
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
parameter MEM_ADDR_START=`DLA_ADDR_START; //Should be instanced with DBB_ or CVSRAM_ADDR_START
parameter TOTAL_MEM_SIZE=`MEM_SIZE; //Should be instanced with DBB or CVSRAM_MEM_SIZE

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

reg [`MSEQ_CONFIG_SIZE-1:0]            config_mem[`NUM_CONFIGS-1:0];

//Memory; `AXI_ADDR_WIDTH bits when byte addressable, remove some bits for offset within word
// Ugh. VCS's largest memory size is (supposedly) 2 GB - 1; but it only seems to support 1 GB - 1.
// And just to be clear, that's the total number of bits, so the highest address is 1 GB - 2, so we're missing a word of data...
reg /*sparse*/ [`MEM_WIDTH-1:0] memory[TOTAL_MEM_SIZE-1:0];

wire s_write_q_tail_valid;
wire s_read_q_tail_valid;
reg [`AXI_ADDR_WIDTH-1-`LOG2_MEM:0] curr_mem_addr;
reg [`WORD_SIZE-1:0] curr_rd_data;
reg [`WORD_SIZE-1:0] mem2slave_rdresp_data_tmp;
wire [`WORD_BYTES-1:0] curr_wr_mask;
wire [`WORD_SIZE-1:0]  curr_wr_data; 
wire [`AXI_ADDR_WIDTH-`LOG2_MEM-1:0] curr_rd_addr; 
wire [`AXI_ADDR_WIDTH-`LOG2_MEM-1:0] curr_wr_addr;
wire [`AXI_LEN_WIDTH-1:0] curr_rd_len;
wire [`AXI_LEN_WIDTH-1:0] curr_wr_len;
wire [`MSEQ_CONFIG_SIZE-1:0] wr_perc;
wire [`MSEQ_CONFIG_SIZE-1:0] rd_perc;
wire wr_ready;
wire rd_ready;
wire [`LOG2_Q-1:0]rd_valid_id;

wire [`MSEQ_CONFIG_SIZE-1:0] perc;

// Signals for memory throttling.
// Fast clock based signals.
reg s_write_q_tail_valid_fast;
reg s_read_q_tail_valid_fast;
reg [`WORD_BYTES-1:0] curr_wr_mask_fast;
reg [`WORD_SIZE-1:0]  curr_wr_data_fast; 
reg [`AXI_ADDR_WIDTH-`LOG2_MEM-1:0] curr_rd_addr_fast; 
reg [`AXI_ADDR_WIDTH-`LOG2_MEM-1:0] curr_wr_addr_fast;
reg [`AXI_LEN_WIDTH-1:0] curr_rd_len_fast;
reg [`AXI_LEN_WIDTH-1:0] curr_wr_len_fast;


wire endOfPhase;

reg [`AXI_LEN_WIDTH-1:0] size1, size2; 
reg valid1, valid2;
reg rdy1, rdy2;
reg rdRdy, wrtRdy;

reg [15:0] blocksOutstandingScaled;
reg [15:0] blocksOutstandingScaledReg;


reg rdNotWrtPhase;
reg [2:0] phaseReg;
reg winner;

assign wr_perc[`MSEQ_CONFIG_SIZE-1:0] = config_mem[`WR_PERC_0];
assign rd_perc[`MSEQ_CONFIG_SIZE-1:0] = config_mem[`RD_PERC_0];
assign perc[`MSEQ_CONFIG_SIZE-1:0] = config_mem[`PERC_ALL]; //spyglass disable W123




//throttle throttle_full_bw (.fastClk(clk), .reset(reset), .perc(perc), .rdSize(rdSize), .wrtSize(wrtSize), .rdValid(rdValid), .wrtValid(wrtValid), .rdRdy(rdRdy) , .wrtRdy(wrtRdy) ); 


slave2mem_wr #(`SLAVE_0, MEM_ADDR_START) slave2mem_wr_0 (
    .clk                        (slow_clk)
   ,.reset                      (reset)
   ,.slave2mem_cmd_wr           (slave2mem_cmd_wr[`SLAVE_0])
   ,.slave2mem_addr             (slave2mem_addr_wr[(`AXI_ADDR_WIDTH*(`SLAVE_0+1)-1)-:`AXI_ADDR_WIDTH])
   ,.slave2mem_data             (slave2mem_data[(`WORD_SIZE*(`SLAVE_0+1)-1)-:`WORD_SIZE])
   ,.slave2mem_wr_mask          (slave2mem_wr_mask[(`WORD_BYTES*(`SLAVE_0+1)-1)-:`WORD_BYTES])
   ,.slave2mem_len_wr           (slave2mem_len_wr[(`AXI_LEN_WIDTH*(`SLAVE_0+1)-1)-:`AXI_LEN_WIDTH])
   ,.mem2slave_wr_ready         (mem2slave_wr_ready[`SLAVE_0])
   ,.mem2slave_wrresp_vld       (mem2slave_wrresp_vld[`SLAVE_0])
   ,.q2mem_write_q_tail_valid   (s_write_q_tail_valid)
   ,.q2mem_curr_wr_addr         (curr_wr_addr[((`AXI_ADDR_WIDTH-`LOG2_MEM)*(`SLAVE_0+1)-1)-:(`AXI_ADDR_WIDTH-`LOG2_MEM)])
   ,.q2mem_curr_wr_data         (curr_wr_data[(`WORD_SIZE*(`SLAVE_0+1)-1) -: `WORD_SIZE])
   ,.q2mem_curr_wr_mask         (curr_wr_mask[(`WORD_BYTES*(`SLAVE_0+1)-1)-:`WORD_BYTES])
   ,.q2mem_curr_wr_len          (curr_wr_len[(`AXI_LEN_WIDTH*(`SLAVE_0+1)-1)-:`AXI_LEN_WIDTH])
   ,.mem2q_wr_ready             (wr_ready)
);

slave2mem_rd #(`SLAVE_0, MEM_ADDR_START) slave2mem_rd_0 (
   .clk                         (slow_clk)
   ,.reset                      (reset)
   ,.slave2mem_cmd_rd           (slave2mem_cmd_rd[`SLAVE_0])
   ,.slave2mem_addr             (slave2mem_addr_rd[(`AXI_ADDR_WIDTH*(`SLAVE_0+1)-1)-:`AXI_ADDR_WIDTH])
   ,.mem2slave_rd_ready         (mem2slave_rd_ready[`SLAVE_0])
   ,.mem2slave_rdresp_vld       (mem2slave_rdresp_vld[`SLAVE_0])
   ,.mem2slave_rdresp_data      (mem2slave_rdresp_data[(`WORD_SIZE*(`SLAVE_0+1)-1)-:`WORD_SIZE])
   ,.slave2mem_len              (slave2mem_len_rd[(`AXI_LEN_WIDTH*(`SLAVE_0+1)-1)-:`AXI_LEN_WIDTH])
   ,.slave2mem_size             (slave2mem_size_rd[(`AXI_SIZE_WIDTH*(`SLAVE_0+1)-1)-:`AXI_SIZE_WIDTH])
   ,.s_read_q_tail_valid        (s_read_q_tail_valid)
   ,.curr_tail                  (rd_valid_id[(`LOG2_Q*(`SLAVE_0+1)-1)-:`LOG2_Q])
   ,.curr_rd_addr               (curr_rd_addr[((`AXI_ADDR_WIDTH-`LOG2_MEM)*(`SLAVE_0+1)-1)-:(`AXI_ADDR_WIDTH-`LOG2_MEM)])
   ,.curr_rd_len                (curr_rd_len[(`AXI_LEN_WIDTH*(`SLAVE_0+1)-1)-:`AXI_LEN_WIDTH])
   ,.mem2slave_rdresp_data_tmp  (mem2slave_rdresp_data_tmp)
   ,.rdresp_data_ready          (rd_ready)
);

// spyglass disable_block W430 W213 SYNTH_5143
integer unsigned i;
initial begin
   $readmemh("slave_mem.cfg", config_mem);
end
// spyglass enable_block W430 W213 SYNTH_5143

assign rd_ready = rdRdy;
assign wr_ready = wrtRdy;


assign endOfPhase = phaseReg % 4;

//spyglass disable_block W238
always @(posedge clk or negedge reset) begin
   if(!reset)begin
        phaseReg <= 0;
        rdRdy <= 0;
        wrtRdy <= 0;

        blocksOutstandingScaledReg <= 0;
        rdy1 <= 0; 
        rdy2 <= 0;
        rdNotWrtPhase <= 0;

    end
    else begin
        blocksOutstandingScaled = blocksOutstandingScaledReg;
        winner = 0;
        valid1 = (rdNotWrtPhase == 1'b1) ?
            s_read_q_tail_valid_fast & ~rdRdy : s_write_q_tail_valid_fast & ~wrtRdy;
        valid2 = (rdNotWrtPhase == 1'b1) ?
            s_write_q_tail_valid_fast & ~wrtRdy : s_read_q_tail_valid_fast & ~rdRdy;

        rdy1 = 0; 
        rdy2 = 0;

        // Mux valid and ready lines.
        size1 = (rdNotWrtPhase == 1'b1) ? curr_rd_len_fast : curr_wr_len_fast;
        size2 = (rdNotWrtPhase == 1'b1) ? curr_wr_len_fast : curr_rd_len_fast;

        // Decrement  to account for AXI use.
        // Each phase represents one read/write access to memory.  
        // At the start of each cycle account for bandwidth 
        // that could have been used.  
            // Don't decrement below 0.
            if (blocksOutstandingScaled < (`MAX_PORTS * perc)) begin //spyglass disable W362
                blocksOutstandingScaled = 0;
            end
            else begin
                blocksOutstandingScaled = blocksOutstandingScaled - (`MAX_PORTS * perc);
            end



        // valid1 == 1 && rdNotWrtPhase == 1 => read
        if ((valid1 == 1'b1)) begin //spyglass disable SYNTH_5130 
//$display ("    valid1 rdNotWrtPhase=%d blocks=%d perc*PORTS=%d", rdNotWrtPhase, blocksOutstandingScaled, perc * `MAX_PORTS);
            // If memory utilization >= than perc allocation, back off future transactions.
            if (blocksOutstandingScaled >= (perc * `MAX_PORTS)) begin //spyglass disable W362
//$display ("   valid1 rdy1=0", );
                rdy1  = 1'b0; //spyglass disable SYNTH_5130 

            end
            // If memory utlization <= perc allocation, then add weighted size into blocksOutstanding.
            else begin
                if (winner == 1'b0) begin
                    winner = 1'b1;
                end

                blocksOutstandingScaled = blocksOutstandingScaled +
                    (((size1 & (4'b1111)) + 1) * `SCALE_FACTOR);
                rdy1 = 1'b1; //spyglass disable SYNTH_5130 

                if (rdNotWrtPhase == 1'b1) begin
                    //Slave Read

                    curr_mem_addr = curr_rd_addr_fast[((`AXI_ADDR_WIDTH-`LOG2_MEM)-1)-:(`AXI_ADDR_WIDTH-`LOG2_MEM)]; //spyglass disable SignedUnsignedExpr-ML SYNTH_5130
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
                    mem2slave_rdresp_data_tmp <= curr_rd_data;
`ifdef AXI_MEM_DEBUG
                    $display("%0t memory_temp: curr_addr=0x%010x, curr_data=0x%0128x",$time, curr_mem_addr, curr_rd_data); //spyglass disable W213 SYNTH_5166
`endif
                end // if rdNotNotWrtPhaseReg
                else begin
                      //Slave write
`ifdef AXI_MEM_DEBUG
$display ("rdy1=%h wrtRdy=%h wr_ready=%h", rdy1, wrtRdy, wr_ready); //spyglass disable W213 SYNTH_5166
`endif
                    for( i = 0; i < `WORD_BYTES; i=i+1 ) begin
                        if( curr_wr_mask_fast[+i] ) begin
                            memory[curr_wr_addr_fast[((`AXI_ADDR_WIDTH-`LOG2_MEM)-1)-:(`AXI_ADDR_WIDTH-`LOG2_MEM)]+(i/`MEM_BYTES)][(i%`MEM_BYTES)*8 +: 8] <= curr_wr_data_fast[(i*8) +: 8];// spyglass disable SignedUnsignedExpr-ML [i*8 +: 8];
                        end // if
                    end // for
                                        $display("%0t SMEM: Slave wrote address 0x%010x data 0x%0128x", $time, ((`AXI_ADDR_WIDTH'b0 + curr_wr_addr_fast[((`AXI_ADDR_WIDTH-`LOG2_MEM)-1)-:(`AXI_ADDR_WIDTH-`LOG2_MEM)]) * `MEM_BYTES) + MEM_ADDR_START, curr_wr_data_fast[(`WORD_SIZE-1)-:`WORD_SIZE]); //spyglass disable W213 SYNTH_5166 SignedUnsignedExpr-ML
                end // else rdNotWrtPhase
            end // else

        end // if valid1

        // valid2 == 1 && rdNotWrtPhase == 1 => write
        if ((valid2 == 1'b1)) begin
//$display ("    valid2 rdNotWrtPhase=%d blocks=%d perc*PORTS=%d", rdNotWrtPhase, blocksOutstandingScaled, perc * `MAX_PORTS);
            // If memory utilization >= than perc allocation, back off future transactions.
            if (blocksOutstandingScaled >= (perc * `MAX_PORTS)) begin //spyglass disable W362
//$display ("    valid2 rdy2=0" );
                rdy2 = 1'b0;

            end
            // If memory utlization <= perc allocation, then add weighted size into blocksOutstanding.
            else begin
                if (winner == 1'b0) begin
                    winner = 1'b1;
                end

                blocksOutstandingScaled = blocksOutstandingScaled +
                    (((size2 & (4'b1111)) + 1) * `SCALE_FACTOR);
                rdy2 = 1'b1;

                if (rdNotWrtPhase == 1'b0) begin
                    //Slave Read

                    curr_mem_addr = curr_rd_addr_fast[((`AXI_ADDR_WIDTH-`LOG2_MEM)-1)-:(`AXI_ADDR_WIDTH-`LOG2_MEM)];//spyglass disable SignedUnsignedExpr-ML
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
                    mem2slave_rdresp_data_tmp <= curr_rd_data;
`ifdef AXI_MEM_DEBUG
                    $display("%0t memory_temp: curr_addr=0x%010x, curr_data=0x%0128x",$time, curr_mem_addr, curr_rd_data); //spyglass disable W213 SYNTH_5166
`endif
                end // if rdNotNotWrtPhaseReg
                else begin
                      //Slave write
`ifdef AXI_MEM_DEBUG
$display ("rdy2=%h wrtRdy=%h wr_ready=%h", rdy2, wrtRdy, wr_ready); //spyglass disable W213 SYNTH_5166
`endif
                    for( i = 0; i < `WORD_BYTES; i=i+1 ) begin
                        if( curr_wr_mask_fast[i] ) begin
                            memory[curr_wr_addr_fast[((`AXI_ADDR_WIDTH-`LOG2_MEM)-1)-:(`AXI_ADDR_WIDTH-`LOG2_MEM)]+(i/`MEM_BYTES)][(i%`MEM_BYTES)*8 +: 8] <= curr_wr_data_fast[(i*8) +: 8];//spyglass disable SignedUnsignedExpr-ML [i*8 +: 8];
                        end // if
                    end // for
                                        $display("%0t SMEM: Slave wrote address 0x%010x data 0x%0128x", $time, ((`AXI_ADDR_WIDTH'b0 + curr_wr_addr_fast[((`AXI_ADDR_WIDTH-`LOG2_MEM)-1)-:(`AXI_ADDR_WIDTH-`LOG2_MEM)]) * `MEM_BYTES) + MEM_ADDR_START, curr_wr_data_fast[(`WORD_SIZE-1)-:`WORD_SIZE]);  //spyglass disable W213 SYNTH_5166 SignedUnsignedExpr-ML
                end // else rdNotWrtPhase
            end //else
        end

        blocksOutstandingScaledReg <= blocksOutstandingScaled;

        rdRdy <= (rdNotWrtPhase == 1'b1) ? rdy1 : rdy2;
        wrtRdy <= (rdNotWrtPhase == 1'b1) ? rdy2 : rdy1;

        phaseReg <= (phaseReg + 1) % 4;
        rdNotWrtPhase <= phaseReg % 2;

        // Sync slow clock signals at end of phase of fast clock.
        s_write_q_tail_valid_fast <= s_write_q_tail_valid;
        s_read_q_tail_valid_fast <=  s_read_q_tail_valid;
        curr_wr_mask_fast <= curr_wr_mask;
        curr_wr_data_fast <= curr_wr_data;
        curr_rd_addr_fast <= curr_rd_addr;
        curr_wr_addr_fast <= curr_wr_addr;
        curr_rd_len_fast <=  curr_rd_len;
        curr_wr_len_fast <=  curr_wr_len;
    end

end // always
assert_module a3 (.clk(clk),.test((`MAX_PORTS * perc)>19'hffff));
endmodule


