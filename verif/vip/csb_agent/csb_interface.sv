`ifndef _CSB_INTERFACE_SV_
`define _CSB_INTERFACE_SV_

`include "csb_defines.svh"

//-------------------------------------------------------------------------------------
//
// INTERFACE: csb_interface
//
// XXX
//-------------------------------------------------------------------------------------

interface csb_interface(input clk, input rst_n);

    //---------------------------------------------------------INTERFACE SIGNALS
    // @{

    wire                       pvld;     
    wire                       prdy;     
    wire [`CSB_ADDR_WIDTH-1:0] addr;
    wire                       write;    
    wire [`CSB_DATA_WIDTH-1:0] wdata;
    wire                       nposted;  
    wire                       wr_complete;
    wire                       rvld;    
    wire [`CSB_DATA_WIDTH-1:0] rdata;

    // }@

    //------------------------------------------------------------CLOCKING BLOCK
    // @{
    // clocking block for master interface
    clocking mcb @(posedge clk);
        //default input #1step output #0;

        output pvld;     
        input  prdy;     
        output addr;
        output write;    
        output wdata;
        output nposted;  
        input  wr_complete;
        input  rvld;    
        input  rdata;
    endclocking : mcb

    // clocking block for monitor interface
    clocking moncb @(posedge clk);
        //default input #1step output #0;

        input pvld;     
        input prdy;     
        input addr;
        input write;    
        input wdata;
        input nposted;  
        input wr_complete;
        input rvld;    
        input rdata;
    endclocking : moncb
    // }@

    // -----------------------------------------------------------------Modports
    // @{
    modport Master (clocking mcb,   input rst_n, input clk);
    modport Monitor(clocking moncb, input rst_n, input clk);
    // }@


    // -----------------------------------------------------------CHECK ASSRTION
    // @{

    // Reuse from VIP

    // }@

endinterface: csb_interface

`endif // _CSB_INTERFACE_SV_
