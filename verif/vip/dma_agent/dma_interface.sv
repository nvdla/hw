`ifndef _DMA_INTERFACE_SV_
`define _DMA_INTERFACE_SV_

`include "dma_defines.sv"

//-------------------------------------------------------------------------------------
//
// INTERFACE: dma interface
//
//-------------------------------------------------------------------------------------

interface dma_interface (input clk, input resetn);
   
    //----------------------------------
    // interface signals
    //----------------------------------

    // read
    logic                            rd_req_valid;
    logic                            rd_req_ready;
    logic [`DMA_RD_REQ_PD_WIDTH-1:0] rd_req_pd;
    logic                            rd_rsp_valid;
    logic                            rd_rsp_ready;
    logic [`DMA_RD_RSP_PD_WIDTH-1:0] rd_rsp_pd;
    
    // write
    logic                            wr_req_valid;
    logic                            wr_req_ready;
    logic [`DMA_WR_REQ_PD_WIDTH-1:0] wr_req_pd;
    logic                            wr_rsp_complete;

    // only used for cdma_wt to identify request source: WT/WMB/WGS
    // 2'b00 : WEIGHT DATA
    // 2'b01 : WMB DATA
    // 2'b10 : WGS DATA
    logic [1:0]  wt_dma_id;

    bit          dma_interface_checker_disable = 0;

    //-------------------------------------------------
    // clocking block that defines the master interface 
    //-------------------------------------------------
    clocking mclk @(posedge clk);
        default input #1step output #0;

        output   rd_req_valid;
        input    rd_req_ready;
        output   rd_req_pd;
        output   wt_dma_id;
        input    rd_rsp_valid;
        output   rd_rsp_ready;
        input    rd_rsp_pd;
        output   wr_req_valid;
        input    wr_req_ready;
        output   wr_req_pd;
        input    wr_rsp_complete;

    endclocking : mclk

    //------------------------------------------------
    // clocking block that defines the slave interface
    //------------------------------------------------
    clocking sclk @(posedge clk);
        default input #1step output #0;

        input    rd_req_valid;
        output   rd_req_ready;
        input    rd_req_pd;
        input    wt_dma_id;
        output   rd_rsp_valid;
        input    rd_rsp_ready;
        output   rd_rsp_pd;
        input    wr_req_valid;
        output   wr_req_ready;
        input    wr_req_pd;
        output   wr_rsp_complete;

    endclocking : sclk

 
    //--------------------------------------------------
    // clocking block that defines the monitor interface
    //--------------------------------------------------
    clocking monclk @(posedge clk);
        default input #1step output #0;
        
        input   rd_req_valid;
        input   rd_req_ready;
        input   rd_req_pd;
        input   wt_dma_id;
        input   rd_rsp_valid;
        input   rd_rsp_ready;
        input   rd_rsp_pd;
        input   wr_req_valid;
        input   wr_req_ready;
        input   wr_req_pd;
        input   wr_rsp_complete;

    endclocking : monclk

    //------------------------------------------
    // Modports used to connect signals
    //------------------------------------------
    modport Master (
            clocking mclk,
            input resetn,
            input clk
            );

    modport Monitor (
            clocking monclk,
            input resetn,
            input clk
            );

    modport Slave (
            clocking sclk,
            input resetn,
            input clk
            );

    initial begin
        if($test$plusargs("dma_interface_disable_checker")) begin
            dma_interface_checker_disable = 1;
            $display("dma_interface: Disable DMA interface checkers");
        end
    end

    /// Property checking rd_req_pd no "X" & "Z" when valid
    property rd_req_pd_2state_p;
        @(posedge clk) disable iff ((!resetn) || dma_interface_checker_disable)
        (rd_req_valid && rd_req_ready) |-> !$isunknown(rd_req_pd[`DMA_RD_REQ_PD_WIDTH-1:0]);
    endproperty
    rd_req_pd_2state : assert property (rd_req_pd_2state_p);

    /// Property checking rd_rsp_pd no "X" & "Z" when valid
    property rd_rsp_pd_2state_p;
        @(posedge clk) disable iff ((!resetn) || dma_interface_checker_disable)
        (rd_rsp_valid && rd_rsp_ready) |-> (((`DMA_DATA_MASK_WIDTH==1) |-> !$isunknown(rd_rsp_pd[`DMA_DATA_WIDTH-1:0])) or ((`DMA_DATA_MASK_WIDTH==2)&&(rd_rsp_pd[`DMA_RD_RSP_PD_WIDTH-1:`DMA_RD_RSP_PD_WIDTH-2]==2'b11) |-> !$isunknown(rd_rsp_pd[`DMA_RD_RSP_PD_WIDTH-3:0])) or ((`DMA_DATA_MASK_WIDTH==2)&&(rd_rsp_pd[`DMA_RD_RSP_PD_WIDTH-1:`DMA_RD_RSP_PD_WIDTH-2]==2'b01) |-> !$isunknown(rd_rsp_pd[`DMA_DATA_WIDTH-1:0])));
    endproperty
    rd_rsp_pd_2state : assert property (rd_rsp_pd_2state_p);

    /// Property checking wr_req_pd no "X" & "Z" when valid
    property wr_req_pd_2state_p;
        @(posedge clk) disable iff ((!resetn) || dma_interface_checker_disable)
        (wr_req_valid && wr_req_ready) |-> ((wr_req_pd[`DMA_WR_REQ_PD_WIDTH-1] |-> !$isunknown(wr_req_pd)) or (!wr_req_pd[`DMA_WR_REQ_PD_WIDTH-1] |-> !$isunknown(wr_req_pd[`DMA_ADDR_WIDTH+`DMA_WR_SIZE_WIDTH-1:0])));
    endproperty
    wr_req_pd_2state : assert property (rd_req_pd_2state_p);

endinterface: dma_interface


`endif //  _DMA_INTERFACE_SV_
