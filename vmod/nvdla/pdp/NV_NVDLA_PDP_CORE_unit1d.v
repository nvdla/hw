// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_PDP_CORE_unit1d.v

#include "NV_NVDLA_PDP_define.h"

module NV_NVDLA_PDP_CORE_unit1d (
   nvdla_core_clk          //|< i
  ,nvdla_core_rstn         //|< i
  ,average_pooling_en      //|< i
  ,cur_datin_disable       //|< i
  ,last_out_en             //|< i
  ,pdma2pdp_pd             //|< i
  ,pdma2pdp_pvld           //|< i
  ,pdp_din_lc_f            //|< i
  ,pooling_din_1st         //|< i
  ,pooling_din_last        //|< i
  ,pooling_out_prdy        //|< i
  ,pooling_type_cfg        //|< i
  ,pooling_unit_en         //|< i
//  ,reg2dp_int16_en         //|< i
//  ,reg2dp_int8_en          //|< i
  ,pdma2pdp_prdy           //|> o
  ,pooling_out             //|> o
  ,pooling_out_pvld        //|> o
  );
//////////////////////////////////////////////////////////////////////////////////
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          average_pooling_en;
input          cur_datin_disable;
input          last_out_en;
input   [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)+8:0] pdma2pdp_pd;
input          pdma2pdp_pvld;
input          pdp_din_lc_f;
input          pooling_din_1st;
input          pooling_din_last;
input          pooling_out_prdy;
input    [1:0] pooling_type_cfg;
input          pooling_unit_en;
//input          reg2dp_int16_en;
//input          reg2dp_int8_en;
output         pdma2pdp_prdy;
output  [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)+3:0] pooling_out;
output         pooling_out_pvld;
//////////////////////////////////////////////////////////////////////////////////
wire           add_out_rdy;
wire           add_out_vld;
wire     [4:0] buf_sel;
wire     [4:0] buf_sel_sync;
wire     [4:0] buf_sel_sync_use;
wire     [4:0] buf_sel_sync_use_d4;
wire           cur_datin_disable_sync;
wire           cur_datin_disable_sync_use;
wire           cur_datin_disable_sync_use_d4;
wire           data_buf_lc;
wire           data_buf_lc_d4;
wire    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)-1:0] datain_ext;
wire    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)-1:0] datain_ext_sync;
//wire    [16:0] fp16_pool_sum_0;
//wire    [16:0] fp16_pool_sum_1;
//wire    [16:0] fp16_pool_sum_2;
//wire    [16:0] fp16_pool_sum_3;
//wire           fp16_pool_sum_prdy;
//wire           fp16_pool_sum_pvld;
//wire           fp_addin_rdy;
//wire           fp_addin_vld;
//wire    [87:0] fp_cur_pooling_dat;
//wire    [87:0] fp_datain_ext;
//wire           fp_mean_pool_cfg;
//wire    [67:0] fp_pool_sum;
//wire    [67:0] fp_pool_sum_result0;
//wire    [67:0] fp_pool_sum_result1;
//wire    [67:0] fp_pool_sum_result2;
//wire    [67:0] fp_pool_sum_result3;
//wire    [87:0] fp_pool_sum_use0;
//wire    [87:0] fp_pool_sum_use1;
//wire    [87:0] fp_pool_sum_use2;
//wire    [87:0] fp_pool_sum_use3;
wire    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)-1:0] int_pool_cur_dat;
wire    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)-1:0] int_pool_datin_ext;
wire    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)-1:0] int_pooling;
wire    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)-1:0] int_pooling_sync;
wire           load_din;
wire           pdma2pdp_prdy_f;
wire     [4:0] pdp_din_cpos;
wire           pdp_din_lc_f_sync;
wire     [3:0] pdp_din_wpos;
wire           pipe_in_rdy;
wire           pipe_out_rdy;
wire           pipe_out_vld;
wire           pool_fun_vld;
wire           pooling_din_1st_sync;
wire           pooling_din_last_sync;
wire           pooling_din_last_sync_use;
wire           pooling_din_last_sync_use_d4;
wire     [2:0] pooling_out_size;
wire     [2:0] pooling_out_size_sync;
wire     [2:0] pooling_out_size_sync_use;
wire     [2:0] pooling_out_size_sync_use_d4;
wire           pooling_out_vld;
wire    [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)-1:0] pooling_result;
reg     [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)-1:0] cur_pooling_dat;
//reg     [67:0] fp_pool_sum_result0_d3;
//reg     [67:0] fp_pool_sum_result0_d4;
//reg     [67:0] fp_pool_sum_result1_d3;
//reg     [67:0] fp_pool_sum_result1_d4;
//reg     [67:0] fp_pool_sum_result2_d3;
//reg     [67:0] fp_pool_sum_result2_d4;
//reg     [67:0] fp_pool_sum_result3_d3;
//reg     [67:0] fp_pool_sum_result3_d4;

//: my $bw = NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3);
//: my $k = int(NVDLA_MEMORY_ATOMIC_SIZE / NVDLA_PDP_THROUGHPUT);
//: foreach my $m (0..$k-1) {
//:     print "reg     [${bw}-1:0] latch_result${m}_d3; \n";
//:     print "reg     [${bw}+3:0] flush_out${m}; \n";
//:     print "wire    [${bw}-1:0] data_buf${m}; \n";
//:     print "wire    [${bw}-1:0] latch_result${m}; \n";
//:     print "wire    [${bw}-1:0] latch_result${m}_d4; \n";
//: }
reg      [4:0] pooling_cnt;
reg     [NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)+3:0] pooling_out;
reg      [2:0] pooling_size;
//////////////////////////////////////////////////////////////////////////////////
//=======================================================
//1D pooling unit
//-------------------------------------------------------
//assign fp_mean_pool_cfg = (reg2dp_fp16_en & average_pooling_en);

// interface
assign pdp_din_wpos  = pdma2pdp_pd[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)+3:NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)];
assign pdp_din_cpos  = pdma2pdp_pd[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)+8:NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)+4];
assign buf_sel       = pdp_din_cpos;

assign load_din      = pdma2pdp_pvld & pdma2pdp_prdy_f & (~cur_datin_disable) & pooling_unit_en;
assign pdma2pdp_prdy_f = pipe_in_rdy;
assign pdma2pdp_prdy = pdma2pdp_prdy_f;

//=========================================================
//POOLING FUNCTION DEFINITION
//
//---- -----------------------------------------------------
//: my $k = NVDLA_PDP_BWPE+3;
//: print qq(
//:     function [${k}-1:0] pooling_MIN; 
//:        input[${k}-1:0]  data0;
//:        input[${k}-1:0]  data1;
//: );
   reg        min_int_ff;
  begin
      min_int_ff    = ($signed(data1)>  $signed(data0))       ;
      pooling_MIN    = (min_int_ff   ) ? data0 : data1;
  end
 endfunction

//: my $k = NVDLA_PDP_BWPE+3;
//: print qq(
//:     function [${k}-1:0] pooling_MAX; 
//:        input[${k}-1:0]  data0;
//:        input[${k}-1:0]  data1;
//: );
      reg        max_int_ff;
      begin
      max_int_ff    = ($signed(data0)>  $signed(data1))       ;
      pooling_MAX   = (max_int_ff   ) ? data0 : data1;
  end
 endfunction

//: my $k = NVDLA_PDP_BWPE+3;
//: print qq(
//:     function [${k}-1:0] pooling_SUM; 
//:        input[${k}-1:0]  data0;
//:        input[${k}-1:0]  data1;
//: );
   begin
      //spyglass disable_block W484
      pooling_SUM =   $signed(data1) + $signed(data0); 
      //spyglass enable_block W484
  end
 endfunction

 //pooling result
//: my $k = NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3);
//: print qq(
//:     function [${k}-1:0] pooling_fun; 
//:        input[${k}-1:0]  data0;
//:        input[${k}-1:0]  data1;
//: );
  input[1:0]  pooling_type;
  reg    min_pooling;
  reg    max_pooling;
  reg    mean_pooling;
  begin
     min_pooling  = (pooling_type== 2'h2 );
     max_pooling  = (pooling_type== 2'h1 );
     mean_pooling = (pooling_type== 2'h0 );
//: my $K = NVDLA_PDP_THROUGHPUT;
//: my $P = (NVDLA_PDP_BWPE+3);
//: foreach my $m (0..$K-1) {
//:     print qq( 
//:         pooling_fun[${P}*${m}+${P}-1:${P}*${m}]  = mean_pooling?  pooling_SUM(data0[${P}*${m}+${P}-1:${P}*${m}],data1[${P}*${m}+${P}-1:${P}*${m}]) :
//:                                                    min_pooling ? (pooling_MIN(data0[${P}*${m}+${P}-1:${P}*${m}],data1[${P}*${m}+${P}-1:${P}*${m}])) :
//:                                                    max_pooling ? (pooling_MAX(data0[${P}*${m}+${P}-1:${P}*${m}],data1[${P}*${m}+${P}-1:${P}*${m}])) : 0;
//:     ); 
//: } 
  end
endfunction
 
//=========================================================
// pooling real size
//
//---------------------------------------------------------
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pooling_size[2:0] <= {3{1'b0}};
  end else begin
    if(load_din & pdp_din_lc_f) begin
        if(pooling_din_last)
            pooling_size[2:0] <= 3'd0;
        else
            pooling_size[2:0] <= pooling_size + 1;
    end
  end
end
assign pooling_out_size = pooling_size;
////====================================================================
//// pooling data 
////
////--------------------------------------------------------------------
assign datain_ext = pdma2pdp_pd[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)-1:0];
always @(*) begin
    case(buf_sel)
//: my $k = int(NVDLA_MEMORY_ATOMIC_SIZE / NVDLA_PDP_THROUGHPUT);
//: foreach my $m (0..$k-1) {
//:     print "5'd${m}:   cur_pooling_dat = data_buf${m}; \n";
//: }
       //VCS coverage off
       default: cur_pooling_dat = 0;
       //VCS coverage on
    endcase
end
//--------------------------------------------------------------------
//pooling function for fp16 average mode
//assign fp_datain_ext      = datain_ext[87:0] ;
//assign fp_cur_pooling_dat = cur_pooling_dat[87:0];
//
//assign fp_addin_vld = pdma2pdp_pvld & pipe_in_rdy & fp_mean_pool_cfg;
//cal1d_fp16_pool_sum u_cal1d_fp16_pool_sum (
//   .inp_a_0                 (fp_cur_pooling_dat[16:0])  //|< w
//  ,.inp_a_1                 (fp_cur_pooling_dat[38:22]) //|< w
//  ,.inp_a_2                 (fp_cur_pooling_dat[60:44]) //|< w
//  ,.inp_a_3                 (fp_cur_pooling_dat[82:66]) //|< w
//  ,.inp_b_0                 (fp_datain_ext[16:0])       //|< w
//  ,.inp_b_1                 (fp_datain_ext[38:22])      //|< w
//  ,.inp_b_2                 (fp_datain_ext[60:44])      //|< w
//  ,.inp_b_3                 (fp_datain_ext[82:66])      //|< w
//  ,.inp_in_pvld             (fp_addin_vld)              //|< w
//  ,.inp_out_prdy            (fp16_pool_sum_prdy)        //|< w
//  ,.nvdla_core_rstn         (nvdla_core_rstn)           //|< i
//  ,.nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)   //|< i
//  ,.inp_in_prdy             (fp_addin_rdy)              //|> w
//  ,.inp_out_pvld            (fp16_pool_sum_pvld)        //|> w
//  ,.out_z_0                 (fp16_pool_sum_0[16:0])     //|> w
//  ,.out_z_1                 (fp16_pool_sum_1[16:0])     //|> w
//  ,.out_z_2                 (fp16_pool_sum_2[16:0])     //|> w
//  ,.out_z_3                 (fp16_pool_sum_3[16:0])     //|> w
//  );
//assign fp_pool_sum = {fp16_pool_sum_3,fp16_pool_sum_2,fp16_pool_sum_1,fp16_pool_sum_0};
////////////////////

//below value 4 means NVDLA_HLS_ADD17_LATENCY
//: my $STAGE = 4;
//: my $WID = NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)*2 + 12;
//:     print qq(
//:         wire   [${WID}-1:0] pipe_out_pd;
//:         wire   [${WID}-1:0] pipe_dp_0;
//:         wire           pipe_vld_0;
//:         wire           pipe_rdy_$STAGE;
//:         assign pipe_vld_0 =  pdma2pdp_pvld;
//:         assign pipe_dp_0  = {pooling_din_last,pooling_out_size[2:0],cur_datin_disable,buf_sel[4:0],pdp_din_lc_f,pooling_din_1st,datain_ext,int_pooling};
//:     ); 
//: foreach my $m (0..$STAGE-1) {
//: my $n = $m+1;
//:     print qq(
//:         wire    pipe_rdy_$m;
//:         reg     pipe_vld_$n;
//:         reg [$WID-1:0]    pipe_dp_$n;
//:     ); 
//: }
//: foreach my $m (0..$STAGE-1) {
//: my $n = $m+1;
//:     print qq(
//:     assign pipe_rdy_$m = ~pipe_vld_$n || pipe_rdy_$n;
//:     always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) 
//:     begin
//:       if (!nvdla_core_rstn)
//:         pipe_vld_$n <= 1'b0;
//:       else if(pipe_vld_$m)
//:         pipe_vld_$n <= 1'b1;
//:       else if(pipe_rdy_$n)
//:         pipe_vld_$n <= 1'b0;
//:     end
//:     always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) 
//:     begin
//:       if (!nvdla_core_rstn)
//:         pipe_dp_$n <= ${WID}'d0;
//:       else if(pipe_vld_${m} & pipe_rdy_${m})
//:         pipe_dp_$n <= pipe_dp_$m;
//:     end
//:     ); 
//: }
//:     print qq(
//:         assign pipe_rdy_$STAGE = pipe_out_rdy;
//:         assign pipe_out_vld = pipe_vld_$STAGE;
//:         assign pipe_out_pd = pipe_dp_$STAGE;
//:     ); 
assign pipe_in_rdy = pipe_rdy_0;
//////::dla_pipe -stages NVDLA_HLS_ADD17_LATENCY -i pipe_in -o pipe_out -width 185;

assign pipe_out_rdy = add_out_rdy;
//assign fp16_pool_sum_prdy = fp_mean_pool_cfg & add_out_rdy & pipe_out_vld;

assign add_out_vld =  pipe_out_vld;

assign add_out_rdy = ~pooling_out_vld | pooling_out_prdy;
////////////////////
assign int_pooling_sync      = pipe_out_pd[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)-1:0];
assign datain_ext_sync       = pipe_out_pd[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)*2-1:NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)];
assign pooling_din_1st_sync  = pipe_out_pd[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)*2];
assign pdp_din_lc_f_sync     = pipe_out_pd[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)*2+1];
assign buf_sel_sync          = pipe_out_pd[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)*2+6:NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)*2+2];
assign cur_datin_disable_sync= pipe_out_pd[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)*2+7];
assign pooling_out_size_sync = pipe_out_pd[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)*2+10:NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)*2+8];
assign pooling_din_last_sync = pipe_out_pd[NVDLA_PDP_THROUGHPUT*(NVDLA_PDP_BWPE+3)*2+11];
////////////////////
////for NVDLA_HLS_ADD17_LATENCY==3
//always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//  if (!nvdla_core_rstn) begin
//    fp_pool_sum_result0_d3 <= {68{1'b0}};
//    fp_pool_sum_result1_d3 <= {68{1'b0}};
//    fp_pool_sum_result2_d3 <= {68{1'b0}};
//    fp_pool_sum_result3_d3 <= {68{1'b0}};
//  end else begin
//    if(add_out_vld & add_out_rdy) begin
//        if(pooling_din_1st_sync) begin
//            case(buf_sel_sync)
//                2'd0: fp_pool_sum_result0_d3 <= {datain_ext_sync[82:66],datain_ext_sync[60:44],datain_ext_sync[38:22],datain_ext_sync[16:0]};
//                2'd1: fp_pool_sum_result1_d3 <= {datain_ext_sync[82:66],datain_ext_sync[60:44],datain_ext_sync[38:22],datain_ext_sync[16:0]};
//                2'd2: fp_pool_sum_result2_d3 <= {datain_ext_sync[82:66],datain_ext_sync[60:44],datain_ext_sync[38:22],datain_ext_sync[16:0]};
//                2'd3: fp_pool_sum_result3_d3 <= {datain_ext_sync[82:66],datain_ext_sync[60:44],datain_ext_sync[38:22],datain_ext_sync[16:0]};
//       //VCS coverage off
//                default: begin
//                    fp_pool_sum_result0_d3 <= fp_pool_sum_result0_d3;
//                    fp_pool_sum_result1_d3 <= fp_pool_sum_result1_d3;
//                    fp_pool_sum_result2_d3 <= fp_pool_sum_result2_d3;
//                    fp_pool_sum_result3_d3 <= fp_pool_sum_result3_d3;
//                end
//       //VCS coverage on
//            endcase
//        end else begin
//            case(buf_sel_sync)
//                2'd0: fp_pool_sum_result0_d3 <= fp_pool_sum;
//                2'd1: fp_pool_sum_result1_d3 <= fp_pool_sum;
//                2'd2: fp_pool_sum_result2_d3 <= fp_pool_sum;
//                2'd3: fp_pool_sum_result3_d3 <= fp_pool_sum;
//       //VCS coverage off
//                default: begin
//                    fp_pool_sum_result0_d3 <= fp_pool_sum_result0_d3;
//                    fp_pool_sum_result1_d3 <= fp_pool_sum_result1_d3;
//                    fp_pool_sum_result2_d3 <= fp_pool_sum_result2_d3;
//                    fp_pool_sum_result3_d3 <= fp_pool_sum_result3_d3;
//                end
//       //VCS coverage on
//            endcase
//        end
//    end
//  end
//end
//
////for NVDLA_HLS_ADD17_LATENCY==4
//always @(
//  pooling_din_1st_sync
//  or buf_sel_sync
//  or datain_ext_sync
//  or fp_pool_sum_result0_d3
//  or fp_pool_sum_result1_d3
//  or fp_pool_sum_result2_d3
//  or fp_pool_sum_result3_d3
//  or fp_pool_sum
//  ) begin
//    if(pooling_din_1st_sync) begin
//        fp_pool_sum_result0_d4 = (buf_sel_sync==2'd0)? {datain_ext_sync[82:66],datain_ext_sync[60:44],datain_ext_sync[38:22],datain_ext_sync[16:0]} : fp_pool_sum_result0_d3;
//        fp_pool_sum_result1_d4 = (buf_sel_sync==2'd1)? {datain_ext_sync[82:66],datain_ext_sync[60:44],datain_ext_sync[38:22],datain_ext_sync[16:0]} : fp_pool_sum_result1_d3;
//        fp_pool_sum_result2_d4 = (buf_sel_sync==2'd2)? {datain_ext_sync[82:66],datain_ext_sync[60:44],datain_ext_sync[38:22],datain_ext_sync[16:0]} : fp_pool_sum_result2_d3;
//        fp_pool_sum_result3_d4 = (buf_sel_sync==2'd3)? {datain_ext_sync[82:66],datain_ext_sync[60:44],datain_ext_sync[38:22],datain_ext_sync[16:0]} : fp_pool_sum_result3_d3;
//    end else begin
//        fp_pool_sum_result0_d4 = (buf_sel_sync==2'd0)? fp_pool_sum : fp_pool_sum_result0_d3;
//        fp_pool_sum_result1_d4 = (buf_sel_sync==2'd1)? fp_pool_sum : fp_pool_sum_result1_d3;
//        fp_pool_sum_result2_d4 = (buf_sel_sync==2'd2)? fp_pool_sum : fp_pool_sum_result2_d3;
//        fp_pool_sum_result3_d4 = (buf_sel_sync==2'd3)? fp_pool_sum : fp_pool_sum_result3_d3;
//    end
//end
//
//assign fp_pool_sum_result0 = fp_pool_sum_result0_d4;
//assign fp_pool_sum_result1 = fp_pool_sum_result1_d4;
//assign fp_pool_sum_result2 = fp_pool_sum_result2_d4;
//assign fp_pool_sum_result3 = fp_pool_sum_result3_d4;
//
//assign fp_pool_sum_use0 = {5'd0,fp_pool_sum_result0[67:51],5'd0,fp_pool_sum_result0[50:34],5'd0,fp_pool_sum_result0[33:17],5'd0,fp_pool_sum_result0[16:0]};
//assign fp_pool_sum_use1 = {5'd0,fp_pool_sum_result1[67:51],5'd0,fp_pool_sum_result1[50:34],5'd0,fp_pool_sum_result1[33:17],5'd0,fp_pool_sum_result1[16:0]};
//assign fp_pool_sum_use2 = {5'd0,fp_pool_sum_result2[67:51],5'd0,fp_pool_sum_result2[50:34],5'd0,fp_pool_sum_result2[33:17],5'd0,fp_pool_sum_result2[16:0]};
//assign fp_pool_sum_use3 = {5'd0,fp_pool_sum_result3[67:51],5'd0,fp_pool_sum_result3[50:34],5'd0,fp_pool_sum_result3[33:17],5'd0,fp_pool_sum_result3[16:0]};
//////////////////////////
assign pool_fun_vld = load_din;
assign int_pool_datin_ext = pool_fun_vld ? datain_ext : 0;
assign int_pool_cur_dat   = pool_fun_vld ? cur_pooling_dat : 0;
assign int_pooling = pooling_fun(int_pool_cur_dat, int_pool_datin_ext,pooling_type_cfg[1:0]);

assign pooling_result = (pooling_din_1st_sync ? datain_ext_sync : int_pooling_sync);
//--------------------------------------------------------------------
//for NVDLA_HLS_ADD17_LATENCY==3
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
//: my $k = int(NVDLA_MEMORY_ATOMIC_SIZE / NVDLA_PDP_THROUGHPUT);
//: foreach my $m (0..$k-1) {
//:     print "latch_result${m}_d3 <= 0; \n";
//: }
  end else begin
    if(add_out_vld & add_out_rdy) begin
        case(buf_sel_sync)
//: my $k = int(NVDLA_MEMORY_ATOMIC_SIZE / NVDLA_PDP_THROUGHPUT);
//: foreach my $m (0..$k-1) {
//:     print "5'd${m}: latch_result${m}_d3 <= pooling_result; \n";
//: }
       //VCS coverage off
            default: begin
//: my $k = int(NVDLA_MEMORY_ATOMIC_SIZE / NVDLA_PDP_THROUGHPUT);
//: foreach my $m (0..$k-1) {
//:     print "latch_result${m}_d3 <= latch_result${m}_d3; \n";
//: }
            end
       //VCS coverage on
        endcase
    end
  end
end

//for NVDLA_HLS_ADD17_LATENCY==4
assign pooling_out_size_sync_use_d4 = pooling_out_size_sync;
assign pooling_din_last_sync_use_d4 = pooling_din_last_sync;
assign buf_sel_sync_use_d4 = buf_sel_sync;
assign cur_datin_disable_sync_use_d4 = cur_datin_disable_sync;
assign data_buf_lc_d4 = pdp_din_lc_f_sync;
//: my $k = int(NVDLA_MEMORY_ATOMIC_SIZE / NVDLA_PDP_THROUGHPUT);
//: foreach my $m (0..$k-1) {
//:     print "assign latch_result${m}_d4 = (buf_sel_sync==5'd$m)? pooling_result : latch_result${m}_d3; \n";
//:     print "assign latch_result$m = latch_result${m}_d4; \n";
//:     print "assign data_buf$m = latch_result$m ; \n";
//: }

//==========
//info select
assign pooling_out_size_sync_use  = /*(NVDLA_HLS_ADD17_LATENCY == 4) ?*/ pooling_out_size_sync_use_d4 /* : pooling_out_size_sync_use_d3 */;
assign pooling_din_last_sync_use  = /*(NVDLA_HLS_ADD17_LATENCY == 4) ?*/ pooling_din_last_sync_use_d4 /* : pooling_din_last_sync_use_d3 */;
assign buf_sel_sync_use           = /*(NVDLA_HLS_ADD17_LATENCY == 4) ?*/ buf_sel_sync_use_d4          /* : buf_sel_sync_use_d3          */;
assign cur_datin_disable_sync_use = /*(NVDLA_HLS_ADD17_LATENCY == 4) ?*/ cur_datin_disable_sync_use_d4/* : cur_datin_disable_sync_use_d3*/;
assign data_buf_lc                = /*(NVDLA_HLS_ADD17_LATENCY == 4) ?*/ data_buf_lc_d4               /* : data_buf_lc_d3               */;

//============================================================
//pooling send out
//
//------------------------------------------------------------
//for NVDLA_HLS_ADD17_LATENCY==3
//&Always posedge;
//  if(add_out_vld)
//     pooling_out_vld_d3 <0=1'b1;
//  else if(pooling_out_prdy)
//     pooling_out_vld_d3 <0= 1'b0;
//&End;
assign pooling_out_vld = /*(NVDLA_HLS_ADD17_LATENCY == 4) ? */add_out_vld/* : pooling_out_vld_d3*/;

assign pooling_out_pvld = pooling_out_vld;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pooling_cnt <= 0;
  end else begin
    if(pooling_out_vld & pooling_out_prdy & ((pooling_din_last_sync_use & (~cur_datin_disable_sync_use)) | last_out_en))begin
//: my $k = int(NVDLA_MEMORY_ATOMIC_SIZE / NVDLA_PDP_THROUGHPUT);
//: print qq(
//:             if(pooling_cnt==(5'd${k} -1))
//: );
             pooling_cnt <= 0;
         else
             pooling_cnt <= pooling_cnt +1'd1;
     end
   end
 end
   
always @(*) begin
    if(last_out_en) begin
        case(pooling_cnt) 
//: my $k = int(NVDLA_MEMORY_ATOMIC_SIZE / NVDLA_PDP_THROUGHPUT);
//: foreach my $m (0..$k-1) {
//:     print "5'd${m}:    pooling_out = flush_out$m; \n";
//: }
         default: pooling_out = 0;
        endcase
    end else begin
        case(pooling_cnt) 
//: my $k = int(NVDLA_MEMORY_ATOMIC_SIZE / NVDLA_PDP_THROUGHPUT);
//: foreach my $m (0..$k-1) {
//:     print "5'd${m}:    pooling_out = {data_buf_lc,pooling_out_size_sync_use,data_buf${m}}; \n";
//: }
         default: pooling_out = 0;
        endcase
    end
end
//////////////////////////////////////////////
//output latch in line end for flush
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
//: my $k = int(NVDLA_MEMORY_ATOMIC_SIZE / NVDLA_PDP_THROUGHPUT);
//: foreach my $m (0..$k-1) {
//:     print "flush_out$m <= 0; \n";
//: }
  end else begin
    if(pooling_din_last_sync_use & (~cur_datin_disable_sync_use)) begin
        case(buf_sel_sync_use)
//: my $k = int(NVDLA_MEMORY_ATOMIC_SIZE / NVDLA_PDP_THROUGHPUT);
//: foreach my $m (0..$k-1) {
//:     print "5'd${m}: flush_out$m <= {data_buf_lc,pooling_out_size_sync_use,data_buf${m}}; \n";
//: }
       //VCS coverage off
        default: begin
//: my $k = int(NVDLA_MEMORY_ATOMIC_SIZE / NVDLA_PDP_THROUGHPUT);
//: foreach my $m (0..$k-1) {
//:     print "flush_out$m <= flush_out${m}; \n";
//: }
        end
       //VCS coverage on
        endcase
    end
  end
end

//////////////////////////////////////////////
endmodule // NV_NVDLA_PDP_CORE_unit1d



