
`include "syn_tb_defines.vh"

module syn_axi_slave (
    clk,
    reset,

    saxi2nvdla_axi_slave_arready,
    saxi2nvdla_axi_slave_awready,
    saxi2nvdla_axi_slave_bid,
    saxi2nvdla_axi_slave_bresp,
    saxi2nvdla_axi_slave_bvalid,
    saxi2nvdla_axi_slave_rdata,
    saxi2nvdla_axi_slave_rid,
    saxi2nvdla_axi_slave_rlast,
    saxi2nvdla_axi_slave_rvalid,
    saxi2nvdla_axi_slave_wready,

    nvdla2saxi_axi_slave_araddr,
    nvdla2saxi_axi_slave_arburst,
    nvdla2saxi_axi_slave_arcache,
    nvdla2saxi_axi_slave_arid,
    nvdla2saxi_axi_slave_arlen,
    nvdla2saxi_axi_slave_arlock,
    nvdla2saxi_axi_slave_arprot,
    nvdla2saxi_axi_slave_arsize,
    nvdla2saxi_axi_slave_arvalid,
    nvdla2saxi_axi_slave_awaddr,
    nvdla2saxi_axi_slave_awburst,
    nvdla2saxi_axi_slave_awcache,
    nvdla2saxi_axi_slave_awid,
    nvdla2saxi_axi_slave_awlen,
    nvdla2saxi_axi_slave_awlock,
    nvdla2saxi_axi_slave_awprot,
    nvdla2saxi_axi_slave_awsize,
    nvdla2saxi_axi_slave_awvalid,
    nvdla2saxi_axi_slave_bready,
    nvdla2saxi_axi_slave_rready,
    nvdla2saxi_axi_slave_wdata,
    nvdla2saxi_axi_slave_wlast,
    nvdla2saxi_axi_slave_wstrb,
    nvdla2saxi_axi_slave_wvalid,

    saxi2mem_cmd_wr,
    saxi2mem_cmd_rd,
    saxi2mem_addr_wr,
    saxi2mem_addr_rd,
    saxi2mem_data,
    saxi2mem_wstrb,
    saxi2mem_len_rd,
    saxi2mem_len_wr,
    saxi2mem_size_rd,
    saxi2mem_size_wr,

    mem2saxi_rdresp,
    mem2saxi_rddata,
    mem2saxi_wrresp,

    mem2saxi_rd_ready,  // TODO: Think about how to use these two signals - for now dangling
    mem2saxi_wr_ready
);

input clk;
input reset;
parameter AXI_SLAVE_ID=0;

output reg                              saxi2nvdla_axi_slave_arready         ;
output reg                              saxi2nvdla_axi_slave_awready         ;
output reg  [`AXI_SLAVE_BID_WIDTH-1:0]  saxi2nvdla_axi_slave_bid             ;
output reg                       [1:0]  saxi2nvdla_axi_slave_bresp           ;
output reg                              saxi2nvdla_axi_slave_bvalid          ;
output reg    [`DATABUS2MEM_WIDTH-1:0]  saxi2nvdla_axi_slave_rdata           ;
output reg  [`AXI_SLAVE_RID_WIDTH-1:0]  saxi2nvdla_axi_slave_rid             ;
output reg                              saxi2nvdla_axi_slave_rlast           ;
output reg                              saxi2nvdla_axi_slave_rvalid          ;
output reg                              saxi2nvdla_axi_slave_wready          ;

input                       [`AXI_ADDR_WIDTH-1:0]  nvdla2saxi_axi_slave_araddr          ;
input                        [1:0]  nvdla2saxi_axi_slave_arburst         ;
input                        [3:0]  nvdla2saxi_axi_slave_arcache         ;
input   [`AXI_SLAVE_RID_WIDTH-1:0]  nvdla2saxi_axi_slave_arid            ;
input                        [3:0]  nvdla2saxi_axi_slave_arlen           ;
input                        [1:0]  nvdla2saxi_axi_slave_arlock          ;
input                        [2:0]  nvdla2saxi_axi_slave_arprot          ;
input                        [2:0]  nvdla2saxi_axi_slave_arsize          ;
input                               nvdla2saxi_axi_slave_arvalid         ;
input                       [`AXI_ADDR_WIDTH-1:0]  nvdla2saxi_axi_slave_awaddr          ;
input                        [1:0]  nvdla2saxi_axi_slave_awburst         ;
input                        [3:0]  nvdla2saxi_axi_slave_awcache         ;
input   [`AXI_SLAVE_WID_WIDTH-1:0]  nvdla2saxi_axi_slave_awid            ;
input                        [3:0]  nvdla2saxi_axi_slave_awlen           ;
input                        [1:0]  nvdla2saxi_axi_slave_awlock          ;
input                        [2:0]  nvdla2saxi_axi_slave_awprot          ;
input                        [2:0]  nvdla2saxi_axi_slave_awsize          ;
input                               nvdla2saxi_axi_slave_awvalid         ;
input                               nvdla2saxi_axi_slave_bready          ;
input                               nvdla2saxi_axi_slave_rready          ;
input     [`DATABUS2MEM_WIDTH-1:0]  nvdla2saxi_axi_slave_wdata           ;
reg     [`AXI_SLAVE_WID_WIDTH-1:0]  nvdla2saxi_axi_slave_wid             ;
input                               nvdla2saxi_axi_slave_wlast           ;
input [(`DATABUS2MEM_WIDTH/8)-1:0]  nvdla2saxi_axi_slave_wstrb           ;
input                               nvdla2saxi_axi_slave_wvalid          ;

output reg          saxi2mem_cmd_wr     ;
output reg          saxi2mem_cmd_rd     ;
output reg   [`AXI_ADDR_WIDTH-1:0] saxi2mem_addr_rd    ;
output reg   [`AXI_ADDR_WIDTH-1:0] saxi2mem_addr_wr    ;
output reg  [`DATABUS2MEM_WIDTH-1:0] saxi2mem_data       ;
output reg   [(`DATABUS2MEM_WIDTH/8)-1:0] saxi2mem_wstrb      ;
output reg   [3:0]  saxi2mem_len_rd     ;
output reg   [3:0]  saxi2mem_len_wr     ;
output reg   [2:0]  saxi2mem_size_rd    ;
output reg   [2:0]  saxi2mem_size_wr    ;

input           mem2saxi_rdresp       ;
input   [`DATABUS2MEM_WIDTH-1:0] mem2saxi_rddata       ;
input           mem2saxi_wrresp       ;
input           mem2saxi_rd_ready   ;
input           mem2saxi_wr_ready   ;

reg           slave_wlast_d1;
reg           slave_wready_wvalid_d1;
reg           slave_awready_awvalid_d1;
reg           slave_arready_arvalid_d1;

reg           read_writefifo;
reg           read_readfifo;

reg     [`ID_FIFO_DATA_LEN-1:0]     reg_id_fifo_wr_bus;
reg    [`DATABUS2MEM_WIDTH-1:0]     mem_rdret_data;
reg        [`AXI_AID_WIDTH-1:0]     mem_rdret_id;
reg        [`AXI_LEN_WIDTH-1:0]     mem_rdret_arlen;
reg       [`AXI_ADDR_WIDTH-1:0]     mem_rdret_araddr;
reg        [`AXI_LEN_WIDTH-1:0]     rd_data_burst_count;
reg        [`AXI_LEN_WIDTH-1:0]     wr_data_burst_count;

reg   [`WDATA_FIFO_DATA_LEN-1:0]   wdata_beat;   // 64 Bytes data bus
reg                       [63:0]   wstrb_beat;   // 64 bits strobe bus for each byte of the data bus
reg    [`ADDR_FIFO_DATA_LEN-1:0]   waddr_fifo_bus;
reg    [`ADDR_FIFO_DATA_LEN-1:0]   raddr_fifo_bus;

// Counts for outstanding transactions
reg                [`LOG2_Q-1:0]    outstanding_rd_count, outstanding_wraddr_count, outstanding_wrdata_count;
reg                                 rd_count_inc,  rd_count_dec;
reg                                 wraddr_count_inc,  wraddr_count_dec;
reg                                 wrdata_count_inc,  wrdata_count_dec;
reg                                 carry_rd_count, carry_wraddr_count, carry_wrdata_count;
/*wire        [`AXI_AID_WIDTH-1:0]    from_fifo_id;
wire       [`AXI_ADDR_WIDTH-1:0]    from_fifo_addr;
wire        [`AXI_LEN_WIDTH-1:0]    from_fifo_len;
wire       [`AXI_SIZE_WIDTH-1:0]    from_fifo_size;*/
wire        [`AXI_AID_WIDTH-1:0]    from_wr_fifo_id;
wire       [`AXI_ADDR_WIDTH-1:0]    from_wr_fifo_addr;
wire        [`AXI_LEN_WIDTH-1:0]    from_wr_fifo_len;
wire       [`AXI_SIZE_WIDTH-1:0]    from_wr_fifo_size;
wire        [`AXI_AID_WIDTH-1:0]    from_rd_fifo_id;
wire       [`AXI_ADDR_WIDTH-1:0]    from_rd_fifo_addr;
wire        [`AXI_LEN_WIDTH-1:0]    from_rd_fifo_len;
wire       [`AXI_SIZE_WIDTH-1:0]    from_rd_fifo_size;
wire        [`AXI_AID_WIDTH-1:0]    from_fifo_wid;
wire    [`DATABUS2MEM_WIDTH-1:0]    from_fifo_wdata;
wire                      [(`DATABUS2MEM_WIDTH/8)-1:0]    from_fifo_wstrb;

wire                            wrcmd2mem;
wire    [`AXI_LEN_WIDTH-1:0]    wrcmd2mem_len;
wire    [`AXI_AID_WIDTH-1:0]    wrcmd2mem_id;
wire   [`AXI_ADDR_WIDTH-1:0]    wrcmd2mem_addr;
wire                            rdcmd2mem;
wire    [`AXI_LEN_WIDTH-1:0]    rdcmd2mem_len;
wire    [`AXI_AID_WIDTH-1:0]    rdcmd2mem_id;
wire   [`AXI_ADDR_WIDTH-1:0]    rdcmd2mem_addr;


// All the fifo wires
// data wires
wire   [`WDATA_FIFO_DATA_LEN-1:0]   axi_slave_wdfifo_wr_bus;
wire                       [63:0]   axi_slave_wsfifo_wr_bus;
wire    [`ADDR_FIFO_DATA_LEN-1:0]   axi_slave_awfifo_wr_bus;
wire    [`ADDR_FIFO_DATA_LEN-1:0]   axi_slave_arfifo_wr_bus;
reg      [`ID_FIFO_DATA_LEN-1:0]    wrid_fifo_wr_bus;
reg      [`ID_FIFO_DATA_LEN-1:0]    rdid_fifo_wr_bus;
wire     [`DATABUS2MEM_WIDTH-1:0]   memresp_wrfifo_wr_bus;
wire     [`DATABUS2MEM_WIDTH-1:0]   memresp_rdfifo_wr_bus;
wire   [`WDATA_FIFO_DATA_LEN-1:0]   axi_slave_wdfifo_rd_bus;
wire                       [63:0]   axi_slave_wsfifo_rd_bus;
wire    [`ADDR_FIFO_DATA_LEN-1:0]   axi_slave_awfifo_rd_bus;
wire    [`ADDR_FIFO_DATA_LEN-1:0]   axi_slave_arfifo_rd_bus;
wire      [`ID_FIFO_DATA_LEN-1:0]   wrid_fifo_rd_bus;
wire      [`ID_FIFO_DATA_LEN-1:0]   rdid_fifo_rd_bus;
wire     [`DATABUS2MEM_WIDTH-1:0]   memresp_wrfifo_rd_bus;
wire     [`DATABUS2MEM_WIDTH-1:0]   memresp_rdfifo_rd_bus;

// busy
wire    wdfifo_wr_busy;
wire    wsfifo_wr_busy;
wire    awfifo_wr_busy;
wire    arfifo_wr_busy;
wire    wrid_fifo_wr_busy;
wire    rdid_fifo_wr_busy;
wire    memresp_wrfifo_wr_busy;
wire    memresp_rdfifo_wr_busy;

// empty
wire    wdfifo_wr_empty;
wire    wsfifo_wr_empty;
wire    awfifo_wr_empty;
wire    arfifo_wr_empty;
wire    wrid_fifo_wr_empty;
wire    rdid_fifo_wr_empty;
wire    memresp_wrfifo_wr_empty;
wire    memresp_rdfifo_wr_empty;

// Valids - rd and write
wire    axi_slave_wdfifo_wr_valid;
wire    axi_slave_wsfifo_wr_valid;
wire    axi_slave_awfifo_wr_valid;
wire    axi_slave_arfifo_wr_valid;
wire    memresp_wrfifo_wr_valid;
wire    memresp_rdfifo_wr_valid;
wire     axi_slave_wdfifo_rd_valid;
wire     axi_slave_wsfifo_rd_valid;
wire     axi_slave_awfifo_rd_valid;
wire     axi_slave_arfifo_rd_valid;
wire     wrid_fifo_rd_valid;
wire     rdid_fifo_rd_valid;
wire     memresp_wrfifo_rd_valid;
wire     memresp_rdfifo_rd_valid;

reg     wrid_fifo_wr_valid;
reg     rdid_fifo_wr_valid;
reg     axi_slave_wdfifo_rd_busy;
reg     axi_slave_wsfifo_rd_busy;
reg     axi_slave_awfifo_rd_busy;
reg     axi_slave_arfifo_rd_busy;
reg     wrid_fifo_rd_busy;
reg     rdid_fifo_rd_busy;
reg     sending_wdata_to_mem;
reg     sending_mem_rdresp2nvdla;
reg     sending_mem_wrresp2nvdla;
reg     memresp_wrfifo_rd_busy;
reg     memresp_rdfifo_rd_busy;
wire [8:0] memresp_rdfifo_rd_count;

reg [`MSEQ_CONFIG_SIZE-1:0]            config_mem[`NUM_CONFIGS-1:0];

// Write fifo depths of 64
// Write data fifo instance
wdata_fifo axi_slave_wdata_fifo (
    .clk                        (clk)
   ,.reset_                     (reset)
   ,.wr_busy                    (wdfifo_wr_busy)
   ,.wr_empty                   (wdfifo_wr_empty)
   ,.wr_data                    (axi_slave_wdfifo_wr_bus)
   ,.wr_req                     (axi_slave_wdfifo_wr_valid)
   ,.rd_data                    (axi_slave_wdfifo_rd_bus)
   ,.rd_req                     (axi_slave_wdfifo_rd_valid)
   ,.rd_busy                    (axi_slave_wdfifo_rd_busy)
);

// Write strb fifo instance
wstrb_fifo axi_slave_wstrb_fifo (
    .clk                        (clk)
   ,.reset_                     (reset)
   ,.wr_busy                    (wsfifo_wr_busy)
   ,.wr_empty                   (wsfifo_wr_empty)
   ,.wr_data                    (axi_slave_wsfifo_wr_bus)
   ,.wr_req                     (axi_slave_wsfifo_wr_valid)
   ,.rd_data                    (axi_slave_wsfifo_rd_bus)
   ,.rd_req                     (axi_slave_wsfifo_rd_valid)
   ,.rd_busy                    (axi_slave_wsfifo_rd_busy)
);

// Write address fifo instance
waddr_fifo axi_slave_waddr_fifo (
    .clk                        (clk)
   ,.reset_                     (reset)
   ,.wr_busy                    (awfifo_wr_busy)
   ,.wr_empty                   (awfifo_wr_empty)
   ,.wr_data                    (axi_slave_awfifo_wr_bus)
   ,.wr_req                     (axi_slave_awfifo_wr_valid)
   ,.rd_data                    (axi_slave_awfifo_rd_bus)
   ,.rd_req                     (axi_slave_awfifo_rd_valid)
   ,.rd_busy                    (axi_slave_awfifo_rd_busy)
);

// Read fifo depths of 384
// Read address fifo instance
raddr_fifo axi_slave_raddr_fifo  (
    .clk                        (clk)
   ,.reset_                     (reset)
   ,.wr_busy                    (arfifo_wr_busy)
   ,.wr_empty                   (arfifo_wr_empty)
   ,.wr_data                    (axi_slave_arfifo_wr_bus)
   ,.wr_req                     (axi_slave_arfifo_wr_valid)
   ,.rd_data                    (axi_slave_arfifo_rd_bus)
   ,.rd_req                     (axi_slave_arfifo_rd_valid)
   ,.rd_busy                    (axi_slave_arfifo_rd_busy)
);

// ID fifo depth of 384+64=448
// Fifo for id's sent to the memory
id_fifo wrid2mem_fifo (
    .clk                        (clk)
   ,.reset_                     (reset)
   ,.wr_busy                    (wrid_fifo_wr_busy)
   ,.wr_empty                   (wrid_fifo_wr_empty)
   ,.wr_data                    (wrid_fifo_wr_bus)
   ,.wr_req                     (wrid_fifo_wr_valid)
   ,.rd_data                    (wrid_fifo_rd_bus)
   ,.rd_req                     (wrid_fifo_rd_valid)
   ,.rd_busy                    (wrid_fifo_rd_busy)
);
id_fifo rdid2mem_fifo (
    .clk                        (clk)
   ,.reset_                     (reset)
   ,.wr_busy                    (rdid_fifo_wr_busy)
   ,.wr_empty                   (rdid_fifo_wr_empty)
   ,.wr_data                    (rdid_fifo_wr_bus)
   ,.wr_req                     (rdid_fifo_wr_valid)
   ,.rd_data                    (rdid_fifo_rd_bus)
   ,.rd_req                     (rdid_fifo_rd_valid)
   ,.rd_busy                    (rdid_fifo_rd_busy)
);
// Same depth as ID fifo, shouldn't be needing that much anyway though - TODO
// Memory response fifo - just the data width of 64 bytes - will have garbage data for the write responses
memresp_fifo mem2slave_rdrspdata_fifo (
    .clk                            (clk)
   ,.reset_                         (reset)
   ,.wr_busy                        (memresp_rdfifo_wr_busy)
   ,.wr_empty                       (memresp_rdfifo_wr_empty)
   ,.wr_data                        (memresp_rdfifo_wr_bus)
   ,.wr_req                         (memresp_rdfifo_wr_valid)
   ,.rd_data                        (memresp_rdfifo_rd_bus)
   ,.rd_req                         (memresp_rdfifo_rd_valid)
   ,.rd_busy                        (memresp_rdfifo_rd_busy)
   ,.rd_count                       (memresp_rdfifo_rd_count)
);
memresp_fifo mem2slave_wrrspdata_fifo (
    .clk                            (clk)
   ,.reset_                         (reset)
   ,.wr_busy                        (memresp_wrfifo_wr_busy)
   ,.wr_empty                       (memresp_wrfifo_wr_empty)
   ,.wr_data                        (memresp_wrfifo_wr_bus)
   ,.wr_req                         (memresp_wrfifo_wr_valid)
   ,.rd_data                        (memresp_wrfifo_rd_bus)
   ,.rd_req                         (memresp_wrfifo_rd_valid)
   ,.rd_busy                        (memresp_wrfifo_rd_busy)
);

//rdata_table
// spyglass disable_block W182c SYNTH_5280 SYNTH_93
time                          rdata_table_timestamp[(2**`AXI_AID_WIDTH)-1:0];
time                          rdata_table_req_time [(2**`AXI_AID_WIDTH)-1:0];
time                          rdata_table_req_time_delta;
// spyglass enable_block W182c SYNTH_5280 SYNTH_93
reg [`AXI_LEN_WIDTH-1:0]      rdata_table_len      [(2**`AXI_AID_WIDTH)-1:0];
reg [`WORD_SIZE-1:0]          rdata_table_data     [(2**`AXI_AID_WIDTH)-1:0]; 
reg                           rdata_table_valid    [(2**`AXI_AID_WIDTH)-1:0];         //addr valid

//bank_ptr
reg [$clog2(`MAX_WRITE_CONFLICT) : 0] waddr_ptr_head[2**`AXI_AID_WIDTH-1:0];
reg [$clog2(`MAX_WRITE_CONFLICT) : 0] waddr_ptr_tail[2**`AXI_AID_WIDTH-1:0];
reg [$clog2(`MAX_WRITE_CONFLICT) : 0] waddr_ptr_mid [2**`AXI_AID_WIDTH-1:0];
reg [$clog2(`MAX_WRITE_CONFLICT) : 0] wdata_ptr_head[2**`AXI_AID_WIDTH-1:0];
reg [$clog2(`MAX_WRITE_CONFLICT) : 0] wdata_ptr_tail[2**`AXI_AID_WIDTH-1:0];

//waddr_bank
time                   waddr_bank_timestamp[(2**`AXI_AID_WIDTH)*`MAX_WRITE_CONFLICT-1 : 0];   // spyglass disable W182c SYNTH_93
time                   waddr_bank_time_delta;
reg [`AXI_AID_WIDTH-1:0]   waddr_bank_id   [(2**`AXI_AID_WIDTH)*`MAX_WRITE_CONFLICT-1 : 0];
reg [`AXI_ADDR_WIDTH-1:0]  waddr_bank_addr [(2**`AXI_AID_WIDTH)*`MAX_WRITE_CONFLICT-1 : 0];
reg [`AXI_LEN_WIDTH-1:0]   waddr_bank_len  [(2**`AXI_AID_WIDTH)*`MAX_WRITE_CONFLICT-1 : 0];
reg [`AXI_SIZE_WIDTH-1:0]  waddr_bank_size [(2**`AXI_AID_WIDTH)*`MAX_WRITE_CONFLICT-1 : 0];
reg [1:0]                  waddr_bank_burst[(2**`AXI_AID_WIDTH)*`MAX_WRITE_CONFLICT-1 : 0];
reg [1:0]                  waddr_bank_lock [(2**`AXI_AID_WIDTH)*`MAX_WRITE_CONFLICT-1 : 0];
reg [3:0]                  waddr_bank_cache[(2**`AXI_AID_WIDTH)*`MAX_WRITE_CONFLICT-1 : 0];
reg [2:0]                  waddr_bank_port [(2**`AXI_AID_WIDTH)*`MAX_WRITE_CONFLICT-1 : 0];
reg                        waddr_bank_av   [(2**`AXI_AID_WIDTH)*`MAX_WRITE_CONFLICT-1 : 0];

//wdata_bank
time                       wdata_bank_timestamp[(2**`AXI_AID_WIDTH)*`MAX_WRITE_CONFLICT-1 : 0]; // spyglass disable W182c SYNTH_93
reg [`AXI_AID_WIDTH-1:0]       wdata_bank_id   [(2**`AXI_AID_WIDTH)*`MAX_WRITE_CONFLICT-1 : 0];
reg [`WORD_SIZE-1:0]           wdata_bank_wdata[(2**`AXI_AID_WIDTH)*`MAX_WRITE_CONFLICT-1 : 0]; 
reg [(`DATABUS2MEM_WIDTH/8)-1:0]                     wdata_bank_wstrb[(2**`AXI_AID_WIDTH)*`MAX_WRITE_CONFLICT-1 : 0];
reg                            wdata_bank_dv   [(2**`AXI_AID_WIDTH)*`MAX_WRITE_CONFLICT-1 : 0];         //data valid

reg save_idfifo_signals;




// Reading this for the outstanding_reads/writes numbers
// spyglass disable_block W213 W430 SYNTH_5143
initial begin
   $readmemh("slave_mem.cfg", config_mem);
end
// spyglass enable_block W213 W430 SYNTH_5143

// Delayed version of wlast for fifo write
always @(posedge clk or negedge reset) begin
  if(!reset) begin
    slave_wlast_d1 <= 1'b0;
    slave_wready_wvalid_d1 <= 1'b0;
    slave_awready_awvalid_d1 <= 1'b0;
    slave_arready_arvalid_d1 <= 1'b0;
  end else begin
    slave_wlast_d1 <= (nvdla2saxi_axi_slave_wlast & nvdla2saxi_axi_slave_wvalid & saxi2nvdla_axi_slave_wready);
    slave_wready_wvalid_d1 <= (nvdla2saxi_axi_slave_wvalid & saxi2nvdla_axi_slave_wready);
    slave_awready_awvalid_d1 <= (saxi2nvdla_axi_slave_awready & nvdla2saxi_axi_slave_awvalid);
    slave_arready_arvalid_d1 <= (saxi2nvdla_axi_slave_arready & nvdla2saxi_axi_slave_arvalid);
  end
end

// Aggregate the write data till the wlast is seen and then write to the fifo
// Signals - wid, wdata, wstrb, wlast, wvalid, wready
always @(posedge clk or negedge reset) begin
  if(!reset) begin
    nvdla2saxi_axi_slave_wid <= 0;
    wdata_beat <= 0;
    wstrb_beat <= 0;
    saxi2nvdla_axi_slave_wready <= 1'b1;

    waddr_fifo_bus <= 0;
    saxi2nvdla_axi_slave_awready <= 1'b1;

    raddr_fifo_bus <= 0;
    saxi2nvdla_axi_slave_arready <= 1'b1;
  end else begin
    // Clearing wdata_beat and wstrb_beat
    if(slave_wlast_d1) begin    // writing into the fifo's in this cycle
//      $display("AXI_MEM_XACTION: WriteReq_delay: CHANNEL=%0d START_TIME=%0t END_TIME=%0t AWID=0x%08x AWLEN=0x%08x AWSIZE=0x%08x AWADDR=0x%010x AWBURST=0x%08x AWLOCK=0x%08x AWPORT=0x%08x WID=0x%08x WDATA=0x%0128x", AXI_SLAVE_ID, waddr_info.waddr_timestamp,$time, waddr_info.id, waddr_info.len, waddr_info.size, waddr_info.addr, waddr_info.burst, waddr_info.lock, waddr_info.port,wdata_beat[`WDATA_FIFO_DATA_LEN-1:`WDATA_FIFO_DATA_LEN-`AXI_AID_WIDTH], wdata_beat[`WDATA_FIFO_DATA_LEN-`AXI_AID_WIDTH-1:0]);
      wdata_beat <= 0;
      wstrb_beat <= 0;
    end

    // Wdata aggregation and writing logic
    if(saxi2nvdla_axi_slave_wready & nvdla2saxi_axi_slave_wvalid) begin
      if(!nvdla2saxi_axi_slave_wlast) begin
        //Put txn in wdata fifo
        saxi2nvdla_axi_slave_wready <= (~wdfifo_wr_busy & (((outstanding_wrdata_count+wrdata_count_inc-wrdata_count_dec) & 16'hffff)< config_mem[`S0_MAX_WRITES]));    // wdata !FIFO_FULL	
      end else begin
        //saxi2nvdla_axi_slave_wready <= 1'b0;
        nvdla2saxi_axi_slave_wid <= nvdla2saxi_axi_slave_wid + 1;
        saxi2nvdla_axi_slave_wready <= (~wdfifo_wr_busy & (((outstanding_wrdata_count+wrdata_count_inc-wrdata_count_dec) & 16'hffff)< config_mem[`S0_MAX_WRITES]));    // wdata !FIFO_FULL	
        // I want to zero it out after writing into the fifo also assert wready - triggered in fifo write
      end     // wlast - ifelse

      wdata_beat <= {nvdla2saxi_axi_slave_wid, nvdla2saxi_axi_slave_wdata}; //Tack on wid
      wstrb_beat <= nvdla2saxi_axi_slave_wstrb;

      if (waddr_bank_av[{nvdla2saxi_axi_slave_wid, waddr_ptr_mid[nvdla2saxi_axi_slave_wid]}]) begin
          //both addr and data are ready
          $display("AXI_MEM_XACTION: WriteReq: CHANNEL=%0d START_TIME=%0t END_TIME=%0t AWID=0x%08x AWLEN=0x%08x AWSIZE=0x%08x AWADDR=0x%010x AWBURST=0x%08x AWLOCK=0x%08x AWPORT=0x%08x WID=0x%08x WDATA=0x%0128x WSTRB=0x%064x", 
          AXI_SLAVE_ID, 
          waddr_bank_timestamp[{nvdla2saxi_axi_slave_wid, waddr_ptr_mid[nvdla2saxi_axi_slave_wid]}],
          $time, 
          waddr_bank_id   [{nvdla2saxi_axi_slave_wid, waddr_ptr_mid[nvdla2saxi_axi_slave_wid]}], 
          waddr_bank_len  [{nvdla2saxi_axi_slave_wid, waddr_ptr_mid[nvdla2saxi_axi_slave_wid]}], 
          waddr_bank_size [{nvdla2saxi_axi_slave_wid, waddr_ptr_mid[nvdla2saxi_axi_slave_wid]}], 
          waddr_bank_addr [{nvdla2saxi_axi_slave_wid, waddr_ptr_mid[nvdla2saxi_axi_slave_wid]}], 
          waddr_bank_burst[{nvdla2saxi_axi_slave_wid, waddr_ptr_mid[nvdla2saxi_axi_slave_wid]}], 
          waddr_bank_lock [{nvdla2saxi_axi_slave_wid, waddr_ptr_mid[nvdla2saxi_axi_slave_wid]}], 
          waddr_bank_port [{nvdla2saxi_axi_slave_wid, waddr_ptr_mid[nvdla2saxi_axi_slave_wid]}], 
          nvdla2saxi_axi_slave_wid, nvdla2saxi_axi_slave_wdata, nvdla2saxi_axi_slave_wstrb);  // spyglass disable  W213
`ifdef AXI_MEM_DEBUG
          $display("wdata_ptrs\[%0d\].head=0x%0x", nvdla2saxi_axi_slave_wid, wdata_ptr_head[nvdla2saxi_axi_slave_awid]); // spyglass disable  W213
`endif
          wdata_bank_dv[{nvdla2saxi_axi_slave_wid, wdata_ptr_head[nvdla2saxi_axi_slave_wid]}] <= 1'b1;
          wdata_ptr_head[nvdla2saxi_axi_slave_wid] <= (wdata_ptr_head[nvdla2saxi_axi_slave_wid]+1) % `MAX_WRITE_CONFLICT;

          waddr_ptr_mid[nvdla2saxi_axi_slave_wid] <= (waddr_ptr_mid [nvdla2saxi_axi_slave_wid]+1) % `MAX_WRITE_CONFLICT;
      end else begin
`ifdef AXI_MEM_DEBUG
          $display("Write data is coming, but addr not received yet. ID=0x%08x", nvdla2saxi_axi_slave_wid); // spyglass disable  W213
`endif
      end
    end else begin
      saxi2nvdla_axi_slave_wready <= (~wdfifo_wr_busy & (((outstanding_wrdata_count+wrdata_count_inc-wrdata_count_dec) & 16'hffff) < config_mem[`S0_MAX_WRITES]));    // wdata !FIFO_FULL 
    end

    // waddr writing logic and aggregation
    if(saxi2nvdla_axi_slave_awready & nvdla2saxi_axi_slave_awvalid) begin
      waddr_fifo_bus <= {nvdla2saxi_axi_slave_awid, nvdla2saxi_axi_slave_awaddr, nvdla2saxi_axi_slave_awlen, nvdla2saxi_axi_slave_awsize};
`ifdef AXI_MEM_DEBUG
      $display("%0t WriteReq_temp(AddrChannel%0d): AWID = 0x%08x, AWLEN=0x%08x, AWSIZE = 0x%08x, AWADDR=0x%08x",$time, AXI_SLAVE_ID, nvdla2saxi_axi_slave_awid, nvdla2saxi_axi_slave_awlen, nvdla2saxi_axi_slave_awsize, nvdla2saxi_axi_slave_awaddr);  // spyglass disable  W213
`endif
      if (waddr_bank_av[{nvdla2saxi_axi_slave_awid, waddr_ptr_head[nvdla2saxi_axi_slave_awid]}] ||
          wdata_bank_dv[{nvdla2saxi_axi_slave_awid, waddr_ptr_head[nvdla2saxi_axi_slave_awid]}] ) begin
          //either addr or data is occupied
          saxi2nvdla_axi_slave_awready <= (~awfifo_wr_busy & (((outstanding_wraddr_count+wraddr_count_inc-wraddr_count_dec) & 16'hffff) < config_mem[`S0_MAX_WRITES]));   // waddr !FIFO_FULL
          $display("%0t ERROR: The count of conflicting id 0x%08x exceeds the max allowed number(%0d)! Please increase MAX_WRITE_CONFLICT",$time, nvdla2saxi_axi_slave_awid, `MAX_WRITE_CONFLICT);  // spyglass disable  W213
          $finish;  // spyglass disable  W213
      end else begin
`ifdef AXI_MEM_DEBUG
          $display("waddr_ptrs\[%0d\].head=0x%0x", nvdla2saxi_axi_slave_awid, waddr_ptr_head[nvdla2saxi_axi_slave_awid]);   // spyglass disable  W213
`endif
          waddr_bank_timestamp[{nvdla2saxi_axi_slave_awid, waddr_ptr_head[nvdla2saxi_axi_slave_awid]}] <= $time;
          waddr_bank_id   [{nvdla2saxi_axi_slave_awid, waddr_ptr_head[nvdla2saxi_axi_slave_awid]}] <= nvdla2saxi_axi_slave_awid;
          waddr_bank_addr [{nvdla2saxi_axi_slave_awid, waddr_ptr_head[nvdla2saxi_axi_slave_awid]}] <= nvdla2saxi_axi_slave_awaddr;
          waddr_bank_len  [{nvdla2saxi_axi_slave_awid, waddr_ptr_head[nvdla2saxi_axi_slave_awid]}] <= nvdla2saxi_axi_slave_awlen;
          waddr_bank_size [{nvdla2saxi_axi_slave_awid, waddr_ptr_head[nvdla2saxi_axi_slave_awid]}] <= nvdla2saxi_axi_slave_awsize;
          waddr_bank_burst[{nvdla2saxi_axi_slave_awid, waddr_ptr_head[nvdla2saxi_axi_slave_awid]}] <= nvdla2saxi_axi_slave_awburst;
          waddr_bank_lock [{nvdla2saxi_axi_slave_awid, waddr_ptr_head[nvdla2saxi_axi_slave_awid]}] <= nvdla2saxi_axi_slave_awlock;
          waddr_bank_cache[{nvdla2saxi_axi_slave_awid, waddr_ptr_head[nvdla2saxi_axi_slave_awid]}] <= nvdla2saxi_axi_slave_awcache;
          waddr_bank_port [{nvdla2saxi_axi_slave_awid, waddr_ptr_head[nvdla2saxi_axi_slave_awid]}] <= nvdla2saxi_axi_slave_awprot;
          waddr_bank_av   [{nvdla2saxi_axi_slave_awid, waddr_ptr_head[nvdla2saxi_axi_slave_awid]}] <= 1'b1;
          waddr_ptr_head[nvdla2saxi_axi_slave_awid] <= (waddr_ptr_head[nvdla2saxi_axi_slave_awid]+1) % `MAX_WRITE_CONFLICT;
          //saxi2nvdla_axi_slave_awready <= 1'b0; //Why are we dropping it? Its silly and makes waves more confusing
          saxi2nvdla_axi_slave_awready <= (~awfifo_wr_busy & (((outstanding_wraddr_count+wraddr_count_inc-wraddr_count_dec) & 16'hffff) < config_mem[`S0_MAX_WRITES]));   // waddr !FIFO_FULL
      end
    end else begin
      saxi2nvdla_axi_slave_awready <= (~awfifo_wr_busy & (((outstanding_wraddr_count+wraddr_count_inc-wraddr_count_dec) & 16'hffff) < config_mem[`S0_MAX_WRITES]));   // waddr !FIFO_FULL
    end

    //raddr writing logic and aggregation
    if(saxi2nvdla_axi_slave_arready & nvdla2saxi_axi_slave_arvalid) begin
      raddr_fifo_bus <= {nvdla2saxi_axi_slave_arid, nvdla2saxi_axi_slave_araddr, nvdla2saxi_axi_slave_arlen, nvdla2saxi_axi_slave_arsize};
      $display("AXI_MEM_XACTION: ReadReq: CHANNEL=%0d TIME=%0t ARID=0x%08x, ARLEN=0x%08x, ARSIZE=0x%08x ARADDR=0x%010x ARBURST=0x%08x ARLOCK=0x%08x ARCACHE=0x%08x ARPORT=0x%08x",AXI_SLAVE_ID, $time, 
      nvdla2saxi_axi_slave_arid, nvdla2saxi_axi_slave_arlen, 
      nvdla2saxi_axi_slave_arsize, nvdla2saxi_axi_slave_araddr, 
      nvdla2saxi_axi_slave_arburst, nvdla2saxi_axi_slave_arlock, 
      nvdla2saxi_axi_slave_arcache, nvdla2saxi_axi_slave_arprot); // spyglass disable  W213
      saxi2nvdla_axi_slave_arready <= 1'b0;
    end else begin
      saxi2nvdla_axi_slave_arready <= (~arfifo_wr_busy & (((outstanding_rd_count+rd_count_inc-rd_count_dec) & 16'hffff) < config_mem[`S0_MAX_READS]));  // spyglass disable  W123 // raddr !FIFO_FULL
    end

  end   // !reset if

end


assign axi_slave_wdfifo_wr_valid = slave_wready_wvalid_d1;
assign axi_slave_wdfifo_wr_bus = wdata_beat;

assign axi_slave_wsfifo_wr_valid = slave_wready_wvalid_d1;
assign axi_slave_wsfifo_wr_bus = wstrb_beat;

assign axi_slave_awfifo_wr_valid = slave_awready_awvalid_d1;
assign axi_slave_awfifo_wr_bus = waddr_fifo_bus;

assign axi_slave_arfifo_wr_valid = slave_arready_arvalid_d1;
assign axi_slave_arfifo_wr_bus = raddr_fifo_bus;

/*
assign awfifo_rd_valid_busy = {`ADDR_FIFO_DATA_LEN{(axi_slave_awfifo_rd_valid & ~axi_slave_awfifo_rd_busy)}};
assign arfifo_rd_valid_busy = {`ADDR_FIFO_DATA_LEN{(axi_slave_arfifo_rd_valid & ~axi_slave_arfifo_rd_busy)}};
assign wdfifo_rd_valid_busy = {`WDATA_FIFO_DATA_LEN{(axi_slave_wdfifo_rd_valid & ~axi_slave_wdfifo_rd_busy)}};
*/

//assign {from_fifo_id, from_fifo_addr, from_fifo_len, from_fifo_size} = (~axi_slave_awfifo_rd_busy & axi_slave_awfifo_rd_valid) ? axi_slave_awfifo_rd_bus : (~axi_slave_arfifo_rd_busy & axi_slave_arfifo_rd_valid) ? axi_slave_arfifo_rd_bus : {`ADDR_FIFO_DATA_LEN{1'b0}} ;
assign {from_rd_fifo_id, from_rd_fifo_addr, from_rd_fifo_len, from_rd_fifo_size} = (~axi_slave_arfifo_rd_busy & axi_slave_arfifo_rd_valid) ? axi_slave_arfifo_rd_bus : {`ADDR_FIFO_DATA_LEN{1'b0}} ;
assign {from_wr_fifo_id, from_wr_fifo_addr, from_wr_fifo_len, from_wr_fifo_size} = (axi_slave_awfifo_rd_valid) ? axi_slave_awfifo_rd_bus : {`ADDR_FIFO_DATA_LEN{1'b0}};
assign {from_fifo_wid, from_fifo_wdata} = (~axi_slave_wdfifo_rd_busy & axi_slave_wdfifo_rd_valid) ? axi_slave_wdfifo_rd_bus : {`WDATA_FIFO_DATA_LEN{1'b0}} ;
assign from_fifo_wstrb = (~axi_slave_wsfifo_rd_busy & axi_slave_wsfifo_rd_valid) ? axi_slave_wsfifo_rd_bus : {64{1'b0}} ;

// Read out of the fifos and issue the write to the Memory unit
always @ (posedge clk or negedge reset) begin
  if(!reset) begin
    read_writefifo <= 0;
    read_readfifo <= 0;
    axi_slave_arfifo_rd_busy <= 1;
    axi_slave_awfifo_rd_busy <= 1;
    axi_slave_wdfifo_rd_busy <= 1;
    axi_slave_wsfifo_rd_busy <= 1;
    reg_id_fifo_wr_bus <= 0;
    saxi2mem_cmd_rd <= 1'b0;
    saxi2mem_cmd_wr <= 1'b0;
    sending_wdata_to_mem <= 0;
    wr_data_burst_count <= 0;
  end else begin

  if (wdfifo_wr_empty & awfifo_wr_empty) begin
    axi_slave_awfifo_rd_busy <= 1;
    axi_slave_wdfifo_rd_busy <= 1;
    axi_slave_wsfifo_rd_busy <= 1;
    wr_data_burst_count <= 0;
    sending_wdata_to_mem <= 0;
  end else begin
    if (!wdfifo_wr_empty & !awfifo_wr_empty & axi_slave_awfifo_rd_busy & axi_slave_wdfifo_rd_busy & mem2saxi_wr_ready) begin
      axi_slave_awfifo_rd_busy <= 1; //Dont pop awfifo til done with from_fifo data, so when burst_count >= from_wr_fifo_len
      axi_slave_wdfifo_rd_busy <= 0;
      axi_slave_wsfifo_rd_busy <= 0;
      wr_data_burst_count <= wr_data_burst_count + 1;
      sending_wdata_to_mem <= 1;
    end else if (sending_wdata_to_mem && (wr_data_burst_count <= from_wr_fifo_len)) begin
      // If we popped a new txn, keep popping wd/wsfifo until hit length, stop popping awfifo
      axi_slave_awfifo_rd_busy <= 1;
      axi_slave_wdfifo_rd_busy <= 0;
      axi_slave_wsfifo_rd_busy <= 0;
      wr_data_burst_count <= wr_data_burst_count + 1;
      sending_wdata_to_mem <= 1;
    end else if (sending_wdata_to_mem && (wr_data_burst_count > from_wr_fifo_len)) begin
      axi_slave_wdfifo_rd_busy <= 1;
      axi_slave_wsfifo_rd_busy <= 1;
      axi_slave_awfifo_rd_busy <= 0;
      wr_data_burst_count <= 0;
      sending_wdata_to_mem <= 0;
    end else begin
      axi_slave_wdfifo_rd_busy <= 1;
      axi_slave_wsfifo_rd_busy <= 1;
      axi_slave_awfifo_rd_busy <= 1;
      wr_data_burst_count <= 0;
      sending_wdata_to_mem <= 0;
    end
  end
 
  if (arfifo_wr_empty) begin
    axi_slave_arfifo_rd_busy <= 1;
  end else begin
    if (!arfifo_wr_empty & axi_slave_arfifo_rd_busy & mem2saxi_rd_ready) begin
      axi_slave_arfifo_rd_busy <= 0;
    end else begin
      axi_slave_arfifo_rd_busy <= 1;
    end
  end



    // Issued read previous cycle - so data should be available now // axi_slave_wdfifo_rd_bus, axi_slave_awfifo_rd_bus
    // Also write the wid into a buffer to match up for the response to send to DLA
    reg_id_fifo_wr_bus <= 0;
    if(~axi_slave_wdfifo_rd_busy) begin
      // There's no wid in this minified protocol
      //if(from_wr_fifo_id != from_fifo_wid) begin
        // TODO: Error out here for now, require writes to be in order
      //  $display("ids doesn't matach! from_wr_fifo_id=0x%08x from_fifo_wid=0x%08x",from_wr_fifo_id, from_fifo_wid); // spyglass disable  W213
      //end

      //saxi2mem_valid <= 1'b1;
      //saxi2mem_cmd <= `SAXI2MEM_CMD_WR;
      saxi2mem_cmd_wr <= 1'b1;
      saxi2mem_addr_wr <= (from_wr_fifo_addr & {{(`AXI_ADDR_WIDTH-6){1'b1}},6'h00})+((wr_data_burst_count-1) * (1<<from_wr_fifo_size));
      saxi2mem_len_wr <= from_wr_fifo_len;
      saxi2mem_size_wr <= from_wr_fifo_size;

      // Shift data/wstrb if addr is not 64-Byte aligned
      if((from_wr_fifo_addr & `AXI_ADDR_WIDTH'h1f) != `AXI_ADDR_WIDTH'h00) begin
// Shift data by 32 Bytes
        saxi2mem_data <= (from_fifo_wdata << 256);
        saxi2mem_wstrb <= (from_fifo_wstrb << 32);
        $display("Error: Addresses unaligned to 64B boundaries are unsupported");
        $finish;
      end else begin
        saxi2mem_data <= from_fifo_wdata;
        saxi2mem_wstrb <= from_fifo_wstrb;
      end

      // Write the wid to the fifo
      wrid_fifo_wr_bus <= {`SAXI2MEM_CMD_WR, from_wr_fifo_len, from_wr_fifo_id, from_wr_fifo_addr};
//    end else if(~axi_slave_arfifo_rd_busy) begin
    end else begin
      saxi2mem_cmd_wr <= 1'b0;
    end

    if(~axi_slave_arfifo_rd_busy) begin
        //saxi2mem_valid <= 1'b1;
        //saxi2mem_cmd <= `SAXI2MEM_CMD_RD;
        saxi2mem_cmd_rd <= 1'b1;
        saxi2mem_addr_rd <= from_rd_fifo_addr & {{(`AXI_ADDR_WIDTH-6){1'b1}},6'h00};
        saxi2mem_len_rd <= from_rd_fifo_len;
        saxi2mem_size_rd <= from_rd_fifo_size;

        // Write the wid to the fifo
        rdid_fifo_wr_bus <= {`SAXI2MEM_CMD_RD, from_rd_fifo_len, from_rd_fifo_id, from_rd_fifo_addr};
    end else begin
      saxi2mem_cmd_rd <= 1'b0;
    end
  end   // !reset
end

// Store the commands sent to mem separately - Write fifo and rd fifo
//assign wrid_fifo_wr_valid = saxi2mem_valid & (saxi2mem_cmd == `SAXI2MEM_CMD_WR);
//assign wrid_fifo_wr_bus = reg_id_fifo_wr_bus;
assign wrid_fifo_wr_valid = saxi2mem_cmd_wr;

//assign rdid_fifo_wr_valid = saxi2mem_valid & (saxi2mem_cmd == `SAXI2MEM_CMD_RD);
//assign rdid_fifo_wr_bus = reg_id_fifo_wr_bus;
assign rdid_fifo_wr_valid = saxi2mem_cmd_rd;

// Write the response from memory into fifos - both read and write response channel
assign memresp_rdfifo_wr_bus = mem2saxi_rddata;
assign memresp_rdfifo_wr_valid = mem2saxi_rdresp;

assign memresp_wrfifo_wr_bus = mem2saxi_rddata;     // TODO: For now this data doesn't matter - Fix the FIFO
assign memresp_wrfifo_wr_valid = mem2saxi_wrresp;

// Separate response channel for read and write
// Write response
assign {wrcmd2mem, wrcmd2mem_len, wrcmd2mem_id, wrcmd2mem_addr} = (wrid_fifo_rd_valid && ~wrid_fifo_rd_busy) ? wrid_fifo_rd_bus : {`ID_FIFO_DATA_LEN{1'b0}};

/*debugging. To be removed*/
always @ (posedge clk) begin
    if (mem2saxi_rdresp) begin
`ifdef AXI_MEM_DEBUG
        $display ("temp: memresp_rdfifo_wr_bus=0x%010x", mem2saxi_rddata); // spyglass disable  W213
`endif
    end
end

integer aid_i;
integer aid_conf_i;
always @ (posedge clk or negedge reset) begin
  if(!reset) begin
    wrid_fifo_rd_busy <= 1'b1;
    saxi2nvdla_axi_slave_bvalid <= 1'b0;
    sending_mem_wrresp2nvdla <= 1'b0;
    for (aid_i=0; aid_i<(2**`AXI_AID_WIDTH); aid_i++)
    begin
        waddr_ptr_head[aid_i] <= 0;
        waddr_ptr_tail[aid_i] <= 0;
        waddr_ptr_mid[aid_i] <= 0;
        wdata_ptr_head[aid_i] <= 0;
        wdata_ptr_tail[aid_i] <= 0;
    end
    for (aid_conf_i=0; aid_conf_i<(2**(`AXI_AID_WIDTH+`MAX_WRITE_CONFLICT)); aid_conf_i++)
    begin
        waddr_bank_av[aid_conf_i] <= 1'b0;
        wdata_bank_dv[aid_conf_i] <= 1'b0;
    end
  end else begin

    if(nvdla2saxi_axi_slave_bready) begin // Slave has accepted the response that was driven during the last cycle
      saxi2nvdla_axi_slave_bvalid <= 1'b0;
    end

    if(!memresp_wrfifo_wr_empty & !sending_mem_wrresp2nvdla) begin
      // Read out the id from the issued fifo
      wrid_fifo_rd_busy <= 1'b0;
      memresp_wrfifo_rd_busy <= 1'b0;
      sending_mem_wrresp2nvdla <= 1'b1;
    end else begin
      wrid_fifo_rd_busy <= 1'b1;
      memresp_wrfifo_rd_busy <= 1'b1;
    end     // mem2saxi_resp

    if(~wrid_fifo_rd_busy & ~memresp_wrfifo_rd_busy) begin
      saxi2nvdla_axi_slave_bresp <= 2'b00;  // TODO: Check if this means OKAY response !
      saxi2nvdla_axi_slave_bid <= wrcmd2mem_id;
      waddr_bank_time_delta = $time - waddr_bank_timestamp[{wrcmd2mem_id, waddr_ptr_tail[wrcmd2mem_id]}];
      $display("AXI_MEM_XACTION: WriteResp: CHANNEL=%0d TIME=%0t LATENCY=%0t BID=0x%08x",AXI_SLAVE_ID, $time, waddr_bank_time_delta, wrcmd2mem_id); // spyglass disable  W213
`ifdef AXI_MEM_DEBUG
      $display("Popping waddr_ptrs[%0d].tail=0x%0x, wdata_ptrs[%0d].tail=0x%0x; Before popping waddr_ptrs[%0d].head=0x%0x, wdata_ptrs[%0d].head=0x%0x there are %0d items left in addrQ, %0d items in dataQ for this ID", 
      wrcmd2mem_id, waddr_ptr_tail[wrcmd2mem_id], 
      wrcmd2mem_id, wdata_ptr_tail[wrcmd2mem_id], 
      wrcmd2mem_id, waddr_ptr_head[wrcmd2mem_id], 
      wrcmd2mem_id, wdata_ptr_head[wrcmd2mem_id], 
      (waddr_ptr_head[wrcmd2mem_id] >= waddr_ptr_tail[wrcmd2mem_id]) ? (waddr_ptr_head[wrcmd2mem_id] - waddr_ptr_tail[wrcmd2mem_id]) : (`MAX_WRITE_CONFLICT+waddr_ptr_head[wrcmd2mem_id] - waddr_ptr_tail[wrcmd2mem_id]),
      (wdata_ptr_head[wrcmd2mem_id] >= wdata_ptr_tail[wrcmd2mem_id]) ? (wdata_ptr_head[wrcmd2mem_id] - wdata_ptr_tail[wrcmd2mem_id]) : (`MAX_WRITE_CONFLICT+wdata_ptr_head[wrcmd2mem_id] - wdata_ptr_tail[wrcmd2mem_id]) ); // spyglass disable  W213
`endif
      waddr_bank_av[{wrcmd2mem_id, waddr_ptr_tail[wrcmd2mem_id]}] <= 1'b0;
      wdata_bank_dv[{wrcmd2mem_id, wdata_ptr_tail[wrcmd2mem_id]}] <= 1'b0;
      waddr_ptr_tail[wrcmd2mem_id] <= (waddr_ptr_tail[wrcmd2mem_id] + 1) % `MAX_WRITE_CONFLICT;
      wdata_ptr_tail[wrcmd2mem_id] <= (wdata_ptr_tail[wrcmd2mem_id] + 1) % `MAX_WRITE_CONFLICT;
      saxi2nvdla_axi_slave_bvalid <= 1'b1;
      sending_mem_wrresp2nvdla <= 1'b0;
    end     // wrid_fifo_rd_busy

  end   // !reset
end

// Read Response
assign {rdcmd2mem, rdcmd2mem_len, rdcmd2mem_id, rdcmd2mem_addr} = (rdid_fifo_rd_valid) ? rdid_fifo_rd_bus : {`ID_FIFO_DATA_LEN{1'b0}};

integer aid_j;
always @ (posedge clk or negedge reset) begin
  if(!reset) begin
    rdid_fifo_rd_busy <= 1'b1;
    memresp_rdfifo_rd_busy <= 1'b1;
    saxi2nvdla_axi_slave_rvalid <= 1'b0;
    sending_mem_rdresp2nvdla <= 1'b0;
    mem_rdret_data <= 0;
    mem_rdret_id <= 0;
    mem_rdret_arlen <= 0;
    mem_rdret_araddr <= 0;
    rd_data_burst_count <= 4'b0000;
    save_idfifo_signals <= 0;
    for (aid_j=0; aid_j<(2**`AXI_AID_WIDTH); aid_j++)
    begin
        rdata_table_valid[aid_j] <= 0;
    end
  end else begin

    if (!nvdla2saxi_axi_slave_rready && !sending_mem_rdresp2nvdla) begin
      //default values
        saxi2nvdla_axi_slave_rvalid <= 0;
        saxi2nvdla_axi_slave_rlast <= 0;
        rd_data_burst_count <= 0;
        memresp_rdfifo_rd_busy <= 1;
        rdid_fifo_rd_busy <= 1;
        save_idfifo_signals <= 0;
    end else if (nvdla2saxi_axi_slave_rready && !sending_mem_rdresp2nvdla) begin
      //default values, try to set sending
      if (memresp_rdfifo_rd_valid && rdid_fifo_rd_valid && (memresp_rdfifo_rd_count >= rdcmd2mem_len)) begin
        sending_mem_rdresp2nvdla <= 1;
        if(rd_data_burst_count == rdcmd2mem_len) begin
          saxi2nvdla_axi_slave_rlast <= 1;
          rd_data_burst_count <= rd_data_burst_count+1;
          rdid_fifo_rd_busy <= 0;
          save_idfifo_signals <= 1;
          // Only send data right away if len==0 otherwise for larger lens, beat 0 stays out for 2 cycles
          saxi2nvdla_axi_slave_rdata <= memresp_rdfifo_rd_bus;
          saxi2nvdla_axi_slave_rid <= rdcmd2mem_id;
          saxi2nvdla_axi_slave_rvalid <= 1'b1;
        end else begin
          saxi2nvdla_axi_slave_rlast <= 0;
          //rd_data_burst_count <= rd_data_burst_count+1;
          rdid_fifo_rd_busy <= 1; //Not popping rdid_fifo until rlast
        end
        //Shift fifos for new values. Need to save rdid until rlast
        memresp_rdfifo_rd_busy <= 0;
      end else begin
        memresp_rdfifo_rd_busy <= 1;
        rdid_fifo_rd_busy <= 1;
        saxi2nvdla_axi_slave_rvalid <= 1'b0;
      end
    end else if (!nvdla2saxi_axi_slave_rready && sending_mem_rdresp2nvdla) begin
      save_idfifo_signals <= 0;
      memresp_rdfifo_rd_busy <= 1;
      rdid_fifo_rd_busy <= 1;
      //hold values
        //sending_mem_rdresp2nvdla <= sending_mem_rdresp2nvdla;
        //saxi2nvdla_axi_slave_rlast <= saxi2nvdla_axi_slave_rlast;
        //rd_data_burst_count <= rd_data_burst_count;
    end else if (nvdla2saxi_axi_slave_rready && sending_mem_rdresp2nvdla) begin
      //push new values
      save_idfifo_signals <= 0;
      if(rd_data_burst_count > rdcmd2mem_len) begin
        sending_mem_rdresp2nvdla <= 0;
        rd_data_burst_count <= 0;
        saxi2nvdla_axi_slave_rvalid <= 0;
        saxi2nvdla_axi_slave_rlast <= 0;
        memresp_rdfifo_rd_busy <= 1;
        rdid_fifo_rd_busy <= 1;
      end else if(rd_data_burst_count == rdcmd2mem_len) begin
        if (memresp_rdfifo_rd_valid) begin
          //sending_mem_rdresp2nvdla <= 0;
          //saxi2nvdla_axi_slave_rlast <= 0;
          //rd_data_burst_count = 0;
          //saxi2nvdla_axi_slave_rvalid <= 1'b0;
          //memresp_rdfifo_rd_busy <= 1;
          //rdid_fifo_rd_busy <= 1;
          saxi2nvdla_axi_slave_rlast <= 1;
          rd_data_burst_count <= rd_data_burst_count + 1;
          saxi2nvdla_axi_slave_rdata <= memresp_rdfifo_rd_bus;
          saxi2nvdla_axi_slave_rid <= rdcmd2mem_id;
          saxi2nvdla_axi_slave_rvalid <= 1'b1;
          memresp_rdfifo_rd_busy <= 1; //Make rdfifo busy. New txn will pop this instead
          rdid_fifo_rd_busy <= 0;
          save_idfifo_signals <= 1;
        end else begin
          rdid_fifo_rd_busy <= 1;
          saxi2nvdla_axi_slave_rvalid <= 1'b0;
          memresp_rdfifo_rd_busy <= 1;
        end
      end else begin
        sending_mem_rdresp2nvdla <= sending_mem_rdresp2nvdla;
        saxi2nvdla_axi_slave_rlast <= 0;
        rdid_fifo_rd_busy <= 1;
        if (memresp_rdfifo_rd_valid) begin
          rd_data_burst_count <= rd_data_burst_count+1;
          saxi2nvdla_axi_slave_rdata <= memresp_rdfifo_rd_bus;
          saxi2nvdla_axi_slave_rid <= rdcmd2mem_id;
          saxi2nvdla_axi_slave_rvalid <= 1'b1;
          memresp_rdfifo_rd_busy <= 0;
        end else begin
          saxi2nvdla_axi_slave_rvalid <= 1'b0;
          memresp_rdfifo_rd_busy <= 1;
        end
      end
    end

    // The data should only be used if nvdla axi is smaller than memory port
    // In which case these hold the rdfifo value to split and shift data back
    // The other signals should be used multiple times for multiple beats
    // Need to take care that id_fifo_busy is tapped less often if len>0
    if(~memresp_rdfifo_rd_busy) begin //if not busy (reading) 
      mem_rdret_data    <= (memresp_rdfifo_rd_valid && ~memresp_rdfifo_rd_busy) ? memresp_rdfifo_rd_bus : {`DATABUS2MEM_WIDTH{1'b0}};
    end
    if(save_idfifo_signals) begin
      mem_rdret_id      <= rdcmd2mem_id;
      mem_rdret_arlen   <= rdcmd2mem_len;
      mem_rdret_araddr  <= rdcmd2mem_addr;
      rd_data_burst_count <= 4'b0000;
    end     // rdid_fifo_rd_busy
    
    // Invalidate rdata table entry on last beat
    if (saxi2nvdla_axi_slave_rlast) begin
       //display ReadResp info
`ifdef AXI_MEM_DEBUG
       $display("%0t ReadResp_temp(Channel%0d):prev saxi2nvdla_rdata=0x%032x", $time, AXI_SLAVE_ID, saxi2nvdla_axi_slave_rdata); // spyglass disable  W213
`endif
       rdata_table_req_time_delta = $time-rdata_table_req_time[mem_rdret_id];
       $display("AXI_MEM_XACTION: ReadResp: CHANNEL=%0d START_TIME=%0t END_TIME=%0t RID=0x%08x RDATA=0x%0128x LATENCY=%0t LEN=%0d",AXI_SLAVE_ID, rdata_table_timestamp[mem_rdret_id], $time, mem_rdret_id, rdata_table_data[mem_rdret_id], rdata_table_req_time_delta, rdata_table_len[mem_rdret_id]);  // spyglass disable  W213
      rdata_table_valid[mem_rdret_id] <= 1'b0; 
    end

    // Master and slave are valid/ready. Validate table entry
    if(saxi2nvdla_axi_slave_arready & nvdla2saxi_axi_slave_arvalid) begin
      if (rdata_table_valid[nvdla2saxi_axi_slave_arid]) begin  
`ifdef AXI_MEM_DEBUG
          $display ("Warning: Read Request of id 0x%08x is already in the queue!", nvdla2saxi_axi_slave_arid);  // spyglass disable  W213
`endif
      end else begin
        if (!saxi2nvdla_axi_slave_rlast) begin

          rdata_table_req_time[nvdla2saxi_axi_slave_arid] <= $time;      
          rdata_table_valid   [nvdla2saxi_axi_slave_arid] <= 1'b1;      
        end
      end
    end

    if(sending_mem_rdresp2nvdla) begin
      //save_idfifo_signals <= 0;
      // Send out first beat regardless of slave rready. It holds until rready is seen
      // For this first beat pick it directly out of the fifo outputs, rest of the beats use mem_rdret* info
      // mem_rdret_data has the data from memory, process it based on addr/size
      if(rd_data_burst_count == 4'b0000) begin      // First read beat to be sent back to DLA
        rdata_table_timestamp[rdcmd2mem_id] <= $time;
        rdata_table_data[rdcmd2mem_id][`DATABUS2MEM_WIDTH-1:0] <= 0;
        rdata_table_len[rdcmd2mem_id] <= rdcmd2mem_len;
        if((rdcmd2mem_addr & `AXI_ADDR_WIDTH'h1f) != `AXI_ADDR_WIDTH'h00) begin
          $display("Error: Addresses unaligned to 64B boundaries are unsupported");
        end

        //saxi2nvdla_axi_slave_rdata <= memresp_rdfifo_rd_bus;
        rdata_table_data[rdcmd2mem_id] <= memresp_rdfifo_rd_bus;
        if (memresp_rdfifo_rd_valid) begin
          //saxi2nvdla_axi_slave_rvalid <= 1'b1;
          //saxi2nvdla_axi_slave_rid <= rdcmd2mem_id;
          //rd_data_burst_count <= rd_data_burst_count + 1;
          //saxi2nvdla_axi_slave_rlast <= (rd_data_burst_count == rdcmd2mem_len);
        end else begin
          //saxi2nvdla_axi_slave_rvalid <= 1'b0;
        end
        
`ifdef AXI_MEM_DEBUG
        $display("%0t ReadResp_temp(Channel%0d): count = 0x%x, RDATA = 0x%0128x, len=%d", $time, AXI_SLAVE_ID, rd_data_burst_count, memresp_rdfifo_rd_bus[`DATABUS2MEM_WIDTH-1:0], rdcmd2mem_len); // spyglass disable  W213
        $display("%0t ReadResp_temp(Channel%0d): RID = 0x%010x", $time, AXI_SLAVE_ID, rdcmd2mem_id); // spyglass disable  W213
`endif
      end else begin //rd_data_burst_count > 0
        if(nvdla2saxi_axi_slave_rready && (rd_data_burst_count <= mem_rdret_arlen)) begin // nvdla accepted the data move to the next one
          //saxi2nvdla_axi_slave_rdata <= memresp_rdfifo_rd_bus;
          rdata_table_data[mem_rdret_id] <= memresp_rdfifo_rd_bus;
          if (memresp_rdfifo_rd_valid) begin
            //saxi2nvdla_axi_slave_rvalid <= 1'b1;
            //saxi2nvdla_axi_slave_rid <= mem_rdret_id; //Latter beats use saved id value
            //rd_data_burst_count <= rd_data_burst_count + 1;
            //saxi2nvdla_axi_slave_rlast <= (rd_data_burst_count == mem_rdret_arlen);
          end else begin
            //saxi2nvdla_axi_slave_rvalid <= 1'b0;
          end
`ifdef AXI_MEM_DEBUG
          $display("%0t ReadResp_temp(Channel%0d): RID = 0x%08x", $time, AXI_SLAVE_ID, mem_rdret_id); // spyglass disable  W213
          $display("%0t ReadResp_temp(Channel%0d): count = 0x%x, RDATA = 0x%0128x, prev saxi2nvdla_rdata=0x%0128x", $time, AXI_SLAVE_ID, rd_data_burst_count, mem_rdret_data[`DATABUS2MEM_WIDTH-1:0], saxi2nvdla_axi_slave_rdata); // spyglass disable  W213
`endif
        end     // rready
      end   // rd_data_burst_count

    end     // sending_mem_rdresp2nvdla

  end   // !reset
end

// Logic for keeping track of outstanding read/write transactions 
always @ (posedge clk or negedge reset) begin
  if(!reset) begin
    outstanding_rd_count <= 0;
    outstanding_wraddr_count <= 0;
    outstanding_wrdata_count <= 0;
    rd_count_inc <= 0;
    rd_count_dec <= 0;
    wraddr_count_inc <= 0;
    wraddr_count_dec <= 0;
    wrdata_count_inc <= 0;
    wrdata_count_dec <= 0;
  end else begin

    rd_count_inc <= 0;
    rd_count_dec <= 0;
    wraddr_count_inc <= 0;
    wraddr_count_dec <= 0;
    wrdata_count_inc <= 0;
    wrdata_count_dec <= 0;

    if(saxi2nvdla_axi_slave_bvalid & nvdla2saxi_axi_slave_bready) begin
      wraddr_count_dec <= 1;
      wrdata_count_dec <= 1;
    end
    if(saxi2nvdla_axi_slave_rvalid & saxi2nvdla_axi_slave_rlast & nvdla2saxi_axi_slave_rready)
      rd_count_dec <= 1;

    if(saxi2nvdla_axi_slave_arready & nvdla2saxi_axi_slave_arvalid)
      rd_count_inc <= 1;
    if(nvdla2saxi_axi_slave_wlast & nvdla2saxi_axi_slave_wvalid & saxi2nvdla_axi_slave_wready)
      wrdata_count_inc <= 1;
    if(saxi2nvdla_axi_slave_awready & nvdla2saxi_axi_slave_awvalid)
      wraddr_count_inc <= 1;

    {carry_rd_count,outstanding_rd_count}         <= outstanding_rd_count + rd_count_inc - rd_count_dec;
    {carry_wraddr_count,outstanding_wraddr_count} <= outstanding_wraddr_count + wraddr_count_inc - wraddr_count_dec;
    {carry_wrdata_count,outstanding_wrdata_count} <= outstanding_wrdata_count + wrdata_count_inc - wrdata_count_dec;
     
  end   // !reset
end

    assert_module a1 (
      .clk		(clk)
      ,.test		(carry_rd_count || carry_wraddr_count || carry_wrdata_count)
   );
  
endmodule



