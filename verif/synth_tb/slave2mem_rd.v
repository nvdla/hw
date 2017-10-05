
`include "syn_tb_defines.vh"


module slave2mem_rd (
   clk,
   reset,
   
   slave2mem_cmd_rd,
   slave2mem_addr,
   mem2slave_rd_ready,
   mem2slave_rdresp_vld,
   mem2slave_rdresp_data,
   slave2mem_len,
   slave2mem_size,
   s_read_q_tail_valid,
   curr_tail,
   curr_rd_addr,
   curr_rd_len,
   mem2slave_rdresp_data_tmp,
   rdresp_data_ready
);

input clk;
input reset;
parameter AXI_SLAVE_ID=0;
parameter MEM_ADDR_START=`DLA_ADDR_START; //Parameterize instance with DBB_ or CVSRAM

input         slave2mem_cmd_rd;
input [`AXI_ADDR_WIDTH-1:0]  slave2mem_addr;
output reg    mem2slave_rd_ready;
output reg    mem2slave_rdresp_vld;
output reg [`WORD_SIZE-1:0] mem2slave_rdresp_data;
input [`AXI_LEN_WIDTH-1:0]  slave2mem_len;
input [`AXI_SIZE_WIDTH-1:0]  slave2mem_size;
output [`LOG2_Q-1:0] curr_tail;
output  s_read_q_tail_valid;
output [`AXI_ADDR_WIDTH-1-`LOG2_MEM:0] curr_rd_addr;
output [`AXI_LEN_WIDTH-1:0] curr_rd_len;
input [`WORD_SIZE-1:0] mem2slave_rdresp_data_tmp;
input rdresp_data_ready;

reg [`MSEQ_CONFIG_SIZE-1:0]            config_mem[`NUM_CONFIGS-1:0];
reg [`AXI_LEN_WIDTH+`AXI_ADDR_WIDTH-`LOG2_MEM:0] s_read_q [`QUEUE_SIZE-1:0];
reg [`LOG2_Q-1:0] s_read_head;
reg [`LOG2_Q-1:0] s_read_tail;
reg [`LOG2_Q-1:0] s_read_count;
reg s_read_count_inc,  s_read_count_dec;
wire [`LOG2_Q-1:0] s_read_latency; // Note if LOG2_Q changes, then config file may need to change.  Current config file is 12bits.
integer i;
reg carry_out;

assign curr_tail = s_read_tail;
assign curr_rd_addr = s_read_q [s_read_tail] [`RD_ADDR_RANGE] - (MEM_ADDR_START >> `LOG2_MEM);
assign curr_rd_len  = s_read_q [s_read_tail] [`RD_LEN_RANGE];
assign s_read_latency  = config_mem[`S0_READ_LATENCY] - `READ_LATENCY_CORRECTION; //spyglass disable W123
assign s_read_q_tail_valid = s_read_q[s_read_tail][`RD_VALID];
//assign mem2slave_rdresp_data <= mem2slave_rdresp_data_tmp;

initial begin //spyglass disable SYNTH_5143 W430
   $readmemh("slave_mem.cfg", config_mem); //spyglass disable SYNTH_5166 W213
end

always @(posedge clk or negedge reset) begin
   if(!reset) begin
      mem2slave_rd_ready  <= 1;
      mem2slave_rdresp_vld<= 0;
      s_read_head         <= s_read_latency;
      s_read_tail         <= 0;
      s_read_count        <= 0;
      s_read_count_inc    <= 0;
      s_read_count_dec    <= 0;
      for (i=0; i<`QUEUE_SIZE; i=i+1) begin
           s_read_q[i][`RD_VALID] <= 1'b0;
      end
   end else begin
		if (modSub (s_read_head, s_read_tail, `QUEUE_SIZE) > s_read_latency) begin
     			mem2slave_rd_ready  <= 0;
		end else begin
     			mem2slave_rd_ready  <= 1;
		end

		// Accept any new commands from slave 0
		if( slave2mem_cmd_rd) begin

			if (s_read_q[s_read_head][`RD_VALID]) begin
      			$display("%0t SMEM: ERROR: Slave %0d read head detected unread entry! Commands are probably getting dropped.", $time, AXI_SLAVE_ID); //spyglass disable SYNTH_5166 W213
				$finish; //spyglass disable SYNTH_5166 W213
			end else begin
				s_read_q[s_read_head] <= {slave2mem_len, slave2mem_addr[`AXI_ADDR_WIDTH-1:`LOG2_MEM], 1'b1};
				$display("%0t SMEM: Received slave %0d read addr 0x%010x len %d size %d, temp_mem_addr 0x%010x", $time, AXI_SLAVE_ID, slave2mem_addr, slave2mem_len, slave2mem_size, slave2mem_addr[`AXI_ADDR_WIDTH-1:`LOG2_MEM]); //spyglass disable SYNTH_5166 W213

	
				s_read_head <= modAdd (s_read_head, 1'd1, `QUEUE_SIZE);


				s_read_count_inc <= 1;
			end

		end else begin
			s_read_count_inc <= 0;

			if (modSub (s_read_head, s_read_tail, `QUEUE_SIZE) <= s_read_latency) begin
				s_read_head <= modAdd (s_read_tail, s_read_latency, `QUEUE_SIZE);
			end
		end

      if( s_read_q[s_read_tail][`RD_VALID] == 1'b1 ) begin
         if (rdresp_data_ready) begin
             mem2slave_rdresp_vld <= 1;
             mem2slave_rdresp_data <= mem2slave_rdresp_data_tmp;
             $display("%0t SMEM: Slave %0d read address 0x%010x (mem address 0x%x) data 0x%0128x", $time, AXI_SLAVE_ID, ((`AXI_ADDR_WIDTH'b0 + curr_rd_addr) * `MEM_BYTES) + MEM_ADDR_START, curr_rd_addr, mem2slave_rdresp_data_tmp); //spyglass disable SYNTH_5166 W213
             s_read_q[s_read_tail][`RD_VALID] <= 1'b0;
             s_read_count_dec <= 1;
          	s_read_tail <= modAdd (s_read_tail, 1'd1, `QUEUE_SIZE);
         end else begin
             mem2slave_rdresp_vld <= 0;
             s_read_count_dec <= 0;
         end
      end else begin
          mem2slave_rdresp_vld <= 0;
          s_read_count_dec <= 0;
          s_read_tail <= modAdd (s_read_tail, 1'd1, `QUEUE_SIZE);
      end

      // Increment head pointers. Either this or the increment while accepting new commands
      // could win the race - that's fine.
/*
      if(s_read_head <= s_read_tail + s_read_latency) begin
         s_read_head <= s_read_tail + s_read_latency;
      end
*/
      {carry_out,s_read_count}  <= s_read_count  + s_read_count_inc  - s_read_count_dec;
   end
end

assert_module a2 (.clk(clk), .test(carry_out));

always @* begin
   if( (s_read_head == s_read_tail) && reset )
      $display("%0t SMEM: ERROR: Slave %0d read head caught up to read tail! Commands are probably getting dropped.", $time, AXI_SLAVE_ID); //spyglass disable SYNTH_5166 W213
end

// Nicely increment power of 2 pointer;
function [`LOG2_Q-1:0] modAdd;
	input [`LOG2_Q-1:0] x;
	input [`LOG2_Q-1:0] delta;
	input [`LOG2_Q:0] wrapSize;

begin
	modAdd = (x + delta) % wrapSize;
end

endfunction

// Nicely decrement power of 2 pointer;
function [`LOG2_Q-1:0] modSub;
	input [`LOG2_Q-1:0] x;
	input [`LOG2_Q-1:0] delta;
	input [`LOG2_Q:0] wrapSize;

begin
	modSub = (x - delta) % wrapSize;
end

endfunction

endmodule

