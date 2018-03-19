// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: RAMDP_64X18_GL_M2_E2.v

`timescale 10ps/1ps
`celldefine
module RAMDP_64X18_GL_M2_E2 (CLK_R, CLK_W, RE, WE
	, RADR_5, RADR_4, RADR_3, RADR_2, RADR_1, RADR_0
    , WADR_5, WADR_4, WADR_3, WADR_2, WADR_1, WADR_0
	, WD_17, WD_16, WD_15, WD_14, WD_13, WD_12, WD_11, WD_10, WD_9, WD_8, WD_7, WD_6, WD_5, WD_4, WD_3, WD_2, WD_1, WD_0
	, RD_17, RD_16, RD_15, RD_14, RD_13, RD_12, RD_11, RD_10, RD_9, RD_8, RD_7, RD_6, RD_5, RD_4, RD_3, RD_2, RD_1, RD_0
    
    , IDDQ
	, SVOP_1, SVOP_0
    , SLEEP_EN_7, SLEEP_EN_6, SLEEP_EN_5, SLEEP_EN_4, SLEEP_EN_3, SLEEP_EN_2, SLEEP_EN_1, SLEEP_EN_0, RET_EN
    
);

// nvProps NoBus SLEEP_EN_

`ifndef RAM_INTERFACE
`ifndef EMULATION
`ifndef SYNTHESIS
// Physical ram size defined as localparam
localparam phy_rows = 32;
localparam phy_cols = 36;
localparam phy_rcols_pos = 36'b0;
`endif //ndef SYNTHESIS
`endif //EMULATION
`endif //ndef RAM_INTERFACE

input CLK_R, CLK_W, RE, WE
	, RADR_5, RADR_4, RADR_3, RADR_2, RADR_1, RADR_0
    , WADR_5, WADR_4, WADR_3, WADR_2, WADR_1, WADR_0
	, WD_17, WD_16, WD_15, WD_14, WD_13, WD_12, WD_11, WD_10, WD_9, WD_8, WD_7, WD_6, WD_5, WD_4, WD_3, WD_2, WD_1, WD_0
    
    , SLEEP_EN_7, SLEEP_EN_6, SLEEP_EN_5, SLEEP_EN_4, SLEEP_EN_3, SLEEP_EN_2, SLEEP_EN_1, SLEEP_EN_0, RET_EN
    , IDDQ
    
	, SVOP_1, SVOP_0;
output RD_17, RD_16, RD_15, RD_14, RD_13, RD_12, RD_11, RD_10, RD_9, RD_8, RD_7, RD_6, RD_5, RD_4, RD_3, RD_2, RD_1, RD_0;

	
`ifndef RAM_INTERFACE
	//assemble & rename wires
	wire [5:0] RA = {RADR_5, RADR_4, RADR_3, RADR_2, RADR_1, RADR_0};
	wire [5:0] WA = {WADR_5, WADR_4, WADR_3, WADR_2, WADR_1, WADR_0};
	wire [17:0] WD = {WD_17, WD_16, WD_15, WD_14, WD_13, WD_12, WD_11, WD_10, WD_9, WD_8, WD_7, WD_6, WD_5, WD_4, WD_3, WD_2, WD_1, WD_0};

	wire [17:0] RD;
	assign {RD_17, RD_16, RD_15, RD_14, RD_13, RD_12, RD_11, RD_10, RD_9, RD_8, RD_7, RD_6, RD_5, RD_4, RD_3, RD_2, RD_1, RD_0} = RD;
	wire [1:0] SVOP = {SVOP_1, SVOP_0};
    wire [7:0] SLEEP_EN = {SLEEP_EN_7, SLEEP_EN_6, SLEEP_EN_5, SLEEP_EN_4, SLEEP_EN_3, SLEEP_EN_2, SLEEP_EN_1, SLEEP_EN_0};
    

`ifndef EMULATION
`ifndef SYNTHESIS

    //State point clobering signals:
    wire check_x = (SVOP_0 ^ SVOP_1);
    wire clobber_x;
    assign clobber_x = ((check_x === 1'bx) || (check_x === 1'bz)) ? 1'b1 : 1'b0;
    wire clobber_array = ((|SLEEP_EN) & ~RET_EN) | clobber_x;
    wire clobber_flops = (|SLEEP_EN) | clobber_x;
    integer i;
    always  @(clobber_array) begin
      if (clobber_array) begin
    		for (i=0; i<64; i=i+1) begin
    		    ITOP.io.array[i] <= 18'bx;
    		end
      end
    end

//VCS coverage off     
    always  @(clobber_flops) begin
        if (clobber_flops) begin
        ITOP.we_lat <= 1'bx;
        ITOP.wa_lat <= 6'bx;
        ITOP.wd_lat <= 18'bx;
        
        ITOP.re_lat <= 1'bx;
        ITOP.ra_lat <= 6'bx;
        ITOP.io.r0_dout_tmp <= 18'b0;
        end
    end
//VCS coverage on    

//VCS coverage off
`ifdef NV_RAM_ASSERT
    //first reset signal for nv_assert_module:
    reg sim_reset;                                                     
    initial begin: init_sim_reset
        sim_reset = 0;  
        #6 sim_reset = 1;
    end

    reg rst_clk;                                                     
    initial begin: init_rst_clk
        rst_clk = 0; 
        #2 rst_clk = 1; 
        #4 rst_clk = 0;  
    end

    //internal weclk|reclk gating signal:
    wire weclk_gating = ITOP.we_lat & ~IDDQ;
    wire reclk_gating = ITOP.re_lat & ~IDDQ;

  //Assertion checks for power sequence of G-option RAMDP:

    //weclk_gating after 2 clk
    reg weclk_gating_1p, weclk_gating_2p;
    always @(posedge CLK_W) begin
        weclk_gating_1p <= weclk_gating;
        weclk_gating_2p <= weclk_gating_1p;
    end

    //reclk_gating after 2 clk
    reg reclk_gating_1p, reclk_gating_2p;
    always @(posedge CLK_R) begin
        reclk_gating_1p <= reclk_gating;
        reclk_gating_2p <= reclk_gating_1p;
    end
    
    //RET_EN off after 2 CLK_W
    reg ret_en_w_1p, ret_en_w_2p;
    always @(posedge CLK_W or posedge RET_EN) begin
        if(RET_EN) 
            begin
                ret_en_w_1p <= 1'b1;
                ret_en_w_2p <= 1'b1;
            end
        else
            begin
                ret_en_w_1p <= RET_EN;
                ret_en_w_2p <= ret_en_w_1p;
            end
    end

    //RET_EN off after 2 CLK_R
    reg ret_en_r_1p, ret_en_r_2p;
    always @(posedge CLK_R or posedge RET_EN) begin
        if(RET_EN) 
            begin
                ret_en_r_1p <= 1'b1;
                ret_en_r_2p <= 1'b1;
            end
        else
            begin
                ret_en_r_1p <= RET_EN;
                ret_en_r_2p <= ret_en_r_1p;
            end
    end

    wire sleep_en_or = (|SLEEP_EN) ;
    //SLEEP_EN off after 2 CLK_W
    reg sleep_en_off_w_1p, sleep_en_off_w_2p;
    always @(posedge CLK_W or posedge sleep_en_or) begin
        if(sleep_en_or)
            begin
                sleep_en_off_w_1p <= 1'b1;
                sleep_en_off_w_2p <= 1'b1;
            end
        else
            begin
                sleep_en_off_w_1p <= sleep_en_or;
                sleep_en_off_w_2p <= sleep_en_off_w_1p;
            end            
    end

    //SLEEP_EN off after 2 CLK_R
    reg sleep_en_off_r_1p, sleep_en_off_r_2p;
    always @(posedge CLK_R or posedge sleep_en_or) begin
        if(sleep_en_or)
            begin
                sleep_en_off_r_1p <= 1'b1;
                sleep_en_off_r_2p <= 1'b1;
            end
        else
            begin
                sleep_en_off_r_1p <= |sleep_en_or;
                sleep_en_off_r_2p <= sleep_en_off_r_1p;
            end            
    end    


  //#1 From function mode to retention mode:
    
    //Power-S1.1:illegal assert RET_EN after asserting SLEEP_EN 
    wire disable_power_assertion_S1P1 = $test$plusargs("disable_power_assertions_globally") | $test$plusargs("disable_power_assertion_assert_RET_EN_after_SLEEP_EN_on_when_function2retention");
    nv_assert_never #(0,0, "Power-S1.1:illegal assert RET_EN after asserting SLEEP_EN") inst_S1P1 (RET_EN ^ rst_clk, ~disable_power_assertion_S1P1 & sim_reset, (|SLEEP_EN));

    //Power-S1.2:illegal assert RET_EN without 2 nop-CLK
    wire disable_power_assertion_S1P2 = $test$plusargs("disable_power_assertions_globally") | $test$plusargs("disable_power_assertion_assert_RET_EN_without_2_nop_CLK");
    nv_assert_never #(0,0, "Power-S1.2:illegal assert RET_EN without 2 nop-CLK") inst_S1P2 (RET_EN ^ rst_clk, ~disable_power_assertion_S1P2 & sim_reset, weclk_gating | weclk_gating_1p | weclk_gating_2p | reclk_gating | reclk_gating_1p | reclk_gating_2p);

  //#2 From retention mode to function mode:

    //Power-S2.1:illegal write without 2 nop-CLK after de-asserting RET_EN
    wire disable_power_assertion_S2P1 = $test$plusargs("disable_power_assertions_globally") | $test$plusargs("disable_power_assertion_write_without_2_nop_CLK_after_retention2function");
    nv_assert_never #(0,0, "Power-S2.1:illegal write without 2 nop-CLK after de-asserting RET_EN") inst_S2P1 (CLK_W ^ rst_clk, ~disable_power_assertion_S2P1 & sim_reset, ~RET_EN & ret_en_w_2p & weclk_gating);

    //Power-S2.2:illegal read without 2 nop-CLK after de-asserting RET_EN
    wire disable_power_assertion_S2P2 = $test$plusargs("disable_power_assertions_globally") | $test$plusargs("disable_power_assertion_read_without_2_nop_CLK_after_retention2function");
    nv_assert_never #(0,0, "Power-S2.2:illegal read without 2 nop-CLK after de-asserting RET_EN") inst_S2P2 (CLK_R ^ rst_clk, ~disable_power_assertion_S2P2 & sim_reset, ~RET_EN & ret_en_r_2p & reclk_gating);

  //#3 From function mode to sleep mode:

    //Power-S3.2:illegal assert SLEEP_EN without 2 nop-CLK
    wire disable_power_assertion_S3P2 = $test$plusargs("disable_power_assertions_globally") | $test$plusargs("disable_power_assertion_assert_SLEEP_EN_without_2_nop_CLK");
    nv_assert_never #(0,0, "Power-S3.2:illegal assert SLEEP_EN without 2 nop-CLK") inst_S3P2 ((|SLEEP_EN) ^ rst_clk, ~disable_power_assertion_S3P2 & sim_reset, weclk_gating | weclk_gating_1p | weclk_gating_2p | reclk_gating | reclk_gating_1p | reclk_gating_2p);

  //#4 From sleep mode to function mode:

    //Power-S4.1:illegal write without 2 nop-CLK after switching from sleep mode to function mode
    wire disable_power_assertion_S4P1 = $test$plusargs("disable_power_assertions_globally") | $test$plusargs("disable_power_assertion_write_without_2_nop_CLK_after_sleep2function");
    nv_assert_never #(0,0, "Power-S4.1:illegal write without 2 nop-CLK after switching from sleep mode to function mode") inst_S4P1 (CLK_W ^ rst_clk, ~disable_power_assertion_S4P1 & sim_reset, ~(|SLEEP_EN) & sleep_en_off_w_2p & weclk_gating);
   
    //Power-S4.2:illegal read without 2 nop-CLK after switching from sleep mode to function mode
    wire disable_power_assertion_S4P2 = $test$plusargs("disable_power_assertions_globally") | $test$plusargs("disable_power_assertion_read_without_2_nop_after_sleep2function");
    nv_assert_never #(0,0, "Power-S4.2:illegal read without 2 nop-CLK after switching from sleep mode to function mode") inst_S4P2 (CLK_R ^ rst_clk, ~disable_power_assertion_S4P2 & sim_reset, ~(|SLEEP_EN) & sleep_en_off_r_2p & reclk_gating);
`endif //NV_RAM_ASSERT
//VCS coverage on 

`ifdef NV_RAM_EXPAND_ARRAY
  wire [18-1:0] Q_63 = ITOP.io.array[63];
  wire [18-1:0] Q_62 = ITOP.io.array[62];
  wire [18-1:0] Q_61 = ITOP.io.array[61];
  wire [18-1:0] Q_60 = ITOP.io.array[60];
  wire [18-1:0] Q_59 = ITOP.io.array[59];
  wire [18-1:0] Q_58 = ITOP.io.array[58];
  wire [18-1:0] Q_57 = ITOP.io.array[57];
  wire [18-1:0] Q_56 = ITOP.io.array[56];
  wire [18-1:0] Q_55 = ITOP.io.array[55];
  wire [18-1:0] Q_54 = ITOP.io.array[54];
  wire [18-1:0] Q_53 = ITOP.io.array[53];
  wire [18-1:0] Q_52 = ITOP.io.array[52];
  wire [18-1:0] Q_51 = ITOP.io.array[51];
  wire [18-1:0] Q_50 = ITOP.io.array[50];
  wire [18-1:0] Q_49 = ITOP.io.array[49];
  wire [18-1:0] Q_48 = ITOP.io.array[48];
  wire [18-1:0] Q_47 = ITOP.io.array[47];
  wire [18-1:0] Q_46 = ITOP.io.array[46];
  wire [18-1:0] Q_45 = ITOP.io.array[45];
  wire [18-1:0] Q_44 = ITOP.io.array[44];
  wire [18-1:0] Q_43 = ITOP.io.array[43];
  wire [18-1:0] Q_42 = ITOP.io.array[42];
  wire [18-1:0] Q_41 = ITOP.io.array[41];
  wire [18-1:0] Q_40 = ITOP.io.array[40];
  wire [18-1:0] Q_39 = ITOP.io.array[39];
  wire [18-1:0] Q_38 = ITOP.io.array[38];
  wire [18-1:0] Q_37 = ITOP.io.array[37];
  wire [18-1:0] Q_36 = ITOP.io.array[36];
  wire [18-1:0] Q_35 = ITOP.io.array[35];
  wire [18-1:0] Q_34 = ITOP.io.array[34];
  wire [18-1:0] Q_33 = ITOP.io.array[33];
  wire [18-1:0] Q_32 = ITOP.io.array[32];
  wire [18-1:0] Q_31 = ITOP.io.array[31];
  wire [18-1:0] Q_30 = ITOP.io.array[30];
  wire [18-1:0] Q_29 = ITOP.io.array[29];
  wire [18-1:0] Q_28 = ITOP.io.array[28];
  wire [18-1:0] Q_27 = ITOP.io.array[27];
  wire [18-1:0] Q_26 = ITOP.io.array[26];
  wire [18-1:0] Q_25 = ITOP.io.array[25];
  wire [18-1:0] Q_24 = ITOP.io.array[24];
  wire [18-1:0] Q_23 = ITOP.io.array[23];
  wire [18-1:0] Q_22 = ITOP.io.array[22];
  wire [18-1:0] Q_21 = ITOP.io.array[21];
  wire [18-1:0] Q_20 = ITOP.io.array[20];
  wire [18-1:0] Q_19 = ITOP.io.array[19];
  wire [18-1:0] Q_18 = ITOP.io.array[18];
  wire [18-1:0] Q_17 = ITOP.io.array[17];
  wire [18-1:0] Q_16 = ITOP.io.array[16];
  wire [18-1:0] Q_15 = ITOP.io.array[15];
  wire [18-1:0] Q_14 = ITOP.io.array[14];
  wire [18-1:0] Q_13 = ITOP.io.array[13];
  wire [18-1:0] Q_12 = ITOP.io.array[12];
  wire [18-1:0] Q_11 = ITOP.io.array[11];
  wire [18-1:0] Q_10 = ITOP.io.array[10];
  wire [18-1:0] Q_9 = ITOP.io.array[9];
  wire [18-1:0] Q_8 = ITOP.io.array[8];
  wire [18-1:0] Q_7 = ITOP.io.array[7];
  wire [18-1:0] Q_6 = ITOP.io.array[6];
  wire [18-1:0] Q_5 = ITOP.io.array[5];
  wire [18-1:0] Q_4 = ITOP.io.array[4];
  wire [18-1:0] Q_3 = ITOP.io.array[3];
  wire [18-1:0] Q_2 = ITOP.io.array[2];
  wire [18-1:0] Q_1 = ITOP.io.array[1];
  wire [18-1:0] Q_0 = ITOP.io.array[0];

`endif //def NV_RAM_EXPAND_ARRAY

//VCS coverage off
`ifdef MONITOR
task monitor_on;
    begin
        ITOP.io.monitor_on = 1'b1;
    end
endtask

task monitor_off;
    begin
        ITOP.io.monitor_on = 1'b0;
        ITOP.io.dump_monitor_result = 1'b1;
    end
endtask
`endif//def MONITOR
//VCS coverage on

//VCS coverage off
task mem_fill_value;
input fill_bit;
integer i;
begin
    for (i=0; i<64; i=i+1) begin
    	ITOP.io.array[i] = {18{fill_bit}};
    end
end
endtask 

task mem_fill_random; 
integer i;
integer j;
reg [17:0] val;
begin
    for (j=0; j<64; j=j+1) begin
        for (i=0; i<18; i=i+1) begin
            val[i] = {$random}; 
        end
	    ITOP.io.array[j] = val;
    end
end
endtask

task mem_write;
  input [5:0] addr;
  input [17:0] data;
  begin
     ITOP.io.mem_wr_raw(addr,data);
  end
endtask

function [17:0] mem_read;
  input [5:0] addr;
  begin
	mem_read = ITOP.io.mem_read_raw(addr);
  end
endfunction

task force_rd;
  input [5:0] addr;
  begin
	ITOP.io.r0_dout_tmp = ITOP.io.array[addr];
  end
endtask

`ifdef MEM_PHYS_INFO
task mem_phys_write;
  input [5-1:0] addr;
  input [35:0] data;
  reg [17:0] wd0, wd1;
  integer i;
  begin
  	for (i=0; i<18; i=i+1) begin
  		wd0[i] = data[i*2];
  		wd1[i] = data[i*2+1];
  	end
  	ITOP.io.mem_wr_raw({addr[5-1:0], 1'b0}, wd0);
  	ITOP.io.mem_wr_raw({addr[5-1:0], 1'b1}, wd1);
  end
endtask

function [35:0] mem_phys_read_padr;
   input [5-1:0] addr;
   reg [35:0] data;
   reg [17:0] rd0, rd1;
   integer i;
   begin
     rd0 = ITOP.io.mem_read_raw({addr[5-1:0], 1'b0});
     rd1 = ITOP.io.mem_read_raw({addr[5-1:0], 1'b1});
     for (i=0; i<=17; i=i+1) begin
	    data[i*2]   = rd0[i];
	    data[i*2+1] = rd1[i];
    end
    mem_phys_read_padr = data;
  end
endfunction

function [5-1:0] mem_log_to_phys_adr;
    input [5:0] addr;
    begin
    mem_log_to_phys_adr = addr[5:1];
    end
endfunction

function [35:0] mem_phys_read_pmasked;
   input [5:0] addr;
   reg [35:0] data;
   reg [17:0] rd0, rd1;
   integer i;
   begin
      case (addr[0])
           1'b0: begin
                     rd0 = ITOP.io.mem_read_raw(addr);
                     rd1 = 18'bx;
                  end
           1'b1: begin
                     rd0 = 18'bx;
                     rd1 = ITOP.io.mem_read_raw(addr);
                  end

      endcase
      for (i=0; i<=17; i=i+1) begin
	      data[i*2]   = rd0[i];
	      data[i*2+1] = rd1[i];
      end
      mem_phys_read_pmasked = data;
  end
endfunction

function [35:0] mem_phys_read_ladr;
  input [5:0] addr;
  begin
	mem_phys_read_ladr = mem_phys_read_padr(mem_log_to_phys_adr(addr));
  end
endfunction
`endif //def MEM_PHYS_INFO

`ifdef FAULT_INJECTION
task mem_fault_no_write;
  input [17:0] fault_mask;
   begin
    ITOP.io.mem_fault_no_write(fault_mask);
  end
endtask

task mem_fault_stuck_0;
  input [17:0] fault_mask;
  integer i;
   begin
    ITOP.io.mem_fault_stuck_0(fault_mask);
   end
endtask

task mem_fault_stuck_1;
  input [17:0] fault_mask;
  integer i;
   begin
    ITOP.io.mem_fault_stuck_1(fault_mask);
  end
endtask

task set_bit_fault_stuck_0;
  input r;
  input c;
  integer r;
  integer c;
    ITOP.io.set_bit_fault_stuck_0(r,c);
endtask

task set_bit_fault_stuck_1;
  input r;
  input c;
  integer r;
  integer c;
    ITOP.io.set_bit_fault_stuck_1(r,c);
endtask

task clear_bit_fault_stuck_0;
  input r;
  input c;
  integer r;
  integer c;
    ITOP.io.clear_bit_fault_stuck_0(r,c);
endtask

task clear_bit_fault_stuck_1;
  input r;
  input c;
  integer r;
  integer c;
    ITOP.io.clear_bit_fault_stuck_1(r,c);
endtask
//VCS coverage on

`endif //def FAULT_INJECTION
`else //def SYNTHESIS
    
    wire clobber_x;
    assign clobber_x = 1'b0;
    wire clobber_array = 1'b0;
    wire clobber_flops = 1'b0;

`endif //ndef SYNTHESIS

	//instantiate memory bank
	RAM_BANK_RAMDP_64X18_GL_M2_E2 ITOP (
		.RE(RE), 
		.WE(WE), 
		.RA(RA),  
		.WA(WA), 
		.CLK_R(CLK_R), 
		.CLK_W(CLK_W), 
		.IDDQ(IDDQ), 
		.SVOP(SVOP), 
		.WD(WD), 
		.RD(RD),
		
		.SLEEP_EN(SLEEP_EN),
        .RET_EN(RET_EN),
        .clobber_flops(clobber_flops), 
        .clobber_array(clobber_array),
        .clobber_x(clobber_x)     	
	);

//VCS coverage off
`else //def EMULATION
    // Simple emulation model without MBIST, SCAN or REDUNDANCY
    	//common part for write
    	reg we_ff;
        reg [5:0] wa_ff;
        reg [17:0] wd_ff; 
    	always @(posedge CLK_W) begin // spyglass disable W391
                we_ff  <= WE;
                wa_ff <= WA;
                wd_ff <= WD;
    	end
    	   
        

    	//common part for read
    	reg re_lat;
        always @(*) begin
    		if (!CLK_R) begin
                re_lat  <= RE; // spyglass disable W18
    		end
    	end
    	
    	wire reclk = CLK_R & re_lat;
    
    	reg [5:0] ra_ff;
    	always @(posedge CLK_R) begin // spyglass disable W391
    			ra_ff <= RA;
    	end

        reg [17:0] dout; 

        assign RD = dout;
    
 	    //memory array       
	    reg [17:0] array[0:63]; 
	    always @(negedge CLK_W ) begin
            if (we_ff) begin
	    		array[wa_ff] <= wd_ff; // spyglass disable SYNTH_5130
            end
	    end
	    always @(*) begin
	    	if (reclk) begin
	    		dout <= array[ra_ff]; // spyglass disable SYNTH_5130, W18
	    	end
	    end
    // End of the simple emulation model
`endif //def EMULATION
//VCS coverage on

`endif //ndef RAM_INTERFACE
endmodule
`endcelldefine






/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// memory bank block : defines internal logic of the RAMDP /////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef RAM_INTERFACE
`ifndef EMULATION
module RAM_BANK_RAMDP_64X18_GL_M2_E2 (RE, WE, RA, WA, CLK_R, CLK_W, IDDQ, SVOP, WD, RD, SLEEP_EN, RET_EN, clobber_flops, clobber_array, clobber_x
);


input RET_EN;
input RE, WE, CLK_R, CLK_W, IDDQ;
input [5:0] RA, WA;
input [17:0] WD;
input [1:0] SVOP;
input [7:0] SLEEP_EN;
input clobber_flops, clobber_array, clobber_x;
output [17:0] RD;

//State point clobering signals:

    wire output_valid = ~(clobber_x | (|SLEEP_EN));
    wire clamp_o = SLEEP_EN[7] | RET_EN;

	//common part for write
    wire clk_w_iddq = CLK_W & ~IDDQ & ~clamp_o;
	reg we_lat;
	always @(*) begin
		if (!clk_w_iddq & !clobber_flops) begin
			we_lat  <=  WE; // spyglass disable W18, IntClock
		end
	end

    // weclk with posedge 1 dly | negedge 2 dly	
    wire weclk, weclk_d0, weclk_d1, weclk_d2;
    assign weclk_d0 = clk_w_iddq & we_lat & ~clobber_flops & ~clobber_array;
    assign #1 weclk_d1 = weclk_d0;
    assign #1 weclk_d2 = weclk_d1;
    assign weclk = weclk_d1 | weclk_d2; // spyglass disable GatedClock

    // wadclk with posedge 0 dly | negedge 3 dly	
    wire wadclk, wadclk_d0, wadclk_d1, wadclk_d2, wadclk_d3;
    assign wadclk_d0 = clk_w_iddq & we_lat;
    assign #1 wadclk_d1 = wadclk_d0;
    assign #1 wadclk_d2 = wadclk_d1;
    assign #1 wadclk_d3 = wadclk_d2;
    assign wadclk = wadclk_d0 | wadclk_d1 | wadclk_d2 | wadclk_d3;  

    // wdclk with posedge 0 dly | negedge 3 dly
    wire wdclk, wdclk_d0, wdclk_d1, wdclk_d2, wdclk_d3;
    assign wdclk_d0 = clk_w_iddq & we_lat;
    assign #1 wdclk_d1 = wdclk_d0;
    assign #1 wdclk_d2 = wdclk_d1;
    assign #1 wdclk_d3 = wdclk_d2;
    assign wdclk = wdclk_d0 | wdclk_d1 | wdclk_d2 | wdclk_d3;  

    reg [5:0] wa_lat;
	always @(*) begin
		if (!wadclk & !clobber_flops) begin
			wa_lat  <=  WA; // spyglass disable W18, IntClock
		end
	end

	reg [17:0] wd_lat;
	always @(*) begin
		if (!wdclk & !clobber_flops) begin
			wd_lat  <= WD; // spyglass disable W18, IntClock
		end
	end

	//common part for read
	reg re_lat;
	always @(*) begin
		if (!CLK_R & !clobber_flops) begin
			re_lat <=  RE; // spyglass disable W18, IntClock
		end
	end

    // reclk with posedge 1 dly | negedge 0 dly
    wire reclk, reclk_d0, reclk_d1;
    assign reclk_d0 = CLK_R & ~IDDQ & re_lat & ~clamp_o;
    assign #1 reclk_d1 = reclk_d0;
    assign reclk = reclk_d0 & reclk_d1; // spyglass disable GatedClock

    // radclk with posedge 0 dly | negedge 1 dly
    wire radclk, radclk_d0, radclk_d1;
    assign radclk_d0 = CLK_R & ~IDDQ & re_lat & ~clamp_o;
    assign #1 radclk_d1 = radclk_d0;
    assign radclk = radclk_d0 | radclk_d1;  

	reg [5:0] ra_lat;
	always @(*) begin
		if (!radclk & !clobber_flops) begin
			ra_lat <=  RA; // spyglass disable W18, IntClock
		end
	end
	
	wire [17:0] dout;
	assign RD = clamp_o ? 18'b0 : (output_valid ? dout : 18'bx); //spyglass disable STARC-2.10.1.6


	//for E-option RAM


	vram_RAMDP_64X18_GL_M2_E2 # (64, 18, 6) io (
		.w0_addr(wa_lat),
		.w0_clk(weclk),
		.w0_bwe({18{1'b1}}),
		.w0_din(wd_lat),
		.r0_addr(ra_lat),
		.r0_clk(reclk),
		.r0_dout(dout),
        .clamp_o(clamp_o)
	);

endmodule
`endif //ndef EMULATION
`endif //ndef RAM_INTERFACE








/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////  ram primitive : defines 2D behavioral memory array of the RAMDP ////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef RAM_INTERFACE
`ifndef EMULATION
module vram_RAMDP_64X18_GL_M2_E2 (
	w0_addr,
	w0_clk,
	w0_bwe,
	w0_din,
	r0_addr,
	r0_clk,
	r0_dout,
    clamp_o
);

parameter words = 64;
parameter bits = 18;
parameter addrs = 6;


input [addrs-1:0] w0_addr;
input w0_clk;
input [bits-1:0] w0_din;
input [bits-1:0] w0_bwe;
input [addrs-1:0] r0_addr;
input r0_clk;
input clamp_o;
output [bits-1:0] r0_dout;

integer a;

`ifndef SYNTHESIS
`ifdef FAULT_INJECTION
	// regs for inducing faults
	reg [bits-1:0] fault_no_write; // block writes to this column
	reg [bits-1:0] fault_stuck_0;  // column always reads as 0
	reg [bits-1:0] fault_stuck_1;  // column always reads as 1
	reg [bits-1:0] bit_fault_stuck_0[0:words-1];  // column always reads as 0
	reg [bits-1:0] bit_fault_stuck_1[0:words-1];  // column always reads as 1
	
	initial begin : init_bit_fault_stuck
	  integer i;
	  integer j;
	  fault_no_write = {bits{1'b0}};
	  fault_stuck_0  = {bits{1'b0}};
	  fault_stuck_1  = {bits{1'b0}};
	  for (i=0; i<=words; i=i+1) begin
	      bit_fault_stuck_0[i] = {bits{1'b0}};
	      bit_fault_stuck_1[i] = {bits{1'b0}};
	  end
	end
`endif //def FAULT_INJECTION

`ifdef MONITOR
//VCS coverage off
// monitor variables
reg monitor_on;
reg dump_monitor_result;
// this monitors coverage including redundancy cols
// 1'bx = not accessed
// 1'b0 = accessed as a 0
// 1'b1 = accessed as a 1
// 1'bz = accessed as both 0 and 1
reg [bits-1:0] bit_written[0:words-1];
reg [bits-1:0] bit_read[0:words-1];

initial begin : init_monitor
  monitor_on = 1'b0; 
  dump_monitor_result = 1'b0;
  for(a=0;a<words;a=a+1) begin
      bit_written[a] = {bits{1'bx}};
      bit_read[a] = {bits{1'bx}};
  end
end

always @(dump_monitor_result) begin : dump_monitor
    integer r;
	integer c;
    integer b;
	reg [36-1:0] tmp_row;
    	if (dump_monitor_result == 1'b1) begin
		    $display("Exercised coverage summary:");
		    $display("\t%m bits not written as 0:");
		    for (r=0; r<32; r=r+1) begin
		        for (b=0; b<bits; b=b+1) begin
                        tmp_row[b*2+0] = bit_written[r*2+0][b];
                        tmp_row[b*2+1] = bit_written[r*2+1][b];
                    end
		    	for (c=0; c<36; c=c+1) begin
		    		if (tmp_row[c] !== 1'b0 && tmp_row[c] !== 1'bz) $display("\t\t[row,col] [%d,%d]", r, c);
		    	end
		    end
            $display("\t%m bits not written as 1:");
		    for (r=0; r<32; r=r+1) begin
		        for (b=0; b<bits; b=b+1) begin
                        tmp_row[b*2+0] = bit_written[r*2+0][b];
                        tmp_row[b*2+1] = bit_written[r*2+1][b];
                    end
		    	for (c=0; c<36; c=c+1) begin
		    		if (tmp_row[c] !== 1'b1 && tmp_row[c] !== 1'bz) $display("\t\t[row,col] [%d,%d]", r, c);
		    	end
		    end
		    $display("\t%m bits not read as 0:");
		    for (r=0; r<32; r=r+1) begin
		        for (b=0; b<bits; b=b+1) begin
                        tmp_row[b*2+0] = bit_read[r*2+0][b];
                        tmp_row[b*2+1] = bit_read[r*2+1][b];
                    end
		    	for (c=0; c<36; c=c+1) begin
		    		if (tmp_row[c] !== 1'b0 && tmp_row[c] !== 1'bz) $display("\t\t[row,col] [%d,%d]", r, c);
		    	end
		    end
		    $display("\t%m bits not read as 1:");
		    for (r=0; r<32; r=r+1) begin
		        for (b=0; b<bits; b=b+1) begin
                        tmp_row[b*2+0] = bit_read[r*2+0][b];
                        tmp_row[b*2+1] = bit_read[r*2+1][b];
                    end
		    	for (c=0; c<36; c=c+1) begin
		    		if (tmp_row[c] !== 1'b1 && tmp_row[c] !== 1'bz) $display("\t\t[row,col] [%d,%d]", r, c);
		    	end
		    end
        end
	dump_monitor_result = 1'b0;
end
//VCS coverage on
`endif //MONITOR
`endif //ndef SYNTHESIS
	
	//memory array
	reg [bits-1:0] array[0:words-1];  

// Bit write enable
`ifndef SYNTHESIS 
    `ifdef FAULT_INJECTION
        wire [bits-1:0] bwe_with_fault = w0_bwe & ~fault_no_write;
        wire [bits-1:0] re_with_fault = ~(bit_fault_stuck_1[r0_addr] | bit_fault_stuck_0[r0_addr]);
    `else
        wire [bits-1:0] bwe_with_fault = w0_bwe;
        wire [bits-1:0] re_with_fault = {bits{1'b1}};
    `endif //def FAULT_INJECTION
`else
    wire [bits-1:0] bwe_with_fault = w0_bwe;
`endif //SYNTHESIS

	//write function
    wire [bits-1:0] bitclk = {bits{w0_clk}} & bwe_with_fault;
    genvar idx;
    generate
        for (idx=0; idx<bits; idx=idx+1)
        begin : write
            always @(bitclk[idx] or w0_clk or w0_addr or w0_din[idx])
            begin
                if (bitclk[idx] && w0_clk)
                begin
                    array[w0_addr][idx] <= w0_din[idx]; // spyglass disable SYNTH_5130, W18
                    `ifndef SYNTHESIS
                    `ifdef MONITOR
//VCS coverage off
                    if (monitor_on) begin 
	    				case (bit_written[w0_addr][idx])
	    				    1'bx: bit_written[w0_addr][idx] = w0_din[idx];
	    				    1'b0: bit_written[w0_addr][idx] = w0_din[idx] == 1 ? 1'bz : 1'b0;
	    				    1'b1: bit_written[w0_addr][idx] = w0_din[idx] == 0 ? 1'bz : 1'b1;
	    				    1'bz: bit_written[w0_addr][idx] = 1'bz;
	    				endcase
                    end   
//VCS coverage on
                    `endif //MONITOR	    
                    `endif //SYNTHESIS	
                end
            end
        end
    endgenerate

	//read function
	wire [bits-1:0] r0_arr;
`ifndef SYNTHESIS
    `ifdef FAULT_INJECTION
	    assign r0_arr = (array[r0_addr] | bit_fault_stuck_1[r0_addr]) & ~bit_fault_stuck_0[r0_addr]; //read fault injection
    `else
	    assign r0_arr = array[r0_addr]; 
    `endif //def FAULT_INJECTION
`else
    assign r0_arr = array[r0_addr]; // spyglass disable SYNTH_5130
`endif //def SYNTHESIS


    wire r0_clk_d0p1, r0_clk_read, r0_clk_reset_collision;
    assign #0.1 r0_clk_d0p1 = r0_clk;
    assign r0_clk_read = r0_clk_d0p1 & r0_clk; // spyglass disable GatedClock
    assign r0_clk_reset_collision = r0_clk | r0_clk_d0p1; // spyglass disable W402b

`ifndef SYNTHESIS
`ifdef MONITOR
//VCS coverage off 
    always @(r0_clk_read) begin
        if (monitor_on) begin
            for (a=0; a<bits; a=a+1) begin
	            if (re_with_fault[a] && r0_clk_read) begin
	                case (bit_read[r0_addr][a])
			            1'bx: bit_read[r0_addr][a] = array[r0_addr][a];
				        1'b0: bit_read[r0_addr][a] = array[r0_addr][a] == 1 ? 1'bz : 1'b0;
				        1'b1: bit_read[r0_addr][a] = array[r0_addr][a] == 0 ? 1'bz : 1'b1;
				        1'bz: bit_read[r0_addr][a] = 1'bz;
		            endcase
	            end
	        end
        end
    end
//VCS coverage on
`endif //MONITOR
`endif //SYNTHESIS

	reg [bits-1:0] collision_ff;
    wire [bits-1:0] collision_ff_clk =  {bits{w0_clk}} & {bits{r0_clk_read}} & {bits{r0_addr==w0_addr}} & bwe_with_fault; //spyglass disable GatedClock
    genvar bw;
    generate
        for (bw=0; bw<bits; bw=bw+1) 
        begin : collision
	        always @(posedge collision_ff_clk[bw] or negedge r0_clk_reset_collision) begin
                if (!r0_clk_reset_collision) 
                    begin
                        collision_ff[bw] <= 1'b0;
                    end
                else
                    begin
                        collision_ff[bw] <= 1'b1;
                    end
            end
        end
    endgenerate

	reg [bits-1:0] r0_dout_tmp;
	always @(*)
	begin
	    if (r0_clk_read) begin
            for (a=0; a<bits; a=a+1) begin
                r0_dout_tmp[a] <= ( collision_ff[a] | (r0_addr==w0_addr & w0_clk & bwe_with_fault[a]) ) ? 1'bx : r0_arr[a] & ~clamp_o; //spyglass disable STARC-2.10.1.6, W18
            end
        end
    end
    wire [bits-1:0] r0_dout = r0_dout_tmp & {bits{~clamp_o}};

`ifndef SYNTHESIS
//VCS coverage off
task mem_wr_raw;
  input [addrs-1:0] addr;
  input [bits-1:0] data;
  begin
    array[addr] = data;
  end
endtask

function [bits-1:0] mem_read_raw;
input [addrs-1:0] addr;
	mem_read_raw = array[addr];
endfunction

`ifdef FAULT_INJECTION
// induce faults on columns
task mem_fault_no_write;
  input [bits-1:0] fault_mask;
   begin
    fault_no_write = fault_mask;
  end
endtask

task mem_fault_stuck_0;
  input [bits-1:0] fault_mask;
  integer i;
   begin
    for ( i=0; i<words; i=i+1 ) begin
      bit_fault_stuck_0[i] = fault_mask;
    end
  end
endtask

task mem_fault_stuck_1;
  input [bits-1:0] fault_mask;
  integer i;
   begin
    for ( i=0; i<words; i=i+1 ) begin
      bit_fault_stuck_1[i] = fault_mask;
    end
  end
endtask

task set_bit_fault_stuck_0;
  input r;
  input c;
  integer r;
  integer c;
  bit_fault_stuck_0[r][c] = 1;
endtask

task set_bit_fault_stuck_1;
  input r;
  input c;
  integer r;
  integer c;
  bit_fault_stuck_1[r][c] = 1;
endtask

task clear_bit_fault_stuck_0;
  input r;
  input c;
  integer r;
  integer c;
  bit_fault_stuck_0[r][c] = 0;
endtask

task clear_bit_fault_stuck_1;
  input r;
  input c;
  integer r;
  integer c;
  bit_fault_stuck_1[r][c] = 0;
endtask
//VCS coverage on
`endif //def FAULT_INJECTION
`endif //ndef SYNTHESIS

endmodule
`endif //ndef EMULATION
`endif //ndef RAM_INTERFACE
