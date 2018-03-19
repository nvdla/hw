#!/usr/bin/env python
import nvdla_python_test_common as test_common

def run(project):
    test, test_name, test_shortcut = test_common.creat_test(__file__, project)
    address_lsb_mask_bits = test_shortcut['address_lsb_mask_bits']
    layer_name = test.add_hardware_layer("auto_layer_name", "CDP")
    layer_config = {
        'cdp.width':7,
        'cdp.height':7,
        'cdp.channel':31,
        'cdp.input_data':'INT8',
        'cdp.input_data_type':'INT8',
        #'cdp.src_base_addr_low':0x4000000,
        'cdp.src_base_addr_low':0x80000000 >> address_lsb_mask_bits,
        'cdp.src_base_addr_high':0,
        'cdp.src_line_stride':8,
        'cdp.src_surface_stride':64,
        'cdp.src_ram_type': 'src_ram_type_MC',
        #'cdp.dst_base_addr_low':0x4004000,
        'cdp.dst_base_addr_low':0x80080000 >> address_lsb_mask_bits,
        'cdp.dst_base_addr_high':0,
        'cdp.dst_line_stride':8,
        'cdp.dst_surface_stride':64,
        'cdp.dst_ram_type': 'MC',
        'cdp.sqsum_bypass': 'enable',
        'cdp.mul_bypass': 'enable',
        'cdp.normalz_len': 'len3',
    
        'cdp.datin_offset': 0x80,
        'cdp.datout_offset': 0x80,
    
        'cdp.lut_le_function':'linear',
        'cdp.lut_le_index_select':0,
        'cdp.lut_le_start_low':0,
        'cdp.lut_le_start_high':0,
        'cdp.lut_le_end_low':64,
        'cdp.lut_le_end_high':0,
    
        'cdp.lut_lo_index_select':0,
        'cdp.lut_lo_start_low':0,
        'cdp.lut_lo_start_high':0,
        'cdp.lut_lo_end_low':256,
        'cdp.lut_lo_end_high':0,
        }
    test.update_layer_setting(layer_name, layer_config)
    test.update_layer_memory(layer_name, {'input':'OFFSET', 'output':'RANDOM'})
    test.update_layer_lut_table(layer_name, {'LE':'x','LO':'x'})
    test_common.generate_trace(test, test_name)

if __name__ == "__main__":
    run('nv_small')
