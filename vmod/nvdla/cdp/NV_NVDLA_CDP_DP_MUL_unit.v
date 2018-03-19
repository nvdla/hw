// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_DP_MUL_unit.v

module NV_NVDLA_CDP_DP_MUL_unit (
   nvdla_core_clk  
  ,nvdla_core_rstn 
  ,mul_ina_pd        
  ,mul_inb_pd     
  ,mul_unit_rdy    
  ,mul_vld         
  ,mul_rdy         
  ,mul_unit_pd     
  ,mul_unit_vld    
  );
//////////////////////////////////////////////////////////////////////////
parameter pINA_BW = 9;
parameter pINB_BW = 16;
//////////////////////////////////////////////////////////////////////////
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         mul_vld;
output        mul_rdy;
input  [pINA_BW-1:0] mul_ina_pd;
input  [pINB_BW-1:0] mul_inb_pd;
output        mul_unit_vld;
input         mul_unit_rdy;
output [pINA_BW+pINB_BW-1:0] mul_unit_pd;
//////////////////////////////////////////////////////////////////////////
reg        mul_unit_vld;
reg    [pINA_BW+pINB_BW-1:0] mul_unit_pd;
//////////////////////////////////////////////////////////////////////////
assign mul_rdy = ~mul_unit_vld | mul_unit_rdy;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mul_unit_pd <= {(pINA_BW+pINB_BW){1'b0}};
  end else begin
    if(mul_vld & mul_rdy) begin
        mul_unit_pd <= $signed(mul_inb_pd[pINB_BW-1:0]) * $signed(mul_ina_pd[pINA_BW-1:0]);
    end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mul_unit_vld <= 1'b0;
  end else begin
    if(mul_vld)
        mul_unit_vld <= 1'b1;
    else if(mul_unit_rdy)
        mul_unit_vld <= 1'b0;
  end
end

///////////////////////////////////////////
endmodule // NV_NVDLA_CDP_DP_MUL_unit


