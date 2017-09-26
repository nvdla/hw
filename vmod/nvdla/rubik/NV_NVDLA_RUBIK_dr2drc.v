// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_RUBIK_dr2drc.v

module NV_NVDLA_RUBIK_dr2drc (
   data_fifo_rdy       //|< i
  ,nvdla_core_clk      //|< i
  ,nvdla_core_rstn     //|< i
  ,pwrbus_ram_pd       //|< i
  ,rd_rsp_pd           //|< i
  ,rd_rsp_vld          //|< i
  ,data_fifo_pd        //|> o
  ,data_fifo_vld       //|> o
  ,rd_cdt_lat_fifo_pop //|> o
  ,rd_rsp_rdy          //|> o
  );


input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [31:0] pwrbus_ram_pd;

input          rd_rsp_vld;
input [513:0]   rd_rsp_pd;
output         rd_rsp_rdy;
output         rd_cdt_lat_fifo_pop;

output         data_fifo_vld;
output [511:0] data_fifo_pd;
input          data_fifo_rdy;

//output         dr2drc_q0_vld;
//output [255:0] dr2drc_q0_pd;
//input          dr2drc_q0_rdy;
//output         dr2drc_q1_vld;
//output [255:0] dr2drc_q1_pd;
//input          dr2drc_q1_rdy;

wire  [255:0] data_fifo_pd_h;
wire  [255:0] data_fifo_pd_l;
wire          data_fifo_pop;
wire          data_fifo_rdy_h;
wire          data_fifo_rdy_l;
wire          data_fifo_vld_h;
wire          data_fifo_vld_l;
wire  [511:0] fifo_idata;
wire  [255:0] fifo_idata_h;
wire  [255:0] fifo_idata_l;
wire          fifo_idata_ready_h;
wire          fifo_idata_ready_l;
wire          fifo_idata_valid_h;
wire          fifo_idata_valid_l;
wire    [1:0] fifo_mask;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
/////////write data to data_fifo/////////////
assign    fifo_mask[1:0]    = rd_rsp_pd[513:512];
assign    fifo_idata[511:0] = rd_rsp_pd[511:0];
assign    fifo_idata_h[255:0] = fifo_mask[1] ? fifo_idata[511:256] : 256'h0;
assign    fifo_idata_l[255:0] = fifo_mask[0] ? fifo_idata[255:0]   : 256'h0;
assign    fifo_idata_valid_h  = rd_rsp_vld & rd_rsp_rdy;
assign    fifo_idata_valid_l  = rd_rsp_vld & rd_rsp_rdy;
assign    rd_rsp_rdy          = fifo_idata_ready_h & fifo_idata_ready_l;
//assign    fifo_imask_vld      = rd_rsp_vld & rd_rsp_rdy;

//read data from data fifo
assign    data_fifo_vld   = data_fifo_vld_h & data_fifo_vld_l;
assign    data_fifo_rdy_h = data_fifo_rdy;
assign    data_fifo_rdy_l = data_fifo_rdy;
assign    data_fifo_pd    = {data_fifo_pd_h[255:0],data_fifo_pd_l[255:0]}; //{fifo_mask_out[1:0],data_fifo_pd_h[255:0],data_fifo_pd_l[255:0]}; 
assign    data_fifo_pop   = data_fifo_vld & data_fifo_rdy;
//assign    data_mask_rdy   = data_fifo_pop;
assign    rd_cdt_lat_fifo_pop = data_fifo_pop;

//assign    qbuf_vld_h      = data_fifo_vld & ( fill_half || fifo_mask_out[1]);       
//assign    qbuf_vld_l      = data_fifo_vld & (!fill_half || fifo_mask_out[0]);   
//assign    qbuf_pd_h[255:0]= fill_half ? data_fifo_pd_l[255:0] : data_fifo_pd_h[255:0] ; 
//assign    qbuf_pd_l[255:0]= fill_half ? data_fifo_pd_h[255:0] : data_fifo_pd_l[255:0] ; 
//
//&Always posedge;
//    if (data_fifo_pop & ~fifo_mask_out[1])
//        fill_half <0= ~fill_half;
//&End;

/****************** Fifo L *****************/
NV_NVDLA_RUBIK_fifo rbk_fifo_l (
   .nvdla_core_clk  (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)       //|< i
  ,.idata_prdy      (fifo_idata_ready_l)    //|> w
  ,.idata_pvld      (fifo_idata_valid_l)    //|< w
  ,.idata_pd        (fifo_idata_l[255:0])   //|< w
  ,.odata_prdy      (data_fifo_rdy_l)       //|< w
  ,.odata_pvld      (data_fifo_vld_l)       //|> w
  ,.odata_pd        (data_fifo_pd_l[255:0]) //|> w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])   //|< i
  );

/****************** Fifo H *****************/
NV_NVDLA_RUBIK_fifo rbk_fifo_h (
   .nvdla_core_clk  (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)       //|< i
  ,.idata_prdy      (fifo_idata_ready_h)    //|> w
  ,.idata_pvld      (fifo_idata_valid_h)    //|< w
  ,.idata_pd        (fifo_idata_h[255:0])   //|< w
  ,.odata_prdy      (data_fifo_rdy_h)       //|< w
  ,.odata_pvld      (data_fifo_vld_h)       //|> w
  ,.odata_pd        (data_fifo_pd_h[255:0]) //|> w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])   //|< i
  );


/*
//fifo mask buffer
&Instance NV_NVDLA_RUBIK_mbuf rbk_mask_buffer;
&Connect  nvdla_core_clk      nvdla_core_clk    ;
&Connect  nvdla_core_rstn     nvdla_core_rstn   ;
&Connect  idata_prdy          fifo_imask_ready  ;
&Connect  idata_pvld          fifo_imask_vld    ;
&Connect  idata_pd            fifo_mask[1:0]    ;
&Connect  odata_prdy          data_mask_rdy      ;
&Connect  odata_pvld          data_mask_vld      ;
&Connect  odata_pd            fifo_mask_out[1:0] ;
&Connect  pwrbus_ram_pd       pwrbus_ram_pd[31:0];

&Terminate data_mask_vld;
&Terminate fifo_imask_ready;

//q0 buffer
&Instance NV_NVDLA_RUBIK_qbuf rbk_qbuf_l;
&Connect  nvdla_core_clk      nvdla_core_clk    ;
&Connect  nvdla_core_rstn     nvdla_core_rstn   ;
&Connect  idata_prdy          qbuf_rdy_l        ;
&Connect  idata_pvld          qbuf_vld_l        ;
&Connect  idata_pd            qbuf_pd_l[255:0]  ;
&Connect  odata_prdy          dr2drc_q0_rdy      ;
&Connect  odata_pvld          dr2drc_q0_vld      ;
&Connect  odata_pd            dr2drc_q0_pd[255:0];
&Connect  pwrbus_ram_pd       pwrbus_ram_pd[31:0];

//q1 buffer
&Instance NV_NVDLA_RUBIK_qbuf rbk_qbuf_h;
&Connect  nvdla_core_clk      nvdla_core_clk    ;
&Connect  nvdla_core_rstn     nvdla_core_rstn   ;
&Connect  idata_prdy          qbuf_rdy_h        ;
&Connect  idata_pvld          qbuf_vld_h        ;
&Connect  idata_pd            qbuf_pd_h[255:0]  ;
&Connect  odata_prdy          dr2drc_q1_rdy      ;
&Connect  odata_pvld          dr2drc_q1_vld      ;
&Connect  odata_pd            dr2drc_q1_pd[255:0];
&Connect  pwrbus_ram_pd       pwrbus_ram_pd[31:0];
*/

endmodule // NV_NVDLA_RUBIK_dr2drc

