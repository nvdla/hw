// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cdp.v

module NV_NVDLA_cdp (
   dla_clk_ovr_on_sync           //|< i
  ,global_clk_ovr_on_sync        //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,nvdla_core_clk                //|< i
  ,nvdla_core_rstn               //|< i
  ,cdp2csb_resp_valid            //|> o
  ,cdp2csb_resp_pd               //|> o
  ,cdp2cvif_rd_cdt_lat_fifo_pop  //|> o
  ,cdp2cvif_rd_req_valid         //|> o
  ,cdp2cvif_rd_req_ready         //|< i
  ,cdp2cvif_rd_req_pd            //|> o
  ,cdp2cvif_wr_req_valid         //|> o
  ,cdp2cvif_wr_req_ready         //|< i
  ,cdp2cvif_wr_req_pd            //|> o
  ,cdp2glb_done_intr_pd          //|> o
  ,cdp2mcif_rd_cdt_lat_fifo_pop  //|> o
  ,cdp2mcif_rd_req_valid         //|> o
  ,cdp2mcif_rd_req_ready         //|< i
  ,cdp2mcif_rd_req_pd            //|> o
  ,cdp2mcif_wr_req_valid         //|> o
  ,cdp2mcif_wr_req_ready         //|< i
  ,cdp2mcif_wr_req_pd            //|> o
  ,cdp_rdma2csb_resp_valid       //|> o
  ,cdp_rdma2csb_resp_pd          //|> o
  ,csb2cdp_rdma_req_pvld         //|< i
  ,csb2cdp_rdma_req_prdy         //|> o
  ,csb2cdp_rdma_req_pd           //|< i
  ,csb2cdp_req_pvld              //|< i
  ,csb2cdp_req_prdy              //|> o
  ,csb2cdp_req_pd                //|< i
  ,cvif2cdp_rd_rsp_valid         //|< i
  ,cvif2cdp_rd_rsp_ready         //|> o
  ,cvif2cdp_rd_rsp_pd            //|< i
  ,cvif2cdp_wr_rsp_complete      //|< i
  ,mcif2cdp_rd_rsp_valid         //|< i
  ,mcif2cdp_rd_rsp_ready         //|> o
  ,mcif2cdp_rd_rsp_pd            //|< i
  ,mcif2cdp_wr_rsp_complete      //|< i
  ,pwrbus_ram_pd                 //|< i
  );
input   dla_clk_ovr_on_sync;
input   global_clk_ovr_on_sync;
input   tmc2slcg_disable_clock_gating;

 //
 // NV_NVDLA_cdp_ports.v
 //
 input  nvdla_core_clk;   /* cdp2csb_resp, cdp2cvif_rd_cdt, cdp2cvif_rd_req, cdp2cvif_wr_req, cdp2glb_done_intr, cdp2mcif_rd_cdt, cdp2mcif_rd_req, cdp2mcif_wr_req, cdp_rdma2csb_resp, csb2cdp_rdma_req, csb2cdp_req, cvif2cdp_rd_rsp, cvif2cdp_wr_rsp, mcif2cdp_rd_rsp, mcif2cdp_wr_rsp */
 input  nvdla_core_rstn;  /* cdp2csb_resp, cdp2cvif_rd_cdt, cdp2cvif_rd_req, cdp2cvif_wr_req, cdp2glb_done_intr, cdp2mcif_rd_cdt, cdp2mcif_rd_req, cdp2mcif_wr_req, cdp_rdma2csb_resp, csb2cdp_rdma_req, csb2cdp_req, cvif2cdp_rd_rsp, cvif2cdp_wr_rsp, mcif2cdp_rd_rsp, mcif2cdp_wr_rsp */

 output        cdp2csb_resp_valid;  /* data valid */
 output [33:0] cdp2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

 output  cdp2cvif_rd_cdt_lat_fifo_pop;

 output        cdp2cvif_rd_req_valid;  /* data valid */
 input         cdp2cvif_rd_req_ready;  /* data return handshake */
 output [78:0] cdp2cvif_rd_req_pd;

 output         cdp2cvif_wr_req_valid;  /* data valid */
 input          cdp2cvif_wr_req_ready;  /* data return handshake */
 output [514:0] cdp2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

 output [1:0] cdp2glb_done_intr_pd;

 output  cdp2mcif_rd_cdt_lat_fifo_pop;

 output        cdp2mcif_rd_req_valid;  /* data valid */
 input         cdp2mcif_rd_req_ready;  /* data return handshake */
 output [78:0] cdp2mcif_rd_req_pd;

 output         cdp2mcif_wr_req_valid;  /* data valid */
 input          cdp2mcif_wr_req_ready;  /* data return handshake */
 output [514:0] cdp2mcif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

 output        cdp_rdma2csb_resp_valid;  /* data valid */
 output [33:0] cdp_rdma2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

 input         csb2cdp_rdma_req_pvld;  /* data valid */
 output        csb2cdp_rdma_req_prdy;  /* data return handshake */
 input  [62:0] csb2cdp_rdma_req_pd;

 input         csb2cdp_req_pvld;  /* data valid */
 output        csb2cdp_req_prdy;  /* data return handshake */
 input  [62:0] csb2cdp_req_pd;

 input          cvif2cdp_rd_rsp_valid;  /* data valid */
 output         cvif2cdp_rd_rsp_ready;  /* data return handshake */
 input  [513:0] cvif2cdp_rd_rsp_pd;

 input  cvif2cdp_wr_rsp_complete;

 input          mcif2cdp_rd_rsp_valid;  /* data valid */
 output         mcif2cdp_rd_rsp_ready;  /* data return handshake */
 input  [513:0] mcif2cdp_rd_rsp_pd;

 input  mcif2cdp_wr_rsp_complete;

 input [31:0] pwrbus_ram_pd;

 wire [78:0] cdp_dp2wdma_pd;
 wire        cdp_dp2wdma_ready;
 wire        cdp_dp2wdma_valid;
 wire [86:0] cdp_rdma2dp_pd;
 wire        cdp_rdma2dp_ready;
 wire        cdp_rdma2dp_valid;
 wire [31:0] dp2reg_d0_out_saturation;
 wire [31:0] dp2reg_d0_perf_lut_hybrid;
 wire [31:0] dp2reg_d0_perf_lut_le_hit;
 wire [31:0] dp2reg_d0_perf_lut_lo_hit;
 wire [31:0] dp2reg_d0_perf_lut_oflow;
 wire [31:0] dp2reg_d0_perf_lut_uflow;
 wire [31:0] dp2reg_d0_perf_write_stall;
 wire [31:0] dp2reg_d1_out_saturation;
 wire [31:0] dp2reg_d1_perf_lut_hybrid;
 wire [31:0] dp2reg_d1_perf_lut_le_hit;
 wire [31:0] dp2reg_d1_perf_lut_lo_hit;
 wire [31:0] dp2reg_d1_perf_lut_oflow;
 wire [31:0] dp2reg_d1_perf_lut_uflow;
 wire [31:0] dp2reg_d1_perf_write_stall;
 wire        dp2reg_done;
 wire [31:0] dp2reg_inf_input_num;
 wire [15:0] dp2reg_lut_data;
 wire [31:0] dp2reg_nan_input_num;
 wire [31:0] dp2reg_nan_output_num;
 wire        fp16_en;
 wire        mon_op_en_neg;
 wire        mon_op_en_pos;
 wire [86:0] nan_preproc_pd;
 wire        nan_preproc_prdy;
 wire        nan_preproc_pvld;
 wire        nvdla_op_gated_clk_core;
 wire        nvdla_op_gated_clk_fp16;
 wire        nvdla_op_gated_clk_int;
 wire        nvdla_op_gated_clk_wdma;
 wire [31:0] reg2dp_cya;
 wire [15:0] reg2dp_datin_offset;
 wire [15:0] reg2dp_datin_scale;
 wire  [4:0] reg2dp_datin_shifter;
 wire [31:0] reg2dp_datout_offset;
 wire [15:0] reg2dp_datout_scale;
 wire  [5:0] reg2dp_datout_shifter;
 wire        reg2dp_dma_en;
 wire [31:0] reg2dp_dst_base_addr_high;
 wire [26:0] reg2dp_dst_base_addr_low;
 wire [26:0] reg2dp_dst_line_stride;
 wire        reg2dp_dst_ram_type;
 wire [26:0] reg2dp_dst_surface_stride;
 wire  [1:0] reg2dp_input_data_type;
 wire        reg2dp_interrupt_ptr;
 wire        reg2dp_lut_access_type;
 wire  [9:0] reg2dp_lut_addr;
 wire [15:0] reg2dp_lut_data;
 wire        reg2dp_lut_data_trigger;
 wire        reg2dp_lut_en;
 wire        reg2dp_lut_hybrid_priority;
 wire  [5:0] reg2dp_lut_le_end_high;
 wire [31:0] reg2dp_lut_le_end_low;
 wire        reg2dp_lut_le_function;
 wire  [7:0] reg2dp_lut_le_index_offset;
 wire  [7:0] reg2dp_lut_le_index_select;
 wire [15:0] reg2dp_lut_le_slope_oflow_scale;
 wire  [4:0] reg2dp_lut_le_slope_oflow_shift;
 wire [15:0] reg2dp_lut_le_slope_uflow_scale;
 wire  [4:0] reg2dp_lut_le_slope_uflow_shift;
 wire  [5:0] reg2dp_lut_le_start_high;
 wire [31:0] reg2dp_lut_le_start_low;
 wire  [5:0] reg2dp_lut_lo_end_high;
 wire [31:0] reg2dp_lut_lo_end_low;
 wire  [7:0] reg2dp_lut_lo_index_select;
 wire [15:0] reg2dp_lut_lo_slope_oflow_scale;
 wire  [4:0] reg2dp_lut_lo_slope_oflow_shift;
 wire [15:0] reg2dp_lut_lo_slope_uflow_scale;
 wire  [4:0] reg2dp_lut_lo_slope_uflow_shift;
 wire  [5:0] reg2dp_lut_lo_start_high;
 wire [31:0] reg2dp_lut_lo_start_low;
 wire        reg2dp_lut_oflow_priority;
 wire        reg2dp_lut_table_id;
 wire        reg2dp_lut_uflow_priority;
 wire        reg2dp_mul_bypass;
 wire        reg2dp_nan_to_zero;
 wire  [1:0] reg2dp_normalz_len;
 wire        reg2dp_op_en;
 wire        reg2dp_sqsum_bypass;
 wire  [3:0] slcg_op_en;
 reg  [31:0] mon_gap_between_layers;
 reg         mon_layer_end_flg;
 reg         mon_op_en_dly;
 reg   [1:0] mon_reg2dp_input_data_type;
 reg         mon_reg2dp_lut_le_function;
 reg         mon_reg2dp_mul_bypass;
 reg         mon_reg2dp_nan_to_zero;
 reg   [1:0] mon_reg2dp_normalz_len;
 reg         mon_reg2dp_sqsum_bypass;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
 assign fp16_en  = (reg2dp_input_data_type[1:0] == 2'h2 );
 //=======================================
 //RDMA
 //---------------------------------------
 NV_NVDLA_CDP_rdma u_rdma (
    .nvdla_core_clk                  (nvdla_core_clk)                        //|< i
   ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
   ,.cdp2cvif_rd_cdt_lat_fifo_pop    (cdp2cvif_rd_cdt_lat_fifo_pop)          //|> o
   ,.cdp2cvif_rd_req_valid           (cdp2cvif_rd_req_valid)                 //|> o
   ,.cdp2cvif_rd_req_ready           (cdp2cvif_rd_req_ready)                 //|< i
   ,.cdp2cvif_rd_req_pd              (cdp2cvif_rd_req_pd[78:0])              //|> o
   ,.cdp2mcif_rd_cdt_lat_fifo_pop    (cdp2mcif_rd_cdt_lat_fifo_pop)          //|> o
   ,.cdp2mcif_rd_req_valid           (cdp2mcif_rd_req_valid)                 //|> o
   ,.cdp2mcif_rd_req_ready           (cdp2mcif_rd_req_ready)                 //|< i
   ,.cdp2mcif_rd_req_pd              (cdp2mcif_rd_req_pd[78:0])              //|> o
   ,.cdp_rdma2csb_resp_valid         (cdp_rdma2csb_resp_valid)               //|> o
   ,.cdp_rdma2csb_resp_pd            (cdp_rdma2csb_resp_pd[33:0])            //|> o
   ,.cdp_rdma2dp_valid               (cdp_rdma2dp_valid)                     //|> w
   ,.cdp_rdma2dp_ready               (cdp_rdma2dp_ready)                     //|< w
   ,.cdp_rdma2dp_pd                  (cdp_rdma2dp_pd[86:0])                  //|> w
   ,.csb2cdp_rdma_req_pvld           (csb2cdp_rdma_req_pvld)                 //|< i
   ,.csb2cdp_rdma_req_prdy           (csb2cdp_rdma_req_prdy)                 //|> o
   ,.csb2cdp_rdma_req_pd             (csb2cdp_rdma_req_pd[62:0])             //|< i
   ,.cvif2cdp_rd_rsp_valid           (cvif2cdp_rd_rsp_valid)                 //|< i
   ,.cvif2cdp_rd_rsp_ready           (cvif2cdp_rd_rsp_ready)                 //|> o
   ,.cvif2cdp_rd_rsp_pd              (cvif2cdp_rd_rsp_pd[513:0])             //|< i
   ,.mcif2cdp_rd_rsp_valid           (mcif2cdp_rd_rsp_valid)                 //|< i
   ,.mcif2cdp_rd_rsp_ready           (mcif2cdp_rd_rsp_ready)                 //|> o
   ,.mcif2cdp_rd_rsp_pd              (mcif2cdp_rd_rsp_pd[513:0])             //|< i
   ,.pwrbus_ram_pd                   (pwrbus_ram_pd[31:0])                   //|< i
   ,.dla_clk_ovr_on_sync             (dla_clk_ovr_on_sync)                   //|< i
   ,.global_clk_ovr_on_sync          (global_clk_ovr_on_sync)                //|< i
   ,.tmc2slcg_disable_clock_gating   (tmc2slcg_disable_clock_gating)         //|< i
   );
 //&Connect cdp_rdma2dp_ready     (cdp_rdma2dp_ready & reg2dp_op_en);

 //=======================================
 //        SLCG gen unit
 //---------------------------------------
 NV_NVDLA_CDP_slcg u_slcg_core (
    .dla_clk_ovr_on_sync             (dla_clk_ovr_on_sync)                   //|< i
   ,.global_clk_ovr_on_sync          (global_clk_ovr_on_sync)                //|< i
   ,.nvdla_core_clk                  (nvdla_core_clk)                        //|< i
   ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
   ,.slcg_en_src                     (slcg_op_en[0])                         //|< w
   ,.tmc2slcg_disable_clock_gating   (tmc2slcg_disable_clock_gating)         //|< i
   ,.nvdla_core_gated_clk            (nvdla_op_gated_clk_core)               //|> w
   );
 
 NV_NVDLA_CDP_slcg u_slcg_wdma (
    .dla_clk_ovr_on_sync             (dla_clk_ovr_on_sync)                   //|< i
   ,.global_clk_ovr_on_sync          (global_clk_ovr_on_sync)                //|< i
   ,.nvdla_core_clk                  (nvdla_core_clk)                        //|< i
   ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
   ,.slcg_en_src                     (slcg_op_en[1])                         //|< w
   ,.tmc2slcg_disable_clock_gating   (tmc2slcg_disable_clock_gating)         //|< i
   ,.nvdla_core_gated_clk            (nvdla_op_gated_clk_wdma)               //|> w
   );

 NV_NVDLA_CDP_slcg u_slcg_fp16 (
    .dla_clk_ovr_on_sync             (dla_clk_ovr_on_sync)                   //|< i
   ,.global_clk_ovr_on_sync          (global_clk_ovr_on_sync)                //|< i
   ,.nvdla_core_clk                  (nvdla_core_clk)                        //|< i
   ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
   ,.slcg_en_src                     (slcg_op_en[2] & fp16_en)               //|< ?
   ,.tmc2slcg_disable_clock_gating   (tmc2slcg_disable_clock_gating)         //|< i
   ,.nvdla_core_gated_clk            (nvdla_op_gated_clk_fp16)               //|> w
   );
 
 NV_NVDLA_CDP_slcg u_slcg_int (
    .dla_clk_ovr_on_sync             (dla_clk_ovr_on_sync)                   //|< i
   ,.global_clk_ovr_on_sync          (global_clk_ovr_on_sync)                //|< i
   ,.nvdla_core_clk                  (nvdla_core_clk)                        //|< i
   ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
   ,.slcg_en_src                     (slcg_op_en[3] & (~fp16_en))            //|< ?
   ,.tmc2slcg_disable_clock_gating   (tmc2slcg_disable_clock_gating)         //|< i
   ,.nvdla_core_gated_clk            (nvdla_op_gated_clk_int)                //|> w
   );

 //=======================================
 //NaN preproc
 //---------------------------------------
 NV_NVDLA_CDP_DP_nan u_DP_nan (
    .nvdla_core_clk                  (nvdla_op_gated_clk_core)               //|< w
   ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
   ,.cdp_rdma2dp_pd                  (cdp_rdma2dp_pd[86:0])                  //|< w
   ,.cdp_rdma2dp_valid               (cdp_rdma2dp_valid)                     //|< w
   ,.dp2reg_done                     (dp2reg_done)                           //|< w
   ,.nan_preproc_prdy                (nan_preproc_prdy)                      //|< w
   ,.reg2dp_input_data_type          (reg2dp_input_data_type[1:0])           //|< w
   ,.reg2dp_nan_to_zero              (reg2dp_nan_to_zero)                    //|< w
   ,.reg2dp_op_en                    (reg2dp_op_en)                          //|< w
   ,.cdp_rdma2dp_ready               (cdp_rdma2dp_ready)                     //|> w
   ,.dp2reg_inf_input_num            (dp2reg_inf_input_num[31:0])            //|> w
   ,.dp2reg_nan_input_num            (dp2reg_nan_input_num[31:0])            //|> w
   ,.nan_preproc_pd                  (nan_preproc_pd[86:0])                  //|> w
   ,.nan_preproc_pvld                (nan_preproc_pvld)                      //|> w
   );
 //&Connect cdp_rdma2dp_valid     (cdp_rdma2dp_valid & reg2dp_op_en);
 //=======================================
 //WDMA
 //---------------------------------------
 NV_NVDLA_CDP_wdma u_wdma (
    .nvdla_core_clk                  (nvdla_op_gated_clk_wdma)               //|< w
   ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
   ,.cdp2mcif_wr_req_valid           (cdp2mcif_wr_req_valid)                 //|> o
   ,.cdp2mcif_wr_req_ready           (cdp2mcif_wr_req_ready)                 //|< i
   ,.cdp2mcif_wr_req_pd              (cdp2mcif_wr_req_pd[514:0])             //|> o
   ,.mcif2cdp_wr_rsp_complete        (mcif2cdp_wr_rsp_complete)              //|< i
   ,.cdp2cvif_wr_req_valid           (cdp2cvif_wr_req_valid)                 //|> o
   ,.cdp2cvif_wr_req_ready           (cdp2cvif_wr_req_ready)                 //|< i
   ,.cdp2cvif_wr_req_pd              (cdp2cvif_wr_req_pd[514:0])             //|> o
   ,.cvif2cdp_wr_rsp_complete        (cvif2cdp_wr_rsp_complete)              //|< i
   ,.cdp_dp2wdma_valid               (cdp_dp2wdma_valid)                     //|< w
   ,.cdp_dp2wdma_ready               (cdp_dp2wdma_ready)                     //|> w
   ,.cdp_dp2wdma_pd                  (cdp_dp2wdma_pd[78:0])                  //|< w
   ,.cdp2glb_done_intr_pd            (cdp2glb_done_intr_pd[1:0])             //|> o
   ,.nvdla_core_clk_orig             (nvdla_core_clk)                        //|< i
   ,.pwrbus_ram_pd                   (pwrbus_ram_pd[31:0])                   //|< i
   ,.reg2dp_dma_en                   (reg2dp_dma_en)                         //|< w
   ,.reg2dp_dst_base_addr_high       (reg2dp_dst_base_addr_high[31:0])       //|< w
   ,.reg2dp_dst_base_addr_low        (reg2dp_dst_base_addr_low[26:0])        //|< w
   ,.reg2dp_dst_line_stride          (reg2dp_dst_line_stride[26:0])          //|< w
   ,.reg2dp_dst_ram_type             (reg2dp_dst_ram_type)                   //|< w
   ,.reg2dp_dst_surface_stride       (reg2dp_dst_surface_stride[26:0])       //|< w
   ,.reg2dp_input_data_type          (reg2dp_input_data_type[1:0])           //|< w
   ,.reg2dp_interrupt_ptr            (reg2dp_interrupt_ptr)                  //|< w
   ,.reg2dp_op_en                    (reg2dp_op_en)                          //|< w
   ,.dp2reg_d0_perf_write_stall      (dp2reg_d0_perf_write_stall[31:0])      //|> w
   ,.dp2reg_d1_perf_write_stall      (dp2reg_d1_perf_write_stall[31:0])      //|> w
   ,.dp2reg_done                     (dp2reg_done)                           //|> w
   ,.dp2reg_nan_output_num           (dp2reg_nan_output_num[31:0])           //|> w
   );

 //========================================
 //CDP core instance
 //----------------------------------------
 NV_NVDLA_CDP_dp u_dp (
    .pwrbus_ram_pd                   (pwrbus_ram_pd[31:0])                   //|< i
   ,.dp2reg_done                     (dp2reg_done)                           //|< w
   ,.reg2dp_datin_offset             (reg2dp_datin_offset[15:0])             //|< w
   ,.reg2dp_datin_scale              (reg2dp_datin_scale[15:0])              //|< w
   ,.reg2dp_datin_shifter            (reg2dp_datin_shifter[4:0])             //|< w
   ,.reg2dp_datout_offset            (reg2dp_datout_offset[31:0])            //|< w
   ,.reg2dp_datout_scale             (reg2dp_datout_scale[15:0])             //|< w
   ,.reg2dp_datout_shifter           (reg2dp_datout_shifter[5:0])            //|< w
   ,.reg2dp_input_data_type          (reg2dp_input_data_type[1:0])           //|< w
   ,.reg2dp_lut_access_type          (reg2dp_lut_access_type)                //|< w
   ,.reg2dp_lut_addr                 (reg2dp_lut_addr[9:0])                  //|< w
   ,.reg2dp_lut_data                 (reg2dp_lut_data[15:0])                 //|< w
   ,.reg2dp_lut_data_trigger         (reg2dp_lut_data_trigger)               //|< w
   ,.reg2dp_lut_hybrid_priority      (reg2dp_lut_hybrid_priority)            //|< w
   ,.reg2dp_lut_le_end_high          (reg2dp_lut_le_end_high[5:0])           //|< w
   ,.reg2dp_lut_le_end_low           (reg2dp_lut_le_end_low[31:0])           //|< w
   ,.reg2dp_lut_le_function          (reg2dp_lut_le_function)                //|< w
   ,.reg2dp_lut_le_index_offset      (reg2dp_lut_le_index_offset[7:0])       //|< w
   ,.reg2dp_lut_le_index_select      (reg2dp_lut_le_index_select[7:0])       //|< w
   ,.reg2dp_lut_le_slope_oflow_scale (reg2dp_lut_le_slope_oflow_scale[15:0]) //|< w
   ,.reg2dp_lut_le_slope_oflow_shift (reg2dp_lut_le_slope_oflow_shift[4:0])  //|< w
   ,.reg2dp_lut_le_slope_uflow_scale (reg2dp_lut_le_slope_uflow_scale[15:0]) //|< w
   ,.reg2dp_lut_le_slope_uflow_shift (reg2dp_lut_le_slope_uflow_shift[4:0])  //|< w
   ,.reg2dp_lut_le_start_high        (reg2dp_lut_le_start_high[5:0])         //|< w
   ,.reg2dp_lut_le_start_low         (reg2dp_lut_le_start_low[31:0])         //|< w
   ,.reg2dp_lut_lo_end_high          (reg2dp_lut_lo_end_high[5:0])           //|< w
   ,.reg2dp_lut_lo_end_low           (reg2dp_lut_lo_end_low[31:0])           //|< w
   ,.reg2dp_lut_lo_index_select      (reg2dp_lut_lo_index_select[7:0])       //|< w
   ,.reg2dp_lut_lo_slope_oflow_scale (reg2dp_lut_lo_slope_oflow_scale[15:0]) //|< w
   ,.reg2dp_lut_lo_slope_oflow_shift (reg2dp_lut_lo_slope_oflow_shift[4:0])  //|< w
   ,.reg2dp_lut_lo_slope_uflow_scale (reg2dp_lut_lo_slope_uflow_scale[15:0]) //|< w
   ,.reg2dp_lut_lo_slope_uflow_shift (reg2dp_lut_lo_slope_uflow_shift[4:0])  //|< w
   ,.reg2dp_lut_lo_start_high        (reg2dp_lut_lo_start_high[5:0])         //|< w
   ,.reg2dp_lut_lo_start_low         (reg2dp_lut_lo_start_low[31:0])         //|< w
   ,.reg2dp_lut_oflow_priority       (reg2dp_lut_oflow_priority)             //|< w
   ,.reg2dp_lut_table_id             (reg2dp_lut_table_id)                   //|< w
   ,.reg2dp_lut_uflow_priority       (reg2dp_lut_uflow_priority)             //|< w
   ,.reg2dp_mul_bypass               (reg2dp_mul_bypass)                     //|< w
   ,.reg2dp_normalz_len              (reg2dp_normalz_len[1:0])               //|< w
   ,.reg2dp_sqsum_bypass             (reg2dp_sqsum_bypass)                   //|< w
   ,.dp2reg_d0_out_saturation        (dp2reg_d0_out_saturation[31:0])        //|> w
   ,.dp2reg_d0_perf_lut_hybrid       (dp2reg_d0_perf_lut_hybrid[31:0])       //|> w
   ,.dp2reg_d0_perf_lut_le_hit       (dp2reg_d0_perf_lut_le_hit[31:0])       //|> w
   ,.dp2reg_d0_perf_lut_lo_hit       (dp2reg_d0_perf_lut_lo_hit[31:0])       //|> w
   ,.dp2reg_d0_perf_lut_oflow        (dp2reg_d0_perf_lut_oflow[31:0])        //|> w
   ,.dp2reg_d0_perf_lut_uflow        (dp2reg_d0_perf_lut_uflow[31:0])        //|> w
   ,.dp2reg_d1_out_saturation        (dp2reg_d1_out_saturation[31:0])        //|> w
   ,.dp2reg_d1_perf_lut_hybrid       (dp2reg_d1_perf_lut_hybrid[31:0])       //|> w
   ,.dp2reg_d1_perf_lut_le_hit       (dp2reg_d1_perf_lut_le_hit[31:0])       //|> w
   ,.dp2reg_d1_perf_lut_lo_hit       (dp2reg_d1_perf_lut_lo_hit[31:0])       //|> w
   ,.dp2reg_d1_perf_lut_oflow        (dp2reg_d1_perf_lut_oflow[31:0])        //|> w
   ,.dp2reg_d1_perf_lut_uflow        (dp2reg_d1_perf_lut_uflow[31:0])        //|> w
   ,.dp2reg_lut_data                 (dp2reg_lut_data[15:0])                 //|> w
   ,.nvdla_core_clk                  (nvdla_op_gated_clk_core)               //|< w
   ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
   ,.cdp_rdma2dp_valid               (nan_preproc_pvld)                      //|< w
   ,.cdp_rdma2dp_ready               (nan_preproc_prdy)                      //|> w
   ,.cdp_rdma2dp_pd                  (nan_preproc_pd[86:0])                  //|< w
   ,.cdp_dp2wdma_valid               (cdp_dp2wdma_valid)                     //|> w
   ,.cdp_dp2wdma_ready               (cdp_dp2wdma_ready)                     //|< w
   ,.cdp_dp2wdma_pd                  (cdp_dp2wdma_pd[78:0])                  //|> w
   ,.nvdla_core_clk_orig             (nvdla_core_clk)                        //|< i
   ,.nvdla_op_gated_clk_fp16         (nvdla_op_gated_clk_fp16)               //|< w
   ,.nvdla_op_gated_clk_int          (nvdla_op_gated_clk_int)                //|< w
   );

 //=======================================
 //CONFIG instance
 //rdma has seperate config register, while wdma share with core
 //---------------------------------------
 NV_NVDLA_CDP_reg u_reg (
    .nvdla_core_clk                  (nvdla_core_clk)                        //|< i
   ,.nvdla_core_rstn                 (nvdla_core_rstn)                       //|< i
   ,.csb2cdp_req_pd                  (csb2cdp_req_pd[62:0])                  //|< i
   ,.csb2cdp_req_pvld                (csb2cdp_req_pvld)                      //|< i
   ,.dp2reg_d0_out_saturation        (dp2reg_d0_out_saturation[31:0])        //|< w
   ,.dp2reg_d0_perf_lut_hybrid       (dp2reg_d0_perf_lut_hybrid[31:0])       //|< w
   ,.dp2reg_d0_perf_lut_le_hit       (dp2reg_d0_perf_lut_le_hit[31:0])       //|< w
   ,.dp2reg_d0_perf_lut_lo_hit       (dp2reg_d0_perf_lut_lo_hit[31:0])       //|< w
   ,.dp2reg_d0_perf_lut_oflow        (dp2reg_d0_perf_lut_oflow[31:0])        //|< w
   ,.dp2reg_d0_perf_lut_uflow        (dp2reg_d0_perf_lut_uflow[31:0])        //|< w
   ,.dp2reg_d0_perf_write_stall      (dp2reg_d0_perf_write_stall[31:0])      //|< w
   ,.dp2reg_d1_out_saturation        (dp2reg_d1_out_saturation[31:0])        //|< w
   ,.dp2reg_d1_perf_lut_hybrid       (dp2reg_d1_perf_lut_hybrid[31:0])       //|< w
   ,.dp2reg_d1_perf_lut_le_hit       (dp2reg_d1_perf_lut_le_hit[31:0])       //|< w
   ,.dp2reg_d1_perf_lut_lo_hit       (dp2reg_d1_perf_lut_lo_hit[31:0])       //|< w
   ,.dp2reg_d1_perf_lut_oflow        (dp2reg_d1_perf_lut_oflow[31:0])        //|< w
   ,.dp2reg_d1_perf_lut_uflow        (dp2reg_d1_perf_lut_uflow[31:0])        //|< w
   ,.dp2reg_d1_perf_write_stall      (dp2reg_d1_perf_write_stall[31:0])      //|< w
   ,.dp2reg_done                     (dp2reg_done)                           //|< w
   ,.dp2reg_inf_input_num            (dp2reg_inf_input_num[31:0])            //|< w
   ,.dp2reg_lut_data                 (dp2reg_lut_data[15:0])                 //|< w
   ,.dp2reg_nan_input_num            (dp2reg_nan_input_num[31:0])            //|< w
   ,.dp2reg_nan_output_num           (dp2reg_nan_output_num[31:0])           //|< w
   ,.cdp2csb_resp_pd                 (cdp2csb_resp_pd[33:0])                 //|> o
   ,.cdp2csb_resp_valid              (cdp2csb_resp_valid)                    //|> o
   ,.csb2cdp_req_prdy                (csb2cdp_req_prdy)                      //|> o
   ,.reg2dp_cya                      (reg2dp_cya[31:0])                      //|> w *
   ,.reg2dp_datin_offset             (reg2dp_datin_offset[15:0])             //|> w
   ,.reg2dp_datin_scale              (reg2dp_datin_scale[15:0])              //|> w
   ,.reg2dp_datin_shifter            (reg2dp_datin_shifter[4:0])             //|> w
   ,.reg2dp_datout_offset            (reg2dp_datout_offset[31:0])            //|> w
   ,.reg2dp_datout_scale             (reg2dp_datout_scale[15:0])             //|> w
   ,.reg2dp_datout_shifter           (reg2dp_datout_shifter[5:0])            //|> w
   ,.reg2dp_dma_en                   (reg2dp_dma_en)                         //|> w
   ,.reg2dp_dst_base_addr_high       (reg2dp_dst_base_addr_high[31:0])       //|> w
   ,.reg2dp_dst_base_addr_low        (reg2dp_dst_base_addr_low[26:0])        //|> w
   ,.reg2dp_dst_line_stride          (reg2dp_dst_line_stride[26:0])          //|> w
   ,.reg2dp_dst_ram_type             (reg2dp_dst_ram_type)                   //|> w
   ,.reg2dp_dst_surface_stride       (reg2dp_dst_surface_stride[26:0])       //|> w
   ,.reg2dp_input_data_type          (reg2dp_input_data_type[1:0])           //|> w
   ,.reg2dp_interrupt_ptr            (reg2dp_interrupt_ptr)                  //|> w
   ,.reg2dp_lut_access_type          (reg2dp_lut_access_type)                //|> w
   ,.reg2dp_lut_addr                 (reg2dp_lut_addr[9:0])                  //|> w
   ,.reg2dp_lut_data                 (reg2dp_lut_data[15:0])                 //|> w
   ,.reg2dp_lut_data_trigger         (reg2dp_lut_data_trigger)               //|> w
   ,.reg2dp_lut_en                   (reg2dp_lut_en)                         //|> w *
   ,.reg2dp_lut_hybrid_priority      (reg2dp_lut_hybrid_priority)            //|> w
   ,.reg2dp_lut_le_end_high          (reg2dp_lut_le_end_high[5:0])           //|> w
   ,.reg2dp_lut_le_end_low           (reg2dp_lut_le_end_low[31:0])           //|> w
   ,.reg2dp_lut_le_function          (reg2dp_lut_le_function)                //|> w
   ,.reg2dp_lut_le_index_offset      (reg2dp_lut_le_index_offset[7:0])       //|> w
   ,.reg2dp_lut_le_index_select      (reg2dp_lut_le_index_select[7:0])       //|> w
   ,.reg2dp_lut_le_slope_oflow_scale (reg2dp_lut_le_slope_oflow_scale[15:0]) //|> w
   ,.reg2dp_lut_le_slope_oflow_shift (reg2dp_lut_le_slope_oflow_shift[4:0])  //|> w
   ,.reg2dp_lut_le_slope_uflow_scale (reg2dp_lut_le_slope_uflow_scale[15:0]) //|> w
   ,.reg2dp_lut_le_slope_uflow_shift (reg2dp_lut_le_slope_uflow_shift[4:0])  //|> w
   ,.reg2dp_lut_le_start_high        (reg2dp_lut_le_start_high[5:0])         //|> w
   ,.reg2dp_lut_le_start_low         (reg2dp_lut_le_start_low[31:0])         //|> w
   ,.reg2dp_lut_lo_end_high          (reg2dp_lut_lo_end_high[5:0])           //|> w
   ,.reg2dp_lut_lo_end_low           (reg2dp_lut_lo_end_low[31:0])           //|> w
   ,.reg2dp_lut_lo_index_select      (reg2dp_lut_lo_index_select[7:0])       //|> w
   ,.reg2dp_lut_lo_slope_oflow_scale (reg2dp_lut_lo_slope_oflow_scale[15:0]) //|> w
   ,.reg2dp_lut_lo_slope_oflow_shift (reg2dp_lut_lo_slope_oflow_shift[4:0])  //|> w
   ,.reg2dp_lut_lo_slope_uflow_scale (reg2dp_lut_lo_slope_uflow_scale[15:0]) //|> w
   ,.reg2dp_lut_lo_slope_uflow_shift (reg2dp_lut_lo_slope_uflow_shift[4:0])  //|> w
   ,.reg2dp_lut_lo_start_high        (reg2dp_lut_lo_start_high[5:0])         //|> w
   ,.reg2dp_lut_lo_start_low         (reg2dp_lut_lo_start_low[31:0])         //|> w
   ,.reg2dp_lut_oflow_priority       (reg2dp_lut_oflow_priority)             //|> w
   ,.reg2dp_lut_table_id             (reg2dp_lut_table_id)                   //|> w
   ,.reg2dp_lut_uflow_priority       (reg2dp_lut_uflow_priority)             //|> w
   ,.reg2dp_mul_bypass               (reg2dp_mul_bypass)                     //|> w
   ,.reg2dp_nan_to_zero              (reg2dp_nan_to_zero)                    //|> w
   ,.reg2dp_normalz_len              (reg2dp_normalz_len[1:0])               //|> w
   ,.reg2dp_op_en                    (reg2dp_op_en)                          //|> w
   ,.reg2dp_sqsum_bypass             (reg2dp_sqsum_bypass)                   //|> w
   ,.slcg_op_en                      (slcg_op_en[3:0])                       //|> w
   );

// //==============
// //OBS signals
// //==============
// //assign obs_bus_cdp_core_clk = nvdla_core_clk;
// //assign obs_bus_cdp_core_rstn = nvdla_core_rstn;
// assign obs_bus_cdp_csb_req_vld = csb2cdp_req_pvld; 
// assign obs_bus_cdp_csb_req_rdy = csb2cdp_req_prdy;   
// assign obs_bus_cdp_rdma_mc_rd_req_vld = cdp2mcif_rd_req_valid;
// assign obs_bus_cdp_rdma_mc_rd_req_rdy = cdp2mcif_rd_req_ready;
// assign obs_bus_cdp_rdma_cv_rd_req_vld = cdp2cvif_rd_req_valid;
// assign obs_bus_cdp_rdma_cv_rd_req_rdy = cdp2cvif_rd_req_ready;
// assign obs_bus_cdp_rdma_mc_rd_rsp_vld = mcif2cdp_rd_rsp_valid;
// assign obs_bus_cdp_rdma_mc_rd_rsp_rdy = mcif2cdp_rd_rsp_ready;
// assign obs_bus_cdp_rdma_cv_rd_rsp_vld = cvif2cdp_rd_rsp_valid;
// assign obs_bus_cdp_rdma_cv_rd_rsp_rdy = cvif2cdp_rd_rsp_ready;
// assign obs_bus_cdp_wdma_mc_wr_vld = cdp2mcif_wr_req_valid;
// assign obs_bus_cdp_wdma_mc_wr_rdy = cdp2mcif_wr_req_ready;
// assign obs_bus_cdp_wdma_cv_wr_vld = cdp2cvif_wr_req_valid;
// assign obs_bus_cdp_wdma_cv_wr_rdy = cdp2cvif_wr_req_ready;

 //==============
 //==============
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP reg2dp_datin_offset not sign extend")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, reg2dp_op_en & (((reg2dp_input_data_type == 2'h0 ) & ((|reg2dp_datin_offset[15:7]) != (&reg2dp_datin_offset[15:7]))))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP reg2dp_datout_offset not sign extend")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, reg2dp_op_en & (((reg2dp_input_data_type == 2'h0 ) & ((|reg2dp_datout_offset[31:24]) != (&reg2dp_datout_offset[31:24]))) | ((reg2dp_input_data_type == 2'h2 ) & ((|reg2dp_datout_offset[31:15]) != (&reg2dp_datout_offset[31:15]))))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP reg2dp_lut_le_end not sign extend")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, reg2dp_op_en & (((reg2dp_input_data_type == 2'h0 ) & ((|{reg2dp_lut_le_end_high[5:0],reg2dp_lut_le_end_low[31:21]}) != (&{reg2dp_lut_le_end_high[5:0],reg2dp_lut_le_end_low[31:21]}))) | ((reg2dp_input_data_type == 2'h2 ) & ((|{reg2dp_lut_le_end_high[5:0],reg2dp_lut_le_end_low[31]}) != (&{reg2dp_lut_le_end_high[5:0],reg2dp_lut_le_end_low[31]}))))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP reg2dp_lut_lo_end not sign extend")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, reg2dp_op_en & (((reg2dp_input_data_type == 2'h0 ) & ((|{reg2dp_lut_lo_end_high[5:0],reg2dp_lut_lo_end_low[31:21]}) != (&{reg2dp_lut_lo_end_high[5:0],reg2dp_lut_lo_end_low[31:21]}))) | ((reg2dp_input_data_type == 2'h2 ) & ((|{reg2dp_lut_lo_end_high[5:0],reg2dp_lut_lo_end_low[31]}) != (&{reg2dp_lut_lo_end_high[5:0],reg2dp_lut_lo_end_low[31]}))))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP reg2dp_lut_le_index_select not sign extend")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, reg2dp_op_en & (((reg2dp_input_data_type == 2'h0 ) & ((|reg2dp_lut_le_index_select[7:5]) != (&reg2dp_lut_le_index_select[7:5]))) | ((reg2dp_input_data_type == 2'h1 ) & ((|reg2dp_lut_le_index_select[7:6]) != (&reg2dp_lut_le_index_select[7:6]))))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP reg2dp_lut_lo_index_select not sign extend")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, reg2dp_op_en & (((reg2dp_input_data_type == 2'h0 ) & ((|reg2dp_lut_lo_index_select[7:5]) != (&reg2dp_lut_lo_index_select[7:5]))) | ((reg2dp_input_data_type == 2'h1 ) & ((|reg2dp_lut_lo_index_select[7:6]) != (&reg2dp_lut_lo_index_select[7:6]))))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP reg2dp_lut_le_start not sign extend")      zzz_assert_never_7x (nvdla_core_clk, `ASSERT_RESET, reg2dp_op_en & (((reg2dp_input_data_type == 2'h0 ) & ((|{reg2dp_lut_le_start_high[5:0],reg2dp_lut_le_start_low[31:21]}) != (&{reg2dp_lut_le_start_high[5:0],reg2dp_lut_le_start_low[31:21]}))) | (fp16_en & ((|{reg2dp_lut_le_start_high[5:0],reg2dp_lut_le_start_low[31]}) != (&{reg2dp_lut_le_start_high[5:0],reg2dp_lut_le_start_low[31]}))))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP reg2dp_lut_lo_start not sign extend")      zzz_assert_never_8x (nvdla_core_clk, `ASSERT_RESET, reg2dp_op_en & (((reg2dp_input_data_type == 2'h0 ) & ((|{reg2dp_lut_lo_start_high[5:0],reg2dp_lut_lo_start_low[31:21]}) != (&{reg2dp_lut_lo_start_high[5:0],reg2dp_lut_lo_start_low[31:21]}))) | (fp16_en & ((|{reg2dp_lut_lo_start_high[5:0],reg2dp_lut_lo_start_low[31]}) != (&{reg2dp_lut_lo_start_high[5:0],reg2dp_lut_lo_start_low[31]}))))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//==============
//function polint
//==============

//cdp core two continuous layers
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    mon_op_en_dly <= 1'b0;
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  mon_op_en_dly <= reg2dp_op_en;
  end
end
assign mon_op_en_pos = reg2dp_op_en & (~mon_op_en_dly);
assign mon_op_en_neg = (~reg2dp_op_en) & mon_op_en_dly;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    mon_layer_end_flg <= 1'b0;
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
    if(mon_op_en_neg)
        mon_layer_end_flg <= 1'b1;
    else if(mon_op_en_pos)
        mon_layer_end_flg <= 1'b0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    mon_gap_between_layers[31:0] <= {32{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
    if(mon_layer_end_flg)
        mon_gap_between_layers[31:0] <= mon_gap_between_layers + 1'b1;
    else
        mon_gap_between_layers[31:0] <= 32'd0;
  end
end


//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    reg funcpoint_cover_off;
    initial begin
        if ( $test$plusargs( "cover_off" ) ) begin
            funcpoint_cover_off = 1'b1;
        end else begin
            funcpoint_cover_off = 1'b0;
        end
    end

    property CDP_CORE_two_continuous_layer__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (mon_gap_between_layers==32'd2) & mon_op_en_pos;
    endproperty
    // Cover 0 : "(mon_gap_between_layers==32'd2) & mon_op_en_pos"
    FUNCPOINT_CDP_CORE_two_continuous_layer__0_COV : cover property (CDP_CORE_two_continuous_layer__0_cov);

  `endif
`endif
//VCS coverage on

//3 cycles means continuous layer

//different config between two continous layers
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    mon_reg2dp_input_data_type <= {2{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_input_data_type <= reg2dp_input_data_type;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_input_data_type <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    mon_reg2dp_lut_le_function <= 1'b0;
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_lut_le_function <= reg2dp_lut_le_function;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_lut_le_function <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    mon_reg2dp_mul_bypass <= 1'b0;
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_mul_bypass <= reg2dp_mul_bypass;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_mul_bypass <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    mon_reg2dp_nan_to_zero <= 1'b0;
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_nan_to_zero <= reg2dp_nan_to_zero;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_nan_to_zero <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    mon_reg2dp_normalz_len <= {2{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_normalz_len <= reg2dp_normalz_len;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_normalz_len <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    mon_reg2dp_sqsum_bypass <= 1'b0;
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_sqsum_bypass <= reg2dp_sqsum_bypass;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_sqsum_bypass <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property CDP_CORE_two_continuous_changed_layer__change_data_type__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_input_data_type!=reg2dp_input_data_type));
    endproperty
    // Cover 1 : "(mon_reg2dp_input_data_type!=reg2dp_input_data_type)"
    FUNCPOINT_CDP_CORE_two_continuous_changed_layer__change_data_type__1_COV : cover property (CDP_CORE_two_continuous_changed_layer__change_data_type__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property CDP_CORE_two_continuous_changed_layer__change_le_func__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_lut_le_function!=reg2dp_lut_le_function));
    endproperty
    // Cover 2 : "(mon_reg2dp_lut_le_function!=reg2dp_lut_le_function)"
    FUNCPOINT_CDP_CORE_two_continuous_changed_layer__change_le_func__2_COV : cover property (CDP_CORE_two_continuous_changed_layer__change_le_func__2_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property CDP_CORE_two_continuous_changed_layer__change_mul_bypass__3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_mul_bypass!=reg2dp_mul_bypass));
    endproperty
    // Cover 3 : "(mon_reg2dp_mul_bypass!=reg2dp_mul_bypass)"
    FUNCPOINT_CDP_CORE_two_continuous_changed_layer__change_mul_bypass__3_COV : cover property (CDP_CORE_two_continuous_changed_layer__change_mul_bypass__3_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property CDP_CORE_two_continuous_changed_layer__change_sqsum_bypass__4_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_sqsum_bypass!=reg2dp_sqsum_bypass));
    endproperty
    // Cover 4 : "(mon_reg2dp_sqsum_bypass!=reg2dp_sqsum_bypass)"
    FUNCPOINT_CDP_CORE_two_continuous_changed_layer__change_sqsum_bypass__4_COV : cover property (CDP_CORE_two_continuous_changed_layer__change_sqsum_bypass__4_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property CDP_CORE_two_continuous_changed_layer__change_nan2zero__5_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_nan_to_zero!=reg2dp_nan_to_zero));
    endproperty
    // Cover 5 : "(mon_reg2dp_nan_to_zero!=reg2dp_nan_to_zero)"
    FUNCPOINT_CDP_CORE_two_continuous_changed_layer__change_nan2zero__5_COV : cover property (CDP_CORE_two_continuous_changed_layer__change_nan2zero__5_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property CDP_CORE_two_continuous_changed_layer__change_lrn_len__6_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_normalz_len!=reg2dp_normalz_len));
    endproperty
    // Cover 6 : "(mon_reg2dp_normalz_len!=reg2dp_normalz_len)"
    FUNCPOINT_CDP_CORE_two_continuous_changed_layer__change_lrn_len__6_COV : cover property (CDP_CORE_two_continuous_changed_layer__change_lrn_len__6_cov);

  `endif
`endif
//VCS coverage on


 //==============
 //==============
 //&Force internal /^dp2reg/;

endmodule // NV_NVDLA_cdp

