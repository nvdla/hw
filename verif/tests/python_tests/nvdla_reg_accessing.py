#!/usr/bin/env python
import os
import sys
sys.path.append('../nvdla_test') 
from nvdla_base_test import NvdlaBaseTest

class nvdla_reg_accesing(NvdlaBaseTest):
    def __init__(self, project, trace_dir, pattern_list=[0x00000000, 0xFFFFFFFF, 0x5A5A5A5A, 0xA5A5A5A5]):
        self._pattern_list = pattern_list
        print('Enter nvdla_reg_accesing init')
        super(nvdla_reg_accesing, self).__init__(project, trace_dir, __file__[:-3])

    def check_reset_value(self):
        for block in self._register_manual_dict['registers']:
            for register in self._register_manual_dict['registers'][block]['register_list']:
                reset_value = self._register_manual_dict['registers'][block][register]['reset_val']
                reset_mask  = self._register_manual_dict['registers'][block][register]['reset_mask']
                read_mask   = self._register_manual_dict['registers'][block][register]['read_mask']
                self._trace_config.append('read_check(%s, %s);' % ('.'.join([block, register]), hex(reset_value & reset_mask & read_mask)))

    def write_read_check_single_group(self, block):
        for register in self._register_manual_dict['registers'][block]['register_list']:
            for write_value in self._pattern_list:
                self.reg_write(block, register, write_value)
                self.reg_read_check(block, register, write_value)

        if(reg_name == "D_OP_ENABLE_0" || reg_name == "SWRESET_0") begin
            continue;
        end
        else if(reg_name == "S_LUT_ACCESS_DATA_0") begin
            continue;
        end
        else if(reg_name == "CFG_LAUNCH0_0" || reg_name == "CFG_LAUNCH1_0" || reg_name == "CFG_OP_0") begin
            continue;
        end

    def write_read_check_double_group(self, block):
        bypass_register_list = [
                "D_OP_ENABLE_0",
                "SWRESET_0",
                "S_LUT_ACCESS_DATA_0",
                "CFG_LAUNCH0_0",
                "CFG_LAUNCH0_1",
                "CFG_OP_0",
                ]
        self.reg_write(block, 'S_POINTER_0', 0x0)
        self.reg_read_check(block, 'S_POINTER_0', 0x0)
        for register in self._register_manual_dict['registers'][block]['register_list']:
            if any(list(register == i for i in bypass_register_list)):
                continue
            for write_value in self._pattern_list:
                self.reg_write(block, register, write_value)
                self.reg_read_check(block, register, write_value)
        self.reg_write(block, 'S_POINTER_0', 0x1)
        self.reg_read_check(block, 'S_POINTER_0', 0x1)
        for register in self._register_manual_dict['registers'][block]['register_list']:
            if register.startswith('D_') and register != 'D_OP_ENABLE_0':
                for write_value in self._pattern_list:
                    self.reg_write(block, register, write_value)
                    self.reg_read_check(block, register, write_value)

    def write_read_check(self):
        block_check = {
                }
        for block in self._register_manual_dict['registers']:
            block_check[block]()

    def compose_test(self):
        self.check_reset_value()
        self.write_read_check()

def run(project, trace_dir):
    reg_test = nvdla_reg_accesing(project, trace_dir)
    reg_test.compose_test()
    reg_test.generate_trace()

if __name__ == "__main__":
    run('nv_small', '.')
