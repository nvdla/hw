// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDP_wdma.v

`include "simulate_x_tick.vh"
module NV_NVDLA_CDP_wdma (
   nvdla_core_clk             //|< i
  ,nvdla_core_clk_orig        //|< i
  ,nvdla_core_rstn            //|< i
  ,cdp2cvif_wr_req_ready      //|< i
  ,cdp2mcif_wr_req_ready      //|< i
  ,cdp_dp2wdma_pd             //|< i
  ,cdp_dp2wdma_valid          //|< i
  ,cvif2cdp_wr_rsp_complete   //|< i
  ,mcif2cdp_wr_rsp_complete   //|< i
  ,pwrbus_ram_pd              //|< i
  ,reg2dp_dma_en              //|< i
  ,reg2dp_dst_base_addr_high  //|< i
  ,reg2dp_dst_base_addr_low   //|< i
  ,reg2dp_dst_line_stride     //|< i
  ,reg2dp_dst_ram_type        //|< i
  ,reg2dp_dst_surface_stride  //|< i
  ,reg2dp_input_data_type     //|< i
  ,reg2dp_interrupt_ptr       //|< i
  ,reg2dp_op_en               //|< i
  ,cdp2cvif_wr_req_pd         //|> o
  ,cdp2cvif_wr_req_valid      //|> o
  ,cdp2glb_done_intr_pd       //|> o
  ,cdp2mcif_wr_req_pd         //|> o
  ,cdp2mcif_wr_req_valid      //|> o
  ,cdp_dp2wdma_ready          //|> o
  ,dp2reg_d0_perf_write_stall //|> o
  ,dp2reg_d1_perf_write_stall //|> o
  ,dp2reg_done                //|> o
  ,dp2reg_nan_output_num      //|> o
  );
//
// NV_NVDLA_CDP_wdma_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

output         cdp2mcif_wr_req_valid;  /* data valid */
input          cdp2mcif_wr_req_ready;  /* data return handshake */
output [514:0] cdp2mcif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input  mcif2cdp_wr_rsp_complete;

output         cdp2cvif_wr_req_valid;  /* data valid */
input          cdp2cvif_wr_req_ready;  /* data return handshake */
output [514:0] cdp2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input  cvif2cdp_wr_rsp_complete;

input         cdp_dp2wdma_valid;  /* data valid */
output        cdp_dp2wdma_ready;  /* data return handshake */
input  [78:0] cdp_dp2wdma_pd;

output [1:0] cdp2glb_done_intr_pd;

input   nvdla_core_clk_orig;
input   [31:0] pwrbus_ram_pd;
input          reg2dp_dma_en;
input   [31:0] reg2dp_dst_base_addr_high;
input   [26:0] reg2dp_dst_base_addr_low;
input   [26:0] reg2dp_dst_line_stride;
input          reg2dp_dst_ram_type;
input   [26:0] reg2dp_dst_surface_stride;
input    [1:0] reg2dp_input_data_type;
input          reg2dp_interrupt_ptr;
input          reg2dp_op_en;
output  [31:0] dp2reg_d0_perf_write_stall;
output  [31:0] dp2reg_d1_perf_write_stall;
output         dp2reg_done;
output  [31:0] dp2reg_nan_output_num;
reg            ack_bot_id;
reg            ack_bot_vld;
reg            ack_top_id;
reg            ack_top_vld;
reg     [63:0] base_addr_c;
reg     [63:0] base_addr_w;
reg      [2:0] beat_cnt;
reg      [1:0] cdp2glb_done_intr_pd;
reg            cdp_dp2wdma_ready;
reg     [31:0] cdp_wr_stall_count;
reg            cmd_en;
reg      [2:0] cmd_fifo_rd_pos_w_reg;
reg            cv_dma_wr_rsp_complete;
reg            cv_pending;
reg            dat_en;
reg     [63:0] dma_req_addr;
reg    [514:0] dma_wr_req_pd;
reg            dma_wr_rsp_complete;
reg     [31:0] dp2reg_d0_perf_write_stall;
reg     [31:0] dp2reg_d1_perf_write_stall;
reg     [31:0] dp2reg_nan_output_num;
reg     [78:0] dp2wdma_pd;
reg            dp2wdma_vld;
reg            fp16_en;
reg            is_beat_num_odd;
reg            layer_flag;
reg            mc_dma_wr_rsp_complete;
reg            mc_pending;
reg            mon_base_addr_c_c;
reg            mon_base_addr_w_c;
reg            mon_dma_req_addr_c;
reg            mon_nan_in_count;
reg     [31:0] nan_in_count;
reg            op_prcess;
reg     [78:0] p1_pipe_data;
reg     [78:0] p1_pipe_rand_data;
reg            p1_pipe_rand_ready;
reg            p1_pipe_rand_valid;
reg            p1_pipe_ready;
reg            p1_pipe_ready_bc;
reg            p1_pipe_valid;
reg            p1_skid_catch;
reg     [78:0] p1_skid_data;
reg     [78:0] p1_skid_pipe_data;
reg            p1_skid_pipe_ready;
reg            p1_skid_pipe_valid;
reg            p1_skid_ready;
reg            p1_skid_ready_flop;
reg            p1_skid_valid;
reg            reg_cube_last;
reg      [2:0] req_chn_size;
reg            stl_adv;
reg     [31:0] stl_cnt_cur;
reg     [33:0] stl_cnt_dec;
reg     [33:0] stl_cnt_ext;
reg     [33:0] stl_cnt_inc;
reg     [33:0] stl_cnt_mod;
reg     [33:0] stl_cnt_new;
reg     [33:0] stl_cnt_nxt;
wire           ack_bot_rdy;
wire           ack_raw_id;
wire           ack_raw_rdy;
wire           ack_raw_vld;
wire           ack_top_rdy;
wire           cdp_wr_stall_count_dec;
wire           cmd_accept;
wire           cmd_fifo_rd_b_sync;
wire           cmd_fifo_rd_b_sync_NC;
wire           cmd_fifo_rd_last_c;
wire           cmd_fifo_rd_last_h;
wire           cmd_fifo_rd_last_w;
wire    [14:0] cmd_fifo_rd_pd;
wire     [2:0] cmd_fifo_rd_pos_c;
wire     [3:0] cmd_fifo_rd_pos_w;
wire           cmd_fifo_rd_prdy;
wire           cmd_fifo_rd_pvld;
wire     [3:0] cmd_fifo_rd_width;
wire    [14:0] cmd_fifo_wr_pd;
wire           cmd_fifo_wr_prdy;
wire           cmd_fifo_wr_pvld;
wire           cmd_rdy;
wire           cmd_vld;
wire           cnt_cen;
wire           cnt_clr;
wire           cnt_inc;
wire           cv_dma_wr_req_rdy;
wire           cv_dma_wr_req_vld;
wire   [514:0] cv_int_wr_req_pd;
wire   [514:0] cv_int_wr_req_pd_d0;
wire           cv_int_wr_req_ready;
wire           cv_int_wr_req_ready_d0;
wire           cv_int_wr_req_valid;
wire           cv_int_wr_req_valid_d0;
wire           cv_int_wr_rsp_complete;
wire           cv_releasing;
wire           cv_wr_req_rdyi;
wire   [255:0] dat0_data;
wire    [63:0] dat0_fifo0_rd_pd;
wire           dat0_fifo0_rd_prdy;
wire           dat0_fifo0_rd_pvld;
wire    [63:0] dat0_fifo0_wr_pd;
wire           dat0_fifo0_wr_prdy;
wire           dat0_fifo0_wr_pvld;
wire    [63:0] dat0_fifo1_rd_pd;
wire           dat0_fifo1_rd_prdy;
wire           dat0_fifo1_rd_pvld;
wire    [63:0] dat0_fifo1_wr_pd;
wire           dat0_fifo1_wr_prdy;
wire           dat0_fifo1_wr_pvld;
wire    [63:0] dat0_fifo2_rd_pd;
wire           dat0_fifo2_rd_prdy;
wire           dat0_fifo2_rd_pvld;
wire    [63:0] dat0_fifo2_wr_pd;
wire           dat0_fifo2_wr_prdy;
wire           dat0_fifo2_wr_pvld;
wire    [63:0] dat0_fifo3_rd_pd;
wire           dat0_fifo3_rd_prdy;
wire           dat0_fifo3_rd_pvld;
wire    [63:0] dat0_fifo3_wr_pd;
wire           dat0_fifo3_wr_prdy;
wire           dat0_fifo3_wr_pvld;
wire           dat0_fifo_rd_pvld;
wire     [3:0] dat0_is_nan_0;
wire     [3:0] dat0_is_nan_1;
wire     [3:0] dat0_is_nan_2;
wire     [3:0] dat0_is_nan_3;
wire           dat0_rdy;
wire           dat0_vld;
wire     [3:0] dat0_vlds;
wire   [255:0] dat1_data;
wire    [63:0] dat1_fifo0_rd_pd;
wire           dat1_fifo0_rd_prdy;
wire           dat1_fifo0_rd_pvld;
wire    [63:0] dat1_fifo0_wr_pd;
wire           dat1_fifo0_wr_prdy;
wire           dat1_fifo0_wr_pvld;
wire    [63:0] dat1_fifo1_rd_pd;
wire           dat1_fifo1_rd_prdy;
wire           dat1_fifo1_rd_pvld;
wire    [63:0] dat1_fifo1_wr_pd;
wire           dat1_fifo1_wr_prdy;
wire           dat1_fifo1_wr_pvld;
wire    [63:0] dat1_fifo2_rd_pd;
wire           dat1_fifo2_rd_prdy;
wire           dat1_fifo2_rd_pvld;
wire    [63:0] dat1_fifo2_wr_pd;
wire           dat1_fifo2_wr_prdy;
wire           dat1_fifo2_wr_pvld;
wire    [63:0] dat1_fifo3_rd_pd;
wire           dat1_fifo3_rd_prdy;
wire           dat1_fifo3_rd_pvld;
wire    [63:0] dat1_fifo3_wr_pd;
wire           dat1_fifo3_wr_prdy;
wire           dat1_fifo3_wr_pvld;
wire           dat1_fifo_rd_pvld;
wire     [3:0] dat1_is_nan_0;
wire     [3:0] dat1_is_nan_1;
wire     [3:0] dat1_is_nan_2;
wire     [3:0] dat1_is_nan_3;
wire           dat1_rdy;
wire           dat1_vld;
wire     [3:0] dat1_vlds;
wire           dat_accept;
wire   [511:0] dat_data;
wire           dat_fifo_wr_rdy;
wire           dat_rdy;
wire           dat_vld;
wire    [63:0] dma_wr_cmd_addr;
wire    [77:0] dma_wr_cmd_pd;
wire           dma_wr_cmd_require_ack;
wire    [12:0] dma_wr_cmd_size;
wire           dma_wr_cmd_vld;
wire   [511:0] dma_wr_dat_data;
wire     [1:0] dma_wr_dat_mask;
wire   [513:0] dma_wr_dat_pd;
wire           dma_wr_dat_vld;
wire           dma_wr_req_rdy;
wire           dma_wr_req_type;
wire           dma_wr_req_vld;
wire           dp2wdma_b_sync;
wire    [14:0] dp2wdma_cmd_pd;
wire    [63:0] dp2wdma_dat_pd;
wire    [63:0] dp2wdma_data;
wire           dp2wdma_last_c;
wire           dp2wdma_last_h;
wire           dp2wdma_last_w;
wire     [2:0] dp2wdma_pos_c;
wire     [3:0] dp2wdma_pos_w;
wire           dp2wdma_pos_w_bit0;
wire           dp2wdma_rdy;
wire     [3:0] dp2wdma_width;
wire           fp16_en_f;
wire           intr_fifo_rd_pd;
wire           intr_fifo_rd_prdy;
wire           intr_fifo_rd_pvld;
wire           intr_fifo_wr_pd;
wire           intr_fifo_wr_pvld;
wire           is_cube_last;
wire           is_last_beat;
wire           is_last_beat_in_block;
wire           is_last_c;
wire           is_last_h;
wire           is_last_w;
wire           mc_dma_wr_req_rdy;
wire           mc_dma_wr_req_vld;
wire   [514:0] mc_int_wr_req_pd;
wire   [514:0] mc_int_wr_req_pd_d0;
wire           mc_int_wr_req_ready;
wire           mc_int_wr_req_ready_d0;
wire           mc_int_wr_req_valid;
wire           mc_int_wr_req_valid_d0;
wire           mc_int_wr_rsp_complete;
wire           mc_releasing;
wire           mc_wr_req_rdyi;
wire     [5:0] nan_num_in_64B;
wire    [31:0] nan_num_in_x;
wire           op_done;
wire           op_load;
wire    [63:0] reg2dp_base_addr;
wire    [63:0] reg2dp_dst_base_addr;
wire    [31:0] reg2dp_line_stride;
wire    [31:0] reg2dp_surf_stride;
wire           releasing;
wire           require_ack;
wire     [3:0] width_size;
wire     [3:0] width_size_use;
wire           wr_req_rdyi;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
//==============
// Work Processing
//==============
assign op_load = reg2dp_op_en & !op_prcess;
assign op_done = reg_cube_last & is_last_beat_in_block & dat_accept;
assign dp2reg_done = op_done;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    op_prcess <= 1'b0;
  end else begin
    if (op_load) begin
        op_prcess <= 1'b1;
    end else if (op_done) begin
        op_prcess <= 1'b0;
    end
  end
end
//==============
// Configure from Register
//==============
assign reg2dp_dst_base_addr = {reg2dp_dst_base_addr_high,reg2dp_dst_base_addr_low,5'd0};

//==============
// Data INPUT pipe and Unpack
//==============
//## pipe (1) randomizer
`ifndef SYNTHESIS
reg p1_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p1_pipe_rand_active
  or 
     `endif
     cdp_dp2wdma_valid
  or p1_pipe_rand_ready
  or cdp_dp2wdma_pd
  ) begin
  `ifdef SYNTHESIS
  p1_pipe_rand_valid = cdp_dp2wdma_valid;
  cdp_dp2wdma_ready = p1_pipe_rand_ready;
  p1_pipe_rand_data = cdp_dp2wdma_pd;
  `else
  // VCS coverage off
  p1_pipe_rand_valid = (p1_pipe_rand_active)? 1'b0 : cdp_dp2wdma_valid;
  cdp_dp2wdma_ready = (p1_pipe_rand_active)? 1'b0 : p1_pipe_rand_ready;
  p1_pipe_rand_data = (p1_pipe_rand_active)?  'bx : cdp_dp2wdma_pd;
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p1_pipe_stall_cycles;
integer p1_pipe_stall_probability;
integer p1_pipe_stall_cycles_min;
integer p1_pipe_stall_cycles_max;
initial begin
  p1_pipe_stall_cycles = 0;
  p1_pipe_stall_probability = 0;
  p1_pipe_stall_cycles_min = 1;
  p1_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_CDP_wdma_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDP_wdma_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDP_wdma_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDP_wdma_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDP_wdma_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDP_wdma_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDP_wdma_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p1_pipe_rand_enable;
reg p1_pipe_rand_poised;
always @(
  p1_pipe_stall_cycles
  or p1_pipe_stall_probability
  or cdp_dp2wdma_valid
  ) begin
  p1_pipe_rand_active = p1_pipe_stall_cycles != 0;
  p1_pipe_rand_enable = p1_pipe_stall_probability != 0;
  p1_pipe_rand_poised = p1_pipe_rand_enable && !p1_pipe_rand_active && cdp_dp2wdma_valid === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p1_pipe_rand_poised) begin
    if (p1_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p1_pipe_stall_cycles <= prand_inst1(p1_pipe_stall_cycles_min, p1_pipe_stall_cycles_max);
    end
  end else if (p1_pipe_rand_active) begin
    p1_pipe_stall_cycles <= p1_pipe_stall_cycles - 1;
  end else begin
    p1_pipe_stall_cycles <= 0;
  end
  end
end

`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
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
            // magic numbers taken from Java's random class (same as lrand48)
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
// Only verilog needs any local variables
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
            // magic numbers taken from Java's random class (same as lrand48)
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

`endif
// VCS coverage on
//## pipe (1) skid buffer
always @(
  p1_pipe_rand_valid
  or p1_skid_ready_flop
  or p1_skid_pipe_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = p1_pipe_rand_valid && p1_skid_ready_flop && !p1_skid_pipe_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_skid_pipe_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    p1_pipe_rand_ready <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_skid_pipe_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  p1_pipe_rand_ready <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? p1_pipe_rand_data : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or p1_pipe_rand_valid
  or p1_skid_valid
  or p1_pipe_rand_data
  or p1_skid_data
  ) begin
  p1_skid_pipe_valid = (p1_skid_ready_flop)? p1_pipe_rand_valid : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_skid_pipe_data = (p1_skid_ready_flop)? p1_pipe_rand_data : p1_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (1) valid-ready-bubble-collapse
always @(
  p1_pipe_ready
  or p1_pipe_valid
  ) begin
  p1_pipe_ready_bc = p1_pipe_ready || !p1_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_valid <= 1'b0;
  end else begin
  p1_pipe_valid <= (p1_pipe_ready_bc)? p1_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && p1_skid_pipe_valid)? p1_skid_pipe_data : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  p1_skid_pipe_ready = p1_pipe_ready_bc;
end
//## pipe (1) output
always @(
  p1_pipe_valid
  or dp2wdma_rdy
  or p1_pipe_data
  ) begin
  dp2wdma_vld = p1_pipe_valid;
  p1_pipe_ready = dp2wdma_rdy;
  dp2wdma_pd = p1_pipe_data;
end
//## pipe (1) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p1_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (dp2wdma_vld^dp2wdma_rdy^cdp_dp2wdma_valid^cdp_dp2wdma_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (cdp_dp2wdma_valid && !cdp_dp2wdma_ready), (cdp_dp2wdma_valid), (cdp_dp2wdma_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif

// PKT_UNPACK_WIRE( cdp_dp2wdma , dp2wdma_ , dp2wdma_pd )
assign       dp2wdma_data[63:0] =    dp2wdma_pd[63:0];
assign       dp2wdma_pos_w[3:0] =    dp2wdma_pd[67:64];
assign       dp2wdma_width[3:0] =    dp2wdma_pd[71:68];
assign       dp2wdma_pos_c[2:0] =    dp2wdma_pd[74:72];
assign        dp2wdma_b_sync  =    dp2wdma_pd[75];
assign        dp2wdma_last_w  =    dp2wdma_pd[76];
assign        dp2wdma_last_h  =    dp2wdma_pd[77];
assign        dp2wdma_last_c  =    dp2wdma_pd[78];
//assign dp2wdma_data [63:0] =    dp2wdma_pd[63:0];
//assign dp2wdma_pos_w [3:0] =    dp2wdma_pd[67:64];
//assign dp2wdma_width [3:0] =    dp2wdma_pd[71:68];
//assign dp2wdma_pos_c [2:0] =    dp2wdma_pd[74:72];
//assign dp2wdma_b_sync  =    dp2wdma_pd[ 75 ];
//assign dp2wdma_last_w  =    dp2wdma_pd[ 76 ];
//assign dp2wdma_last_h  =    dp2wdma_pd[ 77 ];
//assign dp2wdma_last_c  =    dp2wdma_pd[ 78 ];

// PKT_PACK_WIRE( cdp_dp2wdma_cmd , dp2wdma_ , dp2wdma_cmd_pd )
assign      dp2wdma_cmd_pd[3:0] =    dp2wdma_pos_w[3:0];
assign      dp2wdma_cmd_pd[7:4] =    dp2wdma_width[3:0];
assign      dp2wdma_cmd_pd[10:8] =    dp2wdma_pos_c[2:0];
assign      dp2wdma_cmd_pd[11] =    dp2wdma_b_sync ;
assign      dp2wdma_cmd_pd[12] =    dp2wdma_last_w ;
assign      dp2wdma_cmd_pd[13] =    dp2wdma_last_h ;
assign      dp2wdma_cmd_pd[14] =    dp2wdma_last_c ;
//assign dp2wdma_cmd_pd[3:0] =    dp2wdma_pos_w [3:0];
//assign dp2wdma_cmd_pd[7:4] =    dp2wdma_width [3:0];
//assign dp2wdma_cmd_pd[10:8] =    dp2wdma_pos_c [2:0];
//assign dp2wdma_cmd_pd[ 11 ] =    dp2wdma_b_sync ;
//assign dp2wdma_cmd_pd[ 12 ] =    dp2wdma_last_w ;
//assign dp2wdma_cmd_pd[ 13 ] =    dp2wdma_last_h ;
//assign dp2wdma_cmd_pd[ 14 ] =    dp2wdma_last_c ;

// PKT_PACK_WIRE( cdp_dp2wdma_dat , dp2wdma_ , dp2wdma_dat_pd )
assign      dp2wdma_dat_pd[63:0] =    dp2wdma_data[63:0];
//assign dp2wdma_dat_pd[63:0] =    dp2wdma_data [63:0];

//DorisLei
//assign dp2wdma_b_sync_use = dp2wdma_vld && dp2wdma_b_sync;

// when b_sync, both cmd.fifo and dat.fifo need be ready, when !b_sync, only dat.fifo need be ready
assign dp2wdma_rdy = dp2wdma_vld & (dp2wdma_b_sync ? (dat_fifo_wr_rdy & cmd_fifo_wr_prdy) : dat_fifo_wr_rdy);

//==============
// Input FIFO : DATA and its swizzle
//==============
// if start_addr is 32byte aligned, we need swizzle the high & low data
assign dp2wdma_pos_w_bit0 = dp2wdma_pos_w[0];
// if b_sync, need push into both data_fifo and cmd_fifo, if !b_sync, only dat_fifo is needed
// FIFO instance
//assign dat0_fifo0_wr_pvld = (!dp2wdma_b_sync_use) || (dp2wdma_b_sync & cmd_fifo_wr_prdy) & dp2wdma_vld & (dp2wdma_pos_c==0) & (dp2wdma_pos_w==0);
assign dat0_fifo0_wr_pvld = ((!dp2wdma_b_sync) || (dp2wdma_b_sync & cmd_fifo_wr_prdy)) & dp2wdma_vld & (dp2wdma_pos_c==0) & (dp2wdma_pos_w_bit0==0);
assign dat0_fifo0_wr_pd   = dp2wdma_dat_pd[63:0];

NV_NVDLA_CDP_WDMA_dat_fifo u_dat0_fifo0 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.dat_fifo_wr_prdy    (dat0_fifo0_wr_prdy)      //|> w
  ,.dat_fifo_wr_pvld    (dat0_fifo0_wr_pvld)      //|< w
  ,.dat_fifo_wr_pd      (dat0_fifo0_wr_pd[63:0])  //|< w
  ,.dat_fifo_rd_prdy    (dat0_fifo0_rd_prdy)      //|< w
  ,.dat_fifo_rd_pvld    (dat0_fifo0_rd_pvld)      //|> w
  ,.dat_fifo_rd_pd      (dat0_fifo0_rd_pd[63:0])  //|> w
  ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])     //|< i
  );

assign dat0_fifo0_rd_prdy = dat0_rdy & (0 <= req_chn_size);
//assign dat0_fifo1_wr_pvld = (!dp2wdma_b_sync_use) || (dp2wdma_b_sync & cmd_fifo_wr_prdy) & dp2wdma_vld & (dp2wdma_pos_c==1) & (dp2wdma_pos_w==0);
assign dat0_fifo1_wr_pvld = ((!dp2wdma_b_sync) || (dp2wdma_b_sync & cmd_fifo_wr_prdy)) & dp2wdma_vld & (dp2wdma_pos_c==1) & (dp2wdma_pos_w_bit0==0);
assign dat0_fifo1_wr_pd   = dp2wdma_dat_pd[63:0];

NV_NVDLA_CDP_WDMA_dat_fifo u_dat0_fifo1 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.dat_fifo_wr_prdy    (dat0_fifo1_wr_prdy)      //|> w
  ,.dat_fifo_wr_pvld    (dat0_fifo1_wr_pvld)      //|< w
  ,.dat_fifo_wr_pd      (dat0_fifo1_wr_pd[63:0])  //|< w
  ,.dat_fifo_rd_prdy    (dat0_fifo1_rd_prdy)      //|< w
  ,.dat_fifo_rd_pvld    (dat0_fifo1_rd_pvld)      //|> w
  ,.dat_fifo_rd_pd      (dat0_fifo1_rd_pd[63:0])  //|> w
  ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])     //|< i
  );

assign dat0_fifo1_rd_prdy = dat0_rdy & (1 <= req_chn_size);
//assign dat0_fifo2_wr_pvld = (!dp2wdma_b_sync_use) || (dp2wdma_b_sync & cmd_fifo_wr_prdy) & dp2wdma_vld & (dp2wdma_pos_c==2) & (dp2wdma_pos_w==0);
assign dat0_fifo2_wr_pvld = ((!dp2wdma_b_sync) || (dp2wdma_b_sync & cmd_fifo_wr_prdy)) & dp2wdma_vld & (dp2wdma_pos_c==2) & (dp2wdma_pos_w_bit0==0);
assign dat0_fifo2_wr_pd   = dp2wdma_dat_pd[63:0];

NV_NVDLA_CDP_WDMA_dat_fifo u_dat0_fifo2 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.dat_fifo_wr_prdy    (dat0_fifo2_wr_prdy)      //|> w
  ,.dat_fifo_wr_pvld    (dat0_fifo2_wr_pvld)      //|< w
  ,.dat_fifo_wr_pd      (dat0_fifo2_wr_pd[63:0])  //|< w
  ,.dat_fifo_rd_prdy    (dat0_fifo2_rd_prdy)      //|< w
  ,.dat_fifo_rd_pvld    (dat0_fifo2_rd_pvld)      //|> w
  ,.dat_fifo_rd_pd      (dat0_fifo2_rd_pd[63:0])  //|> w
  ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])     //|< i
  );

assign dat0_fifo2_rd_prdy = dat0_rdy & (2 <= req_chn_size);
//assign dat0_fifo3_wr_pvld = (!dp2wdma_b_sync_use) || (dp2wdma_b_sync & cmd_fifo_wr_prdy) & dp2wdma_vld & (dp2wdma_pos_c==3) & (dp2wdma_pos_w==0);
assign dat0_fifo3_wr_pvld = ((!dp2wdma_b_sync) || (dp2wdma_b_sync & cmd_fifo_wr_prdy)) & dp2wdma_vld & (dp2wdma_pos_c==3) & (dp2wdma_pos_w_bit0==0);
assign dat0_fifo3_wr_pd   = dp2wdma_dat_pd[63:0];

NV_NVDLA_CDP_WDMA_dat_fifo u_dat0_fifo3 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.dat_fifo_wr_prdy    (dat0_fifo3_wr_prdy)      //|> w
  ,.dat_fifo_wr_pvld    (dat0_fifo3_wr_pvld)      //|< w
  ,.dat_fifo_wr_pd      (dat0_fifo3_wr_pd[63:0])  //|< w
  ,.dat_fifo_rd_prdy    (dat0_fifo3_rd_prdy)      //|< w
  ,.dat_fifo_rd_pvld    (dat0_fifo3_rd_pvld)      //|> w
  ,.dat_fifo_rd_pd      (dat0_fifo3_rd_pd[63:0])  //|> w
  ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])     //|< i
  );

assign dat0_fifo3_rd_prdy = dat0_rdy & (3 <= req_chn_size);
//assign dat1_fifo0_wr_pvld = (!dp2wdma_b_sync_use) || (dp2wdma_b_sync & cmd_fifo_wr_prdy) & dp2wdma_vld & (dp2wdma_pos_c==0) & (dp2wdma_pos_w==1);
assign dat1_fifo0_wr_pvld = ((!dp2wdma_b_sync) || (dp2wdma_b_sync & cmd_fifo_wr_prdy)) & dp2wdma_vld & (dp2wdma_pos_c==0) & (dp2wdma_pos_w_bit0==1);
assign dat1_fifo0_wr_pd   = dp2wdma_dat_pd[63:0];

NV_NVDLA_CDP_WDMA_dat_fifo u_dat1_fifo0 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.dat_fifo_wr_prdy    (dat1_fifo0_wr_prdy)      //|> w
  ,.dat_fifo_wr_pvld    (dat1_fifo0_wr_pvld)      //|< w
  ,.dat_fifo_wr_pd      (dat1_fifo0_wr_pd[63:0])  //|< w
  ,.dat_fifo_rd_prdy    (dat1_fifo0_rd_prdy)      //|< w
  ,.dat_fifo_rd_pvld    (dat1_fifo0_rd_pvld)      //|> w
  ,.dat_fifo_rd_pd      (dat1_fifo0_rd_pd[63:0])  //|> w
  ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])     //|< i
  );

assign dat1_fifo0_rd_prdy = dat1_rdy & (0 <= req_chn_size);
//assign dat1_fifo1_wr_pvld = (!dp2wdma_b_sync_use) || (dp2wdma_b_sync & cmd_fifo_wr_prdy) & dp2wdma_vld & (dp2wdma_pos_c==1) & (dp2wdma_pos_w==1);
assign dat1_fifo1_wr_pvld = ((!dp2wdma_b_sync) || (dp2wdma_b_sync & cmd_fifo_wr_prdy)) & dp2wdma_vld & (dp2wdma_pos_c==1) & (dp2wdma_pos_w_bit0==1);
assign dat1_fifo1_wr_pd   = dp2wdma_dat_pd[63:0];

NV_NVDLA_CDP_WDMA_dat_fifo u_dat1_fifo1 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.dat_fifo_wr_prdy    (dat1_fifo1_wr_prdy)      //|> w
  ,.dat_fifo_wr_pvld    (dat1_fifo1_wr_pvld)      //|< w
  ,.dat_fifo_wr_pd      (dat1_fifo1_wr_pd[63:0])  //|< w
  ,.dat_fifo_rd_prdy    (dat1_fifo1_rd_prdy)      //|< w
  ,.dat_fifo_rd_pvld    (dat1_fifo1_rd_pvld)      //|> w
  ,.dat_fifo_rd_pd      (dat1_fifo1_rd_pd[63:0])  //|> w
  ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])     //|< i
  );

assign dat1_fifo1_rd_prdy = dat1_rdy & (1 <= req_chn_size);
//assign dat1_fifo2_wr_pvld = (!dp2wdma_b_sync_use) || (dp2wdma_b_sync & cmd_fifo_wr_prdy) & dp2wdma_vld & (dp2wdma_pos_c==2) & (dp2wdma_pos_w==1);
assign dat1_fifo2_wr_pvld = ((!dp2wdma_b_sync) || (dp2wdma_b_sync & cmd_fifo_wr_prdy)) & dp2wdma_vld & (dp2wdma_pos_c==2) & (dp2wdma_pos_w_bit0==1);
assign dat1_fifo2_wr_pd   = dp2wdma_dat_pd[63:0];

NV_NVDLA_CDP_WDMA_dat_fifo u_dat1_fifo2 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.dat_fifo_wr_prdy    (dat1_fifo2_wr_prdy)      //|> w
  ,.dat_fifo_wr_pvld    (dat1_fifo2_wr_pvld)      //|< w
  ,.dat_fifo_wr_pd      (dat1_fifo2_wr_pd[63:0])  //|< w
  ,.dat_fifo_rd_prdy    (dat1_fifo2_rd_prdy)      //|< w
  ,.dat_fifo_rd_pvld    (dat1_fifo2_rd_pvld)      //|> w
  ,.dat_fifo_rd_pd      (dat1_fifo2_rd_pd[63:0])  //|> w
  ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])     //|< i
  );

assign dat1_fifo2_rd_prdy = dat1_rdy & (2 <= req_chn_size);
//assign dat1_fifo3_wr_pvld = (!dp2wdma_b_sync_use) || (dp2wdma_b_sync & cmd_fifo_wr_prdy) & dp2wdma_vld & (dp2wdma_pos_c==3) & (dp2wdma_pos_w==1);
assign dat1_fifo3_wr_pvld = ((!dp2wdma_b_sync) || (dp2wdma_b_sync & cmd_fifo_wr_prdy)) & dp2wdma_vld & (dp2wdma_pos_c==3) & (dp2wdma_pos_w_bit0==1);
assign dat1_fifo3_wr_pd   = dp2wdma_dat_pd[63:0];

NV_NVDLA_CDP_WDMA_dat_fifo u_dat1_fifo3 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.dat_fifo_wr_prdy    (dat1_fifo3_wr_prdy)      //|> w
  ,.dat_fifo_wr_pvld    (dat1_fifo3_wr_pvld)      //|< w
  ,.dat_fifo_wr_pd      (dat1_fifo3_wr_pd[63:0])  //|< w
  ,.dat_fifo_rd_prdy    (dat1_fifo3_rd_prdy)      //|< w
  ,.dat_fifo_rd_pvld    (dat1_fifo3_rd_pvld)      //|> w
  ,.dat_fifo_rd_pd      (dat1_fifo3_rd_pd[63:0])  //|> w
  ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])     //|< i
  );

assign dat1_fifo3_rd_prdy = dat1_rdy & (3 <= req_chn_size);
assign dat_fifo_wr_rdy = (dat0_fifo0_wr_prdy & (dp2wdma_pos_c==0) & (dp2wdma_pos_w_bit0==0)) 
| (dat0_fifo1_wr_prdy & (dp2wdma_pos_c==1) & (dp2wdma_pos_w_bit0==0)) 
| (dat0_fifo2_wr_prdy & (dp2wdma_pos_c==2) & (dp2wdma_pos_w_bit0==0)) 
| (dat0_fifo3_wr_prdy & (dp2wdma_pos_c==3) & (dp2wdma_pos_w_bit0==0)) 
| (dat1_fifo0_wr_prdy & (dp2wdma_pos_c==0) & (dp2wdma_pos_w_bit0==1)) 
| (dat1_fifo1_wr_prdy & (dp2wdma_pos_c==1) & (dp2wdma_pos_w_bit0==1)) 
| (dat1_fifo2_wr_prdy & (dp2wdma_pos_c==2) & (dp2wdma_pos_w_bit0==1)) 
| (dat1_fifo3_wr_prdy & (dp2wdma_pos_c==3) & (dp2wdma_pos_w_bit0==1));
assign dat0_vlds[3:0] = {dat0_fifo3_rd_pvld, dat0_fifo2_rd_pvld, dat0_fifo1_rd_pvld, dat0_fifo0_rd_pvld};
assign dat1_vlds[3:0] = {dat1_fifo3_rd_pvld, dat1_fifo2_rd_pvld, dat1_fifo1_rd_pvld, dat1_fifo0_rd_pvld};
//Doris
//assign dat0_rdys[::range(4)] = {::replcat_dn(4, ", ", 'dat0_fifo${ii}_rd_prdy')};
//assign dat1_rdys[::range(4)] = {::replcat_dn(4, ", ", 'dat1_fifo${ii}_rd_prdy')};
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
  nv_assert_never #(0,0,"CDP-WDMA: dat0 rdys should be all 1 or all 0")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, (dat0_fifo0_rd_prdy & dat0_fifo1_rd_prdy & dat0_fifo2_rd_prdy & dat0_fifo3_rd_prdy)!=(dat0_fifo0_rd_prdy | dat0_fifo1_rd_prdy | dat0_fifo2_rd_prdy | dat0_fifo3_rd_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"CDP-WDMA: dat0 rdys should be all 1 or all 0")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, (dat1_fifo0_rd_prdy & dat1_fifo1_rd_prdy & dat1_fifo2_rd_prdy & dat1_fifo3_rd_prdy)!=(dat1_fifo0_rd_prdy | dat1_fifo1_rd_prdy | dat1_fifo2_rd_prdy | dat1_fifo3_rd_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign dat0_fifo_rd_pvld = &dat0_vlds;
assign dat1_fifo_rd_pvld = &dat1_vlds;

assign dat0_data= {dat0_fifo3_rd_pd, dat0_fifo2_rd_pd, dat0_fifo1_rd_pd, dat0_fifo0_rd_pd};
assign dat1_data= {dat1_fifo3_rd_pd, dat1_fifo2_rd_pd, dat1_fifo1_rd_pd, dat1_fifo0_rd_pd};
assign dat_data = {dat1_data,dat0_data};

//==============
// Input FIFO: CMD
//==============
// cmd-fifo control
// if b_sync, need push into both dat_fifo and cmd_fifo

// FIFO:Write side
//assign cmd_fifo_wr_pvld = dp2wdma_vld & dp2wdma_b_sync & dat_fifo_wr_rdy;
assign cmd_fifo_wr_pvld = dp2wdma_vld & (dp2wdma_b_sync & (dp2wdma_pos_c==3'd3)) & dat_fifo_wr_rdy;
assign cmd_fifo_wr_pd   = dp2wdma_cmd_pd;
// CMD FIFO:Instance
NV_NVDLA_CDP_WDMA_cmd_fifo u_cmd_fifo (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.cmd_fifo_wr_prdy    (cmd_fifo_wr_prdy)        //|> w
  ,.cmd_fifo_wr_pvld    (cmd_fifo_wr_pvld)        //|< w
  ,.cmd_fifo_wr_pd      (cmd_fifo_wr_pd[14:0])    //|< w
  ,.cmd_fifo_rd_prdy    (cmd_fifo_rd_prdy)        //|< w
  ,.cmd_fifo_rd_pvld    (cmd_fifo_rd_pvld)        //|> w
  ,.cmd_fifo_rd_pd      (cmd_fifo_rd_pd[14:0])    //|> w
  ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])     //|< i
  );
// CMD FIFO:Read side
assign cmd_fifo_rd_prdy = cmd_en & cmd_rdy;

// Unpack cmd & data together

// PKT_UNPACK_WIRE( cdp_dp2wdma_cmd , cmd_fifo_rd_ , cmd_fifo_rd_pd )
assign       cmd_fifo_rd_pos_w[3:0] =    cmd_fifo_rd_pd[3:0];
assign       cmd_fifo_rd_width[3:0] =    cmd_fifo_rd_pd[7:4];
assign       cmd_fifo_rd_pos_c[2:0] =    cmd_fifo_rd_pd[10:8];
assign        cmd_fifo_rd_b_sync  =    cmd_fifo_rd_pd[11];
assign        cmd_fifo_rd_last_w  =    cmd_fifo_rd_pd[12];
assign        cmd_fifo_rd_last_h  =    cmd_fifo_rd_pd[13];
assign        cmd_fifo_rd_last_c  =    cmd_fifo_rd_pd[14];
// dat_data | dat_width | dat_channel | dat_b_sync | last_w|last-h|last_c
//assign cmd_fifo_rd_pos_w [3:0] =    cmd_fifo_rd_pd[3:0];
//assign cmd_fifo_rd_width [3:0] =    cmd_fifo_rd_pd[7:4];
//assign cmd_fifo_rd_pos_c [2:0] =    cmd_fifo_rd_pd[10:8];
//assign cmd_fifo_rd_b_sync  =    cmd_fifo_rd_pd[ 11 ];
//assign cmd_fifo_rd_last_w  =    cmd_fifo_rd_pd[ 12 ];
//assign cmd_fifo_rd_last_h  =    cmd_fifo_rd_pd[ 13 ];
//assign cmd_fifo_rd_last_c  =    cmd_fifo_rd_pd[ 14 ];

//Comment by Doris assign cmd_fifo_rd_b_sync_NC = cmd_fifo_rd_b_sync;
assign cmd_fifo_rd_b_sync_NC = cmd_fifo_rd_b_sync;
assign is_last_w = cmd_fifo_rd_last_w;
assign is_last_h = cmd_fifo_rd_last_h;
assign is_last_c = cmd_fifo_rd_last_c;
assign is_cube_last = is_last_w & is_last_h & is_last_c;

//==============
// BLOCK Operation
//==============
assign cmd_vld = cmd_en & cmd_fifo_rd_pvld;
assign cmd_rdy = dma_wr_req_rdy;
assign cmd_accept = cmd_vld & cmd_rdy;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    is_beat_num_odd <= 1'b0;
  end else begin
  if ((cmd_accept) == 1'b1) begin
    is_beat_num_odd <= (cmd_fifo_rd_pos_w[0]==0);
  // VCS coverage off
  end else if ((cmd_accept) == 1'b0) begin
  end else begin
    is_beat_num_odd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cmd_accept))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dat0_vld  = dat_en & dat0_fifo_rd_pvld;
assign dat1_vld  = dat_en & dat1_fifo_rd_pvld & !(is_last_beat & is_beat_num_odd);
assign dat_vld   = dat_en & dat0_vld | dat1_vld;
assign dat_rdy   = dat_en & dma_wr_req_rdy;
assign dat0_rdy  = dat_en & dat_rdy;
assign dat1_rdy  = dat_en & dat_rdy & !(is_last_beat & is_beat_num_odd);
assign dat_accept = dat_vld & dat_rdy;

assign is_last_beat_in_block = is_last_beat;
// beat_cnt and tran_cnt is used to index 8B in each 8(B)x8(w)x4(c) block, (w may be < 8 if is_first_w or is_last_w)
// this is to form one DMA req with maximun 256B data
//         |     beat_cnt
//         |  0 1 2 3 4 5 6 7
// tran_cnt|-----------------
//     0:  |  0 4 0 4 0 4 0 4
//     1:  |  1 5 1 5 1 5 1 5
//     2:  |  2 6 2 6 2 6 2 6
//     3:  |  3 7 3 7 3 7 3 7
// fifo.idx = 4*(beat_cnt%2) + tran_cnt
// Req.cmd
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_en <= 1'b1;
    dat_en <= 1'b0;
  end else begin
    if (is_last_beat_in_block & dat_accept) begin
        cmd_en <= 1'b1;
        dat_en <= 1'b0;
    end else if (cmd_accept) begin
        cmd_en <= 1'b0;
        dat_en <= 1'b1;
    end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg_cube_last <= 1'b0;
  end else begin
  if ((cmd_accept) == 1'b1) begin
    reg_cube_last <= is_cube_last;
  // VCS coverage off
  end else if ((cmd_accept) == 1'b0) begin
  end else begin
    reg_cube_last <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cmd_accept))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    req_chn_size <= {3{1'b0}};
  end else begin
  if ((cmd_accept) == 1'b1) begin
    req_chn_size <= cmd_fifo_rd_pos_c;
  // VCS coverage off
  end else if ((cmd_accept) == 1'b0) begin
  end else begin
    req_chn_size <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cmd_accept))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign width_size = cmd_fifo_rd_pos_w;

// Beat CNT
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    beat_cnt <= {3{1'b0}};
  end else begin
    if (cmd_accept) begin
        beat_cnt <= 0;
    end else if (dat_accept) begin
        beat_cnt <= beat_cnt + 1;
    end
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_fifo_rd_pos_w_reg <= {3{1'b0}};
  end else begin
  if ((cmd_fifo_rd_pvld & cmd_fifo_rd_prdy) == 1'b1) begin
    cmd_fifo_rd_pos_w_reg <= cmd_fifo_rd_pos_w[3:1];
  // VCS coverage off
  end else if ((cmd_fifo_rd_pvld & cmd_fifo_rd_prdy) == 1'b0) begin
  end else begin
    cmd_fifo_rd_pos_w_reg <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cmd_fifo_rd_pvld & cmd_fifo_rd_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//assign is_last_beat  = (beat_cnt==cmd_fifo_rd_pos_w || beat_cnt==cmd_fifo_rd_pos_w-1);
//assign is_last_beat  = (beat_cnt==cmd_fifo_rd_pos_w_reg || beat_cnt==cmd_fifo_rd_pos_w_reg-1);
assign is_last_beat  = (beat_cnt==cmd_fifo_rd_pos_w_reg);
//==============
// DMA REQ: DATA
//==============
//------------------------------------
// mode:  64      ||  mode: 32
// clk : 0 0 1 1  ||  clk : 0 0 1 1
// - - - - - - - -||  - - - - - - - 
// fifo: 0 4 0 4  ||  fifo: 0 4 0 4
// fifo: 1 5 1 5  ||  fifo: 1 5 1 5
// fifo: 2 6 2 6  ||  fifo: 2 6 2 6
// fifo: 3 7 3 7  ||  fifo: 3 7 3 7
// - - - - - - - -||  - - - - - - - 
// bus : L-H L-H  ||  bus : L H-L H
//------------------------------------

//==============
// DMA REQ: ADDR
//==============
// rename for reuse between rdma and wdma
assign reg2dp_base_addr   = reg2dp_dst_base_addr;
assign reg2dp_line_stride = {reg2dp_dst_line_stride,5'd0};
assign reg2dp_surf_stride = {reg2dp_dst_surface_stride,5'd0};
//==============
// DMA Req : ADDR : Prepration
// DMA Req: go through the CUBE: W8->C->H
//==============
// Width: need be updated when move to next line 
// Trigger Condition: (is_last_c & is_last_w)
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    base_addr_w <= {64{1'b0}};
    {mon_base_addr_w_c,base_addr_w} <= {65{1'b0}};
  end else begin
    if (op_load) begin
        base_addr_w <= reg2dp_base_addr;
    end else if (cmd_accept) begin
        if (is_last_c && is_last_w) begin
            {mon_base_addr_w_c,base_addr_w} <= base_addr_w + reg2dp_line_stride;
        end
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
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP_RDMA: no overflow is allowed")      zzz_assert_never_9x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_w_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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

// base_Chn: need be updated when move to next w.group 
// Trigger Condition: (is_last_c)
//  1, jump to next line when is_last_w
//  2, jump to next w.group when !is_last_w
assign width_size_use[3:0] = width_size + 1;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    base_addr_c <= {64{1'b0}};
    {mon_base_addr_c_c,base_addr_c} <= {65{1'b0}};
  end else begin
    if (op_load) begin
        base_addr_c <= reg2dp_base_addr;
    end else if (cmd_accept) begin
        if (is_last_c) begin
            if (is_last_w) begin
                {mon_base_addr_c_c,base_addr_c} <= base_addr_w + reg2dp_line_stride;
            end else begin
                //{mon_base_addr_c_c,base_addr_c} <0= base_addr_c + {width_size + 1,5'd0};
                {mon_base_addr_c_c,base_addr_c} <= base_addr_c + {width_size_use,5'd0};
            end
        end
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
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP_RDMA: no overflow is allowed")      zzz_assert_never_10x (nvdla_core_clk, `ASSERT_RESET, mon_base_addr_c_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// DMA Req : ADDR : Generation
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dma_req_addr <= {64{1'b0}};
    {mon_dma_req_addr_c,dma_req_addr} <= {65{1'b0}};
  end else begin
    if (op_load) begin
        dma_req_addr <= reg2dp_base_addr;
    end else if (cmd_accept) begin
        if (is_last_c) begin
            if (is_last_w) begin
                {mon_dma_req_addr_c,dma_req_addr} <= base_addr_w + reg2dp_line_stride;
            end else begin
                //{mon_dma_req_addr_c,dma_req_addr} <0= base_addr_c + width_size + 1;
                {mon_dma_req_addr_c,dma_req_addr} <= base_addr_c + {width_size_use,5'd0};
            end
        end else begin
            {mon_dma_req_addr_c,dma_req_addr} <= dma_req_addr + reg2dp_surf_stride;
        end
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
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP_RDMA: no overflow is allowed")      zzz_assert_never_11x (nvdla_core_clk, `ASSERT_RESET, mon_dma_req_addr_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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
////==============
//// DMA Req : ADDR : Prepration
//// DMA Req: go through the CUBE: W8->C->H
////==============
//// Width: need be updated when move to next line 
//// Trigger Condition: (is_last_c & is_last_w)
//&Always posedge;
//    if (op_load) begin
//        base_addr_w <0= reg2dp_base_addr;
//    end else if (cmd_accept) begin
//        if (is_last_c && is_last_w) begin
//            {mon_base_addr_w_c,base_addr_w} <0= base_addr_w + reg2dp_line_stride;
//        end
//    end
//&End;
//
//// base_Chn: need be updated when move to next w.group 
//// Trigger Condition: (is_last_c)
////  1, jump to next line when is_last_w
////  2, jump to next w.group when !is_last_w
//assign width_size_use = width_size + 1;
//&Always posedge;
//    if (op_load) begin
//        base_addr_c <0= reg2dp_base_addr;
//    end else if (cmd_accept) begin
//        if (is_last_c) begin
//            if (is_last_w) begin
//                {mon_base_addr_c_c,base_addr_c} <0= base_addr_w + reg2dp_line_stride;
//            end else begin
//                //{mon_base_addr_c_c,base_addr_c} <0= base_addr_c + {width_size + 1,5'd0};
//                {mon_base_addr_c_c,base_addr_c} <0= base_addr_c + {width_size_use,5'd0};
//            end
//        end
//    end
//&End;
//
////==============
//// DMA Req : ADDR : Generation
////==============
//&Always posedge;
//    if (op_load) begin
//        dma_req_addr <0= reg2dp_base_addr;
//    end else if (cmd_accept) begin
//        if (is_last_c) begin
//            if (is_last_w) begin
//                {mon_dma_req_addr_c,dma_req_addr} <0= base_addr_w + reg2dp_line_stride;
//            end else begin
//                //{mon_dma_req_addr_c,dma_req_addr} <0= base_addr_c + width_size + 1;
//                {mon_dma_req_addr_c,dma_req_addr} <0= base_addr_c + {width_size_use,5'd0};
//            end
//        end else begin
//            {mon_dma_req_addr_c,dma_req_addr} <0= dma_req_addr + reg2dp_surf_stride;
//        end
//    end
//&End;
//==============
// DMA REQ: Size
//==============
// packet: cmd
assign dma_wr_cmd_vld  = cmd_vld;
assign dma_wr_cmd_addr = dma_req_addr;
assign dma_wr_cmd_size = {{9{1'b0}}, cmd_fifo_rd_pos_w};
assign dma_wr_cmd_require_ack   = is_cube_last;

// PKT_PACK_WIRE( dma_write_cmd ,  dma_wr_cmd_ ,  dma_wr_cmd_pd )
assign       dma_wr_cmd_pd[63:0] =     dma_wr_cmd_addr[63:0];
assign       dma_wr_cmd_pd[76:64] =     dma_wr_cmd_size[12:0];
assign       dma_wr_cmd_pd[77] =     dma_wr_cmd_require_ack ;
// packet: data
assign dma_wr_dat_vld  = dat_vld;
assign dma_wr_dat_data = dat_data;
assign dma_wr_dat_mask = (is_beat_num_odd && is_last_beat) ? 2'b01 : 2'b11;

// PKT_PACK_WIRE( dma_write_data ,  dma_wr_dat_ ,  dma_wr_dat_pd )
assign       dma_wr_dat_pd[511:0] =     dma_wr_dat_data[511:0];
assign       dma_wr_dat_pd[513:512] =     dma_wr_dat_mask[1:0];

//==============
// output NaN counter
//==============
//Modify for timing issue in partition with phycical constrain
//assign fp16_en = (reg2dp_input_data_type[1:0]==NVDLA_CDP_D_DATA_FORMAT_0_INPUT_DATA_TYPE_FP16);
assign fp16_en_f = (reg2dp_input_data_type[1:0]== 2'h2 );
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    fp16_en <= 1'b0;
  end else begin
  fp16_en <= fp16_en_f;
  end
end
assign dat0_is_nan_0[0] = fp16_en & (&dat0_fifo0_rd_pd[14:10]) & (|dat0_fifo0_rd_pd[9:0]);
assign dat0_is_nan_0[1] = fp16_en & (&dat0_fifo0_rd_pd[30:26]) & (|dat0_fifo0_rd_pd[25:16]);
assign dat0_is_nan_0[2] = fp16_en & (&dat0_fifo0_rd_pd[46:42]) & (|dat0_fifo0_rd_pd[41:32]);
assign dat0_is_nan_0[3] = fp16_en & (&dat0_fifo0_rd_pd[62:58]) & (|dat0_fifo0_rd_pd[57:48]);
assign dat1_is_nan_0[0] = fp16_en & (&dat1_fifo0_rd_pd[14:10]) & (|dat1_fifo0_rd_pd[9:0]);
assign dat1_is_nan_0[1] = fp16_en & (&dat1_fifo0_rd_pd[30:26]) & (|dat1_fifo0_rd_pd[25:16]);
assign dat1_is_nan_0[2] = fp16_en & (&dat1_fifo0_rd_pd[46:42]) & (|dat1_fifo0_rd_pd[41:32]);
assign dat1_is_nan_0[3] = fp16_en & (&dat1_fifo0_rd_pd[62:58]) & (|dat1_fifo0_rd_pd[57:48]);
assign dat0_is_nan_1[0] = fp16_en & (&dat0_fifo1_rd_pd[14:10]) & (|dat0_fifo1_rd_pd[9:0]);
assign dat0_is_nan_1[1] = fp16_en & (&dat0_fifo1_rd_pd[30:26]) & (|dat0_fifo1_rd_pd[25:16]);
assign dat0_is_nan_1[2] = fp16_en & (&dat0_fifo1_rd_pd[46:42]) & (|dat0_fifo1_rd_pd[41:32]);
assign dat0_is_nan_1[3] = fp16_en & (&dat0_fifo1_rd_pd[62:58]) & (|dat0_fifo1_rd_pd[57:48]);
assign dat1_is_nan_1[0] = fp16_en & (&dat1_fifo1_rd_pd[14:10]) & (|dat1_fifo1_rd_pd[9:0]);
assign dat1_is_nan_1[1] = fp16_en & (&dat1_fifo1_rd_pd[30:26]) & (|dat1_fifo1_rd_pd[25:16]);
assign dat1_is_nan_1[2] = fp16_en & (&dat1_fifo1_rd_pd[46:42]) & (|dat1_fifo1_rd_pd[41:32]);
assign dat1_is_nan_1[3] = fp16_en & (&dat1_fifo1_rd_pd[62:58]) & (|dat1_fifo1_rd_pd[57:48]);
assign dat0_is_nan_2[0] = fp16_en & (&dat0_fifo2_rd_pd[14:10]) & (|dat0_fifo2_rd_pd[9:0]);
assign dat0_is_nan_2[1] = fp16_en & (&dat0_fifo2_rd_pd[30:26]) & (|dat0_fifo2_rd_pd[25:16]);
assign dat0_is_nan_2[2] = fp16_en & (&dat0_fifo2_rd_pd[46:42]) & (|dat0_fifo2_rd_pd[41:32]);
assign dat0_is_nan_2[3] = fp16_en & (&dat0_fifo2_rd_pd[62:58]) & (|dat0_fifo2_rd_pd[57:48]);
assign dat1_is_nan_2[0] = fp16_en & (&dat1_fifo2_rd_pd[14:10]) & (|dat1_fifo2_rd_pd[9:0]);
assign dat1_is_nan_2[1] = fp16_en & (&dat1_fifo2_rd_pd[30:26]) & (|dat1_fifo2_rd_pd[25:16]);
assign dat1_is_nan_2[2] = fp16_en & (&dat1_fifo2_rd_pd[46:42]) & (|dat1_fifo2_rd_pd[41:32]);
assign dat1_is_nan_2[3] = fp16_en & (&dat1_fifo2_rd_pd[62:58]) & (|dat1_fifo2_rd_pd[57:48]);
assign dat0_is_nan_3[0] = fp16_en & (&dat0_fifo3_rd_pd[14:10]) & (|dat0_fifo3_rd_pd[9:0]);
assign dat0_is_nan_3[1] = fp16_en & (&dat0_fifo3_rd_pd[30:26]) & (|dat0_fifo3_rd_pd[25:16]);
assign dat0_is_nan_3[2] = fp16_en & (&dat0_fifo3_rd_pd[46:42]) & (|dat0_fifo3_rd_pd[41:32]);
assign dat0_is_nan_3[3] = fp16_en & (&dat0_fifo3_rd_pd[62:58]) & (|dat0_fifo3_rd_pd[57:48]);
assign dat1_is_nan_3[0] = fp16_en & (&dat1_fifo3_rd_pd[14:10]) & (|dat1_fifo3_rd_pd[9:0]);
assign dat1_is_nan_3[1] = fp16_en & (&dat1_fifo3_rd_pd[30:26]) & (|dat1_fifo3_rd_pd[25:16]);
assign dat1_is_nan_3[2] = fp16_en & (&dat1_fifo3_rd_pd[46:42]) & (|dat1_fifo3_rd_pd[41:32]);
assign dat1_is_nan_3[3] = fp16_en & (&dat1_fifo3_rd_pd[62:58]) & (|dat1_fifo3_rd_pd[57:48]);

assign nan_num_in_x[31:0] = {dat1_is_nan_3,dat1_is_nan_2,dat1_is_nan_1,dat1_is_nan_0,dat0_is_nan_3,dat0_is_nan_2,dat0_is_nan_1,dat0_is_nan_0};

//&Shell $VFUNCTIONS -n fun_bit_sum fun_bit_sum_32 32;
function [5:0] fun_bit_sum_32;
  input [31:0] idata;
  reg [5:0] ocnt;
  begin
    ocnt =
        (((( idata[0]  
      +  idata[1]  
      +  idata[2] ) 
      + ( idata[3]  
      +  idata[4]  
      +  idata[5] )) 
      + (( idata[6]  
      +  idata[7]  
      +  idata[8] ) 
      + ( idata[9]  
      +  idata[10]  
      +  idata[11] ))) 
      + ((( idata[12]  
      +  idata[13]  
      +  idata[14] ) 
      + ( idata[15]  
      +  idata[16]  
      +  idata[17] )) 
      + (( idata[18]  
      +  idata[19]  
      +  idata[20] ) 
      + ( idata[21]  
      +  idata[22]  
      +  idata[23] )))) 
      + (( idata[24]  
      +  idata[25]  
      +  idata[26] ) 
      + ( idata[27]  
      +  idata[28]  
      +  idata[29] )) 
      + ( idata[30]  
      +  idata[31] ) ;
    fun_bit_sum_32 = ocnt;
  end
endfunction

assign nan_num_in_64B = fun_bit_sum_32(nan_num_in_x);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    {mon_nan_in_count,nan_in_count[31:0]} <= {33{1'b0}};
  end else begin
    if(dat_accept) begin
        if(op_done)
            {mon_nan_in_count,nan_in_count[31:0]} <= 33'd0;
        else
            {mon_nan_in_count,nan_in_count[31:0]} <= nan_in_count + nan_num_in_64B;
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
  // VCS coverage off 
  nv_assert_never #(0,0,"CDP WDMA: nan counter no overflow is allowed")      zzz_assert_never_12x (nvdla_core_clk, `ASSERT_RESET, mon_nan_in_count); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_nan_output_num <= {32{1'b0}};
  end else begin
    if(op_done)
            dp2reg_nan_output_num <= nan_in_count;
  end
end
//============================

// pack cmd & dat
assign dma_wr_req_vld = dma_wr_cmd_vld | dma_wr_dat_vld;
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
// writting stall counter before DMA_if
//==============
assign cnt_inc = 1'b1;
assign cnt_clr = op_done;
assign cnt_cen = (reg2dp_dma_en == 1'h1 ) & (dma_wr_req_vld & (~dma_wr_req_rdy));



    assign cdp_wr_stall_count_dec = 1'b0;

    // stl adv logic

    always @(
      cnt_inc
      or cdp_wr_stall_count_dec
      ) begin
      stl_adv = cnt_inc ^ cdp_wr_stall_count_dec;
    end
        
    // stl cnt logic
    always @(
      stl_cnt_cur
      or cnt_inc
      or cdp_wr_stall_count_dec
      or stl_adv
      or cnt_clr
      ) begin
      // VCS sop_coverage_off start
      stl_cnt_ext[33:0] = {1'b0, 1'b0, stl_cnt_cur};
      stl_cnt_inc[33:0] = stl_cnt_cur + 1'b1; // spyglass disable W164b
      stl_cnt_dec[33:0] = stl_cnt_cur - 1'b1; // spyglass disable W164b
      stl_cnt_mod[33:0] = (cnt_inc && !cdp_wr_stall_count_dec)? stl_cnt_inc : (!cnt_inc && cdp_wr_stall_count_dec)? stl_cnt_dec : stl_cnt_ext;
      stl_cnt_new[33:0] = (stl_adv)? stl_cnt_mod[33:0] : stl_cnt_ext[33:0];
      stl_cnt_nxt[33:0] = (cnt_clr)? 34'd0 : stl_cnt_new[33:0];
      // VCS sop_coverage_off end
    end

    // stl flops

    always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
      if (!nvdla_core_rstn) begin
        stl_cnt_cur[31:0] <= 0;
      end else begin
      if (cnt_cen) begin
      stl_cnt_cur[31:0] <= stl_cnt_nxt[31:0];
      end
      end
    end

    // stl output logic

    always @(
      stl_cnt_cur
      ) begin
      cdp_wr_stall_count[31:0] = stl_cnt_cur[31:0];
    end
        
      

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    layer_flag <= 1'b0;
  end else begin
  if ((cnt_clr) == 1'b1) begin
    layer_flag <= ~layer_flag;
  // VCS coverage off
  end else if ((cnt_clr) == 1'b0) begin
  end else begin
    layer_flag <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cnt_clr))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dp2reg_d0_perf_write_stall <= {32{1'b0}};
  end else begin
  if ((cnt_clr & (~layer_flag)) == 1'b1) begin
    dp2reg_d0_perf_write_stall <= cdp_wr_stall_count[31:0];
  // VCS coverage off
  end else if ((cnt_clr & (~layer_flag)) == 1'b0) begin
  end else begin
    dp2reg_d0_perf_write_stall <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cnt_clr & (~layer_flag)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dp2reg_d1_perf_write_stall <= {32{1'b0}};
  end else begin
  if ((cnt_clr &   layer_flag ) == 1'b1) begin
    dp2reg_d1_perf_write_stall <= cdp_wr_stall_count[31:0];
  // VCS coverage off
  end else if ((cnt_clr &   layer_flag ) == 1'b0) begin
  end else begin
    dp2reg_d1_perf_write_stall <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cnt_clr &   layer_flag ))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//==============
// DMA Interface
//==============
assign dma_wr_req_type = reg2dp_dst_ram_type;
// wr Channel: Request 
assign cv_dma_wr_req_vld = dma_wr_req_vld & (dma_wr_req_type == 1'b0);
assign mc_dma_wr_req_vld = dma_wr_req_vld & (dma_wr_req_type == 1'b1);
assign cv_wr_req_rdyi = cv_dma_wr_req_rdy & (dma_wr_req_type == 1'b0);
assign mc_wr_req_rdyi = mc_dma_wr_req_rdy & (dma_wr_req_type == 1'b1);
assign wr_req_rdyi = mc_wr_req_rdyi | cv_wr_req_rdyi;
assign dma_wr_req_rdy= wr_req_rdyi;
NV_NVDLA_CDP_WDMA_pipe_p2 pipe_p2 (
   .nvdla_core_clk_orig (nvdla_core_clk_orig)     //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.dma_wr_req_pd       (dma_wr_req_pd[514:0])    //|< r
  ,.mc_dma_wr_req_vld   (mc_dma_wr_req_vld)       //|< w
  ,.mc_int_wr_req_ready (mc_int_wr_req_ready)     //|< w
  ,.mc_dma_wr_req_rdy   (mc_dma_wr_req_rdy)       //|> w
  ,.mc_int_wr_req_pd    (mc_int_wr_req_pd[514:0]) //|> w
  ,.mc_int_wr_req_valid (mc_int_wr_req_valid)     //|> w
  );
NV_NVDLA_CDP_WDMA_pipe_p3 pipe_p3 (
   .nvdla_core_clk_orig (nvdla_core_clk_orig)     //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.cv_dma_wr_req_vld   (cv_dma_wr_req_vld)       //|< w
  ,.cv_int_wr_req_ready (cv_int_wr_req_ready)     //|< w
  ,.dma_wr_req_pd       (dma_wr_req_pd[514:0])    //|< r
  ,.cv_dma_wr_req_rdy   (cv_dma_wr_req_rdy)       //|> w
  ,.cv_int_wr_req_pd    (cv_int_wr_req_pd[514:0]) //|> w
  ,.cv_int_wr_req_valid (cv_int_wr_req_valid)     //|> w
  );

assign mc_int_wr_req_valid_d0 = mc_int_wr_req_valid;
assign mc_int_wr_req_ready = mc_int_wr_req_ready_d0;
assign mc_int_wr_req_pd_d0[514:0] = mc_int_wr_req_pd[514:0];
assign cdp2mcif_wr_req_valid = mc_int_wr_req_valid_d0;
assign mc_int_wr_req_ready_d0 = cdp2mcif_wr_req_ready;
assign cdp2mcif_wr_req_pd[514:0] = mc_int_wr_req_pd_d0[514:0];


assign cv_int_wr_req_valid_d0 = cv_int_wr_req_valid;
assign cv_int_wr_req_ready = cv_int_wr_req_ready_d0;
assign cv_int_wr_req_pd_d0[514:0] = cv_int_wr_req_pd[514:0];
assign cdp2cvif_wr_req_valid = cv_int_wr_req_valid_d0;
assign cv_int_wr_req_ready_d0 = cdp2cvif_wr_req_ready;
assign cdp2cvif_wr_req_pd[514:0] = cv_int_wr_req_pd_d0[514:0];

// wr Channel: Response

assign mc_int_wr_rsp_complete = mcif2cdp_wr_rsp_complete;


assign cv_int_wr_rsp_complete = cvif2cdp_wr_rsp_complete;

assign require_ack = (dma_wr_req_pd[514:514]==0) & (dma_wr_req_pd[77:77]==1);
assign ack_raw_vld = dma_wr_req_vld & wr_req_rdyi & require_ack;
assign ack_raw_id  = dma_wr_req_type;
// stage1: bot
assign ack_raw_rdy = ack_bot_rdy || !ack_bot_vld;
always @(posedge nvdla_core_clk_orig) begin
  if ((ack_raw_vld & ack_raw_rdy) == 1'b1) begin
    ack_bot_id <= ack_raw_id;
  // VCS coverage off
  end else if ((ack_raw_vld & ack_raw_rdy) == 1'b0) begin
  end else begin
    ack_bot_id <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ack_bot_vld <= 1'b0;
  end else begin
  if ((ack_raw_rdy) == 1'b1) begin
    ack_bot_vld <= ack_raw_vld;
  // VCS coverage off
  end else if ((ack_raw_rdy) == 1'b0) begin
  end else begin
    ack_bot_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_core_clk_orig, `ASSERT_RESET, 1'd1,  (^(ack_raw_rdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"dmaif bot never push back")      zzz_assert_never_17x (nvdla_core_clk_orig, `ASSERT_RESET, ack_raw_vld & !ack_raw_rdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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
// stage2: top
assign ack_bot_rdy = ack_top_rdy || !ack_top_vld;
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ack_top_id <= 1'b0;
  end else begin
  if ((ack_bot_vld & ack_bot_rdy) == 1'b1) begin
    ack_top_id <= ack_bot_id;
  // VCS coverage off
  end else if ((ack_bot_vld & ack_bot_rdy) == 1'b0) begin
  end else begin
    ack_top_id <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk_orig, `ASSERT_RESET, 1'd1,  (^(ack_bot_vld & ack_bot_rdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ack_top_vld <= 1'b0;
  end else begin
  if ((ack_bot_rdy) == 1'b1) begin
    ack_top_vld <= ack_bot_vld;
  // VCS coverage off
  end else if ((ack_bot_rdy) == 1'b0) begin
  end else begin
    ack_top_vld <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk_orig, `ASSERT_RESET, 1'd1,  (^(ack_bot_rdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign ack_top_rdy = releasing;
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mc_dma_wr_rsp_complete <= 1'b0;
  end else begin
  mc_dma_wr_rsp_complete <= mc_int_wr_rsp_complete;
  end
end
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cv_dma_wr_rsp_complete <= 1'b0;
  end else begin
  cv_dma_wr_rsp_complete <= cv_int_wr_rsp_complete;
  end
end
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dma_wr_rsp_complete <= 1'b0;
  end else begin
  dma_wr_rsp_complete <= releasing;
  end
end
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mc_pending <= 1'b0;
  end else begin
   if (ack_top_id==0) begin
       if (mc_dma_wr_rsp_complete) begin
           mc_pending <= 1'b1;
       end
   end else if (ack_top_id==1) begin
       if (mc_pending) begin
           mc_pending <= 1'b0;
       end
   end
  end
end
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cv_pending <= 1'b0;
  end else begin
   if (ack_top_id==1) begin
       if (cv_dma_wr_rsp_complete) begin
           cv_pending <= 1'b1;
       end
   end else if (ack_top_id==0) begin
       if (cv_pending) begin
           cv_pending <= 1'b0;
       end
   end
  end
end
assign mc_releasing = ack_top_id==1'b1 & (mc_dma_wr_rsp_complete | mc_pending);
assign cv_releasing = ack_top_id==1'b0 & (cv_dma_wr_rsp_complete | cv_pending);
assign releasing = mc_releasing | cv_releasing;
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
  nv_assert_never #(0,0,"no release both together")      zzz_assert_never_20x (nvdla_core_clk_orig, `ASSERT_RESET, mc_releasing & cv_releasing); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"no mc resp back and pending together")      zzz_assert_never_21x (nvdla_core_clk_orig, `ASSERT_RESET, mc_pending & mc_dma_wr_rsp_complete); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"no cv resp back and pending together")      zzz_assert_never_22x (nvdla_core_clk_orig, `ASSERT_RESET, cv_pending & cv_dma_wr_rsp_complete); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"no ack_top_vld when resp from cv")      zzz_assert_never_23x (nvdla_core_clk_orig, `ASSERT_RESET, (cv_pending | cv_dma_wr_rsp_complete) & !ack_top_vld); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"no ack_top_vld when resp from mc")      zzz_assert_never_24x (nvdla_core_clk_orig, `ASSERT_RESET, (mc_pending | mc_dma_wr_rsp_complete) & !ack_top_vld); // spyglass disable W504 SelfDeterminedExpr-ML 
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

    property dmaif_cdp__two_completes__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk_orig)
        mc_dma_wr_rsp_complete & cv_dma_wr_rsp_complete;
    endproperty
    // Cover 0 : "mc_dma_wr_rsp_complete & cv_dma_wr_rsp_complete"
    FUNCPOINT_dmaif_cdp__two_completes__0_COV : cover property (dmaif_cdp__two_completes__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property dmaif_cdp__one_pending_complete_with_mc__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk_orig)
        cv_pending & mc_dma_wr_rsp_complete;
    endproperty
    // Cover 1 : "cv_pending & mc_dma_wr_rsp_complete"
    FUNCPOINT_dmaif_cdp__one_pending_complete_with_mc__1_COV : cover property (dmaif_cdp__one_pending_complete_with_mc__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property dmaif_cdp__one_pending_complete_with_cv__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk_orig)
        mc_pending & cv_dma_wr_rsp_complete;
    endproperty
    // Cover 2 : "mc_pending & cv_dma_wr_rsp_complete"
    FUNCPOINT_dmaif_cdp__one_pending_complete_with_cv__2_COV : cover property (dmaif_cdp__one_pending_complete_with_cv__2_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property dmaif_cdp__sequence_complete_cv_one_cycle_after_mc_in_order__3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk_orig)
        cv_int_wr_rsp_complete & mc_dma_wr_rsp_complete & ack_top_id==1'b1;
    endproperty
    // Cover 3 : "cv_int_wr_rsp_complete & mc_dma_wr_rsp_complete & ack_top_id==1'b1"
    FUNCPOINT_dmaif_cdp__sequence_complete_cv_one_cycle_after_mc_in_order__3_COV : cover property (dmaif_cdp__sequence_complete_cv_one_cycle_after_mc_in_order__3_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property dmaif_cdp__sequence_complete_cv_one_cycle_after_mc_out_of_order__4_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk_orig)
        cv_int_wr_rsp_complete & mc_dma_wr_rsp_complete & ack_top_id==1'b0;
    endproperty
    // Cover 4 : "cv_int_wr_rsp_complete & mc_dma_wr_rsp_complete & ack_top_id==1'b0"
    FUNCPOINT_dmaif_cdp__sequence_complete_cv_one_cycle_after_mc_out_of_order__4_COV : cover property (dmaif_cdp__sequence_complete_cv_one_cycle_after_mc_out_of_order__4_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property dmaif_cdp__sequence_complete_mc_one_cycle_after_cv_in_order__5_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk_orig)
        mc_int_wr_rsp_complete & cv_dma_wr_rsp_complete & ack_top_id==1'b0;
    endproperty
    // Cover 5 : "mc_int_wr_rsp_complete & cv_dma_wr_rsp_complete & ack_top_id==1'b0"
    FUNCPOINT_dmaif_cdp__sequence_complete_mc_one_cycle_after_cv_in_order__5_COV : cover property (dmaif_cdp__sequence_complete_mc_one_cycle_after_cv_in_order__5_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property dmaif_cdp__sequence_complete_mc_one_cycle_after_cv_out_of_order__6_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk_orig)
        mc_int_wr_rsp_complete & cv_dma_wr_rsp_complete & ack_top_id==1'b1;
    endproperty
    // Cover 6 : "mc_int_wr_rsp_complete & cv_dma_wr_rsp_complete & ack_top_id==1'b1"
    FUNCPOINT_dmaif_cdp__sequence_complete_mc_one_cycle_after_cv_out_of_order__6_COV : cover property (dmaif_cdp__sequence_complete_mc_one_cycle_after_cv_out_of_order__6_cov);

  `endif
`endif
//VCS coverage on



//assign cdp2glb_intr_pd[0] = dma_wr_rsp_complete;
//assign cdp2glb_intr_pd[1] = dma_wr_rsp_complete;

NV_NVDLA_CDP_WDMA_intr_fifo u_intr_fifo (
   .nvdla_core_clk      (nvdla_core_clk_orig)     //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.intr_fifo_wr_pvld   (intr_fifo_wr_pvld)       //|< w
  ,.intr_fifo_wr_pd     (intr_fifo_wr_pd)         //|< w
  ,.intr_fifo_rd_prdy   (intr_fifo_rd_prdy)       //|< w
  ,.intr_fifo_rd_pvld   (intr_fifo_rd_pvld)       //|> w
  ,.intr_fifo_rd_pd     (intr_fifo_rd_pd)         //|> w
  ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])     //|< i
  );
assign intr_fifo_wr_pd    = reg2dp_interrupt_ptr;
assign intr_fifo_wr_pvld  = op_done;
assign intr_fifo_rd_prdy  = dma_wr_rsp_complete;
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cdp2glb_done_intr_pd[0] <= 1'b0;
  end else begin
  cdp2glb_done_intr_pd[0] <= intr_fifo_rd_pvld & intr_fifo_rd_prdy & (intr_fifo_rd_pd==0);
  end
end
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cdp2glb_done_intr_pd[1] <= 1'b0;
  end else begin
  cdp2glb_done_intr_pd[1] <= intr_fifo_rd_pvld & intr_fifo_rd_prdy & (intr_fifo_rd_pd==1);
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
  // VCS coverage off 
  nv_assert_never #(0,0,"when write complete, intr_ptr should be already in the head of intr_fifo read side")      zzz_assert_never_25x (nvdla_core_clk_orig, `ASSERT_RESET, !intr_fifo_rd_pvld & dma_wr_rsp_complete); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////==============
////OBS signals
////==============
//assign obs_bus_cdp_wdma_proc_en   = op_prcess;
//assign obs_bus_cdp_wdma_wr_00_vld = dat0_fifo0_wr_pvld; 
//assign obs_bus_cdp_wdma_wr_10_vld = dat1_fifo0_wr_pvld;
//assign obs_bus_cdp_wdma_rd_0x_rdy = dat0_rdy;
//assign obs_bus_cdp_wdma_rd_1x_rdy = dat1_rdy;

//==============
//function polint
//==============
//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property CDP_WDMA__dma_writing_stall__7_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        dma_wr_req_vld & (~dma_wr_req_rdy);
    endproperty
    // Cover 7 : "dma_wr_req_vld & (~dma_wr_req_rdy)"
    FUNCPOINT_CDP_WDMA__dma_writing_stall__7_COV : cover property (CDP_WDMA__dma_writing_stall__7_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property CDP_WDMA__dp2wdma_stall__8_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        cdp_dp2wdma_valid & (~cdp_dp2wdma_ready);
    endproperty
    // Cover 8 : "cdp_dp2wdma_valid & (~cdp_dp2wdma_ready)"
    FUNCPOINT_CDP_WDMA__dp2wdma_stall__8_COV : cover property (CDP_WDMA__dp2wdma_stall__8_cov);

  `endif
`endif
//VCS coverage on


////two continuous layers
//assign mon_op_en_pos = reg2dp_op_en & (~mon_op_en_dly);
//assign mon_op_en_neg = (~reg2dp_op_en) & mon_op_en_dly;
//&Always posedge;
//    if(mon_op_en_neg)
//        mon_layer_end_flg <0= 1'b1;
//    else if(mon_op_en_pos)
//        mon_layer_end_flg <0= 1'b0;
//&End;
//&Always posedge;
//    if(mon_layer_end_flg)
//        mon_gap_between_layers[31:0] <0= mon_gap_between_layers + 1'b1;
//    else
//        mon_gap_between_layers[31:0] <0= 32'd0;
//&End;
//


endmodule // NV_NVDLA_CDP_wdma



// **************************************************************************************************************
// Generated by ::pipe -m -bc -is mc_int_wr_req_pd (mc_int_wr_req_valid,mc_int_wr_req_ready) <= dma_wr_req_pd[514:0] (mc_dma_wr_req_vld,mc_dma_wr_req_rdy)
// **************************************************************************************************************
module NV_NVDLA_CDP_WDMA_pipe_p2 (
   nvdla_core_clk_orig
  ,nvdla_core_rstn
  ,dma_wr_req_pd
  ,mc_dma_wr_req_vld
  ,mc_int_wr_req_ready
  ,mc_dma_wr_req_rdy
  ,mc_int_wr_req_pd
  ,mc_int_wr_req_valid
  );
input          nvdla_core_clk_orig;
input          nvdla_core_rstn;
input  [514:0] dma_wr_req_pd;
input          mc_dma_wr_req_vld;
input          mc_int_wr_req_ready;
output         mc_dma_wr_req_rdy;
output [514:0] mc_int_wr_req_pd;
output         mc_int_wr_req_valid;
reg            mc_dma_wr_req_rdy;
reg    [514:0] mc_int_wr_req_pd;
reg            mc_int_wr_req_valid;
reg    [514:0] p2_pipe_data;
reg    [514:0] p2_pipe_rand_data;
reg            p2_pipe_rand_ready;
reg            p2_pipe_rand_valid;
reg            p2_pipe_ready;
reg            p2_pipe_ready_bc;
reg            p2_pipe_valid;
reg            p2_skid_catch;
reg    [514:0] p2_skid_data;
reg    [514:0] p2_skid_pipe_data;
reg            p2_skid_pipe_ready;
reg            p2_skid_pipe_valid;
reg            p2_skid_ready;
reg            p2_skid_ready_flop;
reg            p2_skid_valid;
//## pipe (2) randomizer
`ifndef SYNTHESIS
reg p2_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p2_pipe_rand_active
  or 
     `endif
     mc_dma_wr_req_vld
  or p2_pipe_rand_ready
  or dma_wr_req_pd
  ) begin
  `ifdef SYNTHESIS
  p2_pipe_rand_valid = mc_dma_wr_req_vld;
  mc_dma_wr_req_rdy = p2_pipe_rand_ready;
  p2_pipe_rand_data = dma_wr_req_pd[514:0];
  `else
  // VCS coverage off
  p2_pipe_rand_valid = (p2_pipe_rand_active)? 1'b0 : mc_dma_wr_req_vld;
  mc_dma_wr_req_rdy = (p2_pipe_rand_active)? 1'b0 : p2_pipe_rand_ready;
  p2_pipe_rand_data = (p2_pipe_rand_active)?  'bx : dma_wr_req_pd[514:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p2_pipe_stall_cycles;
integer p2_pipe_stall_probability;
integer p2_pipe_stall_cycles_min;
integer p2_pipe_stall_cycles_max;
initial begin
  p2_pipe_stall_cycles = 0;
  p2_pipe_stall_probability = 0;
  p2_pipe_stall_cycles_min = 1;
  p2_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_CDP_wdma_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDP_wdma_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDP_wdma_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDP_wdma_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDP_wdma_pipe_stall_probability" ) ) p2_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDP_wdma_pipe_stall_cycles_min"  ) ) p2_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDP_wdma_pipe_stall_cycles_max"  ) ) p2_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p2_pipe_rand_enable;
reg p2_pipe_rand_poised;
always @(
  p2_pipe_stall_cycles
  or p2_pipe_stall_probability
  or mc_dma_wr_req_vld
  ) begin
  p2_pipe_rand_active = p2_pipe_stall_cycles != 0;
  p2_pipe_rand_enable = p2_pipe_stall_probability != 0;
  p2_pipe_rand_poised = p2_pipe_rand_enable && !p2_pipe_rand_active && mc_dma_wr_req_vld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p2_pipe_rand_poised) begin
    if (p2_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p2_pipe_stall_cycles <= prand_inst1(p2_pipe_stall_cycles_min, p2_pipe_stall_cycles_max);
    end
  end else if (p2_pipe_rand_active) begin
    p2_pipe_stall_cycles <= p2_pipe_stall_cycles - 1;
  end else begin
    p2_pipe_stall_cycles <= 0;
  end
  end
end

`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
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
            // magic numbers taken from Java's random class (same as lrand48)
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
// Only verilog needs any local variables
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
            // magic numbers taken from Java's random class (same as lrand48)
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

`endif
// VCS coverage on
//## pipe (2) skid buffer
always @(
  p2_pipe_rand_valid
  or p2_skid_ready_flop
  or p2_skid_pipe_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = p2_pipe_rand_valid && p2_skid_ready_flop && !p2_skid_pipe_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_skid_pipe_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    p2_pipe_rand_ready <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_skid_pipe_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  p2_pipe_rand_ready <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk_orig) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? p2_pipe_rand_data : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or p2_pipe_rand_valid
  or p2_skid_valid
  or p2_pipe_rand_data
  or p2_skid_data
  ) begin
  p2_skid_pipe_valid = (p2_skid_ready_flop)? p2_pipe_rand_valid : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_skid_pipe_data = (p2_skid_ready_flop)? p2_pipe_rand_data : p2_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (2) valid-ready-bubble-collapse
always @(
  p2_pipe_ready
  or p2_pipe_valid
  ) begin
  p2_pipe_ready_bc = p2_pipe_ready || !p2_pipe_valid;
end
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_valid <= 1'b0;
  end else begin
  p2_pipe_valid <= (p2_pipe_ready_bc)? p2_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk_orig) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && p2_skid_pipe_valid)? p2_skid_pipe_data : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  p2_skid_pipe_ready = p2_pipe_ready_bc;
end
//## pipe (2) output
always @(
  p2_pipe_valid
  or mc_int_wr_req_ready
  or p2_pipe_data
  ) begin
  mc_int_wr_req_valid = p2_pipe_valid;
  p2_pipe_ready = mc_int_wr_req_ready;
  mc_int_wr_req_pd = p2_pipe_data;
end
//## pipe (2) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p2_assert_clk = nvdla_core_clk_orig;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_26x (nvdla_core_clk_orig, `ASSERT_RESET, nvdla_core_rstn, (mc_int_wr_req_valid^mc_int_wr_req_ready^mc_dma_wr_req_vld^mc_dma_wr_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_27x (nvdla_core_clk_orig, `ASSERT_RESET, (mc_dma_wr_req_vld && !mc_dma_wr_req_rdy), (mc_dma_wr_req_vld), (mc_dma_wr_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_CDP_WDMA_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is cv_int_wr_req_pd (cv_int_wr_req_valid,cv_int_wr_req_ready) <= dma_wr_req_pd[514:0] (cv_dma_wr_req_vld,cv_dma_wr_req_rdy)
// **************************************************************************************************************
module NV_NVDLA_CDP_WDMA_pipe_p3 (
   nvdla_core_clk_orig
  ,nvdla_core_rstn
  ,cv_dma_wr_req_vld
  ,cv_int_wr_req_ready
  ,dma_wr_req_pd
  ,cv_dma_wr_req_rdy
  ,cv_int_wr_req_pd
  ,cv_int_wr_req_valid
  );
input          nvdla_core_clk_orig;
input          nvdla_core_rstn;
input          cv_dma_wr_req_vld;
input          cv_int_wr_req_ready;
input  [514:0] dma_wr_req_pd;
output         cv_dma_wr_req_rdy;
output [514:0] cv_int_wr_req_pd;
output         cv_int_wr_req_valid;
reg            cv_dma_wr_req_rdy;
reg    [514:0] cv_int_wr_req_pd;
reg            cv_int_wr_req_valid;
reg    [514:0] p3_pipe_data;
reg    [514:0] p3_pipe_rand_data;
reg            p3_pipe_rand_ready;
reg            p3_pipe_rand_valid;
reg            p3_pipe_ready;
reg            p3_pipe_ready_bc;
reg            p3_pipe_valid;
reg            p3_skid_catch;
reg    [514:0] p3_skid_data;
reg    [514:0] p3_skid_pipe_data;
reg            p3_skid_pipe_ready;
reg            p3_skid_pipe_valid;
reg            p3_skid_ready;
reg            p3_skid_ready_flop;
reg            p3_skid_valid;
//## pipe (3) randomizer
`ifndef SYNTHESIS
reg p3_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p3_pipe_rand_active
  or 
     `endif
     cv_dma_wr_req_vld
  or p3_pipe_rand_ready
  or dma_wr_req_pd
  ) begin
  `ifdef SYNTHESIS
  p3_pipe_rand_valid = cv_dma_wr_req_vld;
  cv_dma_wr_req_rdy = p3_pipe_rand_ready;
  p3_pipe_rand_data = dma_wr_req_pd[514:0];
  `else
  // VCS coverage off
  p3_pipe_rand_valid = (p3_pipe_rand_active)? 1'b0 : cv_dma_wr_req_vld;
  cv_dma_wr_req_rdy = (p3_pipe_rand_active)? 1'b0 : p3_pipe_rand_ready;
  p3_pipe_rand_data = (p3_pipe_rand_active)?  'bx : dma_wr_req_pd[514:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p3_pipe_stall_cycles;
integer p3_pipe_stall_probability;
integer p3_pipe_stall_cycles_min;
integer p3_pipe_stall_cycles_max;
initial begin
  p3_pipe_stall_cycles = 0;
  p3_pipe_stall_probability = 0;
  p3_pipe_stall_cycles_min = 1;
  p3_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_CDP_wdma_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_CDP_wdma_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_CDP_wdma_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_CDP_wdma_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_CDP_wdma_pipe_stall_probability" ) ) p3_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_CDP_wdma_pipe_stall_cycles_min"  ) ) p3_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_CDP_wdma_pipe_stall_cycles_max"  ) ) p3_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p3_pipe_rand_enable;
reg p3_pipe_rand_poised;
always @(
  p3_pipe_stall_cycles
  or p3_pipe_stall_probability
  or cv_dma_wr_req_vld
  ) begin
  p3_pipe_rand_active = p3_pipe_stall_cycles != 0;
  p3_pipe_rand_enable = p3_pipe_stall_probability != 0;
  p3_pipe_rand_poised = p3_pipe_rand_enable && !p3_pipe_rand_active && cv_dma_wr_req_vld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p3_pipe_rand_poised) begin
    if (p3_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p3_pipe_stall_cycles <= prand_inst1(p3_pipe_stall_cycles_min, p3_pipe_stall_cycles_max);
    end
  end else if (p3_pipe_rand_active) begin
    p3_pipe_stall_cycles <= p3_pipe_stall_cycles - 1;
  end else begin
    p3_pipe_stall_cycles <= 0;
  end
  end
end

`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
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
            // magic numbers taken from Java's random class (same as lrand48)
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
// Only verilog needs any local variables
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
            // magic numbers taken from Java's random class (same as lrand48)
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

`endif
// VCS coverage on
//## pipe (3) skid buffer
always @(
  p3_pipe_rand_valid
  or p3_skid_ready_flop
  or p3_skid_pipe_ready
  or p3_skid_valid
  ) begin
  p3_skid_catch = p3_pipe_rand_valid && p3_skid_ready_flop && !p3_skid_pipe_ready;  
  p3_skid_ready = (p3_skid_valid)? p3_skid_pipe_ready : !p3_skid_catch;
end
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_skid_valid <= 1'b0;
    p3_skid_ready_flop <= 1'b1;
    p3_pipe_rand_ready <= 1'b1;
  end else begin
  p3_skid_valid <= (p3_skid_valid)? !p3_skid_pipe_ready : p3_skid_catch;
  p3_skid_ready_flop <= p3_skid_ready;
  p3_pipe_rand_ready <= p3_skid_ready;
  end
end
always @(posedge nvdla_core_clk_orig) begin
  // VCS sop_coverage_off start
  p3_skid_data <= (p3_skid_catch)? p3_pipe_rand_data : p3_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p3_skid_ready_flop
  or p3_pipe_rand_valid
  or p3_skid_valid
  or p3_pipe_rand_data
  or p3_skid_data
  ) begin
  p3_skid_pipe_valid = (p3_skid_ready_flop)? p3_pipe_rand_valid : p3_skid_valid; 
  // VCS sop_coverage_off start
  p3_skid_pipe_data = (p3_skid_ready_flop)? p3_pipe_rand_data : p3_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (3) valid-ready-bubble-collapse
always @(
  p3_pipe_ready
  or p3_pipe_valid
  ) begin
  p3_pipe_ready_bc = p3_pipe_ready || !p3_pipe_valid;
end
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_pipe_valid <= 1'b0;
  end else begin
  p3_pipe_valid <= (p3_pipe_ready_bc)? p3_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk_orig) begin
  // VCS sop_coverage_off start
  p3_pipe_data <= (p3_pipe_ready_bc && p3_skid_pipe_valid)? p3_skid_pipe_data : p3_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p3_pipe_ready_bc
  ) begin
  p3_skid_pipe_ready = p3_pipe_ready_bc;
end
//## pipe (3) output
always @(
  p3_pipe_valid
  or cv_int_wr_req_ready
  or p3_pipe_data
  ) begin
  cv_int_wr_req_valid = p3_pipe_valid;
  p3_pipe_ready = cv_int_wr_req_ready;
  cv_int_wr_req_pd = p3_pipe_data;
end
//## pipe (3) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p3_assert_clk = nvdla_core_clk_orig;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_28x (nvdla_core_clk_orig, `ASSERT_RESET, nvdla_core_rstn, (cv_int_wr_req_valid^cv_int_wr_req_ready^cv_dma_wr_req_vld^cv_dma_wr_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_29x (nvdla_core_clk_orig, `ASSERT_RESET, (cv_dma_wr_req_vld && !cv_dma_wr_req_rdy), (cv_dma_wr_req_vld), (cv_dma_wr_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`endif
endmodule // NV_NVDLA_CDP_WDMA_pipe_p3


// -w 64, 8byte each fifo
// -d 3, depth=4 as we have rd_reg
//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_CDP_WDMA_dat_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus dat_fifo_wr -rd_pipebus dat_fifo_rd -rd_reg -ram_bypass -d 3 -w 64 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_CDP_WDMA_dat_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , dat_fifo_wr_prdy
    , dat_fifo_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , dat_fifo_wr_pause
`endif
    , dat_fifo_wr_pd
    , dat_fifo_rd_prdy
    , dat_fifo_rd_pvld
    , dat_fifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        dat_fifo_wr_prdy;
input         dat_fifo_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         dat_fifo_wr_pause;
`endif
input  [63:0] dat_fifo_wr_pd;
input         dat_fifo_rd_prdy;
output        dat_fifo_rd_pvld;
output [63:0] dat_fifo_rd_pd;
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
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
wire wr_pause_rand;  // random stalling
`endif	
`endif	
// synopsys translate_on
wire wr_reserving;
reg        dat_fifo_wr_busy_int;		        	// copy for internal use
assign     dat_fifo_wr_prdy = !dat_fifo_wr_busy_int;
assign       wr_reserving = dat_fifo_wr_pvld && !dat_fifo_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [1:0] dat_fifo_wr_count;			// write-side count

wire [1:0] wr_count_next_wr_popping = wr_reserving ? dat_fifo_wr_count : (dat_fifo_wr_count - 1'd1); // spyglass disable W164a W484
wire [1:0] wr_count_next_no_wr_popping = wr_reserving ? (dat_fifo_wr_count + 1'd1) : dat_fifo_wr_count; // spyglass disable W164a W484
wire [1:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_3 = ( wr_count_next_no_wr_popping == 2'd3 );
wire wr_count_next_is_3 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_3;
wire [1:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [1:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       dat_fifo_wr_busy_next = wr_count_next_is_3 || // busy next cycle?
                          (wr_limit_reg != 2'd0 &&      // check dat_fifo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg) || dat_fifo_wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       dat_fifo_wr_busy_next = wr_count_next_is_3 || // busy next cycle?
                          (wr_limit_reg != 2'd0 &&      // check dat_fifo_wr_limit if != 0
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
        dat_fifo_wr_busy_int <=  1'b0;
        dat_fifo_wr_count <=  2'd0;
    end else begin
	dat_fifo_wr_busy_int <=  dat_fifo_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    dat_fifo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            dat_fifo_wr_count <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as dat_fifo_wr_pvld

//
// RAM
//

reg  [1:0] dat_fifo_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_wr_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    dat_fifo_wr_adr <=  (dat_fifo_wr_adr == 2'd2) ? 2'd0 : (dat_fifo_wr_adr + 1'd1);
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] dat_fifo_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (dat_fifo_wr_count > 2'd0 || !rd_popping);   // note: write occurs next cycle
wire [63:0] dat_fifo_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_3x64 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( dat_fifo_wr_pd )
    , .we        ( ram_we )
    , .wa        ( dat_fifo_wr_adr )
    , .ra        ( (dat_fifo_wr_count == 0) ? 2'd3 : dat_fifo_rd_adr )
    , .dout        ( dat_fifo_rd_pd_p )
    );


wire [1:0] rd_adr_next_popping = (dat_fifo_rd_adr == 2'd2) ? 2'd0 : (dat_fifo_rd_adr + 1'd1); // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_rd_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
	    dat_fifo_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            dat_fifo_rd_adr <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

wire       dat_fifo_rd_pvld_p; 		// data out of fifo is valid

reg        dat_fifo_rd_pvld_int;	// internal copy of dat_fifo_rd_pvld
assign     dat_fifo_rd_pvld = dat_fifo_rd_pvld_int;
assign     rd_popping = dat_fifo_rd_pvld_p && !(dat_fifo_rd_pvld_int && !dat_fifo_rd_prdy);

reg  [1:0] dat_fifo_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [1:0] rd_count_p_next_rd_popping = rd_pushing ? dat_fifo_rd_count_p : 
                                                                (dat_fifo_rd_count_p - 1'd1);
wire [1:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (dat_fifo_rd_count_p + 1'd1) : 
                                                                    dat_fifo_rd_count_p;
// spyglass enable_block W164a W484
wire [1:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     dat_fifo_rd_pvld_p = dat_fifo_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_rd_count_p <=  2'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    dat_fifo_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            dat_fifo_rd_count_p <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end
reg [63:0]  dat_fifo_rd_pd;         // output data register
wire        rd_req_next = (dat_fifo_rd_pvld_p || (dat_fifo_rd_pvld_int && !dat_fifo_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_rd_pvld_int <=  1'b0;
    end else begin
        dat_fifo_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        dat_fifo_rd_pd <=  dat_fifo_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        dat_fifo_rd_pd <=  {64{`x_or_0}};
    end
    //synopsys translate_on

end

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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (dat_fifo_wr_pvld && !dat_fifo_wr_busy_int) || (dat_fifo_wr_busy_int != dat_fifo_wr_busy_next)) || (rd_pushing || rd_popping || (dat_fifo_rd_pvld_int && dat_fifo_rd_prdy)) || (wr_pushing))
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


// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_CDP_WDMA_dat_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_CDP_WDMA_dat_fifo_wr_limit : 2'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 2'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 2'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 2'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [1:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 2'd0;
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
    wr_limit_override_value = 0;  // to keep viva happy with dangles
    if ( $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif


// Random Write-Side Stalling
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

integer stall_probability;      // prob of stalling
integer stall_cycles_min;       // min cycles to stall
integer stall_cycles_max;       // max cycles to stall
integer stall_cycles_left;      // stall cycles left
`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    stall_probability      = 0; // no stalling by default
    stall_cycles_min       = 1;
    stall_cycles_max       = 10;

`ifdef NO_PLI
`else
    if ( $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_cycles_max=%d", stall_cycles_max);
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

// randomization globals
`ifdef SIMTOP_RANDOMIZE_STALLS
  always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
    if ( ! $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_CDP_WDMA_dat_fifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
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
            if ( dat_fifo_wr_pvld && !(!dat_fifo_wr_prdy)
                 && stall_probability != 0 ) begin
                if ( prand_inst2(1, 100) <= stall_probability ) begin
                    stall_cycles_left <=  prand_inst3(stall_cycles_min, stall_cycles_max);
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
// Histogram of fifo depth (from write side's perspective)
//
// NOTE: it will reference `SIMTOP.perfmon_enabled, so that
//       has to at least be defined, though not initialized.
//	 tbgen testbenches have it already and various
//	 ways to turn it on and off.
//
`ifdef PERFMON_HISTOGRAM 
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( nvdla_core_clk ) 
    , .max      ( {30'd0, (wr_limit_reg == 2'd0) ? 2'd3 : wr_limit_reg} )
    , .curr	( {30'd0, dat_fifo_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_CDP_WDMA_dat_fifo") true
// synopsys dc_script_end


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed2;
reg prand_initialized2;
reg prand_no_rollpli2;
`endif
`endif
`endif

function [31:0] prand_inst2;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst2 = min;
`else
`ifdef SYNTHESIS
        prand_inst2 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized2 !== 1'b1) begin
            prand_no_rollpli2 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli2)
                prand_local_seed2 = {$prand_get_seed(2), 16'b0};
            prand_initialized2 = 1'b1;
        end
        if (prand_no_rollpli2) begin
            prand_inst2 = min;
        end else begin
            diff = max - min + 1;
            prand_inst2 = min + prand_local_seed2[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed2 = prand_local_seed2 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst2 = min;
`else
        prand_inst2 = $RollPLI(min, max, "auto");
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
// Only verilog needs any local variables
reg [47:0] prand_local_seed3;
reg prand_initialized3;
reg prand_no_rollpli3;
`endif
`endif
`endif

function [31:0] prand_inst3;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst3 = min;
`else
`ifdef SYNTHESIS
        prand_inst3 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized3 !== 1'b1) begin
            prand_no_rollpli3 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli3)
                prand_local_seed3 = {$prand_get_seed(3), 16'b0};
            prand_initialized3 = 1'b1;
        end
        if (prand_no_rollpli3) begin
            prand_inst3 = min;
        end else begin
            diff = max - min + 1;
            prand_inst3 = min + prand_local_seed3[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed3 = prand_local_seed3 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst3 = min;
`else
        prand_inst3 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


endmodule // NV_NVDLA_CDP_WDMA_dat_fifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_3x64 (
      clk
    , pwrbus_ram_pd
    , di
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input [31 : 0] pwrbus_ram_pd;
input  [63:0] di;
input  we;
input  [1:0] wa;
input  [1:0] ra;
output [63:0] dout;

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


`ifdef EMU


wire [63:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [63:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_3x64 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 3) ? di : dout_p;

`else

reg [63:0] ram_ff0;
reg [63:0] ram_ff1;
reg [63:0] ram_ff2;

always @( posedge clk ) begin
    if ( we && wa == 2'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 2'd1 ) begin
	ram_ff1 <=  di;
    end
    if ( we && wa == 2'd2 ) begin
	ram_ff2 <=  di;
    end
end

reg [63:0] dout;

always @(*) begin
    case( ra ) 
    2'd0:       dout = ram_ff0;
    2'd1:       dout = ram_ff1;
    2'd2:       dout = ram_ff2;
    2'd3:       dout = di;
    //VCS coverage off
    default:    dout = {64{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_3x64

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_3x64 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [63:0] Di0;
input  [1:0] Ra0;
output [63:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 64'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [63:0] mem[2:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [63:0] Q0 = mem[0];
wire [63:0] Q1 = mem[1];
wire [63:0] Q2 = mem[2];
`endif

// asynchronous ram writes
always @(*) begin
  if ( we0 == 1'b1 ) begin
    #0.1;
    mem[Wa0] = Di0;
  end
end

assign Do0 = mem[Ra0];
`endif
`endif
// synopsys translate_on

// synopsys dc_script_begin
// synopsys dc_script_end

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_3x64] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_3x64] }
endmodule // vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_3x64

//vmw: Memory vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_3x64
//vmw: Address-size 2
//vmw: Data-size 64
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[63:0] data0[63:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[63:0] data1[63:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_CDP_WDMA_dat_fifo_flopram_rwsa_3x64
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU
                
// swizzle: 0: start from fifo_0; start from fifo_4
// width: 0~7, 32x1 in each 32x8
// -d 3, depth=4 as we have rd_reg
//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_CDP_WDMA_cmd_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus cmd_fifo_wr -rd_pipebus cmd_fifo_rd -rd_reg -ram_bypass -d 3 -w 15 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_CDP_WDMA_cmd_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , cmd_fifo_wr_prdy
    , cmd_fifo_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , cmd_fifo_wr_pause
`endif
    , cmd_fifo_wr_pd
    , cmd_fifo_rd_prdy
    , cmd_fifo_rd_pvld
    , cmd_fifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        cmd_fifo_wr_prdy;
input         cmd_fifo_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         cmd_fifo_wr_pause;
`endif
input  [14:0] cmd_fifo_wr_pd;
input         cmd_fifo_rd_prdy;
output        cmd_fifo_rd_pvld;
output [14:0] cmd_fifo_rd_pd;
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
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
wire wr_pause_rand;  // random stalling
`endif	
`endif	
// synopsys translate_on
wire wr_reserving;
reg        cmd_fifo_wr_busy_int;		        	// copy for internal use
assign     cmd_fifo_wr_prdy = !cmd_fifo_wr_busy_int;
assign       wr_reserving = cmd_fifo_wr_pvld && !cmd_fifo_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [1:0] cmd_fifo_wr_count;			// write-side count

wire [1:0] wr_count_next_wr_popping = wr_reserving ? cmd_fifo_wr_count : (cmd_fifo_wr_count - 1'd1); // spyglass disable W164a W484
wire [1:0] wr_count_next_no_wr_popping = wr_reserving ? (cmd_fifo_wr_count + 1'd1) : cmd_fifo_wr_count; // spyglass disable W164a W484
wire [1:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_3 = ( wr_count_next_no_wr_popping == 2'd3 );
wire wr_count_next_is_3 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_3;
wire [1:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [1:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       cmd_fifo_wr_busy_next = wr_count_next_is_3 || // busy next cycle?
                          (wr_limit_reg != 2'd0 &&      // check cmd_fifo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg) || cmd_fifo_wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       cmd_fifo_wr_busy_next = wr_count_next_is_3 || // busy next cycle?
                          (wr_limit_reg != 2'd0 &&      // check cmd_fifo_wr_limit if != 0
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
        cmd_fifo_wr_busy_int <=  1'b0;
        cmd_fifo_wr_count <=  2'd0;
    end else begin
	cmd_fifo_wr_busy_int <=  cmd_fifo_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    cmd_fifo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            cmd_fifo_wr_count <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as cmd_fifo_wr_pvld

//
// RAM
//

reg  [1:0] cmd_fifo_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_wr_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    cmd_fifo_wr_adr <=  (cmd_fifo_wr_adr == 2'd2) ? 2'd0 : (cmd_fifo_wr_adr + 1'd1);
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] cmd_fifo_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (cmd_fifo_wr_count > 2'd0 || !rd_popping);   // note: write occurs next cycle
wire [14:0] cmd_fifo_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_CDP_WDMA_cmd_fifo_flopram_rwsa_3x15 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( cmd_fifo_wr_pd )
    , .we        ( ram_we )
    , .wa        ( cmd_fifo_wr_adr )
    , .ra        ( (cmd_fifo_wr_count == 0) ? 2'd3 : cmd_fifo_rd_adr )
    , .dout        ( cmd_fifo_rd_pd_p )
    );


wire [1:0] rd_adr_next_popping = (cmd_fifo_rd_adr == 2'd2) ? 2'd0 : (cmd_fifo_rd_adr + 1'd1); // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_rd_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
	    cmd_fifo_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            cmd_fifo_rd_adr <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

wire       cmd_fifo_rd_pvld_p; 		// data out of fifo is valid

reg        cmd_fifo_rd_pvld_int;	// internal copy of cmd_fifo_rd_pvld
assign     cmd_fifo_rd_pvld = cmd_fifo_rd_pvld_int;
assign     rd_popping = cmd_fifo_rd_pvld_p && !(cmd_fifo_rd_pvld_int && !cmd_fifo_rd_prdy);

reg  [1:0] cmd_fifo_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [1:0] rd_count_p_next_rd_popping = rd_pushing ? cmd_fifo_rd_count_p : 
                                                                (cmd_fifo_rd_count_p - 1'd1);
wire [1:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (cmd_fifo_rd_count_p + 1'd1) : 
                                                                    cmd_fifo_rd_count_p;
// spyglass enable_block W164a W484
wire [1:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     cmd_fifo_rd_pvld_p = cmd_fifo_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_rd_count_p <=  2'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    cmd_fifo_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            cmd_fifo_rd_count_p <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end
reg [14:0]  cmd_fifo_rd_pd;         // output data register
wire        rd_req_next = (cmd_fifo_rd_pvld_p || (cmd_fifo_rd_pvld_int && !cmd_fifo_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_rd_pvld_int <=  1'b0;
    end else begin
        cmd_fifo_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        cmd_fifo_rd_pd <=  cmd_fifo_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        cmd_fifo_rd_pd <=  {15{`x_or_0}};
    end
    //synopsys translate_on

end

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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (cmd_fifo_wr_pvld && !cmd_fifo_wr_busy_int) || (cmd_fifo_wr_busy_int != cmd_fifo_wr_busy_next)) || (rd_pushing || rd_popping || (cmd_fifo_rd_pvld_int && cmd_fifo_rd_prdy)) || (wr_pushing))
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


// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_CDP_WDMA_cmd_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_CDP_WDMA_cmd_fifo_wr_limit : 2'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 2'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 2'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 2'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [1:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 2'd0;
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
    wr_limit_override_value = 0;  // to keep viva happy with dangles
    if ( $test$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif


// Random Write-Side Stalling
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

integer stall_probability;      // prob of stalling
integer stall_cycles_min;       // min cycles to stall
integer stall_cycles_max;       // max cycles to stall
integer stall_cycles_left;      // stall cycles left
`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    stall_probability      = 0; // no stalling by default
    stall_cycles_min       = 1;
    stall_cycles_max       = 10;

`ifdef NO_PLI
`else
    if ( $test$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_fifo_stall_cycles_max=%d", stall_cycles_max);
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

// randomization globals
`ifdef SIMTOP_RANDOMIZE_STALLS
  always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
    if ( ! $test$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_CDP_WDMA_cmd_fifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
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
            if ( cmd_fifo_wr_pvld && !(!cmd_fifo_wr_prdy)
                 && stall_probability != 0 ) begin
                if ( prand_inst4(1, 100) <= stall_probability ) begin
                    stall_cycles_left <=  prand_inst5(stall_cycles_min, stall_cycles_max);
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
// Histogram of fifo depth (from write side's perspective)
//
// NOTE: it will reference `SIMTOP.perfmon_enabled, so that
//       has to at least be defined, though not initialized.
//	 tbgen testbenches have it already and various
//	 ways to turn it on and off.
//
`ifdef PERFMON_HISTOGRAM 
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( nvdla_core_clk ) 
    , .max      ( {30'd0, (wr_limit_reg == 2'd0) ? 2'd3 : wr_limit_reg} )
    , .curr	( {30'd0, cmd_fifo_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_CDP_WDMA_cmd_fifo") true
// synopsys dc_script_end


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed4;
reg prand_initialized4;
reg prand_no_rollpli4;
`endif
`endif
`endif

function [31:0] prand_inst4;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst4 = min;
`else
`ifdef SYNTHESIS
        prand_inst4 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized4 !== 1'b1) begin
            prand_no_rollpli4 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli4)
                prand_local_seed4 = {$prand_get_seed(4), 16'b0};
            prand_initialized4 = 1'b1;
        end
        if (prand_no_rollpli4) begin
            prand_inst4 = min;
        end else begin
            diff = max - min + 1;
            prand_inst4 = min + prand_local_seed4[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed4 = prand_local_seed4 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst4 = min;
`else
        prand_inst4 = $RollPLI(min, max, "auto");
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
// Only verilog needs any local variables
reg [47:0] prand_local_seed5;
reg prand_initialized5;
reg prand_no_rollpli5;
`endif
`endif
`endif

function [31:0] prand_inst5;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst5 = min;
`else
`ifdef SYNTHESIS
        prand_inst5 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized5 !== 1'b1) begin
            prand_no_rollpli5 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli5)
                prand_local_seed5 = {$prand_get_seed(5), 16'b0};
            prand_initialized5 = 1'b1;
        end
        if (prand_no_rollpli5) begin
            prand_inst5 = min;
        end else begin
            diff = max - min + 1;
            prand_inst5 = min + prand_local_seed5[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed5 = prand_local_seed5 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst5 = min;
`else
        prand_inst5 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


endmodule // NV_NVDLA_CDP_WDMA_cmd_fifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_CDP_WDMA_cmd_fifo_flopram_rwsa_3x15 (
      clk
    , pwrbus_ram_pd
    , di
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input [31 : 0] pwrbus_ram_pd;
input  [14:0] di;
input  we;
input  [1:0] wa;
input  [1:0] ra;
output [14:0] dout;

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


`ifdef EMU


wire [14:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [14:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_CDP_WDMA_cmd_fifo_flopram_rwsa_3x15 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 3) ? di : dout_p;

`else

reg [14:0] ram_ff0;
reg [14:0] ram_ff1;
reg [14:0] ram_ff2;

always @( posedge clk ) begin
    if ( we && wa == 2'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 2'd1 ) begin
	ram_ff1 <=  di;
    end
    if ( we && wa == 2'd2 ) begin
	ram_ff2 <=  di;
    end
end

reg [14:0] dout;

always @(*) begin
    case( ra ) 
    2'd0:       dout = ram_ff0;
    2'd1:       dout = ram_ff1;
    2'd2:       dout = ram_ff2;
    2'd3:       dout = di;
    //VCS coverage off
    default:    dout = {15{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_CDP_WDMA_cmd_fifo_flopram_rwsa_3x15

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_CDP_WDMA_cmd_fifo_flopram_rwsa_3x15 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [14:0] Di0;
input  [1:0] Ra0;
output [14:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 15'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [14:0] mem[2:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [14:0] Q0 = mem[0];
wire [14:0] Q1 = mem[1];
wire [14:0] Q2 = mem[2];
`endif

// asynchronous ram writes
always @(*) begin
  if ( we0 == 1'b1 ) begin
    #0.1;
    mem[Wa0] = Di0;
  end
end

assign Do0 = mem[Ra0];
`endif
`endif
// synopsys translate_on

// synopsys dc_script_begin
// synopsys dc_script_end

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_CDP_WDMA_cmd_fifo_flopram_rwsa_3x15] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_CDP_WDMA_cmd_fifo_flopram_rwsa_3x15] }
endmodule // vmw_NV_NVDLA_CDP_WDMA_cmd_fifo_flopram_rwsa_3x15

//vmw: Memory vmw_NV_NVDLA_CDP_WDMA_cmd_fifo_flopram_rwsa_3x15
//vmw: Address-size 2
//vmw: Data-size 15
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[14:0] data0[14:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[14:0] data1[14:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_CDP_WDMA_cmd_fifo_flopram_rwsa_3x15
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU

//interrupt fifo
//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_CDP_WDMA_intr_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus intr_fifo_wr -rd_pipebus intr_fifo_rd -ram_bypass -d 0 -rd_reg -rd_busy_reg -no_wr_busy -w 1 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_CDP_WDMA_intr_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , intr_fifo_wr_pvld
    , intr_fifo_wr_pd
    , intr_fifo_rd_prdy
    , intr_fifo_rd_pvld
    , intr_fifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
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

// spyglass enable_block W401 -- clock is not input to module

// synopsys dc_script_begin
//   set_boundary_optimization find(design, "NV_NVDLA_CDP_WDMA_intr_fifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_CDP_WDMA_intr_fifo

