
// AXI Related - used by Master/Slave
`define AXI_AID_WIDTH           8
`define AXI_SLAVE_BID_WIDTH     `AXI_AID_WIDTH
`define AXI_SLAVE_RID_WIDTH     `AXI_AID_WIDTH
`define AXI_SLAVE_WID_WIDTH     `AXI_AID_WIDTH

`define AXI_ADDR_WIDTH          64
`define AXI_LEN_WIDTH           4
`define AXI_SIZE_WIDTH          3
`define DATABUS2MEM_WIDTH       512

`define ADDR_FIFO_DATA_LEN      `AXI_AID_WIDTH + `AXI_ADDR_WIDTH + `AXI_LEN_WIDTH + `AXI_SIZE_WIDTH
`define WDATA_FIFO_DATA_LEN     `AXI_AID_WIDTH + `DATABUS2MEM_WIDTH /* 64 Bytes data */
`define ID_FIFO_DATA_LEN        `AXI_AID_WIDTH + `AXI_ADDR_WIDTH + `AXI_LEN_WIDTH + 1 /* 1 bit for the command sent to memory rd/write */

`define SAXI2MEM_CMD_WR     1'b1
`define SAXI2MEM_CMD_RD     1'b0

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
`define MSEQ_MEM_ADDR_BITS 119:56
`define MSEQ_MEM_SIZE_BITS 55:24

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

// DLA Address Range from 0x8000_0000 ~ 0x8fff_ffff. 0x5000_0000 ~ 0x5fff_ffff
// Shares MEM_SIZE for now. If address range differs, dupilicate defines will need to be created
`define DLA_ADDR_START     `AXI_ADDR_WIDTH'h8000_0000
`define DBB_ADDR_START     `AXI_ADDR_WIDTH'h8000_0000
`define DBB_MEM_SIZE       `MEM_SIZE
`define CVSRAM_ADDR_START  `AXI_ADDR_WIDTH'h5000_0000
`define CVSRAM_MEM_SIZE    `MEM_SIZE
// Mask is used to decide which memory to load to and dump from
`define DLA_ADDR_MASK      `AXI_ADDR_WIDTH'hffff_ffff_f000_0000

`define DLA_CLOCK_DIVIDE              2
`define DLATB_S2M_CHANNEL_COUNT       1

// Define offsets inside the config_mem to find these configuration parameters
`define MSEQ_CONFIG_SIZE      32
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
`define MSEQ_POLL_INTERVAL    10
`define MSEQ_RD_TIMEOUT       11
`define MSEQ_WR_TIMEOUT       12
`define MSEQ_INTR_TIMEOUT     13
`define MSEQ_CONT_ON_FAIL     14
`define MSEQ_RD_POLLS         15
`define WR_PERC_0             16
`define RD_PERC_0             17
`define WR_PERC_1             18
`define RD_PERC_1             19
`define PERC_ALL              20
`define NUM_CONFIGS           21

`define WORD_SIZE   512
`define WORD_BYTES  (`WORD_SIZE/8)

//This is the ceiling log 2 of word_size, minus 3 (ie divide by 8 bits per byte); this gets the number of address bits used for the word offset
//This is the address size needed for the word size above.
`define LOG2_WORD $clog2(`WORD_SIZE)-3

`define RD_VALID        0
`define RD_ADDR_RANGE   (`AXI_ADDR_WIDTH-`LOG2_MEM):1
`define RD_LEN_RANGE    (`AXI_ADDR_WIDTH-`LOG2_MEM+`AXI_LEN_WIDTH):(`AXI_ADDR_WIDTH+1-`LOG2_MEM)

//WR_DATA WR_LEN WR_ADDR WR_MASK WR_VALID
`define WR_VALID      0
`define WR_MASK_MIN   1
`define WR_MASK_MAX   `WORD_BYTES
`define WR_MASK_RANGE `WR_MASK_MAX:`WR_MASK_MIN
`define WR_ADDR_MIN   `WR_MASK_MAX+1
`define WR_ADDR_MAX   `WR_MASK_MAX+`AXI_ADDR_WIDTH-`LOG2_MEM
`define WR_ADDR_RANGE `WR_ADDR_MAX:`WR_ADDR_MIN
`define WR_LEN_MIN    `WR_ADDR_MAX+1
`define WR_LEN_MAX    `WR_ADDR_MAX+`AXI_LEN_WIDTH
`define WR_LEN_RANGE  `WR_LEN_MAX:`WR_LEN_MIN
`define WR_DATA_MIN   `WR_LEN_MAX+1
`define WR_DATA_MAX   `WR_LEN_MAX+`WORD_SIZE
`define WR_DATA_RANGE `WR_DATA_MAX:`WR_DATA_MIN
`define WR_Q_MAX      `WR_DATA_MAX

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

// Defines for if someone tries to add more slaves/channels to memory
`define SLAVE_0      0
`define TOTAL_SLAVE  1


// Each channel includes a read port and a write port.
`define MAX_PORTS         (`TOTAL_SLAVE*2)
//`define MAX_PORTS           4
// Want to scale sizes to 100 so that easy perc calc can be made.
`define SCALE_FACTOR        100




