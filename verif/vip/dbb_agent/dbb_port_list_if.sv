
//----------------------------------------------------------------------
// module: dbb_alias_if_wrapper
//
// This is a wrapper module that compensates for the fact that not all
// the wires in the interface are visible on the port list.  We use
// alias statements to connect wrapper wires to interface wires.  Alias
// is a new feature in IEEE 1800-2012.
//----------------------------------------------------------------------

module dbb_interface_wrapper #(
                              int  unsigned DBB_ADDR_WIDTH       = `DBB_ADDR_WIDTH,
                              int  unsigned DBB_DATA_WIDTH       = `DBB_DATA_WIDTH,
                              int  unsigned DBB_ALEN_WIDTH       = `DBB_ALEN_WIDTH,
                              int  unsigned DBB_ASIZE_WIDTH      = `DBB_ASIZE_WIDTH,
                              int  unsigned DBB_ABURST_WIDTH     = `DBB_ABURST_WIDTH,
                              int  unsigned DBB_AID_WIDTH        = `DBB_AID_WIDTH,
                              int  unsigned DBB_AVALID_WIDTH     = `DBB_AVALID_WIDTH,
                              int  unsigned DBB_AREADY_WIDTH     = `DBB_AREADY_WIDTH,
                              int  unsigned DBB_RID_WIDTH        = DBB_AID_WIDTH,
                              int  unsigned DBB_MASTER_RID_WIDTH = DBB_AID_WIDTH,
                              int  unsigned DBB_SLAVE_RID_WIDTH  = DBB_AID_WIDTH,
                              int  unsigned DBB_WSTRB_WIDTH      = DBB_DATA_WIDTH/8,
                              int  unsigned DBB_WID_WIDTH        = DBB_AID_WIDTH,
                              int  unsigned DBB_MASTER_WID_WIDTH = DBB_AID_WIDTH,
                              int  unsigned DBB_SLAVE_WID_WIDTH  = DBB_AID_WIDTH,
                              int  unsigned DBB_BRESP_WIDTH      = `DBB_BRESP_WIDTH,
                              int  unsigned DBB_BID_WIDTH        = DBB_AID_WIDTH,
                              int  unsigned DBB_MASTER_BID_WIDTH = DBB_AID_WIDTH,
                              int  unsigned DBB_SLAVE_BID_WIDTH  = DBB_AID_WIDTH,
                              time          DBB_IF_SETUP         = `DBB_IF_SETUP,
                              time          DBB_IF_HOLD          = `DBB_IF_HOLD,
                              int  unsigned DBB_WDEPTH           = `DBB_WDEPTH,
                              int  unsigned DBB_RDEPTH           = `DBB_RDEPTH,
                              int  unsigned DBB_MAX_OUTSTANDING  = `DBB_MAX_OUTSTANDING,
                              int  unsigned DBB_MAXWAITS         = `DBB_MAXWAITS,
                              int  unsigned DBB_EXMON_WIDTH      = `DBB_EXMON_WIDTH
                                )
  (
    wire                             clk,
    wire                             rst_n,
    wire                             awvalid,
    wire [DBB_ADDR_WIDTH-1:0]       awaddr,
    wire [DBB_ALEN_WIDTH-1:0]       awlen,
    wire [DBB_ASIZE_WIDTH-1:0]      awsize,
    wire [DBB_ABURST_WIDTH-1:0]     awburst,
    wire [DBB_AID_WIDTH-1:0]        awid,
    wire                            awready,
    wire                            arvalid,
    wire [DBB_ADDR_WIDTH-1:0]       araddr,
    wire [DBB_ALEN_WIDTH-1:0]       arlen,
    wire [DBB_ASIZE_WIDTH-1:0]      arsize,
    wire [DBB_ABURST_WIDTH-1:0]     arburst,
    wire [DBB_AID_WIDTH-1:0]        arid,
    wire                            arready,
    wire                            rvalid,
    wire                            rlast,
    wire [DBB_DATA_WIDTH-1:0]       rdata,
    wire [DBB_MASTER_RID_WIDTH-1:0] rid,
    wire                            rready,
    wire                            wvalid,
    wire                            wlast,
    wire [DBB_DATA_WIDTH-1:0]       wdata,
    wire [DBB_WSTRB_WIDTH-1:0]      wstrb,
    wire                            wready,
    wire                            bvalid,
    wire [DBB_BRESP_WIDTH-1:0]      bresp,
    wire [DBB_MASTER_BID_WIDTH-1:0] bid,
    wire                            bready

  );

  dbb_interface#(`DBB_DATA_WIDTH) dbb_interface(.clk(clk), .rst_n(rst_n));

  alias dbb_interface.clk                                 = clk;
  alias dbb_interface.rst_n                               = rst_n;
  alias dbb_interface.awvalid                             = awvalid;
  alias dbb_interface.awaddr   [DBB_ADDR_WIDTH-1:0]       = awaddr;
  alias dbb_interface.awlen    [DBB_ALEN_WIDTH-1:0]       = awlen;
  alias dbb_interface.awsize   [DBB_ASIZE_WIDTH-1:0]      = awsize;
  alias dbb_interface.awburst  [DBB_ABURST_WIDTH-1:0]     = awburst;
  alias dbb_interface.awid     [DBB_AID_WIDTH-1:0]        = awid;
  alias dbb_interface.awready                             = awready;
  alias dbb_interface.arvalid                             = arvalid;
  alias dbb_interface.araddr   [DBB_ADDR_WIDTH-1:0]       = araddr;
  alias dbb_interface.arlen    [DBB_ALEN_WIDTH-1:0]       = arlen;
  alias dbb_interface.arsize   [DBB_ASIZE_WIDTH-1:0]      = arsize;
  alias dbb_interface.arburst  [DBB_ABURST_WIDTH-1:0]     = arburst;
  alias dbb_interface.arid     [DBB_AID_WIDTH-1:0]        = arid;
  alias dbb_interface.arready                             = arready;
  alias dbb_interface.rvalid                              = rvalid;
  alias dbb_interface.rlast                               = rlast;
  alias dbb_interface.rdata    [DBB_DATA_WIDTH-1:0]       = rdata;
  alias dbb_interface.rid      [DBB_MASTER_RID_WIDTH-1:0] = rid;
  alias dbb_interface.rready                              = rready;
  alias dbb_interface.wvalid                              = wvalid;
  alias dbb_interface.wlast                               = wlast;
  alias dbb_interface.wdata    [DBB_DATA_WIDTH-1:0]       = wdata;
  alias dbb_interface.wstrb    [DBB_WSTRB_WIDTH-1:0]      = wstrb;
  alias dbb_interface.wready                              = wready;
  alias dbb_interface.bvalid                              = bvalid;
  alias dbb_interface.bresp    [DBB_BRESP_WIDTH-1:0]      = bresp;
  alias dbb_interface.bid      [DBB_MASTER_BID_WIDTH-1:0] = bid;
  alias dbb_interface.bready                              = bready;

`ifdef DBB_ASSERTIONS

// Instantiate DBB Assertions package
//dbb_assertions
//#(
//    .DATA_WIDTH( DBB_DATA_WIDTH ),
//    .ID_WIDTH( DBB_AID_WIDTH ),
//    .WDEPTH( DBB_WDEPTH ),
//    .MAXRBURSTS( DBB_MAX_OUTSTANDING ),
//    .MAXWBURSTS( DBB_MAX_OUTSTANDING ),
//    .MAXWAITS( DBB_MAXWAITS ),
//    .ADDR_WIDTH( DBB_ADDR_WIDTH ),
//    .EXMON_WIDTH( DBB_EXMON_WIDTH )
//) dbb_assert(dbb_interface);


//  Implement a better solution for controlling assertions from the agent.
always @( dbb_interface.en_dbb_assrt ) begin
    if ( dbb_interface.en_dbb_assrt )  $asserton( 0, dbb_assert );
    else                        $assertoff( 0, dbb_assert );
end

`endif

endmodule
