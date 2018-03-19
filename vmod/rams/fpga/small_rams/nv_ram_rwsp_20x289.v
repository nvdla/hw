// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nv_ram_rwsp_20x289.v

module nv_ram_rwsp_20x289 ( 
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
input	[4:0]	ra;
input			re;
input			ore;
output	[288:0]	dout;
input	[4:0]	wa;
input			we;
input	[288:0]	di;
input	[31:0]	pwrbus_ram_pd;

//reg and wire list
reg		[4:0]	ra_d;
wire	[288:0]	dout;
reg		[288:0]	M	[19:0];

always @( posedge clk ) begin
    if (we)
       M[wa] <= di;
end
 
always @( posedge clk ) begin
    if (re) 
       ra_d <= ra;
end

wire	[288:0]	dout_ram = M[ra_d];

reg		[288:0]	dout_r;
always @( posedge clk ) begin
   if (ore)
       dout_r <= dout_ram;
end

assign dout = dout_r;


endmodule
