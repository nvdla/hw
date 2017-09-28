// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_cmux.v

`include "simulate_x_tick.vh"
module NV_NVDLA_SDP_cmux (
   nvdla_core_clk        //|< i
  ,nvdla_core_rstn       //|< i
  ,cacc2sdp_pd           //|< i
  ,cacc2sdp_valid        //|< i
  ,op_en_load            //|< i
  ,reg2dp_flying_mode    //|< i
  ,reg2dp_nan_to_zero    //|< i
  ,reg2dp_proc_precision //|< i
  ,sdp_cmux2dp_ready     //|< i
  ,sdp_mrdma2cmux_pd     //|< i
  ,sdp_mrdma2cmux_valid  //|< i
  ,cacc2sdp_ready        //|> o
  ,sdp_cmux2dp_pd        //|> o
  ,sdp_cmux2dp_valid     //|> o
  ,sdp_mrdma2cmux_ready  //|> o
  );

//
// NV_NVDLA_SDP_cmux_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input          cacc2sdp_valid;  /* data valid */
output         cacc2sdp_ready;  /* data return handshake */
input  [513:0] cacc2sdp_pd;

input          sdp_mrdma2cmux_valid;  /* data valid */
output         sdp_mrdma2cmux_ready;  /* data return handshake */
input  [513:0] sdp_mrdma2cmux_pd;

input          sdp_cmux2dp_ready;
output [511:0] sdp_cmux2dp_pd;
output         sdp_cmux2dp_valid;
input          reg2dp_flying_mode;
input          reg2dp_nan_to_zero;
input    [1:0] reg2dp_proc_precision;
input          op_en_load;
reg            cfg_flying_mode_on;
reg            cfg_nan_to_zero;
reg            cfg_proc_precision;
reg            cmux_in_en;
wire   [513:0] cacc_pd;
wire           cacc_rdy;
wire           cacc_vld;
wire           cfg_nan_to_zero_en;
wire   [511:0] cmux2dp_pd;
wire           cmux2dp_prdy;
wire           cmux2dp_pvld;
wire   [513:0] cmux_pd;
wire           cmux_pd_batch_end;
wire    [31:0] cmux_pd_data0;
wire    [31:0] cmux_pd_data1;
wire    [31:0] cmux_pd_data10;
wire    [31:0] cmux_pd_data11;
wire    [31:0] cmux_pd_data12;
wire    [31:0] cmux_pd_data13;
wire    [31:0] cmux_pd_data14;
wire    [31:0] cmux_pd_data15;
wire    [31:0] cmux_pd_data2;
wire    [31:0] cmux_pd_data3;
wire    [31:0] cmux_pd_data4;
wire    [31:0] cmux_pd_data5;
wire    [31:0] cmux_pd_data6;
wire    [31:0] cmux_pd_data7;
wire    [31:0] cmux_pd_data8;
wire    [31:0] cmux_pd_data9;
wire           cmux_pd_flush_batch_end_NC;
wire   [511:0] cmux_pd_flush_data;
wire           cmux_pd_layer_end;
wire    [31:0] data_byte0;
wire     [7:0] data_byte0_expo;
wire    [31:0] data_byte0_flush;
wire    [22:0] data_byte0_mant;
wire    [31:0] data_byte1;
wire    [31:0] data_byte10;
wire     [7:0] data_byte10_expo;
wire    [31:0] data_byte10_flush;
wire    [22:0] data_byte10_mant;
wire    [31:0] data_byte11;
wire     [7:0] data_byte11_expo;
wire    [31:0] data_byte11_flush;
wire    [22:0] data_byte11_mant;
wire    [31:0] data_byte12;
wire     [7:0] data_byte12_expo;
wire    [31:0] data_byte12_flush;
wire    [22:0] data_byte12_mant;
wire    [31:0] data_byte13;
wire     [7:0] data_byte13_expo;
wire    [31:0] data_byte13_flush;
wire    [22:0] data_byte13_mant;
wire    [31:0] data_byte14;
wire     [7:0] data_byte14_expo;
wire    [31:0] data_byte14_flush;
wire    [22:0] data_byte14_mant;
wire    [31:0] data_byte15;
wire     [7:0] data_byte15_expo;
wire    [31:0] data_byte15_flush;
wire    [22:0] data_byte15_mant;
wire     [7:0] data_byte1_expo;
wire    [31:0] data_byte1_flush;
wire    [22:0] data_byte1_mant;
wire    [31:0] data_byte2;
wire     [7:0] data_byte2_expo;
wire    [31:0] data_byte2_flush;
wire    [22:0] data_byte2_mant;
wire    [31:0] data_byte3;
wire     [7:0] data_byte3_expo;
wire    [31:0] data_byte3_flush;
wire    [22:0] data_byte3_mant;
wire    [31:0] data_byte4;
wire     [7:0] data_byte4_expo;
wire    [31:0] data_byte4_flush;
wire    [22:0] data_byte4_mant;
wire    [31:0] data_byte5;
wire     [7:0] data_byte5_expo;
wire    [31:0] data_byte5_flush;
wire    [22:0] data_byte5_mant;
wire    [31:0] data_byte6;
wire     [7:0] data_byte6_expo;
wire    [31:0] data_byte6_flush;
wire    [22:0] data_byte6_mant;
wire    [31:0] data_byte7;
wire     [7:0] data_byte7_expo;
wire    [31:0] data_byte7_flush;
wire    [22:0] data_byte7_mant;
wire    [31:0] data_byte8;
wire     [7:0] data_byte8_expo;
wire    [31:0] data_byte8_flush;
wire    [22:0] data_byte8_mant;
wire    [31:0] data_byte9;
wire     [7:0] data_byte9_expo;
wire    [31:0] data_byte9_flush;
wire    [22:0] data_byte9_mant;
wire           is_data_byte0_nan;
wire           is_data_byte10_nan;
wire           is_data_byte11_nan;
wire           is_data_byte12_nan;
wire           is_data_byte13_nan;
wire           is_data_byte14_nan;
wire           is_data_byte15_nan;
wire           is_data_byte1_nan;
wire           is_data_byte2_nan;
wire           is_data_byte3_nan;
wire           is_data_byte4_nan;
wire           is_data_byte5_nan;
wire           is_data_byte6_nan;
wire           is_data_byte7_nan;
wire           is_data_byte8_nan;
wire           is_data_byte9_nan;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
//=======================
// CFG
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_flying_mode_on <= 1'b0;
  end else begin
  cfg_flying_mode_on <= reg2dp_flying_mode == 1'h1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_nan_to_zero <= 1'b0;
  end else begin
  cfg_nan_to_zero <= reg2dp_nan_to_zero == 1'h1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_proc_precision <= 1'b0;
  end else begin
  cfg_proc_precision <= reg2dp_proc_precision == 2'h2;
  end
end
assign cfg_nan_to_zero_en = cfg_nan_to_zero & cfg_proc_precision;

NV_NVDLA_SDP_CMUX_pipe_p1 pipe_p1 (
   .nvdla_core_clk    (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)       //|< i
  ,.cacc2sdp_pd       (cacc2sdp_pd[513:0])    //|< i
  ,.cacc2sdp_valid    (cacc2sdp_valid)        //|< i
  ,.cacc_rdy          (cacc_rdy)              //|< w
  ,.cacc2sdp_ready    (cacc2sdp_ready)        //|> o
  ,.cacc_pd           (cacc_pd[513:0])        //|> w
  ,.cacc_vld          (cacc_vld)              //|> w
  );
assign cmux2dp_pvld = cmux_in_en & ((cfg_flying_mode_on) ? cacc_vld : sdp_mrdma2cmux_valid);

assign cacc_rdy             = cmux_in_en &   cfg_flying_mode_on  & cmux2dp_prdy;
assign sdp_mrdma2cmux_ready = cmux_in_en & (!cfg_flying_mode_on) & cmux2dp_prdy;

//===========================================
// Layer Switch
//===========================================
assign cmux_pd   = (cfg_flying_mode_on) ? cacc_pd    : sdp_mrdma2cmux_pd;

// flush NAN to zero

// PKT_UNPACK_WIRE( nvdla_cc2pp_pkg ,  cmux_pd_  ,  cmux_pd  )
assign        cmux_pd_data0[31:0] =     cmux_pd[31:0];
assign        cmux_pd_data1[31:0] =     cmux_pd[63:32];
assign        cmux_pd_data2[31:0] =     cmux_pd[95:64];
assign        cmux_pd_data3[31:0] =     cmux_pd[127:96];
assign        cmux_pd_data4[31:0] =     cmux_pd[159:128];
assign        cmux_pd_data5[31:0] =     cmux_pd[191:160];
assign        cmux_pd_data6[31:0] =     cmux_pd[223:192];
assign        cmux_pd_data7[31:0] =     cmux_pd[255:224];
assign        cmux_pd_data8[31:0] =     cmux_pd[287:256];
assign        cmux_pd_data9[31:0] =     cmux_pd[319:288];
assign        cmux_pd_data10[31:0] =     cmux_pd[351:320];
assign        cmux_pd_data11[31:0] =     cmux_pd[383:352];
assign        cmux_pd_data12[31:0] =     cmux_pd[415:384];
assign        cmux_pd_data13[31:0] =     cmux_pd[447:416];
assign        cmux_pd_data14[31:0] =     cmux_pd[479:448];
assign        cmux_pd_data15[31:0] =     cmux_pd[511:480];
assign         cmux_pd_batch_end  =     cmux_pd[512];
assign         cmux_pd_layer_end  =     cmux_pd[513];
assign cmux_pd_flush_batch_end_NC = cmux_pd_batch_end;
//assign cmux_pd_flush_layer_end = cmux_pd_layer_end;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmux_in_en <= 1'b0;
  end else begin
    if (op_en_load) begin
       cmux_in_en  <= 1'b1;
    end else if (cmux_pd_layer_end && cmux2dp_pvld && cmux2dp_prdy) begin
       cmux_in_en  <= 1'b0;
    end
  end
end

//=======================

assign data_byte0 = cmux_pd_data0;
assign data_byte0_expo = data_byte0[30:23];
assign data_byte0_mant = data_byte0[22:0];
assign is_data_byte0_nan = (data_byte0_expo==8'hff) & (data_byte0_mant!=0);

assign data_byte0_flush = (cfg_nan_to_zero_en & is_data_byte0_nan)? 32'h0 : data_byte0;
assign cmux_pd_flush_data[31:0] = data_byte0_flush;
assign data_byte1 = cmux_pd_data1;
assign data_byte1_expo = data_byte1[30:23];
assign data_byte1_mant = data_byte1[22:0];
assign is_data_byte1_nan = (data_byte1_expo==8'hff) & (data_byte1_mant!=0);

assign data_byte1_flush = (cfg_nan_to_zero_en & is_data_byte1_nan)? 32'h0 : data_byte1;
assign cmux_pd_flush_data[63:32] = data_byte1_flush;
assign data_byte2 = cmux_pd_data2;
assign data_byte2_expo = data_byte2[30:23];
assign data_byte2_mant = data_byte2[22:0];
assign is_data_byte2_nan = (data_byte2_expo==8'hff) & (data_byte2_mant!=0);

assign data_byte2_flush = (cfg_nan_to_zero_en & is_data_byte2_nan)? 32'h0 : data_byte2;
assign cmux_pd_flush_data[95:64] = data_byte2_flush;
assign data_byte3 = cmux_pd_data3;
assign data_byte3_expo = data_byte3[30:23];
assign data_byte3_mant = data_byte3[22:0];
assign is_data_byte3_nan = (data_byte3_expo==8'hff) & (data_byte3_mant!=0);

assign data_byte3_flush = (cfg_nan_to_zero_en & is_data_byte3_nan)? 32'h0 : data_byte3;
assign cmux_pd_flush_data[127:96] = data_byte3_flush;
assign data_byte4 = cmux_pd_data4;
assign data_byte4_expo = data_byte4[30:23];
assign data_byte4_mant = data_byte4[22:0];
assign is_data_byte4_nan = (data_byte4_expo==8'hff) & (data_byte4_mant!=0);

assign data_byte4_flush = (cfg_nan_to_zero_en & is_data_byte4_nan)? 32'h0 : data_byte4;
assign cmux_pd_flush_data[159:128] = data_byte4_flush;
assign data_byte5 = cmux_pd_data5;
assign data_byte5_expo = data_byte5[30:23];
assign data_byte5_mant = data_byte5[22:0];
assign is_data_byte5_nan = (data_byte5_expo==8'hff) & (data_byte5_mant!=0);

assign data_byte5_flush = (cfg_nan_to_zero_en & is_data_byte5_nan)? 32'h0 : data_byte5;
assign cmux_pd_flush_data[191:160] = data_byte5_flush;
assign data_byte6 = cmux_pd_data6;
assign data_byte6_expo = data_byte6[30:23];
assign data_byte6_mant = data_byte6[22:0];
assign is_data_byte6_nan = (data_byte6_expo==8'hff) & (data_byte6_mant!=0);

assign data_byte6_flush = (cfg_nan_to_zero_en & is_data_byte6_nan)? 32'h0 : data_byte6;
assign cmux_pd_flush_data[223:192] = data_byte6_flush;
assign data_byte7 = cmux_pd_data7;
assign data_byte7_expo = data_byte7[30:23];
assign data_byte7_mant = data_byte7[22:0];
assign is_data_byte7_nan = (data_byte7_expo==8'hff) & (data_byte7_mant!=0);

assign data_byte7_flush = (cfg_nan_to_zero_en & is_data_byte7_nan)? 32'h0 : data_byte7;
assign cmux_pd_flush_data[255:224] = data_byte7_flush;
assign data_byte8 = cmux_pd_data8;
assign data_byte8_expo = data_byte8[30:23];
assign data_byte8_mant = data_byte8[22:0];
assign is_data_byte8_nan = (data_byte8_expo==8'hff) & (data_byte8_mant!=0);

assign data_byte8_flush = (cfg_nan_to_zero_en & is_data_byte8_nan)? 32'h0 : data_byte8;
assign cmux_pd_flush_data[287:256] = data_byte8_flush;
assign data_byte9 = cmux_pd_data9;
assign data_byte9_expo = data_byte9[30:23];
assign data_byte9_mant = data_byte9[22:0];
assign is_data_byte9_nan = (data_byte9_expo==8'hff) & (data_byte9_mant!=0);

assign data_byte9_flush = (cfg_nan_to_zero_en & is_data_byte9_nan)? 32'h0 : data_byte9;
assign cmux_pd_flush_data[319:288] = data_byte9_flush;
assign data_byte10 = cmux_pd_data10;
assign data_byte10_expo = data_byte10[30:23];
assign data_byte10_mant = data_byte10[22:0];
assign is_data_byte10_nan = (data_byte10_expo==8'hff) & (data_byte10_mant!=0);

assign data_byte10_flush = (cfg_nan_to_zero_en & is_data_byte10_nan)? 32'h0 : data_byte10;
assign cmux_pd_flush_data[351:320] = data_byte10_flush;
assign data_byte11 = cmux_pd_data11;
assign data_byte11_expo = data_byte11[30:23];
assign data_byte11_mant = data_byte11[22:0];
assign is_data_byte11_nan = (data_byte11_expo==8'hff) & (data_byte11_mant!=0);

assign data_byte11_flush = (cfg_nan_to_zero_en & is_data_byte11_nan)? 32'h0 : data_byte11;
assign cmux_pd_flush_data[383:352] = data_byte11_flush;
assign data_byte12 = cmux_pd_data12;
assign data_byte12_expo = data_byte12[30:23];
assign data_byte12_mant = data_byte12[22:0];
assign is_data_byte12_nan = (data_byte12_expo==8'hff) & (data_byte12_mant!=0);

assign data_byte12_flush = (cfg_nan_to_zero_en & is_data_byte12_nan)? 32'h0 : data_byte12;
assign cmux_pd_flush_data[415:384] = data_byte12_flush;
assign data_byte13 = cmux_pd_data13;
assign data_byte13_expo = data_byte13[30:23];
assign data_byte13_mant = data_byte13[22:0];
assign is_data_byte13_nan = (data_byte13_expo==8'hff) & (data_byte13_mant!=0);

assign data_byte13_flush = (cfg_nan_to_zero_en & is_data_byte13_nan)? 32'h0 : data_byte13;
assign cmux_pd_flush_data[447:416] = data_byte13_flush;
assign data_byte14 = cmux_pd_data14;
assign data_byte14_expo = data_byte14[30:23];
assign data_byte14_mant = data_byte14[22:0];
assign is_data_byte14_nan = (data_byte14_expo==8'hff) & (data_byte14_mant!=0);

assign data_byte14_flush = (cfg_nan_to_zero_en & is_data_byte14_nan)? 32'h0 : data_byte14;
assign cmux_pd_flush_data[479:448] = data_byte14_flush;
assign data_byte15 = cmux_pd_data15;
assign data_byte15_expo = data_byte15[30:23];
assign data_byte15_mant = data_byte15[22:0];
assign is_data_byte15_nan = (data_byte15_expo==8'hff) & (data_byte15_mant!=0);

assign data_byte15_flush = (cfg_nan_to_zero_en & is_data_byte15_nan)? 32'h0 : data_byte15;
assign cmux_pd_flush_data[511:480] = data_byte15_flush;

//assign nan_input_num[::range(5)] = ::replcat_dn(16, " + ", 'is_data_byte${ii}_nan');
//assign nan_input_cen = cmux2dp_pvld & cmux2dp_prdy & (::replcat_dn(16, " | ", 'is_data_byte${ii}_nan'));
//
//assign {nan_input_cnt_add_c,nan_input_cnt_add[::range(32)]} = nan_input_cnt[::range(32)] + nan_input_num;
//assign nan_input_cnt_nxt = nan_input_cnt_add_c ? 32'hffff_ffff : nan_input_cnt_add;
//
//&Always posedge;
//    if (cfg_perf_nan_inf_count_en) begin
//        if (op_en_load) begin
//            nan_input_cnt <0= 0;
//        end else if (nan_input_cen) begin
//            nan_input_cnt <0= nan_input_cnt_nxt;
//        end
//    end
//&End;
//assign dp2reg_status_nan_input_num = nan_input_cnt;
//
//assign inf_input_num[::range(5)] = ::replcat_dn(16, " + ", 'is_data_byte${ii}_inf');
//assign inf_input_cen = cmux2dp_pvld & cmux2dp_prdy & (::replcat_dn(16, " | ", 'is_data_byte${ii}_inf'));
//
//assign {inf_input_cnt_add_c,inf_input_cnt_add[::range(32)]} = inf_input_cnt[::range(32)] + inf_input_num;
//assign inf_input_cnt_nxt = inf_input_cnt_add_c ? 32'hffff_ffff : inf_input_cnt_add;
//
//&Always posedge;
//    if (cfg_perf_nan_inf_count_en) begin
//        if (op_en_load) begin
//            inf_input_cnt <0= 0;
//        end else if (inf_input_cen) begin
//            inf_input_cnt <0= inf_input_cnt_nxt;
//        end
//    end
//&End;
//assign dp2reg_status_inf_input_num = inf_input_cnt;


// PKT_PACK_WIRE(  sdp_cmux2dp  ,  cmux_pd_flush_  ,  cmux2dp_pd  )
assign       cmux2dp_pd[511:0] =     cmux_pd_flush_data[511:0];

NV_NVDLA_SDP_CMUX_pipe_p2 pipe_p2 (
   .nvdla_core_clk    (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)       //|< i
  ,.cmux2dp_pd        (cmux2dp_pd[511:0])     //|< w
  ,.cmux2dp_pvld      (cmux2dp_pvld)          //|< w
  ,.sdp_cmux2dp_ready (sdp_cmux2dp_ready)     //|< i
  ,.cmux2dp_prdy      (cmux2dp_prdy)          //|> w
  ,.sdp_cmux2dp_pd    (sdp_cmux2dp_pd[511:0]) //|> o
  ,.sdp_cmux2dp_valid (sdp_cmux2dp_valid)     //|> o
  );
//assign sdp_cmux2dp_pd = cmux2dp_pd;
//assign sdp_cmux2dp_valid = cmux2dp_pvld;
//assign cmux2dp_prdy = sdp_cmux2dp_ready;

endmodule // NV_NVDLA_SDP_cmux



// **************************************************************************************************************
// Generated by ::pipe -m -bc -os cacc_pd (cacc_vld, cacc_rdy) <= cacc2sdp_pd[513:0] (cacc2sdp_valid, cacc2sdp_ready)
// **************************************************************************************************************
module NV_NVDLA_SDP_CMUX_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cacc2sdp_pd
  ,cacc2sdp_valid
  ,cacc_rdy
  ,cacc2sdp_ready
  ,cacc_pd
  ,cacc_vld
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] cacc2sdp_pd;
input          cacc2sdp_valid;
input          cacc_rdy;
output         cacc2sdp_ready;
output [513:0] cacc_pd;
output         cacc_vld;
reg            cacc2sdp_ready;
reg    [513:0] cacc_pd;
reg            cacc_vld;
reg    [513:0] p1_pipe_data;
reg    [513:0] p1_pipe_rand_data;
reg            p1_pipe_rand_ready;
reg            p1_pipe_rand_valid;
reg            p1_pipe_ready;
reg            p1_pipe_ready_bc;
reg    [513:0] p1_pipe_skid_data;
reg            p1_pipe_skid_ready;
reg            p1_pipe_skid_valid;
reg            p1_pipe_valid;
reg            p1_skid_catch;
reg    [513:0] p1_skid_data;
reg            p1_skid_ready;
reg            p1_skid_ready_flop;
reg            p1_skid_valid;
//## pipe (1) randomizer
`ifndef SYNTHESIS
reg p1_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p1_pipe_rand_active
  or 
     `endif
     cacc2sdp_valid
  or p1_pipe_rand_ready
  or cacc2sdp_pd
  ) begin
  `ifdef SYNTHESIS
  p1_pipe_rand_valid = cacc2sdp_valid;
  cacc2sdp_ready = p1_pipe_rand_ready;
  p1_pipe_rand_data = cacc2sdp_pd[513:0];
  `else
  // VCS coverage off
  p1_pipe_rand_valid = (p1_pipe_rand_active)? 1'b0 : cacc2sdp_valid;
  cacc2sdp_ready = (p1_pipe_rand_active)? 1'b0 : p1_pipe_rand_ready;
  p1_pipe_rand_data = (p1_pipe_rand_active)?  'bx : cacc2sdp_pd[513:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p1_pipe_stall_cycles;
integer p1_pipe_stall_probability;
integer p1_pipe_stall_cycles_min;
integer p1_pipe_stall_cycles_max;
initial begin
  p1_pipe_stall_cycles = 0;
  p1_pipe_stall_probability = 0;
  p1_pipe_stall_cycles_min = 1;
  p1_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_SDP_cmux_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_SDP_cmux_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_SDP_cmux_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_SDP_cmux_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_SDP_cmux_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_cmux_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_cmux_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p1_pipe_rand_enable;
reg p1_pipe_rand_poised;
always @(
  p1_pipe_stall_cycles
  or p1_pipe_stall_probability
  or cacc2sdp_valid
  ) begin
  p1_pipe_rand_active = p1_pipe_stall_cycles != 0;
  p1_pipe_rand_enable = p1_pipe_stall_probability != 0;
  p1_pipe_rand_poised = p1_pipe_rand_enable && !p1_pipe_rand_active && cacc2sdp_valid === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p1_pipe_rand_poised) begin
    if (p1_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p1_pipe_stall_cycles <= prand_inst1(p1_pipe_stall_cycles_min, p1_pipe_stall_cycles_max);
    end
  end else if (p1_pipe_rand_active) begin
    p1_pipe_stall_cycles <= p1_pipe_stall_cycles - 1;
  end else begin
    p1_pipe_stall_cycles <= 0;
  end
  end
end

`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed0;
reg prand_initialized0;
reg prand_no_rollpli0;
`endif
`endif
`endif

function [31:0] prand_inst0;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst0 = min;
`else
`ifdef SYNTHESIS
        prand_inst0 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized0 !== 1'b1) begin
            prand_no_rollpli0 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli0)
                prand_local_seed0 = {$prand_get_seed(0), 16'b0};
            prand_initialized0 = 1'b1;
        end
        if (prand_no_rollpli0) begin
            prand_inst0 = min;
        end else begin
            diff = max - min + 1;
            prand_inst0 = min + prand_local_seed0[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed0 = prand_local_seed0 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst0 = min;
`else
        prand_inst0 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed1;
reg prand_initialized1;
reg prand_no_rollpli1;
`endif
`endif
`endif

function [31:0] prand_inst1;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst1 = min;
`else
`ifdef SYNTHESIS
        prand_inst1 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized1 !== 1'b1) begin
            prand_no_rollpli1 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli1)
                prand_local_seed1 = {$prand_get_seed(1), 16'b0};
            prand_initialized1 = 1'b1;
        end
        if (prand_no_rollpli1) begin
            prand_inst1 = min;
        end else begin
            diff = max - min + 1;
            prand_inst1 = min + prand_local_seed1[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed1 = prand_local_seed1 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst1 = min;
`else
        prand_inst1 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction

`endif
// VCS coverage on
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
  p1_pipe_valid <= (p1_pipe_ready_bc)? p1_pipe_rand_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && p1_pipe_rand_valid)? p1_pipe_rand_data : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  p1_pipe_rand_ready = p1_pipe_ready_bc;
end
//## pipe (1) skid buffer
always @(
  p1_pipe_valid
  or p1_skid_ready_flop
  or p1_pipe_skid_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = p1_pipe_valid && p1_skid_ready_flop && !p1_pipe_skid_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_pipe_skid_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    p1_pipe_ready <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_pipe_skid_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  p1_pipe_ready <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? p1_pipe_data : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or p1_pipe_valid
  or p1_skid_valid
  or p1_pipe_data
  or p1_skid_data
  ) begin
  p1_pipe_skid_valid = (p1_skid_ready_flop)? p1_pipe_valid : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_pipe_skid_data = (p1_skid_ready_flop)? p1_pipe_data : p1_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (1) output
always @(
  p1_pipe_skid_valid
  or cacc_rdy
  or p1_pipe_skid_data
  ) begin
  cacc_vld = p1_pipe_skid_valid;
  p1_pipe_skid_ready = cacc_rdy;
  cacc_pd = p1_pipe_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cacc_vld^cacc_rdy^cacc2sdp_valid^cacc2sdp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (cacc2sdp_valid && !cacc2sdp_ready), (cacc2sdp_valid), (cacc2sdp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_CMUX_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is sdp_cmux2dp_pd (sdp_cmux2dp_valid,sdp_cmux2dp_ready) <= cmux2dp_pd[511:0] (cmux2dp_pvld,cmux2dp_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_CMUX_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cmux2dp_pd
  ,cmux2dp_pvld
  ,sdp_cmux2dp_ready
  ,cmux2dp_prdy
  ,sdp_cmux2dp_pd
  ,sdp_cmux2dp_valid
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [511:0] cmux2dp_pd;
input          cmux2dp_pvld;
input          sdp_cmux2dp_ready;
output         cmux2dp_prdy;
output [511:0] sdp_cmux2dp_pd;
output         sdp_cmux2dp_valid;
reg            cmux2dp_prdy;
reg    [511:0] p2_pipe_data;
reg    [511:0] p2_pipe_rand_data;
reg            p2_pipe_rand_ready;
reg            p2_pipe_rand_valid;
reg            p2_pipe_ready;
reg            p2_pipe_ready_bc;
reg            p2_pipe_valid;
reg            p2_skid_catch;
reg    [511:0] p2_skid_data;
reg    [511:0] p2_skid_pipe_data;
reg            p2_skid_pipe_ready;
reg            p2_skid_pipe_valid;
reg            p2_skid_ready;
reg            p2_skid_ready_flop;
reg            p2_skid_valid;
reg    [511:0] sdp_cmux2dp_pd;
reg            sdp_cmux2dp_valid;
//## pipe (2) randomizer
`ifndef SYNTHESIS
reg p2_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p2_pipe_rand_active
  or 
     `endif
     cmux2dp_pvld
  or p2_pipe_rand_ready
  or cmux2dp_pd
  ) begin
  `ifdef SYNTHESIS
  p2_pipe_rand_valid = cmux2dp_pvld;
  cmux2dp_prdy = p2_pipe_rand_ready;
  p2_pipe_rand_data = cmux2dp_pd[511:0];
  `else
  // VCS coverage off
  p2_pipe_rand_valid = (p2_pipe_rand_active)? 1'b0 : cmux2dp_pvld;
  cmux2dp_prdy = (p2_pipe_rand_active)? 1'b0 : p2_pipe_rand_ready;
  p2_pipe_rand_data = (p2_pipe_rand_active)?  'bx : cmux2dp_pd[511:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p2_pipe_stall_cycles;
integer p2_pipe_stall_probability;
integer p2_pipe_stall_cycles_min;
integer p2_pipe_stall_cycles_max;
initial begin
  p2_pipe_stall_cycles = 0;
  p2_pipe_stall_probability = 0;
  p2_pipe_stall_cycles_min = 1;
  p2_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_SDP_cmux_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_SDP_cmux_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_SDP_cmux_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_SDP_cmux_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_SDP_cmux_pipe_stall_probability" ) ) p2_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_cmux_pipe_stall_cycles_min"  ) ) p2_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_cmux_pipe_stall_cycles_max"  ) ) p2_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p2_pipe_rand_enable;
reg p2_pipe_rand_poised;
always @(
  p2_pipe_stall_cycles
  or p2_pipe_stall_probability
  or cmux2dp_pvld
  ) begin
  p2_pipe_rand_active = p2_pipe_stall_cycles != 0;
  p2_pipe_rand_enable = p2_pipe_stall_probability != 0;
  p2_pipe_rand_poised = p2_pipe_rand_enable && !p2_pipe_rand_active && cmux2dp_pvld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p2_pipe_rand_poised) begin
    if (p2_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p2_pipe_stall_cycles <= prand_inst1(p2_pipe_stall_cycles_min, p2_pipe_stall_cycles_max);
    end
  end else if (p2_pipe_rand_active) begin
    p2_pipe_stall_cycles <= p2_pipe_stall_cycles - 1;
  end else begin
    p2_pipe_stall_cycles <= 0;
  end
  end
end

`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed0;
reg prand_initialized0;
reg prand_no_rollpli0;
`endif
`endif
`endif

function [31:0] prand_inst0;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst0 = min;
`else
`ifdef SYNTHESIS
        prand_inst0 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized0 !== 1'b1) begin
            prand_no_rollpli0 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli0)
                prand_local_seed0 = {$prand_get_seed(0), 16'b0};
            prand_initialized0 = 1'b1;
        end
        if (prand_no_rollpli0) begin
            prand_inst0 = min;
        end else begin
            diff = max - min + 1;
            prand_inst0 = min + prand_local_seed0[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed0 = prand_local_seed0 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst0 = min;
`else
        prand_inst0 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed1;
reg prand_initialized1;
reg prand_no_rollpli1;
`endif
`endif
`endif

function [31:0] prand_inst1;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst1 = min;
`else
`ifdef SYNTHESIS
        prand_inst1 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized1 !== 1'b1) begin
            prand_no_rollpli1 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli1)
                prand_local_seed1 = {$prand_get_seed(1), 16'b0};
            prand_initialized1 = 1'b1;
        end
        if (prand_no_rollpli1) begin
            prand_inst1 = min;
        end else begin
            diff = max - min + 1;
            prand_inst1 = min + prand_local_seed1[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed1 = prand_local_seed1 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst1 = min;
`else
        prand_inst1 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction

`endif
// VCS coverage on
//## pipe (2) skid buffer
always @(
  p2_pipe_rand_valid
  or p2_skid_ready_flop
  or p2_skid_pipe_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = p2_pipe_rand_valid && p2_skid_ready_flop && !p2_skid_pipe_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_skid_pipe_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    p2_pipe_rand_ready <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_skid_pipe_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  p2_pipe_rand_ready <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? p2_pipe_rand_data : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or p2_pipe_rand_valid
  or p2_skid_valid
  or p2_pipe_rand_data
  or p2_skid_data
  ) begin
  p2_skid_pipe_valid = (p2_skid_ready_flop)? p2_pipe_rand_valid : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_skid_pipe_data = (p2_skid_ready_flop)? p2_pipe_rand_data : p2_skid_data;
  // VCS sop_coverage_off end
end
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
  p2_pipe_valid <= (p2_pipe_ready_bc)? p2_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && p2_skid_pipe_valid)? p2_skid_pipe_data : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  p2_skid_pipe_ready = p2_pipe_ready_bc;
end
//## pipe (2) output
always @(
  p2_pipe_valid
  or sdp_cmux2dp_ready
  or p2_pipe_data
  ) begin
  sdp_cmux2dp_valid = p2_pipe_valid;
  p2_pipe_ready = sdp_cmux2dp_ready;
  sdp_cmux2dp_pd = p2_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (sdp_cmux2dp_valid^sdp_cmux2dp_ready^cmux2dp_pvld^cmux2dp_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_4x (nvdla_core_clk, `ASSERT_RESET, (cmux2dp_pvld && !cmux2dp_prdy), (cmux2dp_pvld), (cmux2dp_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_CMUX_pipe_p2


