
module nv_ram_rws_128x512 ( 
		clk,
		ra,
		re,
		dout,
		wa,
		we,
		di,
		pwrbus_ram_pd
);

parameter FORCE_CONTENTION_ASSERTION_RESET_ACTIVE=1'b0;

// port list
input			clk;
input	[6:0]	ra;
input			re;
output	[511:0]	dout;
input	[6:0]	wa;
input			we;
input	[511:0]	di;
input	[31:0]	pwrbus_ram_pd;

//reg and wire list
reg		[6:0]	ra_d;
wire	[511:0]	dout;
reg		[511:0]	M	[127:0];

always @( posedge clk ) begin
    if (we)
       M[wa] <= di;
end
 
always @( posedge clk ) begin
    if (re) 
       ra_d <= ra;
end
assign  dout = M[ra_d];

endmodule
