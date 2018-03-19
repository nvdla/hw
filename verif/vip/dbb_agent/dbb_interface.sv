`ifndef _NVDLA_DBB_IF_SV
`define _NVDLA_DBB_IF_SV

/// nvdla DBB bus interface.
interface dbb_interface#(int MEM_DATA_WIDTH=512) (input clk, input rst_n);
    parameter MEM_WSTRB_WIDTH = MEM_DATA_WIDTH/8;

    //-----------------------------------------------------------------------
    // DBB Interface Write Address Channel Signals
    //-----------------------------------------------------------------------
    wire                             awvalid;
    wire [`DBB_ADDR_WIDTH-1:0]       awaddr;
    wire [`DBB_ALEN_WIDTH-1:0]       awlen;
    wire [`DBB_ASIZE_WIDTH-1:0]      awsize;
    wire [`DBB_ABURST_WIDTH-1:0]     awburst;
    wire [`DBB_AID_WIDTH-1:0]        awid;
    wire                             awready;

    //-----------------------------------------------------------------------
    // DBB Interface Read Address Channel Signals
    //-----------------------------------------------------------------------
    wire                             arvalid;
    wire [`DBB_ADDR_WIDTH-1:0]       araddr;
    wire [`DBB_ALEN_WIDTH-1:0]       arlen;
    wire [`DBB_ASIZE_WIDTH-1:0]      arsize;
    wire [`DBB_ABURST_WIDTH-1:0]     arburst;
    wire [`DBB_AID_WIDTH-1:0]        arid;
    wire                             arready;

    //-----------------------------------------------------------------------
    // DBB Interface Read Channel Signals
    //-----------------------------------------------------------------------
    wire                             rvalid;
    wire                             rlast;
    wire [MEM_DATA_WIDTH-1:0]        rdata;
    wire [`DBB_MASTER_RID_WIDTH-1:0] rid;
    wire                             rready;

    //-----------------------------------------------------------------------
    // DBB Interface Write Channel Signals
    //-----------------------------------------------------------------------
    wire                             wvalid;
    wire                             wlast;
    wire [MEM_DATA_WIDTH-1:0]        wdata;
    wire [MEM_WSTRB_WIDTH-1:0]       wstrb;
    wire                             wready;
    
    //-----------------------------------------------------------------------
    // DBB Interface Write Response Channel Signals
    //-----------------------------------------------------------------------
    wire                             bvalid;
    wire [`DBB_BRESP_WIDTH-1:0]      bresp;
    wire [`DBB_MASTER_BID_WIDTH-1:0] bid;
    wire                             bready;

    //-----------------------------------------------------------------------
    // Clocking block that defines VIP DBB Master Interface
    // signal synchronization and directionality.

    clocking mclk @(posedge clk);
        default input #`DBB_IF_SETUP output #`DBB_IF_HOLD;
        input  rst_n;

        output awvalid;
        output awaddr;
        output awlen;
        output awsize;
        output awburst;
        output awid;
        input  awready;
        
        output arvalid;
        output araddr;
        output arlen;
        output arsize;
        output arburst;
        output arid;
        input  arready;

        input  rvalid;
        input  rlast;
        input  rdata;
        input  rid;
        output rready;

        output wvalid;
        output wlast;
        output wdata;
        output wstrb;
        input  wready;
        
        input  bvalid;
        input  bresp;
        input  bid;
        output bready;

    endclocking : mclk


    //-----------------------------------------------------------------------
    // Clocking block that defines the VIP DBB slave Interface
    // signal synchronization and directionality.

    clocking sclk @(posedge clk);
        default input #`DBB_IF_SETUP output #`DBB_IF_HOLD;
        input  rst_n;

        input  awvalid;
        input  awaddr;
        input  awlen;
        input  awsize;
        input  awburst;
        input  awid;
        output awready;
        
        input  arvalid;
        input  araddr;
        input  arlen;
        input  arsize;
        input  arburst;
        input  arid;
        output arready;

        output rvalid;
        output rlast;
        output rdata;
        output rid;
        input  rready;
        
        input  wvalid;
        input  wlast;
        input  wdata;
        input  wstrb;
        output wready;
        
        output bvalid;
        output bresp;
        output bid;
        input  bready;

    endclocking : sclk

    //-----------------------------------------------------------------------
    // Clocking block that defines the DBB Monitor Interface
    // signal synchronization and directionality.

    clocking monclk @(posedge clk);
        default input #`DBB_IF_SETUP output #`DBB_IF_HOLD;
        input  rst_n;

        input  arready;
        input  arvalid;
        input  araddr;
        input  arlen;
        input  arsize;
        input  arburst;
        input  arid;

        input  awready;
        input  awvalid;
        input  awaddr;
        input  awlen;
        input  awsize;
        input  awburst;
        input  awid;

        input  rready;
        input  rvalid;
        input  rlast;
        input  rdata;
        input  rid;

        input  wready;
        input  wvalid;
        input  wlast;
        input  wdata;
        input  wstrb;
        
        input  bready;
        input  bvalid;
        input  bresp;
        input  bid;

    endclocking : monclk 

    //------------------------------------------------------------------------
    // Modports used to connect the DBB VIP to DBB interface signals.
    modport Master (
                    clocking mclk,
                    input rst_n,
                    input clk,
                    input awready
                    );
    modport Slave (
                   clocking sclk,
                   input rst_n,
                   input clk
                   );
    modport Monitor (
                     clocking monclk,
                     input rst_n,
                     input clk
                     );

    //------------------------------------------------------------------------

    bit en_dbb_assrt = 0;   // Default value should be 1 once they're implemented b/c assertions are on by default. But for now it is 0 because they're unimplemented

endinterface: dbb_interface

`endif
