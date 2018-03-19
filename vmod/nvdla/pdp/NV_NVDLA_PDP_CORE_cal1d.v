// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_PDP_CORE_cal1d.v

#include "NV_NVDLA_PDP_define.h"

module NV_NVDLA_PDP_CORE_cal1d (
   nvdla_core_clk             
  ,nvdla_core_rstn            
  ,datin_src_cfg              
  ,dp2reg_done                
  ,padding_h_cfg              
  ,pdp_rdma2dp_pd             
  ,pdp_rdma2dp_valid          
  ,pooling1d_prdy             
  ,pooling_channel_cfg        
  ,pooling_fwidth_cfg         
  ,pooling_lwidth_cfg         
  ,pooling_mwidth_cfg         
  ,pooling_out_fwidth_cfg     
  ,pooling_out_lwidth_cfg     
  ,pooling_out_mwidth_cfg     
  ,pooling_size_h_cfg         
  ,pooling_splitw_num_cfg     
  ,pooling_stride_h_cfg       
  ,pooling_type_cfg           
  ,pwrbus_ram_pd              
  ,reg2dp_cube_in_height      
  ,reg2dp_cube_in_width       
  ,reg2dp_cube_out_width      
  //,reg2dp_input_data          
  //,reg2dp_int16_en            
  //,reg2dp_int8_en             
  ,reg2dp_kernel_stride_width 
  ,reg2dp_kernel_width        
  ,reg2dp_op_en               
  ,reg2dp_pad_left            
  ,reg2dp_pad_right           
  ,reg2dp_pad_right_cfg       
  ,reg2dp_pad_value_1x_cfg    
  ,reg2dp_pad_value_2x_cfg    
  ,reg2dp_pad_value_3x_cfg    
  ,reg2dp_pad_value_4x_cfg    
  ,reg2dp_pad_value_5x_cfg    
  ,reg2dp_pad_value_6x_cfg    
  ,reg2dp_pad_value_7x_cfg    
  ,sdp2pdp_pd                 
  ,sdp2pdp_valid              
  ,pdp_op_start               
  ,pdp_rdma2dp_ready          
  ,pooling1d_pd               
  ,pooling1d_pvld             
  ,sdp2pdp_ready              
  );
//////////////////////////////////////////////////////////////////////////
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          datin_src_cfg;
input          dp2reg_done;
input    [2:0] padding_h_cfg;
input   [NVDLA_PDP_THROUGHPUT*NVDLA_BPE+11:0] pdp_rdma2dp_pd;
input          pdp_rdma2dp_valid;
input          pooling1d_prdy;
input   [12:0] pooling_channel_cfg;
input    [9:0] pooling_fwidth_cfg;
input    [9:0] pooling_lwidth_cfg;
input    [9:0] pooling_mwidth_cfg;
input    [9:0] pooling_out_fwidth_cfg;
input    [9:0] pooling_out_lwidth_cfg;
input    [9:0] pooling_out_mwidth_cfg;
input    [2:0] pooling_size_h_cfg;
input    [7:0] pooling_splitw_num_cfg;
input    [3:0] pooling_stride_h_cfg;
input    [1:0] pooling_type_cfg;
input   [31:0] pwrbus_ram_pd;
input   [12:0] reg2dp_cube_in_height;
input   [12:0] reg2dp_cube_in_width;
input   [12:0] reg2dp_cube_out_width;
//input    [1:0] reg2dp_input_data;
//input          reg2dp_int16_en;
//input          reg2dp_int8_en;
input    [3:0] reg2dp_kernel_stride_width;
input    [2:0] reg2dp_kernel_width;
input          reg2dp_op_en;
input    [2:0] reg2dp_pad_left;
input    [2:0] reg2dp_pad_right;
input    [2:0] reg2dp_pad_right_cfg;
input   [18:0] reg2dp_pad_value_1x_cfg;
input   [18:0] reg2dp_pad_value_2x_cfg;
input   [18:0] reg2dp_pad_value_3x_cfg;
input   [18:0] reg2dp_pad_value_4x_cfg;
input   [18:0] reg2dp_pad_value_5x_cfg;
input   [18:0] reg2dp_pad_value_6x_cfg;
input   [18:0] reg2dp_pad_value_7x_cfg;
input   [NVDLA_PDP_THROUGHPUT*NVDLA_BPE+11:0] sdp2pdp_pd;
input          sdp2pdp_valid;
output         pdp_op_start;
output         pdp_rdma2dp_ready;
//: my $m = NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+6);
//: print " output [$m-1:0] pooling1d_pd; \n";
output         pooling1d_pvld;
output         sdp2pdp_ready;
//////////////////////////////////////////////////////////////////////////
//wire 
wire           average_pooling_en;
wire           big_stride;
wire           bsync;
wire           bubble_en_end;
wire     [2:0] bubble_num_dec;
wire    [12:0] cube_out_channel;
wire     [3:0] cube_width_in;
wire           cur_datin_disable_sync;
wire    [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3)-1:0] datain_ext;
wire    [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3)+8:0] datin_buf;
wire     [2:0] first_out_num_dec2;
wire           first_splitw;
wire           first_splitw_en;
wire           init_cnt;
wire     [7:0] init_unit1d_set;
wire    [10:0] k_add_ks;
wire     [4:0] kernel_padl;
wire     [4:0] ks_width;
wire           last_c;
wire           last_c_sync;
wire           last_line_in;
wire           last_out_done;
wire           last_out_en_sync;
wire           last_pooling_flag;
wire           last_splitw;
wire           last_splitw_en;
wire           line_last_stripe_done;
wire           line_ldata_valid;
wire     [2:0] line_regs_1;
wire     [2:0] line_regs_2;
wire     [2:0] line_regs_3;
wire     [2:0] line_regs_4;
wire           load_din;
wire           loading_en;
wire     [2:0] mon_first_out_num_dec2;
wire           mon_overlap;
wire     [1:0] mon_overlap_ff;
wire     [0:0] mon_pad_table_index;
wire           mon_rest_width;
wire     [5:0] mon_strip_xcnt_offset;
//wire     [0:0] mon_unit1d_actv_data_16bit_0;
//wire     [0:0] mon_unit1d_actv_data_16bit_0_ff;
//wire     [0:0] mon_unit1d_actv_data_16bit_1;
//wire     [0:0] mon_unit1d_actv_data_16bit_1_ff;
//wire     [0:0] mon_unit1d_actv_data_16bit_2;
//wire     [0:0] mon_unit1d_actv_data_16bit_2_ff;
//wire     [0:0] mon_unit1d_actv_data_16bit_3;
//wire     [0:0] mon_unit1d_actv_data_16bit_3_ff;
wire           non_split_small_active;
wire     [3:0] non_split_w_pl;
wire     [4:0] non_split_w_pl_pr;
wire           non_splitw;
wire           off_flying_en;
wire           on_flying_en;
wire     [3:0] overlap;
wire     [2:0] overlap_ff;
wire     [2:0] pad_l;
wire     [2:0] pad_r;
wire     [2:0] pad_table_index;
wire           padding_here;
//wire           padding_here_int16;
wire           padding_here_int8;
wire     [2:0] padding_stride1_num;
wire     [2:0] padding_stride2_num;
wire     [2:0] padding_stride3_num;
wire     [2:0] padding_stride4_num;
wire    [10:0] partial_w_last;
wire           pdp_cube_end;
wire           pdp_cube_sync;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3) + 12:0] pdp_datin_pd;
wire   [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3) + 12:0] pdp_datin_pd_f0;
wire    [NVDLA_PDP_THROUGHPUT*NVDLA_BPE+11:0] pdp_datin_pd_f_0;
wire    [NVDLA_PDP_THROUGHPUT*NVDLA_BPE+11:0] pdp_datin_pd_f_mux0;
wire           pdp_datin_prdy;
wire           pdp_datin_prdy_0;
wire           pdp_datin_prdy_1;
wire           pdp_datin_prdy_f;
wire           pdp_datin_prdy_mux0;
wire           pdp_datin_pvld;
wire           pdp_datin_pvld_f;
wire           pdp_datin_pvld_mux0;
//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $b = NVDLA_BPE;
//: foreach my $m (0..$k-1) {
//:     print "wire    [$b+2:0] pdp_din_$m; \n";
//: }
wire           pdp_din_lc;
wire           pdp_din_lc_sync;
wire           pdp_full_pvld;
wire    [11:0] pdp_info_in_pd;
wire           pdp_info_in_prdy;
wire           pdp_info_in_pvld;
wire    [11:0] pdp_info_out_pd;
wire           pdp_info_out_prdy;
wire           pdp_info_out_pvld;
wire           pooling1d_data_pad_rdy;
wire           pooling1d_out_v;
wire           pooling1d_out_v_disable;
wire           pooling1d_out_v_lastout;
wire           pooling1d_out_v_norm;
wire           pooling_1d_rdy;
wire     [7:0] pooling_din_last;
wire     [7:0] pooling_din_last_sync;
wire     [3:0] pooling_size;
wire     [3:0] pooling_size_h;
wire     [4:0] pooling_stride_h;
wire           posc_last;
wire    [12:0] pout_width_cur;
wire    [12:0] rest_width;
wire    [13:0] rest_width_use;
wire           split_small_active;
wire     [5:0] split_w_olap;
wire     [6:0] split_w_olap_pr;
wire           splitw_enable;
wire           splitw_end;
wire           splitw_end_sync;
wire           splitw_start;
wire     [4:0] stride;
wire     [4:0] stride_1x;
wire     [5:0] stride_2x;
wire     [6:0] stride_3x;
wire     [6:0] stride_4x;
wire     [7:0] stride_5x;
wire     [7:0] stride_6x;
wire     [7:0] stride_7x;
wire           stride_end;
wire           strip_recieve_done;
wire           strip_width_end;
wire     [2:0] strip_xcnt_offset;
//: my $m = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $k = int(log($m)/log(2));
//: print "wire     [12-${k}:0] surface_num; \n";
//: print "reg     [12-${k}:0] surface_cnt_rd; \n";
wire           sync_switch_in_vld_d0;
wire           sync_switch_in_vld_d1;
wire    [11:0] sync_switch_out_pd;
wire           sync_switch_out_rdy;
wire           sync_switch_out_vld;
//wire    [21:0] unit1d_actv_data_16bit_0;
//wire    [21:0] unit1d_actv_data_16bit_0_ff;
//wire    [21:0] unit1d_actv_data_16bit_1;
//wire    [21:0] unit1d_actv_data_16bit_1_ff;
//wire    [21:0] unit1d_actv_data_16bit_2;
//wire    [21:0] unit1d_actv_data_16bit_2_ff;
//wire    [21:0] unit1d_actv_data_16bit_3;
//wire    [21:0] unit1d_actv_data_16bit_3_ff;

//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $b = NVDLA_BPE;
//: foreach my $m (0..$k-1) {
//:     print "wire    [$b+2:0] unit1d_actv_data_8bit_${m}; \n";
//:     print "wire    [$b+2:0] unit1d_actv_data_8bit_${m}_ff; \n";
//:     print "wire    [1:0]    mon_unit1d_actv_data_8bit_${m}; \n";
//:     print "wire    [1:0]    mon_unit1d_actv_data_8bit_${m}_ff; \n";
//: }
wire    [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3)+3:0] unit1d_actv_out;
wire           unit1d_actv_out_prdy;
wire           unit1d_actv_out_pvld;
wire     [7:0] unit1d_clr;
wire    [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3)+3:0] unit1d_out_0;
wire    [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3)+3:0] unit1d_out_1;
wire    [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3)+3:0] unit1d_out_2;
wire    [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3)+3:0] unit1d_out_3;
wire    [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3)+3:0] unit1d_out_4;
wire    [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3)+3:0] unit1d_out_5;
wire    [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3)+3:0] unit1d_out_6;
wire    [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3)+3:0] unit1d_out_7;
wire     [7:0] unit1d_out_prdy;
wire           unit1d_out_prdy_use;
wire     [7:0] unit1d_out_pvld;
wire           unit1d_out_pvld_use;
wire     [7:0] unit1d_prdy;
wire     [7:0] unit1d_pvld;
wire     [7:0] unit1d_set;
wire     [7:0] unit1d_set_trig;
wire           wr_line_dat_done;
wire           wr_subcube_dat_done;
wire           wr_surface_dat_done;
wire           wr_total_cube_done;

//reg
reg      [2:0] bubble_cnt;
reg      [2:0] bubble_num;
reg      [4:0] channel_cnt;
reg            cur_datin_disable;
reg      [4:0] first_out_num;
reg      [2:0] flush_num;
reg      [2:0] flush_num_cal;
reg      [2:0] last_out_cnt;
reg            last_out_en;
reg      [6:0] mon_first_out_num;
reg            need_bubble;
reg      [7:0] pad_r_remain;
reg     [18:0] pad_table_out;
reg      [2:0] padding_left;
reg      [2:0] padding_stride_num;
//reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3) + 12:0] pdp_datin_pd0;
//reg            pdp_datin_prdy_f0;
//reg            pdp_datin_pvld0;
reg            pdp_op_pending;
reg            pdpw_active_en;
reg    [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+6)-1:0] pooling1d_data_pad;
reg            pooling1d_data_pad_vld;
reg            pooling_din_1st_0;
reg            pooling_din_1st_1;
reg            pooling_din_1st_2;
reg            pooling_din_1st_3;
reg            pooling_din_1st_4;
reg            pooling_din_1st_5;
reg            pooling_din_1st_6;
reg            pooling_din_1st_7;
reg      [2:0] pooling_out_cnt;
reg     [12:0] pooling_pwidth;
reg      [2:0] regs_num;
reg      [2:0] samllW_flush_num;
reg      [7:0] splitw_cnt;
reg     [12:0] strip_cnt_total;
reg      [2:0] strip_xcnt_psize;
reg      [3:0] strip_xcnt_stride;
reg      [3:0] strip_xcnt_stride_f;
reg            subcube_end_flag;
reg     [NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3)+3:0] unit1d_actv_out_f;
reg      [2:0] unit1d_cnt_pooling;
reg      [2:0] unit1d_cnt_stride;
reg      [7:0] unit1d_en;
reg     [12:0] wr_line_dat_cnt;
reg      [7:0] wr_splitc_cnt;
reg     [12:0] wr_surface_dat_cnt;
////////////////////////////////////////////////////////////////
//==============================================================
//PDP start
//
//--------------------------------------------------------------
assign pdp_op_start = ~pdp_op_pending & reg2dp_op_en;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pdp_op_pending <= 1'b0;
  end else begin
    if(pdp_op_start)
         pdp_op_pending <=  1'b1;
    else if(dp2reg_done)
         pdp_op_pending <= 1'b0;
  end
end
//==============================================================
//input data source select
//--------------------------------------------------------------
assign off_flying_en = (datin_src_cfg == 1'h1 );
assign on_flying_en  = (datin_src_cfg == 1'h0 );
assign pdp_datin_pd_f_mux0 = off_flying_en?  pdp_rdma2dp_pd : sdp2pdp_pd;
assign pdp_datin_pvld_mux0 = off_flying_en?  pdp_rdma2dp_valid     : sdp2pdp_valid;
assign pdp_rdma2dp_ready = pdp_datin_prdy_mux0 & off_flying_en;
assign sdp2pdp_ready     = pdp_datin_prdy_mux0 & on_flying_en;
assign pdp_datin_prdy_mux0 = pdp_datin_prdy_f;
//---------------------------------------------------------------
//---------------------------------------------------------------
//data select after switch
assign pdp_datin_pd_f_0 = pdp_datin_pd_f_mux0;
assign pdp_datin_pvld_f = pdp_datin_pvld_mux0;
//===============================================================
// 1 cycle pipeline for DW timing closure inside unit1d sub modudle
// DW has replaced by normal hls fp17 adder, this pipeline keep here
//---------------------------------------------------------------
//: my $dbw = NVDLA_PDP_THROUGHPUT*NVDLA_BPE;
//: my $Enum = NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_PDP_THROUGHPUT-1;
//: print " assign posc_last = (pdp_datin_pd_f_0[${dbw}+6:${dbw}+4]==${Enum}); \n";


//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $b = NVDLA_BPE;
//: foreach my $m (0..$k-1) {
//:     print qq(
//:         assign pdp_din_$m = {{3{pdp_datin_pd_f_0[${b}*${m}+${b}-1]}},pdp_datin_pd_f_0[${b}*${m}+${b}-1:${b}*${m}]};
//:     );
//: }

assign datain_ext = {
//: my $k = NVDLA_PDP_THROUGHPUT;
//: if($k>1) {
//:     foreach my $m (0..$k-2) {
//:     my $i = $k - $m -1;
//:         print "pdp_din_${i}, ";
//:     }
//: }
pdp_din_0};

assign pdp_datin_pd_f0 = {posc_last,pdp_datin_pd_f_0[NVDLA_PDP_THROUGHPUT*NVDLA_BPE+11:NVDLA_PDP_THROUGHPUT*NVDLA_BPE],datain_ext};
//: my $k = NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3) + 13;
//: &eperl::pipe(" -wid $k -is -do pdp_datin_pd0 -vo pdp_datin_pvld0 -ri pdp_datin_prdy -di pdp_datin_pd_f0 -vi pdp_datin_pvld_f -ro pdp_datin_prdy_f0 ");
assign pdp_datin_prdy_f = pdp_datin_prdy_f0;
assign pdp_datin_pvld = pdp_datin_pvld0;
assign pdp_datin_pd = pdp_datin_pd0;

assign pdp_datin_prdy = (pdp_datin_prdy_0 & pdp_datin_prdy_1) & pdpw_active_en; 
assign pdp_datin_prdy_0 = ~ cur_datin_disable;
//==============================================================
//new splitw
//---------------------------------------------------------------
//assign bsync           = pdp_datin_pd[95];
//assign splitw_end_sync = load_din ? pdp_datin_pd[98] : 1'b0;
//assign pdp_cube_sync   = pdp_datin_pd[99];
assign bsync           = pdp_datin_pd[NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3)+7];
assign splitw_end_sync = load_din ? pdp_datin_pd[NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3)+10] : 1'b0;
assign pdp_cube_sync   = pdp_datin_pd[NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3)+11];
assign pdp_cube_end    = pdp_cube_sync & bsync & load_din;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    splitw_cnt[7:0] <= {8{1'b0}};
  end else begin
   if(splitw_end & bsync & splitw_end_sync & load_din)
        splitw_cnt[7:0] <= 8'd0;
   else if(splitw_end_sync & bsync & load_din)
        splitw_cnt[7:0] <= splitw_cnt + 1;
  end
end
assign splitw_end   = (splitw_cnt==pooling_splitw_num_cfg[7:0]);
assign splitw_start = (splitw_cnt==8'd0);
//===============================================================
//config info
//
//---------------------------------------------------------------
assign non_splitw      = pooling_splitw_num_cfg[7:0]==8'd0 ;
assign first_splitw_en = ~non_splitw & splitw_start;
assign last_splitw_en  = ~non_splitw & splitw_end;

assign {mon_overlap,overlap[3:0]} = ({1'b0,reg2dp_kernel_width} < reg2dp_kernel_stride_width) ? (reg2dp_kernel_stride_width[3:0] - {1'b0,reg2dp_kernel_width[2:0]}) : ({1'b0,reg2dp_kernel_width[2:0]} - reg2dp_kernel_stride_width[3:0]);
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
  nv_assert_never #(0,0,"PDP-CORE: should not overflow")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, mon_overlap); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(
  non_splitw
  or reg2dp_cube_in_width
  or splitw_end
  or reg2dp_kernel_stride_width
  or reg2dp_kernel_width
  or pooling_lwidth_cfg
  or overlap
  or splitw_start
  or pooling_fwidth_cfg
  or pooling_mwidth_cfg
  ) begin
    if(non_splitw)
        pooling_pwidth = reg2dp_cube_in_width[12:0];
    else if(splitw_end) begin
        if(reg2dp_kernel_stride_width > {1'b0,reg2dp_kernel_width})
            pooling_pwidth = {3'd0,pooling_lwidth_cfg[9:0]} - {8'd0,overlap[3:0]};
        else
            pooling_pwidth = {3'd0,pooling_lwidth_cfg[9:0]} + {8'd0,overlap[3:0]};
    end else if(splitw_start)
        pooling_pwidth = {3'd0,pooling_fwidth_cfg[9:0]};
    else begin
        if(reg2dp_kernel_stride_width > {1'b0,reg2dp_kernel_width})
            pooling_pwidth = {3'd0,pooling_mwidth_cfg[9:0]} - {8'd0,overlap[3:0]};
        else
            pooling_pwidth = {3'd0,pooling_mwidth_cfg[9:0]} + {8'd0,overlap[3:0]};
    end
end
//==============================================================
//enable pdp datapath
//--------------------------------------------------------------
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pdpw_active_en <= 1'b0;
  end else begin
   if(pdp_op_start)
          pdpw_active_en   <= 1'b1; 
   else  if(pdp_cube_end)
          pdpw_active_en   <= 1'b0;
  end
end
//==============================================================
//stride count in padding bits
//
//--------------------------------------------------------------
//assign padding_left = ((~pdp_op_pending) | (first_splitw_en & (~splitw_end_sync))) ? padding_h_cfg[2:0] : 3'd0;
always @(
  non_splitw
  or padding_h_cfg
  or first_splitw_en
  or splitw_end_sync
  ) begin
    if(non_splitw)
        padding_left =  padding_h_cfg[2:0];
    else if(first_splitw_en & (~splitw_end_sync))
        padding_left =  padding_h_cfg[2:0];
    else
        padding_left =  3'd0;
end

//stride ==1 
assign padding_stride1_num =  padding_left[2:0];
//stride ==2
assign padding_stride2_num = {1'b0,padding_left[2:1]};
//stride ==3
assign padding_stride3_num= (padding_left[2:0]>=3'd6) ? 3'd2 :
                            (padding_left[2:0]>=3'd3) ? 3'd1 : 3'd0;
//stride==4 5 6 7
assign pooling_stride_h[4:0] = pooling_stride_h_cfg[3:0] + 3'd1;
assign padding_stride4_num = ({1'b0,padding_left[2:0]} > pooling_stride_h_cfg[3:0]) ? 3'd1 : 3'd0;
//number needed for padding in horizental direction
always @(
  pooling_stride_h_cfg
  or padding_stride1_num
  or padding_stride2_num
  or padding_stride3_num
  or padding_stride4_num
  ) begin
    case(pooling_stride_h_cfg)
        4'd0: padding_stride_num = padding_stride1_num;
        4'd1: padding_stride_num = padding_stride2_num;
        4'd2: padding_stride_num = padding_stride3_num;
        default: padding_stride_num = padding_stride4_num;
    endcase
end
 
assign   {mon_strip_xcnt_offset[5:0],strip_xcnt_offset[2:0]} = {5'b0, padding_left} - padding_stride_num * pooling_stride_h;
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
  nv_assert_never #(0,0,"PDPCore cal1d: shouldn't be overflow")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, (|mon_strip_xcnt_offset)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////////////////////
// line reg use num calculation, "+1"
//------------------------------------------------
//stride 1
assign line_regs_1[2:0] = pooling_size_h_cfg[2:0];  
//stride 2
assign line_regs_2[2:0] = {1'd0,pooling_size_h_cfg[2:1]};
//stride 3
assign line_regs_3[2:0] = (pooling_size_h_cfg[2:0]>3'd5)? 3'd2 : ((pooling_size_h_cfg[2:0]>3'd2)? 3'd1 : 3'd0); 
//stride 4 5 6 7
assign line_regs_4 = ({1'b0,pooling_size_h_cfg[2:0]}>pooling_stride_h_cfg)? 3'd1 : 3'd0;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    regs_num[2:0] <= {3{1'b0}};
  end else begin
  if(pdp_op_start) 
   case(pooling_stride_h_cfg)
       4'd0:    regs_num[2:0] <= line_regs_1;  
       4'd1:    regs_num[2:0] <= line_regs_2;
       4'd2:    regs_num[2:0] <= line_regs_3;
       default: regs_num[2:0] <= line_regs_4;
   endcase
  end
end
//////////////////////////////////////////////////
 
//==============================================================
//1D pooling stride/size counter
//
//-------------------------------------------------------------
//stride start
assign load_din            = pdp_datin_prdy & pdp_datin_pvld;
assign pooling_size_h[3:0] = pooling_size_h_cfg[2:0] + 3'd1;
assign strip_recieve_done  = load_din & pdp_din_lc;
//assign pdp_din_lc          = pdp_datin_pd[100];
assign pdp_din_lc          = pdp_datin_pd[NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3)+12];
assign stride_end          = strip_recieve_done & (strip_xcnt_stride==pooling_stride_h_cfg[3:0]);
assign init_cnt            = line_last_stripe_done | pdp_op_start;

always @(*) begin
   if(init_cnt) begin
        strip_xcnt_stride_f[3:0] = {1'b0,strip_xcnt_offset};
   end else if(stride_end)
        strip_xcnt_stride_f[3:0] = 4'd0;
   else if(strip_recieve_done)
        strip_xcnt_stride_f[3:0] = strip_xcnt_stride + 1;
   else
        strip_xcnt_stride_f[3:0] = strip_xcnt_stride;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    strip_xcnt_stride[3:0] <= {4{1'b0}};
  end else begin
  if ((init_cnt | stride_end | strip_recieve_done) == 1'b1) begin
    strip_xcnt_stride[3:0] <= strip_xcnt_stride_f[3:0];
  // VCS coverage off
  end else if ((init_cnt | stride_end | strip_recieve_done) == 1'b0) begin
  end else begin
    strip_xcnt_stride[3:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(init_cnt | stride_end | strip_recieve_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//pooling result ready
assign {mon_overlap_ff[1:0],overlap_ff[2:0]} = {1'b0,pooling_size_h_cfg} - pooling_stride_h_cfg;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    strip_xcnt_psize <= {3{1'b0}};
  end else begin
    if(init_cnt)
        strip_xcnt_psize[2:0] <= padding_left[2:0];
    else if({1'b0,pooling_size_h_cfg} >= pooling_stride_h_cfg)begin // pooling_size >= stride
        if(pooling_1d_rdy)
            strip_xcnt_psize <= overlap_ff[2:0];
        else if(strip_recieve_done)
            strip_xcnt_psize<= strip_xcnt_psize + 1;
    end
    else begin // pooling_size < stride
        if(strip_xcnt_stride_f <= {1'b0,pooling_size_h_cfg[2:0]})
            strip_xcnt_psize <= strip_xcnt_stride_f[2:0];
        else 
            strip_xcnt_psize <= 3'd0;
    end
  end
end
/////////////////////////////////////////////////////////
//input data bubble control logic generation
//-------------------------------------------------------
assign pooling_size[3:0] = pooling_size_h;
assign stride[4:0] = pooling_stride_h;
assign pad_l[2:0] = padding_left;

assign pad_r = reg2dp_pad_right_cfg[2:0];

//active_data_num_last_pooling = (pad_l + width) % stride;

//element/line num need flush at lint/surface end
always @(
  pad_r
  or stride_1x
  or stride_2x
  or stride_3x
  or stride_4x
  or stride_5x
  or stride_6x
  or stride_7x
  ) begin
    if({2'd0,pad_r} < stride_1x[4:0])
        flush_num_cal = 3'd0;
    else if({3'd0,pad_r} < stride_2x[5:0])
        flush_num_cal = 3'd1;
    else if({4'd0,pad_r} < stride_3x[6:0])
        flush_num_cal = 3'd2;
    else if({4'd0,pad_r} < stride_4x[6:0])
        flush_num_cal = 3'd3;
    else if({5'd0,pad_r} < stride_5x[7:0])
        flush_num_cal = 3'd4;
    else if({5'd0,pad_r} < stride_6x[7:0])
        flush_num_cal = 3'd5;
    else if({5'd0,pad_r} < stride_7x[7:0])
        flush_num_cal = 3'd6;
    else// if({5'd0,pad_r} = stride_7x[7:0])
        flush_num_cal = 3'd7;
end
//small input detect
assign non_split_small_active = (non_splitw & (~(|reg2dp_cube_in_width[12:3])) & ((reg2dp_cube_in_width[2:0] + reg2dp_pad_left[2:0]) < {1'b0,reg2dp_kernel_width[2:0]}));
assign split_small_active = (~non_splitw) & ((big_stride & ((pooling_lwidth_cfg[9:0] - {6'd0,overlap[3:0]}) < {8'b0,reg2dp_kernel_width[2:0]}))
                                         | ((~big_stride) & ((pooling_lwidth_cfg[9:0] + {6'd0,overlap[3:0]}) < {8'b0,reg2dp_kernel_width[2:0]})));
//non-split mode cube_width + pad_left + pad_right
assign non_split_w_pl[3:0] = reg2dp_cube_in_width[2:0] + reg2dp_pad_left[2:0];
assign non_split_w_pl_pr[4:0] = non_split_w_pl[3:0] + {1'b0,reg2dp_pad_right[2:0]};

//split mode cube_width +/- overlap + pad_right
assign big_stride = (reg2dp_kernel_stride_width[3:0] >= {1'b0,reg2dp_kernel_width});
assign split_w_olap[5:0] = big_stride ? (pooling_lwidth_cfg[4:0] - {1'd0,overlap[3:0]}) : (pooling_lwidth_cfg[4:0] + {1'd0,overlap[3:0]});
assign split_w_olap_pr[6:0] = split_w_olap[5:0] + {3'd0,reg2dp_pad_right[2:0]};
//pad_right remain afrer 1st kernel pooling
always @(
  non_split_small_active
  or non_split_w_pl_pr
  or reg2dp_kernel_width
  or split_small_active
  or split_w_olap_pr
  ) begin
    if(non_split_small_active)
        pad_r_remain[7:0] = {3'd0,non_split_w_pl_pr[4:0]} - {1'd0,reg2dp_kernel_width[2:0]} ;
    else if(split_small_active)
        pad_r_remain[7:0] = split_w_olap_pr[6:0] - {4'd0,reg2dp_kernel_width[2:0]} ;
    else
        pad_r_remain[7:0] = 8'd0 ;
end
//how many need bubble after 1st kernel pooling
always @(
  pad_r_remain
  or stride_6x
  or stride_5x
  or stride_4x
  or stride_3x
  or stride_2x
  or stride_1x
  ) begin
    if(pad_r_remain == stride_6x[7:0])
        samllW_flush_num = 3'd6;
    else if(pad_r_remain == stride_5x[7:0])
        samllW_flush_num = 3'd5;
    else if(pad_r_remain == {1'd0,stride_4x[6:0]})
        samllW_flush_num = 3'd4;
    else if(pad_r_remain == {1'd0,stride_3x[6:0]})
        samllW_flush_num = 3'd3;
    else if(pad_r_remain == {2'd0,stride_2x[5:0]})
        samllW_flush_num = 3'd2;
    else if(pad_r_remain == {3'd0,stride_1x[4:0]})
        samllW_flush_num = 3'd1;
    else// if(pad_r_remain == 8'd0)
        samllW_flush_num = 3'd0;
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
  // VCS coverage off 
  nv_assert_never #(0,0,"PDP cal1d small width in: pad_r overflow")      zzz_assert_never_8x (nvdla_core_clk, `ASSERT_RESET, (non_split_small_active|split_small_active) & (pad_r_remain == stride_7x)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//flush num calc
always @(
  flush_num_cal
  or non_split_small_active
  or split_small_active
  or samllW_flush_num
  ) begin
    if(flush_num_cal==3'd0)
         flush_num[2:0] = 3'd0;
    else if(non_split_small_active | split_small_active)
         flush_num[2:0] = samllW_flush_num;
    else
        flush_num[2:0] = flush_num_cal[2:0];
end

assign stride_1x[4:0] =   stride[4:0];
assign stride_2x[5:0] =  {stride[4:0],1'b0};
assign stride_3x[6:0] = ( stride_2x+{1'b0,stride[4:0]});
assign stride_4x[6:0] =  {stride[4:0],2'b0}; 
assign stride_5x[7:0] = ( stride_4x+{2'd0,stride[4:0]});
assign stride_6x[7:0] = ( stride_3x+stride_3x);
assign stride_7x[7:0] = ( stride_4x+stride_3x);

//the 1st element/line num need output data
//&Always;
//    if(non_splitw | first_splitw_en)
//        {mon_first_out_num[0],first_out_num[3:0]} = pooling_size - pad_l;
//    else 
//        {mon_first_out_num[0],first_out_num[3:0]} = {1'b0,pooling_size};
//&End;
assign kernel_padl[4:0] = pooling_size[3:0] - {1'b0,pad_l[2:0]};
assign partial_w_last[10:0] = pooling_lwidth_cfg[9:0] + 10'd1;
assign cube_width_in[3:0] = reg2dp_cube_in_width[2:0] + 3'd1;
assign ks_width[4:0] = reg2dp_kernel_stride_width[3:0] + 4'd1;
assign k_add_ks[10:0]= {7'd0,pooling_size[3:0]} + {6'd0,ks_width[4:0]};

always @(
  non_splitw
  or non_split_small_active
  or cube_width_in
  or kernel_padl
  or first_splitw_en
  or last_splitw_en
  or split_small_active
  or big_stride
  or partial_w_last
  or overlap
  or k_add_ks
  or pooling_size
  ) begin
    if(non_splitw) begin
        if(non_split_small_active)
            {mon_first_out_num[6:0],first_out_num[4:0]} = {8'd0,cube_width_in[3:0]};
        else
            {mon_first_out_num[6:0],first_out_num[4:0]} = {7'd0,kernel_padl[4:0]};
    end else begin
        if(first_splitw_en)
            {mon_first_out_num[6:0],first_out_num[4:0]} = {7'd0,kernel_padl[4:0]};
        else if(last_splitw_en & split_small_active) begin
            if(big_stride)
                {mon_first_out_num[6:0],first_out_num[4:0]} = {1'b0,partial_w_last[10:0]};
            else
                {mon_first_out_num[6:0],first_out_num[4:0]} = partial_w_last[10:0] + {7'd0,overlap[3:0]};
        end else begin
            if(big_stride)
                {mon_first_out_num[6:0],first_out_num[4:0]} = {1'b0,k_add_ks};//{7'd0,pooling_size[3:0]} + {6'd0,ks_width[4:0]};
            else
                {mon_first_out_num[6:0],first_out_num[4:0]} = {8'd0,pooling_size[3:0]};
        end
    end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    need_bubble <= 1'b0;
    bubble_num[2:0] <= {3{1'b0}};
  end else begin
    if(pdp_cube_end) begin
        if(|flush_num) begin
            need_bubble <= 1'b1;
            bubble_num[2:0]  <= flush_num;
        end else begin
            need_bubble <= 1'b0;
            bubble_num[2:0]  <= 3'd0;
        end
    end else if(non_splitw) begin
        if(pdp_op_start) begin
            if({2'd0,flush_num} >= first_out_num) begin
                need_bubble <= 1'b1;
                bubble_num[2:0]  <= flush_num - first_out_num[2:0] + 1'b1;
            end else begin
                need_bubble <= 1'b0;
                bubble_num[2:0]  <= 3'd0;
            end
        end
    end else begin//split mode
        if(splitw_end) begin
            if({2'd0,flush_num} >= first_out_num) begin
                need_bubble <= 1'b1;
                bubble_num[2:0]  <= flush_num - first_out_num[2:0] + 1'b1;
            end else begin
                need_bubble <= 1'b0;
                bubble_num[2:0]  <= 3'd0;
            end
        end
    end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cur_datin_disable <= 1'b0;
  end else begin
    if(pdp_cube_end & (|flush_num))
        cur_datin_disable <= 1'b1;
    else if(non_splitw) begin
        if(line_last_stripe_done & need_bubble)
            cur_datin_disable <= 1'b1;
        else if(bubble_en_end)
            cur_datin_disable <= 1'b0;
    end else begin
        if(last_splitw_en & line_last_stripe_done & need_bubble)
            cur_datin_disable <= 1'b1;
        else if(bubble_en_end)
            cur_datin_disable <= 1'b0;
    end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    channel_cnt <= {5{1'b0}};
  end else begin
    if(cur_datin_disable) begin
        if(last_c)
            channel_cnt <= 5'd0;
        else if(pdp_datin_prdy_1)
            channel_cnt <= channel_cnt + 1'b1;
    end else
        channel_cnt <= 5'd0;
  end
end
//: my $Enum = NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_PDP_THROUGHPUT-1;
//: print " assign last_c = (channel_cnt==5'd${Enum}) & pdp_datin_prdy_1;   \n";

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    bubble_cnt <= {3{1'b0}};
  end else begin
    if(cur_datin_disable) begin
        if(bubble_en_end)
            bubble_cnt <= 3'd0;
        else if(last_c)
            bubble_cnt <= bubble_cnt + 1'b1;
    end else
            bubble_cnt <= 3'd0;
  end
end
//assign bubble_en_end = (bubble_cnt == (bubble_num-1'b1)) & last_c;
assign bubble_num_dec[2:0] = bubble_num[2:0]-1'b1;
assign bubble_en_end = (bubble_cnt == bubble_num_dec) & last_c;

//////////////////////////////////////////////////////
//last line element output en during cur line element comming
//----------------------------------------------------
//subcube end flag for last_out_en control in the sub-cube end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    subcube_end_flag <= 1'b0;
  end else begin
    if(splitw_end_sync & bsync)
        subcube_end_flag <= 1'b1;
    else if(load_din)
        subcube_end_flag <= 1'b0;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_out_en <= 1'b0;
  end else begin
    if(last_out_done)
        last_out_en <= 1'b0;
    else if(pdp_cube_end)
        last_out_en <= 1'b0;
    else if((first_out_num != 5'd1) & (~subcube_end_flag)) begin
        if(need_bubble) begin
            if(bubble_en_end)
                last_out_en <= 1'b1;
        end else if(|flush_num) begin
            if(non_splitw & line_last_stripe_done)
                last_out_en <= 1'b1;
            else if(~non_splitw & last_splitw_en & line_last_stripe_done)
                last_out_en <= 1'b1;
        end
    end else
        last_out_en <= 1'b0;
  end
end

//assign {mon_first_out_num_dec2[1:0],first_out_num_dec2[2:0]} = first_out_num - 4'd2;
assign {mon_first_out_num_dec2[2:0],first_out_num_dec2[2:0]} = need_bubble ? (first_out_num - 5'd2) : ({2'b0,flush_num} - 5'd1);
//assign {mon_first_out_num_dec2[1:0],first_out_num_dec2[2:0]} = first_out_num - 4'd1;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_out_cnt <= {3{1'b0}};
  end else begin
    if(last_out_en) begin
        if(strip_recieve_done) begin
            if(last_out_done)
                last_out_cnt <= 3'd0;
            else
                last_out_cnt <= last_out_cnt + 1'b1;
        end
    end else
        last_out_cnt <= 3'd0;
  end
end
assign last_out_done = (last_out_cnt[2:0] == first_out_num_dec2[2:0]) & strip_recieve_done & last_out_en;

assign pooling_1d_rdy      = (strip_xcnt_psize== pooling_size_h_cfg[2:0]) &  strip_recieve_done;

/////////////////////////////////////////////////////////

//strip count in total width
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    strip_cnt_total[12:0] <= {13{1'b0}};
  end else begin
    if(init_cnt)
        strip_cnt_total[12:0] <= 13'd0;
    else if(strip_recieve_done)
        strip_cnt_total[12:0] <= strip_cnt_total + 1;
  end
end
  
assign strip_width_end  = (strip_cnt_total == pooling_pwidth);
assign line_last_stripe_done = (strip_width_end & strip_recieve_done);

//-----------------------
//flag the last one pooling in width direction
//-----------------------
assign {mon_rest_width,rest_width[12:0]} = pooling_pwidth - strip_cnt_total;
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
  nv_assert_never #(0,0,"PDPCore cal1d: shouldn't be overflow")      zzz_assert_never_9x (nvdla_core_clk, `ASSERT_RESET, (pdp_op_pending & mon_rest_width)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign rest_width_use[13:0] = (non_splitw | splitw_end) ? (rest_width + {10'd0,reg2dp_pad_right_cfg}) : {1'b0,rest_width};
assign last_pooling_flag = rest_width_use[13:0] <= {11'd0,pooling_size_h_cfg};
//======================================================================
//pooling 1D unit counter
//
//----------------------------------------------------------------------
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit1d_cnt_stride[2:0] <= {3{1'b0}};
  end else begin
    //if(pdp_op_start)
    if(init_cnt) begin
       unit1d_cnt_stride[2:0] <= padding_stride_num;
    end else if(stride_end) begin
       if(unit1d_cnt_stride == regs_num)
          unit1d_cnt_stride[2:0] <= 3'd0;
       else
          unit1d_cnt_stride[2:0] <= unit1d_cnt_stride +1;
    end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    unit1d_cnt_pooling[2:0] <= {3{1'b0}};
  end else begin
    //if(pdp_op_start)
    if(init_cnt)
         unit1d_cnt_pooling[2:0] <= 0;
    else if(pooling_1d_rdy | line_ldata_valid) begin
       if(unit1d_cnt_pooling == regs_num)
         unit1d_cnt_pooling[2:0] <= 0;
       else
         unit1d_cnt_pooling[2:0] <= unit1d_cnt_pooling + 1;
   end
  end
end

assign line_ldata_valid = line_last_stripe_done;

//: foreach my $i (0..7) {
//: my $j = $i -1;
//:     print "assign init_unit1d_set[$i] = init_cnt & (padding_stride_num>=${i}) & (pout_width_cur >= 3'd${i}); \n";
//:     if($i==0){
//:        print "assign unit1d_set_trig[0] = stride_end & (unit1d_cnt_stride == regs_num) & (~last_pooling_flag);\n";
//:     } else {
//:        print "assign unit1d_set_trig[${i}]=  stride_end & (unit1d_cnt_stride == 3'd${j}) & (unit1d_cnt_stride != regs_num) & (~last_pooling_flag);\n";
//:     }
//:     print qq(
//:        assign unit1d_set[${i}] = unit1d_set_trig[${i}] | init_unit1d_set[${i}]; 
//:        assign unit1d_clr[${i}] = (pooling_1d_rdy & (unit1d_cnt_pooling == 3'd${i})) | line_ldata_valid;
//:        always @(posedge nvdla_core_clk or negedge nvdla_core_rstn)
//:          if (!nvdla_core_rstn) begin
//:            unit1d_en[$i] <= 1'b0;
//:          end else begin
//:             if(pdp_cube_end)
//:                  unit1d_en[$i] <= 1'b0;
//:             else if(unit1d_set[${i}])
//:                  unit1d_en[$i] <= 1'b1;
//:             else if(unit1d_clr[${i}])
//:                  unit1d_en[$i] <= 1'b0;
//:          end
//:     );
//:  }


//: foreach my $i (0..7) {
//:     print qq(
//:         always @(posedge nvdla_core_clk or negedge nvdla_core_rstn)
//:           if (!nvdla_core_rstn) begin
//:             pooling_din_1st_$i <= 1'b0;
//:           end else begin
//:              if(unit1d_set[${i}])
//:                  pooling_din_1st_$i <= 1'b1;
//:              else if(strip_recieve_done)
//:                  pooling_din_1st_$i <= 1'b0;
//:          end
//:     );
//:  }

//////////////////////////////////////////////////////////////////////////////////////
//assign datin_buf    = pdp_datin_pd[96:0];
//assign datin_buf_1  = {pdp_datin_pd[96:88],pdp_datin_pd0[87:0]};
assign datin_buf    = pdp_datin_pd[NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3)+8:0];
assign pdp_datin_prdy_1 = &unit1d_prdy & pdp_info_in_prdy;
assign pdp_full_pvld = pdp_datin_pvld | cur_datin_disable;

assign unit1d_pvld[0] = pdp_full_pvld & pdp_info_in_prdy & (&{unit1d_prdy[7:1]});
assign unit1d_pvld[1] = pdp_full_pvld & pdp_info_in_prdy & (&{unit1d_prdy[7:2],unit1d_prdy[0]});
assign unit1d_pvld[2] = pdp_full_pvld & pdp_info_in_prdy & (&{unit1d_prdy[7:3],unit1d_prdy[1:0]});
assign unit1d_pvld[3] = pdp_full_pvld & pdp_info_in_prdy & (&{unit1d_prdy[7:4],unit1d_prdy[2:0]});
assign unit1d_pvld[4] = pdp_full_pvld & pdp_info_in_prdy & (&{unit1d_prdy[7:5],unit1d_prdy[3:0]});
assign unit1d_pvld[5] = pdp_full_pvld & pdp_info_in_prdy & (&{unit1d_prdy[7:6],unit1d_prdy[4:0]});
assign unit1d_pvld[6] = pdp_full_pvld & pdp_info_in_prdy & (&{unit1d_prdy[7  ],unit1d_prdy[5:0]});
assign unit1d_pvld[7] = pdp_full_pvld & pdp_info_in_prdy & (&{unit1d_prdy[6:0]});

//============================================================
//pdp info pipe
assign pdp_info_in_pvld = pdp_full_pvld & (&unit1d_prdy);
assign pdp_info_in_pd = {pdp_din_lc,last_c,last_out_en,cur_datin_disable,pooling_din_last[7:0]};
NV_NVDLA_PDP_cal1d_info_fifo u_NV_NVDLA_PDP_cal1d_info_fifo (
   .nvdla_core_clk          (nvdla_core_clk)                              //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)                             //|< i
  ,.pdp_info_in_prdy        (pdp_info_in_prdy)                            //|> w
  ,.pdp_info_in_pvld        (pdp_info_in_pvld)                            //|< w
  ,.pdp_info_in_pd          (pdp_info_in_pd[11:0])                        //|< w
  ,.pdp_info_out_prdy       (pdp_info_out_prdy)                           //|< w
  ,.pdp_info_out_pvld       (pdp_info_out_pvld)                           //|> w
  ,.pdp_info_out_pd         (pdp_info_out_pd[11:0])                       //|> w
  ,.pwrbus_ram_pd           (pwrbus_ram_pd[31:0])                         //|< i
  );
assign pdp_info_out_prdy = unit1d_out_prdy_use & (&unit1d_out_pvld);
assign {pdp_din_lc_sync,last_c_sync, last_out_en_sync,cur_datin_disable_sync,pooling_din_last_sync[7:0]} = pdp_info_out_pd[11:0];
//============================================================
// &Instance
//
//------------------------------------------------------------
//assertion trace NVDLA_HLS_ADD17_LATENCY latency change from 4

//: foreach my $i (0..7) {
//: print qq(
//:     assign pooling_din_last[$i] = unit1d_en[$i] & (((strip_xcnt_psize== pooling_size_h_cfg[2:0]) & (unit1d_cnt_pooling==3'd$i)) | strip_width_end) ;
//: 
//:     NV_NVDLA_PDP_CORE_unit1d unit1d_$i (
//:        .nvdla_core_clk          (nvdla_core_clk)                              //|< i
//:       ,.nvdla_core_rstn         (nvdla_core_rstn)                             //|< i
//:       ,.average_pooling_en      (average_pooling_en)                          //|< w
//:       ,.cur_datin_disable       (cur_datin_disable)                           //|< r
//:       ,.last_out_en             ((last_out_en_sync | cur_datin_disable_sync)) //|< ?
//:       ,.pdma2pdp_pd             (datin_buf[NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3)+6:0])                             //|< w
//:       ,.pdma2pdp_pvld           (unit1d_pvld[$i])                              //|< w
//:       ,.pdp_din_lc_f            (pdp_din_lc)                                  //|< w
//:       ,.pooling_din_1st         ((pooling_din_1st_$i ))                        //|< r
//:       ,.pooling_din_last        (pooling_din_last[$i])                         //|< w
//:       ,.pooling_out_prdy        (unit1d_out_prdy[$i])                          //|< w
//:       ,.pooling_type_cfg        (pooling_type_cfg[1:0])                       //|< i
//:       ,.pooling_unit_en         (unit1d_en[$i])                                //|< r
//:       //,.reg2dp_int16_en         (reg2dp_int16_en)                             //|< i
//:       //,.reg2dp_int8_en          (reg2dp_int8_en)                              //|< i
//:       ,.pdma2pdp_prdy           (unit1d_prdy[$i])                              //|> w
//:       ,.pooling_out             (unit1d_out_$i)                          //|> w
//:       ,.pooling_out_pvld        (unit1d_out_pvld[$i])                          //|> w
//:       );
//: );
//: }

//////////////////////////////////////////////////////////////////////////////////////
assign unit1d_out_prdy[0] = unit1d_out_prdy_use & pdp_info_out_pvld & (&{unit1d_out_pvld[7:1]});
assign unit1d_out_prdy[1] = unit1d_out_prdy_use & pdp_info_out_pvld & (&{unit1d_out_pvld[7:2],unit1d_out_pvld[0]});
assign unit1d_out_prdy[2] = unit1d_out_prdy_use & pdp_info_out_pvld & (&{unit1d_out_pvld[7:3],unit1d_out_pvld[1:0]});
assign unit1d_out_prdy[3] = unit1d_out_prdy_use & pdp_info_out_pvld & (&{unit1d_out_pvld[7:4],unit1d_out_pvld[2:0]});
assign unit1d_out_prdy[4] = unit1d_out_prdy_use & pdp_info_out_pvld & (&{unit1d_out_pvld[7:5],unit1d_out_pvld[3:0]});
assign unit1d_out_prdy[5] = unit1d_out_prdy_use & pdp_info_out_pvld & (&{unit1d_out_pvld[7:6],unit1d_out_pvld[4:0]});
assign unit1d_out_prdy[6] = unit1d_out_prdy_use & pdp_info_out_pvld & (&{unit1d_out_pvld[7  ],unit1d_out_pvld[5:0]});
assign unit1d_out_prdy[7] = unit1d_out_prdy_use & pdp_info_out_pvld & (&{unit1d_out_pvld[6:0]});

assign unit1d_out_pvld_use = &unit1d_out_pvld & pdp_info_out_pvld;
//=========================================================
//1d pooling output
//
//---------------------------------------------------------
//unit1d count
assign pooling1d_out_v_norm = ((|pooling_din_last_sync) & pdp_din_lc_sync & (~cur_datin_disable_sync) & unit1d_out_pvld_use & unit1d_out_prdy_use);
assign pooling1d_out_v_disable = (cur_datin_disable_sync & last_c_sync) & unit1d_out_pvld_use & unit1d_out_prdy_use;
assign pooling1d_out_v_lastout = (last_out_en_sync & pdp_din_lc_sync & unit1d_out_pvld_use & unit1d_out_prdy_use);
assign pooling1d_out_v = pooling1d_out_v_norm | pooling1d_out_v_disable | pooling1d_out_v_lastout;
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//end of line
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_line_dat_cnt[12:0] <= {13{1'b0}};
  end else begin
    if(wr_line_dat_done)
        wr_line_dat_cnt[12:0] <= 0;
    else if(pooling1d_out_v)
        wr_line_dat_cnt[12:0] <= wr_line_dat_cnt + 1;
  end
end
assign wr_line_dat_done  = (wr_line_dat_cnt==pout_width_cur) & pooling1d_out_v;

//end of surface
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_surface_dat_cnt <= {13{1'b0}};
  end else begin
   if(wr_surface_dat_done)
       wr_surface_dat_cnt <= 13'd0;
   else if(wr_line_dat_done)
       wr_surface_dat_cnt <= wr_surface_dat_cnt + 13'd1;
  end
end
assign last_line_in = (wr_surface_dat_cnt==reg2dp_cube_in_height[12:0]);
assign wr_surface_dat_done = wr_line_dat_done & last_line_in;

//end of splitw
//assign cube_out_channel[13:0]= pooling_channel_cfg[12:0] + 1'b1;
assign cube_out_channel[12:0]= pooling_channel_cfg[12:0];
////16bits: INT16 or FP16
//assign {mon_surface_num_0,surface_num_0[9:0]} = cube_out_channel[13:4] + {9'd0,(|cube_out_channel[3:0])};
////8bits: INT8
//assign surface_num_1[9:0] = {1'b0,cube_out_channel[13:5]} + (|cube_out_channel[4:0]);
//assign surface_num        = (reg2dp_input_data[1:0] == 2'h0 )? surface_num_1 : surface_num_0;

//: my $m = NVDLA_MEMORY_ATOMIC_SIZE;
//: my $k = int(log($m)/log(2));
//: print "assign surface_num = cube_out_channel[12:${k}]; \n";

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    surface_cnt_rd <= 0;
  end else begin
  if(wr_subcube_dat_done)
       surface_cnt_rd <=  0;
  else if(wr_surface_dat_done)
       surface_cnt_rd <= surface_cnt_rd + 1;
  end
end
//assign wr_subcube_dat_done = ((surface_num-1)==surface_cnt_rd) & wr_surface_dat_done;
assign wr_subcube_dat_done = (surface_num==surface_cnt_rd) & wr_surface_dat_done;

//total cube done
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_splitc_cnt[7:0] <= {8{1'b0}};
  end else begin
    if(wr_total_cube_done)
        wr_splitc_cnt[7:0] <= 8'd0;
    else if(wr_subcube_dat_done)
        wr_splitc_cnt[7:0] <= wr_splitc_cnt + 1;
  end
end
assign wr_total_cube_done = (wr_splitc_cnt==pooling_splitw_num_cfg[7:0]) & wr_subcube_dat_done;
//-------------------------------------------------
//split width selection 
assign splitw_enable = (pooling_splitw_num_cfg!=8'd0);
assign last_splitw   = (wr_splitc_cnt==pooling_splitw_num_cfg[7:0]) & splitw_enable;
assign first_splitw  = (wr_splitc_cnt==8'd0) & splitw_enable;

assign pout_width_cur[12:0]= (~splitw_enable) ? reg2dp_cube_out_width[12:0] : 
                            (last_splitw  ? {3'd0,pooling_out_lwidth_cfg[9:0]} : 
                             first_splitw ? {3'd0,pooling_out_fwidth_cfg[9:0]} : 
                                            {3'd0,pooling_out_mwidth_cfg[9:0]});

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pooling_out_cnt[2:0] <= {3{1'b0}};
  end else begin
   if(pdp_op_start)
       pooling_out_cnt[2:0] <= 3'd0;
   else if(pooling1d_out_v) begin
       if((pooling_out_cnt == regs_num) | wr_line_dat_done)
            pooling_out_cnt[2:0] <= 3'd0;
       else
            pooling_out_cnt[2:0] <= pooling_out_cnt + 3'd1 ;
   end
  end
end

always @(*) begin
    case(pooling_out_cnt)
       3'd0 : unit1d_actv_out_f = unit1d_out_0;
       3'd1 : unit1d_actv_out_f = unit1d_out_1;
       3'd2 : unit1d_actv_out_f = unit1d_out_2;
       3'd3 : unit1d_actv_out_f = unit1d_out_3;
       3'd4 : unit1d_actv_out_f = unit1d_out_4;
       3'd5 : unit1d_actv_out_f = unit1d_out_5;
       3'd6 : unit1d_actv_out_f = unit1d_out_6;
       3'd7 : unit1d_actv_out_f = unit1d_out_7;
    //VCS coverage off
       //default : unit1d_actv_out_f = 92'd0;
       default : unit1d_actv_out_f = 0;
    //VCS coverage on
    endcase
end

assign unit1d_out_prdy_use = unit1d_actv_out_prdy;
assign unit1d_actv_out_pvld = unit1d_out_pvld_use & ((|pooling_din_last_sync) | cur_datin_disable_sync | last_out_en_sync);
assign unit1d_actv_out = unit1d_actv_out_f;

//=================================
//padding value in h direction under average mode
//
//----------------------------------
//padding value 1x,2x,3x,4x,5x,6x,7x table
always @(*) begin
      case(pad_table_index)
          3'd1: pad_table_out = reg2dp_pad_value_1x_cfg[18:0]; //1x 
          3'd2: pad_table_out = reg2dp_pad_value_2x_cfg[18:0]; //2x
          3'd3: pad_table_out = reg2dp_pad_value_3x_cfg[18:0]; //3x
          3'd4: pad_table_out = reg2dp_pad_value_4x_cfg[18:0]; //4x
          3'd5: pad_table_out = reg2dp_pad_value_5x_cfg[18:0]; //5x
          3'd6: pad_table_out = reg2dp_pad_value_6x_cfg[18:0]; //6x
          3'd7: pad_table_out = reg2dp_pad_value_7x_cfg[18:0]; //7x
          default:pad_table_out = 19'd0;
       endcase
end

assign loading_en = unit1d_actv_out_pvld & unit1d_actv_out_prdy;

//: my $s = "\$signed";
//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $b = NVDLA_BPE;
//: foreach my $m (0..$k-1) {
//:     print "assign {mon_unit1d_actv_data_8bit_${m}_ff[1:0],unit1d_actv_data_8bit_${m}_ff} = $s({{1{unit1d_actv_out[(${b}+3)*${m}+(${b}+3)-1]}},unit1d_actv_out[(${b}+3)*${m}+(${b}+3)-1:(${b}+3)*${m}] }) + $s({pad_table_out[10], pad_table_out[10:0]}); \n";
//:     print "assign {mon_unit1d_actv_data_8bit_${m}[1:0],unit1d_actv_data_8bit_${m}} = padding_here_int8 ? {mon_unit1d_actv_data_8bit_${m}_ff[1:0],unit1d_actv_data_8bit_${m}_ff} : {2'd0,unit1d_actv_out[(${b}+3)*${m}+(${b}+3)-1:(${b}+3)*${m}] }; \n";
//: }
//: print "assign padding_here = (pooling_type_cfg== 2'h0 ) & (unit1d_actv_out[${k}*(${b}+3)+2:${k}*(${b}+3)] != pooling_size_h_cfg); \n";

assign padding_here_int8  = padding_here;

assign {mon_pad_table_index[0],pad_table_index[2:0]} = pooling_size_h_cfg - unit1d_actv_out[NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3)+2:NVDLA_PDP_THROUGHPUT*(NVDLA_BPE+3)];
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
  nv_assert_never #(0,0,"PDPCore cal1d: pooling size should not less than active num")      zzz_assert_never_11x (nvdla_core_clk, `ASSERT_RESET, (loading_en & mon_pad_table_index)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pooling1d_data_pad <= 0;
  end else begin
   if(loading_en) begin
          pooling1d_data_pad <= { 
//: my $k = NVDLA_PDP_THROUGHPUT;
//: my $b = NVDLA_BPE;
//: if($k > 1) {
//:     foreach my $m (0..$k-2) {
//:     my $i = $k - $m -1;
//:         print "{{3{unit1d_actv_data_8bit_${i}[${b}+2]}}, unit1d_actv_data_8bit_${i}[${b}+2:0]}, \n";
//:     }
//: }
//:         print "{{3{unit1d_actv_data_8bit_0[${b}+2]}}, unit1d_actv_data_8bit_0[${b}+2:0]}}; \n";
   end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pooling1d_data_pad_vld <= 1'b0;
  end else begin
        if(unit1d_actv_out_pvld)
           pooling1d_data_pad_vld <= 1'b1;
        else if(pooling1d_data_pad_rdy)
           pooling1d_data_pad_vld <= 1'b0;
  end
end

assign unit1d_actv_out_prdy = (~pooling1d_data_pad_vld | pooling1d_data_pad_rdy);
//=================================
//pad_value logic for fp16 average pooling
//----------------------------------
assign average_pooling_en = (pooling_type_cfg== 2'h0 );
/////////////////////////////////////////////////////////////////////////////////////
//=================================
//pooling output 
//
//----------------------------------
assign pooling1d_pd          = pooling1d_data_pad;
assign pooling1d_pvld        = pooling1d_data_pad_vld;
assign pooling1d_data_pad_rdy= pooling1d_prdy;

//==============
//function points
//==============
// max/min/average pooling


////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_feature__int16_max_pooling__1_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        pdp_op_start & reg2dp_int16_en & (pooling_type_cfg== 2'h1 );
//    endproperty
//    // Cover 1 : "pdp_op_start & reg2dp_int16_en & (pooling_type_cfg== 2'h1 )"
//    FUNCPOINT_PDP_feature__int16_max_pooling__1_COV : cover property (PDP_feature__int16_max_pooling__1_cov);
//
//  `endif
//`endif
////VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_feature__int8_max_pooling__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        pdp_op_start  & (pooling_type_cfg== 2'h1 );
    endproperty
    // Cover 2 : "pdp_op_start & (pooling_type_cfg== 2'h1 )"
    FUNCPOINT_PDP_feature__int8_max_pooling__2_COV : cover property (PDP_feature__int8_max_pooling__2_cov);

  `endif
`endif
//VCS coverage on


////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_feature__int16_min_pooling__4_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        pdp_op_start & reg2dp_int16_en & (pooling_type_cfg== 2'h2 );
//    endproperty
//    // Cover 4 : "pdp_op_start & reg2dp_int16_en & (pooling_type_cfg== 2'h2 )"
//    FUNCPOINT_PDP_feature__int16_min_pooling__4_COV : cover property (PDP_feature__int16_min_pooling__4_cov);
//
//  `endif
//`endif
////VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_feature__int8_min_pooling__5_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        pdp_op_start & (pooling_type_cfg== 2'h2 );
    endproperty
    // Cover 5 : "pdp_op_start & (pooling_type_cfg== 2'h2 )"
    FUNCPOINT_PDP_feature__int8_min_pooling__5_COV : cover property (PDP_feature__int8_min_pooling__5_cov);

  `endif
`endif
//VCS coverage on


////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_feature__int16_average_pooling__7_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        pdp_op_start & reg2dp_int16_en & (pooling_type_cfg== 2'h0 );
//    endproperty
//    // Cover 7 : "pdp_op_start & reg2dp_int16_en & (pooling_type_cfg== 2'h0 )"
//    FUNCPOINT_PDP_feature__int16_average_pooling__7_COV : cover property (PDP_feature__int16_average_pooling__7_cov);
//
//  `endif
//`endif
////VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_feature__int8_average_pooling__8_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        pdp_op_start & (pooling_type_cfg== 2'h0 );
    endproperty
    // Cover 8 : "pdp_op_start & (pooling_type_cfg== 2'h0 )"
    FUNCPOINT_PDP_feature__int8_average_pooling__8_COV : cover property (PDP_feature__int8_average_pooling__8_cov);

  `endif
`endif
//VCS coverage on


////pooling in inactive channel
////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_feature__int16_average_pooling_in_inactive_channel__11_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        pdp_op_start & average_pooling_en & reg2dp_int16_en & (~(&pooling_channel_cfg[4:0]));
//    endproperty
//    // Cover 11 : "pdp_op_start & average_pooling_en & reg2dp_int16_en & (~(&pooling_channel_cfg[4:0]))"
//    FUNCPOINT_PDP_feature__int16_average_pooling_in_inactive_channel__11_COV : cover property (PDP_feature__int16_average_pooling_in_inactive_channel__11_cov);
//
//  `endif
//`endif
////VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_feature__int8_average_pooling_in_inactive_channel__12_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        pdp_op_start & average_pooling_en & (~(&pooling_channel_cfg[4:0]));
    endproperty
    // Cover 12 : "pdp_op_start & average_pooling_en & (~(&pooling_channel_cfg[4:0]))"
    FUNCPOINT_PDP_feature__int8_average_pooling_in_inactive_channel__12_COV : cover property (PDP_feature__int8_average_pooling_in_inactive_channel__12_cov);

  `endif
`endif
//VCS coverage on

////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_feature__int16_max_pooling_in_inactive_channel__14_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        pdp_op_start & reg2dp_int16_en & (pooling_type_cfg== 2'h1 ) & (~(&pooling_channel_cfg[4:0]));
//    endproperty
//    // Cover 14 : "pdp_op_start & reg2dp_int16_en & (pooling_type_cfg== 2'h1 ) & (~(&pooling_channel_cfg[4:0]))"
//    FUNCPOINT_PDP_feature__int16_max_pooling_in_inactive_channel__14_COV : cover property (PDP_feature__int16_max_pooling_in_inactive_channel__14_cov);
//
//  `endif
//`endif
////VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_feature__int8_max_pooling_in_inactive_channel__15_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        pdp_op_start & (pooling_type_cfg== 2'h1 ) & (~(&pooling_channel_cfg[4:0]));
    endproperty
    // Cover 15 : "pdp_op_start & (pooling_type_cfg== 2'h1 ) & (~(&pooling_channel_cfg[4:0]))"
    FUNCPOINT_PDP_feature__int8_max_pooling_in_inactive_channel__15_COV : cover property (PDP_feature__int8_max_pooling_in_inactive_channel__15_cov);

  `endif
`endif
//VCS coverage on


////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_feature__int16_min_pooling_in_inactive_channel__17_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        pdp_op_start & reg2dp_int16_en & (pooling_type_cfg== 2'h2 ) & (~(&pooling_channel_cfg[4:0]));
//    endproperty
//    // Cover 17 : "pdp_op_start & reg2dp_int16_en & (pooling_type_cfg== 2'h2 ) & (~(&pooling_channel_cfg[4:0]))"
//    FUNCPOINT_PDP_feature__int16_min_pooling_in_inactive_channel__17_COV : cover property (PDP_feature__int16_min_pooling_in_inactive_channel__17_cov);
//
//  `endif
//`endif
////VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_feature__int8_min_pooling_in_inactive_channel__18_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        pdp_op_start & (pooling_type_cfg== 2'h2 ) & (~(&pooling_channel_cfg[4:0]));
    endproperty
    // Cover 18 : "pdp_op_start & (pooling_type_cfg== 2'h2 ) & (~(&pooling_channel_cfg[4:0]))"
    FUNCPOINT_PDP_feature__int8_min_pooling_in_inactive_channel__18_COV : cover property (PDP_feature__int8_min_pooling_in_inactive_channel__18_cov);

  `endif
`endif
//VCS coverage on

///////////////
//1*1*1 cube input
///////////////
////1*1*1 cube input for nonsplit mode
////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_min_cube_in__1_1_1_cube_in_int16_nonsplit_average_pooling__21_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        pdp_op_start & non_splitw & average_pooling_en & reg2dp_int16_en & (~(|reg2dp_cube_in_width)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg));
//    endproperty
//    // Cover 21 : "pdp_op_start & non_splitw & average_pooling_en & reg2dp_int16_en & (~(|reg2dp_cube_in_width)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg))"
//    FUNCPOINT_PDP_min_cube_in__1_1_1_cube_in_int16_nonsplit_average_pooling__21_COV : cover property (PDP_min_cube_in__1_1_1_cube_in_int16_nonsplit_average_pooling__21_cov);
//
//  `endif
//`endif
////VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_min_cube_in__1_1_1_cube_in_int8_nonsplit_average_pooling__22_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        pdp_op_start & non_splitw & average_pooling_en & (~(|reg2dp_cube_in_width)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg));
    endproperty
    // Cover 22 : "pdp_op_start & non_splitw & average_pooling_en & (~(|reg2dp_cube_in_width)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg))"
    FUNCPOINT_PDP_min_cube_in__1_1_1_cube_in_int8_nonsplit_average_pooling__22_COV : cover property (PDP_min_cube_in__1_1_1_cube_in_int8_nonsplit_average_pooling__22_cov);

  `endif
`endif
//VCS coverage on

////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_min_cube_in__1_1_1_cube_in_int16_nonsplit_max_pooling__24_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        pdp_op_start & non_splitw & reg2dp_int16_en & (pooling_type_cfg== 2'h1 ) & (~(|reg2dp_cube_in_width)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg));
//    endproperty
//    // Cover 24 : "pdp_op_start & non_splitw & reg2dp_int16_en & (pooling_type_cfg== 2'h1 ) & (~(|reg2dp_cube_in_width)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg))"
//    FUNCPOINT_PDP_min_cube_in__1_1_1_cube_in_int16_nonsplit_max_pooling__24_COV : cover property (PDP_min_cube_in__1_1_1_cube_in_int16_nonsplit_max_pooling__24_cov);
//
//  `endif
//`endif
////VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_min_cube_in__1_1_1_cube_in_int8_nonsplit_max_pooling__25_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        pdp_op_start & non_splitw & (pooling_type_cfg== 2'h1 ) & (~(|reg2dp_cube_in_width)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg));
    endproperty
    // Cover 25 : "pdp_op_start & non_splitw & (pooling_type_cfg== 2'h1 ) & (~(|reg2dp_cube_in_width)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg))"
    FUNCPOINT_PDP_min_cube_in__1_1_1_cube_in_int8_nonsplit_max_pooling__25_COV : cover property (PDP_min_cube_in__1_1_1_cube_in_int8_nonsplit_max_pooling__25_cov);

  `endif
`endif
//VCS coverage on


////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_min_cube_in__1_1_1_cube_in_int16_nonsplit_min_pooling__27_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        pdp_op_start & non_splitw & reg2dp_int16_en & (pooling_type_cfg== 2'h2 ) & (~(|reg2dp_cube_in_width)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg));
//    endproperty
//    // Cover 27 : "pdp_op_start & non_splitw & reg2dp_int16_en & (pooling_type_cfg== 2'h2 ) & (~(|reg2dp_cube_in_width)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg))"
//    FUNCPOINT_PDP_min_cube_in__1_1_1_cube_in_int16_nonsplit_min_pooling__27_COV : cover property (PDP_min_cube_in__1_1_1_cube_in_int16_nonsplit_min_pooling__27_cov);
//
//  `endif
//`endif
////VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_min_cube_in__1_1_1_cube_in_int8_nonsplit_min_pooling__28_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        pdp_op_start & non_splitw & (pooling_type_cfg== 2'h2 ) & (~(|reg2dp_cube_in_width)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg));
    endproperty
    // Cover 28 : "pdp_op_start & non_splitw & (pooling_type_cfg== 2'h2 ) & (~(|reg2dp_cube_in_width)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg))"
    FUNCPOINT_PDP_min_cube_in__1_1_1_cube_in_int8_nonsplit_min_pooling__28_COV : cover property (PDP_min_cube_in__1_1_1_cube_in_int8_nonsplit_min_pooling__28_cov);

  `endif
`endif
//VCS coverage on


//1*1*1 cube input for split 2 mode

////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_min_cube_in__1_1_1_cube_in_int16_split2_average_pooling__30_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        pdp_op_start & (pooling_splitw_num_cfg[7:0]==8'd1) & average_pooling_en & reg2dp_int16_en & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg));
//    endproperty
//    // Cover 30 : "pdp_op_start & (pooling_splitw_num_cfg[7:0]==8'd1) & average_pooling_en & reg2dp_int16_en & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg))"
//    FUNCPOINT_PDP_min_cube_in__1_1_1_cube_in_int16_split2_average_pooling__30_COV : cover property (PDP_min_cube_in__1_1_1_cube_in_int16_split2_average_pooling__30_cov);
//
//  `endif
//`endif
////VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_min_cube_in__1_1_1_cube_in_int8_split2_average_pooling__31_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        pdp_op_start & (pooling_splitw_num_cfg[7:0]==8'd1) & average_pooling_en & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg));
    endproperty
    // Cover 31 : "pdp_op_start & (pooling_splitw_num_cfg[7:0]==8'd1) & average_pooling_en & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg))"
    FUNCPOINT_PDP_min_cube_in__1_1_1_cube_in_int8_split2_average_pooling__31_COV : cover property (PDP_min_cube_in__1_1_1_cube_in_int8_split2_average_pooling__31_cov);

  `endif
`endif
//VCS coverage on


////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_min_cube_in__1_1_1_cube_in_int16_split2_max_pooling__33_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        pdp_op_start & (pooling_splitw_num_cfg[7:0]==8'd1) & reg2dp_int16_en & (pooling_type_cfg== 2'h1 ) & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg));
//    endproperty
//    // Cover 33 : "pdp_op_start & (pooling_splitw_num_cfg[7:0]==8'd1) & reg2dp_int16_en & (pooling_type_cfg== 2'h1 ) & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg))"
//    FUNCPOINT_PDP_min_cube_in__1_1_1_cube_in_int16_split2_max_pooling__33_COV : cover property (PDP_min_cube_in__1_1_1_cube_in_int16_split2_max_pooling__33_cov);
//
//  `endif
//`endif
////VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_min_cube_in__1_1_1_cube_in_int8_split2_max_pooling__34_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        pdp_op_start & (pooling_splitw_num_cfg[7:0]==8'd1) & (pooling_type_cfg== 2'h1 ) & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg));
    endproperty
    // Cover 34 : "pdp_op_start & (pooling_splitw_num_cfg[7:0]==8'd1) & (pooling_type_cfg== 2'h1 ) & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg))"
    FUNCPOINT_PDP_min_cube_in__1_1_1_cube_in_int8_split2_max_pooling__34_COV : cover property (PDP_min_cube_in__1_1_1_cube_in_int8_split2_max_pooling__34_cov);

  `endif
`endif
//VCS coverage on

////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_min_cube_in__1_1_1_cube_in_int16_split2_min_pooling__36_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        pdp_op_start & (pooling_splitw_num_cfg[7:0]==8'd1) & reg2dp_int16_en & (pooling_type_cfg== 2'h2 ) & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg));
//    endproperty
//    // Cover 36 : "pdp_op_start & (pooling_splitw_num_cfg[7:0]==8'd1) & reg2dp_int16_en & (pooling_type_cfg== 2'h2 ) & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg))"
//    FUNCPOINT_PDP_min_cube_in__1_1_1_cube_in_int16_split2_min_pooling__36_COV : cover property (PDP_min_cube_in__1_1_1_cube_in_int16_split2_min_pooling__36_cov);
//
//  `endif
//`endif
////VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_min_cube_in__1_1_1_cube_in_int8_split2_min_pooling__37_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        pdp_op_start & (pooling_splitw_num_cfg[7:0]==8'd1) & (pooling_type_cfg== 2'h2 ) & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg));
    endproperty
    // Cover 37 : "pdp_op_start & (pooling_splitw_num_cfg[7:0]==8'd1) & (pooling_type_cfg== 2'h2 ) & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg))"
    FUNCPOINT_PDP_min_cube_in__1_1_1_cube_in_int8_split2_min_pooling__37_COV : cover property (PDP_min_cube_in__1_1_1_cube_in_int8_split2_min_pooling__37_cov);

  `endif
`endif
//VCS coverage on


//1*1*1 cube input for split >2 mode

////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_min_cube_in__1_1_1_cube_in_int16_split3_average_pooling__39_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        pdp_op_start & (pooling_splitw_num_cfg[7:0]>=8'd2) & average_pooling_en & reg2dp_int16_en & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|pooling_mwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg));
//    endproperty
//    // Cover 39 : "pdp_op_start & (pooling_splitw_num_cfg[7:0]>=8'd2) & average_pooling_en & reg2dp_int16_en & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|pooling_mwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg))"
//    FUNCPOINT_PDP_min_cube_in__1_1_1_cube_in_int16_split3_average_pooling__39_COV : cover property (PDP_min_cube_in__1_1_1_cube_in_int16_split3_average_pooling__39_cov);
//
//  `endif
//`endif
////VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_min_cube_in__1_1_1_cube_in_int8_split3_average_pooling__40_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        pdp_op_start & (pooling_splitw_num_cfg[7:0]>=8'd2) & average_pooling_en & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|pooling_mwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg));
    endproperty
    // Cover 40 : "pdp_op_start & (pooling_splitw_num_cfg[7:0]>=8'd2) & average_pooling_en & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|pooling_mwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg))"
    FUNCPOINT_PDP_min_cube_in__1_1_1_cube_in_int8_split3_average_pooling__40_COV : cover property (PDP_min_cube_in__1_1_1_cube_in_int8_split3_average_pooling__40_cov);

  `endif
`endif
//VCS coverage on


////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_min_cube_in__1_1_1_cube_in_int16_split3_max_pooling__42_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        pdp_op_start & (pooling_splitw_num_cfg[7:0]>=8'd2) & reg2dp_int16_en & (pooling_type_cfg== 2'h1 ) & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|pooling_mwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg));
//    endproperty
//    // Cover 42 : "pdp_op_start & (pooling_splitw_num_cfg[7:0]>=8'd2) & reg2dp_int16_en & (pooling_type_cfg== 2'h1 ) & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|pooling_mwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg))"
//    FUNCPOINT_PDP_min_cube_in__1_1_1_cube_in_int16_split3_max_pooling__42_COV : cover property (PDP_min_cube_in__1_1_1_cube_in_int16_split3_max_pooling__42_cov);
//
//  `endif
//`endif
////VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_min_cube_in__1_1_1_cube_in_int8_split3_max_pooling__43_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        pdp_op_start & (pooling_splitw_num_cfg[7:0]>=8'd2) & (pooling_type_cfg== 2'h1 ) & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|pooling_mwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg));
    endproperty
    // Cover 43 : "pdp_op_start & (pooling_splitw_num_cfg[7:0]>=8'd2) & (pooling_type_cfg== 2'h1 ) & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|pooling_mwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg))"
    FUNCPOINT_PDP_min_cube_in__1_1_1_cube_in_int8_split3_max_pooling__43_COV : cover property (PDP_min_cube_in__1_1_1_cube_in_int8_split3_max_pooling__43_cov);

  `endif
`endif
//VCS coverage on


////VCS coverage off
//`ifndef DISABLE_FUNCPOINT
//  `ifdef ENABLE_FUNCPOINT
//
//    property PDP_min_cube_in__1_1_1_cube_in_int16_split3_min_pooling__45_cov;
//        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
//        @(posedge nvdla_core_clk)
//        pdp_op_start & (pooling_splitw_num_cfg[7:0]>=8'd2) & reg2dp_int16_en & (pooling_type_cfg== 2'h2 ) & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|pooling_mwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg));
//    endproperty
//    // Cover 45 : "pdp_op_start & (pooling_splitw_num_cfg[7:0]>=8'd2) & reg2dp_int16_en & (pooling_type_cfg== 2'h2 ) & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|pooling_mwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg))"
//    FUNCPOINT_PDP_min_cube_in__1_1_1_cube_in_int16_split3_min_pooling__45_COV : cover property (PDP_min_cube_in__1_1_1_cube_in_int16_split3_min_pooling__45_cov);
//
//  `endif
//`endif
////VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_min_cube_in__1_1_1_cube_in_int8_split3_min_pooling__46_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        pdp_op_start & (pooling_splitw_num_cfg[7:0]>=8'd2) & (pooling_type_cfg== 2'h2 ) & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|pooling_mwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg));
    endproperty
    // Cover 46 : "pdp_op_start & (pooling_splitw_num_cfg[7:0]>=8'd2) & (pooling_type_cfg== 2'h2 ) & (~(|pooling_fwidth_cfg)) & (~(|pooling_lwidth_cfg)) & (~(|pooling_mwidth_cfg)) & (~(|reg2dp_cube_in_height)) & (~(|pooling_channel_cfg))"
    FUNCPOINT_PDP_min_cube_in__1_1_1_cube_in_int8_split3_min_pooling__46_COV : cover property (PDP_min_cube_in__1_1_1_cube_in_int8_split3_min_pooling__46_cov);

  `endif
`endif
//VCS coverage on


//////////////////////

////==============
////OBS signals
////==============
//assign obs_bus_pdp_cal1d_unit_en = unit1d_en[7:0];
//assign obs_bus_pdp_cal1d_bubble  = cur_datin_disable;

endmodule // NV_NVDLA_PDP_CORE_cal1d





//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_PDP_cal1d_info_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus pdp_info_in -rd_pipebus pdp_info_out -rd_reg -rand_none -ram_bypass -d 8 -w 12 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_PDP_cal1d_info_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , pdp_info_in_prdy
    , pdp_info_in_pvld
    , pdp_info_in_pd
    , pdp_info_out_prdy
    , pdp_info_out_pvld
    , pdp_info_out_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        pdp_info_in_prdy;
input         pdp_info_in_pvld;
input  [11:0] pdp_info_in_pd;
input         pdp_info_out_prdy;
output        pdp_info_out_pvld;
output [11:0] pdp_info_out_pd;
input  [31:0] pwrbus_ram_pd;

// Master Clock Gating (SLCG)
//
// We gate the clock(s) when idle or stalled.
// This allows us to turn off numerous miscellaneous flops
// that don't get gated during synthesis for one reason or another.
//
// We gate write side and read side separately. 
// If the fifo is synchronous, we also gate the ram separately, but if
// -master_clk_gated_unified or -status_reg/-status_logic_reg is specified, 
// then we use one clk gate for write, ram, and read.
//
wire nvdla_core_clk_mgated_enable;   // assigned by code at end of this module
wire nvdla_core_clk_mgated;               // used only in synchronous fifos
NV_CLK_gate_power nvdla_core_clk_mgate( .clk(nvdla_core_clk), .reset_(nvdla_core_rstn), .clk_en(nvdla_core_clk_mgated_enable), .clk_gated(nvdla_core_clk_mgated) );

// 
// WRITE SIDE
//
wire wr_reserving;
reg        pdp_info_in_busy_int;		        	// copy for internal use
assign     pdp_info_in_prdy = !pdp_info_in_busy_int;
assign       wr_reserving = pdp_info_in_pvld && !pdp_info_in_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [3:0] pdp_info_in_count;			// write-side count

wire [3:0] wr_count_next_wr_popping = wr_reserving ? pdp_info_in_count : (pdp_info_in_count - 1'd1); // spyglass disable W164a W484
wire [3:0] wr_count_next_no_wr_popping = wr_reserving ? (pdp_info_in_count + 1'd1) : pdp_info_in_count; // spyglass disable W164a W484
wire [3:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_8 = ( wr_count_next_no_wr_popping == 4'd8 );
wire wr_count_next_is_8 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_8;
wire [3:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [3:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       pdp_info_in_busy_next = wr_count_next_is_8 || // busy next cycle?
                          (wr_limit_reg != 4'd0 &&      // check pdp_info_in_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        pdp_info_in_busy_int <=  1'b0;
        pdp_info_in_count <=  4'd0;
    end else begin
	pdp_info_in_busy_int <=  pdp_info_in_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    pdp_info_in_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            pdp_info_in_count <=  {4{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as pdp_info_in_pvld

//
// RAM
//

reg  [2:0] pdp_info_in_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        pdp_info_in_adr <=  3'd0;
    end else begin
        if ( wr_pushing ) begin
	    pdp_info_in_adr <=  pdp_info_in_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [2:0] pdp_info_out_adr;          // read address this cycle
wire ram_we = wr_pushing && (pdp_info_in_count > 4'd0 || !rd_popping);   // note: write occurs next cycle
wire [11:0] pdp_info_out_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_PDP_cal1d_info_fifo_flopram_rwsa_8x12 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( pdp_info_in_pd )
    , .we        ( ram_we )
    , .wa        ( pdp_info_in_adr )
    , .ra        ( (pdp_info_in_count == 0) ? 4'd8 : {1'b0,pdp_info_out_adr} )
    , .dout        ( pdp_info_out_pd_p )
    );


wire [2:0] rd_adr_next_popping = pdp_info_out_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        pdp_info_out_adr <=  3'd0;
    end else begin
        if ( rd_popping ) begin
	    pdp_info_out_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            pdp_info_out_adr <=  {3{`x_or_0}};
        end
        //synopsys translate_on

    end
end

//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

wire       pdp_info_out_pvld_p; 		// data out of fifo is valid

reg        pdp_info_out_pvld_int;	// internal copy of pdp_info_out_pvld
assign     pdp_info_out_pvld = pdp_info_out_pvld_int;
assign     rd_popping = pdp_info_out_pvld_p && !(pdp_info_out_pvld_int && !pdp_info_out_prdy);

reg  [3:0] pdp_info_out_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [3:0] rd_count_p_next_rd_popping = rd_pushing ? pdp_info_out_count_p : 
                                                                (pdp_info_out_count_p - 1'd1);
wire [3:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (pdp_info_out_count_p + 1'd1) : 
                                                                    pdp_info_out_count_p;
// spyglass enable_block W164a W484
wire [3:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     pdp_info_out_pvld_p = pdp_info_out_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        pdp_info_out_count_p <=  4'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    pdp_info_out_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            pdp_info_out_count_p <=  {4{`x_or_0}};
        end
        //synopsys translate_on

    end
end
reg [11:0]  pdp_info_out_pd;         // output data register
wire        rd_req_next = (pdp_info_out_pvld_p || (pdp_info_out_pvld_int && !pdp_info_out_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        pdp_info_out_pvld_int <=  1'b0;
    end else begin
        pdp_info_out_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        pdp_info_out_pd <=  pdp_info_out_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        pdp_info_out_pd <=  {12{`x_or_0}};
    end
    //synopsys translate_on

end

// Master Clock Gating (SLCG) Enables
//

// plusarg for disabling this stuff:

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg master_clk_gating_disabled;  initial master_clk_gating_disabled = $test$plusargs( "fifogen_disable_master_clk_gating" ) != 0;
`endif
`endif
// synopsys translate_on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (pdp_info_in_pvld && !pdp_info_in_busy_int) || (pdp_info_in_busy_int != pdp_info_in_busy_next)) || (rd_pushing || rd_popping || (pdp_info_out_pvld_int && pdp_info_out_prdy)) || (wr_pushing))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled
			       `endif
			       `endif
                               // synopsys translate_on
                               ;


// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_PDP_cal1d_info_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_PDP_cal1d_info_fifo_wr_limit : 4'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 4'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 4'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 4'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [3:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 4'd0;
`ifdef NV_ARCHPRO
event reinit;

initial begin
    $display("fifogen reinit initial block %m");
    -> reinit;
end
`endif

`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    wr_limit_override = 0;
    wr_limit_override_value = 0;  // to keep viva happy with dangles
    if ( $test$plusargs( "NV_NVDLA_PDP_cal1d_info_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_PDP_cal1d_info_fifo_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif

//
// Histogram of fifo depth (from write side's perspective)
//
// NOTE: it will reference `SIMTOP.perfmon_enabled, so that
//       has to at least be defined, though not initialized.
//	 tbgen testbenches have it already and various
//	 ways to turn it on and off.
//
`ifdef PERFMON_HISTOGRAM 
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( nvdla_core_clk ) 
    , .max      ( {28'd0, (wr_limit_reg == 4'd0) ? 4'd8 : wr_limit_reg} )
    , .curr	( {28'd0, pdp_info_in_count} )
    );
`endif
`endif
// synopsys translate_on
`endif

// spyglass disable_block W164a W164b W116 W484 W504

`ifdef SPYGLASS
`else

`ifdef FV_ASSERT_ON
`else
// synopsys translate_off
`endif

`ifdef ASSERT_ON

`ifdef SPYGLASS
wire disable_assert_plusarg = 1'b0;
`else

`ifdef FV_ASSERT_ON
wire disable_assert_plusarg = 1'b0;
`else
wire disable_assert_plusarg = $test$plusargs("DISABLE_NESS_FLOW_ASSERTIONS");
`endif

`endif
wire assert_enabled = 1'b1 && !disable_assert_plusarg;


`endif

`ifdef FV_ASSERT_ON
`else
// synopsys translate_on
`endif

`ifdef ASSERT_ON

//synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
always @(assert_enabled) begin
    if ( assert_enabled === 1'b0 ) begin
        $display("Asserts are disabled for %m");
    end
end
`endif
`endif
//synopsys translate_on

`endif

`endif

// spyglass enable_block W164a W164b W116 W484 W504


//The NV_BLKBOX_SRC0 module is only present when the FIFOGEN_MODULE_SEARCH
// define is set.  This is to aid fifogen team search for fifogen fifo
// instance and module names in a given design.
`ifdef FIFOGEN_MODULE_SEARCH
NV_BLKBOX_SRC0 dummy_breadcrumb_fifogen_blkbox (.Y());
`endif

// spyglass enable_block W401 -- clock is not input to module

// synopsys dc_script_begin
//   set_boundary_optimization find(design, "NV_NVDLA_PDP_cal1d_info_fifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_PDP_cal1d_info_fifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_PDP_cal1d_info_fifo_flopram_rwsa_8x12 (
      clk
    , pwrbus_ram_pd
    , di
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input [31 : 0] pwrbus_ram_pd;
input  [11:0] di;
input  we;
input  [2:0] wa;
input  [3:0] ra;
output [11:0] dout;

`ifndef FPGA
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_0 (.A(pwrbus_ram_pd[0]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_1 (.A(pwrbus_ram_pd[1]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_2 (.A(pwrbus_ram_pd[2]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_3 (.A(pwrbus_ram_pd[3]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_4 (.A(pwrbus_ram_pd[4]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_5 (.A(pwrbus_ram_pd[5]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_6 (.A(pwrbus_ram_pd[6]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_7 (.A(pwrbus_ram_pd[7]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_8 (.A(pwrbus_ram_pd[8]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_9 (.A(pwrbus_ram_pd[9]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_10 (.A(pwrbus_ram_pd[10]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_11 (.A(pwrbus_ram_pd[11]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_12 (.A(pwrbus_ram_pd[12]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_13 (.A(pwrbus_ram_pd[13]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_14 (.A(pwrbus_ram_pd[14]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_15 (.A(pwrbus_ram_pd[15]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_16 (.A(pwrbus_ram_pd[16]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_17 (.A(pwrbus_ram_pd[17]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_18 (.A(pwrbus_ram_pd[18]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_19 (.A(pwrbus_ram_pd[19]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_20 (.A(pwrbus_ram_pd[20]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_21 (.A(pwrbus_ram_pd[21]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_22 (.A(pwrbus_ram_pd[22]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_23 (.A(pwrbus_ram_pd[23]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_24 (.A(pwrbus_ram_pd[24]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_25 (.A(pwrbus_ram_pd[25]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_26 (.A(pwrbus_ram_pd[26]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_27 (.A(pwrbus_ram_pd[27]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_28 (.A(pwrbus_ram_pd[28]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_29 (.A(pwrbus_ram_pd[29]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_30 (.A(pwrbus_ram_pd[30]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_31 (.A(pwrbus_ram_pd[31]));
`endif


`ifdef EMU


wire [11:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [2:0] Wa0_vmw;
reg we0_vmw;
reg [11:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_PDP_cal1d_info_fifo_flopram_rwsa_8x12 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[2:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 8) ? di : dout_p;

`else

reg [11:0] ram_ff0;
reg [11:0] ram_ff1;
reg [11:0] ram_ff2;
reg [11:0] ram_ff3;
reg [11:0] ram_ff4;
reg [11:0] ram_ff5;
reg [11:0] ram_ff6;
reg [11:0] ram_ff7;

always @( posedge clk ) begin
    if ( we && wa == 3'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 3'd1 ) begin
	ram_ff1 <=  di;
    end
    if ( we && wa == 3'd2 ) begin
	ram_ff2 <=  di;
    end
    if ( we && wa == 3'd3 ) begin
	ram_ff3 <=  di;
    end
    if ( we && wa == 3'd4 ) begin
	ram_ff4 <=  di;
    end
    if ( we && wa == 3'd5 ) begin
	ram_ff5 <=  di;
    end
    if ( we && wa == 3'd6 ) begin
	ram_ff6 <=  di;
    end
    if ( we && wa == 3'd7 ) begin
	ram_ff7 <=  di;
    end
end

reg [11:0] dout;

always @(*) begin
    case( ra ) 
    4'd0:       dout = ram_ff0;
    4'd1:       dout = ram_ff1;
    4'd2:       dout = ram_ff2;
    4'd3:       dout = ram_ff3;
    4'd4:       dout = ram_ff4;
    4'd5:       dout = ram_ff5;
    4'd6:       dout = ram_ff6;
    4'd7:       dout = ram_ff7;
    4'd8:       dout = di;
    //VCS coverage off
    default:    dout = {12{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_PDP_cal1d_info_fifo_flopram_rwsa_8x12

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_PDP_cal1d_info_fifo_flopram_rwsa_8x12 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [2:0] Wa0;
input            we0;
input  [11:0] Di0;
input  [2:0] Ra0;
output [11:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 12'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [11:0] mem[7:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [11:0] Q0 = mem[0];
wire [11:0] Q1 = mem[1];
wire [11:0] Q2 = mem[2];
wire [11:0] Q3 = mem[3];
wire [11:0] Q4 = mem[4];
wire [11:0] Q5 = mem[5];
wire [11:0] Q6 = mem[6];
wire [11:0] Q7 = mem[7];
`endif

// asynchronous ram writes
always @(*) begin
  if ( we0 == 1'b1 ) begin
    #0.1;
    mem[Wa0] = Di0;
  end
end

assign Do0 = mem[Ra0];
`endif
`endif
// synopsys translate_on

// synopsys dc_script_begin
// synopsys dc_script_end

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_PDP_cal1d_info_fifo_flopram_rwsa_8x12] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_PDP_cal1d_info_fifo_flopram_rwsa_8x12] }
endmodule // vmw_NV_NVDLA_PDP_cal1d_info_fifo_flopram_rwsa_8x12

//vmw: Memory vmw_NV_NVDLA_PDP_cal1d_info_fifo_flopram_rwsa_8x12
//vmw: Address-size 3
//vmw: Data-size 12
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[11:0] data0[11:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[11:0] data1[11:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_PDP_cal1d_info_fifo_flopram_rwsa_8x12
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU


