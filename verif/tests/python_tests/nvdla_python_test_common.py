#!/usr/bin/env python
import os
import sys
sys.path.append('../nvdla_test') 
from nvdla_test import NvdlaTest
def creat_test(path, project):
    test_dir  = os.path.dirname(os.path.realpath(path))
    test_name = os.path.basename(os.path.splitext(path)[0])
    test = NvdlaTest(test_name)
    py_test_dir  = os.path.dirname(__file__)
    test.load_register_manual_file(os.path.join(py_test_dir, "../../../outdir", project, "spec/manual/opendla.py"))
    test.load_project_define_file (os.path.join(py_test_dir, "../../../outdir", project, "spec/defs/project.py"))
    test_shortcut = {}
    test_shortcut['address_lsb_mask_bits'] = test._address_lsb_mask_bits
    return test, test_name, dict(test_shortcut)

def generate_trace(test, test_name):
    test.compose_test()
    test.generate_trace_config_file(test_name)
    test.generate_dino_config_file(test_name+"_scve")

#if __name__ == "__main__":
#    creat_test(__file__)
