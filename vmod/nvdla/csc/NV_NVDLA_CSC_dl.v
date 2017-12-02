// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CSC_dl.v

module NV_NVDLA_CSC_dl (
   nvdla_core_clk            //|< i
  ,nvdla_core_rstn           //|< i
  ,sg2dl_pvld                //|< i
  ,sg2dl_pd                  //|< i
  ,sc_state                  //|< i
  ,sg2dl_reuse_rls           //|< i
  ,sc2cdma_dat_pending_req   //|< i
  ,cdma2sc_dat_updt          //|< i
  ,cdma2sc_dat_entries       //|< i
  ,cdma2sc_dat_slices        //|< i
  ,sc2cdma_dat_updt          //|> o
  ,sc2cdma_dat_entries       //|> o
  ,sc2cdma_dat_slices        //|> o
  ,sc2buf_dat_rd_en          //|> o
  ,sc2buf_dat_rd_addr        //|> o
  ,sc2buf_dat_rd_valid       //|< i
  ,sc2buf_dat_rd_data        //|< i
  ,sc2mac_dat_a_pvld         //|> o
  ,sc2mac_dat_a_mask         //|> o
  ,sc2mac_dat_a_data0        //|> o
  ,sc2mac_dat_a_data1        //|> o
  ,sc2mac_dat_a_data2        //|> o
  ,sc2mac_dat_a_data3        //|> o
  ,sc2mac_dat_a_data4        //|> o
  ,sc2mac_dat_a_data5        //|> o
  ,sc2mac_dat_a_data6        //|> o
  ,sc2mac_dat_a_data7        //|> o
  ,sc2mac_dat_a_data8        //|> o
  ,sc2mac_dat_a_data9        //|> o
  ,sc2mac_dat_a_data10       //|> o
  ,sc2mac_dat_a_data11       //|> o
  ,sc2mac_dat_a_data12       //|> o
  ,sc2mac_dat_a_data13       //|> o
  ,sc2mac_dat_a_data14       //|> o
  ,sc2mac_dat_a_data15       //|> o
  ,sc2mac_dat_a_data16       //|> o
  ,sc2mac_dat_a_data17       //|> o
  ,sc2mac_dat_a_data18       //|> o
  ,sc2mac_dat_a_data19       //|> o
  ,sc2mac_dat_a_data20       //|> o
  ,sc2mac_dat_a_data21       //|> o
  ,sc2mac_dat_a_data22       //|> o
  ,sc2mac_dat_a_data23       //|> o
  ,sc2mac_dat_a_data24       //|> o
  ,sc2mac_dat_a_data25       //|> o
  ,sc2mac_dat_a_data26       //|> o
  ,sc2mac_dat_a_data27       //|> o
  ,sc2mac_dat_a_data28       //|> o
  ,sc2mac_dat_a_data29       //|> o
  ,sc2mac_dat_a_data30       //|> o
  ,sc2mac_dat_a_data31       //|> o
  ,sc2mac_dat_a_data32       //|> o
  ,sc2mac_dat_a_data33       //|> o
  ,sc2mac_dat_a_data34       //|> o
  ,sc2mac_dat_a_data35       //|> o
  ,sc2mac_dat_a_data36       //|> o
  ,sc2mac_dat_a_data37       //|> o
  ,sc2mac_dat_a_data38       //|> o
  ,sc2mac_dat_a_data39       //|> o
  ,sc2mac_dat_a_data40       //|> o
  ,sc2mac_dat_a_data41       //|> o
  ,sc2mac_dat_a_data42       //|> o
  ,sc2mac_dat_a_data43       //|> o
  ,sc2mac_dat_a_data44       //|> o
  ,sc2mac_dat_a_data45       //|> o
  ,sc2mac_dat_a_data46       //|> o
  ,sc2mac_dat_a_data47       //|> o
  ,sc2mac_dat_a_data48       //|> o
  ,sc2mac_dat_a_data49       //|> o
  ,sc2mac_dat_a_data50       //|> o
  ,sc2mac_dat_a_data51       //|> o
  ,sc2mac_dat_a_data52       //|> o
  ,sc2mac_dat_a_data53       //|> o
  ,sc2mac_dat_a_data54       //|> o
  ,sc2mac_dat_a_data55       //|> o
  ,sc2mac_dat_a_data56       //|> o
  ,sc2mac_dat_a_data57       //|> o
  ,sc2mac_dat_a_data58       //|> o
  ,sc2mac_dat_a_data59       //|> o
  ,sc2mac_dat_a_data60       //|> o
  ,sc2mac_dat_a_data61       //|> o
  ,sc2mac_dat_a_data62       //|> o
  ,sc2mac_dat_a_data63       //|> o
  ,sc2mac_dat_a_data64       //|> o
  ,sc2mac_dat_a_data65       //|> o
  ,sc2mac_dat_a_data66       //|> o
  ,sc2mac_dat_a_data67       //|> o
  ,sc2mac_dat_a_data68       //|> o
  ,sc2mac_dat_a_data69       //|> o
  ,sc2mac_dat_a_data70       //|> o
  ,sc2mac_dat_a_data71       //|> o
  ,sc2mac_dat_a_data72       //|> o
  ,sc2mac_dat_a_data73       //|> o
  ,sc2mac_dat_a_data74       //|> o
  ,sc2mac_dat_a_data75       //|> o
  ,sc2mac_dat_a_data76       //|> o
  ,sc2mac_dat_a_data77       //|> o
  ,sc2mac_dat_a_data78       //|> o
  ,sc2mac_dat_a_data79       //|> o
  ,sc2mac_dat_a_data80       //|> o
  ,sc2mac_dat_a_data81       //|> o
  ,sc2mac_dat_a_data82       //|> o
  ,sc2mac_dat_a_data83       //|> o
  ,sc2mac_dat_a_data84       //|> o
  ,sc2mac_dat_a_data85       //|> o
  ,sc2mac_dat_a_data86       //|> o
  ,sc2mac_dat_a_data87       //|> o
  ,sc2mac_dat_a_data88       //|> o
  ,sc2mac_dat_a_data89       //|> o
  ,sc2mac_dat_a_data90       //|> o
  ,sc2mac_dat_a_data91       //|> o
  ,sc2mac_dat_a_data92       //|> o
  ,sc2mac_dat_a_data93       //|> o
  ,sc2mac_dat_a_data94       //|> o
  ,sc2mac_dat_a_data95       //|> o
  ,sc2mac_dat_a_data96       //|> o
  ,sc2mac_dat_a_data97       //|> o
  ,sc2mac_dat_a_data98       //|> o
  ,sc2mac_dat_a_data99       //|> o
  ,sc2mac_dat_a_data100      //|> o
  ,sc2mac_dat_a_data101      //|> o
  ,sc2mac_dat_a_data102      //|> o
  ,sc2mac_dat_a_data103      //|> o
  ,sc2mac_dat_a_data104      //|> o
  ,sc2mac_dat_a_data105      //|> o
  ,sc2mac_dat_a_data106      //|> o
  ,sc2mac_dat_a_data107      //|> o
  ,sc2mac_dat_a_data108      //|> o
  ,sc2mac_dat_a_data109      //|> o
  ,sc2mac_dat_a_data110      //|> o
  ,sc2mac_dat_a_data111      //|> o
  ,sc2mac_dat_a_data112      //|> o
  ,sc2mac_dat_a_data113      //|> o
  ,sc2mac_dat_a_data114      //|> o
  ,sc2mac_dat_a_data115      //|> o
  ,sc2mac_dat_a_data116      //|> o
  ,sc2mac_dat_a_data117      //|> o
  ,sc2mac_dat_a_data118      //|> o
  ,sc2mac_dat_a_data119      //|> o
  ,sc2mac_dat_a_data120      //|> o
  ,sc2mac_dat_a_data121      //|> o
  ,sc2mac_dat_a_data122      //|> o
  ,sc2mac_dat_a_data123      //|> o
  ,sc2mac_dat_a_data124      //|> o
  ,sc2mac_dat_a_data125      //|> o
  ,sc2mac_dat_a_data126      //|> o
  ,sc2mac_dat_a_data127      //|> o
  ,sc2mac_dat_a_pd           //|> o
  ,sc2mac_dat_b_pvld         //|> o
  ,sc2mac_dat_b_mask         //|> o
  ,sc2mac_dat_b_data0        //|> o
  ,sc2mac_dat_b_data1        //|> o
  ,sc2mac_dat_b_data2        //|> o
  ,sc2mac_dat_b_data3        //|> o
  ,sc2mac_dat_b_data4        //|> o
  ,sc2mac_dat_b_data5        //|> o
  ,sc2mac_dat_b_data6        //|> o
  ,sc2mac_dat_b_data7        //|> o
  ,sc2mac_dat_b_data8        //|> o
  ,sc2mac_dat_b_data9        //|> o
  ,sc2mac_dat_b_data10       //|> o
  ,sc2mac_dat_b_data11       //|> o
  ,sc2mac_dat_b_data12       //|> o
  ,sc2mac_dat_b_data13       //|> o
  ,sc2mac_dat_b_data14       //|> o
  ,sc2mac_dat_b_data15       //|> o
  ,sc2mac_dat_b_data16       //|> o
  ,sc2mac_dat_b_data17       //|> o
  ,sc2mac_dat_b_data18       //|> o
  ,sc2mac_dat_b_data19       //|> o
  ,sc2mac_dat_b_data20       //|> o
  ,sc2mac_dat_b_data21       //|> o
  ,sc2mac_dat_b_data22       //|> o
  ,sc2mac_dat_b_data23       //|> o
  ,sc2mac_dat_b_data24       //|> o
  ,sc2mac_dat_b_data25       //|> o
  ,sc2mac_dat_b_data26       //|> o
  ,sc2mac_dat_b_data27       //|> o
  ,sc2mac_dat_b_data28       //|> o
  ,sc2mac_dat_b_data29       //|> o
  ,sc2mac_dat_b_data30       //|> o
  ,sc2mac_dat_b_data31       //|> o
  ,sc2mac_dat_b_data32       //|> o
  ,sc2mac_dat_b_data33       //|> o
  ,sc2mac_dat_b_data34       //|> o
  ,sc2mac_dat_b_data35       //|> o
  ,sc2mac_dat_b_data36       //|> o
  ,sc2mac_dat_b_data37       //|> o
  ,sc2mac_dat_b_data38       //|> o
  ,sc2mac_dat_b_data39       //|> o
  ,sc2mac_dat_b_data40       //|> o
  ,sc2mac_dat_b_data41       //|> o
  ,sc2mac_dat_b_data42       //|> o
  ,sc2mac_dat_b_data43       //|> o
  ,sc2mac_dat_b_data44       //|> o
  ,sc2mac_dat_b_data45       //|> o
  ,sc2mac_dat_b_data46       //|> o
  ,sc2mac_dat_b_data47       //|> o
  ,sc2mac_dat_b_data48       //|> o
  ,sc2mac_dat_b_data49       //|> o
  ,sc2mac_dat_b_data50       //|> o
  ,sc2mac_dat_b_data51       //|> o
  ,sc2mac_dat_b_data52       //|> o
  ,sc2mac_dat_b_data53       //|> o
  ,sc2mac_dat_b_data54       //|> o
  ,sc2mac_dat_b_data55       //|> o
  ,sc2mac_dat_b_data56       //|> o
  ,sc2mac_dat_b_data57       //|> o
  ,sc2mac_dat_b_data58       //|> o
  ,sc2mac_dat_b_data59       //|> o
  ,sc2mac_dat_b_data60       //|> o
  ,sc2mac_dat_b_data61       //|> o
  ,sc2mac_dat_b_data62       //|> o
  ,sc2mac_dat_b_data63       //|> o
  ,sc2mac_dat_b_data64       //|> o
  ,sc2mac_dat_b_data65       //|> o
  ,sc2mac_dat_b_data66       //|> o
  ,sc2mac_dat_b_data67       //|> o
  ,sc2mac_dat_b_data68       //|> o
  ,sc2mac_dat_b_data69       //|> o
  ,sc2mac_dat_b_data70       //|> o
  ,sc2mac_dat_b_data71       //|> o
  ,sc2mac_dat_b_data72       //|> o
  ,sc2mac_dat_b_data73       //|> o
  ,sc2mac_dat_b_data74       //|> o
  ,sc2mac_dat_b_data75       //|> o
  ,sc2mac_dat_b_data76       //|> o
  ,sc2mac_dat_b_data77       //|> o
  ,sc2mac_dat_b_data78       //|> o
  ,sc2mac_dat_b_data79       //|> o
  ,sc2mac_dat_b_data80       //|> o
  ,sc2mac_dat_b_data81       //|> o
  ,sc2mac_dat_b_data82       //|> o
  ,sc2mac_dat_b_data83       //|> o
  ,sc2mac_dat_b_data84       //|> o
  ,sc2mac_dat_b_data85       //|> o
  ,sc2mac_dat_b_data86       //|> o
  ,sc2mac_dat_b_data87       //|> o
  ,sc2mac_dat_b_data88       //|> o
  ,sc2mac_dat_b_data89       //|> o
  ,sc2mac_dat_b_data90       //|> o
  ,sc2mac_dat_b_data91       //|> o
  ,sc2mac_dat_b_data92       //|> o
  ,sc2mac_dat_b_data93       //|> o
  ,sc2mac_dat_b_data94       //|> o
  ,sc2mac_dat_b_data95       //|> o
  ,sc2mac_dat_b_data96       //|> o
  ,sc2mac_dat_b_data97       //|> o
  ,sc2mac_dat_b_data98       //|> o
  ,sc2mac_dat_b_data99       //|> o
  ,sc2mac_dat_b_data100      //|> o
  ,sc2mac_dat_b_data101      //|> o
  ,sc2mac_dat_b_data102      //|> o
  ,sc2mac_dat_b_data103      //|> o
  ,sc2mac_dat_b_data104      //|> o
  ,sc2mac_dat_b_data105      //|> o
  ,sc2mac_dat_b_data106      //|> o
  ,sc2mac_dat_b_data107      //|> o
  ,sc2mac_dat_b_data108      //|> o
  ,sc2mac_dat_b_data109      //|> o
  ,sc2mac_dat_b_data110      //|> o
  ,sc2mac_dat_b_data111      //|> o
  ,sc2mac_dat_b_data112      //|> o
  ,sc2mac_dat_b_data113      //|> o
  ,sc2mac_dat_b_data114      //|> o
  ,sc2mac_dat_b_data115      //|> o
  ,sc2mac_dat_b_data116      //|> o
  ,sc2mac_dat_b_data117      //|> o
  ,sc2mac_dat_b_data118      //|> o
  ,sc2mac_dat_b_data119      //|> o
  ,sc2mac_dat_b_data120      //|> o
  ,sc2mac_dat_b_data121      //|> o
  ,sc2mac_dat_b_data122      //|> o
  ,sc2mac_dat_b_data123      //|> o
  ,sc2mac_dat_b_data124      //|> o
  ,sc2mac_dat_b_data125      //|> o
  ,sc2mac_dat_b_data126      //|> o
  ,sc2mac_dat_b_data127      //|> o
  ,sc2mac_dat_b_pd           //|> o
  ,nvdla_core_ng_clk         //|< i
  ,nvdla_wg_clk              //|< i
  ,reg2dp_op_en              //|< i
  ,reg2dp_conv_mode          //|< i
  ,reg2dp_batches            //|< i
  ,reg2dp_proc_precision     //|< i
  ,reg2dp_datain_format      //|< i
  ,reg2dp_skip_data_rls      //|< i
  ,reg2dp_datain_channel_ext //|< i
  ,reg2dp_datain_height_ext  //|< i
  ,reg2dp_datain_width_ext   //|< i
  ,reg2dp_y_extension        //|< i
  ,reg2dp_weight_channel_ext //|< i
  ,reg2dp_entries            //|< i
  ,reg2dp_dataout_width      //|< i
  ,reg2dp_rls_slices         //|< i
  ,reg2dp_conv_x_stride_ext  //|< i
  ,reg2dp_conv_y_stride_ext  //|< i
  ,reg2dp_x_dilation_ext     //|< i
  ,reg2dp_y_dilation_ext     //|< i
  ,reg2dp_pad_left           //|< i
  ,reg2dp_pad_top            //|< i
  ,reg2dp_pad_value          //|< i
  ,reg2dp_data_bank          //|< i
  ,reg2dp_pra_truncate       //|< i
  ,slcg_wg_en                //|> o
  );


//
// NV_NVDLA_CSC_dl_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input        sg2dl_pvld;  /* data valid */
input [30:0] sg2dl_pd;

input [1:0] sc_state;

input  sg2dl_reuse_rls;

input  sc2cdma_dat_pending_req;

input        cdma2sc_dat_updt;     /* data valid */
input [11:0] cdma2sc_dat_entries;
input [11:0] cdma2sc_dat_slices;

output        sc2cdma_dat_updt;     /* data valid */
output [11:0] sc2cdma_dat_entries;
output [11:0] sc2cdma_dat_slices;

output        sc2buf_dat_rd_en;    /* data valid */
output [11:0] sc2buf_dat_rd_addr;

input          sc2buf_dat_rd_valid;  /* data valid */
input [1023:0] sc2buf_dat_rd_data;

output         sc2mac_dat_a_pvld;     /* data valid */
output [127:0] sc2mac_dat_a_mask;
output   [7:0] sc2mac_dat_a_data0;
output   [7:0] sc2mac_dat_a_data1;
output   [7:0] sc2mac_dat_a_data2;
output   [7:0] sc2mac_dat_a_data3;
output   [7:0] sc2mac_dat_a_data4;
output   [7:0] sc2mac_dat_a_data5;
output   [7:0] sc2mac_dat_a_data6;
output   [7:0] sc2mac_dat_a_data7;
output   [7:0] sc2mac_dat_a_data8;
output   [7:0] sc2mac_dat_a_data9;
output   [7:0] sc2mac_dat_a_data10;
output   [7:0] sc2mac_dat_a_data11;
output   [7:0] sc2mac_dat_a_data12;
output   [7:0] sc2mac_dat_a_data13;
output   [7:0] sc2mac_dat_a_data14;
output   [7:0] sc2mac_dat_a_data15;
output   [7:0] sc2mac_dat_a_data16;
output   [7:0] sc2mac_dat_a_data17;
output   [7:0] sc2mac_dat_a_data18;
output   [7:0] sc2mac_dat_a_data19;
output   [7:0] sc2mac_dat_a_data20;
output   [7:0] sc2mac_dat_a_data21;
output   [7:0] sc2mac_dat_a_data22;
output   [7:0] sc2mac_dat_a_data23;
output   [7:0] sc2mac_dat_a_data24;
output   [7:0] sc2mac_dat_a_data25;
output   [7:0] sc2mac_dat_a_data26;
output   [7:0] sc2mac_dat_a_data27;
output   [7:0] sc2mac_dat_a_data28;
output   [7:0] sc2mac_dat_a_data29;
output   [7:0] sc2mac_dat_a_data30;
output   [7:0] sc2mac_dat_a_data31;
output   [7:0] sc2mac_dat_a_data32;
output   [7:0] sc2mac_dat_a_data33;
output   [7:0] sc2mac_dat_a_data34;
output   [7:0] sc2mac_dat_a_data35;
output   [7:0] sc2mac_dat_a_data36;
output   [7:0] sc2mac_dat_a_data37;
output   [7:0] sc2mac_dat_a_data38;
output   [7:0] sc2mac_dat_a_data39;
output   [7:0] sc2mac_dat_a_data40;
output   [7:0] sc2mac_dat_a_data41;
output   [7:0] sc2mac_dat_a_data42;
output   [7:0] sc2mac_dat_a_data43;
output   [7:0] sc2mac_dat_a_data44;
output   [7:0] sc2mac_dat_a_data45;
output   [7:0] sc2mac_dat_a_data46;
output   [7:0] sc2mac_dat_a_data47;
output   [7:0] sc2mac_dat_a_data48;
output   [7:0] sc2mac_dat_a_data49;
output   [7:0] sc2mac_dat_a_data50;
output   [7:0] sc2mac_dat_a_data51;
output   [7:0] sc2mac_dat_a_data52;
output   [7:0] sc2mac_dat_a_data53;
output   [7:0] sc2mac_dat_a_data54;
output   [7:0] sc2mac_dat_a_data55;
output   [7:0] sc2mac_dat_a_data56;
output   [7:0] sc2mac_dat_a_data57;
output   [7:0] sc2mac_dat_a_data58;
output   [7:0] sc2mac_dat_a_data59;
output   [7:0] sc2mac_dat_a_data60;
output   [7:0] sc2mac_dat_a_data61;
output   [7:0] sc2mac_dat_a_data62;
output   [7:0] sc2mac_dat_a_data63;
output   [7:0] sc2mac_dat_a_data64;
output   [7:0] sc2mac_dat_a_data65;
output   [7:0] sc2mac_dat_a_data66;
output   [7:0] sc2mac_dat_a_data67;
output   [7:0] sc2mac_dat_a_data68;
output   [7:0] sc2mac_dat_a_data69;
output   [7:0] sc2mac_dat_a_data70;
output   [7:0] sc2mac_dat_a_data71;
output   [7:0] sc2mac_dat_a_data72;
output   [7:0] sc2mac_dat_a_data73;
output   [7:0] sc2mac_dat_a_data74;
output   [7:0] sc2mac_dat_a_data75;
output   [7:0] sc2mac_dat_a_data76;
output   [7:0] sc2mac_dat_a_data77;
output   [7:0] sc2mac_dat_a_data78;
output   [7:0] sc2mac_dat_a_data79;
output   [7:0] sc2mac_dat_a_data80;
output   [7:0] sc2mac_dat_a_data81;
output   [7:0] sc2mac_dat_a_data82;
output   [7:0] sc2mac_dat_a_data83;
output   [7:0] sc2mac_dat_a_data84;
output   [7:0] sc2mac_dat_a_data85;
output   [7:0] sc2mac_dat_a_data86;
output   [7:0] sc2mac_dat_a_data87;
output   [7:0] sc2mac_dat_a_data88;
output   [7:0] sc2mac_dat_a_data89;
output   [7:0] sc2mac_dat_a_data90;
output   [7:0] sc2mac_dat_a_data91;
output   [7:0] sc2mac_dat_a_data92;
output   [7:0] sc2mac_dat_a_data93;
output   [7:0] sc2mac_dat_a_data94;
output   [7:0] sc2mac_dat_a_data95;
output   [7:0] sc2mac_dat_a_data96;
output   [7:0] sc2mac_dat_a_data97;
output   [7:0] sc2mac_dat_a_data98;
output   [7:0] sc2mac_dat_a_data99;
output   [7:0] sc2mac_dat_a_data100;
output   [7:0] sc2mac_dat_a_data101;
output   [7:0] sc2mac_dat_a_data102;
output   [7:0] sc2mac_dat_a_data103;
output   [7:0] sc2mac_dat_a_data104;
output   [7:0] sc2mac_dat_a_data105;
output   [7:0] sc2mac_dat_a_data106;
output   [7:0] sc2mac_dat_a_data107;
output   [7:0] sc2mac_dat_a_data108;
output   [7:0] sc2mac_dat_a_data109;
output   [7:0] sc2mac_dat_a_data110;
output   [7:0] sc2mac_dat_a_data111;
output   [7:0] sc2mac_dat_a_data112;
output   [7:0] sc2mac_dat_a_data113;
output   [7:0] sc2mac_dat_a_data114;
output   [7:0] sc2mac_dat_a_data115;
output   [7:0] sc2mac_dat_a_data116;
output   [7:0] sc2mac_dat_a_data117;
output   [7:0] sc2mac_dat_a_data118;
output   [7:0] sc2mac_dat_a_data119;
output   [7:0] sc2mac_dat_a_data120;
output   [7:0] sc2mac_dat_a_data121;
output   [7:0] sc2mac_dat_a_data122;
output   [7:0] sc2mac_dat_a_data123;
output   [7:0] sc2mac_dat_a_data124;
output   [7:0] sc2mac_dat_a_data125;
output   [7:0] sc2mac_dat_a_data126;
output   [7:0] sc2mac_dat_a_data127;
output   [8:0] sc2mac_dat_a_pd;

output         sc2mac_dat_b_pvld;     /* data valid */
output [127:0] sc2mac_dat_b_mask;
output   [7:0] sc2mac_dat_b_data0;
output   [7:0] sc2mac_dat_b_data1;
output   [7:0] sc2mac_dat_b_data2;
output   [7:0] sc2mac_dat_b_data3;
output   [7:0] sc2mac_dat_b_data4;
output   [7:0] sc2mac_dat_b_data5;
output   [7:0] sc2mac_dat_b_data6;
output   [7:0] sc2mac_dat_b_data7;
output   [7:0] sc2mac_dat_b_data8;
output   [7:0] sc2mac_dat_b_data9;
output   [7:0] sc2mac_dat_b_data10;
output   [7:0] sc2mac_dat_b_data11;
output   [7:0] sc2mac_dat_b_data12;
output   [7:0] sc2mac_dat_b_data13;
output   [7:0] sc2mac_dat_b_data14;
output   [7:0] sc2mac_dat_b_data15;
output   [7:0] sc2mac_dat_b_data16;
output   [7:0] sc2mac_dat_b_data17;
output   [7:0] sc2mac_dat_b_data18;
output   [7:0] sc2mac_dat_b_data19;
output   [7:0] sc2mac_dat_b_data20;
output   [7:0] sc2mac_dat_b_data21;
output   [7:0] sc2mac_dat_b_data22;
output   [7:0] sc2mac_dat_b_data23;
output   [7:0] sc2mac_dat_b_data24;
output   [7:0] sc2mac_dat_b_data25;
output   [7:0] sc2mac_dat_b_data26;
output   [7:0] sc2mac_dat_b_data27;
output   [7:0] sc2mac_dat_b_data28;
output   [7:0] sc2mac_dat_b_data29;
output   [7:0] sc2mac_dat_b_data30;
output   [7:0] sc2mac_dat_b_data31;
output   [7:0] sc2mac_dat_b_data32;
output   [7:0] sc2mac_dat_b_data33;
output   [7:0] sc2mac_dat_b_data34;
output   [7:0] sc2mac_dat_b_data35;
output   [7:0] sc2mac_dat_b_data36;
output   [7:0] sc2mac_dat_b_data37;
output   [7:0] sc2mac_dat_b_data38;
output   [7:0] sc2mac_dat_b_data39;
output   [7:0] sc2mac_dat_b_data40;
output   [7:0] sc2mac_dat_b_data41;
output   [7:0] sc2mac_dat_b_data42;
output   [7:0] sc2mac_dat_b_data43;
output   [7:0] sc2mac_dat_b_data44;
output   [7:0] sc2mac_dat_b_data45;
output   [7:0] sc2mac_dat_b_data46;
output   [7:0] sc2mac_dat_b_data47;
output   [7:0] sc2mac_dat_b_data48;
output   [7:0] sc2mac_dat_b_data49;
output   [7:0] sc2mac_dat_b_data50;
output   [7:0] sc2mac_dat_b_data51;
output   [7:0] sc2mac_dat_b_data52;
output   [7:0] sc2mac_dat_b_data53;
output   [7:0] sc2mac_dat_b_data54;
output   [7:0] sc2mac_dat_b_data55;
output   [7:0] sc2mac_dat_b_data56;
output   [7:0] sc2mac_dat_b_data57;
output   [7:0] sc2mac_dat_b_data58;
output   [7:0] sc2mac_dat_b_data59;
output   [7:0] sc2mac_dat_b_data60;
output   [7:0] sc2mac_dat_b_data61;
output   [7:0] sc2mac_dat_b_data62;
output   [7:0] sc2mac_dat_b_data63;
output   [7:0] sc2mac_dat_b_data64;
output   [7:0] sc2mac_dat_b_data65;
output   [7:0] sc2mac_dat_b_data66;
output   [7:0] sc2mac_dat_b_data67;
output   [7:0] sc2mac_dat_b_data68;
output   [7:0] sc2mac_dat_b_data69;
output   [7:0] sc2mac_dat_b_data70;
output   [7:0] sc2mac_dat_b_data71;
output   [7:0] sc2mac_dat_b_data72;
output   [7:0] sc2mac_dat_b_data73;
output   [7:0] sc2mac_dat_b_data74;
output   [7:0] sc2mac_dat_b_data75;
output   [7:0] sc2mac_dat_b_data76;
output   [7:0] sc2mac_dat_b_data77;
output   [7:0] sc2mac_dat_b_data78;
output   [7:0] sc2mac_dat_b_data79;
output   [7:0] sc2mac_dat_b_data80;
output   [7:0] sc2mac_dat_b_data81;
output   [7:0] sc2mac_dat_b_data82;
output   [7:0] sc2mac_dat_b_data83;
output   [7:0] sc2mac_dat_b_data84;
output   [7:0] sc2mac_dat_b_data85;
output   [7:0] sc2mac_dat_b_data86;
output   [7:0] sc2mac_dat_b_data87;
output   [7:0] sc2mac_dat_b_data88;
output   [7:0] sc2mac_dat_b_data89;
output   [7:0] sc2mac_dat_b_data90;
output   [7:0] sc2mac_dat_b_data91;
output   [7:0] sc2mac_dat_b_data92;
output   [7:0] sc2mac_dat_b_data93;
output   [7:0] sc2mac_dat_b_data94;
output   [7:0] sc2mac_dat_b_data95;
output   [7:0] sc2mac_dat_b_data96;
output   [7:0] sc2mac_dat_b_data97;
output   [7:0] sc2mac_dat_b_data98;
output   [7:0] sc2mac_dat_b_data99;
output   [7:0] sc2mac_dat_b_data100;
output   [7:0] sc2mac_dat_b_data101;
output   [7:0] sc2mac_dat_b_data102;
output   [7:0] sc2mac_dat_b_data103;
output   [7:0] sc2mac_dat_b_data104;
output   [7:0] sc2mac_dat_b_data105;
output   [7:0] sc2mac_dat_b_data106;
output   [7:0] sc2mac_dat_b_data107;
output   [7:0] sc2mac_dat_b_data108;
output   [7:0] sc2mac_dat_b_data109;
output   [7:0] sc2mac_dat_b_data110;
output   [7:0] sc2mac_dat_b_data111;
output   [7:0] sc2mac_dat_b_data112;
output   [7:0] sc2mac_dat_b_data113;
output   [7:0] sc2mac_dat_b_data114;
output   [7:0] sc2mac_dat_b_data115;
output   [7:0] sc2mac_dat_b_data116;
output   [7:0] sc2mac_dat_b_data117;
output   [7:0] sc2mac_dat_b_data118;
output   [7:0] sc2mac_dat_b_data119;
output   [7:0] sc2mac_dat_b_data120;
output   [7:0] sc2mac_dat_b_data121;
output   [7:0] sc2mac_dat_b_data122;
output   [7:0] sc2mac_dat_b_data123;
output   [7:0] sc2mac_dat_b_data124;
output   [7:0] sc2mac_dat_b_data125;
output   [7:0] sc2mac_dat_b_data126;
output   [7:0] sc2mac_dat_b_data127;
output   [8:0] sc2mac_dat_b_pd;

input nvdla_core_ng_clk;
input nvdla_wg_clk;

input [0:0]                      reg2dp_op_en;
input [0:0]                   reg2dp_conv_mode;
input [4:0]                 reg2dp_batches;
input [1:0]              reg2dp_proc_precision;
input [0:0]          reg2dp_datain_format;
input [0:0]               reg2dp_skip_data_rls;
input [12:0] reg2dp_datain_channel_ext;
input [12:0]  reg2dp_datain_height_ext;
input [12:0]   reg2dp_datain_width_ext;
input [1:0]         reg2dp_y_extension;
input [12:0] reg2dp_weight_channel_ext;
input [11:0]              reg2dp_entries;
input [12:0]         reg2dp_dataout_width;
input [11:0]                   reg2dp_rls_slices;
input [2:0]    reg2dp_conv_x_stride_ext;
input [2:0]    reg2dp_conv_y_stride_ext;
input [4:0]          reg2dp_x_dilation_ext;
input [4:0]          reg2dp_y_dilation_ext;
input [4:0]                reg2dp_pad_left;
input [4:0]                 reg2dp_pad_top;
input [15:0]         reg2dp_pad_value;
input [3:0]                       reg2dp_data_bank;
input [1:0]                 reg2dp_pra_truncate;

output slcg_wg_en;

wire            dat_dummy_l0_en;
wire            dat_dummy_l1_en;
wire            dat_dummy_l2_en;
wire            dat_dummy_l3_en;
wire            dat_l0_set;
wire            dat_l0c0_dummy_w;
wire            dat_l0c1_dummy_w;
wire            dat_l1_set;
wire            dat_l1c0_dummy_w;
wire            dat_l1c1_dummy_w;
wire            dat_l2_set;
wire            dat_l2c0_dummy_w;
wire            dat_l2c1_dummy_w;
wire            dat_l3_set;
wire            dat_l3c0_dummy_w;
wire            dat_l3c1_dummy_w;
wire   [1023:0] dat_out_bypass_data_w;
wire    [127:0] dat_out_bypass_mask_w;
wire            dat_out_bypass_p0_vld_w;
wire            dat_out_bypass_p1_vld_w;
wire      [8:0] dat_out_flag_l0;
wire      [8:0] dat_out_flag_w;
wire            dat_out_pvld_l0;
wire            dat_out_pvld_w;
wire            dat_pipe_valid;
wire    [255:0] dat_pra_dat_ch0;
wire    [255:0] dat_pra_dat_ch1;
wire    [255:0] dat_pra_dat_ch2;
wire    [255:0] dat_pra_dat_ch3;
wire     [11:0] dat_req_addr_last;
wire     [11:0] dat_req_base_d1;
wire      [4:0] dat_req_batch_index;
wire            dat_req_channel_end;
wire            dat_req_exec_dummy;
wire            dat_req_exec_pvld;
wire      [1:0] dat_req_exec_sub_h;
wire      [8:0] dat_req_flag_w;
wire            dat_req_layer_end;
wire      [7:0] dat_req_pipe_bytes;
wire            dat_req_pipe_ch_end;
wire            dat_req_pipe_ch_odd;
wire      [1:0] dat_req_pipe_cur_sub_h;
wire            dat_req_pipe_dummy;
wire      [8:0] dat_req_pipe_flag;
wire     [28:0] dat_req_pipe_pd;
wire            dat_req_pipe_pvld;
wire            dat_req_pipe_rls;
wire            dat_req_pipe_sub_c;
wire      [1:0] dat_req_pipe_sub_h;
wire      [1:0] dat_req_pipe_sub_w;
wire            dat_req_pipe_sub_w_st;
wire            dat_req_stripe_end;
wire            dat_req_stripe_st;
wire            dat_req_sub_h_0_addr_en;
wire            dat_req_sub_h_1_addr_en;
wire            dat_req_sub_h_2_addr_en;
wire            dat_req_sub_h_3_addr_en;
wire            dat_req_sub_w_st_en;
wire      [4:0] dat_rsp_batch_index;
wire      [7:0] dat_rsp_bytes;
wire            dat_rsp_ch_end;
wire            dat_rsp_ch_odd;
wire            dat_rsp_channel_end;
wire      [1:0] dat_rsp_cur_sub_h;
wire            dat_rsp_exec_dummy;
wire            dat_rsp_exec_dummy_d0;
wire            dat_rsp_exec_pvld;
wire            dat_rsp_exec_pvld_d0;
wire      [1:0] dat_rsp_exec_sub_h;
wire      [1:0] dat_rsp_exec_sub_h_d0;
wire      [8:0] dat_rsp_flag;
wire            dat_rsp_l0_block_end;
wire            dat_rsp_l1_block_end;
wire            dat_rsp_l2_block_end;
wire            dat_rsp_l3_block_end;
wire            dat_rsp_layer_end;
wire     [26:0] dat_rsp_pd_d0;
wire      [7:0] dat_rsp_pipe_bytes;
wire            dat_rsp_pipe_ch_end;
wire            dat_rsp_pipe_ch_odd;
wire      [1:0] dat_rsp_pipe_cur_sub_h;
wire            dat_rsp_pipe_dummy;
wire      [8:0] dat_rsp_pipe_flag;
wire     [28:0] dat_rsp_pipe_pd;
wire     [28:0] dat_rsp_pipe_pd_d0;
wire            dat_rsp_pipe_pvld;
wire            dat_rsp_pipe_pvld_d0;
wire            dat_rsp_pipe_rls;
wire            dat_rsp_pipe_sub_c;
wire      [1:0] dat_rsp_pipe_sub_h;
wire      [1:0] dat_rsp_pipe_sub_w;
wire            dat_rsp_pipe_sub_w_st;
wire            dat_rsp_pvld_d0;
wire            dat_rsp_rls;
wire            dat_rsp_stripe_end;
wire            dat_rsp_stripe_st;
wire            dat_rsp_sub_c;
wire      [1:0] dat_rsp_sub_h;
wire      [1:0] dat_rsp_sub_w;
wire    [255:0] dat_wg_16b_ch0;
wire    [255:0] dat_wg_16b_ch1;
wire    [255:0] dat_wg_16b_ch2;
wire    [255:0] dat_wg_16b_ch3;
wire    [255:0] dat_wg_8b_ch0;
wire    [255:0] dat_wg_8b_ch1;
wire    [255:0] dat_wg_8b_ch2;
wire    [255:0] dat_wg_8b_ch3;
wire    [255:0] dat_wg_8b_ch4;
wire    [255:0] dat_wg_8b_ch5;
wire    [255:0] dat_wg_8b_ch6;
wire    [255:0] dat_wg_8b_ch7;
wire            dat_wg_adv;
wire            dat_wg_req_dummy;
wire      [2:0] dataout_w_add;
wire   [1023:0] dbg_csc_dat;
wire      [7:0] dbg_csc_dat_0;
wire      [7:0] dbg_csc_dat_1;
wire      [7:0] dbg_csc_dat_10;
wire      [7:0] dbg_csc_dat_100;
wire      [7:0] dbg_csc_dat_101;
wire      [7:0] dbg_csc_dat_102;
wire      [7:0] dbg_csc_dat_103;
wire      [7:0] dbg_csc_dat_104;
wire      [7:0] dbg_csc_dat_105;
wire      [7:0] dbg_csc_dat_106;
wire      [7:0] dbg_csc_dat_107;
wire      [7:0] dbg_csc_dat_108;
wire      [7:0] dbg_csc_dat_109;
wire      [7:0] dbg_csc_dat_11;
wire      [7:0] dbg_csc_dat_110;
wire      [7:0] dbg_csc_dat_111;
wire      [7:0] dbg_csc_dat_112;
wire      [7:0] dbg_csc_dat_113;
wire      [7:0] dbg_csc_dat_114;
wire      [7:0] dbg_csc_dat_115;
wire      [7:0] dbg_csc_dat_116;
wire      [7:0] dbg_csc_dat_117;
wire      [7:0] dbg_csc_dat_118;
wire      [7:0] dbg_csc_dat_119;
wire      [7:0] dbg_csc_dat_12;
wire      [7:0] dbg_csc_dat_120;
wire      [7:0] dbg_csc_dat_121;
wire      [7:0] dbg_csc_dat_122;
wire      [7:0] dbg_csc_dat_123;
wire      [7:0] dbg_csc_dat_124;
wire      [7:0] dbg_csc_dat_125;
wire      [7:0] dbg_csc_dat_126;
wire      [7:0] dbg_csc_dat_127;
wire      [7:0] dbg_csc_dat_13;
wire      [7:0] dbg_csc_dat_14;
wire      [7:0] dbg_csc_dat_15;
wire      [7:0] dbg_csc_dat_16;
wire      [7:0] dbg_csc_dat_17;
wire      [7:0] dbg_csc_dat_18;
wire      [7:0] dbg_csc_dat_19;
wire      [7:0] dbg_csc_dat_2;
wire      [7:0] dbg_csc_dat_20;
wire      [7:0] dbg_csc_dat_21;
wire      [7:0] dbg_csc_dat_22;
wire      [7:0] dbg_csc_dat_23;
wire      [7:0] dbg_csc_dat_24;
wire      [7:0] dbg_csc_dat_25;
wire      [7:0] dbg_csc_dat_26;
wire      [7:0] dbg_csc_dat_27;
wire      [7:0] dbg_csc_dat_28;
wire      [7:0] dbg_csc_dat_29;
wire      [7:0] dbg_csc_dat_3;
wire      [7:0] dbg_csc_dat_30;
wire      [7:0] dbg_csc_dat_31;
wire      [7:0] dbg_csc_dat_32;
wire      [7:0] dbg_csc_dat_33;
wire      [7:0] dbg_csc_dat_34;
wire      [7:0] dbg_csc_dat_35;
wire      [7:0] dbg_csc_dat_36;
wire      [7:0] dbg_csc_dat_37;
wire      [7:0] dbg_csc_dat_38;
wire      [7:0] dbg_csc_dat_39;
wire      [7:0] dbg_csc_dat_4;
wire      [7:0] dbg_csc_dat_40;
wire      [7:0] dbg_csc_dat_41;
wire      [7:0] dbg_csc_dat_42;
wire      [7:0] dbg_csc_dat_43;
wire      [7:0] dbg_csc_dat_44;
wire      [7:0] dbg_csc_dat_45;
wire      [7:0] dbg_csc_dat_46;
wire      [7:0] dbg_csc_dat_47;
wire      [7:0] dbg_csc_dat_48;
wire      [7:0] dbg_csc_dat_49;
wire      [7:0] dbg_csc_dat_5;
wire      [7:0] dbg_csc_dat_50;
wire      [7:0] dbg_csc_dat_51;
wire      [7:0] dbg_csc_dat_52;
wire      [7:0] dbg_csc_dat_53;
wire      [7:0] dbg_csc_dat_54;
wire      [7:0] dbg_csc_dat_55;
wire      [7:0] dbg_csc_dat_56;
wire      [7:0] dbg_csc_dat_57;
wire      [7:0] dbg_csc_dat_58;
wire      [7:0] dbg_csc_dat_59;
wire      [7:0] dbg_csc_dat_6;
wire      [7:0] dbg_csc_dat_60;
wire      [7:0] dbg_csc_dat_61;
wire      [7:0] dbg_csc_dat_62;
wire      [7:0] dbg_csc_dat_63;
wire      [7:0] dbg_csc_dat_64;
wire      [7:0] dbg_csc_dat_65;
wire      [7:0] dbg_csc_dat_66;
wire      [7:0] dbg_csc_dat_67;
wire      [7:0] dbg_csc_dat_68;
wire      [7:0] dbg_csc_dat_69;
wire      [7:0] dbg_csc_dat_7;
wire      [7:0] dbg_csc_dat_70;
wire      [7:0] dbg_csc_dat_71;
wire      [7:0] dbg_csc_dat_72;
wire      [7:0] dbg_csc_dat_73;
wire      [7:0] dbg_csc_dat_74;
wire      [7:0] dbg_csc_dat_75;
wire      [7:0] dbg_csc_dat_76;
wire      [7:0] dbg_csc_dat_77;
wire      [7:0] dbg_csc_dat_78;
wire      [7:0] dbg_csc_dat_79;
wire      [7:0] dbg_csc_dat_8;
wire      [7:0] dbg_csc_dat_80;
wire      [7:0] dbg_csc_dat_81;
wire      [7:0] dbg_csc_dat_82;
wire      [7:0] dbg_csc_dat_83;
wire      [7:0] dbg_csc_dat_84;
wire      [7:0] dbg_csc_dat_85;
wire      [7:0] dbg_csc_dat_86;
wire      [7:0] dbg_csc_dat_87;
wire      [7:0] dbg_csc_dat_88;
wire      [7:0] dbg_csc_dat_89;
wire      [7:0] dbg_csc_dat_9;
wire      [7:0] dbg_csc_dat_90;
wire      [7:0] dbg_csc_dat_91;
wire      [7:0] dbg_csc_dat_92;
wire      [7:0] dbg_csc_dat_93;
wire      [7:0] dbg_csc_dat_94;
wire      [7:0] dbg_csc_dat_95;
wire      [7:0] dbg_csc_dat_96;
wire      [7:0] dbg_csc_dat_97;
wire      [7:0] dbg_csc_dat_98;
wire      [7:0] dbg_csc_dat_99;
wire            dl_block_end;
wire            dl_channel_end;
wire      [6:0] dl_channel_size;
wire      [1:0] dl_cur_sub_h;
wire            dl_dat_release;
wire            dl_group_end;
wire      [4:0] dl_h_offset;
wire     [30:0] dl_in_pd;
wire     [30:0] dl_in_pd_d0;
wire            dl_in_pvld;
wire            dl_in_pvld_d0;
wire            dl_layer_end;
wire     [30:0] dl_pd_d0;
wire            dl_pvld_d0;
wire      [6:0] dl_stripe_length;
wire      [4:0] dl_w_offset;
wire      [1:0] h_bias_reg_en;
wire      [3:0] mon_dat_out_pra_vld;
wire      [3:0] mon_dat_rsp_pra_rdy;
wire            pixel_force_clr;
wire            pixel_force_fetch;
wire            pixel_req_ch_odd_en;
wire            pixel_req_ch_odd_ori_en;
wire      [9:0] pixel_w_cur;
wire      [1:0] pra_precision_0;
wire      [1:0] pra_precision_1;
wire      [1:0] pra_precision_2;
wire      [1:0] pra_precision_3;
wire      [1:0] pra_truncate_0;
wire      [1:0] pra_truncate_1;
wire      [1:0] pra_truncate_2;
wire      [1:0] pra_truncate_3;
wire      [7:0] rsp_sft_cnt_l0_sub;
wire      [7:0] rsp_sft_cnt_l1_sub;
wire      [7:0] rsp_sft_cnt_l2_sub;
wire      [7:0] rsp_sft_cnt_l3_sub;
wire            slcg_wg_en_w;
wire            w_bias_reg_en;
reg       [4:0] batch_cmp;
reg       [4:0] batch_cmp_w;
reg       [4:0] batch_cnt;
reg       [4:0] batch_cnt_w;
reg      [11:0] c_bias;
reg      [11:0] c_bias_add;
reg      [11:0] c_bias_d1;
reg             c_bias_d1_reg_en;
reg             c_bias_reg_en;
reg      [11:0] c_bias_w;
reg             cbuf_reset;
reg       [3:0] conv_x_stride;
reg       [3:0] conv_x_stride_w;
reg       [3:0] conv_y_stride;
reg       [3:0] conv_y_stride_w;
reg             dat_conv_req_dummy;
reg      [11:0] dat_entry_avl;
reg      [11:0] dat_entry_avl_add;
reg      [11:0] dat_entry_avl_sub;
reg      [11:0] dat_entry_avl_w;
reg      [11:0] dat_entry_end;
reg      [12:0] dat_entry_end_inc;
reg      [11:0] dat_entry_end_inc_wrap;
reg      [11:0] dat_entry_end_w;
reg      [11:0] dat_entry_st;
reg      [12:0] dat_entry_st_inc;
reg      [11:0] dat_entry_st_inc_wrap;
reg      [11:0] dat_entry_st_w;
reg             dat_exec_valid;
reg             dat_exec_valid_d1;
reg             dat_exec_valid_d2;
reg             dat_img_req_dummy;
reg             dat_img_req_skip;
reg             dat_l0c0_dummy;
reg             dat_l0c0_en;
reg     [511:0] dat_l0c0_hi;
reg     [511:0] dat_l0c0_lo;
reg             dat_l0c1_dummy;
reg             dat_l0c1_en;
reg     [511:0] dat_l0c1_hi;
reg     [511:0] dat_l0c1_lo;
reg             dat_l1c0_dummy;
reg             dat_l1c0_en;
reg     [511:0] dat_l1c0_hi;
reg             dat_l1c0_hi_en;
reg     [511:0] dat_l1c0_lo;
reg             dat_l1c1_dummy;
reg             dat_l1c1_en;
reg     [511:0] dat_l1c1_hi;
reg             dat_l1c1_hi_en;
reg     [511:0] dat_l1c1_lo;
reg             dat_l2c0_dummy;
reg             dat_l2c0_en;
reg     [511:0] dat_l2c0_hi;
reg     [511:0] dat_l2c0_lo;
reg             dat_l2c1_dummy;
reg             dat_l2c1_en;
reg     [511:0] dat_l2c1_hi;
reg     [511:0] dat_l2c1_lo;
reg             dat_l3c0_dummy;
reg             dat_l3c0_en;
reg     [511:0] dat_l3c0_hi;
reg     [511:0] dat_l3c0_lo;
reg             dat_l3c1_dummy;
reg             dat_l3c1_en;
reg     [511:0] dat_l3c1_hi;
reg     [511:0] dat_l3c1_lo;
reg    [1023:0] dat_out_bypass_data;
reg     [127:0] dat_out_bypass_mask;
reg    [1023:0] dat_out_data;
reg       [8:0] dat_out_flag;
reg       [8:0] dat_out_flag_l1;
reg       [8:0] dat_out_flag_l2;
reg       [8:0] dat_out_flag_l3;
reg       [8:0] dat_out_flag_l4;
reg       [8:0] dat_out_flag_l5;
reg     [127:0] dat_out_mask;
reg             dat_out_pvld;
reg             dat_out_pvld_l1;
reg             dat_out_pvld_l2;
reg             dat_out_pvld_l3;
reg             dat_out_pvld_l4;
reg             dat_out_pvld_l5;
reg    [1023:0] dat_out_wg_16b;
reg     [511:0] dat_out_wg_8b;
reg    [1023:0] dat_out_wg_data;
reg     [127:0] dat_out_wg_mask;
reg     [127:0] dat_out_wg_mask_fp16;
reg     [127:0] dat_out_wg_mask_int16;
reg      [63:0] dat_out_wg_mask_int8;
reg             dat_pipe_local_valid;
reg             dat_pipe_local_valid_w;
reg             dat_pipe_valid_d1;
reg             dat_pipe_valid_d2;
reg    [1023:0] dat_pra_dat;
reg      [12:0] dat_req_addr_sum;
reg      [11:0] dat_req_addr_w;
reg      [11:0] dat_req_addr_wrap;
reg       [7:0] dat_req_bytes;
reg       [7:0] dat_req_bytes_d1;
reg       [7:0] dat_req_bytes_d2;
reg             dat_req_ch_end_d1;
reg             dat_req_ch_end_d2;
reg             dat_req_ch_odd_d1;
reg             dat_req_ch_odd_d2;
reg       [1:0] dat_req_cur_sub_h_d1;
reg       [1:0] dat_req_cur_sub_h_d2;
reg             dat_req_dummy;
reg             dat_req_dummy_d1;
reg             dat_req_dummy_d2;
reg       [8:0] dat_req_flag_d1;
reg       [8:0] dat_req_flag_d2;
reg             dat_req_rls_d1;
reg             dat_req_rls_d2;
reg             dat_req_skip;
reg             dat_req_sub_c_d1;
reg             dat_req_sub_c_d2;
reg             dat_req_sub_c_w;
reg      [11:0] dat_req_sub_h_0_addr;
reg      [11:0] dat_req_sub_h_1_addr;
reg      [11:0] dat_req_sub_h_2_addr;
reg      [11:0] dat_req_sub_h_3_addr;
reg       [1:0] dat_req_sub_h_d1;
reg       [1:0] dat_req_sub_h_d2;
reg       [1:0] dat_req_sub_w_d1;
reg       [1:0] dat_req_sub_w_d2;
reg             dat_req_sub_w_st_d1;
reg             dat_req_sub_w_st_d2;
reg       [1:0] dat_req_sub_w_w;
reg             dat_req_valid;
reg             dat_req_valid_d1;
reg             dat_rls;
reg    [1023:0] dat_rsp_conv;
reg    [1023:0] dat_rsp_conv_16b;
reg     [511:0] dat_rsp_conv_8b;
reg     [127:0] dat_rsp_cur_h_e2_mask_16b;
reg      [63:0] dat_rsp_cur_h_e2_mask_8b;
reg     [127:0] dat_rsp_cur_h_e4_mask_16b;
reg      [63:0] dat_rsp_cur_h_e4_mask_8b;
reg      [63:0] dat_rsp_cur_h_mask_p1;
reg      [31:0] dat_rsp_cur_h_mask_p2;
reg      [31:0] dat_rsp_cur_h_mask_p3;
reg    [1023:0] dat_rsp_data_w;
reg             dat_rsp_exec_dummy_d1;
reg             dat_rsp_exec_dummy_d2;
reg             dat_rsp_exec_dummy_d3;
reg             dat_rsp_exec_dummy_d4;
reg             dat_rsp_exec_dummy_d5;
reg             dat_rsp_exec_dummy_d6;
reg             dat_rsp_exec_pvld_d1;
reg             dat_rsp_exec_pvld_d2;
reg             dat_rsp_exec_pvld_d3;
reg             dat_rsp_exec_pvld_d4;
reg             dat_rsp_exec_pvld_d5;
reg             dat_rsp_exec_pvld_d6;
reg       [1:0] dat_rsp_exec_sub_h_d1;
reg       [1:0] dat_rsp_exec_sub_h_d2;
reg       [1:0] dat_rsp_exec_sub_h_d3;
reg       [1:0] dat_rsp_exec_sub_h_d4;
reg       [1:0] dat_rsp_exec_sub_h_d5;
reg       [1:0] dat_rsp_exec_sub_h_d6;
reg    [1023:0] dat_rsp_img;
reg    [1023:0] dat_rsp_img_16b;
reg     [511:0] dat_rsp_img_8b;
reg             dat_rsp_l0_ch_odd;
reg       [8:0] dat_rsp_l0_flag;
reg             dat_rsp_l0_pvld;
reg    [1023:0] dat_rsp_l0_sft;
reg     [511:0] dat_rsp_l0_sft_d1;
reg     [255:0] dat_rsp_l0_sft_d2;
reg     [255:0] dat_rsp_l0_sft_d3;
reg    [2047:0] dat_rsp_l0_sft_in;
reg             dat_rsp_l0_stripe_end;
reg             dat_rsp_l0_sub_c;
reg     [511:0] dat_rsp_l0c0_hi;
reg     [511:0] dat_rsp_l0c0_lo;
reg     [511:0] dat_rsp_l0c1_hi;
reg     [511:0] dat_rsp_l0c1_lo;
reg             dat_rsp_l1_ch_odd;
reg       [8:0] dat_rsp_l1_flag;
reg             dat_rsp_l1_pvld;
reg     [511:0] dat_rsp_l1_sft;
reg     [255:0] dat_rsp_l1_sft_d2;
reg     [255:0] dat_rsp_l1_sft_d3;
reg    [1023:0] dat_rsp_l1_sft_in;
reg             dat_rsp_l1_stripe_end;
reg             dat_rsp_l1_sub_c;
reg     [511:0] dat_rsp_l1c0_hi;
reg     [511:0] dat_rsp_l1c0_lo;
reg     [511:0] dat_rsp_l1c1_hi;
reg     [511:0] dat_rsp_l1c1_lo;
reg             dat_rsp_l2_ch_odd;
reg       [8:0] dat_rsp_l2_flag;
reg             dat_rsp_l2_pvld;
reg     [255:0] dat_rsp_l2_sft;
reg     [255:0] dat_rsp_l2_sft_d3;
reg    [1023:0] dat_rsp_l2_sft_in;
reg             dat_rsp_l2_stripe_end;
reg             dat_rsp_l2_sub_c;
reg     [511:0] dat_rsp_l2c0_hi;
reg     [511:0] dat_rsp_l2c0_lo;
reg     [511:0] dat_rsp_l2c1_hi;
reg     [511:0] dat_rsp_l2c1_lo;
reg             dat_rsp_l3_ch_odd;
reg       [8:0] dat_rsp_l3_flag;
reg             dat_rsp_l3_pvld;
reg     [255:0] dat_rsp_l3_sft;
reg    [1023:0] dat_rsp_l3_sft_in;
reg             dat_rsp_l3_stripe_end;
reg             dat_rsp_l3_sub_c;
reg     [511:0] dat_rsp_l3c0_hi;
reg     [511:0] dat_rsp_l3c0_lo;
reg     [511:0] dat_rsp_l3c1_hi;
reg     [511:0] dat_rsp_l3c1_lo;
reg     [127:0] dat_rsp_mask_16b;
reg      [63:0] dat_rsp_mask_8b;
reg     [127:0] dat_rsp_mask_val_fp16;
reg     [127:0] dat_rsp_mask_val_int16;
reg      [63:0] dat_rsp_mask_val_int8;
reg     [127:0] dat_rsp_mask_w;
reg     [127:0] dat_rsp_ori_mask;
reg             dat_rsp_p0_vld_w;
reg             dat_rsp_p1_vld_w;
reg     [511:0] dat_rsp_pad_value;
reg      [26:0] dat_rsp_pd;
reg      [26:0] dat_rsp_pd_d1;
reg      [26:0] dat_rsp_pd_d2;
reg      [26:0] dat_rsp_pd_d3;
reg      [26:0] dat_rsp_pd_d4;
reg      [28:0] dat_rsp_pipe_pd_d1;
reg      [28:0] dat_rsp_pipe_pd_d2;
reg      [28:0] dat_rsp_pipe_pd_d3;
reg      [28:0] dat_rsp_pipe_pd_d4;
reg      [28:0] dat_rsp_pipe_pd_d5;
reg      [28:0] dat_rsp_pipe_pd_d6;
reg             dat_rsp_pipe_pvld_d1;
reg             dat_rsp_pipe_pvld_d2;
reg             dat_rsp_pipe_pvld_d3;
reg             dat_rsp_pipe_pvld_d4;
reg             dat_rsp_pipe_pvld_d5;
reg             dat_rsp_pipe_pvld_d6;
reg             dat_rsp_pra_en;
reg       [3:0] dat_rsp_pra_en_d1;
reg             dat_rsp_pvld;
reg             dat_rsp_pvld_d1;
reg             dat_rsp_pvld_d2;
reg             dat_rsp_pvld_d3;
reg             dat_rsp_pvld_d4;
reg             dat_rsp_sft_hi_d1_en;
reg             dat_rsp_sft_hi_d2_en;
reg             dat_rsp_sft_hi_d3_en;
reg             dat_rsp_sft_lo_d1_en;
reg             dat_rsp_sft_lo_d2_en;
reg             dat_rsp_sft_lo_d3_en;
reg    [1023:0] dat_rsp_wg;
reg     [255:0] dat_rsp_wg_ch0;
reg     [255:0] dat_rsp_wg_ch0_d1;
reg     [255:0] dat_rsp_wg_ch1;
reg     [255:0] dat_rsp_wg_ch1_d1;
reg     [255:0] dat_rsp_wg_ch2;
reg     [255:0] dat_rsp_wg_ch2_d1;
reg     [255:0] dat_rsp_wg_ch3;
reg     [255:0] dat_rsp_wg_ch3_d1;
reg    [1023:0] dat_rsp_wg_lb;
reg    [1023:0] dat_rsp_wg_lt;
reg    [1023:0] dat_rsp_wg_rb;
reg    [1023:0] dat_rsp_wg_rt;
reg             dat_rsp_wg_sel_16b;
reg             dat_rsp_wg_sel_8b_hi;
reg             dat_rsp_wg_sel_8b_lo;
reg             dat_rsp_wg_sel_lb;
reg             dat_rsp_wg_sel_lt;
reg             dat_rsp_wg_sel_rb;
reg             dat_rsp_wg_sel_rt;
reg      [11:0] dat_slice_avl;
reg      [11:0] dat_slice_avl_add;
reg      [11:0] dat_slice_avl_sub;
reg      [11:0] dat_slice_avl_w;
reg    [2303:0] dat_wg;
reg             dat_wg_req_skip;
reg       [3:0] data_bank;
reg       [3:0] data_bank_w;
reg       [5:0] data_batch;
reg       [5:0] data_batch_w;
reg      [10:0] datain_c_cnt;
reg      [10:0] datain_c_cnt_inc;
reg             datain_c_cnt_reg_en;
reg      [10:0] datain_c_cnt_w;
reg      [10:0] datain_channel_cmp;
reg      [10:0] datain_channel_cmp_w;
reg      [13:0] datain_h_cnt;
reg      [13:0] datain_h_cnt_inc;
reg             datain_h_cnt_reg_en;
reg      [13:0] datain_h_cnt_st;
reg      [13:0] datain_h_cnt_w;
reg      [13:0] datain_h_cur;
reg      [13:0] datain_h_ori;
reg             datain_h_ori_reg_en;
reg      [12:0] datain_height_cmp;
reg      [12:0] datain_height_cmp_w;
reg      [13:0] datain_w_cnt;
reg      [13:0] datain_w_cnt_inc;
reg             datain_w_cnt_reg_en;
reg      [13:0] datain_w_cnt_st;
reg      [13:0] datain_w_cnt_w;
reg      [13:0] datain_w_cur;
reg      [13:0] datain_w_ori;
reg             datain_w_ori_reg_en;
reg      [13:0] datain_width;
reg      [12:0] datain_width_cmp;
reg      [12:0] datain_width_cmp_w;
reg      [13:0] datain_width_w;
reg      [12:0] dataout_w_cnt;
reg      [12:0] dataout_w_cnt_inc;
reg             dataout_w_cnt_reg_en;
reg      [12:0] dataout_w_cnt_w;
reg      [12:0] dataout_w_init;
reg      [12:0] dataout_w_ori;
reg             dataout_w_ori_reg_en;
reg      [12:0] dataout_width_cmp;
reg      [12:0] dataout_width_cmp_w;
reg       [9:0] dl_h_offset_ext;
reg      [30:0] dl_in_pd_d1;
reg      [30:0] dl_in_pd_d2;
reg      [30:0] dl_in_pd_d3;
reg      [30:0] dl_in_pd_d4;
reg      [30:0] dl_in_pd_d5;
reg             dl_in_pvld_d1;
reg             dl_in_pvld_d2;
reg             dl_in_pvld_d3;
reg             dl_in_pvld_d4;
reg             dl_in_pvld_d5;
reg       [7:0] dl_out_data0;
reg       [7:0] dl_out_data1;
reg       [7:0] dl_out_data10;
reg       [7:0] dl_out_data100;
reg       [7:0] dl_out_data101;
reg       [7:0] dl_out_data102;
reg       [7:0] dl_out_data103;
reg       [7:0] dl_out_data104;
reg       [7:0] dl_out_data105;
reg       [7:0] dl_out_data106;
reg       [7:0] dl_out_data107;
reg       [7:0] dl_out_data108;
reg       [7:0] dl_out_data109;
reg       [7:0] dl_out_data11;
reg       [7:0] dl_out_data110;
reg       [7:0] dl_out_data111;
reg       [7:0] dl_out_data112;
reg       [7:0] dl_out_data113;
reg       [7:0] dl_out_data114;
reg       [7:0] dl_out_data115;
reg       [7:0] dl_out_data116;
reg       [7:0] dl_out_data117;
reg       [7:0] dl_out_data118;
reg       [7:0] dl_out_data119;
reg       [7:0] dl_out_data12;
reg       [7:0] dl_out_data120;
reg       [7:0] dl_out_data121;
reg       [7:0] dl_out_data122;
reg       [7:0] dl_out_data123;
reg       [7:0] dl_out_data124;
reg       [7:0] dl_out_data125;
reg       [7:0] dl_out_data126;
reg       [7:0] dl_out_data127;
reg       [7:0] dl_out_data13;
reg       [7:0] dl_out_data14;
reg       [7:0] dl_out_data15;
reg       [7:0] dl_out_data16;
reg       [7:0] dl_out_data17;
reg       [7:0] dl_out_data18;
reg       [7:0] dl_out_data19;
reg       [7:0] dl_out_data2;
reg       [7:0] dl_out_data20;
reg       [7:0] dl_out_data21;
reg       [7:0] dl_out_data22;
reg       [7:0] dl_out_data23;
reg       [7:0] dl_out_data24;
reg       [7:0] dl_out_data25;
reg       [7:0] dl_out_data26;
reg       [7:0] dl_out_data27;
reg       [7:0] dl_out_data28;
reg       [7:0] dl_out_data29;
reg       [7:0] dl_out_data3;
reg       [7:0] dl_out_data30;
reg       [7:0] dl_out_data31;
reg       [7:0] dl_out_data32;
reg       [7:0] dl_out_data33;
reg       [7:0] dl_out_data34;
reg       [7:0] dl_out_data35;
reg       [7:0] dl_out_data36;
reg       [7:0] dl_out_data37;
reg       [7:0] dl_out_data38;
reg       [7:0] dl_out_data39;
reg       [7:0] dl_out_data4;
reg       [7:0] dl_out_data40;
reg       [7:0] dl_out_data41;
reg       [7:0] dl_out_data42;
reg       [7:0] dl_out_data43;
reg       [7:0] dl_out_data44;
reg       [7:0] dl_out_data45;
reg       [7:0] dl_out_data46;
reg       [7:0] dl_out_data47;
reg       [7:0] dl_out_data48;
reg       [7:0] dl_out_data49;
reg       [7:0] dl_out_data5;
reg       [7:0] dl_out_data50;
reg       [7:0] dl_out_data51;
reg       [7:0] dl_out_data52;
reg       [7:0] dl_out_data53;
reg       [7:0] dl_out_data54;
reg       [7:0] dl_out_data55;
reg       [7:0] dl_out_data56;
reg       [7:0] dl_out_data57;
reg       [7:0] dl_out_data58;
reg       [7:0] dl_out_data59;
reg       [7:0] dl_out_data6;
reg       [7:0] dl_out_data60;
reg       [7:0] dl_out_data61;
reg       [7:0] dl_out_data62;
reg       [7:0] dl_out_data63;
reg       [7:0] dl_out_data64;
reg       [7:0] dl_out_data65;
reg       [7:0] dl_out_data66;
reg       [7:0] dl_out_data67;
reg       [7:0] dl_out_data68;
reg       [7:0] dl_out_data69;
reg       [7:0] dl_out_data7;
reg       [7:0] dl_out_data70;
reg       [7:0] dl_out_data71;
reg       [7:0] dl_out_data72;
reg       [7:0] dl_out_data73;
reg       [7:0] dl_out_data74;
reg       [7:0] dl_out_data75;
reg       [7:0] dl_out_data76;
reg       [7:0] dl_out_data77;
reg       [7:0] dl_out_data78;
reg       [7:0] dl_out_data79;
reg       [7:0] dl_out_data8;
reg       [7:0] dl_out_data80;
reg       [7:0] dl_out_data81;
reg       [7:0] dl_out_data82;
reg       [7:0] dl_out_data83;
reg       [7:0] dl_out_data84;
reg       [7:0] dl_out_data85;
reg       [7:0] dl_out_data86;
reg       [7:0] dl_out_data87;
reg       [7:0] dl_out_data88;
reg       [7:0] dl_out_data89;
reg       [7:0] dl_out_data9;
reg       [7:0] dl_out_data90;
reg       [7:0] dl_out_data91;
reg       [7:0] dl_out_data92;
reg       [7:0] dl_out_data93;
reg       [7:0] dl_out_data94;
reg       [7:0] dl_out_data95;
reg       [7:0] dl_out_data96;
reg       [7:0] dl_out_data97;
reg       [7:0] dl_out_data98;
reg       [7:0] dl_out_data99;
reg       [8:0] dl_out_flag;
reg     [127:0] dl_out_mask;
reg             dl_out_pvld;
reg             dl_out_pvld_d1;
reg      [30:0] dl_pd;
reg      [30:0] dl_pd_d1;
reg      [30:0] dl_pd_d2;
reg      [30:0] dl_pd_d3;
reg      [30:0] dl_pd_d4;
reg             dl_pvld;
reg             dl_pvld_d1;
reg             dl_pvld_d2;
reg             dl_pvld_d3;
reg             dl_pvld_d4;
reg       [9:0] dl_w_offset_ext;
reg      [11:0] entries;
reg      [11:0] entries_batch;
reg      [11:0] entries_batch_w;
reg      [11:0] entries_cmp;
reg      [11:0] entries_single_w;
reg      [11:0] entries_w;
reg      [11:0] h_bias_0_d1;
reg      [11:0] h_bias_0_stride;
reg      [11:0] h_bias_0_stride_w;
reg      [11:0] h_bias_0_w;
reg      [11:0] h_bias_1_d1;
reg      [11:0] h_bias_1_stride;
reg      [11:0] h_bias_1_stride_w;
reg      [11:0] h_bias_1_w;
reg      [11:0] h_bias_2_d1;
reg      [11:0] h_bias_2_stride;
reg      [11:0] h_bias_2_w;
reg      [11:0] h_bias_3_d1;
reg      [11:0] h_bias_3_stride;
reg      [11:0] h_bias_3_w;
reg      [11:0] h_bias_d1;
reg      [11:0] h_offset_slice;
reg      [11:0] h_offset_slice_w;
reg             is_batch_end;
reg             is_conv;
reg             is_dat_entry_end_wrap;
reg             is_dat_entry_st_wrap;
reg             is_dat_req_addr_wrap;
reg             is_fp16;
reg       [1:0] is_fp16_d1;
reg             is_img;
reg      [33:0] is_img_d1;
reg             is_int8;
reg      [22:0] is_int8_d1;
reg             is_last_channel;
reg             is_pixel;
reg             is_running_first;
reg             is_sg_done;
reg             is_sg_idle;
reg             is_sg_running;
reg             is_sg_running_d1;
reg             is_stripe_end;
reg             is_stripe_equal;
reg             is_sub_h_end;
reg             is_w_end;
reg             is_w_end_ahead;
reg             is_winograd;
reg      [21:0] is_winograd_d1;
reg      [11:0] last_entries;
reg      [11:0] last_slices;
reg             layer_st;
reg             layer_st_d1;
reg             mon_batch_cnt_w;
reg             mon_c_bias_w;
reg             mon_dat_entry_avl_w;
reg       [1:0] mon_dat_entry_end_inc_wrap;
reg       [1:0] mon_dat_entry_st_inc_wrap;
reg             mon_dat_req_addr_wrap;
reg    [1023:0] mon_dat_rsp_l0_sft;
reg     [511:0] mon_dat_rsp_l1_sft;
reg     [767:0] mon_dat_rsp_l2_sft;
reg     [767:0] mon_dat_rsp_l3_sft;
reg             mon_dat_slice_avl_w;
reg             mon_data_bank_w;
reg             mon_datain_c_cnt_inc;
reg             mon_datain_h_cnt_inc;
reg             mon_datain_h_cur;
reg             mon_datain_w_cnt_inc;
reg             mon_datain_w_cur;
reg             mon_dataout_w_cnt_inc;
reg       [5:0] mon_entries_batch_w;
reg             mon_entries_single_w;
reg             mon_entries_w;
reg       [5:0] mon_h_bias_0_stride_w;
reg      [11:0] mon_h_bias_0_w;
reg      [11:0] mon_h_bias_1_stride_w;
reg       [4:0] mon_h_bias_1_w;
reg       [4:0] mon_h_bias_2_w;
reg       [1:0] mon_h_bias_3_w;
reg             mon_h_bias_d1;
reg             mon_pixel_w_cnt_w;
reg       [1:0] mon_pixel_x_init_w;
reg             mon_rls_slices_w;
reg             mon_rsp_sft_cnt_l0_w;
reg             mon_rsp_sft_cnt_l1_w;
reg             mon_rsp_sft_cnt_l2_w;
reg             mon_rsp_sft_cnt_l3_w;
reg      [11:0] mon_slice_entries_w;
reg       [1:0] mon_slice_left_w;
reg             mon_stripe_cnt_inc;
reg       [2:0] mon_sub_h_total_w;
reg      [15:0] pad_value;
reg             pixel_ch_ori_reg_en;
reg      [11:0] pixel_ch_stride;
reg      [11:0] pixel_ch_stride_w;
reg             pixel_force_clr_d1;
reg             pixel_force_fetch_d1;
reg             pixel_req_ch_odd;
reg             pixel_req_ch_odd_ori;
reg             pixel_req_ch_odd_w;
reg      [15:0] pixel_w_ch_ori;
reg      [15:0] pixel_w_cnt;
reg             pixel_w_cnt_reg_en;
reg      [15:0] pixel_w_cnt_w;
reg      [15:0] pixel_w_ori;
reg             pixel_w_ori_reg_en;
reg       [6:0] pixel_x_add;
reg       [7:0] pixel_x_add_w;
reg       [6:0] pixel_x_byte_stride;
reg       [6:0] pixel_x_byte_stride_w;
reg       [6:0] pixel_x_cnt_add;
reg       [5:0] pixel_x_init;
reg       [6:0] pixel_x_init_offset;
reg       [6:0] pixel_x_init_offset_w;
reg       [5:0] pixel_x_init_w;
reg             pixel_x_stride_odd;
reg       [5:0] pixel_x_stride_w;
reg       [7:0] pra_precision;
reg       [7:0] pra_truncate;
reg       [1:0] pra_truncate_w;
reg             reuse_rls;
reg      [11:0] rls_entries;
reg      [11:0] rls_slices;
reg      [11:0] rls_slices_w;
reg       [7:0] rsp_sft_cnt_l0;
reg             rsp_sft_cnt_l0_en;
reg       [7:0] rsp_sft_cnt_l0_inc;
reg       [7:0] rsp_sft_cnt_l0_ori;
reg             rsp_sft_cnt_l0_ori_en;
reg       [7:0] rsp_sft_cnt_l0_w;
reg       [7:0] rsp_sft_cnt_l1;
reg             rsp_sft_cnt_l1_en;
reg       [7:0] rsp_sft_cnt_l1_inc;
reg       [7:0] rsp_sft_cnt_l1_ori;
reg             rsp_sft_cnt_l1_ori_en;
reg       [7:0] rsp_sft_cnt_l1_w;
reg       [7:0] rsp_sft_cnt_l2;
reg             rsp_sft_cnt_l2_en;
reg       [7:0] rsp_sft_cnt_l2_inc;
reg       [7:0] rsp_sft_cnt_l2_ori;
reg             rsp_sft_cnt_l2_ori_en;
reg       [7:0] rsp_sft_cnt_l2_w;
reg       [7:0] rsp_sft_cnt_l3;
reg             rsp_sft_cnt_l3_en;
reg       [7:0] rsp_sft_cnt_l3_inc;
reg       [7:0] rsp_sft_cnt_l3_ori;
reg             rsp_sft_cnt_l3_ori_en;
reg       [7:0] rsp_sft_cnt_l3_w;
reg             rsp_sft_l1_sel_1;
reg             rsp_sft_l1_sel_2;
reg             rsp_sft_l1_sel_3;
reg             rsp_sft_l2_sel_1;
reg             rsp_sft_l2_sel_2;
reg             rsp_sft_l2_sel_3;
reg             rsp_sft_l3_sel_1;
reg             rsp_sft_l3_sel_2;
reg             rsp_sft_l3_sel_3;
reg      [11:0] sc2buf_dat_rd_addr;
reg             sc2buf_dat_rd_en;
reg             sc2buf_dat_rd_en_w;
reg      [11:0] sc2cdma_dat_entries;
reg      [11:0] sc2cdma_dat_entries_w;
reg      [11:0] sc2cdma_dat_slices;
reg      [11:0] sc2cdma_dat_slices_w;
reg             sc2cdma_dat_updt;
reg       [7:0] sc2mac_dat_a_data0;
reg       [7:0] sc2mac_dat_a_data1;
reg       [7:0] sc2mac_dat_a_data10;
reg       [7:0] sc2mac_dat_a_data100;
reg       [7:0] sc2mac_dat_a_data101;
reg       [7:0] sc2mac_dat_a_data102;
reg       [7:0] sc2mac_dat_a_data103;
reg       [7:0] sc2mac_dat_a_data104;
reg       [7:0] sc2mac_dat_a_data105;
reg       [7:0] sc2mac_dat_a_data106;
reg       [7:0] sc2mac_dat_a_data107;
reg       [7:0] sc2mac_dat_a_data108;
reg       [7:0] sc2mac_dat_a_data109;
reg       [7:0] sc2mac_dat_a_data11;
reg       [7:0] sc2mac_dat_a_data110;
reg       [7:0] sc2mac_dat_a_data111;
reg       [7:0] sc2mac_dat_a_data112;
reg       [7:0] sc2mac_dat_a_data113;
reg       [7:0] sc2mac_dat_a_data114;
reg       [7:0] sc2mac_dat_a_data115;
reg       [7:0] sc2mac_dat_a_data116;
reg       [7:0] sc2mac_dat_a_data117;
reg       [7:0] sc2mac_dat_a_data118;
reg       [7:0] sc2mac_dat_a_data119;
reg       [7:0] sc2mac_dat_a_data12;
reg       [7:0] sc2mac_dat_a_data120;
reg       [7:0] sc2mac_dat_a_data121;
reg       [7:0] sc2mac_dat_a_data122;
reg       [7:0] sc2mac_dat_a_data123;
reg       [7:0] sc2mac_dat_a_data124;
reg       [7:0] sc2mac_dat_a_data125;
reg       [7:0] sc2mac_dat_a_data126;
reg       [7:0] sc2mac_dat_a_data127;
reg       [7:0] sc2mac_dat_a_data13;
reg       [7:0] sc2mac_dat_a_data14;
reg       [7:0] sc2mac_dat_a_data15;
reg       [7:0] sc2mac_dat_a_data16;
reg       [7:0] sc2mac_dat_a_data17;
reg       [7:0] sc2mac_dat_a_data18;
reg       [7:0] sc2mac_dat_a_data19;
reg       [7:0] sc2mac_dat_a_data2;
reg       [7:0] sc2mac_dat_a_data20;
reg       [7:0] sc2mac_dat_a_data21;
reg       [7:0] sc2mac_dat_a_data22;
reg       [7:0] sc2mac_dat_a_data23;
reg       [7:0] sc2mac_dat_a_data24;
reg       [7:0] sc2mac_dat_a_data25;
reg       [7:0] sc2mac_dat_a_data26;
reg       [7:0] sc2mac_dat_a_data27;
reg       [7:0] sc2mac_dat_a_data28;
reg       [7:0] sc2mac_dat_a_data29;
reg       [7:0] sc2mac_dat_a_data3;
reg       [7:0] sc2mac_dat_a_data30;
reg       [7:0] sc2mac_dat_a_data31;
reg       [7:0] sc2mac_dat_a_data32;
reg       [7:0] sc2mac_dat_a_data33;
reg       [7:0] sc2mac_dat_a_data34;
reg       [7:0] sc2mac_dat_a_data35;
reg       [7:0] sc2mac_dat_a_data36;
reg       [7:0] sc2mac_dat_a_data37;
reg       [7:0] sc2mac_dat_a_data38;
reg       [7:0] sc2mac_dat_a_data39;
reg       [7:0] sc2mac_dat_a_data4;
reg       [7:0] sc2mac_dat_a_data40;
reg       [7:0] sc2mac_dat_a_data41;
reg       [7:0] sc2mac_dat_a_data42;
reg       [7:0] sc2mac_dat_a_data43;
reg       [7:0] sc2mac_dat_a_data44;
reg       [7:0] sc2mac_dat_a_data45;
reg       [7:0] sc2mac_dat_a_data46;
reg       [7:0] sc2mac_dat_a_data47;
reg       [7:0] sc2mac_dat_a_data48;
reg       [7:0] sc2mac_dat_a_data49;
reg       [7:0] sc2mac_dat_a_data5;
reg       [7:0] sc2mac_dat_a_data50;
reg       [7:0] sc2mac_dat_a_data51;
reg       [7:0] sc2mac_dat_a_data52;
reg       [7:0] sc2mac_dat_a_data53;
reg       [7:0] sc2mac_dat_a_data54;
reg       [7:0] sc2mac_dat_a_data55;
reg       [7:0] sc2mac_dat_a_data56;
reg       [7:0] sc2mac_dat_a_data57;
reg       [7:0] sc2mac_dat_a_data58;
reg       [7:0] sc2mac_dat_a_data59;
reg       [7:0] sc2mac_dat_a_data6;
reg       [7:0] sc2mac_dat_a_data60;
reg       [7:0] sc2mac_dat_a_data61;
reg       [7:0] sc2mac_dat_a_data62;
reg       [7:0] sc2mac_dat_a_data63;
reg       [7:0] sc2mac_dat_a_data64;
reg       [7:0] sc2mac_dat_a_data65;
reg       [7:0] sc2mac_dat_a_data66;
reg       [7:0] sc2mac_dat_a_data67;
reg       [7:0] sc2mac_dat_a_data68;
reg       [7:0] sc2mac_dat_a_data69;
reg       [7:0] sc2mac_dat_a_data7;
reg       [7:0] sc2mac_dat_a_data70;
reg       [7:0] sc2mac_dat_a_data71;
reg       [7:0] sc2mac_dat_a_data72;
reg       [7:0] sc2mac_dat_a_data73;
reg       [7:0] sc2mac_dat_a_data74;
reg       [7:0] sc2mac_dat_a_data75;
reg       [7:0] sc2mac_dat_a_data76;
reg       [7:0] sc2mac_dat_a_data77;
reg       [7:0] sc2mac_dat_a_data78;
reg       [7:0] sc2mac_dat_a_data79;
reg       [7:0] sc2mac_dat_a_data8;
reg       [7:0] sc2mac_dat_a_data80;
reg       [7:0] sc2mac_dat_a_data81;
reg       [7:0] sc2mac_dat_a_data82;
reg       [7:0] sc2mac_dat_a_data83;
reg       [7:0] sc2mac_dat_a_data84;
reg       [7:0] sc2mac_dat_a_data85;
reg       [7:0] sc2mac_dat_a_data86;
reg       [7:0] sc2mac_dat_a_data87;
reg       [7:0] sc2mac_dat_a_data88;
reg       [7:0] sc2mac_dat_a_data89;
reg       [7:0] sc2mac_dat_a_data9;
reg       [7:0] sc2mac_dat_a_data90;
reg       [7:0] sc2mac_dat_a_data91;
reg       [7:0] sc2mac_dat_a_data92;
reg       [7:0] sc2mac_dat_a_data93;
reg       [7:0] sc2mac_dat_a_data94;
reg       [7:0] sc2mac_dat_a_data95;
reg       [7:0] sc2mac_dat_a_data96;
reg       [7:0] sc2mac_dat_a_data97;
reg       [7:0] sc2mac_dat_a_data98;
reg       [7:0] sc2mac_dat_a_data99;
reg     [127:0] sc2mac_dat_a_mask;
reg       [8:0] sc2mac_dat_a_pd;
reg             sc2mac_dat_a_pvld;
reg       [7:0] sc2mac_dat_b_data0;
reg       [7:0] sc2mac_dat_b_data1;
reg       [7:0] sc2mac_dat_b_data10;
reg       [7:0] sc2mac_dat_b_data100;
reg       [7:0] sc2mac_dat_b_data101;
reg       [7:0] sc2mac_dat_b_data102;
reg       [7:0] sc2mac_dat_b_data103;
reg       [7:0] sc2mac_dat_b_data104;
reg       [7:0] sc2mac_dat_b_data105;
reg       [7:0] sc2mac_dat_b_data106;
reg       [7:0] sc2mac_dat_b_data107;
reg       [7:0] sc2mac_dat_b_data108;
reg       [7:0] sc2mac_dat_b_data109;
reg       [7:0] sc2mac_dat_b_data11;
reg       [7:0] sc2mac_dat_b_data110;
reg       [7:0] sc2mac_dat_b_data111;
reg       [7:0] sc2mac_dat_b_data112;
reg       [7:0] sc2mac_dat_b_data113;
reg       [7:0] sc2mac_dat_b_data114;
reg       [7:0] sc2mac_dat_b_data115;
reg       [7:0] sc2mac_dat_b_data116;
reg       [7:0] sc2mac_dat_b_data117;
reg       [7:0] sc2mac_dat_b_data118;
reg       [7:0] sc2mac_dat_b_data119;
reg       [7:0] sc2mac_dat_b_data12;
reg       [7:0] sc2mac_dat_b_data120;
reg       [7:0] sc2mac_dat_b_data121;
reg       [7:0] sc2mac_dat_b_data122;
reg       [7:0] sc2mac_dat_b_data123;
reg       [7:0] sc2mac_dat_b_data124;
reg       [7:0] sc2mac_dat_b_data125;
reg       [7:0] sc2mac_dat_b_data126;
reg       [7:0] sc2mac_dat_b_data127;
reg       [7:0] sc2mac_dat_b_data13;
reg       [7:0] sc2mac_dat_b_data14;
reg       [7:0] sc2mac_dat_b_data15;
reg       [7:0] sc2mac_dat_b_data16;
reg       [7:0] sc2mac_dat_b_data17;
reg       [7:0] sc2mac_dat_b_data18;
reg       [7:0] sc2mac_dat_b_data19;
reg       [7:0] sc2mac_dat_b_data2;
reg       [7:0] sc2mac_dat_b_data20;
reg       [7:0] sc2mac_dat_b_data21;
reg       [7:0] sc2mac_dat_b_data22;
reg       [7:0] sc2mac_dat_b_data23;
reg       [7:0] sc2mac_dat_b_data24;
reg       [7:0] sc2mac_dat_b_data25;
reg       [7:0] sc2mac_dat_b_data26;
reg       [7:0] sc2mac_dat_b_data27;
reg       [7:0] sc2mac_dat_b_data28;
reg       [7:0] sc2mac_dat_b_data29;
reg       [7:0] sc2mac_dat_b_data3;
reg       [7:0] sc2mac_dat_b_data30;
reg       [7:0] sc2mac_dat_b_data31;
reg       [7:0] sc2mac_dat_b_data32;
reg       [7:0] sc2mac_dat_b_data33;
reg       [7:0] sc2mac_dat_b_data34;
reg       [7:0] sc2mac_dat_b_data35;
reg       [7:0] sc2mac_dat_b_data36;
reg       [7:0] sc2mac_dat_b_data37;
reg       [7:0] sc2mac_dat_b_data38;
reg       [7:0] sc2mac_dat_b_data39;
reg       [7:0] sc2mac_dat_b_data4;
reg       [7:0] sc2mac_dat_b_data40;
reg       [7:0] sc2mac_dat_b_data41;
reg       [7:0] sc2mac_dat_b_data42;
reg       [7:0] sc2mac_dat_b_data43;
reg       [7:0] sc2mac_dat_b_data44;
reg       [7:0] sc2mac_dat_b_data45;
reg       [7:0] sc2mac_dat_b_data46;
reg       [7:0] sc2mac_dat_b_data47;
reg       [7:0] sc2mac_dat_b_data48;
reg       [7:0] sc2mac_dat_b_data49;
reg       [7:0] sc2mac_dat_b_data5;
reg       [7:0] sc2mac_dat_b_data50;
reg       [7:0] sc2mac_dat_b_data51;
reg       [7:0] sc2mac_dat_b_data52;
reg       [7:0] sc2mac_dat_b_data53;
reg       [7:0] sc2mac_dat_b_data54;
reg       [7:0] sc2mac_dat_b_data55;
reg       [7:0] sc2mac_dat_b_data56;
reg       [7:0] sc2mac_dat_b_data57;
reg       [7:0] sc2mac_dat_b_data58;
reg       [7:0] sc2mac_dat_b_data59;
reg       [7:0] sc2mac_dat_b_data6;
reg       [7:0] sc2mac_dat_b_data60;
reg       [7:0] sc2mac_dat_b_data61;
reg       [7:0] sc2mac_dat_b_data62;
reg       [7:0] sc2mac_dat_b_data63;
reg       [7:0] sc2mac_dat_b_data64;
reg       [7:0] sc2mac_dat_b_data65;
reg       [7:0] sc2mac_dat_b_data66;
reg       [7:0] sc2mac_dat_b_data67;
reg       [7:0] sc2mac_dat_b_data68;
reg       [7:0] sc2mac_dat_b_data69;
reg       [7:0] sc2mac_dat_b_data7;
reg       [7:0] sc2mac_dat_b_data70;
reg       [7:0] sc2mac_dat_b_data71;
reg       [7:0] sc2mac_dat_b_data72;
reg       [7:0] sc2mac_dat_b_data73;
reg       [7:0] sc2mac_dat_b_data74;
reg       [7:0] sc2mac_dat_b_data75;
reg       [7:0] sc2mac_dat_b_data76;
reg       [7:0] sc2mac_dat_b_data77;
reg       [7:0] sc2mac_dat_b_data78;
reg       [7:0] sc2mac_dat_b_data79;
reg       [7:0] sc2mac_dat_b_data8;
reg       [7:0] sc2mac_dat_b_data80;
reg       [7:0] sc2mac_dat_b_data81;
reg       [7:0] sc2mac_dat_b_data82;
reg       [7:0] sc2mac_dat_b_data83;
reg       [7:0] sc2mac_dat_b_data84;
reg       [7:0] sc2mac_dat_b_data85;
reg       [7:0] sc2mac_dat_b_data86;
reg       [7:0] sc2mac_dat_b_data87;
reg       [7:0] sc2mac_dat_b_data88;
reg       [7:0] sc2mac_dat_b_data89;
reg       [7:0] sc2mac_dat_b_data9;
reg       [7:0] sc2mac_dat_b_data90;
reg       [7:0] sc2mac_dat_b_data91;
reg       [7:0] sc2mac_dat_b_data92;
reg       [7:0] sc2mac_dat_b_data93;
reg       [7:0] sc2mac_dat_b_data94;
reg       [7:0] sc2mac_dat_b_data95;
reg       [7:0] sc2mac_dat_b_data96;
reg       [7:0] sc2mac_dat_b_data97;
reg       [7:0] sc2mac_dat_b_data98;
reg       [7:0] sc2mac_dat_b_data99;
reg     [127:0] sc2mac_dat_b_mask;
reg       [8:0] sc2mac_dat_b_pd;
reg             sc2mac_dat_b_pvld;
reg       [8:0] sc2mac_dat_pd_w;
reg             slcg_wg_en_d1;
reg             slcg_wg_en_d2;
reg             slcg_wg_en_d3;
reg      [11:0] slice_entries_w;
reg      [11:0] slice_left;
reg      [13:0] slice_left_w;
reg      [11:0] slices_oprand;
reg       [6:0] stripe_cnt;
reg       [6:0] stripe_cnt_inc;
reg             stripe_cnt_reg_en;
reg       [6:0] stripe_cnt_w;
reg       [2:0] sub_h_cmp_g0;
reg       [2:0] sub_h_cmp_g1;
reg       [2:0] sub_h_cmp_w;
reg       [1:0] sub_h_cnt;
reg       [2:0] sub_h_cnt_inc;
reg             sub_h_cnt_reg_en;
reg       [1:0] sub_h_cnt_w;
reg       [2:0] sub_h_total_g0;
reg       [2:0] sub_h_total_g1;
reg       [2:0] sub_h_total_g10;
reg       [2:0] sub_h_total_g11;
reg       [1:0] sub_h_total_g2;
reg       [2:0] sub_h_total_g3;
reg       [2:0] sub_h_total_g4;
reg       [2:0] sub_h_total_g5;
reg       [2:0] sub_h_total_g6;
reg       [2:0] sub_h_total_g7;
reg       [2:0] sub_h_total_g8;
reg       [2:0] sub_h_total_g9;
reg       [2:0] sub_h_total_w;
reg             sub_rls;
reg      [14:0] w_bias_16;
reg      [11:0] w_bias_d1;
reg      [14:0] w_bias_int8;
reg      [13:0] w_bias_w;
reg       [5:0] x_dilate;
reg       [5:0] x_dilate_w;
reg       [5:0] y_dilate;
reg       [5:0] y_dilate_w;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
/////////////////////////////////////////////////////////////////////////////////////////////
// Pipeline of Weight loader, for both compressed weight and uncompressed weight
//
//                      input_package
//                           |                     
//                      data request               
//                           |                     
//                      conv_buffer                
//                           |                     
//                      feature data---> data relase
//                        |     |                  
//                      REG    PRA                 
//                        |     |                  
//                        REGISTER                 
//                           |                     
//                          MAC                    
//
/////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////
///// status from sequence generator                     /////
//////////////////////////////////////////////////////////////
always @(
  sc_state
  ) begin
    is_sg_idle = (sc_state == 0 );
end

always @(
  sc_state
  ) begin
    is_sg_running = (sc_state == 2 );
end

always @(
  sc_state
  ) begin
    is_sg_done = (sc_state == 3 );
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    is_sg_running_d1 <= 1'b0;
  end else begin
  is_sg_running_d1 <= is_sg_running;
  end
end
//////////////////////////////////////////////////////////////
///// input signals from registers                       /////
//////////////////////////////////////////////////////////////

always @(
  reg2dp_op_en
  or is_sg_idle
  ) begin
    layer_st = reg2dp_op_en & is_sg_idle;
end

always @(
  reg2dp_datain_format
  ) begin
    is_pixel = (reg2dp_datain_format == 1'h1 );
end

always @(
  reg2dp_conv_mode
  ) begin
    is_winograd = (reg2dp_conv_mode == 1'h1 );
end

always @(
  reg2dp_conv_mode
  ) begin
    is_conv = (reg2dp_conv_mode == 1'h0 );
end

always @(
  is_conv
  or is_pixel
  ) begin
    is_img = is_conv & is_pixel;
end

always @(
  reg2dp_data_bank
  ) begin
    {mon_data_bank_w,
     data_bank_w} = reg2dp_data_bank + 1'b1;
end

always @(
  is_winograd
  or is_img
  or reg2dp_batches
  ) begin
    data_batch_w = (is_winograd | is_img) ? 6'b1 :
                   reg2dp_batches + 1'b1;
end

always @(
  is_winograd
  or is_img
  or reg2dp_batches
  ) begin
    batch_cmp_w = (is_winograd | is_img) ? 5'b0 : reg2dp_batches;
end

always @(
  reg2dp_proc_precision
  ) begin
    is_int8 = (reg2dp_proc_precision == 2'h0 );
end

always @(
  reg2dp_proc_precision
  ) begin
    is_fp16 = (reg2dp_proc_precision == 2'h2 );
end

always @(
  is_winograd
  or reg2dp_datain_width_ext
  ) begin
    datain_width_w = is_winograd ? ({2'b0, reg2dp_datain_width_ext[12:2]} + 1'b1) :
                     reg2dp_datain_width_ext + 1'b1;
end

always @(
  reg2dp_datain_width_ext
  ) begin
    datain_width_cmp_w = reg2dp_datain_width_ext;
end

always @(
  reg2dp_datain_height_ext
  ) begin
    datain_height_cmp_w = reg2dp_datain_height_ext;
end

always @(
  is_winograd
  or reg2dp_weight_channel_ext
  ) begin
    datain_channel_cmp_w = is_winograd ? reg2dp_weight_channel_ext[12:2] :
                           {4'b0, reg2dp_weight_channel_ext[12:6]};
end

always @(
  is_img
  or reg2dp_y_extension
  ) begin
    {sub_h_total_w,
     mon_sub_h_total_w} = is_img ? (6'h9 << reg2dp_y_extension) :
                          6'h8;
end

always @(
  is_img
  or sub_h_total_w
  or is_winograd
  ) begin
    sub_h_cmp_w = is_img ? sub_h_total_w :
                  is_winograd ? 3'h2 :
                  3'h1;
end

always @(
  sub_h_cmp_w
  ) begin
    dataout_w_init[12:0] = sub_h_cmp_w - 1'b1;
end

always @(
  is_winograd
  or reg2dp_conv_x_stride_ext
  ) begin
    conv_x_stride_w = (is_winograd) ? 4'b1 :
                      reg2dp_conv_x_stride_ext + 1'b1;
end

always @(
  reg2dp_datain_channel_ext
  or conv_x_stride_w
  ) begin
    pixel_x_stride_w = (reg2dp_datain_channel_ext[1:0] == 2'h3) ? {conv_x_stride_w, 2'b0} :
                       (reg2dp_datain_channel_ext[1:0] == 2'h2) ? ({conv_x_stride_w, 1'b0} + conv_x_stride_w) :
                       {2'b0, conv_x_stride_w};
end

always @(
  reg2dp_y_extension
  or pixel_x_stride_w
  or reg2dp_weight_channel_ext
  ) begin
    {mon_pixel_x_init_w,
     pixel_x_init_w} = (reg2dp_y_extension == 2'h2) ? ({pixel_x_stride_w, 1'b0} + pixel_x_stride_w + reg2dp_weight_channel_ext[5:0]) :
                       (reg2dp_y_extension == 2'h1) ? (pixel_x_stride_w + reg2dp_weight_channel_ext[5:0]):
                       (reg2dp_weight_channel_ext >= 13'h3f) ? 6'h3f :
                       (reg2dp_weight_channel_ext[5:0]);
end

always @(
  reg2dp_weight_channel_ext
  ) begin
    pixel_x_init_offset_w = (reg2dp_weight_channel_ext[5:0] + 1'b1);
end

always @(
  reg2dp_y_extension
  or pixel_x_stride_w
  ) begin
    pixel_x_add_w = (reg2dp_y_extension == 2'h2) ? {pixel_x_stride_w, 2'b0} :
                    (reg2dp_y_extension == 2'h1) ? {1'b0, pixel_x_stride_w, 1'b0} :
                    {2'b0, pixel_x_stride_w};
end

always @(
  is_int8
  or pixel_x_stride_w
  ) begin
    pixel_x_byte_stride_w = is_int8 ? {1'b0, pixel_x_stride_w} : {pixel_x_stride_w, 1'b0};
end

always @(
  pixel_x_stride_w
  ) begin
    pixel_ch_stride_w = {pixel_x_stride_w, 6'b0};
end

always @(
  is_winograd
  or reg2dp_conv_y_stride_ext
  ) begin
    conv_y_stride_w = (is_winograd) ? 4'b1 :
                      reg2dp_conv_y_stride_ext + 1'b1;
end

always @(
  is_winograd
  or is_img
  or reg2dp_x_dilation_ext
  ) begin
    x_dilate_w = (is_winograd | is_img) ? 6'b1 :
                 reg2dp_x_dilation_ext + 1'b1;
end

always @(
  is_winograd
  or is_img
  or reg2dp_y_dilation_ext
  ) begin
    y_dilate_w = (is_winograd | is_img) ? 6'b1 :
                 reg2dp_y_dilation_ext + 1'b1;
end

always @(
  reg2dp_entries
  ) begin
    {mon_entries_single_w,
     entries_single_w} = (reg2dp_entries + 1'b1);
end

always @(
  entries_single_w
  or data_batch_w
  ) begin
    {mon_entries_batch_w,
     entries_batch_w} = entries_single_w * data_batch_w;
end

always @(
  is_winograd
  or reg2dp_entries
  or entries_single_w
  ) begin
    {mon_entries_w,
     entries_w} = (is_winograd) ? ({reg2dp_entries[9:0], 2'b0} + 3'h4) :
                  entries_single_w;
end

always @(
  data_batch_w
  or y_dilate_w
  ) begin
    h_offset_slice_w = data_batch_w * y_dilate_w;
end

always @(
  entries
  or data_batch
  ) begin
    {mon_h_bias_0_stride_w,
     h_bias_0_stride_w} = entries * data_batch;
end

always @(
  entries
  or h_offset_slice
  ) begin
    {mon_h_bias_1_stride_w,
     h_bias_1_stride_w} = entries * h_offset_slice;
end

always @(
  reg2dp_rls_slices
  ) begin
    {mon_rls_slices_w,
     rls_slices_w} = reg2dp_rls_slices + 1'b1;
end

always @(
  reg2dp_skip_data_rls
  or reg2dp_datain_height_ext
  or reg2dp_rls_slices
  ) begin
    {mon_slice_left_w,
     slice_left_w} = reg2dp_skip_data_rls ? (reg2dp_datain_height_ext + 1'b1) :
                     reg2dp_datain_height_ext - reg2dp_rls_slices;
end

always @(
  layer_st_d1
  or rls_slices
  or slice_left
  ) begin
    slices_oprand = layer_st_d1 ? rls_slices :
                    slice_left;
end

always @(
  entries_batch
  or slices_oprand
  ) begin
    {mon_slice_entries_w,
     slice_entries_w} = entries_batch * slices_oprand;
end

always @(
  reg2dp_dataout_width
  ) begin
    dataout_width_cmp_w = reg2dp_dataout_width;
end

always @(
  reg2dp_pra_truncate
  ) begin
    pra_truncate_w = (reg2dp_pra_truncate == 2'h3) ? 2'h2 :
                     reg2dp_pra_truncate;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    layer_st_d1 <= 1'b0;
  end else begin
  layer_st_d1 <= layer_st;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    is_winograd_d1 <= {22{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    is_winograd_d1 <= {22{is_winograd}};
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    is_winograd_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    is_img_d1 <= {34{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    is_img_d1 <= {34{is_img}};
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    is_img_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    is_int8_d1 <= {23{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    is_int8_d1 <= {23{is_int8}};
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    is_int8_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    is_fp16_d1 <= {2{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    is_fp16_d1 <= {2{is_fp16}};
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    is_fp16_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    data_bank <= {4{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    data_bank <= data_bank_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    data_bank <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    datain_width <= {14{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    datain_width <= datain_width_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    datain_width <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    datain_width_cmp <= {13{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    datain_width_cmp <= datain_width_cmp_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    datain_width_cmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    datain_height_cmp <= {13{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    datain_height_cmp <= datain_height_cmp_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    datain_height_cmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    datain_channel_cmp <= {11{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    datain_channel_cmp <= datain_channel_cmp_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    datain_channel_cmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sub_h_total_g0 <= 3'h1;
  end else begin
  if ((layer_st) == 1'b1) begin
    sub_h_total_g0 <= sub_h_total_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    sub_h_total_g0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sub_h_total_g1 <= 3'h1;
  end else begin
  if ((layer_st) == 1'b1) begin
    sub_h_total_g1 <= sub_h_total_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    sub_h_total_g1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sub_h_total_g2 <= 2'h1;
  end else begin
  if ((layer_st) == 1'b1) begin
    sub_h_total_g2 <= sub_h_total_w[2:1];
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    sub_h_total_g2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sub_h_total_g3 <= 3'h1;
  end else begin
  if ((layer_st) == 1'b1) begin
    sub_h_total_g3 <= sub_h_total_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    sub_h_total_g3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sub_h_total_g4 <= 3'h1;
  end else begin
  if ((layer_st) == 1'b1) begin
    sub_h_total_g4 <= sub_h_total_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    sub_h_total_g4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sub_h_total_g5 <= 3'h1;
  end else begin
  if ((layer_st) == 1'b1) begin
    sub_h_total_g5 <= sub_h_total_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    sub_h_total_g5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sub_h_total_g6 <= 3'h1;
  end else begin
  if ((layer_st) == 1'b1) begin
    sub_h_total_g6 <= sub_h_total_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    sub_h_total_g6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sub_h_total_g7 <= 3'h1;
  end else begin
  if ((layer_st) == 1'b1) begin
    sub_h_total_g7 <= sub_h_total_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    sub_h_total_g7 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sub_h_total_g8 <= 3'h1;
  end else begin
  if ((layer_st) == 1'b1) begin
    sub_h_total_g8 <= sub_h_total_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    sub_h_total_g8 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sub_h_total_g9 <= 3'h1;
  end else begin
  if ((layer_st) == 1'b1) begin
    sub_h_total_g9 <= sub_h_total_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    sub_h_total_g9 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sub_h_total_g10 <= 3'h1;
  end else begin
  if ((layer_st) == 1'b1) begin
    sub_h_total_g10 <= sub_h_total_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    sub_h_total_g10 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sub_h_total_g11 <= 3'h1;
  end else begin
  if ((layer_st) == 1'b1) begin
    sub_h_total_g11 <= sub_h_total_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    sub_h_total_g11 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sub_h_cmp_g0 <= 3'h1;
  end else begin
  if ((layer_st) == 1'b1) begin
    sub_h_cmp_g0 <= sub_h_cmp_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    sub_h_cmp_g0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_22x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sub_h_cmp_g1 <= 3'h1;
  end else begin
  if ((layer_st) == 1'b1) begin
    sub_h_cmp_g1 <= sub_h_cmp_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    sub_h_cmp_g1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_23x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    conv_x_stride <= {4{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    conv_x_stride <= conv_x_stride_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    conv_x_stride <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_24x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    conv_y_stride <= {4{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    conv_y_stride <= conv_y_stride_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    conv_y_stride <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_25x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pixel_x_stride_odd <= 1'b0;
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_x_stride_odd <= pixel_x_stride_w[0];
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_x_stride_odd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_26x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    data_batch <= {6{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    data_batch <= data_batch_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    data_batch <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_27x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    batch_cmp <= {5{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    batch_cmp <= batch_cmp_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    batch_cmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_28x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pixel_x_init <= {6{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_x_init <= pixel_x_init_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_x_init <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_29x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pixel_x_init_offset <= {7{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_x_init_offset <= pixel_x_init_offset_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_x_init_offset <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_30x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pixel_x_add <= {7{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_x_add <= pixel_x_add_w[6:0];
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_x_add <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_31x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pixel_x_byte_stride <= {7{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_x_byte_stride <= pixel_x_byte_stride_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_x_byte_stride <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_32x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pixel_ch_stride <= {12{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    pixel_ch_stride <= pixel_ch_stride_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pixel_ch_stride <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_33x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    x_dilate <= {6{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    x_dilate <= x_dilate_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    x_dilate <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_34x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    y_dilate <= {6{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    y_dilate <= y_dilate_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    y_dilate <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_35x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pad_value <= {16{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    pad_value <= reg2dp_pad_value;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pad_value <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_36x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    entries <= {12{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    entries <= entries_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    entries <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_37x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    entries_batch <= {12{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    entries_batch <= entries_batch_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    entries_batch <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_38x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    entries_cmp <= {12{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    entries_cmp <= reg2dp_entries;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    entries_cmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_39x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    h_offset_slice <= {12{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    h_offset_slice <= h_offset_slice_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    h_offset_slice <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_40x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    h_bias_0_stride <= {12{1'b0}};
  end else begin
  if ((layer_st_d1) == 1'b1) begin
    h_bias_0_stride <= h_bias_0_stride_w;
  // VCS coverage off
  end else if ((layer_st_d1) == 1'b0) begin
  end else begin
    h_bias_0_stride <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_41x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    h_bias_1_stride <= {12{1'b0}};
  end else begin
  if ((layer_st_d1) == 1'b1) begin
    h_bias_1_stride <= h_bias_1_stride_w;
  // VCS coverage off
  end else if ((layer_st_d1) == 1'b0) begin
  end else begin
    h_bias_1_stride <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_42x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    h_bias_2_stride <= {12{1'b0}};
  end else begin
  if ((layer_st_d1) == 1'b1) begin
    h_bias_2_stride <= entries;
  // VCS coverage off
  end else if ((layer_st_d1) == 1'b0) begin
  end else begin
    h_bias_2_stride <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_43x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    h_bias_3_stride <= {12{1'b0}};
  end else begin
  if ((layer_st_d1) == 1'b1) begin
    h_bias_3_stride <= entries;
  // VCS coverage off
  end else if ((layer_st_d1) == 1'b0) begin
  end else begin
    h_bias_3_stride <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_44x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rls_slices <= {12{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    rls_slices <= rls_slices_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    rls_slices <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_45x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rls_entries <= {12{1'b0}};
  end else begin
  if ((layer_st_d1) == 1'b1) begin
    rls_entries <= slice_entries_w;
  // VCS coverage off
  end else if ((layer_st_d1) == 1'b0) begin
  end else begin
    rls_entries <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_46x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slice_left <= {12{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    slice_left <= slice_left_w[12 -1:0];
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    slice_left <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_47x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_slices <= {12{1'b0}};
  end else begin
  if ((is_sg_done) == 1'b1) begin
    last_slices <= slice_left;
  // VCS coverage off
  end else if ((is_sg_done) == 1'b0) begin
  end else begin
    last_slices <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_48x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_sg_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    last_entries <= {12{1'b0}};
  end else begin
  if ((is_sg_done) == 1'b1) begin
    last_entries <= slice_entries_w;
  // VCS coverage off
  end else if ((is_sg_done) == 1'b0) begin
  end else begin
    last_entries <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_49x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_sg_done))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dataout_width_cmp <= {13{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    dataout_width_cmp <= dataout_width_cmp_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    dataout_width_cmp <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_50x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pra_truncate <= {8{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    pra_truncate <= {4{pra_truncate_w}};
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pra_truncate <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_51x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pra_precision <= {8{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    pra_precision <= {4{reg2dp_proc_precision}};
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    pra_precision <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_52x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! Receive package when SG is not running")      zzz_assert_never_53x (nvdla_core_clk, `ASSERT_RESET, (~is_sg_running & sg2dl_pvld)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! SG is not idle when op_en is not set")      zzz_assert_never_54x (nvdla_core_clk, `ASSERT_RESET, (~is_sg_idle & ~reg2dp_op_en)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! data bank oveflow")      zzz_assert_never_55x (nvdla_core_clk, `ASSERT_RESET, (layer_st & mon_data_bank_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! entries oveflow")      zzz_assert_never_56x (nvdla_core_clk, `ASSERT_RESET, (layer_st & mon_entries_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! entries single oveflow")      zzz_assert_never_57x (nvdla_core_clk, `ASSERT_RESET, (layer_st & mon_entries_single_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! entries batch oveflow")      zzz_assert_never_58x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (|mon_entries_batch_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! entries is out of range")      zzz_assert_never_59x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (entries_w > 3840))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! pixel_x_init_w is overflow!")      zzz_assert_never_60x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (|mon_pixel_x_init_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! h_offset_slice_w is out of range!")      zzz_assert_never_61x (nvdla_core_clk, `ASSERT_RESET, (layer_st & (h_offset_slice_w > 3840) & (|reg2dp_datain_height_ext))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! h_bias_0_stride_w is overflow!")      zzz_assert_never_62x (nvdla_core_clk, `ASSERT_RESET, (layer_st_d1 & (|mon_h_bias_0_stride_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! h_bias_0_stride_w is out of range!")      zzz_assert_never_63x (nvdla_core_clk, `ASSERT_RESET, (layer_st_d1 & (h_bias_0_stride_w > 3840))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! rls_slices_w_w is overflow!")      zzz_assert_never_64x (nvdla_core_clk, `ASSERT_RESET, (layer_st & mon_rls_slices_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! rls_slices is out of range!")      zzz_assert_never_65x (nvdla_core_clk, `ASSERT_RESET, (rls_slices > 3840)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! rls_entries is out of range!")      zzz_assert_never_66x (nvdla_core_clk, `ASSERT_RESET, (rls_entries > 3840)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! last_entries is out of range!")      zzz_assert_never_67x (nvdla_core_clk, `ASSERT_RESET, (last_entries > 3840)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! dataout_w_init is out of range!")      zzz_assert_never_68x (nvdla_core_clk, `ASSERT_RESET, (layer_st_d1 & (dataout_w_init > 3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Config error! slice_left_w is overflow!")      zzz_assert_never_69x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & (|mon_slice_left_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Config error! data input width is invalid when winograd!")      zzz_assert_never_70x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & is_winograd & (reg2dp_datain_width_ext[1:0] != 2'h3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Config error! data input height is invalid when winograd!")      zzz_assert_never_71x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & is_winograd & (reg2dp_datain_height_ext[1:0] != 2'h3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Config error! reg2dp_y_extension set when not IMG!")      zzz_assert_never_72x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & ~is_img & ~is_winograd & (|reg2dp_y_extension))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Config error! reg2dp_y_extension is too big for stride when IMG!")      zzz_assert_never_73x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & is_img & (pixel_x_add_w > 8'h40) & (|reg2dp_y_extension))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Config error! convolution stride is not one when winograd or deconv!")      zzz_assert_never_74x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & (is_winograd) & ((|reg2dp_conv_x_stride_ext) | (|reg2dp_conv_y_stride_ext)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Config error! dilation is not one when winograd or img or deconv!")      zzz_assert_never_75x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & (is_img | is_winograd) & ((|reg2dp_x_dilation_ext) | (|reg2dp_y_dilation_ext)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Config error! batch is not one when winograd or img!")      zzz_assert_never_76x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & (is_img | is_winograd) & (|reg2dp_batches))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Config error! channel is not 4 when winograd!")      zzz_assert_never_77x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & is_winograd & (reg2dp_datain_channel_ext[1:0] != 2'h3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Config error! reg2dp_entries is out of range in winograd mode!")      zzz_assert_never_78x (nvdla_core_clk, `ASSERT_RESET, (layer_st & is_winograd & (|reg2dp_entries[11:10]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Config error! rls_slices is not divisible by 4 in winograd mode!")      zzz_assert_never_79x (nvdla_core_clk, `ASSERT_RESET, (layer_st & is_winograd & ~reg2dp_skip_data_rls & (reg2dp_rls_slices[1:0] != 2'h3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////////////////////////////////////////////////////
//  SLCG control signal                                               //
////////////////////////////////////////////////////////////////////////
assign slcg_wg_en_w = reg2dp_op_en & is_winograd;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_wg_en_d1 <= 1'b0;
  end else begin
  slcg_wg_en_d1 <= slcg_wg_en_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_wg_en_d2 <= 1'b0;
  end else begin
  slcg_wg_en_d2 <= slcg_wg_en_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    slcg_wg_en_d3 <= 1'b0;
  end else begin
  slcg_wg_en_d3 <= slcg_wg_en_d2;
  end
end

assign slcg_wg_en = slcg_wg_en_d3;

//////////////////////////////////////////////////////////////
///// cbuf status management                             /////
//////////////////////////////////////////////////////////////
//================  Non-SLCG clock domain ================//


always @(
  sc2cdma_dat_pending_req
  ) begin
    cbuf_reset = sc2cdma_dat_pending_req;
end

always @(
  is_sg_running
  or is_sg_running_d1
  ) begin
    is_running_first = is_sg_running & ~is_sg_running_d1;
end


//////////////////////////////////// calculate avaliable dat slices ////////////////////////////////////
always @(
  cdma2sc_dat_updt
  or cdma2sc_dat_slices
  ) begin
    dat_slice_avl_add = cdma2sc_dat_updt ? cdma2sc_dat_slices : 12'b0;
end

always @(
  dat_rls
  or sc2cdma_dat_slices_w
  ) begin
    dat_slice_avl_sub = dat_rls ? sc2cdma_dat_slices_w : 12'b0;
end

always @(
  cbuf_reset
  or dat_slice_avl
  or dat_slice_avl_add
  or dat_slice_avl_sub
  ) begin
    {mon_dat_slice_avl_w,
     dat_slice_avl_w} = (cbuf_reset) ? 13'b0 :
                        dat_slice_avl + dat_slice_avl_add - dat_slice_avl_sub;
end

//////////////////////////////////// calculate avaliable dat entries ////////////////////////////////////
always @(
  cdma2sc_dat_updt
  or cdma2sc_dat_entries
  ) begin
    dat_entry_avl_add = cdma2sc_dat_updt ? cdma2sc_dat_entries : 12'b0;
end

always @(
  dat_rls
  or sc2cdma_dat_entries_w
  ) begin
    dat_entry_avl_sub = dat_rls ? sc2cdma_dat_entries_w : 12'b0;
end

always @(
  cbuf_reset
  or dat_entry_avl
  or dat_entry_avl_add
  or dat_entry_avl_sub
  ) begin
    {mon_dat_entry_avl_w,
     dat_entry_avl_w} = (cbuf_reset) ? 13'b0 :
                        dat_entry_avl + dat_entry_avl_add - dat_entry_avl_sub;
end

//////////////////////////////////// calculate data entries start offset ////////////////////////////////////
always @(
  dat_entry_st
  or dat_entry_avl_sub
  ) begin
    dat_entry_st_inc = dat_entry_st + dat_entry_avl_sub;
end

always @(
  dat_entry_st_inc
  or data_bank
  ) begin
    {mon_dat_entry_st_inc_wrap[1:0],
     dat_entry_st_inc_wrap} = dat_entry_st_inc - {data_bank, 8'b0};
end

always @(
  dat_entry_st_inc
  or data_bank
  ) begin
    is_dat_entry_st_wrap = (dat_entry_st_inc >= {1'b0, data_bank, 8'b0});
end

always @(
  cbuf_reset
  or is_dat_entry_st_wrap
  or dat_entry_st_inc_wrap
  or dat_entry_st_inc
  ) begin
    dat_entry_st_w = (cbuf_reset) ? 12'b0 :
                     is_dat_entry_st_wrap ? dat_entry_st_inc_wrap :
                     dat_entry_st_inc[12 -1:0];
end

//////////////////////////////////// calculate data entries end offset ////////////////////////////////////
always @(
  dat_entry_end
  or dat_entry_avl_add
  ) begin
    dat_entry_end_inc = dat_entry_end + dat_entry_avl_add;
end

always @(
  dat_entry_end_inc
  or data_bank
  ) begin
    {mon_dat_entry_end_inc_wrap[1:0],
     dat_entry_end_inc_wrap} = dat_entry_end_inc - {data_bank, 8'b0};
end

always @(
  dat_entry_end_inc
  or data_bank
  ) begin
    is_dat_entry_end_wrap = (dat_entry_end_inc >= {1'b0, data_bank, 8'b0});
end

always @(
  cbuf_reset
  or is_dat_entry_end_wrap
  or dat_entry_end_inc_wrap
  or dat_entry_end_inc
  ) begin
    dat_entry_end_w = (cbuf_reset) ? 12'b0 :
                      is_dat_entry_end_wrap ? dat_entry_end_inc_wrap :
                      dat_entry_end_inc[12 -1:0];
end

//////////////////////////////////// registers and assertions ////////////////////////////////////
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_slice_avl <= {12{1'b0}};
  end else begin
  if ((cdma2sc_dat_updt | dat_rls | cbuf_reset) == 1'b1) begin
    dat_slice_avl <= dat_slice_avl_w;
  // VCS coverage off
  end else if ((cdma2sc_dat_updt | dat_rls | cbuf_reset) == 1'b0) begin
  end else begin
    dat_slice_avl <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_80x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(cdma2sc_dat_updt | dat_rls | cbuf_reset))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_entry_avl <= {12{1'b0}};
  end else begin
  if ((cdma2sc_dat_updt | dat_rls | cbuf_reset) == 1'b1) begin
    dat_entry_avl <= dat_entry_avl_w;
  // VCS coverage off
  end else if ((cdma2sc_dat_updt | dat_rls | cbuf_reset) == 1'b0) begin
  end else begin
    dat_entry_avl <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_81x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(cdma2sc_dat_updt | dat_rls | cbuf_reset))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_entry_st <= {12{1'b0}};
  end else begin
  if ((cbuf_reset | dat_rls) == 1'b1) begin
    dat_entry_st <= dat_entry_st_w;
  // VCS coverage off
  end else if ((cbuf_reset | dat_rls) == 1'b0) begin
  end else begin
    dat_entry_st <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_82x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(cbuf_reset | dat_rls))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_entry_end <= {12{1'b0}};
  end else begin
  if ((cbuf_reset | cdma2sc_dat_updt) == 1'b1) begin
    dat_entry_end <= dat_entry_end_w;
  // VCS coverage off
  end else if ((cbuf_reset | cdma2sc_dat_updt) == 1'b0) begin
  end else begin
    dat_entry_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_83x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(cbuf_reset | cdma2sc_dat_updt))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! dat_slice_avl overflow")      zzz_assert_never_84x (nvdla_core_ng_clk, `ASSERT_RESET, (mon_dat_slice_avl_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! dat_slice_avl is out of range")      zzz_assert_never_85x (nvdla_core_ng_clk, `ASSERT_RESET, (dat_slice_avl_w > 3840)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! dat_entry_avl_w overflow")      zzz_assert_never_86x (nvdla_core_ng_clk, `ASSERT_RESET, (mon_dat_entry_avl_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! dat_entry_avl_w is out of range")      zzz_assert_never_87x (nvdla_core_ng_clk, `ASSERT_RESET, (dat_entry_avl_w > 3840)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! slice and data entries are not match")      zzz_assert_never_88x (nvdla_core_ng_clk, `ASSERT_RESET, (((|dat_slice_avl) ^ (|dat_entry_avl)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! data entries and address are not match - empty")      zzz_assert_never_89x (nvdla_core_ng_clk, `ASSERT_RESET, (~(|dat_entry_avl) & (dat_entry_st != dat_entry_end) & ~cbuf_reset)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! data entries and address are not match - full")      zzz_assert_never_90x (nvdla_core_ng_clk, `ASSERT_RESET, ((dat_entry_avl == {data_bank, 8'b0}) & (dat_entry_st != dat_entry_end) & ~cbuf_reset)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! data input update with zero slices")      zzz_assert_never_91x (nvdla_core_ng_clk, `ASSERT_RESET, (cdma2sc_dat_updt & ~(|cdma2sc_dat_slices))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! data input update with zero data entries")      zzz_assert_never_92x (nvdla_core_ng_clk, `ASSERT_RESET, (cdma2sc_dat_updt & ~(|cdma2sc_dat_entries))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//================  Non-SLCG clock domain end ================//

//////////////////////////////////////////////////////////////
///// cbuf status update                                 /////
//////////////////////////////////////////////////////////////
always @(
  dat_rsp_pvld
  or dat_rsp_rls
  ) begin
    sub_rls = (dat_rsp_pvld & dat_rsp_rls);
end

always @(
  sg2dl_reuse_rls
  ) begin
    reuse_rls = sg2dl_reuse_rls;
end

always @(
  reuse_rls
  or last_slices
  or sub_rls
  or rls_slices
  ) begin
    dat_rls = (reuse_rls & (|last_slices)) | (sub_rls & (|rls_slices));
end

always @(
  sub_rls
  or rls_slices
  or last_slices
  ) begin
    sc2cdma_dat_slices_w = sub_rls ? rls_slices :
                           last_slices;
end

always @(
  sub_rls
  or rls_entries
  or last_entries
  ) begin
    sc2cdma_dat_entries_w = sub_rls ? rls_entries :
                            last_entries;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2cdma_dat_updt <= 1'b0;
  end else begin
  sc2cdma_dat_updt <= dat_rls;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2cdma_dat_slices <= {12{1'b0}};
  end else begin
  if ((dat_rls) == 1'b1) begin
    sc2cdma_dat_slices <= sc2cdma_dat_slices_w;
  // VCS coverage off
  end else if ((dat_rls) == 1'b0) begin
  end else begin
    sc2cdma_dat_slices <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_93x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rls))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2cdma_dat_entries <= {12{1'b0}};
  end else begin
  if ((dat_rls) == 1'b1) begin
    sc2cdma_dat_entries <= sc2cdma_dat_entries_w;
  // VCS coverage off
  end else if ((dat_rls) == 1'b0) begin
  end else begin
    sc2cdma_dat_entries <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_94x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rls))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_zero_one_hot #(0,2,0,"Error! data release reason conflict")      zzz_assert_zero_one_hot_95x (nvdla_core_clk, `ASSERT_RESET, ({reuse_rls, sub_rls})); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! Data output update with zero kernels")      zzz_assert_never_96x (nvdla_core_clk, `ASSERT_RESET, (sc2cdma_dat_updt & ~(|sc2cdma_dat_slices))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! Data output update with zero weight entries")      zzz_assert_never_97x (nvdla_core_clk, `ASSERT_RESET, (sc2cdma_dat_updt & ~(|sc2cdma_dat_entries))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! Avaliable slices and avaliable entries are not match!")      zzz_assert_never_98x (nvdla_core_clk, `ASSERT_RESET, ((|dat_slice_avl) ^ (|dat_entry_avl))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////////////////////////////////
///// input data package                                 /////
//////////////////////////////////////////////////////////////
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
  nv_assert_never #(0,0,"Error! Get data package at the 1st cycle of running")      zzz_assert_never_99x (nvdla_core_clk, `ASSERT_RESET, (sg2dl_pvld & is_running_first)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! Get data package when sg is not running")      zzz_assert_never_100x (nvdla_core_clk, `ASSERT_RESET, (sg2dl_pvld & ~is_sg_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////////////////////////////////
///// generate data read sequence                        /////
//////////////////////////////////////////////////////////////
assign dl_in_pvld_d0 = sg2dl_pvld;
assign dl_in_pd_d0 = sg2dl_pd;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_in_pvld_d1 <= 1'b0;
  end else begin
  dl_in_pvld_d1 <= dl_in_pvld_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_in_pd_d1 <= {31{1'b0}};
  end else begin
  if ((dl_in_pvld_d0) == 1'b1) begin
    dl_in_pd_d1 <= dl_in_pd_d0;
  // VCS coverage off
  end else if ((dl_in_pvld_d0) == 1'b0) begin
  end else begin
    dl_in_pd_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_101x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dl_in_pvld_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_in_pvld_d2 <= 1'b0;
  end else begin
  dl_in_pvld_d2 <= dl_in_pvld_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_in_pd_d2 <= {31{1'b0}};
  end else begin
  if ((dl_in_pvld_d1) == 1'b1) begin
    dl_in_pd_d2 <= dl_in_pd_d1;
  // VCS coverage off
  end else if ((dl_in_pvld_d1) == 1'b0) begin
  end else begin
    dl_in_pd_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_102x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dl_in_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_in_pvld_d3 <= 1'b0;
  end else begin
  dl_in_pvld_d3 <= dl_in_pvld_d2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_in_pd_d3 <= {31{1'b0}};
  end else begin
  if ((dl_in_pvld_d2) == 1'b1) begin
    dl_in_pd_d3 <= dl_in_pd_d2;
  // VCS coverage off
  end else if ((dl_in_pvld_d2) == 1'b0) begin
  end else begin
    dl_in_pd_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_103x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dl_in_pvld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_in_pvld_d4 <= 1'b0;
  end else begin
  dl_in_pvld_d4 <= dl_in_pvld_d3;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_in_pd_d4 <= {31{1'b0}};
  end else begin
  if ((dl_in_pvld_d3) == 1'b1) begin
    dl_in_pd_d4 <= dl_in_pd_d3;
  // VCS coverage off
  end else if ((dl_in_pvld_d3) == 1'b0) begin
  end else begin
    dl_in_pd_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_104x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dl_in_pvld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_in_pvld_d5 <= 1'b0;
  end else begin
  dl_in_pvld_d5 <= dl_in_pvld_d4;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_in_pd_d5 <= {31{1'b0}};
  end else begin
  if ((dl_in_pvld_d4) == 1'b1) begin
    dl_in_pd_d5 <= dl_in_pd_d4;
  // VCS coverage off
  end else if ((dl_in_pvld_d4) == 1'b0) begin
  end else begin
    dl_in_pd_d5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_105x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dl_in_pvld_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign dl_in_pvld = (is_winograd_d1[0]) ? dl_in_pvld_d0 : dl_in_pvld_d5;
assign dl_in_pd = (is_winograd_d1[1]) ? dl_in_pd_d0 : dl_in_pd_d5;


assign dl_pvld_d0 = dl_in_pvld;
assign dl_pd_d0 = dl_in_pd;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_pvld_d1 <= 1'b0;
  end else begin
  dl_pvld_d1 <= dl_pvld_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_pd_d1 <= {31{1'b0}};
  end else begin
  if ((dl_pvld_d0) == 1'b1) begin
    dl_pd_d1 <= dl_pd_d0;
  // VCS coverage off
  end else if ((dl_pvld_d0) == 1'b0) begin
  end else begin
    dl_pd_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_106x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dl_pvld_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_pvld_d2 <= 1'b0;
  end else begin
  dl_pvld_d2 <= dl_pvld_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_pd_d2 <= {31{1'b0}};
  end else begin
  if ((dl_pvld_d1) == 1'b1) begin
    dl_pd_d2 <= dl_pd_d1;
  // VCS coverage off
  end else if ((dl_pvld_d1) == 1'b0) begin
  end else begin
    dl_pd_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_107x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dl_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_pvld_d3 <= 1'b0;
  end else begin
  dl_pvld_d3 <= dl_pvld_d2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_pd_d3 <= {31{1'b0}};
  end else begin
  if ((dl_pvld_d2) == 1'b1) begin
    dl_pd_d3 <= dl_pd_d2;
  // VCS coverage off
  end else if ((dl_pvld_d2) == 1'b0) begin
  end else begin
    dl_pd_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_108x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dl_pvld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_pvld_d4 <= 1'b0;
  end else begin
  dl_pvld_d4 <= dl_pvld_d3;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_pd_d4 <= {31{1'b0}};
  end else begin
  if ((dl_pvld_d3) == 1'b1) begin
    dl_pd_d4 <= dl_pd_d3;
  // VCS coverage off
  end else if ((dl_pvld_d3) == 1'b0) begin
  end else begin
    dl_pd_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_109x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dl_pvld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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


always @(
  sub_h_total_g0
  or dl_pvld_d1
  or dl_pvld_d3
  or dl_pvld_d4
  ) begin
    dl_pvld = (sub_h_total_g0[2] & dl_pvld_d1) |
              (sub_h_total_g0[1] & dl_pvld_d3) |
              (sub_h_total_g0[0] & dl_pvld_d4);
end

always @(
  sub_h_total_g1
  or dl_pd_d1
  or dl_pd_d3
  or dl_pd_d4
  ) begin
    dl_pd = ({31 {sub_h_total_g1[2]}} & dl_pd_d1) |
            ({31 {sub_h_total_g1[1]}} & dl_pd_d3) |
            ({31 {sub_h_total_g1[0]}} & dl_pd_d4);
end


// PKT_UNPACK_WIRE( csc_dat_pkg ,  dl_ ,  dl_pd )
assign        dl_w_offset[4:0] =     dl_pd[4:0];
assign        dl_h_offset[4:0] =     dl_pd[9:5];
assign        dl_channel_size[6:0] =     dl_pd[16:10];
assign        dl_stripe_length[6:0] =     dl_pd[23:17];
assign        dl_cur_sub_h[1:0] =     dl_pd[25:24];
assign         dl_block_end  =     dl_pd[26];
assign         dl_channel_end  =     dl_pd[27];
assign         dl_group_end  =     dl_pd[28];
assign         dl_layer_end  =     dl_pd[29];
assign         dl_dat_release  =     dl_pd[30];

////////////////////////// batch up counter //////////////////////////

always @(
  layer_st
  or is_batch_end
  or batch_cnt
  ) begin
    {mon_batch_cnt_w,
     batch_cnt_w} = layer_st ? 6'b0 :
                    is_batch_end ? 6'b0 :
                    batch_cnt + 1'b1;
end

always @(
  batch_cnt
  or batch_cmp
  ) begin
    is_batch_end = (batch_cnt == batch_cmp);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    batch_cnt <= {5{1'b0}};
  end else begin
  if ((layer_st | dat_exec_valid) == 1'b1) begin
    batch_cnt <= batch_cnt_w;
  // VCS coverage off
  end else if ((layer_st | dat_exec_valid) == 1'b0) begin
  end else begin
    batch_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_110x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | dat_exec_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! batch_cnt is not zero when idle")      zzz_assert_never_111x (nvdla_core_clk, `ASSERT_RESET, (~reg2dp_op_en & |(batch_cnt))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! batch_cnt_w overflow!")      zzz_assert_never_112x (nvdla_core_clk, `ASSERT_RESET, (mon_batch_cnt_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////// sub height up counter //////////////////////////

always @(
  sub_h_cnt
  ) begin
    sub_h_cnt_inc = sub_h_cnt + 1'b1;
end

always @(
  layer_st
  or is_sub_h_end
  or sub_h_cnt_inc
  ) begin
    sub_h_cnt_w = (layer_st | is_sub_h_end) ? 2'b0 :
                  sub_h_cnt_inc[1:0];
end

always @(
  sub_h_cnt_inc
  or sub_h_cmp_g0
  ) begin
    is_sub_h_end = (sub_h_cnt_inc == sub_h_cmp_g0);
end

always @(
  layer_st
  or is_winograd_d1
  or reg2dp_y_extension
  or dat_exec_valid
  ) begin
    sub_h_cnt_reg_en = layer_st | ((is_winograd_d1[2] | (|reg2dp_y_extension)) & dat_exec_valid);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sub_h_cnt <= {2{1'b0}};
  end else begin
  if ((sub_h_cnt_reg_en) == 1'b1) begin
    sub_h_cnt <= sub_h_cnt_w;
  // VCS coverage off
  end else if ((sub_h_cnt_reg_en) == 1'b0) begin
  end else begin
    sub_h_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_113x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sub_h_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////// stripe up counter //////////////////////////

always @(
  stripe_cnt
  ) begin
    {mon_stripe_cnt_inc,
     stripe_cnt_inc} = stripe_cnt + 1'b1;
end

always @(
  layer_st
  or is_stripe_equal
  or is_sub_h_end
  or stripe_cnt
  or is_stripe_end
  or stripe_cnt_inc
  ) begin
    stripe_cnt_w = layer_st ? 7'b0 :
                   (is_stripe_equal & ~is_sub_h_end) ? stripe_cnt :
                   is_stripe_end ? 7'b0 :
                   stripe_cnt_inc;
end

always @(
  is_batch_end
  or stripe_cnt_inc
  or dl_stripe_length
  ) begin
    is_stripe_equal = is_batch_end & (stripe_cnt_inc == dl_stripe_length);
end

always @(
  is_stripe_equal
  or is_sub_h_end
  ) begin
    is_stripe_end = is_stripe_equal & is_sub_h_end;
end

always @(
  layer_st
  or dat_exec_valid
  or is_batch_end
  ) begin
    stripe_cnt_reg_en = layer_st | (dat_exec_valid & is_batch_end);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    stripe_cnt <= {7{1'b0}};
  end else begin
  if ((stripe_cnt_reg_en) == 1'b1) begin
    stripe_cnt <= stripe_cnt_w;
  // VCS coverage off
  end else if ((stripe_cnt_reg_en) == 1'b0) begin
  end else begin
    stripe_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_114x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(stripe_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! stripe_cnt is not zero when idle")      zzz_assert_never_115x (nvdla_core_clk, `ASSERT_RESET, (~reg2dp_op_en & |(stripe_cnt))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! stripe_cnt_w is overflow!")      zzz_assert_never_116x (nvdla_core_clk, `ASSERT_RESET, (mon_stripe_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! stripe_cnt_w is too large!")      zzz_assert_never_117x (nvdla_core_clk, `ASSERT_RESET, (stripe_cnt_reg_en & (stripe_cnt_w > dl_stripe_length))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! stripe_cnt is out of range!")      zzz_assert_never_118x (nvdla_core_clk, `ASSERT_RESET, (stripe_cnt > 7'h40)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////// pipe valid generator //////////////////////////
always @(
  dat_pipe_valid
  or is_stripe_equal
  or dl_pvld
  or dat_pipe_local_valid
  ) begin
    dat_pipe_local_valid_w = (dat_pipe_valid & is_stripe_equal) ? 1'b0 :
                             dl_pvld ? 1'b1 :
                             dat_pipe_local_valid;
end

assign dat_pipe_valid = dl_pvld | dat_pipe_local_valid;

always @(
  dl_pvld
  or stripe_cnt
  or sub_h_cnt
  or batch_cnt
  or dat_exec_valid_d1
  ) begin
    dat_exec_valid = dl_pvld ? 1'b1 :
                     (~(|stripe_cnt) & ~(|sub_h_cnt) & ~(|batch_cnt)) ? 1'b0 :
                     dat_exec_valid_d1;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_pipe_local_valid <= 1'b0;
  end else begin
  dat_pipe_local_valid <= dat_pipe_local_valid_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_pipe_valid_d1 <= 1'b0;
  end else begin
  dat_pipe_valid_d1 <= dat_pipe_valid;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_exec_valid_d1 <= 1'b0;
  end else begin
  dat_exec_valid_d1 <= dat_exec_valid;
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
  nv_assert_never #(0,0,"Error! dat_pipe_valid and dat_exec_valid not match!")      zzz_assert_never_119x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & ~(|reg2dp_y_extension) & (dat_exec_valid != dat_pipe_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////// request bytes //////////////////////////
always @(
  is_int8_d1
  or dl_channel_size
  ) begin
    dat_req_bytes = is_int8_d1[0] ? {1'b0, dl_channel_size} : {dl_channel_size, 1'b0};
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_bytes_d1 <= {8{1'b0}};
  end else begin
  if ((dat_exec_valid) == 1'b1) begin
    dat_req_bytes_d1 <= dat_req_bytes;
  // VCS coverage off
  end else if ((dat_exec_valid) == 1'b0) begin
  end else begin
    dat_req_bytes_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_120x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! required bytes is overflow")      zzz_assert_never_121x (nvdla_core_clk, `ASSERT_RESET, (dat_req_bytes > 8'h80)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! required bytes is out of range when int8")      zzz_assert_never_122x (nvdla_core_clk, `ASSERT_RESET, (is_int8_d1[0] & is_sg_running & (dat_req_bytes > 8'h40))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////// output width coordinate counter //////////////////////////

assign dataout_w_add = sub_h_cmp_g1;

always @(
  dataout_w_cnt
  or dataout_w_add
  ) begin
    {mon_dataout_w_cnt_inc,
     dataout_w_cnt_inc} = dataout_w_cnt + dataout_w_add;
end

always @(
  is_batch_end
  or is_sub_h_end
  or dataout_w_cnt
  or dataout_width_cmp
  ) begin
    is_w_end = is_batch_end & is_sub_h_end & (dataout_w_cnt >= dataout_width_cmp);
end

always @(
  is_batch_end
  or dataout_w_cnt
  or dataout_width_cmp
  ) begin
    is_w_end_ahead = is_batch_end & (dataout_w_cnt >= dataout_width_cmp);
end

always @(
  layer_st
  or dataout_w_init
  or is_stripe_end
  or dl_channel_end
  or dataout_w_ori
  or is_w_end
  or dataout_w_cnt_inc
  ) begin
    dataout_w_cnt_w = layer_st ? dataout_w_init :
                      (is_stripe_end & ~dl_channel_end) ? dataout_w_ori :
                      is_w_end ? dataout_w_init :
                      dataout_w_cnt_inc;
end

always @(
  layer_st
  or dat_exec_valid
  or is_batch_end
  or is_sub_h_end
  ) begin
    dataout_w_cnt_reg_en = layer_st | (dat_exec_valid & is_batch_end & is_sub_h_end);
end

always @(
  layer_st
  or dat_exec_valid
  or is_stripe_end
  or dl_channel_end
  ) begin
    dataout_w_ori_reg_en = layer_st | (dat_exec_valid & is_stripe_end & dl_channel_end);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dataout_w_cnt <= {13{1'b0}};
  end else begin
  if ((dataout_w_cnt_reg_en) == 1'b1) begin
    dataout_w_cnt <= dataout_w_cnt_w;
  // VCS coverage off
  end else if ((dataout_w_cnt_reg_en) == 1'b0) begin
  end else begin
    dataout_w_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_123x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dataout_w_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dataout_w_ori <= {13{1'b0}};
  end else begin
  if ((dataout_w_ori_reg_en) == 1'b1) begin
    dataout_w_ori <= dataout_w_cnt_w;
  // VCS coverage off
  end else if ((dataout_w_ori_reg_en) == 1'b0) begin
  end else begin
    dataout_w_ori <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_124x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dataout_w_ori_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////// input channel coordinate counter //////////////////////////

always @(
  datain_c_cnt
  ) begin
    {mon_datain_c_cnt_inc,
     datain_c_cnt_inc} = datain_c_cnt + 1'b1;
end

always @(
  datain_c_cnt
  or datain_channel_cmp
  ) begin
    is_last_channel = (datain_c_cnt == datain_channel_cmp);
end

always @(
  layer_st
  or dl_channel_end
  or datain_c_cnt_inc
  ) begin
    datain_c_cnt_w = layer_st ? 11'b0 :
                     dl_channel_end ? 11'b0 :
                     datain_c_cnt_inc;
end

always @(
  layer_st
  or dat_exec_valid
  or is_stripe_end
  or dl_block_end
  ) begin
    datain_c_cnt_reg_en = layer_st | (dat_exec_valid & is_stripe_end & dl_block_end);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    datain_c_cnt <= {11{1'b0}};
  end else begin
  if ((datain_c_cnt_reg_en) == 1'b1) begin
    datain_c_cnt <= datain_c_cnt_w;
  // VCS coverage off
  end else if ((datain_c_cnt_reg_en) == 1'b0) begin
  end else begin
    datain_c_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_125x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(datain_c_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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


////////////////////////// input width coordinate counter //////////////////////////

always @(
  is_img
  or is_winograd
  or reg2dp_pad_left
  ) begin
    datain_w_cnt_st = (is_img) ? 14'b0 :
                      (is_winograd) ? 14'h2 :
                      13'b0 - reg2dp_pad_left;
end

always @(
  is_winograd_d1
  or datain_w_cnt
  or conv_x_stride
  ) begin
    {mon_datain_w_cnt_inc,
     datain_w_cnt_inc} = (is_winograd_d1[3]) ? (datain_w_cnt + 2'h2) :
                         (datain_w_cnt + conv_x_stride);
end

always @(
  layer_st
  or datain_w_cnt_st
  or is_stripe_end
  or dl_channel_end
  or datain_w_ori
  or is_w_end
  or datain_w_cnt_inc
  ) begin
    datain_w_cnt_w = layer_st ? datain_w_cnt_st :
                     (is_stripe_end & ~dl_channel_end) ? datain_w_ori :
                     is_w_end ? datain_w_cnt_st :
                     datain_w_cnt_inc;
end

always @(
  is_sub_h_end
  or pixel_x_add
  ) begin
    pixel_x_cnt_add = (is_sub_h_end) ? pixel_x_add : 6'b0;
end

always @(
  layer_st_d1
  or pixel_x_init
  or is_stripe_end
  or dl_block_end
  or dl_channel_end
  or is_w_end
  or pixel_w_ch_ori
  or pixel_ch_stride
  or pixel_x_init_offset
  or pixel_w_ori
  or pixel_w_cnt
  or pixel_x_cnt_add
  ) begin
    {mon_pixel_w_cnt_w,
     pixel_w_cnt_w} = (layer_st_d1) ? {{11{1'b0}}, pixel_x_init} :
                      (is_stripe_end & dl_block_end & dl_channel_end & is_w_end) ? {{11{1'b0}}, pixel_x_init} :
                      (is_stripe_end & dl_block_end & dl_channel_end & ~is_w_end) ? (pixel_w_ch_ori + pixel_ch_stride) :
                      (is_stripe_end & dl_block_end & ~dl_channel_end) ? (pixel_w_ch_ori + pixel_x_init_offset) :
                      (is_stripe_end & ~dl_block_end) ? {1'b0, pixel_w_ori} :
                      (pixel_w_cnt + pixel_x_cnt_add);
end

assign pixel_w_cur = pixel_w_cnt[15:6];

always @(
  layer_st
  or dat_exec_valid
  or is_batch_end
  or is_sub_h_end
  or is_img_d1
  ) begin
    datain_w_cnt_reg_en = layer_st | (dat_exec_valid & is_batch_end & is_sub_h_end & ~is_img_d1[0]);
end

always @(
  layer_st
  or dat_exec_valid
  or is_img_d1
  or is_stripe_end
  or dl_channel_end
  ) begin
    datain_w_ori_reg_en =  layer_st | (dat_exec_valid & ~is_img_d1[1] & is_stripe_end & dl_channel_end);
end

always @(
  layer_st_d1
  or dat_exec_valid
  or is_img_d1
  or is_sub_h_end
  or is_w_end
  ) begin
    pixel_w_cnt_reg_en = layer_st_d1 | (dat_exec_valid & is_img_d1[2] & (is_sub_h_end | is_w_end));
end

always @(
  layer_st_d1
  or dat_exec_valid
  or is_img_d1
  or is_stripe_end
  or dl_block_end
  ) begin
    pixel_w_ori_reg_en = layer_st_d1 | (dat_exec_valid & is_img_d1[3] & is_stripe_end & dl_block_end);
end

always @(
  layer_st_d1
  or dat_exec_valid
  or is_img_d1
  or is_stripe_end
  or dl_block_end
  or dl_channel_end
  ) begin
    pixel_ch_ori_reg_en = layer_st_d1 | (dat_exec_valid & is_img_d1[4] & is_stripe_end & dl_block_end & dl_channel_end);
end

always @(
  dl_w_offset
  or x_dilate
  ) begin
    dl_w_offset_ext = dl_w_offset * x_dilate;
end

always @(
  datain_w_cnt
  or dl_w_offset_ext
  ) begin
    {mon_datain_w_cur,
     datain_w_cur} = datain_w_cnt + dl_w_offset_ext;
end

always @(
  layer_st_d1
  or dl_channel_end
  or is_w_end_ahead
  or is_int8_d1
  or is_w_end
  or pixel_x_stride_odd
  or pixel_req_ch_odd_ori
  or pixel_req_ch_odd
  ) begin
    pixel_req_ch_odd_w = layer_st_d1 ? 1'b0 :
                         (dl_channel_end & is_w_end_ahead) ? 1'b0 :
                         (is_int8_d1[1] & dl_channel_end & ~is_w_end & pixel_x_stride_odd) ? ~pixel_req_ch_odd_ori :
                         (is_int8_d1[1] & dl_channel_end & ~is_w_end & ~pixel_x_stride_odd) ? pixel_req_ch_odd_ori :
                         (is_int8_d1[1] & ~dl_channel_end) ? ~pixel_req_ch_odd :
                         pixel_req_ch_odd;
end

assign pixel_req_ch_odd_en = pixel_w_ori_reg_en;
assign pixel_req_ch_odd_ori_en = pixel_ch_ori_reg_en;
assign pixel_force_fetch = (is_img_d1[0] & dat_req_stripe_st) ? 1'b1 :
                           (pixel_force_clr_d1) ? 1'b0 :
                           pixel_force_fetch_d1;
assign pixel_force_clr = is_img_d1[0] & is_sub_h_end & (pixel_force_fetch | pixel_force_fetch_d1);

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    datain_w_cnt <= {14{1'b0}};
  end else begin
  if ((datain_w_cnt_reg_en) == 1'b1) begin
    datain_w_cnt <= datain_w_cnt_w;
  // VCS coverage off
  end else if ((datain_w_cnt_reg_en) == 1'b0) begin
  end else begin
    datain_w_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_126x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(datain_w_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    datain_w_ori <= {14{1'b0}};
  end else begin
  if ((datain_w_ori_reg_en) == 1'b1) begin
    datain_w_ori <= datain_w_cnt_w;
  // VCS coverage off
  end else if ((datain_w_ori_reg_en) == 1'b0) begin
  end else begin
    datain_w_ori <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_127x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(datain_w_ori_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pixel_w_cnt <= {16{1'b0}};
  end else begin
  if ((pixel_w_cnt_reg_en) == 1'b1) begin
    pixel_w_cnt <= pixel_w_cnt_w;
  // VCS coverage off
  end else if ((pixel_w_cnt_reg_en) == 1'b0) begin
  end else begin
    pixel_w_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_128x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pixel_w_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pixel_w_ori <= {16{1'b0}};
  end else begin
  if ((pixel_w_ori_reg_en) == 1'b1) begin
    pixel_w_ori <= pixel_w_cnt_w;
  // VCS coverage off
  end else if ((pixel_w_ori_reg_en) == 1'b0) begin
  end else begin
    pixel_w_ori <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_129x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pixel_w_ori_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pixel_w_ch_ori <= {16{1'b0}};
  end else begin
  if ((pixel_ch_ori_reg_en) == 1'b1) begin
    pixel_w_ch_ori <= pixel_w_cnt_w;
  // VCS coverage off
  end else if ((pixel_ch_ori_reg_en) == 1'b0) begin
  end else begin
    pixel_w_ch_ori <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_130x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pixel_ch_ori_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pixel_req_ch_odd <= 1'b0;
  end else begin
  if ((pixel_req_ch_odd_en) == 1'b1) begin
    pixel_req_ch_odd <= pixel_req_ch_odd_w;
  // VCS coverage off
  end else if ((pixel_req_ch_odd_en) == 1'b0) begin
  end else begin
    pixel_req_ch_odd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_131x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pixel_req_ch_odd_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pixel_req_ch_odd_ori <= 1'b0;
  end else begin
  if ((pixel_req_ch_odd_ori_en) == 1'b1) begin
    pixel_req_ch_odd_ori <= pixel_req_ch_odd_w;
  // VCS coverage off
  end else if ((pixel_req_ch_odd_ori_en) == 1'b0) begin
  end else begin
    pixel_req_ch_odd_ori <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_132x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(pixel_req_ch_odd_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! pixel_w_cnt_w is overflow!")      zzz_assert_never_133x (nvdla_core_clk, `ASSERT_RESET, (pixel_w_cnt_reg_en & mon_pixel_w_cnt_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////// input height coordinate counter //////////////////////////

always @(
  is_winograd
  or reg2dp_pad_top
  ) begin
    datain_h_cnt_st = (is_winograd) ? 14'b0 :
                      14'b0 - reg2dp_pad_top;
end

always @(
  datain_h_cnt
  or conv_y_stride
  ) begin
    {mon_datain_h_cnt_inc,
     datain_h_cnt_inc} = datain_h_cnt + conv_y_stride;
end

always @(
  layer_st
  or is_stripe_end
  or dl_group_end
  or datain_h_cnt_st
  or dl_channel_end
  or datain_h_ori
  or is_w_end
  or datain_h_cnt_inc
  or datain_h_cnt
  ) begin
    datain_h_cnt_w = (layer_st | (is_stripe_end & dl_group_end)) ? datain_h_cnt_st :
                     (is_stripe_end & ~dl_channel_end) ? datain_h_ori :
                     is_w_end ? datain_h_cnt_inc :
                     datain_h_cnt;
end

always @(
  layer_st
  or dat_exec_valid
  or is_stripe_end
  or dl_channel_end
  or is_w_end
  ) begin
    datain_h_cnt_reg_en = layer_st | (dat_exec_valid & ((is_stripe_end & ~dl_channel_end) | is_w_end));
end

always @(
  layer_st
  or dat_exec_valid
  or is_stripe_end
  or dl_channel_end
  ) begin
    datain_h_ori_reg_en = layer_st | (dat_exec_valid & is_stripe_end & dl_channel_end);
end

always @(
  dl_h_offset
  or y_dilate
  ) begin
    dl_h_offset_ext = dl_h_offset * y_dilate;
end

always @(
  datain_h_cnt
  or dl_h_offset_ext
  or sub_h_cnt
  ) begin
    {mon_datain_h_cur,
     datain_h_cur} = datain_h_cnt + dl_h_offset_ext + sub_h_cnt;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    datain_h_cnt <= {14{1'b0}};
  end else begin
  if ((datain_h_cnt_reg_en) == 1'b1) begin
    datain_h_cnt <= datain_h_cnt_w;
  // VCS coverage off
  end else if ((datain_h_cnt_reg_en) == 1'b0) begin
  end else begin
    datain_h_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_134x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(datain_h_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    datain_h_ori <= {14{1'b0}};
  end else begin
  if ((datain_h_ori_reg_en) == 1'b1) begin
    datain_h_ori <= datain_h_cnt_w;
  // VCS coverage off
  end else if ((datain_h_ori_reg_en) == 1'b0) begin
  end else begin
    datain_h_ori <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_135x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(datain_h_ori_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////// fetch valid generate //////////////////////////

always @(
  datain_w_cur
  or datain_width_cmp
  or datain_h_cur
  or datain_height_cmp
  ) begin
    dat_conv_req_dummy = (datain_w_cur[13  ]) | (datain_w_cur > {1'b0, datain_width_cmp}) 
                       | (datain_h_cur[13  ]) | (datain_h_cur > {1'b0, datain_height_cmp}); 
end

assign dat_wg_req_dummy = 1'b0;

always @(
  datain_w_cur
  or stripe_cnt
  ) begin
    dat_wg_req_skip = ((|datain_w_cur[13:2]) & datain_w_cur[1] & (|stripe_cnt[6:1]));
end

always @(
  datain_h_cur
  or datain_height_cmp
  ) begin
    dat_img_req_dummy = (datain_h_cur[13  ]) | (datain_h_cur > {1'b0, datain_height_cmp});
end

always @(
  w_bias_w
  or entries_cmp
  ) begin
    dat_img_req_skip = (w_bias_w[12 +1:2] > entries_cmp);
end

always @(
  is_img_d1
  or dat_img_req_dummy
  or is_winograd_d1
  or dat_wg_req_dummy
  or dat_conv_req_dummy
  ) begin
    dat_req_dummy = is_img_d1[5] ? dat_img_req_dummy :
                    is_winograd_d1[4] ? dat_wg_req_dummy :
                    dat_conv_req_dummy;
end

always @(
  is_winograd_d1
  or dat_wg_req_skip
  or is_img_d1
  or dat_img_req_skip
  ) begin
    dat_req_skip = (is_winograd_d1[5] & dat_wg_req_skip) | (is_img_d1[6] & dat_img_req_skip);
end

always @(
  dat_exec_valid
  or dat_req_dummy
  or dat_req_skip
  ) begin
    dat_req_valid = (dat_exec_valid & ~dat_req_dummy & ~dat_req_skip);
end

//Add corner case
always @(
  is_img_d1
  or is_int8_d1
  or datain_c_cnt
  or dl_block_end
  ) begin
    dat_req_sub_c_w = ~is_img_d1[7] ? (is_int8_d1[2] & datain_c_cnt[0]) :
                      dl_block_end;
end

always @(
  is_winograd_d1
  or datain_w_cur
  ) begin
    dat_req_sub_w_w = is_winograd_d1[6] ? {1'b0, ~datain_w_cur[1]} :
                      datain_w_cur[1:0];
end

assign dat_req_sub_w_st_en = dat_exec_valid & (sub_h_cnt == 2'h0);

assign dat_req_batch_index = batch_cnt;
assign dat_req_stripe_st = dl_pvld;
assign dat_req_stripe_end = is_stripe_equal & dat_pipe_valid;
assign dat_req_channel_end = dl_channel_end;
assign dat_req_layer_end = dl_layer_end;


// PKT_PACK_WIRE( nvdla_stripe_info ,  dat_req_ ,  dat_req_flag_w )
assign       dat_req_flag_w[4:0] =     dat_req_batch_index[4:0];
assign       dat_req_flag_w[5] =     dat_req_stripe_st ;
assign       dat_req_flag_w[6] =     dat_req_stripe_end ;
assign       dat_req_flag_w[7] =     dat_req_channel_end ;
assign       dat_req_flag_w[8] =     dat_req_layer_end ;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_valid_d1 <= 1'b0;
  end else begin
  dat_req_valid_d1 <= dat_req_valid;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_sub_w_d1 <= {2{1'b0}};
  end else begin
  if ((dat_exec_valid) == 1'b1) begin
    dat_req_sub_w_d1 <= dat_req_sub_w_w;
  // VCS coverage off
  end else if ((dat_exec_valid) == 1'b0) begin
  end else begin
    dat_req_sub_w_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_136x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_sub_h_d1 <= {2{1'b0}};
  end else begin
  if ((dat_exec_valid) == 1'b1) begin
    dat_req_sub_h_d1 <= sub_h_cnt;
  // VCS coverage off
  end else if ((dat_exec_valid) == 1'b0) begin
  end else begin
    dat_req_sub_h_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_137x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_sub_c_d1 <= 1'b0;
  end else begin
  if ((dat_exec_valid) == 1'b1) begin
    dat_req_sub_c_d1 <= dat_req_sub_c_w;
  // VCS coverage off
  end else if ((dat_exec_valid) == 1'b0) begin
  end else begin
    dat_req_sub_c_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_138x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_ch_end_d1 <= 1'b0;
  end else begin
  if ((dat_exec_valid) == 1'b1) begin
    dat_req_ch_end_d1 <= is_last_channel;
  // VCS coverage off
  end else if ((dat_exec_valid) == 1'b0) begin
  end else begin
    dat_req_ch_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_139x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_ch_odd_d1 <= 1'b0;
  end else begin
  if ((dat_exec_valid) == 1'b1) begin
    dat_req_ch_odd_d1 <= pixel_req_ch_odd_w;
  // VCS coverage off
  end else if ((dat_exec_valid) == 1'b0) begin
  end else begin
    dat_req_ch_odd_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_140x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_dummy_d1 <= 1'b0;
  end else begin
  if ((dat_exec_valid) == 1'b1) begin
    dat_req_dummy_d1 <= dat_req_dummy;
  // VCS coverage off
  end else if ((dat_exec_valid) == 1'b0) begin
  end else begin
    dat_req_dummy_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_141x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_cur_sub_h_d1 <= {2{1'b0}};
  end else begin
  if ((dat_exec_valid) == 1'b1) begin
    dat_req_cur_sub_h_d1 <= dl_cur_sub_h;
  // VCS coverage off
  end else if ((dat_exec_valid) == 1'b0) begin
  end else begin
    dat_req_cur_sub_h_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_142x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_sub_w_st_d1 <= 1'b0;
  end else begin
  if ((dat_req_sub_w_st_en) == 1'b1) begin
    dat_req_sub_w_st_d1 <= dat_req_stripe_st;
  // VCS coverage off
  end else if ((dat_req_sub_w_st_en) == 1'b0) begin
  end else begin
    dat_req_sub_w_st_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_143x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_req_sub_w_st_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_flag_d1 <= {9{1'b0}};
  end else begin
  if ((dat_exec_valid) == 1'b1) begin
    dat_req_flag_d1 <= dat_req_flag_w;
  // VCS coverage off
  end else if ((dat_exec_valid) == 1'b0) begin
  end else begin
    dat_req_flag_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_144x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_rls_d1 <= 1'b0;
  end else begin
  if ((dat_exec_valid) == 1'b1) begin
    dat_req_rls_d1 <= dl_dat_release & is_stripe_equal & dat_pipe_valid;
  // VCS coverage off
  end else if ((dat_exec_valid) == 1'b0) begin
  end else begin
    dat_req_rls_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_145x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pixel_force_fetch_d1 <= 1'b0;
  end else begin
  if ((dat_exec_valid) == 1'b1) begin
    pixel_force_fetch_d1 <= pixel_force_fetch;
  // VCS coverage off
  end else if ((dat_exec_valid) == 1'b0) begin
  end else begin
    pixel_force_fetch_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_146x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    pixel_force_clr_d1 <= 1'b0;
  end else begin
  if ((dat_exec_valid) == 1'b1) begin
    pixel_force_clr_d1 <= pixel_force_clr;
  // VCS coverage off
  end else if ((dat_exec_valid) == 1'b0) begin
  end else begin
    pixel_force_clr_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_147x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! Another data package when current one is not finish")      zzz_assert_never_148x (nvdla_core_clk, `ASSERT_RESET, (dl_pvld & |{batch_cnt, stripe_cnt})); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! Group end when w_end is not!")      zzz_assert_never_149x (nvdla_core_clk, `ASSERT_RESET, (dat_exec_valid & (is_stripe_end & dl_group_end) & ~is_w_end)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////////////////////////////////
///// generate data read address                         /////
//////////////////////////////////////////////////////////////
////////////////////////// data read index generator: 1st stage //////////////////////////

//channel bias
always @(
  is_img_d1
  or is_int8_d1
  or datain_c_cnt
  or datain_width
  ) begin
    c_bias_add = (~is_img_d1[8] & (~is_int8_d1[3] | datain_c_cnt[0])) ? datain_width[12 -1:0] :
                 12'b0;
end

always @(
  layer_st
  or is_stripe_end
  or dl_channel_end
  or c_bias
  or c_bias_add
  ) begin
    {mon_c_bias_w,
     c_bias_w} = layer_st ? 13'b0 :
                 (is_stripe_end & dl_channel_end) ? 13'b0 :
                 c_bias + c_bias_add;
end

always @(
  layer_st
  or dat_exec_valid
  or is_stripe_end
  or dl_block_end
  ) begin
    c_bias_reg_en = layer_st | (dat_exec_valid & is_stripe_end & dl_block_end);
end

always @(
  c_bias
  or c_bias_d1
  ) begin
    c_bias_d1_reg_en = (c_bias != c_bias_d1);
end

//height bias
always @(
  datain_h_cnt
  or h_bias_0_stride
  ) begin
    {mon_h_bias_0_w,
     h_bias_0_w} = datain_h_cnt[12 -1:0] * h_bias_0_stride;
end

always @(
  dl_h_offset
  or h_bias_1_stride
  ) begin
    {mon_h_bias_1_w,
     h_bias_1_w} = dl_h_offset * h_bias_1_stride;
end

always @(
  batch_cnt
  or h_bias_2_stride
  ) begin
    {mon_h_bias_2_w,
     h_bias_2_w} = batch_cnt * h_bias_2_stride;
end

always @(
  layer_st
  or sub_h_cnt
  or h_bias_3_stride
  ) begin
    {mon_h_bias_3_w,
     h_bias_3_w} = layer_st ? 13'b0 :
                   sub_h_cnt * h_bias_3_stride;
end

assign h_bias_reg_en[0] = dat_exec_valid;
assign h_bias_reg_en[1] = layer_st | (dat_exec_valid & (is_winograd_d1[7] | is_img_d1[9]));

//width bias
always @(
  is_img_d1
  or pixel_w_cur
  or is_winograd_d1
  or datain_w_cnt
  or is_last_channel
  or datain_c_cnt
  or datain_w_cur
  or dat_req_bytes
  ) begin
    w_bias_int8 = is_img_d1[10] ? {4'b0, pixel_w_cur, 1'b0} :
                  is_winograd_d1[8] ? {1'b0, datain_w_cnt} :
                  (~is_last_channel | datain_c_cnt[0] | is_winograd_d1[8]) ? {datain_w_cur[12:0], 2'b0} :
                  (dat_req_bytes > 8'h20) ? {1'b0, datain_w_cur[12:0], 1'b0} :
                  {2'b0, datain_w_cur[12:0]};
end

always @(
  is_img_d1
  or pixel_w_cur
  or is_winograd_d1
  or datain_w_cnt
  or dat_req_bytes
  or datain_w_cur
  ) begin
    w_bias_16 = is_img_d1[11] ? {3'b0, pixel_w_cur, 2'b0} :
                is_winograd_d1[9] ? {1'b0, datain_w_cnt} :
                ((dat_req_bytes > 8'h40) | is_winograd_d1[9]) ? {datain_w_cur[12:0], 2'b0} :
                (dat_req_bytes > 8'h20) ? {1'b0, datain_w_cur[12:0], 1'b0} :
                {2'b0, datain_w_cur[12:0]};
end

always @(
  is_int8_d1
  or w_bias_int8
  or w_bias_16
  ) begin
    w_bias_w = is_int8_d1[4] ? w_bias_int8[12 +1:0] : w_bias_16[12 +1:0];
end

assign w_bias_reg_en = dat_exec_valid;

assign dat_req_base_d1 = dat_entry_st;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    c_bias <= {12{1'b0}};
  end else begin
  if ((c_bias_reg_en) == 1'b1) begin
    c_bias <= c_bias_w;
  // VCS coverage off
  end else if ((c_bias_reg_en) == 1'b0) begin
  end else begin
    c_bias <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_150x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(c_bias_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    c_bias_d1 <= {12{1'b0}};
  end else begin
  if ((c_bias_d1_reg_en) == 1'b1) begin
    c_bias_d1 <= c_bias;
  // VCS coverage off
  end else if ((c_bias_d1_reg_en) == 1'b0) begin
  end else begin
    c_bias_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_151x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(c_bias_d1_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    h_bias_0_d1 <= {12{1'b0}};
  end else begin
  if ((h_bias_reg_en[0]) == 1'b1) begin
    h_bias_0_d1 <= h_bias_0_w;
  // VCS coverage off
  end else if ((h_bias_reg_en[0]) == 1'b0) begin
  end else begin
    h_bias_0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_152x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(h_bias_reg_en[0]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    h_bias_1_d1 <= {12{1'b0}};
  end else begin
  if ((h_bias_reg_en[0]) == 1'b1) begin
    h_bias_1_d1 <= h_bias_1_w;
  // VCS coverage off
  end else if ((h_bias_reg_en[0]) == 1'b0) begin
  end else begin
    h_bias_1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_153x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(h_bias_reg_en[0]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    h_bias_2_d1 <= {12{1'b0}};
  end else begin
  if ((h_bias_reg_en[0]) == 1'b1) begin
    h_bias_2_d1 <= h_bias_2_w;
  // VCS coverage off
  end else if ((h_bias_reg_en[0]) == 1'b0) begin
  end else begin
    h_bias_2_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_154x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(h_bias_reg_en[0]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    h_bias_3_d1 <= {12{1'b0}};
  end else begin
  if ((h_bias_reg_en[1]) == 1'b1) begin
    h_bias_3_d1 <= h_bias_3_w;
  // VCS coverage off
  end else if ((h_bias_reg_en[1]) == 1'b0) begin
  end else begin
    h_bias_3_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_155x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(h_bias_reg_en[1]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    w_bias_d1 <= {12{1'b0}};
  end else begin
  if ((w_bias_reg_en) == 1'b1) begin
    w_bias_d1 <= w_bias_w[12 +1:2];
  // VCS coverage off
  end else if ((w_bias_reg_en) == 1'b0) begin
  end else begin
    w_bias_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_156x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(w_bias_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! c_bias_w is overflow")      zzz_assert_never_157x (nvdla_core_clk, `ASSERT_RESET, (mon_c_bias_w & c_bias_reg_en)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! c_bias_w is out of range")      zzz_assert_never_158x (nvdla_core_clk, `ASSERT_RESET, (c_bias_w >= 3840 & c_bias_reg_en)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! h_bias_2_w is overflow!")      zzz_assert_never_159x (nvdla_core_clk, `ASSERT_RESET, (h_bias_reg_en[0] & |(mon_h_bias_2_w) & dat_req_valid)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! h_bias_2_w is out of range!")      zzz_assert_never_160x (nvdla_core_clk, `ASSERT_RESET, (h_bias_reg_en[0] & (h_bias_2_w > 3840) & dat_req_valid)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! h_bias_3_w is overflow!")      zzz_assert_never_161x (nvdla_core_clk, `ASSERT_RESET, (h_bias_reg_en[1] & |(mon_h_bias_3_w) & dat_req_valid)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! h_bias_3_w is out of range!")      zzz_assert_never_162x (nvdla_core_clk, `ASSERT_RESET, (h_bias_reg_en[1] & (h_bias_3_w > 3840) & dat_req_valid)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

////////////////////////// data read index generator: 2st stage //////////////////////////

always @(
  h_bias_0_d1
  or h_bias_1_d1
  or h_bias_2_d1
  or h_bias_3_d1
  ) begin
    {mon_h_bias_d1,
     h_bias_d1} = h_bias_0_d1 + h_bias_1_d1 + h_bias_2_d1 + h_bias_3_d1;
end

always @(
  dat_req_base_d1
  or c_bias_d1
  or h_bias_d1
  or w_bias_d1
  ) begin
    dat_req_addr_sum = dat_req_base_d1 + c_bias_d1 + h_bias_d1 + w_bias_d1;
end

always @(
  dat_req_addr_sum
  or data_bank
  ) begin
    is_dat_req_addr_wrap = (dat_req_addr_sum >= {1'b0, data_bank, 8'b0});
end

always @(
  dat_req_addr_sum
  or data_bank
  ) begin
    {mon_dat_req_addr_wrap,
     dat_req_addr_wrap} = dat_req_addr_sum[12 -1:0] - {data_bank, 8'b0};
end

always @(
  layer_st
  or dat_req_dummy_d1
  or is_dat_req_addr_wrap
  or dat_req_addr_wrap
  or dat_req_addr_sum
  ) begin
    dat_req_addr_w = (layer_st | dat_req_dummy_d1) ? {12 {1'b1}} :
                     is_dat_req_addr_wrap ? dat_req_addr_wrap : dat_req_addr_sum[12 -1:0];
end

always @(
  dat_req_valid_d1
  or dat_req_addr_last
  or dat_req_addr_w
  or pixel_force_fetch_d1
  ) begin
    sc2buf_dat_rd_en_w = dat_req_valid_d1 & ((dat_req_addr_last != dat_req_addr_w) | pixel_force_fetch_d1);
end

assign dat_req_addr_last = (dat_req_sub_h_d1 == 2'h0) ? dat_req_sub_h_0_addr :
                           (dat_req_sub_h_d1 == 2'h1) ? dat_req_sub_h_1_addr :
                           (dat_req_sub_h_d1 == 2'h2) ? dat_req_sub_h_2_addr :
                           dat_req_sub_h_3_addr;

assign dat_req_sub_h_0_addr_en = layer_st | ((dat_req_valid_d1 | dat_req_dummy_d1) & (dat_req_sub_h_d1 == 2'h0));
assign dat_req_sub_h_1_addr_en = layer_st | ((dat_req_valid_d1 | dat_req_dummy_d1) & (dat_req_sub_h_d1 == 2'h1));
assign dat_req_sub_h_2_addr_en = layer_st | ((dat_req_valid_d1 | dat_req_dummy_d1) & (dat_req_sub_h_d1 == 2'h2));
assign dat_req_sub_h_3_addr_en = layer_st | ((dat_req_valid_d1 | dat_req_dummy_d1) & (dat_req_sub_h_d1 == 2'h3));

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_sub_h_0_addr <= {12{1'b1}};
  end else begin
  if ((dat_req_sub_h_0_addr_en) == 1'b1) begin
    dat_req_sub_h_0_addr <= dat_req_addr_w;
  // VCS coverage off
  end else if ((dat_req_sub_h_0_addr_en) == 1'b0) begin
  end else begin
    dat_req_sub_h_0_addr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_163x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_req_sub_h_0_addr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_sub_h_1_addr <= {12{1'b1}};
  end else begin
  if ((dat_req_sub_h_1_addr_en) == 1'b1) begin
    dat_req_sub_h_1_addr <= dat_req_addr_w;
  // VCS coverage off
  end else if ((dat_req_sub_h_1_addr_en) == 1'b0) begin
  end else begin
    dat_req_sub_h_1_addr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_164x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_req_sub_h_1_addr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_sub_h_2_addr <= {12{1'b1}};
  end else begin
  if ((dat_req_sub_h_2_addr_en) == 1'b1) begin
    dat_req_sub_h_2_addr <= dat_req_addr_w;
  // VCS coverage off
  end else if ((dat_req_sub_h_2_addr_en) == 1'b0) begin
  end else begin
    dat_req_sub_h_2_addr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_165x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_req_sub_h_2_addr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_sub_h_3_addr <= {12{1'b1}};
  end else begin
  if ((dat_req_sub_h_3_addr_en) == 1'b1) begin
    dat_req_sub_h_3_addr <= dat_req_addr_w;
  // VCS coverage off
  end else if ((dat_req_sub_h_3_addr_en) == 1'b0) begin
  end else begin
    dat_req_sub_h_3_addr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_166x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_req_sub_h_3_addr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2buf_dat_rd_en <= 1'b0;
  end else begin
  sc2buf_dat_rd_en <= sc2buf_dat_rd_en_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2buf_dat_rd_addr <= {12{1'b1}};
  end else begin
  if ((layer_st | sc2buf_dat_rd_en_w) == 1'b1) begin
    sc2buf_dat_rd_addr <= dat_req_addr_w;
  // VCS coverage off
  end else if ((layer_st | sc2buf_dat_rd_en_w) == 1'b0) begin
  end else begin
    sc2buf_dat_rd_addr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_167x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | sc2buf_dat_rd_en_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_pipe_valid_d2 <= 1'b0;
  end else begin
  dat_pipe_valid_d2 <= dat_pipe_valid_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_exec_valid_d2 <= 1'b0;
  end else begin
  dat_exec_valid_d2 <= dat_exec_valid_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_sub_w_d2 <= {2{1'b0}};
  end else begin
  if ((dat_exec_valid_d1) == 1'b1) begin
    dat_req_sub_w_d2 <= dat_req_sub_w_d1;
  // VCS coverage off
  end else if ((dat_exec_valid_d1) == 1'b0) begin
  end else begin
    dat_req_sub_w_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_168x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_sub_h_d2 <= {2{1'b0}};
  end else begin
  if ((dat_exec_valid_d1) == 1'b1) begin
    dat_req_sub_h_d2 <= dat_req_sub_h_d1;
  // VCS coverage off
  end else if ((dat_exec_valid_d1) == 1'b0) begin
  end else begin
    dat_req_sub_h_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_169x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_sub_c_d2 <= 1'b0;
  end else begin
  if ((dat_exec_valid_d1) == 1'b1) begin
    dat_req_sub_c_d2 <= dat_req_sub_c_d1;
  // VCS coverage off
  end else if ((dat_exec_valid_d1) == 1'b0) begin
  end else begin
    dat_req_sub_c_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_170x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_ch_end_d2 <= 1'b0;
  end else begin
  if ((dat_exec_valid_d1) == 1'b1) begin
    dat_req_ch_end_d2 <= dat_req_ch_end_d1;
  // VCS coverage off
  end else if ((dat_exec_valid_d1) == 1'b0) begin
  end else begin
    dat_req_ch_end_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_171x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_ch_odd_d2 <= 1'b0;
  end else begin
  if ((dat_exec_valid_d1) == 1'b1) begin
    dat_req_ch_odd_d2 <= dat_req_ch_odd_d1;
  // VCS coverage off
  end else if ((dat_exec_valid_d1) == 1'b0) begin
  end else begin
    dat_req_ch_odd_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_172x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_bytes_d2 <= {8{1'b0}};
  end else begin
  if ((dat_exec_valid_d1) == 1'b1) begin
    dat_req_bytes_d2 <= dat_req_bytes_d1;
  // VCS coverage off
  end else if ((dat_exec_valid_d1) == 1'b0) begin
  end else begin
    dat_req_bytes_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_173x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_dummy_d2 <= 1'b0;
  end else begin
  if ((dat_exec_valid_d1) == 1'b1) begin
    dat_req_dummy_d2 <= dat_req_dummy_d1;
  // VCS coverage off
  end else if ((dat_exec_valid_d1) == 1'b0) begin
  end else begin
    dat_req_dummy_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_174x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_cur_sub_h_d2 <= {2{1'b0}};
  end else begin
  if ((dat_exec_valid_d1) == 1'b1) begin
    dat_req_cur_sub_h_d2 <= dat_req_cur_sub_h_d1;
  // VCS coverage off
  end else if ((dat_exec_valid_d1) == 1'b0) begin
  end else begin
    dat_req_cur_sub_h_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_175x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_sub_w_st_d2 <= 1'b0;
  end else begin
  if ((dat_exec_valid_d1) == 1'b1) begin
    dat_req_sub_w_st_d2 <= dat_req_sub_w_st_d1;
  // VCS coverage off
  end else if ((dat_exec_valid_d1) == 1'b0) begin
  end else begin
    dat_req_sub_w_st_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_176x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_rls_d2 <= 1'b0;
  end else begin
  if ((dat_exec_valid_d1) == 1'b1) begin
    dat_req_rls_d2 <= dat_req_rls_d1;
  // VCS coverage off
  end else if ((dat_exec_valid_d1) == 1'b0) begin
  end else begin
    dat_req_rls_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_177x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_req_flag_d2 <= {9{1'b0}};
  end else begin
  if ((dat_exec_valid_d1) == 1'b1) begin
    dat_req_flag_d2 <= dat_req_flag_d1;
  // VCS coverage off
  end else if ((dat_exec_valid_d1) == 1'b0) begin
  end else begin
    dat_req_flag_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_178x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_exec_valid_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! dat_req_addr_wrap is out of range")      zzz_assert_never_179x (nvdla_core_clk, `ASSERT_RESET, ((dat_req_addr_wrap > 3840) & is_dat_req_addr_wrap & dat_req_valid_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////////////////////////////////
///// sideband pipeline                                  /////
//////////////////////////////////////////////////////////////
assign dat_req_pipe_pvld = dat_pipe_valid_d2;
assign dat_req_pipe_sub_w = dat_req_sub_w_d2;
assign dat_req_pipe_sub_h = dat_req_sub_h_d2;
assign dat_req_pipe_sub_c = dat_req_sub_c_d2;
assign dat_req_pipe_ch_end = dat_req_ch_end_d2;
assign dat_req_pipe_ch_odd = dat_req_ch_odd_d2;
assign dat_req_pipe_bytes = dat_req_bytes_d2;
assign dat_req_pipe_dummy = dat_req_dummy_d2;
assign dat_req_pipe_cur_sub_h = dat_req_cur_sub_h_d2;
assign dat_req_pipe_sub_w_st = dat_req_sub_w_st_d2;
assign dat_req_pipe_rls = dat_req_rls_d2;
assign dat_req_pipe_flag = dat_req_flag_d2;
assign dat_req_exec_pvld = dat_exec_valid_d2;
assign dat_req_exec_dummy = dat_req_dummy_d2;
assign dat_req_exec_sub_h = dat_req_sub_h_d2;


// PKT_PACK_WIRE( csc_dat_req_pkg ,  dat_req_pipe_ ,  dat_req_pipe_pd )
assign       dat_req_pipe_pd[1:0] =     dat_req_pipe_sub_w[1:0];
assign       dat_req_pipe_pd[3:2] =     dat_req_pipe_sub_h[1:0];
assign       dat_req_pipe_pd[4] =     dat_req_pipe_sub_c ;
assign       dat_req_pipe_pd[5] =     dat_req_pipe_ch_end ;
assign       dat_req_pipe_pd[6] =     dat_req_pipe_ch_odd ;
assign       dat_req_pipe_pd[14:7] =     dat_req_pipe_bytes[7:0];
assign       dat_req_pipe_pd[16:15] =     dat_req_pipe_cur_sub_h[1:0];
assign       dat_req_pipe_pd[17] =     dat_req_pipe_dummy ;
assign       dat_req_pipe_pd[18] =     dat_req_pipe_sub_w_st ;
assign       dat_req_pipe_pd[19] =     dat_req_pipe_rls ;
assign       dat_req_pipe_pd[28:20] =     dat_req_pipe_flag[8:0];

assign dat_rsp_pipe_pvld_d0 = dat_req_pipe_pvld;
assign dat_rsp_pipe_pd_d0 = dat_req_pipe_pd;
assign dat_rsp_exec_pvld_d0 = dat_req_exec_pvld;
assign dat_rsp_exec_dummy_d0 = dat_req_exec_dummy;

assign dat_rsp_exec_sub_h_d0 = dat_req_exec_sub_h;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pipe_pvld_d1 <= 1'b0;
  end else begin
  dat_rsp_pipe_pvld_d1 <= dat_rsp_pipe_pvld_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pipe_pd_d1 <= {29{1'b0}};
  end else begin
  if ((dat_rsp_pipe_pvld_d0) == 1'b1) begin
    dat_rsp_pipe_pd_d1 <= dat_rsp_pipe_pd_d0;
  // VCS coverage off
  end else if ((dat_rsp_pipe_pvld_d0) == 1'b0) begin
  end else begin
    dat_rsp_pipe_pd_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_180x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_pipe_pvld_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_exec_pvld_d1 <= 1'b0;
  end else begin
  dat_rsp_exec_pvld_d1 <= dat_rsp_exec_pvld_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_exec_dummy_d1 <= 1'b0;
  end else begin
  if ((dat_rsp_exec_pvld_d0) == 1'b1) begin
    dat_rsp_exec_dummy_d1 <= dat_rsp_exec_dummy_d0;
  // VCS coverage off
  end else if ((dat_rsp_exec_pvld_d0) == 1'b0) begin
  end else begin
    dat_rsp_exec_dummy_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_181x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_exec_pvld_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_exec_sub_h_d1 <= {2{1'b0}};
  end else begin
  if ((dat_rsp_exec_pvld_d0) == 1'b1) begin
    dat_rsp_exec_sub_h_d1 <= dat_rsp_exec_sub_h_d0;
  // VCS coverage off
  end else if ((dat_rsp_exec_pvld_d0) == 1'b0) begin
  end else begin
    dat_rsp_exec_sub_h_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_182x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_exec_pvld_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pipe_pvld_d2 <= 1'b0;
  end else begin
  dat_rsp_pipe_pvld_d2 <= dat_rsp_pipe_pvld_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pipe_pd_d2 <= {29{1'b0}};
  end else begin
  if ((dat_rsp_pipe_pvld_d1) == 1'b1) begin
    dat_rsp_pipe_pd_d2 <= dat_rsp_pipe_pd_d1;
  // VCS coverage off
  end else if ((dat_rsp_pipe_pvld_d1) == 1'b0) begin
  end else begin
    dat_rsp_pipe_pd_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_183x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_pipe_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_exec_pvld_d2 <= 1'b0;
  end else begin
  dat_rsp_exec_pvld_d2 <= dat_rsp_exec_pvld_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_exec_dummy_d2 <= 1'b0;
  end else begin
  if ((dat_rsp_exec_pvld_d1) == 1'b1) begin
    dat_rsp_exec_dummy_d2 <= dat_rsp_exec_dummy_d1;
  // VCS coverage off
  end else if ((dat_rsp_exec_pvld_d1) == 1'b0) begin
  end else begin
    dat_rsp_exec_dummy_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_184x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_exec_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_exec_sub_h_d2 <= {2{1'b0}};
  end else begin
  if ((dat_rsp_exec_pvld_d1) == 1'b1) begin
    dat_rsp_exec_sub_h_d2 <= dat_rsp_exec_sub_h_d1;
  // VCS coverage off
  end else if ((dat_rsp_exec_pvld_d1) == 1'b0) begin
  end else begin
    dat_rsp_exec_sub_h_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_185x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_exec_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pipe_pvld_d3 <= 1'b0;
  end else begin
  dat_rsp_pipe_pvld_d3 <= dat_rsp_pipe_pvld_d2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pipe_pd_d3 <= {29{1'b0}};
  end else begin
  if ((dat_rsp_pipe_pvld_d2) == 1'b1) begin
    dat_rsp_pipe_pd_d3 <= dat_rsp_pipe_pd_d2;
  // VCS coverage off
  end else if ((dat_rsp_pipe_pvld_d2) == 1'b0) begin
  end else begin
    dat_rsp_pipe_pd_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_186x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_pipe_pvld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_exec_pvld_d3 <= 1'b0;
  end else begin
  dat_rsp_exec_pvld_d3 <= dat_rsp_exec_pvld_d2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_exec_dummy_d3 <= 1'b0;
  end else begin
  if ((dat_rsp_exec_pvld_d2) == 1'b1) begin
    dat_rsp_exec_dummy_d3 <= dat_rsp_exec_dummy_d2;
  // VCS coverage off
  end else if ((dat_rsp_exec_pvld_d2) == 1'b0) begin
  end else begin
    dat_rsp_exec_dummy_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_187x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_exec_pvld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_exec_sub_h_d3 <= {2{1'b0}};
  end else begin
  if ((dat_rsp_exec_pvld_d2) == 1'b1) begin
    dat_rsp_exec_sub_h_d3 <= dat_rsp_exec_sub_h_d2;
  // VCS coverage off
  end else if ((dat_rsp_exec_pvld_d2) == 1'b0) begin
  end else begin
    dat_rsp_exec_sub_h_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_188x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_exec_pvld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pipe_pvld_d4 <= 1'b0;
  end else begin
  dat_rsp_pipe_pvld_d4 <= dat_rsp_pipe_pvld_d3;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pipe_pd_d4 <= {29{1'b0}};
  end else begin
  if ((dat_rsp_pipe_pvld_d3) == 1'b1) begin
    dat_rsp_pipe_pd_d4 <= dat_rsp_pipe_pd_d3;
  // VCS coverage off
  end else if ((dat_rsp_pipe_pvld_d3) == 1'b0) begin
  end else begin
    dat_rsp_pipe_pd_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_189x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_pipe_pvld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_exec_pvld_d4 <= 1'b0;
  end else begin
  dat_rsp_exec_pvld_d4 <= dat_rsp_exec_pvld_d3;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_exec_dummy_d4 <= 1'b0;
  end else begin
  if ((dat_rsp_exec_pvld_d3) == 1'b1) begin
    dat_rsp_exec_dummy_d4 <= dat_rsp_exec_dummy_d3;
  // VCS coverage off
  end else if ((dat_rsp_exec_pvld_d3) == 1'b0) begin
  end else begin
    dat_rsp_exec_dummy_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_190x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_exec_pvld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_exec_sub_h_d4 <= {2{1'b0}};
  end else begin
  if ((dat_rsp_exec_pvld_d3) == 1'b1) begin
    dat_rsp_exec_sub_h_d4 <= dat_rsp_exec_sub_h_d3;
  // VCS coverage off
  end else if ((dat_rsp_exec_pvld_d3) == 1'b0) begin
  end else begin
    dat_rsp_exec_sub_h_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_191x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_exec_pvld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pipe_pvld_d5 <= 1'b0;
  end else begin
  dat_rsp_pipe_pvld_d5 <= dat_rsp_pipe_pvld_d4;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pipe_pd_d5 <= {29{1'b0}};
  end else begin
  if ((dat_rsp_pipe_pvld_d4) == 1'b1) begin
    dat_rsp_pipe_pd_d5 <= dat_rsp_pipe_pd_d4;
  // VCS coverage off
  end else if ((dat_rsp_pipe_pvld_d4) == 1'b0) begin
  end else begin
    dat_rsp_pipe_pd_d5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_192x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_pipe_pvld_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_exec_pvld_d5 <= 1'b0;
  end else begin
  dat_rsp_exec_pvld_d5 <= dat_rsp_exec_pvld_d4;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_exec_dummy_d5 <= 1'b0;
  end else begin
  if ((dat_rsp_exec_pvld_d4) == 1'b1) begin
    dat_rsp_exec_dummy_d5 <= dat_rsp_exec_dummy_d4;
  // VCS coverage off
  end else if ((dat_rsp_exec_pvld_d4) == 1'b0) begin
  end else begin
    dat_rsp_exec_dummy_d5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_193x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_exec_pvld_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_exec_sub_h_d5 <= {2{1'b0}};
  end else begin
  if ((dat_rsp_exec_pvld_d4) == 1'b1) begin
    dat_rsp_exec_sub_h_d5 <= dat_rsp_exec_sub_h_d4;
  // VCS coverage off
  end else if ((dat_rsp_exec_pvld_d4) == 1'b0) begin
  end else begin
    dat_rsp_exec_sub_h_d5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_194x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_exec_pvld_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pipe_pvld_d6 <= 1'b0;
  end else begin
  dat_rsp_pipe_pvld_d6 <= dat_rsp_pipe_pvld_d5;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pipe_pd_d6 <= {29{1'b0}};
  end else begin
  if ((dat_rsp_pipe_pvld_d5) == 1'b1) begin
    dat_rsp_pipe_pd_d6 <= dat_rsp_pipe_pd_d5;
  // VCS coverage off
  end else if ((dat_rsp_pipe_pvld_d5) == 1'b0) begin
  end else begin
    dat_rsp_pipe_pd_d6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_195x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_pipe_pvld_d5))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_exec_pvld_d6 <= 1'b0;
  end else begin
  dat_rsp_exec_pvld_d6 <= dat_rsp_exec_pvld_d5;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_exec_dummy_d6 <= 1'b0;
  end else begin
  if ((dat_rsp_exec_pvld_d5) == 1'b1) begin
    dat_rsp_exec_dummy_d6 <= dat_rsp_exec_dummy_d5;
  // VCS coverage off
  end else if ((dat_rsp_exec_pvld_d5) == 1'b0) begin
  end else begin
    dat_rsp_exec_dummy_d6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_196x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_exec_pvld_d5))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_exec_sub_h_d6 <= {2{1'b0}};
  end else begin
  if ((dat_rsp_exec_pvld_d5) == 1'b1) begin
    dat_rsp_exec_sub_h_d6 <= dat_rsp_exec_sub_h_d5;
  // VCS coverage off
  end else if ((dat_rsp_exec_pvld_d5) == 1'b0) begin
  end else begin
    dat_rsp_exec_sub_h_d6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_197x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_exec_pvld_d5))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign dat_rsp_pipe_pvld = dat_rsp_pipe_pvld_d6;
assign dat_rsp_pipe_pd = dat_rsp_pipe_pd_d6;
assign dat_rsp_exec_pvld = dat_rsp_exec_pvld_d6;
assign dat_rsp_exec_dummy = dat_rsp_exec_dummy_d6;

assign dat_rsp_exec_sub_h = dat_rsp_exec_sub_h_d6;



// PKT_UNPACK_WIRE( csc_dat_req_pkg ,  dat_rsp_pipe_ ,  dat_rsp_pipe_pd )
assign        dat_rsp_pipe_sub_w[1:0] =     dat_rsp_pipe_pd[1:0];
assign        dat_rsp_pipe_sub_h[1:0] =     dat_rsp_pipe_pd[3:2];
assign         dat_rsp_pipe_sub_c  =     dat_rsp_pipe_pd[4];
assign         dat_rsp_pipe_ch_end  =     dat_rsp_pipe_pd[5];
assign         dat_rsp_pipe_ch_odd  =     dat_rsp_pipe_pd[6];
assign        dat_rsp_pipe_bytes[7:0] =     dat_rsp_pipe_pd[14:7];
assign        dat_rsp_pipe_cur_sub_h[1:0] =     dat_rsp_pipe_pd[16:15];
assign         dat_rsp_pipe_dummy  =     dat_rsp_pipe_pd[17];
assign         dat_rsp_pipe_sub_w_st  =     dat_rsp_pipe_pd[18];
assign         dat_rsp_pipe_rls  =     dat_rsp_pipe_pd[19];
assign        dat_rsp_pipe_flag[8:0] =     dat_rsp_pipe_pd[28:20];

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
  nv_assert_never #(0,0,"Error! sc2buf_dat_rd_valid when dat_rsp_exec_pvld not!")      zzz_assert_never_198x (nvdla_core_clk, `ASSERT_RESET, (sc2buf_dat_rd_valid & ~dat_rsp_exec_pvld)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////////////////////////////////
///// dl data cache                                      /////
//////////////////////////////////////////////////////////////

always @(
  sc2buf_dat_rd_valid
  or dat_rsp_exec_sub_h
  or is_winograd_d1
  ) begin
    dat_l0c0_en = (sc2buf_dat_rd_valid & (dat_rsp_exec_sub_h == 2'h0));
    dat_l1c0_en = (sc2buf_dat_rd_valid & (dat_rsp_exec_sub_h == 2'h1));
    dat_l1c0_hi_en = (sc2buf_dat_rd_valid & (dat_rsp_exec_sub_h == 2'h1) & ~is_winograd_d1[10]);
    dat_l2c0_en = (sc2buf_dat_rd_valid & (dat_rsp_exec_sub_h == 2'h2));
    dat_l2c0_en = (sc2buf_dat_rd_valid & (dat_rsp_exec_sub_h == 2'h2));
    dat_l3c0_en = (sc2buf_dat_rd_valid & (dat_rsp_exec_sub_h == 2'h3));
    dat_l3c0_en = (sc2buf_dat_rd_valid & (dat_rsp_exec_sub_h == 2'h3));
end

always @(
  dat_wg_adv
  or dat_rsp_exec_sub_h
  or is_img_d1
  or dat_l0c0_en
  or dat_l0c0_dummy
  or dat_l1c0_en
  or dat_l1c0_dummy
  or dat_l2c0_en
  or dat_l2c0_dummy
  or dat_l3c0_en
  or dat_l3c0_dummy
  ) begin
    dat_l0c1_en = (dat_wg_adv & ~dat_rsp_exec_sub_h[0]) |
                  (is_img_d1[12] & dat_l0c0_en & ~dat_l0c0_dummy);
    dat_l1c1_en = (dat_wg_adv & dat_rsp_exec_sub_h[0]) |
                  (is_img_d1[13] & dat_l1c0_en & ~dat_l1c0_dummy);
    dat_l1c1_hi_en = (is_img_d1[14] & dat_l1c0_en & ~dat_l1c0_dummy);
    dat_l2c1_en = (is_img_d1[15] & dat_l2c0_en & ~dat_l2c0_dummy);
    dat_l3c1_en = (is_img_d1[16] & dat_l3c0_en & ~dat_l3c0_dummy);
end

assign dat_dummy_l0_en = dat_rsp_exec_pvld & dat_rsp_exec_dummy & (dat_rsp_exec_sub_h == 2'h0);
assign dat_dummy_l1_en = dat_rsp_exec_pvld & dat_rsp_exec_dummy & (dat_rsp_exec_sub_h == 2'h1);
assign dat_dummy_l2_en = dat_rsp_exec_pvld & dat_rsp_exec_dummy & (dat_rsp_exec_sub_h == 2'h2);
assign dat_dummy_l3_en = dat_rsp_exec_pvld & dat_rsp_exec_dummy & (dat_rsp_exec_sub_h == 2'h3);

assign dat_wg_adv = sc2buf_dat_rd_valid & is_winograd_d1[11] & ~dat_rsp_pipe_sub_w_st;

assign dat_l0c0_dummy_w = dat_l0c0_en ? 1'b0 :
                          dat_dummy_l0_en ? 1'b1 :
                          dat_l0c0_dummy;
assign dat_l1c0_dummy_w = dat_l1c0_en ? 1'b0 :
                          dat_dummy_l1_en ? 1'b1 :
                          dat_l1c0_dummy;
assign dat_l2c0_dummy_w = dat_l2c0_en ? 1'b0 :
                          dat_dummy_l2_en ? 1'b1 :
                          dat_l2c0_dummy;
assign dat_l3c0_dummy_w = dat_l3c0_en ? 1'b0 :
                          dat_dummy_l3_en ? 1'b1 :
                          dat_l3c0_dummy;

assign dat_l0c1_dummy_w = dat_l0c1_en ? 1'b0 :
                          (dat_l0_set) ? dat_l0c0_dummy :
                          dat_l0c1_dummy;
assign dat_l1c1_dummy_w = dat_l1c1_en ? 1'b0 :
                          (dat_l1_set & (|sub_h_total_g2)) ? dat_l1c0_dummy :
                          dat_l1c1_dummy;
assign dat_l2c1_dummy_w = dat_l2c1_en ? 1'b0 :
                          (dat_l2_set & sub_h_total_g2[1]) ? dat_l2c0_dummy :
                          dat_l2c1_dummy;
assign dat_l3c1_dummy_w = dat_l3c1_en ? 1'b0 :
                          (dat_l3_set & sub_h_total_g2[1]) ? dat_l3c0_dummy :
                          dat_l3c1_dummy;

assign dat_l0_set = dat_l0c0_en | dat_dummy_l0_en;
assign dat_l1_set = dat_l1c0_en | dat_dummy_l1_en;
assign dat_l2_set = dat_l2c0_en | dat_dummy_l2_en;
assign dat_l3_set = dat_l3c0_en | dat_dummy_l3_en;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_l0c0_dummy <= 1'b1;
  end else begin
  dat_l0c0_dummy <= dat_l0c0_dummy_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_l1c0_dummy <= 1'b1;
  end else begin
  dat_l1c0_dummy <= dat_l1c0_dummy_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_l2c0_dummy <= 1'b1;
  end else begin
  dat_l2c0_dummy <= dat_l2c0_dummy_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_l3c0_dummy <= 1'b1;
  end else begin
  dat_l3c0_dummy <= dat_l3c0_dummy_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_l0c1_dummy <= 1'b1;
  end else begin
  dat_l0c1_dummy <= dat_l0c1_dummy_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_l1c1_dummy <= 1'b1;
  end else begin
  dat_l1c1_dummy <= dat_l1c1_dummy_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_l2c1_dummy <= 1'b1;
  end else begin
  dat_l2c1_dummy <= dat_l2c1_dummy_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_l3c1_dummy <= 1'b1;
  end else begin
  dat_l3c1_dummy <= dat_l3c1_dummy_w;
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_l0c0_en) == 1'b1) begin
    {dat_l0c0_hi, dat_l0c0_lo} <= sc2buf_dat_rd_data;
  // VCS coverage off
  end else if ((dat_l0c0_en) == 1'b0) begin
  end else begin
    {dat_l0c0_hi, dat_l0c0_lo} <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_l1c0_en) == 1'b1) begin
    dat_l1c0_lo <= sc2buf_dat_rd_data[511:0];
  // VCS coverage off
  end else if ((dat_l1c0_en) == 1'b0) begin
  end else begin
    dat_l1c0_lo <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_l1c0_hi_en) == 1'b1) begin
    dat_l1c0_hi <= sc2buf_dat_rd_data[1023:512];
  // VCS coverage off
  end else if ((dat_l1c0_hi_en) == 1'b0) begin
  end else begin
    dat_l1c0_hi <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_l2c0_en) == 1'b1) begin
    {dat_l2c0_hi, dat_l2c0_lo} <= sc2buf_dat_rd_data;
  // VCS coverage off
  end else if ((dat_l2c0_en) == 1'b0) begin
  end else begin
    {dat_l2c0_hi, dat_l2c0_lo} <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_l3c0_en) == 1'b1) begin
    {dat_l3c0_hi, dat_l3c0_lo} <= sc2buf_dat_rd_data;
  // VCS coverage off
  end else if ((dat_l3c0_en) == 1'b0) begin
  end else begin
    {dat_l3c0_hi, dat_l3c0_lo} <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_l0c1_en) == 1'b1) begin
    {dat_l0c1_hi, dat_l0c1_lo} <= {dat_l0c0_hi, dat_l0c0_lo};
  // VCS coverage off
  end else if ((dat_l0c1_en) == 1'b0) begin
  end else begin
    {dat_l0c1_hi, dat_l0c1_lo} <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_l1c1_en) == 1'b1) begin
    dat_l1c1_lo <= dat_l1c0_lo;
  // VCS coverage off
  end else if ((dat_l1c1_en) == 1'b0) begin
  end else begin
    dat_l1c1_lo <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_l1c1_hi_en) == 1'b1) begin
    dat_l1c1_hi <= dat_l1c0_hi;
  // VCS coverage off
  end else if ((dat_l1c1_hi_en) == 1'b0) begin
  end else begin
    dat_l1c1_hi <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_l2c1_en) == 1'b1) begin
    {dat_l2c1_hi, dat_l2c1_lo} <= {dat_l2c0_hi, dat_l2c0_lo};
  // VCS coverage off
  end else if ((dat_l2c1_en) == 1'b0) begin
  end else begin
    {dat_l2c1_hi, dat_l2c1_lo} <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_l3c1_en) == 1'b1) begin
    {dat_l3c1_hi, dat_l3c1_lo} <= {dat_l3c0_hi, dat_l3c0_lo};
  // VCS coverage off
  end else if ((dat_l3c1_en) == 1'b0) begin
  end else begin
    {dat_l3c1_hi, dat_l3c1_lo} <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

//////////////////////////////////////////////////////////////
///// response contorl                                   /////
//////////////////////////////////////////////////////////////


// PKT_PACK_WIRE( csc_dat_rsp_pkg ,  dat_rsp_pipe_ ,  dat_rsp_pd_d0 )
assign       dat_rsp_pd_d0[1:0] =     dat_rsp_pipe_sub_w[1:0];
assign       dat_rsp_pd_d0[3:2] =     dat_rsp_pipe_sub_h[1:0];
assign       dat_rsp_pd_d0[4] =     dat_rsp_pipe_sub_c ;
assign       dat_rsp_pd_d0[5] =     dat_rsp_pipe_ch_end ;
assign       dat_rsp_pd_d0[6] =     dat_rsp_pipe_ch_odd ;
assign       dat_rsp_pd_d0[14:7] =     dat_rsp_pipe_bytes[7:0];
assign       dat_rsp_pd_d0[16:15] =     dat_rsp_pipe_cur_sub_h[1:0];
assign       dat_rsp_pd_d0[17] =     dat_rsp_pipe_rls ;
assign       dat_rsp_pd_d0[26:18] =     dat_rsp_pipe_flag[8:0];

assign dat_rsp_pvld_d0 = dat_rsp_pipe_pvld;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pvld_d1 <= 1'b0;
  end else begin
  dat_rsp_pvld_d1 <= dat_rsp_pvld_d0;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pd_d1 <= {27{1'b0}};
  end else begin
  if ((dat_rsp_pvld_d0) == 1'b1) begin
    dat_rsp_pd_d1 <= dat_rsp_pd_d0;
  // VCS coverage off
  end else if ((dat_rsp_pvld_d0) == 1'b0) begin
  end else begin
    dat_rsp_pd_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_199x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_pvld_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pvld_d2 <= 1'b0;
  end else begin
  dat_rsp_pvld_d2 <= dat_rsp_pvld_d1;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pd_d2 <= {27{1'b0}};
  end else begin
  if ((dat_rsp_pvld_d1) == 1'b1) begin
    dat_rsp_pd_d2 <= dat_rsp_pd_d1;
  // VCS coverage off
  end else if ((dat_rsp_pvld_d1) == 1'b0) begin
  end else begin
    dat_rsp_pd_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_200x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pvld_d3 <= 1'b0;
  end else begin
  dat_rsp_pvld_d3 <= dat_rsp_pvld_d2;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pd_d3 <= {27{1'b0}};
  end else begin
  if ((dat_rsp_pvld_d2) == 1'b1) begin
    dat_rsp_pd_d3 <= dat_rsp_pd_d2;
  // VCS coverage off
  end else if ((dat_rsp_pvld_d2) == 1'b0) begin
  end else begin
    dat_rsp_pd_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_201x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_pvld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pvld_d4 <= 1'b0;
  end else begin
  dat_rsp_pvld_d4 <= dat_rsp_pvld_d3;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pd_d4 <= {27{1'b0}};
  end else begin
  if ((dat_rsp_pvld_d3) == 1'b1) begin
    dat_rsp_pd_d4 <= dat_rsp_pd_d3;
  // VCS coverage off
  end else if ((dat_rsp_pvld_d3) == 1'b0) begin
  end else begin
    dat_rsp_pd_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_202x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_rsp_pvld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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


always @(
  sub_h_total_g3
  or dat_rsp_pvld_d4
  or dat_rsp_pvld_d2
  or dat_rsp_pvld_d1
  ) begin
    dat_rsp_pvld = (sub_h_total_g3[2] & dat_rsp_pvld_d4) |
                   (sub_h_total_g3[1] & dat_rsp_pvld_d2) |
                   (sub_h_total_g3[0] & dat_rsp_pvld_d1);
end

always @(
  dat_rsp_pvld_d1
  or dat_rsp_pvld_d2
  or dat_rsp_pvld_d3
  or dat_rsp_pvld_d4
  ) begin
    dat_rsp_l0_pvld = dat_rsp_pvld_d1;
    dat_rsp_l1_pvld = dat_rsp_pvld_d2;
    dat_rsp_l2_pvld = dat_rsp_pvld_d3;
    dat_rsp_l3_pvld = dat_rsp_pvld_d4;
end

always @(
  sub_h_total_g4
  or dat_rsp_pd_d4
  or dat_rsp_pd_d2
  or dat_rsp_pd_d1
  ) begin
    dat_rsp_pd = ({27 {sub_h_total_g4[2]}} & dat_rsp_pd_d4) |
                 ({27 {sub_h_total_g4[1]}} & dat_rsp_pd_d2) |
                 ({27 {sub_h_total_g4[0]}} & dat_rsp_pd_d1);
end

always @(
  dat_rsp_pd_d1
  or dat_rsp_pd_d2
  or dat_rsp_pd_d3
  or dat_rsp_pd_d4
  ) begin
    dat_rsp_l0_ch_odd = dat_rsp_pd_d1[6:6];
    dat_rsp_l1_ch_odd = dat_rsp_pd_d2[6:6];
    dat_rsp_l2_ch_odd = dat_rsp_pd_d3[6:6];
    dat_rsp_l3_ch_odd = dat_rsp_pd_d4[6:6];
end

always @(
  dat_rsp_pd_d1
  or dat_rsp_pd_d2
  or dat_rsp_pd_d3
  or dat_rsp_pd_d4
  ) begin
    dat_rsp_l0_sub_c = dat_rsp_pd_d1[4:4];
    dat_rsp_l1_sub_c = dat_rsp_pd_d2[4:4];
    dat_rsp_l2_sub_c = dat_rsp_pd_d3[4:4];
    dat_rsp_l3_sub_c = dat_rsp_pd_d4[4:4];
end

always @(
  dat_rsp_pd_d1
  or dat_rsp_pd_d2
  or dat_rsp_pd_d3
  or dat_rsp_pd_d4
  ) begin
    dat_rsp_l0_flag = dat_rsp_pd_d1[26:18];
    dat_rsp_l1_flag = dat_rsp_pd_d2[26:18];
    dat_rsp_l2_flag = dat_rsp_pd_d3[26:18];
    dat_rsp_l3_flag = dat_rsp_pd_d4[26:18];
end

always @(
  dat_rsp_l0_flag
  or dat_rsp_l1_flag
  or dat_rsp_l2_flag
  or dat_rsp_l3_flag
  ) begin
    dat_rsp_l0_stripe_end = dat_rsp_l0_flag[6:6];
    dat_rsp_l1_stripe_end = dat_rsp_l1_flag[6:6];
    dat_rsp_l2_stripe_end = dat_rsp_l2_flag[6:6];
    dat_rsp_l3_stripe_end = dat_rsp_l3_flag[6:6];
end


// PKT_UNPACK_WIRE( csc_dat_rsp_pkg ,  dat_rsp_ ,  dat_rsp_pd )
assign        dat_rsp_sub_w[1:0] =     dat_rsp_pd[1:0];
assign        dat_rsp_sub_h[1:0] =     dat_rsp_pd[3:2];
assign         dat_rsp_sub_c  =     dat_rsp_pd[4];
assign         dat_rsp_ch_end  =     dat_rsp_pd[5];
assign         dat_rsp_ch_odd  =     dat_rsp_pd[6];
assign        dat_rsp_bytes[7:0] =     dat_rsp_pd[14:7];
assign        dat_rsp_cur_sub_h[1:0] =     dat_rsp_pd[16:15];
assign         dat_rsp_rls  =     dat_rsp_pd[17];
assign        dat_rsp_flag[8:0] =     dat_rsp_pd[26:18];

// PKT_UNPACK_WIRE( nvdla_stripe_info ,  dat_rsp_ ,  dat_rsp_flag )
assign        dat_rsp_batch_index[4:0] =     dat_rsp_flag[4:0];
assign         dat_rsp_stripe_st  =     dat_rsp_flag[5];
assign         dat_rsp_stripe_end  =     dat_rsp_flag[6];
assign         dat_rsp_channel_end  =     dat_rsp_flag[7];
assign         dat_rsp_layer_end  =     dat_rsp_flag[8];


assign rsp_sft_cnt_l0_sub = dat_l0c0_en ? 8'h80 : 8'h0;
assign rsp_sft_cnt_l1_sub = dat_l1c0_en ? 8'h80 : 8'h0;
assign rsp_sft_cnt_l2_sub = dat_l2c0_en ? 8'h80 : 8'h0;
assign rsp_sft_cnt_l3_sub = dat_l3c0_en ? 8'h80 : 8'h0;

always @(
  rsp_sft_cnt_l0
  or pixel_x_byte_stride
  or rsp_sft_cnt_l0_sub
  ) begin
    {mon_rsp_sft_cnt_l0_w,
     rsp_sft_cnt_l0_inc} = rsp_sft_cnt_l0 + pixel_x_byte_stride - rsp_sft_cnt_l0_sub;
end

always @(
  rsp_sft_cnt_l1
  or pixel_x_byte_stride
  or rsp_sft_cnt_l1_sub
  ) begin
    {mon_rsp_sft_cnt_l1_w,
     rsp_sft_cnt_l1_inc} = rsp_sft_cnt_l1 + pixel_x_byte_stride - rsp_sft_cnt_l1_sub;
end

always @(
  rsp_sft_cnt_l2
  or pixel_x_byte_stride
  or rsp_sft_cnt_l2_sub
  ) begin
    {mon_rsp_sft_cnt_l2_w,
     rsp_sft_cnt_l2_inc} = rsp_sft_cnt_l2 + pixel_x_byte_stride - rsp_sft_cnt_l2_sub;
end

always @(
  rsp_sft_cnt_l3
  or pixel_x_byte_stride
  or rsp_sft_cnt_l3_sub
  ) begin
    {mon_rsp_sft_cnt_l3_w,
     rsp_sft_cnt_l3_inc} = rsp_sft_cnt_l3 + pixel_x_byte_stride - rsp_sft_cnt_l3_sub;
end

assign dat_rsp_l0_block_end = dat_rsp_l0_sub_c;
assign dat_rsp_l1_block_end = dat_rsp_l1_sub_c;
assign dat_rsp_l2_block_end = dat_rsp_l2_sub_c;
assign dat_rsp_l3_block_end = dat_rsp_l3_sub_c;

always @(
  layer_st
  or dat_rsp_l0_stripe_end
  or dat_rsp_l0_block_end
  or rsp_sft_cnt_l0_ori
  or dat_rsp_l0_ch_odd
  or dat_dummy_l0_en
  or rsp_sft_cnt_l0_inc
  ) begin
    rsp_sft_cnt_l0_w = (layer_st) ? 8'h80 :
                       (dat_rsp_l0_stripe_end & ~dat_rsp_l0_block_end) ? rsp_sft_cnt_l0_ori :
                       (dat_rsp_l0_stripe_end & dat_rsp_l0_block_end & dat_rsp_l0_ch_odd) ? 8'hc0 :
                       (dat_rsp_l0_stripe_end & dat_rsp_l0_block_end & ~dat_rsp_l0_ch_odd) ? 8'h80 :
                       (dat_dummy_l0_en) ? (rsp_sft_cnt_l0_inc & 8'h7f) :
                       rsp_sft_cnt_l0_inc;
end

always @(
  layer_st
  or dat_rsp_l1_stripe_end
  or dat_rsp_l1_block_end
  or rsp_sft_cnt_l1_ori
  or dat_rsp_l1_ch_odd
  or dat_dummy_l1_en
  or rsp_sft_cnt_l1_inc
  ) begin
    rsp_sft_cnt_l1_w = (layer_st) ? 8'h80 :
                       (dat_rsp_l1_stripe_end & ~dat_rsp_l1_block_end) ? rsp_sft_cnt_l1_ori :
                       (dat_rsp_l1_stripe_end & dat_rsp_l1_block_end & dat_rsp_l1_ch_odd) ? 8'hc0 :
                       (dat_rsp_l1_stripe_end & dat_rsp_l1_block_end & ~dat_rsp_l1_ch_odd) ? 8'h80 :
                       (dat_dummy_l1_en) ? (rsp_sft_cnt_l1_inc & 8'h7f) :
                       rsp_sft_cnt_l1_inc;
end

always @(
  layer_st
  or dat_rsp_l2_stripe_end
  or dat_rsp_l2_block_end
  or rsp_sft_cnt_l2_ori
  or dat_rsp_l2_ch_odd
  or dat_dummy_l2_en
  or rsp_sft_cnt_l2_inc
  ) begin
    rsp_sft_cnt_l2_w = (layer_st) ? 8'h80 :
                       (dat_rsp_l2_stripe_end & ~dat_rsp_l2_block_end) ? rsp_sft_cnt_l2_ori :
                       (dat_rsp_l2_stripe_end & dat_rsp_l2_block_end & dat_rsp_l2_ch_odd) ? 8'hc0 :
                       (dat_rsp_l2_stripe_end & dat_rsp_l2_block_end & ~dat_rsp_l2_ch_odd) ? 8'h80 :
                       (dat_dummy_l2_en) ? (rsp_sft_cnt_l2_inc & 8'h7f) :
                       rsp_sft_cnt_l2_inc;
end

always @(
  layer_st
  or dat_rsp_l3_stripe_end
  or dat_rsp_l3_block_end
  or rsp_sft_cnt_l3_ori
  or dat_rsp_l3_ch_odd
  or dat_dummy_l3_en
  or rsp_sft_cnt_l3_inc
  ) begin
    rsp_sft_cnt_l3_w = (layer_st) ? 8'h80 :
                       (dat_rsp_l3_stripe_end & ~dat_rsp_l3_block_end) ? rsp_sft_cnt_l3_ori :
                       (dat_rsp_l3_stripe_end & dat_rsp_l3_block_end & dat_rsp_l3_ch_odd) ? 8'hc0 :
                       (dat_rsp_l3_stripe_end & dat_rsp_l3_block_end & ~dat_rsp_l3_ch_odd) ? 8'h80 :
                       (dat_dummy_l3_en) ? (rsp_sft_cnt_l3_inc & 8'h7f) :
                       rsp_sft_cnt_l3_inc;
end

always @(
  layer_st
  or is_img_d1
  or dat_rsp_l0_pvld
  or dat_rsp_l1_pvld
  or sub_h_total_g5
  or dat_rsp_l2_pvld
  or dat_rsp_l3_pvld
  ) begin
    rsp_sft_cnt_l0_en = layer_st | (is_img_d1[17] & dat_rsp_l0_pvld);
    rsp_sft_cnt_l1_en = layer_st | (is_img_d1[18] & dat_rsp_l1_pvld & (sub_h_total_g5 != 3'h1));
    rsp_sft_cnt_l2_en = layer_st | (is_img_d1[19] & dat_rsp_l2_pvld & (sub_h_total_g5 == 3'h4));
    rsp_sft_cnt_l3_en = layer_st | (is_img_d1[20] & dat_rsp_l3_pvld & (sub_h_total_g5 == 3'h4));
end

always @(
  layer_st
  or is_img_d1
  or dat_rsp_l0_pvld
  or dat_rsp_l0_stripe_end
  or dat_rsp_l0_block_end
  or dat_rsp_l1_pvld
  or dat_rsp_l1_stripe_end
  or dat_rsp_l1_block_end
  or sub_h_total_g6
  or dat_rsp_l2_pvld
  or dat_rsp_l2_stripe_end
  or dat_rsp_l2_block_end
  or dat_rsp_l3_pvld
  or dat_rsp_l3_stripe_end
  or dat_rsp_l3_block_end
  ) begin
    rsp_sft_cnt_l0_ori_en = layer_st | (is_img_d1[21] & dat_rsp_l0_pvld & dat_rsp_l0_stripe_end & dat_rsp_l0_block_end);
    rsp_sft_cnt_l1_ori_en = layer_st | (is_img_d1[22] & dat_rsp_l1_pvld & dat_rsp_l1_stripe_end & dat_rsp_l1_block_end & (sub_h_total_g6 != 3'h1));
    rsp_sft_cnt_l2_ori_en = layer_st | (is_img_d1[23] & dat_rsp_l2_pvld & dat_rsp_l2_stripe_end & dat_rsp_l2_block_end & (sub_h_total_g6 == 3'h4));
    rsp_sft_cnt_l3_ori_en = layer_st | (is_img_d1[24] & dat_rsp_l3_pvld & dat_rsp_l3_stripe_end & dat_rsp_l3_block_end & (sub_h_total_g6 == 3'h4));
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_sft_cnt_l0 <= {8{1'b0}};
  end else begin
  if ((rsp_sft_cnt_l0_en) == 1'b1) begin
    rsp_sft_cnt_l0 <= rsp_sft_cnt_l0_w;
  // VCS coverage off
  end else if ((rsp_sft_cnt_l0_en) == 1'b0) begin
  end else begin
    rsp_sft_cnt_l0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_203x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_sft_cnt_l0_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_sft_cnt_l1 <= {8{1'b0}};
  end else begin
  if ((rsp_sft_cnt_l1_en) == 1'b1) begin
    rsp_sft_cnt_l1 <= rsp_sft_cnt_l1_w;
  // VCS coverage off
  end else if ((rsp_sft_cnt_l1_en) == 1'b0) begin
  end else begin
    rsp_sft_cnt_l1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_204x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_sft_cnt_l1_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_sft_cnt_l2 <= {8{1'b0}};
  end else begin
  if ((rsp_sft_cnt_l2_en) == 1'b1) begin
    rsp_sft_cnt_l2 <= rsp_sft_cnt_l2_w;
  // VCS coverage off
  end else if ((rsp_sft_cnt_l2_en) == 1'b0) begin
  end else begin
    rsp_sft_cnt_l2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_205x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_sft_cnt_l2_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_sft_cnt_l3 <= {8{1'b0}};
  end else begin
  if ((rsp_sft_cnt_l3_en) == 1'b1) begin
    rsp_sft_cnt_l3 <= rsp_sft_cnt_l3_w;
  // VCS coverage off
  end else if ((rsp_sft_cnt_l3_en) == 1'b0) begin
  end else begin
    rsp_sft_cnt_l3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_206x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_sft_cnt_l3_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_sft_cnt_l0_ori <= {8{1'b0}};
  end else begin
  if ((rsp_sft_cnt_l0_ori_en) == 1'b1) begin
    rsp_sft_cnt_l0_ori <= rsp_sft_cnt_l0_w;
  // VCS coverage off
  end else if ((rsp_sft_cnt_l0_ori_en) == 1'b0) begin
  end else begin
    rsp_sft_cnt_l0_ori <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_207x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_sft_cnt_l0_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_sft_cnt_l1_ori <= {8{1'b0}};
  end else begin
  if ((rsp_sft_cnt_l1_ori_en) == 1'b1) begin
    rsp_sft_cnt_l1_ori <= rsp_sft_cnt_l1_w;
  // VCS coverage off
  end else if ((rsp_sft_cnt_l1_ori_en) == 1'b0) begin
  end else begin
    rsp_sft_cnt_l1_ori <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_208x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_sft_cnt_l1_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_sft_cnt_l2_ori <= {8{1'b0}};
  end else begin
  if ((rsp_sft_cnt_l2_ori_en) == 1'b1) begin
    rsp_sft_cnt_l2_ori <= rsp_sft_cnt_l2_w;
  // VCS coverage off
  end else if ((rsp_sft_cnt_l2_ori_en) == 1'b0) begin
  end else begin
    rsp_sft_cnt_l2_ori <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_209x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_sft_cnt_l2_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rsp_sft_cnt_l3_ori <= {8{1'b0}};
  end else begin
  if ((rsp_sft_cnt_l3_ori_en) == 1'b1) begin
    rsp_sft_cnt_l3_ori <= rsp_sft_cnt_l3_w;
  // VCS coverage off
  end else if ((rsp_sft_cnt_l3_ori_en) == 1'b0) begin
  end else begin
    rsp_sft_cnt_l3_ori <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_210x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(rsp_sft_cnt_l3_ori_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////////////////////////////////
///// response data                                      /////
//////////////////////////////////////////////////////////////
//////////////// data for winograd ////////////////

//6x6x8byte matrix
always @(
  is_winograd_d1
  or dat_l1c0_lo
  or dat_l1c1_lo
  or dat_l0c0_hi
  or dat_l0c1_hi
  or dat_l0c0_lo
  or dat_l0c1_lo
  ) begin
    dat_wg = ~is_winograd_d1[12] ? 2304'b0 :
             {dat_l1c0_lo[511:256], dat_l1c1_lo[511:384],
              dat_l1c0_lo[255:0], dat_l1c1_lo[255:128],
              dat_l0c0_hi[511:256], dat_l0c1_hi[511:384],
              dat_l0c0_hi[255:0], dat_l0c1_hi[255:128],
              dat_l0c0_lo[511:256], dat_l0c1_lo[511:384],
              dat_l0c0_lo[255:0], dat_l0c1_lo[255:128]};
end

always @(
  dat_rsp_sub_h
  or dat_rsp_sub_w
  ) begin
    dat_rsp_wg_sel_lt = (~dat_rsp_sub_h[0] & ~dat_rsp_sub_w[0]);
    dat_rsp_wg_sel_lb = (dat_rsp_sub_h[0] & ~dat_rsp_sub_w[0]);
    dat_rsp_wg_sel_rt = (~dat_rsp_sub_h[0] & dat_rsp_sub_w[0]);
    dat_rsp_wg_sel_rb = (dat_rsp_sub_h[0] & dat_rsp_sub_w[0]);
end

always @(
  is_int8_d1
  or dat_rsp_sub_c
  ) begin
    dat_rsp_wg_sel_16b = ~is_int8_d1[5];
    dat_rsp_wg_sel_8b_lo = is_int8_d1[6] & ~dat_rsp_sub_c;
    dat_rsp_wg_sel_8b_hi = is_int8_d1[7] & dat_rsp_sub_c;
end

always @(
  dat_wg
  ) begin
    dat_rsp_wg_lt = {dat_wg[1535:1280], dat_wg[1151:896], dat_wg[767:512], dat_wg[383:128]};
    dat_rsp_wg_lb = {dat_wg[2303:2048], dat_wg[1919:1664], dat_wg[1535:1280], dat_wg[1151:896]};
    dat_rsp_wg_rt = {dat_wg[1407:1152], dat_wg[1023:768], dat_wg[639:384], dat_wg[255:0]};
    dat_rsp_wg_rb = {dat_wg[2175:1920], dat_wg[1791:1536], dat_wg[1407:1152], dat_wg[1023:768]};
end

always @(
  dat_rsp_wg_sel_lt
  or dat_rsp_wg_lt
  or dat_rsp_wg_sel_lb
  or dat_rsp_wg_lb
  or dat_rsp_wg_sel_rt
  or dat_rsp_wg_rt
  or dat_rsp_wg_sel_rb
  or dat_rsp_wg_rb
  ) begin
    dat_rsp_wg = ({1024{dat_rsp_wg_sel_lt}} & dat_rsp_wg_lt) |
                 ({1024{dat_rsp_wg_sel_lb}} & dat_rsp_wg_lb) |
                 ({1024{dat_rsp_wg_sel_rt}} & dat_rsp_wg_rt) |
                 ({1024{dat_rsp_wg_sel_rb}} & dat_rsp_wg_rb);
end

`ifdef NVDLA_PRINT_WINOGRAD
always @ (posedge nvdla_core_clk)
begin
    if(dat_rsp_pra_en)
    begin
        $display("[NVDLA WINOGRAD] data_pre_pra_remap  = %01024h", dat_rsp_wg);
        $display("[NVDLA WINOGRAD] data_post_pra_remap = %01024h", {dat_rsp_wg_ch3, dat_rsp_wg_ch2, dat_rsp_wg_ch1, dat_rsp_wg_ch0});
    end
end

always @ (posedge nvdla_core_clk)
begin
    if(|mon_dat_out_pra_vld)
    begin
        $display("[NVDLA WINOGRAD] data_pra_out_ch0 = %0256h", dat_pra_dat_ch0);
        $display("[NVDLA WINOGRAD] data_pra_out_ch1 = %0256h", dat_pra_dat_ch1);
        $display("[NVDLA WINOGRAD] data_pra_out_ch2 = %0256h", dat_pra_dat_ch2);
        $display("[NVDLA WINOGRAD] data_pra_out_ch3 = %0256h", dat_pra_dat_ch3);
    end
end
`endif

assign dat_wg_16b_ch0 = {dat_rsp_wg[15*64+15:15*64], dat_rsp_wg[14*64+15:14*64], dat_rsp_wg[13*64+15:13*64], dat_rsp_wg[12*64+15:12*64], dat_rsp_wg[11*64+15:11*64], dat_rsp_wg[10*64+15:10*64], dat_rsp_wg[9*64+15:9*64], dat_rsp_wg[8*64+15:8*64], dat_rsp_wg[7*64+15:7*64], dat_rsp_wg[6*64+15:6*64], dat_rsp_wg[5*64+15:5*64], dat_rsp_wg[4*64+15:4*64], dat_rsp_wg[3*64+15:3*64], dat_rsp_wg[2*64+15:2*64], dat_rsp_wg[1*64+15:1*64], dat_rsp_wg[0*64+15:0*64]};
assign dat_wg_16b_ch1 = {dat_rsp_wg[15*64+31:15*64+16], dat_rsp_wg[14*64+31:14*64+16], dat_rsp_wg[13*64+31:13*64+16], dat_rsp_wg[12*64+31:12*64+16], dat_rsp_wg[11*64+31:11*64+16], dat_rsp_wg[10*64+31:10*64+16], dat_rsp_wg[9*64+31:9*64+16], dat_rsp_wg[8*64+31:8*64+16], dat_rsp_wg[7*64+31:7*64+16], dat_rsp_wg[6*64+31:6*64+16], dat_rsp_wg[5*64+31:5*64+16], dat_rsp_wg[4*64+31:4*64+16], dat_rsp_wg[3*64+31:3*64+16], dat_rsp_wg[2*64+31:2*64+16], dat_rsp_wg[1*64+31:1*64+16], dat_rsp_wg[0*64+31:0*64+16]};
assign dat_wg_16b_ch2 = {dat_rsp_wg[15*64+47:15*64+32], dat_rsp_wg[14*64+47:14*64+32], dat_rsp_wg[13*64+47:13*64+32], dat_rsp_wg[12*64+47:12*64+32], dat_rsp_wg[11*64+47:11*64+32], dat_rsp_wg[10*64+47:10*64+32], dat_rsp_wg[9*64+47:9*64+32], dat_rsp_wg[8*64+47:8*64+32], dat_rsp_wg[7*64+47:7*64+32], dat_rsp_wg[6*64+47:6*64+32], dat_rsp_wg[5*64+47:5*64+32], dat_rsp_wg[4*64+47:4*64+32], dat_rsp_wg[3*64+47:3*64+32], dat_rsp_wg[2*64+47:2*64+32], dat_rsp_wg[1*64+47:1*64+32], dat_rsp_wg[0*64+47:0*64+32]};
assign dat_wg_16b_ch3 = {dat_rsp_wg[15*64+63:15*64+48], dat_rsp_wg[14*64+63:14*64+48], dat_rsp_wg[13*64+63:13*64+48], dat_rsp_wg[12*64+63:12*64+48], dat_rsp_wg[11*64+63:11*64+48], dat_rsp_wg[10*64+63:10*64+48], dat_rsp_wg[9*64+63:9*64+48], dat_rsp_wg[8*64+63:8*64+48], dat_rsp_wg[7*64+63:7*64+48], dat_rsp_wg[6*64+63:6*64+48], dat_rsp_wg[5*64+63:5*64+48], dat_rsp_wg[4*64+63:4*64+48], dat_rsp_wg[3*64+63:3*64+48], dat_rsp_wg[2*64+63:2*64+48], dat_rsp_wg[1*64+63:1*64+48], dat_rsp_wg[0*64+63:0*64+48]};

assign dat_wg_8b_ch0 = {{8{dat_rsp_wg[15*64+ 7]}}, dat_rsp_wg[15*64+7:15*64], {8{dat_rsp_wg[14*64+ 7]}}, dat_rsp_wg[14*64+7:14*64], {8{dat_rsp_wg[13*64+ 7]}}, dat_rsp_wg[13*64+7:13*64], {8{dat_rsp_wg[12*64+ 7]}}, dat_rsp_wg[12*64+7:12*64], {8{dat_rsp_wg[11*64+ 7]}}, dat_rsp_wg[11*64+7:11*64], {8{dat_rsp_wg[10*64+ 7]}}, dat_rsp_wg[10*64+7:10*64], {8{dat_rsp_wg[9*64+ 7]}}, dat_rsp_wg[9*64+7:9*64], {8{dat_rsp_wg[8*64+ 7]}}, dat_rsp_wg[8*64+7:8*64], {8{dat_rsp_wg[7*64+ 7]}}, dat_rsp_wg[7*64+7:7*64], {8{dat_rsp_wg[6*64+ 7]}}, dat_rsp_wg[6*64+7:6*64], {8{dat_rsp_wg[5*64+ 7]}}, dat_rsp_wg[5*64+7:5*64], {8{dat_rsp_wg[4*64+ 7]}}, dat_rsp_wg[4*64+7:4*64], {8{dat_rsp_wg[3*64+ 7]}}, dat_rsp_wg[3*64+7:3*64], {8{dat_rsp_wg[2*64+ 7]}}, dat_rsp_wg[2*64+7:2*64], {8{dat_rsp_wg[1*64+ 7]}}, dat_rsp_wg[1*64+7:1*64], {8{dat_rsp_wg[0*64+ 7]}}, dat_rsp_wg[0*64+7:0*64]};
assign dat_wg_8b_ch1 = {{8{dat_rsp_wg[15*64+15]}}, dat_rsp_wg[15*64+15:15*64+8], {8{dat_rsp_wg[14*64+15]}}, dat_rsp_wg[14*64+15:14*64+8], {8{dat_rsp_wg[13*64+15]}}, dat_rsp_wg[13*64+15:13*64+8], {8{dat_rsp_wg[12*64+15]}}, dat_rsp_wg[12*64+15:12*64+8], {8{dat_rsp_wg[11*64+15]}}, dat_rsp_wg[11*64+15:11*64+8], {8{dat_rsp_wg[10*64+15]}}, dat_rsp_wg[10*64+15:10*64+8], {8{dat_rsp_wg[9*64+15]}}, dat_rsp_wg[9*64+15:9*64+8], {8{dat_rsp_wg[8*64+15]}}, dat_rsp_wg[8*64+15:8*64+8], {8{dat_rsp_wg[7*64+15]}}, dat_rsp_wg[7*64+15:7*64+8], {8{dat_rsp_wg[6*64+15]}}, dat_rsp_wg[6*64+15:6*64+8], {8{dat_rsp_wg[5*64+15]}}, dat_rsp_wg[5*64+15:5*64+8], {8{dat_rsp_wg[4*64+15]}}, dat_rsp_wg[4*64+15:4*64+8], {8{dat_rsp_wg[3*64+15]}}, dat_rsp_wg[3*64+15:3*64+8], {8{dat_rsp_wg[2*64+15]}}, dat_rsp_wg[2*64+15:2*64+8], {8{dat_rsp_wg[1*64+15]}}, dat_rsp_wg[1*64+15:1*64+8], {8{dat_rsp_wg[0*64+15]}}, dat_rsp_wg[0*64+15:0*64+8]};
assign dat_wg_8b_ch2 = {{8{dat_rsp_wg[15*64+23]}}, dat_rsp_wg[15*64+23:15*64+16], {8{dat_rsp_wg[14*64+23]}}, dat_rsp_wg[14*64+23:14*64+16], {8{dat_rsp_wg[13*64+23]}}, dat_rsp_wg[13*64+23:13*64+16], {8{dat_rsp_wg[12*64+23]}}, dat_rsp_wg[12*64+23:12*64+16], {8{dat_rsp_wg[11*64+23]}}, dat_rsp_wg[11*64+23:11*64+16], {8{dat_rsp_wg[10*64+23]}}, dat_rsp_wg[10*64+23:10*64+16], {8{dat_rsp_wg[9*64+23]}}, dat_rsp_wg[9*64+23:9*64+16], {8{dat_rsp_wg[8*64+23]}}, dat_rsp_wg[8*64+23:8*64+16], {8{dat_rsp_wg[7*64+23]}}, dat_rsp_wg[7*64+23:7*64+16], {8{dat_rsp_wg[6*64+23]}}, dat_rsp_wg[6*64+23:6*64+16], {8{dat_rsp_wg[5*64+23]}}, dat_rsp_wg[5*64+23:5*64+16], {8{dat_rsp_wg[4*64+23]}}, dat_rsp_wg[4*64+23:4*64+16], {8{dat_rsp_wg[3*64+23]}}, dat_rsp_wg[3*64+23:3*64+16], {8{dat_rsp_wg[2*64+23]}}, dat_rsp_wg[2*64+23:2*64+16], {8{dat_rsp_wg[1*64+23]}}, dat_rsp_wg[1*64+23:1*64+16], {8{dat_rsp_wg[0*64+23]}}, dat_rsp_wg[0*64+23:0*64+16]};
assign dat_wg_8b_ch3 = {{8{dat_rsp_wg[15*64+31]}}, dat_rsp_wg[15*64+31:15*64+24], {8{dat_rsp_wg[14*64+31]}}, dat_rsp_wg[14*64+31:14*64+24], {8{dat_rsp_wg[13*64+31]}}, dat_rsp_wg[13*64+31:13*64+24], {8{dat_rsp_wg[12*64+31]}}, dat_rsp_wg[12*64+31:12*64+24], {8{dat_rsp_wg[11*64+31]}}, dat_rsp_wg[11*64+31:11*64+24], {8{dat_rsp_wg[10*64+31]}}, dat_rsp_wg[10*64+31:10*64+24], {8{dat_rsp_wg[9*64+31]}}, dat_rsp_wg[9*64+31:9*64+24], {8{dat_rsp_wg[8*64+31]}}, dat_rsp_wg[8*64+31:8*64+24], {8{dat_rsp_wg[7*64+31]}}, dat_rsp_wg[7*64+31:7*64+24], {8{dat_rsp_wg[6*64+31]}}, dat_rsp_wg[6*64+31:6*64+24], {8{dat_rsp_wg[5*64+31]}}, dat_rsp_wg[5*64+31:5*64+24], {8{dat_rsp_wg[4*64+31]}}, dat_rsp_wg[4*64+31:4*64+24], {8{dat_rsp_wg[3*64+31]}}, dat_rsp_wg[3*64+31:3*64+24], {8{dat_rsp_wg[2*64+31]}}, dat_rsp_wg[2*64+31:2*64+24], {8{dat_rsp_wg[1*64+31]}}, dat_rsp_wg[1*64+31:1*64+24], {8{dat_rsp_wg[0*64+31]}}, dat_rsp_wg[0*64+31:0*64+24]};
assign dat_wg_8b_ch4 = {{8{dat_rsp_wg[15*64+39]}}, dat_rsp_wg[15*64+39:15*64+32], {8{dat_rsp_wg[14*64+39]}}, dat_rsp_wg[14*64+39:14*64+32], {8{dat_rsp_wg[13*64+39]}}, dat_rsp_wg[13*64+39:13*64+32], {8{dat_rsp_wg[12*64+39]}}, dat_rsp_wg[12*64+39:12*64+32], {8{dat_rsp_wg[11*64+39]}}, dat_rsp_wg[11*64+39:11*64+32], {8{dat_rsp_wg[10*64+39]}}, dat_rsp_wg[10*64+39:10*64+32], {8{dat_rsp_wg[9*64+39]}}, dat_rsp_wg[9*64+39:9*64+32], {8{dat_rsp_wg[8*64+39]}}, dat_rsp_wg[8*64+39:8*64+32], {8{dat_rsp_wg[7*64+39]}}, dat_rsp_wg[7*64+39:7*64+32], {8{dat_rsp_wg[6*64+39]}}, dat_rsp_wg[6*64+39:6*64+32], {8{dat_rsp_wg[5*64+39]}}, dat_rsp_wg[5*64+39:5*64+32], {8{dat_rsp_wg[4*64+39]}}, dat_rsp_wg[4*64+39:4*64+32], {8{dat_rsp_wg[3*64+39]}}, dat_rsp_wg[3*64+39:3*64+32], {8{dat_rsp_wg[2*64+39]}}, dat_rsp_wg[2*64+39:2*64+32], {8{dat_rsp_wg[1*64+39]}}, dat_rsp_wg[1*64+39:1*64+32], {8{dat_rsp_wg[0*64+39]}}, dat_rsp_wg[0*64+39:0*64+32]};
assign dat_wg_8b_ch5 = {{8{dat_rsp_wg[15*64+47]}}, dat_rsp_wg[15*64+47:15*64+40], {8{dat_rsp_wg[14*64+47]}}, dat_rsp_wg[14*64+47:14*64+40], {8{dat_rsp_wg[13*64+47]}}, dat_rsp_wg[13*64+47:13*64+40], {8{dat_rsp_wg[12*64+47]}}, dat_rsp_wg[12*64+47:12*64+40], {8{dat_rsp_wg[11*64+47]}}, dat_rsp_wg[11*64+47:11*64+40], {8{dat_rsp_wg[10*64+47]}}, dat_rsp_wg[10*64+47:10*64+40], {8{dat_rsp_wg[9*64+47]}}, dat_rsp_wg[9*64+47:9*64+40], {8{dat_rsp_wg[8*64+47]}}, dat_rsp_wg[8*64+47:8*64+40], {8{dat_rsp_wg[7*64+47]}}, dat_rsp_wg[7*64+47:7*64+40], {8{dat_rsp_wg[6*64+47]}}, dat_rsp_wg[6*64+47:6*64+40], {8{dat_rsp_wg[5*64+47]}}, dat_rsp_wg[5*64+47:5*64+40], {8{dat_rsp_wg[4*64+47]}}, dat_rsp_wg[4*64+47:4*64+40], {8{dat_rsp_wg[3*64+47]}}, dat_rsp_wg[3*64+47:3*64+40], {8{dat_rsp_wg[2*64+47]}}, dat_rsp_wg[2*64+47:2*64+40], {8{dat_rsp_wg[1*64+47]}}, dat_rsp_wg[1*64+47:1*64+40], {8{dat_rsp_wg[0*64+47]}}, dat_rsp_wg[0*64+47:0*64+40]};
assign dat_wg_8b_ch6 = {{8{dat_rsp_wg[15*64+55]}}, dat_rsp_wg[15*64+55:15*64+48], {8{dat_rsp_wg[14*64+55]}}, dat_rsp_wg[14*64+55:14*64+48], {8{dat_rsp_wg[13*64+55]}}, dat_rsp_wg[13*64+55:13*64+48], {8{dat_rsp_wg[12*64+55]}}, dat_rsp_wg[12*64+55:12*64+48], {8{dat_rsp_wg[11*64+55]}}, dat_rsp_wg[11*64+55:11*64+48], {8{dat_rsp_wg[10*64+55]}}, dat_rsp_wg[10*64+55:10*64+48], {8{dat_rsp_wg[9*64+55]}}, dat_rsp_wg[9*64+55:9*64+48], {8{dat_rsp_wg[8*64+55]}}, dat_rsp_wg[8*64+55:8*64+48], {8{dat_rsp_wg[7*64+55]}}, dat_rsp_wg[7*64+55:7*64+48], {8{dat_rsp_wg[6*64+55]}}, dat_rsp_wg[6*64+55:6*64+48], {8{dat_rsp_wg[5*64+55]}}, dat_rsp_wg[5*64+55:5*64+48], {8{dat_rsp_wg[4*64+55]}}, dat_rsp_wg[4*64+55:4*64+48], {8{dat_rsp_wg[3*64+55]}}, dat_rsp_wg[3*64+55:3*64+48], {8{dat_rsp_wg[2*64+55]}}, dat_rsp_wg[2*64+55:2*64+48], {8{dat_rsp_wg[1*64+55]}}, dat_rsp_wg[1*64+55:1*64+48], {8{dat_rsp_wg[0*64+55]}}, dat_rsp_wg[0*64+55:0*64+48]};
assign dat_wg_8b_ch7 = {{8{dat_rsp_wg[15*64+63]}}, dat_rsp_wg[15*64+63:15*64+56], {8{dat_rsp_wg[14*64+63]}}, dat_rsp_wg[14*64+63:14*64+56], {8{dat_rsp_wg[13*64+63]}}, dat_rsp_wg[13*64+63:13*64+56], {8{dat_rsp_wg[12*64+63]}}, dat_rsp_wg[12*64+63:12*64+56], {8{dat_rsp_wg[11*64+63]}}, dat_rsp_wg[11*64+63:11*64+56], {8{dat_rsp_wg[10*64+63]}}, dat_rsp_wg[10*64+63:10*64+56], {8{dat_rsp_wg[9*64+63]}}, dat_rsp_wg[9*64+63:9*64+56], {8{dat_rsp_wg[8*64+63]}}, dat_rsp_wg[8*64+63:8*64+56], {8{dat_rsp_wg[7*64+63]}}, dat_rsp_wg[7*64+63:7*64+56], {8{dat_rsp_wg[6*64+63]}}, dat_rsp_wg[6*64+63:6*64+56], {8{dat_rsp_wg[5*64+63]}}, dat_rsp_wg[5*64+63:5*64+56], {8{dat_rsp_wg[4*64+63]}}, dat_rsp_wg[4*64+63:4*64+56], {8{dat_rsp_wg[3*64+63]}}, dat_rsp_wg[3*64+63:3*64+56], {8{dat_rsp_wg[2*64+63]}}, dat_rsp_wg[2*64+63:2*64+56], {8{dat_rsp_wg[1*64+63]}}, dat_rsp_wg[1*64+63:1*64+56], {8{dat_rsp_wg[0*64+63]}}, dat_rsp_wg[0*64+63:0*64+56]};

always @(
  dat_rsp_wg_sel_16b
  or dat_wg_16b_ch0
  or dat_rsp_wg_sel_8b_lo
  or dat_wg_8b_ch0
  or dat_rsp_wg_sel_8b_hi
  or dat_wg_8b_ch4
  ) begin
    dat_rsp_wg_ch0 = ({256{dat_rsp_wg_sel_16b}} & dat_wg_16b_ch0) |
                     ({256{dat_rsp_wg_sel_8b_lo}} & dat_wg_8b_ch0) |
                     ({256{dat_rsp_wg_sel_8b_hi}} & dat_wg_8b_ch4);
end

always @(
  dat_rsp_wg_sel_16b
  or dat_wg_16b_ch1
  or dat_rsp_wg_sel_8b_lo
  or dat_wg_8b_ch1
  or dat_rsp_wg_sel_8b_hi
  or dat_wg_8b_ch5
  ) begin
    dat_rsp_wg_ch1 = ({256{dat_rsp_wg_sel_16b}} & dat_wg_16b_ch1) |
                     ({256{dat_rsp_wg_sel_8b_lo}} & dat_wg_8b_ch1) |
                     ({256{dat_rsp_wg_sel_8b_hi}} & dat_wg_8b_ch5);
end

always @(
  dat_rsp_wg_sel_16b
  or dat_wg_16b_ch2
  or dat_rsp_wg_sel_8b_lo
  or dat_wg_8b_ch2
  or dat_rsp_wg_sel_8b_hi
  or dat_wg_8b_ch6
  ) begin
    dat_rsp_wg_ch2 = ({256{dat_rsp_wg_sel_16b}} & dat_wg_16b_ch2) |
                     ({256{dat_rsp_wg_sel_8b_lo}} & dat_wg_8b_ch2) |
                     ({256{dat_rsp_wg_sel_8b_hi}} & dat_wg_8b_ch6);
end

always @(
  dat_rsp_wg_sel_16b
  or dat_wg_16b_ch3
  or dat_rsp_wg_sel_8b_lo
  or dat_wg_8b_ch3
  or dat_rsp_wg_sel_8b_hi
  or dat_wg_8b_ch7
  ) begin
    dat_rsp_wg_ch3 = ({256{dat_rsp_wg_sel_16b}} & dat_wg_16b_ch3) |
                     ({256{dat_rsp_wg_sel_8b_lo}} & dat_wg_8b_ch3) |
                     ({256{dat_rsp_wg_sel_8b_hi}} & dat_wg_8b_ch7);
end

//////////////// data for convlution ////////////////
always @(
  is_int8_d1
  or pad_value
  ) begin
    dat_rsp_pad_value = is_int8_d1[8] ? {64{pad_value[7:0]}} : {32{pad_value}};
end

always @(
  dat_l0c0_dummy
  or dat_rsp_pad_value
  or dat_l0c0_lo
  or dat_l0c0_hi
  or dat_l1c0_dummy
  or dat_l1c0_lo
  or dat_l1c0_hi
  or dat_l2c0_dummy
  or dat_l2c0_lo
  or dat_l2c0_hi
  or dat_l3c0_dummy
  or dat_l3c0_lo
  or dat_l3c0_hi
  ) begin
    dat_rsp_l0c0_lo = dat_l0c0_dummy ? dat_rsp_pad_value : dat_l0c0_lo;
    dat_rsp_l0c0_hi = dat_l0c0_dummy ? dat_rsp_pad_value : dat_l0c0_hi;
    dat_rsp_l1c0_lo = dat_l1c0_dummy ? dat_rsp_pad_value : dat_l1c0_lo;
    dat_rsp_l1c0_hi = dat_l1c0_dummy ? dat_rsp_pad_value : dat_l1c0_hi;
    dat_rsp_l2c0_lo = dat_l2c0_dummy ? dat_rsp_pad_value : dat_l2c0_lo;
    dat_rsp_l2c0_hi = dat_l2c0_dummy ? dat_rsp_pad_value : dat_l2c0_hi;
    dat_rsp_l3c0_lo = dat_l3c0_dummy ? dat_rsp_pad_value : dat_l3c0_lo;
    dat_rsp_l3c0_hi = dat_l3c0_dummy ? dat_rsp_pad_value : dat_l3c0_hi;
end

always @(
  dat_l0c1_dummy
  or dat_rsp_pad_value
  or dat_l0c1_lo
  or dat_l0c1_hi
  or dat_l1c1_dummy
  or dat_l1c1_lo
  or dat_l1c1_hi
  or dat_l2c1_dummy
  or dat_l2c1_lo
  or dat_l2c1_hi
  or dat_l3c1_dummy
  or dat_l3c1_lo
  or dat_l3c1_hi
  ) begin
    dat_rsp_l0c1_lo = dat_l0c1_dummy ? dat_rsp_pad_value : dat_l0c1_lo;
    dat_rsp_l0c1_hi = dat_l0c1_dummy ? dat_rsp_pad_value : dat_l0c1_hi;
    dat_rsp_l1c1_lo = dat_l1c1_dummy ? dat_rsp_pad_value : dat_l1c1_lo;
    dat_rsp_l1c1_hi = dat_l1c1_dummy ? dat_rsp_pad_value : dat_l1c1_hi;
    dat_rsp_l2c1_lo = dat_l2c1_dummy ? dat_rsp_pad_value : dat_l2c1_lo;
    dat_rsp_l2c1_hi = dat_l2c1_dummy ? dat_rsp_pad_value : dat_l2c1_hi;
    dat_rsp_l3c1_lo = dat_l3c1_dummy ? dat_rsp_pad_value : dat_l3c1_lo;
    dat_rsp_l3c1_hi = dat_l3c1_dummy ? dat_rsp_pad_value : dat_l3c1_hi;
end

always @(
  is_int8_d1
  or is_winograd_d1
  or is_img_d1
  or dat_rsp_bytes
  or dat_rsp_sub_w
  or dat_rsp_l0c0_lo
  or dat_rsp_l0c0_hi
  ) begin
    dat_rsp_conv_16b = (is_int8_d1[9] | is_winograd_d1[13] | is_img_d1[25]) ? 512'b0 :
                       ((dat_rsp_bytes <= 8'h40) & (dat_rsp_bytes > 8'h20) & (dat_rsp_sub_w[0] == 1'h0)) ? {512'b0, dat_rsp_l0c0_lo} :
                       ((dat_rsp_bytes <= 8'h40) & (dat_rsp_bytes > 8'h20) & (dat_rsp_sub_w[0] == 1'h1)) ? {512'b0, dat_rsp_l0c0_hi} :
                       ((dat_rsp_bytes <= 8'h20) & (dat_rsp_sub_w == 2'h0)) ? {768'b0, dat_rsp_l0c0_lo[255:0]} :
                       ((dat_rsp_bytes <= 8'h20) & (dat_rsp_sub_w == 2'h1)) ? {768'b0, dat_rsp_l0c0_lo[511:256]} :
                       ((dat_rsp_bytes <= 8'h20) & (dat_rsp_sub_w == 2'h2)) ? {768'b0, dat_rsp_l0c0_hi[255:0]} :
                       ((dat_rsp_bytes <= 8'h20) & (dat_rsp_sub_w == 2'h3)) ? {768'b0, dat_rsp_l0c0_hi[511:256]} :
                       {dat_rsp_l0c0_hi, dat_rsp_l0c0_lo};
end

always @(
  is_int8_d1
  or is_winograd_d1
  or is_img_d1
  or dat_rsp_bytes
  or dat_rsp_sub_c
  or dat_rsp_l0c0_hi
  or dat_rsp_sub_w
  or dat_rsp_l0c0_lo
  or dat_rsp_ch_end
  ) begin
    dat_rsp_conv_8b = (~is_int8_d1[10] | is_winograd_d1[14] | is_img_d1[26]) ? 512'b0 :
                      ((dat_rsp_bytes <= 8'h20) & (dat_rsp_sub_c == 1'h1)) ? {256'b0, dat_rsp_l0c0_hi[255:0]} :
                      ((dat_rsp_bytes <= 8'h20) & (dat_rsp_sub_w == 2'h0)) ? {256'b0, dat_rsp_l0c0_lo[255:0]} :
                      ((dat_rsp_bytes <= 8'h20) & (dat_rsp_sub_w == 2'h1)) ? {256'b0, dat_rsp_l0c0_lo[511:256]} :
                      ((dat_rsp_bytes <= 8'h20) & (dat_rsp_sub_w == 2'h2)) ? {256'b0, dat_rsp_l0c0_hi[255:0]} :
                      ((dat_rsp_bytes <= 8'h20) & (dat_rsp_sub_w == 2'h3)) ? {256'b0, dat_rsp_l0c0_hi[511:256]} :
                      (dat_rsp_sub_c | (dat_rsp_sub_w[0] & dat_rsp_ch_end)) ? dat_rsp_l0c0_hi :
                      dat_rsp_l0c0_lo;
end

always @(
  dat_rsp_conv_16b
  or dat_rsp_conv_8b
  ) begin
    dat_rsp_conv = dat_rsp_conv_16b | {2{dat_rsp_conv_8b}};
end

//////////////// data for image ////////////////

always @(
  rsp_sft_cnt_l1
  ) begin
    rsp_sft_l1_sel_3 = (rsp_sft_cnt_l1[7:6] == 2'h3);
    rsp_sft_l1_sel_2 = (rsp_sft_cnt_l1[7:6] == 2'h2);
    rsp_sft_l1_sel_1 = (rsp_sft_cnt_l1[7:6] == 2'h1);
end

always @(
  rsp_sft_cnt_l2
  ) begin
    rsp_sft_l2_sel_3 = (rsp_sft_cnt_l2[7:6] == 2'h3);
    rsp_sft_l2_sel_2 = (rsp_sft_cnt_l2[7:6] == 2'h2);
    rsp_sft_l2_sel_1 = (rsp_sft_cnt_l2[7:6] == 2'h1);
end

always @(
  rsp_sft_cnt_l3
  ) begin
    rsp_sft_l3_sel_3 = (rsp_sft_cnt_l3[7:6] == 2'h3);
    rsp_sft_l3_sel_2 = (rsp_sft_cnt_l3[7:6] == 2'h2);
    rsp_sft_l3_sel_1 = (rsp_sft_cnt_l3[7:6] == 2'h1);
end

always @(
  is_img_d1
  or rsp_sft_cnt_l0
  or dat_rsp_l0c0_hi
  or dat_rsp_l0c0_lo
  or dat_rsp_l0c1_hi
  or dat_rsp_l0c1_lo
  ) begin
    dat_rsp_l0_sft_in = ~is_img_d1[27] ? 1024'b0 :
                        (rsp_sft_cnt_l0[7]) ? {512'b0, dat_rsp_l0c0_hi, dat_rsp_l0c0_lo} :
                        {dat_rsp_l0c0_hi, dat_rsp_l0c0_lo, dat_rsp_l0c1_hi, dat_rsp_l0c1_lo};
end

always @(
  is_img_d1
  or rsp_sft_l1_sel_3
  or dat_rsp_l1c0_hi
  or rsp_sft_l1_sel_2
  or dat_rsp_l1c0_lo
  or rsp_sft_l1_sel_1
  or dat_rsp_l1c1_hi
  or dat_rsp_l1c1_lo
  ) begin
    dat_rsp_l1_sft_in = ~is_img_d1[28] ? 512'b0 :
                        rsp_sft_l1_sel_3 ? {512'b0, dat_rsp_l1c0_hi} :
                        rsp_sft_l1_sel_2 ? {dat_rsp_l1c0_hi, dat_rsp_l1c0_lo} :
                        rsp_sft_l1_sel_1 ? {dat_rsp_l1c0_lo, dat_rsp_l1c1_hi} :
                        {dat_rsp_l1c1_hi, dat_rsp_l1c1_lo};
end

always @(
  is_img_d1
  or rsp_sft_l2_sel_3
  or dat_rsp_l2c0_hi
  or rsp_sft_l2_sel_2
  or dat_rsp_l2c0_lo
  or rsp_sft_l2_sel_1
  or dat_rsp_l2c1_hi
  or dat_rsp_l2c1_lo
  ) begin
    dat_rsp_l2_sft_in = ~is_img_d1[29] ? 512'b0 :
                        rsp_sft_l2_sel_3 ? {512'b0, dat_rsp_l2c0_hi} :
                        rsp_sft_l2_sel_2 ? {dat_rsp_l2c0_hi, dat_rsp_l2c0_lo} :
                        rsp_sft_l2_sel_1 ? {dat_rsp_l2c0_lo, dat_rsp_l2c1_hi} :
                        {dat_rsp_l2c1_hi, dat_rsp_l2c1_lo};
end

always @(
  is_img_d1
  or rsp_sft_l3_sel_3
  or dat_rsp_l3c0_hi
  or rsp_sft_l3_sel_2
  or dat_rsp_l3c0_lo
  or rsp_sft_l3_sel_1
  or dat_rsp_l3c1_hi
  or dat_rsp_l3c1_lo
  ) begin
    dat_rsp_l3_sft_in = ~is_img_d1[30] ? 512'b0 :
                        rsp_sft_l3_sel_3 ? {512'b0, dat_rsp_l3c0_hi} :
                        rsp_sft_l3_sel_2 ? {dat_rsp_l3c0_hi, dat_rsp_l3c0_lo} :
                        rsp_sft_l3_sel_1 ? {dat_rsp_l3c0_lo, dat_rsp_l3c1_hi} :
                        {dat_rsp_l3c1_hi, dat_rsp_l3c1_lo};
end

always @(
  dat_rsp_l0_sft_in
  or rsp_sft_cnt_l0
  or dat_rsp_l1_sft_in
  or rsp_sft_cnt_l1
  or dat_rsp_l2_sft_in
  or rsp_sft_cnt_l2
  or dat_rsp_l3_sft_in
  or rsp_sft_cnt_l3
  ) begin
    {mon_dat_rsp_l0_sft, dat_rsp_l0_sft} = dat_rsp_l0_sft_in >> {rsp_sft_cnt_l0[6:0], 3'b0};
    {mon_dat_rsp_l1_sft, dat_rsp_l1_sft} = dat_rsp_l1_sft_in >> {rsp_sft_cnt_l1[5:0], 3'b0};
    {mon_dat_rsp_l2_sft, dat_rsp_l2_sft} = dat_rsp_l2_sft_in >> {rsp_sft_cnt_l2[5:0], 3'b0};
    {mon_dat_rsp_l3_sft, dat_rsp_l3_sft} = dat_rsp_l3_sft_in >> {rsp_sft_cnt_l3[5:0], 3'b0};
end

always @(
  is_img_d1
  or is_int8_d1
  or sub_h_total_g7
  or dat_rsp_l3_sft
  or dat_rsp_l2_sft_d3
  or dat_rsp_l1_sft_d3
  or dat_rsp_l0_sft_d3
  or dat_rsp_l1_sft
  or dat_rsp_l0_sft_d1
  or dat_rsp_l0_sft
  ) begin
    dat_rsp_img_16b = (~is_img_d1[31] | is_int8_d1[11]) ? 1024'b0 :
                      (sub_h_total_g7 == 3'h4) ? {dat_rsp_l3_sft, dat_rsp_l2_sft_d3, dat_rsp_l1_sft_d3, dat_rsp_l0_sft_d3} :
                      (sub_h_total_g7 == 3'h2) ? {dat_rsp_l1_sft, dat_rsp_l0_sft_d1} :
                      dat_rsp_l0_sft;
end

always @(
  is_img_d1
  or is_int8_d1
  or sub_h_total_g8
  or dat_rsp_l3_sft
  or dat_rsp_l2_sft_d3
  or dat_rsp_l1_sft_d3
  or dat_rsp_l0_sft_d3
  or dat_rsp_l1_sft
  or dat_rsp_l0_sft_d1
  or dat_rsp_l0_sft
  ) begin
    dat_rsp_img_8b = (~is_img_d1[32] | ~is_int8_d1[12]) ? 512'b0 :
                     (sub_h_total_g8 == 3'h4) ? {dat_rsp_l3_sft[127:0], dat_rsp_l2_sft_d3[127:0], dat_rsp_l1_sft_d3[127:0], dat_rsp_l0_sft_d3[127:0]} :
                     (sub_h_total_g8 == 3'h2) ? {dat_rsp_l1_sft[255:0], dat_rsp_l0_sft_d1[255:0]} :
                     dat_rsp_l0_sft[511:0];
end

always @(
  is_int8_d1
  or dat_rsp_img_16b
  or dat_rsp_img_8b
  ) begin
    dat_rsp_img = ~is_int8_d1[13] ? dat_rsp_img_16b : {2{dat_rsp_img_8b}};
end

always @(
  dat_rsp_l0_pvld
  or sub_h_total_g9
  or is_int8_d1
  or dat_rsp_l1_pvld
  or dat_rsp_l2_pvld
  ) begin
    dat_rsp_sft_lo_d1_en = dat_rsp_l0_pvld & (sub_h_total_g9 != 3'h1);
    dat_rsp_sft_hi_d1_en = dat_rsp_l0_pvld & (sub_h_total_g9 != 3'h1) & ~is_int8_d1[14];
    dat_rsp_sft_lo_d2_en = dat_rsp_l1_pvld & (sub_h_total_g9 == 3'h4);
    dat_rsp_sft_hi_d2_en = dat_rsp_l1_pvld & (sub_h_total_g9 == 3'h4) & ~is_int8_d1[15];
    dat_rsp_sft_lo_d3_en = dat_rsp_l2_pvld & (sub_h_total_g9 == 3'h4);
    dat_rsp_sft_hi_d3_en = dat_rsp_l2_pvld & (sub_h_total_g9 == 3'h4) & ~is_int8_d1[16];
end

always @(posedge nvdla_core_clk) begin
  if ((dat_rsp_sft_lo_d1_en) == 1'b1) begin
    dat_rsp_l0_sft_d1[255:0] <= dat_rsp_l0_sft[255:0];
  // VCS coverage off
  end else if ((dat_rsp_sft_lo_d1_en) == 1'b0) begin
  end else begin
    dat_rsp_l0_sft_d1[255:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_rsp_sft_hi_d1_en) == 1'b1) begin
    dat_rsp_l0_sft_d1[511:256] <= dat_rsp_l0_sft[511:256];
  // VCS coverage off
  end else if ((dat_rsp_sft_hi_d1_en) == 1'b0) begin
  end else begin
    dat_rsp_l0_sft_d1[511:256] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_rsp_sft_lo_d2_en) == 1'b1) begin
    dat_rsp_l0_sft_d2[127:0] <= dat_rsp_l0_sft_d1[127:0];
  // VCS coverage off
  end else if ((dat_rsp_sft_lo_d2_en) == 1'b0) begin
  end else begin
    dat_rsp_l0_sft_d2[127:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_rsp_sft_hi_d2_en) == 1'b1) begin
    dat_rsp_l0_sft_d2[255:128] <= dat_rsp_l0_sft_d1[255:128];
  // VCS coverage off
  end else if ((dat_rsp_sft_hi_d2_en) == 1'b0) begin
  end else begin
    dat_rsp_l0_sft_d2[255:128] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_rsp_sft_lo_d3_en) == 1'b1) begin
    dat_rsp_l0_sft_d3[127:0] <= dat_rsp_l0_sft_d2[127:0];
  // VCS coverage off
  end else if ((dat_rsp_sft_lo_d3_en) == 1'b0) begin
  end else begin
    dat_rsp_l0_sft_d3[127:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_rsp_sft_hi_d3_en) == 1'b1) begin
    dat_rsp_l0_sft_d3[255:128] <= dat_rsp_l0_sft_d2[255:128];
  // VCS coverage off
  end else if ((dat_rsp_sft_hi_d3_en) == 1'b0) begin
  end else begin
    dat_rsp_l0_sft_d3[255:128] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_rsp_sft_lo_d2_en) == 1'b1) begin
    dat_rsp_l1_sft_d2[127:0] <= dat_rsp_l1_sft[127:0];
  // VCS coverage off
  end else if ((dat_rsp_sft_lo_d2_en) == 1'b0) begin
  end else begin
    dat_rsp_l1_sft_d2[127:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_rsp_sft_hi_d2_en) == 1'b1) begin
    dat_rsp_l1_sft_d2[255:128] <= dat_rsp_l1_sft[255:128];
  // VCS coverage off
  end else if ((dat_rsp_sft_hi_d2_en) == 1'b0) begin
  end else begin
    dat_rsp_l1_sft_d2[255:128] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_rsp_sft_lo_d3_en) == 1'b1) begin
    dat_rsp_l1_sft_d3[127:0] <= dat_rsp_l1_sft_d2[127:0];
  // VCS coverage off
  end else if ((dat_rsp_sft_lo_d3_en) == 1'b0) begin
  end else begin
    dat_rsp_l1_sft_d3[127:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_rsp_sft_hi_d3_en) == 1'b1) begin
    dat_rsp_l1_sft_d3[255:128] <= dat_rsp_l1_sft_d2[255:128];
  // VCS coverage off
  end else if ((dat_rsp_sft_hi_d3_en) == 1'b0) begin
  end else begin
    dat_rsp_l1_sft_d3[255:128] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_rsp_sft_lo_d3_en) == 1'b1) begin
    dat_rsp_l2_sft_d3[127:0] <= dat_rsp_l2_sft[127:0];
  // VCS coverage off
  end else if ((dat_rsp_sft_lo_d3_en) == 1'b0) begin
  end else begin
    dat_rsp_l2_sft_d3[127:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_rsp_sft_hi_d3_en) == 1'b1) begin
    dat_rsp_l2_sft_d3[255:128] <= dat_rsp_l2_sft[255:128];
  // VCS coverage off
  end else if ((dat_rsp_sft_hi_d3_en) == 1'b0) begin
  end else begin
    dat_rsp_l2_sft_d3[255:128] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
//////////////// byte mask ////////////////

always @(
  dat_rsp_bytes
  ) begin
    dat_rsp_ori_mask = ~({128{1'b1}} << dat_rsp_bytes);
end

always @(
  dat_rsp_cur_sub_h
  ) begin
    dat_rsp_cur_h_mask_p1 = (dat_rsp_cur_sub_h >= 2'h1) ? {64{1'b1}} : 64'b0;
    dat_rsp_cur_h_mask_p2 = (dat_rsp_cur_sub_h >= 2'h2) ? {32{1'b1}} : 32'b0;
    dat_rsp_cur_h_mask_p3 = (dat_rsp_cur_sub_h == 2'h3) ? {32{1'b1}} : 32'b0;
end

always @(
  dat_rsp_cur_h_mask_p1
  or dat_rsp_cur_h_mask_p3
  or dat_rsp_cur_h_mask_p2
  ) begin
    dat_rsp_cur_h_e2_mask_16b = {dat_rsp_cur_h_mask_p1, {64{1'b1}}};
    dat_rsp_cur_h_e4_mask_16b = {dat_rsp_cur_h_mask_p3, dat_rsp_cur_h_mask_p2, dat_rsp_cur_h_mask_p1[31:0], {32{1'b1}}};
end

always @(
  dat_rsp_cur_h_mask_p1
  or dat_rsp_cur_h_mask_p3
  or dat_rsp_cur_h_mask_p2
  ) begin
    dat_rsp_cur_h_e2_mask_8b = {dat_rsp_cur_h_mask_p1[31:0], {32{1'b1}}};
    dat_rsp_cur_h_e4_mask_8b = {dat_rsp_cur_h_mask_p3[15:0], dat_rsp_cur_h_mask_p2[15:0], dat_rsp_cur_h_mask_p1[15:0], {16{1'b1}}};
end

always @(
  sub_h_total_g10
  or dat_rsp_ori_mask
  or dat_rsp_cur_h_e4_mask_16b
  or dat_rsp_cur_h_e2_mask_16b
  ) begin
    dat_rsp_mask_16b = (sub_h_total_g10 == 3'h4) ? ({4{dat_rsp_ori_mask[31:0]}} & dat_rsp_cur_h_e4_mask_16b) :
                       (sub_h_total_g10 == 3'h2) ? ({2{dat_rsp_ori_mask[63:0]}} & dat_rsp_cur_h_e2_mask_16b) :
                       dat_rsp_ori_mask;
end

always @(
  sub_h_total_g11
  or dat_rsp_ori_mask
  or dat_rsp_cur_h_e4_mask_8b
  or dat_rsp_cur_h_e2_mask_8b
  ) begin
    dat_rsp_mask_8b = (sub_h_total_g11 == 3'h4) ? ({4{dat_rsp_ori_mask[15:0]}} & dat_rsp_cur_h_e4_mask_8b) :
                      (sub_h_total_g11 == 3'h2) ? ({2{dat_rsp_ori_mask[31:0]}} & dat_rsp_cur_h_e2_mask_8b) :
                      dat_rsp_ori_mask[63:0];

end

always @(
  is_img_d1
  or dat_rsp_img
  or dat_rsp_conv
  ) begin
    dat_rsp_data_w = is_img_d1[33] ? dat_rsp_img :
                     dat_rsp_conv;
end

always @(
  dat_rsp_data_w
  ) begin
    dat_rsp_mask_val_int8 = {(|dat_rsp_data_w[511:504]), (|dat_rsp_data_w[503:496]), (|dat_rsp_data_w[495:488]), (|dat_rsp_data_w[487:480]), (|dat_rsp_data_w[479:472]), (|dat_rsp_data_w[471:464]), (|dat_rsp_data_w[463:456]), (|dat_rsp_data_w[455:448]),
                             (|dat_rsp_data_w[447:440]), (|dat_rsp_data_w[439:432]), (|dat_rsp_data_w[431:424]), (|dat_rsp_data_w[423:416]), (|dat_rsp_data_w[415:408]), (|dat_rsp_data_w[407:400]), (|dat_rsp_data_w[399:392]), (|dat_rsp_data_w[391:384]),
                             (|dat_rsp_data_w[383:376]), (|dat_rsp_data_w[375:368]), (|dat_rsp_data_w[367:360]), (|dat_rsp_data_w[359:352]), (|dat_rsp_data_w[351:344]), (|dat_rsp_data_w[343:336]), (|dat_rsp_data_w[335:328]), (|dat_rsp_data_w[327:320]),
                             (|dat_rsp_data_w[319:312]), (|dat_rsp_data_w[311:304]), (|dat_rsp_data_w[303:296]), (|dat_rsp_data_w[295:288]), (|dat_rsp_data_w[287:280]), (|dat_rsp_data_w[279:272]), (|dat_rsp_data_w[271:264]), (|dat_rsp_data_w[263:256]),
                             (|dat_rsp_data_w[255:248]), (|dat_rsp_data_w[247:240]), (|dat_rsp_data_w[239:232]), (|dat_rsp_data_w[231:224]), (|dat_rsp_data_w[223:216]), (|dat_rsp_data_w[215:208]), (|dat_rsp_data_w[207:200]), (|dat_rsp_data_w[199:192]),
                             (|dat_rsp_data_w[191:184]), (|dat_rsp_data_w[183:176]), (|dat_rsp_data_w[175:168]), (|dat_rsp_data_w[167:160]), (|dat_rsp_data_w[159:152]), (|dat_rsp_data_w[151:144]), (|dat_rsp_data_w[143:136]), (|dat_rsp_data_w[135:128]),
                             (|dat_rsp_data_w[127:120]), (|dat_rsp_data_w[119:112]), (|dat_rsp_data_w[111:104]), (|dat_rsp_data_w[103: 96]), (|dat_rsp_data_w[ 95: 88]), (|dat_rsp_data_w[ 87: 80]), (|dat_rsp_data_w[ 79: 72]), (|dat_rsp_data_w[ 71: 64]),
                             (|dat_rsp_data_w[ 63: 56]), (|dat_rsp_data_w[ 55: 48]), (|dat_rsp_data_w[ 47: 40]), (|dat_rsp_data_w[ 39: 32]), (|dat_rsp_data_w[ 31: 24]), (|dat_rsp_data_w[ 23: 16]), (|dat_rsp_data_w[ 15:  8]), (|dat_rsp_data_w[  7:  0])};
end


always @(
  dat_rsp_data_w
  ) begin
    dat_rsp_mask_val_fp16 = {{2{(|dat_rsp_data_w[1022:1008])}}, {2{(|dat_rsp_data_w[1006:992])}}, {2{(|dat_rsp_data_w[990:976])}}, {2{(|dat_rsp_data_w[974:960])}}, {2{(|dat_rsp_data_w[958:944])}}, {2{(|dat_rsp_data_w[942:928])}}, {2{(|dat_rsp_data_w[926:912])}}, {2{(|dat_rsp_data_w[910:896])}},
                             {2{(|dat_rsp_data_w[894:880])}}, {2{(|dat_rsp_data_w[878:864])}}, {2{(|dat_rsp_data_w[862:848])}}, {2{(|dat_rsp_data_w[846:832])}}, {2{(|dat_rsp_data_w[830:816])}}, {2{(|dat_rsp_data_w[814:800])}}, {2{(|dat_rsp_data_w[798:784])}}, {2{(|dat_rsp_data_w[782:768])}},
                             {2{(|dat_rsp_data_w[766:752])}}, {2{(|dat_rsp_data_w[750:736])}}, {2{(|dat_rsp_data_w[734:720])}}, {2{(|dat_rsp_data_w[718:704])}}, {2{(|dat_rsp_data_w[702:688])}}, {2{(|dat_rsp_data_w[686:672])}}, {2{(|dat_rsp_data_w[670:656])}}, {2{(|dat_rsp_data_w[654:640])}},
                             {2{(|dat_rsp_data_w[638:624])}}, {2{(|dat_rsp_data_w[622:608])}}, {2{(|dat_rsp_data_w[606:592])}}, {2{(|dat_rsp_data_w[590:576])}}, {2{(|dat_rsp_data_w[574:560])}}, {2{(|dat_rsp_data_w[558:544])}}, {2{(|dat_rsp_data_w[542:528])}}, {2{(|dat_rsp_data_w[526:512])}},
                             {2{(|dat_rsp_data_w[510:496])}}, {2{(|dat_rsp_data_w[494:480])}}, {2{(|dat_rsp_data_w[478:464])}}, {2{(|dat_rsp_data_w[462:448])}}, {2{(|dat_rsp_data_w[446:432])}}, {2{(|dat_rsp_data_w[430:416])}}, {2{(|dat_rsp_data_w[414:400])}}, {2{(|dat_rsp_data_w[398:384])}},
                             {2{(|dat_rsp_data_w[382:368])}}, {2{(|dat_rsp_data_w[366:352])}}, {2{(|dat_rsp_data_w[350:336])}}, {2{(|dat_rsp_data_w[334:320])}}, {2{(|dat_rsp_data_w[318:304])}}, {2{(|dat_rsp_data_w[302:288])}}, {2{(|dat_rsp_data_w[286:272])}}, {2{(|dat_rsp_data_w[270:256])}},
                             {2{(|dat_rsp_data_w[254:240])}}, {2{(|dat_rsp_data_w[238:224])}}, {2{(|dat_rsp_data_w[222:208])}}, {2{(|dat_rsp_data_w[206:192])}}, {2{(|dat_rsp_data_w[190:176])}}, {2{(|dat_rsp_data_w[174:160])}}, {2{(|dat_rsp_data_w[158:144])}}, {2{(|dat_rsp_data_w[142:128])}},
                             {2{(|dat_rsp_data_w[126:112])}}, {2{(|dat_rsp_data_w[110: 96])}}, {2{(|dat_rsp_data_w[ 94: 80])}}, {2{(|dat_rsp_data_w[ 78: 64])}}, {2{(|dat_rsp_data_w[ 62: 48])}}, {2{(|dat_rsp_data_w[ 46: 32])}}, {2{(|dat_rsp_data_w[ 30: 16])}}, {2{(|dat_rsp_data_w[ 14:  0])}}};
end


always @(
  dat_rsp_data_w
  ) begin
    dat_rsp_mask_val_int16 = {{2{(|dat_rsp_data_w[1023:1008])}}, {2{(|dat_rsp_data_w[1007:992])}}, {2{(|dat_rsp_data_w[991:976])}}, {2{(|dat_rsp_data_w[975:960])}}, {2{(|dat_rsp_data_w[959:944])}}, {2{(|dat_rsp_data_w[943:928])}}, {2{(|dat_rsp_data_w[927:912])}}, {2{(|dat_rsp_data_w[911:896])}},
                              {2{(|dat_rsp_data_w[895:880])}}, {2{(|dat_rsp_data_w[879:864])}}, {2{(|dat_rsp_data_w[863:848])}}, {2{(|dat_rsp_data_w[847:832])}}, {2{(|dat_rsp_data_w[831:816])}}, {2{(|dat_rsp_data_w[815:800])}}, {2{(|dat_rsp_data_w[799:784])}}, {2{(|dat_rsp_data_w[783:768])}},
                              {2{(|dat_rsp_data_w[767:752])}}, {2{(|dat_rsp_data_w[751:736])}}, {2{(|dat_rsp_data_w[735:720])}}, {2{(|dat_rsp_data_w[719:704])}}, {2{(|dat_rsp_data_w[703:688])}}, {2{(|dat_rsp_data_w[687:672])}}, {2{(|dat_rsp_data_w[671:656])}}, {2{(|dat_rsp_data_w[655:640])}},
                              {2{(|dat_rsp_data_w[639:624])}}, {2{(|dat_rsp_data_w[623:608])}}, {2{(|dat_rsp_data_w[607:592])}}, {2{(|dat_rsp_data_w[591:576])}}, {2{(|dat_rsp_data_w[575:560])}}, {2{(|dat_rsp_data_w[559:544])}}, {2{(|dat_rsp_data_w[543:528])}}, {2{(|dat_rsp_data_w[527:512])}},
                              {2{(|dat_rsp_data_w[511:496])}}, {2{(|dat_rsp_data_w[495:480])}}, {2{(|dat_rsp_data_w[479:464])}}, {2{(|dat_rsp_data_w[463:448])}}, {2{(|dat_rsp_data_w[447:432])}}, {2{(|dat_rsp_data_w[431:416])}}, {2{(|dat_rsp_data_w[415:400])}}, {2{(|dat_rsp_data_w[399:384])}},
                              {2{(|dat_rsp_data_w[383:368])}}, {2{(|dat_rsp_data_w[367:352])}}, {2{(|dat_rsp_data_w[351:336])}}, {2{(|dat_rsp_data_w[335:320])}}, {2{(|dat_rsp_data_w[319:304])}}, {2{(|dat_rsp_data_w[303:288])}}, {2{(|dat_rsp_data_w[287:272])}}, {2{(|dat_rsp_data_w[271:256])}},
                              {2{(|dat_rsp_data_w[255:240])}}, {2{(|dat_rsp_data_w[239:224])}}, {2{(|dat_rsp_data_w[223:208])}}, {2{(|dat_rsp_data_w[207:192])}}, {2{(|dat_rsp_data_w[191:176])}}, {2{(|dat_rsp_data_w[175:160])}}, {2{(|dat_rsp_data_w[159:144])}}, {2{(|dat_rsp_data_w[143:128])}},
                              {2{(|dat_rsp_data_w[127:112])}}, {2{(|dat_rsp_data_w[111: 96])}}, {2{(|dat_rsp_data_w[ 95: 80])}}, {2{(|dat_rsp_data_w[ 79: 64])}}, {2{(|dat_rsp_data_w[ 63: 48])}}, {2{(|dat_rsp_data_w[ 47: 32])}}, {2{(|dat_rsp_data_w[ 31: 16])}}, {2{(|dat_rsp_data_w[ 15:  0])}}};
end



always @(
  is_int8_d1
  or dat_rsp_mask_8b
  or dat_rsp_mask_val_int8
  or is_fp16_d1
  or dat_rsp_mask_16b
  or dat_rsp_mask_val_fp16
  or dat_rsp_mask_val_int16
  ) begin
    dat_rsp_mask_w = is_int8_d1[17] ? {64'b0, (dat_rsp_mask_8b & dat_rsp_mask_val_int8)} :
                     is_fp16_d1[0] ? (dat_rsp_mask_16b & dat_rsp_mask_val_fp16) :
                     (dat_rsp_mask_16b & dat_rsp_mask_val_int16);
end

always @(
  is_int8_d1
  or dat_rsp_pvld
  or is_winograd_d1
  ) begin
    dat_rsp_p1_vld_w = ~is_int8_d1[18] & dat_rsp_pvld & ~is_winograd_d1[15];
    dat_rsp_p0_vld_w = dat_rsp_pvld & ~is_winograd_d1[16];
end

//////////////////////////////////////////////////////////////
///// latency register to balance with PRA cell          /////
//////////////////////////////////////////////////////////////
assign dat_out_pvld_l0 = dat_rsp_pvld;
assign dat_out_flag_l0 = dat_rsp_flag;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_out_pvld_l1 <= 1'b0;
  end else begin
  dat_out_pvld_l1 <= dat_out_pvld_l0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_out_flag_l1 <= {9{1'b0}};
  end else begin
  if ((dat_out_pvld_l0) == 1'b1) begin
    dat_out_flag_l1 <= dat_out_flag_l0;
  // VCS coverage off
  end else if ((dat_out_pvld_l0) == 1'b0) begin
  end else begin
    dat_out_flag_l1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_211x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_out_pvld_l0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_out_pvld_l2 <= 1'b0;
  end else begin
  dat_out_pvld_l2 <= dat_out_pvld_l1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_out_flag_l2 <= {9{1'b0}};
  end else begin
  if ((dat_out_pvld_l1) == 1'b1) begin
    dat_out_flag_l2 <= dat_out_flag_l1;
  // VCS coverage off
  end else if ((dat_out_pvld_l1) == 1'b0) begin
  end else begin
    dat_out_flag_l2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_212x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_out_pvld_l1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_out_pvld_l3 <= 1'b0;
  end else begin
  dat_out_pvld_l3 <= dat_out_pvld_l2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_out_flag_l3 <= {9{1'b0}};
  end else begin
  if ((dat_out_pvld_l2) == 1'b1) begin
    dat_out_flag_l3 <= dat_out_flag_l2;
  // VCS coverage off
  end else if ((dat_out_pvld_l2) == 1'b0) begin
  end else begin
    dat_out_flag_l3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_213x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_out_pvld_l2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_out_pvld_l4 <= 1'b0;
  end else begin
  dat_out_pvld_l4 <= dat_out_pvld_l3;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_out_flag_l4 <= {9{1'b0}};
  end else begin
  if ((dat_out_pvld_l3) == 1'b1) begin
    dat_out_flag_l4 <= dat_out_flag_l3;
  // VCS coverage off
  end else if ((dat_out_pvld_l3) == 1'b0) begin
  end else begin
    dat_out_flag_l4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_214x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_out_pvld_l3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_out_pvld_l5 <= 1'b0;
  end else begin
  dat_out_pvld_l5 <= dat_out_pvld_l4;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_out_flag_l5 <= {9{1'b0}};
  end else begin
  if ((dat_out_pvld_l4) == 1'b1) begin
    dat_out_flag_l5 <= dat_out_flag_l4;
  // VCS coverage off
  end else if ((dat_out_pvld_l4) == 1'b0) begin
  end else begin
    dat_out_flag_l5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_215x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_out_pvld_l4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign dat_out_pvld_w = is_winograd_d1[17] ? dat_out_pvld_l5 : dat_rsp_pvld;
assign dat_out_flag_w = is_winograd_d1[18] ? dat_out_flag_l5 : dat_rsp_flag;

assign dat_out_bypass_p0_vld_w = dat_rsp_p0_vld_w;
assign dat_out_bypass_p1_vld_w = dat_rsp_p1_vld_w;
assign dat_out_bypass_mask_w = dat_rsp_mask_w;
assign dat_out_bypass_data_w = dat_rsp_data_w;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_out_pvld <= 1'b0;
  end else begin
  dat_out_pvld <= dat_out_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_out_flag <= {9{1'b0}};
  end else begin
  if ((dat_out_pvld_w) == 1'b1) begin
    dat_out_flag <= dat_out_flag_w;
  // VCS coverage off
  end else if ((dat_out_pvld_w) == 1'b0) begin
  end else begin
    dat_out_flag <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_216x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_out_pvld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_out_bypass_mask[63:0] <= {64{1'b0}};
  end else begin
  if ((dat_out_bypass_p0_vld_w) == 1'b1) begin
    dat_out_bypass_mask[63:0] <= dat_out_bypass_mask_w[63:0];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w) == 1'b0) begin
  end else begin
    dat_out_bypass_mask[63:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_217x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_out_bypass_p0_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_out_bypass_mask[127:64] <= {64{1'b0}};
  end else begin
  if ((dat_out_bypass_p1_vld_w) == 1'b1) begin
    dat_out_bypass_mask[127:64] <= dat_out_bypass_mask_w[127:64];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w) == 1'b0) begin
  end else begin
    dat_out_bypass_mask[127:64] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_218x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_out_bypass_p1_vld_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[0]) == 1'b1) begin
    dat_out_bypass_data[7:0] <= dat_out_bypass_data_w[7:0];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[0]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[7:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[1]) == 1'b1) begin
    dat_out_bypass_data[15:8] <= dat_out_bypass_data_w[15:8];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[1]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[15:8] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[2]) == 1'b1) begin
    dat_out_bypass_data[23:16] <= dat_out_bypass_data_w[23:16];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[2]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[23:16] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[3]) == 1'b1) begin
    dat_out_bypass_data[31:24] <= dat_out_bypass_data_w[31:24];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[3]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[31:24] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[4]) == 1'b1) begin
    dat_out_bypass_data[39:32] <= dat_out_bypass_data_w[39:32];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[4]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[39:32] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[5]) == 1'b1) begin
    dat_out_bypass_data[47:40] <= dat_out_bypass_data_w[47:40];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[5]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[47:40] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[6]) == 1'b1) begin
    dat_out_bypass_data[55:48] <= dat_out_bypass_data_w[55:48];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[6]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[55:48] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[7]) == 1'b1) begin
    dat_out_bypass_data[63:56] <= dat_out_bypass_data_w[63:56];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[7]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[63:56] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[8]) == 1'b1) begin
    dat_out_bypass_data[71:64] <= dat_out_bypass_data_w[71:64];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[8]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[71:64] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[9]) == 1'b1) begin
    dat_out_bypass_data[79:72] <= dat_out_bypass_data_w[79:72];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[9]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[79:72] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[10]) == 1'b1) begin
    dat_out_bypass_data[87:80] <= dat_out_bypass_data_w[87:80];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[10]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[87:80] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[11]) == 1'b1) begin
    dat_out_bypass_data[95:88] <= dat_out_bypass_data_w[95:88];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[11]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[95:88] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[12]) == 1'b1) begin
    dat_out_bypass_data[103:96] <= dat_out_bypass_data_w[103:96];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[12]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[103:96] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[13]) == 1'b1) begin
    dat_out_bypass_data[111:104] <= dat_out_bypass_data_w[111:104];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[13]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[111:104] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[14]) == 1'b1) begin
    dat_out_bypass_data[119:112] <= dat_out_bypass_data_w[119:112];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[14]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[119:112] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[15]) == 1'b1) begin
    dat_out_bypass_data[127:120] <= dat_out_bypass_data_w[127:120];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[15]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[127:120] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[16]) == 1'b1) begin
    dat_out_bypass_data[135:128] <= dat_out_bypass_data_w[135:128];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[16]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[135:128] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[17]) == 1'b1) begin
    dat_out_bypass_data[143:136] <= dat_out_bypass_data_w[143:136];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[17]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[143:136] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[18]) == 1'b1) begin
    dat_out_bypass_data[151:144] <= dat_out_bypass_data_w[151:144];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[18]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[151:144] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[19]) == 1'b1) begin
    dat_out_bypass_data[159:152] <= dat_out_bypass_data_w[159:152];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[19]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[159:152] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[20]) == 1'b1) begin
    dat_out_bypass_data[167:160] <= dat_out_bypass_data_w[167:160];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[20]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[167:160] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[21]) == 1'b1) begin
    dat_out_bypass_data[175:168] <= dat_out_bypass_data_w[175:168];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[21]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[175:168] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[22]) == 1'b1) begin
    dat_out_bypass_data[183:176] <= dat_out_bypass_data_w[183:176];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[22]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[183:176] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[23]) == 1'b1) begin
    dat_out_bypass_data[191:184] <= dat_out_bypass_data_w[191:184];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[23]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[191:184] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[24]) == 1'b1) begin
    dat_out_bypass_data[199:192] <= dat_out_bypass_data_w[199:192];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[24]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[199:192] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[25]) == 1'b1) begin
    dat_out_bypass_data[207:200] <= dat_out_bypass_data_w[207:200];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[25]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[207:200] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[26]) == 1'b1) begin
    dat_out_bypass_data[215:208] <= dat_out_bypass_data_w[215:208];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[26]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[215:208] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[27]) == 1'b1) begin
    dat_out_bypass_data[223:216] <= dat_out_bypass_data_w[223:216];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[27]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[223:216] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[28]) == 1'b1) begin
    dat_out_bypass_data[231:224] <= dat_out_bypass_data_w[231:224];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[28]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[231:224] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[29]) == 1'b1) begin
    dat_out_bypass_data[239:232] <= dat_out_bypass_data_w[239:232];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[29]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[239:232] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[30]) == 1'b1) begin
    dat_out_bypass_data[247:240] <= dat_out_bypass_data_w[247:240];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[30]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[247:240] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[31]) == 1'b1) begin
    dat_out_bypass_data[255:248] <= dat_out_bypass_data_w[255:248];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[31]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[255:248] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[32]) == 1'b1) begin
    dat_out_bypass_data[263:256] <= dat_out_bypass_data_w[263:256];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[32]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[263:256] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[33]) == 1'b1) begin
    dat_out_bypass_data[271:264] <= dat_out_bypass_data_w[271:264];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[33]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[271:264] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[34]) == 1'b1) begin
    dat_out_bypass_data[279:272] <= dat_out_bypass_data_w[279:272];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[34]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[279:272] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[35]) == 1'b1) begin
    dat_out_bypass_data[287:280] <= dat_out_bypass_data_w[287:280];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[35]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[287:280] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[36]) == 1'b1) begin
    dat_out_bypass_data[295:288] <= dat_out_bypass_data_w[295:288];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[36]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[295:288] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[37]) == 1'b1) begin
    dat_out_bypass_data[303:296] <= dat_out_bypass_data_w[303:296];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[37]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[303:296] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[38]) == 1'b1) begin
    dat_out_bypass_data[311:304] <= dat_out_bypass_data_w[311:304];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[38]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[311:304] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[39]) == 1'b1) begin
    dat_out_bypass_data[319:312] <= dat_out_bypass_data_w[319:312];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[39]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[319:312] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[40]) == 1'b1) begin
    dat_out_bypass_data[327:320] <= dat_out_bypass_data_w[327:320];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[40]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[327:320] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[41]) == 1'b1) begin
    dat_out_bypass_data[335:328] <= dat_out_bypass_data_w[335:328];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[41]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[335:328] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[42]) == 1'b1) begin
    dat_out_bypass_data[343:336] <= dat_out_bypass_data_w[343:336];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[42]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[343:336] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[43]) == 1'b1) begin
    dat_out_bypass_data[351:344] <= dat_out_bypass_data_w[351:344];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[43]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[351:344] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[44]) == 1'b1) begin
    dat_out_bypass_data[359:352] <= dat_out_bypass_data_w[359:352];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[44]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[359:352] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[45]) == 1'b1) begin
    dat_out_bypass_data[367:360] <= dat_out_bypass_data_w[367:360];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[45]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[367:360] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[46]) == 1'b1) begin
    dat_out_bypass_data[375:368] <= dat_out_bypass_data_w[375:368];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[46]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[375:368] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[47]) == 1'b1) begin
    dat_out_bypass_data[383:376] <= dat_out_bypass_data_w[383:376];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[47]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[383:376] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[48]) == 1'b1) begin
    dat_out_bypass_data[391:384] <= dat_out_bypass_data_w[391:384];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[48]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[391:384] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[49]) == 1'b1) begin
    dat_out_bypass_data[399:392] <= dat_out_bypass_data_w[399:392];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[49]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[399:392] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[50]) == 1'b1) begin
    dat_out_bypass_data[407:400] <= dat_out_bypass_data_w[407:400];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[50]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[407:400] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[51]) == 1'b1) begin
    dat_out_bypass_data[415:408] <= dat_out_bypass_data_w[415:408];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[51]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[415:408] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[52]) == 1'b1) begin
    dat_out_bypass_data[423:416] <= dat_out_bypass_data_w[423:416];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[52]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[423:416] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[53]) == 1'b1) begin
    dat_out_bypass_data[431:424] <= dat_out_bypass_data_w[431:424];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[53]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[431:424] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[54]) == 1'b1) begin
    dat_out_bypass_data[439:432] <= dat_out_bypass_data_w[439:432];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[54]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[439:432] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[55]) == 1'b1) begin
    dat_out_bypass_data[447:440] <= dat_out_bypass_data_w[447:440];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[55]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[447:440] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[56]) == 1'b1) begin
    dat_out_bypass_data[455:448] <= dat_out_bypass_data_w[455:448];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[56]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[455:448] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[57]) == 1'b1) begin
    dat_out_bypass_data[463:456] <= dat_out_bypass_data_w[463:456];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[57]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[463:456] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[58]) == 1'b1) begin
    dat_out_bypass_data[471:464] <= dat_out_bypass_data_w[471:464];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[58]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[471:464] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[59]) == 1'b1) begin
    dat_out_bypass_data[479:472] <= dat_out_bypass_data_w[479:472];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[59]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[479:472] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[60]) == 1'b1) begin
    dat_out_bypass_data[487:480] <= dat_out_bypass_data_w[487:480];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[60]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[487:480] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[61]) == 1'b1) begin
    dat_out_bypass_data[495:488] <= dat_out_bypass_data_w[495:488];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[61]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[495:488] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[62]) == 1'b1) begin
    dat_out_bypass_data[503:496] <= dat_out_bypass_data_w[503:496];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[62]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[503:496] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[63]) == 1'b1) begin
    dat_out_bypass_data[511:504] <= dat_out_bypass_data_w[511:504];
  // VCS coverage off
  end else if ((dat_out_bypass_p0_vld_w & dat_out_bypass_mask_w[63]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[511:504] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[64]) == 1'b1) begin
    dat_out_bypass_data[519:512] <= dat_out_bypass_data_w[519:512];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[64]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[519:512] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[65]) == 1'b1) begin
    dat_out_bypass_data[527:520] <= dat_out_bypass_data_w[527:520];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[65]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[527:520] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[66]) == 1'b1) begin
    dat_out_bypass_data[535:528] <= dat_out_bypass_data_w[535:528];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[66]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[535:528] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[67]) == 1'b1) begin
    dat_out_bypass_data[543:536] <= dat_out_bypass_data_w[543:536];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[67]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[543:536] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[68]) == 1'b1) begin
    dat_out_bypass_data[551:544] <= dat_out_bypass_data_w[551:544];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[68]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[551:544] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[69]) == 1'b1) begin
    dat_out_bypass_data[559:552] <= dat_out_bypass_data_w[559:552];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[69]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[559:552] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[70]) == 1'b1) begin
    dat_out_bypass_data[567:560] <= dat_out_bypass_data_w[567:560];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[70]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[567:560] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[71]) == 1'b1) begin
    dat_out_bypass_data[575:568] <= dat_out_bypass_data_w[575:568];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[71]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[575:568] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[72]) == 1'b1) begin
    dat_out_bypass_data[583:576] <= dat_out_bypass_data_w[583:576];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[72]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[583:576] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[73]) == 1'b1) begin
    dat_out_bypass_data[591:584] <= dat_out_bypass_data_w[591:584];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[73]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[591:584] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[74]) == 1'b1) begin
    dat_out_bypass_data[599:592] <= dat_out_bypass_data_w[599:592];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[74]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[599:592] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[75]) == 1'b1) begin
    dat_out_bypass_data[607:600] <= dat_out_bypass_data_w[607:600];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[75]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[607:600] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[76]) == 1'b1) begin
    dat_out_bypass_data[615:608] <= dat_out_bypass_data_w[615:608];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[76]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[615:608] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[77]) == 1'b1) begin
    dat_out_bypass_data[623:616] <= dat_out_bypass_data_w[623:616];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[77]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[623:616] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[78]) == 1'b1) begin
    dat_out_bypass_data[631:624] <= dat_out_bypass_data_w[631:624];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[78]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[631:624] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[79]) == 1'b1) begin
    dat_out_bypass_data[639:632] <= dat_out_bypass_data_w[639:632];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[79]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[639:632] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[80]) == 1'b1) begin
    dat_out_bypass_data[647:640] <= dat_out_bypass_data_w[647:640];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[80]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[647:640] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[81]) == 1'b1) begin
    dat_out_bypass_data[655:648] <= dat_out_bypass_data_w[655:648];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[81]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[655:648] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[82]) == 1'b1) begin
    dat_out_bypass_data[663:656] <= dat_out_bypass_data_w[663:656];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[82]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[663:656] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[83]) == 1'b1) begin
    dat_out_bypass_data[671:664] <= dat_out_bypass_data_w[671:664];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[83]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[671:664] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[84]) == 1'b1) begin
    dat_out_bypass_data[679:672] <= dat_out_bypass_data_w[679:672];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[84]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[679:672] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[85]) == 1'b1) begin
    dat_out_bypass_data[687:680] <= dat_out_bypass_data_w[687:680];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[85]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[687:680] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[86]) == 1'b1) begin
    dat_out_bypass_data[695:688] <= dat_out_bypass_data_w[695:688];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[86]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[695:688] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[87]) == 1'b1) begin
    dat_out_bypass_data[703:696] <= dat_out_bypass_data_w[703:696];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[87]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[703:696] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[88]) == 1'b1) begin
    dat_out_bypass_data[711:704] <= dat_out_bypass_data_w[711:704];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[88]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[711:704] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[89]) == 1'b1) begin
    dat_out_bypass_data[719:712] <= dat_out_bypass_data_w[719:712];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[89]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[719:712] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[90]) == 1'b1) begin
    dat_out_bypass_data[727:720] <= dat_out_bypass_data_w[727:720];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[90]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[727:720] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[91]) == 1'b1) begin
    dat_out_bypass_data[735:728] <= dat_out_bypass_data_w[735:728];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[91]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[735:728] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[92]) == 1'b1) begin
    dat_out_bypass_data[743:736] <= dat_out_bypass_data_w[743:736];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[92]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[743:736] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[93]) == 1'b1) begin
    dat_out_bypass_data[751:744] <= dat_out_bypass_data_w[751:744];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[93]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[751:744] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[94]) == 1'b1) begin
    dat_out_bypass_data[759:752] <= dat_out_bypass_data_w[759:752];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[94]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[759:752] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[95]) == 1'b1) begin
    dat_out_bypass_data[767:760] <= dat_out_bypass_data_w[767:760];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[95]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[767:760] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[96]) == 1'b1) begin
    dat_out_bypass_data[775:768] <= dat_out_bypass_data_w[775:768];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[96]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[775:768] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[97]) == 1'b1) begin
    dat_out_bypass_data[783:776] <= dat_out_bypass_data_w[783:776];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[97]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[783:776] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[98]) == 1'b1) begin
    dat_out_bypass_data[791:784] <= dat_out_bypass_data_w[791:784];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[98]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[791:784] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[99]) == 1'b1) begin
    dat_out_bypass_data[799:792] <= dat_out_bypass_data_w[799:792];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[99]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[799:792] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[100]) == 1'b1) begin
    dat_out_bypass_data[807:800] <= dat_out_bypass_data_w[807:800];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[100]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[807:800] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[101]) == 1'b1) begin
    dat_out_bypass_data[815:808] <= dat_out_bypass_data_w[815:808];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[101]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[815:808] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[102]) == 1'b1) begin
    dat_out_bypass_data[823:816] <= dat_out_bypass_data_w[823:816];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[102]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[823:816] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[103]) == 1'b1) begin
    dat_out_bypass_data[831:824] <= dat_out_bypass_data_w[831:824];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[103]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[831:824] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[104]) == 1'b1) begin
    dat_out_bypass_data[839:832] <= dat_out_bypass_data_w[839:832];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[104]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[839:832] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[105]) == 1'b1) begin
    dat_out_bypass_data[847:840] <= dat_out_bypass_data_w[847:840];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[105]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[847:840] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[106]) == 1'b1) begin
    dat_out_bypass_data[855:848] <= dat_out_bypass_data_w[855:848];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[106]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[855:848] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[107]) == 1'b1) begin
    dat_out_bypass_data[863:856] <= dat_out_bypass_data_w[863:856];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[107]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[863:856] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[108]) == 1'b1) begin
    dat_out_bypass_data[871:864] <= dat_out_bypass_data_w[871:864];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[108]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[871:864] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[109]) == 1'b1) begin
    dat_out_bypass_data[879:872] <= dat_out_bypass_data_w[879:872];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[109]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[879:872] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[110]) == 1'b1) begin
    dat_out_bypass_data[887:880] <= dat_out_bypass_data_w[887:880];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[110]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[887:880] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[111]) == 1'b1) begin
    dat_out_bypass_data[895:888] <= dat_out_bypass_data_w[895:888];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[111]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[895:888] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[112]) == 1'b1) begin
    dat_out_bypass_data[903:896] <= dat_out_bypass_data_w[903:896];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[112]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[903:896] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[113]) == 1'b1) begin
    dat_out_bypass_data[911:904] <= dat_out_bypass_data_w[911:904];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[113]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[911:904] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[114]) == 1'b1) begin
    dat_out_bypass_data[919:912] <= dat_out_bypass_data_w[919:912];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[114]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[919:912] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[115]) == 1'b1) begin
    dat_out_bypass_data[927:920] <= dat_out_bypass_data_w[927:920];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[115]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[927:920] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[116]) == 1'b1) begin
    dat_out_bypass_data[935:928] <= dat_out_bypass_data_w[935:928];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[116]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[935:928] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[117]) == 1'b1) begin
    dat_out_bypass_data[943:936] <= dat_out_bypass_data_w[943:936];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[117]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[943:936] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[118]) == 1'b1) begin
    dat_out_bypass_data[951:944] <= dat_out_bypass_data_w[951:944];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[118]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[951:944] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[119]) == 1'b1) begin
    dat_out_bypass_data[959:952] <= dat_out_bypass_data_w[959:952];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[119]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[959:952] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[120]) == 1'b1) begin
    dat_out_bypass_data[967:960] <= dat_out_bypass_data_w[967:960];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[120]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[967:960] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[121]) == 1'b1) begin
    dat_out_bypass_data[975:968] <= dat_out_bypass_data_w[975:968];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[121]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[975:968] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[122]) == 1'b1) begin
    dat_out_bypass_data[983:976] <= dat_out_bypass_data_w[983:976];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[122]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[983:976] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[123]) == 1'b1) begin
    dat_out_bypass_data[991:984] <= dat_out_bypass_data_w[991:984];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[123]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[991:984] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[124]) == 1'b1) begin
    dat_out_bypass_data[999:992] <= dat_out_bypass_data_w[999:992];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[124]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[999:992] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[125]) == 1'b1) begin
    dat_out_bypass_data[1007:1000] <= dat_out_bypass_data_w[1007:1000];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[125]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[1007:1000] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[126]) == 1'b1) begin
    dat_out_bypass_data[1015:1008] <= dat_out_bypass_data_w[1015:1008];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[126]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[1015:1008] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[127]) == 1'b1) begin
    dat_out_bypass_data[1023:1016] <= dat_out_bypass_data_w[1023:1016];
  // VCS coverage off
  end else if ((dat_out_bypass_p1_vld_w & dat_out_bypass_mask_w[127]) == 1'b0) begin
  end else begin
    dat_out_bypass_data[1023:1016] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end

//////////////////////////////////////////////////////////////
///// PRA units instance                                 /////
//////////////////////////////////////////////////////////////

always @(
  dat_rsp_pvld
  or is_winograd_d1
  ) begin
    dat_rsp_pra_en = dat_rsp_pvld & is_winograd_d1[19];
end

assign {pra_truncate_3, pra_truncate_2, pra_truncate_1, pra_truncate_0} = pra_truncate;
assign {pra_precision_3, pra_precision_2, pra_precision_1, pra_precision_0} = pra_precision;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dat_rsp_pra_en_d1 <= {4{1'b0}};
  end else begin
  dat_rsp_pra_en_d1 <= {4{dat_rsp_pra_en}};
  end
end

always @(posedge nvdla_core_clk) begin
  if ((dat_rsp_pra_en) == 1'b1) begin
    dat_rsp_wg_ch0_d1 <= dat_rsp_wg_ch0;
  // VCS coverage off
  end else if ((dat_rsp_pra_en) == 1'b0) begin
  end else begin
    dat_rsp_wg_ch0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_rsp_pra_en) == 1'b1) begin
    dat_rsp_wg_ch1_d1 <= dat_rsp_wg_ch1;
  // VCS coverage off
  end else if ((dat_rsp_pra_en) == 1'b0) begin
  end else begin
    dat_rsp_wg_ch1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_rsp_pra_en) == 1'b1) begin
    dat_rsp_wg_ch2_d1 <= dat_rsp_wg_ch2;
  // VCS coverage off
  end else if ((dat_rsp_pra_en) == 1'b0) begin
  end else begin
    dat_rsp_wg_ch2_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_rsp_pra_en) == 1'b1) begin
    dat_rsp_wg_ch3_d1 <= dat_rsp_wg_ch3;
  // VCS coverage off
  end else if ((dat_rsp_pra_en) == 1'b0) begin
  end else begin
    dat_rsp_wg_ch3_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


NV_NVDLA_CSC_pra_cell u_pra_cell_0 (
   .nvdla_core_clk      (nvdla_wg_clk)             //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)          //|< i
  ,.chn_data_in_rsc_z   (dat_rsp_wg_ch0_d1[255:0]) //|< r
  ,.chn_data_in_rsc_vz  (dat_rsp_pra_en_d1[0])     //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_dat_rsp_pra_rdy[0])   //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_precision       (pra_precision_0[1:0])     //|< w
  ,.cfg_truncate_rsc_z  (pra_truncate_0[1:0])      //|< w
  ,.chn_data_out_rsc_z  (dat_pra_dat_ch0[255:0])   //|> w
  ,.chn_data_out_rsc_vz (1'b1)                     //|< ?
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_out_rsc_lz (mon_dat_out_pra_vld[0])   //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  );


NV_NVDLA_CSC_pra_cell u_pra_cell_1 (
   .nvdla_core_clk      (nvdla_wg_clk)             //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)          //|< i
  ,.chn_data_in_rsc_z   (dat_rsp_wg_ch1_d1[255:0]) //|< r
  ,.chn_data_in_rsc_vz  (dat_rsp_pra_en_d1[1])     //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_dat_rsp_pra_rdy[1])   //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_precision       (pra_precision_1[1:0])     //|< w
  ,.cfg_truncate_rsc_z  (pra_truncate_1[1:0])      //|< w
  ,.chn_data_out_rsc_z  (dat_pra_dat_ch1[255:0])   //|> w
  ,.chn_data_out_rsc_vz (1'b1)                     //|< ?
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_out_rsc_lz (mon_dat_out_pra_vld[1])   //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  );


NV_NVDLA_CSC_pra_cell u_pra_cell_2 (
   .nvdla_core_clk      (nvdla_wg_clk)             //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)          //|< i
  ,.chn_data_in_rsc_z   (dat_rsp_wg_ch2_d1[255:0]) //|< r
  ,.chn_data_in_rsc_vz  (dat_rsp_pra_en_d1[2])     //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_dat_rsp_pra_rdy[2])   //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_precision       (pra_precision_2[1:0])     //|< w
  ,.cfg_truncate_rsc_z  (pra_truncate_2[1:0])      //|< w
  ,.chn_data_out_rsc_z  (dat_pra_dat_ch2[255:0])   //|> w
  ,.chn_data_out_rsc_vz (1'b1)                     //|< ?
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_out_rsc_lz (mon_dat_out_pra_vld[2])   //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  );


NV_NVDLA_CSC_pra_cell u_pra_cell_3 (
   .nvdla_core_clk      (nvdla_wg_clk)             //|< i
  ,.nvdla_core_rstn     (nvdla_core_rstn)          //|< i
  ,.chn_data_in_rsc_z   (dat_rsp_wg_ch3_d1[255:0]) //|< r
  ,.chn_data_in_rsc_vz  (dat_rsp_pra_en_d1[3])     //|< r
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_in_rsc_lz  (mon_dat_rsp_pra_rdy[3])   //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.cfg_precision       (pra_precision_3[1:0])     //|< w
  ,.cfg_truncate_rsc_z  (pra_truncate_3[1:0])      //|< w
  ,.chn_data_out_rsc_z  (dat_pra_dat_ch3[255:0])   //|> w
  ,.chn_data_out_rsc_vz (1'b1)                     //|< ?
   // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  ,.chn_data_out_rsc_lz (mon_dat_out_pra_vld[3])   //|> w *
   // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
  );


always @(
  dat_pra_dat_ch3
  or dat_pra_dat_ch2
  or dat_pra_dat_ch1
  or dat_pra_dat_ch0
  ) begin
    dat_pra_dat = {dat_pra_dat_ch3, dat_pra_dat_ch2, dat_pra_dat_ch1, dat_pra_dat_ch0};
end

always @(
  dat_pra_dat
  ) begin
    dat_out_wg_8b = {dat_pra_dat[1015:1008], dat_pra_dat[ 759: 752], dat_pra_dat[ 503: 496], dat_pra_dat[ 247: 240],
                     dat_pra_dat[ 999: 992], dat_pra_dat[ 743: 736], dat_pra_dat[ 487: 480], dat_pra_dat[ 231: 224],
                     dat_pra_dat[ 983: 976], dat_pra_dat[ 727: 720], dat_pra_dat[ 471: 464], dat_pra_dat[ 215: 208],
                     dat_pra_dat[ 967: 960], dat_pra_dat[ 711: 704], dat_pra_dat[ 455: 448], dat_pra_dat[ 199: 192],
                     dat_pra_dat[ 951: 944], dat_pra_dat[ 695: 688], dat_pra_dat[ 439: 432], dat_pra_dat[ 183: 176],
                     dat_pra_dat[ 935: 928], dat_pra_dat[ 679: 672], dat_pra_dat[ 423: 416], dat_pra_dat[ 167: 160],
                     dat_pra_dat[ 919: 912], dat_pra_dat[ 663: 656], dat_pra_dat[ 407: 400], dat_pra_dat[ 151: 144],
                     dat_pra_dat[ 903: 896], dat_pra_dat[ 647: 640], dat_pra_dat[ 391: 384], dat_pra_dat[ 135: 128],
                     dat_pra_dat[ 887: 880], dat_pra_dat[ 631: 624], dat_pra_dat[ 375: 368], dat_pra_dat[ 119: 112],
                     dat_pra_dat[ 871: 864], dat_pra_dat[ 615: 608], dat_pra_dat[ 359: 352], dat_pra_dat[ 103:  96],
                     dat_pra_dat[ 855: 848], dat_pra_dat[ 599: 592], dat_pra_dat[ 343: 336], dat_pra_dat[  87:  80],
                     dat_pra_dat[ 839: 832], dat_pra_dat[ 583: 576], dat_pra_dat[ 327: 320], dat_pra_dat[  71:  64],
                     dat_pra_dat[ 823: 816], dat_pra_dat[ 567: 560], dat_pra_dat[ 311: 304], dat_pra_dat[  55:  48],
                     dat_pra_dat[ 807: 800], dat_pra_dat[ 551: 544], dat_pra_dat[ 295: 288], dat_pra_dat[  39:  32],
                     dat_pra_dat[ 791: 784], dat_pra_dat[ 535: 528], dat_pra_dat[ 279: 272], dat_pra_dat[  23:  16],
                     dat_pra_dat[ 775: 768], dat_pra_dat[ 519: 512], dat_pra_dat[ 263: 256], dat_pra_dat[   7:   0]};
end


always @(
  dat_pra_dat
  ) begin
    dat_out_wg_16b = {dat_pra_dat[1023:1008], dat_pra_dat[ 767: 752], dat_pra_dat[ 511: 496], dat_pra_dat[ 255: 240],
                      dat_pra_dat[1007: 992], dat_pra_dat[ 751: 736], dat_pra_dat[ 495: 480], dat_pra_dat[ 239: 224],
                      dat_pra_dat[ 991: 976], dat_pra_dat[ 735: 720], dat_pra_dat[ 479: 464], dat_pra_dat[ 223: 208],
                      dat_pra_dat[ 975: 960], dat_pra_dat[ 719: 704], dat_pra_dat[ 463: 448], dat_pra_dat[ 207: 192],
                      dat_pra_dat[ 959: 944], dat_pra_dat[ 703: 688], dat_pra_dat[ 447: 432], dat_pra_dat[ 191: 176],
                      dat_pra_dat[ 943: 928], dat_pra_dat[ 687: 672], dat_pra_dat[ 431: 416], dat_pra_dat[ 175: 160],
                      dat_pra_dat[ 927: 912], dat_pra_dat[ 671: 656], dat_pra_dat[ 415: 400], dat_pra_dat[ 159: 144],
                      dat_pra_dat[ 911: 896], dat_pra_dat[ 655: 640], dat_pra_dat[ 399: 384], dat_pra_dat[ 143: 128],
                      dat_pra_dat[ 895: 880], dat_pra_dat[ 639: 624], dat_pra_dat[ 383: 368], dat_pra_dat[ 127: 112],
                      dat_pra_dat[ 879: 864], dat_pra_dat[ 623: 608], dat_pra_dat[ 367: 352], dat_pra_dat[ 111:  96],
                      dat_pra_dat[ 863: 848], dat_pra_dat[ 607: 592], dat_pra_dat[ 351: 336], dat_pra_dat[  95:  80],
                      dat_pra_dat[ 847: 832], dat_pra_dat[ 591: 576], dat_pra_dat[ 335: 320], dat_pra_dat[  79:  64],
                      dat_pra_dat[ 831: 816], dat_pra_dat[ 575: 560], dat_pra_dat[ 319: 304], dat_pra_dat[  63:  48],
                      dat_pra_dat[ 815: 800], dat_pra_dat[ 559: 544], dat_pra_dat[ 303: 288], dat_pra_dat[  47:  32],
                      dat_pra_dat[ 799: 784], dat_pra_dat[ 543: 528], dat_pra_dat[ 287: 272], dat_pra_dat[  31:  16],
                      dat_pra_dat[ 783: 768], dat_pra_dat[ 527: 512], dat_pra_dat[ 271: 256], dat_pra_dat[  15:   0]};
end


always @(
  is_int8_d1
  or dat_out_wg_8b
  or dat_out_wg_16b
  ) begin
    dat_out_wg_data = is_int8_d1[19] ? {2{dat_out_wg_8b}} : dat_out_wg_16b;
end


always @(
  dat_out_wg_data
  ) begin
    dat_out_wg_mask_int8 = {(|dat_out_wg_data[ 511: 504]), (|dat_out_wg_data[ 503: 496]), (|dat_out_wg_data[ 495: 488]), (|dat_out_wg_data[ 487: 480]), (|dat_out_wg_data[ 479: 472]), (|dat_out_wg_data[ 471: 464]), (|dat_out_wg_data[ 463: 456]), (|dat_out_wg_data[ 455: 448]),
                            (|dat_out_wg_data[ 447: 440]), (|dat_out_wg_data[ 439: 432]), (|dat_out_wg_data[ 431: 424]), (|dat_out_wg_data[ 423: 416]), (|dat_out_wg_data[ 415: 408]), (|dat_out_wg_data[ 407: 400]), (|dat_out_wg_data[ 399: 392]), (|dat_out_wg_data[ 391: 384]),
                            (|dat_out_wg_data[ 383: 376]), (|dat_out_wg_data[ 375: 368]), (|dat_out_wg_data[ 367: 360]), (|dat_out_wg_data[ 359: 352]), (|dat_out_wg_data[ 351: 344]), (|dat_out_wg_data[ 343: 336]), (|dat_out_wg_data[ 335: 328]), (|dat_out_wg_data[ 327: 320]),
                            (|dat_out_wg_data[ 319: 312]), (|dat_out_wg_data[ 311: 304]), (|dat_out_wg_data[ 303: 296]), (|dat_out_wg_data[ 295: 288]), (|dat_out_wg_data[ 287: 280]), (|dat_out_wg_data[ 279: 272]), (|dat_out_wg_data[ 271: 264]), (|dat_out_wg_data[ 263: 256]),
                            (|dat_out_wg_data[ 255: 248]), (|dat_out_wg_data[ 247: 240]), (|dat_out_wg_data[ 239: 232]), (|dat_out_wg_data[ 231: 224]), (|dat_out_wg_data[ 223: 216]), (|dat_out_wg_data[ 215: 208]), (|dat_out_wg_data[ 207: 200]), (|dat_out_wg_data[ 199: 192]),
                            (|dat_out_wg_data[ 191: 184]), (|dat_out_wg_data[ 183: 176]), (|dat_out_wg_data[ 175: 168]), (|dat_out_wg_data[ 167: 160]), (|dat_out_wg_data[ 159: 152]), (|dat_out_wg_data[ 151: 144]), (|dat_out_wg_data[ 143: 136]), (|dat_out_wg_data[ 135: 128]),
                            (|dat_out_wg_data[ 127: 120]), (|dat_out_wg_data[ 119: 112]), (|dat_out_wg_data[ 111: 104]), (|dat_out_wg_data[ 103:  96]), (|dat_out_wg_data[  95:  88]), (|dat_out_wg_data[  87:  80]), (|dat_out_wg_data[  79:  72]), (|dat_out_wg_data[  71:  64]),
                            (|dat_out_wg_data[  63:  56]), (|dat_out_wg_data[  55:  48]), (|dat_out_wg_data[  47:  40]), (|dat_out_wg_data[  39:  32]), (|dat_out_wg_data[  31:  24]), (|dat_out_wg_data[  23:  16]), (|dat_out_wg_data[  15:   8]), (|dat_out_wg_data[   7:   0])};
end


always @(
  dat_out_wg_data
  ) begin
    dat_out_wg_mask_fp16 = {{2{(|dat_out_wg_data[1022:1008])}}, {2{(|dat_out_wg_data[1006: 992])}}, {2{(|dat_out_wg_data[ 990: 976])}}, {2{(|dat_out_wg_data[ 974: 960])}}, {2{(|dat_out_wg_data[ 958: 944])}}, {2{(|dat_out_wg_data[ 942: 928])}}, {2{(|dat_out_wg_data[ 926: 912])}}, {2{(|dat_out_wg_data[ 910: 896])}},
                            {2{(|dat_out_wg_data[ 894: 880])}}, {2{(|dat_out_wg_data[ 878: 864])}}, {2{(|dat_out_wg_data[ 862: 848])}}, {2{(|dat_out_wg_data[ 846: 832])}}, {2{(|dat_out_wg_data[ 830: 816])}}, {2{(|dat_out_wg_data[ 814: 800])}}, {2{(|dat_out_wg_data[ 798: 784])}}, {2{(|dat_out_wg_data[ 782: 768])}},
                            {2{(|dat_out_wg_data[ 766: 752])}}, {2{(|dat_out_wg_data[ 750: 736])}}, {2{(|dat_out_wg_data[ 734: 720])}}, {2{(|dat_out_wg_data[ 718: 704])}}, {2{(|dat_out_wg_data[ 702: 688])}}, {2{(|dat_out_wg_data[ 686: 672])}}, {2{(|dat_out_wg_data[ 670: 656])}}, {2{(|dat_out_wg_data[ 654: 640])}},
                            {2{(|dat_out_wg_data[ 638: 624])}}, {2{(|dat_out_wg_data[ 622: 608])}}, {2{(|dat_out_wg_data[ 606: 592])}}, {2{(|dat_out_wg_data[ 590: 576])}}, {2{(|dat_out_wg_data[ 574: 560])}}, {2{(|dat_out_wg_data[ 558: 544])}}, {2{(|dat_out_wg_data[ 542: 528])}}, {2{(|dat_out_wg_data[ 526: 512])}},
                            {2{(|dat_out_wg_data[ 510: 496])}}, {2{(|dat_out_wg_data[ 494: 480])}}, {2{(|dat_out_wg_data[ 478: 464])}}, {2{(|dat_out_wg_data[ 462: 448])}}, {2{(|dat_out_wg_data[ 446: 432])}}, {2{(|dat_out_wg_data[ 430: 416])}}, {2{(|dat_out_wg_data[ 414: 400])}}, {2{(|dat_out_wg_data[ 398: 384])}},
                            {2{(|dat_out_wg_data[ 382: 368])}}, {2{(|dat_out_wg_data[ 366: 352])}}, {2{(|dat_out_wg_data[ 350: 336])}}, {2{(|dat_out_wg_data[ 334: 320])}}, {2{(|dat_out_wg_data[ 318: 304])}}, {2{(|dat_out_wg_data[ 302: 288])}}, {2{(|dat_out_wg_data[ 286: 272])}}, {2{(|dat_out_wg_data[ 270: 256])}},
                            {2{(|dat_out_wg_data[ 254: 240])}}, {2{(|dat_out_wg_data[ 238: 224])}}, {2{(|dat_out_wg_data[ 222: 208])}}, {2{(|dat_out_wg_data[ 206: 192])}}, {2{(|dat_out_wg_data[ 190: 176])}}, {2{(|dat_out_wg_data[ 174: 160])}}, {2{(|dat_out_wg_data[ 158: 144])}}, {2{(|dat_out_wg_data[ 142: 128])}},
                            {2{(|dat_out_wg_data[ 126: 112])}}, {2{(|dat_out_wg_data[ 110:  96])}}, {2{(|dat_out_wg_data[  94:  80])}}, {2{(|dat_out_wg_data[  78:  64])}}, {2{(|dat_out_wg_data[  62:  48])}}, {2{(|dat_out_wg_data[  46:  32])}}, {2{(|dat_out_wg_data[  30:  16])}}, {2{(|dat_out_wg_data[  14:   0])}}};
end


always @(
  dat_out_wg_data
  ) begin
    dat_out_wg_mask_int16 = {{2{(|dat_out_wg_data[1023:1008])}}, {2{(|dat_out_wg_data[1007: 992])}}, {2{(|dat_out_wg_data[ 991: 976])}}, {2{(|dat_out_wg_data[ 975: 960])}}, {2{(|dat_out_wg_data[ 959: 944])}}, {2{(|dat_out_wg_data[ 943: 928])}}, {2{(|dat_out_wg_data[ 927: 912])}}, {2{(|dat_out_wg_data[ 911: 896])}},
                             {2{(|dat_out_wg_data[ 895: 880])}}, {2{(|dat_out_wg_data[ 879: 864])}}, {2{(|dat_out_wg_data[ 863: 848])}}, {2{(|dat_out_wg_data[ 847: 832])}}, {2{(|dat_out_wg_data[ 831: 816])}}, {2{(|dat_out_wg_data[ 815: 800])}}, {2{(|dat_out_wg_data[ 799: 784])}}, {2{(|dat_out_wg_data[ 783: 768])}},
                             {2{(|dat_out_wg_data[ 767: 752])}}, {2{(|dat_out_wg_data[ 751: 736])}}, {2{(|dat_out_wg_data[ 735: 720])}}, {2{(|dat_out_wg_data[ 719: 704])}}, {2{(|dat_out_wg_data[ 703: 688])}}, {2{(|dat_out_wg_data[ 687: 672])}}, {2{(|dat_out_wg_data[ 671: 656])}}, {2{(|dat_out_wg_data[ 655: 640])}},
                             {2{(|dat_out_wg_data[ 639: 624])}}, {2{(|dat_out_wg_data[ 623: 608])}}, {2{(|dat_out_wg_data[ 607: 592])}}, {2{(|dat_out_wg_data[ 591: 576])}}, {2{(|dat_out_wg_data[ 575: 560])}}, {2{(|dat_out_wg_data[ 559: 544])}}, {2{(|dat_out_wg_data[ 543: 528])}}, {2{(|dat_out_wg_data[ 527: 512])}},
                             {2{(|dat_out_wg_data[ 511: 496])}}, {2{(|dat_out_wg_data[ 495: 480])}}, {2{(|dat_out_wg_data[ 479: 464])}}, {2{(|dat_out_wg_data[ 463: 448])}}, {2{(|dat_out_wg_data[ 447: 432])}}, {2{(|dat_out_wg_data[ 431: 416])}}, {2{(|dat_out_wg_data[ 415: 400])}}, {2{(|dat_out_wg_data[ 399: 384])}},
                             {2{(|dat_out_wg_data[ 383: 368])}}, {2{(|dat_out_wg_data[ 367: 352])}}, {2{(|dat_out_wg_data[ 351: 336])}}, {2{(|dat_out_wg_data[ 335: 320])}}, {2{(|dat_out_wg_data[ 319: 304])}}, {2{(|dat_out_wg_data[ 303: 288])}}, {2{(|dat_out_wg_data[ 287: 272])}}, {2{(|dat_out_wg_data[ 271: 256])}},
                             {2{(|dat_out_wg_data[ 255: 240])}}, {2{(|dat_out_wg_data[ 239: 224])}}, {2{(|dat_out_wg_data[ 223: 208])}}, {2{(|dat_out_wg_data[ 207: 192])}}, {2{(|dat_out_wg_data[ 191: 176])}}, {2{(|dat_out_wg_data[ 175: 160])}}, {2{(|dat_out_wg_data[ 159: 144])}}, {2{(|dat_out_wg_data[ 143: 128])}},
                             {2{(|dat_out_wg_data[ 127: 112])}}, {2{(|dat_out_wg_data[ 111:  96])}}, {2{(|dat_out_wg_data[  95:  80])}}, {2{(|dat_out_wg_data[  79:  64])}}, {2{(|dat_out_wg_data[  63:  48])}}, {2{(|dat_out_wg_data[  47:  32])}}, {2{(|dat_out_wg_data[  31:  16])}}, {2{(|dat_out_wg_data[  15:   0])}}};
end



always @(
  is_int8_d1
  or dat_out_wg_mask_int8
  or is_fp16_d1
  or dat_out_wg_mask_fp16
  or dat_out_wg_mask_int16
  ) begin
    dat_out_wg_mask = is_int8_d1[20] ? {2{dat_out_wg_mask_int8}} :
                      is_fp16_d1[1] ? dat_out_wg_mask_fp16 :
                      dat_out_wg_mask_int16;
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
  nv_assert_never #(0,0,"Error! PRA cell output and bypass output mismatch!")      zzz_assert_never_219x (nvdla_core_clk, `ASSERT_RESET, ((dat_out_pvld & is_winograd_d1[19]) ^ (|mon_dat_out_pra_vld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////////////////////////////////
///// finial registers                                   /////
//////////////////////////////////////////////////////////////

always @(
  is_winograd_d1
  or dat_out_wg_data
  or is_int8_d1
  or dat_out_bypass_data
  ) begin
    dat_out_data = is_winograd_d1[20] ? dat_out_wg_data :
                   is_int8_d1[21] ? {2{dat_out_bypass_data[511:0]}} :
                   dat_out_bypass_data;
end

always @(
  dat_out_pvld
  or is_winograd_d1
  or dat_out_wg_mask
  or is_int8_d1
  or dat_out_bypass_mask
  ) begin
    dat_out_mask = ~dat_out_pvld ? 128'b0 :
                   is_winograd_d1[21] ? dat_out_wg_mask :
                   is_int8_d1[22] ? {2{dat_out_bypass_mask[63:0]}} :
                   dat_out_bypass_mask;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_out_pvld <= 1'b0;
  end else begin
  dl_out_pvld <= dat_out_pvld;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_out_mask <= {128{1'b0}};
  end else begin
  if ((dat_out_pvld | dl_out_pvld) == 1'b1) begin
    dl_out_mask <= dat_out_mask;
  // VCS coverage off
  end else if ((dat_out_pvld | dl_out_pvld) == 1'b0) begin
  end else begin
    dl_out_mask <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_220x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_out_pvld | dl_out_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_out_flag <= {9{1'b0}};
  end else begin
  if ((dat_out_pvld) == 1'b1) begin
    dl_out_flag <= dat_out_flag;
  // VCS coverage off
  end else if ((dat_out_pvld) == 1'b0) begin
  end else begin
    dl_out_flag <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_221x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dat_out_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[0]) == 1'b1) begin
    dl_out_data0 <= dat_out_data[7:0];
  // VCS coverage off
  end else if ((dat_out_mask[0]) == 1'b0) begin
  end else begin
    dl_out_data0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[1]) == 1'b1) begin
    dl_out_data1 <= dat_out_data[15:8];
  // VCS coverage off
  end else if ((dat_out_mask[1]) == 1'b0) begin
  end else begin
    dl_out_data1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[2]) == 1'b1) begin
    dl_out_data2 <= dat_out_data[23:16];
  // VCS coverage off
  end else if ((dat_out_mask[2]) == 1'b0) begin
  end else begin
    dl_out_data2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[3]) == 1'b1) begin
    dl_out_data3 <= dat_out_data[31:24];
  // VCS coverage off
  end else if ((dat_out_mask[3]) == 1'b0) begin
  end else begin
    dl_out_data3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[4]) == 1'b1) begin
    dl_out_data4 <= dat_out_data[39:32];
  // VCS coverage off
  end else if ((dat_out_mask[4]) == 1'b0) begin
  end else begin
    dl_out_data4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[5]) == 1'b1) begin
    dl_out_data5 <= dat_out_data[47:40];
  // VCS coverage off
  end else if ((dat_out_mask[5]) == 1'b0) begin
  end else begin
    dl_out_data5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[6]) == 1'b1) begin
    dl_out_data6 <= dat_out_data[55:48];
  // VCS coverage off
  end else if ((dat_out_mask[6]) == 1'b0) begin
  end else begin
    dl_out_data6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[7]) == 1'b1) begin
    dl_out_data7 <= dat_out_data[63:56];
  // VCS coverage off
  end else if ((dat_out_mask[7]) == 1'b0) begin
  end else begin
    dl_out_data7 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[8]) == 1'b1) begin
    dl_out_data8 <= dat_out_data[71:64];
  // VCS coverage off
  end else if ((dat_out_mask[8]) == 1'b0) begin
  end else begin
    dl_out_data8 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[9]) == 1'b1) begin
    dl_out_data9 <= dat_out_data[79:72];
  // VCS coverage off
  end else if ((dat_out_mask[9]) == 1'b0) begin
  end else begin
    dl_out_data9 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[10]) == 1'b1) begin
    dl_out_data10 <= dat_out_data[87:80];
  // VCS coverage off
  end else if ((dat_out_mask[10]) == 1'b0) begin
  end else begin
    dl_out_data10 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[11]) == 1'b1) begin
    dl_out_data11 <= dat_out_data[95:88];
  // VCS coverage off
  end else if ((dat_out_mask[11]) == 1'b0) begin
  end else begin
    dl_out_data11 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[12]) == 1'b1) begin
    dl_out_data12 <= dat_out_data[103:96];
  // VCS coverage off
  end else if ((dat_out_mask[12]) == 1'b0) begin
  end else begin
    dl_out_data12 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[13]) == 1'b1) begin
    dl_out_data13 <= dat_out_data[111:104];
  // VCS coverage off
  end else if ((dat_out_mask[13]) == 1'b0) begin
  end else begin
    dl_out_data13 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[14]) == 1'b1) begin
    dl_out_data14 <= dat_out_data[119:112];
  // VCS coverage off
  end else if ((dat_out_mask[14]) == 1'b0) begin
  end else begin
    dl_out_data14 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[15]) == 1'b1) begin
    dl_out_data15 <= dat_out_data[127:120];
  // VCS coverage off
  end else if ((dat_out_mask[15]) == 1'b0) begin
  end else begin
    dl_out_data15 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[16]) == 1'b1) begin
    dl_out_data16 <= dat_out_data[135:128];
  // VCS coverage off
  end else if ((dat_out_mask[16]) == 1'b0) begin
  end else begin
    dl_out_data16 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[17]) == 1'b1) begin
    dl_out_data17 <= dat_out_data[143:136];
  // VCS coverage off
  end else if ((dat_out_mask[17]) == 1'b0) begin
  end else begin
    dl_out_data17 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[18]) == 1'b1) begin
    dl_out_data18 <= dat_out_data[151:144];
  // VCS coverage off
  end else if ((dat_out_mask[18]) == 1'b0) begin
  end else begin
    dl_out_data18 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[19]) == 1'b1) begin
    dl_out_data19 <= dat_out_data[159:152];
  // VCS coverage off
  end else if ((dat_out_mask[19]) == 1'b0) begin
  end else begin
    dl_out_data19 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[20]) == 1'b1) begin
    dl_out_data20 <= dat_out_data[167:160];
  // VCS coverage off
  end else if ((dat_out_mask[20]) == 1'b0) begin
  end else begin
    dl_out_data20 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[21]) == 1'b1) begin
    dl_out_data21 <= dat_out_data[175:168];
  // VCS coverage off
  end else if ((dat_out_mask[21]) == 1'b0) begin
  end else begin
    dl_out_data21 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[22]) == 1'b1) begin
    dl_out_data22 <= dat_out_data[183:176];
  // VCS coverage off
  end else if ((dat_out_mask[22]) == 1'b0) begin
  end else begin
    dl_out_data22 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[23]) == 1'b1) begin
    dl_out_data23 <= dat_out_data[191:184];
  // VCS coverage off
  end else if ((dat_out_mask[23]) == 1'b0) begin
  end else begin
    dl_out_data23 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[24]) == 1'b1) begin
    dl_out_data24 <= dat_out_data[199:192];
  // VCS coverage off
  end else if ((dat_out_mask[24]) == 1'b0) begin
  end else begin
    dl_out_data24 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[25]) == 1'b1) begin
    dl_out_data25 <= dat_out_data[207:200];
  // VCS coverage off
  end else if ((dat_out_mask[25]) == 1'b0) begin
  end else begin
    dl_out_data25 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[26]) == 1'b1) begin
    dl_out_data26 <= dat_out_data[215:208];
  // VCS coverage off
  end else if ((dat_out_mask[26]) == 1'b0) begin
  end else begin
    dl_out_data26 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[27]) == 1'b1) begin
    dl_out_data27 <= dat_out_data[223:216];
  // VCS coverage off
  end else if ((dat_out_mask[27]) == 1'b0) begin
  end else begin
    dl_out_data27 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[28]) == 1'b1) begin
    dl_out_data28 <= dat_out_data[231:224];
  // VCS coverage off
  end else if ((dat_out_mask[28]) == 1'b0) begin
  end else begin
    dl_out_data28 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[29]) == 1'b1) begin
    dl_out_data29 <= dat_out_data[239:232];
  // VCS coverage off
  end else if ((dat_out_mask[29]) == 1'b0) begin
  end else begin
    dl_out_data29 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[30]) == 1'b1) begin
    dl_out_data30 <= dat_out_data[247:240];
  // VCS coverage off
  end else if ((dat_out_mask[30]) == 1'b0) begin
  end else begin
    dl_out_data30 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[31]) == 1'b1) begin
    dl_out_data31 <= dat_out_data[255:248];
  // VCS coverage off
  end else if ((dat_out_mask[31]) == 1'b0) begin
  end else begin
    dl_out_data31 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[32]) == 1'b1) begin
    dl_out_data32 <= dat_out_data[263:256];
  // VCS coverage off
  end else if ((dat_out_mask[32]) == 1'b0) begin
  end else begin
    dl_out_data32 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[33]) == 1'b1) begin
    dl_out_data33 <= dat_out_data[271:264];
  // VCS coverage off
  end else if ((dat_out_mask[33]) == 1'b0) begin
  end else begin
    dl_out_data33 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[34]) == 1'b1) begin
    dl_out_data34 <= dat_out_data[279:272];
  // VCS coverage off
  end else if ((dat_out_mask[34]) == 1'b0) begin
  end else begin
    dl_out_data34 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[35]) == 1'b1) begin
    dl_out_data35 <= dat_out_data[287:280];
  // VCS coverage off
  end else if ((dat_out_mask[35]) == 1'b0) begin
  end else begin
    dl_out_data35 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[36]) == 1'b1) begin
    dl_out_data36 <= dat_out_data[295:288];
  // VCS coverage off
  end else if ((dat_out_mask[36]) == 1'b0) begin
  end else begin
    dl_out_data36 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[37]) == 1'b1) begin
    dl_out_data37 <= dat_out_data[303:296];
  // VCS coverage off
  end else if ((dat_out_mask[37]) == 1'b0) begin
  end else begin
    dl_out_data37 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[38]) == 1'b1) begin
    dl_out_data38 <= dat_out_data[311:304];
  // VCS coverage off
  end else if ((dat_out_mask[38]) == 1'b0) begin
  end else begin
    dl_out_data38 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[39]) == 1'b1) begin
    dl_out_data39 <= dat_out_data[319:312];
  // VCS coverage off
  end else if ((dat_out_mask[39]) == 1'b0) begin
  end else begin
    dl_out_data39 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[40]) == 1'b1) begin
    dl_out_data40 <= dat_out_data[327:320];
  // VCS coverage off
  end else if ((dat_out_mask[40]) == 1'b0) begin
  end else begin
    dl_out_data40 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[41]) == 1'b1) begin
    dl_out_data41 <= dat_out_data[335:328];
  // VCS coverage off
  end else if ((dat_out_mask[41]) == 1'b0) begin
  end else begin
    dl_out_data41 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[42]) == 1'b1) begin
    dl_out_data42 <= dat_out_data[343:336];
  // VCS coverage off
  end else if ((dat_out_mask[42]) == 1'b0) begin
  end else begin
    dl_out_data42 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[43]) == 1'b1) begin
    dl_out_data43 <= dat_out_data[351:344];
  // VCS coverage off
  end else if ((dat_out_mask[43]) == 1'b0) begin
  end else begin
    dl_out_data43 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[44]) == 1'b1) begin
    dl_out_data44 <= dat_out_data[359:352];
  // VCS coverage off
  end else if ((dat_out_mask[44]) == 1'b0) begin
  end else begin
    dl_out_data44 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[45]) == 1'b1) begin
    dl_out_data45 <= dat_out_data[367:360];
  // VCS coverage off
  end else if ((dat_out_mask[45]) == 1'b0) begin
  end else begin
    dl_out_data45 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[46]) == 1'b1) begin
    dl_out_data46 <= dat_out_data[375:368];
  // VCS coverage off
  end else if ((dat_out_mask[46]) == 1'b0) begin
  end else begin
    dl_out_data46 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[47]) == 1'b1) begin
    dl_out_data47 <= dat_out_data[383:376];
  // VCS coverage off
  end else if ((dat_out_mask[47]) == 1'b0) begin
  end else begin
    dl_out_data47 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[48]) == 1'b1) begin
    dl_out_data48 <= dat_out_data[391:384];
  // VCS coverage off
  end else if ((dat_out_mask[48]) == 1'b0) begin
  end else begin
    dl_out_data48 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[49]) == 1'b1) begin
    dl_out_data49 <= dat_out_data[399:392];
  // VCS coverage off
  end else if ((dat_out_mask[49]) == 1'b0) begin
  end else begin
    dl_out_data49 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[50]) == 1'b1) begin
    dl_out_data50 <= dat_out_data[407:400];
  // VCS coverage off
  end else if ((dat_out_mask[50]) == 1'b0) begin
  end else begin
    dl_out_data50 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[51]) == 1'b1) begin
    dl_out_data51 <= dat_out_data[415:408];
  // VCS coverage off
  end else if ((dat_out_mask[51]) == 1'b0) begin
  end else begin
    dl_out_data51 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[52]) == 1'b1) begin
    dl_out_data52 <= dat_out_data[423:416];
  // VCS coverage off
  end else if ((dat_out_mask[52]) == 1'b0) begin
  end else begin
    dl_out_data52 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[53]) == 1'b1) begin
    dl_out_data53 <= dat_out_data[431:424];
  // VCS coverage off
  end else if ((dat_out_mask[53]) == 1'b0) begin
  end else begin
    dl_out_data53 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[54]) == 1'b1) begin
    dl_out_data54 <= dat_out_data[439:432];
  // VCS coverage off
  end else if ((dat_out_mask[54]) == 1'b0) begin
  end else begin
    dl_out_data54 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[55]) == 1'b1) begin
    dl_out_data55 <= dat_out_data[447:440];
  // VCS coverage off
  end else if ((dat_out_mask[55]) == 1'b0) begin
  end else begin
    dl_out_data55 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[56]) == 1'b1) begin
    dl_out_data56 <= dat_out_data[455:448];
  // VCS coverage off
  end else if ((dat_out_mask[56]) == 1'b0) begin
  end else begin
    dl_out_data56 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[57]) == 1'b1) begin
    dl_out_data57 <= dat_out_data[463:456];
  // VCS coverage off
  end else if ((dat_out_mask[57]) == 1'b0) begin
  end else begin
    dl_out_data57 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[58]) == 1'b1) begin
    dl_out_data58 <= dat_out_data[471:464];
  // VCS coverage off
  end else if ((dat_out_mask[58]) == 1'b0) begin
  end else begin
    dl_out_data58 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[59]) == 1'b1) begin
    dl_out_data59 <= dat_out_data[479:472];
  // VCS coverage off
  end else if ((dat_out_mask[59]) == 1'b0) begin
  end else begin
    dl_out_data59 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[60]) == 1'b1) begin
    dl_out_data60 <= dat_out_data[487:480];
  // VCS coverage off
  end else if ((dat_out_mask[60]) == 1'b0) begin
  end else begin
    dl_out_data60 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[61]) == 1'b1) begin
    dl_out_data61 <= dat_out_data[495:488];
  // VCS coverage off
  end else if ((dat_out_mask[61]) == 1'b0) begin
  end else begin
    dl_out_data61 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[62]) == 1'b1) begin
    dl_out_data62 <= dat_out_data[503:496];
  // VCS coverage off
  end else if ((dat_out_mask[62]) == 1'b0) begin
  end else begin
    dl_out_data62 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[63]) == 1'b1) begin
    dl_out_data63 <= dat_out_data[511:504];
  // VCS coverage off
  end else if ((dat_out_mask[63]) == 1'b0) begin
  end else begin
    dl_out_data63 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[64]) == 1'b1) begin
    dl_out_data64 <= dat_out_data[519:512];
  // VCS coverage off
  end else if ((dat_out_mask[64]) == 1'b0) begin
  end else begin
    dl_out_data64 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[65]) == 1'b1) begin
    dl_out_data65 <= dat_out_data[527:520];
  // VCS coverage off
  end else if ((dat_out_mask[65]) == 1'b0) begin
  end else begin
    dl_out_data65 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[66]) == 1'b1) begin
    dl_out_data66 <= dat_out_data[535:528];
  // VCS coverage off
  end else if ((dat_out_mask[66]) == 1'b0) begin
  end else begin
    dl_out_data66 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[67]) == 1'b1) begin
    dl_out_data67 <= dat_out_data[543:536];
  // VCS coverage off
  end else if ((dat_out_mask[67]) == 1'b0) begin
  end else begin
    dl_out_data67 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[68]) == 1'b1) begin
    dl_out_data68 <= dat_out_data[551:544];
  // VCS coverage off
  end else if ((dat_out_mask[68]) == 1'b0) begin
  end else begin
    dl_out_data68 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[69]) == 1'b1) begin
    dl_out_data69 <= dat_out_data[559:552];
  // VCS coverage off
  end else if ((dat_out_mask[69]) == 1'b0) begin
  end else begin
    dl_out_data69 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[70]) == 1'b1) begin
    dl_out_data70 <= dat_out_data[567:560];
  // VCS coverage off
  end else if ((dat_out_mask[70]) == 1'b0) begin
  end else begin
    dl_out_data70 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[71]) == 1'b1) begin
    dl_out_data71 <= dat_out_data[575:568];
  // VCS coverage off
  end else if ((dat_out_mask[71]) == 1'b0) begin
  end else begin
    dl_out_data71 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[72]) == 1'b1) begin
    dl_out_data72 <= dat_out_data[583:576];
  // VCS coverage off
  end else if ((dat_out_mask[72]) == 1'b0) begin
  end else begin
    dl_out_data72 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[73]) == 1'b1) begin
    dl_out_data73 <= dat_out_data[591:584];
  // VCS coverage off
  end else if ((dat_out_mask[73]) == 1'b0) begin
  end else begin
    dl_out_data73 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[74]) == 1'b1) begin
    dl_out_data74 <= dat_out_data[599:592];
  // VCS coverage off
  end else if ((dat_out_mask[74]) == 1'b0) begin
  end else begin
    dl_out_data74 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[75]) == 1'b1) begin
    dl_out_data75 <= dat_out_data[607:600];
  // VCS coverage off
  end else if ((dat_out_mask[75]) == 1'b0) begin
  end else begin
    dl_out_data75 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[76]) == 1'b1) begin
    dl_out_data76 <= dat_out_data[615:608];
  // VCS coverage off
  end else if ((dat_out_mask[76]) == 1'b0) begin
  end else begin
    dl_out_data76 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[77]) == 1'b1) begin
    dl_out_data77 <= dat_out_data[623:616];
  // VCS coverage off
  end else if ((dat_out_mask[77]) == 1'b0) begin
  end else begin
    dl_out_data77 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[78]) == 1'b1) begin
    dl_out_data78 <= dat_out_data[631:624];
  // VCS coverage off
  end else if ((dat_out_mask[78]) == 1'b0) begin
  end else begin
    dl_out_data78 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[79]) == 1'b1) begin
    dl_out_data79 <= dat_out_data[639:632];
  // VCS coverage off
  end else if ((dat_out_mask[79]) == 1'b0) begin
  end else begin
    dl_out_data79 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[80]) == 1'b1) begin
    dl_out_data80 <= dat_out_data[647:640];
  // VCS coverage off
  end else if ((dat_out_mask[80]) == 1'b0) begin
  end else begin
    dl_out_data80 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[81]) == 1'b1) begin
    dl_out_data81 <= dat_out_data[655:648];
  // VCS coverage off
  end else if ((dat_out_mask[81]) == 1'b0) begin
  end else begin
    dl_out_data81 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[82]) == 1'b1) begin
    dl_out_data82 <= dat_out_data[663:656];
  // VCS coverage off
  end else if ((dat_out_mask[82]) == 1'b0) begin
  end else begin
    dl_out_data82 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[83]) == 1'b1) begin
    dl_out_data83 <= dat_out_data[671:664];
  // VCS coverage off
  end else if ((dat_out_mask[83]) == 1'b0) begin
  end else begin
    dl_out_data83 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[84]) == 1'b1) begin
    dl_out_data84 <= dat_out_data[679:672];
  // VCS coverage off
  end else if ((dat_out_mask[84]) == 1'b0) begin
  end else begin
    dl_out_data84 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[85]) == 1'b1) begin
    dl_out_data85 <= dat_out_data[687:680];
  // VCS coverage off
  end else if ((dat_out_mask[85]) == 1'b0) begin
  end else begin
    dl_out_data85 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[86]) == 1'b1) begin
    dl_out_data86 <= dat_out_data[695:688];
  // VCS coverage off
  end else if ((dat_out_mask[86]) == 1'b0) begin
  end else begin
    dl_out_data86 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[87]) == 1'b1) begin
    dl_out_data87 <= dat_out_data[703:696];
  // VCS coverage off
  end else if ((dat_out_mask[87]) == 1'b0) begin
  end else begin
    dl_out_data87 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[88]) == 1'b1) begin
    dl_out_data88 <= dat_out_data[711:704];
  // VCS coverage off
  end else if ((dat_out_mask[88]) == 1'b0) begin
  end else begin
    dl_out_data88 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[89]) == 1'b1) begin
    dl_out_data89 <= dat_out_data[719:712];
  // VCS coverage off
  end else if ((dat_out_mask[89]) == 1'b0) begin
  end else begin
    dl_out_data89 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[90]) == 1'b1) begin
    dl_out_data90 <= dat_out_data[727:720];
  // VCS coverage off
  end else if ((dat_out_mask[90]) == 1'b0) begin
  end else begin
    dl_out_data90 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[91]) == 1'b1) begin
    dl_out_data91 <= dat_out_data[735:728];
  // VCS coverage off
  end else if ((dat_out_mask[91]) == 1'b0) begin
  end else begin
    dl_out_data91 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[92]) == 1'b1) begin
    dl_out_data92 <= dat_out_data[743:736];
  // VCS coverage off
  end else if ((dat_out_mask[92]) == 1'b0) begin
  end else begin
    dl_out_data92 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[93]) == 1'b1) begin
    dl_out_data93 <= dat_out_data[751:744];
  // VCS coverage off
  end else if ((dat_out_mask[93]) == 1'b0) begin
  end else begin
    dl_out_data93 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[94]) == 1'b1) begin
    dl_out_data94 <= dat_out_data[759:752];
  // VCS coverage off
  end else if ((dat_out_mask[94]) == 1'b0) begin
  end else begin
    dl_out_data94 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[95]) == 1'b1) begin
    dl_out_data95 <= dat_out_data[767:760];
  // VCS coverage off
  end else if ((dat_out_mask[95]) == 1'b0) begin
  end else begin
    dl_out_data95 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[96]) == 1'b1) begin
    dl_out_data96 <= dat_out_data[775:768];
  // VCS coverage off
  end else if ((dat_out_mask[96]) == 1'b0) begin
  end else begin
    dl_out_data96 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[97]) == 1'b1) begin
    dl_out_data97 <= dat_out_data[783:776];
  // VCS coverage off
  end else if ((dat_out_mask[97]) == 1'b0) begin
  end else begin
    dl_out_data97 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[98]) == 1'b1) begin
    dl_out_data98 <= dat_out_data[791:784];
  // VCS coverage off
  end else if ((dat_out_mask[98]) == 1'b0) begin
  end else begin
    dl_out_data98 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[99]) == 1'b1) begin
    dl_out_data99 <= dat_out_data[799:792];
  // VCS coverage off
  end else if ((dat_out_mask[99]) == 1'b0) begin
  end else begin
    dl_out_data99 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[100]) == 1'b1) begin
    dl_out_data100 <= dat_out_data[807:800];
  // VCS coverage off
  end else if ((dat_out_mask[100]) == 1'b0) begin
  end else begin
    dl_out_data100 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[101]) == 1'b1) begin
    dl_out_data101 <= dat_out_data[815:808];
  // VCS coverage off
  end else if ((dat_out_mask[101]) == 1'b0) begin
  end else begin
    dl_out_data101 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[102]) == 1'b1) begin
    dl_out_data102 <= dat_out_data[823:816];
  // VCS coverage off
  end else if ((dat_out_mask[102]) == 1'b0) begin
  end else begin
    dl_out_data102 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[103]) == 1'b1) begin
    dl_out_data103 <= dat_out_data[831:824];
  // VCS coverage off
  end else if ((dat_out_mask[103]) == 1'b0) begin
  end else begin
    dl_out_data103 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[104]) == 1'b1) begin
    dl_out_data104 <= dat_out_data[839:832];
  // VCS coverage off
  end else if ((dat_out_mask[104]) == 1'b0) begin
  end else begin
    dl_out_data104 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[105]) == 1'b1) begin
    dl_out_data105 <= dat_out_data[847:840];
  // VCS coverage off
  end else if ((dat_out_mask[105]) == 1'b0) begin
  end else begin
    dl_out_data105 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[106]) == 1'b1) begin
    dl_out_data106 <= dat_out_data[855:848];
  // VCS coverage off
  end else if ((dat_out_mask[106]) == 1'b0) begin
  end else begin
    dl_out_data106 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[107]) == 1'b1) begin
    dl_out_data107 <= dat_out_data[863:856];
  // VCS coverage off
  end else if ((dat_out_mask[107]) == 1'b0) begin
  end else begin
    dl_out_data107 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[108]) == 1'b1) begin
    dl_out_data108 <= dat_out_data[871:864];
  // VCS coverage off
  end else if ((dat_out_mask[108]) == 1'b0) begin
  end else begin
    dl_out_data108 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[109]) == 1'b1) begin
    dl_out_data109 <= dat_out_data[879:872];
  // VCS coverage off
  end else if ((dat_out_mask[109]) == 1'b0) begin
  end else begin
    dl_out_data109 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[110]) == 1'b1) begin
    dl_out_data110 <= dat_out_data[887:880];
  // VCS coverage off
  end else if ((dat_out_mask[110]) == 1'b0) begin
  end else begin
    dl_out_data110 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[111]) == 1'b1) begin
    dl_out_data111 <= dat_out_data[895:888];
  // VCS coverage off
  end else if ((dat_out_mask[111]) == 1'b0) begin
  end else begin
    dl_out_data111 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[112]) == 1'b1) begin
    dl_out_data112 <= dat_out_data[903:896];
  // VCS coverage off
  end else if ((dat_out_mask[112]) == 1'b0) begin
  end else begin
    dl_out_data112 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[113]) == 1'b1) begin
    dl_out_data113 <= dat_out_data[911:904];
  // VCS coverage off
  end else if ((dat_out_mask[113]) == 1'b0) begin
  end else begin
    dl_out_data113 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[114]) == 1'b1) begin
    dl_out_data114 <= dat_out_data[919:912];
  // VCS coverage off
  end else if ((dat_out_mask[114]) == 1'b0) begin
  end else begin
    dl_out_data114 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[115]) == 1'b1) begin
    dl_out_data115 <= dat_out_data[927:920];
  // VCS coverage off
  end else if ((dat_out_mask[115]) == 1'b0) begin
  end else begin
    dl_out_data115 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[116]) == 1'b1) begin
    dl_out_data116 <= dat_out_data[935:928];
  // VCS coverage off
  end else if ((dat_out_mask[116]) == 1'b0) begin
  end else begin
    dl_out_data116 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[117]) == 1'b1) begin
    dl_out_data117 <= dat_out_data[943:936];
  // VCS coverage off
  end else if ((dat_out_mask[117]) == 1'b0) begin
  end else begin
    dl_out_data117 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[118]) == 1'b1) begin
    dl_out_data118 <= dat_out_data[951:944];
  // VCS coverage off
  end else if ((dat_out_mask[118]) == 1'b0) begin
  end else begin
    dl_out_data118 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[119]) == 1'b1) begin
    dl_out_data119 <= dat_out_data[959:952];
  // VCS coverage off
  end else if ((dat_out_mask[119]) == 1'b0) begin
  end else begin
    dl_out_data119 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[120]) == 1'b1) begin
    dl_out_data120 <= dat_out_data[967:960];
  // VCS coverage off
  end else if ((dat_out_mask[120]) == 1'b0) begin
  end else begin
    dl_out_data120 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[121]) == 1'b1) begin
    dl_out_data121 <= dat_out_data[975:968];
  // VCS coverage off
  end else if ((dat_out_mask[121]) == 1'b0) begin
  end else begin
    dl_out_data121 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[122]) == 1'b1) begin
    dl_out_data122 <= dat_out_data[983:976];
  // VCS coverage off
  end else if ((dat_out_mask[122]) == 1'b0) begin
  end else begin
    dl_out_data122 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[123]) == 1'b1) begin
    dl_out_data123 <= dat_out_data[991:984];
  // VCS coverage off
  end else if ((dat_out_mask[123]) == 1'b0) begin
  end else begin
    dl_out_data123 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[124]) == 1'b1) begin
    dl_out_data124 <= dat_out_data[999:992];
  // VCS coverage off
  end else if ((dat_out_mask[124]) == 1'b0) begin
  end else begin
    dl_out_data124 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[125]) == 1'b1) begin
    dl_out_data125 <= dat_out_data[1007:1000];
  // VCS coverage off
  end else if ((dat_out_mask[125]) == 1'b0) begin
  end else begin
    dl_out_data125 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[126]) == 1'b1) begin
    dl_out_data126 <= dat_out_data[1015:1008];
  // VCS coverage off
  end else if ((dat_out_mask[126]) == 1'b0) begin
  end else begin
    dl_out_data126 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dat_out_mask[127]) == 1'b1) begin
    dl_out_data127 <= dat_out_data[1023:1016];
  // VCS coverage off
  end else if ((dat_out_mask[127]) == 1'b0) begin
  end else begin
    dl_out_data127 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end




//////////////////////////////////////////////////////////////
///// registers for retiming                             /////
//////////////////////////////////////////////////////////////

always @(
  dl_out_pvld
  or dl_out_flag
  ) begin
    sc2mac_dat_pd_w = ~dl_out_pvld ? 9'b0 : dl_out_flag;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dl_out_pvld_d1 <= 1'b0;
  end else begin
  dl_out_pvld_d1 <= dl_out_pvld;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2mac_dat_a_pvld <= 1'b0;
  end else begin
  sc2mac_dat_a_pvld <= dl_out_pvld;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2mac_dat_b_pvld <= 1'b0;
  end else begin
  sc2mac_dat_b_pvld <= dl_out_pvld;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2mac_dat_a_pd <= {9{1'b0}};
  end else begin
  if ((dl_out_pvld | dl_out_pvld_d1) == 1'b1) begin
    sc2mac_dat_a_pd <= sc2mac_dat_pd_w;
  // VCS coverage off
  end else if ((dl_out_pvld | dl_out_pvld_d1) == 1'b0) begin
  end else begin
    sc2mac_dat_a_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_222x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dl_out_pvld | dl_out_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2mac_dat_b_pd <= {9{1'b0}};
  end else begin
  if ((dl_out_pvld | dl_out_pvld_d1) == 1'b1) begin
    sc2mac_dat_b_pd <= sc2mac_dat_pd_w;
  // VCS coverage off
  end else if ((dl_out_pvld | dl_out_pvld_d1) == 1'b0) begin
  end else begin
    sc2mac_dat_b_pd <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_223x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dl_out_pvld | dl_out_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2mac_dat_a_mask <= {128{1'b0}};
  end else begin
  if ((dl_out_pvld | dl_out_pvld_d1) == 1'b1) begin
    sc2mac_dat_a_mask <= dl_out_mask;
  // VCS coverage off
  end else if ((dl_out_pvld | dl_out_pvld_d1) == 1'b0) begin
  end else begin
    sc2mac_dat_a_mask <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_224x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dl_out_pvld | dl_out_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2mac_dat_b_mask <= {128{1'b0}};
  end else begin
  if ((dl_out_pvld | dl_out_pvld_d1) == 1'b1) begin
    sc2mac_dat_b_mask <= dl_out_mask;
  // VCS coverage off
  end else if ((dl_out_pvld | dl_out_pvld_d1) == 1'b0) begin
  end else begin
    sc2mac_dat_b_mask <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_225x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dl_out_pvld | dl_out_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[0]) == 1'b1) begin
    sc2mac_dat_a_data0 <= dl_out_data0;
  // VCS coverage off
  end else if ((dl_out_mask[0]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[1]) == 1'b1) begin
    sc2mac_dat_a_data1 <= dl_out_data1;
  // VCS coverage off
  end else if ((dl_out_mask[1]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[2]) == 1'b1) begin
    sc2mac_dat_a_data2 <= dl_out_data2;
  // VCS coverage off
  end else if ((dl_out_mask[2]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[3]) == 1'b1) begin
    sc2mac_dat_a_data3 <= dl_out_data3;
  // VCS coverage off
  end else if ((dl_out_mask[3]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[4]) == 1'b1) begin
    sc2mac_dat_a_data4 <= dl_out_data4;
  // VCS coverage off
  end else if ((dl_out_mask[4]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[5]) == 1'b1) begin
    sc2mac_dat_a_data5 <= dl_out_data5;
  // VCS coverage off
  end else if ((dl_out_mask[5]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[6]) == 1'b1) begin
    sc2mac_dat_a_data6 <= dl_out_data6;
  // VCS coverage off
  end else if ((dl_out_mask[6]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[7]) == 1'b1) begin
    sc2mac_dat_a_data7 <= dl_out_data7;
  // VCS coverage off
  end else if ((dl_out_mask[7]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data7 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[8]) == 1'b1) begin
    sc2mac_dat_a_data8 <= dl_out_data8;
  // VCS coverage off
  end else if ((dl_out_mask[8]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data8 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[9]) == 1'b1) begin
    sc2mac_dat_a_data9 <= dl_out_data9;
  // VCS coverage off
  end else if ((dl_out_mask[9]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data9 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[10]) == 1'b1) begin
    sc2mac_dat_a_data10 <= dl_out_data10;
  // VCS coverage off
  end else if ((dl_out_mask[10]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data10 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[11]) == 1'b1) begin
    sc2mac_dat_a_data11 <= dl_out_data11;
  // VCS coverage off
  end else if ((dl_out_mask[11]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data11 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[12]) == 1'b1) begin
    sc2mac_dat_a_data12 <= dl_out_data12;
  // VCS coverage off
  end else if ((dl_out_mask[12]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data12 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[13]) == 1'b1) begin
    sc2mac_dat_a_data13 <= dl_out_data13;
  // VCS coverage off
  end else if ((dl_out_mask[13]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data13 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[14]) == 1'b1) begin
    sc2mac_dat_a_data14 <= dl_out_data14;
  // VCS coverage off
  end else if ((dl_out_mask[14]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data14 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[15]) == 1'b1) begin
    sc2mac_dat_a_data15 <= dl_out_data15;
  // VCS coverage off
  end else if ((dl_out_mask[15]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data15 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[16]) == 1'b1) begin
    sc2mac_dat_a_data16 <= dl_out_data16;
  // VCS coverage off
  end else if ((dl_out_mask[16]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data16 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[17]) == 1'b1) begin
    sc2mac_dat_a_data17 <= dl_out_data17;
  // VCS coverage off
  end else if ((dl_out_mask[17]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data17 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[18]) == 1'b1) begin
    sc2mac_dat_a_data18 <= dl_out_data18;
  // VCS coverage off
  end else if ((dl_out_mask[18]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data18 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[19]) == 1'b1) begin
    sc2mac_dat_a_data19 <= dl_out_data19;
  // VCS coverage off
  end else if ((dl_out_mask[19]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data19 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[20]) == 1'b1) begin
    sc2mac_dat_a_data20 <= dl_out_data20;
  // VCS coverage off
  end else if ((dl_out_mask[20]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data20 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[21]) == 1'b1) begin
    sc2mac_dat_a_data21 <= dl_out_data21;
  // VCS coverage off
  end else if ((dl_out_mask[21]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data21 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[22]) == 1'b1) begin
    sc2mac_dat_a_data22 <= dl_out_data22;
  // VCS coverage off
  end else if ((dl_out_mask[22]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data22 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[23]) == 1'b1) begin
    sc2mac_dat_a_data23 <= dl_out_data23;
  // VCS coverage off
  end else if ((dl_out_mask[23]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data23 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[24]) == 1'b1) begin
    sc2mac_dat_a_data24 <= dl_out_data24;
  // VCS coverage off
  end else if ((dl_out_mask[24]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data24 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[25]) == 1'b1) begin
    sc2mac_dat_a_data25 <= dl_out_data25;
  // VCS coverage off
  end else if ((dl_out_mask[25]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data25 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[26]) == 1'b1) begin
    sc2mac_dat_a_data26 <= dl_out_data26;
  // VCS coverage off
  end else if ((dl_out_mask[26]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data26 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[27]) == 1'b1) begin
    sc2mac_dat_a_data27 <= dl_out_data27;
  // VCS coverage off
  end else if ((dl_out_mask[27]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data27 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[28]) == 1'b1) begin
    sc2mac_dat_a_data28 <= dl_out_data28;
  // VCS coverage off
  end else if ((dl_out_mask[28]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data28 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[29]) == 1'b1) begin
    sc2mac_dat_a_data29 <= dl_out_data29;
  // VCS coverage off
  end else if ((dl_out_mask[29]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data29 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[30]) == 1'b1) begin
    sc2mac_dat_a_data30 <= dl_out_data30;
  // VCS coverage off
  end else if ((dl_out_mask[30]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data30 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[31]) == 1'b1) begin
    sc2mac_dat_a_data31 <= dl_out_data31;
  // VCS coverage off
  end else if ((dl_out_mask[31]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data31 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[32]) == 1'b1) begin
    sc2mac_dat_a_data32 <= dl_out_data32;
  // VCS coverage off
  end else if ((dl_out_mask[32]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data32 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[33]) == 1'b1) begin
    sc2mac_dat_a_data33 <= dl_out_data33;
  // VCS coverage off
  end else if ((dl_out_mask[33]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data33 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[34]) == 1'b1) begin
    sc2mac_dat_a_data34 <= dl_out_data34;
  // VCS coverage off
  end else if ((dl_out_mask[34]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data34 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[35]) == 1'b1) begin
    sc2mac_dat_a_data35 <= dl_out_data35;
  // VCS coverage off
  end else if ((dl_out_mask[35]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data35 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[36]) == 1'b1) begin
    sc2mac_dat_a_data36 <= dl_out_data36;
  // VCS coverage off
  end else if ((dl_out_mask[36]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data36 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[37]) == 1'b1) begin
    sc2mac_dat_a_data37 <= dl_out_data37;
  // VCS coverage off
  end else if ((dl_out_mask[37]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data37 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[38]) == 1'b1) begin
    sc2mac_dat_a_data38 <= dl_out_data38;
  // VCS coverage off
  end else if ((dl_out_mask[38]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data38 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[39]) == 1'b1) begin
    sc2mac_dat_a_data39 <= dl_out_data39;
  // VCS coverage off
  end else if ((dl_out_mask[39]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data39 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[40]) == 1'b1) begin
    sc2mac_dat_a_data40 <= dl_out_data40;
  // VCS coverage off
  end else if ((dl_out_mask[40]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data40 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[41]) == 1'b1) begin
    sc2mac_dat_a_data41 <= dl_out_data41;
  // VCS coverage off
  end else if ((dl_out_mask[41]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data41 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[42]) == 1'b1) begin
    sc2mac_dat_a_data42 <= dl_out_data42;
  // VCS coverage off
  end else if ((dl_out_mask[42]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data42 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[43]) == 1'b1) begin
    sc2mac_dat_a_data43 <= dl_out_data43;
  // VCS coverage off
  end else if ((dl_out_mask[43]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data43 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[44]) == 1'b1) begin
    sc2mac_dat_a_data44 <= dl_out_data44;
  // VCS coverage off
  end else if ((dl_out_mask[44]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data44 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[45]) == 1'b1) begin
    sc2mac_dat_a_data45 <= dl_out_data45;
  // VCS coverage off
  end else if ((dl_out_mask[45]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data45 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[46]) == 1'b1) begin
    sc2mac_dat_a_data46 <= dl_out_data46;
  // VCS coverage off
  end else if ((dl_out_mask[46]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data46 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[47]) == 1'b1) begin
    sc2mac_dat_a_data47 <= dl_out_data47;
  // VCS coverage off
  end else if ((dl_out_mask[47]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data47 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[48]) == 1'b1) begin
    sc2mac_dat_a_data48 <= dl_out_data48;
  // VCS coverage off
  end else if ((dl_out_mask[48]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data48 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[49]) == 1'b1) begin
    sc2mac_dat_a_data49 <= dl_out_data49;
  // VCS coverage off
  end else if ((dl_out_mask[49]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data49 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[50]) == 1'b1) begin
    sc2mac_dat_a_data50 <= dl_out_data50;
  // VCS coverage off
  end else if ((dl_out_mask[50]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data50 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[51]) == 1'b1) begin
    sc2mac_dat_a_data51 <= dl_out_data51;
  // VCS coverage off
  end else if ((dl_out_mask[51]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data51 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[52]) == 1'b1) begin
    sc2mac_dat_a_data52 <= dl_out_data52;
  // VCS coverage off
  end else if ((dl_out_mask[52]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data52 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[53]) == 1'b1) begin
    sc2mac_dat_a_data53 <= dl_out_data53;
  // VCS coverage off
  end else if ((dl_out_mask[53]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data53 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[54]) == 1'b1) begin
    sc2mac_dat_a_data54 <= dl_out_data54;
  // VCS coverage off
  end else if ((dl_out_mask[54]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data54 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[55]) == 1'b1) begin
    sc2mac_dat_a_data55 <= dl_out_data55;
  // VCS coverage off
  end else if ((dl_out_mask[55]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data55 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[56]) == 1'b1) begin
    sc2mac_dat_a_data56 <= dl_out_data56;
  // VCS coverage off
  end else if ((dl_out_mask[56]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data56 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[57]) == 1'b1) begin
    sc2mac_dat_a_data57 <= dl_out_data57;
  // VCS coverage off
  end else if ((dl_out_mask[57]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data57 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[58]) == 1'b1) begin
    sc2mac_dat_a_data58 <= dl_out_data58;
  // VCS coverage off
  end else if ((dl_out_mask[58]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data58 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[59]) == 1'b1) begin
    sc2mac_dat_a_data59 <= dl_out_data59;
  // VCS coverage off
  end else if ((dl_out_mask[59]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data59 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[60]) == 1'b1) begin
    sc2mac_dat_a_data60 <= dl_out_data60;
  // VCS coverage off
  end else if ((dl_out_mask[60]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data60 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[61]) == 1'b1) begin
    sc2mac_dat_a_data61 <= dl_out_data61;
  // VCS coverage off
  end else if ((dl_out_mask[61]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data61 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[62]) == 1'b1) begin
    sc2mac_dat_a_data62 <= dl_out_data62;
  // VCS coverage off
  end else if ((dl_out_mask[62]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data62 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[63]) == 1'b1) begin
    sc2mac_dat_a_data63 <= dl_out_data63;
  // VCS coverage off
  end else if ((dl_out_mask[63]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data63 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[64]) == 1'b1) begin
    sc2mac_dat_a_data64 <= dl_out_data64;
  // VCS coverage off
  end else if ((dl_out_mask[64]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data64 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[65]) == 1'b1) begin
    sc2mac_dat_a_data65 <= dl_out_data65;
  // VCS coverage off
  end else if ((dl_out_mask[65]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data65 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[66]) == 1'b1) begin
    sc2mac_dat_a_data66 <= dl_out_data66;
  // VCS coverage off
  end else if ((dl_out_mask[66]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data66 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[67]) == 1'b1) begin
    sc2mac_dat_a_data67 <= dl_out_data67;
  // VCS coverage off
  end else if ((dl_out_mask[67]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data67 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[68]) == 1'b1) begin
    sc2mac_dat_a_data68 <= dl_out_data68;
  // VCS coverage off
  end else if ((dl_out_mask[68]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data68 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[69]) == 1'b1) begin
    sc2mac_dat_a_data69 <= dl_out_data69;
  // VCS coverage off
  end else if ((dl_out_mask[69]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data69 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[70]) == 1'b1) begin
    sc2mac_dat_a_data70 <= dl_out_data70;
  // VCS coverage off
  end else if ((dl_out_mask[70]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data70 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[71]) == 1'b1) begin
    sc2mac_dat_a_data71 <= dl_out_data71;
  // VCS coverage off
  end else if ((dl_out_mask[71]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data71 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[72]) == 1'b1) begin
    sc2mac_dat_a_data72 <= dl_out_data72;
  // VCS coverage off
  end else if ((dl_out_mask[72]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data72 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[73]) == 1'b1) begin
    sc2mac_dat_a_data73 <= dl_out_data73;
  // VCS coverage off
  end else if ((dl_out_mask[73]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data73 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[74]) == 1'b1) begin
    sc2mac_dat_a_data74 <= dl_out_data74;
  // VCS coverage off
  end else if ((dl_out_mask[74]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data74 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[75]) == 1'b1) begin
    sc2mac_dat_a_data75 <= dl_out_data75;
  // VCS coverage off
  end else if ((dl_out_mask[75]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data75 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[76]) == 1'b1) begin
    sc2mac_dat_a_data76 <= dl_out_data76;
  // VCS coverage off
  end else if ((dl_out_mask[76]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data76 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[77]) == 1'b1) begin
    sc2mac_dat_a_data77 <= dl_out_data77;
  // VCS coverage off
  end else if ((dl_out_mask[77]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data77 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[78]) == 1'b1) begin
    sc2mac_dat_a_data78 <= dl_out_data78;
  // VCS coverage off
  end else if ((dl_out_mask[78]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data78 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[79]) == 1'b1) begin
    sc2mac_dat_a_data79 <= dl_out_data79;
  // VCS coverage off
  end else if ((dl_out_mask[79]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data79 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[80]) == 1'b1) begin
    sc2mac_dat_a_data80 <= dl_out_data80;
  // VCS coverage off
  end else if ((dl_out_mask[80]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data80 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[81]) == 1'b1) begin
    sc2mac_dat_a_data81 <= dl_out_data81;
  // VCS coverage off
  end else if ((dl_out_mask[81]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data81 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[82]) == 1'b1) begin
    sc2mac_dat_a_data82 <= dl_out_data82;
  // VCS coverage off
  end else if ((dl_out_mask[82]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data82 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[83]) == 1'b1) begin
    sc2mac_dat_a_data83 <= dl_out_data83;
  // VCS coverage off
  end else if ((dl_out_mask[83]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data83 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[84]) == 1'b1) begin
    sc2mac_dat_a_data84 <= dl_out_data84;
  // VCS coverage off
  end else if ((dl_out_mask[84]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data84 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[85]) == 1'b1) begin
    sc2mac_dat_a_data85 <= dl_out_data85;
  // VCS coverage off
  end else if ((dl_out_mask[85]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data85 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[86]) == 1'b1) begin
    sc2mac_dat_a_data86 <= dl_out_data86;
  // VCS coverage off
  end else if ((dl_out_mask[86]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data86 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[87]) == 1'b1) begin
    sc2mac_dat_a_data87 <= dl_out_data87;
  // VCS coverage off
  end else if ((dl_out_mask[87]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data87 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[88]) == 1'b1) begin
    sc2mac_dat_a_data88 <= dl_out_data88;
  // VCS coverage off
  end else if ((dl_out_mask[88]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data88 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[89]) == 1'b1) begin
    sc2mac_dat_a_data89 <= dl_out_data89;
  // VCS coverage off
  end else if ((dl_out_mask[89]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data89 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[90]) == 1'b1) begin
    sc2mac_dat_a_data90 <= dl_out_data90;
  // VCS coverage off
  end else if ((dl_out_mask[90]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data90 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[91]) == 1'b1) begin
    sc2mac_dat_a_data91 <= dl_out_data91;
  // VCS coverage off
  end else if ((dl_out_mask[91]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data91 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[92]) == 1'b1) begin
    sc2mac_dat_a_data92 <= dl_out_data92;
  // VCS coverage off
  end else if ((dl_out_mask[92]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data92 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[93]) == 1'b1) begin
    sc2mac_dat_a_data93 <= dl_out_data93;
  // VCS coverage off
  end else if ((dl_out_mask[93]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data93 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[94]) == 1'b1) begin
    sc2mac_dat_a_data94 <= dl_out_data94;
  // VCS coverage off
  end else if ((dl_out_mask[94]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data94 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[95]) == 1'b1) begin
    sc2mac_dat_a_data95 <= dl_out_data95;
  // VCS coverage off
  end else if ((dl_out_mask[95]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data95 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[96]) == 1'b1) begin
    sc2mac_dat_a_data96 <= dl_out_data96;
  // VCS coverage off
  end else if ((dl_out_mask[96]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data96 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[97]) == 1'b1) begin
    sc2mac_dat_a_data97 <= dl_out_data97;
  // VCS coverage off
  end else if ((dl_out_mask[97]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data97 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[98]) == 1'b1) begin
    sc2mac_dat_a_data98 <= dl_out_data98;
  // VCS coverage off
  end else if ((dl_out_mask[98]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data98 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[99]) == 1'b1) begin
    sc2mac_dat_a_data99 <= dl_out_data99;
  // VCS coverage off
  end else if ((dl_out_mask[99]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data99 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[100]) == 1'b1) begin
    sc2mac_dat_a_data100 <= dl_out_data100;
  // VCS coverage off
  end else if ((dl_out_mask[100]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data100 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[101]) == 1'b1) begin
    sc2mac_dat_a_data101 <= dl_out_data101;
  // VCS coverage off
  end else if ((dl_out_mask[101]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data101 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[102]) == 1'b1) begin
    sc2mac_dat_a_data102 <= dl_out_data102;
  // VCS coverage off
  end else if ((dl_out_mask[102]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data102 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[103]) == 1'b1) begin
    sc2mac_dat_a_data103 <= dl_out_data103;
  // VCS coverage off
  end else if ((dl_out_mask[103]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data103 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[104]) == 1'b1) begin
    sc2mac_dat_a_data104 <= dl_out_data104;
  // VCS coverage off
  end else if ((dl_out_mask[104]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data104 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[105]) == 1'b1) begin
    sc2mac_dat_a_data105 <= dl_out_data105;
  // VCS coverage off
  end else if ((dl_out_mask[105]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data105 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[106]) == 1'b1) begin
    sc2mac_dat_a_data106 <= dl_out_data106;
  // VCS coverage off
  end else if ((dl_out_mask[106]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data106 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[107]) == 1'b1) begin
    sc2mac_dat_a_data107 <= dl_out_data107;
  // VCS coverage off
  end else if ((dl_out_mask[107]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data107 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[108]) == 1'b1) begin
    sc2mac_dat_a_data108 <= dl_out_data108;
  // VCS coverage off
  end else if ((dl_out_mask[108]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data108 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[109]) == 1'b1) begin
    sc2mac_dat_a_data109 <= dl_out_data109;
  // VCS coverage off
  end else if ((dl_out_mask[109]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data109 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[110]) == 1'b1) begin
    sc2mac_dat_a_data110 <= dl_out_data110;
  // VCS coverage off
  end else if ((dl_out_mask[110]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data110 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[111]) == 1'b1) begin
    sc2mac_dat_a_data111 <= dl_out_data111;
  // VCS coverage off
  end else if ((dl_out_mask[111]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data111 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[112]) == 1'b1) begin
    sc2mac_dat_a_data112 <= dl_out_data112;
  // VCS coverage off
  end else if ((dl_out_mask[112]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data112 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[113]) == 1'b1) begin
    sc2mac_dat_a_data113 <= dl_out_data113;
  // VCS coverage off
  end else if ((dl_out_mask[113]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data113 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[114]) == 1'b1) begin
    sc2mac_dat_a_data114 <= dl_out_data114;
  // VCS coverage off
  end else if ((dl_out_mask[114]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data114 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[115]) == 1'b1) begin
    sc2mac_dat_a_data115 <= dl_out_data115;
  // VCS coverage off
  end else if ((dl_out_mask[115]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data115 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[116]) == 1'b1) begin
    sc2mac_dat_a_data116 <= dl_out_data116;
  // VCS coverage off
  end else if ((dl_out_mask[116]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data116 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[117]) == 1'b1) begin
    sc2mac_dat_a_data117 <= dl_out_data117;
  // VCS coverage off
  end else if ((dl_out_mask[117]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data117 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[118]) == 1'b1) begin
    sc2mac_dat_a_data118 <= dl_out_data118;
  // VCS coverage off
  end else if ((dl_out_mask[118]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data118 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[119]) == 1'b1) begin
    sc2mac_dat_a_data119 <= dl_out_data119;
  // VCS coverage off
  end else if ((dl_out_mask[119]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data119 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[120]) == 1'b1) begin
    sc2mac_dat_a_data120 <= dl_out_data120;
  // VCS coverage off
  end else if ((dl_out_mask[120]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data120 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[121]) == 1'b1) begin
    sc2mac_dat_a_data121 <= dl_out_data121;
  // VCS coverage off
  end else if ((dl_out_mask[121]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data121 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[122]) == 1'b1) begin
    sc2mac_dat_a_data122 <= dl_out_data122;
  // VCS coverage off
  end else if ((dl_out_mask[122]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data122 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[123]) == 1'b1) begin
    sc2mac_dat_a_data123 <= dl_out_data123;
  // VCS coverage off
  end else if ((dl_out_mask[123]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data123 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[124]) == 1'b1) begin
    sc2mac_dat_a_data124 <= dl_out_data124;
  // VCS coverage off
  end else if ((dl_out_mask[124]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data124 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[125]) == 1'b1) begin
    sc2mac_dat_a_data125 <= dl_out_data125;
  // VCS coverage off
  end else if ((dl_out_mask[125]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data125 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[126]) == 1'b1) begin
    sc2mac_dat_a_data126 <= dl_out_data126;
  // VCS coverage off
  end else if ((dl_out_mask[126]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data126 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[127]) == 1'b1) begin
    sc2mac_dat_a_data127 <= dl_out_data127;
  // VCS coverage off
  end else if ((dl_out_mask[127]) == 1'b0) begin
  end else begin
    sc2mac_dat_a_data127 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[0]) == 1'b1) begin
    sc2mac_dat_b_data0 <= dl_out_data0;
  // VCS coverage off
  end else if ((dl_out_mask[0]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[1]) == 1'b1) begin
    sc2mac_dat_b_data1 <= dl_out_data1;
  // VCS coverage off
  end else if ((dl_out_mask[1]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[2]) == 1'b1) begin
    sc2mac_dat_b_data2 <= dl_out_data2;
  // VCS coverage off
  end else if ((dl_out_mask[2]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[3]) == 1'b1) begin
    sc2mac_dat_b_data3 <= dl_out_data3;
  // VCS coverage off
  end else if ((dl_out_mask[3]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[4]) == 1'b1) begin
    sc2mac_dat_b_data4 <= dl_out_data4;
  // VCS coverage off
  end else if ((dl_out_mask[4]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[5]) == 1'b1) begin
    sc2mac_dat_b_data5 <= dl_out_data5;
  // VCS coverage off
  end else if ((dl_out_mask[5]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[6]) == 1'b1) begin
    sc2mac_dat_b_data6 <= dl_out_data6;
  // VCS coverage off
  end else if ((dl_out_mask[6]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[7]) == 1'b1) begin
    sc2mac_dat_b_data7 <= dl_out_data7;
  // VCS coverage off
  end else if ((dl_out_mask[7]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data7 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[8]) == 1'b1) begin
    sc2mac_dat_b_data8 <= dl_out_data8;
  // VCS coverage off
  end else if ((dl_out_mask[8]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data8 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[9]) == 1'b1) begin
    sc2mac_dat_b_data9 <= dl_out_data9;
  // VCS coverage off
  end else if ((dl_out_mask[9]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data9 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[10]) == 1'b1) begin
    sc2mac_dat_b_data10 <= dl_out_data10;
  // VCS coverage off
  end else if ((dl_out_mask[10]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data10 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[11]) == 1'b1) begin
    sc2mac_dat_b_data11 <= dl_out_data11;
  // VCS coverage off
  end else if ((dl_out_mask[11]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data11 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[12]) == 1'b1) begin
    sc2mac_dat_b_data12 <= dl_out_data12;
  // VCS coverage off
  end else if ((dl_out_mask[12]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data12 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[13]) == 1'b1) begin
    sc2mac_dat_b_data13 <= dl_out_data13;
  // VCS coverage off
  end else if ((dl_out_mask[13]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data13 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[14]) == 1'b1) begin
    sc2mac_dat_b_data14 <= dl_out_data14;
  // VCS coverage off
  end else if ((dl_out_mask[14]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data14 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[15]) == 1'b1) begin
    sc2mac_dat_b_data15 <= dl_out_data15;
  // VCS coverage off
  end else if ((dl_out_mask[15]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data15 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[16]) == 1'b1) begin
    sc2mac_dat_b_data16 <= dl_out_data16;
  // VCS coverage off
  end else if ((dl_out_mask[16]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data16 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[17]) == 1'b1) begin
    sc2mac_dat_b_data17 <= dl_out_data17;
  // VCS coverage off
  end else if ((dl_out_mask[17]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data17 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[18]) == 1'b1) begin
    sc2mac_dat_b_data18 <= dl_out_data18;
  // VCS coverage off
  end else if ((dl_out_mask[18]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data18 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[19]) == 1'b1) begin
    sc2mac_dat_b_data19 <= dl_out_data19;
  // VCS coverage off
  end else if ((dl_out_mask[19]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data19 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[20]) == 1'b1) begin
    sc2mac_dat_b_data20 <= dl_out_data20;
  // VCS coverage off
  end else if ((dl_out_mask[20]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data20 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[21]) == 1'b1) begin
    sc2mac_dat_b_data21 <= dl_out_data21;
  // VCS coverage off
  end else if ((dl_out_mask[21]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data21 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[22]) == 1'b1) begin
    sc2mac_dat_b_data22 <= dl_out_data22;
  // VCS coverage off
  end else if ((dl_out_mask[22]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data22 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[23]) == 1'b1) begin
    sc2mac_dat_b_data23 <= dl_out_data23;
  // VCS coverage off
  end else if ((dl_out_mask[23]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data23 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[24]) == 1'b1) begin
    sc2mac_dat_b_data24 <= dl_out_data24;
  // VCS coverage off
  end else if ((dl_out_mask[24]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data24 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[25]) == 1'b1) begin
    sc2mac_dat_b_data25 <= dl_out_data25;
  // VCS coverage off
  end else if ((dl_out_mask[25]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data25 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[26]) == 1'b1) begin
    sc2mac_dat_b_data26 <= dl_out_data26;
  // VCS coverage off
  end else if ((dl_out_mask[26]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data26 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[27]) == 1'b1) begin
    sc2mac_dat_b_data27 <= dl_out_data27;
  // VCS coverage off
  end else if ((dl_out_mask[27]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data27 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[28]) == 1'b1) begin
    sc2mac_dat_b_data28 <= dl_out_data28;
  // VCS coverage off
  end else if ((dl_out_mask[28]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data28 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[29]) == 1'b1) begin
    sc2mac_dat_b_data29 <= dl_out_data29;
  // VCS coverage off
  end else if ((dl_out_mask[29]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data29 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[30]) == 1'b1) begin
    sc2mac_dat_b_data30 <= dl_out_data30;
  // VCS coverage off
  end else if ((dl_out_mask[30]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data30 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[31]) == 1'b1) begin
    sc2mac_dat_b_data31 <= dl_out_data31;
  // VCS coverage off
  end else if ((dl_out_mask[31]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data31 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[32]) == 1'b1) begin
    sc2mac_dat_b_data32 <= dl_out_data32;
  // VCS coverage off
  end else if ((dl_out_mask[32]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data32 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[33]) == 1'b1) begin
    sc2mac_dat_b_data33 <= dl_out_data33;
  // VCS coverage off
  end else if ((dl_out_mask[33]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data33 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[34]) == 1'b1) begin
    sc2mac_dat_b_data34 <= dl_out_data34;
  // VCS coverage off
  end else if ((dl_out_mask[34]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data34 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[35]) == 1'b1) begin
    sc2mac_dat_b_data35 <= dl_out_data35;
  // VCS coverage off
  end else if ((dl_out_mask[35]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data35 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[36]) == 1'b1) begin
    sc2mac_dat_b_data36 <= dl_out_data36;
  // VCS coverage off
  end else if ((dl_out_mask[36]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data36 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[37]) == 1'b1) begin
    sc2mac_dat_b_data37 <= dl_out_data37;
  // VCS coverage off
  end else if ((dl_out_mask[37]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data37 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[38]) == 1'b1) begin
    sc2mac_dat_b_data38 <= dl_out_data38;
  // VCS coverage off
  end else if ((dl_out_mask[38]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data38 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[39]) == 1'b1) begin
    sc2mac_dat_b_data39 <= dl_out_data39;
  // VCS coverage off
  end else if ((dl_out_mask[39]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data39 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[40]) == 1'b1) begin
    sc2mac_dat_b_data40 <= dl_out_data40;
  // VCS coverage off
  end else if ((dl_out_mask[40]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data40 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[41]) == 1'b1) begin
    sc2mac_dat_b_data41 <= dl_out_data41;
  // VCS coverage off
  end else if ((dl_out_mask[41]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data41 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[42]) == 1'b1) begin
    sc2mac_dat_b_data42 <= dl_out_data42;
  // VCS coverage off
  end else if ((dl_out_mask[42]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data42 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[43]) == 1'b1) begin
    sc2mac_dat_b_data43 <= dl_out_data43;
  // VCS coverage off
  end else if ((dl_out_mask[43]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data43 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[44]) == 1'b1) begin
    sc2mac_dat_b_data44 <= dl_out_data44;
  // VCS coverage off
  end else if ((dl_out_mask[44]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data44 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[45]) == 1'b1) begin
    sc2mac_dat_b_data45 <= dl_out_data45;
  // VCS coverage off
  end else if ((dl_out_mask[45]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data45 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[46]) == 1'b1) begin
    sc2mac_dat_b_data46 <= dl_out_data46;
  // VCS coverage off
  end else if ((dl_out_mask[46]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data46 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[47]) == 1'b1) begin
    sc2mac_dat_b_data47 <= dl_out_data47;
  // VCS coverage off
  end else if ((dl_out_mask[47]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data47 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[48]) == 1'b1) begin
    sc2mac_dat_b_data48 <= dl_out_data48;
  // VCS coverage off
  end else if ((dl_out_mask[48]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data48 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[49]) == 1'b1) begin
    sc2mac_dat_b_data49 <= dl_out_data49;
  // VCS coverage off
  end else if ((dl_out_mask[49]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data49 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[50]) == 1'b1) begin
    sc2mac_dat_b_data50 <= dl_out_data50;
  // VCS coverage off
  end else if ((dl_out_mask[50]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data50 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[51]) == 1'b1) begin
    sc2mac_dat_b_data51 <= dl_out_data51;
  // VCS coverage off
  end else if ((dl_out_mask[51]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data51 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[52]) == 1'b1) begin
    sc2mac_dat_b_data52 <= dl_out_data52;
  // VCS coverage off
  end else if ((dl_out_mask[52]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data52 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[53]) == 1'b1) begin
    sc2mac_dat_b_data53 <= dl_out_data53;
  // VCS coverage off
  end else if ((dl_out_mask[53]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data53 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[54]) == 1'b1) begin
    sc2mac_dat_b_data54 <= dl_out_data54;
  // VCS coverage off
  end else if ((dl_out_mask[54]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data54 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[55]) == 1'b1) begin
    sc2mac_dat_b_data55 <= dl_out_data55;
  // VCS coverage off
  end else if ((dl_out_mask[55]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data55 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[56]) == 1'b1) begin
    sc2mac_dat_b_data56 <= dl_out_data56;
  // VCS coverage off
  end else if ((dl_out_mask[56]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data56 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[57]) == 1'b1) begin
    sc2mac_dat_b_data57 <= dl_out_data57;
  // VCS coverage off
  end else if ((dl_out_mask[57]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data57 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[58]) == 1'b1) begin
    sc2mac_dat_b_data58 <= dl_out_data58;
  // VCS coverage off
  end else if ((dl_out_mask[58]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data58 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[59]) == 1'b1) begin
    sc2mac_dat_b_data59 <= dl_out_data59;
  // VCS coverage off
  end else if ((dl_out_mask[59]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data59 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[60]) == 1'b1) begin
    sc2mac_dat_b_data60 <= dl_out_data60;
  // VCS coverage off
  end else if ((dl_out_mask[60]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data60 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[61]) == 1'b1) begin
    sc2mac_dat_b_data61 <= dl_out_data61;
  // VCS coverage off
  end else if ((dl_out_mask[61]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data61 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[62]) == 1'b1) begin
    sc2mac_dat_b_data62 <= dl_out_data62;
  // VCS coverage off
  end else if ((dl_out_mask[62]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data62 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[63]) == 1'b1) begin
    sc2mac_dat_b_data63 <= dl_out_data63;
  // VCS coverage off
  end else if ((dl_out_mask[63]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data63 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[64]) == 1'b1) begin
    sc2mac_dat_b_data64 <= dl_out_data64;
  // VCS coverage off
  end else if ((dl_out_mask[64]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data64 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[65]) == 1'b1) begin
    sc2mac_dat_b_data65 <= dl_out_data65;
  // VCS coverage off
  end else if ((dl_out_mask[65]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data65 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[66]) == 1'b1) begin
    sc2mac_dat_b_data66 <= dl_out_data66;
  // VCS coverage off
  end else if ((dl_out_mask[66]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data66 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[67]) == 1'b1) begin
    sc2mac_dat_b_data67 <= dl_out_data67;
  // VCS coverage off
  end else if ((dl_out_mask[67]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data67 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[68]) == 1'b1) begin
    sc2mac_dat_b_data68 <= dl_out_data68;
  // VCS coverage off
  end else if ((dl_out_mask[68]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data68 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[69]) == 1'b1) begin
    sc2mac_dat_b_data69 <= dl_out_data69;
  // VCS coverage off
  end else if ((dl_out_mask[69]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data69 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[70]) == 1'b1) begin
    sc2mac_dat_b_data70 <= dl_out_data70;
  // VCS coverage off
  end else if ((dl_out_mask[70]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data70 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[71]) == 1'b1) begin
    sc2mac_dat_b_data71 <= dl_out_data71;
  // VCS coverage off
  end else if ((dl_out_mask[71]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data71 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[72]) == 1'b1) begin
    sc2mac_dat_b_data72 <= dl_out_data72;
  // VCS coverage off
  end else if ((dl_out_mask[72]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data72 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[73]) == 1'b1) begin
    sc2mac_dat_b_data73 <= dl_out_data73;
  // VCS coverage off
  end else if ((dl_out_mask[73]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data73 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[74]) == 1'b1) begin
    sc2mac_dat_b_data74 <= dl_out_data74;
  // VCS coverage off
  end else if ((dl_out_mask[74]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data74 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[75]) == 1'b1) begin
    sc2mac_dat_b_data75 <= dl_out_data75;
  // VCS coverage off
  end else if ((dl_out_mask[75]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data75 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[76]) == 1'b1) begin
    sc2mac_dat_b_data76 <= dl_out_data76;
  // VCS coverage off
  end else if ((dl_out_mask[76]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data76 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[77]) == 1'b1) begin
    sc2mac_dat_b_data77 <= dl_out_data77;
  // VCS coverage off
  end else if ((dl_out_mask[77]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data77 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[78]) == 1'b1) begin
    sc2mac_dat_b_data78 <= dl_out_data78;
  // VCS coverage off
  end else if ((dl_out_mask[78]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data78 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[79]) == 1'b1) begin
    sc2mac_dat_b_data79 <= dl_out_data79;
  // VCS coverage off
  end else if ((dl_out_mask[79]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data79 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[80]) == 1'b1) begin
    sc2mac_dat_b_data80 <= dl_out_data80;
  // VCS coverage off
  end else if ((dl_out_mask[80]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data80 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[81]) == 1'b1) begin
    sc2mac_dat_b_data81 <= dl_out_data81;
  // VCS coverage off
  end else if ((dl_out_mask[81]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data81 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[82]) == 1'b1) begin
    sc2mac_dat_b_data82 <= dl_out_data82;
  // VCS coverage off
  end else if ((dl_out_mask[82]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data82 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[83]) == 1'b1) begin
    sc2mac_dat_b_data83 <= dl_out_data83;
  // VCS coverage off
  end else if ((dl_out_mask[83]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data83 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[84]) == 1'b1) begin
    sc2mac_dat_b_data84 <= dl_out_data84;
  // VCS coverage off
  end else if ((dl_out_mask[84]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data84 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[85]) == 1'b1) begin
    sc2mac_dat_b_data85 <= dl_out_data85;
  // VCS coverage off
  end else if ((dl_out_mask[85]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data85 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[86]) == 1'b1) begin
    sc2mac_dat_b_data86 <= dl_out_data86;
  // VCS coverage off
  end else if ((dl_out_mask[86]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data86 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[87]) == 1'b1) begin
    sc2mac_dat_b_data87 <= dl_out_data87;
  // VCS coverage off
  end else if ((dl_out_mask[87]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data87 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[88]) == 1'b1) begin
    sc2mac_dat_b_data88 <= dl_out_data88;
  // VCS coverage off
  end else if ((dl_out_mask[88]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data88 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[89]) == 1'b1) begin
    sc2mac_dat_b_data89 <= dl_out_data89;
  // VCS coverage off
  end else if ((dl_out_mask[89]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data89 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[90]) == 1'b1) begin
    sc2mac_dat_b_data90 <= dl_out_data90;
  // VCS coverage off
  end else if ((dl_out_mask[90]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data90 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[91]) == 1'b1) begin
    sc2mac_dat_b_data91 <= dl_out_data91;
  // VCS coverage off
  end else if ((dl_out_mask[91]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data91 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[92]) == 1'b1) begin
    sc2mac_dat_b_data92 <= dl_out_data92;
  // VCS coverage off
  end else if ((dl_out_mask[92]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data92 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[93]) == 1'b1) begin
    sc2mac_dat_b_data93 <= dl_out_data93;
  // VCS coverage off
  end else if ((dl_out_mask[93]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data93 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[94]) == 1'b1) begin
    sc2mac_dat_b_data94 <= dl_out_data94;
  // VCS coverage off
  end else if ((dl_out_mask[94]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data94 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[95]) == 1'b1) begin
    sc2mac_dat_b_data95 <= dl_out_data95;
  // VCS coverage off
  end else if ((dl_out_mask[95]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data95 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[96]) == 1'b1) begin
    sc2mac_dat_b_data96 <= dl_out_data96;
  // VCS coverage off
  end else if ((dl_out_mask[96]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data96 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[97]) == 1'b1) begin
    sc2mac_dat_b_data97 <= dl_out_data97;
  // VCS coverage off
  end else if ((dl_out_mask[97]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data97 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[98]) == 1'b1) begin
    sc2mac_dat_b_data98 <= dl_out_data98;
  // VCS coverage off
  end else if ((dl_out_mask[98]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data98 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[99]) == 1'b1) begin
    sc2mac_dat_b_data99 <= dl_out_data99;
  // VCS coverage off
  end else if ((dl_out_mask[99]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data99 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[100]) == 1'b1) begin
    sc2mac_dat_b_data100 <= dl_out_data100;
  // VCS coverage off
  end else if ((dl_out_mask[100]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data100 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[101]) == 1'b1) begin
    sc2mac_dat_b_data101 <= dl_out_data101;
  // VCS coverage off
  end else if ((dl_out_mask[101]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data101 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[102]) == 1'b1) begin
    sc2mac_dat_b_data102 <= dl_out_data102;
  // VCS coverage off
  end else if ((dl_out_mask[102]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data102 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[103]) == 1'b1) begin
    sc2mac_dat_b_data103 <= dl_out_data103;
  // VCS coverage off
  end else if ((dl_out_mask[103]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data103 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[104]) == 1'b1) begin
    sc2mac_dat_b_data104 <= dl_out_data104;
  // VCS coverage off
  end else if ((dl_out_mask[104]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data104 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[105]) == 1'b1) begin
    sc2mac_dat_b_data105 <= dl_out_data105;
  // VCS coverage off
  end else if ((dl_out_mask[105]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data105 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[106]) == 1'b1) begin
    sc2mac_dat_b_data106 <= dl_out_data106;
  // VCS coverage off
  end else if ((dl_out_mask[106]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data106 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[107]) == 1'b1) begin
    sc2mac_dat_b_data107 <= dl_out_data107;
  // VCS coverage off
  end else if ((dl_out_mask[107]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data107 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[108]) == 1'b1) begin
    sc2mac_dat_b_data108 <= dl_out_data108;
  // VCS coverage off
  end else if ((dl_out_mask[108]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data108 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[109]) == 1'b1) begin
    sc2mac_dat_b_data109 <= dl_out_data109;
  // VCS coverage off
  end else if ((dl_out_mask[109]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data109 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[110]) == 1'b1) begin
    sc2mac_dat_b_data110 <= dl_out_data110;
  // VCS coverage off
  end else if ((dl_out_mask[110]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data110 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[111]) == 1'b1) begin
    sc2mac_dat_b_data111 <= dl_out_data111;
  // VCS coverage off
  end else if ((dl_out_mask[111]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data111 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[112]) == 1'b1) begin
    sc2mac_dat_b_data112 <= dl_out_data112;
  // VCS coverage off
  end else if ((dl_out_mask[112]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data112 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[113]) == 1'b1) begin
    sc2mac_dat_b_data113 <= dl_out_data113;
  // VCS coverage off
  end else if ((dl_out_mask[113]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data113 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[114]) == 1'b1) begin
    sc2mac_dat_b_data114 <= dl_out_data114;
  // VCS coverage off
  end else if ((dl_out_mask[114]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data114 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[115]) == 1'b1) begin
    sc2mac_dat_b_data115 <= dl_out_data115;
  // VCS coverage off
  end else if ((dl_out_mask[115]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data115 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[116]) == 1'b1) begin
    sc2mac_dat_b_data116 <= dl_out_data116;
  // VCS coverage off
  end else if ((dl_out_mask[116]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data116 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[117]) == 1'b1) begin
    sc2mac_dat_b_data117 <= dl_out_data117;
  // VCS coverage off
  end else if ((dl_out_mask[117]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data117 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[118]) == 1'b1) begin
    sc2mac_dat_b_data118 <= dl_out_data118;
  // VCS coverage off
  end else if ((dl_out_mask[118]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data118 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[119]) == 1'b1) begin
    sc2mac_dat_b_data119 <= dl_out_data119;
  // VCS coverage off
  end else if ((dl_out_mask[119]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data119 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[120]) == 1'b1) begin
    sc2mac_dat_b_data120 <= dl_out_data120;
  // VCS coverage off
  end else if ((dl_out_mask[120]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data120 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[121]) == 1'b1) begin
    sc2mac_dat_b_data121 <= dl_out_data121;
  // VCS coverage off
  end else if ((dl_out_mask[121]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data121 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[122]) == 1'b1) begin
    sc2mac_dat_b_data122 <= dl_out_data122;
  // VCS coverage off
  end else if ((dl_out_mask[122]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data122 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[123]) == 1'b1) begin
    sc2mac_dat_b_data123 <= dl_out_data123;
  // VCS coverage off
  end else if ((dl_out_mask[123]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data123 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[124]) == 1'b1) begin
    sc2mac_dat_b_data124 <= dl_out_data124;
  // VCS coverage off
  end else if ((dl_out_mask[124]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data124 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[125]) == 1'b1) begin
    sc2mac_dat_b_data125 <= dl_out_data125;
  // VCS coverage off
  end else if ((dl_out_mask[125]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data125 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[126]) == 1'b1) begin
    sc2mac_dat_b_data126 <= dl_out_data126;
  // VCS coverage off
  end else if ((dl_out_mask[126]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data126 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((dl_out_mask[127]) == 1'b1) begin
    sc2mac_dat_b_data127 <= dl_out_data127;
  // VCS coverage off
  end else if ((dl_out_mask[127]) == 1'b0) begin
  end else begin
    sc2mac_dat_b_data127 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end



`ifndef SYNTHESIS
assign dbg_csc_dat_0 = sc2mac_dat_a_mask[0] ? sc2mac_dat_a_data0 : 8'h0;
assign dbg_csc_dat_1 = sc2mac_dat_a_mask[1] ? sc2mac_dat_a_data1 : 8'h0;
assign dbg_csc_dat_2 = sc2mac_dat_a_mask[2] ? sc2mac_dat_a_data2 : 8'h0;
assign dbg_csc_dat_3 = sc2mac_dat_a_mask[3] ? sc2mac_dat_a_data3 : 8'h0;
assign dbg_csc_dat_4 = sc2mac_dat_a_mask[4] ? sc2mac_dat_a_data4 : 8'h0;
assign dbg_csc_dat_5 = sc2mac_dat_a_mask[5] ? sc2mac_dat_a_data5 : 8'h0;
assign dbg_csc_dat_6 = sc2mac_dat_a_mask[6] ? sc2mac_dat_a_data6 : 8'h0;
assign dbg_csc_dat_7 = sc2mac_dat_a_mask[7] ? sc2mac_dat_a_data7 : 8'h0;
assign dbg_csc_dat_8 = sc2mac_dat_a_mask[8] ? sc2mac_dat_a_data8 : 8'h0;
assign dbg_csc_dat_9 = sc2mac_dat_a_mask[9] ? sc2mac_dat_a_data9 : 8'h0;
assign dbg_csc_dat_10 = sc2mac_dat_a_mask[10] ? sc2mac_dat_a_data10 : 8'h0;
assign dbg_csc_dat_11 = sc2mac_dat_a_mask[11] ? sc2mac_dat_a_data11 : 8'h0;
assign dbg_csc_dat_12 = sc2mac_dat_a_mask[12] ? sc2mac_dat_a_data12 : 8'h0;
assign dbg_csc_dat_13 = sc2mac_dat_a_mask[13] ? sc2mac_dat_a_data13 : 8'h0;
assign dbg_csc_dat_14 = sc2mac_dat_a_mask[14] ? sc2mac_dat_a_data14 : 8'h0;
assign dbg_csc_dat_15 = sc2mac_dat_a_mask[15] ? sc2mac_dat_a_data15 : 8'h0;
assign dbg_csc_dat_16 = sc2mac_dat_a_mask[16] ? sc2mac_dat_a_data16 : 8'h0;
assign dbg_csc_dat_17 = sc2mac_dat_a_mask[17] ? sc2mac_dat_a_data17 : 8'h0;
assign dbg_csc_dat_18 = sc2mac_dat_a_mask[18] ? sc2mac_dat_a_data18 : 8'h0;
assign dbg_csc_dat_19 = sc2mac_dat_a_mask[19] ? sc2mac_dat_a_data19 : 8'h0;
assign dbg_csc_dat_20 = sc2mac_dat_a_mask[20] ? sc2mac_dat_a_data20 : 8'h0;
assign dbg_csc_dat_21 = sc2mac_dat_a_mask[21] ? sc2mac_dat_a_data21 : 8'h0;
assign dbg_csc_dat_22 = sc2mac_dat_a_mask[22] ? sc2mac_dat_a_data22 : 8'h0;
assign dbg_csc_dat_23 = sc2mac_dat_a_mask[23] ? sc2mac_dat_a_data23 : 8'h0;
assign dbg_csc_dat_24 = sc2mac_dat_a_mask[24] ? sc2mac_dat_a_data24 : 8'h0;
assign dbg_csc_dat_25 = sc2mac_dat_a_mask[25] ? sc2mac_dat_a_data25 : 8'h0;
assign dbg_csc_dat_26 = sc2mac_dat_a_mask[26] ? sc2mac_dat_a_data26 : 8'h0;
assign dbg_csc_dat_27 = sc2mac_dat_a_mask[27] ? sc2mac_dat_a_data27 : 8'h0;
assign dbg_csc_dat_28 = sc2mac_dat_a_mask[28] ? sc2mac_dat_a_data28 : 8'h0;
assign dbg_csc_dat_29 = sc2mac_dat_a_mask[29] ? sc2mac_dat_a_data29 : 8'h0;
assign dbg_csc_dat_30 = sc2mac_dat_a_mask[30] ? sc2mac_dat_a_data30 : 8'h0;
assign dbg_csc_dat_31 = sc2mac_dat_a_mask[31] ? sc2mac_dat_a_data31 : 8'h0;
assign dbg_csc_dat_32 = sc2mac_dat_a_mask[32] ? sc2mac_dat_a_data32 : 8'h0;
assign dbg_csc_dat_33 = sc2mac_dat_a_mask[33] ? sc2mac_dat_a_data33 : 8'h0;
assign dbg_csc_dat_34 = sc2mac_dat_a_mask[34] ? sc2mac_dat_a_data34 : 8'h0;
assign dbg_csc_dat_35 = sc2mac_dat_a_mask[35] ? sc2mac_dat_a_data35 : 8'h0;
assign dbg_csc_dat_36 = sc2mac_dat_a_mask[36] ? sc2mac_dat_a_data36 : 8'h0;
assign dbg_csc_dat_37 = sc2mac_dat_a_mask[37] ? sc2mac_dat_a_data37 : 8'h0;
assign dbg_csc_dat_38 = sc2mac_dat_a_mask[38] ? sc2mac_dat_a_data38 : 8'h0;
assign dbg_csc_dat_39 = sc2mac_dat_a_mask[39] ? sc2mac_dat_a_data39 : 8'h0;
assign dbg_csc_dat_40 = sc2mac_dat_a_mask[40] ? sc2mac_dat_a_data40 : 8'h0;
assign dbg_csc_dat_41 = sc2mac_dat_a_mask[41] ? sc2mac_dat_a_data41 : 8'h0;
assign dbg_csc_dat_42 = sc2mac_dat_a_mask[42] ? sc2mac_dat_a_data42 : 8'h0;
assign dbg_csc_dat_43 = sc2mac_dat_a_mask[43] ? sc2mac_dat_a_data43 : 8'h0;
assign dbg_csc_dat_44 = sc2mac_dat_a_mask[44] ? sc2mac_dat_a_data44 : 8'h0;
assign dbg_csc_dat_45 = sc2mac_dat_a_mask[45] ? sc2mac_dat_a_data45 : 8'h0;
assign dbg_csc_dat_46 = sc2mac_dat_a_mask[46] ? sc2mac_dat_a_data46 : 8'h0;
assign dbg_csc_dat_47 = sc2mac_dat_a_mask[47] ? sc2mac_dat_a_data47 : 8'h0;
assign dbg_csc_dat_48 = sc2mac_dat_a_mask[48] ? sc2mac_dat_a_data48 : 8'h0;
assign dbg_csc_dat_49 = sc2mac_dat_a_mask[49] ? sc2mac_dat_a_data49 : 8'h0;
assign dbg_csc_dat_50 = sc2mac_dat_a_mask[50] ? sc2mac_dat_a_data50 : 8'h0;
assign dbg_csc_dat_51 = sc2mac_dat_a_mask[51] ? sc2mac_dat_a_data51 : 8'h0;
assign dbg_csc_dat_52 = sc2mac_dat_a_mask[52] ? sc2mac_dat_a_data52 : 8'h0;
assign dbg_csc_dat_53 = sc2mac_dat_a_mask[53] ? sc2mac_dat_a_data53 : 8'h0;
assign dbg_csc_dat_54 = sc2mac_dat_a_mask[54] ? sc2mac_dat_a_data54 : 8'h0;
assign dbg_csc_dat_55 = sc2mac_dat_a_mask[55] ? sc2mac_dat_a_data55 : 8'h0;
assign dbg_csc_dat_56 = sc2mac_dat_a_mask[56] ? sc2mac_dat_a_data56 : 8'h0;
assign dbg_csc_dat_57 = sc2mac_dat_a_mask[57] ? sc2mac_dat_a_data57 : 8'h0;
assign dbg_csc_dat_58 = sc2mac_dat_a_mask[58] ? sc2mac_dat_a_data58 : 8'h0;
assign dbg_csc_dat_59 = sc2mac_dat_a_mask[59] ? sc2mac_dat_a_data59 : 8'h0;
assign dbg_csc_dat_60 = sc2mac_dat_a_mask[60] ? sc2mac_dat_a_data60 : 8'h0;
assign dbg_csc_dat_61 = sc2mac_dat_a_mask[61] ? sc2mac_dat_a_data61 : 8'h0;
assign dbg_csc_dat_62 = sc2mac_dat_a_mask[62] ? sc2mac_dat_a_data62 : 8'h0;
assign dbg_csc_dat_63 = sc2mac_dat_a_mask[63] ? sc2mac_dat_a_data63 : 8'h0;
assign dbg_csc_dat_64 = sc2mac_dat_a_mask[64] ? sc2mac_dat_a_data64 : 8'h0;
assign dbg_csc_dat_65 = sc2mac_dat_a_mask[65] ? sc2mac_dat_a_data65 : 8'h0;
assign dbg_csc_dat_66 = sc2mac_dat_a_mask[66] ? sc2mac_dat_a_data66 : 8'h0;
assign dbg_csc_dat_67 = sc2mac_dat_a_mask[67] ? sc2mac_dat_a_data67 : 8'h0;
assign dbg_csc_dat_68 = sc2mac_dat_a_mask[68] ? sc2mac_dat_a_data68 : 8'h0;
assign dbg_csc_dat_69 = sc2mac_dat_a_mask[69] ? sc2mac_dat_a_data69 : 8'h0;
assign dbg_csc_dat_70 = sc2mac_dat_a_mask[70] ? sc2mac_dat_a_data70 : 8'h0;
assign dbg_csc_dat_71 = sc2mac_dat_a_mask[71] ? sc2mac_dat_a_data71 : 8'h0;
assign dbg_csc_dat_72 = sc2mac_dat_a_mask[72] ? sc2mac_dat_a_data72 : 8'h0;
assign dbg_csc_dat_73 = sc2mac_dat_a_mask[73] ? sc2mac_dat_a_data73 : 8'h0;
assign dbg_csc_dat_74 = sc2mac_dat_a_mask[74] ? sc2mac_dat_a_data74 : 8'h0;
assign dbg_csc_dat_75 = sc2mac_dat_a_mask[75] ? sc2mac_dat_a_data75 : 8'h0;
assign dbg_csc_dat_76 = sc2mac_dat_a_mask[76] ? sc2mac_dat_a_data76 : 8'h0;
assign dbg_csc_dat_77 = sc2mac_dat_a_mask[77] ? sc2mac_dat_a_data77 : 8'h0;
assign dbg_csc_dat_78 = sc2mac_dat_a_mask[78] ? sc2mac_dat_a_data78 : 8'h0;
assign dbg_csc_dat_79 = sc2mac_dat_a_mask[79] ? sc2mac_dat_a_data79 : 8'h0;
assign dbg_csc_dat_80 = sc2mac_dat_a_mask[80] ? sc2mac_dat_a_data80 : 8'h0;
assign dbg_csc_dat_81 = sc2mac_dat_a_mask[81] ? sc2mac_dat_a_data81 : 8'h0;
assign dbg_csc_dat_82 = sc2mac_dat_a_mask[82] ? sc2mac_dat_a_data82 : 8'h0;
assign dbg_csc_dat_83 = sc2mac_dat_a_mask[83] ? sc2mac_dat_a_data83 : 8'h0;
assign dbg_csc_dat_84 = sc2mac_dat_a_mask[84] ? sc2mac_dat_a_data84 : 8'h0;
assign dbg_csc_dat_85 = sc2mac_dat_a_mask[85] ? sc2mac_dat_a_data85 : 8'h0;
assign dbg_csc_dat_86 = sc2mac_dat_a_mask[86] ? sc2mac_dat_a_data86 : 8'h0;
assign dbg_csc_dat_87 = sc2mac_dat_a_mask[87] ? sc2mac_dat_a_data87 : 8'h0;
assign dbg_csc_dat_88 = sc2mac_dat_a_mask[88] ? sc2mac_dat_a_data88 : 8'h0;
assign dbg_csc_dat_89 = sc2mac_dat_a_mask[89] ? sc2mac_dat_a_data89 : 8'h0;
assign dbg_csc_dat_90 = sc2mac_dat_a_mask[90] ? sc2mac_dat_a_data90 : 8'h0;
assign dbg_csc_dat_91 = sc2mac_dat_a_mask[91] ? sc2mac_dat_a_data91 : 8'h0;
assign dbg_csc_dat_92 = sc2mac_dat_a_mask[92] ? sc2mac_dat_a_data92 : 8'h0;
assign dbg_csc_dat_93 = sc2mac_dat_a_mask[93] ? sc2mac_dat_a_data93 : 8'h0;
assign dbg_csc_dat_94 = sc2mac_dat_a_mask[94] ? sc2mac_dat_a_data94 : 8'h0;
assign dbg_csc_dat_95 = sc2mac_dat_a_mask[95] ? sc2mac_dat_a_data95 : 8'h0;
assign dbg_csc_dat_96 = sc2mac_dat_a_mask[96] ? sc2mac_dat_a_data96 : 8'h0;
assign dbg_csc_dat_97 = sc2mac_dat_a_mask[97] ? sc2mac_dat_a_data97 : 8'h0;
assign dbg_csc_dat_98 = sc2mac_dat_a_mask[98] ? sc2mac_dat_a_data98 : 8'h0;
assign dbg_csc_dat_99 = sc2mac_dat_a_mask[99] ? sc2mac_dat_a_data99 : 8'h0;
assign dbg_csc_dat_100 = sc2mac_dat_a_mask[100] ? sc2mac_dat_a_data100 : 8'h0;
assign dbg_csc_dat_101 = sc2mac_dat_a_mask[101] ? sc2mac_dat_a_data101 : 8'h0;
assign dbg_csc_dat_102 = sc2mac_dat_a_mask[102] ? sc2mac_dat_a_data102 : 8'h0;
assign dbg_csc_dat_103 = sc2mac_dat_a_mask[103] ? sc2mac_dat_a_data103 : 8'h0;
assign dbg_csc_dat_104 = sc2mac_dat_a_mask[104] ? sc2mac_dat_a_data104 : 8'h0;
assign dbg_csc_dat_105 = sc2mac_dat_a_mask[105] ? sc2mac_dat_a_data105 : 8'h0;
assign dbg_csc_dat_106 = sc2mac_dat_a_mask[106] ? sc2mac_dat_a_data106 : 8'h0;
assign dbg_csc_dat_107 = sc2mac_dat_a_mask[107] ? sc2mac_dat_a_data107 : 8'h0;
assign dbg_csc_dat_108 = sc2mac_dat_a_mask[108] ? sc2mac_dat_a_data108 : 8'h0;
assign dbg_csc_dat_109 = sc2mac_dat_a_mask[109] ? sc2mac_dat_a_data109 : 8'h0;
assign dbg_csc_dat_110 = sc2mac_dat_a_mask[110] ? sc2mac_dat_a_data110 : 8'h0;
assign dbg_csc_dat_111 = sc2mac_dat_a_mask[111] ? sc2mac_dat_a_data111 : 8'h0;
assign dbg_csc_dat_112 = sc2mac_dat_a_mask[112] ? sc2mac_dat_a_data112 : 8'h0;
assign dbg_csc_dat_113 = sc2mac_dat_a_mask[113] ? sc2mac_dat_a_data113 : 8'h0;
assign dbg_csc_dat_114 = sc2mac_dat_a_mask[114] ? sc2mac_dat_a_data114 : 8'h0;
assign dbg_csc_dat_115 = sc2mac_dat_a_mask[115] ? sc2mac_dat_a_data115 : 8'h0;
assign dbg_csc_dat_116 = sc2mac_dat_a_mask[116] ? sc2mac_dat_a_data116 : 8'h0;
assign dbg_csc_dat_117 = sc2mac_dat_a_mask[117] ? sc2mac_dat_a_data117 : 8'h0;
assign dbg_csc_dat_118 = sc2mac_dat_a_mask[118] ? sc2mac_dat_a_data118 : 8'h0;
assign dbg_csc_dat_119 = sc2mac_dat_a_mask[119] ? sc2mac_dat_a_data119 : 8'h0;
assign dbg_csc_dat_120 = sc2mac_dat_a_mask[120] ? sc2mac_dat_a_data120 : 8'h0;
assign dbg_csc_dat_121 = sc2mac_dat_a_mask[121] ? sc2mac_dat_a_data121 : 8'h0;
assign dbg_csc_dat_122 = sc2mac_dat_a_mask[122] ? sc2mac_dat_a_data122 : 8'h0;
assign dbg_csc_dat_123 = sc2mac_dat_a_mask[123] ? sc2mac_dat_a_data123 : 8'h0;
assign dbg_csc_dat_124 = sc2mac_dat_a_mask[124] ? sc2mac_dat_a_data124 : 8'h0;
assign dbg_csc_dat_125 = sc2mac_dat_a_mask[125] ? sc2mac_dat_a_data125 : 8'h0;
assign dbg_csc_dat_126 = sc2mac_dat_a_mask[126] ? sc2mac_dat_a_data126 : 8'h0;
assign dbg_csc_dat_127 = sc2mac_dat_a_mask[127] ? sc2mac_dat_a_data127 : 8'h0;

assign dbg_csc_dat = {dbg_csc_dat_127, dbg_csc_dat_126, dbg_csc_dat_125, dbg_csc_dat_124, dbg_csc_dat_123, dbg_csc_dat_122, dbg_csc_dat_121, dbg_csc_dat_120, dbg_csc_dat_119, dbg_csc_dat_118, dbg_csc_dat_117, dbg_csc_dat_116, dbg_csc_dat_115, dbg_csc_dat_114, dbg_csc_dat_113, dbg_csc_dat_112, dbg_csc_dat_111, dbg_csc_dat_110, dbg_csc_dat_109, dbg_csc_dat_108, dbg_csc_dat_107, dbg_csc_dat_106, dbg_csc_dat_105, dbg_csc_dat_104, dbg_csc_dat_103, dbg_csc_dat_102, dbg_csc_dat_101, dbg_csc_dat_100, dbg_csc_dat_99, dbg_csc_dat_98, dbg_csc_dat_97, dbg_csc_dat_96, dbg_csc_dat_95, dbg_csc_dat_94, dbg_csc_dat_93, dbg_csc_dat_92, dbg_csc_dat_91, dbg_csc_dat_90, dbg_csc_dat_89, dbg_csc_dat_88, dbg_csc_dat_87, dbg_csc_dat_86, dbg_csc_dat_85, dbg_csc_dat_84, dbg_csc_dat_83, dbg_csc_dat_82, dbg_csc_dat_81, dbg_csc_dat_80, dbg_csc_dat_79, dbg_csc_dat_78, dbg_csc_dat_77, dbg_csc_dat_76, dbg_csc_dat_75, dbg_csc_dat_74, dbg_csc_dat_73, dbg_csc_dat_72, dbg_csc_dat_71, dbg_csc_dat_70, dbg_csc_dat_69, dbg_csc_dat_68, dbg_csc_dat_67, dbg_csc_dat_66, dbg_csc_dat_65, dbg_csc_dat_64, dbg_csc_dat_63, dbg_csc_dat_62, dbg_csc_dat_61, dbg_csc_dat_60, dbg_csc_dat_59, dbg_csc_dat_58, dbg_csc_dat_57, dbg_csc_dat_56, dbg_csc_dat_55, dbg_csc_dat_54, dbg_csc_dat_53, dbg_csc_dat_52, dbg_csc_dat_51, dbg_csc_dat_50, dbg_csc_dat_49, dbg_csc_dat_48, dbg_csc_dat_47, dbg_csc_dat_46, dbg_csc_dat_45, dbg_csc_dat_44, dbg_csc_dat_43, dbg_csc_dat_42, dbg_csc_dat_41, dbg_csc_dat_40, dbg_csc_dat_39, dbg_csc_dat_38, dbg_csc_dat_37, dbg_csc_dat_36, dbg_csc_dat_35, dbg_csc_dat_34, dbg_csc_dat_33, dbg_csc_dat_32, dbg_csc_dat_31, dbg_csc_dat_30, dbg_csc_dat_29, dbg_csc_dat_28, dbg_csc_dat_27, dbg_csc_dat_26, dbg_csc_dat_25, dbg_csc_dat_24, dbg_csc_dat_23, dbg_csc_dat_22, dbg_csc_dat_21, dbg_csc_dat_20, dbg_csc_dat_19, dbg_csc_dat_18, dbg_csc_dat_17, dbg_csc_dat_16, dbg_csc_dat_15, dbg_csc_dat_14, dbg_csc_dat_13, dbg_csc_dat_12, dbg_csc_dat_11, dbg_csc_dat_10, dbg_csc_dat_9, dbg_csc_dat_8, dbg_csc_dat_7, dbg_csc_dat_6, dbg_csc_dat_5, dbg_csc_dat_4, dbg_csc_dat_3, dbg_csc_dat_2, dbg_csc_dat_1, dbg_csc_dat_0};

`ifdef NVDLA_PRINT_DL
always @ (posedge nvdla_core_clk)
begin
    if(layer_st)
    begin
        $display("[NVDLA DL] layer start");
    end
end

always @ (posedge nvdla_core_clk)
begin
    if(sc2mac_dat_a_pvld)
    begin
        $display("[NVDLA DL] sc2mac_dat = %01024h", dbg_csc_dat);
    end
end
`endif
`endif

//////////////////////////////////////////////////////////////
///// ecodonors                                          /////
//////////////////////////////////////////////////////////////
//                           {pixel_req_ch_odd,pixel_req_ch_odd_ori}
//                           {pixel_force_fetch_d1,pixel_force_clr_d1}
//                           {dat_req_dummy_d1,dat_req_sub_w_st_d1}
//                           {dat_l0c0_dummy,dat_l1c0_dummy} 
//                           {dat_l2c0_dummy,dat_l3c0_dummy} 
//                           {dat_l0c1_dummy,dat_l1c1_dummy}
//                           {dat_l2c1_dummy,dat_l3c1_dummy}
//                           sub_h_cnt
//                           rsp_sft_cnt_l0[1:0]
//                           rsp_sft_cnt_l1[1:0]
//                           rsp_sft_cnt_l2[1:0]
//                           rsp_sft_cnt_l3[1:0];

//////////////////////////////////////////////////////////////
///// functional point                                   /////
//////////////////////////////////////////////////////////////

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

    property csc_dl__data_entry_st_wrap__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((cbuf_reset | dat_rls) & is_dat_entry_st_wrap & (dat_entry_st_w == dat_entry_st_inc_wrap));
    endproperty
    // Cover 0 : "((cbuf_reset | dat_rls) & is_dat_entry_st_wrap & (dat_entry_st_w == dat_entry_st_inc_wrap))"
    FUNCPOINT_csc_dl__data_entry_st_wrap__0_COV : cover property (csc_dl__data_entry_st_wrap__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property csc_dl__dat_req_addr_wrap__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((dat_req_sub_h_0_addr_en) && nvdla_core_rstn) |-> ((is_dat_req_addr_wrap & (dat_req_addr_w == dat_req_addr_wrap)));
    endproperty
    // Cover 1 : "(is_dat_req_addr_wrap & (dat_req_addr_w == dat_req_addr_wrap))"
    FUNCPOINT_csc_dl__dat_req_addr_wrap__1_COV : cover property (csc_dl__dat_req_addr_wrap__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property csc_dl__update_rlease_at_same_time__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (cdma2sc_dat_updt & dat_rls);
    endproperty
    // Cover 2 : "(cdma2sc_dat_updt & dat_rls)"
    FUNCPOINT_csc_dl__update_rlease_at_same_time__2_COV : cover property (csc_dl__update_rlease_at_same_time__2_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property csc_dl__exec_valid_pipe_invalid__3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (dat_exec_valid & ~dat_pipe_valid);
    endproperty
    // Cover 3 : "(dat_exec_valid & ~dat_pipe_valid)"
    FUNCPOINT_csc_dl__exec_valid_pipe_invalid__3_COV : cover property (csc_dl__exec_valid_pipe_invalid__3_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_CSC_dl


