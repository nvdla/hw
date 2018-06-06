#!/usr/bin/env python

import os
import sys
import argparse
import subprocess
import re
from pprint import pprint

__DESCRIPTION__='''
Use for code checkin protection
'''

def _get_abs_path_to_tree_root():
    return os.path.abspath(_get_ref_path_to_tree_root())

def _get_ref_path_to_tree_root(rel_path_to_tree_root = '.'):
    ## there is a file named LICENSE, it's the marker of tree root
    tree_root_marker_path = os.path.join(rel_path_to_tree_root, 'LICENSE')
    if os.path.isfile(tree_root_marker_path) is False:
        rel_path_to_tree_root = os.path.join('..', rel_path_to_tree_root)
        rel_path_to_tree_root = _get_ref_path_to_tree_root(rel_path_to_tree_root)
    return rel_path_to_tree_root

def run_test(project, test_name, arguments):
    python_interpreter = sys.executable
    cmd_exe = os.path.join(_get_abs_path_to_tree_root(), 'verif/tools/run_test.py')
    cmd_args = "-P %(project)s %(name)s %(arguments)s" % {'project':project, 'arguments':arguments, 'name':test_name}
    cmd_str = ' '.join([python_interpreter, cmd_exe, cmd_args])
    print ("Run command:%s"%cmd_str)
    return subprocess.call(cmd_str, shell=True)

def run_plan(project, plan_name, arguments):
    python_interpreter = sys.executable
    cmd_exe = os.path.join(_get_abs_path_to_tree_root(), 'verif/tools/run_plan.py')
    cmd_args = "-P %(project)s --test_plan %(plan_name)s %(arguments)s" % {'project':project, 'plan_name':plan_name, 'arguments':arguments}
    cmd_str = ' '.join([python_interpreter, cmd_exe, cmd_args])
    print ("Run command:%s"%cmd_str)
    return subprocess.call(cmd_str, shell=True)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__DESCRIPTION__)
    parser.add_argument('--project','-P', dest='project', required=True,
                        help='Specify project name')
    config = vars( parser.parse_args() )
    #pprint (config)
    if (config['project'] in ['nv_small', 'nv_small_256', 'nv_small_256_full', 'nv_medium_512', 'nv_medium_1024_full', 'nv_large']):
        ret=run_plan(config['project'], config['project'], '-atag protection -no_lsf -monitor -timeout 20')
        if 0 == ret:
            print ("verif_protection_pass")
        sys.exit(ret)
    sys.exit('Unexpected project name')
