// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_PDP_rdma.v

#include "NV_NVDLA_PDP_define.h"

module NV_NVDLA_PDP_rdma (
   csb2pdp_rdma_req_pd           //|< i
  ,csb2pdp_rdma_req_pvld         //|< i
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cvif2pdp_rd_rsp_pd            //|< i
  ,cvif2pdp_rd_rsp_valid         //|< i
  ,cvif2pdp_rd_rsp_ready         //|> o
  ,pdp2cvif_rd_cdt_lat_fifo_pop  //|> o
  ,pdp2cvif_rd_req_pd            //|> o
  ,pdp2cvif_rd_req_valid         //|> o
  ,pdp2cvif_rd_req_ready         //|< i
#endif
,dla_clk_ovr_on_sync           //|< i
  ,global_clk_ovr_on_sync        //|< i
  ,mcif2pdp_rd_rsp_pd            //|< i
  ,mcif2pdp_rd_rsp_valid         //|< i
  ,nvdla_core_clk                //|< i
  ,nvdla_core_rstn               //|< i
  ,pdp2mcif_rd_req_ready         //|< i
  ,pdp_rdma2dp_ready             //|< i
  ,pwrbus_ram_pd                 //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,csb2pdp_rdma_req_prdy         //|> o
  ,mcif2pdp_rd_rsp_ready         //|> o
  ,pdp2mcif_rd_cdt_lat_fifo_pop  //|> o
  ,pdp2mcif_rd_req_pd            //|> o
  ,pdp2mcif_rd_req_valid         //|> o
  ,pdp_rdma2csb_resp_pd          //|> o
  ,pdp_rdma2csb_resp_valid       //|> o
  ,pdp_rdma2dp_pd                //|> o
  ,pdp_rdma2dp_valid             //|> o
  ,rdma2wdma_done                //|> o
  );
///////////////////////////////////////////////////////////////////////////////////////////
 output        rdma2wdma_done;
 //
 input  nvdla_core_clk;   
 input  nvdla_core_rstn;  

 input         csb2pdp_rdma_req_pvld;  /* data valid */
 output        csb2pdp_rdma_req_prdy;  /* data return handshake */
 input  [62:0] csb2pdp_rdma_req_pd;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
 input          cvif2pdp_rd_rsp_valid;  /* data valid */
 output         cvif2pdp_rd_rsp_ready;  /* data return handshake */
 input [NVDLA_PDP_MEM_RD_RSP-1:0] cvif2pdp_rd_rsp_pd;
 output  pdp2cvif_rd_cdt_lat_fifo_pop;
 output        pdp2cvif_rd_req_valid;  /* data valid */
 input         pdp2cvif_rd_req_ready;  /* data return handshake */
 output [NVDLA_MEM_ADDRESS_WIDTH+14:0] pdp2cvif_rd_req_pd;
#endif

 input          mcif2pdp_rd_rsp_valid;  /* data valid */
 output         mcif2pdp_rd_rsp_ready;  /* data return handshake */
 input [NVDLA_PDP_MEM_RD_RSP-1:0] mcif2pdp_rd_rsp_pd;

 output  pdp2mcif_rd_cdt_lat_fifo_pop;
 output        pdp2mcif_rd_req_valid;  /* data valid */
 input         pdp2mcif_rd_req_ready;  /* data return handshake */
 output [NVDLA_MEM_ADDRESS_WIDTH+14:0] pdp2mcif_rd_req_pd;

 output        pdp_rdma2csb_resp_valid;  /* data valid */
 output [33:0] pdp_rdma2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

 output        pdp_rdma2dp_valid;  /* data valid */
 input         pdp_rdma2dp_ready;  /* data return handshake */
 output [NVDLA_PDP_BWPE*NVDLA_PDP_THROUGHPUT+13:0] pdp_rdma2dp_pd;

 input [31:0] pwrbus_ram_pd;

 input   dla_clk_ovr_on_sync;
 input   global_clk_ovr_on_sync;
 input   tmc2slcg_disable_clock_gating;
///////////////////////////////////////////////////////////////////////////////////////////
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
 wire   [31:0] reg2dp_src_base_addr_low;
 wire   [31:0] reg2dp_src_line_stride;
 wire    [0:0] reg2dp_src_ram_type;
 wire   [31:0] reg2dp_src_surface_stride;
 wire   [31:0] reg2dp_surf_stride;
 wire    [0:0] slcg_op_en;
///////////////////////////////////////////////////////////////////////////////////////////

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
   ,.reg2dp_kernel_stride_width    (reg2dp_kernel_stride_width[3:0])    //|< w
   ,.reg2dp_kernel_width           (reg2dp_kernel_width[3:0])           //|< w
   ,.reg2dp_op_en                  (reg2dp_op_en[0])                    //|< w
   ,.reg2dp_partial_width_in_first (reg2dp_partial_width_in_first[9:0]) //|< w
   ,.reg2dp_partial_width_in_last  (reg2dp_partial_width_in_last[9:0])  //|< w
   ,.reg2dp_partial_width_in_mid   (reg2dp_partial_width_in_mid[9:0])   //|< w
   ,.reg2dp_split_num              (reg2dp_split_num[7:0])              //|< w
   ,.reg2dp_src_base_addr_high     (reg2dp_src_base_addr_high[31:0])    //|< w

   ,.reg2dp_src_base_addr_low      ({reg2dp_src_base_addr_low[31:0]})
   ,.reg2dp_src_line_stride        ({reg2dp_src_line_stride[31:0]})
   ,.reg2dp_src_surface_stride     ({reg2dp_src_surface_stride[31:0]})
   ,.reg2dp_src_ram_type           (reg2dp_src_ram_type[0])         
   ,.dp2reg_d0_perf_read_stall     (dp2reg_d0_perf_read_stall[31:0])
   ,.dp2reg_d1_perf_read_stall     (dp2reg_d1_perf_read_stall[31:0])
   ,.reg2dp_surf_stride            (reg2dp_surf_stride[31:0])       
   ,.eg2ig_done                    (eg2ig_done)                     
   ,.nvdla_core_clk                (nvdla_op_gated_clk)             
   ,.nvdla_core_rstn               (nvdla_core_rstn)                
   ,.pdp2mcif_rd_req_valid         (pdp2mcif_rd_req_valid)          
   ,.pdp2mcif_rd_req_ready         (pdp2mcif_rd_req_ready)          
   ,.pdp2mcif_rd_req_pd            (pdp2mcif_rd_req_pd)           //
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
   ,.pdp2cvif_rd_req_valid         (pdp2cvif_rd_req_valid)          
   ,.pdp2cvif_rd_req_ready         (pdp2cvif_rd_req_ready)          
   ,.pdp2cvif_rd_req_pd            (pdp2cvif_rd_req_pd)           //
#endif
  ,.ig2cq_pvld                    (ig2cq_pvld)                      
   ,.ig2cq_prdy                    (ig2cq_prdy)                     
   ,.ig2cq_pd                      (ig2cq_pd[17:0])                 
   );
 //=======================================
 // Context Queue: trace outstanding req, and pass info from Ig to Eg
 //---------------------------------------
 NV_NVDLA_PDP_RDMA_cq u_cq (
    .nvdla_core_clk                (nvdla_op_gated_clk)  
   ,.nvdla_core_rstn               (nvdla_core_rstn)     
   ,.ig2cq_prdy                    (ig2cq_prdy)          
   ,.ig2cq_pvld                    (ig2cq_pvld)          
   ,.ig2cq_pd                      (ig2cq_pd[17:0])      
   ,.cq2eg_prdy                    (cq2eg_prdy)          
   ,.cq2eg_pvld                    (cq2eg_pvld)          
   ,.cq2eg_pd                      (cq2eg_pd[17:0])      
   ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0]) 
   );
 //=======================================
 // Egress: get return data from external mem
 //---------------------------------------
 NV_NVDLA_PDP_RDMA_eg u_eg (
    .reg2dp_src_ram_type           (reg2dp_src_ram_type)         
   ,.dp2reg_done                   (dp2reg_done)                 
   ,.eg2ig_done                    (eg2ig_done)                  
   ,.rdma2wdma_done                (rdma2wdma_done)              
   ,.nvdla_core_clk                (nvdla_op_gated_clk)          
   ,.nvdla_core_rstn               (nvdla_core_rstn)             
   ,.mcif2pdp_rd_rsp_valid         (mcif2pdp_rd_rsp_valid)       
   ,.mcif2pdp_rd_rsp_ready         (mcif2pdp_rd_rsp_ready)       
   ,.mcif2pdp_rd_rsp_pd            (mcif2pdp_rd_rsp_pd)          
   ,.pdp2mcif_rd_cdt_lat_fifo_pop  (pdp2mcif_rd_cdt_lat_fifo_pop)
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
   ,.cvif2pdp_rd_rsp_valid         (cvif2pdp_rd_rsp_valid)       
   ,.cvif2pdp_rd_rsp_ready         (cvif2pdp_rd_rsp_ready)       
   ,.cvif2pdp_rd_rsp_pd            (cvif2pdp_rd_rsp_pd)          
   ,.pdp2cvif_rd_cdt_lat_fifo_pop  (pdp2cvif_rd_cdt_lat_fifo_pop)
#endif
  ,.pdp_rdma2dp_valid             (pdp_rdma2dp_valid)            
   ,.pdp_rdma2dp_ready             (pdp_rdma2dp_ready)           
   ,.pdp_rdma2dp_pd                (pdp_rdma2dp_pd)              
   ,.cq2eg_pvld                    (cq2eg_pvld)                  
   ,.cq2eg_prdy                    (cq2eg_prdy)                  
   ,.cq2eg_pd                      (cq2eg_pd[17:0])              
   ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])         
   );

 //========================================
 //CFG: Configure Registers
 //----------------------------------------
 NV_NVDLA_PDP_RDMA_reg u_reg (
    .nvdla_core_clk                (nvdla_core_clk)                    
   ,.nvdla_core_rstn               (nvdla_core_rstn)                   
   ,.csb2pdp_rdma_req_pd           (csb2pdp_rdma_req_pd[62:0])         
   ,.csb2pdp_rdma_req_pvld         (csb2pdp_rdma_req_pvld)             
   ,.dp2reg_d0_perf_read_stall     (dp2reg_d0_perf_read_stall[31:0])   
   ,.dp2reg_d1_perf_read_stall     (dp2reg_d1_perf_read_stall[31:0])   
   ,.dp2reg_done                   (dp2reg_done)                       
   ,.csb2pdp_rdma_req_prdy         (csb2pdp_rdma_req_prdy)             
   ,.pdp_rdma2csb_resp_pd          (pdp_rdma2csb_resp_pd[33:0])        
   ,.pdp_rdma2csb_resp_valid       (pdp_rdma2csb_resp_valid)           
   ,.reg2dp_cube_in_channel        (reg2dp_cube_in_channel[12:0])      
   ,.reg2dp_cube_in_height         (reg2dp_cube_in_height[12:0])       
   ,.reg2dp_cube_in_width          (reg2dp_cube_in_width[12:0])        
   ,.reg2dp_cya                    (reg2dp_cya[31:0])                  
   ,.reg2dp_dma_en                 (reg2dp_dma_en)                     
   ,.reg2dp_flying_mode            (reg2dp_flying_mode)                
   ,.reg2dp_input_data             (reg2dp_input_data[1:0])            
   ,.reg2dp_kernel_stride_width    (reg2dp_kernel_stride_width[3:0])   
   ,.reg2dp_kernel_width           (reg2dp_kernel_width[3:0])          
   ,.reg2dp_op_en                  (reg2dp_op_en)                      
   ,.reg2dp_pad_width              (reg2dp_pad_width[3:0])             
   ,.reg2dp_partial_width_in_first (reg2dp_partial_width_in_first[9:0])
   ,.reg2dp_partial_width_in_last  (reg2dp_partial_width_in_last[9:0]) 
   ,.reg2dp_partial_width_in_mid   (reg2dp_partial_width_in_mid[9:0])  
   ,.reg2dp_split_num              (reg2dp_split_num[7:0])             
   ,.reg2dp_src_base_addr_high     (reg2dp_src_base_addr_high[31:0])   
   ,.reg2dp_src_base_addr_low      (reg2dp_src_base_addr_low[31:0])    
   ,.reg2dp_src_line_stride        (reg2dp_src_line_stride[31:0])      
   ,.reg2dp_src_ram_type           (reg2dp_src_ram_type)               
   ,.reg2dp_src_surface_stride     (reg2dp_src_surface_stride[31:0])   
   ,.slcg_op_en                    (slcg_op_en)                        
   );

 //&Forget dangle .*;


endmodule // NV_NVDLA_PDP_rdma

