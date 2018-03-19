// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_MRDMA_eg.v

#include "NV_NVDLA_SDP_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_SDP_MRDMA_eg (
   nvdla_core_clk               //|< i
  ,nvdla_core_rstn              //|< i
  ,pwrbus_ram_pd                //|< i
  ,op_load                      //|< i
  ,eg_done                      //|> o
  ,cq2eg_pd                     //|< i
  ,cq2eg_pvld                   //|< i
  ,cq2eg_prdy                   //|> o
  ,dma_rd_rsp_ram_type          //|> o
  ,dma_rd_rsp_pd                //|< i
  ,dma_rd_rsp_vld               //|< i
  ,dma_rd_rsp_rdy               //|> o
  ,dma_rd_cdt_lat_fifo_pop      //|> o
  ,sdp_mrdma2cmux_pd            //|> o
  ,sdp_mrdma2cmux_valid         //|> o
  ,sdp_mrdma2cmux_ready         //|< i
  ,reg2dp_src_ram_type          //|< i
  ,reg2dp_width                 //|< i
  ,reg2dp_height                //|< i
  ,reg2dp_in_precision          //|< i
  ,reg2dp_proc_precision        //|< i
  ,reg2dp_perf_nan_inf_count_en //|< i
  ,dp2reg_status_inf_input_num  //|> o
  ,dp2reg_status_nan_input_num  //|> o
  );

//&Catenate "NV_NVDLA_SDP_MRDMA_eg_ports.v";
input          nvdla_core_clk;
input          nvdla_core_rstn;
input   [31:0] pwrbus_ram_pd;
input          op_load;
output         eg_done;
input   [13:0] cq2eg_pd;
input          cq2eg_pvld;
output         cq2eg_prdy;
output         dma_rd_rsp_ram_type;
input  [NVDLA_DMA_RD_RSP-1:0] dma_rd_rsp_pd;
input          dma_rd_rsp_vld;
output         dma_rd_rsp_rdy;
output         dma_rd_cdt_lat_fifo_pop;
output [DP_DIN_DW+1:0] sdp_mrdma2cmux_pd;
output         sdp_mrdma2cmux_valid;
input          sdp_mrdma2cmux_ready;
input          reg2dp_src_ram_type;
input   [12:0] reg2dp_height;
input   [12:0] reg2dp_width;
input    [1:0] reg2dp_in_precision;
input    [1:0] reg2dp_proc_precision;
input          reg2dp_perf_nan_inf_count_en;
output  [31:0] dp2reg_status_inf_input_num;
output  [31:0] dp2reg_status_nan_input_num;

wire    [14:0] cmd2dat_dma_pd;
wire           cmd2dat_dma_prdy;
wire           cmd2dat_dma_pvld;
wire    [12:0] cmd2dat_spt_pd;
wire           cmd2dat_spt_prdy;
wire           cmd2dat_spt_pvld;
wire   [AM_DW-1:0] pfifo0_rd_pd;
wire           pfifo0_rd_prdy;
wire           pfifo0_rd_pvld;
wire   [AM_DW-1:0] pfifo1_rd_pd;
wire           pfifo1_rd_prdy;
wire           pfifo1_rd_pvld;
wire   [AM_DW-1:0] pfifo2_rd_pd;
wire           pfifo2_rd_prdy;
wire           pfifo2_rd_pvld;
wire   [AM_DW-1:0] pfifo3_rd_pd;
wire           pfifo3_rd_prdy;
wire           pfifo3_rd_pvld;
#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
wire   [AM_DW2-1:0] sfifo0_rd_pd;
wire           sfifo0_rd_prdy;
wire           sfifo0_rd_pvld;
wire   [AM_DW2-1:0] sfifo1_rd_pd;
wire           sfifo1_rd_prdy;
wire           sfifo1_rd_pvld;
#endif


NV_NVDLA_SDP_MRDMA_EG_cmd u_cmd (
   .nvdla_core_clk               (nvdla_core_clk)                   
  ,.nvdla_core_rstn              (nvdla_core_rstn)                  
  ,.pwrbus_ram_pd                (pwrbus_ram_pd[31:0])              
  ,.eg_done                      (eg_done)                          
  ,.cq2eg_pvld                   (cq2eg_pvld)                       
  ,.cq2eg_prdy                   (cq2eg_prdy)                       
  ,.cq2eg_pd                     (cq2eg_pd[13:0])                   
  ,.cmd2dat_spt_pvld             (cmd2dat_spt_pvld)                 
  ,.cmd2dat_spt_prdy             (cmd2dat_spt_prdy)                 
  ,.cmd2dat_spt_pd               (cmd2dat_spt_pd[12:0])             
  ,.cmd2dat_dma_pvld             (cmd2dat_dma_pvld)                 
  ,.cmd2dat_dma_prdy             (cmd2dat_dma_prdy)                 
  ,.cmd2dat_dma_pd               (cmd2dat_dma_pd[14:0])             
  ,.reg2dp_in_precision          (reg2dp_in_precision[1:0])         
  ,.reg2dp_proc_precision        (reg2dp_proc_precision[1:0])       
  ,.reg2dp_height                (reg2dp_height[12:0])              
  ,.reg2dp_width                 (reg2dp_width[12:0])               
  );

NV_NVDLA_SDP_MRDMA_EG_din u_din (
   .nvdla_core_clk               (nvdla_core_clk)                   
  ,.nvdla_core_rstn              (nvdla_core_rstn)                  
  ,.pwrbus_ram_pd                (pwrbus_ram_pd[31:0])              
  ,.reg2dp_src_ram_type          (reg2dp_src_ram_type)              
  ,.dma_rd_rsp_ram_type          (dma_rd_rsp_ram_type)              
  ,.dma_rd_rsp_pd                (dma_rd_rsp_pd[NVDLA_DMA_RD_RSP-1:0]) 
  ,.dma_rd_rsp_vld               (dma_rd_rsp_vld)                   
  ,.dma_rd_rsp_rdy               (dma_rd_rsp_rdy)                   
  ,.dma_rd_cdt_lat_fifo_pop      (dma_rd_cdt_lat_fifo_pop)          
  ,.cmd2dat_spt_pd               (cmd2dat_spt_pd[12:0])             
  ,.cmd2dat_spt_pvld             (cmd2dat_spt_pvld)                 
  ,.cmd2dat_spt_prdy             (cmd2dat_spt_prdy)                 
  ,.pfifo0_rd_pd                 (pfifo0_rd_pd[AM_DW-1:0])        
  ,.pfifo0_rd_pvld               (pfifo0_rd_pvld)                 
  ,.pfifo0_rd_prdy               (pfifo0_rd_prdy)                   
  ,.pfifo1_rd_pd                 (pfifo1_rd_pd[AM_DW-1:0])        
  ,.pfifo1_rd_pvld               (pfifo1_rd_pvld)                 
  ,.pfifo1_rd_prdy               (pfifo1_rd_prdy)                   
  ,.pfifo2_rd_pd                 (pfifo2_rd_pd[AM_DW-1:0])        
  ,.pfifo2_rd_pvld               (pfifo2_rd_pvld)                 
  ,.pfifo2_rd_prdy               (pfifo2_rd_prdy)                   
  ,.pfifo3_rd_pd                 (pfifo3_rd_pd[AM_DW-1:0])        
  ,.pfifo3_rd_pvld               (pfifo3_rd_pvld)                 
  ,.pfifo3_rd_prdy               (pfifo3_rd_prdy)                   
#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
  ,.sfifo0_rd_prdy               (sfifo0_rd_prdy)                 
  ,.sfifo1_rd_prdy               (sfifo1_rd_prdy)                 
  ,.sfifo0_rd_pd                 (sfifo0_rd_pd[AM_DW2-1:0])       
  ,.sfifo0_rd_pvld               (sfifo0_rd_pvld)                 
  ,.sfifo1_rd_pd                 (sfifo1_rd_pd[AM_DW2-1:0])       
  ,.sfifo1_rd_pvld               (sfifo1_rd_pvld)                 
#endif 
  );

NV_NVDLA_SDP_MRDMA_EG_dout u_dout (
   .nvdla_core_clk               (nvdla_core_clk)                 
  ,.nvdla_core_rstn              (nvdla_core_rstn)                
  ,.op_load                      (op_load)                          
  ,.eg_done                      (eg_done)                          
  ,.cmd2dat_dma_pvld             (cmd2dat_dma_pvld)               
  ,.cmd2dat_dma_prdy             (cmd2dat_dma_prdy)               
  ,.cmd2dat_dma_pd               (cmd2dat_dma_pd[14:0])           
  ,.pfifo0_rd_pvld               (pfifo0_rd_pvld)                 
  ,.pfifo0_rd_prdy               (pfifo0_rd_prdy)                 
  ,.pfifo0_rd_pd                 (pfifo0_rd_pd[AM_DW-1:0])        
  ,.pfifo1_rd_pvld               (pfifo1_rd_pvld)                 
  ,.pfifo1_rd_prdy               (pfifo1_rd_prdy)                 
  ,.pfifo1_rd_pd                 (pfifo1_rd_pd[AM_DW-1:0])        
  ,.pfifo2_rd_pvld               (pfifo2_rd_pvld)                 
  ,.pfifo2_rd_prdy               (pfifo2_rd_prdy)                 
  ,.pfifo2_rd_pd                 (pfifo2_rd_pd[AM_DW-1:0])        
  ,.pfifo3_rd_pvld               (pfifo3_rd_pvld)                 
  ,.pfifo3_rd_prdy               (pfifo3_rd_prdy)                 
  ,.pfifo3_rd_pd                 (pfifo3_rd_pd[AM_DW-1:0])        
#ifdef NVDLA_SDP_DATA_TYPE_INT16TO8
  ,.sfifo0_rd_pvld               (sfifo0_rd_pvld)                 
  ,.sfifo0_rd_prdy               (sfifo0_rd_prdy)                 
  ,.sfifo0_rd_pd                 (sfifo0_rd_pd[AM_DW2-1:0])       
  ,.sfifo1_rd_pvld               (sfifo1_rd_pvld)                 
  ,.sfifo1_rd_prdy               (sfifo1_rd_prdy)                 
  ,.sfifo1_rd_pd                 (sfifo1_rd_pd[AM_DW2-1:0])       
#endif
  ,.sdp_mrdma2cmux_valid         (sdp_mrdma2cmux_valid)             
  ,.sdp_mrdma2cmux_ready         (sdp_mrdma2cmux_ready)             
  ,.sdp_mrdma2cmux_pd            (sdp_mrdma2cmux_pd[DP_DIN_DW+1:0])     
  ,.reg2dp_height                (reg2dp_height[12:0])              
  ,.reg2dp_width                 (reg2dp_width[12:0])               
  ,.reg2dp_in_precision          (reg2dp_in_precision[1:0])         
  ,.reg2dp_proc_precision        (reg2dp_proc_precision[1:0])       
  ,.reg2dp_perf_nan_inf_count_en (reg2dp_perf_nan_inf_count_en)     
  ,.dp2reg_status_inf_input_num  (dp2reg_status_inf_input_num[31:0])
  ,.dp2reg_status_nan_input_num  (dp2reg_status_nan_input_num[31:0])
  );

endmodule // NV_NVDLA_SDP_MRDMA_eg

