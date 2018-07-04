// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

`define  tieoff_axid_bdma     4'd0
`define  tieoff_axid_sdp      4'd1
`define  tieoff_axid_pdp      4'd2
`define  tieoff_axid_cdp      4'd3
`define  tieoff_axid_rbk      4'd4
`define  tieoff_axid_sdp_b    4'd5
`define  tieoff_axid_sdp_n    4'd6
`define  tieoff_axid_sdp_e    4'd7
`define  tieoff_axid_cdma_dat 4'd8
`define  tieoff_axid_cdma_wt  4'd9

`define  tieoff_depth_bdma     9'd245
`define  tieoff_depth_rbk      9'd80
`define  tieoff_depth_cdma_dat 9'd0 
`define  tieoff_depth_cdma_wt  9'd0 
//:printf "`define  tieoff_depth_sdp    9'd%d\n",  NVDLA_VMOD_SDP_MRDMA_LATENCY_FIFO_DEPTH; 
//:printf "`define  tieoff_depth_pdp    9'd%d\n",  NVDLA_VMOD_PDP_RDMA_LATENCY_FIFO_DEPTH;
//:printf "`define  tieoff_depth_cdp    9'd%d\n",  NVDLA_VMOD_CDP_RDMA_LATENCY_FIFO_DEPTH;
//:printf "`define  tieoff_depth_sdp_b  9'd%d\n",  NVDLA_VMOD_SDP_BRDMA_LATENCY_FIFO_DEPTH;
//:printf "`define  tieoff_depth_sdp_n  9'd%d\n",  NVDLA_VMOD_SDP_NRDMA_LATENCY_FIFO_DEPTH;
//:printf "`define  tieoff_depth_sdp_e  9'd%d\n",  NVDLA_VMOD_SDP_ERDMA_LATENCY_FIFO_DEPTH;
