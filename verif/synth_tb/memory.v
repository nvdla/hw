
`include "syn_tb_defines.vh"

module slave_mem (
   clk,
   slow_clk,
   reset,
   
   slave2mem_cmd_rd,
   slave2mem_cmd_wr,
   slave2mem_addr_rd,
   slave2mem_addr_wr,
   slave2mem_data,
   slave2mem_wr_mask,
   slave2mem_len_rd,
   slave2mem_len_wr,
   slave2mem_size_rd,
   slave2mem_size_wr,
   mem2slave_rd_ready,
   mem2slave_wr_ready,
   mem2slave_rdresp_vld,
   mem2slave_rdresp_data,
   mem2slave_wrresp_vld
   
);

input clk;
input slow_clk;
input reset;

//vectorized to support two ports
input [`DLATB_S2M_CHANNEL_COUNT-1:0]     slave2mem_cmd_wr;
input [`DLATB_S2M_CHANNEL_COUNT-1:0]     slave2mem_cmd_rd;
input [`DLATB_S2M_CHANNEL_COUNT*`AXI_ADDR_WIDTH-1:0]  slave2mem_addr_wr;
input [`DLATB_S2M_CHANNEL_COUNT*`AXI_ADDR_WIDTH-1:0]  slave2mem_addr_rd;
input [`DLATB_S2M_CHANNEL_COUNT*`WORD_SIZE-1:0] slave2mem_data;
input [`DLATB_S2M_CHANNEL_COUNT*`WORD_BYTES-1:0] slave2mem_wr_mask;
input [`DLATB_S2M_CHANNEL_COUNT*`AXI_LEN_WIDTH-1:0]  slave2mem_len_rd;
input [`DLATB_S2M_CHANNEL_COUNT*`AXI_LEN_WIDTH-1:0]  slave2mem_len_wr;
input [`DLATB_S2M_CHANNEL_COUNT*`AXI_SIZE_WIDTH-1:0]  slave2mem_size_rd;
input [`DLATB_S2M_CHANNEL_COUNT*`AXI_SIZE_WIDTH-1:0]  slave2mem_size_wr;
output     [`DLATB_S2M_CHANNEL_COUNT-1:0] mem2slave_rd_ready;
output     [`DLATB_S2M_CHANNEL_COUNT-1:0] mem2slave_wr_ready;
output     [`DLATB_S2M_CHANNEL_COUNT-1:0] mem2slave_rdresp_vld;
output     [`DLATB_S2M_CHANNEL_COUNT*`WORD_SIZE-1:0] mem2slave_rdresp_data;
output     [`DLATB_S2M_CHANNEL_COUNT-1:0] mem2slave_wrresp_vld;

reg [15:0]            config_mem[`NUM_CONFIGS-1:0];

//Memory; `AXI_ADDR_WIDTH bits when byte addressable, remove some bits for offset within word
// Ugh. VCS's largest memory size is (supposedly) 2 GB - 1; but it only seems to support 1 GB - 1.
// And just to be clear, that's the total number of bits, so the highest address is 1 GB - 2, so we're missing a word of data...
reg /*sparse*/ [`MEM_WIDTH-1:0] memory[`MEM_SIZE-1:0];

reg channel_count;
wire [`TOTAL_SLAVE-1:0] s_write_q_tail_valid;
wire [`TOTAL_SLAVE-1:0] s_read_q_tail_valid;
reg [`AXI_ADDR_WIDTH-1-`LOG2_MEM:0] curr_mem_addr;
reg [`WORD_SIZE-1:0] curr_rd_data;
reg [`WORD_SIZE-1:0] mem2slave_rdresp_data_tmp[`TOTAL_SLAVE-1:0];
wire [`TOTAL_SLAVE*(`WORD_BYTES)-1:0] curr_wr_mask;
wire [`TOTAL_SLAVE*(`WORD_SIZE)-1:0]  curr_wr_data; 
wire [`TOTAL_SLAVE*(`AXI_ADDR_WIDTH-`LOG2_MEM)-1:0] curr_rd_addr; 
wire [`TOTAL_SLAVE*(`AXI_ADDR_WIDTH-`LOG2_MEM)-1:0] curr_wr_addr;
wire [`TOTAL_SLAVE*`AXI_LEN_WIDTH-1:0] curr_rd_len;
wire [`TOTAL_SLAVE*`AXI_LEN_WIDTH-1:0] curr_wr_len;
wire [`TOTAL_SLAVE*32-1:0] wr_perc;
wire [`TOTAL_SLAVE*32-1:0] rd_perc;
wire [`TOTAL_SLAVE-1:0] wr_ready;
wire [`TOTAL_SLAVE-1:0] rd_ready;
wire [`TOTAL_SLAVE*(`LOG2_Q)-1:0]rd_valid_id;

wire [16-1:0] perc;

// Signals for memory throttling.
// Fast clock based signals.
reg [`TOTAL_SLAVE-1:0] s_write_q_tail_valid_fast;
reg [`TOTAL_SLAVE-1:0] s_read_q_tail_valid_fast;
reg [`TOTAL_SLAVE*(`WORD_BYTES)-1:0] curr_wr_mask_fast;
reg [`TOTAL_SLAVE*(`WORD_SIZE)-1:0]  curr_wr_data_fast; 
reg [`TOTAL_SLAVE*(`AXI_ADDR_WIDTH-`LOG2_MEM)-1:0] curr_rd_addr_fast; 
reg [`TOTAL_SLAVE*(`AXI_ADDR_WIDTH-`LOG2_MEM)-1:0] curr_wr_addr_fast;
reg [`TOTAL_SLAVE*`AXI_LEN_WIDTH-1:0] curr_rd_len_fast;
reg [`TOTAL_SLAVE*`AXI_LEN_WIDTH-1:0] curr_wr_len_fast;


wire endOfPhase;

reg [`TOTAL_SLAVE*`AXI_LEN_WIDTH-1:0] size1, size2; 
reg [(1*`TOTAL_SLAVE)-1:0] valid1, valid2;
reg [(1*`TOTAL_SLAVE)-1:0] rdy1, rdy2;
reg [(1*`TOTAL_SLAVE)-1:0] rdy1Reg, rdy2Reg;
reg [(`TOTAL_SLAVE)-1:0] rdRdy, wrtRdy;

reg [15:0] blocksOutstandingScaled;
reg [15:0] blocksOutstandingScaledReg;


reg rdNotWrtPhaseReg;
reg rdNotWrtPhase;
reg [3:0] phaseReg;
reg [3:0] channel;
reg [3:0] channelReg;
reg [4:0] arbReg; // One more bit than channel:  { channel, rdNotWrtPhase }
reg [4:0] arbSave, arbSaveReg;
reg winner, winnerReg;

`ifndef SPYGLASS
`ifndef EMU_TB
event phase0Start; 
`endif
`endif

//assign wr_perc[(32*(`SLAVE_0+1)-1)-:32] = config_mem[`WR_PERC_0];
//assign rd_perc[(32*(`SLAVE_0+1)-1)-:32] = config_mem[`RD_PERC_0];
//assign wr_perc[(32*(`SLAVE_1+1)-1)-:32] = config_mem[`WR_PERC_1];
//assign rd_perc[(32*(`SLAVE_1+1)-1)-:32] = config_mem[`RD_PERC_1];
assign perc[16-1:0] = config_mem[`PERC_ALL]; //spyglass disable W123




//throttle throttle_full_bw (.fastClk(clk), .reset(reset), .perc(perc), .rdSize(rdSize), .wrtSize(wrtSize), .rdValid(rdValid), .wrtValid(wrtValid), .rdRdy(rdRdy) , .wrtRdy(wrtRdy) ); 


slave2mem_wr #(`SLAVE_0) slave2mem_wr_0 (
    .clk                        (slow_clk)
   ,.reset                      (reset)
   ,.slave2mem_cmd_wr           (slave2mem_cmd_wr[`SLAVE_0])
   ,.slave2mem_addr             (slave2mem_addr_wr[(`AXI_ADDR_WIDTH*(`SLAVE_0+1)-1)-:`AXI_ADDR_WIDTH])
   ,.slave2mem_data             (slave2mem_data[(`WORD_SIZE*(`SLAVE_0+1)-1)-:`WORD_SIZE])
   ,.slave2mem_wr_mask          (slave2mem_wr_mask[(`WORD_BYTES*(`SLAVE_0+1)-1)-:`WORD_BYTES])
   ,.slave2mem_len_wr           (slave2mem_len_wr[(`AXI_LEN_WIDTH*(`SLAVE_0+1)-1)-:`AXI_LEN_WIDTH])
   ,.mem2slave_wr_ready         (mem2slave_wr_ready[`SLAVE_0])
   ,.mem2slave_wrresp_vld       (mem2slave_wrresp_vld[`SLAVE_0])
   ,.q2mem_write_q_tail_valid   (s_write_q_tail_valid[`SLAVE_0])
   ,.q2mem_curr_wr_addr         (curr_wr_addr[((`AXI_ADDR_WIDTH-`LOG2_MEM)*(`SLAVE_0+1)-1)-:(`AXI_ADDR_WIDTH-`LOG2_MEM)])
   ,.q2mem_curr_wr_data         (curr_wr_data[(`WORD_SIZE*(`SLAVE_0+1)-1) -: `WORD_SIZE])
   ,.q2mem_curr_wr_mask         (curr_wr_mask[(`WORD_BYTES*(`SLAVE_0+1)-1)-:`WORD_BYTES])
   ,.q2mem_curr_wr_len          (curr_wr_len[(`AXI_LEN_WIDTH*(`SLAVE_0+1)-1)-:`AXI_LEN_WIDTH])
   ,.mem2q_wr_ready             (wr_ready[`SLAVE_0])
);

slave2mem_rd #(`SLAVE_0) slave2mem_rd_0 (
   .clk                         (slow_clk)
   ,.reset                      (reset)
   ,.slave2mem_cmd_rd           (slave2mem_cmd_rd[`SLAVE_0])
   ,.slave2mem_addr             (slave2mem_addr_rd[(`AXI_ADDR_WIDTH*(`SLAVE_0+1)-1)-:`AXI_ADDR_WIDTH])
   ,.mem2slave_rd_ready         (mem2slave_rd_ready[`SLAVE_0])
   ,.mem2slave_rdresp_vld       (mem2slave_rdresp_vld[`SLAVE_0])
   ,.mem2slave_rdresp_data      (mem2slave_rdresp_data[(`WORD_SIZE*(`SLAVE_0+1)-1)-:`WORD_SIZE])
   ,.slave2mem_len              (slave2mem_len_rd[(`AXI_LEN_WIDTH*(`SLAVE_0+1)-1)-:`AXI_LEN_WIDTH])
   ,.slave2mem_size             (slave2mem_size_rd[(`AXI_SIZE_WIDTH*(`SLAVE_0+1)-1)-:`AXI_SIZE_WIDTH])
   ,.s_read_q_tail_valid        (s_read_q_tail_valid[`SLAVE_0])
   ,.curr_tail                  (rd_valid_id[(`LOG2_Q*(`SLAVE_0+1)-1)-:`LOG2_Q])
   ,.curr_rd_addr               (curr_rd_addr[((`AXI_ADDR_WIDTH-`LOG2_MEM)*(`SLAVE_0+1)-1)-:(`AXI_ADDR_WIDTH-`LOG2_MEM)])
   ,.curr_rd_len                (curr_rd_len[(`AXI_LEN_WIDTH*(`SLAVE_0+1)-1)-:`AXI_LEN_WIDTH])
   ,.mem2slave_rdresp_data_tmp  (mem2slave_rdresp_data_tmp[`SLAVE_0])
   ,.rdresp_data_ready          (rd_ready[`SLAVE_0])
);

slave2mem_wr #(`SLAVE_1) slave2mem_wr_1 (
    .clk                        (slow_clk)
   ,.reset                      (reset)
   ,.slave2mem_cmd_wr           (slave2mem_cmd_wr[`SLAVE_1])
   ,.slave2mem_addr             (slave2mem_addr_wr[(`AXI_ADDR_WIDTH*(`SLAVE_1+1)-1)-:`AXI_ADDR_WIDTH])
   ,.slave2mem_data             (slave2mem_data[(`WORD_SIZE*(`SLAVE_1+1)-1)-:`WORD_SIZE])
   ,.slave2mem_wr_mask          (slave2mem_wr_mask[(`WORD_BYTES*(`SLAVE_1+1)-1)-:`WORD_BYTES])
   ,.slave2mem_len_wr           (slave2mem_len_wr[(`AXI_LEN_WIDTH*(`SLAVE_1+1)-1)-:`AXI_LEN_WIDTH])
   ,.mem2slave_wr_ready         (mem2slave_wr_ready[`SLAVE_1])
   ,.mem2slave_wrresp_vld       (mem2slave_wrresp_vld[`SLAVE_1])
   ,.q2mem_write_q_tail_valid   (s_write_q_tail_valid[`SLAVE_1])
   ,.q2mem_curr_wr_addr         (curr_wr_addr[((`AXI_ADDR_WIDTH-`LOG2_MEM)*(`SLAVE_1+1)-1)-:(`AXI_ADDR_WIDTH-`LOG2_MEM)])
   ,.q2mem_curr_wr_data         (curr_wr_data[(`WORD_SIZE*(`SLAVE_1+1)-1) -: `WORD_SIZE])
   ,.q2mem_curr_wr_mask         (curr_wr_mask[(`WORD_BYTES*(`SLAVE_1+1)-1)-:`WORD_BYTES])
   ,.q2mem_curr_wr_len          (curr_wr_len[(`AXI_LEN_WIDTH*(`SLAVE_1+1)-1)-:`AXI_LEN_WIDTH])
   ,.mem2q_wr_ready             (wr_ready[`SLAVE_1])
);

slave2mem_rd #(`SLAVE_1) slave2mem_rd_1 (
   .clk                         (slow_clk)
   ,.reset                      (reset)
   ,.slave2mem_cmd_rd           (slave2mem_cmd_rd[`SLAVE_1])
   ,.slave2mem_addr             (slave2mem_addr_rd[(`AXI_ADDR_WIDTH*(`SLAVE_1+1)-1)-:`AXI_ADDR_WIDTH])
   ,.mem2slave_rd_ready         (mem2slave_rd_ready[`SLAVE_1])
   ,.mem2slave_rdresp_vld       (mem2slave_rdresp_vld[`SLAVE_1])
   ,.mem2slave_rdresp_data      (mem2slave_rdresp_data[(`WORD_SIZE*(`SLAVE_1+1)-1)-:`WORD_SIZE])
   ,.slave2mem_len              (slave2mem_len_rd[(`AXI_LEN_WIDTH*(`SLAVE_1+1)-1)-:`AXI_LEN_WIDTH])
   ,.slave2mem_size             (slave2mem_size_rd[(`AXI_SIZE_WIDTH*(`SLAVE_1+1)-1)-:`AXI_SIZE_WIDTH])
   ,.s_read_q_tail_valid        (s_read_q_tail_valid[`SLAVE_1])
   ,.curr_tail                  (rd_valid_id[(`LOG2_Q*(`SLAVE_1+1)-1)-:`LOG2_Q])
   ,.curr_rd_addr               (curr_rd_addr[((`AXI_ADDR_WIDTH-`LOG2_MEM)*(`SLAVE_1+1)-1)-:(`AXI_ADDR_WIDTH-`LOG2_MEM)])
   ,.curr_rd_len                (curr_rd_len[(`AXI_LEN_WIDTH*(`SLAVE_1+1)-1)-:`AXI_LEN_WIDTH])
   ,.mem2slave_rdresp_data_tmp  (mem2slave_rdresp_data_tmp[`SLAVE_1])
   ,.rdresp_data_ready          (rd_ready[`SLAVE_1])
);

// spyglass disable_block W430 W213 SYNTH_5143
integer unsigned i;
initial begin
   $readmemh("slave_mem.cfg", config_mem);
end
// spyglass enable_block W430 W213 SYNTH_5143

assign rd_ready = rdRdy;
assign wr_ready = wrtRdy;


assign endOfPhase = (((phaseReg + 1) % `TOTAL_SLAVE) == 0) ? 1'b1 : 1'b0;

//spyglass disable_block W238
always @(posedge clk or negedge reset) begin
   if(!reset)begin
		channelReg <= 0;
		rdNotWrtPhaseReg <= 0;
		phaseReg <= 0;
		rdy1Reg <= 0;
		rdy2Reg <= 0;
		rdRdy <= 0;
		wrtRdy <= 0;

		blocksOutstandingScaledReg <= 0;
		arbReg <= 0;
		winnerReg <= 0;
		arbSaveReg <= 0;

	end
	else begin
		blocksOutstandingScaled = blocksOutstandingScaledReg;
		arbSave = arbSaveReg;


		// Start from the channel last used.
		// Needed to avoid channel bias.
		if (phaseReg == 0) begin
			{ channel, rdNotWrtPhase } = arbReg;
			winner = 0;
			rdy1 = {`TOTAL_SLAVE{1'b0}};
			rdy2 = {`TOTAL_SLAVE{1'b0}};
`ifndef SPYGLASS
`ifndef EMU_TB
-> phase0Start;
`endif
`endif
		end
		else begin
			channel = (channelReg + 1)  % `TOTAL_SLAVE;
			rdNotWrtPhase = rdNotWrtPhaseReg;
			winner = winnerReg;
			rdy1 = rdy1Reg;
			rdy2 = rdy2Reg;
		end

		valid1 = (rdNotWrtPhase == 1'b1) ?
			s_read_q_tail_valid_fast & ~rdRdy : s_write_q_tail_valid_fast & ~wrtRdy;
		valid2 = (rdNotWrtPhase == 1'b1) ?
			s_write_q_tail_valid_fast & ~wrtRdy : s_read_q_tail_valid_fast & ~rdRdy;

		// Mux valid and ready lines.
		size1 = (rdNotWrtPhase == 1'b1) ? curr_rd_len_fast : curr_wr_len_fast;
		size2 = (rdNotWrtPhase == 1'b1) ? curr_wr_len_fast : curr_rd_len_fast;

		// Decrement  to account for AXI use.
		// Each phase represents one channel read/write access to memory.  
		// At the start of each cycle through all the channels, account for bandwidth 
		// that could have been used.  
		if (phaseReg == 0) begin
			// Don't decrement below 0.
                        if (blocksOutstandingScaled < (`MAX_PORTS * perc)) begin //spyglass disable W362
				blocksOutstandingScaled = 0;
			end
			else begin
				blocksOutstandingScaled = blocksOutstandingScaled - (`MAX_PORTS * perc);
			end
		end



		// valid1 == 1 && rdNotWrtPhaseReg == 1 => read
		if ((valid1[channel] == 1'b1)) begin //spyglass disable SYNTH_5130 
//$display ("    chan=%d valid1 rdNotWrtPhaseReg=%d blocks=%d perc*PORTS=%d", channel, rdNotWrtPhase, blocksOutstandingScaled, perc * `MAX_PORTS);
			// If memory utilization >= than perc allocation, back off future transactions.
			if (blocksOutstandingScaled >= (perc * `MAX_PORTS)) begin //spyglass disable W362
//$display ("    chan=%d valid1 rdy1=0", channel);
				rdy1 [channel] = 1'b0; //spyglass disable SYNTH_5130 

			end
			// If memory utlization <= perc allocation, then add weighted size into blocksOutstanding.
			else begin
				if (winner == 1'b0) begin
					arbSave = ({ channel, rdNotWrtPhase } + 1) % (`TOTAL_SLAVE * 2);
					winner = 1'b1;
				end

				blocksOutstandingScaled = blocksOutstandingScaled +
					((((size1 >> (channel * `AXI_LEN_WIDTH)) & (4'b1111)) + 1) * `SCALE_FACTOR);
				rdy1 [channel] = 1'b1; //spyglass disable SYNTH_5130 

				if (rdNotWrtPhase == 1'b1) begin
					//Slave Read

					curr_mem_addr = curr_rd_addr_fast[((`AXI_ADDR_WIDTH-`LOG2_MEM)*(channel+1)-1)-:(`AXI_ADDR_WIDTH-`LOG2_MEM)]; //spyglass disable SignedUnsignedExpr-ML SYNTH_5130
`ifdef MEM_WIDTH_32B
					curr_rd_data[255:0]   = memory[curr_mem_addr];
					curr_rd_data[511:256] = memory[curr_mem_addr+1];
`endif
`ifdef MEM_WIDTH_4B
//spyglass disable_block SYNTH_5130
					curr_rd_data[31:0]    = memory[curr_mem_addr];
					curr_rd_data[63:32]   = memory[curr_mem_addr+1];
					curr_rd_data[95:64]   = memory[curr_mem_addr+2];
					curr_rd_data[127:96]  = memory[curr_mem_addr+3];
					curr_rd_data[159:128] = memory[curr_mem_addr+4];
					curr_rd_data[191:160] = memory[curr_mem_addr+5];
					curr_rd_data[223:192] = memory[curr_mem_addr+6];
					curr_rd_data[255:224] = memory[curr_mem_addr+7];
					curr_rd_data[287:256] = memory[curr_mem_addr+8];
					curr_rd_data[319:288] = memory[curr_mem_addr+9];
					curr_rd_data[351:320] = memory[curr_mem_addr+10];
					curr_rd_data[383:352] = memory[curr_mem_addr+11];
					curr_rd_data[415:384] = memory[curr_mem_addr+12];
					curr_rd_data[447:416] = memory[curr_mem_addr+13];
					curr_rd_data[479:448] = memory[curr_mem_addr+14];
					curr_rd_data[511:480] = memory[curr_mem_addr+15];
//spyglass enable_block SYNTH_5130
`endif
					mem2slave_rdresp_data_tmp[channel] <= curr_rd_data;
`ifdef AXI_MEM_DEBUG
					$display("%0t memory_temp: channel=%d, curr_addr=0x%010x, curr_data=0x%0128x",$time, channel,curr_mem_addr, curr_rd_data); //spyglass disable W213 SYNTH_5166
`endif
				end // if rdNotNotWrtPhaseReg
				else begin
      				//Slave write
`ifdef AXI_MEM_DEBUG
$display ("rdy1=%h rdy1Reg=%h wrtRdy=%h wr_ready=%h", rdy1, rdy1Reg, wrtRdy, wr_ready); //spyglass disable W213 SYNTH_5166
`endif
					for( i = 0; i < `WORD_BYTES; i=i+1 ) begin
						if( curr_wr_mask_fast[`WORD_BYTES*channel+i] ) begin
							memory[curr_wr_addr_fast[((`AXI_ADDR_WIDTH-`LOG2_MEM)*(channel+1)-1)-:(`AXI_ADDR_WIDTH-`LOG2_MEM)]+(i/`MEM_BYTES)][(i%`MEM_BYTES)*8 +: 8] <= curr_wr_data_fast[(`WORD_SIZE*channel+i*8) +: 8];// spyglass disable SignedUnsignedExpr-ML [channel][i*8 +: 8];
						end // if
					end // for
					$display("%0t SMEM: Slave %d wrote address 0x%010x data 0x%0128x", $time, channel, ((`AXI_ADDR_WIDTH'b0 + curr_wr_addr_fast[((`AXI_ADDR_WIDTH-`LOG2_MEM)*(channel+1)-1)-:(`AXI_ADDR_WIDTH-`LOG2_MEM)]) * `MEM_BYTES) + `DLA_ADDR_START, curr_wr_data_fast[(`WORD_SIZE*(channel+1)-1)-:`WORD_SIZE]); //spyglass disable W213 SYNTH_5166 SignedUnsignedExpr-ML 
				end // else rdNotWrtPhase
			end // else

		end // if valid1

		// valid2 == 1 && rdNotWrtPhaseReg == 1 => write
		if ((valid2[channel] == 1'b1)) begin
//$display ("    chan=%d valid2 rdNotWrtPhaseReg=%d blocks=%d perc*PORTS=%d", channel, rdNotWrtPhase, blocksOutstandingScaled, perc * `MAX_PORTS);
			// If memory utilization >= than perc allocation, back off future transactions.
			if (blocksOutstandingScaled >= (perc * `MAX_PORTS)) begin //spyglass disable W362
//$display ("    chan=%d valid2 rdy2=0", channel);
				rdy2 [channel] = 1'b0;

			end
			// If memory utlization <= perc allocation, then add weighted size into blocksOutstanding.
			else begin
				if (winner == 1'b0) begin
					arbSave = ({ channel, rdNotWrtPhase } + 1) % (`TOTAL_SLAVE * 2);
					winner = 1'b1;
				end

				blocksOutstandingScaled = blocksOutstandingScaled +
					((((size2 >> (channel * `AXI_LEN_WIDTH)) & (4'b1111)) + 1) * `SCALE_FACTOR);
				rdy2 [channel] = 1'b1;

				if (rdNotWrtPhase == 1'b0) begin
					//Slave Read

					curr_mem_addr = curr_rd_addr_fast[((`AXI_ADDR_WIDTH-`LOG2_MEM)*(channel+1)-1)-:(`AXI_ADDR_WIDTH-`LOG2_MEM)];//spyglass disable SignedUnsignedExpr-ML
`ifdef MEM_WIDTH_32B
					curr_rd_data[255:0]   = memory[curr_mem_addr];
					curr_rd_data[511:256] = memory[curr_mem_addr+1];
`endif
`ifdef MEM_WIDTH_4B
					curr_rd_data[31:0]    = memory[curr_mem_addr];
					curr_rd_data[63:32]   = memory[curr_mem_addr+1];
					curr_rd_data[95:64]   = memory[curr_mem_addr+2];
					curr_rd_data[127:96]  = memory[curr_mem_addr+3];
					curr_rd_data[159:128] = memory[curr_mem_addr+4];
					curr_rd_data[191:160] = memory[curr_mem_addr+5];
					curr_rd_data[223:192] = memory[curr_mem_addr+6];
					curr_rd_data[255:224] = memory[curr_mem_addr+7];
					curr_rd_data[287:256] = memory[curr_mem_addr+8];
					curr_rd_data[319:288] = memory[curr_mem_addr+9];
					curr_rd_data[351:320] = memory[curr_mem_addr+10];
					curr_rd_data[383:352] = memory[curr_mem_addr+11];
					curr_rd_data[415:384] = memory[curr_mem_addr+12];
					curr_rd_data[447:416] = memory[curr_mem_addr+13];
					curr_rd_data[479:448] = memory[curr_mem_addr+14];
					curr_rd_data[511:480] = memory[curr_mem_addr+15];
`endif
					mem2slave_rdresp_data_tmp[channel] <= curr_rd_data;
`ifdef AXI_MEM_DEBUG
					$display("%0t memory_temp: channel=%d, curr_addr=0x%010x, curr_data=0x%0128x",$time, channel,curr_mem_addr, curr_rd_data); //spyglass disable W213 SYNTH_5166
`endif
				end // if rdNotNotWrtPhaseReg
				else begin
      				//Slave write
`ifdef AXI_MEM_DEBUG
$display ("rdy2=%h rdy2Reg=%h wrtRdy=%h wr_ready=%h", rdy2, rdy2Reg, wrtRdy, wr_ready); //spyglass disable W213 SYNTH_5166
`endif
					for( i = 0; i < `WORD_BYTES; i=i+1 ) begin
						if( curr_wr_mask_fast[`WORD_BYTES*channel+i] ) begin
							memory[curr_wr_addr_fast[((`AXI_ADDR_WIDTH-`LOG2_MEM)*(channel+1)-1)-:(`AXI_ADDR_WIDTH-`LOG2_MEM)]+(i/`MEM_BYTES)][(i%`MEM_BYTES)*8 +: 8] <= curr_wr_data_fast[(`WORD_SIZE*channel+i*8) +: 8];//spyglass disable SignedUnsignedExpr-ML [channel][i*8 +: 8];
						end // if
					end // for
					$display("%0t SMEM: Slave %d wrote address 0x%010x data 0x%0128x", $time, channel, ((`AXI_ADDR_WIDTH'b0 + curr_wr_addr_fast[((`AXI_ADDR_WIDTH-`LOG2_MEM)*(channel+1)-1)-:(`AXI_ADDR_WIDTH-`LOG2_MEM)]) * `MEM_BYTES) + `DLA_ADDR_START, curr_wr_data_fast[(`WORD_SIZE*(channel+1)-1)-:`WORD_SIZE]);  //spyglass disable W213 SYNTH_5166 SignedUnsignedExpr-ML 
				end // else rdNotWrtPhase
			end //else
		end


		blocksOutstandingScaledReg <= blocksOutstandingScaled;

		rdNotWrtPhaseReg <= rdNotWrtPhase;
		arbReg <= (endOfPhase) ? arbSave : arbReg;
		arbSaveReg <= arbSave;
		winnerReg <= winner;

		rdy1Reg <= rdy1;
		rdy2Reg <= rdy2;


		rdRdy <= (endOfPhase) ?
			((rdNotWrtPhase == 1'b1) ? rdy1 : rdy2) : rdRdy;
		wrtRdy <= (endOfPhase) ?
			((rdNotWrtPhase == 1'b1) ? rdy2 : rdy1) : wrtRdy;


		channelReg <= channel;

		phaseReg <= (phaseReg + 1) % `TOTAL_SLAVE;

		// Sync slow clock signals at end of phase of fast clock.
		s_write_q_tail_valid_fast <= (endOfPhase) ? 
			s_write_q_tail_valid : s_write_q_tail_valid_fast;
		s_read_q_tail_valid_fast <= (endOfPhase) ?
			s_read_q_tail_valid : s_read_q_tail_valid_fast;
		curr_wr_mask_fast <= (endOfPhase) ?
			curr_wr_mask : curr_wr_mask_fast;
		curr_wr_data_fast <= (endOfPhase) ?
			curr_wr_data : curr_wr_data_fast;
		curr_rd_addr_fast <= (endOfPhase) ?
			curr_rd_addr : curr_rd_addr_fast;
		curr_wr_addr_fast <= (endOfPhase) ?
			curr_wr_addr : curr_wr_addr_fast;
		curr_rd_len_fast <= (endOfPhase) ?
			curr_rd_len : curr_rd_len_fast;
		curr_wr_len_fast <= (endOfPhase) ?
			curr_wr_len : curr_wr_len_fast;


	end

end // always
assert_module a3 (.clk(clk),.test((`MAX_PORTS * perc)>19'hffff));
endmodule


