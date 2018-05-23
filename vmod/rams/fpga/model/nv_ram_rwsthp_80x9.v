
module nv_ram_rwsthp_80x9 ( 
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
output	[8:0]	dout;
input	[6:0]	wa;
input			we;
input	[8:0]	di;
input			byp_sel;
input	[8:0]	dbyp;
input	[31:0]	pwrbus_ram_pd;

//reg and wire list
reg		[6:0]	ra_d;
wire	[8:0]	dout;
reg		[8:0]	M	[79:0];

always @( posedge clk ) begin
    if (we)
       M[wa] <= di;
end
 
always @( posedge clk ) begin
    if (re) 
       ra_d <= ra;
end

wire	[8:0]	dout_ram = M[ra_d];

wire	[8:0]	fbypass_dout_ram = (byp_sel ? dbyp : dout_ram);

reg		[8:0]	dout_r;
always @( posedge clk ) begin
   if (ore)
       dout_r <= fbypass_dout_ram;
end

assign dout = dout_r;


endmodule
