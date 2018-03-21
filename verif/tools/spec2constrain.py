#!/usr/bin/env python

import re
import sys
import os
import argparse

__DESCRIPTION__ = '''
=========================================
           # spec2constrain #
=========================================

The tool is used to parse register spec define manual files, and generate
all register fields definitions in constrain components for each sub-module.
Generated codes include fields variable defines, field automation macros( UVM
factory usage) and some enumerate type defines. The usage of defining those 
field variables is to simplify constrain block development.
'''

# ===============
# Script options
# ===============
class ArgsCfg:
    ''' 
    1. get comomoand line arguments
    2. set imported moudle path
    ''' 

    def __init__(self):
        self._args = {}
        self._ref_tot_path = '.'

    def get_ref_tot_path(self):
        tot_marker = os.path.join(self._ref_tot_path, 'LICENSE')
        if os.path.isfile(tot_marker) is False:
            self._ref_tot_path = os.path.join('..', self._ref_tot_path) 
            self._ref_tot_path = self.get_ref_tot_path()
        return self._ref_tot_path

    def set_module_path(self, project):
        self.get_ref_tot_path()
        manual_path     = os.path.join(self._ref_tot_path, 'outdir', project, 'spec/manual')
        sys.path.append(manual_path)

    def get_args(self):
        parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description=__DESCRIPTION__)
        parser.add_argument('-b', '--block',   dest='block',   type=str, required=True, nargs='+', help='specify block name')
        parser.add_argument('-t', '--type',    dest='type',    type=str, required=True, choices=['enum','state','macro','ral'], help='specify gen_codes type')
        parser.add_argument('-p', '--project', dest='project', type=str, required=True, help='Specify project name')
        self._args = vars(parser.parse_args())
        return self._args


# ===================
# CLASS: Spec2Cons
# ===================
class Spec2Cons:
    ''' define function to parser spec file for generating needed codes'''

    def __init__(self):
        self._dla_regs = {}
        import opendla
        self._dla_regs   = opendla.registers
        self._black_list = ['OP_EN','PRODUCER','r','c']

    def state_gen(self, blocks, prefix='', is_random=True):
        fld_list = []
        for blk in blocks:
            for reg in self._dla_regs[blk]['register_list']:
                for item in self._dla_regs[blk][reg]['field_list']:
                    if item not in fld_list:
                        field = self._dla_regs[blk][reg][item]
                        if (field['action'] not in self._black_list) and (item not in self._black_list): 
                            if len(field['enums']) != 0:
                                str0 = item.lower()+'_t'
                            else:
                                str0 = 'bit ['+str(field['size']-1)+':0]'
                            if is_random:
                                str0 = '    rand '+str0
                            else:
                                str0 = '    '+str0
                            print("%-35s %0s%0s;" % (str0, prefix, item.lower()))
                    fld_list.append(item)

    def enum_gen(self, blocks):
        fld_list = []
        for blk in blocks:
            for reg in self._dla_regs[blk]['register_list']:
                for item in self._dla_regs[blk][reg]['field_list']:
                    if item not in fld_list:
                        field = self._dla_regs[blk][reg][item]
                        if (field['action'] not in self._black_list) and (item not in self._black_list): 
                            if len(field['enums']) != 0:
                                reverse = {}
                                for key in field['enums']:
                                    reverse[field['enums'][key]] = key
                                keys = sorted(reverse.keys())
                                for idx in range(len(keys)):
                                    if idx==0:
                                        str0 = '    typedef enum{ '+item.lower()+'_'+reverse[keys[idx]]
                                    else:
                                        str0 = '                 ,'+item.lower()+'_'+reverse[keys[idx]]
                                    print('%-50s = \'h%0x' % (str0,keys[idx]))
                                str1 = '                } '+item.lower()+'_t;'
                                print(str1)
                    fld_list.append(item)

    def macro_gen(self, blocks):
        fld_list = []
        for blk in blocks:
            for reg in self._dla_regs[blk]['register_list']:
                for item in self._dla_regs[blk][reg]['field_list']:
                    if item not in fld_list:
                        field = self._dla_regs[blk][reg][item]
                        if (field['action'] not in self._black_list) and (item not in self._black_list): 
                            if len(field['enums']) != 0:
                                str0 = '        `uvm_field_enum('+item.lower()+'_t,'
                                str1 = item.lower()+','
                                print("%-50s%-20s UVM_ALL_ON)" % (str0, str1))
                            else:
                                str0 = '        `uvm_field_int('+item.lower()+','
                                print("%-70s UVM_ALL_ON)" % str0)
                    fld_list.append(item)

    def ral_set(self, blocks):
        for blk in blocks:
            for reg in self._dla_regs[blk]['register_list']:
                for item in self._dla_regs[blk][reg]['field_list']:
                    field = self._dla_regs[blk][reg][item]
                    if (field['action'] not in self._black_list) and (item not in self._black_list): 
                        # FIXME no '_0' suffix in ral register names
                        str0 = '.'.join(['    ral.nvdla',blk,reg[:-2],item,'set('])
                        str1 = ' '+item.lower()+');'
                        print('%-80s%0s' % (str0, str1))


if __name__ == '__main__':
    args_cfg = ArgsCfg()
    args = args_cfg.get_args()
    args_cfg.set_module_path(args['project'])
    spec2cons = Spec2Cons()
    if args['type'] == 'state':
        spec2cons.state_gen(args['block'])
    elif args['type'] == 'macro':
        spec2cons.macro_gen(args['block'])
    elif args['type'] == 'enum':
        spec2cons.enum_gen(args['block'])
    elif args['type'] == 'ral':
        spec2cons.ral_set(args['block'])
