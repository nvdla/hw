// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_partition_m.v

module NV_NVDLA_partition_m (
   csb2cmac_a_req_pd             //|< i
  ,csb2cmac_a_req_pvld           //|< i
  ,direct_reset_                 //|< i
  ,dla_reset_rstn                //|< i
  ,global_clk_ovr_on             //|< i
  ,nvdla_clk_ovr_on              //|< i
  ,nvdla_core_clk                //|< i
  ,sc2mac_dat_data0              //|< i
  ,sc2mac_dat_data1              //|< i
  ,sc2mac_dat_data10             //|< i
  ,sc2mac_dat_data100            //|< i
  ,sc2mac_dat_data101            //|< i
  ,sc2mac_dat_data102            //|< i
  ,sc2mac_dat_data103            //|< i
  ,sc2mac_dat_data104            //|< i
  ,sc2mac_dat_data105            //|< i
  ,sc2mac_dat_data106            //|< i
  ,sc2mac_dat_data107            //|< i
  ,sc2mac_dat_data108            //|< i
  ,sc2mac_dat_data109            //|< i
  ,sc2mac_dat_data11             //|< i
  ,sc2mac_dat_data110            //|< i
  ,sc2mac_dat_data111            //|< i
  ,sc2mac_dat_data112            //|< i
  ,sc2mac_dat_data113            //|< i
  ,sc2mac_dat_data114            //|< i
  ,sc2mac_dat_data115            //|< i
  ,sc2mac_dat_data116            //|< i
  ,sc2mac_dat_data117            //|< i
  ,sc2mac_dat_data118            //|< i
  ,sc2mac_dat_data119            //|< i
  ,sc2mac_dat_data12             //|< i
  ,sc2mac_dat_data120            //|< i
  ,sc2mac_dat_data121            //|< i
  ,sc2mac_dat_data122            //|< i
  ,sc2mac_dat_data123            //|< i
  ,sc2mac_dat_data124            //|< i
  ,sc2mac_dat_data125            //|< i
  ,sc2mac_dat_data126            //|< i
  ,sc2mac_dat_data127            //|< i
  ,sc2mac_dat_data13             //|< i
  ,sc2mac_dat_data14             //|< i
  ,sc2mac_dat_data15             //|< i
  ,sc2mac_dat_data16             //|< i
  ,sc2mac_dat_data17             //|< i
  ,sc2mac_dat_data18             //|< i
  ,sc2mac_dat_data19             //|< i
  ,sc2mac_dat_data2              //|< i
  ,sc2mac_dat_data20             //|< i
  ,sc2mac_dat_data21             //|< i
  ,sc2mac_dat_data22             //|< i
  ,sc2mac_dat_data23             //|< i
  ,sc2mac_dat_data24             //|< i
  ,sc2mac_dat_data25             //|< i
  ,sc2mac_dat_data26             //|< i
  ,sc2mac_dat_data27             //|< i
  ,sc2mac_dat_data28             //|< i
  ,sc2mac_dat_data29             //|< i
  ,sc2mac_dat_data3              //|< i
  ,sc2mac_dat_data30             //|< i
  ,sc2mac_dat_data31             //|< i
  ,sc2mac_dat_data32             //|< i
  ,sc2mac_dat_data33             //|< i
  ,sc2mac_dat_data34             //|< i
  ,sc2mac_dat_data35             //|< i
  ,sc2mac_dat_data36             //|< i
  ,sc2mac_dat_data37             //|< i
  ,sc2mac_dat_data38             //|< i
  ,sc2mac_dat_data39             //|< i
  ,sc2mac_dat_data4              //|< i
  ,sc2mac_dat_data40             //|< i
  ,sc2mac_dat_data41             //|< i
  ,sc2mac_dat_data42             //|< i
  ,sc2mac_dat_data43             //|< i
  ,sc2mac_dat_data44             //|< i
  ,sc2mac_dat_data45             //|< i
  ,sc2mac_dat_data46             //|< i
  ,sc2mac_dat_data47             //|< i
  ,sc2mac_dat_data48             //|< i
  ,sc2mac_dat_data49             //|< i
  ,sc2mac_dat_data5              //|< i
  ,sc2mac_dat_data50             //|< i
  ,sc2mac_dat_data51             //|< i
  ,sc2mac_dat_data52             //|< i
  ,sc2mac_dat_data53             //|< i
  ,sc2mac_dat_data54             //|< i
  ,sc2mac_dat_data55             //|< i
  ,sc2mac_dat_data56             //|< i
  ,sc2mac_dat_data57             //|< i
  ,sc2mac_dat_data58             //|< i
  ,sc2mac_dat_data59             //|< i
  ,sc2mac_dat_data6              //|< i
  ,sc2mac_dat_data60             //|< i
  ,sc2mac_dat_data61             //|< i
  ,sc2mac_dat_data62             //|< i
  ,sc2mac_dat_data63             //|< i
  ,sc2mac_dat_data64             //|< i
  ,sc2mac_dat_data65             //|< i
  ,sc2mac_dat_data66             //|< i
  ,sc2mac_dat_data67             //|< i
  ,sc2mac_dat_data68             //|< i
  ,sc2mac_dat_data69             //|< i
  ,sc2mac_dat_data7              //|< i
  ,sc2mac_dat_data70             //|< i
  ,sc2mac_dat_data71             //|< i
  ,sc2mac_dat_data72             //|< i
  ,sc2mac_dat_data73             //|< i
  ,sc2mac_dat_data74             //|< i
  ,sc2mac_dat_data75             //|< i
  ,sc2mac_dat_data76             //|< i
  ,sc2mac_dat_data77             //|< i
  ,sc2mac_dat_data78             //|< i
  ,sc2mac_dat_data79             //|< i
  ,sc2mac_dat_data8              //|< i
  ,sc2mac_dat_data80             //|< i
  ,sc2mac_dat_data81             //|< i
  ,sc2mac_dat_data82             //|< i
  ,sc2mac_dat_data83             //|< i
  ,sc2mac_dat_data84             //|< i
  ,sc2mac_dat_data85             //|< i
  ,sc2mac_dat_data86             //|< i
  ,sc2mac_dat_data87             //|< i
  ,sc2mac_dat_data88             //|< i
  ,sc2mac_dat_data89             //|< i
  ,sc2mac_dat_data9              //|< i
  ,sc2mac_dat_data90             //|< i
  ,sc2mac_dat_data91             //|< i
  ,sc2mac_dat_data92             //|< i
  ,sc2mac_dat_data93             //|< i
  ,sc2mac_dat_data94             //|< i
  ,sc2mac_dat_data95             //|< i
  ,sc2mac_dat_data96             //|< i
  ,sc2mac_dat_data97             //|< i
  ,sc2mac_dat_data98             //|< i
  ,sc2mac_dat_data99             //|< i
  ,sc2mac_dat_mask               //|< i
  ,sc2mac_dat_pd                 //|< i
  ,sc2mac_dat_pvld               //|< i
  ,sc2mac_wt_data0               //|< i
  ,sc2mac_wt_data1               //|< i
  ,sc2mac_wt_data10              //|< i
  ,sc2mac_wt_data100             //|< i
  ,sc2mac_wt_data101             //|< i
  ,sc2mac_wt_data102             //|< i
  ,sc2mac_wt_data103             //|< i
  ,sc2mac_wt_data104             //|< i
  ,sc2mac_wt_data105             //|< i
  ,sc2mac_wt_data106             //|< i
  ,sc2mac_wt_data107             //|< i
  ,sc2mac_wt_data108             //|< i
  ,sc2mac_wt_data109             //|< i
  ,sc2mac_wt_data11              //|< i
  ,sc2mac_wt_data110             //|< i
  ,sc2mac_wt_data111             //|< i
  ,sc2mac_wt_data112             //|< i
  ,sc2mac_wt_data113             //|< i
  ,sc2mac_wt_data114             //|< i
  ,sc2mac_wt_data115             //|< i
  ,sc2mac_wt_data116             //|< i
  ,sc2mac_wt_data117             //|< i
  ,sc2mac_wt_data118             //|< i
  ,sc2mac_wt_data119             //|< i
  ,sc2mac_wt_data12              //|< i
  ,sc2mac_wt_data120             //|< i
  ,sc2mac_wt_data121             //|< i
  ,sc2mac_wt_data122             //|< i
  ,sc2mac_wt_data123             //|< i
  ,sc2mac_wt_data124             //|< i
  ,sc2mac_wt_data125             //|< i
  ,sc2mac_wt_data126             //|< i
  ,sc2mac_wt_data127             //|< i
  ,sc2mac_wt_data13              //|< i
  ,sc2mac_wt_data14              //|< i
  ,sc2mac_wt_data15              //|< i
  ,sc2mac_wt_data16              //|< i
  ,sc2mac_wt_data17              //|< i
  ,sc2mac_wt_data18              //|< i
  ,sc2mac_wt_data19              //|< i
  ,sc2mac_wt_data2               //|< i
  ,sc2mac_wt_data20              //|< i
  ,sc2mac_wt_data21              //|< i
  ,sc2mac_wt_data22              //|< i
  ,sc2mac_wt_data23              //|< i
  ,sc2mac_wt_data24              //|< i
  ,sc2mac_wt_data25              //|< i
  ,sc2mac_wt_data26              //|< i
  ,sc2mac_wt_data27              //|< i
  ,sc2mac_wt_data28              //|< i
  ,sc2mac_wt_data29              //|< i
  ,sc2mac_wt_data3               //|< i
  ,sc2mac_wt_data30              //|< i
  ,sc2mac_wt_data31              //|< i
  ,sc2mac_wt_data32              //|< i
  ,sc2mac_wt_data33              //|< i
  ,sc2mac_wt_data34              //|< i
  ,sc2mac_wt_data35              //|< i
  ,sc2mac_wt_data36              //|< i
  ,sc2mac_wt_data37              //|< i
  ,sc2mac_wt_data38              //|< i
  ,sc2mac_wt_data39              //|< i
  ,sc2mac_wt_data4               //|< i
  ,sc2mac_wt_data40              //|< i
  ,sc2mac_wt_data41              //|< i
  ,sc2mac_wt_data42              //|< i
  ,sc2mac_wt_data43              //|< i
  ,sc2mac_wt_data44              //|< i
  ,sc2mac_wt_data45              //|< i
  ,sc2mac_wt_data46              //|< i
  ,sc2mac_wt_data47              //|< i
  ,sc2mac_wt_data48              //|< i
  ,sc2mac_wt_data49              //|< i
  ,sc2mac_wt_data5               //|< i
  ,sc2mac_wt_data50              //|< i
  ,sc2mac_wt_data51              //|< i
  ,sc2mac_wt_data52              //|< i
  ,sc2mac_wt_data53              //|< i
  ,sc2mac_wt_data54              //|< i
  ,sc2mac_wt_data55              //|< i
  ,sc2mac_wt_data56              //|< i
  ,sc2mac_wt_data57              //|< i
  ,sc2mac_wt_data58              //|< i
  ,sc2mac_wt_data59              //|< i
  ,sc2mac_wt_data6               //|< i
  ,sc2mac_wt_data60              //|< i
  ,sc2mac_wt_data61              //|< i
  ,sc2mac_wt_data62              //|< i
  ,sc2mac_wt_data63              //|< i
  ,sc2mac_wt_data64              //|< i
  ,sc2mac_wt_data65              //|< i
  ,sc2mac_wt_data66              //|< i
  ,sc2mac_wt_data67              //|< i
  ,sc2mac_wt_data68              //|< i
  ,sc2mac_wt_data69              //|< i
  ,sc2mac_wt_data7               //|< i
  ,sc2mac_wt_data70              //|< i
  ,sc2mac_wt_data71              //|< i
  ,sc2mac_wt_data72              //|< i
  ,sc2mac_wt_data73              //|< i
  ,sc2mac_wt_data74              //|< i
  ,sc2mac_wt_data75              //|< i
  ,sc2mac_wt_data76              //|< i
  ,sc2mac_wt_data77              //|< i
  ,sc2mac_wt_data78              //|< i
  ,sc2mac_wt_data79              //|< i
  ,sc2mac_wt_data8               //|< i
  ,sc2mac_wt_data80              //|< i
  ,sc2mac_wt_data81              //|< i
  ,sc2mac_wt_data82              //|< i
  ,sc2mac_wt_data83              //|< i
  ,sc2mac_wt_data84              //|< i
  ,sc2mac_wt_data85              //|< i
  ,sc2mac_wt_data86              //|< i
  ,sc2mac_wt_data87              //|< i
  ,sc2mac_wt_data88              //|< i
  ,sc2mac_wt_data89              //|< i
  ,sc2mac_wt_data9               //|< i
  ,sc2mac_wt_data90              //|< i
  ,sc2mac_wt_data91              //|< i
  ,sc2mac_wt_data92              //|< i
  ,sc2mac_wt_data93              //|< i
  ,sc2mac_wt_data94              //|< i
  ,sc2mac_wt_data95              //|< i
  ,sc2mac_wt_data96              //|< i
  ,sc2mac_wt_data97              //|< i
  ,sc2mac_wt_data98              //|< i
  ,sc2mac_wt_data99              //|< i
  ,sc2mac_wt_mask                //|< i
  ,sc2mac_wt_pvld                //|< i
  ,sc2mac_wt_sel                 //|< i
  ,test_mode                     //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,cmac_a2csb_resp_pd            //|> o
  ,cmac_a2csb_resp_valid         //|> o
  ,csb2cmac_a_req_prdy           //|> o
  ,mac2accu_data0                //|> o
  ,mac2accu_data1                //|> o
  ,mac2accu_data2                //|> o
  ,mac2accu_data3                //|> o
  ,mac2accu_data4                //|> o
  ,mac2accu_data5                //|> o
  ,mac2accu_data6                //|> o
  ,mac2accu_data7                //|> o
  ,mac2accu_mask                 //|> o
  ,mac2accu_mode                 //|> o
  ,mac2accu_pd                   //|> o
  ,mac2accu_pvld                 //|> o
  );
//
// NV_NVDLA_partition_m_io.v
//

input  test_mode;
input  direct_reset_;

input         csb2cmac_a_req_pvld;  /* data valid */
output        csb2cmac_a_req_prdy;  /* data return handshake */
input  [62:0] csb2cmac_a_req_pd;

output        cmac_a2csb_resp_valid;  /* data valid */
output [33:0] cmac_a2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

input         sc2mac_wt_pvld;     /* data valid */
input [127:0] sc2mac_wt_mask;
input   [7:0] sc2mac_wt_data0;
input   [7:0] sc2mac_wt_data1;
input   [7:0] sc2mac_wt_data2;
input   [7:0] sc2mac_wt_data3;
input   [7:0] sc2mac_wt_data4;
input   [7:0] sc2mac_wt_data5;
input   [7:0] sc2mac_wt_data6;
input   [7:0] sc2mac_wt_data7;
input   [7:0] sc2mac_wt_data8;
input   [7:0] sc2mac_wt_data9;
input   [7:0] sc2mac_wt_data10;
input   [7:0] sc2mac_wt_data11;
input   [7:0] sc2mac_wt_data12;
input   [7:0] sc2mac_wt_data13;
input   [7:0] sc2mac_wt_data14;
input   [7:0] sc2mac_wt_data15;
input   [7:0] sc2mac_wt_data16;
input   [7:0] sc2mac_wt_data17;
input   [7:0] sc2mac_wt_data18;
input   [7:0] sc2mac_wt_data19;
input   [7:0] sc2mac_wt_data20;
input   [7:0] sc2mac_wt_data21;
input   [7:0] sc2mac_wt_data22;
input   [7:0] sc2mac_wt_data23;
input   [7:0] sc2mac_wt_data24;
input   [7:0] sc2mac_wt_data25;
input   [7:0] sc2mac_wt_data26;
input   [7:0] sc2mac_wt_data27;
input   [7:0] sc2mac_wt_data28;
input   [7:0] sc2mac_wt_data29;
input   [7:0] sc2mac_wt_data30;
input   [7:0] sc2mac_wt_data31;
input   [7:0] sc2mac_wt_data32;
input   [7:0] sc2mac_wt_data33;
input   [7:0] sc2mac_wt_data34;
input   [7:0] sc2mac_wt_data35;
input   [7:0] sc2mac_wt_data36;
input   [7:0] sc2mac_wt_data37;
input   [7:0] sc2mac_wt_data38;
input   [7:0] sc2mac_wt_data39;
input   [7:0] sc2mac_wt_data40;
input   [7:0] sc2mac_wt_data41;
input   [7:0] sc2mac_wt_data42;
input   [7:0] sc2mac_wt_data43;
input   [7:0] sc2mac_wt_data44;
input   [7:0] sc2mac_wt_data45;
input   [7:0] sc2mac_wt_data46;
input   [7:0] sc2mac_wt_data47;
input   [7:0] sc2mac_wt_data48;
input   [7:0] sc2mac_wt_data49;
input   [7:0] sc2mac_wt_data50;
input   [7:0] sc2mac_wt_data51;
input   [7:0] sc2mac_wt_data52;
input   [7:0] sc2mac_wt_data53;
input   [7:0] sc2mac_wt_data54;
input   [7:0] sc2mac_wt_data55;
input   [7:0] sc2mac_wt_data56;
input   [7:0] sc2mac_wt_data57;
input   [7:0] sc2mac_wt_data58;
input   [7:0] sc2mac_wt_data59;
input   [7:0] sc2mac_wt_data60;
input   [7:0] sc2mac_wt_data61;
input   [7:0] sc2mac_wt_data62;
input   [7:0] sc2mac_wt_data63;
input   [7:0] sc2mac_wt_data64;
input   [7:0] sc2mac_wt_data65;
input   [7:0] sc2mac_wt_data66;
input   [7:0] sc2mac_wt_data67;
input   [7:0] sc2mac_wt_data68;
input   [7:0] sc2mac_wt_data69;
input   [7:0] sc2mac_wt_data70;
input   [7:0] sc2mac_wt_data71;
input   [7:0] sc2mac_wt_data72;
input   [7:0] sc2mac_wt_data73;
input   [7:0] sc2mac_wt_data74;
input   [7:0] sc2mac_wt_data75;
input   [7:0] sc2mac_wt_data76;
input   [7:0] sc2mac_wt_data77;
input   [7:0] sc2mac_wt_data78;
input   [7:0] sc2mac_wt_data79;
input   [7:0] sc2mac_wt_data80;
input   [7:0] sc2mac_wt_data81;
input   [7:0] sc2mac_wt_data82;
input   [7:0] sc2mac_wt_data83;
input   [7:0] sc2mac_wt_data84;
input   [7:0] sc2mac_wt_data85;
input   [7:0] sc2mac_wt_data86;
input   [7:0] sc2mac_wt_data87;
input   [7:0] sc2mac_wt_data88;
input   [7:0] sc2mac_wt_data89;
input   [7:0] sc2mac_wt_data90;
input   [7:0] sc2mac_wt_data91;
input   [7:0] sc2mac_wt_data92;
input   [7:0] sc2mac_wt_data93;
input   [7:0] sc2mac_wt_data94;
input   [7:0] sc2mac_wt_data95;
input   [7:0] sc2mac_wt_data96;
input   [7:0] sc2mac_wt_data97;
input   [7:0] sc2mac_wt_data98;
input   [7:0] sc2mac_wt_data99;
input   [7:0] sc2mac_wt_data100;
input   [7:0] sc2mac_wt_data101;
input   [7:0] sc2mac_wt_data102;
input   [7:0] sc2mac_wt_data103;
input   [7:0] sc2mac_wt_data104;
input   [7:0] sc2mac_wt_data105;
input   [7:0] sc2mac_wt_data106;
input   [7:0] sc2mac_wt_data107;
input   [7:0] sc2mac_wt_data108;
input   [7:0] sc2mac_wt_data109;
input   [7:0] sc2mac_wt_data110;
input   [7:0] sc2mac_wt_data111;
input   [7:0] sc2mac_wt_data112;
input   [7:0] sc2mac_wt_data113;
input   [7:0] sc2mac_wt_data114;
input   [7:0] sc2mac_wt_data115;
input   [7:0] sc2mac_wt_data116;
input   [7:0] sc2mac_wt_data117;
input   [7:0] sc2mac_wt_data118;
input   [7:0] sc2mac_wt_data119;
input   [7:0] sc2mac_wt_data120;
input   [7:0] sc2mac_wt_data121;
input   [7:0] sc2mac_wt_data122;
input   [7:0] sc2mac_wt_data123;
input   [7:0] sc2mac_wt_data124;
input   [7:0] sc2mac_wt_data125;
input   [7:0] sc2mac_wt_data126;
input   [7:0] sc2mac_wt_data127;
input   [7:0] sc2mac_wt_sel;

input         sc2mac_dat_pvld;     /* data valid */
input [127:0] sc2mac_dat_mask;
input   [7:0] sc2mac_dat_data0;
input   [7:0] sc2mac_dat_data1;
input   [7:0] sc2mac_dat_data2;
input   [7:0] sc2mac_dat_data3;
input   [7:0] sc2mac_dat_data4;
input   [7:0] sc2mac_dat_data5;
input   [7:0] sc2mac_dat_data6;
input   [7:0] sc2mac_dat_data7;
input   [7:0] sc2mac_dat_data8;
input   [7:0] sc2mac_dat_data9;
input   [7:0] sc2mac_dat_data10;
input   [7:0] sc2mac_dat_data11;
input   [7:0] sc2mac_dat_data12;
input   [7:0] sc2mac_dat_data13;
input   [7:0] sc2mac_dat_data14;
input   [7:0] sc2mac_dat_data15;
input   [7:0] sc2mac_dat_data16;
input   [7:0] sc2mac_dat_data17;
input   [7:0] sc2mac_dat_data18;
input   [7:0] sc2mac_dat_data19;
input   [7:0] sc2mac_dat_data20;
input   [7:0] sc2mac_dat_data21;
input   [7:0] sc2mac_dat_data22;
input   [7:0] sc2mac_dat_data23;
input   [7:0] sc2mac_dat_data24;
input   [7:0] sc2mac_dat_data25;
input   [7:0] sc2mac_dat_data26;
input   [7:0] sc2mac_dat_data27;
input   [7:0] sc2mac_dat_data28;
input   [7:0] sc2mac_dat_data29;
input   [7:0] sc2mac_dat_data30;
input   [7:0] sc2mac_dat_data31;
input   [7:0] sc2mac_dat_data32;
input   [7:0] sc2mac_dat_data33;
input   [7:0] sc2mac_dat_data34;
input   [7:0] sc2mac_dat_data35;
input   [7:0] sc2mac_dat_data36;
input   [7:0] sc2mac_dat_data37;
input   [7:0] sc2mac_dat_data38;
input   [7:0] sc2mac_dat_data39;
input   [7:0] sc2mac_dat_data40;
input   [7:0] sc2mac_dat_data41;
input   [7:0] sc2mac_dat_data42;
input   [7:0] sc2mac_dat_data43;
input   [7:0] sc2mac_dat_data44;
input   [7:0] sc2mac_dat_data45;
input   [7:0] sc2mac_dat_data46;
input   [7:0] sc2mac_dat_data47;
input   [7:0] sc2mac_dat_data48;
input   [7:0] sc2mac_dat_data49;
input   [7:0] sc2mac_dat_data50;
input   [7:0] sc2mac_dat_data51;
input   [7:0] sc2mac_dat_data52;
input   [7:0] sc2mac_dat_data53;
input   [7:0] sc2mac_dat_data54;
input   [7:0] sc2mac_dat_data55;
input   [7:0] sc2mac_dat_data56;
input   [7:0] sc2mac_dat_data57;
input   [7:0] sc2mac_dat_data58;
input   [7:0] sc2mac_dat_data59;
input   [7:0] sc2mac_dat_data60;
input   [7:0] sc2mac_dat_data61;
input   [7:0] sc2mac_dat_data62;
input   [7:0] sc2mac_dat_data63;
input   [7:0] sc2mac_dat_data64;
input   [7:0] sc2mac_dat_data65;
input   [7:0] sc2mac_dat_data66;
input   [7:0] sc2mac_dat_data67;
input   [7:0] sc2mac_dat_data68;
input   [7:0] sc2mac_dat_data69;
input   [7:0] sc2mac_dat_data70;
input   [7:0] sc2mac_dat_data71;
input   [7:0] sc2mac_dat_data72;
input   [7:0] sc2mac_dat_data73;
input   [7:0] sc2mac_dat_data74;
input   [7:0] sc2mac_dat_data75;
input   [7:0] sc2mac_dat_data76;
input   [7:0] sc2mac_dat_data77;
input   [7:0] sc2mac_dat_data78;
input   [7:0] sc2mac_dat_data79;
input   [7:0] sc2mac_dat_data80;
input   [7:0] sc2mac_dat_data81;
input   [7:0] sc2mac_dat_data82;
input   [7:0] sc2mac_dat_data83;
input   [7:0] sc2mac_dat_data84;
input   [7:0] sc2mac_dat_data85;
input   [7:0] sc2mac_dat_data86;
input   [7:0] sc2mac_dat_data87;
input   [7:0] sc2mac_dat_data88;
input   [7:0] sc2mac_dat_data89;
input   [7:0] sc2mac_dat_data90;
input   [7:0] sc2mac_dat_data91;
input   [7:0] sc2mac_dat_data92;
input   [7:0] sc2mac_dat_data93;
input   [7:0] sc2mac_dat_data94;
input   [7:0] sc2mac_dat_data95;
input   [7:0] sc2mac_dat_data96;
input   [7:0] sc2mac_dat_data97;
input   [7:0] sc2mac_dat_data98;
input   [7:0] sc2mac_dat_data99;
input   [7:0] sc2mac_dat_data100;
input   [7:0] sc2mac_dat_data101;
input   [7:0] sc2mac_dat_data102;
input   [7:0] sc2mac_dat_data103;
input   [7:0] sc2mac_dat_data104;
input   [7:0] sc2mac_dat_data105;
input   [7:0] sc2mac_dat_data106;
input   [7:0] sc2mac_dat_data107;
input   [7:0] sc2mac_dat_data108;
input   [7:0] sc2mac_dat_data109;
input   [7:0] sc2mac_dat_data110;
input   [7:0] sc2mac_dat_data111;
input   [7:0] sc2mac_dat_data112;
input   [7:0] sc2mac_dat_data113;
input   [7:0] sc2mac_dat_data114;
input   [7:0] sc2mac_dat_data115;
input   [7:0] sc2mac_dat_data116;
input   [7:0] sc2mac_dat_data117;
input   [7:0] sc2mac_dat_data118;
input   [7:0] sc2mac_dat_data119;
input   [7:0] sc2mac_dat_data120;
input   [7:0] sc2mac_dat_data121;
input   [7:0] sc2mac_dat_data122;
input   [7:0] sc2mac_dat_data123;
input   [7:0] sc2mac_dat_data124;
input   [7:0] sc2mac_dat_data125;
input   [7:0] sc2mac_dat_data126;
input   [7:0] sc2mac_dat_data127;
input   [8:0] sc2mac_dat_pd;

output         mac2accu_pvld;   /* data valid */
output   [7:0] mac2accu_mask;
output   [7:0] mac2accu_mode;
output [175:0] mac2accu_data0;
output [175:0] mac2accu_data1;
output [175:0] mac2accu_data2;
output [175:0] mac2accu_data3;
output [175:0] mac2accu_data4;
output [175:0] mac2accu_data5;
output [175:0] mac2accu_data6;
output [175:0] mac2accu_data7;
output   [8:0] mac2accu_pd;

input  global_clk_ovr_on;
input  tmc2slcg_disable_clock_gating;

wire   dla_clk_ovr_on_sync;
wire   global_clk_ovr_on_sync;
wire   nvdla_core_rstn;

//input  la_r_clk;           
//input  larstn;             

input nvdla_core_clk;
input dla_reset_rstn;

input  nvdla_clk_ovr_on;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition M:    Reset Syncer                                //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_reset u_partition_m_reset (
   .dla_reset_rstn                (dla_reset_rstn)                //|< i
  ,.direct_reset_                 (direct_reset_)                 //|< i
  ,.test_mode                     (test_mode)                     //|< i
  ,.synced_rstn                   (nvdla_core_rstn)               //|> w
  ,.nvdla_clk                     (nvdla_core_clk)                //|< i
  );

////////////////////////////////////////////////////////////////////////
// SLCG override
////////////////////////////////////////////////////////////////////////
NV_NVDLA_sync3d u_dla_clk_ovr_on_sync (
   .clk                           (nvdla_core_clk)                //|< i
  ,.sync_i                        (nvdla_clk_ovr_on)              //|< i
  ,.sync_o                        (dla_clk_ovr_on_sync)           //|> w
  );

NV_NVDLA_sync3d_s u_global_clk_ovr_on_sync (
   .clk                           (nvdla_core_clk)                //|< i
  ,.prst                          (nvdla_core_rstn)               //|< w
  ,.sync_i                        (global_clk_ovr_on)             //|< i
  ,.sync_o                        (global_clk_ovr_on_sync)        //|> w
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition M:    Convolution MAC Array                       //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_cmac u_NV_NVDLA_cmac (
   .nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< w
  ,.cmac_a2csb_resp_valid         (cmac_a2csb_resp_valid)         //|> o
  ,.cmac_a2csb_resp_pd            (cmac_a2csb_resp_pd[33:0])      //|> o
  ,.csb2cmac_a_req_pvld           (csb2cmac_a_req_pvld)           //|< i
  ,.csb2cmac_a_req_prdy           (csb2cmac_a_req_prdy)           //|> o
  ,.csb2cmac_a_req_pd             (csb2cmac_a_req_pd[62:0])       //|< i
  ,.mac2accu_pvld                 (mac2accu_pvld)                 //|> o
  ,.mac2accu_mask                 (mac2accu_mask[7:0])            //|> o
  ,.mac2accu_mode                 (mac2accu_mode[7:0])            //|> o
  ,.mac2accu_data0                (mac2accu_data0[175:0])         //|> o
  ,.mac2accu_data1                (mac2accu_data1[175:0])         //|> o
  ,.mac2accu_data2                (mac2accu_data2[175:0])         //|> o
  ,.mac2accu_data3                (mac2accu_data3[175:0])         //|> o
  ,.mac2accu_data4                (mac2accu_data4[175:0])         //|> o
  ,.mac2accu_data5                (mac2accu_data5[175:0])         //|> o
  ,.mac2accu_data6                (mac2accu_data6[175:0])         //|> o
  ,.mac2accu_data7                (mac2accu_data7[175:0])         //|> o
  ,.mac2accu_pd                   (mac2accu_pd[8:0])              //|> o
  ,.sc2mac_dat_pvld               (sc2mac_dat_pvld)               //|< i
  ,.sc2mac_dat_mask               (sc2mac_dat_mask[127:0])        //|< i
  ,.sc2mac_dat_data0              (sc2mac_dat_data0[7:0])         //|< i
  ,.sc2mac_dat_data1              (sc2mac_dat_data1[7:0])         //|< i
  ,.sc2mac_dat_data2              (sc2mac_dat_data2[7:0])         //|< i
  ,.sc2mac_dat_data3              (sc2mac_dat_data3[7:0])         //|< i
  ,.sc2mac_dat_data4              (sc2mac_dat_data4[7:0])         //|< i
  ,.sc2mac_dat_data5              (sc2mac_dat_data5[7:0])         //|< i
  ,.sc2mac_dat_data6              (sc2mac_dat_data6[7:0])         //|< i
  ,.sc2mac_dat_data7              (sc2mac_dat_data7[7:0])         //|< i
  ,.sc2mac_dat_data8              (sc2mac_dat_data8[7:0])         //|< i
  ,.sc2mac_dat_data9              (sc2mac_dat_data9[7:0])         //|< i
  ,.sc2mac_dat_data10             (sc2mac_dat_data10[7:0])        //|< i
  ,.sc2mac_dat_data11             (sc2mac_dat_data11[7:0])        //|< i
  ,.sc2mac_dat_data12             (sc2mac_dat_data12[7:0])        //|< i
  ,.sc2mac_dat_data13             (sc2mac_dat_data13[7:0])        //|< i
  ,.sc2mac_dat_data14             (sc2mac_dat_data14[7:0])        //|< i
  ,.sc2mac_dat_data15             (sc2mac_dat_data15[7:0])        //|< i
  ,.sc2mac_dat_data16             (sc2mac_dat_data16[7:0])        //|< i
  ,.sc2mac_dat_data17             (sc2mac_dat_data17[7:0])        //|< i
  ,.sc2mac_dat_data18             (sc2mac_dat_data18[7:0])        //|< i
  ,.sc2mac_dat_data19             (sc2mac_dat_data19[7:0])        //|< i
  ,.sc2mac_dat_data20             (sc2mac_dat_data20[7:0])        //|< i
  ,.sc2mac_dat_data21             (sc2mac_dat_data21[7:0])        //|< i
  ,.sc2mac_dat_data22             (sc2mac_dat_data22[7:0])        //|< i
  ,.sc2mac_dat_data23             (sc2mac_dat_data23[7:0])        //|< i
  ,.sc2mac_dat_data24             (sc2mac_dat_data24[7:0])        //|< i
  ,.sc2mac_dat_data25             (sc2mac_dat_data25[7:0])        //|< i
  ,.sc2mac_dat_data26             (sc2mac_dat_data26[7:0])        //|< i
  ,.sc2mac_dat_data27             (sc2mac_dat_data27[7:0])        //|< i
  ,.sc2mac_dat_data28             (sc2mac_dat_data28[7:0])        //|< i
  ,.sc2mac_dat_data29             (sc2mac_dat_data29[7:0])        //|< i
  ,.sc2mac_dat_data30             (sc2mac_dat_data30[7:0])        //|< i
  ,.sc2mac_dat_data31             (sc2mac_dat_data31[7:0])        //|< i
  ,.sc2mac_dat_data32             (sc2mac_dat_data32[7:0])        //|< i
  ,.sc2mac_dat_data33             (sc2mac_dat_data33[7:0])        //|< i
  ,.sc2mac_dat_data34             (sc2mac_dat_data34[7:0])        //|< i
  ,.sc2mac_dat_data35             (sc2mac_dat_data35[7:0])        //|< i
  ,.sc2mac_dat_data36             (sc2mac_dat_data36[7:0])        //|< i
  ,.sc2mac_dat_data37             (sc2mac_dat_data37[7:0])        //|< i
  ,.sc2mac_dat_data38             (sc2mac_dat_data38[7:0])        //|< i
  ,.sc2mac_dat_data39             (sc2mac_dat_data39[7:0])        //|< i
  ,.sc2mac_dat_data40             (sc2mac_dat_data40[7:0])        //|< i
  ,.sc2mac_dat_data41             (sc2mac_dat_data41[7:0])        //|< i
  ,.sc2mac_dat_data42             (sc2mac_dat_data42[7:0])        //|< i
  ,.sc2mac_dat_data43             (sc2mac_dat_data43[7:0])        //|< i
  ,.sc2mac_dat_data44             (sc2mac_dat_data44[7:0])        //|< i
  ,.sc2mac_dat_data45             (sc2mac_dat_data45[7:0])        //|< i
  ,.sc2mac_dat_data46             (sc2mac_dat_data46[7:0])        //|< i
  ,.sc2mac_dat_data47             (sc2mac_dat_data47[7:0])        //|< i
  ,.sc2mac_dat_data48             (sc2mac_dat_data48[7:0])        //|< i
  ,.sc2mac_dat_data49             (sc2mac_dat_data49[7:0])        //|< i
  ,.sc2mac_dat_data50             (sc2mac_dat_data50[7:0])        //|< i
  ,.sc2mac_dat_data51             (sc2mac_dat_data51[7:0])        //|< i
  ,.sc2mac_dat_data52             (sc2mac_dat_data52[7:0])        //|< i
  ,.sc2mac_dat_data53             (sc2mac_dat_data53[7:0])        //|< i
  ,.sc2mac_dat_data54             (sc2mac_dat_data54[7:0])        //|< i
  ,.sc2mac_dat_data55             (sc2mac_dat_data55[7:0])        //|< i
  ,.sc2mac_dat_data56             (sc2mac_dat_data56[7:0])        //|< i
  ,.sc2mac_dat_data57             (sc2mac_dat_data57[7:0])        //|< i
  ,.sc2mac_dat_data58             (sc2mac_dat_data58[7:0])        //|< i
  ,.sc2mac_dat_data59             (sc2mac_dat_data59[7:0])        //|< i
  ,.sc2mac_dat_data60             (sc2mac_dat_data60[7:0])        //|< i
  ,.sc2mac_dat_data61             (sc2mac_dat_data61[7:0])        //|< i
  ,.sc2mac_dat_data62             (sc2mac_dat_data62[7:0])        //|< i
  ,.sc2mac_dat_data63             (sc2mac_dat_data63[7:0])        //|< i
  ,.sc2mac_dat_data64             (sc2mac_dat_data64[7:0])        //|< i
  ,.sc2mac_dat_data65             (sc2mac_dat_data65[7:0])        //|< i
  ,.sc2mac_dat_data66             (sc2mac_dat_data66[7:0])        //|< i
  ,.sc2mac_dat_data67             (sc2mac_dat_data67[7:0])        //|< i
  ,.sc2mac_dat_data68             (sc2mac_dat_data68[7:0])        //|< i
  ,.sc2mac_dat_data69             (sc2mac_dat_data69[7:0])        //|< i
  ,.sc2mac_dat_data70             (sc2mac_dat_data70[7:0])        //|< i
  ,.sc2mac_dat_data71             (sc2mac_dat_data71[7:0])        //|< i
  ,.sc2mac_dat_data72             (sc2mac_dat_data72[7:0])        //|< i
  ,.sc2mac_dat_data73             (sc2mac_dat_data73[7:0])        //|< i
  ,.sc2mac_dat_data74             (sc2mac_dat_data74[7:0])        //|< i
  ,.sc2mac_dat_data75             (sc2mac_dat_data75[7:0])        //|< i
  ,.sc2mac_dat_data76             (sc2mac_dat_data76[7:0])        //|< i
  ,.sc2mac_dat_data77             (sc2mac_dat_data77[7:0])        //|< i
  ,.sc2mac_dat_data78             (sc2mac_dat_data78[7:0])        //|< i
  ,.sc2mac_dat_data79             (sc2mac_dat_data79[7:0])        //|< i
  ,.sc2mac_dat_data80             (sc2mac_dat_data80[7:0])        //|< i
  ,.sc2mac_dat_data81             (sc2mac_dat_data81[7:0])        //|< i
  ,.sc2mac_dat_data82             (sc2mac_dat_data82[7:0])        //|< i
  ,.sc2mac_dat_data83             (sc2mac_dat_data83[7:0])        //|< i
  ,.sc2mac_dat_data84             (sc2mac_dat_data84[7:0])        //|< i
  ,.sc2mac_dat_data85             (sc2mac_dat_data85[7:0])        //|< i
  ,.sc2mac_dat_data86             (sc2mac_dat_data86[7:0])        //|< i
  ,.sc2mac_dat_data87             (sc2mac_dat_data87[7:0])        //|< i
  ,.sc2mac_dat_data88             (sc2mac_dat_data88[7:0])        //|< i
  ,.sc2mac_dat_data89             (sc2mac_dat_data89[7:0])        //|< i
  ,.sc2mac_dat_data90             (sc2mac_dat_data90[7:0])        //|< i
  ,.sc2mac_dat_data91             (sc2mac_dat_data91[7:0])        //|< i
  ,.sc2mac_dat_data92             (sc2mac_dat_data92[7:0])        //|< i
  ,.sc2mac_dat_data93             (sc2mac_dat_data93[7:0])        //|< i
  ,.sc2mac_dat_data94             (sc2mac_dat_data94[7:0])        //|< i
  ,.sc2mac_dat_data95             (sc2mac_dat_data95[7:0])        //|< i
  ,.sc2mac_dat_data96             (sc2mac_dat_data96[7:0])        //|< i
  ,.sc2mac_dat_data97             (sc2mac_dat_data97[7:0])        //|< i
  ,.sc2mac_dat_data98             (sc2mac_dat_data98[7:0])        //|< i
  ,.sc2mac_dat_data99             (sc2mac_dat_data99[7:0])        //|< i
  ,.sc2mac_dat_data100            (sc2mac_dat_data100[7:0])       //|< i
  ,.sc2mac_dat_data101            (sc2mac_dat_data101[7:0])       //|< i
  ,.sc2mac_dat_data102            (sc2mac_dat_data102[7:0])       //|< i
  ,.sc2mac_dat_data103            (sc2mac_dat_data103[7:0])       //|< i
  ,.sc2mac_dat_data104            (sc2mac_dat_data104[7:0])       //|< i
  ,.sc2mac_dat_data105            (sc2mac_dat_data105[7:0])       //|< i
  ,.sc2mac_dat_data106            (sc2mac_dat_data106[7:0])       //|< i
  ,.sc2mac_dat_data107            (sc2mac_dat_data107[7:0])       //|< i
  ,.sc2mac_dat_data108            (sc2mac_dat_data108[7:0])       //|< i
  ,.sc2mac_dat_data109            (sc2mac_dat_data109[7:0])       //|< i
  ,.sc2mac_dat_data110            (sc2mac_dat_data110[7:0])       //|< i
  ,.sc2mac_dat_data111            (sc2mac_dat_data111[7:0])       //|< i
  ,.sc2mac_dat_data112            (sc2mac_dat_data112[7:0])       //|< i
  ,.sc2mac_dat_data113            (sc2mac_dat_data113[7:0])       //|< i
  ,.sc2mac_dat_data114            (sc2mac_dat_data114[7:0])       //|< i
  ,.sc2mac_dat_data115            (sc2mac_dat_data115[7:0])       //|< i
  ,.sc2mac_dat_data116            (sc2mac_dat_data116[7:0])       //|< i
  ,.sc2mac_dat_data117            (sc2mac_dat_data117[7:0])       //|< i
  ,.sc2mac_dat_data118            (sc2mac_dat_data118[7:0])       //|< i
  ,.sc2mac_dat_data119            (sc2mac_dat_data119[7:0])       //|< i
  ,.sc2mac_dat_data120            (sc2mac_dat_data120[7:0])       //|< i
  ,.sc2mac_dat_data121            (sc2mac_dat_data121[7:0])       //|< i
  ,.sc2mac_dat_data122            (sc2mac_dat_data122[7:0])       //|< i
  ,.sc2mac_dat_data123            (sc2mac_dat_data123[7:0])       //|< i
  ,.sc2mac_dat_data124            (sc2mac_dat_data124[7:0])       //|< i
  ,.sc2mac_dat_data125            (sc2mac_dat_data125[7:0])       //|< i
  ,.sc2mac_dat_data126            (sc2mac_dat_data126[7:0])       //|< i
  ,.sc2mac_dat_data127            (sc2mac_dat_data127[7:0])       //|< i
  ,.sc2mac_dat_pd                 (sc2mac_dat_pd[8:0])            //|< i
  ,.sc2mac_wt_pvld                (sc2mac_wt_pvld)                //|< i
  ,.sc2mac_wt_mask                (sc2mac_wt_mask[127:0])         //|< i
  ,.sc2mac_wt_data0               (sc2mac_wt_data0[7:0])          //|< i
  ,.sc2mac_wt_data1               (sc2mac_wt_data1[7:0])          //|< i
  ,.sc2mac_wt_data2               (sc2mac_wt_data2[7:0])          //|< i
  ,.sc2mac_wt_data3               (sc2mac_wt_data3[7:0])          //|< i
  ,.sc2mac_wt_data4               (sc2mac_wt_data4[7:0])          //|< i
  ,.sc2mac_wt_data5               (sc2mac_wt_data5[7:0])          //|< i
  ,.sc2mac_wt_data6               (sc2mac_wt_data6[7:0])          //|< i
  ,.sc2mac_wt_data7               (sc2mac_wt_data7[7:0])          //|< i
  ,.sc2mac_wt_data8               (sc2mac_wt_data8[7:0])          //|< i
  ,.sc2mac_wt_data9               (sc2mac_wt_data9[7:0])          //|< i
  ,.sc2mac_wt_data10              (sc2mac_wt_data10[7:0])         //|< i
  ,.sc2mac_wt_data11              (sc2mac_wt_data11[7:0])         //|< i
  ,.sc2mac_wt_data12              (sc2mac_wt_data12[7:0])         //|< i
  ,.sc2mac_wt_data13              (sc2mac_wt_data13[7:0])         //|< i
  ,.sc2mac_wt_data14              (sc2mac_wt_data14[7:0])         //|< i
  ,.sc2mac_wt_data15              (sc2mac_wt_data15[7:0])         //|< i
  ,.sc2mac_wt_data16              (sc2mac_wt_data16[7:0])         //|< i
  ,.sc2mac_wt_data17              (sc2mac_wt_data17[7:0])         //|< i
  ,.sc2mac_wt_data18              (sc2mac_wt_data18[7:0])         //|< i
  ,.sc2mac_wt_data19              (sc2mac_wt_data19[7:0])         //|< i
  ,.sc2mac_wt_data20              (sc2mac_wt_data20[7:0])         //|< i
  ,.sc2mac_wt_data21              (sc2mac_wt_data21[7:0])         //|< i
  ,.sc2mac_wt_data22              (sc2mac_wt_data22[7:0])         //|< i
  ,.sc2mac_wt_data23              (sc2mac_wt_data23[7:0])         //|< i
  ,.sc2mac_wt_data24              (sc2mac_wt_data24[7:0])         //|< i
  ,.sc2mac_wt_data25              (sc2mac_wt_data25[7:0])         //|< i
  ,.sc2mac_wt_data26              (sc2mac_wt_data26[7:0])         //|< i
  ,.sc2mac_wt_data27              (sc2mac_wt_data27[7:0])         //|< i
  ,.sc2mac_wt_data28              (sc2mac_wt_data28[7:0])         //|< i
  ,.sc2mac_wt_data29              (sc2mac_wt_data29[7:0])         //|< i
  ,.sc2mac_wt_data30              (sc2mac_wt_data30[7:0])         //|< i
  ,.sc2mac_wt_data31              (sc2mac_wt_data31[7:0])         //|< i
  ,.sc2mac_wt_data32              (sc2mac_wt_data32[7:0])         //|< i
  ,.sc2mac_wt_data33              (sc2mac_wt_data33[7:0])         //|< i
  ,.sc2mac_wt_data34              (sc2mac_wt_data34[7:0])         //|< i
  ,.sc2mac_wt_data35              (sc2mac_wt_data35[7:0])         //|< i
  ,.sc2mac_wt_data36              (sc2mac_wt_data36[7:0])         //|< i
  ,.sc2mac_wt_data37              (sc2mac_wt_data37[7:0])         //|< i
  ,.sc2mac_wt_data38              (sc2mac_wt_data38[7:0])         //|< i
  ,.sc2mac_wt_data39              (sc2mac_wt_data39[7:0])         //|< i
  ,.sc2mac_wt_data40              (sc2mac_wt_data40[7:0])         //|< i
  ,.sc2mac_wt_data41              (sc2mac_wt_data41[7:0])         //|< i
  ,.sc2mac_wt_data42              (sc2mac_wt_data42[7:0])         //|< i
  ,.sc2mac_wt_data43              (sc2mac_wt_data43[7:0])         //|< i
  ,.sc2mac_wt_data44              (sc2mac_wt_data44[7:0])         //|< i
  ,.sc2mac_wt_data45              (sc2mac_wt_data45[7:0])         //|< i
  ,.sc2mac_wt_data46              (sc2mac_wt_data46[7:0])         //|< i
  ,.sc2mac_wt_data47              (sc2mac_wt_data47[7:0])         //|< i
  ,.sc2mac_wt_data48              (sc2mac_wt_data48[7:0])         //|< i
  ,.sc2mac_wt_data49              (sc2mac_wt_data49[7:0])         //|< i
  ,.sc2mac_wt_data50              (sc2mac_wt_data50[7:0])         //|< i
  ,.sc2mac_wt_data51              (sc2mac_wt_data51[7:0])         //|< i
  ,.sc2mac_wt_data52              (sc2mac_wt_data52[7:0])         //|< i
  ,.sc2mac_wt_data53              (sc2mac_wt_data53[7:0])         //|< i
  ,.sc2mac_wt_data54              (sc2mac_wt_data54[7:0])         //|< i
  ,.sc2mac_wt_data55              (sc2mac_wt_data55[7:0])         //|< i
  ,.sc2mac_wt_data56              (sc2mac_wt_data56[7:0])         //|< i
  ,.sc2mac_wt_data57              (sc2mac_wt_data57[7:0])         //|< i
  ,.sc2mac_wt_data58              (sc2mac_wt_data58[7:0])         //|< i
  ,.sc2mac_wt_data59              (sc2mac_wt_data59[7:0])         //|< i
  ,.sc2mac_wt_data60              (sc2mac_wt_data60[7:0])         //|< i
  ,.sc2mac_wt_data61              (sc2mac_wt_data61[7:0])         //|< i
  ,.sc2mac_wt_data62              (sc2mac_wt_data62[7:0])         //|< i
  ,.sc2mac_wt_data63              (sc2mac_wt_data63[7:0])         //|< i
  ,.sc2mac_wt_data64              (sc2mac_wt_data64[7:0])         //|< i
  ,.sc2mac_wt_data65              (sc2mac_wt_data65[7:0])         //|< i
  ,.sc2mac_wt_data66              (sc2mac_wt_data66[7:0])         //|< i
  ,.sc2mac_wt_data67              (sc2mac_wt_data67[7:0])         //|< i
  ,.sc2mac_wt_data68              (sc2mac_wt_data68[7:0])         //|< i
  ,.sc2mac_wt_data69              (sc2mac_wt_data69[7:0])         //|< i
  ,.sc2mac_wt_data70              (sc2mac_wt_data70[7:0])         //|< i
  ,.sc2mac_wt_data71              (sc2mac_wt_data71[7:0])         //|< i
  ,.sc2mac_wt_data72              (sc2mac_wt_data72[7:0])         //|< i
  ,.sc2mac_wt_data73              (sc2mac_wt_data73[7:0])         //|< i
  ,.sc2mac_wt_data74              (sc2mac_wt_data74[7:0])         //|< i
  ,.sc2mac_wt_data75              (sc2mac_wt_data75[7:0])         //|< i
  ,.sc2mac_wt_data76              (sc2mac_wt_data76[7:0])         //|< i
  ,.sc2mac_wt_data77              (sc2mac_wt_data77[7:0])         //|< i
  ,.sc2mac_wt_data78              (sc2mac_wt_data78[7:0])         //|< i
  ,.sc2mac_wt_data79              (sc2mac_wt_data79[7:0])         //|< i
  ,.sc2mac_wt_data80              (sc2mac_wt_data80[7:0])         //|< i
  ,.sc2mac_wt_data81              (sc2mac_wt_data81[7:0])         //|< i
  ,.sc2mac_wt_data82              (sc2mac_wt_data82[7:0])         //|< i
  ,.sc2mac_wt_data83              (sc2mac_wt_data83[7:0])         //|< i
  ,.sc2mac_wt_data84              (sc2mac_wt_data84[7:0])         //|< i
  ,.sc2mac_wt_data85              (sc2mac_wt_data85[7:0])         //|< i
  ,.sc2mac_wt_data86              (sc2mac_wt_data86[7:0])         //|< i
  ,.sc2mac_wt_data87              (sc2mac_wt_data87[7:0])         //|< i
  ,.sc2mac_wt_data88              (sc2mac_wt_data88[7:0])         //|< i
  ,.sc2mac_wt_data89              (sc2mac_wt_data89[7:0])         //|< i
  ,.sc2mac_wt_data90              (sc2mac_wt_data90[7:0])         //|< i
  ,.sc2mac_wt_data91              (sc2mac_wt_data91[7:0])         //|< i
  ,.sc2mac_wt_data92              (sc2mac_wt_data92[7:0])         //|< i
  ,.sc2mac_wt_data93              (sc2mac_wt_data93[7:0])         //|< i
  ,.sc2mac_wt_data94              (sc2mac_wt_data94[7:0])         //|< i
  ,.sc2mac_wt_data95              (sc2mac_wt_data95[7:0])         //|< i
  ,.sc2mac_wt_data96              (sc2mac_wt_data96[7:0])         //|< i
  ,.sc2mac_wt_data97              (sc2mac_wt_data97[7:0])         //|< i
  ,.sc2mac_wt_data98              (sc2mac_wt_data98[7:0])         //|< i
  ,.sc2mac_wt_data99              (sc2mac_wt_data99[7:0])         //|< i
  ,.sc2mac_wt_data100             (sc2mac_wt_data100[7:0])        //|< i
  ,.sc2mac_wt_data101             (sc2mac_wt_data101[7:0])        //|< i
  ,.sc2mac_wt_data102             (sc2mac_wt_data102[7:0])        //|< i
  ,.sc2mac_wt_data103             (sc2mac_wt_data103[7:0])        //|< i
  ,.sc2mac_wt_data104             (sc2mac_wt_data104[7:0])        //|< i
  ,.sc2mac_wt_data105             (sc2mac_wt_data105[7:0])        //|< i
  ,.sc2mac_wt_data106             (sc2mac_wt_data106[7:0])        //|< i
  ,.sc2mac_wt_data107             (sc2mac_wt_data107[7:0])        //|< i
  ,.sc2mac_wt_data108             (sc2mac_wt_data108[7:0])        //|< i
  ,.sc2mac_wt_data109             (sc2mac_wt_data109[7:0])        //|< i
  ,.sc2mac_wt_data110             (sc2mac_wt_data110[7:0])        //|< i
  ,.sc2mac_wt_data111             (sc2mac_wt_data111[7:0])        //|< i
  ,.sc2mac_wt_data112             (sc2mac_wt_data112[7:0])        //|< i
  ,.sc2mac_wt_data113             (sc2mac_wt_data113[7:0])        //|< i
  ,.sc2mac_wt_data114             (sc2mac_wt_data114[7:0])        //|< i
  ,.sc2mac_wt_data115             (sc2mac_wt_data115[7:0])        //|< i
  ,.sc2mac_wt_data116             (sc2mac_wt_data116[7:0])        //|< i
  ,.sc2mac_wt_data117             (sc2mac_wt_data117[7:0])        //|< i
  ,.sc2mac_wt_data118             (sc2mac_wt_data118[7:0])        //|< i
  ,.sc2mac_wt_data119             (sc2mac_wt_data119[7:0])        //|< i
  ,.sc2mac_wt_data120             (sc2mac_wt_data120[7:0])        //|< i
  ,.sc2mac_wt_data121             (sc2mac_wt_data121[7:0])        //|< i
  ,.sc2mac_wt_data122             (sc2mac_wt_data122[7:0])        //|< i
  ,.sc2mac_wt_data123             (sc2mac_wt_data123[7:0])        //|< i
  ,.sc2mac_wt_data124             (sc2mac_wt_data124[7:0])        //|< i
  ,.sc2mac_wt_data125             (sc2mac_wt_data125[7:0])        //|< i
  ,.sc2mac_wt_data126             (sc2mac_wt_data126[7:0])        //|< i
  ,.sc2mac_wt_data127             (sc2mac_wt_data127[7:0])        //|< i
  ,.sc2mac_wt_sel                 (sc2mac_wt_sel[7:0])            //|< i
  ,.dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< w
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition M:    OBS                                         //
////////////////////////////////////////////////////////////////////////
//&Instance NV_NVDLA_M_obs;

////////////////////////////////////////////////////////////////////////
//  Dangles/Contenders report                                         //
////////////////////////////////////////////////////////////////////////

//|
//|
//|
//|

endmodule // NV_NVDLA_partition_m

