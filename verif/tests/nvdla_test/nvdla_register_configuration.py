#!/usr/bin/env python
class NvdlaRegisterConfiguration (object):
    _register_block_enabled={}
    _is_register_manual_loaded = False
    _register = {}
    _addr_spaces = {}
    _field_register_map = {}

    # Initialize with instance name
    def __init__(self, name):
        self._name = name

    def load_register_manual(self, manual):
        if type(manual) is str:
            # Load register manual from file
            manual_file_path = manual
            print ("load_register_manual: manual_file_path is "+manual_file_path)
            manual_file = {}
            execfile(manual_file_path, manual_file)
            self._register = dict(manual_file['registers'])
            self._addr_spaces = dict(manual_file['addr_spaces'])
            self._is_register_manual_loaded = True
        elif type(manual) is dict:
            # Load register manual file from dict
            self._register = dict(manual['registers'])
            self._addr_spaces = dict(manual['addr_spaces'])
            self._is_register_manual_loaded = True
        else:
            raise Exception("NvdlaRegisterConfiguration", "manual shall either be manual file path or manual dictionary")

    # Set register block enable
    def set_block_enable(self, block_name):
        self._register[block_name]['enabled'] = True
        self.initialize_field_value_in_block(block_name)

    def initialize_field_value_in_block(self, block_name):
        for register_name in self._register[block_name]['register_list']:
            self._register[block_name][register_name]['value'] = self._register[block_name][register_name]['reset_val']
            self._register[block_name][register_name]['edited']= False
            # print("initialize_field_value_in_block: block_name:"+block_name+" register_name:"+register_name)
            for field_name in self._register[block_name][register_name]['field_list']:
                self._register[block_name][register_name][field_name]['value'] = self._register[block_name][register_name][field_name]['default']
                self._register[block_name][register_name][field_name]['edited']= False

    def generate_field_name_register_name_map(self):
        for block_name in self._register:
            for register_name in self._register[block_name]['register_list']:
                for field_name in self._register[block_name][register_name]['field_list']:
                    if block_name in self._field_register_map:
                        self._field_register_map[block_name].update({field_name:register_name})
                    else:
                        self._field_register_map[block_name]={field_name:register_name}

    def get_register_name_by_field_name(self, block_name, field_name):
        return self._field_register_map[block_name][field_name]

    # Set field value
    def set_field_value(self, block_name, register_name, field_name, field_value):
        if 'r' == self._register[block_name][register_name][field_name]['action']:
            return
        #print ("block_name:%s, register_name:%s, field_name:%s, field_value:%s" % (block_name, register_name, field_name, str(field_value)))
        if type(field_value) is str:
            if field_value.upper() in  self._register[block_name][register_name][field_name]["enums"].keys():
                field_value = self._register[block_name][register_name][field_name]["enums"][field_value.upper()]
            else:
                field_value = self._register[block_name][register_name][field_name]["enums"][field_value.upper().replace(field_name+'_','')]
        self._register[block_name][register_name][field_name]['value'] = field_value
        self._register[block_name][register_name][field_name]['edited'] = True
        self._register[block_name][register_name]['edited'] = True
        self.update_register_value_from_field(block_name, register_name)

    # Get field value
    def get_field_value(self, block_name, register_name, field_name):
        print ("nvdla_register_configuration::get_field_value: block_name:%s, register_name:%s, field_name:%s" % (block_name, register_name, field_name) )
        if 'r' == self._register[block_name][register_name][field_name]['action']:
            field_value = self._register[block_name][register_name][field_name]['default']
        field_value = self._register[block_name][register_name][field_name]['value']
        return field_value

    # Get field enum
    def get_field_enum(self, block_name, register_name, field_name):
        field_value = self.get_field_value(block_name, register_name, field_name)
        field_enum = hex(field_value)
        if 0 != len(self._register[block_name][register_name][field_name]["enums"]):
            swap_enums = {y:x for x,y in self._register[block_name][register_name][field_name]["enums"].items() }
            field_enum = swap_enums[self._register[block_name][register_name][field_name]['value']]
        return field_enum

    # Set field value in block
    def set_field_value_in_block(self, block_name, field_name, field_value):
        register_name = self.get_register_name_by_field_name(block_name, field_name)
        self.set_field_value(block_name, register_name, field_name, field_value)

    # Get register value
    def get_register_value(self, block_name, register_name):
        return self._register[block_name][register_name]["value"]

    # Update register value from field
    def update_register_value_from_field(self, block_name, register_name):
        if False == self._is_register_manual_loaded:
            raise Exception("NvdlaRegisterConfiguration", "Register manual has not been loaded")
        if self._register[block_name][register_name]["edited"] is False:
            return
        register_value = self._register[block_name][register_name]['value']
        if 0x0 != self._register[block_name][register_name]['write_mask']:
            register_value = 0
            for field_name in self._register[block_name][register_name]['field_list']:
                if ('w' not in self._register[block_name][register_name][field_name]['action']) or (self._register[block_name][register_name][field_name]["edited"] is False):
                    field_value = self._register[block_name][register_name][field_name]['default']
                else:
                    field_value = self._register[block_name][register_name][field_name]['value']
                print ("nvdla_register_configuration::update_register_value_from_field: block_name:%s, register_name:%s, field_name:%s, field_value:%s" % (block_name, register_name, field_name, hex(field_value)) )
                register_value = register_value | ( ( field_value
                                                    << self._register[block_name][register_name][field_name]['lsb']
                                                    )
                                                  & self._register[block_name][register_name][field_name]['field']
                                                  )
        self._register[block_name][register_name]['value'] = register_value
        print ("nvdla_register_configuration::update_register_value_from_field: block_name:%s, register_name:%s, register_value:%s" % (block_name, register_name, hex(register_value)) )

    # Update register value within a block
    def update_register_value_in_block(self, block_name):
        for register_name in self._register[block_name]['register_list']:
            self.update_register_value_from_field(block_name, register_name)
            
    # Print a block
    def print_block_content(self, block_name):
        print ("_"*25+"print_block_content, start"+"_"*25+"\n")
        for register_name in self._register[block_name]['register_list']:
            print ("-"*4+register_name+' : '+hex(self._register[block_name][register_name]['value']) )
            for field_name in self._register[block_name][register_name]['field_list']:
                if 0 != len(self._register[block_name][register_name][field_name]["enums"]):
                    swap_enums = {y:x for x,y in self._register[block_name][register_name][field_name]["enums"].items() }
                    #print ("swap_enums:"+register_name+field_name+'\n')
                    #print (swap_enums)
                    print ("-"*8+field_name+' : '+swap_enums[self._register[block_name][register_name][field_name]['value']]+' : '+hex(self._register[block_name][register_name][field_name]['value']) )
                else:
                    print ("-"*8+field_name+' : '+hex(self._register[block_name][register_name][field_name]['value']) )
        print ("_"*25+"print_block_content, done"+"_"*25+"\n")

    def print_edited_register_content_in_block(self, block_name):
        print ("_"*25+"print_edited_register_content_in_block, start"+"_"*25+"\n")
        for register_name in self._register[block_name]['register_list']:
            if self._register[block_name][register_name]['edited'] is True:
                print ("-"*4+register_name+' : '+hex(self._register[block_name][register_name]['value']) )
                for field_name in self._register[block_name][register_name]['field_list']:
                    if 0 != len(self._register[block_name][register_name][field_name]["enums"]):
                        swap_enums = {y:x for x,y in self._register[block_name][register_name][field_name]["enums"].items() }
                        #print ("swap_enums:"+register_name+field_name+'\n')
                        #print (swap_enums)
                        print ("-"*8+field_name+' : '+swap_enums[self._register[block_name][register_name][field_name]['value']]+' : '+hex(self._register[block_name][register_name][field_name]['value']) )
                    else:
                        print ("-"*8+field_name+' : '+hex(self._register[block_name][register_name][field_name]['value']) )
        print ("_"*25+"print_edited_register_content_in_block, done"+"_"*25+"\n")

if __name__ == '__main__':
    reg_inst = NvdlaRegisterConfiguration ('Good')
    reg_inst.load_register_manual("C:/work/osdla_test_writer/arnvdla.py")
    reg_inst.set_block_enable("NVDLA_SDP")
    reg_inst.update_register_value_in_block("NVDLA_SDP")
    reg_inst.print_block_content("NVDLA_SDP")
    reg_inst.print_edited_register_content_in_block("NVDLA_SDP")
