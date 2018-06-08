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
`ifdef NVDLA_SDP_BN_ENABLE
    `include "sdp_bn_rtest.sv"
`endif
`ifdef NVDLA_SDP_BS_ENABLE
    `include "sdp_bs_rtest.sv"
`endif
`ifdef NVDLA_SDP_EW_ENABLE
    `include "sdp_ew_rtest.sv"
`endif
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
`include "cc_in_width_ctest.sv"
`include "cc_in_height_ctest.sv"
`include "cc_in_channel_ctest.sv"

`include "cc_out_width_ctest.sv"
`include "cc_out_height_ctest.sv"
`include "cc_out_channel_ctest.sv"

`include "sdp_width_ctest.sv"
`include "sdp_height_ctest.sv"
`include "sdp_channel_ctest.sv"

`include "pdp_in_width_ctest.sv"
`include "pdp_in_height_ctest.sv"
`include "pdp_in_channel_ctest.sv"

`include "pdp_out_width_ctest.sv"
`include "pdp_out_height_ctest.sv"
`include "pdp_out_channel_ctest.sv"

`include "pdp_split_ctest.sv"

`include "cdp_width_ctest.sv"
`include "cdp_height_ctest.sv"
`include "cdp_channel_ctest.sv"

`include "pdp_partial_width_in_first_ctest.sv"
`include "pdp_partial_width_in_mid_ctest.sv"
`include "pdp_partial_width_in_last_ctest.sv"

`include "cc_pitch_line_stride_0_ctest.sv"
`include "cc_pitch_line_stride_1_ctest.sv"
`include "cc_pitch_line_stride_2_ctest.sv"
`include "cc_pitch_line_stride_3_ctest.sv"

`include "cdp_lut_max_slope_flow_scale_ctest.sv"
