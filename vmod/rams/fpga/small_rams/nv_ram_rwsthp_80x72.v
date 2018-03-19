// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nv_ram_rwsthp_80x72.v

module nv_ram_rwsthp_80x72 ( 
		clk,
		ra,
		re,
		ore,
		dout,
		wa,
		we,
		di,
		byp_sel,
		dbyp,
		pwrbus_ram_pd
);

parameter FORCE_CONTENTION_ASSERTION_RESET_ACTIVE=1'b0;

// port list
input			clk;
input	[6:0]	ra;
input			re;
input			ore;
output	[71:0]	dout;
input	[6:0]	wa;
input			we;
input	[71:0]	di;
input			byp_sel;
input	[71:0]	dbyp;
input	[31:0]	pwrbus_ram_pd;

//reg and wire list
reg		[6:0]	ra_d;
wire	[71:0]	dout;
reg		[71:0]	M	[79:0];

always @( posedge clk ) begin
    if (we)
       M[wa] <= di;
end
 
always @( posedge clk ) begin
    if (re) 
       ra_d <= ra;
end

wire	[71:0]	dout_ram = M[ra_d];

wire	[71:0]	fbypass_dout_ram = (byp_sel ? dbyp : dout_ram);

reg		[71:0]	dout_r;
always @( posedge clk ) begin
   if (ore)
       dout_r <= fbypass_dout_ram;
end

assign dout = dout_r;


endmodule
