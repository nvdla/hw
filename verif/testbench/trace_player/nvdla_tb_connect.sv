`ifndef _NVDLA_TB_CONNECT_SV_
`define _NVDLA_TB_CONNECT_SV_

//-------------------------------------------------------------------------------------
//
// FILE: nvdla_tb_connect.sv
//
//-------------------------------------------------------------------------------------

//:| global project
//:| import project

//-----------------------------------------------------------------------
// CSB Interface
//-----------------------------------------------------------------------
// input
assign csb2nvdla_valid    = csb_if.pvld;
assign csb2nvdla_addr     = csb_if.addr;
assign csb2nvdla_write    = csb_if.write;
assign csb2nvdla_wdat     = csb_if.wdata;
assign csb2nvdla_nposted  = csb_if.nposted;
// output
assign csb_if.prdy        = csb2nvdla_ready;
assign csb_if.wr_complete = nvdla2csb_wr_complete;
assign csb_if.rvld        = nvdla2csb_valid;
assign csb_if.rdata       = nvdla2csb_data;

//-----------------------------------------------------------------------
// DBB Interface 
//-----------------------------------------------------------------------
// input
assign nvdla_core2dbb_ar_arready = pri_mem_if.arready;
assign nvdla_core2dbb_aw_awready = pri_mem_if.awready;
assign nvdla_core2dbb_r_rvalid   = pri_mem_if.rvalid;
assign nvdla_core2dbb_r_rlast    = pri_mem_if.rlast;
assign nvdla_core2dbb_r_rdata    = pri_mem_if.rdata;
assign nvdla_core2dbb_r_rid      = pri_mem_if.rid;
assign nvdla_core2dbb_w_wready   = pri_mem_if.wready;
assign nvdla_core2dbb_b_bvalid   = pri_mem_if.bvalid;
assign nvdla_core2dbb_b_bid      = pri_mem_if.bid;

// output
assign pri_mem_if.awvalid               = nvdla_core2dbb_aw_awvalid;
assign pri_mem_if.awaddr                = nvdla_core2dbb_aw_awaddr;
assign pri_mem_if.awlen                 = nvdla_core2dbb_aw_awlen;
assign pri_mem_if.awid                  = nvdla_core2dbb_aw_awid;
assign pri_mem_if.arvalid               = nvdla_core2dbb_ar_arvalid;
assign pri_mem_if.araddr                = nvdla_core2dbb_ar_araddr;
assign pri_mem_if.arlen                 = nvdla_core2dbb_ar_arlen;
assign pri_mem_if.arid                  = nvdla_core2dbb_ar_arid;
assign pri_mem_if.rready                = nvdla_core2dbb_r_rready;
assign pri_mem_if.wvalid                = nvdla_core2dbb_w_wvalid;
assign pri_mem_if.wlast                 = nvdla_core2dbb_w_wlast;
assign pri_mem_if.wdata                 = nvdla_core2dbb_w_wdata;
assign pri_mem_if.wstrb                 = nvdla_core2dbb_w_wstrb;
assign pri_mem_if.bready                = nvdla_core2dbb_b_bready;

assign pri_mem_if.awsize                = $clog2(`DBB_DATA_WIDTH/8);
assign pri_mem_if.arsize                = $clog2(`DBB_DATA_WIDTH/8);
assign pri_mem_if.bresp                 = 0;
    
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
// input
assign nvdla_core2cvsram_ar_arready = sec_mem_if.arready;
assign nvdla_core2cvsram_aw_awready = sec_mem_if.awready;
assign nvdla_core2cvsram_r_rvalid   = sec_mem_if.rvalid;
assign nvdla_core2cvsram_r_rlast    = sec_mem_if.rlast;
assign nvdla_core2cvsram_r_rdata    = sec_mem_if.rdata;
assign nvdla_core2cvsram_r_rid      = sec_mem_if.rid;
assign nvdla_core2cvsram_w_wready   = sec_mem_if.wready;
assign nvdla_core2cvsram_b_bvalid   = sec_mem_if.bvalid;
assign nvdla_core2cvsram_b_bid      = sec_mem_if.bid;

// output
assign sec_mem_if.awvalid               = nvdla_core2cvsram_aw_awvalid;
assign sec_mem_if.awaddr                = nvdla_core2cvsram_aw_awaddr;
assign sec_mem_if.awlen                 = nvdla_core2cvsram_aw_awlen;
assign sec_mem_if.awid                  = nvdla_core2cvsram_aw_awid;
assign sec_mem_if.arvalid               = nvdla_core2cvsram_ar_arvalid;
assign sec_mem_if.araddr                = nvdla_core2cvsram_ar_araddr;
assign sec_mem_if.arlen                 = nvdla_core2cvsram_ar_arlen;
assign sec_mem_if.arid                  = nvdla_core2cvsram_ar_arid;
assign sec_mem_if.rready                = nvdla_core2cvsram_r_rready;
assign sec_mem_if.wvalid                = nvdla_core2cvsram_w_wvalid;
assign sec_mem_if.wlast                 = nvdla_core2cvsram_w_wlast;
assign sec_mem_if.wdata                 = nvdla_core2cvsram_w_wdata;
assign sec_mem_if.wstrb                 = nvdla_core2cvsram_w_wstrb;
assign sec_mem_if.bready                = nvdla_core2cvsram_b_bready;

assign sec_mem_if.awsize                = $clog2(`DBB_DATA_WIDTH/8);
assign sec_mem_if.arsize                = $clog2(`DBB_DATA_WIDTH/8);
assign sec_mem_if.bresp                 = 0;
`endif

//-----------------------------------------------------------------------
// Internal Monitor Interface
//-----------------------------------------------------------------------
assign cdma_wt_pri_mem_if.rd_req_valid   = `CDMA_WT.cdma_wt2mcif_rd_req_valid;
assign cdma_wt_pri_mem_if.rd_req_ready   = `CDMA_WT.cdma_wt2mcif_rd_req_ready;
assign cdma_wt_pri_mem_if.rd_req_pd      = `CDMA_WT.cdma_wt2mcif_rd_req_pd;
assign cdma_wt_pri_mem_if.wt_dma_id      = `CDMA_WT.u_wt.dbg_dma_req_src;
assign cdma_wt_pri_mem_if.rd_rsp_valid   = `CDMA_WT.mcif2cdma_wt_rd_rsp_valid;
assign cdma_wt_pri_mem_if.rd_rsp_ready   = `CDMA_WT.mcif2cdma_wt_rd_rsp_ready;
assign cdma_wt_pri_mem_if.rd_rsp_pd      = `CDMA_WT.mcif2cdma_wt_rd_rsp_pd;

assign cdma_dat_pri_mem_if.rd_req_valid  = `CDMA_DAT.cdma_dat2mcif_rd_req_valid;
assign cdma_dat_pri_mem_if.rd_req_ready  = `CDMA_DAT.cdma_dat2mcif_rd_req_ready;
assign cdma_dat_pri_mem_if.rd_req_pd     = `CDMA_DAT.cdma_dat2mcif_rd_req_pd;
assign cdma_dat_pri_mem_if.rd_rsp_valid  = `CDMA_DAT.mcif2cdma_dat_rd_rsp_valid;
assign cdma_dat_pri_mem_if.rd_rsp_ready  = `CDMA_DAT.mcif2cdma_dat_rd_rsp_ready;
assign cdma_dat_pri_mem_if.rd_rsp_pd     = `CDMA_DAT.mcif2cdma_dat_rd_rsp_pd;

`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
assign cdma_wt_sec_mem_if.rd_req_valid   = `CDMA_WT.cdma_wt2cvif_rd_req_valid;
assign cdma_wt_sec_mem_if.rd_req_ready   = `CDMA_WT.cdma_wt2cvif_rd_req_ready;
assign cdma_wt_sec_mem_if.rd_req_pd      = `CDMA_WT.cdma_wt2cvif_rd_req_pd;
assign cdma_wt_sec_mem_if.wt_dma_id      = `CDMA_WT.u_wt.dbg_dma_req_src;
assign cdma_wt_sec_mem_if.rd_rsp_valid   = `CDMA_WT.cvif2cdma_wt_rd_rsp_valid;
assign cdma_wt_sec_mem_if.rd_rsp_ready   = `CDMA_WT.cvif2cdma_wt_rd_rsp_ready;
assign cdma_wt_sec_mem_if.rd_rsp_pd      = `CDMA_WT.cvif2cdma_wt_rd_rsp_pd;

assign cdma_dat_sec_mem_if.rd_req_valid  = `CDMA_DAT.cdma_dat2cvif_rd_req_valid;
assign cdma_dat_sec_mem_if.rd_req_ready  = `CDMA_DAT.cdma_dat2cvif_rd_req_ready;
assign cdma_dat_sec_mem_if.rd_req_pd     = `CDMA_DAT.cdma_dat2cvif_rd_req_pd;
assign cdma_dat_sec_mem_if.rd_rsp_valid  = `CDMA_DAT.cvif2cdma_dat_rd_rsp_valid;
assign cdma_dat_sec_mem_if.rd_rsp_ready  = `CDMA_DAT.cvif2cdma_dat_rd_rsp_ready;
assign cdma_dat_sec_mem_if.rd_rsp_pd     = `CDMA_DAT.cvif2cdma_dat_rd_rsp_pd;
`endif

assign sdp_pri_mem_if.rd_req_valid       = `SDP.sdp2mcif_rd_req_valid;
assign sdp_pri_mem_if.rd_req_ready       = `SDP.sdp2mcif_rd_req_ready;
assign sdp_pri_mem_if.rd_req_pd          = `SDP.sdp2mcif_rd_req_pd;
assign sdp_pri_mem_if.rd_rsp_valid       = `SDP.mcif2sdp_rd_rsp_valid;
assign sdp_pri_mem_if.rd_rsp_ready       = `SDP.mcif2sdp_rd_rsp_ready;
assign sdp_pri_mem_if.rd_rsp_pd          = `SDP.mcif2sdp_rd_rsp_pd;
assign sdp_pri_mem_if.wr_req_valid       = `SDP.sdp2mcif_wr_req_valid;
assign sdp_pri_mem_if.wr_req_ready       = `SDP.sdp2mcif_wr_req_ready;
assign sdp_pri_mem_if.wr_req_pd          = `SDP.sdp2mcif_wr_req_pd;
assign sdp_pri_mem_if.wr_rsp_complete    = `SDP.mcif2sdp_wr_rsp_complete;

`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
assign sdp_sec_mem_if.rd_req_valid       = `SDP.sdp2cvif_rd_req_valid;
assign sdp_sec_mem_if.rd_req_ready       = `SDP.sdp2cvif_rd_req_ready;
assign sdp_sec_mem_if.rd_req_pd          = `SDP.sdp2cvif_rd_req_pd;
assign sdp_sec_mem_if.rd_rsp_valid       = `SDP.cvif2sdp_rd_rsp_valid;
assign sdp_sec_mem_if.rd_rsp_ready       = `SDP.cvif2sdp_rd_rsp_ready;
assign sdp_sec_mem_if.rd_rsp_pd          = `SDP.cvif2sdp_rd_rsp_pd;
assign sdp_sec_mem_if.wr_req_valid       = `SDP.sdp2cvif_wr_req_valid;
assign sdp_sec_mem_if.wr_req_ready       = `SDP.sdp2cvif_wr_req_ready;
assign sdp_sec_mem_if.wr_req_pd          = `SDP.sdp2cvif_wr_req_pd;
assign sdp_sec_mem_if.wr_rsp_complete    = `SDP.cvif2sdp_wr_rsp_complete;
`endif

`ifdef NVDLA_SDP_BS_ENABLE
assign sdp_b_pri_mem_if.rd_req_valid     = `SDP.sdp_b2mcif_rd_req_valid;
assign sdp_b_pri_mem_if.rd_req_ready     = `SDP.sdp_b2mcif_rd_req_ready;
assign sdp_b_pri_mem_if.rd_req_pd        = `SDP.sdp_b2mcif_rd_req_pd;
assign sdp_b_pri_mem_if.rd_rsp_valid     = `SDP.mcif2sdp_b_rd_rsp_valid;
assign sdp_b_pri_mem_if.rd_rsp_ready     = `SDP.mcif2sdp_b_rd_rsp_ready;
assign sdp_b_pri_mem_if.rd_rsp_pd        = `SDP.mcif2sdp_b_rd_rsp_pd;
`endif

`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
`ifdef NVDLA_SDP_BS_ENABLE
assign sdp_b_sec_mem_if.rd_req_valid     = `SDP.sdp_b2cvif_rd_req_valid;
assign sdp_b_sec_mem_if.rd_req_ready     = `SDP.sdp_b2cvif_rd_req_ready;
assign sdp_b_sec_mem_if.rd_req_pd        = `SDP.sdp_b2cvif_rd_req_pd;
assign sdp_b_sec_mem_if.rd_rsp_valid     = `SDP.cvif2sdp_b_rd_rsp_valid;
assign sdp_b_sec_mem_if.rd_rsp_ready     = `SDP.cvif2sdp_b_rd_rsp_ready;
assign sdp_b_sec_mem_if.rd_rsp_pd        = `SDP.cvif2sdp_b_rd_rsp_pd;
`endif
`endif

`ifdef NVDLA_SDP_EW_ENABLE
assign sdp_e_pri_mem_if.rd_req_valid     = `SDP.sdp_e2mcif_rd_req_valid;
assign sdp_e_pri_mem_if.rd_req_ready     = `SDP.sdp_e2mcif_rd_req_ready;
assign sdp_e_pri_mem_if.rd_req_pd        = `SDP.sdp_e2mcif_rd_req_pd;
assign sdp_e_pri_mem_if.rd_rsp_valid     = `SDP.mcif2sdp_e_rd_rsp_valid;
assign sdp_e_pri_mem_if.rd_rsp_ready     = `SDP.mcif2sdp_e_rd_rsp_ready;
assign sdp_e_pri_mem_if.rd_rsp_pd        = `SDP.mcif2sdp_e_rd_rsp_pd;
`endif

`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
`ifdef NVDLA_SDP_EW_ENABLE
assign sdp_e_sec_mem_if.rd_req_valid     = `SDP.sdp_e2cvif_rd_req_valid;
assign sdp_e_sec_mem_if.rd_req_ready     = `SDP.sdp_e2cvif_rd_req_ready;
assign sdp_e_sec_mem_if.rd_req_pd        = `SDP.sdp_e2cvif_rd_req_pd;
assign sdp_e_sec_mem_if.rd_rsp_valid     = `SDP.cvif2sdp_e_rd_rsp_valid;
assign sdp_e_sec_mem_if.rd_rsp_ready     = `SDP.cvif2sdp_e_rd_rsp_ready;
assign sdp_e_sec_mem_if.rd_rsp_pd        = `SDP.cvif2sdp_e_rd_rsp_pd;
`endif
`endif

`ifdef NVDLA_SDP_BN_ENABLE
assign sdp_n_pri_mem_if.rd_req_valid     = `SDP.sdp_n2mcif_rd_req_valid;
assign sdp_n_pri_mem_if.rd_req_ready     = `SDP.sdp_n2mcif_rd_req_ready;
assign sdp_n_pri_mem_if.rd_req_pd        = `SDP.sdp_n2mcif_rd_req_pd;
assign sdp_n_pri_mem_if.rd_rsp_valid     = `SDP.mcif2sdp_n_rd_rsp_valid;
assign sdp_n_pri_mem_if.rd_rsp_ready     = `SDP.mcif2sdp_n_rd_rsp_ready;
assign sdp_n_pri_mem_if.rd_rsp_pd        = `SDP.mcif2sdp_n_rd_rsp_pd;
`endif

`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
`ifdef NVDLA_SDP_BN_ENABLE
assign sdp_n_sec_mem_if.rd_req_valid     = `SDP.sdp_n2cvif_rd_req_valid;
assign sdp_n_sec_mem_if.rd_req_ready     = `SDP.sdp_n2cvif_rd_req_ready;
assign sdp_n_sec_mem_if.rd_req_pd        = `SDP.sdp_n2cvif_rd_req_pd;
assign sdp_n_sec_mem_if.rd_rsp_valid     = `SDP.cvif2sdp_n_rd_rsp_valid;
assign sdp_n_sec_mem_if.rd_rsp_ready     = `SDP.cvif2sdp_n_rd_rsp_ready;
assign sdp_n_sec_mem_if.rd_rsp_pd        = `SDP.cvif2sdp_n_rd_rsp_pd;
`endif
`endif

`ifdef NVDLA_PDP_ENABLE
assign pdp_pri_mem_if.rd_req_valid       = `PDP.pdp2mcif_rd_req_valid;
assign pdp_pri_mem_if.rd_req_ready       = `PDP.pdp2mcif_rd_req_ready;
assign pdp_pri_mem_if.rd_req_pd          = `PDP.pdp2mcif_rd_req_pd;
assign pdp_pri_mem_if.rd_rsp_valid       = `PDP.mcif2pdp_rd_rsp_valid;
assign pdp_pri_mem_if.rd_rsp_ready       = `PDP.mcif2pdp_rd_rsp_ready;
assign pdp_pri_mem_if.rd_rsp_pd          = `PDP.mcif2pdp_rd_rsp_pd;
assign pdp_pri_mem_if.wr_req_valid       = `PDP.pdp2mcif_wr_req_valid;
assign pdp_pri_mem_if.wr_req_ready       = `PDP.pdp2mcif_wr_req_ready;
assign pdp_pri_mem_if.wr_req_pd          = `PDP.pdp2mcif_wr_req_pd;
assign pdp_pri_mem_if.wr_rsp_complete    = `PDP.mcif2pdp_wr_rsp_complete;
`endif

`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
`ifdef NVDLA_PDP_ENABLE
assign pdp_sec_mem_if.rd_req_valid       = `PDP.pdp2cvif_rd_req_valid;
assign pdp_sec_mem_if.rd_req_ready       = `PDP.pdp2cvif_rd_req_ready;
assign pdp_sec_mem_if.rd_req_pd          = `PDP.pdp2cvif_rd_req_pd;
assign pdp_sec_mem_if.rd_rsp_valid       = `PDP.cvif2pdp_rd_rsp_valid;
assign pdp_sec_mem_if.rd_rsp_ready       = `PDP.cvif2pdp_rd_rsp_ready;
assign pdp_sec_mem_if.rd_rsp_pd          = `PDP.cvif2pdp_rd_rsp_pd;
assign pdp_sec_mem_if.wr_req_valid       = `PDP.pdp2cvif_wr_req_valid;
assign pdp_sec_mem_if.wr_req_ready       = `PDP.pdp2cvif_wr_req_ready;
assign pdp_sec_mem_if.wr_req_pd          = `PDP.pdp2cvif_wr_req_pd;
assign pdp_sec_mem_if.wr_rsp_complete    = `PDP.cvif2pdp_wr_rsp_complete;
`endif
`endif

`ifdef NVDLA_CDP_ENABLE
assign cdp_pri_mem_if.rd_req_valid       = `CDP.cdp2mcif_rd_req_valid;
assign cdp_pri_mem_if.rd_req_ready       = `CDP.cdp2mcif_rd_req_ready;
assign cdp_pri_mem_if.rd_req_pd          = `CDP.cdp2mcif_rd_req_pd;
assign cdp_pri_mem_if.rd_rsp_valid       = `CDP.mcif2cdp_rd_rsp_valid;
assign cdp_pri_mem_if.rd_rsp_ready       = `CDP.mcif2cdp_rd_rsp_ready;
assign cdp_pri_mem_if.rd_rsp_pd          = `CDP.mcif2cdp_rd_rsp_pd;
assign cdp_pri_mem_if.wr_req_valid       = `CDP.cdp2mcif_wr_req_valid;
assign cdp_pri_mem_if.wr_req_ready       = `CDP.cdp2mcif_wr_req_ready;
assign cdp_pri_mem_if.wr_req_pd          = `CDP.cdp2mcif_wr_req_pd;
assign cdp_pri_mem_if.wr_rsp_complete    = `CDP.mcif2cdp_wr_rsp_complete;
`endif

`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
`ifdef NVDLA_CDP_ENABLE
assign cdp_sec_mem_if.rd_req_valid       = `CDP.cdp2cvif_rd_req_valid;
assign cdp_sec_mem_if.rd_req_ready       = `CDP.cdp2cvif_rd_req_ready;
assign cdp_sec_mem_if.rd_req_pd          = `CDP.cdp2cvif_rd_req_pd;
assign cdp_sec_mem_if.rd_rsp_valid       = `CDP.cvif2cdp_rd_rsp_valid;
assign cdp_sec_mem_if.rd_rsp_ready       = `CDP.cvif2cdp_rd_rsp_ready;
assign cdp_sec_mem_if.rd_rsp_pd          = `CDP.cvif2cdp_rd_rsp_pd;
assign cdp_sec_mem_if.wr_req_valid       = `CDP.cdp2cvif_wr_req_valid;
assign cdp_sec_mem_if.wr_req_ready       = `CDP.cdp2cvif_wr_req_ready;
assign cdp_sec_mem_if.wr_req_pd          = `CDP.cdp2cvif_wr_req_pd;
assign cdp_sec_mem_if.wr_rsp_complete    = `CDP.cvif2cdp_wr_rsp_complete;
`endif
`endif

`ifdef NVDLA_BDMA_ENABLE
assign bdma_pri_mem_if.rd_req_valid      = `BDMA.bdma2mcif_rd_req_valid;
assign bdma_pri_mem_if.rd_req_ready      = `BDMA.bdma2mcif_rd_req_ready;
assign bdma_pri_mem_if.rd_req_pd         = `BDMA.bdma2mcif_rd_req_pd;
assign bdma_pri_mem_if.rd_rsp_valid      = `BDMA.mcif2bdma_rd_rsp_valid;
assign bdma_pri_mem_if.rd_rsp_ready      = `BDMA.mcif2bdma_rd_rsp_ready;
assign bdma_pri_mem_if.rd_rsp_pd         = `BDMA.mcif2bdma_rd_rsp_pd;
assign bdma_pri_mem_if.wr_req_valid      = `BDMA.bdma2mcif_wr_req_valid;
assign bdma_pri_mem_if.wr_req_ready      = `BDMA.bdma2mcif_wr_req_ready;
assign bdma_pri_mem_if.wr_req_pd         = `BDMA.bdma2mcif_wr_req_pd;
assign bdma_pri_mem_if.wr_rsp_complete   = `BDMA.mcif2bdma_wr_rsp_complete;
`endif

`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
`ifdef NVDLA_BDMA_ENABLE
assign bdma_sec_mem_if.rd_req_valid      = `BDMA.bdma2cvif_rd_req_valid;
assign bdma_sec_mem_if.rd_req_ready      = `BDMA.bdma2cvif_rd_req_ready;
assign bdma_sec_mem_if.rd_req_pd         = `BDMA.bdma2cvif_rd_req_pd;
assign bdma_sec_mem_if.rd_rsp_valid      = `BDMA.cvif2bdma_rd_rsp_valid;
assign bdma_sec_mem_if.rd_rsp_ready      = `BDMA.cvif2bdma_rd_rsp_ready;
assign bdma_sec_mem_if.rd_rsp_pd         = `BDMA.cvif2bdma_rd_rsp_pd;
assign bdma_sec_mem_if.wr_req_valid      = `BDMA.bdma2cvif_wr_req_valid;
assign bdma_sec_mem_if.wr_req_ready      = `BDMA.bdma2cvif_wr_req_ready;
assign bdma_sec_mem_if.wr_req_pd         = `BDMA.bdma2cvif_wr_req_pd;
assign bdma_sec_mem_if.wr_rsp_complete   = `BDMA.cvif2bdma_wr_rsp_complete;
`endif
`endif

`ifdef NVDLA_RUBIK_ENABLE
assign rbk_pri_mem_if.rd_req_valid       = `RBK.rbk2mcif_rd_req_valid;
assign rbk_pri_mem_if.rd_req_ready       = `RBK.rbk2mcif_rd_req_ready;
assign rbk_pri_mem_if.rd_req_pd          = `RBK.rbk2mcif_rd_req_pd;
assign rbk_pri_mem_if.rd_rsp_valid       = `RBK.mcif2rbk_rd_rsp_valid;
assign rbk_pri_mem_if.rd_rsp_ready       = `RBK.mcif2rbk_rd_rsp_ready;
assign rbk_pri_mem_if.rd_rsp_pd          = `RBK.mcif2rbk_rd_rsp_pd;
assign rbk_pri_mem_if.wr_req_valid       = `RBK.rbk2mcif_wr_req_valid;
assign rbk_pri_mem_if.wr_req_ready       = `RBK.rbk2mcif_wr_req_ready;
assign rbk_pri_mem_if.wr_req_pd          = `RBK.rbk2mcif_wr_req_pd;
assign rbk_pri_mem_if.wr_rsp_complete    = `RBK.mcif2rbk_wr_rsp_complete;
`endif

`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
`ifdef NVDLA_RUBIK_ENABLE
assign rbk_sec_mem_if.rd_req_valid       = `RBK.rbk2cvif_rd_req_valid;
assign rbk_sec_mem_if.rd_req_ready       = `RBK.rbk2cvif_rd_req_ready;
assign rbk_sec_mem_if.rd_req_pd          = `RBK.rbk2cvif_rd_req_pd;
assign rbk_sec_mem_if.rd_rsp_valid       = `RBK.cvif2rbk_rd_rsp_valid;
assign rbk_sec_mem_if.rd_rsp_ready       = `RBK.cvif2rbk_rd_rsp_ready;
assign rbk_sec_mem_if.rd_rsp_pd          = `RBK.cvif2rbk_rd_rsp_pd;
assign rbk_sec_mem_if.wr_req_valid       = `RBK.rbk2cvif_wr_req_valid;
assign rbk_sec_mem_if.wr_req_ready       = `RBK.rbk2cvif_wr_req_ready;
assign rbk_sec_mem_if.wr_req_pd          = `RBK.rbk2cvif_wr_req_pd;
assign rbk_sec_mem_if.wr_rsp_complete    = `RBK.cvif2rbk_wr_rsp_complete;
`endif
`endif

assign csc_dat_a_if.pvld               = `CSC.sc2mac_dat_a_pvld;
assign csc_dat_a_if.pd                 = `CSC.sc2mac_dat_a_pd;
assign csc_dat_a_if.mask               = `CSC.sc2mac_dat_a_mask;
//:| for idx in range(project.PROJVAR["NVDLA_MAC_ATOMIC_C_SIZE"]):
//:|     print("assign csc_dat_a_if.data[%0d]              = `CSC.sc2mac_dat_a_data%0d;" % (idx, idx))

assign csc_dat_b_if.pvld               = `CSC.sc2mac_dat_b_pvld;
assign csc_dat_b_if.pd                 = `CSC.sc2mac_dat_b_pd;
assign csc_dat_b_if.mask               = `CSC.sc2mac_dat_b_mask;
//:| for idx in range(project.PROJVAR["NVDLA_MAC_ATOMIC_C_SIZE"]):
//:|     print("assign csc_dat_b_if.data[%0d]              = `CSC.sc2mac_dat_b_data%0d;" % (idx, idx))

assign csc_wt_a_if.pvld                = `CSC.sc2mac_wt_a_pvld;
assign csc_wt_a_if.wt_sel              = `CSC.sc2mac_wt_a_sel;
assign csc_wt_a_if.mask                = `CSC.sc2mac_wt_a_mask;
//:| for idx in range(project.PROJVAR["NVDLA_MAC_ATOMIC_C_SIZE"]):
//:|     print("assign csc_wt_a_if.data[%0d]               = `CSC.sc2mac_wt_a_data%0d;" % (idx, idx))

assign csc_wt_b_if.pvld                = `CSC.sc2mac_wt_b_pvld;
assign csc_wt_b_if.wt_sel              = `CSC.sc2mac_wt_b_sel;
assign csc_wt_b_if.mask                = `CSC.sc2mac_wt_b_mask;
//:| for idx in range(project.PROJVAR["NVDLA_MAC_ATOMIC_C_SIZE"]):
//:|     print("assign csc_wt_b_if.data[%0d]               = `CSC.sc2mac_wt_b_data%0d;" % (idx, idx))

assign cmac_a_if.mask                  = `CMAC_A.mac2accu_mask;
assign cmac_a_if.mode                  = `CMAC_A.mac2accu_mode;
assign cmac_a_if.pvld                  = `CMAC_A.u_NV_NVDLA_cmac.u_core.dbg_mac2accu_pvld;
assign cmac_a_if.pd                    = `CMAC_A.u_NV_NVDLA_cmac.u_core.dbg_mac2accu_pd;
assign cmac_a_if.conv_mode             = `CMAC_A.u_NV_NVDLA_cmac.reg2dp_conv_mode;
assign cmac_a_if.proc_precision        = `CMAC_A.u_NV_NVDLA_cmac.reg2dp_proc_precision;
//:| for idx in range(project.PROJVAR["NVDLA_MAC_ATOMIC_K_SIZE"]//2):
//:|     print("assign cmac_a_if.data[%0d]                 = `CMAC_A.mac2accu_data%0d;" % (idx, idx))

assign cmac_b_if.mask                  = `CMAC_B.mac2accu_mask;
assign cmac_b_if.mode                  = `CMAC_B.mac2accu_mode;
assign cmac_b_if.pvld                  = `CMAC_B.u_NV_NVDLA_cmac.u_core.dbg_mac2accu_pvld;
assign cmac_b_if.pd                    = `CMAC_B.u_NV_NVDLA_cmac.u_core.dbg_mac2accu_pd;
assign cmac_b_if.conv_mode             = `CMAC_B.u_NV_NVDLA_cmac.reg2dp_conv_mode;
assign cmac_b_if.proc_precision        = `CMAC_B.u_NV_NVDLA_cmac.reg2dp_proc_precision;
//:| for idx in range(project.PROJVAR["NVDLA_MAC_ATOMIC_K_SIZE"]//2):
//:|     print("assign cmac_b_if.data[%0d]                 = `CMAC_B.mac2accu_data%0d;" % (idx, idx))

assign cacc_if.valid                = `CACC.cacc2sdp_valid;
assign cacc_if.ready                = `CACC.cacc2sdp_ready;
assign cacc_if.pd                   = `CACC.cacc2sdp_pd;

assign sdp_if.valid                 = `SDP.sdp2pdp_valid;
assign sdp_if.ready                 = `SDP.sdp2pdp_ready;
assign sdp_if.pd                    = `SDP.sdp2pdp_pd;


`endif // _NVDLA_TB_CONNECT_SV_
