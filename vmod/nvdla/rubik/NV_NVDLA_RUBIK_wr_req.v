// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_RUBIK_wr_req.v

module NV_NVDLA_RUBIK_wr_req (
   nvdla_core_clk          //|< i
  ,nvdla_core_rstn         //|< i
  ,dma_wr_cmd_pd           //|< i
  ,dma_wr_cmd_vld          //|< i
  ,dma_wr_data_pd          //|< i
  ,dma_wr_data_vld         //|< i
  ,dp2reg_consumer         //|< i
  ,pwrbus_ram_pd           //|< i
  ,reg2dp_dataout_ram_type //|< i
  ,reg2dp_perf_en          //|< i
  ,wr_req_rdy              //|< i
  ,dma_wr_cmd_rdy          //|> o
  ,dma_wr_data_rdy         //|> o
  ,dp2reg_d0_wr_stall_cnt  //|> o
  ,dp2reg_d1_wr_stall_cnt  //|> o
  ,dp2reg_done             //|> o
  ,wr_req_pd               //|> o
  ,wr_req_type             //|> o
  ,wr_req_vld              //|> o
  );


input           nvdla_core_clk;
input           nvdla_core_rstn;
input           dp2reg_consumer;
input    [31:0] pwrbus_ram_pd;
input           reg2dp_dataout_ram_type;
input           reg2dp_perf_en;
output   [31:0] dp2reg_d0_wr_stall_cnt;
output   [31:0] dp2reg_d1_wr_stall_cnt;

output           wr_req_type;
output           wr_req_vld;
output  [514:0]  wr_req_pd;
input            wr_req_rdy;

input            dma_wr_cmd_vld;
input   [77:0]   dma_wr_cmd_pd;
output           dma_wr_cmd_rdy;

input            dma_wr_data_vld;
input   [513:0]  dma_wr_data_pd;
output           dma_wr_data_rdy;

output           dp2reg_done;

reg       [3:0] dbuf_remain;
reg      [31:0] dp2reg_d0_wr_stall_cnt;
reg      [31:0] dp2reg_d1_wr_stall_cnt;
reg             dp2reg_done_d;
reg             fill_half;
reg             last_wr_cmd;
reg             mon_dbuf_remain;
reg             mon_wr_dcnt_c;
reg             send_cmd;
reg             send_cmd_open;
reg             send_data;
reg      [13:0] send_data_size;
reg             send_half;
reg             stl_adv;
reg      [31:0] stl_cnt_cur;
reg      [33:0] stl_cnt_dec;
reg      [33:0] stl_cnt_ext;
reg      [33:0] stl_cnt_inc;
reg      [33:0] stl_cnt_mod;
reg      [33:0] stl_cnt_new;
reg      [33:0] stl_cnt_nxt;
reg      [12:0] wr_data_cnt;
reg             wr_req_stall_inc_d;
reg      [31:0] wr_stall_cnt;
wire            dbuf_nempty;
wire   [513:78] dma_wr_cmd_hpd;
wire     [77:0] dma_wr_cmd_opd;
wire     [72:0] dma_wr_cmd_opdt;
wire            dma_wr_cmd_ordy;
wire            dma_wr_cmd_ovld;
wire            dma_wr_cmd_pop;
wire            dma_wr_cmd_req_vld;
wire    [511:0] dma_wr_data_opd;
wire            dma_wr_data_ordy;
wire            dma_wr_data_pop;
wire            dma_wr_data_push;
wire            dma_wr_data_req_vld;
wire    [255:0] dma_wr_datah_opd;
wire            dma_wr_datah_ordy;
wire            dma_wr_datah_ovld;
wire    [255:0] dma_wr_datah_pd;
wire            dma_wr_datah_pop;
wire            dma_wr_datah_rdy;
wire            dma_wr_datah_vld;
wire    [255:0] dma_wr_datal_opd;
wire            dma_wr_datal_ordy;
wire            dma_wr_datal_ovld;
wire    [255:0] dma_wr_datal_pd;
wire            dma_wr_datal_pop;
wire            dma_wr_datal_rdy;
wire            dma_wr_datal_vld;
wire      [1:0] fifo_mask;
wire      [1:0] fifo_omask;
wire            mon_remain_dsize;
wire      [1:0] pop_size;
wire      [1:0] push_size;
wire     [13:0] remain_data_size;
wire            send_data_done;
wire     [13:0] wr_data_cnt_inc;
wire            wr_req_stall_inc;
wire            wr_stall_cnt_dec;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    

assign   dp2reg_done = send_data_done & last_wr_cmd; 
assign   wr_req_type = reg2dp_dataout_ram_type;
assign   wr_req_vld  = dma_wr_cmd_req_vld || dma_wr_data_req_vld; 
assign   wr_req_pd[514:514]      = dma_wr_cmd_pop ? 1'd0  /* PKT_nvdla_dma_wr_req_dma_write_cmd_ID  */  : 1'd1  /* PKT_nvdla_dma_wr_req_dma_write_data_ID  */ ;
assign   wr_req_pd[513:0] = dma_wr_cmd_pop ? {dma_wr_cmd_hpd,dma_wr_cmd_opd} : {fifo_omask,dma_wr_data_opd};
assign   dma_wr_cmd_hpd[513:78] = {436{1'b0}};

assign   dma_wr_cmd_ordy = send_cmd & wr_req_rdy; 
assign   dma_wr_cmd_pop  = dma_wr_cmd_ordy  & dma_wr_cmd_ovld;
assign   dma_wr_cmd_req_vld = send_cmd & dma_wr_cmd_ovld;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    send_cmd <= 1'b0;
  end else begin
    if (dma_wr_cmd_pop)
        send_cmd <= 1'b0;
    else if((send_cmd_open | send_data_done) & dbuf_nempty)
        send_cmd <= 1'b1;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    send_cmd_open <= 1'b1;
  end else begin
    if (send_cmd_open & dbuf_nempty)
        send_cmd_open <= 1'b0;
    else if (send_data_done & ~dbuf_nempty)
        send_cmd_open <= 1'b1;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    send_data <= 1'b0;
  end else begin
    if (send_data_done)
        send_data <= 1'b0;
    else if (dma_wr_cmd_pop)
        send_data <= 1'b1;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_wr_cmd <= 1'b0;
    send_data_size <= {14{1'b0}};
  end else begin
    if (dma_wr_cmd_pop) begin
        last_wr_cmd <= dma_wr_cmd_opd[77:77];
        send_data_size <= dma_wr_cmd_opd[76:64]+1;
    end
  end
end

//push data
assign   fifo_mask[1:0]        = dma_wr_data_pd[513:512];
assign   dma_wr_data_rdy       = ~fifo_mask[1] ? (fill_half ? dma_wr_datah_rdy : dma_wr_datal_rdy) : dma_wr_datah_rdy & dma_wr_datal_rdy;
assign   dma_wr_data_push      = dma_wr_data_vld & dma_wr_data_rdy;
assign   dma_wr_datah_vld      = dma_wr_data_push & (&fifo_mask[1:0] ||  fill_half & ~fifo_mask[1]);
assign   dma_wr_datal_vld      = dma_wr_data_push & (&fifo_mask[1:0] || !fill_half & ~fifo_mask[1]);
assign   dma_wr_datah_pd[255:0]= fill_half ? dma_wr_data_pd[255:0]   : dma_wr_data_pd[511:256] ;
assign   dma_wr_datal_pd[255:0]= fill_half ? dma_wr_data_pd[511:256] : dma_wr_data_pd[255:0] ;
assign   push_size[1:0]        = fifo_mask[1] + fifo_mask[0];

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    fill_half <= 1'b0;
  end else begin
    if (dp2reg_done)
        fill_half <= 1'b0;
    else if (dma_wr_data_push & ~fifo_mask[1])
        fill_half <= ~fill_half;
  end
end

//pop data
assign   dma_wr_data_ordy       = send_data & wr_req_rdy;
assign   dma_wr_datah_ordy      = (~fifo_omask[1] ? !send_half ? 1'b0 : dma_wr_datah_ovld : dma_wr_datah_ovld & dma_wr_datal_ovld) & dma_wr_data_ordy;
assign   dma_wr_datal_ordy      = (~fifo_omask[1] ?  send_half ? 1'b0 : dma_wr_datal_ovld : dma_wr_datah_ovld & dma_wr_datal_ovld) & dma_wr_data_ordy;
assign   dma_wr_data_opd[511:0] = send_half ? {dma_wr_datal_opd[255:0],dma_wr_datah_opd[255:0]} : {dma_wr_datah_opd[255:0],dma_wr_datal_opd[255:0]};

assign   dma_wr_data_req_vld = send_data & (~fifo_omask[1] ? !send_half ? dma_wr_datal_ovld : dma_wr_datah_ovld : dma_wr_datah_ovld & dma_wr_datal_ovld); 

assign   dma_wr_datah_pop = dma_wr_datah_ordy & dma_wr_datah_ovld;
assign   dma_wr_datal_pop = dma_wr_datal_ordy & dma_wr_datal_ovld;
assign   dma_wr_data_pop  = dma_wr_datah_pop | dma_wr_datal_pop;
assign   pop_size[1:0]    = dma_wr_datah_pop + dma_wr_datal_pop;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    send_half <= 1'b0;
  end else begin
    if (dp2reg_done)
        send_half <= 1'b0;
    else if (dma_wr_data_pop & ~fifo_omask[1])
        send_half <= ~send_half;
  end
end

assign  {mon_remain_dsize,remain_data_size} = send_data_size - wr_data_cnt;
assign  fifo_omask[1:0] = remain_data_size == 1'b1 ? 2'b01 : 2'b11;

assign  wr_data_cnt_inc = wr_data_cnt + pop_size;
assign  send_data_done  = dma_wr_data_pop & (wr_data_cnt_inc >= send_data_size);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_data_cnt <= {13{1'b0}};
    {mon_wr_dcnt_c,wr_data_cnt} <= {14{1'b0}};
  end else begin
    if (send_data_done) 
        wr_data_cnt <= {13'b0}; 
    else if(dma_wr_data_pop) 
        {mon_wr_dcnt_c,wr_data_cnt} <= wr_data_cnt_inc;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    {mon_dbuf_remain,dbuf_remain[3:0]} <= {5{1'b0}};
  end else begin
    if (dma_wr_data_push & dma_wr_data_pop)
        {mon_dbuf_remain,dbuf_remain[3:0]} <= dbuf_remain+push_size-pop_size; 
    else if (dma_wr_data_push)
        {mon_dbuf_remain,dbuf_remain[3:0]} <= dbuf_remain+push_size; 
    else if (dma_wr_data_pop)
        {mon_dbuf_remain,dbuf_remain[3:0]} <= dbuf_remain-pop_size; 
  end
end

assign  dbuf_nempty = |dbuf_remain[3:0];                           

assign    dma_wr_cmd_opd[77:0] = {dma_wr_cmd_opdt[72:0],5'h0};

NV_NVDLA_RUBIK_wrdma_cmd rbk_dma_wr_cmd_fifo (
   .nvdla_core_clk  (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)         //|< i
  ,.idata_prdy      (dma_wr_cmd_rdy)          //|> o
  ,.idata_pvld      (dma_wr_cmd_vld)          //|< i
  ,.idata_pd        (dma_wr_cmd_pd[77:5])     //|< i
  ,.odata_prdy      (dma_wr_cmd_ordy)         //|< w
  ,.odata_pvld      (dma_wr_cmd_ovld)         //|> w
  ,.odata_pd        (dma_wr_cmd_opdt[72:0])   //|> w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

NV_NVDLA_RUBIK_wrdma_data rbk_dma_wr_datah_fifo (
   .nvdla_core_clk  (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)         //|< i
  ,.idata_prdy      (dma_wr_datah_rdy)        //|> w
  ,.idata_pvld      (dma_wr_datah_vld)        //|< w
  ,.idata_pd        (dma_wr_datah_pd[255:0])  //|< w
  ,.odata_prdy      (dma_wr_datah_ordy)       //|< w
  ,.odata_pvld      (dma_wr_datah_ovld)       //|> w
  ,.odata_pd        (dma_wr_datah_opd[255:0]) //|> w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

NV_NVDLA_RUBIK_wrdma_data rbk_dma_wr_datal_fifo (
   .nvdla_core_clk  (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)         //|< i
  ,.idata_prdy      (dma_wr_datal_rdy)        //|> w
  ,.idata_pvld      (dma_wr_datal_vld)        //|< w
  ,.idata_pd        (dma_wr_datal_pd[255:0])  //|< w
  ,.odata_prdy      (dma_wr_datal_ordy)       //|< w
  ,.odata_pvld      (dma_wr_datal_ovld)       //|> w
  ,.odata_pd        (dma_wr_datal_opd[255:0]) //|> w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

assign  wr_req_stall_inc = wr_req_vld & !wr_req_rdy;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_req_stall_inc_d <= 1'b0;
  end else begin
  wr_req_stall_inc_d <= wr_req_stall_inc;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_done_d <= 1'b0;
  end else begin
  dp2reg_done_d <= dp2reg_done;
  end
end




    assign wr_stall_cnt_dec = 1'b0;

    // stl adv logic

    always @(
      wr_req_stall_inc_d
      or wr_stall_cnt_dec
      ) begin
      stl_adv = wr_req_stall_inc_d ^ wr_stall_cnt_dec;
    end
        
    // stl cnt logic
    always @(
      stl_cnt_cur
      or wr_req_stall_inc_d
      or wr_stall_cnt_dec
      or stl_adv
      or dp2reg_done_d
      ) begin
      // VCS sop_coverage_off start
      stl_cnt_ext[33:0] = {1'b0, 1'b0, stl_cnt_cur};
      stl_cnt_inc[33:0] = stl_cnt_cur + 1'b1; // spyglass disable W164b
      stl_cnt_dec[33:0] = stl_cnt_cur - 1'b1; // spyglass disable W164b
      stl_cnt_mod[33:0] = (wr_req_stall_inc_d && !wr_stall_cnt_dec)? stl_cnt_inc : (!wr_req_stall_inc_d && wr_stall_cnt_dec)? stl_cnt_dec : stl_cnt_ext;
      stl_cnt_new[33:0] = (stl_adv)? stl_cnt_mod[33:0] : stl_cnt_ext[33:0];
      stl_cnt_nxt[33:0] = (dp2reg_done_d)? 34'd0 : stl_cnt_new[33:0];
      // VCS sop_coverage_off end
    end

    // stl flops

    always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
      if (!nvdla_core_rstn) begin
        stl_cnt_cur[31:0] <= 0;
      end else begin
      if (reg2dp_perf_en) begin
      stl_cnt_cur[31:0] <= stl_cnt_nxt[31:0];
      end
      end
    end

    // stl output logic

    always @(
      stl_cnt_cur
      ) begin
      wr_stall_cnt[31:0] = stl_cnt_cur[31:0];
    end
        
      

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d0_wr_stall_cnt <= {32{1'b0}};
  end else begin
   if (dp2reg_done & ~dp2reg_consumer)
       dp2reg_d0_wr_stall_cnt <= wr_stall_cnt; 
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dp2reg_d1_wr_stall_cnt <= {32{1'b0}};
  end else begin
   if (dp2reg_done & dp2reg_consumer)
       dp2reg_d1_wr_stall_cnt <= wr_stall_cnt; 
  end
end


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

    property rubik_wr_req__wr_request_block__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        wr_req_vld & ~wr_req_rdy;
    endproperty
    // Cover 0 : "wr_req_vld & ~wr_req_rdy"
    FUNCPOINT_rubik_wr_req__wr_request_block__0_COV : cover property (rubik_wr_req__wr_request_block__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property rubik_wr_req__wr_req_cmd_after_rf_nempty__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        send_data_done & ~dbuf_nempty;
    endproperty
    // Cover 1 : "send_data_done & ~dbuf_nempty"
    FUNCPOINT_rubik_wr_req__wr_req_cmd_after_rf_nempty__1_COV : cover property (rubik_wr_req__wr_req_cmd_after_rf_nempty__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property rubik_wr_req__dma_wr_dbuf_fill_half__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        dma_wr_data_push & fill_half;
    endproperty
    // Cover 2 : "dma_wr_data_push & fill_half"
    FUNCPOINT_rubik_wr_req__dma_wr_dbuf_fill_half__2_COV : cover property (rubik_wr_req__dma_wr_dbuf_fill_half__2_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property rubik_wr_req__dma_wr_dbuf_send_half__3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        dma_wr_data_pop & send_half;
    endproperty
    // Cover 3 : "dma_wr_data_pop & send_half"
    FUNCPOINT_rubik_wr_req__dma_wr_dbuf_send_half__3_COV : cover property (rubik_wr_req__dma_wr_dbuf_send_half__3_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_RUBIK_wr_req

