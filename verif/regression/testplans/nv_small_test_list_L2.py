
#PDP
"""
add_test(name='pdp_16x12x8_1x8_max_int8_0', #line buffer full use
         tags=['L2', 'pdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''line buffer full use
                 sdp is passthrough. In output cvt of sdp, scale=1, shift=0, offset=0.
                 pad_left=0, pad_top=6, pad_right=0, pad_bottom=7. pad value=0x0. output cube size=16x18x8
                 stride_x=stride_y=1
         ''')

add_test(name='pdp_16x16x8192_2x2_ave_int8_1', #Max C
         tags=['L2', 'pdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''average operation.
                 pad_left=pad_top=pad_right=pad_bottom=0. pad value=0x0. output cube size=8x8x8192
                 stride_x=2, stride_y=2
         ''')
"""

#CC
add_test(name='dc_8192x1x1_2x3x1x41_int8_0',
         tags=['L2', 'cc'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''test max width number, kernel stride 2x2, unpacked, pad L/R/T/B, clip truncate 2''')

#add_test(name='dc_1x8192x1_1x1x1x32_int8_0',
#         tags=['L1','cc'],
#         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
#         config=['nvdla_utb'],
#         desc='''test max height number, kernel stride 1x1, line unpacked, surface unpacked, no padding, clip truncate 0''')

add_test(name='dc_4x1x8192_1x1x8192x1_int8_0',
         tags=['L2', 'cc'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''test max channel number, kernel stride 3x5, unpacked, no padding, clip truncate 7''')

#SDP
add_test(name='sdp_4x1x8192_pass_through_int8_0',
         tags=['L2', 'sdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''test max channel number, bypass bs, bypass bn, bypass ew''')

add_test(name='sdp_8192x1x1_pass_through_int8_0',
         tags=['L2', 'sdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''test max width number, bypass bs, bypass bn, bypass ew''')

add_test(name='sdp_1x8192x1_pass_through_int8_0',
         tags=['L2', 'sdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''test max height number, bypass bs, bypass bn, bypass ew''')

add_test(name='sdp_1x1x1_pass_through_int8',
         tags=['L2', 'sdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''test 1x1x1 case, bypass bs, bypass bn, bypass ew''')
