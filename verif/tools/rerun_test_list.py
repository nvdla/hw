#!/usr/bin/env python

import os
import time
import argparse
import subprocess
import glob
import json
from   shutil     import copy2, copytree
from   run_report import RunReport


__DESCRIPTION__='''
=========================================
           # RerunTestList #
=========================================
This class is used to rerun tests from specific tests list files
which stored in JSON format. Normal usecase is reruning failed tests
in regressions from file 'failed_test_list.json', which is generated 
in run_report.py script and will be automaticly called by run_plan.py
script. You can also specify user-defined test lists and multiple test
lists are also supported, but must keep the same format as shown in 
'failed_test_list.json' file.
'''

class  RerunTestList(object):

    def __init__(self, run_dir, lsf_cmd):
        self._run_dir   = run_dir
        self._lsf_cmd   = lsf_cmd
        self._test_db   = {}

    def run(self):
        self.load_test_db()
        cmd_file = self.gen_rerun_cmd()
        self.execute_rerun_cmd(cmd_file)

    def load_test_db(self):
        rerun_test_list = os.path.join(self._run_dir,'failed_test_list.json')
        with open(rerun_test_list, 'r') as fh:
            db = json.load(fh)
            self._test_db.update(db) 

    def gen_rerun_cmd(self):
        cmd_file = []
        for idx,info in self._test_db.items():
            rerun_dir = info['dir']+'.rerun'
            os.makedirs(rerun_dir, exist_ok=True)
            #copytree(os.path.join(info['dir'],info['name']), rerun_dir)
            for sh_file in  glob.glob(info['dir']+'/*.sh'):
                copy2(sh_file, rerun_dir)
            cmd_file.append(os.path.join(rerun_dir, 'run_trace_player.sh'))
        return cmd_file
            

    def execute_rerun_cmd(self, cmd_file):
        origin_working_dir = os.getcwd()
        for item in cmd_file:
            rerun_dir = os.path.dirname(item)
            os.chdir(rerun_dir)
            cmd = ' '.join([self._lsf_cmd, item])
            print('[RERUN]: execute command \" %0s \"' % cmd)
            subprocess.Popen(cmd, shell=True)
            time.sleep(1)
        time.sleep(10)
        os.chdir(origin_working_dir)

def main():
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description=__DESCRIPTION__)
    parser.add_argument('--run_dir','-run_dir', dest='run_dir', required=True, default=[], type=str, 
                        help='provide regress directory where failed test need to rerun')
    parser.add_argument('--lsf_command', '-lsf_command', '--lsf_cmd', '-lsf_cmd', dest='lsf_cmd', required=False, default='',
                        help='LSF command to run tests')
    config = vars(parser.parse_args())
    #Generte reports in case no reports
    gen_report = RunReport(regress_dir      =config['run_dir'],
                           publish_dir      = '',
                           publish          = False,
                           monitor          = True,
                           monitor_interval = 30,
                           monitor_timeout  = 1,
                           monitor_quiet    = True,
                           submetrics       = '',
                           )
    gen_report.run()
    rerun_test_list = RerunTestList(run_dir = config['run_dir'],
                                    lsf_cmd = config['lsf_cmd'],
                                 )
    rerun_test_list.run()

if __name__ == '__main__':
    main()
