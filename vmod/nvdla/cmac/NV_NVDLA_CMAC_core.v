// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CMAC_core.v

module NV_NVDLA_CMAC_core (
   nvdla_core_clk                //|< i
  ,nvdla_core_rstn               //|< i
  ,dla_clk_ovr_on_sync           //|< i
  ,global_clk_ovr_on_sync        //|< i
  ,reg2dp_conv_mode              //|< i
  ,reg2dp_op_en                  //|< i
  ,reg2dp_proc_precision         //|< i
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
  ,slcg_op_en                    //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,dp2reg_done                   //|> o
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
// NV_NVDLA_CMAC_core_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

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


input   [0:0]             reg2dp_op_en;
input   [0:0]          reg2dp_conv_mode;
input   [1:0]     reg2dp_proc_precision;
output                                                          dp2reg_done;

//Port for SLCG
input   dla_clk_ovr_on_sync;
input   global_clk_ovr_on_sync;
input   tmc2slcg_disable_clock_gating;
input   [10:0]  slcg_op_en;

wire          cfg_is_fp16;
wire          cfg_is_int16;
wire          cfg_is_int8;
wire          cfg_is_wg;
wire          cfg_reg_en;
wire [1023:0] dat0_actv_data;
wire   [63:0] dat0_actv_nan;
wire  [127:0] dat0_actv_nz;
wire  [103:0] dat0_actv_pvld;
wire  [191:0] dat0_pre_exp;
wire   [63:0] dat0_pre_mask;
wire          dat0_pre_pvld;
wire          dat0_pre_stripe_end;
wire          dat0_pre_stripe_st;
wire [1023:0] dat1_actv_data;
wire   [63:0] dat1_actv_nan;
wire  [127:0] dat1_actv_nz;
wire  [103:0] dat1_actv_pvld;
wire  [191:0] dat1_pre_exp;
wire   [63:0] dat1_pre_mask;
wire          dat1_pre_pvld;
wire          dat1_pre_stripe_end;
wire          dat1_pre_stripe_st;
wire [1023:0] dat2_actv_data;
wire   [63:0] dat2_actv_nan;
wire  [127:0] dat2_actv_nz;
wire  [103:0] dat2_actv_pvld;
wire  [191:0] dat2_pre_exp;
wire   [63:0] dat2_pre_mask;
wire          dat2_pre_pvld;
wire          dat2_pre_stripe_end;
wire          dat2_pre_stripe_st;
wire [1023:0] dat3_actv_data;
wire   [63:0] dat3_actv_nan;
wire  [127:0] dat3_actv_nz;
wire  [103:0] dat3_actv_pvld;
wire  [191:0] dat3_pre_exp;
wire   [63:0] dat3_pre_mask;
wire          dat3_pre_pvld;
wire          dat3_pre_stripe_end;
wire          dat3_pre_stripe_st;
wire [1023:0] dat4_actv_data;
wire   [63:0] dat4_actv_nan;
wire  [127:0] dat4_actv_nz;
wire  [103:0] dat4_actv_pvld;
wire  [191:0] dat4_pre_exp;
wire   [63:0] dat4_pre_mask;
wire          dat4_pre_pvld;
wire          dat4_pre_stripe_end;
wire          dat4_pre_stripe_st;
wire [1023:0] dat5_actv_data;
wire   [63:0] dat5_actv_nan;
wire  [127:0] dat5_actv_nz;
wire  [103:0] dat5_actv_pvld;
wire  [191:0] dat5_pre_exp;
wire   [63:0] dat5_pre_mask;
wire          dat5_pre_pvld;
wire          dat5_pre_stripe_end;
wire          dat5_pre_stripe_st;
wire [1023:0] dat6_actv_data;
wire   [63:0] dat6_actv_nan;
wire  [127:0] dat6_actv_nz;
wire  [103:0] dat6_actv_pvld;
wire  [191:0] dat6_pre_exp;
wire   [63:0] dat6_pre_mask;
wire          dat6_pre_pvld;
wire          dat6_pre_stripe_end;
wire          dat6_pre_stripe_st;
wire [1023:0] dat7_actv_data;
wire   [63:0] dat7_actv_nan;
wire  [127:0] dat7_actv_nz;
wire  [103:0] dat7_actv_pvld;
wire  [191:0] dat7_pre_exp;
wire   [63:0] dat7_pre_mask;
wire          dat7_pre_pvld;
wire          dat7_pre_stripe_end;
wire          dat7_pre_stripe_st;
`ifndef SYNTHESIS
wire    [8:0] dbg_mac2accu_pd;
wire          dbg_mac2accu_pvld;
wire    [8:0] dbg_out_pd_d0;
wire          dbg_out_pvld_d0;
`endif
wire    [7:0] in_dat_data0;
wire    [7:0] in_dat_data1;
wire    [7:0] in_dat_data10;
wire    [7:0] in_dat_data100;
wire    [7:0] in_dat_data101;
wire    [7:0] in_dat_data102;
wire    [7:0] in_dat_data103;
wire    [7:0] in_dat_data104;
wire    [7:0] in_dat_data105;
wire    [7:0] in_dat_data106;
wire    [7:0] in_dat_data107;
wire    [7:0] in_dat_data108;
wire    [7:0] in_dat_data109;
wire    [7:0] in_dat_data11;
wire    [7:0] in_dat_data110;
wire    [7:0] in_dat_data111;
wire    [7:0] in_dat_data112;
wire    [7:0] in_dat_data113;
wire    [7:0] in_dat_data114;
wire    [7:0] in_dat_data115;
wire    [7:0] in_dat_data116;
wire    [7:0] in_dat_data117;
wire    [7:0] in_dat_data118;
wire    [7:0] in_dat_data119;
wire    [7:0] in_dat_data12;
wire    [7:0] in_dat_data120;
wire    [7:0] in_dat_data121;
wire    [7:0] in_dat_data122;
wire    [7:0] in_dat_data123;
wire    [7:0] in_dat_data124;
wire    [7:0] in_dat_data125;
wire    [7:0] in_dat_data126;
wire    [7:0] in_dat_data127;
wire    [7:0] in_dat_data13;
wire    [7:0] in_dat_data14;
wire    [7:0] in_dat_data15;
wire    [7:0] in_dat_data16;
wire    [7:0] in_dat_data17;
wire    [7:0] in_dat_data18;
wire    [7:0] in_dat_data19;
wire    [7:0] in_dat_data2;
wire    [7:0] in_dat_data20;
wire    [7:0] in_dat_data21;
wire    [7:0] in_dat_data22;
wire    [7:0] in_dat_data23;
wire    [7:0] in_dat_data24;
wire    [7:0] in_dat_data25;
wire    [7:0] in_dat_data26;
wire    [7:0] in_dat_data27;
wire    [7:0] in_dat_data28;
wire    [7:0] in_dat_data29;
wire    [7:0] in_dat_data3;
wire    [7:0] in_dat_data30;
wire    [7:0] in_dat_data31;
wire    [7:0] in_dat_data32;
wire    [7:0] in_dat_data33;
wire    [7:0] in_dat_data34;
wire    [7:0] in_dat_data35;
wire    [7:0] in_dat_data36;
wire    [7:0] in_dat_data37;
wire    [7:0] in_dat_data38;
wire    [7:0] in_dat_data39;
wire    [7:0] in_dat_data4;
wire    [7:0] in_dat_data40;
wire    [7:0] in_dat_data41;
wire    [7:0] in_dat_data42;
wire    [7:0] in_dat_data43;
wire    [7:0] in_dat_data44;
wire    [7:0] in_dat_data45;
wire    [7:0] in_dat_data46;
wire    [7:0] in_dat_data47;
wire    [7:0] in_dat_data48;
wire    [7:0] in_dat_data49;
wire    [7:0] in_dat_data5;
wire    [7:0] in_dat_data50;
wire    [7:0] in_dat_data51;
wire    [7:0] in_dat_data52;
wire    [7:0] in_dat_data53;
wire    [7:0] in_dat_data54;
wire    [7:0] in_dat_data55;
wire    [7:0] in_dat_data56;
wire    [7:0] in_dat_data57;
wire    [7:0] in_dat_data58;
wire    [7:0] in_dat_data59;
wire    [7:0] in_dat_data6;
wire    [7:0] in_dat_data60;
wire    [7:0] in_dat_data61;
wire    [7:0] in_dat_data62;
wire    [7:0] in_dat_data63;
wire    [7:0] in_dat_data64;
wire    [7:0] in_dat_data65;
wire    [7:0] in_dat_data66;
wire    [7:0] in_dat_data67;
wire    [7:0] in_dat_data68;
wire    [7:0] in_dat_data69;
wire    [7:0] in_dat_data7;
wire    [7:0] in_dat_data70;
wire    [7:0] in_dat_data71;
wire    [7:0] in_dat_data72;
wire    [7:0] in_dat_data73;
wire    [7:0] in_dat_data74;
wire    [7:0] in_dat_data75;
wire    [7:0] in_dat_data76;
wire    [7:0] in_dat_data77;
wire    [7:0] in_dat_data78;
wire    [7:0] in_dat_data79;
wire    [7:0] in_dat_data8;
wire    [7:0] in_dat_data80;
wire    [7:0] in_dat_data81;
wire    [7:0] in_dat_data82;
wire    [7:0] in_dat_data83;
wire    [7:0] in_dat_data84;
wire    [7:0] in_dat_data85;
wire    [7:0] in_dat_data86;
wire    [7:0] in_dat_data87;
wire    [7:0] in_dat_data88;
wire    [7:0] in_dat_data89;
wire    [7:0] in_dat_data9;
wire    [7:0] in_dat_data90;
wire    [7:0] in_dat_data91;
wire    [7:0] in_dat_data92;
wire    [7:0] in_dat_data93;
wire    [7:0] in_dat_data94;
wire    [7:0] in_dat_data95;
wire    [7:0] in_dat_data96;
wire    [7:0] in_dat_data97;
wire    [7:0] in_dat_data98;
wire    [7:0] in_dat_data99;
wire  [127:0] in_dat_mask;
wire    [8:0] in_dat_pd;
wire          in_dat_pvld;
wire          in_dat_stripe_end;
wire          in_dat_stripe_st;
wire    [7:0] in_wt_data0;
wire    [7:0] in_wt_data1;
wire    [7:0] in_wt_data10;
wire    [7:0] in_wt_data100;
wire    [7:0] in_wt_data101;
wire    [7:0] in_wt_data102;
wire    [7:0] in_wt_data103;
wire    [7:0] in_wt_data104;
wire    [7:0] in_wt_data105;
wire    [7:0] in_wt_data106;
wire    [7:0] in_wt_data107;
wire    [7:0] in_wt_data108;
wire    [7:0] in_wt_data109;
wire    [7:0] in_wt_data11;
wire    [7:0] in_wt_data110;
wire    [7:0] in_wt_data111;
wire    [7:0] in_wt_data112;
wire    [7:0] in_wt_data113;
wire    [7:0] in_wt_data114;
wire    [7:0] in_wt_data115;
wire    [7:0] in_wt_data116;
wire    [7:0] in_wt_data117;
wire    [7:0] in_wt_data118;
wire    [7:0] in_wt_data119;
wire    [7:0] in_wt_data12;
wire    [7:0] in_wt_data120;
wire    [7:0] in_wt_data121;
wire    [7:0] in_wt_data122;
wire    [7:0] in_wt_data123;
wire    [7:0] in_wt_data124;
wire    [7:0] in_wt_data125;
wire    [7:0] in_wt_data126;
wire    [7:0] in_wt_data127;
wire    [7:0] in_wt_data13;
wire    [7:0] in_wt_data14;
wire    [7:0] in_wt_data15;
wire    [7:0] in_wt_data16;
wire    [7:0] in_wt_data17;
wire    [7:0] in_wt_data18;
wire    [7:0] in_wt_data19;
wire    [7:0] in_wt_data2;
wire    [7:0] in_wt_data20;
wire    [7:0] in_wt_data21;
wire    [7:0] in_wt_data22;
wire    [7:0] in_wt_data23;
wire    [7:0] in_wt_data24;
wire    [7:0] in_wt_data25;
wire    [7:0] in_wt_data26;
wire    [7:0] in_wt_data27;
wire    [7:0] in_wt_data28;
wire    [7:0] in_wt_data29;
wire    [7:0] in_wt_data3;
wire    [7:0] in_wt_data30;
wire    [7:0] in_wt_data31;
wire    [7:0] in_wt_data32;
wire    [7:0] in_wt_data33;
wire    [7:0] in_wt_data34;
wire    [7:0] in_wt_data35;
wire    [7:0] in_wt_data36;
wire    [7:0] in_wt_data37;
wire    [7:0] in_wt_data38;
wire    [7:0] in_wt_data39;
wire    [7:0] in_wt_data4;
wire    [7:0] in_wt_data40;
wire    [7:0] in_wt_data41;
wire    [7:0] in_wt_data42;
wire    [7:0] in_wt_data43;
wire    [7:0] in_wt_data44;
wire    [7:0] in_wt_data45;
wire    [7:0] in_wt_data46;
wire    [7:0] in_wt_data47;
wire    [7:0] in_wt_data48;
wire    [7:0] in_wt_data49;
wire    [7:0] in_wt_data5;
wire    [7:0] in_wt_data50;
wire    [7:0] in_wt_data51;
wire    [7:0] in_wt_data52;
wire    [7:0] in_wt_data53;
wire    [7:0] in_wt_data54;
wire    [7:0] in_wt_data55;
wire    [7:0] in_wt_data56;
wire    [7:0] in_wt_data57;
wire    [7:0] in_wt_data58;
wire    [7:0] in_wt_data59;
wire    [7:0] in_wt_data6;
wire    [7:0] in_wt_data60;
wire    [7:0] in_wt_data61;
wire    [7:0] in_wt_data62;
wire    [7:0] in_wt_data63;
wire    [7:0] in_wt_data64;
wire    [7:0] in_wt_data65;
wire    [7:0] in_wt_data66;
wire    [7:0] in_wt_data67;
wire    [7:0] in_wt_data68;
wire    [7:0] in_wt_data69;
wire    [7:0] in_wt_data7;
wire    [7:0] in_wt_data70;
wire    [7:0] in_wt_data71;
wire    [7:0] in_wt_data72;
wire    [7:0] in_wt_data73;
wire    [7:0] in_wt_data74;
wire    [7:0] in_wt_data75;
wire    [7:0] in_wt_data76;
wire    [7:0] in_wt_data77;
wire    [7:0] in_wt_data78;
wire    [7:0] in_wt_data79;
wire    [7:0] in_wt_data8;
wire    [7:0] in_wt_data80;
wire    [7:0] in_wt_data81;
wire    [7:0] in_wt_data82;
wire    [7:0] in_wt_data83;
wire    [7:0] in_wt_data84;
wire    [7:0] in_wt_data85;
wire    [7:0] in_wt_data86;
wire    [7:0] in_wt_data87;
wire    [7:0] in_wt_data88;
wire    [7:0] in_wt_data89;
wire    [7:0] in_wt_data9;
wire    [7:0] in_wt_data90;
wire    [7:0] in_wt_data91;
wire    [7:0] in_wt_data92;
wire    [7:0] in_wt_data93;
wire    [7:0] in_wt_data94;
wire    [7:0] in_wt_data95;
wire    [7:0] in_wt_data96;
wire    [7:0] in_wt_data97;
wire    [7:0] in_wt_data98;
wire    [7:0] in_wt_data99;
wire  [127:0] in_wt_mask;
wire          in_wt_pvld;
wire    [7:0] in_wt_sel;
wire          nvdla_op_gated_clk_0;
wire          nvdla_op_gated_clk_1;
wire          nvdla_op_gated_clk_10;
wire          nvdla_op_gated_clk_2;
wire          nvdla_op_gated_clk_3;
wire          nvdla_op_gated_clk_4;
wire          nvdla_op_gated_clk_5;
wire          nvdla_op_gated_clk_6;
wire          nvdla_op_gated_clk_7;
wire          nvdla_op_gated_clk_8;
wire          nvdla_op_gated_clk_9;
wire          nvdla_wg_gated_clk_0;
wire          nvdla_wg_gated_clk_1;
wire          nvdla_wg_gated_clk_2;
wire          nvdla_wg_gated_clk_3;
wire          nvdla_wg_gated_clk_4;
wire          nvdla_wg_gated_clk_5;
wire          nvdla_wg_gated_clk_6;
wire          nvdla_wg_gated_clk_7;
wire          nvdla_wg_gated_clk_8;
wire  [175:0] out_data0;
wire  [175:0] out_data1;
wire  [175:0] out_data2;
wire  [175:0] out_data3;
wire  [175:0] out_data4;
wire  [175:0] out_data5;
wire  [175:0] out_data6;
wire  [175:0] out_data7;
wire    [7:0] out_mask;
wire    [7:0] out_nan;
wire    [8:0] out_pd;
wire          out_pvld;
wire    [8:0] slcg_wg_en;
wire [1023:0] wt0_actv_data;
wire   [63:0] wt0_actv_nan;
wire  [127:0] wt0_actv_nz;
wire  [103:0] wt0_actv_pvld;
wire  [191:0] wt0_sd_exp;
wire   [63:0] wt0_sd_mask;
wire          wt0_sd_pvld;
wire [1023:0] wt1_actv_data;
wire   [63:0] wt1_actv_nan;
wire  [127:0] wt1_actv_nz;
wire  [103:0] wt1_actv_pvld;
wire  [191:0] wt1_sd_exp;
wire   [63:0] wt1_sd_mask;
wire          wt1_sd_pvld;
wire [1023:0] wt2_actv_data;
wire   [63:0] wt2_actv_nan;
wire  [127:0] wt2_actv_nz;
wire  [103:0] wt2_actv_pvld;
wire  [191:0] wt2_sd_exp;
wire   [63:0] wt2_sd_mask;
wire          wt2_sd_pvld;
wire [1023:0] wt3_actv_data;
wire   [63:0] wt3_actv_nan;
wire  [127:0] wt3_actv_nz;
wire  [103:0] wt3_actv_pvld;
wire  [191:0] wt3_sd_exp;
wire   [63:0] wt3_sd_mask;
wire          wt3_sd_pvld;
wire [1023:0] wt4_actv_data;
wire   [63:0] wt4_actv_nan;
wire  [127:0] wt4_actv_nz;
wire  [103:0] wt4_actv_pvld;
wire  [191:0] wt4_sd_exp;
wire   [63:0] wt4_sd_mask;
wire          wt4_sd_pvld;
wire [1023:0] wt5_actv_data;
wire   [63:0] wt5_actv_nan;
wire  [127:0] wt5_actv_nz;
wire  [103:0] wt5_actv_pvld;
wire  [191:0] wt5_sd_exp;
wire   [63:0] wt5_sd_mask;
wire          wt5_sd_pvld;
wire [1023:0] wt6_actv_data;
wire   [63:0] wt6_actv_nan;
wire  [127:0] wt6_actv_nz;
wire  [103:0] wt6_actv_pvld;
wire  [191:0] wt6_sd_exp;
wire   [63:0] wt6_sd_mask;
wire          wt6_sd_pvld;
wire [1023:0] wt7_actv_data;
wire   [63:0] wt7_actv_nan;
wire  [127:0] wt7_actv_nz;
wire  [103:0] wt7_actv_pvld;
wire  [191:0] wt7_sd_exp;
wire   [63:0] wt7_sd_mask;
wire          wt7_sd_pvld;
`ifndef SYNTHESIS
reg     [8:0] dbg_out_pd_d1;
reg     [8:0] dbg_out_pd_d2;
reg     [8:0] dbg_out_pd_d3;
reg     [8:0] dbg_out_pd_d4;
reg           dbg_out_pvld_d1;
reg           dbg_out_pvld_d2;
reg           dbg_out_pvld_d3;
reg           dbg_out_pvld_d4;
`endif
reg     [8:0] in_dat_pd_d1;
reg     [8:0] in_dat_pd_d2;
reg           in_dat_pvld_d1;
reg           in_dat_pvld_d2;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
//==========================================================
// interface with register config   
//==========================================================
NV_NVDLA_CMAC_CORE_cfg u_cfg (
   .nvdla_core_clk                (nvdla_op_gated_clk_9)          //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.dp2reg_done                   (dp2reg_done)                   //|< o
  ,.reg2dp_conv_mode              (reg2dp_conv_mode)              //|< i
  ,.reg2dp_op_en                  (reg2dp_op_en)                  //|< i
  ,.reg2dp_proc_precision         (reg2dp_proc_precision[1:0])    //|< i
  ,.cfg_is_fp16                   (cfg_is_fp16)                   //|> w
  ,.cfg_is_int16                  (cfg_is_int16)                  //|> w
  ,.cfg_is_int8                   (cfg_is_int8)                   //|> w
  ,.cfg_is_wg                     (cfg_is_wg)                     //|> w
  ,.cfg_reg_en                    (cfg_reg_en)                    //|> w
  ,.slcg_wg_en                    (slcg_wg_en[8:0])               //|> w
  );


always @(posedge nvdla_core_clk) begin
  if ((in_dat_pvld) == 1'b1) begin
    in_dat_pd_d1 <= in_dat_pd;
  // VCS coverage off
  end else if ((in_dat_pvld) == 1'b0) begin
  end else begin
    in_dat_pd_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    in_dat_pvld_d1 <= 1'b0;
  end else begin
  in_dat_pvld_d1 <= in_dat_pvld;
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_dat_pvld_d1) == 1'b1) begin
    in_dat_pd_d2 <= in_dat_pd_d1;
  // VCS coverage off
  end else if ((in_dat_pvld_d1) == 1'b0) begin
  end else begin
    in_dat_pd_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    in_dat_pvld_d2 <= 1'b0;
  end else begin
  in_dat_pvld_d2 <= in_dat_pvld_d1;
  end
end
assign out_pd = in_dat_pd_d2;
assign out_pvld = in_dat_pvld_d2;


//==========================================================
// input retiming logic            
//==========================================================
NV_NVDLA_CMAC_CORE_rt_in u_rt_in (
   .nvdla_core_clk                (nvdla_op_gated_clk_9)          //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.sc2mac_dat_data0              (sc2mac_dat_data0[7:0])         //|< i
  ,.sc2mac_dat_data1              (sc2mac_dat_data1[7:0])         //|< i
  ,.sc2mac_dat_data10             (sc2mac_dat_data10[7:0])        //|< i
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
  ,.sc2mac_dat_data11             (sc2mac_dat_data11[7:0])        //|< i
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
  ,.sc2mac_dat_data12             (sc2mac_dat_data12[7:0])        //|< i
  ,.sc2mac_dat_data120            (sc2mac_dat_data120[7:0])       //|< i
  ,.sc2mac_dat_data121            (sc2mac_dat_data121[7:0])       //|< i
  ,.sc2mac_dat_data122            (sc2mac_dat_data122[7:0])       //|< i
  ,.sc2mac_dat_data123            (sc2mac_dat_data123[7:0])       //|< i
  ,.sc2mac_dat_data124            (sc2mac_dat_data124[7:0])       //|< i
  ,.sc2mac_dat_data125            (sc2mac_dat_data125[7:0])       //|< i
  ,.sc2mac_dat_data126            (sc2mac_dat_data126[7:0])       //|< i
  ,.sc2mac_dat_data127            (sc2mac_dat_data127[7:0])       //|< i
  ,.sc2mac_dat_data13             (sc2mac_dat_data13[7:0])        //|< i
  ,.sc2mac_dat_data14             (sc2mac_dat_data14[7:0])        //|< i
  ,.sc2mac_dat_data15             (sc2mac_dat_data15[7:0])        //|< i
  ,.sc2mac_dat_data16             (sc2mac_dat_data16[7:0])        //|< i
  ,.sc2mac_dat_data17             (sc2mac_dat_data17[7:0])        //|< i
  ,.sc2mac_dat_data18             (sc2mac_dat_data18[7:0])        //|< i
  ,.sc2mac_dat_data19             (sc2mac_dat_data19[7:0])        //|< i
  ,.sc2mac_dat_data2              (sc2mac_dat_data2[7:0])         //|< i
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
  ,.sc2mac_dat_data3              (sc2mac_dat_data3[7:0])         //|< i
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
  ,.sc2mac_dat_data4              (sc2mac_dat_data4[7:0])         //|< i
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
  ,.sc2mac_dat_data5              (sc2mac_dat_data5[7:0])         //|< i
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
  ,.sc2mac_dat_data6              (sc2mac_dat_data6[7:0])         //|< i
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
  ,.sc2mac_dat_data7              (sc2mac_dat_data7[7:0])         //|< i
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
  ,.sc2mac_dat_data8              (sc2mac_dat_data8[7:0])         //|< i
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
  ,.sc2mac_dat_data9              (sc2mac_dat_data9[7:0])         //|< i
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
  ,.sc2mac_dat_mask               (sc2mac_dat_mask[127:0])        //|< i
  ,.sc2mac_dat_pd                 (sc2mac_dat_pd[8:0])            //|< i
  ,.sc2mac_dat_pvld               (sc2mac_dat_pvld)               //|< i
  ,.sc2mac_wt_data0               (sc2mac_wt_data0[7:0])          //|< i
  ,.sc2mac_wt_data1               (sc2mac_wt_data1[7:0])          //|< i
  ,.sc2mac_wt_data10              (sc2mac_wt_data10[7:0])         //|< i
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
  ,.sc2mac_wt_data11              (sc2mac_wt_data11[7:0])         //|< i
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
  ,.sc2mac_wt_data12              (sc2mac_wt_data12[7:0])         //|< i
  ,.sc2mac_wt_data120             (sc2mac_wt_data120[7:0])        //|< i
  ,.sc2mac_wt_data121             (sc2mac_wt_data121[7:0])        //|< i
  ,.sc2mac_wt_data122             (sc2mac_wt_data122[7:0])        //|< i
  ,.sc2mac_wt_data123             (sc2mac_wt_data123[7:0])        //|< i
  ,.sc2mac_wt_data124             (sc2mac_wt_data124[7:0])        //|< i
  ,.sc2mac_wt_data125             (sc2mac_wt_data125[7:0])        //|< i
  ,.sc2mac_wt_data126             (sc2mac_wt_data126[7:0])        //|< i
  ,.sc2mac_wt_data127             (sc2mac_wt_data127[7:0])        //|< i
  ,.sc2mac_wt_data13              (sc2mac_wt_data13[7:0])         //|< i
  ,.sc2mac_wt_data14              (sc2mac_wt_data14[7:0])         //|< i
  ,.sc2mac_wt_data15              (sc2mac_wt_data15[7:0])         //|< i
  ,.sc2mac_wt_data16              (sc2mac_wt_data16[7:0])         //|< i
  ,.sc2mac_wt_data17              (sc2mac_wt_data17[7:0])         //|< i
  ,.sc2mac_wt_data18              (sc2mac_wt_data18[7:0])         //|< i
  ,.sc2mac_wt_data19              (sc2mac_wt_data19[7:0])         //|< i
  ,.sc2mac_wt_data2               (sc2mac_wt_data2[7:0])          //|< i
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
  ,.sc2mac_wt_data3               (sc2mac_wt_data3[7:0])          //|< i
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
  ,.sc2mac_wt_data4               (sc2mac_wt_data4[7:0])          //|< i
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
  ,.sc2mac_wt_data5               (sc2mac_wt_data5[7:0])          //|< i
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
  ,.sc2mac_wt_data6               (sc2mac_wt_data6[7:0])          //|< i
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
  ,.sc2mac_wt_data7               (sc2mac_wt_data7[7:0])          //|< i
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
  ,.sc2mac_wt_data8               (sc2mac_wt_data8[7:0])          //|< i
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
  ,.sc2mac_wt_data9               (sc2mac_wt_data9[7:0])          //|< i
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
  ,.sc2mac_wt_mask                (sc2mac_wt_mask[127:0])         //|< i
  ,.sc2mac_wt_pvld                (sc2mac_wt_pvld)                //|< i
  ,.sc2mac_wt_sel                 (sc2mac_wt_sel[7:0])            //|< i
  ,.in_dat_data0                  (in_dat_data0[7:0])             //|> w
  ,.in_dat_data1                  (in_dat_data1[7:0])             //|> w
  ,.in_dat_data10                 (in_dat_data10[7:0])            //|> w
  ,.in_dat_data100                (in_dat_data100[7:0])           //|> w
  ,.in_dat_data101                (in_dat_data101[7:0])           //|> w
  ,.in_dat_data102                (in_dat_data102[7:0])           //|> w
  ,.in_dat_data103                (in_dat_data103[7:0])           //|> w
  ,.in_dat_data104                (in_dat_data104[7:0])           //|> w
  ,.in_dat_data105                (in_dat_data105[7:0])           //|> w
  ,.in_dat_data106                (in_dat_data106[7:0])           //|> w
  ,.in_dat_data107                (in_dat_data107[7:0])           //|> w
  ,.in_dat_data108                (in_dat_data108[7:0])           //|> w
  ,.in_dat_data109                (in_dat_data109[7:0])           //|> w
  ,.in_dat_data11                 (in_dat_data11[7:0])            //|> w
  ,.in_dat_data110                (in_dat_data110[7:0])           //|> w
  ,.in_dat_data111                (in_dat_data111[7:0])           //|> w
  ,.in_dat_data112                (in_dat_data112[7:0])           //|> w
  ,.in_dat_data113                (in_dat_data113[7:0])           //|> w
  ,.in_dat_data114                (in_dat_data114[7:0])           //|> w
  ,.in_dat_data115                (in_dat_data115[7:0])           //|> w
  ,.in_dat_data116                (in_dat_data116[7:0])           //|> w
  ,.in_dat_data117                (in_dat_data117[7:0])           //|> w
  ,.in_dat_data118                (in_dat_data118[7:0])           //|> w
  ,.in_dat_data119                (in_dat_data119[7:0])           //|> w
  ,.in_dat_data12                 (in_dat_data12[7:0])            //|> w
  ,.in_dat_data120                (in_dat_data120[7:0])           //|> w
  ,.in_dat_data121                (in_dat_data121[7:0])           //|> w
  ,.in_dat_data122                (in_dat_data122[7:0])           //|> w
  ,.in_dat_data123                (in_dat_data123[7:0])           //|> w
  ,.in_dat_data124                (in_dat_data124[7:0])           //|> w
  ,.in_dat_data125                (in_dat_data125[7:0])           //|> w
  ,.in_dat_data126                (in_dat_data126[7:0])           //|> w
  ,.in_dat_data127                (in_dat_data127[7:0])           //|> w
  ,.in_dat_data13                 (in_dat_data13[7:0])            //|> w
  ,.in_dat_data14                 (in_dat_data14[7:0])            //|> w
  ,.in_dat_data15                 (in_dat_data15[7:0])            //|> w
  ,.in_dat_data16                 (in_dat_data16[7:0])            //|> w
  ,.in_dat_data17                 (in_dat_data17[7:0])            //|> w
  ,.in_dat_data18                 (in_dat_data18[7:0])            //|> w
  ,.in_dat_data19                 (in_dat_data19[7:0])            //|> w
  ,.in_dat_data2                  (in_dat_data2[7:0])             //|> w
  ,.in_dat_data20                 (in_dat_data20[7:0])            //|> w
  ,.in_dat_data21                 (in_dat_data21[7:0])            //|> w
  ,.in_dat_data22                 (in_dat_data22[7:0])            //|> w
  ,.in_dat_data23                 (in_dat_data23[7:0])            //|> w
  ,.in_dat_data24                 (in_dat_data24[7:0])            //|> w
  ,.in_dat_data25                 (in_dat_data25[7:0])            //|> w
  ,.in_dat_data26                 (in_dat_data26[7:0])            //|> w
  ,.in_dat_data27                 (in_dat_data27[7:0])            //|> w
  ,.in_dat_data28                 (in_dat_data28[7:0])            //|> w
  ,.in_dat_data29                 (in_dat_data29[7:0])            //|> w
  ,.in_dat_data3                  (in_dat_data3[7:0])             //|> w
  ,.in_dat_data30                 (in_dat_data30[7:0])            //|> w
  ,.in_dat_data31                 (in_dat_data31[7:0])            //|> w
  ,.in_dat_data32                 (in_dat_data32[7:0])            //|> w
  ,.in_dat_data33                 (in_dat_data33[7:0])            //|> w
  ,.in_dat_data34                 (in_dat_data34[7:0])            //|> w
  ,.in_dat_data35                 (in_dat_data35[7:0])            //|> w
  ,.in_dat_data36                 (in_dat_data36[7:0])            //|> w
  ,.in_dat_data37                 (in_dat_data37[7:0])            //|> w
  ,.in_dat_data38                 (in_dat_data38[7:0])            //|> w
  ,.in_dat_data39                 (in_dat_data39[7:0])            //|> w
  ,.in_dat_data4                  (in_dat_data4[7:0])             //|> w
  ,.in_dat_data40                 (in_dat_data40[7:0])            //|> w
  ,.in_dat_data41                 (in_dat_data41[7:0])            //|> w
  ,.in_dat_data42                 (in_dat_data42[7:0])            //|> w
  ,.in_dat_data43                 (in_dat_data43[7:0])            //|> w
  ,.in_dat_data44                 (in_dat_data44[7:0])            //|> w
  ,.in_dat_data45                 (in_dat_data45[7:0])            //|> w
  ,.in_dat_data46                 (in_dat_data46[7:0])            //|> w
  ,.in_dat_data47                 (in_dat_data47[7:0])            //|> w
  ,.in_dat_data48                 (in_dat_data48[7:0])            //|> w
  ,.in_dat_data49                 (in_dat_data49[7:0])            //|> w
  ,.in_dat_data5                  (in_dat_data5[7:0])             //|> w
  ,.in_dat_data50                 (in_dat_data50[7:0])            //|> w
  ,.in_dat_data51                 (in_dat_data51[7:0])            //|> w
  ,.in_dat_data52                 (in_dat_data52[7:0])            //|> w
  ,.in_dat_data53                 (in_dat_data53[7:0])            //|> w
  ,.in_dat_data54                 (in_dat_data54[7:0])            //|> w
  ,.in_dat_data55                 (in_dat_data55[7:0])            //|> w
  ,.in_dat_data56                 (in_dat_data56[7:0])            //|> w
  ,.in_dat_data57                 (in_dat_data57[7:0])            //|> w
  ,.in_dat_data58                 (in_dat_data58[7:0])            //|> w
  ,.in_dat_data59                 (in_dat_data59[7:0])            //|> w
  ,.in_dat_data6                  (in_dat_data6[7:0])             //|> w
  ,.in_dat_data60                 (in_dat_data60[7:0])            //|> w
  ,.in_dat_data61                 (in_dat_data61[7:0])            //|> w
  ,.in_dat_data62                 (in_dat_data62[7:0])            //|> w
  ,.in_dat_data63                 (in_dat_data63[7:0])            //|> w
  ,.in_dat_data64                 (in_dat_data64[7:0])            //|> w
  ,.in_dat_data65                 (in_dat_data65[7:0])            //|> w
  ,.in_dat_data66                 (in_dat_data66[7:0])            //|> w
  ,.in_dat_data67                 (in_dat_data67[7:0])            //|> w
  ,.in_dat_data68                 (in_dat_data68[7:0])            //|> w
  ,.in_dat_data69                 (in_dat_data69[7:0])            //|> w
  ,.in_dat_data7                  (in_dat_data7[7:0])             //|> w
  ,.in_dat_data70                 (in_dat_data70[7:0])            //|> w
  ,.in_dat_data71                 (in_dat_data71[7:0])            //|> w
  ,.in_dat_data72                 (in_dat_data72[7:0])            //|> w
  ,.in_dat_data73                 (in_dat_data73[7:0])            //|> w
  ,.in_dat_data74                 (in_dat_data74[7:0])            //|> w
  ,.in_dat_data75                 (in_dat_data75[7:0])            //|> w
  ,.in_dat_data76                 (in_dat_data76[7:0])            //|> w
  ,.in_dat_data77                 (in_dat_data77[7:0])            //|> w
  ,.in_dat_data78                 (in_dat_data78[7:0])            //|> w
  ,.in_dat_data79                 (in_dat_data79[7:0])            //|> w
  ,.in_dat_data8                  (in_dat_data8[7:0])             //|> w
  ,.in_dat_data80                 (in_dat_data80[7:0])            //|> w
  ,.in_dat_data81                 (in_dat_data81[7:0])            //|> w
  ,.in_dat_data82                 (in_dat_data82[7:0])            //|> w
  ,.in_dat_data83                 (in_dat_data83[7:0])            //|> w
  ,.in_dat_data84                 (in_dat_data84[7:0])            //|> w
  ,.in_dat_data85                 (in_dat_data85[7:0])            //|> w
  ,.in_dat_data86                 (in_dat_data86[7:0])            //|> w
  ,.in_dat_data87                 (in_dat_data87[7:0])            //|> w
  ,.in_dat_data88                 (in_dat_data88[7:0])            //|> w
  ,.in_dat_data89                 (in_dat_data89[7:0])            //|> w
  ,.in_dat_data9                  (in_dat_data9[7:0])             //|> w
  ,.in_dat_data90                 (in_dat_data90[7:0])            //|> w
  ,.in_dat_data91                 (in_dat_data91[7:0])            //|> w
  ,.in_dat_data92                 (in_dat_data92[7:0])            //|> w
  ,.in_dat_data93                 (in_dat_data93[7:0])            //|> w
  ,.in_dat_data94                 (in_dat_data94[7:0])            //|> w
  ,.in_dat_data95                 (in_dat_data95[7:0])            //|> w
  ,.in_dat_data96                 (in_dat_data96[7:0])            //|> w
  ,.in_dat_data97                 (in_dat_data97[7:0])            //|> w
  ,.in_dat_data98                 (in_dat_data98[7:0])            //|> w
  ,.in_dat_data99                 (in_dat_data99[7:0])            //|> w
  ,.in_dat_mask                   (in_dat_mask[127:0])            //|> w
  ,.in_dat_pd                     (in_dat_pd[8:0])                //|> w
  ,.in_dat_pvld                   (in_dat_pvld)                   //|> w
  ,.in_dat_stripe_end             (in_dat_stripe_end)             //|> w
  ,.in_dat_stripe_st              (in_dat_stripe_st)              //|> w
  ,.in_wt_data0                   (in_wt_data0[7:0])              //|> w
  ,.in_wt_data1                   (in_wt_data1[7:0])              //|> w
  ,.in_wt_data10                  (in_wt_data10[7:0])             //|> w
  ,.in_wt_data100                 (in_wt_data100[7:0])            //|> w
  ,.in_wt_data101                 (in_wt_data101[7:0])            //|> w
  ,.in_wt_data102                 (in_wt_data102[7:0])            //|> w
  ,.in_wt_data103                 (in_wt_data103[7:0])            //|> w
  ,.in_wt_data104                 (in_wt_data104[7:0])            //|> w
  ,.in_wt_data105                 (in_wt_data105[7:0])            //|> w
  ,.in_wt_data106                 (in_wt_data106[7:0])            //|> w
  ,.in_wt_data107                 (in_wt_data107[7:0])            //|> w
  ,.in_wt_data108                 (in_wt_data108[7:0])            //|> w
  ,.in_wt_data109                 (in_wt_data109[7:0])            //|> w
  ,.in_wt_data11                  (in_wt_data11[7:0])             //|> w
  ,.in_wt_data110                 (in_wt_data110[7:0])            //|> w
  ,.in_wt_data111                 (in_wt_data111[7:0])            //|> w
  ,.in_wt_data112                 (in_wt_data112[7:0])            //|> w
  ,.in_wt_data113                 (in_wt_data113[7:0])            //|> w
  ,.in_wt_data114                 (in_wt_data114[7:0])            //|> w
  ,.in_wt_data115                 (in_wt_data115[7:0])            //|> w
  ,.in_wt_data116                 (in_wt_data116[7:0])            //|> w
  ,.in_wt_data117                 (in_wt_data117[7:0])            //|> w
  ,.in_wt_data118                 (in_wt_data118[7:0])            //|> w
  ,.in_wt_data119                 (in_wt_data119[7:0])            //|> w
  ,.in_wt_data12                  (in_wt_data12[7:0])             //|> w
  ,.in_wt_data120                 (in_wt_data120[7:0])            //|> w
  ,.in_wt_data121                 (in_wt_data121[7:0])            //|> w
  ,.in_wt_data122                 (in_wt_data122[7:0])            //|> w
  ,.in_wt_data123                 (in_wt_data123[7:0])            //|> w
  ,.in_wt_data124                 (in_wt_data124[7:0])            //|> w
  ,.in_wt_data125                 (in_wt_data125[7:0])            //|> w
  ,.in_wt_data126                 (in_wt_data126[7:0])            //|> w
  ,.in_wt_data127                 (in_wt_data127[7:0])            //|> w
  ,.in_wt_data13                  (in_wt_data13[7:0])             //|> w
  ,.in_wt_data14                  (in_wt_data14[7:0])             //|> w
  ,.in_wt_data15                  (in_wt_data15[7:0])             //|> w
  ,.in_wt_data16                  (in_wt_data16[7:0])             //|> w
  ,.in_wt_data17                  (in_wt_data17[7:0])             //|> w
  ,.in_wt_data18                  (in_wt_data18[7:0])             //|> w
  ,.in_wt_data19                  (in_wt_data19[7:0])             //|> w
  ,.in_wt_data2                   (in_wt_data2[7:0])              //|> w
  ,.in_wt_data20                  (in_wt_data20[7:0])             //|> w
  ,.in_wt_data21                  (in_wt_data21[7:0])             //|> w
  ,.in_wt_data22                  (in_wt_data22[7:0])             //|> w
  ,.in_wt_data23                  (in_wt_data23[7:0])             //|> w
  ,.in_wt_data24                  (in_wt_data24[7:0])             //|> w
  ,.in_wt_data25                  (in_wt_data25[7:0])             //|> w
  ,.in_wt_data26                  (in_wt_data26[7:0])             //|> w
  ,.in_wt_data27                  (in_wt_data27[7:0])             //|> w
  ,.in_wt_data28                  (in_wt_data28[7:0])             //|> w
  ,.in_wt_data29                  (in_wt_data29[7:0])             //|> w
  ,.in_wt_data3                   (in_wt_data3[7:0])              //|> w
  ,.in_wt_data30                  (in_wt_data30[7:0])             //|> w
  ,.in_wt_data31                  (in_wt_data31[7:0])             //|> w
  ,.in_wt_data32                  (in_wt_data32[7:0])             //|> w
  ,.in_wt_data33                  (in_wt_data33[7:0])             //|> w
  ,.in_wt_data34                  (in_wt_data34[7:0])             //|> w
  ,.in_wt_data35                  (in_wt_data35[7:0])             //|> w
  ,.in_wt_data36                  (in_wt_data36[7:0])             //|> w
  ,.in_wt_data37                  (in_wt_data37[7:0])             //|> w
  ,.in_wt_data38                  (in_wt_data38[7:0])             //|> w
  ,.in_wt_data39                  (in_wt_data39[7:0])             //|> w
  ,.in_wt_data4                   (in_wt_data4[7:0])              //|> w
  ,.in_wt_data40                  (in_wt_data40[7:0])             //|> w
  ,.in_wt_data41                  (in_wt_data41[7:0])             //|> w
  ,.in_wt_data42                  (in_wt_data42[7:0])             //|> w
  ,.in_wt_data43                  (in_wt_data43[7:0])             //|> w
  ,.in_wt_data44                  (in_wt_data44[7:0])             //|> w
  ,.in_wt_data45                  (in_wt_data45[7:0])             //|> w
  ,.in_wt_data46                  (in_wt_data46[7:0])             //|> w
  ,.in_wt_data47                  (in_wt_data47[7:0])             //|> w
  ,.in_wt_data48                  (in_wt_data48[7:0])             //|> w
  ,.in_wt_data49                  (in_wt_data49[7:0])             //|> w
  ,.in_wt_data5                   (in_wt_data5[7:0])              //|> w
  ,.in_wt_data50                  (in_wt_data50[7:0])             //|> w
  ,.in_wt_data51                  (in_wt_data51[7:0])             //|> w
  ,.in_wt_data52                  (in_wt_data52[7:0])             //|> w
  ,.in_wt_data53                  (in_wt_data53[7:0])             //|> w
  ,.in_wt_data54                  (in_wt_data54[7:0])             //|> w
  ,.in_wt_data55                  (in_wt_data55[7:0])             //|> w
  ,.in_wt_data56                  (in_wt_data56[7:0])             //|> w
  ,.in_wt_data57                  (in_wt_data57[7:0])             //|> w
  ,.in_wt_data58                  (in_wt_data58[7:0])             //|> w
  ,.in_wt_data59                  (in_wt_data59[7:0])             //|> w
  ,.in_wt_data6                   (in_wt_data6[7:0])              //|> w
  ,.in_wt_data60                  (in_wt_data60[7:0])             //|> w
  ,.in_wt_data61                  (in_wt_data61[7:0])             //|> w
  ,.in_wt_data62                  (in_wt_data62[7:0])             //|> w
  ,.in_wt_data63                  (in_wt_data63[7:0])             //|> w
  ,.in_wt_data64                  (in_wt_data64[7:0])             //|> w
  ,.in_wt_data65                  (in_wt_data65[7:0])             //|> w
  ,.in_wt_data66                  (in_wt_data66[7:0])             //|> w
  ,.in_wt_data67                  (in_wt_data67[7:0])             //|> w
  ,.in_wt_data68                  (in_wt_data68[7:0])             //|> w
  ,.in_wt_data69                  (in_wt_data69[7:0])             //|> w
  ,.in_wt_data7                   (in_wt_data7[7:0])              //|> w
  ,.in_wt_data70                  (in_wt_data70[7:0])             //|> w
  ,.in_wt_data71                  (in_wt_data71[7:0])             //|> w
  ,.in_wt_data72                  (in_wt_data72[7:0])             //|> w
  ,.in_wt_data73                  (in_wt_data73[7:0])             //|> w
  ,.in_wt_data74                  (in_wt_data74[7:0])             //|> w
  ,.in_wt_data75                  (in_wt_data75[7:0])             //|> w
  ,.in_wt_data76                  (in_wt_data76[7:0])             //|> w
  ,.in_wt_data77                  (in_wt_data77[7:0])             //|> w
  ,.in_wt_data78                  (in_wt_data78[7:0])             //|> w
  ,.in_wt_data79                  (in_wt_data79[7:0])             //|> w
  ,.in_wt_data8                   (in_wt_data8[7:0])              //|> w
  ,.in_wt_data80                  (in_wt_data80[7:0])             //|> w
  ,.in_wt_data81                  (in_wt_data81[7:0])             //|> w
  ,.in_wt_data82                  (in_wt_data82[7:0])             //|> w
  ,.in_wt_data83                  (in_wt_data83[7:0])             //|> w
  ,.in_wt_data84                  (in_wt_data84[7:0])             //|> w
  ,.in_wt_data85                  (in_wt_data85[7:0])             //|> w
  ,.in_wt_data86                  (in_wt_data86[7:0])             //|> w
  ,.in_wt_data87                  (in_wt_data87[7:0])             //|> w
  ,.in_wt_data88                  (in_wt_data88[7:0])             //|> w
  ,.in_wt_data89                  (in_wt_data89[7:0])             //|> w
  ,.in_wt_data9                   (in_wt_data9[7:0])              //|> w
  ,.in_wt_data90                  (in_wt_data90[7:0])             //|> w
  ,.in_wt_data91                  (in_wt_data91[7:0])             //|> w
  ,.in_wt_data92                  (in_wt_data92[7:0])             //|> w
  ,.in_wt_data93                  (in_wt_data93[7:0])             //|> w
  ,.in_wt_data94                  (in_wt_data94[7:0])             //|> w
  ,.in_wt_data95                  (in_wt_data95[7:0])             //|> w
  ,.in_wt_data96                  (in_wt_data96[7:0])             //|> w
  ,.in_wt_data97                  (in_wt_data97[7:0])             //|> w
  ,.in_wt_data98                  (in_wt_data98[7:0])             //|> w
  ,.in_wt_data99                  (in_wt_data99[7:0])             //|> w
  ,.in_wt_mask                    (in_wt_mask[127:0])             //|> w
  ,.in_wt_pvld                    (in_wt_pvld)                    //|> w
  ,.in_wt_sel                     (in_wt_sel[7:0])                //|> w
  );

//==========================================================
// input shadow and active pipeline
//==========================================================
NV_NVDLA_CMAC_CORE_active u_active (
   .nvdla_core_clk                (nvdla_op_gated_clk_10)         //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.cfg_is_fp16                   (cfg_is_fp16)                   //|< w
  ,.cfg_is_int16                  (cfg_is_int16)                  //|< w
  ,.cfg_is_int8                   (cfg_is_int8)                   //|< w
  ,.cfg_reg_en                    (cfg_reg_en)                    //|< w
  ,.in_dat_data0                  (in_dat_data0[7:0])             //|< w
  ,.in_dat_data1                  (in_dat_data1[7:0])             //|< w
  ,.in_dat_data10                 (in_dat_data10[7:0])            //|< w
  ,.in_dat_data100                (in_dat_data100[7:0])           //|< w
  ,.in_dat_data101                (in_dat_data101[7:0])           //|< w
  ,.in_dat_data102                (in_dat_data102[7:0])           //|< w
  ,.in_dat_data103                (in_dat_data103[7:0])           //|< w
  ,.in_dat_data104                (in_dat_data104[7:0])           //|< w
  ,.in_dat_data105                (in_dat_data105[7:0])           //|< w
  ,.in_dat_data106                (in_dat_data106[7:0])           //|< w
  ,.in_dat_data107                (in_dat_data107[7:0])           //|< w
  ,.in_dat_data108                (in_dat_data108[7:0])           //|< w
  ,.in_dat_data109                (in_dat_data109[7:0])           //|< w
  ,.in_dat_data11                 (in_dat_data11[7:0])            //|< w
  ,.in_dat_data110                (in_dat_data110[7:0])           //|< w
  ,.in_dat_data111                (in_dat_data111[7:0])           //|< w
  ,.in_dat_data112                (in_dat_data112[7:0])           //|< w
  ,.in_dat_data113                (in_dat_data113[7:0])           //|< w
  ,.in_dat_data114                (in_dat_data114[7:0])           //|< w
  ,.in_dat_data115                (in_dat_data115[7:0])           //|< w
  ,.in_dat_data116                (in_dat_data116[7:0])           //|< w
  ,.in_dat_data117                (in_dat_data117[7:0])           //|< w
  ,.in_dat_data118                (in_dat_data118[7:0])           //|< w
  ,.in_dat_data119                (in_dat_data119[7:0])           //|< w
  ,.in_dat_data12                 (in_dat_data12[7:0])            //|< w
  ,.in_dat_data120                (in_dat_data120[7:0])           //|< w
  ,.in_dat_data121                (in_dat_data121[7:0])           //|< w
  ,.in_dat_data122                (in_dat_data122[7:0])           //|< w
  ,.in_dat_data123                (in_dat_data123[7:0])           //|< w
  ,.in_dat_data124                (in_dat_data124[7:0])           //|< w
  ,.in_dat_data125                (in_dat_data125[7:0])           //|< w
  ,.in_dat_data126                (in_dat_data126[7:0])           //|< w
  ,.in_dat_data127                (in_dat_data127[7:0])           //|< w
  ,.in_dat_data13                 (in_dat_data13[7:0])            //|< w
  ,.in_dat_data14                 (in_dat_data14[7:0])            //|< w
  ,.in_dat_data15                 (in_dat_data15[7:0])            //|< w
  ,.in_dat_data16                 (in_dat_data16[7:0])            //|< w
  ,.in_dat_data17                 (in_dat_data17[7:0])            //|< w
  ,.in_dat_data18                 (in_dat_data18[7:0])            //|< w
  ,.in_dat_data19                 (in_dat_data19[7:0])            //|< w
  ,.in_dat_data2                  (in_dat_data2[7:0])             //|< w
  ,.in_dat_data20                 (in_dat_data20[7:0])            //|< w
  ,.in_dat_data21                 (in_dat_data21[7:0])            //|< w
  ,.in_dat_data22                 (in_dat_data22[7:0])            //|< w
  ,.in_dat_data23                 (in_dat_data23[7:0])            //|< w
  ,.in_dat_data24                 (in_dat_data24[7:0])            //|< w
  ,.in_dat_data25                 (in_dat_data25[7:0])            //|< w
  ,.in_dat_data26                 (in_dat_data26[7:0])            //|< w
  ,.in_dat_data27                 (in_dat_data27[7:0])            //|< w
  ,.in_dat_data28                 (in_dat_data28[7:0])            //|< w
  ,.in_dat_data29                 (in_dat_data29[7:0])            //|< w
  ,.in_dat_data3                  (in_dat_data3[7:0])             //|< w
  ,.in_dat_data30                 (in_dat_data30[7:0])            //|< w
  ,.in_dat_data31                 (in_dat_data31[7:0])            //|< w
  ,.in_dat_data32                 (in_dat_data32[7:0])            //|< w
  ,.in_dat_data33                 (in_dat_data33[7:0])            //|< w
  ,.in_dat_data34                 (in_dat_data34[7:0])            //|< w
  ,.in_dat_data35                 (in_dat_data35[7:0])            //|< w
  ,.in_dat_data36                 (in_dat_data36[7:0])            //|< w
  ,.in_dat_data37                 (in_dat_data37[7:0])            //|< w
  ,.in_dat_data38                 (in_dat_data38[7:0])            //|< w
  ,.in_dat_data39                 (in_dat_data39[7:0])            //|< w
  ,.in_dat_data4                  (in_dat_data4[7:0])             //|< w
  ,.in_dat_data40                 (in_dat_data40[7:0])            //|< w
  ,.in_dat_data41                 (in_dat_data41[7:0])            //|< w
  ,.in_dat_data42                 (in_dat_data42[7:0])            //|< w
  ,.in_dat_data43                 (in_dat_data43[7:0])            //|< w
  ,.in_dat_data44                 (in_dat_data44[7:0])            //|< w
  ,.in_dat_data45                 (in_dat_data45[7:0])            //|< w
  ,.in_dat_data46                 (in_dat_data46[7:0])            //|< w
  ,.in_dat_data47                 (in_dat_data47[7:0])            //|< w
  ,.in_dat_data48                 (in_dat_data48[7:0])            //|< w
  ,.in_dat_data49                 (in_dat_data49[7:0])            //|< w
  ,.in_dat_data5                  (in_dat_data5[7:0])             //|< w
  ,.in_dat_data50                 (in_dat_data50[7:0])            //|< w
  ,.in_dat_data51                 (in_dat_data51[7:0])            //|< w
  ,.in_dat_data52                 (in_dat_data52[7:0])            //|< w
  ,.in_dat_data53                 (in_dat_data53[7:0])            //|< w
  ,.in_dat_data54                 (in_dat_data54[7:0])            //|< w
  ,.in_dat_data55                 (in_dat_data55[7:0])            //|< w
  ,.in_dat_data56                 (in_dat_data56[7:0])            //|< w
  ,.in_dat_data57                 (in_dat_data57[7:0])            //|< w
  ,.in_dat_data58                 (in_dat_data58[7:0])            //|< w
  ,.in_dat_data59                 (in_dat_data59[7:0])            //|< w
  ,.in_dat_data6                  (in_dat_data6[7:0])             //|< w
  ,.in_dat_data60                 (in_dat_data60[7:0])            //|< w
  ,.in_dat_data61                 (in_dat_data61[7:0])            //|< w
  ,.in_dat_data62                 (in_dat_data62[7:0])            //|< w
  ,.in_dat_data63                 (in_dat_data63[7:0])            //|< w
  ,.in_dat_data64                 (in_dat_data64[7:0])            //|< w
  ,.in_dat_data65                 (in_dat_data65[7:0])            //|< w
  ,.in_dat_data66                 (in_dat_data66[7:0])            //|< w
  ,.in_dat_data67                 (in_dat_data67[7:0])            //|< w
  ,.in_dat_data68                 (in_dat_data68[7:0])            //|< w
  ,.in_dat_data69                 (in_dat_data69[7:0])            //|< w
  ,.in_dat_data7                  (in_dat_data7[7:0])             //|< w
  ,.in_dat_data70                 (in_dat_data70[7:0])            //|< w
  ,.in_dat_data71                 (in_dat_data71[7:0])            //|< w
  ,.in_dat_data72                 (in_dat_data72[7:0])            //|< w
  ,.in_dat_data73                 (in_dat_data73[7:0])            //|< w
  ,.in_dat_data74                 (in_dat_data74[7:0])            //|< w
  ,.in_dat_data75                 (in_dat_data75[7:0])            //|< w
  ,.in_dat_data76                 (in_dat_data76[7:0])            //|< w
  ,.in_dat_data77                 (in_dat_data77[7:0])            //|< w
  ,.in_dat_data78                 (in_dat_data78[7:0])            //|< w
  ,.in_dat_data79                 (in_dat_data79[7:0])            //|< w
  ,.in_dat_data8                  (in_dat_data8[7:0])             //|< w
  ,.in_dat_data80                 (in_dat_data80[7:0])            //|< w
  ,.in_dat_data81                 (in_dat_data81[7:0])            //|< w
  ,.in_dat_data82                 (in_dat_data82[7:0])            //|< w
  ,.in_dat_data83                 (in_dat_data83[7:0])            //|< w
  ,.in_dat_data84                 (in_dat_data84[7:0])            //|< w
  ,.in_dat_data85                 (in_dat_data85[7:0])            //|< w
  ,.in_dat_data86                 (in_dat_data86[7:0])            //|< w
  ,.in_dat_data87                 (in_dat_data87[7:0])            //|< w
  ,.in_dat_data88                 (in_dat_data88[7:0])            //|< w
  ,.in_dat_data89                 (in_dat_data89[7:0])            //|< w
  ,.in_dat_data9                  (in_dat_data9[7:0])             //|< w
  ,.in_dat_data90                 (in_dat_data90[7:0])            //|< w
  ,.in_dat_data91                 (in_dat_data91[7:0])            //|< w
  ,.in_dat_data92                 (in_dat_data92[7:0])            //|< w
  ,.in_dat_data93                 (in_dat_data93[7:0])            //|< w
  ,.in_dat_data94                 (in_dat_data94[7:0])            //|< w
  ,.in_dat_data95                 (in_dat_data95[7:0])            //|< w
  ,.in_dat_data96                 (in_dat_data96[7:0])            //|< w
  ,.in_dat_data97                 (in_dat_data97[7:0])            //|< w
  ,.in_dat_data98                 (in_dat_data98[7:0])            //|< w
  ,.in_dat_data99                 (in_dat_data99[7:0])            //|< w
  ,.in_dat_mask                   (in_dat_mask[127:0])            //|< w
  ,.in_dat_pvld                   (in_dat_pvld)                   //|< w
  ,.in_dat_stripe_end             (in_dat_stripe_end)             //|< w
  ,.in_dat_stripe_st              (in_dat_stripe_st)              //|< w
  ,.in_wt_data0                   (in_wt_data0[7:0])              //|< w
  ,.in_wt_data1                   (in_wt_data1[7:0])              //|< w
  ,.in_wt_data10                  (in_wt_data10[7:0])             //|< w
  ,.in_wt_data100                 (in_wt_data100[7:0])            //|< w
  ,.in_wt_data101                 (in_wt_data101[7:0])            //|< w
  ,.in_wt_data102                 (in_wt_data102[7:0])            //|< w
  ,.in_wt_data103                 (in_wt_data103[7:0])            //|< w
  ,.in_wt_data104                 (in_wt_data104[7:0])            //|< w
  ,.in_wt_data105                 (in_wt_data105[7:0])            //|< w
  ,.in_wt_data106                 (in_wt_data106[7:0])            //|< w
  ,.in_wt_data107                 (in_wt_data107[7:0])            //|< w
  ,.in_wt_data108                 (in_wt_data108[7:0])            //|< w
  ,.in_wt_data109                 (in_wt_data109[7:0])            //|< w
  ,.in_wt_data11                  (in_wt_data11[7:0])             //|< w
  ,.in_wt_data110                 (in_wt_data110[7:0])            //|< w
  ,.in_wt_data111                 (in_wt_data111[7:0])            //|< w
  ,.in_wt_data112                 (in_wt_data112[7:0])            //|< w
  ,.in_wt_data113                 (in_wt_data113[7:0])            //|< w
  ,.in_wt_data114                 (in_wt_data114[7:0])            //|< w
  ,.in_wt_data115                 (in_wt_data115[7:0])            //|< w
  ,.in_wt_data116                 (in_wt_data116[7:0])            //|< w
  ,.in_wt_data117                 (in_wt_data117[7:0])            //|< w
  ,.in_wt_data118                 (in_wt_data118[7:0])            //|< w
  ,.in_wt_data119                 (in_wt_data119[7:0])            //|< w
  ,.in_wt_data12                  (in_wt_data12[7:0])             //|< w
  ,.in_wt_data120                 (in_wt_data120[7:0])            //|< w
  ,.in_wt_data121                 (in_wt_data121[7:0])            //|< w
  ,.in_wt_data122                 (in_wt_data122[7:0])            //|< w
  ,.in_wt_data123                 (in_wt_data123[7:0])            //|< w
  ,.in_wt_data124                 (in_wt_data124[7:0])            //|< w
  ,.in_wt_data125                 (in_wt_data125[7:0])            //|< w
  ,.in_wt_data126                 (in_wt_data126[7:0])            //|< w
  ,.in_wt_data127                 (in_wt_data127[7:0])            //|< w
  ,.in_wt_data13                  (in_wt_data13[7:0])             //|< w
  ,.in_wt_data14                  (in_wt_data14[7:0])             //|< w
  ,.in_wt_data15                  (in_wt_data15[7:0])             //|< w
  ,.in_wt_data16                  (in_wt_data16[7:0])             //|< w
  ,.in_wt_data17                  (in_wt_data17[7:0])             //|< w
  ,.in_wt_data18                  (in_wt_data18[7:0])             //|< w
  ,.in_wt_data19                  (in_wt_data19[7:0])             //|< w
  ,.in_wt_data2                   (in_wt_data2[7:0])              //|< w
  ,.in_wt_data20                  (in_wt_data20[7:0])             //|< w
  ,.in_wt_data21                  (in_wt_data21[7:0])             //|< w
  ,.in_wt_data22                  (in_wt_data22[7:0])             //|< w
  ,.in_wt_data23                  (in_wt_data23[7:0])             //|< w
  ,.in_wt_data24                  (in_wt_data24[7:0])             //|< w
  ,.in_wt_data25                  (in_wt_data25[7:0])             //|< w
  ,.in_wt_data26                  (in_wt_data26[7:0])             //|< w
  ,.in_wt_data27                  (in_wt_data27[7:0])             //|< w
  ,.in_wt_data28                  (in_wt_data28[7:0])             //|< w
  ,.in_wt_data29                  (in_wt_data29[7:0])             //|< w
  ,.in_wt_data3                   (in_wt_data3[7:0])              //|< w
  ,.in_wt_data30                  (in_wt_data30[7:0])             //|< w
  ,.in_wt_data31                  (in_wt_data31[7:0])             //|< w
  ,.in_wt_data32                  (in_wt_data32[7:0])             //|< w
  ,.in_wt_data33                  (in_wt_data33[7:0])             //|< w
  ,.in_wt_data34                  (in_wt_data34[7:0])             //|< w
  ,.in_wt_data35                  (in_wt_data35[7:0])             //|< w
  ,.in_wt_data36                  (in_wt_data36[7:0])             //|< w
  ,.in_wt_data37                  (in_wt_data37[7:0])             //|< w
  ,.in_wt_data38                  (in_wt_data38[7:0])             //|< w
  ,.in_wt_data39                  (in_wt_data39[7:0])             //|< w
  ,.in_wt_data4                   (in_wt_data4[7:0])              //|< w
  ,.in_wt_data40                  (in_wt_data40[7:0])             //|< w
  ,.in_wt_data41                  (in_wt_data41[7:0])             //|< w
  ,.in_wt_data42                  (in_wt_data42[7:0])             //|< w
  ,.in_wt_data43                  (in_wt_data43[7:0])             //|< w
  ,.in_wt_data44                  (in_wt_data44[7:0])             //|< w
  ,.in_wt_data45                  (in_wt_data45[7:0])             //|< w
  ,.in_wt_data46                  (in_wt_data46[7:0])             //|< w
  ,.in_wt_data47                  (in_wt_data47[7:0])             //|< w
  ,.in_wt_data48                  (in_wt_data48[7:0])             //|< w
  ,.in_wt_data49                  (in_wt_data49[7:0])             //|< w
  ,.in_wt_data5                   (in_wt_data5[7:0])              //|< w
  ,.in_wt_data50                  (in_wt_data50[7:0])             //|< w
  ,.in_wt_data51                  (in_wt_data51[7:0])             //|< w
  ,.in_wt_data52                  (in_wt_data52[7:0])             //|< w
  ,.in_wt_data53                  (in_wt_data53[7:0])             //|< w
  ,.in_wt_data54                  (in_wt_data54[7:0])             //|< w
  ,.in_wt_data55                  (in_wt_data55[7:0])             //|< w
  ,.in_wt_data56                  (in_wt_data56[7:0])             //|< w
  ,.in_wt_data57                  (in_wt_data57[7:0])             //|< w
  ,.in_wt_data58                  (in_wt_data58[7:0])             //|< w
  ,.in_wt_data59                  (in_wt_data59[7:0])             //|< w
  ,.in_wt_data6                   (in_wt_data6[7:0])              //|< w
  ,.in_wt_data60                  (in_wt_data60[7:0])             //|< w
  ,.in_wt_data61                  (in_wt_data61[7:0])             //|< w
  ,.in_wt_data62                  (in_wt_data62[7:0])             //|< w
  ,.in_wt_data63                  (in_wt_data63[7:0])             //|< w
  ,.in_wt_data64                  (in_wt_data64[7:0])             //|< w
  ,.in_wt_data65                  (in_wt_data65[7:0])             //|< w
  ,.in_wt_data66                  (in_wt_data66[7:0])             //|< w
  ,.in_wt_data67                  (in_wt_data67[7:0])             //|< w
  ,.in_wt_data68                  (in_wt_data68[7:0])             //|< w
  ,.in_wt_data69                  (in_wt_data69[7:0])             //|< w
  ,.in_wt_data7                   (in_wt_data7[7:0])              //|< w
  ,.in_wt_data70                  (in_wt_data70[7:0])             //|< w
  ,.in_wt_data71                  (in_wt_data71[7:0])             //|< w
  ,.in_wt_data72                  (in_wt_data72[7:0])             //|< w
  ,.in_wt_data73                  (in_wt_data73[7:0])             //|< w
  ,.in_wt_data74                  (in_wt_data74[7:0])             //|< w
  ,.in_wt_data75                  (in_wt_data75[7:0])             //|< w
  ,.in_wt_data76                  (in_wt_data76[7:0])             //|< w
  ,.in_wt_data77                  (in_wt_data77[7:0])             //|< w
  ,.in_wt_data78                  (in_wt_data78[7:0])             //|< w
  ,.in_wt_data79                  (in_wt_data79[7:0])             //|< w
  ,.in_wt_data8                   (in_wt_data8[7:0])              //|< w
  ,.in_wt_data80                  (in_wt_data80[7:0])             //|< w
  ,.in_wt_data81                  (in_wt_data81[7:0])             //|< w
  ,.in_wt_data82                  (in_wt_data82[7:0])             //|< w
  ,.in_wt_data83                  (in_wt_data83[7:0])             //|< w
  ,.in_wt_data84                  (in_wt_data84[7:0])             //|< w
  ,.in_wt_data85                  (in_wt_data85[7:0])             //|< w
  ,.in_wt_data86                  (in_wt_data86[7:0])             //|< w
  ,.in_wt_data87                  (in_wt_data87[7:0])             //|< w
  ,.in_wt_data88                  (in_wt_data88[7:0])             //|< w
  ,.in_wt_data89                  (in_wt_data89[7:0])             //|< w
  ,.in_wt_data9                   (in_wt_data9[7:0])              //|< w
  ,.in_wt_data90                  (in_wt_data90[7:0])             //|< w
  ,.in_wt_data91                  (in_wt_data91[7:0])             //|< w
  ,.in_wt_data92                  (in_wt_data92[7:0])             //|< w
  ,.in_wt_data93                  (in_wt_data93[7:0])             //|< w
  ,.in_wt_data94                  (in_wt_data94[7:0])             //|< w
  ,.in_wt_data95                  (in_wt_data95[7:0])             //|< w
  ,.in_wt_data96                  (in_wt_data96[7:0])             //|< w
  ,.in_wt_data97                  (in_wt_data97[7:0])             //|< w
  ,.in_wt_data98                  (in_wt_data98[7:0])             //|< w
  ,.in_wt_data99                  (in_wt_data99[7:0])             //|< w
  ,.in_wt_mask                    (in_wt_mask[127:0])             //|< w
  ,.in_wt_pvld                    (in_wt_pvld)                    //|< w
  ,.in_wt_sel                     (in_wt_sel[7:0])                //|< w
  ,.dat0_actv_data                (dat0_actv_data[1023:0])        //|> w
  ,.dat0_actv_nan                 (dat0_actv_nan[63:0])           //|> w
  ,.dat0_actv_nz                  (dat0_actv_nz[127:0])           //|> w
  ,.dat0_actv_pvld                (dat0_actv_pvld[103:0])         //|> w
  ,.dat0_pre_exp                  (dat0_pre_exp[191:0])           //|> w
  ,.dat0_pre_mask                 (dat0_pre_mask[63:0])           //|> w
  ,.dat0_pre_pvld                 (dat0_pre_pvld)                 //|> w
  ,.dat0_pre_stripe_end           (dat0_pre_stripe_end)           //|> w
  ,.dat0_pre_stripe_st            (dat0_pre_stripe_st)            //|> w
  ,.dat1_actv_data                (dat1_actv_data[1023:0])        //|> w
  ,.dat1_actv_nan                 (dat1_actv_nan[63:0])           //|> w
  ,.dat1_actv_nz                  (dat1_actv_nz[127:0])           //|> w
  ,.dat1_actv_pvld                (dat1_actv_pvld[103:0])         //|> w
  ,.dat1_pre_exp                  (dat1_pre_exp[191:0])           //|> w
  ,.dat1_pre_mask                 (dat1_pre_mask[63:0])           //|> w
  ,.dat1_pre_pvld                 (dat1_pre_pvld)                 //|> w
  ,.dat1_pre_stripe_end           (dat1_pre_stripe_end)           //|> w
  ,.dat1_pre_stripe_st            (dat1_pre_stripe_st)            //|> w
  ,.dat2_actv_data                (dat2_actv_data[1023:0])        //|> w
  ,.dat2_actv_nan                 (dat2_actv_nan[63:0])           //|> w
  ,.dat2_actv_nz                  (dat2_actv_nz[127:0])           //|> w
  ,.dat2_actv_pvld                (dat2_actv_pvld[103:0])         //|> w
  ,.dat2_pre_exp                  (dat2_pre_exp[191:0])           //|> w
  ,.dat2_pre_mask                 (dat2_pre_mask[63:0])           //|> w
  ,.dat2_pre_pvld                 (dat2_pre_pvld)                 //|> w
  ,.dat2_pre_stripe_end           (dat2_pre_stripe_end)           //|> w
  ,.dat2_pre_stripe_st            (dat2_pre_stripe_st)            //|> w
  ,.dat3_actv_data                (dat3_actv_data[1023:0])        //|> w
  ,.dat3_actv_nan                 (dat3_actv_nan[63:0])           //|> w
  ,.dat3_actv_nz                  (dat3_actv_nz[127:0])           //|> w
  ,.dat3_actv_pvld                (dat3_actv_pvld[103:0])         //|> w
  ,.dat3_pre_exp                  (dat3_pre_exp[191:0])           //|> w
  ,.dat3_pre_mask                 (dat3_pre_mask[63:0])           //|> w
  ,.dat3_pre_pvld                 (dat3_pre_pvld)                 //|> w
  ,.dat3_pre_stripe_end           (dat3_pre_stripe_end)           //|> w
  ,.dat3_pre_stripe_st            (dat3_pre_stripe_st)            //|> w
  ,.dat4_actv_data                (dat4_actv_data[1023:0])        //|> w
  ,.dat4_actv_nan                 (dat4_actv_nan[63:0])           //|> w
  ,.dat4_actv_nz                  (dat4_actv_nz[127:0])           //|> w
  ,.dat4_actv_pvld                (dat4_actv_pvld[103:0])         //|> w
  ,.dat4_pre_exp                  (dat4_pre_exp[191:0])           //|> w
  ,.dat4_pre_mask                 (dat4_pre_mask[63:0])           //|> w
  ,.dat4_pre_pvld                 (dat4_pre_pvld)                 //|> w
  ,.dat4_pre_stripe_end           (dat4_pre_stripe_end)           //|> w
  ,.dat4_pre_stripe_st            (dat4_pre_stripe_st)            //|> w
  ,.dat5_actv_data                (dat5_actv_data[1023:0])        //|> w
  ,.dat5_actv_nan                 (dat5_actv_nan[63:0])           //|> w
  ,.dat5_actv_nz                  (dat5_actv_nz[127:0])           //|> w
  ,.dat5_actv_pvld                (dat5_actv_pvld[103:0])         //|> w
  ,.dat5_pre_exp                  (dat5_pre_exp[191:0])           //|> w
  ,.dat5_pre_mask                 (dat5_pre_mask[63:0])           //|> w
  ,.dat5_pre_pvld                 (dat5_pre_pvld)                 //|> w
  ,.dat5_pre_stripe_end           (dat5_pre_stripe_end)           //|> w
  ,.dat5_pre_stripe_st            (dat5_pre_stripe_st)            //|> w
  ,.dat6_actv_data                (dat6_actv_data[1023:0])        //|> w
  ,.dat6_actv_nan                 (dat6_actv_nan[63:0])           //|> w
  ,.dat6_actv_nz                  (dat6_actv_nz[127:0])           //|> w
  ,.dat6_actv_pvld                (dat6_actv_pvld[103:0])         //|> w
  ,.dat6_pre_exp                  (dat6_pre_exp[191:0])           //|> w
  ,.dat6_pre_mask                 (dat6_pre_mask[63:0])           //|> w
  ,.dat6_pre_pvld                 (dat6_pre_pvld)                 //|> w
  ,.dat6_pre_stripe_end           (dat6_pre_stripe_end)           //|> w
  ,.dat6_pre_stripe_st            (dat6_pre_stripe_st)            //|> w
  ,.dat7_actv_data                (dat7_actv_data[1023:0])        //|> w
  ,.dat7_actv_nan                 (dat7_actv_nan[63:0])           //|> w
  ,.dat7_actv_nz                  (dat7_actv_nz[127:0])           //|> w
  ,.dat7_actv_pvld                (dat7_actv_pvld[103:0])         //|> w
  ,.dat7_pre_exp                  (dat7_pre_exp[191:0])           //|> w
  ,.dat7_pre_mask                 (dat7_pre_mask[63:0])           //|> w
  ,.dat7_pre_pvld                 (dat7_pre_pvld)                 //|> w
  ,.dat7_pre_stripe_end           (dat7_pre_stripe_end)           //|> w
  ,.dat7_pre_stripe_st            (dat7_pre_stripe_st)            //|> w
  ,.wt0_actv_data                 (wt0_actv_data[1023:0])         //|> w
  ,.wt0_actv_nan                  (wt0_actv_nan[63:0])            //|> w
  ,.wt0_actv_nz                   (wt0_actv_nz[127:0])            //|> w
  ,.wt0_actv_pvld                 (wt0_actv_pvld[103:0])          //|> w
  ,.wt0_sd_exp                    (wt0_sd_exp[191:0])             //|> w
  ,.wt0_sd_mask                   (wt0_sd_mask[63:0])             //|> w
  ,.wt0_sd_pvld                   (wt0_sd_pvld)                   //|> w
  ,.wt1_actv_data                 (wt1_actv_data[1023:0])         //|> w
  ,.wt1_actv_nan                  (wt1_actv_nan[63:0])            //|> w
  ,.wt1_actv_nz                   (wt1_actv_nz[127:0])            //|> w
  ,.wt1_actv_pvld                 (wt1_actv_pvld[103:0])          //|> w
  ,.wt1_sd_exp                    (wt1_sd_exp[191:0])             //|> w
  ,.wt1_sd_mask                   (wt1_sd_mask[63:0])             //|> w
  ,.wt1_sd_pvld                   (wt1_sd_pvld)                   //|> w
  ,.wt2_actv_data                 (wt2_actv_data[1023:0])         //|> w
  ,.wt2_actv_nan                  (wt2_actv_nan[63:0])            //|> w
  ,.wt2_actv_nz                   (wt2_actv_nz[127:0])            //|> w
  ,.wt2_actv_pvld                 (wt2_actv_pvld[103:0])          //|> w
  ,.wt2_sd_exp                    (wt2_sd_exp[191:0])             //|> w
  ,.wt2_sd_mask                   (wt2_sd_mask[63:0])             //|> w
  ,.wt2_sd_pvld                   (wt2_sd_pvld)                   //|> w
  ,.wt3_actv_data                 (wt3_actv_data[1023:0])         //|> w
  ,.wt3_actv_nan                  (wt3_actv_nan[63:0])            //|> w
  ,.wt3_actv_nz                   (wt3_actv_nz[127:0])            //|> w
  ,.wt3_actv_pvld                 (wt3_actv_pvld[103:0])          //|> w
  ,.wt3_sd_exp                    (wt3_sd_exp[191:0])             //|> w
  ,.wt3_sd_mask                   (wt3_sd_mask[63:0])             //|> w
  ,.wt3_sd_pvld                   (wt3_sd_pvld)                   //|> w
  ,.wt4_actv_data                 (wt4_actv_data[1023:0])         //|> w
  ,.wt4_actv_nan                  (wt4_actv_nan[63:0])            //|> w
  ,.wt4_actv_nz                   (wt4_actv_nz[127:0])            //|> w
  ,.wt4_actv_pvld                 (wt4_actv_pvld[103:0])          //|> w
  ,.wt4_sd_exp                    (wt4_sd_exp[191:0])             //|> w
  ,.wt4_sd_mask                   (wt4_sd_mask[63:0])             //|> w
  ,.wt4_sd_pvld                   (wt4_sd_pvld)                   //|> w
  ,.wt5_actv_data                 (wt5_actv_data[1023:0])         //|> w
  ,.wt5_actv_nan                  (wt5_actv_nan[63:0])            //|> w
  ,.wt5_actv_nz                   (wt5_actv_nz[127:0])            //|> w
  ,.wt5_actv_pvld                 (wt5_actv_pvld[103:0])          //|> w
  ,.wt5_sd_exp                    (wt5_sd_exp[191:0])             //|> w
  ,.wt5_sd_mask                   (wt5_sd_mask[63:0])             //|> w
  ,.wt5_sd_pvld                   (wt5_sd_pvld)                   //|> w
  ,.wt6_actv_data                 (wt6_actv_data[1023:0])         //|> w
  ,.wt6_actv_nan                  (wt6_actv_nan[63:0])            //|> w
  ,.wt6_actv_nz                   (wt6_actv_nz[127:0])            //|> w
  ,.wt6_actv_pvld                 (wt6_actv_pvld[103:0])          //|> w
  ,.wt6_sd_exp                    (wt6_sd_exp[191:0])             //|> w
  ,.wt6_sd_mask                   (wt6_sd_mask[63:0])             //|> w
  ,.wt6_sd_pvld                   (wt6_sd_pvld)                   //|> w
  ,.wt7_actv_data                 (wt7_actv_data[1023:0])         //|> w
  ,.wt7_actv_nan                  (wt7_actv_nan[63:0])            //|> w
  ,.wt7_actv_nz                   (wt7_actv_nz[127:0])            //|> w
  ,.wt7_actv_pvld                 (wt7_actv_pvld[103:0])          //|> w
  ,.wt7_sd_exp                    (wt7_sd_exp[191:0])             //|> w
  ,.wt7_sd_mask                   (wt7_sd_mask[63:0])             //|> w
  ,.wt7_sd_pvld                   (wt7_sd_pvld)                   //|> w
  );

//==========================================================
// MAC CELLs
//==========================================================

NV_NVDLA_CMAC_CORE_mac u_mac_0 (
   .nvdla_core_clk                (nvdla_op_gated_clk_0)          //|< w
  ,.nvdla_wg_clk                  (nvdla_wg_gated_clk_0)          //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.cfg_is_fp16                   (cfg_is_fp16)                   //|< w
  ,.cfg_is_int16                  (cfg_is_int16)                  //|< w
  ,.cfg_is_int8                   (cfg_is_int8)                   //|< w
  ,.cfg_is_wg                     (cfg_is_wg)                     //|< w
  ,.cfg_reg_en                    (cfg_reg_en)                    //|< w
  ,.dat_actv_data                 (dat0_actv_data[1023:0])        //|< w
  ,.dat_actv_nan                  (dat0_actv_nan[63:0])           //|< w
  ,.dat_actv_nz                   (dat0_actv_nz[127:0])           //|< w
  ,.dat_actv_pvld                 (dat0_actv_pvld[103:0])         //|< w
  ,.dat_pre_exp                   (dat0_pre_exp[191:0])           //|< w
  ,.dat_pre_mask                  (dat0_pre_mask[63:0])           //|< w
  ,.dat_pre_pvld                  (dat0_pre_pvld)                 //|< w
  ,.dat_pre_stripe_end            (dat0_pre_stripe_end)           //|< w
  ,.dat_pre_stripe_st             (dat0_pre_stripe_st)            //|< w
  ,.wt_actv_data                  (wt0_actv_data[1023:0])         //|< w
  ,.wt_actv_nan                   (wt0_actv_nan[63:0])            //|< w
  ,.wt_actv_nz                    (wt0_actv_nz[127:0])            //|< w
  ,.wt_actv_pvld                  (wt0_actv_pvld[103:0])          //|< w
  ,.wt_sd_exp                     (wt0_sd_exp[191:0])             //|< w
  ,.wt_sd_mask                    (wt0_sd_mask[63:0])             //|< w
  ,.wt_sd_pvld                    (wt0_sd_pvld)                   //|< w
  ,.mac_out_data                  (out_data0[175:0])              //|> w
  ,.mac_out_nan                   (out_nan[0])                    //|> w *
  ,.mac_out_pvld                  (out_mask[0])                   //|> w
  );


NV_NVDLA_CMAC_CORE_mac u_mac_1 (
   .nvdla_core_clk                (nvdla_op_gated_clk_1)          //|< w
  ,.nvdla_wg_clk                  (nvdla_wg_gated_clk_1)          //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.cfg_is_fp16                   (cfg_is_fp16)                   //|< w
  ,.cfg_is_int16                  (cfg_is_int16)                  //|< w
  ,.cfg_is_int8                   (cfg_is_int8)                   //|< w
  ,.cfg_is_wg                     (cfg_is_wg)                     //|< w
  ,.cfg_reg_en                    (cfg_reg_en)                    //|< w
  ,.dat_actv_data                 (dat1_actv_data[1023:0])        //|< w
  ,.dat_actv_nan                  (dat1_actv_nan[63:0])           //|< w
  ,.dat_actv_nz                   (dat1_actv_nz[127:0])           //|< w
  ,.dat_actv_pvld                 (dat1_actv_pvld[103:0])         //|< w
  ,.dat_pre_exp                   (dat1_pre_exp[191:0])           //|< w
  ,.dat_pre_mask                  (dat1_pre_mask[63:0])           //|< w
  ,.dat_pre_pvld                  (dat1_pre_pvld)                 //|< w
  ,.dat_pre_stripe_end            (dat1_pre_stripe_end)           //|< w
  ,.dat_pre_stripe_st             (dat1_pre_stripe_st)            //|< w
  ,.wt_actv_data                  (wt1_actv_data[1023:0])         //|< w
  ,.wt_actv_nan                   (wt1_actv_nan[63:0])            //|< w
  ,.wt_actv_nz                    (wt1_actv_nz[127:0])            //|< w
  ,.wt_actv_pvld                  (wt1_actv_pvld[103:0])          //|< w
  ,.wt_sd_exp                     (wt1_sd_exp[191:0])             //|< w
  ,.wt_sd_mask                    (wt1_sd_mask[63:0])             //|< w
  ,.wt_sd_pvld                    (wt1_sd_pvld)                   //|< w
  ,.mac_out_data                  (out_data1[175:0])              //|> w
  ,.mac_out_nan                   (out_nan[1])                    //|> w *
  ,.mac_out_pvld                  (out_mask[1])                   //|> w
  );


NV_NVDLA_CMAC_CORE_mac u_mac_2 (
   .nvdla_core_clk                (nvdla_op_gated_clk_2)          //|< w
  ,.nvdla_wg_clk                  (nvdla_wg_gated_clk_2)          //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.cfg_is_fp16                   (cfg_is_fp16)                   //|< w
  ,.cfg_is_int16                  (cfg_is_int16)                  //|< w
  ,.cfg_is_int8                   (cfg_is_int8)                   //|< w
  ,.cfg_is_wg                     (cfg_is_wg)                     //|< w
  ,.cfg_reg_en                    (cfg_reg_en)                    //|< w
  ,.dat_actv_data                 (dat2_actv_data[1023:0])        //|< w
  ,.dat_actv_nan                  (dat2_actv_nan[63:0])           //|< w
  ,.dat_actv_nz                   (dat2_actv_nz[127:0])           //|< w
  ,.dat_actv_pvld                 (dat2_actv_pvld[103:0])         //|< w
  ,.dat_pre_exp                   (dat2_pre_exp[191:0])           //|< w
  ,.dat_pre_mask                  (dat2_pre_mask[63:0])           //|< w
  ,.dat_pre_pvld                  (dat2_pre_pvld)                 //|< w
  ,.dat_pre_stripe_end            (dat2_pre_stripe_end)           //|< w
  ,.dat_pre_stripe_st             (dat2_pre_stripe_st)            //|< w
  ,.wt_actv_data                  (wt2_actv_data[1023:0])         //|< w
  ,.wt_actv_nan                   (wt2_actv_nan[63:0])            //|< w
  ,.wt_actv_nz                    (wt2_actv_nz[127:0])            //|< w
  ,.wt_actv_pvld                  (wt2_actv_pvld[103:0])          //|< w
  ,.wt_sd_exp                     (wt2_sd_exp[191:0])             //|< w
  ,.wt_sd_mask                    (wt2_sd_mask[63:0])             //|< w
  ,.wt_sd_pvld                    (wt2_sd_pvld)                   //|< w
  ,.mac_out_data                  (out_data2[175:0])              //|> w
  ,.mac_out_nan                   (out_nan[2])                    //|> w *
  ,.mac_out_pvld                  (out_mask[2])                   //|> w
  );


NV_NVDLA_CMAC_CORE_mac u_mac_3 (
   .nvdla_core_clk                (nvdla_op_gated_clk_3)          //|< w
  ,.nvdla_wg_clk                  (nvdla_wg_gated_clk_3)          //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.cfg_is_fp16                   (cfg_is_fp16)                   //|< w
  ,.cfg_is_int16                  (cfg_is_int16)                  //|< w
  ,.cfg_is_int8                   (cfg_is_int8)                   //|< w
  ,.cfg_is_wg                     (cfg_is_wg)                     //|< w
  ,.cfg_reg_en                    (cfg_reg_en)                    //|< w
  ,.dat_actv_data                 (dat3_actv_data[1023:0])        //|< w
  ,.dat_actv_nan                  (dat3_actv_nan[63:0])           //|< w
  ,.dat_actv_nz                   (dat3_actv_nz[127:0])           //|< w
  ,.dat_actv_pvld                 (dat3_actv_pvld[103:0])         //|< w
  ,.dat_pre_exp                   (dat3_pre_exp[191:0])           //|< w
  ,.dat_pre_mask                  (dat3_pre_mask[63:0])           //|< w
  ,.dat_pre_pvld                  (dat3_pre_pvld)                 //|< w
  ,.dat_pre_stripe_end            (dat3_pre_stripe_end)           //|< w
  ,.dat_pre_stripe_st             (dat3_pre_stripe_st)            //|< w
  ,.wt_actv_data                  (wt3_actv_data[1023:0])         //|< w
  ,.wt_actv_nan                   (wt3_actv_nan[63:0])            //|< w
  ,.wt_actv_nz                    (wt3_actv_nz[127:0])            //|< w
  ,.wt_actv_pvld                  (wt3_actv_pvld[103:0])          //|< w
  ,.wt_sd_exp                     (wt3_sd_exp[191:0])             //|< w
  ,.wt_sd_mask                    (wt3_sd_mask[63:0])             //|< w
  ,.wt_sd_pvld                    (wt3_sd_pvld)                   //|< w
  ,.mac_out_data                  (out_data3[175:0])              //|> w
  ,.mac_out_nan                   (out_nan[3])                    //|> w *
  ,.mac_out_pvld                  (out_mask[3])                   //|> w
  );


NV_NVDLA_CMAC_CORE_mac u_mac_4 (
   .nvdla_core_clk                (nvdla_op_gated_clk_4)          //|< w
  ,.nvdla_wg_clk                  (nvdla_wg_gated_clk_4)          //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.cfg_is_fp16                   (cfg_is_fp16)                   //|< w
  ,.cfg_is_int16                  (cfg_is_int16)                  //|< w
  ,.cfg_is_int8                   (cfg_is_int8)                   //|< w
  ,.cfg_is_wg                     (cfg_is_wg)                     //|< w
  ,.cfg_reg_en                    (cfg_reg_en)                    //|< w
  ,.dat_actv_data                 (dat4_actv_data[1023:0])        //|< w
  ,.dat_actv_nan                  (dat4_actv_nan[63:0])           //|< w
  ,.dat_actv_nz                   (dat4_actv_nz[127:0])           //|< w
  ,.dat_actv_pvld                 (dat4_actv_pvld[103:0])         //|< w
  ,.dat_pre_exp                   (dat4_pre_exp[191:0])           //|< w
  ,.dat_pre_mask                  (dat4_pre_mask[63:0])           //|< w
  ,.dat_pre_pvld                  (dat4_pre_pvld)                 //|< w
  ,.dat_pre_stripe_end            (dat4_pre_stripe_end)           //|< w
  ,.dat_pre_stripe_st             (dat4_pre_stripe_st)            //|< w
  ,.wt_actv_data                  (wt4_actv_data[1023:0])         //|< w
  ,.wt_actv_nan                   (wt4_actv_nan[63:0])            //|< w
  ,.wt_actv_nz                    (wt4_actv_nz[127:0])            //|< w
  ,.wt_actv_pvld                  (wt4_actv_pvld[103:0])          //|< w
  ,.wt_sd_exp                     (wt4_sd_exp[191:0])             //|< w
  ,.wt_sd_mask                    (wt4_sd_mask[63:0])             //|< w
  ,.wt_sd_pvld                    (wt4_sd_pvld)                   //|< w
  ,.mac_out_data                  (out_data4[175:0])              //|> w
  ,.mac_out_nan                   (out_nan[4])                    //|> w *
  ,.mac_out_pvld                  (out_mask[4])                   //|> w
  );


NV_NVDLA_CMAC_CORE_mac u_mac_5 (
   .nvdla_core_clk                (nvdla_op_gated_clk_5)          //|< w
  ,.nvdla_wg_clk                  (nvdla_wg_gated_clk_5)          //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.cfg_is_fp16                   (cfg_is_fp16)                   //|< w
  ,.cfg_is_int16                  (cfg_is_int16)                  //|< w
  ,.cfg_is_int8                   (cfg_is_int8)                   //|< w
  ,.cfg_is_wg                     (cfg_is_wg)                     //|< w
  ,.cfg_reg_en                    (cfg_reg_en)                    //|< w
  ,.dat_actv_data                 (dat5_actv_data[1023:0])        //|< w
  ,.dat_actv_nan                  (dat5_actv_nan[63:0])           //|< w
  ,.dat_actv_nz                   (dat5_actv_nz[127:0])           //|< w
  ,.dat_actv_pvld                 (dat5_actv_pvld[103:0])         //|< w
  ,.dat_pre_exp                   (dat5_pre_exp[191:0])           //|< w
  ,.dat_pre_mask                  (dat5_pre_mask[63:0])           //|< w
  ,.dat_pre_pvld                  (dat5_pre_pvld)                 //|< w
  ,.dat_pre_stripe_end            (dat5_pre_stripe_end)           //|< w
  ,.dat_pre_stripe_st             (dat5_pre_stripe_st)            //|< w
  ,.wt_actv_data                  (wt5_actv_data[1023:0])         //|< w
  ,.wt_actv_nan                   (wt5_actv_nan[63:0])            //|< w
  ,.wt_actv_nz                    (wt5_actv_nz[127:0])            //|< w
  ,.wt_actv_pvld                  (wt5_actv_pvld[103:0])          //|< w
  ,.wt_sd_exp                     (wt5_sd_exp[191:0])             //|< w
  ,.wt_sd_mask                    (wt5_sd_mask[63:0])             //|< w
  ,.wt_sd_pvld                    (wt5_sd_pvld)                   //|< w
  ,.mac_out_data                  (out_data5[175:0])              //|> w
  ,.mac_out_nan                   (out_nan[5])                    //|> w *
  ,.mac_out_pvld                  (out_mask[5])                   //|> w
  );


NV_NVDLA_CMAC_CORE_mac u_mac_6 (
   .nvdla_core_clk                (nvdla_op_gated_clk_6)          //|< w
  ,.nvdla_wg_clk                  (nvdla_wg_gated_clk_6)          //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.cfg_is_fp16                   (cfg_is_fp16)                   //|< w
  ,.cfg_is_int16                  (cfg_is_int16)                  //|< w
  ,.cfg_is_int8                   (cfg_is_int8)                   //|< w
  ,.cfg_is_wg                     (cfg_is_wg)                     //|< w
  ,.cfg_reg_en                    (cfg_reg_en)                    //|< w
  ,.dat_actv_data                 (dat6_actv_data[1023:0])        //|< w
  ,.dat_actv_nan                  (dat6_actv_nan[63:0])           //|< w
  ,.dat_actv_nz                   (dat6_actv_nz[127:0])           //|< w
  ,.dat_actv_pvld                 (dat6_actv_pvld[103:0])         //|< w
  ,.dat_pre_exp                   (dat6_pre_exp[191:0])           //|< w
  ,.dat_pre_mask                  (dat6_pre_mask[63:0])           //|< w
  ,.dat_pre_pvld                  (dat6_pre_pvld)                 //|< w
  ,.dat_pre_stripe_end            (dat6_pre_stripe_end)           //|< w
  ,.dat_pre_stripe_st             (dat6_pre_stripe_st)            //|< w
  ,.wt_actv_data                  (wt6_actv_data[1023:0])         //|< w
  ,.wt_actv_nan                   (wt6_actv_nan[63:0])            //|< w
  ,.wt_actv_nz                    (wt6_actv_nz[127:0])            //|< w
  ,.wt_actv_pvld                  (wt6_actv_pvld[103:0])          //|< w
  ,.wt_sd_exp                     (wt6_sd_exp[191:0])             //|< w
  ,.wt_sd_mask                    (wt6_sd_mask[63:0])             //|< w
  ,.wt_sd_pvld                    (wt6_sd_pvld)                   //|< w
  ,.mac_out_data                  (out_data6[175:0])              //|> w
  ,.mac_out_nan                   (out_nan[6])                    //|> w *
  ,.mac_out_pvld                  (out_mask[6])                   //|> w
  );


NV_NVDLA_CMAC_CORE_mac u_mac_7 (
   .nvdla_core_clk                (nvdla_op_gated_clk_7)          //|< w
  ,.nvdla_wg_clk                  (nvdla_wg_gated_clk_7)          //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.cfg_is_fp16                   (cfg_is_fp16)                   //|< w
  ,.cfg_is_int16                  (cfg_is_int16)                  //|< w
  ,.cfg_is_int8                   (cfg_is_int8)                   //|< w
  ,.cfg_is_wg                     (cfg_is_wg)                     //|< w
  ,.cfg_reg_en                    (cfg_reg_en)                    //|< w
  ,.dat_actv_data                 (dat7_actv_data[1023:0])        //|< w
  ,.dat_actv_nan                  (dat7_actv_nan[63:0])           //|< w
  ,.dat_actv_nz                   (dat7_actv_nz[127:0])           //|< w
  ,.dat_actv_pvld                 (dat7_actv_pvld[103:0])         //|< w
  ,.dat_pre_exp                   (dat7_pre_exp[191:0])           //|< w
  ,.dat_pre_mask                  (dat7_pre_mask[63:0])           //|< w
  ,.dat_pre_pvld                  (dat7_pre_pvld)                 //|< w
  ,.dat_pre_stripe_end            (dat7_pre_stripe_end)           //|< w
  ,.dat_pre_stripe_st             (dat7_pre_stripe_st)            //|< w
  ,.wt_actv_data                  (wt7_actv_data[1023:0])         //|< w
  ,.wt_actv_nan                   (wt7_actv_nan[63:0])            //|< w
  ,.wt_actv_nz                    (wt7_actv_nz[127:0])            //|< w
  ,.wt_actv_pvld                  (wt7_actv_pvld[103:0])          //|< w
  ,.wt_sd_exp                     (wt7_sd_exp[191:0])             //|< w
  ,.wt_sd_mask                    (wt7_sd_mask[63:0])             //|< w
  ,.wt_sd_pvld                    (wt7_sd_pvld)                   //|< w
  ,.mac_out_data                  (out_data7[175:0])              //|> w
  ,.mac_out_nan                   (out_nan[7])                    //|> w *
  ,.mac_out_pvld                  (out_mask[7])                   //|> w
  );





//==========================================================
// output retiming logic            
//==========================================================
NV_NVDLA_CMAC_CORE_rt_out u_rt_out (
   .nvdla_core_clk                (nvdla_op_gated_clk_8)          //|< w
  ,.nvdla_wg_clk                  (nvdla_wg_gated_clk_8)          //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.cfg_is_wg                     (cfg_is_wg)                     //|< w
  ,.cfg_reg_en                    (cfg_reg_en)                    //|< w
  ,.out_data0                     (out_data0[175:0])              //|< w
  ,.out_data1                     (out_data1[175:0])              //|< w
  ,.out_data2                     (out_data2[175:0])              //|< w
  ,.out_data3                     (out_data3[175:0])              //|< w
  ,.out_data4                     (out_data4[175:0])              //|< w
  ,.out_data5                     (out_data5[175:0])              //|< w
  ,.out_data6                     (out_data6[175:0])              //|< w
  ,.out_data7                     (out_data7[175:0])              //|< w
  ,.out_mask                      (out_mask[7:0])                 //|< w
  ,.out_pd                        (out_pd[8:0])                   //|< w
  ,.out_pvld                      (out_pvld)                      //|< w
  ,.dp2reg_done                   (dp2reg_done)                   //|> o
  ,.mac2accu_data0                (mac2accu_data0[175:0])         //|> o
  ,.mac2accu_data1                (mac2accu_data1[175:0])         //|> o
  ,.mac2accu_data2                (mac2accu_data2[175:0])         //|> o
  ,.mac2accu_data3                (mac2accu_data3[175:0])         //|> o
  ,.mac2accu_data4                (mac2accu_data4[175:0])         //|> o
  ,.mac2accu_data5                (mac2accu_data5[175:0])         //|> o
  ,.mac2accu_data6                (mac2accu_data6[175:0])         //|> o
  ,.mac2accu_data7                (mac2accu_data7[175:0])         //|> o
  ,.mac2accu_mask                 (mac2accu_mask[7:0])            //|> o
  ,.mac2accu_mode                 (mac2accu_mode[7:0])            //|> o
  ,.mac2accu_pd                   (mac2accu_pd[8:0])              //|> o
  ,.mac2accu_pvld                 (mac2accu_pvld)                 //|> o
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
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Error! sc2mac_dat_pvld set when dp2reg_done set!")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, (sc2mac_dat_pvld & dp2reg_done)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  nv_assert_never #(0,0,"Error! sc2mac_wt_pvld set when dp2reg_done set!")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, (sc2mac_wt_pvld & dp2reg_done)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//==========================================================
// SLCG groups
//==========================================================

NV_NVDLA_CMAC_CORE_slcg u_slcg_op_0 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[0])                 //|< i
  ,.slcg_en_src_1                 (1'b1)                          //|< ?
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_0)          //|> w
  );


NV_NVDLA_CMAC_CORE_slcg u_slcg_op_1 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[1])                 //|< i
  ,.slcg_en_src_1                 (1'b1)                          //|< ?
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_1)          //|> w
  );


NV_NVDLA_CMAC_CORE_slcg u_slcg_op_2 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[2])                 //|< i
  ,.slcg_en_src_1                 (1'b1)                          //|< ?
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_2)          //|> w
  );


NV_NVDLA_CMAC_CORE_slcg u_slcg_op_3 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[3])                 //|< i
  ,.slcg_en_src_1                 (1'b1)                          //|< ?
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_3)          //|> w
  );


NV_NVDLA_CMAC_CORE_slcg u_slcg_op_4 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[4])                 //|< i
  ,.slcg_en_src_1                 (1'b1)                          //|< ?
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_4)          //|> w
  );


NV_NVDLA_CMAC_CORE_slcg u_slcg_op_5 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[5])                 //|< i
  ,.slcg_en_src_1                 (1'b1)                          //|< ?
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_5)          //|> w
  );


NV_NVDLA_CMAC_CORE_slcg u_slcg_op_6 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[6])                 //|< i
  ,.slcg_en_src_1                 (1'b1)                          //|< ?
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_6)          //|> w
  );


NV_NVDLA_CMAC_CORE_slcg u_slcg_op_7 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[7])                 //|< i
  ,.slcg_en_src_1                 (1'b1)                          //|< ?
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_7)          //|> w
  );


NV_NVDLA_CMAC_CORE_slcg u_slcg_op_8 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[8])                 //|< i
  ,.slcg_en_src_1                 (1'b1)                          //|< ?
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_8)          //|> w
  );


NV_NVDLA_CMAC_CORE_slcg u_slcg_op_9 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[9])                 //|< i
  ,.slcg_en_src_1                 (1'b1)                          //|< ?
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_9)          //|> w
  );


NV_NVDLA_CMAC_CORE_slcg u_slcg_op_10 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[10])                //|< i
  ,.slcg_en_src_1                 (1'b1)                          //|< ?
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_10)         //|> w
  );


NV_NVDLA_CMAC_CORE_slcg u_slcg_wg_0 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[0])                 //|< i
  ,.slcg_en_src_1                 (slcg_wg_en[0])                 //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_wg_gated_clk_0)          //|> w
  );


NV_NVDLA_CMAC_CORE_slcg u_slcg_wg_1 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[1])                 //|< i
  ,.slcg_en_src_1                 (slcg_wg_en[1])                 //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_wg_gated_clk_1)          //|> w
  );


NV_NVDLA_CMAC_CORE_slcg u_slcg_wg_2 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[2])                 //|< i
  ,.slcg_en_src_1                 (slcg_wg_en[2])                 //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_wg_gated_clk_2)          //|> w
  );


NV_NVDLA_CMAC_CORE_slcg u_slcg_wg_3 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[3])                 //|< i
  ,.slcg_en_src_1                 (slcg_wg_en[3])                 //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_wg_gated_clk_3)          //|> w
  );


NV_NVDLA_CMAC_CORE_slcg u_slcg_wg_4 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[4])                 //|< i
  ,.slcg_en_src_1                 (slcg_wg_en[4])                 //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_wg_gated_clk_4)          //|> w
  );


NV_NVDLA_CMAC_CORE_slcg u_slcg_wg_5 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[5])                 //|< i
  ,.slcg_en_src_1                 (slcg_wg_en[5])                 //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_wg_gated_clk_5)          //|> w
  );


NV_NVDLA_CMAC_CORE_slcg u_slcg_wg_6 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[6])                 //|< i
  ,.slcg_en_src_1                 (slcg_wg_en[6])                 //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_wg_gated_clk_6)          //|> w
  );


NV_NVDLA_CMAC_CORE_slcg u_slcg_wg_7 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[7])                 //|< i
  ,.slcg_en_src_1                 (slcg_wg_en[7])                 //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_wg_gated_clk_7)          //|> w
  );


NV_NVDLA_CMAC_CORE_slcg u_slcg_wg_8 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)           //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)        //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)               //|< i
  ,.slcg_en_src_0                 (slcg_op_en[8])                 //|< i
  ,.slcg_en_src_1                 (slcg_wg_en[8])                 //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating) //|< i
  ,.nvdla_core_gated_clk          (nvdla_wg_gated_clk_8)          //|> w
  );


//==========================================================
// Signals for debugging
//==========================================================

`ifndef SYNTHESIS

//////// for valid forwarding ///////

assign dbg_out_pvld_d0 = out_pvld;
assign dbg_out_pd_d0 = out_pd;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    `ifndef SYNTHESIS
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    dbg_out_pvld_d1 <= 1'b0;
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    `endif
  end else begin
  dbg_out_pvld_d1 <= dbg_out_pvld_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    `ifndef SYNTHESIS
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    dbg_out_pd_d1 <= {9{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    `endif
  end else begin
  if ((dbg_out_pvld_d0) == 1'b1) begin
    dbg_out_pd_d1 <= dbg_out_pd_d0;
  // VCS coverage off
  end else if ((dbg_out_pvld_d0) == 1'b0) begin
  end else begin
    dbg_out_pd_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbg_out_pvld_d0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    `ifndef SYNTHESIS
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    dbg_out_pvld_d2 <= 1'b0;
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    `endif
  end else begin
  dbg_out_pvld_d2 <= dbg_out_pvld_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    `ifndef SYNTHESIS
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    dbg_out_pd_d2 <= {9{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    `endif
  end else begin
  if ((dbg_out_pvld_d1) == 1'b1) begin
    dbg_out_pd_d2 <= dbg_out_pd_d1;
  // VCS coverage off
  end else if ((dbg_out_pvld_d1) == 1'b0) begin
  end else begin
    dbg_out_pd_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbg_out_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    `ifndef SYNTHESIS
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    dbg_out_pvld_d3 <= 1'b0;
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    `endif
  end else begin
  dbg_out_pvld_d3 <= dbg_out_pvld_d2;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    `ifndef SYNTHESIS
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    dbg_out_pd_d3 <= {9{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    `endif
  end else begin
  if ((dbg_out_pvld_d2) == 1'b1) begin
    dbg_out_pd_d3 <= dbg_out_pd_d2;
  // VCS coverage off
  end else if ((dbg_out_pvld_d2) == 1'b0) begin
  end else begin
    dbg_out_pd_d3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbg_out_pvld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    `ifndef SYNTHESIS
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    dbg_out_pvld_d4 <= 1'b0;
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    `endif
  end else begin
  dbg_out_pvld_d4 <= dbg_out_pvld_d3;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    `ifndef SYNTHESIS
    // spyglass disable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    dbg_out_pd_d4 <= {9{1'b0}};
    // spyglass enable_block UnloadedNet-ML UnloadedOutTerm-ML W528 W123 W287a
    `endif
  end else begin
  if ((dbg_out_pvld_d3) == 1'b1) begin
    dbg_out_pd_d4 <= dbg_out_pd_d3;
  // VCS coverage off
  end else if ((dbg_out_pvld_d3) == 1'b0) begin
  end else begin
    dbg_out_pd_d4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(dbg_out_pvld_d3))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON


assign dbg_mac2accu_pvld = dbg_out_pvld_d4;
assign dbg_mac2accu_pd = dbg_out_pd_d4;


`endif

// //==========================================================
// // OBS connection
// //==========================================================
// assign obs_bus_cmac_out_pvld          = out_pvld;
// assign obs_bus_cmac_out_mask          = out_mask;
// assign obs_bus_cmac_out_pd            = out_pd;
// assign obs_bus_cmac_out_nan           = out_nan;
// assign obs_bus_cmac_dp2reg_done       = dp2reg_done;
// assign obs_bus_cmac_cfg_reg_en        = cfg_reg_en;
// assign obs_bus_cmac_cfg_is_fp16       = cfg_is_fp16;
// assign obs_bus_cmac_cfg_is_int16      = cfg_is_int16;
// assign obs_bus_cmac_cfg_is_int8       = cfg_is_int8;
// assign obs_bus_cmac_cfg_is_wg         = cfg_is_wg;
// assign obs_bus_cmac_in_dat_pvld       = in_dat_pvld;
// assign obs_bus_cmac_in_dat_stripe_st  = in_dat_stripe_st;
// assign obs_bus_cmac_in_dat_stripe_end = in_dat_stripe_end;
// assign obs_bus_cmac_in_wt_pvld        = in_wt_pvld;
// assign obs_bus_cmac_in_wt_sel         = in_wt_sel;
// assign obs_bus_cmac_slcg_op_en        = slcg_op_en;
// assign obs_bus_cmac_slcg_wg_en        = slcg_wg_en;

endmodule // NV_NVDLA_CMAC_core

