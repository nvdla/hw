// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_WDMA_DAT_out.v

`include "simulate_x_tick.vh"
module NV_NVDLA_SDP_WDMA_DAT_out (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cmd2dat_dma_pd
  ,cmd2dat_dma_pvld
  ,dfifo0_rd_pd
  ,dfifo0_rd_pvld
  ,dfifo1_rd_pd
  ,dfifo1_rd_pvld
  ,dfifo2_rd_pd
  ,dfifo2_rd_pvld
  ,dfifo3_rd_pd
  ,dfifo3_rd_pvld
  ,dma_wr_req_rdy
  ,op_load
  ,reg2dp_batch_number
  ,reg2dp_dst_ram_type
  ,reg2dp_ew_alu_algo
  ,reg2dp_ew_alu_bypass
  ,reg2dp_ew_bypass
  ,reg2dp_height
  ,reg2dp_interrupt_ptr
  ,reg2dp_out_precision
  ,reg2dp_output_dst
  ,reg2dp_proc_precision
  ,reg2dp_width
  ,reg2dp_winograd
  ,cmd2dat_dma_prdy
  ,dfifo0_rd_prdy
  ,dfifo1_rd_prdy
  ,dfifo2_rd_prdy
  ,dfifo3_rd_prdy
  ,dma_wr_req_pd
  ,dma_wr_req_type
  ,dma_wr_req_vld
  ,dp2reg_done
  ,dp2reg_status_unequal
  ,intr_req_ptr
  ,intr_req_pvld
  );
//
// NV_NVDLA_SDP_WDMA_DAT_out_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         cmd2dat_dma_pvld;  /* data valid */
output        cmd2dat_dma_prdy;  /* data return handshake */
input  [73:0] cmd2dat_dma_pd;

input          dfifo0_rd_pvld;  /* data valid */
output         dfifo0_rd_prdy;  /* data return handshake */
input  [127:0] dfifo0_rd_pd;

input          dfifo1_rd_pvld;  /* data valid */
output         dfifo1_rd_prdy;  /* data return handshake */
input  [127:0] dfifo1_rd_pd;

input          dfifo2_rd_pvld;  /* data valid */
output         dfifo2_rd_prdy;  /* data return handshake */
input  [127:0] dfifo2_rd_pd;

input          dfifo3_rd_pvld;  /* data valid */
output         dfifo3_rd_prdy;  /* data return handshake */
input  [127:0] dfifo3_rd_pd;

input op_load;
input    [4:0] reg2dp_batch_number;
input          reg2dp_dst_ram_type;
input    [1:0] reg2dp_ew_alu_algo;
input          reg2dp_ew_alu_bypass;
input          reg2dp_ew_bypass;
input   [12:0] reg2dp_height;
input          reg2dp_interrupt_ptr;
input    [1:0] reg2dp_out_precision;
input          reg2dp_output_dst;
input    [1:0] reg2dp_proc_precision;
input   [12:0] reg2dp_width;
input          reg2dp_winograd;
output         dp2reg_done;
output         dp2reg_status_unequal;
input          dma_wr_req_rdy;
output [514:0] dma_wr_req_pd;
output         dma_wr_req_type;
output         dma_wr_req_vld;
output         intr_req_ptr;
output         intr_req_pvld;
reg     [11:0] beat_count;
reg     [58:0] cmd_addr;
reg            cmd_cube_end;
reg            cmd_en;
reg            cmd_odd;
reg     [12:0] cmd_size;
reg            cmd_vld;
reg            dat_en;
reg            dfifo0_unequal;
reg            dfifo1_unequal;
reg            dfifo2_unequal;
reg            dfifo3_unequal;
reg    [514:0] dma_wr_req_pd;
reg            dp2reg_done;
reg            fifo_bank1_en;
wire           bank0_vld;
wire           bank1_vld;
wire           cfg_di_int8;
wire           cfg_do_int16;
wire           cfg_mode_1x1_pack;
wire           cfg_mode_8to16;
wire           cfg_mode_batch;
wire           cfg_mode_eql;
wire           cfg_mode_pdp;
wire           cfg_mode_quite;
wire           cfg_mode_winog;
wire    [58:0] cmd2dat_dma_addr;
wire           cmd2dat_dma_cube_end;
wire           cmd2dat_dma_odd;
wire    [12:0] cmd2dat_dma_size;
wire           cmd_accept;
wire           cmd_rdy;
wire           dat_accept;
wire   [511:0] dat_pd;
wire           dat_rdy;
wire           dat_vld;
wire           dfifo0_rd_vld;
wire           dfifo1_rd_vld;
wire           dfifo2_rd_vld;
wire           dfifo3_rd_vld;
wire    [63:0] dma_wr_cmd_addr;
wire    [77:0] dma_wr_cmd_pd;
wire           dma_wr_cmd_require_ack;
wire    [12:0] dma_wr_cmd_size;
wire           dma_wr_cmd_vld;
wire   [511:0] dma_wr_dat_data;
wire     [1:0] dma_wr_dat_mask;
wire   [513:0] dma_wr_dat_pd;
wire           dma_wr_dat_vld;
wire           dma_wr_rdy;
wire           is_last_beat;
wire           is_size_odd;
wire           layer_done;
wire    [11:0] size_of_beat;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    

assign cfg_mode_batch = (reg2dp_batch_number!=0);
assign cfg_mode_winog = reg2dp_winograd== 1'h1 ;

assign cfg_mode_eql   = (reg2dp_ew_bypass== 1'h0 ) 
                      & (reg2dp_ew_alu_bypass== 1'h0 ) 
                      & (reg2dp_ew_alu_algo== 2'h3 );

assign cfg_mode_pdp   = reg2dp_output_dst== 1'h1 ;

assign cfg_mode_quite = cfg_mode_eql | cfg_mode_pdp;

assign cfg_di_int8  = reg2dp_proc_precision  == 0 ;
assign cfg_do_int16 = reg2dp_out_precision == 1 ;

assign cfg_mode_8to16 = cfg_di_int8 & cfg_do_int16;
assign cfg_mode_1x1_pack = (reg2dp_width==0) & (reg2dp_height==0);

//==================================
// DATA split and assembly
//==================================

//assign dp2wdma_data_int16 = {::replcat_dn(16, ", ", 'int16_byte${ii}')};
//
//assign dp2wdma_data_int8  = {::replcat_dn(16, ", ", 'int8_byte${ii}')};

//=====================
// info from WDMA_cmd

// PKT_UNPACK_WIRE( sdp_wdma_dma , cmd2dat_dma_ , cmd2dat_dma_pd )
assign       cmd2dat_dma_addr[58:0] =    cmd2dat_dma_pd[58:0];
assign       cmd2dat_dma_size[12:0] =    cmd2dat_dma_pd[71:59];
assign        cmd2dat_dma_odd  =    cmd2dat_dma_pd[72];
assign        cmd2dat_dma_cube_end  =    cmd2dat_dma_pd[73];
assign cmd2dat_dma_prdy = cmd_rdy || !cmd_vld;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_vld <= 1'b0;
  end else begin
  if ((cmd2dat_dma_prdy) == 1'b1) begin
    cmd_vld <= cmd2dat_dma_pvld;
  // VCS coverage off
  end else if ((cmd2dat_dma_prdy) == 1'b0) begin
  end else begin
    cmd_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cmd2dat_dma_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_size <= {13{1'b0}};
  end else begin
  if ((cmd2dat_dma_pvld & cmd2dat_dma_prdy) == 1'b1) begin
    cmd_size <= cmd2dat_dma_size;
  // VCS coverage off
  end else if ((cmd2dat_dma_pvld & cmd2dat_dma_prdy) == 1'b0) begin
  end else begin
    cmd_size <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cmd2dat_dma_pvld & cmd2dat_dma_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_addr <= {59{1'b0}};
  end else begin
  if ((cmd2dat_dma_pvld & cmd2dat_dma_prdy) == 1'b1) begin
    cmd_addr <= cmd2dat_dma_addr;
  // VCS coverage off
  end else if ((cmd2dat_dma_pvld & cmd2dat_dma_prdy) == 1'b0) begin
  end else begin
    cmd_addr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cmd2dat_dma_pvld & cmd2dat_dma_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_odd <= 1'b0;
  end else begin
  if ((cmd2dat_dma_pvld & cmd2dat_dma_prdy) == 1'b1) begin
    cmd_odd <= cmd2dat_dma_odd;
  // VCS coverage off
  end else if ((cmd2dat_dma_pvld & cmd2dat_dma_prdy) == 1'b0) begin
  end else begin
    cmd_odd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cmd2dat_dma_pvld & cmd2dat_dma_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_cube_end <= 1'b0;
  end else begin
  if ((cmd2dat_dma_pvld & cmd2dat_dma_prdy) == 1'b1) begin
    cmd_cube_end <= cmd2dat_dma_cube_end;
  // VCS coverage off
  end else if ((cmd2dat_dma_pvld & cmd2dat_dma_prdy) == 1'b0) begin
  end else begin
    cmd_cube_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cmd2dat_dma_pvld & cmd2dat_dma_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
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

assign cmd_rdy = dat_accept & is_last_beat;

assign size_of_beat = cmd_size[12:1];
assign is_size_odd = (cmd_size[0]==0);

// Switch between CMD/DAT pkt
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_en <= 1'b1;
    dat_en <= 1'b0;
  end else begin
    if (cmd_accept) begin
        cmd_en <= 1'b0;
        dat_en <= 1'b1;
    end else if (dat_accept) begin
        if (is_last_beat) begin
            cmd_en <= 1'b1;
            dat_en <= 1'b0;
        end
    end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    beat_count <= {12{1'b0}};
  end else begin
    if (dat_accept) begin
        if (is_last_beat) begin
            beat_count <= 0;
        end else begin
            beat_count <= beat_count + 1;
        end
    end
  end
end
assign is_last_beat = (beat_count==size_of_beat);

// 4 FIFOs, 16B each, 64B in total
// BANK0 -> fifo0/1 ; BANK1 -> fifo2/3
always @(
  cfg_mode_8to16
  or cfg_mode_1x1_pack
  or cmd_odd
  or cfg_mode_winog
  or cfg_mode_batch
  or is_last_beat
  or is_size_odd
  ) begin
    if (cfg_mode_8to16) begin
        if (cfg_mode_1x1_pack) begin
            fifo_bank1_en = 1'b1;
        end else begin
            if (cmd_odd) begin
                fifo_bank1_en = 1'b0;
            end else begin
                fifo_bank1_en = 1'b1;
            end
        end
    end else if (cfg_mode_winog) begin
            fifo_bank1_en = 1'b1;
    end else if (cfg_mode_batch) begin
        if (cmd_odd) begin
            fifo_bank1_en = 1'b0;
        end else begin
            fifo_bank1_en = 1'b1;
        end
    end else begin
        fifo_bank1_en = !is_last_beat || !is_size_odd;
    end
end

assign bank0_vld = dfifo0_rd_pvld & dfifo1_rd_pvld;
assign bank1_vld = dfifo2_rd_pvld & dfifo3_rd_pvld;

assign dfifo0_rd_vld = dfifo0_rd_pvld;
assign dfifo0_rd_prdy = dat_rdy & dfifo1_rd_pvld & (!fifo_bank1_en || bank1_vld);
assign dfifo1_rd_vld = dfifo1_rd_pvld;
assign dfifo1_rd_prdy = dat_rdy & dfifo0_rd_pvld & (!fifo_bank1_en || bank1_vld);
assign dfifo2_rd_vld = !fifo_bank1_en || dfifo2_rd_pvld;
assign dfifo2_rd_prdy = dat_rdy & dfifo3_rd_pvld & fifo_bank1_en & bank0_vld;
assign dfifo3_rd_vld = !fifo_bank1_en || dfifo3_rd_pvld;
assign dfifo3_rd_prdy = dat_rdy & dfifo2_rd_pvld & fifo_bank1_en & bank0_vld;

assign dat_rdy = dat_en & dma_wr_rdy;
assign dat_vld =  dfifo3_rd_vld & dfifo2_rd_vld & dfifo1_rd_vld & dfifo0_rd_vld;
assign dat_pd  = {dfifo3_rd_pd , dfifo2_rd_pd , dfifo1_rd_pd , dfifo0_rd_pd};
assign dat_accept = dat_vld & dat_rdy;

assign cmd_accept = cmd_en & cmd_vld & dma_wr_rdy;

assign dma_wr_rdy = cfg_mode_quite || dma_wr_req_rdy;

//=================================================
// Count the Equal Bit in EQ Mode
//=================================================
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dfifo0_unequal <= 1'b0;
  end else begin
   if (op_load) begin
       dfifo0_unequal <= 1'b0;
   end else begin
       if (dfifo0_rd_pvld & dfifo0_rd_prdy) begin
           dfifo0_unequal <= dfifo0_unequal | (|dfifo0_rd_pd);
       end
   end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dfifo1_unequal <= 1'b0;
  end else begin
   if (op_load) begin
       dfifo1_unequal <= 1'b0;
   end else begin
       if (dfifo1_rd_pvld & dfifo1_rd_prdy) begin
           dfifo1_unequal <= dfifo1_unequal | (|dfifo1_rd_pd);
       end
   end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dfifo2_unequal <= 1'b0;
  end else begin
   if (op_load) begin
       dfifo2_unequal <= 1'b0;
   end else begin
       if (dfifo2_rd_pvld & dfifo2_rd_prdy) begin
           dfifo2_unequal <= dfifo2_unequal | (|dfifo2_rd_pd);
       end
   end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dfifo3_unequal <= 1'b0;
  end else begin
   if (op_load) begin
       dfifo3_unequal <= 1'b0;
   end else begin
       if (dfifo3_rd_pvld & dfifo3_rd_prdy) begin
           dfifo3_unequal <= dfifo3_unequal | (|dfifo3_rd_pd);
       end
   end
  end
end
assign dp2reg_status_unequal = dfifo3_unequal | dfifo2_unequal | dfifo1_unequal | dfifo0_unequal;

//===========================
// op_done
//===========================
assign layer_done = dat_accept & cmd_cube_end & is_last_beat;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_done <= 1'b0;
  end else begin
  dp2reg_done <= layer_done;
  end
end

//===========================
// DMA OUTPUT
//===========================
// packet: cmd
assign dma_wr_cmd_vld  = cmd_en & cmd_vld;
assign dma_wr_cmd_addr = {cmd_addr,5'd0};
assign dma_wr_cmd_size = cmd_size;
assign dma_wr_cmd_require_ack   = cmd_cube_end;

// PKT_PACK_WIRE( dma_write_cmd ,  dma_wr_cmd_ ,  dma_wr_cmd_pd )
assign       dma_wr_cmd_pd[63:0] =     dma_wr_cmd_addr[63:0];
assign       dma_wr_cmd_pd[76:64] =     dma_wr_cmd_size[12:0];
assign       dma_wr_cmd_pd[77] =     dma_wr_cmd_require_ack ;
// packet: data
assign dma_wr_dat_vld  = dat_en & dat_vld;
assign dma_wr_dat_data = dat_pd;
assign dma_wr_dat_mask = (is_size_odd && is_last_beat) ? 2'b01 : 2'b11;

// PKT_PACK_WIRE( dma_write_data ,  dma_wr_dat_ ,  dma_wr_dat_pd )
assign       dma_wr_dat_pd[511:0] =     dma_wr_dat_data[511:0];
assign       dma_wr_dat_pd[513:512] =     dma_wr_dat_mask[1:0];

// pack cmd & dat
assign dma_wr_req_vld = (dma_wr_cmd_vld | dma_wr_dat_vld) & !cfg_mode_quite;
always @(
  cmd_en
  or dma_wr_cmd_pd
  or dma_wr_dat_pd
  ) begin
    // init to 0
    dma_wr_req_pd[513:0] = 0;
    // cmd or dat
    if (cmd_en) begin
        dma_wr_req_pd[77:0] = dma_wr_cmd_pd;
    end else begin
        dma_wr_req_pd[513:0] = dma_wr_dat_pd;
    end
    // pkt id
    dma_wr_req_pd[514:514] = cmd_en ? 1'd0  /* PKT_nvdla_dma_wr_req_dma_write_cmd_ID  */  : 1'd1  /* PKT_nvdla_dma_wr_req_dma_write_data_ID  */ ;
end

//==============
// DMA Interface
//==============
assign dma_wr_req_type = reg2dp_dst_ram_type;

//==============
// INTR Interface
//==============
assign intr_req_ptr    = reg2dp_interrupt_ptr;
assign intr_req_pvld  = dat_accept & is_last_beat & cmd_cube_end;

//==============
// FUNCTION POINT
//==============

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    reg funcpoint_cover_off;
    initial begin
        if ( $test$plusargs( "cover_off" ) ) begin
            funcpoint_cover_off = 1'b1;
        end else begin
            funcpoint_cover_off = 1'b0;
        end
    end

    property sdp_wdma_dout__interrupt_point0__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((intr_req_pvld) && nvdla_core_rstn) |-> (intr_req_ptr==0);
    endproperty
    // Cover 0 : "intr_req_ptr==0"
    FUNCPOINT_sdp_wdma_dout__interrupt_point0__0_COV : cover property (sdp_wdma_dout__interrupt_point0__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property sdp_wdma_dout__interrupt_point1__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((intr_req_pvld) && nvdla_core_rstn) |-> (intr_req_ptr==1);
    endproperty
    // Cover 1 : "intr_req_ptr==1"
    FUNCPOINT_sdp_wdma_dout__interrupt_point1__1_COV : cover property (sdp_wdma_dout__interrupt_point1__1_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_SDP_WDMA_DAT_out

