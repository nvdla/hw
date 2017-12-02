// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_PDP_wdma.v

`include "simulate_x_tick.vh"
module NV_NVDLA_PDP_wdma (
   nvdla_core_clk                 //|< i
  ,nvdla_core_clk_orig            //|< i
  ,nvdla_core_rstn                //|< i
  ,cvif2pdp_wr_rsp_complete       //|< i
  ,mcif2pdp_wr_rsp_complete       //|< i
  ,pdp2cvif_wr_req_ready          //|< i
  ,pdp2mcif_wr_req_ready          //|< i
  ,pdp_dp2wdma_pd                 //|< i
  ,pdp_dp2wdma_valid              //|< i
  ,pwrbus_ram_pd                  //|< i
  ,rdma2wdma_done                 //|< i
  ,reg2dp_cube_out_channel        //|< i
  ,reg2dp_cube_out_height         //|< i
  ,reg2dp_cube_out_width          //|< i
  ,reg2dp_dma_en                  //|< i
  ,reg2dp_dst_base_addr_high      //|< i
  ,reg2dp_dst_base_addr_low       //|< i
  ,reg2dp_dst_line_stride         //|< i
  ,reg2dp_dst_ram_type            //|< i
  ,reg2dp_dst_surface_stride      //|< i
  ,reg2dp_flying_mode             //|< i
  ,reg2dp_input_data              //|< i
  ,reg2dp_interrupt_ptr           //|< i
  ,reg2dp_op_en                   //|< i
  ,reg2dp_partial_width_out_first //|< i
  ,reg2dp_partial_width_out_last  //|< i
  ,reg2dp_partial_width_out_mid   //|< i
  ,reg2dp_split_num               //|< i
  ,dp2reg_d0_perf_write_stall     //|> o
  ,dp2reg_d1_perf_write_stall     //|> o
  ,dp2reg_done                    //|> o
  ,dp2reg_nan_output_num          //|> o
  ,pdp2cvif_wr_req_pd             //|> o
  ,pdp2cvif_wr_req_valid          //|> o
  ,pdp2glb_done_intr_pd           //|> o
  ,pdp2mcif_wr_req_pd             //|> o
  ,pdp2mcif_wr_req_valid          //|> o
  ,pdp_dp2wdma_ready              //|> o
  );
//
// NV_NVDLA_PDP_wdma_ports.v
//
input  nvdla_core_clk;   /* pdp2mcif_wr_req, mcif2pdp_wr_rsp, pdp2cvif_wr_req, cvif2pdp_wr_rsp, pdp_dp2wdma, pdp2glb_done_intr */
input  nvdla_core_rstn;  /* pdp2mcif_wr_req, mcif2pdp_wr_rsp, pdp2cvif_wr_req, cvif2pdp_wr_rsp, pdp_dp2wdma, pdp2glb_done_intr */

output         pdp2mcif_wr_req_valid;  /* data valid */
input          pdp2mcif_wr_req_ready;  /* data return handshake */
output [514:0] pdp2mcif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input  mcif2pdp_wr_rsp_complete;

output         pdp2cvif_wr_req_valid;  /* data valid */
input          pdp2cvif_wr_req_ready;  /* data return handshake */
output [514:0] pdp2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input  cvif2pdp_wr_rsp_complete;

input         pdp_dp2wdma_valid;  /* data valid */
output        pdp_dp2wdma_ready;  /* data return handshake */
input  [63:0] pdp_dp2wdma_pd;

input [31:0] pwrbus_ram_pd;

output [1:0] pdp2glb_done_intr_pd;

input          rdma2wdma_done;
input   [12:0] reg2dp_cube_out_channel;
input   [12:0] reg2dp_cube_out_height;
input   [12:0] reg2dp_cube_out_width;
input          reg2dp_dma_en;
input   [31:0] reg2dp_dst_base_addr_high;
input   [26:0] reg2dp_dst_base_addr_low;
input   [26:0] reg2dp_dst_line_stride;
input          reg2dp_dst_ram_type;
input   [26:0] reg2dp_dst_surface_stride;
input          reg2dp_flying_mode;
input    [1:0] reg2dp_input_data;
input          reg2dp_interrupt_ptr;
input          reg2dp_op_en;
input    [9:0] reg2dp_partial_width_out_first;
input    [9:0] reg2dp_partial_width_out_last;
input    [9:0] reg2dp_partial_width_out_mid;
input    [7:0] reg2dp_split_num;
output  [31:0] dp2reg_d0_perf_write_stall;
output  [31:0] dp2reg_d1_perf_write_stall;
output         dp2reg_done;
output  [31:0] dp2reg_nan_output_num;
input   nvdla_core_clk_orig;
reg            ack_bot_id;
reg            ack_bot_vld;
reg            ack_top_id;
reg            ack_top_vld;
reg            cmd_en;
reg     [12:0] cmd_fifo_rd_size_use;
reg     [12:0] count_w;
reg            cv_dma_wr_rsp_complete;
reg            cv_pending;
reg            cvif2pdp_wr_rsp_complete_d1;
reg            dat0_fifo_rd_pvld;
reg            dat1_fifo_rd_pvld;
reg            dat_en;
reg    [514:0] dma_wr_req_pd;
reg            dma_wr_rsp_complete;
reg     [31:0] dp2reg_d0_perf_write_stall;
reg     [31:0] dp2reg_d1_perf_write_stall;
reg     [31:0] dp2reg_nan_output_num;
reg     [63:0] dp2wdma_pd;
reg            dp2wdma_vld;
reg            fp16_en;
reg            intp_waiting_rdma;
reg            layer_flag;
reg            mc_dma_wr_rsp_complete;
reg            mc_pending;
reg            mcif2pdp_wr_rsp_complete_d1;
reg            mon_nan_in_count;
reg     [31:0] nan_in_count;
reg            op_prcess;
reg     [63:0] p1_pipe_data;
reg     [63:0] p1_pipe_rand_data;
reg            p1_pipe_rand_ready;
reg            p1_pipe_rand_valid;
reg            p1_pipe_ready;
reg            p1_pipe_ready_bc;
reg            p1_pipe_valid;
reg            p1_skid_catch;
reg     [63:0] p1_skid_data;
reg     [63:0] p1_skid_pipe_data;
reg            p1_skid_pipe_ready;
reg            p1_skid_pipe_valid;
reg            p1_skid_ready;
reg            p1_skid_ready_flop;
reg            p1_skid_valid;
reg      [1:0] pdp2glb_done_intr_pd;
reg            pdp_dp2wdma_ready;
reg     [31:0] pdp_wr_stall_count;
reg            reading_done_flag;
reg            reg_cube_last;
reg      [1:0] reg_lenb;
reg     [12:0] reg_size;
reg            stl_adv;
reg     [31:0] stl_cnt_cur;
reg     [33:0] stl_cnt_dec;
reg     [33:0] stl_cnt_ext;
reg     [33:0] stl_cnt_inc;
reg     [33:0] stl_cnt_mod;
reg     [33:0] stl_cnt_new;
reg     [33:0] stl_cnt_nxt;
reg            waiting_rdma;
reg            wdma_done;
reg            wdma_done_d1;
wire           ack_bot_rdy;
wire           ack_raw_id;
wire           ack_raw_rdy;
wire           ack_raw_vld;
wire           ack_top_rdy;
wire    [63:0] cmd_fifo_rd_addr;
wire           cmd_fifo_rd_cube_end;
wire     [1:0] cmd_fifo_rd_lenb;
wire    [79:0] cmd_fifo_rd_pd;
wire           cmd_fifo_rd_prdy;
wire           cmd_fifo_rd_pvld;
wire    [12:0] cmd_fifo_rd_size;
wire           cnt_cen;
wire           cnt_clr;
wire           cnt_inc;
wire           cv_dma_wr_req_rdy;
wire           cv_dma_wr_req_vld;
wire   [514:0] cv_int_wr_req_pd;
wire   [514:0] cv_int_wr_req_pd_d0;
wire   [514:0] cv_int_wr_req_pd_d1;
wire           cv_int_wr_req_ready;
wire           cv_int_wr_req_ready_d0;
wire           cv_int_wr_req_ready_d1;
wire           cv_int_wr_req_valid;
wire           cv_int_wr_req_valid_d0;
wire           cv_int_wr_req_valid_d1;
wire           cv_int_wr_rsp_complete;
wire           cv_releasing;
wire           cv_wr_req_rdyi;
wire   [255:0] dat0_data;
wire    [63:0] dat0_fifo0_rd_pd;
wire           dat0_fifo0_rd_prdy;
wire           dat0_fifo0_rd_pvld;
wire    [63:0] dat0_fifo1_rd_pd;
wire           dat0_fifo1_rd_prdy;
wire           dat0_fifo1_rd_pvld;
wire    [63:0] dat0_fifo2_rd_pd;
wire           dat0_fifo2_rd_prdy;
wire           dat0_fifo2_rd_pvld;
wire    [63:0] dat0_fifo3_rd_pd;
wire           dat0_fifo3_rd_prdy;
wire           dat0_fifo3_rd_pvld;
wire     [3:0] dat0_is_nan_0;
wire     [3:0] dat0_is_nan_1;
wire     [3:0] dat0_is_nan_2;
wire     [3:0] dat0_is_nan_3;
wire   [255:0] dat1_data;
wire    [63:0] dat1_fifo0_rd_pd;
wire           dat1_fifo0_rd_prdy;
wire           dat1_fifo0_rd_pvld;
wire    [63:0] dat1_fifo1_rd_pd;
wire           dat1_fifo1_rd_prdy;
wire           dat1_fifo1_rd_pvld;
wire    [63:0] dat1_fifo2_rd_pd;
wire           dat1_fifo2_rd_prdy;
wire           dat1_fifo2_rd_pvld;
wire    [63:0] dat1_fifo3_rd_pd;
wire           dat1_fifo3_rd_prdy;
wire           dat1_fifo3_rd_pvld;
wire     [3:0] dat1_is_nan_0;
wire     [3:0] dat1_is_nan_1;
wire     [3:0] dat1_is_nan_2;
wire     [3:0] dat1_is_nan_3;
wire           dat_accept;
wire   [511:0] dat_data;
wire           dat_fifo_rd_last_pvld;
wire           dat_rdy;
wire           dma_wr_cmd_accept;
wire    [63:0] dma_wr_cmd_addr;
wire    [77:0] dma_wr_cmd_pd;
wire           dma_wr_cmd_require_ack;
wire    [22:0] dma_wr_cmd_size;
wire           dma_wr_cmd_vld;
wire   [511:0] dma_wr_dat_data;
wire     [1:0] dma_wr_dat_mask;
wire   [513:0] dma_wr_dat_pd;
wire           dma_wr_dat_vld;
wire           dma_wr_req_rdy;
wire           dma_wr_req_type;
wire           dma_wr_req_vld;
wire           dp2wdma_rdy;
wire           intr_fifo_rd_pd;
wire           intr_fifo_rd_prdy;
wire           intr_fifo_rd_pvld;
wire           intr_fifo_wr_pd;
wire           intr_fifo_wr_pvld;
wire           is_last_beat;
wire           is_size_odd;
wire           mc_dma_wr_req_rdy;
wire           mc_dma_wr_req_vld;
wire   [514:0] mc_int_wr_req_pd;
wire   [514:0] mc_int_wr_req_pd_d0;
wire   [514:0] mc_int_wr_req_pd_d1;
wire           mc_int_wr_req_ready;
wire           mc_int_wr_req_ready_d0;
wire           mc_int_wr_req_ready_d1;
wire           mc_int_wr_req_valid;
wire           mc_int_wr_req_valid_d0;
wire           mc_int_wr_req_valid_d1;
wire           mc_int_wr_rsp_complete;
wire           mc_releasing;
wire           mc_wr_req_rdyi;
wire     [5:0] nan_num_in_64B;
wire    [31:0] nan_num_in_x;
wire           off_fly_en;
wire           on_fly_en;
wire           op_done;
wire           op_load;
wire           pdp_wr_stall_count_dec;
wire           releasing;
wire           require_ack;
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
// tracing rdma reading done to aviod layer switched but RDMA still reading the last layer
//==============
assign on_fly_en = reg2dp_flying_mode == 1'h0 ;
assign off_fly_en = reg2dp_flying_mode == 1'h1 ;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reading_done_flag <= 1'b0;
  end else begin
    if(op_done)
        reading_done_flag <= 1'b0;
    //else if(rdma2wdma_done)
    else if(rdma2wdma_done & off_fly_en)
        reading_done_flag <= 1'b1;
    else if(op_load & on_fly_en)
        reading_done_flag <= 1'b1;
    else if(op_load & off_fly_en)
        reading_done_flag <= 1'b0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    waiting_rdma <= 1'b0;
  end else begin
    if(op_done & (~reading_done_flag))//
        waiting_rdma <= 1'b1;
    else if(reading_done_flag)
        waiting_rdma <= 1'b0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wdma_done <= 1'b0;
  end else begin
    if(op_done & reading_done_flag)//normal case
        wdma_done <= 1'b1;
    else if(waiting_rdma & reading_done_flag)//waiting RDMA case
        wdma_done <= 1'b1;
    else
        wdma_done <= 1'b0;
  end
end
//==============
// Work Processing
//==============
assign op_load = reg2dp_op_en & !op_prcess;
assign op_done = reg_cube_last & is_last_beat & dat_accept;
assign dp2reg_done = wdma_done;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    op_prcess <= 1'b0;
  end else begin
    if (op_load) begin
        op_prcess <= 1'b1;
    end else if (wdma_done) begin
    //end else if (op_done) begin
        op_prcess <= 1'b0;
    end
  end
end
//==============
// Configure from Register
//==============

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
     pdp_dp2wdma_valid
  or p1_pipe_rand_ready
  or pdp_dp2wdma_pd
  ) begin
  `ifdef SYNTHESIS
  p1_pipe_rand_valid = pdp_dp2wdma_valid;
  pdp_dp2wdma_ready = p1_pipe_rand_ready;
  p1_pipe_rand_data = pdp_dp2wdma_pd;
  `else
  // VCS coverage off
  p1_pipe_rand_valid = (p1_pipe_rand_active)? 1'b0 : pdp_dp2wdma_valid;
  pdp_dp2wdma_ready = (p1_pipe_rand_active)? 1'b0 : p1_pipe_rand_ready;
  p1_pipe_rand_data = (p1_pipe_rand_active)?  'bx : pdp_dp2wdma_pd;
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
  if      ( $value$plusargs( "NV_NVDLA_PDP_wdma_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_PDP_wdma_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_PDP_wdma_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_PDP_wdma_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_PDP_wdma_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_PDP_wdma_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_PDP_wdma_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p1_pipe_rand_enable;
reg p1_pipe_rand_poised;
always @(
  p1_pipe_stall_cycles
  or p1_pipe_stall_probability
  or pdp_dp2wdma_valid
  ) begin
  p1_pipe_rand_active = p1_pipe_stall_cycles != 0;
  p1_pipe_rand_enable = p1_pipe_stall_probability != 0;
  p1_pipe_rand_poised = p1_pipe_rand_enable && !p1_pipe_rand_active && pdp_dp2wdma_valid === 1'b1;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (dp2wdma_vld^dp2wdma_rdy^pdp_dp2wdma_valid^pdp_dp2wdma_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (pdp_dp2wdma_valid && !pdp_dp2wdma_ready), (pdp_dp2wdma_valid), (pdp_dp2wdma_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//==============
// Instance CMD
//==============
NV_NVDLA_PDP_WDMA_dat u_dat (
   .reg2dp_cube_out_channel        (reg2dp_cube_out_channel[12:0])       //|< i
  ,.reg2dp_cube_out_height         (reg2dp_cube_out_height[12:0])        //|< i
  ,.reg2dp_cube_out_width          (reg2dp_cube_out_width[12:0])         //|< i
  ,.reg2dp_input_data              (reg2dp_input_data[1:0])              //|< i
  ,.reg2dp_partial_width_out_first (reg2dp_partial_width_out_first[9:0]) //|< i
  ,.reg2dp_partial_width_out_last  (reg2dp_partial_width_out_last[9:0])  //|< i
  ,.reg2dp_partial_width_out_mid   (reg2dp_partial_width_out_mid[9:0])   //|< i
  ,.reg2dp_split_num               (reg2dp_split_num[7:0])               //|< i
  ,.dp2wdma_pd                     (dp2wdma_pd[63:0])                    //|< r
  ,.dp2wdma_vld                    (dp2wdma_vld)                         //|< r
  ,.dp2wdma_rdy                    (dp2wdma_rdy)                         //|> w
  ,.nvdla_core_clk                 (nvdla_core_clk)                      //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                     //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])                 //|< i
  ,.dat0_fifo0_rd_prdy             (dat0_fifo0_rd_prdy)                  //|< w
  ,.dat0_fifo1_rd_prdy             (dat0_fifo1_rd_prdy)                  //|< w
  ,.dat0_fifo2_rd_prdy             (dat0_fifo2_rd_prdy)                  //|< w
  ,.dat0_fifo3_rd_prdy             (dat0_fifo3_rd_prdy)                  //|< w
  ,.dat1_fifo0_rd_prdy             (dat1_fifo0_rd_prdy)                  //|< w
  ,.dat1_fifo1_rd_prdy             (dat1_fifo1_rd_prdy)                  //|< w
  ,.dat1_fifo2_rd_prdy             (dat1_fifo2_rd_prdy)                  //|< w
  ,.dat1_fifo3_rd_prdy             (dat1_fifo3_rd_prdy)                  //|< w
  ,.dat0_fifo0_rd_pd               (dat0_fifo0_rd_pd[63:0])              //|> w
  ,.dat0_fifo0_rd_pvld             (dat0_fifo0_rd_pvld)                  //|> w
  ,.dat0_fifo1_rd_pd               (dat0_fifo1_rd_pd[63:0])              //|> w
  ,.dat0_fifo1_rd_pvld             (dat0_fifo1_rd_pvld)                  //|> w
  ,.dat0_fifo2_rd_pd               (dat0_fifo2_rd_pd[63:0])              //|> w
  ,.dat0_fifo2_rd_pvld             (dat0_fifo2_rd_pvld)                  //|> w
  ,.dat0_fifo3_rd_pd               (dat0_fifo3_rd_pd[63:0])              //|> w
  ,.dat0_fifo3_rd_pvld             (dat0_fifo3_rd_pvld)                  //|> w
  ,.dat1_fifo0_rd_pd               (dat1_fifo0_rd_pd[63:0])              //|> w
  ,.dat1_fifo0_rd_pvld             (dat1_fifo0_rd_pvld)                  //|> w
  ,.dat1_fifo1_rd_pd               (dat1_fifo1_rd_pd[63:0])              //|> w
  ,.dat1_fifo1_rd_pvld             (dat1_fifo1_rd_pvld)                  //|> w
  ,.dat1_fifo2_rd_pd               (dat1_fifo2_rd_pd[63:0])              //|> w
  ,.dat1_fifo2_rd_pvld             (dat1_fifo2_rd_pvld)                  //|> w
  ,.dat1_fifo3_rd_pd               (dat1_fifo3_rd_pd[63:0])              //|> w
  ,.dat1_fifo3_rd_pvld             (dat1_fifo3_rd_pvld)                  //|> w
  ,.wdma_done                      (wdma_done)                           //|< r
  ,.op_load                        (op_load)                             //|< w
  );
// DATA FIFO: READ SIDE
always @(
  reg_lenb
  or dat0_fifo0_rd_pvld
  or dat0_fifo1_rd_pvld
  or dat0_fifo2_rd_pvld
  or dat0_fifo3_rd_pvld
  ) begin
   case (reg_lenb)
    2'd0: dat0_fifo_rd_pvld = dat0_fifo0_rd_pvld;
    2'd1: dat0_fifo_rd_pvld = dat0_fifo1_rd_pvld;
    2'd2: dat0_fifo_rd_pvld = dat0_fifo2_rd_pvld;
    2'd3: dat0_fifo_rd_pvld = dat0_fifo3_rd_pvld;
   //VCS coverage off
   default : begin 
               dat0_fifo_rd_pvld = {1{`x_or_0}};
             end  
   //VCS coverage on
   endcase
end
always @(
  reg_lenb
  or dat1_fifo0_rd_pvld
  or dat1_fifo1_rd_pvld
  or dat1_fifo2_rd_pvld
  or dat1_fifo3_rd_pvld
  ) begin
   case (reg_lenb)
    2'd0: dat1_fifo_rd_pvld = dat1_fifo0_rd_pvld;
    2'd1: dat1_fifo_rd_pvld = dat1_fifo1_rd_pvld;
    2'd2: dat1_fifo_rd_pvld = dat1_fifo2_rd_pvld;
    2'd3: dat1_fifo_rd_pvld = dat1_fifo3_rd_pvld;
   //VCS coverage off
   default : begin 
               dat1_fifo_rd_pvld = {1{`x_or_0}};
             end  
   //VCS coverage on
   endcase
end
assign dat0_fifo0_rd_prdy = dat_rdy & dat_fifo_rd_last_pvld;
assign dat1_fifo0_rd_prdy = (is_size_odd & is_last_beat)? 1'b0 : dat_rdy & dat_fifo_rd_last_pvld;
assign dat0_fifo1_rd_prdy = dat_rdy & dat_fifo_rd_last_pvld;
assign dat1_fifo1_rd_prdy = (is_size_odd & is_last_beat)? 1'b0 : dat_rdy & dat_fifo_rd_last_pvld;
assign dat0_fifo2_rd_prdy = dat_rdy & dat_fifo_rd_last_pvld;
assign dat1_fifo2_rd_prdy = (is_size_odd & is_last_beat)? 1'b0 : dat_rdy & dat_fifo_rd_last_pvld;
assign dat0_fifo3_rd_prdy = dat_rdy & dat_fifo_rd_last_pvld;
assign dat1_fifo3_rd_prdy = (is_size_odd & is_last_beat)? 1'b0 : dat_rdy & dat_fifo_rd_last_pvld;

assign dat_fifo_rd_last_pvld = (is_size_odd & is_last_beat) ? dat0_fifo_rd_pvld : dat1_fifo_rd_pvld;

assign dat0_data= {dat0_fifo3_rd_pd, dat0_fifo2_rd_pd, dat0_fifo1_rd_pd, dat0_fifo0_rd_pd};
assign dat1_data= {dat1_fifo3_rd_pd, dat1_fifo2_rd_pd, dat1_fifo1_rd_pd, dat1_fifo0_rd_pd};
assign dat_data = {dat1_data,dat0_data};

//==============
// output NaN counter
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    fp16_en <= 1'b0;
  end else begin
  fp16_en <= reg2dp_input_data== 2'h2;
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
//assign nan_num_in_dat0_0[2:0] = (dat0_is_nan_0[0] + dat0_is_nan_0[1]) + (dat0_is_nan_0[2] + dat0_is_nan_0[3]);
//assign nan_num_in_dat0_1[2:0] = (dat0_is_nan_1[0] + dat0_is_nan_1[1]) + (dat0_is_nan_1[2] + dat0_is_nan_1[3]);
//assign nan_num_in_dat0_2[2:0] = (dat0_is_nan_2[0] + dat0_is_nan_2[1]) + (dat0_is_nan_2[2] + dat0_is_nan_2[3]);
//assign nan_num_in_dat0_3[2:0] = (dat0_is_nan_3[0] + dat0_is_nan_3[1]) + (dat0_is_nan_3[2] + dat0_is_nan_3[3]);
//assign nan_num_in_dat1_0[2:0] = (dat1_is_nan_0[0] + dat1_is_nan_0[1]) + (dat1_is_nan_0[2] + dat1_is_nan_0[3]);
//assign nan_num_in_dat1_1[2:0] = (dat1_is_nan_1[0] + dat1_is_nan_1[1]) + (dat1_is_nan_1[2] + dat1_is_nan_1[3]);
//assign nan_num_in_dat1_2[2:0] = (dat1_is_nan_2[0] + dat1_is_nan_2[1]) + (dat1_is_nan_2[2] + dat1_is_nan_2[3]);
//assign nan_num_in_dat1_3[2:0] = (dat1_is_nan_3[0] + dat1_is_nan_3[1]) + (dat1_is_nan_3[2] + dat1_is_nan_3[3]);

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
  nv_assert_never #(0,0,"PDP WDMA: nan counter no overflow is allowed")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, mon_nan_in_count); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//==============
// Instance CMD
//==============
NV_NVDLA_PDP_WDMA_cmd u_cmd (
   .reg2dp_cube_out_channel        (reg2dp_cube_out_channel[12:0])       //|< i
  ,.reg2dp_cube_out_height         (reg2dp_cube_out_height[12:0])        //|< i
  ,.reg2dp_cube_out_width          (reg2dp_cube_out_width[12:0])         //|< i
  ,.reg2dp_dst_base_addr_high      (reg2dp_dst_base_addr_high[31:0])     //|< i
  ,.reg2dp_dst_base_addr_low       (reg2dp_dst_base_addr_low[26:0])      //|< i
  ,.reg2dp_dst_line_stride         (reg2dp_dst_line_stride[26:0])        //|< i
  ,.reg2dp_dst_surface_stride      (reg2dp_dst_surface_stride[26:0])     //|< i
  ,.reg2dp_input_data              (reg2dp_input_data[1:0])              //|< i
  ,.reg2dp_partial_width_out_first (reg2dp_partial_width_out_first[9:0]) //|< i
  ,.reg2dp_partial_width_out_last  (reg2dp_partial_width_out_last[9:0])  //|< i
  ,.reg2dp_partial_width_out_mid   (reg2dp_partial_width_out_mid[9:0])   //|< i
  ,.reg2dp_split_num               (reg2dp_split_num[7:0])               //|< i
  ,.cmd_fifo_rd_prdy               (cmd_fifo_rd_prdy)                    //|< w
  ,.cmd_fifo_rd_pd                 (cmd_fifo_rd_pd[79:0])                //|> w
  ,.cmd_fifo_rd_pvld               (cmd_fifo_rd_pvld)                    //|> w
  ,.nvdla_core_clk                 (nvdla_core_clk)                      //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                     //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])                 //|< i
  ,.op_load                        (op_load)                             //|< w
  );
// CMD FIFO: Read side
assign cmd_fifo_rd_prdy = cmd_en & dma_wr_req_rdy;

// Unpack cmd & data together

// PKT_UNPACK_WIRE( pdp_wdma_cmd , cmd_fifo_rd_ , cmd_fifo_rd_pd )
assign       cmd_fifo_rd_addr[63:0] =    cmd_fifo_rd_pd[63:0];
assign       cmd_fifo_rd_size[12:0] =    cmd_fifo_rd_pd[76:64];
assign       cmd_fifo_rd_lenb[1:0] =    cmd_fifo_rd_pd[78:77];
assign        cmd_fifo_rd_cube_end  =    cmd_fifo_rd_pd[79];
// addr/size/lenb/end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg_lenb <= {2{1'b0}};
  end else begin
  if ((dma_wr_cmd_accept) == 1'b1) begin
    reg_lenb <= cmd_fifo_rd_lenb;
  // VCS coverage off
  end else if ((dma_wr_cmd_accept) == 1'b0) begin
  end else begin
    reg_lenb <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dma_wr_cmd_accept))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    reg_size <= {13{1'b0}};
  end else begin
  if ((dma_wr_cmd_accept) == 1'b1) begin
    reg_size <= cmd_fifo_rd_size;
  // VCS coverage off
  end else if ((dma_wr_cmd_accept) == 1'b0) begin
  end else begin
    reg_size <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dma_wr_cmd_accept))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    reg_cube_last <= 1'b0;
  end else begin
  if ((dma_wr_cmd_accept) == 1'b1) begin
    reg_cube_last <= cmd_fifo_rd_cube_end;
  // VCS coverage off
  end else if ((dma_wr_cmd_accept) == 1'b0) begin
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dma_wr_cmd_accept))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign is_size_odd = (reg_size[0]==0);

//==============
// BLOCK Operation
//==============
//assign is_addr_32byte_aligned = (base_addr_c[5]==1);
//assign pos_w = is_addr_32byte_aligned ^ is_pos_w_even;

assign dma_wr_cmd_vld = cmd_en & cmd_fifo_rd_pvld;
assign dma_wr_cmd_accept = dma_wr_cmd_vld & dma_wr_req_rdy;

assign dma_wr_dat_vld   = dat_en & dat_fifo_rd_last_pvld;
assign dat_rdy          = dat_en & dma_wr_req_rdy;
assign dat_accept = dma_wr_dat_vld & dma_wr_req_rdy;

// count_w and tran_cnt is used to index 8B in each 8(B)x8(w)x4(c) block, (w may be < 8 if is_first_w or is_last_w)
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_w <= {13{1'b0}};
  end else begin
    if (dma_wr_cmd_accept) begin
        count_w <= 0;
    end else if (dat_accept) begin
        count_w <= count_w + 2;
    end
  end
end
assign is_last_beat = (count_w==reg_size || count_w==reg_size-1);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_en <= 1'b1;
    dat_en <= 1'b0;
  end else begin
    if (is_last_beat & dat_accept) begin
        cmd_en <= 1'b1;
        dat_en <= 1'b0;
    end else if (dma_wr_cmd_accept) begin
        cmd_en <= 1'b0;
        dat_en <= 1'b1;
    end
  end
end

//==============
// DMA REQ: Size
//==============
// packet: cmd
//assign dma_wr_cmd_vld  = cmd_vld;
assign dma_wr_cmd_addr = cmd_fifo_rd_addr;
assign dma_wr_cmd_size = {10'b0, cmd_fifo_rd_size};
assign dma_wr_cmd_require_ack   = cmd_fifo_rd_cube_end;

// PKT_PACK_WIRE( dma_write_cmd ,  dma_wr_cmd_ ,  dma_wr_cmd_pd )
assign       dma_wr_cmd_pd[63:0] =     dma_wr_cmd_addr[63:0];
assign       dma_wr_cmd_pd[76:64] =     dma_wr_cmd_size[12:0];
assign       dma_wr_cmd_pd[77] =     dma_wr_cmd_require_ack ;
// packet: data
assign dma_wr_dat_data = dat_data;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_fifo_rd_size_use <= {13{1'b0}};
  end else begin
  if ((cmd_fifo_rd_pvld & cmd_fifo_rd_prdy) == 1'b1) begin
    cmd_fifo_rd_size_use <= cmd_fifo_rd_size[12:0];
  // VCS coverage off
  end else if ((cmd_fifo_rd_pvld & cmd_fifo_rd_prdy) == 1'b0) begin
  end else begin
    cmd_fifo_rd_size_use <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cmd_fifo_rd_pvld & cmd_fifo_rd_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dma_wr_dat_mask = (cmd_fifo_rd_size_use[0]==0 && is_last_beat) ? 2'b01 : 2'b11;

// PKT_PACK_WIRE( dma_write_data ,  dma_wr_dat_ ,  dma_wr_dat_pd )
assign       dma_wr_dat_pd[511:0] =     dma_wr_dat_data[511:0];
assign       dma_wr_dat_pd[513:512] =     dma_wr_dat_mask[1:0];

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
// reading stall counter before DMA_if
//==============
assign cnt_inc = 1'b1;
assign cnt_clr = op_done;
assign cnt_cen = (reg2dp_dma_en == 1'h1 ) & (dma_wr_req_vld & (~dma_wr_req_rdy));



    assign pdp_wr_stall_count_dec = 1'b0;

    // stl adv logic

    always @(
      cnt_inc
      or pdp_wr_stall_count_dec
      ) begin
      stl_adv = cnt_inc ^ pdp_wr_stall_count_dec;
    end
        
    // stl cnt logic
    always @(
      stl_cnt_cur
      or cnt_inc
      or pdp_wr_stall_count_dec
      or stl_adv
      or cnt_clr
      ) begin
      // VCS sop_coverage_off start
      stl_cnt_ext[33:0] = {1'b0, 1'b0, stl_cnt_cur};
      stl_cnt_inc[33:0] = stl_cnt_cur + 1'b1; // spyglass disable W164b
      stl_cnt_dec[33:0] = stl_cnt_cur - 1'b1; // spyglass disable W164b
      stl_cnt_mod[33:0] = (cnt_inc && !pdp_wr_stall_count_dec)? stl_cnt_inc : (!cnt_inc && pdp_wr_stall_count_dec)? stl_cnt_dec : stl_cnt_ext;
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
      pdp_wr_stall_count[31:0] = stl_cnt_cur[31:0];
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cnt_clr))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dp2reg_d0_perf_write_stall <= pdp_wr_stall_count[31:0];
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cnt_clr & (~layer_flag)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dp2reg_d1_perf_write_stall <= pdp_wr_stall_count[31:0];
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cnt_clr &   layer_flag ))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
NV_NVDLA_PDP_WDMA_pipe_p2 pipe_p2 (
   .nvdla_core_clk_orig            (nvdla_core_clk_orig)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                     //|< i
  ,.dma_wr_req_pd                  (dma_wr_req_pd[514:0])                //|< r
  ,.mc_dma_wr_req_vld              (mc_dma_wr_req_vld)                   //|< w
  ,.mc_int_wr_req_ready            (mc_int_wr_req_ready)                 //|< w
  ,.mc_dma_wr_req_rdy              (mc_dma_wr_req_rdy)                   //|> w
  ,.mc_int_wr_req_pd               (mc_int_wr_req_pd[514:0])             //|> w
  ,.mc_int_wr_req_valid            (mc_int_wr_req_valid)                 //|> w
  );
NV_NVDLA_PDP_WDMA_pipe_p3 pipe_p3 (
   .nvdla_core_clk_orig            (nvdla_core_clk_orig)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                     //|< i
  ,.cv_dma_wr_req_vld              (cv_dma_wr_req_vld)                   //|< w
  ,.cv_int_wr_req_ready            (cv_int_wr_req_ready)                 //|< w
  ,.dma_wr_req_pd                  (dma_wr_req_pd[514:0])                //|< r
  ,.cv_dma_wr_req_rdy              (cv_dma_wr_req_rdy)                   //|> w
  ,.cv_int_wr_req_pd               (cv_int_wr_req_pd[514:0])             //|> w
  ,.cv_int_wr_req_valid            (cv_int_wr_req_valid)                 //|> w
  );

assign mc_int_wr_req_valid_d0 = mc_int_wr_req_valid;
assign mc_int_wr_req_ready = mc_int_wr_req_ready_d0;
assign mc_int_wr_req_pd_d0[514:0] = mc_int_wr_req_pd[514:0];
NV_NVDLA_PDP_WDMA_pipe_p4 pipe_p4 (
   .nvdla_core_clk_orig            (nvdla_core_clk_orig)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                     //|< i
  ,.mc_int_wr_req_pd_d0            (mc_int_wr_req_pd_d0[514:0])          //|< w
  ,.mc_int_wr_req_ready_d1         (mc_int_wr_req_ready_d1)              //|< w
  ,.mc_int_wr_req_valid_d0         (mc_int_wr_req_valid_d0)              //|< w
  ,.mc_int_wr_req_pd_d1            (mc_int_wr_req_pd_d1[514:0])          //|> w
  ,.mc_int_wr_req_ready_d0         (mc_int_wr_req_ready_d0)              //|> w
  ,.mc_int_wr_req_valid_d1         (mc_int_wr_req_valid_d1)              //|> w
  );
assign pdp2mcif_wr_req_valid = mc_int_wr_req_valid_d1;
assign mc_int_wr_req_ready_d1 = pdp2mcif_wr_req_ready;
assign pdp2mcif_wr_req_pd[514:0] = mc_int_wr_req_pd_d1[514:0];


assign cv_int_wr_req_valid_d0 = cv_int_wr_req_valid;
assign cv_int_wr_req_ready = cv_int_wr_req_ready_d0;
assign cv_int_wr_req_pd_d0[514:0] = cv_int_wr_req_pd[514:0];
NV_NVDLA_PDP_WDMA_pipe_p5 pipe_p5 (
   .nvdla_core_clk_orig            (nvdla_core_clk_orig)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                     //|< i
  ,.cv_int_wr_req_pd_d0            (cv_int_wr_req_pd_d0[514:0])          //|< w
  ,.cv_int_wr_req_ready_d1         (cv_int_wr_req_ready_d1)              //|< w
  ,.cv_int_wr_req_valid_d0         (cv_int_wr_req_valid_d0)              //|< w
  ,.cv_int_wr_req_pd_d1            (cv_int_wr_req_pd_d1[514:0])          //|> w
  ,.cv_int_wr_req_ready_d0         (cv_int_wr_req_ready_d0)              //|> w
  ,.cv_int_wr_req_valid_d1         (cv_int_wr_req_valid_d1)              //|> w
  );
assign pdp2cvif_wr_req_valid = cv_int_wr_req_valid_d1;
assign cv_int_wr_req_ready_d1 = pdp2cvif_wr_req_ready;
assign pdp2cvif_wr_req_pd[514:0] = cv_int_wr_req_pd_d1[514:0];

// wr Channel: Response

always @(posedge nvdla_core_clk_orig) begin
  mcif2pdp_wr_rsp_complete_d1 <= mcif2pdp_wr_rsp_complete;
end
assign mc_int_wr_rsp_complete = mcif2pdp_wr_rsp_complete_d1;


always @(posedge nvdla_core_clk_orig) begin
  cvif2pdp_wr_rsp_complete_d1 <= cvif2pdp_wr_rsp_complete;
end
assign cv_int_wr_rsp_complete = cvif2pdp_wr_rsp_complete_d1;

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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk_orig, `ASSERT_RESET, 1'd1,  (^(ack_raw_rdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"dmaif bot never push back")      zzz_assert_never_12x (nvdla_core_clk_orig, `ASSERT_RESET, ack_raw_vld & !ack_raw_rdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk_orig, `ASSERT_RESET, 1'd1,  (^(ack_bot_vld & ack_bot_rdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk_orig, `ASSERT_RESET, 1'd1,  (^(ack_bot_rdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"no release both together")      zzz_assert_never_15x (nvdla_core_clk_orig, `ASSERT_RESET, mc_releasing & cv_releasing); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"no mc resp back and pending together")      zzz_assert_never_16x (nvdla_core_clk_orig, `ASSERT_RESET, mc_pending & mc_dma_wr_rsp_complete); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"no cv resp back and pending together")      zzz_assert_never_17x (nvdla_core_clk_orig, `ASSERT_RESET, cv_pending & cv_dma_wr_rsp_complete); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"no ack_top_vld when resp from cv")      zzz_assert_never_18x (nvdla_core_clk_orig, `ASSERT_RESET, (cv_pending | cv_dma_wr_rsp_complete) & !ack_top_vld); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"no ack_top_vld when resp from mc")      zzz_assert_never_19x (nvdla_core_clk_orig, `ASSERT_RESET, (mc_pending | mc_dma_wr_rsp_complete) & !ack_top_vld); // spyglass disable W504 SelfDeterminedExpr-ML 
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

    property dmaif_pdp__two_completes__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk_orig)
        mc_dma_wr_rsp_complete & cv_dma_wr_rsp_complete;
    endproperty
    // Cover 0 : "mc_dma_wr_rsp_complete & cv_dma_wr_rsp_complete"
    FUNCPOINT_dmaif_pdp__two_completes__0_COV : cover property (dmaif_pdp__two_completes__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property dmaif_pdp__one_pending_complete_with_mc__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk_orig)
        cv_pending & mc_dma_wr_rsp_complete;
    endproperty
    // Cover 1 : "cv_pending & mc_dma_wr_rsp_complete"
    FUNCPOINT_dmaif_pdp__one_pending_complete_with_mc__1_COV : cover property (dmaif_pdp__one_pending_complete_with_mc__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property dmaif_pdp__one_pending_complete_with_cv__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk_orig)
        mc_pending & cv_dma_wr_rsp_complete;
    endproperty
    // Cover 2 : "mc_pending & cv_dma_wr_rsp_complete"
    FUNCPOINT_dmaif_pdp__one_pending_complete_with_cv__2_COV : cover property (dmaif_pdp__one_pending_complete_with_cv__2_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property dmaif_pdp__sequence_complete_cv_one_cycle_after_mc_in_order__3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk_orig)
        cv_int_wr_rsp_complete & mc_dma_wr_rsp_complete & ack_top_id==1'b1;
    endproperty
    // Cover 3 : "cv_int_wr_rsp_complete & mc_dma_wr_rsp_complete & ack_top_id==1'b1"
    FUNCPOINT_dmaif_pdp__sequence_complete_cv_one_cycle_after_mc_in_order__3_COV : cover property (dmaif_pdp__sequence_complete_cv_one_cycle_after_mc_in_order__3_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property dmaif_pdp__sequence_complete_cv_one_cycle_after_mc_out_of_order__4_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk_orig)
        cv_int_wr_rsp_complete & mc_dma_wr_rsp_complete & ack_top_id==1'b0;
    endproperty
    // Cover 4 : "cv_int_wr_rsp_complete & mc_dma_wr_rsp_complete & ack_top_id==1'b0"
    FUNCPOINT_dmaif_pdp__sequence_complete_cv_one_cycle_after_mc_out_of_order__4_COV : cover property (dmaif_pdp__sequence_complete_cv_one_cycle_after_mc_out_of_order__4_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property dmaif_pdp__sequence_complete_mc_one_cycle_after_cv_in_order__5_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk_orig)
        mc_int_wr_rsp_complete & cv_dma_wr_rsp_complete & ack_top_id==1'b0;
    endproperty
    // Cover 5 : "mc_int_wr_rsp_complete & cv_dma_wr_rsp_complete & ack_top_id==1'b0"
    FUNCPOINT_dmaif_pdp__sequence_complete_mc_one_cycle_after_cv_in_order__5_COV : cover property (dmaif_pdp__sequence_complete_mc_one_cycle_after_cv_in_order__5_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property dmaif_pdp__sequence_complete_mc_one_cycle_after_cv_out_of_order__6_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk_orig)
        mc_int_wr_rsp_complete & cv_dma_wr_rsp_complete & ack_top_id==1'b1;
    endproperty
    // Cover 6 : "mc_int_wr_rsp_complete & cv_dma_wr_rsp_complete & ack_top_id==1'b1"
    FUNCPOINT_dmaif_pdp__sequence_complete_mc_one_cycle_after_cv_out_of_order__6_COV : cover property (dmaif_pdp__sequence_complete_mc_one_cycle_after_cv_out_of_order__6_cov);

  `endif
`endif
//VCS coverage on


//logic for wdma writing done, and has accepted dma_wr_rsp_complete, but RDMA still not reading done
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wdma_done_d1 <= 1'b0;
  end else begin
  wdma_done_d1 <= wdma_done;
  end
end
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    intp_waiting_rdma <= 1'b0;
  end else begin
    if(dma_wr_rsp_complete & waiting_rdma)
        intp_waiting_rdma <= 1'b1;
    else if(wdma_done_d1)
        intp_waiting_rdma <= 1'b0;
  end
end
//

NV_NVDLA_PDP_WDMA_intr_fifo u_intr_fifo (
   .nvdla_core_clk                 (nvdla_core_clk_orig)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                     //|< i
  ,.intr_fifo_wr_pvld              (intr_fifo_wr_pvld)                   //|< w
  ,.intr_fifo_wr_pd                (intr_fifo_wr_pd)                     //|< w
  ,.intr_fifo_rd_prdy              (intr_fifo_rd_prdy)                   //|< w
  ,.intr_fifo_rd_pvld              (intr_fifo_rd_pvld)                   //|> w
  ,.intr_fifo_rd_pd                (intr_fifo_rd_pd)                     //|> w
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])                 //|< i
  );
assign intr_fifo_wr_pd    = reg2dp_interrupt_ptr;
assign intr_fifo_wr_pvld  = wdma_done;
assign intr_fifo_rd_prdy  = dma_wr_rsp_complete & (~waiting_rdma) || (intp_waiting_rdma & wdma_done_d1);

always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pdp2glb_done_intr_pd[0] <= 1'b0;
  end else begin
  pdp2glb_done_intr_pd[0] <= intr_fifo_rd_pvld & intr_fifo_rd_prdy & (intr_fifo_rd_pd==0);
  end
end
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pdp2glb_done_intr_pd[1] <= 1'b0;
  end else begin
  pdp2glb_done_intr_pd[1] <= intr_fifo_rd_pvld & intr_fifo_rd_prdy & (intr_fifo_rd_pd==1);
  end
end

////==============
////OBS signals
////==============
//assign obs_bus_pdp_core_proc_en = op_prcess;

//==============
//function polint
//==============
//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_WDMA__dma_writing_stall__7_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        dma_wr_req_vld & (~dma_wr_req_rdy);
    endproperty
    // Cover 7 : "dma_wr_req_vld & (~dma_wr_req_rdy)"
    FUNCPOINT_PDP_WDMA__dma_writing_stall__7_COV : cover property (PDP_WDMA__dma_writing_stall__7_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property PDP_WDMA__dp2wdma_stall__8_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        pdp_dp2wdma_valid & (~pdp_dp2wdma_ready);
    endproperty
    // Cover 8 : "pdp_dp2wdma_valid & (~pdp_dp2wdma_ready)"
    FUNCPOINT_PDP_WDMA__dp2wdma_stall__8_COV : cover property (PDP_WDMA__dp2wdma_stall__8_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_PDP_wdma



// **************************************************************************************************************
// Generated by ::pipe -m -bc -is mc_int_wr_req_pd (mc_int_wr_req_valid,mc_int_wr_req_ready) <= dma_wr_req_pd[514:0] (mc_dma_wr_req_vld,mc_dma_wr_req_rdy)
// **************************************************************************************************************
module NV_NVDLA_PDP_WDMA_pipe_p2 (
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
  if      ( $value$plusargs( "NV_NVDLA_PDP_wdma_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_PDP_wdma_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_PDP_wdma_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_PDP_wdma_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_PDP_wdma_pipe_stall_probability" ) ) p2_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_PDP_wdma_pipe_stall_cycles_min"  ) ) p2_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_PDP_wdma_pipe_stall_cycles_max"  ) ) p2_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk_orig, `ASSERT_RESET, nvdla_core_rstn, (mc_int_wr_req_valid^mc_int_wr_req_ready^mc_dma_wr_req_vld^mc_dma_wr_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_21x (nvdla_core_clk_orig, `ASSERT_RESET, (mc_dma_wr_req_vld && !mc_dma_wr_req_rdy), (mc_dma_wr_req_vld), (mc_dma_wr_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_PDP_WDMA_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is cv_int_wr_req_pd (cv_int_wr_req_valid,cv_int_wr_req_ready) <= dma_wr_req_pd[514:0] (cv_dma_wr_req_vld,cv_dma_wr_req_rdy)
// **************************************************************************************************************
module NV_NVDLA_PDP_WDMA_pipe_p3 (
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
  if      ( $value$plusargs( "NV_NVDLA_PDP_wdma_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_PDP_wdma_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_PDP_wdma_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_PDP_wdma_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_PDP_wdma_pipe_stall_probability" ) ) p3_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_PDP_wdma_pipe_stall_cycles_min"  ) ) p3_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_PDP_wdma_pipe_stall_cycles_max"  ) ) p3_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_22x (nvdla_core_clk_orig, `ASSERT_RESET, nvdla_core_rstn, (cv_int_wr_req_valid^cv_int_wr_req_ready^cv_dma_wr_req_vld^cv_dma_wr_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_23x (nvdla_core_clk_orig, `ASSERT_RESET, (cv_dma_wr_req_vld && !cv_dma_wr_req_rdy), (cv_dma_wr_req_vld), (cv_dma_wr_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_PDP_WDMA_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is -rand none mc_int_wr_req_pd_d1[514:0] (mc_int_wr_req_valid_d1,mc_int_wr_req_ready_d1) <= mc_int_wr_req_pd_d0[514:0] (mc_int_wr_req_valid_d0,mc_int_wr_req_ready_d0)
// **************************************************************************************************************
module NV_NVDLA_PDP_WDMA_pipe_p4 (
   nvdla_core_clk_orig
  ,nvdla_core_rstn
  ,mc_int_wr_req_pd_d0
  ,mc_int_wr_req_ready_d1
  ,mc_int_wr_req_valid_d0
  ,mc_int_wr_req_pd_d1
  ,mc_int_wr_req_ready_d0
  ,mc_int_wr_req_valid_d1
  );
input          nvdla_core_clk_orig;
input          nvdla_core_rstn;
input  [514:0] mc_int_wr_req_pd_d0;
input          mc_int_wr_req_ready_d1;
input          mc_int_wr_req_valid_d0;
output [514:0] mc_int_wr_req_pd_d1;
output         mc_int_wr_req_ready_d0;
output         mc_int_wr_req_valid_d1;
reg    [514:0] mc_int_wr_req_pd_d1;
reg            mc_int_wr_req_ready_d0;
reg            mc_int_wr_req_valid_d1;
reg    [514:0] p4_pipe_data;
reg            p4_pipe_ready;
reg            p4_pipe_ready_bc;
reg            p4_pipe_valid;
reg            p4_skid_catch;
reg    [514:0] p4_skid_data;
reg    [514:0] p4_skid_pipe_data;
reg            p4_skid_pipe_ready;
reg            p4_skid_pipe_valid;
reg            p4_skid_ready;
reg            p4_skid_ready_flop;
reg            p4_skid_valid;
//## pipe (4) skid buffer
always @(
  mc_int_wr_req_valid_d0
  or p4_skid_ready_flop
  or p4_skid_pipe_ready
  or p4_skid_valid
  ) begin
  p4_skid_catch = mc_int_wr_req_valid_d0 && p4_skid_ready_flop && !p4_skid_pipe_ready;  
  p4_skid_ready = (p4_skid_valid)? p4_skid_pipe_ready : !p4_skid_catch;
end
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_skid_valid <= 1'b0;
    p4_skid_ready_flop <= 1'b1;
    mc_int_wr_req_ready_d0 <= 1'b1;
  end else begin
  p4_skid_valid <= (p4_skid_valid)? !p4_skid_pipe_ready : p4_skid_catch;
  p4_skid_ready_flop <= p4_skid_ready;
  mc_int_wr_req_ready_d0 <= p4_skid_ready;
  end
end
always @(posedge nvdla_core_clk_orig) begin
  // VCS sop_coverage_off start
  p4_skid_data <= (p4_skid_catch)? mc_int_wr_req_pd_d0[514:0] : p4_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p4_skid_ready_flop
  or mc_int_wr_req_valid_d0
  or p4_skid_valid
  or mc_int_wr_req_pd_d0
  or p4_skid_data
  ) begin
  p4_skid_pipe_valid = (p4_skid_ready_flop)? mc_int_wr_req_valid_d0 : p4_skid_valid; 
  // VCS sop_coverage_off start
  p4_skid_pipe_data = (p4_skid_ready_flop)? mc_int_wr_req_pd_d0[514:0] : p4_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (4) valid-ready-bubble-collapse
always @(
  p4_pipe_ready
  or p4_pipe_valid
  ) begin
  p4_pipe_ready_bc = p4_pipe_ready || !p4_pipe_valid;
end
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_pipe_valid <= 1'b0;
  end else begin
  p4_pipe_valid <= (p4_pipe_ready_bc)? p4_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk_orig) begin
  // VCS sop_coverage_off start
  p4_pipe_data <= (p4_pipe_ready_bc && p4_skid_pipe_valid)? p4_skid_pipe_data : p4_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p4_pipe_ready_bc
  ) begin
  p4_skid_pipe_ready = p4_pipe_ready_bc;
end
//## pipe (4) output
always @(
  p4_pipe_valid
  or mc_int_wr_req_ready_d1
  or p4_pipe_data
  ) begin
  mc_int_wr_req_valid_d1 = p4_pipe_valid;
  p4_pipe_ready = mc_int_wr_req_ready_d1;
  mc_int_wr_req_pd_d1[514:0] = p4_pipe_data;
end
//## pipe (4) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p4_assert_clk = nvdla_core_clk_orig;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_24x (nvdla_core_clk_orig, `ASSERT_RESET, nvdla_core_rstn, (mc_int_wr_req_valid_d1^mc_int_wr_req_ready_d1^mc_int_wr_req_valid_d0^mc_int_wr_req_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_25x (nvdla_core_clk_orig, `ASSERT_RESET, (mc_int_wr_req_valid_d0 && !mc_int_wr_req_ready_d0), (mc_int_wr_req_valid_d0), (mc_int_wr_req_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_PDP_WDMA_pipe_p4




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is -rand none cv_int_wr_req_pd_d1[514:0] (cv_int_wr_req_valid_d1,cv_int_wr_req_ready_d1) <= cv_int_wr_req_pd_d0[514:0] (cv_int_wr_req_valid_d0,cv_int_wr_req_ready_d0)
// **************************************************************************************************************
module NV_NVDLA_PDP_WDMA_pipe_p5 (
   nvdla_core_clk_orig
  ,nvdla_core_rstn
  ,cv_int_wr_req_pd_d0
  ,cv_int_wr_req_ready_d1
  ,cv_int_wr_req_valid_d0
  ,cv_int_wr_req_pd_d1
  ,cv_int_wr_req_ready_d0
  ,cv_int_wr_req_valid_d1
  );
input          nvdla_core_clk_orig;
input          nvdla_core_rstn;
input  [514:0] cv_int_wr_req_pd_d0;
input          cv_int_wr_req_ready_d1;
input          cv_int_wr_req_valid_d0;
output [514:0] cv_int_wr_req_pd_d1;
output         cv_int_wr_req_ready_d0;
output         cv_int_wr_req_valid_d1;
reg    [514:0] cv_int_wr_req_pd_d1;
reg            cv_int_wr_req_ready_d0;
reg            cv_int_wr_req_valid_d1;
reg    [514:0] p5_pipe_data;
reg            p5_pipe_ready;
reg            p5_pipe_ready_bc;
reg            p5_pipe_valid;
reg            p5_skid_catch;
reg    [514:0] p5_skid_data;
reg    [514:0] p5_skid_pipe_data;
reg            p5_skid_pipe_ready;
reg            p5_skid_pipe_valid;
reg            p5_skid_ready;
reg            p5_skid_ready_flop;
reg            p5_skid_valid;
//## pipe (5) skid buffer
always @(
  cv_int_wr_req_valid_d0
  or p5_skid_ready_flop
  or p5_skid_pipe_ready
  or p5_skid_valid
  ) begin
  p5_skid_catch = cv_int_wr_req_valid_d0 && p5_skid_ready_flop && !p5_skid_pipe_ready;  
  p5_skid_ready = (p5_skid_valid)? p5_skid_pipe_ready : !p5_skid_catch;
end
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p5_skid_valid <= 1'b0;
    p5_skid_ready_flop <= 1'b1;
    cv_int_wr_req_ready_d0 <= 1'b1;
  end else begin
  p5_skid_valid <= (p5_skid_valid)? !p5_skid_pipe_ready : p5_skid_catch;
  p5_skid_ready_flop <= p5_skid_ready;
  cv_int_wr_req_ready_d0 <= p5_skid_ready;
  end
end
always @(posedge nvdla_core_clk_orig) begin
  // VCS sop_coverage_off start
  p5_skid_data <= (p5_skid_catch)? cv_int_wr_req_pd_d0[514:0] : p5_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p5_skid_ready_flop
  or cv_int_wr_req_valid_d0
  or p5_skid_valid
  or cv_int_wr_req_pd_d0
  or p5_skid_data
  ) begin
  p5_skid_pipe_valid = (p5_skid_ready_flop)? cv_int_wr_req_valid_d0 : p5_skid_valid; 
  // VCS sop_coverage_off start
  p5_skid_pipe_data = (p5_skid_ready_flop)? cv_int_wr_req_pd_d0[514:0] : p5_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (5) valid-ready-bubble-collapse
always @(
  p5_pipe_ready
  or p5_pipe_valid
  ) begin
  p5_pipe_ready_bc = p5_pipe_ready || !p5_pipe_valid;
end
always @(posedge nvdla_core_clk_orig or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p5_pipe_valid <= 1'b0;
  end else begin
  p5_pipe_valid <= (p5_pipe_ready_bc)? p5_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk_orig) begin
  // VCS sop_coverage_off start
  p5_pipe_data <= (p5_pipe_ready_bc && p5_skid_pipe_valid)? p5_skid_pipe_data : p5_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p5_pipe_ready_bc
  ) begin
  p5_skid_pipe_ready = p5_pipe_ready_bc;
end
//## pipe (5) output
always @(
  p5_pipe_valid
  or cv_int_wr_req_ready_d1
  or p5_pipe_data
  ) begin
  cv_int_wr_req_valid_d1 = p5_pipe_valid;
  p5_pipe_ready = cv_int_wr_req_ready_d1;
  cv_int_wr_req_pd_d1[514:0] = p5_pipe_data;
end
//## pipe (5) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p5_assert_clk = nvdla_core_clk_orig;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_26x (nvdla_core_clk_orig, `ASSERT_RESET, nvdla_core_rstn, (cv_int_wr_req_valid_d1^cv_int_wr_req_ready_d1^cv_int_wr_req_valid_d0^cv_int_wr_req_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_27x (nvdla_core_clk_orig, `ASSERT_RESET, (cv_int_wr_req_valid_d0 && !cv_int_wr_req_ready_d0), (cv_int_wr_req_valid_d0), (cv_int_wr_req_ready_d0)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_PDP_WDMA_pipe_p5


//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_PDP_WDMA_intr_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus intr_fifo_wr -rd_pipebus intr_fifo_rd -ram_bypass -d 0 -rd_reg -rd_busy_reg -no_wr_busy -w 1 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_PDP_WDMA_intr_fifo (
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
//   set_boundary_optimization find(design, "NV_NVDLA_PDP_WDMA_intr_fifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_PDP_WDMA_intr_fifo

