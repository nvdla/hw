// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CMAC_CORE_rt_in.v

module NV_NVDLA_CMAC_CORE_rt_in (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,sc2mac_dat_data0
  ,sc2mac_dat_data1
  ,sc2mac_dat_data10
  ,sc2mac_dat_data100
  ,sc2mac_dat_data101
  ,sc2mac_dat_data102
  ,sc2mac_dat_data103
  ,sc2mac_dat_data104
  ,sc2mac_dat_data105
  ,sc2mac_dat_data106
  ,sc2mac_dat_data107
  ,sc2mac_dat_data108
  ,sc2mac_dat_data109
  ,sc2mac_dat_data11
  ,sc2mac_dat_data110
  ,sc2mac_dat_data111
  ,sc2mac_dat_data112
  ,sc2mac_dat_data113
  ,sc2mac_dat_data114
  ,sc2mac_dat_data115
  ,sc2mac_dat_data116
  ,sc2mac_dat_data117
  ,sc2mac_dat_data118
  ,sc2mac_dat_data119
  ,sc2mac_dat_data12
  ,sc2mac_dat_data120
  ,sc2mac_dat_data121
  ,sc2mac_dat_data122
  ,sc2mac_dat_data123
  ,sc2mac_dat_data124
  ,sc2mac_dat_data125
  ,sc2mac_dat_data126
  ,sc2mac_dat_data127
  ,sc2mac_dat_data13
  ,sc2mac_dat_data14
  ,sc2mac_dat_data15
  ,sc2mac_dat_data16
  ,sc2mac_dat_data17
  ,sc2mac_dat_data18
  ,sc2mac_dat_data19
  ,sc2mac_dat_data2
  ,sc2mac_dat_data20
  ,sc2mac_dat_data21
  ,sc2mac_dat_data22
  ,sc2mac_dat_data23
  ,sc2mac_dat_data24
  ,sc2mac_dat_data25
  ,sc2mac_dat_data26
  ,sc2mac_dat_data27
  ,sc2mac_dat_data28
  ,sc2mac_dat_data29
  ,sc2mac_dat_data3
  ,sc2mac_dat_data30
  ,sc2mac_dat_data31
  ,sc2mac_dat_data32
  ,sc2mac_dat_data33
  ,sc2mac_dat_data34
  ,sc2mac_dat_data35
  ,sc2mac_dat_data36
  ,sc2mac_dat_data37
  ,sc2mac_dat_data38
  ,sc2mac_dat_data39
  ,sc2mac_dat_data4
  ,sc2mac_dat_data40
  ,sc2mac_dat_data41
  ,sc2mac_dat_data42
  ,sc2mac_dat_data43
  ,sc2mac_dat_data44
  ,sc2mac_dat_data45
  ,sc2mac_dat_data46
  ,sc2mac_dat_data47
  ,sc2mac_dat_data48
  ,sc2mac_dat_data49
  ,sc2mac_dat_data5
  ,sc2mac_dat_data50
  ,sc2mac_dat_data51
  ,sc2mac_dat_data52
  ,sc2mac_dat_data53
  ,sc2mac_dat_data54
  ,sc2mac_dat_data55
  ,sc2mac_dat_data56
  ,sc2mac_dat_data57
  ,sc2mac_dat_data58
  ,sc2mac_dat_data59
  ,sc2mac_dat_data6
  ,sc2mac_dat_data60
  ,sc2mac_dat_data61
  ,sc2mac_dat_data62
  ,sc2mac_dat_data63
  ,sc2mac_dat_data64
  ,sc2mac_dat_data65
  ,sc2mac_dat_data66
  ,sc2mac_dat_data67
  ,sc2mac_dat_data68
  ,sc2mac_dat_data69
  ,sc2mac_dat_data7
  ,sc2mac_dat_data70
  ,sc2mac_dat_data71
  ,sc2mac_dat_data72
  ,sc2mac_dat_data73
  ,sc2mac_dat_data74
  ,sc2mac_dat_data75
  ,sc2mac_dat_data76
  ,sc2mac_dat_data77
  ,sc2mac_dat_data78
  ,sc2mac_dat_data79
  ,sc2mac_dat_data8
  ,sc2mac_dat_data80
  ,sc2mac_dat_data81
  ,sc2mac_dat_data82
  ,sc2mac_dat_data83
  ,sc2mac_dat_data84
  ,sc2mac_dat_data85
  ,sc2mac_dat_data86
  ,sc2mac_dat_data87
  ,sc2mac_dat_data88
  ,sc2mac_dat_data89
  ,sc2mac_dat_data9
  ,sc2mac_dat_data90
  ,sc2mac_dat_data91
  ,sc2mac_dat_data92
  ,sc2mac_dat_data93
  ,sc2mac_dat_data94
  ,sc2mac_dat_data95
  ,sc2mac_dat_data96
  ,sc2mac_dat_data97
  ,sc2mac_dat_data98
  ,sc2mac_dat_data99
  ,sc2mac_dat_mask
  ,sc2mac_dat_pd
  ,sc2mac_dat_pvld
  ,sc2mac_wt_data0
  ,sc2mac_wt_data1
  ,sc2mac_wt_data10
  ,sc2mac_wt_data100
  ,sc2mac_wt_data101
  ,sc2mac_wt_data102
  ,sc2mac_wt_data103
  ,sc2mac_wt_data104
  ,sc2mac_wt_data105
  ,sc2mac_wt_data106
  ,sc2mac_wt_data107
  ,sc2mac_wt_data108
  ,sc2mac_wt_data109
  ,sc2mac_wt_data11
  ,sc2mac_wt_data110
  ,sc2mac_wt_data111
  ,sc2mac_wt_data112
  ,sc2mac_wt_data113
  ,sc2mac_wt_data114
  ,sc2mac_wt_data115
  ,sc2mac_wt_data116
  ,sc2mac_wt_data117
  ,sc2mac_wt_data118
  ,sc2mac_wt_data119
  ,sc2mac_wt_data12
  ,sc2mac_wt_data120
  ,sc2mac_wt_data121
  ,sc2mac_wt_data122
  ,sc2mac_wt_data123
  ,sc2mac_wt_data124
  ,sc2mac_wt_data125
  ,sc2mac_wt_data126
  ,sc2mac_wt_data127
  ,sc2mac_wt_data13
  ,sc2mac_wt_data14
  ,sc2mac_wt_data15
  ,sc2mac_wt_data16
  ,sc2mac_wt_data17
  ,sc2mac_wt_data18
  ,sc2mac_wt_data19
  ,sc2mac_wt_data2
  ,sc2mac_wt_data20
  ,sc2mac_wt_data21
  ,sc2mac_wt_data22
  ,sc2mac_wt_data23
  ,sc2mac_wt_data24
  ,sc2mac_wt_data25
  ,sc2mac_wt_data26
  ,sc2mac_wt_data27
  ,sc2mac_wt_data28
  ,sc2mac_wt_data29
  ,sc2mac_wt_data3
  ,sc2mac_wt_data30
  ,sc2mac_wt_data31
  ,sc2mac_wt_data32
  ,sc2mac_wt_data33
  ,sc2mac_wt_data34
  ,sc2mac_wt_data35
  ,sc2mac_wt_data36
  ,sc2mac_wt_data37
  ,sc2mac_wt_data38
  ,sc2mac_wt_data39
  ,sc2mac_wt_data4
  ,sc2mac_wt_data40
  ,sc2mac_wt_data41
  ,sc2mac_wt_data42
  ,sc2mac_wt_data43
  ,sc2mac_wt_data44
  ,sc2mac_wt_data45
  ,sc2mac_wt_data46
  ,sc2mac_wt_data47
  ,sc2mac_wt_data48
  ,sc2mac_wt_data49
  ,sc2mac_wt_data5
  ,sc2mac_wt_data50
  ,sc2mac_wt_data51
  ,sc2mac_wt_data52
  ,sc2mac_wt_data53
  ,sc2mac_wt_data54
  ,sc2mac_wt_data55
  ,sc2mac_wt_data56
  ,sc2mac_wt_data57
  ,sc2mac_wt_data58
  ,sc2mac_wt_data59
  ,sc2mac_wt_data6
  ,sc2mac_wt_data60
  ,sc2mac_wt_data61
  ,sc2mac_wt_data62
  ,sc2mac_wt_data63
  ,sc2mac_wt_data64
  ,sc2mac_wt_data65
  ,sc2mac_wt_data66
  ,sc2mac_wt_data67
  ,sc2mac_wt_data68
  ,sc2mac_wt_data69
  ,sc2mac_wt_data7
  ,sc2mac_wt_data70
  ,sc2mac_wt_data71
  ,sc2mac_wt_data72
  ,sc2mac_wt_data73
  ,sc2mac_wt_data74
  ,sc2mac_wt_data75
  ,sc2mac_wt_data76
  ,sc2mac_wt_data77
  ,sc2mac_wt_data78
  ,sc2mac_wt_data79
  ,sc2mac_wt_data8
  ,sc2mac_wt_data80
  ,sc2mac_wt_data81
  ,sc2mac_wt_data82
  ,sc2mac_wt_data83
  ,sc2mac_wt_data84
  ,sc2mac_wt_data85
  ,sc2mac_wt_data86
  ,sc2mac_wt_data87
  ,sc2mac_wt_data88
  ,sc2mac_wt_data89
  ,sc2mac_wt_data9
  ,sc2mac_wt_data90
  ,sc2mac_wt_data91
  ,sc2mac_wt_data92
  ,sc2mac_wt_data93
  ,sc2mac_wt_data94
  ,sc2mac_wt_data95
  ,sc2mac_wt_data96
  ,sc2mac_wt_data97
  ,sc2mac_wt_data98
  ,sc2mac_wt_data99
  ,sc2mac_wt_mask
  ,sc2mac_wt_pvld
  ,sc2mac_wt_sel
  ,in_dat_data0
  ,in_dat_data1
  ,in_dat_data10
  ,in_dat_data100
  ,in_dat_data101
  ,in_dat_data102
  ,in_dat_data103
  ,in_dat_data104
  ,in_dat_data105
  ,in_dat_data106
  ,in_dat_data107
  ,in_dat_data108
  ,in_dat_data109
  ,in_dat_data11
  ,in_dat_data110
  ,in_dat_data111
  ,in_dat_data112
  ,in_dat_data113
  ,in_dat_data114
  ,in_dat_data115
  ,in_dat_data116
  ,in_dat_data117
  ,in_dat_data118
  ,in_dat_data119
  ,in_dat_data12
  ,in_dat_data120
  ,in_dat_data121
  ,in_dat_data122
  ,in_dat_data123
  ,in_dat_data124
  ,in_dat_data125
  ,in_dat_data126
  ,in_dat_data127
  ,in_dat_data13
  ,in_dat_data14
  ,in_dat_data15
  ,in_dat_data16
  ,in_dat_data17
  ,in_dat_data18
  ,in_dat_data19
  ,in_dat_data2
  ,in_dat_data20
  ,in_dat_data21
  ,in_dat_data22
  ,in_dat_data23
  ,in_dat_data24
  ,in_dat_data25
  ,in_dat_data26
  ,in_dat_data27
  ,in_dat_data28
  ,in_dat_data29
  ,in_dat_data3
  ,in_dat_data30
  ,in_dat_data31
  ,in_dat_data32
  ,in_dat_data33
  ,in_dat_data34
  ,in_dat_data35
  ,in_dat_data36
  ,in_dat_data37
  ,in_dat_data38
  ,in_dat_data39
  ,in_dat_data4
  ,in_dat_data40
  ,in_dat_data41
  ,in_dat_data42
  ,in_dat_data43
  ,in_dat_data44
  ,in_dat_data45
  ,in_dat_data46
  ,in_dat_data47
  ,in_dat_data48
  ,in_dat_data49
  ,in_dat_data5
  ,in_dat_data50
  ,in_dat_data51
  ,in_dat_data52
  ,in_dat_data53
  ,in_dat_data54
  ,in_dat_data55
  ,in_dat_data56
  ,in_dat_data57
  ,in_dat_data58
  ,in_dat_data59
  ,in_dat_data6
  ,in_dat_data60
  ,in_dat_data61
  ,in_dat_data62
  ,in_dat_data63
  ,in_dat_data64
  ,in_dat_data65
  ,in_dat_data66
  ,in_dat_data67
  ,in_dat_data68
  ,in_dat_data69
  ,in_dat_data7
  ,in_dat_data70
  ,in_dat_data71
  ,in_dat_data72
  ,in_dat_data73
  ,in_dat_data74
  ,in_dat_data75
  ,in_dat_data76
  ,in_dat_data77
  ,in_dat_data78
  ,in_dat_data79
  ,in_dat_data8
  ,in_dat_data80
  ,in_dat_data81
  ,in_dat_data82
  ,in_dat_data83
  ,in_dat_data84
  ,in_dat_data85
  ,in_dat_data86
  ,in_dat_data87
  ,in_dat_data88
  ,in_dat_data89
  ,in_dat_data9
  ,in_dat_data90
  ,in_dat_data91
  ,in_dat_data92
  ,in_dat_data93
  ,in_dat_data94
  ,in_dat_data95
  ,in_dat_data96
  ,in_dat_data97
  ,in_dat_data98
  ,in_dat_data99
  ,in_dat_mask
  ,in_dat_pd
  ,in_dat_pvld
  ,in_dat_stripe_end
  ,in_dat_stripe_st
  ,in_wt_data0
  ,in_wt_data1
  ,in_wt_data10
  ,in_wt_data100
  ,in_wt_data101
  ,in_wt_data102
  ,in_wt_data103
  ,in_wt_data104
  ,in_wt_data105
  ,in_wt_data106
  ,in_wt_data107
  ,in_wt_data108
  ,in_wt_data109
  ,in_wt_data11
  ,in_wt_data110
  ,in_wt_data111
  ,in_wt_data112
  ,in_wt_data113
  ,in_wt_data114
  ,in_wt_data115
  ,in_wt_data116
  ,in_wt_data117
  ,in_wt_data118
  ,in_wt_data119
  ,in_wt_data12
  ,in_wt_data120
  ,in_wt_data121
  ,in_wt_data122
  ,in_wt_data123
  ,in_wt_data124
  ,in_wt_data125
  ,in_wt_data126
  ,in_wt_data127
  ,in_wt_data13
  ,in_wt_data14
  ,in_wt_data15
  ,in_wt_data16
  ,in_wt_data17
  ,in_wt_data18
  ,in_wt_data19
  ,in_wt_data2
  ,in_wt_data20
  ,in_wt_data21
  ,in_wt_data22
  ,in_wt_data23
  ,in_wt_data24
  ,in_wt_data25
  ,in_wt_data26
  ,in_wt_data27
  ,in_wt_data28
  ,in_wt_data29
  ,in_wt_data3
  ,in_wt_data30
  ,in_wt_data31
  ,in_wt_data32
  ,in_wt_data33
  ,in_wt_data34
  ,in_wt_data35
  ,in_wt_data36
  ,in_wt_data37
  ,in_wt_data38
  ,in_wt_data39
  ,in_wt_data4
  ,in_wt_data40
  ,in_wt_data41
  ,in_wt_data42
  ,in_wt_data43
  ,in_wt_data44
  ,in_wt_data45
  ,in_wt_data46
  ,in_wt_data47
  ,in_wt_data48
  ,in_wt_data49
  ,in_wt_data5
  ,in_wt_data50
  ,in_wt_data51
  ,in_wt_data52
  ,in_wt_data53
  ,in_wt_data54
  ,in_wt_data55
  ,in_wt_data56
  ,in_wt_data57
  ,in_wt_data58
  ,in_wt_data59
  ,in_wt_data6
  ,in_wt_data60
  ,in_wt_data61
  ,in_wt_data62
  ,in_wt_data63
  ,in_wt_data64
  ,in_wt_data65
  ,in_wt_data66
  ,in_wt_data67
  ,in_wt_data68
  ,in_wt_data69
  ,in_wt_data7
  ,in_wt_data70
  ,in_wt_data71
  ,in_wt_data72
  ,in_wt_data73
  ,in_wt_data74
  ,in_wt_data75
  ,in_wt_data76
  ,in_wt_data77
  ,in_wt_data78
  ,in_wt_data79
  ,in_wt_data8
  ,in_wt_data80
  ,in_wt_data81
  ,in_wt_data82
  ,in_wt_data83
  ,in_wt_data84
  ,in_wt_data85
  ,in_wt_data86
  ,in_wt_data87
  ,in_wt_data88
  ,in_wt_data89
  ,in_wt_data9
  ,in_wt_data90
  ,in_wt_data91
  ,in_wt_data92
  ,in_wt_data93
  ,in_wt_data94
  ,in_wt_data95
  ,in_wt_data96
  ,in_wt_data97
  ,in_wt_data98
  ,in_wt_data99
  ,in_wt_mask
  ,in_wt_pvld
  ,in_wt_sel
  );

input           nvdla_core_clk;
input           nvdla_core_rstn;
input     [7:0] sc2mac_dat_data0;
input     [7:0] sc2mac_dat_data1;
input     [7:0] sc2mac_dat_data10;
input     [7:0] sc2mac_dat_data100;
input     [7:0] sc2mac_dat_data101;
input     [7:0] sc2mac_dat_data102;
input     [7:0] sc2mac_dat_data103;
input     [7:0] sc2mac_dat_data104;
input     [7:0] sc2mac_dat_data105;
input     [7:0] sc2mac_dat_data106;
input     [7:0] sc2mac_dat_data107;
input     [7:0] sc2mac_dat_data108;
input     [7:0] sc2mac_dat_data109;
input     [7:0] sc2mac_dat_data11;
input     [7:0] sc2mac_dat_data110;
input     [7:0] sc2mac_dat_data111;
input     [7:0] sc2mac_dat_data112;
input     [7:0] sc2mac_dat_data113;
input     [7:0] sc2mac_dat_data114;
input     [7:0] sc2mac_dat_data115;
input     [7:0] sc2mac_dat_data116;
input     [7:0] sc2mac_dat_data117;
input     [7:0] sc2mac_dat_data118;
input     [7:0] sc2mac_dat_data119;
input     [7:0] sc2mac_dat_data12;
input     [7:0] sc2mac_dat_data120;
input     [7:0] sc2mac_dat_data121;
input     [7:0] sc2mac_dat_data122;
input     [7:0] sc2mac_dat_data123;
input     [7:0] sc2mac_dat_data124;
input     [7:0] sc2mac_dat_data125;
input     [7:0] sc2mac_dat_data126;
input     [7:0] sc2mac_dat_data127;
input     [7:0] sc2mac_dat_data13;
input     [7:0] sc2mac_dat_data14;
input     [7:0] sc2mac_dat_data15;
input     [7:0] sc2mac_dat_data16;
input     [7:0] sc2mac_dat_data17;
input     [7:0] sc2mac_dat_data18;
input     [7:0] sc2mac_dat_data19;
input     [7:0] sc2mac_dat_data2;
input     [7:0] sc2mac_dat_data20;
input     [7:0] sc2mac_dat_data21;
input     [7:0] sc2mac_dat_data22;
input     [7:0] sc2mac_dat_data23;
input     [7:0] sc2mac_dat_data24;
input     [7:0] sc2mac_dat_data25;
input     [7:0] sc2mac_dat_data26;
input     [7:0] sc2mac_dat_data27;
input     [7:0] sc2mac_dat_data28;
input     [7:0] sc2mac_dat_data29;
input     [7:0] sc2mac_dat_data3;
input     [7:0] sc2mac_dat_data30;
input     [7:0] sc2mac_dat_data31;
input     [7:0] sc2mac_dat_data32;
input     [7:0] sc2mac_dat_data33;
input     [7:0] sc2mac_dat_data34;
input     [7:0] sc2mac_dat_data35;
input     [7:0] sc2mac_dat_data36;
input     [7:0] sc2mac_dat_data37;
input     [7:0] sc2mac_dat_data38;
input     [7:0] sc2mac_dat_data39;
input     [7:0] sc2mac_dat_data4;
input     [7:0] sc2mac_dat_data40;
input     [7:0] sc2mac_dat_data41;
input     [7:0] sc2mac_dat_data42;
input     [7:0] sc2mac_dat_data43;
input     [7:0] sc2mac_dat_data44;
input     [7:0] sc2mac_dat_data45;
input     [7:0] sc2mac_dat_data46;
input     [7:0] sc2mac_dat_data47;
input     [7:0] sc2mac_dat_data48;
input     [7:0] sc2mac_dat_data49;
input     [7:0] sc2mac_dat_data5;
input     [7:0] sc2mac_dat_data50;
input     [7:0] sc2mac_dat_data51;
input     [7:0] sc2mac_dat_data52;
input     [7:0] sc2mac_dat_data53;
input     [7:0] sc2mac_dat_data54;
input     [7:0] sc2mac_dat_data55;
input     [7:0] sc2mac_dat_data56;
input     [7:0] sc2mac_dat_data57;
input     [7:0] sc2mac_dat_data58;
input     [7:0] sc2mac_dat_data59;
input     [7:0] sc2mac_dat_data6;
input     [7:0] sc2mac_dat_data60;
input     [7:0] sc2mac_dat_data61;
input     [7:0] sc2mac_dat_data62;
input     [7:0] sc2mac_dat_data63;
input     [7:0] sc2mac_dat_data64;
input     [7:0] sc2mac_dat_data65;
input     [7:0] sc2mac_dat_data66;
input     [7:0] sc2mac_dat_data67;
input     [7:0] sc2mac_dat_data68;
input     [7:0] sc2mac_dat_data69;
input     [7:0] sc2mac_dat_data7;
input     [7:0] sc2mac_dat_data70;
input     [7:0] sc2mac_dat_data71;
input     [7:0] sc2mac_dat_data72;
input     [7:0] sc2mac_dat_data73;
input     [7:0] sc2mac_dat_data74;
input     [7:0] sc2mac_dat_data75;
input     [7:0] sc2mac_dat_data76;
input     [7:0] sc2mac_dat_data77;
input     [7:0] sc2mac_dat_data78;
input     [7:0] sc2mac_dat_data79;
input     [7:0] sc2mac_dat_data8;
input     [7:0] sc2mac_dat_data80;
input     [7:0] sc2mac_dat_data81;
input     [7:0] sc2mac_dat_data82;
input     [7:0] sc2mac_dat_data83;
input     [7:0] sc2mac_dat_data84;
input     [7:0] sc2mac_dat_data85;
input     [7:0] sc2mac_dat_data86;
input     [7:0] sc2mac_dat_data87;
input     [7:0] sc2mac_dat_data88;
input     [7:0] sc2mac_dat_data89;
input     [7:0] sc2mac_dat_data9;
input     [7:0] sc2mac_dat_data90;
input     [7:0] sc2mac_dat_data91;
input     [7:0] sc2mac_dat_data92;
input     [7:0] sc2mac_dat_data93;
input     [7:0] sc2mac_dat_data94;
input     [7:0] sc2mac_dat_data95;
input     [7:0] sc2mac_dat_data96;
input     [7:0] sc2mac_dat_data97;
input     [7:0] sc2mac_dat_data98;
input     [7:0] sc2mac_dat_data99;
input   [127:0] sc2mac_dat_mask;
input     [8:0] sc2mac_dat_pd;
input           sc2mac_dat_pvld;
input     [7:0] sc2mac_wt_data0;
input     [7:0] sc2mac_wt_data1;
input     [7:0] sc2mac_wt_data10;
input     [7:0] sc2mac_wt_data100;
input     [7:0] sc2mac_wt_data101;
input     [7:0] sc2mac_wt_data102;
input     [7:0] sc2mac_wt_data103;
input     [7:0] sc2mac_wt_data104;
input     [7:0] sc2mac_wt_data105;
input     [7:0] sc2mac_wt_data106;
input     [7:0] sc2mac_wt_data107;
input     [7:0] sc2mac_wt_data108;
input     [7:0] sc2mac_wt_data109;
input     [7:0] sc2mac_wt_data11;
input     [7:0] sc2mac_wt_data110;
input     [7:0] sc2mac_wt_data111;
input     [7:0] sc2mac_wt_data112;
input     [7:0] sc2mac_wt_data113;
input     [7:0] sc2mac_wt_data114;
input     [7:0] sc2mac_wt_data115;
input     [7:0] sc2mac_wt_data116;
input     [7:0] sc2mac_wt_data117;
input     [7:0] sc2mac_wt_data118;
input     [7:0] sc2mac_wt_data119;
input     [7:0] sc2mac_wt_data12;
input     [7:0] sc2mac_wt_data120;
input     [7:0] sc2mac_wt_data121;
input     [7:0] sc2mac_wt_data122;
input     [7:0] sc2mac_wt_data123;
input     [7:0] sc2mac_wt_data124;
input     [7:0] sc2mac_wt_data125;
input     [7:0] sc2mac_wt_data126;
input     [7:0] sc2mac_wt_data127;
input     [7:0] sc2mac_wt_data13;
input     [7:0] sc2mac_wt_data14;
input     [7:0] sc2mac_wt_data15;
input     [7:0] sc2mac_wt_data16;
input     [7:0] sc2mac_wt_data17;
input     [7:0] sc2mac_wt_data18;
input     [7:0] sc2mac_wt_data19;
input     [7:0] sc2mac_wt_data2;
input     [7:0] sc2mac_wt_data20;
input     [7:0] sc2mac_wt_data21;
input     [7:0] sc2mac_wt_data22;
input     [7:0] sc2mac_wt_data23;
input     [7:0] sc2mac_wt_data24;
input     [7:0] sc2mac_wt_data25;
input     [7:0] sc2mac_wt_data26;
input     [7:0] sc2mac_wt_data27;
input     [7:0] sc2mac_wt_data28;
input     [7:0] sc2mac_wt_data29;
input     [7:0] sc2mac_wt_data3;
input     [7:0] sc2mac_wt_data30;
input     [7:0] sc2mac_wt_data31;
input     [7:0] sc2mac_wt_data32;
input     [7:0] sc2mac_wt_data33;
input     [7:0] sc2mac_wt_data34;
input     [7:0] sc2mac_wt_data35;
input     [7:0] sc2mac_wt_data36;
input     [7:0] sc2mac_wt_data37;
input     [7:0] sc2mac_wt_data38;
input     [7:0] sc2mac_wt_data39;
input     [7:0] sc2mac_wt_data4;
input     [7:0] sc2mac_wt_data40;
input     [7:0] sc2mac_wt_data41;
input     [7:0] sc2mac_wt_data42;
input     [7:0] sc2mac_wt_data43;
input     [7:0] sc2mac_wt_data44;
input     [7:0] sc2mac_wt_data45;
input     [7:0] sc2mac_wt_data46;
input     [7:0] sc2mac_wt_data47;
input     [7:0] sc2mac_wt_data48;
input     [7:0] sc2mac_wt_data49;
input     [7:0] sc2mac_wt_data5;
input     [7:0] sc2mac_wt_data50;
input     [7:0] sc2mac_wt_data51;
input     [7:0] sc2mac_wt_data52;
input     [7:0] sc2mac_wt_data53;
input     [7:0] sc2mac_wt_data54;
input     [7:0] sc2mac_wt_data55;
input     [7:0] sc2mac_wt_data56;
input     [7:0] sc2mac_wt_data57;
input     [7:0] sc2mac_wt_data58;
input     [7:0] sc2mac_wt_data59;
input     [7:0] sc2mac_wt_data6;
input     [7:0] sc2mac_wt_data60;
input     [7:0] sc2mac_wt_data61;
input     [7:0] sc2mac_wt_data62;
input     [7:0] sc2mac_wt_data63;
input     [7:0] sc2mac_wt_data64;
input     [7:0] sc2mac_wt_data65;
input     [7:0] sc2mac_wt_data66;
input     [7:0] sc2mac_wt_data67;
input     [7:0] sc2mac_wt_data68;
input     [7:0] sc2mac_wt_data69;
input     [7:0] sc2mac_wt_data7;
input     [7:0] sc2mac_wt_data70;
input     [7:0] sc2mac_wt_data71;
input     [7:0] sc2mac_wt_data72;
input     [7:0] sc2mac_wt_data73;
input     [7:0] sc2mac_wt_data74;
input     [7:0] sc2mac_wt_data75;
input     [7:0] sc2mac_wt_data76;
input     [7:0] sc2mac_wt_data77;
input     [7:0] sc2mac_wt_data78;
input     [7:0] sc2mac_wt_data79;
input     [7:0] sc2mac_wt_data8;
input     [7:0] sc2mac_wt_data80;
input     [7:0] sc2mac_wt_data81;
input     [7:0] sc2mac_wt_data82;
input     [7:0] sc2mac_wt_data83;
input     [7:0] sc2mac_wt_data84;
input     [7:0] sc2mac_wt_data85;
input     [7:0] sc2mac_wt_data86;
input     [7:0] sc2mac_wt_data87;
input     [7:0] sc2mac_wt_data88;
input     [7:0] sc2mac_wt_data89;
input     [7:0] sc2mac_wt_data9;
input     [7:0] sc2mac_wt_data90;
input     [7:0] sc2mac_wt_data91;
input     [7:0] sc2mac_wt_data92;
input     [7:0] sc2mac_wt_data93;
input     [7:0] sc2mac_wt_data94;
input     [7:0] sc2mac_wt_data95;
input     [7:0] sc2mac_wt_data96;
input     [7:0] sc2mac_wt_data97;
input     [7:0] sc2mac_wt_data98;
input     [7:0] sc2mac_wt_data99;
input   [127:0] sc2mac_wt_mask;
input           sc2mac_wt_pvld;
input     [7:0] sc2mac_wt_sel;
output    [7:0] in_dat_data0;
output    [7:0] in_dat_data1;
output    [7:0] in_dat_data10;
output    [7:0] in_dat_data100;
output    [7:0] in_dat_data101;
output    [7:0] in_dat_data102;
output    [7:0] in_dat_data103;
output    [7:0] in_dat_data104;
output    [7:0] in_dat_data105;
output    [7:0] in_dat_data106;
output    [7:0] in_dat_data107;
output    [7:0] in_dat_data108;
output    [7:0] in_dat_data109;
output    [7:0] in_dat_data11;
output    [7:0] in_dat_data110;
output    [7:0] in_dat_data111;
output    [7:0] in_dat_data112;
output    [7:0] in_dat_data113;
output    [7:0] in_dat_data114;
output    [7:0] in_dat_data115;
output    [7:0] in_dat_data116;
output    [7:0] in_dat_data117;
output    [7:0] in_dat_data118;
output    [7:0] in_dat_data119;
output    [7:0] in_dat_data12;
output    [7:0] in_dat_data120;
output    [7:0] in_dat_data121;
output    [7:0] in_dat_data122;
output    [7:0] in_dat_data123;
output    [7:0] in_dat_data124;
output    [7:0] in_dat_data125;
output    [7:0] in_dat_data126;
output    [7:0] in_dat_data127;
output    [7:0] in_dat_data13;
output    [7:0] in_dat_data14;
output    [7:0] in_dat_data15;
output    [7:0] in_dat_data16;
output    [7:0] in_dat_data17;
output    [7:0] in_dat_data18;
output    [7:0] in_dat_data19;
output    [7:0] in_dat_data2;
output    [7:0] in_dat_data20;
output    [7:0] in_dat_data21;
output    [7:0] in_dat_data22;
output    [7:0] in_dat_data23;
output    [7:0] in_dat_data24;
output    [7:0] in_dat_data25;
output    [7:0] in_dat_data26;
output    [7:0] in_dat_data27;
output    [7:0] in_dat_data28;
output    [7:0] in_dat_data29;
output    [7:0] in_dat_data3;
output    [7:0] in_dat_data30;
output    [7:0] in_dat_data31;
output    [7:0] in_dat_data32;
output    [7:0] in_dat_data33;
output    [7:0] in_dat_data34;
output    [7:0] in_dat_data35;
output    [7:0] in_dat_data36;
output    [7:0] in_dat_data37;
output    [7:0] in_dat_data38;
output    [7:0] in_dat_data39;
output    [7:0] in_dat_data4;
output    [7:0] in_dat_data40;
output    [7:0] in_dat_data41;
output    [7:0] in_dat_data42;
output    [7:0] in_dat_data43;
output    [7:0] in_dat_data44;
output    [7:0] in_dat_data45;
output    [7:0] in_dat_data46;
output    [7:0] in_dat_data47;
output    [7:0] in_dat_data48;
output    [7:0] in_dat_data49;
output    [7:0] in_dat_data5;
output    [7:0] in_dat_data50;
output    [7:0] in_dat_data51;
output    [7:0] in_dat_data52;
output    [7:0] in_dat_data53;
output    [7:0] in_dat_data54;
output    [7:0] in_dat_data55;
output    [7:0] in_dat_data56;
output    [7:0] in_dat_data57;
output    [7:0] in_dat_data58;
output    [7:0] in_dat_data59;
output    [7:0] in_dat_data6;
output    [7:0] in_dat_data60;
output    [7:0] in_dat_data61;
output    [7:0] in_dat_data62;
output    [7:0] in_dat_data63;
output    [7:0] in_dat_data64;
output    [7:0] in_dat_data65;
output    [7:0] in_dat_data66;
output    [7:0] in_dat_data67;
output    [7:0] in_dat_data68;
output    [7:0] in_dat_data69;
output    [7:0] in_dat_data7;
output    [7:0] in_dat_data70;
output    [7:0] in_dat_data71;
output    [7:0] in_dat_data72;
output    [7:0] in_dat_data73;
output    [7:0] in_dat_data74;
output    [7:0] in_dat_data75;
output    [7:0] in_dat_data76;
output    [7:0] in_dat_data77;
output    [7:0] in_dat_data78;
output    [7:0] in_dat_data79;
output    [7:0] in_dat_data8;
output    [7:0] in_dat_data80;
output    [7:0] in_dat_data81;
output    [7:0] in_dat_data82;
output    [7:0] in_dat_data83;
output    [7:0] in_dat_data84;
output    [7:0] in_dat_data85;
output    [7:0] in_dat_data86;
output    [7:0] in_dat_data87;
output    [7:0] in_dat_data88;
output    [7:0] in_dat_data89;
output    [7:0] in_dat_data9;
output    [7:0] in_dat_data90;
output    [7:0] in_dat_data91;
output    [7:0] in_dat_data92;
output    [7:0] in_dat_data93;
output    [7:0] in_dat_data94;
output    [7:0] in_dat_data95;
output    [7:0] in_dat_data96;
output    [7:0] in_dat_data97;
output    [7:0] in_dat_data98;
output    [7:0] in_dat_data99;
output  [127:0] in_dat_mask;
output    [8:0] in_dat_pd;
output          in_dat_pvld;
output          in_dat_stripe_end;
output          in_dat_stripe_st;
output    [7:0] in_wt_data0;
output    [7:0] in_wt_data1;
output    [7:0] in_wt_data10;
output    [7:0] in_wt_data100;
output    [7:0] in_wt_data101;
output    [7:0] in_wt_data102;
output    [7:0] in_wt_data103;
output    [7:0] in_wt_data104;
output    [7:0] in_wt_data105;
output    [7:0] in_wt_data106;
output    [7:0] in_wt_data107;
output    [7:0] in_wt_data108;
output    [7:0] in_wt_data109;
output    [7:0] in_wt_data11;
output    [7:0] in_wt_data110;
output    [7:0] in_wt_data111;
output    [7:0] in_wt_data112;
output    [7:0] in_wt_data113;
output    [7:0] in_wt_data114;
output    [7:0] in_wt_data115;
output    [7:0] in_wt_data116;
output    [7:0] in_wt_data117;
output    [7:0] in_wt_data118;
output    [7:0] in_wt_data119;
output    [7:0] in_wt_data12;
output    [7:0] in_wt_data120;
output    [7:0] in_wt_data121;
output    [7:0] in_wt_data122;
output    [7:0] in_wt_data123;
output    [7:0] in_wt_data124;
output    [7:0] in_wt_data125;
output    [7:0] in_wt_data126;
output    [7:0] in_wt_data127;
output    [7:0] in_wt_data13;
output    [7:0] in_wt_data14;
output    [7:0] in_wt_data15;
output    [7:0] in_wt_data16;
output    [7:0] in_wt_data17;
output    [7:0] in_wt_data18;
output    [7:0] in_wt_data19;
output    [7:0] in_wt_data2;
output    [7:0] in_wt_data20;
output    [7:0] in_wt_data21;
output    [7:0] in_wt_data22;
output    [7:0] in_wt_data23;
output    [7:0] in_wt_data24;
output    [7:0] in_wt_data25;
output    [7:0] in_wt_data26;
output    [7:0] in_wt_data27;
output    [7:0] in_wt_data28;
output    [7:0] in_wt_data29;
output    [7:0] in_wt_data3;
output    [7:0] in_wt_data30;
output    [7:0] in_wt_data31;
output    [7:0] in_wt_data32;
output    [7:0] in_wt_data33;
output    [7:0] in_wt_data34;
output    [7:0] in_wt_data35;
output    [7:0] in_wt_data36;
output    [7:0] in_wt_data37;
output    [7:0] in_wt_data38;
output    [7:0] in_wt_data39;
output    [7:0] in_wt_data4;
output    [7:0] in_wt_data40;
output    [7:0] in_wt_data41;
output    [7:0] in_wt_data42;
output    [7:0] in_wt_data43;
output    [7:0] in_wt_data44;
output    [7:0] in_wt_data45;
output    [7:0] in_wt_data46;
output    [7:0] in_wt_data47;
output    [7:0] in_wt_data48;
output    [7:0] in_wt_data49;
output    [7:0] in_wt_data5;
output    [7:0] in_wt_data50;
output    [7:0] in_wt_data51;
output    [7:0] in_wt_data52;
output    [7:0] in_wt_data53;
output    [7:0] in_wt_data54;
output    [7:0] in_wt_data55;
output    [7:0] in_wt_data56;
output    [7:0] in_wt_data57;
output    [7:0] in_wt_data58;
output    [7:0] in_wt_data59;
output    [7:0] in_wt_data6;
output    [7:0] in_wt_data60;
output    [7:0] in_wt_data61;
output    [7:0] in_wt_data62;
output    [7:0] in_wt_data63;
output    [7:0] in_wt_data64;
output    [7:0] in_wt_data65;
output    [7:0] in_wt_data66;
output    [7:0] in_wt_data67;
output    [7:0] in_wt_data68;
output    [7:0] in_wt_data69;
output    [7:0] in_wt_data7;
output    [7:0] in_wt_data70;
output    [7:0] in_wt_data71;
output    [7:0] in_wt_data72;
output    [7:0] in_wt_data73;
output    [7:0] in_wt_data74;
output    [7:0] in_wt_data75;
output    [7:0] in_wt_data76;
output    [7:0] in_wt_data77;
output    [7:0] in_wt_data78;
output    [7:0] in_wt_data79;
output    [7:0] in_wt_data8;
output    [7:0] in_wt_data80;
output    [7:0] in_wt_data81;
output    [7:0] in_wt_data82;
output    [7:0] in_wt_data83;
output    [7:0] in_wt_data84;
output    [7:0] in_wt_data85;
output    [7:0] in_wt_data86;
output    [7:0] in_wt_data87;
output    [7:0] in_wt_data88;
output    [7:0] in_wt_data89;
output    [7:0] in_wt_data9;
output    [7:0] in_wt_data90;
output    [7:0] in_wt_data91;
output    [7:0] in_wt_data92;
output    [7:0] in_wt_data93;
output    [7:0] in_wt_data94;
output    [7:0] in_wt_data95;
output    [7:0] in_wt_data96;
output    [7:0] in_wt_data97;
output    [7:0] in_wt_data98;
output    [7:0] in_wt_data99;
output  [127:0] in_wt_mask;
output          in_wt_pvld;
output    [7:0] in_wt_sel;
reg    [1023:0] in_dat_data;
reg       [7:0] in_dat_data0;
reg       [7:0] in_dat_data1;
reg       [7:0] in_dat_data10;
reg       [7:0] in_dat_data100;
reg       [7:0] in_dat_data101;
reg       [7:0] in_dat_data102;
reg       [7:0] in_dat_data103;
reg       [7:0] in_dat_data104;
reg       [7:0] in_dat_data105;
reg       [7:0] in_dat_data106;
reg       [7:0] in_dat_data107;
reg       [7:0] in_dat_data108;
reg       [7:0] in_dat_data109;
reg       [7:0] in_dat_data11;
reg       [7:0] in_dat_data110;
reg       [7:0] in_dat_data111;
reg       [7:0] in_dat_data112;
reg       [7:0] in_dat_data113;
reg       [7:0] in_dat_data114;
reg       [7:0] in_dat_data115;
reg       [7:0] in_dat_data116;
reg       [7:0] in_dat_data117;
reg       [7:0] in_dat_data118;
reg       [7:0] in_dat_data119;
reg       [7:0] in_dat_data12;
reg       [7:0] in_dat_data120;
reg       [7:0] in_dat_data121;
reg       [7:0] in_dat_data122;
reg       [7:0] in_dat_data123;
reg       [7:0] in_dat_data124;
reg       [7:0] in_dat_data125;
reg       [7:0] in_dat_data126;
reg       [7:0] in_dat_data127;
reg       [7:0] in_dat_data13;
reg       [7:0] in_dat_data14;
reg       [7:0] in_dat_data15;
reg       [7:0] in_dat_data16;
reg       [7:0] in_dat_data17;
reg       [7:0] in_dat_data18;
reg       [7:0] in_dat_data19;
reg       [7:0] in_dat_data2;
reg       [7:0] in_dat_data20;
reg       [7:0] in_dat_data21;
reg       [7:0] in_dat_data22;
reg       [7:0] in_dat_data23;
reg       [7:0] in_dat_data24;
reg       [7:0] in_dat_data25;
reg       [7:0] in_dat_data26;
reg       [7:0] in_dat_data27;
reg       [7:0] in_dat_data28;
reg       [7:0] in_dat_data29;
reg       [7:0] in_dat_data3;
reg       [7:0] in_dat_data30;
reg       [7:0] in_dat_data31;
reg       [7:0] in_dat_data32;
reg       [7:0] in_dat_data33;
reg       [7:0] in_dat_data34;
reg       [7:0] in_dat_data35;
reg       [7:0] in_dat_data36;
reg       [7:0] in_dat_data37;
reg       [7:0] in_dat_data38;
reg       [7:0] in_dat_data39;
reg       [7:0] in_dat_data4;
reg       [7:0] in_dat_data40;
reg       [7:0] in_dat_data41;
reg       [7:0] in_dat_data42;
reg       [7:0] in_dat_data43;
reg       [7:0] in_dat_data44;
reg       [7:0] in_dat_data45;
reg       [7:0] in_dat_data46;
reg       [7:0] in_dat_data47;
reg       [7:0] in_dat_data48;
reg       [7:0] in_dat_data49;
reg       [7:0] in_dat_data5;
reg       [7:0] in_dat_data50;
reg       [7:0] in_dat_data51;
reg       [7:0] in_dat_data52;
reg       [7:0] in_dat_data53;
reg       [7:0] in_dat_data54;
reg       [7:0] in_dat_data55;
reg       [7:0] in_dat_data56;
reg       [7:0] in_dat_data57;
reg       [7:0] in_dat_data58;
reg       [7:0] in_dat_data59;
reg       [7:0] in_dat_data6;
reg       [7:0] in_dat_data60;
reg       [7:0] in_dat_data61;
reg       [7:0] in_dat_data62;
reg       [7:0] in_dat_data63;
reg       [7:0] in_dat_data64;
reg       [7:0] in_dat_data65;
reg       [7:0] in_dat_data66;
reg       [7:0] in_dat_data67;
reg       [7:0] in_dat_data68;
reg       [7:0] in_dat_data69;
reg       [7:0] in_dat_data7;
reg       [7:0] in_dat_data70;
reg       [7:0] in_dat_data71;
reg       [7:0] in_dat_data72;
reg       [7:0] in_dat_data73;
reg       [7:0] in_dat_data74;
reg       [7:0] in_dat_data75;
reg       [7:0] in_dat_data76;
reg       [7:0] in_dat_data77;
reg       [7:0] in_dat_data78;
reg       [7:0] in_dat_data79;
reg       [7:0] in_dat_data8;
reg       [7:0] in_dat_data80;
reg       [7:0] in_dat_data81;
reg       [7:0] in_dat_data82;
reg       [7:0] in_dat_data83;
reg       [7:0] in_dat_data84;
reg       [7:0] in_dat_data85;
reg       [7:0] in_dat_data86;
reg       [7:0] in_dat_data87;
reg       [7:0] in_dat_data88;
reg       [7:0] in_dat_data89;
reg       [7:0] in_dat_data9;
reg       [7:0] in_dat_data90;
reg       [7:0] in_dat_data91;
reg       [7:0] in_dat_data92;
reg       [7:0] in_dat_data93;
reg       [7:0] in_dat_data94;
reg       [7:0] in_dat_data95;
reg       [7:0] in_dat_data96;
reg       [7:0] in_dat_data97;
reg       [7:0] in_dat_data98;
reg       [7:0] in_dat_data99;
reg     [127:0] in_dat_mask;
reg       [8:0] in_dat_pd;
reg             in_dat_pvld;
reg             in_dat_stripe_end;
reg             in_dat_stripe_st;
reg    [1023:0] in_rt_dat_data_d0;
reg    [1023:0] in_rt_dat_data_d1;
reg     [127:0] in_rt_dat_mask_d0;
reg     [127:0] in_rt_dat_mask_d1;
reg       [8:0] in_rt_dat_pd_d0;
reg       [8:0] in_rt_dat_pd_d1;
reg             in_rt_dat_pvld_d0;
reg             in_rt_dat_pvld_d1;
reg    [1023:0] in_rt_wt_data_d0;
reg    [1023:0] in_rt_wt_data_d1;
reg     [127:0] in_rt_wt_mask_d0;
reg     [127:0] in_rt_wt_mask_d1;
reg             in_rt_wt_pvld_d0;
reg             in_rt_wt_pvld_d1;
reg       [7:0] in_rt_wt_sel_d0;
reg       [7:0] in_rt_wt_sel_d1;
reg    [1023:0] in_wt_data;
reg       [7:0] in_wt_data0;
reg       [7:0] in_wt_data1;
reg       [7:0] in_wt_data10;
reg       [7:0] in_wt_data100;
reg       [7:0] in_wt_data101;
reg       [7:0] in_wt_data102;
reg       [7:0] in_wt_data103;
reg       [7:0] in_wt_data104;
reg       [7:0] in_wt_data105;
reg       [7:0] in_wt_data106;
reg       [7:0] in_wt_data107;
reg       [7:0] in_wt_data108;
reg       [7:0] in_wt_data109;
reg       [7:0] in_wt_data11;
reg       [7:0] in_wt_data110;
reg       [7:0] in_wt_data111;
reg       [7:0] in_wt_data112;
reg       [7:0] in_wt_data113;
reg       [7:0] in_wt_data114;
reg       [7:0] in_wt_data115;
reg       [7:0] in_wt_data116;
reg       [7:0] in_wt_data117;
reg       [7:0] in_wt_data118;
reg       [7:0] in_wt_data119;
reg       [7:0] in_wt_data12;
reg       [7:0] in_wt_data120;
reg       [7:0] in_wt_data121;
reg       [7:0] in_wt_data122;
reg       [7:0] in_wt_data123;
reg       [7:0] in_wt_data124;
reg       [7:0] in_wt_data125;
reg       [7:0] in_wt_data126;
reg       [7:0] in_wt_data127;
reg       [7:0] in_wt_data13;
reg       [7:0] in_wt_data14;
reg       [7:0] in_wt_data15;
reg       [7:0] in_wt_data16;
reg       [7:0] in_wt_data17;
reg       [7:0] in_wt_data18;
reg       [7:0] in_wt_data19;
reg       [7:0] in_wt_data2;
reg       [7:0] in_wt_data20;
reg       [7:0] in_wt_data21;
reg       [7:0] in_wt_data22;
reg       [7:0] in_wt_data23;
reg       [7:0] in_wt_data24;
reg       [7:0] in_wt_data25;
reg       [7:0] in_wt_data26;
reg       [7:0] in_wt_data27;
reg       [7:0] in_wt_data28;
reg       [7:0] in_wt_data29;
reg       [7:0] in_wt_data3;
reg       [7:0] in_wt_data30;
reg       [7:0] in_wt_data31;
reg       [7:0] in_wt_data32;
reg       [7:0] in_wt_data33;
reg       [7:0] in_wt_data34;
reg       [7:0] in_wt_data35;
reg       [7:0] in_wt_data36;
reg       [7:0] in_wt_data37;
reg       [7:0] in_wt_data38;
reg       [7:0] in_wt_data39;
reg       [7:0] in_wt_data4;
reg       [7:0] in_wt_data40;
reg       [7:0] in_wt_data41;
reg       [7:0] in_wt_data42;
reg       [7:0] in_wt_data43;
reg       [7:0] in_wt_data44;
reg       [7:0] in_wt_data45;
reg       [7:0] in_wt_data46;
reg       [7:0] in_wt_data47;
reg       [7:0] in_wt_data48;
reg       [7:0] in_wt_data49;
reg       [7:0] in_wt_data5;
reg       [7:0] in_wt_data50;
reg       [7:0] in_wt_data51;
reg       [7:0] in_wt_data52;
reg       [7:0] in_wt_data53;
reg       [7:0] in_wt_data54;
reg       [7:0] in_wt_data55;
reg       [7:0] in_wt_data56;
reg       [7:0] in_wt_data57;
reg       [7:0] in_wt_data58;
reg       [7:0] in_wt_data59;
reg       [7:0] in_wt_data6;
reg       [7:0] in_wt_data60;
reg       [7:0] in_wt_data61;
reg       [7:0] in_wt_data62;
reg       [7:0] in_wt_data63;
reg       [7:0] in_wt_data64;
reg       [7:0] in_wt_data65;
reg       [7:0] in_wt_data66;
reg       [7:0] in_wt_data67;
reg       [7:0] in_wt_data68;
reg       [7:0] in_wt_data69;
reg       [7:0] in_wt_data7;
reg       [7:0] in_wt_data70;
reg       [7:0] in_wt_data71;
reg       [7:0] in_wt_data72;
reg       [7:0] in_wt_data73;
reg       [7:0] in_wt_data74;
reg       [7:0] in_wt_data75;
reg       [7:0] in_wt_data76;
reg       [7:0] in_wt_data77;
reg       [7:0] in_wt_data78;
reg       [7:0] in_wt_data79;
reg       [7:0] in_wt_data8;
reg       [7:0] in_wt_data80;
reg       [7:0] in_wt_data81;
reg       [7:0] in_wt_data82;
reg       [7:0] in_wt_data83;
reg       [7:0] in_wt_data84;
reg       [7:0] in_wt_data85;
reg       [7:0] in_wt_data86;
reg       [7:0] in_wt_data87;
reg       [7:0] in_wt_data88;
reg       [7:0] in_wt_data89;
reg       [7:0] in_wt_data9;
reg       [7:0] in_wt_data90;
reg       [7:0] in_wt_data91;
reg       [7:0] in_wt_data92;
reg       [7:0] in_wt_data93;
reg       [7:0] in_wt_data94;
reg       [7:0] in_wt_data95;
reg       [7:0] in_wt_data96;
reg       [7:0] in_wt_data97;
reg       [7:0] in_wt_data98;
reg       [7:0] in_wt_data99;
reg     [127:0] in_wt_mask;
reg             in_wt_pvld;
reg       [7:0] in_wt_sel;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    

//==========================================================
// Renameing input signals
//==========================================================

always @(
  sc2mac_dat_pvld
  or sc2mac_dat_mask
  or sc2mac_dat_pd
  or sc2mac_dat_data127
  or sc2mac_dat_data126
  or sc2mac_dat_data125
  or sc2mac_dat_data124
  or sc2mac_dat_data123
  or sc2mac_dat_data122
  or sc2mac_dat_data121
  or sc2mac_dat_data120
  or sc2mac_dat_data119
  or sc2mac_dat_data118
  or sc2mac_dat_data117
  or sc2mac_dat_data116
  or sc2mac_dat_data115
  or sc2mac_dat_data114
  or sc2mac_dat_data113
  or sc2mac_dat_data112
  or sc2mac_dat_data111
  or sc2mac_dat_data110
  or sc2mac_dat_data109
  or sc2mac_dat_data108
  or sc2mac_dat_data107
  or sc2mac_dat_data106
  or sc2mac_dat_data105
  or sc2mac_dat_data104
  or sc2mac_dat_data103
  or sc2mac_dat_data102
  or sc2mac_dat_data101
  or sc2mac_dat_data100
  or sc2mac_dat_data99
  or sc2mac_dat_data98
  or sc2mac_dat_data97
  or sc2mac_dat_data96
  or sc2mac_dat_data95
  or sc2mac_dat_data94
  or sc2mac_dat_data93
  or sc2mac_dat_data92
  or sc2mac_dat_data91
  or sc2mac_dat_data90
  or sc2mac_dat_data89
  or sc2mac_dat_data88
  or sc2mac_dat_data87
  or sc2mac_dat_data86
  or sc2mac_dat_data85
  or sc2mac_dat_data84
  or sc2mac_dat_data83
  or sc2mac_dat_data82
  or sc2mac_dat_data81
  or sc2mac_dat_data80
  or sc2mac_dat_data79
  or sc2mac_dat_data78
  or sc2mac_dat_data77
  or sc2mac_dat_data76
  or sc2mac_dat_data75
  or sc2mac_dat_data74
  or sc2mac_dat_data73
  or sc2mac_dat_data72
  or sc2mac_dat_data71
  or sc2mac_dat_data70
  or sc2mac_dat_data69
  or sc2mac_dat_data68
  or sc2mac_dat_data67
  or sc2mac_dat_data66
  or sc2mac_dat_data65
  or sc2mac_dat_data64
  or sc2mac_dat_data63
  or sc2mac_dat_data62
  or sc2mac_dat_data61
  or sc2mac_dat_data60
  or sc2mac_dat_data59
  or sc2mac_dat_data58
  or sc2mac_dat_data57
  or sc2mac_dat_data56
  or sc2mac_dat_data55
  or sc2mac_dat_data54
  or sc2mac_dat_data53
  or sc2mac_dat_data52
  or sc2mac_dat_data51
  or sc2mac_dat_data50
  or sc2mac_dat_data49
  or sc2mac_dat_data48
  or sc2mac_dat_data47
  or sc2mac_dat_data46
  or sc2mac_dat_data45
  or sc2mac_dat_data44
  or sc2mac_dat_data43
  or sc2mac_dat_data42
  or sc2mac_dat_data41
  or sc2mac_dat_data40
  or sc2mac_dat_data39
  or sc2mac_dat_data38
  or sc2mac_dat_data37
  or sc2mac_dat_data36
  or sc2mac_dat_data35
  or sc2mac_dat_data34
  or sc2mac_dat_data33
  or sc2mac_dat_data32
  or sc2mac_dat_data31
  or sc2mac_dat_data30
  or sc2mac_dat_data29
  or sc2mac_dat_data28
  or sc2mac_dat_data27
  or sc2mac_dat_data26
  or sc2mac_dat_data25
  or sc2mac_dat_data24
  or sc2mac_dat_data23
  or sc2mac_dat_data22
  or sc2mac_dat_data21
  or sc2mac_dat_data20
  or sc2mac_dat_data19
  or sc2mac_dat_data18
  or sc2mac_dat_data17
  or sc2mac_dat_data16
  or sc2mac_dat_data15
  or sc2mac_dat_data14
  or sc2mac_dat_data13
  or sc2mac_dat_data12
  or sc2mac_dat_data11
  or sc2mac_dat_data10
  or sc2mac_dat_data9
  or sc2mac_dat_data8
  or sc2mac_dat_data7
  or sc2mac_dat_data6
  or sc2mac_dat_data5
  or sc2mac_dat_data4
  or sc2mac_dat_data3
  or sc2mac_dat_data2
  or sc2mac_dat_data1
  or sc2mac_dat_data0
  ) begin
    in_rt_dat_pvld_d0 = sc2mac_dat_pvld;
    in_rt_dat_mask_d0 = sc2mac_dat_mask;
    in_rt_dat_pd_d0   = sc2mac_dat_pd;
    in_rt_dat_data_d0 = {sc2mac_dat_data127, sc2mac_dat_data126, sc2mac_dat_data125, sc2mac_dat_data124, sc2mac_dat_data123, sc2mac_dat_data122, sc2mac_dat_data121, sc2mac_dat_data120, sc2mac_dat_data119, sc2mac_dat_data118, sc2mac_dat_data117, sc2mac_dat_data116, sc2mac_dat_data115, sc2mac_dat_data114, sc2mac_dat_data113, sc2mac_dat_data112, sc2mac_dat_data111, sc2mac_dat_data110, sc2mac_dat_data109, sc2mac_dat_data108, sc2mac_dat_data107, sc2mac_dat_data106, sc2mac_dat_data105, sc2mac_dat_data104, sc2mac_dat_data103, sc2mac_dat_data102, sc2mac_dat_data101, sc2mac_dat_data100, sc2mac_dat_data99, sc2mac_dat_data98, sc2mac_dat_data97, sc2mac_dat_data96, sc2mac_dat_data95, sc2mac_dat_data94, sc2mac_dat_data93, sc2mac_dat_data92, sc2mac_dat_data91, sc2mac_dat_data90, sc2mac_dat_data89, sc2mac_dat_data88, sc2mac_dat_data87, sc2mac_dat_data86, sc2mac_dat_data85, sc2mac_dat_data84, sc2mac_dat_data83, sc2mac_dat_data82, sc2mac_dat_data81, sc2mac_dat_data80, sc2mac_dat_data79, sc2mac_dat_data78, sc2mac_dat_data77, sc2mac_dat_data76, sc2mac_dat_data75, sc2mac_dat_data74, sc2mac_dat_data73, sc2mac_dat_data72, sc2mac_dat_data71, sc2mac_dat_data70, sc2mac_dat_data69, sc2mac_dat_data68, sc2mac_dat_data67, sc2mac_dat_data66, sc2mac_dat_data65, sc2mac_dat_data64, sc2mac_dat_data63, sc2mac_dat_data62, sc2mac_dat_data61, sc2mac_dat_data60, sc2mac_dat_data59, sc2mac_dat_data58, sc2mac_dat_data57, sc2mac_dat_data56, sc2mac_dat_data55, sc2mac_dat_data54, sc2mac_dat_data53, sc2mac_dat_data52, sc2mac_dat_data51, sc2mac_dat_data50, sc2mac_dat_data49, sc2mac_dat_data48, sc2mac_dat_data47, sc2mac_dat_data46, sc2mac_dat_data45, sc2mac_dat_data44, sc2mac_dat_data43, sc2mac_dat_data42, sc2mac_dat_data41, sc2mac_dat_data40, sc2mac_dat_data39, sc2mac_dat_data38, sc2mac_dat_data37, sc2mac_dat_data36, sc2mac_dat_data35, sc2mac_dat_data34, sc2mac_dat_data33, sc2mac_dat_data32, sc2mac_dat_data31, sc2mac_dat_data30, sc2mac_dat_data29, sc2mac_dat_data28, sc2mac_dat_data27, sc2mac_dat_data26, sc2mac_dat_data25, sc2mac_dat_data24, sc2mac_dat_data23, sc2mac_dat_data22, sc2mac_dat_data21, sc2mac_dat_data20, sc2mac_dat_data19, sc2mac_dat_data18, sc2mac_dat_data17, sc2mac_dat_data16, sc2mac_dat_data15, sc2mac_dat_data14, sc2mac_dat_data13, sc2mac_dat_data12, sc2mac_dat_data11, sc2mac_dat_data10, sc2mac_dat_data9, sc2mac_dat_data8, sc2mac_dat_data7, sc2mac_dat_data6, sc2mac_dat_data5, sc2mac_dat_data4, sc2mac_dat_data3, sc2mac_dat_data2, sc2mac_dat_data1, sc2mac_dat_data0};
end

always @(
  sc2mac_wt_pvld
  or sc2mac_wt_mask
  or sc2mac_wt_sel
  or sc2mac_wt_data127
  or sc2mac_wt_data126
  or sc2mac_wt_data125
  or sc2mac_wt_data124
  or sc2mac_wt_data123
  or sc2mac_wt_data122
  or sc2mac_wt_data121
  or sc2mac_wt_data120
  or sc2mac_wt_data119
  or sc2mac_wt_data118
  or sc2mac_wt_data117
  or sc2mac_wt_data116
  or sc2mac_wt_data115
  or sc2mac_wt_data114
  or sc2mac_wt_data113
  or sc2mac_wt_data112
  or sc2mac_wt_data111
  or sc2mac_wt_data110
  or sc2mac_wt_data109
  or sc2mac_wt_data108
  or sc2mac_wt_data107
  or sc2mac_wt_data106
  or sc2mac_wt_data105
  or sc2mac_wt_data104
  or sc2mac_wt_data103
  or sc2mac_wt_data102
  or sc2mac_wt_data101
  or sc2mac_wt_data100
  or sc2mac_wt_data99
  or sc2mac_wt_data98
  or sc2mac_wt_data97
  or sc2mac_wt_data96
  or sc2mac_wt_data95
  or sc2mac_wt_data94
  or sc2mac_wt_data93
  or sc2mac_wt_data92
  or sc2mac_wt_data91
  or sc2mac_wt_data90
  or sc2mac_wt_data89
  or sc2mac_wt_data88
  or sc2mac_wt_data87
  or sc2mac_wt_data86
  or sc2mac_wt_data85
  or sc2mac_wt_data84
  or sc2mac_wt_data83
  or sc2mac_wt_data82
  or sc2mac_wt_data81
  or sc2mac_wt_data80
  or sc2mac_wt_data79
  or sc2mac_wt_data78
  or sc2mac_wt_data77
  or sc2mac_wt_data76
  or sc2mac_wt_data75
  or sc2mac_wt_data74
  or sc2mac_wt_data73
  or sc2mac_wt_data72
  or sc2mac_wt_data71
  or sc2mac_wt_data70
  or sc2mac_wt_data69
  or sc2mac_wt_data68
  or sc2mac_wt_data67
  or sc2mac_wt_data66
  or sc2mac_wt_data65
  or sc2mac_wt_data64
  or sc2mac_wt_data63
  or sc2mac_wt_data62
  or sc2mac_wt_data61
  or sc2mac_wt_data60
  or sc2mac_wt_data59
  or sc2mac_wt_data58
  or sc2mac_wt_data57
  or sc2mac_wt_data56
  or sc2mac_wt_data55
  or sc2mac_wt_data54
  or sc2mac_wt_data53
  or sc2mac_wt_data52
  or sc2mac_wt_data51
  or sc2mac_wt_data50
  or sc2mac_wt_data49
  or sc2mac_wt_data48
  or sc2mac_wt_data47
  or sc2mac_wt_data46
  or sc2mac_wt_data45
  or sc2mac_wt_data44
  or sc2mac_wt_data43
  or sc2mac_wt_data42
  or sc2mac_wt_data41
  or sc2mac_wt_data40
  or sc2mac_wt_data39
  or sc2mac_wt_data38
  or sc2mac_wt_data37
  or sc2mac_wt_data36
  or sc2mac_wt_data35
  or sc2mac_wt_data34
  or sc2mac_wt_data33
  or sc2mac_wt_data32
  or sc2mac_wt_data31
  or sc2mac_wt_data30
  or sc2mac_wt_data29
  or sc2mac_wt_data28
  or sc2mac_wt_data27
  or sc2mac_wt_data26
  or sc2mac_wt_data25
  or sc2mac_wt_data24
  or sc2mac_wt_data23
  or sc2mac_wt_data22
  or sc2mac_wt_data21
  or sc2mac_wt_data20
  or sc2mac_wt_data19
  or sc2mac_wt_data18
  or sc2mac_wt_data17
  or sc2mac_wt_data16
  or sc2mac_wt_data15
  or sc2mac_wt_data14
  or sc2mac_wt_data13
  or sc2mac_wt_data12
  or sc2mac_wt_data11
  or sc2mac_wt_data10
  or sc2mac_wt_data9
  or sc2mac_wt_data8
  or sc2mac_wt_data7
  or sc2mac_wt_data6
  or sc2mac_wt_data5
  or sc2mac_wt_data4
  or sc2mac_wt_data3
  or sc2mac_wt_data2
  or sc2mac_wt_data1
  or sc2mac_wt_data0
  ) begin
    in_rt_wt_pvld_d0 = sc2mac_wt_pvld;
    in_rt_wt_mask_d0 = sc2mac_wt_mask;
    in_rt_wt_sel_d0  = sc2mac_wt_sel;
    in_rt_wt_data_d0 = {sc2mac_wt_data127, sc2mac_wt_data126, sc2mac_wt_data125, sc2mac_wt_data124, sc2mac_wt_data123, sc2mac_wt_data122, sc2mac_wt_data121, sc2mac_wt_data120, sc2mac_wt_data119, sc2mac_wt_data118, sc2mac_wt_data117, sc2mac_wt_data116, sc2mac_wt_data115, sc2mac_wt_data114, sc2mac_wt_data113, sc2mac_wt_data112, sc2mac_wt_data111, sc2mac_wt_data110, sc2mac_wt_data109, sc2mac_wt_data108, sc2mac_wt_data107, sc2mac_wt_data106, sc2mac_wt_data105, sc2mac_wt_data104, sc2mac_wt_data103, sc2mac_wt_data102, sc2mac_wt_data101, sc2mac_wt_data100, sc2mac_wt_data99, sc2mac_wt_data98, sc2mac_wt_data97, sc2mac_wt_data96, sc2mac_wt_data95, sc2mac_wt_data94, sc2mac_wt_data93, sc2mac_wt_data92, sc2mac_wt_data91, sc2mac_wt_data90, sc2mac_wt_data89, sc2mac_wt_data88, sc2mac_wt_data87, sc2mac_wt_data86, sc2mac_wt_data85, sc2mac_wt_data84, sc2mac_wt_data83, sc2mac_wt_data82, sc2mac_wt_data81, sc2mac_wt_data80, sc2mac_wt_data79, sc2mac_wt_data78, sc2mac_wt_data77, sc2mac_wt_data76, sc2mac_wt_data75, sc2mac_wt_data74, sc2mac_wt_data73, sc2mac_wt_data72, sc2mac_wt_data71, sc2mac_wt_data70, sc2mac_wt_data69, sc2mac_wt_data68, sc2mac_wt_data67, sc2mac_wt_data66, sc2mac_wt_data65, sc2mac_wt_data64, sc2mac_wt_data63, sc2mac_wt_data62, sc2mac_wt_data61, sc2mac_wt_data60, sc2mac_wt_data59, sc2mac_wt_data58, sc2mac_wt_data57, sc2mac_wt_data56, sc2mac_wt_data55, sc2mac_wt_data54, sc2mac_wt_data53, sc2mac_wt_data52, sc2mac_wt_data51, sc2mac_wt_data50, sc2mac_wt_data49, sc2mac_wt_data48, sc2mac_wt_data47, sc2mac_wt_data46, sc2mac_wt_data45, sc2mac_wt_data44, sc2mac_wt_data43, sc2mac_wt_data42, sc2mac_wt_data41, sc2mac_wt_data40, sc2mac_wt_data39, sc2mac_wt_data38, sc2mac_wt_data37, sc2mac_wt_data36, sc2mac_wt_data35, sc2mac_wt_data34, sc2mac_wt_data33, sc2mac_wt_data32, sc2mac_wt_data31, sc2mac_wt_data30, sc2mac_wt_data29, sc2mac_wt_data28, sc2mac_wt_data27, sc2mac_wt_data26, sc2mac_wt_data25, sc2mac_wt_data24, sc2mac_wt_data23, sc2mac_wt_data22, sc2mac_wt_data21, sc2mac_wt_data20, sc2mac_wt_data19, sc2mac_wt_data18, sc2mac_wt_data17, sc2mac_wt_data16, sc2mac_wt_data15, sc2mac_wt_data14, sc2mac_wt_data13, sc2mac_wt_data12, sc2mac_wt_data11, sc2mac_wt_data10, sc2mac_wt_data9, sc2mac_wt_data8, sc2mac_wt_data7, sc2mac_wt_data6, sc2mac_wt_data5, sc2mac_wt_data4, sc2mac_wt_data3, sc2mac_wt_data2, sc2mac_wt_data1, sc2mac_wt_data0};
end

//==========================================================
// Retiming flops
//==========================================================

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    in_rt_dat_pvld_d1 <= 1'b0;
  end else begin
  in_rt_dat_pvld_d1 <= in_rt_dat_pvld_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    in_rt_dat_mask_d1 <= {128{1'b0}};
  end else begin
  if ((in_rt_dat_pvld_d0 | in_rt_dat_pvld_d1) == 1'b1) begin
    in_rt_dat_mask_d1 <= in_rt_dat_mask_d0;
  // VCS coverage off
  end else if ((in_rt_dat_pvld_d0 | in_rt_dat_pvld_d1) == 1'b0) begin
  end else begin
    in_rt_dat_mask_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(in_rt_dat_pvld_d0 | in_rt_dat_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    in_rt_dat_pd_d1 <= {9{1'b0}};
  end else begin
  if ((in_rt_dat_pvld_d0 | in_rt_dat_pvld_d1) == 1'b1) begin
    in_rt_dat_pd_d1 <= in_rt_dat_pd_d0;
  // VCS coverage off
  end else if ((in_rt_dat_pvld_d0 | in_rt_dat_pvld_d1) == 1'b0) begin
  end else begin
    in_rt_dat_pd_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(in_rt_dat_pvld_d0 | in_rt_dat_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  if ((in_rt_dat_mask_d0[0]) == 1'b1) begin
    in_rt_dat_data_d1[7:0] <= in_rt_dat_data_d0[7:0];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[0]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[7:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[1]) == 1'b1) begin
    in_rt_dat_data_d1[15:8] <= in_rt_dat_data_d0[15:8];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[1]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[15:8] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[2]) == 1'b1) begin
    in_rt_dat_data_d1[23:16] <= in_rt_dat_data_d0[23:16];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[2]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[23:16] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[3]) == 1'b1) begin
    in_rt_dat_data_d1[31:24] <= in_rt_dat_data_d0[31:24];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[3]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[31:24] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[4]) == 1'b1) begin
    in_rt_dat_data_d1[39:32] <= in_rt_dat_data_d0[39:32];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[4]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[39:32] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[5]) == 1'b1) begin
    in_rt_dat_data_d1[47:40] <= in_rt_dat_data_d0[47:40];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[5]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[47:40] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[6]) == 1'b1) begin
    in_rt_dat_data_d1[55:48] <= in_rt_dat_data_d0[55:48];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[6]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[55:48] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[7]) == 1'b1) begin
    in_rt_dat_data_d1[63:56] <= in_rt_dat_data_d0[63:56];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[7]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[63:56] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[8]) == 1'b1) begin
    in_rt_dat_data_d1[71:64] <= in_rt_dat_data_d0[71:64];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[8]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[71:64] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[9]) == 1'b1) begin
    in_rt_dat_data_d1[79:72] <= in_rt_dat_data_d0[79:72];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[9]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[79:72] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[10]) == 1'b1) begin
    in_rt_dat_data_d1[87:80] <= in_rt_dat_data_d0[87:80];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[10]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[87:80] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[11]) == 1'b1) begin
    in_rt_dat_data_d1[95:88] <= in_rt_dat_data_d0[95:88];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[11]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[95:88] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[12]) == 1'b1) begin
    in_rt_dat_data_d1[103:96] <= in_rt_dat_data_d0[103:96];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[12]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[103:96] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[13]) == 1'b1) begin
    in_rt_dat_data_d1[111:104] <= in_rt_dat_data_d0[111:104];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[13]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[111:104] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[14]) == 1'b1) begin
    in_rt_dat_data_d1[119:112] <= in_rt_dat_data_d0[119:112];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[14]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[119:112] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[15]) == 1'b1) begin
    in_rt_dat_data_d1[127:120] <= in_rt_dat_data_d0[127:120];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[15]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[127:120] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[16]) == 1'b1) begin
    in_rt_dat_data_d1[135:128] <= in_rt_dat_data_d0[135:128];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[16]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[135:128] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[17]) == 1'b1) begin
    in_rt_dat_data_d1[143:136] <= in_rt_dat_data_d0[143:136];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[17]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[143:136] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[18]) == 1'b1) begin
    in_rt_dat_data_d1[151:144] <= in_rt_dat_data_d0[151:144];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[18]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[151:144] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[19]) == 1'b1) begin
    in_rt_dat_data_d1[159:152] <= in_rt_dat_data_d0[159:152];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[19]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[159:152] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[20]) == 1'b1) begin
    in_rt_dat_data_d1[167:160] <= in_rt_dat_data_d0[167:160];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[20]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[167:160] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[21]) == 1'b1) begin
    in_rt_dat_data_d1[175:168] <= in_rt_dat_data_d0[175:168];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[21]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[175:168] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[22]) == 1'b1) begin
    in_rt_dat_data_d1[183:176] <= in_rt_dat_data_d0[183:176];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[22]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[183:176] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[23]) == 1'b1) begin
    in_rt_dat_data_d1[191:184] <= in_rt_dat_data_d0[191:184];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[23]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[191:184] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[24]) == 1'b1) begin
    in_rt_dat_data_d1[199:192] <= in_rt_dat_data_d0[199:192];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[24]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[199:192] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[25]) == 1'b1) begin
    in_rt_dat_data_d1[207:200] <= in_rt_dat_data_d0[207:200];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[25]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[207:200] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[26]) == 1'b1) begin
    in_rt_dat_data_d1[215:208] <= in_rt_dat_data_d0[215:208];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[26]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[215:208] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[27]) == 1'b1) begin
    in_rt_dat_data_d1[223:216] <= in_rt_dat_data_d0[223:216];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[27]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[223:216] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[28]) == 1'b1) begin
    in_rt_dat_data_d1[231:224] <= in_rt_dat_data_d0[231:224];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[28]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[231:224] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[29]) == 1'b1) begin
    in_rt_dat_data_d1[239:232] <= in_rt_dat_data_d0[239:232];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[29]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[239:232] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[30]) == 1'b1) begin
    in_rt_dat_data_d1[247:240] <= in_rt_dat_data_d0[247:240];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[30]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[247:240] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[31]) == 1'b1) begin
    in_rt_dat_data_d1[255:248] <= in_rt_dat_data_d0[255:248];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[31]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[255:248] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[32]) == 1'b1) begin
    in_rt_dat_data_d1[263:256] <= in_rt_dat_data_d0[263:256];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[32]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[263:256] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[33]) == 1'b1) begin
    in_rt_dat_data_d1[271:264] <= in_rt_dat_data_d0[271:264];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[33]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[271:264] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[34]) == 1'b1) begin
    in_rt_dat_data_d1[279:272] <= in_rt_dat_data_d0[279:272];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[34]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[279:272] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[35]) == 1'b1) begin
    in_rt_dat_data_d1[287:280] <= in_rt_dat_data_d0[287:280];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[35]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[287:280] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[36]) == 1'b1) begin
    in_rt_dat_data_d1[295:288] <= in_rt_dat_data_d0[295:288];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[36]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[295:288] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[37]) == 1'b1) begin
    in_rt_dat_data_d1[303:296] <= in_rt_dat_data_d0[303:296];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[37]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[303:296] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[38]) == 1'b1) begin
    in_rt_dat_data_d1[311:304] <= in_rt_dat_data_d0[311:304];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[38]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[311:304] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[39]) == 1'b1) begin
    in_rt_dat_data_d1[319:312] <= in_rt_dat_data_d0[319:312];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[39]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[319:312] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[40]) == 1'b1) begin
    in_rt_dat_data_d1[327:320] <= in_rt_dat_data_d0[327:320];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[40]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[327:320] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[41]) == 1'b1) begin
    in_rt_dat_data_d1[335:328] <= in_rt_dat_data_d0[335:328];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[41]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[335:328] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[42]) == 1'b1) begin
    in_rt_dat_data_d1[343:336] <= in_rt_dat_data_d0[343:336];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[42]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[343:336] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[43]) == 1'b1) begin
    in_rt_dat_data_d1[351:344] <= in_rt_dat_data_d0[351:344];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[43]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[351:344] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[44]) == 1'b1) begin
    in_rt_dat_data_d1[359:352] <= in_rt_dat_data_d0[359:352];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[44]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[359:352] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[45]) == 1'b1) begin
    in_rt_dat_data_d1[367:360] <= in_rt_dat_data_d0[367:360];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[45]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[367:360] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[46]) == 1'b1) begin
    in_rt_dat_data_d1[375:368] <= in_rt_dat_data_d0[375:368];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[46]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[375:368] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[47]) == 1'b1) begin
    in_rt_dat_data_d1[383:376] <= in_rt_dat_data_d0[383:376];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[47]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[383:376] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[48]) == 1'b1) begin
    in_rt_dat_data_d1[391:384] <= in_rt_dat_data_d0[391:384];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[48]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[391:384] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[49]) == 1'b1) begin
    in_rt_dat_data_d1[399:392] <= in_rt_dat_data_d0[399:392];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[49]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[399:392] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[50]) == 1'b1) begin
    in_rt_dat_data_d1[407:400] <= in_rt_dat_data_d0[407:400];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[50]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[407:400] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[51]) == 1'b1) begin
    in_rt_dat_data_d1[415:408] <= in_rt_dat_data_d0[415:408];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[51]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[415:408] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[52]) == 1'b1) begin
    in_rt_dat_data_d1[423:416] <= in_rt_dat_data_d0[423:416];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[52]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[423:416] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[53]) == 1'b1) begin
    in_rt_dat_data_d1[431:424] <= in_rt_dat_data_d0[431:424];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[53]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[431:424] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[54]) == 1'b1) begin
    in_rt_dat_data_d1[439:432] <= in_rt_dat_data_d0[439:432];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[54]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[439:432] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[55]) == 1'b1) begin
    in_rt_dat_data_d1[447:440] <= in_rt_dat_data_d0[447:440];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[55]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[447:440] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[56]) == 1'b1) begin
    in_rt_dat_data_d1[455:448] <= in_rt_dat_data_d0[455:448];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[56]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[455:448] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[57]) == 1'b1) begin
    in_rt_dat_data_d1[463:456] <= in_rt_dat_data_d0[463:456];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[57]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[463:456] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[58]) == 1'b1) begin
    in_rt_dat_data_d1[471:464] <= in_rt_dat_data_d0[471:464];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[58]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[471:464] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[59]) == 1'b1) begin
    in_rt_dat_data_d1[479:472] <= in_rt_dat_data_d0[479:472];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[59]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[479:472] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[60]) == 1'b1) begin
    in_rt_dat_data_d1[487:480] <= in_rt_dat_data_d0[487:480];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[60]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[487:480] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[61]) == 1'b1) begin
    in_rt_dat_data_d1[495:488] <= in_rt_dat_data_d0[495:488];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[61]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[495:488] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[62]) == 1'b1) begin
    in_rt_dat_data_d1[503:496] <= in_rt_dat_data_d0[503:496];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[62]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[503:496] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[63]) == 1'b1) begin
    in_rt_dat_data_d1[511:504] <= in_rt_dat_data_d0[511:504];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[63]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[511:504] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[64]) == 1'b1) begin
    in_rt_dat_data_d1[519:512] <= in_rt_dat_data_d0[519:512];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[64]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[519:512] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[65]) == 1'b1) begin
    in_rt_dat_data_d1[527:520] <= in_rt_dat_data_d0[527:520];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[65]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[527:520] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[66]) == 1'b1) begin
    in_rt_dat_data_d1[535:528] <= in_rt_dat_data_d0[535:528];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[66]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[535:528] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[67]) == 1'b1) begin
    in_rt_dat_data_d1[543:536] <= in_rt_dat_data_d0[543:536];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[67]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[543:536] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[68]) == 1'b1) begin
    in_rt_dat_data_d1[551:544] <= in_rt_dat_data_d0[551:544];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[68]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[551:544] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[69]) == 1'b1) begin
    in_rt_dat_data_d1[559:552] <= in_rt_dat_data_d0[559:552];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[69]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[559:552] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[70]) == 1'b1) begin
    in_rt_dat_data_d1[567:560] <= in_rt_dat_data_d0[567:560];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[70]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[567:560] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[71]) == 1'b1) begin
    in_rt_dat_data_d1[575:568] <= in_rt_dat_data_d0[575:568];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[71]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[575:568] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[72]) == 1'b1) begin
    in_rt_dat_data_d1[583:576] <= in_rt_dat_data_d0[583:576];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[72]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[583:576] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[73]) == 1'b1) begin
    in_rt_dat_data_d1[591:584] <= in_rt_dat_data_d0[591:584];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[73]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[591:584] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[74]) == 1'b1) begin
    in_rt_dat_data_d1[599:592] <= in_rt_dat_data_d0[599:592];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[74]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[599:592] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[75]) == 1'b1) begin
    in_rt_dat_data_d1[607:600] <= in_rt_dat_data_d0[607:600];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[75]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[607:600] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[76]) == 1'b1) begin
    in_rt_dat_data_d1[615:608] <= in_rt_dat_data_d0[615:608];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[76]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[615:608] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[77]) == 1'b1) begin
    in_rt_dat_data_d1[623:616] <= in_rt_dat_data_d0[623:616];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[77]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[623:616] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[78]) == 1'b1) begin
    in_rt_dat_data_d1[631:624] <= in_rt_dat_data_d0[631:624];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[78]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[631:624] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[79]) == 1'b1) begin
    in_rt_dat_data_d1[639:632] <= in_rt_dat_data_d0[639:632];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[79]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[639:632] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[80]) == 1'b1) begin
    in_rt_dat_data_d1[647:640] <= in_rt_dat_data_d0[647:640];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[80]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[647:640] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[81]) == 1'b1) begin
    in_rt_dat_data_d1[655:648] <= in_rt_dat_data_d0[655:648];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[81]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[655:648] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[82]) == 1'b1) begin
    in_rt_dat_data_d1[663:656] <= in_rt_dat_data_d0[663:656];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[82]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[663:656] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[83]) == 1'b1) begin
    in_rt_dat_data_d1[671:664] <= in_rt_dat_data_d0[671:664];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[83]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[671:664] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[84]) == 1'b1) begin
    in_rt_dat_data_d1[679:672] <= in_rt_dat_data_d0[679:672];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[84]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[679:672] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[85]) == 1'b1) begin
    in_rt_dat_data_d1[687:680] <= in_rt_dat_data_d0[687:680];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[85]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[687:680] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[86]) == 1'b1) begin
    in_rt_dat_data_d1[695:688] <= in_rt_dat_data_d0[695:688];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[86]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[695:688] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[87]) == 1'b1) begin
    in_rt_dat_data_d1[703:696] <= in_rt_dat_data_d0[703:696];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[87]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[703:696] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[88]) == 1'b1) begin
    in_rt_dat_data_d1[711:704] <= in_rt_dat_data_d0[711:704];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[88]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[711:704] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[89]) == 1'b1) begin
    in_rt_dat_data_d1[719:712] <= in_rt_dat_data_d0[719:712];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[89]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[719:712] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[90]) == 1'b1) begin
    in_rt_dat_data_d1[727:720] <= in_rt_dat_data_d0[727:720];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[90]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[727:720] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[91]) == 1'b1) begin
    in_rt_dat_data_d1[735:728] <= in_rt_dat_data_d0[735:728];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[91]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[735:728] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[92]) == 1'b1) begin
    in_rt_dat_data_d1[743:736] <= in_rt_dat_data_d0[743:736];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[92]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[743:736] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[93]) == 1'b1) begin
    in_rt_dat_data_d1[751:744] <= in_rt_dat_data_d0[751:744];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[93]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[751:744] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[94]) == 1'b1) begin
    in_rt_dat_data_d1[759:752] <= in_rt_dat_data_d0[759:752];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[94]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[759:752] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[95]) == 1'b1) begin
    in_rt_dat_data_d1[767:760] <= in_rt_dat_data_d0[767:760];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[95]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[767:760] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[96]) == 1'b1) begin
    in_rt_dat_data_d1[775:768] <= in_rt_dat_data_d0[775:768];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[96]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[775:768] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[97]) == 1'b1) begin
    in_rt_dat_data_d1[783:776] <= in_rt_dat_data_d0[783:776];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[97]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[783:776] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[98]) == 1'b1) begin
    in_rt_dat_data_d1[791:784] <= in_rt_dat_data_d0[791:784];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[98]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[791:784] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[99]) == 1'b1) begin
    in_rt_dat_data_d1[799:792] <= in_rt_dat_data_d0[799:792];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[99]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[799:792] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[100]) == 1'b1) begin
    in_rt_dat_data_d1[807:800] <= in_rt_dat_data_d0[807:800];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[100]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[807:800] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[101]) == 1'b1) begin
    in_rt_dat_data_d1[815:808] <= in_rt_dat_data_d0[815:808];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[101]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[815:808] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[102]) == 1'b1) begin
    in_rt_dat_data_d1[823:816] <= in_rt_dat_data_d0[823:816];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[102]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[823:816] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[103]) == 1'b1) begin
    in_rt_dat_data_d1[831:824] <= in_rt_dat_data_d0[831:824];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[103]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[831:824] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[104]) == 1'b1) begin
    in_rt_dat_data_d1[839:832] <= in_rt_dat_data_d0[839:832];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[104]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[839:832] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[105]) == 1'b1) begin
    in_rt_dat_data_d1[847:840] <= in_rt_dat_data_d0[847:840];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[105]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[847:840] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[106]) == 1'b1) begin
    in_rt_dat_data_d1[855:848] <= in_rt_dat_data_d0[855:848];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[106]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[855:848] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[107]) == 1'b1) begin
    in_rt_dat_data_d1[863:856] <= in_rt_dat_data_d0[863:856];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[107]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[863:856] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[108]) == 1'b1) begin
    in_rt_dat_data_d1[871:864] <= in_rt_dat_data_d0[871:864];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[108]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[871:864] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[109]) == 1'b1) begin
    in_rt_dat_data_d1[879:872] <= in_rt_dat_data_d0[879:872];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[109]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[879:872] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[110]) == 1'b1) begin
    in_rt_dat_data_d1[887:880] <= in_rt_dat_data_d0[887:880];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[110]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[887:880] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[111]) == 1'b1) begin
    in_rt_dat_data_d1[895:888] <= in_rt_dat_data_d0[895:888];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[111]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[895:888] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[112]) == 1'b1) begin
    in_rt_dat_data_d1[903:896] <= in_rt_dat_data_d0[903:896];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[112]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[903:896] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[113]) == 1'b1) begin
    in_rt_dat_data_d1[911:904] <= in_rt_dat_data_d0[911:904];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[113]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[911:904] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[114]) == 1'b1) begin
    in_rt_dat_data_d1[919:912] <= in_rt_dat_data_d0[919:912];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[114]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[919:912] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[115]) == 1'b1) begin
    in_rt_dat_data_d1[927:920] <= in_rt_dat_data_d0[927:920];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[115]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[927:920] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[116]) == 1'b1) begin
    in_rt_dat_data_d1[935:928] <= in_rt_dat_data_d0[935:928];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[116]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[935:928] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[117]) == 1'b1) begin
    in_rt_dat_data_d1[943:936] <= in_rt_dat_data_d0[943:936];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[117]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[943:936] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[118]) == 1'b1) begin
    in_rt_dat_data_d1[951:944] <= in_rt_dat_data_d0[951:944];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[118]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[951:944] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[119]) == 1'b1) begin
    in_rt_dat_data_d1[959:952] <= in_rt_dat_data_d0[959:952];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[119]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[959:952] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[120]) == 1'b1) begin
    in_rt_dat_data_d1[967:960] <= in_rt_dat_data_d0[967:960];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[120]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[967:960] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[121]) == 1'b1) begin
    in_rt_dat_data_d1[975:968] <= in_rt_dat_data_d0[975:968];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[121]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[975:968] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[122]) == 1'b1) begin
    in_rt_dat_data_d1[983:976] <= in_rt_dat_data_d0[983:976];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[122]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[983:976] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[123]) == 1'b1) begin
    in_rt_dat_data_d1[991:984] <= in_rt_dat_data_d0[991:984];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[123]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[991:984] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[124]) == 1'b1) begin
    in_rt_dat_data_d1[999:992] <= in_rt_dat_data_d0[999:992];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[124]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[999:992] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[125]) == 1'b1) begin
    in_rt_dat_data_d1[1007:1000] <= in_rt_dat_data_d0[1007:1000];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[125]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[1007:1000] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[126]) == 1'b1) begin
    in_rt_dat_data_d1[1015:1008] <= in_rt_dat_data_d0[1015:1008];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[126]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[1015:1008] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_dat_mask_d0[127]) == 1'b1) begin
    in_rt_dat_data_d1[1023:1016] <= in_rt_dat_data_d0[1023:1016];
  // VCS coverage off
  end else if ((in_rt_dat_mask_d0[127]) == 1'b0) begin
  end else begin
    in_rt_dat_data_d1[1023:1016] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    in_rt_wt_pvld_d1 <= 1'b0;
  end else begin
  in_rt_wt_pvld_d1 <= in_rt_wt_pvld_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    in_rt_wt_sel_d1 <= {8{1'b0}};
  end else begin
  if ((in_rt_wt_pvld_d0 | in_rt_wt_pvld_d1) == 1'b1) begin
    in_rt_wt_sel_d1 <= in_rt_wt_sel_d0;
  // VCS coverage off
  end else if ((in_rt_wt_pvld_d0 | in_rt_wt_pvld_d1) == 1'b0) begin
  end else begin
    in_rt_wt_sel_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(in_rt_wt_pvld_d0 | in_rt_wt_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    in_rt_wt_mask_d1 <= {128{1'b0}};
  end else begin
  if ((in_rt_wt_pvld_d0 | in_rt_wt_pvld_d1) == 1'b1) begin
    in_rt_wt_mask_d1 <= in_rt_wt_mask_d0;
  // VCS coverage off
  end else if ((in_rt_wt_pvld_d0 | in_rt_wt_pvld_d1) == 1'b0) begin
  end else begin
    in_rt_wt_mask_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(in_rt_wt_pvld_d0 | in_rt_wt_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  if ((in_rt_wt_mask_d0[0]) == 1'b1) begin
    in_rt_wt_data_d1[7:0] <= in_rt_wt_data_d0[7:0];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[0]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[7:0] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[1]) == 1'b1) begin
    in_rt_wt_data_d1[15:8] <= in_rt_wt_data_d0[15:8];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[1]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[15:8] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[2]) == 1'b1) begin
    in_rt_wt_data_d1[23:16] <= in_rt_wt_data_d0[23:16];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[2]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[23:16] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[3]) == 1'b1) begin
    in_rt_wt_data_d1[31:24] <= in_rt_wt_data_d0[31:24];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[3]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[31:24] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[4]) == 1'b1) begin
    in_rt_wt_data_d1[39:32] <= in_rt_wt_data_d0[39:32];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[4]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[39:32] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[5]) == 1'b1) begin
    in_rt_wt_data_d1[47:40] <= in_rt_wt_data_d0[47:40];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[5]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[47:40] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[6]) == 1'b1) begin
    in_rt_wt_data_d1[55:48] <= in_rt_wt_data_d0[55:48];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[6]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[55:48] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[7]) == 1'b1) begin
    in_rt_wt_data_d1[63:56] <= in_rt_wt_data_d0[63:56];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[7]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[63:56] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[8]) == 1'b1) begin
    in_rt_wt_data_d1[71:64] <= in_rt_wt_data_d0[71:64];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[8]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[71:64] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[9]) == 1'b1) begin
    in_rt_wt_data_d1[79:72] <= in_rt_wt_data_d0[79:72];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[9]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[79:72] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[10]) == 1'b1) begin
    in_rt_wt_data_d1[87:80] <= in_rt_wt_data_d0[87:80];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[10]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[87:80] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[11]) == 1'b1) begin
    in_rt_wt_data_d1[95:88] <= in_rt_wt_data_d0[95:88];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[11]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[95:88] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[12]) == 1'b1) begin
    in_rt_wt_data_d1[103:96] <= in_rt_wt_data_d0[103:96];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[12]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[103:96] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[13]) == 1'b1) begin
    in_rt_wt_data_d1[111:104] <= in_rt_wt_data_d0[111:104];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[13]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[111:104] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[14]) == 1'b1) begin
    in_rt_wt_data_d1[119:112] <= in_rt_wt_data_d0[119:112];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[14]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[119:112] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[15]) == 1'b1) begin
    in_rt_wt_data_d1[127:120] <= in_rt_wt_data_d0[127:120];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[15]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[127:120] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[16]) == 1'b1) begin
    in_rt_wt_data_d1[135:128] <= in_rt_wt_data_d0[135:128];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[16]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[135:128] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[17]) == 1'b1) begin
    in_rt_wt_data_d1[143:136] <= in_rt_wt_data_d0[143:136];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[17]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[143:136] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[18]) == 1'b1) begin
    in_rt_wt_data_d1[151:144] <= in_rt_wt_data_d0[151:144];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[18]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[151:144] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[19]) == 1'b1) begin
    in_rt_wt_data_d1[159:152] <= in_rt_wt_data_d0[159:152];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[19]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[159:152] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[20]) == 1'b1) begin
    in_rt_wt_data_d1[167:160] <= in_rt_wt_data_d0[167:160];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[20]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[167:160] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[21]) == 1'b1) begin
    in_rt_wt_data_d1[175:168] <= in_rt_wt_data_d0[175:168];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[21]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[175:168] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[22]) == 1'b1) begin
    in_rt_wt_data_d1[183:176] <= in_rt_wt_data_d0[183:176];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[22]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[183:176] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[23]) == 1'b1) begin
    in_rt_wt_data_d1[191:184] <= in_rt_wt_data_d0[191:184];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[23]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[191:184] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[24]) == 1'b1) begin
    in_rt_wt_data_d1[199:192] <= in_rt_wt_data_d0[199:192];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[24]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[199:192] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[25]) == 1'b1) begin
    in_rt_wt_data_d1[207:200] <= in_rt_wt_data_d0[207:200];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[25]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[207:200] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[26]) == 1'b1) begin
    in_rt_wt_data_d1[215:208] <= in_rt_wt_data_d0[215:208];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[26]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[215:208] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[27]) == 1'b1) begin
    in_rt_wt_data_d1[223:216] <= in_rt_wt_data_d0[223:216];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[27]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[223:216] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[28]) == 1'b1) begin
    in_rt_wt_data_d1[231:224] <= in_rt_wt_data_d0[231:224];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[28]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[231:224] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[29]) == 1'b1) begin
    in_rt_wt_data_d1[239:232] <= in_rt_wt_data_d0[239:232];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[29]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[239:232] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[30]) == 1'b1) begin
    in_rt_wt_data_d1[247:240] <= in_rt_wt_data_d0[247:240];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[30]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[247:240] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[31]) == 1'b1) begin
    in_rt_wt_data_d1[255:248] <= in_rt_wt_data_d0[255:248];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[31]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[255:248] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[32]) == 1'b1) begin
    in_rt_wt_data_d1[263:256] <= in_rt_wt_data_d0[263:256];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[32]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[263:256] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[33]) == 1'b1) begin
    in_rt_wt_data_d1[271:264] <= in_rt_wt_data_d0[271:264];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[33]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[271:264] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[34]) == 1'b1) begin
    in_rt_wt_data_d1[279:272] <= in_rt_wt_data_d0[279:272];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[34]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[279:272] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[35]) == 1'b1) begin
    in_rt_wt_data_d1[287:280] <= in_rt_wt_data_d0[287:280];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[35]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[287:280] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[36]) == 1'b1) begin
    in_rt_wt_data_d1[295:288] <= in_rt_wt_data_d0[295:288];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[36]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[295:288] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[37]) == 1'b1) begin
    in_rt_wt_data_d1[303:296] <= in_rt_wt_data_d0[303:296];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[37]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[303:296] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[38]) == 1'b1) begin
    in_rt_wt_data_d1[311:304] <= in_rt_wt_data_d0[311:304];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[38]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[311:304] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[39]) == 1'b1) begin
    in_rt_wt_data_d1[319:312] <= in_rt_wt_data_d0[319:312];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[39]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[319:312] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[40]) == 1'b1) begin
    in_rt_wt_data_d1[327:320] <= in_rt_wt_data_d0[327:320];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[40]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[327:320] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[41]) == 1'b1) begin
    in_rt_wt_data_d1[335:328] <= in_rt_wt_data_d0[335:328];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[41]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[335:328] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[42]) == 1'b1) begin
    in_rt_wt_data_d1[343:336] <= in_rt_wt_data_d0[343:336];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[42]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[343:336] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[43]) == 1'b1) begin
    in_rt_wt_data_d1[351:344] <= in_rt_wt_data_d0[351:344];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[43]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[351:344] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[44]) == 1'b1) begin
    in_rt_wt_data_d1[359:352] <= in_rt_wt_data_d0[359:352];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[44]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[359:352] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[45]) == 1'b1) begin
    in_rt_wt_data_d1[367:360] <= in_rt_wt_data_d0[367:360];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[45]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[367:360] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[46]) == 1'b1) begin
    in_rt_wt_data_d1[375:368] <= in_rt_wt_data_d0[375:368];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[46]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[375:368] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[47]) == 1'b1) begin
    in_rt_wt_data_d1[383:376] <= in_rt_wt_data_d0[383:376];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[47]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[383:376] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[48]) == 1'b1) begin
    in_rt_wt_data_d1[391:384] <= in_rt_wt_data_d0[391:384];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[48]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[391:384] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[49]) == 1'b1) begin
    in_rt_wt_data_d1[399:392] <= in_rt_wt_data_d0[399:392];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[49]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[399:392] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[50]) == 1'b1) begin
    in_rt_wt_data_d1[407:400] <= in_rt_wt_data_d0[407:400];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[50]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[407:400] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[51]) == 1'b1) begin
    in_rt_wt_data_d1[415:408] <= in_rt_wt_data_d0[415:408];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[51]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[415:408] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[52]) == 1'b1) begin
    in_rt_wt_data_d1[423:416] <= in_rt_wt_data_d0[423:416];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[52]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[423:416] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[53]) == 1'b1) begin
    in_rt_wt_data_d1[431:424] <= in_rt_wt_data_d0[431:424];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[53]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[431:424] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[54]) == 1'b1) begin
    in_rt_wt_data_d1[439:432] <= in_rt_wt_data_d0[439:432];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[54]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[439:432] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[55]) == 1'b1) begin
    in_rt_wt_data_d1[447:440] <= in_rt_wt_data_d0[447:440];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[55]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[447:440] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[56]) == 1'b1) begin
    in_rt_wt_data_d1[455:448] <= in_rt_wt_data_d0[455:448];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[56]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[455:448] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[57]) == 1'b1) begin
    in_rt_wt_data_d1[463:456] <= in_rt_wt_data_d0[463:456];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[57]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[463:456] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[58]) == 1'b1) begin
    in_rt_wt_data_d1[471:464] <= in_rt_wt_data_d0[471:464];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[58]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[471:464] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[59]) == 1'b1) begin
    in_rt_wt_data_d1[479:472] <= in_rt_wt_data_d0[479:472];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[59]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[479:472] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[60]) == 1'b1) begin
    in_rt_wt_data_d1[487:480] <= in_rt_wt_data_d0[487:480];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[60]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[487:480] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[61]) == 1'b1) begin
    in_rt_wt_data_d1[495:488] <= in_rt_wt_data_d0[495:488];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[61]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[495:488] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[62]) == 1'b1) begin
    in_rt_wt_data_d1[503:496] <= in_rt_wt_data_d0[503:496];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[62]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[503:496] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[63]) == 1'b1) begin
    in_rt_wt_data_d1[511:504] <= in_rt_wt_data_d0[511:504];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[63]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[511:504] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[64]) == 1'b1) begin
    in_rt_wt_data_d1[519:512] <= in_rt_wt_data_d0[519:512];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[64]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[519:512] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[65]) == 1'b1) begin
    in_rt_wt_data_d1[527:520] <= in_rt_wt_data_d0[527:520];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[65]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[527:520] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[66]) == 1'b1) begin
    in_rt_wt_data_d1[535:528] <= in_rt_wt_data_d0[535:528];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[66]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[535:528] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[67]) == 1'b1) begin
    in_rt_wt_data_d1[543:536] <= in_rt_wt_data_d0[543:536];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[67]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[543:536] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[68]) == 1'b1) begin
    in_rt_wt_data_d1[551:544] <= in_rt_wt_data_d0[551:544];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[68]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[551:544] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[69]) == 1'b1) begin
    in_rt_wt_data_d1[559:552] <= in_rt_wt_data_d0[559:552];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[69]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[559:552] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[70]) == 1'b1) begin
    in_rt_wt_data_d1[567:560] <= in_rt_wt_data_d0[567:560];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[70]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[567:560] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[71]) == 1'b1) begin
    in_rt_wt_data_d1[575:568] <= in_rt_wt_data_d0[575:568];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[71]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[575:568] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[72]) == 1'b1) begin
    in_rt_wt_data_d1[583:576] <= in_rt_wt_data_d0[583:576];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[72]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[583:576] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[73]) == 1'b1) begin
    in_rt_wt_data_d1[591:584] <= in_rt_wt_data_d0[591:584];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[73]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[591:584] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[74]) == 1'b1) begin
    in_rt_wt_data_d1[599:592] <= in_rt_wt_data_d0[599:592];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[74]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[599:592] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[75]) == 1'b1) begin
    in_rt_wt_data_d1[607:600] <= in_rt_wt_data_d0[607:600];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[75]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[607:600] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[76]) == 1'b1) begin
    in_rt_wt_data_d1[615:608] <= in_rt_wt_data_d0[615:608];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[76]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[615:608] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[77]) == 1'b1) begin
    in_rt_wt_data_d1[623:616] <= in_rt_wt_data_d0[623:616];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[77]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[623:616] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[78]) == 1'b1) begin
    in_rt_wt_data_d1[631:624] <= in_rt_wt_data_d0[631:624];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[78]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[631:624] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[79]) == 1'b1) begin
    in_rt_wt_data_d1[639:632] <= in_rt_wt_data_d0[639:632];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[79]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[639:632] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[80]) == 1'b1) begin
    in_rt_wt_data_d1[647:640] <= in_rt_wt_data_d0[647:640];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[80]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[647:640] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[81]) == 1'b1) begin
    in_rt_wt_data_d1[655:648] <= in_rt_wt_data_d0[655:648];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[81]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[655:648] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[82]) == 1'b1) begin
    in_rt_wt_data_d1[663:656] <= in_rt_wt_data_d0[663:656];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[82]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[663:656] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[83]) == 1'b1) begin
    in_rt_wt_data_d1[671:664] <= in_rt_wt_data_d0[671:664];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[83]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[671:664] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[84]) == 1'b1) begin
    in_rt_wt_data_d1[679:672] <= in_rt_wt_data_d0[679:672];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[84]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[679:672] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[85]) == 1'b1) begin
    in_rt_wt_data_d1[687:680] <= in_rt_wt_data_d0[687:680];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[85]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[687:680] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[86]) == 1'b1) begin
    in_rt_wt_data_d1[695:688] <= in_rt_wt_data_d0[695:688];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[86]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[695:688] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[87]) == 1'b1) begin
    in_rt_wt_data_d1[703:696] <= in_rt_wt_data_d0[703:696];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[87]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[703:696] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[88]) == 1'b1) begin
    in_rt_wt_data_d1[711:704] <= in_rt_wt_data_d0[711:704];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[88]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[711:704] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[89]) == 1'b1) begin
    in_rt_wt_data_d1[719:712] <= in_rt_wt_data_d0[719:712];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[89]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[719:712] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[90]) == 1'b1) begin
    in_rt_wt_data_d1[727:720] <= in_rt_wt_data_d0[727:720];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[90]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[727:720] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[91]) == 1'b1) begin
    in_rt_wt_data_d1[735:728] <= in_rt_wt_data_d0[735:728];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[91]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[735:728] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[92]) == 1'b1) begin
    in_rt_wt_data_d1[743:736] <= in_rt_wt_data_d0[743:736];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[92]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[743:736] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[93]) == 1'b1) begin
    in_rt_wt_data_d1[751:744] <= in_rt_wt_data_d0[751:744];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[93]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[751:744] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[94]) == 1'b1) begin
    in_rt_wt_data_d1[759:752] <= in_rt_wt_data_d0[759:752];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[94]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[759:752] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[95]) == 1'b1) begin
    in_rt_wt_data_d1[767:760] <= in_rt_wt_data_d0[767:760];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[95]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[767:760] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[96]) == 1'b1) begin
    in_rt_wt_data_d1[775:768] <= in_rt_wt_data_d0[775:768];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[96]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[775:768] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[97]) == 1'b1) begin
    in_rt_wt_data_d1[783:776] <= in_rt_wt_data_d0[783:776];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[97]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[783:776] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[98]) == 1'b1) begin
    in_rt_wt_data_d1[791:784] <= in_rt_wt_data_d0[791:784];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[98]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[791:784] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[99]) == 1'b1) begin
    in_rt_wt_data_d1[799:792] <= in_rt_wt_data_d0[799:792];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[99]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[799:792] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[100]) == 1'b1) begin
    in_rt_wt_data_d1[807:800] <= in_rt_wt_data_d0[807:800];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[100]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[807:800] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[101]) == 1'b1) begin
    in_rt_wt_data_d1[815:808] <= in_rt_wt_data_d0[815:808];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[101]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[815:808] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[102]) == 1'b1) begin
    in_rt_wt_data_d1[823:816] <= in_rt_wt_data_d0[823:816];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[102]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[823:816] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[103]) == 1'b1) begin
    in_rt_wt_data_d1[831:824] <= in_rt_wt_data_d0[831:824];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[103]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[831:824] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[104]) == 1'b1) begin
    in_rt_wt_data_d1[839:832] <= in_rt_wt_data_d0[839:832];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[104]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[839:832] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[105]) == 1'b1) begin
    in_rt_wt_data_d1[847:840] <= in_rt_wt_data_d0[847:840];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[105]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[847:840] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[106]) == 1'b1) begin
    in_rt_wt_data_d1[855:848] <= in_rt_wt_data_d0[855:848];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[106]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[855:848] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[107]) == 1'b1) begin
    in_rt_wt_data_d1[863:856] <= in_rt_wt_data_d0[863:856];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[107]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[863:856] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[108]) == 1'b1) begin
    in_rt_wt_data_d1[871:864] <= in_rt_wt_data_d0[871:864];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[108]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[871:864] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[109]) == 1'b1) begin
    in_rt_wt_data_d1[879:872] <= in_rt_wt_data_d0[879:872];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[109]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[879:872] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[110]) == 1'b1) begin
    in_rt_wt_data_d1[887:880] <= in_rt_wt_data_d0[887:880];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[110]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[887:880] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[111]) == 1'b1) begin
    in_rt_wt_data_d1[895:888] <= in_rt_wt_data_d0[895:888];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[111]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[895:888] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[112]) == 1'b1) begin
    in_rt_wt_data_d1[903:896] <= in_rt_wt_data_d0[903:896];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[112]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[903:896] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[113]) == 1'b1) begin
    in_rt_wt_data_d1[911:904] <= in_rt_wt_data_d0[911:904];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[113]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[911:904] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[114]) == 1'b1) begin
    in_rt_wt_data_d1[919:912] <= in_rt_wt_data_d0[919:912];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[114]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[919:912] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[115]) == 1'b1) begin
    in_rt_wt_data_d1[927:920] <= in_rt_wt_data_d0[927:920];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[115]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[927:920] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[116]) == 1'b1) begin
    in_rt_wt_data_d1[935:928] <= in_rt_wt_data_d0[935:928];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[116]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[935:928] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[117]) == 1'b1) begin
    in_rt_wt_data_d1[943:936] <= in_rt_wt_data_d0[943:936];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[117]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[943:936] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[118]) == 1'b1) begin
    in_rt_wt_data_d1[951:944] <= in_rt_wt_data_d0[951:944];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[118]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[951:944] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[119]) == 1'b1) begin
    in_rt_wt_data_d1[959:952] <= in_rt_wt_data_d0[959:952];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[119]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[959:952] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[120]) == 1'b1) begin
    in_rt_wt_data_d1[967:960] <= in_rt_wt_data_d0[967:960];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[120]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[967:960] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[121]) == 1'b1) begin
    in_rt_wt_data_d1[975:968] <= in_rt_wt_data_d0[975:968];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[121]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[975:968] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[122]) == 1'b1) begin
    in_rt_wt_data_d1[983:976] <= in_rt_wt_data_d0[983:976];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[122]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[983:976] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[123]) == 1'b1) begin
    in_rt_wt_data_d1[991:984] <= in_rt_wt_data_d0[991:984];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[123]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[991:984] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[124]) == 1'b1) begin
    in_rt_wt_data_d1[999:992] <= in_rt_wt_data_d0[999:992];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[124]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[999:992] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[125]) == 1'b1) begin
    in_rt_wt_data_d1[1007:1000] <= in_rt_wt_data_d0[1007:1000];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[125]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[1007:1000] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[126]) == 1'b1) begin
    in_rt_wt_data_d1[1015:1008] <= in_rt_wt_data_d0[1015:1008];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[126]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[1015:1008] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((in_rt_wt_mask_d0[127]) == 1'b1) begin
    in_rt_wt_data_d1[1023:1016] <= in_rt_wt_data_d0[1023:1016];
  // VCS coverage off
  end else if ((in_rt_wt_mask_d0[127]) == 1'b0) begin
  end else begin
    in_rt_wt_data_d1[1023:1016] <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(
  in_rt_dat_pvld_d1
  or in_rt_dat_mask_d1
  or in_rt_dat_pd_d1
  or in_rt_dat_data_d1
  ) begin
    in_dat_pvld = in_rt_dat_pvld_d1;
    in_dat_mask = in_rt_dat_mask_d1;
    in_dat_pd   = in_rt_dat_pd_d1;
    in_dat_data = in_rt_dat_data_d1;
end


always @(
  in_rt_wt_pvld_d1
  or in_rt_wt_mask_d1
  or in_rt_wt_sel_d1
  or in_rt_wt_data_d1
  ) begin
    in_wt_pvld = in_rt_wt_pvld_d1;
    in_wt_mask = in_rt_wt_mask_d1;
    in_wt_sel  = in_rt_wt_sel_d1;
    in_wt_data = in_rt_wt_data_d1;
end



//==========================================================
// Split data and weight bytes
//==========================================================


always @(
  in_dat_data
  ) begin
    {in_dat_data127, in_dat_data126, in_dat_data125, in_dat_data124, in_dat_data123, in_dat_data122, in_dat_data121, in_dat_data120, in_dat_data119, in_dat_data118, in_dat_data117, in_dat_data116, in_dat_data115, in_dat_data114, in_dat_data113, in_dat_data112, in_dat_data111, in_dat_data110, in_dat_data109, in_dat_data108, in_dat_data107, in_dat_data106, in_dat_data105, in_dat_data104, in_dat_data103, in_dat_data102, in_dat_data101, in_dat_data100, in_dat_data99, in_dat_data98, in_dat_data97, in_dat_data96, in_dat_data95, in_dat_data94, in_dat_data93, in_dat_data92, in_dat_data91, in_dat_data90, in_dat_data89, in_dat_data88, in_dat_data87, in_dat_data86, in_dat_data85, in_dat_data84, in_dat_data83, in_dat_data82, in_dat_data81, in_dat_data80, in_dat_data79, in_dat_data78, in_dat_data77, in_dat_data76, in_dat_data75, in_dat_data74, in_dat_data73, in_dat_data72, in_dat_data71, in_dat_data70, in_dat_data69, in_dat_data68, in_dat_data67, in_dat_data66, in_dat_data65, in_dat_data64, in_dat_data63, in_dat_data62, in_dat_data61, in_dat_data60, in_dat_data59, in_dat_data58, in_dat_data57, in_dat_data56, in_dat_data55, in_dat_data54, in_dat_data53, in_dat_data52, in_dat_data51, in_dat_data50, in_dat_data49, in_dat_data48, in_dat_data47, in_dat_data46, in_dat_data45, in_dat_data44, in_dat_data43, in_dat_data42, in_dat_data41, in_dat_data40, in_dat_data39, in_dat_data38, in_dat_data37, in_dat_data36, in_dat_data35, in_dat_data34, in_dat_data33, in_dat_data32, in_dat_data31, in_dat_data30, in_dat_data29, in_dat_data28, in_dat_data27, in_dat_data26, in_dat_data25, in_dat_data24, in_dat_data23, in_dat_data22, in_dat_data21, in_dat_data20, in_dat_data19, in_dat_data18, in_dat_data17, in_dat_data16, in_dat_data15, in_dat_data14, in_dat_data13, in_dat_data12, in_dat_data11, in_dat_data10, in_dat_data9, in_dat_data8, in_dat_data7, in_dat_data6, in_dat_data5, in_dat_data4, in_dat_data3, in_dat_data2, in_dat_data1, in_dat_data0} = in_dat_data;
end

always @(
  in_wt_data
  ) begin
    {in_wt_data127, in_wt_data126, in_wt_data125, in_wt_data124, in_wt_data123, in_wt_data122, in_wt_data121, in_wt_data120, in_wt_data119, in_wt_data118, in_wt_data117, in_wt_data116, in_wt_data115, in_wt_data114, in_wt_data113, in_wt_data112, in_wt_data111, in_wt_data110, in_wt_data109, in_wt_data108, in_wt_data107, in_wt_data106, in_wt_data105, in_wt_data104, in_wt_data103, in_wt_data102, in_wt_data101, in_wt_data100, in_wt_data99, in_wt_data98, in_wt_data97, in_wt_data96, in_wt_data95, in_wt_data94, in_wt_data93, in_wt_data92, in_wt_data91, in_wt_data90, in_wt_data89, in_wt_data88, in_wt_data87, in_wt_data86, in_wt_data85, in_wt_data84, in_wt_data83, in_wt_data82, in_wt_data81, in_wt_data80, in_wt_data79, in_wt_data78, in_wt_data77, in_wt_data76, in_wt_data75, in_wt_data74, in_wt_data73, in_wt_data72, in_wt_data71, in_wt_data70, in_wt_data69, in_wt_data68, in_wt_data67, in_wt_data66, in_wt_data65, in_wt_data64, in_wt_data63, in_wt_data62, in_wt_data61, in_wt_data60, in_wt_data59, in_wt_data58, in_wt_data57, in_wt_data56, in_wt_data55, in_wt_data54, in_wt_data53, in_wt_data52, in_wt_data51, in_wt_data50, in_wt_data49, in_wt_data48, in_wt_data47, in_wt_data46, in_wt_data45, in_wt_data44, in_wt_data43, in_wt_data42, in_wt_data41, in_wt_data40, in_wt_data39, in_wt_data38, in_wt_data37, in_wt_data36, in_wt_data35, in_wt_data34, in_wt_data33, in_wt_data32, in_wt_data31, in_wt_data30, in_wt_data29, in_wt_data28, in_wt_data27, in_wt_data26, in_wt_data25, in_wt_data24, in_wt_data23, in_wt_data22, in_wt_data21, in_wt_data20, in_wt_data19, in_wt_data18, in_wt_data17, in_wt_data16, in_wt_data15, in_wt_data14, in_wt_data13, in_wt_data12, in_wt_data11, in_wt_data10, in_wt_data9, in_wt_data8, in_wt_data7, in_wt_data6, in_wt_data5, in_wt_data4, in_wt_data3, in_wt_data2, in_wt_data1, in_wt_data0} = in_wt_data;
end


//==========================================================
// Generate control signals
//==========================================================

always @(
  in_dat_pd
  ) begin
    in_dat_stripe_st  = in_dat_pd[5:5];
    in_dat_stripe_end = in_dat_pd[6:6];
end


endmodule // NV_NVDLA_CMAC_CORE_rt_in


