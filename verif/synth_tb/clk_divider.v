
// clock divider for memory and axi_slave
// memory clk is faster than axi_slave clk
// take in memory clk as input, slow it down to generate axi_slave clk

module clk_divider(
    clk,
    reset,
    slow_clk
);

input clk;
input reset;
output reg slow_clk;

reg [7:0] clkCount;
reg firstTime;
reg clkPrev;


always @(posedge clk or negedge reset) begin
    if(!reset) begin
        slow_clk <= 0;
        clkCount <= `DLA_CLOCK_DIVIDE - 2'b10;
        firstTime <= 1'b1;
    end else begin
    if (clkCount == 0) begin
        // Used to align the clocks.
        if (firstTime == 1'b1 )  begin
                slow_clk <= 1'b1;
                firstTime <= 1'b0;
                clkCount <= `DLA_CLOCK_DIVIDE - 2'b10;
        end else begin
            slow_clk <= ~slow_clk;
            clkCount <= `DLA_CLOCK_DIVIDE - 2'b10;
        end
    end else begin
        clkCount <= clkCount - 2'b10;
    end
/*        if (clkCount == 0) begin
            if ( firstTime ) begin
                slow_clk <= ~clk;
                firstTime <=0;
            end else begin
                slow_clk <= ~slow_clk;
            end
            clkCount <= `DLA_CLOCK_DIVIDE - 1'b1;
        end else begin
            clkCount <= clkCount - 1'b1;
        end
*/
    end
end

endmodule






