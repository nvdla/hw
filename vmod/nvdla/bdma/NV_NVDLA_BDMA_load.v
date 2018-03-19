// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_BDMA_load.v

`include "simulate_x_tick.vh"
module NV_NVDLA_BDMA_load (
   nvdla_core_clk            //|< i
  ,nvdla_core_rstn           //|< i
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,bdma2cvif_rd_req_ready    //|< i
  #endif
  ,bdma2mcif_rd_req_ready    //|< i
  ,csb2ld_vld                //|< i
  ,ld2st_wr_idle             //|< i
  ,ld2st_wr_prdy             //|< i
  ,reg2dp_cmd_dst_ram_type   //|< i
  ,reg2dp_cmd_interrupt      //|< i
  ,reg2dp_cmd_interrupt_ptr  //|< i
  ,reg2dp_cmd_src_ram_type   //|< i
  ,reg2dp_dst_addr_high_v8   //|< i
  ,reg2dp_dst_addr_low_v32   //|< i
  ,reg2dp_dst_line_stride    //|< i
  ,reg2dp_dst_surf_stride    //|< i
  ,reg2dp_line_repeat_number //|< i
  ,reg2dp_line_size          //|< i
  ,reg2dp_src_addr_high_v8   //|< i
  ,reg2dp_src_addr_low_v32   //|< i
  ,reg2dp_src_line_stride    //|< i
  ,reg2dp_src_surf_stride    //|< i
  ,reg2dp_surf_repeat_number //|< i
  ,st2ld_load_idle           //|< i
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,bdma2cvif_rd_req_pd       //|> o
  ,bdma2cvif_rd_req_valid    //|> o
  #endif
  ,bdma2mcif_rd_req_pd       //|> o
  ,bdma2mcif_rd_req_valid    //|> o
  ,csb2ld_rdy                //|> o
  ,ld2csb_grp0_dma_stall_inc //|> o
  ,ld2csb_grp1_dma_stall_inc //|> o
  ,ld2csb_idle               //|> o
  ,ld2gate_slcg_en           //|> o
  ,ld2st_wr_pd               //|> o
  ,ld2st_wr_pvld             //|> o
  );
//
// NV_NVDLA_BDMA_load_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

output        bdma2mcif_rd_req_valid;  /* data valid */
input         bdma2mcif_rd_req_ready;  /* data return handshake */
output [78:0] bdma2mcif_rd_req_pd;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
output        bdma2cvif_rd_req_valid;  /* data valid */
input         bdma2cvif_rd_req_ready;  /* data return handshake */
output [78:0] bdma2cvif_rd_req_pd;
#endif

output         ld2st_wr_pvld;  /* data valid */
input          ld2st_wr_prdy;  /* data return handshake */
output [160:0] ld2st_wr_pd;

//&Ports /^obs_bus/;
input         reg2dp_cmd_dst_ram_type;
input         reg2dp_cmd_interrupt;
input         reg2dp_cmd_interrupt_ptr;
input         reg2dp_cmd_src_ram_type;
input  [31:0] reg2dp_dst_addr_high_v8;
input  [26:0] reg2dp_dst_addr_low_v32;
input  [26:0] reg2dp_dst_line_stride;
input  [26:0] reg2dp_dst_surf_stride;
input  [23:0] reg2dp_line_repeat_number;
input  [12:0] reg2dp_line_size;
input  [31:0] reg2dp_src_addr_high_v8;
input  [26:0] reg2dp_src_addr_low_v32;
input  [26:0] reg2dp_src_line_stride;
input  [26:0] reg2dp_src_surf_stride;
input  [23:0] reg2dp_surf_repeat_number;
input         csb2ld_vld;
output        csb2ld_rdy;
output        ld2csb_grp0_dma_stall_inc;
output        ld2csb_grp1_dma_stall_inc;
output        ld2csb_idle;
input         ld2st_wr_idle;
input         st2ld_load_idle;
output        ld2gate_slcg_en;

reg           ld2gate_slcg_en;
reg    [63:0] line_addr;
reg    [23:0] line_count;
reg           mon_line_addr_c;
reg           mon_surf_addr_c;
reg           reg_cmd_src_ram_type;
reg    [23:0] reg_line_repeat_number;
reg    [12:0] reg_line_size;
reg    [31:0] reg_line_stride;
reg    [23:0] reg_surf_repeat_number;
reg    [31:0] reg_surf_stride;
reg    [63:0] surf_addr;
reg    [23:0] surf_count;
reg           tran_valid;
wire          cmd_ready;
wire          cmd_valid;
wire          cv_dma_rd_req_rdy;
wire          cv_dma_rd_req_vld;
wire   [78:0] cv_int_rd_req_pd;
wire   [78:0] cv_int_rd_req_pd_d0;
wire          cv_int_rd_req_ready;
wire          cv_int_rd_req_ready_d0;
wire          cv_int_rd_req_valid;
wire          cv_int_rd_req_valid_d0;
wire          cv_rd_req_rdyi;
wire   [63:0] dma_rd_req_addr;
wire   [78:0] dma_rd_req_pd;
wire          dma_rd_req_rdy;
wire   [14:0] dma_rd_req_size;
wire          dma_rd_req_type;
wire          dma_rd_req_vld;
wire          dma_stall_inc;
wire          is_cube_end;
wire          is_last_req_in_line;
wire          is_src_ram_type_switching;
wire          is_surf_end;
wire   [63:0] ld2st_addr;
wire          ld2st_cmd_dst_ram_type;
wire          ld2st_cmd_interrupt;
wire          ld2st_cmd_interrupt_ptr;
wire          ld2st_cmd_src_ram_type;
wire   [23:0] ld2st_line_repeat_number;
wire   [12:0] ld2st_line_size;
wire   [26:0] ld2st_line_stride;
wire   [23:0] ld2st_surf_repeat_number;
wire   [26:0] ld2st_surf_stride;
wire          ld_idle;
wire          load_cmd;
wire          load_cmd_en;
wire          mc_dma_rd_req_rdy;
wire          mc_dma_rd_req_vld;
wire   [78:0] mc_int_rd_req_pd;
wire   [78:0] mc_int_rd_req_pd_d0;
wire          mc_int_rd_req_ready;
wire          mc_int_rd_req_ready_d0;
wire          mc_int_rd_req_valid;
wire          mc_int_rd_req_valid_d0;
wire          mc_rd_req_rdyi;
wire          rd_req_rdyi;
wire   [63:0] reg2dp_addr;
wire   [63:0] reg2dp_dst_addr;
wire   [31:0] reg2dp_src_line_stride_ext;
wire   [31:0] reg2dp_src_surf_stride_ext;
wire          tran_accept;
wire   [63:0] tran_addr;
wire          tran_ready;
wire   [14:0] tran_size;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
//==============
// LOAD: PROCESS
//==============
// when Load process is idle or finished the execution of last command, it will pop the next command from CSB cmd FIFO

// input rename

// FLAG: processing 
// downstreams are dmaif and context-Q
// after the csb cmd queue, will have one more layer to buffer the command when processing
// will load when cmd layer is empty, or when reach the last transaction and will be accepted by downstream(dma and CQ)
//  cmd_valid        cmd_ready
//     _|_______________|_  
//    |        pipe       | 
//    |___________________| 
//      v               ^   
//  tran_valid       tran_ready

assign csb2ld_rdy = ld2st_wr_prdy & cmd_ready & load_cmd_en;
assign ld2st_wr_pvld = csb2ld_vld & cmd_ready & load_cmd_en;
assign cmd_valid     = csb2ld_vld & ld2st_wr_prdy & load_cmd_en;
assign cmd_ready   = (!tran_valid) | (tran_accept & is_cube_end);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    tran_valid <= 1'b0;
  end else begin
  if ((cmd_ready) == 1'b1) begin
    tran_valid <= cmd_valid;
  // VCS coverage off
  end else if ((cmd_ready) == 1'b0) begin
  end else begin
    tran_valid <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cmd_ready))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign tran_ready  = dma_rd_req_rdy;
assign tran_accept = tran_valid & tran_ready;
assign load_cmd = cmd_valid & cmd_ready;

assign is_src_ram_type_switching = (reg2dp_cmd_src_ram_type!=reg_cmd_src_ram_type);
assign load_cmd_en = csb2ld_vld & ((ld_idle & st2ld_load_idle) || !is_src_ram_type_switching);

//==============================
// IDLE
assign ld_idle =  ld2st_wr_idle & !tran_valid;
assign ld2csb_idle = ld_idle;

//==============================
// SLCG
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ld2gate_slcg_en <= 1'b0;
  end else begin
  ld2gate_slcg_en <= !ld_idle;
  end
end

// Constant Reg on each COMMAND
assign reg2dp_dst_addr[63:0] = {reg2dp_dst_addr_high_v8,reg2dp_dst_addr_low_v32,5'd0};
assign reg2dp_addr[63:0] = {reg2dp_src_addr_high_v8,reg2dp_src_addr_low_v32,5'd0};
assign reg2dp_src_line_stride_ext = {reg2dp_src_line_stride,5'h0};
assign reg2dp_src_surf_stride_ext = {reg2dp_src_surf_stride,5'h0};
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg_line_size <= {13{1'b0}};
    reg_cmd_src_ram_type <= 1'b0;
    reg_line_stride <= {32{1'b0}};
    reg_surf_stride <= {32{1'b0}};
    reg_line_repeat_number <= {24{1'b0}};
    reg_surf_repeat_number <= {24{1'b0}};
  end else begin
    if (load_cmd) begin
        reg_line_size               <= reg2dp_line_size;
        reg_cmd_src_ram_type        <= reg2dp_cmd_src_ram_type;
        reg_line_stride <= reg2dp_src_line_stride_ext;
        reg_surf_stride <= reg2dp_src_surf_stride_ext;
        
        //reg_cmd_dst_ram_type       <= reg2dp_cmd_dst_ram_type;
        //reg_cmd_interrupt      <= reg2dp_cmd_interrupt;

        reg_line_repeat_number   <= reg2dp_line_repeat_number;
        //reg_dst_line_stride <= reg2dp_dst_line_stride;
        
        reg_surf_repeat_number   <= reg2dp_surf_repeat_number;
        //reg_dst_surf_stride <= reg2dp_dst_surf_stride;

        //reg_src_addr <= reg2dp_src_addr;
        //reg_dst_addr <= reg2dp_dst_addr;
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
  nv_assert_never #(0,0,"Line Address is overlapped within one single command")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, (reg_line_size<<5) > reg_line_stride); // spyglass disable W504 SelfDeterminedExpr-ML 
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

// ===================================
// Context Queue Write
// ===================================
// below are required cmd information needed in store side to reassemble the return data, 
// and format the DMA write request, one emtry is needed for each MOMERY COPY COMMAND
assign ld2st_addr                 = reg2dp_dst_addr; 
assign ld2st_line_size            = reg2dp_line_size;
assign ld2st_cmd_src_ram_type     = reg2dp_cmd_src_ram_type;
assign ld2st_cmd_dst_ram_type     = reg2dp_cmd_dst_ram_type;
assign ld2st_cmd_interrupt        = reg2dp_cmd_interrupt;
assign ld2st_cmd_interrupt_ptr    = reg2dp_cmd_interrupt_ptr;
assign ld2st_line_stride          = reg2dp_dst_line_stride;
assign ld2st_surf_stride          = reg2dp_dst_surf_stride;
assign ld2st_line_repeat_number   = reg2dp_line_repeat_number;
assign ld2st_surf_repeat_number   = reg2dp_surf_repeat_number;

// PKT_PACK_WIRE( bdma_ld2st , ld2st_ , ld2st_wr_pd )
assign      ld2st_wr_pd[63:0] =    ld2st_addr[63:0];
assign      ld2st_wr_pd[76:64] =    ld2st_line_size[12:0];
assign      ld2st_wr_pd[77] =    ld2st_cmd_src_ram_type ;
assign      ld2st_wr_pd[78] =    ld2st_cmd_dst_ram_type ;
assign      ld2st_wr_pd[79] =    ld2st_cmd_interrupt ;
assign      ld2st_wr_pd[80] =    ld2st_cmd_interrupt_ptr ;
assign      ld2st_wr_pd[107:81] =    ld2st_line_stride[26:0];
assign      ld2st_wr_pd[120:108] =    ld2st_line_repeat_number[12:0];
assign      ld2st_wr_pd[147:121] =    ld2st_surf_stride[26:0];
assign      ld2st_wr_pd[160:148] =    ld2st_surf_repeat_number[12:0];

// Variable Reg on each COMMAND
// 3-D support tran->line->surf->cube
// cube consists of multiple surfaces(surf)
// surf consists of multiple lines
// line consists of multiple transaction(tran)
assign is_last_req_in_line = 1'b1;
assign is_surf_end = is_last_req_in_line & (line_count==reg_line_repeat_number);
assign is_cube_end = is_surf_end & (surf_count==reg_surf_repeat_number);

// tran_addr is the start address of each DMA request
// will load a new one from CSB FIFO for every mem copy command
// will change every time one DMA request is aacpetted by xxif
assign tran_addr = line_addr;

// Line_addr is the start address of every line
// load a new one from CSB FIFO for every mem copy command
// will change every time one a block is done and jump to the next line
always @(posedge nvdla_core_clk) begin
    if (load_cmd) begin
        line_addr <= reg2dp_addr;
    end else if (tran_accept) begin
        if (is_surf_end) begin
            {mon_line_addr_c,line_addr} <= surf_addr + reg_surf_stride;
        end else begin
            {mon_line_addr_c,line_addr} <= line_addr + reg_line_stride;
        end
    end
end

// Surf_addr is the base address of each surface
// load a new one from CSB FIFO for every mem copy command
// will change every time one a block is done and jump to the next surface
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    surf_addr <= {64{1'b0}};
    {mon_surf_addr_c,surf_addr} <= {65{1'b0}};
  end else begin
    if (load_cmd) begin
        surf_addr <= reg2dp_addr;
    end else if (tran_accept) begin
        if (is_surf_end) begin
            {mon_surf_addr_c,surf_addr} <= surf_addr + reg_surf_stride;
        end
    end
  end
end

//===TRAN SIZE
// for each DMA request, tran_size is to tell how many 32B DATA block indicated
assign tran_size = {{2{1'b0}}, reg_line_size};// reg_line_size;

// ===LINE COUNT
// count++ when just to next line
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    line_count <= {24{1'b0}};
  end else begin
    if (tran_accept) begin
        if (is_surf_end) begin
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
    surf_count <= {24{1'b0}};
  end else begin
    if (tran_accept) begin
        if (is_cube_end) begin
            surf_count <= 0;
        end else if (is_surf_end) begin
            surf_count <= surf_count + 1;
        end 
    end
  end
end
//==============
// LOAD: DMA OUT
//==============
// ===DMA Request: ADDR/SIZE/INTR
assign dma_rd_req_vld  = tran_valid;
assign dma_rd_req_addr = tran_addr;
assign dma_rd_req_type = reg_cmd_src_ram_type;
assign dma_rd_req_size = tran_size;

// PKT_PACK_WIRE( dma_read_cmd , dma_rd_req_ , dma_rd_req_pd )
assign      dma_rd_req_pd[63:0] =    dma_rd_req_addr[63:0];
assign      dma_rd_req_pd[78:64] =    dma_rd_req_size[14:0];

// rd Channel: Request 
assign cv_dma_rd_req_vld = dma_rd_req_vld & (dma_rd_req_type == 1'b0);
assign mc_dma_rd_req_vld = dma_rd_req_vld & (dma_rd_req_type == 1'b1);
assign cv_rd_req_rdyi = cv_dma_rd_req_rdy & (dma_rd_req_type == 1'b0);
assign mc_rd_req_rdyi = mc_dma_rd_req_rdy & (dma_rd_req_type == 1'b1);
assign rd_req_rdyi = mc_rd_req_rdyi | cv_rd_req_rdyi;
assign dma_rd_req_rdy= rd_req_rdyi;
NV_NVDLA_BDMA_LOAD_pipe_p1 pipe_p1 (
   .nvdla_core_clk      (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)        //|< i
  ,.dma_rd_req_pd       (dma_rd_req_pd[78:0])    //|< w
  ,.mc_dma_rd_req_vld   (mc_dma_rd_req_vld)      //|< w
  ,.mc_int_rd_req_ready (mc_int_rd_req_ready)    //|< w
  ,.mc_dma_rd_req_rdy   (mc_dma_rd_req_rdy)      //|> w
  ,.mc_int_rd_req_pd    (mc_int_rd_req_pd[78:0]) //|> w
  ,.mc_int_rd_req_valid (mc_int_rd_req_valid)    //|> w
  );
NV_NVDLA_BDMA_LOAD_pipe_p2 pipe_p2 (
   .nvdla_core_clk      (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)        //|< i
  ,.cv_dma_rd_req_vld   (cv_dma_rd_req_vld)      //|< w
  ,.cv_int_rd_req_ready (cv_int_rd_req_ready)    //|< w
  ,.dma_rd_req_pd       (dma_rd_req_pd[78:0])    //|< w
  ,.cv_dma_rd_req_rdy   (cv_dma_rd_req_rdy)      //|> w
  ,.cv_int_rd_req_pd    (cv_int_rd_req_pd[78:0]) //|> w
  ,.cv_int_rd_req_valid (cv_int_rd_req_valid)    //|> w
  );

assign mc_int_rd_req_valid_d0 = mc_int_rd_req_valid;
assign mc_int_rd_req_ready = mc_int_rd_req_ready_d0;
assign mc_int_rd_req_pd_d0[78:0] = mc_int_rd_req_pd[78:0];
assign bdma2mcif_rd_req_valid = mc_int_rd_req_valid_d0;
assign mc_int_rd_req_ready_d0 = bdma2mcif_rd_req_ready;
assign bdma2mcif_rd_req_pd[78:0] = mc_int_rd_req_pd_d0[78:0];


assign cv_int_rd_req_valid_d0 = cv_int_rd_req_valid;
assign cv_int_rd_req_ready = cv_int_rd_req_ready_d0;
assign cv_int_rd_req_pd_d0[78:0] = cv_int_rd_req_pd[78:0];
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
assign bdma2cvif_rd_req_valid = cv_int_rd_req_valid_d0;
assign cv_int_rd_req_ready_d0 = bdma2cvif_rd_req_ready;
assign bdma2cvif_rd_req_pd[78:0] = cv_int_rd_req_pd_d0[78:0];
#endif


//&Viva width_learning_off;
assign dma_stall_inc = dma_rd_req_vld & !dma_rd_req_rdy;
assign ld2csb_grp0_dma_stall_inc = dma_stall_inc & reg2dp_cmd_interrupt_ptr==0; 
assign ld2csb_grp1_dma_stall_inc = dma_stall_inc & reg2dp_cmd_interrupt_ptr==1; 
//======================================
// OBS Signals
//======================================
//assign obs_bus_bdma_load_cmd    = load_cmd;
//assign obs_bus_bdma_load_cmd_en = load_cmd_en;
//assign obs_bus_bdma_load_idle   = ld_idle;
//assign obs_bus_bdma_load_ram_switch    = is_src_ram_type_switching;
//assign obs_bus_bdma_load_tran_ready    = tran_ready;
//assign obs_bus_bdma_load_tran_valid    = tran_valid;
//assign obs_bus_bdma_load_ld2st_wr_pvld = ld2st_wr_pvld;
//assign obs_bus_bdma_load_ld2st_wr_prdy = ld2st_wr_prdy;
//assign obs_bus_bdma_load_ld2st_wr_idle = ld2st_wr_idle;
endmodule // NV_NVDLA_BDMA_load



// **************************************************************************************************************
// Generated by ::pipe -m -bc -is mc_int_rd_req_pd (mc_int_rd_req_valid,mc_int_rd_req_ready) <= dma_rd_req_pd[78:0] (mc_dma_rd_req_vld,mc_dma_rd_req_rdy)
// **************************************************************************************************************
module NV_NVDLA_BDMA_LOAD_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,dma_rd_req_pd
  ,mc_dma_rd_req_vld
  ,mc_int_rd_req_ready
  ,mc_dma_rd_req_rdy
  ,mc_int_rd_req_pd
  ,mc_int_rd_req_valid
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [78:0] dma_rd_req_pd;
input         mc_dma_rd_req_vld;
input         mc_int_rd_req_ready;
output        mc_dma_rd_req_rdy;
output [78:0] mc_int_rd_req_pd;
output        mc_int_rd_req_valid;
reg           mc_dma_rd_req_rdy;
reg    [78:0] mc_int_rd_req_pd;
reg           mc_int_rd_req_valid;
reg    [78:0] p1_pipe_data;
reg    [78:0] p1_pipe_rand_data;
reg           p1_pipe_rand_ready;
reg           p1_pipe_rand_valid;
reg           p1_pipe_ready;
reg           p1_pipe_ready_bc;
reg           p1_pipe_valid;
reg           p1_skid_catch;
reg    [78:0] p1_skid_data;
reg    [78:0] p1_skid_pipe_data;
reg           p1_skid_pipe_ready;
reg           p1_skid_pipe_valid;
reg           p1_skid_ready;
reg           p1_skid_ready_flop;
reg           p1_skid_valid;
//## pipe (1) randomizer
`ifndef SYNTHESIS
reg p1_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p1_pipe_rand_active
  or 
     `endif
     mc_dma_rd_req_vld
  or p1_pipe_rand_ready
  or dma_rd_req_pd
  ) begin
  `ifdef SYNTHESIS
  p1_pipe_rand_valid = mc_dma_rd_req_vld;
  mc_dma_rd_req_rdy = p1_pipe_rand_ready;
  p1_pipe_rand_data = dma_rd_req_pd[78:0];
  `else
  // VCS coverage off
  p1_pipe_rand_valid = (p1_pipe_rand_active)? 1'b0 : mc_dma_rd_req_vld;
  mc_dma_rd_req_rdy = (p1_pipe_rand_active)? 1'b0 : p1_pipe_rand_ready;
  p1_pipe_rand_data = (p1_pipe_rand_active)?  'bx : dma_rd_req_pd[78:0];
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
  if      ( $value$plusargs( "NV_NVDLA_BDMA_load_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_BDMA_load_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_BDMA_load_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_BDMA_load_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_BDMA_load_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_BDMA_load_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_BDMA_load_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p1_pipe_rand_enable;
reg p1_pipe_rand_poised;
always @(
  p1_pipe_stall_cycles
  or p1_pipe_stall_probability
  or mc_dma_rd_req_vld
  ) begin
  p1_pipe_rand_active = p1_pipe_stall_cycles != 0;
  p1_pipe_rand_enable = p1_pipe_stall_probability != 0;
  p1_pipe_rand_poised = p1_pipe_rand_enable && !p1_pipe_rand_active && mc_dma_rd_req_vld === 1'b1;
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
  or mc_int_rd_req_ready
  or p1_pipe_data
  ) begin
  mc_int_rd_req_valid = p1_pipe_valid;
  p1_pipe_ready = mc_int_rd_req_ready;
  mc_int_rd_req_pd = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mc_int_rd_req_valid^mc_int_rd_req_ready^mc_dma_rd_req_vld^mc_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_4x (nvdla_core_clk, `ASSERT_RESET, (mc_dma_rd_req_vld && !mc_dma_rd_req_rdy), (mc_dma_rd_req_vld), (mc_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_BDMA_LOAD_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is cv_int_rd_req_pd (cv_int_rd_req_valid,cv_int_rd_req_ready) <= dma_rd_req_pd[78:0] (cv_dma_rd_req_vld,cv_dma_rd_req_rdy)
// **************************************************************************************************************
module NV_NVDLA_BDMA_LOAD_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cv_dma_rd_req_vld
  ,cv_int_rd_req_ready
  ,dma_rd_req_pd
  ,cv_dma_rd_req_rdy
  ,cv_int_rd_req_pd
  ,cv_int_rd_req_valid
  );
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         cv_dma_rd_req_vld;
input         cv_int_rd_req_ready;
input  [78:0] dma_rd_req_pd;
output        cv_dma_rd_req_rdy;
output [78:0] cv_int_rd_req_pd;
output        cv_int_rd_req_valid;
reg           cv_dma_rd_req_rdy;
reg    [78:0] cv_int_rd_req_pd;
reg           cv_int_rd_req_valid;
reg    [78:0] p2_pipe_data;
reg    [78:0] p2_pipe_rand_data;
reg           p2_pipe_rand_ready;
reg           p2_pipe_rand_valid;
reg           p2_pipe_ready;
reg           p2_pipe_ready_bc;
reg           p2_pipe_valid;
reg           p2_skid_catch;
reg    [78:0] p2_skid_data;
reg    [78:0] p2_skid_pipe_data;
reg           p2_skid_pipe_ready;
reg           p2_skid_pipe_valid;
reg           p2_skid_ready;
reg           p2_skid_ready_flop;
reg           p2_skid_valid;
//## pipe (2) randomizer
`ifndef SYNTHESIS
reg p2_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p2_pipe_rand_active
  or 
     `endif
     cv_dma_rd_req_vld
  or p2_pipe_rand_ready
  or dma_rd_req_pd
  ) begin
  `ifdef SYNTHESIS
  p2_pipe_rand_valid = cv_dma_rd_req_vld;
  cv_dma_rd_req_rdy = p2_pipe_rand_ready;
  p2_pipe_rand_data = dma_rd_req_pd[78:0];
  `else
  // VCS coverage off
  p2_pipe_rand_valid = (p2_pipe_rand_active)? 1'b0 : cv_dma_rd_req_vld;
  cv_dma_rd_req_rdy = (p2_pipe_rand_active)? 1'b0 : p2_pipe_rand_ready;
  p2_pipe_rand_data = (p2_pipe_rand_active)?  'bx : dma_rd_req_pd[78:0];
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
  if      ( $value$plusargs( "NV_NVDLA_BDMA_load_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_BDMA_load_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_BDMA_load_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_BDMA_load_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_BDMA_load_pipe_stall_probability" ) ) p2_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_BDMA_load_pipe_stall_cycles_min"  ) ) p2_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_BDMA_load_pipe_stall_cycles_max"  ) ) p2_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p2_pipe_rand_enable;
reg p2_pipe_rand_poised;
always @(
  p2_pipe_stall_cycles
  or p2_pipe_stall_probability
  or cv_dma_rd_req_vld
  ) begin
  p2_pipe_rand_active = p2_pipe_stall_cycles != 0;
  p2_pipe_rand_enable = p2_pipe_stall_probability != 0;
  p2_pipe_rand_poised = p2_pipe_rand_enable && !p2_pipe_rand_active && cv_dma_rd_req_vld === 1'b1;
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
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
always @(posedge nvdla_core_clk) begin
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_valid <= 1'b0;
  end else begin
  p2_pipe_valid <= (p2_pipe_ready_bc)? p2_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
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
  or cv_int_rd_req_ready
  or p2_pipe_data
  ) begin
  cv_int_rd_req_valid = p2_pipe_valid;
  p2_pipe_ready = cv_int_rd_req_ready;
  cv_int_rd_req_pd = p2_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (cv_int_rd_req_valid^cv_int_rd_req_ready^cv_dma_rd_req_vld^cv_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_6x (nvdla_core_clk, `ASSERT_RESET, (cv_dma_rd_req_vld && !cv_dma_rd_req_rdy), (cv_dma_rd_req_vld), (cv_dma_rd_req_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_BDMA_LOAD_pipe_p2


