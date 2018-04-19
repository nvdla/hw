// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_pdp.v

#include "NV_NVDLA_PDP_define.h"

module NV_NVDLA_pdp (
   dla_clk_ovr_on_sync           //|< i
  ,global_clk_ovr_on_sync        //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,nvdla_core_clk                //|< i
  ,nvdla_core_rstn               //|< i
  ,csb2pdp_rdma_req_pvld         //|< i
  ,csb2pdp_rdma_req_prdy         //|> o
  ,csb2pdp_rdma_req_pd           //|< i
  ,csb2pdp_req_pvld              //|< i
  ,csb2pdp_req_prdy              //|> o
  ,csb2pdp_req_pd                //|< i
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cvif2pdp_rd_rsp_valid         //|< i
  ,cvif2pdp_rd_rsp_ready         //|> o
  ,cvif2pdp_rd_rsp_pd            //|< i
  ,cvif2pdp_wr_rsp_complete      //|< i
  ,pdp2cvif_rd_cdt_lat_fifo_pop  //|> o
  ,pdp2cvif_rd_req_valid         //|> o
  ,pdp2cvif_rd_req_ready         //|< i
  ,pdp2cvif_rd_req_pd            //|> o
  ,pdp2cvif_wr_req_valid         //|> o
  ,pdp2cvif_wr_req_ready         //|< i
  ,pdp2cvif_wr_req_pd            //|> o
#endif
  ,mcif2pdp_rd_rsp_valid         //|< i
  ,mcif2pdp_rd_rsp_ready         //|> o
  ,mcif2pdp_rd_rsp_pd            //|< i
  ,mcif2pdp_wr_rsp_complete      //|< i
  ,pdp2csb_resp_valid            //|> o
  ,pdp2csb_resp_pd               //|> o
  ,pdp2glb_done_intr_pd          //|> o
  ,pdp2mcif_rd_cdt_lat_fifo_pop  //|> o
  ,pdp2mcif_rd_req_valid         //|> o
  ,pdp2mcif_rd_req_ready         //|< i
  ,pdp2mcif_rd_req_pd            //|> o
  ,pdp2mcif_wr_req_valid         //|> o
  ,pdp2mcif_wr_req_ready         //|< i
  ,pdp2mcif_wr_req_pd            //|> o
  ,pdp_rdma2csb_resp_valid       //|> o
  ,pdp_rdma2csb_resp_pd          //|> o
  ,pwrbus_ram_pd                 //|< i
  ,sdp2pdp_valid                 //|< i
  ,sdp2pdp_ready                 //|> o
  ,sdp2pdp_pd                    //|< i
  );
///////////////////////////////////////////////////////////////////////
input   dla_clk_ovr_on_sync;
input   global_clk_ovr_on_sync;
input   tmc2slcg_disable_clock_gating;

 input  nvdla_core_clk;   
 input  nvdla_core_rstn; 

 input         csb2pdp_rdma_req_pvld;
 output        csb2pdp_rdma_req_prdy;
 input  [62:0] csb2pdp_rdma_req_pd;

 input         csb2pdp_req_pvld;
 output        csb2pdp_req_prdy;
 input  [62:0] csb2pdp_req_pd;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
 input          cvif2pdp_rd_rsp_valid; 
 output         cvif2pdp_rd_rsp_ready; 
 input [NVDLA_PDP_MEM_RD_RSP-1:0] cvif2pdp_rd_rsp_pd;
 input  cvif2pdp_wr_rsp_complete;
 output  pdp2cvif_rd_cdt_lat_fifo_pop;

 output        pdp2cvif_rd_req_valid;
 input         pdp2cvif_rd_req_ready;
 output [NVDLA_MEM_ADDRESS_WIDTH+14:0] pdp2cvif_rd_req_pd;

 output         pdp2cvif_wr_req_valid;
 input          pdp2cvif_wr_req_ready;
 output [NVDLA_PDP_MEM_WR_REQ-1:0] pdp2cvif_wr_req_pd;
#endif

 input          mcif2pdp_rd_rsp_valid;
 output         mcif2pdp_rd_rsp_ready;
 input [NVDLA_PDP_MEM_RD_RSP-1:0] mcif2pdp_rd_rsp_pd;
 input  mcif2pdp_wr_rsp_complete;

 output        pdp2csb_resp_valid;
 output [33:0] pdp2csb_resp_pd;   


 output [1:0] pdp2glb_done_intr_pd;

 output  pdp2mcif_rd_cdt_lat_fifo_pop;
 output        pdp2mcif_rd_req_valid;
 input         pdp2mcif_rd_req_ready;
 output [NVDLA_MEM_ADDRESS_WIDTH+14:0] pdp2mcif_rd_req_pd;

 output         pdp2mcif_wr_req_valid;
 input          pdp2mcif_wr_req_ready;
 output [NVDLA_PDP_MEM_WR_REQ-1:0] pdp2mcif_wr_req_pd;

 output        pdp_rdma2csb_resp_valid;
 output [33:0] pdp_rdma2csb_resp_pd;   

 input [31:0] pwrbus_ram_pd;

 input          sdp2pdp_valid; 
 output         sdp2pdp_ready; 
 input  [NVDLA_PDP_ONFLY_INPUT_BW-1:0] sdp2pdp_pd;
///////////////////////////////////////////////////////////////////////

 wire        aver_pooling_en;
 wire [31:0] dp2reg_d0_perf_write_stall;
 wire [31:0] dp2reg_d1_perf_write_stall;
 wire        dp2reg_done;
 wire        mon_op_en_neg;
 wire        mon_op_en_pos;
 wire [NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT+11:0] nan_preproc_pd;
 wire        nan_preproc_prdy;
 wire        nan_preproc_pvld;
 wire        nvdla_op_gated_clk_core;
 wire        nvdla_op_gated_clk_wdma;
 wire [NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT-1:0] pdp_dp2wdma_pd;
 wire        pdp_dp2wdma_ready;
 wire        pdp_dp2wdma_valid;
 wire [NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT+11:0] pdp_rdma2dp_pd;
 wire        pdp_rdma2dp_ready;
 wire        pdp_rdma2dp_valid;
 wire        rdma2wdma_done;
 wire [12:0] reg2dp_cube_in_channel;
 wire [12:0] reg2dp_cube_in_height;
 wire [12:0] reg2dp_cube_in_width;
 wire [12:0] reg2dp_cube_out_channel;
 wire [12:0] reg2dp_cube_out_height;
 wire [12:0] reg2dp_cube_out_width;
 wire [31:0] reg2dp_cya;
 wire        reg2dp_dma_en;
 wire [31:0] reg2dp_dst_base_addr_high;
 wire [31:0] reg2dp_dst_base_addr_low;
 wire [31:0] reg2dp_dst_line_stride;
 wire        reg2dp_dst_ram_type;
 wire [31:0] reg2dp_dst_surface_stride;
 wire        reg2dp_flying_mode;
// wire  [1:0] reg2dp_input_data;
 wire        reg2dp_interrupt_ptr;
 wire  [3:0] reg2dp_kernel_height;
 wire  [3:0] reg2dp_kernel_stride_height;
 wire  [3:0] reg2dp_kernel_stride_width;
 wire  [3:0] reg2dp_kernel_width;
 wire        reg2dp_nan_to_zero;
 wire        reg2dp_op_en;
 wire  [2:0] reg2dp_pad_bottom;
 wire  [2:0] reg2dp_pad_left;
 wire  [2:0] reg2dp_pad_right;
 wire  [2:0] reg2dp_pad_top;
 wire [18:0] reg2dp_pad_value_1x;
 wire [18:0] reg2dp_pad_value_2x;
 wire [18:0] reg2dp_pad_value_3x;
 wire [18:0] reg2dp_pad_value_4x;
 wire [18:0] reg2dp_pad_value_5x;
 wire [18:0] reg2dp_pad_value_6x;
 wire [18:0] reg2dp_pad_value_7x;
 wire  [9:0] reg2dp_partial_width_in_first;
 wire  [9:0] reg2dp_partial_width_in_last;
 wire  [9:0] reg2dp_partial_width_in_mid;
 wire  [9:0] reg2dp_partial_width_out_first;
 wire  [9:0] reg2dp_partial_width_out_last;
 wire  [9:0] reg2dp_partial_width_out_mid;
 wire  [1:0] reg2dp_pooling_method;
 wire [16:0] reg2dp_recip_kernel_height;
 wire [16:0] reg2dp_recip_kernel_width;
 wire  [7:0] reg2dp_split_num;
 wire [31:0] reg2dp_src_base_addr_high;
 wire [31:0] reg2dp_src_base_addr_low;
 wire [31:0] reg2dp_src_line_stride;
 wire [31:0] reg2dp_src_surface_stride;
 wire  [2:0] slcg_op_en;
 reg  [31:0] mon_gap_between_layers;
 reg         mon_layer_end_flg;
 reg         mon_op_en_dly;
 reg  [12:0] mon_reg2dp_cube_in_channel;
 reg  [12:0] mon_reg2dp_cube_in_height;
 reg  [12:0] mon_reg2dp_cube_in_width;
 reg  [12:0] mon_reg2dp_cube_out_channel;
 reg  [12:0] mon_reg2dp_cube_out_height;
 reg  [12:0] mon_reg2dp_cube_out_width;
 reg         mon_reg2dp_flying_mode;
 reg   [3:0] mon_reg2dp_kernel_height;
 reg   [3:0] mon_reg2dp_kernel_stride_height;
 reg   [3:0] mon_reg2dp_kernel_stride_width;
 reg   [3:0] mon_reg2dp_kernel_width;
 reg         mon_reg2dp_nan_to_zero;
 reg   [2:0] mon_reg2dp_pad_bottom;
 reg   [2:0] mon_reg2dp_pad_left;
 reg   [2:0] mon_reg2dp_pad_right;
 reg   [2:0] mon_reg2dp_pad_top;
 reg   [9:0] mon_reg2dp_partial_width_in_first;
 reg   [9:0] mon_reg2dp_partial_width_in_last;
 reg   [9:0] mon_reg2dp_partial_width_in_mid;
 reg   [9:0] mon_reg2dp_partial_width_out_first;
 reg   [9:0] mon_reg2dp_partial_width_out_last;
 reg   [9:0] mon_reg2dp_partial_width_out_mid;
 reg   [1:0] mon_reg2dp_pooling_method;
 reg   [7:0] mon_reg2dp_split_num;
///////////////////////////////////////////////////////////////////////

 //=======================================
 //RDMA
 //---------------------------------------
 NV_NVDLA_PDP_rdma u_rdma (
    .rdma2wdma_done                 (rdma2wdma_done)               
   ,.nvdla_core_clk                 (nvdla_core_clk)               
   ,.nvdla_core_rstn                (nvdla_core_rstn)              
   ,.csb2pdp_rdma_req_pvld          (csb2pdp_rdma_req_pvld)        
   ,.csb2pdp_rdma_req_prdy          (csb2pdp_rdma_req_prdy)        
   ,.csb2pdp_rdma_req_pd            (csb2pdp_rdma_req_pd[62:0])    
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
   ,.cvif2pdp_rd_rsp_valid          (cvif2pdp_rd_rsp_valid)        
   ,.cvif2pdp_rd_rsp_ready          (cvif2pdp_rd_rsp_ready)        
   ,.cvif2pdp_rd_rsp_pd             (cvif2pdp_rd_rsp_pd)           
   ,.pdp2cvif_rd_cdt_lat_fifo_pop   (pdp2cvif_rd_cdt_lat_fifo_pop) 
   ,.pdp2cvif_rd_req_valid          (pdp2cvif_rd_req_valid)        
   ,.pdp2cvif_rd_req_ready          (pdp2cvif_rd_req_ready)        
   ,.pdp2cvif_rd_req_pd             (pdp2cvif_rd_req_pd)     
#endif
   ,.mcif2pdp_rd_rsp_valid          (mcif2pdp_rd_rsp_valid)        
   ,.mcif2pdp_rd_rsp_ready          (mcif2pdp_rd_rsp_ready)        
   ,.mcif2pdp_rd_rsp_pd             (mcif2pdp_rd_rsp_pd)           
   ,.pdp2mcif_rd_cdt_lat_fifo_pop   (pdp2mcif_rd_cdt_lat_fifo_pop) 
   ,.pdp2mcif_rd_req_valid          (pdp2mcif_rd_req_valid)        
   ,.pdp2mcif_rd_req_ready          (pdp2mcif_rd_req_ready)        
   ,.pdp2mcif_rd_req_pd             (pdp2mcif_rd_req_pd)     
   ,.pdp_rdma2csb_resp_valid        (pdp_rdma2csb_resp_valid)      
   ,.pdp_rdma2csb_resp_pd           (pdp_rdma2csb_resp_pd[33:0])   
   ,.pdp_rdma2dp_valid              (pdp_rdma2dp_valid)            
   ,.pdp_rdma2dp_ready              (pdp_rdma2dp_ready)            
   ,.pdp_rdma2dp_pd                 (pdp_rdma2dp_pd)               
   ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])          
   ,.dla_clk_ovr_on_sync            (dla_clk_ovr_on_sync)          
   ,.global_clk_ovr_on_sync         (global_clk_ovr_on_sync)       
   ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)
   );
 //=======================================
 //        SLCG gen unit
 //---------------------------------------
// assign fp16_en = reg2dp_input_data== 2'h2 ;
 assign aver_pooling_en = reg2dp_pooling_method== 2'h0 ;

 NV_NVDLA_PDP_slcg u_slcg_core (
    .dla_clk_ovr_on_sync            (dla_clk_ovr_on_sync)          
   ,.global_clk_ovr_on_sync         (global_clk_ovr_on_sync)       
   ,.nvdla_core_clk                 (nvdla_core_clk)               
   ,.nvdla_core_rstn                (nvdla_core_rstn)              
   ,.slcg_en_src                    (slcg_op_en[0])                
   ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)
   ,.nvdla_core_gated_clk           (nvdla_op_gated_clk_core)      
   );
 
 NV_NVDLA_PDP_slcg u_slcg_wdma (
    .dla_clk_ovr_on_sync            (dla_clk_ovr_on_sync)          
   ,.global_clk_ovr_on_sync         (global_clk_ovr_on_sync)       
   ,.nvdla_core_clk                 (nvdla_core_clk)               
   ,.nvdla_core_rstn                (nvdla_core_rstn)              
   ,.slcg_en_src                    (slcg_op_en[1])                
   ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)
   ,.nvdla_core_gated_clk           (nvdla_op_gated_clk_wdma)      
   );

// NV_NVDLA_PDP_slcg u_slcg_fp16 (
//    .dla_clk_ovr_on_sync            (dla_clk_ovr_on_sync)        
//   ,.global_clk_ovr_on_sync         (global_clk_ovr_on_sync)     
//   ,.nvdla_core_clk                 (nvdla_core_clk)             
//   ,.nvdla_core_rstn                (nvdla_core_rstn)            
//   ,.slcg_en_src                    (slcg_op_en[2] & fp16_en & aver_pooling_en)
//   ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)            
//   ,.nvdla_core_gated_clk           (nvdla_op_gated_clk_fp16)                  
//   );
 //=======================================
 //NaN control of RDMA output data
 //---------------------------------------
 NV_NVDLA_PDP_nan u_nan (
    .nvdla_core_clk                 (nvdla_op_gated_clk_core)    
   ,.nvdla_core_rstn                (nvdla_core_rstn)            
   ,.dp2reg_done                    (dp2reg_done)                
   ,.nan_preproc_prdy               (nan_preproc_prdy)           
   ,.pdp_rdma2dp_pd                 (pdp_rdma2dp_pd)       
   ,.pdp_rdma2dp_valid              (pdp_rdma2dp_valid)          
   ,.reg2dp_flying_mode             (reg2dp_flying_mode)         
   ,.reg2dp_nan_to_zero             (reg2dp_nan_to_zero)         
   ,.reg2dp_op_en                   (reg2dp_op_en)               
   ,.dp2reg_inf_input_num           () //dp2reg_inf_input_num[31:0]) 
   ,.dp2reg_nan_input_num           () //dp2reg_nan_input_num[31:0]) 
   ,.nan_preproc_pd                 (nan_preproc_pd)       
   ,.nan_preproc_pvld               (nan_preproc_pvld)           
   ,.pdp_rdma2dp_ready              (pdp_rdma2dp_ready)          
   );
//assign nan_preproc_pd = pdp_rdma2dp_pd;
//assign nan_preproc_pvld = pdp_rdma2dp_valid;
//assign pdp_rdma2dp_ready = nan_preproc_prdy;


 //=======================================
 //WDMA
 //---------------------------------------
 NV_NVDLA_PDP_wdma u_wdma (
    .nvdla_core_clk                 (nvdla_op_gated_clk_wdma)            
   ,.nvdla_core_rstn                (nvdla_core_rstn)                    
   ,.pdp2mcif_wr_req_valid          (pdp2mcif_wr_req_valid)              
   ,.pdp2mcif_wr_req_ready          (pdp2mcif_wr_req_ready)              
   ,.pdp2mcif_wr_req_pd             (pdp2mcif_wr_req_pd)                 
   ,.mcif2pdp_wr_rsp_complete       (mcif2pdp_wr_rsp_complete)           
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
   ,.pdp2cvif_wr_req_valid          (pdp2cvif_wr_req_valid)              
   ,.pdp2cvif_wr_req_ready          (pdp2cvif_wr_req_ready)              
   ,.pdp2cvif_wr_req_pd             (pdp2cvif_wr_req_pd)          
   ,.cvif2pdp_wr_rsp_complete       (cvif2pdp_wr_rsp_complete)           
#endif
   ,.pdp_dp2wdma_valid              (pdp_dp2wdma_valid)                  
   ,.pdp_dp2wdma_ready              (pdp_dp2wdma_ready)                  
   ,.pdp_dp2wdma_pd                 (pdp_dp2wdma_pd)               
   ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])                
   ,.pdp2glb_done_intr_pd           (pdp2glb_done_intr_pd[1:0])          
   ,.rdma2wdma_done                 (rdma2wdma_done)                     
   ,.reg2dp_cube_out_channel        (reg2dp_cube_out_channel[12:0])      
   ,.reg2dp_cube_out_height         (reg2dp_cube_out_height[12:0])       
   ,.reg2dp_cube_out_width          (reg2dp_cube_out_width[12:0])        
   ,.reg2dp_dma_en                  (reg2dp_dma_en)                      
   ,.reg2dp_dst_base_addr_high      (reg2dp_dst_base_addr_high[31:0])    
   ,.reg2dp_dst_base_addr_low      ({reg2dp_dst_base_addr_low[31:0]})
   ,.reg2dp_dst_line_stride        ({reg2dp_dst_line_stride[31:0]})
   ,.reg2dp_dst_surface_stride     ({reg2dp_dst_surface_stride[31:0]})
   ,.reg2dp_dst_ram_type            (reg2dp_dst_ram_type)                
   ,.reg2dp_flying_mode             (reg2dp_flying_mode)                 
   ,.reg2dp_interrupt_ptr           (reg2dp_interrupt_ptr)               
   ,.reg2dp_op_en                   (reg2dp_op_en)                       
   ,.reg2dp_partial_width_out_first (reg2dp_partial_width_out_first[9:0])
   ,.reg2dp_partial_width_out_last  (reg2dp_partial_width_out_last[9:0]) 
   ,.reg2dp_partial_width_out_mid   (reg2dp_partial_width_out_mid[9:0])  
   ,.reg2dp_split_num               (reg2dp_split_num[7:0])              
   ,.dp2reg_d0_perf_write_stall     (dp2reg_d0_perf_write_stall[31:0])   
   ,.dp2reg_d1_perf_write_stall     (dp2reg_d1_perf_write_stall[31:0])   
   ,.dp2reg_done                    (dp2reg_done)                        
   ,.nvdla_core_clk_orig            (nvdla_core_clk)                     
   );
 //========================================
 //PDP core instance
 //----------------------------------------
 NV_NVDLA_PDP_core u_core (
    .nvdla_core_clk                 (nvdla_op_gated_clk_core)             
   ,.nvdla_core_rstn                (nvdla_core_rstn)                     
   ,.datin_src_cfg                  (reg2dp_flying_mode)                  
   ,.dp2reg_done                    (dp2reg_done)                         
   ,.padding_h_cfg                  (reg2dp_pad_left[2:0])                
   ,.padding_v_cfg                  (reg2dp_pad_top[2:0])                 
   ,.pdp_dp2wdma_ready              (pdp_dp2wdma_ready)                   
   ,.pdp_rdma2dp_pd                 (nan_preproc_pd)                
   ,.pdp_rdma2dp_valid              (nan_preproc_pvld)                    
   ,.pooling_channel_cfg            (reg2dp_cube_out_channel[12:0])       
   ,.pooling_fwidth_cfg             (reg2dp_partial_width_in_first[9:0])  
   ,.pooling_lwidth_cfg             (reg2dp_partial_width_in_last[9:0])   
   ,.pooling_mwidth_cfg             (reg2dp_partial_width_in_mid[9:0])    
   ,.pooling_out_fwidth_cfg         (reg2dp_partial_width_out_first[9:0]) 
   ,.pooling_out_lwidth_cfg         (reg2dp_partial_width_out_last[9:0])  
   ,.pooling_out_mwidth_cfg         (reg2dp_partial_width_out_mid[9:0])   
   ,.pooling_size_h_cfg             (reg2dp_kernel_width[2:0])            
   ,.pooling_size_v_cfg             (reg2dp_kernel_height[2:0])           
   ,.pooling_splitw_num_cfg         (reg2dp_split_num[7:0])               
   ,.pooling_stride_h_cfg           (reg2dp_kernel_stride_width[3:0])     
   ,.pooling_stride_v_cfg           (reg2dp_kernel_stride_height[3:0])    
   ,.pooling_type_cfg               (reg2dp_pooling_method[1:0])          
   ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])                 
   ,.reg2dp_cube_in_channel         (reg2dp_cube_in_channel[12:0])        
   ,.reg2dp_cube_in_height          (reg2dp_cube_in_height[12:0])         
   ,.reg2dp_cube_in_width           (reg2dp_cube_in_width[12:0])          
   ,.reg2dp_cube_out_width          (reg2dp_cube_out_width[12:0])         
   ,.reg2dp_flying_mode             (reg2dp_flying_mode)                  
//   ,.reg2dp_input_data              (reg2dp_input_data[1:0])            
   ,.reg2dp_kernel_height           (reg2dp_kernel_height[2:0])           
   ,.reg2dp_kernel_stride_width     (reg2dp_kernel_stride_width[3:0])     
   ,.reg2dp_kernel_width            (reg2dp_kernel_width[2:0])            
   ,.reg2dp_op_en                   (reg2dp_op_en)                        
   ,.reg2dp_pad_bottom_cfg          (reg2dp_pad_bottom[2:0])              
   ,.reg2dp_pad_left                (reg2dp_pad_left[2:0])                
   ,.reg2dp_pad_right               (reg2dp_pad_right[2:0])               
   ,.reg2dp_pad_right_cfg           (reg2dp_pad_right[2:0])               
   ,.reg2dp_pad_top                 (reg2dp_pad_top[2:0])                 
   ,.reg2dp_pad_value_1x_cfg        (reg2dp_pad_value_1x[18:0])           
   ,.reg2dp_pad_value_2x_cfg        (reg2dp_pad_value_2x[18:0])           
   ,.reg2dp_pad_value_3x_cfg        (reg2dp_pad_value_3x[18:0])           
   ,.reg2dp_pad_value_4x_cfg        (reg2dp_pad_value_4x[18:0])           
   ,.reg2dp_pad_value_5x_cfg        (reg2dp_pad_value_5x[18:0])           
   ,.reg2dp_pad_value_6x_cfg        (reg2dp_pad_value_6x[18:0])           
   ,.reg2dp_pad_value_7x_cfg        (reg2dp_pad_value_7x[18:0])           
   ,.reg2dp_partial_width_out_first (reg2dp_partial_width_out_first[9:0]) 
   ,.reg2dp_partial_width_out_last  (reg2dp_partial_width_out_last[9:0])  
   ,.reg2dp_partial_width_out_mid   (reg2dp_partial_width_out_mid[9:0]) 
   ,.reg2dp_recip_height_cfg        (reg2dp_recip_kernel_height[16:0])  
   ,.reg2dp_recip_width_cfg         (reg2dp_recip_kernel_width[16:0])   
   ,.sdp2pdp_pd                     (sdp2pdp_pd)                        
   ,.sdp2pdp_valid                  (sdp2pdp_valid)                     
   ,.pdp_dp2wdma_pd                 (pdp_dp2wdma_pd)                    
   ,.pdp_dp2wdma_valid              (pdp_dp2wdma_valid)                 
   ,.pdp_rdma2dp_ready              (nan_preproc_prdy)                  
   ,.sdp2pdp_ready                  (sdp2pdp_ready)                     
   );
 //=======================================
 //CONFIG instance
 //rdma has seperate config register, while wdma share with core
 //---------------------------------------
 NV_NVDLA_PDP_reg u_reg (
    .nvdla_core_clk                 (nvdla_core_clk)                  
   ,.nvdla_core_rstn                (nvdla_core_rstn)                 
   ,.csb2pdp_req_pd                 (csb2pdp_req_pd[62:0])            
   ,.csb2pdp_req_pvld               (csb2pdp_req_pvld)                
   ,.dp2reg_d0_perf_write_stall     (dp2reg_d0_perf_write_stall[31:0])
   ,.dp2reg_d1_perf_write_stall     (dp2reg_d1_perf_write_stall[31:0])
   ,.dp2reg_done                    (dp2reg_done)                     
   ,.dp2reg_inf_input_num           (32'd0)//dp2reg_inf_input_num[31:0])  
   ,.dp2reg_nan_input_num           (32'd0)//dp2reg_nan_input_num[31:0])  
   ,.dp2reg_nan_output_num          (32'd0)//dp2reg_nan_output_num[31:0]) 
   ,.csb2pdp_req_prdy               (csb2pdp_req_prdy)                
   ,.pdp2csb_resp_pd                (pdp2csb_resp_pd[33:0])           
   ,.pdp2csb_resp_valid             (pdp2csb_resp_valid)              
   ,.reg2dp_cube_in_channel         (reg2dp_cube_in_channel[12:0])    
   ,.reg2dp_cube_in_height          (reg2dp_cube_in_height[12:0])     
   ,.reg2dp_cube_in_width           (reg2dp_cube_in_width[12:0])      
   ,.reg2dp_cube_out_channel        (reg2dp_cube_out_channel[12:0])   
   ,.reg2dp_cube_out_height         (reg2dp_cube_out_height[12:0])    
   ,.reg2dp_cube_out_width          (reg2dp_cube_out_width[12:0])     
   ,.reg2dp_cya                     (reg2dp_cya[31:0])                
   ,.reg2dp_dma_en                  (reg2dp_dma_en)                   
   ,.reg2dp_dst_base_addr_high      (reg2dp_dst_base_addr_high[31:0]) 
   ,.reg2dp_dst_base_addr_low       (reg2dp_dst_base_addr_low[31:0])  
   ,.reg2dp_dst_line_stride         (reg2dp_dst_line_stride[31:0])    
   ,.reg2dp_dst_ram_type            (reg2dp_dst_ram_type)             
   ,.reg2dp_dst_surface_stride      (reg2dp_dst_surface_stride[31:0]) 
   ,.reg2dp_flying_mode             (reg2dp_flying_mode)              
   ,.reg2dp_input_data              ()                    //|> w
   ,.reg2dp_interrupt_ptr           (reg2dp_interrupt_ptr)            
   ,.reg2dp_kernel_height           (reg2dp_kernel_height[3:0])       
   ,.reg2dp_kernel_stride_height    (reg2dp_kernel_stride_height[3:0])
   ,.reg2dp_kernel_stride_width     (reg2dp_kernel_stride_width[3:0]) 
   ,.reg2dp_kernel_width            (reg2dp_kernel_width[3:0])        
   ,.reg2dp_nan_to_zero             (reg2dp_nan_to_zero)              
   ,.reg2dp_op_en                   (reg2dp_op_en)                    
   ,.reg2dp_pad_bottom              (reg2dp_pad_bottom[2:0])          
   ,.reg2dp_pad_left                (reg2dp_pad_left[2:0])            
   ,.reg2dp_pad_right               (reg2dp_pad_right[2:0])           
   ,.reg2dp_pad_top                 (reg2dp_pad_top[2:0])             
   ,.reg2dp_pad_value_1x            (reg2dp_pad_value_1x[18:0])       
   ,.reg2dp_pad_value_2x            (reg2dp_pad_value_2x[18:0])       
   ,.reg2dp_pad_value_3x            (reg2dp_pad_value_3x[18:0])       
   ,.reg2dp_pad_value_4x            (reg2dp_pad_value_4x[18:0])       
   ,.reg2dp_pad_value_5x            (reg2dp_pad_value_5x[18:0])       
   ,.reg2dp_pad_value_6x            (reg2dp_pad_value_6x[18:0])       
   ,.reg2dp_pad_value_7x            (reg2dp_pad_value_7x[18:0])       
   ,.reg2dp_partial_width_in_first  (reg2dp_partial_width_in_first[9:0])  
   ,.reg2dp_partial_width_in_last   (reg2dp_partial_width_in_last[9:0])   
   ,.reg2dp_partial_width_in_mid    (reg2dp_partial_width_in_mid[9:0])    
   ,.reg2dp_partial_width_out_first (reg2dp_partial_width_out_first[9:0]) 
   ,.reg2dp_partial_width_out_last  (reg2dp_partial_width_out_last[9:0])  
   ,.reg2dp_partial_width_out_mid   (reg2dp_partial_width_out_mid[9:0])   
   ,.reg2dp_pooling_method          (reg2dp_pooling_method[1:0])          
   ,.reg2dp_recip_kernel_height     (reg2dp_recip_kernel_height[16:0])    
   ,.reg2dp_recip_kernel_width      (reg2dp_recip_kernel_width[16:0])     
   ,.reg2dp_split_num               (reg2dp_split_num[7:0])               
   ,.reg2dp_src_base_addr_high      (reg2dp_src_base_addr_high[31:0])     
   ,.reg2dp_src_base_addr_low       (reg2dp_src_base_addr_low[31:0])      
   ,.reg2dp_src_line_stride         (reg2dp_src_line_stride[31:0])        
   ,.reg2dp_src_surface_stride      (reg2dp_src_surface_stride[31:0])     
   ,.slcg_op_en                     (slcg_op_en[2:0])                     
   );

// //==============
// //OBS signals
// //==============
// //assign obs_bus_cdp_core_clk = nvdla_core_clk;
// //assign obs_bus_cdp_core_rstn = nvdla_core_rstn;
// assign obs_bus_pdp_csb_req_vld = csb2pdp_req_pvld; 
// assign obs_bus_pdp_csb_req_rdy = csb2pdp_req_prdy;   
// assign obs_bus_pdp_rdma_mc_rd_req_vld = pdp2mcif_rd_req_valid;
// assign obs_bus_pdp_rdma_mc_rd_req_rdy = pdp2mcif_rd_req_ready;
// assign obs_bus_pdp_rdma_cv_rd_req_vld = pdp2cvif_rd_req_valid;
// assign obs_bus_pdp_rdma_cv_rd_req_rdy = pdp2cvif_rd_req_ready;
// assign obs_bus_pdp_rdma_mc_rd_rsp_vld = mcif2pdp_rd_rsp_valid;
// assign obs_bus_pdp_rdma_mc_rd_rsp_rdy = mcif2pdp_rd_rsp_ready;
// assign obs_bus_pdp_rdma_cv_rd_rsp_vld = cvif2pdp_rd_rsp_valid;
// assign obs_bus_pdp_rdma_cv_rd_rsp_rdy = cvif2pdp_rd_rsp_ready;
// assign obs_bus_pdp_wdma_mc_wr_vld = pdp2mcif_wr_req_valid;
// assign obs_bus_pdp_wdma_mc_wr_rdy = pdp2mcif_wr_req_ready;
// assign obs_bus_pdp_wdma_cv_wr_vld = pdp2cvif_wr_req_valid;
// assign obs_bus_pdp_wdma_cv_wr_rdy = pdp2cvif_wr_req_ready;

 //==============
 //cfg assertion
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
  nv_assert_never #(0,0,"PDPCore pad_value setting issue: 2X != 1X * 2")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, aver_pooling_en & reg2dp_op_en & (reg2dp_pad_value_2x != $signed(reg2dp_pad_value_1x) * $signed({1'b0,4'd2}))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore pad_value setting issue: 3X != 1X * 3")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, aver_pooling_en & reg2dp_op_en & (reg2dp_pad_value_3x != $signed(reg2dp_pad_value_1x) * $signed({1'b0,4'd3}))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore pad_value setting issue: 4X != 1X * 4")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, aver_pooling_en & reg2dp_op_en & (reg2dp_pad_value_4x != $signed(reg2dp_pad_value_1x) * $signed({1'b0,4'd4}))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore pad_value setting issue: 5X != 1X * 5")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, aver_pooling_en & reg2dp_op_en & (reg2dp_pad_value_5x != $signed(reg2dp_pad_value_1x) * $signed({1'b0,4'd5}))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore pad_value setting issue: 6X != 1X * 6")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, aver_pooling_en & reg2dp_op_en & (reg2dp_pad_value_6x != $signed(reg2dp_pad_value_1x) * $signed({1'b0,4'd6}))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"PDPCore pad_value setting issue: 7X != 1X * 7")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, aver_pooling_en & reg2dp_op_en & (reg2dp_pad_value_7x != $signed(reg2dp_pad_value_1x) * $signed({1'b0,4'd7}))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
////////////////////////////////
////pdp cube_out_width setting, limited by line buffer size
////////////////////////////////
////non-split mode
////two sub-cube split mode
////more than two sub-cube split mode
//////////////////////////////
//overlap vs partial width/partial_width in
//a) when split into 2 sub-cube, that is split_num=1,
//when kernel >=kernel_stride, overlap = kernel - kernel_stride, overlap <= width_first;
//when kernel < kernel_stride, overlap = kernel_stride - kernel, overlap < width_last , for this item, i think current constrain has cover it. because subcube num in output side equals to that in input side, and partial out first/right are all >=1 element;
//b) split_num>=2
//when kernel >=kernel_stride, overlap = kernel - kernel_stride, overlap <= min(width_first, width_mid);
//when kernel < kernel_stride, overlap = kernel_stride - kernel, overlap < min(width_mid, width_last) , for this item, i think current constrain has cover it. because subcube num in output side equals to that in input side, and partial out first/mid/right are all >=1 element;
//////////////////////////////
//split into 2 sub-cube
////split into more than 2 sub-cube

//==============
//function points
//==============

///////////////
//1*1*1 cube output
///////////////
//1*1*1 cube output for nonsplit mode

////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    reg funcpoint_cover_off;
//    initial begin
//        if ( $test$plusargs( "cover_off" ) ) begin
//            funcpoint_cover_off = 1'b1;
//        end else begin
//            funcpoint_cover_off = 1'b0;
//        end
//    end
//
//    property PDP_min_cube_out__1_1_1_cube_out_fp16_nonsplit_average_pooling__0_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        reg2dp_op_en & (reg2dp_split_num==8'd0) & (reg2dp_input_data== 2'h2 ) & (reg2dp_pooling_method== 2'h0 ) & (~(|reg2dp_cube_out_width)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
//    endproperty
//    // Cover 0 : "reg2dp_op_en & (reg2dp_split_num==8'd0) & (reg2dp_input_data== 2'h2 ) & (reg2dp_pooling_method== 2'h0 ) & (~(|reg2dp_cube_out_width)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
//    FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_fp16_nonsplit_average_pooling__0_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_fp16_nonsplit_average_pooling__0_cov);
//
//  `endif
//`endif
////VCS coverage on

////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_min_cube_out__1_1_1_cube_out_int16_nonsplit_average_pooling__1_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        reg2dp_op_en & (reg2dp_split_num==8'd0) & (reg2dp_input_data== 2'h1 ) & (reg2dp_pooling_method== 2'h0 ) & (~(|reg2dp_cube_out_width)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
//    endproperty
//    // Cover 1 : "reg2dp_op_en & (reg2dp_split_num==8'd0) & (reg2dp_input_data== 2'h1 ) & (reg2dp_pooling_method== 2'h0 ) & (~(|reg2dp_cube_out_width)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
//    FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_int16_nonsplit_average_pooling__1_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_int16_nonsplit_average_pooling__1_cov);
//
//  `endif
//`endif
////VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_min_cube_out__1_1_1_cube_out_int8_nonsplit_average_pooling__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        reg2dp_op_en & (reg2dp_split_num==8'd0) &  (reg2dp_pooling_method== 2'h0 ) & (~(|reg2dp_cube_out_width)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
    endproperty
    // Cover 2 : "reg2dp_op_en & (reg2dp_split_num==8'd0) & (reg2dp_pooling_method== 2'h0 ) & (~(|reg2dp_cube_out_width)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
    FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_int8_nonsplit_average_pooling__2_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_int8_nonsplit_average_pooling__2_cov);

  `endif
`endif
//VCS coverage on

////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_min_cube_out__1_1_1_cube_out_fp16_nonsplit_max_pooling__3_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        reg2dp_op_en & (reg2dp_split_num==8'd0) & (reg2dp_input_data== 2'h2 ) & (reg2dp_pooling_method== 2'h1 ) & (~(|reg2dp_cube_out_width)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
//    endproperty
//    // Cover 3 : "reg2dp_op_en & (reg2dp_split_num==8'd0) & (reg2dp_input_data== 2'h2 ) & (reg2dp_pooling_method== 2'h1 ) & (~(|reg2dp_cube_out_width)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
//    FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_fp16_nonsplit_max_pooling__3_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_fp16_nonsplit_max_pooling__3_cov);
//
//  `endif
//`endif
////VCS coverage on
//
////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_min_cube_out__1_1_1_cube_out_int16_nonsplit_max_pooling__4_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        reg2dp_op_en & (reg2dp_split_num==8'd0) & (reg2dp_input_data== 2'h1 ) & (reg2dp_pooling_method== 2'h1 ) & (~(|reg2dp_cube_out_width)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
//    endproperty
//    // Cover 4 : "reg2dp_op_en & (reg2dp_split_num==8'd0) & (reg2dp_input_data== 2'h1 ) & (reg2dp_pooling_method== 2'h1 ) & (~(|reg2dp_cube_out_width)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
//    FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_int16_nonsplit_max_pooling__4_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_int16_nonsplit_max_pooling__4_cov);
//
//  `endif
//`endif
////VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_min_cube_out__1_1_1_cube_out_int8_nonsplit_max_pooling__5_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        reg2dp_op_en & (reg2dp_split_num==8'd0) & (reg2dp_pooling_method== 2'h1 ) & (~(|reg2dp_cube_out_width)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
    endproperty
    // Cover 5 : "reg2dp_op_en & (reg2dp_split_num==8'd0) & (reg2dp_pooling_method== 2'h1 ) & (~(|reg2dp_cube_out_width)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
    FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_int8_nonsplit_max_pooling__5_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_int8_nonsplit_max_pooling__5_cov);

  `endif
`endif
//VCS coverage on

////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_min_cube_out__1_1_1_cube_out_fp16_nonsplit_min_pooling__6_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        reg2dp_op_en & (reg2dp_split_num==8'd0) & (reg2dp_input_data== 2'h2 ) & (reg2dp_pooling_method== 2'h2 ) & (~(|reg2dp_cube_out_width)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
//    endproperty
//    // Cover 6 : "reg2dp_op_en & (reg2dp_split_num==8'd0) & (reg2dp_input_data== 2'h2 ) & (reg2dp_pooling_method== 2'h2 ) & (~(|reg2dp_cube_out_width)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
//    FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_fp16_nonsplit_min_pooling__6_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_fp16_nonsplit_min_pooling__6_cov);
//
//  `endif
//`endif
////VCS coverage on
//
////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_min_cube_out__1_1_1_cube_out_int16_nonsplit_min_pooling__7_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        reg2dp_op_en & (reg2dp_split_num==8'd0) & (reg2dp_input_data== 2'h1 ) & (reg2dp_pooling_method== 2'h2 ) & (~(|reg2dp_cube_out_width)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
//    endproperty
//    // Cover 7 : "reg2dp_op_en & (reg2dp_split_num==8'd0) & (reg2dp_input_data== 2'h1 ) & (reg2dp_pooling_method== 2'h2 ) & (~(|reg2dp_cube_out_width)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
//    FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_int16_nonsplit_min_pooling__7_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_int16_nonsplit_min_pooling__7_cov);
//
//  `endif
//`endif
////VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_min_cube_out__1_1_1_cube_out_int8_nonsplit_min_pooling__8_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        reg2dp_op_en & (reg2dp_split_num==8'd0) & (reg2dp_pooling_method== 2'h2 ) & (~(|reg2dp_cube_out_width)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
    endproperty
    // Cover 8 : "reg2dp_op_en & (reg2dp_split_num==8'd0) & (reg2dp_pooling_method== 2'h2 ) & (~(|reg2dp_cube_out_width)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
    FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_int8_nonsplit_min_pooling__8_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_int8_nonsplit_min_pooling__8_cov);

  `endif
`endif
//VCS coverage on


////1*1*1 cube output for split 2 mode
////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_min_cube_out__1_1_1_cube_out_fp16_split2_average_pooling__9_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        reg2dp_op_en & (reg2dp_split_num==8'd1) & (reg2dp_input_data== 2'h2 ) & (reg2dp_pooling_method== 2'h0 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
//    endproperty
//    // Cover 9 : "reg2dp_op_en & (reg2dp_split_num==8'd1) & (reg2dp_input_data== 2'h2 ) & (reg2dp_pooling_method== 2'h0 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
//    FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_fp16_split2_average_pooling__9_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_fp16_split2_average_pooling__9_cov);
//
//  `endif
//`endif
////VCS coverage on
//
////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_min_cube_out__1_1_1_cube_out_int16_split2_average_pooling__10_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        reg2dp_op_en & (reg2dp_split_num==8'd1) & (reg2dp_input_data== 2'h1 ) & (reg2dp_pooling_method== 2'h0 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
//    endproperty
//    // Cover 10 : "reg2dp_op_en & (reg2dp_split_num==8'd1) & (reg2dp_input_data== 2'h1 ) & (reg2dp_pooling_method== 2'h0 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
//    FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_int16_split2_average_pooling__10_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_int16_split2_average_pooling__10_cov);
//
//  `endif
//`endif
////VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_min_cube_out__1_1_1_cube_out_int8_split2_average_pooling__11_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        reg2dp_op_en & (reg2dp_split_num==8'd1) & (reg2dp_pooling_method== 2'h0 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
    endproperty
    // Cover 11 : "reg2dp_op_en & (reg2dp_split_num==8'd1) & (reg2dp_pooling_method== 2'h0 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
    FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_int8_split2_average_pooling__11_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_int8_split2_average_pooling__11_cov);

  `endif
`endif
//VCS coverage on

////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_min_cube_out__1_1_1_cube_out_fp16_split2_max_pooling__12_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        reg2dp_op_en & (reg2dp_split_num==8'd1) & (reg2dp_input_data== 2'h2 ) & (reg2dp_pooling_method== 2'h1 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
//    endproperty
//    // Cover 12 : "reg2dp_op_en & (reg2dp_split_num==8'd1) & (reg2dp_input_data== 2'h2 ) & (reg2dp_pooling_method== 2'h1 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
//    FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_fp16_split2_max_pooling__12_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_fp16_split2_max_pooling__12_cov);
//
//  `endif
//`endif
////VCS coverage on
//
////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_min_cube_out__1_1_1_cube_out_int16_split2_max_pooling__13_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        reg2dp_op_en & (reg2dp_split_num==8'd1) & (reg2dp_input_data== 2'h1 ) & (reg2dp_pooling_method== 2'h1 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
//    endproperty
//    // Cover 13 : "reg2dp_op_en & (reg2dp_split_num==8'd1) & (reg2dp_input_data== 2'h1 ) & (reg2dp_pooling_method== 2'h1 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
//    FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_int16_split2_max_pooling__13_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_int16_split2_max_pooling__13_cov);
//
//  `endif
//`endif
////VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_min_cube_out__1_1_1_cube_out_int8_split2_max_pooling__14_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        reg2dp_op_en & (reg2dp_split_num==8'd1) & (reg2dp_pooling_method== 2'h1 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
    endproperty
    // Cover 14 : "reg2dp_op_en & (reg2dp_split_num==8'd1) & (reg2dp_pooling_method== 2'h1 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
    FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_int8_split2_max_pooling__14_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_int8_split2_max_pooling__14_cov);

  `endif
`endif
//VCS coverage on

// //VCS coverage off
// `ifndef DISABLE_FUNCPOINT
//   `ifdef ENABLE_FUNCPOINT
// 
//     property PDP_min_cube_out__1_1_1_cube_out_fp16_split2_min_pooling__15_cov;
//         disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//         @(posedge nvdla_core_clk)
//         reg2dp_op_en & (reg2dp_split_num==8'd1) & (reg2dp_input_data== 2'h2 ) & (reg2dp_pooling_method== 2'h2 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
//     endproperty
//     // Cover 15 : "reg2dp_op_en & (reg2dp_split_num==8'd1) & (reg2dp_input_data== 2'h2 ) & (reg2dp_pooling_method== 2'h2 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
//     FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_fp16_split2_min_pooling__15_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_fp16_split2_min_pooling__15_cov);
// 
//   `endif
// `endif
// //VCS coverage on
// 
// //VCS coverage off
// `ifndef DISABLE_FUNCPOINT
//   `ifdef ENABLE_FUNCPOINT
// 
//     property PDP_min_cube_out__1_1_1_cube_out_int16_split2_min_pooling__16_cov;
//         disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//         @(posedge nvdla_core_clk)
//         reg2dp_op_en & (reg2dp_split_num==8'd1) & (reg2dp_input_data== 2'h1 ) & (reg2dp_pooling_method== 2'h2 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
//     endproperty
//     // Cover 16 : "reg2dp_op_en & (reg2dp_split_num==8'd1) & (reg2dp_input_data== 2'h1 ) & (reg2dp_pooling_method== 2'h2 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
//     FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_int16_split2_min_pooling__16_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_int16_split2_min_pooling__16_cov);
// 
//   `endif
// `endif
// //VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_min_cube_out__1_1_1_cube_out_int8_split2_min_pooling__17_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        reg2dp_op_en & (reg2dp_split_num==8'd1) & (reg2dp_pooling_method== 2'h2 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
    endproperty
    // Cover 17 : "reg2dp_op_en & (reg2dp_split_num==8'd1) & (reg2dp_pooling_method== 2'h2 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
    FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_int8_split2_min_pooling__17_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_int8_split2_min_pooling__17_cov);

  `endif
`endif
//VCS coverage on


//1*1*1 cube output for split >2 mode
// //VCS coverage off
// `ifndef DISABLE_FUNCPOINT
//   `ifdef ENABLE_FUNCPOINT
// 
//     property PDP_min_cube_out__1_1_1_cube_out_fp16_split3_average_pooling__18_cov;
//         disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//         @(posedge nvdla_core_clk)
//         reg2dp_op_en & (reg2dp_split_num>=8'd2) & (reg2dp_input_data== 2'h2 ) & (reg2dp_pooling_method== 2'h0 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_partial_width_out_mid)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
//     endproperty
//     // Cover 18 : "reg2dp_op_en & (reg2dp_split_num>=8'd2) & (reg2dp_input_data== 2'h2 ) & (reg2dp_pooling_method== 2'h0 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_partial_width_out_mid)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
//     FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_fp16_split3_average_pooling__18_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_fp16_split3_average_pooling__18_cov);
// 
//   `endif
// `endif
// //VCS coverage on
// 
// //VCS coverage off
// `ifndef DISABLE_FUNCPOINT
//   `ifdef ENABLE_FUNCPOINT
// 
//     property PDP_min_cube_out__1_1_1_cube_out_int16_split3_average_pooling__19_cov;
//         disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//         @(posedge nvdla_core_clk)
//         reg2dp_op_en & (reg2dp_split_num>=8'd2) & (reg2dp_input_data== 2'h1 ) & (reg2dp_pooling_method== 2'h0 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_partial_width_out_mid)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
//     endproperty
//     // Cover 19 : "reg2dp_op_en & (reg2dp_split_num>=8'd2) & (reg2dp_input_data== 2'h1 ) & (reg2dp_pooling_method== 2'h0 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_partial_width_out_mid)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
//     FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_int16_split3_average_pooling__19_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_int16_split3_average_pooling__19_cov);
// 
//   `endif
// `endif
// //VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_min_cube_out__1_1_1_cube_out_int8_split3_average_pooling__20_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        reg2dp_op_en & (reg2dp_split_num>=8'd2) & (reg2dp_pooling_method== 2'h0 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_partial_width_out_mid)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
    endproperty
    // Cover 20 : "reg2dp_op_en & (reg2dp_split_num>=8'd2) & (reg2dp_pooling_method== 2'h0 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_partial_width_out_mid)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
    FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_int8_split3_average_pooling__20_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_int8_split3_average_pooling__20_cov);

  `endif
`endif
//VCS coverage on

// //VCS coverage off
// `ifndef DISABLE_FUNCPOINT
//   `ifdef ENABLE_FUNCPOINT
// 
//     property PDP_min_cube_out__1_1_1_cube_out_fp16_split3_max_pooling__21_cov;
//         disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//         @(posedge nvdla_core_clk)
//         reg2dp_op_en & (reg2dp_split_num>=8'd2) & (reg2dp_input_data== 2'h2 ) & (reg2dp_pooling_method== 2'h1 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_partial_width_out_mid)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
//     endproperty
//     // Cover 21 : "reg2dp_op_en & (reg2dp_split_num>=8'd2) & (reg2dp_input_data== 2'h2 ) & (reg2dp_pooling_method== 2'h1 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_partial_width_out_mid)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
//     FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_fp16_split3_max_pooling__21_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_fp16_split3_max_pooling__21_cov);
// 
//   `endif
// `endif
// //VCS coverage on
// 
// //VCS coverage off
// `ifndef DISABLE_FUNCPOINT
//   `ifdef ENABLE_FUNCPOINT
// 
//     property PDP_min_cube_out__1_1_1_cube_out_int16_split3_max_pooling__22_cov;
//         disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//         @(posedge nvdla_core_clk)
//         reg2dp_op_en & (reg2dp_split_num>=8'd2) & (reg2dp_input_data== 2'h1 ) & (reg2dp_pooling_method== 2'h1 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_partial_width_out_mid)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
//     endproperty
//     // Cover 22 : "reg2dp_op_en & (reg2dp_split_num>=8'd2) & (reg2dp_input_data== 2'h1 ) & (reg2dp_pooling_method== 2'h1 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_partial_width_out_mid)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
//     FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_int16_split3_max_pooling__22_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_int16_split3_max_pooling__22_cov);
// 
//   `endif
// `endif
// //VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_min_cube_out__1_1_1_cube_out_int8_split3_max_pooling__23_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        reg2dp_op_en & (reg2dp_split_num>=8'd2) & (reg2dp_pooling_method== 2'h1 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_partial_width_out_mid)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
    endproperty
    // Cover 23 : "reg2dp_op_en & (reg2dp_split_num>=8'd2) & (reg2dp_pooling_method== 2'h1 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_partial_width_out_mid)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
    FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_int8_split3_max_pooling__23_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_int8_split3_max_pooling__23_cov);

  `endif
`endif
//VCS coverage on

// //VCS coverage off
// `ifndef DISABLE_FUNCPOINT
//   `ifdef ENABLE_FUNCPOINT
// 
//     property PDP_min_cube_out__1_1_1_cube_out_fp16_split3_min_pooling__24_cov;
//         disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//         @(posedge nvdla_core_clk)
//         reg2dp_op_en & (reg2dp_split_num>=8'd2) & (reg2dp_input_data== 2'h2 ) & (reg2dp_pooling_method== 2'h2 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_partial_width_out_mid)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
//     endproperty
//     // Cover 24 : "reg2dp_op_en & (reg2dp_split_num>=8'd2) & (reg2dp_input_data== 2'h2 ) & (reg2dp_pooling_method== 2'h2 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_partial_width_out_mid)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
//     FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_fp16_split3_min_pooling__24_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_fp16_split3_min_pooling__24_cov);
// 
//   `endif
// `endif
// //VCS coverage on
// 
// //VCS coverage off
// `ifndef DISABLE_FUNCPOINT
//   `ifdef ENABLE_FUNCPOINT
// 
//     property PDP_min_cube_out__1_1_1_cube_out_int16_split3_min_pooling__25_cov;
//         disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//         @(posedge nvdla_core_clk)
//         reg2dp_op_en & (reg2dp_split_num>=8'd2) & (reg2dp_input_data== 2'h1 ) & (reg2dp_pooling_method== 2'h2 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_partial_width_out_mid)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
//     endproperty
//     // Cover 25 : "reg2dp_op_en & (reg2dp_split_num>=8'd2) & (reg2dp_input_data== 2'h1 ) & (reg2dp_pooling_method== 2'h2 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_partial_width_out_mid)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
//     FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_int16_split3_min_pooling__25_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_int16_split3_min_pooling__25_cov);
// 
//   `endif
// `endif
// //VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_min_cube_out__1_1_1_cube_out_int8_split3_min_pooling__26_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        reg2dp_op_en & (reg2dp_split_num>=8'd2) & (reg2dp_pooling_method== 2'h2 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_partial_width_out_mid)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel));
    endproperty
    // Cover 26 : "reg2dp_op_en & (reg2dp_split_num>=8'd2) & (reg2dp_pooling_method== 2'h2 ) & (~(|reg2dp_partial_width_out_first)) & (~(|reg2dp_partial_width_out_last)) & (~(|reg2dp_partial_width_out_mid)) & (~(|reg2dp_cube_out_height)) & (~(|reg2dp_cube_out_channel))"
    FUNCPOINT_PDP_min_cube_out__1_1_1_cube_out_int8_split3_min_pooling__26_COV : cover property (PDP_min_cube_out__1_1_1_cube_out_int8_split3_min_pooling__26_cov);

  `endif
`endif
//VCS coverage on


//rdma lattency_buffer is full, but core op_en not trigger

//two continuous layers
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

    property PDP_CORE_two_continuous_layer__27_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (mon_gap_between_layers==32'd2) & mon_op_en_pos;
    endproperty
    // Cover 27 : "(mon_gap_between_layers==32'd2) & mon_op_en_pos"
    FUNCPOINT_PDP_CORE_two_continuous_layer__27_COV : cover property (PDP_CORE_two_continuous_layer__27_cov);

  `endif
`endif
//VCS coverage on

//3 cycles means continuous layer

//different config between two continous layers
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    mon_reg2dp_cube_in_channel <= {13{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_cube_in_channel <= reg2dp_cube_in_channel;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_cube_in_channel <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    mon_reg2dp_cube_in_height <= {13{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_cube_in_height <= reg2dp_cube_in_height;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_cube_in_height <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mon_reg2dp_cube_in_width <= {13{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_cube_in_width <= reg2dp_cube_in_width;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_cube_in_width <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mon_reg2dp_cube_out_channel <= {13{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_cube_out_channel <= reg2dp_cube_out_channel;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_cube_out_channel <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mon_reg2dp_cube_out_height <= {13{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_cube_out_height <= reg2dp_cube_out_height;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_cube_out_height <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mon_reg2dp_cube_out_width <= {13{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_cube_out_width <= reg2dp_cube_out_width;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_cube_out_width <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mon_reg2dp_partial_width_in_first <= {10{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_partial_width_in_first <= reg2dp_partial_width_in_first;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_partial_width_in_first <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mon_reg2dp_partial_width_in_last <= {10{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_partial_width_in_last <= reg2dp_partial_width_in_last;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_partial_width_in_last <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mon_reg2dp_partial_width_in_mid <= {10{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_partial_width_in_mid <= reg2dp_partial_width_in_mid;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_partial_width_in_mid <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_22x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mon_reg2dp_partial_width_out_first <= {10{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_partial_width_out_first <= reg2dp_partial_width_out_first;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_partial_width_out_first <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_23x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mon_reg2dp_partial_width_out_last <= {10{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_partial_width_out_last <= reg2dp_partial_width_out_last;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_partial_width_out_last <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_24x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mon_reg2dp_partial_width_out_mid <= {10{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_partial_width_out_mid <= reg2dp_partial_width_out_mid;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_partial_width_out_mid <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_25x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mon_reg2dp_flying_mode <= 1'b0;
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_flying_mode <= reg2dp_flying_mode;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_flying_mode <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_26x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//   if (!nvdla_core_rstn) begin
//     // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
//     mon_reg2dp_input_data <= {2{1'b0}};
//     // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
//   end else begin
//   if ((mon_op_en_pos) == 1'b1) begin
//     mon_reg2dp_input_data <= reg2dp_input_data;
//   // VCS coverage off
//   end else if ((mon_op_en_pos) == 1'b0) begin
//   end else begin
//     mon_reg2dp_input_data <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
//   // VCS coverage on
//   end
//   end
// end
// `ifdef SPYGLASS_ASSERT_ON
// `else
// // spyglass disable_block NoWidthInBasedNum-ML 
// // spyglass disable_block STARC-2.10.3.2a 
// // spyglass disable_block STARC05-2.1.3.1 
// // spyglass disable_block STARC-2.1.4.6 
// // spyglass disable_block W116 
// // spyglass disable_block W154 
// // spyglass disable_block W239 
// // spyglass disable_block W362 
// // spyglass disable_block WRN_58 
// // spyglass disable_block WRN_61 
// `endif // SPYGLASS_ASSERT_ON
// `ifdef ASSERT_ON
// `ifdef FV_ASSERT_ON
// `define ASSERT_RESET nvdla_core_rstn
// `else
// `ifdef SYNTHESIS
// `define ASSERT_RESET nvdla_core_rstn
// `else
// `ifdef ASSERT_OFF_RESET_IS_X
// `define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
// `else
// `define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
// `endif // ASSERT_OFF_RESET_IS_X
// `endif // SYNTHESIS
// `endif // FV_ASSERT_ON
// `ifndef SYNTHESIS
//   // VCS coverage off 
//   nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_27x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
//   // VCS coverage on
// `endif
// `undef ASSERT_RESET
// `endif // ASSERT_ON
// `ifdef SPYGLASS_ASSERT_ON
// `else
// // spyglass enable_block NoWidthInBasedNum-ML 
// // spyglass enable_block STARC-2.10.3.2a 
// // spyglass enable_block STARC05-2.1.3.1 
// // spyglass enable_block STARC-2.1.4.6 
// // spyglass enable_block W116 
// // spyglass enable_block W154 
// // spyglass enable_block W239 
// // spyglass enable_block W362 
// // spyglass enable_block WRN_58 
// // spyglass enable_block WRN_61 
// `endif // SPYGLASS_ASSERT_ON
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    mon_reg2dp_kernel_height <= {4{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_kernel_height <= reg2dp_kernel_height;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_kernel_height <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_28x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mon_reg2dp_kernel_width <= {4{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_kernel_width <= reg2dp_kernel_width;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_kernel_width <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_29x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mon_reg2dp_kernel_stride_height <= {4{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_kernel_stride_height <= reg2dp_kernel_stride_height;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_kernel_stride_height <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_30x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mon_reg2dp_kernel_stride_width <= {4{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_kernel_stride_width <= reg2dp_kernel_stride_width;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_kernel_stride_width <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_31x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_32x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mon_reg2dp_pad_bottom <= {3{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_pad_bottom <= reg2dp_pad_bottom;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_pad_bottom <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_33x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mon_reg2dp_pad_left <= {3{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_pad_left <= reg2dp_pad_left;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_pad_left <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_34x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mon_reg2dp_pad_right <= {3{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_pad_right <= reg2dp_pad_right;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_pad_right <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_35x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mon_reg2dp_pad_top <= {3{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_pad_top <= reg2dp_pad_top;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_pad_top <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_36x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mon_reg2dp_pooling_method <= {2{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_pooling_method <= reg2dp_pooling_method;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_pooling_method <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_37x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    mon_reg2dp_split_num <= {8{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  end else begin
  if ((mon_op_en_pos) == 1'b1) begin
    mon_reg2dp_split_num <= reg2dp_split_num;
  // VCS coverage off
  end else if ((mon_op_en_pos) == 1'b0) begin
  end else begin
    mon_reg2dp_split_num <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_38x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(mon_op_en_pos))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

    property PDP_CORE_two_continuous_changed_layer__change_cube_in_w__28_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_cube_in_width!=reg2dp_cube_in_width));
    endproperty
    // Cover 28 : "(mon_reg2dp_cube_in_width!=reg2dp_cube_in_width)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_cube_in_w__28_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_cube_in_w__28_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_cube_in_h__29_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_cube_in_height!=reg2dp_cube_in_height));
    endproperty
    // Cover 29 : "(mon_reg2dp_cube_in_height!=reg2dp_cube_in_height)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_cube_in_h__29_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_cube_in_h__29_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_cube_in_c__30_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_cube_in_channel!=reg2dp_cube_in_channel));
    endproperty
    // Cover 30 : "(mon_reg2dp_cube_in_channel!=reg2dp_cube_in_channel)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_cube_in_c__30_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_cube_in_c__30_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_cube_out_w__31_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_cube_out_width!=reg2dp_cube_out_width));
    endproperty
    // Cover 31 : "(mon_reg2dp_cube_out_width!=reg2dp_cube_out_width)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_cube_out_w__31_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_cube_out_w__31_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_cube_out_h__32_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_cube_out_height!=reg2dp_cube_out_height));
    endproperty
    // Cover 32 : "(mon_reg2dp_cube_out_height!=reg2dp_cube_out_height)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_cube_out_h__32_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_cube_out_h__32_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_cube_out_c__33_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_cube_out_channel!=reg2dp_cube_out_channel));
    endproperty
    // Cover 33 : "(mon_reg2dp_cube_out_channel!=reg2dp_cube_out_channel)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_cube_out_c__33_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_cube_out_c__33_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_cube_partial_in_f__34_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_partial_width_in_first!=reg2dp_partial_width_in_first));
    endproperty
    // Cover 34 : "(mon_reg2dp_partial_width_in_first!=reg2dp_partial_width_in_first)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_cube_partial_in_f__34_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_cube_partial_in_f__34_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_cube_partial_in_m__35_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_partial_width_in_mid!=reg2dp_partial_width_in_mid));
    endproperty
    // Cover 35 : "(mon_reg2dp_partial_width_in_mid!=reg2dp_partial_width_in_mid)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_cube_partial_in_m__35_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_cube_partial_in_m__35_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_cube_partial_in_l__36_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_partial_width_in_last!=reg2dp_partial_width_in_last));
    endproperty
    // Cover 36 : "(mon_reg2dp_partial_width_in_last!=reg2dp_partial_width_in_last)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_cube_partial_in_l__36_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_cube_partial_in_l__36_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_cube_partial_out_f__37_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_partial_width_out_first!=reg2dp_partial_width_out_first));
    endproperty
    // Cover 37 : "(mon_reg2dp_partial_width_out_first!=reg2dp_partial_width_out_first)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_cube_partial_out_f__37_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_cube_partial_out_f__37_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_cube_partial_out_m__38_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_partial_width_out_mid!=reg2dp_partial_width_out_mid));
    endproperty
    // Cover 38 : "(mon_reg2dp_partial_width_out_mid!=reg2dp_partial_width_out_mid)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_cube_partial_out_m__38_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_cube_partial_out_m__38_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_cube_partial_out_l__39_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_partial_width_out_last!=reg2dp_partial_width_out_last));
    endproperty
    // Cover 39 : "(mon_reg2dp_partial_width_out_last!=reg2dp_partial_width_out_last)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_cube_partial_out_l__39_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_cube_partial_out_l__39_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_onfly_2_offfly__40_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_flying_mode == 1'h0 ) & (reg2dp_flying_mode== 1'h1 ));
    endproperty
    // Cover 40 : "(mon_reg2dp_flying_mode == 1'h0 ) & (reg2dp_flying_mode== 1'h1 )"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_onfly_2_offfly__40_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_onfly_2_offfly__40_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_offfly_2_onfly__41_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_flying_mode == 1'h1 ) & (reg2dp_flying_mode== 1'h0 ));
    endproperty
    // Cover 41 : "(mon_reg2dp_flying_mode == 1'h1 ) & (reg2dp_flying_mode== 1'h0 )"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_offfly_2_onfly__41_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_offfly_2_onfly__41_cov);

  `endif
`endif
//VCS coverage on

//  //VCS coverage off
//  `ifndef DISABLE_FUNCPOINT
//    `ifdef ENABLE_FUNCPOINT
//  
//      property PDP_CORE_two_continuous_changed_layer__change_data_type__42_cov;
//          disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//          @(posedge nvdla_core_clk)
//          ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_input_data!=reg2dp_input_data));
//      endproperty
//      // Cover 42 : "(mon_reg2dp_input_data!=reg2dp_input_data)"
//      FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_data_type__42_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_data_type__42_cov);
//  
//    `endif
//  `endif
//  //VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_kernel_w__43_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_kernel_width!=reg2dp_kernel_width));
    endproperty
    // Cover 43 : "(mon_reg2dp_kernel_width!=reg2dp_kernel_width)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_kernel_w__43_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_kernel_w__43_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_kernel_h__44_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_kernel_height!=reg2dp_kernel_height));
    endproperty
    // Cover 44 : "(mon_reg2dp_kernel_height!=reg2dp_kernel_height)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_kernel_h__44_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_kernel_h__44_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_kernel_stride_w__45_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_kernel_stride_width!=reg2dp_kernel_stride_width));
    endproperty
    // Cover 45 : "(mon_reg2dp_kernel_stride_width!=reg2dp_kernel_stride_width)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_kernel_stride_w__45_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_kernel_stride_w__45_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_kernel_stride_h__46_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_kernel_stride_height!=reg2dp_kernel_stride_height));
    endproperty
    // Cover 46 : "(mon_reg2dp_kernel_stride_height!=reg2dp_kernel_stride_height)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_kernel_stride_h__46_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_kernel_stride_h__46_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_nan2zero__47_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_nan_to_zero!=reg2dp_nan_to_zero));
    endproperty
    // Cover 47 : "(mon_reg2dp_nan_to_zero!=reg2dp_nan_to_zero)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_nan2zero__47_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_nan2zero__47_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_pad_bottom__48_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_pad_bottom!=reg2dp_pad_bottom));
    endproperty
    // Cover 48 : "(mon_reg2dp_pad_bottom!=reg2dp_pad_bottom)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_pad_bottom__48_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_pad_bottom__48_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_pad_left__49_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_pad_left!=reg2dp_pad_left));
    endproperty
    // Cover 49 : "(mon_reg2dp_pad_left!=reg2dp_pad_left)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_pad_left__49_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_pad_left__49_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_pad_right__50_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_pad_right!=reg2dp_pad_right));
    endproperty
    // Cover 50 : "(mon_reg2dp_pad_right!=reg2dp_pad_right)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_pad_right__50_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_pad_right__50_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_pad_top__51_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_pad_top!=reg2dp_pad_top));
    endproperty
    // Cover 51 : "(mon_reg2dp_pad_top!=reg2dp_pad_top)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_pad_top__51_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_pad_top__51_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_pooling_type__52_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_pooling_method!=reg2dp_pooling_method));
    endproperty
    // Cover 52 : "(mon_reg2dp_pooling_method!=reg2dp_pooling_method)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_pooling_type__52_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_pooling_type__52_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_CORE_two_continuous_changed_layer__change_split_num__53_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((mon_op_en_pos) && nvdla_core_rstn) |-> ((mon_reg2dp_split_num!=reg2dp_split_num));
    endproperty
    // Cover 53 : "(mon_reg2dp_split_num!=reg2dp_split_num)"
    FUNCPOINT_PDP_CORE_two_continuous_changed_layer__change_split_num__53_COV : cover property (PDP_CORE_two_continuous_changed_layer__change_split_num__53_cov);

  `endif
`endif
//VCS coverage on


//==============


endmodule // NV_NVDLA_pdp

