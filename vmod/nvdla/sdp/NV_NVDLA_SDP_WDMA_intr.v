// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_WDMA_intr.v

`include "simulate_x_tick.vh"
module NV_NVDLA_SDP_WDMA_intr (
   nvdla_core_clk       //|< i
  ,nvdla_core_rstn      //|< i
  ,dma_wr_req_rdy       //|< i
  ,dma_wr_req_vld       //|< i
  ,dma_wr_rsp_complete  //|< i
  ,intr_req_ptr         //|< i
  ,intr_req_pvld        //|< i
  ,op_load              //|< i
  ,pwrbus_ram_pd        //|< i
  ,reg2dp_ew_alu_algo   //|< i
  ,reg2dp_ew_alu_bypass //|< i
  ,reg2dp_ew_bypass     //|< i
  ,reg2dp_op_en         //|< i
  ,reg2dp_output_dst    //|< i
  ,reg2dp_perf_dma_en   //|< i
  ,dp2reg_wdma_stall    //|> o
  ,sdp2glb_done_intr_pd //|> o
  );

input   [1:0] reg2dp_ew_alu_algo;
input         reg2dp_ew_alu_bypass;
input         reg2dp_ew_bypass;
input         reg2dp_op_en;
input         reg2dp_output_dst;
input         reg2dp_perf_dma_en;
output [31:0] dp2reg_wdma_stall;
input         intr_req_ptr;
input         intr_req_pvld;
input  [31:0] pwrbus_ram_pd;
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         dma_wr_req_rdy;
input         dma_wr_req_vld;
input         dma_wr_rsp_complete;
output  [1:0] sdp2glb_done_intr_pd;
input         op_load;

reg    [31:0] dp2reg_wdma_stall;
reg     [1:0] sdp2glb_done_intr_pd;
reg           stl_adv;
reg    [31:0] stl_cnt_cur;
reg    [33:0] stl_cnt_dec;
reg    [33:0] stl_cnt_ext;
reg    [33:0] stl_cnt_inc;
reg    [33:0] stl_cnt_mod;
reg    [33:0] stl_cnt_new;
reg    [33:0] stl_cnt_nxt;

wire          cfg_mode_eql;
wire          cfg_mode_pdp;
wire          cfg_mode_quite;
wire          dp2reg_wdma_stall_dec;
wire          intr0_internal;
wire          intr0_wr;
wire          intr1_internal;
wire          intr1_wr;
wire          intr_fifo_rd_pd;
wire          intr_fifo_rd_prdy;
wire          intr_fifo_rd_pvld;
wire          intr_fifo_wr_pd;
wire          intr_fifo_wr_pvld;
wire          mon_intr_fifo_rd_pvld;
wire          wdma_stall_cnt_cen;
wire          wdma_stall_cnt_clr;
wire          wdma_stall_cnt_inc;


//============================
// CFG
//============================

assign cfg_mode_eql   = (reg2dp_ew_bypass== 1'h0 ) 
                      & (reg2dp_ew_alu_bypass== 1'h0 ) 
                      & (reg2dp_ew_alu_algo== 2'h3 );

assign cfg_mode_pdp   = reg2dp_output_dst== 1'h1 ;

assign cfg_mode_quite = cfg_mode_eql | cfg_mode_pdp;

//==============
// Interrupt
//==============
assign intr_fifo_wr_pvld = intr_req_pvld & !cfg_mode_quite;
assign intr_fifo_wr_pd   = intr_req_ptr;


NV_NVDLA_SDP_WDMA_DAT_DMAIF_intr_fifo u_NV_NVDLA_SDP_WDMA_DAT_DMAIF_intr_fifo (
   .nvdla_core_clk    (nvdla_core_clk)      //|< i
  ,.nvdla_core_rstn   (nvdla_core_rstn)     //|< i
  ,.intr_fifo_wr_pvld (intr_fifo_wr_pvld)   //|< w
  ,.intr_fifo_wr_pd   (intr_fifo_wr_pd)     //|< w
  ,.intr_fifo_rd_prdy (intr_fifo_rd_prdy)   //|< w
  ,.intr_fifo_rd_pvld (intr_fifo_rd_pvld)   //|> w
  ,.intr_fifo_rd_pd   (intr_fifo_rd_pd)     //|> w
  ,.pwrbus_ram_pd     (pwrbus_ram_pd[31:0]) //|< i
  );
assign intr_fifo_rd_prdy = dma_wr_rsp_complete;

assign intr0_internal = cfg_mode_quite & intr_req_pvld & (intr_req_ptr==0);
assign intr0_wr  = dma_wr_rsp_complete & (intr_fifo_rd_pd==0);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sdp2glb_done_intr_pd[0] <= 1'b0;
  end else begin
  sdp2glb_done_intr_pd[0] <= intr0_wr | intr0_internal;
  end
end

assign intr1_internal = cfg_mode_quite & intr_req_pvld & (intr_req_ptr==1);
assign intr1_wr  = dma_wr_rsp_complete & (intr_fifo_rd_pd==1);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sdp2glb_done_intr_pd[1] <= 1'b0;
  end else begin
  sdp2glb_done_intr_pd[1] <= intr1_wr | intr1_internal;
  end
end

assign mon_intr_fifo_rd_pvld = intr_fifo_rd_pvld;

`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"when write complete, intr_ptr should be already in the head of intr_fifo read side")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, !mon_intr_fifo_rd_pvld & intr_fifo_rd_prdy); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"write intr0 and eql intr0 never happen in the same layer")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, intr0_wr & intr0_internal); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"write intr1 and eql intr1 never happen in the same layer")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, intr1_wr & intr1_internal); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//==============
// PERF STATISTIC
assign wdma_stall_cnt_inc = dma_wr_req_vld & !dma_wr_req_rdy;
assign wdma_stall_cnt_clr = op_load;
assign wdma_stall_cnt_cen = reg2dp_op_en & reg2dp_perf_dma_en;


    assign dp2reg_wdma_stall_dec = 1'b0;


    always @(
      wdma_stall_cnt_inc
      or dp2reg_wdma_stall_dec
      ) begin
      stl_adv = wdma_stall_cnt_inc ^ dp2reg_wdma_stall_dec;
    end
        
    always @(
      stl_cnt_cur
      or wdma_stall_cnt_inc
      or dp2reg_wdma_stall_dec
      or stl_adv
      or wdma_stall_cnt_clr
      ) begin
      stl_cnt_ext[33:0] = {1'b0, 1'b0, stl_cnt_cur};
      stl_cnt_inc[33:0] = stl_cnt_cur + 1'b1; // spyglass disable W164b
      stl_cnt_dec[33:0] = stl_cnt_cur - 1'b1; // spyglass disable W164b
      stl_cnt_mod[33:0] = (wdma_stall_cnt_inc && !dp2reg_wdma_stall_dec)? stl_cnt_inc : (!wdma_stall_cnt_inc && dp2reg_wdma_stall_dec)? stl_cnt_dec : stl_cnt_ext;
      stl_cnt_new[33:0] = (stl_adv)? stl_cnt_mod[33:0] : stl_cnt_ext[33:0];
      stl_cnt_nxt[33:0] = (wdma_stall_cnt_clr)? 34'd0 : stl_cnt_new[33:0];
    end

    always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
      if (!nvdla_core_rstn) begin
        stl_cnt_cur[31:0] <= 0;
      end else begin
      if (wdma_stall_cnt_cen) begin
      stl_cnt_cur[31:0] <= stl_cnt_nxt[31:0];
      end
      end
    end

    always @(
      stl_cnt_cur
      ) begin
      dp2reg_wdma_stall[31:0] = stl_cnt_cur[31:0];
    end
        
      
endmodule // NV_NVDLA_SDP_WDMA_intr



`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_SDP_WDMA_DAT_DMAIF_intr_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , intr_fifo_wr_pvld
    , intr_fifo_wr_pd
    , intr_fifo_rd_prdy
    , intr_fifo_rd_pvld
    , intr_fifo_rd_pd
    , pwrbus_ram_pd
    );

input         nvdla_core_clk;
input         nvdla_core_rstn;
input         intr_fifo_wr_pvld;
input         intr_fifo_wr_pd;
input         intr_fifo_rd_prdy;
output        intr_fifo_rd_pvld;
output        intr_fifo_rd_pd;
input  [31:0] pwrbus_ram_pd;

// Master Clock Gating (SLCG)
//
// We gate the clock(s) when idle or stalled.
// This allows us to turn off numerous miscellaneous flops
// that don't get gated during synthesis for one reason or another.
//
// We gate write side and read side separately. 
// If the fifo is synchronous, we also gate the ram separately, but if
// -master_clk_gated_unified or -status_reg/-status_logic_reg is specified, 
// then we use one clk gate for write, ram, and read.
//
wire nvdla_core_clk_mgated_enable;   // assigned by code at end of this module
wire nvdla_core_clk_mgated;               // used only in synchronous fifos
NV_CLK_gate_power nvdla_core_clk_mgate( .clk(nvdla_core_clk), .reset_(nvdla_core_rstn), .clk_en(nvdla_core_clk_mgated_enable), .clk_gated(nvdla_core_clk_mgated) );

// 
// WRITE SIDE
//
        
//          
// NOTE: 0-depth fifo has no write side
//          


//
// RAM
//

//
// NOTE: 0-depth fifo has no ram.
//
wire [0:0] intr_fifo_rd_pd_p = intr_fifo_wr_pd;

//
// SYNCHRONOUS BOUNDARY
//

//
// NOTE: 0-depth fifo has no real boundary between write and read sides
//


//
// READ SIDE
//

reg        intr_fifo_rd_prdy_d;				// intr_fifo_rd_prdy registered in cleanly

always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        intr_fifo_rd_prdy_d <=  1'b1;
    end else begin
        intr_fifo_rd_prdy_d <=  intr_fifo_rd_prdy;
    end
end

wire       intr_fifo_rd_prdy_d_o;			// combinatorial rd_busy

reg        intr_fifo_rd_pvld_int;			// internal copy of intr_fifo_rd_pvld

assign     intr_fifo_rd_pvld = intr_fifo_rd_pvld_int;
wire       intr_fifo_rd_pvld_p = intr_fifo_wr_pvld ; 		// no real fifo, take from write-side input
reg        intr_fifo_rd_pvld_int_o;	// internal copy of intr_fifo_rd_pvld_o
wire       intr_fifo_rd_pvld_o = intr_fifo_rd_pvld_int_o;
wire       rd_popping = intr_fifo_rd_pvld_p && !(intr_fifo_rd_pvld_int_o && !intr_fifo_rd_prdy_d_o);


// 
// SKID for -rd_busy_reg
//
reg  intr_fifo_rd_pd_o;         // output data register
wire        rd_req_next_o = (intr_fifo_rd_pvld_p || (intr_fifo_rd_pvld_int_o && !intr_fifo_rd_prdy_d_o)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        intr_fifo_rd_pvld_int_o <=  1'b0;
    end else begin
        intr_fifo_rd_pvld_int_o <=  rd_req_next_o;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (intr_fifo_rd_pvld_int && rd_req_next_o && rd_popping) ) begin
        intr_fifo_rd_pd_o <=  intr_fifo_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((intr_fifo_rd_pvld_int && rd_req_next_o && rd_popping)) ) begin
    end else begin
        intr_fifo_rd_pd_o <=  {1{`x_or_0}};
    end
    //synopsys translate_on

end

//
// FINAL OUTPUT
//
reg  intr_fifo_rd_pd;				// output data register
reg        intr_fifo_rd_pvld_int_d;			// so we can bubble-collapse intr_fifo_rd_prdy_d
assign     intr_fifo_rd_prdy_d_o = !((intr_fifo_rd_pvld_o && intr_fifo_rd_pvld_int_d && !intr_fifo_rd_prdy_d ) );
wire       rd_req_next = (!intr_fifo_rd_prdy_d_o ? intr_fifo_rd_pvld_o : intr_fifo_rd_pvld_p) ;  

always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        intr_fifo_rd_pvld_int <=  1'b0;
        intr_fifo_rd_pvld_int_d <=  1'b0;
    end else begin
        if ( !intr_fifo_rd_pvld_int || intr_fifo_rd_prdy ) begin
	    intr_fifo_rd_pvld_int <=  rd_req_next;
        end
        //synopsys translate_off
            else if ( !(!intr_fifo_rd_pvld_int || intr_fifo_rd_prdy) ) begin
        end else begin
            intr_fifo_rd_pvld_int <=  `x_or_0;
        end
        //synopsys translate_on


        intr_fifo_rd_pvld_int_d <=  intr_fifo_rd_pvld_int;
    end
end

always @( posedge nvdla_core_clk ) begin
    if ( rd_req_next && (!intr_fifo_rd_pvld_int || intr_fifo_rd_prdy ) ) begin
        case (!intr_fifo_rd_prdy_d_o) 
            1'b0:    intr_fifo_rd_pd <=  intr_fifo_rd_pd_p;
            1'b1:    intr_fifo_rd_pd <=  intr_fifo_rd_pd_o;
            //VCS coverage off
            default: intr_fifo_rd_pd <=  {1{`x_or_0}};
            //VCS coverage on
        endcase
    end
    //synopsys translate_off
        else if ( !(rd_req_next && (!intr_fifo_rd_pvld_int || intr_fifo_rd_prdy)) ) begin
    end else begin
        intr_fifo_rd_pd <=  {1{`x_or_0}};
    end
    //synopsys translate_on

end


// Tie-offs for pwrbus_ram_pd
`ifndef FPGA
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_0 (.A(pwrbus_ram_pd[0]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_1 (.A(pwrbus_ram_pd[1]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_2 (.A(pwrbus_ram_pd[2]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_3 (.A(pwrbus_ram_pd[3]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_4 (.A(pwrbus_ram_pd[4]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_5 (.A(pwrbus_ram_pd[5]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_6 (.A(pwrbus_ram_pd[6]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_7 (.A(pwrbus_ram_pd[7]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_8 (.A(pwrbus_ram_pd[8]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_9 (.A(pwrbus_ram_pd[9]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_10 (.A(pwrbus_ram_pd[10]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_11 (.A(pwrbus_ram_pd[11]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_12 (.A(pwrbus_ram_pd[12]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_13 (.A(pwrbus_ram_pd[13]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_14 (.A(pwrbus_ram_pd[14]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_15 (.A(pwrbus_ram_pd[15]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_16 (.A(pwrbus_ram_pd[16]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_17 (.A(pwrbus_ram_pd[17]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_18 (.A(pwrbus_ram_pd[18]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_19 (.A(pwrbus_ram_pd[19]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_20 (.A(pwrbus_ram_pd[20]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_21 (.A(pwrbus_ram_pd[21]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_22 (.A(pwrbus_ram_pd[22]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_23 (.A(pwrbus_ram_pd[23]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_24 (.A(pwrbus_ram_pd[24]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_25 (.A(pwrbus_ram_pd[25]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_26 (.A(pwrbus_ram_pd[26]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_27 (.A(pwrbus_ram_pd[27]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_28 (.A(pwrbus_ram_pd[28]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_29 (.A(pwrbus_ram_pd[29]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_30 (.A(pwrbus_ram_pd[30]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_31 (.A(pwrbus_ram_pd[31]));
`endif

// Master Clock Gating (SLCG) Enables
//

// plusarg for disabling this stuff:

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg master_clk_gating_disabled;  initial master_clk_gating_disabled = $test$plusargs( "fifogen_disable_master_clk_gating" ) != 0;
`endif
`endif
// synopsys translate_on
assign nvdla_core_clk_mgated_enable = ((1'b0) || (intr_fifo_wr_pvld || (intr_fifo_rd_pvld_int && intr_fifo_rd_prdy_d) || (intr_fifo_rd_pvld_int_o && intr_fifo_rd_prdy_d_o)))
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



endmodule // NV_NVDLA_SDP_WDMA_DAT_DMAIF_intr_fifo

