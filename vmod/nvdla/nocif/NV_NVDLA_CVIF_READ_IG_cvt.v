// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CVIF_READ_IG_cvt.v

`include "simulate_x_tick.vh"
module NV_NVDLA_CVIF_READ_IG_cvt (
   nvdla_core_clk          //|< i
  ,nvdla_core_rstn         //|< i
  ,cq_wr_prdy              //|< i
  ,cvif2noc_axi_ar_arready //|< i
  ,eg2ig_axi_vld           //|< i
  ,reg2dp_rd_os_cnt        //|< i
  ,spt2cvt_req_pd          //|< i
  ,spt2cvt_req_valid       //|< i
  ,cq_wr_pd                //|> o
  ,cq_wr_pvld              //|> o
  ,cq_wr_thread_id         //|> o
  ,cvif2noc_axi_ar_araddr  //|> o
  ,cvif2noc_axi_ar_arid    //|> o
  ,cvif2noc_axi_ar_arlen   //|> o
  ,cvif2noc_axi_ar_arvalid //|> o
  ,spt2cvt_req_ready       //|> o
  );
//
// NV_NVDLA_CVIF_READ_IG_cvt_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         spt2cvt_req_valid;  /* data valid */
output        spt2cvt_req_ready;  /* data return handshake */
input  [74:0] spt2cvt_req_pd;

output       cq_wr_pvld;       /* data valid */
input        cq_wr_prdy;       /* data return handshake */
output [3:0] cq_wr_thread_id;
output [6:0] cq_wr_pd;

output        cvif2noc_axi_ar_arvalid;  /* data valid */
input         cvif2noc_axi_ar_arready;  /* data return handshake */
output  [7:0] cvif2noc_axi_ar_arid;
output  [3:0] cvif2noc_axi_ar_arlen;
output [63:0] cvif2noc_axi_ar_araddr;

//&Ports /streamid/; //stepheng,remove
input  [7:0] reg2dp_rd_os_cnt;
input        eg2ig_axi_vld;
reg          eg2ig_axi_vld_d;
reg          os_adv;
reg    [8:0] os_cnt;
reg    [8:0] os_cnt_cur;
reg   [10:0] os_cnt_ext;
reg   [10:0] os_cnt_mod;
reg   [10:0] os_cnt_new;
reg   [10:0] os_cnt_nxt;
wire  [63:0] axi_addr;
wire   [3:0] axi_axid;
wire  [69:0] axi_cmd_pd;
wire         axi_cmd_rdy;
wire         axi_cmd_vld;
wire   [1:0] axi_len;
wire   [7:0] cfg_rd_os_cnt;
wire  [63:0] cmd_addr;
wire   [3:0] cmd_axid;
wire         cmd_ftran;
wire         cmd_ltran;
wire         cmd_odd;
wire         cmd_rdy;
wire   [2:0] cmd_size;
wire         cmd_swizzle;
wire         cmd_vld;
wire         end_addr_is_32_align;
wire   [2:0] end_offset;
wire   [1:0] end_offset_2_1_NC;
wire         ig2cq_fdrop;
wire         ig2cq_ldrop;
wire   [1:0] ig2cq_lens;
wire         ig2cq_ltran;
wire         ig2cq_odd;
wire         ig2cq_swizzle;
wire         inc;
wire         mon_axi_len_c;
wire         mon_end_offset_c;
wire  [63:0] opipe_axi_addr;
wire   [3:0] opipe_axi_axid;
wire   [1:0] opipe_axi_len;
wire  [69:0] opipe_axi_pd;
wire         opipe_axi_rdy;
wire         opipe_axi_vld;
wire   [2:0] os_cnt_add;
wire         os_cnt_add_en;
wire         os_cnt_cen;
wire         os_cnt_full;
wire   [0:0] os_cnt_sub;
wire         os_cnt_sub_en;
wire   [2:0] os_inp_add_nxt;
wire   [9:0] os_inp_nxt;
wire   [0:0] os_inp_sub_nxt;
wire   [8:0] rd_os_cnt_ext;
wire         stt_addr_is_32_align;
wire   [2:0] stt_offset;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
// IG===UNPACK

assign cmd_vld = spt2cvt_req_valid;
assign spt2cvt_req_ready = cmd_rdy;

// PKT_UNPACK_WIRE( cvt_read_cmd , cmd_ , spt2cvt_req_pd )
assign       cmd_axid[3:0] =    spt2cvt_req_pd[3:0];
assign       cmd_addr[63:0] =    spt2cvt_req_pd[67:4];
assign       cmd_size[2:0] =    spt2cvt_req_pd[70:68];
assign        cmd_swizzle  =    spt2cvt_req_pd[71];
assign        cmd_odd  =    spt2cvt_req_pd[72];
assign        cmd_ltran  =    spt2cvt_req_pd[73];
assign        cmd_ftran  =    spt2cvt_req_pd[74];

// IG===address calculation
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
  nv_assert_never #(0,0,"5 bit of addr LSB should always be 0")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, (|cmd_addr[4:0]== 1'b1 )); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign stt_offset = cmd_addr[7:5]; // start position within a 256B block

assign stt_addr_is_32_align = (stt_offset[0]== 1'b1 );

assign {mon_end_offset_c,end_offset[2:0]} = stt_offset + cmd_size;
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
assign end_offset_2_1_NC = end_offset[2:1]; // only need end_offset bit0 to know end addr alignment
assign end_addr_is_32_align = (end_offset[0]== 1'b0 );

// IG===AXI Trans GEN
assign axi_axid   = cmd_axid;
//assign axi_addr = cmd_addr & 40'hff_ffff_ffc0; // make [5:0]=0
assign axi_addr = cmd_addr & 64'hffff_ffff_ffff_ffc0; // stepheng, ake [5:0]=0
//assign axi_size = AXSIZE_64; //stepheng. remove
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

//assign axi_user_size = cmd_user_size; //stepheng,remove

//assign axi_streamid = falcon2cvif_streamid; //stepheng,remove.

// IG===Context Queue
// ( Upp,Low)    10   11     00   01
// Count
// 0:            F           1M    L
// 1:            F+1M F+L    2M 1M+L
// 2:            F+2M F+1M+L 3M 2M+L
// 3:            F+3M F+2M+L 4M 3M+L
assign cq_wr_pvld = cmd_vld & axi_cmd_rdy & !os_cnt_full; // inter-lock with opipe

assign ig2cq_lens  = axi_len;
assign ig2cq_swizzle = cmd_swizzle;
assign ig2cq_ltran = cmd_ltran;
assign ig2cq_odd   = cmd_odd;
assign ig2cq_fdrop = cmd_ftran & stt_addr_is_32_align;
assign ig2cq_ldrop = cmd_ltran & end_addr_is_32_align;
//assign cq_wr_pd = {ig2cq_cnt,ig2cq_upp,ig2cq_low};

// PKT_PACK_WIRE( nocif_read_ig2eg , ig2cq_ , cq_wr_pd )
assign      cq_wr_pd[1:0] =    ig2cq_lens[1:0];
assign      cq_wr_pd[2] =    ig2cq_swizzle ;
assign      cq_wr_pd[3] =    ig2cq_odd ;
assign      cq_wr_pd[4] =    ig2cq_ltran ;
assign      cq_wr_pd[5] =    ig2cq_fdrop ;
assign      cq_wr_pd[6] =    ig2cq_ldrop ;

assign cq_wr_thread_id = cmd_axid;

// IG===AXI OUT PIPE
assign axi_cmd_vld = cmd_vld & cq_wr_prdy & !os_cnt_full; // inter-lock with context-queue
assign cmd_rdy = axi_cmd_rdy & cq_wr_prdy & !os_cnt_full;

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
  // VCS sop_coverage_off start
  os_cnt_ext[10:0] = {1'b0, 1'b0, os_cnt_cur};
  os_cnt_mod[10:0] = os_cnt_cur + os_cnt_add[2:0] - os_cnt_sub[0:0]; // spyglass disable W164b
  os_cnt_new[10:0] = (os_adv)? os_cnt_mod[10:0] : os_cnt_ext[10:0];
  os_cnt_nxt[10:0] = os_cnt_new[10:0];
  // VCS sop_coverage_off end
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
  nv_assert_never #(0,0,"never: counter overflow beyond <ovr_cnt>")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, (os_cnt_nxt > 256 && os_cnt_cen)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

  
//stepheng.
NV_NVDLA_CVIF_READ_IG_CVT_pipe_p1 pipe_p1 (
   .nvdla_core_clk  (nvdla_core_clk)     //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)    //|< i
  ,.axi_cmd_pd      (axi_cmd_pd[69:0])   //|< w
  ,.axi_cmd_vld     (axi_cmd_vld)        //|< w
  ,.opipe_axi_rdy   (opipe_axi_rdy)      //|< w
  ,.axi_cmd_rdy     (axi_cmd_rdy)        //|> w
  ,.opipe_axi_pd    (opipe_axi_pd[69:0]) //|> w
  ,.opipe_axi_vld   (opipe_axi_vld)      //|> w
  );

//stepheng,remove streamid & user_size & axi_size
assign axi_cmd_pd = {axi_axid,axi_addr,axi_len};

assign {opipe_axi_axid,opipe_axi_addr,opipe_axi_len} = opipe_axi_pd;


// IG===AXI OUT ZERO EXT
assign cvif2noc_axi_ar_arid     = {{4{1'b0}}, opipe_axi_axid}; 
assign cvif2noc_axi_ar_araddr   = opipe_axi_addr;
assign cvif2noc_axi_ar_arlen    = {{2{1'b0}}, opipe_axi_len};//stepheng
//assign cvif2noc_axi_ar_arsize   = opipe_axi_size;

//stepheng,remove
//// USER BITS
//&Always;
//    cvif2noc_axi_ar_aruser[PKT_arnv_user_t_ALL_BITS] = 0;
//    cvif2noc_axi_ar_aruser[PKT_arnv_user_t_StreamID_FIELD] = opipe_axi_streamid; 
//    cvif2noc_axi_ar_aruser[PKT_arnv_user_t_user_size_FIELD] = opipe_axi_user_size; 
//    cvif2noc_axi_ar_aruser[PKT_arnv_user_t_vpr_rd_FIELD] = USER_VPR_RD;  // vpr_rd
//    cvif2noc_axi_ar_aruser[PKT_arnv_user_t_rsb_ns_FIELD] = USER_RSB_NS;  // rsb_ns
//&End;

//stepheng,remove tie off.
//// IG===AXI OUT TIEOFF
//assign cvif2noc_axi_ar_arburst  = AXBURST;
//assign cvif2noc_axi_ar_arlock   = AXLOCK;
//assign cvif2noc_axi_ar_arcache  = AXCACHE;
//assign cvif2noc_axi_ar_arprot   = AXPROT;
//assign cvif2noc_axi_ar_arqos    = AXQOS;
//assign cvif2noc_axi_ar_arregion = AXREGION;

// IG===AXI OUT valid/ready
assign cvif2noc_axi_ar_arvalid  = opipe_axi_vld;
assign opipe_axi_rdy            = cvif2noc_axi_ar_arready;

//==========================================
// OBS
//assign obs_bus_cvif_read_ig_cvt_axi_cmd_rdy       =  axi_cmd_rdy; 
//assign obs_bus_cvif_read_ig_cvt_axi_cmd_vld       =  axi_cmd_vld; 
//assign obs_bus_cvif_read_ig_cvt_ig2cq_fdrop       =  ig2cq_fdrop;
//assign obs_bus_cvif_read_ig_cvt_ig2cq_ldrop       =  ig2cq_ldrop; 
//assign obs_bus_cvif_read_ig_cvt_ig2cq_lens        =  ig2cq_lens; 
//assign obs_bus_cvif_read_ig_cvt_ig2cq_ltran       =  ig2cq_ltran; 
//assign obs_bus_cvif_read_ig_cvt_ig2cq_odd         =  ig2cq_odd; 
//assign obs_bus_cvif_read_ig_cvt_ig2cq_prdy        =  cq_wr_prdy; 
//assign obs_bus_cvif_read_ig_cvt_ig2cq_pvld        =  cq_wr_pvld; 
//assign obs_bus_cvif_read_ig_cvt_ig2cq_swizzle     =  ig2cq_swizzle; 
//assign obs_bus_cvif_read_ig_cvt_ig2cq_thread_id   =  cq_wr_thread_id; 

`ifdef NVDLA_PRINT_AXI
reg [63:0] mon_axi_count;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        mon_axi_count <= 0;
    end else begin
        mon_axi_count <= mon_axi_count + 1'b1;
    end
    
    if (cvif2noc_axi_ar_arvalid & cvif2noc_axi_ar_arready) begin
        $display("NVDLA CVIF READ ADDR:time=%0d:cycle=%0d:addr=0x%0h:id=%0d:cache=%0d:size=%0d:len=%0d:usid=%0d:usize=%0d",$stime,mon_axi_count,cvif2noc_axi_ar_araddr,cvif2noc_axi_ar_arid,cvif2noc_axi_ar_arcache,cvif2noc_axi_ar_arsize,cvif2noc_axi_ar_arlen,cvif2noc_axi_ar_aruser[7:0],cvif2noc_axi_ar_aruser[28:26]);
    end
end
`endif

endmodule // NV_NVDLA_CVIF_READ_IG_cvt



// **************************************************************************************************************
// Generated by ::pipe -m -rand none -bc -is opipe_axi_pd (opipe_axi_vld,opipe_axi_rdy) <= axi_cmd_pd[69:0] (axi_cmd_vld,axi_cmd_rdy)
// **************************************************************************************************************
module NV_NVDLA_CVIF_READ_IG_CVT_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,axi_cmd_pd
  ,axi_cmd_vld
  ,opipe_axi_rdy
  ,axi_cmd_rdy
  ,opipe_axi_pd
  ,opipe_axi_vld
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [69:0] axi_cmd_pd;
input         axi_cmd_vld;
input         opipe_axi_rdy;
output        axi_cmd_rdy;
output [69:0] opipe_axi_pd;
output        opipe_axi_vld;
reg           axi_cmd_rdy;
reg    [69:0] opipe_axi_pd;
reg           opipe_axi_vld;
reg    [69:0] p1_pipe_data;
reg           p1_pipe_ready;
reg           p1_pipe_ready_bc;
reg           p1_pipe_valid;
reg           p1_skid_catch;
reg    [69:0] p1_skid_data;
reg    [69:0] p1_skid_pipe_data;
reg           p1_skid_pipe_ready;
reg           p1_skid_pipe_valid;
reg           p1_skid_ready;
reg           p1_skid_ready_flop;
reg           p1_skid_valid;
//## pipe (1) skid buffer
always @(
  axi_cmd_vld
  or p1_skid_ready_flop
  or p1_skid_pipe_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = axi_cmd_vld && p1_skid_ready_flop && !p1_skid_pipe_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_skid_pipe_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    axi_cmd_rdy <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_skid_pipe_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  axi_cmd_rdy <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? axi_cmd_pd[69:0] : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or axi_cmd_vld
  or p1_skid_valid
  or axi_cmd_pd
  or p1_skid_data
  ) begin
  p1_skid_pipe_valid = (p1_skid_ready_flop)? axi_cmd_vld : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_skid_pipe_data = (p1_skid_ready_flop)? axi_cmd_pd[69:0] : p1_skid_data;
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
  or opipe_axi_rdy
  or p1_pipe_data
  ) begin
  opipe_axi_vld = p1_pipe_valid;
  p1_pipe_ready = opipe_axi_rdy;
  opipe_axi_pd = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (opipe_axi_vld^opipe_axi_rdy^axi_cmd_vld^axi_cmd_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_6x (nvdla_core_clk, `ASSERT_RESET, (axi_cmd_vld && !axi_cmd_rdy), (axi_cmd_vld), (axi_cmd_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_CVIF_READ_IG_CVT_pipe_p1


