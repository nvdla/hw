#!/usr/bin/env python

import os
import sys
import argparse
import shutil
import re
import enum
import time
import fcntl
import nvdla_tb_sim_cfg
from pprint import pprint
from pathlib import Path
import subprocess

__DESCRIPTION__='''
This class is used to run a test:
    1. Run pre simulation processing:
        1. Directory setup
        2. Test preparation, source file generation or copy 
    2. Get regression setting from command line
    3. Generated single test run command
'''
__default_trace_root__ = 'verif/tests'
__uvm_tp_path__ = 'verif/testbench/trace_player'
__uvm_tg_path__ = 'verif/testbench/trace_generator'
__cmod_wrap_lib_path__ = 'verif/vip/reference_model/nvdla_cmod_wrap/release/lib'

class Status(enum.Enum):
    RUNNING = 1
    PASS = 2
    FAILED = 3

class RunTest(object):

    def __init__(self, test_config_dict):
        self._config_dict = {   'project':None,
                                'module':None,
                                'trace_root':None,
                                'trace_dir':None,
                                'output_dir':None,
                                'output_log_name':None,
                                'rtlarg':[],
                                'test_name':None,
                                'testbench':None,
                                'timeout':None,
                                'debug':None,
                                'dump_waveform':None,
                                'seed':None,
                            }
        self._tree_root = self._get_abs_path_to_tree_root()
        self._initial_working_dir = os.getcwd()
        self.load_test_config(test_config_dict)
        self._status = Status.RUNNING

    def _get_ref_path_to_tree_root(self, rel_path_to_tree_root = '.'):
        ## there is a file named LICENSE, it's the marker of tree root
        tree_root_marker_path = os.path.join(rel_path_to_tree_root, 'LICENSE')
        if os.path.isfile(tree_root_marker_path) is False:
            rel_path_to_tree_root = os.path.join('..', rel_path_to_tree_root)
            rel_path_to_tree_root = self._get_ref_path_to_tree_root(rel_path_to_tree_root)
        return rel_path_to_tree_root

    def _get_abs_path_to_tree_root(self):
        return os.path.abspath(self._get_ref_path_to_tree_root())

    def setup_environment(self):
        p = re.compile('^\s*(?P<tool_name>\w+)\s*:=\s*(?P<tool_path>.+)\s*$')
        # Get tree.make
        tree_make_abs_path = os.path.join(self._get_abs_path_to_tree_root(), 'tree.make')
        with open(tree_make_abs_path, 'r') as f:
            tree_make_content = f.readlines()
        #print(tree_make_content)
        # Get tool directories
        tool = dict()
        for line in tree_make_content:
            m = p.match(line)
            if m:
                tool[m.group('tool_name')] = m.group('tool_path')
        # Set system env
        try:
            os.environ["VERDI_HOME"] = tool['VERDI_HOME']
            os.environ["NOVAS_HOME"] = tool['NOVAS_HOME']
            os.environ["VCS_HOME"]   = tool['VCS_HOME']
            self._vcs_lib_path = os.path.join(tool['VCS_HOME'], 'linux64/lib')
        except KeyError as error:
            raise Exception("%s is not defined in tree.make" % error.args[0])

    def load_test_config(self, test_config_dict):
        ## TODO: config validation
        self._config_dict.update(test_config_dict)
        self._name = self._config_dict['test_name']
        if self._config_dict['trace_dir'] is not None:
            self._trace_dir = self._config_dict['trace_dir']
        if self._config_dict['trace_root'] is not None:
            self._trace_root = self._config_dict['trace_root']
        else:
            ## default trace root
            self._trace_root = os.path.join(self._tree_root, __default_trace_root__)
        if self._config_dict['output_dir'] is not None:
            if not os.path.exists(self._config_dict['output_dir']):
                os.makedirs(self._config_dict['output_dir'])
            self._output_dir = os.path.abspath(self._config_dict['output_dir'])
        else:
            self._output_dir = self._initial_working_dir
        self._project = self._config_dict['project']
        self._testbench = self._config_dict['testbench']
        self._output_log = self._config_dict['output_log']
        self._rtlarg = self._config_dict['rtlarg']
        self._timeout = self._config_dict['timeout']
        self._dump_waveform = self._config_dict['dump_waveform']
        self._dump_memory = self._config_dict['dump_memory']

    def _python_test_pre_process(self):
        origin_dir = os.getcwd()
        dst_test_dir_path = Path(self._output_dir, self._name)
        if dst_test_dir_path.is_dir():
            shutil.rmtree(dst_test_dir_path)
        os.mkdir(dst_test_dir_path)
        os.chdir(dst_test_dir_path)
        test_path = Path(self._tree_root)
        test_file_name = self._name+'.py'
        if self._config_dict['trace_dir'] is not None:
            ## Trace dir has been specified
            test_path = test_path / 'verif/tests/nvdla_test' / test_file_name
        elif '_trace_root' in dir(self):
            ## Trace root has been specified
            try:
                test_path = list(Path(self._trace_root).glob('**/'+test_file_name))[0]
            except:
                raise Exception('RunTest::_python_test_pre_process', 'Cannot found test %s under path %s' % (test_file_name, self._trace_root))
        print ("Test path is %s" % test_path)
        # check file existence
        if not test_path.is_file():
            raise Exception('RunTest::_python_test_pre_process', 'test path %s is not a valid file path' % test_path)
        # generate trace dumper script
        script = './run_trace_generator.sh'
        with open(script, '+w') as cmd_fh:
            python_interpreter = sys.executable
            cmd = ' '.join([python_interpreter, str(test_path), self._project, self._output_dir])
            cmd_fh.write ('\n'.join(['#!/bin/sh\n', cmd]))
        subprocess.call('chmod 755 '+script, shell=True)
        print("Start dumping trace file './%s/%s.cfg':\n  cmd = %s" % (self._name, self._name, cmd))
        # Generate trace
        try:
            subprocess.call(script, shell=True)
        except OSError:
            raise Exception('RunTest::_python_test_pre_process', 'Failed to generate trace file')
        os.chdir(origin_dir)

    def _trace_test_pre_process(self):
        test_path = ''
        test_dir_name = self._name
        if '_trace_dir' in dir(self):
            test_path = os.path.join(self._trace_dir, test_dir_name)
        elif '_trace_root' in dir(self):
            ## Trace root has been specified
            for root, dirs, files in os.walk(self._trace_root):
                if (self._name in dirs) and (os.path.basename(root) == self._project):
                    self._trace_dir = root
                    test_path = os.path.join(root, test_dir_name)
                    break
            if 0 == len(test_path):
                raise Exception('RunTest::_trace_test_pre_process', 'Cannot found test directory %s under path %s' % (test_dir_name, self._trace_root))
        if os.path.isdir(test_path) is False:
            raise Exception('RunTest::_trace_test_pre_process', 'test path %s is not a valid directory path' % test_path)
        dst_test_dir_path = os.path.join(self._output_dir, test_dir_name)
        try:
            shutil.rmtree(dst_test_dir_path)
        except OSError:
            if os.path.exists(dst_test_dir_path):
                raise Exception("RunTest::_trace_test_pre_process", "Fail to remove trace direct: %s, may be some one is editing it." % dst_test_dir_path)
            # No trace test is current directory
            pass
        try:
            shutil.copytree(test_path, dst_test_dir_path)
        except OSError:
            raise Exception("RunTest::_trace_test_pre_process", "Fail to copy trace test from original place to current working directory.")

    def _uvm_test_pre_process(self):
        original_osenv_run_path = os.environ.get('PATH',"")
        stored_dir = os.getcwd()
        dst_test_dir_path = os.path.join(self._output_dir, self._name)
        if os.path.isdir(dst_test_dir_path):
            shutil.rmtree(dst_test_dir_path)
        os.mkdir(dst_test_dir_path)
        os.chdir(dst_test_dir_path)

        self.create_status_file()

        # Dump trace file under trace_generator TB
        simv_exe = os.path.join(self._tree_root, 'outdir', self._project, __uvm_tg_path__, 'simv')
        if os.path.isfile(simv_exe) is False:
            raise Exception('RunTest::_uvm_test_pre_process', 'simv %s is not a valid file path' % simv_exe)
        simv_args = ' -l testout +UVM_TESTNAME=%s ' % (self._name)
        if self._rtlarg is not None:
            simv_args += ' ' + ' '.join(self._rtlarg)
        simv_cmd  = simv_exe + simv_args
        added_run_path = os.path.join(self._tree_root, 'verif/tools/surface_generator')
        os.environ['PATH'] = os.pathsep.join([added_run_path, original_osenv_run_path])
        # generate trace dumper script
        script = './run_trace_generator.sh'
        cmd_fh = open(script, '+w')
        cmd_fh.write('#!/bin/sh\n\n')
        cmd_fh.write("export VCS_HOME=%s\n\n" % os.environ['VCS_HOME'])
        cmd_fh.write("export PATH=%s\n\n" % os.environ['PATH'])
        cmd_fh.write(simv_cmd+'\n')
        cmd_fh.close()
        subprocess.call('chmod 755 '+script, shell=True)
        print("Start dumping trace file './%s/%s.cfg':\n  cmd = %s" % (self._name, self._name, simv_cmd))
        # run trace dumper
        try:
            subprocess.call(script, shell=True)
        except OSError:
            raise Exception('RunTest::_uvm_test_pre_prcess', 'Failed to generate trace file')
        # check result
        self.run_post_process('./testout', quiet=0)
        if self._status != Status.PASS:
            os.chdir(self._output_dir)
            shutil.copyfile(os.path.join(dst_test_dir_path, 'testout'), os.path.join(self._output_dir,self._output_log))
            self.remove_status_file()
            with open('FAIL','w') as f_fh:
                f_fh.write('Trace Generator Failed')
            with open('STATUS','w') as status_fh:
                status_fh.write('FAIL')
            raise Exception('RunTest::_uvm_test_pre_prcess', 'Failed to generate trace file')
        os.chdir(stored_dir)

    def run_pre_process(self):
        #print ("File path of run_test.py is %s" % os.path.abspath(__file__) )
        print ("\nTree root path is %s\n" % self._tree_root)
        ## Use for test preparation, search tests in default directory
        ## For Python tests, trace generation shall be performed in this phase
        ## For Trace tests, trace shall be copied to run directory
        ## For UVM tests, trace shall be dumped under run directory
        if ('nvdla_python_test' == self._config_dict['module']):
            self._python_test_pre_process()
        elif 'nvdla_uvm_test' == self._config_dict['module']:
            self._uvm_test_pre_process()
        elif 'nvdla_trace_test' == self._config_dict['module']:
            self._trace_test_pre_process()
        else:
            raise Exception('RunTest::run_pre_process', 'Invalid module: %s, valids are: nvdla_python_test, nvdla_trace_test, nvdla_uvm_test'%self._config_dict['module'])
        self._trace_test_dir_path = os.path.join(self._output_dir, self._name)
        self._trace_test_cfg_path = os.path.join(self._trace_test_dir_path, self._name+'.cfg')

    def run_simulation(self):
        ## Use for simulations: RTL simulation, CMOD simulation and etc
        if 'nvdla_utb' == self._testbench:
            if self._config_dict['dump_trace_only']:
                return
            else:
                self.run_uvm_tb_simulation()
        elif 'nvdla_ctb' == self._testbench:
            ## Reserved for cmod verification
            raise Exception('RunTest::run_simulation', 'nvdla_ctb is not ready yet')
        else:
            msg = 'Unknown testbench name: ' + self._testbench + ' Valid are: nvdla_utb.'
            raise Exception('RunTest::run_simulation', msg)

    def run_uvm_tb_simulation(self):
        # set environment variable
        original_osenv_ld_path = os.environ.get('LD_LIBRARY_PATH',"")
        original_osenv_run_path = os.environ.get('PATH',"")
        added_ld_path1 = os.path.join(self._tree_root, 'outdir', self._project, __cmod_wrap_lib_path__)
        added_ld_path2 = self._vcs_lib_path
        added_run_path = os.path.join(self._tree_root, 'verif/tools')
        os.environ['LD_LIBRARY_PATH'] = os.pathsep.join([added_ld_path1, added_ld_path2, original_osenv_ld_path])
        os.environ['PATH'] = os.pathsep.join([added_run_path, original_osenv_run_path])

        # set cmd
        simv_exe = os.path.join(self._tree_root, 'outdir', self._project, __uvm_tp_path__, 'simv')
        if os.path.isfile(simv_exe) is False:
            raise Exception('RunTest::run_uvm_tb_simulation', 'simv %s is not a valid file path' % simv_exe)
        simv_args = ' -l ' + self._output_log
        if self._dump_waveform:
            simv_args += ' +wave'
        if self._dump_memory:
            simv_args += ' +uvm_set_config_int=*,auto_dump_surface,1'
        if self._config_dict['nvdla_utb_work_mode'] is not None:
            simv_args += ' +WORK_MODE=' + self._config_dict['nvdla_utb_work_mode'].upper()
        simv_args += ' +UVM_MAX_QUIT_COUNT=1'
        simv_args += ' +uvm_set_action=*,UVM/COMP/NAME,UVM_WARNING,UVM_NO_ACTION'
        simv_args += ' +uvm_set_action=*,UVM/RSRC/NOREGEX,UVM_WARNING,UVM_NO_ACTION'
        simv_args += ' +uvm_set_config_string=*,trace_file_path,' + self._trace_test_cfg_path
        if self._rtlarg is not None:
            simv_args += ' ' + ' '.join(self._rtlarg)
        if self._config_dict['debug']:
            simv_args += nvdla_tb_sim_cfg.arg_gen() 
        simv_cmd = simv_exe + simv_args

        # generate trace player script
        script = './run_trace_player.sh'
        cmd_fh = open(script, '+w')
        cmd_fh.write('#!/bin/sh\n\n')
        cmd_fh.write("export VCS_HOME=%s\n\n" % os.environ['VCS_HOME'])
        cmd_fh.write("export VERDI_HOME=%s\n\n" % os.environ['VERDI_HOME'])
        cmd_fh.write("export NOVAS_HOME=%s\n\n" % os.environ['NOVAS_HOME'])
        cmd_fh.write("export LD_LIBRARY_PATH=%s\n\n" % os.environ['LD_LIBRARY_PATH'])
        cmd_fh.write("export PATH=%s\n\n" % os.environ['PATH'])
        cmd_fh.write(simv_cmd+'\n')
        cmd_fh.close()
        subprocess.call('chmod 755 '+script, shell=True)

        # copy run_verdi.sh from outdir to running dir
        run_verdi_src_path = os.path.join(os.path.dirname(simv_exe), 'run_verdi.sh')
        shutil.copy(run_verdi_src_path, self._output_dir)

        # run cmd
        print ("Start running simulation: cmd = %s\n" % script)
        try:
            subprocess.run(script, timeout=60*self._timeout, shell=False)
        except subprocess.TimeoutExpired:
            msg = "\n** ERROR **: run_test.py: Job timeout after %0d minutes running. Please specify a bigger value through option '-timeout <N>'" % self._timeout
            with open(self._output_log, 'a') as fh:
                fh.write(msg)
            print(msg)
            self._status = Status.FAILED

        print ("Simulation finished.")

        # restore environment variable
        os.environ['LD_LIBRARY_PATH'] = original_osenv_ld_path
        os.environ['PATH'] = original_osenv_run_path
    
    def run_post_process(self, log_fname, quiet=0):
        ## Use for post processing on simulation result, log analysis and etc
        BIG_PASS = '''
PPPP     A     SSSSS  SSSSS
P   P   A A    S      S
PPPP   AAAAA   SSSSS  SSSSS
P     A     A      S      S
P     A     A  SSSSS  SSSSS

'''

        BIG_FAIL = '''
FFFFF    A     IIIII  L
F       A A      I    L
FFFF   AAAAA     I    L
F     A     A    I    L
F     A     A  IIIII  LLLLL

'''

        SMALL_PASS = '''
*******************************
**        TEST PASS          **
*******************************
'''

        SMALL_FAIL = '''
*******************************
**        TEST FAILED        **
*******************************
'''
        print ("Parse simulation log ...")

        pass_keywords = ['TEST PASS', 'SIMULATION PASS', 'TRACE GENERATION PASS']
        fail_keywords = ['error', 'fail', 'fatal']
        ignore_keywords = ['UVM_ERROR :    0', 'UVM_FATAL :    0', 'Failed to load FSDB dumper',
                           'Number of demoted UVM_ERROR reports', 'Number of caught UVM_ERROR reports',
                           'Number of demoted UVM_FATAL reports', 'Number of caught UVM_FATAL reports',
                           'is_response_error',
                           ]
        pass_pattern = '|'.join(pass_keywords)
        fail_pattern = '|'.join(fail_keywords)
        ignore_pattern = '|'.join(ignore_keywords)

        fail_syndrome = ''

        log_fh = open(log_fname, "r+")
        log_fh.flush()
        os.fsync(log_fh.fileno())
        for index, line in enumerate(log_fh):
            if re.search(fail_pattern, line, re.IGNORECASE):
                if (re.search(ignore_pattern, line)):
                    continue
                else:
                    fail_syndrome = line
                    self._status = Status.FAILED
                    break
            elif re.search(pass_pattern, line, re.IGNORECASE):
                self._status = Status.PASS

        # only update status, don't print status and generate status file
        # when parsing trace dumper log
        if quiet:
            log_fh.close()
            return

        log_fh.seek(0, 2) # move file pointer to the end of file
        if self._status == Status.FAILED:
            print (SMALL_FAIL)
            print (BIG_FAIL)
            log_fh.write(SMALL_FAIL)
            log_fh.write(BIG_FAIL)
        elif self._status == Status.PASS:
            print (SMALL_PASS)
            print (BIG_PASS)
            log_fh.write(SMALL_PASS)
            log_fh.write(BIG_PASS)
        # make sure file contents in internal buffer have been writtern to disk
        log_fh.flush()
        os.fsync(log_fh.fileno())
        # run_plan assumes fail syndrome is put in the last line
        log_fh.write(fail_syndrome)
        log_fh.close()
        self.remove_status_file()
        self.create_status_file()

    def remove_status_file(self):
        if os.path.exists("FAIL"):
            os.remove("FAIL")
        if os.path.exists("PASS"):
            os.remove("PASS")
        if os.path.exists("RUNNING"):
            os.remove("RUNNING")
        if os.path.exists("STATUS"):
            os.remove("STATUS")

    def create_status_file(self):
        sum_status_fh = open("STATUS", "w")
        if self._status == Status.FAILED:
            status_fh = open("FAIL", "w")
            status_fh.close()
            sum_status_fh.write("FAIL")
        elif self._status == Status.PASS:
            status_fh = open("PASS", "w")
            status_fh.close()
            sum_status_fh.write("PASS")
        else:
            status_fh = open("RUNNING", "w")
            status_fh.close()
            sum_status_fh.write("RUNNING")
        sum_status_fh.close()

    def run_test(self):
        self.setup_environment()
        os.chdir(self._output_dir)
        self.remove_status_file()
        self.create_status_file()
        self.run_pre_process()
        if not self._config_dict['dump_trace_only']:
            self.run_simulation()
            self.run_post_process(self._output_log)
        os.chdir(self._initial_working_dir)
        return self._status == Status.PASS

if __name__ == '__main__':
    ## run_test.py -P nv_large sdp_passthrough_8x8x32_pack_inc_int8 -v nvdla_utb
    parser = argparse.ArgumentParser(description=__DESCRIPTION__)
    parser.add_argument('--project','-P', dest='project', required=True,
                        help='Specify project name')
    parser.add_argument('--module', '-mod', dest='module', required=False, default='nvdla_trace_test',
                        help='Specify module: nvdla_python_test, nvdla_uvm_test, nvdla_trace_test')
    parser.add_argument('--traceRoot', '-traceRoot', dest='trace_root', required=False,
                        help='Specify a directory which is in high hierarchy of the test source directory')
    parser.add_argument('--traces', '-traces', dest='trace_dir', required=False,
                        help='Specify test source directory')
    parser.add_argument('--output', '-o', dest='output_log', required=False, default='testout', 
                        help='Specify output log name')
    parser.add_argument('--outdir', '-outdir', dest='output_dir', required=False,
                        help='Specify output directory name, temperal files and logs will be redirect to this directory')
    parser.add_argument('--rtlarg', '-rtlarg', dest='rtlarg', required=False, action='append',
                        help='Specify rtlarg, verilog plusargs will be wrapped into RTL arg, -rtlarg "+PLUS_ARG_NAME=PLUS_ARG_VALUE"')
    parser.add_argument('test_name', metavar='test_name', type=str,
                        help='Specify test name')
    parser.add_argument('--testbench','-tb','-v', dest='testbench', required=True,
                        help='Specify test bench name')
    parser.add_argument('--nvdla_utb_work_mode','-uwm', dest='nvdla_utb_work_mode', required=False,
                        help='Specify uvm test bench work mode, only effective when testbench is nvdla_utb')
    parser.add_argument('--timeout', '-timeout', dest='timeout', type=int, default=1440, required=False,
                        help='Specify job running timeout value in minutes')
    parser.add_argument('--waves','--wave','-waves','-wave', dest='dump_waveform', action='store_true', default=False, required=False,
                        help='Dump waveform')
    parser.add_argument('--dump_memory','-dump_mem', dest='dump_memory', action='store_true', default=False, required=False,
                        help='Dump memory content in the end of simulation')
    parser.add_argument('--dump_trace_only','-dump_trace_only', dest='dump_trace_only', action='store_true', default=False, required=False,
                        help='Dump trace file only, do not run trace player, only used for uvm_random_test')
    parser.add_argument('--debug','-debug', dest='debug', action='store_true', default=False, required=False,
                        help='Enter into debug config setting process')
    config = vars( parser.parse_args() )
    pprint (config)
    run_test = RunTest(config)
    ok = run_test.run_test()
    if ok:
        sys.exit(0)
    else:
        sys.exit(1)

