// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_WRITE_ig_s.v

#include "NV_NVDLA_MCIF_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_MCIF_WRITE_ig_s (
   nvdla_core_clk          
  ,nvdla_core_rstn         
  ,pwrbus_ram_pd           
  #ifdef NVDLA_BDMA_ENABLE
  ,bdma2mcif_wr_req_pd     
  ,bdma2mcif_wr_req_valid  
  ,bdma2mcif_wr_req_ready  
  #endif
  #ifdef NVDLA_CDP_ENABLE
  ,cdp2mcif_wr_req_pd      
  ,cdp2mcif_wr_req_valid   
  ,cdp2mcif_wr_req_ready   
  #endif
  #ifdef NVDLA_PDP_ENABLE
  ,pdp2mcif_wr_req_pd      
  ,pdp2mcif_wr_req_valid   
  ,pdp2mcif_wr_req_ready   
  #endif
  #ifdef NVDLA_RUBIK_ENABLE
  ,rbk2mcif_wr_req_pd      
  ,rbk2mcif_wr_req_valid   
  ,rbk2mcif_wr_req_ready   
  #endif
  ,sdp2mcif_wr_req_pd      
  ,sdp2mcif_wr_req_valid   
  ,sdp2mcif_wr_req_ready   
  ,cq_wr_pd                
  ,cq_wr_pvld              
  ,cq_wr_thread_id         
  ,cq_wr_prdy              
  ,eg2ig_axi_len           
  ,eg2ig_axi_vld         
  
  ,reg2dp_wr_os_cnt        
  #ifdef NVDLA_BDMA_ENABLE
  ,reg2dp_wr_weight_bdma   
  #endif
  #ifdef NVDLA_CDP_ENABLE
  ,reg2dp_wr_weight_cdp    
  #endif
  #ifdef NVDLA_PDP_ENABLE
  ,reg2dp_wr_weight_pdp    
  #endif
  #ifdef NVDLA_RUBIK_ENABLE
  ,reg2dp_wr_weight_rbk    
  #endif
  ,reg2dp_wr_weight_sdp    
  ,mcif2noc_axi_aw_awaddr  
  ,mcif2noc_axi_aw_awid    
  ,mcif2noc_axi_aw_awlen   
  ,mcif2noc_axi_aw_awvalid 
  ,mcif2noc_axi_aw_awready 
  ,mcif2noc_axi_w_wdata    
  ,mcif2noc_axi_w_wlast    
  ,mcif2noc_axi_w_wstrb    
  ,mcif2noc_axi_w_wvalid   
  ,mcif2noc_axi_w_wready   
  );


///////////////////////////////////////////////////////
//
// NV_NVDLA_MCIF_WRITE_ig_ports.v
//
input  nvdla_core_clk; 
input  nvdla_core_rstn;
input [31:0] pwrbus_ram_pd;

#ifdef NVDLA_BDMA_ENABLE
input          bdma2mcif_wr_req_valid;
output         bdma2mcif_wr_req_ready;
input  [NVDLA_DMA_WR_REQ-1:0] bdma2mcif_wr_req_pd;
#endif

#ifdef NVDLA_CDP_ENABLE
input          cdp2mcif_wr_req_valid; 
output         cdp2mcif_wr_req_ready; 
input  [NVDLA_DMA_WR_REQ-1:0] cdp2mcif_wr_req_pd;
#endif

#ifdef NVDLA_PDP_ENABLE
input          pdp2mcif_wr_req_valid;  
output         pdp2mcif_wr_req_ready;  
input  [NVDLA_DMA_WR_REQ-1:0] pdp2mcif_wr_req_pd;     
#endif

#ifdef NVDLA_RUBIK_ENABLE
input          rbk2mcif_wr_req_valid;  
output         rbk2mcif_wr_req_ready;  
input  [NVDLA_DMA_WR_REQ-1:0] rbk2mcif_wr_req_pd;     
#endif

input          sdp2mcif_wr_req_valid;  
output         sdp2mcif_wr_req_ready;  
input  [NVDLA_DMA_WR_REQ-1:0] sdp2mcif_wr_req_pd;     


output        cq_wr_pvld; 
input         cq_wr_prdy;
output [2:0]  cq_wr_thread_id;
output [2:0]  cq_wr_pd;
input   [1:0] eg2ig_axi_len;
input         eg2ig_axi_vld;

output        mcif2noc_axi_aw_awvalid;
input         mcif2noc_axi_aw_awready;
output  [7:0] mcif2noc_axi_aw_awid;
output  [3:0] mcif2noc_axi_aw_awlen;
output [31:0] mcif2noc_axi_aw_awaddr;

output         mcif2noc_axi_w_wvalid;  
input          mcif2noc_axi_w_wready;  
output [NVDLA_MEMIF_WIDTH-1:0] mcif2noc_axi_w_wdata;
output  [31:0] mcif2noc_axi_w_wstrb;
output         mcif2noc_axi_w_wlast;

input   [7:0] reg2dp_wr_os_cnt;
#ifdef NVDLA_BDMA_ENABLE
input   [7:0] reg2dp_wr_weight_bdma;
#endif
#ifdef NVDLA_CDP_ENABLE
input   [7:0] reg2dp_wr_weight_cdp;
#endif
#ifdef NVDLA_PDP_ENABLE
input   [7:0] reg2dp_wr_weight_pdp;
#endif
#ifdef NVDLA_RUBIK_ENABLE
input   [7:0] reg2dp_wr_weight_rbk;
#endif
input   [7:0] reg2dp_wr_weight_sdp;


/////////////////////////////////////////////////////
wire   [44:0] arb2spt_cmd_pd;
wire          arb2spt_cmd_ready;
wire          arb2spt_cmd_valid;
wire  [NVDLA_DMA_RD_RSP-1:0] arb2spt_dat_pd;
wire          arb2spt_dat_ready;
wire          arb2spt_dat_valid;
wire   [44:0] bpt2arb_cmd0_pd;
wire          bpt2arb_cmd0_ready;
wire          bpt2arb_cmd0_valid;
wire   [44:0] bpt2arb_cmd1_pd;
wire          bpt2arb_cmd1_ready;
wire          bpt2arb_cmd1_valid;
wire   [44:0] bpt2arb_cmd2_pd;
wire          bpt2arb_cmd2_ready;
wire          bpt2arb_cmd2_valid;
wire   [44:0] bpt2arb_cmd3_pd;
wire          bpt2arb_cmd3_ready;
wire          bpt2arb_cmd3_valid;
wire   [44:0] bpt2arb_cmd4_pd;
wire          bpt2arb_cmd4_ready;
wire          bpt2arb_cmd4_valid;
wire  [NVDLA_DMA_RD_RSP-1:0] bpt2arb_dat0_pd;
wire          bpt2arb_dat0_ready;
wire          bpt2arb_dat0_valid;
wire  [NVDLA_DMA_RD_RSP-1:0] bpt2arb_dat1_pd;
wire          bpt2arb_dat1_ready;
wire          bpt2arb_dat1_valid;
wire  [NVDLA_DMA_RD_RSP-1:0] bpt2arb_dat2_pd;
wire          bpt2arb_dat2_ready;
wire          bpt2arb_dat2_valid;
wire  [NVDLA_DMA_RD_RSP-1:0] bpt2arb_dat3_pd;
wire          bpt2arb_dat3_ready;
wire          bpt2arb_dat3_valid;
wire  [NVDLA_DMA_RD_RSP-1:0] bpt2arb_dat4_pd;
wire          bpt2arb_dat4_ready;
wire          bpt2arb_dat4_valid;
wire   [44:0] spt2cvt_cmd_pd;
wire          spt2cvt_cmd_ready;
wire          spt2cvt_cmd_valid;
wire  [NVDLA_DMA_RD_RSP-1:0] spt2cvt_dat_pd;
wire          spt2cvt_dat_ready;
wire          spt2cvt_dat_valid;


//////////////////////////////////////////////////////////
#ifdef NVDLA_BDMA_ENABLE
NV_NVDLA_MCIF_WRITE_IG_bpt_s u_bpt0 (
   .nvdla_core_clk          (nvdla_core_clk)               
  ,.nvdla_core_rstn         (nvdla_core_rstn)              
  ,.dma2bpt_req_valid       (bdma2mcif_wr_req_valid)       
  ,.dma2bpt_req_ready       (bdma2mcif_wr_req_ready)       
  ,.dma2bpt_req_pd          (bdma2mcif_wr_req_pd)          
  ,.bpt2arb_cmd_valid       (bpt2arb_cmd0_valid)           
  ,.bpt2arb_cmd_ready       (bpt2arb_cmd0_ready)           
  ,.bpt2arb_cmd_pd          (bpt2arb_cmd0_pd[44:0])        
  ,.bpt2arb_dat_valid       (bpt2arb_dat0_valid)           
  ,.bpt2arb_dat_ready       (bpt2arb_dat0_ready)           
  ,.bpt2arb_dat_pd          (bpt2arb_dat0_pd)              
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])          
  ,.axid                    (4'd0)                         
  );
#endif

NV_NVDLA_MCIF_WRITE_IG_bpt_s u_bpt1 (
   .nvdla_core_clk          (nvdla_core_clk)               
  ,.nvdla_core_rstn         (nvdla_core_rstn)              
  ,.dma2bpt_req_valid       (sdp2mcif_wr_req_valid)        
  ,.dma2bpt_req_ready       (sdp2mcif_wr_req_ready)        
  ,.dma2bpt_req_pd          (sdp2mcif_wr_req_pd)           
  ,.bpt2arb_cmd_valid       (bpt2arb_cmd1_valid)           
  ,.bpt2arb_cmd_ready       (bpt2arb_cmd1_ready)           
  ,.bpt2arb_cmd_pd          (bpt2arb_cmd1_pd[44:0])        
  ,.bpt2arb_dat_valid       (bpt2arb_dat1_valid)           
  ,.bpt2arb_dat_ready       (bpt2arb_dat1_ready)           
  ,.bpt2arb_dat_pd          (bpt2arb_dat1_pd)              
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])          
  ,.axid                    (4'd1)                         
  );

#ifdef NVDLA_PDP_ENABLE
NV_NVDLA_MCIF_WRITE_IG_bpt_s u_bpt2 (
   .nvdla_core_clk          (nvdla_core_clk)               
  ,.nvdla_core_rstn         (nvdla_core_rstn)              
  ,.dma2bpt_req_valid       (pdp2mcif_wr_req_valid)        
  ,.dma2bpt_req_ready       (pdp2mcif_wr_req_ready)        
  ,.dma2bpt_req_pd          (pdp2mcif_wr_req_pd)           
  ,.bpt2arb_cmd_valid       (bpt2arb_cmd2_valid)           
  ,.bpt2arb_cmd_ready       (bpt2arb_cmd2_ready)           
  ,.bpt2arb_cmd_pd          (bpt2arb_cmd2_pd[44:0])        
  ,.bpt2arb_dat_valid       (bpt2arb_dat2_valid)           
  ,.bpt2arb_dat_ready       (bpt2arb_dat2_ready)           
  ,.bpt2arb_dat_pd          (bpt2arb_dat2_pd)              
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])          
  ,.axid                    (4'd2)                         
  );
#endif

#ifdef NVDLA_CDP_ENABLE
NV_NVDLA_MCIF_WRITE_IG_bpt_s u_bpt3 (
   .nvdla_core_clk          (nvdla_core_clk)               
  ,.nvdla_core_rstn         (nvdla_core_rstn)              
  ,.dma2bpt_req_valid       (cdp2mcif_wr_req_valid)        
  ,.dma2bpt_req_ready       (cdp2mcif_wr_req_ready)        
  ,.dma2bpt_req_pd          (cdp2mcif_wr_req_pd)           
  ,.bpt2arb_cmd_valid       (bpt2arb_cmd3_valid)           
  ,.bpt2arb_cmd_ready       (bpt2arb_cmd3_ready)           
  ,.bpt2arb_cmd_pd          (bpt2arb_cmd3_pd[44:0])        
  ,.bpt2arb_dat_valid       (bpt2arb_dat3_valid)           
  ,.bpt2arb_dat_ready       (bpt2arb_dat3_ready)           
  ,.bpt2arb_dat_pd          (bpt2arb_dat3_pd)       
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])          
  ,.axid                    (4'd3)                         
  );
#endif

#ifdef NVDLA_RUBIK_ENABLE
NV_NVDLA_MCIF_WRITE_IG_bpt_s u_bpt4 (
   .nvdla_core_clk          (nvdla_core_clk)               
  ,.nvdla_core_rstn         (nvdla_core_rstn)              
  ,.dma2bpt_req_valid       (rbk2mcif_wr_req_valid)        
  ,.dma2bpt_req_ready       (rbk2mcif_wr_req_ready)        
  ,.dma2bpt_req_pd          (rbk2mcif_wr_req_pd)           
  ,.bpt2arb_cmd_valid       (bpt2arb_cmd4_valid)           
  ,.bpt2arb_cmd_ready       (bpt2arb_cmd4_ready)           
  ,.bpt2arb_cmd_pd          (bpt2arb_cmd4_pd[44:0])        
  ,.bpt2arb_dat_valid       (bpt2arb_dat4_valid)           
  ,.bpt2arb_dat_ready       (bpt2arb_dat4_ready)           
  ,.bpt2arb_dat_pd          (bpt2arb_dat4_pd)              
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])          
  ,.axid                    (4'd4)                         
  );
#endif

NV_NVDLA_MCIF_WRITE_IG_arb_s  u_arb (
   .nvdla_core_clk          (nvdla_core_clk)               
  ,.nvdla_core_rstn         (nvdla_core_rstn)              
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])          
  #ifdef NVDLA_BDMA_ENABLE
  ,.bpt2arb_cmd0_valid      (bpt2arb_cmd0_valid)           
  ,.bpt2arb_cmd0_ready      (bpt2arb_cmd0_ready)           
  ,.bpt2arb_cmd0_pd         (bpt2arb_cmd0_pd[44:0] )       
  ,.bpt2arb_dat0_valid      (bpt2arb_dat0_valid)           
  ,.bpt2arb_dat0_ready      (bpt2arb_dat0_ready)           
  ,.bpt2arb_dat0_pd         (bpt2arb_dat0_pd )             
  #endif  
  ,.bpt2arb_cmd1_valid      (bpt2arb_cmd1_valid)           
  ,.bpt2arb_cmd1_ready      (bpt2arb_cmd1_ready)           
  ,.bpt2arb_cmd1_pd         (bpt2arb_cmd1_pd[44:0] )       
  ,.bpt2arb_dat1_valid      (bpt2arb_dat1_valid)           
  ,.bpt2arb_dat1_ready      (bpt2arb_dat1_ready)           
  ,.bpt2arb_dat1_pd         (bpt2arb_dat1_pd )             
  #ifdef NVDLA_PDP_ENABLE
  ,.bpt2arb_cmd2_valid      (bpt2arb_cmd2_valid)           
  ,.bpt2arb_cmd2_ready      (bpt2arb_cmd2_ready)           
  ,.bpt2arb_cmd2_pd         (bpt2arb_cmd2_pd[44:0] )       
  ,.bpt2arb_dat2_valid      (bpt2arb_dat2_valid)           
  ,.bpt2arb_dat2_ready      (bpt2arb_dat2_ready)           
  ,.bpt2arb_dat2_pd         (bpt2arb_dat2_pd )             
  #endif
  #ifdef NVDLA_CDP_ENABLE
  ,.bpt2arb_cmd3_valid      (bpt2arb_cmd3_valid)           
  ,.bpt2arb_cmd3_ready      (bpt2arb_cmd3_ready)           
  ,.bpt2arb_cmd3_pd         (bpt2arb_cmd3_pd[44:0] )       
  ,.bpt2arb_dat3_valid      (bpt2arb_dat3_valid)           
  ,.bpt2arb_dat3_ready      (bpt2arb_dat3_ready)           
  ,.bpt2arb_dat3_pd         (bpt2arb_dat3_pd )             
  #endif
  #ifdef NVDLA_RUBIK_ENABLE
  ,.bpt2arb_cmd4_valid      (bpt2arb_cmd4_valid)           
  ,.bpt2arb_cmd4_ready      (bpt2arb_cmd4_ready)           
  ,.bpt2arb_cmd4_pd         (bpt2arb_cmd4_pd[44:0] )       
  ,.bpt2arb_dat4_valid      (bpt2arb_dat4_valid)           
  ,.bpt2arb_dat4_ready      (bpt2arb_dat4_ready)           
  ,.bpt2arb_dat4_pd         (bpt2arb_dat4_pd )             
  #endif
  ,.arb2spt_cmd_valid       (arb2spt_cmd_valid)            
  ,.arb2spt_cmd_ready       (arb2spt_cmd_ready)            
  ,.arb2spt_cmd_pd          (arb2spt_cmd_pd[44:0])         
  ,.arb2spt_dat_valid       (arb2spt_dat_valid)            
  ,.arb2spt_dat_ready       (arb2spt_dat_ready)            
  ,.arb2spt_dat_pd          (arb2spt_dat_pd)               
  #ifdef NVDLA_BDMA_ENABLE
  ,.reg2dp_wr_weight_bdma   (reg2dp_wr_weight_bdma[7:0])   
  #endif
  #ifdef NVDLA_CDP_ENABLE
  ,.reg2dp_wr_weight_cdp    (reg2dp_wr_weight_cdp[7:0])    
  #endif
  #ifdef NVDLA_PDP_ENABLE
  ,.reg2dp_wr_weight_pdp    (reg2dp_wr_weight_pdp[7:0])    
  #endif
  #ifdef NVDLA_RUBIK_ENABLE
  ,.reg2dp_wr_weight_rbk    (reg2dp_wr_weight_rbk[7:0])    
  #endif
  ,.reg2dp_wr_weight_sdp    (reg2dp_wr_weight_sdp[7:0])    
  );

NV_NVDLA_MCIF_WRITE_IG_spt_s u_spt (
   .nvdla_core_clk          (nvdla_core_clk)               
  ,.nvdla_core_rstn         (nvdla_core_rstn)              
  ,.arb2spt_cmd_valid       (arb2spt_cmd_valid)            
  ,.arb2spt_cmd_ready       (arb2spt_cmd_ready)            
  ,.arb2spt_cmd_pd          (arb2spt_cmd_pd[44:0])         
  ,.arb2spt_dat_valid       (arb2spt_dat_valid)            
  ,.arb2spt_dat_ready       (arb2spt_dat_ready)            
  ,.arb2spt_dat_pd          (arb2spt_dat_pd[NVDLA_DMA_RD_RSP-1:0])        
  ,.spt2cvt_cmd_valid       (spt2cvt_cmd_valid)            
  ,.spt2cvt_cmd_ready       (spt2cvt_cmd_ready)            
  ,.spt2cvt_cmd_pd          (spt2cvt_cmd_pd[44:0])         
  ,.spt2cvt_dat_valid       (spt2cvt_dat_valid)            
  ,.spt2cvt_dat_ready       (spt2cvt_dat_ready)            
  ,.spt2cvt_dat_pd          (spt2cvt_dat_pd)               
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])          
  );

NV_NVDLA_MCIF_WRITE_IG_cvt_s u_cvt (
   .nvdla_core_clk          (nvdla_core_clk)               
  ,.nvdla_core_rstn         (nvdla_core_rstn)              
  ,.spt2cvt_cmd_valid       (spt2cvt_cmd_valid)            
  ,.spt2cvt_cmd_ready       (spt2cvt_cmd_ready)            
  ,.spt2cvt_cmd_pd          (spt2cvt_cmd_pd[44:0])         
  ,.spt2cvt_dat_valid       (spt2cvt_dat_valid)            
  ,.spt2cvt_dat_ready       (spt2cvt_dat_ready)            
  ,.spt2cvt_dat_pd          (spt2cvt_dat_pd)               
  ,.cq_wr_pvld              (cq_wr_pvld)                   
  ,.cq_wr_prdy              (cq_wr_prdy)                   
  ,.cq_wr_thread_id         (cq_wr_thread_id[2:0])         
  ,.cq_wr_pd                (cq_wr_pd[2:0])                
  ,.mcif2noc_axi_aw_awvalid (mcif2noc_axi_aw_awvalid)      
  ,.mcif2noc_axi_aw_awready (mcif2noc_axi_aw_awready)      
  ,.mcif2noc_axi_aw_awid    (mcif2noc_axi_aw_awid[7:0])    
  ,.mcif2noc_axi_aw_awlen   (mcif2noc_axi_aw_awlen[3:0])   
  ,.mcif2noc_axi_aw_awaddr  (mcif2noc_axi_aw_awaddr[31:0]) 
  ,.mcif2noc_axi_w_wvalid   (mcif2noc_axi_w_wvalid)        
  ,.mcif2noc_axi_w_wready   (mcif2noc_axi_w_wready)        
  ,.mcif2noc_axi_w_wdata    (mcif2noc_axi_w_wdata)  
  ,.mcif2noc_axi_w_wstrb    (mcif2noc_axi_w_wstrb[31:0])   
  ,.mcif2noc_axi_w_wlast    (mcif2noc_axi_w_wlast)         
  ,.eg2ig_axi_len           (eg2ig_axi_len[1:0])           
  ,.eg2ig_axi_vld           (eg2ig_axi_vld)                
  ,.reg2dp_wr_os_cnt        (reg2dp_wr_os_cnt[7:0])        
  );


endmodule // NV_NVDLA_MCIF_WRITE_ig

