// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_PDP_rdma.v

module NV_NVDLA_PDP_rdma (
   csb2pdp_rdma_req_pd           //|< i
  ,csb2pdp_rdma_req_pvld         //|< i
  ,cvif2pdp_rd_rsp_pd            //|< i
  ,cvif2pdp_rd_rsp_valid         //|< i
  ,dla_clk_ovr_on_sync           //|< i
  ,global_clk_ovr_on_sync        //|< i
  ,mcif2pdp_rd_rsp_pd            //|< i
  ,mcif2pdp_rd_rsp_valid         //|< i
  ,nvdla_core_clk                //|< i
  ,nvdla_core_rstn               //|< i
  ,pdp2cvif_rd_req_ready         //|< i
  ,pdp2mcif_rd_req_ready         //|< i
  ,pdp_rdma2dp_ready             //|< i
  ,pwrbus_ram_pd                 //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,csb2pdp_rdma_req_prdy         //|> o
  ,cvif2pdp_rd_rsp_ready         //|> o
  ,mcif2pdp_rd_rsp_ready         //|> o
  ,pdp2cvif_rd_cdt_lat_fifo_pop  //|> o
  ,pdp2cvif_rd_req_pd            //|> o
  ,pdp2cvif_rd_req_valid         //|> o
  ,pdp2mcif_rd_cdt_lat_fifo_pop  //|> o
  ,pdp2mcif_rd_req_pd            //|> o
  ,pdp2mcif_rd_req_valid         //|> o
  ,pdp_rdma2csb_resp_pd          //|> o
  ,pdp_rdma2csb_resp_valid       //|> o
  ,pdp_rdma2dp_pd                //|> o
  ,pdp_rdma2dp_valid             //|> o
  ,rdma2wdma_done                //|> o
  );
 output        rdma2wdma_done;
 //
 // NV_NVDLA_PDP_rdma_ports.v
 //
 input  nvdla_core_clk;   /* csb2pdp_rdma_req, cvif2pdp_rd_rsp, mcif2pdp_rd_rsp, pdp2cvif_rd_cdt, pdp2cvif_rd_req, pdp2mcif_rd_cdt, pdp2mcif_rd_req, pdp_rdma2csb_resp, pdp_rdma2dp */
 input  nvdla_core_rstn;  /* csb2pdp_rdma_req, cvif2pdp_rd_rsp, mcif2pdp_rd_rsp, pdp2cvif_rd_cdt, pdp2cvif_rd_req, pdp2mcif_rd_cdt, pdp2mcif_rd_req, pdp_rdma2csb_resp, pdp_rdma2dp */

 input         csb2pdp_rdma_req_pvld;  /* data valid */
 output        csb2pdp_rdma_req_prdy;  /* data return handshake */
 input  [62:0] csb2pdp_rdma_req_pd;

 input          cvif2pdp_rd_rsp_valid;  /* data valid */
 output         cvif2pdp_rd_rsp_ready;  /* data return handshake */
 input  [513:0] cvif2pdp_rd_rsp_pd;

 input          mcif2pdp_rd_rsp_valid;  /* data valid */
 output         mcif2pdp_rd_rsp_ready;  /* data return handshake */
 input  [513:0] mcif2pdp_rd_rsp_pd;

 output  pdp2cvif_rd_cdt_lat_fifo_pop;

 output        pdp2cvif_rd_req_valid;  /* data valid */
 input         pdp2cvif_rd_req_ready;  /* data return handshake */
 output [78:0] pdp2cvif_rd_req_pd;

 output  pdp2mcif_rd_cdt_lat_fifo_pop;

 output        pdp2mcif_rd_req_valid;  /* data valid */
 input         pdp2mcif_rd_req_ready;  /* data return handshake */
 output [78:0] pdp2mcif_rd_req_pd;

 output        pdp_rdma2csb_resp_valid;  /* data valid */
 output [33:0] pdp_rdma2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

 output        pdp_rdma2dp_valid;  /* data valid */
 input         pdp_rdma2dp_ready;  /* data return handshake */
 output [75:0] pdp_rdma2dp_pd;

 input [31:0] pwrbus_ram_pd;

 input   dla_clk_ovr_on_sync;
 input   global_clk_ovr_on_sync;
 input   tmc2slcg_disable_clock_gating;
 wire   [17:0] cq2eg_pd;
 wire          cq2eg_prdy;
 wire          cq2eg_pvld;
 wire   [31:0] dp2reg_d0_perf_read_stall;
 wire   [31:0] dp2reg_d1_perf_read_stall;
 wire          dp2reg_done;
 wire          eg2ig_done;
 wire   [17:0] ig2cq_pd;
 wire          ig2cq_prdy;
 wire          ig2cq_pvld;
 wire          nvdla_op_gated_clk;
 wire   [12:0] reg2dp_cube_in_channel;
 wire   [12:0] reg2dp_cube_in_height;
 wire   [12:0] reg2dp_cube_in_width;
 wire   [31:0] reg2dp_cya;
 wire    [0:0] reg2dp_dma_en;
 wire          reg2dp_flying_mode;
 wire    [1:0] reg2dp_input_data;
 wire    [3:0] reg2dp_kernel_stride_width;
 wire    [3:0] reg2dp_kernel_width;
 wire    [0:0] reg2dp_op_en;
 wire    [3:0] reg2dp_pad_width;
 wire    [9:0] reg2dp_partial_width_in_first;
 wire    [9:0] reg2dp_partial_width_in_last;
 wire    [9:0] reg2dp_partial_width_in_mid;
 wire    [7:0] reg2dp_split_num;
 wire   [31:0] reg2dp_src_base_addr_high;
 wire   [26:0] reg2dp_src_base_addr_low;
 wire   [26:0] reg2dp_src_line_stride;
 wire    [0:0] reg2dp_src_ram_type;
 wire   [26:0] reg2dp_src_surface_stride;
 wire   [31:0] reg2dp_surf_stride;
 wire    [0:0] slcg_op_en;

//=======================================
//        SLCG gen unit
//---------------------------------------

NV_NVDLA_PDP_slcg u_slcg (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)                //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)             //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                     //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                    //|< i
  ,.slcg_en_src                   (slcg_op_en[0])                      //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)      //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk)                 //|> w
  );
//&Connect    slcg_en_src             slcg_op_en & off_fly_en;
 //=======================================
 // Ingress: send read request to external mem
 //---------------------------------------
 NV_NVDLA_PDP_RDMA_ig u_ig (
    .reg2dp_cube_in_channel        (reg2dp_cube_in_channel[12:0])       //|< w
   ,.reg2dp_cube_in_height         (reg2dp_cube_in_height[12:0])        //|< w
   ,.reg2dp_cube_in_width          (reg2dp_cube_in_width[12:0])         //|< w
   ,.reg2dp_dma_en                 (reg2dp_dma_en[0])                   //|< w
   ,.reg2dp_input_data             (reg2dp_input_data[1:0])             //|< w
   ,.reg2dp_kernel_stride_width    (reg2dp_kernel_stride_width[3:0])    //|< w
   ,.reg2dp_kernel_width           (reg2dp_kernel_width[3:0])           //|< w
   ,.reg2dp_op_en                  (reg2dp_op_en[0])                    //|< w
   ,.reg2dp_partial_width_in_first (reg2dp_partial_width_in_first[9:0]) //|< w
   ,.reg2dp_partial_width_in_last  (reg2dp_partial_width_in_last[9:0])  //|< w
   ,.reg2dp_partial_width_in_mid   (reg2dp_partial_width_in_mid[9:0])   //|< w
   ,.reg2dp_split_num              (reg2dp_split_num[7:0])              //|< w
   ,.reg2dp_src_base_addr_high     (reg2dp_src_base_addr_high[31:0])    //|< w
   ,.reg2dp_src_base_addr_low      (reg2dp_src_base_addr_low[26:0])     //|< w
   ,.reg2dp_src_line_stride        (reg2dp_src_line_stride[26:0])       //|< w
   ,.reg2dp_src_ram_type           (reg2dp_src_ram_type[0])             //|< w
   ,.reg2dp_src_surface_stride     (reg2dp_src_surface_stride[26:0])    //|< w
   ,.dp2reg_d0_perf_read_stall     (dp2reg_d0_perf_read_stall[31:0])    //|> w
   ,.dp2reg_d1_perf_read_stall     (dp2reg_d1_perf_read_stall[31:0])    //|> w
   ,.reg2dp_surf_stride            (reg2dp_surf_stride[31:0])           //|> w *
   ,.eg2ig_done                    (eg2ig_done)                         //|< w
   ,.nvdla_core_clk                (nvdla_op_gated_clk)                 //|< w
   ,.nvdla_core_rstn               (nvdla_core_rstn)                    //|< i
   ,.pdp2mcif_rd_req_valid         (pdp2mcif_rd_req_valid)              //|> o
   ,.pdp2mcif_rd_req_ready         (pdp2mcif_rd_req_ready)              //|< i
   ,.pdp2mcif_rd_req_pd            (pdp2mcif_rd_req_pd[78:0])           //|> o
   ,.pdp2cvif_rd_req_valid         (pdp2cvif_rd_req_valid)              //|> o
   ,.pdp2cvif_rd_req_ready         (pdp2cvif_rd_req_ready)              //|< i
   ,.pdp2cvif_rd_req_pd            (pdp2cvif_rd_req_pd[78:0])           //|> o
   ,.ig2cq_pvld                    (ig2cq_pvld)                         //|> w
   ,.ig2cq_prdy                    (ig2cq_prdy)                         //|< w
   ,.ig2cq_pd                      (ig2cq_pd[17:0])                     //|> w
   );
 //=======================================
 // Context Queue: trace outstanding req, and pass info from Ig to Eg
 //---------------------------------------
 NV_NVDLA_PDP_RDMA_cq u_cq (
    .nvdla_core_clk                (nvdla_op_gated_clk)                 //|< w
   ,.nvdla_core_rstn               (nvdla_core_rstn)                    //|< i
   ,.ig2cq_prdy                    (ig2cq_prdy)                         //|> w
   ,.ig2cq_pvld                    (ig2cq_pvld)                         //|< w
   ,.ig2cq_pd                      (ig2cq_pd[17:0])                     //|< w
   ,.cq2eg_prdy                    (cq2eg_prdy)                         //|< w
   ,.cq2eg_pvld                    (cq2eg_pvld)                         //|> w
   ,.cq2eg_pd                      (cq2eg_pd[17:0])                     //|> w
   ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])                //|< i
   );
 //=======================================
 // Egress: get return data from external mem
 //---------------------------------------
 NV_NVDLA_PDP_RDMA_eg u_eg (
    .reg2dp_src_ram_type           (reg2dp_src_ram_type)                //|< w
   ,.dp2reg_done                   (dp2reg_done)                        //|> w
   ,.eg2ig_done                    (eg2ig_done)                         //|> w
   ,.rdma2wdma_done                (rdma2wdma_done)                     //|> o
   ,.nvdla_core_clk                (nvdla_op_gated_clk)                 //|< w
   ,.nvdla_core_rstn               (nvdla_core_rstn)                    //|< i
   ,.mcif2pdp_rd_rsp_valid         (mcif2pdp_rd_rsp_valid)              //|< i
   ,.mcif2pdp_rd_rsp_ready         (mcif2pdp_rd_rsp_ready)              //|> o
   ,.mcif2pdp_rd_rsp_pd            (mcif2pdp_rd_rsp_pd[513:0])          //|< i
   ,.pdp2mcif_rd_cdt_lat_fifo_pop  (pdp2mcif_rd_cdt_lat_fifo_pop)       //|> o
   ,.cvif2pdp_rd_rsp_valid         (cvif2pdp_rd_rsp_valid)              //|< i
   ,.cvif2pdp_rd_rsp_ready         (cvif2pdp_rd_rsp_ready)              //|> o
   ,.cvif2pdp_rd_rsp_pd            (cvif2pdp_rd_rsp_pd[513:0])          //|< i
   ,.pdp2cvif_rd_cdt_lat_fifo_pop  (pdp2cvif_rd_cdt_lat_fifo_pop)       //|> o
   ,.pdp_rdma2dp_valid             (pdp_rdma2dp_valid)                  //|> o
   ,.pdp_rdma2dp_ready             (pdp_rdma2dp_ready)                  //|< i
   ,.pdp_rdma2dp_pd                (pdp_rdma2dp_pd[75:0])               //|> o
   ,.cq2eg_pvld                    (cq2eg_pvld)                         //|< w
   ,.cq2eg_prdy                    (cq2eg_prdy)                         //|> w
   ,.cq2eg_pd                      (cq2eg_pd[17:0])                     //|< w
   ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])                //|< i
   );

 //========================================
 //CFG: Configure Registers
 //----------------------------------------
 NV_NVDLA_PDP_RDMA_reg u_reg (
    .nvdla_core_clk                (nvdla_core_clk)                     //|< i
   ,.nvdla_core_rstn               (nvdla_core_rstn)                    //|< i
   ,.csb2pdp_rdma_req_pd           (csb2pdp_rdma_req_pd[62:0])          //|< i
   ,.csb2pdp_rdma_req_pvld         (csb2pdp_rdma_req_pvld)              //|< i
   ,.dp2reg_d0_perf_read_stall     (dp2reg_d0_perf_read_stall[31:0])    //|< w
   ,.dp2reg_d1_perf_read_stall     (dp2reg_d1_perf_read_stall[31:0])    //|< w
   ,.dp2reg_done                   (dp2reg_done)                        //|< w
   ,.csb2pdp_rdma_req_prdy         (csb2pdp_rdma_req_prdy)              //|> o
   ,.pdp_rdma2csb_resp_pd          (pdp_rdma2csb_resp_pd[33:0])         //|> o
   ,.pdp_rdma2csb_resp_valid       (pdp_rdma2csb_resp_valid)            //|> o
   ,.reg2dp_cube_in_channel        (reg2dp_cube_in_channel[12:0])       //|> w
   ,.reg2dp_cube_in_height         (reg2dp_cube_in_height[12:0])        //|> w
   ,.reg2dp_cube_in_width          (reg2dp_cube_in_width[12:0])         //|> w
   ,.reg2dp_cya                    (reg2dp_cya[31:0])                   //|> w *
   ,.reg2dp_dma_en                 (reg2dp_dma_en)                      //|> w
   ,.reg2dp_flying_mode            (reg2dp_flying_mode)                 //|> w *
   ,.reg2dp_input_data             (reg2dp_input_data[1:0])             //|> w
   ,.reg2dp_kernel_stride_width    (reg2dp_kernel_stride_width[3:0])    //|> w
   ,.reg2dp_kernel_width           (reg2dp_kernel_width[3:0])           //|> w
   ,.reg2dp_op_en                  (reg2dp_op_en)                       //|> w
   ,.reg2dp_pad_width              (reg2dp_pad_width[3:0])              //|> w *
   ,.reg2dp_partial_width_in_first (reg2dp_partial_width_in_first[9:0]) //|> w
   ,.reg2dp_partial_width_in_last  (reg2dp_partial_width_in_last[9:0])  //|> w
   ,.reg2dp_partial_width_in_mid   (reg2dp_partial_width_in_mid[9:0])   //|> w
   ,.reg2dp_split_num              (reg2dp_split_num[7:0])              //|> w
   ,.reg2dp_src_base_addr_high     (reg2dp_src_base_addr_high[31:0])    //|> w
   ,.reg2dp_src_base_addr_low      (reg2dp_src_base_addr_low[26:0])     //|> w
   ,.reg2dp_src_line_stride        (reg2dp_src_line_stride[26:0])       //|> w
   ,.reg2dp_src_ram_type           (reg2dp_src_ram_type)                //|> w
   ,.reg2dp_src_surface_stride     (reg2dp_src_surface_stride[26:0])    //|> w
   ,.slcg_op_en                    (slcg_op_en)                         //|> w
   );

 //&Forget dangle .*;


endmodule // NV_NVDLA_PDP_rdma

