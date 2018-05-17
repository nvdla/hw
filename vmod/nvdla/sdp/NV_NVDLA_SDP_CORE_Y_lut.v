// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_CORE_Y_lut.v

`include "simulate_x_tick.vh"
#include "NV_NVDLA_SDP_define.h"
module NV_NVDLA_SDP_CORE_Y_lut (
   nvdla_core_clk                  //|< i
  ,nvdla_core_rstn                 //|< i
  ,idx2lut_pd                      //|< i
  ,idx2lut_pvld                    //|< i
  ,lut2inp_prdy                    //|< i
  ,op_en_load                      //|< i
  ,pwrbus_ram_pd                   //|< i
  ,reg2dp_lut_int_access_type      //|< i
  ,reg2dp_lut_int_addr             //|< i
  ,reg2dp_lut_int_data             //|< i
  ,reg2dp_lut_int_data_wr          //|< i
  ,reg2dp_lut_int_table_id         //|< i
  ,reg2dp_lut_le_end               //|< i
  ,reg2dp_lut_le_function          //|< i
  ,reg2dp_lut_le_index_offset      //|< i
  ,reg2dp_lut_le_slope_oflow_scale //|< i
  ,reg2dp_lut_le_slope_oflow_shift //|< i
  ,reg2dp_lut_le_slope_uflow_scale //|< i
  ,reg2dp_lut_le_slope_uflow_shift //|< i
  ,reg2dp_lut_le_start             //|< i
  ,reg2dp_lut_lo_end               //|< i
  ,reg2dp_lut_lo_slope_oflow_scale //|< i
  ,reg2dp_lut_lo_slope_oflow_shift //|< i
  ,reg2dp_lut_lo_slope_uflow_scale //|< i
  ,reg2dp_lut_lo_slope_uflow_shift //|< i
  ,reg2dp_lut_lo_start             //|< i
  ,reg2dp_perf_lut_en              //|< i
  ,reg2dp_proc_precision           //|< i
  ,dp2reg_lut_hybrid               //|> o
  ,dp2reg_lut_int_data             //|> o
  ,dp2reg_lut_le_hit               //|> o
  ,dp2reg_lut_lo_hit               //|> o
  ,dp2reg_lut_oflow                //|> o
  ,dp2reg_lut_uflow                //|> o
  ,idx2lut_prdy                    //|> o
  ,lut2inp_pd                      //|> o
  ,lut2inp_pvld                    //|> o
  );
//
// NV_NVDLA_SDP_CORE_Y_lut_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

output         lut2inp_pvld;  /* data valid */
input          lut2inp_prdy;  /* data return handshake */
output [EW_LUT_OUT_DW-1:0] lut2inp_pd;

input          idx2lut_pvld;  /* data valid */
output         idx2lut_prdy;  /* data return handshake */
input  [EW_IDX_OUT_DW-1:0] idx2lut_pd;

input          reg2dp_lut_int_access_type;
input    [9:0] reg2dp_lut_int_addr;
input   [15:0] reg2dp_lut_int_data;
input          reg2dp_lut_int_data_wr;
input          reg2dp_lut_int_table_id;
input   [31:0] reg2dp_lut_le_end;
input          reg2dp_lut_le_function;
input    [7:0] reg2dp_lut_le_index_offset;
input   [15:0] reg2dp_lut_le_slope_oflow_scale;
input    [4:0] reg2dp_lut_le_slope_oflow_shift;
input   [15:0] reg2dp_lut_le_slope_uflow_scale;
input    [4:0] reg2dp_lut_le_slope_uflow_shift;
input   [31:0] reg2dp_lut_le_start;
input   [31:0] reg2dp_lut_lo_end;
input   [15:0] reg2dp_lut_lo_slope_oflow_scale;
input    [4:0] reg2dp_lut_lo_slope_oflow_shift;
input   [15:0] reg2dp_lut_lo_slope_uflow_scale;
input    [4:0] reg2dp_lut_lo_slope_uflow_shift;
input   [31:0] reg2dp_lut_lo_start;
input          reg2dp_perf_lut_en;
input    [1:0] reg2dp_proc_precision;
output  [31:0] dp2reg_lut_hybrid;
output  [15:0] dp2reg_lut_int_data;
output  [31:0] dp2reg_lut_le_hit;
output  [31:0] dp2reg_lut_lo_hit;
output  [31:0] dp2reg_lut_oflow;
output  [31:0] dp2reg_lut_uflow;
input   [31:0] pwrbus_ram_pd;
input          op_en_load;

reg            idx2lut_prdy;
reg    [EW_LUT_OUT_DW-1:0] lut2inp_pd;
reg            lut2inp_pvld;
reg    [EW_IDX_OUT_DW-1:0] lut_in_pd;
reg            lut_in_pvld;
wire           lut_in_prdy;
wire   [EW_LUT_OUT_DW-1:0] lut_out_pd;
wire           lut_out_pvld;
reg            lut_out_prdy;

//: my $k = NVDLA_SDP_EW_THROUGHPUT;
//: my $m = LUT_TABLE_MAX_DEPTH;
//: foreach my $lut (qw(le lo)) {
//:   foreach my $i  (0..${m}-1) {
//:     print "reg     [15:0] REG_${lut}_${i}; \n";
//:   }
//: }
//: foreach my $lut (qw(le lo)) {
//:   foreach my $j (0..1) {
//:     foreach my $i  (0..${k}-1) {
//:       print "reg     [15:0] ${lut}_data${j}_${i}; \n";
//:     }
//:   }
//: }
reg     [15:0] le_lut_data;
reg     [15:0] lo_lut_data;

#ifdef NVDLA_FEATURE_DATA_TYPE_FP16
//: my $k = NVDLA_SDP_EW_THROUGHPUT;
//: foreach my $i  (0..${k}-1) {
//: print qq(
//: reg      [7:0] out_bias${i}_expo;
//: reg     [22:0] out_bias${i}_mant;
//: reg            out_bias${i}_sign;
//: );
//: }
#endif

//: my $k = NVDLA_SDP_EW_THROUGHPUT;
//: foreach my $i  (0..${k}-1) {
//: print qq(
//: reg     [31:0] out_bias${i};
//: reg     [31:0] out_offset${i};
//: reg     [15:0] out_scale${i};
//: reg      [4:0] out_shift${i};
//: );
//: }

wire     [4:0] lut_hybrid_sum;
wire     [4:0] lut_le_hit_sum;
wire     [4:0] lut_lo_hit_sum;
wire     [4:0] lut_oflow_sum;
wire     [4:0] lut_uflow_sum;
wire     [4:0] perf_lut_hybrid_add;
wire     [0:0] perf_lut_hybrid_sub;
wire     [4:0] perf_lut_le_hit_add;
wire     [0:0] perf_lut_le_hit_sub;
wire     [4:0] perf_lut_lo_hit_add;
wire     [0:0] perf_lut_lo_hit_sub;
wire     [4:0] perf_lut_oflow_add;
wire     [0:0] perf_lut_oflow_sub;
wire     [4:0] perf_lut_uflow_add;
wire     [0:0] perf_lut_uflow_sub;
reg     [31:0] lut_hybrid_cnt;
reg     [31:0] lut_le_hit_cnt;
reg     [31:0] lut_lo_hit_cnt;
reg     [31:0] lut_oflow_cnt;
reg     [31:0] lut_uflow_cnt;
reg            perf_lut_hybrid_adv;
reg     [31:0] perf_lut_hybrid_cnt_cur;
reg     [33:0] perf_lut_hybrid_cnt_ext;
reg     [33:0] perf_lut_hybrid_cnt_mod;
reg     [33:0] perf_lut_hybrid_cnt_new;
reg     [33:0] perf_lut_hybrid_cnt_nxt;
reg            perf_lut_le_hit_adv;
reg     [31:0] perf_lut_le_hit_cnt_cur;
reg     [33:0] perf_lut_le_hit_cnt_ext;
reg     [33:0] perf_lut_le_hit_cnt_mod;
reg     [33:0] perf_lut_le_hit_cnt_new;
reg     [33:0] perf_lut_le_hit_cnt_nxt;
reg            perf_lut_lo_hit_adv;
reg     [31:0] perf_lut_lo_hit_cnt_cur;
reg     [33:0] perf_lut_lo_hit_cnt_ext;
reg     [33:0] perf_lut_lo_hit_cnt_mod;
reg     [33:0] perf_lut_lo_hit_cnt_new;
reg     [33:0] perf_lut_lo_hit_cnt_nxt;
reg            perf_lut_oflow_adv;
reg     [31:0] perf_lut_oflow_cnt_cur;
reg     [33:0] perf_lut_oflow_cnt_ext;
reg     [33:0] perf_lut_oflow_cnt_mod;
reg     [33:0] perf_lut_oflow_cnt_new;
reg     [33:0] perf_lut_oflow_cnt_nxt;
reg            perf_lut_uflow_adv;
reg     [31:0] perf_lut_uflow_cnt_cur;
reg     [33:0] perf_lut_uflow_cnt_ext;
reg     [33:0] perf_lut_uflow_cnt_mod;
reg     [33:0] perf_lut_uflow_cnt_new;
reg     [33:0] perf_lut_uflow_cnt_nxt;

wire   [70*NVDLA_SDP_EW_THROUGHPUT-1:0] cmd_fifo_rd_pd;
wire           cmd_fifo_rd_prdy;
wire           cmd_fifo_rd_pvld;
wire   [70*NVDLA_SDP_EW_THROUGHPUT-1:0] cmd_fifo_wr_pd;
wire           cmd_fifo_wr_prdy;
wire           cmd_fifo_wr_pvld;
wire   [32*NVDLA_SDP_EW_THROUGHPUT-1:0] dat_fifo_rd_pd;
wire           dat_fifo_rd_prdy;
wire           dat_fifo_rd_pvld;
wire   [32*NVDLA_SDP_EW_THROUGHPUT-1:0] dat_fifo_wr_pd;
wire           dat_fifo_wr_pvld;

//: my $k = NVDLA_SDP_EW_THROUGHPUT;
//: foreach my $j (0..1) {
//:   foreach my $i  (0..${k}-1) {
//:   print"wire    [15:0] dat_in_y${j}_${i}; \n";
//:   }
//: }

//: my $ed = LUT_TABLE_LE_DEPTH;
//: my $od = LUT_TABLE_LO_DEPTH;
//: foreach my $i  (0..${ed}-1) {
//:  print"wire           le_wr_en_$i; \n";
//: }
//: foreach my $i  (0..${od}-1) {
//:  print"wire           lo_wr_en_$i; \n";
//: }

//: my $k = NVDLA_SDP_EW_THROUGHPUT;
//: foreach my $i  (0..${k}-1) {
//: print qq(
//: wire     [8:0] lut_in_addr${i};
//: wire     [8:0] lut_in_addr${i}_0;
//: wire     [8:0] lut_in_addr${i}_1;
//: wire    [34:0] lut_in_fraction${i};
//: wire           lut_in_hybrid${i};
//: wire           lut_in_le_hit${i};
//: wire           lut_in_lo_hit${i};
//: wire           lut_in_oflow${i};
//: wire           lut_in_sel${i};
//: wire           lut_in_uflow${i};
//: wire    [31:0] lut_in_x${i};
//: wire           out_flow${i};
//: wire    [34:0] out_fraction${i};
//: wire           out_oflow${i};
//: wire           out_sel${i};
//: wire           out_uflow${i};
//: wire    [31:0] out_x${i};
//: wire    [15:0] out_y0_${i};
//: wire    [15:0] out_y1_${i};
//: );
//: }

wire           lut_access_type;
wire     [9:0] lut_addr;
wire    [15:0] lut_data;
wire    [27:0] pro2lut_pd;
wire           pro2lut_valid;
wire     [9:0] pro_in_addr;
wire    [15:0] pro_in_data;
wire           pro_in_select_le;
wire           pro_in_select_lo;
wire           pro_in_table_id;
wire           pro_in_wr;
wire           pro_in_wr_en;
wire           rd_lut_en;

wire    [27:0] lut_pd;
wire           lut_table_id;
wire           mon_cmd_fifo_rd_pvld;

    
//==============
// Reg Configure
//==============
// get the width of all regs
//=======================================

//===========================================
// LUT Programing
//===========================================
assign lut_addr = reg2dp_lut_int_addr[9:0];
assign lut_data = reg2dp_lut_int_data[15:0];
assign lut_table_id = reg2dp_lut_int_table_id;
assign lut_access_type = reg2dp_lut_int_access_type;

assign lut_pd = {lut_access_type,lut_table_id,lut_data,lut_addr};
assign pro2lut_valid = reg2dp_lut_int_data_wr;
assign pro2lut_pd   = lut_pd;


// PKT_UNPACK_WIRE( sdp_y_lut_pro ,  pro_in_ ,  pro2lut_pd )
assign pro_in_addr[9:0]  =     pro2lut_pd[9:0];
assign pro_in_data[15:0] =     pro2lut_pd[25:10];
assign pro_in_table_id   =     pro2lut_pd[26];
assign pro_in_wr         =     pro2lut_pd[27];
assign pro_in_wr_en = pro2lut_valid & (pro_in_wr== 1'h1 );
//assign pro_in_rd_en = pro2lut_valid & pro_in_wr==0;
assign pro_in_select_le = pro_in_table_id== 1'h0 ;
assign pro_in_select_lo = pro_in_table_id== 1'h1 ;
//===========================================
// READ LUT
always @(
  pro_in_addr
  or REG_le_0
  or REG_le_1
  or REG_le_2
  or REG_le_3
  or REG_le_4
  or REG_le_5
  or REG_le_6
  or REG_le_7
  or REG_le_8
  or REG_le_9
  or REG_le_10
  or REG_le_11
  or REG_le_12
  or REG_le_13
  or REG_le_14
  or REG_le_15
  or REG_le_16
  or REG_le_17
  or REG_le_18
  or REG_le_19
  or REG_le_20
  or REG_le_21
  or REG_le_22
  or REG_le_23
  or REG_le_24
  or REG_le_25
  or REG_le_26
  or REG_le_27
  or REG_le_28
  or REG_le_29
  or REG_le_30
  or REG_le_31
  or REG_le_32
  or REG_le_33
  or REG_le_34
  or REG_le_35
  or REG_le_36
  or REG_le_37
  or REG_le_38
  or REG_le_39
  or REG_le_40
  or REG_le_41
  or REG_le_42
  or REG_le_43
  or REG_le_44
  or REG_le_45
  or REG_le_46
  or REG_le_47
  or REG_le_48
  or REG_le_49
  or REG_le_50
  or REG_le_51
  or REG_le_52
  or REG_le_53
  or REG_le_54
  or REG_le_55
  or REG_le_56
  or REG_le_57
  or REG_le_58
  or REG_le_59
  or REG_le_60
  or REG_le_61
  or REG_le_62
  or REG_le_63
  or REG_le_64
  ) begin
   case (pro_in_addr)
0: le_lut_data = REG_le_0;
1: le_lut_data = REG_le_1;
2: le_lut_data = REG_le_2;
3: le_lut_data = REG_le_3;
4: le_lut_data = REG_le_4;
5: le_lut_data = REG_le_5;
6: le_lut_data = REG_le_6;
7: le_lut_data = REG_le_7;
8: le_lut_data = REG_le_8;
9: le_lut_data = REG_le_9;
10: le_lut_data = REG_le_10;
11: le_lut_data = REG_le_11;
12: le_lut_data = REG_le_12;
13: le_lut_data = REG_le_13;
14: le_lut_data = REG_le_14;
15: le_lut_data = REG_le_15;
16: le_lut_data = REG_le_16;
17: le_lut_data = REG_le_17;
18: le_lut_data = REG_le_18;
19: le_lut_data = REG_le_19;
20: le_lut_data = REG_le_20;
21: le_lut_data = REG_le_21;
22: le_lut_data = REG_le_22;
23: le_lut_data = REG_le_23;
24: le_lut_data = REG_le_24;
25: le_lut_data = REG_le_25;
26: le_lut_data = REG_le_26;
27: le_lut_data = REG_le_27;
28: le_lut_data = REG_le_28;
29: le_lut_data = REG_le_29;
30: le_lut_data = REG_le_30;
31: le_lut_data = REG_le_31;
32: le_lut_data = REG_le_32;
33: le_lut_data = REG_le_33;
34: le_lut_data = REG_le_34;
35: le_lut_data = REG_le_35;
36: le_lut_data = REG_le_36;
37: le_lut_data = REG_le_37;
38: le_lut_data = REG_le_38;
39: le_lut_data = REG_le_39;
40: le_lut_data = REG_le_40;
41: le_lut_data = REG_le_41;
42: le_lut_data = REG_le_42;
43: le_lut_data = REG_le_43;
44: le_lut_data = REG_le_44;
45: le_lut_data = REG_le_45;
46: le_lut_data = REG_le_46;
47: le_lut_data = REG_le_47;
48: le_lut_data = REG_le_48;
49: le_lut_data = REG_le_49;
50: le_lut_data = REG_le_50;
51: le_lut_data = REG_le_51;
52: le_lut_data = REG_le_52;
53: le_lut_data = REG_le_53;
54: le_lut_data = REG_le_54;
55: le_lut_data = REG_le_55;
56: le_lut_data = REG_le_56;
57: le_lut_data = REG_le_57;
58: le_lut_data = REG_le_58;
59: le_lut_data = REG_le_59;
60: le_lut_data = REG_le_60;
61: le_lut_data = REG_le_61;
62: le_lut_data = REG_le_62;
63: le_lut_data = REG_le_63;
64: le_lut_data = REG_le_64;
   //VCS coverage off
   default : begin 
               le_lut_data[15:0] = {16{`x_or_0}};
             end  
   //VCS coverage on
   endcase
end
always @(
  pro_in_addr
  or REG_lo_0
  or REG_lo_1
  or REG_lo_2
  or REG_lo_3
  or REG_lo_4
  or REG_lo_5
  or REG_lo_6
  or REG_lo_7
  or REG_lo_8
  or REG_lo_9
  or REG_lo_10
  or REG_lo_11
  or REG_lo_12
  or REG_lo_13
  or REG_lo_14
  or REG_lo_15
  or REG_lo_16
  or REG_lo_17
  or REG_lo_18
  or REG_lo_19
  or REG_lo_20
  or REG_lo_21
  or REG_lo_22
  or REG_lo_23
  or REG_lo_24
  or REG_lo_25
  or REG_lo_26
  or REG_lo_27
  or REG_lo_28
  or REG_lo_29
  or REG_lo_30
  or REG_lo_31
  or REG_lo_32
  or REG_lo_33
  or REG_lo_34
  or REG_lo_35
  or REG_lo_36
  or REG_lo_37
  or REG_lo_38
  or REG_lo_39
  or REG_lo_40
  or REG_lo_41
  or REG_lo_42
  or REG_lo_43
  or REG_lo_44
  or REG_lo_45
  or REG_lo_46
  or REG_lo_47
  or REG_lo_48
  or REG_lo_49
  or REG_lo_50
  or REG_lo_51
  or REG_lo_52
  or REG_lo_53
  or REG_lo_54
  or REG_lo_55
  or REG_lo_56
  or REG_lo_57
  or REG_lo_58
  or REG_lo_59
  or REG_lo_60
  or REG_lo_61
  or REG_lo_62
  or REG_lo_63
  or REG_lo_64
  or REG_lo_65
  or REG_lo_66
  or REG_lo_67
  or REG_lo_68
  or REG_lo_69
  or REG_lo_70
  or REG_lo_71
  or REG_lo_72
  or REG_lo_73
  or REG_lo_74
  or REG_lo_75
  or REG_lo_76
  or REG_lo_77
  or REG_lo_78
  or REG_lo_79
  or REG_lo_80
  or REG_lo_81
  or REG_lo_82
  or REG_lo_83
  or REG_lo_84
  or REG_lo_85
  or REG_lo_86
  or REG_lo_87
  or REG_lo_88
  or REG_lo_89
  or REG_lo_90
  or REG_lo_91
  or REG_lo_92
  or REG_lo_93
  or REG_lo_94
  or REG_lo_95
  or REG_lo_96
  or REG_lo_97
  or REG_lo_98
  or REG_lo_99
  or REG_lo_100
  or REG_lo_101
  or REG_lo_102
  or REG_lo_103
  or REG_lo_104
  or REG_lo_105
  or REG_lo_106
  or REG_lo_107
  or REG_lo_108
  or REG_lo_109
  or REG_lo_110
  or REG_lo_111
  or REG_lo_112
  or REG_lo_113
  or REG_lo_114
  or REG_lo_115
  or REG_lo_116
  or REG_lo_117
  or REG_lo_118
  or REG_lo_119
  or REG_lo_120
  or REG_lo_121
  or REG_lo_122
  or REG_lo_123
  or REG_lo_124
  or REG_lo_125
  or REG_lo_126
  or REG_lo_127
  or REG_lo_128
  or REG_lo_129
  or REG_lo_130
  or REG_lo_131
  or REG_lo_132
  or REG_lo_133
  or REG_lo_134
  or REG_lo_135
  or REG_lo_136
  or REG_lo_137
  or REG_lo_138
  or REG_lo_139
  or REG_lo_140
  or REG_lo_141
  or REG_lo_142
  or REG_lo_143
  or REG_lo_144
  or REG_lo_145
  or REG_lo_146
  or REG_lo_147
  or REG_lo_148
  or REG_lo_149
  or REG_lo_150
  or REG_lo_151
  or REG_lo_152
  or REG_lo_153
  or REG_lo_154
  or REG_lo_155
  or REG_lo_156
  or REG_lo_157
  or REG_lo_158
  or REG_lo_159
  or REG_lo_160
  or REG_lo_161
  or REG_lo_162
  or REG_lo_163
  or REG_lo_164
  or REG_lo_165
  or REG_lo_166
  or REG_lo_167
  or REG_lo_168
  or REG_lo_169
  or REG_lo_170
  or REG_lo_171
  or REG_lo_172
  or REG_lo_173
  or REG_lo_174
  or REG_lo_175
  or REG_lo_176
  or REG_lo_177
  or REG_lo_178
  or REG_lo_179
  or REG_lo_180
  or REG_lo_181
  or REG_lo_182
  or REG_lo_183
  or REG_lo_184
  or REG_lo_185
  or REG_lo_186
  or REG_lo_187
  or REG_lo_188
  or REG_lo_189
  or REG_lo_190
  or REG_lo_191
  or REG_lo_192
  or REG_lo_193
  or REG_lo_194
  or REG_lo_195
  or REG_lo_196
  or REG_lo_197
  or REG_lo_198
  or REG_lo_199
  or REG_lo_200
  or REG_lo_201
  or REG_lo_202
  or REG_lo_203
  or REG_lo_204
  or REG_lo_205
  or REG_lo_206
  or REG_lo_207
  or REG_lo_208
  or REG_lo_209
  or REG_lo_210
  or REG_lo_211
  or REG_lo_212
  or REG_lo_213
  or REG_lo_214
  or REG_lo_215
  or REG_lo_216
  or REG_lo_217
  or REG_lo_218
  or REG_lo_219
  or REG_lo_220
  or REG_lo_221
  or REG_lo_222
  or REG_lo_223
  or REG_lo_224
  or REG_lo_225
  or REG_lo_226
  or REG_lo_227
  or REG_lo_228
  or REG_lo_229
  or REG_lo_230
  or REG_lo_231
  or REG_lo_232
  or REG_lo_233
  or REG_lo_234
  or REG_lo_235
  or REG_lo_236
  or REG_lo_237
  or REG_lo_238
  or REG_lo_239
  or REG_lo_240
  or REG_lo_241
  or REG_lo_242
  or REG_lo_243
  or REG_lo_244
  or REG_lo_245
  or REG_lo_246
  or REG_lo_247
  or REG_lo_248
  or REG_lo_249
  or REG_lo_250
  or REG_lo_251
  or REG_lo_252
  or REG_lo_253
  or REG_lo_254
  or REG_lo_255
  or REG_lo_256
  ) begin
   case (pro_in_addr)
0: lo_lut_data = REG_lo_0;
1: lo_lut_data = REG_lo_1;
2: lo_lut_data = REG_lo_2;
3: lo_lut_data = REG_lo_3;
4: lo_lut_data = REG_lo_4;
5: lo_lut_data = REG_lo_5;
6: lo_lut_data = REG_lo_6;
7: lo_lut_data = REG_lo_7;
8: lo_lut_data = REG_lo_8;
9: lo_lut_data = REG_lo_9;
10: lo_lut_data = REG_lo_10;
11: lo_lut_data = REG_lo_11;
12: lo_lut_data = REG_lo_12;
13: lo_lut_data = REG_lo_13;
14: lo_lut_data = REG_lo_14;
15: lo_lut_data = REG_lo_15;
16: lo_lut_data = REG_lo_16;
17: lo_lut_data = REG_lo_17;
18: lo_lut_data = REG_lo_18;
19: lo_lut_data = REG_lo_19;
20: lo_lut_data = REG_lo_20;
21: lo_lut_data = REG_lo_21;
22: lo_lut_data = REG_lo_22;
23: lo_lut_data = REG_lo_23;
24: lo_lut_data = REG_lo_24;
25: lo_lut_data = REG_lo_25;
26: lo_lut_data = REG_lo_26;
27: lo_lut_data = REG_lo_27;
28: lo_lut_data = REG_lo_28;
29: lo_lut_data = REG_lo_29;
30: lo_lut_data = REG_lo_30;
31: lo_lut_data = REG_lo_31;
32: lo_lut_data = REG_lo_32;
33: lo_lut_data = REG_lo_33;
34: lo_lut_data = REG_lo_34;
35: lo_lut_data = REG_lo_35;
36: lo_lut_data = REG_lo_36;
37: lo_lut_data = REG_lo_37;
38: lo_lut_data = REG_lo_38;
39: lo_lut_data = REG_lo_39;
40: lo_lut_data = REG_lo_40;
41: lo_lut_data = REG_lo_41;
42: lo_lut_data = REG_lo_42;
43: lo_lut_data = REG_lo_43;
44: lo_lut_data = REG_lo_44;
45: lo_lut_data = REG_lo_45;
46: lo_lut_data = REG_lo_46;
47: lo_lut_data = REG_lo_47;
48: lo_lut_data = REG_lo_48;
49: lo_lut_data = REG_lo_49;
50: lo_lut_data = REG_lo_50;
51: lo_lut_data = REG_lo_51;
52: lo_lut_data = REG_lo_52;
53: lo_lut_data = REG_lo_53;
54: lo_lut_data = REG_lo_54;
55: lo_lut_data = REG_lo_55;
56: lo_lut_data = REG_lo_56;
57: lo_lut_data = REG_lo_57;
58: lo_lut_data = REG_lo_58;
59: lo_lut_data = REG_lo_59;
60: lo_lut_data = REG_lo_60;
61: lo_lut_data = REG_lo_61;
62: lo_lut_data = REG_lo_62;
63: lo_lut_data = REG_lo_63;
64: lo_lut_data = REG_lo_64;
65: lo_lut_data = REG_lo_65;
66: lo_lut_data = REG_lo_66;
67: lo_lut_data = REG_lo_67;
68: lo_lut_data = REG_lo_68;
69: lo_lut_data = REG_lo_69;
70: lo_lut_data = REG_lo_70;
71: lo_lut_data = REG_lo_71;
72: lo_lut_data = REG_lo_72;
73: lo_lut_data = REG_lo_73;
74: lo_lut_data = REG_lo_74;
75: lo_lut_data = REG_lo_75;
76: lo_lut_data = REG_lo_76;
77: lo_lut_data = REG_lo_77;
78: lo_lut_data = REG_lo_78;
79: lo_lut_data = REG_lo_79;
80: lo_lut_data = REG_lo_80;
81: lo_lut_data = REG_lo_81;
82: lo_lut_data = REG_lo_82;
83: lo_lut_data = REG_lo_83;
84: lo_lut_data = REG_lo_84;
85: lo_lut_data = REG_lo_85;
86: lo_lut_data = REG_lo_86;
87: lo_lut_data = REG_lo_87;
88: lo_lut_data = REG_lo_88;
89: lo_lut_data = REG_lo_89;
90: lo_lut_data = REG_lo_90;
91: lo_lut_data = REG_lo_91;
92: lo_lut_data = REG_lo_92;
93: lo_lut_data = REG_lo_93;
94: lo_lut_data = REG_lo_94;
95: lo_lut_data = REG_lo_95;
96: lo_lut_data = REG_lo_96;
97: lo_lut_data = REG_lo_97;
98: lo_lut_data = REG_lo_98;
99: lo_lut_data = REG_lo_99;
100: lo_lut_data = REG_lo_100;
101: lo_lut_data = REG_lo_101;
102: lo_lut_data = REG_lo_102;
103: lo_lut_data = REG_lo_103;
104: lo_lut_data = REG_lo_104;
105: lo_lut_data = REG_lo_105;
106: lo_lut_data = REG_lo_106;
107: lo_lut_data = REG_lo_107;
108: lo_lut_data = REG_lo_108;
109: lo_lut_data = REG_lo_109;
110: lo_lut_data = REG_lo_110;
111: lo_lut_data = REG_lo_111;
112: lo_lut_data = REG_lo_112;
113: lo_lut_data = REG_lo_113;
114: lo_lut_data = REG_lo_114;
115: lo_lut_data = REG_lo_115;
116: lo_lut_data = REG_lo_116;
117: lo_lut_data = REG_lo_117;
118: lo_lut_data = REG_lo_118;
119: lo_lut_data = REG_lo_119;
120: lo_lut_data = REG_lo_120;
121: lo_lut_data = REG_lo_121;
122: lo_lut_data = REG_lo_122;
123: lo_lut_data = REG_lo_123;
124: lo_lut_data = REG_lo_124;
125: lo_lut_data = REG_lo_125;
126: lo_lut_data = REG_lo_126;
127: lo_lut_data = REG_lo_127;
128: lo_lut_data = REG_lo_128;
129: lo_lut_data = REG_lo_129;
130: lo_lut_data = REG_lo_130;
131: lo_lut_data = REG_lo_131;
132: lo_lut_data = REG_lo_132;
133: lo_lut_data = REG_lo_133;
134: lo_lut_data = REG_lo_134;
135: lo_lut_data = REG_lo_135;
136: lo_lut_data = REG_lo_136;
137: lo_lut_data = REG_lo_137;
138: lo_lut_data = REG_lo_138;
139: lo_lut_data = REG_lo_139;
140: lo_lut_data = REG_lo_140;
141: lo_lut_data = REG_lo_141;
142: lo_lut_data = REG_lo_142;
143: lo_lut_data = REG_lo_143;
144: lo_lut_data = REG_lo_144;
145: lo_lut_data = REG_lo_145;
146: lo_lut_data = REG_lo_146;
147: lo_lut_data = REG_lo_147;
148: lo_lut_data = REG_lo_148;
149: lo_lut_data = REG_lo_149;
150: lo_lut_data = REG_lo_150;
151: lo_lut_data = REG_lo_151;
152: lo_lut_data = REG_lo_152;
153: lo_lut_data = REG_lo_153;
154: lo_lut_data = REG_lo_154;
155: lo_lut_data = REG_lo_155;
156: lo_lut_data = REG_lo_156;
157: lo_lut_data = REG_lo_157;
158: lo_lut_data = REG_lo_158;
159: lo_lut_data = REG_lo_159;
160: lo_lut_data = REG_lo_160;
161: lo_lut_data = REG_lo_161;
162: lo_lut_data = REG_lo_162;
163: lo_lut_data = REG_lo_163;
164: lo_lut_data = REG_lo_164;
165: lo_lut_data = REG_lo_165;
166: lo_lut_data = REG_lo_166;
167: lo_lut_data = REG_lo_167;
168: lo_lut_data = REG_lo_168;
169: lo_lut_data = REG_lo_169;
170: lo_lut_data = REG_lo_170;
171: lo_lut_data = REG_lo_171;
172: lo_lut_data = REG_lo_172;
173: lo_lut_data = REG_lo_173;
174: lo_lut_data = REG_lo_174;
175: lo_lut_data = REG_lo_175;
176: lo_lut_data = REG_lo_176;
177: lo_lut_data = REG_lo_177;
178: lo_lut_data = REG_lo_178;
179: lo_lut_data = REG_lo_179;
180: lo_lut_data = REG_lo_180;
181: lo_lut_data = REG_lo_181;
182: lo_lut_data = REG_lo_182;
183: lo_lut_data = REG_lo_183;
184: lo_lut_data = REG_lo_184;
185: lo_lut_data = REG_lo_185;
186: lo_lut_data = REG_lo_186;
187: lo_lut_data = REG_lo_187;
188: lo_lut_data = REG_lo_188;
189: lo_lut_data = REG_lo_189;
190: lo_lut_data = REG_lo_190;
191: lo_lut_data = REG_lo_191;
192: lo_lut_data = REG_lo_192;
193: lo_lut_data = REG_lo_193;
194: lo_lut_data = REG_lo_194;
195: lo_lut_data = REG_lo_195;
196: lo_lut_data = REG_lo_196;
197: lo_lut_data = REG_lo_197;
198: lo_lut_data = REG_lo_198;
199: lo_lut_data = REG_lo_199;
200: lo_lut_data = REG_lo_200;
201: lo_lut_data = REG_lo_201;
202: lo_lut_data = REG_lo_202;
203: lo_lut_data = REG_lo_203;
204: lo_lut_data = REG_lo_204;
205: lo_lut_data = REG_lo_205;
206: lo_lut_data = REG_lo_206;
207: lo_lut_data = REG_lo_207;
208: lo_lut_data = REG_lo_208;
209: lo_lut_data = REG_lo_209;
210: lo_lut_data = REG_lo_210;
211: lo_lut_data = REG_lo_211;
212: lo_lut_data = REG_lo_212;
213: lo_lut_data = REG_lo_213;
214: lo_lut_data = REG_lo_214;
215: lo_lut_data = REG_lo_215;
216: lo_lut_data = REG_lo_216;
217: lo_lut_data = REG_lo_217;
218: lo_lut_data = REG_lo_218;
219: lo_lut_data = REG_lo_219;
220: lo_lut_data = REG_lo_220;
221: lo_lut_data = REG_lo_221;
222: lo_lut_data = REG_lo_222;
223: lo_lut_data = REG_lo_223;
224: lo_lut_data = REG_lo_224;
225: lo_lut_data = REG_lo_225;
226: lo_lut_data = REG_lo_226;
227: lo_lut_data = REG_lo_227;
228: lo_lut_data = REG_lo_228;
229: lo_lut_data = REG_lo_229;
230: lo_lut_data = REG_lo_230;
231: lo_lut_data = REG_lo_231;
232: lo_lut_data = REG_lo_232;
233: lo_lut_data = REG_lo_233;
234: lo_lut_data = REG_lo_234;
235: lo_lut_data = REG_lo_235;
236: lo_lut_data = REG_lo_236;
237: lo_lut_data = REG_lo_237;
238: lo_lut_data = REG_lo_238;
239: lo_lut_data = REG_lo_239;
240: lo_lut_data = REG_lo_240;
241: lo_lut_data = REG_lo_241;
242: lo_lut_data = REG_lo_242;
243: lo_lut_data = REG_lo_243;
244: lo_lut_data = REG_lo_244;
245: lo_lut_data = REG_lo_245;
246: lo_lut_data = REG_lo_246;
247: lo_lut_data = REG_lo_247;
248: lo_lut_data = REG_lo_248;
249: lo_lut_data = REG_lo_249;
250: lo_lut_data = REG_lo_250;
251: lo_lut_data = REG_lo_251;
252: lo_lut_data = REG_lo_252;
253: lo_lut_data = REG_lo_253;
254: lo_lut_data = REG_lo_254;
255: lo_lut_data = REG_lo_255;
256: lo_lut_data = REG_lo_256;
   //VCS coverage off
   default : begin 
               lo_lut_data[15:0] = {16{`x_or_0}};
             end  
   //VCS coverage on
   endcase
end
assign dp2reg_lut_int_data = pro_in_select_le ? le_lut_data : lo_lut_data;

//=======================================
// WRITE LUT
assign le_wr_en_0 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==0);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_0 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_0) == 1'b1) begin
    REG_le_0 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_0) == 1'b0) begin
  end else begin
    REG_le_0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_1 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==1);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_1 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_1) == 1'b1) begin
    REG_le_1 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_1) == 1'b0) begin
  end else begin
    REG_le_1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_2x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_2 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==2);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_2 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_2) == 1'b1) begin
    REG_le_2 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_2) == 1'b0) begin
  end else begin
    REG_le_2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_3 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==3);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_3 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_3) == 1'b1) begin
    REG_le_3 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_3) == 1'b0) begin
  end else begin
    REG_le_3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_4x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_3))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_4 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==4);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_4 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_4) == 1'b1) begin
    REG_le_4 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_4) == 1'b0) begin
  end else begin
    REG_le_4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_4))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_5 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==5);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_5 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_5) == 1'b1) begin
    REG_le_5 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_5) == 1'b0) begin
  end else begin
    REG_le_5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_6x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_5))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_6 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==6);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_6 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_6) == 1'b1) begin
    REG_le_6 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_6) == 1'b0) begin
  end else begin
    REG_le_6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_6))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_7 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==7);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_7 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_7) == 1'b1) begin
    REG_le_7 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_7) == 1'b0) begin
  end else begin
    REG_le_7 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_8x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_7))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_8 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==8);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_8 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_8) == 1'b1) begin
    REG_le_8 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_8) == 1'b0) begin
  end else begin
    REG_le_8 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_8))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_9 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==9);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_9 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_9) == 1'b1) begin
    REG_le_9 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_9) == 1'b0) begin
  end else begin
    REG_le_9 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_10x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_9))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_10 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==10);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_10 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_10) == 1'b1) begin
    REG_le_10 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_10) == 1'b0) begin
  end else begin
    REG_le_10 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_11x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_10))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_11 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==11);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_11 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_11) == 1'b1) begin
    REG_le_11 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_11) == 1'b0) begin
  end else begin
    REG_le_11 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_12x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_11))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_12 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==12);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_12 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_12) == 1'b1) begin
    REG_le_12 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_12) == 1'b0) begin
  end else begin
    REG_le_12 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_13x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_12))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_13 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==13);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_13 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_13) == 1'b1) begin
    REG_le_13 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_13) == 1'b0) begin
  end else begin
    REG_le_13 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_14x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_13))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_14 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==14);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_14 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_14) == 1'b1) begin
    REG_le_14 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_14) == 1'b0) begin
  end else begin
    REG_le_14 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_15x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_14))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_15 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==15);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_15 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_15) == 1'b1) begin
    REG_le_15 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_15) == 1'b0) begin
  end else begin
    REG_le_15 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_16x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_15))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_16 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==16);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_16 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_16) == 1'b1) begin
    REG_le_16 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_16) == 1'b0) begin
  end else begin
    REG_le_16 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_17x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_16))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_17 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==17);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_17 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_17) == 1'b1) begin
    REG_le_17 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_17) == 1'b0) begin
  end else begin
    REG_le_17 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_18x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_17))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_18 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==18);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_18 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_18) == 1'b1) begin
    REG_le_18 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_18) == 1'b0) begin
  end else begin
    REG_le_18 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_19x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_18))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_19 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==19);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_19 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_19) == 1'b1) begin
    REG_le_19 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_19) == 1'b0) begin
  end else begin
    REG_le_19 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_20x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_19))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_20 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==20);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_20 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_20) == 1'b1) begin
    REG_le_20 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_20) == 1'b0) begin
  end else begin
    REG_le_20 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_21x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_20))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_21 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==21);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_21 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_21) == 1'b1) begin
    REG_le_21 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_21) == 1'b0) begin
  end else begin
    REG_le_21 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_22x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_21))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_22 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==22);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_22 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_22) == 1'b1) begin
    REG_le_22 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_22) == 1'b0) begin
  end else begin
    REG_le_22 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_23x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_22))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_23 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==23);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_23 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_23) == 1'b1) begin
    REG_le_23 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_23) == 1'b0) begin
  end else begin
    REG_le_23 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_24x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_23))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_24 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==24);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_24 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_24) == 1'b1) begin
    REG_le_24 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_24) == 1'b0) begin
  end else begin
    REG_le_24 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_25x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_24))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_25 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==25);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_25 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_25) == 1'b1) begin
    REG_le_25 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_25) == 1'b0) begin
  end else begin
    REG_le_25 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_26x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_25))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_26 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==26);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_26 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_26) == 1'b1) begin
    REG_le_26 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_26) == 1'b0) begin
  end else begin
    REG_le_26 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_27x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_26))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_27 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==27);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_27 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_27) == 1'b1) begin
    REG_le_27 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_27) == 1'b0) begin
  end else begin
    REG_le_27 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_28x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_27))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_28 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==28);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_28 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_28) == 1'b1) begin
    REG_le_28 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_28) == 1'b0) begin
  end else begin
    REG_le_28 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_29x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_28))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_29 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==29);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_29 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_29) == 1'b1) begin
    REG_le_29 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_29) == 1'b0) begin
  end else begin
    REG_le_29 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_30x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_29))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_30 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==30);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_30 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_30) == 1'b1) begin
    REG_le_30 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_30) == 1'b0) begin
  end else begin
    REG_le_30 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_31x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_30))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_31 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==31);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_31 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_31) == 1'b1) begin
    REG_le_31 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_31) == 1'b0) begin
  end else begin
    REG_le_31 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_32x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_31))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_32 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==32);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_32 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_32) == 1'b1) begin
    REG_le_32 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_32) == 1'b0) begin
  end else begin
    REG_le_32 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_33x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_32))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_33 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==33);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_33 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_33) == 1'b1) begin
    REG_le_33 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_33) == 1'b0) begin
  end else begin
    REG_le_33 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_34x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_33))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_34 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==34);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_34 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_34) == 1'b1) begin
    REG_le_34 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_34) == 1'b0) begin
  end else begin
    REG_le_34 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_35x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_34))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_35 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==35);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_35 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_35) == 1'b1) begin
    REG_le_35 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_35) == 1'b0) begin
  end else begin
    REG_le_35 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_36x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_35))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_36 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==36);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_36 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_36) == 1'b1) begin
    REG_le_36 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_36) == 1'b0) begin
  end else begin
    REG_le_36 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_37x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_36))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_37 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==37);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_37 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_37) == 1'b1) begin
    REG_le_37 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_37) == 1'b0) begin
  end else begin
    REG_le_37 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_38x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_37))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_38 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==38);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_38 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_38) == 1'b1) begin
    REG_le_38 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_38) == 1'b0) begin
  end else begin
    REG_le_38 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_39x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_38))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_39 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==39);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_39 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_39) == 1'b1) begin
    REG_le_39 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_39) == 1'b0) begin
  end else begin
    REG_le_39 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_40x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_39))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_40 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==40);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_40 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_40) == 1'b1) begin
    REG_le_40 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_40) == 1'b0) begin
  end else begin
    REG_le_40 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_41x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_40))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_41 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==41);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_41 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_41) == 1'b1) begin
    REG_le_41 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_41) == 1'b0) begin
  end else begin
    REG_le_41 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_42x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_41))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_42 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==42);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_42 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_42) == 1'b1) begin
    REG_le_42 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_42) == 1'b0) begin
  end else begin
    REG_le_42 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_43x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_42))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_43 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==43);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_43 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_43) == 1'b1) begin
    REG_le_43 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_43) == 1'b0) begin
  end else begin
    REG_le_43 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_44x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_43))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_44 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==44);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_44 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_44) == 1'b1) begin
    REG_le_44 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_44) == 1'b0) begin
  end else begin
    REG_le_44 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_45x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_44))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_45 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==45);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_45 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_45) == 1'b1) begin
    REG_le_45 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_45) == 1'b0) begin
  end else begin
    REG_le_45 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_46x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_45))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_46 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==46);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_46 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_46) == 1'b1) begin
    REG_le_46 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_46) == 1'b0) begin
  end else begin
    REG_le_46 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_47x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_46))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_47 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==47);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_47 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_47) == 1'b1) begin
    REG_le_47 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_47) == 1'b0) begin
  end else begin
    REG_le_47 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_48x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_47))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_48 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==48);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_48 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_48) == 1'b1) begin
    REG_le_48 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_48) == 1'b0) begin
  end else begin
    REG_le_48 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_49x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_48))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_49 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==49);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_49 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_49) == 1'b1) begin
    REG_le_49 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_49) == 1'b0) begin
  end else begin
    REG_le_49 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_50x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_49))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_50 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==50);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_50 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_50) == 1'b1) begin
    REG_le_50 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_50) == 1'b0) begin
  end else begin
    REG_le_50 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_51x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_50))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_51 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==51);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_51 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_51) == 1'b1) begin
    REG_le_51 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_51) == 1'b0) begin
  end else begin
    REG_le_51 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_52x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_51))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_52 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==52);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_52 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_52) == 1'b1) begin
    REG_le_52 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_52) == 1'b0) begin
  end else begin
    REG_le_52 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_53x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_52))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_53 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==53);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_53 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_53) == 1'b1) begin
    REG_le_53 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_53) == 1'b0) begin
  end else begin
    REG_le_53 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_54x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_53))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_54 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==54);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_54 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_54) == 1'b1) begin
    REG_le_54 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_54) == 1'b0) begin
  end else begin
    REG_le_54 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_55x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_54))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_55 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==55);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_55 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_55) == 1'b1) begin
    REG_le_55 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_55) == 1'b0) begin
  end else begin
    REG_le_55 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_56x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_55))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_56 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==56);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_56 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_56) == 1'b1) begin
    REG_le_56 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_56) == 1'b0) begin
  end else begin
    REG_le_56 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_57x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_56))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_57 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==57);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_57 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_57) == 1'b1) begin
    REG_le_57 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_57) == 1'b0) begin
  end else begin
    REG_le_57 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_58x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_57))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_58 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==58);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_58 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_58) == 1'b1) begin
    REG_le_58 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_58) == 1'b0) begin
  end else begin
    REG_le_58 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_59x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_58))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_59 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==59);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_59 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_59) == 1'b1) begin
    REG_le_59 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_59) == 1'b0) begin
  end else begin
    REG_le_59 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_60x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_59))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_60 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==60);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_60 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_60) == 1'b1) begin
    REG_le_60 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_60) == 1'b0) begin
  end else begin
    REG_le_60 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_61x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_60))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_61 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==61);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_61 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_61) == 1'b1) begin
    REG_le_61 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_61) == 1'b0) begin
  end else begin
    REG_le_61 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_62x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_61))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_62 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==62);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_62 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_62) == 1'b1) begin
    REG_le_62 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_62) == 1'b0) begin
  end else begin
    REG_le_62 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_63x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_62))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_63 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==63);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_63 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_63) == 1'b1) begin
    REG_le_63 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_63) == 1'b0) begin
  end else begin
    REG_le_63 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_64x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_63))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign le_wr_en_64 = pro_in_wr_en & pro_in_select_le & (pro_in_addr==64);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_le_64 <= {16{1'b0}};
  end else begin
  if ((le_wr_en_64) == 1'b1) begin
    REG_le_64 <= pro_in_data;
  // VCS coverage off
  end else if ((le_wr_en_64) == 1'b0) begin
  end else begin
    REG_le_64 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_65x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(le_wr_en_64))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign REG_le_65 = {16{`tick_x_or_0}};

assign REG_le_66 = {16{`tick_x_or_0}};

assign REG_le_67 = {16{`tick_x_or_0}};

assign REG_le_68 = {16{`tick_x_or_0}};

assign REG_le_69 = {16{`tick_x_or_0}};

assign REG_le_70 = {16{`tick_x_or_0}};

assign REG_le_71 = {16{`tick_x_or_0}};

assign REG_le_72 = {16{`tick_x_or_0}};

assign REG_le_73 = {16{`tick_x_or_0}};

assign REG_le_74 = {16{`tick_x_or_0}};

assign REG_le_75 = {16{`tick_x_or_0}};

assign REG_le_76 = {16{`tick_x_or_0}};

assign REG_le_77 = {16{`tick_x_or_0}};

assign REG_le_78 = {16{`tick_x_or_0}};

assign REG_le_79 = {16{`tick_x_or_0}};

assign REG_le_80 = {16{`tick_x_or_0}};

assign REG_le_81 = {16{`tick_x_or_0}};

assign REG_le_82 = {16{`tick_x_or_0}};

assign REG_le_83 = {16{`tick_x_or_0}};

assign REG_le_84 = {16{`tick_x_or_0}};

assign REG_le_85 = {16{`tick_x_or_0}};

assign REG_le_86 = {16{`tick_x_or_0}};

assign REG_le_87 = {16{`tick_x_or_0}};

assign REG_le_88 = {16{`tick_x_or_0}};

assign REG_le_89 = {16{`tick_x_or_0}};

assign REG_le_90 = {16{`tick_x_or_0}};

assign REG_le_91 = {16{`tick_x_or_0}};

assign REG_le_92 = {16{`tick_x_or_0}};

assign REG_le_93 = {16{`tick_x_or_0}};

assign REG_le_94 = {16{`tick_x_or_0}};

assign REG_le_95 = {16{`tick_x_or_0}};

assign REG_le_96 = {16{`tick_x_or_0}};

assign REG_le_97 = {16{`tick_x_or_0}};

assign REG_le_98 = {16{`tick_x_or_0}};

assign REG_le_99 = {16{`tick_x_or_0}};

assign REG_le_100 = {16{`tick_x_or_0}};

assign REG_le_101 = {16{`tick_x_or_0}};

assign REG_le_102 = {16{`tick_x_or_0}};

assign REG_le_103 = {16{`tick_x_or_0}};

assign REG_le_104 = {16{`tick_x_or_0}};

assign REG_le_105 = {16{`tick_x_or_0}};

assign REG_le_106 = {16{`tick_x_or_0}};

assign REG_le_107 = {16{`tick_x_or_0}};

assign REG_le_108 = {16{`tick_x_or_0}};

assign REG_le_109 = {16{`tick_x_or_0}};

assign REG_le_110 = {16{`tick_x_or_0}};

assign REG_le_111 = {16{`tick_x_or_0}};

assign REG_le_112 = {16{`tick_x_or_0}};

assign REG_le_113 = {16{`tick_x_or_0}};

assign REG_le_114 = {16{`tick_x_or_0}};

assign REG_le_115 = {16{`tick_x_or_0}};

assign REG_le_116 = {16{`tick_x_or_0}};

assign REG_le_117 = {16{`tick_x_or_0}};

assign REG_le_118 = {16{`tick_x_or_0}};

assign REG_le_119 = {16{`tick_x_or_0}};

assign REG_le_120 = {16{`tick_x_or_0}};

assign REG_le_121 = {16{`tick_x_or_0}};

assign REG_le_122 = {16{`tick_x_or_0}};

assign REG_le_123 = {16{`tick_x_or_0}};

assign REG_le_124 = {16{`tick_x_or_0}};

assign REG_le_125 = {16{`tick_x_or_0}};

assign REG_le_126 = {16{`tick_x_or_0}};

assign REG_le_127 = {16{`tick_x_or_0}};

assign REG_le_128 = {16{`tick_x_or_0}};

assign REG_le_129 = {16{`tick_x_or_0}};

assign REG_le_130 = {16{`tick_x_or_0}};

assign REG_le_131 = {16{`tick_x_or_0}};

assign REG_le_132 = {16{`tick_x_or_0}};

assign REG_le_133 = {16{`tick_x_or_0}};

assign REG_le_134 = {16{`tick_x_or_0}};

assign REG_le_135 = {16{`tick_x_or_0}};

assign REG_le_136 = {16{`tick_x_or_0}};

assign REG_le_137 = {16{`tick_x_or_0}};

assign REG_le_138 = {16{`tick_x_or_0}};

assign REG_le_139 = {16{`tick_x_or_0}};

assign REG_le_140 = {16{`tick_x_or_0}};

assign REG_le_141 = {16{`tick_x_or_0}};

assign REG_le_142 = {16{`tick_x_or_0}};

assign REG_le_143 = {16{`tick_x_or_0}};

assign REG_le_144 = {16{`tick_x_or_0}};

assign REG_le_145 = {16{`tick_x_or_0}};

assign REG_le_146 = {16{`tick_x_or_0}};

assign REG_le_147 = {16{`tick_x_or_0}};

assign REG_le_148 = {16{`tick_x_or_0}};

assign REG_le_149 = {16{`tick_x_or_0}};

assign REG_le_150 = {16{`tick_x_or_0}};

assign REG_le_151 = {16{`tick_x_or_0}};

assign REG_le_152 = {16{`tick_x_or_0}};

assign REG_le_153 = {16{`tick_x_or_0}};

assign REG_le_154 = {16{`tick_x_or_0}};

assign REG_le_155 = {16{`tick_x_or_0}};

assign REG_le_156 = {16{`tick_x_or_0}};

assign REG_le_157 = {16{`tick_x_or_0}};

assign REG_le_158 = {16{`tick_x_or_0}};

assign REG_le_159 = {16{`tick_x_or_0}};

assign REG_le_160 = {16{`tick_x_or_0}};

assign REG_le_161 = {16{`tick_x_or_0}};

assign REG_le_162 = {16{`tick_x_or_0}};

assign REG_le_163 = {16{`tick_x_or_0}};

assign REG_le_164 = {16{`tick_x_or_0}};

assign REG_le_165 = {16{`tick_x_or_0}};

assign REG_le_166 = {16{`tick_x_or_0}};

assign REG_le_167 = {16{`tick_x_or_0}};

assign REG_le_168 = {16{`tick_x_or_0}};

assign REG_le_169 = {16{`tick_x_or_0}};

assign REG_le_170 = {16{`tick_x_or_0}};

assign REG_le_171 = {16{`tick_x_or_0}};

assign REG_le_172 = {16{`tick_x_or_0}};

assign REG_le_173 = {16{`tick_x_or_0}};

assign REG_le_174 = {16{`tick_x_or_0}};

assign REG_le_175 = {16{`tick_x_or_0}};

assign REG_le_176 = {16{`tick_x_or_0}};

assign REG_le_177 = {16{`tick_x_or_0}};

assign REG_le_178 = {16{`tick_x_or_0}};

assign REG_le_179 = {16{`tick_x_or_0}};

assign REG_le_180 = {16{`tick_x_or_0}};

assign REG_le_181 = {16{`tick_x_or_0}};

assign REG_le_182 = {16{`tick_x_or_0}};

assign REG_le_183 = {16{`tick_x_or_0}};

assign REG_le_184 = {16{`tick_x_or_0}};

assign REG_le_185 = {16{`tick_x_or_0}};

assign REG_le_186 = {16{`tick_x_or_0}};

assign REG_le_187 = {16{`tick_x_or_0}};

assign REG_le_188 = {16{`tick_x_or_0}};

assign REG_le_189 = {16{`tick_x_or_0}};

assign REG_le_190 = {16{`tick_x_or_0}};

assign REG_le_191 = {16{`tick_x_or_0}};

assign REG_le_192 = {16{`tick_x_or_0}};

assign REG_le_193 = {16{`tick_x_or_0}};

assign REG_le_194 = {16{`tick_x_or_0}};

assign REG_le_195 = {16{`tick_x_or_0}};

assign REG_le_196 = {16{`tick_x_or_0}};

assign REG_le_197 = {16{`tick_x_or_0}};

assign REG_le_198 = {16{`tick_x_or_0}};

assign REG_le_199 = {16{`tick_x_or_0}};

assign REG_le_200 = {16{`tick_x_or_0}};

assign REG_le_201 = {16{`tick_x_or_0}};

assign REG_le_202 = {16{`tick_x_or_0}};

assign REG_le_203 = {16{`tick_x_or_0}};

assign REG_le_204 = {16{`tick_x_or_0}};

assign REG_le_205 = {16{`tick_x_or_0}};

assign REG_le_206 = {16{`tick_x_or_0}};

assign REG_le_207 = {16{`tick_x_or_0}};

assign REG_le_208 = {16{`tick_x_or_0}};

assign REG_le_209 = {16{`tick_x_or_0}};

assign REG_le_210 = {16{`tick_x_or_0}};

assign REG_le_211 = {16{`tick_x_or_0}};

assign REG_le_212 = {16{`tick_x_or_0}};

assign REG_le_213 = {16{`tick_x_or_0}};

assign REG_le_214 = {16{`tick_x_or_0}};

assign REG_le_215 = {16{`tick_x_or_0}};

assign REG_le_216 = {16{`tick_x_or_0}};

assign REG_le_217 = {16{`tick_x_or_0}};

assign REG_le_218 = {16{`tick_x_or_0}};

assign REG_le_219 = {16{`tick_x_or_0}};

assign REG_le_220 = {16{`tick_x_or_0}};

assign REG_le_221 = {16{`tick_x_or_0}};

assign REG_le_222 = {16{`tick_x_or_0}};

assign REG_le_223 = {16{`tick_x_or_0}};

assign REG_le_224 = {16{`tick_x_or_0}};

assign REG_le_225 = {16{`tick_x_or_0}};

assign REG_le_226 = {16{`tick_x_or_0}};

assign REG_le_227 = {16{`tick_x_or_0}};

assign REG_le_228 = {16{`tick_x_or_0}};

assign REG_le_229 = {16{`tick_x_or_0}};

assign REG_le_230 = {16{`tick_x_or_0}};

assign REG_le_231 = {16{`tick_x_or_0}};

assign REG_le_232 = {16{`tick_x_or_0}};

assign REG_le_233 = {16{`tick_x_or_0}};

assign REG_le_234 = {16{`tick_x_or_0}};

assign REG_le_235 = {16{`tick_x_or_0}};

assign REG_le_236 = {16{`tick_x_or_0}};

assign REG_le_237 = {16{`tick_x_or_0}};

assign REG_le_238 = {16{`tick_x_or_0}};

assign REG_le_239 = {16{`tick_x_or_0}};

assign REG_le_240 = {16{`tick_x_or_0}};

assign REG_le_241 = {16{`tick_x_or_0}};

assign REG_le_242 = {16{`tick_x_or_0}};

assign REG_le_243 = {16{`tick_x_or_0}};

assign REG_le_244 = {16{`tick_x_or_0}};

assign REG_le_245 = {16{`tick_x_or_0}};

assign REG_le_246 = {16{`tick_x_or_0}};

assign REG_le_247 = {16{`tick_x_or_0}};

assign REG_le_248 = {16{`tick_x_or_0}};

assign REG_le_249 = {16{`tick_x_or_0}};

assign REG_le_250 = {16{`tick_x_or_0}};

assign REG_le_251 = {16{`tick_x_or_0}};

assign REG_le_252 = {16{`tick_x_or_0}};

assign REG_le_253 = {16{`tick_x_or_0}};

assign REG_le_254 = {16{`tick_x_or_0}};

assign REG_le_255 = {16{`tick_x_or_0}};

assign REG_le_256 = {16{`tick_x_or_0}};


assign lo_wr_en_0 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==0);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_0 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_0) == 1'b1) begin
    REG_lo_0 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_0) == 1'b0) begin
  end else begin
    REG_lo_0 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_66x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_0))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_1 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==1);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_1 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_1) == 1'b1) begin
    REG_lo_1 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_1) == 1'b0) begin
  end else begin
    REG_lo_1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_67x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_1))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_2 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==2);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_2 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_2) == 1'b1) begin
    REG_lo_2 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_2) == 1'b0) begin
  end else begin
    REG_lo_2 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_68x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_2))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_3 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==3);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_3 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_3) == 1'b1) begin
    REG_lo_3 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_3) == 1'b0) begin
  end else begin
    REG_lo_3 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_69x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_3))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_4 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==4);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_4 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_4) == 1'b1) begin
    REG_lo_4 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_4) == 1'b0) begin
  end else begin
    REG_lo_4 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_70x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_4))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_5 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==5);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_5 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_5) == 1'b1) begin
    REG_lo_5 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_5) == 1'b0) begin
  end else begin
    REG_lo_5 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_71x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_5))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_6 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==6);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_6 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_6) == 1'b1) begin
    REG_lo_6 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_6) == 1'b0) begin
  end else begin
    REG_lo_6 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_72x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_6))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_7 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==7);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_7 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_7) == 1'b1) begin
    REG_lo_7 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_7) == 1'b0) begin
  end else begin
    REG_lo_7 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_73x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_7))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_8 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==8);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_8 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_8) == 1'b1) begin
    REG_lo_8 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_8) == 1'b0) begin
  end else begin
    REG_lo_8 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_74x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_8))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_9 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==9);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_9 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_9) == 1'b1) begin
    REG_lo_9 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_9) == 1'b0) begin
  end else begin
    REG_lo_9 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_75x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_9))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_10 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==10);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_10 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_10) == 1'b1) begin
    REG_lo_10 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_10) == 1'b0) begin
  end else begin
    REG_lo_10 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_76x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_10))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_11 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==11);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_11 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_11) == 1'b1) begin
    REG_lo_11 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_11) == 1'b0) begin
  end else begin
    REG_lo_11 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_77x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_11))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_12 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==12);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_12 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_12) == 1'b1) begin
    REG_lo_12 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_12) == 1'b0) begin
  end else begin
    REG_lo_12 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_78x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_12))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_13 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==13);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_13 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_13) == 1'b1) begin
    REG_lo_13 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_13) == 1'b0) begin
  end else begin
    REG_lo_13 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_79x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_13))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_14 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==14);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_14 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_14) == 1'b1) begin
    REG_lo_14 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_14) == 1'b0) begin
  end else begin
    REG_lo_14 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_80x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_14))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_15 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==15);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_15 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_15) == 1'b1) begin
    REG_lo_15 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_15) == 1'b0) begin
  end else begin
    REG_lo_15 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_81x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_15))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_16 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==16);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_16 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_16) == 1'b1) begin
    REG_lo_16 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_16) == 1'b0) begin
  end else begin
    REG_lo_16 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_82x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_16))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_17 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==17);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_17 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_17) == 1'b1) begin
    REG_lo_17 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_17) == 1'b0) begin
  end else begin
    REG_lo_17 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_83x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_17))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_18 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==18);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_18 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_18) == 1'b1) begin
    REG_lo_18 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_18) == 1'b0) begin
  end else begin
    REG_lo_18 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_84x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_18))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_19 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==19);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_19 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_19) == 1'b1) begin
    REG_lo_19 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_19) == 1'b0) begin
  end else begin
    REG_lo_19 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_85x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_19))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_20 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==20);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_20 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_20) == 1'b1) begin
    REG_lo_20 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_20) == 1'b0) begin
  end else begin
    REG_lo_20 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_86x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_20))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_21 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==21);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_21 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_21) == 1'b1) begin
    REG_lo_21 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_21) == 1'b0) begin
  end else begin
    REG_lo_21 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_87x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_21))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_22 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==22);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_22 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_22) == 1'b1) begin
    REG_lo_22 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_22) == 1'b0) begin
  end else begin
    REG_lo_22 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_88x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_22))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_23 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==23);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_23 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_23) == 1'b1) begin
    REG_lo_23 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_23) == 1'b0) begin
  end else begin
    REG_lo_23 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_89x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_23))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_24 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==24);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_24 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_24) == 1'b1) begin
    REG_lo_24 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_24) == 1'b0) begin
  end else begin
    REG_lo_24 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_90x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_24))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_25 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==25);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_25 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_25) == 1'b1) begin
    REG_lo_25 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_25) == 1'b0) begin
  end else begin
    REG_lo_25 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_91x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_25))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_26 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==26);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_26 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_26) == 1'b1) begin
    REG_lo_26 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_26) == 1'b0) begin
  end else begin
    REG_lo_26 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_92x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_26))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_27 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==27);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_27 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_27) == 1'b1) begin
    REG_lo_27 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_27) == 1'b0) begin
  end else begin
    REG_lo_27 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_93x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_27))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_28 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==28);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_28 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_28) == 1'b1) begin
    REG_lo_28 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_28) == 1'b0) begin
  end else begin
    REG_lo_28 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_94x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_28))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_29 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==29);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_29 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_29) == 1'b1) begin
    REG_lo_29 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_29) == 1'b0) begin
  end else begin
    REG_lo_29 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_95x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_29))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_30 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==30);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_30 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_30) == 1'b1) begin
    REG_lo_30 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_30) == 1'b0) begin
  end else begin
    REG_lo_30 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_96x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_30))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_31 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==31);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_31 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_31) == 1'b1) begin
    REG_lo_31 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_31) == 1'b0) begin
  end else begin
    REG_lo_31 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_97x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_31))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_32 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==32);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_32 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_32) == 1'b1) begin
    REG_lo_32 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_32) == 1'b0) begin
  end else begin
    REG_lo_32 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_98x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_32))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_33 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==33);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_33 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_33) == 1'b1) begin
    REG_lo_33 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_33) == 1'b0) begin
  end else begin
    REG_lo_33 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_99x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_33))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_34 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==34);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_34 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_34) == 1'b1) begin
    REG_lo_34 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_34) == 1'b0) begin
  end else begin
    REG_lo_34 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_100x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_34))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_35 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==35);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_35 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_35) == 1'b1) begin
    REG_lo_35 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_35) == 1'b0) begin
  end else begin
    REG_lo_35 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_101x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_35))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_36 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==36);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_36 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_36) == 1'b1) begin
    REG_lo_36 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_36) == 1'b0) begin
  end else begin
    REG_lo_36 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_102x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_36))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_37 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==37);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_37 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_37) == 1'b1) begin
    REG_lo_37 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_37) == 1'b0) begin
  end else begin
    REG_lo_37 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_103x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_37))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_38 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==38);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_38 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_38) == 1'b1) begin
    REG_lo_38 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_38) == 1'b0) begin
  end else begin
    REG_lo_38 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_104x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_38))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_39 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==39);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_39 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_39) == 1'b1) begin
    REG_lo_39 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_39) == 1'b0) begin
  end else begin
    REG_lo_39 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_105x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_39))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_40 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==40);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_40 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_40) == 1'b1) begin
    REG_lo_40 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_40) == 1'b0) begin
  end else begin
    REG_lo_40 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_106x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_40))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_41 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==41);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_41 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_41) == 1'b1) begin
    REG_lo_41 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_41) == 1'b0) begin
  end else begin
    REG_lo_41 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_107x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_41))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_42 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==42);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_42 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_42) == 1'b1) begin
    REG_lo_42 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_42) == 1'b0) begin
  end else begin
    REG_lo_42 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_108x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_42))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_43 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==43);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_43 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_43) == 1'b1) begin
    REG_lo_43 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_43) == 1'b0) begin
  end else begin
    REG_lo_43 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_109x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_43))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_44 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==44);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_44 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_44) == 1'b1) begin
    REG_lo_44 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_44) == 1'b0) begin
  end else begin
    REG_lo_44 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_110x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_44))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_45 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==45);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_45 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_45) == 1'b1) begin
    REG_lo_45 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_45) == 1'b0) begin
  end else begin
    REG_lo_45 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_111x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_45))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_46 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==46);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_46 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_46) == 1'b1) begin
    REG_lo_46 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_46) == 1'b0) begin
  end else begin
    REG_lo_46 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_112x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_46))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_47 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==47);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_47 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_47) == 1'b1) begin
    REG_lo_47 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_47) == 1'b0) begin
  end else begin
    REG_lo_47 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_113x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_47))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_48 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==48);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_48 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_48) == 1'b1) begin
    REG_lo_48 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_48) == 1'b0) begin
  end else begin
    REG_lo_48 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_114x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_48))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_49 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==49);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_49 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_49) == 1'b1) begin
    REG_lo_49 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_49) == 1'b0) begin
  end else begin
    REG_lo_49 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_115x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_49))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_50 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==50);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_50 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_50) == 1'b1) begin
    REG_lo_50 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_50) == 1'b0) begin
  end else begin
    REG_lo_50 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_116x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_50))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_51 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==51);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_51 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_51) == 1'b1) begin
    REG_lo_51 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_51) == 1'b0) begin
  end else begin
    REG_lo_51 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_117x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_51))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_52 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==52);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_52 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_52) == 1'b1) begin
    REG_lo_52 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_52) == 1'b0) begin
  end else begin
    REG_lo_52 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_118x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_52))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_53 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==53);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_53 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_53) == 1'b1) begin
    REG_lo_53 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_53) == 1'b0) begin
  end else begin
    REG_lo_53 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_119x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_53))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_54 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==54);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_54 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_54) == 1'b1) begin
    REG_lo_54 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_54) == 1'b0) begin
  end else begin
    REG_lo_54 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_120x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_54))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_55 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==55);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_55 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_55) == 1'b1) begin
    REG_lo_55 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_55) == 1'b0) begin
  end else begin
    REG_lo_55 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_121x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_55))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_56 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==56);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_56 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_56) == 1'b1) begin
    REG_lo_56 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_56) == 1'b0) begin
  end else begin
    REG_lo_56 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_122x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_56))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_57 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==57);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_57 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_57) == 1'b1) begin
    REG_lo_57 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_57) == 1'b0) begin
  end else begin
    REG_lo_57 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_123x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_57))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_58 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==58);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_58 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_58) == 1'b1) begin
    REG_lo_58 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_58) == 1'b0) begin
  end else begin
    REG_lo_58 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_124x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_58))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_59 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==59);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_59 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_59) == 1'b1) begin
    REG_lo_59 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_59) == 1'b0) begin
  end else begin
    REG_lo_59 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_125x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_59))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_60 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==60);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_60 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_60) == 1'b1) begin
    REG_lo_60 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_60) == 1'b0) begin
  end else begin
    REG_lo_60 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_126x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_60))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_61 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==61);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_61 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_61) == 1'b1) begin
    REG_lo_61 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_61) == 1'b0) begin
  end else begin
    REG_lo_61 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_127x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_61))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_62 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==62);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_62 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_62) == 1'b1) begin
    REG_lo_62 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_62) == 1'b0) begin
  end else begin
    REG_lo_62 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_128x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_62))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_63 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==63);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_63 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_63) == 1'b1) begin
    REG_lo_63 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_63) == 1'b0) begin
  end else begin
    REG_lo_63 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_129x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_63))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_64 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==64);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_64 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_64) == 1'b1) begin
    REG_lo_64 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_64) == 1'b0) begin
  end else begin
    REG_lo_64 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_130x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_64))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_65 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==65);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_65 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_65) == 1'b1) begin
    REG_lo_65 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_65) == 1'b0) begin
  end else begin
    REG_lo_65 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_131x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_65))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_66 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==66);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_66 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_66) == 1'b1) begin
    REG_lo_66 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_66) == 1'b0) begin
  end else begin
    REG_lo_66 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_132x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_66))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_67 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==67);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_67 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_67) == 1'b1) begin
    REG_lo_67 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_67) == 1'b0) begin
  end else begin
    REG_lo_67 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_133x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_67))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_68 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==68);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_68 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_68) == 1'b1) begin
    REG_lo_68 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_68) == 1'b0) begin
  end else begin
    REG_lo_68 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_134x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_68))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_69 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==69);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_69 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_69) == 1'b1) begin
    REG_lo_69 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_69) == 1'b0) begin
  end else begin
    REG_lo_69 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_135x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_69))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_70 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==70);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_70 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_70) == 1'b1) begin
    REG_lo_70 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_70) == 1'b0) begin
  end else begin
    REG_lo_70 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_136x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_70))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_71 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==71);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_71 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_71) == 1'b1) begin
    REG_lo_71 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_71) == 1'b0) begin
  end else begin
    REG_lo_71 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_137x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_71))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_72 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==72);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_72 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_72) == 1'b1) begin
    REG_lo_72 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_72) == 1'b0) begin
  end else begin
    REG_lo_72 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_138x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_72))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_73 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==73);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_73 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_73) == 1'b1) begin
    REG_lo_73 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_73) == 1'b0) begin
  end else begin
    REG_lo_73 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_139x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_73))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_74 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==74);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_74 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_74) == 1'b1) begin
    REG_lo_74 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_74) == 1'b0) begin
  end else begin
    REG_lo_74 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_140x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_74))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_75 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==75);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_75 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_75) == 1'b1) begin
    REG_lo_75 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_75) == 1'b0) begin
  end else begin
    REG_lo_75 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_141x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_75))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_76 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==76);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_76 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_76) == 1'b1) begin
    REG_lo_76 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_76) == 1'b0) begin
  end else begin
    REG_lo_76 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_142x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_76))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_77 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==77);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_77 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_77) == 1'b1) begin
    REG_lo_77 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_77) == 1'b0) begin
  end else begin
    REG_lo_77 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_143x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_77))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_78 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==78);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_78 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_78) == 1'b1) begin
    REG_lo_78 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_78) == 1'b0) begin
  end else begin
    REG_lo_78 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_144x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_78))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_79 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==79);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_79 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_79) == 1'b1) begin
    REG_lo_79 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_79) == 1'b0) begin
  end else begin
    REG_lo_79 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_145x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_79))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_80 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==80);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_80 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_80) == 1'b1) begin
    REG_lo_80 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_80) == 1'b0) begin
  end else begin
    REG_lo_80 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_146x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_80))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_81 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==81);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_81 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_81) == 1'b1) begin
    REG_lo_81 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_81) == 1'b0) begin
  end else begin
    REG_lo_81 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_147x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_81))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_82 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==82);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_82 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_82) == 1'b1) begin
    REG_lo_82 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_82) == 1'b0) begin
  end else begin
    REG_lo_82 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_148x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_82))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_83 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==83);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_83 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_83) == 1'b1) begin
    REG_lo_83 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_83) == 1'b0) begin
  end else begin
    REG_lo_83 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_149x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_83))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_84 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==84);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_84 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_84) == 1'b1) begin
    REG_lo_84 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_84) == 1'b0) begin
  end else begin
    REG_lo_84 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_150x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_84))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_85 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==85);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_85 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_85) == 1'b1) begin
    REG_lo_85 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_85) == 1'b0) begin
  end else begin
    REG_lo_85 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_151x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_85))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_86 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==86);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_86 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_86) == 1'b1) begin
    REG_lo_86 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_86) == 1'b0) begin
  end else begin
    REG_lo_86 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_152x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_86))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_87 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==87);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_87 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_87) == 1'b1) begin
    REG_lo_87 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_87) == 1'b0) begin
  end else begin
    REG_lo_87 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_153x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_87))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_88 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==88);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_88 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_88) == 1'b1) begin
    REG_lo_88 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_88) == 1'b0) begin
  end else begin
    REG_lo_88 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_154x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_88))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_89 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==89);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_89 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_89) == 1'b1) begin
    REG_lo_89 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_89) == 1'b0) begin
  end else begin
    REG_lo_89 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_155x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_89))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_90 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==90);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_90 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_90) == 1'b1) begin
    REG_lo_90 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_90) == 1'b0) begin
  end else begin
    REG_lo_90 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_156x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_90))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_91 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==91);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_91 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_91) == 1'b1) begin
    REG_lo_91 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_91) == 1'b0) begin
  end else begin
    REG_lo_91 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_157x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_91))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_92 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==92);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_92 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_92) == 1'b1) begin
    REG_lo_92 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_92) == 1'b0) begin
  end else begin
    REG_lo_92 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_158x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_92))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_93 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==93);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_93 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_93) == 1'b1) begin
    REG_lo_93 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_93) == 1'b0) begin
  end else begin
    REG_lo_93 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_159x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_93))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_94 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==94);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_94 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_94) == 1'b1) begin
    REG_lo_94 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_94) == 1'b0) begin
  end else begin
    REG_lo_94 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_160x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_94))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_95 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==95);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_95 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_95) == 1'b1) begin
    REG_lo_95 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_95) == 1'b0) begin
  end else begin
    REG_lo_95 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_161x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_95))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_96 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==96);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_96 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_96) == 1'b1) begin
    REG_lo_96 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_96) == 1'b0) begin
  end else begin
    REG_lo_96 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_162x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_96))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_97 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==97);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_97 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_97) == 1'b1) begin
    REG_lo_97 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_97) == 1'b0) begin
  end else begin
    REG_lo_97 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_163x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_97))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_98 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==98);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_98 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_98) == 1'b1) begin
    REG_lo_98 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_98) == 1'b0) begin
  end else begin
    REG_lo_98 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_164x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_98))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_99 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==99);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_99 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_99) == 1'b1) begin
    REG_lo_99 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_99) == 1'b0) begin
  end else begin
    REG_lo_99 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_165x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_99))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_100 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==100);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_100 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_100) == 1'b1) begin
    REG_lo_100 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_100) == 1'b0) begin
  end else begin
    REG_lo_100 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_166x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_100))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_101 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==101);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_101 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_101) == 1'b1) begin
    REG_lo_101 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_101) == 1'b0) begin
  end else begin
    REG_lo_101 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_167x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_101))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_102 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==102);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_102 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_102) == 1'b1) begin
    REG_lo_102 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_102) == 1'b0) begin
  end else begin
    REG_lo_102 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_168x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_102))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_103 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==103);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_103 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_103) == 1'b1) begin
    REG_lo_103 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_103) == 1'b0) begin
  end else begin
    REG_lo_103 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_169x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_103))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_104 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==104);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_104 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_104) == 1'b1) begin
    REG_lo_104 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_104) == 1'b0) begin
  end else begin
    REG_lo_104 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_170x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_104))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_105 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==105);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_105 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_105) == 1'b1) begin
    REG_lo_105 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_105) == 1'b0) begin
  end else begin
    REG_lo_105 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_171x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_105))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_106 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==106);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_106 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_106) == 1'b1) begin
    REG_lo_106 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_106) == 1'b0) begin
  end else begin
    REG_lo_106 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_172x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_106))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_107 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==107);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_107 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_107) == 1'b1) begin
    REG_lo_107 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_107) == 1'b0) begin
  end else begin
    REG_lo_107 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_173x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_107))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_108 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==108);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_108 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_108) == 1'b1) begin
    REG_lo_108 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_108) == 1'b0) begin
  end else begin
    REG_lo_108 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_174x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_108))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_109 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==109);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_109 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_109) == 1'b1) begin
    REG_lo_109 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_109) == 1'b0) begin
  end else begin
    REG_lo_109 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_175x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_109))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_110 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==110);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_110 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_110) == 1'b1) begin
    REG_lo_110 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_110) == 1'b0) begin
  end else begin
    REG_lo_110 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_176x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_110))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_111 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==111);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_111 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_111) == 1'b1) begin
    REG_lo_111 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_111) == 1'b0) begin
  end else begin
    REG_lo_111 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_177x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_111))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_112 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==112);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_112 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_112) == 1'b1) begin
    REG_lo_112 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_112) == 1'b0) begin
  end else begin
    REG_lo_112 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_178x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_112))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_113 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==113);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_113 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_113) == 1'b1) begin
    REG_lo_113 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_113) == 1'b0) begin
  end else begin
    REG_lo_113 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_179x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_113))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_114 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==114);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_114 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_114) == 1'b1) begin
    REG_lo_114 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_114) == 1'b0) begin
  end else begin
    REG_lo_114 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_180x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_114))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_115 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==115);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_115 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_115) == 1'b1) begin
    REG_lo_115 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_115) == 1'b0) begin
  end else begin
    REG_lo_115 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_181x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_115))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_116 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==116);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_116 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_116) == 1'b1) begin
    REG_lo_116 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_116) == 1'b0) begin
  end else begin
    REG_lo_116 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_182x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_116))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_117 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==117);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_117 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_117) == 1'b1) begin
    REG_lo_117 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_117) == 1'b0) begin
  end else begin
    REG_lo_117 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_183x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_117))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_118 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==118);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_118 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_118) == 1'b1) begin
    REG_lo_118 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_118) == 1'b0) begin
  end else begin
    REG_lo_118 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_184x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_118))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_119 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==119);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_119 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_119) == 1'b1) begin
    REG_lo_119 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_119) == 1'b0) begin
  end else begin
    REG_lo_119 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_185x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_119))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_120 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==120);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_120 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_120) == 1'b1) begin
    REG_lo_120 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_120) == 1'b0) begin
  end else begin
    REG_lo_120 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_186x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_120))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_121 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==121);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_121 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_121) == 1'b1) begin
    REG_lo_121 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_121) == 1'b0) begin
  end else begin
    REG_lo_121 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_187x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_121))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_122 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==122);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_122 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_122) == 1'b1) begin
    REG_lo_122 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_122) == 1'b0) begin
  end else begin
    REG_lo_122 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_188x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_122))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_123 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==123);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_123 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_123) == 1'b1) begin
    REG_lo_123 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_123) == 1'b0) begin
  end else begin
    REG_lo_123 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_189x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_123))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_124 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==124);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_124 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_124) == 1'b1) begin
    REG_lo_124 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_124) == 1'b0) begin
  end else begin
    REG_lo_124 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_190x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_124))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_125 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==125);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_125 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_125) == 1'b1) begin
    REG_lo_125 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_125) == 1'b0) begin
  end else begin
    REG_lo_125 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_191x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_125))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_126 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==126);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_126 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_126) == 1'b1) begin
    REG_lo_126 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_126) == 1'b0) begin
  end else begin
    REG_lo_126 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_192x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_126))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_127 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==127);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_127 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_127) == 1'b1) begin
    REG_lo_127 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_127) == 1'b0) begin
  end else begin
    REG_lo_127 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_193x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_127))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_128 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==128);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_128 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_128) == 1'b1) begin
    REG_lo_128 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_128) == 1'b0) begin
  end else begin
    REG_lo_128 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_194x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_128))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_129 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==129);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_129 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_129) == 1'b1) begin
    REG_lo_129 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_129) == 1'b0) begin
  end else begin
    REG_lo_129 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_195x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_129))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_130 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==130);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_130 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_130) == 1'b1) begin
    REG_lo_130 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_130) == 1'b0) begin
  end else begin
    REG_lo_130 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_196x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_130))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_131 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==131);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_131 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_131) == 1'b1) begin
    REG_lo_131 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_131) == 1'b0) begin
  end else begin
    REG_lo_131 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_197x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_131))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_132 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==132);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_132 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_132) == 1'b1) begin
    REG_lo_132 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_132) == 1'b0) begin
  end else begin
    REG_lo_132 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_198x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_132))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_133 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==133);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_133 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_133) == 1'b1) begin
    REG_lo_133 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_133) == 1'b0) begin
  end else begin
    REG_lo_133 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_199x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_133))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_134 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==134);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_134 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_134) == 1'b1) begin
    REG_lo_134 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_134) == 1'b0) begin
  end else begin
    REG_lo_134 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_200x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_134))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_135 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==135);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_135 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_135) == 1'b1) begin
    REG_lo_135 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_135) == 1'b0) begin
  end else begin
    REG_lo_135 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_201x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_135))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_136 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==136);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_136 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_136) == 1'b1) begin
    REG_lo_136 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_136) == 1'b0) begin
  end else begin
    REG_lo_136 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_202x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_136))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_137 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==137);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_137 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_137) == 1'b1) begin
    REG_lo_137 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_137) == 1'b0) begin
  end else begin
    REG_lo_137 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_203x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_137))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_138 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==138);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_138 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_138) == 1'b1) begin
    REG_lo_138 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_138) == 1'b0) begin
  end else begin
    REG_lo_138 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_204x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_138))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_139 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==139);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_139 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_139) == 1'b1) begin
    REG_lo_139 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_139) == 1'b0) begin
  end else begin
    REG_lo_139 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_205x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_139))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_140 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==140);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_140 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_140) == 1'b1) begin
    REG_lo_140 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_140) == 1'b0) begin
  end else begin
    REG_lo_140 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_206x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_140))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_141 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==141);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_141 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_141) == 1'b1) begin
    REG_lo_141 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_141) == 1'b0) begin
  end else begin
    REG_lo_141 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_207x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_141))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_142 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==142);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_142 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_142) == 1'b1) begin
    REG_lo_142 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_142) == 1'b0) begin
  end else begin
    REG_lo_142 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_208x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_142))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_143 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==143);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_143 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_143) == 1'b1) begin
    REG_lo_143 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_143) == 1'b0) begin
  end else begin
    REG_lo_143 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_209x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_143))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_144 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==144);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_144 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_144) == 1'b1) begin
    REG_lo_144 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_144) == 1'b0) begin
  end else begin
    REG_lo_144 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_210x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_144))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_145 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==145);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_145 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_145) == 1'b1) begin
    REG_lo_145 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_145) == 1'b0) begin
  end else begin
    REG_lo_145 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_211x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_145))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_146 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==146);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_146 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_146) == 1'b1) begin
    REG_lo_146 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_146) == 1'b0) begin
  end else begin
    REG_lo_146 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_212x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_146))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_147 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==147);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_147 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_147) == 1'b1) begin
    REG_lo_147 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_147) == 1'b0) begin
  end else begin
    REG_lo_147 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_213x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_147))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_148 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==148);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_148 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_148) == 1'b1) begin
    REG_lo_148 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_148) == 1'b0) begin
  end else begin
    REG_lo_148 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_214x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_148))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_149 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==149);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_149 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_149) == 1'b1) begin
    REG_lo_149 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_149) == 1'b0) begin
  end else begin
    REG_lo_149 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_215x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_149))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_150 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==150);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_150 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_150) == 1'b1) begin
    REG_lo_150 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_150) == 1'b0) begin
  end else begin
    REG_lo_150 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_216x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_150))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_151 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==151);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_151 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_151) == 1'b1) begin
    REG_lo_151 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_151) == 1'b0) begin
  end else begin
    REG_lo_151 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_217x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_151))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_152 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==152);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_152 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_152) == 1'b1) begin
    REG_lo_152 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_152) == 1'b0) begin
  end else begin
    REG_lo_152 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_218x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_152))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_153 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==153);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_153 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_153) == 1'b1) begin
    REG_lo_153 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_153) == 1'b0) begin
  end else begin
    REG_lo_153 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_219x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_153))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_154 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==154);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_154 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_154) == 1'b1) begin
    REG_lo_154 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_154) == 1'b0) begin
  end else begin
    REG_lo_154 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_220x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_154))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_155 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==155);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_155 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_155) == 1'b1) begin
    REG_lo_155 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_155) == 1'b0) begin
  end else begin
    REG_lo_155 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_221x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_155))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_156 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==156);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_156 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_156) == 1'b1) begin
    REG_lo_156 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_156) == 1'b0) begin
  end else begin
    REG_lo_156 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_222x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_156))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_157 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==157);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_157 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_157) == 1'b1) begin
    REG_lo_157 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_157) == 1'b0) begin
  end else begin
    REG_lo_157 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_223x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_157))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_158 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==158);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_158 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_158) == 1'b1) begin
    REG_lo_158 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_158) == 1'b0) begin
  end else begin
    REG_lo_158 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_224x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_158))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_159 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==159);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_159 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_159) == 1'b1) begin
    REG_lo_159 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_159) == 1'b0) begin
  end else begin
    REG_lo_159 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_225x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_159))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_160 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==160);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_160 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_160) == 1'b1) begin
    REG_lo_160 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_160) == 1'b0) begin
  end else begin
    REG_lo_160 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_226x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_160))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_161 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==161);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_161 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_161) == 1'b1) begin
    REG_lo_161 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_161) == 1'b0) begin
  end else begin
    REG_lo_161 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_227x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_161))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_162 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==162);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_162 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_162) == 1'b1) begin
    REG_lo_162 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_162) == 1'b0) begin
  end else begin
    REG_lo_162 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_228x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_162))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_163 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==163);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_163 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_163) == 1'b1) begin
    REG_lo_163 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_163) == 1'b0) begin
  end else begin
    REG_lo_163 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_229x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_163))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_164 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==164);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_164 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_164) == 1'b1) begin
    REG_lo_164 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_164) == 1'b0) begin
  end else begin
    REG_lo_164 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_230x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_164))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_165 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==165);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_165 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_165) == 1'b1) begin
    REG_lo_165 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_165) == 1'b0) begin
  end else begin
    REG_lo_165 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_231x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_165))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_166 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==166);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_166 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_166) == 1'b1) begin
    REG_lo_166 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_166) == 1'b0) begin
  end else begin
    REG_lo_166 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_232x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_166))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_167 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==167);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_167 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_167) == 1'b1) begin
    REG_lo_167 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_167) == 1'b0) begin
  end else begin
    REG_lo_167 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_233x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_167))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_168 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==168);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_168 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_168) == 1'b1) begin
    REG_lo_168 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_168) == 1'b0) begin
  end else begin
    REG_lo_168 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_234x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_168))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_169 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==169);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_169 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_169) == 1'b1) begin
    REG_lo_169 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_169) == 1'b0) begin
  end else begin
    REG_lo_169 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_235x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_169))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_170 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==170);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_170 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_170) == 1'b1) begin
    REG_lo_170 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_170) == 1'b0) begin
  end else begin
    REG_lo_170 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_236x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_170))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_171 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==171);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_171 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_171) == 1'b1) begin
    REG_lo_171 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_171) == 1'b0) begin
  end else begin
    REG_lo_171 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_237x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_171))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_172 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==172);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_172 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_172) == 1'b1) begin
    REG_lo_172 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_172) == 1'b0) begin
  end else begin
    REG_lo_172 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_238x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_172))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_173 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==173);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_173 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_173) == 1'b1) begin
    REG_lo_173 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_173) == 1'b0) begin
  end else begin
    REG_lo_173 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_239x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_173))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_174 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==174);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_174 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_174) == 1'b1) begin
    REG_lo_174 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_174) == 1'b0) begin
  end else begin
    REG_lo_174 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_240x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_174))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_175 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==175);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_175 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_175) == 1'b1) begin
    REG_lo_175 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_175) == 1'b0) begin
  end else begin
    REG_lo_175 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_241x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_175))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_176 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==176);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_176 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_176) == 1'b1) begin
    REG_lo_176 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_176) == 1'b0) begin
  end else begin
    REG_lo_176 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_242x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_176))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_177 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==177);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_177 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_177) == 1'b1) begin
    REG_lo_177 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_177) == 1'b0) begin
  end else begin
    REG_lo_177 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_243x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_177))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_178 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==178);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_178 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_178) == 1'b1) begin
    REG_lo_178 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_178) == 1'b0) begin
  end else begin
    REG_lo_178 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_244x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_178))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_179 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==179);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_179 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_179) == 1'b1) begin
    REG_lo_179 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_179) == 1'b0) begin
  end else begin
    REG_lo_179 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_245x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_179))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_180 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==180);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_180 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_180) == 1'b1) begin
    REG_lo_180 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_180) == 1'b0) begin
  end else begin
    REG_lo_180 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_246x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_180))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_181 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==181);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_181 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_181) == 1'b1) begin
    REG_lo_181 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_181) == 1'b0) begin
  end else begin
    REG_lo_181 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_247x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_181))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_182 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==182);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_182 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_182) == 1'b1) begin
    REG_lo_182 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_182) == 1'b0) begin
  end else begin
    REG_lo_182 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_248x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_182))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_183 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==183);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_183 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_183) == 1'b1) begin
    REG_lo_183 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_183) == 1'b0) begin
  end else begin
    REG_lo_183 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_249x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_183))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_184 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==184);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_184 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_184) == 1'b1) begin
    REG_lo_184 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_184) == 1'b0) begin
  end else begin
    REG_lo_184 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_250x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_184))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_185 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==185);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_185 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_185) == 1'b1) begin
    REG_lo_185 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_185) == 1'b0) begin
  end else begin
    REG_lo_185 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_251x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_185))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_186 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==186);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_186 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_186) == 1'b1) begin
    REG_lo_186 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_186) == 1'b0) begin
  end else begin
    REG_lo_186 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_252x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_186))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_187 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==187);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_187 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_187) == 1'b1) begin
    REG_lo_187 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_187) == 1'b0) begin
  end else begin
    REG_lo_187 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_253x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_187))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_188 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==188);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_188 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_188) == 1'b1) begin
    REG_lo_188 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_188) == 1'b0) begin
  end else begin
    REG_lo_188 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_254x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_188))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_189 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==189);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_189 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_189) == 1'b1) begin
    REG_lo_189 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_189) == 1'b0) begin
  end else begin
    REG_lo_189 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_255x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_189))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_190 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==190);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_190 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_190) == 1'b1) begin
    REG_lo_190 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_190) == 1'b0) begin
  end else begin
    REG_lo_190 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_256x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_190))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_191 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==191);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_191 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_191) == 1'b1) begin
    REG_lo_191 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_191) == 1'b0) begin
  end else begin
    REG_lo_191 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_257x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_191))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_192 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==192);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_192 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_192) == 1'b1) begin
    REG_lo_192 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_192) == 1'b0) begin
  end else begin
    REG_lo_192 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_258x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_192))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_193 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==193);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_193 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_193) == 1'b1) begin
    REG_lo_193 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_193) == 1'b0) begin
  end else begin
    REG_lo_193 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_259x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_193))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_194 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==194);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_194 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_194) == 1'b1) begin
    REG_lo_194 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_194) == 1'b0) begin
  end else begin
    REG_lo_194 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_260x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_194))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_195 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==195);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_195 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_195) == 1'b1) begin
    REG_lo_195 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_195) == 1'b0) begin
  end else begin
    REG_lo_195 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_261x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_195))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_196 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==196);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_196 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_196) == 1'b1) begin
    REG_lo_196 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_196) == 1'b0) begin
  end else begin
    REG_lo_196 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_262x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_196))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_197 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==197);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_197 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_197) == 1'b1) begin
    REG_lo_197 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_197) == 1'b0) begin
  end else begin
    REG_lo_197 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_263x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_197))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_198 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==198);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_198 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_198) == 1'b1) begin
    REG_lo_198 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_198) == 1'b0) begin
  end else begin
    REG_lo_198 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_264x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_198))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_199 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==199);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_199 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_199) == 1'b1) begin
    REG_lo_199 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_199) == 1'b0) begin
  end else begin
    REG_lo_199 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_265x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_199))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_200 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==200);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_200 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_200) == 1'b1) begin
    REG_lo_200 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_200) == 1'b0) begin
  end else begin
    REG_lo_200 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_266x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_200))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_201 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==201);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_201 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_201) == 1'b1) begin
    REG_lo_201 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_201) == 1'b0) begin
  end else begin
    REG_lo_201 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_267x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_201))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_202 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==202);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_202 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_202) == 1'b1) begin
    REG_lo_202 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_202) == 1'b0) begin
  end else begin
    REG_lo_202 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_268x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_202))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_203 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==203);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_203 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_203) == 1'b1) begin
    REG_lo_203 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_203) == 1'b0) begin
  end else begin
    REG_lo_203 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_269x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_203))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_204 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==204);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_204 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_204) == 1'b1) begin
    REG_lo_204 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_204) == 1'b0) begin
  end else begin
    REG_lo_204 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_270x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_204))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_205 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==205);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_205 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_205) == 1'b1) begin
    REG_lo_205 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_205) == 1'b0) begin
  end else begin
    REG_lo_205 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_271x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_205))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_206 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==206);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_206 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_206) == 1'b1) begin
    REG_lo_206 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_206) == 1'b0) begin
  end else begin
    REG_lo_206 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_272x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_206))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_207 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==207);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_207 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_207) == 1'b1) begin
    REG_lo_207 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_207) == 1'b0) begin
  end else begin
    REG_lo_207 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_273x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_207))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_208 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==208);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_208 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_208) == 1'b1) begin
    REG_lo_208 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_208) == 1'b0) begin
  end else begin
    REG_lo_208 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_274x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_208))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_209 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==209);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_209 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_209) == 1'b1) begin
    REG_lo_209 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_209) == 1'b0) begin
  end else begin
    REG_lo_209 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_275x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_209))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_210 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==210);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_210 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_210) == 1'b1) begin
    REG_lo_210 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_210) == 1'b0) begin
  end else begin
    REG_lo_210 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_276x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_210))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_211 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==211);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_211 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_211) == 1'b1) begin
    REG_lo_211 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_211) == 1'b0) begin
  end else begin
    REG_lo_211 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_277x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_211))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_212 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==212);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_212 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_212) == 1'b1) begin
    REG_lo_212 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_212) == 1'b0) begin
  end else begin
    REG_lo_212 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_278x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_212))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_213 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==213);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_213 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_213) == 1'b1) begin
    REG_lo_213 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_213) == 1'b0) begin
  end else begin
    REG_lo_213 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_279x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_213))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_214 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==214);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_214 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_214) == 1'b1) begin
    REG_lo_214 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_214) == 1'b0) begin
  end else begin
    REG_lo_214 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_280x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_214))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_215 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==215);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_215 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_215) == 1'b1) begin
    REG_lo_215 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_215) == 1'b0) begin
  end else begin
    REG_lo_215 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_281x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_215))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_216 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==216);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_216 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_216) == 1'b1) begin
    REG_lo_216 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_216) == 1'b0) begin
  end else begin
    REG_lo_216 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_282x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_216))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_217 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==217);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_217 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_217) == 1'b1) begin
    REG_lo_217 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_217) == 1'b0) begin
  end else begin
    REG_lo_217 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_283x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_217))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_218 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==218);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_218 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_218) == 1'b1) begin
    REG_lo_218 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_218) == 1'b0) begin
  end else begin
    REG_lo_218 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_284x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_218))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_219 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==219);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_219 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_219) == 1'b1) begin
    REG_lo_219 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_219) == 1'b0) begin
  end else begin
    REG_lo_219 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_285x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_219))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_220 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==220);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_220 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_220) == 1'b1) begin
    REG_lo_220 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_220) == 1'b0) begin
  end else begin
    REG_lo_220 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_286x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_220))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_221 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==221);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_221 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_221) == 1'b1) begin
    REG_lo_221 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_221) == 1'b0) begin
  end else begin
    REG_lo_221 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_287x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_221))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_222 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==222);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_222 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_222) == 1'b1) begin
    REG_lo_222 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_222) == 1'b0) begin
  end else begin
    REG_lo_222 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_288x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_222))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_223 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==223);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_223 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_223) == 1'b1) begin
    REG_lo_223 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_223) == 1'b0) begin
  end else begin
    REG_lo_223 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_289x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_223))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_224 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==224);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_224 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_224) == 1'b1) begin
    REG_lo_224 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_224) == 1'b0) begin
  end else begin
    REG_lo_224 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_290x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_224))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_225 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==225);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_225 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_225) == 1'b1) begin
    REG_lo_225 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_225) == 1'b0) begin
  end else begin
    REG_lo_225 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_291x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_225))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_226 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==226);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_226 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_226) == 1'b1) begin
    REG_lo_226 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_226) == 1'b0) begin
  end else begin
    REG_lo_226 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_292x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_226))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_227 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==227);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_227 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_227) == 1'b1) begin
    REG_lo_227 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_227) == 1'b0) begin
  end else begin
    REG_lo_227 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_293x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_227))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_228 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==228);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_228 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_228) == 1'b1) begin
    REG_lo_228 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_228) == 1'b0) begin
  end else begin
    REG_lo_228 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_294x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_228))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_229 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==229);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_229 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_229) == 1'b1) begin
    REG_lo_229 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_229) == 1'b0) begin
  end else begin
    REG_lo_229 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_295x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_229))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_230 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==230);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_230 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_230) == 1'b1) begin
    REG_lo_230 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_230) == 1'b0) begin
  end else begin
    REG_lo_230 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_296x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_230))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_231 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==231);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_231 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_231) == 1'b1) begin
    REG_lo_231 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_231) == 1'b0) begin
  end else begin
    REG_lo_231 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_297x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_231))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_232 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==232);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_232 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_232) == 1'b1) begin
    REG_lo_232 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_232) == 1'b0) begin
  end else begin
    REG_lo_232 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_298x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_232))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_233 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==233);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_233 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_233) == 1'b1) begin
    REG_lo_233 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_233) == 1'b0) begin
  end else begin
    REG_lo_233 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_299x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_233))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_234 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==234);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_234 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_234) == 1'b1) begin
    REG_lo_234 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_234) == 1'b0) begin
  end else begin
    REG_lo_234 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_300x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_234))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_235 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==235);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_235 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_235) == 1'b1) begin
    REG_lo_235 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_235) == 1'b0) begin
  end else begin
    REG_lo_235 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_301x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_235))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_236 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==236);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_236 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_236) == 1'b1) begin
    REG_lo_236 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_236) == 1'b0) begin
  end else begin
    REG_lo_236 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_302x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_236))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_237 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==237);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_237 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_237) == 1'b1) begin
    REG_lo_237 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_237) == 1'b0) begin
  end else begin
    REG_lo_237 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_303x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_237))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_238 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==238);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_238 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_238) == 1'b1) begin
    REG_lo_238 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_238) == 1'b0) begin
  end else begin
    REG_lo_238 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_304x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_238))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_239 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==239);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_239 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_239) == 1'b1) begin
    REG_lo_239 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_239) == 1'b0) begin
  end else begin
    REG_lo_239 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_305x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_239))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_240 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==240);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_240 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_240) == 1'b1) begin
    REG_lo_240 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_240) == 1'b0) begin
  end else begin
    REG_lo_240 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_306x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_240))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_241 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==241);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_241 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_241) == 1'b1) begin
    REG_lo_241 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_241) == 1'b0) begin
  end else begin
    REG_lo_241 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_307x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_241))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_242 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==242);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_242 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_242) == 1'b1) begin
    REG_lo_242 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_242) == 1'b0) begin
  end else begin
    REG_lo_242 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_308x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_242))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_243 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==243);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_243 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_243) == 1'b1) begin
    REG_lo_243 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_243) == 1'b0) begin
  end else begin
    REG_lo_243 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_309x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_243))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_244 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==244);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_244 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_244) == 1'b1) begin
    REG_lo_244 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_244) == 1'b0) begin
  end else begin
    REG_lo_244 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_310x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_244))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_245 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==245);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_245 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_245) == 1'b1) begin
    REG_lo_245 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_245) == 1'b0) begin
  end else begin
    REG_lo_245 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_311x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_245))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_246 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==246);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_246 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_246) == 1'b1) begin
    REG_lo_246 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_246) == 1'b0) begin
  end else begin
    REG_lo_246 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_312x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_246))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_247 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==247);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_247 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_247) == 1'b1) begin
    REG_lo_247 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_247) == 1'b0) begin
  end else begin
    REG_lo_247 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_313x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_247))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_248 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==248);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_248 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_248) == 1'b1) begin
    REG_lo_248 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_248) == 1'b0) begin
  end else begin
    REG_lo_248 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_314x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_248))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_249 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==249);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_249 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_249) == 1'b1) begin
    REG_lo_249 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_249) == 1'b0) begin
  end else begin
    REG_lo_249 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_315x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_249))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_250 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==250);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_250 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_250) == 1'b1) begin
    REG_lo_250 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_250) == 1'b0) begin
  end else begin
    REG_lo_250 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_316x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_250))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_251 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==251);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_251 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_251) == 1'b1) begin
    REG_lo_251 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_251) == 1'b0) begin
  end else begin
    REG_lo_251 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_317x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_251))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_252 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==252);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_252 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_252) == 1'b1) begin
    REG_lo_252 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_252) == 1'b0) begin
  end else begin
    REG_lo_252 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_318x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_252))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_253 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==253);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_253 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_253) == 1'b1) begin
    REG_lo_253 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_253) == 1'b0) begin
  end else begin
    REG_lo_253 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_319x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_253))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_254 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==254);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_254 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_254) == 1'b1) begin
    REG_lo_254 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_254) == 1'b0) begin
  end else begin
    REG_lo_254 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_320x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_254))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_255 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==255);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_255 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_255) == 1'b1) begin
    REG_lo_255 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_255) == 1'b0) begin
  end else begin
    REG_lo_255 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_321x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_255))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

assign lo_wr_en_256 = pro_in_wr_en & pro_in_select_lo & (pro_in_addr==256);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    REG_lo_256 <= {16{1'b0}};
  end else begin
  if ((lo_wr_en_256) == 1'b1) begin
    REG_lo_256 <= pro_in_data;
  // VCS coverage off
  end else if ((lo_wr_en_256) == 1'b0) begin
  end else begin
    REG_lo_256 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_322x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(lo_wr_en_256))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON


//viva_pipe -bc lut_in_pd(lut_in_pvld, lut_in_prdy) <= idx2lut_pd(idx2lut_pvld,idx2lut_prdy);
NV_NVDLA_SDP_CORE_Y_lut_pipe_p1  pipe_p1 (
   .nvdla_core_clk  (nvdla_core_clk)              
  ,.nvdla_core_rstn (nvdla_core_rstn)             
  ,.idx2lut_pvld    (idx2lut_pvld)               
  ,.idx2lut_prdy    (idx2lut_prdy)               
  ,.idx2lut_pd      (idx2lut_pd[EW_IDX_OUT_DW-1:0])         
  ,.lut_in_pvld     (lut_in_pvld)              
  ,.lut_in_prdy     (lut_in_prdy)              
  ,.lut_in_pd       (lut_in_pd[EW_IDX_OUT_DW-1:0])          
  );

// PKT_UNPACK_WIRE( sdp_y_lut_in ,  lut_in_ ,  lut_in_pd )
//: my $k=NVDLA_SDP_EW_THROUGHPUT;
//: my $bx =NVDLA_SDP_EW_THROUGHPUT*35;
//: my $bof=NVDLA_SDP_EW_THROUGHPUT*(35+32);
//: my $buf=NVDLA_SDP_EW_THROUGHPUT*(35+32+1);
//: my $bsl=NVDLA_SDP_EW_THROUGHPUT*(35+32+2);
//: my $ba =NVDLA_SDP_EW_THROUGHPUT*(35+32+3);
//: my $beh=NVDLA_SDP_EW_THROUGHPUT*(35+32+12);
//: my $boh=NVDLA_SDP_EW_THROUGHPUT*(35+32+13);
//: foreach my $i  (0..${k}-1) {
//: print "assign   lut_in_fraction${i}[34:0] =  lut_in_pd[35*${i}+34:35*${i}]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign   lut_in_x${i}[31:0]        =  lut_in_pd[32*${i}+31+${bx}:32*${i}+${bx}]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign   lut_in_oflow${i}          =  lut_in_pd[${i}+${bof}]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign   lut_in_uflow${i}          =  lut_in_pd[${i}+${buf}]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign   lut_in_sel${i}            =  lut_in_pd[${i}+${bsl}]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign   lut_in_addr${i}[8:0]      =  lut_in_pd[9*${i}+8+${ba}:9*${i}+${ba}]; \n"; 
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign   lut_in_le_hit${i}         =  lut_in_pd[${i}+${beh}]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign   lut_in_lo_hit${i}         =  lut_in_pd[${i}+${boh}]; \n";
//: }


//=======================================
// PERF STATISTIC
// OFLOW
//: my $k=NVDLA_SDP_EW_THROUGHPUT;
//: print "assign lut_oflow_sum[4:0] = lut_in_oflow0";
//: if(${k} >1) {
//: foreach my $i  (1..${k}-1) {
//: print "+ lut_in_oflow${i}";
//: }
//: }
//: print ";\n";

assign perf_lut_oflow_add = (&lut_oflow_cnt) ? 0 : lut_oflow_sum;
assign perf_lut_oflow_sub = 1'b0;
assign dp2reg_lut_oflow = lut_oflow_cnt;

always @(
  perf_lut_oflow_add
  or perf_lut_oflow_sub
  ) begin
  perf_lut_oflow_adv = perf_lut_oflow_add[4:0] != {{4{1'b0}}, perf_lut_oflow_sub[0:0]};
end
    
always @(
  perf_lut_oflow_cnt_cur
  or perf_lut_oflow_add
  or perf_lut_oflow_sub
  or perf_lut_oflow_adv
  or op_en_load
  ) begin
  perf_lut_oflow_cnt_ext[33:0] = {1'b0, 1'b0, perf_lut_oflow_cnt_cur};
  perf_lut_oflow_cnt_mod[33:0] = perf_lut_oflow_cnt_cur + perf_lut_oflow_add[4:0] - perf_lut_oflow_sub[0:0]; // spyglass disable W164b
  perf_lut_oflow_cnt_new[33:0] = (perf_lut_oflow_adv)? perf_lut_oflow_cnt_mod[33:0] : perf_lut_oflow_cnt_ext[33:0];
  perf_lut_oflow_cnt_nxt[33:0] = (op_en_load)? 34'd0 : perf_lut_oflow_cnt_new[33:0];
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    perf_lut_oflow_cnt_cur[31:0] <= 0;
  end else begin
  if (reg2dp_perf_lut_en) begin
  perf_lut_oflow_cnt_cur[31:0] <= perf_lut_oflow_cnt_nxt[31:0];
  end
  end
end

always @(
  perf_lut_oflow_cnt_cur
  ) begin
  lut_oflow_cnt[31:0] = perf_lut_oflow_cnt_cur[31:0];
end
    
  
// UFLOW
//: my $k=NVDLA_SDP_EW_THROUGHPUT;
//: print "assign lut_uflow_sum[4:0] = lut_in_uflow0";
//: if(${k} >1) {
//: foreach my $i  (1..${k}-1) {
//: print "+ lut_in_uflow${i}";
//: }
//: }
//: print ";\n";

assign perf_lut_uflow_add = (&lut_uflow_cnt) ? 0 : lut_uflow_sum;
assign perf_lut_uflow_sub = 1'b0;
assign dp2reg_lut_uflow = lut_uflow_cnt;

always @(
  perf_lut_uflow_add
  or perf_lut_uflow_sub
  ) begin
  perf_lut_uflow_adv = perf_lut_uflow_add[4:0] != {{4{1'b0}}, perf_lut_uflow_sub[0:0]};
end
    
always @(
  perf_lut_uflow_cnt_cur
  or perf_lut_uflow_add
  or perf_lut_uflow_sub
  or perf_lut_uflow_adv
  or op_en_load
  ) begin
  perf_lut_uflow_cnt_ext[33:0] = {1'b0, 1'b0, perf_lut_uflow_cnt_cur};
  perf_lut_uflow_cnt_mod[33:0] = perf_lut_uflow_cnt_cur + perf_lut_uflow_add[4:0] - perf_lut_uflow_sub[0:0]; // spyglass disable W164b
  perf_lut_uflow_cnt_new[33:0] = (perf_lut_uflow_adv)? perf_lut_uflow_cnt_mod[33:0] : perf_lut_uflow_cnt_ext[33:0];
  perf_lut_uflow_cnt_nxt[33:0] = (op_en_load)? 34'd0 : perf_lut_uflow_cnt_new[33:0];
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    perf_lut_uflow_cnt_cur[31:0] <= 0;
  end else begin
  if (reg2dp_perf_lut_en) begin
  perf_lut_uflow_cnt_cur[31:0] <= perf_lut_uflow_cnt_nxt[31:0];
  end
  end
end

always @(
  perf_lut_uflow_cnt_cur
  ) begin
  lut_uflow_cnt[31:0] = perf_lut_uflow_cnt_cur[31:0];
end
    
  
// HYBRID
//: my $k=NVDLA_SDP_EW_THROUGHPUT;
//: foreach my $i  (1..${k}-1) {
//: print "assign lut_in_hybrid${i} = !(lut_in_oflow${i} | lut_in_uflow${i}); \n";
//: }
//: print "\n";
//: print "assign lut_hybrid_sum[4:0] = lut_in_hybrid0";
//: if(${k} >1) {
//: foreach my $i  (1..${k}-1) {
//: print "+ lut_in_hybrid${i}";
//: }
//: }
//: print ";\n";

assign perf_lut_hybrid_add = (&lut_hybrid_cnt) ? 0 : lut_hybrid_sum;
assign perf_lut_hybrid_sub = 1'b0;
assign dp2reg_lut_hybrid = lut_hybrid_cnt;

always @(
  perf_lut_hybrid_add
  or perf_lut_hybrid_sub
  ) begin
  perf_lut_hybrid_adv = perf_lut_hybrid_add[4:0] != {{4{1'b0}}, perf_lut_hybrid_sub[0:0]};
end
    
always @(
  perf_lut_hybrid_cnt_cur
  or perf_lut_hybrid_add
  or perf_lut_hybrid_sub
  or perf_lut_hybrid_adv
  or op_en_load
  ) begin
  perf_lut_hybrid_cnt_ext[33:0] = {1'b0, 1'b0, perf_lut_hybrid_cnt_cur};
  perf_lut_hybrid_cnt_mod[33:0] = perf_lut_hybrid_cnt_cur + perf_lut_hybrid_add[4:0] - perf_lut_hybrid_sub[0:0]; // spyglass disable W164b
  perf_lut_hybrid_cnt_new[33:0] = (perf_lut_hybrid_adv)? perf_lut_hybrid_cnt_mod[33:0] : perf_lut_hybrid_cnt_ext[33:0];
  perf_lut_hybrid_cnt_nxt[33:0] = (op_en_load)? 34'd0 : perf_lut_hybrid_cnt_new[33:0];
end

// perf_lut_hybrid flops

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    perf_lut_hybrid_cnt_cur[31:0] <= 0;
  end else begin
  if (reg2dp_perf_lut_en) begin
  perf_lut_hybrid_cnt_cur[31:0] <= perf_lut_hybrid_cnt_nxt[31:0];
  end
  end
end

// perf_lut_hybrid output logic

always @(
  perf_lut_hybrid_cnt_cur
  ) begin
  lut_hybrid_cnt[31:0] = perf_lut_hybrid_cnt_cur[31:0];
end
    
  
// LE_HIT
//: my $k=NVDLA_SDP_EW_THROUGHPUT;
//: print "assign lut_le_hit_sum[4:0] = lut_in_le_hit0";
//: if(${k} >1) {
//: foreach my $i  (1..${k}-1) {
//: print "+ lut_in_le_hit${i}";
//: }
//: }
//: print ";\n";

assign perf_lut_le_hit_add = (&lut_le_hit_cnt) ? 0 : lut_le_hit_sum;
assign perf_lut_le_hit_sub = 1'b0;
assign dp2reg_lut_le_hit = lut_le_hit_cnt;

always @(
  perf_lut_le_hit_add
  or perf_lut_le_hit_sub
  ) begin
  perf_lut_le_hit_adv = perf_lut_le_hit_add[4:0] != {{4{1'b0}}, perf_lut_le_hit_sub[0:0]};
end
    
// perf_lut_le_hit cnt logic
always @(
  perf_lut_le_hit_cnt_cur
  or perf_lut_le_hit_add
  or perf_lut_le_hit_sub
  or perf_lut_le_hit_adv
  or op_en_load
  ) begin
  // VCS sop_coverage_off start
  perf_lut_le_hit_cnt_ext[33:0] = {1'b0, 1'b0, perf_lut_le_hit_cnt_cur};
  perf_lut_le_hit_cnt_mod[33:0] = perf_lut_le_hit_cnt_cur + perf_lut_le_hit_add[4:0] - perf_lut_le_hit_sub[0:0]; 
  perf_lut_le_hit_cnt_new[33:0] = (perf_lut_le_hit_adv)? perf_lut_le_hit_cnt_mod[33:0] : perf_lut_le_hit_cnt_ext[33:0];
  perf_lut_le_hit_cnt_nxt[33:0] = (op_en_load)? 34'd0 : perf_lut_le_hit_cnt_new[33:0];
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    perf_lut_le_hit_cnt_cur[31:0] <= 0;
  end else begin
  if (reg2dp_perf_lut_en) begin
  perf_lut_le_hit_cnt_cur[31:0] <= perf_lut_le_hit_cnt_nxt[31:0];
  end
  end
end

always @(
  perf_lut_le_hit_cnt_cur
  ) begin
  lut_le_hit_cnt[31:0] = perf_lut_le_hit_cnt_cur[31:0];
end
    
  
// LO_HIT
//: my $k=NVDLA_SDP_EW_THROUGHPUT;
//: print "assign lut_lo_hit_sum[4:0] = lut_in_lo_hit0";
//: if(${k} >1) {
//: foreach my $i  (1..${k}-1) {
//: print "+ lut_in_lo_hit${i}";
//: }
//: }
//: print ";\n";

assign perf_lut_lo_hit_add = (&lut_lo_hit_cnt) ? 0 : lut_lo_hit_sum;
assign perf_lut_lo_hit_sub = 1'b0;
assign dp2reg_lut_lo_hit = lut_lo_hit_cnt;

always @(
  perf_lut_lo_hit_add
  or perf_lut_lo_hit_sub
  ) begin
  perf_lut_lo_hit_adv = perf_lut_lo_hit_add[4:0] != {{4{1'b0}}, perf_lut_lo_hit_sub[0:0]};
end
    
always @(
  perf_lut_lo_hit_cnt_cur
  or perf_lut_lo_hit_add
  or perf_lut_lo_hit_sub
  or perf_lut_lo_hit_adv
  or op_en_load
  ) begin
  perf_lut_lo_hit_cnt_ext[33:0] = {1'b0, 1'b0, perf_lut_lo_hit_cnt_cur};
  perf_lut_lo_hit_cnt_mod[33:0] = perf_lut_lo_hit_cnt_cur + perf_lut_lo_hit_add[4:0] - perf_lut_lo_hit_sub[0:0]; // spyglass disable W164b
  perf_lut_lo_hit_cnt_new[33:0] = (perf_lut_lo_hit_adv)? perf_lut_lo_hit_cnt_mod[33:0] : perf_lut_lo_hit_cnt_ext[33:0];
  perf_lut_lo_hit_cnt_nxt[33:0] = (op_en_load)? 34'd0 : perf_lut_lo_hit_cnt_new[33:0];
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    perf_lut_lo_hit_cnt_cur[31:0] <= 0;
  end else begin
  if (reg2dp_perf_lut_en) begin
  perf_lut_lo_hit_cnt_cur[31:0] <= perf_lut_lo_hit_cnt_nxt[31:0];
  end
  end
end

always @(
  perf_lut_lo_hit_cnt_cur
  ) begin
  lut_lo_hit_cnt[31:0] = perf_lut_lo_hit_cnt_cur[31:0];
end
  
 
  
//=======================================
// rd addr mux 
//: my $k=NVDLA_SDP_EW_THROUGHPUT;
//: foreach my $i  (0..${k}-1) {
//: print qq(
//: assign lut_in_addr${i}_0 = lut_in_addr${i};
//: assign lut_in_addr${i}_1 = lut_in_addr${i} + 1;
//: );
//: }
//: 
//: my $lut_depth = LUT_TABLE_MAX_DEPTH;
//: foreach my $lut (qw(le lo)) {
//:     foreach my $x (0..1) {
//:         foreach my $i (0.. ${k}-1) {
//:             print qq(
//:              always @ ( * ) begin
//:              case (lut_in_addr${i}_${x})
//:             );
//:             foreach my $idx ($x .. ${lut_depth}-1) {
//:                 print" $idx: ${lut}_data${x}_${i} = REG_${lut}_$idx; \n";
//:             }
//:             print qq(
//:              default: ${lut}_data${x}_${i}= {16{`x_or_0}};
//:              endcase
//:              end
//:             );
//:         }
//:     }
//: }
//: 
//: foreach my $i  (0..${k}-1) {
//: print qq(
//: assign dat_in_y0_$i = (lut_in_sel${i}==1'b0) ? le_data0_$i : lo_data0_$i;
//: assign dat_in_y1_$i = (lut_in_sel${i}==1'b0) ? le_data1_$i : lo_data1_$i;
//: );
//: }
  

//=======================================
// dat fifo wr
assign rd_lut_en = lut_in_pvld & lut_in_prdy;
assign dat_fifo_wr_pvld = rd_lut_en;

// PKT_PACK_WIRE( sdp_y_lut_dat ,  dat_in_ ,  dat_fifo_wr_pd )
//: my $k=NVDLA_SDP_EW_THROUGHPUT;
//: my $b=NVDLA_SDP_EW_THROUGHPUT*16;
//: foreach my $i  (0..${k}-1) {
//: print "assign       dat_fifo_wr_pd[16*${i}+15:16*${i}]  =  dat_in_y0_${i}[15:0]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign       dat_fifo_wr_pd[16*${i}+${b}+15:16*${i}+${b}] =  dat_in_y1_${i}[15:0]; \n";
//: }
//: 
//: foreach my $i  (0..${k}-1) {
//: print "assign       out_y0_${i}[15:0] = dat_fifo_rd_pd[16*${i}+15:16*${i}]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign       out_y1_${i}[15:0] = dat_fifo_rd_pd[16*${i}+${b}+15:16*${i}+${b}]; \n";
//: }


NV_NVDLA_SDP_CORE_Y_LUT_dat u_dat (
   .nvdla_core_clk   (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn  (nvdla_core_rstn)       //|< i
  ,.dat_fifo_wr_pvld (dat_fifo_wr_pvld)      //|< w
  ,.dat_fifo_wr_pd   (dat_fifo_wr_pd[32*NVDLA_SDP_EW_THROUGHPUT-1:0]) //|< w
  ,.dat_fifo_rd_prdy (dat_fifo_rd_prdy)      //|< w
  ,.dat_fifo_rd_pvld (dat_fifo_rd_pvld)      //|> w
  ,.dat_fifo_rd_pd   (dat_fifo_rd_pd[32*NVDLA_SDP_EW_THROUGHPUT-1:0]) //|> w
  ,.pwrbus_ram_pd    (pwrbus_ram_pd[31:0])   //|< i
  );

// dat fifo rd
assign dat_fifo_rd_prdy = lut_out_prdy;

//============
// cmd fifo wr:

// PKT_PACK_WIRE( sdp_y_lut_cmd ,  lut_in_ ,  cmd_fifo_wr_pd )
//: my $k=NVDLA_SDP_EW_THROUGHPUT;
//: my $bx =NVDLA_SDP_EW_THROUGHPUT*35;
//: my $bof=NVDLA_SDP_EW_THROUGHPUT*(35+32);
//: my $buf=NVDLA_SDP_EW_THROUGHPUT*(35+32+1);
//: my $bsl=NVDLA_SDP_EW_THROUGHPUT*(35+32+2);
//: foreach my $i  (0..${k}-1) {
//: print "assign       cmd_fifo_wr_pd[35*${i}+34:35*${i}] =      lut_in_fraction${i}[34:0]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign       cmd_fifo_wr_pd[32*${i}+31+${bx}:32*${i}+${bx}] =   lut_in_x${i}[31:0]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign       cmd_fifo_wr_pd[${i}+${bof}] =       lut_in_oflow${i} ; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign       cmd_fifo_wr_pd[${i}+${buf}] =       lut_in_uflow${i} ; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign       cmd_fifo_wr_pd[${i}+${bsl}] =       lut_in_sel${i} ; \n"; 
//: }
//: 
//: foreach my $i  (0..${k}-1) {
//: print "assign       out_fraction${i}[34:0] =  cmd_fifo_rd_pd[35*${i}+34:35*${i}]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign       out_x${i}[31:0]        =  cmd_fifo_rd_pd[32*${i}+31+${bx}:32*${i}+${bx}]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign       out_oflow${i}          =  cmd_fifo_rd_pd[${i}+${bof}]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign       out_uflow${i}          =  cmd_fifo_rd_pd[${i}+${buf}]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign       out_sel${i}            =  cmd_fifo_rd_pd[${i}+${bsl}]; \n";
//: }


assign cmd_fifo_wr_pvld = lut_in_pvld;
assign lut_in_prdy = cmd_fifo_wr_prdy;

// cmd fifo inst:
NV_NVDLA_SDP_CORE_Y_LUT_cmd u_cmd (
   .nvdla_core_clk   (nvdla_core_clk)        //|< i
  ,.nvdla_core_rstn  (nvdla_core_rstn)       //|< i
  ,.cmd_fifo_wr_prdy (cmd_fifo_wr_prdy)      //|> w
  ,.cmd_fifo_wr_pvld (cmd_fifo_wr_pvld)      //|< w
  ,.cmd_fifo_wr_pd   (cmd_fifo_wr_pd[70*NVDLA_SDP_EW_THROUGHPUT-1:0]) //|< w
  ,.cmd_fifo_rd_prdy (cmd_fifo_rd_prdy)      //|< w
  ,.cmd_fifo_rd_pvld (cmd_fifo_rd_pvld)      //|> w
  ,.cmd_fifo_rd_pd   (cmd_fifo_rd_pd[70*NVDLA_SDP_EW_THROUGHPUT-1:0]) //|> w
  ,.pwrbus_ram_pd    (pwrbus_ram_pd[31:0])   //|< i
  );

// cmd fifo rd:
assign cmd_fifo_rd_prdy = lut_out_prdy & dat_fifo_rd_pvld;

//=======================================
// output mux when oflow/uflow



//: my $k=NVDLA_SDP_EW_THROUGHPUT;
//: foreach my $i  (0..${k}-1) {
//: print "assign out_flow${i} = out_uflow${i} | out_oflow${i}; \n";
//: }
//:         
//: foreach my $i (0.. ${k}-1) {
//: print qq(
//:     always @(
//:       out_uflow$i
//:       or out_sel$i
//:       or reg2dp_lut_le_slope_uflow_scale
//:       or reg2dp_lut_le_slope_uflow_shift
//:       or reg2dp_lut_le_start
//:       or reg2dp_lut_le_function
//:       or reg2dp_proc_precision
//:       or reg2dp_lut_le_index_offset
//:       or reg2dp_lut_lo_slope_uflow_scale
//:       or reg2dp_lut_lo_slope_uflow_shift
//:       or reg2dp_lut_lo_start
//:       or out_oflow$i
//:       or reg2dp_lut_le_slope_oflow_scale
//:       or reg2dp_lut_le_slope_oflow_shift
//:       or reg2dp_lut_le_end
//:       or reg2dp_lut_lo_slope_oflow_scale
//:       or reg2dp_lut_lo_slope_oflow_shift
//:       or reg2dp_lut_lo_end
//:       ) begin
//:        if (out_uflow${i}) begin
//:                if (out_sel${i}==1'b0) begin
//:                    out_scale${i}  = reg2dp_lut_le_slope_uflow_scale;
//:                    out_shift${i}  = reg2dp_lut_le_slope_uflow_shift;
//:                    out_offset${i} = reg2dp_lut_le_start;
//:                    if (reg2dp_lut_le_function==1'b0) begin
//:                        out_bias${i} = reg2dp_lut_le_index_offset[8 -1] ? 0 : (1 << reg2dp_lut_le_index_offset);
//:                    end else begin
//:                        out_bias${i} = 0;
//:                    end
//:                end else begin
//:                    out_scale${i}  = reg2dp_lut_lo_slope_uflow_scale;
//:                    out_shift${i}  = reg2dp_lut_lo_slope_uflow_shift;
//:                    out_offset${i} = reg2dp_lut_lo_start;
//:                    out_bias${i}   = 0;
//:                end
//:          end else if (out_oflow${i}) begin
//:              if (out_sel${i}==1'b0) begin
//:                  out_scale${i}  = reg2dp_lut_le_slope_oflow_scale;
//:                  out_shift${i}  = reg2dp_lut_le_slope_oflow_shift;
//:                  out_offset${i} = reg2dp_lut_le_end;
//:                  out_bias${i}   = 0;
//:              end else begin
//:                  out_scale${i}  = reg2dp_lut_lo_slope_oflow_scale;
//:                  out_shift${i}  = reg2dp_lut_lo_slope_oflow_shift;
//:                  out_offset${i} = reg2dp_lut_lo_end;
//:                  out_bias${i}   = 0;
//:              end
//:          end else begin
//:              out_scale${i} = 0;
//:              out_shift${i} = 0;
//:              out_offset${i} = 0;
//:              out_bias${i}   = 0;
//:          end
//:     end
//: );
//: }


//=======================================
// output pipe
assign lut_out_pvld = dat_fifo_rd_pvld;

// PKT_PACK_WIRE( sdp_y_lut_out ,  out_ ,  lut_out_pd )
//: my $k=NVDLA_SDP_EW_THROUGHPUT;
//: my $bf =NVDLA_SDP_EW_THROUGHPUT*32;
//: my $by0=NVDLA_SDP_EW_THROUGHPUT*(32+35);
//: my $by1=NVDLA_SDP_EW_THROUGHPUT*(32+35+16);
//: my $bsc=NVDLA_SDP_EW_THROUGHPUT*(32+35+32);
//: my $bsf=NVDLA_SDP_EW_THROUGHPUT*(32+35+48);
//: my $bof=NVDLA_SDP_EW_THROUGHPUT*(32+35+48+5);
//: my $bbs=NVDLA_SDP_EW_THROUGHPUT*(32+35+85);
//: my $bfw=NVDLA_SDP_EW_THROUGHPUT*(32+35+85+32);
//: foreach my $i  (0..${k}-1) {
//: print "assign       lut_out_pd[32*${i}+31:32*${i}]                 = out_x${i}[31:0]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign       lut_out_pd[35*${i}+${bf}+34:35*${i}+${bf}]     = out_fraction${i}[34:0]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign       lut_out_pd[16*${i}+${by0}+15:16*${i}+${by0}]   = out_y0_${i}[15:0]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign       lut_out_pd[16*${i}+${by1}+15:16*${i}+${by1}]   = out_y1_${i}[15:0]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign       lut_out_pd[16*${i}+${bsc}+15:16*${i}+${bsc}]   = out_scale${i}[15:0]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign       lut_out_pd[5*${i}+${bsf}+4:5*${i}+${bsf}]      = out_shift${i}[4:0]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign       lut_out_pd[32*${i}+${bof}+31:32*${i}+${bof}]   = out_offset${i}[31:0]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign       lut_out_pd[32*${i}+${bbs}+31:32*${i}+${bbs}]   = out_bias${i}[31:0]; \n";
//: }
//: foreach my $i  (0..${k}-1) {
//: print "assign       lut_out_pd[${i}+${bfw}]     = out_flow${i}; \n"; 
//: }

NV_NVDLA_SDP_CORE_Y_lut_pipe_p2  pipe_p2 (
   .nvdla_core_clk  (nvdla_core_clk)              
  ,.nvdla_core_rstn (nvdla_core_rstn)             
  ,.lut_out_pvld    (lut_out_pvld)               
  ,.lut_out_prdy    (lut_out_prdy)               
  ,.lut_out_pd      (lut_out_pd[EW_LUT_OUT_DW-1:0])         
  ,.lut2inp_pvld    (lut2inp_pvld)              
  ,.lut2inp_prdy    (lut2inp_prdy)              
  ,.lut2inp_pd      (lut2inp_pd[EW_LUT_OUT_DW-1:0])          
  );


//=======================================
// Assertions
assign mon_cmd_fifo_rd_pvld = cmd_fifo_rd_pvld;

`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"when data is ready, cmd should be ready, which is faster")      zzz_assert_never_327x (nvdla_core_clk, `ASSERT_RESET, dat_fifo_rd_pvld & !mon_cmd_fifo_rd_pvld); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON


// Assertion for LUT Programing
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
  // VCS coverage off 
  nv_assert_never #(0,0,"exceed the size of LE LUT")      zzz_assert_never_328x (nvdla_core_clk, `ASSERT_RESET, (lut_table_id== 1'h0 ) && lut_addr> 65); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
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
  // VCS coverage off 
  nv_assert_never #(0,0,"exceed the size of LE LUT")      zzz_assert_never_329x (nvdla_core_clk, `ASSERT_RESET, (lut_table_id== 1'h1 ) && lut_addr> 257); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
endmodule // NV_NVDLA_SDP_CORE_Y_lut



module  NV_NVDLA_SDP_CORE_Y_lut_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,idx2lut_pvld
  ,idx2lut_prdy
  ,idx2lut_pd
  ,lut_in_pvld
  ,lut_in_prdy
  ,lut_in_pd
  );

input         nvdla_core_clk;
input         nvdla_core_rstn;
input         idx2lut_pvld;
output        idx2lut_prdy;
input  [EW_IDX_OUT_DW-1:0] idx2lut_pd;
output        lut_in_pvld;
input         lut_in_prdy;
output [EW_IDX_OUT_DW-1:0] lut_in_pd;

//: my $dw = EW_IDX_OUT_DW;
//: &eperl::pipe("-is -wid $dw -do lut_in_pd -vo lut_in_pvld -ri lut_in_prdy -di idx2lut_pd -vi idx2lut_pvld -ro idx2lut_prdy");


endmodule


module  NV_NVDLA_SDP_CORE_Y_lut_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,lut_out_pvld
  ,lut_out_prdy
  ,lut_out_pd
  ,lut2inp_pvld
  ,lut2inp_prdy
  ,lut2inp_pd
  );

input         nvdla_core_clk;
input         nvdla_core_rstn;
input         lut_out_pvld;
output        lut_out_prdy;
input  [EW_LUT_OUT_DW-1:0] lut_out_pd;
output        lut2inp_pvld;
input         lut2inp_prdy;
output [EW_LUT_OUT_DW-1:0] lut2inp_pd;


//: my $dw = EW_LUT_OUT_DW;
//: &eperl::pipe("-is -wid $dw -do lut2inp_pd -vo lut2inp_pvld -ri lut2inp_prdy -di lut_out_pd -vi lut_out_pvld -ro lut_out_prdy");


endmodule


#if (NVDLA_SDP_EW_THROUGHPUT==4) 


`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_SDP_CORE_Y_LUT_dat (
      nvdla_core_clk
    , nvdla_core_rstn
    , dat_fifo_wr_pvld
    , dat_fifo_wr_pd
    , dat_fifo_rd_prdy
    , dat_fifo_rd_pvld
    , dat_fifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         dat_fifo_wr_pvld;
input  [127:0] dat_fifo_wr_pd;
input         dat_fifo_rd_prdy;
output        dat_fifo_rd_pvld;
output [127:0] dat_fifo_rd_pd;
input  [31:0] pwrbus_ram_pd;

// Master Clock Gating (SLCG)
//
// We gate the clock(s) when idle or stalled.
// This allows us to turn off numerous miscellaneous flops
// that don't get gated during synthesis for one reason or another.
//
// We gate write side and read side separately. 
// If the fifo is synchronous, we also gate the ram separately, but if
// -master_clk_gated_unified or -status_reg/-status_logic_reg is specified, 
// then we use one clk gate for write, ram, and read.
//
wire nvdla_core_clk_mgated_enable;   // assigned by code at end of this module
wire nvdla_core_clk_mgated;               // used only in synchronous fifos
NV_CLK_gate_power nvdla_core_clk_mgate( .clk(nvdla_core_clk), .reset_(nvdla_core_rstn), .clk_en(nvdla_core_clk_mgated_enable), .clk_gated(nvdla_core_clk_mgated) );

// 
// WRITE SIDE
//
wire wr_reserving;
assign       wr_reserving = dat_fifo_wr_pvld;


wire       wr_popping;                          // fwd: write side sees pop?

reg  [1:0] dat_fifo_wr_count;			// write-side count

wire [1:0] wr_count_next_wr_popping = wr_reserving ? dat_fifo_wr_count : (dat_fifo_wr_count - 1'd1); // spyglass disable W164a W484
wire [1:0] wr_count_next_no_wr_popping = wr_reserving ? (dat_fifo_wr_count + 1'd1) : dat_fifo_wr_count; // spyglass disable W164a W484
wire [1:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_wr_count <=  2'd0;
    end else begin
	if ( wr_reserving ^ wr_popping ) begin
	    dat_fifo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            dat_fifo_wr_count <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as dat_fifo_wr_pvld

//
// RAM
//

reg   dat_fifo_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_wr_adr <=  1'd0;
    end else begin
        if ( wr_pushing ) begin
	    dat_fifo_wr_adr <=  dat_fifo_wr_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg  dat_fifo_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (dat_fifo_wr_count > 2'd0 || !rd_popping);   // note: write occurs next cycle
wire [127:0] dat_fifo_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_SDP_CORE_Y_LUT_dat_flopram_rwsa_2x128 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( dat_fifo_wr_pd )
    , .we        ( ram_we )
    , .wa        ( dat_fifo_wr_adr )
    , .ra        ( (dat_fifo_wr_count == 0) ? 2'd2 : {1'b0,dat_fifo_rd_adr} )
    , .dout        ( dat_fifo_rd_pd_p )
    );


wire [0:0] rd_adr_next_popping = dat_fifo_rd_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_rd_adr <=  1'd0;
    end else begin
        if ( rd_popping ) begin
	    dat_fifo_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            dat_fifo_rd_adr <=  {1{`x_or_0}};
        end
        //synopsys translate_on

    end
end

//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

wire       dat_fifo_rd_pvld_p; 		// data out of fifo is valid

reg        dat_fifo_rd_pvld_int;	// internal copy of dat_fifo_rd_pvld
assign     dat_fifo_rd_pvld = dat_fifo_rd_pvld_int;
assign     rd_popping = dat_fifo_rd_pvld_p && !(dat_fifo_rd_pvld_int && !dat_fifo_rd_prdy);

reg  [1:0] dat_fifo_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [1:0] rd_count_p_next_rd_popping = rd_pushing ? dat_fifo_rd_count_p : 
                                                                (dat_fifo_rd_count_p - 1'd1);
wire [1:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (dat_fifo_rd_count_p + 1'd1) : 
                                                                    dat_fifo_rd_count_p;
// spyglass enable_block W164a W484
wire [1:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     dat_fifo_rd_pvld_p = dat_fifo_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_rd_count_p <=  2'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    dat_fifo_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            dat_fifo_rd_count_p <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end
reg [127:0]  dat_fifo_rd_pd;         // output data register
wire        rd_req_next = (dat_fifo_rd_pvld_p || (dat_fifo_rd_pvld_int && !dat_fifo_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_rd_pvld_int <=  1'b0;
    end else begin
        dat_fifo_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        dat_fifo_rd_pd <=  dat_fifo_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        dat_fifo_rd_pd <=  {128{`x_or_0}};
    end
    //synopsys translate_on

end

// Master Clock Gating (SLCG) Enables
//

// plusarg for disabling this stuff:

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg master_clk_gating_disabled;  initial master_clk_gating_disabled = $test$plusargs( "fifogen_disable_master_clk_gating" ) != 0;
`endif
`endif
// synopsys translate_on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || dat_fifo_wr_pvld) || (rd_pushing || rd_popping || (dat_fifo_rd_pvld_int && dat_fifo_rd_prdy)) || (wr_pushing))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled
			       `endif
			       `endif
                               // synopsys translate_on
                               ;

//
// Histogram of fifo depth (from write side's perspective)
//
// NOTE: it will reference `SIMTOP.perfmon_enabled, so that
//       has to at least be defined, though not initialized.
//	 tbgen testbenches have it already and various
//	 ways to turn it on and off.
//
`ifdef PERFMON_HISTOGRAM 
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( nvdla_core_clk ) 
    , .max      ( 32'd2 )
    , .curr	( {30'd0, dat_fifo_wr_count} )
    );
`endif
`endif
// synopsys translate_on
`endif

// spyglass disable_block W164a W164b W116 W484 W504

`ifdef SPYGLASS
`else

`ifdef FV_ASSERT_ON
`else
// synopsys translate_off
`endif

`ifdef ASSERT_ON

`ifdef SPYGLASS
wire disable_assert_plusarg = 1'b0;
`else

`ifdef FV_ASSERT_ON
wire disable_assert_plusarg = 1'b0;
`else
wire disable_assert_plusarg = $test$plusargs("DISABLE_NESS_FLOW_ASSERTIONS");
`endif

`endif
wire assert_enabled = 1'b1 && !disable_assert_plusarg;


nv_assert_fifo #(0, 2, 0, 0, "FIFOGEN_ASSERTION Fifo overflow or underflow") 
    fifogen_rd_fifo_check ( .clk    ( nvdla_core_clk ), 
                            .reset_ ( ( ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn ) & assert_enabled === 1'bx ? 1'b0 : ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn ) & assert_enabled ) ), 
                            .push   ( rd_pushing ), 
                            .pop    ( rd_popping )
                          );

`endif

`ifdef FV_ASSERT_ON
`else
// synopsys translate_on
`endif

`ifdef ASSERT_ON

//synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
always @(assert_enabled) begin
    if ( assert_enabled === 1'b0 ) begin
        $display("Asserts are disabled for %m");
    end
end
`endif
`endif
//synopsys translate_on

`endif

`endif

// spyglass enable_block W164a W164b W116 W484 W504


//The NV_BLKBOX_SRC0 module is only present when the FIFOGEN_MODULE_SEARCH
// define is set.  This is to aid fifogen team search for fifogen fifo
// instance and module names in a given design.
`ifdef FIFOGEN_MODULE_SEARCH
NV_BLKBOX_SRC0 dummy_breadcrumb_fifogen_blkbox (.Y());
`endif

// spyglass enable_block W401 -- clock is not input to module

// synopsys dc_script_begin
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_CORE_Y_LUT_dat") true
// synopsys dc_script_end


endmodule // NV_NVDLA_SDP_CORE_Y_LUT_dat

// 
// Flop-Based RAM 
//
module NV_NVDLA_SDP_CORE_Y_LUT_dat_flopram_rwsa_2x128 (
      clk
    , pwrbus_ram_pd
    , di
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input [31 : 0] pwrbus_ram_pd;
input  [127:0] di;
input  we;
input  [0:0] wa;
input  [1:0] ra;
output [127:0] dout;

`ifndef FPGA
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_0 (.A(pwrbus_ram_pd[0]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_1 (.A(pwrbus_ram_pd[1]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_2 (.A(pwrbus_ram_pd[2]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_3 (.A(pwrbus_ram_pd[3]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_4 (.A(pwrbus_ram_pd[4]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_5 (.A(pwrbus_ram_pd[5]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_6 (.A(pwrbus_ram_pd[6]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_7 (.A(pwrbus_ram_pd[7]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_8 (.A(pwrbus_ram_pd[8]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_9 (.A(pwrbus_ram_pd[9]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_10 (.A(pwrbus_ram_pd[10]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_11 (.A(pwrbus_ram_pd[11]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_12 (.A(pwrbus_ram_pd[12]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_13 (.A(pwrbus_ram_pd[13]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_14 (.A(pwrbus_ram_pd[14]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_15 (.A(pwrbus_ram_pd[15]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_16 (.A(pwrbus_ram_pd[16]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_17 (.A(pwrbus_ram_pd[17]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_18 (.A(pwrbus_ram_pd[18]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_19 (.A(pwrbus_ram_pd[19]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_20 (.A(pwrbus_ram_pd[20]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_21 (.A(pwrbus_ram_pd[21]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_22 (.A(pwrbus_ram_pd[22]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_23 (.A(pwrbus_ram_pd[23]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_24 (.A(pwrbus_ram_pd[24]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_25 (.A(pwrbus_ram_pd[25]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_26 (.A(pwrbus_ram_pd[26]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_27 (.A(pwrbus_ram_pd[27]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_28 (.A(pwrbus_ram_pd[28]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_29 (.A(pwrbus_ram_pd[29]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_30 (.A(pwrbus_ram_pd[30]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_31 (.A(pwrbus_ram_pd[31]));
`endif


`ifdef EMU


wire [127:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [0:0] Wa0_vmw;
reg we0_vmw;
reg [127:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_SDP_CORE_Y_LUT_dat_flopram_rwsa_2x128 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[0:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 2) ? di : dout_p;

`else

reg [127:0] ram_ff0;
reg [127:0] ram_ff1;

always @( posedge clk ) begin
    if ( we && wa == 1'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 1'd1 ) begin
	ram_ff1 <=  di;
    end
end

reg [127:0] dout;

always @(*) begin
    case( ra ) 
    2'd0:       dout = ram_ff0;
    2'd1:       dout = ram_ff1;
    2'd2:       dout = di;
    //VCS coverage off
    default:    dout = {128{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_SDP_CORE_Y_LUT_dat_flopram_rwsa_2x128

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_SDP_CORE_Y_LUT_dat_flopram_rwsa_2x128 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [0:0] Wa0;
input            we0;
input  [127:0] Di0;
input  [0:0] Ra0;
output [127:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 128'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [127:0] mem[1:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [127:0] Q0 = mem[0];
wire [127:0] Q1 = mem[1];
`endif

// asynchronous ram writes
always @(*) begin
  if ( we0 == 1'b1 ) begin
    #0.1;
    mem[Wa0] = Di0;
  end
end

assign Do0 = mem[Ra0];
`endif
`endif
// synopsys translate_on

// synopsys dc_script_begin
// synopsys dc_script_end

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_SDP_CORE_Y_LUT_dat_flopram_rwsa_2x128] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_SDP_CORE_Y_LUT_dat_flopram_rwsa_2x128] }
endmodule // vmw_NV_NVDLA_SDP_CORE_Y_LUT_dat_flopram_rwsa_2x128

//vmw: Memory vmw_NV_NVDLA_SDP_CORE_Y_LUT_dat_flopram_rwsa_2x128
//vmw: Address-size 1
//vmw: Data-size 128
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[127:0] data0[127:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[127:0] data1[127:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_SDP_CORE_Y_LUT_dat_flopram_rwsa_2x128
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU



`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_SDP_CORE_Y_LUT_cmd (
      nvdla_core_clk
    , nvdla_core_rstn
    , cmd_fifo_wr_prdy
    , cmd_fifo_wr_pvld
    , cmd_fifo_wr_pd
    , cmd_fifo_rd_prdy
    , cmd_fifo_rd_pvld
    , cmd_fifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        cmd_fifo_wr_prdy;
input         cmd_fifo_wr_pvld;
input  [279:0] cmd_fifo_wr_pd;
input         cmd_fifo_rd_prdy;
output        cmd_fifo_rd_pvld;
output [279:0] cmd_fifo_rd_pd;
input  [31:0] pwrbus_ram_pd;

// Master Clock Gating (SLCG)
//
// We gate the clock(s) when idle or stalled.
// This allows us to turn off numerous miscellaneous flops
// that don't get gated during synthesis for one reason or another.
//
// We gate write side and read side separately. 
// If the fifo is synchronous, we also gate the ram separately, but if
// -master_clk_gated_unified or -status_reg/-status_logic_reg is specified, 
// then we use one clk gate for write, ram, and read.
//
wire nvdla_core_clk_mgated_enable;   // assigned by code at end of this module
wire nvdla_core_clk_mgated;               // used only in synchronous fifos
NV_CLK_gate_power nvdla_core_clk_mgate( .clk(nvdla_core_clk), .reset_(nvdla_core_rstn), .clk_en(nvdla_core_clk_mgated_enable), .clk_gated(nvdla_core_clk_mgated) );

// 
// WRITE SIDE
//
wire wr_reserving;
reg        cmd_fifo_wr_busy_int;		        	// copy for internal use
assign     cmd_fifo_wr_prdy = !cmd_fifo_wr_busy_int;
assign       wr_reserving = cmd_fifo_wr_pvld && !cmd_fifo_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [1:0] cmd_fifo_wr_count;			// write-side count

wire [1:0] wr_count_next_wr_popping = wr_reserving ? cmd_fifo_wr_count : (cmd_fifo_wr_count - 1'd1); // spyglass disable W164a W484
wire [1:0] wr_count_next_no_wr_popping = wr_reserving ? (cmd_fifo_wr_count + 1'd1) : cmd_fifo_wr_count; // spyglass disable W164a W484
wire [1:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_2 = ( wr_count_next_no_wr_popping == 2'd2 );
wire wr_count_next_is_2 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_2;
wire [1:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [1:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       cmd_fifo_wr_busy_next = wr_count_next_is_2 || // busy next cycle?
                          (wr_limit_reg != 2'd0 &&      // check cmd_fifo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_wr_busy_int <=  1'b0;
        cmd_fifo_wr_count <=  2'd0;
    end else begin
	cmd_fifo_wr_busy_int <=  cmd_fifo_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    cmd_fifo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            cmd_fifo_wr_count <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as cmd_fifo_wr_pvld

//
// RAM
//

reg   cmd_fifo_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_wr_adr <=  1'd0;
    end else begin
        if ( wr_pushing ) begin
	    cmd_fifo_wr_adr <=  cmd_fifo_wr_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg  cmd_fifo_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (cmd_fifo_wr_count > 2'd0 || !rd_popping);   // note: write occurs next cycle
wire [279:0] cmd_fifo_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_SDP_CORE_Y_LUT_cmd_flopram_rwsa_2x280 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( cmd_fifo_wr_pd )
    , .we        ( ram_we )
    , .wa        ( cmd_fifo_wr_adr )
    , .ra        ( (cmd_fifo_wr_count == 0) ? 2'd2 : {1'b0,cmd_fifo_rd_adr} )
    , .dout        ( cmd_fifo_rd_pd_p )
    );


wire [0:0] rd_adr_next_popping = cmd_fifo_rd_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_rd_adr <=  1'd0;
    end else begin
        if ( rd_popping ) begin
	    cmd_fifo_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            cmd_fifo_rd_adr <=  {1{`x_or_0}};
        end
        //synopsys translate_on

    end
end

//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

wire       cmd_fifo_rd_pvld_p; 		// data out of fifo is valid

reg        cmd_fifo_rd_pvld_int;	// internal copy of cmd_fifo_rd_pvld
assign     cmd_fifo_rd_pvld = cmd_fifo_rd_pvld_int;
assign     rd_popping = cmd_fifo_rd_pvld_p && !(cmd_fifo_rd_pvld_int && !cmd_fifo_rd_prdy);

reg  [1:0] cmd_fifo_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [1:0] rd_count_p_next_rd_popping = rd_pushing ? cmd_fifo_rd_count_p : 
                                                                (cmd_fifo_rd_count_p - 1'd1);
wire [1:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (cmd_fifo_rd_count_p + 1'd1) : 
                                                                    cmd_fifo_rd_count_p;
// spyglass enable_block W164a W484
wire [1:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     cmd_fifo_rd_pvld_p = cmd_fifo_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_rd_count_p <=  2'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    cmd_fifo_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            cmd_fifo_rd_count_p <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end
reg [279:0]  cmd_fifo_rd_pd;         // output data register
wire        rd_req_next = (cmd_fifo_rd_pvld_p || (cmd_fifo_rd_pvld_int && !cmd_fifo_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_rd_pvld_int <=  1'b0;
    end else begin
        cmd_fifo_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        cmd_fifo_rd_pd <=  cmd_fifo_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        cmd_fifo_rd_pd <=  {280{`x_or_0}};
    end
    //synopsys translate_on

end

// Master Clock Gating (SLCG) Enables
//

// plusarg for disabling this stuff:

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg master_clk_gating_disabled;  initial master_clk_gating_disabled = $test$plusargs( "fifogen_disable_master_clk_gating" ) != 0;
`endif
`endif
// synopsys translate_on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (cmd_fifo_wr_pvld && !cmd_fifo_wr_busy_int) || (cmd_fifo_wr_busy_int != cmd_fifo_wr_busy_next)) || (rd_pushing || rd_popping || (cmd_fifo_rd_pvld_int && cmd_fifo_rd_prdy)) || (wr_pushing))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled
			       `endif
			       `endif
                               // synopsys translate_on
                               ;


// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_SDP_CORE_Y_LUT_cmd_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_SDP_CORE_Y_LUT_cmd_wr_limit : 2'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 2'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 2'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 2'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [1:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 2'd0;
`ifdef NV_ARCHPRO
event reinit;

initial begin
    $display("fifogen reinit initial block %m");
    -> reinit;
end
`endif

`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    wr_limit_override = 0;
    wr_limit_override_value = 0;  // to keep viva happy with dangles
    if ( $test$plusargs( "NV_NVDLA_SDP_CORE_Y_LUT_cmd_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_SDP_CORE_Y_LUT_cmd_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif

//
// Histogram of fifo depth (from write side's perspective)
//
// NOTE: it will reference `SIMTOP.perfmon_enabled, so that
//       has to at least be defined, though not initialized.
//	 tbgen testbenches have it already and various
//	 ways to turn it on and off.
//
`ifdef PERFMON_HISTOGRAM 
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( nvdla_core_clk ) 
    , .max      ( {30'd0, (wr_limit_reg == 2'd0) ? 2'd2 : wr_limit_reg} )
    , .curr	( {30'd0, cmd_fifo_wr_count} )
    );
`endif
`endif
// synopsys translate_on
`endif

// spyglass disable_block W164a W164b W116 W484 W504

`ifdef SPYGLASS
`else

`ifdef FV_ASSERT_ON
`else
// synopsys translate_off
`endif

`ifdef ASSERT_ON

`ifdef SPYGLASS
wire disable_assert_plusarg = 1'b0;
`else

`ifdef FV_ASSERT_ON
wire disable_assert_plusarg = 1'b0;
`else
wire disable_assert_plusarg = $test$plusargs("DISABLE_NESS_FLOW_ASSERTIONS");
`endif

`endif
wire assert_enabled = 1'b1 && !disable_assert_plusarg;


`endif

`ifdef FV_ASSERT_ON
`else
// synopsys translate_on
`endif

`ifdef ASSERT_ON

//synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
always @(assert_enabled) begin
    if ( assert_enabled === 1'b0 ) begin
        $display("Asserts are disabled for %m");
    end
end
`endif
`endif
//synopsys translate_on

`endif

`endif

// spyglass enable_block W164a W164b W116 W484 W504


//The NV_BLKBOX_SRC0 module is only present when the FIFOGEN_MODULE_SEARCH
// define is set.  This is to aid fifogen team search for fifogen fifo
// instance and module names in a given design.
`ifdef FIFOGEN_MODULE_SEARCH
NV_BLKBOX_SRC0 dummy_breadcrumb_fifogen_blkbox (.Y());
`endif

// spyglass enable_block W401 -- clock is not input to module

// synopsys dc_script_begin
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_CORE_Y_LUT_cmd") true
// synopsys dc_script_end


endmodule // NV_NVDLA_SDP_CORE_Y_LUT_cmd

// 
// Flop-Based RAM 
//
module NV_NVDLA_SDP_CORE_Y_LUT_cmd_flopram_rwsa_2x280 (
      clk
    , pwrbus_ram_pd
    , di
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input [31 : 0] pwrbus_ram_pd;
input  [279:0] di;
input  we;
input  [0:0] wa;
input  [1:0] ra;
output [279:0] dout;

`ifndef FPGA
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_0 (.A(pwrbus_ram_pd[0]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_1 (.A(pwrbus_ram_pd[1]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_2 (.A(pwrbus_ram_pd[2]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_3 (.A(pwrbus_ram_pd[3]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_4 (.A(pwrbus_ram_pd[4]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_5 (.A(pwrbus_ram_pd[5]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_6 (.A(pwrbus_ram_pd[6]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_7 (.A(pwrbus_ram_pd[7]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_8 (.A(pwrbus_ram_pd[8]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_9 (.A(pwrbus_ram_pd[9]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_10 (.A(pwrbus_ram_pd[10]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_11 (.A(pwrbus_ram_pd[11]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_12 (.A(pwrbus_ram_pd[12]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_13 (.A(pwrbus_ram_pd[13]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_14 (.A(pwrbus_ram_pd[14]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_15 (.A(pwrbus_ram_pd[15]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_16 (.A(pwrbus_ram_pd[16]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_17 (.A(pwrbus_ram_pd[17]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_18 (.A(pwrbus_ram_pd[18]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_19 (.A(pwrbus_ram_pd[19]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_20 (.A(pwrbus_ram_pd[20]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_21 (.A(pwrbus_ram_pd[21]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_22 (.A(pwrbus_ram_pd[22]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_23 (.A(pwrbus_ram_pd[23]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_24 (.A(pwrbus_ram_pd[24]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_25 (.A(pwrbus_ram_pd[25]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_26 (.A(pwrbus_ram_pd[26]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_27 (.A(pwrbus_ram_pd[27]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_28 (.A(pwrbus_ram_pd[28]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_29 (.A(pwrbus_ram_pd[29]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_30 (.A(pwrbus_ram_pd[30]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_31 (.A(pwrbus_ram_pd[31]));
`endif

`ifdef EMU


wire [279:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [0:0] Wa0_vmw;
reg we0_vmw;
reg [279:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_SDP_CORE_Y_LUT_cmd_flopram_rwsa_2x280 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[0:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 2) ? di : dout_p;

`else

reg [279:0] ram_ff0;
reg [279:0] ram_ff1;

always @( posedge clk ) begin
    if ( we && wa == 1'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 1'd1 ) begin
	ram_ff1 <=  di;
    end
end

reg [279:0] dout;

always @(*) begin
    case( ra ) 
    2'd0:       dout = ram_ff0;
    2'd1:       dout = ram_ff1;
    2'd2:       dout = di;
    //VCS coverage off
    default:    dout = {280{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_SDP_CORE_Y_LUT_cmd_flopram_rwsa_2x280

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_SDP_CORE_Y_LUT_cmd_flopram_rwsa_2x280 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [0:0] Wa0;
input            we0;
input  [279:0] Di0;
input  [0:0] Ra0;
output [279:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 280'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [279:0] mem[1:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [279:0] Q0 = mem[0];
wire [279:0] Q1 = mem[1];
`endif

// asynchronous ram writes
always @(*) begin
  if ( we0 == 1'b1 ) begin
    #0.1;
    mem[Wa0] = Di0;
  end
end

assign Do0 = mem[Ra0];
`endif
`endif
// synopsys translate_on

// synopsys dc_script_begin
// synopsys dc_script_end

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_SDP_CORE_Y_LUT_cmd_flopram_rwsa_2x280] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_SDP_CORE_Y_LUT_cmd_flopram_rwsa_2x280] }
endmodule // vmw_NV_NVDLA_SDP_CORE_Y_LUT_cmd_flopram_rwsa_2x280


`endif // EMU



#elif (NVDLA_SDP_EW_THROUGHPUT==1) 


`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_SDP_CORE_Y_LUT_dat (
      nvdla_core_clk
    , nvdla_core_rstn
    , dat_fifo_wr_pvld
    , dat_fifo_wr_pd
    , dat_fifo_rd_prdy
    , dat_fifo_rd_pvld
    , dat_fifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         dat_fifo_wr_pvld;
input  [31:0] dat_fifo_wr_pd;
input         dat_fifo_rd_prdy;
output        dat_fifo_rd_pvld;
output [31:0] dat_fifo_rd_pd;
input  [31:0] pwrbus_ram_pd;

// Master Clock Gating (SLCG)
//
// We gate the clock(s) when idle or stalled.
// This allows us to turn off numerous miscellaneous flops
// that don't get gated during synthesis for one reason or another.
//
// We gate write side and read side separately. 
// If the fifo is synchronous, we also gate the ram separately, but if
// -master_clk_gated_unified or -status_reg/-status_logic_reg is specified, 
// then we use one clk gate for write, ram, and read.
//
wire nvdla_core_clk_mgated_enable;   // assigned by code at end of this module
wire nvdla_core_clk_mgated;               // used only in synchronous fifos
NV_CLK_gate_power nvdla_core_clk_mgate( .clk(nvdla_core_clk), .reset_(nvdla_core_rstn), .clk_en(nvdla_core_clk_mgated_enable), .clk_gated(nvdla_core_clk_mgated) );

// 
// WRITE SIDE
//
wire wr_reserving;
assign       wr_reserving = dat_fifo_wr_pvld;


wire       wr_popping;                          // fwd: write side sees pop?

reg  [1:0] dat_fifo_wr_count;			// write-side count

wire [1:0] wr_count_next_wr_popping = wr_reserving ? dat_fifo_wr_count : (dat_fifo_wr_count - 1'd1); // spyglass disable W164a W484
wire [1:0] wr_count_next_no_wr_popping = wr_reserving ? (dat_fifo_wr_count + 1'd1) : dat_fifo_wr_count; // spyglass disable W164a W484
wire [1:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_wr_count <=  2'd0;
    end else begin
	if ( wr_reserving ^ wr_popping ) begin
	    dat_fifo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            dat_fifo_wr_count <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as dat_fifo_wr_pvld

//
// RAM
//

reg   dat_fifo_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_wr_adr <=  1'd0;
    end else begin
        if ( wr_pushing ) begin
	    dat_fifo_wr_adr <=  dat_fifo_wr_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg  dat_fifo_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (dat_fifo_wr_count > 2'd0 || !rd_popping);   // note: write occurs next cycle
wire [31:0] dat_fifo_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_SDP_CORE_Y_LUT_dat_flopram_rwsa_2x32 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( dat_fifo_wr_pd )
    , .we        ( ram_we )
    , .wa        ( dat_fifo_wr_adr )
    , .ra        ( (dat_fifo_wr_count == 0) ? 2'd2 : {1'b0,dat_fifo_rd_adr} )
    , .dout        ( dat_fifo_rd_pd_p )
    );


wire [0:0] rd_adr_next_popping = dat_fifo_rd_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_rd_adr <=  1'd0;
    end else begin
        if ( rd_popping ) begin
	    dat_fifo_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            dat_fifo_rd_adr <=  {1{`x_or_0}};
        end
        //synopsys translate_on

    end
end

//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

wire       dat_fifo_rd_pvld_p; 		// data out of fifo is valid

reg        dat_fifo_rd_pvld_int;	// internal copy of dat_fifo_rd_pvld
assign     dat_fifo_rd_pvld = dat_fifo_rd_pvld_int;
assign     rd_popping = dat_fifo_rd_pvld_p && !(dat_fifo_rd_pvld_int && !dat_fifo_rd_prdy);

reg  [1:0] dat_fifo_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [1:0] rd_count_p_next_rd_popping = rd_pushing ? dat_fifo_rd_count_p : 
                                                                (dat_fifo_rd_count_p - 1'd1);
wire [1:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (dat_fifo_rd_count_p + 1'd1) : 
                                                                    dat_fifo_rd_count_p;
// spyglass enable_block W164a W484
wire [1:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     dat_fifo_rd_pvld_p = dat_fifo_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_rd_count_p <=  2'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    dat_fifo_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            dat_fifo_rd_count_p <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end
reg [31:0]  dat_fifo_rd_pd;         // output data register
wire        rd_req_next = (dat_fifo_rd_pvld_p || (dat_fifo_rd_pvld_int && !dat_fifo_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        dat_fifo_rd_pvld_int <=  1'b0;
    end else begin
        dat_fifo_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        dat_fifo_rd_pd <=  dat_fifo_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        dat_fifo_rd_pd <=  {32{`x_or_0}};
    end
    //synopsys translate_on

end

// Master Clock Gating (SLCG) Enables
//

// plusarg for disabling this stuff:

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg master_clk_gating_disabled;  initial master_clk_gating_disabled = $test$plusargs( "fifogen_disable_master_clk_gating" ) != 0;
`endif
`endif
// synopsys translate_on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || dat_fifo_wr_pvld) || (rd_pushing || rd_popping || (dat_fifo_rd_pvld_int && dat_fifo_rd_prdy)) || (wr_pushing))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled
			       `endif
			       `endif
                               // synopsys translate_on
                               ;

//
// Histogram of fifo depth (from write side's perspective)
//
// NOTE: it will reference `SIMTOP.perfmon_enabled, so that
//       has to at least be defined, though not initialized.
//	 tbgen testbenches have it already and various
//	 ways to turn it on and off.
//
`ifdef PERFMON_HISTOGRAM 
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( nvdla_core_clk ) 
    , .max      ( 32'd2 )
    , .curr	( {30'd0, dat_fifo_wr_count} )
    );
`endif
`endif
// synopsys translate_on
`endif

// spyglass disable_block W164a W164b W116 W484 W504

`ifdef SPYGLASS
`else

`ifdef FV_ASSERT_ON
`else
// synopsys translate_off
`endif

`ifdef ASSERT_ON

`ifdef SPYGLASS
wire disable_assert_plusarg = 1'b0;
`else

`ifdef FV_ASSERT_ON
wire disable_assert_plusarg = 1'b0;
`else
wire disable_assert_plusarg = $test$plusargs("DISABLE_NESS_FLOW_ASSERTIONS");
`endif

`endif
wire assert_enabled = 1'b1 && !disable_assert_plusarg;


nv_assert_fifo #(0, 2, 0, 0, "FIFOGEN_ASSERTION Fifo overflow or underflow") 
    fifogen_rd_fifo_check ( .clk    ( nvdla_core_clk ), 
                            .reset_ ( ( ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn ) & assert_enabled === 1'bx ? 1'b0 : ( nvdla_core_rstn === 1'bx ? 1'b0 : nvdla_core_rstn ) & assert_enabled ) ), 
                            .push   ( rd_pushing ), 
                            .pop    ( rd_popping )
                          );

`endif

`ifdef FV_ASSERT_ON
`else
// synopsys translate_on
`endif

`ifdef ASSERT_ON

//synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
always @(assert_enabled) begin
    if ( assert_enabled === 1'b0 ) begin
        $display("Asserts are disabled for %m");
    end
end
`endif
`endif
//synopsys translate_on

`endif

`endif

// spyglass enable_block W164a W164b W116 W484 W504


//The NV_BLKBOX_SRC0 module is only present when the FIFOGEN_MODULE_SEARCH
// define is set.  This is to aid fifogen team search for fifogen fifo
// instance and module names in a given design.
`ifdef FIFOGEN_MODULE_SEARCH
NV_BLKBOX_SRC0 dummy_breadcrumb_fifogen_blkbox (.Y());
`endif

// spyglass enable_block W401 -- clock is not input to module

// synopsys dc_script_begin
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_CORE_Y_LUT_dat") true
// synopsys dc_script_end


endmodule // NV_NVDLA_SDP_CORE_Y_LUT_dat

// 
// Flop-Based RAM 
//
module NV_NVDLA_SDP_CORE_Y_LUT_dat_flopram_rwsa_2x32 (
      clk
    , pwrbus_ram_pd
    , di
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input [31 : 0] pwrbus_ram_pd;
input  [31:0] di;
input  we;
input  [0:0] wa;
input  [1:0] ra;
output [31:0] dout;

`ifndef FPGA
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_0 (.A(pwrbus_ram_pd[0]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_1 (.A(pwrbus_ram_pd[1]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_2 (.A(pwrbus_ram_pd[2]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_3 (.A(pwrbus_ram_pd[3]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_4 (.A(pwrbus_ram_pd[4]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_5 (.A(pwrbus_ram_pd[5]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_6 (.A(pwrbus_ram_pd[6]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_7 (.A(pwrbus_ram_pd[7]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_8 (.A(pwrbus_ram_pd[8]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_9 (.A(pwrbus_ram_pd[9]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_10 (.A(pwrbus_ram_pd[10]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_11 (.A(pwrbus_ram_pd[11]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_12 (.A(pwrbus_ram_pd[12]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_13 (.A(pwrbus_ram_pd[13]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_14 (.A(pwrbus_ram_pd[14]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_15 (.A(pwrbus_ram_pd[15]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_16 (.A(pwrbus_ram_pd[16]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_17 (.A(pwrbus_ram_pd[17]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_18 (.A(pwrbus_ram_pd[18]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_19 (.A(pwrbus_ram_pd[19]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_20 (.A(pwrbus_ram_pd[20]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_21 (.A(pwrbus_ram_pd[21]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_22 (.A(pwrbus_ram_pd[22]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_23 (.A(pwrbus_ram_pd[23]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_24 (.A(pwrbus_ram_pd[24]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_25 (.A(pwrbus_ram_pd[25]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_26 (.A(pwrbus_ram_pd[26]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_27 (.A(pwrbus_ram_pd[27]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_28 (.A(pwrbus_ram_pd[28]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_29 (.A(pwrbus_ram_pd[29]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_30 (.A(pwrbus_ram_pd[30]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_31 (.A(pwrbus_ram_pd[31]));
`endif

`ifdef EMU


wire [31:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [0:0] Wa0_vmw;
reg we0_vmw;
reg [31:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_SDP_CORE_Y_LUT_dat_flopram_rwsa_2x32 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[0:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 2) ? di : dout_p;

`else

reg [31:0] ram_ff0;
reg [31:0] ram_ff1;

always @( posedge clk ) begin
    if ( we && wa == 1'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 1'd1 ) begin
	ram_ff1 <=  di;
    end
end

reg [31:0] dout;

always @(*) begin
    case( ra ) 
    2'd0:       dout = ram_ff0;
    2'd1:       dout = ram_ff1;
    2'd2:       dout = di;
    //VCS coverage off
    default:    dout = {32{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_SDP_CORE_Y_LUT_dat_flopram_rwsa_2x32

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_SDP_CORE_Y_LUT_dat_flopram_rwsa_2x32 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [0:0] Wa0;
input            we0;
input  [31:0] Di0;
input  [0:0] Ra0;
output [31:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 32'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [31:0] mem[1:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [31:0] Q0 = mem[0];
wire [31:0] Q1 = mem[1];
`endif

// asynchronous ram writes
always @(*) begin
  if ( we0 == 1'b1 ) begin
    #0.1;
    mem[Wa0] = Di0;
  end
end

assign Do0 = mem[Ra0];
`endif
`endif
// synopsys translate_on

// synopsys dc_script_begin
// synopsys dc_script_end

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_SDP_CORE_Y_LUT_dat_flopram_rwsa_2x32] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_SDP_CORE_Y_LUT_dat_flopram_rwsa_2x32] }
endmodule // vmw_NV_NVDLA_SDP_CORE_Y_LUT_dat_flopram_rwsa_2x32

//vmw: Memory vmw_NV_NVDLA_SDP_CORE_Y_LUT_dat_flopram_rwsa_2x32
//vmw: Address-size 1
//vmw: Data-size 32
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[31:0] data0[31:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[31:0] data1[31:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_SDP_CORE_Y_LUT_dat_flopram_rwsa_2x32
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU


`define FORCE_CONTENTION_ASSERTION_RESET_ACTIVE 1'b1
`include "simulate_x_tick.vh"


module NV_NVDLA_SDP_CORE_Y_LUT_cmd (
      nvdla_core_clk
    , nvdla_core_rstn
    , cmd_fifo_wr_prdy
    , cmd_fifo_wr_pvld
    , cmd_fifo_wr_pd
    , cmd_fifo_rd_prdy
    , cmd_fifo_rd_pvld
    , cmd_fifo_rd_pd
    , pwrbus_ram_pd
    );

// spyglass disable_block W401 -- clock is not input to module
input         nvdla_core_clk;
input         nvdla_core_rstn;
output        cmd_fifo_wr_prdy;
input         cmd_fifo_wr_pvld;
input  [69:0] cmd_fifo_wr_pd;
input         cmd_fifo_rd_prdy;
output        cmd_fifo_rd_pvld;
output [69:0] cmd_fifo_rd_pd;
input  [31:0] pwrbus_ram_pd;

// Master Clock Gating (SLCG)
//
// We gate the clock(s) when idle or stalled.
// This allows us to turn off numerous miscellaneous flops
// that don't get gated during synthesis for one reason or another.
//
// We gate write side and read side separately. 
// If the fifo is synchronous, we also gate the ram separately, but if
// -master_clk_gated_unified or -status_reg/-status_logic_reg is specified, 
// then we use one clk gate for write, ram, and read.
//
wire nvdla_core_clk_mgated_enable;   // assigned by code at end of this module
wire nvdla_core_clk_mgated;               // used only in synchronous fifos
NV_CLK_gate_power nvdla_core_clk_mgate( .clk(nvdla_core_clk), .reset_(nvdla_core_rstn), .clk_en(nvdla_core_clk_mgated_enable), .clk_gated(nvdla_core_clk_mgated) );

// 
// WRITE SIDE
//
wire wr_reserving;
reg        cmd_fifo_wr_busy_int;		        	// copy for internal use
assign     cmd_fifo_wr_prdy = !cmd_fifo_wr_busy_int;
assign       wr_reserving = cmd_fifo_wr_pvld && !cmd_fifo_wr_busy_int; // reserving write space?


wire       wr_popping;                          // fwd: write side sees pop?

reg  [1:0] cmd_fifo_wr_count;			// write-side count

wire [1:0] wr_count_next_wr_popping = wr_reserving ? cmd_fifo_wr_count : (cmd_fifo_wr_count - 1'd1); // spyglass disable W164a W484
wire [1:0] wr_count_next_no_wr_popping = wr_reserving ? (cmd_fifo_wr_count + 1'd1) : cmd_fifo_wr_count; // spyglass disable W164a W484
wire [1:0] wr_count_next = wr_popping ? wr_count_next_wr_popping : 
                                               wr_count_next_no_wr_popping;

wire wr_count_next_no_wr_popping_is_2 = ( wr_count_next_no_wr_popping == 2'd2 );
wire wr_count_next_is_2 = wr_popping ? 1'b0 :
                                          wr_count_next_no_wr_popping_is_2;
wire [1:0] wr_limit_muxed;  // muxed with simulation/emulation overrides
wire [1:0] wr_limit_reg = wr_limit_muxed;
                          // VCS coverage off
wire       cmd_fifo_wr_busy_next = wr_count_next_is_2 || // busy next cycle?
                          (wr_limit_reg != 2'd0 &&      // check cmd_fifo_wr_limit if != 0
                           wr_count_next >= wr_limit_reg)  ;
                          // VCS coverage on
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_wr_busy_int <=  1'b0;
        cmd_fifo_wr_count <=  2'd0;
    end else begin
	cmd_fifo_wr_busy_int <=  cmd_fifo_wr_busy_next;
	if ( wr_reserving ^ wr_popping ) begin
	    cmd_fifo_wr_count <=  wr_count_next;
        end 
        //synopsys translate_off
            else if ( !(wr_reserving ^ wr_popping) ) begin
        end else begin
            cmd_fifo_wr_count <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end

wire       wr_pushing = wr_reserving;   // data pushed same cycle as cmd_fifo_wr_pvld

//
// RAM
//

reg   cmd_fifo_wr_adr;			// current write address

// spyglass disable_block W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_wr_adr <=  1'd0;
    end else begin
        if ( wr_pushing ) begin
	    cmd_fifo_wr_adr <=  cmd_fifo_wr_adr + 1'd1;
        end
    end
end
// spyglass enable_block W484

wire rd_popping;

reg  cmd_fifo_rd_adr;          // read address this cycle
wire ram_we = wr_pushing && (cmd_fifo_wr_count > 2'd0 || !rd_popping);   // note: write occurs next cycle
wire [69:0] cmd_fifo_rd_pd_p;                    // read data out of ram

wire [31 : 0] pwrbus_ram_pd;

// Adding parameter for fifogen to disable wr/rd contention assertion in ramgen.
// Fifogen handles this by ignoring the data on the ram data out for that cycle.


NV_NVDLA_SDP_CORE_Y_LUT_cmd_flopram_rwsa_2x70 ram (
      .clk( nvdla_core_clk_mgated )
    , .pwrbus_ram_pd ( pwrbus_ram_pd )
    , .di        ( cmd_fifo_wr_pd )
    , .we        ( ram_we )
    , .wa        ( cmd_fifo_wr_adr )
    , .ra        ( (cmd_fifo_wr_count == 0) ? 2'd2 : {1'b0,cmd_fifo_rd_adr} )
    , .dout        ( cmd_fifo_rd_pd_p )
    );


wire [0:0] rd_adr_next_popping = cmd_fifo_rd_adr + 1'd1; // spyglass disable W484
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_rd_adr <=  1'd0;
    end else begin
        if ( rd_popping ) begin
	    cmd_fifo_rd_adr <=  rd_adr_next_popping;
        end 
        //synopsys translate_off
            else if ( !rd_popping ) begin
        end else begin
            cmd_fifo_rd_adr <=  {1{`x_or_0}};
        end
        //synopsys translate_on

    end
end

//
// SYNCHRONOUS BOUNDARY
//


assign wr_popping = rd_popping;		// let it be seen immediately

wire   rd_pushing = wr_pushing;		// let it be seen immediately

//
// READ SIDE
//

wire       cmd_fifo_rd_pvld_p; 		// data out of fifo is valid

reg        cmd_fifo_rd_pvld_int;	// internal copy of cmd_fifo_rd_pvld
assign     cmd_fifo_rd_pvld = cmd_fifo_rd_pvld_int;
assign     rd_popping = cmd_fifo_rd_pvld_p && !(cmd_fifo_rd_pvld_int && !cmd_fifo_rd_prdy);

reg  [1:0] cmd_fifo_rd_count_p;			// read-side fifo count
// spyglass disable_block W164a W484
wire [1:0] rd_count_p_next_rd_popping = rd_pushing ? cmd_fifo_rd_count_p : 
                                                                (cmd_fifo_rd_count_p - 1'd1);
wire [1:0] rd_count_p_next_no_rd_popping =  rd_pushing ? (cmd_fifo_rd_count_p + 1'd1) : 
                                                                    cmd_fifo_rd_count_p;
// spyglass enable_block W164a W484
wire [1:0] rd_count_p_next = rd_popping ? rd_count_p_next_rd_popping :
                                                     rd_count_p_next_no_rd_popping; 
assign     cmd_fifo_rd_pvld_p = cmd_fifo_rd_count_p != 0 || rd_pushing;
always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_rd_count_p <=  2'd0;
    end else begin
        if ( rd_pushing || rd_popping  ) begin
	    cmd_fifo_rd_count_p <=  rd_count_p_next;
        end 
        //synopsys translate_off
            else if ( !(rd_pushing || rd_popping ) ) begin
        end else begin
            cmd_fifo_rd_count_p <=  {2{`x_or_0}};
        end
        //synopsys translate_on

    end
end
reg [69:0]  cmd_fifo_rd_pd;         // output data register
wire        rd_req_next = (cmd_fifo_rd_pvld_p || (cmd_fifo_rd_pvld_int && !cmd_fifo_rd_prdy)) ;

always @( posedge nvdla_core_clk_mgated or negedge nvdla_core_rstn ) begin
    if ( !nvdla_core_rstn ) begin
        cmd_fifo_rd_pvld_int <=  1'b0;
    end else begin
        cmd_fifo_rd_pvld_int <=  rd_req_next;
    end
end
always @( posedge nvdla_core_clk_mgated ) begin
    if ( (rd_popping) ) begin
        cmd_fifo_rd_pd <=  cmd_fifo_rd_pd_p;
    end 
    //synopsys translate_off
        else if ( !((rd_popping)) ) begin
    end else begin
        cmd_fifo_rd_pd <=  {70{`x_or_0}};
    end
    //synopsys translate_on

end

// Master Clock Gating (SLCG) Enables
//

// plusarg for disabling this stuff:

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg master_clk_gating_disabled;  initial master_clk_gating_disabled = $test$plusargs( "fifogen_disable_master_clk_gating" ) != 0;
`endif
`endif
// synopsys translate_on
assign nvdla_core_clk_mgated_enable = ((wr_reserving || wr_pushing || wr_popping || (cmd_fifo_wr_pvld && !cmd_fifo_wr_busy_int) || (cmd_fifo_wr_busy_int != cmd_fifo_wr_busy_next)) || (rd_pushing || rd_popping || (cmd_fifo_rd_pvld_int && cmd_fifo_rd_prdy)) || (wr_pushing))
                               `ifdef FIFOGEN_MASTER_CLK_GATING_DISABLED
                               || 1'b1
                               `endif
                               // synopsys translate_off
			       `ifndef SYNTH_LEVEL1_COMPILE
			       `ifndef SYNTHESIS
                               || master_clk_gating_disabled
			       `endif
			       `endif
                               // synopsys translate_on
                               ;


// Simulation and Emulation Overrides of wr_limit(s)
//

`ifdef EMU

`ifdef EMU_FIFO_CFG
// Emulation Global Config Override
//
assign wr_limit_muxed = `EMU_FIFO_CFG.NV_NVDLA_SDP_CORE_Y_LUT_cmd_wr_limit_override ? `EMU_FIFO_CFG.NV_NVDLA_SDP_CORE_Y_LUT_cmd_wr_limit : 2'd0;
`else
// No Global Override for Emulation 
//
assign wr_limit_muxed = 2'd0;
`endif // EMU_FIFO_CFG

`else // !EMU
`ifdef SYNTH_LEVEL1_COMPILE

// No Override for GCS Compiles
//
assign wr_limit_muxed = 2'd0;
`else
`ifdef SYNTHESIS

// No Override for RTL Synthesis
//

assign wr_limit_muxed = 2'd0;

`else  

// RTL Simulation Plusarg Override


// VCS coverage off

reg wr_limit_override;
reg [1:0] wr_limit_override_value; 
assign wr_limit_muxed = wr_limit_override ? wr_limit_override_value : 2'd0;
`ifdef NV_ARCHPRO
event reinit;

initial begin
    $display("fifogen reinit initial block %m");
    -> reinit;
end
`endif

`ifdef NV_ARCHPRO
always @( reinit ) begin
`else 
initial begin
`endif
    wr_limit_override = 0;
    wr_limit_override_value = 0;  // to keep viva happy with dangles
    if ( $test$plusargs( "NV_NVDLA_SDP_CORE_Y_LUT_cmd_wr_limit" ) ) begin
        wr_limit_override = 1;
        $value$plusargs( "NV_NVDLA_SDP_CORE_Y_LUT_cmd_wr_limit=%d", wr_limit_override_value);
    end
end

// VCS coverage on


`endif 
`endif
`endif

//
// Histogram of fifo depth (from write side's perspective)
//
// NOTE: it will reference `SIMTOP.perfmon_enabled, so that
//       has to at least be defined, though not initialized.
//	 tbgen testbenches have it already and various
//	 ways to turn it on and off.
//
`ifdef PERFMON_HISTOGRAM 
// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
perfmon_histogram perfmon (
      .clk	( nvdla_core_clk ) 
    , .max      ( {30'd0, (wr_limit_reg == 2'd0) ? 2'd2 : wr_limit_reg} )
    , .curr	( {30'd0, cmd_fifo_wr_count} )
    );
`endif
`endif
// synopsys translate_on
`endif

// spyglass disable_block W164a W164b W116 W484 W504

`ifdef SPYGLASS
`else

`ifdef FV_ASSERT_ON
`else
// synopsys translate_off
`endif

`ifdef ASSERT_ON

`ifdef SPYGLASS
wire disable_assert_plusarg = 1'b0;
`else

`ifdef FV_ASSERT_ON
wire disable_assert_plusarg = 1'b0;
`else
wire disable_assert_plusarg = $test$plusargs("DISABLE_NESS_FLOW_ASSERTIONS");
`endif

`endif
wire assert_enabled = 1'b1 && !disable_assert_plusarg;


`endif

`ifdef FV_ASSERT_ON
`else
// synopsys translate_on
`endif

`ifdef ASSERT_ON

//synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
always @(assert_enabled) begin
    if ( assert_enabled === 1'b0 ) begin
        $display("Asserts are disabled for %m");
    end
end
`endif
`endif
//synopsys translate_on

`endif

`endif

// spyglass enable_block W164a W164b W116 W484 W504


//The NV_BLKBOX_SRC0 module is only present when the FIFOGEN_MODULE_SEARCH
// define is set.  This is to aid fifogen team search for fifogen fifo
// instance and module names in a given design.
`ifdef FIFOGEN_MODULE_SEARCH
NV_BLKBOX_SRC0 dummy_breadcrumb_fifogen_blkbox (.Y());
`endif

// spyglass enable_block W401 -- clock is not input to module

// synopsys dc_script_begin
//   set_boundary_optimization find(design, "NV_NVDLA_SDP_CORE_Y_LUT_cmd") true
// synopsys dc_script_end


endmodule // NV_NVDLA_SDP_CORE_Y_LUT_cmd

// 
// Flop-Based RAM 
//
module NV_NVDLA_SDP_CORE_Y_LUT_cmd_flopram_rwsa_2x70 (
      clk
    , pwrbus_ram_pd
    , di
    , we
    , wa
    , ra
    , dout
    );

input  clk;  // write clock
input [31 : 0] pwrbus_ram_pd;
input  [69:0] di;
input  we;
input  [0:0] wa;
input  [1:0] ra;
output [69:0] dout;

`ifndef FPGA
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_0 (.A(pwrbus_ram_pd[0]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_1 (.A(pwrbus_ram_pd[1]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_2 (.A(pwrbus_ram_pd[2]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_3 (.A(pwrbus_ram_pd[3]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_4 (.A(pwrbus_ram_pd[4]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_5 (.A(pwrbus_ram_pd[5]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_6 (.A(pwrbus_ram_pd[6]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_7 (.A(pwrbus_ram_pd[7]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_8 (.A(pwrbus_ram_pd[8]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_9 (.A(pwrbus_ram_pd[9]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_10 (.A(pwrbus_ram_pd[10]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_11 (.A(pwrbus_ram_pd[11]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_12 (.A(pwrbus_ram_pd[12]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_13 (.A(pwrbus_ram_pd[13]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_14 (.A(pwrbus_ram_pd[14]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_15 (.A(pwrbus_ram_pd[15]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_16 (.A(pwrbus_ram_pd[16]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_17 (.A(pwrbus_ram_pd[17]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_18 (.A(pwrbus_ram_pd[18]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_19 (.A(pwrbus_ram_pd[19]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_20 (.A(pwrbus_ram_pd[20]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_21 (.A(pwrbus_ram_pd[21]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_22 (.A(pwrbus_ram_pd[22]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_23 (.A(pwrbus_ram_pd[23]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_24 (.A(pwrbus_ram_pd[24]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_25 (.A(pwrbus_ram_pd[25]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_26 (.A(pwrbus_ram_pd[26]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_27 (.A(pwrbus_ram_pd[27]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_28 (.A(pwrbus_ram_pd[28]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_29 (.A(pwrbus_ram_pd[29]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_30 (.A(pwrbus_ram_pd[30]));
NV_BLKBOX_SINK UJ_BBOX2UNIT_UNUSED_pwrbus_31 (.A(pwrbus_ram_pd[31]));
`endif

`ifdef EMU


wire [69:0] dout_p;

// we use an emulation ram here to save flops on the emulation board
// so that the monstrous chip can fit :-)
//
reg [0:0] Wa0_vmw;
reg we0_vmw;
reg [69:0] Di0_vmw;

always @( posedge clk ) begin
    Wa0_vmw <=  wa;
    we0_vmw <=  we;
    Di0_vmw <=  di;
end

vmw_NV_NVDLA_SDP_CORE_Y_LUT_cmd_flopram_rwsa_2x70 emu_ram (
     .Wa0( Wa0_vmw ) 
   , .we0( we0_vmw ) 
   , .Di0( Di0_vmw )
   , .Ra0( ra[0:0] ) 
   , .Do0( dout_p )
   );

assign dout = (ra == 2) ? di : dout_p;

`else

reg [69:0] ram_ff0;
reg [69:0] ram_ff1;

always @( posedge clk ) begin
    if ( we && wa == 1'd0 ) begin
	ram_ff0 <=  di;
    end
    if ( we && wa == 1'd1 ) begin
	ram_ff1 <=  di;
    end
end

reg [69:0] dout;

always @(*) begin
    case( ra ) 
    2'd0:       dout = ram_ff0;
    2'd1:       dout = ram_ff1;
    2'd2:       dout = di;
    //VCS coverage off
    default:    dout = {70{`x_or_0}};
    //VCS coverage on
    endcase
end

`endif // EMU

endmodule // NV_NVDLA_SDP_CORE_Y_LUT_cmd_flopram_rwsa_2x70

// emulation model of flopram guts
//
`ifdef EMU


module vmw_NV_NVDLA_SDP_CORE_Y_LUT_cmd_flopram_rwsa_2x70 (
   Wa0, we0, Di0,
   Ra0, Do0
   );

input  [0:0] Wa0;
input            we0;
input  [69:0] Di0;
input  [0:0] Ra0;
output [69:0] Do0;

// Only visible during Spyglass to avoid blackboxes.
`ifdef SPYGLASS_FLOPRAM

assign Do0 = 70'd0;
wire dummy = 1'b0 | (|Wa0) | (|we0) | (|Di0) | (|Ra0);

`endif

// synopsys translate_off
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
reg [69:0] mem[1:0];

// expand mem for debug ease
`ifdef EMU_EXPAND_FLOPRAM_MEM
wire [69:0] Q0 = mem[0];
wire [69:0] Q1 = mem[1];
`endif

// asynchronous ram writes
always @(*) begin
  if ( we0 == 1'b1 ) begin
    #0.1;
    mem[Wa0] = Di0;
  end
end

assign Do0 = mem[Ra0];
`endif
`endif
// synopsys translate_on

// synopsys dc_script_begin
// synopsys dc_script_end

// g2c if { [find / -null_ok -subdesign vmw_NV_NVDLA_SDP_CORE_Y_LUT_cmd_flopram_rwsa_2x70] != {} } { set_attr preserve 1 [find / -subdesign vmw_NV_NVDLA_SDP_CORE_Y_LUT_cmd_flopram_rwsa_2x70] }
endmodule // vmw_NV_NVDLA_SDP_CORE_Y_LUT_cmd_flopram_rwsa_2x70

//vmw: Memory vmw_NV_NVDLA_SDP_CORE_Y_LUT_cmd_flopram_rwsa_2x70
//vmw: Address-size 1
//vmw: Data-size 70
//vmw: Sensitivity level 1
//vmw: Ports W R

//vmw: terminal we0 WriteEnable0
//vmw: terminal Wa0 address0
//vmw: terminal Di0[69:0] data0[69:0]
//vmw: 
//vmw: terminal Ra0 address1
//vmw: terminal Do0[69:0] data1[69:0]
//vmw: 

//qt: CELL vmw_NV_NVDLA_SDP_CORE_Y_LUT_cmd_flopram_rwsa_2x70
//qt: TERMINAL we0 TYPE=WE POLARITY=H PORT=1
//qt: TERMINAL Wa0[%d] TYPE=ADDRESS DIR=W BIT=%1 PORT=1
//qt: TERMINAL Di0[%d] TYPE=DATA DIR=I BIT=%1 PORT=1
//qt: 
//qt: TERMINAL Ra0[%d] TYPE=ADDRESS DIR=R BIT=%1 PORT=1
//qt: TERMINAL Do0[%d] TYPE=DATA DIR=O BIT=%1 PORT=1
//qt:

`endif // EMU





#endif
