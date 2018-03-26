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
import argparse
import subprocess

__DESCRIPTION__ = '''
  This tool is used to generate coverage report.
'''

class RunCoverageReport(object):
    project        = ''
    tb             = 'trace_player'
    tb_cm_dir      = 'simv.vdb'
    test_cm_dir    = 'test.vdb'
    merged_cm_dir  = 'merged.vdb'
    regress_dir    = []
    elfile         = []
    report_dir     = './urgReport'
    gen_report_only= False
    view_report    = False
    dry_run        = False
    tree_root      = ''

    def __init__(self, project, tb, tb_cm_dir, test_cm_dir, merged_cm_dir,
                 regress_dir, report_dir, elfile, gen_report_only, view_report, dry_run):
        self.project = project
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
        if len(elfile) > 0:
            self.elfile = elfile
        if dry_run is not None:
            self.dry_run = dry_run
        self.tree_root = self.__get_abs_path_of_tree_root()

    def run(self):
        if not self.gen_report_only:
            self.__merge_vdb()
        self.__gen_coverage_report()

    def __merge_vdb(self):
        self.__run_cmd('rm -rf %s' % self.merged_cm_dir)

        # testbench vdb
        ip_vdb = os.path.join(self.tree_root, 'outdir', self.project, 'verif/testbench/%s/%s' % (self.tb, self.tb_cm_dir))
        if not os.path.isdir(ip_vdb):
            raise Exception('merge_vdb', 'directory does not exist: %s' %  ip_vdb)
            
        # test vdb
        self.__run_cmd('echo > test_vdb.list')
        for d in self.regress_dir:
            cmd = 'find %s -type d -name "%s" -not -empty >> test_vdb.list' % (d, self.test_cm_dir)
            self.__run_cmd(cmd)
        
        # merged vdb
        cmd  = 'urg -dir %s -f test_vdb.list -dbname %s' % (ip_vdb, self.merged_cm_dir)
        cmd += ' -group ratio -group merge_across_scopes -parallel -parallel_split 10 -maxjobs 100'
        cmd += ' -show tests -nocheck -noreport'
        self.__run_cmd(cmd)

    def __gen_coverage_report(self):
        cmd = 'urg -group ratio -show ratios -group merge_across_scopes -dir %s -report %s ' % (self.merged_cm_dir, self.report_dir)
        if len(self.elfile) > 0:
            cmd += ' '.join(list(map(lambda x: ' -elfile '+x, self.elfile)))
        self.__run_cmd(cmd)
        cmd = 'firefox %s/dashboard.html &' % self.report_dir
        if self.dry_run == False:
            print('[INFO] Coverage report is generated under %s.' % self.report_dir)
            print('[INFO] You can open it like this: %s' % cmd)
        if self.view_report:
            self.__run_cmd(cmd)

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
    parser.add_argument('--elfile', '-elfile',
                        dest     = 'elfile',
                        required = False,
                        default  = [],
                        action   = 'append',
                        help     = 'Specify exclusion file, can be specified multiple times')
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
    args = vars(parser.parse_args())
    
    run_coverage_report = RunCoverageReport(project        = args['project'],
                                            tb             = args['tb'],
                                            tb_cm_dir      = args['tb_cm_dir'],
                                            test_cm_dir    = args['test_cm_dir'],
                                            merged_cm_dir  = args['merged_cm_dir'],
                                            regress_dir    = args['regress_dir'],
                                            report_dir     = args['report_dir'],
                                            elfile         = args['elfile'],
                                            view_report    = args['view_report'],
                                            gen_report_only= args['gen_report_only'],
                                            dry_run        = args['dry_run'],
                                            )
    run_coverage_report.run() 

if __name__ == '__main__':
    main()

