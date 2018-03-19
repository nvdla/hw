// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_HLS_Y_int_idx.v

module NV_NVDLA_SDP_HLS_Y_int_idx (
   cfg_lut_hybrid_priority //|< i
  ,cfg_lut_le_function     //|< i
  ,cfg_lut_le_index_offset //|< i
  ,cfg_lut_le_index_select //|< i
  ,cfg_lut_le_start        //|< i
  ,cfg_lut_lo_index_select //|< i
  ,cfg_lut_lo_start        //|< i
  ,cfg_lut_oflow_priority  //|< i
  ,cfg_lut_uflow_priority  //|< i
  ,lut_data_in             //|< i
  ,lut_in_pvld             //|< i
  ,lut_out_prdy            //|< i
  ,nvdla_core_clk          //|< i
  ,nvdla_core_rstn         //|< i
  ,lut_in_prdy             //|> o
  ,lut_out_frac            //|> o
  ,lut_out_le_hit          //|> o
  ,lut_out_lo_hit          //|> o
  ,lut_out_oflow           //|> o
  ,lut_out_pvld            //|> o
  ,lut_out_ram_addr        //|> o
  ,lut_out_ram_sel         //|> o
  ,lut_out_uflow           //|> o
  ,lut_out_x               //|> o
  );

input         cfg_lut_hybrid_priority;
input         cfg_lut_le_function;
input   [7:0] cfg_lut_le_index_offset;
input   [7:0] cfg_lut_le_index_select;
input  [31:0] cfg_lut_le_start;
input   [7:0] cfg_lut_lo_index_select;
input  [31:0] cfg_lut_lo_start;
input         cfg_lut_oflow_priority;
input         cfg_lut_uflow_priority;
input  [31:0] lut_data_in;
input         lut_in_pvld;
input         lut_out_prdy;
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        lut_in_prdy;
output [34:0] lut_out_frac;
output        lut_out_le_hit;
output        lut_out_lo_hit;
output        lut_out_oflow;
output        lut_out_pvld;
output  [8:0] lut_out_ram_addr;
output        lut_out_ram_sel;
output        lut_out_uflow;
output [31:0] lut_out_x;

/*
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         cfg_lut_le_function;
input         cfg_lut_hybrid_priority;
input         cfg_lut_oflow_priority;
input         cfg_lut_uflow_priority;

input         lut_in_pvld;
output        lut_in_prdy;
output        lut_out_pvld;
input         lut_out_prdy;

input   [LUT_IDX_REG_WIDTH-1:0]  cfg_lut_le_index_select;
input   [LUT_IDX_REG_WIDTH-1:0]  cfg_lut_lo_index_select;
input   [LUT_IDX_REG_WIDTH-1:0]  cfg_lut_le_index_offset;
input   [LUT_REG_WIDTH-1:0]      cfg_lut_le_start;
input   [LUT_REG_WIDTH-1:0]      cfg_lut_lo_start;
input   [LUT_IN_WIDTH-1:0]       lut_data_in;

output  [LUT_IN_WIDTH-1:0]       lut_out_x;
output  [LUT_FRAC_WIDTH-1:0]     lut_out_frac;
output  [LUT_ADDR_WIDTH-1:0]     lut_out_ram_addr;
output                           lut_out_ram_sel;
output                           lut_out_le_hit;
output                           lut_out_lo_hit;
output                           lut_out_uflow;
output                           lut_out_oflow;
*/

reg    [34:0] lut_final_frac;
reg           lut_final_oflow;
reg     [8:0] lut_final_ram_addr;
reg           lut_final_ram_sel;
reg           lut_final_uflow;
wire    [7:0] le_expn_cfg_offset;
wire   [31:0] le_expn_cfg_start;
wire   [31:0] le_expn_data_in;
wire   [34:0] le_expn_frac;
wire          le_expn_in_prdy;
wire          le_expn_in_pvld;
wire    [8:0] le_expn_index;
wire          le_expn_oflow;
wire          le_expn_out_prdy;
wire          le_expn_out_pvld;
wire          le_expn_uflow;
wire   [34:0] le_frac;
wire          le_hit;
wire    [8:0] le_index;
wire    [7:0] le_line_cfg_sel;
wire   [31:0] le_line_cfg_start;
wire   [31:0] le_line_data_in;
wire   [34:0] le_line_frac;
wire          le_line_in_prdy;
wire          le_line_in_pvld;
wire    [8:0] le_line_index;
wire          le_line_oflow;
wire          le_line_out_prdy;
wire          le_line_out_pvld;
wire          le_line_uflow;
wire          le_miss;
wire          le_oflow;
wire          le_uflow;
wire   [34:0] lo_frac;
wire          lo_hit;
wire    [8:0] lo_index;
wire   [34:0] lo_line_frac;
wire          lo_line_in_prdy;
wire    [8:0] lo_line_index;
wire          lo_line_oflow;
wire          lo_line_out_pvld;
wire          lo_line_uflow;
wire          lo_miss;
wire          lo_oflow;
wire          lo_uflow;
wire   [80:0] lut_final_pd;
wire          lut_final_prdy;
wire          lut_final_pvld;
wire   [31:0] lut_final_x;
wire          lut_in_xrdy;
wire   [80:0] lut_out_pd;
wire          lut_pipe2_prdy;
wire          lut_pipe2_pvld;
wire   [31:0] lut_pipe2_x;
wire          lut_pipe3_pvld;
wire          lut_pipe_prdy;
wire          lut_pipe_pvld;
wire   [31:0] lut_pipe_x;


// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
//The same three stage pipe with lut_expn and lut_line
NV_NVDLA_SDP_HLS_Y_INT_IDX_pipe_p1 pipe_p1 (
   .nvdla_core_clk  (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)              //|< i
  ,.lut_data_in     (lut_data_in[31:0])            //|< i
  ,.lut_in_pvld     (lut_in_pvld)                  //|< i
  ,.lut_pipe_prdy   (lut_pipe_prdy)                //|< w
  ,.lut_in_xrdy     (lut_in_xrdy)                  //|> w *
  ,.lut_pipe_pvld   (lut_pipe_pvld)                //|> w
  ,.lut_pipe_x      (lut_pipe_x[31:0])             //|> w
  );
NV_NVDLA_SDP_HLS_Y_INT_IDX_pipe_p2 pipe_p2 (
   .nvdla_core_clk  (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)              //|< i
  ,.lut_pipe2_prdy  (lut_pipe2_prdy)               //|< w
  ,.lut_pipe_pvld   (lut_pipe_pvld)                //|< w
  ,.lut_pipe_x      (lut_pipe_x[31:0])             //|< w
  ,.lut_pipe2_pvld  (lut_pipe2_pvld)               //|> w
  ,.lut_pipe2_x     (lut_pipe2_x[31:0])            //|> w
  ,.lut_pipe_prdy   (lut_pipe_prdy)                //|> w
  );
NV_NVDLA_SDP_HLS_Y_INT_IDX_pipe_p3 pipe_p3 (
   .nvdla_core_clk  (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)              //|< i
  ,.lut_final_prdy  (lut_final_prdy)               //|< w
  ,.lut_pipe2_pvld  (lut_pipe2_pvld)               //|< w
  ,.lut_pipe2_x     (lut_pipe2_x[31:0])            //|< w
  ,.lut_final_x     (lut_final_x[31:0])            //|> w
  ,.lut_pipe2_prdy  (lut_pipe2_prdy)               //|> w
  ,.lut_pipe3_pvld  (lut_pipe3_pvld)               //|> w *
  );


NV_NVDLA_SDP_HLS_lut_expn #(.LUT_DEPTH(65 )) lut_le_expn (
   .cfg_lut_offset  (le_expn_cfg_offset[7:0])      //|< w
  ,.cfg_lut_start   (le_expn_cfg_start[31:0])      //|< w
  ,.idx_data_in     (le_expn_data_in[31:0])        //|< w
  ,.idx_in_pvld     (le_expn_in_pvld)              //|< w
  ,.idx_out_prdy    (le_expn_out_prdy)             //|< w
  ,.nvdla_core_clk  (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)              //|< i
  ,.idx_in_prdy     (le_expn_in_prdy)              //|> w
  ,.idx_out_pvld    (le_expn_out_pvld)             //|> w
  ,.lut_frac_out    (le_expn_frac[34:0])           //|> w
  ,.lut_index_out   (le_expn_index[8:0])           //|> w
  ,.lut_oflow_out   (le_expn_oflow)                //|> w
  ,.lut_uflow_out   (le_expn_uflow)                //|> w
  );

NV_NVDLA_SDP_HLS_lut_line #(.LUT_DEPTH(65 )) lut_le_line (
   .cfg_lut_sel     (le_line_cfg_sel[7:0])         //|< w
  ,.cfg_lut_start   (le_line_cfg_start[31:0])      //|< w
  ,.idx_data_in     (le_line_data_in[31:0])        //|< w
  ,.idx_in_pvld     (le_line_in_pvld)              //|< w
  ,.idx_out_prdy    (le_line_out_prdy)             //|< w
  ,.nvdla_core_clk  (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)              //|< i
  ,.idx_in_prdy     (le_line_in_prdy)              //|> w
  ,.idx_out_pvld    (le_line_out_pvld)             //|> w
  ,.lut_frac_out    (le_line_frac[34:0])           //|> w
  ,.lut_index_out   (le_line_index[8:0])           //|> w
  ,.lut_oflow_out   (le_line_oflow)                //|> w
  ,.lut_uflow_out   (le_line_uflow)                //|> w
  );

NV_NVDLA_SDP_HLS_lut_line #(.LUT_DEPTH(257 )) lut_lo_line (
   .cfg_lut_sel     (cfg_lut_lo_index_select[7:0]) //|< i
  ,.cfg_lut_start   (cfg_lut_lo_start[31:0])       //|< i
  ,.idx_data_in     (lut_data_in[31:0])            //|< i
  ,.idx_in_pvld     (lut_in_pvld)                  //|< i
  ,.idx_out_prdy    (lut_final_prdy)               //|< w
  ,.nvdla_core_clk  (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)              //|< i
  ,.idx_in_prdy     (lo_line_in_prdy)              //|> w
  ,.idx_out_pvld    (lo_line_out_pvld)             //|> w
  ,.lut_frac_out    (lo_line_frac[34:0])           //|> w
  ,.lut_index_out   (lo_line_index[8:0])           //|> w
  ,.lut_oflow_out   (lo_line_oflow)                //|> w
  ,.lut_uflow_out   (lo_line_uflow)                //|> w
  );

assign  le_expn_in_pvld  = (cfg_lut_le_function == 0 ) ? lut_in_pvld : 1'b0;
assign  le_line_in_pvld  = (cfg_lut_le_function != 0 ) ? lut_in_pvld : 1'b0;

assign  le_expn_out_prdy = (cfg_lut_le_function == 0 ) ? lut_final_prdy : 1'b1;
assign  le_line_out_prdy = (cfg_lut_le_function != 0 ) ? lut_final_prdy : 1'b1;

assign  le_expn_data_in[31:0]         = (cfg_lut_le_function == 0 ) ? lut_data_in[31:0] : {32  {1'b0}};
assign  le_expn_cfg_start[31:0]      = (cfg_lut_le_function == 0 ) ? cfg_lut_le_start[31:0] : {32 {1'b0}};
assign  le_expn_cfg_offset[7:0] = (cfg_lut_le_function == 0 ) ? cfg_lut_le_index_offset[7:0] : {8 {1'b0}};

assign  le_line_data_in[31:0]      = (cfg_lut_le_function != 0 ) ? lut_data_in[31:0] : {32  {1'b0}};
assign  le_line_cfg_start[31:0]   = (cfg_lut_le_function != 0 ) ? cfg_lut_le_start[31:0] : {32 {1'b0}};
assign  le_line_cfg_sel[7:0] = (cfg_lut_le_function != 0 ) ? cfg_lut_le_index_select[7:0] : {8 {1'b0}};

assign  lut_in_prdy    = ((cfg_lut_le_function == 0 ) ? le_expn_in_prdy  : le_line_in_prdy ) & lo_line_in_prdy;
assign  lut_final_pvld = ((cfg_lut_le_function == 0 ) ? le_expn_out_pvld : le_line_out_pvld) & lo_line_out_pvld;

assign  le_oflow = (cfg_lut_le_function == 0 ) ? le_expn_oflow : le_line_oflow; 
assign  le_uflow = (cfg_lut_le_function == 0 ) ? le_expn_uflow : le_line_uflow; 

assign  le_index[8:0] = (cfg_lut_le_function == 0 ) ? le_expn_index[8:0] : le_line_index[8:0]; 
assign  le_frac[34:0] = (cfg_lut_le_function == 0 ) ? le_expn_frac[34:0] : le_line_frac[34:0]; 

assign  lo_oflow = lo_line_oflow; 
assign  lo_uflow = lo_line_uflow; 
assign  lo_index[8:0] = lo_line_index[8:0]; 
assign  lo_frac[34:0] = lo_line_frac[34:0]; 

//hit miss
assign  le_miss = (le_uflow | le_oflow);
assign  le_hit = !le_miss;
assign  lo_miss = (lo_uflow | lo_oflow);
assign  lo_hit = !lo_miss;
        

always @(
  le_uflow
  or lo_uflow
  or cfg_lut_uflow_priority
  or lo_index
  or le_index
  or lo_frac
  or le_frac
  or le_oflow
  or lo_oflow
  or cfg_lut_oflow_priority
  or le_hit
  or lo_hit
  or cfg_lut_hybrid_priority
  or le_miss
  or lo_miss
  ) begin
   if (le_uflow & lo_uflow) begin
        lut_final_uflow   = cfg_lut_uflow_priority ? lo_uflow  : le_uflow;
        lut_final_oflow   = 0;
        lut_final_ram_sel = cfg_lut_uflow_priority ? 1  : 0 ;
        lut_final_ram_addr= cfg_lut_uflow_priority ? lo_index  : le_index;
        lut_final_frac    = cfg_lut_uflow_priority ? lo_frac   : le_frac;
    end 
    else if (le_oflow & lo_oflow) begin
        lut_final_uflow   = 0;
        lut_final_oflow   = cfg_lut_oflow_priority ? lo_oflow  : le_oflow;
        lut_final_ram_sel = cfg_lut_oflow_priority ? 1  : 0 ;
        lut_final_ram_addr= cfg_lut_oflow_priority ? lo_index  : le_index;
        lut_final_frac    = cfg_lut_oflow_priority ? lo_frac   : le_frac;
    end 
    else if (le_hit & lo_hit) begin
        lut_final_ram_addr= cfg_lut_hybrid_priority ? lo_index : le_index;
        lut_final_frac    = cfg_lut_hybrid_priority ? lo_frac  : le_frac;
        lut_final_ram_sel = cfg_lut_hybrid_priority ? 1 : 0 ;
        lut_final_uflow   = 0;
        lut_final_oflow   = 0;
    end 
    else if (le_miss & lo_miss) begin
        lut_final_ram_addr= cfg_lut_hybrid_priority ? lo_index : le_index;
        lut_final_frac    = cfg_lut_hybrid_priority ? lo_frac  : le_frac;
        lut_final_ram_sel = cfg_lut_hybrid_priority ? 1 : 0 ;
        lut_final_uflow   = cfg_lut_hybrid_priority ? lo_uflow : le_uflow;
        lut_final_oflow   = cfg_lut_hybrid_priority ? lo_oflow : le_oflow;
    end 
    else if (le_hit) begin
        lut_final_ram_addr= le_index;
        lut_final_frac    = le_frac;
        lut_final_ram_sel = 0 ;
        lut_final_uflow   = 0;
        lut_final_oflow   = 0;
    end 
    else begin // if (lo_hit) begin
        lut_final_ram_addr= lo_index;
        lut_final_frac    = lo_frac;
        lut_final_ram_sel = 1 ;
        lut_final_uflow   = 0;
        lut_final_oflow   = 0;
    end
end


assign lut_final_pd = {lo_hit,le_hit,lut_final_oflow,lut_final_uflow,lut_final_frac[34:0],lut_final_ram_addr[8:0],lut_final_ram_sel,lut_final_x[31:0]};
assign {lut_out_lo_hit,lut_out_le_hit,lut_out_oflow,lut_out_uflow,lut_out_frac[34:0],lut_out_ram_addr[8:0],lut_out_ram_sel,lut_out_x[31:0]} = lut_out_pd;

NV_NVDLA_SDP_HLS_Y_INT_IDX_pipe_p4 pipe_p4 (
   .nvdla_core_clk  (nvdla_core_clk)               //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)              //|< i
  ,.lut_final_pd    (lut_final_pd[80:0])           //|< w
  ,.lut_final_pvld  (lut_final_pvld)               //|< w
  ,.lut_out_prdy    (lut_out_prdy)                 //|< i
  ,.lut_final_prdy  (lut_final_prdy)               //|> w
  ,.lut_out_pd      (lut_out_pd[80:0])             //|> w
  ,.lut_out_pvld    (lut_out_pvld)                 //|> o
  );


endmodule // NV_NVDLA_SDP_HLS_Y_int_idx



// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is lut_pipe_x[31:0]  (lut_pipe_pvld,lut_pipe_prdy)   <= lut_data_in[31:0] (lut_in_pvld,lut_in_xrdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_Y_INT_IDX_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,lut_data_in
  ,lut_in_pvld
  ,lut_pipe_prdy
  ,lut_in_xrdy
  ,lut_pipe_pvld
  ,lut_pipe_x
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [31:0] lut_data_in;
input         lut_in_pvld;
input         lut_pipe_prdy;
output        lut_in_xrdy;
output        lut_pipe_pvld;
output [31:0] lut_pipe_x;
reg           lut_in_xrdy;
reg           lut_pipe_pvld;
reg    [31:0] lut_pipe_x;
reg    [31:0] p1_pipe_data;
reg           p1_pipe_ready;
reg           p1_pipe_ready_bc;
reg           p1_pipe_valid;
reg           p1_skid_catch;
reg    [31:0] p1_skid_data;
reg    [31:0] p1_skid_pipe_data;
reg           p1_skid_pipe_ready;
reg           p1_skid_pipe_valid;
reg           p1_skid_ready;
reg           p1_skid_ready_flop;
reg           p1_skid_valid;
//## pipe (1) skid buffer
always @(
  lut_in_pvld
  or p1_skid_ready_flop
  or p1_skid_pipe_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = lut_in_pvld && p1_skid_ready_flop && !p1_skid_pipe_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_skid_pipe_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    lut_in_xrdy <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_skid_pipe_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  lut_in_xrdy <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? lut_data_in[31:0] : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or lut_in_pvld
  or p1_skid_valid
  or lut_data_in
  or p1_skid_data
  ) begin
  p1_skid_pipe_valid = (p1_skid_ready_flop)? lut_in_pvld : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_skid_pipe_data = (p1_skid_ready_flop)? lut_data_in[31:0] : p1_skid_data;
  // VCS sop_coverage_off end
end
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
  p1_pipe_valid <= (p1_pipe_ready_bc)? p1_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && p1_skid_pipe_valid)? p1_skid_pipe_data : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  p1_skid_pipe_ready = p1_pipe_ready_bc;
end
//## pipe (1) output
always @(
  p1_pipe_valid
  or lut_pipe_prdy
  or p1_pipe_data
  ) begin
  lut_pipe_pvld = p1_pipe_valid;
  p1_pipe_ready = lut_pipe_prdy;
  lut_pipe_x[31:0] = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (lut_pipe_pvld^lut_pipe_prdy^lut_in_pvld^lut_in_xrdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (lut_in_pvld && !lut_in_xrdy), (lut_in_pvld), (lut_in_xrdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_Y_INT_IDX_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is lut_pipe2_x[31:0] (lut_pipe2_pvld,lut_pipe2_prdy) <= lut_pipe_x[31:0]  (lut_pipe_pvld,lut_pipe_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_Y_INT_IDX_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,lut_pipe2_prdy
  ,lut_pipe_pvld
  ,lut_pipe_x
  ,lut_pipe2_pvld
  ,lut_pipe2_x
  ,lut_pipe_prdy
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         lut_pipe2_prdy;
input         lut_pipe_pvld;
input  [31:0] lut_pipe_x;
output        lut_pipe2_pvld;
output [31:0] lut_pipe2_x;
output        lut_pipe_prdy;
reg           lut_pipe2_pvld;
reg    [31:0] lut_pipe2_x;
reg           lut_pipe_prdy;
reg    [31:0] p2_pipe_data;
reg           p2_pipe_ready;
reg           p2_pipe_ready_bc;
reg           p2_pipe_valid;
reg           p2_skid_catch;
reg    [31:0] p2_skid_data;
reg    [31:0] p2_skid_pipe_data;
reg           p2_skid_pipe_ready;
reg           p2_skid_pipe_valid;
reg           p2_skid_ready;
reg           p2_skid_ready_flop;
reg           p2_skid_valid;
//## pipe (2) skid buffer
always @(
  lut_pipe_pvld
  or p2_skid_ready_flop
  or p2_skid_pipe_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = lut_pipe_pvld && p2_skid_ready_flop && !p2_skid_pipe_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_skid_pipe_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    lut_pipe_prdy <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_skid_pipe_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  lut_pipe_prdy <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? lut_pipe_x[31:0] : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or lut_pipe_pvld
  or p2_skid_valid
  or lut_pipe_x
  or p2_skid_data
  ) begin
  p2_skid_pipe_valid = (p2_skid_ready_flop)? lut_pipe_pvld : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_skid_pipe_data = (p2_skid_ready_flop)? lut_pipe_x[31:0] : p2_skid_data;
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
  or lut_pipe2_prdy
  or p2_pipe_data
  ) begin
  lut_pipe2_pvld = p2_pipe_valid;
  p2_pipe_ready = lut_pipe2_prdy;
  lut_pipe2_x[31:0] = p2_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (lut_pipe2_pvld^lut_pipe2_prdy^lut_pipe_pvld^lut_pipe_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_4x (nvdla_core_clk, `ASSERT_RESET, (lut_pipe_pvld && !lut_pipe_prdy), (lut_pipe_pvld), (lut_pipe_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_Y_INT_IDX_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is lut_final_x[31:0] (lut_pipe3_pvld,lut_final_prdy) <= lut_pipe2_x[31:0] (lut_pipe2_pvld,lut_pipe2_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_Y_INT_IDX_pipe_p3 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,lut_final_prdy
  ,lut_pipe2_pvld
  ,lut_pipe2_x
  ,lut_final_x
  ,lut_pipe2_prdy
  ,lut_pipe3_pvld
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         lut_final_prdy;
input         lut_pipe2_pvld;
input  [31:0] lut_pipe2_x;
output [31:0] lut_final_x;
output        lut_pipe2_prdy;
output        lut_pipe3_pvld;
reg    [31:0] lut_final_x;
reg           lut_pipe2_prdy;
reg           lut_pipe3_pvld;
reg    [31:0] p3_pipe_data;
reg           p3_pipe_ready;
reg           p3_pipe_ready_bc;
reg           p3_pipe_valid;
reg           p3_skid_catch;
reg    [31:0] p3_skid_data;
reg    [31:0] p3_skid_pipe_data;
reg           p3_skid_pipe_ready;
reg           p3_skid_pipe_valid;
reg           p3_skid_ready;
reg           p3_skid_ready_flop;
reg           p3_skid_valid;
//## pipe (3) skid buffer
always @(
  lut_pipe2_pvld
  or p3_skid_ready_flop
  or p3_skid_pipe_ready
  or p3_skid_valid
  ) begin
  p3_skid_catch = lut_pipe2_pvld && p3_skid_ready_flop && !p3_skid_pipe_ready;  
  p3_skid_ready = (p3_skid_valid)? p3_skid_pipe_ready : !p3_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_skid_valid <= 1'b0;
    p3_skid_ready_flop <= 1'b1;
    lut_pipe2_prdy <= 1'b1;
  end else begin
  p3_skid_valid <= (p3_skid_valid)? !p3_skid_pipe_ready : p3_skid_catch;
  p3_skid_ready_flop <= p3_skid_ready;
  lut_pipe2_prdy <= p3_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_skid_data <= (p3_skid_catch)? lut_pipe2_x[31:0] : p3_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p3_skid_ready_flop
  or lut_pipe2_pvld
  or p3_skid_valid
  or lut_pipe2_x
  or p3_skid_data
  ) begin
  p3_skid_pipe_valid = (p3_skid_ready_flop)? lut_pipe2_pvld : p3_skid_valid; 
  // VCS sop_coverage_off start
  p3_skid_pipe_data = (p3_skid_ready_flop)? lut_pipe2_x[31:0] : p3_skid_data;
  // VCS sop_coverage_off end
end
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
  p3_pipe_valid <= (p3_pipe_ready_bc)? p3_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_pipe_data <= (p3_pipe_ready_bc && p3_skid_pipe_valid)? p3_skid_pipe_data : p3_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p3_pipe_ready_bc
  ) begin
  p3_skid_pipe_ready = p3_pipe_ready_bc;
end
//## pipe (3) output
always @(
  p3_pipe_valid
  or lut_final_prdy
  or p3_pipe_data
  ) begin
  lut_pipe3_pvld = p3_pipe_valid;
  p3_pipe_ready = lut_final_prdy;
  lut_final_x[31:0] = p3_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (lut_pipe3_pvld^lut_final_prdy^lut_pipe2_pvld^lut_pipe2_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_6x (nvdla_core_clk, `ASSERT_RESET, (lut_pipe2_pvld && !lut_pipe2_prdy), (lut_pipe2_pvld), (lut_pipe2_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_Y_INT_IDX_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is lut_out_pd[80:0] (lut_out_pvld,lut_out_prdy) <= lut_final_pd[80:0] (lut_final_pvld,lut_final_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_Y_INT_IDX_pipe_p4 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,lut_final_pd
  ,lut_final_pvld
  ,lut_out_prdy
  ,lut_final_prdy
  ,lut_out_pd
  ,lut_out_pvld
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [80:0] lut_final_pd;
input         lut_final_pvld;
input         lut_out_prdy;
output        lut_final_prdy;
output [80:0] lut_out_pd;
output        lut_out_pvld;
reg           lut_final_prdy;
reg    [80:0] lut_out_pd;
reg           lut_out_pvld;
reg    [80:0] p4_pipe_data;
reg           p4_pipe_ready;
reg           p4_pipe_ready_bc;
reg           p4_pipe_valid;
reg           p4_skid_catch;
reg    [80:0] p4_skid_data;
reg    [80:0] p4_skid_pipe_data;
reg           p4_skid_pipe_ready;
reg           p4_skid_pipe_valid;
reg           p4_skid_ready;
reg           p4_skid_ready_flop;
reg           p4_skid_valid;
//## pipe (4) skid buffer
always @(
  lut_final_pvld
  or p4_skid_ready_flop
  or p4_skid_pipe_ready
  or p4_skid_valid
  ) begin
  p4_skid_catch = lut_final_pvld && p4_skid_ready_flop && !p4_skid_pipe_ready;  
  p4_skid_ready = (p4_skid_valid)? p4_skid_pipe_ready : !p4_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_skid_valid <= 1'b0;
    p4_skid_ready_flop <= 1'b1;
    lut_final_prdy <= 1'b1;
  end else begin
  p4_skid_valid <= (p4_skid_valid)? !p4_skid_pipe_ready : p4_skid_catch;
  p4_skid_ready_flop <= p4_skid_ready;
  lut_final_prdy <= p4_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_skid_data <= (p4_skid_catch)? lut_final_pd[80:0] : p4_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p4_skid_ready_flop
  or lut_final_pvld
  or p4_skid_valid
  or lut_final_pd
  or p4_skid_data
  ) begin
  p4_skid_pipe_valid = (p4_skid_ready_flop)? lut_final_pvld : p4_skid_valid; 
  // VCS sop_coverage_off start
  p4_skid_pipe_data = (p4_skid_ready_flop)? lut_final_pd[80:0] : p4_skid_data;
  // VCS sop_coverage_off end
end
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
  p4_pipe_valid <= (p4_pipe_ready_bc)? p4_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_pipe_data <= (p4_pipe_ready_bc && p4_skid_pipe_valid)? p4_skid_pipe_data : p4_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p4_pipe_ready_bc
  ) begin
  p4_skid_pipe_ready = p4_pipe_ready_bc;
end
//## pipe (4) output
always @(
  p4_pipe_valid
  or lut_out_prdy
  or p4_pipe_data
  ) begin
  lut_out_pvld = p4_pipe_valid;
  p4_pipe_ready = lut_out_prdy;
  lut_out_pd[80:0] = p4_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (lut_out_pvld^lut_out_prdy^lut_final_pvld^lut_final_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_8x (nvdla_core_clk, `ASSERT_RESET, (lut_final_pvld && !lut_final_prdy), (lut_final_pvld), (lut_final_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_HLS_Y_INT_IDX_pipe_p4



