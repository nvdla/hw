// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_csc.v

#include "NV_NVDLA_CSC.h"
#include "../cbuf/NV_NVDLA_CBUF.h"
module NV_NVDLA_csc (
   accu2sc_credit_size           //|< i
  ,accu2sc_credit_vld            //|< i
  ,cdma2sc_dat_entries           //|< i
  ,cdma2sc_dat_pending_ack       //|< i
  ,cdma2sc_dat_slices            //|< i
  ,cdma2sc_dat_updt              //|< i
  ,cdma2sc_wmb_entries           //|< i
  ,cdma2sc_wt_entries            //|< i
  ,cdma2sc_wt_kernels            //|< i
  ,cdma2sc_wt_pending_ack        //|< i
  ,cdma2sc_wt_updt               //|< i
  ,csb2csc_req_pd                //|< i
  ,csb2csc_req_pvld              //|< i
  ,dla_clk_ovr_on_sync           //|< i
  ,global_clk_ovr_on_sync        //|< i
  ,nvdla_core_clk                //|< i
  ,nvdla_core_rstn               //|< i
  ,pwrbus_ram_pd                 //|< i
  ,sc2buf_dat_rd_data            //|< i
  ,sc2buf_dat_rd_valid           //|< i
  ,sc2buf_dat_rd_shift           //|> o
  ,sc2buf_dat_rd_next1_en        //|> o
  ,sc2buf_dat_rd_next1_addr      //|> o
  ,sc2buf_wt_rd_data             //|< i
  ,sc2buf_wt_rd_valid            //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,csb2csc_req_prdy              //|> o
  ,csc2csb_resp_pd               //|> o
  ,csc2csb_resp_valid            //|> o
  ,sc2buf_dat_rd_addr            //|> o
  ,sc2buf_dat_rd_en              //|> o
  ,sc2buf_wt_rd_addr             //|> o
  ,sc2buf_wt_rd_en               //|> o
  ,sc2cdma_dat_entries           //|> o
  ,sc2cdma_dat_pending_req       //|> o
  ,sc2cdma_dat_slices            //|> o
  ,sc2cdma_dat_updt              //|> o
  ,sc2cdma_wmb_entries           //|> o
  ,sc2cdma_wt_entries            //|> o
  ,sc2cdma_wt_kernels            //|> o
  ,sc2cdma_wt_pending_req        //|> o
  ,sc2cdma_wt_updt               //|> o
  //: for(my $i=0; $i<CSC_ATOMC ; $i++){
  //: print qq(
  //: ,sc2mac_dat_a_data${i}            //|> o );
  //: }
  ,sc2mac_dat_a_mask             //|> o
  ,sc2mac_dat_a_pd               //|> o
  ,sc2mac_dat_a_pvld             //|> o
  //: for(my $i=0; $i<CSC_ATOMC ; $i++){
  //: print qq(
  //: ,sc2mac_dat_b_data${i}            //|> o );
  //: }
  ,sc2mac_dat_b_mask             //|> o
  ,sc2mac_dat_b_pd               //|> o
  ,sc2mac_dat_b_pvld             //|> o
  //: for(my $i=0; $i<CSC_ATOMC ; $i++){
  //: print qq(
  //: ,sc2mac_wt_a_data${i}            //|> o );
  //: }
  ,sc2mac_wt_a_mask              //|> o
  ,sc2mac_wt_a_pvld              //|> o
  ,sc2mac_wt_a_sel               //|> o
  //: for(my $i=0; $i<CSC_ATOMC ; $i++){
  //: print qq(
  //: ,sc2mac_wt_b_data${i}            //|> o );
  //: }
  ,sc2mac_wt_b_mask              //|> o
  ,sc2mac_wt_b_pvld              //|> o
  ,sc2mac_wt_b_sel               //|> o
  `ifdef CBUF_WEIGHT_COMPRESSED
  ,sc2buf_wmb_rd_addr            //|> o
  ,sc2buf_wmb_rd_en              //|> o
  ,sc2buf_wmb_rd_data            //|< i
  ,sc2buf_wmb_rd_valid           //|< i
  `endif
  );

input  nvdla_core_clk;  
input  nvdla_core_rstn; 
output  sc2cdma_dat_pending_req;
output  sc2cdma_wt_pending_req;
input       accu2sc_credit_vld;   /* data valid */
input [2:0] accu2sc_credit_size;
input  cdma2sc_dat_pending_ack;
input  cdma2sc_wt_pending_ack;
input         csb2csc_req_pvld;  /* data valid */
output        csb2csc_req_prdy;  /* data return handshake */
input  [62:0] csb2csc_req_pd;
output        csc2csb_resp_valid;  /* data valid */
output [33:0] csc2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */
input        cdma2sc_dat_updt;     /* data valid */
input [CSC_ENTRIES_NUM_WIDTH-1:0] cdma2sc_dat_entries;
input [13:0] cdma2sc_dat_slices;
output        sc2cdma_dat_updt;     /* data valid */
output [CSC_ENTRIES_NUM_WIDTH-1:0] sc2cdma_dat_entries;
output [13:0] sc2cdma_dat_slices;
input [31:0] pwrbus_ram_pd;
output        sc2buf_dat_rd_en;    /* data valid */
output [CBUF_ADDR_WIDTH-1:0] sc2buf_dat_rd_addr;
input          sc2buf_dat_rd_valid;  /* data valid */
input [CBUF_ENTRY_BITS-1:0] sc2buf_dat_rd_data;
output [CBUF_RD_DATA_SHIFT_WIDTH-1:0] sc2buf_dat_rd_shift;
output sc2buf_dat_rd_next1_en;
output [CBUF_ADDR_WIDTH-1:0] sc2buf_dat_rd_next1_addr;
`ifdef CBUF_WEIGHT_COMPRESSED
output       sc2buf_wmb_rd_en;    /* data valid */
output [CBUF_ADDR_WIDTH-1:0] sc2buf_wmb_rd_addr;
input          sc2buf_wmb_rd_valid;  /* data valid */
input [CBUF_ENTRY_BITS-1:0] sc2buf_wmb_rd_data;
`endif
output        sc2buf_wt_rd_en;    /* data valid */
output [CBUF_ADDR_WIDTH-1:0] sc2buf_wt_rd_addr;
input          sc2buf_wt_rd_valid;  /* data valid */
input [CBUF_ENTRY_BITS-1:0] sc2buf_wt_rd_data;
output         sc2mac_dat_a_pvld;     /* data valid */
output [CSC_ATOMC-1:0] sc2mac_dat_a_mask;
//: for(my $i=0; $i<CSC_ATOMC ; $i++){
//: print qq(
//: output   [CSC_BPE-1:0] sc2mac_dat_a_data${i}; );
//: }
output   [8:0] sc2mac_dat_a_pd;
output         sc2mac_dat_b_pvld;     /* data valid */
output [CSC_ATOMC-1:0] sc2mac_dat_b_mask;
//: for(my $i=0; $i<CSC_ATOMC ; $i++){
//: print qq(
//: output   [CSC_BPE-1:0] sc2mac_dat_b_data${i}; );
//: }
output   [8:0] sc2mac_dat_b_pd;
output         sc2mac_wt_a_pvld;     /* data valid */
output [CSC_ATOMC-1:0] sc2mac_wt_a_mask;
//: for(my $i=0; $i<CSC_ATOMC ; $i++){
//: print qq(
//: output   [CSC_BPE-1:0] sc2mac_wt_a_data${i}; );
//: }
output   [CSC_ATOMK_HF-1:0] sc2mac_wt_a_sel;
output         sc2mac_wt_b_pvld;     /* data valid */
output [CSC_ATOMC-1:0] sc2mac_wt_b_mask;
//: for(my $i=0; $i<CSC_ATOMC ; $i++){
//: print qq(
//: output   [CSC_BPE-1:0] sc2mac_wt_b_data${i}; );
//: }
output   [CSC_ATOMK_HF-1:0] sc2mac_wt_b_sel;
input        cdma2sc_wt_updt;      /* data valid */
input [13:0] cdma2sc_wt_kernels;
input [CSC_ENTRIES_NUM_WIDTH-1:0] cdma2sc_wt_entries;
input  [8:0] cdma2sc_wmb_entries;
output        sc2cdma_wt_updt;      /* data valid */
output [13:0] sc2cdma_wt_kernels;
output [CSC_ENTRIES_NUM_WIDTH-1:0] sc2cdma_wt_entries;
output  [8:0] sc2cdma_wmb_entries;
input   dla_clk_ovr_on_sync;
input   global_clk_ovr_on_sync;
input   tmc2slcg_disable_clock_gating;

wire        dp2reg_done;
wire        nvdla_op_gated_clk_0;
wire        nvdla_op_gated_clk_1;
wire        nvdla_op_gated_clk_2;
wire        nvdla_wg_gated_clk;
wire [20:0] reg2dp_atomics;
wire  [4:0] reg2dp_batches;
wire  [0:0] reg2dp_conv_mode;
wire  [2:0] reg2dp_conv_x_stride_ext;
wire  [2:0] reg2dp_conv_y_stride_ext;
wire [31:0] reg2dp_cya;
wire  [4:0] reg2dp_data_bank;
wire  [0:0] reg2dp_data_reuse;
wire [12:0] reg2dp_datain_channel_ext;
wire  [0:0] reg2dp_datain_format;
wire [12:0] reg2dp_datain_height_ext;
wire [12:0] reg2dp_datain_width_ext;
wire [12:0] reg2dp_dataout_channel;
wire [12:0] reg2dp_dataout_height;
wire [12:0] reg2dp_dataout_width;
wire [13:0] reg2dp_entries;
wire  [1:0] reg2dp_in_precision;
wire  [0:0] reg2dp_op_en;
wire  [4:0] reg2dp_pad_left;
wire  [4:0] reg2dp_pad_top;
wire [15:0] reg2dp_pad_value;
wire  [1:0] reg2dp_pra_truncate;
wire  [1:0] reg2dp_proc_precision;
wire [11:0] reg2dp_rls_slices;
wire  [0:0] reg2dp_skip_data_rls;
wire  [0:0] reg2dp_skip_weight_rls;
wire  [4:0] reg2dp_weight_bank;
wire [31:0] reg2dp_weight_bytes;
wire [12:0] reg2dp_weight_channel_ext;
wire  [0:0] reg2dp_weight_format;
wire  [4:0] reg2dp_weight_height_ext;
wire [12:0] reg2dp_weight_kernel;
wire  [0:0] reg2dp_weight_reuse;
wire  [4:0] reg2dp_weight_width_ext;
wire [27:0] reg2dp_wmb_bytes;
wire  [4:0] reg2dp_x_dilation_ext;
wire  [4:0] reg2dp_y_dilation_ext;
wire  [1:0] reg2dp_y_extension;
wire  [1:0] sc_state;
wire [30:0] sg2dl_pd;
wire        sg2dl_pvld;
wire        sg2dl_reuse_rls;
wire [17:0] sg2wl_pd;
wire        sg2wl_pvld;
wire        sg2wl_reuse_rls;
wire  [3:0] slcg_op_en;
wire        slcg_wg_en;


//==========================================================
// Regfile
//==========================================================
NV_NVDLA_CSC_regfile u_regfile (
   .nvdla_core_clk                (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.csb2csc_req_pd                (csb2csc_req_pd[62:0])            //|< i
  ,.csb2csc_req_pvld              (csb2csc_req_pvld)                //|< i
  ,.dp2reg_done                   (dp2reg_done)                     //|< w
  ,.csb2csc_req_prdy              (csb2csc_req_prdy)                //|> o
  ,.csc2csb_resp_pd               (csc2csb_resp_pd[33:0])           //|> o
  ,.csc2csb_resp_valid            (csc2csb_resp_valid)              //|> o
  ,.reg2dp_atomics                (reg2dp_atomics[20:0])            //|> w
  ,.reg2dp_batches                (reg2dp_batches[4:0])             //|> w
  ,.reg2dp_conv_mode              (reg2dp_conv_mode)                //|> w
  ,.reg2dp_conv_x_stride_ext      (reg2dp_conv_x_stride_ext[2:0])   //|> w
  ,.reg2dp_conv_y_stride_ext      (reg2dp_conv_y_stride_ext[2:0])   //|> w
  ,.reg2dp_cya                    (reg2dp_cya[31:0])                //|> w *
  ,.reg2dp_data_bank              (reg2dp_data_bank[4:0])           //|> w
  ,.reg2dp_data_reuse             (reg2dp_data_reuse)               //|> w
  ,.reg2dp_datain_channel_ext     (reg2dp_datain_channel_ext[12:0]) //|> w
  ,.reg2dp_datain_format          (reg2dp_datain_format)            //|> w
  ,.reg2dp_datain_height_ext      (reg2dp_datain_height_ext[12:0])  //|> w
  ,.reg2dp_datain_width_ext       (reg2dp_datain_width_ext[12:0])   //|> w
  ,.reg2dp_dataout_channel        (reg2dp_dataout_channel[12:0])    //|> w *
  ,.reg2dp_dataout_height         (reg2dp_dataout_height[12:0])     //|> w
  ,.reg2dp_dataout_width          (reg2dp_dataout_width[12:0])      //|> w
  ,.reg2dp_entries                (reg2dp_entries[13:0])            //|> w
  ,.reg2dp_in_precision           (reg2dp_in_precision[1:0])        //|> w
  ,.reg2dp_op_en                  (reg2dp_op_en)                    //|> w
  ,.reg2dp_pad_left               (reg2dp_pad_left[4:0])            //|> w
  ,.reg2dp_pad_top                (reg2dp_pad_top[4:0])             //|> w
  ,.reg2dp_pad_value              (reg2dp_pad_value[15:0])          //|> w
  ,.reg2dp_pra_truncate           (reg2dp_pra_truncate[1:0])        //|> w
  ,.reg2dp_proc_precision         (reg2dp_proc_precision[1:0])      //|> w
  ,.reg2dp_rls_slices             (reg2dp_rls_slices[11:0])         //|> w
  ,.reg2dp_skip_data_rls          (reg2dp_skip_data_rls)            //|> w
  ,.reg2dp_skip_weight_rls        (reg2dp_skip_weight_rls)          //|> w
  ,.reg2dp_weight_bank            (reg2dp_weight_bank[4:0])         //|> w
  ,.reg2dp_weight_bytes           (reg2dp_weight_bytes[31:0])       //|> w
  ,.reg2dp_weight_channel_ext     (reg2dp_weight_channel_ext[12:0]) //|> w
  ,.reg2dp_weight_format          (reg2dp_weight_format)            //|> w
  ,.reg2dp_weight_height_ext      (reg2dp_weight_height_ext[4:0])   //|> w
  ,.reg2dp_weight_kernel          (reg2dp_weight_kernel[12:0])      //|> w
  ,.reg2dp_weight_reuse           (reg2dp_weight_reuse)             //|> w
  ,.reg2dp_weight_width_ext       (reg2dp_weight_width_ext[4:0])    //|> w
  ,.reg2dp_wmb_bytes              (reg2dp_wmb_bytes[27:0])          //|> w
  ,.reg2dp_x_dilation_ext         (reg2dp_x_dilation_ext[4:0])      //|> w
  ,.reg2dp_y_dilation_ext         (reg2dp_y_dilation_ext[4:0])      //|> w
  ,.reg2dp_y_extension            (reg2dp_y_extension[1:0])         //|> w
  ,.slcg_op_en                    (slcg_op_en[3:0])                 //|> w
  );

//==========================================================
// Sequence generator
//==========================================================
NV_NVDLA_CSC_sg u_sg (
   .nvdla_core_clk                (nvdla_op_gated_clk_0)            //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])             //|< i
  ,.dp2reg_done                   (dp2reg_done)                     //|> w
  ,.cdma2sc_dat_updt              (cdma2sc_dat_updt)                //|< i
  ,.cdma2sc_dat_entries           (cdma2sc_dat_entries[CSC_ENTRIES_NUM_WIDTH-1:0])       //|< i
  ,.cdma2sc_dat_slices            (cdma2sc_dat_slices[13:0])        //|< i
  ,.cdma2sc_wt_updt               (cdma2sc_wt_updt)                 //|< i
  ,.cdma2sc_wt_kernels            (cdma2sc_wt_kernels[13:0])        //|< i
  ,.cdma2sc_wt_entries            (cdma2sc_wt_entries[CSC_ENTRIES_NUM_WIDTH-1:0])        //|< i
  ,.cdma2sc_wmb_entries           (cdma2sc_wmb_entries[8:0])        //|< i
  ,.sg2dl_pvld                    (sg2dl_pvld)                      //|> w
  ,.sg2dl_pd                      (sg2dl_pd[30:0])                  //|> w
  ,.sg2wl_pvld                    (sg2wl_pvld)                      //|> w
  ,.sg2wl_pd                      (sg2wl_pd[17:0])                  //|> w
  ,.accu2sc_credit_vld            (accu2sc_credit_vld)              //|< i
  ,.accu2sc_credit_size           (accu2sc_credit_size[2:0])        //|< i
  ,.sc_state                      (sc_state[1:0])                   //|> w
  ,.sc2cdma_dat_pending_req       (sc2cdma_dat_pending_req)         //|> o
  ,.sc2cdma_wt_pending_req        (sc2cdma_wt_pending_req)          //|> o
  ,.cdma2sc_dat_pending_ack       (cdma2sc_dat_pending_ack)         //|< i
  ,.cdma2sc_wt_pending_ack        (cdma2sc_wt_pending_ack)          //|< i
  ,.sg2dl_reuse_rls               (sg2dl_reuse_rls)                 //|> w
  ,.sg2wl_reuse_rls               (sg2wl_reuse_rls)                 //|> w
  ,.nvdla_core_ng_clk             (nvdla_core_clk)                  //|< i
  ,.reg2dp_op_en                  (reg2dp_op_en[0])                 //|< w
  ,.reg2dp_conv_mode              (reg2dp_conv_mode[0])             //|< w
  ,.reg2dp_proc_precision         (reg2dp_proc_precision[1:0])      //|< w
  ,.reg2dp_data_reuse             (reg2dp_data_reuse[0])            //|< w
  ,.reg2dp_skip_data_rls          (reg2dp_skip_data_rls[0])         //|< w
  ,.reg2dp_weight_reuse           (reg2dp_weight_reuse[0])          //|< w
  ,.reg2dp_skip_weight_rls        (reg2dp_skip_weight_rls[0])       //|< w
  ,.reg2dp_batches                (reg2dp_batches[4:0])             //|< w
  ,.reg2dp_datain_format          (reg2dp_datain_format[0])         //|< w
  ,.reg2dp_datain_height_ext      (reg2dp_datain_height_ext[12:0])  //|< w
  ,.reg2dp_y_extension            (reg2dp_y_extension[1:0])         //|< w
  ,.reg2dp_weight_width_ext       (reg2dp_weight_width_ext[4:0])    //|< w
  ,.reg2dp_weight_height_ext      (reg2dp_weight_height_ext[4:0])   //|< w
  ,.reg2dp_weight_channel_ext     (reg2dp_weight_channel_ext[12:0]) //|< w
  ,.reg2dp_weight_kernel          (reg2dp_weight_kernel[12:0])      //|< w
  ,.reg2dp_dataout_width          (reg2dp_dataout_width[12:0])      //|< w
  ,.reg2dp_dataout_height         (reg2dp_dataout_height[12:0])     //|< w
  ,.reg2dp_data_bank              (reg2dp_data_bank[4:0])           //|< w
  ,.reg2dp_weight_bank            (reg2dp_weight_bank[4:0])         //|< w
  ,.reg2dp_atomics                (reg2dp_atomics[20:0])            //|< w
  ,.reg2dp_rls_slices             (reg2dp_rls_slices[11:0])         //|< w
  );

//==========================================================
// Weight loader
//==========================================================
NV_NVDLA_CSC_wl u_wl (
   .nvdla_core_clk                (nvdla_op_gated_clk_1)            //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.sg2wl_pvld                    (sg2wl_pvld)                      //|< w
  ,.sg2wl_pd                      (sg2wl_pd[17:0])                  //|< w
  ,.sc_state                      (sc_state[1:0])                   //|< w
  ,.sg2wl_reuse_rls               (sg2wl_reuse_rls)                 //|< w
  ,.sc2cdma_wt_pending_req        (sc2cdma_wt_pending_req)          //|< o
  ,.cdma2sc_wt_updt               (cdma2sc_wt_updt)                 //|< i
  ,.cdma2sc_wt_kernels            (cdma2sc_wt_kernels[13:0])        //|< i
  ,.cdma2sc_wt_entries            (cdma2sc_wt_entries[CSC_ENTRIES_NUM_WIDTH-1:0])        //|< i
  ,.cdma2sc_wmb_entries           (cdma2sc_wmb_entries[8:0])        //|< i
  ,.sc2cdma_wt_updt               (sc2cdma_wt_updt)                 //|> o
  ,.sc2cdma_wt_kernels            (sc2cdma_wt_kernels[13:0])        //|> o
  ,.sc2cdma_wt_entries            (sc2cdma_wt_entries[CSC_ENTRIES_NUM_WIDTH-1:0])        //|> o
  ,.sc2cdma_wmb_entries           (sc2cdma_wmb_entries[8:0])        //|> o
  ,.sc2buf_wt_rd_en               (sc2buf_wt_rd_en)                 //|> o
  ,.sc2buf_wt_rd_addr             (sc2buf_wt_rd_addr[CBUF_ADDR_WIDTH-1:0])         //|> o
  ,.sc2buf_wt_rd_valid            (sc2buf_wt_rd_valid)              //|< i
  ,.sc2buf_wt_rd_data             (sc2buf_wt_rd_data)       //|< i
  `ifdef CBUF_WEIGHT_COMPRESSED
  ,.sc2buf_wmb_rd_en              (sc2buf_wmb_rd_en)                //|> o
  ,.sc2buf_wmb_rd_addr            (sc2buf_wmb_rd_addr[CBUF_ADDR_WIDTH-1:0])         //|> o
  ,.sc2buf_wmb_rd_valid           (sc2buf_wmb_rd_valid)             //|< i
  ,.sc2buf_wmb_rd_data            (sc2buf_wmb_rd_data)      //|< i
  `endif
  ,.sc2mac_wt_a_pvld              (sc2mac_wt_a_pvld)                //|> o
  ,.sc2mac_wt_a_mask              (sc2mac_wt_a_mask[CSC_ATOMC-1:0])         //|> o
  //: my $kk=CSC_BPE-1;
  //: for(my $i=0; $i<CSC_ATOMC; $i++){
  //: print qq(
  //: ,.sc2mac_wt_a_data${i}             (sc2mac_wt_a_data${i}[${kk}:0])   )
  //: }
  ,.sc2mac_wt_a_sel               (sc2mac_wt_a_sel[CSC_ATOMK_HF-1:0])            //|> o
  ,.sc2mac_wt_b_pvld              (sc2mac_wt_b_pvld)                //|> o
  ,.sc2mac_wt_b_mask              (sc2mac_wt_b_mask[CSC_ATOMC-1:0])         //|> o
  //: my $kk=CSC_BPE-1;
  //: for(my $i=0; $i<CSC_ATOMC; $i++){
  //: print qq(
  //: ,.sc2mac_wt_b_data${i}             (sc2mac_wt_b_data${i}[${kk}:0])   )
  //: }
  ,.sc2mac_wt_b_sel               (sc2mac_wt_b_sel[CSC_ATOMK_HF-1:0])            //|> o
  ,.nvdla_core_ng_clk             (nvdla_core_clk)                  //|< i
  ,.reg2dp_op_en                  (reg2dp_op_en[0])                 //|< w
  ,.reg2dp_in_precision           (reg2dp_in_precision[1:0])        //|< w
  ,.reg2dp_proc_precision         (reg2dp_proc_precision[1:0])      //|< w
  ,.reg2dp_y_extension            (reg2dp_y_extension[1:0])         //|< w
  ,.reg2dp_weight_reuse           (reg2dp_weight_reuse[0])          //|< w
  ,.reg2dp_skip_weight_rls        (reg2dp_skip_weight_rls[0])       //|< w
  ,.reg2dp_weight_format          (reg2dp_weight_format[0])         //|< w
  ,.reg2dp_weight_bytes           (reg2dp_weight_bytes[31:0])       //|< w
  ,.reg2dp_wmb_bytes              (reg2dp_wmb_bytes[27:0])          //|< w
  ,.reg2dp_data_bank              (reg2dp_data_bank[4:0])           //|< w
  ,.reg2dp_weight_bank            (reg2dp_weight_bank[4:0])         //|< w
  );

//==========================================================
// Data loader
//==========================================================
NV_NVDLA_CSC_dl u_dl (
   .nvdla_core_clk                (nvdla_op_gated_clk_2)            //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.sg2dl_pvld                    (sg2dl_pvld)                      //|< w
  ,.sg2dl_pd                      (sg2dl_pd[30:0])                  //|< w
  ,.sc_state                      (sc_state[1:0])                   //|< w
  ,.sg2dl_reuse_rls               (sg2dl_reuse_rls)                 //|< w
  ,.sc2cdma_dat_pending_req       (sc2cdma_dat_pending_req)         //|< o
  ,.cdma2sc_dat_updt              (cdma2sc_dat_updt)                //|< i
  ,.cdma2sc_dat_entries           (cdma2sc_dat_entries[CSC_ENTRIES_NUM_WIDTH-1:0])       //|< i
  ,.cdma2sc_dat_slices            (cdma2sc_dat_slices[13:0])        //|< i
  ,.sc2cdma_dat_updt              (sc2cdma_dat_updt)                //|> o
  ,.sc2cdma_dat_entries           (sc2cdma_dat_entries[CSC_ENTRIES_NUM_WIDTH-1:0])       //|> o
  ,.sc2cdma_dat_slices            (sc2cdma_dat_slices[13:0])        //|> o
  ,.sc2buf_dat_rd_en              (sc2buf_dat_rd_en)                //|> o
  ,.sc2buf_dat_rd_addr            (sc2buf_dat_rd_addr[CBUF_ADDR_WIDTH-1:0])        //|> o
  ,.sc2buf_dat_rd_shift           (sc2buf_dat_rd_shift)
  ,.sc2buf_dat_rd_next1_en        (sc2buf_dat_rd_next1_en)
  ,.sc2buf_dat_rd_next1_addr      (sc2buf_dat_rd_next1_addr)
  ,.sc2buf_dat_rd_valid           (sc2buf_dat_rd_valid)             //|< i
  ,.sc2buf_dat_rd_data            (sc2buf_dat_rd_data)      //|< i
  ,.sc2mac_dat_a_pvld             (sc2mac_dat_a_pvld)               //|> o
  ,.sc2mac_dat_a_mask             (sc2mac_dat_a_mask[CSC_ATOMC-1:0])        //|> o
  //: my $kk=CSC_BPE-1;
  //: for(my $i=0; $i<CSC_ATOMC; $i++){
  //: print qq(
  //: ,.sc2mac_dat_a_data${i}             (sc2mac_dat_a_data${i}[${kk}:0])   )
  //: }
  ,.sc2mac_dat_a_pd               (sc2mac_dat_a_pd[8:0])            //|> o
  ,.sc2mac_dat_b_pvld             (sc2mac_dat_b_pvld)               //|> o
  ,.sc2mac_dat_b_mask             (sc2mac_dat_b_mask[CSC_ATOMC-1:0])        //|> o
  //: my $kk=CSC_BPE-1;
  //: for(my $i=0; $i<CSC_ATOMC; $i++){
  //: print qq(
  //: ,.sc2mac_dat_b_data${i}             (sc2mac_dat_b_data${i}[${kk}:0])   )
  //: }
  ,.sc2mac_dat_b_pd               (sc2mac_dat_b_pd[8:0])            //|> o
  ,.nvdla_core_ng_clk             (nvdla_core_clk)                  //|< i
  ,.nvdla_wg_clk                  (nvdla_wg_gated_clk)              //|< w
  ,.reg2dp_op_en                  (reg2dp_op_en[0])                 //|< w
  ,.reg2dp_conv_mode              (reg2dp_conv_mode[0])             //|< w
  ,.reg2dp_batches                (reg2dp_batches[4:0])             //|< w
  ,.reg2dp_proc_precision         (reg2dp_proc_precision[1:0])      //|< w
  ,.reg2dp_datain_format          (reg2dp_datain_format[0])         //|< w
  ,.reg2dp_skip_data_rls          (reg2dp_skip_data_rls[0])         //|< w
  ,.reg2dp_datain_channel_ext     (reg2dp_datain_channel_ext[12:0]) //|< w
  ,.reg2dp_datain_height_ext      (reg2dp_datain_height_ext[12:0])  //|< w
  ,.reg2dp_datain_width_ext       (reg2dp_datain_width_ext[12:0])   //|< w
  ,.reg2dp_y_extension            (reg2dp_y_extension[1:0])         //|< w
  ,.reg2dp_weight_channel_ext     (reg2dp_weight_channel_ext[12:0]) //|< w
  ,.reg2dp_entries                (reg2dp_entries[13:0])            //|< w
  ,.reg2dp_dataout_width          (reg2dp_dataout_width[12:0])      //|< w
  ,.reg2dp_rls_slices             (reg2dp_rls_slices[11:0])         //|< w
  ,.reg2dp_conv_x_stride_ext      (reg2dp_conv_x_stride_ext[2:0])   //|< w
  ,.reg2dp_conv_y_stride_ext      (reg2dp_conv_y_stride_ext[2:0])   //|< w
  ,.reg2dp_x_dilation_ext         (reg2dp_x_dilation_ext[4:0])      //|< w
  ,.reg2dp_y_dilation_ext         (reg2dp_y_dilation_ext[4:0])      //|< w
  ,.reg2dp_pad_left               (reg2dp_pad_left[4:0])            //|< w
  ,.reg2dp_pad_top                (reg2dp_pad_top[4:0])             //|< w
  ,.reg2dp_pad_value              (reg2dp_pad_value[15:0])          //|< w
  ,.reg2dp_data_bank              (reg2dp_data_bank[4:0])           //|< w
  ,.reg2dp_pra_truncate           (reg2dp_pra_truncate[1:0])        //|< w
  ,.slcg_wg_en                    (slcg_wg_en)                      //|> w
  );

//==========================================================
// SLCG groups
//==========================================================

NV_NVDLA_CSC_slcg u_slcg_op_0 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)             //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)          //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.slcg_en_src_0                 (slcg_op_en[0])                   //|< w
  ,.slcg_en_src_1                 (1'b1)                            //|< ?
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)   //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_0)            //|> w
  );


NV_NVDLA_CSC_slcg u_slcg_op_1 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)             //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)          //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.slcg_en_src_0                 (slcg_op_en[1])                   //|< w
  ,.slcg_en_src_1                 (1'b1)                            //|< ?
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)   //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_1)            //|> w
  );


NV_NVDLA_CSC_slcg u_slcg_op_2 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)             //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)          //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.slcg_en_src_0                 (slcg_op_en[2])                   //|< w
  ,.slcg_en_src_1                 (1'b1)                            //|< ?
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)   //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_2)            //|> w
  );


NV_NVDLA_CSC_slcg u_slcg_wg (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)             //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)          //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.slcg_en_src_0                 (slcg_op_en[3])                   //|< w
  ,.slcg_en_src_1                 (slcg_wg_en)                      //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)   //|< i
  ,.nvdla_core_gated_clk          (nvdla_wg_gated_clk)              //|> w
  );


endmodule // NV_NVDLA_csc


