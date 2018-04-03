rtlarg = '-rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM']

for i in range(plan_arguments['RUN_NUM']):
    ############################################# CC #############################################
    add_test(name='cc_max_datain_width_ctest',
             tags=['L21', 'cc', 'cover'],
             args=[rtlarg, get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse CC semi-random case, to cover max value of input cube width''')

    add_test(name='cc_max_datain_height_ctest',
             tags=['L21', 'cc', 'cover'],
             args=[rtlarg, get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse CC semi-random case, to cover max value of input cube height''')

    add_test(name='cc_max_datain_channel_ctest',
             tags=['L21', 'cc', 'cover'],
             args=[rtlarg, get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse CC semi-random case, to cover max value of input cube channel''')

    add_test(name='cc_max_dataout_width_ctest',
             tags=['L21', 'cc', 'cover'],
             args=[rtlarg, get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse CC semi-random case, to cover max value of output cube width''')

    add_test(name='cc_max_dataout_height_ctest',
             tags=['L21', 'cc', 'cover'],
             args=[rtlarg, get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse CC semi-random case, to cover max value of output cube height''')

    add_test(name='cc_max_dataout_channel_ctest',
             tags=['L21', 'cc', 'cover'],
             args=[rtlarg, get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse CC semi-random case, to cover max value of output cube channel''')

    ############################################# SDP #############################################
    add_test(name='sdp_max_cube_width_ctest',
             tags=['L21', 'sdp', 'cover'],
             args=[rtlarg, get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse sdp semi-random case, to cover max value of input cube width''')

    add_test(name='sdp_max_cube_height_ctest',
             tags=['L21', 'sdp', 'cover'],
             args=[rtlarg, get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse sdp semi-random case, to cover max value of input cube height''')

    add_test(name='sdp_max_cube_channel_ctest',
             tags=['L21', 'sdp', 'cover'],
             args=[rtlarg, get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse sdp semi-random case, to cover max value of input cube channel''')

    ############################################# PDP #############################################
    add_test(name='pdp_max_cube_in_width_ctest',
             tags=['L21', 'pdp', 'cover'],
             args=[rtlarg, get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse PDP semi-random case, to cover max value of input cube width''')

    add_test(name='pdp_max_cube_in_height_ctest',
             tags=['L21', 'pdp', 'cover'],
             args=[rtlarg, get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse PDP semi-random case, to cover max value of input cube height''')

    add_test(name='pdp_max_cube_in_channel_ctest',
             tags=['L21', 'pdp', 'cover'],
             args=[rtlarg, get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse PDP semi-random case, to cover max value of input cube channel''')

    add_test(name='pdp_max_cube_out_width_ctest',
             tags=['L21', 'pdp', 'cover'],
             args=[rtlarg, get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse PDP semi-random case, to cover max value of output cube width''')

    add_test(name='pdp_max_cube_out_height_ctest',
             tags=['L21', 'pdp', 'cover'],
             args=[rtlarg, get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse PDP semi-random case, to cover max value of output cube height''')

    add_test(name='pdp_max_cube_out_channel_ctest',
             tags=['L21', 'pdp', 'cover'],
             args=[rtlarg, get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse PDP semi-random case, to cover max value of output cube channel''')

    add_test(name='pdp_split_ctest',
             tags=['L21', 'pdp', 'cover'],
             args=[rtlarg, get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None resue PDP semi-random case, to cover large split out size ''')

    ############################################# CDP #############################################
    add_test(name='cdp_max_cube_width_ctest',
             tags=['L21', 'cdp', 'cover'],
             args=[rtlarg, get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse CDP semi-random case, to cover max value of input cube width''')

    add_test(name='cdp_max_cube_height_ctest',
             tags=['L21', 'cdp', 'cover'],
             args=[rtlarg, get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse CDP semi-random case, to cover max value of input cube height''')

    add_test(name='cdp_max_cube_channel_ctest',
             tags=['L21', 'cdp', 'cover'],
             args=[rtlarg, get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse CDP semi-random case, to cover max value of input cube channel''')

