// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_apb2csb.v

module NV_NVDLA_apb2csb (
   pclk
  ,prstn
  ,csb2nvdla_ready
  ,nvdla2csb_data
  ,nvdla2csb_valid
  ,paddr
  ,penable
  ,psel
  ,pwdata
  ,pwrite
  ,csb2nvdla_addr
  ,csb2nvdla_nposted
  ,csb2nvdla_valid
  ,csb2nvdla_wdat
  ,csb2nvdla_write
  ,prdata
  ,pready
  );


input  pclk;
input  prstn;

//apb interface
input         psel; 
input         penable;
input         pwrite;
input [31:0]  paddr;
input [31:0]  pwdata;
output [31:0] prdata;
output        pready;

//csb interface 
output         csb2nvdla_valid;   
input          csb2nvdla_ready; 
output  [15:0] csb2nvdla_addr;
output  [31:0] csb2nvdla_wdat;
output         csb2nvdla_write;
output         csb2nvdla_nposted;

input          nvdla2csb_valid; 
input   [31:0] nvdla2csb_data;

//input  nvdla2csb_wr_complete;

reg    rd_trans_low;
wire   rd_trans_vld;
wire   wr_trans_vld;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
assign   wr_trans_vld = psel & penable & pwrite; 
assign   rd_trans_vld = psel & penable & ~pwrite;

always @(posedge pclk or negedge prstn) begin
  if (!prstn) begin
    rd_trans_low <= 1'b0;
  end else begin
    if(nvdla2csb_valid & rd_trans_low) 
        rd_trans_low <= 1'b0;
    else if (csb2nvdla_ready & rd_trans_vld) 
        rd_trans_low <= 1'b1;
  end
end

assign   csb2nvdla_valid   = wr_trans_vld | rd_trans_vld & ~rd_trans_low;
assign   csb2nvdla_addr    = paddr[17:2];
assign   csb2nvdla_wdat    = pwdata[31:0];
assign   csb2nvdla_write   = pwrite;
assign   csb2nvdla_nposted = 1'b0;

assign   prdata = nvdla2csb_data[31:0]; 

assign   pready = ~(wr_trans_vld & ~csb2nvdla_ready | rd_trans_vld & ~nvdla2csb_valid);

endmodule // NV_NVDLA_apb2csb

