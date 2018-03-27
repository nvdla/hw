// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_bdma.v

module NV_NVDLA_bdma (
   bdma2mcif_rd_req_ready        //|< i
  ,bdma2mcif_wr_req_ready        //|< i
  ,csb2bdma_req_pd               //|< i
  ,csb2bdma_req_pvld             //|< i  
   #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,bdma2cvif_rd_req_ready        //|< i
  ,bdma2cvif_wr_req_ready        //|< i
  #endif
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cvif2bdma_rd_rsp_pd           //|< i
  ,cvif2bdma_rd_rsp_valid        //|< i
  ,cvif2bdma_wr_rsp_complete     //|< i
  #endif
  ,dla_clk_ovr_on_sync           //|< i
  ,global_clk_ovr_on_sync        //|< i
  ,mcif2bdma_rd_rsp_pd           //|< i
  ,mcif2bdma_rd_rsp_valid        //|< i
  ,mcif2bdma_wr_rsp_complete     //|< i
  ,nvdla_core_clk                //|< i
  ,nvdla_core_rstn               //|< i
  ,pwrbus_ram_pd                 //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,bdma2csb_resp_pd              //|> o
  ,bdma2csb_resp_valid           //|> o
   #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,bdma2cvif_rd_cdt_lat_fifo_pop //|> o
  ,bdma2cvif_rd_req_pd           //|> o
  ,bdma2cvif_rd_req_valid        //|> o
  ,bdma2cvif_wr_req_pd           //|> o
  ,bdma2cvif_wr_req_valid        //|> o
  #endif
  ,bdma2glb_done_intr_pd         //|> o
  ,bdma2mcif_rd_cdt_lat_fifo_pop //|> o
  ,bdma2mcif_rd_req_pd           //|> o
  ,bdma2mcif_rd_req_valid        //|> o
  ,bdma2mcif_wr_req_pd           //|> o
  ,bdma2mcif_wr_req_valid        //|> o
  ,csb2bdma_req_prdy             //|> o
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cvif2bdma_rd_rsp_ready        //|> o
  #endif
  ,mcif2bdma_rd_rsp_ready        //|> o
  );

//
// NV_NVDLA_bdma_ports.v
//
input  nvdla_core_clk;   /* bdma2csb_resp, bdma2cvif_rd_cdt, bdma2cvif_rd_req, bdma2cvif_wr_req, bdma2glb_done_intr, bdma2mcif_rd_cdt, bdma2mcif_rd_req, bdma2mcif_wr_req, csb2bdma_req, cvif2bdma_rd_rsp, cvif2bdma_wr_rsp, mcif2bdma_rd_rsp, mcif2bdma_wr_rsp */
input  nvdla_core_rstn;  /* bdma2csb_resp, bdma2cvif_rd_cdt, bdma2cvif_rd_req, bdma2cvif_wr_req, bdma2glb_done_intr, bdma2mcif_rd_cdt, bdma2mcif_rd_req, bdma2mcif_wr_req, csb2bdma_req, cvif2bdma_rd_rsp, cvif2bdma_wr_rsp, mcif2bdma_rd_rsp, mcif2bdma_wr_rsp */

output        bdma2csb_resp_valid;  /* data valid */
output [33:0] bdma2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
output  bdma2cvif_rd_cdt_lat_fifo_pop;

output        bdma2cvif_rd_req_valid;  /* data valid */
input         bdma2cvif_rd_req_ready;  /* data return handshake */
output [78:0] bdma2cvif_rd_req_pd;

output         bdma2cvif_wr_req_valid;  /* data valid */
input          bdma2cvif_wr_req_ready;  /* data return handshake */
output [514:0] bdma2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */
#endif

output [1:0] bdma2glb_done_intr_pd;

output  bdma2mcif_rd_cdt_lat_fifo_pop;

output        bdma2mcif_rd_req_valid;  /* data valid */
input         bdma2mcif_rd_req_ready;  /* data return handshake */
output [78:0] bdma2mcif_rd_req_pd;

output         bdma2mcif_wr_req_valid;  /* data valid */
input          bdma2mcif_wr_req_ready;  /* data return handshake */
output [514:0] bdma2mcif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input         csb2bdma_req_pvld;  /* data valid */
output        csb2bdma_req_prdy;  /* data return handshake */
input  [62:0] csb2bdma_req_pd;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
input          cvif2bdma_rd_rsp_valid;  /* data valid */
output         cvif2bdma_rd_rsp_ready;  /* data return handshake */
input  [513:0] cvif2bdma_rd_rsp_pd;

input  cvif2bdma_wr_rsp_complete;
#endif

input          mcif2bdma_rd_rsp_valid;  /* data valid */
output         mcif2bdma_rd_rsp_ready;  /* data return handshake */
input  [513:0] mcif2bdma_rd_rsp_pd;

input  mcif2bdma_wr_rsp_complete;

input [31:0] pwrbus_ram_pd;

//&Ports /^obs_bus/;
input         dla_clk_ovr_on_sync;
input         global_clk_ovr_on_sync;
input         tmc2slcg_disable_clock_gating;
wire          csb2gate_slcg_en;
wire          csb2ld_rdy;
wire          csb2ld_vld;
wire   [31:0] dma_write_stall_count;
wire          dma_write_stall_count_cen;
wire          ld2csb_grp0_dma_stall_inc;
wire          ld2csb_grp1_dma_stall_inc;
wire          ld2csb_idle;
wire          ld2gate_slcg_en;
wire  [160:0] ld2st_rd_pd;
wire          ld2st_rd_prdy;
wire          ld2st_rd_pvld;
wire          ld2st_wr_idle;
wire  [160:0] ld2st_wr_pd;
wire          ld2st_wr_prdy;
wire          ld2st_wr_pvld;
wire          nvdla_gated_clk;
wire          reg2dp_cmd_dst_ram_type;
wire          reg2dp_cmd_interrupt;
wire          reg2dp_cmd_interrupt_ptr;
wire          reg2dp_cmd_src_ram_type;
wire   [31:0] reg2dp_dst_addr_high_v8;
wire   [26:0] reg2dp_dst_addr_low_v32;
wire   [26:0] reg2dp_dst_line_stride;
wire   [26:0] reg2dp_dst_surf_stride;
wire   [23:0] reg2dp_line_repeat_number;
wire   [12:0] reg2dp_line_size;
wire   [31:0] reg2dp_src_addr_high_v8;
wire   [26:0] reg2dp_src_addr_low_v32;
wire   [26:0] reg2dp_src_line_stride;
wire   [26:0] reg2dp_src_surf_stride;
wire   [23:0] reg2dp_surf_repeat_number;
wire          st2csb_grp0_done;
wire          st2csb_grp1_done;
wire          st2csb_idle;
wire          st2gate_slcg_en;
wire          st2ld_load_idle;

// &Forget dangle .*;
NV_NVDLA_BDMA_csb u_csb (
   .nvdla_core_clk                (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.csb2bdma_req_pvld             (csb2bdma_req_pvld)               //|< i
  ,.csb2bdma_req_prdy             (csb2bdma_req_prdy)               //|> o
  ,.csb2bdma_req_pd               (csb2bdma_req_pd[62:0])           //|< i
  ,.bdma2csb_resp_valid           (bdma2csb_resp_valid)             //|> o
  ,.bdma2csb_resp_pd              (bdma2csb_resp_pd[33:0])          //|> o
  ,.bdma2glb_done_intr_pd         (bdma2glb_done_intr_pd[1:0])      //|> o
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])             //|< i
  ,.st2csb_grp0_done              (st2csb_grp0_done)                //|< w
  ,.st2csb_grp1_done              (st2csb_grp1_done)                //|< w
  ,.st2csb_idle                   (st2csb_idle)                     //|< w
  ,.reg2dp_cmd_dst_ram_type       (reg2dp_cmd_dst_ram_type)         //|> w
  ,.reg2dp_cmd_interrupt          (reg2dp_cmd_interrupt)            //|> w
  ,.reg2dp_cmd_interrupt_ptr      (reg2dp_cmd_interrupt_ptr)        //|> w
  ,.reg2dp_cmd_src_ram_type       (reg2dp_cmd_src_ram_type)         //|> w
  ,.reg2dp_dst_addr_high_v8       (reg2dp_dst_addr_high_v8[31:0])   //|> w
  ,.reg2dp_dst_addr_low_v32       (reg2dp_dst_addr_low_v32[26:0])   //|> w
  ,.reg2dp_dst_line_stride        (reg2dp_dst_line_stride[26:0])    //|> w
  ,.reg2dp_dst_surf_stride        (reg2dp_dst_surf_stride[26:0])    //|> w
  ,.reg2dp_line_repeat_number     (reg2dp_line_repeat_number[23:0]) //|> w
  ,.reg2dp_line_size              (reg2dp_line_size[12:0])          //|> w
  ,.reg2dp_src_addr_high_v8       (reg2dp_src_addr_high_v8[31:0])   //|> w
  ,.reg2dp_src_addr_low_v32       (reg2dp_src_addr_low_v32[26:0])   //|> w
  ,.reg2dp_src_line_stride        (reg2dp_src_line_stride[26:0])    //|> w
  ,.reg2dp_src_surf_stride        (reg2dp_src_surf_stride[26:0])    //|> w
  ,.reg2dp_surf_repeat_number     (reg2dp_surf_repeat_number[23:0]) //|> w
  ,.csb2ld_rdy                    (csb2ld_rdy)                      //|< w
  ,.ld2csb_grp0_dma_stall_inc     (ld2csb_grp0_dma_stall_inc)       //|< w
  ,.ld2csb_grp1_dma_stall_inc     (ld2csb_grp1_dma_stall_inc)       //|< w
  ,.ld2csb_idle                   (ld2csb_idle)                     //|< w
  ,.csb2ld_vld                    (csb2ld_vld)                      //|> w
  ,.csb2gate_slcg_en              (csb2gate_slcg_en)                //|> w
  ,.dma_write_stall_count         (dma_write_stall_count[31:0])     //|< w
  ,.dma_write_stall_count_cen     (dma_write_stall_count_cen)       //|> w
  );

NV_NVDLA_BDMA_gate u_gate (
   .csb2gate_slcg_en              (csb2gate_slcg_en)                //|< w
  ,.dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)             //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)          //|< i
  ,.ld2gate_slcg_en               (ld2gate_slcg_en)                 //|< w
  ,.nvdla_core_clk                (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.st2gate_slcg_en               (st2gate_slcg_en)                 //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)   //|< i
  ,.nvdla_gated_clk               (nvdla_gated_clk)                 //|> w
  );

NV_NVDLA_BDMA_load u_load (
   .nvdla_core_clk                (nvdla_gated_clk)                 //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.bdma2mcif_rd_req_valid        (bdma2mcif_rd_req_valid)          //|> o
  ,.bdma2mcif_rd_req_ready        (bdma2mcif_rd_req_ready)          //|< i
  ,.bdma2mcif_rd_req_pd           (bdma2mcif_rd_req_pd[78:0])       //|> o
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,.bdma2cvif_rd_req_valid        (bdma2cvif_rd_req_valid)          //|> o
  ,.bdma2cvif_rd_req_ready        (bdma2cvif_rd_req_ready)          //|< i
  ,.bdma2cvif_rd_req_pd           (bdma2cvif_rd_req_pd[78:0])       //|> o
#endif
  ,.ld2st_wr_pvld                 (ld2st_wr_pvld)                   //|> w
  ,.ld2st_wr_prdy                 (ld2st_wr_prdy)                   //|< w
  ,.ld2st_wr_pd                   (ld2st_wr_pd[160:0])              //|> w
  ,.reg2dp_cmd_dst_ram_type       (reg2dp_cmd_dst_ram_type)         //|< w
  ,.reg2dp_cmd_interrupt          (reg2dp_cmd_interrupt)            //|< w
  ,.reg2dp_cmd_interrupt_ptr      (reg2dp_cmd_interrupt_ptr)        //|< w
  ,.reg2dp_cmd_src_ram_type       (reg2dp_cmd_src_ram_type)         //|< w
  ,.reg2dp_dst_addr_high_v8       (reg2dp_dst_addr_high_v8[31:0])   //|< w
  ,.reg2dp_dst_addr_low_v32       (reg2dp_dst_addr_low_v32[26:0])   //|< w
  ,.reg2dp_dst_line_stride        (reg2dp_dst_line_stride[26:0])    //|< w
  ,.reg2dp_dst_surf_stride        (reg2dp_dst_surf_stride[26:0])    //|< w
  ,.reg2dp_line_repeat_number     (reg2dp_line_repeat_number[23:0]) //|< w
  ,.reg2dp_line_size              (reg2dp_line_size[12:0])          //|< w
  ,.reg2dp_src_addr_high_v8       (reg2dp_src_addr_high_v8[31:0])   //|< w
  ,.reg2dp_src_addr_low_v32       (reg2dp_src_addr_low_v32[26:0])   //|< w
  ,.reg2dp_src_line_stride        (reg2dp_src_line_stride[26:0])    //|< w
  ,.reg2dp_src_surf_stride        (reg2dp_src_surf_stride[26:0])    //|< w
  ,.reg2dp_surf_repeat_number     (reg2dp_surf_repeat_number[23:0]) //|< w
  ,.csb2ld_vld                    (csb2ld_vld)                      //|< w
  ,.csb2ld_rdy                    (csb2ld_rdy)                      //|> w
  ,.ld2csb_grp0_dma_stall_inc     (ld2csb_grp0_dma_stall_inc)       //|> w
  ,.ld2csb_grp1_dma_stall_inc     (ld2csb_grp1_dma_stall_inc)       //|> w
  ,.ld2csb_idle                   (ld2csb_idle)                     //|> w
  ,.ld2st_wr_idle                 (ld2st_wr_idle)                   //|< w
  ,.st2ld_load_idle               (st2ld_load_idle)                 //|< w
  ,.ld2gate_slcg_en               (ld2gate_slcg_en)                 //|> w
  );

NV_NVDLA_BDMA_store u_store (
   .nvdla_core_clk                (nvdla_gated_clk)                 //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.mcif2bdma_rd_rsp_valid        (mcif2bdma_rd_rsp_valid)          //|< i
  ,.mcif2bdma_rd_rsp_ready        (mcif2bdma_rd_rsp_ready)          //|> o
  ,.mcif2bdma_rd_rsp_pd           (mcif2bdma_rd_rsp_pd[513:0])      //|< i
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,.cvif2bdma_rd_rsp_valid        (cvif2bdma_rd_rsp_valid)          //|< i
  ,.cvif2bdma_rd_rsp_ready        (cvif2bdma_rd_rsp_ready)          //|> o
  ,.cvif2bdma_rd_rsp_pd           (cvif2bdma_rd_rsp_pd[513:0])      //|< i
#endif
  ,.bdma2mcif_rd_cdt_lat_fifo_pop (bdma2mcif_rd_cdt_lat_fifo_pop)   //|> o
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,.bdma2cvif_rd_cdt_lat_fifo_pop (bdma2cvif_rd_cdt_lat_fifo_pop)   //|> o
#endif
  ,.bdma2mcif_wr_req_valid        (bdma2mcif_wr_req_valid)          //|> o
  ,.bdma2mcif_wr_req_ready        (bdma2mcif_wr_req_ready)          //|< i
  ,.bdma2mcif_wr_req_pd           (bdma2mcif_wr_req_pd[514:0])      //|> o
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,.bdma2cvif_wr_req_valid        (bdma2cvif_wr_req_valid)          //|> o
  ,.bdma2cvif_wr_req_ready        (bdma2cvif_wr_req_ready)          //|< i
  ,.bdma2cvif_wr_req_pd           (bdma2cvif_wr_req_pd[514:0])      //|> o
#endif
  ,.mcif2bdma_wr_rsp_complete     (mcif2bdma_wr_rsp_complete)       //|< i
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,.cvif2bdma_wr_rsp_complete     (cvif2bdma_wr_rsp_complete)       //|< i
#endif
  ,.ld2st_rd_pvld                 (ld2st_rd_pvld)                   //|< w
  ,.ld2st_rd_prdy                 (ld2st_rd_prdy)                   //|> w
  ,.ld2st_rd_pd                   (ld2st_rd_pd[160:0])              //|< w
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])             //|< i
  ,.st2ld_load_idle               (st2ld_load_idle)                 //|> w
  ,.st2csb_grp0_done              (st2csb_grp0_done)                //|> w
  ,.st2csb_grp1_done              (st2csb_grp1_done)                //|> w
  ,.st2csb_idle                   (st2csb_idle)                     //|> w
  ,.st2gate_slcg_en               (st2gate_slcg_en)                 //|> w
  ,.dma_write_stall_count         (dma_write_stall_count[31:0])     //|> w
  ,.dma_write_stall_count_cen     (dma_write_stall_count_cen)       //|< w
  );

NV_NVDLA_BDMA_cq u_cq (
   .nvdla_core_clk                (nvdla_gated_clk)                 //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.ld2st_wr_prdy                 (ld2st_wr_prdy)                   //|> w
  ,.ld2st_wr_idle                 (ld2st_wr_idle)                   //|> w
  ,.ld2st_wr_pvld                 (ld2st_wr_pvld)                   //|< w
  ,.ld2st_wr_pd                   (ld2st_wr_pd[160:0])              //|< w
  ,.ld2st_rd_prdy                 (ld2st_rd_prdy)                   //|< w
  ,.ld2st_rd_pvld                 (ld2st_rd_pvld)                   //|> w
  ,.ld2st_rd_pd                   (ld2st_rd_pd[160:0])              //|> w
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])             //|< i
  );

endmodule // NV_NVDLA_bdma

