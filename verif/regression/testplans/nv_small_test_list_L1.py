#PDP
add_test(name='pdp_8x8x64_2x2_ave_int8_0',
         tags=['L1', 'pdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''basic test, average operation
                 pad_left=pad_top=0, pad_right=pad_bottom=1. pad value=0. output cube size=8x8x64
                 stride_x=stride_y=1
         ''')

add_test(name='pdp_8x8x64_2x2_min_int8_0',
         tags=['L1', 'pdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''basic test, min operation
                 pad_left=pad_top=0, pad_right=pad_bottom=1. pad value=0. output cube size=8x8x64
                 stride_x=stride_y=1
         ''')

add_test(name='pdp_1x1x1_3x3_ave_int8_0',
         tags=['L1', 'pdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''cube of size 1x1x1
                 pad_left=pad_top=2, pad_right=pad_bottom=0. pad value=0x10. output cube size=1x1x1
                 stride_x=stride_y=2
         ''')

add_test(name='pdp_1x3x8_8x8_ave_int8_0',  #out 1x1xN. With bubble in normal process
         tags=['L1', 'pdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''output cube of size 1x1xN.
                 pad_left=1, pad_top=2, pad_right=6, pad_bottom=3. pad value=0x7f. output cube size=1x1x8
                 stride_x=stride_y=1
         ''')

add_test(name='pdp_5x7x8_4x1_split_max_int8_0', #normal split=2
         tags=['L1', 'pdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''split_num=2. max operation
                 partial_width_in_first=3, partial_width_in_mid=2, partial_width_in_last=2
                 partial_width_out_first=1, partial_width_out_mid=1, partial_width_out_last=1
                 pad_left=1, pad_top=pad_right=pad_bottom=0. pad value=random. output cube size=2x4x8
                 stride_x=stride_y=2
         ''')

add_test(name='pdp_16x6x16_4x2_split_max_int8_0', #normal split>2
         tags=['L1', 'pdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''split_num=3. max operation
                 partial_width_in_first=2, partial_width_in_mid=12, partial_width_in_last=2
                 partial_width_out_first=1, partial_width_out_mid=6, partial_width_out_last=2
                 pad_left=2 pad_top=1 pad_right=2 pad_bottom=1. pad value=random. output cube size=9x4x16
                 stride_x=stride_y=2
         ''')

add_test(name='pdp_28x28x8_2x2_max_int8_0', #ks>k
         tags=['L1', 'pdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''kernel_stride > kerne_size. non-split
                 pad_left=pad_top=pad_right=pad_bottom=1. pad value=0x0. output cube size=8x8x8.
                 stride_x=stride_y=4
         ''')

#HW bubble tests

add_test(name='pdp_8x9x19_3x3_ave_int8_0', #W process: not bubble, H process: not bubble
         tags=['L1', 'pdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''average operation.
                 pad_left=1 pad_top=2 pad_right=pad_bottom=0. pad value=0x55. output cube size=4x5x19
                 stride_x=2, stride_y=2
         ''')

add_test(name='pdp_8x9x19_3x3_ave_int8_1', #W process: not bubble, H process: bubble one line
         tags=['L1', 'pdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''average operation.
                 pad_left=1 pad_top=2 pad_right=0 pad_bottom=2. pad value=0x11. output cube size=4x6x19
                 stride_x=2, stride_y=2
         ''')

add_test(name='pdp_12x9x19_8x3_ave_int8_0', #W process: bubble one element, H process: not bubble
         tags=['L1', 'pdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''average operation.
                 pad_left=6 pad_top=2 pad_right=4 pad_bottom=0. pad value=0xff. output cube size=8x5x19
                 stride_x=2, stride_y=2
         ''')

add_test(name='pdp_24x16x1_8x8_ave_int8_0', #W process: bubble one element, H process: not bubble
         tags=['L1', 'pdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''average operation.
                 pad_left=5 pad_top=6 pad_right=6 pad_bottom=7. pad value=0xff. output cube size=28x8x1
                 stride_x=1, stride_y=3
         ''')


#CDP
add_test(name='cdp_8x8x32_lrn5_int8_0', #lrn=5 (cdp_lrn5_stest)
         tags=['L1', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''lrn=5. Hit in LO and select the result of LO.
                 lut_hybrid_priority=LO. lut_le_function=LINEAR
                 sqsum_bypass=DISABLE, mul_bypass=DISABLE.
                 lo_index_select=8.
                 In LO table, the value of each entry is same as the entry index. (0-256)
                 lut_lo_start=0, lut_lo_end=255*255*5=0xfe01*5=0x4f605
                 datin_offset=0, datin_scale=1, datin_shifter=0.
                 datout_offset=0, datout_scale=1, datout_shifter=9.
                 (The max value after lut and mul is 256*255. shift right 9bits to the range of signed int8)
         ''')

add_test(name='cdp_8x8x32_lrn7_int8_0', #lrn=7 (cdp_lrn7_stest)
         tags=['L1', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''lrn=7. Hit in LO and select the result of LO.
                 lut_hybrid_priority=LO. lut_le_function=LINEAR
                 sqsum_bypass=DISABLE, mul_bypass=DISABLE.
                 lo_index_select=8.
                 In LO table, the value of each entry is same as the entry index. (0-256)
                 lut_lo_start=0, lut_lo_end=255*255*7=0xfe01*7=0x6f207
                 datin_offset=0, datin_scale=1, datin_shifter=0.
                 datout_offset=0, datout_scale=1, datout_shifter=9.
                 (The max value after lut and mul is 256*255. shift right 9bits to the range of signed int8)
         ''')

add_test(name='cdp_8x8x32_lrn9_int8_0', #lrn=9
         tags=['L1', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''lrn=9. Hit in LO and select the result of LO.
                 lut_hybrid_priority=LO. lut_le_function=LINEAR
                 sqsum_bypass=DISABLE, mul_bypass=DISABLE.
                 lo_index_select=12.
                 In LO table, the value of each entry is same as the entry index. (0-256)
                 lut_lo_start=0, lut_lo_end=255*255*9=0xfe01*9=0x8ee09
                 datin_offset=0, datin_scale=1, datin_shifter=0.
                 datout_offset=0, datout_scale=1, datout_shifter=9.
                 (The max value after lut and mul is 256*255. shift right 9bits to the range of signed int8)
         ''')

add_test(name='cdp_1x1x1_lrn3_int8_0', #1x1x1
         tags=['L1', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''input cube size is 1x1x1. The input value is 0x127
                 lrn=3. Hit in LO and select the result of LO.
                 lut_hybrid_priority=LO. lut_le_function=LINEAR
                 sqsum_bypass=DISABLE, mul_bypass=DISABLE.
                 lo_index_offset=0, lo_index_select=0.
                 In LO table, the value of each entry is same as the entry index. (0-256)
                 lut_lo_start=0, lut_lo_end=255*255*3=0xfe01*3=0x2fa03
                 datin_offset=0, datin_scale=1, datin_shifter=0.
                 datout_offset=0, datout_scale=1, datout_shifter=9.
                 (The max value after lut and mul is 256*255. shift right 9bits to the range of signed int8)
         ''')

add_test(name='cdp_1x1x31_lrn3_int8_0', #1x1xC
         tags=['L1', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''input cube size is 1x1x31.
                 lrn=3. Hit in LO and select the result of LO.
                 lut_hybrid_priority=LO. lut_le_function=LINEAR
                 sqsum_bypass=DISABLE, mul_bypass=DISABLE.
                 lo_index_offset=0, lo_index_select=0.
                 In LO table, the value of each entry is same as the entry index. (0-256)
                 lut_lo_start=0, lut_lo_end=255*255*3=0xfe01*3=0x2fa03
                 datin_offset=0, datin_scale=1, datin_shifter=0.
                 datout_offset=0, datout_scale=1, datout_shifter=9.
                 (The max value after lut and mul is 256*255. shift right 9bits to the range of signed int8)
         ''')

add_test(name='cdp_33x17x34_lrn5_int8_0',
         tags=['L1', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''lrn=5. Hit in LO and select the result of LO.
                 lut_hybrid_priority=LO. lut_le_function=LINEAR
                 sqsum_bypass=DISABLE, mul_bypass=DISABLE.
                 lo_index_select=8.
                 In LO table, the value of each entry is same as the entry index. (0-256)
                 lut_lo_start=0, lut_lo_end=255*255*5=0xfe01*5=0x4f605
                 datin_offset=0, datin_scale=1, datin_shifter=0.
                 datout_offset=0, datout_scale=1, datout_shifter=9.
                 (The max value after lut and mul is 256*255. shift right 9bits to the range of signed int8)
         ''')
add_test(name='cdp_8x8x64_lrn3_int8_0', #Hit in LE's exp table (cdp_small_full_feature_80)
         tags=['L1', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''lrn=3. All hit in LE's exp table. The result of LUT is from LE's exp table. (The result of LO is don't care)
                 lut_hybrid_priority=LE. lut_le_function=EXP
                 sqsum_bypass=DISABLE, mul_bypass=DISABLE.
                 le_index_offset=0, le_index_select=0.
                 In LE table, the value of each entry is same as the entry index. (0-64)
                 lut_le_start=0, lut_le_end=log2(255*255*3)=18
                 datin_offset=0, datin_scale=1, datin_shifter=0.
                 datout_offset=0, datout_scale=1, datout_shifter=9.
                 (The max value after lut and mul is 256*255. shift right 9bits to the range of signed int8)
                 Note: 1. lut_lo_start and lut_lo_end have to be set properly to make sure lut miss in LO.
                       2. If square sum is 0, the lookup in le will be underflow. So change all input data to non-zero.
         ''')

add_test(name='cdp_8x8x64_lrn3_int8_1', #Hit in LE's linear table (cdp_small_full_feature_81)
         tags=['L1', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''lrn=3. Hit in LE's linear table. The result of LUT is from LE's linear table
                 lut_hybrid_priority=LE. lut_le_function=LINEAR
                 sqsum_bypass=DISABLE, mul_bypass=DISABLE.
                 le_index_offset=0, le_index_select=0.
                 In LE table, the value of each entry is same as the entry index. (0-64)
                 lut_le_start=0, lut_le_end=round_to_2^n(0x2fa03)=0x40000, le_index_select=12
                 lut_lo_start=255*255*3=0x2fa03, lut_lo_end=0x2fa03+0x100=0x2fb03. (miss in LO)
                 datin_offset=0, datin_scale=1, datin_shifter=0.
                 datout_offset=0, datout_scale=1, datout_shifter=9.
                 (The max value after lut and mul is 256*255. shift right 9bits to the range of signed int8)
         ''')

add_test(name='cdp_8x8x64_lrn3_int8_2', #Miss in LO and LE tables (cdp_small_full_feature_82)
         tags=['L1', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''lrn=3. Miss in LO and LE tables.
                 lut_hybrid_priority=LO. lut_le_function=LINEAR
                 lut_uflow_priority=LE. lut_oflow_priority=LO
                 sqsum_bypass=DISABLE, mul_bypass=DISABLE.
                 lo_underflow=1 le_underflow=1
                 LO:
                   lo_index_select=0.
                   In LO table, the value of each entry is same as the entry index. (0-256)
                   lut_lo_start=0x2fa04, lut_lo_end=0x2fb04
                 LE:
                   le_index_offset=0, le_index_select=0.
                   In LE table, the value of each entry is same as the entry index. (0-64)
                   lut_le_start=0x2fa04, lut_le_end=0x2fa44.
                 datin_offset=0, datin_scale=1, datin_shifter=0.
                 datout_offset=0, datout_scale=1, datout_shifter=9.
                 lut_le_slope_uflow_scale = 1, lut_le_slope_uflow_shift = 0.
                 lut_le_slope_oflow_scale = 1, lut_le_slope_oflow_shift = 0.
                 lut_lo_slope_uflow_scale = 1, lut_lo_slope_uflow_shift = 0.
                 lut_lo_slope_oflow_scale = 1, lut_lo_slope_oflow_shift = 0.
                 (The max value after lut and mul is 256*255. shift right 9bits to the range of signed int8)
         ''')

#From Doris
add_test(name='cdp_8x8x64_lrn3_int8_3', #a<b<c<d. le range[a,c], lo range[b,d]
                                         #LE work as EXP, select LO
                                         #sqsum bypassed & mul bypassed 

         tags=['L1', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''Bypass square and mul. a<b<c<d
                 le range=[a,c], lo range=[b,d]
                 Select the result of LO.
                 lut_hybrid_priority=LO. lut_le_function=EXP
                 sqsum_bypass=ENABLE, mul_bypass=ENABLE.
                 le_index_offset=-57, lo_index_select=-1.
                 In LO and LE table, the value of each entry is same as the entry index.
                 lut_lo_start=64, lut_lo_end=192
                 lut_le_start=32, lut_lo_end=160
                 datin_offset=-128, datin_scale=1, datin_shifter=0.
                 datout_offset=0, datout_scale=1, datout_shifter=0.
         ''')

add_test(name='cdp_8x8x64_lrn3_int8_4', #a<b<c<d. le range[b,d], lo range[a,c]
                                         #LE work as EXP, select LE
                                         #sqsum bypassed & mul bypassed 

         tags=['L1', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''Bypass square and mul
                 a<b<c<d
                 le range=[b,d], lo range=[a,c]
                 Select the result of LE.
                 lut_hybrid_priority=LE. lut_le_function=EXP
                 sqsum_bypass=ENABLE, mul_bypass=ENABLE.
                 le_index_offset=-57, lo_index_select=-1.
                 In LO and LE table, the value of each entry is same as the entry index.
                 lut_lo_start=8, lut_lo_end=136
                 datin_offset=-128, datin_scale=1, datin_shifter=0.
                 datout_offset=0, datout_scale=1, datout_shifter=0.
         ''')

add_test(name='cdp_8x8x64_lrn3_int8_5', #a<b<c<d. le range[b,d], lo range[a,c]
                                         #LE work as EXP, select LO
                                         #sqsum bypassed & mul bypassed 

         tags=['L1', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''Bypass square and mul
                 a<b<c<d
                 le range=[b,d], lo range=[a,c]
                 Select the result of LE.
                 lut_hybrid_priority=LO. lut_le_function=EXP
                 sqsum_bypass=ENABLE, mul_bypass=ENABLE.
                 le_index_offset=-57, lo_index_select=-1.
                 In LO and LE table, the value of each entry is same as the entry index.
                 lut_lo_start=8, lut_lo_end=136
                 datin_offset=-128, datin_scale=1, datin_shifter=0.
                 datout_offset=0, datout_scale=1, datout_shifter=0.
         ''')

add_test(name='cdp_8x8x64_lrn3_int8_6', #a<b<c<d. le range[a,c], lo range[b,d]
                                         #LE work as LINEAR, select LE
                                         #sqsum bypassed & mul bypassed 

         tags=['L1', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''Bypass square and mul. a<b<c<d
                 le range=[a,c], lo range=[b,d]
                 Select the result of LE.
                 lut_hybrid_priority=LE. lut_le_function=LINEAR
                 sqsum_bypass=ENABLE, mul_bypass=ENABLE.
                 le_index_offset=-57, lo_index_select=-1.
                 In LO and LE table, the value of each entry is same as the entry index.
                 lut_lo_start=64, lut_lo_end=192
                 lut_le_start=10, lut_lo_end=138
                 datin_offset=-128, datin_scale=1, datin_shifter=0.
                 datout_offset=0, datout_scale=1, datout_shifter=0.
         ''')

add_test(name='cdp_8x8x64_lrn3_int8_7', #enable sqsum and mul, normal lrn3 case. LE is EXP
         tags=['L1', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''lrn=3.
                 lut_hybrid_priority=LO. lut_le_function=EXP
                 sqsum_bypass=DISABLE, mul_bypass=DISABLE.
                 le_index_offset=-55, lo_index_select=1.
                 In LO and LE table, the value of each entry is same as the entry index.
                 lut_le_start=64, lut_le_end=576
                 lut_lo_start=168, lut_lo_end=680
                 datin_offset=0, datin_scale=1, datin_shifter=0.
                 datout_offset=0, datout_scale=1, datout_shifter=0.
                 input value is in range [0,16]
         ''')

add_test(name='cdp_8x8x64_lrn3_int8_8', #enable sqsum and mul, normal lrn3 case. LE is LINEAR
         tags=['L1', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''lrn=3.
                 lut_hybrid_priority=LO. lut_le_function=LINEAR
                 sqsum_bypass=DISABLE, mul_bypass=DISABLE.
                 le_index_offset=-55, lo_index_select=1.
                 In LO and LE table, the value of each entry is same as the entry index.
                 lut_le_start=100, lut_le_end=612
                 lut_lo_start=168, lut_lo_end=680
                 datin_offset=0, datin_scale=1, datin_shifter=0.
                 datout_offset=0, datout_scale=1, datout_shifter=0.
                 input value is in range [0,16]
         ''')

add_test(name='cdp_8x8x64_lrn3_int8_9', #uflow/oflow process test. based on normal lrn3
         tags=['L1', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''lrn=3.
                 lut_hybrid_priority=LO. lut_le_function=EXP
                 sqsum_bypass=DISABLE, mul_bypass=DISABLE.
                 le_index_offset=-55, lo_index_select=1.
                 In LO and LE table, the value of each entry is same as the entry index.
                 lut_le_start=64, lut_le_end=576
                 lut_lo_start=168, lut_lo_end=680
                 datin_offset=0, datin_scale=1, datin_shifter=0.
                 datout_offset=0, datout_scale=1, datout_shifter=9.
                 input value is in range [0,16]
         ''')

add_test(name='cdp_8x8x64_lrn3_int8_10', #cube size test based on normal lrn3
         tags=['L1', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''lrn=3. 
                 lut_hybrid_priority=LO. lut_le_function=EXP
                 sqsum_bypass=DISABLE, mul_bypass=DISABLE.
                 le_index_offset=-55, le_index_select=1.
                 In LO and LE table, the value of each entry is random
                 lut_le_start=64, lut_le_end=576
                 lut_lo_start=168, lut_lo_end=680
                 datin_offset=0, datin_scale=1, datin_shifter=0.
                 datout_offset=0, datout_scale=1, datout_shifter=9.
                 input value is in range [0,16]
         ''')

add_test(name='cdp_8x8x64_lrn3_int8_11', #ocvt test based on normal lrn3
         tags=['L1', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''lrn=3. 
                 lut_hybrid_priority=LO. lut_le_function=EXP
                 sqsum_bypass=DISABLE, mul_bypass=DISABLE.
                 le_index_offset=-55, le_index_select=1.
                 In LO and LE table, the value of each entry is random
                 lut_le_start=64, lut_le_end=576
                 lut_lo_start=168, lut_lo_end=680
                 datin_offset=0, datin_scale=1, datin_shifter=0.
                 datout_offset=-33, datout_scale=9, datout_shifter=-2.
                 input value is in range [0,16]
         ''')

add_test(name='cdp_8x8x64_lrn3_int8_12', #icvt test based on normal lrn3
         tags=['L1', 'cdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''lrn=3. 
                 lut_hybrid_priority=LO. lut_le_function=EXP
                 sqsum_bypass=DISABLE, mul_bypass=DISABLE.
                 le_index_offset=-55, le_index_select=1.
                 In LO and LE table, the value of each entry is random
                 lut_le_start=64, lut_le_end=576
                 lut_lo_start=168, lut_lo_end=680
                 datin_offset=-100, datin_scale=-2, datin_shifter=3.
                 datout_offset=-33, datout_scale=9, datout_shifter=-2.
                 input value is in range [0,16]
         ''')

#CC
add_test(name='dc_13x15x64_5x3x64x16_int8_0',
         tags=['L1', 'cc', 'dc'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''copied from cc_small_full_feature_1, kernel stride 1x1, unpacked, pad L/R/B, no clip truncate, partial weight''')

add_test(name='dc_14x7x49_3x4x49x32_int8_0',
         tags=['L1', 'cc', 'dc'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''copied from cc_small_full_feature_2, kernel stride 1x1, unpacked, pad L/R/B, clip truncate 1, partial weight''')

add_test(name='dc_32x26x76_6x3x76x16_int8_0',
         tags=['L1','cc', 'dc'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''copied from cc_small_full_feature_3, kernel stride 1x1, packed, pad L/T/B, clip truncate 6, partial weight''')

add_test(name='dc_6x8x192_3x3x192x32_int8_0',
         tags=['L1','cc', 'dc'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''copied from cc_small_full_feature_6, kernel stride 1x1, unpacked, pad L/R/T, clip truncate 12, full weight''')

add_test(name='dc_24x44x14_5x3x14x41_int8_0',
         tags=['L1','cc', 'dc'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''copied from cc_small_full_feature_7, kernel stride 1x1, unpacked, pad L/R/T/B, clip truncate 10, full weight''')

add_test(name='dc_35x22x54_6x8x54x29_int8_0',
         tags=['L1','cc', 'dc'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''copied from cc_small_full_feature_8, kernel stride 1x1, unpacked, pad L/R/T/B, no clip truncate, partial weight''')

#add_test(name='img_WxHxC_RxSxCxK_R8_int8',  #pixel format 0xb
#         tags=['L1','cc'],
#         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
#         config=['nvdla_utb'],
#         desc='''test for image format R8''')

#add_test(name='img_51x96x4_1x10x4x32_A8B8G8R8_int8_0', #pixel format 0xc
#         tags=['L1','cc', 'img'],
#         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
#         config=['nvdla_utb'],
#         desc='''converted from cc_small_full_feature_17, kernel stride 2x2, unpacked, no padding, clip truncate 3, full weight, input cvt enable, cvt_scale 2, cvt_offset 0, cvt_truncate 0''')

add_test(name='img_51x96x4_1x10x4x32_A8R8G8B8_int8_0', #pixel format 0xd
         tags=['L1','cc', 'img'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''converted from cc_small_full_feature_17, kernel stride 2x2, unpacked, no padding, clip truncate 3, full weight, input cvt enable, cvt_scale 3, cvt_offset 5, cvt_truncate 1''')

add_test(name='img_51x96x4_1x10x4x32_B8G8R8A8_int8_0', #pixel format 0xe
         tags=['L1','cc', 'img'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''converted from cc_small_full_feature_17, kernel stride 2x2, unpacked, no padding, clip truncate 3, full weight, input cvt enable, cvt_scale 4, cvt_offset 10, cvt_truncate 2''')

add_test(name='img_51x96x4_1x10x4x32_R8G8B8A8_int8_0', #pixel format 0xf
         tags=['L1','cc', 'img'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''copied from cc_small_full_feature_17, kernel stride 2x2, unpacked, no padding, clip truncate 3, full weight, input cvt enable, cvt_scale 1, cvt_offset 0, cvt_truncate 0''')

add_test(name='img_51x96x4_1x10x4x32_X8B8G8R8_int8_0', #pixel format 0x10
         tags=['L1','cc', 'img'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''converted from cc_small_full_feature_17, kernel stride 2x2, unpacked, no padding, clip truncate 3, full weight, input cvt enable, cvt_scale 5, cvt_offset 2, cvt_truncate 2''')

add_test(name='img_51x96x4_1x10x4x32_X8R8G8B8_int8_0', #pixel format 0x11
         tags=['L1','cc', 'img'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''converted from cc_small_full_feature_17, kernel stride 2x2, unpacked, no padding, clip truncate 3, full weight, input cvt enable, cvt_scale 6, cvt_offset 4, cvt_truncate 2''')

add_test(name='img_51x96x4_1x10x4x32_B8G8R8X8_int8_0', #pixel format 0x12
         tags=['L1','cc', 'img'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''converted from cc_small_full_feature_17, kernel stride 2x2, unpacked, no padding, clip truncate 3, full weight, input cvt enable, cvt_scale 7, cvt_offset 8, cvt_truncate 2''')

add_test(name='img_51x96x4_1x10x4x32_R8G8B8X8_int8_0', #pixel format 0x13
         tags=['L1','cc', 'img'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''converted from cc_small_full_feature_17, kernel stride 2x2, unpacked, no padding, clip truncate 3, full weight, input cvt enable, cvt_scale 8, cvt_offset 16, cvt_truncate 3''')

add_test(name='img_51x96x4_1x10x4x32_A8Y8U8V8_int8_0', #pixel format 0x1a
         tags=['L1','cc', 'img'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''converted from cc_small_full_feature_17, kernel stride 2x2, unpacked, no padding, clip truncate 3, full weight, input cvt enable, cvt_scale 1, cvt_offset 32, cvt_truncate 0''')

add_test(name='img_51x96x4_1x10x4x32_V8U8Y8A8_int8_0', #pixel format 0x1b
         tags=['L1','cc', 'img'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''converted from cc_small_full_feature_17, kernel stride 2x2, unpacked, no padding, clip truncate 3, full weight, input cvt enable, cvt_scale 1, cvt_offset 0, cvt_truncate 1''')

#add_test(name='img_43x90x3_1x3x3x41_Y8U8V8_int8',  #pixel format 0x1c
#         tags=['L1','cc'],
#         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
#         config=['nvdla_utb'],
#         desc='''copied from cc_small_full_feature_22, kernel stride 7x3, unpacked, pad L/R/T/B, clip truncate 7, post_y_ext 2''')

#add_test(name='img_43x90x3_1x3x3x41_Y8V8U8_int8',  #pixel format 0x1d
#         tags=['L1','cc'],
#         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
#         config=['nvdla_utb'],
#         desc='''copied from cc_small_full_feature_22, kernel stride 7x3, unpacked, pad L/R/T/B, clip truncate 7, post_y_ext 4''')

add_test(name='dc_1x1x8_1x1x8x1_int8_0',
         tags=['L1','cc', 'dc'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''test 1x1 case, kernel stride 1x1, packed, no padding, clip truncate 6''')

#add_test(name='dc_sdp_pdp_WxHxC_RxSxCxK_int8_0',
#         tags=['L1','cc', 'dc'],
#         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
#         config=['nvdla_utb'],
#         desc='''test fused layers''')

#SDP tests
add_test(name='sdp_3x3x33_bs_int8_reg_0',
         tags=['L1', 'sdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''copied from sdp_bs_reg_stest, alu_algo SUM. mul_prelu 0''')

add_test(name='sdp_3x3x33_bs_int8_reg_1',
         tags=['L1', 'sdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''copied from sdp_bs_reg_stest, alu_algo MIN. mul_prelu 0''')

add_test(name='sdp_23x13x42_bs_int8_mem_0',
         tags=['L1', 'sdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''converted from sdp_cmod_full_feature_3, src mem, one_byte, per_element, bypass alu, mul_prelu 1, bypass relu''')

add_test(name='sdp_5x24x18_bs_int8_mem_0',
         tags=['L1', 'sdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''converted from sdp_cmod_full_feature_4, src mem, one_byte, per_element, alu_algo MAX, bypass mul, bypass relu''')

add_test(name='sdp_3x3x33_bn_int8_reg_0',
         tags=['L1', 'sdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''copied from sdp_bn_reg_stest_0, alu_algo SUM. mul_prelu 0''')

add_test(name='sdp_3x3x33_bn_int8_reg_1',
         tags=['L1', 'sdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''copied from sdp_bn_reg_stest_1, alu_algo MAX. bypass mul, bypass relu''')

add_test(name='sdp_3x3x33_bn_int8_reg_2',
         tags=['L1', 'sdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''copied from sdp_bn_reg_stest_2, alu_algo MIN. mul_prelu 1''')

add_test(name='sdp_3x3x33_bn_int8_reg_3',
         tags=['L1', 'sdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''copied from sdp_bn_reg_stest_3, alu_algo SUM. mul_prelu 0, bypass alu''')

add_test(name='sdp_3x3x33_bn_int8_mem_0',
         tags=['L1', 'sdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''converted from sdp_bn_mem_stest, alu_algo SUM. bypass mul, per_element''')

#add_test(name='sdp_3x3x33_ew_int8_reg_0',
#         tags=['L1', 'sdp'],
#         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
#         config=['nvdla_utb'],
#         desc='''copied from sdp_ew_reg_stest, alu_algo SUM. mul_prelu 0, bypass alu_cvt, bypass mul_cvt, bypass lut''')
#
#add_test(name='sdp_3x3x33_ew_le_lin_int8',
#         tags=['L1', 'sdp'],
#         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
#         config=['nvdla_utb'],
#         desc='''copied from sdp_le_lin_stest, bypass alu, bypass mul''')
#
#add_test(name='sdp_3x3x33_ew_le_exp_int8',
#         tags=['L1', 'sdp'],
#         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
#         config=['nvdla_utb'],
#         desc='''copied from sdp_le_exp_stest, bypass alu, bypass mul''')
#
#add_test(name='sdp_3x3x32_ew_lo_lin_int8',
#         tags=['L1', 'sdp'],
#         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
#         config=['nvdla_utb'],
#         desc='''copied from sdp_lo_lin_stest, bypass alu, bypass mul''')

add_test(name='sdp_1x1x8_pass_through_int8_0',
         tags=['L1', 'sdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''test 1x1x8 case, bypass bs, bypass bn, bypass ew''')

add_test(name='sdp_3x3x33_bs_bn_int8_0',
         tags=['L1', 'sdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''copied from sdp_3x3x33_bs_int8_reg_0, enabled both bs and bn''')

add_test(name='sdp_3x3x33_bs_bn_int8_1',
         tags=['L1', 'sdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''copied from sdp_3x3x33_bs_int8_reg_1, enabled both bs and bn''')

add_test(name='sdp_pdp_32x16x32_pass_through_int8_0',
         tags=['L1', 'sdp', 'pdp'],
         args=[FIXED_SEED_ARG, DISABLE_COMPARE_ALL_UNITS_SB_ARG],
         config=['nvdla_utb'],
         desc='''test sdp+pdp flying case, bypass bs, bypass bn, bypass ew, 1x1 pdp kernel with max pooling method''')

