// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_img.v

module NV_NVDLA_CDMA_img (
   cvif2img_dat_rd_rsp_pd     //|< i
  ,cvif2img_dat_rd_rsp_valid  //|< i
  ,img2sbuf_p0_rd_data        //|< i
  ,img2sbuf_p1_rd_data        //|< i
  ,img_dat2cvif_rd_req_ready  //|< i
  ,img_dat2mcif_rd_req_ready  //|< i
  ,mcif2img_dat_rd_rsp_pd     //|< i
  ,mcif2img_dat_rd_rsp_valid  //|< i
  ,nvdla_core_clk             //|< i
  ,nvdla_core_ng_clk          //|< i
  ,nvdla_core_rstn            //|< i
  ,pwrbus_ram_pd              //|< i
  ,reg2dp_conv_mode           //|< i
  ,reg2dp_data_bank           //|< i
  ,reg2dp_data_reuse          //|< i
  ,reg2dp_datain_addr_high_0  //|< i
  ,reg2dp_datain_addr_high_1  //|< i
  ,reg2dp_datain_addr_low_0   //|< i
  ,reg2dp_datain_addr_low_1   //|< i
  ,reg2dp_datain_channel      //|< i
  ,reg2dp_datain_format       //|< i
  ,reg2dp_datain_height       //|< i
  ,reg2dp_datain_ram_type     //|< i
  ,reg2dp_datain_width        //|< i
  ,reg2dp_dma_en              //|< i
  ,reg2dp_entries             //|< i
  ,reg2dp_in_precision        //|< i
  ,reg2dp_line_stride         //|< i
  ,reg2dp_mean_ax             //|< i
  ,reg2dp_mean_bv             //|< i
  ,reg2dp_mean_format         //|< i
  ,reg2dp_mean_gu             //|< i
  ,reg2dp_mean_ry             //|< i
  ,reg2dp_op_en               //|< i
  ,reg2dp_pad_left            //|< i
  ,reg2dp_pad_right           //|< i
  ,reg2dp_pixel_format        //|< i
  ,reg2dp_pixel_mapping       //|< i
  ,reg2dp_pixel_sign_override //|< i
  ,reg2dp_pixel_x_offset      //|< i
  ,reg2dp_pixel_y_offset      //|< i
  ,reg2dp_proc_precision      //|< i
  ,reg2dp_rsv_height          //|< i *
  ,reg2dp_rsv_per_line        //|< i *
  ,reg2dp_rsv_per_uv_line     //|< i *
  ,reg2dp_rsv_y_index         //|< i *
  ,reg2dp_skip_data_rls       //|< i
  ,reg2dp_uv_line_stride      //|< i
  ,sc2cdma_dat_pending_req    //|< i
  ,status2dma_free_entries    //|< i
  ,status2dma_fsm_switch      //|< i
  ,status2dma_valid_slices    //|< i *
  ,status2dma_wr_idx          //|< i
  ,cvif2img_dat_rd_rsp_ready  //|> o
  ,dp2reg_img_rd_latency      //|> o
  ,dp2reg_img_rd_stall        //|> o
  ,img2cvt_dat_wr_addr        //|> o
  ,img2cvt_dat_wr_data        //|> o
  ,img2cvt_dat_wr_en          //|> o
  ,img2cvt_dat_wr_hsel        //|> o
  ,img2cvt_dat_wr_info_pd     //|> o
  ,img2cvt_dat_wr_pad_mask    //|> o
  ,img2cvt_mn_wr_data         //|> o
  ,img2sbuf_p0_rd_addr        //|> o
  ,img2sbuf_p0_rd_en          //|> o
  ,img2sbuf_p0_wr_addr        //|> o
  ,img2sbuf_p0_wr_data        //|> o
  ,img2sbuf_p0_wr_en          //|> o
  ,img2sbuf_p1_rd_addr        //|> o
  ,img2sbuf_p1_rd_en          //|> o
  ,img2sbuf_p1_wr_addr        //|> o
  ,img2sbuf_p1_wr_data        //|> o
  ,img2sbuf_p1_wr_en          //|> o
  ,img2status_dat_entries     //|> o
  ,img2status_dat_slices      //|> o
  ,img2status_dat_updt        //|> o
  ,img2status_state           //|> o
  ,img_dat2cvif_rd_req_pd     //|> o
  ,img_dat2cvif_rd_req_valid  //|> o
  ,img_dat2mcif_rd_req_pd     //|> o
  ,img_dat2mcif_rd_req_valid  //|> o
  ,mcif2img_dat_rd_rsp_ready  //|> o
  ,slcg_img_gate_dc           //|> o
  ,slcg_img_gate_wg           //|> o
  );


//
// NV_NVDLA_CDMA_img_ports.v
//
input  nvdla_core_clk;   /* img_dat2mcif_rd_req, img_dat2cvif_rd_req, mcif2img_dat_rd_rsp, cvif2img_dat_rd_rsp, img2cvt_dat_wr, img2cvt_mn_wr, img2cvt_dat_wr_info, switch_status2dma, state_img2status, dat_up_img2status, bc_status2dma, img2sbuf_p0_wr, img2sbuf_p1_wr, img2sbuf_p0_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, img2sbuf_p0_rd_nvdla_ram_data_DATA_WIDTH_256, img2sbuf_p1_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, img2sbuf_p1_rd_nvdla_ram_data_DATA_WIDTH_256, sc2cdma_dat_pending */
input  nvdla_core_rstn;  /* img_dat2mcif_rd_req, img_dat2cvif_rd_req, mcif2img_dat_rd_rsp, cvif2img_dat_rd_rsp, img2cvt_dat_wr, img2cvt_mn_wr, img2cvt_dat_wr_info, switch_status2dma, state_img2status, dat_up_img2status, bc_status2dma, img2sbuf_p0_wr, img2sbuf_p1_wr, img2sbuf_p0_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, img2sbuf_p0_rd_nvdla_ram_data_DATA_WIDTH_256, img2sbuf_p1_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, img2sbuf_p1_rd_nvdla_ram_data_DATA_WIDTH_256, sc2cdma_dat_pending */

input [31:0] pwrbus_ram_pd;

output        img_dat2mcif_rd_req_valid;  /* data valid */
input         img_dat2mcif_rd_req_ready;  /* data return handshake */
output [78:0] img_dat2mcif_rd_req_pd;

output        img_dat2cvif_rd_req_valid;  /* data valid */
input         img_dat2cvif_rd_req_ready;  /* data return handshake */
output [78:0] img_dat2cvif_rd_req_pd;

input          mcif2img_dat_rd_rsp_valid;  /* data valid */
output         mcif2img_dat_rd_rsp_ready;  /* data return handshake */
input  [513:0] mcif2img_dat_rd_rsp_pd;

input          cvif2img_dat_rd_rsp_valid;  /* data valid */
output         cvif2img_dat_rd_rsp_ready;  /* data return handshake */
input  [513:0] cvif2img_dat_rd_rsp_pd;

output          img2cvt_dat_wr_en;    /* data valid */
output   [11:0] img2cvt_dat_wr_addr;
output          img2cvt_dat_wr_hsel;
output [1023:0] img2cvt_dat_wr_data;

output [1023:0] img2cvt_mn_wr_data;

output [11:0] img2cvt_dat_wr_info_pd;

input  status2dma_fsm_switch;

output [1:0] img2status_state;

output        img2status_dat_updt;     /* data valid */
output [11:0] img2status_dat_entries;
output [11:0] img2status_dat_slices;

input [11:0] status2dma_valid_slices;
input [11:0] status2dma_free_entries;
input [11:0] status2dma_wr_idx;

output         img2sbuf_p0_wr_en;    /* data valid */
output   [7:0] img2sbuf_p0_wr_addr;
output [255:0] img2sbuf_p0_wr_data;

output         img2sbuf_p1_wr_en;    /* data valid */
output   [7:0] img2sbuf_p1_wr_addr;
output [255:0] img2sbuf_p1_wr_data;

output       img2sbuf_p0_rd_en;    /* data valid */
output [7:0] img2sbuf_p0_rd_addr;

input [255:0] img2sbuf_p0_rd_data;

output       img2sbuf_p1_rd_en;    /* data valid */
output [7:0] img2sbuf_p1_rd_addr;

input [255:0] img2sbuf_p1_rd_data;

input  sc2cdma_dat_pending_req;

input nvdla_core_ng_clk;

input [0:0]                     reg2dp_op_en;
input [0:0]                  reg2dp_conv_mode;
input [1:0]               reg2dp_in_precision;
input [1:0]             reg2dp_proc_precision;
input [0:0]                 reg2dp_data_reuse;
input [0:0]              reg2dp_skip_data_rls;
input [0:0]         reg2dp_datain_format;
input [5:0]          reg2dp_pixel_format;
input [0:0]         reg2dp_pixel_mapping;
input [0:0]   reg2dp_pixel_sign_override;
input [12:0]          reg2dp_datain_width;
input [12:0]         reg2dp_datain_height;
input [12:0]        reg2dp_datain_channel;
input [4:0]         reg2dp_pixel_x_offset;
input [2:0]         reg2dp_pixel_y_offset;
input [0:0]       reg2dp_datain_ram_type;
input [31:0] reg2dp_datain_addr_high_0;
input [26:0]   reg2dp_datain_addr_low_0;
input [31:0] reg2dp_datain_addr_high_1;
input [26:0]   reg2dp_datain_addr_low_1;
input [26:0]             reg2dp_line_stride;
input [26:0]       reg2dp_uv_line_stride;
input [0:0]             reg2dp_mean_format;
input [15:0]               reg2dp_mean_ry;
input [15:0]               reg2dp_mean_gu;
input [15:0]               reg2dp_mean_bv;
input [15:0]               reg2dp_mean_ax;
input [11:0]             reg2dp_entries;
input [4:0]               reg2dp_pad_left;
input [5:0]              reg2dp_pad_right;
//input [NVDLA_CDMA_D_ZERO_PADDING_VALUE_0_PAD_VALUE_SIZE-1:0]        reg2dp_pad_value;
input [3:0]                      reg2dp_data_bank;
input [0:0]                  reg2dp_dma_en;
input [9:0]         reg2dp_rsv_per_line;
input [9:0]      reg2dp_rsv_per_uv_line;
input [2:0]           reg2dp_rsv_height;
input [4:0]          reg2dp_rsv_y_index;

output slcg_img_gate_dc;
output slcg_img_gate_wg;

output [31:0]       dp2reg_img_rd_stall;
output [31:0]   dp2reg_img_rd_latency;
output [127:0] img2cvt_dat_wr_pad_mask;

wire        is_running;
wire        layer_st;
wire        pack_is_done;
wire  [3:0] pixel_bank;
wire        pixel_data_expand;
wire        pixel_data_shrink;
wire        pixel_early_end;
wire [10:0] pixel_order;
wire        pixel_packed_10b;
wire        pixel_planar;
wire  [3:0] pixel_planar0_bundle_limit;
wire  [3:0] pixel_planar0_bundle_limit_1st;
wire  [4:0] pixel_planar0_byte_sft;
wire  [3:0] pixel_planar0_lp_burst;
wire        pixel_planar0_lp_vld;
wire  [3:0] pixel_planar0_rp_burst;
wire        pixel_planar0_rp_vld;
wire  [2:0] pixel_planar0_sft;
wire [11:0] pixel_planar0_width_burst;
wire  [4:0] pixel_planar1_bundle_limit;
wire  [4:0] pixel_planar1_bundle_limit_1st;
wire  [4:0] pixel_planar1_byte_sft;
wire  [2:0] pixel_planar1_lp_burst;
wire        pixel_planar1_lp_vld;
wire  [2:0] pixel_planar1_rp_burst;
wire        pixel_planar1_rp_vld;
wire  [2:0] pixel_planar1_sft;
wire [10:0] pixel_planar1_width_burst;
wire  [1:0] pixel_precision;
wire        pixel_uint;
wire [11:0] sg2pack_data_entries;
wire [11:0] sg2pack_entry_end;
wire [11:0] sg2pack_entry_mid;
wire [11:0] sg2pack_entry_st;
wire [12:0] sg2pack_height_total;
wire [10:0] sg2pack_img_pd;
wire        sg2pack_img_prdy;
wire        sg2pack_img_pvld;
wire        sg2pack_mn_enable;
wire  [3:0] sg2pack_sub_h_end;
wire  [3:0] sg2pack_sub_h_mid;
wire  [3:0] sg2pack_sub_h_st;
wire        sg_is_done;



// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
NV_NVDLA_CDMA_IMG_ctrl u_ctrl (
   .nvdla_core_clk                 (nvdla_core_clk)                      //|< i
  ,.nvdla_core_ng_clk              (nvdla_core_ng_clk)                   //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                     //|< i
  ,.pack_is_done                   (pack_is_done)                        //|< w
  ,.sc2cdma_dat_pending_req        (sc2cdma_dat_pending_req)             //|< i
  ,.sg_is_done                     (sg_is_done)                          //|< w
  ,.status2dma_fsm_switch          (status2dma_fsm_switch)               //|< i
  ,.img2status_state               (img2status_state[1:0])               //|> o
  ,.is_running                     (is_running)                          //|> w
  ,.layer_st                       (layer_st)                            //|> w
  ,.pixel_bank                     (pixel_bank[3:0])                     //|> w
  ,.pixel_data_expand              (pixel_data_expand)                   //|> w
  ,.pixel_data_shrink              (pixel_data_shrink)                   //|> w
  ,.pixel_early_end                (pixel_early_end)                     //|> w
  ,.pixel_order                    (pixel_order[10:0])                   //|> w
  ,.pixel_packed_10b               (pixel_packed_10b)                    //|> w
  ,.pixel_planar                   (pixel_planar)                        //|> w
  ,.pixel_planar0_bundle_limit     (pixel_planar0_bundle_limit[3:0])     //|> w
  ,.pixel_planar0_bundle_limit_1st (pixel_planar0_bundle_limit_1st[3:0]) //|> w
  ,.pixel_planar0_byte_sft         (pixel_planar0_byte_sft[4:0])         //|> w
  ,.pixel_planar0_lp_burst         (pixel_planar0_lp_burst[3:0])         //|> w
  ,.pixel_planar0_lp_vld           (pixel_planar0_lp_vld)                //|> w
  ,.pixel_planar0_rp_burst         (pixel_planar0_rp_burst[3:0])         //|> w
  ,.pixel_planar0_rp_vld           (pixel_planar0_rp_vld)                //|> w
  ,.pixel_planar0_sft              (pixel_planar0_sft[2:0])              //|> w
  ,.pixel_planar0_width_burst      (pixel_planar0_width_burst[11:0])     //|> w
  ,.pixel_planar1_bundle_limit     (pixel_planar1_bundle_limit[4:0])     //|> w
  ,.pixel_planar1_bundle_limit_1st (pixel_planar1_bundle_limit_1st[4:0]) //|> w
  ,.pixel_planar1_byte_sft         (pixel_planar1_byte_sft[4:0])         //|> w
  ,.pixel_planar1_lp_burst         (pixel_planar1_lp_burst[2:0])         //|> w
  ,.pixel_planar1_lp_vld           (pixel_planar1_lp_vld)                //|> w
  ,.pixel_planar1_rp_burst         (pixel_planar1_rp_burst[2:0])         //|> w
  ,.pixel_planar1_rp_vld           (pixel_planar1_rp_vld)                //|> w
  ,.pixel_planar1_sft              (pixel_planar1_sft[2:0])              //|> w
  ,.pixel_planar1_width_burst      (pixel_planar1_width_burst[10:0])     //|> w
  ,.pixel_precision                (pixel_precision[1:0])                //|> w
  ,.pixel_uint                     (pixel_uint)                          //|> w
  ,.slcg_img_gate_dc               (slcg_img_gate_dc)                    //|> o
  ,.slcg_img_gate_wg               (slcg_img_gate_wg)                    //|> o
  ,.reg2dp_op_en                   (reg2dp_op_en[0])                     //|< i
  ,.reg2dp_conv_mode               (reg2dp_conv_mode[0])                 //|< i
  ,.reg2dp_in_precision            (reg2dp_in_precision[1:0])            //|< i
  ,.reg2dp_proc_precision          (reg2dp_proc_precision[1:0])          //|< i
  ,.reg2dp_datain_format           (reg2dp_datain_format[0])             //|< i
  ,.reg2dp_pixel_format            (reg2dp_pixel_format[5:0])            //|< i
  ,.reg2dp_pixel_mapping           (reg2dp_pixel_mapping[0])             //|< i
  ,.reg2dp_pixel_sign_override     (reg2dp_pixel_sign_override[0])       //|< i
  ,.reg2dp_datain_width            (reg2dp_datain_width[12:0])           //|< i
  ,.reg2dp_data_reuse              (reg2dp_data_reuse[0])                //|< i
  ,.reg2dp_skip_data_rls           (reg2dp_skip_data_rls[0])             //|< i
  ,.reg2dp_data_bank               (reg2dp_data_bank[3:0])               //|< i
  ,.reg2dp_pixel_x_offset          (reg2dp_pixel_x_offset[4:0])          //|< i
  ,.reg2dp_pad_left                (reg2dp_pad_left[4:0])                //|< i
  ,.reg2dp_pad_right               (reg2dp_pad_right[5:0])               //|< i
  );

NV_NVDLA_CDMA_IMG_sg u_sg (
   .nvdla_core_clk                 (nvdla_core_clk)                      //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                     //|< i
  ,.cvif2img_dat_rd_rsp_pd         (cvif2img_dat_rd_rsp_pd[513:0])       //|< i
  ,.cvif2img_dat_rd_rsp_valid      (cvif2img_dat_rd_rsp_valid)           //|< i
  ,.img2status_dat_entries         (img2status_dat_entries[11:0])        //|< o
  ,.img2status_dat_updt            (img2status_dat_updt)                 //|< o
  ,.img_dat2cvif_rd_req_ready      (img_dat2cvif_rd_req_ready)           //|< i
  ,.img_dat2mcif_rd_req_ready      (img_dat2mcif_rd_req_ready)           //|< i
  ,.is_running                     (is_running)                          //|< w
  ,.layer_st                       (layer_st)                            //|< w
  ,.mcif2img_dat_rd_rsp_pd         (mcif2img_dat_rd_rsp_pd[513:0])       //|< i
  ,.mcif2img_dat_rd_rsp_valid      (mcif2img_dat_rd_rsp_valid)           //|< i
  ,.pixel_order                    (pixel_order[10:0])                   //|< w
  ,.pixel_planar                   (pixel_planar)                        //|< w
  ,.pixel_planar0_bundle_limit     (pixel_planar0_bundle_limit[3:0])     //|< w
  ,.pixel_planar0_bundle_limit_1st (pixel_planar0_bundle_limit_1st[3:0]) //|< w
  ,.pixel_planar0_byte_sft         (pixel_planar0_byte_sft[4:0])         //|< w
  ,.pixel_planar0_lp_burst         (pixel_planar0_lp_burst[3:0])         //|< w
  ,.pixel_planar0_lp_vld           (pixel_planar0_lp_vld)                //|< w
  ,.pixel_planar0_rp_burst         (pixel_planar0_rp_burst[3:0])         //|< w
  ,.pixel_planar0_rp_vld           (pixel_planar0_rp_vld)                //|< w
  ,.pixel_planar0_width_burst      (pixel_planar0_width_burst[11:0])     //|< w
  ,.pixel_planar1_bundle_limit     (pixel_planar1_bundle_limit[4:0])     //|< w
  ,.pixel_planar1_bundle_limit_1st (pixel_planar1_bundle_limit_1st[4:0]) //|< w
  ,.pixel_planar1_byte_sft         (pixel_planar1_byte_sft[4:0])         //|< w
  ,.pixel_planar1_lp_burst         (pixel_planar1_lp_burst[2:0])         //|< w
  ,.pixel_planar1_lp_vld           (pixel_planar1_lp_vld)                //|< w
  ,.pixel_planar1_rp_burst         (pixel_planar1_rp_burst[2:0])         //|< w
  ,.pixel_planar1_rp_vld           (pixel_planar1_rp_vld)                //|< w
  ,.pixel_planar1_width_burst      (pixel_planar1_width_burst[10:0])     //|< w
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])                 //|< i
  ,.reg2dp_op_en                   (reg2dp_op_en)                        //|< i
  ,.sg2pack_img_prdy               (sg2pack_img_prdy)                    //|< w
  ,.status2dma_free_entries        (status2dma_free_entries[11:0])       //|< i
  ,.status2dma_fsm_switch          (status2dma_fsm_switch)               //|< i
  ,.cvif2img_dat_rd_rsp_ready      (cvif2img_dat_rd_rsp_ready)           //|> o
  ,.img2sbuf_p0_wr_addr            (img2sbuf_p0_wr_addr[7:0])            //|> o
  ,.img2sbuf_p0_wr_data            (img2sbuf_p0_wr_data[255:0])          //|> o
  ,.img2sbuf_p0_wr_en              (img2sbuf_p0_wr_en)                   //|> o
  ,.img2sbuf_p1_wr_addr            (img2sbuf_p1_wr_addr[7:0])            //|> o
  ,.img2sbuf_p1_wr_data            (img2sbuf_p1_wr_data[255:0])          //|> o
  ,.img2sbuf_p1_wr_en              (img2sbuf_p1_wr_en)                   //|> o
  ,.img_dat2cvif_rd_req_pd         (img_dat2cvif_rd_req_pd[78:0])        //|> o
  ,.img_dat2cvif_rd_req_valid      (img_dat2cvif_rd_req_valid)           //|> o
  ,.img_dat2mcif_rd_req_pd         (img_dat2mcif_rd_req_pd[78:0])        //|> o
  ,.img_dat2mcif_rd_req_valid      (img_dat2mcif_rd_req_valid)           //|> o
  ,.mcif2img_dat_rd_rsp_ready      (mcif2img_dat_rd_rsp_ready)           //|> o
  ,.sg2pack_data_entries           (sg2pack_data_entries[11:0])          //|> w
  ,.sg2pack_entry_end              (sg2pack_entry_end[11:0])             //|> w
  ,.sg2pack_entry_mid              (sg2pack_entry_mid[11:0])             //|> w
  ,.sg2pack_entry_st               (sg2pack_entry_st[11:0])              //|> w
  ,.sg2pack_height_total           (sg2pack_height_total[12:0])          //|> w
  ,.sg2pack_img_pd                 (sg2pack_img_pd[10:0])                //|> w
  ,.sg2pack_img_pvld               (sg2pack_img_pvld)                    //|> w
  ,.sg2pack_mn_enable              (sg2pack_mn_enable)                   //|> w
  ,.sg2pack_sub_h_end              (sg2pack_sub_h_end[3:0])              //|> w
  ,.sg2pack_sub_h_mid              (sg2pack_sub_h_mid[3:0])              //|> w
  ,.sg2pack_sub_h_st               (sg2pack_sub_h_st[3:0])               //|> w
  ,.sg_is_done                     (sg_is_done)                          //|> w
  ,.reg2dp_pixel_y_offset          (reg2dp_pixel_y_offset[2:0])          //|< i
  ,.reg2dp_datain_height           (reg2dp_datain_height[12:0])          //|< i
  ,.reg2dp_datain_ram_type         (reg2dp_datain_ram_type[0])           //|< i
  ,.reg2dp_datain_addr_high_0      (reg2dp_datain_addr_high_0[31:0])     //|< i
  ,.reg2dp_datain_addr_low_0       (reg2dp_datain_addr_low_0[26:0])      //|< i
  ,.reg2dp_datain_addr_high_1      (reg2dp_datain_addr_high_1[31:0])     //|< i
  ,.reg2dp_datain_addr_low_1       (reg2dp_datain_addr_low_1[26:0])      //|< i
  ,.reg2dp_line_stride             (reg2dp_line_stride[26:0])            //|< i
  ,.reg2dp_uv_line_stride          (reg2dp_uv_line_stride[26:0])         //|< i
  ,.reg2dp_mean_format             (reg2dp_mean_format[0])               //|< i
  ,.reg2dp_entries                 (reg2dp_entries[11:0])                //|< i
  ,.reg2dp_dma_en                  (reg2dp_dma_en[0])                    //|< i
  ,.dp2reg_img_rd_stall            (dp2reg_img_rd_stall[31:0])           //|> o
  ,.dp2reg_img_rd_latency          (dp2reg_img_rd_latency[31:0])         //|> o
  );

NV_NVDLA_CDMA_IMG_pack u_pack (
   .nvdla_core_clk                 (nvdla_core_clk)                      //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                     //|< i
  ,.img2sbuf_p0_rd_data            (img2sbuf_p0_rd_data[255:0])          //|< i
  ,.img2sbuf_p1_rd_data            (img2sbuf_p1_rd_data[255:0])          //|< i
  ,.is_running                     (is_running)                          //|< w
  ,.layer_st                       (layer_st)                            //|< w
  ,.pixel_bank                     (pixel_bank[3:0])                     //|< w
  ,.pixel_data_expand              (pixel_data_expand)                   //|< w
  ,.pixel_data_shrink              (pixel_data_shrink)                   //|< w
  ,.pixel_early_end                (pixel_early_end)                     //|< w
  ,.pixel_packed_10b               (pixel_packed_10b)                    //|< w
  ,.pixel_planar                   (pixel_planar)                        //|< w
  ,.pixel_planar0_sft              (pixel_planar0_sft[2:0])              //|< w
  ,.pixel_planar1_sft              (pixel_planar1_sft[2:0])              //|< w
  ,.pixel_precision                (pixel_precision[1:0])                //|< w
  ,.pixel_uint                     (pixel_uint)                          //|< w
  ,.sg2pack_data_entries           (sg2pack_data_entries[11:0])          //|< w
  ,.sg2pack_entry_end              (sg2pack_entry_end[11:0])             //|< w
  ,.sg2pack_entry_mid              (sg2pack_entry_mid[11:0])             //|< w
  ,.sg2pack_entry_st               (sg2pack_entry_st[11:0])              //|< w
  ,.sg2pack_height_total           (sg2pack_height_total[12:0])          //|< w
  ,.sg2pack_img_pd                 (sg2pack_img_pd[10:0])                //|< w
  ,.sg2pack_img_pvld               (sg2pack_img_pvld)                    //|< w
  ,.sg2pack_mn_enable              (sg2pack_mn_enable)                   //|< w
  ,.sg2pack_sub_h_end              (sg2pack_sub_h_end[3:0])              //|< w
  ,.sg2pack_sub_h_mid              (sg2pack_sub_h_mid[3:0])              //|< w
  ,.sg2pack_sub_h_st               (sg2pack_sub_h_st[3:0])               //|< w
  ,.status2dma_wr_idx              (status2dma_wr_idx[11:0])             //|< i
  ,.img2cvt_dat_wr_addr            (img2cvt_dat_wr_addr[11:0])           //|> o
  ,.img2cvt_dat_wr_data            (img2cvt_dat_wr_data[1023:0])         //|> o
  ,.img2cvt_dat_wr_en              (img2cvt_dat_wr_en)                   //|> o
  ,.img2cvt_dat_wr_hsel            (img2cvt_dat_wr_hsel)                 //|> o
  ,.img2cvt_dat_wr_info_pd         (img2cvt_dat_wr_info_pd[11:0])        //|> o
  ,.img2cvt_mn_wr_data             (img2cvt_mn_wr_data[1023:0])          //|> o
  ,.img2sbuf_p0_rd_addr            (img2sbuf_p0_rd_addr[7:0])            //|> o
  ,.img2sbuf_p0_rd_en              (img2sbuf_p0_rd_en)                   //|> o
  ,.img2sbuf_p1_rd_addr            (img2sbuf_p1_rd_addr[7:0])            //|> o
  ,.img2sbuf_p1_rd_en              (img2sbuf_p1_rd_en)                   //|> o
  ,.img2status_dat_entries         (img2status_dat_entries[11:0])        //|> o
  ,.img2status_dat_slices          (img2status_dat_slices[11:0])         //|> o
  ,.img2status_dat_updt            (img2status_dat_updt)                 //|> o
  ,.pack_is_done                   (pack_is_done)                        //|> w
  ,.sg2pack_img_prdy               (sg2pack_img_prdy)                    //|> w
  ,.reg2dp_datain_width            (reg2dp_datain_width[12:0])           //|< i
  ,.reg2dp_datain_channel          (reg2dp_datain_channel[12:0])         //|< i
  ,.reg2dp_mean_ry                 (reg2dp_mean_ry[15:0])                //|< i
  ,.reg2dp_mean_gu                 (reg2dp_mean_gu[15:0])                //|< i
  ,.reg2dp_mean_bv                 (reg2dp_mean_bv[15:0])                //|< i
  ,.reg2dp_mean_ax                 (reg2dp_mean_ax[15:0])                //|< i
  ,.reg2dp_pad_left                (reg2dp_pad_left[4:0])                //|< i
  ,.reg2dp_pad_right               (reg2dp_pad_right[5:0])               //|< i
  ,.img2cvt_dat_wr_pad_mask        (img2cvt_dat_wr_pad_mask[127:0])      //|> o
  );

endmodule // NV_NVDLA_CDMA_img


