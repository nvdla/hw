// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_rubik.v

module NV_NVDLA_rubik (
   nvdla_core_clk                //|< i
  ,nvdla_core_rstn               //|< i
  ,csb2rbk_req_pvld              //|< i
  ,csb2rbk_req_prdy              //|> o
  ,csb2rbk_req_pd                //|< i
  ,rbk2csb_resp_valid            //|> o
  ,rbk2csb_resp_pd               //|> o
  ,pwrbus_ram_pd                 //|< i
  ,rbk2mcif_rd_req_valid         //|> o
  ,rbk2mcif_rd_req_ready         //|< i
  ,rbk2mcif_rd_req_pd            //|> o
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,rbk2cvif_rd_req_valid         //|> o
  ,rbk2cvif_rd_req_ready         //|< i
  ,rbk2cvif_rd_req_pd            //|> o
#endif
  ,mcif2rbk_rd_rsp_valid         //|< i
  ,mcif2rbk_rd_rsp_ready         //|> o
  ,mcif2rbk_rd_rsp_pd            //|< i
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cvif2rbk_rd_rsp_valid         //|< i
  ,cvif2rbk_rd_rsp_ready         //|> o
  ,cvif2rbk_rd_rsp_pd            //|< i
#endif
  ,rbk2mcif_wr_req_valid         //|> o
  ,rbk2mcif_wr_req_ready         //|< i
  ,rbk2mcif_wr_req_pd            //|> o
  ,mcif2rbk_wr_rsp_complete      //|< i
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,rbk2cvif_wr_req_valid         //|> o
  ,rbk2cvif_wr_req_ready         //|< i
  ,rbk2cvif_wr_req_pd            //|> o
  ,cvif2rbk_wr_rsp_complete      //|< i
#endif
  ,rbk2mcif_rd_cdt_lat_fifo_pop  //|> o
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,rbk2cvif_rd_cdt_lat_fifo_pop  //|> o
#endif
  ,rubik2glb_done_intr_pd        //|> o
  ,dla_clk_ovr_on_sync           //|< i
  ,global_clk_ovr_on_sync        //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  );


//
// NV_NVDLA_rubik_ports.v
//
input  nvdla_core_clk;   /* csb2rbk_req, rbk2csb_resp, rbk2mcif_rd_req, rbk2cvif_rd_req, mcif2rbk_rd_rsp, cvif2rbk_rd_rsp, rbk2mcif_wr_req, mcif2rbk_wr_rsp, rbk2cvif_wr_req, cvif2rbk_wr_rsp, rbk2mcif_rd_cdt, rbk2cvif_rd_cdt, rubik2glb_done_intr */
input  nvdla_core_rstn;  /* csb2rbk_req, rbk2csb_resp, rbk2mcif_rd_req, rbk2cvif_rd_req, mcif2rbk_rd_rsp, cvif2rbk_rd_rsp, rbk2mcif_wr_req, mcif2rbk_wr_rsp, rbk2cvif_wr_req, cvif2rbk_wr_rsp, rbk2mcif_rd_cdt, rbk2cvif_rd_cdt, rubik2glb_done_intr */

input         csb2rbk_req_pvld;  /* data valid */
output        csb2rbk_req_prdy;  /* data return handshake */
input  [62:0] csb2rbk_req_pd;

output        rbk2csb_resp_valid;  /* data valid */
output [33:0] rbk2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

input [31:0] pwrbus_ram_pd;

output        rbk2mcif_rd_req_valid;  /* data valid */
input         rbk2mcif_rd_req_ready;  /* data return handshake */
output [78:0] rbk2mcif_rd_req_pd;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
output        rbk2cvif_rd_req_valid;  /* data valid */
input         rbk2cvif_rd_req_ready;  /* data return handshake */
output [78:0] rbk2cvif_rd_req_pd;
#endif

input          mcif2rbk_rd_rsp_valid;  /* data valid */
output         mcif2rbk_rd_rsp_ready;  /* data return handshake */
input  [513:0] mcif2rbk_rd_rsp_pd;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
input          cvif2rbk_rd_rsp_valid;  /* data valid */
output         cvif2rbk_rd_rsp_ready;  /* data return handshake */
input  [513:0] cvif2rbk_rd_rsp_pd;
#endif

output         rbk2mcif_wr_req_valid;  /* data valid */
input          rbk2mcif_wr_req_ready;  /* data return handshake */
output [514:0] rbk2mcif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input  mcif2rbk_wr_rsp_complete;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
output         rbk2cvif_wr_req_valid;  /* data valid */
input          rbk2cvif_wr_req_ready;  /* data return handshake */
output [514:0] rbk2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input  cvif2rbk_wr_rsp_complete;
#endif

output  rbk2mcif_rd_cdt_lat_fifo_pop;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
output  rbk2cvif_rd_cdt_lat_fifo_pop;
#endif

output [1:0] rubik2glb_done_intr_pd;

input   dla_clk_ovr_on_sync;
input   global_clk_ovr_on_sync;
input   tmc2slcg_disable_clock_gating;

//&Ports /^obs_bus/;

wire         contract_lit_dx;
wire [511:0] data_fifo_pd;
wire         data_fifo_rdy;
wire         data_fifo_vld;
wire  [77:0] dma_wr_cmd_pd;
wire         dma_wr_cmd_rdy;
wire         dma_wr_cmd_vld;
wire [513:0] dma_wr_data_pd;
wire         dma_wr_data_rdy;
wire         dma_wr_data_vld;
wire         dp2reg_consumer;
wire  [31:0] dp2reg_d0_rd_stall_cnt;
wire  [31:0] dp2reg_d0_wr_stall_cnt;
wire  [31:0] dp2reg_d1_rd_stall_cnt;
wire  [31:0] dp2reg_d1_wr_stall_cnt;
wire         dp2reg_done;
wire  [13:0] inwidth;
wire         nvdla_op_gated_clk_0;
wire         nvdla_op_gated_clk_1;
wire         nvdla_op_gated_clk_2;
wire         rd_cdt_lat_fifo_pop;
wire  [78:0] rd_req_pd;
wire         rd_req_rdy;
wire         rd_req_type;
wire         rd_req_vld;
wire [513:0] rd_rsp_pd;
wire         rd_rsp_rdy;
wire         rd_rsp_vld;
wire  [26:0] reg2dp_contract_stride_0;
wire  [26:0] reg2dp_contract_stride_1;
wire  [31:0] reg2dp_dain_addr_high;
wire  [26:0] reg2dp_dain_addr_low;
wire  [26:0] reg2dp_dain_line_stride;
wire  [26:0] reg2dp_dain_planar_stride;
wire  [26:0] reg2dp_dain_surf_stride;
wire  [31:0] reg2dp_daout_addr_high;
wire  [26:0] reg2dp_daout_addr_low;
wire  [26:0] reg2dp_daout_line_stride;
wire  [26:0] reg2dp_daout_planar_stride;
wire  [26:0] reg2dp_daout_surf_stride;
wire  [12:0] reg2dp_datain_channel;
wire  [12:0] reg2dp_datain_height;
wire         reg2dp_datain_ram_type;
wire  [12:0] reg2dp_datain_width;
wire  [12:0] reg2dp_dataout_channel;
wire         reg2dp_dataout_ram_type;
wire   [4:0] reg2dp_deconv_x_stride;
wire   [4:0] reg2dp_deconv_y_stride;
wire   [1:0] reg2dp_in_precision;
wire         reg2dp_op_en;
wire         reg2dp_perf_en;
wire   [1:0] reg2dp_rubik_mode;
wire   [4:0] rf_rd_addr;
wire  [11:0] rf_rd_cmd_pd;
wire         rf_rd_cmd_rdy;
wire         rf_rd_cmd_vld;
wire         rf_rd_done;
wire  [11:0] rf_rd_mask;
wire         rf_rd_rdy;
wire         rf_rd_vld;
wire   [4:0] rf_wr_addr;
wire  [10:0] rf_wr_cmd_pd;
wire         rf_wr_cmd_rdy;
wire         rf_wr_cmd_vld;
wire [511:0] rf_wr_data;
wire         rf_wr_done;
wire         rf_wr_rdy;
wire         rf_wr_vld;
wire   [2:0] slcg_op_en;
wire [514:0] wr_req_pd;
wire         wr_req_rdy;
wire         wr_req_type;
wire         wr_req_vld;
wire         wr_rsp_complete;


#ifdef  NVDLA_RUBIK_RESHAPE_DISABLE
assign  reg2dp_rubik_mode[1:0] = 2'b0; 
#else
wire  [1:0]  cfg_reg2dp_rubik_mode;
assign  reg2dp_rubik_mode[1:0] = cfg_reg2dp_rubik_mode[1:0]; 
#endif

#ifdef  NVDLA_FEATURE_DATA_TYPE_INT8
assign  reg2dp_in_precision[1:0] = 2'b0;
#else
wire  [1:0]  cfg_reg2dp_in_precision;
assign  reg2dp_in_precision[1:0] = cfg_reg2dp_in_precision[1:0]; 
#endif



NV_NVDLA_RUBIK_regfile u_regfile (
   .nvdla_core_clk                (nvdla_core_clk)                   //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                  //|< i
  ,.csb2rbk_req_pd                (csb2rbk_req_pd[62:0])             //|< i
  ,.csb2rbk_req_pvld              (csb2rbk_req_pvld)                 //|< i
  ,.dp2reg_d0_rd_stall_cnt        (dp2reg_d0_rd_stall_cnt[31:0])     //|< w
  ,.dp2reg_d0_wr_stall_cnt        (dp2reg_d0_wr_stall_cnt[31:0])     //|< w
  ,.dp2reg_d1_rd_stall_cnt        (dp2reg_d1_rd_stall_cnt[31:0])     //|< w
  ,.dp2reg_d1_wr_stall_cnt        (dp2reg_d1_wr_stall_cnt[31:0])     //|< w
  ,.dp2reg_done                   (dp2reg_done)                      //|< w
  ,.csb2rbk_req_prdy              (csb2rbk_req_prdy)                 //|> o
  ,.dp2reg_consumer               (dp2reg_consumer)                  //|> w
  ,.rbk2csb_resp_pd               (rbk2csb_resp_pd[33:0])            //|> o
  ,.rbk2csb_resp_valid            (rbk2csb_resp_valid)               //|> o
  ,.reg2dp_contract_stride_0      (reg2dp_contract_stride_0[26:0])   //|> w
  ,.reg2dp_contract_stride_1      (reg2dp_contract_stride_1[26:0])   //|> w
  ,.reg2dp_dain_addr_high         (reg2dp_dain_addr_high[31:0])      //|> w
  ,.reg2dp_dain_addr_low          (reg2dp_dain_addr_low[26:0])       //|> w
  ,.reg2dp_dain_line_stride       (reg2dp_dain_line_stride[26:0])    //|> w
  ,.reg2dp_dain_planar_stride     (reg2dp_dain_planar_stride[26:0])  //|> w
  ,.reg2dp_dain_surf_stride       (reg2dp_dain_surf_stride[26:0])    //|> w
  ,.reg2dp_daout_addr_high        (reg2dp_daout_addr_high[31:0])     //|> w
  ,.reg2dp_daout_addr_low         (reg2dp_daout_addr_low[26:0])      //|> w
  ,.reg2dp_daout_line_stride      (reg2dp_daout_line_stride[26:0])   //|> w
  ,.reg2dp_daout_planar_stride    (reg2dp_daout_planar_stride[26:0]) //|> w
  ,.reg2dp_daout_surf_stride      (reg2dp_daout_surf_stride[26:0])   //|> w
  ,.reg2dp_datain_channel         (reg2dp_datain_channel[12:0])      //|> w
  ,.reg2dp_datain_height          (reg2dp_datain_height[12:0])       //|> w
  ,.reg2dp_datain_ram_type        (reg2dp_datain_ram_type)           //|> w
  ,.reg2dp_datain_width           (reg2dp_datain_width[12:0])        //|> w
  ,.reg2dp_dataout_channel        (reg2dp_dataout_channel[12:0])     //|> w
  ,.reg2dp_dataout_ram_type       (reg2dp_dataout_ram_type)          //|> w
  ,.reg2dp_deconv_x_stride        (reg2dp_deconv_x_stride[4:0])      //|> w
  ,.reg2dp_deconv_y_stride        (reg2dp_deconv_y_stride[4:0])      //|> w
#ifndef  NVDLA_FEATURE_DATA_TYPE_INT8
  ,.reg2dp_in_precision           (cfg_reg2dp_in_precision[1:0])     //|> w
#endif
  ,.reg2dp_op_en                  (reg2dp_op_en)                     //|> w
  ,.reg2dp_perf_en                (reg2dp_perf_en)                   //|> w
#ifndef  NVDLA_RUBIK_RESHAPE_DISABLE
  ,.reg2dp_rubik_mode             (cfg_reg2dp_rubik_mode[1:0])       //|> w
#endif
  ,.slcg_op_en                    (slcg_op_en[2:0])                  //|> w
  );


NV_NVDLA_RUBIK_intr u_intr (
   .nvdla_core_clk                (nvdla_core_clk)                   //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                  //|< i
  ,.dp2reg_consumer               (dp2reg_consumer)                  //|< w
  ,.dp2reg_done                   (dp2reg_done)                      //|< w
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])              //|< i
  ,.reg2dp_op_en                  (reg2dp_op_en)                     //|< w
  ,.wr_rsp_complete               (wr_rsp_complete)                  //|< w
  ,.rubik2glb_done_intr_pd        (rubik2glb_done_intr_pd[1:0])      //|> o
  );

NV_NVDLA_RUBIK_dma u_dma (
   .nvdla_core_clk                (nvdla_core_clk)                   //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                  //|< i
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,.cvif2rbk_rd_rsp_pd            (cvif2rbk_rd_rsp_pd[513:0])        //|< i
  ,.cvif2rbk_rd_rsp_valid         (cvif2rbk_rd_rsp_valid)            //|< i
  ,.cvif2rbk_wr_rsp_complete      (cvif2rbk_wr_rsp_complete)         //|< i
#endif
  ,.mcif2rbk_rd_rsp_pd            (mcif2rbk_rd_rsp_pd[513:0])        //|< i
  ,.mcif2rbk_rd_rsp_valid         (mcif2rbk_rd_rsp_valid)            //|< i
  ,.mcif2rbk_wr_rsp_complete      (mcif2rbk_wr_rsp_complete)         //|< i
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,.rbk2cvif_rd_req_ready         (rbk2cvif_rd_req_ready)            //|< i
  ,.rbk2cvif_wr_req_ready         (rbk2cvif_wr_req_ready)            //|< i
#endif
  ,.rbk2mcif_rd_req_ready         (rbk2mcif_rd_req_ready)            //|< i
  ,.rbk2mcif_wr_req_ready         (rbk2mcif_wr_req_ready)            //|< i
  ,.rd_cdt_lat_fifo_pop           (rd_cdt_lat_fifo_pop)              //|< w
  ,.rd_req_pd                     (rd_req_pd[78:0])                  //|< w
  ,.rd_req_type                   (rd_req_type)                      //|< w
  ,.rd_req_vld                    (rd_req_vld)                       //|< w
  ,.rd_rsp_rdy                    (rd_rsp_rdy)                       //|< w
  ,.wr_req_pd                     (wr_req_pd[514:0])                 //|< w
  ,.wr_req_type                   (wr_req_type)                      //|< w
  ,.wr_req_vld                    (wr_req_vld)                       //|< w
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,.cvif2rbk_rd_rsp_ready         (cvif2rbk_rd_rsp_ready)            //|> o
#endif
  ,.mcif2rbk_rd_rsp_ready         (mcif2rbk_rd_rsp_ready)            //|> o
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,.rbk2cvif_rd_cdt_lat_fifo_pop  (rbk2cvif_rd_cdt_lat_fifo_pop)     //|> o
  ,.rbk2cvif_rd_req_pd            (rbk2cvif_rd_req_pd[78:0])         //|> o
  ,.rbk2cvif_rd_req_valid         (rbk2cvif_rd_req_valid)            //|> o
  ,.rbk2cvif_wr_req_pd            (rbk2cvif_wr_req_pd[514:0])        //|> o
  ,.rbk2cvif_wr_req_valid         (rbk2cvif_wr_req_valid)            //|> o
#endif
  ,.rbk2mcif_rd_cdt_lat_fifo_pop  (rbk2mcif_rd_cdt_lat_fifo_pop)     //|> o
  ,.rbk2mcif_rd_req_pd            (rbk2mcif_rd_req_pd[78:0])         //|> o
  ,.rbk2mcif_rd_req_valid         (rbk2mcif_rd_req_valid)            //|> o
  ,.rbk2mcif_wr_req_pd            (rbk2mcif_wr_req_pd[514:0])        //|> o
  ,.rbk2mcif_wr_req_valid         (rbk2mcif_wr_req_valid)            //|> o
  ,.rd_req_rdy                    (rd_req_rdy)                       //|> w
  ,.rd_rsp_pd                     (rd_rsp_pd[513:0])                 //|> w
  ,.rd_rsp_vld                    (rd_rsp_vld)                       //|> w
  ,.wr_req_rdy                    (wr_req_rdy)                       //|> w
  ,.wr_rsp_complete               (wr_rsp_complete)                  //|> w
  );

NV_NVDLA_RUBIK_seq_gen u_seq_gen (
   .nvdla_core_clk                (nvdla_op_gated_clk_0)             //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)                  //|< i
  ,.dp2reg_consumer               (dp2reg_consumer)                  //|< w
  ,.reg2dp_perf_en                (reg2dp_perf_en)                   //|< w
  ,.dp2reg_d0_rd_stall_cnt        (dp2reg_d0_rd_stall_cnt[31:0])     //|> w
  ,.dp2reg_d1_rd_stall_cnt        (dp2reg_d1_rd_stall_cnt[31:0])     //|> w
  ,.reg2dp_op_en                  (reg2dp_op_en)                     //|< w
  ,.reg2dp_datain_ram_type        (reg2dp_datain_ram_type)           //|< w
  ,.reg2dp_rubik_mode             (reg2dp_rubik_mode[1:0])           //|< w
  ,.reg2dp_in_precision           (reg2dp_in_precision[1:0])         //|< w
  ,.reg2dp_dain_addr_high         (reg2dp_dain_addr_high[31:0])      //|< w
  ,.reg2dp_dain_addr_low          (reg2dp_dain_addr_low[26:0])       //|< w
  ,.reg2dp_datain_channel         (reg2dp_datain_channel[12:0])      //|< w
  ,.reg2dp_datain_height          (reg2dp_datain_height[12:0])       //|< w
  ,.reg2dp_datain_width           (reg2dp_datain_width[12:0])        //|< w
  ,.reg2dp_deconv_x_stride        (reg2dp_deconv_x_stride[4:0])      //|< w
  ,.reg2dp_deconv_y_stride        (reg2dp_deconv_y_stride[4:0])      //|< w
  ,.reg2dp_dain_line_stride       (reg2dp_dain_line_stride[26:0])    //|< w
  ,.reg2dp_dain_planar_stride     (reg2dp_dain_planar_stride[26:0])  //|< w
  ,.reg2dp_dain_surf_stride       (reg2dp_dain_surf_stride[26:0])    //|< w
  ,.reg2dp_contract_stride_0      (reg2dp_contract_stride_0[26:0])   //|< w
  ,.reg2dp_contract_stride_1      (reg2dp_contract_stride_1[26:0])   //|< w
  ,.reg2dp_daout_addr_high        (reg2dp_daout_addr_high[31:0])     //|< w
  ,.reg2dp_daout_addr_low         (reg2dp_daout_addr_low[26:0])      //|< w
  ,.reg2dp_daout_line_stride      (reg2dp_daout_line_stride[26:0])   //|< w
  ,.reg2dp_daout_planar_stride    (reg2dp_daout_planar_stride[26:0]) //|< w
  ,.reg2dp_daout_surf_stride      (reg2dp_daout_surf_stride[26:0])   //|< w
  ,.reg2dp_dataout_channel        (reg2dp_dataout_channel[12:0])     //|< w
  ,.dp2reg_done                   (dp2reg_done)                      //|< w
  ,.rd_req_type                   (rd_req_type)                      //|> w
  ,.rd_req_vld                    (rd_req_vld)                       //|> w
  ,.rd_req_rdy                    (rd_req_rdy)                       //|< w
  ,.rd_req_pd                     (rd_req_pd[78:0])                  //|> w
  ,.rf_wr_cmd_vld                 (rf_wr_cmd_vld)                    //|> w
  ,.rf_wr_cmd_rdy                 (rf_wr_cmd_rdy)                    //|< w
  ,.rf_wr_cmd_pd                  (rf_wr_cmd_pd[10:0])               //|> w
  ,.rf_rd_cmd_vld                 (rf_rd_cmd_vld)                    //|> w
  ,.rf_rd_cmd_rdy                 (rf_rd_cmd_rdy)                    //|< w
  ,.rf_rd_cmd_pd                  (rf_rd_cmd_pd[11:0])               //|> w
  ,.dma_wr_cmd_vld                (dma_wr_cmd_vld)                   //|> w
  ,.dma_wr_cmd_rdy                (dma_wr_cmd_rdy)                   //|< w
  ,.dma_wr_cmd_pd                 (dma_wr_cmd_pd[77:0])              //|> w
  ,.contract_lit_dx               (contract_lit_dx)                  //|> w
  ,.inwidth                       (inwidth[13:0])                    //|> w
  );

NV_NVDLA_RUBIK_wr_req u_wr_req (
   .nvdla_core_clk                (nvdla_op_gated_clk_0)             //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)                  //|< i
  ,.dp2reg_consumer               (dp2reg_consumer)                  //|< w
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])              //|< i
  ,.reg2dp_dataout_ram_type       (reg2dp_dataout_ram_type)          //|< w
  ,.reg2dp_perf_en                (reg2dp_perf_en)                   //|< w
  ,.dp2reg_d0_wr_stall_cnt        (dp2reg_d0_wr_stall_cnt[31:0])     //|> w
  ,.dp2reg_d1_wr_stall_cnt        (dp2reg_d1_wr_stall_cnt[31:0])     //|> w
  ,.wr_req_type                   (wr_req_type)                      //|> w
  ,.wr_req_vld                    (wr_req_vld)                       //|> w
  ,.wr_req_pd                     (wr_req_pd[514:0])                 //|> w
  ,.wr_req_rdy                    (wr_req_rdy)                       //|< w
  ,.dma_wr_cmd_vld                (dma_wr_cmd_vld)                   //|< w
  ,.dma_wr_cmd_pd                 (dma_wr_cmd_pd[77:0])              //|< w
  ,.dma_wr_cmd_rdy                (dma_wr_cmd_rdy)                   //|> w
  ,.dma_wr_data_vld               (dma_wr_data_vld)                  //|< w
  ,.dma_wr_data_pd                (dma_wr_data_pd[513:0])            //|< w
  ,.dma_wr_data_rdy               (dma_wr_data_rdy)                  //|> w
  ,.dp2reg_done                   (dp2reg_done)                      //|> w
  );

NV_NVDLA_RUBIK_rf_ctrl u_rf_ctrl (
   .nvdla_core_clk                (nvdla_op_gated_clk_0)             //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)                  //|< i
  ,.contract_lit_dx               (contract_lit_dx)                  //|< w
  ,.inwidth                       (inwidth[13:0])                    //|< w
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])              //|< i
  ,.rf_wr_cmd_vld                 (rf_wr_cmd_vld)                    //|< w
  ,.rf_wr_cmd_pd                  (rf_wr_cmd_pd[10:0])               //|< w
  ,.rf_wr_cmd_rdy                 (rf_wr_cmd_rdy)                    //|> w
  ,.rf_rd_cmd_vld                 (rf_rd_cmd_vld)                    //|< w
  ,.rf_rd_cmd_pd                  (rf_rd_cmd_pd[11:0])               //|< w
  ,.rf_rd_cmd_rdy                 (rf_rd_cmd_rdy)                    //|> w
  ,.data_fifo_vld                 (data_fifo_vld)                    //|< w
  ,.data_fifo_pd                  (data_fifo_pd[511:0])              //|< w
  ,.data_fifo_rdy                 (data_fifo_rdy)                    //|> w
  ,.rf_wr_vld                     (rf_wr_vld)                        //|> w
  ,.rf_wr_done                    (rf_wr_done)                       //|> w
  ,.rf_wr_addr                    (rf_wr_addr[4:0])                  //|> w
  ,.rf_wr_data                    (rf_wr_data[511:0])                //|> w
  ,.rf_wr_rdy                     (rf_wr_rdy)                        //|< w
  ,.rf_rd_vld                     (rf_rd_vld)                        //|> w
  ,.rf_rd_done                    (rf_rd_done)                       //|> w
  ,.rf_rd_mask                    (rf_rd_mask[11:0])                 //|> w
  ,.rf_rd_addr                    (rf_rd_addr[4:0])                  //|> w
  ,.rf_rd_rdy                     (rf_rd_rdy)                        //|< w
  ,.reg2dp_rubik_mode             (reg2dp_rubik_mode[1:0])           //|< w
  ,.reg2dp_in_precision           (reg2dp_in_precision[1:0])         //|< w
  );

NV_NVDLA_RUBIK_dr2drc u_dr2drc (
   .nvdla_core_clk                (nvdla_op_gated_clk_1)             //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)                  //|< i
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])              //|< i
  ,.rd_rsp_vld                    (rd_rsp_vld)                       //|< w
  ,.rd_rsp_pd                     (rd_rsp_pd[513:0])                 //|< w
  ,.rd_rsp_rdy                    (rd_rsp_rdy)                       //|> w
  ,.rd_cdt_lat_fifo_pop           (rd_cdt_lat_fifo_pop)              //|> w
  ,.data_fifo_vld                 (data_fifo_vld)                    //|> w
  ,.data_fifo_pd                  (data_fifo_pd[511:0])              //|> w
  ,.data_fifo_rdy                 (data_fifo_rdy)                    //|< w
  );

NV_NVDLA_RUBIK_rf_core u_rf_core (
   .nvdla_core_clk                (nvdla_op_gated_clk_2)             //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)                  //|< i
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])              //|< i
  ,.rf_wr_vld                     (rf_wr_vld)                        //|< w
  ,.rf_wr_done                    (rf_wr_done)                       //|< w
  ,.rf_wr_addr                    (rf_wr_addr[4:0])                  //|< w
  ,.rf_wr_data                    (rf_wr_data[511:0])                //|< w
  ,.rf_wr_rdy                     (rf_wr_rdy)                        //|> w
  ,.rf_rd_vld                     (rf_rd_vld)                        //|< w
  ,.rf_rd_done                    (rf_rd_done)                       //|< w
  ,.rf_rd_addr                    (rf_rd_addr[4:0])                  //|< w
  ,.rf_rd_mask                    (rf_rd_mask[11:0])                 //|< w
  ,.rf_rd_rdy                     (rf_rd_rdy)                        //|> w
  ,.dma_wr_data_vld               (dma_wr_data_vld)                  //|> w
  ,.dma_wr_data_pd                (dma_wr_data_pd[513:0])            //|> w
  ,.dma_wr_data_rdy               (dma_wr_data_rdy)                  //|< w
  ,.reg2dp_rubik_mode             (reg2dp_rubik_mode[1:0])           //|< w
  ,.reg2dp_in_precision           (reg2dp_in_precision[1:0])         //|< w
  );

//Insert SLCG groups
NV_NVDLA_RUBIK_slcg u_slcg_op_0 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)              //|< i
  ,.enable                        (slcg_op_en[0])                    //|< w
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)           //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                   //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                  //|< i
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)    //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_0)             //|> w
  );

NV_NVDLA_RUBIK_slcg u_slcg_op_1 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)              //|< i
  ,.enable                        (slcg_op_en[1])                    //|< w
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)           //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                   //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                  //|< i
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)    //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_1)             //|> w
  );

NV_NVDLA_RUBIK_slcg u_slcg_op_2 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)              //|< i
  ,.enable                        (slcg_op_en[2])                    //|< w
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)           //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                   //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                  //|< i
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)    //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_2)             //|> w
  );


/////////////////obs bus///////////////////
//assign   obs_bus_rubik_rd_req_vld     = rd_req_vld     ;  
//assign   obs_bus_rubik_rd_req_rdy     = rd_req_rdy     ;  
//assign   obs_bus_rubik_rd_req_done    = rd_req_done    ;  
//assign   obs_bus_rubik_dma_wr_cmd_vld = dma_wr_cmd_vld ;  
//assign   obs_bus_rubik_dma_wr_cmd_rdy = dma_wr_cmd_rdy ;  
//assign   obs_bus_rubik_rf_wcmd_vld    = rf_wr_cmd_vld  ;   
//assign   obs_bus_rubik_rf_wcmd_rdy    = rf_wr_cmd_rdy  ;  
//assign   obs_bus_rubik_rf_wcmd_pd     = rf_wr_cmd_pd   ;  
//assign   obs_bus_rubik_rf_rcmd_vld    = rf_rd_cmd_vld  ;   
//assign   obs_bus_rubik_rf_rcmd_rdy    = rf_rd_cmd_rdy  ;  
//assign   obs_bus_rubik_rf_rcmd_pd     = rf_rd_cmd_pd   ; 
//
//assign   obs_bus_rubik_rf_wr_vld       = rf_wr_vld;       
//assign   obs_bus_rubik_rf_wr_rdy       = rf_wr_rdy;       
//assign   obs_bus_rubik_rf_wr_done      = rf_wr_done;        
//assign   obs_bus_rubik_rf_wr_addr      = rf_wr_addr;       
//assign   obs_bus_rubik_rf_rd_vld       = rf_rd_vld; 
//assign   obs_bus_rubik_rf_rd_rdy       = rf_rd_rdy;        
//assign   obs_bus_rubik_rf_rd_done      = rf_rd_done;        
//assign   obs_bus_rubik_rf_rd_addr      = rf_rd_addr;      
//assign   obs_bus_rubik_rf_rd_mask      = rf_rd_mask;        
//assign   obs_bus_rubik_dma_wr_data_vld = dma_wr_data_vld;  
//assign   obs_bus_rubik_dma_wr_data_rdy = dma_wr_data_rdy; 
//
//assign   obs_bus_rubik_wr_req_vld      = wr_req_vld;                
//assign   obs_bus_rubik_wr_req_rdy      = wr_req_rdy; 
//assign   obs_bus_rubik_wr_req_done     = dp2reg_done;  
//assign   obs_bus_rubik_wr_rsp_complete = wr_rsp_complete;     

endmodule // NV_NVDLA_rubik


