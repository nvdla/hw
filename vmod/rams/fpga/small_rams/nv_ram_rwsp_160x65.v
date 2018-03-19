// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nv_ram_rwsp_160x65.v

module nv_ram_rwsp_160x65 ( 
		clk,
		ra,
		re,
		ore,
		dout,
		wa,
		we,
		di,
		pwrbus_ram_pd
);

parameter FORCE_CONTENTION_ASSERTION_RESET_ACTIVE=1'b0;

// port list
input			clk;
input	[7:0]	ra;
input			re;
input			ore;
output	[64:0]	dout;
input	[7:0]	wa;
input			we;
input	[64:0]	di;
input	[31:0]	pwrbus_ram_pd;

//reg and wire list
reg		[7:0]	ra_d;
wire	[64:0]	dout;
reg		[64:0]	M	[159:0];

always @( posedge clk ) begin
    if (we)
       M[wa] <= di;
end
 
always @( posedge clk ) begin
    if (re) 
       ra_d <= ra;
end

wire	[64:0]	dout_ram = M[ra_d];

reg		[64:0]	dout_r;
always @( posedge clk ) begin
   if (ore)
       dout_r <= dout_ram;
end

assign dout = dout_r;


endmodule
