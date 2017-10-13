
`include "syn_tb_defines.vh"

module slave2mem_wr (
   clk,
   reset,
   
   slave2mem_cmd_wr,
   slave2mem_addr,
   slave2mem_data,
   slave2mem_wr_mask,
   slave2mem_len_wr,
   mem2slave_wr_ready,
   mem2slave_wrresp_vld,
   q2mem_write_q_tail_valid,
   q2mem_curr_wr_addr,
   q2mem_curr_wr_data,
   q2mem_curr_wr_mask,
   q2mem_curr_wr_len,
   mem2q_wr_ready
);

input clk;
input reset;
parameter AXI_SLAVE_ID = 0;
parameter MEM_ADDR_START=`DLA_ADDR_START; //Parameterize instance with DBB_ or CVSRAM

input         slave2mem_cmd_wr;
input [`AXI_ADDR_WIDTH-1:0]  slave2mem_addr;
input [`WORD_SIZE-1:0] slave2mem_data;
input [`WORD_BYTES-1:0] slave2mem_wr_mask;
input [`AXI_LEN_WIDTH-1:0] slave2mem_len_wr;
output reg    mem2slave_wr_ready;
output reg    mem2slave_wrresp_vld;
output q2mem_write_q_tail_valid;
output [`AXI_ADDR_WIDTH-1-`LOG2_MEM:0] q2mem_curr_wr_addr;
output [`WORD_SIZE-1:0] q2mem_curr_wr_data;
output [`WORD_BYTES-1:0] q2mem_curr_wr_mask;
output [`AXI_LEN_WIDTH-1:0] q2mem_curr_wr_len;
input mem2q_wr_ready;
reg [`AXI_LEN_WIDTH-1:0] mem2q_wrresp_burst_count;

reg [`MSEQ_CONFIG_SIZE-1:0]            config_mem[`NUM_CONFIGS-1:0];
reg [`WR_Q_MAX:0]     s_write_q[`QUEUE_SIZE-1:0];

reg [`LOG2_Q-1:0] s_write_head;
reg [`LOG2_Q-1:0] s_write_tail;
reg [`LOG2_Q-1:0] s_write_count;
reg s_write_count_inc, s_write_count_dec;
wire [`LOG2_Q-1:0] s_write_latency; // Note if LOG2_Q changes, then config file may need to change.  Current config file is 12bits.
integer i;

assign q2mem_curr_wr_addr = s_write_q[s_write_tail][`WR_ADDR_RANGE] - (MEM_ADDR_START >> `LOG2_MEM);
assign q2mem_curr_wr_mask = s_write_q[s_write_tail][`WR_MASK_RANGE];
assign q2mem_curr_wr_data = s_write_q[s_write_tail][`WR_DATA_RANGE];
assign q2mem_curr_wr_len  = s_write_q[s_write_tail][`WR_LEN_RANGE];
assign s_write_latency = config_mem[`S0_WRITE_LATENCY] - `WRITE_LATENCY_CORRECTION;
assign q2mem_write_q_tail_valid = s_write_q[s_write_tail][`WR_VALID];

initial begin
   $readmemh("slave_mem.cfg", config_mem);
end

always @(posedge clk or negedge reset) begin
   if(!reset) begin
      mem2q_wrresp_burst_count <= 0;
      mem2slave_wr_ready  <= 1;
      mem2slave_wrresp_vld<= 0;
      s_write_head        <= s_write_latency;
      s_write_tail        <= 0;
      s_write_count       <= 0;
      s_write_count_inc   <= 0;
      s_write_count_dec   <= 0;
      for (i=0; i<`QUEUE_SIZE; i=i+1) begin
          s_write_q[i][`WR_VALID] <= 1'b0;
      end
   end else begin
		if (modSub (s_write_head, s_write_tail, `QUEUE_SIZE) > s_write_latency) begin
			mem2slave_wr_ready  <= 0;
		end else begin
			mem2slave_wr_ready  <= 1;
		end

		if( slave2mem_cmd_wr ) begin

			if (s_write_q[s_write_head][`WR_VALID]) begin
				$display("%0t SMEM: ERROR: Slave %0d write head detected unread entry! Commands are probably getting dropped.", $time, AXI_SLAVE_ID);
				$finish;
			end else begin

				//Write
				s_write_q[s_write_head][`WR_VALID]      <= 1'b1;
				s_write_q[s_write_head][`WR_MASK_RANGE] <= slave2mem_wr_mask;
				s_write_q[s_write_head][`WR_ADDR_RANGE] <= slave2mem_addr[`AXI_ADDR_WIDTH-1:`LOG2_MEM];
				s_write_q[s_write_head][`WR_DATA_RANGE] <= slave2mem_data;
				s_write_q[s_write_head][`WR_LEN_RANGE] <= slave2mem_len_wr;
				$display("%0t SMEM: Received slave %0d write addr 0x%010x mask 0x%016x data 0x%0128x", $time, AXI_SLAVE_ID, slave2mem_addr, slave2mem_wr_mask, slave2mem_data);

				s_write_head <= modAdd (s_write_head, 'd1, `QUEUE_SIZE);
				s_write_head <= s_write_head + 1;

				s_write_count_inc <= 1;
			end
		end else begin
			s_write_count_inc <= 0;

			if (modSub (s_write_head, s_write_tail, `QUEUE_SIZE) <= s_write_latency) begin
				s_write_head <= modAdd (s_write_tail, s_write_latency, `QUEUE_SIZE);
			end
		end
			
//$display("wr_ready=%d, vaild=%d",wr_ready, s_write_q[s_write_tail][`WR_VALID]);
      
      // Return results and increment tail pointers for slave 0
      if( s_write_q[s_write_tail][`WR_VALID] == 1'b1 ) begin
//$display ("%0t: DEBUG1 mem2q_wr_ready=%h", $time, mem2q_wr_ready);
          if (mem2q_wr_ready) begin
//$display ("%0t: DEBUG2 mem2q_wr_ready=%h", $time, mem2q_wr_ready);
             if(mem2q_wrresp_burst_count < s_write_q[s_write_tail][`WR_LEN_RANGE]) begin
               mem2slave_wrresp_vld <= 0; //Only increment once per id
               mem2q_wrresp_burst_count <= mem2q_wrresp_burst_count + 1;
             end else begin
               mem2slave_wrresp_vld <= 1; //Only increment once per id
               mem2q_wrresp_burst_count <= 0;
             end
             s_write_q[s_write_tail][`WR_VALID] <= 1'b0;
             s_write_count_dec <= 1;

             s_write_tail <= modAdd (s_write_tail, 'd1, `QUEUE_SIZE);
          end else begin
             mem2slave_wrresp_vld <= 0;
             s_write_count_dec <= 0;
          end
      end else begin
          mem2slave_wrresp_vld <= 0;
          s_write_count_dec <= 0;
          s_write_tail <= modAdd (s_write_tail, 'd1, `QUEUE_SIZE);
      end

/*
      if(s_write_head <= s_write_tail + s_write_latency) begin
         s_write_head <= s_write_tail + s_write_latency;
      end
*/
      s_write_count <= s_write_count + s_write_count_inc - s_write_count_dec;
   end
end

always @* begin
   if( (s_write_head == s_write_tail) && reset )
      $display("%0t SMEM: ERROR: Slave %0d write head caught up to write tail! Commands are probably getting dropped.", $time, AXI_SLAVE_ID);
`ifdef EMU_TB
// AS - Not required
`else
   if( q2mem_curr_wr_addr > (`MEM_SIZE-1) && reset ) begin
      $display("%0t SMEM: ERROR: Slave %0d wrote the last address in memory, which doesn't exist due to VCS limitations.", $time, AXI_SLAVE_ID);
      $finish;
   end
`endif
end


// Nicely increment power of 2 pointer;
function [`LOG2_Q-1:0] modAdd;
	input [`LOG2_Q:0] x;
	input [`LOG2_Q:0] delta;
	input [`LOG2_Q:0] wrapSize;

begin
	modAdd = (x + delta) % wrapSize;
end

endfunction

// Nicely decrement power of 2 pointer;
function [`LOG2_Q-1:0] modSub;
	input [`LOG2_Q:0] x;
	input [`LOG2_Q:0] delta;
	input [`LOG2_Q:0] wrapSize;

begin
	modSub = (x - delta) % wrapSize;
end

endfunction

endmodule
