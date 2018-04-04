`ifndef _NVDLA_TB_TOP_SV_
`define _NVDLA_TB_TOP_SV_
`timescale 100ps/100ps
//-------------------------------------------------------------------------------------
//
// MODULE: nvdla_tp_top
//
//-------------------------------------------------------------------------------------

module nvdla_tb_top;

    import nvdla_tb_common_pkg::*;

    parameter core_cycle = 10;
    parameter csb_cycle  = 10;

    reg       core_clk;
    reg       csb_clk;
    reg       rstn;
    
    int       pri_intf_bvalid_trans_count;
    int       pri_intf_rvalid_trans_count;
    int       sec_intf_bvalid_trans_count;
    int       sec_intf_rvalid_trans_count;
    int       total_trans_count;

    wire      intf_busy;
    wire      cc_busy;
    wire      sdp_busy;
    wire      pdp_busy;
    wire      dut_busy;
    //-----------------------------------------------------------WIRE SIGNAL DECLARATION
    // 
    // @{

    /*AUTOINPUT*/
    // Beginning of automatic inputs (from unused autoinst inputs)
    wire [15:0]        csb2nvdla_addr;                // To DLA_DUT of NV_nvdla.v
    wire               csb2nvdla_nposted;             // To DLA_DUT of NV_nvdla.v
    wire               csb2nvdla_valid;               // To DLA_DUT of NV_nvdla.v
    wire [31:0]        csb2nvdla_wdat;                // To DLA_DUT of NV_nvdla.v
    wire               csb2nvdla_write;               // To DLA_DUT of NV_nvdla.v
    wire               direct_reset_;                 // To DLA_DUT of NV_nvdla.v
    wire               dla_core_clk;                  // To DLA_DUT of NV_nvdla.v
    wire               dla_csb_clk;                   // To DLA_DUT of NV_nvdla.v
    wire               dla_reset_rstn;                // To DLA_DUT of NV_nvdla.v
    wire               global_clk_ovr_on;             // To DLA_DUT of NV_nvdla.v
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
    wire               nvdla_core2cvsram_ar_arready;  // To DLA_DUT of NV_nvdla.v
    wire               nvdla_core2cvsram_aw_awready;  // To DLA_DUT of NV_nvdla.v
    wire [7:0]         nvdla_core2cvsram_b_bid;       // To DLA_DUT of NV_nvdla.v
    wire               nvdla_core2cvsram_b_bvalid;    // To DLA_DUT of NV_nvdla.v
    wire [511:0]       nvdla_core2cvsram_r_rdata;     // To DLA_DUT of NV_nvdla.v
    wire [7:0]         nvdla_core2cvsram_r_rid;       // To DLA_DUT of NV_nvdla.v
    wire               nvdla_core2cvsram_r_rlast;     // To DLA_DUT of NV_nvdla.v
    wire               nvdla_core2cvsram_r_rvalid;    // To DLA_DUT of NV_nvdla.v
    wire               nvdla_core2cvsram_w_wready;    // To DLA_DUT of NV_nvdla.v
`endif
    wire               nvdla_core2dbb_ar_arready;     // To DLA_DUT of NV_nvdla.v
    wire               nvdla_core2dbb_aw_awready;     // To DLA_DUT of NV_nvdla.v
    wire [7:0]         nvdla_core2dbb_b_bid;          // To DLA_DUT of NV_nvdla.v
    wire               nvdla_core2dbb_b_bvalid;       // To DLA_DUT of NV_nvdla.v
    wire [511:0]       nvdla_core2dbb_r_rdata;        // To DLA_DUT of NV_nvdla.v
    wire [7:0]         nvdla_core2dbb_r_rid;          // To DLA_DUT of NV_nvdla.v
    wire               nvdla_core2dbb_r_rlast;        // To DLA_DUT of NV_nvdla.v
    wire               nvdla_core2dbb_r_rvalid;       // To DLA_DUT of NV_nvdla.v
    wire               nvdla_core2dbb_w_wready;       // To DLA_DUT of NV_nvdla.v
    wire [31:0]        nvdla_pwrbus_ram_a_pd;         // To DLA_DUT of NV_nvdla.v
    wire [31:0]        nvdla_pwrbus_ram_c_pd;         // To DLA_DUT of NV_nvdla.v
    wire [31:0]        nvdla_pwrbus_ram_ma_pd;        // To DLA_DUT of NV_nvdla.v
    wire [31:0]        nvdla_pwrbus_ram_mb_pd;        // To DLA_DUT of NV_nvdla.v
    wire [31:0]        nvdla_pwrbus_ram_o_pd;         // To DLA_DUT of NV_nvdla.v
    wire [31:0]        nvdla_pwrbus_ram_p_pd;         // To DLA_DUT of NV_nvdla.v
    wire               test_mode;                     // To DLA_DUT of NV_nvdla.v
    wire               tmc2slcg_disable_clock_gating; // To DLA_DUT of NV_nvdla.v
    // End of automatics
    /*AUTOOUTPUT*/
    // Beginning of automatic outputs (from unused autoinst outputs)
    wire              csb2nvdla_ready;               // From DLA_DUT of NV_nvdla.v
    wire              dla_intr;                      // From DLA_DUT of NV_nvdla.v
    wire [31:0]       nvdla2csb_data;                // From DLA_DUT of NV_nvdla.v
    wire              nvdla2csb_valid;               // From DLA_DUT of NV_nvdla.v
    wire              nvdla2csb_wr_complete;         // From DLA_DUT of NV_nvdla.v
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
    wire [63:0]       nvdla_core2cvsram_ar_araddr;   // From DLA_DUT of NV_nvdla.v
    wire [7:0]        nvdla_core2cvsram_ar_arid;     // From DLA_DUT of NV_nvdla.v
    wire [3:0]        nvdla_core2cvsram_ar_arlen;    // From DLA_DUT of NV_nvdla.v
    wire              nvdla_core2cvsram_ar_arvalid;  // From DLA_DUT of NV_nvdla.v
    wire [63:0]       nvdla_core2cvsram_aw_awaddr;   // From DLA_DUT of NV_nvdla.v
    wire [7:0]        nvdla_core2cvsram_aw_awid;     // From DLA_DUT of NV_nvdla.v
    wire [3:0]        nvdla_core2cvsram_aw_awlen;    // From DLA_DUT of NV_nvdla.v
    wire              nvdla_core2cvsram_aw_awvalid;  // From DLA_DUT of NV_nvdla.v
    wire              nvdla_core2cvsram_b_bready;    // From DLA_DUT of NV_nvdla.v
    wire              nvdla_core2cvsram_r_rready;    // From DLA_DUT of NV_nvdla.v
    wire [511:0]      nvdla_core2cvsram_w_wdata;     // From DLA_DUT of NV_nvdla.v
    wire              nvdla_core2cvsram_w_wlast;     // From DLA_DUT of NV_nvdla.v
    wire [63:0]       nvdla_core2cvsram_w_wstrb;     // From DLA_DUT of NV_nvdla.v
    wire              nvdla_core2cvsram_w_wvalid;    // From DLA_DUT of NV_nvdla.v
`endif
    wire [63:0]       nvdla_core2dbb_ar_araddr;      // From DLA_DUT of NV_nvdla.v
    wire [7:0]        nvdla_core2dbb_ar_arid;        // From DLA_DUT of NV_nvdla.v
    wire [3:0]        nvdla_core2dbb_ar_arlen;       // From DLA_DUT of NV_nvdla.v
    wire              nvdla_core2dbb_ar_arvalid;     // From DLA_DUT of NV_nvdla.v
    wire [63:0]       nvdla_core2dbb_aw_awaddr;      // From DLA_DUT of NV_nvdla.v
    wire [7:0]        nvdla_core2dbb_aw_awid;        // From DLA_DUT of NV_nvdla.v
    wire [3:0]        nvdla_core2dbb_aw_awlen;       // From DLA_DUT of NV_nvdla.v
    wire              nvdla_core2dbb_aw_awvalid;     // From DLA_DUT of NV_nvdla.v
    wire              nvdla_core2dbb_b_bready;       // From DLA_DUT of NV_nvdla.v
    wire              nvdla_core2dbb_r_rready;       // From DLA_DUT of NV_nvdla.v
    wire [511:0]      nvdla_core2dbb_w_wdata;        // From DLA_DUT of NV_nvdla.v
    wire              nvdla_core2dbb_w_wlast;        // From DLA_DUT of NV_nvdla.v
    wire [63:0]       nvdla_core2dbb_w_wstrb;        // From DLA_DUT of NV_nvdla.v
    wire              nvdla_core2dbb_w_wvalid;       // From DLA_DUT of NV_nvdla.v
    // End of automatics

    // }@


    //----------------------------------------------------------CLOCK & RESET GENERATION
    //
    // @{

    assign dla_core_clk                  = core_clk;
    assign dla_csb_clk                   = csb_clk;
    assign dla_reset_rstn                = rstn;
    assign test_mode                     = 1'b0;
    assign global_clk_ovr_on             = 1'b0;
    assign tmc2slcg_disable_clock_gating = 1'b0;
    assign nvdla_pwrbus_ram_c_pd         = 32'b0;
    assign nvdla_pwrbus_ram_p_pd         = 32'b0;
    assign nvdla_pwrbus_ram_o_pd         = 32'b0;
    assign nvdla_pwrbus_ram_a_pd         = 32'b0;
    assign nvdla_pwrbus_ram_ma_pd        = 32'b0;
    assign nvdla_pwrbus_ram_mb_pd        = 32'b0;


    initial begin
        core_clk = 0;
        forever #(core_cycle/2) core_clk = ~core_clk;
    end

    initial begin
        csb_clk = 0;
        forever #(csb_cycle/2) csb_clk = ~csb_clk;
    end

    initial begin
        rstn = 0;
        #10;
        rstn = 1;
    end

    // }@

    //------------------------------------------------------------------WAVEFORM DUMPING
    //
    // @{
    initial begin
		if($test$plusargs("wave")) begin 
			$display("Dumping FSDB waveform");
          	$fsdbDumpfile("nvdla");
          	$fsdbDumpvars(0);
		end
    end

    final begin
        $fsdbDumpflush();
    end

    // }@

    //----------------------------------------------------------------NVDLA DUT INSTANCE
    //
    // @{
    NV_nvdla DLA_DUT(/*AUTOINST*/
                     // Outputs
                     .csb2nvdla_ready               (csb2nvdla_ready),
                     .nvdla2csb_valid               (nvdla2csb_valid),
                     .nvdla2csb_data                (nvdla2csb_data[31:0]),
                     .nvdla2csb_wr_complete         (nvdla2csb_wr_complete),
                     .nvdla_core2dbb_aw_awvalid     (nvdla_core2dbb_aw_awvalid),
                     .nvdla_core2dbb_aw_awid        (nvdla_core2dbb_aw_awid[7:0]),
                     .nvdla_core2dbb_aw_awlen       (nvdla_core2dbb_aw_awlen[3:0]),
                     .nvdla_core2dbb_aw_awaddr      (nvdla_core2dbb_aw_awaddr[63:0]),
                     .nvdla_core2dbb_w_wvalid       (nvdla_core2dbb_w_wvalid),
                     .nvdla_core2dbb_w_wdata        (nvdla_core2dbb_w_wdata[511:0]),
                     .nvdla_core2dbb_w_wstrb        (nvdla_core2dbb_w_wstrb[63:0]),
                     .nvdla_core2dbb_w_wlast        (nvdla_core2dbb_w_wlast),
                     .nvdla_core2dbb_b_bready       (nvdla_core2dbb_b_bready),
                     .nvdla_core2dbb_ar_arvalid     (nvdla_core2dbb_ar_arvalid),
                     .nvdla_core2dbb_ar_arid        (nvdla_core2dbb_ar_arid[7:0]),
                     .nvdla_core2dbb_ar_arlen       (nvdla_core2dbb_ar_arlen[3:0]),
                     .nvdla_core2dbb_ar_araddr      (nvdla_core2dbb_ar_araddr[63:0]),
                     .nvdla_core2dbb_r_rready       (nvdla_core2dbb_r_rready),
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
                     .nvdla_core2cvsram_aw_awvalid  (nvdla_core2cvsram_aw_awvalid),
                     .nvdla_core2cvsram_aw_awid     (nvdla_core2cvsram_aw_awid[7:0]),
                     .nvdla_core2cvsram_aw_awlen    (nvdla_core2cvsram_aw_awlen[3:0]),
                     .nvdla_core2cvsram_aw_awaddr   (nvdla_core2cvsram_aw_awaddr[63:0]),
                     .nvdla_core2cvsram_w_wvalid    (nvdla_core2cvsram_w_wvalid),
                     .nvdla_core2cvsram_w_wdata     (nvdla_core2cvsram_w_wdata[511:0]),
                     .nvdla_core2cvsram_w_wstrb     (nvdla_core2cvsram_w_wstrb[63:0]),
                     .nvdla_core2cvsram_w_wlast     (nvdla_core2cvsram_w_wlast),
                     .nvdla_core2cvsram_b_bready    (nvdla_core2cvsram_b_bready),
                     .nvdla_core2cvsram_ar_arvalid  (nvdla_core2cvsram_ar_arvalid),
                     .nvdla_core2cvsram_ar_arid     (nvdla_core2cvsram_ar_arid[7:0]),
                     .nvdla_core2cvsram_ar_arlen    (nvdla_core2cvsram_ar_arlen[3:0]),
                     .nvdla_core2cvsram_ar_araddr   (nvdla_core2cvsram_ar_araddr[63:0]),
                     .nvdla_core2cvsram_r_rready    (nvdla_core2cvsram_r_rready),
`endif
                     .dla_intr                      (dla_intr),
                     // Inputs
                     .dla_core_clk                  (dla_core_clk),
                     .dla_csb_clk                   (dla_csb_clk),
                     .global_clk_ovr_on             (global_clk_ovr_on),
                     .tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating),
                     .dla_reset_rstn                (dla_reset_rstn),
                     .direct_reset_                 (direct_reset_),
                     .test_mode                     (test_mode),
                     .csb2nvdla_valid               (csb2nvdla_valid),
                     .csb2nvdla_addr                (csb2nvdla_addr[15:0]),
                     .csb2nvdla_wdat                (csb2nvdla_wdat[31:0]),
                     .csb2nvdla_write               (csb2nvdla_write),
                     .csb2nvdla_nposted             (csb2nvdla_nposted),
                     .nvdla_core2dbb_aw_awready     (nvdla_core2dbb_aw_awready),
                     .nvdla_core2dbb_w_wready       (nvdla_core2dbb_w_wready),
                     .nvdla_core2dbb_b_bvalid       (nvdla_core2dbb_b_bvalid),
                     .nvdla_core2dbb_b_bid          (nvdla_core2dbb_b_bid[7:0]),
                     .nvdla_core2dbb_ar_arready     (nvdla_core2dbb_ar_arready),
                     .nvdla_core2dbb_r_rvalid       (nvdla_core2dbb_r_rvalid),
                     .nvdla_core2dbb_r_rid          (nvdla_core2dbb_r_rid[7:0]),
                     .nvdla_core2dbb_r_rlast        (nvdla_core2dbb_r_rlast),
                     .nvdla_core2dbb_r_rdata        (nvdla_core2dbb_r_rdata[`NVDLA_PRIMARY_MEMIF_WIDTH-1:0]),
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
                     .nvdla_core2cvsram_aw_awready  (nvdla_core2cvsram_aw_awready),
                     .nvdla_core2cvsram_w_wready    (nvdla_core2cvsram_w_wready),
                     .nvdla_core2cvsram_b_bvalid    (nvdla_core2cvsram_b_bvalid),
                     .nvdla_core2cvsram_b_bid       (nvdla_core2cvsram_b_bid[7:0]),
                     .nvdla_core2cvsram_ar_arready  (nvdla_core2cvsram_ar_arready),
                     .nvdla_core2cvsram_r_rvalid    (nvdla_core2cvsram_r_rvalid),
                     .nvdla_core2cvsram_r_rid       (nvdla_core2cvsram_r_rid[7:0]),
                     .nvdla_core2cvsram_r_rlast     (nvdla_core2cvsram_r_rlast),
                     .nvdla_core2cvsram_r_rdata     (nvdla_core2cvsram_r_rdata[`NVDLA_SECONDARY_MEMIF_WIDTH-1:0]),
`endif
                     .nvdla_pwrbus_ram_c_pd         (nvdla_pwrbus_ram_c_pd[31:0]),
                     .nvdla_pwrbus_ram_ma_pd        (nvdla_pwrbus_ram_ma_pd[31:0]),
                     .nvdla_pwrbus_ram_mb_pd        (nvdla_pwrbus_ram_mb_pd[31:0]),
                     .nvdla_pwrbus_ram_p_pd         (nvdla_pwrbus_ram_p_pd[31:0]),
                     .nvdla_pwrbus_ram_o_pd         (nvdla_pwrbus_ram_o_pd[31:0]),
                     .nvdla_pwrbus_ram_a_pd         (nvdla_pwrbus_ram_a_pd[31:0]));
    // }@

    nvdla_top_sv_module_wrapper rm_top_module_inst();
    
    //----------------------------------------------------------------INTERFACE INSTANCE
    // 
    // @{

    csb_interface  csb_if(.clk(csb_clk), .rst_n(dla_reset_rstn));

    dbb_interface#(`NVDLA_PRIMARY_MEMIF_WIDTH)  pri_mem_if(.clk(core_clk), .rst_n(dla_reset_rstn));
    `ifdef NVDLA_SECONDARY_MEMIF_ENABLE
    dbb_interface#(`NVDLA_SECONDARY_MEMIF_WIDTH)  sec_mem_if(.clk(core_clk), .rst_n(dla_reset_rstn));
    `endif

    `define CDMA_WT  DLA_DUT.u_partition_c.u_NV_NVDLA_cdma
    `define CDMA_DAT DLA_DUT.u_partition_c.u_NV_NVDLA_cdma
    `define CSC      DLA_DUT.u_partition_c.u_NV_NVDLA_csc
    `define CMAC_A   DLA_DUT.u_partition_ma
    `define CMAC_B   DLA_DUT.u_partition_mb
    `define CACC     DLA_DUT.u_partition_a.u_NV_NVDLA_cacc
    `define SDP      DLA_DUT.u_partition_p.u_NV_NVDLA_sdp
    `define SDP_B    DLA_DUT.u_partition_p.u_NV_NVDLA_sdp
    `define SDP_N    DLA_DUT.u_partition_p.u_NV_NVDLA_sdp
    `define SDP_E    DLA_DUT.u_partition_p.u_NV_NVDLA_sdp
    `define PDP      DLA_DUT.u_partition_o.u_NV_NVDLA_pdp
    `define CDP      DLA_DUT.u_partition_o.u_NV_NVDLA_cdp
    `define BDMA     DLA_DUT.u_partition_o.u_NV_NVDLA_bdma
    `define RBK      DLA_DUT.u_partition_o.u_NV_NVDLA_rubik

    //:| global project
    //:| import project
    //:| global dma_ports
    //:| dma_ports = ["cdma_wt", "cdma_dat", "sdp"]
    //:| if "NVDLA_SDP_BS_ENABLE" in project.PROJVAR: dma_ports.append("sdp_b")
    //:| if "NVDLA_SDP_BN_ENABLE" in project.PROJVAR: dma_ports.append("sdp_n")
    //:| if "NVDLA_SDP_EW_ENABLE" in project.PROJVAR: dma_ports.append("sdp_e")
    //:| if "NVDLA_PDP_ENABLE"    in project.PROJVAR: dma_ports.append("pdp")
    //:| if "NVDLA_CDP_ENABLE"    in project.PROJVAR: dma_ports.append("cdp")
    //:| if "NVDLA_BDMA_ENABLE"   in project.PROJVAR: dma_ports.append("bdma")
    //:| if "NVDLA_RUBIK_ENABLE"  in project.PROJVAR: dma_ports.append("rbk")
    //:| for dma in dma_ports:
    //:|     print("    dma_interface  %0s_pri_mem_if(.clk(`%0s.nvdla_core_clk), .resetn(`%0s.nvdla_core_rstn));" % (dma, dma.upper(), dma.upper()))
    //:|     if "NVDLA_SECONDARY_MEMIF_ENABLE" in project.PROJVAR:
    //:|         print("    dma_interface  %0s_sec_mem_if(.clk(`%0s.nvdla_core_clk), .resetn(`%0s.nvdla_core_rstn));" % (dma, dma.upper(), dma.upper()))

    cc_interface#(CSC_DT_DW,CSC_DT_DS)  csc_dat_a_if  (.clk(`CSC.nvdla_core_clk),    .resetn(`CSC.nvdla_core_rstn));
    cc_interface#(CSC_WT_DW,CSC_WT_DS)  csc_wt_a_if   (.clk(`CSC.nvdla_core_clk),    .resetn(`CSC.nvdla_core_rstn));
    cc_interface#(CSC_DT_DW,CSC_DT_DS)  csc_dat_b_if  (.clk(`CSC.nvdla_core_clk),    .resetn(`CSC.nvdla_core_rstn));
    cc_interface#(CSC_WT_DW,CSC_WT_DS)  csc_wt_b_if   (.clk(`CSC.nvdla_core_clk),    .resetn(`CSC.nvdla_core_rstn));
    cc_interface#(CMAC_DW, CMAC_DS)     cmac_a_if     (.clk(`CMAC_A.nvdla_core_clk), .resetn(`CMAC_A.nvdla_core_rstn));
    cc_interface#(CMAC_DW, CMAC_DS)     cmac_b_if     (.clk(`CMAC_B.nvdla_core_clk), .resetn(`CMAC_B.nvdla_core_rstn));
    dp_interface#(CACC_PW)              cacc_if       (.clk(`CACC.nvdla_core_clk),   .resetn(`CACC.nvdla_core_rstn));
    dp_interface#(SDP_PW)               sdp_if        (.clk(`SDP.nvdla_core_clk),    .resetn(`SDP.nvdla_core_rstn));

    `include "nvdla_tb_connect.sv"

    initial begin
        string work_mode;
        if($value$plusargs("WORK_MODE=%0s", work_mode)) begin
            if("CMOD_ONLY" == work_mode) begin
                force csb_if.prdy        = 1;
                force csb2nvdla_valid    = 0;
                force dla_csb_clk        = 0;
                force dla_core_clk       = 0;
            end
        end
    end
    
    always @(posedge core_clk) begin
        string work_mode;
        if($value$plusargs("WORK_MODE=%0s", work_mode)) begin
            if("CMOD_ONLY" == work_mode) begin
                if(csb_if.pvld && csb_if.nposted && csb_if.write) begin
                    @(posedge csb_clk);
                    force csb_if.wr_complete = 1;
                    @(posedge csb_clk);
                    force csb_if.wr_complete = 0;
                end
                else if(csb_if.pvld && (csb_if.write===0)) begin
                    @(posedge csb_clk);
                    force csb_if.rvld = 1;
                    @(posedge csb_clk);
                    force csb_if.rvld = 0;
                end
            end
        end
    end

    // }@

    //-------------------------------------------------------TESTBENCH ENV CONFIGURATION
    // Centralized control of testbench environment through UVM config_db
    // @{

    initial begin
        // configure virtual interface
        uvm_config_db#(virtual csb_interface)::set(null, "*.csb_agt", "vif",    csb_if);
        uvm_config_db#(virtual dbb_interface#(`NVDLA_PRIMARY_MEMIF_WIDTH))::set(null, "*.pri_mem_agt", "slv_if", pri_mem_if);
        `ifdef NVDLA_SECONDARY_MEMIF_ENABLE
        uvm_config_db#(virtual dbb_interface#(`NVDLA_SECONDARY_MEMIF_WIDTH))::set(null, "*.sec_mem_agt", "slv_if", sec_mem_if);
        `endif

        //:| for dma in dma_ports:
        //:|     print("        uvm_config_db#(virtual dma_interface)::set(null, \"*.%0s_pri_mem_agt\", \"slv_if\", %0s_pri_mem_if);" % (dma, dma))
        //:|     if "NVDLA_SECONDARY_MEMIF_ENABLE" in project.PROJVAR:
        //:|         print("        uvm_config_db#(virtual dma_interface)::set(null, \"*.%0s_sec_mem_agt\", \"slv_if\", %0s_sec_mem_if);" % (dma, dma))

		uvm_config_db#(virtual cc_interface#(CSC_DT_DW, CSC_DT_DS))::set(null,"*.csc_dat_a_agt","slv_if",csc_dat_a_if); 
		uvm_config_db#(virtual cc_interface#(CSC_WT_DW, CSC_WT_DS))::set(null,"*.csc_wt_a_agt","slv_if",csc_wt_a_if); 
		uvm_config_db#(virtual cc_interface#(CSC_DT_DW, CSC_DT_DS))::set(null,"*.csc_dat_b_agt","slv_if",csc_dat_b_if); 
		uvm_config_db#(virtual cc_interface#(CSC_WT_DW, CSC_WT_DS))::set(null,"*.csc_wt_b_agt","slv_if",csc_wt_b_if); 
		uvm_config_db#(virtual cc_interface#(CMAC_DW, CMAC_DS))::set(null,"*.cmac_a_agt","slv_if",cmac_a_if); 
		uvm_config_db#(virtual cc_interface#(CMAC_DW, CMAC_DS))::set(null,"*.cmac_b_agt","slv_if",cmac_b_if); 
		uvm_config_db#(virtual dp_interface#(CACC_PW))::set(null,"*.cacc_agt","slv_if",cacc_if); 
		uvm_config_db#(virtual dp_interface#(SDP_PW))::set(null,"*.sdp_agt","slv_if",sdp_if); 
    end

    // }@

    //-------------------------------------------------------ENTRANCE of SIMULATION TEST
    // Phases all components through all registered phases, choose default top test:
    // nvdla_tb_base_test, and can be overridden by command-line plusarg: +UVM_TESTNAME
    // @{
    uvm_event_pool  glb_evts;
    initial begin
        uvm_event       dut_evt;
        uvm_event       rm_evt;
        uvm_event       sim_done_evt;

        dut_evt      = new("dut_intr_evt");
        rm_evt       = new("rm_intr_evt");
        sim_done_evt = new("sim_done_evt");

        glb_evts = uvm_event_pool::get_global_pool();
        if(glb_evts == null) begin
            `uvm_fatal("NVDLA_TB_TOP", "Failed to get global event pool")
        end
        glb_evts.add("dut_intr_evt", dut_evt);
        glb_evts.add("rm_intr_evt",  rm_evt);
        glb_evts.add("sim_done_evt", sim_done_evt);

        run_test("nvdla_tb_base_test");
    end

    // }@
    
    always @(posedge core_clk) begin
        if(dla_intr === 1) begin
            uvm_event       evt;
            evt = glb_evts.get("dut_intr_evt");
            evt.trigger();
            evt.wait_off();
        end
    end

    wire   rm_dla_intr;
    assign rm_dla_intr = rm_top_module_inst.nvdla_intr;
    always @(posedge core_clk) begin
        if(rm_dla_intr === 1) begin
            uvm_event       evt;
            evt = glb_evts.get("rm_intr_evt");
            evt.trigger();
            evt.wait_off();
        end
    end

    initial begin
        bit[15:0] counter;
        int fd; 
        string walltime;
        forever begin
            @(posedge core_clk);
            counter++;                                                                                                                                                                                                                     
            if(counter==0) begin
                $system("date \"+%Y-%m-%d-%H:%M:%S\" > localtime");
                fd = $fopen("localtime", "r");
                void'($fscanf(fd,"%s",walltime));
                $fclose(fd);
                $display("[HEART_BEAT]: TimeStamp @%0t, walltime=%0s",$time,walltime);
            end 
        end     
    end

    // TIMEOUT control: through interface busy checking
    `ifdef NVDLA_SECONDARY_MEMIF_ENABLE
    assign intf_busy = pri_mem_if.arvalid | pri_mem_if.rvalid | pri_mem_if.awvalid | 
                       sec_mem_if.arvalid | sec_mem_if.rvalid | sec_mem_if.awvalid | 
                       csb_if.pvld;
    `else
    assign intf_busy = pri_mem_if.arvalid | pri_mem_if.rvalid | pri_mem_if.awvalid | 
                       csb_if.pvld;
    `endif
    assign cc_busy = `CMAC_A.sc2mac_dat_pvld | `CDMA_DAT.cdma2buf_dat_wr_en | 
                     `CDMA_WT.cdma2buf_wt_wr_en;
    assign sdp_busy = `SDP.u_core.cvt_data_out_pvld && `SDP.u_core.cvt_data_out_prdy;
    assign pdp_busy = `PDP.u_core.u_cal2d.load_din;
    assign dut_busy = intf_busy | cc_busy | sdp_busy | pdp_busy;

    initial begin    
        bit[15:0] counter;
        forever begin                                                                                                                                                                                                                      
            @(posedge core_clk);
            if( !rstn ) begin
                counter = 0;
            end else begin
                if( dut_busy ) begin
                    counter = 0;
                end else begin
                    counter ++;
                end  
            end      
            if( counter > 5000 ) begin
                `uvm_fatal("NVDLA_TB_TOP", "TIMEOUT: over 5000 core clock cycles both I/Fs and internal busy indicator are IDLE. Terminate simulation now ...");
            end      
        end          
    end


    //-------------------------------------------------------------TESTBENCH SAIF CONFIG
    // Centralized control of testbench SAIF dumpping
    // @{
`ifdef NVDLA_SAIF_ENABLE
    always @ (posedge nvdla_core2dbb_b_bvalid) begin
        pri_intf_bvalid_trans_count += 1;
    end
    
    always @ (posedge nvdla_core2dbb_r_rvalid) begin
        pri_intf_rvalid_trans_count += 1;
    end
    `ifdef NVDLA_SECONDARY_MEMIF_ENABLE
        always @ (posedge nvdla_core2cvsram_b_bvalid) begin
            sec_intf_bvalid_trans_count += 1;
        end
        
        always @ (posedge nvdla_core2cvsram_r_rvalid) begin
            sec_intf_rvalid_trans_count += 1;
        end
    `endif //NVDLA_SECONDARY_MEMIF_ENABLE
    always @(pri_intf_rvalid_trans_count or pri_intf_bvalid_trans_count or sec_intf_rvalid_trans_count or sec_intf_bvalid_trans_count) begin
        total_trans_count = pri_intf_bvalid_trans_count + pri_intf_rvalid_trans_count + sec_intf_bvalid_trans_count + sec_intf_rvalid_trans_count;
    end

    initial begin
        string saif_name;
        int saif_start_trans;
        int saif_end_trans;
    
        if ($test$plusargs("dump_saif")) begin
            `uvm_info("NVDLA_TB_TOP","NVDLA_SAIF_ENABLE is set in compile", UVM_NONE) 
            if(!$value$plusargs("saif_name=%s", saif_name))  saif_name = "out.saif";
            if(!$value$plusargs("saif_start_trans=%d", saif_start_trans))  saif_start_trans = 0;
            if(!$value$plusargs("saif_end_trans=%d", saif_end_trans))  saif_end_trans = 9999999;
            
            `uvm_info("NVDLA_TB_TOP",$psprintf("(%0d) NVDLA_SAIF: monitoring with rtl_on for saif", $stime),UVM_NONE)
            $set_gate_level_monitoring("rtl_on");
            `uvm_info("NVDLA_TB_TOP",$psprintf("(%0d) NVDLA_SAIF: setting toggle region for saif",$stime),UVM_NONE)
            $set_toggle_region("DLA_DUT");
    
            if(saif_start_trans!= 0) begin
                `uvm_info("NVDLA_TB_TOP",$psprintf("(%0d) NVDLA_SAIF: saif_start_trans enabled in file %0s", $stime, saif_name),UVM_NONE)
                wait (total_trans_count >= saif_start_trans);
                `uvm_info("NVDLA_TB_TOP",$psprintf("(%0d) NVDLA_SAIF: start saif, trans_count == %d", $stime, total_trans_count),UVM_NONE)
            end //

            #10 $toggle_start;
            `uvm_info("NVDLA_TB_TOP",$psprintf("(%0d) NVDLA_SAIF: toggle start for saif", $stime),UVM_NONE)

            if (saif_end_trans!=0) begin
             `uvm_info("NVDLA_TB_TOP",$psprintf("(%0d) NVDLA_SAIF: saif_end_trans enabled in file %0s", $stime, saif_name),UVM_NONE)
              wait (total_trans_count >= saif_end_trans);
              `uvm_info("NVDLA_TB_TOP",$psprintf("(%0d) NVDLA_SAIF: end saif, trans_count == %d", $stime, total_trans_count),UVM_NONE)
            end
            else begin
              uvm_event sim_done_evt;
              if(!glb_evts.exists("sim_done_evt")) begin
                  `uvm_fatal("NVDLA_TB_TOP","Fail to get sim_done_evt from global_event_pool")
              end
              sim_done_evt = glb_evts.get("sim_done_evt");
              sim_done_evt.wait_on();
              `uvm_info("NVDLA_TB_TOP",$psprintf("(%0d) NVDLA_SAIF: observe sim_done_evt", $stime),UVM_NONE)
            end
            $toggle_stop;
            #10;

            if ($test$plusargs("dump_top_saif")) begin
              string full_saif_filename;
              full_saif_filename = "top0.snps.saif";
              `uvm_info("NVDLA_TB_TOP",$psprintf("(%0d) NVDLA_SAIF : creating toggle report for nvdla_top (%0s) )", $stime, full_saif_filename ),UVM_NONE)
              $toggle_report(full_saif_filename, 1.0e-9, "nvdla_top");
            end
        end 
        else begin
            `uvm_info("NVDLA_TB_TOP","No SAIF dump for simulation",UVM_NONE)
        end// dump_saif
    end
`endif //NVDLA_SAIF_ENABLE
    // }@
endmodule : nvdla_tb_top


`endif // _NVDLA_TB_TOP_SV_

// Local Variables:
// verilog-library-flags:("-y ../../")
// End:
