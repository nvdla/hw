// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_lut.v

module NV_NVDLA_CDP_DP_lut (
   nvdla_core_clk             //|< i
  ,nvdla_core_clk_orig        //|< i
  ,nvdla_core_rstn            //|< i
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         ,dp2lut_X_entry_${m}
//:         ,dp2lut_Xinfo_${m}
//:         ,dp2lut_Y_entry_${m}
//:         ,dp2lut_Yinfo_${m}
//:     );
//: }
  ,dp2lut_pvld                //|< i
  ,lut2intp_prdy              //|< i
  ,reg2dp_lut_access_type     //|< i
  ,reg2dp_lut_addr            //|< i
  ,reg2dp_lut_data            //|< i
  ,reg2dp_lut_data_trigger    //|< i
  ,reg2dp_lut_hybrid_priority //|< i
  ,reg2dp_lut_oflow_priority  //|< i
  ,reg2dp_lut_table_id        //|< i
  ,reg2dp_lut_uflow_priority  //|< i
  ,dp2lut_prdy                //|> o
  ,dp2reg_lut_data            //|> o
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         ,lut2intp_X_data_${m}0         //|> o
//:         ,lut2intp_X_data_${m}0_17b     //|> o
//:         ,lut2intp_X_data_${m}1         //|> o
//:         ,lut2intp_X_info_${m}          //|> o
//:     );
//: }
  ,lut2intp_X_sel             //|> o
  ,lut2intp_Y_sel             //|> o
  ,lut2intp_pvld              //|> o
  );
////////////////////////////////////////////////////////////////////////////
input         nvdla_core_clk;
input         nvdla_core_clk_orig;
input         nvdla_core_rstn;
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         input   [9:0] dp2lut_X_entry_${m};
//:         input  [17:0] dp2lut_Xinfo_${m};
//:         input   [9:0] dp2lut_Y_entry_${m};
//:         input  [17:0] dp2lut_Yinfo_${m};
//:     );
//: }
input         dp2lut_pvld;
input         lut2intp_prdy;
input         reg2dp_lut_access_type;
input   [9:0] reg2dp_lut_addr;
input  [15:0] reg2dp_lut_data;
input         reg2dp_lut_data_trigger;
input         reg2dp_lut_hybrid_priority;
input         reg2dp_lut_oflow_priority;
input         reg2dp_lut_table_id;
input         reg2dp_lut_uflow_priority;
output        dp2lut_prdy;
output [15:0] dp2reg_lut_data;
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         output [31:0] lut2intp_X_data_${m}0;
//:         output [16:0] lut2intp_X_data_${m}0_17b;
//:         output [31:0] lut2intp_X_data_${m}1;
//:         output [19:0] lut2intp_X_info_${m};
//:     );
//: }
output  [NVDLA_CDP_THROUGHPUT-1:0] lut2intp_X_sel;
output  [NVDLA_CDP_THROUGHPUT-1:0] lut2intp_Y_sel;
output        lut2intp_pvld;
////////////////////////////////////////////////////////////////////////////
reg    [15:0] density_out;
//: foreach my $m  (0..256) {
//:     print qq(
//:         reg    [15:0] density_reg$m;
//:     );
//: }
reg           lut2intp_pvld;
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         reg    [31:0] lut2intp_X_data_${m}0;
//:         reg    [16:0] lut2intp_X_data_${m}0_17b;
//:         reg    [31:0] lut2intp_X_data_${m}1;
//:         reg    [19:0] lut2intp_X_info_${m};
//:     );
//: }
reg     [NVDLA_CDP_THROUGHPUT-1:0] lut2intp_X_sel;
reg     [NVDLA_CDP_THROUGHPUT-1:0] lut2intp_Y_sel;
reg     [NVDLA_CDP_THROUGHPUT-1:0] lutX_sel;
reg     [NVDLA_CDP_THROUGHPUT-1:0] lutY_sel;
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         reg    [15:0] lut_X_data_${m}0;
//:         reg    [15:0] lut_X_data_${m}1;
//:         reg    [17:0] lut_X_info_${m};
//:         reg    [15:0] lut_Y_data_${m}0;
//:         reg    [15:0] lut_Y_data_${m}1;
//:         reg    [17:0] lut_Y_info_${m};
//:     );
//: }
reg     [NVDLA_CDP_THROUGHPUT-1:0] lut_X_sel;
reg     [NVDLA_CDP_THROUGHPUT-1:0] lut_Y_sel;
reg    [15:0] raw_out;
//: foreach my $m  (0..64) {
//:     print qq(
//:         reg    [15:0] raw_reg$m;
//:     );
//: }
wire          both_hybrid_sel;
wire          both_of_sel;
wire          both_uf_sel;
wire          dp2lut_prdy_f;
wire          load_din;
// my $k = NVDLA_CDP_THROUGHPUT/2;
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         wire   [15:0] lutX_data_${m}0;
//:         wire   [15:0] lutX_data_${m}1;
//:         wire   [15:0] lutX_info_${m};
//:         wire   [31:0] lut_X_dat_${m}0;
//:         wire   [16:0] lut_X_dat_${m}0_fp17;
//:         wire   [31:0] lut_X_dat_${m}1;
//:     );
//: }
wire          lut_wr_en;
wire          raw_select;
////////////////////////////////////////////////////////////////////////////
//==============
// Work Processing
//==============
assign lut_wr_en = (reg2dp_lut_access_type== 1'h1 ) && reg2dp_lut_data_trigger;
assign raw_select = (reg2dp_lut_table_id == 1'h0 );
//==========================================
//LUT write 
//------------------------------------------
//need update foreach value if LUT depth update
//: foreach my $m  (0..64) {
//:     print qq(
//:         always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
//:           if (!nvdla_core_rstn) begin
//:             raw_reg${m} <= {16{1'b0}};
//:           end else if (lut_wr_en & raw_select) begin 
//:                 if (reg2dp_lut_addr[9:0] == $m) 
//:                      raw_reg$m <= reg2dp_lut_data[15:0]; 
//:           end
//:         end
//:     );
//: }

//------------------------------------------
//need update foreach value if LUT depth update
//: foreach my $m  (0..256) {
//:     print qq(
//:         always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
//:           if (!nvdla_core_rstn) begin
//:             density_reg$m <= {16{1'b0}};
//:           end else begin
//:             if (lut_wr_en & (~raw_select)) begin 
//:                 if (reg2dp_lut_addr[9:0] == $m) 
//:                      density_reg$m <= reg2dp_lut_data[15:0]; 
//:             end
//:           end
//:         end
//:     );
//: }

//==========================================
//LUT read
//------------------------------------------
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    raw_out <= {16{1'b0}};
  end else begin
    case(reg2dp_lut_addr[9:0]) 
//: foreach my $m (0..64) {
//:     print qq(
//:         $m: raw_out <= raw_reg$m; 
//:     );
//: }
    default: raw_out <= raw_reg0; 
    endcase 
  end
end

always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    density_out <= {16{1'b0}};
  end else begin
    case (reg2dp_lut_addr[9:0]) 
//: foreach my $m (0..256) {
//:     print qq(
//:         $m: density_out <= density_reg$m; 
//:     );
//: }
    default: density_out <= density_reg0; 
    endcase 
  end
end

assign dp2reg_lut_data[15:0] = raw_select ? raw_out : density_out;

//==========================================
//data to DP
//------------------------------------------
assign load_din = dp2lut_pvld & dp2lut_prdy_f;
assign dp2lut_prdy_f = ~lut2intp_pvld | lut2intp_prdy;
assign dp2lut_prdy = dp2lut_prdy_f;

/////////////////////////////////
//lut look up select control
/////////////////////////////////
assign both_hybrid_sel = (reg2dp_lut_hybrid_priority == 1'h1 );
assign both_of_sel  = (reg2dp_lut_oflow_priority == 1'h1 );
assign both_uf_sel  = (reg2dp_lut_uflow_priority == 1'h1 );

//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         always @(*) begin
//:              case({dp2lut_Xinfo_${m}[17:16],dp2lut_Yinfo_${m}[17:16]}) 
//:              4'b0000,4'b0110,4'b1001: lut_X_sel[$m] = ~both_hybrid_sel; //both hit, or one uflow and the other oflow 
//:              4'b0001,4'b0010: lut_X_sel[$m] = 1'b1; //X hit, Y uflow/oflow 
//:              4'b0100,4'b1000: lut_X_sel[$m] = 1'b0; //X uflow/oflow, Y hit 
//:              4'b0101: lut_X_sel[$m] = ~both_uf_sel ; //both uflow 
//:              4'b1010: lut_X_sel[$m] = ~both_of_sel ; //both oflow 
//:              default: lut_X_sel[$m] = 1'd0; 
//:              endcase 
//:         end
//:     );
//: }

//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         always @(*) begin
//:              case({dp2lut_Xinfo_${m}[17:16],dp2lut_Yinfo_${m}[17:16]}) 
//:              4'b0000,4'b0110,4'b1001: lut_Y_sel[$m] = both_hybrid_sel; //both hit, or one uflow and the other oflow 
//:              4'b0001,4'b0010: lut_Y_sel[$m] = 1'b0; //X hit, Y uflow/oflow 
//:              4'b0100,4'b1000: lut_Y_sel[$m] = 1'b1; //X uflow/oflow, Y hit 
//:              4'b0101: lut_Y_sel[$m] = both_uf_sel ; //both uflow 
//:              4'b1010: lut_Y_sel[$m] = both_of_sel ; //both oflow 
//:              default: lut_Y_sel[$m] = 1'd0; 
//:              endcase 
//:         end
//:     );
//: }

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
  nv_assert_never #(0,0,"CDP LUT select: Lut X and Lut Y both select or both not selected")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, load_din & (~(&(lut_X_sel ^ lut_Y_sel)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

/////////////////////////////////

//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:           if (!nvdla_core_rstn) begin
//:             lut_X_data_${m}0[15:0] <= {16{1'b0}};
//:             lut_X_data_${m}1[15:0] <= {16{1'b0}};
//:           end else begin
//:           if(load_din & lut_X_sel[$m]) begin 
//:              if(dp2lut_Xinfo_${m}[16]) begin 
//:                 lut_X_data_${m}0[15:0] <= raw_reg0; 
//:                 lut_X_data_${m}1[15:0] <= raw_reg0; 
//:              end else if(dp2lut_Xinfo_${m}[17]) begin 
//:                 lut_X_data_${m}0[15:0] <= raw_reg64; 
//:                 lut_X_data_${m}1[15:0] <= raw_reg64; 
//:              end else begin 
//:                case(dp2lut_X_entry_${m}[9:0]) 
//:     );
//:         foreach my $i  (0..64-1) {
//:           my $j = $i + 1;
//:           print qq(
//:             $i: begin 
//:                  lut_X_data_${m}0[15:0] <= raw_reg${i}; 
//:                  lut_X_data_${m}1[15:0] <= raw_reg${j}; 
//:             end 
//:           );
//:         }
//:     print qq(
//:            64: begin 
//:                 lut_X_data_${m}0[15:0] <= raw_reg64; 
//:                 lut_X_data_${m}1[15:0] <= raw_reg64; 
//:            end 
//:            default: begin 
//:              lut_X_data_${m}0[15:0] <= raw_reg0; 
//:              lut_X_data_${m}1[15:0] <= raw_reg0; 
//:            end 
//:            endcase 
//:            end 
//:        end 
//:          end
//:        end
//:            );
//: }
/////////////////
/////////////////
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:           if (!nvdla_core_rstn) begin
//:             lut_Y_data_${m}0[15:0] <= {16{1'b0}};
//:             lut_Y_data_${m}1[15:0] <= {16{1'b0}};
//:           end else begin
//:           if(load_din & lut_Y_sel[$m]) begin 
//:              if(dp2lut_Yinfo_${m}[16]) begin 
//:                 lut_Y_data_${m}0[15:0] <= density_reg0; 
//:                 lut_Y_data_${m}1[15:0] <= density_reg0; 
//:              end else if(dp2lut_Yinfo_${m}[17]) begin 
//:                 lut_Y_data_${m}0[15:0] <= density_reg256; 
//:                 lut_Y_data_${m}1[15:0] <= density_reg256; 
//:              end else begin 
//:                case(dp2lut_Y_entry_${m}[9:0]) 
//:     );
//:         foreach my $i  (0..256-1) {
//:           my $j = $i + 1;
//:           print qq(
//:               $i: begin 
//:                    lut_Y_data_${m}0[15:0] <= density_reg${i}; 
//:                    lut_Y_data_${m}1[15:0] <= density_reg${j}; 
//:               end 
//:           );
//:         }
//:     print qq(
//:               256: begin 
//:                    lut_Y_data_${m}0[15:0] <= density_reg256; 
//:                    lut_Y_data_${m}1[15:0] <= density_reg256; 
//:               end 
//:               default: begin 
//:                 lut_Y_data_${m}0[15:0] <= density_reg0; 
//:                 lut_Y_data_${m}1[15:0] <= density_reg0; 
//:               end 
//:             endcase 
//:             end 
//:       end 
//:         end
//:       end
//:            );
//: }

////////////////

//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:           if (!nvdla_core_rstn) begin
//:             lut_X_info_${m} <= {18{1'b0}};
//:           end else if (load_din) begin
//:             lut_X_info_${m} <= dp2lut_Xinfo_${m}[17:0];
//:           end
//:         end
//:     );
//: }
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    lutX_sel <= {NVDLA_CDP_THROUGHPUT{1'b0}};
  end else if (load_din) begin
    lutX_sel <= lut_X_sel[NVDLA_CDP_THROUGHPUT-1:0];
  end
end

//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
//:           if (!nvdla_core_rstn) begin
//:             lut_Y_info_${m} <= {18{1'b0}};
//:           end else if (load_din) begin
//:             lut_Y_info_${m} <= dp2lut_Yinfo_${m}[17:0];
//:           end
//:         end
//:     );
//: }

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    lutY_sel <= {NVDLA_CDP_THROUGHPUT{1'b0}};
  end else if (load_din) begin
    lutY_sel <= lut_Y_sel[NVDLA_CDP_THROUGHPUT-1:0];
  end
end
////////////////
//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:         assign lutX_data_${m}0[15:0] = lutX_sel[$m] ? lut_X_data_${m}0[15:0] : (lutY_sel[$m] ? lut_Y_data_${m}0[15:0] : 16'd0); 
//:         assign lutX_data_${m}1[15:0] = lutX_sel[$m] ? lut_X_data_${m}1[15:0] : (lutY_sel[$m] ? lut_Y_data_${m}1[15:0] : 16'd0); 
//:         assign lutX_info_${m}[15:0]  = lutX_sel[$m] ? lut_X_info_${m}[15:0]  : (lutY_sel[$m] ? lut_Y_info_${m}[15:0]  : 16'd0); 
//:     );
//: }

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
     lut2intp_pvld <= 1'b0;
  end else begin
    if(dp2lut_pvld)
        lut2intp_pvld <= 1'b1;
    else if(lut2intp_prdy)
        lut2intp_pvld <= 1'b0;
  end
end
///////////////////////////////////////////////////////////////
//output data
///////////////////////////////////////////////////////////////

//: my $k = NVDLA_CDP_THROUGHPUT;
//: foreach my $m  (0..$k-1) {
//:     print qq(
//:          assign  lut2intp_X_data_${m}0[31:0]     = {{16{lutX_data_${m}0[15]}},lutX_data_${m}0[15:0]}; 
//:          assign  lut2intp_X_data_${m}1[31:0]     = {{16{lutX_data_${m}1[15]}},lutX_data_${m}1[15:0]}; 
//:          assign  lut2intp_X_data_${m}0_17b[16:0] = {lutX_data_${m}0[15],lutX_data_${m}0[15:0]}; 
//:          assign  lut2intp_X_info_${m}[19:0]      = {lut_Y_info_${m}[17:16],lut_X_info_${m}[17:16],lutX_info_${m}[15:0]}; 
//:          assign  lut2intp_X_sel[$m]            = lutX_sel[$m]; 
//:          assign  lut2intp_Y_sel[$m]            = lutY_sel[$m]; 
//:     );
//: }

/////////////////////////
endmodule // NV_NVDLA_CDP_DP_lut

