// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_nocif.v

module NV_NVDLA_nocif (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,pwrbus_ram_pd
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
//: my $k = NVDLA_NUM_DMA_READ_CLIENTS;
//: my $i = 0;
//: for($i=0; $i<$k; $i++) {
//: print("  ,client${i}2cvif_rd_cdt_lat_fifo_pop\n");
//: print("  ,client${i}2cvif_rd_req_valid\n");
//: print("  ,client${i}2cvif_rd_req_pd\n");
//: print("  ,client${i}2cvif_rd_req_ready\n");
//: print("  ,cvif2client${i}_rd_rsp_valid\n");
//: print("  ,cvif2client${i}_rd_rsp_pd\n");
//: print("  ,cvif2client${i}_rd_rsp_ready\n");
//: print("  ,client${i}2cvif_lat_fifo_depth\n");
//: print("  ,client${i}2cvif_rd_axid\n");
//: }
//: my $k = NVDLA_NUM_DMA_WRITE_CLIENTS;
//: my $i = 0;
//: for($i=0; $i<$k; $i++) {
//: print("  ,client${i}2cvif_wr_req_pd\n");
//: print("  ,client${i}2cvif_wr_req_valid\n");
//: print("  ,client${i}2cvif_wr_req_ready\n");
//: print("  ,cvif2client${i}_wr_rsp_complete\n");
//: print("  ,client${i}2cvif_wr_axid\n");
//: }
#endif
//: my $k = NVDLA_NUM_DMA_READ_CLIENTS;
//: my $i = 0;
//: for($i=0; $i<$k; $i++) {
//: print("  ,client${i}2mcif_rd_cdt_lat_fifo_pop\n");
//: print("  ,client${i}2mcif_rd_req_valid\n");
//: print("  ,client${i}2mcif_rd_req_pd\n");
//: print("  ,client${i}2mcif_rd_req_ready\n");
//: print("  ,mcif2client${i}_rd_rsp_valid\n");
//: print("  ,mcif2client${i}_rd_rsp_pd\n");
//: print("  ,mcif2client${i}_rd_rsp_ready\n");
//: print("  ,client${i}2mcif_lat_fifo_depth\n");
//: print("  ,client${i}2mcif_rd_axid\n");
//: }
//: my $k = NVDLA_NUM_DMA_WRITE_CLIENTS;
//: my $i = 0;
//: for($i=0; $i<$k; $i++) {
//: print("  ,client${i}2mcif_wr_req_pd\n");
//: print("  ,client${i}2mcif_wr_req_valid\n");
//: print("  ,client${i}2mcif_wr_req_ready\n");
//: print("  ,mcif2client${i}_wr_rsp_complete\n");
//: print("  ,client${i}2mcif_wr_axid\n");
//: }
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,noc2cvif_axi_b_bid             //|< i
  ,noc2cvif_axi_b_bvalid          //|< i
  ,noc2cvif_axi_r_rdata           //|< i
  ,noc2cvif_axi_r_rid             //|< i
  ,noc2cvif_axi_r_rlast           //|< i
  ,noc2cvif_axi_r_rvalid          //|< i
  ,cvif2noc_axi_ar_arready        //|< i
  ,cvif2noc_axi_aw_awready        //|< i
  ,cvif2noc_axi_w_wready          //|< i
  ,cvif2csb_resp_pd               //|> o
  ,cvif2csb_resp_valid            //|> o
  ,cvif2noc_axi_ar_araddr         //|> o
  ,cvif2noc_axi_ar_arid           //|> o
  ,cvif2noc_axi_ar_arlen          //|> o
  ,cvif2noc_axi_ar_arvalid        //|> o
  ,cvif2noc_axi_aw_awaddr         //|> o
  ,cvif2noc_axi_aw_awid           //|> o
  ,cvif2noc_axi_aw_awlen          //|> o
  ,cvif2noc_axi_aw_awvalid        //|> o
  ,cvif2noc_axi_w_wdata           //|> o
  ,cvif2noc_axi_w_wlast           //|> o
  ,cvif2noc_axi_w_wstrb           //|> o
  ,cvif2noc_axi_w_wvalid          //|> o
  ,noc2cvif_axi_b_bready          //|> o
  ,noc2cvif_axi_r_rready          //|> o
#endif
  ,csb2mcif_req_pd                //|< i
  ,csb2mcif_req_pvld              //|< i
  ,csb2mcif_req_prdy              //|> o
  ,mcif2csb_resp_pd               //|> o
  ,mcif2csb_resp_valid            //|> o
  ,noc2mcif_axi_b_bid             //|< i
  ,noc2mcif_axi_b_bvalid          //|< i
  ,noc2mcif_axi_r_rdata           //|< i
  ,noc2mcif_axi_r_rid             //|< i
  ,noc2mcif_axi_r_rlast           //|< i
  ,noc2mcif_axi_r_rvalid          //|< i
  ,mcif2noc_axi_ar_arready        //|< i
  ,mcif2noc_axi_aw_awready        //|< i
  ,mcif2noc_axi_w_wready          //|< i
  ,mcif2noc_axi_ar_araddr         //|> o
  ,mcif2noc_axi_ar_arid           //|> o
  ,mcif2noc_axi_ar_arlen          //|> o
  ,mcif2noc_axi_ar_arvalid        //|> o
  ,mcif2noc_axi_aw_awaddr         //|> o
  ,mcif2noc_axi_aw_awid           //|> o
  ,mcif2noc_axi_aw_awlen          //|> o
  ,mcif2noc_axi_aw_awvalid        //|> o
  ,mcif2noc_axi_w_wdata           //|> o
  ,mcif2noc_axi_w_wlast           //|> o
  ,mcif2noc_axi_w_wstrb           //|> o
  ,mcif2noc_axi_w_wvalid          //|> o
  ,noc2mcif_axi_b_bready          //|> o
  ,noc2mcif_axi_r_rready          //|> o
);

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
//:my $k = NVDLA_NUM_DMA_READ_CLIENTS;
//:my $i = 0;
//:for ($i=0;$i<$k;$i++) {
//: print ("input client${i}2cvif_rd_cdt_lat_fifo_pop;\n");
//: print("input client${i}2cvif_rd_req_valid;\n");
//: print qq(input [NVDLA_MEM_ADDRESS_WIDTH+14:0] client${i}2cvif_rd_req_pd;);
//: print("output client${i}2cvif_rd_req_ready;\n");
//: print("output cvif2client${i}_rd_rsp_valid;\n");
//: print("input cvif2client${i}_rd_rsp_ready;\n");
//: print qq(output [NVDLA_SECONDARY_MEMIF_WIDTH+1:0] cvif2client${i}_rd_rsp_pd;);
//: print("input [7:0] client${i}2cvif_lat_fifo_depth;\n");
//: print("input [3:0] client${i}2cvif_rd_axid;\n");
//: }

//:my $k = NVDLA_NUM_DMA_WRITE_CLIENTS;
//:my $i = 0;
//:for ($i=0;$i<$k;$i++) {
//: print qq(input [NVDLA_SECONDARY_MEMIF_WIDTH+2:0] client${i}2cvif_wr_req_pd;);
//: print("input client${i}2cvif_wr_req_valid;\n");
//: print("output client${i}2cvif_wr_req_ready;\n");
//: print("output cvif2client${i}_wr_rsp_complete;\n");
//: print("input [3:0] client${i}2cvif_wr_axid;\n");
//: }
#endif

//:my $k = NVDLA_NUM_DMA_READ_CLIENTS;
//:my $i = 0;
//:for ($i=0;$i<$k;$i++) {
//: print ("input client${i}2mcif_rd_cdt_lat_fifo_pop;\n");
//: print("input client${i}2mcif_rd_req_valid;\n");
//: print qq(input [NVDLA_DMA_RD_REQ-1:0] client${i}2mcif_rd_req_pd;\n);
//: print("output client${i}2mcif_rd_req_ready;\n");
//: print("output mcif2client${i}_rd_rsp_valid;\n");
//: print("input mcif2client${i}_rd_rsp_ready;\n");
//: print qq(output [NVDLA_DMA_RD_RSP-1:0] mcif2client${i}_rd_rsp_pd;\n);
//: print("input [7:0] client${i}2mcif_lat_fifo_depth;\n");
//: print("input [3:0] client${i}2mcif_rd_axid;\n");
//: }

//:my $k = NVDLA_NUM_DMA_WRITE_CLIENTS;
//:my $i = 0;
//:for ($i=0;$i<$k;$i++) {
//: print qq(input [NVDLA_DMA_WR_REQ-1:0] client${i}2mcif_wr_req_pd;\n);
//: print("input client${i}2mcif_wr_req_valid;\n");
//: print("output client${i}2mcif_wr_req_ready;\n");
//: print("output mcif2client${i}_wr_rsp_complete;\n");
//: print("input [3:0] client${i}2mcif_wr_axid;\n");
//: }
input         nvdla_core_clk;
input         nvdla_core_rstn; 
input  [31:0] pwrbus_ram_pd;
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
output [33:0] cvif2csb_resp_pd;
output cvif2csb_resp_valid;
output        cvif2noc_axi_ar_arvalid;  /* data valid */
input         cvif2noc_axi_ar_arready;  /* data return handshake */
output  [7:0] cvif2noc_axi_ar_arid;
output  [3:0] cvif2noc_axi_ar_arlen;
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] cvif2noc_axi_ar_araddr;

output        cvif2noc_axi_aw_awvalid;  /* data valid */
input         cvif2noc_axi_aw_awready;  /* data return handshake */
output  [7:0] cvif2noc_axi_aw_awid;
output  [3:0] cvif2noc_axi_aw_awlen;
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] cvif2noc_axi_aw_awaddr;

output         cvif2noc_axi_w_wvalid;  /* data valid */
input          cvif2noc_axi_w_wready;  /* data return handshake */
output [NVDLA_SECONDARY_MEMIF_WIDTH-1:0] cvif2noc_axi_w_wdata;
output  [NVDLA_SECONDARY_MEMIF_WIDTH/8-1:0] cvif2noc_axi_w_wstrb;
output         cvif2noc_axi_w_wlast;
input        noc2cvif_axi_b_bvalid;  /* data valid */
output       noc2cvif_axi_b_bready;  /* data return handshake */
input  [7:0] noc2cvif_axi_b_bid;

input          noc2cvif_axi_r_rvalid;  /* data valid */
output         noc2cvif_axi_r_rready;  /* data return handshake */
input    [7:0] noc2cvif_axi_r_rid;
input          noc2cvif_axi_r_rlast;
input  [NVDLA_SECONDARY_MEMIF_WIDTH-1:0] noc2cvif_axi_r_rdata;
#endif

output        mcif2noc_axi_ar_arvalid;  /* data valid */
input         mcif2noc_axi_ar_arready;  /* data return handshake */
output  [7:0] mcif2noc_axi_ar_arid;
output  [3:0] mcif2noc_axi_ar_arlen;
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] mcif2noc_axi_ar_araddr;

output        mcif2noc_axi_aw_awvalid;  /* data valid */
input         mcif2noc_axi_aw_awready;  /* data return handshake */
output  [7:0] mcif2noc_axi_aw_awid;
output  [3:0] mcif2noc_axi_aw_awlen;
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] mcif2noc_axi_aw_awaddr;

output         mcif2noc_axi_w_wvalid;  /* data valid */
input          mcif2noc_axi_w_wready;  /* data return handshake */
output [NVDLA_PRIMARY_MEMIF_WIDTH-1:0] mcif2noc_axi_w_wdata;
output  [NVDLA_PRIMARY_MEMIF_WIDTH/8-1:0] mcif2noc_axi_w_wstrb;
output         mcif2noc_axi_w_wlast;
input        noc2mcif_axi_b_bvalid;  /* data valid */
output       noc2mcif_axi_b_bready;  /* data return handshake */
input  [7:0] noc2mcif_axi_b_bid;

input          noc2mcif_axi_r_rvalid;  /* data valid */
output         noc2mcif_axi_r_rready;  /* data return handshake */
input    [7:0] noc2mcif_axi_r_rid;
input          noc2mcif_axi_r_rlast;
input  [NVDLA_PRIMARY_MEMIF_WIDTH-1:0] noc2mcif_axi_r_rdata;

input         csb2mcif_req_pvld;  /* data valid */
output        csb2mcif_req_prdy;  /* data return handshake */
input  [62:0] csb2mcif_req_pd;
output        mcif2csb_resp_valid;  /* data valid */
output [33:0] mcif2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */


#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
NV_NVDLA_NOCIF_sram u_sram (
    .nvdla_core_clk(nvdla_core_clk)
    ,.nvdla_core_rstn(nvdla_core_rstn)
//: my $k = NVDLA_NUM_DMA_READ_CLIENTS;
//: my $i = 0;
//: for($i=0; $i<$k; $i++) {
//: print("  ,.client${i}2cvif_rd_cdt_lat_fifo_pop(client${i}2cvif_rd_cdt_lat_fifo_pop)\n");
//: print("  ,.client${i}2cvif_rd_req_valid(client${i}2cvif_rd_req_valid)\n");
//: print("  ,.client${i}2cvif_rd_req_pd(client${i}2cvif_rd_req_pd)\n");
//: print("  ,.client${i}2cvif_rd_req_ready(client${i}2cvif_rd_req_ready)\n");
//: print("  ,.cvif2client${i}_rd_rsp_valid(cvif2client${i}_rd_rsp_valid)\n");
//: print("  ,.cvif2client${i}_rd_rsp_pd(cvif2client${i}_rd_rsp_pd)\n");
//: print("  ,.cvif2client${i}_rd_rsp_ready(cvif2client${i}_rd_rsp_ready)\n");
//: print("  ,.client${i}2cvif_rd_axid(client${i}2cvif_rd_axid)\n");
//: print("  ,.client${i}2cvif_lat_fifo_depth(client${i}2cvif_lat_fifo_depth)\n");
//: }
//: my $k = NVDLA_NUM_DMA_WRITE_CLIENTS;
//: my $i = 0;
//: for($i=0; $i<$k; $i++) {
//: print("  ,.client${i}2cvif_wr_req_pd(client${i}2cvif_wr_req_pd)\n");
//: print("  ,.client${i}2cvif_wr_req_valid(client${i}2cvif_wr_req_valid)\n");
//: print("  ,.client${i}2cvif_wr_req_ready(client${i}2cvif_wr_req_ready)\n");
//: print("  ,.cvif2client${i}_wr_rsp_complete(cvif2client${i}_wr_rsp_complete)\n");
//: print("  ,.client${i}2cvif_wr_axid(client${i}2cvif_wr_axid)\n");
//: }
  ,.noc2cvif_axi_b_bid(noc2cvif_axi_b_bid             )             //|< i
  ,.noc2cvif_axi_b_bvalid(noc2cvif_axi_b_bvalid          )          //|< i
  ,.noc2cvif_axi_r_rdata(noc2cvif_axi_r_rdata           )           //|< i
  ,.noc2cvif_axi_r_rid(noc2cvif_axi_r_rid             )             //|< i
  ,.noc2cvif_axi_r_rlast(noc2cvif_axi_r_rlast           )           //|< i
  ,.noc2cvif_axi_r_rvalid(noc2cvif_axi_r_rvalid          )          //|< i
  ,.cvif2noc_axi_ar_arready(cvif2noc_axi_ar_arready        )        //|< i
  ,.cvif2noc_axi_aw_awready(cvif2noc_axi_aw_awready        )        //|< i
  ,.cvif2noc_axi_w_wready(cvif2noc_axi_w_wready          )          //|< i
  ,.cvif2csb_resp_pd(cvif2csb_resp_pd               )               //|> o
  ,.cvif2csb_resp_valid(cvif2csb_resp_valid            )            //|> o
  ,.cvif2noc_axi_ar_araddr(cvif2noc_axi_ar_araddr         )         //|> o
  ,.cvif2noc_axi_ar_arid(cvif2noc_axi_ar_arid           )           //|> o
  ,.cvif2noc_axi_ar_arlen(cvif2noc_axi_ar_arlen          )          //|> o
  ,.cvif2noc_axi_ar_arvalid(cvif2noc_axi_ar_arvalid        )        //|> o
  ,.cvif2noc_axi_aw_awaddr(cvif2noc_axi_aw_awaddr         )         //|> o
  ,.cvif2noc_axi_aw_awid(cvif2noc_axi_aw_awid           )           //|> o
  ,.cvif2noc_axi_aw_awlen(cvif2noc_axi_aw_awlen          )          //|> o
  ,.cvif2noc_axi_aw_awvalid(cvif2noc_axi_aw_awvalid        )        //|> o
  ,.cvif2noc_axi_w_wdata(cvif2noc_axi_w_wdata           )           //|> o
  ,.cvif2noc_axi_w_wlast(cvif2noc_axi_w_wlast           )           //|> o
  ,.cvif2noc_axi_w_wstrb(cvif2noc_axi_w_wstrb           )           //|> o
  ,.cvif2noc_axi_w_wvalid(cvif2noc_axi_w_wvalid          )          //|> o
  ,.noc2cvif_axi_b_bready(noc2cvif_axi_b_bready          )          //|> o
  ,.noc2cvif_axi_r_rready(noc2cvif_axi_r_rready          )          //|> o
);
#endif

NV_NVDLA_NOCIF_dram u_dram (
    .nvdla_core_clk(nvdla_core_clk)
    ,.nvdla_core_rstn(nvdla_core_rstn)
    ,.pwrbus_ram_pd (pwrbus_ram_pd)
    ,.csb2mcif_req_pvld   (csb2mcif_req_pvld)              //|< i
    ,.csb2mcif_req_prdy   (csb2mcif_req_prdy)              //|> o
    ,.csb2mcif_req_pd     (csb2mcif_req_pd[62:0])          //|< i
    ,.mcif2csb_resp_valid (mcif2csb_resp_valid)            //|> o
    ,.mcif2csb_resp_pd    (mcif2csb_resp_pd[33:0])         //|> o
//: my $k = NVDLA_NUM_DMA_READ_CLIENTS;
//: my $i = 0;
//: for($i=0; $i<$k; $i++) {
//: print("  ,.client${i}2mcif_rd_cdt_lat_fifo_pop(client${i}2mcif_rd_cdt_lat_fifo_pop)\n");
//: print("  ,.client${i}2mcif_rd_req_valid(client${i}2mcif_rd_req_valid)\n");
//: print("  ,.client${i}2mcif_rd_req_pd(client${i}2mcif_rd_req_pd)\n");
//: print("  ,.client${i}2mcif_rd_req_ready(client${i}2mcif_rd_req_ready)\n");
//: print("  ,.mcif2client${i}_rd_rsp_valid(mcif2client${i}_rd_rsp_valid)\n");
//: print("  ,.mcif2client${i}_rd_rsp_ready(mcif2client${i}_rd_rsp_ready)\n");
//: print("  ,.mcif2client${i}_rd_rsp_pd(mcif2client${i}_rd_rsp_pd)\n");
//: print("  ,.client${i}2mcif_rd_axid(client${i}2mcif_rd_axid)\n");
//: print("  ,.client${i}2mcif_lat_fifo_depth(client${i}2mcif_lat_fifo_depth)\n");
//: }
//: my $k = NVDLA_NUM_DMA_WRITE_CLIENTS;
//: my $i = 0;
//: for($i=0; $i<$k; $i++) {
//: print("  ,.client${i}2mcif_wr_req_pd(client${i}2mcif_wr_req_pd)\n");
//: print("  ,.client${i}2mcif_wr_req_valid(client${i}2mcif_wr_req_valid)\n");
//: print("  ,.client${i}2mcif_wr_req_ready(client${i}2mcif_wr_req_ready)\n");
//: print("  ,.mcif2client${i}_wr_rsp_complete(mcif2client${i}_wr_rsp_complete)\n");
//: print("  ,.client${i}2mcif_wr_axid(client${i}2mcif_wr_axid)\n");
//: }
  ,.noc2mcif_axi_b_bid(noc2mcif_axi_b_bid             )             //|< i
  ,.noc2mcif_axi_b_bvalid(noc2mcif_axi_b_bvalid          )          //|< i
  ,.noc2mcif_axi_r_rdata(noc2mcif_axi_r_rdata           )           //|< i
  ,.noc2mcif_axi_r_rid(noc2mcif_axi_r_rid             )             //|< i
  ,.noc2mcif_axi_r_rlast(noc2mcif_axi_r_rlast           )           //|< i
  ,.noc2mcif_axi_r_rvalid(noc2mcif_axi_r_rvalid          )          //|< i
  ,.mcif2noc_axi_ar_arready(mcif2noc_axi_ar_arready        )        //|< i
  ,.mcif2noc_axi_aw_awready(mcif2noc_axi_aw_awready        )        //|< i
  ,.mcif2noc_axi_w_wready(mcif2noc_axi_w_wready          )          //|< i
  ,.mcif2noc_axi_ar_araddr(mcif2noc_axi_ar_araddr         )         //|> o
  ,.mcif2noc_axi_ar_arid(mcif2noc_axi_ar_arid           )           //|> o
  ,.mcif2noc_axi_ar_arlen(mcif2noc_axi_ar_arlen          )          //|> o
  ,.mcif2noc_axi_ar_arvalid(mcif2noc_axi_ar_arvalid        )        //|> o
  ,.mcif2noc_axi_aw_awaddr(mcif2noc_axi_aw_awaddr         )         //|> o
  ,.mcif2noc_axi_aw_awid(mcif2noc_axi_aw_awid           )           //|> o
  ,.mcif2noc_axi_aw_awlen(mcif2noc_axi_aw_awlen          )          //|> o
  ,.mcif2noc_axi_aw_awvalid(mcif2noc_axi_aw_awvalid        )        //|> o
  ,.mcif2noc_axi_w_wdata(mcif2noc_axi_w_wdata           )           //|> o
  ,.mcif2noc_axi_w_wlast(mcif2noc_axi_w_wlast           )           //|> o
  ,.mcif2noc_axi_w_wstrb(mcif2noc_axi_w_wstrb           )           //|> o
  ,.mcif2noc_axi_w_wvalid(mcif2noc_axi_w_wvalid          )          //|> o
  ,.noc2mcif_axi_b_bready(noc2mcif_axi_b_bready          )          //|> o
  ,.noc2mcif_axi_r_rready(noc2mcif_axi_r_rready          )          //|> o
);



endmodule
