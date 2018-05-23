## ----------------------------------------------------------------------------
## This testplan is for functional coverage closure purpose.
## ----------------------------------------------------------------------------

common_args = [
    get_seed_args(),
    DISABLE_COMPARE_ALL_UNITS_SB_ARG,
    ' -rtlarg +uvm_set_config_int=uvm_test_top,layers,%d ' % plan_arguments['LAYER_NUM'],
]

#for i in range(plan_arguments['RUN_NUM']):
for i in range(1):
    ############################################# CC #############################################
    for subtest in range(10):
        _args = list(common_args)
        _args.append(' -rtlarg +uvm_set_config_int=*,subtest,%d ' % subtest)

        add_test(name='cc_in_width_ctest',
                 tags=['L21', 'cc', 'cover'],
                 args=_args,
                 module='nvdla_uvm_test',
                 config=['nvdla_utb'],
                 desc=''' None reuse CC semi-random case, to cover values of input cube width''')

        add_test(name='cc_in_height_ctest',
                 tags=['L21', 'cc', 'cover'],
                 args=_args,
                 module='nvdla_uvm_test',
                 config=['nvdla_utb'],
                 desc=''' None reuse CC semi-random case, to cover values of input cube height''')

        add_test(name='cc_in_channel_ctest',
                 tags=['L21', 'cc', 'cover'],
                 args=_args,
                 module='nvdla_uvm_test',
                 config=['nvdla_utb'],
                 desc=''' None reuse CC semi-random case, to cover values of input cube channel''')

        add_test(name='cc_out_width_ctest',
                 tags=['L21', 'cc', 'cover'],
                 args=_args,
                 module='nvdla_uvm_test',
                 config=['nvdla_utb'],
                 desc=''' None reuse CC semi-random case, to cover values of output cube width''')

        add_test(name='cc_out_height_ctest',
                 tags=['L21', 'cc', 'cover'],
                 args=_args,
                 module='nvdla_uvm_test',
                 config=['nvdla_utb'],
                 desc=''' None reuse CC semi-random case, to cover values of output cube height''')

        add_test(name='cc_out_channel_ctest',
                 tags=['L21', 'cc', 'cover'],
                 args=_args,
                 module='nvdla_uvm_test',
                 config=['nvdla_utb'],
                 desc=''' None reuse CC semi-random case, to cover values of output cube channel''')

    # Add corner test to cover below cross cover bins (see nvdla_coverage_conv.sv):
    # - cr_data_reuse_datain_format_pixel_mapping_pixel_format_line_stride_pitch_0
    # - cr_data_reuse_datain_format_pixel_mapping_pixel_format_line_stride_pitch_1
    # - cr_data_reuse_datain_format_pixel_mapping_pixel_format_line_stride_pitch_2
    # - cr_data_reuse_datain_format_pixel_mapping_pixel_format_uv_line_stride

    for subtest in range(10):
#       # INT16_FP16 only
#       for pixel_format in range(0x14, 0x1a): # [A2B10G10R10:V10U10Y10A2]
#           _args = list(common_args),
#           _args.append(' -rtlarg +uvm_set_config_int=*,pixel_format,%d ' % pixel_format)
#           _args.append(' -rtlarg +uvm_set_config_int=*,subtest,%d ' % subtest)
#           add_test(name='cc_pitch_line_stride_0_ctest',
#                    tags=['L21', 'cc', 'cover'],
#                    args=_args,
#                    module='nvdla_uvm_test',
#                    config=['nvdla_utb'],
#                    desc=''' None reuse CC random case, input data format is fixed as image ''')

        for pixel_format in [0x1c, 0x1d]: # Y8___U8V8_N444 and Y8___V8U8_N444
            _args = list(common_args)
            _args.append(' -rtlarg +uvm_set_config_int=*,pixel_format,%d ' % pixel_format)
            _args.append(' -rtlarg +uvm_set_config_int=*,subtest,%d ' % subtest)
            add_test(name='cc_pitch_line_stride_0_ctest',
                     tags=['L21', 'cc', 'cover'],
                     args=_args,
                     module='nvdla_uvm_test',
                     config=['nvdla_utb'],
                     desc=''' None reuse CC random case, input data format is fixed as image ''')

        for pixel_format in list(range(0xc, 0x14)) + [0, 0x1a, 0x1b]: # R8, [A8B8G8R8:R8G8B8X8], A8Y8U8V8 and V8U8Y8A8
            _args = list(common_args)
            _args.append(' -rtlarg +uvm_set_config_int=*,pixel_format,%d ' % pixel_format)
            _args.append(' -rtlarg +uvm_set_config_int=*,subtest,%d ' % subtest)
            add_test(name='cc_pitch_line_stride_2_ctest',
                     tags=['L21', 'cc', 'cover'],
                     args=_args,
                     module='nvdla_uvm_test',
                     config=['nvdla_utb'],
                     desc=''' None reuse CC random case, input data format is fixed as image ''')

        for pixel_format in [0x1c, 0x1d]: # Y8___U8V8_N444 and Y8___V8U8_N444
            _args = list(common_args)
            _args.append(' -rtlarg +uvm_set_config_int=*,pixel_format,%d ' % pixel_format)
            _args.append(' -rtlarg +uvm_set_config_int=*,subtest,%d ' % subtest)
            add_test(name='cc_pitch_line_stride_3_ctest',
                     tags=['L21', 'cc', 'cover'],
                     args=_args,
                     module='nvdla_uvm_test',
                     config=['nvdla_utb'],
                     desc=''' None reuse CC random case, input data format is fixed as image ''')

    ############################################# SDP #############################################
    for subtest in range(10):
        for flying_mode in ['flying_mode_ON', 'flying_mode_OFF']:
            _args = list(common_args)
            _args.append(' -rtlarg +uvm_set_config_string=*,flying_mode,%s ' % flying_mode)
            _args.append(' -rtlarg +uvm_set_config_int=*,subtest,%d ' % subtest)

            add_test(name='sdp_width_ctest',
                     tags=['L21', 'sdp', 'cover'],
                     args=_args,
                     module='nvdla_uvm_test',
                     config=['nvdla_utb'],
                     desc=''' None reuse sdp semi-random case, to cover cross between flying_mode and input cube width''')

            add_test(name='sdp_height_ctest',
                     tags=['L21', 'sdp', 'cover'],
                     args=_args,
                     module='nvdla_uvm_test',
                     config=['nvdla_utb'],
                     desc=''' None reuse sdp semi-random case, to cover cross between flying_mode and input cube height''')

            add_test(name='sdp_channel_ctest',
                     tags=['L21', 'sdp', 'cover'],
                     args=_args,
                     module='nvdla_uvm_test',
                     config=['nvdla_utb'],
                     desc=''' None reuse sdp semi-random case, to cover cross between flying_mode and input cube channel''')

    ############################################# PDP #############################################
    for subtest in range(10):
        for flying_mode in ['flying_mode_ON', 'flying_mode_OFF']:
            _args = list(common_args)
            _args.append(' -rtlarg +uvm_set_config_string=*,flying_mode,%s ' % flying_mode)
            _args.append(' -rtlarg +uvm_set_config_int=*,subtest,%d ' % subtest)

            if (flying_mode == 'flying_mode_OFF') or (flying_mode == 'flying_mode_ON' and subtest < 3):
                add_test(name='pdp_in_width_ctest',
                         tags=['L21', 'pdp', 'cover'],
                         args=_args,
                         module='nvdla_uvm_test',
                         config=['nvdla_utb'],
                         desc=''' None reuse PDP semi-random case, to cover value range of input cube width''')

            add_test(name='pdp_in_height_ctest',
                     tags=['L21', 'pdp', 'cover'],
                     args=_args,
                     module='nvdla_uvm_test',
                     config=['nvdla_utb'],
                     desc=''' None reuse PDP semi-random case, to cover value range of input cube height''')

            add_test(name='pdp_in_channel_ctest',
                     tags=['L21', 'pdp', 'cover'],
                     args=_args,
                     module='nvdla_uvm_test',
                     config=['nvdla_utb'],
                     desc=''' None reuse PDP semi-random case, to cover value range of input cube channel''')


    for subtest in range(10):
        _args = list(common_args)
        _args.append(' -rtlarg +uvm_set_config_int=*,subtest,%d ' % subtest)

        add_test(name='pdp_out_width_ctest',
                 tags=['L21', 'pdp', 'cover'],
                 args=_args,
                 module='nvdla_uvm_test',
                 config=['nvdla_utb'],
                 desc=''' None reuse PDP semi-random case, to cover value range of output cube width''')

        add_test(name='pdp_out_height_ctest',
                 tags=['L21', 'pdp', 'cover'],
                 args=_args,
                 module='nvdla_uvm_test',
                 config=['nvdla_utb'],
                 desc=''' None reuse PDP semi-random case, to cover value range of output cube height''')

        add_test(name='pdp_out_channel_ctest',
                 tags=['L21', 'pdp', 'cover'],
                 args=_args,
                 module='nvdla_uvm_test',
                 config=['nvdla_utb'],
                 desc=''' None reuse PDP semi-random case, to cover value range of output cube channel''')

    for subtest in range(10):
        _args = list(common_args)
        _args.append(' -rtlarg +uvm_set_config_int=*,subtest,%d ' % subtest)

        add_test(name='pdp_partial_width_in_first_ctest',
                 tags=['L21', 'pdp', 'cover'],
                 args = _args,
                 module='nvdla_uvm_test',
                 config=['nvdla_utb'],
                 desc=''' None reuse PDP semi-random case, to cover values of partial_width_in_first''')

        add_test(name='pdp_partial_width_in_last_ctest',
                 tags=['L21', 'pdp', 'cover'],
                 args = _args,
                 module='nvdla_uvm_test',
                 config=['nvdla_utb'],
                 desc=''' None reuse PDP semi-random case, to cover values of partial_width_in_last''')

        add_test(name='pdp_partial_width_in_mid_ctest',
                 tags=['L21', 'pdp', 'cover'],
                 args = _args,
                 module='nvdla_uvm_test',
                 config=['nvdla_utb'],
                 desc=''' None reuse PDP semi-random case, to cover values of partial_width_in_mid''')

    add_test(name='pdp_split_ctest',
             tags=['L21', 'pdp', 'cover'],
             args = list(common_args),
             module='nvdla_uvm_test',
             config=['nvdla_utb'],
             desc=''' None resue PDP semi-random case, to cover large split out size ''')

    ############################################# CDP #############################################
    for subtest in range(10):
        _args = list(common_args)
        _args.append(' -rtlarg +uvm_set_config_int=*,subtest,%d ' % subtest)

        add_test(name='cdp_width_ctest',
                 tags=['L21', 'cdp', 'cover'],
                 args=_args,
                 module='nvdla_uvm_test',
                 config=['nvdla_utb'],
                 desc=''' None reuse CDP semi-random case, to cover value range of input cube width''')

        add_test(name='cdp_height_ctest',
                 tags=['L21', 'cdp', 'cover'],
                 args=_args,
                 module='nvdla_uvm_test',
                 config=['nvdla_utb'],
                 desc=''' None reuse CDP semi-random case, to cover value range of input cube height''')

        add_test(name='cdp_channel_ctest',
                 tags=['L21', 'cdp', 'cover'],
                 args=_args,
                 module='nvdla_uvm_test',
                 config=['nvdla_utb'],
                 desc=''' None reuse CDP semi-random case, to cover value range of input cube channel''')

    # To cover below coverpoints(see nvdla_coverage_cdp.sv):
    # - cp_lut_le_slope_uflow_scale
    # - cp_lut_le_slope_oflow_scale
    # - cp_lut_lo_slope_uflow_scale
    # - cp_lut_lo_slope_oflow_scale

    for subtest in range(8):
        _args = list(common_args)
        _args.append(' -rtlarg +uvm_set_config_int=*,subtest,%d ' % subtest)
        add_test(name='cdp_lut_max_slope_flow_scale_ctest',
                 tags=['L21', 'cdp', 'cover'],
                 args=_args,
                 module='nvdla_uvm_test',
                 config=['nvdla_utb'],
                 desc=''' CDP random case ''')
