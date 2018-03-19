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

