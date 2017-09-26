// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_CORE_Y_dpunpack.v

`include "simulate_x_tick.vh"
module NV_NVDLA_SDP_CORE_Y_dpunpack (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,inp_pvld
  ,inp_data
  ,inp_prdy
  ,out_pvld
  ,out_data
  ,out_prdy
  );
    input nvdla_core_clk;
    input nvdla_core_rstn;

    input  inp_pvld;
    input  [127:0] inp_data;
    output inp_prdy;
    
    output out_pvld;
    output [511:0] out_data;
    input  out_prdy;

    reg    [1:0] pack_cnt;
    reg          pack_pvld;
    reg  [127:0] pack_seg0;
    reg  [127:0] pack_seg1;
    reg  [127:0] pack_seg2;
    reg  [127:0] pack_seg3;
    wire         inp_acc;
    wire         is_pack_last;
    wire         pack_prdy;



assign inp_prdy = (!pack_pvld) | pack_prdy ;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pack_pvld <= 1'b0;
  end else begin
  if ((inp_prdy) == 1'b1) begin
    pack_pvld <= inp_pvld & is_pack_last;
  // VCS coverage off
  end else if ((inp_prdy) == 1'b0) begin
  end else begin
    pack_pvld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(inp_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign inp_acc = inp_pvld & inp_prdy;


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pack_cnt <= {2{1'b0}};
  end else begin
    if (inp_acc) begin
        if (is_pack_last) begin
            pack_cnt <= 0;
        end else begin
            pack_cnt <= pack_cnt + 1;
        end
    end
  end
end

assign is_pack_last = (pack_cnt==4-1);

always @(posedge nvdla_core_clk) begin
  if ((inp_acc & pack_cnt==0) == 1'b1) begin
    pack_seg0 <= inp_data;
  // VCS coverage off
  end else if ((inp_acc & pack_cnt==0) == 1'b0) begin
  end else begin
    pack_seg0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
                
always @(posedge nvdla_core_clk) begin
  if ((inp_acc & pack_cnt==1) == 1'b1) begin
    pack_seg1 <= inp_data;
  // VCS coverage off
  end else if ((inp_acc & pack_cnt==1) == 1'b0) begin
  end else begin
    pack_seg1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
                
always @(posedge nvdla_core_clk) begin
  if ((inp_acc & pack_cnt==2) == 1'b1) begin
    pack_seg2 <= inp_data;
  // VCS coverage off
  end else if ((inp_acc & pack_cnt==2) == 1'b0) begin
  end else begin
    pack_seg2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
                
always @(posedge nvdla_core_clk) begin
  if ((inp_acc & pack_cnt==3) == 1'b1) begin
    pack_seg3 <= inp_data;
  // VCS coverage off
  end else if ((inp_acc & pack_cnt==3) == 1'b0) begin
  end else begin
    pack_seg3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
                

//====================================
assign pack_prdy = out_prdy;
assign out_pvld  = pack_pvld;
assign out_data  = {pack_seg3 , pack_seg2 , pack_seg1 , pack_seg0};

endmodule // NV_NVDLA_SDP_CORE_Y_dpunpack

