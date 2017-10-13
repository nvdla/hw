// ----------------------------------------------------------------------------
//      ___                                   _____                      ___     
//     /__/\          ___        ___         /  /::\       ___          /  /\    
//     \  \:\        /__/\      /  /\       /  /:/\:\     /  /\        /  /::\   
//      \  \:\       \  \:\    /  /:/      /  /:/  \:\   /  /:/       /  /:/\:\  
//  _____\__\:\       \  \:\  /__/::\     /__/:/ \__\:| /__/::\      /  /:/~/::\ 
// /__/::::::::\  ___  \__\:\ \__\/\:\__  \  \:\ /  /:/ \__\/\:\__  /__/:/ /:/\:\
// \  \:\~~\~~\/ /__/\ |  |:|    \  \:\/\  \  \:\  /:/     \  \:\/\ \  \:\/:/__\/
//  \  \:\  ~~~  \  \:\|  |:|     \__\::/   \  \:\/:/       \__\::/  \  \::/     
//   \  \:\       \  \:\__|:|     /__/:/     \  \::/        /__/:/    \  \:\     
//    \  \:\       \__\::::/      \__\/       \__\/         \__\/      \  \:\    
//     \__\/           ~~~~                                             \__\/    
//                                     ___                            ___   
//         _____                      /  /\             ___          /  /\  
//        /  /::\                    /  /::\           /  /\        /  /::\ 
//       /  /:/\:\                  /  /:/\:\         /  /:/       /  /:/\:\
//      /  /:/  \:\   __      __   /  /:/~/::\       /__/::\      /  /:/~/:/
//     /__/:/ \__\:/ /__/\   /  /\/__/:/ /:/\:\      \__\/\:\__  /__/:/ /:/ 
//     \  \:\ /  /:/ \  \:\ /  /:/\  \:\/:/__\/         \  \:\/\ \  \:\/:/  
//      \  \:\  /:/   \  \:\  /:/  \  \::/               \__\::/  \  \::/   
//       \  \:\/:/     \  \:\/:/    \  \:\               /__/:/    \  \:\   
//        \  \::/       \  \::/      \  \:\              \__\/      \  \:\  
//         \__\/         \__\/        \__\/                          \__\/  
// ----------------------------------------------------------------------------
//
// Component: Top-level Module Example Testbench
//
// ----------------------------------------------------------------------------

/// Top-level RTL module for example testbench.

`include "syn_tb_defines.vh"

module top;

`ifdef ZEBU
    reg dollar_finish;
`endif

   // -----------------
   // PARAMETER DECL 
   // -----------------

    parameter simulation_cycle = 20;
	// 400/800 MHz.
//    parameter simulation_cycle_mem = 10;
    parameter simulation_cycle_mem = 20;

   // -----------------
   // CLK/RESET REG DECL 
   // -----------------

    wire      clk;      // System clock
    reg       reset;    // spyglass disable W402b // System reset
    reg       half_speed_clk;
    wire      mem_clk;
    reg       mem_clk_fast;

   // -----------------
   // AXI WIRE DECL 
   // -----------------

    wire                            axi_slave0_arready         ;
    wire                            axi_slave0_awready         ;
    wire [`AXI_SLAVE_BID_WIDTH-1:0] axi_slave0_bid             ;
    wire                      [1:0] axi_slave0_bresp           ;
    wire                            axi_slave0_bvalid          ;
    wire   [`DATABUS2MEM_WIDTH-1:0] axi_slave0_rdata           ;
    wire [`AXI_SLAVE_RID_WIDTH-1:0] axi_slave0_rid             ;
    wire                            axi_slave0_rlast           ;
    wire                            axi_slave0_rvalid          ;
    wire                            axi_slave0_wready          ;

    wire                            axi_slave1_arready         ;
    wire                            axi_slave1_awready         ;
    wire [`AXI_SLAVE_BID_WIDTH-1:0] axi_slave1_bid             ;
    wire                      [1:0] axi_slave1_bresp           ;
    wire                            axi_slave1_bvalid          ;
    wire   [`DATABUS2MEM_WIDTH-1:0] axi_slave1_rdata           ;
    wire [`AXI_SLAVE_RID_WIDTH-1:0] axi_slave1_rid             ;
    wire                            axi_slave1_rlast           ;
    wire                            axi_slave1_rvalid          ;
    wire                            axi_slave1_wready          ;
                
    wire                     [`AXI_ADDR_WIDTH-1:0] axi_slave0_araddr          ;
//    wire                      [1:0] axi_slave0_arburst         ;
//    wire                      [3:0] axi_slave0_arcache         ;
    wire [`AXI_SLAVE_RID_WIDTH-1:0] axi_slave0_arid            ;
    wire                      [3:0] axi_slave0_arlen           ;
//    wire                      [1:0] axi_slave0_arlock          ;
//    wire                      [2:0] axi_slave0_arprot          ;
//    wire                      [2:0] axi_slave0_arsize          ;
    wire                            axi_slave0_arvalid         ;
    wire                     [`AXI_ADDR_WIDTH-1:0] axi_slave0_awaddr          ;
//    wire                      [1:0] axi_slave0_awburst         ;
//    wire                      [3:0] axi_slave0_awcache         ;
    wire [`AXI_SLAVE_WID_WIDTH-1:0] axi_slave0_awid            ;
    wire                      [3:0] axi_slave0_awlen           ;
//    wire                      [1:0] axi_slave0_awlock          ;
//    wire                      [2:0] axi_slave0_awprot          ;
//    wire                      [2:0] axi_slave0_awsize          ;
    wire                            axi_slave0_awvalid         ;
    wire                            axi_slave0_bready          ;
    wire                            axi_slave0_rready          ;
    wire   [`DATABUS2MEM_WIDTH-1:0] axi_slave0_wdata           ;
    wire                            axi_slave0_wlast           ;
    wire [(`DATABUS2MEM_WIDTH/8)-1:0] axi_slave0_wstrb           ;
    wire                            axi_slave0_wvalid          ;

    wire                     [`AXI_ADDR_WIDTH-1:0] axi_slave1_araddr          ;
//    wire                      [1:0] axi_slave1_arburst         ;
//    wire                      [3:0] axi_slave1_arcache         ;
    wire [`AXI_SLAVE_RID_WIDTH-1:0] axi_slave1_arid            ;
    wire                      [3:0] axi_slave1_arlen           ;
//    wire                      [1:0] axi_slave1_arlock          ;
//    wire                      [2:0] axi_slave1_arprot          ;
//    wire                      [2:0] axi_slave1_arsize          ;
    wire                            axi_slave1_arvalid         ;
    wire                     [`AXI_ADDR_WIDTH-1:0] axi_slave1_awaddr          ;
//    wire                      [1:0] axi_slave1_awburst         ;
//    wire                      [3:0] axi_slave1_awcache         ;
    wire [`AXI_SLAVE_WID_WIDTH-1:0] axi_slave1_awid            ;
    wire                      [3:0] axi_slave1_awlen           ;
//    wire                      [1:0] axi_slave1_awlock          ;
//    wire                      [2:0] axi_slave1_awprot          ;
//    wire                      [2:0] axi_slave1_awsize          ;
    wire                            axi_slave1_awvalid         ;
    wire                            axi_slave1_bready          ;
    wire                            axi_slave1_rready          ;
    wire                    [`DATABUS2MEM_WIDTH-1:0] axi_slave1_wdata           ;
    wire                            axi_slave1_wlast           ;
    wire [(`DATABUS2MEM_WIDTH/8)-1:0] axi_slave1_wstrb           ;
    wire                            axi_slave1_wvalid          ;


    wire axi_slave0_wvalid_vip    ;
    wire axi_slave0_rready_vip    ;
    wire axi_slave1_wvalid_vip    ;
    wire axi_slave1_rready_vip    ;
    wire axi_slave0_rvalid_vip    ;
    wire axi_slave0_wready_vip    ;
    wire axi_slave1_rvalid_vip    ;
    wire axi_slave1_wready_vip    ;
    wire axi_slave0_awvalid_vip    ;
    wire axi_slave0_arready_vip    ;
    wire axi_slave1_awvalid_vip    ;
    wire axi_slave1_arready_vip    ;
    wire axi_slave0_arvalid_vip    ;
    wire axi_slave0_awready_vip    ;
    wire axi_slave1_arvalid_vip    ;
    wire axi_slave1_awready_vip    ;

    wire mem_holdoff;
    wire dla_intr;

    // Synthesizable TB: Connectivity wires between master_seq, axi_master and nvdla
    wire        mseq2tb_test_done;
    wire        mcsb2scsb_pvld;
    wire        mcsb2scsb_prdy;
    wire [62:0] mcsb2scsb_pd;

    wire        scsb2mcsb_valid;
    wire [31:0] scsb2mcsb_pd;
    wire        scsb2mcsb_error;
    wire        scsb2mcsb_wr_complete;
    wire        scsb2mcsb_wr_err;
    wire        scsb2mcsb_wr_rdat;

    wire        mseq_pending_req;
    wire [62:0] mseq2mcsb_pd;
    wire        mcsb2mseq_consumed_req;
    wire [31:0] mcsb2mseq_rdata; 
    wire        mcsb2mseq_rvalid;

    // CSB Master Sequencer
    csb_master_seq csb_mseq(

        .clk                    (half_speed_clk) 
       ,.reset                  (reset) // spyglass disable W123

       ,.mseq_pending_req       (mseq_pending_req)
       ,.mseq2mcsb_pd           (mseq2mcsb_pd)
       ,.mcsb2mseq_consumed_req (mcsb2mseq_consumed_req)
       ,.mcsb2mseq_rdata        (mcsb2mseq_rdata)
       ,.mcsb2mseq_rvalid       (mcsb2mseq_rvalid)

       ,.dut2mseq_intr0         (dla_intr)
       ,.mseq2tb_test_done      (mseq2tb_test_done)

    ); // syn_master_seq

    // Syn CSB Master
    syn_csb_master csb_master(

        .clk                    (half_speed_clk)
       ,.reset                  (reset) // spyglass disable UndrivenInTerm-ML

       ,.mcsb2scsb_pvld         (mcsb2scsb_pvld)
       ,.mcsb2scsb_prdy         (mcsb2scsb_prdy)
       ,.mcsb2scsb_pd           (mcsb2scsb_pd)

       ,.scsb2mcsb_valid        (scsb2mcsb_valid)
       ,.scsb2mcsb_pd           (scsb2mcsb_pd)
       ,.scsb2mcsb_error        (scsb2mcsb_error)
       ,.scsb2mcsb_wr_complete  (scsb2mcsb_wr_complete)
       ,.scsb2mcsb_wr_err       (scsb2mcsb_wr_err)
       ,.scsb2mcsb_wr_rdat      (scsb2mcsb_wr_rdat)

       ,.mseq_pending_req       (mseq_pending_req)
       ,.mseq2mcsb_pd           (mseq2mcsb_pd)
       ,.mcsb2mseq_consumed_req (mcsb2mseq_consumed_req)
       ,.mcsb2mseq_rdata        (mcsb2mseq_rdata)
       ,.mcsb2mseq_rvalid       (mcsb2mseq_rvalid)

    );


    syn_slave_mem_wrap slave_mem_wrap (
        .clk                                        (mem_clk)
       ,.fast_clk                                   (mem_clk_fast) // spyglass disable UndrivenInTerm-ML W123
       ,.reset                                      (reset)  // spyglass disable UndrivenInTerm-ML
       ,.saxi2nvdla_axi_slave0_arready                (axi_slave0_arready_vip     )
       ,.saxi2nvdla_axi_slave0_awready                (axi_slave0_awready_vip     )
       ,.saxi2nvdla_axi_slave0_bid                    (axi_slave0_bid             )
       ,.saxi2nvdla_axi_slave0_bresp                  (axi_slave0_bresp           )
       ,.saxi2nvdla_axi_slave0_bvalid                 (axi_slave0_bvalid          )
       ,.saxi2nvdla_axi_slave0_rdata                  (axi_slave0_rdata           )
       ,.saxi2nvdla_axi_slave0_rid                    (axi_slave0_rid             )
       ,.saxi2nvdla_axi_slave0_rlast                  (axi_slave0_rlast           )
       ,.saxi2nvdla_axi_slave0_rvalid                 (axi_slave0_rvalid_vip      )
       ,.saxi2nvdla_axi_slave0_wready                 (axi_slave0_wready_vip      )

       ,.saxi2nvdla_axi_slave1_arready                (axi_slave1_arready_vip     )
       ,.saxi2nvdla_axi_slave1_awready                (axi_slave1_awready_vip     )
       ,.saxi2nvdla_axi_slave1_bid                    (axi_slave1_bid             )
       ,.saxi2nvdla_axi_slave1_bresp                  (axi_slave1_bresp           )
       ,.saxi2nvdla_axi_slave1_bvalid                 (axi_slave1_bvalid          )
       ,.saxi2nvdla_axi_slave1_rdata                  (axi_slave1_rdata           )
       ,.saxi2nvdla_axi_slave1_rid                    (axi_slave1_rid             )
       ,.saxi2nvdla_axi_slave1_rlast                  (axi_slave1_rlast           )
       ,.saxi2nvdla_axi_slave1_rvalid                 (axi_slave1_rvalid_vip      )
       ,.saxi2nvdla_axi_slave1_wready                 (axi_slave1_wready_vip      )
                                                                                
       ,.nvdla2saxi_axi_slave0_araddr                 (axi_slave0_araddr          )
       ,.nvdla2saxi_axi_slave0_arburst                (2'b01) //axi_slave0_arburst         )
       ,.nvdla2saxi_axi_slave0_arcache                (4'b0) //axi_slave0_arcache         )
       ,.nvdla2saxi_axi_slave0_arid                   (axi_slave0_arid            )
       ,.nvdla2saxi_axi_slave0_arlen                  (axi_slave0_arlen           )
       ,.nvdla2saxi_axi_slave0_arlock                 (2'b0) //axi_slave0_arlock          )
       ,.nvdla2saxi_axi_slave0_arprot                 (3'b0) //axi_slave0_arprot          )
       ,.nvdla2saxi_axi_slave0_arsize                 (3'b110) //axi_slave0_arsize          )
       ,.nvdla2saxi_axi_slave0_arvalid                (axi_slave0_arvalid_vip     )
       ,.nvdla2saxi_axi_slave0_awaddr                 (axi_slave0_awaddr          )
       ,.nvdla2saxi_axi_slave0_awburst                (2'b01) //axi_slave0_awburst         )
       ,.nvdla2saxi_axi_slave0_awcache                (4'b0) //axi_slave0_awcache         )
       ,.nvdla2saxi_axi_slave0_awid                   (axi_slave0_awid            )
       ,.nvdla2saxi_axi_slave0_awlen                  (axi_slave0_awlen           )
       ,.nvdla2saxi_axi_slave0_awlock                 (2'b0) //axi_slave0_awlock          )
       ,.nvdla2saxi_axi_slave0_awprot                 (3'b0) //axi_slave0_awprot          )
       ,.nvdla2saxi_axi_slave0_awsize                 (3'b110) //axi_slave0_awsize          )
       ,.nvdla2saxi_axi_slave0_awvalid                (axi_slave0_awvalid_vip     )
       ,.nvdla2saxi_axi_slave0_bready                 (axi_slave0_bready          )
       ,.nvdla2saxi_axi_slave0_rready                 (axi_slave0_rready_vip      )
       ,.nvdla2saxi_axi_slave0_wdata                  (axi_slave0_wdata           )
       ,.nvdla2saxi_axi_slave0_wlast                  (axi_slave0_wlast           )
       ,.nvdla2saxi_axi_slave0_wstrb                  (axi_slave0_wstrb           )
       ,.nvdla2saxi_axi_slave0_wvalid                 (axi_slave0_wvalid_vip      )
                                                                                
       ,.nvdla2saxi_axi_slave1_araddr                 (axi_slave1_araddr          )
       ,.nvdla2saxi_axi_slave1_arburst                (2'b01) //axi_slave1_arburst         )
       ,.nvdla2saxi_axi_slave1_arcache                (4'b0) //axi_slave1_arcache         )
       ,.nvdla2saxi_axi_slave1_arid                   (axi_slave1_arid            )
       ,.nvdla2saxi_axi_slave1_arlen                  (axi_slave1_arlen           )
       ,.nvdla2saxi_axi_slave1_arlock                 (2'b0) //axi_slave1_arlock          )
       ,.nvdla2saxi_axi_slave1_arprot                 (3'b0) //axi_slave1_arprot          )
       ,.nvdla2saxi_axi_slave1_arsize                 (3'b110) //axi_slave1_arsize          )
       ,.nvdla2saxi_axi_slave1_arvalid                (axi_slave1_arvalid_vip     )
       ,.nvdla2saxi_axi_slave1_awaddr                 (axi_slave1_awaddr          )
       ,.nvdla2saxi_axi_slave1_awburst                (2'b01) //axi_slave1_awburst         )
       ,.nvdla2saxi_axi_slave1_awcache                (4'b0) //axi_slave1_awcache         )
       ,.nvdla2saxi_axi_slave1_awid                   (axi_slave1_awid            )
       ,.nvdla2saxi_axi_slave1_awlen                  (axi_slave1_awlen           )
       ,.nvdla2saxi_axi_slave1_awlock                 (2'b0) //axi_slave1_awlock          )
       ,.nvdla2saxi_axi_slave1_awprot                 (3'b0) //axi_slave1_awprot          )
       ,.nvdla2saxi_axi_slave1_awsize                 (3'b110) //axi_slave1_awsize          )
       ,.nvdla2saxi_axi_slave1_awvalid                (axi_slave1_awvalid_vip     )
       ,.nvdla2saxi_axi_slave1_bready                 (axi_slave1_bready          )
       ,.nvdla2saxi_axi_slave1_rready                 (axi_slave1_rready_vip      )
       ,.nvdla2saxi_axi_slave1_wdata                  (axi_slave1_wdata           )
       ,.nvdla2saxi_axi_slave1_wlast                  (axi_slave1_wlast           )
       ,.nvdla2saxi_axi_slave1_wstrb                  (axi_slave1_wstrb           )
       ,.nvdla2saxi_axi_slave1_wvalid                 (axi_slave1_wvalid_vip      )
    );

   // -----------------
   // DEBUG WIRE DECL 
   // -----------------
   reg  [31:0] trans_count; // location to view transaction count from sv code for non sv wform viewers.

   // --------------
   // Reset
   // --------------
  
   wire nvdlarstn;
   assign nvdlarstn = reset; 


   // --------------------------
   // Generated clocks
   // --------------------------

   reg        msc_clk_ip;
	reg turn_off_assert_clk_tp;

`ifdef EMU_TB

`else
 	initial begin
		turn_off_assert_clk_tp = $test$plusargs("turn_off_assert_clk");
		reset = 1'b0;
		half_speed_clk = 1'b0;
		msc_clk_ip = 1'b0;
		mem_clk_fast = 1'b0;

		repeat (1000) @ (clk);
		reset = 1'b1;
	end


	always #(simulation_cycle/2) msc_clk_ip = ~msc_clk_ip;
	always #(simulation_cycle_mem/2) mem_clk_fast = ~mem_clk_fast;

	assign clk = (turn_off_assert_clk_tp) ? 0 : msc_clk_ip;

	always @ (posedge clk) begin
		half_speed_clk <= ~half_speed_clk;
	end
`endif

   // --------------
   // WIRES & REGS
   // --------------

   // Interrupts
   wire         nvdla2soc_intr0n; // master0 stalling interrupt.
   wire         nvdla2soc_intr1n; // master1 stalling interrupt.
   
   // Timers    
   wire   [26:0] soc2nvdla_time0_gray; // gray code counter
   wire   [28:0] soc2nvdla_time1_gray; // gray code counter (upper bits)
   wire   [55:0] soc2nvdla_time_gray;  // concatenated counter
   wire          soc2nvdla_time_tick;  // toggles every  32 counts changes
   assign soc2nvdla_time_gray = {soc2nvdla_time1_gray,soc2nvdla_time0_gray};

   // --------------
   // nvdla IP wrapper
   // --------------
   
   NV_nvdla nvdla_top (

        .dla_core_clk (half_speed_clk)
        ,.dla_csb_clk (half_speed_clk)
        ,.global_clk_ovr_on (1'b0)
        ,.tmc2slcg_disable_clock_gating (1'b0)
        ,.dla_reset_rstn (reset)
        ,.direct_reset_ (reset)
        ,.test_mode (1'b0)
        ,.csb2nvdla_valid (mcsb2scsb_pvld)               //|< i
        ,.csb2nvdla_ready (mcsb2scsb_prdy)               //|> o
        ,.csb2nvdla_addr (mcsb2scsb_pd[15:0])            //|< i
        ,.csb2nvdla_wdat (mcsb2scsb_pd[53:22])           //|< i
        ,.csb2nvdla_write (mcsb2scsb_pd[54:54])          //|< i
        ,.csb2nvdla_nposted (mcsb2scsb_pd[55:55])        //|< i
        ,.nvdla2csb_valid (scsb2mcsb_valid)              //|> o
        ,.nvdla2csb_data (scsb2mcsb_pd)               //|> o
        ,.nvdla2csb_wr_complete (scsb2mcsb_wr_complete)  //|> o
        ,.nvdla_core2dbb_aw_awvalid (axi_slave0_awvalid)
        ,.nvdla_core2dbb_aw_awready (axi_slave0_awready)
        ,.nvdla_core2dbb_aw_awaddr (axi_slave0_awaddr)
        ,.nvdla_core2dbb_aw_awid (axi_slave0_awid)
        ,.nvdla_core2dbb_aw_awlen (axi_slave0_awlen)
        ,.nvdla_core2dbb_w_wvalid (axi_slave0_wvalid)
        ,.nvdla_core2dbb_w_wready (axi_slave0_wready)
        ,.nvdla_core2dbb_w_wdata (axi_slave0_wdata)
        ,.nvdla_core2dbb_w_wstrb (axi_slave0_wstrb)
        ,.nvdla_core2dbb_w_wlast (axi_slave0_wlast)
        ,.nvdla_core2dbb_b_bvalid (axi_slave0_bvalid)
        ,.nvdla_core2dbb_b_bready (axi_slave0_bready)
        ,.nvdla_core2dbb_b_bid (axi_slave0_bid)
        ,.nvdla_core2dbb_ar_arvalid (axi_slave0_arvalid)
        ,.nvdla_core2dbb_ar_arready (axi_slave0_arready)
        ,.nvdla_core2dbb_ar_araddr (axi_slave0_araddr)
        ,.nvdla_core2dbb_ar_arid (axi_slave0_arid)
        ,.nvdla_core2dbb_ar_arlen (axi_slave0_arlen)
        ,.nvdla_core2dbb_r_rvalid (axi_slave0_rvalid)
        ,.nvdla_core2dbb_r_rready (axi_slave0_rready)
        ,.nvdla_core2dbb_r_rid (axi_slave0_rid)
        ,.nvdla_core2dbb_r_rlast (axi_slave0_rlast)
        ,.nvdla_core2dbb_r_rdata (axi_slave0_rdata)
        ,.nvdla_core2cvsram_aw_awvalid (axi_slave1_awvalid)
        ,.nvdla_core2cvsram_aw_awready (axi_slave1_awready)
        ,.nvdla_core2cvsram_aw_awaddr (axi_slave1_awaddr)
        ,.nvdla_core2cvsram_aw_awid (axi_slave1_awid)
        ,.nvdla_core2cvsram_aw_awlen (axi_slave1_awlen)
        ,.nvdla_core2cvsram_w_wvalid (axi_slave1_wvalid)
        ,.nvdla_core2cvsram_w_wready (axi_slave1_wready)
        ,.nvdla_core2cvsram_w_wdata (axi_slave1_wdata)
        ,.nvdla_core2cvsram_w_wstrb (axi_slave1_wstrb)
        ,.nvdla_core2cvsram_w_wlast (axi_slave1_wlast)
        ,.nvdla_core2cvsram_b_bvalid (axi_slave1_bvalid)
        ,.nvdla_core2cvsram_b_bready (axi_slave1_bready)
        ,.nvdla_core2cvsram_b_bid (axi_slave1_bid)
        ,.nvdla_core2cvsram_ar_arvalid (axi_slave1_arvalid)
        ,.nvdla_core2cvsram_ar_arready (axi_slave1_arready)
        ,.nvdla_core2cvsram_ar_araddr (axi_slave1_araddr)
        ,.nvdla_core2cvsram_ar_arid (axi_slave1_arid)
        ,.nvdla_core2cvsram_ar_arlen (axi_slave1_arlen)
        ,.nvdla_core2cvsram_r_rvalid (axi_slave1_rvalid)
        ,.nvdla_core2cvsram_r_rready (axi_slave1_rready)
        ,.nvdla_core2cvsram_r_rid (axi_slave1_rid)
        ,.nvdla_core2cvsram_r_rlast (axi_slave1_rlast)
        ,.nvdla_core2cvsram_r_rdata (axi_slave1_rdata)
        ,.dla_intr (dla_intr)
        ,.nvdla_pwrbus_ram_c_pd (32'b0)
        ,.nvdla_pwrbus_ram_ma_pd (32'b0)
        ,.nvdla_pwrbus_ram_mb_pd (32'b0)
        ,.nvdla_pwrbus_ram_p_pd (32'b0)
        ,.nvdla_pwrbus_ram_o_pd (32'b0)
        ,.nvdla_pwrbus_ram_a_pd (32'b0)

   ); // nvdla_top


   // --------------
   // timer generator
   // --------------
   soc2nvdla_time_gen soc2nvdla_time_gen0 (
// spyglass disable_block UndrivenInTerm-ML W123 
       .clk                                 (msc_clk_ip                        ) //|> i I
// spyglass enable_block UndrivenInTerm-ML W123
      ,.reset_                              (nvdlarstn                           ) //|> i I
      ,.soc2nvdla_time1_gray                  (soc2nvdla_time1_gray                ) //|> o O
      ,.soc2nvdla_time0_gray                  (soc2nvdla_time0_gray                ) //|> o O
      ,.soc2nvdla_time_tick                   (soc2nvdla_time_tick                 ) //|> o O

   ); // soc2nvdla_time_gen

  clk_divider mem_clk_gen (
     .clk                                   (mem_clk_fast) // spyglass disable UndrivenInTerm-ML
    ,.reset                                 (reset) // spyglass disable UndrivenInTerm-ML W402b
    ,.slow_clk                              (mem_clk) // spyglass disable IntClock 
  );
  
 
   // --------------
   // bandwidth throttlers
   // --------------
    reg [31:0] max_txn_outstanding;
    reg [31:0] max_rd_outstanding;
    reg [31:0] max_wr_outstanding;
    reg [31:0] slv0_rd_outstanding;
    reg [31:0] slv0_wr_outstanding;
    reg [31:0] slv1_rd_outstanding;
    reg [31:0] slv1_wr_outstanding;
// spyglass disable_block W430 SYNTH_5143
    initial begin
`ifdef ZEBU
        // $value$plusargs not supported in ZeBu
        max_txn_outstanding = 512;
        max_wr_outstanding = 512;
        max_rd_outstanding = 512;
`else
        if(!($value$plusargs("max_txn_outstanding_per_channel=%d", max_txn_outstanding))) begin
            max_txn_outstanding = 512;
        end
        if(!($value$plusargs("max_wr_outstanding_per_channel=%d",  max_wr_outstanding))) begin
            max_wr_outstanding = 512;
        end
        if(!($value$plusargs("max_rd_outstanding_per_channel=%d",  max_rd_outstanding))) begin
            max_rd_outstanding = 512;
        end
`endif
    end
// spyglass enable_block W430 SYNTH_5143

    reg mem0_txn_rd_holdoff;
    reg mem1_txn_rd_holdoff;
    reg mem0_txn_wr_holdoff;
    reg mem1_txn_wr_holdoff;
    reg [31:0] slv0_txn_outstanding; 
    reg [31:0] slv1_txn_outstanding;
    reg carry_out0, carry_out1;
    reg [31:0] slv0_outstanding;  //delete me
    reg [31:0] slv1_outstanding;  //delete me

    wire mem0_wr_cnt_incr;
    wire mem0_rd_cnt_incr;
    wire mem1_wr_cnt_incr;
    wire mem1_rd_cnt_incr;
    wire mem0_wr_cnt_decr;
    wire mem0_rd_cnt_decr;
    wire mem1_wr_cnt_decr;
    wire mem1_rd_cnt_decr;

    assign {carry_out0,slv0_txn_outstanding} = slv0_rd_outstanding + slv0_wr_outstanding;
    assign {carry_out1,slv1_txn_outstanding} = slv1_rd_outstanding + slv1_wr_outstanding;
       
 
    always @ (negedge mem_clk or negedge reset) begin
        if(!reset) begin
            mem0_txn_wr_holdoff <= 0; 
            mem1_txn_wr_holdoff <= 0; 
            mem0_txn_rd_holdoff <= 0; 
            mem1_txn_rd_holdoff <= 0; 
        end else begin
            mem0_txn_wr_holdoff <= slv0_txn_outstanding >= max_txn_outstanding || slv0_wr_outstanding >= max_wr_outstanding;
            mem1_txn_wr_holdoff <= slv1_txn_outstanding >= max_txn_outstanding || slv1_wr_outstanding >= max_wr_outstanding;
            mem0_txn_rd_holdoff <= slv0_txn_outstanding >= max_txn_outstanding || slv0_rd_outstanding >= max_rd_outstanding;
            mem1_txn_rd_holdoff <= slv1_txn_outstanding >= max_txn_outstanding || slv1_rd_outstanding >= max_rd_outstanding;
        end
    end

    assign mem0_wr_cnt_incr = axi_slave0_awvalid && axi_slave0_awready;
    assign mem0_rd_cnt_incr = axi_slave0_arvalid && axi_slave0_arready;
    assign mem1_wr_cnt_incr = axi_slave1_awvalid && axi_slave1_awready;
    assign mem1_rd_cnt_incr = axi_slave1_arvalid && axi_slave1_arready;
    assign mem0_wr_cnt_decr = axi_slave0_bvalid && axi_slave0_bready; 
    assign mem0_rd_cnt_decr = axi_slave0_rvalid && axi_slave0_rready && axi_slave0_rlast; 
    assign mem1_wr_cnt_decr = axi_slave1_bvalid && axi_slave1_bready; 
    assign mem1_rd_cnt_decr = axi_slave1_rvalid && axi_slave1_rready && axi_slave1_rlast; 

    always @ (posedge mem_clk or negedge reset) begin
        if(!reset) begin
            slv0_rd_outstanding <= 0;
            slv0_wr_outstanding <= 0;
            slv1_rd_outstanding <= 0;
            slv1_wr_outstanding <= 0;
        end else begin
            slv0_rd_outstanding <= (mem0_rd_cnt_incr && !mem0_rd_cnt_decr) ? slv0_rd_outstanding + 1 :
                                   (!mem0_rd_cnt_incr && mem0_rd_cnt_decr) ? slv0_rd_outstanding - 1 :
                                                                             slv0_rd_outstanding;
            slv0_wr_outstanding <= (mem0_wr_cnt_incr && !mem0_wr_cnt_decr) ? slv0_wr_outstanding + 1 :
                                   (!mem0_wr_cnt_incr && mem0_wr_cnt_decr) ? slv0_wr_outstanding - 1 :
                                                                             slv0_wr_outstanding;
            slv1_rd_outstanding <= (mem1_rd_cnt_incr && !mem1_rd_cnt_decr) ? slv1_rd_outstanding + 1 :
                                   (!mem1_rd_cnt_incr && mem1_rd_cnt_decr) ? slv1_rd_outstanding - 1 :
                                                                             slv1_rd_outstanding;
            slv1_wr_outstanding <= (mem1_wr_cnt_incr && !mem1_wr_cnt_decr) ? slv1_wr_outstanding + 1 :
                                   (!mem1_wr_cnt_incr && mem1_wr_cnt_decr) ? slv1_wr_outstanding - 1 :
                                                                             slv1_wr_outstanding;
        end
    end


`ifdef EMU_TB
   bandwidth_mon bw_mon (
   .clk         (mem_clk),
   .event0      (1'b0), //Loai: added a dummy buffer
   .event1      (axi_slave0_rvalid && axi_slave0_rready),
   .event2      (axi_slave1_wvalid && axi_slave1_wready),
   .event3      (axi_slave1_rvalid && axi_slave1_rready),
   .holdoff     (mem_holdoff)
   );
`else
   bandwidth_mon bw_mon (
   .clk         (mem_clk),
   .event0      (axi_slave0_wvalid && axi_slave0_wready),
   .event1      (axi_slave0_rvalid && axi_slave0_rready),
   .event2      (axi_slave1_wvalid && axi_slave1_wready),
   .event3      (axi_slave1_rvalid && axi_slave1_rready),
   .holdoff     (mem_holdoff)
   );
`endif

   assert_module a0 (
    .clk		(clk)
    ,.test		(carry_out0 || carry_out1)
   );

 
   bandwidth_throttle mem0_wradr_throttle (
    .clk        (mem_clk),
    .holdoff    (mem0_txn_wr_holdoff),
    .valid_in   (axi_slave0_awvalid),
    .ready_out  (axi_slave0_awready),

    .valid_out  (axi_slave0_awvalid_vip),
    .ready_in   (axi_slave0_awready_vip)
   );

   bandwidth_throttle mem1_wradr_throttle (
    .clk        (mem_clk),
    .holdoff    (mem1_txn_wr_holdoff),
    .valid_in   (axi_slave1_awvalid),
    .ready_out  (axi_slave1_awready),

    .valid_out  (axi_slave1_awvalid_vip),
    .ready_in   (axi_slave1_awready_vip)
   );

    bandwidth_throttle mem0_rdadr_throttle (
    .clk        (mem_clk),
    .holdoff    (mem0_txn_rd_holdoff),
    .valid_in   (axi_slave0_arvalid),
    .ready_out  (axi_slave0_arready),

    .valid_out  (axi_slave0_arvalid_vip),
    .ready_in   (axi_slave0_arready_vip)
   );

   bandwidth_throttle mem1_rdadr_throttle (
    .clk        (mem_clk),
    .holdoff    (mem1_txn_rd_holdoff),
    .valid_in   (axi_slave1_arvalid),
    .ready_out  (axi_slave1_arready),

    .valid_out  (axi_slave1_arvalid_vip),
    .ready_in   (axi_slave1_arready_vip)
   );

   bandwidth_throttle mem0_wr_bw_mon (
    .clk        (mem_clk),
    .holdoff    (mem_holdoff),
    .valid_in   (axi_slave0_wvalid),
    .ready_out  (axi_slave0_wready),

    .valid_out  (axi_slave0_wvalid_vip),
    .ready_in   (axi_slave0_wready_vip)
   );
   bandwidth_throttle mem1_wr_bw_mon (
    .clk        (mem_clk),
    .holdoff    (mem_holdoff),
    .valid_in   (axi_slave1_wvalid),
    .ready_out  (axi_slave1_wready),

    .valid_out  (axi_slave1_wvalid_vip),
    .ready_in   (axi_slave1_wready_vip)
   );
   bandwidth_throttle mem0_rd_bw_mon (
    .clk        (mem_clk),
    .holdoff    (mem_holdoff),
    .valid_out  (axi_slave0_rvalid),
    .ready_in   (axi_slave0_rready),

    .valid_in   (axi_slave0_rvalid_vip),
    .ready_out  (axi_slave0_rready_vip)

   );
   bandwidth_throttle mem1_rd_bw_mon (
    .clk        (mem_clk),
    .holdoff    (mem_holdoff),
    .valid_out  (axi_slave1_rvalid),
    .ready_in   (axi_slave1_rready),

    .valid_in   (axi_slave1_rvalid_vip),
    .ready_out  (axi_slave1_rready_vip)
   );

  // --------------------------
  // Generate waveforms
  // --------------------------

`ifndef ZEBU
`ifndef EMU_TB
initial begin
$dumpfile("bench_pk_pass.vcd");
`ifdef VCS
    $vcdpluson (0,
//	top.nvdla_top.nvdla_core_wrap.nvdla_core.fgsx0_0.SYS.sys_logic.host,
	top.slave_mem_wrap.axi_slave0,
	top.slave_mem_wrap.axi_slave1,
	top.slave_mem_wrap.dbb_mem,
	top.slave_mem_wrap.cvsram_mem,
	top.mem_clk_gen,top.clk, top.msc_clk_ip, top.reset, top.mem_clk_fast, top.mem_clk);
`endif
/*
$dumpvars(0,top.slave_mem_wrap.axi_slave0,
	top.slave_mem_wrap.axi_slave1,
	top.slave_mem_wrap.syn_mem,
	top.mem_clk_gen,top.clk, top.msc_clk_ip, top.reset, top.mem_clk_fast, top.mem_clk);
*/
end


  `ifdef NO_DUMPS
  `else

    reg [31:0]        dump_start_trans;     // starting transaction of dump (0 == off)
    reg [63:0]        dump_start_time;      // starting time of dump (0 == off)
    reg [63:0]        dump_stop_time;       // stopping time of dump (<= start is off)
    reg [(256*8)-1:0] vpd_dump_name;            // file name of dump
    string            input_dir, full_saif_filename ;
    reg [31:0]        saif_start_trans;     // starting transaction of saif (0 == off)
    reg [31:0]        saif_end_trans;       // ending transaction of saif (0 == off)

    // DVE FORMATS
    initial begin
/*
        $dumpfile("bench_pk_pass.vcd");
        $dumpvars(0,top.slave_mem_wrap.axi_slave0,
                    top.slave_mem_wrap.axi_slave1,
                    top.slave_mem_wrap.syn_mem);
*/



       if(!$value$plusargs("vpd_dump_name=%s", vpd_dump_name))  vpd_dump_name = "vpdplus.vpd";
       if(!$value$plusargs("dump_start_time=%d", dump_start_time))  dump_start_time = 0;
       if ( dump_start_time != 0 ) begin
           #(dump_start_time);
       end //
       if ($test$plusargs("dump_vpd") || $test$plusargs("dump_vcd")) begin
          $vcdplusfile (vpd_dump_name);
          $vcdpluson;
        `ifdef WAVES      
          $dumpvars;
        `endif
       end
    end
    // SAIF 
    reg [(256*8)-1:0] saif_name;            // file name of saif
    initial begin
       if ($test$plusargs("dump_saif")) begin

         if(!$value$plusargs("saif_name=%s", saif_name))  saif_name = "out.saif";
         if(!$value$plusargs("saif_start_trans=%d", saif_start_trans))  saif_start_trans = 0;
         if(!$value$plusargs("saif_end_trans=%d", saif_end_trans))  saif_end_trans = 9999999;

         $display( "(%0d) NVDLA_IP_INFO : monitoring with rtl_on for saif", $stime );
         $set_gate_level_monitoring("rtl_on");
         $display( "(%0d) NVDLA_IP_INFO : setting toggle region for saif", $stime );
         $set_toggle_region("nvdla_top");
         // $set_toggle_region("nvdla_top.nvdla_core_wrap.nvdla_core.fgsx0_0.GMF0TPC0.tpc0.smmmio");

         if ( saif_start_trans != 0 ) begin
           $display( "(%0d) NVDLA_IP_INFO : saif_start_trans enabled in file %0s", $stime, saif_name );
           wait (trans_count !== {32{1'bx}});
           $display( "(%0d) NVDLA_IP_INFO : start waiting for saif trans_count == %d", $stime, saif_start_trans );
           wait (trans_count >= saif_start_trans);
           $display( "(%0d) NVDLA_IP_INFO : starting saif, trans_count == %d", $stime, trans_count );
         end //

         #10 $toggle_start;
         $display( "(%0d) NVDLA_IP_INFO : toggle start for saif", $stime );

         if ( saif_end_trans != 0 ) begin
           $display( "(%0d) NVDLA_IP_INFO : saif_end_trans enabled in file %0s", $stime, saif_name );
           wait (trans_count !== {32{1'bx}});
           $display( "(%0d) NVDLA_IP_INFO : end waiting for trans_count == %d", $stime, saif_end_trans );
           wait (trans_count >= saif_end_trans);
           $display( "(%0d) NVDLA_IP_INFO : ending saif, trans_count == %d", $stime, trans_count );

           $toggle_stop;
           #10;

           if($value$plusargs("input_dir=%s", input_dir)) begin
            if ($test$plusargs("dump_smm_saif")) begin
             full_saif_filename = $psprintf("%0s/smm0.snps.saif",input_dir);
             $display( "(%0d) NVDLA_IP_INFO : creating toggle report for smmmio (%0s)", $stime, full_saif_filename );
//             $toggle_report(full_saif_filename, 1.0e-9, "nvdla_top.nvdla_core_wrap.nvdla_core.fgsx0_0.GMF0TPC0.tpc0.smmmio");
            end
            if ($test$plusargs("dump_top_saif")) begin
             full_saif_filename = $psprintf("%0s/top0.snps.saif",input_dir);
//             $display( "(%0d) NVDLA_IP_INFO : creating toggle report for nvdla_top (%0s)", $stime, full_saif_filename );
//             $toggle_report(full_saif_filename, 1.0e-9, "nvdla_top");
            end
           end
         end //

       end
    end

    // VERDI FORMATS
    reg [(256*8)-1:0] dump_name;            // file name of dump
    reg [(256*8)-1:0] dump_cone;            // name of file containing dump cone.
    reg [(256*8)-1:0] esa_path;             // path to esa.list
    reg [(256*8)-1:0] tb_dir;               // path to tb dir
    integer           esa_fhandle;

    initial begin
       if(!$value$plusargs("dump_name=%s", dump_name))  dump_name = "debussy.fsdb";
       if(!$value$plusargs("dump_start_time=%d", dump_start_time))  dump_start_time = 1;
       if(!$value$plusargs("dump_start_trans=%d", dump_start_trans))  dump_start_trans = 0;
       dump_stop_time = 0;
       
       if ( dump_start_time != 0 ) begin
           #(dump_start_time);
       end //
       if ( dump_start_trans != 0 ) begin
           $display( "(%0d) NVDLA_IP_INFO : dump_start_trans enabled in file %0s", $stime, dump_name );
           wait (trans_count !== {32{1'bx}});
           $display( "(%0d) NVDLA_IP_INFO : waiting for trans_count == %d", $stime, dump_start_trans );
           wait (trans_count >= dump_start_trans);
           $display( "(%0d) NVDLA_IP_INFO : starting fsdb dump, trans_count == %d", $stime, trans_count );
       end //
       if ( $test$plusargs("dump_fsdb") || $test$plusargs("fsdb_dump")) begin
              $display( "(%0d) NVDLA_IP_INFO : Turning on fsdb dump to file %0s", $stime, dump_name );
             `ifdef VERILINT
             `else
             `endif
              $fsdbAutoSwitchDumpfile( 1000, dump_name, 20 );
              $fsdbDumpvars("level=",0,top);
              // $fsdbAutoSwitchDumpfile(100, "verilog.fsdb", 20);
              // $fsdbDumpfile( dump_name );
              // $fsdbDumpvars( 0, top );
              // $fsdbDumpvars;
              // $fsdbDumpon();
              #1;
              $display( "(%0d) NVDLA_IP_INFO : fsdb dumping enabled. %0s", $stime, dump_name );
       end

    end
  `endif
`endif
`endif

endmodule                     



// --------------------------
// Generate Timers for DLA 
// --------------------------

module soc2nvdla_time_gen (
    clk
   ,reset_
   ,soc2nvdla_time1_gray
   ,soc2nvdla_time0_gray
   ,soc2nvdla_time_tick
  );

 input         clk;
 input         reset_;
 output [28:0] soc2nvdla_time1_gray;
 output [26:0] soc2nvdla_time0_gray;
 output        soc2nvdla_time_tick;
   
 reg    [28:0] soc2nvdla_time1_gray;
 reg    [26:0] soc2nvdla_time0_gray;
 reg    [28:0] soc2nvdla_time1_bin;
 reg    [26:0] soc2nvdla_time0_bin;

 wire   [55:0] soc2nvdla_time_bin_right_shift;

 always @(posedge clk or negedge reset_) begin
   if (!reset_) begin
     {soc2nvdla_time1_bin,soc2nvdla_time0_bin} <= {56{1'b0}};
   end else begin
     {soc2nvdla_time1_bin,soc2nvdla_time0_bin} <= {soc2nvdla_time1_bin,soc2nvdla_time0_bin} + 1;
   end
 end

 assign  soc2nvdla_time_bin_right_shift = ( {soc2nvdla_time1_bin,soc2nvdla_time0_bin} >> 1) ;

 assign  soc2nvdla_time_tick = soc2nvdla_time_bin_right_shift[4];

 always @( soc2nvdla_time1_bin or soc2nvdla_time0_bin or soc2nvdla_time_bin_right_shift) begin
     {soc2nvdla_time1_gray[28:0],soc2nvdla_time0_gray[26:0]} = Bin2Gray({soc2nvdla_time1_bin[28:0], soc2nvdla_time0_bin[26:0]}, soc2nvdla_time_bin_right_shift) ;
 end

 function [55:0] Bin2Gray ;
   input [55:0] Bin;
   input [55:0] Bin_right_shift;
   begin
     Bin2Gray = Bin ^ Bin_right_shift;
   end
 endfunction

endmodule

module bandwidth_mon(
    clk,
    event0,
    event1,
    event2,
    event3,
    holdoff
);
input clk;
input event0;
input event1;
input event2;
input event3;

output holdoff;
`ifdef EMU_TB
assign holdoff = 1'b0;
`else
  real max_pct;
  real current_util;
  real window_r;

  reg [3999:0] history = 0;
  integer counter = 0;
  integer window = 100;
  integer num_ones;
  reg holdoff = 0;
  reg disable_throttle = 0;

  initial begin
    if(!($value$plusargs("mem_bandwidth_pct=%d", max_pct))) begin
        max_pct = 50;
    end
    if(!($value$plusargs("mem_bandwidth_window=%d", window))) begin
        window = 100;
    end
    `ifndef VERDI_VIEWING
//   if(window > 1000) begin `uvm_fatal("PLUSARG_ERR", "mem_bandwidth_window must be less than 1000"); end
    if(window > 1000) begin
		$display( "(%0d) NVDLA_IP_ERROR : mem_bandwidth_window must be less than 1000)", $stime, );
		$finish;
	end
    `endif


    window = 4 * window; //4 events per clock
    window_r = window;
  end

  always @(negedge clk) begin
    history[counter  ] = event0;
    history[counter+1] = event1;
    history[counter+2] = event2;
    history[counter+3] = event3;

    if(window <= 100) begin
        num_ones = $countones(history[399:0]);
    end else begin
        num_ones = $countones(history);
    end

    current_util = ((num_ones*1.0) / (window_r*1.0)) * 100.0;

    holdoff = current_util > max_pct;

    counter = counter + 4;
    if(counter > (window-4)) counter = 0;
  end
`endif
endmodule


module bandwidth_throttle(
    clk
    ,holdoff
    ,ready_in
    ,valid_in
    ,ready_out
    ,valid_out
  );
  input clk;
  input holdoff;
  input ready_in;
  input valid_in;

  output ready_out;
  output valid_out;

  assign ready_out = ready_in & !holdoff;
  assign valid_out = valid_in & !holdoff;

endmodule

module assert_module(clk, test);
    input clk;
    input test;
    always @(posedge clk)
    begin
        if (test == 1)
        begin
            $display("ASSERTION FAILED in %m");  // spyglass disable W213 SYNTH_5166
            $finish;  // spyglass disable W213 SYNTH_5166
        end
    end
endmodule


