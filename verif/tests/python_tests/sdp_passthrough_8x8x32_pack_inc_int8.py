#!/usr/bin/env python
import nvdla_python_test_common as test_common

def run(project):
    test, test_name, test_shortcut = test_common.creat_test(__file__, project)
    address_lsb_mask_bits = test_shortcut['address_lsb_mask_bits']
    layer_name = test.add_hardware_layer("auto_layer_name", "SDP")
    layer_config = {
        'sdp.src_base_addr_high' : 0,
        'sdp.dst_base_addr_high' : 0,
        #'sdp.src_base_addr_low' : 0x4000000,
        #'sdp.dst_base_addr_low' : 0x4004000,
        'sdp.src_base_addr_low' : 0x80000000 >> address_lsb_mask_bits,
        'sdp.dst_base_addr_low' : 0x80080000 >> address_lsb_mask_bits,
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
        'sdp.cvt_scale': 1,
    }
    test.update_layer_setting(layer_name, layer_config)
    test.update_layer_memory(layer_name, {'input':'OFFSET', 'output':'RANDOM'})
    test_common.generate_trace(test, test_name)

if __name__ == "__main__":
    run('nv_small')
