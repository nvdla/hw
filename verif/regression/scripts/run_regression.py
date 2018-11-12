#!/usr/bin/env python

import os
import sys
import argparse
import subprocess
import time
import shutil
import glob
import json
from   pprint   import pprint
from   datetime import datetime

__DESCRIPTION__='''
Use for running regression
'''

def build_tree(project_name, dry_run=False, en_cov=False):
    tot_dir = _get_abs_path_to_tree_root()
    os.chdir(tot_dir)
    # Remove tree.make and outdir
    treemake_abs_path = os.path.join(tot_dir, 'tree.make')
    try:
        os.remove(treemake_abs_path)
    except OSError:
        pass
    outdir_abs_path = os.path.join(tot_dir, 'outdir')
    shutil.rmtree(outdir_abs_path, True)
    # Tree.make setup
    cmd_str = "make USE_NV_ENV=1"
    subprocess.run(cmd_str, shell=True)
    if en_cov:
        with open(treemake_abs_path, 'a') as fh:
            fh.write('COVERAGE:=1')
    # Build tree
    cmd_str = "./tools/bin/tmake -build ready_for_test -project %s" % project_name
    print("Build command:%s" % cmd_str)
    if not dry_run:
        ret = subprocess.run(cmd_str, shell=True)
        return ret.returncode
    else:
        return 0

def _get_abs_path_to_tree_root():
    return os.path.abspath(_get_ref_path_to_tree_root())

def _get_ref_path_to_tree_root(rel_path_to_tree_root = '.'):
    ## there is a file named LICENSE, it's the marker of tree root
    tree_root_marker_path = os.path.join(rel_path_to_tree_root, 'LICENSE')
    if os.path.isfile(tree_root_marker_path) is False:
        rel_path_to_tree_root = os.path.join('..', rel_path_to_tree_root)
        rel_path_to_tree_root = _get_ref_path_to_tree_root(rel_path_to_tree_root)
    return rel_path_to_tree_root

def run_plan(project, plan_name, arguments, lsf_cmd=None, dry_run=False):
    python_interpreter = sys.executable
    cmd_exe = os.path.join(_get_abs_path_to_tree_root(), 'verif/tools/run_plan.py')
    cmd_args = "-P %(project)s --test_plan %(plan_name)s %(arguments)s" % {'project':project, 'plan_name':plan_name, 'arguments':arguments}
    if lsf_cmd:
        cmd_args += ' -lsf_cmd "%s"' % lsf_cmd
    cmd_str = ' '.join([python_interpreter, cmd_exe, cmd_args])
    print ("Run command:%s"%cmd_str)
    if not dry_run:
        ret = subprocess.run(cmd_str, shell=True)
        return ret.returncode
    else:
        return 0

def run_report(run_dir, db_dir, arguments, sub_metrics='', dry_run=False):
    python_interpreter = sys.executable
    cmd_exe = os.path.join(_get_abs_path_to_tree_root(), 'verif/tools/run_report.py')
    cmd_args = "-run_dir %(run_dir)s -publish_dir %(db_dir)s -publish %(arguments)s " % {'db_dir':db_dir, 'run_dir':run_dir, 'arguments':arguments}
    if sub_metrics:
        cmd_args += ' -sub_metrics %s' % sub_metrics
    cmd_str = ' '.join([python_interpreter, cmd_exe, cmd_args])
    print ("Status monitor command:%s"%cmd_str)
    if not dry_run:
        ret = subprocess.run(cmd_str, shell=True)
        return ret.returncode
    else:
        return 0

def run_coverage_report(urg_opts, project, run_dir, db_dir, report_dir, publish_dir, waver_path='', dry_run=False):
    python_interpreter = sys.executable
    cmd_exe = os.path.join(_get_abs_path_to_tree_root(), 'verif/tools/run_coverage_report.py')
    #cmd_args = "-regress_dir %(run_dir)s -merged_cm_dir %(db_dir)s -report_dir %(report_dir)s -waver_path %(waver_path)s" % {'regress_dir':regress_dir, 'db_dir':db_dir, 'report_dir':report_dir, 'waver_path':waver_path}
    cmd_args = "-urg_opts '%(urg_opts)s' -P %(project)s -regress_dir %(run_dir)s -merged_cm_dir %(db_dir)s -report_dir %(report_dir)s -publish -publish_dir %(publish_dir)s" \
                % {'urg_opts':urg_opts, 'project':project, 'run_dir':run_dir, 'db_dir':db_dir, 'report_dir':report_dir, 'publish_dir':publish_dir}
    cmd_str = ' '.join([python_interpreter, cmd_exe, cmd_args])
    print ("Status monitor command:%s"%cmd_str)
    if not dry_run:
        ret = subprocess.run(cmd_str, shell=True)
        return ret.returncode
    else:
        return 0

def run_diagnose(regr_dir,synd_dir,publish_dir,levenshtein_py_path='',dry_run=False):
    cmd_exe  = os.path.join(_get_abs_path_to_tree_root(), 'verif/tools/run_diagnose.py')
    cmd_args = "-regr_dir %(regr_dir)s -synd_dir %(synd_dir)s -publish_dir %(publish_dir)s -publish -a diagnose " % {'regr_dir':regr_dir, 'synd_dir':synd_dir, 'publish_dir':publish_dir}
    cmd_str = ' '.join([levenshtein_py_path, cmd_exe, cmd_args])
    print ("Test diagnose command:%s"%cmd_str)
    if not dry_run:
        ret = subprocess.run(cmd_str, shell=True)
        return ret.returncode
    else:
        return 0

def run_metrics(db_dir, web_dir, name, plotly_python_path='', dry_run=False):
    cmd_exe = os.path.join(_get_abs_path_to_tree_root(), 'verif/tools/run_metrics.py')
    cmd_args = "-db_dir %(db_dir)s -web_dir %(web_dir)s -regression_name %(name)s" % {'db_dir':db_dir, 'web_dir':web_dir, 'name':name}
    cmd_str = ' '.join([plotly_python_path, cmd_exe, cmd_args])
    print ("Metrics generation command:%s"%cmd_str)
    if not dry_run:
        ret = subprocess.run(cmd_str, shell=True)
        return ret.returncode
    else:
        return 0

def kill_running_tests(run_dir):
    cmd_str = os.path.join(_get_abs_path_to_tree_root(), run_dir, 'kill_plan.sh')
    print ("Kill still running tests:%s"%cmd_str)
    return subprocess.run(cmd_str, shell=True)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__DESCRIPTION__)
    parser.add_argument('--project','-P', dest='project', required=True,
                        help='Specify project name')
    parser.add_argument('--kind', '-kind', dest='kind', type=str, default='sanity', choices=['protection','sanity','random','coverage','all'], required=True,
                        help='Specify regression kind')
    parser.add_argument('--timeout', '-timeout', dest='timeout', type=int, default=720, required=False,
                        help='Specify job running timeout value in minutes')
    parser.add_argument('--name', '-name', dest='test_name_pattern', required=False, default='',
                        help='Specify test name selection pattern')
    parser.add_argument('--skip_build', '-skip_build', dest='skip_build', required=False, default=False, action='store_true',
                        help='Skip build')
    parser.add_argument('--and_tag','-atag', dest='and_tag_list', required=False, nargs='+', action='append',
                        help='Test contains all and_tag will be seleted')
    parser.add_argument('--or_tag','-otag', dest='or_tag_list', required=False, nargs='+', action='append',
                        help='Test contains at least one of the or_tag will be seleted')
    parser.add_argument('--not_tag','-ntag', dest='not_tag_list', required=False, nargs='+', action='append',
                        help='Test contains any one of the not_tag will not be seleted')
    parser.add_argument('--seed', '-seed', dest='seed', type=int, required=False, default=round(time.time()),
                        help = 'Specify python random number generator seed')
    parser.add_argument('--publish_dir', '-publish_dir', dest='publish_dir', type=str, default='', required=False,
                        help='Regression result will be posted to specifed directory')
    parser.add_argument('--syndrome_dir', '-syndrome_dir', dest='syndrome_dir', type=str, default='', required=False,
                        help='Regression syndrome data base directory')
    parser.add_argument('--web_dir', '-web_dir', dest='web_dir', type=str, default='', required=False,
                        help='Web report will be generated in specified directory')
    parser.add_argument('--lsf_command', '-lsf_cmd', dest='lsf_cmd', required=False, default=None,
                        help='LSF command to run tests')
    parser.add_argument('--plotly_py_path', '-plotly_py_path', '--ppp', '-ppp', dest='plotly_py_path', type=str, default='', required=False,
                        help='Python version which contains plotly lib')
    parser.add_argument('--levenshtein_py_path', '-levenshtein_py_path', '--lpp', '-lpp', dest='levenshtein_py_path', type=str, default='', required=False,
                        help='Python version which contains levenshtein lib')
    parser.add_argument('--dry_run', '-dry_run', dest='dry_run', required=False, default=False, action='store_true',
                        help='Print command only, will not execute any command')
    parser.add_argument('--en_cov', '-en_cov', dest='en_cov', required=False, default=False, action='store_true',
                        help='Enable coverage in project build process')
    parser.add_argument('--extra_args', '-extra_args', dest='extra_args', required=False, type=str, default='',
                        help='Extra arguments which will be appended to run_plan command line')
    config = vars( parser.parse_args() )
    config['and_tag_list'] = [] if config['and_tag_list'] is None else [item for sublist in config['and_tag_list'] for item in sublist]
    config['or_tag_list'] = [] if config['or_tag_list'] is None else [item for sublist in config['or_tag_list'] for item in sublist]
    config['not_tag_list'] = [] if config['not_tag_list'] is None else [item for sublist in config['not_tag_list'] for item in sublist]
    if config['plotly_py_path']:
        assert(os.path.isfile(config['plotly_py_path']))
    if config['levenshtein_py_path']:
        assert(os.path.isfile(config['levenshtein_py_path']))
    max_regression_time = config['timeout']
    publish_dir = config['publish_dir']
    synd_dir = config['syndrome_dir']
    web_dir  = config['web_dir']
    lsf_cmd = config['lsf_cmd']
    dry_run = config['dry_run']
    args_list = []
    if config['timeout']:
        args_list.append("-timeout %d" % config['timeout'])
    if config['test_name_pattern']:
        args_list.append("-name %s" % config['name'])
    if config['and_tag_list']:
        args_list.append("-atag %s" % ' '.join(config['and_tag_list']))
    if config['or_tag_list']:
        args_list.append("-otag %s" % ' '.join(config['or_tag_list']))
    if config['not_tag_list']:
        args_list.append("-ntag %s" % ' '.join(config['not_tag_list']))
    args_list.append("-seed %d" % config['seed'])
    args  = ' '.join(args_list)
    args += ' '+config['extra_args']
    #pprint (config)
    project_name = config['project']
    if not config['skip_build']:
        ret = build_tree(project_name, dry_run, config['en_cov'])
        if 0 != ret:
            print("TREE_BUILD_FAIL")
            sys.exit(ret)
    if (project_name in ['nv_small','nv_small_256', 'nv_small_256_full', 'nv_medium_512', 'nv_medium_1024_full', 'nv_large']):
        time_str = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
        run_dir = '%s_%s' % (project_name, time_str)
        try:
            if 'protection' == config['kind']:
                ret=run_plan(config['project'], project_name, '-otag protection %s -run_dir %s' % (args, run_dir), lsf_cmd)
                ret=run_report(run_dir, publish_dir, '-monitor_timeout %d' % max_regression_time, '', dry_run)
            elif 'sanity' == config['kind']:
                ret=run_plan(config['project'], project_name, '-otag L0 L1 L2 %s -run_dir %s' % (args, run_dir), lsf_cmd, dry_run)
                ret=run_report(run_dir, publish_dir, '-monitor_timeout %d' % max_regression_time, 'passing_rate:L0 passing_rate:L1 passing_rate:L2', dry_run)
            elif 'random' == config['kind']:
                ret=run_plan(config['project'], project_name, '-otag L10 L11 %s -run_dir %s' % (args, run_dir), lsf_cmd, dry_run)
                ret=run_report(run_dir, publish_dir, '-monitor_timeout %d' % max_regression_time, 'passing_rate:L10 passing_rate:L11', dry_run)
            elif 'coverage' == config['kind']:
                ret=run_plan(config['project'], project_name, '-otag L0 L1 L2 L10 L11 L20 L21 %s -run_dir %s -en_cov' % (args, run_dir), lsf_cmd, dry_run)
                ret=run_report(run_dir, publish_dir, '-monitor_timeout %d' % max_regression_time, 'passing_rate:L0 passing_rate:L1 passing_rate:L2 passing_rate:L10 passing_rate:L11 passing_rate:L20 passing_rate:L21', dry_run)
                regr_sts_file = ''.join(glob.glob('{}/regression_status_*.json'.format(run_dir)))
                with open(regr_sts_file, 'r') as fh:
                    regr_db = json.load(fh)
                cov_vdb_dir = 'merged_'+regr_db['start_time']+'.vdb'
                cov_report_dir = 'report_'+regr_db['start_time']
                ret=run_coverage_report('-format both', config['project'], run_dir, cov_vdb_dir, cov_report_dir, publish_dir, dry_run)
                shutil.move(cov_vdb_dir, run_dir)
                shutil.move(cov_report_dir, run_dir)
            elif 'all' == config['kind']:
                ret=run_plan(config['project'], project_name, '%s -run_dir %s' % (args, run_dir), lsf_cmd, dry_run)
                ret=run_report(run_dir, publish_dir, '-monitor_timeout %d' % max_regression_time, 'passing_rate:L0 passing_rate:L1 passing_rate:L2 passing_rate:L10 passing_rate:L11', dry_run)
            if 0 == ret:
                print ("REGRESSION_PASS")
            else:
                print ("REGRESSION_FAIL")
            ret=run_diagnose(run_dir, synd_dir, publish_dir, config['levenshtein_py_path'], dry_run)
            if 0 != ret:
                raise Exception("REGRESSION_FAIL_CANNOT_RUN_DIAGNOSE")
            ret=run_metrics(os.path.join(publish_dir,'json_db'), web_dir, project_name+'_'+config['kind'], config['plotly_py_path'], dry_run)
            if 0 != ret:
                raise Exception("REGRESSION_FAIL_CANNOT_GENERATE_METRICS")
        except:
            raise Exception("REGRESSION_FAIL_UNKOWN_REASON")
        print ("REGRESSION_COMPLETE")
        sys.exit(0)
    raise Exception("REGRESSION_FAIL_UNKOWN_PROJECT")
