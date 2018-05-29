#!/usr/bin/env python

import argparse
import re
import os
from pprint import pprint
__DESCRIPTION__='''
    1. Read in trace file
    2. Generated file for trace parser to dispatch to other component
'''
class TraceParser(object):
    re_comment = re.compile(r'^\s*(\/\/).*$')
    re_empty_line   = re.compile(r'^\s*$')
    re_sequence_command = re.compile(r'^\s*(?P<kind>(reg_write|reg_read_check|reg_read))\s*\(\s*(?P<name>[\w\.]+)\s*,\s*(?P<value>(\w+|\d+|0x[0-9a-fA-F]+))\s*\)\s*;\s*(\/\/.*)*$')
    re_sequence_command_read_write      = re.compile(r'^\s*reg_(?P<kind>(write|read_check))\s*\(\s*(?P<name>[\w\.]+)\s*,\s*(?P<value>(\w+|\d+|0x[0-9a-fA-F]+))\s*\)\s*;\s*(\/\/.*)*$')
    re_sequence_command_read_to_value   = re.compile(r'^\s*reg_(?P<kind>read)\s*\(\s*(?P<name>[\w\.]+)\s*,\s*(?P<value>(\w+|\d+|0x[0-9a-fA-F]+))\s*\)\s*;\s*(\/\/.*)*$')
    re_sequence_command_event           = re.compile(r'^\s*sync_(?P<kind>(notify|wait))\s*\(\s*(?P<name>[\w\.]+)\s*,\s*(?P<value>(\w+|\d+|0x[0-9a-fA-F]+))\s*\)\s*;\s*(\/\/.*)*$')
    re_interrupt_handler_command        = re.compile(r'^\s*intr_notify\s*\(\s*((?P<intr_id>\w+)\s*,\s*)?(?P<sync_id>\w+)\s*\)\s*;\s*(\/\/.*)*$')
    #re_result_checker_command           = re.compile(r'^\s*(?P<kind>(check_crc|check_file|check_nothing))\s*\(\s*(?P<sync_id>\w+)\s*,\s*(?P<memory_type>\w+)\s*,\s*(?P<base_addr>0x[0-9a-fA-F]+)\s*,\s*(?P<size>0x[0-9a-fA-F]+)\s*,\s*(?P<golden_crc>0x[0-9a-fA-F]+)\s*\)\s*;\s*(\/\/)*$')
    re_result_checker_command           = re.compile(r'^\s*(?P<kind>(check_crc|check_file|check_nothing))\s*\(\s*(?P<sync_id>\w+)\s*(,\s*(?P<memory_type>\w+)\s*,\s*(?P<base_addr>0x[0-9a-fA-F]+)\s*,\s*(?P<size>(0x[0-9a-fA-F]+)|(\d+))\s*,\s*((?P<golden_crc>0x[0-9a-fA-F]+)|"(?P<golden_file_path>[\w\.\/]+)")\s*)?\)\s*;\s*(\/\/.*)*$')

    re_memory_model_command = re.compile(r'''
        ^
        \s*(?P<kind>(mem_reserve|mem_load|mem_init|mem_release))\s*
        \(
        \s*(?P<memory_type>\w+)\s*,
        \s*(?P<base_addr>0x[0-9a-fA-F]+)\s*,
        \s*( "(?P<file_path>[\w\.\/]+)" | (?P<size>(0x[0-9a-fA-F]+)|(\d+)) | (?P<release_sync_id>\w+) )\s*
        (,\s*(?P<pattern>[A-Z_]+)\s*)?
        (,\s*(?P<reserve_load_init_sync_id>\w+)\s*)?
        \)\s*;
        \s*(\/\/.*)*
        $
    ''', re.VERBOSE)
    re_sequence_command_poll_reg        = re.compile(r'^\s*(?P<kind>poll_reg_equal)\s*\(\s*(?P<name>[\w\.]+)\s*,\s*(?P<value>(\w+|\d+|0x[0-9a-fA-F]+))\s*\)\s*;\s*(\/\/.*)*$')
    
    #mem_load ( sec_mem, 0x8000, "python/over/perl.dat"); 
    #mem_init ( pri_mem, 0x2000, "python/over/perl.dat", RANDOM);
    #mem_init ( sec_mem, 0x5000, 0x2000, ALL_ZERO); 

    def load_trace_file(self, test_dict):
        self.trace_file_path = test_dict

    #------------------------------------------------------------------------------------------------------
    #         | kind         | block_name   | reg_name  | field_name    |  data               | sync_id
    #         | WRITE        |   block_name |  reg_name |  N.A          |    data             |   N.A
    #         | READ_CHECK   |   block_name |  reg_name |  N.A          |    expected data    |   N.A
    #         | READ         |   block_name |  reg_name |  N.A          |    N.A              |   sync_id
    #         | NOTIFY       |   block_name |  N.A      |  N.A          |    N.A              |   sync_id
    #         | WAIT         |   block_name |  N.A      |  N.A          |    N.A              |   sync_id
    #         | POLL_REG_*   |   block_name |  reg_name |  N.A          |    expected data    |   N.A
    #         | POLL_FIELD_* |   block_name |  reg_name |  field_name   |    expected data    |   N.A
    #------------------------------------------------------------------------------------------------------
    #--------------------------------------------------
    # kind         |  interrupt_id     | sync_id
    # SINGLE_SHOT  |     N.A           |  sync_id
    # MULTI_SHOT   |  sequence_id      |  sync_id
    #--------------------------------------------------
    #def gen_sequence_command(self):
    #    for pre_process_method in pre_process_method_list:
    #        pre_process_method()

    def is_sequence_command(self, string):
        pass

    def do_parsing(self):
        trace_dir = os.path.dirname(self.trace_file_path)
        f_trace = open (self.trace_file_path, 'r')
        f_seq_cmd = open ('trace_parser_cmd_sequence_command.log', 'w')
        f_ic_cmd  = open ('trace_parser_cmd_interrupt_controller_command.log', 'w')
        f_rc_cmd  = open ('trace_parser_cmd_result_checker_command.log', 'w')
        f_mm_cmd  = open ('trace_parser_cmd_memory_model_command.log', 'w')
        for line in f_trace:
            print ("line:" + line.rstrip())
            m = self.re_empty_line.match(line)
            if m:
                continue
            m = self.re_comment.match(line)
            if m:
                continue
            m = self.re_sequence_command_read_write.match(line)
            if m:
                print (m.groupdict())
                ####            kind block_name&reg_name field_name data sync_id
                f_seq_cmd.write("%s %s NA %X NA\n" % ( m.group('kind').upper(), ' '.join(m.group('name').split('.')), int(m.group('value'),0) ) )
                continue
            m = self.re_sequence_command_read_to_value.match(line)
            if m:
                print (m.groupdict())
                ####            kind block_name&reg_name field_name data sync_id
                f_seq_cmd.write("%s %s NA NA %s\n" % ( m.group('kind').upper(), ' '.join(m.group('name').split('.')), m.group('value') ) )
                continue
            m = self.re_sequence_command_event.match(line)
            if m:
                print (m.groupdict())
                ####            kind block_name reg_name field_name data sync_id
                f_seq_cmd.write("%s %s NA NA 0 %s\n" % (m.group('kind').upper(), ' '.join(m.group('name').split('.')), m.group('value')))
                continue
            m = self.re_interrupt_handler_command.match(line)
            if m:
                print (m.groupdict())
                if m.group('intr_id') is not None:
                    f_ic_cmd.write("MULTI_SHOT %s %s\n" % (m.group('intr_id').upper(), m.group('sync_id')))
                else:
                    f_ic_cmd.write("SINGLE_SHOT NA %s\n" % (m.group('sync_id')))
                continue
            #--------------------------------------------------
            # kind             | sync_id   | memory_type   | base_addr     | size  | crc   | file_path
            # CHECK_NOTHING    |  sync_id  |  N.A          |  N.A          |  N.A  |  N.A  |  N.A
            # CHECK_CRC        |  sync_id  |  memory_type  |  base_addr    |  size | crc   |  N.A
            # CHECK_FILE       |  sync_id  |  memory_type  |  base_addr    |  size |  N.A  | file_path
            #--------------------------------------------------
            #check_crc(sync_id_0, pri_mem, 0x80100000, 0x1000, 0x33d91a71);
            m = self.re_result_checker_command.match(line)
            if m:
                print (m.groupdict())
                if "check_nothing" == m.group('kind').lower():
                    f_rc_cmd.write("%s %s NA 0 0 0 NA\n" % (m.group('kind').upper(), m.group('sync_id')))
                elif "check_crc" == m.group('kind').lower():
                    f_rc_cmd.write("%s %s %s %X %X %X NA\n" % (m.group('kind').upper(), m.group('sync_id'), m.group('memory_type').upper(), int(m.group('base_addr'),0), int(m.group('size'),0), int(m.group('golden_crc'),0) ))
                elif "check_file" == m.group('kind').lower():
                    f_rc_cmd.write("%s %s %s %X %X 0 %s\n" % (m.group('kind').upper(), m.group('sync_id'), m.group('memory_type').upper(), int(m.group('base_addr'),0), int(m.group('size'),0), os.path.join(trace_dir, m.group('golden_file_path')) ))
                continue

            ## Memory model
            m = self.re_memory_model_command.match(line)
            if m:
                print (m.groupdict())
                # kind | memory_type | base_addr | size | pattern | file_path | sync_id
                format_str = "%(kind)s %(memory_type)s %(base_addr)X %(size)X %(pattern)s %(file_path)s %(sync_id)s\n"
                if "mem_reserve" == m.group('kind').lower():
                    ## Initialize memory from file
                    f_mm_cmd.write(format_str % {
                        'kind'        : m.group('kind').upper(),
                        'memory_type' : m.group('memory_type').upper(),
                        'base_addr'   : int(m.group('base_addr'),0),
                        'size'        : int(m.group('size'),0),
                        'pattern'     : 'NA',
                        'file_path'   : 'NA',
                        'sync_id'     : m.group('reserve_load_init_sync_id') if m.group('reserve_load_init_sync_id') is not None else ''
                    })
                elif "mem_load" == m.group('kind').lower():
                    ## Initialize memory from file
                    f_mm_cmd.write(format_str % {
                        'kind'        : m.group('kind').upper(),
                        'memory_type' : m.group('memory_type').upper(),
                        'base_addr'   : int(m.group('base_addr'),0),
                        'size'        : 0,
                        'pattern'     : 'NA',
                        'file_path'   : os.path.join(trace_dir, m.group('file_path')),
                        'sync_id'     : m.group('reserve_load_init_sync_id') if m.group('reserve_load_init_sync_id') is not None else ''
                    })
                elif "mem_init" == m.group('kind').lower():
                    if m.group('size') is not None:
                        ## Initialize memory with pattern and size
                        f_mm_cmd.write(format_str % {
                            'kind'        : 'MEM_INIT_PATTERN',
                            'memory_type' : m.group('memory_type').upper(),
                            'base_addr'   : int(m.group('base_addr'),0),
                            'size'        : int(m.group('size'),0),
                            'pattern'     : m.group('pattern'),
                            'file_path'   : 'NA',
                            'sync_id'     : m.group('reserve_load_init_sync_id') if m.group('reserve_load_init_sync_id') is not None else ''
                        })
                    else:
                        ## Initialize memory with pattern and offset from file
                        f_mm_cmd.write(format_str % {
                            'kind'        : 'MEM_INIT_FILE',
                            'memory_type' : m.group('memory_type').upper(),
                            'base_addr'   : int(m.group('base_addr'),0),
                            'size'        : 0,
                            'pattern'     : m.group('pattern'),
                            'file_path'   : os.path.join(trace_dir, m.group('file_path')),
                            'sync_id'     : m.group('reserve_load_init_sync_id') if m.group('reserve_load_init_sync_id') is not None else ''
                        })
                elif "mem_release" == m.group('kind').lower():
                    ## Release memory
                    f_mm_cmd.write(format_str % {
                        'kind'        : 'MEM_RELEASE',
                        'memory_type' : m.group('memory_type').upper(),
                        'base_addr'   : int(m.group('base_addr'),0),
                        'size'        : 0,
                        'pattern'     : 'NA',
                        'file_path'   : 'NA',
                        'sync_id'     : m.group('release_sync_id') if m.group('release_sync_id') is not None else ''
                    })

                continue

            m = self.re_sequence_command_poll_reg.match(line)
            if m:
                print (m.groupdict())
                f_seq_cmd.write("%s %s NA %X NA\n" % ( m.group('kind').upper(), ' '.join(m.group('name').split('.')), int(m.group('value'),0) ) )
                continue
            raise Exception("Unregconized line:\n%s" % line)
        f_seq_cmd.close()
        f_ic_cmd.close()
        f_rc_cmd.close()
        f_mm_cmd.close()
        f_trace.close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__DESCRIPTION__)
    parser.add_argument('--file_path','-f', dest='file_path', required=True,
                        help='Specify trace file path')
    config = vars( parser.parse_args() )
    pprint (config)
    trace_parser = TraceParser()
    trace_parser.load_trace_file(config['file_path'])
    trace_parser.do_parsing()
