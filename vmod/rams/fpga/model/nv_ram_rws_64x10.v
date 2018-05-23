
module nv_ram_rws_64x10 ( 
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
input	[5:0]	ra;
input			re;
output	[9:0]	dout;
input	[5:0]	wa;
input			we;
input	[9:0]	di;
input	[31:0]	pwrbus_ram_pd;

//reg and wire list
reg		[5:0]	ra_d;
wire	[9:0]	dout;
reg		[9:0]	M	[63:0];

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
