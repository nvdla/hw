// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_img.v

#include "NV_NVDLA_CDMA_define.h"

module NV_NVDLA_CDMA_img (
   img_dat2mcif_rd_req_ready  //|< i
  ,mcif2img_dat_rd_rsp_pd     //|< i
  ,mcif2img_dat_rd_rsp_valid  //|< i
  ,img_dat2mcif_rd_req_pd     //|> o
  ,img_dat2mcif_rd_req_valid  //|> o
  ,mcif2img_dat_rd_rsp_ready  //|> o
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cvif2img_dat_rd_rsp_pd     //|< i
  ,cvif2img_dat_rd_rsp_valid  //|< i
  ,img_dat2cvif_rd_req_ready  //|< i
  ,cvif2img_dat_rd_rsp_ready  //|> o
  ,img_dat2cvif_rd_req_pd     //|> o
  ,img_dat2cvif_rd_req_valid  //|> o
  #endif
  ,nvdla_core_clk             //|< i
  ,nvdla_core_ng_clk          //|< i
  ,nvdla_core_rstn            //|< i
  ,pwrbus_ram_pd              //|< i
  ,reg2dp_conv_mode           //|< i
  ,reg2dp_data_bank           //|< i
  ,reg2dp_data_reuse          //|< i
  ,reg2dp_datain_addr_high_0  //|< i
  ,reg2dp_datain_addr_high_1  //|< i
  ,reg2dp_datain_addr_low_0   //|< i
  ,reg2dp_datain_addr_low_1   //|< i
  ,reg2dp_datain_channel      //|< i
  ,reg2dp_datain_format       //|< i
  ,reg2dp_datain_height       //|< i
  ,reg2dp_datain_ram_type     //|< i
  ,reg2dp_datain_width        //|< i
  ,reg2dp_dma_en              //|< i
  ,reg2dp_entries             //|< i
  ,reg2dp_in_precision        //|< i
  ,reg2dp_line_stride         //|< i
  ,reg2dp_mean_ax             //|< i
  ,reg2dp_mean_bv             //|< i
  ,reg2dp_mean_format         //|< i
  ,reg2dp_mean_gu             //|< i
  ,reg2dp_mean_ry             //|< i
  ,reg2dp_op_en               //|< i
  ,reg2dp_pad_left            //|< i
  ,reg2dp_pad_right           //|< i
  ,reg2dp_pixel_format        //|< i
  ,reg2dp_pixel_mapping       //|< i
  ,reg2dp_pixel_sign_override //|< i
  ,reg2dp_pixel_x_offset      //|< i
  ,reg2dp_pixel_y_offset      //|< i
  ,reg2dp_proc_precision      //|< i
  ,reg2dp_rsv_height          //|< i *
  ,reg2dp_rsv_per_line        //|< i *
  ,reg2dp_rsv_per_uv_line     //|< i *
  ,reg2dp_rsv_y_index         //|< i *
  ,reg2dp_skip_data_rls       //|< i
  ,reg2dp_uv_line_stride      //|< i
  ,sc2cdma_dat_pending_req    //|< i
  ,status2dma_free_entries    //|< i
  ,status2dma_fsm_switch      //|< i
  ,status2dma_valid_slices    //|< i *
  ,status2dma_wr_idx          //|< i
  ,dp2reg_img_rd_latency      //|> o
  ,dp2reg_img_rd_stall        //|> o
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:      ,img2cvt_dat_wr_sel  
//:      ,img2cvt_dat_wr_addr  
//:      ,img2cvt_dat_wr_data 
//:      ,img2cvt_mn_wr_data 
//:      ,img2cvt_dat_wr_pad_mask
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:          ,img2cvt_dat_wr_mask
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:              ,img2cvt_dat_wr_addr${i}  
//:              ,img2cvt_dat_wr_data${i} 
//:              ,img2cvt_mn_wr_data${i} 
//:              ,img2cvt_dat_wr_pad_mask${i}
//:         );
//:     }
//: } else {
//:     print qq(
//:      ,img2cvt_dat_wr_addr
//:      ,img2cvt_dat_wr_data
//:      ,img2cvt_mn_wr_data
//:      ,img2cvt_dat_wr_pad_mask
//:     );
//: }
  ,img2cvt_dat_wr_en          //|> o
  ,img2cvt_dat_wr_info_pd     //|> o
  //,img2cvt_dat_wr_pad_mask    //|> o

//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_CDMA_BPE; ##atomic_m BW
//: my $M = $dmaif/$atmm;  ##atomic_m number per dma transaction
//: foreach my $i (0..$M-1) {
//:     print qq(
//:         ,img2sbuf_p${i}_wr_en     
//:         ,img2sbuf_p${i}_wr_addr 
//:         ,img2sbuf_p${i}_wr_data 
//:         ,img2sbuf_p${i}_rd_en 
//:         ,img2sbuf_p${i}_rd_addr 
//:         ,img2sbuf_p${i}_rd_data 
//:     );
//: }
  ,img2status_dat_entries     //|> o
  ,img2status_dat_slices      //|> o
  ,img2status_dat_updt        //|> o
  ,img2status_state           //|> o
  ,slcg_img_gate_dc           //|> o
  ,slcg_img_gate_wg           //|> o
  );

///////////////////////////////////////////////////////////////////////////
input  nvdla_core_clk;
input  nvdla_core_rstn;

input [31:0] pwrbus_ram_pd;

output        img_dat2mcif_rd_req_valid;
input         img_dat2mcif_rd_req_ready;
output [NVDLA_CDMA_MEM_RD_REQ-1:0] img_dat2mcif_rd_req_pd;
input          mcif2img_dat_rd_rsp_valid;
output         mcif2img_dat_rd_rsp_ready;
input  [NVDLA_CDMA_MEM_RD_RSP-1:0] mcif2img_dat_rd_rsp_pd;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
output        img_dat2cvif_rd_req_valid;
input         img_dat2cvif_rd_req_ready;
output [NVDLA_CDMA_MEM_RD_REQ-1:0] img_dat2cvif_rd_req_pd;
input          cvif2img_dat_rd_rsp_valid;
output         cvif2img_dat_rd_rsp_ready;
input  [NVDLA_CDMA_MEM_RD_RSP-1:0] cvif2img_dat_rd_rsp_pd;
#endif

output          img2cvt_dat_wr_en; 
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $Bnum = $dmaif / NVDLA_BPE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:      output [${k}-1:0]     img2cvt_dat_wr_sel ;
//:      output [16:0]         img2cvt_dat_wr_addr; 
//:      output [${dmaif}-1:0] img2cvt_dat_wr_data;
//:      output [${Bnum}*16-1:0] img2cvt_mn_wr_data;
//:      output [$Bnum-1:0]    img2cvt_dat_wr_pad_mask;
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:      output   [${k}-1:0]      img2cvt_dat_wr_mask;
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:              output [16:0]         img2cvt_dat_wr_addr${i}; 
//:              output [${dmaif}-1:0] img2cvt_dat_wr_data${i};
//:              output [${Bnum}*16-1:0] img2cvt_mn_wr_data${i};
//:              output [$Bnum-1:0]    img2cvt_dat_wr_pad_mask${i};
//:         );
//:     }
//: } else {
//:     print qq(
//:      output [16:0]         img2cvt_dat_wr_addr;  
//:      output [${dmaif}-1:0] img2cvt_dat_wr_data;
//:      output [${Bnum}*16-1:0] img2cvt_mn_wr_data;
//:      output [$Bnum-1:0]    img2cvt_dat_wr_pad_mask;
//:     );
//: }
output [11:0] img2cvt_dat_wr_info_pd;
////: my $ele_num=NVDLA_CDMA_DMAIF_BW/NVDLA_CDMA_BPE;
////: print qq( output [${ele_num}-1:0] img2cvt_dat_wr_pad_mask;  );

output [1:0]  img2status_state;
output        img2status_dat_updt;
output [14:0] img2status_dat_entries;
output [13:0] img2status_dat_slices;
input [13:0]  status2dma_valid_slices;
input [14:0]  status2dma_free_entries;
input [14:0]  status2dma_wr_idx;
input         status2dma_fsm_switch;

//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_CDMA_BPE; ##atomic_m BW
//: my $M = $dmaif/$atmm;  ##atomic_m number per dma transaction
//: foreach my $i (0..$M-1) {
//:     print qq(
//:          output               img2sbuf_p${i}_wr_en  ;  
//:          output [7:0]         img2sbuf_p${i}_wr_addr;
//:          output [${atmm}-1:0] img2sbuf_p${i}_wr_data;
//:          output               img2sbuf_p${i}_rd_en;
//:          output [7:0]         img2sbuf_p${i}_rd_addr;
//:          input  [${atmm}-1:0] img2sbuf_p${i}_rd_data;
//:     );
//: }

input  sc2cdma_dat_pending_req;

input nvdla_core_ng_clk;

input [0:0]                     reg2dp_op_en;
input [0:0]                  reg2dp_conv_mode;
input [1:0]               reg2dp_in_precision;
input [1:0]             reg2dp_proc_precision;
input [0:0]                 reg2dp_data_reuse;
input [0:0]              reg2dp_skip_data_rls;
input [0:0]         reg2dp_datain_format;
input [5:0]          reg2dp_pixel_format;
input [0:0]         reg2dp_pixel_mapping;
input [0:0]   reg2dp_pixel_sign_override;
input [12:0]          reg2dp_datain_width;
input [12:0]         reg2dp_datain_height;
input [12:0]        reg2dp_datain_channel;
input [4:0]         reg2dp_pixel_x_offset;
input [2:0]         reg2dp_pixel_y_offset;
input [0:0]       reg2dp_datain_ram_type;
input [31:0] reg2dp_datain_addr_high_0;
input [31:0]   reg2dp_datain_addr_low_0;
input [31:0]   reg2dp_datain_addr_low_1;
input [31:0]   reg2dp_line_stride;
input [31:0]   reg2dp_uv_line_stride;
input [31:0] reg2dp_datain_addr_high_1;
input [0:0]             reg2dp_mean_format;
input [15:0]               reg2dp_mean_ry;
input [15:0]               reg2dp_mean_gu;
input [15:0]               reg2dp_mean_bv;
input [15:0]               reg2dp_mean_ax;
input [13:0]             reg2dp_entries;
input [4:0]               reg2dp_pad_left;
input [5:0]              reg2dp_pad_right;
//input [NVDLA_CDMA_D_ZERO_PADDING_VALUE_0_PAD_VALUE_SIZE-1:0]        reg2dp_pad_value;
input [4:0]                      reg2dp_data_bank;
input [0:0]                  reg2dp_dma_en;
input [9:0]         reg2dp_rsv_per_line;
input [9:0]      reg2dp_rsv_per_uv_line;
input [2:0]           reg2dp_rsv_height;
input [4:0]          reg2dp_rsv_y_index;

output slcg_img_gate_dc;
output slcg_img_gate_wg;

output [31:0]       dp2reg_img_rd_stall;
output [31:0]   dp2reg_img_rd_latency;
/////////////////////////////////////////////////////////////////////////////////////////
wire        is_running;
wire        layer_st;
wire        pack_is_done;
wire  [5:0] pixel_bank;
wire        pixel_data_expand;
wire        pixel_data_shrink;
wire        pixel_early_end;
wire [10:0] pixel_order;
wire        pixel_packed_10b;
wire        pixel_planar;
wire  [3:0] pixel_planar0_bundle_limit;
wire  [3:0] pixel_planar0_bundle_limit_1st;
//: my $atmmbw = int( log(NVDLA_MEMORY_ATOMIC_SIZE) / log(2) );
//: print qq(
//:     wire      [${atmmbw}-1:0] pixel_planar0_byte_sft;
//:     wire      [${atmmbw}-1:0] pixel_planar1_byte_sft;
//: );
wire  [3:0] pixel_planar0_lp_burst;
wire        pixel_planar0_lp_vld;
wire  [3:0] pixel_planar0_rp_burst;
wire        pixel_planar0_rp_vld;
wire  [2:0] pixel_planar0_sft;
wire [13:0] pixel_planar0_width_burst;
wire  [4:0] pixel_planar1_bundle_limit;
wire  [4:0] pixel_planar1_bundle_limit_1st;
wire  [2:0] pixel_planar1_lp_burst;
wire        pixel_planar1_lp_vld;
wire  [2:0] pixel_planar1_rp_burst;
wire        pixel_planar1_rp_vld;
wire  [2:0] pixel_planar1_sft;
wire [13:0] pixel_planar1_width_burst;
wire  [1:0] pixel_precision;
wire        pixel_uint;
wire [14:0] sg2pack_data_entries;
wire [14:0] sg2pack_entry_end;
wire [14:0] sg2pack_entry_mid;
wire [14:0] sg2pack_entry_st;
wire [12:0] sg2pack_height_total;
wire [10:0] sg2pack_img_pd;
wire        sg2pack_img_prdy;
wire        sg2pack_img_pvld;
wire        sg2pack_mn_enable;
wire  [3:0] sg2pack_sub_h_end;
wire  [3:0] sg2pack_sub_h_mid;
wire  [3:0] sg2pack_sub_h_st;
wire        sg_is_done;
/////////////////////////////////////////////////////////////////////////////////////////
    
NV_NVDLA_CDMA_IMG_ctrl u_ctrl (
   .nvdla_core_clk                 (nvdla_core_clk)                     
  ,.nvdla_core_ng_clk              (nvdla_core_ng_clk)                  
  ,.nvdla_core_rstn                (nvdla_core_rstn)                    
  ,.pack_is_done                   (pack_is_done)                       
  ,.sc2cdma_dat_pending_req        (sc2cdma_dat_pending_req)            
  ,.sg_is_done                     (sg_is_done)                         
  ,.status2dma_fsm_switch          (status2dma_fsm_switch)              
  ,.img2status_state               (img2status_state[1:0])              
  ,.is_running                     (is_running)                         
  ,.layer_st                       (layer_st)                           
  ,.pixel_bank                     (pixel_bank)                    
  ,.pixel_data_expand              (pixel_data_expand)                  
  ,.pixel_data_shrink              (pixel_data_shrink)                  
  ,.pixel_early_end                (pixel_early_end)                    
  ,.pixel_order                    (pixel_order)                  
  ,.pixel_packed_10b               (pixel_packed_10b)                   
  ,.pixel_planar                   (pixel_planar)                       
  ,.pixel_planar0_bundle_limit     (pixel_planar0_bundle_limit)    
  ,.pixel_planar0_bundle_limit_1st (pixel_planar0_bundle_limit_1st)
  ,.pixel_planar0_byte_sft         (pixel_planar0_byte_sft)        
  ,.pixel_planar0_lp_burst         (pixel_planar0_lp_burst)        
  ,.pixel_planar0_lp_vld           (pixel_planar0_lp_vld)               
  ,.pixel_planar0_rp_burst         (pixel_planar0_rp_burst)        
  ,.pixel_planar0_rp_vld           (pixel_planar0_rp_vld)               
  ,.pixel_planar0_sft              (pixel_planar0_sft)             
  ,.pixel_planar0_width_burst      (pixel_planar0_width_burst)    
  ,.pixel_planar1_bundle_limit     (pixel_planar1_bundle_limit)    
  ,.pixel_planar1_bundle_limit_1st (pixel_planar1_bundle_limit_1st)
  ,.pixel_planar1_byte_sft         (pixel_planar1_byte_sft)        
  ,.pixel_planar1_lp_burst         (pixel_planar1_lp_burst)        
  ,.pixel_planar1_lp_vld           (pixel_planar1_lp_vld)               
  ,.pixel_planar1_rp_burst         (pixel_planar1_rp_burst)        
  ,.pixel_planar1_rp_vld           (pixel_planar1_rp_vld)               
  ,.pixel_planar1_sft              (pixel_planar1_sft)             
  ,.pixel_planar1_width_burst      (pixel_planar1_width_burst)    
  ,.pixel_precision                (pixel_precision)               
  ,.pixel_uint                     (pixel_uint)                         
  ,.slcg_img_gate_dc               (slcg_img_gate_dc)                   
  ,.slcg_img_gate_wg               (slcg_img_gate_wg)                   
  ,.reg2dp_op_en                   (reg2dp_op_en[0])                    
  ,.reg2dp_conv_mode               (reg2dp_conv_mode[0])                
  ,.reg2dp_in_precision            (reg2dp_in_precision[1:0])           
  ,.reg2dp_proc_precision          (reg2dp_proc_precision[1:0])         
  ,.reg2dp_datain_format           (reg2dp_datain_format[0])            
  ,.reg2dp_pixel_format            (reg2dp_pixel_format[5:0])           
  ,.reg2dp_pixel_mapping           (reg2dp_pixel_mapping[0])            
  ,.reg2dp_pixel_sign_override     (reg2dp_pixel_sign_override[0])      
  ,.reg2dp_datain_width            (reg2dp_datain_width[12:0])          
  ,.reg2dp_data_reuse              (reg2dp_data_reuse[0])               
  ,.reg2dp_skip_data_rls           (reg2dp_skip_data_rls[0])            
  ,.reg2dp_data_bank               (reg2dp_data_bank[4:0])
  ,.reg2dp_pixel_x_offset          (reg2dp_pixel_x_offset[4:0])         
  ,.reg2dp_pad_left                (reg2dp_pad_left[4:0])               
  ,.reg2dp_pad_right               (reg2dp_pad_right[5:0])              
  );

NV_NVDLA_CDMA_IMG_sg u_sg (
   .nvdla_core_clk                 (nvdla_core_clk)                     
  ,.nvdla_core_rstn                (nvdla_core_rstn)                    
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,.cvif2img_dat_rd_rsp_pd         (cvif2img_dat_rd_rsp_pd)      
  ,.cvif2img_dat_rd_rsp_valid      (cvif2img_dat_rd_rsp_valid)          
  ,.img_dat2cvif_rd_req_ready      (img_dat2cvif_rd_req_ready)          
  ,.cvif2img_dat_rd_rsp_ready      (cvif2img_dat_rd_rsp_ready)          
  ,.img_dat2cvif_rd_req_pd         (img_dat2cvif_rd_req_pd)       
  ,.img_dat2cvif_rd_req_valid      (img_dat2cvif_rd_req_valid)          
#endif
  ,.img2status_dat_entries         (img2status_dat_entries)       
  ,.img2status_dat_updt            (img2status_dat_updt)                
  ,.is_running                     (is_running)                         
  ,.layer_st                       (layer_st)                           
  ,.img_dat2mcif_rd_req_pd         (img_dat2mcif_rd_req_pd)       
  ,.img_dat2mcif_rd_req_valid      (img_dat2mcif_rd_req_valid)          
  ,.img_dat2mcif_rd_req_ready      (img_dat2mcif_rd_req_ready)          
  ,.mcif2img_dat_rd_rsp_pd         (mcif2img_dat_rd_rsp_pd)      
  ,.mcif2img_dat_rd_rsp_valid      (mcif2img_dat_rd_rsp_valid)          
  ,.mcif2img_dat_rd_rsp_ready      (mcif2img_dat_rd_rsp_ready)          
  ,.pixel_order                    (pixel_order[10:0])                  
  ,.pixel_planar                   (pixel_planar)                       
  ,.pixel_planar0_bundle_limit     (pixel_planar0_bundle_limit[3:0])    
  ,.pixel_planar0_bundle_limit_1st (pixel_planar0_bundle_limit_1st[3:0])
  ,.pixel_planar0_byte_sft         (pixel_planar0_byte_sft)        
  ,.pixel_planar0_lp_burst         (pixel_planar0_lp_burst[3:0])        
  ,.pixel_planar0_lp_vld           (pixel_planar0_lp_vld)               
  ,.pixel_planar0_rp_burst         (pixel_planar0_rp_burst[3:0])        
  ,.pixel_planar0_rp_vld           (pixel_planar0_rp_vld)               
  ,.pixel_planar0_width_burst      (pixel_planar0_width_burst )   
  ,.pixel_planar1_bundle_limit     (pixel_planar1_bundle_limit[4:0])    
  ,.pixel_planar1_bundle_limit_1st (pixel_planar1_bundle_limit_1st[4:0])
  ,.pixel_planar1_byte_sft         (pixel_planar1_byte_sft)        
  ,.pixel_planar1_lp_burst         (pixel_planar1_lp_burst[2:0])        
  ,.pixel_planar1_lp_vld           (pixel_planar1_lp_vld)               
  ,.pixel_planar1_rp_burst         (pixel_planar1_rp_burst[2:0])        
  ,.pixel_planar1_rp_vld           (pixel_planar1_rp_vld)               
  ,.pixel_planar1_width_burst      (pixel_planar1_width_burst)    
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])                
  ,.reg2dp_op_en                   (reg2dp_op_en)                       
  ,.sg2pack_img_prdy               (sg2pack_img_prdy)                   
  ,.status2dma_free_entries        (status2dma_free_entries)      
  ,.status2dma_fsm_switch          (status2dma_fsm_switch)              
//: my $dmaif = NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE;
//: my $atmm_num = ($dmaif / $atmm);
//: foreach my $i(0..$atmm_num -1) {
//:     print qq(
//:       ,.img2sbuf_p${i}_wr_addr    (img2sbuf_p${i}_wr_addr)
//:       ,.img2sbuf_p${i}_wr_data    (img2sbuf_p${i}_wr_data)       
//:       ,.img2sbuf_p${i}_wr_en      (img2sbuf_p${i}_wr_en)        
//:     );
//: }
  ,.sg2pack_data_entries           (sg2pack_data_entries)         
  ,.sg2pack_entry_end              (sg2pack_entry_end)            
  ,.sg2pack_entry_mid              (sg2pack_entry_mid)            
  ,.sg2pack_entry_st               (sg2pack_entry_st)             
  ,.sg2pack_height_total           (sg2pack_height_total[12:0])         
  ,.sg2pack_img_pd                 (sg2pack_img_pd[10:0])               
  ,.sg2pack_img_pvld               (sg2pack_img_pvld)                   
  ,.sg2pack_mn_enable              (sg2pack_mn_enable)                  
  ,.sg2pack_sub_h_end              (sg2pack_sub_h_end[3:0])             
  ,.sg2pack_sub_h_mid              (sg2pack_sub_h_mid[3:0])             
  ,.sg2pack_sub_h_st               (sg2pack_sub_h_st[3:0])              
  ,.sg_is_done                     (sg_is_done)                         
  ,.reg2dp_pixel_y_offset          (reg2dp_pixel_y_offset[2:0])         
  ,.reg2dp_datain_height           (reg2dp_datain_height[12:0])         
  ,.reg2dp_datain_ram_type         (reg2dp_datain_ram_type[0])          
  ,.reg2dp_datain_addr_high_0      (reg2dp_datain_addr_high_0[31:0])    
  ,.reg2dp_datain_addr_low_0       (reg2dp_datain_addr_low_0)     
  ,.reg2dp_datain_addr_high_1      (reg2dp_datain_addr_high_1[31:0])    
  ,.reg2dp_datain_addr_low_1       (reg2dp_datain_addr_low_1)     
  ,.reg2dp_line_stride             (reg2dp_line_stride)           
  ,.reg2dp_uv_line_stride          (reg2dp_uv_line_stride)        
  ,.reg2dp_mean_format             (reg2dp_mean_format[0])              
  ,.reg2dp_entries                 (reg2dp_entries[13:0])               
  ,.reg2dp_dma_en                  (reg2dp_dma_en[0])                   
  ,.dp2reg_img_rd_stall            (dp2reg_img_rd_stall[31:0])          
  ,.dp2reg_img_rd_latency          (dp2reg_img_rd_latency[31:0])        
  );

NV_NVDLA_CDMA_IMG_pack u_pack (
   .nvdla_core_clk                 (nvdla_core_clk)                     
  ,.nvdla_core_rstn                (nvdla_core_rstn)                    
//: my $dmaif = NVDLA_CDMA_DMAIF_BW;
//: my $atmm = NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE;
//: my $atmm_num = ($dmaif / $atmm);
//: foreach my $i(0..$atmm_num -1) {
//:     print qq(
//:       ,.img2sbuf_p${i}_rd_data            (img2sbuf_p${i}_rd_data)         
//:       ,.img2sbuf_p${i}_rd_addr            (img2sbuf_p${i}_rd_addr)           
//:       ,.img2sbuf_p${i}_rd_en              (img2sbuf_p${i}_rd_en)                  
//:     );
//: }
  ,.is_running                     (is_running)                         
  ,.layer_st                       (layer_st)                           
  ,.pixel_bank                     (pixel_bank)                    
  ,.pixel_data_expand              (pixel_data_expand)                  
  ,.pixel_data_shrink              (pixel_data_shrink)                  
  ,.pixel_early_end                (pixel_early_end)                    
  ,.pixel_packed_10b               (pixel_packed_10b)                   
  ,.pixel_planar                   (pixel_planar)                       
  ,.pixel_planar0_sft              (pixel_planar0_sft[2:0])             
  ,.pixel_planar1_sft              (pixel_planar1_sft[2:0])             
  ,.pixel_precision                (pixel_precision[1:0])               
  ,.pixel_uint                     (pixel_uint)                         
  ,.sg2pack_data_entries           (sg2pack_data_entries)         
  ,.sg2pack_entry_end              (sg2pack_entry_end)            
  ,.sg2pack_entry_mid              (sg2pack_entry_mid)            
  ,.sg2pack_entry_st               (sg2pack_entry_st)             
  ,.sg2pack_height_total           (sg2pack_height_total[12:0])         
  ,.sg2pack_img_pd                 (sg2pack_img_pd[10:0])               
  ,.sg2pack_img_pvld               (sg2pack_img_pvld)                   
  ,.sg2pack_mn_enable              (sg2pack_mn_enable)                  
  ,.sg2pack_sub_h_end              (sg2pack_sub_h_end[3:0])             
  ,.sg2pack_sub_h_mid              (sg2pack_sub_h_mid[3:0])             
  ,.sg2pack_sub_h_st               (sg2pack_sub_h_st[3:0])              
  ,.status2dma_wr_idx              (status2dma_wr_idx[14:0])            
//: my $dmaif=NVDLA_CDMA_DMAIF_BW;
//: my $Bnum = $dmaif / NVDLA_BPE;
//: my $atmc=NVDLA_MAC_ATOMIC_C_SIZE*NVDLA_CDMA_BPE;
//: if($dmaif < $atmc) {
//:     my $k = int(log(int($atmc/$dmaif))/log(2));
//:     print qq(
//:      ,.img2cvt_dat_wr_sel       (img2cvt_dat_wr_sel       )
//:      ,.img2cvt_dat_wr_addr      (img2cvt_dat_wr_addr      )
//:      ,.img2cvt_dat_wr_data      (img2cvt_dat_wr_data      )
//:      ,.img2cvt_mn_wr_data       (img2cvt_mn_wr_data       )
//:      ,.img2cvt_dat_wr_pad_mask  (img2cvt_dat_wr_pad_mask  )
//:     );
//: } elsif($dmaif > $atmc) {
//:     my $k = int(log(int($dmaif/$atmc))/log(2));
//:     print qq(
//:         ,.img2cvt_dat_wr_mask       (img2cvt_dat_wr_mask    )
//:     );
//:     foreach my $i (0..$k-1) {
//:         print qq(
//:              ,.img2cvt_dat_wr_addr${i}      (img2cvt_dat_wr_addr${i}      )
//:              ,.img2cvt_dat_wr_data${i}      (img2cvt_dat_wr_data${i}      )
//:              ,.img2cvt_mn_wr_data${i}       (img2cvt_mn_wr_data${i}       )
//:              ,.img2cvt_dat_wr_pad_mask${i}  (img2cvt_dat_wr_pad_mask${i}  )
//:         );
//:     }
//: } else {
//:     print qq(
//:      ,.img2cvt_dat_wr_addr      (img2cvt_dat_wr_addr      )
//:      ,.img2cvt_dat_wr_data      (img2cvt_dat_wr_data      )
//:      ,.img2cvt_mn_wr_data       (img2cvt_mn_wr_data       )
//:      ,.img2cvt_dat_wr_pad_mask  (img2cvt_dat_wr_pad_mask  )
//:     );
//: }
  //,.img2cvt_dat_wr_addr            (img2cvt_dat_wr_addr[11:0])          
  //,.img2cvt_dat_wr_data            (img2cvt_dat_wr_data)        
  ,.img2cvt_dat_wr_en              (img2cvt_dat_wr_en)                  
  //,.img2cvt_dat_wr_hsel            (img2cvt_dat_wr_sel)                
  ,.img2cvt_dat_wr_info_pd         (img2cvt_dat_wr_info_pd[11:0])       
  //,.img2cvt_mn_wr_data             (img2cvt_mn_wr_data)         
  ,.img2status_dat_entries         (img2status_dat_entries)       
  ,.img2status_dat_slices          (img2status_dat_slices)        
  ,.img2status_dat_updt            (img2status_dat_updt)                
  ,.pack_is_done                   (pack_is_done)                       
  ,.sg2pack_img_prdy               (sg2pack_img_prdy)                   
  ,.reg2dp_datain_width            (reg2dp_datain_width[12:0])          
  ,.reg2dp_datain_channel          (reg2dp_datain_channel[12:0])        
  ,.reg2dp_mean_ry                 (reg2dp_mean_ry[15:0])               
  ,.reg2dp_mean_gu                 (reg2dp_mean_gu[15:0])               
  ,.reg2dp_mean_bv                 (reg2dp_mean_bv[15:0])               
  ,.reg2dp_mean_ax                 (reg2dp_mean_ax[15:0])               
  ,.reg2dp_pad_left                (reg2dp_pad_left[4:0])               
  ,.reg2dp_pad_right               (reg2dp_pad_right[5:0])              
  //,.img2cvt_dat_wr_pad_mask        (img2cvt_dat_wr_pad_mask)     
  );

endmodule // NV_NVDLA_CDMA_img


