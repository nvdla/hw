// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_BDMA_store.v

`include "simulate_x_tick.vh"
module NV_NVDLA_BDMA_store (
   nvdla_core_clk                //|< i
  ,nvdla_core_rstn               //|< i
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,bdma2cvif_wr_req_ready        //|< i
#endif
  ,bdma2mcif_wr_req_ready        //|< i
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cvif2bdma_rd_rsp_pd           //|< i
  ,cvif2bdma_rd_rsp_valid        //|< i
  ,cvif2bdma_wr_rsp_complete     //|< i
#endif
  ,dma_write_stall_count_cen     //|< i
  ,ld2st_rd_pd                   //|< i
  ,ld2st_rd_pvld                 //|< i
  ,mcif2bdma_rd_rsp_pd           //|< i
  ,mcif2bdma_rd_rsp_valid        //|< i
  ,mcif2bdma_wr_rsp_complete     //|< i
  ,pwrbus_ram_pd                 //|< i
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,bdma2cvif_rd_cdt_lat_fifo_pop //|> o
  ,bdma2cvif_wr_req_pd           //|> o
  ,bdma2cvif_wr_req_valid        //|> o
#endif
  ,bdma2mcif_rd_cdt_lat_fifo_pop //|> o
  ,bdma2mcif_wr_req_pd           //|> o
  ,bdma2mcif_wr_req_valid        //|> o
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cvif2bdma_rd_rsp_ready        //|> o
#endif
  ,dma_write_stall_count         //|> o
  ,ld2st_rd_prdy                 //|> o
  ,mcif2bdma_rd_rsp_ready        //|> o
  ,st2csb_grp0_done              //|> o
  ,st2csb_grp1_done              //|> o
  ,st2csb_idle                   //|> o
  ,st2gate_slcg_en               //|> o
  ,st2ld_load_idle               //|> o
  );

//
// NV_NVDLA_BDMA_store_ports.v
//
input  nvdla_core_clk;   /* mcif2bdma_rd_rsp, cvif2bdma_rd_rsp, bdma2mcif_rd_cdt, bdma2cvif_rd_cdt, bdma2mcif_wr_req, bdma2cvif_wr_req, mcif2bdma_wr_rsp, cvif2bdma_wr_rsp, ld2st_rd */
input  nvdla_core_rstn;  /* mcif2bdma_rd_rsp, cvif2bdma_rd_rsp, bdma2mcif_rd_cdt, bdma2cvif_rd_cdt, bdma2mcif_wr_req, bdma2cvif_wr_req, mcif2bdma_wr_rsp, cvif2bdma_wr_rsp, ld2st_rd */

input          mcif2bdma_rd_rsp_valid;  /* data valid */
output         mcif2bdma_rd_rsp_ready;  /* data return handshake */
input  [513:0] mcif2bdma_rd_rsp_pd;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
input          cvif2bdma_rd_rsp_valid;  /* data valid */
output         cvif2bdma_rd_rsp_ready;  /* data return handshake */
input  [513:0] cvif2bdma_rd_rsp_pd;
#endif

output  bdma2mcif_rd_cdt_lat_fifo_pop;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
output  bdma2cvif_rd_cdt_lat_fifo_pop;
#endif

output         bdma2mcif_wr_req_valid;  /* data valid */
input          bdma2mcif_wr_req_ready;  /* data return handshake */
output [514:0] bdma2mcif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
output         bdma2cvif_wr_req_valid;  /* data valid */
input          bdma2cvif_wr_req_ready;  /* data return handshake */
output [514:0] bdma2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */
#endif

input  mcif2bdma_wr_rsp_complete;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
input  cvif2bdma_wr_rsp_complete;
#endif

input          ld2st_rd_pvld;  /* data valid */
output         ld2st_rd_prdy;  /* data return handshake */
input  [160:0] ld2st_rd_pd;

input [31:0] pwrbus_ram_pd;

//&Ports /^obs_bus/;
output         st2ld_load_idle;
output         st2csb_grp0_done;
output         st2csb_grp1_done;
output         st2csb_idle;
output         st2gate_slcg_en;
output [31:0] dma_write_stall_count;
input                dma_write_stall_count_cen;
reg            ack_bot_id;
reg            ack_bot_vld;
reg            ack_top_id;
reg            ack_top_vld;
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
reg            bdma2cvif_rd_cdt_lat_fifo_pop;
#endif
reg            bdma2mcif_rd_cdt_lat_fifo_pop;
reg     [11:0] beat_count;
reg            cmd_en;
reg            cv_dma_wr_rsp_complete;
reg            cv_pending;
reg            dat_en;
reg    [514:0] dma_wr_req_pd;
reg            dma_wr_rsp_complete;
reg     [31:0] dma_write_stall_count;
reg     [63:0] line_addr;
reg     [12:0] line_count;
reg            mc_dma_wr_rsp_complete;
reg            mc_pending;
reg            mon_line_addr_c;
reg            mon_surf_addr_c;
reg            reg_cmd_dst_ram_type;
reg            reg_cmd_interrupt;
reg            reg_cmd_interrupt_ptr;
reg            reg_cmd_src_ram_type;
reg     [12:0] reg_line_repeat_number;
reg     [12:0] reg_line_size;
reg     [26:0] reg_line_stride;
reg     [12:0] reg_surf_repeat_number;
reg     [26:0] reg_surf_stride;
reg            st2gate_slcg_en;
reg            stl_adv;
reg     [31:0] stl_cnt_cur;
reg     [33:0] stl_cnt_dec;
reg     [33:0] stl_cnt_ext;
reg     [33:0] stl_cnt_inc;
reg     [33:0] stl_cnt_mod;
reg     [33:0] stl_cnt_new;
reg     [33:0] stl_cnt_nxt;
reg     [63:0] surf_addr;
reg     [12:0] surf_count;
reg            tran_cmd_valid;
wire           ack_bot_rdy;
wire           ack_raw_id;
wire           ack_raw_rdy;
wire           ack_raw_vld;
wire           ack_top_rdy;
wire    [11:0] beat_size;
wire   [513:0] cv_dma_rd_rsp_pd;
wire           cv_dma_rd_rsp_vld;
wire           cv_dma_wr_req_rdy;
wire           cv_dma_wr_req_vld;
wire   [513:0] cv_int_rd_rsp_pd;
wire           cv_int_rd_rsp_ready;
wire           cv_int_rd_rsp_valid;
wire   [514:0] cv_int_wr_req_pd;
wire   [514:0] cv_int_wr_req_pd_d0;
wire           cv_int_wr_req_ready;
wire           cv_int_wr_req_ready_d0;
wire           cv_int_wr_req_valid;
wire           cv_int_wr_req_valid_d0;
wire           cv_int_wr_rsp_complete;
wire           cv_releasing;
wire           cv_wr_req_rdyi;
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
wire   [513:0] cvif2bdma_rd_rsp_pd_d0;
wire           cvif2bdma_rd_rsp_ready_d0;
wire           cvif2bdma_rd_rsp_valid_d0;
#endif
wire           dma_rd_cdt_lat_fifo_pop;
wire   [513:0] dma_rd_rsp_pd;
wire           dma_rd_rsp_ram_type;
wire           dma_rd_rsp_rdy;
wire           dma_rd_rsp_vld;
wire    [63:0] dma_wr_cmd_addr;
wire    [77:0] dma_wr_cmd_pd;
wire           dma_wr_cmd_rdy;
wire           dma_wr_cmd_require_ack;
wire    [12:0] dma_wr_cmd_size;
wire           dma_wr_cmd_vld;
wire   [513:0] dma_wr_dat_data;
wire     [1:0] dma_wr_dat_mask;
wire   [513:0] dma_wr_dat_pd;
wire           dma_wr_dat_pvld;
wire           dma_wr_dat_rdy;
wire           dma_wr_dat_vld;
wire           dma_wr_req_ram_type;
wire           dma_wr_req_rdy;
wire           dma_wr_req_vld;
wire           dma_write_stall_count_dec;
wire           dma_write_stall_count_inc;
wire           fifo_intr_rd_pd;
wire           fifo_intr_rd_prdy;
wire           fifo_intr_rd_pvld;
wire           fifo_intr_wr_idle;
wire           fifo_intr_wr_pd;
wire           fifo_intr_wr_pvld;
wire           grp0_done;
wire           grp1_done;
wire           is_cube_last;
wire           is_last_beat;
wire           is_surf_last;
wire    [63:0] ld2st_addr;
wire           ld2st_cmd_dst_ram_type;
wire           ld2st_cmd_interrupt;
wire           ld2st_cmd_interrupt_ptr;
wire           ld2st_cmd_src_ram_type;
wire    [12:0] ld2st_line_repeat_number;
wire    [12:0] ld2st_line_size;
wire    [26:0] ld2st_line_stride;
wire           ld2st_rd_accept;
wire    [12:0] ld2st_surf_repeat_number;
wire    [26:0] ld2st_surf_stride;
wire   [513:0] mc_dma_rd_rsp_pd;
wire           mc_dma_rd_rsp_vld;
wire           mc_dma_wr_req_rdy;
wire           mc_dma_wr_req_vld;
wire   [513:0] mc_int_rd_rsp_pd;
wire           mc_int_rd_rsp_ready;
wire           mc_int_rd_rsp_valid;
wire   [514:0] mc_int_wr_req_pd;
wire   [514:0] mc_int_wr_req_pd_d0;
wire           mc_int_wr_req_ready;
wire           mc_int_wr_req_ready_d0;
wire           mc_int_wr_req_valid;
wire           mc_int_wr_req_valid_d0;
wire           mc_int_wr_rsp_complete;
wire           mc_releasing;
wire           mc_wr_req_rdyi;
wire   [513:0] mcif2bdma_rd_rsp_pd_d0;
wire           mcif2bdma_rd_rsp_ready_d0;
wire           mcif2bdma_rd_rsp_valid_d0;
wire           releasing;
wire           require_ack;
wire           st_idle;
wire           tran_cmd_accept;
wire           tran_dat_accept;
wire           wr_req_rdyi;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
//==================================
//===Return DATA from DMA READ RSP CHANNEL
//==================================
assign dma_rd_rsp_ram_type     = reg_cmd_src_ram_type;

// rd Channel: Response

assign mcif2bdma_rd_rsp_valid_d0 = mcif2bdma_rd_rsp_valid;
assign mcif2bdma_rd_rsp_ready = mcif2bdma_rd_rsp_ready_d0;
assign mcif2bdma_rd_rsp_pd_d0[513:0] = mcif2bdma_rd_rsp_pd[513:0];
assign mc_int_rd_rsp_valid = mcif2bdma_rd_rsp_valid_d0;
assign mcif2bdma_rd_rsp_ready_d0 = mc_int_rd_rsp_ready;
assign mc_int_rd_rsp_pd[513:0] = mcif2bdma_rd_rsp_pd_d0[513:0];


#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
assign cvif2bdma_rd_rsp_valid_d0 = cvif2bdma_rd_rsp_valid;
assign cvif2bdma_rd_rsp_ready = cvif2bdma_rd_rsp_ready_d0;
assign cvif2bdma_rd_rsp_pd_d0[513:0] = cvif2bdma_rd_rsp_pd[513:0];
assign cv_int_rd_rsp_valid = cvif2bdma_rd_rsp_valid_d0;
assign cvif2bdma_rd_rsp_ready_d0 = cv_int_rd_rsp_ready;
assign cv_int_rd_rsp_pd[513:0] = cvif2bdma_rd_rsp_pd_d0[513:0];
#endif

NV_NVDLA_BDMA_STORE_pipe_p1 pipe_p1 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.dma_rd_rsp_rdy      (dma_rd_rsp_rdy)          //|< w
  ,.mc_int_rd_rsp_pd    (mc_int_rd_rsp_pd[513:0]) //|< w
  ,.mc_int_rd_rsp_valid (mc_int_rd_rsp_valid)     //|< w
  ,.mc_dma_rd_rsp_pd    (mc_dma_rd_rsp_pd[513:0]) //|> w
  ,.mc_dma_rd_rsp_vld   (mc_dma_rd_rsp_vld)       //|> w
  ,.mc_int_rd_rsp_ready (mc_int_rd_rsp_ready)     //|> w
  );
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
NV_NVDLA_BDMA_STORE_pipe_p2 pipe_p2 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.cv_int_rd_rsp_pd    (cv_int_rd_rsp_pd[513:0]) //|< w
  ,.cv_int_rd_rsp_valid (cv_int_rd_rsp_valid)     //|< w
  ,.dma_rd_rsp_rdy      (dma_rd_rsp_rdy)          //|< w
  ,.cv_dma_rd_rsp_pd    (cv_dma_rd_rsp_pd[513:0]) //|> w
  ,.cv_dma_rd_rsp_vld   (cv_dma_rd_rsp_vld)       //|> w
  ,.cv_int_rd_rsp_ready (cv_int_rd_rsp_ready)     //|> w
  );
assign dma_rd_rsp_vld = mc_dma_rd_rsp_vld | cv_dma_rd_rsp_vld;
assign dma_rd_rsp_pd = ({514{mc_dma_rd_rsp_vld}} & mc_dma_rd_rsp_pd) 
                        | ({514{cv_dma_rd_rsp_vld}} & cv_dma_rd_rsp_pd);
#else 
assign dma_rd_rsp_vld = mc_dma_rd_rsp_vld; 
assign dma_rd_rsp_pd = ({514{mc_dma_rd_rsp_vld}} & mc_dma_rd_rsp_pd); 
#endif


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
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  nv_assert_never #(0,0,"DMAIF: mcif and cvif should never return data both")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, mc_dma_rd_rsp_vld & cv_dma_rd_rsp_vld); // spyglass disable W504 SelfDeterminedExpr-ML 
#else
  nv_assert_never #(0,0,"DMAIF: mcif and cvif should never return data both")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, mc_dma_rd_rsp_vld); // spyglass disable W504 SelfDeterminedExpr-ML 
#endif
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
    bdma2mcif_rd_cdt_lat_fifo_pop <= 1'b0;
  end else begin
  bdma2mcif_rd_cdt_lat_fifo_pop <= dma_rd_cdt_lat_fifo_pop & (dma_rd_rsp_ram_type == 1'b1);
  end
end
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    bdma2cvif_rd_cdt_lat_fifo_pop <= 1'b0;
  end else begin
  bdma2cvif_rd_cdt_lat_fifo_pop <= dma_rd_cdt_lat_fifo_pop & (dma_rd_rsp_ram_type == 1'b0);
  end
end
#endif
//==================================
//===Load Cmd from Context QUEUE
//==================================
// input rename
//   ro = ri || !vo;                 // ready
//   vo <0= (ro)? vi : vo;           // valid
//   do <= (ro && vi)? di : do;      // data
assign ld2st_rd_prdy = (tran_dat_accept & is_last_beat & is_cube_last) || (!tran_cmd_valid);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    tran_cmd_valid <= 1'b0;
  end else begin
  if ((ld2st_rd_prdy) == 1'b1) begin
    tran_cmd_valid <= ld2st_rd_pvld;
  // VCS coverage off
  end else if ((ld2st_rd_prdy) == 1'b0) begin
  end else begin
    tran_cmd_valid <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(ld2st_rd_prdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign ld2st_rd_accept = ld2st_rd_prdy & ld2st_rd_pvld;

// PKT_UNPACK_WIRE( bdma_ld2st , ld2st_ , ld2st_rd_pd )
assign       ld2st_addr[63:0] =    ld2st_rd_pd[63:0];
assign       ld2st_line_size[12:0] =    ld2st_rd_pd[76:64];
assign        ld2st_cmd_src_ram_type  =    ld2st_rd_pd[77];
assign        ld2st_cmd_dst_ram_type  =    ld2st_rd_pd[78];
assign        ld2st_cmd_interrupt  =    ld2st_rd_pd[79];
assign        ld2st_cmd_interrupt_ptr  =    ld2st_rd_pd[80];
assign       ld2st_line_stride[26:0] =    ld2st_rd_pd[107:81];
assign       ld2st_line_repeat_number[12:0] =    ld2st_rd_pd[120:108];
assign       ld2st_surf_stride[26:0] =    ld2st_rd_pd[147:121];
assign       ld2st_surf_repeat_number[12:0] =    ld2st_rd_pd[160:148];
always @(posedge nvdla_core_clk) begin
    if (ld2st_rd_accept) begin
        //reg_addr                <= ld2st_addr;
        reg_line_size           <= ld2st_line_size;
        reg_cmd_src_ram_type    <= ld2st_cmd_src_ram_type;
        reg_cmd_dst_ram_type    <= ld2st_cmd_dst_ram_type;
        reg_cmd_interrupt       <= ld2st_cmd_interrupt;
        reg_cmd_interrupt_ptr   <= ld2st_cmd_interrupt_ptr;
        reg_line_stride         <= ld2st_line_stride;
        reg_line_repeat_number  <= ld2st_line_repeat_number;
        reg_surf_stride         <= ld2st_surf_stride;
        reg_surf_repeat_number  <= ld2st_surf_repeat_number;
    end
end

assign dma_rd_cdt_lat_fifo_pop = dma_wr_dat_pvld & dma_wr_dat_rdy;

NV_NVDLA_BDMA_STORE_lat_fifo lat_fifo (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.lat_fifo_wr_prdy    (dma_rd_rsp_rdy)          //|> w
  ,.lat_fifo_wr_pvld    (dma_rd_rsp_vld)          //|< w
  ,.lat_fifo_wr_pd      (dma_rd_rsp_pd[513:0])    //|< w
  ,.lat_fifo_rd_prdy    (dma_wr_dat_rdy)          //|< w
  ,.lat_fifo_rd_pvld    (dma_wr_dat_pvld)         //|> w
  ,.lat_fifo_rd_pd      (dma_wr_dat_data[513:0])  //|> w
  ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])     //|< i
  );


//==================================
//===DMA WRITE DATA
//==================================

//===FLAG: cmd or data
//===LDC: first Command and follow with corespoing data
// Only when all beat is ready in r2w FIFO, wr_cmd will be sent
// and after cmd is sent, data will be sent to XXIF without bubble
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cmd_en <= 1'b1;
    dat_en <= 1'b0;
  end else begin
    if (tran_cmd_accept) begin
        cmd_en <= 1'b0;
        dat_en <= 1'b1;
    end else if (tran_dat_accept & is_last_beat) begin
        cmd_en <= 1'b1;
        dat_en <= 1'b0;
    end
  end
end


//==================================
//===Beat Count
//==================================
assign beat_size = reg_line_size[12:1];
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    beat_count <= {12{1'b0}};
  end else begin
    if (tran_dat_accept) begin
        if (is_last_beat) begin
            beat_count <= 0;
        end else begin
            beat_count <= beat_count + 1;
        end
    end
  end
end
assign is_last_beat = (beat_count==beat_size);

//==================================
// Interrupt Handler
//==================================
NV_NVDLA_BDMA_STORE_fifo_intr u_fifo_intr (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.fifo_intr_wr_idle   (fifo_intr_wr_idle)       //|> w
  ,.fifo_intr_wr_pvld   (fifo_intr_wr_pvld)       //|< w
  ,.fifo_intr_wr_pd     (fifo_intr_wr_pd)         //|< w
  ,.fifo_intr_rd_prdy   (fifo_intr_rd_prdy)       //|< w
  ,.fifo_intr_rd_pvld   (fifo_intr_rd_pvld)       //|> w
  ,.fifo_intr_rd_pd     (fifo_intr_rd_pd)         //|> w
  ,.pwrbus_ram_pd       (pwrbus_ram_pd[31:0])     //|< i
  );
assign fifo_intr_wr_pd    = reg_cmd_interrupt_ptr;
assign fifo_intr_wr_pvld  = dma_wr_cmd_vld & dma_wr_cmd_rdy & dma_wr_cmd_require_ack;
assign fifo_intr_rd_prdy  = dma_wr_rsp_complete;

assign grp0_done = fifo_intr_rd_pvld & fifo_intr_rd_prdy & (fifo_intr_rd_pd==0);
assign grp1_done = fifo_intr_rd_pvld & fifo_intr_rd_prdy & (fifo_intr_rd_pd==1);

assign st2csb_grp0_done = grp0_done;
assign st2csb_grp1_done = grp1_done;
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
  nv_assert_never #(0,0,"when write complete, intr_ptr should be already in the head of fifo_intr read side")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, !fifo_intr_rd_pvld & dma_wr_rsp_complete); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//==================================
//===DMA WRITE REQ
//==================================
// Line_addr is the start address of every line
// load a new one from CSB FIFO for every mem copy command
// will change every time one a block is done and jump to the next line
always @(posedge nvdla_core_clk) begin
    if (ld2st_rd_accept) begin
        line_addr <= ld2st_addr;
    end else if (tran_dat_accept & is_last_beat) begin
        if (is_surf_last) begin
            {mon_line_addr_c,line_addr} <= surf_addr + (reg_surf_stride<<5);
        end else begin
            {mon_line_addr_c,line_addr} <= line_addr + (reg_line_stride<<5);
        end
    end
end

// Surf_addr is the base address of each surface
// will change every time one a block is done and jump to the next surface
always @(posedge nvdla_core_clk) begin
    if (ld2st_rd_accept) begin
        surf_addr <= ld2st_addr;
    end else if (tran_dat_accept & is_last_beat) begin
        if (is_surf_last) begin
            {mon_surf_addr_c,surf_addr} <= surf_addr + (reg_surf_stride<<5);
        end
    end
end

//===TRAN SIZE
// for each DMA request, tran_size is to tell how many 32B DATA block indicated

// ===LINE COUNT
// count++ when just to next line
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    line_count <= {13{1'b0}};
  end else begin
    if (tran_dat_accept & is_last_beat) begin
        if (is_surf_last) begin
            line_count <= 0;
        end else begin
            line_count <= line_count + 1;
        end
    end
  end
end

// SURF COUNT
// count++ when just to next surf
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    surf_count <= {13{1'b0}};
  end else begin
    if (tran_dat_accept & is_last_beat) begin
        if (is_cube_last) begin
            surf_count <= 0;
        end else if (is_surf_last) begin
            surf_count <= surf_count + 1;
        end 
    end
  end
end

//===Require ACK
assign is_surf_last = (line_count==reg_line_repeat_number);
assign is_cube_last = (surf_count==reg_surf_repeat_number) && is_surf_last;

//===DMA WRITE OUT 
assign dma_wr_cmd_rdy = dma_wr_req_rdy & cmd_en;
assign dma_wr_dat_rdy = dma_wr_req_rdy & dat_en;

assign tran_cmd_accept = dma_wr_cmd_rdy  & dma_wr_req_vld;
assign tran_dat_accept = dma_wr_dat_rdy & dma_wr_req_vld;

//DMA WRITE req : cmd
assign dma_wr_cmd_vld           = cmd_en & tran_cmd_valid;
assign dma_wr_cmd_addr          = line_addr;
assign dma_wr_cmd_size          = reg_line_size;
assign dma_wr_cmd_require_ack   = reg_cmd_interrupt & is_cube_last;

// PKT_PACK_WIRE( dma_write_cmd , dma_wr_cmd_ , dma_wr_cmd_pd )
assign      dma_wr_cmd_pd[63:0] =    dma_wr_cmd_addr[63:0];
assign      dma_wr_cmd_pd[76:64] =    dma_wr_cmd_size[12:0];
assign      dma_wr_cmd_pd[77] =    dma_wr_cmd_require_ack ;

//DMA WRITE req : data
assign dma_wr_dat_vld   = dat_en & dma_wr_dat_pvld;
//assign dma_wr_dat_data  = lat_fifo_rd_pd;
assign dma_wr_dat_mask  = (reg_line_size[0]==0 && is_last_beat) ? 2'b01 : 2'b11;

// PKT_PACK_WIRE( dma_write_data , dma_wr_dat_ , dma_wr_dat_pd )
assign      dma_wr_dat_pd[511:0] =    dma_wr_dat_data[511:0];
assign      dma_wr_dat_pd[513:512] =    dma_wr_dat_mask[1:0];

// req: cmd|data
assign dma_wr_req_vld  = dma_wr_cmd_vld | dma_wr_dat_vld;
always @(
  cmd_en
  or dma_wr_cmd_pd
  or dma_wr_dat_pd
  ) begin
    dma_wr_req_pd = 0;
    if (cmd_en) begin
        dma_wr_req_pd[77:0] = dma_wr_cmd_pd;
        dma_wr_req_pd[514:514] = 1'd0  /* PKT_nvdla_dma_wr_req_dma_write_cmd_ID  */ ;
    end else begin
        dma_wr_req_pd[513:0] = dma_wr_dat_pd;
        dma_wr_req_pd[514:514] = 1'd1  /* PKT_nvdla_dma_wr_req_dma_write_data_ID  */ ;
    end
end

//DMA WRITE req : pkt : cmd+data
assign dma_wr_req_ram_type          = reg_cmd_dst_ram_type;
// wr Channel: Request 
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
assign cv_dma_wr_req_vld = dma_wr_req_vld & (dma_wr_req_ram_type == 1'b0);
#endif
assign mc_dma_wr_req_vld = dma_wr_req_vld & (dma_wr_req_ram_type == 1'b1);
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
assign cv_wr_req_rdyi = cv_dma_wr_req_rdy & (dma_wr_req_ram_type == 1'b0);
#endif
assign mc_wr_req_rdyi = mc_dma_wr_req_rdy & (dma_wr_req_ram_type == 1'b1);
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
assign wr_req_rdyi = mc_wr_req_rdyi | cv_wr_req_rdyi;
#else
assign wr_req_rdyi = mc_wr_req_rdyi; 
#endif
assign dma_wr_req_rdy= wr_req_rdyi;
NV_NVDLA_BDMA_STORE_pipe_p3 pipe_p3 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.dma_wr_req_pd       (dma_wr_req_pd[514:0])    //|< r
  ,.mc_dma_wr_req_vld   (mc_dma_wr_req_vld)       //|< w
  ,.mc_int_wr_req_ready (mc_int_wr_req_ready)     //|< w
  ,.mc_dma_wr_req_rdy   (mc_dma_wr_req_rdy)       //|> w
  ,.mc_int_wr_req_pd    (mc_int_wr_req_pd[514:0]) //|> w
  ,.mc_int_wr_req_valid (mc_int_wr_req_valid)     //|> w
  );
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
NV_NVDLA_BDMA_STORE_pipe_p4 pipe_p4 (
   .nvdla_core_clk      (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)         //|< i
  ,.cv_dma_wr_req_vld   (cv_dma_wr_req_vld)       //|< w
  ,.cv_int_wr_req_ready (cv_int_wr_req_ready)     //|< w
  ,.dma_wr_req_pd       (dma_wr_req_pd[514:0])    //|< r
  ,.cv_dma_wr_req_rdy   (cv_dma_wr_req_rdy)       //|> w
  ,.cv_int_wr_req_pd    (cv_int_wr_req_pd[514:0]) //|> w
  ,.cv_int_wr_req_valid (cv_int_wr_req_valid)     //|> w
  );
#endif

assign mc_int_wr_req_valid_d0 = mc_int_wr_req_valid;
assign mc_int_wr_req_ready = mc_int_wr_req_ready_d0;
assign mc_int_wr_req_pd_d0[514:0] = mc_int_wr_req_pd[514:0];
assign bdma2mcif_wr_req_valid = mc_int_wr_req_valid_d0;
assign mc_int_wr_req_ready_d0 = bdma2mcif_wr_req_ready;
assign bdma2mcif_wr_req_pd[514:0] = mc_int_wr_req_pd_d0[514:0];


#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
assign cv_int_wr_req_valid_d0 = cv_int_wr_req_valid;
assign cv_int_wr_req_ready = cv_int_wr_req_ready_d0;
assign cv_int_wr_req_pd_d0[514:0] = cv_int_wr_req_pd[514:0];
assign bdma2cvif_wr_req_valid = cv_int_wr_req_valid_d0;
assign cv_int_wr_req_ready_d0 = bdma2cvif_wr_req_ready;
assign bdma2cvif_wr_req_pd[514:0] = cv_int_wr_req_pd_d0[514:0];
#endif

// wr Channel: Response

assign mc_int_wr_rsp_complete = mcif2bdma_wr_rsp_complete;


#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
assign cv_int_wr_rsp_complete = cvif2bdma_wr_rsp_complete;
#endif
assign require_ack = (dma_wr_req_pd[514:514]==0) & (dma_wr_req_pd[77:77]==1);
assign ack_raw_vld = dma_wr_req_vld & wr_req_rdyi & require_ack;
assign ack_raw_id  = dma_wr_req_ram_type;
// stage1: bot
assign ack_raw_rdy = ack_bot_rdy || !ack_bot_vld;
always @(posedge nvdla_core_clk) begin
  if ((ack_raw_vld & ack_raw_rdy) == 1'b1) begin
    ack_bot_id <= ack_raw_id;
  // VCS coverage off
  end else if ((ack_raw_vld & ack_raw_rdy) == 1'b0) begin
  end else begin
    ack_bot_id <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(ack_raw_rdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"dmaif bot never push back")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, ack_raw_vld & !ack_raw_rdy); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(ack_bot_vld & ack_bot_rdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(ack_bot_rdy))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mc_dma_wr_rsp_complete <= 1'b0;
  end else begin
  mc_dma_wr_rsp_complete <= mc_int_wr_rsp_complete;
  end
end
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cv_dma_wr_rsp_complete <= 1'b0;
  end else begin
  cv_dma_wr_rsp_complete <= cv_int_wr_rsp_complete;
  end
end
#endif
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dma_wr_rsp_complete <= 1'b0;
  end else begin
  dma_wr_rsp_complete <= releasing;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
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
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
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
#endif
assign mc_releasing = ack_top_id==1'b1 & (mc_dma_wr_rsp_complete | mc_pending);
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
assign cv_releasing = ack_top_id==1'b0 & (cv_dma_wr_rsp_complete | cv_pending);
#endif
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
assign releasing = mc_releasing | cv_releasing;
#else
assign releasing = mc_releasing; 
#endif
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
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  nv_assert_never #(0,0,"no release both together")      zzz_assert_never_8x (nvdla_core_clk, `ASSERT_RESET, mc_releasing & cv_releasing); // spyglass disable W504 SelfDeterminedExpr-ML 
  #else
  nv_assert_never #(0,0,"no release both together")      zzz_assert_never_8x (nvdla_core_clk, `ASSERT_RESET, mc_releasing ); // spyglass disable W504 SelfDeterminedExpr-ML 
  #endif
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
  nv_assert_never #(0,0,"no mc resp back and pending together")      zzz_assert_never_9x (nvdla_core_clk, `ASSERT_RESET, mc_pending & mc_dma_wr_rsp_complete); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  nv_assert_never #(0,0,"no cv resp back and pending together")      zzz_assert_never_10x (nvdla_core_clk, `ASSERT_RESET, cv_pending & cv_dma_wr_rsp_complete); // spyglass disable W504 SelfDeterminedExpr-ML 
  #endif
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
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  nv_assert_never #(0,0,"no ack_top_vld when resp from cv")      zzz_assert_never_11x (nvdla_core_clk, `ASSERT_RESET, (cv_pending | cv_dma_wr_rsp_complete) & !ack_top_vld); // spyglass disable W504 SelfDeterminedExpr-ML 
  #endif
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
  nv_assert_never #(0,0,"no ack_top_vld when resp from mc")      zzz_assert_never_12x (nvdla_core_clk, `ASSERT_RESET, (mc_pending | mc_dma_wr_rsp_complete) & !ack_top_vld); // spyglass disable W504 SelfDeterminedExpr-ML 
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

    property dmaif_bdma__two_completes__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
	#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
        mc_dma_wr_rsp_complete & cv_dma_wr_rsp_complete;
	#else
        mc_dma_wr_rsp_complete; 
	#endif
    endproperty
    // Cover 0 : "mc_dma_wr_rsp_complete & cv_dma_wr_rsp_complete"
    FUNCPOINT_dmaif_bdma__two_completes__0_COV : cover property (dmaif_bdma__two_completes__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property dmaif_bdma__one_pending_complete_with_mc__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
	#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
        cv_pending & mc_dma_wr_rsp_complete;
	#else
        mc_dma_wr_rsp_complete;
	#endif
    endproperty
    // Cover 1 : "cv_pending & mc_dma_wr_rsp_complete"
    FUNCPOINT_dmaif_bdma__one_pending_complete_with_mc__1_COV : cover property (dmaif_bdma__one_pending_complete_with_mc__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property dmaif_bdma__one_pending_complete_with_cv__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
	#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
        mc_pending & cv_dma_wr_rsp_complete;
	#else
        mc_pending;
	#endif
    endproperty
    // Cover 2 : "mc_pending & cv_dma_wr_rsp_complete"
    FUNCPOINT_dmaif_bdma__one_pending_complete_with_cv__2_COV : cover property (dmaif_bdma__one_pending_complete_with_cv__2_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property dmaif_bdma__sequence_complete_cv_one_cycle_after_mc_in_order__3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
	#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
        cv_int_wr_rsp_complete & mc_dma_wr_rsp_complete & ack_top_id==1'b1;
	#else
        mc_dma_wr_rsp_complete & ack_top_id==1'b1;
	#endif
    endproperty
    // Cover 3 : "cv_int_wr_rsp_complete & mc_dma_wr_rsp_complete & ack_top_id==1'b1"
    FUNCPOINT_dmaif_bdma__sequence_complete_cv_one_cycle_after_mc_in_order__3_COV : cover property (dmaif_bdma__sequence_complete_cv_one_cycle_after_mc_in_order__3_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property dmaif_bdma__sequence_complete_cv_one_cycle_after_mc_out_of_order__4_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
	#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
        cv_int_wr_rsp_complete & mc_dma_wr_rsp_complete & ack_top_id==1'b0;
	#else
        mc_dma_wr_rsp_complete & ack_top_id==1'b0;
	#endif
    endproperty
    // Cover 4 : "cv_int_wr_rsp_complete & mc_dma_wr_rsp_complete & ack_top_id==1'b0"
    FUNCPOINT_dmaif_bdma__sequence_complete_cv_one_cycle_after_mc_out_of_order__4_COV : cover property (dmaif_bdma__sequence_complete_cv_one_cycle_after_mc_out_of_order__4_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property dmaif_bdma__sequence_complete_mc_one_cycle_after_cv_in_order__5_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
	#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
        mc_int_wr_rsp_complete & cv_dma_wr_rsp_complete & ack_top_id==1'b0;
	#else
        mc_int_wr_rsp_complete &  ack_top_id==1'b0;
	#endif
    endproperty
    // Cover 5 : "mc_int_wr_rsp_complete & cv_dma_wr_rsp_complete & ack_top_id==1'b0"
    FUNCPOINT_dmaif_bdma__sequence_complete_mc_one_cycle_after_cv_in_order__5_COV : cover property (dmaif_bdma__sequence_complete_mc_one_cycle_after_cv_in_order__5_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property dmaif_bdma__sequence_complete_mc_one_cycle_after_cv_out_of_order__6_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
	#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
        mc_int_wr_rsp_complete & cv_dma_wr_rsp_complete & ack_top_id==1'b1;
	#else
        mc_int_wr_rsp_complete & ack_top_id==1'b1;
	#endif
    endproperty
    // Cover 6 : "mc_int_wr_rsp_complete & cv_dma_wr_rsp_complete & ack_top_id==1'b1"
    FUNCPOINT_dmaif_bdma__sequence_complete_mc_one_cycle_after_cv_out_of_order__6_COV : cover property (dmaif_bdma__sequence_complete_mc_one_cycle_after_cv_out_of_order__6_cov);

  `endif
`endif
//VCS coverage on



//======================================
// STATUS
//======================================
// STATUS stall count
assign dma_write_stall_count_inc = dma_wr_req_vld & !dma_wr_req_rdy;



    assign dma_write_stall_count_dec = 1'b0;

    // stl adv logic

    always @(
      dma_write_stall_count_inc
      or dma_write_stall_count_dec
      ) begin
      stl_adv = dma_write_stall_count_inc ^ dma_write_stall_count_dec;
    end
        
    // stl cnt logic
    always @(
      stl_cnt_cur
      or dma_write_stall_count_inc
      or dma_write_stall_count_dec
      or stl_adv
      or dma_wr_rsp_complete
      ) begin
      // VCS sop_coverage_off start
      stl_cnt_ext[33:0] = {1'b0, 1'b0, stl_cnt_cur};
      stl_cnt_inc[33:0] = stl_cnt_cur + 1'b1; // spyglass disable W164b
      stl_cnt_dec[33:0] = stl_cnt_cur - 1'b1; // spyglass disable W164b
      stl_cnt_mod[33:0] = (dma_write_stall_count_inc && !dma_write_stall_count_dec)? stl_cnt_inc : (!dma_write_stall_count_inc && dma_write_stall_count_dec)? stl_cnt_dec : stl_cnt_ext;
      stl_cnt_new[33:0] = (stl_adv)? stl_cnt_mod[33:0] : stl_cnt_ext[33:0];
      stl_cnt_nxt[33:0] = (dma_wr_rsp_complete)? 34'd0 : stl_cnt_new[33:0];
      // VCS sop_coverage_off end
    end

    // stl flops

    always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
      if (!nvdla_core_rstn) begin
        stl_cnt_cur[31:0] <= 0;
      end else begin
      if (dma_write_stall_count_cen) begin
      stl_cnt_cur[31:0] <= stl_cnt_nxt[31:0];
      end
      end
    end

    // stl output logic

    always @(
      stl_cnt_cur
      ) begin
      dma_write_stall_count[31:0] = stl_cnt_cur[31:0];
    end
        
      

// STATUS IDLE
assign st_idle = fifo_intr_wr_idle & !tran_cmd_valid;
assign st2csb_idle = st_idle;
assign st2ld_load_idle = cmd_en & !tran_cmd_valid;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    st2gate_slcg_en <= 1'b0;
  end else begin
  st2gate_slcg_en <= !st_idle;
  end
end

//======================================
// OBS
//assign obs_bus_bdma_store_ack_bot_vld        =  ack_bot_vld; 
//assign obs_bus_bdma_store_ack_top_vld        =  ack_top_vld;
//assign obs_bus_bdma_store_ack_pending        =  releasing; 
//assign obs_bus_bdma_store_ack_release        =  releasing; 
//assign obs_bus_bdma_store_cmd_en             =  cmd_en; 
//assign obs_bus_bdma_store_dat_en             =  dat_en;
//assign obs_bus_bdma_store_cv_rd_rsp_rdy      =  dma_rd_rsp_rdy;
//assign obs_bus_bdma_store_cv_rd_rsp_vld      =  cv_dma_rd_rsp_vld; 
//assign obs_bus_bdma_store_cv_wr_req_rdy      =  cv_dma_wr_req_rdy; 
//assign obs_bus_bdma_store_cv_wr_req_vld      =  cv_dma_wr_req_vld; 
//assign obs_bus_bdma_store_cv_wr_rsp_complete =  cv_dma_wr_rsp_complete; 
//assign obs_bus_bdma_store_grp0_done          =  grp0_done;
//assign obs_bus_bdma_store_grp1_done          =  grp1_done;
//assign obs_bus_bdma_store_idle               =  st_idle; 
//assign obs_bus_bdma_store_is_cube_last       =  is_cube_last;
//assign obs_bus_bdma_store_is_surf_last       =  is_surf_last;
//assign obs_bus_bdma_store_lat_fifo_rd_prdy   =  lat_fifo_rd_prdy; 
//assign obs_bus_bdma_store_lat_fifo_rd_pvld   =  lat_fifo_rd_pvld; 
//assign obs_bus_bdma_store_lat_fifo_wr_prdy   =  lat_fifo_wr_prdy;
//assign obs_bus_bdma_store_lat_fifo_wr_pvld   =  lat_fifo_wr_pvld;
//assign obs_bus_bdma_store_mc_rd_rsp_rdy      =  dma_rd_rsp_rdy;
//assign obs_bus_bdma_store_mc_rd_rsp_vld      =  mc_dma_rd_rsp_vld; 
//assign obs_bus_bdma_store_mc_wr_req_rdy      =  mc_dma_wr_req_rdy; 
//assign obs_bus_bdma_store_mc_wr_req_vld      =  mc_dma_wr_req_vld; 
//assign obs_bus_bdma_store_mc_wr_rsp_complete =  mc_dma_wr_rsp_complete; 

endmodule // NV_NVDLA_BDMA_store



// **************************************************************************************************************
// Generated by ::pipe -m -bc -os mc_dma_rd_rsp_pd (mc_dma_rd_rsp_vld,dma_rd_rsp_rdy) <= mc_int_rd_rsp_pd[513:0] (mc_int_rd_rsp_valid,mc_int_rd_rsp_ready)
// **************************************************************************************************************
module NV_NVDLA_BDMA_STORE_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dma_rd_rsp_rdy
  ,mc_int_rd_rsp_pd
  ,mc_int_rd_rsp_valid
  ,mc_dma_rd_rsp_pd
  ,mc_dma_rd_rsp_vld
  ,mc_int_rd_rsp_ready
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          dma_rd_rsp_rdy;
input  [513:0] mc_int_rd_rsp_pd;
input          mc_int_rd_rsp_valid;
output [513:0] mc_dma_rd_rsp_pd;
output         mc_dma_rd_rsp_vld;
output         mc_int_rd_rsp_ready;
reg    [513:0] mc_dma_rd_rsp_pd;
reg            mc_dma_rd_rsp_vld;
reg            mc_int_rd_rsp_ready;
reg    [513:0] p1_pipe_data;
reg    [513:0] p1_pipe_rand_data;
reg            p1_pipe_rand_ready;
reg            p1_pipe_rand_valid;
reg            p1_pipe_ready;
reg            p1_pipe_ready_bc;
reg    [513:0] p1_pipe_skid_data;
reg            p1_pipe_skid_ready;
reg            p1_pipe_skid_valid;
reg            p1_pipe_valid;
reg            p1_skid_catch;
reg    [513:0] p1_skid_data;
reg            p1_skid_ready;
reg            p1_skid_ready_flop;
reg            p1_skid_valid;
//## pipe (1) randomizer
`ifndef SYNTHESIS
reg p1_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p1_pipe_rand_active
  or 
     `endif
     mc_int_rd_rsp_valid
  or p1_pipe_rand_ready
  or mc_int_rd_rsp_pd
  ) begin
  `ifdef SYNTHESIS
  p1_pipe_rand_valid = mc_int_rd_rsp_valid;
  mc_int_rd_rsp_ready = p1_pipe_rand_ready;
  p1_pipe_rand_data = mc_int_rd_rsp_pd[513:0];
  `else
  // VCS coverage off
  p1_pipe_rand_valid = (p1_pipe_rand_active)? 1'b0 : mc_int_rd_rsp_valid;
  mc_int_rd_rsp_ready = (p1_pipe_rand_active)? 1'b0 : p1_pipe_rand_ready;
  p1_pipe_rand_data = (p1_pipe_rand_active)?  'bx : mc_int_rd_rsp_pd[513:0];
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
  if      ( $value$plusargs( "NV_NVDLA_BDMA_store_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p1_pipe_rand_enable;
reg p1_pipe_rand_poised;
always @(
  p1_pipe_stall_cycles
  or p1_pipe_stall_probability
  or mc_int_rd_rsp_valid
  ) begin
  p1_pipe_rand_active = p1_pipe_stall_cycles != 0;
  p1_pipe_rand_enable = p1_pipe_stall_probability != 0;
  p1_pipe_rand_poised = p1_pipe_rand_enable && !p1_pipe_rand_active && mc_int_rd_rsp_valid === 1'b1;
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
  p1_pipe_valid <= (p1_pipe_ready_bc)? p1_pipe_rand_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && p1_pipe_rand_valid)? p1_pipe_rand_data : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  p1_pipe_rand_ready = p1_pipe_ready_bc;
end
//## pipe (1) skid buffer
always @(
  p1_pipe_valid
  or p1_skid_ready_flop
  or p1_pipe_skid_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = p1_pipe_valid && p1_skid_ready_flop && !p1_pipe_skid_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_pipe_skid_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    p1_pipe_ready <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_pipe_skid_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  p1_pipe_ready <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? p1_pipe_data : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or p1_pipe_valid
  or p1_skid_valid
  or p1_pipe_data
  or p1_skid_data
  ) begin
  p1_pipe_skid_valid = (p1_skid_ready_flop)? p1_pipe_valid : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_pipe_skid_data = (p1_skid_ready_flop)? p1_pipe_data : p1_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (1) output
always @(
  p1_pipe_skid_valid
  or dma_rd_rsp_rdy
  or p1_pipe_skid_data
  ) begin
  mc_dma_rd_rsp_vld = p1_pipe_skid_valid;
  p1_pipe_skid_ready = dma_rd_rsp_rdy;
  mc_dma_rd_rsp_pd = p1_pipe_skid_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mc_dma_rd_rsp_vld^dma_rd_rsp_rdy^mc_int_rd_rsp_valid^mc_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_14x (nvdla_core_clk, `ASSERT_RESET, (mc_int_rd_rsp_valid && !mc_int_rd_rsp_ready), (mc_int_rd_rsp_valid), (mc_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_BDMA_STORE_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -os cv_dma_rd_rsp_pd (cv_dma_rd_rsp_vld,dma_rd_rsp_rdy) <= cv_int_rd_rsp_pd[513:0] (cv_int_rd_rsp_valid,cv_int_rd_rsp_ready)
// **************************************************************************************************************
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
module NV_NVDLA_BDMA_STORE_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cv_int_rd_rsp_pd
  ,cv_int_rd_rsp_valid
  ,dma_rd_rsp_rdy
  ,cv_dma_rd_rsp_pd
  ,cv_dma_rd_rsp_vld
  ,cv_int_rd_rsp_ready
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [513:0] cv_int_rd_rsp_pd;
input          cv_int_rd_rsp_valid;
input          dma_rd_rsp_rdy;
output [513:0] cv_dma_rd_rsp_pd;
output         cv_dma_rd_rsp_vld;
output         cv_int_rd_rsp_ready;
reg    [513:0] cv_dma_rd_rsp_pd;
reg            cv_dma_rd_rsp_vld;
reg            cv_int_rd_rsp_ready;
reg    [513:0] p2_pipe_data;
reg    [513:0] p2_pipe_rand_data;
reg            p2_pipe_rand_ready;
reg            p2_pipe_rand_valid;
reg            p2_pipe_ready;
reg            p2_pipe_ready_bc;
reg    [513:0] p2_pipe_skid_data;
reg            p2_pipe_skid_ready;
reg            p2_pipe_skid_valid;
reg            p2_pipe_valid;
reg            p2_skid_catch;
reg    [513:0] p2_skid_data;
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
     cv_int_rd_rsp_valid
  or p2_pipe_rand_ready
  or cv_int_rd_rsp_pd
  ) begin
  `ifdef SYNTHESIS
  p2_pipe_rand_valid = cv_int_rd_rsp_valid;
  cv_int_rd_rsp_ready = p2_pipe_rand_ready;
  p2_pipe_rand_data = cv_int_rd_rsp_pd[513:0];
  `else
  // VCS coverage off
  p2_pipe_rand_valid = (p2_pipe_rand_active)? 1'b0 : cv_int_rd_rsp_valid;
  cv_int_rd_rsp_ready = (p2_pipe_rand_active)? 1'b0 : p2_pipe_rand_ready;
  p2_pipe_rand_data = (p2_pipe_rand_active)?  'bx : cv_int_rd_rsp_pd[513:0];
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
  if      ( $value$plusargs( "NV_NVDLA_BDMA_store_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_probability" ) ) p2_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_cycles_min"  ) ) p2_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_cycles_max"  ) ) p2_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p2_pipe_rand_enable;
reg p2_pipe_rand_poised;
always @(
  p2_pipe_stall_cycles
  or p2_pipe_stall_probability
  or cv_int_rd_rsp_valid
  ) begin
  p2_pipe_rand_active = p2_pipe_stall_cycles != 0;
  p2_pipe_rand_enable = p2_pipe_stall_probability != 0;
  p2_pipe_rand_poised = p2_pipe_rand_enable && !p2_pipe_rand_active && cv_int_rd_rsp_valid === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
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
//## pipe (2) valid-ready-bubble-collapse
always @(
  p2_pipe_ready
  or p2_pipe_valid
  ) begin
  p2_pipe_ready_bc = p2_pipe_ready || !p2_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_valid <= 1'b0;
  end else begin
  p2_pipe_valid <= (p2_pipe_ready_bc)? p2_pipe_rand_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && p2_pipe_rand_valid)? p2_pipe_rand_data : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  p2_pipe_rand_ready = p2_pipe_ready_bc;
end
//## pipe (2) skid buffer
always @(
  p2_pipe_valid
  or p2_skid_ready_flop
  or p2_pipe_skid_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = p2_pipe_valid && p2_skid_ready_flop && !p2_pipe_skid_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_pipe_skid_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    p2_pipe_ready <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_pipe_skid_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  p2_pipe_ready <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? p2_pipe_data : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or p2_pipe_valid
  or p2_skid_valid
  or p2_pipe_data
  or p2_skid_data
  ) begin
  p2_pipe_skid_valid = (p2_skid_ready_flop)? p2_pipe_valid : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_pipe_skid_data = (p2_skid_ready_flop)? p2_pipe_data : p2_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (2) output
always @(
  p2_pipe_skid_valid
  or dma_rd_rsp_rdy
  or p2_pipe_skid_data
  ) begin
  cv_dma_rd_rsp_vld = p2_pipe_skid_valid;
  p2_pipe_skid_ready = dma_rd_rsp_rdy;
  cv_dma_rd_rsp_pd = p2_pipe_skid_data;
end
//## pipe (2) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p2_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cv_dma_rd_rsp_vld^dma_rd_rsp_rdy^cv_int_rd_rsp_valid^cv_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_16x (nvdla_core_clk, `ASSERT_RESET, (cv_int_rd_rsp_valid && !cv_int_rd_rsp_ready), (cv_int_rd_rsp_valid), (cv_int_rd_rsp_ready)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_BDMA_STORE_pipe_p2
#endif




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is mc_int_wr_req_pd (mc_int_wr_req_valid,mc_int_wr_req_ready) <= dma_wr_req_pd[514:0] (mc_dma_wr_req_vld,mc_dma_wr_req_rdy)
// **************************************************************************************************************
module NV_NVDLA_BDMA_STORE_pipe_p3 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dma_wr_req_pd
  ,mc_dma_wr_req_vld
  ,mc_int_wr_req_ready
  ,mc_dma_wr_req_rdy
  ,mc_int_wr_req_pd
  ,mc_int_wr_req_valid
  );
input          nvdla_core_clk;
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
     mc_dma_wr_req_vld
  or p3_pipe_rand_ready
  or dma_wr_req_pd
  ) begin
  `ifdef SYNTHESIS
  p3_pipe_rand_valid = mc_dma_wr_req_vld;
  mc_dma_wr_req_rdy = p3_pipe_rand_ready;
  p3_pipe_rand_data = dma_wr_req_pd[514:0];
  `else
  // VCS coverage off
  p3_pipe_rand_valid = (p3_pipe_rand_active)? 1'b0 : mc_dma_wr_req_vld;
  mc_dma_wr_req_rdy = (p3_pipe_rand_active)? 1'b0 : p3_pipe_rand_ready;
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
  if      ( $value$plusargs( "NV_NVDLA_BDMA_store_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p3_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p3_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p3_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p3_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_probability" ) ) p3_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_cycles_min"  ) ) p3_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_cycles_max"  ) ) p3_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p3_pipe_rand_enable;
reg p3_pipe_rand_poised;
always @(
  p3_pipe_stall_cycles
  or p3_pipe_stall_probability
  or mc_dma_wr_req_vld
  ) begin
  p3_pipe_rand_active = p3_pipe_stall_cycles != 0;
  p3_pipe_rand_enable = p3_pipe_stall_probability != 0;
  p3_pipe_rand_poised = p3_pipe_rand_enable && !p3_pipe_rand_active && mc_dma_wr_req_vld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
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
always @(posedge nvdla_core_clk) begin
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_pipe_valid <= 1'b0;
  end else begin
  p3_pipe_valid <= (p3_pipe_ready_bc)? p3_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
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
  or mc_int_wr_req_ready
  or p3_pipe_data
  ) begin
  mc_int_wr_req_valid = p3_pipe_valid;
  p3_pipe_ready = mc_int_wr_req_ready;
  mc_int_wr_req_pd = p3_pipe_data;
end
//## pipe (3) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p3_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mc_int_wr_req_valid^mc_int_wr_req_ready^mc_dma_wr_req_vld^mc_dma_wr_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_18x (nvdla_core_clk, `ASSERT_RESET, (mc_dma_wr_req_vld && !mc_dma_wr_req_rdy), (mc_dma_wr_req_vld), (mc_dma_wr_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_BDMA_STORE_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is cv_int_wr_req_pd (cv_int_wr_req_valid,cv_int_wr_req_ready) <= dma_wr_req_pd[514:0] (cv_dma_wr_req_vld,cv_dma_wr_req_rdy)
// **************************************************************************************************************
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
module NV_NVDLA_BDMA_STORE_pipe_p4 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cv_dma_wr_req_vld
  ,cv_int_wr_req_ready
  ,dma_wr_req_pd
  ,cv_dma_wr_req_rdy
  ,cv_int_wr_req_pd
  ,cv_int_wr_req_valid
  );
input          nvdla_core_clk;
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
reg    [514:0] p4_pipe_data;
reg    [514:0] p4_pipe_rand_data;
reg            p4_pipe_rand_ready;
reg            p4_pipe_rand_valid;
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
//## pipe (4) randomizer
`ifndef SYNTHESIS
reg p4_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p4_pipe_rand_active
  or 
     `endif
     cv_dma_wr_req_vld
  or p4_pipe_rand_ready
  or dma_wr_req_pd
  ) begin
  `ifdef SYNTHESIS
  p4_pipe_rand_valid = cv_dma_wr_req_vld;
  cv_dma_wr_req_rdy = p4_pipe_rand_ready;
  p4_pipe_rand_data = dma_wr_req_pd[514:0];
  `else
  // VCS coverage off
  p4_pipe_rand_valid = (p4_pipe_rand_active)? 1'b0 : cv_dma_wr_req_vld;
  cv_dma_wr_req_rdy = (p4_pipe_rand_active)? 1'b0 : p4_pipe_rand_ready;
  p4_pipe_rand_data = (p4_pipe_rand_active)?  'bx : dma_wr_req_pd[514:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p4_pipe_stall_cycles;
integer p4_pipe_stall_probability;
integer p4_pipe_stall_cycles_min;
integer p4_pipe_stall_cycles_max;
initial begin
  p4_pipe_stall_cycles = 0;
  p4_pipe_stall_probability = 0;
  p4_pipe_stall_cycles_min = 1;
  p4_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_BDMA_store_pipe_rand_probability=%d",  p4_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p4_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_probability=%d", p4_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p4_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_cycles_min=%d",  p4_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p4_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_cycles_max=%d",  p4_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p4_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_probability" ) ) p4_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_cycles_min"  ) ) p4_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_BDMA_store_pipe_stall_cycles_max"  ) ) p4_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p4_pipe_rand_enable;
reg p4_pipe_rand_poised;
always @(
  p4_pipe_stall_cycles
  or p4_pipe_stall_probability
  or cv_dma_wr_req_vld
  ) begin
  p4_pipe_rand_active = p4_pipe_stall_cycles != 0;
  p4_pipe_rand_enable = p4_pipe_stall_probability != 0;
  p4_pipe_rand_poised = p4_pipe_rand_enable && !p4_pipe_rand_active && cv_dma_wr_req_vld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p4_pipe_rand_poised) begin
    if (p4_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p4_pipe_stall_cycles <= prand_inst1(p4_pipe_stall_cycles_min, p4_pipe_stall_cycles_max);
    end
  end else if (p4_pipe_rand_active) begin
    p4_pipe_stall_cycles <= p4_pipe_stall_cycles - 1;
  end else begin
    p4_pipe_stall_cycles <= 0;
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
//## pipe (4) skid buffer
always @(
  p4_pipe_rand_valid
  or p4_skid_ready_flop
  or p4_skid_pipe_ready
  or p4_skid_valid
  ) begin
  p4_skid_catch = p4_pipe_rand_valid && p4_skid_ready_flop && !p4_skid_pipe_ready;  
  p4_skid_ready = (p4_skid_valid)? p4_skid_pipe_ready : !p4_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_skid_valid <= 1'b0;
    p4_skid_ready_flop <= 1'b1;
    p4_pipe_rand_ready <= 1'b1;
  end else begin
  p4_skid_valid <= (p4_skid_valid)? !p4_skid_pipe_ready : p4_skid_catch;
  p4_skid_ready_flop <= p4_skid_ready;
  p4_pipe_rand_ready <= p4_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_skid_data <= (p4_skid_catch)? p4_pipe_rand_data : p4_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p4_skid_ready_flop
  or p4_pipe_rand_valid
  or p4_skid_valid
  or p4_pipe_rand_data
  or p4_skid_data
  ) begin
  p4_skid_pipe_valid = (p4_skid_ready_flop)? p4_pipe_rand_valid : p4_skid_valid; 
  // VCS sop_coverage_off start
  p4_skid_pipe_data = (p4_skid_ready_flop)? p4_pipe_rand_data : p4_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (4) valid-ready-bubble-collapse
always @(
  p4_pipe_ready
  or p4_pipe_valid
  ) begin
  p4_pipe_ready_bc = p4_pipe_ready || !p4_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_pipe_valid <= 1'b0;
  end else begin
  p4_pipe_valid <= (p4_pipe_ready_bc)? p4_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
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
  or cv_int_wr_req_ready
  or p4_pipe_data
  ) begin
  cv_int_wr_req_valid = p4_pipe_valid;
  p4_pipe_ready = cv_int_wr_req_ready;
  cv_int_wr_req_pd = p4_pipe_data;
end
//## pipe (4) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p4_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cv_int_wr_req_valid^cv_int_wr_req_ready^cv_dma_wr_req_vld^cv_dma_wr_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_20x (nvdla_core_clk, `ASSERT_RESET, (cv_dma_wr_req_vld && !cv_dma_wr_req_rdy), (cv_dma_wr_req_vld), (cv_dma_wr_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_BDMA_STORE_pipe_p4
#endif


//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_BDMA_STORE_lat_fifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus lat_fifo_wr -rd_pipebus lat_fifo_rd -rd_reg -d 245 -w 514 -ram ra2 [Chosen ram type: ra2 - ramgen_generic (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_BDMA_STORE_lat_fifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , lat_fifo_wr_prdy
    , lat_fifo_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , lat_fifo_wr_pause
`endif
    , lat_fifo_wr_pd
    , lat_fifo_rd_prdy
    , lat_fifo_rd_pvld
    , lat_fifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        lat_fifo_wr_prdy;
input         lat_fifo_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         lat_fifo_wr_pause;
`endif
input  [513:0] lat_fifo_wr_pd;
input         lat_fifo_rd_prdy;
output        lat_fifo_rd_pvld;
output [513:0] lat_fifo_rd_pd;
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
reg        lat_fifo_wr_busy_int;		        	// copy for internal use
assign     lat_fifo_wr_prdy = !lat_fifo_wr_busy_int;
assign       wr_reserving = lat_fifo_wr_pvld && !lat_fifo_wr_busy_int; // reserving write space?


reg        wr_popping;                          // fwd: write side sees pop?

reg  [7:0] lat_fifo_wr_count;			// write-side count

wire [7:0] wr_count_next_wr_popping = wr_reserving ? lat_fifo_wr_count : (lat_fifo_wr_count - 1'd1); // spyglass disable W164a W484
wire [7:0] wr_count_next_no_wr_popping = wr_reserving ? (lat_fifo_wr_count + 1'd1) : lat_fifo_wr_count; // spyglass disable W164a W484
wire [7:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_245 = ( wr_count_next_no_wr_popping == 8'd245 );
wire wr_count_next_is_245 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_245;
wire [7:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [7:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       lat_fifo_wr_busy_next = wr_count_next_is_245 || // busy next cycle?
                          (wr_limit_reg != 8'd0 &&      // check lat_fifo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg) || lat_fifo_wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       lat_fifo_wr_busy_next = wr_count_next_is_245 || // busy next cycle?
                          (wr_limit_reg != 8'd0 &&      // check lat_fifo_wr_limit if != 0
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
        lat_fifo_wr_busy_int <=  1'b0;
        lat_fifo_wr_count <=  8'd0;
    end else begin
	lat_fifo_wr_busy_int <=  lat_fifo_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    lat_fifo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            lat_fifo_wr_count <=  {8{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as lat_fifo_wr_pvld

//
// RAM
//

reg  [7:0] lat_fifo_wr_adr;			// current write address
wire [7:0] lat_fifo_rd_adr_p;		// read address to use for ram
wire [513:0] lat_fifo_rd_pd_p;		// read data directly out of ram

wire rd_enable;

wire ore;
wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


nv_ram_rwsp_245x514 #(`FORCE_CONTENTION_ASSERTION_RESET_ACTIVE) ram (
      .clk		 ( nvdla_core_clk )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .wa        ( lat_fifo_wr_adr )
    , .we        ( wr_pushing )
    , .di        ( lat_fifo_wr_pd )
    , .ra        ( lat_fifo_rd_adr_p )
    , .re        ( rd_enable )
    , .dout        ( lat_fifo_rd_pd_p )
    , .ore        ( ore )
    );
// next lat_fifo_wr_adr if wr_pushing=1
wire [7:0] wr_adr_next = (lat_fifo_wr_adr == 8'd244) ? 8'd0 : (lat_fifo_wr_adr + 1'd1);  // spyglass disable W484

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_fifo_wr_adr <=  8'd0;
    end else begin
        if ( wr_pushing ) begin
            lat_fifo_wr_adr      <=  wr_adr_next;
        end 
        //synopsys translate_off
            else if ( !(wr_pushing) ) begin
        end else begin
            lat_fifo_wr_adr   <=  {8{`x_or_0}};
        end
        //synopsys translate_on

    end 
end
// spyglass enable_block W484

wire   rd_popping;              // read side doing pop this cycle?
reg  [7:0] lat_fifo_rd_adr;		// current read address
// next    read address
wire [7:0] rd_adr_next = (lat_fifo_rd_adr == 8'd244) ? 8'd0 : (lat_fifo_rd_adr + 1'd1);   // spyglass disable W484
assign         lat_fifo_rd_adr_p = rd_popping ? rd_adr_next : lat_fifo_rd_adr; // for ram

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_fifo_rd_adr <=  8'd0;
    end else begin
        if ( rd_popping ) begin
	    lat_fifo_rd_adr      <=  rd_adr_next;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            lat_fifo_rd_adr <=  {8{`x_or_0}};
        end
        //synopsys translate_on

    end
end
// spyglass enable_block W484

//
// SYNCHRONOUS BOUNDARY
//


always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_popping <=  1'b0;
    end else begin
	wr_popping <=  rd_popping;  
    end
end


reg    rd_pushing;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rd_pushing <=  1'b0;
    end else begin
	rd_pushing <=  wr_pushing;  // let data go into ram first
    end
end

//
// READ SIDE
//

reg        lat_fifo_rd_pvld_p; 		// data out of fifo is valid

reg        lat_fifo_rd_pvld_int;			// internal copy of lat_fifo_rd_pvld
assign     lat_fifo_rd_pvld = lat_fifo_rd_pvld_int;
assign     rd_popping = lat_fifo_rd_pvld_p && !(lat_fifo_rd_pvld_int && !lat_fifo_rd_prdy);

reg  [7:0] lat_fifo_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [7:0] rd_count_p_next_rd_popping = rd_pushing ? lat_fifo_rd_count_p : 
                                                                (lat_fifo_rd_count_p - 1'd1);
wire [7:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (lat_fifo_rd_count_p + 1'd1) : 
                                                                    lat_fifo_rd_count_p;
// spyglass enable_block W164a W484
wire [7:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
wire rd_count_p_next_rd_popping_not_0 = rd_count_p_next_rd_popping != 0;
wire rd_count_p_next_no_rd_popping_not_0 = rd_count_p_next_no_rd_popping != 0;
wire rd_count_p_next_not_0 = rd_popping ? rd_count_p_next_rd_popping_not_0 :
                                              rd_count_p_next_no_rd_popping_not_0;
assign rd_enable = ((rd_count_p_next_not_0) && ((~lat_fifo_rd_pvld_p) || rd_popping));  // anytime data's there and not stalled
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_fifo_rd_count_p <=  8'd0;
        lat_fifo_rd_pvld_p <=  1'b0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    lat_fifo_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            lat_fifo_rd_count_p <=  {8{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing || rd_popping  ) begin
	    lat_fifo_rd_pvld_p   <=   (rd_count_p_next_not_0);
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            lat_fifo_rd_pvld_p   <=  `x_or_0;
        end
        //synopsys translate_on

    end
end
wire        rd_req_next = (lat_fifo_rd_pvld_p || (lat_fifo_rd_pvld_int && !lat_fifo_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        lat_fifo_rd_pvld_int <=  1'b0;
    end else begin
        lat_fifo_rd_pvld_int <=  rd_req_next;
    end
end
assign lat_fifo_rd_pd = lat_fifo_rd_pd_p;
assign ore = rd_popping;

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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || rd_popping || wr_popping || (lat_fifo_wr_pvld && !lat_fifo_wr_busy_int) || (lat_fifo_wr_busy_int != lat_fifo_wr_busy_next)) || (rd_pushing || rd_popping || (lat_fifo_rd_pvld_int && lat_fifo_rd_prdy) || wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_BDMA_STORE_lat_fifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_BDMA_STORE_lat_fifo_wr_limit : 8'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 8'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 8'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 8'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [7:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 8'd0;
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
    if ( $test$plusargs( "NV_NVDLA_BDMA_STORE_lat_fifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_BDMA_STORE_lat_fifo_wr_limit=%d", wr_limit_override_value);
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
    if ( $test$plusargs( "NV_NVDLA_BDMA_STORE_lat_fifo_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_BDMA_STORE_lat_fifo_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_BDMA_STORE_lat_fifo_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_BDMA_STORE_lat_fifo_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_BDMA_STORE_lat_fifo_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_BDMA_STORE_lat_fifo_fifo_stall_cycles_max=%d", stall_cycles_max);
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
    if ( ! $test$plusargs( "NV_NVDLA_BDMA_STORE_lat_fifo_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_BDMA_STORE_lat_fifo_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_BDMA_STORE_lat_fifo_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
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
            if ( lat_fifo_wr_pvld && !(!lat_fifo_wr_prdy)
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
    , .max      ( {24'd0, (wr_limit_reg == 8'd0) ? 8'd245 : wr_limit_reg} )
    , .curr	( {24'd0, lat_fifo_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_BDMA_STORE_lat_fifo") true
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


endmodule // NV_NVDLA_BDMA_STORE_lat_fifo



//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_BDMA_STORE_fifo_r2w -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus fifo_r2w_wr -rd_pipebus fifo_r2w_rd -rd_reg -d 4 -w 514 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_BDMA_STORE_fifo_r2w (
      nvdla_core_clk
    , nvdla_core_rstn
    , fifo_r2w_wr_prdy
    , fifo_r2w_wr_pvld
`ifdef FV_RAND_WR_PAUSE
    , fifo_r2w_wr_pause
`endif
    , fifo_r2w_wr_pd
    , fifo_r2w_rd_prdy
    , fifo_r2w_rd_pvld
    , fifo_r2w_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        fifo_r2w_wr_prdy;
input         fifo_r2w_wr_pvld;
`ifdef FV_RAND_WR_PAUSE
input         fifo_r2w_wr_pause;
`endif
input  [513:0] fifo_r2w_wr_pd;
input         fifo_r2w_rd_prdy;
output        fifo_r2w_rd_pvld;
output [513:0] fifo_r2w_rd_pd;
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
reg        fifo_r2w_wr_busy_int;		        	// copy for internal use
assign     fifo_r2w_wr_prdy = !fifo_r2w_wr_busy_int;
assign       wr_reserving = fifo_r2w_wr_pvld && !fifo_r2w_wr_busy_int; // reserving write space?


reg        wr_popping;                          // fwd: write side sees pop?

reg  [2:0] fifo_r2w_wr_count;			// write-side count

wire [2:0] wr_count_next_wr_popping = wr_reserving ? fifo_r2w_wr_count : (fifo_r2w_wr_count - 1'd1); // spyglass disable W164a W484
wire [2:0] wr_count_next_no_wr_popping = wr_reserving ? (fifo_r2w_wr_count + 1'd1) : fifo_r2w_wr_count; // spyglass disable W164a W484
wire [2:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_4 = ( wr_count_next_no_wr_popping == 3'd4 );
wire wr_count_next_is_4 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_4;
wire [2:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [2:0] wr_limit_reg = wr_limit_muxed;
`ifdef FV_RAND_WR_PAUSE
                          // VCS coverage off
wire       fifo_r2w_wr_busy_next = wr_count_next_is_4 || // busy next cycle?
                          (wr_limit_reg != 3'd0 &&      // check fifo_r2w_wr_limit if != 0
                           wr_count_next >= wr_limit_reg) || fifo_r2w_wr_pause;
                          // VCS coverage on
`else
                          // VCS coverage off
wire       fifo_r2w_wr_busy_next = wr_count_next_is_4 || // busy next cycle?
                          (wr_limit_reg != 3'd0 &&      // check fifo_r2w_wr_limit if != 0
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
        fifo_r2w_wr_busy_int <=  1'b0;
        fifo_r2w_wr_count <=  3'd0;
    end else begin
	fifo_r2w_wr_busy_int <=  fifo_r2w_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    fifo_r2w_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            fifo_r2w_wr_count <=  {3{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as fifo_r2w_wr_pvld

//
// RAM
//

reg  [1:0] fifo_r2w_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        fifo_r2w_wr_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    fifo_r2w_wr_adr <=  fifo_r2w_wr_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484


reg [1:0] fifo_r2w_rd_adr;          // read address this cycle
wire ram_we = wr_pushing;   // note: write occurs next cycle
wire [513:0] fifo_r2w_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_BDMA_STORE_fifo_r2w_flopram_rwsa_4x514 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( fifo_r2w_wr_pd )
    , .we        ( ram_we )
    , .wa        ( fifo_r2w_wr_adr )
    , .ra        ( fifo_r2w_rd_adr )
    , .dout        ( fifo_r2w_rd_pd_p )
    );

wire   rd_popping;              // read side doing pop this cycle?

wire [1:0] rd_adr_next_popping = fifo_r2w_rd_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        fifo_r2w_rd_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
	    fifo_r2w_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            fifo_r2w_rd_adr <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

//
// SYNCHRONOUS BOUNDARY
//


always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        wr_popping <=  1'b0;
    end else begin
	wr_popping <=  rd_popping;  
    end
end

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

reg        fifo_r2w_rd_pvld_p; 		// data out of fifo is valid

reg        fifo_r2w_rd_pvld_int;			// internal copy of fifo_r2w_rd_pvld
assign     fifo_r2w_rd_pvld = fifo_r2w_rd_pvld_int;
assign     rd_popping = fifo_r2w_rd_pvld_p && !(fifo_r2w_rd_pvld_int && !fifo_r2w_rd_prdy);

reg  [2:0] fifo_r2w_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [2:0] rd_count_p_next_rd_popping = rd_pushing ? fifo_r2w_rd_count_p : 
                                                                (fifo_r2w_rd_count_p - 1'd1);
wire [2:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (fifo_r2w_rd_count_p + 1'd1) : 
                                                                    fifo_r2w_rd_count_p;
// spyglass enable_block W164a W484
wire [2:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
wire rd_count_p_next_rd_popping_not_0 = rd_count_p_next_rd_popping != 0;
wire rd_count_p_next_no_rd_popping_not_0 = rd_count_p_next_no_rd_popping != 0;
wire rd_count_p_next_not_0 = rd_popping ? rd_count_p_next_rd_popping_not_0 :
                                              rd_count_p_next_no_rd_popping_not_0;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        fifo_r2w_rd_count_p <=  3'd0;
        fifo_r2w_rd_pvld_p <=  1'b0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    fifo_r2w_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            fifo_r2w_rd_count_p <=  {3{`x_or_0}};
        end
        //synopsys translate_on

        if ( rd_pushing || rd_popping  ) begin
	    fifo_r2w_rd_pvld_p   <=   (rd_count_p_next_not_0);
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            fifo_r2w_rd_pvld_p   <=  `x_or_0;
        end
        //synopsys translate_on

    end
end
reg [513:0]  fifo_r2w_rd_pd;         // output data register
wire        rd_req_next = (fifo_r2w_rd_pvld_p || (fifo_r2w_rd_pvld_int && !fifo_r2w_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        fifo_r2w_rd_pvld_int <=  1'b0;
    end else begin
        fifo_r2w_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        fifo_r2w_rd_pd <=  fifo_r2w_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        fifo_r2w_rd_pd <=  {514{`x_or_0}};
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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || rd_popping || wr_popping || (fifo_r2w_wr_pvld && !fifo_r2w_wr_busy_int) || (fifo_r2w_wr_busy_int != fifo_r2w_wr_busy_next)) || (rd_pushing || rd_popping || (fifo_r2w_rd_pvld_int && fifo_r2w_rd_prdy)) || (wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_BDMA_STORE_fifo_r2w_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_BDMA_STORE_fifo_r2w_wr_limit : 3'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 3'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 3'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 3'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [2:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 3'd0;
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
    if ( $test$plusargs( "NV_NVDLA_BDMA_STORE_fifo_r2w_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_BDMA_STORE_fifo_r2w_wr_limit=%d", wr_limit_override_value);
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
    if ( $test$plusargs( "NV_NVDLA_BDMA_STORE_fifo_r2w_fifo_stall_probability" ) ) begin
        $value$plusargs( "NV_NVDLA_BDMA_STORE_fifo_r2w_fifo_stall_probability=%d", stall_probability);
    end else if ( $test$plusargs( "default_fifo_stall_probability" ) ) begin
        $value$plusargs( "default_fifo_stall_probability=%d", stall_probability);
    end

    if ( $test$plusargs( "NV_NVDLA_BDMA_STORE_fifo_r2w_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "NV_NVDLA_BDMA_STORE_fifo_r2w_fifo_stall_cycles_min=%d", stall_cycles_min);
    end else if ( $test$plusargs( "default_fifo_stall_cycles_min" ) ) begin
        $value$plusargs( "default_fifo_stall_cycles_min=%d", stall_cycles_min);
    end

    if ( $test$plusargs( "NV_NVDLA_BDMA_STORE_fifo_r2w_fifo_stall_cycles_max" ) ) begin
        $value$plusargs( "NV_NVDLA_BDMA_STORE_fifo_r2w_fifo_stall_cycles_max=%d", stall_cycles_max);
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
    if ( ! $test$plusargs( "NV_NVDLA_BDMA_STORE_fifo_r2w_fifo_stall_probability" ) ) stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_probability; 
    if ( ! $test$plusargs( "NV_NVDLA_BDMA_STORE_fifo_r2w_fifo_stall_cycles_min"  ) ) stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_min;
    if ( ! $test$plusargs( "NV_NVDLA_BDMA_STORE_fifo_r2w_fifo_stall_cycles_max"  ) ) stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_fifo_cycles_max;
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
            if ( fifo_r2w_wr_pvld && !(!fifo_r2w_wr_prdy)
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
    , .max      ( {29'd0, (wr_limit_reg == 3'd0) ? 3'd4 : wr_limit_reg} )
    , .curr	( {29'd0, fifo_r2w_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_BDMA_STORE_fifo_r2w") true
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


endmodule // NV_NVDLA_BDMA_STORE_fifo_r2w

// 
// Flop-Based RAM 
//
module NV_NVDLA_BDMA_STORE_fifo_r2w_flopram_rwsa_4x514 (
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
input  [513:0] di;
input  we;
input  [1:0] wa;
input  [1:0] ra;
output [513:0] dout;

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

`ifdef EMU


// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [513:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_BDMA_STORE_fifo_r2w_flopram_rwsa_4x514 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra ) 
   , .Do0( dout )
   );

`else

reg [513:0] ram_ff0;
reg [513:0] ram_ff1;
reg [513:0] ram_ff2;
reg [513:0] ram_ff3;

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
    if ( we && wa == 2'd3 ) begin
	ram_ff3 <=  di;
    end
end

reg [513:0] dout;

always @(*) begin
    case( ra ) 
    2'd0:       dout = ram_ff0;
    2'd1:       dout = ram_ff1;
    2'd2:       dout = ram_ff2;
    2'd3:       dout = ram_ff3;
    //VCS coverage off
    default:    dout = {514{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_BDMA_STORE_fifo_r2w_flopram_rwsa_4x514

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_BDMA_STORE_fifo_r2w_flopram_rwsa_4x514 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [513:0] Di0;
input  [1:0] Ra0;
output [513:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 514'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [513:0] mem[3:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [513:0] Q0 = mem[0];
wire [513:0] Q1 = mem[1];
wire [513:0] Q2 = mem[2];
wire [513:0] Q3 = mem[3];
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

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_BDMA_STORE_fifo_r2w_flopram_rwsa_4x514] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_BDMA_STORE_fifo_r2w_flopram_rwsa_4x514] }
endmodule // vmw_NV_NVDLA_BDMA_STORE_fifo_r2w_flopram_rwsa_4x514

//vmw: Memory vmw_NV_NVDLA_BDMA_STORE_fifo_r2w_flopram_rwsa_4x514
//vmw: Address-size 2
//vmw: Data-size 514
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[513:0] data0[513:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[513:0] data1[513:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_BDMA_STORE_fifo_r2w_flopram_rwsa_4x514
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU

//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_BDMA_STORE_fifo_intr -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus fifo_intr_wr -rd_pipebus fifo_intr_rd -ram_bypass -d 0 -rd_reg -wr_idle -rd_busy_reg -no_wr_busy -w 1 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_BDMA_STORE_fifo_intr (
      nvdla_core_clk
    , nvdla_core_rstn
    , fifo_intr_wr_idle
    , fifo_intr_wr_pvld
    , fifo_intr_wr_pd
    , fifo_intr_rd_prdy
    , fifo_intr_rd_pvld
    , fifo_intr_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        fifo_intr_wr_idle;
input         fifo_intr_wr_pvld;
input         fifo_intr_wr_pd;
input         fifo_intr_rd_prdy;
output        fifo_intr_rd_pvld;
output        fifo_intr_rd_pd;
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
wire [0:0] fifo_intr_rd_pd_p = fifo_intr_wr_pd;

//
// SYNCHRONOUS BOUNDARY
//

//
// NOTE: 0-depth fifo has no real boundary between write and read sides
//


//
// READ SIDE
//

reg        fifo_intr_rd_prdy_d;				// fifo_intr_rd_prdy registered in cleanly

always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        fifo_intr_rd_prdy_d <=  1'b1;
    end else begin
        fifo_intr_rd_prdy_d <=  fifo_intr_rd_prdy;
    end
end

wire       fifo_intr_rd_prdy_d_o;			// combinatorial rd_busy

reg        fifo_intr_rd_pvld_int;			// internal copy of fifo_intr_rd_pvld

assign     fifo_intr_rd_pvld = fifo_intr_rd_pvld_int;
wire       fifo_intr_rd_pvld_p = fifo_intr_wr_pvld ; 		// no real fifo, take from write-side input
reg        fifo_intr_rd_pvld_int_o;	// internal copy of fifo_intr_rd_pvld_o
wire       fifo_intr_rd_pvld_o = fifo_intr_rd_pvld_int_o;
wire       rd_popping = fifo_intr_rd_pvld_p && !(fifo_intr_rd_pvld_int_o && !fifo_intr_rd_prdy_d_o);


// 
// SKID for -rd_busy_reg
//
reg  fifo_intr_rd_pd_o;         // output data register
wire        rd_req_next_o = (fifo_intr_rd_pvld_p || (fifo_intr_rd_pvld_int_o && !fifo_intr_rd_prdy_d_o)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        fifo_intr_rd_pvld_int_o <=  1'b0;
    end else begin
        fifo_intr_rd_pvld_int_o <=  rd_req_next_o;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (fifo_intr_rd_pvld_int && rd_req_next_o && rd_popping) ) begin
        fifo_intr_rd_pd_o <=  fifo_intr_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((fifo_intr_rd_pvld_int && rd_req_next_o && rd_popping)) ) begin
    end else begin
        fifo_intr_rd_pd_o <=  {1{`x_or_0}};
    end
    //synopsys translate_on

end

//
// FINAL OUTPUT
//
reg  fifo_intr_rd_pd;				// output data register
reg        fifo_intr_rd_pvld_int_d;			// so we can bubble-collapse fifo_intr_rd_prdy_d
assign     fifo_intr_rd_prdy_d_o = !((fifo_intr_rd_pvld_o && fifo_intr_rd_pvld_int_d && !fifo_intr_rd_prdy_d ) );
wire       rd_req_next = (!fifo_intr_rd_prdy_d_o ? fifo_intr_rd_pvld_o : fifo_intr_rd_pvld_p) ;  

always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        fifo_intr_rd_pvld_int <=  1'b0;
        fifo_intr_rd_pvld_int_d <=  1'b0;
    end else begin
        if ( !fifo_intr_rd_pvld_int || fifo_intr_rd_prdy ) begin
	    fifo_intr_rd_pvld_int <=  rd_req_next;
        end
        //synopsys translate_off
            else if ( !(!fifo_intr_rd_pvld_int || fifo_intr_rd_prdy) ) begin
        end else begin
            fifo_intr_rd_pvld_int <=  `x_or_0;
        end
        //synopsys translate_on


        fifo_intr_rd_pvld_int_d <=  fifo_intr_rd_pvld_int;
    end
end

always @( posedge nvdla_core_clk ) begin
    if ( rd_req_next && (!fifo_intr_rd_pvld_int || fifo_intr_rd_prdy ) ) begin
        case (!fifo_intr_rd_prdy_d_o) 
            1'b0:    fifo_intr_rd_pd <=  fifo_intr_rd_pd_p;
            1'b1:    fifo_intr_rd_pd <=  fifo_intr_rd_pd_o;
            //VCS coverage off
            default: fifo_intr_rd_pd <=  {1{`x_or_0}};
            //VCS coverage on
        endcase
    end
    //synopsys translate_off
        else if ( !(rd_req_next && (!fifo_intr_rd_pvld_int || fifo_intr_rd_prdy)) ) begin
    end else begin
        fifo_intr_rd_pd <=  {1{`x_or_0}};
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
//
// Read-side Idle Calculation
//
wire   rd_idle = !fifo_intr_rd_pvld_int_o && !fifo_intr_rd_pvld_int;


//
// Write-Side Idle Calculation
//
wire fifo_intr_wr_idle_d0 = !fifo_intr_wr_pvld && rd_idle;
wire fifo_intr_wr_idle = fifo_intr_wr_idle_d0;


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
assign nvdla_core_clk_mgated_enable = ((1'b0) || (fifo_intr_wr_pvld || (fifo_intr_rd_pvld_int && fifo_intr_rd_prdy_d) || (fifo_intr_rd_pvld_int_o && fifo_intr_rd_prdy_d_o)))
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
//   set_boundary_optimization find(design, "NV_NVDLA_BDMA_STORE_fifo_intr") true
// synopsys dc_script_end


endmodule // NV_NVDLA_BDMA_STORE_fifo_intr

