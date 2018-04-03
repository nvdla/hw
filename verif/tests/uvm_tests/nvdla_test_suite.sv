`include "nvdla_user_define_demo_test.sv"
/*
    CC test list
*/
`include "cc_feature_rtest.sv"
`include "cc_pitch_rtest.sv"
`include "cc_feature_data_full_reuse_rtest.sv"
`include "cc_feature_weight_full_reuse_rtest.sv"
`include "cc_image_data_full_reuse_rtest.sv"
`include "cc_rtest.sv"

/*
    SDP test lsit
*/
`include "sdp_bs_rtest.sv"
`include "sdp_bn_rtest.sv"
`include "sdp_rtest.sv"

/*
    CDP test lsit
*/
`include "cdp_exp_rtest.sv"
`include "cdp_lin_rtest.sv"
`include "cdp_rtest.sv"

/*
    PDP test lsit
*/
`include "pdp_split_rtest.sv"
`include "pdp_non_split_rtest.sv"
`include "pdp_rtest.sv"

/*
    Multi-resource data path test list
*/
`include "cc_sdprdma_sdp_rtest.sv"
`include "cc_sdprdma_sdp_pdp_rtest.sv"
`include "cc_sdp_pdp_rtest.sv"
`include "sdprdma_sdp_pdp_rtest.sv"

/*
    Multi-scenario test list
*/
`include "multi_scenario_rtest.sv"

/*
    Coverage test list
*/
`include "cc_max_datain_width_ctest.sv"
`include "cc_max_datain_height_ctest.sv"
`include "cc_max_datain_channel_ctest.sv"

`include "cc_max_dataout_width_ctest.sv"
`include "cc_max_dataout_height_ctest.sv"
`include "cc_max_dataout_channel_ctest.sv"

`include "sdp_max_cube_width_ctest.sv"
`include "sdp_max_cube_height_ctest.sv"
`include "sdp_max_cube_channel_ctest.sv"

`include "pdp_max_cube_in_width_ctest.sv"
`include "pdp_max_cube_in_height_ctest.sv"
`include "pdp_max_cube_in_channel_ctest.sv"

`include "pdp_max_cube_out_width_ctest.sv"
`include "pdp_max_cube_out_height_ctest.sv"
`include "pdp_max_cube_out_channel_ctest.sv"

`include "cdp_max_cube_width_ctest.sv"
`include "cdp_max_cube_height_ctest.sv"
`include "cdp_max_cube_channel_ctest.sv"
