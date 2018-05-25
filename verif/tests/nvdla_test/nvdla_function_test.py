#!/usr/bin/env python
from nvdla_hardware_layer import NvdlaHardwareLayer
from nvdla_memory_manager import NvdlaMemoryManager
import random
from pprint import pprint
import os
from math import log

class NvdlaTest(object):

    def __init__(self, name):
        self._name = name
        random.seed()
        self._auto_hardware_layer_name = {}  # key:scenario, value:layer_list
        self._hardware_layer_name_list  = []
        self._project_define_dict = {}
        self._register_manual_dict = {}
        self._is_project_define_loaded = False
        self._is_register_manual_loaded = False
        self._hardware_layer_dict = {}
        self._used_block_layers_dict_of_list = {} # {block:[layer_0, layer_1]}
        self._layer_configuration = {}
        self._dependence_layer_dict = {}
        self._memory_space_manager = {'pri_mem':NvdlaMemoryManager(self._name+'_memory_space_manager_pri_mem'), 'sec_mem':NvdlaMemoryManager(self._name+'_memory_space_manager_sec_mem')}

    def is_two_list_the_same(self, list_a, list_b):
        return not(bool(set(list_a).difference(set(list_b))))

    # Do some basic validation on manual before using it
    ## 1. Block key list shall be the same between dict addr_spaces and dict registers
    def validate_manual(self):
        if self.is_two_list_the_same( self._register_manual_dict['registers'].keys(), self._register_manual_dict['addr_spaces'].keys() ) is False:
            raise Exception("NvdlaTest::validate_manual", "manual registers and addr_spaces are not the same")

    # Load project definition from file
    def load_project_define_file(self, project_define_file_path):
        self._is_project_define_loaded = True
        buffer_dict = {}
        execfile(project_define_file_path, buffer_dict)
        self._project_define_dict = dict(buffer_dict['PROJVAR'])
        ## following variable may be used in test coding
        self._memory_element_per_atom = int(self._project_define_dict['NVDLA_MEMORY_ATOMIC_SIZE'])
        self._memory_atom_byte_size = self._memory_element_per_atom * 1 # TODO, use  element_byte_size from spec
        self._address_lsb_mask_bits = int(log(self._memory_atom_byte_size, 2))

    # Load manual from file
    def load_register_manual_file(self, manual_file_path):
        self._is_register_manual_loaded = True
        execfile(manual_file_path, self._register_manual_dict)
        self.validate_manual()
        #pprint (self._register_manual_dict)
        #self._register = dict(manual_file['registers'])
        #self._addr_spaces = dict(manual_file['addr_spaces'])

    # Add hardware layer
    def add_hardware_layer(self, layer_name, scenario_name):
        # check layer_name existed
        if layer_name in self._hardware_layer_dict:
            raise Exception("NvdlaTest::add_hardware_layer", "Current adding layer name %s is existed, layer name shall be unique" % layer_name)
        if "auto_layer_name" == layer_name:
            layer_scenario_index = len(self._auto_hardware_layer_name[scenario_name]) if scenario_name in self._auto_hardware_layer_name else 0
            layer_name = "%s_%d" % (scenario_name, layer_scenario_index)
        layer = NvdlaHardwareLayer(layer_name, dict(self._register_manual_dict), dict(self._project_define_dict))
        layer.set_scenario(scenario_name)
        self._hardware_layer_dict[layer_name] = layer
        self._hardware_layer_name_list.append(layer_name)
        if scenario_name in self._auto_hardware_layer_name:
            self._auto_hardware_layer_name[scenario_name].append(layer_name)
        else:
            self._auto_hardware_layer_name[scenario_name] = [layer_name]
        return layer_name

    # Update field variables in a specific layer
    def update_layer_setting(self, layer_name, scenario_config_dict):
        if layer_name not in self._hardware_layer_dict:
            raise Exception("NvdlaTest::update_layer_setting", "Cannot find layer name %s, please add layer before use it" % layer_name)
        self._hardware_layer_dict[layer_name].update_layer_setting(scenario_config_dict)

    def update_layer_memory(self, layer_name, memory_setting_dict):
        #"L_0", {'input':'index', 'output':'rand'}
        if layer_name not in self._hardware_layer_dict:
            raise Exception("NvdlaTest::update_layer_memory", "Cannot find layer name %s, please add layer before use it" % layer_name)
        self._hardware_layer_dict[layer_name].update_layer_memory(memory_setting_dict)

    def update_layer_lut_table(self, layer_name, lut_table_setting_dict):
        #"L_0", {'input':'index', 'output':'rand'}
        if layer_name not in self._hardware_layer_dict:
            raise Exception("NvdlaTest::update_layer_lut", "Cannot find layer name %s, please add layer before use it" % layer_name)
        self._hardware_layer_dict[layer_name].update_layer_lut_table(lut_table_setting_dict)

    def resolve_layer_dependency(self):
        self._resolve_block_dependency()

    # Resolve producer pointer value
    def _resolve_block_dependency(self):
        self._get_used_block_layer_mapping()
        for block_name in self._used_block_layers_dict_of_list:
            layer_index = 0;
            for layer_name in self._used_block_layers_dict_of_list[block_name]:
                self._hardware_layer_dict[layer_name].set_block_index(block_name, layer_index)
                if layer_index >= 2:
                    depended_layer_name = self._used_block_layers_dict_of_list[block_name][layer_index-2]
                    sync_id = "%s_%s_%d_interrupt" % (depended_layer_name, block_name.replace("NVDLA_",""), layer_index-2)
                    self._hardware_layer_dict[layer_name].set_block_dependency( block_name, sync_id)
                layer_index += 1


    def _get_used_block_layer_mapping(self):
        for layer_name, layer in self._hardware_layer_dict.items():
            for block_name in layer.get_resource_list():
                if block_name in self._used_block_layers_dict_of_list:
                    self._used_block_layers_dict_of_list[block_name].append(layer_name)
                else:
                    self._used_block_layers_dict_of_list[block_name]=[layer_name]

    # Compose test
    ## Update register value from field in all layer
    def compose_test(self):
        self.resolve_layer_dependency()
        for layer_name,layer in self._hardware_layer_dict.items():
            #layer.generate_layer_configuration()
            self._layer_configuration[layer_name] = layer.get_layer_configuration_dict()
            #pprint (self._layer_configuration[layer_name])
            #for surface_name in layer.get_surface_name_by_memory_type('pri_mem'):
            #    self._memory_space_manager['pri_mem'].add_space_setting(surface_name, layer.get_surface_setting_by_name(surface_name))
            #for surface_name in layer.get_surface_name_by_memory_type('sec_mem'):
            #    self._memory_space_manager['sec_mem'].add_space_setting(surface_name, layer.get_surface_setting_by_name(surface_name))
            for surface_name in layer.get_surface_names():
                surface_setting =  layer.get_surface_setting_by_name(surface_name)
                print ("surface_setting, surface_name:%s" % surface_name)
                print surface_setting
                self._memory_space_manager[surface_setting['ram_type']].add_space_setting(surface_name, surface_setting)
        self._memory_space_manager['pri_mem'].generate_all_surfaces()
        self._memory_space_manager['sec_mem'].generate_all_surfaces()

    # Generate dinosaure format trace
    def generate_dino_config_file(self, trace_dir):
        config_str_list = ["## NVDLA Dino  TRACE config: %s" % self._name]
        for layer_name in self._hardware_layer_name_list:
            layer_config = self._layer_configuration[layer_name]
            #for layer_name, layer_config in self._layer_configuration.items():
            config_str_list.append("##---------- Layer:%s, scenario:%s----------" % (layer_name, self._hardware_layer_dict[layer_name].get_scenario()))
            # Generate memory setting
            config_str_list.append("##----------## Layer:%s: memory preparation, begin----------" % layer_name)
            #for surface_base_addr, surface_setting in layer_config["memory_surface"].items():
            #    config_str_list.append("mem_init(ALL_ZERO, %s);" % (surface_base_addr))
            for surface_name in layer_config["memory_surface"].keys():
                ram_type = layer_config["memory_surface"][surface_name]['ram_type']
                config_str_list.append(self._memory_space_manager[ram_type].get_config_string(surface_name, 'dino'))
            config_str_list.append("##----------## Layer:%s: memory preparation, end----------" % layer_name)
            # Generate block dependency
            ## config_str_list.append("##----------## Layer:%s: cross layer dependency, begin----------" % layer_name)
            ## for block_name, sync_id in layer_config["block_dependency"].items():
            ##     config_str_list.append("sync_wait(%s, %s);" % (block_name, sync_id))
            ## config_str_list.append("##----------## Layer:%s: cross layer dependency, end----------" % layer_name)
            # Producer pointer
            config_str_list.append("##----------## Layer:%s: set producer pointer, begin----------" % layer_name)
            for register_name, value in layer_config["producer_pointer"].items():
                #config_str_list.append("reg_write(%s, %s);" % (register_name, value))
                config_str_list.append("%s:0x0:%s" % (register_name, value))
            config_str_list.append("##----------## Layer:%s: set producer pointer, end----------" % layer_name)
            # LUT programming
            config_str_list.append("##----------## Layer:%s: LUT programming, begin----------" % layer_name)
            if len(layer_config["lut_table_data"]):
                for table_id in layer_config["lut_table_data"]:
                    for register_name, register_value in layer_config["lut_table_data"][table_id]:
                        config_str_list.append("%s:0x0:%s" % (register_name, hex(register_value)))
            for register_name in layer_config["configuration"]:
                if 'S_LUT_' not in register_name:
                    continue
                config_str_list.append("%s:0x0:%s" % (register_name, hex(layer_config["configuration"][register_name]["value"])))
                ## field comment
                for field_name in layer_config["configuration"][register_name]["field_config"]:
                    field_value = layer_config["configuration"][register_name]["field_config"][field_name]
                    config_str_list.append("## %s.%s:%s" % (register_name, field_name, field_value))
            config_str_list.append("##----------## Layer:%s: LUT programming, end----------" % layer_name)
            # Configuration
            config_str_list.append("##----------## Layer:%s: configuraion, begin----------" % layer_name)
            for register_name in layer_config["configuration"]:
                if 'S_LUT_' in register_name:
                    continue
                config_str_list.append("%s:0x0:%s" % (register_name, hex(layer_config["configuration"][register_name]["value"])))
                ## field comment
                for field_name in layer_config["configuration"][register_name]["field_config"]:
                    field_value = layer_config["configuration"][register_name]["field_config"][field_name]
                    config_str_list.append("## %s.%s:%s" % (register_name, field_name, field_value))
            config_str_list.append("##----------## Layer:%s: configuraion, end----------" % layer_name)
            # Operatioin enable
            config_str_list.append("##----------## Layer:%s: operation enable, begin----------" % layer_name)
            operation_enable_raw_list = layer_config["operation_enable"]
            for operation_enable_thread in operation_enable_raw_list:
                for operation_enable in operation_enable_thread:
                    block_name     = operation_enable['block_name']
                    register_name  = operation_enable['register_name']
                    register_value = 0x1
                    config_str_list.append("##----------#### Layer:%s: operation enable, block:%s, begin --" % (layer_name,block_name))
                    config_str_list.append("%s:0x0:%s" % (register_name, hex(register_value)))
                    config_str_list.append("##----------#### Layer:%s: operation enable, block:%s, end   --" % (layer_name,block_name))
            config_str_list.append("##----------## Layer:%s: operation enable, end----------" % layer_name)
            ## Interrupt handling
            #config_str_list.append("##----------## Layer:%s: interrupt handling, begin----------" % layer_name)
            #for intr_id, sync_id in layer_config["interrupt"].items():
            #    config_str_list.append("intr_notify(%s, %s);" % (intr_id, sync_id))
            #config_str_list.append("##----------## Layer:%s: interrupt handling, end----------" % layer_name)
            ## Result checker
            #config_str_list.append("##----------## Layer:%s: result checker, begin----------" % layer_name)
            #for sync_id, action in layer_config["result_checker"].items():
            #    if action['type'] is "check_nothing":
            #        config_str_list.append("check_nothing(%s);" % (sync_id))
            #config_str_list.append("##----------## Layer:%s: result checker, end----------" % layer_name)
        #print (config_str_list)
        #print ('\n'.join(config_str_list))
        # Make dir
        os.mkdir(trace_dir)
        origin_working_directory = os.getcwd()
        os.chdir(trace_dir)
        # Dump configuration to file
        f = open(self._name+'.cfg', 'w')
        f.write('\n'.join(config_str_list))
        f.close()
        # Dump memory to file
        for layer_name in self._hardware_layer_name_list:
            layer_config = self._layer_configuration[layer_name]
            for surface_name in layer_config["memory_surface"].keys():
                ram_type = layer_config["memory_surface"][surface_name]['ram_type']
                self._memory_space_manager[ram_type].generate_data_file(surface_name, 'dino')
        os.chdir(origin_working_directory)
        print ("Test generation done.")

    # Generate trace config
    def generate_trace_config_file(self, trace_dir):
        config_str_list = ["// NVDLA TRACE config: %s" % self._name]
        for layer_name in self._hardware_layer_name_list:
            layer_config = self._layer_configuration[layer_name]
            #for layer_name, layer_config in self._layer_configuration.items():
            config_str_list.append("//---------- Layer:%s, scenario:%s----------" % (layer_name, self._hardware_layer_dict[layer_name].get_scenario()))
            # Generate memory setting
            config_str_list.append("//----------## Layer:%s: memory preparation, begin----------" % layer_name)
            #for surface_base_addr, surface_setting in layer_config["memory_surface"].items():
            #    config_str_list.append("mem_init(ALL_ZERO, %s);" % (surface_base_addr))
            for surface_name in layer_config["memory_surface"].keys():
                ram_type = layer_config["memory_surface"][surface_name]['ram_type']
                config_str_list.append(self._memory_space_manager[ram_type].get_config_string(surface_name, 'trace'))
            config_str_list.append("//----------## Layer:%s: memory preparation, end----------" % layer_name)
            # Generate block dependency
            config_str_list.append("//----------## Layer:%s: cross layer dependency, begin----------" % layer_name)
            for block_name, sync_id in layer_config["block_dependency"].items():
                config_str_list.append("sync_wait(%s, %s);" % (block_name, sync_id))
            config_str_list.append("//----------## Layer:%s: cross layer dependency, end----------" % layer_name)
            # Producer pointer
            config_str_list.append("//----------## Layer:%s: set producer pointer, begin----------" % layer_name)
            for register_name, value in layer_config["producer_pointer"].items():
                config_str_list.append("reg_write(%s, %s);" % (register_name, value))
            config_str_list.append("//----------## Layer:%s: set producer pointer, end----------" % layer_name)
            # LUT programming
            config_str_list.append("//----------## Layer:%s: LUT programming, begin----------" % layer_name)
            if len(layer_config["lut_table_data"]):
                for table_id in layer_config["lut_table_data"]:
                    for register_name, register_value in layer_config["lut_table_data"][table_id]:
                        config_str_list.append("reg_write(%s, %s);" % (register_name, hex(register_value)))
            for register_name in layer_config["configuration"]:
                if 'S_LUT_' not in register_name:
                    continue
                config_str_list.append("reg_write(%s, %s);" % (register_name, hex(layer_config["configuration"][register_name]["value"])))
                ## field comment
                for field_name in layer_config["configuration"][register_name]["field_config"]:
                    field_value = layer_config["configuration"][register_name]["field_config"][field_name]
                    config_str_list.append("// %s.%s:%s" % (register_name, field_name, field_value))
            config_str_list.append("//----------## Layer:%s: LUT programming, end----------" % layer_name)
            # Configuration
            config_str_list.append("//----------## Layer:%s: configuraion, begin----------" % layer_name)
            for register_name in layer_config["configuration"]:
                if 'S_LUT_' in register_name:
                    continue
                config_str_list.append("reg_write(%s, %s);" % (register_name, hex(layer_config["configuration"][register_name]["value"])))
                ## field comment
                for field_name in layer_config["configuration"][register_name]["field_config"]:
                    field_value = layer_config["configuration"][register_name]["field_config"][field_name]
                    config_str_list.append("// %s.%s:%s" % (register_name, field_name, field_value))
            config_str_list.append("//----------## Layer:%s: configuraion, end----------" % layer_name)
            # Operatioin enable
            config_str_list.append("//----------## Layer:%s: operation enable, begin----------" % layer_name)
            operation_enable_raw_list = layer_config["operation_enable"]
            for operation_enable_thread in operation_enable_raw_list:
                for operation_enable in operation_enable_thread:
                    block_name     = operation_enable['block_name']
                    register_name  = operation_enable['register_name']
                    register_value = 0x1
                    config_str_list.append("//----------#### Layer:%s: operation enable, block:%s, begin --" % (layer_name,block_name))
                    if len(operation_enable["depended_sync_id"]) > 0:
                        random.shuffle(operation_enable["depended_sync_id"])
                        for depended_sync_id in operation_enable["depended_sync_id"]:
                            config_str_list.append("sync_wait(%s, %s);" % (block_name, depended_sync_id))
                    config_str_list.append("reg_write(%s,%s);" % (register_name, hex(register_value)))
                    if operation_enable["generated_sync_id"] is not None:
                        config_str_list.append("sync_notify(%s, %s);" % (block_name, operation_enable["generated_sync_id"]))
                    config_str_list.append("//----------#### Layer:%s: operation enable, block:%s, end   --" % (layer_name,block_name))
            config_str_list.append("//----------## Layer:%s: operation enable, end----------" % layer_name)
            # Interrupt handling
            config_str_list.append("//----------## Layer:%s: interrupt handling, begin----------" % layer_name)
            for intr_id, sync_id in layer_config["interrupt"].items():
                config_str_list.append("intr_notify(%s, %s);" % (intr_id, sync_id))
            config_str_list.append("//----------## Layer:%s: interrupt handling, end----------" % layer_name)
            # Result checker
            config_str_list.append("//----------## Layer:%s: result checker, begin----------" % layer_name)
            for sync_id, action in layer_config["result_checker"].items():
                if action['type'] is "check_nothing":
                    config_str_list.append("check_nothing(%s);" % (sync_id))
            config_str_list.append("//----------## Layer:%s: result checker, end----------" % layer_name)
        #print ('\n'.join(config_str_list))
        # Make dir
        os.mkdir(trace_dir)
        origin_working_directory = os.getcwd()
        #print ('nvdla_test::generate_trace_config_file, trace_dir is %s' % trace_dir)
        #print ('nvdla_test::generate_trace_config_file, origin_working_directory is %s' % origin_working_directory)
        os.chdir(trace_dir)
        # Dump configuration to file
        f = open(self._name+'.cfg', 'w')
        f.write('\n'.join(config_str_list))
        f.close()
        # Dump memory to file
        for layer_name in self._hardware_layer_name_list:
            layer_config = self._layer_configuration[layer_name]
            for surface_name in layer_config["memory_surface"].keys():
                ram_type = layer_config["memory_surface"][surface_name]['ram_type']
                self._memory_space_manager[ram_type].generate_data_file(surface_name, 'trace')
        os.chdir(origin_working_directory)
        print ("Test generation done.")

if __name__ == '__main__':
    test = NvdlaTest ('nvdla_test')
    trace_dir = "nvdla_test"
    #test.load_register_manual_file("nvdla.py")
    test.load_register_manual_file("../../../outdir/nv_small/spec/manuals/opendla.py")
    test.load_project_define_file ("../../../outdir/nv_small/spec/defs/project.py")
    test.add_hardware_layer("L_0", "SDP")
    layer_0_setting = {
        'sdp.src_base_addr_low' : 0x0,
        'sdp.dst_base_addr_low' : 0x4000,
        'sdp.width' : 7,
        'sdp.height': 7,
        'sdp.channel': 31,
        'sdp.src_line_stride' : 8,
        'sdp.src_surface_stride' : 64,
        'sdp.dst_line_stride' : 8,
        'sdp.dst_surface_stride' : 64,
        'sdp.brdma_disable': 'yEs',
        'sdp.nrdma_disable': 'yeS',
        'sdp.erdma_disable': 'Yes',
        'sdp.bs_bypass': 'Yes',
        'sdp.bn_bypass': 'yEs',
        'sdp.ew_bypass': 'yeS',
        'sdp.in_precision':'INT8',
        'sdp.proc_precision':'INT8',
        'sdp.out_precision':'INT8',
        'sdp.src_ram_type': 'src_ram_type_MC',
        'sdp.dst_ram_type': 'MC',
    }
    test.update_layer_setting("L_0", layer_0_setting)
    test.update_layer_memory("L_0", {'input':'ALL_ZERO', 'output':'RANDOM'})
    test.update_layer_lut_table(layer_name, {'LE':'x'})
    test.compose_test()
    test.generate_dino_config_file(trace_dir)
    #test.generate_trace_config_file(trace_dir)
