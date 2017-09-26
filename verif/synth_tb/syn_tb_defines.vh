
// AXI Related - used by Master/Slave
`define AXI_AID_WIDTH           8
`define AXI_SLAVE_BID_WIDTH     `AXI_AID_WIDTH
`define AXI_SLAVE_RID_WIDTH     `AXI_AID_WIDTH
`define AXI_SLAVE_WID_WIDTH     `AXI_AID_WIDTH

`define AXI_ADDR_WIDTH          32
`define AXI_LEN_WIDTH           4
`define AXI_SIZE_WIDTH          3
`define DATABUS2MEM_WIDTH       512

`define ADDR_FIFO_DATA_LEN      `AXI_AID_WIDTH + `AXI_ADDR_WIDTH + `AXI_LEN_WIDTH + `AXI_SIZE_WIDTH
`define WDATA_FIFO_DATA_LEN     `AXI_AID_WIDTH + `DATABUS2MEM_WIDTH /* 64 Bytes data */
`define ID_FIFO_DATA_LEN        `AXI_AID_WIDTH + `AXI_ADDR_WIDTH + `AXI_LEN_WIDTH + 1 /* 1 bit for the command sent to memory rd/write */

`define SAXI2MEM_CMD_WR     1'b1
`define SAXI2MEM_CMD_RD     1'b0

// DLA Address Range from 0x8000_0000 ~ 0x8000_0000
`define DLA_ADDR_START  32'h8000_0000

/*****************************************************
 *************** MASTER SEQ RELATED ******************
 *****************************************************/ 
`define MSEQ_CMD_SIZE 384
`define MSEQ_OP_BITS 127:120
`define MSEQ_ADDR_BITS 119:88
`define MSEQ_DATA_BITS 87:56
`define MSEQ_MASK_BITS 55:24
`define MSEQ_COMPARE_BITS 23:16
`define MSEQ_NPOLLS_BITS 15:0
`define MSEQ_FILENAME_BITS 383:128
`define MSEQ_MEM_ADDR_BITS 119:80
`define MSEQ_MEM_SIZE_BITS 79:48

//PD_BITS are the top 16 bits of addr
`define MSEQ_PD_BITS 119:105
`define MSEQ_RW_PD_BITS 104
//DATA_PD_BITS are the data bits
`define MSEQ_DATA_PD_BITS 87:56
//PD_BITS are the lower 16 bits of addr
`define MSEQ_ADDR_PD_BITS 103:88

`define MSEQ_OP_REG_WRITE 8'h00
`define MSEQ_OP_REG_READ  8'h01
`define MSEQ_OP_MEM_WRITE 8'h02
`define MSEQ_OP_MEM_READ  8'h03
`define MSEQ_OP_MEM_LOAD  8'h04
`define MSEQ_OP_MEM_DUMP  8'h05
`define MSEQ_OP_WAIT      8'h06
`define MSEQ_OP_DONE      8'hff

`define MSEQ_NUM_CMDS 2000000

/*****************************************************
 ************* SYNTH MEMORY RELATED ******************
 *****************************************************/ 

// Added by Nathan
//`define ZEBU 1
`ifdef ZEBU
   `define NO_PERFMON_HISTOGRAM 1
   `define NO_DUMPS 1
   `define MEM_WIDTH_32B
   `define EMU_TB
`else
   // NOTE: If changing the memory width define, you MUST also change the word size in synth_tb/sim_scripts/inp_txn_to_hexdump.pl!!!
   `define MEM_WIDTH_4B
`endif

`ifdef CADENCE
   `define EMU_TB
`endif


`ifdef MEM_WIDTH_32B
   `define MEM_WIDTH   256
   `ifdef ZEBU
      `define MEM_SIZE    (2**25)
      `define ZRM_CHANGE_BYTES   (`MEM_BYTES/8)
      `define ZRM_LOG2_MEM    ($clog2((`MEM_WIDTH/8))-3)
   `else
      `define MEM_SIZE    (2**25 - 1)
   `endif
`endif
`ifdef MEM_WIDTH_4B
   `define MEM_WIDTH   32
   `define MEM_SIZE    (2**28 - 1)
`endif

`define MEM_BYTES   (`MEM_WIDTH/8)
`define LOG2_MEM    ($clog2(`MEM_WIDTH)-3)

`define DLA_CLOCK_DIVIDE              2
`define DLATB_S2M_CHANNEL_COUNT       2

// Define offsets inside the config_mem to find these configuration parameters
`define NUM_CONFIGS           24
`define S0_MAX_READS          0
`define S0_MAX_WRITES         1
`define S0_MAX_TOTAL          2
`define S0_READ_LATENCY       3
`define S0_WRITE_LATENCY      4
`define S1_MAX_READS          5
`define S1_MAX_WRITES         6
`define S1_MAX_TOTAL          7
`define S1_READ_LATENCY       8
`define S1_WRITE_LATENCY      9
`define MSEQ_POLL_INTERVAL_HI 10
`define MSEQ_POLL_INTERVAL_LO 11
`define MSEQ_RD_TIMEOUT_HI    12
`define MSEQ_RD_TIMEOUT_LO    13
`define MSEQ_WR_TIMEOUT_HI    14
`define MSEQ_WR_TIMEOUT_LO    15
`define MSEQ_CONT_ON_FAIL     16
`define MSEQ_RD_POLLS_HI      17
`define MSEQ_RD_POLLS_LO      18
`define WR_PERC_0             19
`define RD_PERC_0             20
`define WR_PERC_1             21
`define RD_PERC_1             22
`define PERC_ALL              23

`define WORD_SIZE   512
`define WORD_BYTES  (`WORD_SIZE/8)

//This is the ceiling log 2 of word_size, minus 3 (ie divide by 8 bits per byte); this gets the number of address bits used for the word offset
//This is the address size needed for the word size above.
`define LOG2_WORD $clog2(`WORD_SIZE)-3

`define RD_VALID        0
`define RD_ADDR_RANGE   (`AXI_ADDR_WIDTH-`LOG2_MEM):1
`define RD_LEN_RANGE    (`AXI_ADDR_WIDTH-`LOG2_MEM+`AXI_LEN_WIDTH):(`AXI_ADDR_WIDTH+1-`LOG2_MEM)

`define WR_VALID      0
`define WR_MASK_MIN   1
`define WR_MASK_RANGE `WORD_BYTES:1
`define WR_ADDR_RANGE (`WORD_BYTES+`AXI_ADDR_WIDTH-`LOG2_MEM):(`WORD_BYTES+1)
`define WR_LEN_RANGE  (`WORD_BYTES+`AXI_ADDR_WIDTH+`AXI_LEN_WIDTH-`LOG2_MEM):(`WORD_BYTES+`AXI_ADDR_WIDTH+1-`LOG2_MEM)
`define WR_Q_MAX      (`WORD_BYTES+`WORD_SIZE+`AXI_ADDR_WIDTH+`AXI_LEN_WIDTH-`LOG2_MEM)
`define WR_DATA_RANGE `WR_Q_MAX:(`WORD_BYTES+41+`AXI_LEN_WIDTH-`LOG2_MEM)

//Adjust latencies by measured latency from nvdla2saxi_axi_slave_wvalid to saxi2nvdla_axi_slave_bvalid
//and nvdla2saxi_axi_slave_arvalid to saxi2nvdla_axi_slave_rvalid to hit the programmed latency.
//The programmed latencies should be larger than this for correct behavior.
`define WRITE_LATENCY_CORRECTION 8
`define READ_LATENCY_CORRECTION  7

//QUEUE_SIZE must be larger than the largest latency (plus extra, in case reads and writes would be scheduled in the same cycle)
`define QUEUE_SIZE  2048
`define LOG2_Q      ($clog2(`QUEUE_SIZE))


//the max in-progress write requests that share same id
`define MAX_WRITE_CONFLICT 64

`define SLAVE_0      0
`define SLAVE_1      1
`define TOTAL_SLAVE  2


// Each channel includes a read port and a write port.
//`define MAX_PORTS         (`TOTAL_SLAVE*2)
`define MAX_PORTS           4
// Want to scale sizes to 100 so that easy perc calc can be made.
`define SCALE_FACTOR        100




