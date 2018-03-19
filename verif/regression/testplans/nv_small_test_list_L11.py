for i in range(plan_arguments['RUN_NUM']):
    ############################################# multi resource #############################################
    add_test(name='cc_sdprdma_sdp_rtest',
             tags=['L11', 'cc','sdp','sdprdma'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' random case: CC+SDP+SDPRDMA ''')

    add_test(name='cc_sdprdma_sdp_pdp_rtest',
             tags=['L11', 'cc','sdp','sdprdma','pdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' random case: CC+SDP+SDPRDMA+PDP ''')


    add_test(name='cc_sdp_pdp_rtest',
             tags=['L11', 'cc','sdp','pdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' random case: CC+SDP+PDP ''')

    add_test(name='sdprdma_sdp_pdp_rtest',
             tags=['L11', 'sdp','sdprdma','pdp'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' random case: SDPRDMA+SDP+PDP ''')

    ############################################# multi scenario #############################################
    add_test(name='multi_scenario_rtest',
             tags=['L11', 'multi_scenario'],
             args=[' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'], get_seed_args(), DISABLE_COMPARE_ALL_UNITS_SB_ARG],
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' random case for full scenario list ''')

