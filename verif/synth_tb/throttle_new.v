
`include "syn_tb_defines.vh"
`define THROTTLE_CENTER		1000

module throttle_new (clk, reset, perc, len, valid, id, ready);

input clk;
input reset;

input [31:0] perc;
input [3:0] len;
input valid;
input [`LOG2_Q-1:0] id;
output ready;

reg ready;
reg [15:0] d;
reg [`LOG2_Q-1:0] prev_id;

wire [15:0] dx;
wire [15:0] dy;
wire [15:0] dx2;
wire [15:0] dy2;

assign dy = perc;
assign dy2 = 2 * dy;
assign dx = 100;
assign dx2 = 2 * dx;


always @ (posedge clk or negedge reset) begin
//	$display ("%0t:  d=%0d dx=%0d dy=%0d dx2=%0d dy2=%0d perc=%0d", $time, d, dx, dy, dx2, dy2, perc);
	if (!reset) begin
		d <= dy2 - dx + `THROTTLE_CENTER; // Center at `THROTTLE_CENTER.
		ready <= 0;
	end
	else begin
		if (valid == 1'b1 && !ready) begin
			if (d > `THROTTLE_CENTER) begin
				ready <= 1;
                d <= d + ((dy2 - dx2) * len);
			end
			else begin
				ready <= 0;
				d <= d + (dy2);
			end
		end
		else begin
			ready <= 0;
		end
	end

end


endmodule

/*module top;

reg clk, reset;
reg [15:0] perc;
reg [15:0] size;
reg valid;
wire ready;


initial begin
	clk <= 0;
	reset <= 1;
	size <= 1;
	perc <= 50;
	valid <= 1;
	#100

	reset <= 0;
	$display ("Reset complete");
	#1000;


	$finish;
end

throttle t1 (clk, reset, perc, size, valid,ready);

always #10 clk = ~clk;

always @ (posedge clk) begin
	$display ("%0t ready=%d size=%d", $time, ready, size);

	if (ready == 1'b1) begin
		size <= (size  + 1) %3 + 1;
	end
end


endmodule*/
