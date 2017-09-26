// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_READ_cq.v

`include "simulate_x_tick.vh"
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"
module NV_NVDLA_MCIF_READ_cq (
      nvdla_core_clk
    , nvdla_core_rstn
    , cq_wr_prdy
    , cq_wr_pvld
    , cq_wr_thread_id
`ifdef FV_RAND_WR_PAUSE
    , cq_wr_pause
`endif
    , cq_wr_pd
    , cq_rd0_prdy
    , cq_rd0_pvld
    , cq_rd0_pd
    , cq_rd1_prdy
    , cq_rd1_pvld
    , cq_rd1_pd
    , cq_rd2_prdy
    , cq_rd2_pvld
    , cq_rd2_pd
    , cq_rd3_prdy
    , cq_rd3_pvld
    , cq_rd3_pd
    , cq_rd4_prdy
    , cq_rd4_pvld
    , cq_rd4_pd
    , cq_rd5_prdy
    , cq_rd5_pvld
    , cq_rd5_pd
    , cq_rd6_prdy
    , cq_rd6_pvld
    , cq_rd6_pd
    , cq_rd7_prdy
    , cq_rd7_pvld
    , cq_rd7_pd
    , cq_rd8_prdy
    , cq_rd8_pvld
    , cq_rd8_pd
    , cq_rd9_prdy
    , cq_rd9_pvld
    , cq_rd9_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        cq_wr_prdy;
input         cq_wr_pvld;
input  [3:0] cq_wr_thread_id;
`ifdef FV_RAND_WR_PAUSE
input         cq_wr_pause;
`endif
input  [6:0] cq_wr_pd;
input         cq_rd0_prdy;
output        cq_rd0_pvld;
output [6:0] cq_rd0_pd;
input         cq_rd1_prdy;
output        cq_rd1_pvld;
output [6:0] cq_rd1_pd;
input         cq_rd2_prdy;
output        cq_rd2_pvld;
output [6:0] cq_rd2_pd;
input         cq_rd3_prdy;
output        cq_rd3_pvld;
output [6:0] cq_rd3_pd;
input         cq_rd4_prdy;
output        cq_rd4_pvld;
output [6:0] cq_rd4_pd;
input         cq_rd5_prdy;
output        cq_rd5_pvld;
output [6:0] cq_rd5_pd;
input         cq_rd6_prdy;
output        cq_rd6_pvld;
output [6:0] cq_rd6_pd;
input         cq_rd7_prdy;
output        cq_rd7_pvld;
output [6:0] cq_rd7_pd;
input         cq_rd8_prdy;
output        cq_rd8_pvld;
output [6:0] cq_rd8_pd;
input         cq_rd9_prdy;
output        cq_rd9_pvld;
output [6:0] cq_rd9_pd;
input  [31:0] pwrbus_ram_pd;

//
//wire [9:0] cq_rd_credit;
wire       cq_rd_take;
wire [6:0] cq_rd_pd_p;
wire [3:0] cq_rd_take_thread_id;

//
wire       wr_bypassing;        

//

wire nvdla_core_clk_mgated_skid;
wire nvdla_core_clk_mgated_skid_enable;
NV_CLK_gate_power nvdla_core_clk_rd_mgate_skid( .clk(nvdla_core_clk), .reset_(nvdla_core_rstn), .clk_en(nvdla_core_clk_mgated_skid_enable), .clk_gated(nvdla_core_clk_mgated_skid) );

wire nvdla_core_clk_mgated_enable;   
wire nvdla_core_clk_mgated;               
NV_CLK_gate_power nvdla_core_clk_mgate( .clk(nvdla_core_clk), .reset_(nvdla_core_rstn), .clk_en(nvdla_core_clk_mgated_enable), .clk_gated(nvdla_core_clk_mgated) );

// 
// WRITE SIDE
//
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
wire wr_pause_rand;  
`endif	
`endif	
// synopsys translate_on
wire wr_reserving;
reg        cq_wr_busy_int;		        	
assign     cq_wr_prdy = !cq_wr_busy_int;
assign       wr_reserving = cq_wr_pvld && !cq_wr_busy_int; 


wire       wr_popping;                          

reg  [8:0] cq_wr_count;			
wire wr_reserving_and_not_bypassing = wr_reserving && !wr_bypassing;

wire [8:0] wr_count_next_wr_popping = wr_reserving_and_not_bypassing ? cq_wr_count : (cq_wr_count - 1'd1); // spyglass disable W164a W484
wire [8:0] wr_count_next_no_wr_popping = wr_reserving_and_not_bypassing ? (cq_wr_count + 1'd1) : cq_wr_count; // spyglass disable W164a W484
wire [8:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_256 = ( wr_count_next_no_wr_popping == 9'd256 );
wire wr_count_next_is_256 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_256;
wire [8:0] wr_limit_muxed;  
wire [8:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       cq_wr_busy_next = wr_count_next_is_256 || 
                          (wr_limit_reg != 9'd0 &&      
                           wr_count_next >= wr_limit_reg) || cq_wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       cq_wr_busy_next = wr_count_next_is_256 || 
                          (wr_limit_reg != 9'd0 &&      
                           wr_count_next >= wr_limit_reg)  
 // synopsys translate_off
  `ifndef SYNTH_LEVEL1_COMPILE
  `ifndef SYNTHESIS
 || wr_pause_rand
  `endif
  `endif
 // synopsys translate_on
;
                          // VCS coverage on
`endif
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_wr_busy_int <=  1'b0;
        cq_wr_count <=  9'd0;
    end else begin
	cq_wr_busy_int <=  cq_wr_busy_next;
	if ( wr_reserving_and_not_bypassing ^ wr_popping ) begin
	    cq_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving_and_not_bypassing ^ wr_popping) ) begin
        end else begin
            cq_wr_count <=  {9{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving && !wr_bypassing;   
wire [3:0] wr_pushing_thread_id = cq_wr_thread_id; 

//
// RAM
//

wire wr_adr_popping = wr_pushing;	

wire [7:0] cq_wr_adr;			
reg  [7:0] cq_rd_adr;
wire [7:0] cq_rd_adr_p = cq_rd_adr;		

wire rd_enable;

wire [31 : 0] pwrbus_ram_pd;



nv_ram_rws_256x7 #(`FORCE_CONTENTION_ASSERTION_RESET_ACTIVE) ram (
      .clk		 ( nvdla_core_clk )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .wa        ( cq_wr_adr )
    , .we        ( wr_pushing )
    , .di        ( cq_wr_pd )
    , .ra        ( cq_rd_adr_p )
    , .re        ( rd_enable )
    , .dout        ( cq_rd_pd_p )
    );

wire   rd_popping;              

//
//



wire   rd_pushing = wr_pushing;		
wire [3:0] rd_pushing_thread_id = wr_pushing_thread_id;
wire [7:0] rd_pushing_adr = cq_wr_adr;

//
//
wire [7:0] rd_popping_adr;   

wire [7:0] free_adr_index;
reg [255-1:0] free_adr_mask_next;
reg [255-1:0] free_adr_mask;

assign cq_wr_adr = free_adr_index;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        free_adr_mask <=  {255{1'b1}};
    end else begin
        if ( rd_popping || wr_adr_popping ) begin
            free_adr_mask <=  free_adr_mask_next;
        end 
        //synopsys translate_off
            else if ( !(rd_popping || wr_adr_popping) ) begin
        end else begin
            free_adr_mask <=  {255{`x_or_0}};
        end
        //synopsys translate_on

    end
end    

always @(*) begin
    free_adr_mask_next = free_adr_mask;

        if ( rd_popping && rd_popping_adr == 8'd0 ) begin
            free_adr_mask_next[0] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd0 ) begin
            free_adr_mask_next[0] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd1 ) begin
            free_adr_mask_next[1] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd1 ) begin
            free_adr_mask_next[1] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd2 ) begin
            free_adr_mask_next[2] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd2 ) begin
            free_adr_mask_next[2] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd3 ) begin
            free_adr_mask_next[3] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd3 ) begin
            free_adr_mask_next[3] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd4 ) begin
            free_adr_mask_next[4] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd4 ) begin
            free_adr_mask_next[4] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd5 ) begin
            free_adr_mask_next[5] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd5 ) begin
            free_adr_mask_next[5] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd6 ) begin
            free_adr_mask_next[6] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd6 ) begin
            free_adr_mask_next[6] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd7 ) begin
            free_adr_mask_next[7] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd7 ) begin
            free_adr_mask_next[7] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd8 ) begin
            free_adr_mask_next[8] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd8 ) begin
            free_adr_mask_next[8] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd9 ) begin
            free_adr_mask_next[9] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd9 ) begin
            free_adr_mask_next[9] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd10 ) begin
            free_adr_mask_next[10] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd10 ) begin
            free_adr_mask_next[10] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd11 ) begin
            free_adr_mask_next[11] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd11 ) begin
            free_adr_mask_next[11] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd12 ) begin
            free_adr_mask_next[12] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd12 ) begin
            free_adr_mask_next[12] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd13 ) begin
            free_adr_mask_next[13] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd13 ) begin
            free_adr_mask_next[13] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd14 ) begin
            free_adr_mask_next[14] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd14 ) begin
            free_adr_mask_next[14] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd15 ) begin
            free_adr_mask_next[15] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd15 ) begin
            free_adr_mask_next[15] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd16 ) begin
            free_adr_mask_next[16] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd16 ) begin
            free_adr_mask_next[16] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd17 ) begin
            free_adr_mask_next[17] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd17 ) begin
            free_adr_mask_next[17] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd18 ) begin
            free_adr_mask_next[18] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd18 ) begin
            free_adr_mask_next[18] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd19 ) begin
            free_adr_mask_next[19] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd19 ) begin
            free_adr_mask_next[19] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd20 ) begin
            free_adr_mask_next[20] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd20 ) begin
            free_adr_mask_next[20] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd21 ) begin
            free_adr_mask_next[21] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd21 ) begin
            free_adr_mask_next[21] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd22 ) begin
            free_adr_mask_next[22] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd22 ) begin
            free_adr_mask_next[22] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd23 ) begin
            free_adr_mask_next[23] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd23 ) begin
            free_adr_mask_next[23] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd24 ) begin
            free_adr_mask_next[24] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd24 ) begin
            free_adr_mask_next[24] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd25 ) begin
            free_adr_mask_next[25] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd25 ) begin
            free_adr_mask_next[25] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd26 ) begin
            free_adr_mask_next[26] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd26 ) begin
            free_adr_mask_next[26] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd27 ) begin
            free_adr_mask_next[27] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd27 ) begin
            free_adr_mask_next[27] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd28 ) begin
            free_adr_mask_next[28] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd28 ) begin
            free_adr_mask_next[28] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd29 ) begin
            free_adr_mask_next[29] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd29 ) begin
            free_adr_mask_next[29] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd30 ) begin
            free_adr_mask_next[30] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd30 ) begin
            free_adr_mask_next[30] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd31 ) begin
            free_adr_mask_next[31] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd31 ) begin
            free_adr_mask_next[31] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd32 ) begin
            free_adr_mask_next[32] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd32 ) begin
            free_adr_mask_next[32] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd33 ) begin
            free_adr_mask_next[33] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd33 ) begin
            free_adr_mask_next[33] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd34 ) begin
            free_adr_mask_next[34] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd34 ) begin
            free_adr_mask_next[34] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd35 ) begin
            free_adr_mask_next[35] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd35 ) begin
            free_adr_mask_next[35] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd36 ) begin
            free_adr_mask_next[36] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd36 ) begin
            free_adr_mask_next[36] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd37 ) begin
            free_adr_mask_next[37] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd37 ) begin
            free_adr_mask_next[37] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd38 ) begin
            free_adr_mask_next[38] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd38 ) begin
            free_adr_mask_next[38] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd39 ) begin
            free_adr_mask_next[39] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd39 ) begin
            free_adr_mask_next[39] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd40 ) begin
            free_adr_mask_next[40] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd40 ) begin
            free_adr_mask_next[40] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd41 ) begin
            free_adr_mask_next[41] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd41 ) begin
            free_adr_mask_next[41] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd42 ) begin
            free_adr_mask_next[42] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd42 ) begin
            free_adr_mask_next[42] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd43 ) begin
            free_adr_mask_next[43] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd43 ) begin
            free_adr_mask_next[43] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd44 ) begin
            free_adr_mask_next[44] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd44 ) begin
            free_adr_mask_next[44] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd45 ) begin
            free_adr_mask_next[45] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd45 ) begin
            free_adr_mask_next[45] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd46 ) begin
            free_adr_mask_next[46] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd46 ) begin
            free_adr_mask_next[46] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd47 ) begin
            free_adr_mask_next[47] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd47 ) begin
            free_adr_mask_next[47] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd48 ) begin
            free_adr_mask_next[48] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd48 ) begin
            free_adr_mask_next[48] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd49 ) begin
            free_adr_mask_next[49] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd49 ) begin
            free_adr_mask_next[49] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd50 ) begin
            free_adr_mask_next[50] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd50 ) begin
            free_adr_mask_next[50] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd51 ) begin
            free_adr_mask_next[51] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd51 ) begin
            free_adr_mask_next[51] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd52 ) begin
            free_adr_mask_next[52] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd52 ) begin
            free_adr_mask_next[52] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd53 ) begin
            free_adr_mask_next[53] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd53 ) begin
            free_adr_mask_next[53] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd54 ) begin
            free_adr_mask_next[54] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd54 ) begin
            free_adr_mask_next[54] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd55 ) begin
            free_adr_mask_next[55] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd55 ) begin
            free_adr_mask_next[55] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd56 ) begin
            free_adr_mask_next[56] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd56 ) begin
            free_adr_mask_next[56] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd57 ) begin
            free_adr_mask_next[57] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd57 ) begin
            free_adr_mask_next[57] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd58 ) begin
            free_adr_mask_next[58] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd58 ) begin
            free_adr_mask_next[58] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd59 ) begin
            free_adr_mask_next[59] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd59 ) begin
            free_adr_mask_next[59] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd60 ) begin
            free_adr_mask_next[60] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd60 ) begin
            free_adr_mask_next[60] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd61 ) begin
            free_adr_mask_next[61] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd61 ) begin
            free_adr_mask_next[61] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd62 ) begin
            free_adr_mask_next[62] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd62 ) begin
            free_adr_mask_next[62] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd63 ) begin
            free_adr_mask_next[63] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd63 ) begin
            free_adr_mask_next[63] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd64 ) begin
            free_adr_mask_next[64] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd64 ) begin
            free_adr_mask_next[64] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd65 ) begin
            free_adr_mask_next[65] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd65 ) begin
            free_adr_mask_next[65] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd66 ) begin
            free_adr_mask_next[66] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd66 ) begin
            free_adr_mask_next[66] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd67 ) begin
            free_adr_mask_next[67] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd67 ) begin
            free_adr_mask_next[67] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd68 ) begin
            free_adr_mask_next[68] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd68 ) begin
            free_adr_mask_next[68] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd69 ) begin
            free_adr_mask_next[69] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd69 ) begin
            free_adr_mask_next[69] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd70 ) begin
            free_adr_mask_next[70] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd70 ) begin
            free_adr_mask_next[70] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd71 ) begin
            free_adr_mask_next[71] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd71 ) begin
            free_adr_mask_next[71] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd72 ) begin
            free_adr_mask_next[72] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd72 ) begin
            free_adr_mask_next[72] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd73 ) begin
            free_adr_mask_next[73] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd73 ) begin
            free_adr_mask_next[73] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd74 ) begin
            free_adr_mask_next[74] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd74 ) begin
            free_adr_mask_next[74] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd75 ) begin
            free_adr_mask_next[75] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd75 ) begin
            free_adr_mask_next[75] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd76 ) begin
            free_adr_mask_next[76] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd76 ) begin
            free_adr_mask_next[76] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd77 ) begin
            free_adr_mask_next[77] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd77 ) begin
            free_adr_mask_next[77] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd78 ) begin
            free_adr_mask_next[78] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd78 ) begin
            free_adr_mask_next[78] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd79 ) begin
            free_adr_mask_next[79] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd79 ) begin
            free_adr_mask_next[79] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd80 ) begin
            free_adr_mask_next[80] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd80 ) begin
            free_adr_mask_next[80] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd81 ) begin
            free_adr_mask_next[81] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd81 ) begin
            free_adr_mask_next[81] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd82 ) begin
            free_adr_mask_next[82] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd82 ) begin
            free_adr_mask_next[82] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd83 ) begin
            free_adr_mask_next[83] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd83 ) begin
            free_adr_mask_next[83] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd84 ) begin
            free_adr_mask_next[84] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd84 ) begin
            free_adr_mask_next[84] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd85 ) begin
            free_adr_mask_next[85] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd85 ) begin
            free_adr_mask_next[85] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd86 ) begin
            free_adr_mask_next[86] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd86 ) begin
            free_adr_mask_next[86] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd87 ) begin
            free_adr_mask_next[87] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd87 ) begin
            free_adr_mask_next[87] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd88 ) begin
            free_adr_mask_next[88] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd88 ) begin
            free_adr_mask_next[88] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd89 ) begin
            free_adr_mask_next[89] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd89 ) begin
            free_adr_mask_next[89] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd90 ) begin
            free_adr_mask_next[90] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd90 ) begin
            free_adr_mask_next[90] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd91 ) begin
            free_adr_mask_next[91] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd91 ) begin
            free_adr_mask_next[91] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd92 ) begin
            free_adr_mask_next[92] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd92 ) begin
            free_adr_mask_next[92] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd93 ) begin
            free_adr_mask_next[93] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd93 ) begin
            free_adr_mask_next[93] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd94 ) begin
            free_adr_mask_next[94] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd94 ) begin
            free_adr_mask_next[94] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd95 ) begin
            free_adr_mask_next[95] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd95 ) begin
            free_adr_mask_next[95] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd96 ) begin
            free_adr_mask_next[96] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd96 ) begin
            free_adr_mask_next[96] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd97 ) begin
            free_adr_mask_next[97] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd97 ) begin
            free_adr_mask_next[97] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd98 ) begin
            free_adr_mask_next[98] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd98 ) begin
            free_adr_mask_next[98] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd99 ) begin
            free_adr_mask_next[99] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd99 ) begin
            free_adr_mask_next[99] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd100 ) begin
            free_adr_mask_next[100] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd100 ) begin
            free_adr_mask_next[100] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd101 ) begin
            free_adr_mask_next[101] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd101 ) begin
            free_adr_mask_next[101] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd102 ) begin
            free_adr_mask_next[102] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd102 ) begin
            free_adr_mask_next[102] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd103 ) begin
            free_adr_mask_next[103] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd103 ) begin
            free_adr_mask_next[103] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd104 ) begin
            free_adr_mask_next[104] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd104 ) begin
            free_adr_mask_next[104] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd105 ) begin
            free_adr_mask_next[105] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd105 ) begin
            free_adr_mask_next[105] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd106 ) begin
            free_adr_mask_next[106] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd106 ) begin
            free_adr_mask_next[106] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd107 ) begin
            free_adr_mask_next[107] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd107 ) begin
            free_adr_mask_next[107] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd108 ) begin
            free_adr_mask_next[108] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd108 ) begin
            free_adr_mask_next[108] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd109 ) begin
            free_adr_mask_next[109] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd109 ) begin
            free_adr_mask_next[109] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd110 ) begin
            free_adr_mask_next[110] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd110 ) begin
            free_adr_mask_next[110] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd111 ) begin
            free_adr_mask_next[111] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd111 ) begin
            free_adr_mask_next[111] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd112 ) begin
            free_adr_mask_next[112] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd112 ) begin
            free_adr_mask_next[112] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd113 ) begin
            free_adr_mask_next[113] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd113 ) begin
            free_adr_mask_next[113] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd114 ) begin
            free_adr_mask_next[114] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd114 ) begin
            free_adr_mask_next[114] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd115 ) begin
            free_adr_mask_next[115] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd115 ) begin
            free_adr_mask_next[115] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd116 ) begin
            free_adr_mask_next[116] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd116 ) begin
            free_adr_mask_next[116] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd117 ) begin
            free_adr_mask_next[117] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd117 ) begin
            free_adr_mask_next[117] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd118 ) begin
            free_adr_mask_next[118] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd118 ) begin
            free_adr_mask_next[118] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd119 ) begin
            free_adr_mask_next[119] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd119 ) begin
            free_adr_mask_next[119] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd120 ) begin
            free_adr_mask_next[120] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd120 ) begin
            free_adr_mask_next[120] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd121 ) begin
            free_adr_mask_next[121] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd121 ) begin
            free_adr_mask_next[121] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd122 ) begin
            free_adr_mask_next[122] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd122 ) begin
            free_adr_mask_next[122] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd123 ) begin
            free_adr_mask_next[123] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd123 ) begin
            free_adr_mask_next[123] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd124 ) begin
            free_adr_mask_next[124] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd124 ) begin
            free_adr_mask_next[124] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd125 ) begin
            free_adr_mask_next[125] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd125 ) begin
            free_adr_mask_next[125] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd126 ) begin
            free_adr_mask_next[126] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd126 ) begin
            free_adr_mask_next[126] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd127 ) begin
            free_adr_mask_next[127] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd127 ) begin
            free_adr_mask_next[127] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd128 ) begin
            free_adr_mask_next[128] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd128 ) begin
            free_adr_mask_next[128] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd129 ) begin
            free_adr_mask_next[129] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd129 ) begin
            free_adr_mask_next[129] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd130 ) begin
            free_adr_mask_next[130] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd130 ) begin
            free_adr_mask_next[130] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd131 ) begin
            free_adr_mask_next[131] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd131 ) begin
            free_adr_mask_next[131] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd132 ) begin
            free_adr_mask_next[132] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd132 ) begin
            free_adr_mask_next[132] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd133 ) begin
            free_adr_mask_next[133] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd133 ) begin
            free_adr_mask_next[133] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd134 ) begin
            free_adr_mask_next[134] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd134 ) begin
            free_adr_mask_next[134] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd135 ) begin
            free_adr_mask_next[135] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd135 ) begin
            free_adr_mask_next[135] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd136 ) begin
            free_adr_mask_next[136] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd136 ) begin
            free_adr_mask_next[136] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd137 ) begin
            free_adr_mask_next[137] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd137 ) begin
            free_adr_mask_next[137] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd138 ) begin
            free_adr_mask_next[138] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd138 ) begin
            free_adr_mask_next[138] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd139 ) begin
            free_adr_mask_next[139] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd139 ) begin
            free_adr_mask_next[139] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd140 ) begin
            free_adr_mask_next[140] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd140 ) begin
            free_adr_mask_next[140] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd141 ) begin
            free_adr_mask_next[141] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd141 ) begin
            free_adr_mask_next[141] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd142 ) begin
            free_adr_mask_next[142] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd142 ) begin
            free_adr_mask_next[142] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd143 ) begin
            free_adr_mask_next[143] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd143 ) begin
            free_adr_mask_next[143] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd144 ) begin
            free_adr_mask_next[144] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd144 ) begin
            free_adr_mask_next[144] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd145 ) begin
            free_adr_mask_next[145] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd145 ) begin
            free_adr_mask_next[145] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd146 ) begin
            free_adr_mask_next[146] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd146 ) begin
            free_adr_mask_next[146] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd147 ) begin
            free_adr_mask_next[147] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd147 ) begin
            free_adr_mask_next[147] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd148 ) begin
            free_adr_mask_next[148] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd148 ) begin
            free_adr_mask_next[148] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd149 ) begin
            free_adr_mask_next[149] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd149 ) begin
            free_adr_mask_next[149] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd150 ) begin
            free_adr_mask_next[150] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd150 ) begin
            free_adr_mask_next[150] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd151 ) begin
            free_adr_mask_next[151] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd151 ) begin
            free_adr_mask_next[151] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd152 ) begin
            free_adr_mask_next[152] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd152 ) begin
            free_adr_mask_next[152] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd153 ) begin
            free_adr_mask_next[153] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd153 ) begin
            free_adr_mask_next[153] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd154 ) begin
            free_adr_mask_next[154] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd154 ) begin
            free_adr_mask_next[154] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd155 ) begin
            free_adr_mask_next[155] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd155 ) begin
            free_adr_mask_next[155] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd156 ) begin
            free_adr_mask_next[156] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd156 ) begin
            free_adr_mask_next[156] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd157 ) begin
            free_adr_mask_next[157] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd157 ) begin
            free_adr_mask_next[157] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd158 ) begin
            free_adr_mask_next[158] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd158 ) begin
            free_adr_mask_next[158] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd159 ) begin
            free_adr_mask_next[159] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd159 ) begin
            free_adr_mask_next[159] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd160 ) begin
            free_adr_mask_next[160] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd160 ) begin
            free_adr_mask_next[160] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd161 ) begin
            free_adr_mask_next[161] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd161 ) begin
            free_adr_mask_next[161] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd162 ) begin
            free_adr_mask_next[162] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd162 ) begin
            free_adr_mask_next[162] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd163 ) begin
            free_adr_mask_next[163] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd163 ) begin
            free_adr_mask_next[163] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd164 ) begin
            free_adr_mask_next[164] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd164 ) begin
            free_adr_mask_next[164] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd165 ) begin
            free_adr_mask_next[165] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd165 ) begin
            free_adr_mask_next[165] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd166 ) begin
            free_adr_mask_next[166] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd166 ) begin
            free_adr_mask_next[166] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd167 ) begin
            free_adr_mask_next[167] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd167 ) begin
            free_adr_mask_next[167] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd168 ) begin
            free_adr_mask_next[168] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd168 ) begin
            free_adr_mask_next[168] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd169 ) begin
            free_adr_mask_next[169] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd169 ) begin
            free_adr_mask_next[169] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd170 ) begin
            free_adr_mask_next[170] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd170 ) begin
            free_adr_mask_next[170] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd171 ) begin
            free_adr_mask_next[171] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd171 ) begin
            free_adr_mask_next[171] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd172 ) begin
            free_adr_mask_next[172] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd172 ) begin
            free_adr_mask_next[172] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd173 ) begin
            free_adr_mask_next[173] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd173 ) begin
            free_adr_mask_next[173] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd174 ) begin
            free_adr_mask_next[174] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd174 ) begin
            free_adr_mask_next[174] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd175 ) begin
            free_adr_mask_next[175] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd175 ) begin
            free_adr_mask_next[175] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd176 ) begin
            free_adr_mask_next[176] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd176 ) begin
            free_adr_mask_next[176] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd177 ) begin
            free_adr_mask_next[177] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd177 ) begin
            free_adr_mask_next[177] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd178 ) begin
            free_adr_mask_next[178] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd178 ) begin
            free_adr_mask_next[178] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd179 ) begin
            free_adr_mask_next[179] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd179 ) begin
            free_adr_mask_next[179] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd180 ) begin
            free_adr_mask_next[180] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd180 ) begin
            free_adr_mask_next[180] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd181 ) begin
            free_adr_mask_next[181] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd181 ) begin
            free_adr_mask_next[181] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd182 ) begin
            free_adr_mask_next[182] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd182 ) begin
            free_adr_mask_next[182] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd183 ) begin
            free_adr_mask_next[183] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd183 ) begin
            free_adr_mask_next[183] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd184 ) begin
            free_adr_mask_next[184] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd184 ) begin
            free_adr_mask_next[184] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd185 ) begin
            free_adr_mask_next[185] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd185 ) begin
            free_adr_mask_next[185] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd186 ) begin
            free_adr_mask_next[186] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd186 ) begin
            free_adr_mask_next[186] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd187 ) begin
            free_adr_mask_next[187] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd187 ) begin
            free_adr_mask_next[187] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd188 ) begin
            free_adr_mask_next[188] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd188 ) begin
            free_adr_mask_next[188] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd189 ) begin
            free_adr_mask_next[189] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd189 ) begin
            free_adr_mask_next[189] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd190 ) begin
            free_adr_mask_next[190] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd190 ) begin
            free_adr_mask_next[190] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd191 ) begin
            free_adr_mask_next[191] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd191 ) begin
            free_adr_mask_next[191] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd192 ) begin
            free_adr_mask_next[192] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd192 ) begin
            free_adr_mask_next[192] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd193 ) begin
            free_adr_mask_next[193] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd193 ) begin
            free_adr_mask_next[193] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd194 ) begin
            free_adr_mask_next[194] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd194 ) begin
            free_adr_mask_next[194] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd195 ) begin
            free_adr_mask_next[195] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd195 ) begin
            free_adr_mask_next[195] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd196 ) begin
            free_adr_mask_next[196] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd196 ) begin
            free_adr_mask_next[196] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd197 ) begin
            free_adr_mask_next[197] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd197 ) begin
            free_adr_mask_next[197] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd198 ) begin
            free_adr_mask_next[198] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd198 ) begin
            free_adr_mask_next[198] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd199 ) begin
            free_adr_mask_next[199] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd199 ) begin
            free_adr_mask_next[199] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd200 ) begin
            free_adr_mask_next[200] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd200 ) begin
            free_adr_mask_next[200] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd201 ) begin
            free_adr_mask_next[201] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd201 ) begin
            free_adr_mask_next[201] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd202 ) begin
            free_adr_mask_next[202] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd202 ) begin
            free_adr_mask_next[202] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd203 ) begin
            free_adr_mask_next[203] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd203 ) begin
            free_adr_mask_next[203] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd204 ) begin
            free_adr_mask_next[204] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd204 ) begin
            free_adr_mask_next[204] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd205 ) begin
            free_adr_mask_next[205] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd205 ) begin
            free_adr_mask_next[205] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd206 ) begin
            free_adr_mask_next[206] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd206 ) begin
            free_adr_mask_next[206] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd207 ) begin
            free_adr_mask_next[207] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd207 ) begin
            free_adr_mask_next[207] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd208 ) begin
            free_adr_mask_next[208] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd208 ) begin
            free_adr_mask_next[208] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd209 ) begin
            free_adr_mask_next[209] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd209 ) begin
            free_adr_mask_next[209] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd210 ) begin
            free_adr_mask_next[210] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd210 ) begin
            free_adr_mask_next[210] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd211 ) begin
            free_adr_mask_next[211] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd211 ) begin
            free_adr_mask_next[211] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd212 ) begin
            free_adr_mask_next[212] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd212 ) begin
            free_adr_mask_next[212] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd213 ) begin
            free_adr_mask_next[213] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd213 ) begin
            free_adr_mask_next[213] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd214 ) begin
            free_adr_mask_next[214] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd214 ) begin
            free_adr_mask_next[214] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd215 ) begin
            free_adr_mask_next[215] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd215 ) begin
            free_adr_mask_next[215] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd216 ) begin
            free_adr_mask_next[216] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd216 ) begin
            free_adr_mask_next[216] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd217 ) begin
            free_adr_mask_next[217] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd217 ) begin
            free_adr_mask_next[217] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd218 ) begin
            free_adr_mask_next[218] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd218 ) begin
            free_adr_mask_next[218] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd219 ) begin
            free_adr_mask_next[219] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd219 ) begin
            free_adr_mask_next[219] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd220 ) begin
            free_adr_mask_next[220] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd220 ) begin
            free_adr_mask_next[220] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd221 ) begin
            free_adr_mask_next[221] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd221 ) begin
            free_adr_mask_next[221] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd222 ) begin
            free_adr_mask_next[222] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd222 ) begin
            free_adr_mask_next[222] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd223 ) begin
            free_adr_mask_next[223] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd223 ) begin
            free_adr_mask_next[223] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd224 ) begin
            free_adr_mask_next[224] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd224 ) begin
            free_adr_mask_next[224] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd225 ) begin
            free_adr_mask_next[225] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd225 ) begin
            free_adr_mask_next[225] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd226 ) begin
            free_adr_mask_next[226] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd226 ) begin
            free_adr_mask_next[226] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd227 ) begin
            free_adr_mask_next[227] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd227 ) begin
            free_adr_mask_next[227] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd228 ) begin
            free_adr_mask_next[228] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd228 ) begin
            free_adr_mask_next[228] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd229 ) begin
            free_adr_mask_next[229] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd229 ) begin
            free_adr_mask_next[229] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd230 ) begin
            free_adr_mask_next[230] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd230 ) begin
            free_adr_mask_next[230] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd231 ) begin
            free_adr_mask_next[231] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd231 ) begin
            free_adr_mask_next[231] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd232 ) begin
            free_adr_mask_next[232] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd232 ) begin
            free_adr_mask_next[232] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd233 ) begin
            free_adr_mask_next[233] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd233 ) begin
            free_adr_mask_next[233] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd234 ) begin
            free_adr_mask_next[234] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd234 ) begin
            free_adr_mask_next[234] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd235 ) begin
            free_adr_mask_next[235] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd235 ) begin
            free_adr_mask_next[235] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd236 ) begin
            free_adr_mask_next[236] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd236 ) begin
            free_adr_mask_next[236] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd237 ) begin
            free_adr_mask_next[237] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd237 ) begin
            free_adr_mask_next[237] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd238 ) begin
            free_adr_mask_next[238] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd238 ) begin
            free_adr_mask_next[238] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd239 ) begin
            free_adr_mask_next[239] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd239 ) begin
            free_adr_mask_next[239] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd240 ) begin
            free_adr_mask_next[240] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd240 ) begin
            free_adr_mask_next[240] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd241 ) begin
            free_adr_mask_next[241] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd241 ) begin
            free_adr_mask_next[241] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd242 ) begin
            free_adr_mask_next[242] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd242 ) begin
            free_adr_mask_next[242] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd243 ) begin
            free_adr_mask_next[243] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd243 ) begin
            free_adr_mask_next[243] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd244 ) begin
            free_adr_mask_next[244] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd244 ) begin
            free_adr_mask_next[244] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd245 ) begin
            free_adr_mask_next[245] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd245 ) begin
            free_adr_mask_next[245] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd246 ) begin
            free_adr_mask_next[246] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd246 ) begin
            free_adr_mask_next[246] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd247 ) begin
            free_adr_mask_next[247] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd247 ) begin
            free_adr_mask_next[247] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd248 ) begin
            free_adr_mask_next[248] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd248 ) begin
            free_adr_mask_next[248] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd249 ) begin
            free_adr_mask_next[249] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd249 ) begin
            free_adr_mask_next[249] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd250 ) begin
            free_adr_mask_next[250] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd250 ) begin
            free_adr_mask_next[250] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd251 ) begin
            free_adr_mask_next[251] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd251 ) begin
            free_adr_mask_next[251] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd252 ) begin
            free_adr_mask_next[252] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd252 ) begin
            free_adr_mask_next[252] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd253 ) begin
            free_adr_mask_next[253] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd253 ) begin
            free_adr_mask_next[253] = 1'b0;
        end
        if ( rd_popping && rd_popping_adr == 8'd254 ) begin
            free_adr_mask_next[254] = 1'b1;
        end else if ( wr_adr_popping && free_adr_index == 8'd254 ) begin
            free_adr_mask_next[254] = 1'b0;
        end
end

wire flag_l0_0 = free_adr_mask[1] | free_adr_mask[0];
wire flag_l0_1 = free_adr_mask[3] | free_adr_mask[2];
wire flag_l0_2 = free_adr_mask[5] | free_adr_mask[4];
wire flag_l0_3 = free_adr_mask[7] | free_adr_mask[6];
wire flag_l0_4 = free_adr_mask[9] | free_adr_mask[8];
wire flag_l0_5 = free_adr_mask[11] | free_adr_mask[10];
wire flag_l0_6 = free_adr_mask[13] | free_adr_mask[12];
wire flag_l0_7 = free_adr_mask[15] | free_adr_mask[14];
wire flag_l0_8 = free_adr_mask[17] | free_adr_mask[16];
wire flag_l0_9 = free_adr_mask[19] | free_adr_mask[18];
wire flag_l0_10 = free_adr_mask[21] | free_adr_mask[20];
wire flag_l0_11 = free_adr_mask[23] | free_adr_mask[22];
wire flag_l0_12 = free_adr_mask[25] | free_adr_mask[24];
wire flag_l0_13 = free_adr_mask[27] | free_adr_mask[26];
wire flag_l0_14 = free_adr_mask[29] | free_adr_mask[28];
wire flag_l0_15 = free_adr_mask[31] | free_adr_mask[30];
wire flag_l0_16 = free_adr_mask[33] | free_adr_mask[32];
wire flag_l0_17 = free_adr_mask[35] | free_adr_mask[34];
wire flag_l0_18 = free_adr_mask[37] | free_adr_mask[36];
wire flag_l0_19 = free_adr_mask[39] | free_adr_mask[38];
wire flag_l0_20 = free_adr_mask[41] | free_adr_mask[40];
wire flag_l0_21 = free_adr_mask[43] | free_adr_mask[42];
wire flag_l0_22 = free_adr_mask[45] | free_adr_mask[44];
wire flag_l0_23 = free_adr_mask[47] | free_adr_mask[46];
wire flag_l0_24 = free_adr_mask[49] | free_adr_mask[48];
wire flag_l0_25 = free_adr_mask[51] | free_adr_mask[50];
wire flag_l0_26 = free_adr_mask[53] | free_adr_mask[52];
wire flag_l0_27 = free_adr_mask[55] | free_adr_mask[54];
wire flag_l0_28 = free_adr_mask[57] | free_adr_mask[56];
wire flag_l0_29 = free_adr_mask[59] | free_adr_mask[58];
wire flag_l0_30 = free_adr_mask[61] | free_adr_mask[60];
wire flag_l0_31 = free_adr_mask[63] | free_adr_mask[62];
wire flag_l0_32 = free_adr_mask[65] | free_adr_mask[64];
wire flag_l0_33 = free_adr_mask[67] | free_adr_mask[66];
wire flag_l0_34 = free_adr_mask[69] | free_adr_mask[68];
wire flag_l0_35 = free_adr_mask[71] | free_adr_mask[70];
wire flag_l0_36 = free_adr_mask[73] | free_adr_mask[72];
wire flag_l0_37 = free_adr_mask[75] | free_adr_mask[74];
wire flag_l0_38 = free_adr_mask[77] | free_adr_mask[76];
wire flag_l0_39 = free_adr_mask[79] | free_adr_mask[78];
wire flag_l0_40 = free_adr_mask[81] | free_adr_mask[80];
wire flag_l0_41 = free_adr_mask[83] | free_adr_mask[82];
wire flag_l0_42 = free_adr_mask[85] | free_adr_mask[84];
wire flag_l0_43 = free_adr_mask[87] | free_adr_mask[86];
wire flag_l0_44 = free_adr_mask[89] | free_adr_mask[88];
wire flag_l0_45 = free_adr_mask[91] | free_adr_mask[90];
wire flag_l0_46 = free_adr_mask[93] | free_adr_mask[92];
wire flag_l0_47 = free_adr_mask[95] | free_adr_mask[94];
wire flag_l0_48 = free_adr_mask[97] | free_adr_mask[96];
wire flag_l0_49 = free_adr_mask[99] | free_adr_mask[98];
wire flag_l0_50 = free_adr_mask[101] | free_adr_mask[100];
wire flag_l0_51 = free_adr_mask[103] | free_adr_mask[102];
wire flag_l0_52 = free_adr_mask[105] | free_adr_mask[104];
wire flag_l0_53 = free_adr_mask[107] | free_adr_mask[106];
wire flag_l0_54 = free_adr_mask[109] | free_adr_mask[108];
wire flag_l0_55 = free_adr_mask[111] | free_adr_mask[110];
wire flag_l0_56 = free_adr_mask[113] | free_adr_mask[112];
wire flag_l0_57 = free_adr_mask[115] | free_adr_mask[114];
wire flag_l0_58 = free_adr_mask[117] | free_adr_mask[116];
wire flag_l0_59 = free_adr_mask[119] | free_adr_mask[118];
wire flag_l0_60 = free_adr_mask[121] | free_adr_mask[120];
wire flag_l0_61 = free_adr_mask[123] | free_adr_mask[122];
wire flag_l0_62 = free_adr_mask[125] | free_adr_mask[124];
wire flag_l0_63 = free_adr_mask[127] | free_adr_mask[126];
wire flag_l0_64 = free_adr_mask[129] | free_adr_mask[128];
wire flag_l0_65 = free_adr_mask[131] | free_adr_mask[130];
wire flag_l0_66 = free_adr_mask[133] | free_adr_mask[132];
wire flag_l0_67 = free_adr_mask[135] | free_adr_mask[134];
wire flag_l0_68 = free_adr_mask[137] | free_adr_mask[136];
wire flag_l0_69 = free_adr_mask[139] | free_adr_mask[138];
wire flag_l0_70 = free_adr_mask[141] | free_adr_mask[140];
wire flag_l0_71 = free_adr_mask[143] | free_adr_mask[142];
wire flag_l0_72 = free_adr_mask[145] | free_adr_mask[144];
wire flag_l0_73 = free_adr_mask[147] | free_adr_mask[146];
wire flag_l0_74 = free_adr_mask[149] | free_adr_mask[148];
wire flag_l0_75 = free_adr_mask[151] | free_adr_mask[150];
wire flag_l0_76 = free_adr_mask[153] | free_adr_mask[152];
wire flag_l0_77 = free_adr_mask[155] | free_adr_mask[154];
wire flag_l0_78 = free_adr_mask[157] | free_adr_mask[156];
wire flag_l0_79 = free_adr_mask[159] | free_adr_mask[158];
wire flag_l0_80 = free_adr_mask[161] | free_adr_mask[160];
wire flag_l0_81 = free_adr_mask[163] | free_adr_mask[162];
wire flag_l0_82 = free_adr_mask[165] | free_adr_mask[164];
wire flag_l0_83 = free_adr_mask[167] | free_adr_mask[166];
wire flag_l0_84 = free_adr_mask[169] | free_adr_mask[168];
wire flag_l0_85 = free_adr_mask[171] | free_adr_mask[170];
wire flag_l0_86 = free_adr_mask[173] | free_adr_mask[172];
wire flag_l0_87 = free_adr_mask[175] | free_adr_mask[174];
wire flag_l0_88 = free_adr_mask[177] | free_adr_mask[176];
wire flag_l0_89 = free_adr_mask[179] | free_adr_mask[178];
wire flag_l0_90 = free_adr_mask[181] | free_adr_mask[180];
wire flag_l0_91 = free_adr_mask[183] | free_adr_mask[182];
wire flag_l0_92 = free_adr_mask[185] | free_adr_mask[184];
wire flag_l0_93 = free_adr_mask[187] | free_adr_mask[186];
wire flag_l0_94 = free_adr_mask[189] | free_adr_mask[188];
wire flag_l0_95 = free_adr_mask[191] | free_adr_mask[190];
wire flag_l0_96 = free_adr_mask[193] | free_adr_mask[192];
wire flag_l0_97 = free_adr_mask[195] | free_adr_mask[194];
wire flag_l0_98 = free_adr_mask[197] | free_adr_mask[196];
wire flag_l0_99 = free_adr_mask[199] | free_adr_mask[198];
wire flag_l0_100 = free_adr_mask[201] | free_adr_mask[200];
wire flag_l0_101 = free_adr_mask[203] | free_adr_mask[202];
wire flag_l0_102 = free_adr_mask[205] | free_adr_mask[204];
wire flag_l0_103 = free_adr_mask[207] | free_adr_mask[206];
wire flag_l0_104 = free_adr_mask[209] | free_adr_mask[208];
wire flag_l0_105 = free_adr_mask[211] | free_adr_mask[210];
wire flag_l0_106 = free_adr_mask[213] | free_adr_mask[212];
wire flag_l0_107 = free_adr_mask[215] | free_adr_mask[214];
wire flag_l0_108 = free_adr_mask[217] | free_adr_mask[216];
wire flag_l0_109 = free_adr_mask[219] | free_adr_mask[218];
wire flag_l0_110 = free_adr_mask[221] | free_adr_mask[220];
wire flag_l0_111 = free_adr_mask[223] | free_adr_mask[222];
wire flag_l0_112 = free_adr_mask[225] | free_adr_mask[224];
wire flag_l0_113 = free_adr_mask[227] | free_adr_mask[226];
wire flag_l0_114 = free_adr_mask[229] | free_adr_mask[228];
wire flag_l0_115 = free_adr_mask[231] | free_adr_mask[230];
wire flag_l0_116 = free_adr_mask[233] | free_adr_mask[232];
wire flag_l0_117 = free_adr_mask[235] | free_adr_mask[234];
wire flag_l0_118 = free_adr_mask[237] | free_adr_mask[236];
wire flag_l0_119 = free_adr_mask[239] | free_adr_mask[238];
wire flag_l0_120 = free_adr_mask[241] | free_adr_mask[240];
wire flag_l0_121 = free_adr_mask[243] | free_adr_mask[242];
wire flag_l0_122 = free_adr_mask[245] | free_adr_mask[244];
wire flag_l0_123 = free_adr_mask[247] | free_adr_mask[246];
wire flag_l0_124 = free_adr_mask[249] | free_adr_mask[248];
wire flag_l0_125 = free_adr_mask[251] | free_adr_mask[250];
wire flag_l0_126 = free_adr_mask[253] | free_adr_mask[252];

wire flag_l1_0 = flag_l0_1 | flag_l0_0;
wire flag_l1_1 = flag_l0_3 | flag_l0_2;
wire flag_l1_2 = flag_l0_5 | flag_l0_4;
wire flag_l1_3 = flag_l0_7 | flag_l0_6;
wire flag_l1_4 = flag_l0_9 | flag_l0_8;
wire flag_l1_5 = flag_l0_11 | flag_l0_10;
wire flag_l1_6 = flag_l0_13 | flag_l0_12;
wire flag_l1_7 = flag_l0_15 | flag_l0_14;
wire flag_l1_8 = flag_l0_17 | flag_l0_16;
wire flag_l1_9 = flag_l0_19 | flag_l0_18;
wire flag_l1_10 = flag_l0_21 | flag_l0_20;
wire flag_l1_11 = flag_l0_23 | flag_l0_22;
wire flag_l1_12 = flag_l0_25 | flag_l0_24;
wire flag_l1_13 = flag_l0_27 | flag_l0_26;
wire flag_l1_14 = flag_l0_29 | flag_l0_28;
wire flag_l1_15 = flag_l0_31 | flag_l0_30;
wire flag_l1_16 = flag_l0_33 | flag_l0_32;
wire flag_l1_17 = flag_l0_35 | flag_l0_34;
wire flag_l1_18 = flag_l0_37 | flag_l0_36;
wire flag_l1_19 = flag_l0_39 | flag_l0_38;
wire flag_l1_20 = flag_l0_41 | flag_l0_40;
wire flag_l1_21 = flag_l0_43 | flag_l0_42;
wire flag_l1_22 = flag_l0_45 | flag_l0_44;
wire flag_l1_23 = flag_l0_47 | flag_l0_46;
wire flag_l1_24 = flag_l0_49 | flag_l0_48;
wire flag_l1_25 = flag_l0_51 | flag_l0_50;
wire flag_l1_26 = flag_l0_53 | flag_l0_52;
wire flag_l1_27 = flag_l0_55 | flag_l0_54;
wire flag_l1_28 = flag_l0_57 | flag_l0_56;
wire flag_l1_29 = flag_l0_59 | flag_l0_58;
wire flag_l1_30 = flag_l0_61 | flag_l0_60;
wire flag_l1_31 = flag_l0_63 | flag_l0_62;
wire flag_l1_32 = flag_l0_65 | flag_l0_64;
wire flag_l1_33 = flag_l0_67 | flag_l0_66;
wire flag_l1_34 = flag_l0_69 | flag_l0_68;
wire flag_l1_35 = flag_l0_71 | flag_l0_70;
wire flag_l1_36 = flag_l0_73 | flag_l0_72;
wire flag_l1_37 = flag_l0_75 | flag_l0_74;
wire flag_l1_38 = flag_l0_77 | flag_l0_76;
wire flag_l1_39 = flag_l0_79 | flag_l0_78;
wire flag_l1_40 = flag_l0_81 | flag_l0_80;
wire flag_l1_41 = flag_l0_83 | flag_l0_82;
wire flag_l1_42 = flag_l0_85 | flag_l0_84;
wire flag_l1_43 = flag_l0_87 | flag_l0_86;
wire flag_l1_44 = flag_l0_89 | flag_l0_88;
wire flag_l1_45 = flag_l0_91 | flag_l0_90;
wire flag_l1_46 = flag_l0_93 | flag_l0_92;
wire flag_l1_47 = flag_l0_95 | flag_l0_94;
wire flag_l1_48 = flag_l0_97 | flag_l0_96;
wire flag_l1_49 = flag_l0_99 | flag_l0_98;
wire flag_l1_50 = flag_l0_101 | flag_l0_100;
wire flag_l1_51 = flag_l0_103 | flag_l0_102;
wire flag_l1_52 = flag_l0_105 | flag_l0_104;
wire flag_l1_53 = flag_l0_107 | flag_l0_106;
wire flag_l1_54 = flag_l0_109 | flag_l0_108;
wire flag_l1_55 = flag_l0_111 | flag_l0_110;
wire flag_l1_56 = flag_l0_113 | flag_l0_112;
wire flag_l1_57 = flag_l0_115 | flag_l0_114;
wire flag_l1_58 = flag_l0_117 | flag_l0_116;
wire flag_l1_59 = flag_l0_119 | flag_l0_118;
wire flag_l1_60 = flag_l0_121 | flag_l0_120;
wire flag_l1_61 = flag_l0_123 | flag_l0_122;
wire flag_l1_62 = flag_l0_125 | flag_l0_124;

wire flag_l2_0 = flag_l1_1 | flag_l1_0;
wire flag_l2_1 = flag_l1_3 | flag_l1_2;
wire flag_l2_2 = flag_l1_5 | flag_l1_4;
wire flag_l2_3 = flag_l1_7 | flag_l1_6;
wire flag_l2_4 = flag_l1_9 | flag_l1_8;
wire flag_l2_5 = flag_l1_11 | flag_l1_10;
wire flag_l2_6 = flag_l1_13 | flag_l1_12;
wire flag_l2_7 = flag_l1_15 | flag_l1_14;
wire flag_l2_8 = flag_l1_17 | flag_l1_16;
wire flag_l2_9 = flag_l1_19 | flag_l1_18;
wire flag_l2_10 = flag_l1_21 | flag_l1_20;
wire flag_l2_11 = flag_l1_23 | flag_l1_22;
wire flag_l2_12 = flag_l1_25 | flag_l1_24;
wire flag_l2_13 = flag_l1_27 | flag_l1_26;
wire flag_l2_14 = flag_l1_29 | flag_l1_28;
wire flag_l2_15 = flag_l1_31 | flag_l1_30;
wire flag_l2_16 = flag_l1_33 | flag_l1_32;
wire flag_l2_17 = flag_l1_35 | flag_l1_34;
wire flag_l2_18 = flag_l1_37 | flag_l1_36;
wire flag_l2_19 = flag_l1_39 | flag_l1_38;
wire flag_l2_20 = flag_l1_41 | flag_l1_40;
wire flag_l2_21 = flag_l1_43 | flag_l1_42;
wire flag_l2_22 = flag_l1_45 | flag_l1_44;
wire flag_l2_23 = flag_l1_47 | flag_l1_46;
wire flag_l2_24 = flag_l1_49 | flag_l1_48;
wire flag_l2_25 = flag_l1_51 | flag_l1_50;
wire flag_l2_26 = flag_l1_53 | flag_l1_52;
wire flag_l2_27 = flag_l1_55 | flag_l1_54;
wire flag_l2_28 = flag_l1_57 | flag_l1_56;
wire flag_l2_29 = flag_l1_59 | flag_l1_58;
wire flag_l2_30 = flag_l1_61 | flag_l1_60;

wire flag_l3_0 = flag_l2_1 | flag_l2_0;
wire flag_l3_1 = flag_l2_3 | flag_l2_2;
wire flag_l3_2 = flag_l2_5 | flag_l2_4;
wire flag_l3_3 = flag_l2_7 | flag_l2_6;
wire flag_l3_4 = flag_l2_9 | flag_l2_8;
wire flag_l3_5 = flag_l2_11 | flag_l2_10;
wire flag_l3_6 = flag_l2_13 | flag_l2_12;
wire flag_l3_7 = flag_l2_15 | flag_l2_14;
wire flag_l3_8 = flag_l2_17 | flag_l2_16;
wire flag_l3_9 = flag_l2_19 | flag_l2_18;
wire flag_l3_10 = flag_l2_21 | flag_l2_20;
wire flag_l3_11 = flag_l2_23 | flag_l2_22;
wire flag_l3_12 = flag_l2_25 | flag_l2_24;
wire flag_l3_13 = flag_l2_27 | flag_l2_26;
wire flag_l3_14 = flag_l2_29 | flag_l2_28;

wire flag_l4_0 = flag_l3_1 | flag_l3_0;
wire flag_l4_1 = flag_l3_3 | flag_l3_2;
wire flag_l4_2 = flag_l3_5 | flag_l3_4;
wire flag_l4_3 = flag_l3_7 | flag_l3_6;
wire flag_l4_4 = flag_l3_9 | flag_l3_8;
wire flag_l4_5 = flag_l3_11 | flag_l3_10;
wire flag_l4_6 = flag_l3_13 | flag_l3_12;

wire flag_l5_0 = flag_l4_1 | flag_l4_0;
wire flag_l5_1 = flag_l4_3 | flag_l4_2;
wire flag_l5_2 = flag_l4_5 | flag_l4_4;

wire flag_l6_0 = flag_l5_1 | flag_l5_0;

wire index_l0_0 = !free_adr_mask[0];
wire index_l0_1 = !free_adr_mask[2];
wire index_l0_2 = !free_adr_mask[4];
wire index_l0_3 = !free_adr_mask[6];
wire index_l0_4 = !free_adr_mask[8];
wire index_l0_5 = !free_adr_mask[10];
wire index_l0_6 = !free_adr_mask[12];
wire index_l0_7 = !free_adr_mask[14];
wire index_l0_8 = !free_adr_mask[16];
wire index_l0_9 = !free_adr_mask[18];
wire index_l0_10 = !free_adr_mask[20];
wire index_l0_11 = !free_adr_mask[22];
wire index_l0_12 = !free_adr_mask[24];
wire index_l0_13 = !free_adr_mask[26];
wire index_l0_14 = !free_adr_mask[28];
wire index_l0_15 = !free_adr_mask[30];
wire index_l0_16 = !free_adr_mask[32];
wire index_l0_17 = !free_adr_mask[34];
wire index_l0_18 = !free_adr_mask[36];
wire index_l0_19 = !free_adr_mask[38];
wire index_l0_20 = !free_adr_mask[40];
wire index_l0_21 = !free_adr_mask[42];
wire index_l0_22 = !free_adr_mask[44];
wire index_l0_23 = !free_adr_mask[46];
wire index_l0_24 = !free_adr_mask[48];
wire index_l0_25 = !free_adr_mask[50];
wire index_l0_26 = !free_adr_mask[52];
wire index_l0_27 = !free_adr_mask[54];
wire index_l0_28 = !free_adr_mask[56];
wire index_l0_29 = !free_adr_mask[58];
wire index_l0_30 = !free_adr_mask[60];
wire index_l0_31 = !free_adr_mask[62];
wire index_l0_32 = !free_adr_mask[64];
wire index_l0_33 = !free_adr_mask[66];
wire index_l0_34 = !free_adr_mask[68];
wire index_l0_35 = !free_adr_mask[70];
wire index_l0_36 = !free_adr_mask[72];
wire index_l0_37 = !free_adr_mask[74];
wire index_l0_38 = !free_adr_mask[76];
wire index_l0_39 = !free_adr_mask[78];
wire index_l0_40 = !free_adr_mask[80];
wire index_l0_41 = !free_adr_mask[82];
wire index_l0_42 = !free_adr_mask[84];
wire index_l0_43 = !free_adr_mask[86];
wire index_l0_44 = !free_adr_mask[88];
wire index_l0_45 = !free_adr_mask[90];
wire index_l0_46 = !free_adr_mask[92];
wire index_l0_47 = !free_adr_mask[94];
wire index_l0_48 = !free_adr_mask[96];
wire index_l0_49 = !free_adr_mask[98];
wire index_l0_50 = !free_adr_mask[100];
wire index_l0_51 = !free_adr_mask[102];
wire index_l0_52 = !free_adr_mask[104];
wire index_l0_53 = !free_adr_mask[106];
wire index_l0_54 = !free_adr_mask[108];
wire index_l0_55 = !free_adr_mask[110];
wire index_l0_56 = !free_adr_mask[112];
wire index_l0_57 = !free_adr_mask[114];
wire index_l0_58 = !free_adr_mask[116];
wire index_l0_59 = !free_adr_mask[118];
wire index_l0_60 = !free_adr_mask[120];
wire index_l0_61 = !free_adr_mask[122];
wire index_l0_62 = !free_adr_mask[124];
wire index_l0_63 = !free_adr_mask[126];
wire index_l0_64 = !free_adr_mask[128];
wire index_l0_65 = !free_adr_mask[130];
wire index_l0_66 = !free_adr_mask[132];
wire index_l0_67 = !free_adr_mask[134];
wire index_l0_68 = !free_adr_mask[136];
wire index_l0_69 = !free_adr_mask[138];
wire index_l0_70 = !free_adr_mask[140];
wire index_l0_71 = !free_adr_mask[142];
wire index_l0_72 = !free_adr_mask[144];
wire index_l0_73 = !free_adr_mask[146];
wire index_l0_74 = !free_adr_mask[148];
wire index_l0_75 = !free_adr_mask[150];
wire index_l0_76 = !free_adr_mask[152];
wire index_l0_77 = !free_adr_mask[154];
wire index_l0_78 = !free_adr_mask[156];
wire index_l0_79 = !free_adr_mask[158];
wire index_l0_80 = !free_adr_mask[160];
wire index_l0_81 = !free_adr_mask[162];
wire index_l0_82 = !free_adr_mask[164];
wire index_l0_83 = !free_adr_mask[166];
wire index_l0_84 = !free_adr_mask[168];
wire index_l0_85 = !free_adr_mask[170];
wire index_l0_86 = !free_adr_mask[172];
wire index_l0_87 = !free_adr_mask[174];
wire index_l0_88 = !free_adr_mask[176];
wire index_l0_89 = !free_adr_mask[178];
wire index_l0_90 = !free_adr_mask[180];
wire index_l0_91 = !free_adr_mask[182];
wire index_l0_92 = !free_adr_mask[184];
wire index_l0_93 = !free_adr_mask[186];
wire index_l0_94 = !free_adr_mask[188];
wire index_l0_95 = !free_adr_mask[190];
wire index_l0_96 = !free_adr_mask[192];
wire index_l0_97 = !free_adr_mask[194];
wire index_l0_98 = !free_adr_mask[196];
wire index_l0_99 = !free_adr_mask[198];
wire index_l0_100 = !free_adr_mask[200];
wire index_l0_101 = !free_adr_mask[202];
wire index_l0_102 = !free_adr_mask[204];
wire index_l0_103 = !free_adr_mask[206];
wire index_l0_104 = !free_adr_mask[208];
wire index_l0_105 = !free_adr_mask[210];
wire index_l0_106 = !free_adr_mask[212];
wire index_l0_107 = !free_adr_mask[214];
wire index_l0_108 = !free_adr_mask[216];
wire index_l0_109 = !free_adr_mask[218];
wire index_l0_110 = !free_adr_mask[220];
wire index_l0_111 = !free_adr_mask[222];
wire index_l0_112 = !free_adr_mask[224];
wire index_l0_113 = !free_adr_mask[226];
wire index_l0_114 = !free_adr_mask[228];
wire index_l0_115 = !free_adr_mask[230];
wire index_l0_116 = !free_adr_mask[232];
wire index_l0_117 = !free_adr_mask[234];
wire index_l0_118 = !free_adr_mask[236];
wire index_l0_119 = !free_adr_mask[238];
wire index_l0_120 = !free_adr_mask[240];
wire index_l0_121 = !free_adr_mask[242];
wire index_l0_122 = !free_adr_mask[244];
wire index_l0_123 = !free_adr_mask[246];
wire index_l0_124 = !free_adr_mask[248];
wire index_l0_125 = !free_adr_mask[250];
wire index_l0_126 = !free_adr_mask[252];
wire index_l0_127 = !free_adr_mask[254];

wire [1:0] index_l1_0 = {!flag_l0_0,(flag_l0_0?index_l0_0:index_l0_1)};
wire [1:0] index_l1_1 = {!flag_l0_2,(flag_l0_2?index_l0_2:index_l0_3)};
wire [1:0] index_l1_2 = {!flag_l0_4,(flag_l0_4?index_l0_4:index_l0_5)};
wire [1:0] index_l1_3 = {!flag_l0_6,(flag_l0_6?index_l0_6:index_l0_7)};
wire [1:0] index_l1_4 = {!flag_l0_8,(flag_l0_8?index_l0_8:index_l0_9)};
wire [1:0] index_l1_5 = {!flag_l0_10,(flag_l0_10?index_l0_10:index_l0_11)};
wire [1:0] index_l1_6 = {!flag_l0_12,(flag_l0_12?index_l0_12:index_l0_13)};
wire [1:0] index_l1_7 = {!flag_l0_14,(flag_l0_14?index_l0_14:index_l0_15)};
wire [1:0] index_l1_8 = {!flag_l0_16,(flag_l0_16?index_l0_16:index_l0_17)};
wire [1:0] index_l1_9 = {!flag_l0_18,(flag_l0_18?index_l0_18:index_l0_19)};
wire [1:0] index_l1_10 = {!flag_l0_20,(flag_l0_20?index_l0_20:index_l0_21)};
wire [1:0] index_l1_11 = {!flag_l0_22,(flag_l0_22?index_l0_22:index_l0_23)};
wire [1:0] index_l1_12 = {!flag_l0_24,(flag_l0_24?index_l0_24:index_l0_25)};
wire [1:0] index_l1_13 = {!flag_l0_26,(flag_l0_26?index_l0_26:index_l0_27)};
wire [1:0] index_l1_14 = {!flag_l0_28,(flag_l0_28?index_l0_28:index_l0_29)};
wire [1:0] index_l1_15 = {!flag_l0_30,(flag_l0_30?index_l0_30:index_l0_31)};
wire [1:0] index_l1_16 = {!flag_l0_32,(flag_l0_32?index_l0_32:index_l0_33)};
wire [1:0] index_l1_17 = {!flag_l0_34,(flag_l0_34?index_l0_34:index_l0_35)};
wire [1:0] index_l1_18 = {!flag_l0_36,(flag_l0_36?index_l0_36:index_l0_37)};
wire [1:0] index_l1_19 = {!flag_l0_38,(flag_l0_38?index_l0_38:index_l0_39)};
wire [1:0] index_l1_20 = {!flag_l0_40,(flag_l0_40?index_l0_40:index_l0_41)};
wire [1:0] index_l1_21 = {!flag_l0_42,(flag_l0_42?index_l0_42:index_l0_43)};
wire [1:0] index_l1_22 = {!flag_l0_44,(flag_l0_44?index_l0_44:index_l0_45)};
wire [1:0] index_l1_23 = {!flag_l0_46,(flag_l0_46?index_l0_46:index_l0_47)};
wire [1:0] index_l1_24 = {!flag_l0_48,(flag_l0_48?index_l0_48:index_l0_49)};
wire [1:0] index_l1_25 = {!flag_l0_50,(flag_l0_50?index_l0_50:index_l0_51)};
wire [1:0] index_l1_26 = {!flag_l0_52,(flag_l0_52?index_l0_52:index_l0_53)};
wire [1:0] index_l1_27 = {!flag_l0_54,(flag_l0_54?index_l0_54:index_l0_55)};
wire [1:0] index_l1_28 = {!flag_l0_56,(flag_l0_56?index_l0_56:index_l0_57)};
wire [1:0] index_l1_29 = {!flag_l0_58,(flag_l0_58?index_l0_58:index_l0_59)};
wire [1:0] index_l1_30 = {!flag_l0_60,(flag_l0_60?index_l0_60:index_l0_61)};
wire [1:0] index_l1_31 = {!flag_l0_62,(flag_l0_62?index_l0_62:index_l0_63)};
wire [1:0] index_l1_32 = {!flag_l0_64,(flag_l0_64?index_l0_64:index_l0_65)};
wire [1:0] index_l1_33 = {!flag_l0_66,(flag_l0_66?index_l0_66:index_l0_67)};
wire [1:0] index_l1_34 = {!flag_l0_68,(flag_l0_68?index_l0_68:index_l0_69)};
wire [1:0] index_l1_35 = {!flag_l0_70,(flag_l0_70?index_l0_70:index_l0_71)};
wire [1:0] index_l1_36 = {!flag_l0_72,(flag_l0_72?index_l0_72:index_l0_73)};
wire [1:0] index_l1_37 = {!flag_l0_74,(flag_l0_74?index_l0_74:index_l0_75)};
wire [1:0] index_l1_38 = {!flag_l0_76,(flag_l0_76?index_l0_76:index_l0_77)};
wire [1:0] index_l1_39 = {!flag_l0_78,(flag_l0_78?index_l0_78:index_l0_79)};
wire [1:0] index_l1_40 = {!flag_l0_80,(flag_l0_80?index_l0_80:index_l0_81)};
wire [1:0] index_l1_41 = {!flag_l0_82,(flag_l0_82?index_l0_82:index_l0_83)};
wire [1:0] index_l1_42 = {!flag_l0_84,(flag_l0_84?index_l0_84:index_l0_85)};
wire [1:0] index_l1_43 = {!flag_l0_86,(flag_l0_86?index_l0_86:index_l0_87)};
wire [1:0] index_l1_44 = {!flag_l0_88,(flag_l0_88?index_l0_88:index_l0_89)};
wire [1:0] index_l1_45 = {!flag_l0_90,(flag_l0_90?index_l0_90:index_l0_91)};
wire [1:0] index_l1_46 = {!flag_l0_92,(flag_l0_92?index_l0_92:index_l0_93)};
wire [1:0] index_l1_47 = {!flag_l0_94,(flag_l0_94?index_l0_94:index_l0_95)};
wire [1:0] index_l1_48 = {!flag_l0_96,(flag_l0_96?index_l0_96:index_l0_97)};
wire [1:0] index_l1_49 = {!flag_l0_98,(flag_l0_98?index_l0_98:index_l0_99)};
wire [1:0] index_l1_50 = {!flag_l0_100,(flag_l0_100?index_l0_100:index_l0_101)};
wire [1:0] index_l1_51 = {!flag_l0_102,(flag_l0_102?index_l0_102:index_l0_103)};
wire [1:0] index_l1_52 = {!flag_l0_104,(flag_l0_104?index_l0_104:index_l0_105)};
wire [1:0] index_l1_53 = {!flag_l0_106,(flag_l0_106?index_l0_106:index_l0_107)};
wire [1:0] index_l1_54 = {!flag_l0_108,(flag_l0_108?index_l0_108:index_l0_109)};
wire [1:0] index_l1_55 = {!flag_l0_110,(flag_l0_110?index_l0_110:index_l0_111)};
wire [1:0] index_l1_56 = {!flag_l0_112,(flag_l0_112?index_l0_112:index_l0_113)};
wire [1:0] index_l1_57 = {!flag_l0_114,(flag_l0_114?index_l0_114:index_l0_115)};
wire [1:0] index_l1_58 = {!flag_l0_116,(flag_l0_116?index_l0_116:index_l0_117)};
wire [1:0] index_l1_59 = {!flag_l0_118,(flag_l0_118?index_l0_118:index_l0_119)};
wire [1:0] index_l1_60 = {!flag_l0_120,(flag_l0_120?index_l0_120:index_l0_121)};
wire [1:0] index_l1_61 = {!flag_l0_122,(flag_l0_122?index_l0_122:index_l0_123)};
wire [1:0] index_l1_62 = {!flag_l0_124,(flag_l0_124?index_l0_124:index_l0_125)};
wire [1:0] index_l1_63 = {!flag_l0_126,(flag_l0_126?index_l0_126:index_l0_127)};

wire [2:0] index_l2_0 = {!flag_l1_0,(flag_l1_0?index_l1_0:index_l1_1)};
wire [2:0] index_l2_1 = {!flag_l1_2,(flag_l1_2?index_l1_2:index_l1_3)};
wire [2:0] index_l2_2 = {!flag_l1_4,(flag_l1_4?index_l1_4:index_l1_5)};
wire [2:0] index_l2_3 = {!flag_l1_6,(flag_l1_6?index_l1_6:index_l1_7)};
wire [2:0] index_l2_4 = {!flag_l1_8,(flag_l1_8?index_l1_8:index_l1_9)};
wire [2:0] index_l2_5 = {!flag_l1_10,(flag_l1_10?index_l1_10:index_l1_11)};
wire [2:0] index_l2_6 = {!flag_l1_12,(flag_l1_12?index_l1_12:index_l1_13)};
wire [2:0] index_l2_7 = {!flag_l1_14,(flag_l1_14?index_l1_14:index_l1_15)};
wire [2:0] index_l2_8 = {!flag_l1_16,(flag_l1_16?index_l1_16:index_l1_17)};
wire [2:0] index_l2_9 = {!flag_l1_18,(flag_l1_18?index_l1_18:index_l1_19)};
wire [2:0] index_l2_10 = {!flag_l1_20,(flag_l1_20?index_l1_20:index_l1_21)};
wire [2:0] index_l2_11 = {!flag_l1_22,(flag_l1_22?index_l1_22:index_l1_23)};
wire [2:0] index_l2_12 = {!flag_l1_24,(flag_l1_24?index_l1_24:index_l1_25)};
wire [2:0] index_l2_13 = {!flag_l1_26,(flag_l1_26?index_l1_26:index_l1_27)};
wire [2:0] index_l2_14 = {!flag_l1_28,(flag_l1_28?index_l1_28:index_l1_29)};
wire [2:0] index_l2_15 = {!flag_l1_30,(flag_l1_30?index_l1_30:index_l1_31)};
wire [2:0] index_l2_16 = {!flag_l1_32,(flag_l1_32?index_l1_32:index_l1_33)};
wire [2:0] index_l2_17 = {!flag_l1_34,(flag_l1_34?index_l1_34:index_l1_35)};
wire [2:0] index_l2_18 = {!flag_l1_36,(flag_l1_36?index_l1_36:index_l1_37)};
wire [2:0] index_l2_19 = {!flag_l1_38,(flag_l1_38?index_l1_38:index_l1_39)};
wire [2:0] index_l2_20 = {!flag_l1_40,(flag_l1_40?index_l1_40:index_l1_41)};
wire [2:0] index_l2_21 = {!flag_l1_42,(flag_l1_42?index_l1_42:index_l1_43)};
wire [2:0] index_l2_22 = {!flag_l1_44,(flag_l1_44?index_l1_44:index_l1_45)};
wire [2:0] index_l2_23 = {!flag_l1_46,(flag_l1_46?index_l1_46:index_l1_47)};
wire [2:0] index_l2_24 = {!flag_l1_48,(flag_l1_48?index_l1_48:index_l1_49)};
wire [2:0] index_l2_25 = {!flag_l1_50,(flag_l1_50?index_l1_50:index_l1_51)};
wire [2:0] index_l2_26 = {!flag_l1_52,(flag_l1_52?index_l1_52:index_l1_53)};
wire [2:0] index_l2_27 = {!flag_l1_54,(flag_l1_54?index_l1_54:index_l1_55)};
wire [2:0] index_l2_28 = {!flag_l1_56,(flag_l1_56?index_l1_56:index_l1_57)};
wire [2:0] index_l2_29 = {!flag_l1_58,(flag_l1_58?index_l1_58:index_l1_59)};
wire [2:0] index_l2_30 = {!flag_l1_60,(flag_l1_60?index_l1_60:index_l1_61)};
wire [2:0] index_l2_31 = {!flag_l1_62,(flag_l1_62?index_l1_62:index_l1_63)};

wire [3:0] index_l3_0 = {!flag_l2_0,(flag_l2_0?index_l2_0:index_l2_1)};
wire [3:0] index_l3_1 = {!flag_l2_2,(flag_l2_2?index_l2_2:index_l2_3)};
wire [3:0] index_l3_2 = {!flag_l2_4,(flag_l2_4?index_l2_4:index_l2_5)};
wire [3:0] index_l3_3 = {!flag_l2_6,(flag_l2_6?index_l2_6:index_l2_7)};
wire [3:0] index_l3_4 = {!flag_l2_8,(flag_l2_8?index_l2_8:index_l2_9)};
wire [3:0] index_l3_5 = {!flag_l2_10,(flag_l2_10?index_l2_10:index_l2_11)};
wire [3:0] index_l3_6 = {!flag_l2_12,(flag_l2_12?index_l2_12:index_l2_13)};
wire [3:0] index_l3_7 = {!flag_l2_14,(flag_l2_14?index_l2_14:index_l2_15)};
wire [3:0] index_l3_8 = {!flag_l2_16,(flag_l2_16?index_l2_16:index_l2_17)};
wire [3:0] index_l3_9 = {!flag_l2_18,(flag_l2_18?index_l2_18:index_l2_19)};
wire [3:0] index_l3_10 = {!flag_l2_20,(flag_l2_20?index_l2_20:index_l2_21)};
wire [3:0] index_l3_11 = {!flag_l2_22,(flag_l2_22?index_l2_22:index_l2_23)};
wire [3:0] index_l3_12 = {!flag_l2_24,(flag_l2_24?index_l2_24:index_l2_25)};
wire [3:0] index_l3_13 = {!flag_l2_26,(flag_l2_26?index_l2_26:index_l2_27)};
wire [3:0] index_l3_14 = {!flag_l2_28,(flag_l2_28?index_l2_28:index_l2_29)};
wire [3:0] index_l3_15 = {!flag_l2_30,(flag_l2_30?index_l2_30:index_l2_31)};

wire [4:0] index_l4_0 = {!flag_l3_0,(flag_l3_0?index_l3_0:index_l3_1)};
wire [4:0] index_l4_1 = {!flag_l3_2,(flag_l3_2?index_l3_2:index_l3_3)};
wire [4:0] index_l4_2 = {!flag_l3_4,(flag_l3_4?index_l3_4:index_l3_5)};
wire [4:0] index_l4_3 = {!flag_l3_6,(flag_l3_6?index_l3_6:index_l3_7)};
wire [4:0] index_l4_4 = {!flag_l3_8,(flag_l3_8?index_l3_8:index_l3_9)};
wire [4:0] index_l4_5 = {!flag_l3_10,(flag_l3_10?index_l3_10:index_l3_11)};
wire [4:0] index_l4_6 = {!flag_l3_12,(flag_l3_12?index_l3_12:index_l3_13)};
wire [4:0] index_l4_7 = {!flag_l3_14,(flag_l3_14?index_l3_14:index_l3_15)};

wire [5:0] index_l5_0 = {!flag_l4_0,(flag_l4_0?index_l4_0:index_l4_1)};
wire [5:0] index_l5_1 = {!flag_l4_2,(flag_l4_2?index_l4_2:index_l4_3)};
wire [5:0] index_l5_2 = {!flag_l4_4,(flag_l4_4?index_l4_4:index_l4_5)};
wire [5:0] index_l5_3 = {!flag_l4_6,(flag_l4_6?index_l4_6:index_l4_7)};

wire [6:0] index_l6_0 = {!flag_l5_0,(flag_l5_0?index_l5_0:index_l5_1)};
wire [6:0] index_l6_1 = {!flag_l5_2,(flag_l5_2?index_l5_2:index_l5_3)};

wire [7:0] index_l7_0 = {!flag_l6_0,(flag_l6_0?index_l6_0:index_l6_1)};

assign free_adr_index[7:0] = index_l7_0[7:0];


assign wr_popping = rd_popping;



//
reg [9:0] cq_rd_credit;			// registered out take credits
reg rd_pushing_q;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd_credit <=  10'd0;
        rd_pushing_q <=  1'b0;
    end else begin
        if ( rd_pushing || rd_pushing_q ) begin
            cq_rd_credit[0] <=  rd_pushing && rd_pushing_thread_id == 4'd0;
            cq_rd_credit[1] <=  rd_pushing && rd_pushing_thread_id == 4'd1;
            cq_rd_credit[2] <=  rd_pushing && rd_pushing_thread_id == 4'd2;
            cq_rd_credit[3] <=  rd_pushing && rd_pushing_thread_id == 4'd3;
            cq_rd_credit[4] <=  rd_pushing && rd_pushing_thread_id == 4'd4;
            cq_rd_credit[5] <=  rd_pushing && rd_pushing_thread_id == 4'd5;
            cq_rd_credit[6] <=  rd_pushing && rd_pushing_thread_id == 4'd6;
            cq_rd_credit[7] <=  rd_pushing && rd_pushing_thread_id == 4'd7;
            cq_rd_credit[8] <=  rd_pushing && rd_pushing_thread_id == 4'd8;
            cq_rd_credit[9] <=  rd_pushing && rd_pushing_thread_id == 4'd9;
            rd_pushing_q <=  rd_pushing;
        end
    end
end
wire rd_pushing0 = rd_pushing && rd_pushing_thread_id == 4'd0;
wire rd_pushing1 = rd_pushing && rd_pushing_thread_id == 4'd1;
wire rd_pushing2 = rd_pushing && rd_pushing_thread_id == 4'd2;
wire rd_pushing3 = rd_pushing && rd_pushing_thread_id == 4'd3;
wire rd_pushing4 = rd_pushing && rd_pushing_thread_id == 4'd4;
wire rd_pushing5 = rd_pushing && rd_pushing_thread_id == 4'd5;
wire rd_pushing6 = rd_pushing && rd_pushing_thread_id == 4'd6;
wire rd_pushing7 = rd_pushing && rd_pushing_thread_id == 4'd7;
wire rd_pushing8 = rd_pushing && rd_pushing_thread_id == 4'd8;
wire rd_pushing9 = rd_pushing && rd_pushing_thread_id == 4'd9;

wire rd_take0 = cq_rd_take && cq_rd_take_thread_id == 4'd0; 
wire rd_take1 = cq_rd_take && cq_rd_take_thread_id == 4'd1; 
wire rd_take2 = cq_rd_take && cq_rd_take_thread_id == 4'd2; 
wire rd_take3 = cq_rd_take && cq_rd_take_thread_id == 4'd3; 
wire rd_take4 = cq_rd_take && cq_rd_take_thread_id == 4'd4; 
wire rd_take5 = cq_rd_take && cq_rd_take_thread_id == 4'd5; 
wire rd_take6 = cq_rd_take && cq_rd_take_thread_id == 4'd6; 
wire rd_take7 = cq_rd_take && cq_rd_take_thread_id == 4'd7; 
wire rd_take8 = cq_rd_take && cq_rd_take_thread_id == 4'd8; 
wire rd_take9 = cq_rd_take && cq_rd_take_thread_id == 4'd9; 


reg [7:0] head0; 
reg [7:0] tail0; 

reg [7:0] head1; 
reg [7:0] tail1; 

reg [7:0] head2; 
reg [7:0] tail2; 

reg [7:0] head3; 
reg [7:0] tail3; 

reg [7:0] head4; 
reg [7:0] tail4; 

reg [7:0] head5; 
reg [7:0] tail5; 

reg [7:0] head6; 
reg [7:0] tail6; 

reg [7:0] head7; 
reg [7:0] tail7; 

reg [7:0] head8; 
reg [7:0] tail8; 

reg [7:0] head9; 
reg [7:0] tail9; 

reg [9:0] rd_take_n_dly;
reg rd_take_dly_cg;
wire update_rd_take_n_dly = cq_rd_take || rd_take_dly_cg; 
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rd_take_dly_cg <=  1'b0;
        rd_take_n_dly <=  {10{1'b0}};
    end else begin
        rd_take_dly_cg <=  cq_rd_take;

        if ( update_rd_take_n_dly ) begin
            rd_take_n_dly <=  {rd_take9,rd_take8,rd_take7,rd_take6,rd_take5,rd_take4,rd_take3,rd_take2,rd_take1,rd_take0};
        end
        //synopsys translate_off
            else if ( !update_rd_take_n_dly) begin
        end else begin
            rd_take_n_dly <=  {10{`x_or_0}};
        end
        //synopsys translate_on

    end
end

reg  [7:0] adr_ram_wr_adr;
wire [7:0] adr_ram_wr_data;
reg        adr_ram_wr_enable;
reg  [7:0] adr_ram_rd_adr;
wire [7:0] adr_ram_rd_data;
reg       adr_ram_rd_enable;

reg  [8:0] cq_rd_count0;
wire [8:0] rd_count0_next;
reg  [8:0] cq_rd_count1;
wire [8:0] rd_count1_next;
reg  [8:0] cq_rd_count2;
wire [8:0] rd_count2_next;
reg  [8:0] cq_rd_count3;
wire [8:0] rd_count3_next;
reg  [8:0] cq_rd_count4;
wire [8:0] rd_count4_next;
reg  [8:0] cq_rd_count5;
wire [8:0] rd_count5_next;
reg  [8:0] cq_rd_count6;
wire [8:0] rd_count6_next;
reg  [8:0] cq_rd_count7;
wire [8:0] rd_count7_next;
reg  [8:0] cq_rd_count8;
wire [8:0] rd_count8_next;
reg  [8:0] cq_rd_count9;
wire [8:0] rd_count9_next;

assign rd_count0_next = 
    rd_pushing0 ? ( rd_take0 ? cq_rd_count0 : cq_rd_count0 + 1'd1 ) : 
                  ( rd_take0 ? cq_rd_count0 - 1'd1 : cq_rd_count0 );
assign rd_count1_next = 
    rd_pushing1 ? ( rd_take1 ? cq_rd_count1 : cq_rd_count1 + 1'd1 ) : 
                  ( rd_take1 ? cq_rd_count1 - 1'd1 : cq_rd_count1 );
assign rd_count2_next = 
    rd_pushing2 ? ( rd_take2 ? cq_rd_count2 : cq_rd_count2 + 1'd1 ) : 
                  ( rd_take2 ? cq_rd_count2 - 1'd1 : cq_rd_count2 );
assign rd_count3_next = 
    rd_pushing3 ? ( rd_take3 ? cq_rd_count3 : cq_rd_count3 + 1'd1 ) : 
                  ( rd_take3 ? cq_rd_count3 - 1'd1 : cq_rd_count3 );
assign rd_count4_next = 
    rd_pushing4 ? ( rd_take4 ? cq_rd_count4 : cq_rd_count4 + 1'd1 ) : 
                  ( rd_take4 ? cq_rd_count4 - 1'd1 : cq_rd_count4 );
assign rd_count5_next = 
    rd_pushing5 ? ( rd_take5 ? cq_rd_count5 : cq_rd_count5 + 1'd1 ) : 
                  ( rd_take5 ? cq_rd_count5 - 1'd1 : cq_rd_count5 );
assign rd_count6_next = 
    rd_pushing6 ? ( rd_take6 ? cq_rd_count6 : cq_rd_count6 + 1'd1 ) : 
                  ( rd_take6 ? cq_rd_count6 - 1'd1 : cq_rd_count6 );
assign rd_count7_next = 
    rd_pushing7 ? ( rd_take7 ? cq_rd_count7 : cq_rd_count7 + 1'd1 ) : 
                  ( rd_take7 ? cq_rd_count7 - 1'd1 : cq_rd_count7 );
assign rd_count8_next = 
    rd_pushing8 ? ( rd_take8 ? cq_rd_count8 : cq_rd_count8 + 1'd1 ) : 
                  ( rd_take8 ? cq_rd_count8 - 1'd1 : cq_rd_count8 );
assign rd_count9_next = 
    rd_pushing9 ? ( rd_take9 ? cq_rd_count9 : cq_rd_count9 + 1'd1 ) : 
                  ( rd_take9 ? cq_rd_count9 - 1'd1 : cq_rd_count9 );
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd_count0 <=  9'd0;
        cq_rd_count1 <=  9'd0;
        cq_rd_count2 <=  9'd0;
        cq_rd_count3 <=  9'd0;
        cq_rd_count4 <=  9'd0;
        cq_rd_count5 <=  9'd0;
        cq_rd_count6 <=  9'd0;
        cq_rd_count7 <=  9'd0;
        cq_rd_count8 <=  9'd0;
        cq_rd_count9 <=  9'd0;
    end else begin
        if ( rd_pushing0 ^ rd_take0 ) begin
            cq_rd_count0 <=  rd_count0_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing0 ^ rd_take0) ) begin
        end else begin
            cq_rd_count0 <=  {9{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing1 ^ rd_take1 ) begin
            cq_rd_count1 <=  rd_count1_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing1 ^ rd_take1) ) begin
        end else begin
            cq_rd_count1 <=  {9{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing2 ^ rd_take2 ) begin
            cq_rd_count2 <=  rd_count2_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing2 ^ rd_take2) ) begin
        end else begin
            cq_rd_count2 <=  {9{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing3 ^ rd_take3 ) begin
            cq_rd_count3 <=  rd_count3_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing3 ^ rd_take3) ) begin
        end else begin
            cq_rd_count3 <=  {9{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing4 ^ rd_take4 ) begin
            cq_rd_count4 <=  rd_count4_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing4 ^ rd_take4) ) begin
        end else begin
            cq_rd_count4 <=  {9{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing5 ^ rd_take5 ) begin
            cq_rd_count5 <=  rd_count5_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing5 ^ rd_take5) ) begin
        end else begin
            cq_rd_count5 <=  {9{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing6 ^ rd_take6 ) begin
            cq_rd_count6 <=  rd_count6_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing6 ^ rd_take6) ) begin
        end else begin
            cq_rd_count6 <=  {9{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing7 ^ rd_take7 ) begin
            cq_rd_count7 <=  rd_count7_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing7 ^ rd_take7) ) begin
        end else begin
            cq_rd_count7 <=  {9{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing8 ^ rd_take8 ) begin
            cq_rd_count8 <=  rd_count8_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing8 ^ rd_take8) ) begin
        end else begin
            cq_rd_count8 <=  {9{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing9 ^ rd_take9 ) begin
            cq_rd_count9 <=  rd_count9_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing9 ^ rd_take9) ) begin
        end else begin
            cq_rd_count9 <=  {9{`x_or_0}};
        end
        //synopsys translate_on

    end
end

reg [9:0] update_head;
wire [9:0] update_head_next;

assign update_head_next[0] = (rd_take0 && cq_rd_count0 > 9'd1) ? 1'b1 : 1'b0; 
assign update_head_next[1] = (rd_take1 && cq_rd_count1 > 9'd1) ? 1'b1 : 1'b0; 
assign update_head_next[2] = (rd_take2 && cq_rd_count2 > 9'd1) ? 1'b1 : 1'b0; 
assign update_head_next[3] = (rd_take3 && cq_rd_count3 > 9'd1) ? 1'b1 : 1'b0; 
assign update_head_next[4] = (rd_take4 && cq_rd_count4 > 9'd1) ? 1'b1 : 1'b0; 
assign update_head_next[5] = (rd_take5 && cq_rd_count5 > 9'd1) ? 1'b1 : 1'b0; 
assign update_head_next[6] = (rd_take6 && cq_rd_count6 > 9'd1) ? 1'b1 : 1'b0; 
assign update_head_next[7] = (rd_take7 && cq_rd_count7 > 9'd1) ? 1'b1 : 1'b0; 
assign update_head_next[8] = (rd_take8 && cq_rd_count8 > 9'd1) ? 1'b1 : 1'b0; 
assign update_head_next[9] = (rd_take9 && cq_rd_count9 > 9'd1) ? 1'b1 : 1'b0; 
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        update_head <=  10'd0;
    end else begin

        if ( rd_pushing || cq_rd_take ) begin
            update_head <=  update_head_next;
        end
        //synopsys translate_off
            else if ( !(rd_pushing || cq_rd_take) ) begin
        end else begin
            update_head <=  {10{`x_or_0}};
        end
        //synopsys translate_on











    end
end

always @(posedge nvdla_core_clk_mgated) begin

    if ( rd_pushing0 ) begin
        tail0 <=  rd_pushing_adr;
    end 
    //synopsys translate_off
        else if ( !rd_pushing0 ) begin
    end else begin
        tail0 <=  {8{`x_or_0}};
    end
    //synopsys translate_on


    if ( (rd_pushing0 && cq_rd_count0 == 9'd0 ) ||
         (rd_pushing0 && rd_take0 && cq_rd_count0 == 9'd1) ) begin
        head0 <=  rd_pushing_adr;
    end else if ( update_head[0] ) begin
        head0 <=  adr_ram_rd_data;
    end


    if ( rd_pushing1 ) begin
        tail1 <=  rd_pushing_adr;
    end 
    //synopsys translate_off
        else if ( !rd_pushing1 ) begin
    end else begin
        tail1 <=  {8{`x_or_0}};
    end
    //synopsys translate_on


    if ( (rd_pushing1 && cq_rd_count1 == 9'd0 ) ||
         (rd_pushing1 && rd_take1 && cq_rd_count1 == 9'd1) ) begin
        head1 <=  rd_pushing_adr;
    end else if ( update_head[1] ) begin
        head1 <=  adr_ram_rd_data;
    end


    if ( rd_pushing2 ) begin
        tail2 <=  rd_pushing_adr;
    end 
    //synopsys translate_off
        else if ( !rd_pushing2 ) begin
    end else begin
        tail2 <=  {8{`x_or_0}};
    end
    //synopsys translate_on


    if ( (rd_pushing2 && cq_rd_count2 == 9'd0 ) ||
         (rd_pushing2 && rd_take2 && cq_rd_count2 == 9'd1) ) begin
        head2 <=  rd_pushing_adr;
    end else if ( update_head[2] ) begin
        head2 <=  adr_ram_rd_data;
    end


    if ( rd_pushing3 ) begin
        tail3 <=  rd_pushing_adr;
    end 
    //synopsys translate_off
        else if ( !rd_pushing3 ) begin
    end else begin
        tail3 <=  {8{`x_or_0}};
    end
    //synopsys translate_on


    if ( (rd_pushing3 && cq_rd_count3 == 9'd0 ) ||
         (rd_pushing3 && rd_take3 && cq_rd_count3 == 9'd1) ) begin
        head3 <=  rd_pushing_adr;
    end else if ( update_head[3] ) begin
        head3 <=  adr_ram_rd_data;
    end


    if ( rd_pushing4 ) begin
        tail4 <=  rd_pushing_adr;
    end 
    //synopsys translate_off
        else if ( !rd_pushing4 ) begin
    end else begin
        tail4 <=  {8{`x_or_0}};
    end
    //synopsys translate_on


    if ( (rd_pushing4 && cq_rd_count4 == 9'd0 ) ||
         (rd_pushing4 && rd_take4 && cq_rd_count4 == 9'd1) ) begin
        head4 <=  rd_pushing_adr;
    end else if ( update_head[4] ) begin
        head4 <=  adr_ram_rd_data;
    end


    if ( rd_pushing5 ) begin
        tail5 <=  rd_pushing_adr;
    end 
    //synopsys translate_off
        else if ( !rd_pushing5 ) begin
    end else begin
        tail5 <=  {8{`x_or_0}};
    end
    //synopsys translate_on


    if ( (rd_pushing5 && cq_rd_count5 == 9'd0 ) ||
         (rd_pushing5 && rd_take5 && cq_rd_count5 == 9'd1) ) begin
        head5 <=  rd_pushing_adr;
    end else if ( update_head[5] ) begin
        head5 <=  adr_ram_rd_data;
    end


    if ( rd_pushing6 ) begin
        tail6 <=  rd_pushing_adr;
    end 
    //synopsys translate_off
        else if ( !rd_pushing6 ) begin
    end else begin
        tail6 <=  {8{`x_or_0}};
    end
    //synopsys translate_on


    if ( (rd_pushing6 && cq_rd_count6 == 9'd0 ) ||
         (rd_pushing6 && rd_take6 && cq_rd_count6 == 9'd1) ) begin
        head6 <=  rd_pushing_adr;
    end else if ( update_head[6] ) begin
        head6 <=  adr_ram_rd_data;
    end


    if ( rd_pushing7 ) begin
        tail7 <=  rd_pushing_adr;
    end 
    //synopsys translate_off
        else if ( !rd_pushing7 ) begin
    end else begin
        tail7 <=  {8{`x_or_0}};
    end
    //synopsys translate_on


    if ( (rd_pushing7 && cq_rd_count7 == 9'd0 ) ||
         (rd_pushing7 && rd_take7 && cq_rd_count7 == 9'd1) ) begin
        head7 <=  rd_pushing_adr;
    end else if ( update_head[7] ) begin
        head7 <=  adr_ram_rd_data;
    end


    if ( rd_pushing8 ) begin
        tail8 <=  rd_pushing_adr;
    end 
    //synopsys translate_off
        else if ( !rd_pushing8 ) begin
    end else begin
        tail8 <=  {8{`x_or_0}};
    end
    //synopsys translate_on


    if ( (rd_pushing8 && cq_rd_count8 == 9'd0 ) ||
         (rd_pushing8 && rd_take8 && cq_rd_count8 == 9'd1) ) begin
        head8 <=  rd_pushing_adr;
    end else if ( update_head[8] ) begin
        head8 <=  adr_ram_rd_data;
    end


    if ( rd_pushing9 ) begin
        tail9 <=  rd_pushing_adr;
    end 
    //synopsys translate_off
        else if ( !rd_pushing9 ) begin
    end else begin
        tail9 <=  {8{`x_or_0}};
    end
    //synopsys translate_on


    if ( (rd_pushing9 && cq_rd_count9 == 9'd0 ) ||
         (rd_pushing9 && rd_take9 && cq_rd_count9 == 9'd1) ) begin
        head9 <=  rd_pushing_adr;
    end else if ( update_head[9] ) begin
        head9 <=  adr_ram_rd_data;
    end

end


nv_ram_rwst_256x8 adr_ram (
      .clk               ( nvdla_core_clk )
    , .wa        ( adr_ram_wr_adr )
    , .we        ( adr_ram_wr_enable  )
    , .di        ( adr_ram_wr_data )
    , .ra        ( adr_ram_rd_adr )
    , .re        ( adr_ram_rd_enable  )
    , .dout        ( adr_ram_rd_data )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    );

assign adr_ram_wr_data = rd_pushing_adr;

always @(*) begin
    case( rd_pushing_thread_id )
        4'd0: adr_ram_wr_adr = tail0;
        4'd1: adr_ram_wr_adr = tail1;
        4'd2: adr_ram_wr_adr = tail2;
        4'd3: adr_ram_wr_adr = tail3;
        4'd4: adr_ram_wr_adr = tail4;
        4'd5: adr_ram_wr_adr = tail5;
        4'd6: adr_ram_wr_adr = tail6;
        4'd7: adr_ram_wr_adr = tail7;
        4'd8: adr_ram_wr_adr = tail8;
        4'd9: adr_ram_wr_adr = tail9;
        //VCS coverage off
        default: adr_ram_wr_adr = {8{`x_or_0}};
        //VCS coverage on
    endcase
end

always @(*) begin
    case( rd_pushing_thread_id )
        4'd0: adr_ram_wr_enable = rd_pushing && cq_rd_count0 != 9'd0 ? 1'b1 : 1'b0;
        4'd1: adr_ram_wr_enable = rd_pushing && cq_rd_count1 != 9'd0 ? 1'b1 : 1'b0;
        4'd2: adr_ram_wr_enable = rd_pushing && cq_rd_count2 != 9'd0 ? 1'b1 : 1'b0;
        4'd3: adr_ram_wr_enable = rd_pushing && cq_rd_count3 != 9'd0 ? 1'b1 : 1'b0;
        4'd4: adr_ram_wr_enable = rd_pushing && cq_rd_count4 != 9'd0 ? 1'b1 : 1'b0;
        4'd5: adr_ram_wr_enable = rd_pushing && cq_rd_count5 != 9'd0 ? 1'b1 : 1'b0;
        4'd6: adr_ram_wr_enable = rd_pushing && cq_rd_count6 != 9'd0 ? 1'b1 : 1'b0;
        4'd7: adr_ram_wr_enable = rd_pushing && cq_rd_count7 != 9'd0 ? 1'b1 : 1'b0;
        4'd8: adr_ram_wr_enable = rd_pushing && cq_rd_count8 != 9'd0 ? 1'b1 : 1'b0;
        4'd9: adr_ram_wr_enable = rd_pushing && cq_rd_count9 != 9'd0 ? 1'b1 : 1'b0;
        //VCS coverage off
        default: adr_ram_wr_enable = !rd_pushing ? 1'b0 : `x_or_0;
        //VCS coverage on
    endcase
end
                    
always @(*) begin
    case( cq_rd_take_thread_id )
        4'd0: adr_ram_rd_enable = cq_rd_take && cq_rd_count0 != 9'd0 ? 1'b1 : 1'b0;
        4'd1: adr_ram_rd_enable = cq_rd_take && cq_rd_count1 != 9'd0 ? 1'b1 : 1'b0;
        4'd2: adr_ram_rd_enable = cq_rd_take && cq_rd_count2 != 9'd0 ? 1'b1 : 1'b0;
        4'd3: adr_ram_rd_enable = cq_rd_take && cq_rd_count3 != 9'd0 ? 1'b1 : 1'b0;
        4'd4: adr_ram_rd_enable = cq_rd_take && cq_rd_count4 != 9'd0 ? 1'b1 : 1'b0;
        4'd5: adr_ram_rd_enable = cq_rd_take && cq_rd_count5 != 9'd0 ? 1'b1 : 1'b0;
        4'd6: adr_ram_rd_enable = cq_rd_take && cq_rd_count6 != 9'd0 ? 1'b1 : 1'b0;
        4'd7: adr_ram_rd_enable = cq_rd_take && cq_rd_count7 != 9'd0 ? 1'b1 : 1'b0;
        4'd8: adr_ram_rd_enable = cq_rd_take && cq_rd_count8 != 9'd0 ? 1'b1 : 1'b0;
        4'd9: adr_ram_rd_enable = cq_rd_take && cq_rd_count9 != 9'd0 ? 1'b1 : 1'b0;
        //VCS coverage off
        default: adr_ram_rd_enable = !cq_rd_take ? 1'b0 : `x_or_0;
        //VCS coverage on
    endcase
end 

always @(*) begin
    case( cq_rd_take_thread_id )
        4'd0: adr_ram_rd_adr = rd_take_n_dly[0] && update_head[0] ? adr_ram_rd_data : head0;
        4'd1: adr_ram_rd_adr = rd_take_n_dly[1] && update_head[1] ? adr_ram_rd_data : head1;
        4'd2: adr_ram_rd_adr = rd_take_n_dly[2] && update_head[2] ? adr_ram_rd_data : head2;
        4'd3: adr_ram_rd_adr = rd_take_n_dly[3] && update_head[3] ? adr_ram_rd_data : head3;
        4'd4: adr_ram_rd_adr = rd_take_n_dly[4] && update_head[4] ? adr_ram_rd_data : head4;
        4'd5: adr_ram_rd_adr = rd_take_n_dly[5] && update_head[5] ? adr_ram_rd_data : head5;
        4'd6: adr_ram_rd_adr = rd_take_n_dly[6] && update_head[6] ? adr_ram_rd_data : head6;
        4'd7: adr_ram_rd_adr = rd_take_n_dly[7] && update_head[7] ? adr_ram_rd_data : head7;
        4'd8: adr_ram_rd_adr = rd_take_n_dly[8] && update_head[8] ? adr_ram_rd_data : head8;
        4'd9: adr_ram_rd_adr = rd_take_n_dly[9] && update_head[9] ? adr_ram_rd_data : head9;
        //VCS coverage off
        default: adr_ram_rd_adr = {8{`x_or_0}};
        //VCS coverage on
    endcase
end

always @(*) begin
    case( cq_rd_take_thread_id )
        4'd0: cq_rd_adr = rd_take_n_dly[0] && update_head[0] ? adr_ram_rd_data : head0;
        4'd1: cq_rd_adr = rd_take_n_dly[1] && update_head[1] ? adr_ram_rd_data : head1;
        4'd2: cq_rd_adr = rd_take_n_dly[2] && update_head[2] ? adr_ram_rd_data : head2;
        4'd3: cq_rd_adr = rd_take_n_dly[3] && update_head[3] ? adr_ram_rd_data : head3;
        4'd4: cq_rd_adr = rd_take_n_dly[4] && update_head[4] ? adr_ram_rd_data : head4;
        4'd5: cq_rd_adr = rd_take_n_dly[5] && update_head[5] ? adr_ram_rd_data : head5;
        4'd6: cq_rd_adr = rd_take_n_dly[6] && update_head[6] ? adr_ram_rd_data : head6;
        4'd7: cq_rd_adr = rd_take_n_dly[7] && update_head[7] ? adr_ram_rd_data : head7;
        4'd8: cq_rd_adr = rd_take_n_dly[8] && update_head[8] ? adr_ram_rd_data : head8;
        4'd9: cq_rd_adr = rd_take_n_dly[9] && update_head[9] ? adr_ram_rd_data : head9;
        //VCS coverage off
        default: cq_rd_adr = {8{`x_or_0}};
        //VCS coverage on
    endcase
end


//
//
reg rd_take_dly;
assign rd_popping = rd_take_dly;

reg [7:0] rd_adr_dly;
assign rd_popping_adr = rd_adr_dly;
assign rd_enable  = cq_rd_take;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rd_take_dly <=  1'b0;
    end else begin
        rd_take_dly <=  cq_rd_take;
    end
end

always @( posedge nvdla_core_clk_mgated ) begin
    if ( cq_rd_take ) begin
        rd_adr_dly <=  cq_rd_adr;
    end 
    //synopsys translate_off
        else if ( !(cq_rd_take) ) begin
    end else begin
        rd_adr_dly <=  {8{`x_or_0}};
    end
    //synopsys translate_on
 
end


//

wire [9:0] cq_rd_take_elig;   

wire rd_pre_bypassing0;          
wire rd_bypassing0;              
reg  [6:0] rd_skid0_0;     
reg  [6:0] rd_skid0_1;     
reg  [6:0] rd_skid0_2;     
reg  rd_skid0_0_vld;             
reg  rd_skid0_1_vld;             
reg  rd_skid0_2_vld;             

reg  cq_rd0_prdy_d;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd0_prdy_d <=  1'b1;
    end else begin

        cq_rd0_prdy_d <=  cq_rd0_prdy;
    end
end

assign cq_rd0_pvld = rd_skid0_0_vld || rd_pre_bypassing0;  			
assign cq_rd0_pd = rd_skid0_0_vld ? rd_skid0_0 : cq_wr_pd;        

always @( posedge nvdla_core_clk_mgated_skid ) begin
    if ( (rd_bypassing0 || rd_take_n_dly[0]) && (!rd_skid0_0_vld || (cq_rd0_pvld && cq_rd0_prdy && !rd_skid0_1_vld)) ) begin
        rd_skid0_0 <=  rd_take_n_dly[0] ? cq_rd_pd_p : cq_wr_pd;
    end else if ( cq_rd0_pvld && cq_rd0_prdy && rd_skid0_1_vld ) begin
        rd_skid0_0 <=  rd_skid0_1;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing0 || rd_take_n_dly[0]) && (!rd_skid0_0_vld || (cq_rd0_pvld && cq_rd0_prdy && !rd_skid0_1_vld))) && 
                  !(cq_rd0_pvld && cq_rd0_prdy && rd_skid0_1_vld) ) begin
    end else begin
        rd_skid0_0 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

    if ( (rd_bypassing0 || rd_take_n_dly[0]) && (!rd_skid0_1_vld || (cq_rd0_pvld && cq_rd0_prdy && !rd_skid0_2_vld)) ) begin
        rd_skid0_1 <=  rd_bypassing0 ? cq_wr_pd : cq_rd_pd_p;
    end else if ( cq_rd0_pvld && cq_rd0_prdy && rd_skid0_2_vld ) begin
        rd_skid0_1 <=  rd_skid0_2;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing0 || rd_take_n_dly[0]) && (!rd_skid0_1_vld || (cq_rd0_pvld && cq_rd0_prdy && !rd_skid0_2_vld))) && 
                  !(cq_rd0_pvld && cq_rd0_prdy && rd_skid0_2_vld) ) begin
    end else begin
        rd_skid0_1 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

    if ( (rd_bypassing0 || rd_take_n_dly[0]) && rd_skid0_0_vld && rd_skid0_1_vld && (rd_skid0_2_vld || !(cq_rd0_pvld && cq_rd0_prdy)) ) begin
        rd_skid0_2 <=  rd_bypassing0 ? cq_wr_pd : cq_rd_pd_p;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing0 || rd_take_n_dly[0]) && rd_skid0_0_vld && rd_skid0_1_vld && (rd_skid0_2_vld || !(cq_rd0_pvld && cq_rd0_prdy))) ) begin 
    end else begin
        rd_skid0_2 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

end

always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rd_skid0_0_vld <=  1'b0;
        rd_skid0_1_vld <=  1'b0;
        rd_skid0_2_vld <=  1'b0;
    end else begin
        rd_skid0_0_vld <=  (cq_rd0_pvld && cq_rd0_prdy) ? (rd_skid0_1_vld || (rd_bypassing0 && rd_skid0_0_vld) || rd_take_n_dly[0]) : (rd_skid0_0_vld || rd_bypassing0 || rd_take_n_dly[0]);
	rd_skid0_1_vld <=  (cq_rd0_pvld && cq_rd0_prdy) ? (rd_skid0_2_vld || (rd_skid0_1_vld && (rd_bypassing0 || rd_take_n_dly[0]))) : (rd_skid0_1_vld || (rd_skid0_0_vld && (rd_bypassing0 || rd_take_n_dly[0])));
        //VCS coverage off
	rd_skid0_2_vld <=  (cq_rd0_pvld && cq_rd0_prdy) ? (rd_skid0_2_vld && (rd_bypassing0 || rd_take_n_dly[0])) : (rd_skid0_2_vld || (rd_skid0_1_vld && (rd_bypassing0 || rd_take_n_dly[0])));
        //VCS coverage on
    end
end

// spyglass disable_block W164a W116 W484
reg  [8:0] cq_rd0_credits;   
reg             cq_rd0_credits_ne0; 
wire [8:0] cq_rd0_credits_w_take_next  =  cq_rd0_credits + cq_rd_credit[0] - 1'b1;
wire [8:0] cq_rd0_credits_wo_take_next =  cq_rd0_credits + cq_rd_credit[0];
wire [8:0] cq_rd0_credits_next =  rd_take0 ? cq_rd0_credits_w_take_next : cq_rd0_credits_wo_take_next; 
// spyglass enable_block W164a W116 W484

//VCS coverage off
assign cq_rd_take_elig[0] = (cq_rd0_prdy_d || !rd_skid0_0_vld || !rd_skid0_1_vld || (!rd_skid0_2_vld && !rd_take_n_dly[0])) && (cq_rd_credit[0] || cq_rd0_credits_ne0);
//VCS coverage on

assign rd_pre_bypassing0 = cq_wr_pvld && !cq_wr_busy_int && (cq_wr_thread_id == 4'd0) && cq_rd0_credits == 0 && !cq_rd_credit[0] && (!rd_take_n_dly[0] || rd_skid0_0_vld); 
assign rd_bypassing0 = rd_pre_bypassing0 && (!rd_skid0_2_vld || !rd_skid0_1_vld || !(!cq_rd0_prdy_d && rd_skid0_0_vld && rd_skid0_1_vld)) && !rd_take_n_dly[0];
always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd0_credits <=  9'd0;
        cq_rd0_credits_ne0 <=  1'b0;
    end else begin
        if ( cq_rd_credit[0] |  rd_take0 ) begin
            cq_rd0_credits <=  cq_rd0_credits_next;
            cq_rd0_credits_ne0 <=  rd_take0 ? (cq_rd0_credits_w_take_next != 0) : (cq_rd0_credits_wo_take_next != 0);
        end
        //synopsys translate_off
            else if ( ! (cq_rd_credit[0] |  rd_take0) ) begin
        end else begin
            cq_rd0_credits <=  {9{`x_or_0}};
            cq_rd0_credits_ne0 <=  `x_or_0; 
        end
        //synopsys translate_on

    end
end

wire rd_pre_bypassing1;          
wire rd_bypassing1;              
reg  [6:0] rd_skid1_0;     
reg  [6:0] rd_skid1_1;     
reg  [6:0] rd_skid1_2;     
reg  rd_skid1_0_vld;             
reg  rd_skid1_1_vld;             
reg  rd_skid1_2_vld;             

reg  cq_rd1_prdy_d;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd1_prdy_d <=  1'b1;
    end else begin

        cq_rd1_prdy_d <=  cq_rd1_prdy;
    end
end

assign cq_rd1_pvld = rd_skid1_0_vld || rd_pre_bypassing1;  			
assign cq_rd1_pd = rd_skid1_0_vld ? rd_skid1_0 : cq_wr_pd;        

always @( posedge nvdla_core_clk_mgated_skid ) begin
    if ( (rd_bypassing1 || rd_take_n_dly[1]) && (!rd_skid1_0_vld || (cq_rd1_pvld && cq_rd1_prdy && !rd_skid1_1_vld)) ) begin
        rd_skid1_0 <=  rd_take_n_dly[1] ? cq_rd_pd_p : cq_wr_pd;
    end else if ( cq_rd1_pvld && cq_rd1_prdy && rd_skid1_1_vld ) begin
        rd_skid1_0 <=  rd_skid1_1;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing1 || rd_take_n_dly[1]) && (!rd_skid1_0_vld || (cq_rd1_pvld && cq_rd1_prdy && !rd_skid1_1_vld))) && 
                  !(cq_rd1_pvld && cq_rd1_prdy && rd_skid1_1_vld) ) begin
    end else begin
        rd_skid1_0 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

    if ( (rd_bypassing1 || rd_take_n_dly[1]) && (!rd_skid1_1_vld || (cq_rd1_pvld && cq_rd1_prdy && !rd_skid1_2_vld)) ) begin
        rd_skid1_1 <=  rd_bypassing1 ? cq_wr_pd : cq_rd_pd_p;
    end else if ( cq_rd1_pvld && cq_rd1_prdy && rd_skid1_2_vld ) begin
        rd_skid1_1 <=  rd_skid1_2;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing1 || rd_take_n_dly[1]) && (!rd_skid1_1_vld || (cq_rd1_pvld && cq_rd1_prdy && !rd_skid1_2_vld))) && 
                  !(cq_rd1_pvld && cq_rd1_prdy && rd_skid1_2_vld) ) begin
    end else begin
        rd_skid1_1 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

    if ( (rd_bypassing1 || rd_take_n_dly[1]) && rd_skid1_0_vld && rd_skid1_1_vld && (rd_skid1_2_vld || !(cq_rd1_pvld && cq_rd1_prdy)) ) begin
        rd_skid1_2 <=  rd_bypassing1 ? cq_wr_pd : cq_rd_pd_p;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing1 || rd_take_n_dly[1]) && rd_skid1_0_vld && rd_skid1_1_vld && (rd_skid1_2_vld || !(cq_rd1_pvld && cq_rd1_prdy))) ) begin 
    end else begin
        rd_skid1_2 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

end

always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rd_skid1_0_vld <=  1'b0;
        rd_skid1_1_vld <=  1'b0;
        rd_skid1_2_vld <=  1'b0;
    end else begin
        rd_skid1_0_vld <=  (cq_rd1_pvld && cq_rd1_prdy) ? (rd_skid1_1_vld || (rd_bypassing1 && rd_skid1_0_vld) || rd_take_n_dly[1]) : (rd_skid1_0_vld || rd_bypassing1 || rd_take_n_dly[1]);
	rd_skid1_1_vld <=  (cq_rd1_pvld && cq_rd1_prdy) ? (rd_skid1_2_vld || (rd_skid1_1_vld && (rd_bypassing1 || rd_take_n_dly[1]))) : (rd_skid1_1_vld || (rd_skid1_0_vld && (rd_bypassing1 || rd_take_n_dly[1])));
        //VCS coverage off
	rd_skid1_2_vld <=  (cq_rd1_pvld && cq_rd1_prdy) ? (rd_skid1_2_vld && (rd_bypassing1 || rd_take_n_dly[1])) : (rd_skid1_2_vld || (rd_skid1_1_vld && (rd_bypassing1 || rd_take_n_dly[1])));
        //VCS coverage on
    end
end

// spyglass disable_block W164a W116 W484
reg  [8:0] cq_rd1_credits;   
reg             cq_rd1_credits_ne0; 
wire [8:0] cq_rd1_credits_w_take_next  =  cq_rd1_credits + cq_rd_credit[1] - 1'b1;
wire [8:0] cq_rd1_credits_wo_take_next =  cq_rd1_credits + cq_rd_credit[1];
wire [8:0] cq_rd1_credits_next =  rd_take1 ? cq_rd1_credits_w_take_next : cq_rd1_credits_wo_take_next; 
// spyglass enable_block W164a W116 W484

//VCS coverage off
assign cq_rd_take_elig[1] = (cq_rd1_prdy_d || !rd_skid1_0_vld || !rd_skid1_1_vld || (!rd_skid1_2_vld && !rd_take_n_dly[1])) && (cq_rd_credit[1] || cq_rd1_credits_ne0);
//VCS coverage on

assign rd_pre_bypassing1 = cq_wr_pvld && !cq_wr_busy_int && (cq_wr_thread_id == 4'd1) && cq_rd1_credits == 0 && !cq_rd_credit[1] && (!rd_take_n_dly[1] || rd_skid1_0_vld); 
assign rd_bypassing1 = rd_pre_bypassing1 && (!rd_skid1_2_vld || !rd_skid1_1_vld || !(!cq_rd1_prdy_d && rd_skid1_0_vld && rd_skid1_1_vld)) && !rd_take_n_dly[1];
always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd1_credits <=  9'd0;
        cq_rd1_credits_ne0 <=  1'b0;
    end else begin
        if ( cq_rd_credit[1] |  rd_take1 ) begin
            cq_rd1_credits <=  cq_rd1_credits_next;
            cq_rd1_credits_ne0 <=  rd_take1 ? (cq_rd1_credits_w_take_next != 0) : (cq_rd1_credits_wo_take_next != 0);
        end
        //synopsys translate_off
            else if ( ! (cq_rd_credit[1] |  rd_take1) ) begin
        end else begin
            cq_rd1_credits <=  {9{`x_or_0}};
            cq_rd1_credits_ne0 <=  `x_or_0; 
        end
        //synopsys translate_on

    end
end

wire rd_pre_bypassing2;          
wire rd_bypassing2;              
reg  [6:0] rd_skid2_0;     
reg  [6:0] rd_skid2_1;     
reg  [6:0] rd_skid2_2;     
reg  rd_skid2_0_vld;             
reg  rd_skid2_1_vld;             
reg  rd_skid2_2_vld;             

reg  cq_rd2_prdy_d;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd2_prdy_d <=  1'b1;
    end else begin

        cq_rd2_prdy_d <=  cq_rd2_prdy;
    end
end

assign cq_rd2_pvld = rd_skid2_0_vld || rd_pre_bypassing2;  			
assign cq_rd2_pd = rd_skid2_0_vld ? rd_skid2_0 : cq_wr_pd;        

always @( posedge nvdla_core_clk_mgated_skid ) begin
    if ( (rd_bypassing2 || rd_take_n_dly[2]) && (!rd_skid2_0_vld || (cq_rd2_pvld && cq_rd2_prdy && !rd_skid2_1_vld)) ) begin
        rd_skid2_0 <=  rd_take_n_dly[2] ? cq_rd_pd_p : cq_wr_pd;
    end else if ( cq_rd2_pvld && cq_rd2_prdy && rd_skid2_1_vld ) begin
        rd_skid2_0 <=  rd_skid2_1;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing2 || rd_take_n_dly[2]) && (!rd_skid2_0_vld || (cq_rd2_pvld && cq_rd2_prdy && !rd_skid2_1_vld))) && 
                  !(cq_rd2_pvld && cq_rd2_prdy && rd_skid2_1_vld) ) begin
    end else begin
        rd_skid2_0 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

    if ( (rd_bypassing2 || rd_take_n_dly[2]) && (!rd_skid2_1_vld || (cq_rd2_pvld && cq_rd2_prdy && !rd_skid2_2_vld)) ) begin
        rd_skid2_1 <=  rd_bypassing2 ? cq_wr_pd : cq_rd_pd_p;
    end else if ( cq_rd2_pvld && cq_rd2_prdy && rd_skid2_2_vld ) begin
        rd_skid2_1 <=  rd_skid2_2;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing2 || rd_take_n_dly[2]) && (!rd_skid2_1_vld || (cq_rd2_pvld && cq_rd2_prdy && !rd_skid2_2_vld))) && 
                  !(cq_rd2_pvld && cq_rd2_prdy && rd_skid2_2_vld) ) begin
    end else begin
        rd_skid2_1 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

    if ( (rd_bypassing2 || rd_take_n_dly[2]) && rd_skid2_0_vld && rd_skid2_1_vld && (rd_skid2_2_vld || !(cq_rd2_pvld && cq_rd2_prdy)) ) begin
        rd_skid2_2 <=  rd_bypassing2 ? cq_wr_pd : cq_rd_pd_p;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing2 || rd_take_n_dly[2]) && rd_skid2_0_vld && rd_skid2_1_vld && (rd_skid2_2_vld || !(cq_rd2_pvld && cq_rd2_prdy))) ) begin 
    end else begin
        rd_skid2_2 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

end

always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rd_skid2_0_vld <=  1'b0;
        rd_skid2_1_vld <=  1'b0;
        rd_skid2_2_vld <=  1'b0;
    end else begin
        rd_skid2_0_vld <=  (cq_rd2_pvld && cq_rd2_prdy) ? (rd_skid2_1_vld || (rd_bypassing2 && rd_skid2_0_vld) || rd_take_n_dly[2]) : (rd_skid2_0_vld || rd_bypassing2 || rd_take_n_dly[2]);
	rd_skid2_1_vld <=  (cq_rd2_pvld && cq_rd2_prdy) ? (rd_skid2_2_vld || (rd_skid2_1_vld && (rd_bypassing2 || rd_take_n_dly[2]))) : (rd_skid2_1_vld || (rd_skid2_0_vld && (rd_bypassing2 || rd_take_n_dly[2])));
        //VCS coverage off
	rd_skid2_2_vld <=  (cq_rd2_pvld && cq_rd2_prdy) ? (rd_skid2_2_vld && (rd_bypassing2 || rd_take_n_dly[2])) : (rd_skid2_2_vld || (rd_skid2_1_vld && (rd_bypassing2 || rd_take_n_dly[2])));
        //VCS coverage on
    end
end

// spyglass disable_block W164a W116 W484
reg  [8:0] cq_rd2_credits;   
reg             cq_rd2_credits_ne0; 
wire [8:0] cq_rd2_credits_w_take_next  =  cq_rd2_credits + cq_rd_credit[2] - 1'b1;
wire [8:0] cq_rd2_credits_wo_take_next =  cq_rd2_credits + cq_rd_credit[2];
wire [8:0] cq_rd2_credits_next =  rd_take2 ? cq_rd2_credits_w_take_next : cq_rd2_credits_wo_take_next; 
// spyglass enable_block W164a W116 W484

//VCS coverage off
assign cq_rd_take_elig[2] = (cq_rd2_prdy_d || !rd_skid2_0_vld || !rd_skid2_1_vld || (!rd_skid2_2_vld && !rd_take_n_dly[2])) && (cq_rd_credit[2] || cq_rd2_credits_ne0);
//VCS coverage on

assign rd_pre_bypassing2 = cq_wr_pvld && !cq_wr_busy_int && (cq_wr_thread_id == 4'd2) && cq_rd2_credits == 0 && !cq_rd_credit[2] && (!rd_take_n_dly[2] || rd_skid2_0_vld); 
assign rd_bypassing2 = rd_pre_bypassing2 && (!rd_skid2_2_vld || !rd_skid2_1_vld || !(!cq_rd2_prdy_d && rd_skid2_0_vld && rd_skid2_1_vld)) && !rd_take_n_dly[2];
always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd2_credits <=  9'd0;
        cq_rd2_credits_ne0 <=  1'b0;
    end else begin
        if ( cq_rd_credit[2] |  rd_take2 ) begin
            cq_rd2_credits <=  cq_rd2_credits_next;
            cq_rd2_credits_ne0 <=  rd_take2 ? (cq_rd2_credits_w_take_next != 0) : (cq_rd2_credits_wo_take_next != 0);
        end
        //synopsys translate_off
            else if ( ! (cq_rd_credit[2] |  rd_take2) ) begin
        end else begin
            cq_rd2_credits <=  {9{`x_or_0}};
            cq_rd2_credits_ne0 <=  `x_or_0; 
        end
        //synopsys translate_on

    end
end

wire rd_pre_bypassing3;          
wire rd_bypassing3;              
reg  [6:0] rd_skid3_0;     
reg  [6:0] rd_skid3_1;     
reg  [6:0] rd_skid3_2;     
reg  rd_skid3_0_vld;             
reg  rd_skid3_1_vld;             
reg  rd_skid3_2_vld;             

reg  cq_rd3_prdy_d;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd3_prdy_d <=  1'b1;
    end else begin

        cq_rd3_prdy_d <=  cq_rd3_prdy;
    end
end

assign cq_rd3_pvld = rd_skid3_0_vld || rd_pre_bypassing3;  			
assign cq_rd3_pd = rd_skid3_0_vld ? rd_skid3_0 : cq_wr_pd;        

always @( posedge nvdla_core_clk_mgated_skid ) begin
    if ( (rd_bypassing3 || rd_take_n_dly[3]) && (!rd_skid3_0_vld || (cq_rd3_pvld && cq_rd3_prdy && !rd_skid3_1_vld)) ) begin
        rd_skid3_0 <=  rd_take_n_dly[3] ? cq_rd_pd_p : cq_wr_pd;
    end else if ( cq_rd3_pvld && cq_rd3_prdy && rd_skid3_1_vld ) begin
        rd_skid3_0 <=  rd_skid3_1;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing3 || rd_take_n_dly[3]) && (!rd_skid3_0_vld || (cq_rd3_pvld && cq_rd3_prdy && !rd_skid3_1_vld))) && 
                  !(cq_rd3_pvld && cq_rd3_prdy && rd_skid3_1_vld) ) begin
    end else begin
        rd_skid3_0 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

    if ( (rd_bypassing3 || rd_take_n_dly[3]) && (!rd_skid3_1_vld || (cq_rd3_pvld && cq_rd3_prdy && !rd_skid3_2_vld)) ) begin
        rd_skid3_1 <=  rd_bypassing3 ? cq_wr_pd : cq_rd_pd_p;
    end else if ( cq_rd3_pvld && cq_rd3_prdy && rd_skid3_2_vld ) begin
        rd_skid3_1 <=  rd_skid3_2;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing3 || rd_take_n_dly[3]) && (!rd_skid3_1_vld || (cq_rd3_pvld && cq_rd3_prdy && !rd_skid3_2_vld))) && 
                  !(cq_rd3_pvld && cq_rd3_prdy && rd_skid3_2_vld) ) begin
    end else begin
        rd_skid3_1 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

    if ( (rd_bypassing3 || rd_take_n_dly[3]) && rd_skid3_0_vld && rd_skid3_1_vld && (rd_skid3_2_vld || !(cq_rd3_pvld && cq_rd3_prdy)) ) begin
        rd_skid3_2 <=  rd_bypassing3 ? cq_wr_pd : cq_rd_pd_p;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing3 || rd_take_n_dly[3]) && rd_skid3_0_vld && rd_skid3_1_vld && (rd_skid3_2_vld || !(cq_rd3_pvld && cq_rd3_prdy))) ) begin 
    end else begin
        rd_skid3_2 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

end

always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rd_skid3_0_vld <=  1'b0;
        rd_skid3_1_vld <=  1'b0;
        rd_skid3_2_vld <=  1'b0;
    end else begin
        rd_skid3_0_vld <=  (cq_rd3_pvld && cq_rd3_prdy) ? (rd_skid3_1_vld || (rd_bypassing3 && rd_skid3_0_vld) || rd_take_n_dly[3]) : (rd_skid3_0_vld || rd_bypassing3 || rd_take_n_dly[3]);
	rd_skid3_1_vld <=  (cq_rd3_pvld && cq_rd3_prdy) ? (rd_skid3_2_vld || (rd_skid3_1_vld && (rd_bypassing3 || rd_take_n_dly[3]))) : (rd_skid3_1_vld || (rd_skid3_0_vld && (rd_bypassing3 || rd_take_n_dly[3])));
        //VCS coverage off
	rd_skid3_2_vld <=  (cq_rd3_pvld && cq_rd3_prdy) ? (rd_skid3_2_vld && (rd_bypassing3 || rd_take_n_dly[3])) : (rd_skid3_2_vld || (rd_skid3_1_vld && (rd_bypassing3 || rd_take_n_dly[3])));
        //VCS coverage on
    end
end

// spyglass disable_block W164a W116 W484
reg  [8:0] cq_rd3_credits;   
reg             cq_rd3_credits_ne0; 
wire [8:0] cq_rd3_credits_w_take_next  =  cq_rd3_credits + cq_rd_credit[3] - 1'b1;
wire [8:0] cq_rd3_credits_wo_take_next =  cq_rd3_credits + cq_rd_credit[3];
wire [8:0] cq_rd3_credits_next =  rd_take3 ? cq_rd3_credits_w_take_next : cq_rd3_credits_wo_take_next; 
// spyglass enable_block W164a W116 W484

//VCS coverage off
assign cq_rd_take_elig[3] = (cq_rd3_prdy_d || !rd_skid3_0_vld || !rd_skid3_1_vld || (!rd_skid3_2_vld && !rd_take_n_dly[3])) && (cq_rd_credit[3] || cq_rd3_credits_ne0);
//VCS coverage on

assign rd_pre_bypassing3 = cq_wr_pvld && !cq_wr_busy_int && (cq_wr_thread_id == 4'd3) && cq_rd3_credits == 0 && !cq_rd_credit[3] && (!rd_take_n_dly[3] || rd_skid3_0_vld); 
assign rd_bypassing3 = rd_pre_bypassing3 && (!rd_skid3_2_vld || !rd_skid3_1_vld || !(!cq_rd3_prdy_d && rd_skid3_0_vld && rd_skid3_1_vld)) && !rd_take_n_dly[3];
always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd3_credits <=  9'd0;
        cq_rd3_credits_ne0 <=  1'b0;
    end else begin
        if ( cq_rd_credit[3] |  rd_take3 ) begin
            cq_rd3_credits <=  cq_rd3_credits_next;
            cq_rd3_credits_ne0 <=  rd_take3 ? (cq_rd3_credits_w_take_next != 0) : (cq_rd3_credits_wo_take_next != 0);
        end
        //synopsys translate_off
            else if ( ! (cq_rd_credit[3] |  rd_take3) ) begin
        end else begin
            cq_rd3_credits <=  {9{`x_or_0}};
            cq_rd3_credits_ne0 <=  `x_or_0; 
        end
        //synopsys translate_on

    end
end

wire rd_pre_bypassing4;          
wire rd_bypassing4;              
reg  [6:0] rd_skid4_0;     
reg  [6:0] rd_skid4_1;     
reg  [6:0] rd_skid4_2;     
reg  rd_skid4_0_vld;             
reg  rd_skid4_1_vld;             
reg  rd_skid4_2_vld;             

reg  cq_rd4_prdy_d;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd4_prdy_d <=  1'b1;
    end else begin

        cq_rd4_prdy_d <=  cq_rd4_prdy;
    end
end

assign cq_rd4_pvld = rd_skid4_0_vld || rd_pre_bypassing4;  			
assign cq_rd4_pd = rd_skid4_0_vld ? rd_skid4_0 : cq_wr_pd;        

always @( posedge nvdla_core_clk_mgated_skid ) begin
    if ( (rd_bypassing4 || rd_take_n_dly[4]) && (!rd_skid4_0_vld || (cq_rd4_pvld && cq_rd4_prdy && !rd_skid4_1_vld)) ) begin
        rd_skid4_0 <=  rd_take_n_dly[4] ? cq_rd_pd_p : cq_wr_pd;
    end else if ( cq_rd4_pvld && cq_rd4_prdy && rd_skid4_1_vld ) begin
        rd_skid4_0 <=  rd_skid4_1;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing4 || rd_take_n_dly[4]) && (!rd_skid4_0_vld || (cq_rd4_pvld && cq_rd4_prdy && !rd_skid4_1_vld))) && 
                  !(cq_rd4_pvld && cq_rd4_prdy && rd_skid4_1_vld) ) begin
    end else begin
        rd_skid4_0 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

    if ( (rd_bypassing4 || rd_take_n_dly[4]) && (!rd_skid4_1_vld || (cq_rd4_pvld && cq_rd4_prdy && !rd_skid4_2_vld)) ) begin
        rd_skid4_1 <=  rd_bypassing4 ? cq_wr_pd : cq_rd_pd_p;
    end else if ( cq_rd4_pvld && cq_rd4_prdy && rd_skid4_2_vld ) begin
        rd_skid4_1 <=  rd_skid4_2;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing4 || rd_take_n_dly[4]) && (!rd_skid4_1_vld || (cq_rd4_pvld && cq_rd4_prdy && !rd_skid4_2_vld))) && 
                  !(cq_rd4_pvld && cq_rd4_prdy && rd_skid4_2_vld) ) begin
    end else begin
        rd_skid4_1 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

    if ( (rd_bypassing4 || rd_take_n_dly[4]) && rd_skid4_0_vld && rd_skid4_1_vld && (rd_skid4_2_vld || !(cq_rd4_pvld && cq_rd4_prdy)) ) begin
        rd_skid4_2 <=  rd_bypassing4 ? cq_wr_pd : cq_rd_pd_p;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing4 || rd_take_n_dly[4]) && rd_skid4_0_vld && rd_skid4_1_vld && (rd_skid4_2_vld || !(cq_rd4_pvld && cq_rd4_prdy))) ) begin 
    end else begin
        rd_skid4_2 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

end

always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rd_skid4_0_vld <=  1'b0;
        rd_skid4_1_vld <=  1'b0;
        rd_skid4_2_vld <=  1'b0;
    end else begin
        rd_skid4_0_vld <=  (cq_rd4_pvld && cq_rd4_prdy) ? (rd_skid4_1_vld || (rd_bypassing4 && rd_skid4_0_vld) || rd_take_n_dly[4]) : (rd_skid4_0_vld || rd_bypassing4 || rd_take_n_dly[4]);
	rd_skid4_1_vld <=  (cq_rd4_pvld && cq_rd4_prdy) ? (rd_skid4_2_vld || (rd_skid4_1_vld && (rd_bypassing4 || rd_take_n_dly[4]))) : (rd_skid4_1_vld || (rd_skid4_0_vld && (rd_bypassing4 || rd_take_n_dly[4])));
        //VCS coverage off
	rd_skid4_2_vld <=  (cq_rd4_pvld && cq_rd4_prdy) ? (rd_skid4_2_vld && (rd_bypassing4 || rd_take_n_dly[4])) : (rd_skid4_2_vld || (rd_skid4_1_vld && (rd_bypassing4 || rd_take_n_dly[4])));
        //VCS coverage on
    end
end

// spyglass disable_block W164a W116 W484
reg  [8:0] cq_rd4_credits;   
reg             cq_rd4_credits_ne0; 
wire [8:0] cq_rd4_credits_w_take_next  =  cq_rd4_credits + cq_rd_credit[4] - 1'b1;
wire [8:0] cq_rd4_credits_wo_take_next =  cq_rd4_credits + cq_rd_credit[4];
wire [8:0] cq_rd4_credits_next =  rd_take4 ? cq_rd4_credits_w_take_next : cq_rd4_credits_wo_take_next; 
// spyglass enable_block W164a W116 W484

//VCS coverage off
assign cq_rd_take_elig[4] = (cq_rd4_prdy_d || !rd_skid4_0_vld || !rd_skid4_1_vld || (!rd_skid4_2_vld && !rd_take_n_dly[4])) && (cq_rd_credit[4] || cq_rd4_credits_ne0);
//VCS coverage on

assign rd_pre_bypassing4 = cq_wr_pvld && !cq_wr_busy_int && (cq_wr_thread_id == 4'd4) && cq_rd4_credits == 0 && !cq_rd_credit[4] && (!rd_take_n_dly[4] || rd_skid4_0_vld); 
assign rd_bypassing4 = rd_pre_bypassing4 && (!rd_skid4_2_vld || !rd_skid4_1_vld || !(!cq_rd4_prdy_d && rd_skid4_0_vld && rd_skid4_1_vld)) && !rd_take_n_dly[4];
always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd4_credits <=  9'd0;
        cq_rd4_credits_ne0 <=  1'b0;
    end else begin
        if ( cq_rd_credit[4] |  rd_take4 ) begin
            cq_rd4_credits <=  cq_rd4_credits_next;
            cq_rd4_credits_ne0 <=  rd_take4 ? (cq_rd4_credits_w_take_next != 0) : (cq_rd4_credits_wo_take_next != 0);
        end
        //synopsys translate_off
            else if ( ! (cq_rd_credit[4] |  rd_take4) ) begin
        end else begin
            cq_rd4_credits <=  {9{`x_or_0}};
            cq_rd4_credits_ne0 <=  `x_or_0; 
        end
        //synopsys translate_on

    end
end

wire rd_pre_bypassing5;          
wire rd_bypassing5;              
reg  [6:0] rd_skid5_0;     
reg  [6:0] rd_skid5_1;     
reg  [6:0] rd_skid5_2;     
reg  rd_skid5_0_vld;             
reg  rd_skid5_1_vld;             
reg  rd_skid5_2_vld;             

reg  cq_rd5_prdy_d;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd5_prdy_d <=  1'b1;
    end else begin

        cq_rd5_prdy_d <=  cq_rd5_prdy;
    end
end

assign cq_rd5_pvld = rd_skid5_0_vld || rd_pre_bypassing5;  		
assign cq_rd5_pd = rd_skid5_0_vld ? rd_skid5_0 : cq_wr_pd;        

always @( posedge nvdla_core_clk_mgated_skid ) begin
    if ( (rd_bypassing5 || rd_take_n_dly[5]) && (!rd_skid5_0_vld || (cq_rd5_pvld && cq_rd5_prdy && !rd_skid5_1_vld)) ) begin
        rd_skid5_0 <=  rd_take_n_dly[5] ? cq_rd_pd_p : cq_wr_pd;
    end else if ( cq_rd5_pvld && cq_rd5_prdy && rd_skid5_1_vld ) begin
        rd_skid5_0 <=  rd_skid5_1;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing5 || rd_take_n_dly[5]) && (!rd_skid5_0_vld || (cq_rd5_pvld && cq_rd5_prdy && !rd_skid5_1_vld))) && 
                  !(cq_rd5_pvld && cq_rd5_prdy && rd_skid5_1_vld) ) begin
    end else begin
        rd_skid5_0 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

    if ( (rd_bypassing5 || rd_take_n_dly[5]) && (!rd_skid5_1_vld || (cq_rd5_pvld && cq_rd5_prdy && !rd_skid5_2_vld)) ) begin
        rd_skid5_1 <=  rd_bypassing5 ? cq_wr_pd : cq_rd_pd_p;
    end else if ( cq_rd5_pvld && cq_rd5_prdy && rd_skid5_2_vld ) begin
        rd_skid5_1 <=  rd_skid5_2;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing5 || rd_take_n_dly[5]) && (!rd_skid5_1_vld || (cq_rd5_pvld && cq_rd5_prdy && !rd_skid5_2_vld))) && 
                  !(cq_rd5_pvld && cq_rd5_prdy && rd_skid5_2_vld) ) begin
    end else begin
        rd_skid5_1 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

    if ( (rd_bypassing5 || rd_take_n_dly[5]) && rd_skid5_0_vld && rd_skid5_1_vld && (rd_skid5_2_vld || !(cq_rd5_pvld && cq_rd5_prdy)) ) begin
        rd_skid5_2 <=  rd_bypassing5 ? cq_wr_pd : cq_rd_pd_p;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing5 || rd_take_n_dly[5]) && rd_skid5_0_vld && rd_skid5_1_vld && (rd_skid5_2_vld || !(cq_rd5_pvld && cq_rd5_prdy))) ) begin 
    end else begin
        rd_skid5_2 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

end

always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rd_skid5_0_vld <=  1'b0;
        rd_skid5_1_vld <=  1'b0;
        rd_skid5_2_vld <=  1'b0;
    end else begin
        rd_skid5_0_vld <=  (cq_rd5_pvld && cq_rd5_prdy) ? (rd_skid5_1_vld || (rd_bypassing5 && rd_skid5_0_vld) || rd_take_n_dly[5]) : (rd_skid5_0_vld || rd_bypassing5 || rd_take_n_dly[5]);
	rd_skid5_1_vld <=  (cq_rd5_pvld && cq_rd5_prdy) ? (rd_skid5_2_vld || (rd_skid5_1_vld && (rd_bypassing5 || rd_take_n_dly[5]))) : (rd_skid5_1_vld || (rd_skid5_0_vld && (rd_bypassing5 || rd_take_n_dly[5])));
        //VCS coverage off
	rd_skid5_2_vld <=  (cq_rd5_pvld && cq_rd5_prdy) ? (rd_skid5_2_vld && (rd_bypassing5 || rd_take_n_dly[5])) : (rd_skid5_2_vld || (rd_skid5_1_vld && (rd_bypassing5 || rd_take_n_dly[5])));
        //VCS coverage on
    end
end

// spyglass disable_block W164a W116 W484
reg  [8:0] cq_rd5_credits;   
reg             cq_rd5_credits_ne0; 
wire [8:0] cq_rd5_credits_w_take_next  =  cq_rd5_credits + cq_rd_credit[5] - 1'b1;
wire [8:0] cq_rd5_credits_wo_take_next =  cq_rd5_credits + cq_rd_credit[5];
wire [8:0] cq_rd5_credits_next =  rd_take5 ? cq_rd5_credits_w_take_next : cq_rd5_credits_wo_take_next; 
// spyglass enable_block W164a W116 W484

//VCS coverage off
assign cq_rd_take_elig[5] = (cq_rd5_prdy_d || !rd_skid5_0_vld || !rd_skid5_1_vld || (!rd_skid5_2_vld && !rd_take_n_dly[5])) && (cq_rd_credit[5] || cq_rd5_credits_ne0);
//VCS coverage on

assign rd_pre_bypassing5 = cq_wr_pvld && !cq_wr_busy_int && (cq_wr_thread_id == 4'd5) && cq_rd5_credits == 0 && !cq_rd_credit[5] && (!rd_take_n_dly[5] || rd_skid5_0_vld); 
assign rd_bypassing5 = rd_pre_bypassing5 && (!rd_skid5_2_vld || !rd_skid5_1_vld || !(!cq_rd5_prdy_d && rd_skid5_0_vld && rd_skid5_1_vld)) && !rd_take_n_dly[5];
always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd5_credits <=  9'd0;
        cq_rd5_credits_ne0 <=  1'b0;
    end else begin
        if ( cq_rd_credit[5] |  rd_take5 ) begin
            cq_rd5_credits <=  cq_rd5_credits_next;
            cq_rd5_credits_ne0 <=  rd_take5 ? (cq_rd5_credits_w_take_next != 0) : (cq_rd5_credits_wo_take_next != 0);
        end
        //synopsys translate_off
            else if ( ! (cq_rd_credit[5] |  rd_take5) ) begin
        end else begin
            cq_rd5_credits <=  {9{`x_or_0}};
            cq_rd5_credits_ne0 <=  `x_or_0; 
        end
        //synopsys translate_on

    end
end

wire rd_pre_bypassing6;          
wire rd_bypassing6;              
reg  [6:0] rd_skid6_0;     
reg  [6:0] rd_skid6_1;     
reg  [6:0] rd_skid6_2;     
reg  rd_skid6_0_vld;             
reg  rd_skid6_1_vld;             
reg  rd_skid6_2_vld;             

reg  cq_rd6_prdy_d;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd6_prdy_d <=  1'b1;
    end else begin

        cq_rd6_prdy_d <=  cq_rd6_prdy;
    end
end

assign cq_rd6_pvld = rd_skid6_0_vld || rd_pre_bypassing6;  			
assign cq_rd6_pd = rd_skid6_0_vld ? rd_skid6_0 : cq_wr_pd;        

always @( posedge nvdla_core_clk_mgated_skid ) begin
    if ( (rd_bypassing6 || rd_take_n_dly[6]) && (!rd_skid6_0_vld || (cq_rd6_pvld && cq_rd6_prdy && !rd_skid6_1_vld)) ) begin
        rd_skid6_0 <=  rd_take_n_dly[6] ? cq_rd_pd_p : cq_wr_pd;
    end else if ( cq_rd6_pvld && cq_rd6_prdy && rd_skid6_1_vld ) begin
        rd_skid6_0 <=  rd_skid6_1;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing6 || rd_take_n_dly[6]) && (!rd_skid6_0_vld || (cq_rd6_pvld && cq_rd6_prdy && !rd_skid6_1_vld))) && 
                  !(cq_rd6_pvld && cq_rd6_prdy && rd_skid6_1_vld) ) begin
    end else begin
        rd_skid6_0 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

    if ( (rd_bypassing6 || rd_take_n_dly[6]) && (!rd_skid6_1_vld || (cq_rd6_pvld && cq_rd6_prdy && !rd_skid6_2_vld)) ) begin
        rd_skid6_1 <=  rd_bypassing6 ? cq_wr_pd : cq_rd_pd_p;
    end else if ( cq_rd6_pvld && cq_rd6_prdy && rd_skid6_2_vld ) begin
        rd_skid6_1 <=  rd_skid6_2;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing6 || rd_take_n_dly[6]) && (!rd_skid6_1_vld || (cq_rd6_pvld && cq_rd6_prdy && !rd_skid6_2_vld))) && 
                  !(cq_rd6_pvld && cq_rd6_prdy && rd_skid6_2_vld) ) begin
    end else begin
        rd_skid6_1 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

    if ( (rd_bypassing6 || rd_take_n_dly[6]) && rd_skid6_0_vld && rd_skid6_1_vld && (rd_skid6_2_vld || !(cq_rd6_pvld && cq_rd6_prdy)) ) begin
        rd_skid6_2 <=  rd_bypassing6 ? cq_wr_pd : cq_rd_pd_p;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing6 || rd_take_n_dly[6]) && rd_skid6_0_vld && rd_skid6_1_vld && (rd_skid6_2_vld || !(cq_rd6_pvld && cq_rd6_prdy))) ) begin 
    end else begin
        rd_skid6_2 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

end

always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rd_skid6_0_vld <=  1'b0;
        rd_skid6_1_vld <=  1'b0;
        rd_skid6_2_vld <=  1'b0;
    end else begin
        rd_skid6_0_vld <=  (cq_rd6_pvld && cq_rd6_prdy) ? (rd_skid6_1_vld || (rd_bypassing6 && rd_skid6_0_vld) || rd_take_n_dly[6]) : (rd_skid6_0_vld || rd_bypassing6 || rd_take_n_dly[6]);
	rd_skid6_1_vld <=  (cq_rd6_pvld && cq_rd6_prdy) ? (rd_skid6_2_vld || (rd_skid6_1_vld && (rd_bypassing6 || rd_take_n_dly[6]))) : (rd_skid6_1_vld || (rd_skid6_0_vld && (rd_bypassing6 || rd_take_n_dly[6])));
        //VCS coverage off
	rd_skid6_2_vld <=  (cq_rd6_pvld && cq_rd6_prdy) ? (rd_skid6_2_vld && (rd_bypassing6 || rd_take_n_dly[6])) : (rd_skid6_2_vld || (rd_skid6_1_vld && (rd_bypassing6 || rd_take_n_dly[6])));
        //VCS coverage on
    end
end

// spyglass disable_block W164a W116 W484
reg  [8:0] cq_rd6_credits;   
reg             cq_rd6_credits_ne0; 
wire [8:0] cq_rd6_credits_w_take_next  =  cq_rd6_credits + cq_rd_credit[6] - 1'b1;
wire [8:0] cq_rd6_credits_wo_take_next =  cq_rd6_credits + cq_rd_credit[6];
wire [8:0] cq_rd6_credits_next =  rd_take6 ? cq_rd6_credits_w_take_next : cq_rd6_credits_wo_take_next; 
// spyglass enable_block W164a W116 W484

//VCS coverage off
assign cq_rd_take_elig[6] = (cq_rd6_prdy_d || !rd_skid6_0_vld || !rd_skid6_1_vld || (!rd_skid6_2_vld && !rd_take_n_dly[6])) && (cq_rd_credit[6] || cq_rd6_credits_ne0);
//VCS coverage on

assign rd_pre_bypassing6 = cq_wr_pvld && !cq_wr_busy_int && (cq_wr_thread_id == 4'd6) && cq_rd6_credits == 0 && !cq_rd_credit[6] && (!rd_take_n_dly[6] || rd_skid6_0_vld); 
assign rd_bypassing6 = rd_pre_bypassing6 && (!rd_skid6_2_vld || !rd_skid6_1_vld || !(!cq_rd6_prdy_d && rd_skid6_0_vld && rd_skid6_1_vld)) && !rd_take_n_dly[6];
always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd6_credits <=  9'd0;
        cq_rd6_credits_ne0 <=  1'b0;
    end else begin
        if ( cq_rd_credit[6] |  rd_take6 ) begin
            cq_rd6_credits <=  cq_rd6_credits_next;
            cq_rd6_credits_ne0 <=  rd_take6 ? (cq_rd6_credits_w_take_next != 0) : (cq_rd6_credits_wo_take_next != 0);
        end
        //synopsys translate_off
            else if ( ! (cq_rd_credit[6] |  rd_take6) ) begin
        end else begin
            cq_rd6_credits <=  {9{`x_or_0}};
            cq_rd6_credits_ne0 <=  `x_or_0; 
        end
        //synopsys translate_on

    end
end

wire rd_pre_bypassing7;          
wire rd_bypassing7;              
reg  [6:0] rd_skid7_0;     
reg  [6:0] rd_skid7_1;     
reg  [6:0] rd_skid7_2;     
reg  rd_skid7_0_vld;             
reg  rd_skid7_1_vld;             
reg  rd_skid7_2_vld;             

reg  cq_rd7_prdy_d;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd7_prdy_d <=  1'b1;
    end else begin

        cq_rd7_prdy_d <=  cq_rd7_prdy;
    end
end

assign cq_rd7_pvld = rd_skid7_0_vld || rd_pre_bypassing7;  			
assign cq_rd7_pd = rd_skid7_0_vld ? rd_skid7_0 : cq_wr_pd;        

always @( posedge nvdla_core_clk_mgated_skid ) begin
    if ( (rd_bypassing7 || rd_take_n_dly[7]) && (!rd_skid7_0_vld || (cq_rd7_pvld && cq_rd7_prdy && !rd_skid7_1_vld)) ) begin
        rd_skid7_0 <=  rd_take_n_dly[7] ? cq_rd_pd_p : cq_wr_pd;
    end else if ( cq_rd7_pvld && cq_rd7_prdy && rd_skid7_1_vld ) begin
        rd_skid7_0 <=  rd_skid7_1;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing7 || rd_take_n_dly[7]) && (!rd_skid7_0_vld || (cq_rd7_pvld && cq_rd7_prdy && !rd_skid7_1_vld))) && 
                  !(cq_rd7_pvld && cq_rd7_prdy && rd_skid7_1_vld) ) begin
    end else begin
        rd_skid7_0 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

    if ( (rd_bypassing7 || rd_take_n_dly[7]) && (!rd_skid7_1_vld || (cq_rd7_pvld && cq_rd7_prdy && !rd_skid7_2_vld)) ) begin
        rd_skid7_1 <=  rd_bypassing7 ? cq_wr_pd : cq_rd_pd_p;
    end else if ( cq_rd7_pvld && cq_rd7_prdy && rd_skid7_2_vld ) begin
        rd_skid7_1 <=  rd_skid7_2;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing7 || rd_take_n_dly[7]) && (!rd_skid7_1_vld || (cq_rd7_pvld && cq_rd7_prdy && !rd_skid7_2_vld))) && 
                  !(cq_rd7_pvld && cq_rd7_prdy && rd_skid7_2_vld) ) begin
    end else begin
        rd_skid7_1 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

    if ( (rd_bypassing7 || rd_take_n_dly[7]) && rd_skid7_0_vld && rd_skid7_1_vld && (rd_skid7_2_vld || !(cq_rd7_pvld && cq_rd7_prdy)) ) begin
        rd_skid7_2 <=  rd_bypassing7 ? cq_wr_pd : cq_rd_pd_p;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing7 || rd_take_n_dly[7]) && rd_skid7_0_vld && rd_skid7_1_vld && (rd_skid7_2_vld || !(cq_rd7_pvld && cq_rd7_prdy))) ) begin 
    end else begin
        rd_skid7_2 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

end

always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rd_skid7_0_vld <=  1'b0;
        rd_skid7_1_vld <=  1'b0;
        rd_skid7_2_vld <=  1'b0;
    end else begin
        rd_skid7_0_vld <=  (cq_rd7_pvld && cq_rd7_prdy) ? (rd_skid7_1_vld || (rd_bypassing7 && rd_skid7_0_vld) || rd_take_n_dly[7]) : (rd_skid7_0_vld || rd_bypassing7 || rd_take_n_dly[7]);
	rd_skid7_1_vld <=  (cq_rd7_pvld && cq_rd7_prdy) ? (rd_skid7_2_vld || (rd_skid7_1_vld && (rd_bypassing7 || rd_take_n_dly[7]))) : (rd_skid7_1_vld || (rd_skid7_0_vld && (rd_bypassing7 || rd_take_n_dly[7])));
        //VCS coverage off
	rd_skid7_2_vld <=  (cq_rd7_pvld && cq_rd7_prdy) ? (rd_skid7_2_vld && (rd_bypassing7 || rd_take_n_dly[7])) : (rd_skid7_2_vld || (rd_skid7_1_vld && (rd_bypassing7 || rd_take_n_dly[7])));
        //VCS coverage on
    end
end

// spyglass disable_block W164a W116 W484
reg  [8:0] cq_rd7_credits;   
reg             cq_rd7_credits_ne0; 
wire [8:0] cq_rd7_credits_w_take_next  =  cq_rd7_credits + cq_rd_credit[7] - 1'b1;
wire [8:0] cq_rd7_credits_wo_take_next =  cq_rd7_credits + cq_rd_credit[7];
wire [8:0] cq_rd7_credits_next =  rd_take7 ? cq_rd7_credits_w_take_next : cq_rd7_credits_wo_take_next; 
// spyglass enable_block W164a W116 W484

//VCS coverage off
assign cq_rd_take_elig[7] = (cq_rd7_prdy_d || !rd_skid7_0_vld || !rd_skid7_1_vld || (!rd_skid7_2_vld && !rd_take_n_dly[7])) && (cq_rd_credit[7] || cq_rd7_credits_ne0);
//VCS coverage on

assign rd_pre_bypassing7 = cq_wr_pvld && !cq_wr_busy_int && (cq_wr_thread_id == 4'd7) && cq_rd7_credits == 0 && !cq_rd_credit[7] && (!rd_take_n_dly[7] || rd_skid7_0_vld); 
assign rd_bypassing7 = rd_pre_bypassing7 && (!rd_skid7_2_vld || !rd_skid7_1_vld || !(!cq_rd7_prdy_d && rd_skid7_0_vld && rd_skid7_1_vld)) && !rd_take_n_dly[7];
always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd7_credits <=  9'd0;
        cq_rd7_credits_ne0 <=  1'b0;
    end else begin
        if ( cq_rd_credit[7] |  rd_take7 ) begin
            cq_rd7_credits <=  cq_rd7_credits_next;
            cq_rd7_credits_ne0 <=  rd_take7 ? (cq_rd7_credits_w_take_next != 0) : (cq_rd7_credits_wo_take_next != 0);
        end
        //synopsys translate_off
            else if ( ! (cq_rd_credit[7] |  rd_take7) ) begin
        end else begin
            cq_rd7_credits <=  {9{`x_or_0}};
            cq_rd7_credits_ne0 <=  `x_or_0; 
        end
        //synopsys translate_on

    end
end

wire rd_pre_bypassing8;          
wire rd_bypassing8;              
reg  [6:0] rd_skid8_0;     
reg  [6:0] rd_skid8_1;     
reg  [6:0] rd_skid8_2;     
reg  rd_skid8_0_vld;             
reg  rd_skid8_1_vld;             
reg  rd_skid8_2_vld;             

reg  cq_rd8_prdy_d;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd8_prdy_d <=  1'b1;
    end else begin

        cq_rd8_prdy_d <=  cq_rd8_prdy;
    end
end

assign cq_rd8_pvld = rd_skid8_0_vld || rd_pre_bypassing8;  			
assign cq_rd8_pd = rd_skid8_0_vld ? rd_skid8_0 : cq_wr_pd;        

always @( posedge nvdla_core_clk_mgated_skid ) begin
    if ( (rd_bypassing8 || rd_take_n_dly[8]) && (!rd_skid8_0_vld || (cq_rd8_pvld && cq_rd8_prdy && !rd_skid8_1_vld)) ) begin
        rd_skid8_0 <=  rd_take_n_dly[8] ? cq_rd_pd_p : cq_wr_pd;
    end else if ( cq_rd8_pvld && cq_rd8_prdy && rd_skid8_1_vld ) begin
        rd_skid8_0 <=  rd_skid8_1;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing8 || rd_take_n_dly[8]) && (!rd_skid8_0_vld || (cq_rd8_pvld && cq_rd8_prdy && !rd_skid8_1_vld))) && 
                  !(cq_rd8_pvld && cq_rd8_prdy && rd_skid8_1_vld) ) begin
    end else begin
        rd_skid8_0 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

    if ( (rd_bypassing8 || rd_take_n_dly[8]) && (!rd_skid8_1_vld || (cq_rd8_pvld && cq_rd8_prdy && !rd_skid8_2_vld)) ) begin
        rd_skid8_1 <=  rd_bypassing8 ? cq_wr_pd : cq_rd_pd_p;
    end else if ( cq_rd8_pvld && cq_rd8_prdy && rd_skid8_2_vld ) begin
        rd_skid8_1 <=  rd_skid8_2;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing8 || rd_take_n_dly[8]) && (!rd_skid8_1_vld || (cq_rd8_pvld && cq_rd8_prdy && !rd_skid8_2_vld))) && 
                  !(cq_rd8_pvld && cq_rd8_prdy && rd_skid8_2_vld) ) begin
    end else begin
        rd_skid8_1 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

    if ( (rd_bypassing8 || rd_take_n_dly[8]) && rd_skid8_0_vld && rd_skid8_1_vld && (rd_skid8_2_vld || !(cq_rd8_pvld && cq_rd8_prdy)) ) begin
        rd_skid8_2 <=  rd_bypassing8 ? cq_wr_pd : cq_rd_pd_p;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing8 || rd_take_n_dly[8]) && rd_skid8_0_vld && rd_skid8_1_vld && (rd_skid8_2_vld || !(cq_rd8_pvld && cq_rd8_prdy))) ) begin 
    end else begin
        rd_skid8_2 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

end

always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rd_skid8_0_vld <=  1'b0;
        rd_skid8_1_vld <=  1'b0;
        rd_skid8_2_vld <=  1'b0;
    end else begin
        rd_skid8_0_vld <=  (cq_rd8_pvld && cq_rd8_prdy) ? (rd_skid8_1_vld || (rd_bypassing8 && rd_skid8_0_vld) || rd_take_n_dly[8]) : (rd_skid8_0_vld || rd_bypassing8 || rd_take_n_dly[8]);
	rd_skid8_1_vld <=  (cq_rd8_pvld && cq_rd8_prdy) ? (rd_skid8_2_vld || (rd_skid8_1_vld && (rd_bypassing8 || rd_take_n_dly[8]))) : (rd_skid8_1_vld || (rd_skid8_0_vld && (rd_bypassing8 || rd_take_n_dly[8])));
        //VCS coverage off
	rd_skid8_2_vld <=  (cq_rd8_pvld && cq_rd8_prdy) ? (rd_skid8_2_vld && (rd_bypassing8 || rd_take_n_dly[8])) : (rd_skid8_2_vld || (rd_skid8_1_vld && (rd_bypassing8 || rd_take_n_dly[8])));
        //VCS coverage on
    end
end

// spyglass disable_block W164a W116 W484
reg  [8:0] cq_rd8_credits;   
reg             cq_rd8_credits_ne0; 
wire [8:0] cq_rd8_credits_w_take_next  =  cq_rd8_credits + cq_rd_credit[8] - 1'b1;
wire [8:0] cq_rd8_credits_wo_take_next =  cq_rd8_credits + cq_rd_credit[8];
wire [8:0] cq_rd8_credits_next =  rd_take8 ? cq_rd8_credits_w_take_next : cq_rd8_credits_wo_take_next; 
// spyglass enable_block W164a W116 W484

//VCS coverage off
assign cq_rd_take_elig[8] = (cq_rd8_prdy_d || !rd_skid8_0_vld || !rd_skid8_1_vld || (!rd_skid8_2_vld && !rd_take_n_dly[8])) && (cq_rd_credit[8] || cq_rd8_credits_ne0);
//VCS coverage on

assign rd_pre_bypassing8 = cq_wr_pvld && !cq_wr_busy_int && (cq_wr_thread_id == 4'd8) && cq_rd8_credits == 0 && !cq_rd_credit[8] && (!rd_take_n_dly[8] || rd_skid8_0_vld); 
assign rd_bypassing8 = rd_pre_bypassing8 && (!rd_skid8_2_vld || !rd_skid8_1_vld || !(!cq_rd8_prdy_d && rd_skid8_0_vld && rd_skid8_1_vld)) && !rd_take_n_dly[8];
always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd8_credits <=  9'd0;
        cq_rd8_credits_ne0 <=  1'b0;
    end else begin
        if ( cq_rd_credit[8] |  rd_take8 ) begin
            cq_rd8_credits <=  cq_rd8_credits_next;
            cq_rd8_credits_ne0 <=  rd_take8 ? (cq_rd8_credits_w_take_next != 0) : (cq_rd8_credits_wo_take_next != 0);
        end
        //synopsys translate_off
            else if ( ! (cq_rd_credit[8] |  rd_take8) ) begin
        end else begin
            cq_rd8_credits <=  {9{`x_or_0}};
            cq_rd8_credits_ne0 <=  `x_or_0; 
        end
        //synopsys translate_on

    end
end

wire rd_pre_bypassing9;          
wire rd_bypassing9;              
reg  [6:0] rd_skid9_0;     
reg  [6:0] rd_skid9_1;     
reg  [6:0] rd_skid9_2;     
reg  rd_skid9_0_vld;             
reg  rd_skid9_1_vld;             
reg  rd_skid9_2_vld;             

reg  cq_rd9_prdy_d;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd9_prdy_d <=  1'b1;
    end else begin

        cq_rd9_prdy_d <=  cq_rd9_prdy;
    end
end

assign cq_rd9_pvld = rd_skid9_0_vld || rd_pre_bypassing9;  			
assign cq_rd9_pd = rd_skid9_0_vld ? rd_skid9_0 : cq_wr_pd;        

always @( posedge nvdla_core_clk_mgated_skid ) begin
    if ( (rd_bypassing9 || rd_take_n_dly[9]) && (!rd_skid9_0_vld || (cq_rd9_pvld && cq_rd9_prdy && !rd_skid9_1_vld)) ) begin
        rd_skid9_0 <=  rd_take_n_dly[9] ? cq_rd_pd_p : cq_wr_pd;
    end else if ( cq_rd9_pvld && cq_rd9_prdy && rd_skid9_1_vld ) begin
        rd_skid9_0 <=  rd_skid9_1;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing9 || rd_take_n_dly[9]) && (!rd_skid9_0_vld || (cq_rd9_pvld && cq_rd9_prdy && !rd_skid9_1_vld))) && 
                  !(cq_rd9_pvld && cq_rd9_prdy && rd_skid9_1_vld) ) begin
    end else begin
        rd_skid9_0 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

    if ( (rd_bypassing9 || rd_take_n_dly[9]) && (!rd_skid9_1_vld || (cq_rd9_pvld && cq_rd9_prdy && !rd_skid9_2_vld)) ) begin
        rd_skid9_1 <=  rd_bypassing9 ? cq_wr_pd : cq_rd_pd_p;
    end else if ( cq_rd9_pvld && cq_rd9_prdy && rd_skid9_2_vld ) begin
        rd_skid9_1 <=  rd_skid9_2;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing9 || rd_take_n_dly[9]) && (!rd_skid9_1_vld || (cq_rd9_pvld && cq_rd9_prdy && !rd_skid9_2_vld))) && 
                  !(cq_rd9_pvld && cq_rd9_prdy && rd_skid9_2_vld) ) begin
    end else begin
        rd_skid9_1 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

    if ( (rd_bypassing9 || rd_take_n_dly[9]) && rd_skid9_0_vld && rd_skid9_1_vld && (rd_skid9_2_vld || !(cq_rd9_pvld && cq_rd9_prdy)) ) begin
        rd_skid9_2 <=  rd_bypassing9 ? cq_wr_pd : cq_rd_pd_p;
    end
    //synopsys translate_off
        else if ( !((rd_bypassing9 || rd_take_n_dly[9]) && rd_skid9_0_vld && rd_skid9_1_vld && (rd_skid9_2_vld || !(cq_rd9_pvld && cq_rd9_prdy))) ) begin 
    end else begin
        rd_skid9_2 <=  {7{`x_or_0}};
    end
    //synopsys translate_on

end

always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rd_skid9_0_vld <=  1'b0;
        rd_skid9_1_vld <=  1'b0;
        rd_skid9_2_vld <=  1'b0;
    end else begin
        rd_skid9_0_vld <=  (cq_rd9_pvld && cq_rd9_prdy) ? (rd_skid9_1_vld || (rd_bypassing9 && rd_skid9_0_vld) || rd_take_n_dly[9]) : (rd_skid9_0_vld || rd_bypassing9 || rd_take_n_dly[9]);
	rd_skid9_1_vld <=  (cq_rd9_pvld && cq_rd9_prdy) ? (rd_skid9_2_vld || (rd_skid9_1_vld && (rd_bypassing9 || rd_take_n_dly[9]))) : (rd_skid9_1_vld || (rd_skid9_0_vld && (rd_bypassing9 || rd_take_n_dly[9])));
        //VCS coverage off
	rd_skid9_2_vld <=  (cq_rd9_pvld && cq_rd9_prdy) ? (rd_skid9_2_vld && (rd_bypassing9 || rd_take_n_dly[9])) : (rd_skid9_2_vld || (rd_skid9_1_vld && (rd_bypassing9 || rd_take_n_dly[9])));
        //VCS coverage on
    end
end

// spyglass disable_block W164a W116 W484
reg  [8:0] cq_rd9_credits;   
reg             cq_rd9_credits_ne0; 
wire [8:0] cq_rd9_credits_w_take_next  =  cq_rd9_credits + cq_rd_credit[9] - 1'b1;
wire [8:0] cq_rd9_credits_wo_take_next =  cq_rd9_credits + cq_rd_credit[9];
wire [8:0] cq_rd9_credits_next =  rd_take9 ? cq_rd9_credits_w_take_next : cq_rd9_credits_wo_take_next; 
// spyglass enable_block W164a W116 W484

//VCS coverage off
assign cq_rd_take_elig[9] = (cq_rd9_prdy_d || !rd_skid9_0_vld || !rd_skid9_1_vld || (!rd_skid9_2_vld && !rd_take_n_dly[9])) && (cq_rd_credit[9] || cq_rd9_credits_ne0);
//VCS coverage on

assign rd_pre_bypassing9 = cq_wr_pvld && !cq_wr_busy_int && (cq_wr_thread_id == 4'd9) && cq_rd9_credits == 0 && !cq_rd_credit[9] && (!rd_take_n_dly[9] || rd_skid9_0_vld); 
assign rd_bypassing9 = rd_pre_bypassing9 && (!rd_skid9_2_vld || !rd_skid9_1_vld || !(!cq_rd9_prdy_d && rd_skid9_0_vld && rd_skid9_1_vld)) && !rd_take_n_dly[9];
always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd9_credits <=  9'd0;
        cq_rd9_credits_ne0 <=  1'b0;
    end else begin
        if ( cq_rd_credit[9] |  rd_take9 ) begin
            cq_rd9_credits <=  cq_rd9_credits_next;
            cq_rd9_credits_ne0 <=  rd_take9 ? (cq_rd9_credits_w_take_next != 0) : (cq_rd9_credits_wo_take_next != 0);
        end
        //synopsys translate_off
            else if ( ! (cq_rd_credit[9] |  rd_take9) ) begin
        end else begin
            cq_rd9_credits <=  {9{`x_or_0}};
            cq_rd9_credits_ne0 <=  `x_or_0; 
        end
        //synopsys translate_on

    end
end



assign cq_rd_take = |cq_rd_take_elig;  

reg [3:0] cq_rd_take_thread_id_last;

wire [9:0] cq_rd_take_thread_id_is_1 = {
    cq_rd_take_elig[1] && cq_rd_take_thread_id_last == 4'd9 && !cq_rd_take_elig[0],
    cq_rd_take_elig[1] && cq_rd_take_thread_id_last == 4'd8 && !cq_rd_take_elig[9] && !cq_rd_take_elig[0],
    cq_rd_take_elig[1] && cq_rd_take_thread_id_last == 4'd7 && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0],
    cq_rd_take_elig[1] && cq_rd_take_thread_id_last == 4'd6 && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0],
    cq_rd_take_elig[1] && cq_rd_take_thread_id_last == 4'd5 && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0],
    cq_rd_take_elig[1] && cq_rd_take_thread_id_last == 4'd4 && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0],
    cq_rd_take_elig[1] && cq_rd_take_thread_id_last == 4'd3 && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0],
    cq_rd_take_elig[1] && cq_rd_take_thread_id_last == 4'd2 && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0],
    cq_rd_take_elig[1] && cq_rd_take_thread_id_last == 4'd1 && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0],
    cq_rd_take_elig[1] && cq_rd_take_thread_id_last == 4'd0};

wire [9:0] cq_rd_take_thread_id_is_2 = {
    cq_rd_take_elig[2] && cq_rd_take_thread_id_last == 4'd9 && !cq_rd_take_elig[0] && !cq_rd_take_elig[1],
    cq_rd_take_elig[2] && cq_rd_take_thread_id_last == 4'd8 && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1],
    cq_rd_take_elig[2] && cq_rd_take_thread_id_last == 4'd7 && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1],
    cq_rd_take_elig[2] && cq_rd_take_thread_id_last == 4'd6 && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1],
    cq_rd_take_elig[2] && cq_rd_take_thread_id_last == 4'd5 && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1],
    cq_rd_take_elig[2] && cq_rd_take_thread_id_last == 4'd4 && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1],
    cq_rd_take_elig[2] && cq_rd_take_thread_id_last == 4'd3 && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1],
    cq_rd_take_elig[2] && cq_rd_take_thread_id_last == 4'd2 && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1],
    cq_rd_take_elig[2] && cq_rd_take_thread_id_last == 4'd1,
    cq_rd_take_elig[2] && cq_rd_take_thread_id_last == 4'd0 && !cq_rd_take_elig[1]};

wire [9:0] cq_rd_take_thread_id_is_3 = {
    cq_rd_take_elig[3] && cq_rd_take_thread_id_last == 4'd9 && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2],
    cq_rd_take_elig[3] && cq_rd_take_thread_id_last == 4'd8 && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2],
    cq_rd_take_elig[3] && cq_rd_take_thread_id_last == 4'd7 && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2],
    cq_rd_take_elig[3] && cq_rd_take_thread_id_last == 4'd6 && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2],
    cq_rd_take_elig[3] && cq_rd_take_thread_id_last == 4'd5 && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2],
    cq_rd_take_elig[3] && cq_rd_take_thread_id_last == 4'd4 && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2],
    cq_rd_take_elig[3] && cq_rd_take_thread_id_last == 4'd3 && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2],
    cq_rd_take_elig[3] && cq_rd_take_thread_id_last == 4'd2,
    cq_rd_take_elig[3] && cq_rd_take_thread_id_last == 4'd1 && !cq_rd_take_elig[2],
    cq_rd_take_elig[3] && cq_rd_take_thread_id_last == 4'd0 && !cq_rd_take_elig[1] && !cq_rd_take_elig[2]};

wire [9:0] cq_rd_take_thread_id_is_4 = {
    cq_rd_take_elig[4] && cq_rd_take_thread_id_last == 4'd9 && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3],
    cq_rd_take_elig[4] && cq_rd_take_thread_id_last == 4'd8 && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3],
    cq_rd_take_elig[4] && cq_rd_take_thread_id_last == 4'd7 && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3],
    cq_rd_take_elig[4] && cq_rd_take_thread_id_last == 4'd6 && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3],
    cq_rd_take_elig[4] && cq_rd_take_thread_id_last == 4'd5 && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3],
    cq_rd_take_elig[4] && cq_rd_take_thread_id_last == 4'd4 && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3],
    cq_rd_take_elig[4] && cq_rd_take_thread_id_last == 4'd3,
    cq_rd_take_elig[4] && cq_rd_take_thread_id_last == 4'd2 && !cq_rd_take_elig[3],
    cq_rd_take_elig[4] && cq_rd_take_thread_id_last == 4'd1 && !cq_rd_take_elig[2] && !cq_rd_take_elig[3],
    cq_rd_take_elig[4] && cq_rd_take_thread_id_last == 4'd0 && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3]};

wire [9:0] cq_rd_take_thread_id_is_5 = {
    cq_rd_take_elig[5] && cq_rd_take_thread_id_last == 4'd9 && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4],
    cq_rd_take_elig[5] && cq_rd_take_thread_id_last == 4'd8 && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4],
    cq_rd_take_elig[5] && cq_rd_take_thread_id_last == 4'd7 && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4],
    cq_rd_take_elig[5] && cq_rd_take_thread_id_last == 4'd6 && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4],
    cq_rd_take_elig[5] && cq_rd_take_thread_id_last == 4'd5 && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4],
    cq_rd_take_elig[5] && cq_rd_take_thread_id_last == 4'd4,
    cq_rd_take_elig[5] && cq_rd_take_thread_id_last == 4'd3 && !cq_rd_take_elig[4],
    cq_rd_take_elig[5] && cq_rd_take_thread_id_last == 4'd2 && !cq_rd_take_elig[3] && !cq_rd_take_elig[4],
    cq_rd_take_elig[5] && cq_rd_take_thread_id_last == 4'd1 && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4],
    cq_rd_take_elig[5] && cq_rd_take_thread_id_last == 4'd0 && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4]};

wire [9:0] cq_rd_take_thread_id_is_6 = {
    cq_rd_take_elig[6] && cq_rd_take_thread_id_last == 4'd9 && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5],
    cq_rd_take_elig[6] && cq_rd_take_thread_id_last == 4'd8 && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5],
    cq_rd_take_elig[6] && cq_rd_take_thread_id_last == 4'd7 && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5],
    cq_rd_take_elig[6] && cq_rd_take_thread_id_last == 4'd6 && !cq_rd_take_elig[7] && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5],
    cq_rd_take_elig[6] && cq_rd_take_thread_id_last == 4'd5,
    cq_rd_take_elig[6] && cq_rd_take_thread_id_last == 4'd4 && !cq_rd_take_elig[5],
    cq_rd_take_elig[6] && cq_rd_take_thread_id_last == 4'd3 && !cq_rd_take_elig[4] && !cq_rd_take_elig[5],
    cq_rd_take_elig[6] && cq_rd_take_thread_id_last == 4'd2 && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5],
    cq_rd_take_elig[6] && cq_rd_take_thread_id_last == 4'd1 && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5],
    cq_rd_take_elig[6] && cq_rd_take_thread_id_last == 4'd0 && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5]};

wire [9:0] cq_rd_take_thread_id_is_7 = {
    cq_rd_take_elig[7] && cq_rd_take_thread_id_last == 4'd9 && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6],
    cq_rd_take_elig[7] && cq_rd_take_thread_id_last == 4'd8 && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6],
    cq_rd_take_elig[7] && cq_rd_take_thread_id_last == 4'd7 && !cq_rd_take_elig[8] && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6],
    cq_rd_take_elig[7] && cq_rd_take_thread_id_last == 4'd6,
    cq_rd_take_elig[7] && cq_rd_take_thread_id_last == 4'd5 && !cq_rd_take_elig[6],
    cq_rd_take_elig[7] && cq_rd_take_thread_id_last == 4'd4 && !cq_rd_take_elig[5] && !cq_rd_take_elig[6],
    cq_rd_take_elig[7] && cq_rd_take_thread_id_last == 4'd3 && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6],
    cq_rd_take_elig[7] && cq_rd_take_thread_id_last == 4'd2 && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6],
    cq_rd_take_elig[7] && cq_rd_take_thread_id_last == 4'd1 && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6],
    cq_rd_take_elig[7] && cq_rd_take_thread_id_last == 4'd0 && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6]};

wire [9:0] cq_rd_take_thread_id_is_8 = {
    cq_rd_take_elig[8] && cq_rd_take_thread_id_last == 4'd9 && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7],
    cq_rd_take_elig[8] && cq_rd_take_thread_id_last == 4'd8 && !cq_rd_take_elig[9] && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7],
    cq_rd_take_elig[8] && cq_rd_take_thread_id_last == 4'd7,
    cq_rd_take_elig[8] && cq_rd_take_thread_id_last == 4'd6 && !cq_rd_take_elig[7],
    cq_rd_take_elig[8] && cq_rd_take_thread_id_last == 4'd5 && !cq_rd_take_elig[6] && !cq_rd_take_elig[7],
    cq_rd_take_elig[8] && cq_rd_take_thread_id_last == 4'd4 && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7],
    cq_rd_take_elig[8] && cq_rd_take_thread_id_last == 4'd3 && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7],
    cq_rd_take_elig[8] && cq_rd_take_thread_id_last == 4'd2 && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7],
    cq_rd_take_elig[8] && cq_rd_take_thread_id_last == 4'd1 && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7],
    cq_rd_take_elig[8] && cq_rd_take_thread_id_last == 4'd0 && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7]};

wire [9:0] cq_rd_take_thread_id_is_9 = {
    cq_rd_take_elig[9] && cq_rd_take_thread_id_last == 4'd9 && !cq_rd_take_elig[0] && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8],
    cq_rd_take_elig[9] && cq_rd_take_thread_id_last == 4'd8,
    cq_rd_take_elig[9] && cq_rd_take_thread_id_last == 4'd7 && !cq_rd_take_elig[8],
    cq_rd_take_elig[9] && cq_rd_take_thread_id_last == 4'd6 && !cq_rd_take_elig[7] && !cq_rd_take_elig[8],
    cq_rd_take_elig[9] && cq_rd_take_thread_id_last == 4'd5 && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8],
    cq_rd_take_elig[9] && cq_rd_take_thread_id_last == 4'd4 && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8],
    cq_rd_take_elig[9] && cq_rd_take_thread_id_last == 4'd3 && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8],
    cq_rd_take_elig[9] && cq_rd_take_thread_id_last == 4'd2 && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8],
    cq_rd_take_elig[9] && cq_rd_take_thread_id_last == 4'd1 && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8],
    cq_rd_take_elig[9] && cq_rd_take_thread_id_last == 4'd0 && !cq_rd_take_elig[1] && !cq_rd_take_elig[2] && !cq_rd_take_elig[3] && !cq_rd_take_elig[4] && !cq_rd_take_elig[5] && !cq_rd_take_elig[6] && !cq_rd_take_elig[7] && !cq_rd_take_elig[8]};

assign cq_rd_take_thread_id[0] = |{cq_rd_take_thread_id_is_1,cq_rd_take_thread_id_is_3,cq_rd_take_thread_id_is_5,cq_rd_take_thread_id_is_7,cq_rd_take_thread_id_is_9};

assign cq_rd_take_thread_id[1] = |{cq_rd_take_thread_id_is_2,cq_rd_take_thread_id_is_3,cq_rd_take_thread_id_is_6,cq_rd_take_thread_id_is_7};

assign cq_rd_take_thread_id[2] = |{cq_rd_take_thread_id_is_4,cq_rd_take_thread_id_is_5,cq_rd_take_thread_id_is_6,cq_rd_take_thread_id_is_7};

assign cq_rd_take_thread_id[3] = |{cq_rd_take_thread_id_is_8,cq_rd_take_thread_id_is_9};

always @( posedge nvdla_core_clk_mgated_skid or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cq_rd_take_thread_id_last <=  4'd0;
    end else begin
        if ( cq_rd_take ) begin
            cq_rd_take_thread_id_last <=  cq_rd_take_thread_id;
        end
        //synopsys translate_off
            else if ( !cq_rd_take ) begin
        end else begin
            cq_rd_take_thread_id_last <=  {4{`x_or_0}};
        end
        //synopsys translate_on

    end
end

assign wr_bypassing = rd_bypassing0 || rd_bypassing1 || rd_bypassing2 || rd_bypassing3 || rd_bypassing4 || rd_bypassing5 || rd_bypassing6 || rd_bypassing7 || rd_bypassing8 || rd_bypassing9;



//



// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg master_clk_gating_disabled;  initial master_clk_gating_disabled = $test$plusargs( "fifogen_disable_master_clk_gating" ) != 0;
`endif
`endif
// synopsys translate_on

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg wr_pause_rand_dly;  
always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_pause_rand_dly <=  1'b0;
    end else begin
        wr_pause_rand_dly <=  wr_pause_rand;
    end
end
`endif
`endif
// synopsys translate_on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (cq_wr_pvld && !cq_wr_busy_int) || (cq_wr_busy_int != cq_wr_busy_next) || rd_popping) || (rd_pushing || cq_rd_take || cq_rd_credit != 10'd0 || rd_take_dly))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled || (wr_pause_rand != wr_pause_rand_dly)
			       `endif
			       `endif
                               // synopsys translate_on
                               ;


assign nvdla_core_clk_mgated_skid_enable = nvdla_core_clk_mgated_enable || ( cq_rd0_pvld && cq_rd0_prdy ) || rd_bypassing0 || ( cq_rd1_pvld && cq_rd1_prdy ) || rd_bypassing1 || ( cq_rd2_pvld && cq_rd2_prdy ) || rd_bypassing2 || ( cq_rd3_pvld && cq_rd3_prdy ) || rd_bypassing3 || ( cq_rd4_pvld && cq_rd4_prdy ) || rd_bypassing4 || ( cq_rd5_pvld && cq_rd5_prdy ) || rd_bypassing5 || ( cq_rd6_pvld && cq_rd6_prdy ) || rd_bypassing6 || ( cq_rd7_pvld && cq_rd7_prdy ) || rd_bypassing7 || ( cq_rd8_pvld && cq_rd8_prdy ) || rd_bypassing8 || ( cq_rd9_pvld && cq_rd9_prdy ) || rd_bypassing9
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled
			       `endif
			       `endif
                               // synopsys translate_on
                               ;



//

`ifdef EMU

`ifdef EMU_FIFO_CFG

//
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_MCIF_READ_cq_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_MCIF_READ_cq_wr_limit : 9'd0;
`else

//
assign wr_limit_muxed = 9'd0;
`endif 

`else 
`ifdef SYNTH_LEVEL1_COMPILE


//
assign wr_limit_muxed = 9'd0;
`else
`ifdef SYNTHESIS


//

assign wr_limit_muxed = 9'd0;

`else  




// VCS coverage off

reg wr_limit_override;
reg [8:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 9'd0;
`ifdef NV_ARCHPRO
event reinit;

initial begin
    $display("fifogen reinit initial block %m");
    -> reinit;
end
`endif

`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    wr_limit_override = 0;
    wr_limit_override_value = 0;  
    if ( $test$plusargs( "NV_NVDLA_MCIF_READ_cq_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_MCIF_READ_cq_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif



// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off

// leda W339 OFF -- Non synthesizable operator
// leda W372 OFF -- Undefined PLI task
// leda W373 OFF -- Undefined PLI function
// leda W599 OFF -- This construct is not supported by Synopsys
// leda W430 OFF -- Initial statement is not synthesizable
// leda W182 OFF -- Illegal statement for synthesis
// leda W639 OFF -- For synthesis, operands of a division or modulo operation need to be constants
// leda DCVER_274_NV OFF -- This system task is not supported by DC

integer stall_probability;      
integer stall_cycles_min;       
integer stall_cycles_max;       
integer stall_cycles_left;      
`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    stall_probability      = 0; 
    stall_cycles_min       = 1;
    stall_cycles_max       = 10;

`ifdef NO_PLI
`else
    if ( $test$plusargs( "NV_NVDLA_MCIF_READ_cq_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_MCIF_READ_cq_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_MCIF_READ_cq_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_MCIF_READ_cq_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_MCIF_READ_cq_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_MCIF_READ_cq_fifo_stall_cycles_max=%d", stall_cycles_max);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_max=%d", stall_cycles_max);
    end
`endif

    if ( stall_cycles_min < 1 ) begin
        stall_cycles_min = 1;
    end

    if ( stall_cycles_min > stall_cycles_max ) begin
        stall_cycles_max = stall_cycles_min;
    end

end

`ifdef NO_PLI
`else


`ifdef SIMTOP_RANDOMIZE_STALLS
  always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
    if ( ! $test$plusargs( "NV_NVDLA_MCIF_READ_cq_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_MCIF_READ_cq_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_MCIF_READ_cq_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
  end
`endif

`endif

always @( negedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        stall_cycles_left <=  0;
    end else begin
`ifdef NO_PLI
            stall_cycles_left <=  0;
`else
            if ( cq_wr_pvld && !(!cq_wr_prdy)
                 && stall_probability != 0 ) begin
                if ( prand_inst0(1, 100) <= stall_probability ) begin
                    stall_cycles_left <=  prand_inst1(stall_cycles_min, stall_cycles_max);
                end else if ( stall_cycles_left !== 0  ) begin
                    stall_cycles_left <=  stall_cycles_left - 1;
                end
            end else if ( stall_cycles_left !== 0  ) begin
                stall_cycles_left <=  stall_cycles_left - 1;
            end
`endif
    end
end

assign wr_pause_rand = (stall_cycles_left !== 0) ;

// VCS coverage on
`endif
`endif
// synopsys translate_on
// VCS coverage on

// leda W339 ON
// leda W372 ON
// leda W373 ON
// leda W599 ON
// leda W430 ON
// leda W182 ON
// leda W639 ON
// leda DCVER_274_NV ON


//

//




//
`ifdef PERFMON_HISTOGRAM 
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( nvdla_core_clk ) 
    , .max      ( {23'd0, (wr_limit_reg == 9'd0) ? 9'd256 : wr_limit_reg} )
    , .curr	( {23'd0, cq_wr_count} )
    );
`endif
`endif
// synopsys translate_on
`endif

// spyglass disable_block W164a W164b W116 W484 W504

`ifdef SPYGLASS
`else

`ifdef FV_ASSERT_ON
`else
// synopsys translate_off
`endif

`ifdef ASSERT_ON

`ifdef SPYGLASS
wire disable_assert_plusarg = 1'b0;
`else

`ifdef FV_ASSERT_ON
wire disable_assert_plusarg = 1'b0;
`else
wire disable_assert_plusarg = $test$plusargs("DISABLE_NESS_FLOW_ASSERTIONS");
`endif

`endif
wire assert_enabled = 1'b1 && !disable_assert_plusarg;


nv_assert_vld_credit_max #(0, 0, 256, 0, "FIFOGEN_ASSERTION A take occurred without credits being available") 
    fifogen_rd_take_credit_check0  ( .clk       ( nvdla_core_clk ), 
                                        .reset_    ( ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn ) & assert_enabled ), 
                                        .vld       ( cq_rd_take  && cq_rd_take_thread_id == 4'd0 ),
                                        .credit    ( cq_rd_credit[0] )
                                      );

nv_assert_vld_credit_max #(0, 0, 256, 0, "FIFOGEN_ASSERTION A take occurred without credits being available") 
    fifogen_rd_take_credit_check1  ( .clk       ( nvdla_core_clk ), 
                                        .reset_    ( ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn ) & assert_enabled ), 
                                        .vld       ( cq_rd_take  && cq_rd_take_thread_id == 4'd1 ),
                                        .credit    ( cq_rd_credit[1] )
                                      );

nv_assert_vld_credit_max #(0, 0, 256, 0, "FIFOGEN_ASSERTION A take occurred without credits being available") 
    fifogen_rd_take_credit_check2  ( .clk       ( nvdla_core_clk ), 
                                        .reset_    ( ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn ) & assert_enabled ), 
                                        .vld       ( cq_rd_take  && cq_rd_take_thread_id == 4'd2 ),
                                        .credit    ( cq_rd_credit[2] )
                                      );

nv_assert_vld_credit_max #(0, 0, 256, 0, "FIFOGEN_ASSERTION A take occurred without credits being available") 
    fifogen_rd_take_credit_check3  ( .clk       ( nvdla_core_clk ), 
                                        .reset_    ( ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn ) & assert_enabled ), 
                                        .vld       ( cq_rd_take  && cq_rd_take_thread_id == 4'd3 ),
                                        .credit    ( cq_rd_credit[3] )
                                      );

nv_assert_vld_credit_max #(0, 0, 256, 0, "FIFOGEN_ASSERTION A take occurred without credits being available") 
    fifogen_rd_take_credit_check4  ( .clk       ( nvdla_core_clk ), 
                                        .reset_    ( ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn ) & assert_enabled ), 
                                        .vld       ( cq_rd_take  && cq_rd_take_thread_id == 4'd4 ),
                                        .credit    ( cq_rd_credit[4] )
                                      );

nv_assert_vld_credit_max #(0, 0, 256, 0, "FIFOGEN_ASSERTION A take occurred without credits being available") 
    fifogen_rd_take_credit_check5  ( .clk       ( nvdla_core_clk ), 
                                        .reset_    ( ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn ) & assert_enabled ), 
                                        .vld       ( cq_rd_take  && cq_rd_take_thread_id == 4'd5 ),
                                        .credit    ( cq_rd_credit[5] )
                                      );

nv_assert_vld_credit_max #(0, 0, 256, 0, "FIFOGEN_ASSERTION A take occurred without credits being available") 
    fifogen_rd_take_credit_check6  ( .clk       ( nvdla_core_clk ), 
                                        .reset_    ( ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn ) & assert_enabled ), 
                                        .vld       ( cq_rd_take  && cq_rd_take_thread_id == 4'd6 ),
                                        .credit    ( cq_rd_credit[6] )
                                      );

nv_assert_vld_credit_max #(0, 0, 256, 0, "FIFOGEN_ASSERTION A take occurred without credits being available") 
    fifogen_rd_take_credit_check7  ( .clk       ( nvdla_core_clk ), 
                                        .reset_    ( ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn ) & assert_enabled ), 
                                        .vld       ( cq_rd_take  && cq_rd_take_thread_id == 4'd7 ),
                                        .credit    ( cq_rd_credit[7] )
                                      );

nv_assert_vld_credit_max #(0, 0, 256, 0, "FIFOGEN_ASSERTION A take occurred without credits being available") 
    fifogen_rd_take_credit_check8  ( .clk       ( nvdla_core_clk ), 
                                        .reset_    ( ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn ) & assert_enabled ), 
                                        .vld       ( cq_rd_take  && cq_rd_take_thread_id == 4'd8 ),
                                        .credit    ( cq_rd_credit[8] )
                                      );

nv_assert_vld_credit_max #(0, 0, 256, 0, "FIFOGEN_ASSERTION A take occurred without credits being available") 
    fifogen_rd_take_credit_check9  ( .clk       ( nvdla_core_clk ), 
                                        .reset_    ( ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn ) & assert_enabled ), 
                                        .vld       ( cq_rd_take  && cq_rd_take_thread_id == 4'd9 ),
                                        .credit    ( cq_rd_credit[9] )
                                      );

`endif

`ifdef FV_ASSERT_ON
`else
// synopsys translate_on
`endif

`ifdef ASSERT_ON

//synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
always @(assert_enabled) begin
    if ( assert_enabled === 1'b0 ) begin
        $display("Asserts are disabled for %m");
    end
end
`endif
`endif
//synopsys translate_on

`endif

`endif

// spyglass enable_block W164a W164b W116 W484 W504


//The NV_BLKBOX_SRC0 module is only present when the FIFOGEN_MODULE_SEARCH
// define is set.  This is to aid fifogen team search for fifogen fifo
// instance and module names in a given design.
`ifdef FIFOGEN_MODULE_SEARCH
NV_BLKBOX_SRC0 dummy_breadcrumb_fifogen_blkbox (.Y());
`endif

// spyglass enable_block W401 -- clock is not input to module

// synopsys dc_script_begin
//   set_boundary_optimization find(design, "NV_NVDLA_MCIF_READ_cq") true
// synopsys dc_script_end




`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG

reg [47:0] prand_local_seed0;
reg prand_initialized0;
reg prand_no_rollpli0;
`endif
`endif
`endif

function [31:0] prand_inst0;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst0 = min;
`else
`ifdef SYNTHESIS
        prand_inst0 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized0 !== 1'b1) begin
            prand_no_rollpli0 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli0)
                prand_local_seed0 = {$prand_get_seed(0), 16'b0};
            prand_initialized0 = 1'b1;
        end
        if (prand_no_rollpli0) begin
            prand_inst0 = min;
        end else begin
            diff = max - min + 1;
            prand_inst0 = min + prand_local_seed0[47:16] % diff;
            
            prand_local_seed0 = prand_local_seed0 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst0 = min;
`else
        prand_inst0 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction



`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG

reg [47:0] prand_local_seed1;
reg prand_initialized1;
reg prand_no_rollpli1;
`endif
`endif
`endif

function [31:0] prand_inst1;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst1 = min;
`else
`ifdef SYNTHESIS
        prand_inst1 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized1 !== 1'b1) begin
            prand_no_rollpli1 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli1)
                prand_local_seed1 = {$prand_get_seed(1), 16'b0};
            prand_initialized1 = 1'b1;
        end
        if (prand_no_rollpli1) begin
            prand_inst1 = min;
        end else begin
            diff = max - min + 1;
            prand_inst1 = min + prand_local_seed1[47:16] % diff;
            
            prand_local_seed1 = prand_local_seed1 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst1 = min;
`else
        prand_inst1 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


endmodule 



//
//

