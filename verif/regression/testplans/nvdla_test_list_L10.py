for i in range(plan_arguments['RUN_NUM']):
    ############################################# CC #############################################
    add_test(name='cc_feature_rtest',
             tags=['L10', 'cc'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse CC random case, input data format is fixed as feature ''')

    add_test(name='cc_pitch_rtest',
             tags=['L10', 'cc'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse CC random case, input data format is fixed as image ''')


    add_test(name='cc_feature_data_full_reuse_rtest',
             tags=['L10', 'cc'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,2 ', get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG], # for reuse case, at least 2 layers are required
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' CC reuse input data random case, input data format is fixed as feature ''')

    add_test(name='cc_feature_weight_full_reuse_rtest',
             tags=['L10', 'cc'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,2 ', get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG], # for reuse case, at least 2 layers are required
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' CC reuse weight random case, input data format is fixed as feature ''')

    add_test(name='cc_image_data_full_reuse_rtest',
             tags=['L10', 'cc'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,2 ', get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG], # for reuse case, at least 2 layers are required
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' CC reuse input data random case, input data format is fixed as image ''')

    add_test(name='cc_rtest',
             tags=['L10', 'cc'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse CC random case ''')


    ############################################## PDP #############################################

    add_test(name='pdp_split_rtest',
             tags=['L10', 'pdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' PDP random case, fixed to split mode ''')

    add_test(name='pdp_non_split_rtest',
             tags=['L10', 'pdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' PDP random case, fixed to non-split mode ''')

    add_test(name='pdp_rtest',
             tags=['L10', 'pdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' PDP random case ''')


    ############################################# SDP #############################################

    if 'NVDLA_SDP_BS_ENABLE' in project.PROJVAR and project.PROJVAR['NVDLA_SDP_BS_ENABLE'] is True:
        add_test(name='sdp_bs_rtest',
                 tags=['L10', 'sdp'],
                 args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
                 module='nvdla_uvm_test',
                 config=['nvdla_utb'],
                 desc=''' SDP offline random case, with BS enabled and not bypassed ''')

    if 'NVDLA_SDP_BN_ENABLE' in project.PROJVAR and project.PROJVAR['NVDLA_SDP_BN_ENABLE'] is True:
        add_test(name='sdp_bn_rtest',
                 tags=['L10', 'sdp'],
                 args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
                 module='nvdla_uvm_test',
                 config=['nvdla_utb'],
                 desc=''' SDP offline random case, with BN enabled and not bypassed ''')

    if 'NVDLA_SDP_EW_ENABLE' in project.PROJVAR and project.PROJVAR['NVDLA_SDP_EW_ENABLE'] is True:
        add_test(name='sdp_ew_rtest',
                 tags=['L10', 'sdp'],
                 args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
                 module='nvdla_uvm_test',
                 config=['nvdla_utb'],
                 desc=''' SDP offline random case, with EW enabled and not bypassed ''')

    add_test(name='sdp_rtest',
             tags=['L10', 'sdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' SDP offline random case ''')

    ############################################# CDP #############################################

    add_test(name='cdp_exp_rtest',
             tags=['L10', 'cdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' CDP random case, fixed to EXPONENT mode of LE LUT ''')

    add_test(name='cdp_lin_rtest',
             tags=['L10', 'cdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' CDP random case, fixed to LINEAR mode of LE LUT ''')

    add_test(name='cdp_rtest',
             tags=['L10', 'cdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' CDP random case ''')

