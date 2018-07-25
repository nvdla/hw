// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_rdma.v

module NV_NVDLA_CDP_rdma (
   nvdla_core_clk                //|< i
  ,nvdla_core_rstn               //|< i
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cdp2cvif_rd_cdt_lat_fifo_pop  //|> o
  ,cdp2cvif_rd_req_valid         //|> o
  ,cdp2cvif_rd_req_ready         //|< i
  ,cdp2cvif_rd_req_pd            //|> o
  #endif
  ,cdp2mcif_rd_cdt_lat_fifo_pop  //|> o
  ,cdp2mcif_rd_req_valid         //|> o
  ,cdp2mcif_rd_req_ready         //|< i
  ,cdp2mcif_rd_req_pd            //|> o
  ,cdp_rdma2csb_resp_valid       //|> o
  ,cdp_rdma2csb_resp_pd          //|> o
  ,cdp_rdma2dp_valid             //|> o
  ,cdp_rdma2dp_ready             //|< i
  ,cdp_rdma2dp_pd                //|> o
  ,csb2cdp_rdma_req_pvld         //|< i
  ,csb2cdp_rdma_req_prdy         //|> o
  ,csb2cdp_rdma_req_pd           //|< i
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cvif2cdp_rd_rsp_valid         //|< i
  ,cvif2cdp_rd_rsp_ready         //|> o
  ,cvif2cdp_rd_rsp_pd            //|< i
  #endif
  ,mcif2cdp_rd_rsp_valid         //|< i
  ,mcif2cdp_rd_rsp_ready         //|> o
  ,mcif2cdp_rd_rsp_pd            //|< i
  ,pwrbus_ram_pd                 //|< i
  ,dla_clk_ovr_on_sync           //|< i
  ,global_clk_ovr_on_sync        //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  );
 //
 // NV_NVDLA_CDP_rdma_ports.v
 //
 input  nvdla_core_clk;   /* cdp2cvif_rd_cdt, cdp2cvif_rd_req, cdp2mcif_rd_cdt, cdp2mcif_rd_req, cdp_rdma2csb_resp, cdp_rdma2dp, csb2cdp_rdma_req, cvif2cdp_rd_rsp, mcif2cdp_rd_rsp */
 input  nvdla_core_rstn;  /* cdp2cvif_rd_cdt, cdp2cvif_rd_req, cdp2mcif_rd_cdt, cdp2mcif_rd_req, cdp_rdma2csb_resp, cdp_rdma2dp, csb2cdp_rdma_req, cvif2cdp_rd_rsp, mcif2cdp_rd_rsp */

  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
 output  cdp2cvif_rd_cdt_lat_fifo_pop;

 output        cdp2cvif_rd_req_valid;  /* data valid */
 input         cdp2cvif_rd_req_ready;  /* data return handshake */
 output [NVDLA_DMA_RD_REQ-1:0] cdp2cvif_rd_req_pd;
 #endif

 output  cdp2mcif_rd_cdt_lat_fifo_pop;

 output        cdp2mcif_rd_req_valid;  /* data valid */
 input         cdp2mcif_rd_req_ready;  /* data return handshake */
 output [NVDLA_DMA_RD_REQ-1:0] cdp2mcif_rd_req_pd;

 output        cdp_rdma2csb_resp_valid;  /* data valid */
 output [33:0] cdp_rdma2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

 output        cdp_rdma2dp_valid;  /* data valid */
 input         cdp_rdma2dp_ready;  /* data return handshake */
 output [NVDLA_CDP_THROUGHPUT*NVDLA_BPE+24:0] cdp_rdma2dp_pd;

 input         csb2cdp_rdma_req_pvld;  /* data valid */
 output        csb2cdp_rdma_req_prdy;  /* data return handshake */
 input  [62:0] csb2cdp_rdma_req_pd;

  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
 input          cvif2cdp_rd_rsp_valid;  /* data valid */
 output         cvif2cdp_rd_rsp_ready;  /* data return handshake */
 input  [NVDLA_DMA_RD_RSP-1:0] cvif2cdp_rd_rsp_pd;
 #endif

 input          mcif2cdp_rd_rsp_valid;  /* data valid */
 output         mcif2cdp_rd_rsp_ready;  /* data return handshake */
 input  [NVDLA_DMA_RD_RSP-1:0] mcif2cdp_rd_rsp_pd;

 input [31:0] pwrbus_ram_pd;

input   dla_clk_ovr_on_sync;
input   global_clk_ovr_on_sync;
input   tmc2slcg_disable_clock_gating;

wire  [6:0] cq_rd_pd;
wire        cq_rd_prdy;
wire        cq_rd_pvld;
wire  [6:0] cq_wr_pd;
wire        cq_wr_prdy;
wire        cq_wr_pvld;
wire [31:0] dp2reg_d0_perf_read_stall;
wire [31:0] dp2reg_d1_perf_read_stall;
wire        dp2reg_done;
wire        eg2ig_done;
wire        nvdla_op_gated_clk;
wire [12:0] reg2dp_channel;
wire [31:0] reg2dp_cya;
wire  [0:0] reg2dp_dma_en;
wire [12:0] reg2dp_height;
wire  [1:0] reg2dp_input_data;
wire  [0:0] reg2dp_op_en;
wire [31:0] reg2dp_src_base_addr_high;
wire [31:0] reg2dp_src_base_addr_low;
wire [31:0] reg2dp_src_line_stride;
wire  [0:0] reg2dp_src_ram_type;
wire [31:0] reg2dp_src_surface_stride;
wire [12:0] reg2dp_width;
wire        slcg_op_en;

//=======================================
//        SLCG gen unit
//---------------------------------------
NV_NVDLA_CDP_slcg u_slcg (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)             //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)          //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.slcg_en_src                   (slcg_op_en)                      //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)   //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk)              //|> w
  );
 //=======================================
 // Ingress: send read request to external mem
 //---------------------------------------
 NV_NVDLA_CDP_RDMA_ig u_ig (
    .reg2dp_channel                (reg2dp_channel[12:0])            //|< w
   ,.reg2dp_dma_en                 (reg2dp_dma_en[0])                //|< w
   ,.reg2dp_height                 (reg2dp_height[12:0])             //|< w
   ,.reg2dp_input_data             (reg2dp_input_data[1:0])          //|< w
   ,.reg2dp_op_en                  (reg2dp_op_en[0])                 //|< w
   ,.reg2dp_src_base_addr_high     (reg2dp_src_base_addr_high[31:0]) //|< w
   ,.reg2dp_src_base_addr_low      (reg2dp_src_base_addr_low[31:0]) 
   ,.reg2dp_src_line_stride        (reg2dp_src_line_stride[31:0])   
   ,.reg2dp_src_surface_stride     (reg2dp_src_surface_stride[31:0])
   ,.reg2dp_src_ram_type           (reg2dp_src_ram_type[0])          //|< w
   ,.reg2dp_width                  (reg2dp_width[12:0])              //|< w
   ,.dp2reg_d0_perf_read_stall     (dp2reg_d0_perf_read_stall[31:0]) //|> w
   ,.dp2reg_d1_perf_read_stall     (dp2reg_d1_perf_read_stall[31:0]) //|> w
   ,.eg2ig_done                    (eg2ig_done)                      //|< w
   ,.nvdla_core_clk                (nvdla_op_gated_clk)              //|< w
   ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
   ,.cdp2mcif_rd_req_valid         (cdp2mcif_rd_req_valid)           //|> o
   ,.cdp2mcif_rd_req_ready         (cdp2mcif_rd_req_ready)           //|< i
   ,.cdp2mcif_rd_req_pd            (cdp2mcif_rd_req_pd)        //|> o
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
   ,.cdp2cvif_rd_req_valid         (cdp2cvif_rd_req_valid)           //|> o
   ,.cdp2cvif_rd_req_ready         (cdp2cvif_rd_req_ready)           //|< i
   ,.cdp2cvif_rd_req_pd            (cdp2cvif_rd_req_pd)        //|> o
   #endif
   ,.cq_wr_pvld                    (cq_wr_pvld)                      //|> w
   ,.cq_wr_prdy                    (cq_wr_prdy)                      //|< w
   ,.cq_wr_pd                      (cq_wr_pd[6:0])                   //|> w
   );

 //=======================================
 // Context Queue: trace outstanding req, and pass info from Ig to Eg
 //---------------------------------------
 NV_NVDLA_CDP_RDMA_cq u_cq (
    .nvdla_core_clk                (nvdla_op_gated_clk)              //|< w
   ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
   ,.cq_wr_prdy                    (cq_wr_prdy)                      //|> w
   ,.cq_wr_pvld                    (cq_wr_pvld)                      //|< w
   ,.cq_wr_pd                      (cq_wr_pd[6:0])                   //|< w
   ,.cq_rd_prdy                    (cq_rd_prdy)                      //|< w
   ,.cq_rd_pvld                    (cq_rd_pvld)                      //|> w
   ,.cq_rd_pd                      (cq_rd_pd[6:0])                   //|> w
   ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])             //|< i
   );
 //=======================================
 // Egress: get return data from external mem
 //---------------------------------------
 NV_NVDLA_CDP_RDMA_eg u_eg (
    .reg2dp_channel                (reg2dp_channel[4:0])             //|< w
   ,.reg2dp_input_data             (reg2dp_input_data[1:0])          //|< w
   ,.reg2dp_src_ram_type           (reg2dp_src_ram_type)             //|< w
   ,.dp2reg_done                   (dp2reg_done)                     //|> w
   ,.eg2ig_done                    (eg2ig_done)                      //|> w
   ,.nvdla_core_clk                (nvdla_op_gated_clk)              //|< w
   ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
   ,.mcif2cdp_rd_rsp_valid         (mcif2cdp_rd_rsp_valid)           //|< i
   ,.mcif2cdp_rd_rsp_ready         (mcif2cdp_rd_rsp_ready)           //|> o
   ,.mcif2cdp_rd_rsp_pd            (mcif2cdp_rd_rsp_pd)       //|< i
   ,.cdp2mcif_rd_cdt_lat_fifo_pop  (cdp2mcif_rd_cdt_lat_fifo_pop)    //|> o
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
   ,.cvif2cdp_rd_rsp_valid         (cvif2cdp_rd_rsp_valid)           //|< i
   ,.cvif2cdp_rd_rsp_ready         (cvif2cdp_rd_rsp_ready)           //|> o
   ,.cvif2cdp_rd_rsp_pd            (cvif2cdp_rd_rsp_pd)       //|< i
   ,.cdp2cvif_rd_cdt_lat_fifo_pop  (cdp2cvif_rd_cdt_lat_fifo_pop)    //|> o
   #endif
   ,.cdp_rdma2dp_valid             (cdp_rdma2dp_valid)               //|> o
   ,.cdp_rdma2dp_ready             (cdp_rdma2dp_ready)               //|< i
   ,.cdp_rdma2dp_pd                (cdp_rdma2dp_pd)            //|> o
   ,.cq_rd_pvld                    (cq_rd_pvld)                      //|< w
   ,.cq_rd_prdy                    (cq_rd_prdy)                      //|> w
   ,.cq_rd_pd                      (cq_rd_pd[6:0])                   //|< w
   ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])             //|< i
   );

 //========================================
 //CFG: Configure Registers
 //----------------------------------------
 NV_NVDLA_CDP_RDMA_reg u_reg (
    .nvdla_core_clk                (nvdla_core_clk)                  //|< i
   ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
   ,.csb2cdp_rdma_req_pd           (csb2cdp_rdma_req_pd[62:0])       //|< i
   ,.csb2cdp_rdma_req_pvld         (csb2cdp_rdma_req_pvld)           //|< i
   ,.dp2reg_d0_perf_read_stall     (dp2reg_d0_perf_read_stall[31:0]) //|< w
   ,.dp2reg_d1_perf_read_stall     (dp2reg_d1_perf_read_stall[31:0]) //|< w
   ,.dp2reg_done                   (dp2reg_done)                     //|< w
   ,.cdp_rdma2csb_resp_pd          (cdp_rdma2csb_resp_pd[33:0])      //|> o
   ,.cdp_rdma2csb_resp_valid       (cdp_rdma2csb_resp_valid)         //|> o
   ,.csb2cdp_rdma_req_prdy         (csb2cdp_rdma_req_prdy)           //|> o
   ,.reg2dp_channel                (reg2dp_channel[12:0])            //|> w
   ,.reg2dp_cya                    (reg2dp_cya[31:0])                //|> w *
   ,.reg2dp_dma_en                 (reg2dp_dma_en)                   //|> w
   ,.reg2dp_height                 (reg2dp_height[12:0])             //|> w
   ,.reg2dp_input_data             (reg2dp_input_data[1:0])          //|> w
   ,.reg2dp_op_en                  (reg2dp_op_en)                    //|> w
   ,.reg2dp_src_base_addr_high     (reg2dp_src_base_addr_high[31:0]) //|> w
   ,.reg2dp_src_base_addr_low      (reg2dp_src_base_addr_low[31:0])  //|> w
   ,.reg2dp_src_line_stride        (reg2dp_src_line_stride[31:0])    //|> w
   ,.reg2dp_src_ram_type           (reg2dp_src_ram_type)             //|> w
   ,.reg2dp_src_surface_stride     (reg2dp_src_surface_stride[31:0]) //|> w
   ,.reg2dp_width                  (reg2dp_width[12:0])              //|> w
   ,.slcg_op_en                    (slcg_op_en)                      //|> w
   );



endmodule // NV_NVDLA_CDP_rdma

