`ifndef _CC_INTERFACE_SV_
`define _CC_INTERFACE_SV_

`include "cc_defines.sv"

//-------------------------------------------------------------------------------------
//
// INTERFACE: cc_interface
//
//-------------------------------------------------------------------------------------

interface cc_interface #(int DW = 1, int MW =1) (input clk, input resetn);

    bit     cc_interface_checker_disable = 0;

    //----------------------------------
    // interface signals
    //----------------------------------

    logic                         pvld;
    logic [`CC_PD_WIDTH-1:0]      pd;
    logic [MW-1:0]                mask; 
    //----------------------------------------------
    // Only for CMAC2CACC data compare mask
    logic                         conv_mode;
    logic [1:0]                   proc_precision;
    //----------------------------------------------
    // For CMAC2CACC
    logic [7:0]                   mode;
    //----------------------------------------------
    // for my $i (0 .. MW-1) {
    //     print logic [DW-1:0] data$i;
    // }
    logic [DW-1:0]                data[MW];
    logic [`CC_SEL_WIDTH-1:0]     wt_sel;

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
        
        input    pvld;
        input    pd;
        input    mask; 
        input    conv_mode;
        input    proc_precision;
        input    mode;
        // for my $i (0 .. MW-1) {
        //     print logic [DW-1:0] data$i;
        // }
        input    data;
        input    wt_sel;

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
        if($test$plusargs("cc_interface_disable_checker")) begin
            cc_interface_checker_disable = 1;
            $display("cc_interface: Disable NVDLA CC interface checkers");
        end
    end

    /* FIXME comment out for parametrization not done
    /// Property checking mask no "X" & "Z" when valid
    property mask_2state_p;
        @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
        pvld |-> !$isunknown(mask);
    endproperty
    mask_2state : assert property (mask_2state_p);

    // /// Property checking pd no "X" & "Z" when valid
    // property pd_2state_p;
    //     @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
    //     pvld |-> !$isunknown(pd);
    // endproperty
    // pd_2state : assert property (pd_2state_p);

    // /// Property checking wt_sel no "X" & "Z" when valid
    // property wt_sel_2state_p;
    //     @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
    //     pvld |-> !$isunknown(wt_sel);
    // endproperty
    // wt_sel_2state : assert property (wt_sel_2state_p);

    if(MW == 8) begin // CMAC => CACC
        /// Property checking data0 no "X" & "Z" when valid
        property data0_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[0]) |-> ( ((conv_mode==0 && proc_precision!=1) |-> !$isunknown(data0 & {44{1'b1}})) or 
                                    ((conv_mode==0 && proc_precision==1) |-> !$isunknown(data0 & {38{1'b1}})) or
                                    ((conv_mode==1 && proc_precision==1) |-> !$isunknown(data0 & {{6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}})) );
        endproperty
        data0_2state : assert property (data0_2state_p);

        /// Property checking data1 no "X" & "Z" when valid
        property data1_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[0]) |-> ( ((conv_mode==0 && proc_precision!=1) |-> !$isunknown(data1 & {44{1'b1}})) or 
                                    ((conv_mode==0 && proc_precision==1) |-> !$isunknown(data1 & {38{1'b1}})) or
                                    ((conv_mode==1 && proc_precision==1) |-> !$isunknown(data1 & {{6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}})) );
        endproperty
        data1_2state : assert property (data1_2state_p);

        /// Property checking data2 no "X" & "Z" when valid
        property data2_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[0]) |-> ( ((conv_mode==0 && proc_precision!=1) |-> !$isunknown(data2 & {44{1'b1}})) or 
                                    ((conv_mode==0 && proc_precision==1) |-> !$isunknown(data2 & {38{1'b1}})) or
                                    ((conv_mode==1 && proc_precision==1) |-> !$isunknown(data2 & {{6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}})) );
        endproperty
        data2_2state : assert property (data2_2state_p);

        /// Property checking data3 no "X" & "Z" when valid
        property data3_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[0]) |-> ( ((conv_mode==0 && proc_precision!=1) |-> !$isunknown(data3 & {44{1'b1}})) or 
                                    ((conv_mode==0 && proc_precision==1) |-> !$isunknown(data3 & {38{1'b1}})) or
                                    ((conv_mode==1 && proc_precision==1) |-> !$isunknown(data3 & {{6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}})) );
        endproperty
        data3_2state : assert property (data3_2state_p);

        /// Property checking data4 no "X" & "Z" when valid
        property data4_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[0]) |-> ( ((conv_mode==0 && proc_precision!=1) |-> !$isunknown(data4 & {44{1'b1}})) or 
                                    ((conv_mode==0 && proc_precision==1) |-> !$isunknown(data4 & {38{1'b1}})) or
                                    ((conv_mode==1 && proc_precision==1) |-> !$isunknown(data4 & {{6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}})) );
        endproperty
        data4_2state : assert property (data4_2state_p);

        /// Property checking data5 no "X" & "Z" when valid
        property data5_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[0]) |-> ( ((conv_mode==0 && proc_precision!=1) |-> !$isunknown(data5 & {44{1'b1}})) or 
                                    ((conv_mode==0 && proc_precision==1) |-> !$isunknown(data5 & {38{1'b1}})) or
                                    ((conv_mode==1 && proc_precision==1) |-> !$isunknown(data5 & {{6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}})) );
        endproperty
        data5_2state : assert property (data5_2state_p);

        /// Property checking data6 no "X" & "Z" when valid
        property data6_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[0]) |-> ( ((conv_mode==0 && proc_precision!=1) |-> !$isunknown(data6 & {44{1'b1}})) or 
                                    ((conv_mode==0 && proc_precision==1) |-> !$isunknown(data6 & {38{1'b1}})) or
                                    ((conv_mode==1 && proc_precision==1) |-> !$isunknown(data6 & {{6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}})) );
        endproperty
        data6_2state : assert property (data6_2state_p);

        /// Property checking data7 no "X" & "Z" when valid
        property data7_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[0]) |-> ( ((conv_mode==0 && proc_precision!=1) |-> !$isunknown(data7 & {44{1'b1}})) or 
                                    ((conv_mode==0 && proc_precision==1) |-> !$isunknown(data7 & {38{1'b1}})) or
                                    ((conv_mode==1 && proc_precision==1) |-> !$isunknown(data7 & {{6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}, {6{1'b0}}, {38{1'b1}}})) );
        endproperty
        data7_2state : assert property (data7_2state_p);
    end
    else if(MW == 128) begin
        /// Property checking data0 no "X" & "Z" when valid
        property data0_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[0]) |-> !$isunknown(data0);
        endproperty
        data0_2state : assert property (data0_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data1_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[1]) |-> !$isunknown(data1);
        endproperty
        data1_2state : assert property (data1_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data2_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[2]) |-> !$isunknown(data2);
        endproperty
        data2_2state : assert property (data2_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data3_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[3]) |-> !$isunknown(data3);
        endproperty
        data3_2state : assert property (data3_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data4_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[4]) |-> !$isunknown(data4);
        endproperty
        data4_2state : assert property (data4_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data5_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[5]) |-> !$isunknown(data5);
        endproperty
        data5_2state : assert property (data5_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data6_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[6]) |-> !$isunknown(data6);
        endproperty
        data6_2state : assert property (data6_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data7_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[7]) |-> !$isunknown(data7);
        endproperty
        data7_2state : assert property (data7_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data8_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[8]) |-> !$isunknown(data8);
        endproperty
        data8_2state : assert property (data8_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data9_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[9]) |-> !$isunknown(data9);
        endproperty
        data9_2state : assert property (data9_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data10_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[10]) |-> !$isunknown(data10);
        endproperty
        data10_2state : assert property (data10_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data11_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[11]) |-> !$isunknown(data11);
        endproperty
        data11_2state : assert property (data11_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data12_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[12]) |-> !$isunknown(data12);
        endproperty
        data12_2state : assert property (data12_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data13_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[13]) |-> !$isunknown(data13);
        endproperty
        data13_2state : assert property (data13_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data14_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[14]) |-> !$isunknown(data14);
        endproperty
        data14_2state : assert property (data14_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data15_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[15]) |-> !$isunknown(data15);
        endproperty
        data15_2state : assert property (data15_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data16_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[16]) |-> !$isunknown(data16);
        endproperty
        data16_2state : assert property (data16_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data17_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[17]) |-> !$isunknown(data17);
        endproperty
        data17_2state : assert property (data17_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data18_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[18]) |-> !$isunknown(data18);
        endproperty
        data18_2state : assert property (data18_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data19_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[19]) |-> !$isunknown(data19);
        endproperty
        data19_2state : assert property (data19_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data20_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[20]) |-> !$isunknown(data20);
        endproperty
        data20_2state : assert property (data20_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data21_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[21]) |-> !$isunknown(data21);
        endproperty
        data21_2state : assert property (data21_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data22_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[22]) |-> !$isunknown(data22);
        endproperty
        data22_2state : assert property (data22_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data23_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[23]) |-> !$isunknown(data23);
        endproperty
        data23_2state : assert property (data23_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data24_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[24]) |-> !$isunknown(data24);
        endproperty
        data24_2state : assert property (data24_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data25_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[25]) |-> !$isunknown(data25);
        endproperty
        data25_2state : assert property (data25_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data26_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[26]) |-> !$isunknown(data26);
        endproperty
        data26_2state : assert property (data26_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data27_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[27]) |-> !$isunknown(data27);
        endproperty
        data27_2state : assert property (data27_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data28_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[28]) |-> !$isunknown(data28);
        endproperty
        data28_2state : assert property (data28_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data29_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[29]) |-> !$isunknown(data29);
        endproperty
        data29_2state : assert property (data29_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data30_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[30]) |-> !$isunknown(data30);
        endproperty
        data30_2state : assert property (data30_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data31_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[31]) |-> !$isunknown(data31);
        endproperty
        data31_2state : assert property (data31_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data32_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[32]) |-> !$isunknown(data32);
        endproperty
        data32_2state : assert property (data32_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data33_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[33]) |-> !$isunknown(data33);
        endproperty
        data33_2state : assert property (data33_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data34_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[34]) |-> !$isunknown(data34);
        endproperty
        data34_2state : assert property (data34_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data35_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[35]) |-> !$isunknown(data35);
        endproperty
        data35_2state : assert property (data35_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data36_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[36]) |-> !$isunknown(data36);
        endproperty
        data36_2state : assert property (data36_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data37_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[37]) |-> !$isunknown(data37);
        endproperty
        data37_2state : assert property (data37_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data38_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[38]) |-> !$isunknown(data38);
        endproperty
        data38_2state : assert property (data38_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data39_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[39]) |-> !$isunknown(data39);
        endproperty
        data39_2state : assert property (data39_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data40_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[40]) |-> !$isunknown(data40);
        endproperty
        data40_2state : assert property (data40_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data41_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[41]) |-> !$isunknown(data41);
        endproperty
        data41_2state : assert property (data41_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data42_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[42]) |-> !$isunknown(data42);
        endproperty
        data42_2state : assert property (data42_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data43_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[43]) |-> !$isunknown(data43);
        endproperty
        data43_2state : assert property (data43_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data44_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[44]) |-> !$isunknown(data44);
        endproperty
        data44_2state : assert property (data44_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data45_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[45]) |-> !$isunknown(data45);
        endproperty
        data45_2state : assert property (data45_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data46_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[46]) |-> !$isunknown(data46);
        endproperty
        data46_2state : assert property (data46_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data47_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[47]) |-> !$isunknown(data47);
        endproperty
        data47_2state : assert property (data47_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data48_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[48]) |-> !$isunknown(data48);
        endproperty
        data48_2state : assert property (data48_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data49_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[49]) |-> !$isunknown(data49);
        endproperty
        data49_2state : assert property (data49_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data50_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[50]) |-> !$isunknown(data50);
        endproperty
        data50_2state : assert property (data50_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data51_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[51]) |-> !$isunknown(data51);
        endproperty
        data51_2state : assert property (data51_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data52_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[52]) |-> !$isunknown(data52);
        endproperty
        data52_2state : assert property (data52_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data53_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[53]) |-> !$isunknown(data53);
        endproperty
        data53_2state : assert property (data53_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data54_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[54]) |-> !$isunknown(data54);
        endproperty
        data54_2state : assert property (data54_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data55_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[55]) |-> !$isunknown(data55);
        endproperty
        data55_2state : assert property (data55_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data56_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[56]) |-> !$isunknown(data56);
        endproperty
        data56_2state : assert property (data56_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data57_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[57]) |-> !$isunknown(data57);
        endproperty
        data57_2state : assert property (data57_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data58_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[58]) |-> !$isunknown(data58);
        endproperty
        data58_2state : assert property (data58_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data59_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[59]) |-> !$isunknown(data59);
        endproperty
        data59_2state : assert property (data59_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data60_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[60]) |-> !$isunknown(data60);
        endproperty
        data60_2state : assert property (data60_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data61_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[61]) |-> !$isunknown(data61);
        endproperty
        data61_2state : assert property (data61_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data62_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[62]) |-> !$isunknown(data62);
        endproperty
        data62_2state : assert property (data62_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data63_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[63]) |-> !$isunknown(data63);
        endproperty
        data63_2state : assert property (data63_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data64_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[64]) |-> !$isunknown(data64);
        endproperty
        data64_2state : assert property (data64_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data65_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[65]) |-> !$isunknown(data65);
        endproperty
        data65_2state : assert property (data65_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data66_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[66]) |-> !$isunknown(data66);
        endproperty
        data66_2state : assert property (data66_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data67_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[67]) |-> !$isunknown(data67);
        endproperty
        data67_2state : assert property (data67_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data68_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[68]) |-> !$isunknown(data68);
        endproperty
        data68_2state : assert property (data68_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data69_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[69]) |-> !$isunknown(data69);
        endproperty
        data69_2state : assert property (data69_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data70_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[70]) |-> !$isunknown(data70);
        endproperty
        data70_2state : assert property (data70_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data71_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[71]) |-> !$isunknown(data71);
        endproperty
        data71_2state : assert property (data71_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data72_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[72]) |-> !$isunknown(data72);
        endproperty
        data72_2state : assert property (data72_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data73_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[73]) |-> !$isunknown(data73);
        endproperty
        data73_2state : assert property (data73_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data74_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[74]) |-> !$isunknown(data74);
        endproperty
        data74_2state : assert property (data74_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data75_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[75]) |-> !$isunknown(data75);
        endproperty
        data75_2state : assert property (data75_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data76_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[76]) |-> !$isunknown(data76);
        endproperty
        data76_2state : assert property (data76_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data77_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[77]) |-> !$isunknown(data77);
        endproperty
        data77_2state : assert property (data77_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data78_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[78]) |-> !$isunknown(data78);
        endproperty
        data78_2state : assert property (data78_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data79_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[79]) |-> !$isunknown(data79);
        endproperty
        data79_2state : assert property (data79_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data80_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[80]) |-> !$isunknown(data80);
        endproperty
        data80_2state : assert property (data80_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data81_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[81]) |-> !$isunknown(data81);
        endproperty
        data81_2state : assert property (data81_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data82_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[82]) |-> !$isunknown(data82);
        endproperty
        data82_2state : assert property (data82_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data83_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[83]) |-> !$isunknown(data83);
        endproperty
        data83_2state : assert property (data83_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data84_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[84]) |-> !$isunknown(data84);
        endproperty
        data84_2state : assert property (data84_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data85_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[85]) |-> !$isunknown(data85);
        endproperty
        data85_2state : assert property (data85_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data86_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[86]) |-> !$isunknown(data86);
        endproperty
        data86_2state : assert property (data86_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data87_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[87]) |-> !$isunknown(data87);
        endproperty
        data87_2state : assert property (data87_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data88_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[88]) |-> !$isunknown(data88);
        endproperty
        data88_2state : assert property (data88_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data89_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[89]) |-> !$isunknown(data89);
        endproperty
        data89_2state : assert property (data89_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data90_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[90]) |-> !$isunknown(data90);
        endproperty
        data90_2state : assert property (data90_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data91_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[91]) |-> !$isunknown(data91);
        endproperty
        data91_2state : assert property (data91_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data92_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[92]) |-> !$isunknown(data92);
        endproperty
        data92_2state : assert property (data92_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data93_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[93]) |-> !$isunknown(data93);
        endproperty
        data93_2state : assert property (data93_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data94_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[94]) |-> !$isunknown(data94);
        endproperty
        data94_2state : assert property (data94_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data95_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[95]) |-> !$isunknown(data95);
        endproperty
        data95_2state : assert property (data95_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data96_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[96]) |-> !$isunknown(data96);
        endproperty
        data96_2state : assert property (data96_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data97_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[97]) |-> !$isunknown(data97);
        endproperty
        data97_2state : assert property (data97_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data98_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[98]) |-> !$isunknown(data98);
        endproperty
        data98_2state : assert property (data98_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data99_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[99]) |-> !$isunknown(data99);
        endproperty
        data99_2state : assert property (data99_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data100_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[100]) |-> !$isunknown(data100);
        endproperty
        data100_2state : assert property (data100_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data101_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[101]) |-> !$isunknown(data101);
        endproperty
        data101_2state : assert property (data101_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data102_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[102]) |-> !$isunknown(data102);
        endproperty
        data102_2state : assert property (data102_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data103_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[103]) |-> !$isunknown(data103);
        endproperty
        data103_2state : assert property (data103_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data104_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[104]) |-> !$isunknown(data104);
        endproperty
        data104_2state : assert property (data104_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data105_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[105]) |-> !$isunknown(data105);
        endproperty
        data105_2state : assert property (data105_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data106_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[106]) |-> !$isunknown(data106);
        endproperty
        data106_2state : assert property (data106_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data107_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[107]) |-> !$isunknown(data107);
        endproperty
        data107_2state : assert property (data107_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data108_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[108]) |-> !$isunknown(data108);
        endproperty
        data108_2state : assert property (data108_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data109_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[109]) |-> !$isunknown(data109);
        endproperty
        data109_2state : assert property (data109_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data110_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[110]) |-> !$isunknown(data110);
        endproperty
        data110_2state : assert property (data110_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data111_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[111]) |-> !$isunknown(data111);
        endproperty
        data111_2state : assert property (data111_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data112_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[112]) |-> !$isunknown(data112);
        endproperty
        data112_2state : assert property (data112_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data113_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[113]) |-> !$isunknown(data113);
        endproperty
        data113_2state : assert property (data113_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data114_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[114]) |-> !$isunknown(data114);
        endproperty
        data114_2state : assert property (data114_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data115_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[115]) |-> !$isunknown(data115);
        endproperty
        data115_2state : assert property (data115_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data116_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[116]) |-> !$isunknown(data116);
        endproperty
        data116_2state : assert property (data116_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data117_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[117]) |-> !$isunknown(data117);
        endproperty
        data117_2state : assert property (data117_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data118_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[118]) |-> !$isunknown(data118);
        endproperty
        data118_2state : assert property (data118_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data119_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[119]) |-> !$isunknown(data119);
        endproperty
        data119_2state : assert property (data119_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data120_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[120]) |-> !$isunknown(data120);
        endproperty
        data120_2state : assert property (data120_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data121_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[121]) |-> !$isunknown(data121);
        endproperty
        data121_2state : assert property (data121_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data122_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[122]) |-> !$isunknown(data122);
        endproperty
        data122_2state : assert property (data122_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data123_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[123]) |-> !$isunknown(data123);
        endproperty
        data123_2state : assert property (data123_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data124_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[124]) |-> !$isunknown(data124);
        endproperty
        data124_2state : assert property (data124_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data125_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[125]) |-> !$isunknown(data125);
        endproperty
        data125_2state : assert property (data125_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data126_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[126]) |-> !$isunknown(data126);
        endproperty
        data126_2state : assert property (data126_2state_p);
        
        /// Property checking data0 no "X" & "Z" when valid
        property data127_2state_p;
            @(posedge clk) disable iff ((!resetn) || cc_interface_checker_disable)
            (pvld && mask[127]) |-> !$isunknown(data127);
        endproperty
        data127_2state : assert property (data127_2state_p);
    end
    */

endinterface: cc_interface


`endif //  _CC_INTERFACE_SV_
