#!/usr/bin/env python
from nvdla_test import NvdlaTest
import os

working_dir = os.getcwd()
test_dir  = os.path.dirname(os.path.realpath(__file__))
file_name = os.path.basename(__file__)

test = NvdlaTest(file_name)
#test.load_register_manual_file("nvdla.py")
test.load_register_manual_file("../../../outdir/nv_small/spec/manuals/opendla.py")
test.add_hardware_layer("layer_0", "SDP")
test.add_hardware_layer("layer_1", "SDP")
test.add_hardware_layer("layer_2", "PDP")
layer_3_name = test.add_hardware_layer("auto_layer_name", "CONV_SDP")
layer_0 = {
    'sdp.width':7,
    'sdp.height':7,
    'sdp.channel':31,
    }

layer_1 = {
    'sdp.width':15,
    'sdp.height':15,
    'sdp.channel':31,
    }

layer_2 = {
    'pdp.cube_out_width':3,
    'pdp.cube_out_height':3,
    'pdp.cube_out_channel':31,
    'pdp.cube_in_width':7,
    'pdp.cube_in_height':7,
    'pdp.cube_in_channel':31,
    }

layer_3 = {
    'sdp.width':7,
    'sdp.height':7,
    'sdp.channel':31,
    }

test.update_layer_setting("layer_0", layer_0)
test.update_layer_setting("layer_1", layer_1)
test.update_layer_setting("layer_2", layer_2)
test.update_layer_setting(layer_3_name, layer_3)
test.compose_test()
#test.generate_dino_config_file(trace_file_path)
test.generate_trace_config_file(trace_file_path)
