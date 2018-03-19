// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_RDMA_EG_ro.v

#include "NV_NVDLA_SDP_define.h"

`include "simulate_x_tick.vh"
module NV_NVDLA_SDP_RDMA_EG_ro (
   nvdla_core_clk       //|< i
  ,nvdla_core_rstn      //|< i
  ,pwrbus_ram_pd        //|< i
  ,cfg_dp_8             //|< i
  ,cfg_dp_size_1byte    //|< i
  ,cfg_mode_per_element //|< i
  #ifdef NVDLA_BATCH_ENABLE
  ,cfg_mode_multi_batch //|< i
  ,reg2dp_batch_number  //|< i
  #endif
  ,reg2dp_channel       //|< i
  ,reg2dp_height        //|< i
  ,reg2dp_width         //|< i
  ,rod0_wr_pd           //|< i
  ,rod1_wr_pd           //|< i
  ,rod2_wr_pd           //|< i
  ,rod3_wr_pd           //|< i
  ,rod_wr_mask          //|< i
  ,rod_wr_vld           //|< i
  ,rod_wr_rdy           //|> o
  ,roc_wr_pd            //|< i
  ,roc_wr_vld           //|< i
  ,roc_wr_rdy           //|> o
  ,layer_end            //|> o
  ,sdp_rdma2dp_pd       //|> o
  ,sdp_rdma2dp_valid    //|> o
  ,sdp_rdma2dp_ready    //|< i
  );



input  nvdla_core_clk;   
input  nvdla_core_rstn;
input  [31:0]  pwrbus_ram_pd; 

output         sdp_rdma2dp_valid;  
input          sdp_rdma2dp_ready;  
output [AM_DW2:0] sdp_rdma2dp_pd;

input  [AM_DW-1:0] rod0_wr_pd;
input  [AM_DW-1:0] rod1_wr_pd;
input  [AM_DW-1:0] rod2_wr_pd;
input  [AM_DW-1:0] rod3_wr_pd;
input    [3:0] rod_wr_mask;
input          rod_wr_vld;
output         rod_wr_rdy;
input    [1:0] roc_wr_pd;
input          roc_wr_vld;
output         roc_wr_rdy;
input          cfg_dp_8;
input          cfg_dp_size_1byte;
input          cfg_mode_per_element;
#ifdef NVDLA_BATCH_ENABLE
input          cfg_mode_multi_batch;
input    [4:0] reg2dp_batch_number;
#endif
input   [12:0] reg2dp_channel;
input   [12:0] reg2dp_height;
input   [12:0] reg2dp_width;
output         layer_end;

wire     [2:0] size_of_beat;
wire    [12:0] size_of_width;
wire    [13-AM_AW:0] size_of_surf;
reg      [1:0] beat_cnt;
wire     [2:0] beat_cnt_nxt;
reg            mon_beat_cnt;
#ifdef NVDLA_BATCH_ENABLE
reg      [4:0] count_b;
wire           is_last_b;
wire           is_batch_end;
#endif
reg     [12:0] count_h;
reg     [12:0] count_w;
reg     [13-AM_AW:0] count_c;
reg            is_last_beat;
wire           is_cube_end;
wire           is_last_c;
wire           is_last_h;
wire           is_last_w;
wire           is_line_end;
wire           is_surf_end;
reg            roc_rd_en;
wire     [1:0] roc_rd_pd;
wire           roc_rd_prdy;
wire           roc_rd_pvld;
reg            rodx_rd_en;
wire   [AM_DW-1:0] rod0_rd_pd;
wire           rod0_rd_prdy;
wire           rod0_rd_pvld;
wire           rod0_wr_prdy;
wire           rod0_wr_pvld;
wire   [AM_DW-1:0] rod1_rd_pd;
wire           rod1_rd_prdy;
wire           rod1_rd_pvld;
wire           rod1_wr_prdy;
wire           rod1_wr_pvld;
wire   [AM_DW-1:0] rod2_rd_pd;
wire           rod2_rd_prdy;
wire           rod2_rd_pvld;
wire           rod2_wr_prdy;
wire           rod2_wr_pvld;
wire   [AM_DW-1:0] rod3_rd_pd;
wire           rod3_rd_prdy;
wire           rod3_rd_pvld;
wire           rod3_wr_prdy;
wire           rod3_wr_pvld;
wire     [1:0] rod_sel;
wire           rod0_sel;
wire           rod1_sel;
wire           rod2_sel;
wire           rod3_sel;
reg     [AM_DW-1:0] out_data_1bpe;
wire    [AM_DW2-1:0] out_data_1bpe_ext;
reg     [AM_DW2-1:0] out_data_2bpe;
reg            out_vld_1bpe;
reg            out_vld_2bpe;
wire           out_accept;
wire           out_rdy;
reg            out_vld;
wire   [AM_DW2:0] out_pd;


//=======================================================
// DATA FIFO: WRITE SIDE
//=======================================================

assign rod_wr_rdy = ~(rod_wr_mask[0] & ~rod0_wr_prdy |rod_wr_mask[1] & ~rod1_wr_prdy | rod_wr_mask[2] & ~rod2_wr_prdy | rod_wr_mask[3] & ~rod3_wr_prdy ); 
assign rod0_wr_pvld = rod_wr_vld & rod_wr_mask[0] & ~(rod_wr_mask[1] & ~rod1_wr_prdy | rod_wr_mask[2] & ~rod2_wr_prdy | rod_wr_mask[3] & ~rod3_wr_prdy );
assign rod1_wr_pvld = rod_wr_vld & rod_wr_mask[1] & ~(rod_wr_mask[0] & ~rod0_wr_prdy | rod_wr_mask[2] & ~rod2_wr_prdy | rod_wr_mask[3] & ~rod3_wr_prdy );
assign rod2_wr_pvld = rod_wr_vld & rod_wr_mask[2] & ~(rod_wr_mask[0] & ~rod0_wr_prdy | rod_wr_mask[1] & ~rod1_wr_prdy | rod_wr_mask[3] & ~rod3_wr_prdy ); 
assign rod3_wr_pvld = rod_wr_vld & rod_wr_mask[3] & ~(rod_wr_mask[0] & ~rod0_wr_prdy | rod_wr_mask[1] & ~rod1_wr_prdy | rod_wr_mask[2] & ~rod2_wr_prdy );


NV_NVDLA_SDP_RDMA_EG_RO_dfifo u_rod0 (
   .nvdla_core_clk     (nvdla_core_clk)         
  ,.nvdla_core_rstn    (nvdla_core_rstn)        
  ,.rod_wr_prdy        (rod0_wr_prdy)           
  ,.rod_wr_pvld        (rod0_wr_pvld)           
  ,.rod_wr_pd          (rod0_wr_pd[AM_DW-1:0])      
  ,.rod_rd_prdy        (rod0_rd_prdy)           
  ,.rod_rd_pvld        (rod0_rd_pvld)           
  ,.rod_rd_pd          (rod0_rd_pd[AM_DW-1:0])      
  );

NV_NVDLA_SDP_RDMA_EG_RO_dfifo u_rod1 (
   .nvdla_core_clk     (nvdla_core_clk)         
  ,.nvdla_core_rstn    (nvdla_core_rstn)        
  ,.rod_wr_prdy        (rod1_wr_prdy)           
  ,.rod_wr_pvld        (rod1_wr_pvld)           
  ,.rod_wr_pd          (rod1_wr_pd[AM_DW-1:0])      
  ,.rod_rd_prdy        (rod1_rd_prdy)           
  ,.rod_rd_pvld        (rod1_rd_pvld)           
  ,.rod_rd_pd          (rod1_rd_pd[AM_DW-1:0])      
  );

NV_NVDLA_SDP_RDMA_EG_RO_dfifo u_rod2 (
   .nvdla_core_clk     (nvdla_core_clk)         
  ,.nvdla_core_rstn    (nvdla_core_rstn)        
  ,.rod_wr_prdy        (rod2_wr_prdy)           
  ,.rod_wr_pvld        (rod2_wr_pvld)           
  ,.rod_wr_pd          (rod2_wr_pd[AM_DW-1:0])      
  ,.rod_rd_prdy        (rod2_rd_prdy)           
  ,.rod_rd_pvld        (rod2_rd_pvld)           
  ,.rod_rd_pd          (rod2_rd_pd[AM_DW-1:0])      
  );

NV_NVDLA_SDP_RDMA_EG_RO_dfifo u_rod3 (
   .nvdla_core_clk     (nvdla_core_clk)         
  ,.nvdla_core_rstn    (nvdla_core_rstn)        
  ,.rod_wr_prdy        (rod3_wr_prdy)           
  ,.rod_wr_pvld        (rod3_wr_pvld)           
  ,.rod_wr_pd          (rod3_wr_pd[AM_DW-1:0])      
  ,.rod_rd_prdy        (rod3_rd_prdy)           
  ,.rod_rd_pvld        (rod3_rd_pvld)           
  ,.rod_rd_pd          (rod3_rd_pd[AM_DW-1:0])      
  );



//=======================================================
// DATA FIFO: READ SIDE
//=======================================================

always @(
  cfg_mode_per_element
  #ifdef NVDLA_BATCH_ENABLE
  or cfg_mode_multi_batch
  or is_last_b
  #endif
  or is_last_h
  or is_last_w
  ) begin
   #ifdef NVDLA_BATCH_ENABLE
   if (cfg_mode_multi_batch) begin
       if (cfg_mode_per_element) begin
          rodx_rd_en = is_last_b; 
       end else begin
          rodx_rd_en = is_last_b & is_last_h & is_last_w;
       end
   end else 
   #endif
   begin
       if (cfg_mode_per_element) begin
           rodx_rd_en = 1'b1;
       end else begin
           rodx_rd_en = is_last_h & is_last_w;
       end
   end
end

assign rod0_rd_prdy = out_rdy & rodx_rd_en & rod0_sel & ~(rod1_sel & ~rod1_rd_pvld);
assign rod1_rd_prdy = out_rdy & rodx_rd_en & rod1_sel & ~(rod0_sel & ~rod0_rd_pvld);
assign rod2_rd_prdy = out_rdy & rodx_rd_en & rod2_sel & ~(rod3_sel & ~rod3_rd_pvld);
assign rod3_rd_prdy = out_rdy & rodx_rd_en & rod3_sel & ~(rod2_sel & ~rod2_rd_pvld);



//==============
// CMD FIFO
//==============
// One entry in ROC indicates one entry from latency fifo
NV_NVDLA_SDP_RDMA_EG_RO_cfifo u_roc (
   .nvdla_core_clk     (nvdla_core_clk)        
  ,.nvdla_core_rstn    (nvdla_core_rstn)       
  ,.pwrbus_ram_pd      (pwrbus_ram_pd)         
  ,.roc_wr_prdy        (roc_wr_rdy)            
  ,.roc_wr_pvld        (roc_wr_vld)            
  ,.roc_wr_pd          (roc_wr_pd[1:0])        
  ,.roc_rd_prdy        (roc_rd_prdy)           
  ,.roc_rd_pvld        (roc_rd_pvld)           
  ,.roc_rd_pd          (roc_rd_pd[1:0])        
  );



always @(
  cfg_mode_per_element
  #ifdef NVDLA_BATCH_ENABLE
  or cfg_mode_multi_batch
  or is_batch_end
  #endif
  or is_surf_end
  or is_last_beat
  ) begin
    #ifdef NVDLA_BATCH_ENABLE
    if (cfg_mode_multi_batch) begin
        roc_rd_en = is_batch_end & is_last_beat & (is_surf_end | cfg_mode_per_element);
    end else
    #endif 
    begin
        roc_rd_en = is_last_beat & (is_surf_end | cfg_mode_per_element);
    end
end
assign roc_rd_prdy = roc_rd_en & out_accept;

assign size_of_beat = roc_rd_pvld ? (roc_rd_pd[1:0] + 1) : 3'b0;
  

//==============
// END
//==============
#ifdef NVDLA_BATCH_ENABLE
assign is_batch_end = is_last_b;
assign is_line_end  = is_last_w & is_last_b;
#else
assign is_line_end  = is_last_w;
#endif
assign is_surf_end  = is_line_end & is_last_h;
assign is_cube_end  = is_surf_end & is_last_c;

#ifdef NVDLA_BATCH_ENABLE
//==============
//Batch Count
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_b <= {5{1'b0}};
  end else begin
    if (cfg_mode_multi_batch) begin
        if (out_accept) begin
            if (is_last_b) begin
                count_b <= 0;
            end else begin
                count_b <= count_b + 1;
            end
        end
    end
  end
end
assign is_last_b = (count_b == reg2dp_batch_number);
#endif

//==============
// Width Count
//==============
assign size_of_width = reg2dp_width;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_w <= {13{1'b0}};
  end else begin
    if (out_accept) begin
        #ifdef NVDLA_BATCH_ENABLE
        if (cfg_mode_multi_batch) begin
            if (is_batch_end) begin
                if (is_line_end) begin
                    count_w <= 0;
                end else begin 
                    count_w <= count_w + 1;
                end
            end
        end else 
        #endif
        begin
            if (is_line_end) begin
                count_w <= 0;
            end else begin 
                count_w <= count_w + 1;
            end
        end
    end
  end
end
assign is_last_w = (count_w==size_of_width);

//==============
// HEIGHT Count
//==============
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_h <= {13{1'b0}};
  end else begin
    if (out_accept) begin
        if (is_surf_end) begin
            count_h <= 0;
        end else if (is_line_end) begin
            count_h <= count_h + 1;
        end
    end
  end
end
assign is_last_h = (count_h==reg2dp_height);

//==============
// SURF Count
//==============
assign size_of_surf = cfg_dp_8 ? {1'b0,reg2dp_channel[12:AM_AW]} : reg2dp_channel[12:AM_AW2];
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_c <= {(14-AM_AW){1'b0}};
  end else begin
    if (out_accept) begin
        if (is_cube_end) begin
            count_c <= 0;
        end else if (is_surf_end) begin
            count_c <= count_c + 1;
        end
    end
  end
end
assign is_last_c = (count_c==size_of_surf);

//==============
// BEAT CNT: used to foreach 1~4 16E rod FIFOs
//==============
wire [1:0] size_of_elem = (cfg_dp_size_1byte | !cfg_dp_8) ? 2'h1 : 2'h2;
assign     beat_cnt_nxt = beat_cnt + size_of_elem;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
      {mon_beat_cnt,beat_cnt} <= 3'h0;
  end else begin
    if (out_accept) begin
      if (cfg_mode_per_element) begin
          if (is_last_beat) begin
              {mon_beat_cnt,beat_cnt} <= 3'h0;
          end else begin
              {mon_beat_cnt,beat_cnt} <= beat_cnt_nxt;
          end
      end else if (is_surf_end) begin
          if (is_last_beat) begin
              {mon_beat_cnt,beat_cnt} <= 3'h0;
          end else begin
              {mon_beat_cnt,beat_cnt} <= beat_cnt_nxt;
          end
      end
    end
  end
end

assign  is_last_beat = beat_cnt_nxt == size_of_beat;

assign rod_sel  = beat_cnt;
assign rod0_sel = beat_cnt == 2'h0;
assign rod2_sel = beat_cnt == 2'h2;
assign rod1_sel = (cfg_dp_size_1byte | !cfg_dp_8)? beat_cnt == 2'h1 : beat_cnt == 2'h0;
assign rod3_sel = (cfg_dp_size_1byte | !cfg_dp_8)? beat_cnt == 2'h3 : beat_cnt == 2'h2;


////dp int8 one byte per element or int16 two bytes per elment/////////// 
always @(
  rod_sel
  or rod0_rd_pd
  or rod1_rd_pd
  or rod2_rd_pd
  or rod3_rd_pd
  ) begin
    case (rod_sel)
    2'd0: out_data_1bpe = rod0_rd_pd;
    2'd1: out_data_1bpe = rod1_rd_pd;
    2'd2: out_data_1bpe = rod2_rd_pd;
    2'd3: out_data_1bpe = rod3_rd_pd;
    default : out_data_1bpe[AM_DW-1:0] = {AM_DW{`x_or_0}};

    endcase
end

always @(
  rod_sel
  or rod0_rd_pvld
  or rod1_rd_pvld
  or rod2_rd_pvld
  or rod3_rd_pvld
  ) begin
    case (rod_sel)
    2'd0: out_vld_1bpe = rod0_rd_pvld;
    2'd1: out_vld_1bpe = rod1_rd_pvld;
    2'd2: out_vld_1bpe = rod2_rd_pvld;
    2'd3: out_vld_1bpe = rod3_rd_pvld;
    default : out_vld_1bpe = {1{`x_or_0}};

    endcase
end


//: my $m = NVDLA_MEMORY_ATOMIC_SIZE;
//: foreach my $i  (0..${m}-1) {
//: print "assign out_data_1bpe_ext[16*${i}+15:16*${i}] = {{8{out_data_1bpe[8*${i}+7]}}, out_data_1bpe[8*${i}+7:8*${i}]}; \n";
//: }


////dp int8 two byte per element/////////// 
always @(
  rod_sel
  or rod0_rd_pd
  or rod1_rd_pd
  or rod2_rd_pd
  or rod3_rd_pd
  ) begin
    case (rod_sel)
    2'd0: out_data_2bpe = {rod1_rd_pd,rod0_rd_pd};
    2'd2: out_data_2bpe = {rod3_rd_pd,rod2_rd_pd};
    default :  out_data_2bpe[AM_DW2-1:0] = {AM_DW2{`x_or_0}};

    endcase
end

always @(
  rod_sel
  or rod0_rd_pvld
  or rod1_rd_pvld
  or rod2_rd_pvld
  or rod3_rd_pvld
  ) begin
    case (rod_sel)
    2'd0: out_vld_2bpe = rod1_rd_pvld & rod0_rd_pvld;
    2'd2: out_vld_2bpe = rod3_rd_pvld & rod2_rd_pvld;
    default : out_vld_2bpe = {1{`x_or_0}};

    endcase
end


////mux out data ////
assign  out_vld = (cfg_dp_size_1byte | !cfg_dp_8) ? out_vld_1bpe : out_vld_2bpe;
assign  out_pd[AM_DW2-1:0] = !cfg_dp_8 ? {{AM_DW{1'b0}},out_data_1bpe[AM_DW-1:0]} :  cfg_dp_size_1byte ? out_data_1bpe_ext[AM_DW2-1:0] : out_data_2bpe[AM_DW2-1:0];
assign  out_pd[AM_DW2] = is_cube_end;
assign  out_accept     = out_vld & out_rdy;


NV_NVDLA_SDP_RDMA_EG_RO_pipe_p1 pipe_p1 (
   .nvdla_core_clk     (nvdla_core_clk)             //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)            //|< i
  ,.out_pd             (out_pd[AM_DW2:0])           //|< w
  ,.out_vld            (out_vld)                    //|< r
  ,.out_rdy            (out_rdy)                    //|> w
  ,.sdp_rdma2dp_ready  (sdp_rdma2dp_ready)          //|< i
  ,.sdp_rdma2dp_pd     (sdp_rdma2dp_pd[AM_DW2:0])   //|> o
  ,.sdp_rdma2dp_valid  (sdp_rdma2dp_valid)          //|> o
  );


assign layer_end = sdp_rdma2dp_valid & sdp_rdma2dp_ready & sdp_rdma2dp_pd[AM_DW2];



endmodule // NV_NVDLA_SDP_RDMA_EG_ro



// **************************************************************************************************************
// Generated by ::pipe -m -bc sdp_rdma2dp_pd (sdp_rdma2dp_valid,sdp_rdma2dp_ready) <= out_pd[AM_DW:0] (out_vld, out_rdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_RDMA_EG_RO_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,out_pd
  ,out_vld
  ,out_rdy
  ,sdp_rdma2dp_ready
  ,sdp_rdma2dp_pd
  ,sdp_rdma2dp_valid
  );

input          nvdla_core_clk;
input          nvdla_core_rstn;
input          out_vld;
output         out_rdy;
input  [AM_DW2:0] out_pd;
output [AM_DW2:0] sdp_rdma2dp_pd;
output         sdp_rdma2dp_valid;
input          sdp_rdma2dp_ready;

//: my $dw = 1 + AM_DW2;
//: &eperl::pipe("-is -wid $dw -do sdp_rdma2dp_pd -vo sdp_rdma2dp_valid -ri sdp_rdma2dp_ready -di out_pd -vi out_vld -ro out_rdy");


endmodule // NV_NVDLA_SDP_RDMA_EG_RO_pipe_p1


module NV_NVDLA_SDP_RDMA_EG_RO_dfifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , rod_wr_prdy
    , rod_wr_pvld
    , rod_wr_pd
    , rod_rd_prdy
    , rod_rd_pvld
    , rod_rd_pd
    );

input         nvdla_core_clk;
input         nvdla_core_rstn;
output        rod_wr_prdy;
input         rod_wr_pvld;
input  [AM_DW-1:0] rod_wr_pd;
input         rod_rd_prdy;
output        rod_rd_pvld;
output [AM_DW-1:0] rod_rd_pd;


//: my $dw = AM_DW;
//: &eperl::pipe("-is -wid $dw -do rod_rd_pd -vo rod_rd_pvld -ri rod_rd_prdy -di rod_wr_pd -vi rod_wr_pvld -ro rod_wr_prdy");


endmodule  



`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_SDP_RDMA_EG_RO_cfifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , roc_wr_prdy
    , roc_wr_pvld
    , roc_wr_pd
    , roc_rd_prdy
    , roc_rd_pvld
    , roc_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        roc_wr_prdy;
input         roc_wr_pvld;
input  [1:0] roc_wr_pd;
input         roc_rd_prdy;
output        roc_rd_pvld;
output [1:0] roc_rd_pd;
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
wire wr_reserving;
reg        roc_wr_busy_int;		        	// copy for internal use
assign     roc_wr_prdy = !roc_wr_busy_int;
assign       wr_reserving = roc_wr_pvld && !roc_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [2:0] roc_wr_count;			// write-side count

wire [2:0] wr_count_next_wr_popping = wr_reserving ? roc_wr_count : (roc_wr_count - 1'd1); // spyglass disable W164a W484
wire [2:0] wr_count_next_no_wr_popping = wr_reserving ? (roc_wr_count + 1'd1) : roc_wr_count; // spyglass disable W164a W484
wire [2:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_4 = ( wr_count_next_no_wr_popping == 3'd4 );
wire wr_count_next_is_4 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_4;
wire [2:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [2:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       roc_wr_busy_next = wr_count_next_is_4 || // busy next cycle?
                          (wr_limit_reg != 3'd0 &&      // check roc_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        roc_wr_busy_int <=  1'b0;
        roc_wr_count <=  3'd0;
    end else begin
	roc_wr_busy_int <=  roc_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    roc_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            roc_wr_count <=  {3{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as roc_wr_pvld

//
// RAM
//

reg  [1:0] roc_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        roc_wr_adr <=  2'd0;
    end else begin
        if ( wr_pushing ) begin
	    roc_wr_adr <=  roc_wr_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg [1:0] roc_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (roc_wr_count > 3'd0 || !rd_popping);   // note: write occurs next cycle
wire [1:0] roc_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_SDP_RDMA_EG_RO_cfifo_flopram_rwsa_4x2 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( roc_wr_pd )
    , .we        ( ram_we )
    , .wa        ( roc_wr_adr )
    , .ra        ( (roc_wr_count == 0) ? 3'd4 : {1'b0,roc_rd_adr} )
    , .dout        ( roc_rd_pd_p )
    );


wire [1:0] rd_adr_next_popping = roc_rd_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        roc_rd_adr <=  2'd0;
    end else begin
        if ( rd_popping ) begin
	    roc_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            roc_rd_adr <=  {2{`x_or_0}};
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

reg        roc_rd_prdy_d;				// roc_rd_prdy registered in cleanly

always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        roc_rd_prdy_d <=  1'b1;
    end else begin
        roc_rd_prdy_d <=  roc_rd_prdy;
    end
end

wire       roc_rd_prdy_d_o;			// combinatorial rd_busy

wire       roc_rd_pvld_p; 		// data out of fifo is valid

reg        roc_rd_pvld_int_o;	// internal copy of roc_rd_pvld_o
wire       roc_rd_pvld_o = roc_rd_pvld_int_o;
assign     rd_popping = roc_rd_pvld_p && !(roc_rd_pvld_int_o && !roc_rd_prdy_d_o);

reg  [2:0] roc_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [2:0] rd_count_p_next_rd_popping = rd_pushing ? roc_rd_count_p : 
                                                                (roc_rd_count_p - 1'd1);
wire [2:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (roc_rd_count_p + 1'd1) : 
                                                                    roc_rd_count_p;
// spyglass enable_block W164a W484
wire [2:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     roc_rd_pvld_p = roc_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        roc_rd_count_p <=  3'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    roc_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            roc_rd_count_p <=  {3{`x_or_0}};
        end
        //synopsys translate_on

    end
end


// 
// SKID for -rd_busy_reg
//
reg [1:0]  roc_rd_pd_o;         // output data register
wire        rd_req_next_o = (roc_rd_pvld_p || (roc_rd_pvld_int_o && !roc_rd_prdy_d_o)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        roc_rd_pvld_int_o <=  1'b0;
    end else begin
        roc_rd_pvld_int_o <=  rd_req_next_o;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        roc_rd_pd_o <=  roc_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        roc_rd_pd_o <=  {2{`x_or_0}};
    end
    //synopsys translate_on

end

//
// FINAL OUTPUT
//
assign     roc_rd_pd = !roc_rd_prdy_d_o ? roc_rd_pd_o : roc_rd_pd_p; // skid reg assign
reg        roc_rd_pvld_d;				// previous roc_rd_pvld
assign     roc_rd_prdy_d_o = !(roc_rd_pvld_d && !roc_rd_prdy_d );
assign     roc_rd_pvld  = !roc_rd_prdy_d_o ? roc_rd_pvld_o  : roc_rd_pvld_p;  

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        roc_rd_pvld_d <=  1'b0;
    end else begin
        roc_rd_pvld_d <=  roc_rd_pvld;
    end
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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (roc_wr_pvld && !roc_wr_busy_int) || (roc_wr_busy_int != roc_wr_busy_next)) || (rd_pushing || rd_popping || (roc_rd_pvld && roc_rd_prdy_d) || (roc_rd_pvld_int_o && roc_rd_prdy_d_o)) || (wr_pushing))
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


// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_SDP_RDMA_EG_RO_cfifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_SDP_RDMA_EG_RO_cfifo_wr_limit : 3'd0;
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
    if ( $test$plusargs( "NV_NVDLA_SDP_RDMA_EG_RO_cfifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_SDP_RDMA_EG_RO_cfifo_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif

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
    , .curr	( {29'd0, roc_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_RDMA_EG_RO_cfifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_SDP_RDMA_EG_RO_cfifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_SDP_RDMA_EG_RO_cfifo_flopram_rwsa_4x2 (
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
input  [1:0] di;
input  we;
input  [1:0] wa;
input  [2:0] ra;
output [1:0] dout;

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


wire [1:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [1:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_SDP_RDMA_EG_RO_cfifo_flopram_rwsa_4x2 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[1:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 4) ? di : dout_p;

`else

reg [1:0] ram_ff0;
reg [1:0] ram_ff1;
reg [1:0] ram_ff2;
reg [1:0] ram_ff3;

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

reg [1:0] dout;

always @(*) begin
    case( ra ) 
    3'd0:       dout = ram_ff0;
    3'd1:       dout = ram_ff1;
    3'd2:       dout = ram_ff2;
    3'd3:       dout = ram_ff3;
    3'd4:       dout = di;
    //VCS coverage off
    default:    dout = {2{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_SDP_RDMA_EG_RO_cfifo_flopram_rwsa_4x2

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_SDP_RDMA_EG_RO_cfifo_flopram_rwsa_4x2 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [1:0] Di0;
input  [1:0] Ra0;
output [1:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 2'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [1:0] mem[3:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [1:0] Q0 = mem[0];
wire [1:0] Q1 = mem[1];
wire [1:0] Q2 = mem[2];
wire [1:0] Q3 = mem[3];
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

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_SDP_RDMA_EG_RO_cfifo_flopram_rwsa_4x2] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_SDP_RDMA_EG_RO_cfifo_flopram_rwsa_4x2] }
endmodule // vmw_NV_NVDLA_SDP_RDMA_EG_RO_cfifo_flopram_rwsa_4x2

//vmw: Memory vmw_NV_NVDLA_SDP_RDMA_EG_RO_cfifo_flopram_rwsa_4x2
//vmw: Address-size 2
//vmw: Data-size 2
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[1:0] data0[1:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[1:0] data1[1:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_SDP_RDMA_EG_RO_cfifo_flopram_rwsa_4x2
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU


