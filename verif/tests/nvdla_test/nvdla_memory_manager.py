#!/usr/bin/env python
import random
from pprint import pprint

## Similar to Python 3.x int.to_bytes(length, byteorder, signed)
def int_to_byte_string_list(int_value, length, byteorder='little', signed=False):
    if type(int_value) is not int:
        raise Exception('nvdla_memory_manager', 'The type of parameter int_value shall be int.')
    if type(length) is not int:
        raise Exception('nvdla_memory_manager', 'The type of parameter length shall be int.')
    if length <= 0:
        raise Exception('nvdla_memory_manager', 'Parameter length shall be greater than zero.')
    if byteorder not in ['big','little']:
        raise Exception('nvdla_memory_manager','Parameter byteorder shall be either "big" or "little".')
    if type(signed) is not bool:
        raise Exception('nvdla_memory_manager', 'The type of parameter signed shall be bool.')
    little_endian_list = []
    value = int(int_value)
    for byte_index in range(length):
        little_endian_list.append('0x%02X'%(value&0xFF))
    if 'big' == byteorder:
        little_endian_list.reverse()
    return little_endian_list

class NvdlaMemoryManager(object):
    ### Generated file naming convention: <name>_<surface_name>_base_address.dat
#        setting['size'] = size
#        setting['pattern'] = pattern
#        setting['base_address'] = base_addr
#        setting['precision'] = INT8, not used yet
#        setting['line_atom'] = element_per_atom*width
#        setting['line_size'] = width*element_per_atom*element_byte_size
#        setting['line_stride'] = line_stride
#        setting['line_number'] = height
#        setting['surface_stride'] = surf_stride
#        setting['surface_number'] = surf_num
    def __init__(self, name):
        self._name = name
        self._setting_dict      = {}  # key: surface_name, #value: settings
        self._allocated_space_list   = []  #item: (base_addr, size)
        self._generated_memory_surface = {}
        self._space_content = {} # key: surface_name, #value: content
        self._space_content_generated = {} # key: surface_name, #value: True/False
        self._byte_per_line = 8
        random.seed()

    def add_space_setting(self, surface_name, setting):
        self._setting_dict[surface_name] = dict(setting)

    def generate_dino_data_file(self, surface_name):
        if self._space_content_generated[surface_name] is False:
            self.generate_surface_by_name(surface_name)
        content_str_list = []
        content = self._space_content[surface_name]
        previous_offset = 0
        for address_offset in sorted(content.keys()):
            line_content = content[address_offset]
            byte_size = len(line_content)
            byte_idx = 0
            while (byte_idx < byte_size):
                converted_byte_num = min(self._byte_per_line, byte_size-byte_idx)
                converted_byte_list = line_content[byte_idx:byte_idx+converted_byte_num]
                content_str_list.append("##offset:%s" % (hex(address_offset+byte_idx)))
                content_str_list.append("%s" % (' '.join(converted_byte_list)))
                byte_idx += converted_byte_num
        content_str = '\n'.join(content_str_list)
        f = open(surface_name+'.dat', 'w')
        f.write(content_str)
        f.close()

    def generate_trace_data_file(self, surface_name):
        if self._space_content_generated[surface_name] is False:
            self.generate_surface_by_name(surface_name)
        content_str_list = []
        content = self._space_content[surface_name]
        for address_offset in sorted(content.keys()):
            line_content = content[address_offset]
            byte_size = len(line_content)
            byte_idx = 0
            while (byte_idx < byte_size):
                converted_byte_num = min(self._byte_per_line, byte_size-byte_idx)
                converted_byte_list = line_content[byte_idx:byte_idx+converted_byte_num]
                content_str_list.append("{offset:%s, size:%d, payload:%s}," % (hex(address_offset+byte_idx), converted_byte_num, ' '.join(converted_byte_list)) )
                byte_idx += converted_byte_num
        content_str = '\n'.join(content_str_list)
        f = open(surface_name+'.dat', 'w')
        f.write(content_str)
        f.close()

    def resolve_surface_addresses(self):
        # TODO
        pass

    def get_content_by_name(self, surface_name):
        if self._space_content_generated[surface_name] is False:
            self.generate_surface_by_name(surface_name)
        return self._space_content[surface_name]

    def generate_surface_by_name(self, surface_name):
        space_content = {}
        surf_setting = self._setting_dict[surface_name]
        atom_byte_size = 1 if ('INT8' == surf_setting['precision']) else 2
        for surf_idx in range(surf_setting['surface_number']):
            for line_idx in range(surf_setting['line_number']):
                addr_offset = surf_setting['surface_stride'] * surf_idx + surf_setting['line_stride']*line_idx
                #print ("generate_surface_by_name::addr_offset:%s" % hex(addr_offset))
                if 'ALL_ZERO' == surf_setting['pattern'].upper():
                    space_content[addr_offset] = ['0x00']*(surf_setting['line_size'])
                elif 'ALL_ONE' == surf_setting['pattern'].upper():
                    space_content[addr_offset] = ['0x01']*(surf_setting['line_size'])
                elif 'ALL_TWO' == surf_setting['pattern'].upper():
                    space_content[addr_offset] = ['0x02']*(surf_setting['line_size'])
                elif 'ALL_FOUR' == surf_setting['pattern'].upper():
                    space_content[addr_offset] = ['0x04']*(surf_setting['line_size'])
                elif 'RANDOM' == surf_setting['pattern'].upper():
                    line_byte_list = []
                    [line_byte_list.extend(int_to_byte_string_list(random.randint(0,0xFFFF), atom_byte_size)) for i in range(surf_setting['line_atom'])]
                    space_content[addr_offset] = line_byte_list
                elif 'OFFSET' == surf_setting['pattern']:
                    line_byte_list = []
                    [line_byte_list.extend(int_to_byte_string_list(i+addr_offset, atom_byte_size)) for i in range(surf_setting['line_atom'])]
                    space_content[addr_offset] = line_byte_list
                #print ("generate_surface_by_name::space_content:%s" % ' '.join(space_content[addr_offset]))
        self._space_content[surface_name] = space_content
        #print ("space_content")
        #print (space_content)
        self._space_content_generated[surface_name] = True

    def get_base_address_by_name(self, surface_name):
        return self._setting_dict[surface_name]['base_address']

    def generate_all_surfaces(self):
        for surf_name in self._setting_dict.keys():
            self.generate_surface_by_name(surf_name)

    def get_dino_config_string(self, surface_name):
        surf_setting = self._setting_dict[surface_name]
        ram_type = surf_setting['ram_type']
        base_addr = surf_setting['base_address']
        command_string = 'LOADFILE:%s.dat:%s:%d' % (surface_name, base_addr,1  if 'pri_mem' == ram_type else 0)
        return command_string

    def get_trace_config_string(self, surface_name):
        surf_setting = self._setting_dict[surface_name]
        ram_type = surf_setting['ram_type']
        base_addr = surf_setting['base_address']
        command_string = 'mem_load(%s, %s, "%s.dat");' % (ram_type, base_addr, surface_name)
        return command_string

    def get_config_string(self, surface_name, data_format):
        if self._space_content_generated[surface_name] is False:
            self.generate_surface_by_name(surface_name)
        if 'dino' == data_format:
            return self.get_dino_config_string(surface_name)
        elif 'trace' == data_format:
            return self.get_trace_config_string(surface_name)

    def generate_data_file(self, surface_name, data_format):
        if self._space_content_generated[surface_name] is False:
            self.generate_surface_by_name(surface_name)
        if 'dino' == data_format:
            self.generate_dino_data_file(surface_name)
        elif 'trace' == data_format:
            self.generate_trace_data_file(surface_name)

if __name__ == '__main__':
    nmm = NvdlaMemoryManager('nmm')
#        setting['base_address'] = base_addr
#        setting['size'] = size
#        setting['pattern'] = pattern
#        setting['precision'] = INT8
#        setting['element_per_atom'] = element_per_atom
#        setting['line_size'] = width*atom_byte_size
#        setting['line_stride'] = line_stride
#        setting['line_number'] = height
#        setting['surface_stride'] = surf_stride
#        setting['surface_number'] = surf_num
#        setting['padding_channel_number'] = padding_c
    mms = { 
            'base_address':0x8000,
            'size':2048,
            'pattern':'ALL_ZERO',
            'precision':'INT8',
            'element_per_atom':8,
            'line_size':64,
            'line_atom':64,
            'line_stride':64,
            'line_number':8,
            'surface_stride':512,
            'surface_number':4,
            'padding_channel_number':0,
          } 
    #mms = { 
    #        'base_address':0x8000,
    #        'size':2048,
    #        'pattern':'ALL_FOUR',
    #        'precision':'INT8',
    #        'element_per_atom':1024,
    #        'line_size':1024,
    #        'line_atom':1024,
    #        'line_stride':1024,
    #        'line_number':1,
    #        'surface_stride':1024,
    #        'surface_number':1,
    #        'padding_channel_number':0,
    #      } 
    #surface_name = "32x1x1x32_int8_all_four"
    surface_name = "8x8x32_pack_int8_all_zero"
    nmm.add_space_setting(surface_name, mms)
    data_format = 'trace'
    nmm.generate_all_surfaces()
    mem_content_str = nmm.get_content_by_name(surface_name)
    nmm.generate_data_file(surface_name, data_format)
    #nmm.generate_data_file(surface_name, data_format)
    #pprint (mem_content_str)
