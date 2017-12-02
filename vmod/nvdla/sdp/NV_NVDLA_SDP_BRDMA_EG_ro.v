// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_BRDMA_EG_ro.v

`include "simulate_x_tick.vh"
module NV_NVDLA_SDP_BRDMA_EG_ro (
   nvdla_core_clk       //|< i
  ,nvdla_core_rstn      //|< i
  ,cfg_do_8             //|< i
  ,cfg_dp_8             //|< i
  ,cfg_mode_multi_batch //|< i
  ,cfg_mode_per_element //|< i
  ,pwrbus_ram_pd        //|< i
  ,reg2dp_batch_number  //|< i
  ,reg2dp_channel       //|< i
  ,reg2dp_height        //|< i
  ,reg2dp_width         //|< i
  ,roc_wr_pd            //|< i
  ,roc_wr_vld           //|< i
  ,rod0_wr_pd           //|< i
  ,rod1_wr_pd           //|< i
  ,rod2_wr_pd           //|< i
  ,rod3_wr_pd           //|< i
  ,rod_wr_mask          //|< i
  ,rod_wr_vld           //|< i
  ,sdp_brdma2dp_ready   //|< i
  ,layer_end            //|> o
  ,roc_wr_rdy           //|> o
  ,rod_wr_rdy           //|> o
  ,sdp_brdma2dp_pd      //|> o
  ,sdp_brdma2dp_valid   //|> o
  );
//
// NV_NVDLA_SDP_BRDMA_EG_ro_ports.v
//
input  nvdla_core_clk;   /* sdp_brdma2dp */
input  nvdla_core_rstn;  /* sdp_brdma2dp */

output         sdp_brdma2dp_valid;  /* data valid */
input          sdp_brdma2dp_ready;  /* data return handshake */
output [256:0] sdp_brdma2dp_pd;

input [31:0] pwrbus_ram_pd;


input  [255:0] rod0_wr_pd;
input  [255:0] rod1_wr_pd;
input  [255:0] rod2_wr_pd;
input  [255:0] rod3_wr_pd;
input    [3:0] rod_wr_mask;
input          rod_wr_vld;
output         rod_wr_rdy;
input    [3:0] roc_wr_pd;
input          roc_wr_vld;
output         roc_wr_rdy;
input          cfg_do_8;
input          cfg_dp_8;
input          cfg_mode_multi_batch;
input          cfg_mode_per_element;
input    [4:0] reg2dp_batch_number;
input   [12:0] reg2dp_channel;
input   [12:0] reg2dp_height;
input   [12:0] reg2dp_width;

output layer_end;

reg      [1:0] beat_cnt;
reg      [4:0] count_b;
reg      [8:0] count_c;
reg            count_e;
reg     [12:0] count_h;
reg      [1:0] count_step;
reg     [12:0] count_w;
reg            is_last_beat;
reg    [255:0] out_data;
reg            out_vld;
reg            roc_rd_en;
reg            rod0_rd_en;
reg            rod1_rd_en;
reg            rod2_rd_en;
reg            rod3_rd_en;
reg      [1:0] size_of_step;
wire           is_batch_end;
wire           is_cube_end;
wire           is_cube_last_NC;
wire           is_elem_end;
wire           is_half_NC;
wire           is_half_step;
wire           is_last_b;
wire           is_last_c;
wire           is_last_e;
wire           is_last_h;
wire           is_last_step;
wire           is_last_w;
wire           is_line_end;
wire           is_surf_end;
wire           is_width_odd;
wire           mon_rod_sel_c;
wire           out_accept;
wire           out_layer_end;
wire   [256:0] out_pd;
wire           out_rdy;
wire     [3:0] roc_rd_pd;
wire           roc_rd_prdy;
wire           roc_rd_pvld;
wire   [255:0] rod0_rd_pd;
wire           rod0_rd_prdy;
wire           rod0_rd_pvld;
wire           rod0_wr_prdy;
wire           rod0_wr_pvld;
wire   [255:0] rod1_rd_pd;
wire           rod1_rd_prdy;
wire           rod1_rd_pvld;
wire           rod1_wr_prdy;
wire           rod1_wr_pvld;
wire   [255:0] rod2_rd_pd;
wire           rod2_rd_prdy;
wire           rod2_rd_pvld;
wire           rod2_wr_prdy;
wire           rod2_wr_pvld;
wire   [255:0] rod3_rd_pd;
wire           rod3_rd_prdy;
wire           rod3_rd_pvld;
wire           rod3_wr_prdy;
wire           rod3_wr_pvld;
wire     [1:0] rod_sel;
wire     [1:0] size_of_beat;
wire           size_of_elem;
wire     [8:0] size_of_surf;
wire    [12:0] size_of_width;
// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
//==============
// CFG
//==============

//=======================================================
// DATA FIFO: WRITE SIDE
//=======================================================

assign rod_wr_rdy = {rod3_wr_prdy & rod2_wr_prdy & rod1_wr_prdy & rod0_wr_prdy};
assign rod0_wr_pvld = rod_wr_vld & rod_wr_mask[0] & (rod1_wr_prdy & rod2_wr_prdy & rod3_wr_prdy);
NV_NVDLA_SDP_BRDMA_EG_RO_dfifo u_rod0 (
   .nvdla_core_clk     (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)        //|< i
  ,.rod_wr_prdy        (rod0_wr_prdy)           //|> w
  ,.rod_wr_pvld        (rod0_wr_pvld)           //|< w
  ,.rod_wr_pd          (rod0_wr_pd[255:0])      //|< i
  ,.rod_rd_prdy        (rod0_rd_prdy)           //|< w
  ,.rod_rd_pvld        (rod0_rd_pvld)           //|> w
  ,.rod_rd_pd          (rod0_rd_pd[255:0])      //|> w
  ,.pwrbus_ram_pd      (pwrbus_ram_pd[31:0])    //|< i
  );

assign rod1_wr_pvld = rod_wr_vld & rod_wr_mask[1] & (rod0_wr_prdy & rod2_wr_prdy & rod3_wr_prdy);
NV_NVDLA_SDP_BRDMA_EG_RO_dfifo u_rod1 (
   .nvdla_core_clk     (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)        //|< i
  ,.rod_wr_prdy        (rod1_wr_prdy)           //|> w
  ,.rod_wr_pvld        (rod1_wr_pvld)           //|< w
  ,.rod_wr_pd          (rod1_wr_pd[255:0])      //|< i
  ,.rod_rd_prdy        (rod1_rd_prdy)           //|< w
  ,.rod_rd_pvld        (rod1_rd_pvld)           //|> w
  ,.rod_rd_pd          (rod1_rd_pd[255:0])      //|> w
  ,.pwrbus_ram_pd      (pwrbus_ram_pd[31:0])    //|< i
  );

assign rod2_wr_pvld = rod_wr_vld & rod_wr_mask[2] & (rod0_wr_prdy & rod1_wr_prdy & rod3_wr_prdy);
NV_NVDLA_SDP_BRDMA_EG_RO_dfifo u_rod2 (
   .nvdla_core_clk     (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)        //|< i
  ,.rod_wr_prdy        (rod2_wr_prdy)           //|> w
  ,.rod_wr_pvld        (rod2_wr_pvld)           //|< w
  ,.rod_wr_pd          (rod2_wr_pd[255:0])      //|< i
  ,.rod_rd_prdy        (rod2_rd_prdy)           //|< w
  ,.rod_rd_pvld        (rod2_rd_pvld)           //|> w
  ,.rod_rd_pd          (rod2_rd_pd[255:0])      //|> w
  ,.pwrbus_ram_pd      (pwrbus_ram_pd[31:0])    //|< i
  );

assign rod3_wr_pvld = rod_wr_vld & rod_wr_mask[3] & (rod0_wr_prdy & rod1_wr_prdy & rod2_wr_prdy);
NV_NVDLA_SDP_BRDMA_EG_RO_dfifo u_rod3 (
   .nvdla_core_clk     (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)        //|< i
  ,.rod_wr_prdy        (rod3_wr_prdy)           //|> w
  ,.rod_wr_pvld        (rod3_wr_pvld)           //|< w
  ,.rod_wr_pd          (rod3_wr_pd[255:0])      //|< i
  ,.rod_rd_prdy        (rod3_rd_prdy)           //|< w
  ,.rod_rd_pvld        (rod3_rd_pvld)           //|> w
  ,.rod_rd_pd          (rod3_rd_pd[255:0])      //|> w
  ,.pwrbus_ram_pd      (pwrbus_ram_pd[31:0])    //|< i
  );


//=======================================================
// DATA FIFO: READ SIDE
//=======================================================









//&Always;
//    if (out_rdy) begin
//        if (cfg_mode_per_element) begin
//            if (cfg_mode_multi_batch) begin
//                rod0_rd_prdy = is_last_beat & is_batch_end;
//            end else begin
//                rod0_rd_prdy = (rod_sel==0);
//            end
//        end else begin
//            rod0_rd_prdy = is_last_beat & is_surf_end;
//        end
//    end else begin
//        rod0_rd_prdy = 1'b0;
//    end
//&End;
// rod_rd_prdy
//                                    (cfg_mode_multi_batch 
//                                    ? (cfg_mode_per_element 
//                                        ? (is_batch_end)
//                                        : (is_batch_end & is_surf_end & is_last_beat)
//                                      )
//                                    : (cfg_mode_per_element 
//                                        ? (rod_sel==$i)
//                                        : (is_surf_end & is_last_beat)
//                                      )
//                                    ); 


always @(
  cfg_mode_multi_batch
  or cfg_mode_per_element
  or is_last_b
  or count_step
  or cfg_do_8
  or is_last_h
  or is_last_w
  or rod_sel
  or is_surf_end
  or is_last_beat
  ) begin
   if (cfg_mode_multi_batch) begin
       if (cfg_mode_per_element) begin
          rod0_rd_en = is_last_b & (count_step==0);
       end else begin
          if (cfg_do_8) begin
              rod0_rd_en = is_last_b & is_last_h & is_last_w & rod_sel==0;
          end else begin
              rod0_rd_en = is_last_b & is_last_h & is_last_w & rod_sel==0;
          end
       end
   end else begin
       if (cfg_mode_per_element) begin
           rod0_rd_en = rod_sel==0;
       end else begin
           rod0_rd_en = is_surf_end & is_last_beat;
       end
   end
end

assign rod0_rd_prdy = out_rdy & rod0_rd_en;


always @(
  cfg_mode_multi_batch
  or cfg_mode_per_element
  or is_last_b
  or count_step
  or cfg_do_8
  or is_last_h
  or is_last_w
  or rod_sel
  or is_surf_end
  or is_last_beat
  ) begin
   if (cfg_mode_multi_batch) begin
       if (cfg_mode_per_element) begin
          rod1_rd_en = is_last_b & (count_step==1);
       end else begin
          if (cfg_do_8) begin
              rod1_rd_en = is_last_b & is_last_h & is_last_w & rod_sel==1;
          end else begin
              rod1_rd_en = is_last_b & is_last_h & is_last_w & rod_sel==1;
          end
       end
   end else begin
       if (cfg_mode_per_element) begin
           rod1_rd_en = rod_sel==1;
       end else begin
           rod1_rd_en = is_surf_end & is_last_beat;
       end
   end
end

assign rod1_rd_prdy = out_rdy & rod1_rd_en;


always @(
  cfg_mode_multi_batch
  or cfg_mode_per_element
  or is_last_b
  or count_step
  or cfg_do_8
  or is_last_h
  or is_last_w
  or rod_sel
  or is_surf_end
  or is_last_beat
  ) begin
   if (cfg_mode_multi_batch) begin
       if (cfg_mode_per_element) begin
          rod2_rd_en = is_last_b & (count_step==2);
       end else begin
          if (cfg_do_8) begin
              rod2_rd_en = is_last_b & is_last_h & is_last_w & rod_sel==2;
          end else begin
              rod2_rd_en = is_last_b & is_last_h & is_last_w & rod_sel==2;
          end
       end
   end else begin
       if (cfg_mode_per_element) begin
           rod2_rd_en = rod_sel==2;
       end else begin
           rod2_rd_en = is_surf_end & is_last_beat;
       end
   end
end

assign rod2_rd_prdy = out_rdy & rod2_rd_en;


always @(
  cfg_mode_multi_batch
  or cfg_mode_per_element
  or is_last_b
  or count_step
  or cfg_do_8
  or is_last_h
  or is_last_w
  or rod_sel
  or is_surf_end
  or is_last_beat
  ) begin
   if (cfg_mode_multi_batch) begin
       if (cfg_mode_per_element) begin
          rod3_rd_en = is_last_b & (count_step==3);
       end else begin
          if (cfg_do_8) begin
              rod3_rd_en = is_last_b & is_last_h & is_last_w & rod_sel==3;
          end else begin
              rod3_rd_en = is_last_b & is_last_h & is_last_w & rod_sel==3;
          end
       end
   end else begin
       if (cfg_mode_per_element) begin
           rod3_rd_en = rod_sel==3;
       end else begin
           rod3_rd_en = is_surf_end & is_last_beat;
       end
   end
end

assign rod3_rd_prdy = out_rdy & rod3_rd_en;

//==============
// CMD FIFO
//==============
// One entry in ROC indicates one entry from latency fifo
NV_NVDLA_SDP_BRDMA_EG_RO_cfifo u_roc (
   .nvdla_core_clk     (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)        //|< i
  ,.roc_wr_prdy        (roc_wr_rdy)             //|> o
  ,.roc_wr_pvld        (roc_wr_vld)             //|< i
  ,.roc_wr_pd          (roc_wr_pd[3:0])         //|< i
  ,.roc_rd_prdy        (roc_rd_prdy)            //|< w
  ,.roc_rd_pvld        (roc_rd_pvld)            //|> w
  ,.roc_rd_pd          (roc_rd_pd[3:0])         //|> w
  ,.pwrbus_ram_pd      (pwrbus_ram_pd[31:0])    //|< i
  );

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
  nv_assert_never #(0,0,"roc need be faster than rod0")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, rod0_rd_pvld & !roc_rd_pvld); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(
  cfg_mode_multi_batch
  or cfg_mode_per_element
  or is_batch_end
  or is_last_step
  or is_surf_end
  or is_last_beat
  or is_elem_end
  ) begin
    if (cfg_mode_multi_batch) begin
        if (cfg_mode_per_element) begin
            roc_rd_en = is_batch_end & is_last_step;
        end else begin
            roc_rd_en = is_batch_end & is_surf_end & is_last_beat;
        end
    end else begin
        roc_rd_en = is_elem_end & is_last_beat & (is_surf_end | cfg_mode_per_element);
    end
end
assign roc_rd_prdy = roc_rd_en & out_accept;

assign size_of_beat = {2{roc_rd_pvld}} & roc_rd_pd[1:0];
assign is_half_NC = roc_rd_pvld & roc_rd_pd[2:2];
assign is_cube_last_NC = roc_rd_pvld & roc_rd_pd[3:3];
assign out_layer_end = is_cube_end;

//==============
// END
//==============
//assign is_batch_end = is_last_b & is_last_step;
assign is_batch_end = is_last_b;

assign is_elem_end  = is_last_e;
assign is_line_end  = is_elem_end & is_last_w & is_last_b;
assign is_surf_end  = is_line_end  & is_last_h;
assign is_cube_end  = is_surf_end  & is_last_c;

//==============
// Batch_RR Count: round 
//==============
always @(
  cfg_mode_multi_batch
  or cfg_do_8
  ) begin
    if (cfg_mode_multi_batch) begin
        if (cfg_do_8) begin
            //if (is_half) begin
            //    size_of_step = 2'd1;
            //end else begin
                  size_of_step = 2'd3;
            //end
        end else begin
            //if (is_half) begin
            //    size_of_step = 2'd0;
            //end else begin
                  size_of_step = 2'd1;
            //end
        end
    end else begin
        size_of_step = 2'd0; 
    end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_step <= {2{1'b0}};
  end else begin
    if (cfg_mode_multi_batch) begin
        if (out_accept) begin
            if (is_last_step) begin
                count_step <= 0;
            end else begin
                count_step <= count_step + 1;
            end
        end
    end
  end
end

assign is_width_odd = reg2dp_width[0]==0;
assign is_last_step = (is_last_w & is_width_odd) ? (count_step==(size_of_step>>1)) : (count_step==size_of_step);
assign is_half_step = count_step==(size_of_step>>1);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_b <= {5{1'b0}};
  end else begin
    if (cfg_mode_multi_batch) begin
        if (out_accept) begin
            if (is_last_step) begin
                if (is_last_b) begin
                    count_b <= 0;
                end else begin
                    count_b <= count_b + 1;
                end
            end
        end
    end
  end
end
assign is_last_b = (count_b==reg2dp_batch_number);

//==============
// ELEM Count
//==============
assign size_of_elem = cfg_dp_8 ? 1'b1 : 1'b0;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_e <= 1'b0;
  end else begin
    if (out_accept) begin
        if (is_last_e) begin
            count_e <= 0;
        end else begin
            count_e <= count_e + 1;
        end
    end
  end
end
assign is_last_e = count_e==size_of_elem;

//==============
// Width Count
//==============
assign size_of_width = reg2dp_width;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_w <= {13{1'b0}};
  end else begin
    if (out_accept) begin
        if (cfg_mode_multi_batch) begin
            if (is_batch_end) begin
                if (is_line_end) begin
                    count_w <= 0;
                end else if (is_half_step || is_last_step) begin
                    count_w <= count_w + 1;
                end
            end
        end else begin
            if (is_line_end) begin
                count_w <= 0;
            end else if (is_elem_end) begin
                count_w <= count_w + 1;
            end
        end
    end
  end
end
assign is_last_w = (count_w==size_of_width);
//assign is_last_2w = (size_of_width > 0 ) ?  (count_w==size_of_width-1) : 1'b0;

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
assign size_of_surf = cfg_dp_8 ? {1'b0,reg2dp_channel[12:5]} : reg2dp_channel[12:4];
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    count_c <= {9{1'b0}};
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    beat_cnt <= {2{1'b0}};
  end else begin
    if (out_accept) begin
        if (cfg_mode_multi_batch) begin
            if (cfg_mode_per_element) begin
                if (is_elem_end) begin
                    if (is_last_beat) begin
                        beat_cnt <= 0;
                    end else begin
                        beat_cnt <= beat_cnt + size_of_elem + 1;
                    end
                end
            end else begin
                if (is_surf_end) begin
                    if (is_last_beat) begin
                        beat_cnt <= 0;
                    end else begin
                        beat_cnt <= beat_cnt + (size_of_step>>1) + 1;
                    end
                end
            end
        end else begin
            if (cfg_mode_per_element) begin
                if (is_elem_end) begin
                    if (is_last_beat) begin
                        beat_cnt <= 0;
                    end else begin
                        beat_cnt <= beat_cnt + size_of_elem + 1;
                    end
                end
            end else begin
                if (is_surf_end) begin
                    if (is_last_beat) begin
                        beat_cnt <= 0;
                    end else begin
                        beat_cnt <= beat_cnt + size_of_elem + 1;
                    end
                end
            end
        end
    end
  end
end
always @(
  cfg_mode_multi_batch
  or beat_cnt
  or size_of_step
  or size_of_beat
  ) begin
    if (cfg_mode_multi_batch) begin
        //if (cfg_mode_per_element) begin
        //    is_last_beat = (beat_cnt+count_e)==size_of_beat;
        //end else begin
        //    is_last_beat = (beat_cnt + (size_of_step>>1))== {1'b0,size_of_beat};
        //end
        is_last_beat = (beat_cnt + (size_of_step>>1))== {1'b0,size_of_beat};
    end else begin
        is_last_beat = beat_cnt==size_of_beat;
    end
end

assign {mon_rod_sel_c,rod_sel} = beat_cnt + count_e;
//&Always;
//    if (cfg_mode_multi_batch) begin
//        if (cfg_mode_per_element) begin
//            {mon_rod_sel_c,rod_sel} = {1'b0,count_step};
//        end else begin
//            {mon_rod_sel_c,rod_sel} = beat_cnt + count_e;
//        end
//    end else begin
//        {mon_rod_sel_c,rod_sel} = beat_cnt + count_e;
//    end
//&End;

always @(
  rod_sel
  or rod0_rd_pd
  or rod1_rd_pd
  or rod2_rd_pd
  or rod3_rd_pd
  ) begin
//spyglass disable_block W171 W226
    case (rod_sel)
    2'd0: out_data = rod0_rd_pd;
    2'd1: out_data = rod1_rd_pd;
    2'd2: out_data = rod2_rd_pd;
    2'd3: out_data = rod3_rd_pd;
    //VCS coverage off
    default : begin 
                out_data[255:0] = {256{`x_or_0}};
              end  
    //VCS coverage on
    endcase
//spyglass enable_block W171 W226
end

always @(
  rod_sel
  or rod0_rd_pvld
  or rod1_rd_pvld
  or rod2_rd_pvld
  or rod3_rd_pvld
  ) begin
//spyglass disable_block W171 W226
    case (rod_sel)
    2'd0: out_vld = rod0_rd_pvld;
    2'd1: out_vld = rod1_rd_pvld;
    2'd2: out_vld = rod2_rd_pvld;
    2'd3: out_vld = rod3_rd_pvld;
    //VCS coverage off
    default : begin 
                out_vld = {1{`x_or_0}};
              end  
    //VCS coverage on
    endcase
//spyglass enable_block W171 W226
end

//                                            ? ( cfg_mode_per_element ? (is_last_b & rod_sel==$i) 
//                                                                     : (is_surf_end & is_last_beat) 
//                                              )
//                                            : ( cfg_mode_per_element ? (rod_sel==$i) 
//                                                                     : (is_surf_end && is_last_beat) 
//                                              )
//                                            );
// mask is to tell which data is true
//assign out_mask = {16{1'b1}};

//==============
// OUTPUT PACK and PIPE: To Data Processor
//==============
// PD Pack

// PKT_PACK_WIRE( sdp_brdma2dp , out_ , out_pd )
assign      out_pd[255:0] =    out_data[255:0];
assign      out_pd[256] =    out_layer_end ;
// out_data

assign out_accept = out_vld & out_rdy;
NV_NVDLA_SDP_BRDMA_EG_RO_pipe_p1 pipe_p1 (
   .nvdla_core_clk     (nvdla_core_clk)         //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)        //|< i
  ,.out_pd             (out_pd[256:0])          //|< w
  ,.out_vld            (out_vld)                //|< r
  ,.sdp_brdma2dp_ready (sdp_brdma2dp_ready)     //|< i
  ,.out_rdy            (out_rdy)                //|> w
  ,.sdp_brdma2dp_pd    (sdp_brdma2dp_pd[256:0]) //|> o
  ,.sdp_brdma2dp_valid (sdp_brdma2dp_valid)     //|> o
  );

assign layer_end = sdp_brdma2dp_valid & sdp_brdma2dp_ready & sdp_brdma2dp_pd[256:256];

//==============
// ASSERTIONS
//==============
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
  nv_assert_never #(0,0,"rod_sel should never overflow")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, mon_rod_sel_c); // spyglass disable W504 SelfDeterminedExpr-ML 
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

endmodule // NV_NVDLA_SDP_BRDMA_EG_ro



// **************************************************************************************************************
// Generated by ::pipe -m -bc sdp_brdma2dp_pd (sdp_brdma2dp_valid,sdp_brdma2dp_ready) <= out_pd[256:0] (out_vld, out_rdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_BRDMA_EG_RO_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,out_pd
  ,out_vld
  ,sdp_brdma2dp_ready
  ,out_rdy
  ,sdp_brdma2dp_pd
  ,sdp_brdma2dp_valid
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [256:0] out_pd;
input          out_vld;
input          sdp_brdma2dp_ready;
output         out_rdy;
output [256:0] sdp_brdma2dp_pd;
output         sdp_brdma2dp_valid;
reg            out_rdy;
reg    [256:0] p1_pipe_data;
reg    [256:0] p1_pipe_rand_data;
reg            p1_pipe_rand_ready;
reg            p1_pipe_rand_valid;
reg            p1_pipe_ready;
reg            p1_pipe_ready_bc;
reg            p1_pipe_valid;
reg    [256:0] sdp_brdma2dp_pd;
reg            sdp_brdma2dp_valid;
//## pipe (1) randomizer
`ifndef SYNTHESIS
reg p1_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p1_pipe_rand_active
  or 
     `endif
     out_vld
  or p1_pipe_rand_ready
  or out_pd
  ) begin
  `ifdef SYNTHESIS
  p1_pipe_rand_valid = out_vld;
  out_rdy = p1_pipe_rand_ready;
  p1_pipe_rand_data = out_pd[256:0];
  `else
  // VCS coverage off
  p1_pipe_rand_valid = (p1_pipe_rand_active)? 1'b0 : out_vld;
  out_rdy = (p1_pipe_rand_active)? 1'b0 : p1_pipe_rand_ready;
  p1_pipe_rand_data = (p1_pipe_rand_active)?  'bx : out_pd[256:0];
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
  if      ( $value$plusargs( "NV_NVDLA_SDP_BRDMA_EG_ro_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_SDP_BRDMA_EG_ro_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_SDP_BRDMA_EG_ro_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_SDP_BRDMA_EG_ro_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_SDP_BRDMA_EG_ro_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_BRDMA_EG_ro_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_SDP_BRDMA_EG_ro_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p1_pipe_rand_enable;
reg p1_pipe_rand_poised;
always @(
  p1_pipe_stall_cycles
  or p1_pipe_stall_probability
  or out_vld
  ) begin
  p1_pipe_rand_active = p1_pipe_stall_cycles != 0;
  p1_pipe_rand_enable = p1_pipe_stall_probability != 0;
  p1_pipe_rand_poised = p1_pipe_rand_enable && !p1_pipe_rand_active && out_vld === 1'b1;
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
//## pipe (1) output
always @(
  p1_pipe_valid
  or sdp_brdma2dp_ready
  or p1_pipe_data
  ) begin
  sdp_brdma2dp_valid = p1_pipe_valid;
  p1_pipe_ready = sdp_brdma2dp_ready;
  sdp_brdma2dp_pd = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (sdp_brdma2dp_valid^sdp_brdma2dp_ready^out_vld^out_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_4x (nvdla_core_clk, `ASSERT_RESET, (out_vld && !out_rdy), (out_vld), (out_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_SDP_BRDMA_EG_RO_pipe_p1



// Re-Order Data
// if we have rd_reg, then depth = required - 1 ,so depth=4-1=3
//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_SDP_BRDMA_EG_RO_dfifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus rod_wr -rd_pipebus rod_rd -rand_none -d 1 -ram_bypass -rd_reg -rd_busy_reg -w 256 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_SDP_BRDMA_EG_RO_dfifo (
      nvdla_core_clk
    , nvdla_core_rstn
    , rod_wr_prdy
    , rod_wr_pvld
    , rod_wr_pd
    , rod_rd_prdy
    , rod_rd_pvld
    , rod_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        rod_wr_prdy;
input         rod_wr_pvld;
input  [255:0] rod_wr_pd;
input         rod_rd_prdy;
output        rod_rd_pvld;
output [255:0] rod_rd_pd;
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
reg        rod_wr_busy_int;		        	// copy for internal use
assign     rod_wr_prdy = !rod_wr_busy_int;
assign       wr_reserving = rod_wr_pvld && !rod_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg        rod_wr_count;			// write-side count

wire       wr_count_next_wr_popping = wr_reserving ? rod_wr_count : (rod_wr_count - 1'd1); // spyglass disable W164a W484
wire       wr_count_next_no_wr_popping = wr_reserving ? (rod_wr_count + 1'd1) : rod_wr_count; // spyglass disable W164a W484
wire       wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_1 = ( wr_count_next_no_wr_popping == 1'd1 );
wire wr_count_next_is_1 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_1;
wire       wr_limit_muxed;  // muxed with simulation/emulation overrides
wire       wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       rod_wr_busy_next = wr_count_next_is_1 || // busy next cycle?
                          (wr_limit_reg != 1'd0 &&      // check rod_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rod_wr_busy_int <=  1'b0;
        rod_wr_count <=  1'd0;
    end else begin
	rod_wr_busy_int <=  rod_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    rod_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            rod_wr_count <=  {1{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as rod_wr_pvld

//
// RAM
//

wire rd_popping;

wire ram_we = wr_pushing && (rod_wr_count > 1'd0 || !rd_popping);   // note: write occurs next cycle
wire [255:0] rod_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_SDP_BRDMA_EG_RO_dfifo_flopram_rwsa_1x256 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( rod_wr_pd )
    , .we        ( ram_we )
    , .ra        ( (rod_wr_count == 0) ? 1'd1 : 1'b0 )
    , .dout        ( rod_rd_pd_p )
    );


//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

reg        rod_rd_prdy_d;				// rod_rd_prdy registered in cleanly

always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rod_rd_prdy_d <=  1'b1;
    end else begin
        rod_rd_prdy_d <=  rod_rd_prdy;
    end
end

wire       rod_rd_prdy_d_o;			// combinatorial rd_busy

reg        rod_rd_pvld_int;			// internal copy of rod_rd_pvld

assign     rod_rd_pvld = rod_rd_pvld_int;
wire       rod_rd_pvld_p; 		// data out of fifo is valid

reg        rod_rd_pvld_int_o;	// internal copy of rod_rd_pvld_o
wire       rod_rd_pvld_o = rod_rd_pvld_int_o;
assign     rd_popping = rod_rd_pvld_p && !(rod_rd_pvld_int_o && !rod_rd_prdy_d_o);

reg        rod_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire       rd_count_p_next_rd_popping = rd_pushing ? rod_rd_count_p : 
                                                                (rod_rd_count_p - 1'd1);
wire       rd_count_p_next_no_rd_popping =  rd_pushing ? (rod_rd_count_p + 1'd1) : 
                                                                    rod_rd_count_p;
// spyglass enable_block W164a W484
wire       rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     rod_rd_pvld_p = rod_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rod_rd_count_p <=  1'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    rod_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            rod_rd_count_p <=  {1{`x_or_0}};
        end
        //synopsys translate_on

    end
end


// 
// SKID for -rd_busy_reg
//
reg [255:0]  rod_rd_pd_o;         // output data register
wire        rd_req_next_o = (rod_rd_pvld_p || (rod_rd_pvld_int_o && !rod_rd_prdy_d_o)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rod_rd_pvld_int_o <=  1'b0;
    end else begin
        rod_rd_pvld_int_o <=  rd_req_next_o;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rod_rd_pvld_int && rd_req_next_o && rd_popping) ) begin
        rod_rd_pd_o <=  rod_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rod_rd_pvld_int && rd_req_next_o && rd_popping)) ) begin
    end else begin
        rod_rd_pd_o <=  {256{`x_or_0}};
    end
    //synopsys translate_on

end

//
// FINAL OUTPUT
//
reg [255:0]  rod_rd_pd;				// output data register
reg        rod_rd_pvld_int_d;			// so we can bubble-collapse rod_rd_prdy_d
assign     rod_rd_prdy_d_o = !((rod_rd_pvld_o && rod_rd_pvld_int_d && !rod_rd_prdy_d ) );
wire       rd_req_next = (!rod_rd_prdy_d_o ? rod_rd_pvld_o : rod_rd_pvld_p) ;  

always @( posedge nvdla_core_clk or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        rod_rd_pvld_int <=  1'b0;
        rod_rd_pvld_int_d <=  1'b0;
    end else begin
        if ( !rod_rd_pvld_int || rod_rd_prdy ) begin
	    rod_rd_pvld_int <=  rd_req_next;
        end
        //synopsys translate_off
            else if ( !(!rod_rd_pvld_int || rod_rd_prdy) ) begin
        end else begin
            rod_rd_pvld_int <=  `x_or_0;
        end
        //synopsys translate_on


        rod_rd_pvld_int_d <=  rod_rd_pvld_int;
    end
end

always @( posedge nvdla_core_clk ) begin
    if ( rd_req_next && (!rod_rd_pvld_int || rod_rd_prdy ) ) begin
        case (!rod_rd_prdy_d_o) 
            1'b0:    rod_rd_pd <=  rod_rd_pd_p;
            1'b1:    rod_rd_pd <=  rod_rd_pd_o;
            //VCS coverage off
            default: rod_rd_pd <=  {256{`x_or_0}};
            //VCS coverage on
        endcase
    end
    //synopsys translate_off
        else if ( !(rd_req_next && (!rod_rd_pvld_int || rod_rd_prdy)) ) begin
    end else begin
        rod_rd_pd <=  {256{`x_or_0}};
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
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (rod_wr_pvld && !rod_wr_busy_int) || (rod_wr_busy_int != rod_wr_busy_next)) || (rd_pushing || rd_popping || (rod_rd_pvld_int && rod_rd_prdy_d) || (rod_rd_pvld_int_o && rod_rd_prdy_d_o)) || (wr_pushing))
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_SDP_BRDMA_EG_RO_dfifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_SDP_BRDMA_EG_RO_dfifo_wr_limit : 1'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 1'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 1'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 1'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg       wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 1'd0;
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
    if ( $test$plusargs( "NV_NVDLA_SDP_BRDMA_EG_RO_dfifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_SDP_BRDMA_EG_RO_dfifo_wr_limit=%d", wr_limit_override_value);
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
    , .max      ( {31'd0, (wr_limit_reg == 1'd0) ? 1'd1 : wr_limit_reg} )
    , .curr	( {31'd0, rod_wr_count} )
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
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_BRDMA_EG_RO_dfifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_SDP_BRDMA_EG_RO_dfifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_SDP_BRDMA_EG_RO_dfifo_flopram_rwsa_1x256 (
      clk
    , pwrbus_ram_pd
    , di
    , we
    , ra
    , dout
    );

input  clk;  // write clock
input [31 : 0] pwrbus_ram_pd;
input  [255:0] di;
input  we;
input  [0:0] ra;
output [255:0] dout;

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

reg [255:0] ram_ff0;

always @( posedge clk ) begin
    if ( we ) begin
	ram_ff0 <=  di;
    end
end

reg [255:0] dout;

always @(*) begin
    case( ra ) 
    1'd0:       dout = ram_ff0;
    1'd1:       dout = di;
    //VCS coverage off
    default:    dout = {256{`x_or_0}};
    //VCS coverage on
    endcase
end

endmodule // NV_NVDLA_SDP_BRDMA_EG_RO_dfifo_flopram_rwsa_1x256

//
// AUTOMATICALLY GENERATED -- DO NOT EDIT OR CHECK IN
//
// /home/nvtools/engr/2017/03/11_05_00_06/nvtools/scripts/fifogen
// fifogen -input_config_yaml ../../../../../../../socd/ip_chip_tools/1.0/defs/public/fifogen/golden/tlit5/fifogen.yml -no_make_ram -no_make_ram -stdout -m NV_NVDLA_SDP_BRDMA_EG_RO_cfifo -clk_name nvdla_core_clk -reset_name nvdla_core_rstn -wr_pipebus roc_wr -rd_pipebus roc_rd -rand_none -d 4 -ram_bypass -rd_busy_reg -w 4 -ram ff [Chosen ram type: ff - fifogen_flops (user specified, thus no other ram type is allowed)]
// chip config vars: assertion_module_prefix=nv_  strict_synchronizers=1  strict_synchronizers_use_lib_cells=1  strict_synchronizers_use_tm_lib_cells=1  strict_sync_randomizer=1  assertion_message_prefix=FIFOGEN_ASSERTION  allow_async_fifola=0  ignore_ramgen_fifola_variant=1  uses_p_SSYNC=0  uses_prand=1  uses_rammake_inc=1  use_x_or_0=1  force_wr_reg_gated=1  no_force_reset=1  no_timescale=1  no_pli_ifdef=1  requires_full_throughput=1  ram_auto_ff_bits_cutoff=16  ram_auto_ff_width_cutoff=2  ram_auto_ff_width_cutoff_max_depth=32  ram_auto_ff_depth_cutoff=-1  ram_auto_ff_no_la2_depth_cutoff=5  ram_auto_la2_width_cutoff=8  ram_auto_la2_width_cutoff_max_depth=56  ram_auto_la2_depth_cutoff=16  flopram_emu_model=1  dslp_single_clamp_port=1  dslp_clamp_port=1  slp_single_clamp_port=1  slp_clamp_port=1  master_clk_gated=1  clk_gate_module=NV_CLK_gate_power  redundant_timing_flops=0  hot_reset_async_force_ports_and_loopback=1  ram_sleep_en_width=1  async_cdc_reg_id=NV_AFIFO_  rd_reg_default_for_async=1  async_ram_instance_prefix=NV_ASYNC_RAM_  allow_rd_busy_reg_warning=0  do_dft_xelim_gating=1  add_dft_xelim_wr_clkgate=1  add_dft_xelim_rd_clkgate=1 
//
// leda B_3208_NV OFF -- Unequal length LHS and RHS in assignment
// leda B_1405 OFF -- 2 asynchronous resets in this unit detected
`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_SDP_BRDMA_EG_RO_cfifo (
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
input  [3:0] roc_wr_pd;
input         roc_rd_prdy;
output        roc_rd_pvld;
output [3:0] roc_rd_pd;
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
wire [3:0] roc_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_SDP_BRDMA_EG_RO_cfifo_flopram_rwsa_4x4 ram (
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
reg [3:0]  roc_rd_pd_o;         // output data register
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
        roc_rd_pd_o <=  {4{`x_or_0}};
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
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_SDP_BRDMA_EG_RO_cfifo_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_SDP_BRDMA_EG_RO_cfifo_wr_limit : 3'd0;
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
    if ( $test$plusargs( "NV_NVDLA_SDP_BRDMA_EG_RO_cfifo_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_SDP_BRDMA_EG_RO_cfifo_wr_limit=%d", wr_limit_override_value);
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
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_BRDMA_EG_RO_cfifo") true
// synopsys dc_script_end


endmodule // NV_NVDLA_SDP_BRDMA_EG_RO_cfifo

// 
// Flop-Based RAM 
//
module NV_NVDLA_SDP_BRDMA_EG_RO_cfifo_flopram_rwsa_4x4 (
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
input  [3:0] di;
input  we;
input  [1:0] wa;
input  [2:0] ra;
output [3:0] dout;

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


wire [3:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [1:0] Wa0_vmw;
reg we0_vmw;
reg [3:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_SDP_BRDMA_EG_RO_cfifo_flopram_rwsa_4x4 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[1:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 4) ? di : dout_p;

`else

reg [3:0] ram_ff0;
reg [3:0] ram_ff1;
reg [3:0] ram_ff2;
reg [3:0] ram_ff3;

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

reg [3:0] dout;

always @(*) begin
    case( ra ) 
    3'd0:       dout = ram_ff0;
    3'd1:       dout = ram_ff1;
    3'd2:       dout = ram_ff2;
    3'd3:       dout = ram_ff3;
    3'd4:       dout = di;
    //VCS coverage off
    default:    dout = {4{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_SDP_BRDMA_EG_RO_cfifo_flopram_rwsa_4x4

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_SDP_BRDMA_EG_RO_cfifo_flopram_rwsa_4x4 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [1:0] Wa0;
input            we0;
input  [3:0] Di0;
input  [1:0] Ra0;
output [3:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 4'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [3:0] mem[3:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [3:0] Q0 = mem[0];
wire [3:0] Q1 = mem[1];
wire [3:0] Q2 = mem[2];
wire [3:0] Q3 = mem[3];
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

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_SDP_BRDMA_EG_RO_cfifo_flopram_rwsa_4x4] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_SDP_BRDMA_EG_RO_cfifo_flopram_rwsa_4x4] }
endmodule // vmw_NV_NVDLA_SDP_BRDMA_EG_RO_cfifo_flopram_rwsa_4x4

//vmw: Memory vmw_NV_NVDLA_SDP_BRDMA_EG_RO_cfifo_flopram_rwsa_4x4
//vmw: Address-size 2
//vmw: Data-size 4
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[3:0] data0[3:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[3:0] data1[3:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_SDP_BRDMA_EG_RO_cfifo_flopram_rwsa_4x4
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU

