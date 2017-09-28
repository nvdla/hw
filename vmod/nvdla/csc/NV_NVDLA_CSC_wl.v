// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CSC_wl.v

module NV_NVDLA_CSC_wl (
   nvdla_core_clk         //|< i
  ,nvdla_core_rstn        //|< i
  ,sg2wl_pvld             //|< i
  ,sg2wl_pd               //|< i
  ,sc_state               //|< i
  ,sg2wl_reuse_rls        //|< i
  ,sc2cdma_wt_pending_req //|< i
  ,cdma2sc_wt_updt        //|< i
  ,cdma2sc_wt_kernels     //|< i *
  ,cdma2sc_wt_entries     //|< i
  ,cdma2sc_wmb_entries    //|< i
  ,sc2cdma_wt_updt        //|> o
  ,sc2cdma_wt_kernels     //|> o
  ,sc2cdma_wt_entries     //|> o
  ,sc2cdma_wmb_entries    //|> o
  ,sc2buf_wt_rd_en        //|> o
  ,sc2buf_wt_rd_addr      //|> o
  ,sc2buf_wt_rd_valid     //|< i
  ,sc2buf_wt_rd_data      //|< i
  ,sc2buf_wmb_rd_en       //|> o
  ,sc2buf_wmb_rd_addr     //|> o
  ,sc2buf_wmb_rd_valid    //|< i
  ,sc2buf_wmb_rd_data     //|< i
  ,sc2mac_wt_a_pvld       //|> o
  ,sc2mac_wt_a_mask       //|> o
  ,sc2mac_wt_a_data0      //|> o
  ,sc2mac_wt_a_data1      //|> o
  ,sc2mac_wt_a_data2      //|> o
  ,sc2mac_wt_a_data3      //|> o
  ,sc2mac_wt_a_data4      //|> o
  ,sc2mac_wt_a_data5      //|> o
  ,sc2mac_wt_a_data6      //|> o
  ,sc2mac_wt_a_data7      //|> o
  ,sc2mac_wt_a_data8      //|> o
  ,sc2mac_wt_a_data9      //|> o
  ,sc2mac_wt_a_data10     //|> o
  ,sc2mac_wt_a_data11     //|> o
  ,sc2mac_wt_a_data12     //|> o
  ,sc2mac_wt_a_data13     //|> o
  ,sc2mac_wt_a_data14     //|> o
  ,sc2mac_wt_a_data15     //|> o
  ,sc2mac_wt_a_data16     //|> o
  ,sc2mac_wt_a_data17     //|> o
  ,sc2mac_wt_a_data18     //|> o
  ,sc2mac_wt_a_data19     //|> o
  ,sc2mac_wt_a_data20     //|> o
  ,sc2mac_wt_a_data21     //|> o
  ,sc2mac_wt_a_data22     //|> o
  ,sc2mac_wt_a_data23     //|> o
  ,sc2mac_wt_a_data24     //|> o
  ,sc2mac_wt_a_data25     //|> o
  ,sc2mac_wt_a_data26     //|> o
  ,sc2mac_wt_a_data27     //|> o
  ,sc2mac_wt_a_data28     //|> o
  ,sc2mac_wt_a_data29     //|> o
  ,sc2mac_wt_a_data30     //|> o
  ,sc2mac_wt_a_data31     //|> o
  ,sc2mac_wt_a_data32     //|> o
  ,sc2mac_wt_a_data33     //|> o
  ,sc2mac_wt_a_data34     //|> o
  ,sc2mac_wt_a_data35     //|> o
  ,sc2mac_wt_a_data36     //|> o
  ,sc2mac_wt_a_data37     //|> o
  ,sc2mac_wt_a_data38     //|> o
  ,sc2mac_wt_a_data39     //|> o
  ,sc2mac_wt_a_data40     //|> o
  ,sc2mac_wt_a_data41     //|> o
  ,sc2mac_wt_a_data42     //|> o
  ,sc2mac_wt_a_data43     //|> o
  ,sc2mac_wt_a_data44     //|> o
  ,sc2mac_wt_a_data45     //|> o
  ,sc2mac_wt_a_data46     //|> o
  ,sc2mac_wt_a_data47     //|> o
  ,sc2mac_wt_a_data48     //|> o
  ,sc2mac_wt_a_data49     //|> o
  ,sc2mac_wt_a_data50     //|> o
  ,sc2mac_wt_a_data51     //|> o
  ,sc2mac_wt_a_data52     //|> o
  ,sc2mac_wt_a_data53     //|> o
  ,sc2mac_wt_a_data54     //|> o
  ,sc2mac_wt_a_data55     //|> o
  ,sc2mac_wt_a_data56     //|> o
  ,sc2mac_wt_a_data57     //|> o
  ,sc2mac_wt_a_data58     //|> o
  ,sc2mac_wt_a_data59     //|> o
  ,sc2mac_wt_a_data60     //|> o
  ,sc2mac_wt_a_data61     //|> o
  ,sc2mac_wt_a_data62     //|> o
  ,sc2mac_wt_a_data63     //|> o
  ,sc2mac_wt_a_data64     //|> o
  ,sc2mac_wt_a_data65     //|> o
  ,sc2mac_wt_a_data66     //|> o
  ,sc2mac_wt_a_data67     //|> o
  ,sc2mac_wt_a_data68     //|> o
  ,sc2mac_wt_a_data69     //|> o
  ,sc2mac_wt_a_data70     //|> o
  ,sc2mac_wt_a_data71     //|> o
  ,sc2mac_wt_a_data72     //|> o
  ,sc2mac_wt_a_data73     //|> o
  ,sc2mac_wt_a_data74     //|> o
  ,sc2mac_wt_a_data75     //|> o
  ,sc2mac_wt_a_data76     //|> o
  ,sc2mac_wt_a_data77     //|> o
  ,sc2mac_wt_a_data78     //|> o
  ,sc2mac_wt_a_data79     //|> o
  ,sc2mac_wt_a_data80     //|> o
  ,sc2mac_wt_a_data81     //|> o
  ,sc2mac_wt_a_data82     //|> o
  ,sc2mac_wt_a_data83     //|> o
  ,sc2mac_wt_a_data84     //|> o
  ,sc2mac_wt_a_data85     //|> o
  ,sc2mac_wt_a_data86     //|> o
  ,sc2mac_wt_a_data87     //|> o
  ,sc2mac_wt_a_data88     //|> o
  ,sc2mac_wt_a_data89     //|> o
  ,sc2mac_wt_a_data90     //|> o
  ,sc2mac_wt_a_data91     //|> o
  ,sc2mac_wt_a_data92     //|> o
  ,sc2mac_wt_a_data93     //|> o
  ,sc2mac_wt_a_data94     //|> o
  ,sc2mac_wt_a_data95     //|> o
  ,sc2mac_wt_a_data96     //|> o
  ,sc2mac_wt_a_data97     //|> o
  ,sc2mac_wt_a_data98     //|> o
  ,sc2mac_wt_a_data99     //|> o
  ,sc2mac_wt_a_data100    //|> o
  ,sc2mac_wt_a_data101    //|> o
  ,sc2mac_wt_a_data102    //|> o
  ,sc2mac_wt_a_data103    //|> o
  ,sc2mac_wt_a_data104    //|> o
  ,sc2mac_wt_a_data105    //|> o
  ,sc2mac_wt_a_data106    //|> o
  ,sc2mac_wt_a_data107    //|> o
  ,sc2mac_wt_a_data108    //|> o
  ,sc2mac_wt_a_data109    //|> o
  ,sc2mac_wt_a_data110    //|> o
  ,sc2mac_wt_a_data111    //|> o
  ,sc2mac_wt_a_data112    //|> o
  ,sc2mac_wt_a_data113    //|> o
  ,sc2mac_wt_a_data114    //|> o
  ,sc2mac_wt_a_data115    //|> o
  ,sc2mac_wt_a_data116    //|> o
  ,sc2mac_wt_a_data117    //|> o
  ,sc2mac_wt_a_data118    //|> o
  ,sc2mac_wt_a_data119    //|> o
  ,sc2mac_wt_a_data120    //|> o
  ,sc2mac_wt_a_data121    //|> o
  ,sc2mac_wt_a_data122    //|> o
  ,sc2mac_wt_a_data123    //|> o
  ,sc2mac_wt_a_data124    //|> o
  ,sc2mac_wt_a_data125    //|> o
  ,sc2mac_wt_a_data126    //|> o
  ,sc2mac_wt_a_data127    //|> o
  ,sc2mac_wt_a_sel        //|> o
  ,sc2mac_wt_b_pvld       //|> o
  ,sc2mac_wt_b_mask       //|> o
  ,sc2mac_wt_b_data0      //|> o
  ,sc2mac_wt_b_data1      //|> o
  ,sc2mac_wt_b_data2      //|> o
  ,sc2mac_wt_b_data3      //|> o
  ,sc2mac_wt_b_data4      //|> o
  ,sc2mac_wt_b_data5      //|> o
  ,sc2mac_wt_b_data6      //|> o
  ,sc2mac_wt_b_data7      //|> o
  ,sc2mac_wt_b_data8      //|> o
  ,sc2mac_wt_b_data9      //|> o
  ,sc2mac_wt_b_data10     //|> o
  ,sc2mac_wt_b_data11     //|> o
  ,sc2mac_wt_b_data12     //|> o
  ,sc2mac_wt_b_data13     //|> o
  ,sc2mac_wt_b_data14     //|> o
  ,sc2mac_wt_b_data15     //|> o
  ,sc2mac_wt_b_data16     //|> o
  ,sc2mac_wt_b_data17     //|> o
  ,sc2mac_wt_b_data18     //|> o
  ,sc2mac_wt_b_data19     //|> o
  ,sc2mac_wt_b_data20     //|> o
  ,sc2mac_wt_b_data21     //|> o
  ,sc2mac_wt_b_data22     //|> o
  ,sc2mac_wt_b_data23     //|> o
  ,sc2mac_wt_b_data24     //|> o
  ,sc2mac_wt_b_data25     //|> o
  ,sc2mac_wt_b_data26     //|> o
  ,sc2mac_wt_b_data27     //|> o
  ,sc2mac_wt_b_data28     //|> o
  ,sc2mac_wt_b_data29     //|> o
  ,sc2mac_wt_b_data30     //|> o
  ,sc2mac_wt_b_data31     //|> o
  ,sc2mac_wt_b_data32     //|> o
  ,sc2mac_wt_b_data33     //|> o
  ,sc2mac_wt_b_data34     //|> o
  ,sc2mac_wt_b_data35     //|> o
  ,sc2mac_wt_b_data36     //|> o
  ,sc2mac_wt_b_data37     //|> o
  ,sc2mac_wt_b_data38     //|> o
  ,sc2mac_wt_b_data39     //|> o
  ,sc2mac_wt_b_data40     //|> o
  ,sc2mac_wt_b_data41     //|> o
  ,sc2mac_wt_b_data42     //|> o
  ,sc2mac_wt_b_data43     //|> o
  ,sc2mac_wt_b_data44     //|> o
  ,sc2mac_wt_b_data45     //|> o
  ,sc2mac_wt_b_data46     //|> o
  ,sc2mac_wt_b_data47     //|> o
  ,sc2mac_wt_b_data48     //|> o
  ,sc2mac_wt_b_data49     //|> o
  ,sc2mac_wt_b_data50     //|> o
  ,sc2mac_wt_b_data51     //|> o
  ,sc2mac_wt_b_data52     //|> o
  ,sc2mac_wt_b_data53     //|> o
  ,sc2mac_wt_b_data54     //|> o
  ,sc2mac_wt_b_data55     //|> o
  ,sc2mac_wt_b_data56     //|> o
  ,sc2mac_wt_b_data57     //|> o
  ,sc2mac_wt_b_data58     //|> o
  ,sc2mac_wt_b_data59     //|> o
  ,sc2mac_wt_b_data60     //|> o
  ,sc2mac_wt_b_data61     //|> o
  ,sc2mac_wt_b_data62     //|> o
  ,sc2mac_wt_b_data63     //|> o
  ,sc2mac_wt_b_data64     //|> o
  ,sc2mac_wt_b_data65     //|> o
  ,sc2mac_wt_b_data66     //|> o
  ,sc2mac_wt_b_data67     //|> o
  ,sc2mac_wt_b_data68     //|> o
  ,sc2mac_wt_b_data69     //|> o
  ,sc2mac_wt_b_data70     //|> o
  ,sc2mac_wt_b_data71     //|> o
  ,sc2mac_wt_b_data72     //|> o
  ,sc2mac_wt_b_data73     //|> o
  ,sc2mac_wt_b_data74     //|> o
  ,sc2mac_wt_b_data75     //|> o
  ,sc2mac_wt_b_data76     //|> o
  ,sc2mac_wt_b_data77     //|> o
  ,sc2mac_wt_b_data78     //|> o
  ,sc2mac_wt_b_data79     //|> o
  ,sc2mac_wt_b_data80     //|> o
  ,sc2mac_wt_b_data81     //|> o
  ,sc2mac_wt_b_data82     //|> o
  ,sc2mac_wt_b_data83     //|> o
  ,sc2mac_wt_b_data84     //|> o
  ,sc2mac_wt_b_data85     //|> o
  ,sc2mac_wt_b_data86     //|> o
  ,sc2mac_wt_b_data87     //|> o
  ,sc2mac_wt_b_data88     //|> o
  ,sc2mac_wt_b_data89     //|> o
  ,sc2mac_wt_b_data90     //|> o
  ,sc2mac_wt_b_data91     //|> o
  ,sc2mac_wt_b_data92     //|> o
  ,sc2mac_wt_b_data93     //|> o
  ,sc2mac_wt_b_data94     //|> o
  ,sc2mac_wt_b_data95     //|> o
  ,sc2mac_wt_b_data96     //|> o
  ,sc2mac_wt_b_data97     //|> o
  ,sc2mac_wt_b_data98     //|> o
  ,sc2mac_wt_b_data99     //|> o
  ,sc2mac_wt_b_data100    //|> o
  ,sc2mac_wt_b_data101    //|> o
  ,sc2mac_wt_b_data102    //|> o
  ,sc2mac_wt_b_data103    //|> o
  ,sc2mac_wt_b_data104    //|> o
  ,sc2mac_wt_b_data105    //|> o
  ,sc2mac_wt_b_data106    //|> o
  ,sc2mac_wt_b_data107    //|> o
  ,sc2mac_wt_b_data108    //|> o
  ,sc2mac_wt_b_data109    //|> o
  ,sc2mac_wt_b_data110    //|> o
  ,sc2mac_wt_b_data111    //|> o
  ,sc2mac_wt_b_data112    //|> o
  ,sc2mac_wt_b_data113    //|> o
  ,sc2mac_wt_b_data114    //|> o
  ,sc2mac_wt_b_data115    //|> o
  ,sc2mac_wt_b_data116    //|> o
  ,sc2mac_wt_b_data117    //|> o
  ,sc2mac_wt_b_data118    //|> o
  ,sc2mac_wt_b_data119    //|> o
  ,sc2mac_wt_b_data120    //|> o
  ,sc2mac_wt_b_data121    //|> o
  ,sc2mac_wt_b_data122    //|> o
  ,sc2mac_wt_b_data123    //|> o
  ,sc2mac_wt_b_data124    //|> o
  ,sc2mac_wt_b_data125    //|> o
  ,sc2mac_wt_b_data126    //|> o
  ,sc2mac_wt_b_data127    //|> o
  ,sc2mac_wt_b_sel        //|> o
  ,nvdla_core_ng_clk      //|< i
  ,reg2dp_op_en           //|< i
  ,reg2dp_in_precision    //|< i *
  ,reg2dp_proc_precision  //|< i
  ,reg2dp_y_extension     //|< i
  ,reg2dp_weight_reuse    //|< i *
  ,reg2dp_skip_weight_rls //|< i
  ,reg2dp_weight_format   //|< i
  ,reg2dp_weight_bytes    //|< i
  ,reg2dp_wmb_bytes       //|< i
  ,reg2dp_data_bank       //|< i
  ,reg2dp_weight_bank     //|< i
  );


//
// NV_NVDLA_CSC_wl_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input        sg2wl_pvld;  /* data valid */
input [17:0] sg2wl_pd;

input [1:0] sc_state;

input  sg2wl_reuse_rls;

input  sc2cdma_wt_pending_req;

input        cdma2sc_wt_updt;      /* data valid */
input [13:0] cdma2sc_wt_kernels;
input [11:0] cdma2sc_wt_entries;
input  [8:0] cdma2sc_wmb_entries;

output        sc2cdma_wt_updt;      /* data valid */
output [13:0] sc2cdma_wt_kernels;
output [11:0] sc2cdma_wt_entries;
output  [8:0] sc2cdma_wmb_entries;

output        sc2buf_wt_rd_en;    /* data valid */
output [11:0] sc2buf_wt_rd_addr;

input          sc2buf_wt_rd_valid;  /* data valid */
input [1023:0] sc2buf_wt_rd_data;

output       sc2buf_wmb_rd_en;    /* data valid */
output [7:0] sc2buf_wmb_rd_addr;

input          sc2buf_wmb_rd_valid;  /* data valid */
input [1023:0] sc2buf_wmb_rd_data;

output         sc2mac_wt_a_pvld;     /* data valid */
output [127:0] sc2mac_wt_a_mask;
output   [7:0] sc2mac_wt_a_data0;
output   [7:0] sc2mac_wt_a_data1;
output   [7:0] sc2mac_wt_a_data2;
output   [7:0] sc2mac_wt_a_data3;
output   [7:0] sc2mac_wt_a_data4;
output   [7:0] sc2mac_wt_a_data5;
output   [7:0] sc2mac_wt_a_data6;
output   [7:0] sc2mac_wt_a_data7;
output   [7:0] sc2mac_wt_a_data8;
output   [7:0] sc2mac_wt_a_data9;
output   [7:0] sc2mac_wt_a_data10;
output   [7:0] sc2mac_wt_a_data11;
output   [7:0] sc2mac_wt_a_data12;
output   [7:0] sc2mac_wt_a_data13;
output   [7:0] sc2mac_wt_a_data14;
output   [7:0] sc2mac_wt_a_data15;
output   [7:0] sc2mac_wt_a_data16;
output   [7:0] sc2mac_wt_a_data17;
output   [7:0] sc2mac_wt_a_data18;
output   [7:0] sc2mac_wt_a_data19;
output   [7:0] sc2mac_wt_a_data20;
output   [7:0] sc2mac_wt_a_data21;
output   [7:0] sc2mac_wt_a_data22;
output   [7:0] sc2mac_wt_a_data23;
output   [7:0] sc2mac_wt_a_data24;
output   [7:0] sc2mac_wt_a_data25;
output   [7:0] sc2mac_wt_a_data26;
output   [7:0] sc2mac_wt_a_data27;
output   [7:0] sc2mac_wt_a_data28;
output   [7:0] sc2mac_wt_a_data29;
output   [7:0] sc2mac_wt_a_data30;
output   [7:0] sc2mac_wt_a_data31;
output   [7:0] sc2mac_wt_a_data32;
output   [7:0] sc2mac_wt_a_data33;
output   [7:0] sc2mac_wt_a_data34;
output   [7:0] sc2mac_wt_a_data35;
output   [7:0] sc2mac_wt_a_data36;
output   [7:0] sc2mac_wt_a_data37;
output   [7:0] sc2mac_wt_a_data38;
output   [7:0] sc2mac_wt_a_data39;
output   [7:0] sc2mac_wt_a_data40;
output   [7:0] sc2mac_wt_a_data41;
output   [7:0] sc2mac_wt_a_data42;
output   [7:0] sc2mac_wt_a_data43;
output   [7:0] sc2mac_wt_a_data44;
output   [7:0] sc2mac_wt_a_data45;
output   [7:0] sc2mac_wt_a_data46;
output   [7:0] sc2mac_wt_a_data47;
output   [7:0] sc2mac_wt_a_data48;
output   [7:0] sc2mac_wt_a_data49;
output   [7:0] sc2mac_wt_a_data50;
output   [7:0] sc2mac_wt_a_data51;
output   [7:0] sc2mac_wt_a_data52;
output   [7:0] sc2mac_wt_a_data53;
output   [7:0] sc2mac_wt_a_data54;
output   [7:0] sc2mac_wt_a_data55;
output   [7:0] sc2mac_wt_a_data56;
output   [7:0] sc2mac_wt_a_data57;
output   [7:0] sc2mac_wt_a_data58;
output   [7:0] sc2mac_wt_a_data59;
output   [7:0] sc2mac_wt_a_data60;
output   [7:0] sc2mac_wt_a_data61;
output   [7:0] sc2mac_wt_a_data62;
output   [7:0] sc2mac_wt_a_data63;
output   [7:0] sc2mac_wt_a_data64;
output   [7:0] sc2mac_wt_a_data65;
output   [7:0] sc2mac_wt_a_data66;
output   [7:0] sc2mac_wt_a_data67;
output   [7:0] sc2mac_wt_a_data68;
output   [7:0] sc2mac_wt_a_data69;
output   [7:0] sc2mac_wt_a_data70;
output   [7:0] sc2mac_wt_a_data71;
output   [7:0] sc2mac_wt_a_data72;
output   [7:0] sc2mac_wt_a_data73;
output   [7:0] sc2mac_wt_a_data74;
output   [7:0] sc2mac_wt_a_data75;
output   [7:0] sc2mac_wt_a_data76;
output   [7:0] sc2mac_wt_a_data77;
output   [7:0] sc2mac_wt_a_data78;
output   [7:0] sc2mac_wt_a_data79;
output   [7:0] sc2mac_wt_a_data80;
output   [7:0] sc2mac_wt_a_data81;
output   [7:0] sc2mac_wt_a_data82;
output   [7:0] sc2mac_wt_a_data83;
output   [7:0] sc2mac_wt_a_data84;
output   [7:0] sc2mac_wt_a_data85;
output   [7:0] sc2mac_wt_a_data86;
output   [7:0] sc2mac_wt_a_data87;
output   [7:0] sc2mac_wt_a_data88;
output   [7:0] sc2mac_wt_a_data89;
output   [7:0] sc2mac_wt_a_data90;
output   [7:0] sc2mac_wt_a_data91;
output   [7:0] sc2mac_wt_a_data92;
output   [7:0] sc2mac_wt_a_data93;
output   [7:0] sc2mac_wt_a_data94;
output   [7:0] sc2mac_wt_a_data95;
output   [7:0] sc2mac_wt_a_data96;
output   [7:0] sc2mac_wt_a_data97;
output   [7:0] sc2mac_wt_a_data98;
output   [7:0] sc2mac_wt_a_data99;
output   [7:0] sc2mac_wt_a_data100;
output   [7:0] sc2mac_wt_a_data101;
output   [7:0] sc2mac_wt_a_data102;
output   [7:0] sc2mac_wt_a_data103;
output   [7:0] sc2mac_wt_a_data104;
output   [7:0] sc2mac_wt_a_data105;
output   [7:0] sc2mac_wt_a_data106;
output   [7:0] sc2mac_wt_a_data107;
output   [7:0] sc2mac_wt_a_data108;
output   [7:0] sc2mac_wt_a_data109;
output   [7:0] sc2mac_wt_a_data110;
output   [7:0] sc2mac_wt_a_data111;
output   [7:0] sc2mac_wt_a_data112;
output   [7:0] sc2mac_wt_a_data113;
output   [7:0] sc2mac_wt_a_data114;
output   [7:0] sc2mac_wt_a_data115;
output   [7:0] sc2mac_wt_a_data116;
output   [7:0] sc2mac_wt_a_data117;
output   [7:0] sc2mac_wt_a_data118;
output   [7:0] sc2mac_wt_a_data119;
output   [7:0] sc2mac_wt_a_data120;
output   [7:0] sc2mac_wt_a_data121;
output   [7:0] sc2mac_wt_a_data122;
output   [7:0] sc2mac_wt_a_data123;
output   [7:0] sc2mac_wt_a_data124;
output   [7:0] sc2mac_wt_a_data125;
output   [7:0] sc2mac_wt_a_data126;
output   [7:0] sc2mac_wt_a_data127;
output   [7:0] sc2mac_wt_a_sel;

output         sc2mac_wt_b_pvld;     /* data valid */
output [127:0] sc2mac_wt_b_mask;
output   [7:0] sc2mac_wt_b_data0;
output   [7:0] sc2mac_wt_b_data1;
output   [7:0] sc2mac_wt_b_data2;
output   [7:0] sc2mac_wt_b_data3;
output   [7:0] sc2mac_wt_b_data4;
output   [7:0] sc2mac_wt_b_data5;
output   [7:0] sc2mac_wt_b_data6;
output   [7:0] sc2mac_wt_b_data7;
output   [7:0] sc2mac_wt_b_data8;
output   [7:0] sc2mac_wt_b_data9;
output   [7:0] sc2mac_wt_b_data10;
output   [7:0] sc2mac_wt_b_data11;
output   [7:0] sc2mac_wt_b_data12;
output   [7:0] sc2mac_wt_b_data13;
output   [7:0] sc2mac_wt_b_data14;
output   [7:0] sc2mac_wt_b_data15;
output   [7:0] sc2mac_wt_b_data16;
output   [7:0] sc2mac_wt_b_data17;
output   [7:0] sc2mac_wt_b_data18;
output   [7:0] sc2mac_wt_b_data19;
output   [7:0] sc2mac_wt_b_data20;
output   [7:0] sc2mac_wt_b_data21;
output   [7:0] sc2mac_wt_b_data22;
output   [7:0] sc2mac_wt_b_data23;
output   [7:0] sc2mac_wt_b_data24;
output   [7:0] sc2mac_wt_b_data25;
output   [7:0] sc2mac_wt_b_data26;
output   [7:0] sc2mac_wt_b_data27;
output   [7:0] sc2mac_wt_b_data28;
output   [7:0] sc2mac_wt_b_data29;
output   [7:0] sc2mac_wt_b_data30;
output   [7:0] sc2mac_wt_b_data31;
output   [7:0] sc2mac_wt_b_data32;
output   [7:0] sc2mac_wt_b_data33;
output   [7:0] sc2mac_wt_b_data34;
output   [7:0] sc2mac_wt_b_data35;
output   [7:0] sc2mac_wt_b_data36;
output   [7:0] sc2mac_wt_b_data37;
output   [7:0] sc2mac_wt_b_data38;
output   [7:0] sc2mac_wt_b_data39;
output   [7:0] sc2mac_wt_b_data40;
output   [7:0] sc2mac_wt_b_data41;
output   [7:0] sc2mac_wt_b_data42;
output   [7:0] sc2mac_wt_b_data43;
output   [7:0] sc2mac_wt_b_data44;
output   [7:0] sc2mac_wt_b_data45;
output   [7:0] sc2mac_wt_b_data46;
output   [7:0] sc2mac_wt_b_data47;
output   [7:0] sc2mac_wt_b_data48;
output   [7:0] sc2mac_wt_b_data49;
output   [7:0] sc2mac_wt_b_data50;
output   [7:0] sc2mac_wt_b_data51;
output   [7:0] sc2mac_wt_b_data52;
output   [7:0] sc2mac_wt_b_data53;
output   [7:0] sc2mac_wt_b_data54;
output   [7:0] sc2mac_wt_b_data55;
output   [7:0] sc2mac_wt_b_data56;
output   [7:0] sc2mac_wt_b_data57;
output   [7:0] sc2mac_wt_b_data58;
output   [7:0] sc2mac_wt_b_data59;
output   [7:0] sc2mac_wt_b_data60;
output   [7:0] sc2mac_wt_b_data61;
output   [7:0] sc2mac_wt_b_data62;
output   [7:0] sc2mac_wt_b_data63;
output   [7:0] sc2mac_wt_b_data64;
output   [7:0] sc2mac_wt_b_data65;
output   [7:0] sc2mac_wt_b_data66;
output   [7:0] sc2mac_wt_b_data67;
output   [7:0] sc2mac_wt_b_data68;
output   [7:0] sc2mac_wt_b_data69;
output   [7:0] sc2mac_wt_b_data70;
output   [7:0] sc2mac_wt_b_data71;
output   [7:0] sc2mac_wt_b_data72;
output   [7:0] sc2mac_wt_b_data73;
output   [7:0] sc2mac_wt_b_data74;
output   [7:0] sc2mac_wt_b_data75;
output   [7:0] sc2mac_wt_b_data76;
output   [7:0] sc2mac_wt_b_data77;
output   [7:0] sc2mac_wt_b_data78;
output   [7:0] sc2mac_wt_b_data79;
output   [7:0] sc2mac_wt_b_data80;
output   [7:0] sc2mac_wt_b_data81;
output   [7:0] sc2mac_wt_b_data82;
output   [7:0] sc2mac_wt_b_data83;
output   [7:0] sc2mac_wt_b_data84;
output   [7:0] sc2mac_wt_b_data85;
output   [7:0] sc2mac_wt_b_data86;
output   [7:0] sc2mac_wt_b_data87;
output   [7:0] sc2mac_wt_b_data88;
output   [7:0] sc2mac_wt_b_data89;
output   [7:0] sc2mac_wt_b_data90;
output   [7:0] sc2mac_wt_b_data91;
output   [7:0] sc2mac_wt_b_data92;
output   [7:0] sc2mac_wt_b_data93;
output   [7:0] sc2mac_wt_b_data94;
output   [7:0] sc2mac_wt_b_data95;
output   [7:0] sc2mac_wt_b_data96;
output   [7:0] sc2mac_wt_b_data97;
output   [7:0] sc2mac_wt_b_data98;
output   [7:0] sc2mac_wt_b_data99;
output   [7:0] sc2mac_wt_b_data100;
output   [7:0] sc2mac_wt_b_data101;
output   [7:0] sc2mac_wt_b_data102;
output   [7:0] sc2mac_wt_b_data103;
output   [7:0] sc2mac_wt_b_data104;
output   [7:0] sc2mac_wt_b_data105;
output   [7:0] sc2mac_wt_b_data106;
output   [7:0] sc2mac_wt_b_data107;
output   [7:0] sc2mac_wt_b_data108;
output   [7:0] sc2mac_wt_b_data109;
output   [7:0] sc2mac_wt_b_data110;
output   [7:0] sc2mac_wt_b_data111;
output   [7:0] sc2mac_wt_b_data112;
output   [7:0] sc2mac_wt_b_data113;
output   [7:0] sc2mac_wt_b_data114;
output   [7:0] sc2mac_wt_b_data115;
output   [7:0] sc2mac_wt_b_data116;
output   [7:0] sc2mac_wt_b_data117;
output   [7:0] sc2mac_wt_b_data118;
output   [7:0] sc2mac_wt_b_data119;
output   [7:0] sc2mac_wt_b_data120;
output   [7:0] sc2mac_wt_b_data121;
output   [7:0] sc2mac_wt_b_data122;
output   [7:0] sc2mac_wt_b_data123;
output   [7:0] sc2mac_wt_b_data124;
output   [7:0] sc2mac_wt_b_data125;
output   [7:0] sc2mac_wt_b_data126;
output   [7:0] sc2mac_wt_b_data127;
output   [7:0] sc2mac_wt_b_sel;

input nvdla_core_ng_clk;

input [0:0]                  reg2dp_op_en;
input [1:0]            reg2dp_in_precision;
input [1:0]          reg2dp_proc_precision;
input [1:0]     reg2dp_y_extension;
input [0:0]            reg2dp_weight_reuse;
input [0:0]         reg2dp_skip_weight_rls;
input [0:0]      reg2dp_weight_format;
input [24:0]        reg2dp_weight_bytes;
input [20:0]              reg2dp_wmb_bytes;
input [3:0]                   reg2dp_data_bank;
input [3:0]                 reg2dp_weight_bank;

wire   [1023:0] dbg_csc_wt_a;
wire      [7:0] dbg_csc_wt_a_0;
wire      [7:0] dbg_csc_wt_a_1;
wire      [7:0] dbg_csc_wt_a_10;
wire      [7:0] dbg_csc_wt_a_100;
wire      [7:0] dbg_csc_wt_a_101;
wire      [7:0] dbg_csc_wt_a_102;
wire      [7:0] dbg_csc_wt_a_103;
wire      [7:0] dbg_csc_wt_a_104;
wire      [7:0] dbg_csc_wt_a_105;
wire      [7:0] dbg_csc_wt_a_106;
wire      [7:0] dbg_csc_wt_a_107;
wire      [7:0] dbg_csc_wt_a_108;
wire      [7:0] dbg_csc_wt_a_109;
wire      [7:0] dbg_csc_wt_a_11;
wire      [7:0] dbg_csc_wt_a_110;
wire      [7:0] dbg_csc_wt_a_111;
wire      [7:0] dbg_csc_wt_a_112;
wire      [7:0] dbg_csc_wt_a_113;
wire      [7:0] dbg_csc_wt_a_114;
wire      [7:0] dbg_csc_wt_a_115;
wire      [7:0] dbg_csc_wt_a_116;
wire      [7:0] dbg_csc_wt_a_117;
wire      [7:0] dbg_csc_wt_a_118;
wire      [7:0] dbg_csc_wt_a_119;
wire      [7:0] dbg_csc_wt_a_12;
wire      [7:0] dbg_csc_wt_a_120;
wire      [7:0] dbg_csc_wt_a_121;
wire      [7:0] dbg_csc_wt_a_122;
wire      [7:0] dbg_csc_wt_a_123;
wire      [7:0] dbg_csc_wt_a_124;
wire      [7:0] dbg_csc_wt_a_125;
wire      [7:0] dbg_csc_wt_a_126;
wire      [7:0] dbg_csc_wt_a_127;
wire      [7:0] dbg_csc_wt_a_13;
wire      [7:0] dbg_csc_wt_a_14;
wire      [7:0] dbg_csc_wt_a_15;
wire      [7:0] dbg_csc_wt_a_16;
wire      [7:0] dbg_csc_wt_a_17;
wire      [7:0] dbg_csc_wt_a_18;
wire      [7:0] dbg_csc_wt_a_19;
wire      [7:0] dbg_csc_wt_a_2;
wire      [7:0] dbg_csc_wt_a_20;
wire      [7:0] dbg_csc_wt_a_21;
wire      [7:0] dbg_csc_wt_a_22;
wire      [7:0] dbg_csc_wt_a_23;
wire      [7:0] dbg_csc_wt_a_24;
wire      [7:0] dbg_csc_wt_a_25;
wire      [7:0] dbg_csc_wt_a_26;
wire      [7:0] dbg_csc_wt_a_27;
wire      [7:0] dbg_csc_wt_a_28;
wire      [7:0] dbg_csc_wt_a_29;
wire      [7:0] dbg_csc_wt_a_3;
wire      [7:0] dbg_csc_wt_a_30;
wire      [7:0] dbg_csc_wt_a_31;
wire      [7:0] dbg_csc_wt_a_32;
wire      [7:0] dbg_csc_wt_a_33;
wire      [7:0] dbg_csc_wt_a_34;
wire      [7:0] dbg_csc_wt_a_35;
wire      [7:0] dbg_csc_wt_a_36;
wire      [7:0] dbg_csc_wt_a_37;
wire      [7:0] dbg_csc_wt_a_38;
wire      [7:0] dbg_csc_wt_a_39;
wire      [7:0] dbg_csc_wt_a_4;
wire      [7:0] dbg_csc_wt_a_40;
wire      [7:0] dbg_csc_wt_a_41;
wire      [7:0] dbg_csc_wt_a_42;
wire      [7:0] dbg_csc_wt_a_43;
wire      [7:0] dbg_csc_wt_a_44;
wire      [7:0] dbg_csc_wt_a_45;
wire      [7:0] dbg_csc_wt_a_46;
wire      [7:0] dbg_csc_wt_a_47;
wire      [7:0] dbg_csc_wt_a_48;
wire      [7:0] dbg_csc_wt_a_49;
wire      [7:0] dbg_csc_wt_a_5;
wire      [7:0] dbg_csc_wt_a_50;
wire      [7:0] dbg_csc_wt_a_51;
wire      [7:0] dbg_csc_wt_a_52;
wire      [7:0] dbg_csc_wt_a_53;
wire      [7:0] dbg_csc_wt_a_54;
wire      [7:0] dbg_csc_wt_a_55;
wire      [7:0] dbg_csc_wt_a_56;
wire      [7:0] dbg_csc_wt_a_57;
wire      [7:0] dbg_csc_wt_a_58;
wire      [7:0] dbg_csc_wt_a_59;
wire      [7:0] dbg_csc_wt_a_6;
wire      [7:0] dbg_csc_wt_a_60;
wire      [7:0] dbg_csc_wt_a_61;
wire      [7:0] dbg_csc_wt_a_62;
wire      [7:0] dbg_csc_wt_a_63;
wire      [7:0] dbg_csc_wt_a_64;
wire      [7:0] dbg_csc_wt_a_65;
wire      [7:0] dbg_csc_wt_a_66;
wire      [7:0] dbg_csc_wt_a_67;
wire      [7:0] dbg_csc_wt_a_68;
wire      [7:0] dbg_csc_wt_a_69;
wire      [7:0] dbg_csc_wt_a_7;
wire      [7:0] dbg_csc_wt_a_70;
wire      [7:0] dbg_csc_wt_a_71;
wire      [7:0] dbg_csc_wt_a_72;
wire      [7:0] dbg_csc_wt_a_73;
wire      [7:0] dbg_csc_wt_a_74;
wire      [7:0] dbg_csc_wt_a_75;
wire      [7:0] dbg_csc_wt_a_76;
wire      [7:0] dbg_csc_wt_a_77;
wire      [7:0] dbg_csc_wt_a_78;
wire      [7:0] dbg_csc_wt_a_79;
wire      [7:0] dbg_csc_wt_a_8;
wire      [7:0] dbg_csc_wt_a_80;
wire      [7:0] dbg_csc_wt_a_81;
wire      [7:0] dbg_csc_wt_a_82;
wire      [7:0] dbg_csc_wt_a_83;
wire      [7:0] dbg_csc_wt_a_84;
wire      [7:0] dbg_csc_wt_a_85;
wire      [7:0] dbg_csc_wt_a_86;
wire      [7:0] dbg_csc_wt_a_87;
wire      [7:0] dbg_csc_wt_a_88;
wire      [7:0] dbg_csc_wt_a_89;
wire      [7:0] dbg_csc_wt_a_9;
wire      [7:0] dbg_csc_wt_a_90;
wire      [7:0] dbg_csc_wt_a_91;
wire      [7:0] dbg_csc_wt_a_92;
wire      [7:0] dbg_csc_wt_a_93;
wire      [7:0] dbg_csc_wt_a_94;
wire      [7:0] dbg_csc_wt_a_95;
wire      [7:0] dbg_csc_wt_a_96;
wire      [7:0] dbg_csc_wt_a_97;
wire      [7:0] dbg_csc_wt_a_98;
wire      [7:0] dbg_csc_wt_a_99;
wire   [1023:0] dbg_csc_wt_b;
wire      [7:0] dbg_csc_wt_b_0;
wire      [7:0] dbg_csc_wt_b_1;
wire      [7:0] dbg_csc_wt_b_10;
wire      [7:0] dbg_csc_wt_b_100;
wire      [7:0] dbg_csc_wt_b_101;
wire      [7:0] dbg_csc_wt_b_102;
wire      [7:0] dbg_csc_wt_b_103;
wire      [7:0] dbg_csc_wt_b_104;
wire      [7:0] dbg_csc_wt_b_105;
wire      [7:0] dbg_csc_wt_b_106;
wire      [7:0] dbg_csc_wt_b_107;
wire      [7:0] dbg_csc_wt_b_108;
wire      [7:0] dbg_csc_wt_b_109;
wire      [7:0] dbg_csc_wt_b_11;
wire      [7:0] dbg_csc_wt_b_110;
wire      [7:0] dbg_csc_wt_b_111;
wire      [7:0] dbg_csc_wt_b_112;
wire      [7:0] dbg_csc_wt_b_113;
wire      [7:0] dbg_csc_wt_b_114;
wire      [7:0] dbg_csc_wt_b_115;
wire      [7:0] dbg_csc_wt_b_116;
wire      [7:0] dbg_csc_wt_b_117;
wire      [7:0] dbg_csc_wt_b_118;
wire      [7:0] dbg_csc_wt_b_119;
wire      [7:0] dbg_csc_wt_b_12;
wire      [7:0] dbg_csc_wt_b_120;
wire      [7:0] dbg_csc_wt_b_121;
wire      [7:0] dbg_csc_wt_b_122;
wire      [7:0] dbg_csc_wt_b_123;
wire      [7:0] dbg_csc_wt_b_124;
wire      [7:0] dbg_csc_wt_b_125;
wire      [7:0] dbg_csc_wt_b_126;
wire      [7:0] dbg_csc_wt_b_127;
wire      [7:0] dbg_csc_wt_b_13;
wire      [7:0] dbg_csc_wt_b_14;
wire      [7:0] dbg_csc_wt_b_15;
wire      [7:0] dbg_csc_wt_b_16;
wire      [7:0] dbg_csc_wt_b_17;
wire      [7:0] dbg_csc_wt_b_18;
wire      [7:0] dbg_csc_wt_b_19;
wire      [7:0] dbg_csc_wt_b_2;
wire      [7:0] dbg_csc_wt_b_20;
wire      [7:0] dbg_csc_wt_b_21;
wire      [7:0] dbg_csc_wt_b_22;
wire      [7:0] dbg_csc_wt_b_23;
wire      [7:0] dbg_csc_wt_b_24;
wire      [7:0] dbg_csc_wt_b_25;
wire      [7:0] dbg_csc_wt_b_26;
wire      [7:0] dbg_csc_wt_b_27;
wire      [7:0] dbg_csc_wt_b_28;
wire      [7:0] dbg_csc_wt_b_29;
wire      [7:0] dbg_csc_wt_b_3;
wire      [7:0] dbg_csc_wt_b_30;
wire      [7:0] dbg_csc_wt_b_31;
wire      [7:0] dbg_csc_wt_b_32;
wire      [7:0] dbg_csc_wt_b_33;
wire      [7:0] dbg_csc_wt_b_34;
wire      [7:0] dbg_csc_wt_b_35;
wire      [7:0] dbg_csc_wt_b_36;
wire      [7:0] dbg_csc_wt_b_37;
wire      [7:0] dbg_csc_wt_b_38;
wire      [7:0] dbg_csc_wt_b_39;
wire      [7:0] dbg_csc_wt_b_4;
wire      [7:0] dbg_csc_wt_b_40;
wire      [7:0] dbg_csc_wt_b_41;
wire      [7:0] dbg_csc_wt_b_42;
wire      [7:0] dbg_csc_wt_b_43;
wire      [7:0] dbg_csc_wt_b_44;
wire      [7:0] dbg_csc_wt_b_45;
wire      [7:0] dbg_csc_wt_b_46;
wire      [7:0] dbg_csc_wt_b_47;
wire      [7:0] dbg_csc_wt_b_48;
wire      [7:0] dbg_csc_wt_b_49;
wire      [7:0] dbg_csc_wt_b_5;
wire      [7:0] dbg_csc_wt_b_50;
wire      [7:0] dbg_csc_wt_b_51;
wire      [7:0] dbg_csc_wt_b_52;
wire      [7:0] dbg_csc_wt_b_53;
wire      [7:0] dbg_csc_wt_b_54;
wire      [7:0] dbg_csc_wt_b_55;
wire      [7:0] dbg_csc_wt_b_56;
wire      [7:0] dbg_csc_wt_b_57;
wire      [7:0] dbg_csc_wt_b_58;
wire      [7:0] dbg_csc_wt_b_59;
wire      [7:0] dbg_csc_wt_b_6;
wire      [7:0] dbg_csc_wt_b_60;
wire      [7:0] dbg_csc_wt_b_61;
wire      [7:0] dbg_csc_wt_b_62;
wire      [7:0] dbg_csc_wt_b_63;
wire      [7:0] dbg_csc_wt_b_64;
wire      [7:0] dbg_csc_wt_b_65;
wire      [7:0] dbg_csc_wt_b_66;
wire      [7:0] dbg_csc_wt_b_67;
wire      [7:0] dbg_csc_wt_b_68;
wire      [7:0] dbg_csc_wt_b_69;
wire      [7:0] dbg_csc_wt_b_7;
wire      [7:0] dbg_csc_wt_b_70;
wire      [7:0] dbg_csc_wt_b_71;
wire      [7:0] dbg_csc_wt_b_72;
wire      [7:0] dbg_csc_wt_b_73;
wire      [7:0] dbg_csc_wt_b_74;
wire      [7:0] dbg_csc_wt_b_75;
wire      [7:0] dbg_csc_wt_b_76;
wire      [7:0] dbg_csc_wt_b_77;
wire      [7:0] dbg_csc_wt_b_78;
wire      [7:0] dbg_csc_wt_b_79;
wire      [7:0] dbg_csc_wt_b_8;
wire      [7:0] dbg_csc_wt_b_80;
wire      [7:0] dbg_csc_wt_b_81;
wire      [7:0] dbg_csc_wt_b_82;
wire      [7:0] dbg_csc_wt_b_83;
wire      [7:0] dbg_csc_wt_b_84;
wire      [7:0] dbg_csc_wt_b_85;
wire      [7:0] dbg_csc_wt_b_86;
wire      [7:0] dbg_csc_wt_b_87;
wire      [7:0] dbg_csc_wt_b_88;
wire      [7:0] dbg_csc_wt_b_89;
wire      [7:0] dbg_csc_wt_b_9;
wire      [7:0] dbg_csc_wt_b_90;
wire      [7:0] dbg_csc_wt_b_91;
wire      [7:0] dbg_csc_wt_b_92;
wire      [7:0] dbg_csc_wt_b_93;
wire      [7:0] dbg_csc_wt_b_94;
wire      [7:0] dbg_csc_wt_b_95;
wire      [7:0] dbg_csc_wt_b_96;
wire      [7:0] dbg_csc_wt_b_97;
wire      [7:0] dbg_csc_wt_b_98;
wire      [7:0] dbg_csc_wt_b_99;
wire     [15:0] dec_input_sel;
wire      [7:0] sc2mac_out_data0;
wire      [7:0] sc2mac_out_data1;
wire      [7:0] sc2mac_out_data10;
wire      [7:0] sc2mac_out_data100;
wire      [7:0] sc2mac_out_data101;
wire      [7:0] sc2mac_out_data102;
wire      [7:0] sc2mac_out_data103;
wire      [7:0] sc2mac_out_data104;
wire      [7:0] sc2mac_out_data105;
wire      [7:0] sc2mac_out_data106;
wire      [7:0] sc2mac_out_data107;
wire      [7:0] sc2mac_out_data108;
wire      [7:0] sc2mac_out_data109;
wire      [7:0] sc2mac_out_data11;
wire      [7:0] sc2mac_out_data110;
wire      [7:0] sc2mac_out_data111;
wire      [7:0] sc2mac_out_data112;
wire      [7:0] sc2mac_out_data113;
wire      [7:0] sc2mac_out_data114;
wire      [7:0] sc2mac_out_data115;
wire      [7:0] sc2mac_out_data116;
wire      [7:0] sc2mac_out_data117;
wire      [7:0] sc2mac_out_data118;
wire      [7:0] sc2mac_out_data119;
wire      [7:0] sc2mac_out_data12;
wire      [7:0] sc2mac_out_data120;
wire      [7:0] sc2mac_out_data121;
wire      [7:0] sc2mac_out_data122;
wire      [7:0] sc2mac_out_data123;
wire      [7:0] sc2mac_out_data124;
wire      [7:0] sc2mac_out_data125;
wire      [7:0] sc2mac_out_data126;
wire      [7:0] sc2mac_out_data127;
wire      [7:0] sc2mac_out_data13;
wire      [7:0] sc2mac_out_data14;
wire      [7:0] sc2mac_out_data15;
wire      [7:0] sc2mac_out_data16;
wire      [7:0] sc2mac_out_data17;
wire      [7:0] sc2mac_out_data18;
wire      [7:0] sc2mac_out_data19;
wire      [7:0] sc2mac_out_data2;
wire      [7:0] sc2mac_out_data20;
wire      [7:0] sc2mac_out_data21;
wire      [7:0] sc2mac_out_data22;
wire      [7:0] sc2mac_out_data23;
wire      [7:0] sc2mac_out_data24;
wire      [7:0] sc2mac_out_data25;
wire      [7:0] sc2mac_out_data26;
wire      [7:0] sc2mac_out_data27;
wire      [7:0] sc2mac_out_data28;
wire      [7:0] sc2mac_out_data29;
wire      [7:0] sc2mac_out_data3;
wire      [7:0] sc2mac_out_data30;
wire      [7:0] sc2mac_out_data31;
wire      [7:0] sc2mac_out_data32;
wire      [7:0] sc2mac_out_data33;
wire      [7:0] sc2mac_out_data34;
wire      [7:0] sc2mac_out_data35;
wire      [7:0] sc2mac_out_data36;
wire      [7:0] sc2mac_out_data37;
wire      [7:0] sc2mac_out_data38;
wire      [7:0] sc2mac_out_data39;
wire      [7:0] sc2mac_out_data4;
wire      [7:0] sc2mac_out_data40;
wire      [7:0] sc2mac_out_data41;
wire      [7:0] sc2mac_out_data42;
wire      [7:0] sc2mac_out_data43;
wire      [7:0] sc2mac_out_data44;
wire      [7:0] sc2mac_out_data45;
wire      [7:0] sc2mac_out_data46;
wire      [7:0] sc2mac_out_data47;
wire      [7:0] sc2mac_out_data48;
wire      [7:0] sc2mac_out_data49;
wire      [7:0] sc2mac_out_data5;
wire      [7:0] sc2mac_out_data50;
wire      [7:0] sc2mac_out_data51;
wire      [7:0] sc2mac_out_data52;
wire      [7:0] sc2mac_out_data53;
wire      [7:0] sc2mac_out_data54;
wire      [7:0] sc2mac_out_data55;
wire      [7:0] sc2mac_out_data56;
wire      [7:0] sc2mac_out_data57;
wire      [7:0] sc2mac_out_data58;
wire      [7:0] sc2mac_out_data59;
wire      [7:0] sc2mac_out_data6;
wire      [7:0] sc2mac_out_data60;
wire      [7:0] sc2mac_out_data61;
wire      [7:0] sc2mac_out_data62;
wire      [7:0] sc2mac_out_data63;
wire      [7:0] sc2mac_out_data64;
wire      [7:0] sc2mac_out_data65;
wire      [7:0] sc2mac_out_data66;
wire      [7:0] sc2mac_out_data67;
wire      [7:0] sc2mac_out_data68;
wire      [7:0] sc2mac_out_data69;
wire      [7:0] sc2mac_out_data7;
wire      [7:0] sc2mac_out_data70;
wire      [7:0] sc2mac_out_data71;
wire      [7:0] sc2mac_out_data72;
wire      [7:0] sc2mac_out_data73;
wire      [7:0] sc2mac_out_data74;
wire      [7:0] sc2mac_out_data75;
wire      [7:0] sc2mac_out_data76;
wire      [7:0] sc2mac_out_data77;
wire      [7:0] sc2mac_out_data78;
wire      [7:0] sc2mac_out_data79;
wire      [7:0] sc2mac_out_data8;
wire      [7:0] sc2mac_out_data80;
wire      [7:0] sc2mac_out_data81;
wire      [7:0] sc2mac_out_data82;
wire      [7:0] sc2mac_out_data83;
wire      [7:0] sc2mac_out_data84;
wire      [7:0] sc2mac_out_data85;
wire      [7:0] sc2mac_out_data86;
wire      [7:0] sc2mac_out_data87;
wire      [7:0] sc2mac_out_data88;
wire      [7:0] sc2mac_out_data89;
wire      [7:0] sc2mac_out_data9;
wire      [7:0] sc2mac_out_data90;
wire      [7:0] sc2mac_out_data91;
wire      [7:0] sc2mac_out_data92;
wire      [7:0] sc2mac_out_data93;
wire      [7:0] sc2mac_out_data94;
wire      [7:0] sc2mac_out_data95;
wire      [7:0] sc2mac_out_data96;
wire      [7:0] sc2mac_out_data97;
wire      [7:0] sc2mac_out_data98;
wire      [7:0] sc2mac_out_data99;
wire    [127:0] sc2mac_out_mask;
wire            sc2mac_out_pvld;
wire     [15:0] sc2mac_out_sel;
wire            wl_channel_end;
wire      [1:0] wl_cur_sub_h;
wire            wl_group_end;
wire     [17:0] wl_in_pd;
wire     [17:0] wl_in_pd_d0;
wire            wl_in_pvld;
wire            wl_in_pvld_d0;
wire      [5:0] wl_kernel_size;
wire     [17:0] wl_pd;
wire            wl_pvld;
wire      [6:0] wl_weight_size;
wire            wl_wt_release;
wire            wmb_req_d1_channel_end;
wire      [1:0] wmb_req_d1_cur_sub_h;
wire            wmb_req_d1_dual;
wire      [7:0] wmb_req_d1_element;
wire            wmb_req_d1_group_end;
wire      [6:0] wmb_req_d1_ori_element;
wire            wmb_req_d1_rls;
wire      [8:0] wmb_req_d1_rls_entries;
wire            wmb_req_d1_stripe_end;
wire     [30:0] wmb_req_pipe_pd;
wire            wmb_req_pipe_pvld;
wire            wmb_rsp_channel_end;
wire      [1:0] wmb_rsp_cur_sub_h;
wire            wmb_rsp_dual;
wire      [7:0] wmb_rsp_element;
wire            wmb_rsp_group_end;
wire      [6:0] wmb_rsp_ori_element;
wire     [30:0] wmb_rsp_pipe_pd;
wire     [30:0] wmb_rsp_pipe_pd_d0;
wire            wmb_rsp_pipe_pvld;
wire            wmb_rsp_pipe_pvld_d0;
wire            wmb_rsp_rls;
wire      [8:0] wmb_rsp_rls_entries;
wire            wmb_rsp_stripe_end;
wire      [7:0] wt_req_d1_bytes;
wire            wt_req_d1_channel_end;
wire            wt_req_d1_group_end;
wire            wt_req_d1_rls;
wire            wt_req_d1_stripe_end;
wire      [8:0] wt_req_d1_wmb_rls_entries;
wire     [11:0] wt_req_d1_wt_rls_entries;
wire     [32:0] wt_req_pipe_pd;
wire            wt_req_pipe_pvld;
wire      [7:0] wt_rsp_bytes;
wire            wt_rsp_channel_end;
wire            wt_rsp_group_end;
wire    [127:0] wt_rsp_mask;
wire    [127:0] wt_rsp_mask_d0;
wire            wt_rsp_mask_en;
wire            wt_rsp_mask_en_d0;
wire     [32:0] wt_rsp_pipe_pd;
wire     [32:0] wt_rsp_pipe_pd_d0;
wire            wt_rsp_pipe_pvld;
wire            wt_rsp_pipe_pvld_d0;
wire            wt_rsp_rls;
wire            wt_rsp_stripe_end;
wire      [8:0] wt_rsp_wmb_rls_entries;
wire     [11:0] wt_rsp_wt_rls_entries;
reg             addr_init;
reg             cbuf_reset;
reg       [3:0] data_bank;
reg       [3:0] data_bank_w;
reg    [1023:0] dec_input_data;
reg     [127:0] dec_input_mask;
reg       [9:0] dec_input_mask_en;
reg             dec_input_pipe_valid;
reg             is_compressed;
reg             is_compressed_d1;
reg             is_fp16;
reg             is_fp16_d1;
reg             is_int8;
reg             is_int8_d1;
reg             is_sg_done;
reg             is_sg_idle;
reg             is_sg_pending;
reg             is_sg_running;
reg             is_sg_running_d1;
reg             is_stripe_end;
reg             is_wr_req_addr_wrap;
reg             is_wt_entry_end_wrap;
reg             is_wt_entry_st_wrap;
reg      [11:0] last_weight_entries;
reg       [8:0] last_wmb_entries;
reg       [8:0] last_wmb_entries_w;
reg             layer_st;
reg             mon_data_bank_w;
reg             mon_stripe_cnt_inc;
reg             mon_stripe_length;
reg       [2:0] mon_sub_h_total_w;
reg             mon_weight_bank_w;
reg             mon_wmb_element_avl_inc;
reg             mon_wmb_entry_avl_w;
reg             mon_wmb_entry_end_inc;
reg             mon_wmb_entry_st_inc;
reg             mon_wmb_req_addr_inc;
reg             mon_wmb_req_element;
reg             mon_wmb_rls_cnt_inc;
reg       [1:0] mon_wmb_rsp_bit_remain_w;
reg      [63:0] mon_wmb_rsp_emask_in_hi;
reg             mon_wmb_shift_remain;
reg             mon_wt_byte_avl_inc;
reg       [7:0] mon_wt_data_input_rs;
reg             mon_wt_entry_avl_w;
reg             mon_wt_entry_end_inc_wrap;
reg             mon_wt_entry_st_inc_wrap;
reg             mon_wt_req_addr_inc;
reg             mon_wt_req_addr_out;
reg      [31:0] mon_wt_req_emask_p1;
reg      [47:0] mon_wt_req_emask_p2;
reg      [47:0] mon_wt_req_emask_p3;
reg      [31:0] mon_wt_req_emask_p5;
reg      [47:0] mon_wt_req_emask_p6;
reg      [47:0] mon_wt_req_emask_p7;
reg             mon_wt_rls_cnt_inc;
reg       [1:0] mon_wt_rsp_byte_remain_w;
reg             mon_wt_shift_remain;
reg             reuse_rls;
reg       [7:0] sc2buf_wmb_rd_addr;
reg             sc2buf_wmb_rd_en;
reg      [11:0] sc2buf_wt_rd_addr;
reg             sc2buf_wt_rd_en;
reg       [8:0] sc2cdma_wmb_entries;
reg      [11:0] sc2cdma_wt_entries;
reg             sc2cdma_wt_updt;
reg     [127:0] sc2mac_out_a_mask;
reg       [7:0] sc2mac_out_a_sel_w;
reg     [127:0] sc2mac_out_b_mask;
reg       [7:0] sc2mac_out_b_sel_w;
reg       [7:0] sc2mac_wt_a_data0;
reg       [7:0] sc2mac_wt_a_data1;
reg       [7:0] sc2mac_wt_a_data10;
reg       [7:0] sc2mac_wt_a_data100;
reg       [7:0] sc2mac_wt_a_data101;
reg       [7:0] sc2mac_wt_a_data102;
reg       [7:0] sc2mac_wt_a_data103;
reg       [7:0] sc2mac_wt_a_data104;
reg       [7:0] sc2mac_wt_a_data105;
reg       [7:0] sc2mac_wt_a_data106;
reg       [7:0] sc2mac_wt_a_data107;
reg       [7:0] sc2mac_wt_a_data108;
reg       [7:0] sc2mac_wt_a_data109;
reg       [7:0] sc2mac_wt_a_data11;
reg       [7:0] sc2mac_wt_a_data110;
reg       [7:0] sc2mac_wt_a_data111;
reg       [7:0] sc2mac_wt_a_data112;
reg       [7:0] sc2mac_wt_a_data113;
reg       [7:0] sc2mac_wt_a_data114;
reg       [7:0] sc2mac_wt_a_data115;
reg       [7:0] sc2mac_wt_a_data116;
reg       [7:0] sc2mac_wt_a_data117;
reg       [7:0] sc2mac_wt_a_data118;
reg       [7:0] sc2mac_wt_a_data119;
reg       [7:0] sc2mac_wt_a_data12;
reg       [7:0] sc2mac_wt_a_data120;
reg       [7:0] sc2mac_wt_a_data121;
reg       [7:0] sc2mac_wt_a_data122;
reg       [7:0] sc2mac_wt_a_data123;
reg       [7:0] sc2mac_wt_a_data124;
reg       [7:0] sc2mac_wt_a_data125;
reg       [7:0] sc2mac_wt_a_data126;
reg       [7:0] sc2mac_wt_a_data127;
reg       [7:0] sc2mac_wt_a_data13;
reg       [7:0] sc2mac_wt_a_data14;
reg       [7:0] sc2mac_wt_a_data15;
reg       [7:0] sc2mac_wt_a_data16;
reg       [7:0] sc2mac_wt_a_data17;
reg       [7:0] sc2mac_wt_a_data18;
reg       [7:0] sc2mac_wt_a_data19;
reg       [7:0] sc2mac_wt_a_data2;
reg       [7:0] sc2mac_wt_a_data20;
reg       [7:0] sc2mac_wt_a_data21;
reg       [7:0] sc2mac_wt_a_data22;
reg       [7:0] sc2mac_wt_a_data23;
reg       [7:0] sc2mac_wt_a_data24;
reg       [7:0] sc2mac_wt_a_data25;
reg       [7:0] sc2mac_wt_a_data26;
reg       [7:0] sc2mac_wt_a_data27;
reg       [7:0] sc2mac_wt_a_data28;
reg       [7:0] sc2mac_wt_a_data29;
reg       [7:0] sc2mac_wt_a_data3;
reg       [7:0] sc2mac_wt_a_data30;
reg       [7:0] sc2mac_wt_a_data31;
reg       [7:0] sc2mac_wt_a_data32;
reg       [7:0] sc2mac_wt_a_data33;
reg       [7:0] sc2mac_wt_a_data34;
reg       [7:0] sc2mac_wt_a_data35;
reg       [7:0] sc2mac_wt_a_data36;
reg       [7:0] sc2mac_wt_a_data37;
reg       [7:0] sc2mac_wt_a_data38;
reg       [7:0] sc2mac_wt_a_data39;
reg       [7:0] sc2mac_wt_a_data4;
reg       [7:0] sc2mac_wt_a_data40;
reg       [7:0] sc2mac_wt_a_data41;
reg       [7:0] sc2mac_wt_a_data42;
reg       [7:0] sc2mac_wt_a_data43;
reg       [7:0] sc2mac_wt_a_data44;
reg       [7:0] sc2mac_wt_a_data45;
reg       [7:0] sc2mac_wt_a_data46;
reg       [7:0] sc2mac_wt_a_data47;
reg       [7:0] sc2mac_wt_a_data48;
reg       [7:0] sc2mac_wt_a_data49;
reg       [7:0] sc2mac_wt_a_data5;
reg       [7:0] sc2mac_wt_a_data50;
reg       [7:0] sc2mac_wt_a_data51;
reg       [7:0] sc2mac_wt_a_data52;
reg       [7:0] sc2mac_wt_a_data53;
reg       [7:0] sc2mac_wt_a_data54;
reg       [7:0] sc2mac_wt_a_data55;
reg       [7:0] sc2mac_wt_a_data56;
reg       [7:0] sc2mac_wt_a_data57;
reg       [7:0] sc2mac_wt_a_data58;
reg       [7:0] sc2mac_wt_a_data59;
reg       [7:0] sc2mac_wt_a_data6;
reg       [7:0] sc2mac_wt_a_data60;
reg       [7:0] sc2mac_wt_a_data61;
reg       [7:0] sc2mac_wt_a_data62;
reg       [7:0] sc2mac_wt_a_data63;
reg       [7:0] sc2mac_wt_a_data64;
reg       [7:0] sc2mac_wt_a_data65;
reg       [7:0] sc2mac_wt_a_data66;
reg       [7:0] sc2mac_wt_a_data67;
reg       [7:0] sc2mac_wt_a_data68;
reg       [7:0] sc2mac_wt_a_data69;
reg       [7:0] sc2mac_wt_a_data7;
reg       [7:0] sc2mac_wt_a_data70;
reg       [7:0] sc2mac_wt_a_data71;
reg       [7:0] sc2mac_wt_a_data72;
reg       [7:0] sc2mac_wt_a_data73;
reg       [7:0] sc2mac_wt_a_data74;
reg       [7:0] sc2mac_wt_a_data75;
reg       [7:0] sc2mac_wt_a_data76;
reg       [7:0] sc2mac_wt_a_data77;
reg       [7:0] sc2mac_wt_a_data78;
reg       [7:0] sc2mac_wt_a_data79;
reg       [7:0] sc2mac_wt_a_data8;
reg       [7:0] sc2mac_wt_a_data80;
reg       [7:0] sc2mac_wt_a_data81;
reg       [7:0] sc2mac_wt_a_data82;
reg       [7:0] sc2mac_wt_a_data83;
reg       [7:0] sc2mac_wt_a_data84;
reg       [7:0] sc2mac_wt_a_data85;
reg       [7:0] sc2mac_wt_a_data86;
reg       [7:0] sc2mac_wt_a_data87;
reg       [7:0] sc2mac_wt_a_data88;
reg       [7:0] sc2mac_wt_a_data89;
reg       [7:0] sc2mac_wt_a_data9;
reg       [7:0] sc2mac_wt_a_data90;
reg       [7:0] sc2mac_wt_a_data91;
reg       [7:0] sc2mac_wt_a_data92;
reg       [7:0] sc2mac_wt_a_data93;
reg       [7:0] sc2mac_wt_a_data94;
reg       [7:0] sc2mac_wt_a_data95;
reg       [7:0] sc2mac_wt_a_data96;
reg       [7:0] sc2mac_wt_a_data97;
reg       [7:0] sc2mac_wt_a_data98;
reg       [7:0] sc2mac_wt_a_data99;
reg     [127:0] sc2mac_wt_a_mask;
reg             sc2mac_wt_a_pvld;
reg             sc2mac_wt_a_pvld_w;
reg       [7:0] sc2mac_wt_a_sel;
reg       [7:0] sc2mac_wt_b_data0;
reg       [7:0] sc2mac_wt_b_data1;
reg       [7:0] sc2mac_wt_b_data10;
reg       [7:0] sc2mac_wt_b_data100;
reg       [7:0] sc2mac_wt_b_data101;
reg       [7:0] sc2mac_wt_b_data102;
reg       [7:0] sc2mac_wt_b_data103;
reg       [7:0] sc2mac_wt_b_data104;
reg       [7:0] sc2mac_wt_b_data105;
reg       [7:0] sc2mac_wt_b_data106;
reg       [7:0] sc2mac_wt_b_data107;
reg       [7:0] sc2mac_wt_b_data108;
reg       [7:0] sc2mac_wt_b_data109;
reg       [7:0] sc2mac_wt_b_data11;
reg       [7:0] sc2mac_wt_b_data110;
reg       [7:0] sc2mac_wt_b_data111;
reg       [7:0] sc2mac_wt_b_data112;
reg       [7:0] sc2mac_wt_b_data113;
reg       [7:0] sc2mac_wt_b_data114;
reg       [7:0] sc2mac_wt_b_data115;
reg       [7:0] sc2mac_wt_b_data116;
reg       [7:0] sc2mac_wt_b_data117;
reg       [7:0] sc2mac_wt_b_data118;
reg       [7:0] sc2mac_wt_b_data119;
reg       [7:0] sc2mac_wt_b_data12;
reg       [7:0] sc2mac_wt_b_data120;
reg       [7:0] sc2mac_wt_b_data121;
reg       [7:0] sc2mac_wt_b_data122;
reg       [7:0] sc2mac_wt_b_data123;
reg       [7:0] sc2mac_wt_b_data124;
reg       [7:0] sc2mac_wt_b_data125;
reg       [7:0] sc2mac_wt_b_data126;
reg       [7:0] sc2mac_wt_b_data127;
reg       [7:0] sc2mac_wt_b_data13;
reg       [7:0] sc2mac_wt_b_data14;
reg       [7:0] sc2mac_wt_b_data15;
reg       [7:0] sc2mac_wt_b_data16;
reg       [7:0] sc2mac_wt_b_data17;
reg       [7:0] sc2mac_wt_b_data18;
reg       [7:0] sc2mac_wt_b_data19;
reg       [7:0] sc2mac_wt_b_data2;
reg       [7:0] sc2mac_wt_b_data20;
reg       [7:0] sc2mac_wt_b_data21;
reg       [7:0] sc2mac_wt_b_data22;
reg       [7:0] sc2mac_wt_b_data23;
reg       [7:0] sc2mac_wt_b_data24;
reg       [7:0] sc2mac_wt_b_data25;
reg       [7:0] sc2mac_wt_b_data26;
reg       [7:0] sc2mac_wt_b_data27;
reg       [7:0] sc2mac_wt_b_data28;
reg       [7:0] sc2mac_wt_b_data29;
reg       [7:0] sc2mac_wt_b_data3;
reg       [7:0] sc2mac_wt_b_data30;
reg       [7:0] sc2mac_wt_b_data31;
reg       [7:0] sc2mac_wt_b_data32;
reg       [7:0] sc2mac_wt_b_data33;
reg       [7:0] sc2mac_wt_b_data34;
reg       [7:0] sc2mac_wt_b_data35;
reg       [7:0] sc2mac_wt_b_data36;
reg       [7:0] sc2mac_wt_b_data37;
reg       [7:0] sc2mac_wt_b_data38;
reg       [7:0] sc2mac_wt_b_data39;
reg       [7:0] sc2mac_wt_b_data4;
reg       [7:0] sc2mac_wt_b_data40;
reg       [7:0] sc2mac_wt_b_data41;
reg       [7:0] sc2mac_wt_b_data42;
reg       [7:0] sc2mac_wt_b_data43;
reg       [7:0] sc2mac_wt_b_data44;
reg       [7:0] sc2mac_wt_b_data45;
reg       [7:0] sc2mac_wt_b_data46;
reg       [7:0] sc2mac_wt_b_data47;
reg       [7:0] sc2mac_wt_b_data48;
reg       [7:0] sc2mac_wt_b_data49;
reg       [7:0] sc2mac_wt_b_data5;
reg       [7:0] sc2mac_wt_b_data50;
reg       [7:0] sc2mac_wt_b_data51;
reg       [7:0] sc2mac_wt_b_data52;
reg       [7:0] sc2mac_wt_b_data53;
reg       [7:0] sc2mac_wt_b_data54;
reg       [7:0] sc2mac_wt_b_data55;
reg       [7:0] sc2mac_wt_b_data56;
reg       [7:0] sc2mac_wt_b_data57;
reg       [7:0] sc2mac_wt_b_data58;
reg       [7:0] sc2mac_wt_b_data59;
reg       [7:0] sc2mac_wt_b_data6;
reg       [7:0] sc2mac_wt_b_data60;
reg       [7:0] sc2mac_wt_b_data61;
reg       [7:0] sc2mac_wt_b_data62;
reg       [7:0] sc2mac_wt_b_data63;
reg       [7:0] sc2mac_wt_b_data64;
reg       [7:0] sc2mac_wt_b_data65;
reg       [7:0] sc2mac_wt_b_data66;
reg       [7:0] sc2mac_wt_b_data67;
reg       [7:0] sc2mac_wt_b_data68;
reg       [7:0] sc2mac_wt_b_data69;
reg       [7:0] sc2mac_wt_b_data7;
reg       [7:0] sc2mac_wt_b_data70;
reg       [7:0] sc2mac_wt_b_data71;
reg       [7:0] sc2mac_wt_b_data72;
reg       [7:0] sc2mac_wt_b_data73;
reg       [7:0] sc2mac_wt_b_data74;
reg       [7:0] sc2mac_wt_b_data75;
reg       [7:0] sc2mac_wt_b_data76;
reg       [7:0] sc2mac_wt_b_data77;
reg       [7:0] sc2mac_wt_b_data78;
reg       [7:0] sc2mac_wt_b_data79;
reg       [7:0] sc2mac_wt_b_data8;
reg       [7:0] sc2mac_wt_b_data80;
reg       [7:0] sc2mac_wt_b_data81;
reg       [7:0] sc2mac_wt_b_data82;
reg       [7:0] sc2mac_wt_b_data83;
reg       [7:0] sc2mac_wt_b_data84;
reg       [7:0] sc2mac_wt_b_data85;
reg       [7:0] sc2mac_wt_b_data86;
reg       [7:0] sc2mac_wt_b_data87;
reg       [7:0] sc2mac_wt_b_data88;
reg       [7:0] sc2mac_wt_b_data89;
reg       [7:0] sc2mac_wt_b_data9;
reg       [7:0] sc2mac_wt_b_data90;
reg       [7:0] sc2mac_wt_b_data91;
reg       [7:0] sc2mac_wt_b_data92;
reg       [7:0] sc2mac_wt_b_data93;
reg       [7:0] sc2mac_wt_b_data94;
reg       [7:0] sc2mac_wt_b_data95;
reg       [7:0] sc2mac_wt_b_data96;
reg       [7:0] sc2mac_wt_b_data97;
reg       [7:0] sc2mac_wt_b_data98;
reg       [7:0] sc2mac_wt_b_data99;
reg     [127:0] sc2mac_wt_b_mask;
reg             sc2mac_wt_b_pvld;
reg             sc2mac_wt_b_pvld_w;
reg       [7:0] sc2mac_wt_b_sel;
reg       [4:0] stripe_cnt;
reg       [4:0] stripe_cnt_inc;
reg             stripe_cnt_reg_en;
reg       [4:0] stripe_cnt_w;
reg       [4:0] stripe_length;
reg      [63:0] sub_h_mask_1;
reg      [63:0] sub_h_mask_2;
reg      [63:0] sub_h_mask_3;
reg       [2:0] sub_h_total;
reg       [2:0] sub_h_total_w;
reg             sub_rls;
reg       [8:0] sub_rls_wmb_entries;
reg      [11:0] sub_rls_wt_entries;
reg       [3:0] weight_bank;
reg       [3:0] weight_bank_w;
reg      [17:0] wl_in_pd_d1;
reg             wl_in_pvld_d1;
reg      [10:0] wmb_element_avl;
reg      [10:0] wmb_element_avl_add;
reg      [10:0] wmb_element_avl_inc;
reg      [10:0] wmb_element_avl_last;
reg             wmb_element_avl_last_reg_en;
reg             wmb_element_avl_reg_en;
reg       [7:0] wmb_element_avl_sub;
reg      [10:0] wmb_element_avl_w;
reg     [127:0] wmb_emask_rd_ls;
reg    [1023:0] wmb_emask_rd_rs;
reg    [1023:0] wmb_emask_remain;
reg    [1023:0] wmb_emask_remain_last;
reg             wmb_emask_remain_last_reg_en;
reg             wmb_emask_remain_reg_en;
reg    [1023:0] wmb_emask_remain_rs;
reg    [1023:0] wmb_emask_remain_w;
reg       [8:0] wmb_entry_avl;
reg       [8:0] wmb_entry_avl_add;
reg       [8:0] wmb_entry_avl_sub;
reg       [8:0] wmb_entry_avl_w;
reg       [7:0] wmb_entry_end;
reg       [8:0] wmb_entry_end_inc;
reg       [7:0] wmb_entry_end_w;
reg       [7:0] wmb_entry_st;
reg       [8:0] wmb_entry_st_inc;
reg       [7:0] wmb_entry_st_w;
reg             wmb_pipe_valid;
reg             wmb_pipe_valid_d1;
reg       [7:0] wmb_req_addr;
reg       [7:0] wmb_req_addr_inc;
reg       [7:0] wmb_req_addr_last;
reg             wmb_req_addr_last_reg_en;
reg             wmb_req_addr_reg_en;
reg       [7:0] wmb_req_addr_w;
reg             wmb_req_channel_end_d1;
reg       [1:0] wmb_req_cur_sub_h_d1;
reg       [7:0] wmb_req_cycle_element;
reg             wmb_req_dual;
reg             wmb_req_dual_d1;
reg       [7:0] wmb_req_element;
reg       [7:0] wmb_req_element_d1;
reg             wmb_req_group_end_d1;
reg       [6:0] wmb_req_ori_element;
reg       [6:0] wmb_req_ori_element_d1;
reg             wmb_req_rls_d1;
reg       [8:0] wmb_req_rls_entries_d1;
reg             wmb_req_stripe_end_d1;
reg             wmb_req_valid;
reg       [8:0] wmb_rls_cnt;
reg       [8:0] wmb_rls_cnt_inc;
reg             wmb_rls_cnt_reg_en;
reg             wmb_rls_cnt_vld;
reg             wmb_rls_cnt_vld_w;
reg       [8:0] wmb_rls_cnt_w;
reg       [8:0] wmb_rls_entries;
reg       [9:0] wmb_rsp_bit_remain;
reg      [10:0] wmb_rsp_bit_remain_add;
reg       [9:0] wmb_rsp_bit_remain_last;
reg             wmb_rsp_bit_remain_last_reg_en;
reg       [7:0] wmb_rsp_bit_remain_sub;
reg       [9:0] wmb_rsp_bit_remain_w;
reg     [127:0] wmb_rsp_emask;
reg     [127:0] wmb_rsp_emask_in;
reg      [63:0] wmb_rsp_emask_in_hi;
reg       [6:0] wmb_rsp_ori_sft_3;
reg      [30:0] wmb_rsp_pipe_pd_d1;
reg      [30:0] wmb_rsp_pipe_pd_d2;
reg      [30:0] wmb_rsp_pipe_pd_d3;
reg      [30:0] wmb_rsp_pipe_pd_d4;
reg      [30:0] wmb_rsp_pipe_pd_d5;
reg      [30:0] wmb_rsp_pipe_pd_d6;
reg             wmb_rsp_pipe_pvld_d1;
reg             wmb_rsp_pipe_pvld_d2;
reg             wmb_rsp_pipe_pvld_d3;
reg             wmb_rsp_pipe_pvld_d4;
reg             wmb_rsp_pipe_pvld_d5;
reg             wmb_rsp_pipe_pvld_d6;
reg      [63:0] wmb_rsp_vld_d;
reg      [63:0] wmb_rsp_vld_s;
reg       [7:0] wmb_shift_remain;
reg       [7:0] wt_byte_avl;
reg       [7:0] wt_byte_avl_add;
reg       [7:0] wt_byte_avl_inc;
reg       [7:0] wt_byte_avl_last;
reg       [7:0] wt_byte_avl_sub;
reg       [7:0] wt_byte_avl_w;
reg             wt_byte_last_reg_en;
reg    [1023:0] wt_data_input_ls;
reg    [1015:0] wt_data_input_rs;
reg    [1023:0] wt_data_input_sft;
reg    [1015:0] wt_data_remain;
reg    [1015:0] wt_data_remain_last;
reg             wt_data_remain_last_reg_en;
reg    [1015:0] wt_data_remain_masked;
reg             wt_data_remain_reg_en;
reg    [1015:0] wt_data_remain_rs;
reg    [1015:0] wt_data_remain_w;
reg      [11:0] wt_entry_avl;
reg      [11:0] wt_entry_avl_add;
reg      [11:0] wt_entry_avl_sub;
reg      [11:0] wt_entry_avl_w;
reg      [11:0] wt_entry_end;
reg      [12:0] wt_entry_end_inc;
reg      [11:0] wt_entry_end_inc_wrap;
reg      [11:0] wt_entry_end_w;
reg      [11:0] wt_entry_st;
reg      [12:0] wt_entry_st_inc;
reg      [11:0] wt_entry_st_inc_wrap;
reg      [11:0] wt_entry_st_w;
reg      [11:0] wt_req_addr;
reg      [11:0] wt_req_addr_inc;
reg      [11:0] wt_req_addr_inc_wrap;
reg      [11:0] wt_req_addr_last;
reg             wt_req_addr_last_reg_en;
reg      [11:0] wt_req_addr_out;
reg             wt_req_addr_reg_en;
reg      [11:0] wt_req_addr_w;
reg     [127:0] wt_req_bmask;
reg       [7:0] wt_req_bytes;
reg       [7:0] wt_req_bytes_d1;
reg             wt_req_channel_end;
reg             wt_req_channel_end_d1;
reg       [1:0] wt_req_cur_sub_h;
reg             wt_req_dual;
reg     [127:0] wt_req_emask;
reg      [63:0] wt_req_emask_hi;
reg      [63:0] wt_req_emask_p0;
reg      [31:0] wt_req_emask_p1;
reg      [15:0] wt_req_emask_p2;
reg      [15:0] wt_req_emask_p3;
reg      [63:0] wt_req_emask_p4;
reg      [31:0] wt_req_emask_p5;
reg      [15:0] wt_req_emask_p6;
reg      [15:0] wt_req_emask_p7;
reg             wt_req_group_end;
reg             wt_req_group_end_d1;
reg     [127:0] wt_req_mask_d1;
reg             wt_req_mask_en;
reg             wt_req_mask_en_d1;
reg     [127:0] wt_req_mask_w;
reg       [6:0] wt_req_ori_element;
reg       [6:0] wt_req_ori_sft_1;
reg       [6:0] wt_req_ori_sft_2;
reg       [6:0] wt_req_ori_sft_3;
reg             wt_req_pipe_valid;
reg             wt_req_pipe_valid_d1;
reg             wt_req_rls;
reg             wt_req_rls_d1;
reg             wt_req_stripe_end;
reg             wt_req_stripe_end_d1;
reg             wt_req_valid;
reg      [63:0] wt_req_vld_bit;
reg       [8:0] wt_req_wmb_rls_entries;
reg       [8:0] wt_req_wmb_rls_entries_d1;
reg      [11:0] wt_req_wt_rls_entries_d1;
reg             wt_rls;
reg      [11:0] wt_rls_cnt;
reg      [11:0] wt_rls_cnt_inc;
reg             wt_rls_cnt_reg_en;
reg             wt_rls_cnt_vld;
reg             wt_rls_cnt_vld_w;
reg      [11:0] wt_rls_cnt_w;
reg      [11:0] wt_rls_entries;
reg             wt_rls_updt;
reg       [8:0] wt_rls_wmb_entries;
reg      [11:0] wt_rls_wt_entries;
reg       [6:0] wt_rsp_byte_remain;
reg       [7:0] wt_rsp_byte_remain_add;
reg             wt_rsp_byte_remain_en;
reg       [6:0] wt_rsp_byte_remain_last;
reg             wt_rsp_byte_remain_last_en;
reg       [6:0] wt_rsp_byte_remain_w;
reg    [1023:0] wt_rsp_data;
reg             wt_rsp_last_stripe_end;
reg     [127:0] wt_rsp_mask_d1;
reg     [127:0] wt_rsp_mask_d1_w;
reg     [127:0] wt_rsp_mask_d2;
reg     [127:0] wt_rsp_mask_d3;
reg     [127:0] wt_rsp_mask_d4;
reg     [127:0] wt_rsp_mask_d5;
reg     [127:0] wt_rsp_mask_d6;
reg             wt_rsp_mask_en_d1;
reg             wt_rsp_mask_en_d2;
reg             wt_rsp_mask_en_d3;
reg             wt_rsp_mask_en_d4;
reg             wt_rsp_mask_en_d5;
reg             wt_rsp_mask_en_d6;
reg      [32:0] wt_rsp_pipe_pd_d1;
reg      [32:0] wt_rsp_pipe_pd_d2;
reg      [32:0] wt_rsp_pipe_pd_d3;
reg      [32:0] wt_rsp_pipe_pd_d4;
reg      [32:0] wt_rsp_pipe_pd_d5;
reg      [32:0] wt_rsp_pipe_pd_d6;
reg             wt_rsp_pipe_pvld_d1;
reg             wt_rsp_pipe_pvld_d2;
reg             wt_rsp_pipe_pvld_d3;
reg             wt_rsp_pipe_pvld_d4;
reg             wt_rsp_pipe_pvld_d5;
reg             wt_rsp_pipe_pvld_d6;
reg      [15:0] wt_rsp_sel_d1;
reg      [15:0] wt_rsp_sel_w;
reg       [7:0] wt_shift_remain;

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
//                      input_package--------------
//                           |                    |
//                      WMB_request               |
//                           |                    |
//                      conv_buffer               |
//                           |                    |
//                      WMB_data ---------> weight_request
//                           |                    |
//                           |              conv_buffer
//                           |                    |
//                           |              weight_data   
//                           |                    |
//                           |              weight_data   
//                           |                    |
//                           |------------> weight_decompressor
//                                                |
//                                          weight_to_MAC_cell
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
    is_sg_pending = (sc_state == 1 );
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

always @(
  is_sg_running
  or is_sg_running_d1
  ) begin
    addr_init = is_sg_running & ~is_sg_running_d1;
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
  reg2dp_data_bank
  ) begin
    {mon_data_bank_w,
     data_bank_w} = reg2dp_data_bank + 1'b1;
end

always @(
  reg2dp_weight_bank
  ) begin
    {mon_weight_bank_w,
     weight_bank_w} = reg2dp_weight_bank + 1'b1;
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
  reg2dp_weight_format
  ) begin
    is_compressed = (reg2dp_weight_format == 1'h1 );
end

always @(
  reg2dp_y_extension
  ) begin
    {sub_h_total_w,
     mon_sub_h_total_w} = (6'h9 << reg2dp_y_extension);
end

always @(
  is_compressed_d1
  or reg2dp_wmb_bytes
  ) begin
    last_wmb_entries_w = is_compressed_d1 ? reg2dp_wmb_bytes[8 :0] : 9'b0;
end

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
    weight_bank <= {4{1'b0}};
  end else begin
  if ((layer_st) == 1'b1) begin
    weight_bank <= weight_bank_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    weight_bank <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
    last_weight_entries <= {12{1'b0}};
  end else begin
  if ((is_sg_done & reg2dp_skip_weight_rls) == 1'b1) begin
    last_weight_entries <= reg2dp_weight_bytes[12 -1:0];
  // VCS coverage off
  end else if ((is_sg_done & reg2dp_skip_weight_rls) == 1'b0) begin
  end else begin
    last_weight_entries <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_sg_done & reg2dp_skip_weight_rls))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    last_wmb_entries <= {9{1'b0}};
  end else begin
  if ((is_sg_done & reg2dp_skip_weight_rls) == 1'b1) begin
    last_wmb_entries <= last_wmb_entries_w;
  // VCS coverage off
  end else if ((is_sg_done & reg2dp_skip_weight_rls) == 1'b0) begin
  end else begin
    last_wmb_entries <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(is_sg_done & reg2dp_skip_weight_rls))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    sub_h_total <= 3'h1;
  end else begin
  if ((layer_st) == 1'b1) begin
    sub_h_total <= sub_h_total_w;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    sub_h_total <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
    is_int8_d1 <= 1'b0;
  end else begin
  if ((layer_st) == 1'b1) begin
    is_int8_d1 <= is_int8;
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
    is_fp16_d1 <= 1'b0;
  end else begin
  if ((layer_st) == 1'b1) begin
    is_fp16_d1 <= is_fp16;
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
    is_compressed_d1 <= 1'b0;
  end else begin
  if ((layer_st) == 1'b1) begin
    is_compressed_d1 <= is_compressed;
  // VCS coverage off
  end else if ((layer_st) == 1'b0) begin
  end else begin
    is_compressed_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_never #(0,0,"Error! Receive package when SG is not running")      zzz_assert_never_9x (nvdla_core_clk, `ASSERT_RESET, (~is_sg_running & wl_pvld)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! SG is not idle when op_en is not set")      zzz_assert_never_10x (nvdla_core_clk, `ASSERT_RESET, (~is_sg_idle & ~reg2dp_op_en)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! data bank oveflow")      zzz_assert_never_11x (nvdla_core_clk, `ASSERT_RESET, (mon_data_bank_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! weight bank oveflow")      zzz_assert_never_12x (nvdla_core_clk, `ASSERT_RESET, (mon_weight_bank_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config Error! weight bytes overflow in full weight mode")      zzz_assert_never_13x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & reg2dp_skip_weight_rls & (reg2dp_weight_bytes > 3840))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Config Error! wmb bytes overflow in full weight mode")      zzz_assert_never_14x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & is_compressed & reg2dp_skip_weight_rls & (reg2dp_wmb_bytes > 256))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//Now it's a valid test case
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
  nv_assert_never #(0,0,"Config Error! last_wmb_entries is out of range!")      zzz_assert_never_15x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & is_compressed & reg2dp_skip_weight_rls & ~(|reg2dp_wmb_bytes[8 :0]))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
///// cbuf status management                             /////
//////////////////////////////////////////////////////////////

always @(
  sc2cdma_wt_pending_req
  ) begin
    cbuf_reset = sc2cdma_wt_pending_req;
end

//////////////////////////////////// calculate avaliable kernels ////////////////////////////////////
//Avaliable kernel size is useless here. Discard the code

//////////////////////////////////// calculate avaliable weight entries ////////////////////////////////////
//================  Non-SLCG clock domain ================//

always @(
  cdma2sc_wt_updt
  or cdma2sc_wt_entries
  ) begin
    wt_entry_avl_add = cdma2sc_wt_updt ? cdma2sc_wt_entries : 12'b0;
end

always @(
  wt_rls
  or wt_rls_wt_entries
  ) begin
    wt_entry_avl_sub = wt_rls ? wt_rls_wt_entries : 12'b0;
end

always @(
  cbuf_reset
  or wt_entry_avl
  or wt_entry_avl_add
  or wt_entry_avl_sub
  ) begin
    {mon_wt_entry_avl_w,
     wt_entry_avl_w} = (cbuf_reset) ? 13'b0 :
                       wt_entry_avl + wt_entry_avl_add - wt_entry_avl_sub;
end

//////////////////////////////////// calculate avaliable wmb entries ////////////////////////////////////
always @(
  cdma2sc_wt_updt
  or cdma2sc_wmb_entries
  ) begin
    wmb_entry_avl_add = cdma2sc_wt_updt ? cdma2sc_wmb_entries : 9'b0;
end

always @(
  wt_rls
  or wt_rls_wmb_entries
  ) begin
    wmb_entry_avl_sub = wt_rls ? wt_rls_wmb_entries : 9'b0;
end

always @(
  cbuf_reset
  or wmb_entry_avl
  or wmb_entry_avl_add
  or wmb_entry_avl_sub
  ) begin
    {mon_wmb_entry_avl_w,
     wmb_entry_avl_w} = (cbuf_reset) ? 10'b0 :
                        wmb_entry_avl + wmb_entry_avl_add - wmb_entry_avl_sub;
end

//////////////////////////////////// calculate weight entries start offset ////////////////////////////////////
always @(
  wt_entry_st
  or wt_rls_wt_entries
  ) begin
     wt_entry_st_inc = wt_entry_st + wt_rls_wt_entries;
end

always @(
  wt_entry_st_inc
  or weight_bank
  ) begin
    {mon_wt_entry_st_inc_wrap,
     wt_entry_st_inc_wrap} = wt_entry_st_inc[12 -1:0] - {weight_bank, 8'b0};
end

always @(
  wt_entry_st_inc
  or weight_bank
  ) begin
    is_wt_entry_st_wrap = (wt_entry_st_inc >= {1'b0, weight_bank, 8'b0});
end

always @(
  cbuf_reset
  or wt_rls
  or wt_entry_st
  or is_wt_entry_st_wrap
  or wt_entry_st_inc_wrap
  or wt_entry_st_inc
  ) begin
    wt_entry_st_w = (cbuf_reset) ? 12'b0 :
                    (~wt_rls) ? wt_entry_st :
                    is_wt_entry_st_wrap ? wt_entry_st_inc_wrap :
                    wt_entry_st_inc[12 -1:0];
end

//////////////////////////////////// calculate weight entries end offset ////////////////////////////////////
always @(
  wt_entry_end
  or cdma2sc_wt_entries
  ) begin
     wt_entry_end_inc = wt_entry_end + cdma2sc_wt_entries;
end

always @(
  wt_entry_end_inc
  or weight_bank
  ) begin
    {mon_wt_entry_end_inc_wrap,
     wt_entry_end_inc_wrap} = wt_entry_end_inc[12 -1:0] - {weight_bank, 8'b0};
end

always @(
  wt_entry_end_inc
  or weight_bank
  ) begin
    is_wt_entry_end_wrap = (wt_entry_end_inc >= {1'b0, weight_bank, 8'b0});
end

always @(
  cbuf_reset
  or is_wt_entry_end_wrap
  or wt_entry_end_inc_wrap
  or wt_entry_end_inc
  ) begin
    wt_entry_end_w = (cbuf_reset) ? 12'b0 :
                     is_wt_entry_end_wrap ? wt_entry_end_inc_wrap :
                     wt_entry_end_inc[12 -1:0];
end

//////////////////////////////////// calculate wmb entries start offset ////////////////////////////////////
always @(
  wmb_entry_st
  or wt_rls_wmb_entries
  ) begin
    {mon_wmb_entry_st_inc,
     wmb_entry_st_inc} = wmb_entry_st + wt_rls_wmb_entries;
end

always @(
  cbuf_reset
  or wt_rls
  or wmb_entry_st
  or wmb_entry_st_inc
  ) begin
    wmb_entry_st_w = (cbuf_reset) ? 8'b0 :
                     (~wt_rls) ? wmb_entry_st :
                     wmb_entry_st_inc[8 -1:0];
end

//////////////////////////////////// calculate wmb entries end offset ////////////////////////////////////
always @(
  wmb_entry_end
  or cdma2sc_wmb_entries
  ) begin
    {mon_wmb_entry_end_inc,
     wmb_entry_end_inc} = wmb_entry_end + cdma2sc_wmb_entries;
end

always @(
  cbuf_reset
  or wmb_entry_end_inc
  ) begin
    wmb_entry_end_w = (cbuf_reset) ? 8'b0 : wmb_entry_end_inc[8 -1:0];
end

//////////////////////////////////// registers and assertions ////////////////////////////////////
always @(posedge nvdla_core_ng_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_entry_avl <= {12{1'b0}};
  end else begin
  if ((cdma2sc_wt_updt | wt_rls | cbuf_reset) == 1'b1) begin
    wt_entry_avl <= wt_entry_avl_w;
  // VCS coverage off
  end else if ((cdma2sc_wt_updt | wt_rls | cbuf_reset) == 1'b0) begin
  end else begin
    wt_entry_avl <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(cdma2sc_wt_updt | wt_rls | cbuf_reset))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_entry_avl <= {9{1'b0}};
  end else begin
  if ((cdma2sc_wt_updt | wt_rls | cbuf_reset) == 1'b1) begin
    wmb_entry_avl <= wmb_entry_avl_w;
  // VCS coverage off
  end else if ((cdma2sc_wt_updt | wt_rls | cbuf_reset) == 1'b0) begin
  end else begin
    wmb_entry_avl <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(cdma2sc_wt_updt | wt_rls | cbuf_reset))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_entry_st <= {12{1'b0}};
  end else begin
  if ((cbuf_reset | wt_rls) == 1'b1) begin
    wt_entry_st <= wt_entry_st_w;
  // VCS coverage off
  end else if ((cbuf_reset | wt_rls) == 1'b0) begin
  end else begin
    wt_entry_st <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(cbuf_reset | wt_rls))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_entry_end <= {12{1'b0}};
  end else begin
  if ((cbuf_reset | cdma2sc_wt_updt) == 1'b1) begin
    wt_entry_end <= wt_entry_end_w;
  // VCS coverage off
  end else if ((cbuf_reset | cdma2sc_wt_updt) == 1'b0) begin
  end else begin
    wt_entry_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(cbuf_reset | cdma2sc_wt_updt))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_entry_st <= {8{1'b0}};
  end else begin
  if ((cbuf_reset | wt_rls) == 1'b1) begin
    wmb_entry_st <= wmb_entry_st_w;
  // VCS coverage off
  end else if ((cbuf_reset | wt_rls) == 1'b0) begin
  end else begin
    wmb_entry_st <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(cbuf_reset | wt_rls))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_entry_end <= {8{1'b0}};
  end else begin
  if ((cbuf_reset | cdma2sc_wt_updt) == 1'b1) begin
    wmb_entry_end <= wmb_entry_end_w;
  // VCS coverage off
  end else if ((cbuf_reset | cdma2sc_wt_updt) == 1'b0) begin
  end else begin
    wmb_entry_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_ng_clk, `ASSERT_RESET, 1'd1,  (^(cbuf_reset | cdma2sc_wt_updt))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wt_entry_avl_w overflow")      zzz_assert_never_22x (nvdla_core_ng_clk, `ASSERT_RESET, (mon_wt_entry_avl_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wt_entry_avl_w is out of range")      zzz_assert_never_23x (nvdla_core_ng_clk, `ASSERT_RESET, (wt_entry_avl_w > 3840)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wmb_entry_avl_w overflow")      zzz_assert_never_24x (nvdla_core_ng_clk, `ASSERT_RESET, (mon_wmb_entry_avl_w)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wmb_entry_avl_w is out of range")      zzz_assert_never_25x (nvdla_core_ng_clk, `ASSERT_RESET, (wmb_entry_avl_w > {1'b1, 8'b0})); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! weight entries and address are not match - empty")      zzz_assert_never_26x (nvdla_core_ng_clk, `ASSERT_RESET, (~(|wt_entry_avl) & (wt_entry_st != wt_entry_end) & ~is_sg_pending)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! weight entries and address are not match - full")      zzz_assert_never_27x (nvdla_core_ng_clk, `ASSERT_RESET, ((wt_entry_avl == {weight_bank, 8'b0}) & (wt_entry_st != wt_entry_end) & ~is_sg_pending)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wmb entries and address are not match - empty")      zzz_assert_never_28x (nvdla_core_ng_clk, `ASSERT_RESET, (~(|wmb_entry_avl) & (wmb_entry_st != wmb_entry_end) & ~is_sg_pending)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wmb entries and address are not match - full")      zzz_assert_never_29x (nvdla_core_ng_clk, `ASSERT_RESET, ((wmb_entry_avl == {1'b0, 8'b0}) & (wmb_entry_st != wmb_entry_end) & reg2dp_op_en & ~is_sg_pending)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! Weight input update with zero kernels")      zzz_assert_never_30x (nvdla_core_ng_clk, `ASSERT_RESET, (cdma2sc_wt_updt & ~(|cdma2sc_wt_kernels))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  wt_rsp_pipe_pvld
  or wt_rsp_rls
  ) begin
    sub_rls = (wt_rsp_pipe_pvld & wt_rsp_rls);
end

always @(
  wt_rsp_wt_rls_entries
  ) begin
    sub_rls_wt_entries = wt_rsp_wt_rls_entries;
end

always @(
  wt_rsp_wmb_rls_entries
  ) begin
    sub_rls_wmb_entries = wt_rsp_wmb_rls_entries;
end

always @(
  sg2wl_reuse_rls
  ) begin
    reuse_rls = sg2wl_reuse_rls;
end

always @(
  reuse_rls
  or sub_rls
  ) begin
    wt_rls = reuse_rls | sub_rls;
end

always @(
  reuse_rls
  or last_weight_entries
  or sub_rls_wt_entries
  ) begin
    wt_rls_wt_entries = reuse_rls ? last_weight_entries :
                        sub_rls_wt_entries;
end

always @(
  reuse_rls
  or last_wmb_entries
  or sub_rls_wmb_entries
  ) begin
    wt_rls_wmb_entries = reuse_rls ? last_wmb_entries :
                         sub_rls_wmb_entries;
end

//Update for ECO bug 200332053
always @(
  wt_rls
  ) begin
    wt_rls_updt = wt_rls;   //ECO bug 200332053
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2cdma_wt_updt <= 1'b0;
  end else begin
  sc2cdma_wt_updt <= wt_rls_updt;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2cdma_wt_entries <= {12{1'b0}};
  end else begin
  if ((wt_rls_updt) == 1'b1) begin
    sc2cdma_wt_entries <= wt_rls_wt_entries;
  // VCS coverage off
  end else if ((wt_rls_updt) == 1'b0) begin
  end else begin
    sc2cdma_wt_entries <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_31x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rls_updt))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    sc2cdma_wmb_entries <= {9{1'b0}};
  end else begin
  if ((wt_rls_updt) == 1'b1) begin
    sc2cdma_wmb_entries <= wt_rls_wmb_entries;
  // VCS coverage off
  end else if ((wt_rls_updt) == 1'b0) begin
  end else begin
    sc2cdma_wmb_entries <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_32x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rls_updt))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//sc2cmda_wt_kernels is useless
assign sc2cdma_wt_kernels = 14'b0;

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
  nv_assert_zero_one_hot #(0,2,0,"Error! weight release reason conflict")      zzz_assert_zero_one_hot_33x (nvdla_core_clk, `ASSERT_RESET, ({reuse_rls, sub_rls})); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Useless assertion, please ignore")      zzz_assert_never_34x (nvdla_core_clk, `ASSERT_RESET, (sc2cdma_wt_updt & ~(|sc2cdma_wt_entries) & (|sc2cdma_wt_entries))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
assign wl_in_pvld_d0 = sg2wl_pvld;
assign wl_in_pd_d0 = sg2wl_pd;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wl_in_pvld_d1 <= 1'b0;
  end else begin
  wl_in_pvld_d1 <= wl_in_pvld_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wl_in_pd_d1 <= {18{1'b0}};
  end else begin
  if ((wl_in_pvld_d0) == 1'b1) begin
    wl_in_pd_d1 <= wl_in_pd_d0;
  // VCS coverage off
  end else if ((wl_in_pvld_d0) == 1'b0) begin
  end else begin
    wl_in_pd_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_35x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wl_in_pvld_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign wl_in_pvld = wl_in_pvld_d1;
assign wl_in_pd = wl_in_pd_d1;


assign wl_pvld = wl_in_pvld;
assign wl_pd = wl_in_pd;


// PKT_UNPACK_WIRE( csc_wt_pkg ,  wl_ ,  wl_pd )
assign        wl_weight_size[6:0] =     wl_pd[6:0];
assign        wl_kernel_size[5:0] =     wl_pd[12:7];
assign        wl_cur_sub_h[1:0] =     wl_pd[14:13];
assign         wl_channel_end  =     wl_pd[15];
assign         wl_group_end  =     wl_pd[16];
assign         wl_wt_release  =     wl_pd[17];

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
  nv_assert_never #(0,0,"Error! Get weight package when is sg is not running")      zzz_assert_never_36x (nvdla_core_clk, `ASSERT_RESET, (sg2wl_pvld & ~is_sg_running)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
///// generate wmb read request                          /////
//////////////////////////////////////////////////////////////

//////////////////////////////////// generate wmb_pipe_valid siganal ////////////////////////////////////

always @(
  stripe_cnt
  ) begin
    {mon_stripe_cnt_inc,
     stripe_cnt_inc} = stripe_cnt + 1'b1;
end

always @(
  layer_st
  or is_stripe_end
  or stripe_cnt_inc
  ) begin
    stripe_cnt_w = layer_st ? 5'b0 :
                   is_stripe_end ? 5'b0 :
                   stripe_cnt_inc;
end

always @(
  is_int8_d1
  or wl_kernel_size
  ) begin
    {mon_stripe_length,
     stripe_length} = is_int8_d1 ? (wl_kernel_size[5:1] + wl_kernel_size[0]) :
                      wl_kernel_size;
end

always @(
  stripe_cnt_inc
  or stripe_length
  ) begin
    is_stripe_end = (stripe_cnt_inc == stripe_length);
end

//assign is_stripe_st = wl_pvld;

always @(
  layer_st
  or wmb_pipe_valid
  ) begin
    stripe_cnt_reg_en = layer_st | wmb_pipe_valid;
end

always @(
  wl_pvld
  or stripe_cnt
  or wmb_pipe_valid_d1
  ) begin
    wmb_pipe_valid = wl_pvld ? 1'b1 :
                     ~(|stripe_cnt) ? 1'b0 :
                     wmb_pipe_valid_d1;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    stripe_cnt <= {5{1'b0}};
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_37x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(stripe_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! stripe_cnt is not zero when idle")      zzz_assert_never_38x (nvdla_core_clk, `ASSERT_RESET, (~reg2dp_op_en & |(stripe_cnt))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! stripe_cnt_w is overflow!")      zzz_assert_never_39x (nvdla_core_clk, `ASSERT_RESET, (wmb_pipe_valid & mon_stripe_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! stripe_length is overflow!")      zzz_assert_never_40x (nvdla_core_clk, `ASSERT_RESET, (wl_pvld & mon_stripe_length)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//////////////////////////////////// generate wmb_req_valid siganal ////////////////////////////////////

always @(
  wmb_req_valid
  ) begin
    wmb_element_avl_add = ~wmb_req_valid ? 11'b0 :
                          11'h400;
end

always @(
  wmb_pipe_valid
  or wmb_req_element
  ) begin
    wmb_element_avl_sub = wmb_pipe_valid ? wmb_req_element : 8'h0;
end

always @(
  wmb_element_avl
  or wmb_element_avl_add
  or wmb_element_avl_sub
  ) begin
    {mon_wmb_element_avl_inc,
     wmb_element_avl_inc} = wmb_element_avl + wmb_element_avl_add - wmb_element_avl_sub;
end

always @(
  layer_st
  or is_stripe_end
  or wl_group_end
  or wl_channel_end
  or wmb_element_avl_last
  or wmb_element_avl_inc
  ) begin
    wmb_element_avl_w = layer_st ? 11'b0 :
                        (is_stripe_end & ~wl_group_end & wl_channel_end) ? wmb_element_avl_last :
                        wmb_element_avl_inc;
end

always @(
  wl_weight_size
  ) begin
    wmb_req_ori_element = wl_weight_size;
end

always @(
  wmb_req_dual
  or wl_weight_size
  ) begin
    wmb_req_cycle_element = wmb_req_dual ? {wl_weight_size, 1'b0} :
                            {1'b0, wl_weight_size};
end

always @(
  wl_cur_sub_h
  or wmb_req_cycle_element
  ) begin
    {mon_wmb_req_element,
     wmb_req_element} = (wl_cur_sub_h == 2'h0) ? {1'b0, wmb_req_cycle_element} :
                        (wl_cur_sub_h == 2'h1) ? {1'b0, wmb_req_cycle_element[6:0], 1'b0} :
                        (wl_cur_sub_h == 2'h2) ? ({wmb_req_cycle_element[6:0], 1'b0} + wmb_req_cycle_element):
                        {1'b0, wmb_req_cycle_element[5:0], 2'b0};
end

always @(
  is_int8_d1
  or is_stripe_end
  or wl_kernel_size
  ) begin
    wmb_req_dual = is_int8_d1 & (~is_stripe_end | ~wl_kernel_size[0]);
end

always @(
  wmb_pipe_valid
  or is_compressed_d1
  or wmb_element_avl
  or wmb_req_element
  ) begin
    wmb_req_valid = wmb_pipe_valid & is_compressed_d1 & (wmb_element_avl < {{3{1'b0}}, wmb_req_element});
end

always @(
  layer_st
  or wmb_pipe_valid
  or is_compressed_d1
  ) begin
    wmb_element_avl_reg_en = layer_st | (wmb_pipe_valid & is_compressed_d1);
end

always @(
  layer_st
  or wmb_pipe_valid
  or is_compressed_d1
  or is_stripe_end
  or wl_group_end
  ) begin
    wmb_element_avl_last_reg_en = layer_st | (wmb_pipe_valid & is_compressed_d1 & is_stripe_end & wl_group_end);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_element_avl <= {11{1'b0}};
  end else begin
  if ((wmb_element_avl_reg_en) == 1'b1) begin
    wmb_element_avl <= wmb_element_avl_w;
  // VCS coverage off
  end else if ((wmb_element_avl_reg_en) == 1'b0) begin
  end else begin
    wmb_element_avl <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_41x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_element_avl_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_element_avl_last <= {11{1'b0}};
  end else begin
  if ((wmb_element_avl_last_reg_en) == 1'b1) begin
    wmb_element_avl_last <= wmb_element_avl_w;
  // VCS coverage off
  end else if ((wmb_element_avl_last_reg_en) == 1'b0) begin
  end else begin
    wmb_element_avl_last <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_42x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_element_avl_last_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wmb_element_avl_inc is overflow!")      zzz_assert_never_43x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & is_compressed_d1 & mon_wmb_element_avl_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wmb_req_element is out of range!")      zzz_assert_never_44x (nvdla_core_clk, `ASSERT_RESET, (wmb_pipe_valid & (wmb_req_element == 8'b0 || wmb_req_element > 8'h80))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wmb_req_element is overflow!")      zzz_assert_never_45x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & mon_wmb_req_element)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////// generate wmb read address ////////////////////////////////////

always @(
  wmb_req_addr
  ) begin
    {mon_wmb_req_addr_inc,
     wmb_req_addr_inc} = wmb_req_addr + 1'b1;
end

always @(
  addr_init
  or wmb_entry_st_w
  or is_stripe_end
  or wl_channel_end
  or wl_group_end
  or wmb_req_addr_last
  or wmb_req_valid
  or wmb_req_addr_inc
  or wmb_req_addr
  ) begin
    wmb_req_addr_w = addr_init ? wmb_entry_st_w :
                     (is_stripe_end & wl_channel_end & ~wl_group_end) ? wmb_req_addr_last :
                     wmb_req_valid ? wmb_req_addr_inc :
                     wmb_req_addr;
end

always @(
  is_compressed_d1
  or addr_init
  or wmb_req_valid
  or wmb_pipe_valid
  or is_stripe_end
  or wl_channel_end
  ) begin
    wmb_req_addr_reg_en = is_compressed_d1 & (addr_init | wmb_req_valid | (wmb_pipe_valid & is_stripe_end & wl_channel_end));
end

always @(
  is_compressed_d1
  or addr_init
  or wmb_pipe_valid
  or is_stripe_end
  or wl_group_end
  ) begin
    wmb_req_addr_last_reg_en = is_compressed_d1 & (addr_init | (wmb_pipe_valid & is_stripe_end & wl_group_end));
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_req_addr <= {8{1'b0}};
  end else begin
  if ((wmb_req_addr_reg_en) == 1'b1) begin
    wmb_req_addr <= wmb_req_addr_w;
  // VCS coverage off
  end else if ((wmb_req_addr_reg_en) == 1'b0) begin
  end else begin
    wmb_req_addr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_46x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_req_addr_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_req_addr_last <= {8{1'b0}};
  end else begin
  if ((wmb_req_addr_last_reg_en) == 1'b1) begin
    wmb_req_addr_last <= wmb_req_addr_w;
  // VCS coverage off
  end else if ((wmb_req_addr_last_reg_en) == 1'b0) begin
  end else begin
    wmb_req_addr_last <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_47x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_req_addr_last_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////// wmb entries counter for release ////////////////////////////////////

always @(
  layer_st
  or wl_group_end
  or is_stripe_end
  or wl_channel_end
  or wmb_rls_cnt_vld
  ) begin
    wmb_rls_cnt_vld_w = (layer_st | (wl_group_end & is_stripe_end)) ? 1'b0 :
                        (wl_channel_end & is_stripe_end) ? 1'b1 :
                        wmb_rls_cnt_vld;
end

always @(
  wmb_rls_cnt
  ) begin
    {mon_wmb_rls_cnt_inc,
     wmb_rls_cnt_inc} = wmb_rls_cnt + 1'b1;
end

always @(
  layer_st
  or is_stripe_end
  or wl_group_end
  or wmb_rls_cnt_inc
  ) begin
    wmb_rls_cnt_w = layer_st ? 9'b0 :
                    (is_stripe_end & wl_group_end) ? 9'b0 :
                    wmb_rls_cnt_inc;
end

always @(
  layer_st
  or is_compressed_d1
  or wmb_pipe_valid
  or is_stripe_end
  or wl_group_end
  or wmb_req_valid
  or wmb_rls_cnt_vld
  ) begin
    wmb_rls_cnt_reg_en = layer_st |
                         (is_compressed_d1 & wmb_pipe_valid & is_stripe_end & wl_group_end) |
                         (is_compressed_d1 & wmb_req_valid & ~wmb_rls_cnt_vld);
end

always @(
  wmb_rls_cnt_vld
  or wmb_req_valid
  or wmb_rls_cnt
  or wmb_rls_cnt_inc
  ) begin
    wmb_rls_entries = (wmb_rls_cnt_vld | ~wmb_req_valid) ? wmb_rls_cnt :
                      wmb_rls_cnt_inc;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_rls_cnt_vld <= 1'b0;
  end else begin
  wmb_rls_cnt_vld <= wmb_rls_cnt_vld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_rls_cnt <= {9{1'b0}};
  end else begin
  if ((wmb_rls_cnt_reg_en) == 1'b1) begin
    wmb_rls_cnt <= wmb_rls_cnt_w;
  // VCS coverage off
  end else if ((wmb_rls_cnt_reg_en) == 1'b0) begin
  end else begin
    wmb_rls_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_48x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_rls_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wmb_rls_cnt_inc is overflow!")      zzz_assert_never_49x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & is_compressed_d1 & mon_wmb_rls_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wmb_rls_cnt is out of range!")      zzz_assert_never_50x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en && is_compressed_d1 && (wmb_rls_cnt > 9'h100))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////// send wmb read request ////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2buf_wmb_rd_en <= 1'b0;
  end else begin
  sc2buf_wmb_rd_en <= wmb_req_valid;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2buf_wmb_rd_addr <= {8{1'b0}};
  end else begin
  if ((wmb_req_valid) == 1'b1) begin
    sc2buf_wmb_rd_addr <= wmb_req_addr;
  // VCS coverage off
  end else if ((wmb_req_valid) == 1'b0) begin
  end else begin
    sc2buf_wmb_rd_addr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_51x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_req_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_pipe_valid_d1 <= 1'b0;
  end else begin
  wmb_pipe_valid_d1 <= wmb_pipe_valid;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_req_ori_element_d1 <= {7{1'b0}};
  end else begin
  if ((wmb_pipe_valid) == 1'b1) begin
    wmb_req_ori_element_d1 <= wmb_req_ori_element;
  // VCS coverage off
  end else if ((wmb_pipe_valid) == 1'b0) begin
  end else begin
    wmb_req_ori_element_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_52x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_pipe_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_req_element_d1 <= {8{1'b0}};
  end else begin
  if ((wmb_pipe_valid) == 1'b1) begin
    wmb_req_element_d1 <= wmb_req_element;
  // VCS coverage off
  end else if ((wmb_pipe_valid) == 1'b0) begin
  end else begin
    wmb_req_element_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_53x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_pipe_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_req_rls_entries_d1 <= {9{1'b0}};
  end else begin
  if ((wmb_pipe_valid & wl_wt_release & is_stripe_end) == 1'b1) begin
    wmb_req_rls_entries_d1 <= wmb_rls_entries;
  // VCS coverage off
  end else if ((wmb_pipe_valid & wl_wt_release & is_stripe_end) == 1'b0) begin
  end else begin
    wmb_req_rls_entries_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_54x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_pipe_valid & wl_wt_release & is_stripe_end))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_req_stripe_end_d1 <= 1'b0;
  end else begin
  if ((wmb_pipe_valid) == 1'b1) begin
    wmb_req_stripe_end_d1 <= is_stripe_end;
  // VCS coverage off
  end else if ((wmb_pipe_valid) == 1'b0) begin
  end else begin
    wmb_req_stripe_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_55x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_pipe_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_req_channel_end_d1 <= 1'b0;
  end else begin
  if ((wmb_pipe_valid) == 1'b1) begin
    wmb_req_channel_end_d1 <= wl_channel_end & is_stripe_end;
  // VCS coverage off
  end else if ((wmb_pipe_valid) == 1'b0) begin
  end else begin
    wmb_req_channel_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_56x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_pipe_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_req_group_end_d1 <= 1'b0;
  end else begin
  if ((wmb_pipe_valid) == 1'b1) begin
    wmb_req_group_end_d1 <= wl_group_end & is_stripe_end;
  // VCS coverage off
  end else if ((wmb_pipe_valid) == 1'b0) begin
  end else begin
    wmb_req_group_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_57x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_pipe_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_req_rls_d1 <= 1'b0;
  end else begin
  if ((wmb_pipe_valid) == 1'b1) begin
    wmb_req_rls_d1 <= wl_wt_release & is_stripe_end;
  // VCS coverage off
  end else if ((wmb_pipe_valid) == 1'b0) begin
  end else begin
    wmb_req_rls_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_58x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_pipe_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_req_dual_d1 <= 1'b0;
  end else begin
  if ((wmb_pipe_valid) == 1'b1) begin
    wmb_req_dual_d1 <= wmb_req_dual;
  // VCS coverage off
  end else if ((wmb_pipe_valid) == 1'b0) begin
  end else begin
    wmb_req_dual_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_59x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_pipe_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_req_cur_sub_h_d1 <= {2{1'b0}};
  end else begin
  if ((wmb_pipe_valid) == 1'b1) begin
    wmb_req_cur_sub_h_d1 <= wl_cur_sub_h;
  // VCS coverage off
  end else if ((wmb_pipe_valid) == 1'b0) begin
  end else begin
    wmb_req_cur_sub_h_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_60x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_pipe_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
///// sideband pipeline for wmb read                     /////
//////////////////////////////////////////////////////////////
assign wmb_req_pipe_pvld = wmb_pipe_valid_d1;

assign wmb_req_d1_stripe_end = wmb_req_stripe_end_d1;
assign wmb_req_d1_channel_end = wmb_req_channel_end_d1;
assign wmb_req_d1_group_end =  wmb_req_group_end_d1;
assign wmb_req_d1_rls = wmb_req_rls_d1;
assign wmb_req_d1_dual = wmb_req_dual_d1;
assign wmb_req_d1_cur_sub_h = wmb_req_cur_sub_h_d1;
assign wmb_req_d1_element = wmb_req_element_d1;
assign wmb_req_d1_ori_element = wmb_req_ori_element_d1;
assign wmb_req_d1_rls_entries = wmb_req_rls_entries_d1;


// PKT_PACK_WIRE( csc_wmb_req_pkg ,  wmb_req_d1_ ,  wmb_req_pipe_pd )
assign       wmb_req_pipe_pd[6:0] =     wmb_req_d1_ori_element[6:0];
assign       wmb_req_pipe_pd[14:7] =     wmb_req_d1_element[7:0];
assign       wmb_req_pipe_pd[23:15] =     wmb_req_d1_rls_entries[8:0];
assign       wmb_req_pipe_pd[24] =     wmb_req_d1_stripe_end ;
assign       wmb_req_pipe_pd[25] =     wmb_req_d1_channel_end ;
assign       wmb_req_pipe_pd[26] =     wmb_req_d1_group_end ;
assign       wmb_req_pipe_pd[27] =     wmb_req_d1_rls ;
assign       wmb_req_pipe_pd[28] =     wmb_req_d1_dual ;
assign       wmb_req_pipe_pd[30:29] =     wmb_req_d1_cur_sub_h[1:0];

assign wmb_rsp_pipe_pvld_d0 = wmb_req_pipe_pvld;
assign wmb_rsp_pipe_pd_d0 = wmb_req_pipe_pd;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_rsp_pipe_pvld_d1 <= 1'b0;
  end else begin
  wmb_rsp_pipe_pvld_d1 <= wmb_rsp_pipe_pvld_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_rsp_pipe_pd_d1 <= {31{1'b0}};
  end else begin
  if ((wmb_rsp_pipe_pvld_d0) == 1'b1) begin
    wmb_rsp_pipe_pd_d1 <= wmb_rsp_pipe_pd_d0;
  // VCS coverage off
  end else if ((wmb_rsp_pipe_pvld_d0) == 1'b0) begin
  end else begin
    wmb_rsp_pipe_pd_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_61x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_rsp_pipe_pvld_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_rsp_pipe_pvld_d2 <= 1'b0;
  end else begin
  wmb_rsp_pipe_pvld_d2 <= wmb_rsp_pipe_pvld_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_rsp_pipe_pd_d2 <= {31{1'b0}};
  end else begin
  if ((wmb_rsp_pipe_pvld_d1) == 1'b1) begin
    wmb_rsp_pipe_pd_d2 <= wmb_rsp_pipe_pd_d1;
  // VCS coverage off
  end else if ((wmb_rsp_pipe_pvld_d1) == 1'b0) begin
  end else begin
    wmb_rsp_pipe_pd_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_62x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_rsp_pipe_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_rsp_pipe_pvld_d3 <= 1'b0;
  end else begin
  wmb_rsp_pipe_pvld_d3 <= wmb_rsp_pipe_pvld_d2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_rsp_pipe_pd_d3 <= {31{1'b0}};
  end else begin
  if ((wmb_rsp_pipe_pvld_d2) == 1'b1) begin
    wmb_rsp_pipe_pd_d3 <= wmb_rsp_pipe_pd_d2;
  // VCS coverage off
  end else if ((wmb_rsp_pipe_pvld_d2) == 1'b0) begin
  end else begin
    wmb_rsp_pipe_pd_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_63x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_rsp_pipe_pvld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_rsp_pipe_pvld_d4 <= 1'b0;
  end else begin
  wmb_rsp_pipe_pvld_d4 <= wmb_rsp_pipe_pvld_d3;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_rsp_pipe_pd_d4 <= {31{1'b0}};
  end else begin
  if ((wmb_rsp_pipe_pvld_d3) == 1'b1) begin
    wmb_rsp_pipe_pd_d4 <= wmb_rsp_pipe_pd_d3;
  // VCS coverage off
  end else if ((wmb_rsp_pipe_pvld_d3) == 1'b0) begin
  end else begin
    wmb_rsp_pipe_pd_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_64x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_rsp_pipe_pvld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_rsp_pipe_pvld_d5 <= 1'b0;
  end else begin
  wmb_rsp_pipe_pvld_d5 <= wmb_rsp_pipe_pvld_d4;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_rsp_pipe_pd_d5 <= {31{1'b0}};
  end else begin
  if ((wmb_rsp_pipe_pvld_d4) == 1'b1) begin
    wmb_rsp_pipe_pd_d5 <= wmb_rsp_pipe_pd_d4;
  // VCS coverage off
  end else if ((wmb_rsp_pipe_pvld_d4) == 1'b0) begin
  end else begin
    wmb_rsp_pipe_pd_d5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_65x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_rsp_pipe_pvld_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_rsp_pipe_pvld_d6 <= 1'b0;
  end else begin
  wmb_rsp_pipe_pvld_d6 <= wmb_rsp_pipe_pvld_d5;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_rsp_pipe_pd_d6 <= {31{1'b0}};
  end else begin
  if ((wmb_rsp_pipe_pvld_d5) == 1'b1) begin
    wmb_rsp_pipe_pd_d6 <= wmb_rsp_pipe_pd_d5;
  // VCS coverage off
  end else if ((wmb_rsp_pipe_pvld_d5) == 1'b0) begin
  end else begin
    wmb_rsp_pipe_pd_d6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_66x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_rsp_pipe_pvld_d5))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign wmb_rsp_pipe_pvld = wmb_rsp_pipe_pvld_d6;
assign wmb_rsp_pipe_pd = wmb_rsp_pipe_pd_d6;


//////////////////////////////////////////////////////////////
///// wmb data process                                   /////
//////////////////////////////////////////////////////////////


// PKT_UNPACK_WIRE( csc_wmb_req_pkg ,  wmb_rsp_ ,  wmb_rsp_pipe_pd )
assign        wmb_rsp_ori_element[6:0] =     wmb_rsp_pipe_pd[6:0];
assign        wmb_rsp_element[7:0] =     wmb_rsp_pipe_pd[14:7];
assign        wmb_rsp_rls_entries[8:0] =     wmb_rsp_pipe_pd[23:15];
assign         wmb_rsp_stripe_end  =     wmb_rsp_pipe_pd[24];
assign         wmb_rsp_channel_end  =     wmb_rsp_pipe_pd[25];
assign         wmb_rsp_group_end  =     wmb_rsp_pipe_pd[26];
assign         wmb_rsp_rls  =     wmb_rsp_pipe_pd[27];
assign         wmb_rsp_dual  =     wmb_rsp_pipe_pd[28];
assign        wmb_rsp_cur_sub_h[1:0] =     wmb_rsp_pipe_pd[30:29];

//////////////////////////////////// wmb remain counter ////////////////////////////////////

always @(
  sc2buf_wmb_rd_valid
  ) begin
    wmb_rsp_bit_remain_add = sc2buf_wmb_rd_valid ? 11'h400 : 11'h0;
end

always @(
  wmb_rsp_pipe_pvld
  or wmb_rsp_element
  ) begin
    wmb_rsp_bit_remain_sub = wmb_rsp_pipe_pvld ? wmb_rsp_element : 8'b0;
end

always @(
  layer_st
  or wmb_rsp_channel_end
  or wmb_rsp_group_end
  or wmb_rsp_bit_remain_last
  or wmb_rsp_bit_remain
  or wmb_rsp_bit_remain_add
  or wmb_rsp_bit_remain_sub
  ) begin
    {mon_wmb_rsp_bit_remain_w,
     wmb_rsp_bit_remain_w} = (layer_st) ? 11'b0 :
                             (wmb_rsp_channel_end & ~wmb_rsp_group_end) ? {2'b0, wmb_rsp_bit_remain_last} :
                             wmb_rsp_bit_remain + wmb_rsp_bit_remain_add - wmb_rsp_bit_remain_sub;
end

always @(
  layer_st
  or wmb_rsp_pipe_pvld
  or wmb_rsp_group_end
  or is_compressed_d1
  ) begin
    wmb_rsp_bit_remain_last_reg_en = layer_st | (wmb_rsp_pipe_pvld & wmb_rsp_group_end & is_compressed_d1);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_rsp_bit_remain <= {10{1'b0}};
  end else begin
  if ((layer_st | (wmb_rsp_pipe_pvld & is_compressed_d1)) == 1'b1) begin
    wmb_rsp_bit_remain <= wmb_rsp_bit_remain_w;
  // VCS coverage off
  end else if ((layer_st | (wmb_rsp_pipe_pvld & is_compressed_d1)) == 1'b0) begin
  end else begin
    wmb_rsp_bit_remain <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_67x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | (wmb_rsp_pipe_pvld & is_compressed_d1)))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_rsp_bit_remain_last <= {10{1'b0}};
  end else begin
  if ((wmb_rsp_bit_remain_last_reg_en) == 1'b1) begin
    wmb_rsp_bit_remain_last <= wmb_rsp_bit_remain_w;
  // VCS coverage off
  end else if ((wmb_rsp_bit_remain_last_reg_en) == 1'b0) begin
  end else begin
    wmb_rsp_bit_remain_last <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_68x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_rsp_bit_remain_last_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wmb_rsp_bit_remain_w is overflow")      zzz_assert_never_69x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & is_compressed_d1 & (|mon_wmb_rsp_bit_remain_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////// generate element mask for both compressed and compressed case ////////////////////////////////////
//emask for element mask, NOT byte mask

always @(
  sc2buf_wmb_rd_valid
  or sc2buf_wmb_rd_data
  or wmb_rsp_bit_remain
  ) begin
    wmb_emask_rd_ls = ~sc2buf_wmb_rd_valid ? 128'b0 :
                      (sc2buf_wmb_rd_data[127:0] << wmb_rsp_bit_remain[6:0]);
end

always @(
  wmb_emask_rd_ls
  or wmb_emask_remain
  or is_compressed_d1
  ) begin
    wmb_rsp_emask_in = (wmb_emask_rd_ls | wmb_emask_remain[127:0] | {128{~is_compressed_d1}});
end

always @(
  wmb_rsp_element
  ) begin
    wmb_rsp_vld_s = ~({64{1'b1}} << wmb_rsp_element);
    wmb_rsp_vld_d = ~({64{1'b1}} << wmb_rsp_element[7:1]);
end

always @(
  wmb_rsp_emask_in
  or wmb_rsp_element
  ) begin
    {mon_wmb_rsp_emask_in_hi[63:0],
     wmb_rsp_emask_in_hi} = ((wmb_rsp_emask_in) >> wmb_rsp_element[7:1]);
end

always @(
  wmb_rsp_dual
  or wmb_rsp_emask_in_hi
  or wmb_rsp_emask_in
  or wmb_rsp_vld_d
  or wmb_rsp_vld_s
  ) begin
    wmb_rsp_emask = (wmb_rsp_dual) ? {wmb_rsp_emask_in_hi, wmb_rsp_emask_in[63:0]} & {2{wmb_rsp_vld_d}} :
                    {64'b0, (wmb_rsp_emask_in[63:0] & wmb_rsp_vld_s)};
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_req_emask <= {128{1'b0}};
  end else begin
  if ((wmb_rsp_pipe_pvld) == 1'b1) begin
    wt_req_emask <= wmb_rsp_emask;
  // VCS coverage off
  end else if ((wmb_rsp_pipe_pvld) == 1'b0) begin
  end else begin
    wt_req_emask <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_70x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_rsp_pipe_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////// generate local remain masks ////////////////////////////////////

always @(
  wmb_rsp_element
  or wmb_rsp_bit_remain
  ) begin
    {mon_wmb_shift_remain,
     wmb_shift_remain} = wmb_rsp_element - wmb_rsp_bit_remain[6:0];
end

always @(
  sc2buf_wmb_rd_data
  or wmb_shift_remain
  ) begin
    wmb_emask_rd_rs = (sc2buf_wmb_rd_data >> wmb_shift_remain);
end

always @(
  wmb_emask_remain
  or wmb_rsp_element
  ) begin
    wmb_emask_remain_rs = (wmb_emask_remain >> wmb_rsp_element);
end

always @(
  layer_st
  or wmb_rsp_channel_end
  or wmb_rsp_group_end
  or wmb_emask_remain_last
  or sc2buf_wmb_rd_valid
  or wmb_emask_rd_rs
  or wmb_emask_remain_rs
  ) begin
    wmb_emask_remain_w = layer_st ? 1024'b0 :
                         (wmb_rsp_channel_end & ~wmb_rsp_group_end) ? wmb_emask_remain_last :
                         sc2buf_wmb_rd_valid ? wmb_emask_rd_rs :
                         wmb_emask_remain_rs;
end

always @(
  layer_st
  or wmb_rsp_pipe_pvld
  or is_compressed_d1
  ) begin
    wmb_emask_remain_reg_en = layer_st | (wmb_rsp_pipe_pvld & is_compressed_d1);
end

always @(
  layer_st
  or wmb_rsp_pipe_pvld
  or wmb_rsp_group_end
  or is_compressed_d1
  ) begin
    wmb_emask_remain_last_reg_en = layer_st | (wmb_rsp_pipe_pvld & wmb_rsp_group_end & is_compressed_d1);
end

always @(
  wmb_rsp_ori_element
  ) begin
    wmb_rsp_ori_sft_3 = {wmb_rsp_ori_element[4:0], 1'b0} + wmb_rsp_ori_element[4:0];
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wmb_emask_remain <= {1024{1'b0}};
  end else begin
  if ((wmb_emask_remain_reg_en) == 1'b1) begin
    wmb_emask_remain <= wmb_emask_remain_w;
  // VCS coverage off
  end else if ((wmb_emask_remain_reg_en) == 1'b0) begin
  end else begin
    wmb_emask_remain <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_71x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_emask_remain_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wmb_emask_remain_last <= {1024{1'b0}};
  end else begin
  if ((wmb_emask_remain_last_reg_en) == 1'b1) begin
    wmb_emask_remain_last <= wmb_emask_remain_w;
  // VCS coverage off
  end else if ((wmb_emask_remain_last_reg_en) == 1'b0) begin
  end else begin
    wmb_emask_remain_last <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_72x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_emask_remain_last_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wmb_shift_remain is underflow!")      zzz_assert_never_73x (nvdla_core_clk, `ASSERT_RESET, (wmb_emask_remain_reg_en & mon_wmb_shift_remain & sc2buf_wmb_rd_valid)); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////// registers for pipeline ////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_req_pipe_valid <= 1'b0;
  end else begin
  wt_req_pipe_valid <= wmb_rsp_pipe_pvld;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_req_ori_element <= {7{1'b0}};
  end else begin
  if ((wmb_rsp_pipe_pvld) == 1'b1) begin
    wt_req_ori_element <= wmb_rsp_ori_element;
  // VCS coverage off
  end else if ((wmb_rsp_pipe_pvld) == 1'b0) begin
  end else begin
    wt_req_ori_element <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_74x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_rsp_pipe_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_stripe_end <= 1'b0;
  end else begin
  if ((wmb_rsp_pipe_pvld) == 1'b1) begin
    wt_req_stripe_end <= wmb_rsp_stripe_end;
  // VCS coverage off
  end else if ((wmb_rsp_pipe_pvld) == 1'b0) begin
  end else begin
    wt_req_stripe_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_75x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_rsp_pipe_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_channel_end <= 1'b0;
  end else begin
  if ((wmb_rsp_pipe_pvld) == 1'b1) begin
    wt_req_channel_end <= wmb_rsp_channel_end;
  // VCS coverage off
  end else if ((wmb_rsp_pipe_pvld) == 1'b0) begin
  end else begin
    wt_req_channel_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_76x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_rsp_pipe_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_group_end <= 1'b0;
  end else begin
  if ((wmb_rsp_pipe_pvld) == 1'b1) begin
    wt_req_group_end <= wmb_rsp_group_end;
  // VCS coverage off
  end else if ((wmb_rsp_pipe_pvld) == 1'b0) begin
  end else begin
    wt_req_group_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_77x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_rsp_pipe_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_rls <= 1'b0;
  end else begin
  if ((wmb_rsp_pipe_pvld) == 1'b1) begin
    wt_req_rls <= wmb_rsp_rls;
  // VCS coverage off
  end else if ((wmb_rsp_pipe_pvld) == 1'b0) begin
  end else begin
    wt_req_rls <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_78x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_rsp_pipe_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_wmb_rls_entries <= {9{1'b0}};
  end else begin
  if ((wmb_rsp_pipe_pvld) == 1'b1) begin
    wt_req_wmb_rls_entries <= wmb_rsp_rls_entries;
  // VCS coverage off
  end else if ((wmb_rsp_pipe_pvld) == 1'b0) begin
  end else begin
    wt_req_wmb_rls_entries <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_79x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_rsp_pipe_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_dual <= 1'b0;
  end else begin
  if ((wmb_rsp_pipe_pvld) == 1'b1) begin
    wt_req_dual <= wmb_rsp_dual;
  // VCS coverage off
  end else if ((wmb_rsp_pipe_pvld) == 1'b0) begin
  end else begin
    wt_req_dual <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_80x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_rsp_pipe_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_cur_sub_h <= {2{1'b0}};
  end else begin
  if ((wmb_rsp_pipe_pvld) == 1'b1) begin
    wt_req_cur_sub_h <= wmb_rsp_cur_sub_h;
  // VCS coverage off
  end else if ((wmb_rsp_pipe_pvld) == 1'b0) begin
  end else begin
    wt_req_cur_sub_h <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_81x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_rsp_pipe_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_ori_sft_3 <= {7{1'b0}};
  end else begin
  if ((wmb_rsp_pipe_pvld) == 1'b1) begin
    wt_req_ori_sft_3 <= wmb_rsp_ori_sft_3;
  // VCS coverage off
  end else if ((wmb_rsp_pipe_pvld) == 1'b0) begin
  end else begin
    wt_req_ori_sft_3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_82x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wmb_rsp_pipe_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
///// weight data request generate                       /////
//////////////////////////////////////////////////////////////

//////////////////////////////////// generate mask sum ////////////////////////////////////

////CAUSION! wt_req_bmask is byte mask, not elemnet mask!////
always @(
  is_int8_d1
  or wt_req_emask
  ) begin
    wt_req_bmask = is_int8_d1 ? wt_req_emask :
                  {{2{wt_req_emask[63]}}, {2{wt_req_emask[62]}}, {2{wt_req_emask[61]}}, {2{wt_req_emask[60]}}, {2{wt_req_emask[59]}}, {2{wt_req_emask[58]}}, {2{wt_req_emask[57]}}, {2{wt_req_emask[56]}}, {2{wt_req_emask[55]}}, {2{wt_req_emask[54]}}, {2{wt_req_emask[53]}}, {2{wt_req_emask[52]}}, {2{wt_req_emask[51]}}, {2{wt_req_emask[50]}}, {2{wt_req_emask[49]}}, {2{wt_req_emask[48]}}, {2{wt_req_emask[47]}}, {2{wt_req_emask[46]}}, {2{wt_req_emask[45]}}, {2{wt_req_emask[44]}}, {2{wt_req_emask[43]}}, {2{wt_req_emask[42]}}, {2{wt_req_emask[41]}}, {2{wt_req_emask[40]}}, {2{wt_req_emask[39]}}, {2{wt_req_emask[38]}}, {2{wt_req_emask[37]}}, {2{wt_req_emask[36]}}, {2{wt_req_emask[35]}}, {2{wt_req_emask[34]}}, {2{wt_req_emask[33]}}, {2{wt_req_emask[32]}}, {2{wt_req_emask[31]}}, {2{wt_req_emask[30]}}, {2{wt_req_emask[29]}}, {2{wt_req_emask[28]}}, {2{wt_req_emask[27]}}, {2{wt_req_emask[26]}}, {2{wt_req_emask[25]}}, {2{wt_req_emask[24]}}, {2{wt_req_emask[23]}}, {2{wt_req_emask[22]}}, {2{wt_req_emask[21]}}, {2{wt_req_emask[20]}}, {2{wt_req_emask[19]}}, {2{wt_req_emask[18]}}, {2{wt_req_emask[17]}}, {2{wt_req_emask[16]}}, {2{wt_req_emask[15]}}, {2{wt_req_emask[14]}}, {2{wt_req_emask[13]}}, {2{wt_req_emask[12]}}, {2{wt_req_emask[11]}}, {2{wt_req_emask[10]}}, {2{wt_req_emask[9]}}, {2{wt_req_emask[8]}}, {2{wt_req_emask[7]}}, {2{wt_req_emask[6]}}, {2{wt_req_emask[5]}}, {2{wt_req_emask[4]}}, {2{wt_req_emask[3]}}, {2{wt_req_emask[2]}}, {2{wt_req_emask[1]}}, {2{wt_req_emask[0]}}};
end

always @(
  wt_req_bmask
  ) begin
    wt_req_bytes = wt_req_bmask[0] + wt_req_bmask[1] + wt_req_bmask[2] + wt_req_bmask[3] + wt_req_bmask[4] + wt_req_bmask[5] + wt_req_bmask[6] + wt_req_bmask[7] + wt_req_bmask[8] + wt_req_bmask[9] + wt_req_bmask[10] + wt_req_bmask[11] + wt_req_bmask[12] + wt_req_bmask[13] + wt_req_bmask[14] + wt_req_bmask[15] + wt_req_bmask[16] + wt_req_bmask[17] + wt_req_bmask[18] + wt_req_bmask[19] + wt_req_bmask[20] + wt_req_bmask[21] + wt_req_bmask[22] + wt_req_bmask[23] + wt_req_bmask[24] + wt_req_bmask[25] + wt_req_bmask[26] + wt_req_bmask[27] + wt_req_bmask[28] + wt_req_bmask[29] + wt_req_bmask[30] + wt_req_bmask[31] + wt_req_bmask[32] + wt_req_bmask[33] + wt_req_bmask[34] + wt_req_bmask[35] + wt_req_bmask[36] + wt_req_bmask[37] + wt_req_bmask[38] + wt_req_bmask[39] + wt_req_bmask[40] + wt_req_bmask[41] + wt_req_bmask[42] + wt_req_bmask[43] + wt_req_bmask[44] + wt_req_bmask[45] + wt_req_bmask[46] + wt_req_bmask[47] + wt_req_bmask[48] + wt_req_bmask[49] + wt_req_bmask[50] + wt_req_bmask[51] + wt_req_bmask[52] + wt_req_bmask[53] + wt_req_bmask[54] + wt_req_bmask[55] + wt_req_bmask[56] + wt_req_bmask[57] + wt_req_bmask[58] + wt_req_bmask[59] + wt_req_bmask[60] + wt_req_bmask[61] + wt_req_bmask[62] + wt_req_bmask[63] + wt_req_bmask[64] + wt_req_bmask[65] + wt_req_bmask[66] + wt_req_bmask[67] + wt_req_bmask[68] + wt_req_bmask[69] + wt_req_bmask[70] + wt_req_bmask[71] + wt_req_bmask[72] + wt_req_bmask[73] + wt_req_bmask[74] + wt_req_bmask[75] + wt_req_bmask[76] + wt_req_bmask[77] + wt_req_bmask[78] + wt_req_bmask[79] + wt_req_bmask[80] + wt_req_bmask[81] + wt_req_bmask[82] + wt_req_bmask[83] + wt_req_bmask[84] + wt_req_bmask[85] + wt_req_bmask[86] + wt_req_bmask[87] + wt_req_bmask[88] + wt_req_bmask[89] + wt_req_bmask[90] + wt_req_bmask[91] + wt_req_bmask[92] + wt_req_bmask[93] + wt_req_bmask[94] + wt_req_bmask[95] + wt_req_bmask[96] + wt_req_bmask[97] + wt_req_bmask[98] + wt_req_bmask[99] + wt_req_bmask[100] + wt_req_bmask[101] + wt_req_bmask[102] + wt_req_bmask[103] + wt_req_bmask[104] + wt_req_bmask[105] + wt_req_bmask[106] + wt_req_bmask[107] + wt_req_bmask[108] + wt_req_bmask[109] + wt_req_bmask[110] + wt_req_bmask[111] + wt_req_bmask[112] + wt_req_bmask[113] + wt_req_bmask[114] + wt_req_bmask[115] + wt_req_bmask[116] + wt_req_bmask[117] + wt_req_bmask[118] + wt_req_bmask[119] + wt_req_bmask[120] + wt_req_bmask[121] + wt_req_bmask[122] + wt_req_bmask[123] + wt_req_bmask[124] + wt_req_bmask[125] + wt_req_bmask[126] + wt_req_bmask[127];
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
  nv_assert_never #(0,0,"Error! wt_req_bytes is overflow")      zzz_assert_never_83x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en && (wt_req_bytes > 8'h80))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////// generate element mask for decoding////////////////////////////////////


//valid bit for each sub h line
always @(
  wt_req_ori_element
  ) begin
    wt_req_vld_bit = ~({64{1'b1}} << wt_req_ori_element);
end

//valid bit to select sub h line
always @(
  wt_req_cur_sub_h
  ) begin
    sub_h_mask_1 = (wt_req_cur_sub_h >= 2'h1) ? 64'hffff_ffff : 64'h0;
    sub_h_mask_2 = (wt_req_cur_sub_h >= 2'h2) ? 64'hffff : 64'h0;
    sub_h_mask_3 = (wt_req_cur_sub_h == 2'h3) ? 64'hffff : 64'h0;
end

//element number to be shifted
always @(
  wt_req_ori_element
  ) begin
    wt_req_ori_sft_1 = wt_req_ori_element;
    wt_req_ori_sft_2 = {wt_req_ori_element[5:0], 1'b0};
end

always @(
  wt_req_emask
  or wt_req_vld_bit
  ) begin
    wt_req_emask_p0 = wt_req_emask[63:0] & wt_req_vld_bit;
end

always @(
  wt_req_emask
  or wt_req_ori_sft_1
  or wt_req_vld_bit
  or sub_h_mask_1
  or wt_req_ori_sft_2
  or sub_h_mask_2
  or wt_req_ori_sft_3
  or sub_h_mask_3
  ) begin
    {mon_wt_req_emask_p1[31:0],
     wt_req_emask_p1} = (wt_req_emask[63:0] >> wt_req_ori_sft_1) & wt_req_vld_bit & sub_h_mask_1;
    {mon_wt_req_emask_p2[47:0],
     wt_req_emask_p2} = (wt_req_emask[63:0] >> wt_req_ori_sft_2) & wt_req_vld_bit & sub_h_mask_2;
    {mon_wt_req_emask_p3[47:0],
     wt_req_emask_p3} = (wt_req_emask[63:0] >> wt_req_ori_sft_3) & wt_req_vld_bit & sub_h_mask_3;
end

always @(
  wt_req_dual
  or wt_req_emask
  ) begin
    wt_req_emask_hi = wt_req_dual ? wt_req_emask[127:64] : 64'b0;
end

always @(
  wt_req_emask_hi
  or wt_req_vld_bit
  ) begin
    wt_req_emask_p4 = wt_req_emask_hi & wt_req_vld_bit;
end

always @(
  wt_req_emask_hi
  or wt_req_ori_sft_1
  or wt_req_vld_bit
  or sub_h_mask_1
  or wt_req_ori_sft_2
  or sub_h_mask_2
  or wt_req_ori_sft_3
  or sub_h_mask_3
  ) begin
    {mon_wt_req_emask_p5[31:0],
     wt_req_emask_p5} = (wt_req_emask_hi >> wt_req_ori_sft_1) & wt_req_vld_bit & sub_h_mask_1;
    {mon_wt_req_emask_p6[47:0],
     wt_req_emask_p6} = (wt_req_emask_hi >> wt_req_ori_sft_2) & wt_req_vld_bit & sub_h_mask_2;
    {mon_wt_req_emask_p7[47:0],
     wt_req_emask_p7} = (wt_req_emask_hi >> wt_req_ori_sft_3) & wt_req_vld_bit & sub_h_mask_3;
end

//Caution! Must reset wt_req_mask to all zero when layer started
//other width wt_req_mask_en may gate wt_rsp_mask_d1_w improperly!
always @(
  layer_st
  or sub_h_total
  or wt_req_emask_p4
  or wt_req_emask_p0
  or wt_req_emask_p5
  or wt_req_emask_p1
  or wt_req_emask_p7
  or wt_req_emask_p6
  or wt_req_emask_p3
  or wt_req_emask_p2
  ) begin
    wt_req_mask_w = layer_st ? 128'b0 :
                    (sub_h_total == 3'h1) ? {wt_req_emask_p4, wt_req_emask_p0} :
                    (sub_h_total == 3'h2) ? {wt_req_emask_p5, wt_req_emask_p4[31:0], wt_req_emask_p1, wt_req_emask_p0[31:0]} :
                    {wt_req_emask_p7, wt_req_emask_p6, wt_req_emask_p5[15:0], wt_req_emask_p4[15:0], wt_req_emask_p3, wt_req_emask_p2, wt_req_emask_p1[15:0], wt_req_emask_p0[15:0]};
end

always @(
  wt_req_pipe_valid
  or wt_req_mask_w
  or wt_req_mask_d1
  ) begin
    wt_req_mask_en = wt_req_pipe_valid & (wt_req_mask_w != wt_req_mask_d1);
end

//////////////////////////////////// generate weight read request ////////////////////////////////////
always @(
  wt_req_pipe_valid
  or wt_byte_avl
  or wt_req_bytes
  ) begin
    wt_req_valid = wt_req_pipe_valid & (wt_byte_avl < wt_req_bytes);
end

//////////////////////////////////// generate weight avaliable bytes ////////////////////////////////////

always @(
  wt_req_valid
  ) begin
    wt_byte_avl_add = ~wt_req_valid ? 8'b0 :
                      8'h80;
end

always @(
  wt_req_bytes
  ) begin
    wt_byte_avl_sub = wt_req_bytes;
end

always @(
  wt_byte_avl
  or wt_byte_avl_add
  or wt_byte_avl_sub
  ) begin
    {mon_wt_byte_avl_inc,
     wt_byte_avl_inc} = wt_byte_avl + wt_byte_avl_add - wt_byte_avl_sub;
end

always @(
  layer_st
  or wt_req_group_end
  or wt_req_channel_end
  or wt_byte_avl_last
  or wt_byte_avl_inc
  ) begin
    wt_byte_avl_w = layer_st ? 8'b0 :
                    ( ~wt_req_group_end & wt_req_channel_end) ? wt_byte_avl_last :
                    wt_byte_avl_inc;
end

always @(
  layer_st
  or wt_req_pipe_valid
  or wt_req_stripe_end
  or wt_req_group_end
  ) begin
    wt_byte_last_reg_en = layer_st | (wt_req_pipe_valid & wt_req_stripe_end & wt_req_group_end);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_byte_avl <= {8{1'b0}};
  end else begin
  if ((layer_st | wt_req_pipe_valid) == 1'b1) begin
    wt_byte_avl <= wt_byte_avl_w;
  // VCS coverage off
  end else if ((layer_st | wt_req_pipe_valid) == 1'b0) begin
  end else begin
    wt_byte_avl <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_84x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | wt_req_pipe_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_byte_avl_last <= {8{1'b0}};
  end else begin
  if ((wt_byte_last_reg_en) == 1'b1) begin
    wt_byte_avl_last <= wt_byte_avl_w;
  // VCS coverage off
  end else if ((wt_byte_last_reg_en) == 1'b0) begin
  end else begin
    wt_byte_avl_last <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_85x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_byte_last_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wt_byte_avl_inc is overflow!")      zzz_assert_never_86x (nvdla_core_clk, `ASSERT_RESET, (wt_req_pipe_valid & mon_wt_byte_avl_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wt_byte_avl_w!")      zzz_assert_never_87x (nvdla_core_clk, `ASSERT_RESET, (wt_req_pipe_valid & (wt_byte_avl_w > 8'h80))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////// generate weight read address ////////////////////////////////////

always @(
  wt_req_addr
  ) begin
    {mon_wt_req_addr_inc,
     wt_req_addr_inc} = wt_req_addr + 1'b1;
end

always @(
  wt_req_addr_inc
  or weight_bank
  ) begin
    is_wr_req_addr_wrap = (wt_req_addr_inc == {weight_bank, 8'b0});
end

always @(
  is_wr_req_addr_wrap
  or wt_req_addr_inc
  ) begin
    wt_req_addr_inc_wrap = is_wr_req_addr_wrap ? 12'b0 : wt_req_addr_inc;
end

always @(
  addr_init
  or wt_entry_st_w
  or wt_req_channel_end
  or wt_req_group_end
  or wt_req_addr_last
  or wt_req_valid
  or wt_req_addr_inc_wrap
  or wt_req_addr
  ) begin
    wt_req_addr_w = addr_init ? wt_entry_st_w :
                    (wt_req_channel_end & ~wt_req_group_end) ? wt_req_addr_last :
                    wt_req_valid ? wt_req_addr_inc_wrap :
                    wt_req_addr;
end

always @(
  addr_init
  or wt_req_valid
  or wt_req_pipe_valid
  or wt_req_channel_end
  ) begin
    wt_req_addr_reg_en = addr_init | wt_req_valid | (wt_req_pipe_valid & wt_req_channel_end);
end

always @(
  addr_init
  or wt_req_pipe_valid
  or wt_req_group_end
  ) begin
    wt_req_addr_last_reg_en = addr_init | (wt_req_pipe_valid & wt_req_pipe_valid & wt_req_group_end);
end

always @(
  wt_req_addr
  or data_bank
  ) begin
    {mon_wt_req_addr_out,
     wt_req_addr_out} = wt_req_addr + {data_bank, 8'b0};
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_req_addr <= {12{1'b0}};
  end else begin
  if ((wt_req_addr_reg_en) == 1'b1) begin
    wt_req_addr <= wt_req_addr_w;
  // VCS coverage off
  end else if ((wt_req_addr_reg_en) == 1'b0) begin
  end else begin
    wt_req_addr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_88x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_addr_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_addr_last <= {12{1'b0}};
  end else begin
  if ((wt_req_addr_last_reg_en) == 1'b1) begin
    wt_req_addr_last <= wt_req_addr_w;
  // VCS coverage off
  end else if ((wt_req_addr_last_reg_en) == 1'b0) begin
  end else begin
    wt_req_addr_last <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_89x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_addr_last_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"wt_req_addr_out is overflow")      zzz_assert_never_90x (nvdla_core_clk, `ASSERT_RESET, (wt_req_valid & mon_wt_req_addr_out)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"wt_req_addr_out is out of range")      zzz_assert_never_91x (nvdla_core_clk, `ASSERT_RESET, (wt_req_valid & (wt_req_addr > {weight_bank, 8'b0}))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////// weight entries counter for release ////////////////////////////////////

always @(
  layer_st
  or wt_req_group_end
  or wt_req_channel_end
  or wt_rls_cnt_vld
  ) begin
    wt_rls_cnt_vld_w = (layer_st | wt_req_group_end) ? 1'b0 :
                       wt_req_channel_end ? 1'b1 :
                       wt_rls_cnt_vld;
end

always @(
  wt_rls_cnt
  ) begin
    {mon_wt_rls_cnt_inc,
     wt_rls_cnt_inc} = wt_rls_cnt + 1'b1;
end

always @(
  layer_st
  or wt_req_group_end
  or wt_rls_cnt_inc
  ) begin
    wt_rls_cnt_w = layer_st ? 12'b0 :
                   wt_req_group_end ? 12'b0 :
                   wt_rls_cnt_inc;
end

always @(
  layer_st
  or wt_req_pipe_valid
  or wt_req_group_end
  or wt_rls_cnt_vld
  or wt_req_valid
  ) begin
    wt_rls_cnt_reg_en = layer_st | (wt_req_pipe_valid & wt_req_group_end) | (~wt_rls_cnt_vld & wt_req_valid);
end

always @(
  wt_rls_cnt_vld
  or wt_req_valid
  or wt_rls_cnt
  or wt_rls_cnt_inc
  ) begin
    wt_rls_entries = (wt_rls_cnt_vld | ~wt_req_valid) ? wt_rls_cnt :
                     wt_rls_cnt_inc;
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_rls_cnt_vld <= 1'b0;
  end else begin
  wt_rls_cnt_vld <= wt_rls_cnt_vld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_rls_cnt <= {12{1'b0}};
  end else begin
  if ((wt_rls_cnt_reg_en) == 1'b1) begin
    wt_rls_cnt <= wt_rls_cnt_w;
  // VCS coverage off
  end else if ((wt_rls_cnt_reg_en) == 1'b0) begin
  end else begin
    wt_rls_cnt <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_92x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rls_cnt_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wt_rls_cnt_inc is overflow!")      zzz_assert_never_93x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en && mon_wt_rls_cnt_inc)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wt_rls_cnt_inc is out of range!")      zzz_assert_never_94x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en && (wt_rls_cnt > 3840))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////// send weight read request ////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2buf_wt_rd_en <= 1'b0;
  end else begin
  sc2buf_wt_rd_en <= wt_req_valid;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2buf_wt_rd_addr <= {12{1'b0}};
  end else begin
  if ((wt_req_valid) == 1'b1) begin
    sc2buf_wt_rd_addr <= wt_req_addr_out;
  // VCS coverage off
  end else if ((wt_req_valid) == 1'b0) begin
  end else begin
    sc2buf_wt_rd_addr <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_95x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_pipe_valid_d1 <= 1'b0;
  end else begin
  wt_req_pipe_valid_d1 <= wt_req_pipe_valid;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_req_stripe_end_d1 <= 1'b0;
  end else begin
  if ((wt_req_pipe_valid) == 1'b1) begin
    wt_req_stripe_end_d1 <= wt_req_stripe_end;
  // VCS coverage off
  end else if ((wt_req_pipe_valid) == 1'b0) begin
  end else begin
    wt_req_stripe_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_96x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_pipe_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_channel_end_d1 <= 1'b0;
  end else begin
  if ((wt_req_pipe_valid) == 1'b1) begin
    wt_req_channel_end_d1 <= wt_req_channel_end;
  // VCS coverage off
  end else if ((wt_req_pipe_valid) == 1'b0) begin
  end else begin
    wt_req_channel_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_97x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_pipe_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_group_end_d1 <= 1'b0;
  end else begin
  if ((wt_req_pipe_valid) == 1'b1) begin
    wt_req_group_end_d1 <= wt_req_group_end;
  // VCS coverage off
  end else if ((wt_req_pipe_valid) == 1'b0) begin
  end else begin
    wt_req_group_end_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_98x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_pipe_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_rls_d1 <= 1'b0;
  end else begin
  if ((wt_req_pipe_valid) == 1'b1) begin
    wt_req_rls_d1 <= wt_req_rls;
  // VCS coverage off
  end else if ((wt_req_pipe_valid) == 1'b0) begin
  end else begin
    wt_req_rls_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_99x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_pipe_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_bytes_d1 <= {8{1'b0}};
  end else begin
  if ((wt_req_pipe_valid) == 1'b1) begin
    wt_req_bytes_d1 <= wt_req_bytes;
  // VCS coverage off
  end else if ((wt_req_pipe_valid) == 1'b0) begin
  end else begin
    wt_req_bytes_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_100x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_pipe_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//Caution! Here wt_req_mask is still element mask
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_req_mask_d1 <= {128{1'b0}};
  end else begin
  if ((layer_st | wt_req_pipe_valid) == 1'b1) begin
    wt_req_mask_d1 <= wt_req_mask_w;
  // VCS coverage off
  end else if ((layer_st | wt_req_pipe_valid) == 1'b0) begin
  end else begin
    wt_req_mask_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_101x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(layer_st | wt_req_pipe_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_mask_en_d1 <= 1'b0;
  end else begin
  wt_req_mask_en_d1 <= wt_req_mask_en;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_req_wmb_rls_entries_d1 <= {9{1'b0}};
  end else begin
  if ((wt_req_pipe_valid) == 1'b1) begin
    wt_req_wmb_rls_entries_d1 <= wt_req_wmb_rls_entries;
  // VCS coverage off
  end else if ((wt_req_pipe_valid) == 1'b0) begin
  end else begin
    wt_req_wmb_rls_entries_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_102x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_pipe_valid))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_req_wt_rls_entries_d1 <= {12{1'b0}};
  end else begin
  if ((wt_req_pipe_valid & wt_req_rls) == 1'b1) begin
    wt_req_wt_rls_entries_d1 <= wt_rls_entries;
  // VCS coverage off
  end else if ((wt_req_pipe_valid & wt_req_rls) == 1'b0) begin
  end else begin
    wt_req_wt_rls_entries_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_103x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_req_pipe_valid & wt_req_rls))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
///// sideband pipeline for wmb read                     /////
//////////////////////////////////////////////////////////////
assign wt_req_pipe_pvld = wt_req_pipe_valid_d1;

assign wt_req_d1_stripe_end      = wt_req_stripe_end_d1;
assign wt_req_d1_channel_end     = wt_req_channel_end_d1;
assign wt_req_d1_group_end       = wt_req_group_end_d1;
assign wt_req_d1_rls             = wt_req_rls_d1;
assign wt_req_d1_bytes           = wt_req_bytes_d1;
assign wt_req_d1_wmb_rls_entries = wt_req_wmb_rls_entries_d1;
assign wt_req_d1_wt_rls_entries  = wt_req_wt_rls_entries_d1;


// PKT_PACK_WIRE( csc_wt_req_pkg ,  wt_req_d1_ ,  wt_req_pipe_pd )
assign       wt_req_pipe_pd[7:0] =     wt_req_d1_bytes[7:0];
assign       wt_req_pipe_pd[16:8] =     wt_req_d1_wmb_rls_entries[8:0];
assign       wt_req_pipe_pd[28:17] =     wt_req_d1_wt_rls_entries[11:0];
assign       wt_req_pipe_pd[29] =     wt_req_d1_stripe_end ;
assign       wt_req_pipe_pd[30] =     wt_req_d1_channel_end ;
assign       wt_req_pipe_pd[31] =     wt_req_d1_group_end ;
assign       wt_req_pipe_pd[32] =     wt_req_d1_rls ;

assign wt_rsp_pipe_pvld_d0 = wt_req_pipe_pvld;
assign wt_rsp_pipe_pd_d0 = wt_req_pipe_pd;
assign wt_rsp_mask_en_d0 = wt_req_mask_en_d1;
assign wt_rsp_mask_d0 = wt_req_mask_d1;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_rsp_pipe_pvld_d1 <= 1'b0;
  end else begin
  wt_rsp_pipe_pvld_d1 <= wt_rsp_pipe_pvld_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_rsp_pipe_pd_d1 <= {33{1'b0}};
  end else begin
  if ((wt_rsp_pipe_pvld_d0) == 1'b1) begin
    wt_rsp_pipe_pd_d1 <= wt_rsp_pipe_pd_d0;
  // VCS coverage off
  end else if ((wt_rsp_pipe_pvld_d0) == 1'b0) begin
  end else begin
    wt_rsp_pipe_pd_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_104x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rsp_pipe_pvld_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_rsp_mask_en_d1 <= 1'b0;
  end else begin
  wt_rsp_mask_en_d1 <= wt_rsp_mask_en_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_rsp_mask_d1 <= {128{1'b0}};
  end else begin
  if ((wt_rsp_mask_en_d0) == 1'b1) begin
    wt_rsp_mask_d1 <= wt_rsp_mask_d0;
  // VCS coverage off
  end else if ((wt_rsp_mask_en_d0) == 1'b0) begin
  end else begin
    wt_rsp_mask_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_105x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rsp_mask_en_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_rsp_pipe_pvld_d2 <= 1'b0;
  end else begin
  wt_rsp_pipe_pvld_d2 <= wt_rsp_pipe_pvld_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_rsp_pipe_pd_d2 <= {33{1'b0}};
  end else begin
  if ((wt_rsp_pipe_pvld_d1) == 1'b1) begin
    wt_rsp_pipe_pd_d2 <= wt_rsp_pipe_pd_d1;
  // VCS coverage off
  end else if ((wt_rsp_pipe_pvld_d1) == 1'b0) begin
  end else begin
    wt_rsp_pipe_pd_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_106x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rsp_pipe_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_rsp_mask_en_d2 <= 1'b0;
  end else begin
  wt_rsp_mask_en_d2 <= wt_rsp_mask_en_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_rsp_mask_d2 <= {128{1'b0}};
  end else begin
  if ((wt_rsp_mask_en_d1) == 1'b1) begin
    wt_rsp_mask_d2 <= wt_rsp_mask_d1;
  // VCS coverage off
  end else if ((wt_rsp_mask_en_d1) == 1'b0) begin
  end else begin
    wt_rsp_mask_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_107x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rsp_mask_en_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_rsp_pipe_pvld_d3 <= 1'b0;
  end else begin
  wt_rsp_pipe_pvld_d3 <= wt_rsp_pipe_pvld_d2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_rsp_pipe_pd_d3 <= {33{1'b0}};
  end else begin
  if ((wt_rsp_pipe_pvld_d2) == 1'b1) begin
    wt_rsp_pipe_pd_d3 <= wt_rsp_pipe_pd_d2;
  // VCS coverage off
  end else if ((wt_rsp_pipe_pvld_d2) == 1'b0) begin
  end else begin
    wt_rsp_pipe_pd_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_108x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rsp_pipe_pvld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_rsp_mask_en_d3 <= 1'b0;
  end else begin
  wt_rsp_mask_en_d3 <= wt_rsp_mask_en_d2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_rsp_mask_d3 <= {128{1'b0}};
  end else begin
  if ((wt_rsp_mask_en_d2) == 1'b1) begin
    wt_rsp_mask_d3 <= wt_rsp_mask_d2;
  // VCS coverage off
  end else if ((wt_rsp_mask_en_d2) == 1'b0) begin
  end else begin
    wt_rsp_mask_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_109x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rsp_mask_en_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_rsp_pipe_pvld_d4 <= 1'b0;
  end else begin
  wt_rsp_pipe_pvld_d4 <= wt_rsp_pipe_pvld_d3;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_rsp_pipe_pd_d4 <= {33{1'b0}};
  end else begin
  if ((wt_rsp_pipe_pvld_d3) == 1'b1) begin
    wt_rsp_pipe_pd_d4 <= wt_rsp_pipe_pd_d3;
  // VCS coverage off
  end else if ((wt_rsp_pipe_pvld_d3) == 1'b0) begin
  end else begin
    wt_rsp_pipe_pd_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_110x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rsp_pipe_pvld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_rsp_mask_en_d4 <= 1'b0;
  end else begin
  wt_rsp_mask_en_d4 <= wt_rsp_mask_en_d3;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_rsp_mask_d4 <= {128{1'b0}};
  end else begin
  if ((wt_rsp_mask_en_d3) == 1'b1) begin
    wt_rsp_mask_d4 <= wt_rsp_mask_d3;
  // VCS coverage off
  end else if ((wt_rsp_mask_en_d3) == 1'b0) begin
  end else begin
    wt_rsp_mask_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_111x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rsp_mask_en_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_rsp_pipe_pvld_d5 <= 1'b0;
  end else begin
  wt_rsp_pipe_pvld_d5 <= wt_rsp_pipe_pvld_d4;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_rsp_pipe_pd_d5 <= {33{1'b0}};
  end else begin
  if ((wt_rsp_pipe_pvld_d4) == 1'b1) begin
    wt_rsp_pipe_pd_d5 <= wt_rsp_pipe_pd_d4;
  // VCS coverage off
  end else if ((wt_rsp_pipe_pvld_d4) == 1'b0) begin
  end else begin
    wt_rsp_pipe_pd_d5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_112x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rsp_pipe_pvld_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_rsp_mask_en_d5 <= 1'b0;
  end else begin
  wt_rsp_mask_en_d5 <= wt_rsp_mask_en_d4;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_rsp_mask_d5 <= {128{1'b0}};
  end else begin
  if ((wt_rsp_mask_en_d4) == 1'b1) begin
    wt_rsp_mask_d5 <= wt_rsp_mask_d4;
  // VCS coverage off
  end else if ((wt_rsp_mask_en_d4) == 1'b0) begin
  end else begin
    wt_rsp_mask_d5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_113x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rsp_mask_en_d4))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_rsp_pipe_pvld_d6 <= 1'b0;
  end else begin
  wt_rsp_pipe_pvld_d6 <= wt_rsp_pipe_pvld_d5;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_rsp_pipe_pd_d6 <= {33{1'b0}};
  end else begin
  if ((wt_rsp_pipe_pvld_d5) == 1'b1) begin
    wt_rsp_pipe_pd_d6 <= wt_rsp_pipe_pd_d5;
  // VCS coverage off
  end else if ((wt_rsp_pipe_pvld_d5) == 1'b0) begin
  end else begin
    wt_rsp_pipe_pd_d6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_114x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rsp_pipe_pvld_d5))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_rsp_mask_en_d6 <= 1'b0;
  end else begin
  wt_rsp_mask_en_d6 <= wt_rsp_mask_en_d5;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_rsp_mask_d6 <= {128{1'b0}};
  end else begin
  if ((wt_rsp_mask_en_d5) == 1'b1) begin
    wt_rsp_mask_d6 <= wt_rsp_mask_d5;
  // VCS coverage off
  end else if ((wt_rsp_mask_en_d5) == 1'b0) begin
  end else begin
    wt_rsp_mask_d6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_115x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rsp_mask_en_d5))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign wt_rsp_pipe_pvld = wt_rsp_pipe_pvld_d6;
assign wt_rsp_pipe_pd = wt_rsp_pipe_pd_d6;

assign wt_rsp_mask_en = wt_rsp_mask_en_d6;
assign wt_rsp_mask = wt_rsp_mask_d6;


//////////////////////////////////////////////////////////////
///// weight data process                                /////
//////////////////////////////////////////////////////////////


// PKT_UNPACK_WIRE( csc_wt_req_pkg ,  wt_rsp_ ,  wt_rsp_pipe_pd )
assign        wt_rsp_bytes[7:0] =     wt_rsp_pipe_pd[7:0];
assign        wt_rsp_wmb_rls_entries[8:0] =     wt_rsp_pipe_pd[16:8];
assign        wt_rsp_wt_rls_entries[11:0] =     wt_rsp_pipe_pd[28:17];
assign         wt_rsp_stripe_end  =     wt_rsp_pipe_pd[29];
assign         wt_rsp_channel_end  =     wt_rsp_pipe_pd[30];
assign         wt_rsp_group_end  =     wt_rsp_pipe_pd[31];
assign         wt_rsp_rls  =     wt_rsp_pipe_pd[32];

//////////////////////////////////// generate byte mask for decoding ////////////////////////////////////

always @(
  is_int8_d1
  or wt_rsp_mask
  ) begin
    wt_rsp_mask_d1_w = is_int8_d1 ? wt_rsp_mask :
                       {{2{wt_rsp_mask[63]}}, {2{wt_rsp_mask[62]}}, {2{wt_rsp_mask[61]}}, {2{wt_rsp_mask[60]}}, {2{wt_rsp_mask[59]}}, {2{wt_rsp_mask[58]}}, {2{wt_rsp_mask[57]}}, {2{wt_rsp_mask[56]}}, {2{wt_rsp_mask[55]}}, {2{wt_rsp_mask[54]}}, {2{wt_rsp_mask[53]}}, {2{wt_rsp_mask[52]}}, {2{wt_rsp_mask[51]}}, {2{wt_rsp_mask[50]}}, {2{wt_rsp_mask[49]}}, {2{wt_rsp_mask[48]}}, {2{wt_rsp_mask[47]}}, {2{wt_rsp_mask[46]}}, {2{wt_rsp_mask[45]}}, {2{wt_rsp_mask[44]}}, {2{wt_rsp_mask[43]}}, {2{wt_rsp_mask[42]}}, {2{wt_rsp_mask[41]}}, {2{wt_rsp_mask[40]}}, {2{wt_rsp_mask[39]}}, {2{wt_rsp_mask[38]}}, {2{wt_rsp_mask[37]}}, {2{wt_rsp_mask[36]}}, {2{wt_rsp_mask[35]}}, {2{wt_rsp_mask[34]}}, {2{wt_rsp_mask[33]}}, {2{wt_rsp_mask[32]}}, {2{wt_rsp_mask[31]}}, {2{wt_rsp_mask[30]}}, {2{wt_rsp_mask[29]}}, {2{wt_rsp_mask[28]}}, {2{wt_rsp_mask[27]}}, {2{wt_rsp_mask[26]}}, {2{wt_rsp_mask[25]}}, {2{wt_rsp_mask[24]}}, {2{wt_rsp_mask[23]}}, {2{wt_rsp_mask[22]}}, {2{wt_rsp_mask[21]}}, {2{wt_rsp_mask[20]}}, {2{wt_rsp_mask[19]}}, {2{wt_rsp_mask[18]}}, {2{wt_rsp_mask[17]}}, {2{wt_rsp_mask[16]}}, {2{wt_rsp_mask[15]}}, {2{wt_rsp_mask[14]}}, {2{wt_rsp_mask[13]}}, {2{wt_rsp_mask[12]}}, {2{wt_rsp_mask[11]}}, {2{wt_rsp_mask[10]}}, {2{wt_rsp_mask[9]}}, {2{wt_rsp_mask[8]}}, {2{wt_rsp_mask[7]}}, {2{wt_rsp_mask[6]}}, {2{wt_rsp_mask[5]}}, {2{wt_rsp_mask[4]}}, {2{wt_rsp_mask[3]}}, {2{wt_rsp_mask[2]}}, {2{wt_rsp_mask[1]}}, {2{wt_rsp_mask[0]}}};
end

//////////////////////////////////// weight remain counter ////////////////////////////////////

always @(
  sc2buf_wt_rd_valid
  ) begin
    wt_rsp_byte_remain_add = sc2buf_wt_rd_valid ? 8'h80 : 8'h0;
end

always @(
  layer_st
  or wt_rsp_channel_end
  or wt_rsp_group_end
  or wt_rsp_byte_remain_last
  or wt_rsp_byte_remain
  or wt_rsp_byte_remain_add
  or wt_rsp_bytes
  ) begin
    {mon_wt_rsp_byte_remain_w,
     wt_rsp_byte_remain_w} = (layer_st) ? 8'b0 :
                             (wt_rsp_channel_end & ~wt_rsp_group_end) ? {2'b0, wt_rsp_byte_remain_last} :
                             wt_rsp_byte_remain + wt_rsp_byte_remain_add - wt_rsp_bytes;
end

always @(
  layer_st
  or wt_rsp_pipe_pvld
  ) begin
    wt_rsp_byte_remain_en = layer_st | wt_rsp_pipe_pvld;
end

always @(
  layer_st
  or wt_rsp_pipe_pvld
  or wt_rsp_group_end
  ) begin
    wt_rsp_byte_remain_last_en = layer_st | (wt_rsp_pipe_pvld & wt_rsp_group_end);
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_rsp_byte_remain <= {7{1'b0}};
  end else begin
  if ((wt_rsp_byte_remain_en) == 1'b1) begin
    wt_rsp_byte_remain <= wt_rsp_byte_remain_w;
  // VCS coverage off
  end else if ((wt_rsp_byte_remain_en) == 1'b0) begin
  end else begin
    wt_rsp_byte_remain <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_116x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rsp_byte_remain_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_rsp_byte_remain_last <= {7{1'b0}};
  end else begin
  if ((wt_rsp_byte_remain_last_en) == 1'b1) begin
    wt_rsp_byte_remain_last <= wt_rsp_byte_remain_w;
  // VCS coverage off
  end else if ((wt_rsp_byte_remain_last_en) == 1'b0) begin
  end else begin
    wt_rsp_byte_remain_last <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_117x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rsp_byte_remain_last_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_never #(0,0,"Error! wt_rsp_byte_remain_w is overflow")      zzz_assert_never_118x (nvdla_core_clk, `ASSERT_RESET, (wt_rsp_byte_remain_last_en & (|mon_wt_rsp_byte_remain_w))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////// generate local remain bytes ////////////////////////////////////

always @(
  wt_rsp_bytes
  or wt_rsp_byte_remain
  ) begin
    {mon_wt_shift_remain,
     wt_shift_remain} = wt_rsp_bytes - wt_rsp_byte_remain[6:0];
end

always @(
  sc2buf_wt_rd_data
  or wt_shift_remain
  ) begin
    {mon_wt_data_input_rs[7:0],
     wt_data_input_rs} = (sc2buf_wt_rd_data[1023:0] >> {wt_shift_remain, 3'b0});
end

always @(
  wt_rsp_byte_remain
  or wt_data_remain
  ) begin
    wt_data_remain_masked = ~(|wt_rsp_byte_remain) ? 1016'b0:
                            wt_data_remain;
end

always @(
  wt_data_remain
  or wt_rsp_bytes
  ) begin
    wt_data_remain_rs = (wt_data_remain >> {wt_rsp_bytes, 3'b0});
end

always @(
  layer_st
  or wt_rsp_channel_end
  or wt_rsp_group_end
  or wt_rsp_byte_remain_last
  or wt_data_remain_last
  or sc2buf_wt_rd_valid
  or wt_data_input_rs
  or wt_data_remain_rs
  ) begin
    wt_data_remain_w = layer_st ? 1016'b0 :
                       (wt_rsp_channel_end & ~wt_rsp_group_end & (|wt_rsp_byte_remain_last)) ? wt_data_remain_last :
                       sc2buf_wt_rd_valid ? wt_data_input_rs :
                       wt_data_remain_rs;
end

always @(
  layer_st
  or wt_rsp_pipe_pvld
  or wt_rsp_byte_remain_w
  ) begin
    wt_data_remain_reg_en = layer_st | (wt_rsp_pipe_pvld & (|wt_rsp_byte_remain_w));
end

always @(
  layer_st
  or wt_rsp_pipe_pvld
  or wt_rsp_group_end
  or wt_rsp_byte_remain_w
  ) begin
    wt_data_remain_last_reg_en = layer_st | (wt_rsp_pipe_pvld & wt_rsp_group_end & (|wt_rsp_byte_remain_w));
end

always @(
  sc2buf_wt_rd_data
  or wt_rsp_byte_remain
  ) begin
    wt_data_input_ls = (sc2buf_wt_rd_data << {wt_rsp_byte_remain[6:0], 3'b0});
end

always @(
  sc2buf_wt_rd_valid
  or wt_data_input_ls
  ) begin
    wt_data_input_sft = (sc2buf_wt_rd_valid) ? wt_data_input_ls : 1024'b0;
end

always @(posedge nvdla_core_clk) begin
  if ((wt_data_remain_reg_en) == 1'b1) begin
    wt_data_remain <= wt_data_remain_w;
  // VCS coverage off
  end else if ((wt_data_remain_reg_en) == 1'b0) begin
  end else begin
    wt_data_remain <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((wt_data_remain_last_reg_en) == 1'b1) begin
    wt_data_remain_last <= wt_data_remain_w;
  // VCS coverage off
  end else if ((wt_data_remain_last_reg_en) == 1'b0) begin
  end else begin
    wt_data_remain_last <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
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
  nv_assert_never #(0,0,"Error! wt_data_input_rs is overflow!")      zzz_assert_never_119x (nvdla_core_clk, `ASSERT_RESET, (sc2buf_wt_rd_valid & (|mon_wt_data_input_rs))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////// generate bytes for decoding ////////////////////////////////////
always @(
  wt_data_input_sft
  or wt_data_remain_masked
  ) begin
    wt_rsp_data = (wt_data_input_sft | {8'b0, wt_data_remain_masked});
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dec_input_data <= {1024{1'b0}};
  end else begin
  if ((wt_rsp_pipe_pvld) == 1'b1) begin
    dec_input_data <= wt_rsp_data;
  // VCS coverage off
  end else if ((wt_rsp_pipe_pvld) == 1'b0) begin
  end else begin
    dec_input_data <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_120x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rsp_pipe_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

//////////////////////////////////// generate select signal ////////////////////////////////////
always @(
  wt_rsp_last_stripe_end
  or wt_rsp_sel_d1
  ) begin
    wt_rsp_sel_w = wt_rsp_last_stripe_end ? 16'h1 : {wt_rsp_sel_d1[14:0], wt_rsp_sel_d1[15]};
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wt_rsp_last_stripe_end <= 1'b1;
  end else begin
  if ((wt_rsp_pipe_pvld) == 1'b1) begin
    wt_rsp_last_stripe_end <= wt_rsp_stripe_end;
  // VCS coverage off
  end else if ((wt_rsp_pipe_pvld) == 1'b0) begin
  end else begin
    wt_rsp_last_stripe_end <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_121x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rsp_pipe_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    wt_rsp_sel_d1 <= 16'h1;
  end else begin
  if ((wt_rsp_pipe_pvld) == 1'b1) begin
    wt_rsp_sel_d1 <= wt_rsp_sel_w;
  // VCS coverage off
  end else if ((wt_rsp_pipe_pvld) == 1'b0) begin
  end else begin
    wt_rsp_sel_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_122x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rsp_pipe_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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

assign dec_input_sel = wt_rsp_sel_d1;

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
  nv_assert_one_hot #(0,16,0,"Error! weight output select error!")      zzz_assert_one_hot_123x (nvdla_core_clk, `ASSERT_RESET, (wt_rsp_sel_d1)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
//////////////////////////////////// prepare other signals ////////////////////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dec_input_pipe_valid <= 1'b0;
  end else begin
  dec_input_pipe_valid <= wt_rsp_pipe_pvld;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dec_input_mask <= {128{1'b0}};
  end else begin
  if ((wt_rsp_mask_en) == 1'b1) begin
    dec_input_mask <= wt_rsp_mask_d1_w;
  // VCS coverage off
  end else if ((wt_rsp_mask_en) == 1'b0) begin
  end else begin
    dec_input_mask <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_124x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(wt_rsp_mask_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    dec_input_mask_en <= {10{1'b0}};
  end else begin
  dec_input_mask_en <= {10{wt_rsp_mask_en}};
  end
end

NV_NVDLA_CSC_WL_dec u_dec (
   .nvdla_core_clk   (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn  (nvdla_core_rstn)         //|< i
  ,.input_data       (dec_input_data[1023:0])  //|< r
  ,.input_mask       (dec_input_mask[127:0])   //|< r
  ,.input_mask_en    (dec_input_mask_en[9:0])  //|< r
  ,.input_pipe_valid (dec_input_pipe_valid)    //|< r
  ,.input_sel        (dec_input_sel[15:0])     //|< w
  ,.is_fp16          (is_fp16_d1)              //|< r
  ,.is_int8          (is_int8_d1)              //|< r
  ,.output_data0     (sc2mac_out_data0[7:0])   //|> w
  ,.output_data1     (sc2mac_out_data1[7:0])   //|> w
  ,.output_data10    (sc2mac_out_data10[7:0])  //|> w
  ,.output_data100   (sc2mac_out_data100[7:0]) //|> w
  ,.output_data101   (sc2mac_out_data101[7:0]) //|> w
  ,.output_data102   (sc2mac_out_data102[7:0]) //|> w
  ,.output_data103   (sc2mac_out_data103[7:0]) //|> w
  ,.output_data104   (sc2mac_out_data104[7:0]) //|> w
  ,.output_data105   (sc2mac_out_data105[7:0]) //|> w
  ,.output_data106   (sc2mac_out_data106[7:0]) //|> w
  ,.output_data107   (sc2mac_out_data107[7:0]) //|> w
  ,.output_data108   (sc2mac_out_data108[7:0]) //|> w
  ,.output_data109   (sc2mac_out_data109[7:0]) //|> w
  ,.output_data11    (sc2mac_out_data11[7:0])  //|> w
  ,.output_data110   (sc2mac_out_data110[7:0]) //|> w
  ,.output_data111   (sc2mac_out_data111[7:0]) //|> w
  ,.output_data112   (sc2mac_out_data112[7:0]) //|> w
  ,.output_data113   (sc2mac_out_data113[7:0]) //|> w
  ,.output_data114   (sc2mac_out_data114[7:0]) //|> w
  ,.output_data115   (sc2mac_out_data115[7:0]) //|> w
  ,.output_data116   (sc2mac_out_data116[7:0]) //|> w
  ,.output_data117   (sc2mac_out_data117[7:0]) //|> w
  ,.output_data118   (sc2mac_out_data118[7:0]) //|> w
  ,.output_data119   (sc2mac_out_data119[7:0]) //|> w
  ,.output_data12    (sc2mac_out_data12[7:0])  //|> w
  ,.output_data120   (sc2mac_out_data120[7:0]) //|> w
  ,.output_data121   (sc2mac_out_data121[7:0]) //|> w
  ,.output_data122   (sc2mac_out_data122[7:0]) //|> w
  ,.output_data123   (sc2mac_out_data123[7:0]) //|> w
  ,.output_data124   (sc2mac_out_data124[7:0]) //|> w
  ,.output_data125   (sc2mac_out_data125[7:0]) //|> w
  ,.output_data126   (sc2mac_out_data126[7:0]) //|> w
  ,.output_data127   (sc2mac_out_data127[7:0]) //|> w
  ,.output_data13    (sc2mac_out_data13[7:0])  //|> w
  ,.output_data14    (sc2mac_out_data14[7:0])  //|> w
  ,.output_data15    (sc2mac_out_data15[7:0])  //|> w
  ,.output_data16    (sc2mac_out_data16[7:0])  //|> w
  ,.output_data17    (sc2mac_out_data17[7:0])  //|> w
  ,.output_data18    (sc2mac_out_data18[7:0])  //|> w
  ,.output_data19    (sc2mac_out_data19[7:0])  //|> w
  ,.output_data2     (sc2mac_out_data2[7:0])   //|> w
  ,.output_data20    (sc2mac_out_data20[7:0])  //|> w
  ,.output_data21    (sc2mac_out_data21[7:0])  //|> w
  ,.output_data22    (sc2mac_out_data22[7:0])  //|> w
  ,.output_data23    (sc2mac_out_data23[7:0])  //|> w
  ,.output_data24    (sc2mac_out_data24[7:0])  //|> w
  ,.output_data25    (sc2mac_out_data25[7:0])  //|> w
  ,.output_data26    (sc2mac_out_data26[7:0])  //|> w
  ,.output_data27    (sc2mac_out_data27[7:0])  //|> w
  ,.output_data28    (sc2mac_out_data28[7:0])  //|> w
  ,.output_data29    (sc2mac_out_data29[7:0])  //|> w
  ,.output_data3     (sc2mac_out_data3[7:0])   //|> w
  ,.output_data30    (sc2mac_out_data30[7:0])  //|> w
  ,.output_data31    (sc2mac_out_data31[7:0])  //|> w
  ,.output_data32    (sc2mac_out_data32[7:0])  //|> w
  ,.output_data33    (sc2mac_out_data33[7:0])  //|> w
  ,.output_data34    (sc2mac_out_data34[7:0])  //|> w
  ,.output_data35    (sc2mac_out_data35[7:0])  //|> w
  ,.output_data36    (sc2mac_out_data36[7:0])  //|> w
  ,.output_data37    (sc2mac_out_data37[7:0])  //|> w
  ,.output_data38    (sc2mac_out_data38[7:0])  //|> w
  ,.output_data39    (sc2mac_out_data39[7:0])  //|> w
  ,.output_data4     (sc2mac_out_data4[7:0])   //|> w
  ,.output_data40    (sc2mac_out_data40[7:0])  //|> w
  ,.output_data41    (sc2mac_out_data41[7:0])  //|> w
  ,.output_data42    (sc2mac_out_data42[7:0])  //|> w
  ,.output_data43    (sc2mac_out_data43[7:0])  //|> w
  ,.output_data44    (sc2mac_out_data44[7:0])  //|> w
  ,.output_data45    (sc2mac_out_data45[7:0])  //|> w
  ,.output_data46    (sc2mac_out_data46[7:0])  //|> w
  ,.output_data47    (sc2mac_out_data47[7:0])  //|> w
  ,.output_data48    (sc2mac_out_data48[7:0])  //|> w
  ,.output_data49    (sc2mac_out_data49[7:0])  //|> w
  ,.output_data5     (sc2mac_out_data5[7:0])   //|> w
  ,.output_data50    (sc2mac_out_data50[7:0])  //|> w
  ,.output_data51    (sc2mac_out_data51[7:0])  //|> w
  ,.output_data52    (sc2mac_out_data52[7:0])  //|> w
  ,.output_data53    (sc2mac_out_data53[7:0])  //|> w
  ,.output_data54    (sc2mac_out_data54[7:0])  //|> w
  ,.output_data55    (sc2mac_out_data55[7:0])  //|> w
  ,.output_data56    (sc2mac_out_data56[7:0])  //|> w
  ,.output_data57    (sc2mac_out_data57[7:0])  //|> w
  ,.output_data58    (sc2mac_out_data58[7:0])  //|> w
  ,.output_data59    (sc2mac_out_data59[7:0])  //|> w
  ,.output_data6     (sc2mac_out_data6[7:0])   //|> w
  ,.output_data60    (sc2mac_out_data60[7:0])  //|> w
  ,.output_data61    (sc2mac_out_data61[7:0])  //|> w
  ,.output_data62    (sc2mac_out_data62[7:0])  //|> w
  ,.output_data63    (sc2mac_out_data63[7:0])  //|> w
  ,.output_data64    (sc2mac_out_data64[7:0])  //|> w
  ,.output_data65    (sc2mac_out_data65[7:0])  //|> w
  ,.output_data66    (sc2mac_out_data66[7:0])  //|> w
  ,.output_data67    (sc2mac_out_data67[7:0])  //|> w
  ,.output_data68    (sc2mac_out_data68[7:0])  //|> w
  ,.output_data69    (sc2mac_out_data69[7:0])  //|> w
  ,.output_data7     (sc2mac_out_data7[7:0])   //|> w
  ,.output_data70    (sc2mac_out_data70[7:0])  //|> w
  ,.output_data71    (sc2mac_out_data71[7:0])  //|> w
  ,.output_data72    (sc2mac_out_data72[7:0])  //|> w
  ,.output_data73    (sc2mac_out_data73[7:0])  //|> w
  ,.output_data74    (sc2mac_out_data74[7:0])  //|> w
  ,.output_data75    (sc2mac_out_data75[7:0])  //|> w
  ,.output_data76    (sc2mac_out_data76[7:0])  //|> w
  ,.output_data77    (sc2mac_out_data77[7:0])  //|> w
  ,.output_data78    (sc2mac_out_data78[7:0])  //|> w
  ,.output_data79    (sc2mac_out_data79[7:0])  //|> w
  ,.output_data8     (sc2mac_out_data8[7:0])   //|> w
  ,.output_data80    (sc2mac_out_data80[7:0])  //|> w
  ,.output_data81    (sc2mac_out_data81[7:0])  //|> w
  ,.output_data82    (sc2mac_out_data82[7:0])  //|> w
  ,.output_data83    (sc2mac_out_data83[7:0])  //|> w
  ,.output_data84    (sc2mac_out_data84[7:0])  //|> w
  ,.output_data85    (sc2mac_out_data85[7:0])  //|> w
  ,.output_data86    (sc2mac_out_data86[7:0])  //|> w
  ,.output_data87    (sc2mac_out_data87[7:0])  //|> w
  ,.output_data88    (sc2mac_out_data88[7:0])  //|> w
  ,.output_data89    (sc2mac_out_data89[7:0])  //|> w
  ,.output_data9     (sc2mac_out_data9[7:0])   //|> w
  ,.output_data90    (sc2mac_out_data90[7:0])  //|> w
  ,.output_data91    (sc2mac_out_data91[7:0])  //|> w
  ,.output_data92    (sc2mac_out_data92[7:0])  //|> w
  ,.output_data93    (sc2mac_out_data93[7:0])  //|> w
  ,.output_data94    (sc2mac_out_data94[7:0])  //|> w
  ,.output_data95    (sc2mac_out_data95[7:0])  //|> w
  ,.output_data96    (sc2mac_out_data96[7:0])  //|> w
  ,.output_data97    (sc2mac_out_data97[7:0])  //|> w
  ,.output_data98    (sc2mac_out_data98[7:0])  //|> w
  ,.output_data99    (sc2mac_out_data99[7:0])  //|> w
  ,.output_mask      (sc2mac_out_mask[127:0])  //|> w
  ,.output_pvld      (sc2mac_out_pvld)         //|> w
  ,.output_sel       (sc2mac_out_sel[15:0])    //|> w
  );

//////////////////////////////////////////////////////////////
///// registers for retiming                             /////
//////////////////////////////////////////////////////////////

always @(
  sc2mac_out_pvld
  or sc2mac_out_sel
  ) begin
    sc2mac_out_a_sel_w = {8{sc2mac_out_pvld}} & sc2mac_out_sel[7:0];
    sc2mac_out_b_sel_w = {8{sc2mac_out_pvld}} & sc2mac_out_sel[15:8];
end

always @(
  sc2mac_out_a_sel_w
  or sc2mac_out_b_sel_w
  ) begin
    sc2mac_wt_a_pvld_w = (|sc2mac_out_a_sel_w);
    sc2mac_wt_b_pvld_w = (|sc2mac_out_b_sel_w);
end

always @(
  sc2mac_out_mask
  or sc2mac_wt_a_pvld_w
  or sc2mac_wt_b_pvld_w
  ) begin
    sc2mac_out_a_mask = sc2mac_out_mask & {128{sc2mac_wt_a_pvld_w}};
    sc2mac_out_b_mask = sc2mac_out_mask & {128{sc2mac_wt_b_pvld_w}};
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2mac_wt_a_pvld <= 1'b0;
  end else begin
  sc2mac_wt_a_pvld <= sc2mac_wt_a_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2mac_wt_b_pvld <= 1'b0;
  end else begin
  sc2mac_wt_b_pvld <= sc2mac_wt_b_pvld_w;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2mac_wt_a_mask <= {128{1'b0}};
  end else begin
  if ((sc2mac_wt_a_pvld_w | sc2mac_wt_a_pvld) == 1'b1) begin
    sc2mac_wt_a_mask <= sc2mac_out_a_mask;
  // VCS coverage off
  end else if ((sc2mac_wt_a_pvld_w | sc2mac_wt_a_pvld) == 1'b0) begin
  end else begin
    sc2mac_wt_a_mask <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_125x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sc2mac_wt_a_pvld_w | sc2mac_wt_a_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    sc2mac_wt_b_mask <= {128{1'b0}};
  end else begin
  if ((sc2mac_wt_b_pvld_w | sc2mac_wt_b_pvld) == 1'b1) begin
    sc2mac_wt_b_mask <= sc2mac_out_b_mask;
  // VCS coverage off
  end else if ((sc2mac_wt_b_pvld_w | sc2mac_wt_b_pvld) == 1'b0) begin
  end else begin
    sc2mac_wt_b_mask <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_126x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sc2mac_wt_b_pvld_w | sc2mac_wt_b_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    sc2mac_wt_a_sel <= {8{1'b0}};
  end else begin
  if ((sc2mac_wt_a_pvld_w | sc2mac_wt_a_pvld) == 1'b1) begin
    sc2mac_wt_a_sel <= sc2mac_out_a_sel_w;
  // VCS coverage off
  end else if ((sc2mac_wt_a_pvld_w | sc2mac_wt_a_pvld) == 1'b0) begin
  end else begin
    sc2mac_wt_a_sel <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_127x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sc2mac_wt_a_pvld_w | sc2mac_wt_a_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
    sc2mac_wt_b_sel <= {8{1'b0}};
  end else begin
  if ((sc2mac_wt_b_pvld_w | sc2mac_wt_b_pvld) == 1'b1) begin
    sc2mac_wt_b_sel <= sc2mac_out_b_sel_w;
  // VCS coverage off
  end else if ((sc2mac_wt_b_pvld_w | sc2mac_wt_b_pvld) == 1'b0) begin
  end else begin
    sc2mac_wt_b_sel <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_128x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sc2mac_wt_b_pvld_w | sc2mac_wt_b_pvld))); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  if ((sc2mac_out_a_mask[0]) == 1'b1) begin
    sc2mac_wt_a_data0 <= sc2mac_out_data0;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[0]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[1]) == 1'b1) begin
    sc2mac_wt_a_data1 <= sc2mac_out_data1;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[1]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[2]) == 1'b1) begin
    sc2mac_wt_a_data2 <= sc2mac_out_data2;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[2]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[3]) == 1'b1) begin
    sc2mac_wt_a_data3 <= sc2mac_out_data3;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[3]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[4]) == 1'b1) begin
    sc2mac_wt_a_data4 <= sc2mac_out_data4;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[4]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[5]) == 1'b1) begin
    sc2mac_wt_a_data5 <= sc2mac_out_data5;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[5]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[6]) == 1'b1) begin
    sc2mac_wt_a_data6 <= sc2mac_out_data6;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[6]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[7]) == 1'b1) begin
    sc2mac_wt_a_data7 <= sc2mac_out_data7;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[7]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data7 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[8]) == 1'b1) begin
    sc2mac_wt_a_data8 <= sc2mac_out_data8;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[8]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data8 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[9]) == 1'b1) begin
    sc2mac_wt_a_data9 <= sc2mac_out_data9;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[9]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data9 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[10]) == 1'b1) begin
    sc2mac_wt_a_data10 <= sc2mac_out_data10;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[10]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data10 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[11]) == 1'b1) begin
    sc2mac_wt_a_data11 <= sc2mac_out_data11;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[11]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data11 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[12]) == 1'b1) begin
    sc2mac_wt_a_data12 <= sc2mac_out_data12;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[12]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data12 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[13]) == 1'b1) begin
    sc2mac_wt_a_data13 <= sc2mac_out_data13;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[13]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data13 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[14]) == 1'b1) begin
    sc2mac_wt_a_data14 <= sc2mac_out_data14;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[14]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data14 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[15]) == 1'b1) begin
    sc2mac_wt_a_data15 <= sc2mac_out_data15;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[15]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data15 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[16]) == 1'b1) begin
    sc2mac_wt_a_data16 <= sc2mac_out_data16;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[16]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data16 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[17]) == 1'b1) begin
    sc2mac_wt_a_data17 <= sc2mac_out_data17;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[17]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data17 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[18]) == 1'b1) begin
    sc2mac_wt_a_data18 <= sc2mac_out_data18;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[18]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data18 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[19]) == 1'b1) begin
    sc2mac_wt_a_data19 <= sc2mac_out_data19;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[19]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data19 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[20]) == 1'b1) begin
    sc2mac_wt_a_data20 <= sc2mac_out_data20;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[20]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data20 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[21]) == 1'b1) begin
    sc2mac_wt_a_data21 <= sc2mac_out_data21;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[21]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data21 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[22]) == 1'b1) begin
    sc2mac_wt_a_data22 <= sc2mac_out_data22;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[22]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data22 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[23]) == 1'b1) begin
    sc2mac_wt_a_data23 <= sc2mac_out_data23;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[23]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data23 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[24]) == 1'b1) begin
    sc2mac_wt_a_data24 <= sc2mac_out_data24;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[24]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data24 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[25]) == 1'b1) begin
    sc2mac_wt_a_data25 <= sc2mac_out_data25;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[25]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data25 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[26]) == 1'b1) begin
    sc2mac_wt_a_data26 <= sc2mac_out_data26;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[26]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data26 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[27]) == 1'b1) begin
    sc2mac_wt_a_data27 <= sc2mac_out_data27;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[27]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data27 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[28]) == 1'b1) begin
    sc2mac_wt_a_data28 <= sc2mac_out_data28;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[28]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data28 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[29]) == 1'b1) begin
    sc2mac_wt_a_data29 <= sc2mac_out_data29;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[29]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data29 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[30]) == 1'b1) begin
    sc2mac_wt_a_data30 <= sc2mac_out_data30;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[30]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data30 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[31]) == 1'b1) begin
    sc2mac_wt_a_data31 <= sc2mac_out_data31;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[31]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data31 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[32]) == 1'b1) begin
    sc2mac_wt_a_data32 <= sc2mac_out_data32;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[32]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data32 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[33]) == 1'b1) begin
    sc2mac_wt_a_data33 <= sc2mac_out_data33;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[33]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data33 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[34]) == 1'b1) begin
    sc2mac_wt_a_data34 <= sc2mac_out_data34;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[34]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data34 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[35]) == 1'b1) begin
    sc2mac_wt_a_data35 <= sc2mac_out_data35;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[35]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data35 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[36]) == 1'b1) begin
    sc2mac_wt_a_data36 <= sc2mac_out_data36;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[36]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data36 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[37]) == 1'b1) begin
    sc2mac_wt_a_data37 <= sc2mac_out_data37;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[37]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data37 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[38]) == 1'b1) begin
    sc2mac_wt_a_data38 <= sc2mac_out_data38;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[38]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data38 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[39]) == 1'b1) begin
    sc2mac_wt_a_data39 <= sc2mac_out_data39;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[39]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data39 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[40]) == 1'b1) begin
    sc2mac_wt_a_data40 <= sc2mac_out_data40;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[40]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data40 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[41]) == 1'b1) begin
    sc2mac_wt_a_data41 <= sc2mac_out_data41;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[41]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data41 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[42]) == 1'b1) begin
    sc2mac_wt_a_data42 <= sc2mac_out_data42;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[42]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data42 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[43]) == 1'b1) begin
    sc2mac_wt_a_data43 <= sc2mac_out_data43;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[43]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data43 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[44]) == 1'b1) begin
    sc2mac_wt_a_data44 <= sc2mac_out_data44;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[44]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data44 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[45]) == 1'b1) begin
    sc2mac_wt_a_data45 <= sc2mac_out_data45;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[45]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data45 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[46]) == 1'b1) begin
    sc2mac_wt_a_data46 <= sc2mac_out_data46;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[46]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data46 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[47]) == 1'b1) begin
    sc2mac_wt_a_data47 <= sc2mac_out_data47;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[47]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data47 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[48]) == 1'b1) begin
    sc2mac_wt_a_data48 <= sc2mac_out_data48;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[48]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data48 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[49]) == 1'b1) begin
    sc2mac_wt_a_data49 <= sc2mac_out_data49;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[49]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data49 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[50]) == 1'b1) begin
    sc2mac_wt_a_data50 <= sc2mac_out_data50;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[50]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data50 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[51]) == 1'b1) begin
    sc2mac_wt_a_data51 <= sc2mac_out_data51;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[51]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data51 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[52]) == 1'b1) begin
    sc2mac_wt_a_data52 <= sc2mac_out_data52;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[52]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data52 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[53]) == 1'b1) begin
    sc2mac_wt_a_data53 <= sc2mac_out_data53;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[53]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data53 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[54]) == 1'b1) begin
    sc2mac_wt_a_data54 <= sc2mac_out_data54;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[54]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data54 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[55]) == 1'b1) begin
    sc2mac_wt_a_data55 <= sc2mac_out_data55;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[55]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data55 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[56]) == 1'b1) begin
    sc2mac_wt_a_data56 <= sc2mac_out_data56;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[56]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data56 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[57]) == 1'b1) begin
    sc2mac_wt_a_data57 <= sc2mac_out_data57;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[57]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data57 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[58]) == 1'b1) begin
    sc2mac_wt_a_data58 <= sc2mac_out_data58;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[58]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data58 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[59]) == 1'b1) begin
    sc2mac_wt_a_data59 <= sc2mac_out_data59;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[59]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data59 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[60]) == 1'b1) begin
    sc2mac_wt_a_data60 <= sc2mac_out_data60;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[60]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data60 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[61]) == 1'b1) begin
    sc2mac_wt_a_data61 <= sc2mac_out_data61;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[61]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data61 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[62]) == 1'b1) begin
    sc2mac_wt_a_data62 <= sc2mac_out_data62;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[62]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data62 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[63]) == 1'b1) begin
    sc2mac_wt_a_data63 <= sc2mac_out_data63;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[63]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data63 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[64]) == 1'b1) begin
    sc2mac_wt_a_data64 <= sc2mac_out_data64;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[64]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data64 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[65]) == 1'b1) begin
    sc2mac_wt_a_data65 <= sc2mac_out_data65;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[65]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data65 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[66]) == 1'b1) begin
    sc2mac_wt_a_data66 <= sc2mac_out_data66;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[66]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data66 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[67]) == 1'b1) begin
    sc2mac_wt_a_data67 <= sc2mac_out_data67;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[67]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data67 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[68]) == 1'b1) begin
    sc2mac_wt_a_data68 <= sc2mac_out_data68;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[68]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data68 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[69]) == 1'b1) begin
    sc2mac_wt_a_data69 <= sc2mac_out_data69;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[69]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data69 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[70]) == 1'b1) begin
    sc2mac_wt_a_data70 <= sc2mac_out_data70;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[70]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data70 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[71]) == 1'b1) begin
    sc2mac_wt_a_data71 <= sc2mac_out_data71;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[71]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data71 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[72]) == 1'b1) begin
    sc2mac_wt_a_data72 <= sc2mac_out_data72;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[72]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data72 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[73]) == 1'b1) begin
    sc2mac_wt_a_data73 <= sc2mac_out_data73;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[73]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data73 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[74]) == 1'b1) begin
    sc2mac_wt_a_data74 <= sc2mac_out_data74;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[74]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data74 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[75]) == 1'b1) begin
    sc2mac_wt_a_data75 <= sc2mac_out_data75;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[75]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data75 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[76]) == 1'b1) begin
    sc2mac_wt_a_data76 <= sc2mac_out_data76;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[76]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data76 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[77]) == 1'b1) begin
    sc2mac_wt_a_data77 <= sc2mac_out_data77;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[77]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data77 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[78]) == 1'b1) begin
    sc2mac_wt_a_data78 <= sc2mac_out_data78;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[78]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data78 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[79]) == 1'b1) begin
    sc2mac_wt_a_data79 <= sc2mac_out_data79;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[79]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data79 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[80]) == 1'b1) begin
    sc2mac_wt_a_data80 <= sc2mac_out_data80;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[80]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data80 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[81]) == 1'b1) begin
    sc2mac_wt_a_data81 <= sc2mac_out_data81;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[81]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data81 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[82]) == 1'b1) begin
    sc2mac_wt_a_data82 <= sc2mac_out_data82;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[82]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data82 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[83]) == 1'b1) begin
    sc2mac_wt_a_data83 <= sc2mac_out_data83;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[83]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data83 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[84]) == 1'b1) begin
    sc2mac_wt_a_data84 <= sc2mac_out_data84;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[84]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data84 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[85]) == 1'b1) begin
    sc2mac_wt_a_data85 <= sc2mac_out_data85;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[85]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data85 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[86]) == 1'b1) begin
    sc2mac_wt_a_data86 <= sc2mac_out_data86;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[86]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data86 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[87]) == 1'b1) begin
    sc2mac_wt_a_data87 <= sc2mac_out_data87;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[87]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data87 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[88]) == 1'b1) begin
    sc2mac_wt_a_data88 <= sc2mac_out_data88;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[88]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data88 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[89]) == 1'b1) begin
    sc2mac_wt_a_data89 <= sc2mac_out_data89;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[89]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data89 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[90]) == 1'b1) begin
    sc2mac_wt_a_data90 <= sc2mac_out_data90;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[90]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data90 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[91]) == 1'b1) begin
    sc2mac_wt_a_data91 <= sc2mac_out_data91;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[91]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data91 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[92]) == 1'b1) begin
    sc2mac_wt_a_data92 <= sc2mac_out_data92;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[92]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data92 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[93]) == 1'b1) begin
    sc2mac_wt_a_data93 <= sc2mac_out_data93;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[93]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data93 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[94]) == 1'b1) begin
    sc2mac_wt_a_data94 <= sc2mac_out_data94;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[94]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data94 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[95]) == 1'b1) begin
    sc2mac_wt_a_data95 <= sc2mac_out_data95;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[95]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data95 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[96]) == 1'b1) begin
    sc2mac_wt_a_data96 <= sc2mac_out_data96;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[96]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data96 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[97]) == 1'b1) begin
    sc2mac_wt_a_data97 <= sc2mac_out_data97;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[97]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data97 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[98]) == 1'b1) begin
    sc2mac_wt_a_data98 <= sc2mac_out_data98;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[98]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data98 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[99]) == 1'b1) begin
    sc2mac_wt_a_data99 <= sc2mac_out_data99;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[99]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data99 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[100]) == 1'b1) begin
    sc2mac_wt_a_data100 <= sc2mac_out_data100;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[100]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data100 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[101]) == 1'b1) begin
    sc2mac_wt_a_data101 <= sc2mac_out_data101;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[101]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data101 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[102]) == 1'b1) begin
    sc2mac_wt_a_data102 <= sc2mac_out_data102;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[102]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data102 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[103]) == 1'b1) begin
    sc2mac_wt_a_data103 <= sc2mac_out_data103;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[103]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data103 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[104]) == 1'b1) begin
    sc2mac_wt_a_data104 <= sc2mac_out_data104;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[104]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data104 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[105]) == 1'b1) begin
    sc2mac_wt_a_data105 <= sc2mac_out_data105;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[105]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data105 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[106]) == 1'b1) begin
    sc2mac_wt_a_data106 <= sc2mac_out_data106;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[106]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data106 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[107]) == 1'b1) begin
    sc2mac_wt_a_data107 <= sc2mac_out_data107;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[107]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data107 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[108]) == 1'b1) begin
    sc2mac_wt_a_data108 <= sc2mac_out_data108;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[108]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data108 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[109]) == 1'b1) begin
    sc2mac_wt_a_data109 <= sc2mac_out_data109;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[109]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data109 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[110]) == 1'b1) begin
    sc2mac_wt_a_data110 <= sc2mac_out_data110;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[110]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data110 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[111]) == 1'b1) begin
    sc2mac_wt_a_data111 <= sc2mac_out_data111;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[111]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data111 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[112]) == 1'b1) begin
    sc2mac_wt_a_data112 <= sc2mac_out_data112;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[112]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data112 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[113]) == 1'b1) begin
    sc2mac_wt_a_data113 <= sc2mac_out_data113;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[113]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data113 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[114]) == 1'b1) begin
    sc2mac_wt_a_data114 <= sc2mac_out_data114;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[114]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data114 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[115]) == 1'b1) begin
    sc2mac_wt_a_data115 <= sc2mac_out_data115;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[115]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data115 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[116]) == 1'b1) begin
    sc2mac_wt_a_data116 <= sc2mac_out_data116;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[116]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data116 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[117]) == 1'b1) begin
    sc2mac_wt_a_data117 <= sc2mac_out_data117;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[117]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data117 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[118]) == 1'b1) begin
    sc2mac_wt_a_data118 <= sc2mac_out_data118;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[118]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data118 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[119]) == 1'b1) begin
    sc2mac_wt_a_data119 <= sc2mac_out_data119;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[119]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data119 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[120]) == 1'b1) begin
    sc2mac_wt_a_data120 <= sc2mac_out_data120;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[120]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data120 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[121]) == 1'b1) begin
    sc2mac_wt_a_data121 <= sc2mac_out_data121;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[121]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data121 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[122]) == 1'b1) begin
    sc2mac_wt_a_data122 <= sc2mac_out_data122;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[122]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data122 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[123]) == 1'b1) begin
    sc2mac_wt_a_data123 <= sc2mac_out_data123;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[123]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data123 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[124]) == 1'b1) begin
    sc2mac_wt_a_data124 <= sc2mac_out_data124;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[124]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data124 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[125]) == 1'b1) begin
    sc2mac_wt_a_data125 <= sc2mac_out_data125;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[125]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data125 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[126]) == 1'b1) begin
    sc2mac_wt_a_data126 <= sc2mac_out_data126;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[126]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data126 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_a_mask[127]) == 1'b1) begin
    sc2mac_wt_a_data127 <= sc2mac_out_data127;
  // VCS coverage off
  end else if ((sc2mac_out_a_mask[127]) == 1'b0) begin
  end else begin
    sc2mac_wt_a_data127 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[0]) == 1'b1) begin
    sc2mac_wt_b_data0 <= sc2mac_out_data0;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[0]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[1]) == 1'b1) begin
    sc2mac_wt_b_data1 <= sc2mac_out_data1;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[1]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[2]) == 1'b1) begin
    sc2mac_wt_b_data2 <= sc2mac_out_data2;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[2]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[3]) == 1'b1) begin
    sc2mac_wt_b_data3 <= sc2mac_out_data3;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[3]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[4]) == 1'b1) begin
    sc2mac_wt_b_data4 <= sc2mac_out_data4;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[4]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[5]) == 1'b1) begin
    sc2mac_wt_b_data5 <= sc2mac_out_data5;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[5]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[6]) == 1'b1) begin
    sc2mac_wt_b_data6 <= sc2mac_out_data6;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[6]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[7]) == 1'b1) begin
    sc2mac_wt_b_data7 <= sc2mac_out_data7;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[7]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data7 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[8]) == 1'b1) begin
    sc2mac_wt_b_data8 <= sc2mac_out_data8;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[8]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data8 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[9]) == 1'b1) begin
    sc2mac_wt_b_data9 <= sc2mac_out_data9;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[9]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data9 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[10]) == 1'b1) begin
    sc2mac_wt_b_data10 <= sc2mac_out_data10;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[10]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data10 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[11]) == 1'b1) begin
    sc2mac_wt_b_data11 <= sc2mac_out_data11;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[11]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data11 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[12]) == 1'b1) begin
    sc2mac_wt_b_data12 <= sc2mac_out_data12;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[12]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data12 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[13]) == 1'b1) begin
    sc2mac_wt_b_data13 <= sc2mac_out_data13;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[13]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data13 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[14]) == 1'b1) begin
    sc2mac_wt_b_data14 <= sc2mac_out_data14;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[14]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data14 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[15]) == 1'b1) begin
    sc2mac_wt_b_data15 <= sc2mac_out_data15;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[15]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data15 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[16]) == 1'b1) begin
    sc2mac_wt_b_data16 <= sc2mac_out_data16;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[16]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data16 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[17]) == 1'b1) begin
    sc2mac_wt_b_data17 <= sc2mac_out_data17;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[17]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data17 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[18]) == 1'b1) begin
    sc2mac_wt_b_data18 <= sc2mac_out_data18;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[18]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data18 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[19]) == 1'b1) begin
    sc2mac_wt_b_data19 <= sc2mac_out_data19;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[19]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data19 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[20]) == 1'b1) begin
    sc2mac_wt_b_data20 <= sc2mac_out_data20;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[20]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data20 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[21]) == 1'b1) begin
    sc2mac_wt_b_data21 <= sc2mac_out_data21;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[21]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data21 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[22]) == 1'b1) begin
    sc2mac_wt_b_data22 <= sc2mac_out_data22;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[22]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data22 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[23]) == 1'b1) begin
    sc2mac_wt_b_data23 <= sc2mac_out_data23;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[23]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data23 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[24]) == 1'b1) begin
    sc2mac_wt_b_data24 <= sc2mac_out_data24;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[24]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data24 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[25]) == 1'b1) begin
    sc2mac_wt_b_data25 <= sc2mac_out_data25;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[25]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data25 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[26]) == 1'b1) begin
    sc2mac_wt_b_data26 <= sc2mac_out_data26;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[26]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data26 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[27]) == 1'b1) begin
    sc2mac_wt_b_data27 <= sc2mac_out_data27;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[27]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data27 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[28]) == 1'b1) begin
    sc2mac_wt_b_data28 <= sc2mac_out_data28;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[28]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data28 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[29]) == 1'b1) begin
    sc2mac_wt_b_data29 <= sc2mac_out_data29;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[29]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data29 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[30]) == 1'b1) begin
    sc2mac_wt_b_data30 <= sc2mac_out_data30;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[30]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data30 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[31]) == 1'b1) begin
    sc2mac_wt_b_data31 <= sc2mac_out_data31;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[31]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data31 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[32]) == 1'b1) begin
    sc2mac_wt_b_data32 <= sc2mac_out_data32;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[32]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data32 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[33]) == 1'b1) begin
    sc2mac_wt_b_data33 <= sc2mac_out_data33;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[33]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data33 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[34]) == 1'b1) begin
    sc2mac_wt_b_data34 <= sc2mac_out_data34;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[34]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data34 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[35]) == 1'b1) begin
    sc2mac_wt_b_data35 <= sc2mac_out_data35;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[35]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data35 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[36]) == 1'b1) begin
    sc2mac_wt_b_data36 <= sc2mac_out_data36;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[36]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data36 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[37]) == 1'b1) begin
    sc2mac_wt_b_data37 <= sc2mac_out_data37;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[37]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data37 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[38]) == 1'b1) begin
    sc2mac_wt_b_data38 <= sc2mac_out_data38;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[38]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data38 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[39]) == 1'b1) begin
    sc2mac_wt_b_data39 <= sc2mac_out_data39;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[39]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data39 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[40]) == 1'b1) begin
    sc2mac_wt_b_data40 <= sc2mac_out_data40;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[40]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data40 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[41]) == 1'b1) begin
    sc2mac_wt_b_data41 <= sc2mac_out_data41;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[41]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data41 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[42]) == 1'b1) begin
    sc2mac_wt_b_data42 <= sc2mac_out_data42;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[42]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data42 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[43]) == 1'b1) begin
    sc2mac_wt_b_data43 <= sc2mac_out_data43;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[43]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data43 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[44]) == 1'b1) begin
    sc2mac_wt_b_data44 <= sc2mac_out_data44;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[44]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data44 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[45]) == 1'b1) begin
    sc2mac_wt_b_data45 <= sc2mac_out_data45;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[45]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data45 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[46]) == 1'b1) begin
    sc2mac_wt_b_data46 <= sc2mac_out_data46;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[46]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data46 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[47]) == 1'b1) begin
    sc2mac_wt_b_data47 <= sc2mac_out_data47;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[47]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data47 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[48]) == 1'b1) begin
    sc2mac_wt_b_data48 <= sc2mac_out_data48;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[48]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data48 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[49]) == 1'b1) begin
    sc2mac_wt_b_data49 <= sc2mac_out_data49;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[49]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data49 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[50]) == 1'b1) begin
    sc2mac_wt_b_data50 <= sc2mac_out_data50;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[50]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data50 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[51]) == 1'b1) begin
    sc2mac_wt_b_data51 <= sc2mac_out_data51;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[51]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data51 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[52]) == 1'b1) begin
    sc2mac_wt_b_data52 <= sc2mac_out_data52;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[52]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data52 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[53]) == 1'b1) begin
    sc2mac_wt_b_data53 <= sc2mac_out_data53;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[53]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data53 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[54]) == 1'b1) begin
    sc2mac_wt_b_data54 <= sc2mac_out_data54;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[54]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data54 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[55]) == 1'b1) begin
    sc2mac_wt_b_data55 <= sc2mac_out_data55;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[55]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data55 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[56]) == 1'b1) begin
    sc2mac_wt_b_data56 <= sc2mac_out_data56;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[56]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data56 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[57]) == 1'b1) begin
    sc2mac_wt_b_data57 <= sc2mac_out_data57;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[57]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data57 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[58]) == 1'b1) begin
    sc2mac_wt_b_data58 <= sc2mac_out_data58;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[58]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data58 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[59]) == 1'b1) begin
    sc2mac_wt_b_data59 <= sc2mac_out_data59;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[59]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data59 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[60]) == 1'b1) begin
    sc2mac_wt_b_data60 <= sc2mac_out_data60;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[60]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data60 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[61]) == 1'b1) begin
    sc2mac_wt_b_data61 <= sc2mac_out_data61;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[61]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data61 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[62]) == 1'b1) begin
    sc2mac_wt_b_data62 <= sc2mac_out_data62;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[62]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data62 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[63]) == 1'b1) begin
    sc2mac_wt_b_data63 <= sc2mac_out_data63;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[63]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data63 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[64]) == 1'b1) begin
    sc2mac_wt_b_data64 <= sc2mac_out_data64;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[64]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data64 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[65]) == 1'b1) begin
    sc2mac_wt_b_data65 <= sc2mac_out_data65;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[65]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data65 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[66]) == 1'b1) begin
    sc2mac_wt_b_data66 <= sc2mac_out_data66;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[66]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data66 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[67]) == 1'b1) begin
    sc2mac_wt_b_data67 <= sc2mac_out_data67;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[67]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data67 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[68]) == 1'b1) begin
    sc2mac_wt_b_data68 <= sc2mac_out_data68;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[68]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data68 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[69]) == 1'b1) begin
    sc2mac_wt_b_data69 <= sc2mac_out_data69;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[69]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data69 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[70]) == 1'b1) begin
    sc2mac_wt_b_data70 <= sc2mac_out_data70;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[70]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data70 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[71]) == 1'b1) begin
    sc2mac_wt_b_data71 <= sc2mac_out_data71;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[71]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data71 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[72]) == 1'b1) begin
    sc2mac_wt_b_data72 <= sc2mac_out_data72;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[72]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data72 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[73]) == 1'b1) begin
    sc2mac_wt_b_data73 <= sc2mac_out_data73;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[73]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data73 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[74]) == 1'b1) begin
    sc2mac_wt_b_data74 <= sc2mac_out_data74;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[74]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data74 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[75]) == 1'b1) begin
    sc2mac_wt_b_data75 <= sc2mac_out_data75;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[75]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data75 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[76]) == 1'b1) begin
    sc2mac_wt_b_data76 <= sc2mac_out_data76;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[76]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data76 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[77]) == 1'b1) begin
    sc2mac_wt_b_data77 <= sc2mac_out_data77;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[77]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data77 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[78]) == 1'b1) begin
    sc2mac_wt_b_data78 <= sc2mac_out_data78;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[78]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data78 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[79]) == 1'b1) begin
    sc2mac_wt_b_data79 <= sc2mac_out_data79;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[79]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data79 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[80]) == 1'b1) begin
    sc2mac_wt_b_data80 <= sc2mac_out_data80;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[80]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data80 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[81]) == 1'b1) begin
    sc2mac_wt_b_data81 <= sc2mac_out_data81;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[81]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data81 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[82]) == 1'b1) begin
    sc2mac_wt_b_data82 <= sc2mac_out_data82;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[82]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data82 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[83]) == 1'b1) begin
    sc2mac_wt_b_data83 <= sc2mac_out_data83;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[83]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data83 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[84]) == 1'b1) begin
    sc2mac_wt_b_data84 <= sc2mac_out_data84;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[84]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data84 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[85]) == 1'b1) begin
    sc2mac_wt_b_data85 <= sc2mac_out_data85;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[85]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data85 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[86]) == 1'b1) begin
    sc2mac_wt_b_data86 <= sc2mac_out_data86;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[86]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data86 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[87]) == 1'b1) begin
    sc2mac_wt_b_data87 <= sc2mac_out_data87;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[87]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data87 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[88]) == 1'b1) begin
    sc2mac_wt_b_data88 <= sc2mac_out_data88;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[88]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data88 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[89]) == 1'b1) begin
    sc2mac_wt_b_data89 <= sc2mac_out_data89;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[89]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data89 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[90]) == 1'b1) begin
    sc2mac_wt_b_data90 <= sc2mac_out_data90;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[90]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data90 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[91]) == 1'b1) begin
    sc2mac_wt_b_data91 <= sc2mac_out_data91;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[91]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data91 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[92]) == 1'b1) begin
    sc2mac_wt_b_data92 <= sc2mac_out_data92;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[92]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data92 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[93]) == 1'b1) begin
    sc2mac_wt_b_data93 <= sc2mac_out_data93;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[93]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data93 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[94]) == 1'b1) begin
    sc2mac_wt_b_data94 <= sc2mac_out_data94;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[94]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data94 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[95]) == 1'b1) begin
    sc2mac_wt_b_data95 <= sc2mac_out_data95;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[95]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data95 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[96]) == 1'b1) begin
    sc2mac_wt_b_data96 <= sc2mac_out_data96;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[96]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data96 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[97]) == 1'b1) begin
    sc2mac_wt_b_data97 <= sc2mac_out_data97;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[97]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data97 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[98]) == 1'b1) begin
    sc2mac_wt_b_data98 <= sc2mac_out_data98;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[98]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data98 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[99]) == 1'b1) begin
    sc2mac_wt_b_data99 <= sc2mac_out_data99;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[99]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data99 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[100]) == 1'b1) begin
    sc2mac_wt_b_data100 <= sc2mac_out_data100;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[100]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data100 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[101]) == 1'b1) begin
    sc2mac_wt_b_data101 <= sc2mac_out_data101;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[101]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data101 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[102]) == 1'b1) begin
    sc2mac_wt_b_data102 <= sc2mac_out_data102;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[102]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data102 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[103]) == 1'b1) begin
    sc2mac_wt_b_data103 <= sc2mac_out_data103;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[103]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data103 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[104]) == 1'b1) begin
    sc2mac_wt_b_data104 <= sc2mac_out_data104;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[104]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data104 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[105]) == 1'b1) begin
    sc2mac_wt_b_data105 <= sc2mac_out_data105;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[105]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data105 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[106]) == 1'b1) begin
    sc2mac_wt_b_data106 <= sc2mac_out_data106;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[106]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data106 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[107]) == 1'b1) begin
    sc2mac_wt_b_data107 <= sc2mac_out_data107;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[107]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data107 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[108]) == 1'b1) begin
    sc2mac_wt_b_data108 <= sc2mac_out_data108;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[108]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data108 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[109]) == 1'b1) begin
    sc2mac_wt_b_data109 <= sc2mac_out_data109;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[109]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data109 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[110]) == 1'b1) begin
    sc2mac_wt_b_data110 <= sc2mac_out_data110;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[110]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data110 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[111]) == 1'b1) begin
    sc2mac_wt_b_data111 <= sc2mac_out_data111;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[111]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data111 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[112]) == 1'b1) begin
    sc2mac_wt_b_data112 <= sc2mac_out_data112;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[112]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data112 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[113]) == 1'b1) begin
    sc2mac_wt_b_data113 <= sc2mac_out_data113;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[113]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data113 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[114]) == 1'b1) begin
    sc2mac_wt_b_data114 <= sc2mac_out_data114;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[114]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data114 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[115]) == 1'b1) begin
    sc2mac_wt_b_data115 <= sc2mac_out_data115;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[115]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data115 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[116]) == 1'b1) begin
    sc2mac_wt_b_data116 <= sc2mac_out_data116;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[116]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data116 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[117]) == 1'b1) begin
    sc2mac_wt_b_data117 <= sc2mac_out_data117;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[117]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data117 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[118]) == 1'b1) begin
    sc2mac_wt_b_data118 <= sc2mac_out_data118;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[118]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data118 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[119]) == 1'b1) begin
    sc2mac_wt_b_data119 <= sc2mac_out_data119;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[119]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data119 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[120]) == 1'b1) begin
    sc2mac_wt_b_data120 <= sc2mac_out_data120;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[120]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data120 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[121]) == 1'b1) begin
    sc2mac_wt_b_data121 <= sc2mac_out_data121;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[121]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data121 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[122]) == 1'b1) begin
    sc2mac_wt_b_data122 <= sc2mac_out_data122;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[122]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data122 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[123]) == 1'b1) begin
    sc2mac_wt_b_data123 <= sc2mac_out_data123;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[123]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data123 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[124]) == 1'b1) begin
    sc2mac_wt_b_data124 <= sc2mac_out_data124;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[124]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data124 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[125]) == 1'b1) begin
    sc2mac_wt_b_data125 <= sc2mac_out_data125;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[125]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data125 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[126]) == 1'b1) begin
    sc2mac_wt_b_data126 <= sc2mac_out_data126;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[126]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data126 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_out_b_mask[127]) == 1'b1) begin
    sc2mac_wt_b_data127 <= sc2mac_out_data127;
  // VCS coverage off
  end else if ((sc2mac_out_b_mask[127]) == 1'b0) begin
  end else begin
    sc2mac_wt_b_data127 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end



`ifndef SYNTHESIS
assign dbg_csc_wt_a_0 = sc2mac_wt_a_mask[0] ? sc2mac_wt_a_data0 : 8'h0;
assign dbg_csc_wt_a_1 = sc2mac_wt_a_mask[1] ? sc2mac_wt_a_data1 : 8'h0;
assign dbg_csc_wt_a_2 = sc2mac_wt_a_mask[2] ? sc2mac_wt_a_data2 : 8'h0;
assign dbg_csc_wt_a_3 = sc2mac_wt_a_mask[3] ? sc2mac_wt_a_data3 : 8'h0;
assign dbg_csc_wt_a_4 = sc2mac_wt_a_mask[4] ? sc2mac_wt_a_data4 : 8'h0;
assign dbg_csc_wt_a_5 = sc2mac_wt_a_mask[5] ? sc2mac_wt_a_data5 : 8'h0;
assign dbg_csc_wt_a_6 = sc2mac_wt_a_mask[6] ? sc2mac_wt_a_data6 : 8'h0;
assign dbg_csc_wt_a_7 = sc2mac_wt_a_mask[7] ? sc2mac_wt_a_data7 : 8'h0;
assign dbg_csc_wt_a_8 = sc2mac_wt_a_mask[8] ? sc2mac_wt_a_data8 : 8'h0;
assign dbg_csc_wt_a_9 = sc2mac_wt_a_mask[9] ? sc2mac_wt_a_data9 : 8'h0;
assign dbg_csc_wt_a_10 = sc2mac_wt_a_mask[10] ? sc2mac_wt_a_data10 : 8'h0;
assign dbg_csc_wt_a_11 = sc2mac_wt_a_mask[11] ? sc2mac_wt_a_data11 : 8'h0;
assign dbg_csc_wt_a_12 = sc2mac_wt_a_mask[12] ? sc2mac_wt_a_data12 : 8'h0;
assign dbg_csc_wt_a_13 = sc2mac_wt_a_mask[13] ? sc2mac_wt_a_data13 : 8'h0;
assign dbg_csc_wt_a_14 = sc2mac_wt_a_mask[14] ? sc2mac_wt_a_data14 : 8'h0;
assign dbg_csc_wt_a_15 = sc2mac_wt_a_mask[15] ? sc2mac_wt_a_data15 : 8'h0;
assign dbg_csc_wt_a_16 = sc2mac_wt_a_mask[16] ? sc2mac_wt_a_data16 : 8'h0;
assign dbg_csc_wt_a_17 = sc2mac_wt_a_mask[17] ? sc2mac_wt_a_data17 : 8'h0;
assign dbg_csc_wt_a_18 = sc2mac_wt_a_mask[18] ? sc2mac_wt_a_data18 : 8'h0;
assign dbg_csc_wt_a_19 = sc2mac_wt_a_mask[19] ? sc2mac_wt_a_data19 : 8'h0;
assign dbg_csc_wt_a_20 = sc2mac_wt_a_mask[20] ? sc2mac_wt_a_data20 : 8'h0;
assign dbg_csc_wt_a_21 = sc2mac_wt_a_mask[21] ? sc2mac_wt_a_data21 : 8'h0;
assign dbg_csc_wt_a_22 = sc2mac_wt_a_mask[22] ? sc2mac_wt_a_data22 : 8'h0;
assign dbg_csc_wt_a_23 = sc2mac_wt_a_mask[23] ? sc2mac_wt_a_data23 : 8'h0;
assign dbg_csc_wt_a_24 = sc2mac_wt_a_mask[24] ? sc2mac_wt_a_data24 : 8'h0;
assign dbg_csc_wt_a_25 = sc2mac_wt_a_mask[25] ? sc2mac_wt_a_data25 : 8'h0;
assign dbg_csc_wt_a_26 = sc2mac_wt_a_mask[26] ? sc2mac_wt_a_data26 : 8'h0;
assign dbg_csc_wt_a_27 = sc2mac_wt_a_mask[27] ? sc2mac_wt_a_data27 : 8'h0;
assign dbg_csc_wt_a_28 = sc2mac_wt_a_mask[28] ? sc2mac_wt_a_data28 : 8'h0;
assign dbg_csc_wt_a_29 = sc2mac_wt_a_mask[29] ? sc2mac_wt_a_data29 : 8'h0;
assign dbg_csc_wt_a_30 = sc2mac_wt_a_mask[30] ? sc2mac_wt_a_data30 : 8'h0;
assign dbg_csc_wt_a_31 = sc2mac_wt_a_mask[31] ? sc2mac_wt_a_data31 : 8'h0;
assign dbg_csc_wt_a_32 = sc2mac_wt_a_mask[32] ? sc2mac_wt_a_data32 : 8'h0;
assign dbg_csc_wt_a_33 = sc2mac_wt_a_mask[33] ? sc2mac_wt_a_data33 : 8'h0;
assign dbg_csc_wt_a_34 = sc2mac_wt_a_mask[34] ? sc2mac_wt_a_data34 : 8'h0;
assign dbg_csc_wt_a_35 = sc2mac_wt_a_mask[35] ? sc2mac_wt_a_data35 : 8'h0;
assign dbg_csc_wt_a_36 = sc2mac_wt_a_mask[36] ? sc2mac_wt_a_data36 : 8'h0;
assign dbg_csc_wt_a_37 = sc2mac_wt_a_mask[37] ? sc2mac_wt_a_data37 : 8'h0;
assign dbg_csc_wt_a_38 = sc2mac_wt_a_mask[38] ? sc2mac_wt_a_data38 : 8'h0;
assign dbg_csc_wt_a_39 = sc2mac_wt_a_mask[39] ? sc2mac_wt_a_data39 : 8'h0;
assign dbg_csc_wt_a_40 = sc2mac_wt_a_mask[40] ? sc2mac_wt_a_data40 : 8'h0;
assign dbg_csc_wt_a_41 = sc2mac_wt_a_mask[41] ? sc2mac_wt_a_data41 : 8'h0;
assign dbg_csc_wt_a_42 = sc2mac_wt_a_mask[42] ? sc2mac_wt_a_data42 : 8'h0;
assign dbg_csc_wt_a_43 = sc2mac_wt_a_mask[43] ? sc2mac_wt_a_data43 : 8'h0;
assign dbg_csc_wt_a_44 = sc2mac_wt_a_mask[44] ? sc2mac_wt_a_data44 : 8'h0;
assign dbg_csc_wt_a_45 = sc2mac_wt_a_mask[45] ? sc2mac_wt_a_data45 : 8'h0;
assign dbg_csc_wt_a_46 = sc2mac_wt_a_mask[46] ? sc2mac_wt_a_data46 : 8'h0;
assign dbg_csc_wt_a_47 = sc2mac_wt_a_mask[47] ? sc2mac_wt_a_data47 : 8'h0;
assign dbg_csc_wt_a_48 = sc2mac_wt_a_mask[48] ? sc2mac_wt_a_data48 : 8'h0;
assign dbg_csc_wt_a_49 = sc2mac_wt_a_mask[49] ? sc2mac_wt_a_data49 : 8'h0;
assign dbg_csc_wt_a_50 = sc2mac_wt_a_mask[50] ? sc2mac_wt_a_data50 : 8'h0;
assign dbg_csc_wt_a_51 = sc2mac_wt_a_mask[51] ? sc2mac_wt_a_data51 : 8'h0;
assign dbg_csc_wt_a_52 = sc2mac_wt_a_mask[52] ? sc2mac_wt_a_data52 : 8'h0;
assign dbg_csc_wt_a_53 = sc2mac_wt_a_mask[53] ? sc2mac_wt_a_data53 : 8'h0;
assign dbg_csc_wt_a_54 = sc2mac_wt_a_mask[54] ? sc2mac_wt_a_data54 : 8'h0;
assign dbg_csc_wt_a_55 = sc2mac_wt_a_mask[55] ? sc2mac_wt_a_data55 : 8'h0;
assign dbg_csc_wt_a_56 = sc2mac_wt_a_mask[56] ? sc2mac_wt_a_data56 : 8'h0;
assign dbg_csc_wt_a_57 = sc2mac_wt_a_mask[57] ? sc2mac_wt_a_data57 : 8'h0;
assign dbg_csc_wt_a_58 = sc2mac_wt_a_mask[58] ? sc2mac_wt_a_data58 : 8'h0;
assign dbg_csc_wt_a_59 = sc2mac_wt_a_mask[59] ? sc2mac_wt_a_data59 : 8'h0;
assign dbg_csc_wt_a_60 = sc2mac_wt_a_mask[60] ? sc2mac_wt_a_data60 : 8'h0;
assign dbg_csc_wt_a_61 = sc2mac_wt_a_mask[61] ? sc2mac_wt_a_data61 : 8'h0;
assign dbg_csc_wt_a_62 = sc2mac_wt_a_mask[62] ? sc2mac_wt_a_data62 : 8'h0;
assign dbg_csc_wt_a_63 = sc2mac_wt_a_mask[63] ? sc2mac_wt_a_data63 : 8'h0;
assign dbg_csc_wt_a_64 = sc2mac_wt_a_mask[64] ? sc2mac_wt_a_data64 : 8'h0;
assign dbg_csc_wt_a_65 = sc2mac_wt_a_mask[65] ? sc2mac_wt_a_data65 : 8'h0;
assign dbg_csc_wt_a_66 = sc2mac_wt_a_mask[66] ? sc2mac_wt_a_data66 : 8'h0;
assign dbg_csc_wt_a_67 = sc2mac_wt_a_mask[67] ? sc2mac_wt_a_data67 : 8'h0;
assign dbg_csc_wt_a_68 = sc2mac_wt_a_mask[68] ? sc2mac_wt_a_data68 : 8'h0;
assign dbg_csc_wt_a_69 = sc2mac_wt_a_mask[69] ? sc2mac_wt_a_data69 : 8'h0;
assign dbg_csc_wt_a_70 = sc2mac_wt_a_mask[70] ? sc2mac_wt_a_data70 : 8'h0;
assign dbg_csc_wt_a_71 = sc2mac_wt_a_mask[71] ? sc2mac_wt_a_data71 : 8'h0;
assign dbg_csc_wt_a_72 = sc2mac_wt_a_mask[72] ? sc2mac_wt_a_data72 : 8'h0;
assign dbg_csc_wt_a_73 = sc2mac_wt_a_mask[73] ? sc2mac_wt_a_data73 : 8'h0;
assign dbg_csc_wt_a_74 = sc2mac_wt_a_mask[74] ? sc2mac_wt_a_data74 : 8'h0;
assign dbg_csc_wt_a_75 = sc2mac_wt_a_mask[75] ? sc2mac_wt_a_data75 : 8'h0;
assign dbg_csc_wt_a_76 = sc2mac_wt_a_mask[76] ? sc2mac_wt_a_data76 : 8'h0;
assign dbg_csc_wt_a_77 = sc2mac_wt_a_mask[77] ? sc2mac_wt_a_data77 : 8'h0;
assign dbg_csc_wt_a_78 = sc2mac_wt_a_mask[78] ? sc2mac_wt_a_data78 : 8'h0;
assign dbg_csc_wt_a_79 = sc2mac_wt_a_mask[79] ? sc2mac_wt_a_data79 : 8'h0;
assign dbg_csc_wt_a_80 = sc2mac_wt_a_mask[80] ? sc2mac_wt_a_data80 : 8'h0;
assign dbg_csc_wt_a_81 = sc2mac_wt_a_mask[81] ? sc2mac_wt_a_data81 : 8'h0;
assign dbg_csc_wt_a_82 = sc2mac_wt_a_mask[82] ? sc2mac_wt_a_data82 : 8'h0;
assign dbg_csc_wt_a_83 = sc2mac_wt_a_mask[83] ? sc2mac_wt_a_data83 : 8'h0;
assign dbg_csc_wt_a_84 = sc2mac_wt_a_mask[84] ? sc2mac_wt_a_data84 : 8'h0;
assign dbg_csc_wt_a_85 = sc2mac_wt_a_mask[85] ? sc2mac_wt_a_data85 : 8'h0;
assign dbg_csc_wt_a_86 = sc2mac_wt_a_mask[86] ? sc2mac_wt_a_data86 : 8'h0;
assign dbg_csc_wt_a_87 = sc2mac_wt_a_mask[87] ? sc2mac_wt_a_data87 : 8'h0;
assign dbg_csc_wt_a_88 = sc2mac_wt_a_mask[88] ? sc2mac_wt_a_data88 : 8'h0;
assign dbg_csc_wt_a_89 = sc2mac_wt_a_mask[89] ? sc2mac_wt_a_data89 : 8'h0;
assign dbg_csc_wt_a_90 = sc2mac_wt_a_mask[90] ? sc2mac_wt_a_data90 : 8'h0;
assign dbg_csc_wt_a_91 = sc2mac_wt_a_mask[91] ? sc2mac_wt_a_data91 : 8'h0;
assign dbg_csc_wt_a_92 = sc2mac_wt_a_mask[92] ? sc2mac_wt_a_data92 : 8'h0;
assign dbg_csc_wt_a_93 = sc2mac_wt_a_mask[93] ? sc2mac_wt_a_data93 : 8'h0;
assign dbg_csc_wt_a_94 = sc2mac_wt_a_mask[94] ? sc2mac_wt_a_data94 : 8'h0;
assign dbg_csc_wt_a_95 = sc2mac_wt_a_mask[95] ? sc2mac_wt_a_data95 : 8'h0;
assign dbg_csc_wt_a_96 = sc2mac_wt_a_mask[96] ? sc2mac_wt_a_data96 : 8'h0;
assign dbg_csc_wt_a_97 = sc2mac_wt_a_mask[97] ? sc2mac_wt_a_data97 : 8'h0;
assign dbg_csc_wt_a_98 = sc2mac_wt_a_mask[98] ? sc2mac_wt_a_data98 : 8'h0;
assign dbg_csc_wt_a_99 = sc2mac_wt_a_mask[99] ? sc2mac_wt_a_data99 : 8'h0;
assign dbg_csc_wt_a_100 = sc2mac_wt_a_mask[100] ? sc2mac_wt_a_data100 : 8'h0;
assign dbg_csc_wt_a_101 = sc2mac_wt_a_mask[101] ? sc2mac_wt_a_data101 : 8'h0;
assign dbg_csc_wt_a_102 = sc2mac_wt_a_mask[102] ? sc2mac_wt_a_data102 : 8'h0;
assign dbg_csc_wt_a_103 = sc2mac_wt_a_mask[103] ? sc2mac_wt_a_data103 : 8'h0;
assign dbg_csc_wt_a_104 = sc2mac_wt_a_mask[104] ? sc2mac_wt_a_data104 : 8'h0;
assign dbg_csc_wt_a_105 = sc2mac_wt_a_mask[105] ? sc2mac_wt_a_data105 : 8'h0;
assign dbg_csc_wt_a_106 = sc2mac_wt_a_mask[106] ? sc2mac_wt_a_data106 : 8'h0;
assign dbg_csc_wt_a_107 = sc2mac_wt_a_mask[107] ? sc2mac_wt_a_data107 : 8'h0;
assign dbg_csc_wt_a_108 = sc2mac_wt_a_mask[108] ? sc2mac_wt_a_data108 : 8'h0;
assign dbg_csc_wt_a_109 = sc2mac_wt_a_mask[109] ? sc2mac_wt_a_data109 : 8'h0;
assign dbg_csc_wt_a_110 = sc2mac_wt_a_mask[110] ? sc2mac_wt_a_data110 : 8'h0;
assign dbg_csc_wt_a_111 = sc2mac_wt_a_mask[111] ? sc2mac_wt_a_data111 : 8'h0;
assign dbg_csc_wt_a_112 = sc2mac_wt_a_mask[112] ? sc2mac_wt_a_data112 : 8'h0;
assign dbg_csc_wt_a_113 = sc2mac_wt_a_mask[113] ? sc2mac_wt_a_data113 : 8'h0;
assign dbg_csc_wt_a_114 = sc2mac_wt_a_mask[114] ? sc2mac_wt_a_data114 : 8'h0;
assign dbg_csc_wt_a_115 = sc2mac_wt_a_mask[115] ? sc2mac_wt_a_data115 : 8'h0;
assign dbg_csc_wt_a_116 = sc2mac_wt_a_mask[116] ? sc2mac_wt_a_data116 : 8'h0;
assign dbg_csc_wt_a_117 = sc2mac_wt_a_mask[117] ? sc2mac_wt_a_data117 : 8'h0;
assign dbg_csc_wt_a_118 = sc2mac_wt_a_mask[118] ? sc2mac_wt_a_data118 : 8'h0;
assign dbg_csc_wt_a_119 = sc2mac_wt_a_mask[119] ? sc2mac_wt_a_data119 : 8'h0;
assign dbg_csc_wt_a_120 = sc2mac_wt_a_mask[120] ? sc2mac_wt_a_data120 : 8'h0;
assign dbg_csc_wt_a_121 = sc2mac_wt_a_mask[121] ? sc2mac_wt_a_data121 : 8'h0;
assign dbg_csc_wt_a_122 = sc2mac_wt_a_mask[122] ? sc2mac_wt_a_data122 : 8'h0;
assign dbg_csc_wt_a_123 = sc2mac_wt_a_mask[123] ? sc2mac_wt_a_data123 : 8'h0;
assign dbg_csc_wt_a_124 = sc2mac_wt_a_mask[124] ? sc2mac_wt_a_data124 : 8'h0;
assign dbg_csc_wt_a_125 = sc2mac_wt_a_mask[125] ? sc2mac_wt_a_data125 : 8'h0;
assign dbg_csc_wt_a_126 = sc2mac_wt_a_mask[126] ? sc2mac_wt_a_data126 : 8'h0;
assign dbg_csc_wt_a_127 = sc2mac_wt_a_mask[127] ? sc2mac_wt_a_data127 : 8'h0;
assign dbg_csc_wt_b_0 = sc2mac_wt_b_mask[0] ? sc2mac_wt_b_data0 : 8'h0;
assign dbg_csc_wt_b_1 = sc2mac_wt_b_mask[1] ? sc2mac_wt_b_data1 : 8'h0;
assign dbg_csc_wt_b_2 = sc2mac_wt_b_mask[2] ? sc2mac_wt_b_data2 : 8'h0;
assign dbg_csc_wt_b_3 = sc2mac_wt_b_mask[3] ? sc2mac_wt_b_data3 : 8'h0;
assign dbg_csc_wt_b_4 = sc2mac_wt_b_mask[4] ? sc2mac_wt_b_data4 : 8'h0;
assign dbg_csc_wt_b_5 = sc2mac_wt_b_mask[5] ? sc2mac_wt_b_data5 : 8'h0;
assign dbg_csc_wt_b_6 = sc2mac_wt_b_mask[6] ? sc2mac_wt_b_data6 : 8'h0;
assign dbg_csc_wt_b_7 = sc2mac_wt_b_mask[7] ? sc2mac_wt_b_data7 : 8'h0;
assign dbg_csc_wt_b_8 = sc2mac_wt_b_mask[8] ? sc2mac_wt_b_data8 : 8'h0;
assign dbg_csc_wt_b_9 = sc2mac_wt_b_mask[9] ? sc2mac_wt_b_data9 : 8'h0;
assign dbg_csc_wt_b_10 = sc2mac_wt_b_mask[10] ? sc2mac_wt_b_data10 : 8'h0;
assign dbg_csc_wt_b_11 = sc2mac_wt_b_mask[11] ? sc2mac_wt_b_data11 : 8'h0;
assign dbg_csc_wt_b_12 = sc2mac_wt_b_mask[12] ? sc2mac_wt_b_data12 : 8'h0;
assign dbg_csc_wt_b_13 = sc2mac_wt_b_mask[13] ? sc2mac_wt_b_data13 : 8'h0;
assign dbg_csc_wt_b_14 = sc2mac_wt_b_mask[14] ? sc2mac_wt_b_data14 : 8'h0;
assign dbg_csc_wt_b_15 = sc2mac_wt_b_mask[15] ? sc2mac_wt_b_data15 : 8'h0;
assign dbg_csc_wt_b_16 = sc2mac_wt_b_mask[16] ? sc2mac_wt_b_data16 : 8'h0;
assign dbg_csc_wt_b_17 = sc2mac_wt_b_mask[17] ? sc2mac_wt_b_data17 : 8'h0;
assign dbg_csc_wt_b_18 = sc2mac_wt_b_mask[18] ? sc2mac_wt_b_data18 : 8'h0;
assign dbg_csc_wt_b_19 = sc2mac_wt_b_mask[19] ? sc2mac_wt_b_data19 : 8'h0;
assign dbg_csc_wt_b_20 = sc2mac_wt_b_mask[20] ? sc2mac_wt_b_data20 : 8'h0;
assign dbg_csc_wt_b_21 = sc2mac_wt_b_mask[21] ? sc2mac_wt_b_data21 : 8'h0;
assign dbg_csc_wt_b_22 = sc2mac_wt_b_mask[22] ? sc2mac_wt_b_data22 : 8'h0;
assign dbg_csc_wt_b_23 = sc2mac_wt_b_mask[23] ? sc2mac_wt_b_data23 : 8'h0;
assign dbg_csc_wt_b_24 = sc2mac_wt_b_mask[24] ? sc2mac_wt_b_data24 : 8'h0;
assign dbg_csc_wt_b_25 = sc2mac_wt_b_mask[25] ? sc2mac_wt_b_data25 : 8'h0;
assign dbg_csc_wt_b_26 = sc2mac_wt_b_mask[26] ? sc2mac_wt_b_data26 : 8'h0;
assign dbg_csc_wt_b_27 = sc2mac_wt_b_mask[27] ? sc2mac_wt_b_data27 : 8'h0;
assign dbg_csc_wt_b_28 = sc2mac_wt_b_mask[28] ? sc2mac_wt_b_data28 : 8'h0;
assign dbg_csc_wt_b_29 = sc2mac_wt_b_mask[29] ? sc2mac_wt_b_data29 : 8'h0;
assign dbg_csc_wt_b_30 = sc2mac_wt_b_mask[30] ? sc2mac_wt_b_data30 : 8'h0;
assign dbg_csc_wt_b_31 = sc2mac_wt_b_mask[31] ? sc2mac_wt_b_data31 : 8'h0;
assign dbg_csc_wt_b_32 = sc2mac_wt_b_mask[32] ? sc2mac_wt_b_data32 : 8'h0;
assign dbg_csc_wt_b_33 = sc2mac_wt_b_mask[33] ? sc2mac_wt_b_data33 : 8'h0;
assign dbg_csc_wt_b_34 = sc2mac_wt_b_mask[34] ? sc2mac_wt_b_data34 : 8'h0;
assign dbg_csc_wt_b_35 = sc2mac_wt_b_mask[35] ? sc2mac_wt_b_data35 : 8'h0;
assign dbg_csc_wt_b_36 = sc2mac_wt_b_mask[36] ? sc2mac_wt_b_data36 : 8'h0;
assign dbg_csc_wt_b_37 = sc2mac_wt_b_mask[37] ? sc2mac_wt_b_data37 : 8'h0;
assign dbg_csc_wt_b_38 = sc2mac_wt_b_mask[38] ? sc2mac_wt_b_data38 : 8'h0;
assign dbg_csc_wt_b_39 = sc2mac_wt_b_mask[39] ? sc2mac_wt_b_data39 : 8'h0;
assign dbg_csc_wt_b_40 = sc2mac_wt_b_mask[40] ? sc2mac_wt_b_data40 : 8'h0;
assign dbg_csc_wt_b_41 = sc2mac_wt_b_mask[41] ? sc2mac_wt_b_data41 : 8'h0;
assign dbg_csc_wt_b_42 = sc2mac_wt_b_mask[42] ? sc2mac_wt_b_data42 : 8'h0;
assign dbg_csc_wt_b_43 = sc2mac_wt_b_mask[43] ? sc2mac_wt_b_data43 : 8'h0;
assign dbg_csc_wt_b_44 = sc2mac_wt_b_mask[44] ? sc2mac_wt_b_data44 : 8'h0;
assign dbg_csc_wt_b_45 = sc2mac_wt_b_mask[45] ? sc2mac_wt_b_data45 : 8'h0;
assign dbg_csc_wt_b_46 = sc2mac_wt_b_mask[46] ? sc2mac_wt_b_data46 : 8'h0;
assign dbg_csc_wt_b_47 = sc2mac_wt_b_mask[47] ? sc2mac_wt_b_data47 : 8'h0;
assign dbg_csc_wt_b_48 = sc2mac_wt_b_mask[48] ? sc2mac_wt_b_data48 : 8'h0;
assign dbg_csc_wt_b_49 = sc2mac_wt_b_mask[49] ? sc2mac_wt_b_data49 : 8'h0;
assign dbg_csc_wt_b_50 = sc2mac_wt_b_mask[50] ? sc2mac_wt_b_data50 : 8'h0;
assign dbg_csc_wt_b_51 = sc2mac_wt_b_mask[51] ? sc2mac_wt_b_data51 : 8'h0;
assign dbg_csc_wt_b_52 = sc2mac_wt_b_mask[52] ? sc2mac_wt_b_data52 : 8'h0;
assign dbg_csc_wt_b_53 = sc2mac_wt_b_mask[53] ? sc2mac_wt_b_data53 : 8'h0;
assign dbg_csc_wt_b_54 = sc2mac_wt_b_mask[54] ? sc2mac_wt_b_data54 : 8'h0;
assign dbg_csc_wt_b_55 = sc2mac_wt_b_mask[55] ? sc2mac_wt_b_data55 : 8'h0;
assign dbg_csc_wt_b_56 = sc2mac_wt_b_mask[56] ? sc2mac_wt_b_data56 : 8'h0;
assign dbg_csc_wt_b_57 = sc2mac_wt_b_mask[57] ? sc2mac_wt_b_data57 : 8'h0;
assign dbg_csc_wt_b_58 = sc2mac_wt_b_mask[58] ? sc2mac_wt_b_data58 : 8'h0;
assign dbg_csc_wt_b_59 = sc2mac_wt_b_mask[59] ? sc2mac_wt_b_data59 : 8'h0;
assign dbg_csc_wt_b_60 = sc2mac_wt_b_mask[60] ? sc2mac_wt_b_data60 : 8'h0;
assign dbg_csc_wt_b_61 = sc2mac_wt_b_mask[61] ? sc2mac_wt_b_data61 : 8'h0;
assign dbg_csc_wt_b_62 = sc2mac_wt_b_mask[62] ? sc2mac_wt_b_data62 : 8'h0;
assign dbg_csc_wt_b_63 = sc2mac_wt_b_mask[63] ? sc2mac_wt_b_data63 : 8'h0;
assign dbg_csc_wt_b_64 = sc2mac_wt_b_mask[64] ? sc2mac_wt_b_data64 : 8'h0;
assign dbg_csc_wt_b_65 = sc2mac_wt_b_mask[65] ? sc2mac_wt_b_data65 : 8'h0;
assign dbg_csc_wt_b_66 = sc2mac_wt_b_mask[66] ? sc2mac_wt_b_data66 : 8'h0;
assign dbg_csc_wt_b_67 = sc2mac_wt_b_mask[67] ? sc2mac_wt_b_data67 : 8'h0;
assign dbg_csc_wt_b_68 = sc2mac_wt_b_mask[68] ? sc2mac_wt_b_data68 : 8'h0;
assign dbg_csc_wt_b_69 = sc2mac_wt_b_mask[69] ? sc2mac_wt_b_data69 : 8'h0;
assign dbg_csc_wt_b_70 = sc2mac_wt_b_mask[70] ? sc2mac_wt_b_data70 : 8'h0;
assign dbg_csc_wt_b_71 = sc2mac_wt_b_mask[71] ? sc2mac_wt_b_data71 : 8'h0;
assign dbg_csc_wt_b_72 = sc2mac_wt_b_mask[72] ? sc2mac_wt_b_data72 : 8'h0;
assign dbg_csc_wt_b_73 = sc2mac_wt_b_mask[73] ? sc2mac_wt_b_data73 : 8'h0;
assign dbg_csc_wt_b_74 = sc2mac_wt_b_mask[74] ? sc2mac_wt_b_data74 : 8'h0;
assign dbg_csc_wt_b_75 = sc2mac_wt_b_mask[75] ? sc2mac_wt_b_data75 : 8'h0;
assign dbg_csc_wt_b_76 = sc2mac_wt_b_mask[76] ? sc2mac_wt_b_data76 : 8'h0;
assign dbg_csc_wt_b_77 = sc2mac_wt_b_mask[77] ? sc2mac_wt_b_data77 : 8'h0;
assign dbg_csc_wt_b_78 = sc2mac_wt_b_mask[78] ? sc2mac_wt_b_data78 : 8'h0;
assign dbg_csc_wt_b_79 = sc2mac_wt_b_mask[79] ? sc2mac_wt_b_data79 : 8'h0;
assign dbg_csc_wt_b_80 = sc2mac_wt_b_mask[80] ? sc2mac_wt_b_data80 : 8'h0;
assign dbg_csc_wt_b_81 = sc2mac_wt_b_mask[81] ? sc2mac_wt_b_data81 : 8'h0;
assign dbg_csc_wt_b_82 = sc2mac_wt_b_mask[82] ? sc2mac_wt_b_data82 : 8'h0;
assign dbg_csc_wt_b_83 = sc2mac_wt_b_mask[83] ? sc2mac_wt_b_data83 : 8'h0;
assign dbg_csc_wt_b_84 = sc2mac_wt_b_mask[84] ? sc2mac_wt_b_data84 : 8'h0;
assign dbg_csc_wt_b_85 = sc2mac_wt_b_mask[85] ? sc2mac_wt_b_data85 : 8'h0;
assign dbg_csc_wt_b_86 = sc2mac_wt_b_mask[86] ? sc2mac_wt_b_data86 : 8'h0;
assign dbg_csc_wt_b_87 = sc2mac_wt_b_mask[87] ? sc2mac_wt_b_data87 : 8'h0;
assign dbg_csc_wt_b_88 = sc2mac_wt_b_mask[88] ? sc2mac_wt_b_data88 : 8'h0;
assign dbg_csc_wt_b_89 = sc2mac_wt_b_mask[89] ? sc2mac_wt_b_data89 : 8'h0;
assign dbg_csc_wt_b_90 = sc2mac_wt_b_mask[90] ? sc2mac_wt_b_data90 : 8'h0;
assign dbg_csc_wt_b_91 = sc2mac_wt_b_mask[91] ? sc2mac_wt_b_data91 : 8'h0;
assign dbg_csc_wt_b_92 = sc2mac_wt_b_mask[92] ? sc2mac_wt_b_data92 : 8'h0;
assign dbg_csc_wt_b_93 = sc2mac_wt_b_mask[93] ? sc2mac_wt_b_data93 : 8'h0;
assign dbg_csc_wt_b_94 = sc2mac_wt_b_mask[94] ? sc2mac_wt_b_data94 : 8'h0;
assign dbg_csc_wt_b_95 = sc2mac_wt_b_mask[95] ? sc2mac_wt_b_data95 : 8'h0;
assign dbg_csc_wt_b_96 = sc2mac_wt_b_mask[96] ? sc2mac_wt_b_data96 : 8'h0;
assign dbg_csc_wt_b_97 = sc2mac_wt_b_mask[97] ? sc2mac_wt_b_data97 : 8'h0;
assign dbg_csc_wt_b_98 = sc2mac_wt_b_mask[98] ? sc2mac_wt_b_data98 : 8'h0;
assign dbg_csc_wt_b_99 = sc2mac_wt_b_mask[99] ? sc2mac_wt_b_data99 : 8'h0;
assign dbg_csc_wt_b_100 = sc2mac_wt_b_mask[100] ? sc2mac_wt_b_data100 : 8'h0;
assign dbg_csc_wt_b_101 = sc2mac_wt_b_mask[101] ? sc2mac_wt_b_data101 : 8'h0;
assign dbg_csc_wt_b_102 = sc2mac_wt_b_mask[102] ? sc2mac_wt_b_data102 : 8'h0;
assign dbg_csc_wt_b_103 = sc2mac_wt_b_mask[103] ? sc2mac_wt_b_data103 : 8'h0;
assign dbg_csc_wt_b_104 = sc2mac_wt_b_mask[104] ? sc2mac_wt_b_data104 : 8'h0;
assign dbg_csc_wt_b_105 = sc2mac_wt_b_mask[105] ? sc2mac_wt_b_data105 : 8'h0;
assign dbg_csc_wt_b_106 = sc2mac_wt_b_mask[106] ? sc2mac_wt_b_data106 : 8'h0;
assign dbg_csc_wt_b_107 = sc2mac_wt_b_mask[107] ? sc2mac_wt_b_data107 : 8'h0;
assign dbg_csc_wt_b_108 = sc2mac_wt_b_mask[108] ? sc2mac_wt_b_data108 : 8'h0;
assign dbg_csc_wt_b_109 = sc2mac_wt_b_mask[109] ? sc2mac_wt_b_data109 : 8'h0;
assign dbg_csc_wt_b_110 = sc2mac_wt_b_mask[110] ? sc2mac_wt_b_data110 : 8'h0;
assign dbg_csc_wt_b_111 = sc2mac_wt_b_mask[111] ? sc2mac_wt_b_data111 : 8'h0;
assign dbg_csc_wt_b_112 = sc2mac_wt_b_mask[112] ? sc2mac_wt_b_data112 : 8'h0;
assign dbg_csc_wt_b_113 = sc2mac_wt_b_mask[113] ? sc2mac_wt_b_data113 : 8'h0;
assign dbg_csc_wt_b_114 = sc2mac_wt_b_mask[114] ? sc2mac_wt_b_data114 : 8'h0;
assign dbg_csc_wt_b_115 = sc2mac_wt_b_mask[115] ? sc2mac_wt_b_data115 : 8'h0;
assign dbg_csc_wt_b_116 = sc2mac_wt_b_mask[116] ? sc2mac_wt_b_data116 : 8'h0;
assign dbg_csc_wt_b_117 = sc2mac_wt_b_mask[117] ? sc2mac_wt_b_data117 : 8'h0;
assign dbg_csc_wt_b_118 = sc2mac_wt_b_mask[118] ? sc2mac_wt_b_data118 : 8'h0;
assign dbg_csc_wt_b_119 = sc2mac_wt_b_mask[119] ? sc2mac_wt_b_data119 : 8'h0;
assign dbg_csc_wt_b_120 = sc2mac_wt_b_mask[120] ? sc2mac_wt_b_data120 : 8'h0;
assign dbg_csc_wt_b_121 = sc2mac_wt_b_mask[121] ? sc2mac_wt_b_data121 : 8'h0;
assign dbg_csc_wt_b_122 = sc2mac_wt_b_mask[122] ? sc2mac_wt_b_data122 : 8'h0;
assign dbg_csc_wt_b_123 = sc2mac_wt_b_mask[123] ? sc2mac_wt_b_data123 : 8'h0;
assign dbg_csc_wt_b_124 = sc2mac_wt_b_mask[124] ? sc2mac_wt_b_data124 : 8'h0;
assign dbg_csc_wt_b_125 = sc2mac_wt_b_mask[125] ? sc2mac_wt_b_data125 : 8'h0;
assign dbg_csc_wt_b_126 = sc2mac_wt_b_mask[126] ? sc2mac_wt_b_data126 : 8'h0;
assign dbg_csc_wt_b_127 = sc2mac_wt_b_mask[127] ? sc2mac_wt_b_data127 : 8'h0;

assign dbg_csc_wt_a = {dbg_csc_wt_a_127, dbg_csc_wt_a_126, dbg_csc_wt_a_125, dbg_csc_wt_a_124, dbg_csc_wt_a_123, dbg_csc_wt_a_122, dbg_csc_wt_a_121, dbg_csc_wt_a_120, dbg_csc_wt_a_119, dbg_csc_wt_a_118, dbg_csc_wt_a_117, dbg_csc_wt_a_116, dbg_csc_wt_a_115, dbg_csc_wt_a_114, dbg_csc_wt_a_113, dbg_csc_wt_a_112, dbg_csc_wt_a_111, dbg_csc_wt_a_110, dbg_csc_wt_a_109, dbg_csc_wt_a_108, dbg_csc_wt_a_107, dbg_csc_wt_a_106, dbg_csc_wt_a_105, dbg_csc_wt_a_104, dbg_csc_wt_a_103, dbg_csc_wt_a_102, dbg_csc_wt_a_101, dbg_csc_wt_a_100, dbg_csc_wt_a_99, dbg_csc_wt_a_98, dbg_csc_wt_a_97, dbg_csc_wt_a_96, dbg_csc_wt_a_95, dbg_csc_wt_a_94, dbg_csc_wt_a_93, dbg_csc_wt_a_92, dbg_csc_wt_a_91, dbg_csc_wt_a_90, dbg_csc_wt_a_89, dbg_csc_wt_a_88, dbg_csc_wt_a_87, dbg_csc_wt_a_86, dbg_csc_wt_a_85, dbg_csc_wt_a_84, dbg_csc_wt_a_83, dbg_csc_wt_a_82, dbg_csc_wt_a_81, dbg_csc_wt_a_80, dbg_csc_wt_a_79, dbg_csc_wt_a_78, dbg_csc_wt_a_77, dbg_csc_wt_a_76, dbg_csc_wt_a_75, dbg_csc_wt_a_74, dbg_csc_wt_a_73, dbg_csc_wt_a_72, dbg_csc_wt_a_71, dbg_csc_wt_a_70, dbg_csc_wt_a_69, dbg_csc_wt_a_68, dbg_csc_wt_a_67, dbg_csc_wt_a_66, dbg_csc_wt_a_65, dbg_csc_wt_a_64, dbg_csc_wt_a_63, dbg_csc_wt_a_62, dbg_csc_wt_a_61, dbg_csc_wt_a_60, dbg_csc_wt_a_59, dbg_csc_wt_a_58, dbg_csc_wt_a_57, dbg_csc_wt_a_56, dbg_csc_wt_a_55, dbg_csc_wt_a_54, dbg_csc_wt_a_53, dbg_csc_wt_a_52, dbg_csc_wt_a_51, dbg_csc_wt_a_50, dbg_csc_wt_a_49, dbg_csc_wt_a_48, dbg_csc_wt_a_47, dbg_csc_wt_a_46, dbg_csc_wt_a_45, dbg_csc_wt_a_44, dbg_csc_wt_a_43, dbg_csc_wt_a_42, dbg_csc_wt_a_41, dbg_csc_wt_a_40, dbg_csc_wt_a_39, dbg_csc_wt_a_38, dbg_csc_wt_a_37, dbg_csc_wt_a_36, dbg_csc_wt_a_35, dbg_csc_wt_a_34, dbg_csc_wt_a_33, dbg_csc_wt_a_32, dbg_csc_wt_a_31, dbg_csc_wt_a_30, dbg_csc_wt_a_29, dbg_csc_wt_a_28, dbg_csc_wt_a_27, dbg_csc_wt_a_26, dbg_csc_wt_a_25, dbg_csc_wt_a_24, dbg_csc_wt_a_23, dbg_csc_wt_a_22, dbg_csc_wt_a_21, dbg_csc_wt_a_20, dbg_csc_wt_a_19, dbg_csc_wt_a_18, dbg_csc_wt_a_17, dbg_csc_wt_a_16, dbg_csc_wt_a_15, dbg_csc_wt_a_14, dbg_csc_wt_a_13, dbg_csc_wt_a_12, dbg_csc_wt_a_11, dbg_csc_wt_a_10, dbg_csc_wt_a_9, dbg_csc_wt_a_8, dbg_csc_wt_a_7, dbg_csc_wt_a_6, dbg_csc_wt_a_5, dbg_csc_wt_a_4, dbg_csc_wt_a_3, dbg_csc_wt_a_2, dbg_csc_wt_a_1, dbg_csc_wt_a_0};
assign dbg_csc_wt_b = {dbg_csc_wt_b_127, dbg_csc_wt_b_126, dbg_csc_wt_b_125, dbg_csc_wt_b_124, dbg_csc_wt_b_123, dbg_csc_wt_b_122, dbg_csc_wt_b_121, dbg_csc_wt_b_120, dbg_csc_wt_b_119, dbg_csc_wt_b_118, dbg_csc_wt_b_117, dbg_csc_wt_b_116, dbg_csc_wt_b_115, dbg_csc_wt_b_114, dbg_csc_wt_b_113, dbg_csc_wt_b_112, dbg_csc_wt_b_111, dbg_csc_wt_b_110, dbg_csc_wt_b_109, dbg_csc_wt_b_108, dbg_csc_wt_b_107, dbg_csc_wt_b_106, dbg_csc_wt_b_105, dbg_csc_wt_b_104, dbg_csc_wt_b_103, dbg_csc_wt_b_102, dbg_csc_wt_b_101, dbg_csc_wt_b_100, dbg_csc_wt_b_99, dbg_csc_wt_b_98, dbg_csc_wt_b_97, dbg_csc_wt_b_96, dbg_csc_wt_b_95, dbg_csc_wt_b_94, dbg_csc_wt_b_93, dbg_csc_wt_b_92, dbg_csc_wt_b_91, dbg_csc_wt_b_90, dbg_csc_wt_b_89, dbg_csc_wt_b_88, dbg_csc_wt_b_87, dbg_csc_wt_b_86, dbg_csc_wt_b_85, dbg_csc_wt_b_84, dbg_csc_wt_b_83, dbg_csc_wt_b_82, dbg_csc_wt_b_81, dbg_csc_wt_b_80, dbg_csc_wt_b_79, dbg_csc_wt_b_78, dbg_csc_wt_b_77, dbg_csc_wt_b_76, dbg_csc_wt_b_75, dbg_csc_wt_b_74, dbg_csc_wt_b_73, dbg_csc_wt_b_72, dbg_csc_wt_b_71, dbg_csc_wt_b_70, dbg_csc_wt_b_69, dbg_csc_wt_b_68, dbg_csc_wt_b_67, dbg_csc_wt_b_66, dbg_csc_wt_b_65, dbg_csc_wt_b_64, dbg_csc_wt_b_63, dbg_csc_wt_b_62, dbg_csc_wt_b_61, dbg_csc_wt_b_60, dbg_csc_wt_b_59, dbg_csc_wt_b_58, dbg_csc_wt_b_57, dbg_csc_wt_b_56, dbg_csc_wt_b_55, dbg_csc_wt_b_54, dbg_csc_wt_b_53, dbg_csc_wt_b_52, dbg_csc_wt_b_51, dbg_csc_wt_b_50, dbg_csc_wt_b_49, dbg_csc_wt_b_48, dbg_csc_wt_b_47, dbg_csc_wt_b_46, dbg_csc_wt_b_45, dbg_csc_wt_b_44, dbg_csc_wt_b_43, dbg_csc_wt_b_42, dbg_csc_wt_b_41, dbg_csc_wt_b_40, dbg_csc_wt_b_39, dbg_csc_wt_b_38, dbg_csc_wt_b_37, dbg_csc_wt_b_36, dbg_csc_wt_b_35, dbg_csc_wt_b_34, dbg_csc_wt_b_33, dbg_csc_wt_b_32, dbg_csc_wt_b_31, dbg_csc_wt_b_30, dbg_csc_wt_b_29, dbg_csc_wt_b_28, dbg_csc_wt_b_27, dbg_csc_wt_b_26, dbg_csc_wt_b_25, dbg_csc_wt_b_24, dbg_csc_wt_b_23, dbg_csc_wt_b_22, dbg_csc_wt_b_21, dbg_csc_wt_b_20, dbg_csc_wt_b_19, dbg_csc_wt_b_18, dbg_csc_wt_b_17, dbg_csc_wt_b_16, dbg_csc_wt_b_15, dbg_csc_wt_b_14, dbg_csc_wt_b_13, dbg_csc_wt_b_12, dbg_csc_wt_b_11, dbg_csc_wt_b_10, dbg_csc_wt_b_9, dbg_csc_wt_b_8, dbg_csc_wt_b_7, dbg_csc_wt_b_6, dbg_csc_wt_b_5, dbg_csc_wt_b_4, dbg_csc_wt_b_3, dbg_csc_wt_b_2, dbg_csc_wt_b_1, dbg_csc_wt_b_0};

`ifdef NVDLA_PRINT_WL
always @ (posedge nvdla_core_clk)
begin
    if(layer_st)
    begin
        $display("[NVDLA WL] layer start");
    end
end

always @ (posedge nvdla_core_clk)
begin
    if(sc2mac_wt_a_pvld)
    begin
        $display("[NVDLA WL] sc2mac_wt = %01024h", dbg_csc_wt_a);
    end
    else if (sc2mac_wt_b_pvld)
    begin
        $display("[NVDLA WL] sc2mac_wt = %01024h", dbg_csc_wt_b);
    end
end
`endif
`endif

//////////////////////////////////////////////////////////////
///// ecodonors                                          /////
//////////////////////////////////////////////////////////////
//                           wmb_element_avl[1:0]
//                           {wmb_rls_cnt_vld,sc2buf_wmb_rd_en}
//                           {wmb_req_stripe_end_d1,wmb_req_channel_end_d1}
//                           {wmb_req_group_end_d1,wmb_req_rls_d1} 
//                           {wmb_pipe_valid_d1,wmb_req_dual_d1}
//                           wmb_req_cur_sub_h_d1
//                           wt_req_ori_sft_3[1:0];

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

    property csc_wl__int8_sub_h_4_line_mode_EQ_0__0_0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((wl_pvld) && nvdla_core_rstn) |-> ((wl_cur_sub_h == 0) && (((sub_h_total == 3'h4) & is_int8_d1)));
    endproperty
    // Cover 0_0 : "(wl_cur_sub_h == 0) && (((sub_h_total == 3'h4) & is_int8_d1))"
    FUNCPOINT_csc_wl__int8_sub_h_4_line_mode_EQ_0__0_0_COV : cover property (csc_wl__int8_sub_h_4_line_mode_EQ_0__0_0_cov);

    property csc_wl__int8_sub_h_4_line_mode_EQ_1__0_1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((wl_pvld) && nvdla_core_rstn) |-> ((wl_cur_sub_h == 1) && (((sub_h_total == 3'h4) & is_int8_d1)));
    endproperty
    // Cover 0_1 : "(wl_cur_sub_h == 1) && (((sub_h_total == 3'h4) & is_int8_d1))"
    FUNCPOINT_csc_wl__int8_sub_h_4_line_mode_EQ_1__0_1_COV : cover property (csc_wl__int8_sub_h_4_line_mode_EQ_1__0_1_cov);

    property csc_wl__int8_sub_h_4_line_mode_EQ_2__0_2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((wl_pvld) && nvdla_core_rstn) |-> ((wl_cur_sub_h == 2) && (((sub_h_total == 3'h4) & is_int8_d1)));
    endproperty
    // Cover 0_2 : "(wl_cur_sub_h == 2) && (((sub_h_total == 3'h4) & is_int8_d1))"
    FUNCPOINT_csc_wl__int8_sub_h_4_line_mode_EQ_2__0_2_COV : cover property (csc_wl__int8_sub_h_4_line_mode_EQ_2__0_2_cov);

    property csc_wl__int8_sub_h_4_line_mode_EQ_3__0_3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((wl_pvld) && nvdla_core_rstn) |-> ((wl_cur_sub_h == 3) && (((sub_h_total == 3'h4) & is_int8_d1)));
    endproperty
    // Cover 0_3 : "(wl_cur_sub_h == 3) && (((sub_h_total == 3'h4) & is_int8_d1))"
    FUNCPOINT_csc_wl__int8_sub_h_4_line_mode_EQ_3__0_3_COV : cover property (csc_wl__int8_sub_h_4_line_mode_EQ_3__0_3_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property csc_wl__int8_sub_h_2_line_mode_EQ_0__1_0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((wl_pvld) && nvdla_core_rstn) |-> ((wl_cur_sub_h == 0) && (((sub_h_total == 3'h2) & is_int8_d1)));
    endproperty
    // Cover 1_0 : "(wl_cur_sub_h == 0) && (((sub_h_total == 3'h2) & is_int8_d1))"
    FUNCPOINT_csc_wl__int8_sub_h_2_line_mode_EQ_0__1_0_COV : cover property (csc_wl__int8_sub_h_2_line_mode_EQ_0__1_0_cov);

    property csc_wl__int8_sub_h_2_line_mode_EQ_1__1_1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((wl_pvld) && nvdla_core_rstn) |-> ((wl_cur_sub_h == 1) && (((sub_h_total == 3'h2) & is_int8_d1)));
    endproperty
    // Cover 1_1 : "(wl_cur_sub_h == 1) && (((sub_h_total == 3'h2) & is_int8_d1))"
    FUNCPOINT_csc_wl__int8_sub_h_2_line_mode_EQ_1__1_1_COV : cover property (csc_wl__int8_sub_h_2_line_mode_EQ_1__1_1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property csc_wl__non_int8_sub_h_4_line_mode_EQ_0__2_0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((wl_pvld) && nvdla_core_rstn) |-> ((wl_cur_sub_h == 0) && (((sub_h_total == 3'h4) & ~is_int8_d1)));
    endproperty
    // Cover 2_0 : "(wl_cur_sub_h == 0) && (((sub_h_total == 3'h4) & ~is_int8_d1))"
    FUNCPOINT_csc_wl__non_int8_sub_h_4_line_mode_EQ_0__2_0_COV : cover property (csc_wl__non_int8_sub_h_4_line_mode_EQ_0__2_0_cov);

    property csc_wl__non_int8_sub_h_4_line_mode_EQ_1__2_1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((wl_pvld) && nvdla_core_rstn) |-> ((wl_cur_sub_h == 1) && (((sub_h_total == 3'h4) & ~is_int8_d1)));
    endproperty
    // Cover 2_1 : "(wl_cur_sub_h == 1) && (((sub_h_total == 3'h4) & ~is_int8_d1))"
    FUNCPOINT_csc_wl__non_int8_sub_h_4_line_mode_EQ_1__2_1_COV : cover property (csc_wl__non_int8_sub_h_4_line_mode_EQ_1__2_1_cov);

    property csc_wl__non_int8_sub_h_4_line_mode_EQ_2__2_2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((wl_pvld) && nvdla_core_rstn) |-> ((wl_cur_sub_h == 2) && (((sub_h_total == 3'h4) & ~is_int8_d1)));
    endproperty
    // Cover 2_2 : "(wl_cur_sub_h == 2) && (((sub_h_total == 3'h4) & ~is_int8_d1))"
    FUNCPOINT_csc_wl__non_int8_sub_h_4_line_mode_EQ_2__2_2_COV : cover property (csc_wl__non_int8_sub_h_4_line_mode_EQ_2__2_2_cov);

    property csc_wl__non_int8_sub_h_4_line_mode_EQ_3__2_3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((wl_pvld) && nvdla_core_rstn) |-> ((wl_cur_sub_h == 3) && (((sub_h_total == 3'h4) & ~is_int8_d1)));
    endproperty
    // Cover 2_3 : "(wl_cur_sub_h == 3) && (((sub_h_total == 3'h4) & ~is_int8_d1))"
    FUNCPOINT_csc_wl__non_int8_sub_h_4_line_mode_EQ_3__2_3_COV : cover property (csc_wl__non_int8_sub_h_4_line_mode_EQ_3__2_3_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property csc_wl__non_int8_sub_h_2_line_mode_EQ_0__3_0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((wl_pvld) && nvdla_core_rstn) |-> ((wl_cur_sub_h == 0) && (((sub_h_total == 3'h2) & ~is_int8_d1)));
    endproperty
    // Cover 3_0 : "(wl_cur_sub_h == 0) && (((sub_h_total == 3'h2) & ~is_int8_d1))"
    FUNCPOINT_csc_wl__non_int8_sub_h_2_line_mode_EQ_0__3_0_COV : cover property (csc_wl__non_int8_sub_h_2_line_mode_EQ_0__3_0_cov);

    property csc_wl__non_int8_sub_h_2_line_mode_EQ_1__3_1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((wl_pvld) && nvdla_core_rstn) |-> ((wl_cur_sub_h == 1) && (((sub_h_total == 3'h2) & ~is_int8_d1)));
    endproperty
    // Cover 3_1 : "(wl_cur_sub_h == 1) && (((sub_h_total == 3'h2) & ~is_int8_d1))"
    FUNCPOINT_csc_wl__non_int8_sub_h_2_line_mode_EQ_1__3_1_COV : cover property (csc_wl__non_int8_sub_h_2_line_mode_EQ_1__3_1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property csc_wl__wmb_address_wraps__4_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((wmb_req_addr_reg_en) && nvdla_core_rstn) |-> ((mon_wmb_req_addr_inc & (wmb_req_addr_w == wmb_req_addr_inc)));
    endproperty
    // Cover 4 : "(mon_wmb_req_addr_inc & (wmb_req_addr_w == wmb_req_addr_inc))"
    FUNCPOINT_csc_wl__wmb_address_wraps__4_COV : cover property (csc_wl__wmb_address_wraps__4_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property csc_wl__weight_address_wraps__5_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((wt_req_addr_reg_en) && nvdla_core_rstn) |-> ((is_wr_req_addr_wrap & (wt_req_addr_w == wt_req_addr_inc_wrap)));
    endproperty
    // Cover 5 : "(is_wr_req_addr_wrap & (wt_req_addr_w == wt_req_addr_inc_wrap))"
    FUNCPOINT_csc_wl__weight_address_wraps__5_COV : cover property (csc_wl__weight_address_wraps__5_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property csc_wl__update_rlease_at_same_time__6_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        (cdma2sc_wt_updt & wt_rls);
    endproperty
    // Cover 6 : "(cdma2sc_wt_updt & wt_rls)"
    FUNCPOINT_csc_wl__update_rlease_at_same_time__6_COV : cover property (csc_wl__update_rlease_at_same_time__6_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_CSC_wl


