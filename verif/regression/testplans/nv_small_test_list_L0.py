############################################# Register Accessing ###################################
add_test(name='nvdla_reg_accessing',
         tags=['L0','protection'],
         module='nvdla_python_test',
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG, '-uwm RTL_ONLY'],
         config=['nvdla_utb'],
         desc='''Check reset value''')

############################################# PDP ###################################
add_test(name='pdp_8x8x32_1x1_int8_0',
         tags=['L0', 'pdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''pdp_passthrough_8x8x32_pack_all_zero_int8''')

add_test(name='pdp_8x8x32_1x1_int8_1',
         tags=['L0', 'pdp','protection'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''pdp_passthrough_8x8x32_pack_inc_int8''')

add_test(name='pdp_8x8x64_2x2_int8',
         tags=['L0', 'pdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''basic test, max. kernel_size=2x2''')

add_test(name='pdp_7x9x10_3x3_int8',
         tags=['L0', 'pdp','protection'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''basic test, max. kernel_size=3x3''')

############################################# SDP ###################################
add_test(name='sdp_8x8x32_bypass_int8_1',
         tags=['L0', 'sdp','protection'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''sdp_passthrough_8x8x32_pack_inc_int8''')

add_test(name='sdp_8x8x32_bypass_int8_0',
         tags=['L0', 'sdp','protection'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''sdp_passthrough_8x8x32_pack_all_zero_int8''')

add_test(name='sdp_4x22x42_bypass_int8',
         tags=['L0', 'sdp','protection'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''basic test''')

############################################# CDP ###################################
add_test(name='cdp_8x8x32_lrn3_int8_0',
         tags=['L0', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''cdp_passthrough_8x8x32_pack_zero_int8''')

add_test(name='cdp_8x8x32_lrn3_int8_1',
         tags=['L0', 'cdp','protection'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''cdp_passthrough_8x8x32_pack_inc_int8''')

add_test(name='cdp_8x8x32_lrn3_int8_2',
         tags=['L0', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''basic test, lrn=3''')

add_test(name='cdp_8x8x64_lrn9_int8',
         tags=['L0', 'cdp','protection'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''basic test, lrn=9''')

############################################# CC ####################################
#DC mode
add_test(name='dc_8x16x128_3x3x128x32_int8',    #cc_full_feature_0
         tags=['L0', 'cc'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''copied from cc_small_full_feature_0, kernel stride 1x1, unpacked, pad L/T/B, no clip truncate, partial weight''')

add_test(name='dc_24x33x55_5x5x55x25_int8_0',
         tags=['L0','cc','protection'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''copied from cc_small_full_feature_5, kernel stride 4x3, unpacked, pad L/R/T/B, clip truncate 4, full weight''')

add_test(name='dc_8x8x36_4x4x36x16_dilation_int8_0',
         tags=['L0','cc'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''converted from cc_dilat_stest, kernel stride 2x2, dilation 2x2, unpacked, pad L/T, clip truncate 1''')

#Image-in mode
add_test(name='img_51x96x4_1x10x4x32_A8B8G8R8_int8_0', #pixel format 0xc
         tags=['L0','cc'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''converted from cc_small_full_feature_17, kernel stride 2x2, unpacked, no padding, clip truncate 3, full weight, input cvt enable, cvt_scale 2, cvt_offset 0, cvt_truncate 0''')
