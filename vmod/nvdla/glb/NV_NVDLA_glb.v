// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_glb.v

module NV_NVDLA_glb (
   cacc2glb_done_intr_pd     //|< i
#ifdef NVDLA_BDMA_ENABLE
  ,bdma2glb_done_intr_pd     //|< i
#endif
  ,cdma_dat2glb_done_intr_pd //|< i
  ,cdma_wt2glb_done_intr_pd  //|< i
#ifdef NVDLA_CDP_ENABLE
  ,cdp2glb_done_intr_pd      //|< i
#endif
  ,csb2glb_req_pd            //|< i
  ,csb2glb_req_pvld          //|< i
  ,direct_reset_             //|< i
  ,nvdla_core_clk            //|< i
  ,nvdla_core_rstn           //|< i
  ,nvdla_falcon_clk          //|< i
  ,nvdla_falcon_rstn         //|< i
#ifdef NVDLA_PDP_ENABLE
  ,pdp2glb_done_intr_pd      //|< i
#endif
#ifdef NVDLA_RUBIK_ENABLE 
  ,rubik2glb_done_intr_pd    //|< i
#endif
  ,sdp2glb_done_intr_pd      //|< i
  ,test_mode                 //|< i
  ,core_intr                 //|> o
  ,csb2glb_req_prdy          //|> o
  ,glb2csb_resp_pd           //|> o
  ,glb2csb_resp_valid        //|> o
  );

//
// NV_NVDLA_glb_io.v
//

input         csb2glb_req_pvld;  /* data valid */
output        csb2glb_req_prdy;  /* data return handshake */
input  [62:0] csb2glb_req_pd;

output        glb2csb_resp_valid;  /* data valid */
output [33:0] glb2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output  core_intr;

input [1:0] sdp2glb_done_intr_pd;
#ifdef NVDLA_CDP_ENABLE
input [1:0] cdp2glb_done_intr_pd;
#endif
#ifdef NVDLA_PDP_ENABLE
input [1:0] pdp2glb_done_intr_pd;
#endif
#ifdef NVDLA_BDMA_ENABLE
input [1:0] bdma2glb_done_intr_pd;
#endif
#ifdef NVDLA_RUBIK_ENABLE 
input [1:0] rubik2glb_done_intr_pd;
#endif
input [1:0] cdma_wt2glb_done_intr_pd;
input [1:0] cdma_dat2glb_done_intr_pd;
input [1:0] cacc2glb_done_intr_pd;


input nvdla_core_clk;
input nvdla_falcon_clk;
input nvdla_core_rstn;
input nvdla_falcon_rstn;
input test_mode;
input direct_reset_;




#ifdef NVDLA_BDMA_ENABLE
wire        bdma_done_mask0;
wire        bdma_done_mask1;
wire        bdma_done_status0;
wire        bdma_done_status1;
#endif
wire        cacc_done_mask0;
wire        cacc_done_mask1;
wire        cacc_done_status0;
wire        cacc_done_status1;
wire        cdma_dat_done_mask0;
wire        cdma_dat_done_mask1;
wire        cdma_dat_done_status0;
wire        cdma_dat_done_status1;
wire        cdma_wt_done_mask0;
wire        cdma_wt_done_mask1;
wire        cdma_wt_done_status0;
wire        cdma_wt_done_status1;
#ifdef NVDLA_CDP_ENABLE
wire        cdp_done_mask0;
wire        cdp_done_mask1;
wire        cdp_done_status0;
wire        cdp_done_status1;
#endif
#ifdef NVDLA_PDP_ENABLE
wire        pdp_done_mask0;
wire        pdp_done_mask1;
wire        pdp_done_status0;
wire        pdp_done_status1;
#endif
#ifdef NVDLA_RUBIK_ENABLE 
wire        rubik_done_mask0;
wire        rubik_done_mask1;
wire        rubik_done_status0;
wire        rubik_done_status1;
#endif
wire        sdp_done_mask0;
wire        sdp_done_mask1;
wire        sdp_done_set0_trigger;
wire        sdp_done_status0;
wire        sdp_done_status0_trigger;
wire        sdp_done_status1;
wire [31:0] req_wdat;

////////////////////////////////////////////////////////
//  csb interface
////////////////////////////////////////////////////////
NV_NVDLA_GLB_csb u_csb (
   .nvdla_core_clk            (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)                //|< i
#ifdef NVDLA_BDMA_ENABLE
  ,.bdma_done_status0         (bdma_done_status0)              //|< w
  ,.bdma_done_status1         (bdma_done_status1)              //|< w
#endif
  ,.cacc_done_status0         (cacc_done_status0)              //|< w
  ,.cacc_done_status1         (cacc_done_status1)              //|< w
  ,.cdma_dat_done_status0     (cdma_dat_done_status0)          //|< w
  ,.cdma_dat_done_status1     (cdma_dat_done_status1)          //|< w
  ,.cdma_wt_done_status0      (cdma_wt_done_status0)           //|< w
  ,.cdma_wt_done_status1      (cdma_wt_done_status1)           //|< w
#ifdef NVDLA_CDP_ENABLE
  ,.cdp_done_status0          (cdp_done_status0)               //|< w
  ,.cdp_done_status1          (cdp_done_status1)               //|< w
#endif
  ,.csb2glb_req_pd            (csb2glb_req_pd[62:0])           //|< i
  ,.csb2glb_req_pvld          (csb2glb_req_pvld)               //|< i
#ifdef NVDLA_PDP_ENABLE
  ,.pdp_done_status0          (pdp_done_status0)               //|< w
  ,.pdp_done_status1          (pdp_done_status1)               //|< w
#endif
#ifdef NVDLA_RUBIK_ENABLE 
  ,.rubik_done_status0        (rubik_done_status0)             //|< w
  ,.rubik_done_status1        (rubik_done_status1)             //|< w
#endif
  ,.sdp_done_status0          (sdp_done_status0)               //|< w
  ,.sdp_done_status1          (sdp_done_status1)               //|< w
#ifdef NVDLA_BDMA_ENABLE
  ,.bdma_done_mask0           (bdma_done_mask0)                //|> w
  ,.bdma_done_mask1           (bdma_done_mask1)                //|> w
#endif
  ,.cacc_done_mask0           (cacc_done_mask0)                //|> w
  ,.cacc_done_mask1           (cacc_done_mask1)                //|> w
  ,.cdma_dat_done_mask0       (cdma_dat_done_mask0)            //|> w
  ,.cdma_dat_done_mask1       (cdma_dat_done_mask1)            //|> w
  ,.cdma_wt_done_mask0        (cdma_wt_done_mask0)             //|> w
  ,.cdma_wt_done_mask1        (cdma_wt_done_mask1)             //|> w
#ifdef NVDLA_CDP_ENABLE
  ,.cdp_done_mask0            (cdp_done_mask0)                 //|> w
  ,.cdp_done_mask1            (cdp_done_mask1)                 //|> w
#endif
  ,.csb2glb_req_prdy          (csb2glb_req_prdy)               //|> o
  ,.glb2csb_resp_pd           (glb2csb_resp_pd[33:0])          //|> o
  ,.glb2csb_resp_valid        (glb2csb_resp_valid)             //|> o
#ifdef NVDLA_PDP_ENABLE
  ,.pdp_done_mask0            (pdp_done_mask0)                 //|> w
  ,.pdp_done_mask1            (pdp_done_mask1)                 //|> w
#endif
#ifdef NVDLA_RUBIK_ENABLE 
  ,.rubik_done_mask0          (rubik_done_mask0)               //|> w
  ,.rubik_done_mask1          (rubik_done_mask1)               //|> w
#endif
  ,.sdp_done_mask0            (sdp_done_mask0)                 //|> w
  ,.sdp_done_mask1            (sdp_done_mask1)                 //|> w
  ,.sdp_done_set0_trigger     (sdp_done_set0_trigger)          //|> w
  ,.sdp_done_status0_trigger  (sdp_done_status0_trigger)       //|> w
  ,.req_wdat                  (req_wdat[31:0])                 //|> w
  );

////////////////////////////////////////////////////////
//  interrupt controller
////////////////////////////////////////////////////////
NV_NVDLA_GLB_ic u_ic (
   .nvdla_core_clk            (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn           (nvdla_core_rstn)                //|< i
#ifdef NVDLA_BDMA_ENABLE
  ,.bdma2glb_done_intr_pd     (bdma2glb_done_intr_pd[1:0])     //|< i
  ,.bdma_done_mask0           (bdma_done_mask0)                //|< w
  ,.bdma_done_mask1           (bdma_done_mask1)                //|< w
#endif
  ,.cacc2glb_done_intr_pd     (cacc2glb_done_intr_pd[1:0])     //|< i
  ,.cacc_done_mask0           (cacc_done_mask0)                //|< w
  ,.cacc_done_mask1           (cacc_done_mask1)                //|< w
  ,.cdma_dat2glb_done_intr_pd (cdma_dat2glb_done_intr_pd[1:0]) //|< i
  ,.cdma_dat_done_mask0       (cdma_dat_done_mask0)            //|< w
  ,.cdma_dat_done_mask1       (cdma_dat_done_mask1)            //|< w
  ,.cdma_wt2glb_done_intr_pd  (cdma_wt2glb_done_intr_pd[1:0])  //|< i
  ,.cdma_wt_done_mask0        (cdma_wt_done_mask0)             //|< w
  ,.cdma_wt_done_mask1        (cdma_wt_done_mask1)             //|< w
#ifdef NVDLA_CDP_ENABLE
  ,.cdp2glb_done_intr_pd      (cdp2glb_done_intr_pd[1:0])      //|< i
  ,.cdp_done_mask0            (cdp_done_mask0)                 //|< w
  ,.cdp_done_mask1            (cdp_done_mask1)                 //|< w
#endif
  ,.nvdla_falcon_clk          (nvdla_falcon_clk)               //|< i
  ,.nvdla_falcon_rstn         (nvdla_falcon_rstn)              //|< i
#ifdef NVDLA_PDP_ENABLE
  ,.pdp2glb_done_intr_pd      (pdp2glb_done_intr_pd[1:0])      //|< i
  ,.pdp_done_mask0            (pdp_done_mask0)                 //|< w
  ,.pdp_done_mask1            (pdp_done_mask1)                 //|< w
#endif
#ifdef NVDLA_RUBIK_ENABLE 
  ,.rubik2glb_done_intr_pd    (rubik2glb_done_intr_pd[1:0])    //|< i
  ,.rubik_done_mask0          (rubik_done_mask0)               //|< w
  ,.rubik_done_mask1          (rubik_done_mask1)               //|< w
#endif
  ,.req_wdat                  (req_wdat[21:0])                 //|< w
  ,.sdp2glb_done_intr_pd      (sdp2glb_done_intr_pd[1:0])      //|< i
  ,.sdp_done_mask0            (sdp_done_mask0)                 //|< w
  ,.sdp_done_mask1            (sdp_done_mask1)                 //|< w
  ,.sdp_done_set0_trigger     (sdp_done_set0_trigger)          //|< w
  ,.sdp_done_status0_trigger  (sdp_done_status0_trigger)       //|< w
#ifdef NVDLA_BDMA_ENABLE
  ,.bdma_done_status0         (bdma_done_status0)              //|> w
  ,.bdma_done_status1         (bdma_done_status1)              //|> w
#endif
  ,.cacc_done_status0         (cacc_done_status0)              //|> w
  ,.cacc_done_status1         (cacc_done_status1)              //|> w
  ,.cdma_dat_done_status0     (cdma_dat_done_status0)          //|> w
  ,.cdma_dat_done_status1     (cdma_dat_done_status1)          //|> w
  ,.cdma_wt_done_status0      (cdma_wt_done_status0)           //|> w
  ,.cdma_wt_done_status1      (cdma_wt_done_status1)           //|> w
#ifdef NVDLA_CDP_ENABLE
  ,.cdp_done_status0          (cdp_done_status0)               //|> w
  ,.cdp_done_status1          (cdp_done_status1)               //|> w
#endif
#ifdef NVDLA_PDP_ENABLE
  ,.pdp_done_status0          (pdp_done_status0)               //|> w
  ,.pdp_done_status1          (pdp_done_status1)               //|> w
#endif
#ifdef NVDLA_RUBIK_ENABLE 
  ,.rubik_done_status0        (rubik_done_status0)             //|> w
  ,.rubik_done_status1        (rubik_done_status1)             //|> w
#endif
  ,.sdp_done_status0          (sdp_done_status0)               //|> w
  ,.sdp_done_status1          (sdp_done_status1)               //|> w
  ,.core_intr                 (core_intr)                      //|> o
  );

//////////////////////////////////////////////////////////
////  Dangles/Contenders report                       
//////////////////////////////////////////////////////////

endmodule // NV_NVDLA_glb
