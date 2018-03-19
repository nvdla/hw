add_test(name='cc_8x8x32_32x1x1x32_pack_all_zero_int8',
         tags=['pyt','cc','sanity'],
         args=[],
         module='nvdla_python_test',
         config=['nvdla_utb'],
         desc='''''')

add_test(name='sdp_passthrough_8x8x32_pack_inc_int8',
         tags=['pyt','sdp','sanity'],
         args=[],
         module='nvdla_python_test',
         config=['nvdla_utb'],
         desc='''''')

add_test(name='pdp_passthrough_8x8x32_pack_inc_int8',
         tags=['pyt','pdp','sanity'],
         args=[],
         module='nvdla_python_test',
         config=['nvdla_utb'],
         desc='''''')

add_test(name='cdp_passthrough_8x8x32_pack_inc_int8',
         tags=['pyt','cdp','sanity'],
         args=[],
         module='nvdla_python_test',
         config=['nvdla_utb'],
         desc='''''')

add_test(name='sdp_passthrough_8x8x32_pack_inc_int8',
         tags=['sdp','as2'],
         args=['-uwm cmod_only'],
         config=['nvdla_utb'],
         desc='''''')

add_test(name='pdp_passthrough_8x8x32_pack_inc_int8',
         tags=['pdp','as2'],
         args=['-uwm cmod_only'],
         config=['nvdla_utb'],
         desc='''''')

add_test(name='cdp_passthrough_8x8x32_pack_inc_int8',
         tags=['cdp','as2'],
         args=['-uwm cmod_only'],
         config=['nvdla_utb'],
         desc='''''')
