// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CACC_assembly_buffer.v

module NV_NVDLA_CACC_assembly_buffer (
   nvdla_core_clk  //|< i
  ,nvdla_core_rstn //|< i
  ,abuf_rd_addr    //|< i
  ,abuf_rd_en      //|< i
  ,abuf_wr_addr    //|< i
  ,abuf_wr_data_0  //|< i
  ,abuf_wr_data_1  //|< i
  ,abuf_wr_data_2  //|< i
  ,abuf_wr_data_3  //|< i
  ,abuf_wr_data_4  //|< i
  ,abuf_wr_data_5  //|< i
  ,abuf_wr_data_6  //|< i
  ,abuf_wr_data_7  //|< i
  ,abuf_wr_en      //|< i
  ,pwrbus_ram_pd   //|< i
  ,abuf_rd_data_0  //|> o
  ,abuf_rd_data_1  //|> o
  ,abuf_rd_data_2  //|> o
  ,abuf_rd_data_3  //|> o
  ,abuf_rd_data_4  //|> o
  ,abuf_rd_data_5  //|> o
  ,abuf_rd_data_6  //|> o
  ,abuf_rd_data_7  //|> o
  );


input          nvdla_core_clk;
input          nvdla_core_rstn;
input    [4:0] abuf_rd_addr;
input    [7:0] abuf_rd_en;
input    [4:0] abuf_wr_addr;
input  [767:0] abuf_wr_data_0;
input  [767:0] abuf_wr_data_1;
input  [767:0] abuf_wr_data_2;
input  [767:0] abuf_wr_data_3;
input  [543:0] abuf_wr_data_4;
input  [543:0] abuf_wr_data_5;
input  [543:0] abuf_wr_data_6;
input  [543:0] abuf_wr_data_7;
input    [7:0] abuf_wr_en;
input   [31:0] pwrbus_ram_pd;
output [767:0] abuf_rd_data_0;
output [767:0] abuf_rd_data_1;
output [767:0] abuf_rd_data_2;
output [767:0] abuf_rd_data_3;
output [543:0] abuf_rd_data_4;
output [543:0] abuf_rd_data_5;
output [543:0] abuf_rd_data_6;
output [543:0] abuf_rd_data_7;
wire   [767:0] abuf_rd_data_0_w;
wire   [767:0] abuf_rd_data_1_w;
wire   [767:0] abuf_rd_data_2_w;
wire   [767:0] abuf_rd_data_3_w;
wire   [543:0] abuf_rd_data_4_w;
wire   [543:0] abuf_rd_data_5_w;
wire   [543:0] abuf_rd_data_6_w;
wire   [543:0] abuf_rd_data_7_w;
wire   [767:0] abuf_rd_data_ecc_0;
wire   [767:0] abuf_rd_data_ecc_1;
wire   [767:0] abuf_rd_data_ecc_2;
wire   [767:0] abuf_rd_data_ecc_3;
wire   [543:0] abuf_rd_data_ecc_4;
wire   [543:0] abuf_rd_data_ecc_5;
wire   [543:0] abuf_rd_data_ecc_6;
wire   [543:0] abuf_rd_data_ecc_7;
wire   [767:0] abuf_rd_raw_data_0;
wire   [767:0] abuf_rd_raw_data_1;
wire   [767:0] abuf_rd_raw_data_2;
wire   [767:0] abuf_rd_raw_data_3;
wire   [543:0] abuf_rd_raw_data_4;
wire   [543:0] abuf_rd_raw_data_5;
wire   [543:0] abuf_rd_raw_data_6;
wire   [543:0] abuf_rd_raw_data_7;
wire     [7:0] abuf_rd_reg_en;
wire   [767:0] abuf_wr_data_0_d1_w;
wire   [767:0] abuf_wr_data_1_d1_w;
wire   [767:0] abuf_wr_data_2_d1_w;
wire   [767:0] abuf_wr_data_3_d1_w;
wire   [543:0] abuf_wr_data_4_d1_w;
wire   [543:0] abuf_wr_data_5_d1_w;
wire   [543:0] abuf_wr_data_6_d1_w;
wire   [543:0] abuf_wr_data_7_d1_w;
wire     [7:0] abuf_wr_en_d1_w;
reg    [767:0] abuf_rd_data_0;
reg    [767:0] abuf_rd_data_1;
reg    [767:0] abuf_rd_data_2;
reg    [767:0] abuf_rd_data_3;
reg    [543:0] abuf_rd_data_4;
reg    [543:0] abuf_rd_data_5;
reg    [543:0] abuf_rd_data_6;
reg    [543:0] abuf_rd_data_7;
reg      [7:0] abuf_rd_en_d1;
reg      [7:0] abuf_rd_en_d2;
reg    [767:0] abuf_rd_raw_data_0_d2;
reg    [767:0] abuf_rd_raw_data_1_d2;
reg    [767:0] abuf_rd_raw_data_2_d2;
reg    [767:0] abuf_rd_raw_data_3_d2;
reg    [543:0] abuf_rd_raw_data_4_d2;
reg    [543:0] abuf_rd_raw_data_5_d2;
reg    [543:0] abuf_rd_raw_data_6_d2;
reg    [543:0] abuf_rd_raw_data_7_d2;
reg      [4:0] abuf_wr_addr_d1;
reg    [767:0] abuf_wr_data_0_d1;
reg    [767:0] abuf_wr_data_1_d1;
reg    [767:0] abuf_wr_data_2_d1;
reg    [767:0] abuf_wr_data_3_d1;
reg    [543:0] abuf_wr_data_4_d1;
reg    [543:0] abuf_wr_data_5_d1;
reg    [543:0] abuf_wr_data_6_d1;
reg    [543:0] abuf_wr_data_7_d1;
reg      [7:0] abuf_wr_en_d1;





////////////////////////////////////////////////////////////////////////
//                                                                    //
// Input write latency: 1 cycle                                       //
//                                                                    //
////////////////////////////////////////////////////////////////////////








////////////////////////////////////////////////////////////////////////
//                                                                    //
// Output read latency: 3 cycle                                       //
//                                                                    //
////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////
// Input write stage1: connect to retiming register                   //
////////////////////////////////////////////////////////////////////////

assign abuf_wr_en_d1_w[0] = abuf_wr_en[0];
assign abuf_wr_en_d1_w[1] = abuf_wr_en[1];
assign abuf_wr_en_d1_w[2] = abuf_wr_en[2];
assign abuf_wr_en_d1_w[3] = abuf_wr_en[3];
assign abuf_wr_en_d1_w[4] = abuf_wr_en[4];
assign abuf_wr_en_d1_w[5] = abuf_wr_en[5];
assign abuf_wr_en_d1_w[6] = abuf_wr_en[6];
assign abuf_wr_en_d1_w[7] = abuf_wr_en[7];


assign abuf_wr_data_0_d1_w = abuf_wr_data_0[768-1:0];
assign abuf_wr_data_1_d1_w = abuf_wr_data_1[768-1:0];
assign abuf_wr_data_2_d1_w = abuf_wr_data_2[768-1:0];
assign abuf_wr_data_3_d1_w = abuf_wr_data_3[768-1:0];
assign abuf_wr_data_4_d1_w = abuf_wr_data_4[544-1:0];
assign abuf_wr_data_5_d1_w = abuf_wr_data_5[544-1:0];
assign abuf_wr_data_6_d1_w = abuf_wr_data_6[544-1:0];
assign abuf_wr_data_7_d1_w = abuf_wr_data_7[544-1:0];

////////////////////////////////////////////////////////////////////////
// Input write stage1 registers                                       //
////////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    abuf_wr_en_d1 <= {8{1'b0}};
  end else begin
  abuf_wr_en_d1 <= abuf_wr_en_d1_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    abuf_wr_addr_d1 <= {5{1'b0}};
  end else begin
  abuf_wr_addr_d1 <= abuf_wr_addr;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_wr_en_d1_w[0]) == 1'b1) begin
    abuf_wr_data_0_d1 <= {abuf_wr_data_0_d1_w};
  // VCS coverage off
  end else if ((abuf_wr_en_d1_w[0]) == 1'b0) begin
  end else begin
    abuf_wr_data_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_wr_en_d1_w[1]) == 1'b1) begin
    abuf_wr_data_1_d1 <= {abuf_wr_data_1_d1_w};
  // VCS coverage off
  end else if ((abuf_wr_en_d1_w[1]) == 1'b0) begin
  end else begin
    abuf_wr_data_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_wr_en_d1_w[2]) == 1'b1) begin
    abuf_wr_data_2_d1 <= {abuf_wr_data_2_d1_w};
  // VCS coverage off
  end else if ((abuf_wr_en_d1_w[2]) == 1'b0) begin
  end else begin
    abuf_wr_data_2_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_wr_en_d1_w[3]) == 1'b1) begin
    abuf_wr_data_3_d1 <= {abuf_wr_data_3_d1_w};
  // VCS coverage off
  end else if ((abuf_wr_en_d1_w[3]) == 1'b0) begin
  end else begin
    abuf_wr_data_3_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_wr_en_d1_w[4]) == 1'b1) begin
    abuf_wr_data_4_d1 <= {abuf_wr_data_4_d1_w};
  // VCS coverage off
  end else if ((abuf_wr_en_d1_w[4]) == 1'b0) begin
  end else begin
    abuf_wr_data_4_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_wr_en_d1_w[5]) == 1'b1) begin
    abuf_wr_data_5_d1 <= {abuf_wr_data_5_d1_w};
  // VCS coverage off
  end else if ((abuf_wr_en_d1_w[5]) == 1'b0) begin
  end else begin
    abuf_wr_data_5_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_wr_en_d1_w[6]) == 1'b1) begin
    abuf_wr_data_6_d1 <= {abuf_wr_data_6_d1_w};
  // VCS coverage off
  end else if ((abuf_wr_en_d1_w[6]) == 1'b0) begin
  end else begin
    abuf_wr_data_6_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_wr_en_d1_w[7]) == 1'b1) begin
    abuf_wr_data_7_d1 <= {abuf_wr_data_7_d1_w};
  // VCS coverage off
  end else if ((abuf_wr_en_d1_w[7]) == 1'b0) begin
  end else begin
    abuf_wr_data_7_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

////////////////////////////////////////////////////////////////////////
// Instance RAMs                                                      //
////////////////////////////////////////////////////////////////////////

nv_ram_rws_32x768 u_accu_abuf_0 (
   .clk           (nvdla_core_clk)            //|< i
  ,.ra            (abuf_rd_addr[4:0])         //|< i
  ,.re            (abuf_rd_en[0])             //|< i
  ,.dout          (abuf_rd_data_ecc_0[767:0]) //|> w
  ,.wa            (abuf_wr_addr_d1[4:0])      //|< r
  ,.we            (abuf_wr_en_d1[0])          //|< r
  ,.di            (abuf_wr_data_0_d1[767:0])  //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0])       //|< i
  );


nv_ram_rws_32x768 u_accu_abuf_1 (
   .clk           (nvdla_core_clk)            //|< i
  ,.ra            (abuf_rd_addr[4:0])         //|< i
  ,.re            (abuf_rd_en[1])             //|< i
  ,.dout          (abuf_rd_data_ecc_1[767:0]) //|> w
  ,.wa            (abuf_wr_addr_d1[4:0])      //|< r
  ,.we            (abuf_wr_en_d1[1])          //|< r
  ,.di            (abuf_wr_data_1_d1[767:0])  //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0])       //|< i
  );


nv_ram_rws_32x768 u_accu_abuf_2 (
   .clk           (nvdla_core_clk)            //|< i
  ,.ra            (abuf_rd_addr[4:0])         //|< i
  ,.re            (abuf_rd_en[2])             //|< i
  ,.dout          (abuf_rd_data_ecc_2[767:0]) //|> w
  ,.wa            (abuf_wr_addr_d1[4:0])      //|< r
  ,.we            (abuf_wr_en_d1[2])          //|< r
  ,.di            (abuf_wr_data_2_d1[767:0])  //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0])       //|< i
  );


nv_ram_rws_32x768 u_accu_abuf_3 (
   .clk           (nvdla_core_clk)            //|< i
  ,.ra            (abuf_rd_addr[4:0])         //|< i
  ,.re            (abuf_rd_en[3])             //|< i
  ,.dout          (abuf_rd_data_ecc_3[767:0]) //|> w
  ,.wa            (abuf_wr_addr_d1[4:0])      //|< r
  ,.we            (abuf_wr_en_d1[3])          //|< r
  ,.di            (abuf_wr_data_3_d1[767:0])  //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0])       //|< i
  );


nv_ram_rws_32x544 u_accu_abuf_4 (
   .clk           (nvdla_core_clk)            //|< i
  ,.ra            (abuf_rd_addr[4:0])         //|< i
  ,.re            (abuf_rd_en[4])             //|< i
  ,.dout          (abuf_rd_data_ecc_4[543:0]) //|> w
  ,.wa            (abuf_wr_addr_d1[4:0])      //|< r
  ,.we            (abuf_wr_en_d1[4])          //|< r
  ,.di            (abuf_wr_data_4_d1[543:0])  //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0])       //|< i
  );


nv_ram_rws_32x544 u_accu_abuf_5 (
   .clk           (nvdla_core_clk)            //|< i
  ,.ra            (abuf_rd_addr[4:0])         //|< i
  ,.re            (abuf_rd_en[5])             //|< i
  ,.dout          (abuf_rd_data_ecc_5[543:0]) //|> w
  ,.wa            (abuf_wr_addr_d1[4:0])      //|< r
  ,.we            (abuf_wr_en_d1[5])          //|< r
  ,.di            (abuf_wr_data_5_d1[543:0])  //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0])       //|< i
  );


nv_ram_rws_32x544 u_accu_abuf_6 (
   .clk           (nvdla_core_clk)            //|< i
  ,.ra            (abuf_rd_addr[4:0])         //|< i
  ,.re            (abuf_rd_en[6])             //|< i
  ,.dout          (abuf_rd_data_ecc_6[543:0]) //|> w
  ,.wa            (abuf_wr_addr_d1[4:0])      //|< r
  ,.we            (abuf_wr_en_d1[6])          //|< r
  ,.di            (abuf_wr_data_6_d1[543:0])  //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0])       //|< i
  );


nv_ram_rws_32x544 u_accu_abuf_7 (
   .clk           (nvdla_core_clk)            //|< i
  ,.ra            (abuf_rd_addr[4:0])         //|< i
  ,.re            (abuf_rd_en[7])             //|< i
  ,.dout          (abuf_rd_data_ecc_7[543:0]) //|> w
  ,.wa            (abuf_wr_addr_d1[4:0])      //|< r
  ,.we            (abuf_wr_en_d1[7])          //|< r
  ,.di            (abuf_wr_data_7_d1[543:0])  //|< r
  ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0])       //|< i
  );







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
  nv_assert_never #(0,0,"Error! Read and write same entry at same cycle!")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, (abuf_wr_en_d1[0] & abuf_rd_en[0] & (abuf_wr_addr_d1 == abuf_rd_addr))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! Read and write same entry at same cycle!")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, (abuf_wr_en_d1[1] & abuf_rd_en[1] & (abuf_wr_addr_d1 == abuf_rd_addr))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! Read and write same entry at same cycle!")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, (abuf_wr_en_d1[2] & abuf_rd_en[2] & (abuf_wr_addr_d1 == abuf_rd_addr))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! Read and write same entry at same cycle!")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, (abuf_wr_en_d1[3] & abuf_rd_en[3] & (abuf_wr_addr_d1 == abuf_rd_addr))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! Read and write same entry at same cycle!")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, (abuf_wr_en_d1[4] & abuf_rd_en[4] & (abuf_wr_addr_d1 == abuf_rd_addr))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! Read and write same entry at same cycle!")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, (abuf_wr_en_d1[5] & abuf_rd_en[5] & (abuf_wr_addr_d1 == abuf_rd_addr))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! Read and write same entry at same cycle!")      zzz_assert_never_7x (nvdla_core_clk, `ASSERT_RESET, (abuf_wr_en_d1[6] & abuf_rd_en[6] & (abuf_wr_addr_d1 == abuf_rd_addr))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! Read and write same entry at same cycle!")      zzz_assert_never_8x (nvdla_core_clk, `ASSERT_RESET, (abuf_wr_en_d1[7] & abuf_rd_en[7] & (abuf_wr_addr_d1 == abuf_rd_addr))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////////////////////////////////////////////////////
// Input read stage1: read connection to RAM                          //
////////////////////////////////////////////////////////////////////////





////////////////////////////////////////////////////////////////////////
// Input read stage1 registers                                        //
////////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    abuf_rd_en_d1 <= {8{1'b0}};
  end else begin
  abuf_rd_en_d1 <= abuf_rd_en;
  end
end
////////////////////////////////////////////////////////////////////////
// Input read stage2: retiming reigsters                              //
////////////////////////////////////////////////////////////////////////


assign abuf_rd_raw_data_0 = abuf_rd_data_ecc_0;
assign abuf_rd_raw_data_1 = abuf_rd_data_ecc_1;
assign abuf_rd_raw_data_2 = abuf_rd_data_ecc_2;
assign abuf_rd_raw_data_3 = abuf_rd_data_ecc_3;
assign abuf_rd_raw_data_4 = abuf_rd_data_ecc_4;
assign abuf_rd_raw_data_5 = abuf_rd_data_ecc_5;
assign abuf_rd_raw_data_6 = abuf_rd_data_ecc_6;
assign abuf_rd_raw_data_7 = abuf_rd_data_ecc_7;


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    abuf_rd_en_d2 <= {8{1'b0}};
  end else begin
  abuf_rd_en_d2 <= abuf_rd_en_d1;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_rd_en_d1[0]) == 1'b1) begin
    abuf_rd_raw_data_0_d2 <= abuf_rd_raw_data_0;
  // VCS coverage off
  end else if ((abuf_rd_en_d1[0]) == 1'b0) begin
  end else begin
    abuf_rd_raw_data_0_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_rd_en_d1[1]) == 1'b1) begin
    abuf_rd_raw_data_1_d2 <= abuf_rd_raw_data_1;
  // VCS coverage off
  end else if ((abuf_rd_en_d1[1]) == 1'b0) begin
  end else begin
    abuf_rd_raw_data_1_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_rd_en_d1[2]) == 1'b1) begin
    abuf_rd_raw_data_2_d2 <= abuf_rd_raw_data_2;
  // VCS coverage off
  end else if ((abuf_rd_en_d1[2]) == 1'b0) begin
  end else begin
    abuf_rd_raw_data_2_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_rd_en_d1[3]) == 1'b1) begin
    abuf_rd_raw_data_3_d2 <= abuf_rd_raw_data_3;
  // VCS coverage off
  end else if ((abuf_rd_en_d1[3]) == 1'b0) begin
  end else begin
    abuf_rd_raw_data_3_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_rd_en_d1[4]) == 1'b1) begin
    abuf_rd_raw_data_4_d2 <= abuf_rd_raw_data_4;
  // VCS coverage off
  end else if ((abuf_rd_en_d1[4]) == 1'b0) begin
  end else begin
    abuf_rd_raw_data_4_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_rd_en_d1[5]) == 1'b1) begin
    abuf_rd_raw_data_5_d2 <= abuf_rd_raw_data_5;
  // VCS coverage off
  end else if ((abuf_rd_en_d1[5]) == 1'b0) begin
  end else begin
    abuf_rd_raw_data_5_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_rd_en_d1[6]) == 1'b1) begin
    abuf_rd_raw_data_6_d2 <= abuf_rd_raw_data_6;
  // VCS coverage off
  end else if ((abuf_rd_en_d1[6]) == 1'b0) begin
  end else begin
    abuf_rd_raw_data_6_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_rd_en_d1[7]) == 1'b1) begin
    abuf_rd_raw_data_7_d2 <= abuf_rd_raw_data_7;
  // VCS coverage off
  end else if ((abuf_rd_en_d1[7]) == 1'b0) begin
  end else begin
    abuf_rd_raw_data_7_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


////////////////////////////////////////////////////////////////////////
// Input read stage3: retiming register                               //
////////////////////////////////////////////////////////////////////////

assign abuf_rd_reg_en[0] = abuf_rd_en_d2[0];
assign abuf_rd_reg_en[1] = abuf_rd_en_d2[1];
assign abuf_rd_reg_en[2] = abuf_rd_en_d2[2];
assign abuf_rd_reg_en[3] = abuf_rd_en_d2[3];
assign abuf_rd_reg_en[4] = abuf_rd_en_d2[4];
assign abuf_rd_reg_en[5] = abuf_rd_en_d2[5];
assign abuf_rd_reg_en[6] = abuf_rd_en_d2[6];
assign abuf_rd_reg_en[7] = abuf_rd_en_d2[7];


assign abuf_rd_data_0_w = abuf_rd_raw_data_0_d2;
assign abuf_rd_data_1_w = abuf_rd_raw_data_1_d2;
assign abuf_rd_data_2_w = abuf_rd_raw_data_2_d2;
assign abuf_rd_data_3_w = abuf_rd_raw_data_3_d2;
assign abuf_rd_data_4_w = abuf_rd_raw_data_4_d2;
assign abuf_rd_data_5_w = abuf_rd_raw_data_5_d2;
assign abuf_rd_data_6_w = abuf_rd_raw_data_6_d2;
assign abuf_rd_data_7_w = abuf_rd_raw_data_7_d2;

////////////////////////////////////////////////////////////////////////
// Input read stage4 registers                                        //
////////////////////////////////////////////////////////////////////////
always @(posedge nvdla_core_clk) begin
  if ((abuf_rd_reg_en[0]) == 1'b1) begin
    abuf_rd_data_0 <= abuf_rd_data_0_w;
  // VCS coverage off
  end else if ((abuf_rd_reg_en[0]) == 1'b0) begin
  end else begin
    abuf_rd_data_0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_rd_reg_en[1]) == 1'b1) begin
    abuf_rd_data_1 <= abuf_rd_data_1_w;
  // VCS coverage off
  end else if ((abuf_rd_reg_en[1]) == 1'b0) begin
  end else begin
    abuf_rd_data_1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_rd_reg_en[2]) == 1'b1) begin
    abuf_rd_data_2 <= abuf_rd_data_2_w;
  // VCS coverage off
  end else if ((abuf_rd_reg_en[2]) == 1'b0) begin
  end else begin
    abuf_rd_data_2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_rd_reg_en[3]) == 1'b1) begin
    abuf_rd_data_3 <= abuf_rd_data_3_w;
  // VCS coverage off
  end else if ((abuf_rd_reg_en[3]) == 1'b0) begin
  end else begin
    abuf_rd_data_3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_rd_reg_en[4]) == 1'b1) begin
    abuf_rd_data_4 <= abuf_rd_data_4_w;
  // VCS coverage off
  end else if ((abuf_rd_reg_en[4]) == 1'b0) begin
  end else begin
    abuf_rd_data_4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_rd_reg_en[5]) == 1'b1) begin
    abuf_rd_data_5 <= abuf_rd_data_5_w;
  // VCS coverage off
  end else if ((abuf_rd_reg_en[5]) == 1'b0) begin
  end else begin
    abuf_rd_data_5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_rd_reg_en[6]) == 1'b1) begin
    abuf_rd_data_6 <= abuf_rd_data_6_w;
  // VCS coverage off
  end else if ((abuf_rd_reg_en[6]) == 1'b0) begin
  end else begin
    abuf_rd_data_6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((abuf_rd_reg_en[7]) == 1'b1) begin
    abuf_rd_data_7 <= abuf_rd_data_7_w;
  // VCS coverage off
  end else if ((abuf_rd_reg_en[7]) == 1'b0) begin
  end else begin
    abuf_rd_data_7 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end



endmodule // NV_NVDLA_CACC_assembly_buffer


