add_test(name='dc_8x16x128_3x3x128x32_int8',    #cc_full_feature_0
         tags=['L0', 'cc'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG, '-uwm cmod_only'],
         config=['nvdla_utb'],
         desc='''copied from cc_small_full_feature_0, kernel stride 1x1, unpacked, pad L/T/B, no clip truncate, partial weight''')

add_test(name='img_51x96x4_1x10x4x32_R8G8B8A8_int8_0', #pixel format 0xf
         tags=['L0','cc', 'img'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG, '-uwm cmod_only'],
         config=['nvdla_utb'],
         desc='''copied from cc_small_full_feature_17, kernel stride 2x2, unpacked, no padding, clip truncate 3, full weight, input cvt enable, cvt_scale 1, cvt_offset 0, cvt_truncate 0''')


