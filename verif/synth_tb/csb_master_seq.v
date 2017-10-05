
`include "syn_tb_defines.vh"

module csb_master_seq (
   clk,
   reset,
   
   mseq_pending_req,
   mcsb2mseq_consumed_req,
   mseq2mcsb_pd,
   mcsb2mseq_rdata,
   mcsb2mseq_rvalid,

   dut2mseq_intr0,
   mseq2tb_test_done
);

input clk;
input reset;

output reg        mseq_pending_req;
input             mcsb2mseq_consumed_req;
output reg [62:0] mseq2mcsb_pd;
input      [31:0] mcsb2mseq_rdata;
input             mcsb2mseq_rvalid;

input             dut2mseq_intr0;
output reg        mseq2tb_test_done;




parameter MSEQ_IDLE   = 8'h0;
parameter MSEQ_REG_RD = 8'h1;
parameter MSEQ_REG_RD_WAIT_RESP = 8'h2;
parameter MSEQ_REG_RD_POLL_WAIT = 8'h3;
parameter MSEQ_REG_RD_MISMATCH = 8'h4;
parameter MSEQ_REG_RD_TIMEOUT = 8'h5;
parameter MSEQ_REG_WR = 8'h8;
parameter MSEQ_REG_WR_WAIT_RESP = 8'h9;
parameter MSEQ_REG_WR_TIMEOUT = 8'ha;
parameter MSEQ_MEM_RD = 8'h10;
parameter MSEQ_MEM_WR = 8'h18;
parameter MSEQ_MEM_LD = 8'h20;
parameter MSEQ_MEM_DMP = 8'h28;
parameter MSEQ_WAIT = 8'h30;
parameter MSEQ_WAIT_TIMEOUT = 8'h31;
parameter MSEQ_BOOT_1 = 8'hfd;
parameter MSEQ_BOOT_2 = 8'hfe;
parameter MSEQ_DONE = 8'hff;

parameter EQ = 8'h0;
parameter LE = 8'h1;
parameter GE = 8'h2;

reg [`MSEQ_CMD_SIZE-1:0] cmd_memory[`MSEQ_NUM_CMDS-1:0];
reg [`MSEQ_CMD_SIZE-1:0] curr_cmd;
reg [`MSEQ_CONFIG_SIZE-1:0]               config_mem[`NUM_CONFIGS-1:0];

wire [`MSEQ_OP_BITS]       curr_cmd_op;
wire [`MSEQ_DATA_BITS]     curr_cmd_data;
//wire [`MSEQ_MASK_BITS]     curr_cmd_mask;
// wire [`MSEQ_NPOLLS_BITS]   curr_cmd_polls;
// assign curr_cmd_polls   = curr_cmd[`MSEQ_NPOLLS_BITS];
// Make this wider and specified by the config file, not by the test file (despite the signal name)
reg [31:0]                 curr_cmd_polls;
assign curr_cmd_op      = curr_cmd[`MSEQ_OP_BITS];
assign curr_cmd_data    = curr_cmd[`MSEQ_DATA_BITS];



reg [31:0] line;
reg [31:0] line_next;
reg  [7:0] cs, ns;
reg [`MSEQ_CONFIG_SIZE-1:0] timer;
reg [`MSEQ_CONFIG_SIZE-1:0] timer_next;
reg [`MSEQ_CONFIG_SIZE-1:0] count;
reg [`MSEQ_CONFIG_SIZE-1:0] count_next;
reg [31:0] response;

reg [`MSEQ_MEM_ADDR_BITS] memory_start_address;
reg [`MSEQ_MEM_ADDR_BITS] memory_end_address;
reg dump_main_memory;
reg load_main_memory;

// FIXME: Knobs?
reg [`MSEQ_CONFIG_SIZE-1:0] read_reg_poll_interval;
reg [`MSEQ_CONFIG_SIZE-1:0] read_timeout;
reg [`MSEQ_CONFIG_SIZE-1:0] write_timeout;
reg [`MSEQ_CONFIG_SIZE-1:0] wait_timeout;
reg        continue_on_fail;

wire [31:0] boot_timer;
assign boot_timer = 10; //may not be needed

// No x's
integer i;
//Change data size to a define
reg [31:0] rdata_no_x;
always @* begin
   for( i = 0; i < 32; i=i+1 ) begin
      if(mcsb2mseq_rdata[i]) rdata_no_x[i] = 1'b1; else rdata_no_x[i] = 1'b0;
   end
end

initial begin //spyglass disable W430
   `ifdef ZEBU
      $readmemh("input.txn.zebu", cmd_memory); //spyglass disable W213
   `else
      $readmemh("input.txn.raw", cmd_memory); //spyglass disable W213
   `endif
   $readmemh("slave_mem.cfg", config_mem); //spyglass disable W213
end

always @(posedge clk or negedge reset) begin
   if(!reset) begin
      cs <= MSEQ_BOOT_1;
      line <= 0;
      read_reg_poll_interval <= config_mem[`MSEQ_POLL_INTERVAL];
      read_timeout <= config_mem[`MSEQ_RD_TIMEOUT];
      write_timeout <= config_mem[`MSEQ_WR_TIMEOUT];
      write_timeout <= config_mem[`MSEQ_INTR_TIMEOUT];
      continue_on_fail <= config_mem[`MSEQ_CONT_ON_FAIL][0];
      curr_cmd_polls <= config_mem[`MSEQ_RD_POLLS];
      cs <= MSEQ_BOOT_1;
      line <= 0;
      count <= 0;
      timer <= 0;
   end else begin
      cs <= ns;
      line <= line_next;
      count <= count_next;
      timer <= timer_next;
   end
end

// Calculate next state
always @* begin
   ns = cs;
   case(cs)
      MSEQ_IDLE : begin
         curr_cmd = cmd_memory[line];
         case(curr_cmd_op)
            `MSEQ_OP_DONE      : ns = MSEQ_DONE;
            `MSEQ_OP_REG_READ  : ns = MSEQ_REG_RD;
            `MSEQ_OP_REG_WRITE : ns = MSEQ_REG_WR;
            `MSEQ_OP_MEM_READ  : ns = MSEQ_MEM_RD;
            `MSEQ_OP_MEM_WRITE : ns = MSEQ_MEM_WR;
            `MSEQ_OP_MEM_LOAD  : ns = MSEQ_MEM_LD;
            `MSEQ_OP_MEM_DUMP  : ns = MSEQ_MEM_DMP;
            `MSEQ_OP_WAIT      : ns = MSEQ_WAIT;
         endcase
      end
      MSEQ_WAIT : begin
         if(dut2mseq_intr0 == 1)
            ns = MSEQ_IDLE;
         else begin
            if ( timer > wait_timeout ) begin
              ns = MSEQ_WAIT_TIMEOUT;
            end else begin
              ns = MSEQ_WAIT;
            end
         end
      end
      MSEQ_WAIT_TIMEOUT : begin
         if( continue_on_fail ) begin
            ns = MSEQ_IDLE;
         end else begin
            ns = MSEQ_DONE;
         end
      end
      MSEQ_REG_RD : begin
         if(count > curr_cmd_polls)
            ns = MSEQ_REG_RD_MISMATCH;
         else begin
            ns = MSEQ_REG_RD_WAIT_RESP;
         end
      end
      MSEQ_REG_RD_WAIT_RESP : begin
         if( timer > read_timeout )
            ns = MSEQ_REG_RD_TIMEOUT;
         else if( mcsb2mseq_rvalid ) begin
            response = rdata_no_x; 
            case( curr_cmd[`MSEQ_COMPARE_BITS] )
               EQ : begin
                  //TODO: mask
                  if( (rdata_no_x) == (curr_cmd_data) ) begin
                     ns = MSEQ_IDLE;
                  end else begin
                     ns = MSEQ_REG_RD_POLL_WAIT;
                  end
               end
               GE : begin
                  //TODO: mask
                  if( (rdata_no_x ) >= (curr_cmd_data ) ) begin
                     ns = MSEQ_IDLE;
                  end else begin
                     ns = MSEQ_REG_RD_POLL_WAIT;
                  end
               end
               LE : begin
                  //TODO: mask
                  if( (rdata_no_x ) <= (curr_cmd_data ) ) begin
                     ns = MSEQ_IDLE;
                  end else begin
                     ns = MSEQ_REG_RD_POLL_WAIT;
                  end
               end
            endcase
         end else
            ns = MSEQ_REG_RD_WAIT_RESP;
      end //MSEQ_REG_RD_WAIT_RESP
      MSEQ_REG_RD_POLL_WAIT : begin
         if(timer > read_reg_poll_interval)
            ns = MSEQ_REG_RD;
         else
            ns = MSEQ_REG_RD_POLL_WAIT;
      end
      MSEQ_REG_RD_MISMATCH : begin
         if( continue_on_fail ) begin
            ns = MSEQ_IDLE;
         end else begin
            ns = MSEQ_DONE;
         end
      end
      MSEQ_REG_RD_TIMEOUT : begin
         if( continue_on_fail ) begin
            ns = MSEQ_IDLE;
         end else begin
            ns = MSEQ_DONE;
         end
      end
      MSEQ_REG_WR : begin
         ns = MSEQ_REG_WR_WAIT_RESP;
      end
      MSEQ_REG_WR_WAIT_RESP : begin
         if( timer > write_timeout)
            ns = MSEQ_REG_WR_TIMEOUT;
         else if( mcsb2mseq_rvalid )
            //FIXME - do we care about the write status, or just that some response came back?
            ns = MSEQ_IDLE;
      end
      MSEQ_REG_WR_TIMEOUT : begin
         if( continue_on_fail ) begin
            ns = MSEQ_IDLE;
         end else begin
            ns = MSEQ_DONE;
         end
      end
      MSEQ_MEM_LD : begin
         ns = MSEQ_IDLE;
         //$readmemh(curr_cmd[`MSEQ_FILENAME_BITS], top.slave_mem_wrap.syn_mem.memory, curr_cmd[`MSEQ_MEM_ADDR_BITS]/(`MEM_BYTES) - 32'h100_0000, (curr_cmd[`MSEQ_MEM_ADDR_BITS] + curr_cmd[`MSEQ_MEM_SIZE_BITS])/(`MEM_BYTES) - 32'h100_0000 - 1);
      end
      MSEQ_MEM_DMP : begin
         ns = MSEQ_IDLE;
         //$writememh(curr_cmd[`MSEQ_FILENAME_BITS], top.slave_mem_wrap.syn_mem.memory, curr_cmd[`MSEQ_MEM_ADDR_BITS]/(`MEM_BYTES) - 32'h100_0000, (curr_cmd[`MSEQ_MEM_ADDR_BITS] + curr_cmd[`MSEQ_MEM_SIZE_BITS])/(`MEM_BYTES) - 32'h100_0000 - 1);
      end
      
      MSEQ_BOOT_1 : begin
         ns = MSEQ_BOOT_2;
      end
      MSEQ_BOOT_2 : begin
         if( timer > boot_timer )
            ns = MSEQ_IDLE;
         else
            ns = MSEQ_BOOT_2;
      end
      MSEQ_DONE : begin
         ns = MSEQ_DONE;
`ifdef ZEBU
         top.dollar_finish = 1'b1;
`else
         #500ns;
         $finish; //spyglass disable W213
`endif
      end
      default : begin
         if( reset ) begin
            $display("%0t MSEQ: ERROR: Unsupported command in master sequencer.", $time); //spyglass disable W213
            ns = MSEQ_DONE;
         end
      end
   endcase
end

// Display debug/error info
always @(posedge clk) begin
   case(cs)
      MSEQ_REG_RD: begin
         if( count == 0 ) begin
            $display("%0t MSEQ: read_cmd address 0x%08x with data 0x%08x and mask 0x%08x (command %0d)", $time, curr_cmd[`MSEQ_ADDR_BITS], curr_cmd[`MSEQ_DATA_BITS], curr_cmd[`MSEQ_MASK_BITS], line - 5); //spyglass disable W213
         end
      end
      MSEQ_REG_WR: begin
         $display("%0t MSEQ: write_cmd address 0x%08x with data 0x%08x (command %0d)", $time, curr_cmd[`MSEQ_ADDR_BITS], curr_cmd[`MSEQ_DATA_BITS], line - 5); //spyglass disable W213
      end
      MSEQ_REG_RD_MISMATCH: begin
         if( continue_on_fail ) begin
            $display("%0t MSEQ: Read to address 0x%08x did not return the expected value 0x%08x after %0d attempts (last read 0x%08x), but continuing anyway.", 
                     $time, curr_cmd[`MSEQ_ADDR_BITS], curr_cmd[`MSEQ_DATA_BITS], curr_cmd[`MSEQ_NPOLLS_BITS], response); //spyglass disable W213
         end else begin
            $display("%0t MSEQ: ERROR: Read to address 0x%08x did not return the expected value 0x%08x after %0d attempts (last read 0x%08x), failing.", 
                     $time, curr_cmd[`MSEQ_ADDR_BITS], curr_cmd[`MSEQ_DATA_BITS], curr_cmd[`MSEQ_NPOLLS_BITS], response); //spyglass disable W213
         end
      end
      MSEQ_REG_RD_TIMEOUT: begin
         if( continue_on_fail ) begin
            $display("%0t MSEQ: Timed out waiting for register read on 0x%08x, continuing...", $time, curr_cmd[`MSEQ_ADDR_BITS]); //spyglass disable W213
         end else begin
            $display("%0t MSEQ: ERROR: Timeout waiting for register read on 0x%08x, failing.", $time, curr_cmd[`MSEQ_ADDR_BITS]); //spyglass disable W213
         end
      end
      MSEQ_REG_WR_TIMEOUT: begin
         if( continue_on_fail ) begin
            $display("%0t MSEQ: Timed out waiting for register write on 0x%08x, continuing...", $time, curr_cmd[`MSEQ_ADDR_BITS]); //spyglass disable W213
         end else begin
            $display("%0t MSEQ: ERROR: Timeout waiting for register write on 0x%08x, failing.", $time, curr_cmd[`MSEQ_ADDR_BITS]); //spyglass disable W213
         end
      end
      MSEQ_WAIT_TIMEOUT: begin
         if( continue_on_fail ) begin
            $display("%0t MSEQ: Timed out waiting for interrupt, continuing...", $time, curr_cmd[`MSEQ_ADDR_BITS]); //spyglass disable W213
         end else begin
            $display("%0t MSEQ: ERROR: Timeout waiting for interrupt, failing.", $time, curr_cmd[`MSEQ_ADDR_BITS]); //spyglass disable W213
         end
      end
      MSEQ_REG_RD_POLL_WAIT: begin
         if( timer == 1 )
            $display("%0t MSEQ: Retrying read at 0x%08x (returned 0x%08x, expected 0x%08x)...", $time, curr_cmd[`MSEQ_ADDR_BITS], response, curr_cmd[`MSEQ_DATA_BITS]); //spyglass disable W213
      end
      MSEQ_REG_WR_WAIT_RESP : begin
         if( mcsb2mseq_rvalid )
            $display("%0t MSEQ: Write (command %0d) completed (addr: 0x%08x, data: 0x%08x.", $time, line - 5, curr_cmd[`MSEQ_ADDR_BITS], curr_cmd[`MSEQ_DATA_BITS]); //spyglass disable W213
      end
      MSEQ_REG_RD_WAIT_RESP : begin
         if( ns == MSEQ_IDLE )
            //Line - 5: -1 because line has advanced already, -5 more to negate the boot code automatically inserted in the test, and +1 so that we're using 1-based indexing.
            $display("%0t MSEQ: Read (command %0d) matched (addr: 0x%08x, received data: 0x%08x, expected data: 0x%08x.", $time, line - 5, curr_cmd[`MSEQ_ADDR_BITS], response, curr_cmd[`MSEQ_DATA_BITS]); //spyglass disable W213
         else if( ns == MSEQ_REG_RD_POLL_WAIT )
            $display("%0t MSEQ: Read mismatched, retrying (addr: 0x%08x, received data:  0x%08x, expected data: 0x%08x.", $time, curr_cmd[`MSEQ_ADDR_BITS], response, curr_cmd[`MSEQ_DATA_BITS]); //spyglass disable W213
      end
      MSEQ_MEM_LD : begin
         $display("%0t MSEQ: Backdoor mem_load of file %s at address 0x%08x for length 0x%08x.", $time, curr_cmd[`MSEQ_FILENAME_BITS], curr_cmd[`MSEQ_MEM_ADDR_BITS], curr_cmd[`MSEQ_MEM_SIZE_BITS]);//spyglass disable W213
      end
      MSEQ_MEM_DMP : begin
         $display("%0t MSEQ: Backdoor mem_dump of file %s at address 0x%08x for length 0x%08x.", $time, curr_cmd[`MSEQ_FILENAME_BITS], curr_cmd[`MSEQ_MEM_ADDR_BITS], curr_cmd[`MSEQ_MEM_SIZE_BITS]);//spyglass disable W213
      end
   endcase
end

// Translate state machine to outputs
always @(posedge clk) begin
   if(!reset) begin
      mseq2tb_test_done <= 0;
   end else begin
      case(cs)
         MSEQ_BOOT_1: mseq2tb_test_done <= 0;
         MSEQ_IDLE: begin
            mseq2mcsb_pd <= 0;
            mseq_pending_req <= 0;
            mseq2tb_test_done <= 0;
            load_main_memory <= 0;
            dump_main_memory <= 0;
         end
         MSEQ_REG_RD: begin
            mseq_pending_req <= 1;
            mseq2mcsb_pd[62:55] <= curr_cmd[`MSEQ_PD_BITS];
            mseq2mcsb_pd[54] <= 0; //Reads set this bit to 0
            mseq2mcsb_pd[21:0] <= {6'b0,curr_cmd[`MSEQ_ADDR_PD_BITS]};
            mseq2mcsb_pd[53:22] <= curr_cmd[`MSEQ_DATA_PD_BITS];
         end
         MSEQ_REG_RD_WAIT_RESP: begin
            mseq_pending_req <= 0;
         // drop pd signals?
         end
         MSEQ_REG_WR: begin
            mseq_pending_req <= 1;
            mseq2mcsb_pd[62:55] <= curr_cmd[`MSEQ_PD_BITS];
            mseq2mcsb_pd[54] <= 1; //Writes set this bit to 1
            mseq2mcsb_pd[21:0] <= {6'b0,curr_cmd[`MSEQ_ADDR_PD_BITS]};
            mseq2mcsb_pd[53:22] <= curr_cmd[`MSEQ_DATA_PD_BITS];
         end
         MSEQ_REG_WR_WAIT_RESP: begin
            mseq_pending_req <= 0;
         // drop pd signals?
         end
         MSEQ_MEM_LD : begin
   `ifdef ZEBU
            // This will be handled by zemi3 xtor
   `elsif CADENCE
            //Loai: this command for 256bit memory as it needs -retainValue -retainValueOffset
            `ifdef MEM_WIDTH_32B
               if ((curr_cmd[`MSEQ_MEM_ADDR_BITS] & `DLA_ADDR_MASK) == `DBB_ADDR_START) begin
                 $qel("memory -load %%readmemh slave_mem_wrap.dbb_mem.memory -file %s -start %d -end %d -retainValue -retainValueOffset",curr_cmd[`MSEQ_FILENAME_BITS], curr_cmd[`MSEQ_MEM_ADDR_BITS]/(`MEM_BYTES) - (`DBB_ADDR_START >> `LOG2_MEM), (curr_cmd[`MSEQ_MEM_ADDR_BITS] + curr_cmd[`MSEQ_MEM_SIZE_BITS] - 1)/(`MEM_BYTES) - (`DBB_ADDR_START >> `LOG2_MEM));
               end else if((curr_cmd[`MSEQ_MEM_ADDR_BITS] & `DLA_ADDR_MASK) == `CVSRAM_ADDR_START) begin
                 $qel("memory -load %%readmemh slave_mem_wrap.cvsram_mem.memory -file %s -start %d -end %d -retainValue -retainValueOffset",curr_cmd[`MSEQ_FILENAME_BITS], curr_cmd[`MSEQ_MEM_ADDR_BITS]/(`MEM_BYTES) - (`CVSRAM_ADDR_START >> `LOG2_MEM), (curr_cmd[`MSEQ_MEM_ADDR_BITS] + curr_cmd[`MSEQ_MEM_SIZE_BITS] - 1)/(`MEM_BYTES) - (`CVSRAM_ADDR_START >> `LOG2_MEM));
              end
            `else
               if ((curr_cmd[`MSEQ_MEM_ADDR_BITS] & `DLA_ADDR_MASK) == `DBB_ADDR_START) begin
                 $readmemh(curr_cmd[`MSEQ_FILENAME_BITS], top.slave_mem_wrap.dbb_mem.memory, curr_cmd[`MSEQ_MEM_ADDR_BITS]/(`MEM_BYTES) - (`DBB_ADDR_START >> `LOG2_MEM), (curr_cmd[`MSEQ_MEM_ADDR_BITS] + curr_cmd[`MSEQ_MEM_SIZE_BITS] - 1)/(`MEM_BYTES) - (`DBB_ADDR_START >> `LOG2_MEM));
               end else if((curr_cmd[`MSEQ_MEM_ADDR_BITS] & `DLA_ADDR_MASK) == `CVSRAM_ADDR_START) begin
                 $readmemh(curr_cmd[`MSEQ_FILENAME_BITS], top.slave_mem_wrap.cvsram_mem.memory, curr_cmd[`MSEQ_MEM_ADDR_BITS]/(`MEM_BYTES) - (`CVSRAM_ADDR_START >> `LOG2_MEM), (curr_cmd[`MSEQ_MEM_ADDR_BITS] + curr_cmd[`MSEQ_MEM_SIZE_BITS] - 1)/(`MEM_BYTES) - (`CVSRAM_ADDR_START >> `LOG2_MEM));
               end else
                 $display("Error: Address in input.txn for loading file to memory is outside defined regions, DBB_ADDR_START or CSVRAM_ADDR_START");
                 $finish;
               end
             `endif
   `else
              `ifndef SPYGLASS
            //e.g load_mem 0x80000000 0x400 sample_surf.dat
            // if sample_surf.dat is first file loaded it turns into 0.raw2
            // 0.raw2 is read through curr_cmd[`MSEQ_FILENAME_BITS]
            // putting it into top.slave_mem_wrap.dbb_mem.memory
            // curr_cmd[MSEQ_MEM_ADDR_BITS=80000000] MEM_BYTES=MEM_WIDTH/8=32/8=4
            // DBB_ADDR_START=0x80000000 LOG2_MEM=log2(MEM_WIDTH)-3=5-3=2
            // 3rd arguments = 80000000/4 - (0x80000000 >> 2) = 0
            // size (4th arg) = 3rd arg + 0x400/4 - 1 = 0xff
            if ((curr_cmd[`MSEQ_MEM_ADDR_BITS] & `DLA_ADDR_MASK) == `DBB_ADDR_START) begin
              $readmemh(curr_cmd[`MSEQ_FILENAME_BITS], top.slave_mem_wrap.dbb_mem.memory, curr_cmd[`MSEQ_MEM_ADDR_BITS]/(`MEM_BYTES) - (`DBB_ADDR_START >> `LOG2_MEM), (curr_cmd[`MSEQ_MEM_ADDR_BITS] + curr_cmd[`MSEQ_MEM_SIZE_BITS] - 1)/(`MEM_BYTES) - (`DBB_ADDR_START >> `LOG2_MEM));
            end else if((curr_cmd[`MSEQ_MEM_ADDR_BITS] & `DLA_ADDR_MASK) == `CVSRAM_ADDR_START) begin
              $readmemh(curr_cmd[`MSEQ_FILENAME_BITS], top.slave_mem_wrap.cvsram_mem.memory, curr_cmd[`MSEQ_MEM_ADDR_BITS]/(`MEM_BYTES) - (`CVSRAM_ADDR_START >> `LOG2_MEM), (curr_cmd[`MSEQ_MEM_ADDR_BITS] + curr_cmd[`MSEQ_MEM_SIZE_BITS] - 1)/(`MEM_BYTES) - (`CVSRAM_ADDR_START >> `LOG2_MEM));
            end
              `endif
   `endif
            if ((curr_cmd[`MSEQ_MEM_ADDR_BITS] & `DLA_ADDR_MASK) == `DBB_ADDR_START) begin
              memory_start_address <= curr_cmd[`MSEQ_MEM_ADDR_BITS]/(`MEM_BYTES) - (`DBB_ADDR_START >> `LOG2_MEM);
              memory_end_address <= (curr_cmd[`MSEQ_MEM_ADDR_BITS] + curr_cmd[`MSEQ_MEM_SIZE_BITS])/(`MEM_BYTES) - (`DBB_ADDR_START >> `LOG2_MEM) - 1;
              load_main_memory <= 1;
            end else if((curr_cmd[`MSEQ_MEM_ADDR_BITS] & `DLA_ADDR_MASK) == `CVSRAM_ADDR_START) begin
              memory_start_address <= curr_cmd[`MSEQ_MEM_ADDR_BITS]/(`MEM_BYTES) - (`CVSRAM_ADDR_START >> `LOG2_MEM);
              memory_end_address <= (curr_cmd[`MSEQ_MEM_ADDR_BITS] + curr_cmd[`MSEQ_MEM_SIZE_BITS])/(`MEM_BYTES) - (`CVSRAM_ADDR_START >> `LOG2_MEM) - 1;
              load_main_memory <= 1;
            end
         end
         MSEQ_MEM_DMP : begin
   `ifdef EMU_TB
            // This will be handled by zemi3 xtor
   `else
            if ((curr_cmd[`MSEQ_MEM_ADDR_BITS] & `DLA_ADDR_MASK) == `DBB_ADDR_START) begin
                $writememh(curr_cmd[`MSEQ_FILENAME_BITS], top.slave_mem_wrap.dbb_mem.memory, curr_cmd[`MSEQ_MEM_ADDR_BITS]/(`MEM_BYTES) - (`DBB_ADDR_START >> `LOG2_MEM), (curr_cmd[`MSEQ_MEM_ADDR_BITS] + curr_cmd[`MSEQ_MEM_SIZE_BITS] - 1)/(`MEM_BYTES) - (`DBB_ADDR_START >> `LOG2_MEM));
            end else if((curr_cmd[`MSEQ_MEM_ADDR_BITS] & `DLA_ADDR_MASK) == `CVSRAM_ADDR_START) begin
                $writememh(curr_cmd[`MSEQ_FILENAME_BITS], top.slave_mem_wrap.cvsram_mem.memory, curr_cmd[`MSEQ_MEM_ADDR_BITS]/(`MEM_BYTES) - (`CVSRAM_ADDR_START >> `LOG2_MEM), (curr_cmd[`MSEQ_MEM_ADDR_BITS] + curr_cmd[`MSEQ_MEM_SIZE_BITS] - 1)/(`MEM_BYTES) - (`CVSRAM_ADDR_START >> `LOG2_MEM));
            end
   `endif
            if ((curr_cmd[`MSEQ_MEM_ADDR_BITS] & `DLA_ADDR_MASK) == `DBB_ADDR_START) begin
                memory_start_address <= curr_cmd[`MSEQ_MEM_ADDR_BITS]/(`MEM_BYTES) - (`DBB_ADDR_START >> `LOG2_MEM);
                memory_end_address <= (curr_cmd[`MSEQ_MEM_ADDR_BITS] + curr_cmd[`MSEQ_MEM_SIZE_BITS])/(`MEM_BYTES) - (`DBB_ADDR_START >> `LOG2_MEM) - 1;
                dump_main_memory <= 1;
            end else if((curr_cmd[`MSEQ_MEM_ADDR_BITS] & `DLA_ADDR_MASK) == `CVSRAM_ADDR_START) begin
                memory_start_address <= curr_cmd[`MSEQ_MEM_ADDR_BITS]/(`MEM_BYTES) - (`CVSRAM_ADDR_START >> `LOG2_MEM);
                memory_end_address <= (curr_cmd[`MSEQ_MEM_ADDR_BITS] + curr_cmd[`MSEQ_MEM_SIZE_BITS])/(`MEM_BYTES) - (`CVSRAM_ADDR_START >> `LOG2_MEM) - 1;
                dump_main_memory <= 1;
            end
         end
         
         MSEQ_DONE: begin
            mseq2mcsb_pd <= 0;
            mseq2tb_test_done <= 1;
         end
         default : begin
            mseq2mcsb_pd <= 1'bx;
            mseq2tb_test_done <= 1'bx;
         end
      endcase
   end
end

`ifdef CADENCE
always @(posedge clk) begin
   if (cs == MSEQ_MEM_DMP) begin
      //Loai: this command for 256bit memory as it needs -retainValue -retainValueOffset for memory load
      `ifdef MEM_WIDTH_32B
          if ((curr_cmd[`MSEQ_MEM_ADDR_BITS] & `DLA_ADDR_MASK) == `DBB_ADDR_START) begin
             $qel("memory -dump %%readmemh slave_mem_wrap.dbb_mem.memory -file %s -start %d -end %d", curr_cmd[`MSEQ_FILENAME_BITS], curr_cmd[`MSEQ_MEM_ADDR_BITS]/(`MEM_BYTES) - (`DBB_ADDR_START >> `LOG2_MEM), (curr_cmd[`MSEQ_MEM_ADDR_BITS] + curr_cmd[`MSEQ_MEM_SIZE_BITS] - 1)/(`MEM_BYTES) - (`DBB_ADDR_START >> `LOG2_MEM));
          end else if((curr_cmd[`MSEQ_MEM_ADDR_BITS] & `DLA_ADDR_MASK) == `CVSRAM_ADDR_START) begin
             $qel("memory -dump %%readmemh slave_mem_wrap.cvsram_mem.memory -file %s -start %d -end %d", curr_cmd[`MSEQ_FILENAME_BITS], curr_cmd[`MSEQ_MEM_ADDR_BITS]/(`MEM_BYTES) - (`CVSRAM_ADDR_START >> `LOG2_MEM), (curr_cmd[`MSEQ_MEM_ADDR_BITS] + curr_cmd[`MSEQ_MEM_SIZE_BITS] - 1)/(`MEM_BYTES) - (`CVSRAM_ADDR_START >> `LOG2_MEM));
         end
      `else
         //Everything up to the least significant 1 of ADDR_START should be 0 in the mask
         if ((curr_cmd[`MSEQ_MEM_ADDR_BITS] & `DLA_ADDR_MASK) == `DBB_ADDR_START) begin
             $writememh(curr_cmd[`MSEQ_FILENAME_BITS], top.slave_mem_wrap.dbb_mem.memory, curr_cmd[`MSEQ_MEM_ADDR_BITS]/(`MEM_BYTES) - (`DBB_ADDR_START >> `LOG2_MEM), (curr_cmd[`MSEQ_MEM_ADDR_BITS] + curr_cmd[`MSEQ_MEM_SIZE_BITS])/(`MEM_BYTES) - (`DBB_ADDR_START >> `LOG2_MEM) - 1);
         end else if((curr_cmd[`MSEQ_MEM_ADDR_BITS] & `DLA_ADDR_MASK) == `CVSRAM_ADDR_START) begin
             $writememh(curr_cmd[`MSEQ_FILENAME_BITS], top.slave_mem_wrap.cvsram_mem.memory, curr_cmd[`MSEQ_MEM_ADDR_BITS]/(`MEM_BYTES) - (`CVSRAM_ADDR_START >> `LOG2_MEM), (curr_cmd[`MSEQ_MEM_ADDR_BITS] + curr_cmd[`MSEQ_MEM_SIZE_BITS])/(`MEM_BYTES) - (`CVSRAM_ADDR_START >> `LOG2_MEM) - 1);
         end
         //dump_main_memory <= 1;
      `endif
   end
end
`endif

// Run timers
// Review the following case statement : Might have missing cases. Currently requires the default.
always @* begin
      line_next  = line;
      count_next = count;
      timer_next = timer;
 
   if( !reset ) begin
      line_next  = 0;
      count_next = 0;
      timer_next = 0;
   end else begin
      case(cs)
         MSEQ_IDLE: begin
            line_next = line + 1;
            count_next = 0;
         end
         MSEQ_REG_RD: begin
            count_next = count + 1;
            timer_next = 0;
         end
         MSEQ_REG_RD_WAIT_RESP: begin
            if((timer <= read_timeout) && mcsb2mseq_rvalid)
               timer_next = 0;
            else
               timer_next = timer + 1;
         end
         MSEQ_REG_RD_POLL_WAIT: begin
            timer_next = timer + 1;
         end
         MSEQ_REG_WR: begin
            timer_next = 0;
         end
         MSEQ_REG_WR_WAIT_RESP: begin
            timer_next = timer + 1;
         end
         MSEQ_WAIT: begin
            if((timer <= read_timeout) && dut2mseq_intr0)
               timer_next = 0;
            else
               timer_next = timer + 1;
         end
         MSEQ_BOOT_1: begin
            timer_next = 0;
         end
         MSEQ_BOOT_2: begin
            timer_next = timer + 1;
         end
         default: begin
            line_next  = line;
            count_next = count;
            timer_next = timer;
         end
      endcase
   end
end

endmodule
