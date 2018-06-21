#!/usr/bin/env python
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).absolute().parents[1]/'nvdla_test')) 
from nvdla_base_test import NvdlaBaseTest

class nvdla_reg_accesing(NvdlaBaseTest):
    def __init__(self, project, trace_dir, pattern_list=[0x00000000, 0xFFFFFFFF, 0x5A5A5A5A, 0xA5A5A5A5]):
        self._pattern_list = pattern_list
        print('Enter nvdla_reg_accesing init')
        super(nvdla_reg_accesing, self).__init__(project, trace_dir, Path(__file__).stem)

    def bypass_block(self, block):
        self._trace_config.append('// Bypass block %s' % block)

    def write_read_check_single_group(self, block):
        bypass_register_list = (
                "D_OP_ENABLE_0",
                "S_STATUS_0",
                "S_POINTER_0",
                "SWRESET_0",
                "S_LUT_ACCESS_DATA_0",
                "CFG_LAUNCH0_0",
                "CFG_LAUNCH0_1",
                "CFG_OP_0",
                )
        for register in self._register_manual_dict['registers'][block]['register_list']:
            if self._register_manual_dict['registers'][block][register]['write_mask'] == 0:
                # read only register
                continue
            if register in bypass_register_list:
                self._trace_config.append('// Bypass %s' % '.'.join([block, register]))
                continue
            for write_value in self._pattern_list:
                self.reg_write(block, register, write_value)
                self.reg_read_check(block, register, write_value)

    def write_read_check_double_group(self, block):
        bypass_register_list = (
                "D_OP_ENABLE_0",
                "S_STATUS_0",
                "S_POINTER_0",
                "SWRESET_0",
                "S_LUT_ACCESS_DATA_0",
                "CFG_LAUNCH0_0",
                "CFG_LAUNCH0_1",
                "CFG_OP_0",
                )
        self.reg_write(block, 'S_POINTER_0', 0x0)
        self.reg_read_check(block, 'S_POINTER_0', 0x0)
        for register in self._register_manual_dict['registers'][block]['register_list']:
            if self._register_manual_dict['registers'][block][register]['write_mask'] == 0:
                # read only register
                continue
            if register in bypass_register_list:
                self._trace_config.append('// Bypass %s' % '.'.join([block, register]))
                continue
            for write_value in self._pattern_list:
                self.reg_write(block, register, write_value)
                self.reg_read_check(block, register, write_value)
        self.reg_write(block, 'S_POINTER_0', 0x1)
        self.reg_read_check(block, 'S_POINTER_0', 0x1)
        for register in self._register_manual_dict['registers'][block]['register_list']:
            if self._register_manual_dict['registers'][block][register]['write_mask'] == 0:
                # read only register
                continue
            if register in bypass_register_list:
                self._trace_config.append('// Bypass %s' % '.'.join([block, register]))
                continue
            for write_value in self._pattern_list:
                self.reg_write(block, register, write_value)
                self.reg_read_check(block, register, write_value)

    def check_reset_value(self):
        bug_list = [
                #'NVDLA_SDP_RDMA_D_BRDMA_CFG_0',
                #'NVDLA_SDP_RDMA_D_NRDMA_CFG_0',
                #'NVDLA_SDP_RDMA_D_ERDMA_CFG_0',
                ]
        conditional_build_block = {
                'NVDLA_CVIF':'NVDLA_SECONDARY_MEMIF_DISABLE',
                'NVDLA_BDMA':'NVDLA_BDMA_ENABLE',
                'NVDLA_RBK':'NVDLA_RBK_ENABLE',
                'NVDLA_PDP':'NVDLA_PDP_ENABLE',
                'NVDLA_CDP':'NVDLA_CDP_ENABLE',
                'NVDLA_GEC':'NVDLA_GEC_ENABLE',
                }
        for block in self._register_manual_dict['registers']:
            if block in conditional_build_block:
                if conditional_build_block[block] not in self._project_define_dict:
                    continue
            for register in self._register_manual_dict['registers'][block]['register_list']:
                block_reg = '_'.join([block, register])
                if block_reg in bug_list:
                    self.trace_comment("Bug in %s" % block_reg)
                    continue
                reset_value = self._register_manual_dict['registers'][block][register]['reset_val']
                reset_mask  = self._register_manual_dict['registers'][block][register]['reset_mask']
                check_value = reset_value & reset_mask
                #print('Reg:%s, reset_value:%s, reset_mask:%s, read_mask:%s, check_value:%s' % (register, reset_value, reset_mask, read_mask, check_value))
                self.reg_read_check(block, register, check_value)

    def write_read_check(self):
        block_check = {
                'NVDLA_CFGROM':self.write_read_check_single_group,
                'NVDLA_MCIF':self.write_read_check_single_group,
                'NVDLA_CVIF':self.write_read_check_single_group,
                'NVDLA_BDMA':self.write_read_check_single_group,
                'NVDLA_GLB': lambda x: "nothing",
                'NVDLA_GEC': lambda x: "nothing",
                }
        conditional_build_block = {
                'NVDLA_CVIF':'NVDLA_SECONDARY_MEMIF_DISABLE',
                'NVDLA_BDMA':'NVDLA_BDMA_ENABLE',
                'NVDLA_RBK':'NVDLA_RBK_ENABLE',
                'NVDLA_PDP':'NVDLA_PDP_ENABLE',
                'NVDLA_CDP':'NVDLA_CDP_ENABLE',
                }
        for block in self._register_manual_dict['registers']:
            if block in conditional_build_block:
                if conditional_build_block[block] not in self._project_define_dict:
                    continue
            block_check_func = block_check.get(block, self.write_read_check_double_group)
            block_check_func(block)
            self.sync_notify(block, block+'_done')
            self.check_nothing(block+'_done')

    def compose_test(self):
        self.check_reset_value()
        self.write_read_check()

def run(project, trace_dir):
    reg_test = nvdla_reg_accesing(project, trace_dir)
    reg_test.compose_test()
    reg_test.generate_trace()

if __name__ == "__main__":
    run(sys.argv[1], sys.argv[2])
