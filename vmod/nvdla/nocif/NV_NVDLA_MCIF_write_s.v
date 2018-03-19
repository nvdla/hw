// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_write_s.v

#include "NV_NVDLA_MCIF_define.h"

module NV_NVDLA_MCIF_write_s (
  nvdla_core_clk            //|< i
  ,nvdla_core_rstn           //|< i
  #ifdef NVDLA_BDMA_ENABLE
  ,bdma2mcif_wr_req_pd       //|< i
  ,bdma2mcif_wr_req_valid    //|< i
  #endif
  #ifdef NVDLA_CDP_ENABLE
  ,cdp2mcif_wr_req_pd        //|< i
  ,cdp2mcif_wr_req_valid     //|< i
  #endif
  ,mcif2noc_axi_aw_awready   //|< i
  ,mcif2noc_axi_w_wready     //|< i
  ,noc2mcif_axi_b_bid        //|< i
  ,noc2mcif_axi_b_bvalid     //|< i
  #ifdef NVDLA_PDP_ENABLE
  ,pdp2mcif_wr_req_pd        //|< i
  ,pdp2mcif_wr_req_valid     //|< i
  #endif
  ,pwrbus_ram_pd             //|< i
  #ifdef NVDLA_RUBIK_ENABLE
  ,rbk2mcif_wr_req_pd        //|< i
  ,rbk2mcif_wr_req_valid     //|< i
  #endif
  ,reg2dp_wr_os_cnt          //|< i
  #ifdef NVDLA_BDMA_ENABLE
  ,reg2dp_wr_weight_bdma     //|< i
  #endif
  #ifdef NVDLA_CDP_ENABLE
  ,reg2dp_wr_weight_cdp      //|< i
  #endif
  #ifdef NVDLA_PDP_ENABLE
  ,reg2dp_wr_weight_pdp      //|< i
  #endif
  #ifdef NVDLA_RUBIK_ENABLE
  ,reg2dp_wr_weight_rbk      //|< i
  #endif
  ,reg2dp_wr_weight_sdp      //|< i
  ,sdp2mcif_wr_req_pd        //|< i
  ,sdp2mcif_wr_req_valid     //|< i
  #ifdef NVDLA_BDMA_ENABLE
  ,bdma2mcif_wr_req_ready    //|> o
  #endif
  #ifdef NVDLA_CDP_ENABLE
  ,cdp2mcif_wr_req_ready     //|> o
  #endif
  #ifdef NVDLA_BDMA_ENABLE
  ,mcif2bdma_wr_rsp_complete //|> o
  #endif
  #ifdef NVDLA_CDP_ENABLE
  ,mcif2cdp_wr_rsp_complete  //|> o
  #endif
  ,mcif2noc_axi_aw_awaddr    //|> o
  ,mcif2noc_axi_aw_awid      //|> o
  ,mcif2noc_axi_aw_awlen     //|> o
  ,mcif2noc_axi_aw_awvalid   //|> o
  ,mcif2noc_axi_w_wdata      //|> o
  ,mcif2noc_axi_w_wlast      //|> o
  ,mcif2noc_axi_w_wstrb      //|> o
  ,mcif2noc_axi_w_wvalid     //|> o
  #ifdef NVDLA_PDP_ENABLE
  ,mcif2pdp_wr_rsp_complete  //|> o
  #endif
  #ifdef NVDLA_RUBIK_ENABLE
  ,mcif2rbk_wr_rsp_complete  //|> o
  #endif
  ,mcif2sdp_wr_rsp_complete  //|> o
  ,noc2mcif_axi_b_bready     //|> o
  #ifdef NVDLA_PDP_ENABLE
  ,pdp2mcif_wr_req_ready     //|> o
  #endif
  #ifdef NVDLA_RUBIK_ENABLE
  ,rbk2mcif_wr_req_ready     //|> o
  #endif
  ,sdp2mcif_wr_req_ready     //|> o
  );
//////////////////////////////////////////////////////
//
// NV_NVDLA_MCIF_write_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn; 

  #ifdef NVDLA_BDMA_ENABLE
input          bdma2mcif_wr_req_valid;  /* data valid */
output         bdma2mcif_wr_req_ready;  /* data return handshake */
input  [MEM_WR_PD_BW-1:0] bdma2mcif_wr_req_pd; 
#endif

  #ifdef NVDLA_CDP_ENABLE
input          cdp2mcif_wr_req_valid;
output         cdp2mcif_wr_req_ready; 
input  [MEM_WR_PD_BW-1:0] cdp2mcif_wr_req_pd; 
#endif

  #ifdef NVDLA_BDMA_ENABLE
output  mcif2bdma_wr_rsp_complete;
#endif

  #ifdef NVDLA_CDP_ENABLE
output  mcif2cdp_wr_rsp_complete;
#endif

output        mcif2noc_axi_aw_awvalid;  /* data valid */
input         mcif2noc_axi_aw_awready;  /* data return handshake */
output  [7:0] mcif2noc_axi_aw_awid;
output  [3:0] mcif2noc_axi_aw_awlen;
output [31:0] mcif2noc_axi_aw_awaddr;

output         mcif2noc_axi_w_wvalid;  /* data valid */
input          mcif2noc_axi_w_wready;  /* data return handshake */
output [MEM_BW-1:0] mcif2noc_axi_w_wdata;
//output  [63:0] mcif2noc_axi_w_wstrb;//
output  [31:0] mcif2noc_axi_w_wstrb;//
output         mcif2noc_axi_w_wlast;

  #ifdef NVDLA_PDP_ENABLE
output  mcif2pdp_wr_rsp_complete;
#endif

  #ifdef NVDLA_RUBIK_ENABLE
output  mcif2rbk_wr_rsp_complete;
#endif

output  mcif2sdp_wr_rsp_complete;

input        noc2mcif_axi_b_bvalid;  /* data valid */
output       noc2mcif_axi_b_bready;  /* data return handshake */
input  [7:0] noc2mcif_axi_b_bid;

  #ifdef NVDLA_PDP_ENABLE
input          pdp2mcif_wr_req_valid;  /* data valid */
output         pdp2mcif_wr_req_ready;  /* data return handshake */
input  [MEM_WR_PD_BW-1:0] pdp2mcif_wr_req_pd; 
#endif

input [31:0] pwrbus_ram_pd;

  #ifdef NVDLA_RUBIK_ENABLE
input          rbk2mcif_wr_req_valid;  /* data valid */
output         rbk2mcif_wr_req_ready;  /* data return handshake */
input  [MEM_WR_PD_BW-1:0] rbk2mcif_wr_req_pd;  
#endif

input          sdp2mcif_wr_req_valid;  /* data valid */
output         sdp2mcif_wr_req_ready;  /* data return handshake */
input  [MEM_WR_PD_BW-1:0] sdp2mcif_wr_req_pd;

input [7:0] reg2dp_wr_os_cnt;
  #ifdef NVDLA_BDMA_ENABLE
input [7:0] reg2dp_wr_weight_bdma;
#endif
  #ifdef NVDLA_CDP_ENABLE
input [7:0] reg2dp_wr_weight_cdp;
#endif
  #ifdef NVDLA_PDP_ENABLE
input [7:0] reg2dp_wr_weight_pdp;
#endif
  #ifdef NVDLA_RUBIK_ENABLE
input [7:0] reg2dp_wr_weight_rbk;
#endif
input [7:0] reg2dp_wr_weight_sdp;
wire  [2:0] cq_rd0_pd;
wire        cq_rd0_prdy;
wire        cq_rd0_pvld;
wire  [2:0] cq_rd1_pd;
wire        cq_rd1_prdy;
wire        cq_rd1_pvld;
wire  [2:0] cq_rd2_pd;
wire        cq_rd2_prdy;
wire        cq_rd2_pvld;
wire  [2:0] cq_rd3_pd;
wire        cq_rd3_prdy;
wire        cq_rd3_pvld;
wire  [2:0] cq_rd4_pd;
wire        cq_rd4_prdy;
wire        cq_rd4_pvld;
wire  [2:0] cq_wr_pd;
wire        cq_wr_prdy;
wire        cq_wr_pvld;
wire  [2:0] cq_wr_thread_id;
wire  [1:0] eg2ig_axi_len;
wire        eg2ig_axi_vld;
///////////////////////////////////////////////////////////
NV_NVDLA_MCIF_WRITE_ig_s u_ig (
   .nvdla_core_clk            (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)              //|< i
  #ifdef NVDLA_BDMA_ENABLE
  ,.bdma2mcif_wr_req_valid    (bdma2mcif_wr_req_valid)       //|< i
  ,.bdma2mcif_wr_req_ready    (bdma2mcif_wr_req_ready)       //|> o
  ,.bdma2mcif_wr_req_pd       (bdma2mcif_wr_req_pd)   //|< i
  #endif
  #ifdef NVDLA_CDP_ENABLE
  ,.cdp2mcif_wr_req_valid     (cdp2mcif_wr_req_valid)        //|< i
  ,.cdp2mcif_wr_req_ready     (cdp2mcif_wr_req_ready)        //|> o
  ,.cdp2mcif_wr_req_pd        (cdp2mcif_wr_req_pd)    //|< i
  #endif
  ,.cq_wr_pvld                (cq_wr_pvld)                   //|> w
  ,.cq_wr_prdy                (cq_wr_prdy)                   //|< w
  ,.cq_wr_thread_id           (cq_wr_thread_id[2:0])         //|> w
  ,.cq_wr_pd                  (cq_wr_pd[2:0])                //|> w
  ,.mcif2noc_axi_aw_awvalid   (mcif2noc_axi_aw_awvalid)      //|> o
  ,.mcif2noc_axi_aw_awready   (mcif2noc_axi_aw_awready)      //|< i
  ,.mcif2noc_axi_aw_awid      (mcif2noc_axi_aw_awid[7:0])    //|> o
  ,.mcif2noc_axi_aw_awlen     (mcif2noc_axi_aw_awlen[3:0])   //|> o
  ,.mcif2noc_axi_aw_awaddr    (mcif2noc_axi_aw_awaddr) //|> o
  ,.mcif2noc_axi_w_wvalid     (mcif2noc_axi_w_wvalid)        //|> o
  ,.mcif2noc_axi_w_wready     (mcif2noc_axi_w_wready)        //|< i
  ,.mcif2noc_axi_w_wdata      (mcif2noc_axi_w_wdata)  //|> o
  ,.mcif2noc_axi_w_wstrb      (mcif2noc_axi_w_wstrb)   //|> o
  ,.mcif2noc_axi_w_wlast      (mcif2noc_axi_w_wlast)         //|> o
  #ifdef NVDLA_PDP_ENABLE
  ,.pdp2mcif_wr_req_valid     (pdp2mcif_wr_req_valid)        //|< i
  ,.pdp2mcif_wr_req_ready     (pdp2mcif_wr_req_ready)        //|> o
  ,.pdp2mcif_wr_req_pd        (pdp2mcif_wr_req_pd)    //|< i
  #endif
  ,.pwrbus_ram_pd             (pwrbus_ram_pd[31:0])          //|< i
  #ifdef NVDLA_RUBIK_ENABLE
  ,.rbk2mcif_wr_req_valid     (rbk2mcif_wr_req_valid)        //|< i
  ,.rbk2mcif_wr_req_ready     (rbk2mcif_wr_req_ready)        //|> o
  ,.rbk2mcif_wr_req_pd        (rbk2mcif_wr_req_pd)    //|< i
  #endif
  ,.sdp2mcif_wr_req_valid     (sdp2mcif_wr_req_valid)        //|< i
  ,.sdp2mcif_wr_req_ready     (sdp2mcif_wr_req_ready)        //|> o
  ,.sdp2mcif_wr_req_pd        (sdp2mcif_wr_req_pd)    //|< i
  ,.reg2dp_wr_os_cnt          (reg2dp_wr_os_cnt[7:0])        //|< i
  #ifdef NVDLA_BDMA_ENABLE
  ,.reg2dp_wr_weight_bdma     (reg2dp_wr_weight_bdma[7:0])   //|< i
  #endif
  #ifdef NVDLA_CDP_ENABLE
  ,.reg2dp_wr_weight_cdp      (reg2dp_wr_weight_cdp[7:0])    //|< i
  #endif
  #ifdef NVDLA_PDP_ENABLE
  ,.reg2dp_wr_weight_pdp      (reg2dp_wr_weight_pdp[7:0])    //|< i
  #endif
  #ifdef NVDLA_RUBIK_ENABLE
  ,.reg2dp_wr_weight_rbk      (reg2dp_wr_weight_rbk[7:0])    //|< i
  #endif
  ,.reg2dp_wr_weight_sdp      (reg2dp_wr_weight_sdp[7:0])    //|< i
  ,.eg2ig_axi_len             (eg2ig_axi_len[1:0])           //|< w
  ,.eg2ig_axi_vld             (eg2ig_axi_vld)                //|< w
  );

NV_NVDLA_MCIF_WRITE_eg_s u_eg (
   .nvdla_core_clk            (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)              //|< i
  ,.mcif2sdp_wr_rsp_complete  (mcif2sdp_wr_rsp_complete)     //|> o
  #ifdef NVDLA_CDP_ENABLE
  ,.mcif2cdp_wr_rsp_complete  (mcif2cdp_wr_rsp_complete)     //|> o
  #endif
  #ifdef NVDLA_PDP_ENABLE
  ,.mcif2pdp_wr_rsp_complete  (mcif2pdp_wr_rsp_complete)     //|> o
  #endif
  #ifdef NVDLA_BDMA_ENABLE
  ,.mcif2bdma_wr_rsp_complete (mcif2bdma_wr_rsp_complete)    //|> o
  #endif
  #ifdef NVDLA_RUBIK_ENABLE
  ,.mcif2rbk_wr_rsp_complete  (mcif2rbk_wr_rsp_complete)     //|> o
  #endif
  ,.cq_rd0_pvld               (cq_rd0_pvld)                  //|< w
  ,.cq_rd0_prdy               (cq_rd0_prdy)                  //|> w
  ,.cq_rd0_pd                 (cq_rd0_pd[2:0])               //|< w
  ,.cq_rd1_pvld               (cq_rd1_pvld)                  //|< w
  ,.cq_rd1_prdy               (cq_rd1_prdy)                  //|> w
  ,.cq_rd1_pd                 (cq_rd1_pd[2:0])               //|< w
  ,.cq_rd2_pvld               (cq_rd2_pvld)                  //|< w
  ,.cq_rd2_prdy               (cq_rd2_prdy)                  //|> w
  ,.cq_rd2_pd                 (cq_rd2_pd[2:0])               //|< w
  ,.cq_rd3_pvld               (cq_rd3_pvld)                  //|< w
  ,.cq_rd3_prdy               (cq_rd3_prdy)                  //|> w
  ,.cq_rd3_pd                 (cq_rd3_pd[2:0])               //|< w
  ,.cq_rd4_pvld               (cq_rd4_pvld)                  //|< w
  ,.cq_rd4_prdy               (cq_rd4_prdy)                  //|> w
  ,.cq_rd4_pd                 (cq_rd4_pd[2:0])               //|< w
  ,.noc2mcif_axi_b_bvalid     (noc2mcif_axi_b_bvalid)        //|< i
  ,.noc2mcif_axi_b_bready     (noc2mcif_axi_b_bready)        //|> o
  ,.noc2mcif_axi_b_bid        (noc2mcif_axi_b_bid[7:0])      //|< i
  ,.eg2ig_axi_len             (eg2ig_axi_len[1:0])           //|> w
  ,.eg2ig_axi_vld             (eg2ig_axi_vld)                //|> w
  );

NV_NVDLA_MCIF_WRITE_cq u_cq (
   .nvdla_core_clk            (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)              //|< i
  ,.cq_wr_prdy                (cq_wr_prdy)                   //|> w
  ,.cq_wr_pvld                (cq_wr_pvld)                   //|< w
  ,.cq_wr_thread_id           (cq_wr_thread_id[2:0])         //|< w
  ,.cq_wr_pd                  (cq_wr_pd[2:0])                //|< w
  ,.cq_rd0_prdy               (cq_rd0_prdy)                  //|< w
  ,.cq_rd0_pvld               (cq_rd0_pvld)                  //|> w
  ,.cq_rd0_pd                 (cq_rd0_pd[2:0])               //|> w
  ,.cq_rd1_prdy               (cq_rd1_prdy)                  //|< w
  ,.cq_rd1_pvld               (cq_rd1_pvld)                  //|> w
  ,.cq_rd1_pd                 (cq_rd1_pd[2:0])               //|> w
  ,.cq_rd2_prdy               (cq_rd2_prdy)                  //|< w
  ,.cq_rd2_pvld               (cq_rd2_pvld)                  //|> w
  ,.cq_rd2_pd                 (cq_rd2_pd[2:0])               //|> w
  ,.cq_rd3_prdy               (cq_rd3_prdy)                  //|< w
  ,.cq_rd3_pvld               (cq_rd3_pvld)                  //|> w
  ,.cq_rd3_pd                 (cq_rd3_pd[2:0])               //|> w
  ,.cq_rd4_prdy               (cq_rd4_prdy)                  //|< w
  ,.cq_rd4_pvld               (cq_rd4_pvld)                  //|> w
  ,.cq_rd4_pd                 (cq_rd4_pd[2:0])               //|> w
  ,.pwrbus_ram_pd             (pwrbus_ram_pd[31:0])          //|< i
  );

endmodule // NV_NVDLA_MCIF_write

