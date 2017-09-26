// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_MUL_unit.v

module NV_NVDLA_CDP_DP_MUL_unit (
   nvdla_core_clk          //|< i
  ,nvdla_op_gated_clk_int  //|< i
  ,nvdla_core_rstn         //|< i
  ,datin_pd                //|< i
  ,fp16_en                 //|< i
  ,intp2mul_pd_0           //|< i
  ,intp2mul_pd_1           //|< i
  ,mul_unit_rdy            //|< i
  ,mul_vld                 //|< i
  ,nvdla_op_gated_clk_fp16 //|< i
  ,reg2dp_input_data_type  //|< i
  ,mul_rdy                 //|> o
  ,mul_unit_pd             //|> o
  ,mul_unit_vld            //|> o
  );
input         nvdla_core_clk;
input         nvdla_op_gated_clk_int;
input         nvdla_core_rstn;
input  [17:0] datin_pd;
input         fp16_en;
input  [16:0] intp2mul_pd_0;
input  [16:0] intp2mul_pd_1;
input         mul_unit_rdy;
input         mul_vld;
input         nvdla_op_gated_clk_fp16;
input   [1:0] reg2dp_input_data_type;
output        mul_rdy;
output [49:0] mul_unit_pd;
output        mul_unit_vld;
reg           fp16_en_sync;
reg           int16_en_use;
reg           int8_en_f;
reg    [32:0] mul_int_lsb;
reg    [24:0] mul_int_msb;
reg           mul_int_vld_d0;
wire   [16:0] datin_pd_lsb;
wire          fp_mul_a_rdy;
wire          fp_mul_a_vld;
wire          fp_mul_b_rdy;
wire          fp_mul_b_vld;
wire   [16:0] fp_mul_pd;
wire          fp_mul_rdy;
wire          fp_mul_vld;
wire   [16:0] intp2mul_msb;
wire          mul_fp_rdy;
wire          mul_fp_vld;
wire   [24:0] mul_int8_msb;
wire          mul_int_load;
wire          mul_int_rdy;
wire          mul_int_rdy_d0;
wire          mul_int_vld;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    ///////////////////////////////////////////
//interlock two path data 
//assign intp2mul_prdy = mul_rdy & datin_pvld;
//assign datin_prdy = mul_rdy & intp2mul_pvld;
//assign mul_vld = datin_pvld & intp2mul_pvld;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int16_en_use <= 1'b0;
  end else begin
  int16_en_use <= reg2dp_input_data_type[1:0] == 1;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    fp16_en_sync <= 1'b0;
  end else begin
  fp16_en_sync <= fp16_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int8_en_f <= 1'b0;
  end else begin
  int8_en_f <= reg2dp_input_data_type[1:0] == 0;
  end
end
assign mul_rdy = fp16_en_sync ? mul_fp_rdy : mul_int_rdy;
//////////////////////////////////////////////////////////////////////////
//mul for int mode
//////////////////////////////////////////////////////////////////////////
//slcg
/////

assign mul_int_vld = fp16_en_sync ? 1'b0 : mul_vld;
assign mul_int_rdy = ~mul_int_vld_d0 | mul_int_rdy_d0;
assign mul_int_load = mul_int_vld & mul_int_rdy;

assign datin_pd_lsb = int8_en_f ? {{8{datin_pd[8]}},datin_pd[8:0]} : (int16_en_use ? datin_pd[16:0] : 17'd0);
assign intp2mul_msb = intp2mul_pd_1[16:0];

assign mul_int8_msb[24:0] = $signed(intp2mul_msb[15:0]) * $signed(datin_pd[17:9]);
always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mul_int_lsb[32:0] <= {33{1'b0}};
    mul_int_msb[24:0] <= {25{1'b0}};
  end else begin
    if(mul_int_load) begin
        mul_int_lsb[32:0] <= $signed(intp2mul_pd_0[15:0]) * $signed(datin_pd_lsb);
        //mul_int_msb[24:0] <0= int8_en ? ($signed(intp2mul_msb[15:0]) * $signed(datin_pd[17:9])) : 25'd0;
        mul_int_msb[24:0] <= int8_en_f ? mul_int8_msb : 25'd0;
    end
  end
end

always @(posedge nvdla_op_gated_clk_int or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mul_int_vld_d0 <= 1'b0;
  end else begin
    if(mul_int_vld)
        mul_int_vld_d0 <= 1'b1;
    else if(mul_int_rdy_d0)
        mul_int_vld_d0 <= 1'b0;
  end
end

//slcg
/////
//////////////////////////////////////////////////////////////////////////
//mul for fp16 mode
//////////////////////////////////////////////////////////////////////////

assign mul_fp_vld = fp16_en_sync ? mul_vld : 1'b0;
assign mul_fp_rdy = fp_mul_a_rdy & fp_mul_b_rdy;
///////
assign fp_mul_a_vld = mul_fp_vld & fp_mul_b_rdy;
assign fp_mul_b_vld = mul_fp_vld & fp_mul_a_rdy;

HLS_fp17_mul u_fp_mul (
   .nvdla_core_clk  (nvdla_op_gated_clk_fp16) //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)         //|< i
  ,.chn_a_rsc_z     (datin_pd[16:0])          //|< i
  ,.chn_a_rsc_vz    (fp_mul_a_vld)            //|< w
  ,.chn_a_rsc_lz    (fp_mul_a_rdy)            //|> w
  ,.chn_b_rsc_z     (intp2mul_pd_0[16:0])     //|< i
  ,.chn_b_rsc_vz    (fp_mul_b_vld)            //|< w
  ,.chn_b_rsc_lz    (fp_mul_b_rdy)            //|> w
  ,.chn_o_rsc_z     (fp_mul_pd[16:0])         //|> w
  ,.chn_o_rsc_vz    (fp_mul_rdy)              //|< w
  ,.chn_o_rsc_lz    (fp_mul_vld)              //|> w
  );
//&Connect chn_a_rsc_z     intp2mul_pd_0[16:0];
//&Connect chn_b_rsc_z     datin_pd[16:0];

/////////////////////////
//output select

assign fp_mul_rdy = fp16_en_sync ? mul_unit_rdy : 1'b1;
assign mul_int_rdy_d0 = fp16_en_sync ? 1'b1 : mul_unit_rdy;

assign mul_unit_vld = fp16_en_sync ? fp_mul_vld : mul_int_vld_d0;
assign mul_unit_pd  = fp16_en_sync ? {{33{fp_mul_pd[16]}},fp_mul_pd} : (int16_en_use ? {{17{mul_int_lsb[32]}},mul_int_lsb[32:0]} : {mul_int_msb[24:0],mul_int_lsb[24:0]});

///////////////////////////////////////////
endmodule // NV_NVDLA_CDP_DP_MUL_unit


