// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_PDP_CORE_unit1d.v

module NV_NVDLA_PDP_CORE_unit1d (
   nvdla_core_clk          //|< i
  ,nvdla_core_rstn         //|< i
  ,average_pooling_en      //|< i
  ,cur_datin_disable       //|< i
  ,last_out_en             //|< i
  ,nvdla_op_gated_clk_fp16 //|< i
  ,pdma2pdp_pd             //|< i
  ,pdma2pdp_pvld           //|< i
  ,pdp_din_lc_f            //|< i
  ,pooling_din_1st         //|< i
  ,pooling_din_last        //|< i
  ,pooling_out_prdy        //|< i
  ,pooling_type_cfg        //|< i
  ,pooling_unit_en         //|< i
  ,reg2dp_fp16_en          //|< i
  ,reg2dp_int16_en         //|< i
  ,reg2dp_int8_en          //|< i
  ,pdma2pdp_prdy           //|> o
  ,pooling_out             //|> o
  ,pooling_out_pvld        //|> o
  );

input          nvdla_core_clk;
input          nvdla_core_rstn;
input          average_pooling_en;
input          cur_datin_disable;
input          last_out_en;
input          nvdla_op_gated_clk_fp16;
input   [93:0] pdma2pdp_pd;
input          pdma2pdp_pvld;
input          pdp_din_lc_f;
input          pooling_din_1st;
input          pooling_din_last;
input          pooling_out_prdy;
input    [1:0] pooling_type_cfg;
input          pooling_unit_en;
input          reg2dp_fp16_en;
input          reg2dp_int16_en;
input          reg2dp_int8_en;
output         pdma2pdp_prdy;
output  [91:0] pooling_out;
output         pooling_out_pvld;
wire           add_out_rdy;
wire           add_out_vld;
wire     [1:0] buf_sel;
wire     [1:0] buf_sel_sync;
wire     [1:0] buf_sel_sync_use;
wire     [1:0] buf_sel_sync_use_d4;
wire           cur_datin_disable_sync;
wire           cur_datin_disable_sync_use;
wire           cur_datin_disable_sync_use_d4;
wire    [87:0] data_buf0;
wire    [87:0] data_buf1;
wire    [87:0] data_buf2;
wire    [87:0] data_buf3;
wire           data_buf_lc;
wire           data_buf_lc_d4;
wire    [87:0] datain_ext;
wire    [87:0] datain_ext_sync;
wire    [16:0] fp16_pool_sum_0;
wire    [16:0] fp16_pool_sum_1;
wire    [16:0] fp16_pool_sum_2;
wire    [16:0] fp16_pool_sum_3;
wire           fp16_pool_sum_prdy;
wire           fp16_pool_sum_pvld;
wire           fp_addin_rdy;
wire           fp_addin_vld;
wire    [87:0] fp_cur_pooling_dat;
wire    [87:0] fp_datain_ext;
wire           fp_mean_pool_cfg;
wire    [67:0] fp_pool_sum;
wire    [67:0] fp_pool_sum_result0;
wire    [67:0] fp_pool_sum_result1;
wire    [67:0] fp_pool_sum_result2;
wire    [67:0] fp_pool_sum_result3;
wire    [87:0] fp_pool_sum_use0;
wire    [87:0] fp_pool_sum_use1;
wire    [87:0] fp_pool_sum_use2;
wire    [87:0] fp_pool_sum_use3;
wire    [87:0] int_pool_cur_dat;
wire    [87:0] int_pool_datin_ext;
wire    [87:0] int_pooling;
wire    [87:0] int_pooling_sync;
wire    [87:0] latch_result0;
wire    [87:0] latch_result0_d4;
wire    [87:0] latch_result1;
wire    [87:0] latch_result1_d4;
wire    [87:0] latch_result2;
wire    [87:0] latch_result2_d4;
wire    [87:0] latch_result3;
wire    [87:0] latch_result3_d4;
wire           load_din;
wire           pdma2pdp_prdy_f;
wire     [1:0] pdp_din_cpos;
wire           pdp_din_lc_f_sync;
wire     [3:0] pdp_din_wpos;
wire   [184:0] pipe_in_pd;
wire   [184:0] pipe_in_pd_d0;
wire   [184:0] pipe_in_pd_d1;
wire   [184:0] pipe_in_pd_d2;
wire   [184:0] pipe_in_pd_d3;
wire   [184:0] pipe_in_pd_d4;
wire           pipe_in_rdy;
wire           pipe_in_rdy_d0;
wire           pipe_in_rdy_d1;
wire           pipe_in_rdy_d2;
wire           pipe_in_rdy_d3;
wire           pipe_in_rdy_d4;
wire           pipe_in_vld;
wire           pipe_in_vld_d0;
wire           pipe_in_vld_d1;
wire           pipe_in_vld_d2;
wire           pipe_in_vld_d3;
wire           pipe_in_vld_d4;
wire   [184:0] pipe_out_pd;
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
wire    [87:0] pooling_result;
reg     [87:0] cur_pooling_dat;
reg     [91:0] flush_out0;
reg     [91:0] flush_out1;
reg     [91:0] flush_out2;
reg     [91:0] flush_out3;
reg     [67:0] fp_pool_sum_result0_d3;
reg     [67:0] fp_pool_sum_result0_d4;
reg     [67:0] fp_pool_sum_result1_d3;
reg     [67:0] fp_pool_sum_result1_d4;
reg     [67:0] fp_pool_sum_result2_d3;
reg     [67:0] fp_pool_sum_result2_d4;
reg     [67:0] fp_pool_sum_result3_d3;
reg     [67:0] fp_pool_sum_result3_d4;
reg     [87:0] latch_result0_d3;
reg     [87:0] latch_result1_d3;
reg     [87:0] latch_result2_d3;
reg     [87:0] latch_result3_d3;
reg      [1:0] pooling_cnt;
reg     [91:0] pooling_out;
reg      [2:0] pooling_size;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
//=======================================================
//1D pooling unit
//
//-------------------------------------------------------
assign fp_mean_pool_cfg = (reg2dp_fp16_en & average_pooling_en);

// interface
assign pdp_din_wpos  = pdma2pdp_pd[91:88];
assign pdp_din_cpos  = pdma2pdp_pd[93:92];
assign buf_sel       = pdp_din_cpos[1:0];

assign load_din      = pdma2pdp_pvld & pdma2pdp_prdy_f & (~cur_datin_disable) & pooling_unit_en;
//assign pdma2pdp_prdy_f = pipe_in_rdy & fp_addin_rdy;
assign pdma2pdp_prdy_f = fp_mean_pool_cfg ? (pipe_in_rdy & fp_addin_rdy) : pipe_in_rdy;
assign pdma2pdp_prdy = pdma2pdp_prdy_f;

//=========================================================
//POOLING FUNCTION DEFINITION
//
//---- -----------------------------------------------------
 //=========================================================
 //POOLING FUNCTION DEFINITION
 //
 //---- -----------------------------------------------------

function[21:0] pooling_MIN; 
   input       reg2dp_int8_en;
   input       reg2dp_int16_en;
   input       reg2dp_fp16_en;
   input[21:0]  data0;
   input[21:0]  data1;
   reg[10:0]  data0_lsb;
   reg[10:0]  data0_msb;
   reg[10:0]  data1_lsb;
   reg[10:0]  data1_msb;
   reg[21:0]  min_16int;
   reg[21:0]  min_fp16;
   reg[10:0]  min_8int_lsb;
   reg[10:0]  min_8int_msb;
   reg [21:0] int16_data0;
   reg [21:0] int16_data1;
   reg [21:0] fp16_data0;
   reg [21:0] fp16_data1;
   reg        min_8int_lsb_ff;
   reg        min_8int_msb_ff;
   reg        min_16int_ff;
  begin
      {data0_msb,data0_lsb} = reg2dp_int8_en ? data0 : 0;
      {data1_msb,data1_lsb} = reg2dp_int8_en ? data1 : 0;
      int16_data0 = reg2dp_int16_en ? data0 : 0;
      int16_data1 = reg2dp_int16_en ? data1 : 0;
      fp16_data0  = reg2dp_fp16_en ? data0 : 0;
      fp16_data1  = reg2dp_fp16_en ? data1 : 0;

      min_8int_lsb_ff = ($signed(data1_lsb)> $signed(data0_lsb));
      min_8int_msb_ff = ($signed(data1_msb)> $signed(data0_msb));
      //min_16int_ff    = ($signed(data1)>  $signed(data0))       ;
      min_16int_ff    = ($signed(int16_data1)>  $signed(int16_data0))       ;

      min_8int_lsb = (min_8int_lsb_ff) ? data0_lsb : data1_lsb;
      min_8int_msb = (min_8int_msb_ff) ? data0_msb : data1_msb;
      min_16int    = (min_16int_ff   ) ? int16_data0 : int16_data1;
      min_fp16     = ((~fp16_data0[15]) & (~fp16_data1[15]))? ((fp16_data0[14:0]>fp16_data1[14:0])? fp16_data1 : fp16_data0) : 
                     (((fp16_data0[15]) & (fp16_data1[15]))?  ((fp16_data0[14:0]>fp16_data1[14:0])? fp16_data0 : fp16_data1) : 
                     (((fp16_data0[15]) & (~fp16_data1[15]))?  fp16_data0 : fp16_data1));

      pooling_MIN  = reg2dp_fp16_en ? min_fp16 : 
                    (reg2dp_int16_en ? min_16int : {min_8int_msb,min_8int_lsb});
  end
 endfunction

 function[21:0] pooling_MAX; 
   input       reg2dp_int8_en;
   input       reg2dp_int16_en;
   input       reg2dp_fp16_en;
   input[21:0]  data0;
   input[21:0]  data1;
      reg[10:0]  data0_lsb;
      reg[10:0]  data0_msb;
      reg[10:0]  data1_lsb;
      reg[10:0]  data1_msb;
      reg[21:0]  max_16int;
      reg[21:0]  max_fp16;
      reg[10:0]  max_8int_lsb;
      reg[10:0]  max_8int_msb;
      reg [21:0] int16_data0;
      reg [21:0] int16_data1;
      reg [21:0] fp16_data0;
      reg [21:0] fp16_data1;
      reg        max_8int_lsb_ff;
      reg        max_8int_msb_ff;
      reg        max_16int_ff;
      begin
      {data0_msb,data0_lsb} = reg2dp_int8_en ? data0 : 0;
      {data1_msb,data1_lsb} = reg2dp_int8_en ? data1 : 0;
      int16_data0 = reg2dp_int16_en ? data0 : 0;
      int16_data1 = reg2dp_int16_en ? data1 : 0;
      fp16_data0  = reg2dp_fp16_en ? data0 : 0;
      fp16_data1  = reg2dp_fp16_en ? data1 : 0;
      max_8int_lsb_ff = ($signed(data0_lsb)> $signed(data1_lsb));
      max_8int_msb_ff = ($signed(data0_msb)> $signed(data1_msb));
      max_16int_ff    = ($signed(int16_data0)>  $signed(int16_data1))       ;

      max_8int_lsb = (max_8int_lsb_ff) ? data0_lsb : data1_lsb;
      max_8int_msb = (max_8int_msb_ff) ? data0_msb : data1_msb;
      max_16int    = (max_16int_ff   ) ? int16_data0 : int16_data1;
      max_fp16     = ((~fp16_data0[15]) & (~fp16_data1[15]))? ((fp16_data0[14:0]>fp16_data1[14:0])? fp16_data0 : fp16_data1) : 
                     (((fp16_data0[15]) & (fp16_data1[15]))?  ((fp16_data0[14:0]>fp16_data1[14:0])? fp16_data1 : fp16_data0) : 
                     (((fp16_data0[15]) & (~fp16_data1[15]))?  fp16_data1 : fp16_data0));
      pooling_MAX  = reg2dp_fp16_en ? max_fp16 : 
                    (reg2dp_int16_en ? max_16int : {max_8int_msb,max_8int_lsb});
  end
 endfunction

 function[21:0] pooling_SUM; 
   input       reg2dp_int8_en;
   input       reg2dp_int16_en;
   input[21:0]  data0;
   input[21:0]  data1;
   reg[10:0]  data0_lsb;
   reg[10:0]  data0_msb;
   reg[10:0]  data1_lsb;
   reg[10:0]  data1_msb;
   reg[21:0]  int16_data0;
   reg[21:0]  int16_data1;
   reg[21:0]  sum_16int;
   reg[10:0]  sum_8int_lsb;
   reg[10:0]  sum_8int_msb;
   reg[10:0]  sum_8int_lsb_ff;
   reg[10:0]  sum_8int_msb_ff;
   reg[21:0]  sum_16int_ff;
   begin
      {data0_msb,data0_lsb} = reg2dp_int8_en ? data0 : 0;
      {data1_msb,data1_lsb} = reg2dp_int8_en ? data1 : 0;
      int16_data0 = reg2dp_int16_en ? data0 : 0;
      int16_data1 = reg2dp_int16_en ? data1 : 0;
      //spyglass disable_block W484
      sum_8int_lsb_ff[10:0] =   $signed(data1_lsb) + $signed(data0_lsb);
      sum_8int_msb_ff[10:0] =   $signed(data1_msb) + $signed(data0_msb);
      sum_16int_ff[21:0]    =   $signed(int16_data1) + $signed(int16_data0); 
      //spyglass enable_block W484
      
      sum_8int_lsb =   sum_8int_lsb_ff;
      sum_8int_msb =   sum_8int_msb_ff;
      sum_16int    =   sum_16int_ff   ; 
      pooling_SUM  = reg2dp_int16_en ? sum_16int : {sum_8int_msb,sum_8int_lsb};
  end
 endfunction

 //pooling result
function[87:0] pooling_fun;
  input       reg2dp_int8_en;
  input       reg2dp_int16_en;
  input       reg2dp_fp16_en;
  input[1:0]  pooling_type;
  input[87:0] data0_in;
  input[87:0] data1_in;
  reg    min_pooling;
  reg    max_pooling;
  reg    mean_pooling;
  reg  [3:0] din0_is_nan;
  reg  [3:0] din1_is_nan;
  reg  [3:0] nan_in;
  begin
     min_pooling = (pooling_type== 2'h2 );
     max_pooling = (pooling_type== 2'h1 );
     mean_pooling = (pooling_type== 2'h0 );
     din0_is_nan[0] = &data0_in[14:10] & (|data0_in[9:0]);
     din1_is_nan[0] = &data1_in[14:10] & (|data1_in[9:0]);
     din0_is_nan[1] = &data0_in[36:32] & (|data0_in[31:22]);
     din1_is_nan[1] = &data1_in[36:32] & (|data1_in[31:22]);
     din0_is_nan[2] = &data0_in[58:54] & (|data0_in[53:44]);
     din1_is_nan[2] = &data1_in[58:54] & (|data1_in[53:44]);
     din0_is_nan[3] = &data0_in[80:76] & (|data0_in[75:66]);
     din1_is_nan[3] = &data1_in[80:76] & (|data1_in[75:66]);
     nan_in = din0_is_nan | din1_is_nan;
     pooling_fun[21:0]  = mean_pooling? pooling_SUM(reg2dp_int8_en,reg2dp_int16_en,data0_in[21:0],data1_in[21:0]) :
         min_pooling ? (((~reg2dp_fp16_en)| (~nan_in[0] & reg2dp_fp16_en))? pooling_MIN (reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,data0_in[21:0],data1_in[21:0]) : (din0_is_nan[0]? data0_in[21:0] : data1_in[21:0])) :
         max_pooling ? (((~reg2dp_fp16_en)| (~nan_in[0] & reg2dp_fp16_en))? pooling_MAX (reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,data0_in[21:0],data1_in[21:0]) : (din0_is_nan[0]? data0_in[21:0] : data1_in[21:0])) : 0;
      
     pooling_fun[43:22] = mean_pooling? pooling_SUM(reg2dp_int8_en,reg2dp_int16_en,data0_in[43:22],data1_in[43:22]) :
         min_pooling ? (((~reg2dp_fp16_en)| (~nan_in[1] & reg2dp_fp16_en))? pooling_MIN (reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,data0_in[43:22],data1_in[43:22]) : (din0_is_nan[1]? data0_in[43:22] : data1_in[43:22])):
         max_pooling ? (((~reg2dp_fp16_en)| (~nan_in[1] & reg2dp_fp16_en))? pooling_MAX (reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,data0_in[43:22],data1_in[43:22]) : (din0_is_nan[1]? data0_in[43:22] : data1_in[43:22])): 0;
      
     pooling_fun[65:44] = mean_pooling? pooling_SUM(reg2dp_int8_en,reg2dp_int16_en,data0_in[65:44],data1_in[65:44]) :
         min_pooling ? (((~reg2dp_fp16_en)| (~nan_in[2] & reg2dp_fp16_en))? pooling_MIN (reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,data0_in[65:44],data1_in[65:44]) : (din0_is_nan[2]? data0_in[65:44] : data1_in[65:44])) :
         max_pooling ? (((~reg2dp_fp16_en)| (~nan_in[2] & reg2dp_fp16_en))? pooling_MAX (reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,data0_in[65:44],data1_in[65:44]) : (din0_is_nan[2]? data0_in[65:44] : data1_in[65:44])) : 0;
      
     pooling_fun[87:66]= mean_pooling? pooling_SUM(reg2dp_int8_en,reg2dp_int16_en,data0_in[87:66],data1_in[87:66]) : 
         min_pooling ? (((~reg2dp_fp16_en)| (~nan_in[3] & reg2dp_fp16_en))? pooling_MIN (reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,data0_in[87:66],data1_in[87:66]) : (din0_is_nan[3]? data0_in[87:66] : data1_in[87:66])) :
         max_pooling ? (((~reg2dp_fp16_en)| (~nan_in[3] & reg2dp_fp16_en))? pooling_MAX (reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,data0_in[87:66],data1_in[87:66]) : (din0_is_nan[3]? data0_in[87:66] : data1_in[87:66])) : 0;
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
assign datain_ext = pdma2pdp_pd[87:0];
always @(
  buf_sel
  or data_buf0
  or data_buf1
  or data_buf2
  or data_buf3
  ) begin
    case(buf_sel)   
       2'd0:    cur_pooling_dat = data_buf0[87:0];
       2'd1:    cur_pooling_dat = data_buf1[87:0];
       2'd2:    cur_pooling_dat = data_buf2[87:0];
       2'd3:    cur_pooling_dat = data_buf3[87:0];
       //VCS coverage off
       default: cur_pooling_dat = 88'd0;
       //VCS coverage on
    endcase
end
//--------------------------------------------------------------------
//pooling function for fp16 average mode
assign fp_datain_ext      = datain_ext[87:0] ;
assign fp_cur_pooling_dat = cur_pooling_dat[87:0];

assign fp_addin_vld = pdma2pdp_pvld & pipe_in_rdy & fp_mean_pool_cfg;
cal1d_fp16_pool_sum u_cal1d_fp16_pool_sum (
   .inp_a_0                 (fp_cur_pooling_dat[16:0])  //|< w
  ,.inp_a_1                 (fp_cur_pooling_dat[38:22]) //|< w
  ,.inp_a_2                 (fp_cur_pooling_dat[60:44]) //|< w
  ,.inp_a_3                 (fp_cur_pooling_dat[82:66]) //|< w
  ,.inp_b_0                 (fp_datain_ext[16:0])       //|< w
  ,.inp_b_1                 (fp_datain_ext[38:22])      //|< w
  ,.inp_b_2                 (fp_datain_ext[60:44])      //|< w
  ,.inp_b_3                 (fp_datain_ext[82:66])      //|< w
  ,.inp_in_pvld             (fp_addin_vld)              //|< w
  ,.inp_out_prdy            (fp16_pool_sum_prdy)        //|< w
  ,.nvdla_core_rstn         (nvdla_core_rstn)           //|< i
  ,.nvdla_op_gated_clk_fp16 (nvdla_op_gated_clk_fp16)   //|< i
  ,.inp_in_prdy             (fp_addin_rdy)              //|> w
  ,.inp_out_pvld            (fp16_pool_sum_pvld)        //|> w
  ,.out_z_0                 (fp16_pool_sum_0[16:0])     //|> w
  ,.out_z_1                 (fp16_pool_sum_1[16:0])     //|> w
  ,.out_z_2                 (fp16_pool_sum_2[16:0])     //|> w
  ,.out_z_3                 (fp16_pool_sum_3[16:0])     //|> w
  );
assign fp_pool_sum = {fp16_pool_sum_3,fp16_pool_sum_2,fp16_pool_sum_1,fp16_pool_sum_0};
////////////////////
//assign pipe_in_vld = pdma2pdp_pvld & fp_addin_rdy;
assign pipe_in_vld = fp_mean_pool_cfg ? pdma2pdp_pvld & fp_addin_rdy : pdma2pdp_pvld;
assign pipe_in_pd  = {pooling_din_last,pooling_out_size,cur_datin_disable,buf_sel[1:0],pdp_din_lc_f,pooling_din_1st,datain_ext[87:0],int_pooling[87:0]};

assign pipe_in_vld_d0 = pipe_in_vld;
assign pipe_in_rdy = pipe_in_rdy_d0;
assign pipe_in_pd_d0[184:0] = pipe_in_pd[184:0];
NV_NVDLA_PDP_CORE_UNIT1D_pipe_p1 pipe_p1 (
   .nvdla_core_clk          (nvdla_core_clk)            //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)           //|< i
  ,.pipe_in_pd_d0           (pipe_in_pd_d0[184:0])      //|< w
  ,.pipe_in_rdy_d1          (pipe_in_rdy_d1)            //|< w
  ,.pipe_in_vld_d0          (pipe_in_vld_d0)            //|< w
  ,.pipe_in_pd_d1           (pipe_in_pd_d1[184:0])      //|> w
  ,.pipe_in_rdy_d0          (pipe_in_rdy_d0)            //|> w
  ,.pipe_in_vld_d1          (pipe_in_vld_d1)            //|> w
  );
NV_NVDLA_PDP_CORE_UNIT1D_pipe_p2 pipe_p2 (
   .nvdla_core_clk          (nvdla_core_clk)            //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)           //|< i
  ,.pipe_in_pd_d1           (pipe_in_pd_d1[184:0])      //|< w
  ,.pipe_in_rdy_d2          (pipe_in_rdy_d2)            //|< w
  ,.pipe_in_vld_d1          (pipe_in_vld_d1)            //|< w
  ,.pipe_in_pd_d2           (pipe_in_pd_d2[184:0])      //|> w
  ,.pipe_in_rdy_d1          (pipe_in_rdy_d1)            //|> w
  ,.pipe_in_vld_d2          (pipe_in_vld_d2)            //|> w
  );
NV_NVDLA_PDP_CORE_UNIT1D_pipe_p3 pipe_p3 (
   .nvdla_core_clk          (nvdla_core_clk)            //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)           //|< i
  ,.pipe_in_pd_d2           (pipe_in_pd_d2[184:0])      //|< w
  ,.pipe_in_rdy_d3          (pipe_in_rdy_d3)            //|< w
  ,.pipe_in_vld_d2          (pipe_in_vld_d2)            //|< w
  ,.pipe_in_pd_d3           (pipe_in_pd_d3[184:0])      //|> w
  ,.pipe_in_rdy_d2          (pipe_in_rdy_d2)            //|> w
  ,.pipe_in_vld_d3          (pipe_in_vld_d3)            //|> w
  );
NV_NVDLA_PDP_CORE_UNIT1D_pipe_p4 pipe_p4 (
   .nvdla_core_clk          (nvdla_core_clk)            //|< i
  ,.nvdla_core_rstn         (nvdla_core_rstn)           //|< i
  ,.pipe_in_pd_d3           (pipe_in_pd_d3[184:0])      //|< w
  ,.pipe_in_rdy_d4          (pipe_in_rdy_d4)            //|< w
  ,.pipe_in_vld_d3          (pipe_in_vld_d3)            //|< w
  ,.pipe_in_pd_d4           (pipe_in_pd_d4[184:0])      //|> w
  ,.pipe_in_rdy_d3          (pipe_in_rdy_d3)            //|> w
  ,.pipe_in_vld_d4          (pipe_in_vld_d4)            //|> w
  );
assign pipe_out_vld = pipe_in_vld_d4;
assign pipe_in_rdy_d4 = pipe_out_rdy;
assign pipe_out_pd[184:0] = pipe_in_pd_d4[184:0];

assign pipe_out_rdy = fp_mean_pool_cfg ? (add_out_rdy & fp16_pool_sum_pvld) : add_out_rdy;
assign fp16_pool_sum_prdy = fp_mean_pool_cfg & add_out_rdy & pipe_out_vld;

assign add_out_vld =  fp_mean_pool_cfg ? (pipe_out_vld & fp16_pool_sum_pvld) : pipe_out_vld;

assign add_out_rdy = ~pooling_out_vld | pooling_out_prdy;
////////////////////
assign int_pooling_sync      = pipe_out_pd[87:0];
assign datain_ext_sync       = pipe_out_pd[175:88];
assign pooling_din_1st_sync  = pipe_out_pd[176];
assign pdp_din_lc_f_sync     = pipe_out_pd[177];
assign buf_sel_sync          = pipe_out_pd[179:178];
assign cur_datin_disable_sync= pipe_out_pd[180];
assign pooling_out_size_sync = pipe_out_pd[183:181];
assign pooling_din_last_sync = pipe_out_pd[184];
////////////////////
//for NVDLA_HLS_ADD17_LATENCY==3
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    fp_pool_sum_result0_d3 <= {68{1'b0}};
    fp_pool_sum_result1_d3 <= {68{1'b0}};
    fp_pool_sum_result2_d3 <= {68{1'b0}};
    fp_pool_sum_result3_d3 <= {68{1'b0}};
  end else begin
    if(add_out_vld & add_out_rdy) begin
        if(pooling_din_1st_sync) begin
            case(buf_sel_sync)
                2'd0: fp_pool_sum_result0_d3 <= {datain_ext_sync[82:66],datain_ext_sync[60:44],datain_ext_sync[38:22],datain_ext_sync[16:0]};
                2'd1: fp_pool_sum_result1_d3 <= {datain_ext_sync[82:66],datain_ext_sync[60:44],datain_ext_sync[38:22],datain_ext_sync[16:0]};
                2'd2: fp_pool_sum_result2_d3 <= {datain_ext_sync[82:66],datain_ext_sync[60:44],datain_ext_sync[38:22],datain_ext_sync[16:0]};
                2'd3: fp_pool_sum_result3_d3 <= {datain_ext_sync[82:66],datain_ext_sync[60:44],datain_ext_sync[38:22],datain_ext_sync[16:0]};
       //VCS coverage off
                default: begin
                    fp_pool_sum_result0_d3 <= fp_pool_sum_result0_d3;
                    fp_pool_sum_result1_d3 <= fp_pool_sum_result1_d3;
                    fp_pool_sum_result2_d3 <= fp_pool_sum_result2_d3;
                    fp_pool_sum_result3_d3 <= fp_pool_sum_result3_d3;
                end
       //VCS coverage on
            endcase
        end else begin
            case(buf_sel_sync)
                2'd0: fp_pool_sum_result0_d3 <= fp_pool_sum;
                2'd1: fp_pool_sum_result1_d3 <= fp_pool_sum;
                2'd2: fp_pool_sum_result2_d3 <= fp_pool_sum;
                2'd3: fp_pool_sum_result3_d3 <= fp_pool_sum;
       //VCS coverage off
                default: begin
                    fp_pool_sum_result0_d3 <= fp_pool_sum_result0_d3;
                    fp_pool_sum_result1_d3 <= fp_pool_sum_result1_d3;
                    fp_pool_sum_result2_d3 <= fp_pool_sum_result2_d3;
                    fp_pool_sum_result3_d3 <= fp_pool_sum_result3_d3;
                end
       //VCS coverage on
            endcase
        end
    end
  end
end

//for NVDLA_HLS_ADD17_LATENCY==4
always @(
  pooling_din_1st_sync
  or buf_sel_sync
  or datain_ext_sync
  or fp_pool_sum_result0_d3
  or fp_pool_sum_result1_d3
  or fp_pool_sum_result2_d3
  or fp_pool_sum_result3_d3
  or fp_pool_sum
  ) begin
    if(pooling_din_1st_sync) begin
        fp_pool_sum_result0_d4 = (buf_sel_sync==2'd0)? {datain_ext_sync[82:66],datain_ext_sync[60:44],datain_ext_sync[38:22],datain_ext_sync[16:0]} : fp_pool_sum_result0_d3;
        fp_pool_sum_result1_d4 = (buf_sel_sync==2'd1)? {datain_ext_sync[82:66],datain_ext_sync[60:44],datain_ext_sync[38:22],datain_ext_sync[16:0]} : fp_pool_sum_result1_d3;
        fp_pool_sum_result2_d4 = (buf_sel_sync==2'd2)? {datain_ext_sync[82:66],datain_ext_sync[60:44],datain_ext_sync[38:22],datain_ext_sync[16:0]} : fp_pool_sum_result2_d3;
        fp_pool_sum_result3_d4 = (buf_sel_sync==2'd3)? {datain_ext_sync[82:66],datain_ext_sync[60:44],datain_ext_sync[38:22],datain_ext_sync[16:0]} : fp_pool_sum_result3_d3;
    end else begin
        fp_pool_sum_result0_d4 = (buf_sel_sync==2'd0)? fp_pool_sum : fp_pool_sum_result0_d3;
        fp_pool_sum_result1_d4 = (buf_sel_sync==2'd1)? fp_pool_sum : fp_pool_sum_result1_d3;
        fp_pool_sum_result2_d4 = (buf_sel_sync==2'd2)? fp_pool_sum : fp_pool_sum_result2_d3;
        fp_pool_sum_result3_d4 = (buf_sel_sync==2'd3)? fp_pool_sum : fp_pool_sum_result3_d3;
    end
end

//assign fp_pool_sum_result0 = (NVDLA_HLS_ADD17_LATENCY == 4) ? fp_pool_sum_result0_d4 : fp_pool_sum_result0_d3;
//assign fp_pool_sum_result1 = (NVDLA_HLS_ADD17_LATENCY == 4) ? fp_pool_sum_result1_d4 : fp_pool_sum_result1_d3;
//assign fp_pool_sum_result2 = (NVDLA_HLS_ADD17_LATENCY == 4) ? fp_pool_sum_result2_d4 : fp_pool_sum_result2_d3;
//assign fp_pool_sum_result3 = (NVDLA_HLS_ADD17_LATENCY == 4) ? fp_pool_sum_result3_d4 : fp_pool_sum_result3_d3;
assign fp_pool_sum_result0 = fp_pool_sum_result0_d4;
assign fp_pool_sum_result1 = fp_pool_sum_result1_d4;
assign fp_pool_sum_result2 = fp_pool_sum_result2_d4;
assign fp_pool_sum_result3 = fp_pool_sum_result3_d4;

assign fp_pool_sum_use0 = {5'd0,fp_pool_sum_result0[67:51],5'd0,fp_pool_sum_result0[50:34],5'd0,fp_pool_sum_result0[33:17],5'd0,fp_pool_sum_result0[16:0]};
assign fp_pool_sum_use1 = {5'd0,fp_pool_sum_result1[67:51],5'd0,fp_pool_sum_result1[50:34],5'd0,fp_pool_sum_result1[33:17],5'd0,fp_pool_sum_result1[16:0]};
assign fp_pool_sum_use2 = {5'd0,fp_pool_sum_result2[67:51],5'd0,fp_pool_sum_result2[50:34],5'd0,fp_pool_sum_result2[33:17],5'd0,fp_pool_sum_result2[16:0]};
assign fp_pool_sum_use3 = {5'd0,fp_pool_sum_result3[67:51],5'd0,fp_pool_sum_result3[50:34],5'd0,fp_pool_sum_result3[33:17],5'd0,fp_pool_sum_result3[16:0]};
//////////////////////////
assign pool_fun_vld = fp_mean_pool_cfg ? 1'b0 : load_din;
assign int_pool_datin_ext = pool_fun_vld ? datain_ext : 88'd0;
assign int_pool_cur_dat   = pool_fun_vld ? cur_pooling_dat[87:0] : 88'd0;
assign int_pooling = pooling_fun(reg2dp_int8_en,reg2dp_int16_en,reg2dp_fp16_en,pooling_type_cfg[1:0],int_pool_cur_dat, int_pool_datin_ext);

assign pooling_result = (pooling_din_1st_sync ? datain_ext_sync : int_pooling_sync);
//--------------------------------------------------------------------
//for NVDLA_HLS_ADD17_LATENCY==3
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    latch_result0_d3[87:0] <= {88{1'b0}};
    latch_result1_d3[87:0] <= {88{1'b0}};
    latch_result2_d3[87:0] <= {88{1'b0}};
    latch_result3_d3[87:0] <= {88{1'b0}};
  end else begin
    if(add_out_vld & add_out_rdy) begin
        //pooling_out_size_sync_use_d3 <0= pooling_out_size_sync;
        //pooling_din_last_sync_use_d3 <0= pooling_din_last_sync;
        //buf_sel_sync_use_d3 <0= buf_sel_sync;
        //cur_datin_disable_sync_use_d3 <0= cur_datin_disable_sync;
        //data_buf_lc_d3 <0= pdp_din_lc_f_sync;
        case(buf_sel_sync)
            2'd0: latch_result0_d3[87:0] <= pooling_result;
            2'd1: latch_result1_d3[87:0] <= pooling_result;
            2'd2: latch_result2_d3[87:0] <= pooling_result;
            2'd3: latch_result3_d3[87:0] <= pooling_result;
       //VCS coverage off
            default: begin
                latch_result0_d3[87:0] <= latch_result0_d3[87:0];
                latch_result1_d3[87:0] <= latch_result1_d3[87:0];
                latch_result2_d3[87:0] <= latch_result2_d3[87:0];
                latch_result3_d3[87:0] <= latch_result3_d3[87:0];
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
assign latch_result0_d4[87:0] = (buf_sel_sync==2'd0)? pooling_result : latch_result0_d3[87:0];
assign latch_result1_d4[87:0] = (buf_sel_sync==2'd1)? pooling_result : latch_result1_d3[87:0];
assign latch_result2_d4[87:0] = (buf_sel_sync==2'd2)? pooling_result : latch_result2_d3[87:0];
assign latch_result3_d4[87:0] = (buf_sel_sync==2'd3)? pooling_result : latch_result3_d3[87:0];

//assign latch_result0[87:0] = (NVDLA_HLS_ADD17_LATENCY == 4) ? latch_result0_d4[87:0] : latch_result0_d3[87:0];
//assign latch_result1[87:0] = (NVDLA_HLS_ADD17_LATENCY == 4) ? latch_result1_d4[87:0] : latch_result1_d3[87:0];
//assign latch_result2[87:0] = (NVDLA_HLS_ADD17_LATENCY == 4) ? latch_result2_d4[87:0] : latch_result2_d3[87:0];
//assign latch_result3[87:0] = (NVDLA_HLS_ADD17_LATENCY == 4) ? latch_result3_d4[87:0] : latch_result3_d3[87:0];
assign latch_result0[87:0] = latch_result0_d4[87:0];
assign latch_result1[87:0] = latch_result1_d4[87:0];
assign latch_result2[87:0] = latch_result2_d4[87:0];
assign latch_result3[87:0] = latch_result3_d4[87:0];

assign data_buf0 = fp_mean_pool_cfg ? fp_pool_sum_use0 : latch_result0[87:0];
assign data_buf1 = fp_mean_pool_cfg ? fp_pool_sum_use1 : latch_result1[87:0];
assign data_buf2 = fp_mean_pool_cfg ? fp_pool_sum_use2 : latch_result2[87:0];
assign data_buf3 = fp_mean_pool_cfg ? fp_pool_sum_use3 : latch_result3[87:0];

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
    pooling_cnt <= {2{1'b0}};
  end else begin
    if(pooling_out_vld & pooling_out_prdy & ((pooling_din_last_sync_use & (~cur_datin_disable_sync_use)) | last_out_en))begin
        if(pooling_cnt==2'd3)
            pooling_cnt <= 2'd0;
        else
            pooling_cnt <= pooling_cnt +1'd1;
    end
  end
end
   
always @(
  last_out_en
  or pooling_cnt
  or flush_out0
  or flush_out1
  or flush_out2
  or flush_out3
  or data_buf_lc
  or pooling_out_size_sync_use
  or data_buf0
  or data_buf1
  or data_buf2
  or data_buf3
  ) begin
    if(last_out_en) begin
        case(pooling_cnt) 
         2'd0:    pooling_out = flush_out0;
         2'd1:    pooling_out = flush_out1;
         2'd2:    pooling_out = flush_out2;
         default: pooling_out = flush_out3;
        endcase
    end else begin
        case(pooling_cnt) 
         2'd0:    pooling_out = {data_buf_lc,pooling_out_size_sync_use,data_buf0};
         2'd1:    pooling_out = {data_buf_lc,pooling_out_size_sync_use,data_buf1};
         2'd2:    pooling_out = {data_buf_lc,pooling_out_size_sync_use,data_buf2};
         default: pooling_out = {data_buf_lc,pooling_out_size_sync_use,data_buf3};
        endcase
    end
end
//////////////////////////////////////////////
//output latch in line end for flush
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    flush_out0 <= {92{1'b0}};
    flush_out1 <= {92{1'b0}};
    flush_out2 <= {92{1'b0}};
    flush_out3 <= {92{1'b0}};
  end else begin
    if(pooling_din_last_sync_use & (~cur_datin_disable_sync_use)) begin
        case(buf_sel_sync_use)
        2'b00: flush_out0 <= {data_buf_lc,pooling_out_size_sync_use,data_buf0};
        2'b01: flush_out1 <= {data_buf_lc,pooling_out_size_sync_use,data_buf1};
        2'b10: flush_out2 <= {data_buf_lc,pooling_out_size_sync_use,data_buf2};
        2'b11: flush_out3 <= {data_buf_lc,pooling_out_size_sync_use,data_buf3};
       //VCS coverage off
        default: begin
            flush_out0 <= flush_out0;
            flush_out1 <= flush_out1;
            flush_out2 <= flush_out2;
            flush_out3 <= flush_out3;
        end
       //VCS coverage on
        endcase
    end
  end
end

//////////////////////////////////////////////
endmodule // NV_NVDLA_PDP_CORE_unit1d



// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none pipe_in_pd_d1[184:0] (pipe_in_vld_d1,pipe_in_rdy_d1) <= pipe_in_pd_d0[184:0] (pipe_in_vld_d0,pipe_in_rdy_d0)
// **************************************************************************************************************
module NV_NVDLA_PDP_CORE_UNIT1D_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,pipe_in_pd_d0
  ,pipe_in_rdy_d1
  ,pipe_in_vld_d0
  ,pipe_in_pd_d1
  ,pipe_in_rdy_d0
  ,pipe_in_vld_d1
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [184:0] pipe_in_pd_d0;
input          pipe_in_rdy_d1;
input          pipe_in_vld_d0;
output [184:0] pipe_in_pd_d1;
output         pipe_in_rdy_d0;
output         pipe_in_vld_d1;
reg    [184:0] p1_pipe_data;
reg            p1_pipe_ready;
reg            p1_pipe_ready_bc;
reg            p1_pipe_valid;
reg    [184:0] pipe_in_pd_d1;
reg            pipe_in_rdy_d0;
reg            pipe_in_vld_d1;
//## pipe (1) valid-ready-bubble-collapse
always @(
  p1_pipe_ready
  or p1_pipe_valid
  ) begin
  p1_pipe_ready_bc = p1_pipe_ready || !p1_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_valid <= 1'b0;
  end else begin
  p1_pipe_valid <= (p1_pipe_ready_bc)? pipe_in_vld_d0 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && pipe_in_vld_d0)? pipe_in_pd_d0[184:0] : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  pipe_in_rdy_d0 = p1_pipe_ready_bc;
end
//## pipe (1) output
always @(
  p1_pipe_valid
  or pipe_in_rdy_d1
  or p1_pipe_data
  ) begin
  pipe_in_vld_d1 = p1_pipe_valid;
  p1_pipe_ready = pipe_in_rdy_d1;
  pipe_in_pd_d1[184:0] = p1_pipe_data;
end
//## pipe (1) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p1_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (pipe_in_vld_d1^pipe_in_rdy_d1^pipe_in_vld_d0^pipe_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (pipe_in_vld_d0 && !pipe_in_rdy_d0), (pipe_in_vld_d0), (pipe_in_rdy_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_PDP_CORE_UNIT1D_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none pipe_in_pd_d2[184:0] (pipe_in_vld_d2,pipe_in_rdy_d2) <= pipe_in_pd_d1[184:0] (pipe_in_vld_d1,pipe_in_rdy_d1)
// **************************************************************************************************************
module NV_NVDLA_PDP_CORE_UNIT1D_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,pipe_in_pd_d1
  ,pipe_in_rdy_d2
  ,pipe_in_vld_d1
  ,pipe_in_pd_d2
  ,pipe_in_rdy_d1
  ,pipe_in_vld_d2
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [184:0] pipe_in_pd_d1;
input          pipe_in_rdy_d2;
input          pipe_in_vld_d1;
output [184:0] pipe_in_pd_d2;
output         pipe_in_rdy_d1;
output         pipe_in_vld_d2;
reg    [184:0] p2_pipe_data;
reg            p2_pipe_ready;
reg            p2_pipe_ready_bc;
reg            p2_pipe_valid;
reg    [184:0] pipe_in_pd_d2;
reg            pipe_in_rdy_d1;
reg            pipe_in_vld_d2;
//## pipe (2) valid-ready-bubble-collapse
always @(
  p2_pipe_ready
  or p2_pipe_valid
  ) begin
  p2_pipe_ready_bc = p2_pipe_ready || !p2_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_valid <= 1'b0;
  end else begin
  p2_pipe_valid <= (p2_pipe_ready_bc)? pipe_in_vld_d1 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && pipe_in_vld_d1)? pipe_in_pd_d1[184:0] : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  pipe_in_rdy_d1 = p2_pipe_ready_bc;
end
//## pipe (2) output
always @(
  p2_pipe_valid
  or pipe_in_rdy_d2
  or p2_pipe_data
  ) begin
  pipe_in_vld_d2 = p2_pipe_valid;
  p2_pipe_ready = pipe_in_rdy_d2;
  pipe_in_pd_d2[184:0] = p2_pipe_data;
end
//## pipe (2) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p2_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (pipe_in_vld_d2^pipe_in_rdy_d2^pipe_in_vld_d1^pipe_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_4x (nvdla_core_clk, `ASSERT_RESET, (pipe_in_vld_d1 && !pipe_in_rdy_d1), (pipe_in_vld_d1), (pipe_in_rdy_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_PDP_CORE_UNIT1D_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none pipe_in_pd_d3[184:0] (pipe_in_vld_d3,pipe_in_rdy_d3) <= pipe_in_pd_d2[184:0] (pipe_in_vld_d2,pipe_in_rdy_d2)
// **************************************************************************************************************
module NV_NVDLA_PDP_CORE_UNIT1D_pipe_p3 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,pipe_in_pd_d2
  ,pipe_in_rdy_d3
  ,pipe_in_vld_d2
  ,pipe_in_pd_d3
  ,pipe_in_rdy_d2
  ,pipe_in_vld_d3
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [184:0] pipe_in_pd_d2;
input          pipe_in_rdy_d3;
input          pipe_in_vld_d2;
output [184:0] pipe_in_pd_d3;
output         pipe_in_rdy_d2;
output         pipe_in_vld_d3;
reg    [184:0] p3_pipe_data;
reg            p3_pipe_ready;
reg            p3_pipe_ready_bc;
reg            p3_pipe_valid;
reg    [184:0] pipe_in_pd_d3;
reg            pipe_in_rdy_d2;
reg            pipe_in_vld_d3;
//## pipe (3) valid-ready-bubble-collapse
always @(
  p3_pipe_ready
  or p3_pipe_valid
  ) begin
  p3_pipe_ready_bc = p3_pipe_ready || !p3_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_pipe_valid <= 1'b0;
  end else begin
  p3_pipe_valid <= (p3_pipe_ready_bc)? pipe_in_vld_d2 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_pipe_data <= (p3_pipe_ready_bc && pipe_in_vld_d2)? pipe_in_pd_d2[184:0] : p3_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p3_pipe_ready_bc
  ) begin
  pipe_in_rdy_d2 = p3_pipe_ready_bc;
end
//## pipe (3) output
always @(
  p3_pipe_valid
  or pipe_in_rdy_d3
  or p3_pipe_data
  ) begin
  pipe_in_vld_d3 = p3_pipe_valid;
  p3_pipe_ready = pipe_in_rdy_d3;
  pipe_in_pd_d3[184:0] = p3_pipe_data;
end
//## pipe (3) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p3_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (pipe_in_vld_d3^pipe_in_rdy_d3^pipe_in_vld_d2^pipe_in_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_6x (nvdla_core_clk, `ASSERT_RESET, (pipe_in_vld_d2 && !pipe_in_rdy_d2), (pipe_in_vld_d2), (pipe_in_rdy_d2)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_PDP_CORE_UNIT1D_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -bc  -rand none pipe_in_pd_d4[184:0] (pipe_in_vld_d4,pipe_in_rdy_d4) <= pipe_in_pd_d3[184:0] (pipe_in_vld_d3,pipe_in_rdy_d3)
// **************************************************************************************************************
module NV_NVDLA_PDP_CORE_UNIT1D_pipe_p4 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,pipe_in_pd_d3
  ,pipe_in_rdy_d4
  ,pipe_in_vld_d3
  ,pipe_in_pd_d4
  ,pipe_in_rdy_d3
  ,pipe_in_vld_d4
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [184:0] pipe_in_pd_d3;
input          pipe_in_rdy_d4;
input          pipe_in_vld_d3;
output [184:0] pipe_in_pd_d4;
output         pipe_in_rdy_d3;
output         pipe_in_vld_d4;
reg    [184:0] p4_pipe_data;
reg            p4_pipe_ready;
reg            p4_pipe_ready_bc;
reg            p4_pipe_valid;
reg    [184:0] pipe_in_pd_d4;
reg            pipe_in_rdy_d3;
reg            pipe_in_vld_d4;
//## pipe (4) valid-ready-bubble-collapse
always @(
  p4_pipe_ready
  or p4_pipe_valid
  ) begin
  p4_pipe_ready_bc = p4_pipe_ready || !p4_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_pipe_valid <= 1'b0;
  end else begin
  p4_pipe_valid <= (p4_pipe_ready_bc)? pipe_in_vld_d3 : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_pipe_data <= (p4_pipe_ready_bc && pipe_in_vld_d3)? pipe_in_pd_d3[184:0] : p4_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p4_pipe_ready_bc
  ) begin
  pipe_in_rdy_d3 = p4_pipe_ready_bc;
end
//## pipe (4) output
always @(
  p4_pipe_valid
  or pipe_in_rdy_d4
  or p4_pipe_data
  ) begin
  pipe_in_vld_d4 = p4_pipe_valid;
  p4_pipe_ready = pipe_in_rdy_d4;
  pipe_in_pd_d4[184:0] = p4_pipe_data;
end
//## pipe (4) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p4_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (pipe_in_vld_d4^pipe_in_rdy_d4^pipe_in_vld_d3^pipe_in_rdy_d3)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_8x (nvdla_core_clk, `ASSERT_RESET, (pipe_in_vld_d3 && !pipe_in_rdy_d3), (pipe_in_vld_d3), (pipe_in_rdy_d3)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_PDP_CORE_UNIT1D_pipe_p4



