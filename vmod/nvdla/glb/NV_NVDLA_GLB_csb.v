// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_GLB_csb.v

module NV_NVDLA_GLB_csb (
   nvdla_core_clk           //|< i
  ,nvdla_core_rstn          //|< i
#ifdef NVDLA_BDMA_ENABLE
  ,bdma_done_status0        //|< i
  ,bdma_done_status1        //|< i
#endif
  ,cacc_done_status0        //|< i
  ,cacc_done_status1        //|< i
  ,cdma_dat_done_status0    //|< i
  ,cdma_dat_done_status1    //|< i
  ,cdma_wt_done_status0     //|< i
  ,cdma_wt_done_status1     //|< i
#ifdef NVDLA_CDP_ENABLE
  ,cdp_done_status0         //|< i
  ,cdp_done_status1         //|< i
#endif
  ,csb2glb_req_pd           //|< i
  ,csb2glb_req_pvld         //|< i
#ifdef NVDLA_PDP_ENABLE
  ,pdp_done_status0         //|< i
  ,pdp_done_status1         //|< i
#endif
#ifdef NVDLA_RUBIK_ENABLE 
  ,rubik_done_status0       //|< i
  ,rubik_done_status1       //|< i
#endif
  ,sdp_done_status0         //|< i
  ,sdp_done_status1         //|< i
#ifdef NVDLA_BDMA_ENABLE
  ,bdma_done_mask0          //|> o
  ,bdma_done_mask1          //|> o
#endif
  ,cacc_done_mask0          //|> o
  ,cacc_done_mask1          //|> o
  ,cdma_dat_done_mask0      //|> o
  ,cdma_dat_done_mask1      //|> o
  ,cdma_wt_done_mask0       //|> o
  ,cdma_wt_done_mask1       //|> o
#ifdef NVDLA_CDP_ENABLE
  ,cdp_done_mask0           //|> o
  ,cdp_done_mask1           //|> o
#endif
  ,csb2glb_req_prdy         //|> o
  ,glb2csb_resp_pd          //|> o
  ,glb2csb_resp_valid       //|> o
#ifdef NVDLA_PDP_ENABLE
  ,pdp_done_mask0           //|> o
  ,pdp_done_mask1           //|> o
#endif
  ,req_wdat                 //|> o
#ifdef NVDLA_RUBIK_ENABLE 
  ,rubik_done_mask0         //|> o
  ,rubik_done_mask1         //|> o
#endif
  ,sdp_done_mask0           //|> o
  ,sdp_done_mask1           //|> o
  ,sdp_done_set0_trigger    //|> o
  ,sdp_done_status0_trigger //|> o
  );

input         nvdla_core_clk;
input         nvdla_core_rstn;
#ifdef NVDLA_BDMA_ENABLE
input         bdma_done_status0;
input         bdma_done_status1;
#endif
input         cacc_done_status0;
input         cacc_done_status1;
input         cdma_dat_done_status0;
input         cdma_dat_done_status1;
input         cdma_wt_done_status0;
input         cdma_wt_done_status1;
#ifdef NVDLA_CDP_ENABLE
input         cdp_done_status0;
input         cdp_done_status1;
#endif
input  [62:0] csb2glb_req_pd;
input         csb2glb_req_pvld;
#ifdef NVDLA_PDP_ENABLE
input         pdp_done_status0;
input         pdp_done_status1;
#endif
#ifdef NVDLA_RUBIK_ENABLE 
input         rubik_done_status0;
input         rubik_done_status1;
#endif
input         sdp_done_status0;
input         sdp_done_status1;
#ifdef NVDLA_BDMA_ENABLE
output        bdma_done_mask0;
output        bdma_done_mask1;
#endif
output        cacc_done_mask0;
output        cacc_done_mask1;
output        cdma_dat_done_mask0;
output        cdma_dat_done_mask1;
output        cdma_wt_done_mask0;
output        cdma_wt_done_mask1;
#ifdef NVDLA_CDP_ENABLE
output        cdp_done_mask0;
output        cdp_done_mask1;
#endif
output        csb2glb_req_prdy;
output [33:0] glb2csb_resp_pd;
output        glb2csb_resp_valid;
#ifdef NVDLA_PDP_ENABLE
output        pdp_done_mask0;
output        pdp_done_mask1;
#endif
output [31:0] req_wdat;
#ifdef NVDLA_RUBIK_ENABLE 
output        rubik_done_mask0;
output        rubik_done_mask1;
#endif
output        sdp_done_mask0;
output        sdp_done_mask1;
output        sdp_done_set0_trigger;
output        sdp_done_status0_trigger;
reg    [33:0] glb2csb_resp_pd;
reg           glb2csb_resp_valid;
reg    [62:0] req_pd;
reg           req_vld;
wire          bdma_done_set0;
wire          bdma_done_set1;
wire          cacc_done_set0;
wire          cacc_done_set1;
wire          cdma_dat_done_set0;
wire          cdma_dat_done_set1;
wire          cdma_wt_done_set0;
wire          cdma_wt_done_set1;
wire          cdp_done_set0;
wire          cdp_done_set1;
wire          pdp_done_set0;
wire          pdp_done_set1;
wire   [11:0] reg_offset;
wire   [31:0] reg_rd_data;
wire   [31:0] reg_wr_data;
wire          reg_wr_en;
wire   [21:0] req_addr;
wire    [1:0] req_level_NC;
wire          req_nposted;
wire          req_srcpriv_NC;
wire    [3:0] req_wrbe_NC;
wire          req_write;
wire   [33:0] rsp_pd;
wire          rsp_rd_error;
wire   [32:0] rsp_rd_pd;
wire   [31:0] rsp_rd_rdat;
wire          rsp_rd_vld;
wire          rsp_vld;
wire          rsp_wr_error;
wire   [32:0] rsp_wr_pd;
wire   [31:0] rsp_wr_rdat;
wire          rsp_wr_vld;
wire          rubik_done_set0;
wire          rubik_done_set1;
wire          sdp_done_set0;
wire          sdp_done_set1;


//////////////////////////////////////////////////////////
////  register
//////////////////////////////////////////////////////////

//tie 0 for wo type register read
assign bdma_done_set0 = 1'b0;
assign bdma_done_set1 = 1'b0;
assign cdp_done_set0  = 1'b0;
assign cdp_done_set1  = 1'b0;
assign pdp_done_set0  = 1'b0;
assign pdp_done_set1  = 1'b0;
assign sdp_done_set0  = 1'b0;
assign sdp_done_set1  = 1'b0;
assign rubik_done_set0  = 1'b0;
assign rubik_done_set1  = 1'b0;
assign cdma_dat_done_set0  = 1'b0;
assign cdma_dat_done_set1  = 1'b0;
assign cdma_wt_done_set0  = 1'b0;
assign cdma_wt_done_set1  = 1'b0;
assign cacc_done_set0  = 1'b0;
assign cacc_done_set1  = 1'b0;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        req_vld <= 1'b0;
    end else begin
        req_vld <= csb2glb_req_pvld;
    end
end
always @(posedge nvdla_core_clk) begin
    if ((csb2glb_req_pvld) == 1'b1) begin
        req_pd <= csb2glb_req_pd;
    end
end
assign csb2glb_req_prdy = 1'b1;

// ========
// REQUEST
// ========
// flow=pvld_prdy 
assign req_level_NC = req_pd[62:61];
assign req_nposted = req_pd[55:55];
assign req_addr = req_pd[21:0];
assign req_wrbe_NC = req_pd[60:57];
assign req_srcpriv_NC = req_pd[56:56];
assign req_write = req_pd[54:54];
assign req_wdat = req_pd[53:22];
// ========
// RESPONSE
// ========
// flow=valid 
assign rsp_rd_pd[32:32] = rsp_rd_error;
assign rsp_rd_pd[31:0] = rsp_rd_rdat;
assign rsp_wr_pd[32:32] = rsp_wr_error;
assign rsp_wr_pd[31:0] = rsp_wr_rdat;


assign rsp_rd_vld  = req_vld & ~req_write;
assign rsp_rd_rdat = {32{rsp_rd_vld}} & reg_rd_data;
assign rsp_rd_error  = 1'b0;

assign rsp_wr_vld  = req_vld & req_write & req_nposted;
assign rsp_wr_rdat = {32{1'b0}};
assign rsp_wr_error  = 1'b0;

// ========
// REQUEST
// ========
assign rsp_vld = rsp_rd_vld | rsp_wr_vld;
assign rsp_pd[33:33] = ({1{rsp_rd_vld}} & {1'h0}) 
                     | ({1{rsp_wr_vld}} & {1'h1});

assign rsp_pd[32:0] = ({33{rsp_rd_vld}} & rsp_rd_pd)
                    | ({33{rsp_wr_vld}} & rsp_wr_pd);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if (!nvdla_core_rstn) begin
        glb2csb_resp_valid <= 1'b0;
    end else begin
        glb2csb_resp_valid <= rsp_vld;
    end
end
always @(posedge nvdla_core_clk) begin
    if ((rsp_vld) == 1'b1) begin
        glb2csb_resp_pd <= rsp_pd;
    end
end

assign reg_offset = {req_addr[9:0],{2{1'b0}}};
assign reg_wr_en = req_vld & req_write;
assign reg_wr_data = req_wdat;

NV_NVDLA_GLB_CSB_reg u_reg (
     .reg_rd_data              (reg_rd_data[31:0])        //|> w
    ,.reg_offset               (reg_offset[11:0])         //|< w
    ,.reg_wr_data              (reg_wr_data[31:0])        //|< w
    ,.reg_wr_en                (reg_wr_en)                //|< w
    ,.nvdla_core_clk           (nvdla_core_clk)           //|< i
    ,.nvdla_core_rstn          (nvdla_core_rstn)          //|< i
#ifdef NVDLA_BDMA_ENABLE
    ,.bdma_done_mask0          (bdma_done_mask0)          //|> o
    ,.bdma_done_mask1          (bdma_done_mask1)          //|> o
#endif
    ,.cacc_done_mask0          (cacc_done_mask0)          //|> o
    ,.cacc_done_mask1          (cacc_done_mask1)          //|> o
    ,.cdma_dat_done_mask0      (cdma_dat_done_mask0)      //|> o
    ,.cdma_dat_done_mask1      (cdma_dat_done_mask1)      //|> o
    ,.cdma_wt_done_mask0       (cdma_wt_done_mask0)       //|> o
    ,.cdma_wt_done_mask1       (cdma_wt_done_mask1)       //|> o
#ifdef NVDLA_CDP_ENABLE
    ,.cdp_done_mask0           (cdp_done_mask0)           //|> o
    ,.cdp_done_mask1           (cdp_done_mask1)           //|> o
#endif
#ifdef NVDLA_PDP_ENABLE
    ,.pdp_done_mask0           (pdp_done_mask0)           //|> o
    ,.pdp_done_mask1           (pdp_done_mask1)           //|> o
#endif
#ifdef NVDLA_RUBIK_ENABLE 
    ,.rubik_done_mask0         (rubik_done_mask0)         //|> o
    ,.rubik_done_mask1         (rubik_done_mask1)         //|> o
#endif
    ,.sdp_done_mask0           (sdp_done_mask0)           //|> o
    ,.sdp_done_mask1           (sdp_done_mask1)           //|> o
    ,.sdp_done_set0_trigger    (sdp_done_set0_trigger)    //|> o
    ,.sdp_done_status0_trigger (sdp_done_status0_trigger) //|> o
    ,.bdma_done_set0           (bdma_done_set0)           //|< w
    ,.bdma_done_set1           (bdma_done_set1)           //|< w
    ,.cacc_done_set0           (cacc_done_set0)           //|< w
    ,.cacc_done_set1           (cacc_done_set1)           //|< w
    ,.cdma_dat_done_set0       (cdma_dat_done_set0)       //|< w
    ,.cdma_dat_done_set1       (cdma_dat_done_set1)       //|< w
    ,.cdma_wt_done_set0        (cdma_wt_done_set0)        //|< w
    ,.cdma_wt_done_set1        (cdma_wt_done_set1)        //|< w
    ,.cdp_done_set0            (cdp_done_set0)            //|< w
    ,.cdp_done_set1            (cdp_done_set1)            //|< w
    ,.pdp_done_set0            (pdp_done_set0)            //|< w
    ,.pdp_done_set1            (pdp_done_set1)            //|< w
    ,.rubik_done_set0          (rubik_done_set0)          //|< w
    ,.rubik_done_set1          (rubik_done_set1)          //|< w
    ,.sdp_done_set0            (sdp_done_set0)            //|< w
    ,.sdp_done_set1            (sdp_done_set1)            //|< w
#ifdef NVDLA_BDMA_ENABLE
    ,.bdma_done_status0        (bdma_done_status0)        //|< i
    ,.bdma_done_status1        (bdma_done_status1)        //|< i
#else
    ,.bdma_done_status0        (1'b0)                     //|< i
    ,.bdma_done_status1        (1'b0)                     //|< i
#endif
    ,.cacc_done_status0        (cacc_done_status0)        //|< i
    ,.cacc_done_status1        (cacc_done_status1)        //|< i
    ,.cdma_dat_done_status0    (cdma_dat_done_status0)    //|< i
    ,.cdma_dat_done_status1    (cdma_dat_done_status1)    //|< i
    ,.cdma_wt_done_status0     (cdma_wt_done_status0)     //|< i
    ,.cdma_wt_done_status1     (cdma_wt_done_status1)     //|< i
#ifdef NVDLA_CDP_ENABLE
    ,.cdp_done_status0         (cdp_done_status0)         //|< i
    ,.cdp_done_status1         (cdp_done_status1)         //|< i
#else
    ,.cdp_done_status0         (1'b0)                     //|< i
    ,.cdp_done_status1         (1'b0)                     //|< i
#endif
#ifdef NVDLA_PDP_ENABLE
    ,.pdp_done_status0         (pdp_done_status0)         //|< i
    ,.pdp_done_status1         (pdp_done_status1)         //|< i
#else
    ,.pdp_done_status0         (1'b0)                     //|< i
    ,.pdp_done_status1         (1'b0)                     //|< i
#endif
#ifdef NVDLA_RUBIK_ENABLE 
    ,.rubik_done_status0       (rubik_done_status0)       //|< i
    ,.rubik_done_status1       (rubik_done_status1)       //|< i
#else
    ,.rubik_done_status0       (1'b0)                     //|< i
    ,.rubik_done_status1       (1'b0)                     //|< i
#endif
    ,.sdp_done_status0         (sdp_done_status0)         //|< i
    ,.sdp_done_status1         (sdp_done_status1)         //|< i
);

endmodule // NV_NVDLA_GLB_csb
