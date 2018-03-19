`ifndef _DP_INTERFACE_SV_
`define _DP_INTERFACE_SV_

`include "dp_defines.sv"

//-------------------------------------------------------------------------------------
//
// INTERFACE: dp_interface
//
//-------------------------------------------------------------------------------------

// Parameterized Interface: PW for Pad Width
interface dp_interface#(int PW = 1) (input clk, input resetn);
   
    //----------------------------------
    // interface signals
    //----------------------------------

    logic          valid;
    logic          ready;
    logic [PW-1:0] pd;

    //-------------------------------------------------
    // clocking block that defines the master interface 
    //-------------------------------------------------
    clocking mclk @(posedge clk);
        default input #1step output #0;

    endclocking : mclk

    //------------------------------------------------
    // clocking block that defines the slave interface
    //------------------------------------------------
    clocking sclk @(posedge clk);
        default input #1step output #0;

    endclocking : sclk

 
    //--------------------------------------------------
    // clocking block that defines the monitor interface
    //--------------------------------------------------
    clocking monclk @(posedge clk);
        default input #1step output #0;
        
        input   valid;
        input   ready;
        input   pd;

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

    /* nv_TODO */ // Add assertions
    /// Property checking pd no "X" & "Z" when valid
    /*FIXME, re-enable unknown state check after regression is stable
    property pd_2state_p;
        @(posedge clk) disable iff (!resetn)
        (valid && ready) |-> !$isunknown(pd);
    endproperty
    pd_2state : assert property (pd_2state_p);
    */

endinterface: dp_interface


`endif //  _DP_INTERFACE_SV_
