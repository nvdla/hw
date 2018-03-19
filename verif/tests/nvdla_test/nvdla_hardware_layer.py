#!/usr/bin/env python
from nvdla_register_configuration import NvdlaRegisterConfiguration
from pprint import pprint

class NvdlaHardwareLayer (NvdlaRegisterConfiguration):
    __description__ = '''
    1. set_scenario
    1.1. generate_field_variables_from_register_configuration
    1.1.1. generate_field_name_register_name_map
    2. update_layer_setting
    2.1.  update_field_variable_from_dict
    3. Setup up dependency
    3.1  Set producer
    3.2  Set interrupt dependency
    4. generate_layer_configuration
    4.1. update_register_configuration_from_field_variable
    4. get_layer_configuration_dict
'''
    _scenario_block_dict_of_list = {
                                "CONV_SDP" : ["NVDLA_CDMA", "NVDLA_CSC", "NVDLA_CMAC_A", "NVDLA_CMAC_B", "NVDLA_CACC", "NVDLA_SDP"],
                                "CONV_SDP_RDMA_SDP" : ["NVDLA_CDMA", "NVDLA_CSC", "NVDLA_CMAC_A", "NVDLA_CMAC_B", "NVDLA_CACC", "NVDLA_SDP_RDMA", "NVDLA_SDP"],
                                "CONV_SDP_PDP" : ["NVDLA_CDMA", "NVDLA_CSC", "NVDLA_CMAC_A", "NVDLA_CMAC_B", "NVDLA_CACC", "NVDLA_SDP", "NVDLA_PDP"],
                                "CONV_SDP_RDMA_SDP_PDP" : ["NVDLA_CDMA", "NVDLA_CSC", "NVDLA_CMAC_A", "NVDLA_CMAC_B", "NVDLA_CACC", "NVDLA_SDP_RDMA", "NVDLA_SDP", "NVDLA_PDP"],
                                "SDP" : ["NVDLA_SDP_RDMA", "NVDLA_SDP"],
                                "PDP" : ["NVDLA_PDP_RDMA", "NVDLA_PDP"],
                                "CDP" : ["NVDLA_CDP_RDMA", "NVDLA_CDP"],
                                "SDP_PDP" : ["NVDLA_SDP_RDMA", "NVDLA_SDP", "NVDLA_PDP"],
                                "BDMA" : ["NVDLA_BDMA"],
                                "RUBIK" : ["NVDLA_RBK"],
                                }
    _scenario_memory_block_dict_of_list = {
                                "CONV_SDP" : {"NVDLA_CDMA":set(['input','weight','wmb','wgs']), "NVDLA_SDP":set(['output'])},
                                "CONV_SDP_RDMA_SDP" : {"NVDLA_CDMA":set(['input','weight','wmb','wgs']), "NVDLA_SDP_RDMA":set(['input','bs','bn','ew']), "NVDLA_SDP":set(['output'])},
                                "CONV_SDP_PDP" : {"NVDLA_CDMA":set(['input','weight','wmb','wgs']), "NVDLA_PDP":set(['output'])},
                                "CONV_SDP_RDMA_SDP_PDP" : {"NVDLA_CDMA":set(['input','weight','wmb','wgs']), "NVDLA_SDP_RDMA":set(['input','bs','bn','ew']), "NVDLA_PDP":set(['output'])},
                                "SDP" : {"NVDLA_SDP_RDMA":set(['input','bs','bn','ew']), "NVDLA_SDP":set(['output'])},
                                "PDP" : {"NVDLA_PDP_RDMA":set(['input']), "NVDLA_PDP":set(['output'])},
                                "CDP" : {"NVDLA_CDP_RDMA":set(['input']), "NVDLA_CDP":set(['output'])},
                                "SDP_PDP" : {"NVDLA_SDP_RDMA":set(['input','bs','bn','ew']), "NVDLA_PDP":set(['output'])},
                                "BDMA" : {"NVDLA_BDMA":set(['input'])},
                                "RUBIK" : {"NVDLA_RBK":set(['input'])},
                                }
    _scenario_lut_table_dict = {
                                "CONV_SDP" : {"NVDLA_SDP":set(['LE','LO'])},
                                "CONV_SDP_RDMA_SDP" : {"NVDLA_SDP":set(['LE','LO'])},
                                "CONV_SDP_PDP" : {"NVDLA_SDP":set(['LE','LO'])},
                                "CONV_SDP_RDMA_SDP_PDP" : {"NVDLA_SDP":set(['LE','LO'])},
                                "SDP" : {"NVDLA_SDP":set(['LE','LO'])},
                                "CDP" : {"NVDLA_CDP":set(['LE','LO'])},
                                "SDP_PDP" : {"NVDLA_SDP":set(['LE','LO'])},
                                }
    _scenario_interrupt_dict = {
                                "CONV_SDP" : ["NVDLA_CDMA", "NVDLA_CACC", "NVDLA_SDP"],
                                "CONV_SDP_RDMA_SDP" : ["NVDLA_CDMA", "NVDLA_CACC", "NVDLA_SDP"],
                                "CONV_SDP_PDP" : ["NVDLA_CDMA", "NVDLA_CACC", "NVDLA_SDP", "NVDLA_PDP"],
                                "CONV_SDP_RDMA_SDP_PDP" : ["NVDLA_CDMA", "NVDLA_CACC", "NVDLA_SDP", "NVDLA_PDP"],
                                "SDP" : ["NVDLA_SDP"],
                                "PDP" : ["NVDLA_PDP"],
                                "CDP" : ["NVDLA_CDP"],
                                "SDP_PDP" : ["NVDLA_PDP"],
                                "BDMA" : ["NVDLA_BDMA"],
                                "RUBIK" : ["NVDLA_RBK"],
                                }
    _scenario_operation_enable_dict = {
                                        "CONV_SDP" : [
                                            [
                                                {
                                                    "block_name":"NVDLA_CDMA",
                                                    "register_name":"NVDLA_CDMA.D_OP_ENABLE_0",
                                                    "depended_sync_id":[],
                                                    "generated_sync_id":None,
                                                },
                                            ],
                                            [
                                               {    "block_name":"NVDLA_CACC",
                                                    "register_name":"NVDLA_CACC.D_OP_ENABLE_0",
                                                    "depended_sync_id":[],
                                                    "generated_sync_id": 'NVDLA_CACC_D_OP_ENABLE_0'
                                               },
                                               {    "block_name":"NVDLA_CMAC_A",
                                                    "register_name":"NVDLA_CMAC_A.D_OP_ENABLE_0",
                                                    "depended_sync_id":['NVDLA_CACC_D_OP_ENABLE_0'],
                                                    "generated_sync_id": 'NVDLA_CMAC_A_D_OP_ENABLE_0'
                                               },
                                               {    "block_name":"NVDLA_CMAC_B",
                                                    "register_name":"NVDLA_CMAC_B.D_OP_ENABLE_0",
                                                    "depended_sync_id":['NVDLA_CACC_D_OP_ENABLE_0'],
                                                    "generated_sync_id": 'NVDLA_CMAC_B_D_OP_ENABLE_0'
                                               },
                                               {    "block_name":"NVDLA_CSC",
                                                    "register_name":"NVDLA_CSC.D_OP_ENABLE_0",
                                                    "depended_sync_id":['NVDLA_CMAC_A_D_OP_ENABLE_0','NVDLA_CMAC_B_D_OP_ENABLE_0'],
                                                    "generated_sync_id":None,
                                               },
                                            ],
                                            [
                                                {    "block_name":"NVDLA_SDP",
                                                     "register_name":"NVDLA_SDP.D_OP_ENABLE_0",
                                                     "depended_sync_id":[],
                                                     "generated_sync_id":None,
                                                },
                                            ],
                                        ],
                                        "CONV_SDP_RDMA_SDP" : [
                                            [
                                                {
                                                    "block_name":"NVDLA_CDMA",
                                                    "register_name":"NVDLA_CDMA.D_OP_ENABLE_0",
                                                    "depended_sync_id":[],
                                                    "generated_sync_id":None,
                                                },
                                            ],
                                            [
                                               {    "block_name":"NVDLA_CACC",
                                                    "register_name":"NVDLA_CACC.D_OP_ENABLE_0",
                                                    "depended_sync_id":[],
                                                    "generated_sync_id": 'NVDLA_CACC_D_OP_ENABLE_0'
                                               },
                                               {    "block_name":"NVDLA_CMAC_A",
                                                    "register_name":"NVDLA_CMAC_A.D_OP_ENABLE_0",
                                                    "depended_sync_id":['NVDLA_CACC_D_OP_ENABLE_0'],
                                                    "generated_sync_id": 'NVDLA_CMAC_A_D_OP_ENABLE_0'
                                               },
                                               {    "block_name":"NVDLA_CMAC_B",
                                                    "register_name":"NVDLA_CMAC_B.D_OP_ENABLE_0",
                                                    "depended_sync_id":['NVDLA_CACC_D_OP_ENABLE_0'],
                                                    "generated_sync_id": 'NVDLA_CMAC_B_D_OP_ENABLE_0'
                                               },
                                               {    "block_name":"NVDLA_CSC",
                                                    "register_name":"NVDLA_CSC.D_OP_ENABLE_0",
                                                    "depended_sync_id":['NVDLA_CMAC_A_D_OP_ENABLE_0','NVDLA_CMAC_B_D_OP_ENABLE_0'],
                                                    "generated_sync_id":None,
                                               },
                                            ],
                                            [
                                                {    "block_name":"NVDLA_SDP_RDMA",
                                                     "register_name":"NVDLA_SDP_RDMA.D_OP_ENABLE_0",
                                                     "depended_sync_id":[],
                                                     "generated_sync_id":None,
                                                },
                                            ],
                                            [
                                                {    "block_name":"NVDLA_SDP",
                                                     "register_name":"NVDLA_SDP.D_OP_ENABLE_0",
                                                     "depended_sync_id":[],
                                                     "generated_sync_id":None,
                                                },
                                            ],
                                        ],
                                        "CONV_SDP_PDP" : [
                                            [
                                                {
                                                    "block_name":"NVDLA_CDMA",
                                                    "register_name":"NVDLA_CDMA.D_OP_ENABLE_0",
                                                    "depended_sync_id":[],
                                                    "generated_sync_id":None,
                                                },
                                            ],
                                            [
                                               {    "block_name":"NVDLA_CACC",
                                                    "register_name":"NVDLA_CACC.D_OP_ENABLE_0",
                                                    "depended_sync_id":[],
                                                    "generated_sync_id": 'NVDLA_CACC_D_OP_ENABLE_0'
                                               },
                                               {    "block_name":"NVDLA_CMAC_A",
                                                    "register_name":"NVDLA_CMAC_A.D_OP_ENABLE_0",
                                                    "depended_sync_id":['NVDLA_CACC_D_OP_ENABLE_0'],
                                                    "generated_sync_id": 'NVDLA_CMAC_A_D_OP_ENABLE_0'
                                               },
                                               {    "block_name":"NVDLA_CMAC_B",
                                                    "register_name":"NVDLA_CMAC_B.D_OP_ENABLE_0",
                                                    "depended_sync_id":['NVDLA_CACC_D_OP_ENABLE_0'],
                                                    "generated_sync_id": 'NVDLA_CMAC_B_D_OP_ENABLE_0'
                                               },
                                               {    "block_name":"NVDLA_CSC",
                                                    "register_name":"NVDLA_CSC.D_OP_ENABLE_0",
                                                    "depended_sync_id":['NVDLA_CMAC_A_D_OP_ENABLE_0','NVDLA_CMAC_B_D_OP_ENABLE_0'],
                                                    "generated_sync_id":None,
                                               },
                                            ],
                                            [
                                                {    "block_name":"NVDLA_SDP",
                                                     "register_name":"NVDLA_SDP.D_OP_ENABLE_0",
                                                     "depended_sync_id":[],
                                                     "generated_sync_id":None,
                                                },
                                            ],
                                            [
                                                {    "block_name":"NVDLA_PDP",
                                                     "register_name":"NVDLA_PDP.D_OP_ENABLE_0",
                                                     "depended_sync_id":[],
                                                     "generated_sync_id":None,
                                                },
                                            ],
                                        ],
                                        "CONV_SDP_RDMA_SDP_PDP" : [
                                            [
                                                {
                                                    "block_name":"NVDLA_CDMA",
                                                    "register_name":"NVDLA_CDMA.D_OP_ENABLE_0",
                                                    "depended_sync_id":[],
                                                    "generated_sync_id":None,
                                                },
                                            ],
                                            [
                                               {    "block_name":"NVDLA_CACC",
                                                    "register_name":"NVDLA_CACC.D_OP_ENABLE_0",
                                                    "depended_sync_id":[],
                                                    "generated_sync_id": 'NVDLA_CACC_D_OP_ENABLE_0'
                                               },
                                               {    "block_name":"NVDLA_CMAC_A",
                                                    "register_name":"NVDLA_CMAC_A.D_OP_ENABLE_0",
                                                    "depended_sync_id":['NVDLA_CACC_D_OP_ENABLE_0'],
                                                    "generated_sync_id": 'NVDLA_CMAC_A_D_OP_ENABLE_0'
                                               },
                                               {    "block_name":"NVDLA_CMAC_B",
                                                    "register_name":"NVDLA_CMAC_B.D_OP_ENABLE_0",
                                                    "depended_sync_id":['NVDLA_CACC_D_OP_ENABLE_0'],
                                                    "generated_sync_id": 'NVDLA_CMAC_B_D_OP_ENABLE_0'
                                               },
                                               {    "block_name":"NVDLA_CSC",
                                                    "register_name":"NVDLA_CSC.D_OP_ENABLE_0",
                                                    "depended_sync_id":['NVDLA_CMAC_A_D_OP_ENABLE_0','NVDLA_CMAC_B_D_OP_ENABLE_0'],
                                                    "generated_sync_id":None,
                                               },
                                            ],
                                            [
                                                {    "block_name":"NVDLA_SDP_RDMA",
                                                     "register_name":"NVDLA_SDP_RDMA.D_OP_ENABLE_0",
                                                     "depended_sync_id":[],
                                                     "generated_sync_id":None,
                                                },
                                            ],
                                            [
                                                {    "block_name":"NVDLA_SDP",
                                                     "register_name":"NVDLA_SDP.D_OP_ENABLE_0",
                                                     "depended_sync_id":[],
                                                     "generated_sync_id":None,
                                                },
                                            ],
                                            [
                                                {    "block_name":"NVDLA_PDP",
                                                     "register_name":"NVDLA_PDP.D_OP_ENABLE_0",
                                                     "depended_sync_id":[],
                                                     "generated_sync_id":None,
                                                },
                                            ],
                                        ],
                                        "SDP" : [
                                            [
                                                {    "block_name":"NVDLA_SDP_RDMA",
                                                     "register_name":"NVDLA_SDP_RDMA.D_OP_ENABLE_0",
                                                     "depended_sync_id":[],
                                                     "generated_sync_id":None,
                                                },
                                            ],
                                            [
                                                {    "block_name":"NVDLA_SDP",
                                                     "register_name":"NVDLA_SDP.D_OP_ENABLE_0",
                                                     "depended_sync_id":[],
                                                     "generated_sync_id":None,
                                                },
                                            ],
                                        ],
                                        "PDP" : [
                                            [
                                                {    "block_name":"NVDLA_PDP_RDMA",
                                                     "register_name":"NVDLA_PDP_RDMA.D_OP_ENABLE_0",
                                                     "depended_sync_id":[],
                                                     "generated_sync_id":None,
                                                },
                                            ],
                                            [
                                                {    "block_name":"NVDLA_PDP",
                                                     "register_name":"NVDLA_PDP.D_OP_ENABLE_0",
                                                     "depended_sync_id":[],
                                                     "generated_sync_id":None,
                                                },
                                            ],
                                        ],
                                        "CDP" : [
                                            [
                                                #{    "block_name":"NVDLA_CDP_RDMA",
                                                #     "register_name":"NVDLA_CDP_RDMA.D_OP_ENABLE_0",
                                                #     "depended_sync_id":[],
                                                #     "generated_sync_id":"NVDLA_CDP_RDMA_D_OP_ENABLE_0",
                                                #},
                                                {    "block_name":"NVDLA_CDP_RDMA",
                                                     "register_name":"NVDLA_CDP_RDMA.D_OP_ENABLE_0",
                                                     "depended_sync_id":[],
                                                     "generated_sync_id":None,
                                                },
                                            ],
                                            [
                                                #{    "block_name":"NVDLA_CDP",
                                                #     "register_name":"NVDLA_CDP.D_OP_ENABLE_0",
                                                #     "depended_sync_id":["NVDLA_CDP_RDMA_D_OP_ENABLE_0"],
                                                #     "generated_sync_id":None,
                                                #},
                                                {    "block_name":"NVDLA_CDP",
                                                     "register_name":"NVDLA_CDP.D_OP_ENABLE_0",
                                                     "depended_sync_id":[],
                                                     "generated_sync_id":None,
                                                },
                                            ],
                                        ],
                                        "SDP_PDP" : [
                                            [
                                                {    "block_name":"NVDLA_SDP_RDMA",
                                                     "register_name":"NVDLA_SDP_RDMA.D_OP_ENABLE_0",
                                                     "depended_sync_id":[],
                                                     "generated_sync_id":None,
                                                },
                                            ],
                                            [
                                                {    "block_name":"NVDLA_PDP_RDMA",
                                                     "register_name":"NVDLA_PDP_RDMA.D_OP_ENABLE_0",
                                                     "depended_sync_id":[],
                                                     "generated_sync_id":None,
                                                },
                                            ],
                                            [
                                                {    "block_name":"NVDLA_PDP",
                                                     "register_name":"NVDLA_PDP.D_OP_ENABLE_0",
                                                     "depended_sync_id":[],
                                                     "generated_sync_id":None,
                                                },
                                            ],
                                        ],
#                                        "BDMA" : [
#                                        ],
                                        "RUBIK" : [
                                            [
                                                {    "block_name":"NVDLA_RBK",
                                                     "register_name":"NVDLA_RBK.D_OP_ENABLE_0",
                                                     "depended_sync_id":[],
                                                     "generated_sync_id":None,
                                                },
                                            ],
                                        ],
    }
    _scenario_resource_map = {
                                "CONV_SDP" : {
                                    "NVDLA_CDMA":[],
                                    "NVDLA_CACC":["NVDLA_CMAC_A", "NVDLA_CMAC_B","NVDLA_CSC"],
                                    "NVDLA_SDP":[],
                                },
                                "CONV_SDP_RDMA_SDP" : {
                                    "NVDLA_CDMA":[],
                                    "NVDLA_CACC":["NVDLA_CMAC_A", "NVDLA_CMAC_B","NVDLA_CSC"],
                                    "NVDLA_SDP":["NVDLA_SDP_RDMA"],
                                },
                                "CONV_SDP_PDP" : {
                                    "NVDLA_CDMA":[],
                                    "NVDLA_CACC":["NVDLA_CMAC_A", "NVDLA_CMAC_B","NVDLA_CSC"],
                                    "NVDLA_SDP":[],
                                    "NVDLA_PDP":[],
                                },
                                "CONV_SDP_RDMA_SDP_PDP" : {
                                    "NVDLA_CDMA":[],
                                    "NVDLA_CACC":["NVDLA_CMAC_A", "NVDLA_CMAC_B","NVDLA_CSC"],
                                    "NVDLA_SDP":["NVDLA_SDP_RDMA"],
                                    "NVDLA_PDP":[],
                                },
                                "SDP" : {
                                    "NVDLA_SDP":["NVDLA_SDP_RDMA"],
                                },
                                "PDP" : {
                                    "NVDLA_PDP":["NVDLA_PDP_RDMA"],
                                },
                                "CDP" : {
                                    "NVDLA_CDP":["NVDLA_CDP_RDMA"],
                                },
                                "SDP_PDP" : {
                                    "NVDLA_SDP":["NVDLA_SDP_RDMA"],
                                    "NVDLA_PDP":[],
                                },
                                "BDMA" :{
                                    "NVDLA_BDMA":[],
                                },
                                "RUBIK" : {
                                    "NVDLA_RBK":[],
                                },
    }
    #_scenario_interrupt_dict = {scenario:self._scenario_resource_map[scenario].keys() for scenario in self._scenario_resource_map.keys()}
    _field_prefix_block_dict = {
                                "NVDLA_CDMA":"cc.",
                                "NVDLA_CSC":"cc.",
                                "NVDLA_CMAC_A":"cc.",
                                "NVDLA_CMAC_B":"cc.",
                                "NVDLA_CACC":"cc.",
                                "NVDLA_SDP_RDMA":"sdp.",
                                "NVDLA_SDP":"sdp.",
                                "NVDLA_PDP_RDMA":"pdp.",
                                "NVDLA_PDP":"pdp.",
                                "NVDLA_CDP_RDMA":"cdp.",
                                "NVDLA_CDP":"cdp.",
    }


    # Initialize with instance name
    def __init__(self, name, manual, project_define):
        self._name = name
        self._scenario = None
        self._activated_register_block_list = None # block in selected scenario
        self._activated_interrupt_list = None      # interrupt block in selected scenario
        self._activated_field_prefix_set = set()
        self._field_variable_block_dict = {}
        self._field_variable_dict = {}
        self._edited_field_variable_dict = {}
        self._block_index_dict = {}              # key: block_name, value: block_index
        self._functional_configuration_dict = {}
        self._block_dependency_sync_id_dict = {} # Tree dependency: key: block name, value: sync_id. To generate, sync_notify(block_name, sync_id), sync_wait(block_name, sync_id)
        self._producer_pointer_dict = {}
        self._operation_enable_list = []
        self._interrupt_id_dict = {}             # key: intr_id in GLB, value: sync_id. To generate intr_notify(intr_id, sync_id)
        self._result_checker_dict = {}
        self._memory_surface_dict = {}           # Memory surface setting, to memory space generator for surface content generation
        self._project_define = {}
        self._memory_setting = {}
        self._lut_table_setting = {}
        self._lut_data_config = {}
        self.load_register_manual(manual)
        self.load_project_define(project_define)
        
    # Set hardware layer scenario
    def set_scenario(self, scenario_name):
        self._activated_register_block_list = list(self._scenario_block_dict_of_list[scenario_name])
        self._activated_interrupt_list = list(self._scenario_interrupt_dict[scenario_name])
        self._scenario = scenario_name
        for register_block in self._activated_register_block_list:
            self.set_block_enable(register_block)
        self.generate_field_variables_from_register_configuration()
    
    def get_scenario(self):
        return self._scenario

    def load_project_define(self, project_define):
        self._project_define = dict(project_define)
        self._memory_atom_element_num = int(self._project_define['NVDLA_MEMORY_ATOMIC_SIZE'])

    # Update layer configuration
    def update_layer_setting(self, config_dict):
        self._update_field_variable_from_dict(config_dict)

    def update_layer_memory(self, setting_dict):
        self._memory_setting = dict(setting_dict)

    def update_layer_lut_table(self, setting_dict):
        self._lut_table_setting = dict(setting_dict)

    def _generate_layer_configuration(self):
        self._update_register_configuration_from_field_variable()
        for block_name in self._activated_register_block_list:
            for register_name in self._register[block_name]['register_list']:
                # Ignore none writtern register
                if 0 == self._register[block_name][register_name]['write_mask']:
                    continue
                # Ignore producer pointer
                if "S_POINTER_0" == register_name:
                    continue
                # Ignore operation enable
                if "D_OP_ENABLE_0" == register_name:
                    continue
                register_config_name = '.'.join([block_name, register_name])
                self._functional_configuration_dict[register_config_name] = {
                                    "value":self._register[block_name][register_name]["value"],
                                    "edited":self._register[block_name][register_name]["edited"],
                                    "field_config":{},
                                    }
                print ('_generate_layer_configuration::block_name:%s,register_name:%s,register_value:%s' % (block_name, register_name, hex(self._register[block_name][register_name]["value"])))
                for field_name in self._register[block_name][register_name]['field_list']:
                    if 0 != len(self._register[block_name][register_name][field_name]["enums"]):
                        swap_enums = {y:x for x,y in self._register[block_name][register_name][field_name]["enums"].items() }
                        self._functional_configuration_dict[register_config_name]["field_config"][field_name] = swap_enums[self._register[block_name][register_name][field_name]['value']]+' : '+hex(self._register[block_name][register_name][field_name]['value'])
                    else:
                        self._functional_configuration_dict[register_config_name]["field_config"][field_name] = hex(self._register[block_name][register_name][field_name]['value'])

    def get_resource_list(self):
        return list(self._activated_register_block_list)
    
    # Generate field variable
    def generate_field_variables_from_register_configuration(self):
        self.generate_field_name_register_name_map()
        for block_name in self._activated_register_block_list:
            field_prefix = block_name.replace("NVDLA_","").lower()+"." if block_name not in self._field_prefix_block_dict else self._field_prefix_block_dict[block_name]
            self._activated_field_prefix_set.add(field_prefix)
            for register_name in self._register[block_name]["register_list"]:
                for field_name in self._register[block_name][register_name]["field_list"]:
                    field_variable = field_prefix+field_name.lower()
                    self._field_variable_dict[field_prefix+field_name] = self._register[block_name][register_name][field_name]["default"]
                    if field_variable in self._field_variable_block_dict:
                        self._field_variable_block_dict[field_variable].append((block_name,register_name,field_name))
                    else:
                        self._field_variable_block_dict[field_variable]=[(block_name,register_name,field_name)]
        #print "self._field_variable_block_dict"
        #print (self._field_variable_block_dict)

    def validate_config_dict(self, config_dict):
        if type(config_dict) is dict:
            for field_variable in config_dict:
                if (field_variable not in self._field_variable_block_dict):
                    Exception("NvdlaHardwareLayer::validate_config_dict", "%s in config is not a valid variable"%field_variable)
        else:
            raise Exception("NvdlaHardwareLayer::validate_config_dict", "Parameter config is not a dict type")

    # Update field variable from dict
    def _update_field_variable_from_dict(self, config_dict):
        #print (config_dict)
        self.validate_config_dict(config_dict)
        ## self._field_variable_dict.update(config_dict)
        self._edited_field_variable_dict.update(dict(config_dict))

    # Update field variable to register config
    def _update_register_configuration_from_field_variable(self):
        for field_variable, field_value in self._edited_field_variable_dict.items():
            #print ("field_variable:%s,field_value:%s" % (field_variable,str(field_value)))
            for (block_name,register_name,field_name)  in self._field_variable_block_dict[field_variable]:
                print ("_update_register_configuration_from_field_variable::block_name:%s,register_name:%s,field_name:%s,field_value:%s" % (block_name,register_name,field_name,str(field_value)))
                self.set_field_value(block_name, register_name, field_name.upper(), field_value)
        for block_name in self._activated_register_block_list:        
            self.update_register_value_in_block(block_name)
    
    # Update block producer
    def set_block_index(self, block_name, block_index):
        if block_name in self._activated_register_block_list:
            self._block_index_dict[block_name] = block_index
            producer_value = block_index % 2
            self.set_field_value(block_name, "S_POINTER_0", "PRODUCER", producer_value)
            self.update_register_value_from_field(block_name, "S_POINTER_0")
            self._producer_pointer_dict["%s.S_POINTER_0" % (block_name)]=producer_value
        
    def set_block_dependency(self, block_name, sync_id_name):
        if block_name in self._activated_interrupt_list:
            self._block_dependency_sync_id_dict[block_name] = sync_id_name
            self._update_resource_dependence(block_name)
        
    def _update_resource_dependence(self, master_block_name):
        for slave_block_name_list in self._scenario_resource_map[self._scenario][master_block_name]:
            for slave_block_name in slave_block_name_list:
                self._block_dependency_sync_id_dict[slave_block_name] = self._block_dependency_sync_id_dict[master_block_name]

    def _evaluate_surface_setting(self, base_addr, width, height, channel, line_stride, surf_stride, ram_type, precision, pattern):
        setting = {}
        atom_byte_size = 0;
        if precision is 'INT8':
            atom_byte_size = self._memory_atom_element_num;
        elif precision is 'INT16':
            atom_byte_size = self._memory_atom_element_num*2;
        elif precision is 'FP16':
            atom_byte_size = self._memory_atom_element_num*2;
        surf_num = (channel + self._memory_atom_element_num - 1) // self._memory_atom_element_num
        size = surf_stride * surf_num
        setting['base_address'] = base_addr
        setting['size'] = size
        setting['pattern'] = pattern
        setting['precision'] = precision.upper()
        setting['element_per_atom'] = self._memory_atom_element_num
        setting['line_atom'] = width*self._memory_atom_element_num
        setting['line_size'] = width*atom_byte_size
        setting['line_stride'] = line_stride
        setting['line_number'] = height
        setting['surface_stride'] = surf_stride
        setting['surface_number'] = surf_num
        if ram_type in ["MC","MCIF","PRI_MEM","PRIMARY"]:
            setting['ram_type'] = 'pri_mem'
        elif ram_type in ["CV","CVIF","SEC_MEM","SECONDARY"]:
            setting['ram_type'] = 'sec_mem'
        setting['padding_channel_number'] = channel % self._memory_atom_element_num
        return setting

    def _evaluate_weight_surface_setting(self, base_addr, width, height, channel, kernel_num, ram_type, precision, pattern):
        setting = {}
        byte_size = 1;
        if precision is 'INT8':
            byte_size = 1
        elif precision is 'INT16':
            byte_size = 2
        elif precision is 'FP16':
            byte_size = 2
        surf_num = kernel_num
        element_per_kernel = width*height*channel
        byte_per_kernel = element_per_kernel * byte_size
        surf_stride = byte_per_kernel
        size = surf_stride * surf_num
        line_stride = surf_stride
        setting['base_address'] = base_addr
        setting['size'] = size
        setting['pattern'] = pattern
        setting['precision'] = precision.upper()
        setting['element_per_atom'] = element_per_kernel
        setting['line_atom'] = element_per_kernel
        setting['line_size'] = line_stride
        setting['line_stride'] = line_stride
        setting['line_number'] = 1
        setting['surface_stride'] = surf_stride
        setting['surface_number'] = surf_num
        if ram_type in ["MC","MCIF","PRI_MEM","PRIMARY"]:
            setting['ram_type'] = 'pri_mem'
        elif ram_type in ["CV","CVIF","SEC_MEM","SECONDARY"]:
            setting['ram_type'] = 'sec_mem'
        setting['padding_channel_number'] = 0
        return setting

    def _generate_interrupt_id_list(self):
        for block_name in self._activated_interrupt_list:
            producer_pointer = self.get_field_value(block_name, "S_POINTER_0", "PRODUCER")
            block_index = self._block_index_dict[block_name]
            if block_name is "NVDLA_CDMA":
                reuse_enalbe = self.get_field_enum(block_name, "D_MISC_CFG_0", "DATA_REUSE")
                if "DISABLE" == reuse_enalbe:
                    interrupt_id = "cdma_dat_%d"%producer_pointer
                    sync_id = "%s_%s_%d_interrupt" % (self._name, "cdma_dat", block_index)
                    self._interrupt_id_dict[interrupt_id] = sync_id
                reuse_enalbe = self.get_field_enum(block_name, "D_MISC_CFG_0", "WEIGHT_REUSE")
                if "DISABLE" == reuse_enalbe:
                    interrupt_id = "cdma_wt_%d"%producer_pointer
                    sync_id = "%s_%s_%d_interrupt" % (self._name, "cdma_wt", block_index)
                    self._interrupt_id_dict[interrupt_id] = sync_id
            else:
                interrupt_id = "%s_%d" % (block_name.replace("NVDLA_",""), producer_pointer)
                sync_id = "%s_%s_%d_interrupt" % (self._name, block_name.replace("NVDLA_",""), block_index)
                self._interrupt_id_dict[interrupt_id] = sync_id

    def _generate_operation_enable(self):
        self._operation_enable_list = list(self._scenario_operation_enable_dict[self._scenario])
        for operation_enable_thread in self._operation_enable_list:
            for operation_enable in operation_enable_thread:
                if len(operation_enable["depended_sync_id"]) > 0:
                    for sync_id_index, depended_sync_id in enumerate(operation_enable["depended_sync_id"]):
                        operation_enable["depended_sync_id"][sync_id_index] = "%s_%s" % (self._name, depended_sync_id)
                if operation_enable["generated_sync_id"] is not None:
                    operation_enable["generated_sync_id"] = "%s_%s" % (self._name, operation_enable["generated_sync_id"])

    ## need further update for more pattern support
    def _generate_memory_setting(self):
        ## Get memory surface
        for block_name in self._scenario_memory_block_dict_of_list[self._scenario].keys():
            if block_name is "NVDLA_CDMA":
                ## For input feature cube:
                surface_name = "%s_input" % self._name
                pattern = self._memory_setting['input']
                precision   = self.get_field_enum('NVDLA_CSC', 'D_MISC_CFG_0', 'IN_PRECISION')  ## NVDLA_CDMA does not store precision information
                width   = self.get_field_value(block_name, 'D_DATAIN_SIZE_0_0', 'DATAIN_WIDTH') + 1
                height  = self.get_field_value(block_name, 'D_DATAIN_SIZE_0_0', 'DATAIN_HEIGHT') + 1
                channel = self.get_field_value(block_name, 'D_DATAIN_SIZE_1_0', 'DATAIN_CHANNEL') + 1
                base_addr = hex( (self.get_register_value(block_name, 'D_DAIN_ADDR_HIGH_0_0') << 32) | self.get_register_value(block_name, 'D_DAIN_ADDR_LOW_0_0') )
                line_stride = self.get_register_value(block_name, 'D_LINE_STRIDE_0')
                surf_stride = self.get_register_value(block_name, 'D_SURF_STRIDE_0')
                ram_type    = self.get_field_enum(block_name, 'D_DAIN_RAM_TYPE_0', 'DATAIN_RAM_TYPE')
                self._memory_surface_dict[surface_name] = self._evaluate_surface_setting(base_addr, width, height, channel, line_stride, surf_stride, ram_type, precision, pattern)
                ## For weight cube:
                surface_name = "%s_weight" % self._name
                pattern = self._memory_setting['weight']
                precision   = self.get_field_enum('NVDLA_CSC', 'D_MISC_CFG_0', 'IN_PRECISION')  ## NVDLA_CDMA does not store precision information
                width   = self.get_field_value('NVDLA_CSC', 'D_WEIGHT_SIZE_EXT_0_0', 'WEIGHT_WIDTH_EXT') + 1
                height  = self.get_field_value('NVDLA_CSC', 'D_WEIGHT_SIZE_EXT_0_0', 'WEIGHT_HEIGHT_EXT') + 1
                channel = self.get_field_value('NVDLA_CSC', 'D_WEIGHT_SIZE_EXT_1_0', 'WEIGHT_CHANNEL_EXT') + 1
                kernel_num = self.get_field_value('NVDLA_CSC', 'D_WEIGHT_SIZE_EXT_1_0', 'WEIGHT_CHANNEL_EXT') + 1
                base_addr = hex( (self.get_register_value(block_name, 'D_WEIGHT_ADDR_HIGH_0') << 32) | self.get_register_value(block_name, 'D_WEIGHT_ADDR_LOW_0') )
                line_stride = self.get_register_value(block_name, 'D_LINE_STRIDE_0')
                surf_stride = self.get_register_value(block_name, 'D_SURF_STRIDE_0')
                ram_type    = self.get_field_enum(block_name, 'D_WEIGHT_RAM_TYPE_0', 'WEIGHT_RAM_TYPE')
                self._memory_surface_dict[surface_name] = self._evaluate_weight_surface_setting(base_addr, width, height, channel, kernel_num, ram_type, precision, pattern)
            if block_name is "NVDLA_SDP_RDMA":
                surface_name = "%s_input" % self._name
                pattern = self._memory_setting['input']
                precision   = self.get_field_enum(block_name, 'D_FEATURE_MODE_CFG_0', 'IN_PRECISION')
                width   = self.get_register_value(block_name, 'D_DATA_CUBE_WIDTH_0') + 1
                height  = self.get_register_value(block_name, 'D_DATA_CUBE_HEIGHT_0') + 1
                channel = self.get_register_value(block_name, 'D_DATA_CUBE_CHANNEL_0') + 1
                base_addr = hex( (self.get_register_value(block_name, 'D_SRC_BASE_ADDR_HIGH_0') << 32) | self.get_register_value(block_name, 'D_SRC_BASE_ADDR_LOW_0') )
                line_stride = self.get_register_value(block_name, 'D_SRC_LINE_STRIDE_0')
                surf_stride = self.get_register_value(block_name, 'D_SRC_SURFACE_STRIDE_0')
                ram_type    = self.get_field_enum(block_name, 'D_SRC_DMA_CFG_0', 'SRC_RAM_TYPE')
                #if ram_type in ["MC","MCIF","PRI_MEM","PRIMARY"]:
                #    self._memory_surface_dict['pri_mem'][surface_name] = self._evaluate_surface_setting(base_addr, width, height, channel, line_stride, surf_stride, ram_type, precision, pattern)
                #elif ram_type in ["CV","CVIF","SEC_MEM","SECONDARY"]:
                #    self._memory_surface_dict['sec_mem'][surface_name] = self._evaluate_surface_setting(base_addr, width, height, channel, line_stride, surf_stride, ram_type, precision, pattern)
                self._memory_surface_dict[surface_name] = self._evaluate_surface_setting(base_addr, width, height, channel, line_stride, surf_stride, ram_type, precision, pattern)
            if block_name is "NVDLA_SDP":
                surface_name = "%s_output" % self._name
                pattern = self._memory_setting['output']
                precision   = self.get_field_enum(block_name, 'D_DATA_FORMAT_0', 'OUT_PRECISION')
                width   = self.get_register_value(block_name, 'D_DATA_CUBE_WIDTH_0') + 1
                height  = self.get_register_value(block_name, 'D_DATA_CUBE_HEIGHT_0') + 1
                channel = self.get_register_value(block_name, 'D_DATA_CUBE_CHANNEL_0') + 1
                base_addr = hex( (self.get_register_value(block_name, 'D_DST_BASE_ADDR_HIGH_0') << 32) | self.get_register_value(block_name, 'D_DST_BASE_ADDR_LOW_0') )
                line_stride = self.get_register_value(block_name, 'D_DST_LINE_STRIDE_0')
                surf_stride = self.get_register_value(block_name, 'D_DST_SURFACE_STRIDE_0')
                ram_type    = self.get_field_enum(block_name, 'D_DST_DMA_CFG_0', 'DST_RAM_TYPE')
                #if ram_type in ["MC","MCIF","PRI_MEM","PRIMARY"]:
                #    self._memory_surface_dict['pri_mem'][surface_name] = self._evaluate_surface_setting(base_addr, width, height, channel, line_stride, surf_stride, ram_type, precision, pattern)
                #elif ram_type in ["CV","CVIF","SEC_MEM","SECONDARY"]:
                #    self._memory_surface_dict['sec_mem'][surface_name] = self._evaluate_surface_setting(base_addr, width, height, channel, line_stride, surf_stride, ram_type, precision, pattern)
                self._memory_surface_dict[surface_name] = self._evaluate_surface_setting(base_addr, width, height, channel, line_stride, surf_stride, ram_type, precision, pattern)
            if block_name is "NVDLA_PDP_RDMA":
                surface_name = "%s_input" % self._name
                pattern = self._memory_setting['input']
                precision   = self.get_field_enum(block_name, 'D_DATA_FORMAT_0', 'INPUT_DATA')
                width   = self.get_register_value(block_name, 'D_DATA_CUBE_IN_WIDTH_0') + 1
                height  = self.get_register_value(block_name, 'D_DATA_CUBE_IN_HEIGHT_0') + 1
                channel = self.get_register_value(block_name, 'D_DATA_CUBE_IN_CHANNEL_0') + 1
                base_addr = hex( (self.get_register_value(block_name, 'D_SRC_BASE_ADDR_HIGH_0') << 32) | self.get_register_value(block_name, 'D_SRC_BASE_ADDR_LOW_0') )
                line_stride = self.get_register_value(block_name, 'D_SRC_LINE_STRIDE_0')
                surf_stride = self.get_register_value(block_name, 'D_SRC_SURFACE_STRIDE_0')
                ram_type    = self.get_field_enum(block_name, 'D_SRC_RAM_CFG_0', 'SRC_RAM_TYPE')
                self._memory_surface_dict[surface_name] = self._evaluate_surface_setting(base_addr, width, height, channel, line_stride, surf_stride, ram_type, precision, pattern)
            if block_name is "NVDLA_PDP":
                surface_name = "%s_output" % self._name
                pattern = self._memory_setting['output']
                precision   = self.get_field_enum(block_name, 'D_DATA_FORMAT_0', 'INPUT_DATA')
                width   = self.get_register_value(block_name, 'D_DATA_CUBE_OUT_WIDTH_0') + 1
                height  = self.get_register_value(block_name, 'D_DATA_CUBE_OUT_HEIGHT_0') + 1
                channel = self.get_register_value(block_name, 'D_DATA_CUBE_OUT_CHANNEL_0') + 1
                base_addr = hex( (self.get_register_value(block_name, 'D_DST_BASE_ADDR_HIGH_0') << 32) | self.get_register_value(block_name, 'D_DST_BASE_ADDR_LOW_0') )
                line_stride = self.get_register_value(block_name, 'D_DST_LINE_STRIDE_0')
                surf_stride = self.get_register_value(block_name, 'D_DST_SURFACE_STRIDE_0')
                ram_type    = self.get_field_enum(block_name, 'D_DST_RAM_CFG_0', 'DST_RAM_TYPE')
                self._memory_surface_dict[surface_name] = self._evaluate_surface_setting(base_addr, width, height, channel, line_stride, surf_stride, ram_type, precision, pattern)
            if block_name is "NVDLA_CDP_RDMA":
                surface_name = "%s_input" % self._name
                pattern = self._memory_setting['input']
                precision   = self.get_field_enum(block_name, 'D_DATA_FORMAT_0', 'INPUT_DATA')
                width   = self.get_register_value(block_name, 'D_DATA_CUBE_WIDTH_0') + 1
                height  = self.get_register_value(block_name, 'D_DATA_CUBE_HEIGHT_0') + 1
                channel = self.get_register_value(block_name, 'D_DATA_CUBE_CHANNEL_0') + 1
                base_addr = hex( (self.get_register_value(block_name, 'D_SRC_BASE_ADDR_HIGH_0') << 32) | self.get_register_value(block_name, 'D_SRC_BASE_ADDR_LOW_0') )
                line_stride = self.get_register_value(block_name, 'D_SRC_LINE_STRIDE_0')
                surf_stride = self.get_register_value(block_name, 'D_SRC_SURFACE_STRIDE_0')
                ram_type    = self.get_field_enum(block_name, 'D_SRC_DMA_CFG_0', 'SRC_RAM_TYPE')
                self._memory_surface_dict[surface_name] = self._evaluate_surface_setting(base_addr, width, height, channel, line_stride, surf_stride, ram_type, precision, pattern)
            if block_name is "NVDLA_CDP":
                surface_name = "%s_output" % self._name
                pattern = self._memory_setting['output']
                precision   = self.get_field_enum('NVDLA_CDP_RDMA', 'D_DATA_FORMAT_0', 'INPUT_DATA')
                width   = self.get_register_value('NVDLA_CDP_RDMA', 'D_DATA_CUBE_WIDTH_0') + 1
                height  = self.get_register_value('NVDLA_CDP_RDMA', 'D_DATA_CUBE_HEIGHT_0') + 1
                channel = self.get_register_value('NVDLA_CDP_RDMA', 'D_DATA_CUBE_CHANNEL_0') + 1
                base_addr = hex( (self.get_register_value(block_name, 'D_DST_BASE_ADDR_HIGH_0') << 32) | self.get_register_value(block_name, 'D_DST_BASE_ADDR_LOW_0') )
                line_stride = self.get_register_value(block_name, 'D_DST_LINE_STRIDE_0')
                surf_stride = self.get_register_value(block_name, 'D_DST_SURFACE_STRIDE_0')
                ram_type    = self.get_field_enum(block_name, 'D_DST_DMA_CFG_0', 'DST_RAM_TYPE')
                self._memory_surface_dict[surface_name] = self._evaluate_surface_setting(base_addr, width, height, channel, line_stride, surf_stride, ram_type, precision, pattern)
        ## Generate command

    def _generate_lut_table(self):
        if self._scenario not in self._scenario_lut_table_dict:
            return
        for block_name in self._scenario_lut_table_dict[self._scenario].keys():
            # User to make sure LUT enableness
            if 'LE' in self._lut_table_setting:
                register_name = 'S_LUT_ACCESS_CFG_0'
                self.set_field_value(block_name, register_name, 'LUT_ADDR', 0)
                self.set_field_value(block_name, register_name, 'LUT_TABLE_ID', 'LE')
                self.set_field_value(block_name, register_name, 'LUT_ACCESS_TYPE', 'WRITE')
                register_value = self._register[block_name][register_name]["value"]
                self._lut_data_config['LE'] = [('%s.%s' % (block_name,register_name), register_value)]
                data_list = range(65)
                lut_function =  lambda x: eval(self._lut_table_setting['LE'])
                self._lut_data_config['LE'].extend( [('%s.S_LUT_ACCESS_DATA_0' % block_name,lut_function(i)) for i in data_list] )
                print ("self._lut_data_config['LE']")
                print self._lut_data_config['LE']
            if 'LO' in self._lut_table_setting:
                register_name = 'S_LUT_ACCESS_CFG_0'
                self.set_field_value(block_name, register_name, 'LUT_ADDR', 0)
                self.set_field_value(block_name, register_name, 'LUT_TABLE_ID', 'LO')
                self.set_field_value(block_name, register_name, 'LUT_ACCESS_TYPE', 'WRITE')
                register_value = self._register[block_name][register_name]["value"]
                self._lut_data_config['LO'] = [('%s.%s' % (block_name,register_name), register_value)]
                data_list = range(257)
                lut_function =  lambda x: eval(self._lut_table_setting['LO'])
                self._lut_data_config['LO'].extend( [('%s.S_LUT_ACCESS_DATA_0' % block_name,lut_function(i)) for i in data_list] )

    def _generate_result_checker(self):
        for intr_id, sync_id in self._interrupt_id_dict.items():
            self._result_checker_dict[sync_id] = {'type':"check_nothing"}

    #def get_surface_name_by_memory_type(self, memory_type):
    #    if memory_type.lower() not in ['pri_mem', 'sec_mem']:
    #        raise Exception ('NvdlaHardwareLayer::get_surface_name_by_memory_type', 'Parameter memory_type shall be either "pri_mem" or "sec_mem"')
    #    return self._memory_surface_dict[memory_type.lower()].keys()

    def get_surface_names(self):
        return self._memory_surface_dict.keys()

    def get_surface_setting_by_name(self, surface_name):
        return self._memory_surface_dict[surface_name]

    def get_layer_configuration_dict(self):
        self._generate_layer_configuration()
        self._generate_memory_setting()
        self._generate_operation_enable()
        self._generate_interrupt_id_list()
        self._generate_result_checker()
        self._generate_lut_table()
        layer_configuration_dict = {}
        ## Generate config key
        layer_configuration_dict["configuration"]   = self._functional_configuration_dict
        layer_configuration_dict["block_dependency"]= self._block_dependency_sync_id_dict
        layer_configuration_dict["producer_pointer"]= self._producer_pointer_dict
        layer_configuration_dict["operation_enable"]= self._operation_enable_list
        layer_configuration_dict["interrupt"]       = self._interrupt_id_dict
        layer_configuration_dict["result_checker"]  = self._result_checker_dict
        layer_configuration_dict["memory_surface"]  = self._memory_surface_dict
        layer_configuration_dict["lut_table_data"]  = self._lut_data_config
        return layer_configuration_dict

if __name__ == '__main__':
    layer = NvdlaHardwareLayer ('GoodLayer', "C:/work/osdla_test_writer/arnvdla.py")
    layer.set_scenario("SDP")
    layer_0_setting = {
        'sdp.width' : 7,
        'sdp.height': 7,
        'sdp.channel': 31,
    }
    layer.update_layer_setting(layer_0_setting)
    #layer.generate_layer_configuration()
    #layer.print_block_content("NVDLA_SDP")
    layer.print_edited_register_content_in_block("NVDLA_SDP")
    layer_configuration_dict = layer.get_layer_configuration_dict()
    print ("layer_configuration_dict")
    pprint (layer_configuration_dict)
