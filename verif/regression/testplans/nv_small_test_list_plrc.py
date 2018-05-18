for i in range(plan_arguments['RUN_NUM']):
    ############################################# CC #############################################
    add_test(name='cc_feature_rtest',
             tags=['cc'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse CC random case, input data format is fixed as feature ''')

    add_test(name='cc_pitch_rtest',
             tags=['cc'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse CC random case, input data format is fixed as image ''')

    add_test(name='cc_rtest',
             tags=['cc'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None reuse CC random case ''')

    add_test(name='cc_sdprdma_sdp_rtest',
             tags=['cc','sdp','sdprdma'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' random case: CC+SDP+SDPRDMA ''')

    add_test(name='cc_sdprdma_sdp_pdp_rtest',
             tags=['cc','sdp','sdprdma','pdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' random case: CC+SDP+SDPRDMA+PDP ''')


    add_test(name='cc_sdp_pdp_rtest',
             tags=['cc','sdp','pdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' random case: CC+SDP+PDP ''')

    add_test(name='sdprdma_sdp_pdp_rtest',
             tags=['sdp','sdprdma','pdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' random case: SDPRDMA+SDP+PDP ''')


    ############################################## PDP #############################################

    add_test(name='pdp_split_rtest',
             tags=['pdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' PDP random case, fixed to split mode ''')

    add_test(name='pdp_non_split_rtest',
             tags=['pdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' PDP random case, fixed to non-split mode ''')

    add_test(name='pdp_rtest',
             tags=['pdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' PDP random case ''')


    ############################################# SDP #############################################

    add_test(name='sdp_bs_rtest',
             tags=['sdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' SDP offline random case, with BS enabled and not bypassed ''')

    add_test(name='sdp_bn_rtest',
             tags=['sdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' SDP offline random case, with BN enabled and not bypassed ''')

    add_test(name='sdp_rtest',
             tags=['sdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' SDP offline random case ''')

    ############################################# CDP #############################################

    add_test(name='cdp_exp_rtest',
             tags=['cdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' CDP random case, fixed to EXPONENT mode of LE LUT ''')

    add_test(name='cdp_lin_rtest',
             tags=['cdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' CDP random case, fixed to LINEAR mode of LE LUT ''')

    add_test(name='cdp_rtest',
             tags=['cdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' CDP random case ''')

