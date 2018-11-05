#!/usr/bin/env python
#
# TOT = Top Of Tree (tree root)
#
# Coverage Flow Example:
#
# 1. Add 'COVERAGE := 1' in TOT/tree.make
#
# 2. Build tree
#|   TOT/tools/bin/tmake -build ready_for_test
#
# 3. Run regression (you can run multiple rounds of regression with different ~layer_num~):
#|   TOT/verif/tools/run_plan.py -tp nv_small -P nv_small -monitor \
#|       -layer_num 4 -run_num 2 \
#|       -extra_args "-rtlarg '-cm line+tgl+cond+fsm+branch+assert -cm_dir test.vdb +fcov_en' "
#
# 4. Generate coverage report
#|   TOT/verif/tools/run_coverage_report.py -P nv_small \
#|     -regress_dir nv_small_2018-03-07_01-09-09 \
#|     -regress_dir nv_small_2018-03-06_21-50-42 \
#|     -report_dir ./historical/2018-03-07

import os
import sys
import re
import argparse
import subprocess
import json
import glob
from   shutil import copy2, copytree, which

__DESCRIPTION__ = '''
  This tool is used to generate coverage report.
'''

class RunCoverageReport(object):
    project        = ''
    urg_exe        = 'urg'
    tb             = 'trace_player'
    tb_cm_dir      = 'simv.vdb'
    test_cm_dir    = 'test.vdb'
    merged_cm_dir  = 'merged.vdb'
    regress_dir    = []
    urg_opts       = []
    report_dir     = './urgReport'
    gen_report_only= False
    view_report    = False
    dry_run        = False
    tree_root      = ''
    publish        = False
    publish_dir    = ''

    def __init__(self, project, tb, tb_cm_dir, test_cm_dir, merged_cm_dir, regress_dir, 
                 report_dir, urg_opts, gen_report_only, view_report, dry_run, publish, publish_dir):
        self.project     = project
        self.publish     = publish
        self.publish_dir = publish_dir
        if tb is not None:
            self.tb = tb
        if tb_cm_dir is not None:
            self.tb_cm_dir = tb_cm_dir
        if test_cm_dir is not None:
            self.test_cm_dir = test_cm_dir
        if merged_cm_dir is not None:
            self.merged_cm_dir = merged_cm_dir
        self.regress_dir = regress_dir
        if report_dir is not None:
            self.report_dir = report_dir
        if gen_report_only is not None:
            self.gen_report_only = gen_report_only
        if view_report is not None:
            self.view_report = view_report
        if len(urg_opts) > 0:
            self.urg_opts = urg_opts
        if dry_run is not None:
            self.dry_run = dry_run
        self.tree_root = self.__get_abs_path_of_tree_root()
        env = self.__get_env_from_file(os.path.join(self.tree_root, 'tree.make'), ':=')
        try:
            os.environ['VCS_HOME'] = env['VCS_HOME']
        except KeyError as error:
            raise Exception('%s is not defined in tree.make' % error.args[0])
        os.environ['PATH'] = os.pathsep.join([os.path.join(os.environ['VCS_HOME'], 'bin'), os.environ['PATH']])
        self.urg_exe = which('urg')

    def run(self):
        if not self.gen_report_only:
            self.__merge_vdb()
        self.__gen_coverage_report()
        self.__merge_regr_status_db()
        self.__update_coverage_metrics()

    def __merge_vdb(self):
        self.__run_cmd('rm -rf %s' % self.merged_cm_dir)

        # testbench vdb
        ip_vdb = os.path.join(self.tree_root, 'outdir', self.project, 'verif/testbench/%s/%s' % (self.tb, self.tb_cm_dir))
        if not os.path.isdir(ip_vdb):
            raise Exception('merge_vdb', 'directory does not exist: %s' %  ip_vdb)
            
        # test vdb
        test_vdb_list = []
        for d in self.regress_dir:
            with open(os.path.join(d, 'test_organization.json'), 'r') as f:
                test_dict = json.load(f)
                for tinfo in test_dict.values():
                    if self.tb == 'trace_player':
                        test_vdb_path = os.path.join(tinfo['dir'], self.test_cm_dir)
                    else:
                        test_vdb_path = os.path.join(tinfo['dir'], tinfo['name'], self.test_cm_dir)
                    test_vdb_list.append(test_vdb_path)
        with open('test_vdb.list', 'w') as f:
            f.write('\n'.join(test_vdb_list))

        # merged vdb
        cmd  = '%s -dir %s -f test_vdb.list -dbname %s' % (self.urg_exe, ip_vdb, self.merged_cm_dir)
        cmd += ' -parallel -parallel_split 80 -maxjobs 100'
        cmd += ' -show tests -nocheck -noreport'
        self.__run_cmd(cmd)

    def __gen_coverage_report(self):
        elfiles = glob.glob(os.path.join(self.tree_root, 'verif', 'coverage', 'elfiles', self.project, '*.el'))
        cmd_exe   = self.urg_exe
        cmd_args  = ' -dir %s' % self.merged_cm_dir
        cmd_args += ' -report %s' % self.report_dir
        cmd_args += ' -group ratio -show ratios'
        cmd_args += ''.join(list(map(lambda x: ' -elfile %s' % x, elfiles)))
        if len(self.urg_opts) > 0:
            cmd_args += ' ' + ' '.join(self.urg_opts)
        cmd = cmd_exe + ' ' + cmd_args
        self.__run_cmd(cmd)
        cmd = 'firefox %s/dashboard.html &' % self.report_dir
        if self.dry_run == False:
            print('[INFO] Coverage report is generated under %s.' % self.report_dir)
            print('[INFO] You can open it like this: %s' % cmd)
        if self.view_report:
            self.__run_cmd(cmd)

    def __merge_test_status_db(self):
        file_list = [item for sublist in [[x for x in glob.glob(y+'/test_status_*.json')] for y in self.regress_dir] for item in sublist]
        file_list = sorted(file_list)
        merge_db = {}
        for idx in range(len(file_list)):
            with open(file_list[idx], 'r') as fh:
                db = json.load(fh)
            if idx == 0:
                merge_db = db
            else:
                db_len = len(merge_db)
                for i in db:
                    merge_db[str(int(i)+db_len)] = db[i]
        with open(file_list[0], 'w') as fh:
            json.dump(merge_db, fh, sort_keys=True, indent=4)
        return merge_db

    def __merge_regr_status_db(self):
        test_db = self.__merge_test_status_db()
        file_list = [item for sublist in [[x for x in glob.glob(y+'/regression_status_*.json')] for y in self.regress_dir] for item in sublist]
        file_list = sorted(file_list)
        merge_db = {}
        for idx in range(len(file_list)):
            with open(file_list[idx], 'r') as fh:
                db = json.load(fh)
            if idx == 0:
                merge_db = db
            else:
                if db['unique_id'] != merge_db['unique_id']:
                    raise Exception('CommmitID mismatch between regression %s and %s' % (file_list[0], file_list[idx]))
                merge_db['metrics_result']['planned_test_number']    += db['metrics_result']['planned_test_number']
                merge_db['metrics_result']['running_test_number']    += db['metrics_result']['running_test_number']
                merge_db['metrics_result']['unwrittern_test_number'] += db['metrics_result']['unwrittern_test_number']
        # Calculate merged regression passing rate
        pass_cnt  = 0
        for tid,info in test_db.items():
            if info['status'] == 'PASS':
                pass_cnt += 1
        if len(test_db) != 0:
            merge_db['metrics_result']['passing_rate'] = float('%.4f' % (pass_cnt/len(test_db)))
        with open(file_list[0], 'w') as fh:
            json.dump(merge_db, fh, sort_keys=True, indent=4)

    def __update_coverage_metrics(self):
        ''' Used to get coverage data from urg report file and annotate back to regression json file.'''
        cov_dict = {}
        cov_file = os.path.join(self.report_dir,'dashboard.txt')
        regr_sts_file = ''.join(glob.glob('{}/regression_status_*.json'.format(sorted(self.regress_dir)[0])))
        test_sts_file = ''.join(glob.glob('{}/test_status_*.json'.format(sorted(self.regress_dir)[0])))
        with open(regr_sts_file, 'r') as fh:
            regr_db = json.load(fh)
        with open(cov_file, 'r') as fh:
            cov_data = fh.readlines()
            for idx in range(len(cov_data)):
                if re.match('Total Coverage Summary', cov_data[idx], re.I):
                    cov_item  = re.split('\s{2,}',cov_data[idx+1].strip())
                    cov_score = re.split('\s{2,}',cov_data[idx+2].strip())
                    for i in range(len(cov_item)):
                        cov_dict[cov_item[i]] = re.split('\s|\/', cov_score[i])
                    f_hit = 0
                    f_all = 0
                    c_hit = 0
                    c_all = 0
                    for key in cov_dict:
                        if key in ['ASSERT', 'GROUP']:
                            f_hit += int(cov_dict[key][1])
                            f_all += int(cov_dict[key][2])
                        elif key in ['LINE', 'COND', 'TOGGLE', 'FSM', 'BRANCH']:
                            c_hit += int(cov_dict[key][1])
                            c_all += int(cov_dict[key][2])
                    #cov_dict['FUNC'] = '{:.4f}'.format((int(cov_dict['ASSERT'][1])+int(cov_dict['GROUP'][1]))/(int(cov_dict['ASSERT'][2])+int(cov_dict['GROUP'][2])))
                    #cov_dict['CODE'] = '{:.4f}'.format((int(cov_dict['LINE'][1])+int(cov_dict['COND'][1])+int(cov_dict['TOGGLE'][1])+int(cov_dict['FSM'][1])+int(cov_dict['BRANCH'][1])) \
                    #                                   / (int(cov_dict['LINE'][2])+int(cov_dict['COND'][2])+int(cov_dict['TOGGLE'][2])+int(cov_dict['FSM'][2])+int(cov_dict['BRANCH'][2])))
                    if f_all != 0:
                        cov_dict['FUNC'] =  '{:.4f}'.format(f_hit/f_all)
                    else:
                        cov_dict['FUNC'] =  0
                    if c_all != 0:
                        cov_dict['CODE'] =  '{:.4f}'.format(c_hit/c_all)
                    else:
                        cov_dict['CODE'] =  0
                    if 'LINE' in cov_dict:
                        regr_db['metrics_result']['line_coverage']       = float(cov_dict['LINE'][0])/100
                    else:
                        regr_db['metrics_result']['line_coverage']       = 0
                    if 'COND' in cov_dict:
                        regr_db['metrics_result']['cond_coverage']       = float(cov_dict['COND'][0])/100
                    else:
                        regr_db['metrics_result']['cond_coverage']       = 0
                    if 'TOGGLE' in cov_dict:
                        regr_db['metrics_result']['toggle_coverage']     = float(cov_dict['TOGGLE'][0])/100
                    else:
                        regr_db['metrics_result']['toggle_coverage']     = 0
                    if 'FSM' in cov_dict:
                        regr_db['metrics_result']['fsm_coverage']        = float(cov_dict['FSM'][0])/100
                    else:
                        regr_db['metrics_result']['fsm_coverage']        = 0
                    if 'BRANCH' in cov_dict:
                        regr_db['metrics_result']['branch_coverage']     = float(cov_dict['BRANCH'][0])/100
                    else:
                        regr_db['metrics_result']['branch_coverage']     = 0
                    if 'ASSERT' in cov_dict:
                        regr_db['metrics_result']['assert_coverage']     = float(cov_dict['ASSERT'][0])/100
                    else:
                        regr_db['metrics_result']['assert_coverage']     = 0
                    if 'GROUP' in cov_dict:
                        regr_db['metrics_result']['group_coverage']      = float(cov_dict['GROUP'][0])/100
                    else:
                        regr_db['metrics_result']['group_coverage']      = 0
                    regr_db['metrics_result']['code_coverage']       = float(cov_dict['CODE'])
                    regr_db['metrics_result']['functional_coverage'] = float(cov_dict['FUNC'])
                    with open(regr_sts_file, 'w') as fh:
                        json.dump(regr_db, fh, sort_keys=True, indent=4)
                    print('[INFO] Coverage Data Anotation in regression data file : %s completed' % regr_sts_file)
                    if self.publish:
                        os.makedirs(os.path.join(self.publish_dir,'json_db'), exist_ok=True)
                        copy2(regr_sts_file, os.path.join(self.publish_dir,'json_db'))
                        print('[INFO] Published regression data file: %s' % regr_sts_file)
                        copy2(test_sts_file, os.path.join(self.publish_dir,'json_db'))
                        print('[INFO] Published test status data file: %s' % test_sts_file)
                        copytree(self.report_dir, os.path.join(self.publish_dir,'coverage/report',os.path.basename(self.report_dir)))
                        print('[INFO] Published coverage report : %s' % self.report_dir)
                        copytree(self.merged_cm_dir, os.path.join(self.publish_dir,'coverage/data',os.path.basename(self.merged_cm_dir)))
                        print('[INFO] Published coverage data : %s' % self.merged_cm_dir)
                    break

    def __run_cmd(self, cmd, verbose=True):
        if self.dry_run:
            print('[INFO] %s' % cmd)
            return

        try:
            if verbose:
                print('[INFO] %s' % cmd)
            subprocess.call(cmd, shell=True)
        except OSError:
            raise Exception('run_cmd', 'Failed to run cmd: %s' %  cmd)

    def __get_ref_path_to_tree_root(self, rel_path_to_tree_root = '.'):
        tree_root_marker_path = os.path.join(rel_path_to_tree_root, 'LICENSE')
        if os.path.isfile(tree_root_marker_path) is False:
            rel_path_to_tree_root = os.path.join('..', rel_path_to_tree_root)
            rel_path_to_tree_root = self.__get_ref_path_to_tree_root(rel_path_to_tree_root)
        return rel_path_to_tree_root
    
    def __get_abs_path_of_tree_root(self):
        return os.path.abspath(self.__get_ref_path_to_tree_root())

    def __get_env_from_file(self, fname, sep):
        env = {}
        pat = re.compile(r'^\s*(?P<left>\S+)\s+' + sep + r'\s*(?P<right>\S+)\s*$')
        with open(fname) as file:
            for line in file:
                m = pat.match(line)
                if m: env[m.group('left')] = m.group('right')
        return env

def main():
    parser = argparse.ArgumentParser(description = __DESCRIPTION__)
    parser.add_argument('--project', '-P',
                        dest     = 'project',
                        required = True,
                        help     = 'Specify project name: nv_small, nv_small_256, nv_large')
    parser.add_argument('--tb', '-tb',
                        dest     = 'tb',
                        required = False,
                        default  = 'trace_player',
                        help     = 'Specify which tb regression was running on: trace_player or trace_generator, default is trace_player')
    parser.add_argument('--tb_cm_dir', '-tb_cm_dir',
                        dest     = 'tb_cm_dir',
                        required = False,
                        default  = 'simv.vdb',
                        help     = 'Specify testbench coverage metrics directory, default is simv.vdb')
    parser.add_argument('--test_cm_dir', '-test_cm_dir',
                        dest     = 'test_cm_dir',
                        required = False,
                        default  = 'test.vdb',
                        help     = 'Specify test coverage metrics directory, default is test.vdb')
    parser.add_argument('--merged_cm_dir', '-merged_cm_dir',
                        dest     = 'merged_cm_dir',
                        required = False,
                        default  = 'merged.vdb',
                        help     = 'Specify merged coverage metrics directory, default is merged.vdb')
    parser.add_argument('--regress_dir', '-regress_dir',
                        dest     = 'regress_dir',
                        required = True,
                        action   = 'append',
                        help     = 'Specify regression result directory, can be specified multiple times')
    parser.add_argument('--urg_opts', '-urg_opts',
                        dest     = 'urg_opts',
                        required = False,
                        default  = [],
                        action   = 'append',
                        help     = 'Specify extra urg options')
    parser.add_argument('--report_dir', '-report_dir',
                        dest     = 'report_dir',
                        required = False,
                        default  = None,
                        help     = 'Specify coverage report directory')
    parser.add_argument('--gen_report_only', '-gen_report_only',
                        dest     = 'gen_report_only',
                        required = False,
                        action   = 'store_true',
                        default  = False,
                        help     = 'Generate coverage report only, do not merge vdb')
    parser.add_argument('--view_report', '-view_report',
                        dest     = 'view_report',
                        required = False,
                        action   = 'store_true',
                        default  = False,
                        help     = 'View coverage report after report generated')
    parser.add_argument('--dry_run', '-dry_run',
                        dest     = 'dry_run',
                        required = False,
                        action   = 'store_true',
                        default  = False,
                        help     = 'Only show running cmd, cmd will not be executed')
    parser.add_argument('--publish', '-publish',
                        dest     = 'publish',
                        required = False,
                        action   = 'store_true',
                        default  = False,
                        help     = 'Pulish (merged) regression database and coverage database/report')
    parser.add_argument('--publish_dir', '-publish_dir',
                        dest = 'publish_dir',
                        required = False,
                        default='',
                        help = 'Specify directory for storing published regression/coverage data&report')
    args = vars(parser.parse_args())
    
    run_coverage_report = RunCoverageReport(project        = args['project'],
                                            tb             = args['tb'],
                                            tb_cm_dir      = args['tb_cm_dir'],
                                            test_cm_dir    = args['test_cm_dir'],
                                            merged_cm_dir  = args['merged_cm_dir'],
                                            regress_dir    = args['regress_dir'],
                                            report_dir     = args['report_dir'],
                                            urg_opts       = args['urg_opts'],
                                            view_report    = args['view_report'],
                                            gen_report_only= args['gen_report_only'],
                                            dry_run        = args['dry_run'],
                                            publish        = args['publish'],
                                            publish_dir    = args['publish_dir'],
                                            )
    run_coverage_report.run() 

if __name__ == '__main__':
    main()

