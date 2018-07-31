#!/usr/bin/env python

import os
import imp
import argparse
import subprocess
import time
import sys
import random
import json
import re
from pprint      import pprint
from datetime    import datetime
from collections import OrderedDict
from testplan    import TestPlan
from run_report  import RunReport
from lsf_monitor import LSFMonitor

__DESCRIPTION__='''
This class is used to run a batch of tests from a givin test plan:
    1. Get test plan from command line
    2. Get regression setting from command line
    3. Generated single test run command
    4. Test selection example:
        Tests:
    #######################################################
    ## Test Name # Tag                                   ##
    ## ------------------------------------------------- ##
    ##  cc_0    |   cc, sdp, sanity, release
    ## ------------------------------------------------- ##
    ##  sdp_0   |    sdp, sanity
    ## ------------------------------------------------- ##
    ##  pdp_0   |    pdp, sanity
    ## ------------------------------------------------- ##
    ##  cdp_0   |    cdp, sanity
    #######################################################
    --or_tag pdp cdp:  pdp_0 cdp_0
    --and_tag sanity sdp: cc_0, sdp_0
    --and_tag sanity --or_tag sdp pdp: sdp_0 pdp_0
'''
#test_plan = TestPlan()

def get_next_seed():
    seed = random.randint(0, 2000000)
    return seed

def _get_abs_path_to_tree_root():
    return os.path.abspath(_get_ref_path_to_tree_root())

def _get_ref_path_to_tree_root(rel_path_to_tree_root = '.'):
    ## there is a file named LICENSE, it's the marker of tree root
    tree_root_marker_path = os.path.join(rel_path_to_tree_root, 'LICENSE')
    if os.path.isfile(tree_root_marker_path) is False:
        rel_path_to_tree_root = os.path.join('..', rel_path_to_tree_root)
        rel_path_to_tree_root = _get_ref_path_to_tree_root(rel_path_to_tree_root)
    return rel_path_to_tree_root

class RunPlan(object):
    run_test_list = []
    config = {}
    command_list = OrderedDict()

    def __init__(self):
        #self._test_plan = TestPlan()
        self._test_plan_dir = os.path.join(_get_abs_path_to_tree_root(), 'verif/regression/testplans')

    def load_config(self, config):
        #global test_plan
        self.config=dict(config)
        self._test_plan = TestPlan(self.config['project'])
        #print 'runplan::load_config:before, begin'
        #print dir()
        #print globals()
        #print locals()
        #print 'runplan::load_config:before, end'
        class_dict = dict(test_plan=self._test_plan, test_plan_dir=self._test_plan_dir)
        self._test_plan.set_plan_arguments({'LAYER_NUM':self.config['layer_num'], 'RUN_NUM':self.config['run_num']})
        exec(open(os.path.join(self._test_plan_dir,self.config['test_plan'])).read(), globals(), class_dict)
        #print 'runplan::load_config:after, begin'
        #print dir()
        #print globals()
        #print locals()
        #print 'runplan::load_config:after, end'
        #print 'RunPlan:load_config, test_plan full test test:'
        #test_plan.print_full_test_list()
        #pprint (test_plan)
        if '.' == self.config['run_dir']:
            self.config['run_dir'] = os.path.abspath(os.path.splitext(config['test_plan'])[0]+'_'+datetime.now().strftime('%Y-%m-%d_%H-%M-%S'))
        else:
            self.config['run_dir'] = os.path.abspath(self.config['run_dir'])
            if not os.path.exists(self.config['run_dir']):
                os.makedirs(self.config['run_dir'])

    def select_by_tag_method (self, test_dict, **kwargs):
        ##if kwargs is not None:
        ##    for key, value in kwargs.items():
        ##        print key
        ##        print value
        ##print "run_plan::select_by_tag_method, test_dict"
        ##print test_dict
        and_tag_list = kwargs.get('and_tag_list',[])
        or_tag_list  = kwargs.get('or_tag_list',[])
        not_tag_list  = kwargs.get('not_tag_list',[])
        if len(and_tag_list) == 0 and len(or_tag_list) == 0 and len(not_tag_list) == 0:
            #print "run_plan::select_by_tag_method, and_tag_list and or_tag_list are both empty"
            return (1,1)
        if 'tags' in test_dict:
            for tag in not_tag_list:
                if tag in test_dict['tags']:
                    return (0,1)
            for tag in and_tag_list:
                if tag not in test_dict['tags']:
                    return (0,1)
            if len(or_tag_list)== 0:
                return (1,1)
            for tag in or_tag_list:
                if tag in test_dict['tags']:
                    return (1,1)
        return (0,1)

    def update_run_test_list_by_tag(self):
        self.run_test_list = self._test_plan.get_test_list(self.select_by_tag_method, and_tag_list=self.config['and_tag_list'], or_tag_list=self.config['or_tag_list'], not_tag_list=self.config['not_tag_list'])
        if len(self.run_test_list) == 0:
            print("** Error: Empty run test list, please check!")
            exit(1)

    #def update_run_test_list_by_test_bench(self):
    #    self.run_test_list = test_plan.update_test_list(self.select_by_tag_method, and_tag_list=self.config['and_tag_list'], or_tag_list=self.config['or_tag_list'])

    def update_run_test_list_by_name(self):
        if self.config['test_name_pattern']:
            test_name_pattern = self.config['test_name_pattern']
            self.run_test_list = [test_dict for test_dict in self.run_test_list if test_name_pattern in test_dict['name']]

    def print_run_test_list(self):
        pprint(self.run_test_list)

    def gen_run_test_command_list(self):
        for test_dict in self.run_test_list:
            name        = test_dict['name']
            args        = test_dict['args']
            config_list = test_dict['config']
            module      = test_dict['module']
            if test_dict['unwritten']:
                continue
            for config in config_list:
                cmd_exe = os.path.join(_get_abs_path_to_tree_root(), 'verif/tools/run_test.py')
                #print(self.config['rtlarg'])
                rtlargs = ' '.join(list('-rtlarg '+"'"+ item + "'" for item in self.config['rtlarg']))
                #print(rtlargs)
                cmd_args = "-P %(project)s -mod %(module)s -o testout %(args)s -timeout %(timeout)i %(rtlargs)s %(extra_args)s %(name)s -v %(config)s" % {'project':self.config['project'], 'module':module, 'args':' '.join(args), 'config':config, 'name':name, 'timeout':self.config['timeout'], 'rtlargs':rtlargs, 'extra_args':self.config['extra_args']}
                if self.config['dump_waveform']:
                    cmd_args += ' -waves'
                if self.config['dump_trace_only']:
                    cmd_args += ' -dump_trace_only'
                cmd_str = cmd_exe + ' ' + cmd_args
                if config in self.command_list:
                    self.command_list[config].append({name:cmd_str})
                else:
                    self.command_list[config]=[{name:cmd_str}]

    def print_run_test_command_list(self):
        for test_bench in self.command_list:
            for cmd in self.command_list[test_bench]:
                for name,cmd_str in cmd.items():
                    print(cmd_str)

    def generate_run_test_commands(self):
        test_dir_cmd = OrderedDict()
        origin_working_dir = os.getcwd()
        abs_path_of_run_dir = os.path.abspath(self.config['run_dir'])
        python_interpreter = sys.executable
        for test_bench in self.command_list:
            ## Get test name count
            test_name_count = {}
            test_created_count = {}
            # pprint(self.command_list[test_bench])
            # Counting test with same source file
            for cmd in self.command_list[test_bench]:
                for name, cmd_str in cmd.items():
                    if name in test_name_count:
                        test_name_count[name] += 1
                    else:
                        test_name_count[name] = 1
                        test_created_count[name] = 0
            for cmd in self.command_list[test_bench]:
                for name, cmd_str in cmd.items():
                    ## Create test directory
                    if test_name_count[name] == 1:
                        test_dir = os.path.join(abs_path_of_run_dir, test_bench, name)
                    else:
                        test_dir = os.path.join(abs_path_of_run_dir, test_bench, name + '_' +str(test_created_count[name]))
                        test_created_count[name] += 1
                    #print('\ntest_dir is ' + test_dir)
                    if os.path.exists(test_dir):
                        os.remove(test_dir)
                    os.makedirs(test_dir)
                    os.chdir(test_dir)

                    ## Create run_test_cmd
                    cmd_file = name + '.sh'
                    cmd_fh = open(cmd_file, 'w')
                    cmd_fh.write ('\n'.join(['#!/bin/sh\n', python_interpreter+' '+cmd_str+' -outdir %s'%test_dir,'']))
                    cmd_fh.close()
                    subprocess.call('chmod 754 ' + cmd_file, shell=True)
                    test_dir_cmd[test_dir] = cmd_file
        os.chdir(origin_working_dir)
        return test_dir_cmd

    def execute_run_test_commands(self, test_dir_cmd):
        origin_working_dir = os.getcwd()
        lsf_cmd = self.config['lsf_cmd'] 
        for test_dir,cmd_file in test_dir_cmd.items():
            try:
                os.chdir(test_dir)
            except FileNotFoundError as err1:
                print('%0s, wait 3s and retry' % err1)
                time.sleep(3)
                try:
                    os.chdir(test_dir)
                except FileNotFoundError as err2:
                    raise Exception('%0s' % err2)
            cmd = os.path.join(test_dir, cmd_file)
            cmd = ' '.join([lsf_cmd, cmd])
            subprocess.Popen(cmd, shell=True)
            time.sleep(1)
        time.sleep(10)
        os.chdir(origin_working_dir)

    def execute_run_test_commands_with_plrc(self, test_dir_cmd):
        origin_working_dir = os.getcwd()
        lsf_cmd            = self.config['lsf_cmd']
        for test_dir,cmd_file in test_dir_cmd.items():
            try:
                os.chdir(test_dir)
            except FileNotFoundError as err1:
                print('%0s, wait 3s and retry' % err1)
                time.sleep(3)
                try:
                    os.chdir(test_dir)
                except FileNotFoundError as err2:
                    raise Exception('%0s' % err2)

            with open(cmd_file, 'r') as fl:
                cmd_line = fl.readlines()[-1] 
            # use specified lsf_cmd run trace_generator
            cmd_tg = cmd_line.rstrip() + ' -dump_trace_only '
            cmd = ' '.join([lsf_cmd, cmd_tg])
            subprocess.Popen(cmd, shell=True)
            time.sleep(1)
        time.sleep(5)
        print('TraceGenerator jobs submitted Done')

        self._test_dir_plrc = {}
        for test_dir,cmd_file in test_dir_cmd.items():
            os.chdir(test_dir)
            while True:
                if os.path.exists(os.path.join(cmd_file.rstrip('\.sh'),'FAIL')):
                    break
                elif os.path.exists(os.path.join(cmd_file.rstrip('\.sh'),'PASS')):
                    cmd       = os.path.join(test_dir,cmd_file)
                    plrc_path = self.config['plrc_path']
                    plrc_exe  = ' '.join([self.config['plrc_py'], 
                                          os.path.join(plrc_path,'lsf_predict.py')])
                    trace_dir = os.path.join(test_dir,cmd_file.rstrip('\.sh'))
                    plrc_cmd  = f'{plrc_exe} -trace_dir {trace_dir} -model_dir {plrc_path}'
                    info      = subprocess.check_output(plrc_cmd, shell=True)
                    lsf_info  = info.decode('utf-8').rstrip().split('\n')
                    mem_pred  = lsf_info[0].replace('mem_pred:','').rstrip()
                    time_pred = lsf_info[1].replace('time_pred:','').rstrip()
                    lsf_cmd   = lsf_info[2]
                    print(lsf_cmd)
                    cmd       = ' '.join([lsf_cmd, cmd])
                    subprocess.Popen(cmd, shell=True)
                    self._test_dir_plrc[test_dir] = dict(mempred=mem_pred,cpupred=time_pred)
                    time.sleep(1)
                    break
                else:
                    time.sleep(10)
                    continue
        time.sleep(10)
        os.chdir(origin_working_dir)


    def execute_run_test_commands_no_lsf(self, test_dir_cmd):
        pid_list = []
        #print("test_dir_cmd", test_dir_cmd)
        origin_working_dir = os.getcwd()
        for test_dir,cmd_file in test_dir_cmd.items():
            os.chdir(test_dir)
            print('Start running test in test_dir:', test_dir)
            cmd = os.path.join(test_dir, cmd_file)
            if self.config['disable_multi_processing']:
                p = subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL)
            else:
                p = subprocess.Popen(cmd, shell=True, stdout=subprocess.DEVNULL, preexec_fn=os.setpgrp)
                #subprocess.Popen(cmd, shell=True, stdout=subprocess.DEVNULL)
            pid_list.append(p.pid)
            print('Done in test_dir:', test_dir)
            time.sleep(1)
        os.chdir(self.config['run_dir'])
        #print('pid list', pid_list)
        with open('kill_plan.sh','w') as f:
            f.write('\n'.join(list(map(lambda x: "kill -9 "+str(x), pid_list))))
        subprocess.run('chmod 755 kill_plan.sh', shell=True)
        time.sleep(1)
        os.chdir(origin_working_dir)

    def run_plan(self):
        self._test_dir_cmd = self.generate_run_test_commands()
        if not self.config['gen_cmd_only']:
            if self.config['no_lsf']:
                self.execute_run_test_commands_no_lsf(self._test_dir_cmd)
            elif self.config['enable_plrc']:
                self.execute_run_test_commands_with_plrc(self._test_dir_cmd)
            else:
                self.execute_run_test_commands(self._test_dir_cmd)

    def dump_regression_status(self):
        # dump regression status data in JSON fromat
        sts_data                   = {}
        test_list                  = []
        unwritten_test_list        = []
        test_run_multi_time_list   = []
        git_cm_id                  = subprocess.check_output('git log -n 1 --pretty=format:"%H"', shell = True, encoding = 'ascii')
        sts_data['unique_id']      = git_cm_id;
        sts_data['plan_seed']      = self.config['seed']
        sts_data['start_time']     = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
        sts_data['status']         = 'running'
        sts_data['is_official']    = 1
        sts_data['metrics_result'] = {}
        if self.config['dump_trace_only']:
            sts_data['dump_trace_only'] = 'True'
        else:
            sts_data['dump_trace_only'] = 'False'
        if not self.config['no_lsf'] and self.config['lsf_cmd']:
            sts_data['farm_type'] = 'LSF'
        else:
            sts_data['farm_type'] = 'Local'
        for item in self.run_test_list:
            if item['name'] not in test_list:
                test_list.append(item['name']) 
            if all([item['unwritten'] == True, item['name'] not in unwritten_test_list]):
                unwritten_test_list.append(item['name'])
            else:
                test_run_multi_time_list.append(item['name'])
        print('RUN_PLAN: following tests will be run multiple times')
        pprint(test_run_multi_time_list)
        sts_data['metrics_result']['planned_test_number']    = len(test_list)
        sts_data['metrics_result']['unwrittern_test_number'] = len(unwritten_test_list)
        sts_data['metrics_result']['running_test_number']    = len(self._test_dir_cmd)
        sts_data['metrics_result']['passing_rate']           = 0
        sts_data['metrics_result']['code_coverage']          = 0
        sts_data['metrics_result']['functional_coverage']    = 0
        with open(self.config['run_dir']+'/regression_status.json', 'w') as sts_fh:
            json.dump(sts_data, sts_fh, sort_keys=True, indent=4)

    def dump_test_orgz(self):
        test_orgz_data = {}
        test_id = 0
        jobid_list = []
        if not self.config['no_lsf'] and self.config['lsf_cmd']:
            lsf_monitor = LSFMonitor()
        for test_dir,cmd_file in self._test_dir_cmd.items():
            test_orgz_data[test_id] = {}
            test_orgz_data[test_id]['dir'] = test_dir
            test_name = cmd_file[0:-3]
            test_orgz_data[test_id]['name'] = test_name
            if self.config['enable_plrc']:
                test_orgz_data[test_id]['mempred'] = self._test_dir_plrc[test_dir]['mempred']
                test_orgz_data[test_id]['cpupred'] = self._test_dir_plrc[test_dir]['cpupred']
            for item in self.run_test_list:
                if item['name'] == test_name:
                    test_orgz_data[test_id]['tags'] = item['tags']
                    break
            test_orgz_data[test_id]['test_bench'] = 'nvdla_utb'
            if not self.config['no_lsf'] and self.config['lsf_cmd']:
                job_id      = lsf_monitor.get_job_by_name(os.path.join(test_dir,cmd_file))
                jobid_list += job_id
                test_orgz_data[test_id]['job_id'] = int(job_id[0])
            else:
                test_orgz_data[test_id]['job_id'] = ''
            test_id += 1
        with open(self.config['run_dir']+'/test_organization.json', 'w') as test_orgz_fh:
            json.dump(test_orgz_data, test_orgz_fh, sort_keys=True, indent=4)
        if not self.config['no_lsf'] and self.config['lsf_cmd']:
            kill_plan = self.config['run_dir']+'/kill_plan.sh'
            with open(kill_plan, 'w') as fh:
                fh.write('bkill ' + ' '.join([str(x) for x in jobid_list]))
            subprocess.run('chmod 755 '+kill_plan, shell=True)

def main():
    parser = argparse.ArgumentParser(description=__DESCRIPTION__)
    cube_size_list = ['small', 'medium', 'large', 'normal']
    parser.add_argument('--test_plan','-tp', dest='test_plan', required=True,
                        help='Specify test plan file')
    parser.add_argument('--project','-P', dest='project', required=True,
                        help='Specify project name')
    parser.add_argument('--name', '-name', dest='test_name_pattern', required=False, default='',
                        help='Specify test name selection pattern')
    parser.add_argument('--and_tag','-atag', dest='and_tag_list', required=False, nargs='+', action='append',
                        help='Test contains all and_tag will be seleted')
    parser.add_argument('--or_tag','-otag', dest='or_tag_list', required=False, nargs='+', action='append',
                        help='Test contains at least one of the or_tag will be seleted')
    parser.add_argument('--not_tag','-ntag', dest='not_tag_list', required=False, nargs='+', action='append',
                        help='Test contains any one of the not_tag will not be seleted')
    parser.add_argument('--run_dir','-run_dir', dest='run_dir', required=False, default= '.',
                        help='Run test plan under specified directory')
    parser.add_argument('--gen_command_only', '-gen_cmd_only', dest='gen_cmd_only', required=False, action='store_true', default=False,
                        help='Only generated run test command, will not run simulation')
    parser.add_argument('--publish_dir', '-publish_dir', dest = 'publish_dir', required = False,
                        default='',
                        help = 'Specify directory for storing published regression results data report')
    parser.add_argument('--publish', '-publish', dest='publish', required=False, default=False, action='store_true',
                        help = 'Publish regression results data, if enabled, must specify publish_dir')
    parser.add_argument('--monitor', '-monitor', dest='monitor', required=False, action='store_true',
                        help='Monitor regression status until all tests finished')
    parser.add_argument('--monitor_interval', '-monitor_interval', dest='monitor_interval', type=int, required=False, default=30,
                        help = 'Specify monitor interval value in seconds')
    parser.add_argument('--monitor_quiet', '-monitor_quiet', dest='monitor_quiet', required=False, default=False, action='store_true',
                        help='Do not print regression report when monitor (used to wait regression finish)')
    parser.add_argument('--timeout', '-timeout', dest='timeout', type=int, default=1440, required=False,
                        help='Specify job running timeout value in minutes')
    parser.add_argument('--no_lsf', '-no_lsf', dest='no_lsf', required=False, default=False, action='store_true',
                        help='Do not Use LSF to run tests')
    parser.add_argument('--lsf_command', '-lsf_command', '--lsf_cmd', '-lsf_cmd', dest='lsf_cmd', required=False, default='',
                        help='LSF command to run tests')
    parser.add_argument('--enable_predict_lsf_resource_consumption', '-enable_plrc', '--en_plrc', '-en_plrc', dest='enable_plrc', required=False, default=False, action='store_true',
                        help='Enable lsf queue resource consumption prediction, then submit runs to specific predicted LSF queue')
    parser.add_argument('--predict_lsf_resource_consumption_path', '-plrc_path', '--plrc_path', dest='plrc_path', required=False, default=False,
                        help='Specify lsf queue resource consumption prediction tool path')
    parser.add_argument('--plrc_py', '-plrc_py', dest='plrc_py', type=str, default='', required=False,
                        help='Python version which contains libs in plrc tool')
    parser.add_argument('--enable_coverage', '-enable_coverage', '--en_cov', '-en_cov', dest='enable_coverage', required=False, default=False, action='store_true',
                        help='Enable both code and functional coverage')
    parser.add_argument('--enable_functional_coverage', '-enable_functional_coverage', '--en_fcov', '-en_fcov', dest='enable_functional_coverage', required=False, default=False, action='store_true',
                        help='Enable functional coverage')
    parser.add_argument('--enable_code_coverage', '-enable_code_coverage', '--en_ccov', '-en_ccov', dest='enable_code_coverage', required=False, default=False, action='store_true',
                        help='Enable code coverage')
    parser.add_argument('--disable_multi_processing', '-dmp', dest='disable_multi_processing', required=False,
                        default=False, action='store_true',
                        help='Enable multi processing')
    parser.add_argument('--UVM_VERBOSITY', '-uverb', dest='uverb', required=False, type=str, default='UVM_NONE',
                        help='Specify UVM_VERBOSITY value')
    parser.add_argument('--cc_input_cube_size', '-cc_input_cube_size', '-cics', dest='cc_input_cube_size', required=False, type=str.lower, choices=cube_size_list, default=None,
                        help='Specify convolution input cube size range')
    parser.add_argument('--cc_weight_cube_size', '-cc_weight_cube_size', '-cwcs', dest='cc_weight_cube_size', required=False, type=str.lower, choices=cube_size_list, default=None,
                        help='Specify convolution weight cube size range')
    parser.add_argument('--cc_output_cube_size', '-cc_output_cube_size', '-cocs', dest='cc_output_cube_size', required=False, type=str.lower, choices=cube_size_list, default=None,
                        help='Specify convolution output cube size range')
    parser.add_argument('--sdp_cube_size', '-sdp_cube_size', '-scs', dest='sdp_cube_size', required=False, type=str.lower, choices=cube_size_list, default=None,
                        help='Specify sdp cube size range')
    parser.add_argument('--pdp_input_cube_size', '-pdp_input_cube_size', '-pics', dest='pdp_input_cube_size', required=False, type=str.lower, choices=cube_size_list, default=None,
                        help='Specify pdp input cube size range')
    parser.add_argument('--cdp_cube_size', '-cdp_cube_size', '-ccs', dest='cdp_cube_size', required=False, type=str.lower, choices=cube_size_list, default=None,
                        help='Specify cdp cube size range')
    parser.add_argument('--extra_args', '-extra_args', dest='extra_args', required=False, type=str, default='',
                        help='Extra arguments which will be appended to test command line')
    parser.add_argument('--waves','--wave','-waves','-wave', dest='dump_waveform', action='store_true', default=False, required=False,
                        help='Enable waveform dumping')
    parser.add_argument('--layer_num', '--l_num', '-layer_num', '-l_num', dest='layer_num', type=int, required=False, default=1,
                        help = 'Specify layer numbers for multi-layer tests')
    parser.add_argument('--run_num', '--r_num', '-run_num', '-r_num', dest='run_num', type=int, required=False, default=1,
                        help = 'Specify round numbers which will be used to determine how many rounds will the same test run')
    parser.add_argument('--seed', '-seed', dest='seed', type=int, required=False, default=round(time.time()),
                        help = 'Specify python random number generator seed')
    parser.add_argument('--sub_metrics', '-sub_metrics', dest = 'sub_metrics', type=str, nargs='+', required = False,
                        help = '''Specify sub_metrics for generating regression report using string format: 'merics:tag(;tag)'. 
                        For example: passing_rate:L0;sdp, means generating submetrics with tag [L0,sdp] for 'passing_rate' metrics''')
    parser.add_argument('--dump_trace_only','-dump_trace_only', dest='dump_trace_only', action='store_true', default=False, required=False,
                        help='Dump trace file only, do not run trace player, only used for uvm_random_test')
    config = vars( parser.parse_args() )
    config['and_tag_list'] = [] if config['and_tag_list'] is None else [item for sublist in config['and_tag_list'] for item in sublist]
    config['or_tag_list'] = [] if config['or_tag_list'] is None else [item for sublist in config['or_tag_list'] for item in sublist]
    config['not_tag_list'] = [] if config['not_tag_list'] is None else [item for sublist in config['not_tag_list'] for item in sublist]

    if config['enable_coverage']:
        config['enable_functional_coverage'] = True
        config['enable_code_coverage'] = True

    # Prepare rtlarg
    config['rtlarg'] = []
    config['rtlarg'].append('+UVM_VERBOSITY=%s'                                 % config['uverb'])
    if config['cc_input_cube_size'] is not None:
        config['rtlarg'].append('+uvm_set_config_string=*,cc_input_cube_size,%s'    % config['cc_input_cube_size'])
    if  config['cc_weight_cube_size'] is not None:
        config['rtlarg'].append('+uvm_set_config_string=*,cc_weight_cube_size,%s'   % config['cc_weight_cube_size'])
    if  config['cc_output_cube_size'] is not None:
        config['rtlarg'].append('+uvm_set_config_string=*,cc_output_cube_size,%s'   % config['cc_output_cube_size'])
    if  config['sdp_cube_size'] is not None:
        config['rtlarg'].append('+uvm_set_config_string=*,sdp_cube_size,%s'         % config['sdp_cube_size'])
    if  config['pdp_input_cube_size'] is not None:
        config['rtlarg'].append('+uvm_set_config_string=*,pdp_input_cube_size,%s'   % config['pdp_input_cube_size'])
    if  config['cdp_cube_size'] is not None:
        config['rtlarg'].append('+uvm_set_config_string=*,cdp_cube_size,%s'         % config['cdp_cube_size'])
    if config['enable_functional_coverage']:
        config['rtlarg'].append('+fcov_en -cm_dir test')
    if config['enable_code_coverage']:
        config['rtlarg'].append('-cm line+tgl+cond+fsm+branch+assert -cm_dir test')

    # set random seed
    random.seed(config['seed'])

    if config['test_plan'][-3:] != '.py':
        config['test_plan'] += '.py' 
    # pprint (config)
    # execfile (config['test_list'])
    # pprint (test_list)
    run_plan = RunPlan()
    run_plan.load_config(config)
    run_plan.update_run_test_list_by_tag()
    run_plan.update_run_test_list_by_name()
    #print 'print_run_test_list'
    #run_plan.print_run_test_list()
    #print 'Generate run_test commands'
    run_plan.gen_run_test_command_list()
    run_plan.print_run_test_command_list()
    run_plan.run_plan()
    run_plan.dump_test_orgz()
    run_plan.dump_regression_status()

    # Parse regression data and print report
    run_report = RunReport(regress_dir=run_plan.config['run_dir'],
                           publish_dir=config['publish_dir'],
                           publish=config['publish'],
                           monitor=config['monitor'],
                           monitor_interval=config['monitor_interval'],
                           monitor_timeout=config['timeout'],
                           monitor_quiet=config['monitor_quiet'],
                           submetrics=config['sub_metrics'],
                           )
    run_report.run()
    if run_report.is_regress_pass():
        return 0
    else:
        return 1

if __name__ == '__main__':
    ret = main()
    sys.exit(ret)

