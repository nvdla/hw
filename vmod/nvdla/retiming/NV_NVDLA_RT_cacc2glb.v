// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_RT_cacc2glb.v

module NV_NVDLA_RT_cacc2glb (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cacc2glb_done_intr_src_pd
  ,cacc2glb_done_intr_dst_pd
  );

//
// NV_NVDLA_RT_cacc2glb_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input [1:0] cacc2glb_done_intr_src_pd;

output [1:0] cacc2glb_done_intr_dst_pd;

wire [1:0] cacc2glb_done_intr_pd_d0;
reg  [1:0] cacc2glb_done_intr_pd_d1;
reg  [1:0] cacc2glb_done_intr_pd_d2;



assign cacc2glb_done_intr_pd_d0 = cacc2glb_done_intr_src_pd;


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cacc2glb_done_intr_pd_d1 <= {2{1'b0}};
  end else begin
  cacc2glb_done_intr_pd_d1 <= cacc2glb_done_intr_pd_d0;
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cacc2glb_done_intr_pd_d2 <= {2{1'b0}};
  end else begin
  cacc2glb_done_intr_pd_d2 <= cacc2glb_done_intr_pd_d1;
  end
end


assign cacc2glb_done_intr_dst_pd = cacc2glb_done_intr_pd_d2;



endmodule // NV_NVDLA_RT_cacc2glb

