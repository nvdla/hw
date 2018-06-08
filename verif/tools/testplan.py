#!/usr/bin/env python

import imp
import argparse
from pprint import pprint
import os
import sys

__DESCRIPTION__='''
This class is used to execute a test plan:
    1. Load test plan file
    2. 

    Test plan structure
    test_list = [ 
        hash_of (name, args.sort, config) : {
        name    : name_string,
        args    : arg_list,
        config  : config_list,
        module  : module_string,
        tags    : tag_list,
        desc    : desc_string,
        },
    ]
'''

class TestPlan():
    def __init__(self, project):
        self.project = project
        self.test_list = []
        self.log_checker_dict = {}
        self.test_bench_list = []
        self.plan_arguments = {}
        self.user_variables = dict(add_test=self.add_test)
        self.defs_path = os.path.join(self.get_abs_path_to_tree_root(), 'outdir', self.project, 'spec/defs')
        sys.path.append(self.defs_path)

    def set_plan_arguments(self, attr_dict):
        assert(type(attr_dict)==dict)
        self.plan_arguments.update(attr_dict)
        self.user_variables.update(dict(plan_arguments=self.plan_arguments))

    def add_test(self, name='', args=[], config=[], module='nvdla_trace_test', tags=[], desc='', unwritten=False):
        ## TODO, type checker
        self.test_list.append( {
            'name'   : name,
            'args'   : args,
            'config' : config,
            'module' : module,
            'tags'   : tags,
            'desc'   : desc,
            'unwritten': unwritten,
            }
        )

    def load_user_defined_variables(self, user_defined_variables_path):
        pass

    def load_test_list(self, test_list_path):
        exec(open(test_list_path).read(), self.user_variables, self.user_variables)

    def print_full_test_list(self):
        pprint (self.test_list)

    def get_test_list(self):
        ##print "In, get_test_list"
        return list(self.test_list)

    def get_test_list(self, test_selector_function):
        ##print "TestPlan::get_test_list:test_selector_function"
        selected_test_list = []
        for test_dict in self.test_list:
            #pprint (test_dict)
            (selected, no_error) = test_selector_function(test_dict)
            if ((1 == selected) and (1 == no_error)):
                selected_test_list.append(test_dict)
        return selected_test_list

    def get_test_list(self, test_selector_function, **kwargs):
        ##print "TestPlan::get_test_list:test_selector_function, **kwargs"
        selected_test_list = []
        for test_dict in self.test_list:
            #pprint (test_dict)
            if (len(kwargs)>0):
                (selected, no_error) = test_selector_function(test_dict, **kwargs)
            else:
                (selected, no_error) = test_selector_function(test_dict)
            ##print "TestPlan::get_test_list:test_selector_function, selected:%d, no_error:%d" % (selected, no_error)
            if ((1 == selected) and (1 == no_error)):
                selected_test_list.append(dict(test_dict))
        return selected_test_list

    def update_test_list(self, test_selector_function):
        self.test_list = self.get_test_list(test_selector_function)

    def update_test_list(self, test_selector_function, **kwargs):
        self.test_list = self.get_test_list(test_selector_function, **kwargs)

    def set_log_checker(self, log_checker_dict):
        #self.log_checker_dict.update(log_checker_dict)
        updated_tb = []
        new_added_tb = []
        for tb in log_checker_dict.keys():
            if tb in self.log_checker_dict:
                updated_tb.append(tb)
            else:
                new_added_tb.append(tb)
            self.log_checker_dict[tb] = log_checker_dict[tb]
        if len(updated_tb)>0:
            print("TestPlan::set_log_checker, updated log checker setting for following test bench:"+','.join(updated_tb))
        if len(new_added_tb)>0:
            print("TestPlan::set_log_checker, add log checker setting for following test bench:"+','.join(new_added_tb))

    def set_test_bench_filter(self, test_bench_list):
        print("TestPlan::setup test bench filters, valid test benchs are: %s" % ','.join(test_bench_list))
        self.test_bench_list = list(test_bench_list)

    def update_test_list_by_test_bench(self):
        self.test_list = self.get_test_list(test_selector_with_test_bench, test_bench_list=self.test_bench_list)

    def get_ref_path_to_tree_root(self, rel_path_to_tree_root = '.'):
        # there is a file named LICENSE, it's the marker of tree root
        tree_root_marker_path = os.path.join(rel_path_to_tree_root, 'LICENSE')
        if os.path.isfile(tree_root_marker_path) is False:
            rel_path_to_tree_root = os.path.join('..', rel_path_to_tree_root)
            rel_path_to_tree_root = self.get_ref_path_to_tree_root(rel_path_to_tree_root)
        return rel_path_to_tree_root

    def get_abs_path_to_tree_root(self):
        return os.path.abspath(self.get_ref_path_to_tree_root())

def test_selector_pri_mem(testDict):
    ##print "test_selector_pri_mem:testDict"
    ##pprint (testDict)
    if 'tags' in testDict and ('pri_mem' in testDict['tags']):
        return (1,1)
    return (0,1)

def test_selector_with_arg(testDict, **kwargs):
    tag_list = kwargs.get('tag_list',[])
    if 'tags' in testDict:
        for tag in tag_list:
            if (tag in testDict['tags']):
                return (1,1)
    return (0,1)

def test_selector_with_test_bench(testDict, **kwargs):
    #print "test_selector_with_test_bench, testDict"
    #print testDict
    test_bench_list = kwargs.get('test_bench_list',[])
    if 'config' in testDict:
        for test_bench in test_bench_list:
            if (test_bench in testDict['config']):
                return (1,1)
    return (0,1)

## testing
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__DESCRIPTION__)
    parser.add_argument('--test_list', dest='test_list', required=True,
                        help='Specify test plan file')
    config = vars ( parser.parse_args() )
    #pprint (config)
    # execfile (config['test_list'])
    # pprint (test_list)
    test_plan = TestPlan()
    test_plan.load_test_list(config['test_list'])
    test_plan.set_log_checker({'uvm_tb':'tbd'})
    test_plan.set_log_checker({'uvm_tb':'hahaha'})
    #test_plan.print_full_test_list()
    print('Select tests with pri_mem tag')
    pprint (test_plan.get_test_list(test_selector_pri_mem))
    print('Select tests with a list tag [cc, sdp]')
    tag_list=['cc','sdp']
    pprint (test_plan.get_test_list(test_selector_with_arg, tag_list=tag_list))
