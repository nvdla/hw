// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_RT_csc2cmac_a.v

module NV_NVDLA_RT_csc2cmac_a (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,sc2mac_wt_src_pvld
  ,sc2mac_wt_src_mask
  ,sc2mac_wt_src_data0
  ,sc2mac_wt_src_data1
  ,sc2mac_wt_src_data2
  ,sc2mac_wt_src_data3
  ,sc2mac_wt_src_data4
  ,sc2mac_wt_src_data5
  ,sc2mac_wt_src_data6
  ,sc2mac_wt_src_data7
  ,sc2mac_wt_src_data8
  ,sc2mac_wt_src_data9
  ,sc2mac_wt_src_data10
  ,sc2mac_wt_src_data11
  ,sc2mac_wt_src_data12
  ,sc2mac_wt_src_data13
  ,sc2mac_wt_src_data14
  ,sc2mac_wt_src_data15
  ,sc2mac_wt_src_data16
  ,sc2mac_wt_src_data17
  ,sc2mac_wt_src_data18
  ,sc2mac_wt_src_data19
  ,sc2mac_wt_src_data20
  ,sc2mac_wt_src_data21
  ,sc2mac_wt_src_data22
  ,sc2mac_wt_src_data23
  ,sc2mac_wt_src_data24
  ,sc2mac_wt_src_data25
  ,sc2mac_wt_src_data26
  ,sc2mac_wt_src_data27
  ,sc2mac_wt_src_data28
  ,sc2mac_wt_src_data29
  ,sc2mac_wt_src_data30
  ,sc2mac_wt_src_data31
  ,sc2mac_wt_src_data32
  ,sc2mac_wt_src_data33
  ,sc2mac_wt_src_data34
  ,sc2mac_wt_src_data35
  ,sc2mac_wt_src_data36
  ,sc2mac_wt_src_data37
  ,sc2mac_wt_src_data38
  ,sc2mac_wt_src_data39
  ,sc2mac_wt_src_data40
  ,sc2mac_wt_src_data41
  ,sc2mac_wt_src_data42
  ,sc2mac_wt_src_data43
  ,sc2mac_wt_src_data44
  ,sc2mac_wt_src_data45
  ,sc2mac_wt_src_data46
  ,sc2mac_wt_src_data47
  ,sc2mac_wt_src_data48
  ,sc2mac_wt_src_data49
  ,sc2mac_wt_src_data50
  ,sc2mac_wt_src_data51
  ,sc2mac_wt_src_data52
  ,sc2mac_wt_src_data53
  ,sc2mac_wt_src_data54
  ,sc2mac_wt_src_data55
  ,sc2mac_wt_src_data56
  ,sc2mac_wt_src_data57
  ,sc2mac_wt_src_data58
  ,sc2mac_wt_src_data59
  ,sc2mac_wt_src_data60
  ,sc2mac_wt_src_data61
  ,sc2mac_wt_src_data62
  ,sc2mac_wt_src_data63
  ,sc2mac_wt_src_data64
  ,sc2mac_wt_src_data65
  ,sc2mac_wt_src_data66
  ,sc2mac_wt_src_data67
  ,sc2mac_wt_src_data68
  ,sc2mac_wt_src_data69
  ,sc2mac_wt_src_data70
  ,sc2mac_wt_src_data71
  ,sc2mac_wt_src_data72
  ,sc2mac_wt_src_data73
  ,sc2mac_wt_src_data74
  ,sc2mac_wt_src_data75
  ,sc2mac_wt_src_data76
  ,sc2mac_wt_src_data77
  ,sc2mac_wt_src_data78
  ,sc2mac_wt_src_data79
  ,sc2mac_wt_src_data80
  ,sc2mac_wt_src_data81
  ,sc2mac_wt_src_data82
  ,sc2mac_wt_src_data83
  ,sc2mac_wt_src_data84
  ,sc2mac_wt_src_data85
  ,sc2mac_wt_src_data86
  ,sc2mac_wt_src_data87
  ,sc2mac_wt_src_data88
  ,sc2mac_wt_src_data89
  ,sc2mac_wt_src_data90
  ,sc2mac_wt_src_data91
  ,sc2mac_wt_src_data92
  ,sc2mac_wt_src_data93
  ,sc2mac_wt_src_data94
  ,sc2mac_wt_src_data95
  ,sc2mac_wt_src_data96
  ,sc2mac_wt_src_data97
  ,sc2mac_wt_src_data98
  ,sc2mac_wt_src_data99
  ,sc2mac_wt_src_data100
  ,sc2mac_wt_src_data101
  ,sc2mac_wt_src_data102
  ,sc2mac_wt_src_data103
  ,sc2mac_wt_src_data104
  ,sc2mac_wt_src_data105
  ,sc2mac_wt_src_data106
  ,sc2mac_wt_src_data107
  ,sc2mac_wt_src_data108
  ,sc2mac_wt_src_data109
  ,sc2mac_wt_src_data110
  ,sc2mac_wt_src_data111
  ,sc2mac_wt_src_data112
  ,sc2mac_wt_src_data113
  ,sc2mac_wt_src_data114
  ,sc2mac_wt_src_data115
  ,sc2mac_wt_src_data116
  ,sc2mac_wt_src_data117
  ,sc2mac_wt_src_data118
  ,sc2mac_wt_src_data119
  ,sc2mac_wt_src_data120
  ,sc2mac_wt_src_data121
  ,sc2mac_wt_src_data122
  ,sc2mac_wt_src_data123
  ,sc2mac_wt_src_data124
  ,sc2mac_wt_src_data125
  ,sc2mac_wt_src_data126
  ,sc2mac_wt_src_data127
  ,sc2mac_wt_src_sel
  ,sc2mac_dat_src_pvld
  ,sc2mac_dat_src_mask
  ,sc2mac_dat_src_data0
  ,sc2mac_dat_src_data1
  ,sc2mac_dat_src_data2
  ,sc2mac_dat_src_data3
  ,sc2mac_dat_src_data4
  ,sc2mac_dat_src_data5
  ,sc2mac_dat_src_data6
  ,sc2mac_dat_src_data7
  ,sc2mac_dat_src_data8
  ,sc2mac_dat_src_data9
  ,sc2mac_dat_src_data10
  ,sc2mac_dat_src_data11
  ,sc2mac_dat_src_data12
  ,sc2mac_dat_src_data13
  ,sc2mac_dat_src_data14
  ,sc2mac_dat_src_data15
  ,sc2mac_dat_src_data16
  ,sc2mac_dat_src_data17
  ,sc2mac_dat_src_data18
  ,sc2mac_dat_src_data19
  ,sc2mac_dat_src_data20
  ,sc2mac_dat_src_data21
  ,sc2mac_dat_src_data22
  ,sc2mac_dat_src_data23
  ,sc2mac_dat_src_data24
  ,sc2mac_dat_src_data25
  ,sc2mac_dat_src_data26
  ,sc2mac_dat_src_data27
  ,sc2mac_dat_src_data28
  ,sc2mac_dat_src_data29
  ,sc2mac_dat_src_data30
  ,sc2mac_dat_src_data31
  ,sc2mac_dat_src_data32
  ,sc2mac_dat_src_data33
  ,sc2mac_dat_src_data34
  ,sc2mac_dat_src_data35
  ,sc2mac_dat_src_data36
  ,sc2mac_dat_src_data37
  ,sc2mac_dat_src_data38
  ,sc2mac_dat_src_data39
  ,sc2mac_dat_src_data40
  ,sc2mac_dat_src_data41
  ,sc2mac_dat_src_data42
  ,sc2mac_dat_src_data43
  ,sc2mac_dat_src_data44
  ,sc2mac_dat_src_data45
  ,sc2mac_dat_src_data46
  ,sc2mac_dat_src_data47
  ,sc2mac_dat_src_data48
  ,sc2mac_dat_src_data49
  ,sc2mac_dat_src_data50
  ,sc2mac_dat_src_data51
  ,sc2mac_dat_src_data52
  ,sc2mac_dat_src_data53
  ,sc2mac_dat_src_data54
  ,sc2mac_dat_src_data55
  ,sc2mac_dat_src_data56
  ,sc2mac_dat_src_data57
  ,sc2mac_dat_src_data58
  ,sc2mac_dat_src_data59
  ,sc2mac_dat_src_data60
  ,sc2mac_dat_src_data61
  ,sc2mac_dat_src_data62
  ,sc2mac_dat_src_data63
  ,sc2mac_dat_src_data64
  ,sc2mac_dat_src_data65
  ,sc2mac_dat_src_data66
  ,sc2mac_dat_src_data67
  ,sc2mac_dat_src_data68
  ,sc2mac_dat_src_data69
  ,sc2mac_dat_src_data70
  ,sc2mac_dat_src_data71
  ,sc2mac_dat_src_data72
  ,sc2mac_dat_src_data73
  ,sc2mac_dat_src_data74
  ,sc2mac_dat_src_data75
  ,sc2mac_dat_src_data76
  ,sc2mac_dat_src_data77
  ,sc2mac_dat_src_data78
  ,sc2mac_dat_src_data79
  ,sc2mac_dat_src_data80
  ,sc2mac_dat_src_data81
  ,sc2mac_dat_src_data82
  ,sc2mac_dat_src_data83
  ,sc2mac_dat_src_data84
  ,sc2mac_dat_src_data85
  ,sc2mac_dat_src_data86
  ,sc2mac_dat_src_data87
  ,sc2mac_dat_src_data88
  ,sc2mac_dat_src_data89
  ,sc2mac_dat_src_data90
  ,sc2mac_dat_src_data91
  ,sc2mac_dat_src_data92
  ,sc2mac_dat_src_data93
  ,sc2mac_dat_src_data94
  ,sc2mac_dat_src_data95
  ,sc2mac_dat_src_data96
  ,sc2mac_dat_src_data97
  ,sc2mac_dat_src_data98
  ,sc2mac_dat_src_data99
  ,sc2mac_dat_src_data100
  ,sc2mac_dat_src_data101
  ,sc2mac_dat_src_data102
  ,sc2mac_dat_src_data103
  ,sc2mac_dat_src_data104
  ,sc2mac_dat_src_data105
  ,sc2mac_dat_src_data106
  ,sc2mac_dat_src_data107
  ,sc2mac_dat_src_data108
  ,sc2mac_dat_src_data109
  ,sc2mac_dat_src_data110
  ,sc2mac_dat_src_data111
  ,sc2mac_dat_src_data112
  ,sc2mac_dat_src_data113
  ,sc2mac_dat_src_data114
  ,sc2mac_dat_src_data115
  ,sc2mac_dat_src_data116
  ,sc2mac_dat_src_data117
  ,sc2mac_dat_src_data118
  ,sc2mac_dat_src_data119
  ,sc2mac_dat_src_data120
  ,sc2mac_dat_src_data121
  ,sc2mac_dat_src_data122
  ,sc2mac_dat_src_data123
  ,sc2mac_dat_src_data124
  ,sc2mac_dat_src_data125
  ,sc2mac_dat_src_data126
  ,sc2mac_dat_src_data127
  ,sc2mac_dat_src_pd
  ,sc2mac_wt_dst_pvld
  ,sc2mac_wt_dst_mask
  ,sc2mac_wt_dst_data0
  ,sc2mac_wt_dst_data1
  ,sc2mac_wt_dst_data2
  ,sc2mac_wt_dst_data3
  ,sc2mac_wt_dst_data4
  ,sc2mac_wt_dst_data5
  ,sc2mac_wt_dst_data6
  ,sc2mac_wt_dst_data7
  ,sc2mac_wt_dst_data8
  ,sc2mac_wt_dst_data9
  ,sc2mac_wt_dst_data10
  ,sc2mac_wt_dst_data11
  ,sc2mac_wt_dst_data12
  ,sc2mac_wt_dst_data13
  ,sc2mac_wt_dst_data14
  ,sc2mac_wt_dst_data15
  ,sc2mac_wt_dst_data16
  ,sc2mac_wt_dst_data17
  ,sc2mac_wt_dst_data18
  ,sc2mac_wt_dst_data19
  ,sc2mac_wt_dst_data20
  ,sc2mac_wt_dst_data21
  ,sc2mac_wt_dst_data22
  ,sc2mac_wt_dst_data23
  ,sc2mac_wt_dst_data24
  ,sc2mac_wt_dst_data25
  ,sc2mac_wt_dst_data26
  ,sc2mac_wt_dst_data27
  ,sc2mac_wt_dst_data28
  ,sc2mac_wt_dst_data29
  ,sc2mac_wt_dst_data30
  ,sc2mac_wt_dst_data31
  ,sc2mac_wt_dst_data32
  ,sc2mac_wt_dst_data33
  ,sc2mac_wt_dst_data34
  ,sc2mac_wt_dst_data35
  ,sc2mac_wt_dst_data36
  ,sc2mac_wt_dst_data37
  ,sc2mac_wt_dst_data38
  ,sc2mac_wt_dst_data39
  ,sc2mac_wt_dst_data40
  ,sc2mac_wt_dst_data41
  ,sc2mac_wt_dst_data42
  ,sc2mac_wt_dst_data43
  ,sc2mac_wt_dst_data44
  ,sc2mac_wt_dst_data45
  ,sc2mac_wt_dst_data46
  ,sc2mac_wt_dst_data47
  ,sc2mac_wt_dst_data48
  ,sc2mac_wt_dst_data49
  ,sc2mac_wt_dst_data50
  ,sc2mac_wt_dst_data51
  ,sc2mac_wt_dst_data52
  ,sc2mac_wt_dst_data53
  ,sc2mac_wt_dst_data54
  ,sc2mac_wt_dst_data55
  ,sc2mac_wt_dst_data56
  ,sc2mac_wt_dst_data57
  ,sc2mac_wt_dst_data58
  ,sc2mac_wt_dst_data59
  ,sc2mac_wt_dst_data60
  ,sc2mac_wt_dst_data61
  ,sc2mac_wt_dst_data62
  ,sc2mac_wt_dst_data63
  ,sc2mac_wt_dst_data64
  ,sc2mac_wt_dst_data65
  ,sc2mac_wt_dst_data66
  ,sc2mac_wt_dst_data67
  ,sc2mac_wt_dst_data68
  ,sc2mac_wt_dst_data69
  ,sc2mac_wt_dst_data70
  ,sc2mac_wt_dst_data71
  ,sc2mac_wt_dst_data72
  ,sc2mac_wt_dst_data73
  ,sc2mac_wt_dst_data74
  ,sc2mac_wt_dst_data75
  ,sc2mac_wt_dst_data76
  ,sc2mac_wt_dst_data77
  ,sc2mac_wt_dst_data78
  ,sc2mac_wt_dst_data79
  ,sc2mac_wt_dst_data80
  ,sc2mac_wt_dst_data81
  ,sc2mac_wt_dst_data82
  ,sc2mac_wt_dst_data83
  ,sc2mac_wt_dst_data84
  ,sc2mac_wt_dst_data85
  ,sc2mac_wt_dst_data86
  ,sc2mac_wt_dst_data87
  ,sc2mac_wt_dst_data88
  ,sc2mac_wt_dst_data89
  ,sc2mac_wt_dst_data90
  ,sc2mac_wt_dst_data91
  ,sc2mac_wt_dst_data92
  ,sc2mac_wt_dst_data93
  ,sc2mac_wt_dst_data94
  ,sc2mac_wt_dst_data95
  ,sc2mac_wt_dst_data96
  ,sc2mac_wt_dst_data97
  ,sc2mac_wt_dst_data98
  ,sc2mac_wt_dst_data99
  ,sc2mac_wt_dst_data100
  ,sc2mac_wt_dst_data101
  ,sc2mac_wt_dst_data102
  ,sc2mac_wt_dst_data103
  ,sc2mac_wt_dst_data104
  ,sc2mac_wt_dst_data105
  ,sc2mac_wt_dst_data106
  ,sc2mac_wt_dst_data107
  ,sc2mac_wt_dst_data108
  ,sc2mac_wt_dst_data109
  ,sc2mac_wt_dst_data110
  ,sc2mac_wt_dst_data111
  ,sc2mac_wt_dst_data112
  ,sc2mac_wt_dst_data113
  ,sc2mac_wt_dst_data114
  ,sc2mac_wt_dst_data115
  ,sc2mac_wt_dst_data116
  ,sc2mac_wt_dst_data117
  ,sc2mac_wt_dst_data118
  ,sc2mac_wt_dst_data119
  ,sc2mac_wt_dst_data120
  ,sc2mac_wt_dst_data121
  ,sc2mac_wt_dst_data122
  ,sc2mac_wt_dst_data123
  ,sc2mac_wt_dst_data124
  ,sc2mac_wt_dst_data125
  ,sc2mac_wt_dst_data126
  ,sc2mac_wt_dst_data127
  ,sc2mac_wt_dst_sel
  ,sc2mac_dat_dst_pvld
  ,sc2mac_dat_dst_mask
  ,sc2mac_dat_dst_data0
  ,sc2mac_dat_dst_data1
  ,sc2mac_dat_dst_data2
  ,sc2mac_dat_dst_data3
  ,sc2mac_dat_dst_data4
  ,sc2mac_dat_dst_data5
  ,sc2mac_dat_dst_data6
  ,sc2mac_dat_dst_data7
  ,sc2mac_dat_dst_data8
  ,sc2mac_dat_dst_data9
  ,sc2mac_dat_dst_data10
  ,sc2mac_dat_dst_data11
  ,sc2mac_dat_dst_data12
  ,sc2mac_dat_dst_data13
  ,sc2mac_dat_dst_data14
  ,sc2mac_dat_dst_data15
  ,sc2mac_dat_dst_data16
  ,sc2mac_dat_dst_data17
  ,sc2mac_dat_dst_data18
  ,sc2mac_dat_dst_data19
  ,sc2mac_dat_dst_data20
  ,sc2mac_dat_dst_data21
  ,sc2mac_dat_dst_data22
  ,sc2mac_dat_dst_data23
  ,sc2mac_dat_dst_data24
  ,sc2mac_dat_dst_data25
  ,sc2mac_dat_dst_data26
  ,sc2mac_dat_dst_data27
  ,sc2mac_dat_dst_data28
  ,sc2mac_dat_dst_data29
  ,sc2mac_dat_dst_data30
  ,sc2mac_dat_dst_data31
  ,sc2mac_dat_dst_data32
  ,sc2mac_dat_dst_data33
  ,sc2mac_dat_dst_data34
  ,sc2mac_dat_dst_data35
  ,sc2mac_dat_dst_data36
  ,sc2mac_dat_dst_data37
  ,sc2mac_dat_dst_data38
  ,sc2mac_dat_dst_data39
  ,sc2mac_dat_dst_data40
  ,sc2mac_dat_dst_data41
  ,sc2mac_dat_dst_data42
  ,sc2mac_dat_dst_data43
  ,sc2mac_dat_dst_data44
  ,sc2mac_dat_dst_data45
  ,sc2mac_dat_dst_data46
  ,sc2mac_dat_dst_data47
  ,sc2mac_dat_dst_data48
  ,sc2mac_dat_dst_data49
  ,sc2mac_dat_dst_data50
  ,sc2mac_dat_dst_data51
  ,sc2mac_dat_dst_data52
  ,sc2mac_dat_dst_data53
  ,sc2mac_dat_dst_data54
  ,sc2mac_dat_dst_data55
  ,sc2mac_dat_dst_data56
  ,sc2mac_dat_dst_data57
  ,sc2mac_dat_dst_data58
  ,sc2mac_dat_dst_data59
  ,sc2mac_dat_dst_data60
  ,sc2mac_dat_dst_data61
  ,sc2mac_dat_dst_data62
  ,sc2mac_dat_dst_data63
  ,sc2mac_dat_dst_data64
  ,sc2mac_dat_dst_data65
  ,sc2mac_dat_dst_data66
  ,sc2mac_dat_dst_data67
  ,sc2mac_dat_dst_data68
  ,sc2mac_dat_dst_data69
  ,sc2mac_dat_dst_data70
  ,sc2mac_dat_dst_data71
  ,sc2mac_dat_dst_data72
  ,sc2mac_dat_dst_data73
  ,sc2mac_dat_dst_data74
  ,sc2mac_dat_dst_data75
  ,sc2mac_dat_dst_data76
  ,sc2mac_dat_dst_data77
  ,sc2mac_dat_dst_data78
  ,sc2mac_dat_dst_data79
  ,sc2mac_dat_dst_data80
  ,sc2mac_dat_dst_data81
  ,sc2mac_dat_dst_data82
  ,sc2mac_dat_dst_data83
  ,sc2mac_dat_dst_data84
  ,sc2mac_dat_dst_data85
  ,sc2mac_dat_dst_data86
  ,sc2mac_dat_dst_data87
  ,sc2mac_dat_dst_data88
  ,sc2mac_dat_dst_data89
  ,sc2mac_dat_dst_data90
  ,sc2mac_dat_dst_data91
  ,sc2mac_dat_dst_data92
  ,sc2mac_dat_dst_data93
  ,sc2mac_dat_dst_data94
  ,sc2mac_dat_dst_data95
  ,sc2mac_dat_dst_data96
  ,sc2mac_dat_dst_data97
  ,sc2mac_dat_dst_data98
  ,sc2mac_dat_dst_data99
  ,sc2mac_dat_dst_data100
  ,sc2mac_dat_dst_data101
  ,sc2mac_dat_dst_data102
  ,sc2mac_dat_dst_data103
  ,sc2mac_dat_dst_data104
  ,sc2mac_dat_dst_data105
  ,sc2mac_dat_dst_data106
  ,sc2mac_dat_dst_data107
  ,sc2mac_dat_dst_data108
  ,sc2mac_dat_dst_data109
  ,sc2mac_dat_dst_data110
  ,sc2mac_dat_dst_data111
  ,sc2mac_dat_dst_data112
  ,sc2mac_dat_dst_data113
  ,sc2mac_dat_dst_data114
  ,sc2mac_dat_dst_data115
  ,sc2mac_dat_dst_data116
  ,sc2mac_dat_dst_data117
  ,sc2mac_dat_dst_data118
  ,sc2mac_dat_dst_data119
  ,sc2mac_dat_dst_data120
  ,sc2mac_dat_dst_data121
  ,sc2mac_dat_dst_data122
  ,sc2mac_dat_dst_data123
  ,sc2mac_dat_dst_data124
  ,sc2mac_dat_dst_data125
  ,sc2mac_dat_dst_data126
  ,sc2mac_dat_dst_data127
  ,sc2mac_dat_dst_pd
  );

//
// NV_NVDLA_RT_csc2cmac_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input         sc2mac_wt_src_pvld;     /* data valid */
input [127:0] sc2mac_wt_src_mask;
input   [7:0] sc2mac_wt_src_data0;
input   [7:0] sc2mac_wt_src_data1;
input   [7:0] sc2mac_wt_src_data2;
input   [7:0] sc2mac_wt_src_data3;
input   [7:0] sc2mac_wt_src_data4;
input   [7:0] sc2mac_wt_src_data5;
input   [7:0] sc2mac_wt_src_data6;
input   [7:0] sc2mac_wt_src_data7;
input   [7:0] sc2mac_wt_src_data8;
input   [7:0] sc2mac_wt_src_data9;
input   [7:0] sc2mac_wt_src_data10;
input   [7:0] sc2mac_wt_src_data11;
input   [7:0] sc2mac_wt_src_data12;
input   [7:0] sc2mac_wt_src_data13;
input   [7:0] sc2mac_wt_src_data14;
input   [7:0] sc2mac_wt_src_data15;
input   [7:0] sc2mac_wt_src_data16;
input   [7:0] sc2mac_wt_src_data17;
input   [7:0] sc2mac_wt_src_data18;
input   [7:0] sc2mac_wt_src_data19;
input   [7:0] sc2mac_wt_src_data20;
input   [7:0] sc2mac_wt_src_data21;
input   [7:0] sc2mac_wt_src_data22;
input   [7:0] sc2mac_wt_src_data23;
input   [7:0] sc2mac_wt_src_data24;
input   [7:0] sc2mac_wt_src_data25;
input   [7:0] sc2mac_wt_src_data26;
input   [7:0] sc2mac_wt_src_data27;
input   [7:0] sc2mac_wt_src_data28;
input   [7:0] sc2mac_wt_src_data29;
input   [7:0] sc2mac_wt_src_data30;
input   [7:0] sc2mac_wt_src_data31;
input   [7:0] sc2mac_wt_src_data32;
input   [7:0] sc2mac_wt_src_data33;
input   [7:0] sc2mac_wt_src_data34;
input   [7:0] sc2mac_wt_src_data35;
input   [7:0] sc2mac_wt_src_data36;
input   [7:0] sc2mac_wt_src_data37;
input   [7:0] sc2mac_wt_src_data38;
input   [7:0] sc2mac_wt_src_data39;
input   [7:0] sc2mac_wt_src_data40;
input   [7:0] sc2mac_wt_src_data41;
input   [7:0] sc2mac_wt_src_data42;
input   [7:0] sc2mac_wt_src_data43;
input   [7:0] sc2mac_wt_src_data44;
input   [7:0] sc2mac_wt_src_data45;
input   [7:0] sc2mac_wt_src_data46;
input   [7:0] sc2mac_wt_src_data47;
input   [7:0] sc2mac_wt_src_data48;
input   [7:0] sc2mac_wt_src_data49;
input   [7:0] sc2mac_wt_src_data50;
input   [7:0] sc2mac_wt_src_data51;
input   [7:0] sc2mac_wt_src_data52;
input   [7:0] sc2mac_wt_src_data53;
input   [7:0] sc2mac_wt_src_data54;
input   [7:0] sc2mac_wt_src_data55;
input   [7:0] sc2mac_wt_src_data56;
input   [7:0] sc2mac_wt_src_data57;
input   [7:0] sc2mac_wt_src_data58;
input   [7:0] sc2mac_wt_src_data59;
input   [7:0] sc2mac_wt_src_data60;
input   [7:0] sc2mac_wt_src_data61;
input   [7:0] sc2mac_wt_src_data62;
input   [7:0] sc2mac_wt_src_data63;
input   [7:0] sc2mac_wt_src_data64;
input   [7:0] sc2mac_wt_src_data65;
input   [7:0] sc2mac_wt_src_data66;
input   [7:0] sc2mac_wt_src_data67;
input   [7:0] sc2mac_wt_src_data68;
input   [7:0] sc2mac_wt_src_data69;
input   [7:0] sc2mac_wt_src_data70;
input   [7:0] sc2mac_wt_src_data71;
input   [7:0] sc2mac_wt_src_data72;
input   [7:0] sc2mac_wt_src_data73;
input   [7:0] sc2mac_wt_src_data74;
input   [7:0] sc2mac_wt_src_data75;
input   [7:0] sc2mac_wt_src_data76;
input   [7:0] sc2mac_wt_src_data77;
input   [7:0] sc2mac_wt_src_data78;
input   [7:0] sc2mac_wt_src_data79;
input   [7:0] sc2mac_wt_src_data80;
input   [7:0] sc2mac_wt_src_data81;
input   [7:0] sc2mac_wt_src_data82;
input   [7:0] sc2mac_wt_src_data83;
input   [7:0] sc2mac_wt_src_data84;
input   [7:0] sc2mac_wt_src_data85;
input   [7:0] sc2mac_wt_src_data86;
input   [7:0] sc2mac_wt_src_data87;
input   [7:0] sc2mac_wt_src_data88;
input   [7:0] sc2mac_wt_src_data89;
input   [7:0] sc2mac_wt_src_data90;
input   [7:0] sc2mac_wt_src_data91;
input   [7:0] sc2mac_wt_src_data92;
input   [7:0] sc2mac_wt_src_data93;
input   [7:0] sc2mac_wt_src_data94;
input   [7:0] sc2mac_wt_src_data95;
input   [7:0] sc2mac_wt_src_data96;
input   [7:0] sc2mac_wt_src_data97;
input   [7:0] sc2mac_wt_src_data98;
input   [7:0] sc2mac_wt_src_data99;
input   [7:0] sc2mac_wt_src_data100;
input   [7:0] sc2mac_wt_src_data101;
input   [7:0] sc2mac_wt_src_data102;
input   [7:0] sc2mac_wt_src_data103;
input   [7:0] sc2mac_wt_src_data104;
input   [7:0] sc2mac_wt_src_data105;
input   [7:0] sc2mac_wt_src_data106;
input   [7:0] sc2mac_wt_src_data107;
input   [7:0] sc2mac_wt_src_data108;
input   [7:0] sc2mac_wt_src_data109;
input   [7:0] sc2mac_wt_src_data110;
input   [7:0] sc2mac_wt_src_data111;
input   [7:0] sc2mac_wt_src_data112;
input   [7:0] sc2mac_wt_src_data113;
input   [7:0] sc2mac_wt_src_data114;
input   [7:0] sc2mac_wt_src_data115;
input   [7:0] sc2mac_wt_src_data116;
input   [7:0] sc2mac_wt_src_data117;
input   [7:0] sc2mac_wt_src_data118;
input   [7:0] sc2mac_wt_src_data119;
input   [7:0] sc2mac_wt_src_data120;
input   [7:0] sc2mac_wt_src_data121;
input   [7:0] sc2mac_wt_src_data122;
input   [7:0] sc2mac_wt_src_data123;
input   [7:0] sc2mac_wt_src_data124;
input   [7:0] sc2mac_wt_src_data125;
input   [7:0] sc2mac_wt_src_data126;
input   [7:0] sc2mac_wt_src_data127;
input   [7:0] sc2mac_wt_src_sel;

input         sc2mac_dat_src_pvld;     /* data valid */
input [127:0] sc2mac_dat_src_mask;
input   [7:0] sc2mac_dat_src_data0;
input   [7:0] sc2mac_dat_src_data1;
input   [7:0] sc2mac_dat_src_data2;
input   [7:0] sc2mac_dat_src_data3;
input   [7:0] sc2mac_dat_src_data4;
input   [7:0] sc2mac_dat_src_data5;
input   [7:0] sc2mac_dat_src_data6;
input   [7:0] sc2mac_dat_src_data7;
input   [7:0] sc2mac_dat_src_data8;
input   [7:0] sc2mac_dat_src_data9;
input   [7:0] sc2mac_dat_src_data10;
input   [7:0] sc2mac_dat_src_data11;
input   [7:0] sc2mac_dat_src_data12;
input   [7:0] sc2mac_dat_src_data13;
input   [7:0] sc2mac_dat_src_data14;
input   [7:0] sc2mac_dat_src_data15;
input   [7:0] sc2mac_dat_src_data16;
input   [7:0] sc2mac_dat_src_data17;
input   [7:0] sc2mac_dat_src_data18;
input   [7:0] sc2mac_dat_src_data19;
input   [7:0] sc2mac_dat_src_data20;
input   [7:0] sc2mac_dat_src_data21;
input   [7:0] sc2mac_dat_src_data22;
input   [7:0] sc2mac_dat_src_data23;
input   [7:0] sc2mac_dat_src_data24;
input   [7:0] sc2mac_dat_src_data25;
input   [7:0] sc2mac_dat_src_data26;
input   [7:0] sc2mac_dat_src_data27;
input   [7:0] sc2mac_dat_src_data28;
input   [7:0] sc2mac_dat_src_data29;
input   [7:0] sc2mac_dat_src_data30;
input   [7:0] sc2mac_dat_src_data31;
input   [7:0] sc2mac_dat_src_data32;
input   [7:0] sc2mac_dat_src_data33;
input   [7:0] sc2mac_dat_src_data34;
input   [7:0] sc2mac_dat_src_data35;
input   [7:0] sc2mac_dat_src_data36;
input   [7:0] sc2mac_dat_src_data37;
input   [7:0] sc2mac_dat_src_data38;
input   [7:0] sc2mac_dat_src_data39;
input   [7:0] sc2mac_dat_src_data40;
input   [7:0] sc2mac_dat_src_data41;
input   [7:0] sc2mac_dat_src_data42;
input   [7:0] sc2mac_dat_src_data43;
input   [7:0] sc2mac_dat_src_data44;
input   [7:0] sc2mac_dat_src_data45;
input   [7:0] sc2mac_dat_src_data46;
input   [7:0] sc2mac_dat_src_data47;
input   [7:0] sc2mac_dat_src_data48;
input   [7:0] sc2mac_dat_src_data49;
input   [7:0] sc2mac_dat_src_data50;
input   [7:0] sc2mac_dat_src_data51;
input   [7:0] sc2mac_dat_src_data52;
input   [7:0] sc2mac_dat_src_data53;
input   [7:0] sc2mac_dat_src_data54;
input   [7:0] sc2mac_dat_src_data55;
input   [7:0] sc2mac_dat_src_data56;
input   [7:0] sc2mac_dat_src_data57;
input   [7:0] sc2mac_dat_src_data58;
input   [7:0] sc2mac_dat_src_data59;
input   [7:0] sc2mac_dat_src_data60;
input   [7:0] sc2mac_dat_src_data61;
input   [7:0] sc2mac_dat_src_data62;
input   [7:0] sc2mac_dat_src_data63;
input   [7:0] sc2mac_dat_src_data64;
input   [7:0] sc2mac_dat_src_data65;
input   [7:0] sc2mac_dat_src_data66;
input   [7:0] sc2mac_dat_src_data67;
input   [7:0] sc2mac_dat_src_data68;
input   [7:0] sc2mac_dat_src_data69;
input   [7:0] sc2mac_dat_src_data70;
input   [7:0] sc2mac_dat_src_data71;
input   [7:0] sc2mac_dat_src_data72;
input   [7:0] sc2mac_dat_src_data73;
input   [7:0] sc2mac_dat_src_data74;
input   [7:0] sc2mac_dat_src_data75;
input   [7:0] sc2mac_dat_src_data76;
input   [7:0] sc2mac_dat_src_data77;
input   [7:0] sc2mac_dat_src_data78;
input   [7:0] sc2mac_dat_src_data79;
input   [7:0] sc2mac_dat_src_data80;
input   [7:0] sc2mac_dat_src_data81;
input   [7:0] sc2mac_dat_src_data82;
input   [7:0] sc2mac_dat_src_data83;
input   [7:0] sc2mac_dat_src_data84;
input   [7:0] sc2mac_dat_src_data85;
input   [7:0] sc2mac_dat_src_data86;
input   [7:0] sc2mac_dat_src_data87;
input   [7:0] sc2mac_dat_src_data88;
input   [7:0] sc2mac_dat_src_data89;
input   [7:0] sc2mac_dat_src_data90;
input   [7:0] sc2mac_dat_src_data91;
input   [7:0] sc2mac_dat_src_data92;
input   [7:0] sc2mac_dat_src_data93;
input   [7:0] sc2mac_dat_src_data94;
input   [7:0] sc2mac_dat_src_data95;
input   [7:0] sc2mac_dat_src_data96;
input   [7:0] sc2mac_dat_src_data97;
input   [7:0] sc2mac_dat_src_data98;
input   [7:0] sc2mac_dat_src_data99;
input   [7:0] sc2mac_dat_src_data100;
input   [7:0] sc2mac_dat_src_data101;
input   [7:0] sc2mac_dat_src_data102;
input   [7:0] sc2mac_dat_src_data103;
input   [7:0] sc2mac_dat_src_data104;
input   [7:0] sc2mac_dat_src_data105;
input   [7:0] sc2mac_dat_src_data106;
input   [7:0] sc2mac_dat_src_data107;
input   [7:0] sc2mac_dat_src_data108;
input   [7:0] sc2mac_dat_src_data109;
input   [7:0] sc2mac_dat_src_data110;
input   [7:0] sc2mac_dat_src_data111;
input   [7:0] sc2mac_dat_src_data112;
input   [7:0] sc2mac_dat_src_data113;
input   [7:0] sc2mac_dat_src_data114;
input   [7:0] sc2mac_dat_src_data115;
input   [7:0] sc2mac_dat_src_data116;
input   [7:0] sc2mac_dat_src_data117;
input   [7:0] sc2mac_dat_src_data118;
input   [7:0] sc2mac_dat_src_data119;
input   [7:0] sc2mac_dat_src_data120;
input   [7:0] sc2mac_dat_src_data121;
input   [7:0] sc2mac_dat_src_data122;
input   [7:0] sc2mac_dat_src_data123;
input   [7:0] sc2mac_dat_src_data124;
input   [7:0] sc2mac_dat_src_data125;
input   [7:0] sc2mac_dat_src_data126;
input   [7:0] sc2mac_dat_src_data127;
input   [8:0] sc2mac_dat_src_pd;

output         sc2mac_wt_dst_pvld;     /* data valid */
output [127:0] sc2mac_wt_dst_mask;
output   [7:0] sc2mac_wt_dst_data0;
output   [7:0] sc2mac_wt_dst_data1;
output   [7:0] sc2mac_wt_dst_data2;
output   [7:0] sc2mac_wt_dst_data3;
output   [7:0] sc2mac_wt_dst_data4;
output   [7:0] sc2mac_wt_dst_data5;
output   [7:0] sc2mac_wt_dst_data6;
output   [7:0] sc2mac_wt_dst_data7;
output   [7:0] sc2mac_wt_dst_data8;
output   [7:0] sc2mac_wt_dst_data9;
output   [7:0] sc2mac_wt_dst_data10;
output   [7:0] sc2mac_wt_dst_data11;
output   [7:0] sc2mac_wt_dst_data12;
output   [7:0] sc2mac_wt_dst_data13;
output   [7:0] sc2mac_wt_dst_data14;
output   [7:0] sc2mac_wt_dst_data15;
output   [7:0] sc2mac_wt_dst_data16;
output   [7:0] sc2mac_wt_dst_data17;
output   [7:0] sc2mac_wt_dst_data18;
output   [7:0] sc2mac_wt_dst_data19;
output   [7:0] sc2mac_wt_dst_data20;
output   [7:0] sc2mac_wt_dst_data21;
output   [7:0] sc2mac_wt_dst_data22;
output   [7:0] sc2mac_wt_dst_data23;
output   [7:0] sc2mac_wt_dst_data24;
output   [7:0] sc2mac_wt_dst_data25;
output   [7:0] sc2mac_wt_dst_data26;
output   [7:0] sc2mac_wt_dst_data27;
output   [7:0] sc2mac_wt_dst_data28;
output   [7:0] sc2mac_wt_dst_data29;
output   [7:0] sc2mac_wt_dst_data30;
output   [7:0] sc2mac_wt_dst_data31;
output   [7:0] sc2mac_wt_dst_data32;
output   [7:0] sc2mac_wt_dst_data33;
output   [7:0] sc2mac_wt_dst_data34;
output   [7:0] sc2mac_wt_dst_data35;
output   [7:0] sc2mac_wt_dst_data36;
output   [7:0] sc2mac_wt_dst_data37;
output   [7:0] sc2mac_wt_dst_data38;
output   [7:0] sc2mac_wt_dst_data39;
output   [7:0] sc2mac_wt_dst_data40;
output   [7:0] sc2mac_wt_dst_data41;
output   [7:0] sc2mac_wt_dst_data42;
output   [7:0] sc2mac_wt_dst_data43;
output   [7:0] sc2mac_wt_dst_data44;
output   [7:0] sc2mac_wt_dst_data45;
output   [7:0] sc2mac_wt_dst_data46;
output   [7:0] sc2mac_wt_dst_data47;
output   [7:0] sc2mac_wt_dst_data48;
output   [7:0] sc2mac_wt_dst_data49;
output   [7:0] sc2mac_wt_dst_data50;
output   [7:0] sc2mac_wt_dst_data51;
output   [7:0] sc2mac_wt_dst_data52;
output   [7:0] sc2mac_wt_dst_data53;
output   [7:0] sc2mac_wt_dst_data54;
output   [7:0] sc2mac_wt_dst_data55;
output   [7:0] sc2mac_wt_dst_data56;
output   [7:0] sc2mac_wt_dst_data57;
output   [7:0] sc2mac_wt_dst_data58;
output   [7:0] sc2mac_wt_dst_data59;
output   [7:0] sc2mac_wt_dst_data60;
output   [7:0] sc2mac_wt_dst_data61;
output   [7:0] sc2mac_wt_dst_data62;
output   [7:0] sc2mac_wt_dst_data63;
output   [7:0] sc2mac_wt_dst_data64;
output   [7:0] sc2mac_wt_dst_data65;
output   [7:0] sc2mac_wt_dst_data66;
output   [7:0] sc2mac_wt_dst_data67;
output   [7:0] sc2mac_wt_dst_data68;
output   [7:0] sc2mac_wt_dst_data69;
output   [7:0] sc2mac_wt_dst_data70;
output   [7:0] sc2mac_wt_dst_data71;
output   [7:0] sc2mac_wt_dst_data72;
output   [7:0] sc2mac_wt_dst_data73;
output   [7:0] sc2mac_wt_dst_data74;
output   [7:0] sc2mac_wt_dst_data75;
output   [7:0] sc2mac_wt_dst_data76;
output   [7:0] sc2mac_wt_dst_data77;
output   [7:0] sc2mac_wt_dst_data78;
output   [7:0] sc2mac_wt_dst_data79;
output   [7:0] sc2mac_wt_dst_data80;
output   [7:0] sc2mac_wt_dst_data81;
output   [7:0] sc2mac_wt_dst_data82;
output   [7:0] sc2mac_wt_dst_data83;
output   [7:0] sc2mac_wt_dst_data84;
output   [7:0] sc2mac_wt_dst_data85;
output   [7:0] sc2mac_wt_dst_data86;
output   [7:0] sc2mac_wt_dst_data87;
output   [7:0] sc2mac_wt_dst_data88;
output   [7:0] sc2mac_wt_dst_data89;
output   [7:0] sc2mac_wt_dst_data90;
output   [7:0] sc2mac_wt_dst_data91;
output   [7:0] sc2mac_wt_dst_data92;
output   [7:0] sc2mac_wt_dst_data93;
output   [7:0] sc2mac_wt_dst_data94;
output   [7:0] sc2mac_wt_dst_data95;
output   [7:0] sc2mac_wt_dst_data96;
output   [7:0] sc2mac_wt_dst_data97;
output   [7:0] sc2mac_wt_dst_data98;
output   [7:0] sc2mac_wt_dst_data99;
output   [7:0] sc2mac_wt_dst_data100;
output   [7:0] sc2mac_wt_dst_data101;
output   [7:0] sc2mac_wt_dst_data102;
output   [7:0] sc2mac_wt_dst_data103;
output   [7:0] sc2mac_wt_dst_data104;
output   [7:0] sc2mac_wt_dst_data105;
output   [7:0] sc2mac_wt_dst_data106;
output   [7:0] sc2mac_wt_dst_data107;
output   [7:0] sc2mac_wt_dst_data108;
output   [7:0] sc2mac_wt_dst_data109;
output   [7:0] sc2mac_wt_dst_data110;
output   [7:0] sc2mac_wt_dst_data111;
output   [7:0] sc2mac_wt_dst_data112;
output   [7:0] sc2mac_wt_dst_data113;
output   [7:0] sc2mac_wt_dst_data114;
output   [7:0] sc2mac_wt_dst_data115;
output   [7:0] sc2mac_wt_dst_data116;
output   [7:0] sc2mac_wt_dst_data117;
output   [7:0] sc2mac_wt_dst_data118;
output   [7:0] sc2mac_wt_dst_data119;
output   [7:0] sc2mac_wt_dst_data120;
output   [7:0] sc2mac_wt_dst_data121;
output   [7:0] sc2mac_wt_dst_data122;
output   [7:0] sc2mac_wt_dst_data123;
output   [7:0] sc2mac_wt_dst_data124;
output   [7:0] sc2mac_wt_dst_data125;
output   [7:0] sc2mac_wt_dst_data126;
output   [7:0] sc2mac_wt_dst_data127;
output   [7:0] sc2mac_wt_dst_sel;

output         sc2mac_dat_dst_pvld;     /* data valid */
output [127:0] sc2mac_dat_dst_mask;
output   [7:0] sc2mac_dat_dst_data0;
output   [7:0] sc2mac_dat_dst_data1;
output   [7:0] sc2mac_dat_dst_data2;
output   [7:0] sc2mac_dat_dst_data3;
output   [7:0] sc2mac_dat_dst_data4;
output   [7:0] sc2mac_dat_dst_data5;
output   [7:0] sc2mac_dat_dst_data6;
output   [7:0] sc2mac_dat_dst_data7;
output   [7:0] sc2mac_dat_dst_data8;
output   [7:0] sc2mac_dat_dst_data9;
output   [7:0] sc2mac_dat_dst_data10;
output   [7:0] sc2mac_dat_dst_data11;
output   [7:0] sc2mac_dat_dst_data12;
output   [7:0] sc2mac_dat_dst_data13;
output   [7:0] sc2mac_dat_dst_data14;
output   [7:0] sc2mac_dat_dst_data15;
output   [7:0] sc2mac_dat_dst_data16;
output   [7:0] sc2mac_dat_dst_data17;
output   [7:0] sc2mac_dat_dst_data18;
output   [7:0] sc2mac_dat_dst_data19;
output   [7:0] sc2mac_dat_dst_data20;
output   [7:0] sc2mac_dat_dst_data21;
output   [7:0] sc2mac_dat_dst_data22;
output   [7:0] sc2mac_dat_dst_data23;
output   [7:0] sc2mac_dat_dst_data24;
output   [7:0] sc2mac_dat_dst_data25;
output   [7:0] sc2mac_dat_dst_data26;
output   [7:0] sc2mac_dat_dst_data27;
output   [7:0] sc2mac_dat_dst_data28;
output   [7:0] sc2mac_dat_dst_data29;
output   [7:0] sc2mac_dat_dst_data30;
output   [7:0] sc2mac_dat_dst_data31;
output   [7:0] sc2mac_dat_dst_data32;
output   [7:0] sc2mac_dat_dst_data33;
output   [7:0] sc2mac_dat_dst_data34;
output   [7:0] sc2mac_dat_dst_data35;
output   [7:0] sc2mac_dat_dst_data36;
output   [7:0] sc2mac_dat_dst_data37;
output   [7:0] sc2mac_dat_dst_data38;
output   [7:0] sc2mac_dat_dst_data39;
output   [7:0] sc2mac_dat_dst_data40;
output   [7:0] sc2mac_dat_dst_data41;
output   [7:0] sc2mac_dat_dst_data42;
output   [7:0] sc2mac_dat_dst_data43;
output   [7:0] sc2mac_dat_dst_data44;
output   [7:0] sc2mac_dat_dst_data45;
output   [7:0] sc2mac_dat_dst_data46;
output   [7:0] sc2mac_dat_dst_data47;
output   [7:0] sc2mac_dat_dst_data48;
output   [7:0] sc2mac_dat_dst_data49;
output   [7:0] sc2mac_dat_dst_data50;
output   [7:0] sc2mac_dat_dst_data51;
output   [7:0] sc2mac_dat_dst_data52;
output   [7:0] sc2mac_dat_dst_data53;
output   [7:0] sc2mac_dat_dst_data54;
output   [7:0] sc2mac_dat_dst_data55;
output   [7:0] sc2mac_dat_dst_data56;
output   [7:0] sc2mac_dat_dst_data57;
output   [7:0] sc2mac_dat_dst_data58;
output   [7:0] sc2mac_dat_dst_data59;
output   [7:0] sc2mac_dat_dst_data60;
output   [7:0] sc2mac_dat_dst_data61;
output   [7:0] sc2mac_dat_dst_data62;
output   [7:0] sc2mac_dat_dst_data63;
output   [7:0] sc2mac_dat_dst_data64;
output   [7:0] sc2mac_dat_dst_data65;
output   [7:0] sc2mac_dat_dst_data66;
output   [7:0] sc2mac_dat_dst_data67;
output   [7:0] sc2mac_dat_dst_data68;
output   [7:0] sc2mac_dat_dst_data69;
output   [7:0] sc2mac_dat_dst_data70;
output   [7:0] sc2mac_dat_dst_data71;
output   [7:0] sc2mac_dat_dst_data72;
output   [7:0] sc2mac_dat_dst_data73;
output   [7:0] sc2mac_dat_dst_data74;
output   [7:0] sc2mac_dat_dst_data75;
output   [7:0] sc2mac_dat_dst_data76;
output   [7:0] sc2mac_dat_dst_data77;
output   [7:0] sc2mac_dat_dst_data78;
output   [7:0] sc2mac_dat_dst_data79;
output   [7:0] sc2mac_dat_dst_data80;
output   [7:0] sc2mac_dat_dst_data81;
output   [7:0] sc2mac_dat_dst_data82;
output   [7:0] sc2mac_dat_dst_data83;
output   [7:0] sc2mac_dat_dst_data84;
output   [7:0] sc2mac_dat_dst_data85;
output   [7:0] sc2mac_dat_dst_data86;
output   [7:0] sc2mac_dat_dst_data87;
output   [7:0] sc2mac_dat_dst_data88;
output   [7:0] sc2mac_dat_dst_data89;
output   [7:0] sc2mac_dat_dst_data90;
output   [7:0] sc2mac_dat_dst_data91;
output   [7:0] sc2mac_dat_dst_data92;
output   [7:0] sc2mac_dat_dst_data93;
output   [7:0] sc2mac_dat_dst_data94;
output   [7:0] sc2mac_dat_dst_data95;
output   [7:0] sc2mac_dat_dst_data96;
output   [7:0] sc2mac_dat_dst_data97;
output   [7:0] sc2mac_dat_dst_data98;
output   [7:0] sc2mac_dat_dst_data99;
output   [7:0] sc2mac_dat_dst_data100;
output   [7:0] sc2mac_dat_dst_data101;
output   [7:0] sc2mac_dat_dst_data102;
output   [7:0] sc2mac_dat_dst_data103;
output   [7:0] sc2mac_dat_dst_data104;
output   [7:0] sc2mac_dat_dst_data105;
output   [7:0] sc2mac_dat_dst_data106;
output   [7:0] sc2mac_dat_dst_data107;
output   [7:0] sc2mac_dat_dst_data108;
output   [7:0] sc2mac_dat_dst_data109;
output   [7:0] sc2mac_dat_dst_data110;
output   [7:0] sc2mac_dat_dst_data111;
output   [7:0] sc2mac_dat_dst_data112;
output   [7:0] sc2mac_dat_dst_data113;
output   [7:0] sc2mac_dat_dst_data114;
output   [7:0] sc2mac_dat_dst_data115;
output   [7:0] sc2mac_dat_dst_data116;
output   [7:0] sc2mac_dat_dst_data117;
output   [7:0] sc2mac_dat_dst_data118;
output   [7:0] sc2mac_dat_dst_data119;
output   [7:0] sc2mac_dat_dst_data120;
output   [7:0] sc2mac_dat_dst_data121;
output   [7:0] sc2mac_dat_dst_data122;
output   [7:0] sc2mac_dat_dst_data123;
output   [7:0] sc2mac_dat_dst_data124;
output   [7:0] sc2mac_dat_dst_data125;
output   [7:0] sc2mac_dat_dst_data126;
output   [7:0] sc2mac_dat_dst_data127;
output   [8:0] sc2mac_dat_dst_pd;

wire   [7:0] sc2mac_dat_data0_d0;
wire   [7:0] sc2mac_dat_data100_d0;
wire   [7:0] sc2mac_dat_data101_d0;
wire   [7:0] sc2mac_dat_data102_d0;
wire   [7:0] sc2mac_dat_data103_d0;
wire   [7:0] sc2mac_dat_data104_d0;
wire   [7:0] sc2mac_dat_data105_d0;
wire   [7:0] sc2mac_dat_data106_d0;
wire   [7:0] sc2mac_dat_data107_d0;
wire   [7:0] sc2mac_dat_data108_d0;
wire   [7:0] sc2mac_dat_data109_d0;
wire   [7:0] sc2mac_dat_data10_d0;
wire   [7:0] sc2mac_dat_data110_d0;
wire   [7:0] sc2mac_dat_data111_d0;
wire   [7:0] sc2mac_dat_data112_d0;
wire   [7:0] sc2mac_dat_data113_d0;
wire   [7:0] sc2mac_dat_data114_d0;
wire   [7:0] sc2mac_dat_data115_d0;
wire   [7:0] sc2mac_dat_data116_d0;
wire   [7:0] sc2mac_dat_data117_d0;
wire   [7:0] sc2mac_dat_data118_d0;
wire   [7:0] sc2mac_dat_data119_d0;
wire   [7:0] sc2mac_dat_data11_d0;
wire   [7:0] sc2mac_dat_data120_d0;
wire   [7:0] sc2mac_dat_data121_d0;
wire   [7:0] sc2mac_dat_data122_d0;
wire   [7:0] sc2mac_dat_data123_d0;
wire   [7:0] sc2mac_dat_data124_d0;
wire   [7:0] sc2mac_dat_data125_d0;
wire   [7:0] sc2mac_dat_data126_d0;
wire   [7:0] sc2mac_dat_data127_d0;
wire   [7:0] sc2mac_dat_data12_d0;
wire   [7:0] sc2mac_dat_data13_d0;
wire   [7:0] sc2mac_dat_data14_d0;
wire   [7:0] sc2mac_dat_data15_d0;
wire   [7:0] sc2mac_dat_data16_d0;
wire   [7:0] sc2mac_dat_data17_d0;
wire   [7:0] sc2mac_dat_data18_d0;
wire   [7:0] sc2mac_dat_data19_d0;
wire   [7:0] sc2mac_dat_data1_d0;
wire   [7:0] sc2mac_dat_data20_d0;
wire   [7:0] sc2mac_dat_data21_d0;
wire   [7:0] sc2mac_dat_data22_d0;
wire   [7:0] sc2mac_dat_data23_d0;
wire   [7:0] sc2mac_dat_data24_d0;
wire   [7:0] sc2mac_dat_data25_d0;
wire   [7:0] sc2mac_dat_data26_d0;
wire   [7:0] sc2mac_dat_data27_d0;
wire   [7:0] sc2mac_dat_data28_d0;
wire   [7:0] sc2mac_dat_data29_d0;
wire   [7:0] sc2mac_dat_data2_d0;
wire   [7:0] sc2mac_dat_data30_d0;
wire   [7:0] sc2mac_dat_data31_d0;
wire   [7:0] sc2mac_dat_data32_d0;
wire   [7:0] sc2mac_dat_data33_d0;
wire   [7:0] sc2mac_dat_data34_d0;
wire   [7:0] sc2mac_dat_data35_d0;
wire   [7:0] sc2mac_dat_data36_d0;
wire   [7:0] sc2mac_dat_data37_d0;
wire   [7:0] sc2mac_dat_data38_d0;
wire   [7:0] sc2mac_dat_data39_d0;
wire   [7:0] sc2mac_dat_data3_d0;
wire   [7:0] sc2mac_dat_data40_d0;
wire   [7:0] sc2mac_dat_data41_d0;
wire   [7:0] sc2mac_dat_data42_d0;
wire   [7:0] sc2mac_dat_data43_d0;
wire   [7:0] sc2mac_dat_data44_d0;
wire   [7:0] sc2mac_dat_data45_d0;
wire   [7:0] sc2mac_dat_data46_d0;
wire   [7:0] sc2mac_dat_data47_d0;
wire   [7:0] sc2mac_dat_data48_d0;
wire   [7:0] sc2mac_dat_data49_d0;
wire   [7:0] sc2mac_dat_data4_d0;
wire   [7:0] sc2mac_dat_data50_d0;
wire   [7:0] sc2mac_dat_data51_d0;
wire   [7:0] sc2mac_dat_data52_d0;
wire   [7:0] sc2mac_dat_data53_d0;
wire   [7:0] sc2mac_dat_data54_d0;
wire   [7:0] sc2mac_dat_data55_d0;
wire   [7:0] sc2mac_dat_data56_d0;
wire   [7:0] sc2mac_dat_data57_d0;
wire   [7:0] sc2mac_dat_data58_d0;
wire   [7:0] sc2mac_dat_data59_d0;
wire   [7:0] sc2mac_dat_data5_d0;
wire   [7:0] sc2mac_dat_data60_d0;
wire   [7:0] sc2mac_dat_data61_d0;
wire   [7:0] sc2mac_dat_data62_d0;
wire   [7:0] sc2mac_dat_data63_d0;
wire   [7:0] sc2mac_dat_data64_d0;
wire   [7:0] sc2mac_dat_data65_d0;
wire   [7:0] sc2mac_dat_data66_d0;
wire   [7:0] sc2mac_dat_data67_d0;
wire   [7:0] sc2mac_dat_data68_d0;
wire   [7:0] sc2mac_dat_data69_d0;
wire   [7:0] sc2mac_dat_data6_d0;
wire   [7:0] sc2mac_dat_data70_d0;
wire   [7:0] sc2mac_dat_data71_d0;
wire   [7:0] sc2mac_dat_data72_d0;
wire   [7:0] sc2mac_dat_data73_d0;
wire   [7:0] sc2mac_dat_data74_d0;
wire   [7:0] sc2mac_dat_data75_d0;
wire   [7:0] sc2mac_dat_data76_d0;
wire   [7:0] sc2mac_dat_data77_d0;
wire   [7:0] sc2mac_dat_data78_d0;
wire   [7:0] sc2mac_dat_data79_d0;
wire   [7:0] sc2mac_dat_data7_d0;
wire   [7:0] sc2mac_dat_data80_d0;
wire   [7:0] sc2mac_dat_data81_d0;
wire   [7:0] sc2mac_dat_data82_d0;
wire   [7:0] sc2mac_dat_data83_d0;
wire   [7:0] sc2mac_dat_data84_d0;
wire   [7:0] sc2mac_dat_data85_d0;
wire   [7:0] sc2mac_dat_data86_d0;
wire   [7:0] sc2mac_dat_data87_d0;
wire   [7:0] sc2mac_dat_data88_d0;
wire   [7:0] sc2mac_dat_data89_d0;
wire   [7:0] sc2mac_dat_data8_d0;
wire   [7:0] sc2mac_dat_data90_d0;
wire   [7:0] sc2mac_dat_data91_d0;
wire   [7:0] sc2mac_dat_data92_d0;
wire   [7:0] sc2mac_dat_data93_d0;
wire   [7:0] sc2mac_dat_data94_d0;
wire   [7:0] sc2mac_dat_data95_d0;
wire   [7:0] sc2mac_dat_data96_d0;
wire   [7:0] sc2mac_dat_data97_d0;
wire   [7:0] sc2mac_dat_data98_d0;
wire   [7:0] sc2mac_dat_data99_d0;
wire   [7:0] sc2mac_dat_data9_d0;
wire [127:0] sc2mac_dat_mask_d0;
wire   [8:0] sc2mac_dat_pd_d0;
wire         sc2mac_dat_pvld_d0;
wire   [7:0] sc2mac_wt_data0_d0;
wire   [7:0] sc2mac_wt_data100_d0;
wire   [7:0] sc2mac_wt_data101_d0;
wire   [7:0] sc2mac_wt_data102_d0;
wire   [7:0] sc2mac_wt_data103_d0;
wire   [7:0] sc2mac_wt_data104_d0;
wire   [7:0] sc2mac_wt_data105_d0;
wire   [7:0] sc2mac_wt_data106_d0;
wire   [7:0] sc2mac_wt_data107_d0;
wire   [7:0] sc2mac_wt_data108_d0;
wire   [7:0] sc2mac_wt_data109_d0;
wire   [7:0] sc2mac_wt_data10_d0;
wire   [7:0] sc2mac_wt_data110_d0;
wire   [7:0] sc2mac_wt_data111_d0;
wire   [7:0] sc2mac_wt_data112_d0;
wire   [7:0] sc2mac_wt_data113_d0;
wire   [7:0] sc2mac_wt_data114_d0;
wire   [7:0] sc2mac_wt_data115_d0;
wire   [7:0] sc2mac_wt_data116_d0;
wire   [7:0] sc2mac_wt_data117_d0;
wire   [7:0] sc2mac_wt_data118_d0;
wire   [7:0] sc2mac_wt_data119_d0;
wire   [7:0] sc2mac_wt_data11_d0;
wire   [7:0] sc2mac_wt_data120_d0;
wire   [7:0] sc2mac_wt_data121_d0;
wire   [7:0] sc2mac_wt_data122_d0;
wire   [7:0] sc2mac_wt_data123_d0;
wire   [7:0] sc2mac_wt_data124_d0;
wire   [7:0] sc2mac_wt_data125_d0;
wire   [7:0] sc2mac_wt_data126_d0;
wire   [7:0] sc2mac_wt_data127_d0;
wire   [7:0] sc2mac_wt_data12_d0;
wire   [7:0] sc2mac_wt_data13_d0;
wire   [7:0] sc2mac_wt_data14_d0;
wire   [7:0] sc2mac_wt_data15_d0;
wire   [7:0] sc2mac_wt_data16_d0;
wire   [7:0] sc2mac_wt_data17_d0;
wire   [7:0] sc2mac_wt_data18_d0;
wire   [7:0] sc2mac_wt_data19_d0;
wire   [7:0] sc2mac_wt_data1_d0;
wire   [7:0] sc2mac_wt_data20_d0;
wire   [7:0] sc2mac_wt_data21_d0;
wire   [7:0] sc2mac_wt_data22_d0;
wire   [7:0] sc2mac_wt_data23_d0;
wire   [7:0] sc2mac_wt_data24_d0;
wire   [7:0] sc2mac_wt_data25_d0;
wire   [7:0] sc2mac_wt_data26_d0;
wire   [7:0] sc2mac_wt_data27_d0;
wire   [7:0] sc2mac_wt_data28_d0;
wire   [7:0] sc2mac_wt_data29_d0;
wire   [7:0] sc2mac_wt_data2_d0;
wire   [7:0] sc2mac_wt_data30_d0;
wire   [7:0] sc2mac_wt_data31_d0;
wire   [7:0] sc2mac_wt_data32_d0;
wire   [7:0] sc2mac_wt_data33_d0;
wire   [7:0] sc2mac_wt_data34_d0;
wire   [7:0] sc2mac_wt_data35_d0;
wire   [7:0] sc2mac_wt_data36_d0;
wire   [7:0] sc2mac_wt_data37_d0;
wire   [7:0] sc2mac_wt_data38_d0;
wire   [7:0] sc2mac_wt_data39_d0;
wire   [7:0] sc2mac_wt_data3_d0;
wire   [7:0] sc2mac_wt_data40_d0;
wire   [7:0] sc2mac_wt_data41_d0;
wire   [7:0] sc2mac_wt_data42_d0;
wire   [7:0] sc2mac_wt_data43_d0;
wire   [7:0] sc2mac_wt_data44_d0;
wire   [7:0] sc2mac_wt_data45_d0;
wire   [7:0] sc2mac_wt_data46_d0;
wire   [7:0] sc2mac_wt_data47_d0;
wire   [7:0] sc2mac_wt_data48_d0;
wire   [7:0] sc2mac_wt_data49_d0;
wire   [7:0] sc2mac_wt_data4_d0;
wire   [7:0] sc2mac_wt_data50_d0;
wire   [7:0] sc2mac_wt_data51_d0;
wire   [7:0] sc2mac_wt_data52_d0;
wire   [7:0] sc2mac_wt_data53_d0;
wire   [7:0] sc2mac_wt_data54_d0;
wire   [7:0] sc2mac_wt_data55_d0;
wire   [7:0] sc2mac_wt_data56_d0;
wire   [7:0] sc2mac_wt_data57_d0;
wire   [7:0] sc2mac_wt_data58_d0;
wire   [7:0] sc2mac_wt_data59_d0;
wire   [7:0] sc2mac_wt_data5_d0;
wire   [7:0] sc2mac_wt_data60_d0;
wire   [7:0] sc2mac_wt_data61_d0;
wire   [7:0] sc2mac_wt_data62_d0;
wire   [7:0] sc2mac_wt_data63_d0;
wire   [7:0] sc2mac_wt_data64_d0;
wire   [7:0] sc2mac_wt_data65_d0;
wire   [7:0] sc2mac_wt_data66_d0;
wire   [7:0] sc2mac_wt_data67_d0;
wire   [7:0] sc2mac_wt_data68_d0;
wire   [7:0] sc2mac_wt_data69_d0;
wire   [7:0] sc2mac_wt_data6_d0;
wire   [7:0] sc2mac_wt_data70_d0;
wire   [7:0] sc2mac_wt_data71_d0;
wire   [7:0] sc2mac_wt_data72_d0;
wire   [7:0] sc2mac_wt_data73_d0;
wire   [7:0] sc2mac_wt_data74_d0;
wire   [7:0] sc2mac_wt_data75_d0;
wire   [7:0] sc2mac_wt_data76_d0;
wire   [7:0] sc2mac_wt_data77_d0;
wire   [7:0] sc2mac_wt_data78_d0;
wire   [7:0] sc2mac_wt_data79_d0;
wire   [7:0] sc2mac_wt_data7_d0;
wire   [7:0] sc2mac_wt_data80_d0;
wire   [7:0] sc2mac_wt_data81_d0;
wire   [7:0] sc2mac_wt_data82_d0;
wire   [7:0] sc2mac_wt_data83_d0;
wire   [7:0] sc2mac_wt_data84_d0;
wire   [7:0] sc2mac_wt_data85_d0;
wire   [7:0] sc2mac_wt_data86_d0;
wire   [7:0] sc2mac_wt_data87_d0;
wire   [7:0] sc2mac_wt_data88_d0;
wire   [7:0] sc2mac_wt_data89_d0;
wire   [7:0] sc2mac_wt_data8_d0;
wire   [7:0] sc2mac_wt_data90_d0;
wire   [7:0] sc2mac_wt_data91_d0;
wire   [7:0] sc2mac_wt_data92_d0;
wire   [7:0] sc2mac_wt_data93_d0;
wire   [7:0] sc2mac_wt_data94_d0;
wire   [7:0] sc2mac_wt_data95_d0;
wire   [7:0] sc2mac_wt_data96_d0;
wire   [7:0] sc2mac_wt_data97_d0;
wire   [7:0] sc2mac_wt_data98_d0;
wire   [7:0] sc2mac_wt_data99_d0;
wire   [7:0] sc2mac_wt_data9_d0;
wire [127:0] sc2mac_wt_mask_d0;
wire         sc2mac_wt_pvld_d0;
wire   [7:0] sc2mac_wt_sel_d0;
reg    [7:0] sc2mac_dat_data0_d1;
reg    [7:0] sc2mac_dat_data0_d2;
reg    [7:0] sc2mac_dat_data100_d1;
reg    [7:0] sc2mac_dat_data100_d2;
reg    [7:0] sc2mac_dat_data101_d1;
reg    [7:0] sc2mac_dat_data101_d2;
reg    [7:0] sc2mac_dat_data102_d1;
reg    [7:0] sc2mac_dat_data102_d2;
reg    [7:0] sc2mac_dat_data103_d1;
reg    [7:0] sc2mac_dat_data103_d2;
reg    [7:0] sc2mac_dat_data104_d1;
reg    [7:0] sc2mac_dat_data104_d2;
reg    [7:0] sc2mac_dat_data105_d1;
reg    [7:0] sc2mac_dat_data105_d2;
reg    [7:0] sc2mac_dat_data106_d1;
reg    [7:0] sc2mac_dat_data106_d2;
reg    [7:0] sc2mac_dat_data107_d1;
reg    [7:0] sc2mac_dat_data107_d2;
reg    [7:0] sc2mac_dat_data108_d1;
reg    [7:0] sc2mac_dat_data108_d2;
reg    [7:0] sc2mac_dat_data109_d1;
reg    [7:0] sc2mac_dat_data109_d2;
reg    [7:0] sc2mac_dat_data10_d1;
reg    [7:0] sc2mac_dat_data10_d2;
reg    [7:0] sc2mac_dat_data110_d1;
reg    [7:0] sc2mac_dat_data110_d2;
reg    [7:0] sc2mac_dat_data111_d1;
reg    [7:0] sc2mac_dat_data111_d2;
reg    [7:0] sc2mac_dat_data112_d1;
reg    [7:0] sc2mac_dat_data112_d2;
reg    [7:0] sc2mac_dat_data113_d1;
reg    [7:0] sc2mac_dat_data113_d2;
reg    [7:0] sc2mac_dat_data114_d1;
reg    [7:0] sc2mac_dat_data114_d2;
reg    [7:0] sc2mac_dat_data115_d1;
reg    [7:0] sc2mac_dat_data115_d2;
reg    [7:0] sc2mac_dat_data116_d1;
reg    [7:0] sc2mac_dat_data116_d2;
reg    [7:0] sc2mac_dat_data117_d1;
reg    [7:0] sc2mac_dat_data117_d2;
reg    [7:0] sc2mac_dat_data118_d1;
reg    [7:0] sc2mac_dat_data118_d2;
reg    [7:0] sc2mac_dat_data119_d1;
reg    [7:0] sc2mac_dat_data119_d2;
reg    [7:0] sc2mac_dat_data11_d1;
reg    [7:0] sc2mac_dat_data11_d2;
reg    [7:0] sc2mac_dat_data120_d1;
reg    [7:0] sc2mac_dat_data120_d2;
reg    [7:0] sc2mac_dat_data121_d1;
reg    [7:0] sc2mac_dat_data121_d2;
reg    [7:0] sc2mac_dat_data122_d1;
reg    [7:0] sc2mac_dat_data122_d2;
reg    [7:0] sc2mac_dat_data123_d1;
reg    [7:0] sc2mac_dat_data123_d2;
reg    [7:0] sc2mac_dat_data124_d1;
reg    [7:0] sc2mac_dat_data124_d2;
reg    [7:0] sc2mac_dat_data125_d1;
reg    [7:0] sc2mac_dat_data125_d2;
reg    [7:0] sc2mac_dat_data126_d1;
reg    [7:0] sc2mac_dat_data126_d2;
reg    [7:0] sc2mac_dat_data127_d1;
reg    [7:0] sc2mac_dat_data127_d2;
reg    [7:0] sc2mac_dat_data12_d1;
reg    [7:0] sc2mac_dat_data12_d2;
reg    [7:0] sc2mac_dat_data13_d1;
reg    [7:0] sc2mac_dat_data13_d2;
reg    [7:0] sc2mac_dat_data14_d1;
reg    [7:0] sc2mac_dat_data14_d2;
reg    [7:0] sc2mac_dat_data15_d1;
reg    [7:0] sc2mac_dat_data15_d2;
reg    [7:0] sc2mac_dat_data16_d1;
reg    [7:0] sc2mac_dat_data16_d2;
reg    [7:0] sc2mac_dat_data17_d1;
reg    [7:0] sc2mac_dat_data17_d2;
reg    [7:0] sc2mac_dat_data18_d1;
reg    [7:0] sc2mac_dat_data18_d2;
reg    [7:0] sc2mac_dat_data19_d1;
reg    [7:0] sc2mac_dat_data19_d2;
reg    [7:0] sc2mac_dat_data1_d1;
reg    [7:0] sc2mac_dat_data1_d2;
reg    [7:0] sc2mac_dat_data20_d1;
reg    [7:0] sc2mac_dat_data20_d2;
reg    [7:0] sc2mac_dat_data21_d1;
reg    [7:0] sc2mac_dat_data21_d2;
reg    [7:0] sc2mac_dat_data22_d1;
reg    [7:0] sc2mac_dat_data22_d2;
reg    [7:0] sc2mac_dat_data23_d1;
reg    [7:0] sc2mac_dat_data23_d2;
reg    [7:0] sc2mac_dat_data24_d1;
reg    [7:0] sc2mac_dat_data24_d2;
reg    [7:0] sc2mac_dat_data25_d1;
reg    [7:0] sc2mac_dat_data25_d2;
reg    [7:0] sc2mac_dat_data26_d1;
reg    [7:0] sc2mac_dat_data26_d2;
reg    [7:0] sc2mac_dat_data27_d1;
reg    [7:0] sc2mac_dat_data27_d2;
reg    [7:0] sc2mac_dat_data28_d1;
reg    [7:0] sc2mac_dat_data28_d2;
reg    [7:0] sc2mac_dat_data29_d1;
reg    [7:0] sc2mac_dat_data29_d2;
reg    [7:0] sc2mac_dat_data2_d1;
reg    [7:0] sc2mac_dat_data2_d2;
reg    [7:0] sc2mac_dat_data30_d1;
reg    [7:0] sc2mac_dat_data30_d2;
reg    [7:0] sc2mac_dat_data31_d1;
reg    [7:0] sc2mac_dat_data31_d2;
reg    [7:0] sc2mac_dat_data32_d1;
reg    [7:0] sc2mac_dat_data32_d2;
reg    [7:0] sc2mac_dat_data33_d1;
reg    [7:0] sc2mac_dat_data33_d2;
reg    [7:0] sc2mac_dat_data34_d1;
reg    [7:0] sc2mac_dat_data34_d2;
reg    [7:0] sc2mac_dat_data35_d1;
reg    [7:0] sc2mac_dat_data35_d2;
reg    [7:0] sc2mac_dat_data36_d1;
reg    [7:0] sc2mac_dat_data36_d2;
reg    [7:0] sc2mac_dat_data37_d1;
reg    [7:0] sc2mac_dat_data37_d2;
reg    [7:0] sc2mac_dat_data38_d1;
reg    [7:0] sc2mac_dat_data38_d2;
reg    [7:0] sc2mac_dat_data39_d1;
reg    [7:0] sc2mac_dat_data39_d2;
reg    [7:0] sc2mac_dat_data3_d1;
reg    [7:0] sc2mac_dat_data3_d2;
reg    [7:0] sc2mac_dat_data40_d1;
reg    [7:0] sc2mac_dat_data40_d2;
reg    [7:0] sc2mac_dat_data41_d1;
reg    [7:0] sc2mac_dat_data41_d2;
reg    [7:0] sc2mac_dat_data42_d1;
reg    [7:0] sc2mac_dat_data42_d2;
reg    [7:0] sc2mac_dat_data43_d1;
reg    [7:0] sc2mac_dat_data43_d2;
reg    [7:0] sc2mac_dat_data44_d1;
reg    [7:0] sc2mac_dat_data44_d2;
reg    [7:0] sc2mac_dat_data45_d1;
reg    [7:0] sc2mac_dat_data45_d2;
reg    [7:0] sc2mac_dat_data46_d1;
reg    [7:0] sc2mac_dat_data46_d2;
reg    [7:0] sc2mac_dat_data47_d1;
reg    [7:0] sc2mac_dat_data47_d2;
reg    [7:0] sc2mac_dat_data48_d1;
reg    [7:0] sc2mac_dat_data48_d2;
reg    [7:0] sc2mac_dat_data49_d1;
reg    [7:0] sc2mac_dat_data49_d2;
reg    [7:0] sc2mac_dat_data4_d1;
reg    [7:0] sc2mac_dat_data4_d2;
reg    [7:0] sc2mac_dat_data50_d1;
reg    [7:0] sc2mac_dat_data50_d2;
reg    [7:0] sc2mac_dat_data51_d1;
reg    [7:0] sc2mac_dat_data51_d2;
reg    [7:0] sc2mac_dat_data52_d1;
reg    [7:0] sc2mac_dat_data52_d2;
reg    [7:0] sc2mac_dat_data53_d1;
reg    [7:0] sc2mac_dat_data53_d2;
reg    [7:0] sc2mac_dat_data54_d1;
reg    [7:0] sc2mac_dat_data54_d2;
reg    [7:0] sc2mac_dat_data55_d1;
reg    [7:0] sc2mac_dat_data55_d2;
reg    [7:0] sc2mac_dat_data56_d1;
reg    [7:0] sc2mac_dat_data56_d2;
reg    [7:0] sc2mac_dat_data57_d1;
reg    [7:0] sc2mac_dat_data57_d2;
reg    [7:0] sc2mac_dat_data58_d1;
reg    [7:0] sc2mac_dat_data58_d2;
reg    [7:0] sc2mac_dat_data59_d1;
reg    [7:0] sc2mac_dat_data59_d2;
reg    [7:0] sc2mac_dat_data5_d1;
reg    [7:0] sc2mac_dat_data5_d2;
reg    [7:0] sc2mac_dat_data60_d1;
reg    [7:0] sc2mac_dat_data60_d2;
reg    [7:0] sc2mac_dat_data61_d1;
reg    [7:0] sc2mac_dat_data61_d2;
reg    [7:0] sc2mac_dat_data62_d1;
reg    [7:0] sc2mac_dat_data62_d2;
reg    [7:0] sc2mac_dat_data63_d1;
reg    [7:0] sc2mac_dat_data63_d2;
reg    [7:0] sc2mac_dat_data64_d1;
reg    [7:0] sc2mac_dat_data64_d2;
reg    [7:0] sc2mac_dat_data65_d1;
reg    [7:0] sc2mac_dat_data65_d2;
reg    [7:0] sc2mac_dat_data66_d1;
reg    [7:0] sc2mac_dat_data66_d2;
reg    [7:0] sc2mac_dat_data67_d1;
reg    [7:0] sc2mac_dat_data67_d2;
reg    [7:0] sc2mac_dat_data68_d1;
reg    [7:0] sc2mac_dat_data68_d2;
reg    [7:0] sc2mac_dat_data69_d1;
reg    [7:0] sc2mac_dat_data69_d2;
reg    [7:0] sc2mac_dat_data6_d1;
reg    [7:0] sc2mac_dat_data6_d2;
reg    [7:0] sc2mac_dat_data70_d1;
reg    [7:0] sc2mac_dat_data70_d2;
reg    [7:0] sc2mac_dat_data71_d1;
reg    [7:0] sc2mac_dat_data71_d2;
reg    [7:0] sc2mac_dat_data72_d1;
reg    [7:0] sc2mac_dat_data72_d2;
reg    [7:0] sc2mac_dat_data73_d1;
reg    [7:0] sc2mac_dat_data73_d2;
reg    [7:0] sc2mac_dat_data74_d1;
reg    [7:0] sc2mac_dat_data74_d2;
reg    [7:0] sc2mac_dat_data75_d1;
reg    [7:0] sc2mac_dat_data75_d2;
reg    [7:0] sc2mac_dat_data76_d1;
reg    [7:0] sc2mac_dat_data76_d2;
reg    [7:0] sc2mac_dat_data77_d1;
reg    [7:0] sc2mac_dat_data77_d2;
reg    [7:0] sc2mac_dat_data78_d1;
reg    [7:0] sc2mac_dat_data78_d2;
reg    [7:0] sc2mac_dat_data79_d1;
reg    [7:0] sc2mac_dat_data79_d2;
reg    [7:0] sc2mac_dat_data7_d1;
reg    [7:0] sc2mac_dat_data7_d2;
reg    [7:0] sc2mac_dat_data80_d1;
reg    [7:0] sc2mac_dat_data80_d2;
reg    [7:0] sc2mac_dat_data81_d1;
reg    [7:0] sc2mac_dat_data81_d2;
reg    [7:0] sc2mac_dat_data82_d1;
reg    [7:0] sc2mac_dat_data82_d2;
reg    [7:0] sc2mac_dat_data83_d1;
reg    [7:0] sc2mac_dat_data83_d2;
reg    [7:0] sc2mac_dat_data84_d1;
reg    [7:0] sc2mac_dat_data84_d2;
reg    [7:0] sc2mac_dat_data85_d1;
reg    [7:0] sc2mac_dat_data85_d2;
reg    [7:0] sc2mac_dat_data86_d1;
reg    [7:0] sc2mac_dat_data86_d2;
reg    [7:0] sc2mac_dat_data87_d1;
reg    [7:0] sc2mac_dat_data87_d2;
reg    [7:0] sc2mac_dat_data88_d1;
reg    [7:0] sc2mac_dat_data88_d2;
reg    [7:0] sc2mac_dat_data89_d1;
reg    [7:0] sc2mac_dat_data89_d2;
reg    [7:0] sc2mac_dat_data8_d1;
reg    [7:0] sc2mac_dat_data8_d2;
reg    [7:0] sc2mac_dat_data90_d1;
reg    [7:0] sc2mac_dat_data90_d2;
reg    [7:0] sc2mac_dat_data91_d1;
reg    [7:0] sc2mac_dat_data91_d2;
reg    [7:0] sc2mac_dat_data92_d1;
reg    [7:0] sc2mac_dat_data92_d2;
reg    [7:0] sc2mac_dat_data93_d1;
reg    [7:0] sc2mac_dat_data93_d2;
reg    [7:0] sc2mac_dat_data94_d1;
reg    [7:0] sc2mac_dat_data94_d2;
reg    [7:0] sc2mac_dat_data95_d1;
reg    [7:0] sc2mac_dat_data95_d2;
reg    [7:0] sc2mac_dat_data96_d1;
reg    [7:0] sc2mac_dat_data96_d2;
reg    [7:0] sc2mac_dat_data97_d1;
reg    [7:0] sc2mac_dat_data97_d2;
reg    [7:0] sc2mac_dat_data98_d1;
reg    [7:0] sc2mac_dat_data98_d2;
reg    [7:0] sc2mac_dat_data99_d1;
reg    [7:0] sc2mac_dat_data99_d2;
reg    [7:0] sc2mac_dat_data9_d1;
reg    [7:0] sc2mac_dat_data9_d2;
reg  [127:0] sc2mac_dat_mask_d1;
reg  [127:0] sc2mac_dat_mask_d2;
reg    [8:0] sc2mac_dat_pd_d1;
reg    [8:0] sc2mac_dat_pd_d2;
reg          sc2mac_dat_pvld_d1;
reg          sc2mac_dat_pvld_d2;
reg    [7:0] sc2mac_wt_data0_d1;
reg    [7:0] sc2mac_wt_data0_d2;
reg    [7:0] sc2mac_wt_data100_d1;
reg    [7:0] sc2mac_wt_data100_d2;
reg    [7:0] sc2mac_wt_data101_d1;
reg    [7:0] sc2mac_wt_data101_d2;
reg    [7:0] sc2mac_wt_data102_d1;
reg    [7:0] sc2mac_wt_data102_d2;
reg    [7:0] sc2mac_wt_data103_d1;
reg    [7:0] sc2mac_wt_data103_d2;
reg    [7:0] sc2mac_wt_data104_d1;
reg    [7:0] sc2mac_wt_data104_d2;
reg    [7:0] sc2mac_wt_data105_d1;
reg    [7:0] sc2mac_wt_data105_d2;
reg    [7:0] sc2mac_wt_data106_d1;
reg    [7:0] sc2mac_wt_data106_d2;
reg    [7:0] sc2mac_wt_data107_d1;
reg    [7:0] sc2mac_wt_data107_d2;
reg    [7:0] sc2mac_wt_data108_d1;
reg    [7:0] sc2mac_wt_data108_d2;
reg    [7:0] sc2mac_wt_data109_d1;
reg    [7:0] sc2mac_wt_data109_d2;
reg    [7:0] sc2mac_wt_data10_d1;
reg    [7:0] sc2mac_wt_data10_d2;
reg    [7:0] sc2mac_wt_data110_d1;
reg    [7:0] sc2mac_wt_data110_d2;
reg    [7:0] sc2mac_wt_data111_d1;
reg    [7:0] sc2mac_wt_data111_d2;
reg    [7:0] sc2mac_wt_data112_d1;
reg    [7:0] sc2mac_wt_data112_d2;
reg    [7:0] sc2mac_wt_data113_d1;
reg    [7:0] sc2mac_wt_data113_d2;
reg    [7:0] sc2mac_wt_data114_d1;
reg    [7:0] sc2mac_wt_data114_d2;
reg    [7:0] sc2mac_wt_data115_d1;
reg    [7:0] sc2mac_wt_data115_d2;
reg    [7:0] sc2mac_wt_data116_d1;
reg    [7:0] sc2mac_wt_data116_d2;
reg    [7:0] sc2mac_wt_data117_d1;
reg    [7:0] sc2mac_wt_data117_d2;
reg    [7:0] sc2mac_wt_data118_d1;
reg    [7:0] sc2mac_wt_data118_d2;
reg    [7:0] sc2mac_wt_data119_d1;
reg    [7:0] sc2mac_wt_data119_d2;
reg    [7:0] sc2mac_wt_data11_d1;
reg    [7:0] sc2mac_wt_data11_d2;
reg    [7:0] sc2mac_wt_data120_d1;
reg    [7:0] sc2mac_wt_data120_d2;
reg    [7:0] sc2mac_wt_data121_d1;
reg    [7:0] sc2mac_wt_data121_d2;
reg    [7:0] sc2mac_wt_data122_d1;
reg    [7:0] sc2mac_wt_data122_d2;
reg    [7:0] sc2mac_wt_data123_d1;
reg    [7:0] sc2mac_wt_data123_d2;
reg    [7:0] sc2mac_wt_data124_d1;
reg    [7:0] sc2mac_wt_data124_d2;
reg    [7:0] sc2mac_wt_data125_d1;
reg    [7:0] sc2mac_wt_data125_d2;
reg    [7:0] sc2mac_wt_data126_d1;
reg    [7:0] sc2mac_wt_data126_d2;
reg    [7:0] sc2mac_wt_data127_d1;
reg    [7:0] sc2mac_wt_data127_d2;
reg    [7:0] sc2mac_wt_data12_d1;
reg    [7:0] sc2mac_wt_data12_d2;
reg    [7:0] sc2mac_wt_data13_d1;
reg    [7:0] sc2mac_wt_data13_d2;
reg    [7:0] sc2mac_wt_data14_d1;
reg    [7:0] sc2mac_wt_data14_d2;
reg    [7:0] sc2mac_wt_data15_d1;
reg    [7:0] sc2mac_wt_data15_d2;
reg    [7:0] sc2mac_wt_data16_d1;
reg    [7:0] sc2mac_wt_data16_d2;
reg    [7:0] sc2mac_wt_data17_d1;
reg    [7:0] sc2mac_wt_data17_d2;
reg    [7:0] sc2mac_wt_data18_d1;
reg    [7:0] sc2mac_wt_data18_d2;
reg    [7:0] sc2mac_wt_data19_d1;
reg    [7:0] sc2mac_wt_data19_d2;
reg    [7:0] sc2mac_wt_data1_d1;
reg    [7:0] sc2mac_wt_data1_d2;
reg    [7:0] sc2mac_wt_data20_d1;
reg    [7:0] sc2mac_wt_data20_d2;
reg    [7:0] sc2mac_wt_data21_d1;
reg    [7:0] sc2mac_wt_data21_d2;
reg    [7:0] sc2mac_wt_data22_d1;
reg    [7:0] sc2mac_wt_data22_d2;
reg    [7:0] sc2mac_wt_data23_d1;
reg    [7:0] sc2mac_wt_data23_d2;
reg    [7:0] sc2mac_wt_data24_d1;
reg    [7:0] sc2mac_wt_data24_d2;
reg    [7:0] sc2mac_wt_data25_d1;
reg    [7:0] sc2mac_wt_data25_d2;
reg    [7:0] sc2mac_wt_data26_d1;
reg    [7:0] sc2mac_wt_data26_d2;
reg    [7:0] sc2mac_wt_data27_d1;
reg    [7:0] sc2mac_wt_data27_d2;
reg    [7:0] sc2mac_wt_data28_d1;
reg    [7:0] sc2mac_wt_data28_d2;
reg    [7:0] sc2mac_wt_data29_d1;
reg    [7:0] sc2mac_wt_data29_d2;
reg    [7:0] sc2mac_wt_data2_d1;
reg    [7:0] sc2mac_wt_data2_d2;
reg    [7:0] sc2mac_wt_data30_d1;
reg    [7:0] sc2mac_wt_data30_d2;
reg    [7:0] sc2mac_wt_data31_d1;
reg    [7:0] sc2mac_wt_data31_d2;
reg    [7:0] sc2mac_wt_data32_d1;
reg    [7:0] sc2mac_wt_data32_d2;
reg    [7:0] sc2mac_wt_data33_d1;
reg    [7:0] sc2mac_wt_data33_d2;
reg    [7:0] sc2mac_wt_data34_d1;
reg    [7:0] sc2mac_wt_data34_d2;
reg    [7:0] sc2mac_wt_data35_d1;
reg    [7:0] sc2mac_wt_data35_d2;
reg    [7:0] sc2mac_wt_data36_d1;
reg    [7:0] sc2mac_wt_data36_d2;
reg    [7:0] sc2mac_wt_data37_d1;
reg    [7:0] sc2mac_wt_data37_d2;
reg    [7:0] sc2mac_wt_data38_d1;
reg    [7:0] sc2mac_wt_data38_d2;
reg    [7:0] sc2mac_wt_data39_d1;
reg    [7:0] sc2mac_wt_data39_d2;
reg    [7:0] sc2mac_wt_data3_d1;
reg    [7:0] sc2mac_wt_data3_d2;
reg    [7:0] sc2mac_wt_data40_d1;
reg    [7:0] sc2mac_wt_data40_d2;
reg    [7:0] sc2mac_wt_data41_d1;
reg    [7:0] sc2mac_wt_data41_d2;
reg    [7:0] sc2mac_wt_data42_d1;
reg    [7:0] sc2mac_wt_data42_d2;
reg    [7:0] sc2mac_wt_data43_d1;
reg    [7:0] sc2mac_wt_data43_d2;
reg    [7:0] sc2mac_wt_data44_d1;
reg    [7:0] sc2mac_wt_data44_d2;
reg    [7:0] sc2mac_wt_data45_d1;
reg    [7:0] sc2mac_wt_data45_d2;
reg    [7:0] sc2mac_wt_data46_d1;
reg    [7:0] sc2mac_wt_data46_d2;
reg    [7:0] sc2mac_wt_data47_d1;
reg    [7:0] sc2mac_wt_data47_d2;
reg    [7:0] sc2mac_wt_data48_d1;
reg    [7:0] sc2mac_wt_data48_d2;
reg    [7:0] sc2mac_wt_data49_d1;
reg    [7:0] sc2mac_wt_data49_d2;
reg    [7:0] sc2mac_wt_data4_d1;
reg    [7:0] sc2mac_wt_data4_d2;
reg    [7:0] sc2mac_wt_data50_d1;
reg    [7:0] sc2mac_wt_data50_d2;
reg    [7:0] sc2mac_wt_data51_d1;
reg    [7:0] sc2mac_wt_data51_d2;
reg    [7:0] sc2mac_wt_data52_d1;
reg    [7:0] sc2mac_wt_data52_d2;
reg    [7:0] sc2mac_wt_data53_d1;
reg    [7:0] sc2mac_wt_data53_d2;
reg    [7:0] sc2mac_wt_data54_d1;
reg    [7:0] sc2mac_wt_data54_d2;
reg    [7:0] sc2mac_wt_data55_d1;
reg    [7:0] sc2mac_wt_data55_d2;
reg    [7:0] sc2mac_wt_data56_d1;
reg    [7:0] sc2mac_wt_data56_d2;
reg    [7:0] sc2mac_wt_data57_d1;
reg    [7:0] sc2mac_wt_data57_d2;
reg    [7:0] sc2mac_wt_data58_d1;
reg    [7:0] sc2mac_wt_data58_d2;
reg    [7:0] sc2mac_wt_data59_d1;
reg    [7:0] sc2mac_wt_data59_d2;
reg    [7:0] sc2mac_wt_data5_d1;
reg    [7:0] sc2mac_wt_data5_d2;
reg    [7:0] sc2mac_wt_data60_d1;
reg    [7:0] sc2mac_wt_data60_d2;
reg    [7:0] sc2mac_wt_data61_d1;
reg    [7:0] sc2mac_wt_data61_d2;
reg    [7:0] sc2mac_wt_data62_d1;
reg    [7:0] sc2mac_wt_data62_d2;
reg    [7:0] sc2mac_wt_data63_d1;
reg    [7:0] sc2mac_wt_data63_d2;
reg    [7:0] sc2mac_wt_data64_d1;
reg    [7:0] sc2mac_wt_data64_d2;
reg    [7:0] sc2mac_wt_data65_d1;
reg    [7:0] sc2mac_wt_data65_d2;
reg    [7:0] sc2mac_wt_data66_d1;
reg    [7:0] sc2mac_wt_data66_d2;
reg    [7:0] sc2mac_wt_data67_d1;
reg    [7:0] sc2mac_wt_data67_d2;
reg    [7:0] sc2mac_wt_data68_d1;
reg    [7:0] sc2mac_wt_data68_d2;
reg    [7:0] sc2mac_wt_data69_d1;
reg    [7:0] sc2mac_wt_data69_d2;
reg    [7:0] sc2mac_wt_data6_d1;
reg    [7:0] sc2mac_wt_data6_d2;
reg    [7:0] sc2mac_wt_data70_d1;
reg    [7:0] sc2mac_wt_data70_d2;
reg    [7:0] sc2mac_wt_data71_d1;
reg    [7:0] sc2mac_wt_data71_d2;
reg    [7:0] sc2mac_wt_data72_d1;
reg    [7:0] sc2mac_wt_data72_d2;
reg    [7:0] sc2mac_wt_data73_d1;
reg    [7:0] sc2mac_wt_data73_d2;
reg    [7:0] sc2mac_wt_data74_d1;
reg    [7:0] sc2mac_wt_data74_d2;
reg    [7:0] sc2mac_wt_data75_d1;
reg    [7:0] sc2mac_wt_data75_d2;
reg    [7:0] sc2mac_wt_data76_d1;
reg    [7:0] sc2mac_wt_data76_d2;
reg    [7:0] sc2mac_wt_data77_d1;
reg    [7:0] sc2mac_wt_data77_d2;
reg    [7:0] sc2mac_wt_data78_d1;
reg    [7:0] sc2mac_wt_data78_d2;
reg    [7:0] sc2mac_wt_data79_d1;
reg    [7:0] sc2mac_wt_data79_d2;
reg    [7:0] sc2mac_wt_data7_d1;
reg    [7:0] sc2mac_wt_data7_d2;
reg    [7:0] sc2mac_wt_data80_d1;
reg    [7:0] sc2mac_wt_data80_d2;
reg    [7:0] sc2mac_wt_data81_d1;
reg    [7:0] sc2mac_wt_data81_d2;
reg    [7:0] sc2mac_wt_data82_d1;
reg    [7:0] sc2mac_wt_data82_d2;
reg    [7:0] sc2mac_wt_data83_d1;
reg    [7:0] sc2mac_wt_data83_d2;
reg    [7:0] sc2mac_wt_data84_d1;
reg    [7:0] sc2mac_wt_data84_d2;
reg    [7:0] sc2mac_wt_data85_d1;
reg    [7:0] sc2mac_wt_data85_d2;
reg    [7:0] sc2mac_wt_data86_d1;
reg    [7:0] sc2mac_wt_data86_d2;
reg    [7:0] sc2mac_wt_data87_d1;
reg    [7:0] sc2mac_wt_data87_d2;
reg    [7:0] sc2mac_wt_data88_d1;
reg    [7:0] sc2mac_wt_data88_d2;
reg    [7:0] sc2mac_wt_data89_d1;
reg    [7:0] sc2mac_wt_data89_d2;
reg    [7:0] sc2mac_wt_data8_d1;
reg    [7:0] sc2mac_wt_data8_d2;
reg    [7:0] sc2mac_wt_data90_d1;
reg    [7:0] sc2mac_wt_data90_d2;
reg    [7:0] sc2mac_wt_data91_d1;
reg    [7:0] sc2mac_wt_data91_d2;
reg    [7:0] sc2mac_wt_data92_d1;
reg    [7:0] sc2mac_wt_data92_d2;
reg    [7:0] sc2mac_wt_data93_d1;
reg    [7:0] sc2mac_wt_data93_d2;
reg    [7:0] sc2mac_wt_data94_d1;
reg    [7:0] sc2mac_wt_data94_d2;
reg    [7:0] sc2mac_wt_data95_d1;
reg    [7:0] sc2mac_wt_data95_d2;
reg    [7:0] sc2mac_wt_data96_d1;
reg    [7:0] sc2mac_wt_data96_d2;
reg    [7:0] sc2mac_wt_data97_d1;
reg    [7:0] sc2mac_wt_data97_d2;
reg    [7:0] sc2mac_wt_data98_d1;
reg    [7:0] sc2mac_wt_data98_d2;
reg    [7:0] sc2mac_wt_data99_d1;
reg    [7:0] sc2mac_wt_data99_d2;
reg    [7:0] sc2mac_wt_data9_d1;
reg    [7:0] sc2mac_wt_data9_d2;
reg  [127:0] sc2mac_wt_mask_d1;
reg  [127:0] sc2mac_wt_mask_d2;
reg          sc2mac_wt_pvld_d1;
reg          sc2mac_wt_pvld_d2;
reg    [7:0] sc2mac_wt_sel_d1;
reg    [7:0] sc2mac_wt_sel_d2;


assign sc2mac_wt_pvld_d0 = sc2mac_wt_src_pvld;
assign sc2mac_wt_sel_d0 = sc2mac_wt_src_sel;
assign sc2mac_wt_mask_d0 = sc2mac_wt_src_mask;
assign sc2mac_wt_data0_d0 = sc2mac_wt_src_data0;
assign sc2mac_wt_data1_d0 = sc2mac_wt_src_data1;
assign sc2mac_wt_data2_d0 = sc2mac_wt_src_data2;
assign sc2mac_wt_data3_d0 = sc2mac_wt_src_data3;
assign sc2mac_wt_data4_d0 = sc2mac_wt_src_data4;
assign sc2mac_wt_data5_d0 = sc2mac_wt_src_data5;
assign sc2mac_wt_data6_d0 = sc2mac_wt_src_data6;
assign sc2mac_wt_data7_d0 = sc2mac_wt_src_data7;
assign sc2mac_wt_data8_d0 = sc2mac_wt_src_data8;
assign sc2mac_wt_data9_d0 = sc2mac_wt_src_data9;
assign sc2mac_wt_data10_d0 = sc2mac_wt_src_data10;
assign sc2mac_wt_data11_d0 = sc2mac_wt_src_data11;
assign sc2mac_wt_data12_d0 = sc2mac_wt_src_data12;
assign sc2mac_wt_data13_d0 = sc2mac_wt_src_data13;
assign sc2mac_wt_data14_d0 = sc2mac_wt_src_data14;
assign sc2mac_wt_data15_d0 = sc2mac_wt_src_data15;
assign sc2mac_wt_data16_d0 = sc2mac_wt_src_data16;
assign sc2mac_wt_data17_d0 = sc2mac_wt_src_data17;
assign sc2mac_wt_data18_d0 = sc2mac_wt_src_data18;
assign sc2mac_wt_data19_d0 = sc2mac_wt_src_data19;
assign sc2mac_wt_data20_d0 = sc2mac_wt_src_data20;
assign sc2mac_wt_data21_d0 = sc2mac_wt_src_data21;
assign sc2mac_wt_data22_d0 = sc2mac_wt_src_data22;
assign sc2mac_wt_data23_d0 = sc2mac_wt_src_data23;
assign sc2mac_wt_data24_d0 = sc2mac_wt_src_data24;
assign sc2mac_wt_data25_d0 = sc2mac_wt_src_data25;
assign sc2mac_wt_data26_d0 = sc2mac_wt_src_data26;
assign sc2mac_wt_data27_d0 = sc2mac_wt_src_data27;
assign sc2mac_wt_data28_d0 = sc2mac_wt_src_data28;
assign sc2mac_wt_data29_d0 = sc2mac_wt_src_data29;
assign sc2mac_wt_data30_d0 = sc2mac_wt_src_data30;
assign sc2mac_wt_data31_d0 = sc2mac_wt_src_data31;
assign sc2mac_wt_data32_d0 = sc2mac_wt_src_data32;
assign sc2mac_wt_data33_d0 = sc2mac_wt_src_data33;
assign sc2mac_wt_data34_d0 = sc2mac_wt_src_data34;
assign sc2mac_wt_data35_d0 = sc2mac_wt_src_data35;
assign sc2mac_wt_data36_d0 = sc2mac_wt_src_data36;
assign sc2mac_wt_data37_d0 = sc2mac_wt_src_data37;
assign sc2mac_wt_data38_d0 = sc2mac_wt_src_data38;
assign sc2mac_wt_data39_d0 = sc2mac_wt_src_data39;
assign sc2mac_wt_data40_d0 = sc2mac_wt_src_data40;
assign sc2mac_wt_data41_d0 = sc2mac_wt_src_data41;
assign sc2mac_wt_data42_d0 = sc2mac_wt_src_data42;
assign sc2mac_wt_data43_d0 = sc2mac_wt_src_data43;
assign sc2mac_wt_data44_d0 = sc2mac_wt_src_data44;
assign sc2mac_wt_data45_d0 = sc2mac_wt_src_data45;
assign sc2mac_wt_data46_d0 = sc2mac_wt_src_data46;
assign sc2mac_wt_data47_d0 = sc2mac_wt_src_data47;
assign sc2mac_wt_data48_d0 = sc2mac_wt_src_data48;
assign sc2mac_wt_data49_d0 = sc2mac_wt_src_data49;
assign sc2mac_wt_data50_d0 = sc2mac_wt_src_data50;
assign sc2mac_wt_data51_d0 = sc2mac_wt_src_data51;
assign sc2mac_wt_data52_d0 = sc2mac_wt_src_data52;
assign sc2mac_wt_data53_d0 = sc2mac_wt_src_data53;
assign sc2mac_wt_data54_d0 = sc2mac_wt_src_data54;
assign sc2mac_wt_data55_d0 = sc2mac_wt_src_data55;
assign sc2mac_wt_data56_d0 = sc2mac_wt_src_data56;
assign sc2mac_wt_data57_d0 = sc2mac_wt_src_data57;
assign sc2mac_wt_data58_d0 = sc2mac_wt_src_data58;
assign sc2mac_wt_data59_d0 = sc2mac_wt_src_data59;
assign sc2mac_wt_data60_d0 = sc2mac_wt_src_data60;
assign sc2mac_wt_data61_d0 = sc2mac_wt_src_data61;
assign sc2mac_wt_data62_d0 = sc2mac_wt_src_data62;
assign sc2mac_wt_data63_d0 = sc2mac_wt_src_data63;
assign sc2mac_wt_data64_d0 = sc2mac_wt_src_data64;
assign sc2mac_wt_data65_d0 = sc2mac_wt_src_data65;
assign sc2mac_wt_data66_d0 = sc2mac_wt_src_data66;
assign sc2mac_wt_data67_d0 = sc2mac_wt_src_data67;
assign sc2mac_wt_data68_d0 = sc2mac_wt_src_data68;
assign sc2mac_wt_data69_d0 = sc2mac_wt_src_data69;
assign sc2mac_wt_data70_d0 = sc2mac_wt_src_data70;
assign sc2mac_wt_data71_d0 = sc2mac_wt_src_data71;
assign sc2mac_wt_data72_d0 = sc2mac_wt_src_data72;
assign sc2mac_wt_data73_d0 = sc2mac_wt_src_data73;
assign sc2mac_wt_data74_d0 = sc2mac_wt_src_data74;
assign sc2mac_wt_data75_d0 = sc2mac_wt_src_data75;
assign sc2mac_wt_data76_d0 = sc2mac_wt_src_data76;
assign sc2mac_wt_data77_d0 = sc2mac_wt_src_data77;
assign sc2mac_wt_data78_d0 = sc2mac_wt_src_data78;
assign sc2mac_wt_data79_d0 = sc2mac_wt_src_data79;
assign sc2mac_wt_data80_d0 = sc2mac_wt_src_data80;
assign sc2mac_wt_data81_d0 = sc2mac_wt_src_data81;
assign sc2mac_wt_data82_d0 = sc2mac_wt_src_data82;
assign sc2mac_wt_data83_d0 = sc2mac_wt_src_data83;
assign sc2mac_wt_data84_d0 = sc2mac_wt_src_data84;
assign sc2mac_wt_data85_d0 = sc2mac_wt_src_data85;
assign sc2mac_wt_data86_d0 = sc2mac_wt_src_data86;
assign sc2mac_wt_data87_d0 = sc2mac_wt_src_data87;
assign sc2mac_wt_data88_d0 = sc2mac_wt_src_data88;
assign sc2mac_wt_data89_d0 = sc2mac_wt_src_data89;
assign sc2mac_wt_data90_d0 = sc2mac_wt_src_data90;
assign sc2mac_wt_data91_d0 = sc2mac_wt_src_data91;
assign sc2mac_wt_data92_d0 = sc2mac_wt_src_data92;
assign sc2mac_wt_data93_d0 = sc2mac_wt_src_data93;
assign sc2mac_wt_data94_d0 = sc2mac_wt_src_data94;
assign sc2mac_wt_data95_d0 = sc2mac_wt_src_data95;
assign sc2mac_wt_data96_d0 = sc2mac_wt_src_data96;
assign sc2mac_wt_data97_d0 = sc2mac_wt_src_data97;
assign sc2mac_wt_data98_d0 = sc2mac_wt_src_data98;
assign sc2mac_wt_data99_d0 = sc2mac_wt_src_data99;
assign sc2mac_wt_data100_d0 = sc2mac_wt_src_data100;
assign sc2mac_wt_data101_d0 = sc2mac_wt_src_data101;
assign sc2mac_wt_data102_d0 = sc2mac_wt_src_data102;
assign sc2mac_wt_data103_d0 = sc2mac_wt_src_data103;
assign sc2mac_wt_data104_d0 = sc2mac_wt_src_data104;
assign sc2mac_wt_data105_d0 = sc2mac_wt_src_data105;
assign sc2mac_wt_data106_d0 = sc2mac_wt_src_data106;
assign sc2mac_wt_data107_d0 = sc2mac_wt_src_data107;
assign sc2mac_wt_data108_d0 = sc2mac_wt_src_data108;
assign sc2mac_wt_data109_d0 = sc2mac_wt_src_data109;
assign sc2mac_wt_data110_d0 = sc2mac_wt_src_data110;
assign sc2mac_wt_data111_d0 = sc2mac_wt_src_data111;
assign sc2mac_wt_data112_d0 = sc2mac_wt_src_data112;
assign sc2mac_wt_data113_d0 = sc2mac_wt_src_data113;
assign sc2mac_wt_data114_d0 = sc2mac_wt_src_data114;
assign sc2mac_wt_data115_d0 = sc2mac_wt_src_data115;
assign sc2mac_wt_data116_d0 = sc2mac_wt_src_data116;
assign sc2mac_wt_data117_d0 = sc2mac_wt_src_data117;
assign sc2mac_wt_data118_d0 = sc2mac_wt_src_data118;
assign sc2mac_wt_data119_d0 = sc2mac_wt_src_data119;
assign sc2mac_wt_data120_d0 = sc2mac_wt_src_data120;
assign sc2mac_wt_data121_d0 = sc2mac_wt_src_data121;
assign sc2mac_wt_data122_d0 = sc2mac_wt_src_data122;
assign sc2mac_wt_data123_d0 = sc2mac_wt_src_data123;
assign sc2mac_wt_data124_d0 = sc2mac_wt_src_data124;
assign sc2mac_wt_data125_d0 = sc2mac_wt_src_data125;
assign sc2mac_wt_data126_d0 = sc2mac_wt_src_data126;
assign sc2mac_wt_data127_d0 = sc2mac_wt_src_data127;


assign sc2mac_dat_pvld_d0 = sc2mac_dat_src_pvld;
assign sc2mac_dat_pd_d0 = sc2mac_dat_src_pd;
assign sc2mac_dat_mask_d0 = sc2mac_dat_src_mask;
assign sc2mac_dat_data0_d0 = sc2mac_dat_src_data0;
assign sc2mac_dat_data1_d0 = sc2mac_dat_src_data1;
assign sc2mac_dat_data2_d0 = sc2mac_dat_src_data2;
assign sc2mac_dat_data3_d0 = sc2mac_dat_src_data3;
assign sc2mac_dat_data4_d0 = sc2mac_dat_src_data4;
assign sc2mac_dat_data5_d0 = sc2mac_dat_src_data5;
assign sc2mac_dat_data6_d0 = sc2mac_dat_src_data6;
assign sc2mac_dat_data7_d0 = sc2mac_dat_src_data7;
assign sc2mac_dat_data8_d0 = sc2mac_dat_src_data8;
assign sc2mac_dat_data9_d0 = sc2mac_dat_src_data9;
assign sc2mac_dat_data10_d0 = sc2mac_dat_src_data10;
assign sc2mac_dat_data11_d0 = sc2mac_dat_src_data11;
assign sc2mac_dat_data12_d0 = sc2mac_dat_src_data12;
assign sc2mac_dat_data13_d0 = sc2mac_dat_src_data13;
assign sc2mac_dat_data14_d0 = sc2mac_dat_src_data14;
assign sc2mac_dat_data15_d0 = sc2mac_dat_src_data15;
assign sc2mac_dat_data16_d0 = sc2mac_dat_src_data16;
assign sc2mac_dat_data17_d0 = sc2mac_dat_src_data17;
assign sc2mac_dat_data18_d0 = sc2mac_dat_src_data18;
assign sc2mac_dat_data19_d0 = sc2mac_dat_src_data19;
assign sc2mac_dat_data20_d0 = sc2mac_dat_src_data20;
assign sc2mac_dat_data21_d0 = sc2mac_dat_src_data21;
assign sc2mac_dat_data22_d0 = sc2mac_dat_src_data22;
assign sc2mac_dat_data23_d0 = sc2mac_dat_src_data23;
assign sc2mac_dat_data24_d0 = sc2mac_dat_src_data24;
assign sc2mac_dat_data25_d0 = sc2mac_dat_src_data25;
assign sc2mac_dat_data26_d0 = sc2mac_dat_src_data26;
assign sc2mac_dat_data27_d0 = sc2mac_dat_src_data27;
assign sc2mac_dat_data28_d0 = sc2mac_dat_src_data28;
assign sc2mac_dat_data29_d0 = sc2mac_dat_src_data29;
assign sc2mac_dat_data30_d0 = sc2mac_dat_src_data30;
assign sc2mac_dat_data31_d0 = sc2mac_dat_src_data31;
assign sc2mac_dat_data32_d0 = sc2mac_dat_src_data32;
assign sc2mac_dat_data33_d0 = sc2mac_dat_src_data33;
assign sc2mac_dat_data34_d0 = sc2mac_dat_src_data34;
assign sc2mac_dat_data35_d0 = sc2mac_dat_src_data35;
assign sc2mac_dat_data36_d0 = sc2mac_dat_src_data36;
assign sc2mac_dat_data37_d0 = sc2mac_dat_src_data37;
assign sc2mac_dat_data38_d0 = sc2mac_dat_src_data38;
assign sc2mac_dat_data39_d0 = sc2mac_dat_src_data39;
assign sc2mac_dat_data40_d0 = sc2mac_dat_src_data40;
assign sc2mac_dat_data41_d0 = sc2mac_dat_src_data41;
assign sc2mac_dat_data42_d0 = sc2mac_dat_src_data42;
assign sc2mac_dat_data43_d0 = sc2mac_dat_src_data43;
assign sc2mac_dat_data44_d0 = sc2mac_dat_src_data44;
assign sc2mac_dat_data45_d0 = sc2mac_dat_src_data45;
assign sc2mac_dat_data46_d0 = sc2mac_dat_src_data46;
assign sc2mac_dat_data47_d0 = sc2mac_dat_src_data47;
assign sc2mac_dat_data48_d0 = sc2mac_dat_src_data48;
assign sc2mac_dat_data49_d0 = sc2mac_dat_src_data49;
assign sc2mac_dat_data50_d0 = sc2mac_dat_src_data50;
assign sc2mac_dat_data51_d0 = sc2mac_dat_src_data51;
assign sc2mac_dat_data52_d0 = sc2mac_dat_src_data52;
assign sc2mac_dat_data53_d0 = sc2mac_dat_src_data53;
assign sc2mac_dat_data54_d0 = sc2mac_dat_src_data54;
assign sc2mac_dat_data55_d0 = sc2mac_dat_src_data55;
assign sc2mac_dat_data56_d0 = sc2mac_dat_src_data56;
assign sc2mac_dat_data57_d0 = sc2mac_dat_src_data57;
assign sc2mac_dat_data58_d0 = sc2mac_dat_src_data58;
assign sc2mac_dat_data59_d0 = sc2mac_dat_src_data59;
assign sc2mac_dat_data60_d0 = sc2mac_dat_src_data60;
assign sc2mac_dat_data61_d0 = sc2mac_dat_src_data61;
assign sc2mac_dat_data62_d0 = sc2mac_dat_src_data62;
assign sc2mac_dat_data63_d0 = sc2mac_dat_src_data63;
assign sc2mac_dat_data64_d0 = sc2mac_dat_src_data64;
assign sc2mac_dat_data65_d0 = sc2mac_dat_src_data65;
assign sc2mac_dat_data66_d0 = sc2mac_dat_src_data66;
assign sc2mac_dat_data67_d0 = sc2mac_dat_src_data67;
assign sc2mac_dat_data68_d0 = sc2mac_dat_src_data68;
assign sc2mac_dat_data69_d0 = sc2mac_dat_src_data69;
assign sc2mac_dat_data70_d0 = sc2mac_dat_src_data70;
assign sc2mac_dat_data71_d0 = sc2mac_dat_src_data71;
assign sc2mac_dat_data72_d0 = sc2mac_dat_src_data72;
assign sc2mac_dat_data73_d0 = sc2mac_dat_src_data73;
assign sc2mac_dat_data74_d0 = sc2mac_dat_src_data74;
assign sc2mac_dat_data75_d0 = sc2mac_dat_src_data75;
assign sc2mac_dat_data76_d0 = sc2mac_dat_src_data76;
assign sc2mac_dat_data77_d0 = sc2mac_dat_src_data77;
assign sc2mac_dat_data78_d0 = sc2mac_dat_src_data78;
assign sc2mac_dat_data79_d0 = sc2mac_dat_src_data79;
assign sc2mac_dat_data80_d0 = sc2mac_dat_src_data80;
assign sc2mac_dat_data81_d0 = sc2mac_dat_src_data81;
assign sc2mac_dat_data82_d0 = sc2mac_dat_src_data82;
assign sc2mac_dat_data83_d0 = sc2mac_dat_src_data83;
assign sc2mac_dat_data84_d0 = sc2mac_dat_src_data84;
assign sc2mac_dat_data85_d0 = sc2mac_dat_src_data85;
assign sc2mac_dat_data86_d0 = sc2mac_dat_src_data86;
assign sc2mac_dat_data87_d0 = sc2mac_dat_src_data87;
assign sc2mac_dat_data88_d0 = sc2mac_dat_src_data88;
assign sc2mac_dat_data89_d0 = sc2mac_dat_src_data89;
assign sc2mac_dat_data90_d0 = sc2mac_dat_src_data90;
assign sc2mac_dat_data91_d0 = sc2mac_dat_src_data91;
assign sc2mac_dat_data92_d0 = sc2mac_dat_src_data92;
assign sc2mac_dat_data93_d0 = sc2mac_dat_src_data93;
assign sc2mac_dat_data94_d0 = sc2mac_dat_src_data94;
assign sc2mac_dat_data95_d0 = sc2mac_dat_src_data95;
assign sc2mac_dat_data96_d0 = sc2mac_dat_src_data96;
assign sc2mac_dat_data97_d0 = sc2mac_dat_src_data97;
assign sc2mac_dat_data98_d0 = sc2mac_dat_src_data98;
assign sc2mac_dat_data99_d0 = sc2mac_dat_src_data99;
assign sc2mac_dat_data100_d0 = sc2mac_dat_src_data100;
assign sc2mac_dat_data101_d0 = sc2mac_dat_src_data101;
assign sc2mac_dat_data102_d0 = sc2mac_dat_src_data102;
assign sc2mac_dat_data103_d0 = sc2mac_dat_src_data103;
assign sc2mac_dat_data104_d0 = sc2mac_dat_src_data104;
assign sc2mac_dat_data105_d0 = sc2mac_dat_src_data105;
assign sc2mac_dat_data106_d0 = sc2mac_dat_src_data106;
assign sc2mac_dat_data107_d0 = sc2mac_dat_src_data107;
assign sc2mac_dat_data108_d0 = sc2mac_dat_src_data108;
assign sc2mac_dat_data109_d0 = sc2mac_dat_src_data109;
assign sc2mac_dat_data110_d0 = sc2mac_dat_src_data110;
assign sc2mac_dat_data111_d0 = sc2mac_dat_src_data111;
assign sc2mac_dat_data112_d0 = sc2mac_dat_src_data112;
assign sc2mac_dat_data113_d0 = sc2mac_dat_src_data113;
assign sc2mac_dat_data114_d0 = sc2mac_dat_src_data114;
assign sc2mac_dat_data115_d0 = sc2mac_dat_src_data115;
assign sc2mac_dat_data116_d0 = sc2mac_dat_src_data116;
assign sc2mac_dat_data117_d0 = sc2mac_dat_src_data117;
assign sc2mac_dat_data118_d0 = sc2mac_dat_src_data118;
assign sc2mac_dat_data119_d0 = sc2mac_dat_src_data119;
assign sc2mac_dat_data120_d0 = sc2mac_dat_src_data120;
assign sc2mac_dat_data121_d0 = sc2mac_dat_src_data121;
assign sc2mac_dat_data122_d0 = sc2mac_dat_src_data122;
assign sc2mac_dat_data123_d0 = sc2mac_dat_src_data123;
assign sc2mac_dat_data124_d0 = sc2mac_dat_src_data124;
assign sc2mac_dat_data125_d0 = sc2mac_dat_src_data125;
assign sc2mac_dat_data126_d0 = sc2mac_dat_src_data126;
assign sc2mac_dat_data127_d0 = sc2mac_dat_src_data127;




always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2mac_wt_pvld_d1 <= 1'b0;
  end else begin
  sc2mac_wt_pvld_d1 <= sc2mac_wt_pvld_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2mac_wt_sel_d1 <= {8{1'b0}};
  end else begin
  if ((sc2mac_wt_pvld_d0 | sc2mac_wt_pvld_d1) == 1'b1) begin
    sc2mac_wt_sel_d1 <= sc2mac_wt_sel_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_pvld_d0 | sc2mac_wt_pvld_d1) == 1'b0) begin
  end else begin
    sc2mac_wt_sel_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sc2mac_wt_pvld_d0 | sc2mac_wt_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sc2mac_wt_mask_d1 <= {128{1'b0}};
  end else begin
  if ((sc2mac_wt_pvld_d0 | sc2mac_wt_pvld_d1) == 1'b1) begin
    sc2mac_wt_mask_d1 <= sc2mac_wt_mask_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_pvld_d0 | sc2mac_wt_pvld_d1) == 1'b0) begin
  end else begin
    sc2mac_wt_mask_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sc2mac_wt_pvld_d0 | sc2mac_wt_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  if ((sc2mac_wt_mask_d0[0]) == 1'b1) begin
    sc2mac_wt_data0_d1 <= sc2mac_wt_data0_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[0]) == 1'b0) begin
  end else begin
    sc2mac_wt_data0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[1]) == 1'b1) begin
    sc2mac_wt_data1_d1 <= sc2mac_wt_data1_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[1]) == 1'b0) begin
  end else begin
    sc2mac_wt_data1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[2]) == 1'b1) begin
    sc2mac_wt_data2_d1 <= sc2mac_wt_data2_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[2]) == 1'b0) begin
  end else begin
    sc2mac_wt_data2_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[3]) == 1'b1) begin
    sc2mac_wt_data3_d1 <= sc2mac_wt_data3_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[3]) == 1'b0) begin
  end else begin
    sc2mac_wt_data3_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[4]) == 1'b1) begin
    sc2mac_wt_data4_d1 <= sc2mac_wt_data4_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[4]) == 1'b0) begin
  end else begin
    sc2mac_wt_data4_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[5]) == 1'b1) begin
    sc2mac_wt_data5_d1 <= sc2mac_wt_data5_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[5]) == 1'b0) begin
  end else begin
    sc2mac_wt_data5_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[6]) == 1'b1) begin
    sc2mac_wt_data6_d1 <= sc2mac_wt_data6_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[6]) == 1'b0) begin
  end else begin
    sc2mac_wt_data6_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[7]) == 1'b1) begin
    sc2mac_wt_data7_d1 <= sc2mac_wt_data7_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[7]) == 1'b0) begin
  end else begin
    sc2mac_wt_data7_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[8]) == 1'b1) begin
    sc2mac_wt_data8_d1 <= sc2mac_wt_data8_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[8]) == 1'b0) begin
  end else begin
    sc2mac_wt_data8_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[9]) == 1'b1) begin
    sc2mac_wt_data9_d1 <= sc2mac_wt_data9_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[9]) == 1'b0) begin
  end else begin
    sc2mac_wt_data9_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[10]) == 1'b1) begin
    sc2mac_wt_data10_d1 <= sc2mac_wt_data10_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[10]) == 1'b0) begin
  end else begin
    sc2mac_wt_data10_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[11]) == 1'b1) begin
    sc2mac_wt_data11_d1 <= sc2mac_wt_data11_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[11]) == 1'b0) begin
  end else begin
    sc2mac_wt_data11_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[12]) == 1'b1) begin
    sc2mac_wt_data12_d1 <= sc2mac_wt_data12_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[12]) == 1'b0) begin
  end else begin
    sc2mac_wt_data12_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[13]) == 1'b1) begin
    sc2mac_wt_data13_d1 <= sc2mac_wt_data13_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[13]) == 1'b0) begin
  end else begin
    sc2mac_wt_data13_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[14]) == 1'b1) begin
    sc2mac_wt_data14_d1 <= sc2mac_wt_data14_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[14]) == 1'b0) begin
  end else begin
    sc2mac_wt_data14_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[15]) == 1'b1) begin
    sc2mac_wt_data15_d1 <= sc2mac_wt_data15_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[15]) == 1'b0) begin
  end else begin
    sc2mac_wt_data15_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[16]) == 1'b1) begin
    sc2mac_wt_data16_d1 <= sc2mac_wt_data16_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[16]) == 1'b0) begin
  end else begin
    sc2mac_wt_data16_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[17]) == 1'b1) begin
    sc2mac_wt_data17_d1 <= sc2mac_wt_data17_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[17]) == 1'b0) begin
  end else begin
    sc2mac_wt_data17_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[18]) == 1'b1) begin
    sc2mac_wt_data18_d1 <= sc2mac_wt_data18_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[18]) == 1'b0) begin
  end else begin
    sc2mac_wt_data18_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[19]) == 1'b1) begin
    sc2mac_wt_data19_d1 <= sc2mac_wt_data19_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[19]) == 1'b0) begin
  end else begin
    sc2mac_wt_data19_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[20]) == 1'b1) begin
    sc2mac_wt_data20_d1 <= sc2mac_wt_data20_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[20]) == 1'b0) begin
  end else begin
    sc2mac_wt_data20_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[21]) == 1'b1) begin
    sc2mac_wt_data21_d1 <= sc2mac_wt_data21_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[21]) == 1'b0) begin
  end else begin
    sc2mac_wt_data21_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[22]) == 1'b1) begin
    sc2mac_wt_data22_d1 <= sc2mac_wt_data22_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[22]) == 1'b0) begin
  end else begin
    sc2mac_wt_data22_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[23]) == 1'b1) begin
    sc2mac_wt_data23_d1 <= sc2mac_wt_data23_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[23]) == 1'b0) begin
  end else begin
    sc2mac_wt_data23_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[24]) == 1'b1) begin
    sc2mac_wt_data24_d1 <= sc2mac_wt_data24_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[24]) == 1'b0) begin
  end else begin
    sc2mac_wt_data24_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[25]) == 1'b1) begin
    sc2mac_wt_data25_d1 <= sc2mac_wt_data25_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[25]) == 1'b0) begin
  end else begin
    sc2mac_wt_data25_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[26]) == 1'b1) begin
    sc2mac_wt_data26_d1 <= sc2mac_wt_data26_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[26]) == 1'b0) begin
  end else begin
    sc2mac_wt_data26_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[27]) == 1'b1) begin
    sc2mac_wt_data27_d1 <= sc2mac_wt_data27_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[27]) == 1'b0) begin
  end else begin
    sc2mac_wt_data27_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[28]) == 1'b1) begin
    sc2mac_wt_data28_d1 <= sc2mac_wt_data28_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[28]) == 1'b0) begin
  end else begin
    sc2mac_wt_data28_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[29]) == 1'b1) begin
    sc2mac_wt_data29_d1 <= sc2mac_wt_data29_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[29]) == 1'b0) begin
  end else begin
    sc2mac_wt_data29_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[30]) == 1'b1) begin
    sc2mac_wt_data30_d1 <= sc2mac_wt_data30_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[30]) == 1'b0) begin
  end else begin
    sc2mac_wt_data30_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[31]) == 1'b1) begin
    sc2mac_wt_data31_d1 <= sc2mac_wt_data31_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[31]) == 1'b0) begin
  end else begin
    sc2mac_wt_data31_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[32]) == 1'b1) begin
    sc2mac_wt_data32_d1 <= sc2mac_wt_data32_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[32]) == 1'b0) begin
  end else begin
    sc2mac_wt_data32_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[33]) == 1'b1) begin
    sc2mac_wt_data33_d1 <= sc2mac_wt_data33_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[33]) == 1'b0) begin
  end else begin
    sc2mac_wt_data33_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[34]) == 1'b1) begin
    sc2mac_wt_data34_d1 <= sc2mac_wt_data34_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[34]) == 1'b0) begin
  end else begin
    sc2mac_wt_data34_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[35]) == 1'b1) begin
    sc2mac_wt_data35_d1 <= sc2mac_wt_data35_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[35]) == 1'b0) begin
  end else begin
    sc2mac_wt_data35_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[36]) == 1'b1) begin
    sc2mac_wt_data36_d1 <= sc2mac_wt_data36_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[36]) == 1'b0) begin
  end else begin
    sc2mac_wt_data36_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[37]) == 1'b1) begin
    sc2mac_wt_data37_d1 <= sc2mac_wt_data37_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[37]) == 1'b0) begin
  end else begin
    sc2mac_wt_data37_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[38]) == 1'b1) begin
    sc2mac_wt_data38_d1 <= sc2mac_wt_data38_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[38]) == 1'b0) begin
  end else begin
    sc2mac_wt_data38_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[39]) == 1'b1) begin
    sc2mac_wt_data39_d1 <= sc2mac_wt_data39_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[39]) == 1'b0) begin
  end else begin
    sc2mac_wt_data39_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[40]) == 1'b1) begin
    sc2mac_wt_data40_d1 <= sc2mac_wt_data40_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[40]) == 1'b0) begin
  end else begin
    sc2mac_wt_data40_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[41]) == 1'b1) begin
    sc2mac_wt_data41_d1 <= sc2mac_wt_data41_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[41]) == 1'b0) begin
  end else begin
    sc2mac_wt_data41_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[42]) == 1'b1) begin
    sc2mac_wt_data42_d1 <= sc2mac_wt_data42_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[42]) == 1'b0) begin
  end else begin
    sc2mac_wt_data42_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[43]) == 1'b1) begin
    sc2mac_wt_data43_d1 <= sc2mac_wt_data43_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[43]) == 1'b0) begin
  end else begin
    sc2mac_wt_data43_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[44]) == 1'b1) begin
    sc2mac_wt_data44_d1 <= sc2mac_wt_data44_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[44]) == 1'b0) begin
  end else begin
    sc2mac_wt_data44_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[45]) == 1'b1) begin
    sc2mac_wt_data45_d1 <= sc2mac_wt_data45_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[45]) == 1'b0) begin
  end else begin
    sc2mac_wt_data45_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[46]) == 1'b1) begin
    sc2mac_wt_data46_d1 <= sc2mac_wt_data46_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[46]) == 1'b0) begin
  end else begin
    sc2mac_wt_data46_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[47]) == 1'b1) begin
    sc2mac_wt_data47_d1 <= sc2mac_wt_data47_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[47]) == 1'b0) begin
  end else begin
    sc2mac_wt_data47_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[48]) == 1'b1) begin
    sc2mac_wt_data48_d1 <= sc2mac_wt_data48_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[48]) == 1'b0) begin
  end else begin
    sc2mac_wt_data48_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[49]) == 1'b1) begin
    sc2mac_wt_data49_d1 <= sc2mac_wt_data49_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[49]) == 1'b0) begin
  end else begin
    sc2mac_wt_data49_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[50]) == 1'b1) begin
    sc2mac_wt_data50_d1 <= sc2mac_wt_data50_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[50]) == 1'b0) begin
  end else begin
    sc2mac_wt_data50_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[51]) == 1'b1) begin
    sc2mac_wt_data51_d1 <= sc2mac_wt_data51_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[51]) == 1'b0) begin
  end else begin
    sc2mac_wt_data51_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[52]) == 1'b1) begin
    sc2mac_wt_data52_d1 <= sc2mac_wt_data52_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[52]) == 1'b0) begin
  end else begin
    sc2mac_wt_data52_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[53]) == 1'b1) begin
    sc2mac_wt_data53_d1 <= sc2mac_wt_data53_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[53]) == 1'b0) begin
  end else begin
    sc2mac_wt_data53_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[54]) == 1'b1) begin
    sc2mac_wt_data54_d1 <= sc2mac_wt_data54_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[54]) == 1'b0) begin
  end else begin
    sc2mac_wt_data54_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[55]) == 1'b1) begin
    sc2mac_wt_data55_d1 <= sc2mac_wt_data55_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[55]) == 1'b0) begin
  end else begin
    sc2mac_wt_data55_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[56]) == 1'b1) begin
    sc2mac_wt_data56_d1 <= sc2mac_wt_data56_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[56]) == 1'b0) begin
  end else begin
    sc2mac_wt_data56_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[57]) == 1'b1) begin
    sc2mac_wt_data57_d1 <= sc2mac_wt_data57_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[57]) == 1'b0) begin
  end else begin
    sc2mac_wt_data57_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[58]) == 1'b1) begin
    sc2mac_wt_data58_d1 <= sc2mac_wt_data58_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[58]) == 1'b0) begin
  end else begin
    sc2mac_wt_data58_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[59]) == 1'b1) begin
    sc2mac_wt_data59_d1 <= sc2mac_wt_data59_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[59]) == 1'b0) begin
  end else begin
    sc2mac_wt_data59_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[60]) == 1'b1) begin
    sc2mac_wt_data60_d1 <= sc2mac_wt_data60_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[60]) == 1'b0) begin
  end else begin
    sc2mac_wt_data60_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[61]) == 1'b1) begin
    sc2mac_wt_data61_d1 <= sc2mac_wt_data61_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[61]) == 1'b0) begin
  end else begin
    sc2mac_wt_data61_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[62]) == 1'b1) begin
    sc2mac_wt_data62_d1 <= sc2mac_wt_data62_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[62]) == 1'b0) begin
  end else begin
    sc2mac_wt_data62_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[63]) == 1'b1) begin
    sc2mac_wt_data63_d1 <= sc2mac_wt_data63_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[63]) == 1'b0) begin
  end else begin
    sc2mac_wt_data63_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[64]) == 1'b1) begin
    sc2mac_wt_data64_d1 <= sc2mac_wt_data64_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[64]) == 1'b0) begin
  end else begin
    sc2mac_wt_data64_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[65]) == 1'b1) begin
    sc2mac_wt_data65_d1 <= sc2mac_wt_data65_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[65]) == 1'b0) begin
  end else begin
    sc2mac_wt_data65_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[66]) == 1'b1) begin
    sc2mac_wt_data66_d1 <= sc2mac_wt_data66_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[66]) == 1'b0) begin
  end else begin
    sc2mac_wt_data66_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[67]) == 1'b1) begin
    sc2mac_wt_data67_d1 <= sc2mac_wt_data67_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[67]) == 1'b0) begin
  end else begin
    sc2mac_wt_data67_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[68]) == 1'b1) begin
    sc2mac_wt_data68_d1 <= sc2mac_wt_data68_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[68]) == 1'b0) begin
  end else begin
    sc2mac_wt_data68_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[69]) == 1'b1) begin
    sc2mac_wt_data69_d1 <= sc2mac_wt_data69_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[69]) == 1'b0) begin
  end else begin
    sc2mac_wt_data69_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[70]) == 1'b1) begin
    sc2mac_wt_data70_d1 <= sc2mac_wt_data70_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[70]) == 1'b0) begin
  end else begin
    sc2mac_wt_data70_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[71]) == 1'b1) begin
    sc2mac_wt_data71_d1 <= sc2mac_wt_data71_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[71]) == 1'b0) begin
  end else begin
    sc2mac_wt_data71_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[72]) == 1'b1) begin
    sc2mac_wt_data72_d1 <= sc2mac_wt_data72_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[72]) == 1'b0) begin
  end else begin
    sc2mac_wt_data72_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[73]) == 1'b1) begin
    sc2mac_wt_data73_d1 <= sc2mac_wt_data73_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[73]) == 1'b0) begin
  end else begin
    sc2mac_wt_data73_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[74]) == 1'b1) begin
    sc2mac_wt_data74_d1 <= sc2mac_wt_data74_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[74]) == 1'b0) begin
  end else begin
    sc2mac_wt_data74_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[75]) == 1'b1) begin
    sc2mac_wt_data75_d1 <= sc2mac_wt_data75_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[75]) == 1'b0) begin
  end else begin
    sc2mac_wt_data75_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[76]) == 1'b1) begin
    sc2mac_wt_data76_d1 <= sc2mac_wt_data76_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[76]) == 1'b0) begin
  end else begin
    sc2mac_wt_data76_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[77]) == 1'b1) begin
    sc2mac_wt_data77_d1 <= sc2mac_wt_data77_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[77]) == 1'b0) begin
  end else begin
    sc2mac_wt_data77_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[78]) == 1'b1) begin
    sc2mac_wt_data78_d1 <= sc2mac_wt_data78_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[78]) == 1'b0) begin
  end else begin
    sc2mac_wt_data78_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[79]) == 1'b1) begin
    sc2mac_wt_data79_d1 <= sc2mac_wt_data79_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[79]) == 1'b0) begin
  end else begin
    sc2mac_wt_data79_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[80]) == 1'b1) begin
    sc2mac_wt_data80_d1 <= sc2mac_wt_data80_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[80]) == 1'b0) begin
  end else begin
    sc2mac_wt_data80_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[81]) == 1'b1) begin
    sc2mac_wt_data81_d1 <= sc2mac_wt_data81_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[81]) == 1'b0) begin
  end else begin
    sc2mac_wt_data81_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[82]) == 1'b1) begin
    sc2mac_wt_data82_d1 <= sc2mac_wt_data82_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[82]) == 1'b0) begin
  end else begin
    sc2mac_wt_data82_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[83]) == 1'b1) begin
    sc2mac_wt_data83_d1 <= sc2mac_wt_data83_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[83]) == 1'b0) begin
  end else begin
    sc2mac_wt_data83_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[84]) == 1'b1) begin
    sc2mac_wt_data84_d1 <= sc2mac_wt_data84_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[84]) == 1'b0) begin
  end else begin
    sc2mac_wt_data84_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[85]) == 1'b1) begin
    sc2mac_wt_data85_d1 <= sc2mac_wt_data85_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[85]) == 1'b0) begin
  end else begin
    sc2mac_wt_data85_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[86]) == 1'b1) begin
    sc2mac_wt_data86_d1 <= sc2mac_wt_data86_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[86]) == 1'b0) begin
  end else begin
    sc2mac_wt_data86_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[87]) == 1'b1) begin
    sc2mac_wt_data87_d1 <= sc2mac_wt_data87_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[87]) == 1'b0) begin
  end else begin
    sc2mac_wt_data87_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[88]) == 1'b1) begin
    sc2mac_wt_data88_d1 <= sc2mac_wt_data88_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[88]) == 1'b0) begin
  end else begin
    sc2mac_wt_data88_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[89]) == 1'b1) begin
    sc2mac_wt_data89_d1 <= sc2mac_wt_data89_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[89]) == 1'b0) begin
  end else begin
    sc2mac_wt_data89_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[90]) == 1'b1) begin
    sc2mac_wt_data90_d1 <= sc2mac_wt_data90_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[90]) == 1'b0) begin
  end else begin
    sc2mac_wt_data90_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[91]) == 1'b1) begin
    sc2mac_wt_data91_d1 <= sc2mac_wt_data91_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[91]) == 1'b0) begin
  end else begin
    sc2mac_wt_data91_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[92]) == 1'b1) begin
    sc2mac_wt_data92_d1 <= sc2mac_wt_data92_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[92]) == 1'b0) begin
  end else begin
    sc2mac_wt_data92_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[93]) == 1'b1) begin
    sc2mac_wt_data93_d1 <= sc2mac_wt_data93_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[93]) == 1'b0) begin
  end else begin
    sc2mac_wt_data93_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[94]) == 1'b1) begin
    sc2mac_wt_data94_d1 <= sc2mac_wt_data94_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[94]) == 1'b0) begin
  end else begin
    sc2mac_wt_data94_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[95]) == 1'b1) begin
    sc2mac_wt_data95_d1 <= sc2mac_wt_data95_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[95]) == 1'b0) begin
  end else begin
    sc2mac_wt_data95_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[96]) == 1'b1) begin
    sc2mac_wt_data96_d1 <= sc2mac_wt_data96_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[96]) == 1'b0) begin
  end else begin
    sc2mac_wt_data96_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[97]) == 1'b1) begin
    sc2mac_wt_data97_d1 <= sc2mac_wt_data97_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[97]) == 1'b0) begin
  end else begin
    sc2mac_wt_data97_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[98]) == 1'b1) begin
    sc2mac_wt_data98_d1 <= sc2mac_wt_data98_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[98]) == 1'b0) begin
  end else begin
    sc2mac_wt_data98_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[99]) == 1'b1) begin
    sc2mac_wt_data99_d1 <= sc2mac_wt_data99_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[99]) == 1'b0) begin
  end else begin
    sc2mac_wt_data99_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[100]) == 1'b1) begin
    sc2mac_wt_data100_d1 <= sc2mac_wt_data100_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[100]) == 1'b0) begin
  end else begin
    sc2mac_wt_data100_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[101]) == 1'b1) begin
    sc2mac_wt_data101_d1 <= sc2mac_wt_data101_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[101]) == 1'b0) begin
  end else begin
    sc2mac_wt_data101_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[102]) == 1'b1) begin
    sc2mac_wt_data102_d1 <= sc2mac_wt_data102_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[102]) == 1'b0) begin
  end else begin
    sc2mac_wt_data102_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[103]) == 1'b1) begin
    sc2mac_wt_data103_d1 <= sc2mac_wt_data103_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[103]) == 1'b0) begin
  end else begin
    sc2mac_wt_data103_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[104]) == 1'b1) begin
    sc2mac_wt_data104_d1 <= sc2mac_wt_data104_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[104]) == 1'b0) begin
  end else begin
    sc2mac_wt_data104_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[105]) == 1'b1) begin
    sc2mac_wt_data105_d1 <= sc2mac_wt_data105_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[105]) == 1'b0) begin
  end else begin
    sc2mac_wt_data105_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[106]) == 1'b1) begin
    sc2mac_wt_data106_d1 <= sc2mac_wt_data106_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[106]) == 1'b0) begin
  end else begin
    sc2mac_wt_data106_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[107]) == 1'b1) begin
    sc2mac_wt_data107_d1 <= sc2mac_wt_data107_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[107]) == 1'b0) begin
  end else begin
    sc2mac_wt_data107_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[108]) == 1'b1) begin
    sc2mac_wt_data108_d1 <= sc2mac_wt_data108_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[108]) == 1'b0) begin
  end else begin
    sc2mac_wt_data108_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[109]) == 1'b1) begin
    sc2mac_wt_data109_d1 <= sc2mac_wt_data109_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[109]) == 1'b0) begin
  end else begin
    sc2mac_wt_data109_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[110]) == 1'b1) begin
    sc2mac_wt_data110_d1 <= sc2mac_wt_data110_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[110]) == 1'b0) begin
  end else begin
    sc2mac_wt_data110_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[111]) == 1'b1) begin
    sc2mac_wt_data111_d1 <= sc2mac_wt_data111_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[111]) == 1'b0) begin
  end else begin
    sc2mac_wt_data111_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[112]) == 1'b1) begin
    sc2mac_wt_data112_d1 <= sc2mac_wt_data112_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[112]) == 1'b0) begin
  end else begin
    sc2mac_wt_data112_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[113]) == 1'b1) begin
    sc2mac_wt_data113_d1 <= sc2mac_wt_data113_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[113]) == 1'b0) begin
  end else begin
    sc2mac_wt_data113_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[114]) == 1'b1) begin
    sc2mac_wt_data114_d1 <= sc2mac_wt_data114_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[114]) == 1'b0) begin
  end else begin
    sc2mac_wt_data114_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[115]) == 1'b1) begin
    sc2mac_wt_data115_d1 <= sc2mac_wt_data115_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[115]) == 1'b0) begin
  end else begin
    sc2mac_wt_data115_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[116]) == 1'b1) begin
    sc2mac_wt_data116_d1 <= sc2mac_wt_data116_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[116]) == 1'b0) begin
  end else begin
    sc2mac_wt_data116_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[117]) == 1'b1) begin
    sc2mac_wt_data117_d1 <= sc2mac_wt_data117_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[117]) == 1'b0) begin
  end else begin
    sc2mac_wt_data117_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[118]) == 1'b1) begin
    sc2mac_wt_data118_d1 <= sc2mac_wt_data118_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[118]) == 1'b0) begin
  end else begin
    sc2mac_wt_data118_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[119]) == 1'b1) begin
    sc2mac_wt_data119_d1 <= sc2mac_wt_data119_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[119]) == 1'b0) begin
  end else begin
    sc2mac_wt_data119_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[120]) == 1'b1) begin
    sc2mac_wt_data120_d1 <= sc2mac_wt_data120_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[120]) == 1'b0) begin
  end else begin
    sc2mac_wt_data120_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[121]) == 1'b1) begin
    sc2mac_wt_data121_d1 <= sc2mac_wt_data121_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[121]) == 1'b0) begin
  end else begin
    sc2mac_wt_data121_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[122]) == 1'b1) begin
    sc2mac_wt_data122_d1 <= sc2mac_wt_data122_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[122]) == 1'b0) begin
  end else begin
    sc2mac_wt_data122_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[123]) == 1'b1) begin
    sc2mac_wt_data123_d1 <= sc2mac_wt_data123_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[123]) == 1'b0) begin
  end else begin
    sc2mac_wt_data123_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[124]) == 1'b1) begin
    sc2mac_wt_data124_d1 <= sc2mac_wt_data124_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[124]) == 1'b0) begin
  end else begin
    sc2mac_wt_data124_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[125]) == 1'b1) begin
    sc2mac_wt_data125_d1 <= sc2mac_wt_data125_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[125]) == 1'b0) begin
  end else begin
    sc2mac_wt_data125_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[126]) == 1'b1) begin
    sc2mac_wt_data126_d1 <= sc2mac_wt_data126_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[126]) == 1'b0) begin
  end else begin
    sc2mac_wt_data126_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d0[127]) == 1'b1) begin
    sc2mac_wt_data127_d1 <= sc2mac_wt_data127_d0;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d0[127]) == 1'b0) begin
  end else begin
    sc2mac_wt_data127_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2mac_dat_pvld_d1 <= 1'b0;
  end else begin
  sc2mac_dat_pvld_d1 <= sc2mac_dat_pvld_d0;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2mac_dat_pd_d1 <= {9{1'b0}};
  end else begin
  if ((sc2mac_dat_pvld_d0 | sc2mac_dat_pvld_d1) == 1'b1) begin
    sc2mac_dat_pd_d1 <= sc2mac_dat_pd_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_pvld_d0 | sc2mac_dat_pvld_d1) == 1'b0) begin
  end else begin
    sc2mac_dat_pd_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sc2mac_dat_pvld_d0 | sc2mac_dat_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sc2mac_dat_mask_d1 <= {128{1'b0}};
  end else begin
  if ((sc2mac_dat_pvld_d0 | sc2mac_dat_pvld_d1) == 1'b1) begin
    sc2mac_dat_mask_d1 <= sc2mac_dat_mask_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_pvld_d0 | sc2mac_dat_pvld_d1) == 1'b0) begin
  end else begin
    sc2mac_dat_mask_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sc2mac_dat_pvld_d0 | sc2mac_dat_pvld_d1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  if ((sc2mac_dat_mask_d0[0]) == 1'b1) begin
    sc2mac_dat_data0_d1 <= sc2mac_dat_data0_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[0]) == 1'b0) begin
  end else begin
    sc2mac_dat_data0_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[1]) == 1'b1) begin
    sc2mac_dat_data1_d1 <= sc2mac_dat_data1_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[1]) == 1'b0) begin
  end else begin
    sc2mac_dat_data1_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[2]) == 1'b1) begin
    sc2mac_dat_data2_d1 <= sc2mac_dat_data2_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[2]) == 1'b0) begin
  end else begin
    sc2mac_dat_data2_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[3]) == 1'b1) begin
    sc2mac_dat_data3_d1 <= sc2mac_dat_data3_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[3]) == 1'b0) begin
  end else begin
    sc2mac_dat_data3_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[4]) == 1'b1) begin
    sc2mac_dat_data4_d1 <= sc2mac_dat_data4_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[4]) == 1'b0) begin
  end else begin
    sc2mac_dat_data4_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[5]) == 1'b1) begin
    sc2mac_dat_data5_d1 <= sc2mac_dat_data5_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[5]) == 1'b0) begin
  end else begin
    sc2mac_dat_data5_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[6]) == 1'b1) begin
    sc2mac_dat_data6_d1 <= sc2mac_dat_data6_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[6]) == 1'b0) begin
  end else begin
    sc2mac_dat_data6_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[7]) == 1'b1) begin
    sc2mac_dat_data7_d1 <= sc2mac_dat_data7_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[7]) == 1'b0) begin
  end else begin
    sc2mac_dat_data7_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[8]) == 1'b1) begin
    sc2mac_dat_data8_d1 <= sc2mac_dat_data8_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[8]) == 1'b0) begin
  end else begin
    sc2mac_dat_data8_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[9]) == 1'b1) begin
    sc2mac_dat_data9_d1 <= sc2mac_dat_data9_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[9]) == 1'b0) begin
  end else begin
    sc2mac_dat_data9_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[10]) == 1'b1) begin
    sc2mac_dat_data10_d1 <= sc2mac_dat_data10_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[10]) == 1'b0) begin
  end else begin
    sc2mac_dat_data10_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[11]) == 1'b1) begin
    sc2mac_dat_data11_d1 <= sc2mac_dat_data11_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[11]) == 1'b0) begin
  end else begin
    sc2mac_dat_data11_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[12]) == 1'b1) begin
    sc2mac_dat_data12_d1 <= sc2mac_dat_data12_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[12]) == 1'b0) begin
  end else begin
    sc2mac_dat_data12_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[13]) == 1'b1) begin
    sc2mac_dat_data13_d1 <= sc2mac_dat_data13_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[13]) == 1'b0) begin
  end else begin
    sc2mac_dat_data13_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[14]) == 1'b1) begin
    sc2mac_dat_data14_d1 <= sc2mac_dat_data14_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[14]) == 1'b0) begin
  end else begin
    sc2mac_dat_data14_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[15]) == 1'b1) begin
    sc2mac_dat_data15_d1 <= sc2mac_dat_data15_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[15]) == 1'b0) begin
  end else begin
    sc2mac_dat_data15_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[16]) == 1'b1) begin
    sc2mac_dat_data16_d1 <= sc2mac_dat_data16_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[16]) == 1'b0) begin
  end else begin
    sc2mac_dat_data16_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[17]) == 1'b1) begin
    sc2mac_dat_data17_d1 <= sc2mac_dat_data17_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[17]) == 1'b0) begin
  end else begin
    sc2mac_dat_data17_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[18]) == 1'b1) begin
    sc2mac_dat_data18_d1 <= sc2mac_dat_data18_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[18]) == 1'b0) begin
  end else begin
    sc2mac_dat_data18_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[19]) == 1'b1) begin
    sc2mac_dat_data19_d1 <= sc2mac_dat_data19_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[19]) == 1'b0) begin
  end else begin
    sc2mac_dat_data19_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[20]) == 1'b1) begin
    sc2mac_dat_data20_d1 <= sc2mac_dat_data20_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[20]) == 1'b0) begin
  end else begin
    sc2mac_dat_data20_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[21]) == 1'b1) begin
    sc2mac_dat_data21_d1 <= sc2mac_dat_data21_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[21]) == 1'b0) begin
  end else begin
    sc2mac_dat_data21_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[22]) == 1'b1) begin
    sc2mac_dat_data22_d1 <= sc2mac_dat_data22_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[22]) == 1'b0) begin
  end else begin
    sc2mac_dat_data22_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[23]) == 1'b1) begin
    sc2mac_dat_data23_d1 <= sc2mac_dat_data23_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[23]) == 1'b0) begin
  end else begin
    sc2mac_dat_data23_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[24]) == 1'b1) begin
    sc2mac_dat_data24_d1 <= sc2mac_dat_data24_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[24]) == 1'b0) begin
  end else begin
    sc2mac_dat_data24_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[25]) == 1'b1) begin
    sc2mac_dat_data25_d1 <= sc2mac_dat_data25_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[25]) == 1'b0) begin
  end else begin
    sc2mac_dat_data25_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[26]) == 1'b1) begin
    sc2mac_dat_data26_d1 <= sc2mac_dat_data26_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[26]) == 1'b0) begin
  end else begin
    sc2mac_dat_data26_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[27]) == 1'b1) begin
    sc2mac_dat_data27_d1 <= sc2mac_dat_data27_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[27]) == 1'b0) begin
  end else begin
    sc2mac_dat_data27_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[28]) == 1'b1) begin
    sc2mac_dat_data28_d1 <= sc2mac_dat_data28_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[28]) == 1'b0) begin
  end else begin
    sc2mac_dat_data28_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[29]) == 1'b1) begin
    sc2mac_dat_data29_d1 <= sc2mac_dat_data29_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[29]) == 1'b0) begin
  end else begin
    sc2mac_dat_data29_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[30]) == 1'b1) begin
    sc2mac_dat_data30_d1 <= sc2mac_dat_data30_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[30]) == 1'b0) begin
  end else begin
    sc2mac_dat_data30_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[31]) == 1'b1) begin
    sc2mac_dat_data31_d1 <= sc2mac_dat_data31_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[31]) == 1'b0) begin
  end else begin
    sc2mac_dat_data31_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[32]) == 1'b1) begin
    sc2mac_dat_data32_d1 <= sc2mac_dat_data32_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[32]) == 1'b0) begin
  end else begin
    sc2mac_dat_data32_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[33]) == 1'b1) begin
    sc2mac_dat_data33_d1 <= sc2mac_dat_data33_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[33]) == 1'b0) begin
  end else begin
    sc2mac_dat_data33_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[34]) == 1'b1) begin
    sc2mac_dat_data34_d1 <= sc2mac_dat_data34_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[34]) == 1'b0) begin
  end else begin
    sc2mac_dat_data34_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[35]) == 1'b1) begin
    sc2mac_dat_data35_d1 <= sc2mac_dat_data35_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[35]) == 1'b0) begin
  end else begin
    sc2mac_dat_data35_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[36]) == 1'b1) begin
    sc2mac_dat_data36_d1 <= sc2mac_dat_data36_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[36]) == 1'b0) begin
  end else begin
    sc2mac_dat_data36_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[37]) == 1'b1) begin
    sc2mac_dat_data37_d1 <= sc2mac_dat_data37_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[37]) == 1'b0) begin
  end else begin
    sc2mac_dat_data37_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[38]) == 1'b1) begin
    sc2mac_dat_data38_d1 <= sc2mac_dat_data38_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[38]) == 1'b0) begin
  end else begin
    sc2mac_dat_data38_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[39]) == 1'b1) begin
    sc2mac_dat_data39_d1 <= sc2mac_dat_data39_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[39]) == 1'b0) begin
  end else begin
    sc2mac_dat_data39_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[40]) == 1'b1) begin
    sc2mac_dat_data40_d1 <= sc2mac_dat_data40_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[40]) == 1'b0) begin
  end else begin
    sc2mac_dat_data40_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[41]) == 1'b1) begin
    sc2mac_dat_data41_d1 <= sc2mac_dat_data41_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[41]) == 1'b0) begin
  end else begin
    sc2mac_dat_data41_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[42]) == 1'b1) begin
    sc2mac_dat_data42_d1 <= sc2mac_dat_data42_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[42]) == 1'b0) begin
  end else begin
    sc2mac_dat_data42_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[43]) == 1'b1) begin
    sc2mac_dat_data43_d1 <= sc2mac_dat_data43_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[43]) == 1'b0) begin
  end else begin
    sc2mac_dat_data43_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[44]) == 1'b1) begin
    sc2mac_dat_data44_d1 <= sc2mac_dat_data44_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[44]) == 1'b0) begin
  end else begin
    sc2mac_dat_data44_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[45]) == 1'b1) begin
    sc2mac_dat_data45_d1 <= sc2mac_dat_data45_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[45]) == 1'b0) begin
  end else begin
    sc2mac_dat_data45_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[46]) == 1'b1) begin
    sc2mac_dat_data46_d1 <= sc2mac_dat_data46_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[46]) == 1'b0) begin
  end else begin
    sc2mac_dat_data46_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[47]) == 1'b1) begin
    sc2mac_dat_data47_d1 <= sc2mac_dat_data47_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[47]) == 1'b0) begin
  end else begin
    sc2mac_dat_data47_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[48]) == 1'b1) begin
    sc2mac_dat_data48_d1 <= sc2mac_dat_data48_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[48]) == 1'b0) begin
  end else begin
    sc2mac_dat_data48_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[49]) == 1'b1) begin
    sc2mac_dat_data49_d1 <= sc2mac_dat_data49_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[49]) == 1'b0) begin
  end else begin
    sc2mac_dat_data49_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[50]) == 1'b1) begin
    sc2mac_dat_data50_d1 <= sc2mac_dat_data50_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[50]) == 1'b0) begin
  end else begin
    sc2mac_dat_data50_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[51]) == 1'b1) begin
    sc2mac_dat_data51_d1 <= sc2mac_dat_data51_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[51]) == 1'b0) begin
  end else begin
    sc2mac_dat_data51_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[52]) == 1'b1) begin
    sc2mac_dat_data52_d1 <= sc2mac_dat_data52_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[52]) == 1'b0) begin
  end else begin
    sc2mac_dat_data52_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[53]) == 1'b1) begin
    sc2mac_dat_data53_d1 <= sc2mac_dat_data53_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[53]) == 1'b0) begin
  end else begin
    sc2mac_dat_data53_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[54]) == 1'b1) begin
    sc2mac_dat_data54_d1 <= sc2mac_dat_data54_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[54]) == 1'b0) begin
  end else begin
    sc2mac_dat_data54_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[55]) == 1'b1) begin
    sc2mac_dat_data55_d1 <= sc2mac_dat_data55_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[55]) == 1'b0) begin
  end else begin
    sc2mac_dat_data55_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[56]) == 1'b1) begin
    sc2mac_dat_data56_d1 <= sc2mac_dat_data56_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[56]) == 1'b0) begin
  end else begin
    sc2mac_dat_data56_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[57]) == 1'b1) begin
    sc2mac_dat_data57_d1 <= sc2mac_dat_data57_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[57]) == 1'b0) begin
  end else begin
    sc2mac_dat_data57_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[58]) == 1'b1) begin
    sc2mac_dat_data58_d1 <= sc2mac_dat_data58_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[58]) == 1'b0) begin
  end else begin
    sc2mac_dat_data58_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[59]) == 1'b1) begin
    sc2mac_dat_data59_d1 <= sc2mac_dat_data59_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[59]) == 1'b0) begin
  end else begin
    sc2mac_dat_data59_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[60]) == 1'b1) begin
    sc2mac_dat_data60_d1 <= sc2mac_dat_data60_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[60]) == 1'b0) begin
  end else begin
    sc2mac_dat_data60_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[61]) == 1'b1) begin
    sc2mac_dat_data61_d1 <= sc2mac_dat_data61_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[61]) == 1'b0) begin
  end else begin
    sc2mac_dat_data61_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[62]) == 1'b1) begin
    sc2mac_dat_data62_d1 <= sc2mac_dat_data62_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[62]) == 1'b0) begin
  end else begin
    sc2mac_dat_data62_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[63]) == 1'b1) begin
    sc2mac_dat_data63_d1 <= sc2mac_dat_data63_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[63]) == 1'b0) begin
  end else begin
    sc2mac_dat_data63_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[64]) == 1'b1) begin
    sc2mac_dat_data64_d1 <= sc2mac_dat_data64_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[64]) == 1'b0) begin
  end else begin
    sc2mac_dat_data64_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[65]) == 1'b1) begin
    sc2mac_dat_data65_d1 <= sc2mac_dat_data65_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[65]) == 1'b0) begin
  end else begin
    sc2mac_dat_data65_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[66]) == 1'b1) begin
    sc2mac_dat_data66_d1 <= sc2mac_dat_data66_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[66]) == 1'b0) begin
  end else begin
    sc2mac_dat_data66_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[67]) == 1'b1) begin
    sc2mac_dat_data67_d1 <= sc2mac_dat_data67_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[67]) == 1'b0) begin
  end else begin
    sc2mac_dat_data67_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[68]) == 1'b1) begin
    sc2mac_dat_data68_d1 <= sc2mac_dat_data68_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[68]) == 1'b0) begin
  end else begin
    sc2mac_dat_data68_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[69]) == 1'b1) begin
    sc2mac_dat_data69_d1 <= sc2mac_dat_data69_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[69]) == 1'b0) begin
  end else begin
    sc2mac_dat_data69_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[70]) == 1'b1) begin
    sc2mac_dat_data70_d1 <= sc2mac_dat_data70_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[70]) == 1'b0) begin
  end else begin
    sc2mac_dat_data70_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[71]) == 1'b1) begin
    sc2mac_dat_data71_d1 <= sc2mac_dat_data71_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[71]) == 1'b0) begin
  end else begin
    sc2mac_dat_data71_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[72]) == 1'b1) begin
    sc2mac_dat_data72_d1 <= sc2mac_dat_data72_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[72]) == 1'b0) begin
  end else begin
    sc2mac_dat_data72_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[73]) == 1'b1) begin
    sc2mac_dat_data73_d1 <= sc2mac_dat_data73_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[73]) == 1'b0) begin
  end else begin
    sc2mac_dat_data73_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[74]) == 1'b1) begin
    sc2mac_dat_data74_d1 <= sc2mac_dat_data74_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[74]) == 1'b0) begin
  end else begin
    sc2mac_dat_data74_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[75]) == 1'b1) begin
    sc2mac_dat_data75_d1 <= sc2mac_dat_data75_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[75]) == 1'b0) begin
  end else begin
    sc2mac_dat_data75_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[76]) == 1'b1) begin
    sc2mac_dat_data76_d1 <= sc2mac_dat_data76_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[76]) == 1'b0) begin
  end else begin
    sc2mac_dat_data76_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[77]) == 1'b1) begin
    sc2mac_dat_data77_d1 <= sc2mac_dat_data77_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[77]) == 1'b0) begin
  end else begin
    sc2mac_dat_data77_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[78]) == 1'b1) begin
    sc2mac_dat_data78_d1 <= sc2mac_dat_data78_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[78]) == 1'b0) begin
  end else begin
    sc2mac_dat_data78_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[79]) == 1'b1) begin
    sc2mac_dat_data79_d1 <= sc2mac_dat_data79_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[79]) == 1'b0) begin
  end else begin
    sc2mac_dat_data79_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[80]) == 1'b1) begin
    sc2mac_dat_data80_d1 <= sc2mac_dat_data80_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[80]) == 1'b0) begin
  end else begin
    sc2mac_dat_data80_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[81]) == 1'b1) begin
    sc2mac_dat_data81_d1 <= sc2mac_dat_data81_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[81]) == 1'b0) begin
  end else begin
    sc2mac_dat_data81_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[82]) == 1'b1) begin
    sc2mac_dat_data82_d1 <= sc2mac_dat_data82_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[82]) == 1'b0) begin
  end else begin
    sc2mac_dat_data82_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[83]) == 1'b1) begin
    sc2mac_dat_data83_d1 <= sc2mac_dat_data83_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[83]) == 1'b0) begin
  end else begin
    sc2mac_dat_data83_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[84]) == 1'b1) begin
    sc2mac_dat_data84_d1 <= sc2mac_dat_data84_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[84]) == 1'b0) begin
  end else begin
    sc2mac_dat_data84_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[85]) == 1'b1) begin
    sc2mac_dat_data85_d1 <= sc2mac_dat_data85_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[85]) == 1'b0) begin
  end else begin
    sc2mac_dat_data85_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[86]) == 1'b1) begin
    sc2mac_dat_data86_d1 <= sc2mac_dat_data86_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[86]) == 1'b0) begin
  end else begin
    sc2mac_dat_data86_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[87]) == 1'b1) begin
    sc2mac_dat_data87_d1 <= sc2mac_dat_data87_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[87]) == 1'b0) begin
  end else begin
    sc2mac_dat_data87_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[88]) == 1'b1) begin
    sc2mac_dat_data88_d1 <= sc2mac_dat_data88_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[88]) == 1'b0) begin
  end else begin
    sc2mac_dat_data88_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[89]) == 1'b1) begin
    sc2mac_dat_data89_d1 <= sc2mac_dat_data89_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[89]) == 1'b0) begin
  end else begin
    sc2mac_dat_data89_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[90]) == 1'b1) begin
    sc2mac_dat_data90_d1 <= sc2mac_dat_data90_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[90]) == 1'b0) begin
  end else begin
    sc2mac_dat_data90_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[91]) == 1'b1) begin
    sc2mac_dat_data91_d1 <= sc2mac_dat_data91_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[91]) == 1'b0) begin
  end else begin
    sc2mac_dat_data91_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[92]) == 1'b1) begin
    sc2mac_dat_data92_d1 <= sc2mac_dat_data92_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[92]) == 1'b0) begin
  end else begin
    sc2mac_dat_data92_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[93]) == 1'b1) begin
    sc2mac_dat_data93_d1 <= sc2mac_dat_data93_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[93]) == 1'b0) begin
  end else begin
    sc2mac_dat_data93_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[94]) == 1'b1) begin
    sc2mac_dat_data94_d1 <= sc2mac_dat_data94_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[94]) == 1'b0) begin
  end else begin
    sc2mac_dat_data94_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[95]) == 1'b1) begin
    sc2mac_dat_data95_d1 <= sc2mac_dat_data95_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[95]) == 1'b0) begin
  end else begin
    sc2mac_dat_data95_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[96]) == 1'b1) begin
    sc2mac_dat_data96_d1 <= sc2mac_dat_data96_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[96]) == 1'b0) begin
  end else begin
    sc2mac_dat_data96_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[97]) == 1'b1) begin
    sc2mac_dat_data97_d1 <= sc2mac_dat_data97_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[97]) == 1'b0) begin
  end else begin
    sc2mac_dat_data97_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[98]) == 1'b1) begin
    sc2mac_dat_data98_d1 <= sc2mac_dat_data98_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[98]) == 1'b0) begin
  end else begin
    sc2mac_dat_data98_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[99]) == 1'b1) begin
    sc2mac_dat_data99_d1 <= sc2mac_dat_data99_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[99]) == 1'b0) begin
  end else begin
    sc2mac_dat_data99_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[100]) == 1'b1) begin
    sc2mac_dat_data100_d1 <= sc2mac_dat_data100_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[100]) == 1'b0) begin
  end else begin
    sc2mac_dat_data100_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[101]) == 1'b1) begin
    sc2mac_dat_data101_d1 <= sc2mac_dat_data101_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[101]) == 1'b0) begin
  end else begin
    sc2mac_dat_data101_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[102]) == 1'b1) begin
    sc2mac_dat_data102_d1 <= sc2mac_dat_data102_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[102]) == 1'b0) begin
  end else begin
    sc2mac_dat_data102_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[103]) == 1'b1) begin
    sc2mac_dat_data103_d1 <= sc2mac_dat_data103_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[103]) == 1'b0) begin
  end else begin
    sc2mac_dat_data103_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[104]) == 1'b1) begin
    sc2mac_dat_data104_d1 <= sc2mac_dat_data104_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[104]) == 1'b0) begin
  end else begin
    sc2mac_dat_data104_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[105]) == 1'b1) begin
    sc2mac_dat_data105_d1 <= sc2mac_dat_data105_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[105]) == 1'b0) begin
  end else begin
    sc2mac_dat_data105_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[106]) == 1'b1) begin
    sc2mac_dat_data106_d1 <= sc2mac_dat_data106_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[106]) == 1'b0) begin
  end else begin
    sc2mac_dat_data106_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[107]) == 1'b1) begin
    sc2mac_dat_data107_d1 <= sc2mac_dat_data107_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[107]) == 1'b0) begin
  end else begin
    sc2mac_dat_data107_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[108]) == 1'b1) begin
    sc2mac_dat_data108_d1 <= sc2mac_dat_data108_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[108]) == 1'b0) begin
  end else begin
    sc2mac_dat_data108_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[109]) == 1'b1) begin
    sc2mac_dat_data109_d1 <= sc2mac_dat_data109_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[109]) == 1'b0) begin
  end else begin
    sc2mac_dat_data109_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[110]) == 1'b1) begin
    sc2mac_dat_data110_d1 <= sc2mac_dat_data110_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[110]) == 1'b0) begin
  end else begin
    sc2mac_dat_data110_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[111]) == 1'b1) begin
    sc2mac_dat_data111_d1 <= sc2mac_dat_data111_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[111]) == 1'b0) begin
  end else begin
    sc2mac_dat_data111_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[112]) == 1'b1) begin
    sc2mac_dat_data112_d1 <= sc2mac_dat_data112_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[112]) == 1'b0) begin
  end else begin
    sc2mac_dat_data112_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[113]) == 1'b1) begin
    sc2mac_dat_data113_d1 <= sc2mac_dat_data113_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[113]) == 1'b0) begin
  end else begin
    sc2mac_dat_data113_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[114]) == 1'b1) begin
    sc2mac_dat_data114_d1 <= sc2mac_dat_data114_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[114]) == 1'b0) begin
  end else begin
    sc2mac_dat_data114_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[115]) == 1'b1) begin
    sc2mac_dat_data115_d1 <= sc2mac_dat_data115_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[115]) == 1'b0) begin
  end else begin
    sc2mac_dat_data115_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[116]) == 1'b1) begin
    sc2mac_dat_data116_d1 <= sc2mac_dat_data116_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[116]) == 1'b0) begin
  end else begin
    sc2mac_dat_data116_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[117]) == 1'b1) begin
    sc2mac_dat_data117_d1 <= sc2mac_dat_data117_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[117]) == 1'b0) begin
  end else begin
    sc2mac_dat_data117_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[118]) == 1'b1) begin
    sc2mac_dat_data118_d1 <= sc2mac_dat_data118_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[118]) == 1'b0) begin
  end else begin
    sc2mac_dat_data118_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[119]) == 1'b1) begin
    sc2mac_dat_data119_d1 <= sc2mac_dat_data119_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[119]) == 1'b0) begin
  end else begin
    sc2mac_dat_data119_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[120]) == 1'b1) begin
    sc2mac_dat_data120_d1 <= sc2mac_dat_data120_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[120]) == 1'b0) begin
  end else begin
    sc2mac_dat_data120_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[121]) == 1'b1) begin
    sc2mac_dat_data121_d1 <= sc2mac_dat_data121_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[121]) == 1'b0) begin
  end else begin
    sc2mac_dat_data121_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[122]) == 1'b1) begin
    sc2mac_dat_data122_d1 <= sc2mac_dat_data122_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[122]) == 1'b0) begin
  end else begin
    sc2mac_dat_data122_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[123]) == 1'b1) begin
    sc2mac_dat_data123_d1 <= sc2mac_dat_data123_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[123]) == 1'b0) begin
  end else begin
    sc2mac_dat_data123_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[124]) == 1'b1) begin
    sc2mac_dat_data124_d1 <= sc2mac_dat_data124_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[124]) == 1'b0) begin
  end else begin
    sc2mac_dat_data124_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[125]) == 1'b1) begin
    sc2mac_dat_data125_d1 <= sc2mac_dat_data125_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[125]) == 1'b0) begin
  end else begin
    sc2mac_dat_data125_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[126]) == 1'b1) begin
    sc2mac_dat_data126_d1 <= sc2mac_dat_data126_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[126]) == 1'b0) begin
  end else begin
    sc2mac_dat_data126_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d0[127]) == 1'b1) begin
    sc2mac_dat_data127_d1 <= sc2mac_dat_data127_d0;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d0[127]) == 1'b0) begin
  end else begin
    sc2mac_dat_data127_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2mac_wt_pvld_d2 <= 1'b0;
  end else begin
  sc2mac_wt_pvld_d2 <= sc2mac_wt_pvld_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2mac_wt_sel_d2 <= {8{1'b0}};
  end else begin
  if ((sc2mac_wt_pvld_d1 | sc2mac_wt_pvld_d2) == 1'b1) begin
    sc2mac_wt_sel_d2 <= sc2mac_wt_sel_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_pvld_d1 | sc2mac_wt_pvld_d2) == 1'b0) begin
  end else begin
    sc2mac_wt_sel_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sc2mac_wt_pvld_d1 | sc2mac_wt_pvld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sc2mac_wt_mask_d2 <= {128{1'b0}};
  end else begin
  if ((sc2mac_wt_pvld_d1 | sc2mac_wt_pvld_d2) == 1'b1) begin
    sc2mac_wt_mask_d2 <= sc2mac_wt_mask_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_pvld_d1 | sc2mac_wt_pvld_d2) == 1'b0) begin
  end else begin
    sc2mac_wt_mask_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sc2mac_wt_pvld_d1 | sc2mac_wt_pvld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  if ((sc2mac_wt_mask_d1[0]) == 1'b1) begin
    sc2mac_wt_data0_d2 <= sc2mac_wt_data0_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[0]) == 1'b0) begin
  end else begin
    sc2mac_wt_data0_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[1]) == 1'b1) begin
    sc2mac_wt_data1_d2 <= sc2mac_wt_data1_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[1]) == 1'b0) begin
  end else begin
    sc2mac_wt_data1_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[2]) == 1'b1) begin
    sc2mac_wt_data2_d2 <= sc2mac_wt_data2_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[2]) == 1'b0) begin
  end else begin
    sc2mac_wt_data2_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[3]) == 1'b1) begin
    sc2mac_wt_data3_d2 <= sc2mac_wt_data3_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[3]) == 1'b0) begin
  end else begin
    sc2mac_wt_data3_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[4]) == 1'b1) begin
    sc2mac_wt_data4_d2 <= sc2mac_wt_data4_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[4]) == 1'b0) begin
  end else begin
    sc2mac_wt_data4_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[5]) == 1'b1) begin
    sc2mac_wt_data5_d2 <= sc2mac_wt_data5_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[5]) == 1'b0) begin
  end else begin
    sc2mac_wt_data5_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[6]) == 1'b1) begin
    sc2mac_wt_data6_d2 <= sc2mac_wt_data6_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[6]) == 1'b0) begin
  end else begin
    sc2mac_wt_data6_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[7]) == 1'b1) begin
    sc2mac_wt_data7_d2 <= sc2mac_wt_data7_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[7]) == 1'b0) begin
  end else begin
    sc2mac_wt_data7_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[8]) == 1'b1) begin
    sc2mac_wt_data8_d2 <= sc2mac_wt_data8_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[8]) == 1'b0) begin
  end else begin
    sc2mac_wt_data8_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[9]) == 1'b1) begin
    sc2mac_wt_data9_d2 <= sc2mac_wt_data9_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[9]) == 1'b0) begin
  end else begin
    sc2mac_wt_data9_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[10]) == 1'b1) begin
    sc2mac_wt_data10_d2 <= sc2mac_wt_data10_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[10]) == 1'b0) begin
  end else begin
    sc2mac_wt_data10_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[11]) == 1'b1) begin
    sc2mac_wt_data11_d2 <= sc2mac_wt_data11_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[11]) == 1'b0) begin
  end else begin
    sc2mac_wt_data11_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[12]) == 1'b1) begin
    sc2mac_wt_data12_d2 <= sc2mac_wt_data12_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[12]) == 1'b0) begin
  end else begin
    sc2mac_wt_data12_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[13]) == 1'b1) begin
    sc2mac_wt_data13_d2 <= sc2mac_wt_data13_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[13]) == 1'b0) begin
  end else begin
    sc2mac_wt_data13_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[14]) == 1'b1) begin
    sc2mac_wt_data14_d2 <= sc2mac_wt_data14_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[14]) == 1'b0) begin
  end else begin
    sc2mac_wt_data14_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[15]) == 1'b1) begin
    sc2mac_wt_data15_d2 <= sc2mac_wt_data15_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[15]) == 1'b0) begin
  end else begin
    sc2mac_wt_data15_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[16]) == 1'b1) begin
    sc2mac_wt_data16_d2 <= sc2mac_wt_data16_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[16]) == 1'b0) begin
  end else begin
    sc2mac_wt_data16_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[17]) == 1'b1) begin
    sc2mac_wt_data17_d2 <= sc2mac_wt_data17_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[17]) == 1'b0) begin
  end else begin
    sc2mac_wt_data17_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[18]) == 1'b1) begin
    sc2mac_wt_data18_d2 <= sc2mac_wt_data18_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[18]) == 1'b0) begin
  end else begin
    sc2mac_wt_data18_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[19]) == 1'b1) begin
    sc2mac_wt_data19_d2 <= sc2mac_wt_data19_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[19]) == 1'b0) begin
  end else begin
    sc2mac_wt_data19_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[20]) == 1'b1) begin
    sc2mac_wt_data20_d2 <= sc2mac_wt_data20_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[20]) == 1'b0) begin
  end else begin
    sc2mac_wt_data20_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[21]) == 1'b1) begin
    sc2mac_wt_data21_d2 <= sc2mac_wt_data21_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[21]) == 1'b0) begin
  end else begin
    sc2mac_wt_data21_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[22]) == 1'b1) begin
    sc2mac_wt_data22_d2 <= sc2mac_wt_data22_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[22]) == 1'b0) begin
  end else begin
    sc2mac_wt_data22_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[23]) == 1'b1) begin
    sc2mac_wt_data23_d2 <= sc2mac_wt_data23_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[23]) == 1'b0) begin
  end else begin
    sc2mac_wt_data23_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[24]) == 1'b1) begin
    sc2mac_wt_data24_d2 <= sc2mac_wt_data24_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[24]) == 1'b0) begin
  end else begin
    sc2mac_wt_data24_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[25]) == 1'b1) begin
    sc2mac_wt_data25_d2 <= sc2mac_wt_data25_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[25]) == 1'b0) begin
  end else begin
    sc2mac_wt_data25_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[26]) == 1'b1) begin
    sc2mac_wt_data26_d2 <= sc2mac_wt_data26_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[26]) == 1'b0) begin
  end else begin
    sc2mac_wt_data26_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[27]) == 1'b1) begin
    sc2mac_wt_data27_d2 <= sc2mac_wt_data27_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[27]) == 1'b0) begin
  end else begin
    sc2mac_wt_data27_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[28]) == 1'b1) begin
    sc2mac_wt_data28_d2 <= sc2mac_wt_data28_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[28]) == 1'b0) begin
  end else begin
    sc2mac_wt_data28_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[29]) == 1'b1) begin
    sc2mac_wt_data29_d2 <= sc2mac_wt_data29_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[29]) == 1'b0) begin
  end else begin
    sc2mac_wt_data29_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[30]) == 1'b1) begin
    sc2mac_wt_data30_d2 <= sc2mac_wt_data30_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[30]) == 1'b0) begin
  end else begin
    sc2mac_wt_data30_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[31]) == 1'b1) begin
    sc2mac_wt_data31_d2 <= sc2mac_wt_data31_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[31]) == 1'b0) begin
  end else begin
    sc2mac_wt_data31_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[32]) == 1'b1) begin
    sc2mac_wt_data32_d2 <= sc2mac_wt_data32_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[32]) == 1'b0) begin
  end else begin
    sc2mac_wt_data32_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[33]) == 1'b1) begin
    sc2mac_wt_data33_d2 <= sc2mac_wt_data33_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[33]) == 1'b0) begin
  end else begin
    sc2mac_wt_data33_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[34]) == 1'b1) begin
    sc2mac_wt_data34_d2 <= sc2mac_wt_data34_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[34]) == 1'b0) begin
  end else begin
    sc2mac_wt_data34_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[35]) == 1'b1) begin
    sc2mac_wt_data35_d2 <= sc2mac_wt_data35_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[35]) == 1'b0) begin
  end else begin
    sc2mac_wt_data35_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[36]) == 1'b1) begin
    sc2mac_wt_data36_d2 <= sc2mac_wt_data36_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[36]) == 1'b0) begin
  end else begin
    sc2mac_wt_data36_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[37]) == 1'b1) begin
    sc2mac_wt_data37_d2 <= sc2mac_wt_data37_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[37]) == 1'b0) begin
  end else begin
    sc2mac_wt_data37_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[38]) == 1'b1) begin
    sc2mac_wt_data38_d2 <= sc2mac_wt_data38_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[38]) == 1'b0) begin
  end else begin
    sc2mac_wt_data38_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[39]) == 1'b1) begin
    sc2mac_wt_data39_d2 <= sc2mac_wt_data39_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[39]) == 1'b0) begin
  end else begin
    sc2mac_wt_data39_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[40]) == 1'b1) begin
    sc2mac_wt_data40_d2 <= sc2mac_wt_data40_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[40]) == 1'b0) begin
  end else begin
    sc2mac_wt_data40_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[41]) == 1'b1) begin
    sc2mac_wt_data41_d2 <= sc2mac_wt_data41_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[41]) == 1'b0) begin
  end else begin
    sc2mac_wt_data41_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[42]) == 1'b1) begin
    sc2mac_wt_data42_d2 <= sc2mac_wt_data42_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[42]) == 1'b0) begin
  end else begin
    sc2mac_wt_data42_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[43]) == 1'b1) begin
    sc2mac_wt_data43_d2 <= sc2mac_wt_data43_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[43]) == 1'b0) begin
  end else begin
    sc2mac_wt_data43_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[44]) == 1'b1) begin
    sc2mac_wt_data44_d2 <= sc2mac_wt_data44_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[44]) == 1'b0) begin
  end else begin
    sc2mac_wt_data44_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[45]) == 1'b1) begin
    sc2mac_wt_data45_d2 <= sc2mac_wt_data45_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[45]) == 1'b0) begin
  end else begin
    sc2mac_wt_data45_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[46]) == 1'b1) begin
    sc2mac_wt_data46_d2 <= sc2mac_wt_data46_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[46]) == 1'b0) begin
  end else begin
    sc2mac_wt_data46_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[47]) == 1'b1) begin
    sc2mac_wt_data47_d2 <= sc2mac_wt_data47_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[47]) == 1'b0) begin
  end else begin
    sc2mac_wt_data47_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[48]) == 1'b1) begin
    sc2mac_wt_data48_d2 <= sc2mac_wt_data48_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[48]) == 1'b0) begin
  end else begin
    sc2mac_wt_data48_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[49]) == 1'b1) begin
    sc2mac_wt_data49_d2 <= sc2mac_wt_data49_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[49]) == 1'b0) begin
  end else begin
    sc2mac_wt_data49_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[50]) == 1'b1) begin
    sc2mac_wt_data50_d2 <= sc2mac_wt_data50_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[50]) == 1'b0) begin
  end else begin
    sc2mac_wt_data50_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[51]) == 1'b1) begin
    sc2mac_wt_data51_d2 <= sc2mac_wt_data51_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[51]) == 1'b0) begin
  end else begin
    sc2mac_wt_data51_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[52]) == 1'b1) begin
    sc2mac_wt_data52_d2 <= sc2mac_wt_data52_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[52]) == 1'b0) begin
  end else begin
    sc2mac_wt_data52_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[53]) == 1'b1) begin
    sc2mac_wt_data53_d2 <= sc2mac_wt_data53_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[53]) == 1'b0) begin
  end else begin
    sc2mac_wt_data53_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[54]) == 1'b1) begin
    sc2mac_wt_data54_d2 <= sc2mac_wt_data54_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[54]) == 1'b0) begin
  end else begin
    sc2mac_wt_data54_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[55]) == 1'b1) begin
    sc2mac_wt_data55_d2 <= sc2mac_wt_data55_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[55]) == 1'b0) begin
  end else begin
    sc2mac_wt_data55_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[56]) == 1'b1) begin
    sc2mac_wt_data56_d2 <= sc2mac_wt_data56_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[56]) == 1'b0) begin
  end else begin
    sc2mac_wt_data56_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[57]) == 1'b1) begin
    sc2mac_wt_data57_d2 <= sc2mac_wt_data57_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[57]) == 1'b0) begin
  end else begin
    sc2mac_wt_data57_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[58]) == 1'b1) begin
    sc2mac_wt_data58_d2 <= sc2mac_wt_data58_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[58]) == 1'b0) begin
  end else begin
    sc2mac_wt_data58_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[59]) == 1'b1) begin
    sc2mac_wt_data59_d2 <= sc2mac_wt_data59_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[59]) == 1'b0) begin
  end else begin
    sc2mac_wt_data59_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[60]) == 1'b1) begin
    sc2mac_wt_data60_d2 <= sc2mac_wt_data60_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[60]) == 1'b0) begin
  end else begin
    sc2mac_wt_data60_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[61]) == 1'b1) begin
    sc2mac_wt_data61_d2 <= sc2mac_wt_data61_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[61]) == 1'b0) begin
  end else begin
    sc2mac_wt_data61_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[62]) == 1'b1) begin
    sc2mac_wt_data62_d2 <= sc2mac_wt_data62_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[62]) == 1'b0) begin
  end else begin
    sc2mac_wt_data62_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[63]) == 1'b1) begin
    sc2mac_wt_data63_d2 <= sc2mac_wt_data63_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[63]) == 1'b0) begin
  end else begin
    sc2mac_wt_data63_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[64]) == 1'b1) begin
    sc2mac_wt_data64_d2 <= sc2mac_wt_data64_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[64]) == 1'b0) begin
  end else begin
    sc2mac_wt_data64_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[65]) == 1'b1) begin
    sc2mac_wt_data65_d2 <= sc2mac_wt_data65_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[65]) == 1'b0) begin
  end else begin
    sc2mac_wt_data65_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[66]) == 1'b1) begin
    sc2mac_wt_data66_d2 <= sc2mac_wt_data66_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[66]) == 1'b0) begin
  end else begin
    sc2mac_wt_data66_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[67]) == 1'b1) begin
    sc2mac_wt_data67_d2 <= sc2mac_wt_data67_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[67]) == 1'b0) begin
  end else begin
    sc2mac_wt_data67_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[68]) == 1'b1) begin
    sc2mac_wt_data68_d2 <= sc2mac_wt_data68_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[68]) == 1'b0) begin
  end else begin
    sc2mac_wt_data68_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[69]) == 1'b1) begin
    sc2mac_wt_data69_d2 <= sc2mac_wt_data69_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[69]) == 1'b0) begin
  end else begin
    sc2mac_wt_data69_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[70]) == 1'b1) begin
    sc2mac_wt_data70_d2 <= sc2mac_wt_data70_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[70]) == 1'b0) begin
  end else begin
    sc2mac_wt_data70_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[71]) == 1'b1) begin
    sc2mac_wt_data71_d2 <= sc2mac_wt_data71_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[71]) == 1'b0) begin
  end else begin
    sc2mac_wt_data71_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[72]) == 1'b1) begin
    sc2mac_wt_data72_d2 <= sc2mac_wt_data72_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[72]) == 1'b0) begin
  end else begin
    sc2mac_wt_data72_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[73]) == 1'b1) begin
    sc2mac_wt_data73_d2 <= sc2mac_wt_data73_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[73]) == 1'b0) begin
  end else begin
    sc2mac_wt_data73_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[74]) == 1'b1) begin
    sc2mac_wt_data74_d2 <= sc2mac_wt_data74_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[74]) == 1'b0) begin
  end else begin
    sc2mac_wt_data74_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[75]) == 1'b1) begin
    sc2mac_wt_data75_d2 <= sc2mac_wt_data75_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[75]) == 1'b0) begin
  end else begin
    sc2mac_wt_data75_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[76]) == 1'b1) begin
    sc2mac_wt_data76_d2 <= sc2mac_wt_data76_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[76]) == 1'b0) begin
  end else begin
    sc2mac_wt_data76_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[77]) == 1'b1) begin
    sc2mac_wt_data77_d2 <= sc2mac_wt_data77_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[77]) == 1'b0) begin
  end else begin
    sc2mac_wt_data77_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[78]) == 1'b1) begin
    sc2mac_wt_data78_d2 <= sc2mac_wt_data78_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[78]) == 1'b0) begin
  end else begin
    sc2mac_wt_data78_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[79]) == 1'b1) begin
    sc2mac_wt_data79_d2 <= sc2mac_wt_data79_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[79]) == 1'b0) begin
  end else begin
    sc2mac_wt_data79_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[80]) == 1'b1) begin
    sc2mac_wt_data80_d2 <= sc2mac_wt_data80_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[80]) == 1'b0) begin
  end else begin
    sc2mac_wt_data80_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[81]) == 1'b1) begin
    sc2mac_wt_data81_d2 <= sc2mac_wt_data81_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[81]) == 1'b0) begin
  end else begin
    sc2mac_wt_data81_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[82]) == 1'b1) begin
    sc2mac_wt_data82_d2 <= sc2mac_wt_data82_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[82]) == 1'b0) begin
  end else begin
    sc2mac_wt_data82_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[83]) == 1'b1) begin
    sc2mac_wt_data83_d2 <= sc2mac_wt_data83_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[83]) == 1'b0) begin
  end else begin
    sc2mac_wt_data83_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[84]) == 1'b1) begin
    sc2mac_wt_data84_d2 <= sc2mac_wt_data84_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[84]) == 1'b0) begin
  end else begin
    sc2mac_wt_data84_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[85]) == 1'b1) begin
    sc2mac_wt_data85_d2 <= sc2mac_wt_data85_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[85]) == 1'b0) begin
  end else begin
    sc2mac_wt_data85_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[86]) == 1'b1) begin
    sc2mac_wt_data86_d2 <= sc2mac_wt_data86_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[86]) == 1'b0) begin
  end else begin
    sc2mac_wt_data86_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[87]) == 1'b1) begin
    sc2mac_wt_data87_d2 <= sc2mac_wt_data87_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[87]) == 1'b0) begin
  end else begin
    sc2mac_wt_data87_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[88]) == 1'b1) begin
    sc2mac_wt_data88_d2 <= sc2mac_wt_data88_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[88]) == 1'b0) begin
  end else begin
    sc2mac_wt_data88_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[89]) == 1'b1) begin
    sc2mac_wt_data89_d2 <= sc2mac_wt_data89_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[89]) == 1'b0) begin
  end else begin
    sc2mac_wt_data89_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[90]) == 1'b1) begin
    sc2mac_wt_data90_d2 <= sc2mac_wt_data90_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[90]) == 1'b0) begin
  end else begin
    sc2mac_wt_data90_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[91]) == 1'b1) begin
    sc2mac_wt_data91_d2 <= sc2mac_wt_data91_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[91]) == 1'b0) begin
  end else begin
    sc2mac_wt_data91_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[92]) == 1'b1) begin
    sc2mac_wt_data92_d2 <= sc2mac_wt_data92_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[92]) == 1'b0) begin
  end else begin
    sc2mac_wt_data92_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[93]) == 1'b1) begin
    sc2mac_wt_data93_d2 <= sc2mac_wt_data93_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[93]) == 1'b0) begin
  end else begin
    sc2mac_wt_data93_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[94]) == 1'b1) begin
    sc2mac_wt_data94_d2 <= sc2mac_wt_data94_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[94]) == 1'b0) begin
  end else begin
    sc2mac_wt_data94_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[95]) == 1'b1) begin
    sc2mac_wt_data95_d2 <= sc2mac_wt_data95_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[95]) == 1'b0) begin
  end else begin
    sc2mac_wt_data95_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[96]) == 1'b1) begin
    sc2mac_wt_data96_d2 <= sc2mac_wt_data96_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[96]) == 1'b0) begin
  end else begin
    sc2mac_wt_data96_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[97]) == 1'b1) begin
    sc2mac_wt_data97_d2 <= sc2mac_wt_data97_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[97]) == 1'b0) begin
  end else begin
    sc2mac_wt_data97_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[98]) == 1'b1) begin
    sc2mac_wt_data98_d2 <= sc2mac_wt_data98_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[98]) == 1'b0) begin
  end else begin
    sc2mac_wt_data98_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[99]) == 1'b1) begin
    sc2mac_wt_data99_d2 <= sc2mac_wt_data99_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[99]) == 1'b0) begin
  end else begin
    sc2mac_wt_data99_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[100]) == 1'b1) begin
    sc2mac_wt_data100_d2 <= sc2mac_wt_data100_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[100]) == 1'b0) begin
  end else begin
    sc2mac_wt_data100_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[101]) == 1'b1) begin
    sc2mac_wt_data101_d2 <= sc2mac_wt_data101_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[101]) == 1'b0) begin
  end else begin
    sc2mac_wt_data101_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[102]) == 1'b1) begin
    sc2mac_wt_data102_d2 <= sc2mac_wt_data102_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[102]) == 1'b0) begin
  end else begin
    sc2mac_wt_data102_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[103]) == 1'b1) begin
    sc2mac_wt_data103_d2 <= sc2mac_wt_data103_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[103]) == 1'b0) begin
  end else begin
    sc2mac_wt_data103_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[104]) == 1'b1) begin
    sc2mac_wt_data104_d2 <= sc2mac_wt_data104_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[104]) == 1'b0) begin
  end else begin
    sc2mac_wt_data104_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[105]) == 1'b1) begin
    sc2mac_wt_data105_d2 <= sc2mac_wt_data105_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[105]) == 1'b0) begin
  end else begin
    sc2mac_wt_data105_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[106]) == 1'b1) begin
    sc2mac_wt_data106_d2 <= sc2mac_wt_data106_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[106]) == 1'b0) begin
  end else begin
    sc2mac_wt_data106_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[107]) == 1'b1) begin
    sc2mac_wt_data107_d2 <= sc2mac_wt_data107_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[107]) == 1'b0) begin
  end else begin
    sc2mac_wt_data107_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[108]) == 1'b1) begin
    sc2mac_wt_data108_d2 <= sc2mac_wt_data108_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[108]) == 1'b0) begin
  end else begin
    sc2mac_wt_data108_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[109]) == 1'b1) begin
    sc2mac_wt_data109_d2 <= sc2mac_wt_data109_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[109]) == 1'b0) begin
  end else begin
    sc2mac_wt_data109_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[110]) == 1'b1) begin
    sc2mac_wt_data110_d2 <= sc2mac_wt_data110_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[110]) == 1'b0) begin
  end else begin
    sc2mac_wt_data110_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[111]) == 1'b1) begin
    sc2mac_wt_data111_d2 <= sc2mac_wt_data111_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[111]) == 1'b0) begin
  end else begin
    sc2mac_wt_data111_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[112]) == 1'b1) begin
    sc2mac_wt_data112_d2 <= sc2mac_wt_data112_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[112]) == 1'b0) begin
  end else begin
    sc2mac_wt_data112_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[113]) == 1'b1) begin
    sc2mac_wt_data113_d2 <= sc2mac_wt_data113_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[113]) == 1'b0) begin
  end else begin
    sc2mac_wt_data113_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[114]) == 1'b1) begin
    sc2mac_wt_data114_d2 <= sc2mac_wt_data114_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[114]) == 1'b0) begin
  end else begin
    sc2mac_wt_data114_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[115]) == 1'b1) begin
    sc2mac_wt_data115_d2 <= sc2mac_wt_data115_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[115]) == 1'b0) begin
  end else begin
    sc2mac_wt_data115_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[116]) == 1'b1) begin
    sc2mac_wt_data116_d2 <= sc2mac_wt_data116_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[116]) == 1'b0) begin
  end else begin
    sc2mac_wt_data116_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[117]) == 1'b1) begin
    sc2mac_wt_data117_d2 <= sc2mac_wt_data117_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[117]) == 1'b0) begin
  end else begin
    sc2mac_wt_data117_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[118]) == 1'b1) begin
    sc2mac_wt_data118_d2 <= sc2mac_wt_data118_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[118]) == 1'b0) begin
  end else begin
    sc2mac_wt_data118_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[119]) == 1'b1) begin
    sc2mac_wt_data119_d2 <= sc2mac_wt_data119_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[119]) == 1'b0) begin
  end else begin
    sc2mac_wt_data119_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[120]) == 1'b1) begin
    sc2mac_wt_data120_d2 <= sc2mac_wt_data120_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[120]) == 1'b0) begin
  end else begin
    sc2mac_wt_data120_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[121]) == 1'b1) begin
    sc2mac_wt_data121_d2 <= sc2mac_wt_data121_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[121]) == 1'b0) begin
  end else begin
    sc2mac_wt_data121_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[122]) == 1'b1) begin
    sc2mac_wt_data122_d2 <= sc2mac_wt_data122_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[122]) == 1'b0) begin
  end else begin
    sc2mac_wt_data122_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[123]) == 1'b1) begin
    sc2mac_wt_data123_d2 <= sc2mac_wt_data123_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[123]) == 1'b0) begin
  end else begin
    sc2mac_wt_data123_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[124]) == 1'b1) begin
    sc2mac_wt_data124_d2 <= sc2mac_wt_data124_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[124]) == 1'b0) begin
  end else begin
    sc2mac_wt_data124_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[125]) == 1'b1) begin
    sc2mac_wt_data125_d2 <= sc2mac_wt_data125_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[125]) == 1'b0) begin
  end else begin
    sc2mac_wt_data125_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[126]) == 1'b1) begin
    sc2mac_wt_data126_d2 <= sc2mac_wt_data126_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[126]) == 1'b0) begin
  end else begin
    sc2mac_wt_data126_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_wt_mask_d1[127]) == 1'b1) begin
    sc2mac_wt_data127_d2 <= sc2mac_wt_data127_d1;
  // VCS coverage off
  end else if ((sc2mac_wt_mask_d1[127]) == 1'b0) begin
  end else begin
    sc2mac_wt_data127_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end


always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2mac_dat_pvld_d2 <= 1'b0;
  end else begin
  sc2mac_dat_pvld_d2 <= sc2mac_dat_pvld_d1;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sc2mac_dat_pd_d2 <= {9{1'b0}};
  end else begin
  if ((sc2mac_dat_pvld_d1 | sc2mac_dat_pvld_d2) == 1'b1) begin
    sc2mac_dat_pd_d2 <= sc2mac_dat_pd_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_pvld_d1 | sc2mac_dat_pvld_d2) == 1'b0) begin
  end else begin
    sc2mac_dat_pd_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sc2mac_dat_pvld_d1 | sc2mac_dat_pvld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
    sc2mac_dat_mask_d2 <= {128{1'b0}};
  end else begin
  if ((sc2mac_dat_pvld_d1 | sc2mac_dat_pvld_d2) == 1'b1) begin
    sc2mac_dat_mask_d2 <= sc2mac_dat_mask_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_pvld_d1 | sc2mac_dat_pvld_d2) == 1'b0) begin
  end else begin
    sc2mac_dat_mask_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(sc2mac_dat_pvld_d1 | sc2mac_dat_pvld_d2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  if ((sc2mac_dat_mask_d1[0]) == 1'b1) begin
    sc2mac_dat_data0_d2 <= sc2mac_dat_data0_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[0]) == 1'b0) begin
  end else begin
    sc2mac_dat_data0_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[1]) == 1'b1) begin
    sc2mac_dat_data1_d2 <= sc2mac_dat_data1_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[1]) == 1'b0) begin
  end else begin
    sc2mac_dat_data1_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[2]) == 1'b1) begin
    sc2mac_dat_data2_d2 <= sc2mac_dat_data2_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[2]) == 1'b0) begin
  end else begin
    sc2mac_dat_data2_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[3]) == 1'b1) begin
    sc2mac_dat_data3_d2 <= sc2mac_dat_data3_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[3]) == 1'b0) begin
  end else begin
    sc2mac_dat_data3_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[4]) == 1'b1) begin
    sc2mac_dat_data4_d2 <= sc2mac_dat_data4_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[4]) == 1'b0) begin
  end else begin
    sc2mac_dat_data4_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[5]) == 1'b1) begin
    sc2mac_dat_data5_d2 <= sc2mac_dat_data5_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[5]) == 1'b0) begin
  end else begin
    sc2mac_dat_data5_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[6]) == 1'b1) begin
    sc2mac_dat_data6_d2 <= sc2mac_dat_data6_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[6]) == 1'b0) begin
  end else begin
    sc2mac_dat_data6_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[7]) == 1'b1) begin
    sc2mac_dat_data7_d2 <= sc2mac_dat_data7_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[7]) == 1'b0) begin
  end else begin
    sc2mac_dat_data7_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[8]) == 1'b1) begin
    sc2mac_dat_data8_d2 <= sc2mac_dat_data8_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[8]) == 1'b0) begin
  end else begin
    sc2mac_dat_data8_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[9]) == 1'b1) begin
    sc2mac_dat_data9_d2 <= sc2mac_dat_data9_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[9]) == 1'b0) begin
  end else begin
    sc2mac_dat_data9_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[10]) == 1'b1) begin
    sc2mac_dat_data10_d2 <= sc2mac_dat_data10_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[10]) == 1'b0) begin
  end else begin
    sc2mac_dat_data10_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[11]) == 1'b1) begin
    sc2mac_dat_data11_d2 <= sc2mac_dat_data11_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[11]) == 1'b0) begin
  end else begin
    sc2mac_dat_data11_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[12]) == 1'b1) begin
    sc2mac_dat_data12_d2 <= sc2mac_dat_data12_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[12]) == 1'b0) begin
  end else begin
    sc2mac_dat_data12_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[13]) == 1'b1) begin
    sc2mac_dat_data13_d2 <= sc2mac_dat_data13_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[13]) == 1'b0) begin
  end else begin
    sc2mac_dat_data13_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[14]) == 1'b1) begin
    sc2mac_dat_data14_d2 <= sc2mac_dat_data14_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[14]) == 1'b0) begin
  end else begin
    sc2mac_dat_data14_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[15]) == 1'b1) begin
    sc2mac_dat_data15_d2 <= sc2mac_dat_data15_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[15]) == 1'b0) begin
  end else begin
    sc2mac_dat_data15_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[16]) == 1'b1) begin
    sc2mac_dat_data16_d2 <= sc2mac_dat_data16_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[16]) == 1'b0) begin
  end else begin
    sc2mac_dat_data16_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[17]) == 1'b1) begin
    sc2mac_dat_data17_d2 <= sc2mac_dat_data17_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[17]) == 1'b0) begin
  end else begin
    sc2mac_dat_data17_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[18]) == 1'b1) begin
    sc2mac_dat_data18_d2 <= sc2mac_dat_data18_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[18]) == 1'b0) begin
  end else begin
    sc2mac_dat_data18_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[19]) == 1'b1) begin
    sc2mac_dat_data19_d2 <= sc2mac_dat_data19_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[19]) == 1'b0) begin
  end else begin
    sc2mac_dat_data19_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[20]) == 1'b1) begin
    sc2mac_dat_data20_d2 <= sc2mac_dat_data20_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[20]) == 1'b0) begin
  end else begin
    sc2mac_dat_data20_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[21]) == 1'b1) begin
    sc2mac_dat_data21_d2 <= sc2mac_dat_data21_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[21]) == 1'b0) begin
  end else begin
    sc2mac_dat_data21_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[22]) == 1'b1) begin
    sc2mac_dat_data22_d2 <= sc2mac_dat_data22_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[22]) == 1'b0) begin
  end else begin
    sc2mac_dat_data22_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[23]) == 1'b1) begin
    sc2mac_dat_data23_d2 <= sc2mac_dat_data23_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[23]) == 1'b0) begin
  end else begin
    sc2mac_dat_data23_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[24]) == 1'b1) begin
    sc2mac_dat_data24_d2 <= sc2mac_dat_data24_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[24]) == 1'b0) begin
  end else begin
    sc2mac_dat_data24_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[25]) == 1'b1) begin
    sc2mac_dat_data25_d2 <= sc2mac_dat_data25_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[25]) == 1'b0) begin
  end else begin
    sc2mac_dat_data25_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[26]) == 1'b1) begin
    sc2mac_dat_data26_d2 <= sc2mac_dat_data26_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[26]) == 1'b0) begin
  end else begin
    sc2mac_dat_data26_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[27]) == 1'b1) begin
    sc2mac_dat_data27_d2 <= sc2mac_dat_data27_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[27]) == 1'b0) begin
  end else begin
    sc2mac_dat_data27_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[28]) == 1'b1) begin
    sc2mac_dat_data28_d2 <= sc2mac_dat_data28_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[28]) == 1'b0) begin
  end else begin
    sc2mac_dat_data28_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[29]) == 1'b1) begin
    sc2mac_dat_data29_d2 <= sc2mac_dat_data29_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[29]) == 1'b0) begin
  end else begin
    sc2mac_dat_data29_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[30]) == 1'b1) begin
    sc2mac_dat_data30_d2 <= sc2mac_dat_data30_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[30]) == 1'b0) begin
  end else begin
    sc2mac_dat_data30_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[31]) == 1'b1) begin
    sc2mac_dat_data31_d2 <= sc2mac_dat_data31_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[31]) == 1'b0) begin
  end else begin
    sc2mac_dat_data31_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[32]) == 1'b1) begin
    sc2mac_dat_data32_d2 <= sc2mac_dat_data32_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[32]) == 1'b0) begin
  end else begin
    sc2mac_dat_data32_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[33]) == 1'b1) begin
    sc2mac_dat_data33_d2 <= sc2mac_dat_data33_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[33]) == 1'b0) begin
  end else begin
    sc2mac_dat_data33_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[34]) == 1'b1) begin
    sc2mac_dat_data34_d2 <= sc2mac_dat_data34_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[34]) == 1'b0) begin
  end else begin
    sc2mac_dat_data34_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[35]) == 1'b1) begin
    sc2mac_dat_data35_d2 <= sc2mac_dat_data35_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[35]) == 1'b0) begin
  end else begin
    sc2mac_dat_data35_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[36]) == 1'b1) begin
    sc2mac_dat_data36_d2 <= sc2mac_dat_data36_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[36]) == 1'b0) begin
  end else begin
    sc2mac_dat_data36_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[37]) == 1'b1) begin
    sc2mac_dat_data37_d2 <= sc2mac_dat_data37_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[37]) == 1'b0) begin
  end else begin
    sc2mac_dat_data37_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[38]) == 1'b1) begin
    sc2mac_dat_data38_d2 <= sc2mac_dat_data38_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[38]) == 1'b0) begin
  end else begin
    sc2mac_dat_data38_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[39]) == 1'b1) begin
    sc2mac_dat_data39_d2 <= sc2mac_dat_data39_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[39]) == 1'b0) begin
  end else begin
    sc2mac_dat_data39_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[40]) == 1'b1) begin
    sc2mac_dat_data40_d2 <= sc2mac_dat_data40_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[40]) == 1'b0) begin
  end else begin
    sc2mac_dat_data40_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[41]) == 1'b1) begin
    sc2mac_dat_data41_d2 <= sc2mac_dat_data41_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[41]) == 1'b0) begin
  end else begin
    sc2mac_dat_data41_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[42]) == 1'b1) begin
    sc2mac_dat_data42_d2 <= sc2mac_dat_data42_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[42]) == 1'b0) begin
  end else begin
    sc2mac_dat_data42_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[43]) == 1'b1) begin
    sc2mac_dat_data43_d2 <= sc2mac_dat_data43_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[43]) == 1'b0) begin
  end else begin
    sc2mac_dat_data43_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[44]) == 1'b1) begin
    sc2mac_dat_data44_d2 <= sc2mac_dat_data44_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[44]) == 1'b0) begin
  end else begin
    sc2mac_dat_data44_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[45]) == 1'b1) begin
    sc2mac_dat_data45_d2 <= sc2mac_dat_data45_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[45]) == 1'b0) begin
  end else begin
    sc2mac_dat_data45_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[46]) == 1'b1) begin
    sc2mac_dat_data46_d2 <= sc2mac_dat_data46_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[46]) == 1'b0) begin
  end else begin
    sc2mac_dat_data46_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[47]) == 1'b1) begin
    sc2mac_dat_data47_d2 <= sc2mac_dat_data47_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[47]) == 1'b0) begin
  end else begin
    sc2mac_dat_data47_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[48]) == 1'b1) begin
    sc2mac_dat_data48_d2 <= sc2mac_dat_data48_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[48]) == 1'b0) begin
  end else begin
    sc2mac_dat_data48_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[49]) == 1'b1) begin
    sc2mac_dat_data49_d2 <= sc2mac_dat_data49_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[49]) == 1'b0) begin
  end else begin
    sc2mac_dat_data49_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[50]) == 1'b1) begin
    sc2mac_dat_data50_d2 <= sc2mac_dat_data50_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[50]) == 1'b0) begin
  end else begin
    sc2mac_dat_data50_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[51]) == 1'b1) begin
    sc2mac_dat_data51_d2 <= sc2mac_dat_data51_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[51]) == 1'b0) begin
  end else begin
    sc2mac_dat_data51_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[52]) == 1'b1) begin
    sc2mac_dat_data52_d2 <= sc2mac_dat_data52_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[52]) == 1'b0) begin
  end else begin
    sc2mac_dat_data52_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[53]) == 1'b1) begin
    sc2mac_dat_data53_d2 <= sc2mac_dat_data53_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[53]) == 1'b0) begin
  end else begin
    sc2mac_dat_data53_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[54]) == 1'b1) begin
    sc2mac_dat_data54_d2 <= sc2mac_dat_data54_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[54]) == 1'b0) begin
  end else begin
    sc2mac_dat_data54_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[55]) == 1'b1) begin
    sc2mac_dat_data55_d2 <= sc2mac_dat_data55_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[55]) == 1'b0) begin
  end else begin
    sc2mac_dat_data55_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[56]) == 1'b1) begin
    sc2mac_dat_data56_d2 <= sc2mac_dat_data56_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[56]) == 1'b0) begin
  end else begin
    sc2mac_dat_data56_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[57]) == 1'b1) begin
    sc2mac_dat_data57_d2 <= sc2mac_dat_data57_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[57]) == 1'b0) begin
  end else begin
    sc2mac_dat_data57_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[58]) == 1'b1) begin
    sc2mac_dat_data58_d2 <= sc2mac_dat_data58_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[58]) == 1'b0) begin
  end else begin
    sc2mac_dat_data58_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[59]) == 1'b1) begin
    sc2mac_dat_data59_d2 <= sc2mac_dat_data59_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[59]) == 1'b0) begin
  end else begin
    sc2mac_dat_data59_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[60]) == 1'b1) begin
    sc2mac_dat_data60_d2 <= sc2mac_dat_data60_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[60]) == 1'b0) begin
  end else begin
    sc2mac_dat_data60_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[61]) == 1'b1) begin
    sc2mac_dat_data61_d2 <= sc2mac_dat_data61_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[61]) == 1'b0) begin
  end else begin
    sc2mac_dat_data61_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[62]) == 1'b1) begin
    sc2mac_dat_data62_d2 <= sc2mac_dat_data62_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[62]) == 1'b0) begin
  end else begin
    sc2mac_dat_data62_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[63]) == 1'b1) begin
    sc2mac_dat_data63_d2 <= sc2mac_dat_data63_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[63]) == 1'b0) begin
  end else begin
    sc2mac_dat_data63_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[64]) == 1'b1) begin
    sc2mac_dat_data64_d2 <= sc2mac_dat_data64_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[64]) == 1'b0) begin
  end else begin
    sc2mac_dat_data64_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[65]) == 1'b1) begin
    sc2mac_dat_data65_d2 <= sc2mac_dat_data65_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[65]) == 1'b0) begin
  end else begin
    sc2mac_dat_data65_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[66]) == 1'b1) begin
    sc2mac_dat_data66_d2 <= sc2mac_dat_data66_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[66]) == 1'b0) begin
  end else begin
    sc2mac_dat_data66_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[67]) == 1'b1) begin
    sc2mac_dat_data67_d2 <= sc2mac_dat_data67_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[67]) == 1'b0) begin
  end else begin
    sc2mac_dat_data67_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[68]) == 1'b1) begin
    sc2mac_dat_data68_d2 <= sc2mac_dat_data68_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[68]) == 1'b0) begin
  end else begin
    sc2mac_dat_data68_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[69]) == 1'b1) begin
    sc2mac_dat_data69_d2 <= sc2mac_dat_data69_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[69]) == 1'b0) begin
  end else begin
    sc2mac_dat_data69_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[70]) == 1'b1) begin
    sc2mac_dat_data70_d2 <= sc2mac_dat_data70_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[70]) == 1'b0) begin
  end else begin
    sc2mac_dat_data70_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[71]) == 1'b1) begin
    sc2mac_dat_data71_d2 <= sc2mac_dat_data71_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[71]) == 1'b0) begin
  end else begin
    sc2mac_dat_data71_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[72]) == 1'b1) begin
    sc2mac_dat_data72_d2 <= sc2mac_dat_data72_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[72]) == 1'b0) begin
  end else begin
    sc2mac_dat_data72_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[73]) == 1'b1) begin
    sc2mac_dat_data73_d2 <= sc2mac_dat_data73_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[73]) == 1'b0) begin
  end else begin
    sc2mac_dat_data73_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[74]) == 1'b1) begin
    sc2mac_dat_data74_d2 <= sc2mac_dat_data74_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[74]) == 1'b0) begin
  end else begin
    sc2mac_dat_data74_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[75]) == 1'b1) begin
    sc2mac_dat_data75_d2 <= sc2mac_dat_data75_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[75]) == 1'b0) begin
  end else begin
    sc2mac_dat_data75_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[76]) == 1'b1) begin
    sc2mac_dat_data76_d2 <= sc2mac_dat_data76_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[76]) == 1'b0) begin
  end else begin
    sc2mac_dat_data76_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[77]) == 1'b1) begin
    sc2mac_dat_data77_d2 <= sc2mac_dat_data77_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[77]) == 1'b0) begin
  end else begin
    sc2mac_dat_data77_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[78]) == 1'b1) begin
    sc2mac_dat_data78_d2 <= sc2mac_dat_data78_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[78]) == 1'b0) begin
  end else begin
    sc2mac_dat_data78_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[79]) == 1'b1) begin
    sc2mac_dat_data79_d2 <= sc2mac_dat_data79_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[79]) == 1'b0) begin
  end else begin
    sc2mac_dat_data79_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[80]) == 1'b1) begin
    sc2mac_dat_data80_d2 <= sc2mac_dat_data80_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[80]) == 1'b0) begin
  end else begin
    sc2mac_dat_data80_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[81]) == 1'b1) begin
    sc2mac_dat_data81_d2 <= sc2mac_dat_data81_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[81]) == 1'b0) begin
  end else begin
    sc2mac_dat_data81_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[82]) == 1'b1) begin
    sc2mac_dat_data82_d2 <= sc2mac_dat_data82_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[82]) == 1'b0) begin
  end else begin
    sc2mac_dat_data82_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[83]) == 1'b1) begin
    sc2mac_dat_data83_d2 <= sc2mac_dat_data83_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[83]) == 1'b0) begin
  end else begin
    sc2mac_dat_data83_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[84]) == 1'b1) begin
    sc2mac_dat_data84_d2 <= sc2mac_dat_data84_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[84]) == 1'b0) begin
  end else begin
    sc2mac_dat_data84_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[85]) == 1'b1) begin
    sc2mac_dat_data85_d2 <= sc2mac_dat_data85_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[85]) == 1'b0) begin
  end else begin
    sc2mac_dat_data85_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[86]) == 1'b1) begin
    sc2mac_dat_data86_d2 <= sc2mac_dat_data86_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[86]) == 1'b0) begin
  end else begin
    sc2mac_dat_data86_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[87]) == 1'b1) begin
    sc2mac_dat_data87_d2 <= sc2mac_dat_data87_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[87]) == 1'b0) begin
  end else begin
    sc2mac_dat_data87_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[88]) == 1'b1) begin
    sc2mac_dat_data88_d2 <= sc2mac_dat_data88_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[88]) == 1'b0) begin
  end else begin
    sc2mac_dat_data88_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[89]) == 1'b1) begin
    sc2mac_dat_data89_d2 <= sc2mac_dat_data89_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[89]) == 1'b0) begin
  end else begin
    sc2mac_dat_data89_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[90]) == 1'b1) begin
    sc2mac_dat_data90_d2 <= sc2mac_dat_data90_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[90]) == 1'b0) begin
  end else begin
    sc2mac_dat_data90_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[91]) == 1'b1) begin
    sc2mac_dat_data91_d2 <= sc2mac_dat_data91_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[91]) == 1'b0) begin
  end else begin
    sc2mac_dat_data91_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[92]) == 1'b1) begin
    sc2mac_dat_data92_d2 <= sc2mac_dat_data92_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[92]) == 1'b0) begin
  end else begin
    sc2mac_dat_data92_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[93]) == 1'b1) begin
    sc2mac_dat_data93_d2 <= sc2mac_dat_data93_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[93]) == 1'b0) begin
  end else begin
    sc2mac_dat_data93_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[94]) == 1'b1) begin
    sc2mac_dat_data94_d2 <= sc2mac_dat_data94_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[94]) == 1'b0) begin
  end else begin
    sc2mac_dat_data94_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[95]) == 1'b1) begin
    sc2mac_dat_data95_d2 <= sc2mac_dat_data95_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[95]) == 1'b0) begin
  end else begin
    sc2mac_dat_data95_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[96]) == 1'b1) begin
    sc2mac_dat_data96_d2 <= sc2mac_dat_data96_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[96]) == 1'b0) begin
  end else begin
    sc2mac_dat_data96_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[97]) == 1'b1) begin
    sc2mac_dat_data97_d2 <= sc2mac_dat_data97_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[97]) == 1'b0) begin
  end else begin
    sc2mac_dat_data97_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[98]) == 1'b1) begin
    sc2mac_dat_data98_d2 <= sc2mac_dat_data98_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[98]) == 1'b0) begin
  end else begin
    sc2mac_dat_data98_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[99]) == 1'b1) begin
    sc2mac_dat_data99_d2 <= sc2mac_dat_data99_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[99]) == 1'b0) begin
  end else begin
    sc2mac_dat_data99_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[100]) == 1'b1) begin
    sc2mac_dat_data100_d2 <= sc2mac_dat_data100_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[100]) == 1'b0) begin
  end else begin
    sc2mac_dat_data100_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[101]) == 1'b1) begin
    sc2mac_dat_data101_d2 <= sc2mac_dat_data101_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[101]) == 1'b0) begin
  end else begin
    sc2mac_dat_data101_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[102]) == 1'b1) begin
    sc2mac_dat_data102_d2 <= sc2mac_dat_data102_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[102]) == 1'b0) begin
  end else begin
    sc2mac_dat_data102_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[103]) == 1'b1) begin
    sc2mac_dat_data103_d2 <= sc2mac_dat_data103_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[103]) == 1'b0) begin
  end else begin
    sc2mac_dat_data103_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[104]) == 1'b1) begin
    sc2mac_dat_data104_d2 <= sc2mac_dat_data104_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[104]) == 1'b0) begin
  end else begin
    sc2mac_dat_data104_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[105]) == 1'b1) begin
    sc2mac_dat_data105_d2 <= sc2mac_dat_data105_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[105]) == 1'b0) begin
  end else begin
    sc2mac_dat_data105_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[106]) == 1'b1) begin
    sc2mac_dat_data106_d2 <= sc2mac_dat_data106_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[106]) == 1'b0) begin
  end else begin
    sc2mac_dat_data106_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[107]) == 1'b1) begin
    sc2mac_dat_data107_d2 <= sc2mac_dat_data107_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[107]) == 1'b0) begin
  end else begin
    sc2mac_dat_data107_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[108]) == 1'b1) begin
    sc2mac_dat_data108_d2 <= sc2mac_dat_data108_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[108]) == 1'b0) begin
  end else begin
    sc2mac_dat_data108_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[109]) == 1'b1) begin
    sc2mac_dat_data109_d2 <= sc2mac_dat_data109_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[109]) == 1'b0) begin
  end else begin
    sc2mac_dat_data109_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[110]) == 1'b1) begin
    sc2mac_dat_data110_d2 <= sc2mac_dat_data110_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[110]) == 1'b0) begin
  end else begin
    sc2mac_dat_data110_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[111]) == 1'b1) begin
    sc2mac_dat_data111_d2 <= sc2mac_dat_data111_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[111]) == 1'b0) begin
  end else begin
    sc2mac_dat_data111_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[112]) == 1'b1) begin
    sc2mac_dat_data112_d2 <= sc2mac_dat_data112_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[112]) == 1'b0) begin
  end else begin
    sc2mac_dat_data112_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[113]) == 1'b1) begin
    sc2mac_dat_data113_d2 <= sc2mac_dat_data113_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[113]) == 1'b0) begin
  end else begin
    sc2mac_dat_data113_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[114]) == 1'b1) begin
    sc2mac_dat_data114_d2 <= sc2mac_dat_data114_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[114]) == 1'b0) begin
  end else begin
    sc2mac_dat_data114_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[115]) == 1'b1) begin
    sc2mac_dat_data115_d2 <= sc2mac_dat_data115_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[115]) == 1'b0) begin
  end else begin
    sc2mac_dat_data115_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[116]) == 1'b1) begin
    sc2mac_dat_data116_d2 <= sc2mac_dat_data116_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[116]) == 1'b0) begin
  end else begin
    sc2mac_dat_data116_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[117]) == 1'b1) begin
    sc2mac_dat_data117_d2 <= sc2mac_dat_data117_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[117]) == 1'b0) begin
  end else begin
    sc2mac_dat_data117_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[118]) == 1'b1) begin
    sc2mac_dat_data118_d2 <= sc2mac_dat_data118_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[118]) == 1'b0) begin
  end else begin
    sc2mac_dat_data118_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[119]) == 1'b1) begin
    sc2mac_dat_data119_d2 <= sc2mac_dat_data119_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[119]) == 1'b0) begin
  end else begin
    sc2mac_dat_data119_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[120]) == 1'b1) begin
    sc2mac_dat_data120_d2 <= sc2mac_dat_data120_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[120]) == 1'b0) begin
  end else begin
    sc2mac_dat_data120_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[121]) == 1'b1) begin
    sc2mac_dat_data121_d2 <= sc2mac_dat_data121_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[121]) == 1'b0) begin
  end else begin
    sc2mac_dat_data121_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[122]) == 1'b1) begin
    sc2mac_dat_data122_d2 <= sc2mac_dat_data122_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[122]) == 1'b0) begin
  end else begin
    sc2mac_dat_data122_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[123]) == 1'b1) begin
    sc2mac_dat_data123_d2 <= sc2mac_dat_data123_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[123]) == 1'b0) begin
  end else begin
    sc2mac_dat_data123_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[124]) == 1'b1) begin
    sc2mac_dat_data124_d2 <= sc2mac_dat_data124_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[124]) == 1'b0) begin
  end else begin
    sc2mac_dat_data124_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[125]) == 1'b1) begin
    sc2mac_dat_data125_d2 <= sc2mac_dat_data125_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[125]) == 1'b0) begin
  end else begin
    sc2mac_dat_data125_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[126]) == 1'b1) begin
    sc2mac_dat_data126_d2 <= sc2mac_dat_data126_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[126]) == 1'b0) begin
  end else begin
    sc2mac_dat_data126_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end
always @(posedge nvdla_core_clk) begin
  if ((sc2mac_dat_mask_d1[127]) == 1'b1) begin
    sc2mac_dat_data127_d2 <= sc2mac_dat_data127_d1;
  // VCS coverage off
  end else if ((sc2mac_dat_mask_d1[127]) == 1'b0) begin
  end else begin
    sc2mac_dat_data127_d2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
end






assign sc2mac_wt_dst_pvld = sc2mac_wt_pvld_d2;
assign sc2mac_wt_dst_sel = sc2mac_wt_sel_d2;
assign sc2mac_wt_dst_mask = sc2mac_wt_mask_d2;
assign sc2mac_wt_dst_data0 = sc2mac_wt_data0_d2;
assign sc2mac_wt_dst_data1 = sc2mac_wt_data1_d2;
assign sc2mac_wt_dst_data2 = sc2mac_wt_data2_d2;
assign sc2mac_wt_dst_data3 = sc2mac_wt_data3_d2;
assign sc2mac_wt_dst_data4 = sc2mac_wt_data4_d2;
assign sc2mac_wt_dst_data5 = sc2mac_wt_data5_d2;
assign sc2mac_wt_dst_data6 = sc2mac_wt_data6_d2;
assign sc2mac_wt_dst_data7 = sc2mac_wt_data7_d2;
assign sc2mac_wt_dst_data8 = sc2mac_wt_data8_d2;
assign sc2mac_wt_dst_data9 = sc2mac_wt_data9_d2;
assign sc2mac_wt_dst_data10 = sc2mac_wt_data10_d2;
assign sc2mac_wt_dst_data11 = sc2mac_wt_data11_d2;
assign sc2mac_wt_dst_data12 = sc2mac_wt_data12_d2;
assign sc2mac_wt_dst_data13 = sc2mac_wt_data13_d2;
assign sc2mac_wt_dst_data14 = sc2mac_wt_data14_d2;
assign sc2mac_wt_dst_data15 = sc2mac_wt_data15_d2;
assign sc2mac_wt_dst_data16 = sc2mac_wt_data16_d2;
assign sc2mac_wt_dst_data17 = sc2mac_wt_data17_d2;
assign sc2mac_wt_dst_data18 = sc2mac_wt_data18_d2;
assign sc2mac_wt_dst_data19 = sc2mac_wt_data19_d2;
assign sc2mac_wt_dst_data20 = sc2mac_wt_data20_d2;
assign sc2mac_wt_dst_data21 = sc2mac_wt_data21_d2;
assign sc2mac_wt_dst_data22 = sc2mac_wt_data22_d2;
assign sc2mac_wt_dst_data23 = sc2mac_wt_data23_d2;
assign sc2mac_wt_dst_data24 = sc2mac_wt_data24_d2;
assign sc2mac_wt_dst_data25 = sc2mac_wt_data25_d2;
assign sc2mac_wt_dst_data26 = sc2mac_wt_data26_d2;
assign sc2mac_wt_dst_data27 = sc2mac_wt_data27_d2;
assign sc2mac_wt_dst_data28 = sc2mac_wt_data28_d2;
assign sc2mac_wt_dst_data29 = sc2mac_wt_data29_d2;
assign sc2mac_wt_dst_data30 = sc2mac_wt_data30_d2;
assign sc2mac_wt_dst_data31 = sc2mac_wt_data31_d2;
assign sc2mac_wt_dst_data32 = sc2mac_wt_data32_d2;
assign sc2mac_wt_dst_data33 = sc2mac_wt_data33_d2;
assign sc2mac_wt_dst_data34 = sc2mac_wt_data34_d2;
assign sc2mac_wt_dst_data35 = sc2mac_wt_data35_d2;
assign sc2mac_wt_dst_data36 = sc2mac_wt_data36_d2;
assign sc2mac_wt_dst_data37 = sc2mac_wt_data37_d2;
assign sc2mac_wt_dst_data38 = sc2mac_wt_data38_d2;
assign sc2mac_wt_dst_data39 = sc2mac_wt_data39_d2;
assign sc2mac_wt_dst_data40 = sc2mac_wt_data40_d2;
assign sc2mac_wt_dst_data41 = sc2mac_wt_data41_d2;
assign sc2mac_wt_dst_data42 = sc2mac_wt_data42_d2;
assign sc2mac_wt_dst_data43 = sc2mac_wt_data43_d2;
assign sc2mac_wt_dst_data44 = sc2mac_wt_data44_d2;
assign sc2mac_wt_dst_data45 = sc2mac_wt_data45_d2;
assign sc2mac_wt_dst_data46 = sc2mac_wt_data46_d2;
assign sc2mac_wt_dst_data47 = sc2mac_wt_data47_d2;
assign sc2mac_wt_dst_data48 = sc2mac_wt_data48_d2;
assign sc2mac_wt_dst_data49 = sc2mac_wt_data49_d2;
assign sc2mac_wt_dst_data50 = sc2mac_wt_data50_d2;
assign sc2mac_wt_dst_data51 = sc2mac_wt_data51_d2;
assign sc2mac_wt_dst_data52 = sc2mac_wt_data52_d2;
assign sc2mac_wt_dst_data53 = sc2mac_wt_data53_d2;
assign sc2mac_wt_dst_data54 = sc2mac_wt_data54_d2;
assign sc2mac_wt_dst_data55 = sc2mac_wt_data55_d2;
assign sc2mac_wt_dst_data56 = sc2mac_wt_data56_d2;
assign sc2mac_wt_dst_data57 = sc2mac_wt_data57_d2;
assign sc2mac_wt_dst_data58 = sc2mac_wt_data58_d2;
assign sc2mac_wt_dst_data59 = sc2mac_wt_data59_d2;
assign sc2mac_wt_dst_data60 = sc2mac_wt_data60_d2;
assign sc2mac_wt_dst_data61 = sc2mac_wt_data61_d2;
assign sc2mac_wt_dst_data62 = sc2mac_wt_data62_d2;
assign sc2mac_wt_dst_data63 = sc2mac_wt_data63_d2;
assign sc2mac_wt_dst_data64 = sc2mac_wt_data64_d2;
assign sc2mac_wt_dst_data65 = sc2mac_wt_data65_d2;
assign sc2mac_wt_dst_data66 = sc2mac_wt_data66_d2;
assign sc2mac_wt_dst_data67 = sc2mac_wt_data67_d2;
assign sc2mac_wt_dst_data68 = sc2mac_wt_data68_d2;
assign sc2mac_wt_dst_data69 = sc2mac_wt_data69_d2;
assign sc2mac_wt_dst_data70 = sc2mac_wt_data70_d2;
assign sc2mac_wt_dst_data71 = sc2mac_wt_data71_d2;
assign sc2mac_wt_dst_data72 = sc2mac_wt_data72_d2;
assign sc2mac_wt_dst_data73 = sc2mac_wt_data73_d2;
assign sc2mac_wt_dst_data74 = sc2mac_wt_data74_d2;
assign sc2mac_wt_dst_data75 = sc2mac_wt_data75_d2;
assign sc2mac_wt_dst_data76 = sc2mac_wt_data76_d2;
assign sc2mac_wt_dst_data77 = sc2mac_wt_data77_d2;
assign sc2mac_wt_dst_data78 = sc2mac_wt_data78_d2;
assign sc2mac_wt_dst_data79 = sc2mac_wt_data79_d2;
assign sc2mac_wt_dst_data80 = sc2mac_wt_data80_d2;
assign sc2mac_wt_dst_data81 = sc2mac_wt_data81_d2;
assign sc2mac_wt_dst_data82 = sc2mac_wt_data82_d2;
assign sc2mac_wt_dst_data83 = sc2mac_wt_data83_d2;
assign sc2mac_wt_dst_data84 = sc2mac_wt_data84_d2;
assign sc2mac_wt_dst_data85 = sc2mac_wt_data85_d2;
assign sc2mac_wt_dst_data86 = sc2mac_wt_data86_d2;
assign sc2mac_wt_dst_data87 = sc2mac_wt_data87_d2;
assign sc2mac_wt_dst_data88 = sc2mac_wt_data88_d2;
assign sc2mac_wt_dst_data89 = sc2mac_wt_data89_d2;
assign sc2mac_wt_dst_data90 = sc2mac_wt_data90_d2;
assign sc2mac_wt_dst_data91 = sc2mac_wt_data91_d2;
assign sc2mac_wt_dst_data92 = sc2mac_wt_data92_d2;
assign sc2mac_wt_dst_data93 = sc2mac_wt_data93_d2;
assign sc2mac_wt_dst_data94 = sc2mac_wt_data94_d2;
assign sc2mac_wt_dst_data95 = sc2mac_wt_data95_d2;
assign sc2mac_wt_dst_data96 = sc2mac_wt_data96_d2;
assign sc2mac_wt_dst_data97 = sc2mac_wt_data97_d2;
assign sc2mac_wt_dst_data98 = sc2mac_wt_data98_d2;
assign sc2mac_wt_dst_data99 = sc2mac_wt_data99_d2;
assign sc2mac_wt_dst_data100 = sc2mac_wt_data100_d2;
assign sc2mac_wt_dst_data101 = sc2mac_wt_data101_d2;
assign sc2mac_wt_dst_data102 = sc2mac_wt_data102_d2;
assign sc2mac_wt_dst_data103 = sc2mac_wt_data103_d2;
assign sc2mac_wt_dst_data104 = sc2mac_wt_data104_d2;
assign sc2mac_wt_dst_data105 = sc2mac_wt_data105_d2;
assign sc2mac_wt_dst_data106 = sc2mac_wt_data106_d2;
assign sc2mac_wt_dst_data107 = sc2mac_wt_data107_d2;
assign sc2mac_wt_dst_data108 = sc2mac_wt_data108_d2;
assign sc2mac_wt_dst_data109 = sc2mac_wt_data109_d2;
assign sc2mac_wt_dst_data110 = sc2mac_wt_data110_d2;
assign sc2mac_wt_dst_data111 = sc2mac_wt_data111_d2;
assign sc2mac_wt_dst_data112 = sc2mac_wt_data112_d2;
assign sc2mac_wt_dst_data113 = sc2mac_wt_data113_d2;
assign sc2mac_wt_dst_data114 = sc2mac_wt_data114_d2;
assign sc2mac_wt_dst_data115 = sc2mac_wt_data115_d2;
assign sc2mac_wt_dst_data116 = sc2mac_wt_data116_d2;
assign sc2mac_wt_dst_data117 = sc2mac_wt_data117_d2;
assign sc2mac_wt_dst_data118 = sc2mac_wt_data118_d2;
assign sc2mac_wt_dst_data119 = sc2mac_wt_data119_d2;
assign sc2mac_wt_dst_data120 = sc2mac_wt_data120_d2;
assign sc2mac_wt_dst_data121 = sc2mac_wt_data121_d2;
assign sc2mac_wt_dst_data122 = sc2mac_wt_data122_d2;
assign sc2mac_wt_dst_data123 = sc2mac_wt_data123_d2;
assign sc2mac_wt_dst_data124 = sc2mac_wt_data124_d2;
assign sc2mac_wt_dst_data125 = sc2mac_wt_data125_d2;
assign sc2mac_wt_dst_data126 = sc2mac_wt_data126_d2;
assign sc2mac_wt_dst_data127 = sc2mac_wt_data127_d2;


assign sc2mac_dat_dst_pvld = sc2mac_dat_pvld_d2;
assign sc2mac_dat_dst_pd = sc2mac_dat_pd_d2;
assign sc2mac_dat_dst_mask = sc2mac_dat_mask_d2;
assign sc2mac_dat_dst_data0 = sc2mac_dat_data0_d2;
assign sc2mac_dat_dst_data1 = sc2mac_dat_data1_d2;
assign sc2mac_dat_dst_data2 = sc2mac_dat_data2_d2;
assign sc2mac_dat_dst_data3 = sc2mac_dat_data3_d2;
assign sc2mac_dat_dst_data4 = sc2mac_dat_data4_d2;
assign sc2mac_dat_dst_data5 = sc2mac_dat_data5_d2;
assign sc2mac_dat_dst_data6 = sc2mac_dat_data6_d2;
assign sc2mac_dat_dst_data7 = sc2mac_dat_data7_d2;
assign sc2mac_dat_dst_data8 = sc2mac_dat_data8_d2;
assign sc2mac_dat_dst_data9 = sc2mac_dat_data9_d2;
assign sc2mac_dat_dst_data10 = sc2mac_dat_data10_d2;
assign sc2mac_dat_dst_data11 = sc2mac_dat_data11_d2;
assign sc2mac_dat_dst_data12 = sc2mac_dat_data12_d2;
assign sc2mac_dat_dst_data13 = sc2mac_dat_data13_d2;
assign sc2mac_dat_dst_data14 = sc2mac_dat_data14_d2;
assign sc2mac_dat_dst_data15 = sc2mac_dat_data15_d2;
assign sc2mac_dat_dst_data16 = sc2mac_dat_data16_d2;
assign sc2mac_dat_dst_data17 = sc2mac_dat_data17_d2;
assign sc2mac_dat_dst_data18 = sc2mac_dat_data18_d2;
assign sc2mac_dat_dst_data19 = sc2mac_dat_data19_d2;
assign sc2mac_dat_dst_data20 = sc2mac_dat_data20_d2;
assign sc2mac_dat_dst_data21 = sc2mac_dat_data21_d2;
assign sc2mac_dat_dst_data22 = sc2mac_dat_data22_d2;
assign sc2mac_dat_dst_data23 = sc2mac_dat_data23_d2;
assign sc2mac_dat_dst_data24 = sc2mac_dat_data24_d2;
assign sc2mac_dat_dst_data25 = sc2mac_dat_data25_d2;
assign sc2mac_dat_dst_data26 = sc2mac_dat_data26_d2;
assign sc2mac_dat_dst_data27 = sc2mac_dat_data27_d2;
assign sc2mac_dat_dst_data28 = sc2mac_dat_data28_d2;
assign sc2mac_dat_dst_data29 = sc2mac_dat_data29_d2;
assign sc2mac_dat_dst_data30 = sc2mac_dat_data30_d2;
assign sc2mac_dat_dst_data31 = sc2mac_dat_data31_d2;
assign sc2mac_dat_dst_data32 = sc2mac_dat_data32_d2;
assign sc2mac_dat_dst_data33 = sc2mac_dat_data33_d2;
assign sc2mac_dat_dst_data34 = sc2mac_dat_data34_d2;
assign sc2mac_dat_dst_data35 = sc2mac_dat_data35_d2;
assign sc2mac_dat_dst_data36 = sc2mac_dat_data36_d2;
assign sc2mac_dat_dst_data37 = sc2mac_dat_data37_d2;
assign sc2mac_dat_dst_data38 = sc2mac_dat_data38_d2;
assign sc2mac_dat_dst_data39 = sc2mac_dat_data39_d2;
assign sc2mac_dat_dst_data40 = sc2mac_dat_data40_d2;
assign sc2mac_dat_dst_data41 = sc2mac_dat_data41_d2;
assign sc2mac_dat_dst_data42 = sc2mac_dat_data42_d2;
assign sc2mac_dat_dst_data43 = sc2mac_dat_data43_d2;
assign sc2mac_dat_dst_data44 = sc2mac_dat_data44_d2;
assign sc2mac_dat_dst_data45 = sc2mac_dat_data45_d2;
assign sc2mac_dat_dst_data46 = sc2mac_dat_data46_d2;
assign sc2mac_dat_dst_data47 = sc2mac_dat_data47_d2;
assign sc2mac_dat_dst_data48 = sc2mac_dat_data48_d2;
assign sc2mac_dat_dst_data49 = sc2mac_dat_data49_d2;
assign sc2mac_dat_dst_data50 = sc2mac_dat_data50_d2;
assign sc2mac_dat_dst_data51 = sc2mac_dat_data51_d2;
assign sc2mac_dat_dst_data52 = sc2mac_dat_data52_d2;
assign sc2mac_dat_dst_data53 = sc2mac_dat_data53_d2;
assign sc2mac_dat_dst_data54 = sc2mac_dat_data54_d2;
assign sc2mac_dat_dst_data55 = sc2mac_dat_data55_d2;
assign sc2mac_dat_dst_data56 = sc2mac_dat_data56_d2;
assign sc2mac_dat_dst_data57 = sc2mac_dat_data57_d2;
assign sc2mac_dat_dst_data58 = sc2mac_dat_data58_d2;
assign sc2mac_dat_dst_data59 = sc2mac_dat_data59_d2;
assign sc2mac_dat_dst_data60 = sc2mac_dat_data60_d2;
assign sc2mac_dat_dst_data61 = sc2mac_dat_data61_d2;
assign sc2mac_dat_dst_data62 = sc2mac_dat_data62_d2;
assign sc2mac_dat_dst_data63 = sc2mac_dat_data63_d2;
assign sc2mac_dat_dst_data64 = sc2mac_dat_data64_d2;
assign sc2mac_dat_dst_data65 = sc2mac_dat_data65_d2;
assign sc2mac_dat_dst_data66 = sc2mac_dat_data66_d2;
assign sc2mac_dat_dst_data67 = sc2mac_dat_data67_d2;
assign sc2mac_dat_dst_data68 = sc2mac_dat_data68_d2;
assign sc2mac_dat_dst_data69 = sc2mac_dat_data69_d2;
assign sc2mac_dat_dst_data70 = sc2mac_dat_data70_d2;
assign sc2mac_dat_dst_data71 = sc2mac_dat_data71_d2;
assign sc2mac_dat_dst_data72 = sc2mac_dat_data72_d2;
assign sc2mac_dat_dst_data73 = sc2mac_dat_data73_d2;
assign sc2mac_dat_dst_data74 = sc2mac_dat_data74_d2;
assign sc2mac_dat_dst_data75 = sc2mac_dat_data75_d2;
assign sc2mac_dat_dst_data76 = sc2mac_dat_data76_d2;
assign sc2mac_dat_dst_data77 = sc2mac_dat_data77_d2;
assign sc2mac_dat_dst_data78 = sc2mac_dat_data78_d2;
assign sc2mac_dat_dst_data79 = sc2mac_dat_data79_d2;
assign sc2mac_dat_dst_data80 = sc2mac_dat_data80_d2;
assign sc2mac_dat_dst_data81 = sc2mac_dat_data81_d2;
assign sc2mac_dat_dst_data82 = sc2mac_dat_data82_d2;
assign sc2mac_dat_dst_data83 = sc2mac_dat_data83_d2;
assign sc2mac_dat_dst_data84 = sc2mac_dat_data84_d2;
assign sc2mac_dat_dst_data85 = sc2mac_dat_data85_d2;
assign sc2mac_dat_dst_data86 = sc2mac_dat_data86_d2;
assign sc2mac_dat_dst_data87 = sc2mac_dat_data87_d2;
assign sc2mac_dat_dst_data88 = sc2mac_dat_data88_d2;
assign sc2mac_dat_dst_data89 = sc2mac_dat_data89_d2;
assign sc2mac_dat_dst_data90 = sc2mac_dat_data90_d2;
assign sc2mac_dat_dst_data91 = sc2mac_dat_data91_d2;
assign sc2mac_dat_dst_data92 = sc2mac_dat_data92_d2;
assign sc2mac_dat_dst_data93 = sc2mac_dat_data93_d2;
assign sc2mac_dat_dst_data94 = sc2mac_dat_data94_d2;
assign sc2mac_dat_dst_data95 = sc2mac_dat_data95_d2;
assign sc2mac_dat_dst_data96 = sc2mac_dat_data96_d2;
assign sc2mac_dat_dst_data97 = sc2mac_dat_data97_d2;
assign sc2mac_dat_dst_data98 = sc2mac_dat_data98_d2;
assign sc2mac_dat_dst_data99 = sc2mac_dat_data99_d2;
assign sc2mac_dat_dst_data100 = sc2mac_dat_data100_d2;
assign sc2mac_dat_dst_data101 = sc2mac_dat_data101_d2;
assign sc2mac_dat_dst_data102 = sc2mac_dat_data102_d2;
assign sc2mac_dat_dst_data103 = sc2mac_dat_data103_d2;
assign sc2mac_dat_dst_data104 = sc2mac_dat_data104_d2;
assign sc2mac_dat_dst_data105 = sc2mac_dat_data105_d2;
assign sc2mac_dat_dst_data106 = sc2mac_dat_data106_d2;
assign sc2mac_dat_dst_data107 = sc2mac_dat_data107_d2;
assign sc2mac_dat_dst_data108 = sc2mac_dat_data108_d2;
assign sc2mac_dat_dst_data109 = sc2mac_dat_data109_d2;
assign sc2mac_dat_dst_data110 = sc2mac_dat_data110_d2;
assign sc2mac_dat_dst_data111 = sc2mac_dat_data111_d2;
assign sc2mac_dat_dst_data112 = sc2mac_dat_data112_d2;
assign sc2mac_dat_dst_data113 = sc2mac_dat_data113_d2;
assign sc2mac_dat_dst_data114 = sc2mac_dat_data114_d2;
assign sc2mac_dat_dst_data115 = sc2mac_dat_data115_d2;
assign sc2mac_dat_dst_data116 = sc2mac_dat_data116_d2;
assign sc2mac_dat_dst_data117 = sc2mac_dat_data117_d2;
assign sc2mac_dat_dst_data118 = sc2mac_dat_data118_d2;
assign sc2mac_dat_dst_data119 = sc2mac_dat_data119_d2;
assign sc2mac_dat_dst_data120 = sc2mac_dat_data120_d2;
assign sc2mac_dat_dst_data121 = sc2mac_dat_data121_d2;
assign sc2mac_dat_dst_data122 = sc2mac_dat_data122_d2;
assign sc2mac_dat_dst_data123 = sc2mac_dat_data123_d2;
assign sc2mac_dat_dst_data124 = sc2mac_dat_data124_d2;
assign sc2mac_dat_dst_data125 = sc2mac_dat_data125_d2;
assign sc2mac_dat_dst_data126 = sc2mac_dat_data126_d2;
assign sc2mac_dat_dst_data127 = sc2mac_dat_data127_d2;





endmodule // NV_NVDLA_RT_csc2cmac_a

