// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_shared_buffer.v

#include "NV_NVDLA_CDMA_define.h"

module NV_NVDLA_CDMA_shared_buffer (
   nvdla_core_clk      //|< i
  ,nvdla_core_rstn     //|< i
  ,pwrbus_ram_pd       //|< i
  ,dc2sbuf_p0_wr_en    //|< i
  ,dc2sbuf_p0_wr_addr  //|< i
  ,dc2sbuf_p0_wr_data  //|< i
  ,dc2sbuf_p1_wr_en    //|< i
  ,dc2sbuf_p1_wr_addr  //|< i
  ,dc2sbuf_p1_wr_data  //|< i
#ifdef NVDLA_WINOGRAD_ENABLE
  ,wg2sbuf_p0_wr_en    //|< i
  ,wg2sbuf_p0_wr_addr  //|< i
  ,wg2sbuf_p0_wr_data  //|< i
  ,wg2sbuf_p1_wr_en    //|< i
  ,wg2sbuf_p1_wr_addr  //|< i
  ,wg2sbuf_p1_wr_data  //|< i
#endif
  ,img2sbuf_p0_wr_en   //|< i
  ,img2sbuf_p0_wr_addr //|< i
  ,img2sbuf_p0_wr_data //|< i
  ,img2sbuf_p1_wr_en   //|< i
  ,img2sbuf_p1_wr_addr //|< i
  ,img2sbuf_p1_wr_data //|< i
  ,dc2sbuf_p0_rd_en    //|< i
  ,dc2sbuf_p0_rd_addr  //|< i
  ,dc2sbuf_p0_rd_data  //|> o
  ,dc2sbuf_p1_rd_en    //|< i
  ,dc2sbuf_p1_rd_addr  //|< i
  ,dc2sbuf_p1_rd_data  //|> o
#ifdef NVDLA_WINOGRAD_ENABLE
  ,wg2sbuf_p0_rd_en    //|< i
  ,wg2sbuf_p0_rd_addr  //|< i
  ,wg2sbuf_p0_rd_data  //|> o
  ,wg2sbuf_p1_rd_en    //|< i
  ,wg2sbuf_p1_rd_addr  //|< i
  ,wg2sbuf_p1_rd_data  //|> o
#endif
  ,img2sbuf_p0_rd_en   //|< i
  ,img2sbuf_p0_rd_addr //|< i
  ,img2sbuf_p0_rd_data //|> o
  ,img2sbuf_p1_rd_en   //|< i
  ,img2sbuf_p1_rd_addr //|< i
  ,img2sbuf_p1_rd_data //|> o
  );

//
// NV_NVDLA_CDMA_shared_buffer_ports.v
//
input  nvdla_core_clk;
input  nvdla_core_rstn;

input [31:0] pwrbus_ram_pd;

input         dc2sbuf_p0_wr_en;    /* data valid */
input   [7:0] dc2sbuf_p0_wr_addr;
input [NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE-1:0] dc2sbuf_p0_wr_data;

input         dc2sbuf_p1_wr_en;    /* data valid */
input   [7:0] dc2sbuf_p1_wr_addr;
input [NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE-1:0] dc2sbuf_p1_wr_data;

#ifdef NVDLA_WINOGRAD_ENABLE
input         wg2sbuf_p0_wr_en;    /* data valid */
input   [7:0] wg2sbuf_p0_wr_addr;
input [NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE-1:0] wg2sbuf_p0_wr_data;

input         wg2sbuf_p1_wr_en;    /* data valid */
input   [7:0] wg2sbuf_p1_wr_addr;
input [NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE-1:0] wg2sbuf_p1_wr_data;
#endif

input         img2sbuf_p0_wr_en;    /* data valid */
input   [7:0] img2sbuf_p0_wr_addr;
input [NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE-1:0] img2sbuf_p0_wr_data;

input         img2sbuf_p1_wr_en;    /* data valid */
input   [7:0] img2sbuf_p1_wr_addr;
input [NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE-1:0] img2sbuf_p1_wr_data;

input       dc2sbuf_p0_rd_en;    /* data valid */
input [7:0] dc2sbuf_p0_rd_addr;
output [NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE-1:0] dc2sbuf_p0_rd_data;

input       dc2sbuf_p1_rd_en;    /* data valid */
input [7:0] dc2sbuf_p1_rd_addr;
output [NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE-1:0] dc2sbuf_p1_rd_data;

#ifdef NVDLA_WINOGRAD_ENABLE
input       wg2sbuf_p0_rd_en;    /* data valid */
input [7:0] wg2sbuf_p0_rd_addr;
output [NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE-1:0] wg2sbuf_p0_rd_data;

input       wg2sbuf_p1_rd_en;    /* data valid */
input [7:0] wg2sbuf_p1_rd_addr;
output [NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE-1:0] wg2sbuf_p1_rd_data;
#endif

input       img2sbuf_p0_rd_en;    /* data valid */
input [7:0] img2sbuf_p0_rd_addr;
output [NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE-1:0] img2sbuf_p0_rd_data;

input       img2sbuf_p1_rd_en;    /* data valid */
input [7:0] img2sbuf_p1_rd_addr;
output [NVDLA_MEMORY_ATOMIC_SIZE*NVDLA_BPE-1:0] img2sbuf_p1_rd_data;

//////////////
// REGS     //
//////////////
//: my $i;
//: my $j;
//: my $k;
//: my $serial;
//: my $b0;
//: my $val;
//: my @input_list;
//: my $def_wino = SBUF_WINOGRAD;
//: if($def_wino) {
//:     @input_list = ("dc", "wg", "img");
//: } else {
//:     @input_list = ("dc", "img");
//: }
//: my @input_list_1 = ("dc", "img");
//: my $name;
//: for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:     $serial = sprintf("%02d", $j);
//:     for($k = 0; $k < 2; $k ++) {
//:         print qq(reg          sbuf_p${k}_re_${serial}_norm_d1;\n);
//:     }
//: }
//: $b0 = CDMA_SBUF_SDATA_BITS - 1;
//: for($k = 0; $k < 2; $k ++) {
//:     print qq(reg  [${b0}:0] sbuf_p${k}_rdat_d2;\n);
//:     print qq(reg            sbuf_p${k}_rd_en_d1;\n);
//: }
//: if($def_wino) {
//:     for($j = 0; $j < CDMA_SBUF_NUMBER/4; $j ++) {
//:         $val = sprintf("%02d", $j);
//:         for($k = 0; $k < 2; $k ++) {
//:             print qq(reg          sbuf_p${k}_re_${val}_wg_d1;\n);
//:         }
//:     }
//:     for($k = 0; $k < 2; $k ++) {
//:         for($i = 0; $i < 4; $i ++) {
//:             print qq(reg          sbuf_p${k}_wg_sel_q${i}_d1;\n);
//:         }
//:     }
//: }
//: print qq (\n\n);

//////////////
// WIRES    //
//////////////
//: my $i;
//: my $j;
//: my $k;
//: my $serial;
//: my $b0;
//: my $val;
//: my @input_list;
//: my $def_wino = SBUF_WINOGRAD;
//: if($def_wino) {
//:     @input_list = ("dc", "wg", "img");
//: } else {
//:     @input_list = ("dc", "img");
//: }
//: my @input_list_1 = ("dc", "img");
//: my $name;
//: $b0 = int(log(CDMA_SBUF_NUMBER)/log(2)) - 1;
//: for($i = 0; $i < @input_list; $i ++) {
//:     $name = $input_list[$i];
//:     print qq (
//:         wire   [${b0}:0] ${name}2sbuf_p0_wr_bsel;
//:         wire   [${b0}:0] ${name}2sbuf_p1_wr_bsel;\n);
//: }
//: for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:     $serial = sprintf("%02d", $j);
//:     for($i = 0; $i < @input_list; $i ++) {
//:         for($k = 0; $k < 2; $k ++) {
//:             $name = $input_list[$i];
//:             print qq (wire         ${name}2sbuf_p${k}_wr_sel_${serial};\n);
//:         }
//:     }
//: }
//: for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:     $serial = sprintf("%02d", $j);
//:     print qq (wire         sbuf_we_${serial};\n);
//: }
//: for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:     $serial = sprintf("%02d", $j);
//:     $b0 = int(log(CDMA_SBUF_DEPTH)/log(2)) - int(log(CDMA_SBUF_NUMBER)/log(2)) - 1;
//:     print qq (wire   [${b0}:0] sbuf_wa_${serial};\n);
//: }
//: for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:     $serial = sprintf("%02d", $j);
//:     $b0 = CDMA_SBUF_SDATA_BITS - 1;
//:     print qq (wire [${b0}:0] sbuf_wdat_${serial};\n);
//: }
//: $b0 = int(log(CDMA_SBUF_NUMBER)/log(2)) - 1;
//: for($i = 0; $i < @input_list_1; $i ++) {
//:     $name = $input_list_1[$i];
//:     print qq (
//: wire   [${b0}:0] ${name}2sbuf_p0_rd_bsel;
//: wire   [${b0}:0] ${name}2sbuf_p1_rd_bsel;\n);
//: }
//: for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:     $serial = sprintf("%02d", $j);
//:     for($i = 0; $i < @input_list_1; $i ++) {
//:         for($k = 0; $k < 2; $k ++) {
//:             $name = $input_list_1[$i];
//:             print qq (wire         ${name}2sbuf_p${k}_rd_sel_${serial};\n);
//:         }
//:     }
//: }
//: for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:     for($k = 0; $k < 2; $k ++) {
//:         $serial = sprintf("%02d", $j);
//:         print qq (wire         sbuf_p${k}_re_${serial};\n);
//:     }
//: }
//: for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:     $serial = sprintf("%02d", $j);
//:     print qq (wire         sbuf_re_${serial};\n);
//: }
//: $b0 = CDMA_SBUF_SDATA_BITS - 1;
//: for($i = 0; $i < CDMA_SBUF_NUMBER; $i ++) {
//:     $serial = sprintf("%02d", $i);
//:     print qq (wire [${b0}:0] sbuf_rdat_${serial};\n);
//: }
//: $b0 = int(log(CDMA_SBUF_DEPTH)/log(2)) - int(log(CDMA_SBUF_NUMBER)/log(2)) - 1;
//: for($i = 0; $i < @input_list_1; $i ++) {
//:     $name = $input_list_1[$i];
//:     print qq (
//: wire   [${b0}:0] ${name}2sbuf_p0_rd_esel;
//: wire   [${b0}:0] ${name}2sbuf_p1_rd_esel;\n);
//: }
//: for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:     $serial = sprintf("%02d", $j);
//:     $b0 = int(log(CDMA_SBUF_DEPTH)/log(2)) - int(log(CDMA_SBUF_NUMBER)/log(2)) - 1;
//:     print qq (wire   [${b0}:0] sbuf_ra_${serial};\n);
//: }
//: $b0 = CDMA_SBUF_SDATA_BITS - 1;
//: for($k = 0; $k < 2; $k ++) {
//:     print qq (wire [${b0}:0] sbuf_p${k}_norm_rdat;\n);
//: }
//: for($k = 0; $k < 2; $k ++) {
//:     print qq (wire [${b0}:0] sbuf_p${k}_rdat;\n);
//: }
//: if($def_wino) {
//:     $b0 = int(log(CDMA_SBUF_NUMBER)/log(2)) - 3;
//:     print qq (
//:     wire   [${b0}:0] wg2sbuf_p0_rd_bsel;
//:     wire   [${b0}:0] wg2sbuf_p1_rd_bsel;\n);
//:     
//:     for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:         $serial = sprintf("%02d", $j);
//:         $i = int($j/4);
//:         for($k = 0; $k < 2; $k ++) {
//:             print qq (wire         wg2sbuf_p${k}_rd_sel_${serial};\n);
//:         }
//:     }
//:     
//:     $b0 = int(log(CDMA_SBUF_DEPTH)/log(2)) - int(log(CDMA_SBUF_NUMBER)/log(2)) - 1;
//:     print qq (
//:     wire   [${b0}:0] wg2sbuf_p0_rd_esel;
//:     wire   [${b0}:0] wg2sbuf_p1_rd_esel;\n);
//:     $b0 = CDMA_SBUF_SDATA_BITS - 1;
//:     for($k = 0; $k < 2; $k ++) {
//:         for($i = 0; $i < 4; $i ++) {
//:             print qq (wire [${b0}:0] sbuf_p${k}_wg_rdat_src_${i};\n);
//:         }
//:     }
//:     for($k = 0; $k < 2; $k ++) {
//:         print qq(wire [${b0}:0] sbuf_p${k}_wg_rdat;\n);
//:     }
//:     for($k = 0; $k < 2; $k ++) {
//:         for($i = 0; $i < 4; $i ++) {
//:             print qq(wire         sbuf_p${k}_wg_sel_q${i};\n);
//:         }
//:     }
//: }

////////////////////////////////////////////////////////////////////////
// Input port to RAMS                                                 //
////////////////////////////////////////////////////////////////////////

//: my $i;
//: my $j;
//: my $k;
//: my $serial;
//: my $b1;
//: my $b0;
//: my $bits;
//: my @input_list;
//: my $def_wino = SBUF_WINOGRAD;
//: if($def_wino) {
//:     @input_list = ("dc", "wg", "img");
//: } else {
//:     @input_list = ("dc", "img");
//: }
//: my $name;
//: 
//: $b1 = int(log(CDMA_SBUF_DEPTH)/log(2)) - 1;
//: $b0 = int(log(CDMA_SBUF_DEPTH)/log(2)) - int(log(CDMA_SBUF_NUMBER)/log(2));
//: for($i = 0; $i < @input_list; $i ++) {
//:     $name = $input_list[$i];
//:     print qq (
//: assign ${name}2sbuf_p0_wr_bsel = ${name}2sbuf_p0_wr_addr[${b1}:${b0}];
//: assign ${name}2sbuf_p1_wr_bsel = ${name}2sbuf_p1_wr_addr[${b1}:${b0}];\n);
//: }
//: print qq (\n\n);
//: 
//: for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:     $serial = sprintf("%02d", $j);
//:     $bits = int(log(CDMA_SBUF_NUMBER)/log(2));
//:     for($i = 0; $i < @input_list; $i ++) {
//:         for($k = 0; $k < 2; $k ++) {
//:             $name = $input_list[$i];
//:             print qq (assign ${name}2sbuf_p${k}_wr_sel_${serial} = (${name}2sbuf_p${k}_wr_bsel == ${bits}'d${j}) & ${name}2sbuf_p${k}_wr_en;\n);
//:         }
//:     }
//: }
//: for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:     $serial = sprintf("%02d", $j);
//:     print qq (assign sbuf_we_${serial} = );
//:     for($i = 0; $i < @input_list; $i ++) {
//:         for($k = 0; $k < 2; $k ++) {
//:             $name = $input_list[$i];
//:             print qq (${name}2sbuf_p${k}_wr_sel_${serial});
//:             if($i != @input_list - 1 || $k != 1) {
//:                 print qq ( |\n                    );
//:             } else {
//:                 print qq (;\n\n);
//:             }
//:         }
//:     }
//:     print qq (\n\n);
//: }
//: 
//: for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:     $serial = sprintf("%02d", $j);
//:     $bits = int(log(CDMA_SBUF_DEPTH)/log(2)) - int(log(CDMA_SBUF_NUMBER)/log(2));
//:     $b1 = int(log(CDMA_SBUF_DEPTH)/log(2)) - int(log(CDMA_SBUF_NUMBER)/log(2)) - 1;
//:     $b0 = 0;
//:     print qq (assign sbuf_wa_${serial} = );
//:     for($i = 0; $i < @input_list; $i ++) {
//:         for($k = 0; $k < 2; $k ++) {
//:             $name = $input_list[$i];
//:             print qq (({${bits}{${name}2sbuf_p${k}_wr_sel_${serial}}} & ${name}2sbuf_p${k}_wr_addr[${b1}:${b0}]));
//:             if($i != @input_list - 1 || $k != 1) {
//:                 print qq ( |\n                    );
//:             } else {
//:                 print qq (;\n\n);
//:             }
//:         }
//:     }
//:     print qq (\n\n);
//: }
//: for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:     $serial = sprintf("%02d", $j);
//:     $bits = CDMA_SBUF_SDATA_BITS;
//:     print qq (assign sbuf_wdat_${serial} = );
//:     for($i = 0; $i < @input_list; $i ++) {
//:         for($k = 0; $k < 2; $k ++) {
//:             $name = $input_list[$i];
//:             print qq (({${bits}{${name}2sbuf_p${k}_wr_sel_${serial}}} & ${name}2sbuf_p${k}_wr_data));
//:             if($i != @input_list - 1 || $k != 1) {
//:                 print qq ( |\n                      );
//:             } else {
//:                 print qq (;\n\n);
//:             }
//:         }
//:     }
//:     print qq (\n\n);
//: }

////////////////////////////////////////////////////////////////////////\n";
// Instance 16 256bx8 RAMs as local shared buffers                    //\n";
////////////////////////////////////////////////////////////////////////\n";

//: my $i;
//: my $serial;
//: my $bits;
//: my $depth;
//: $bits = CDMA_SBUF_SDATA_BITS;
//: $depth = CDMA_SBUF_DEPTH / CDMA_SBUF_NUMBER;
//: for($i = 0; $i < CDMA_SBUF_NUMBER; $i ++) {
//:     $serial = sprintf("%02d", $i);
//:     print qq {
//: nv_ram_rws_${depth}x${bits} u_shared_buffer_${serial} (
//:    .clk           (nvdla_core_clk)  //|< i
//:   ,.ra            (sbuf_ra_${serial})      //|< r
//:   ,.re            (sbuf_re_${serial})      //|< r
//:   ,.dout          (sbuf_rdat_${serial})    //|> w
//:   ,.wa            (sbuf_wa_${serial})      //|< r
//:   ,.we            (sbuf_we_${serial})      //|< r
//:   ,.di            (sbuf_wdat_${serial})    //|< r
//:   ,.pwrbus_ram_pd (pwrbus_ram_pd)   //|< i
//:   );\n\n};
//: }

////////////////////////////////////////////////////////////////////////\n";
// RAMs to output port: stage 1                                       //\n";
////////////////////////////////////////////////////////////////////////\n";

//: my $i;
//: my $j;
//: my $k;
//: my $serial;
//: my @input_list;
//: my $def_wino = SBUF_WINOGRAD;
//: if($def_wino) {
//:     @input_list = ("dc", "wg", "img");
//: } else {
//:     @input_list = ("dc", "img");
//: }
//: my @input_list_1 = ("dc", "img");
//: my $name;
//: my $b1;
//: my $b0;
//: my $bits;
//: 
//: $b1 = int(log(CDMA_SBUF_DEPTH)/log(2)) - 1;
//: $b0 = int(log(CDMA_SBUF_DEPTH)/log(2)) - int(log(CDMA_SBUF_NUMBER)/log(2));
//: for($i = 0; $i < @input_list_1; $i ++) {
//:     $name = $input_list_1[$i];
//:     print qq (
//: assign ${name}2sbuf_p0_rd_bsel = ${name}2sbuf_p0_rd_addr[${b1}:${b0}];
//: assign ${name}2sbuf_p1_rd_bsel = ${name}2sbuf_p1_rd_addr[${b1}:${b0}];\n);
//: }
//: 
//: if($def_wino) {
//:     $b1 = int(log(CDMA_SBUF_DEPTH)/log(2)) - 1;
//:     $b0 = int(log(CDMA_SBUF_DEPTH)/log(2)) - int(log(CDMA_SBUF_NUMBER)/log(2)) + 2;
//:     print qq (
//:     assign wg2sbuf_p0_rd_bsel = wg2sbuf_p0_rd_addr[${b1}:${b0}];
//:     assign wg2sbuf_p1_rd_bsel = wg2sbuf_p1_rd_addr[${b1}:${b0}];\n);
//:     print qq (\n\n);
//: 
//: }
//: for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:     $serial = sprintf("%02d", $j);
//:     $bits = int(log(CDMA_SBUF_NUMBER)/log(2));
//:     for($i = 0; $i < @input_list_1; $i ++) {
//:         for($k = 0; $k < 2; $k ++) {
//:             $name = $input_list_1[$i];
//:             print qq (assign ${name}2sbuf_p${k}_rd_sel_${serial} = (${name}2sbuf_p${k}_rd_bsel == ${bits}'d${j}) & ${name}2sbuf_p${k}_rd_en;\n);
//:         }
//:     }
//: }
//: print qq (\n\n);
//: 
//: if($def_wino) {
//:     for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:         $serial = sprintf("%02d", $j);
//:         $bits = int(log(CDMA_SBUF_NUMBER)/log(2)) - 2;
//:         $i = int($j/4);
//:         for($k = 0; $k < 2; $k ++) {
//:             print qq (assign wg2sbuf_p${k}_rd_sel_${serial} = (wg2sbuf_p${k}_rd_bsel == ${bits}'d${i}) & wg2sbuf_p${k}_rd_en;\n);
//:         }
//:     }
//:     print qq (\n\n);
//: 
//: }
//: for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:     for($k = 0; $k < 2; $k ++) {
//:         $serial = sprintf("%02d", $j);
//:         print qq (assign sbuf_p${k}_re_${serial} = );
//:         for($i = 0; $i < @input_list; $i ++) {
//:             $name = $input_list[$i];
//:             print qq (${name}2sbuf_p${k}_rd_sel_${serial});
//:             if($i != @input_list - 1) {
//:                 print qq ( | );
//:             } else {
//:                 print qq (;\n);
//:             }
//:         }
//:     }
//: }
//: print qq (\n\n);
//: 
//: for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:     $serial = sprintf("%02d", $j);
//:     print qq (assign sbuf_re_${serial} = sbuf_p0_re_${serial} | sbuf_p1_re_${serial};\n);
//: }
//: print qq (\n\n);
//: 
//: $b1 = int(log(CDMA_SBUF_DEPTH)/log(2)) - int(log(CDMA_SBUF_NUMBER)/log(2)) - 1;
//: $b0 = 0;
//: for($i = 0; $i < @input_list_1; $i ++) {
//:     $name = $input_list_1[$i];
//:     print qq (
//: assign ${name}2sbuf_p0_rd_esel = ${name}2sbuf_p0_rd_addr[${b1}:${b0}];
//: assign ${name}2sbuf_p1_rd_esel = ${name}2sbuf_p1_rd_addr[${b1}:${b0}];\n);
//: }
//: 
//: if($def_wino) {
//:     $b1 = int(log(CDMA_SBUF_DEPTH)/log(2)) - int(log(CDMA_SBUF_NUMBER)/log(2)) + 1;
//:     $b0 = 2;
//:     print qq (
//:     assign wg2sbuf_p0_rd_esel = wg2sbuf_p0_rd_addr[${b1}:${b0}];
//:     assign wg2sbuf_p1_rd_esel = wg2sbuf_p1_rd_addr[${b1}:${b0}];\n);
//:     print qq (\n\n);
//: 
//: }
//: for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:     $serial = sprintf("%02d", $j);
//:     $bits = int(log(CDMA_SBUF_DEPTH)/log(2)) - int(log(CDMA_SBUF_NUMBER)/log(2));
//:     print qq (assign sbuf_ra_${serial} = );
//:     for($i = 0; $i < @input_list; $i ++) {
//:         for($k = 0; $k < 2; $k ++) {
//:             $name = $input_list[$i];
//:             print qq (({${bits}{${name}2sbuf_p${k}_rd_sel_${serial}}} & ${name}2sbuf_p${k}_rd_esel));
//:             if($i != @input_list - 1 || $k != 1) {
//:                 print qq ( |\n                    );
//:             } else {
//:                 print qq (;\n\n);
//:             }
//:         }
//:     }
//: }
//: print qq (\n\n);
//: 
//: if($def_wino) {
//:     for($k = 0; $k < 2; $k ++) {
//:         for($i = 0; $i < 4; $i ++) {
//:             print qq(assign sbuf_p${k}_wg_sel_q${i} = (wg2sbuf_p${k}_rd_addr[1:0] == 2'h${i}) & wg2sbuf_p${k}_rd_en;\n);
//:         }
//:     }
//:     print qq (\n\n);
//: }

////////////////////////////////////////////////////////////////////////\n";
// RAMs to output port: stage1 register                               //\n";
////////////////////////////////////////////////////////////////////////\n";
//: my $i;
//: my $j;
//: my $k;
//: my $serial;
//: my $val;
//: my @input_list;
//: my $def_wino = SBUF_WINOGRAD;
//: if($def_wino) {
//:     @input_list = ("dc", "wg", "img");
//: } else {
//:     @input_list = ("dc", "img");
//: }
//: my $name;
//: 
//: for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:     $serial = sprintf("%02d", $j);
//:     for($k = 0; $k < 2; $k ++) {
//:         if($def_wino) {
//:             &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"sbuf_p${k}_re_${serial} & ~wg2sbuf_p${k}_rd_en\" -q sbuf_p${k}_re_${serial}_norm_d1");
//:         } else {
//:             &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"sbuf_p${k}_re_${serial}\" -q sbuf_p${k}_re_${serial}_norm_d1");
//:         }
//:     }
//: }
//: print qq (\n\n);
//: 
//: if($def_wino) {
//:     for($j = 0; $j < CDMA_SBUF_NUMBER/4; $j ++) {
//:         $val = sprintf("%02d", $j);
//:         $serial = sprintf("%02d", $j*4);
//:         for($k = 0; $k < 2; $k ++) {
//:             &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"sbuf_p${k}_re_${serial} & wg2sbuf_p${k}_rd_en\" -q sbuf_p${k}_re_${val}_wg_d1");
//:         }
//:     }
//:     print qq (\n\n);
//:     
//:     for($k = 0; $k < 2; $k ++) {
//:         for($i = 0; $i < 4; $i ++) {
//:             &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"sbuf_p${k}_wg_sel_q${i}\" -q sbuf_p${k}_wg_sel_q${i}_d1");
//:         }
//:     }
//:     print qq (\n\n);
//: 
//: }
//: if($def_wino) {
//:     &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"dc2sbuf_p0_rd_en | wg2sbuf_p0_rd_en | img2sbuf_p0_rd_en\" -q sbuf_p0_rd_en_d1");
//:     &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"dc2sbuf_p1_rd_en | wg2sbuf_p1_rd_en | img2sbuf_p1_rd_en\" -q sbuf_p1_rd_en_d1");
//: } else {
//:     &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"dc2sbuf_p0_rd_en | img2sbuf_p0_rd_en\" -q sbuf_p0_rd_en_d1");
//:     &eperl::flop("-nodeclare   -rval \"1'b0\"   -d \"dc2sbuf_p1_rd_en | img2sbuf_p1_rd_en\" -q sbuf_p1_rd_en_d1");
//: }
//: print qq (\n\n);


////////////////////////////////////////////////////////////////////////\n";
// RAMs to output port: stage2                                        //\n";
////////////////////////////////////////////////////////////////////////\n";
//: my $i;
//: my $j;
//: my $k;
//: my $b1;
//: my $b0;
//: my $val;
//: my $serial;
//: my $def_wino = SBUF_WINOGRAD;
//: 
//: for($k = 0; $k < 2; $k ++) {
//:     print qq (assign sbuf_p${k}_norm_rdat = );
//:     for($j = 0; $j < CDMA_SBUF_NUMBER; $j ++) {
//:         $serial = sprintf("%02d", $j);
//:         print qq (({CDMA_SBUF_SDATA_BITS{sbuf_p${k}_re_${serial}_norm_d1}} & sbuf_rdat_${serial}));
//:         if($j != CDMA_SBUF_NUMBER - 1) {
//:             print qq ( |\n                           );
//:         } else {
//:             print qq (;\n);
//:         }
//:     }
//:     print qq (\n\n);
//: }
//: print qq (\n\n);
//: 
//: if($def_wino) {
//:     for($k = 0; $k < 2; $k ++) {
//:         for($i = 0; $i < 4; $i ++) {
//:             print qq (assign sbuf_p${k}_wg_rdat_src_${i} = );
//:             for($j = 0; $j < CDMA_SBUF_NUMBER/4; $j ++) {
//:                 $val = sprintf("%02d", $j);
//:                 $serial = sprintf("%02d", $j*4 + $i);
//:                 print qq (({CDMA_SBUF_SDATA_BITS{sbuf_p${k}_re_${val}_wg_d1}} & sbuf_rdat_${serial}));
//:                 if($j != CDMA_SBUF_NUMBER/4 - 1) {
//:                     print qq ( |\n                               );
//:                 } else {
//:                     print qq (;\n);
//:                 }
//:             }
//:             print qq (\n\n);
//:         }
//:     }
//:     print qq (\n\n);
//:     
//:     for($k = 0; $k < 2; $k ++) {
//:         print qq(assign sbuf_p${k}_wg_rdat = );
//:         for($i = 0; $i < 4; $i ++) {
//:             $b1 = int(CDMA_SBUF_SDATA_BITS/4 * ($i + 1) - 1);
//:             $b0 = int(CDMA_SBUF_SDATA_BITS/4 * $i);
//:             print qq(\({CDMA_SBUF_SDATA_BITS{sbuf_p${k}_wg_sel_q${i}_d1}} & \{);
//:             for($j = 3; $j >= 0; $j --) {
//:                 print qq(sbuf_p${k}_wg_rdat_src_${j}[${b1}:${b0}]);
//:                 if($j != 0) {
//:                     print qq(, );
//:                 } else {
//:                     print qq(\}\));
//:                 }
//:             }
//:             if($i != 3) {
//:                 print qq( |\n                         );
//:             } else {
//:                 print qq(;\n);
//:             }
//:         }
//:         print qq(\n);
//:     }
//:     print qq (\n\n);
//:     
//:     for($k = 0; $k < 2; $k ++) {
//:         print qq (assign sbuf_p${k}_rdat = sbuf_p${k}_norm_rdat | sbuf_p${k}_wg_rdat;\n);
//:     }
//: } else {
//:     for($k = 0; $k < 2; $k ++) {
//:         print qq (assign sbuf_p${k}_rdat = sbuf_p${k}_norm_rdat;\n);
//:     }
//: }
//: print qq (\n\n);

////////////////////////////////////////////////////////////////////////\n";
// RAMs to output port: stage2 register                               //\n";
////////////////////////////////////////////////////////////////////////\n";
//: my $k;
//: for($k = 0; $k < 2; $k ++) {
//:     &eperl::flop("-nodeclare  -norst -en \"sbuf_p${k}_rd_en_d1\" -d \"sbuf_p${k}_rdat\" -q sbuf_p${k}_rdat_d2");
//: }
//: print qq (\n\n);

////////////////////////////////////////////////////////////////////////\n";
// RAMs to output port: connect output data signal                    //\n";
////////////////////////////////////////////////////////////////////////\n";
//: my $i;
//: my $k;
//: my @input_list;
//: my $def_wino = SBUF_WINOGRAD;
//: if($def_wino) {
//:     @input_list = ("dc", "wg", "img");
//: } else {
//:     @input_list = ("dc", "img");
//: }
//: my @input_list_1 = ("dc", "img");
//: my $name;
//: for($k = 0; $k < 2; $k ++) {
//:     for($i = 0; $i < @input_list; $i ++) {
//:         $name = $input_list[$i];
//:         print qq (assign ${name}2sbuf_p${k}_rd_data = sbuf_p${k}_rdat_d2;\n);
//:     }
//: }


////////////////////////////////////////////////////////////////////////
//  Assertion                                                         //
////////////////////////////////////////////////////////////////////////
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 

    #ifdef NVDLA_WINOGRAD_ENABLE
  nv_assert_never #(0,0,"multiple write to shared buffer")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, ((dc2sbuf_p0_wr_en | dc2sbuf_p1_wr_en) & (wg2sbuf_p0_wr_en | wg2sbuf_p1_wr_en)) |                                                              ((dc2sbuf_p0_wr_en | dc2sbuf_p1_wr_en) & (img2sbuf_p0_wr_en | img2sbuf_p1_wr_en)) |                                                              ((wg2sbuf_p0_wr_en | wg2sbuf_p1_wr_en) & (img2sbuf_p0_wr_en | img2sbuf_p1_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"multiple read to shared buffer")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, ((dc2sbuf_p0_rd_en | dc2sbuf_p1_rd_en) & (wg2sbuf_p0_rd_en | wg2sbuf_p1_rd_en)) |                                                             ((dc2sbuf_p0_rd_en | dc2sbuf_p1_rd_en) & (img2sbuf_p0_rd_en | img2sbuf_p1_rd_en)) |                                                             ((wg2sbuf_p0_rd_en | wg2sbuf_p1_rd_en) & (img2sbuf_p0_rd_en | img2sbuf_p1_rd_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"dc write same buffer")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, (dc2sbuf_p0_wr_en & dc2sbuf_p1_wr_en & (dc2sbuf_p0_wr_bsel == dc2sbuf_p1_wr_bsel))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"wg write same buffer")      zzz_assert_never_4x (nvdla_core_clk, `ASSERT_RESET, (wg2sbuf_p0_wr_en & wg2sbuf_p1_wr_en & (wg2sbuf_p0_wr_bsel == wg2sbuf_p1_wr_bsel))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"img write same buffer")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, (img2sbuf_p0_wr_en & img2sbuf_p1_wr_en & (img2sbuf_p0_wr_bsel == img2sbuf_p1_wr_bsel))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"dc read same buffer")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, (dc2sbuf_p0_rd_en & dc2sbuf_p1_rd_en & (dc2sbuf_p0_rd_bsel == dc2sbuf_p1_rd_bsel))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"wg read same buffer")      zzz_assert_never_7x (nvdla_core_clk, `ASSERT_RESET, (wg2sbuf_p0_rd_en & wg2sbuf_p1_rd_en & (wg2sbuf_p0_rd_bsel == wg2sbuf_p1_rd_bsel))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"img read same buffer")      zzz_assert_never_8x (nvdla_core_clk, `ASSERT_RESET, (img2sbuf_p0_rd_en & img2sbuf_p1_rd_en & (img2sbuf_p0_rd_bsel == img2sbuf_p1_rd_bsel))); // spyglass disable W504 SelfDeterminedExpr-ML 
    #else
  nv_assert_never #(0,0,"multiple write to shared buffer")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, ((dc2sbuf_p0_wr_en | dc2sbuf_p1_wr_en) & (img2sbuf_p0_wr_en | img2sbuf_p1_wr_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"multiple read to shared buffer")      zzz_assert_never_2x (nvdla_core_clk, `ASSERT_RESET, ((dc2sbuf_p0_rd_en | dc2sbuf_p1_rd_en) & (img2sbuf_p0_rd_en | img2sbuf_p1_rd_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"dc write same buffer")      zzz_assert_never_3x (nvdla_core_clk, `ASSERT_RESET, (dc2sbuf_p0_wr_en & dc2sbuf_p1_wr_en & (dc2sbuf_p0_wr_bsel == dc2sbuf_p1_wr_bsel))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"img write same buffer")      zzz_assert_never_5x (nvdla_core_clk, `ASSERT_RESET, (img2sbuf_p0_wr_en & img2sbuf_p1_wr_en & (img2sbuf_p0_wr_bsel == img2sbuf_p1_wr_bsel))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"dc read same buffer")      zzz_assert_never_6x (nvdla_core_clk, `ASSERT_RESET, (dc2sbuf_p0_rd_en & dc2sbuf_p1_rd_en & (dc2sbuf_p0_rd_bsel == dc2sbuf_p1_rd_bsel))); // spyglass disable W504 SelfDeterminedExpr-ML 
  nv_assert_never #(0,0,"img read same buffer")      zzz_assert_never_8x (nvdla_core_clk, `ASSERT_RESET, (img2sbuf_p0_rd_en & img2sbuf_p1_rd_en & (img2sbuf_p0_rd_bsel == img2sbuf_p1_rd_bsel))); // spyglass disable W504 SelfDeterminedExpr-ML 
    #endif
//for(my $i = 0; $i < CDMA_SBUF_NUMBER; $i ++) {
//    my $j = sprintf("%02d", $i);
//    my $k = $i + 9;
//    vprint qq {
//        nv_assert_never #(0,0,"Error! shared ram ${j} read and write hazard!") zzz_assert_never_${k} (nvdla_core_clk, `ASSERT_RESET, (sbuf_re_${j} & sbuf_we_${j} & (sbuf_ra_${j} == sbuf_wa_${j}))); \/\/ spyglass disable W504 SelfDeterminedExpr-ML};
//}

  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

endmodule // NV_NVDLA_CDMA_shared_buffer


