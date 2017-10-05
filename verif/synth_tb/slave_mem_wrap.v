
// Wrapper for the two AXI slaves and the memory module
module syn_slave_mem_wrap (
    clk,
    fast_clk,
    reset,

    saxi2nvdla_axi_slave0_arready                ,
    saxi2nvdla_axi_slave0_awready                ,
    saxi2nvdla_axi_slave0_bid                    ,
    saxi2nvdla_axi_slave0_bresp                  ,
    saxi2nvdla_axi_slave0_bvalid                 ,
    saxi2nvdla_axi_slave0_rdata                  ,
    saxi2nvdla_axi_slave0_rid                    ,
    saxi2nvdla_axi_slave0_rlast                  ,
    saxi2nvdla_axi_slave0_rresp                  ,
    saxi2nvdla_axi_slave0_rvalid                 ,
    saxi2nvdla_axi_slave0_wready                 ,

    saxi2nvdla_axi_slave1_arready                ,
    saxi2nvdla_axi_slave1_awready                ,
    saxi2nvdla_axi_slave1_bid                    ,
    saxi2nvdla_axi_slave1_bresp                  ,
    saxi2nvdla_axi_slave1_bvalid                 ,
    saxi2nvdla_axi_slave1_rdata                  ,
    saxi2nvdla_axi_slave1_rid                    ,
    saxi2nvdla_axi_slave1_rlast                  ,
    saxi2nvdla_axi_slave1_rresp                  ,
    saxi2nvdla_axi_slave1_rvalid                 ,
    saxi2nvdla_axi_slave1_wready                 ,

    nvdla2saxi_axi_slave0_araddr                 ,
    nvdla2saxi_axi_slave0_arburst                ,
    nvdla2saxi_axi_slave0_arcache                ,
    nvdla2saxi_axi_slave0_arid                   ,
    nvdla2saxi_axi_slave0_arlen                  ,
    nvdla2saxi_axi_slave0_arlock                 ,
    nvdla2saxi_axi_slave0_arprot                 ,
    nvdla2saxi_axi_slave0_arsize                 ,
    nvdla2saxi_axi_slave0_arvalid                ,
    nvdla2saxi_axi_slave0_awaddr                 ,
    nvdla2saxi_axi_slave0_awburst                ,
    nvdla2saxi_axi_slave0_awcache                ,
    nvdla2saxi_axi_slave0_awid                   ,
    nvdla2saxi_axi_slave0_awlen                  ,
    nvdla2saxi_axi_slave0_awlock                 ,
    nvdla2saxi_axi_slave0_awprot                 ,
    nvdla2saxi_axi_slave0_awsize                 ,
    nvdla2saxi_axi_slave0_awvalid                ,
    nvdla2saxi_axi_slave0_bready                 ,
    nvdla2saxi_axi_slave0_rready                 ,
    nvdla2saxi_axi_slave0_wdata                  ,
    nvdla2saxi_axi_slave0_wid                    ,
    nvdla2saxi_axi_slave0_wlast                  ,
    nvdla2saxi_axi_slave0_wstrb                  ,
    nvdla2saxi_axi_slave0_wvalid                 ,

    nvdla2saxi_axi_slave1_araddr                 ,
    nvdla2saxi_axi_slave1_arburst                ,
    nvdla2saxi_axi_slave1_arcache                ,
    nvdla2saxi_axi_slave1_arid                   ,
    nvdla2saxi_axi_slave1_arlen                  ,
    nvdla2saxi_axi_slave1_arlock                 ,
    nvdla2saxi_axi_slave1_arprot                 ,
    nvdla2saxi_axi_slave1_arsize                 ,
    nvdla2saxi_axi_slave1_arvalid                ,
    nvdla2saxi_axi_slave1_awaddr                 ,
    nvdla2saxi_axi_slave1_awburst                ,
    nvdla2saxi_axi_slave1_awcache                ,
    nvdla2saxi_axi_slave1_awid                   ,
    nvdla2saxi_axi_slave1_awlen                  ,
    nvdla2saxi_axi_slave1_awlock                 ,
    nvdla2saxi_axi_slave1_awprot                 ,
    nvdla2saxi_axi_slave1_awsize                 ,
    nvdla2saxi_axi_slave1_awvalid                ,
    nvdla2saxi_axi_slave1_bready                 ,
    nvdla2saxi_axi_slave1_rready                 ,
    nvdla2saxi_axi_slave1_wdata                  ,
    nvdla2saxi_axi_slave1_wid                    ,
    nvdla2saxi_axi_slave1_wlast                  ,
    nvdla2saxi_axi_slave1_wstrb                  ,
    nvdla2saxi_axi_slave1_wvalid
);

input   clk;
input   fast_clk;
input   reset;

output                                saxi2nvdla_axi_slave0_arready         ;
output                                saxi2nvdla_axi_slave0_awready         ;
output     [`AXI_SLAVE_BID_WIDTH-1:0] saxi2nvdla_axi_slave0_bid             ;
output                          [1:0] saxi2nvdla_axi_slave0_bresp           ;
output                                saxi2nvdla_axi_slave0_bvalid          ;
output                        [`DATABUS2MEM_WIDTH-1:0] saxi2nvdla_axi_slave0_rdata           ;
output     [`AXI_SLAVE_RID_WIDTH-1:0] saxi2nvdla_axi_slave0_rid             ;
output                                saxi2nvdla_axi_slave0_rlast           ;
output                          [1:0] saxi2nvdla_axi_slave0_rresp           ;
output                                saxi2nvdla_axi_slave0_rvalid          ;
output                                saxi2nvdla_axi_slave0_wready          ;

output                                saxi2nvdla_axi_slave1_arready         ;
output                                saxi2nvdla_axi_slave1_awready         ;
output     [`AXI_SLAVE_BID_WIDTH-1:0] saxi2nvdla_axi_slave1_bid             ;
output                          [1:0] saxi2nvdla_axi_slave1_bresp           ;
output                                saxi2nvdla_axi_slave1_bvalid          ;
output                        [`DATABUS2MEM_WIDTH-1:0] saxi2nvdla_axi_slave1_rdata           ;
output     [`AXI_SLAVE_RID_WIDTH-1:0] saxi2nvdla_axi_slave1_rid             ;
output                                saxi2nvdla_axi_slave1_rlast           ;
output                          [1:0] saxi2nvdla_axi_slave1_rresp           ;
output                                saxi2nvdla_axi_slave1_rvalid          ;
output                                saxi2nvdla_axi_slave1_wready          ;

input           [`AXI_ADDR_WIDTH-1:0] nvdla2saxi_axi_slave0_araddr          ;
input                           [1:0] nvdla2saxi_axi_slave0_arburst         ;
input                           [3:0] nvdla2saxi_axi_slave0_arcache         ;
input      [`AXI_SLAVE_RID_WIDTH-1:0] nvdla2saxi_axi_slave0_arid            ;
input                           [`AXI_LEN_WIDTH-1:0] nvdla2saxi_axi_slave0_arlen           ;
input                           [1:0] nvdla2saxi_axi_slave0_arlock          ;
input                           [2:0] nvdla2saxi_axi_slave0_arprot          ;
input                           [2:0] nvdla2saxi_axi_slave0_arsize          ;
input                                 nvdla2saxi_axi_slave0_arvalid         ;
input           [`AXI_ADDR_WIDTH-1:0] nvdla2saxi_axi_slave0_awaddr          ;
input                           [1:0] nvdla2saxi_axi_slave0_awburst         ;
input                           [3:0] nvdla2saxi_axi_slave0_awcache         ;
input      [`AXI_SLAVE_WID_WIDTH-1:0] nvdla2saxi_axi_slave0_awid            ;
input                           [`AXI_LEN_WIDTH-1:0] nvdla2saxi_axi_slave0_awlen           ;
input                           [1:0] nvdla2saxi_axi_slave0_awlock          ;
input                           [2:0] nvdla2saxi_axi_slave0_awprot          ;
input                           [2:0] nvdla2saxi_axi_slave0_awsize          ;
input                                 nvdla2saxi_axi_slave0_awvalid         ;
input                                 nvdla2saxi_axi_slave0_bready          ;
input                                 nvdla2saxi_axi_slave0_rready          ;
input                         [`DATABUS2MEM_WIDTH-1:0] nvdla2saxi_axi_slave0_wdata           ;
input      [`AXI_SLAVE_WID_WIDTH-1:0] nvdla2saxi_axi_slave0_wid             ;
input                                 nvdla2saxi_axi_slave0_wlast           ;
input                          [(`DATABUS2MEM_WIDTH/8)-1:0] nvdla2saxi_axi_slave0_wstrb           ;
input                                 nvdla2saxi_axi_slave0_wvalid          ;

input                          [`AXI_ADDR_WIDTH-1:0] nvdla2saxi_axi_slave1_araddr          ;
input                           [1:0] nvdla2saxi_axi_slave1_arburst         ;
input                           [3:0] nvdla2saxi_axi_slave1_arcache         ;
input      [`AXI_SLAVE_RID_WIDTH-1:0] nvdla2saxi_axi_slave1_arid            ;
input                           [`AXI_LEN_WIDTH-1:0] nvdla2saxi_axi_slave1_arlen           ;
input                           [1:0] nvdla2saxi_axi_slave1_arlock          ;
input                           [2:0] nvdla2saxi_axi_slave1_arprot          ;
input                           [2:0] nvdla2saxi_axi_slave1_arsize          ;
input                                 nvdla2saxi_axi_slave1_arvalid         ;
input                          [`AXI_ADDR_WIDTH-1:0] nvdla2saxi_axi_slave1_awaddr          ;
input                           [1:0] nvdla2saxi_axi_slave1_awburst         ;
input                           [3:0] nvdla2saxi_axi_slave1_awcache         ;
input      [`AXI_SLAVE_WID_WIDTH-1:0] nvdla2saxi_axi_slave1_awid            ;
input                           [`AXI_LEN_WIDTH-1:0] nvdla2saxi_axi_slave1_awlen           ;
input                           [1:0] nvdla2saxi_axi_slave1_awlock          ;
input                           [2:0] nvdla2saxi_axi_slave1_awprot          ;
input                           [2:0] nvdla2saxi_axi_slave1_awsize          ;
input                                 nvdla2saxi_axi_slave1_awvalid         ;
input                                 nvdla2saxi_axi_slave1_bready          ;
input                                 nvdla2saxi_axi_slave1_rready          ;
input                         [`DATABUS2MEM_WIDTH-1:0] nvdla2saxi_axi_slave1_wdata           ;
input      [`AXI_SLAVE_WID_WIDTH-1:0] nvdla2saxi_axi_slave1_wid             ;
input                                 nvdla2saxi_axi_slave1_wlast           ;
input                          [(`DATABUS2MEM_WIDTH/8)-1:0] nvdla2saxi_axi_slave1_wstrb           ;
input                                 nvdla2saxi_axi_slave1_wvalid          ;

wire            saxi02mem_cmd_wr       ;
wire            saxi02mem_cmd_rd       ;
wire    [`AXI_ADDR_WIDTH-1:0]  saxi02mem_addr_wr      ;
wire    [`AXI_ADDR_WIDTH-1:0]  saxi02mem_addr_rd      ;
wire   [`WORD_SIZE-1:0]  saxi02mem_data         ;
wire    [(`DATABUS2MEM_WIDTH/8)-1:0]  saxi02mem_wstrb        ;
wire     [`AXI_LEN_WIDTH-1:0]  saxi02mem_len_rd       ;
wire     [`AXI_LEN_WIDTH-1:0]  saxi02mem_len_wr       ;
wire     [2:0]  saxi02mem_size_rd      ;
wire     [2:0]  saxi02mem_size_wr      ;
wire            mem2saxi0_rdresp       ;
wire            mem2saxi0_wrresp       ;
wire   [`DATABUS2MEM_WIDTH-1:0]  mem2saxi0_rddata       ;
wire            mem2saxi0_rd_ready     ;
wire            mem2saxi0_wr_ready     ;

wire            saxi12mem_cmd_wr       ;
wire            saxi12mem_cmd_rd       ;
wire    [`AXI_ADDR_WIDTH-1:0]  saxi12mem_addr_rd      ;
wire    [`AXI_ADDR_WIDTH-1:0]  saxi12mem_addr_wr      ;
wire   [`WORD_SIZE-1:0]  saxi12mem_data         ;
wire    [(`DATABUS2MEM_WIDTH/8)-1:0]  saxi12mem_wstrb        ;
wire     [`AXI_LEN_WIDTH-1:0]  saxi12mem_len_rd       ;
wire     [`AXI_LEN_WIDTH-1:0]  saxi12mem_len_wr       ;
wire     [2:0]  saxi12mem_size_rd      ;
wire     [2:0]  saxi12mem_size_wr      ;
wire            mem2saxi1_rdresp       ;
wire            mem2saxi1_wrresp       ;
wire   [`WORD_SIZE-1:0]  mem2saxi1_rddata       ;
wire            mem2saxi1_rd_ready     ;
wire            mem2saxi1_wr_ready     ;
wire            axi_clk                ;

  syn_axi_slave #(0) axi_slave0 (
     .clk                           (clk)
    ,.reset				            (reset)

    ,.saxi2nvdla_axi_slave_arready    (saxi2nvdla_axi_slave0_arready)
    ,.saxi2nvdla_axi_slave_awready    (saxi2nvdla_axi_slave0_awready)
    ,.saxi2nvdla_axi_slave_bid        (saxi2nvdla_axi_slave0_bid    )
    ,.saxi2nvdla_axi_slave_bresp      (saxi2nvdla_axi_slave0_bresp  )
    ,.saxi2nvdla_axi_slave_bvalid     (saxi2nvdla_axi_slave0_bvalid )
    ,.saxi2nvdla_axi_slave_rdata      (saxi2nvdla_axi_slave0_rdata  )
    ,.saxi2nvdla_axi_slave_rid        (saxi2nvdla_axi_slave0_rid    )
    ,.saxi2nvdla_axi_slave_rlast      (saxi2nvdla_axi_slave0_rlast  )
    ,.saxi2nvdla_axi_slave_rresp      (saxi2nvdla_axi_slave0_rresp  )
    ,.saxi2nvdla_axi_slave_rvalid     (saxi2nvdla_axi_slave0_rvalid )
    ,.saxi2nvdla_axi_slave_wready     (saxi2nvdla_axi_slave0_wready )

    ,.nvdla2saxi_axi_slave_araddr     (nvdla2saxi_axi_slave0_araddr )
    ,.nvdla2saxi_axi_slave_arburst    (nvdla2saxi_axi_slave0_arburst)
    ,.nvdla2saxi_axi_slave_arcache    (nvdla2saxi_axi_slave0_arcache)
    ,.nvdla2saxi_axi_slave_arid       (nvdla2saxi_axi_slave0_arid   )
    ,.nvdla2saxi_axi_slave_arlen      (nvdla2saxi_axi_slave0_arlen  )
    ,.nvdla2saxi_axi_slave_arlock     (nvdla2saxi_axi_slave0_arlock )
    ,.nvdla2saxi_axi_slave_arprot     (nvdla2saxi_axi_slave0_arprot )
    ,.nvdla2saxi_axi_slave_arsize     (nvdla2saxi_axi_slave0_arsize )
    ,.nvdla2saxi_axi_slave_arvalid    (nvdla2saxi_axi_slave0_arvalid)
    ,.nvdla2saxi_axi_slave_awaddr     (nvdla2saxi_axi_slave0_awaddr )
    ,.nvdla2saxi_axi_slave_awburst    (nvdla2saxi_axi_slave0_awburst)
    ,.nvdla2saxi_axi_slave_awcache    (nvdla2saxi_axi_slave0_awcache)
    ,.nvdla2saxi_axi_slave_awid       (nvdla2saxi_axi_slave0_awid   )
    ,.nvdla2saxi_axi_slave_awlen      (nvdla2saxi_axi_slave0_awlen  )
    ,.nvdla2saxi_axi_slave_awlock     (nvdla2saxi_axi_slave0_awlock )
    ,.nvdla2saxi_axi_slave_awprot     (nvdla2saxi_axi_slave0_awprot )
    ,.nvdla2saxi_axi_slave_awsize     (nvdla2saxi_axi_slave0_awsize )
    ,.nvdla2saxi_axi_slave_awvalid    (nvdla2saxi_axi_slave0_awvalid)
    ,.nvdla2saxi_axi_slave_bready     (nvdla2saxi_axi_slave0_bready )
    ,.nvdla2saxi_axi_slave_rready     (nvdla2saxi_axi_slave0_rready )
    ,.nvdla2saxi_axi_slave_wdata      (nvdla2saxi_axi_slave0_wdata  )
    ,.nvdla2saxi_axi_slave_wid        (nvdla2saxi_axi_slave0_wid    )
    ,.nvdla2saxi_axi_slave_wlast      (nvdla2saxi_axi_slave0_wlast  )
    ,.nvdla2saxi_axi_slave_wstrb      (nvdla2saxi_axi_slave0_wstrb  )
    ,.nvdla2saxi_axi_slave_wvalid     (nvdla2saxi_axi_slave0_wvalid )

    ,.saxi2mem_cmd_wr               (saxi02mem_cmd_wr  )
    ,.saxi2mem_cmd_rd               (saxi02mem_cmd_rd  )
    ,.saxi2mem_addr_wr              (saxi02mem_addr_wr )
    ,.saxi2mem_addr_rd              (saxi02mem_addr_rd )
    ,.saxi2mem_data                 (saxi02mem_data    )
    ,.saxi2mem_wstrb                (saxi02mem_wstrb   )
    ,.saxi2mem_len_rd               (saxi02mem_len_rd  )
    ,.saxi2mem_len_wr               (saxi02mem_len_wr  )
    ,.saxi2mem_size_rd              (saxi02mem_size_rd )
    ,.saxi2mem_size_wr              (saxi02mem_size_wr )
    ,.mem2saxi_rdresp               (mem2saxi0_rdresp  )
    ,.mem2saxi_rddata               (mem2saxi0_rddata  )
    ,.mem2saxi_wrresp               (mem2saxi0_wrresp  )
    ,.mem2saxi_rd_ready             (mem2saxi0_rd_ready)
    ,.mem2saxi_wr_ready             (mem2saxi0_wr_ready)
  );

  syn_axi_slave #(1) axi_slave1 (
     .clk                           (clk)
    ,.reset				            (reset)

    ,.saxi2nvdla_axi_slave_arready    (saxi2nvdla_axi_slave1_arready)
    ,.saxi2nvdla_axi_slave_awready    (saxi2nvdla_axi_slave1_awready)
    ,.saxi2nvdla_axi_slave_bid        (saxi2nvdla_axi_slave1_bid    )
    ,.saxi2nvdla_axi_slave_bresp      (saxi2nvdla_axi_slave1_bresp  )
    ,.saxi2nvdla_axi_slave_bvalid     (saxi2nvdla_axi_slave1_bvalid )
    ,.saxi2nvdla_axi_slave_rdata      (saxi2nvdla_axi_slave1_rdata  )
    ,.saxi2nvdla_axi_slave_rid        (saxi2nvdla_axi_slave1_rid    )
    ,.saxi2nvdla_axi_slave_rlast      (saxi2nvdla_axi_slave1_rlast  )
    ,.saxi2nvdla_axi_slave_rresp      (saxi2nvdla_axi_slave1_rresp  )
    ,.saxi2nvdla_axi_slave_rvalid     (saxi2nvdla_axi_slave1_rvalid )
    ,.saxi2nvdla_axi_slave_wready     (saxi2nvdla_axi_slave1_wready )

    ,.nvdla2saxi_axi_slave_araddr     (nvdla2saxi_axi_slave1_araddr )
    ,.nvdla2saxi_axi_slave_arburst    (nvdla2saxi_axi_slave1_arburst)
    ,.nvdla2saxi_axi_slave_arcache    (nvdla2saxi_axi_slave1_arcache)
    ,.nvdla2saxi_axi_slave_arid       (nvdla2saxi_axi_slave1_arid   )
    ,.nvdla2saxi_axi_slave_arlen      (nvdla2saxi_axi_slave1_arlen  )
    ,.nvdla2saxi_axi_slave_arlock     (nvdla2saxi_axi_slave1_arlock )
    ,.nvdla2saxi_axi_slave_arprot     (nvdla2saxi_axi_slave1_arprot )
    ,.nvdla2saxi_axi_slave_arsize     (nvdla2saxi_axi_slave1_arsize )
    ,.nvdla2saxi_axi_slave_arvalid    (nvdla2saxi_axi_slave1_arvalid)
    ,.nvdla2saxi_axi_slave_awaddr     (nvdla2saxi_axi_slave1_awaddr )
    ,.nvdla2saxi_axi_slave_awburst    (nvdla2saxi_axi_slave1_awburst)
    ,.nvdla2saxi_axi_slave_awcache    (nvdla2saxi_axi_slave1_awcache)
    ,.nvdla2saxi_axi_slave_awid       (nvdla2saxi_axi_slave1_awid   )
    ,.nvdla2saxi_axi_slave_awlen      (nvdla2saxi_axi_slave1_awlen  )
    ,.nvdla2saxi_axi_slave_awlock     (nvdla2saxi_axi_slave1_awlock )
    ,.nvdla2saxi_axi_slave_awprot     (nvdla2saxi_axi_slave1_awprot )
    ,.nvdla2saxi_axi_slave_awsize     (nvdla2saxi_axi_slave1_awsize )
    ,.nvdla2saxi_axi_slave_awvalid    (nvdla2saxi_axi_slave1_awvalid)
    ,.nvdla2saxi_axi_slave_bready     (nvdla2saxi_axi_slave1_bready )
    ,.nvdla2saxi_axi_slave_rready     (nvdla2saxi_axi_slave1_rready )
    ,.nvdla2saxi_axi_slave_wdata      (nvdla2saxi_axi_slave1_wdata  )
    ,.nvdla2saxi_axi_slave_wid        (nvdla2saxi_axi_slave1_wid    )
    ,.nvdla2saxi_axi_slave_wlast      (nvdla2saxi_axi_slave1_wlast  )
    ,.nvdla2saxi_axi_slave_wstrb      (nvdla2saxi_axi_slave1_wstrb  )
    ,.nvdla2saxi_axi_slave_wvalid     (nvdla2saxi_axi_slave1_wvalid )

    ,.saxi2mem_cmd_wr               (saxi12mem_cmd_wr  )
    ,.saxi2mem_cmd_rd               (saxi12mem_cmd_rd  )
    ,.saxi2mem_addr_wr              (saxi12mem_addr_wr )
    ,.saxi2mem_addr_rd              (saxi12mem_addr_rd )
    ,.saxi2mem_data                 (saxi12mem_data    )
    ,.saxi2mem_wstrb                (saxi12mem_wstrb   )
    ,.saxi2mem_len_rd               (saxi12mem_len_rd  )
    ,.saxi2mem_len_wr               (saxi12mem_len_wr  )
    ,.saxi2mem_size_rd              (saxi12mem_size_rd )
    ,.saxi2mem_size_wr              (saxi12mem_size_wr )
    ,.mem2saxi_rdresp               (mem2saxi1_rdresp  )
    ,.mem2saxi_rddata               (mem2saxi1_rddata  )
    ,.mem2saxi_wrresp               (mem2saxi1_wrresp  )
    ,.mem2saxi_rd_ready             (mem2saxi1_rd_ready)
    ,.mem2saxi_wr_ready             (mem2saxi1_wr_ready)
  );

  slave_mem #(`DBB_ADDR_START, `DBB_MEM_SIZE) dbb_mem (
    .clk                    (fast_clk)
   ,.slow_clk               (clk)
   ,.reset                  (reset)

   ,.slave2mem_cmd_wr       (saxi02mem_cmd_wr)
   ,.slave2mem_cmd_rd       (saxi02mem_cmd_rd)
   ,.slave2mem_addr_wr      (saxi02mem_addr_wr)
   ,.slave2mem_addr_rd      (saxi02mem_addr_rd)
   ,.slave2mem_data         (saxi02mem_data)
   ,.slave2mem_wr_mask      (saxi02mem_wstrb)
   ,.slave2mem_len_rd       (saxi02mem_len_rd)
   ,.slave2mem_len_wr       (saxi02mem_len_wr)
   ,.slave2mem_size_rd      (saxi02mem_size_rd)
   ,.slave2mem_size_wr      (saxi02mem_size_wr)
   ,.mem2slave_rd_ready     (mem2saxi0_rd_ready)
   ,.mem2slave_wr_ready     (mem2saxi0_wr_ready)
   ,.mem2slave_rdresp_vld   (mem2saxi0_rdresp)
   ,.mem2slave_rdresp_data  (mem2saxi0_rddata)
   ,.mem2slave_wrresp_vld   (mem2saxi0_wrresp)
  );

slave_mem #(`CVSRAM_ADDR_START, `CVSRAM_MEM_SIZE) cvsram_mem (
    .clk                    (fast_clk)
   ,.slow_clk               (clk)
   ,.reset                  (reset)
 
   ,.slave2mem_cmd_wr       (saxi12mem_cmd_wr)
   ,.slave2mem_cmd_rd       (saxi12mem_cmd_rd)
   ,.slave2mem_addr_wr      (saxi12mem_addr_wr)
   ,.slave2mem_addr_rd      (saxi12mem_addr_rd)
   ,.slave2mem_data         (saxi12mem_data)
   ,.slave2mem_wr_mask      (saxi12mem_wstrb)
   ,.slave2mem_len_rd       (saxi12mem_len_rd)
   ,.slave2mem_len_wr       (saxi12mem_len_wr)
   ,.slave2mem_size_rd      (saxi12mem_size_rd)
   ,.slave2mem_size_wr      (saxi12mem_size_wr)
   ,.mem2slave_rd_ready     (mem2saxi1_rd_ready)
   ,.mem2slave_wr_ready     (mem2saxi1_wr_ready)
   ,.mem2slave_rdresp_vld   (mem2saxi1_rdresp)
   ,.mem2slave_rdresp_data  (mem2saxi1_rddata)
   ,.mem2slave_wrresp_vld   (mem2saxi1_wrresp)
  );


endmodule


