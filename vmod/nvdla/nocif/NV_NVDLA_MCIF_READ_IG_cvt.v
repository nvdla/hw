// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_MCIF_READ_IG_cvt.v

`include "simulate_x_tick.vh"
module NV_NVDLA_MCIF_READ_IG_cvt (
   nvdla_core_clk                           //|< i
  ,nvdla_core_rstn                          //|< i
  ,reg2dp_rd_os_cnt                         //|< i
#if (NVDLA_PRIMARY_MEMIF_WIDTH > NVDLA_MEMORY_ATOMIC_WIDTH)
  ,cq_wr_pd                                 //|> o
  ,cq_wr_pvld                               //|> o
  ,cq_wr_prdy                               //|< i
  ,cq_wr_thread_id                          //|> o
#endif
  ,eg2ig_axi_vld                            //|< i
  ,spt2cvt_req_pd                           //|< i
  ,spt2cvt_req_valid                        //|< i
  ,spt2cvt_req_ready                        //|> o
  ,mcif2noc_axi_ar_araddr                   //|> o
  ,mcif2noc_axi_ar_arid                     //|> o
  ,mcif2noc_axi_ar_arlen                    //|> o
  ,mcif2noc_axi_ar_arvalid                  //|> o
  ,mcif2noc_axi_ar_arready                  //|< i
  );
//
// NV_NVDLA_MCIF_READ_IG_cvt_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;
input   [7:0] reg2dp_rd_os_cnt;

output        mcif2noc_axi_ar_arvalid;   
input         mcif2noc_axi_ar_arready;   
output [NVDLA_MEM_ADDRESS_WIDTH-1:0] mcif2noc_axi_ar_araddr;
output  [7:0] mcif2noc_axi_ar_arid;
output  [3:0] mcif2noc_axi_ar_arlen;

input         spt2cvt_req_valid;  
output        spt2cvt_req_ready;  
input  [NVDLA_MEM_ADDRESS_WIDTH+10:0] spt2cvt_req_pd;

input         eg2ig_axi_vld;
#if (NVDLA_PRIMARY_MEMIF_WIDTH > NVDLA_MEMORY_ATOMIC_WIDTH)
output       cq_wr_pvld;       
input        cq_wr_prdy;       
output [6:0] cq_wr_pd;
output [3:0] cq_wr_thread_id;

wire    [2:0] stt_offset;
wire    [2:0] end_offset;
wire          stt_addr_is_32_align;
wire          end_addr_is_32_align;
wire          inc;
wire          mon_axi_len_c;
wire          mon_end_offset_c;
#endif

reg           eg2ig_axi_vld_d;
reg           os_adv;
reg     [8:0] os_cnt;
reg     [8:0] os_cnt_cur;
reg    [10:0] os_cnt_ext;
reg    [10:0] os_cnt_mod;
reg    [10:0] os_cnt_new;
reg    [10:0] os_cnt_nxt;
wire    [2:0] os_cnt_add;
wire          os_cnt_add_en;
wire          os_cnt_cen;
wire          os_cnt_full;
wire    [0:0] os_cnt_sub;
wire          os_cnt_sub_en;
wire    [2:0] os_inp_add_nxt;
wire    [9:0] os_inp_nxt;
wire    [0:0] os_inp_sub_nxt;
wire    [8:0] rd_os_cnt_ext;
wire    [7:0] cfg_rd_os_cnt;

wire   [NVDLA_MEM_ADDRESS_WIDTH-1:0] axi_addr;
wire    [3:0] axi_axid;
wire   [NVDLA_MEM_ADDRESS_WIDTH+5:0] axi_cmd_pd;
wire          axi_cmd_rdy;
wire          axi_cmd_vld;
wire    [1:0] axi_len;
wire   [NVDLA_MEM_ADDRESS_WIDTH-1:0] cmd_addr;
wire    [3:0] cmd_axid;
wire          cmd_ftran;
wire          cmd_ltran;
wire          cmd_odd;
wire    [2:0] cmd_size;
wire          cmd_swizzle;
wire          cmd_vld;
wire          cmd_rdy;

wire   [NVDLA_MEM_ADDRESS_WIDTH-1:0] opipe_axi_addr;
wire    [3:0] opipe_axi_axid;
wire    [1:0] opipe_axi_len;
wire   [NVDLA_MEM_ADDRESS_WIDTH+5:0] opipe_axi_pd;
wire          opipe_axi_rdy;
wire          opipe_axi_vld;


assign    cmd_vld = spt2cvt_req_valid;
assign    spt2cvt_req_ready = cmd_rdy;

assign    cmd_axid[3:0] =  spt2cvt_req_pd[3:0];
assign    cmd_addr[NVDLA_MEM_ADDRESS_WIDTH-1:0] =  spt2cvt_req_pd[NVDLA_MEM_ADDRESS_WIDTH+3:4];
assign    cmd_size[2:0] = spt2cvt_req_pd[NVDLA_MEM_ADDRESS_WIDTH+6:NVDLA_MEM_ADDRESS_WIDTH+4];
assign    cmd_swizzle  =  spt2cvt_req_pd[NVDLA_MEM_ADDRESS_WIDTH+7];
assign    cmd_odd    =    spt2cvt_req_pd[NVDLA_MEM_ADDRESS_WIDTH+8];
assign    cmd_ltran  =    spt2cvt_req_pd[NVDLA_MEM_ADDRESS_WIDTH+9];
assign    cmd_ftran  =    spt2cvt_req_pd[NVDLA_MEM_ADDRESS_WIDTH+10];


#if (NVDLA_PRIMARY_MEMIF_WIDTH > NVDLA_MEMORY_ATOMIC_WIDTH)
assign stt_offset = cmd_addr[7:5]; 
assign {mon_end_offset_c,end_offset[2:0]} = stt_offset + cmd_size;
assign stt_addr_is_32_align = (stt_offset[0]== 1'b1 );
assign end_addr_is_32_align = (end_offset[0]== 1'b0 );
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
  nv_assert_never #(0,0,"end address should never cross 256B address boundary")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, mon_end_offset_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign inc = cmd_ftran & cmd_ltran & (cmd_size[0]==1) & cmd_swizzle;
assign {mon_axi_len_c, axi_len[1:0]}  = cmd_size[2:1] + inc;
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
  nv_assert_never #(0,0,"Should not be overflow")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, mon_axi_len_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign   cq_wr_pvld = cmd_vld & axi_cmd_rdy & !os_cnt_full;
assign   cq_wr_pd[1:0] =  axi_len[1:0];
assign   cq_wr_pd[2] =    cmd_swizzle ;
assign   cq_wr_pd[3] =    cmd_odd ;
assign   cq_wr_pd[4] =    cmd_ltran ;
assign   cq_wr_pd[5] =    cmd_ftran & stt_addr_is_32_align;
assign   cq_wr_pd[6] =    cmd_ltran & end_addr_is_32_align;
assign   cq_wr_thread_id = cmd_axid;

assign   axi_cmd_vld = cmd_vld & cq_wr_prdy & !os_cnt_full; 
assign   cmd_rdy = axi_cmd_rdy & cq_wr_prdy & !os_cnt_full;

#else
assign   axi_cmd_vld = cmd_vld & !os_cnt_full; 
assign   cmd_rdy = axi_cmd_rdy & !os_cnt_full;

assign   axi_len  = cmd_size[1:0];   //fixmefixme
#endif
assign   axi_axid = cmd_axid;
assign   axi_addr = {cmd_addr[NVDLA_MEM_ADDRESS_WIDTH-1:NVDLA_MEMORY_ATOMIC_LOG2],{NVDLA_MEMORY_ATOMIC_LOG2{1'b0}}}; 


assign os_inp_add_nxt[2:0] = cmd_vld ? (axi_len + 1) : 3'd0;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
       eg2ig_axi_vld_d <= 1'b0;
  end else begin
       eg2ig_axi_vld_d <= eg2ig_axi_vld;
  end
end
assign os_inp_sub_nxt[0:0] = eg2ig_axi_vld_d ? 1'd1 : 1'd0;
assign os_inp_nxt[9:0] = os_cnt + os_inp_add_nxt - os_inp_sub_nxt;


// 256 outstanding trans
assign os_cnt_add_en = axi_cmd_vld & axi_cmd_rdy;
assign os_cnt_sub_en = eg2ig_axi_vld_d;
assign os_cnt_cen = os_cnt_add_en | os_cnt_sub_en;
assign os_cnt_add = os_cnt_add_en ? (axi_len + 1) : 3'd0;
assign os_cnt_sub = os_cnt_sub_en ? 1'd1 : 1'd0;
assign cfg_rd_os_cnt = reg2dp_rd_os_cnt[7:0];
assign rd_os_cnt_ext = {{1{1'b0}}, cfg_rd_os_cnt};
assign os_cnt_full = os_inp_nxt > (rd_os_cnt_ext + 1);

// os adv logic
always @(
  os_cnt_add
  or os_cnt_sub
  ) begin
  os_adv = os_cnt_add[2:0] != {{2{1'b0}}, os_cnt_sub[0:0]};
end
    
// os cnt logic
always @(
  os_cnt_cur
  or os_cnt_add
  or os_cnt_sub
  or os_adv
  ) begin
  os_cnt_ext[10:0] = {1'b0, 1'b0, os_cnt_cur};
  os_cnt_mod[10:0] = os_cnt_cur + os_cnt_add[2:0] - os_cnt_sub[0:0]; // spyglass disable W164b 
  os_cnt_new[10:0] = (os_adv)? os_cnt_mod[10:0] : os_cnt_ext[10:0];
  os_cnt_nxt[10:0] = os_cnt_new[10:0];
end

// os flops
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
      os_cnt_cur[8:0] <= 0;
  end else begin
  if (os_cnt_cen) begin
      os_cnt_cur[8:0] <= os_cnt_nxt[8:0];
  end
  end
end

// os output logic
always @(
  os_cnt_cur
  ) begin
  os_cnt[8:0] = os_cnt_cur[8:0];
end
    
// os asserts
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
  nv_assert_never #(0,0,"never: counter overflow beyond <ovr_cnt>")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, (os_cnt_nxt > NVDLA_MCIF_BURST_SIZE && os_cnt_cen)); //fixme // spyglass disable W504 SelfDeterminedExpr-ML 
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


NV_NVDLA_MCIF_READ_IG_CVT_pipe_p1  pipe_p1 (
   .nvdla_core_clk  (nvdla_core_clk)     //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)    //|< i
  ,.axi_cmd_pd      (axi_cmd_pd)         //|< w
  ,.axi_cmd_vld     (axi_cmd_vld)        //|< w
  ,.axi_cmd_rdy     (axi_cmd_rdy)        //|> w
  ,.opipe_axi_pd    (opipe_axi_pd)       //|> w
  ,.opipe_axi_vld   (opipe_axi_vld)      //|> w
  ,.opipe_axi_rdy   (opipe_axi_rdy)      //|< w
  );


assign axi_cmd_pd = {axi_axid,axi_addr,axi_len};

assign {opipe_axi_axid,opipe_axi_addr,opipe_axi_len} = opipe_axi_pd;

assign mcif2noc_axi_ar_arid     = {{4{1'b0}}, opipe_axi_axid};
assign mcif2noc_axi_ar_araddr   = opipe_axi_addr;
assign mcif2noc_axi_ar_arlen    = {{2{1'b0}}, opipe_axi_len};
assign mcif2noc_axi_ar_arvalid  = opipe_axi_vld;
assign opipe_axi_rdy            = mcif2noc_axi_ar_arready;

 

endmodule // NV_NVDLA_MCIF_READ_IG_cvt



// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -is opipe_axi_pd (opipe_axi_vld,opipe_axi_rdy) <= axi_cmd_pd[NVDLA_MEM_ADDRESS_WIDTH+5:0] (axi_cmd_vld,axi_cmd_rdy)
// **************************************************************************************************************
module NV_NVDLA_MCIF_READ_IG_CVT_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,axi_cmd_pd
  ,axi_cmd_vld
  ,axi_cmd_rdy
  ,opipe_axi_pd
  ,opipe_axi_vld
  ,opipe_axi_rdy
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [NVDLA_MEM_ADDRESS_WIDTH+5:0] axi_cmd_pd;
input         axi_cmd_vld;
output        axi_cmd_rdy;
output [NVDLA_MEM_ADDRESS_WIDTH+5:0] opipe_axi_pd;
output        opipe_axi_vld;
input         opipe_axi_rdy;

//: my $w = eval(NVDLA_MEM_ADDRESS_WIDTH+6);
//: &eperl::pipe(" -wid $w -is -do opipe_axi_pd -vo opipe_axi_vld -ri opipe_axi_rdy -di axi_cmd_pd -vi axi_cmd_vld -ro axi_cmd_rdy");


endmodule // NV_NVDLA_MCIF_READ_IG_CVT_pipe_p1


