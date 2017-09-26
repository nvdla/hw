// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: HLS_fp32_add.v

module FP32_ADD_mgc_in_wire_wait_v1 (ld, vd, d, lz, vz, z);

  parameter integer rscid = 1;
  parameter integer width = 8;

  input              ld;
  output             vd;
  output [width-1:0] d;
  output             lz;
  input              vz;
  input  [width-1:0] z;

  wire               vd;
  wire   [width-1:0] d;
  wire               lz;

  assign d = z;
  assign lz = ld;
  assign vd = vz;

endmodule


//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/siflibs/FP32_ADD_mgc_out_stdreg_wait_v1.v 
//------------------------------------------------------------------------------
// Catapult Synthesis - Sample I/O Port Library
//
// Copyright (c) 2003-2015 Mentor Graphics Corp.
//       All Rights Reserved
//
// This document may be used and distributed without restriction provided that
// this copyright statement is not removed from the file and that any derivative
// work contains this copyright notice.
//
// The design information contained in this file is intended to be an example
// of the functionality which the end user may study in preparation for creating
// their own custom interfaces. This design does not necessarily present a 
// complete implementation of the named protocol or standard.
//
//------------------------------------------------------------------------------


module FP32_ADD_mgc_out_stdreg_wait_v1 (ld, vd, d, lz, vz, z);

  parameter integer rscid = 1;
  parameter integer width = 8;

  input              ld;
  output             vd;
  input  [width-1:0] d;
  output             lz;
  input              vz;
  output [width-1:0] z;

  wire               vd;
  wire               lz;
  wire   [width-1:0] z;

  assign z = d;
  assign lz = ld;
  assign vd = vz;

endmodule



//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/siflibs/mgc_shift_bl_beh_v4.v 
module FP32_ADD_mgc_shift_bl_v4(a,s,z);
   parameter    width_a = 4;
   parameter    signd_a = 1;
   parameter    width_s = 2;
   parameter    width_z = 8;

   input [width_a-1:0] a;
   input [width_s-1:0] s;
   output [width_z -1:0] z;

   generate if ( signd_a )
   begin: SIGNED
     assign z = fshl_s(a,s,a[width_a-1]);
   end
   else
   begin: UNSIGNED
     assign z = fshl_s(a,s,1'b0);
   end
   endgenerate

   //Shift-left - unsigned shift argument one bit more
   function [width_z-1:0] fshl_u_1;
      input [width_a  :0] arg1;
      input [width_s-1:0] arg2;
      input sbit;
      parameter olen = width_z;
      parameter ilen = width_a+1;
      parameter len = (ilen >= olen) ? ilen : olen;
      reg [len-1:0] result;
      reg [len-1:0] result_t;
      begin
        result_t = {(len){sbit}};
        result_t[ilen-1:0] = arg1;
        result = result_t <<< arg2;
        fshl_u_1 =  result[olen-1:0];
      end
   endfunction // fshl_u

   //Shift-left - unsigned shift argument
   function [width_z-1:0] fshl_u;
      input [width_a-1:0] arg1;
      input [width_s-1:0] arg2;
      input sbit;
      fshl_u = fshl_u_1({sbit,arg1} ,arg2, sbit);
   endfunction // fshl_u

   //Shift right - unsigned shift argument
   function [width_z-1:0] fshr_u;
      input [width_a-1:0] arg1;
      input [width_s-1:0] arg2;
      input sbit;
      parameter olen = width_z;
      parameter ilen = signd_a ? width_a : width_a+1;
      parameter len = (ilen >= olen) ? ilen : olen;
      reg signed [len-1:0] result;
      reg signed [len-1:0] result_t;
      begin
        result_t = $signed( {(len){sbit}} );
        result_t[width_a-1:0] = arg1;
        result = result_t >>> arg2;
        fshr_u =  result[olen-1:0];
      end
   endfunction // fshl_u

   //Shift left - signed shift argument
   function [width_z-1:0] fshl_s;
      input [width_a-1:0] arg1;
      input [width_s-1:0] arg2;
      input sbit;
      reg [width_a:0] sbit_arg1;
      begin
        // Ignoring the possibility that arg2[width_s-1] could be X
        // because of customer complaints regarding X'es in simulation results
        if ( arg2[width_s-1] == 1'b0 )
        begin
          sbit_arg1[width_a:0] = {(width_a+1){1'b0}};
          fshl_s = fshl_u(arg1, arg2, sbit);
        end
        else
        begin
          sbit_arg1[width_a] = sbit;
          sbit_arg1[width_a-1:0] = arg1;
          fshl_s = fshr_u(sbit_arg1[width_a:1], ~arg2, sbit);
        end
      end
   endfunction

endmodule

//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/siflibs/mgc_shift_l_beh_v4.v 
module FP32_ADD_mgc_shift_l_v4(a,s,z);
   parameter    width_a = 4;
   parameter    signd_a = 1;
   parameter    width_s = 2;
   parameter    width_z = 8;

   input [width_a-1:0] a;
   input [width_s-1:0] s;
   output [width_z -1:0] z;

   generate
   if (signd_a)
   begin: SIGNED
      assign z = fshl_u(a,s,a[width_a-1]);
   end
   else
   begin: UNSIGNED
      assign z = fshl_u(a,s,1'b0);
   end
   endgenerate

   //Shift-left - unsigned shift argument one bit more
   function [width_z-1:0] fshl_u_1;
      input [width_a  :0] arg1;
      input [width_s-1:0] arg2;
      input sbit;
      parameter olen = width_z;
      parameter ilen = width_a+1;
      parameter len = (ilen >= olen) ? ilen : olen;
      reg [len-1:0] result;
      reg [len-1:0] result_t;
      begin
        result_t = {(len){sbit}};
        result_t[ilen-1:0] = arg1;
        result = result_t <<< arg2;
        fshl_u_1 =  result[olen-1:0];
      end
   endfunction // fshl_u

   //Shift-left - unsigned shift argument
   function [width_z-1:0] fshl_u;
      input [width_a-1:0] arg1;
      input [width_s-1:0] arg2;
      input sbit;
      fshl_u = fshl_u_1({sbit,arg1} ,arg2, sbit);
   endfunction // fshl_u

endmodule

//------> ../td_ccore_solutions/leading_sign_49_0_e47cea887f8a82708c2da9a42282cded83a3_0/rtl.v 
// ----------------------------------------------------------------------
//  HLS HDL:        Verilog Netlister
//  HLS Version:    10.0/264918 Production Release
//  HLS Date:       Mon Aug  8 13:35:54 PDT 2016
// 
//  Generated by:   ezhang@hk-sim-10-184
//  Generated date: Fri Jun 16 21:52:55 2017
// ----------------------------------------------------------------------

// 
// ------------------------------------------------------------------
//  Design Unit:    FP32_ADD_leading_sign_49_0
// ------------------------------------------------------------------


module FP32_ADD_leading_sign_49_0 (
  mantissa, rtn
);
  input [48:0] mantissa;
  output [5:0] rtn;


  // Interconnect Declarations
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_6_2_sdt_2;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_18_3_sdt_3;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_26_2_sdt_2;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_42_4_sdt_4;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_50_2_sdt_2;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_62_3_sdt_3;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_70_2_sdt_2;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_90_5_sdt_5;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_98_2_sdt_2;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_110_3_sdt_3;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_118_2_sdt_2;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_134_4_sdt_4;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_6_2_sdt_1;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_14_2_sdt_1;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_26_2_sdt_1;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_34_2_sdt_1;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_50_2_sdt_1;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_58_2_sdt_1;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_70_2_sdt_1;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_78_2_sdt_1;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_98_2_sdt_1;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_106_2_sdt_1;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_118_2_sdt_1;
  wire IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_126_2_sdt_1;
  wire c_h_1_2;
  wire c_h_1_5;
  wire c_h_1_6;
  wire c_h_1_9;
  wire c_h_1_12;
  wire c_h_1_13;
  wire c_h_1_14;
  wire c_h_1_17;
  wire c_h_1_20;
  wire c_h_1_21;
  wire c_h_1_22;
  wire c_h_1_23;

  wire[0:0] IntLeadZero_49U_leading_sign_49_0_rtn_and_189_nl;
  wire[0:0] IntLeadZero_49U_leading_sign_49_0_rtn_and_187_nl;
  wire[0:0] IntLeadZero_49U_leading_sign_49_0_rtn_and_194_nl;
  wire[0:0] IntLeadZero_49U_leading_sign_49_0_rtn_and_195_nl;
  wire[0:0] IntLeadZero_49U_leading_sign_49_0_rtn_IntLeadZero_49U_leading_sign_49_0_rtn_or_1_nl;

  // Interconnect Declarations for Component Instantiations 
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_6_2_sdt_2 = ~((mantissa[46:45]!=2'b00));
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_6_2_sdt_1 = ~((mantissa[48:47]!=2'b00));
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_14_2_sdt_1 = ~((mantissa[44:43]!=2'b00));
  assign c_h_1_2 = IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_6_2_sdt_1 & IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_6_2_sdt_2;
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_18_3_sdt_3 = (mantissa[42:41]==2'b00)
      & IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_14_2_sdt_1;
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_26_2_sdt_2 = ~((mantissa[38:37]!=2'b00));
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_26_2_sdt_1 = ~((mantissa[40:39]!=2'b00));
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_34_2_sdt_1 = ~((mantissa[36:35]!=2'b00));
  assign c_h_1_5 = IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_26_2_sdt_1 & IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_26_2_sdt_2;
  assign c_h_1_6 = c_h_1_2 & IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_18_3_sdt_3;
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_42_4_sdt_4 = (mantissa[34:33]==2'b00)
      & IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_34_2_sdt_1 & c_h_1_5;
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_50_2_sdt_2 = ~((mantissa[30:29]!=2'b00));
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_50_2_sdt_1 = ~((mantissa[32:31]!=2'b00));
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_58_2_sdt_1 = ~((mantissa[28:27]!=2'b00));
  assign c_h_1_9 = IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_50_2_sdt_1 & IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_50_2_sdt_2;
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_62_3_sdt_3 = (mantissa[26:25]==2'b00)
      & IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_58_2_sdt_1;
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_70_2_sdt_2 = ~((mantissa[22:21]!=2'b00));
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_70_2_sdt_1 = ~((mantissa[24:23]!=2'b00));
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_78_2_sdt_1 = ~((mantissa[20:19]!=2'b00));
  assign c_h_1_12 = IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_70_2_sdt_1 & IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_70_2_sdt_2;
  assign c_h_1_13 = c_h_1_9 & IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_62_3_sdt_3;
  assign c_h_1_14 = c_h_1_6 & IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_42_4_sdt_4;
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_90_5_sdt_5 = (mantissa[18:17]==2'b00)
      & IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_78_2_sdt_1 & c_h_1_12 & c_h_1_13;
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_98_2_sdt_2 = ~((mantissa[14:13]!=2'b00));
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_98_2_sdt_1 = ~((mantissa[16:15]!=2'b00));
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_106_2_sdt_1 = ~((mantissa[12:11]!=2'b00));
  assign c_h_1_17 = IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_98_2_sdt_1 & IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_98_2_sdt_2;
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_110_3_sdt_3 = (mantissa[10:9]==2'b00)
      & IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_106_2_sdt_1;
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_118_2_sdt_2 = ~((mantissa[6:5]!=2'b00));
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_118_2_sdt_1 = ~((mantissa[8:7]!=2'b00));
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_126_2_sdt_1 = ~((mantissa[4:3]!=2'b00));
  assign c_h_1_20 = IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_118_2_sdt_1 & IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_118_2_sdt_2;
  assign c_h_1_21 = c_h_1_17 & IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_110_3_sdt_3;
  assign IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_134_4_sdt_4 = (mantissa[2:1]==2'b00)
      & IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_126_2_sdt_1 & c_h_1_20;
  assign c_h_1_22 = c_h_1_21 & IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_134_4_sdt_4;
  assign c_h_1_23 = c_h_1_14 & IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_90_5_sdt_5;
  assign IntLeadZero_49U_leading_sign_49_0_rtn_and_189_nl = c_h_1_14 & (c_h_1_22
      | (~ IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_90_5_sdt_5));
  assign IntLeadZero_49U_leading_sign_49_0_rtn_and_187_nl = c_h_1_6 & (c_h_1_13 |
      (~ IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_42_4_sdt_4)) & (~((~(c_h_1_21
      & (~ IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_134_4_sdt_4))) & c_h_1_23));
  assign IntLeadZero_49U_leading_sign_49_0_rtn_and_194_nl = c_h_1_2 & (c_h_1_5 |
      (~ IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_18_3_sdt_3)) & (~((~(c_h_1_9
      & (c_h_1_12 | (~ IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_62_3_sdt_3))))
      & c_h_1_14)) & (~(((~(c_h_1_17 & (c_h_1_20 | (~ IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_110_3_sdt_3))))
      | c_h_1_22) & c_h_1_23));
  assign IntLeadZero_49U_leading_sign_49_0_rtn_and_195_nl = IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_6_2_sdt_1
      & (IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_14_2_sdt_1 | (~ IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_6_2_sdt_2))
      & (~((~(IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_26_2_sdt_1 & (IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_34_2_sdt_1
      | (~ IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_26_2_sdt_2)))) & c_h_1_6))
      & (~((~(IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_50_2_sdt_1 & (IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_58_2_sdt_1
      | (~ IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_50_2_sdt_2)) & (~((~(IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_70_2_sdt_1
      & (IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_78_2_sdt_1 | (~ IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_70_2_sdt_2))))
      & c_h_1_13)))) & c_h_1_14)) & (~(((~(IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_98_2_sdt_1
      & (IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_106_2_sdt_1 | (~ IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_98_2_sdt_2))
      & (~((~(IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_118_2_sdt_1 & (IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_126_2_sdt_1
      | (~ IntLeadZero_49U_leading_sign_49_0_rtn_wrs_c_118_2_sdt_2)))) & c_h_1_21))))
      | c_h_1_22) & c_h_1_23));
  assign IntLeadZero_49U_leading_sign_49_0_rtn_IntLeadZero_49U_leading_sign_49_0_rtn_or_1_nl
      = ((~((mantissa[48]) | (~((mantissa[47:46]!=2'b01))))) & (~(((mantissa[44])
      | (~((mantissa[43:42]!=2'b01)))) & c_h_1_2)) & (~((~((~((mantissa[40]) | (~((mantissa[39:38]!=2'b01)))))
      & (~(((mantissa[36]) | (~((mantissa[35:34]!=2'b01)))) & c_h_1_5)))) & c_h_1_6))
      & (~((~((~((mantissa[32]) | (~((mantissa[31:30]!=2'b01))))) & (~(((mantissa[28])
      | (~((mantissa[27:26]!=2'b01)))) & c_h_1_9)) & (~((~((~((mantissa[24]) | (~((mantissa[23:22]!=2'b01)))))
      & (~(((mantissa[20]) | (~((mantissa[19:18]!=2'b01)))) & c_h_1_12)))) & c_h_1_13))))
      & c_h_1_14)) & (~(((~((~((mantissa[16]) | (~((mantissa[15:14]!=2'b01))))) &
      (~(((mantissa[12]) | (~((mantissa[11:10]!=2'b01)))) & c_h_1_17)) & (~((~((~((mantissa[8])
      | (~((mantissa[7:6]!=2'b01))))) & (~(((mantissa[4]) | (~((mantissa[3:2]!=2'b01))))
      & c_h_1_20)))) & c_h_1_21)))) | c_h_1_22) & c_h_1_23))) | ((~ (mantissa[0]))
      & c_h_1_22 & c_h_1_23);
  assign rtn = {c_h_1_23 , (IntLeadZero_49U_leading_sign_49_0_rtn_and_189_nl) , (IntLeadZero_49U_leading_sign_49_0_rtn_and_187_nl)
      , (IntLeadZero_49U_leading_sign_49_0_rtn_and_194_nl) , (IntLeadZero_49U_leading_sign_49_0_rtn_and_195_nl)
      , (IntLeadZero_49U_leading_sign_49_0_rtn_IntLeadZero_49U_leading_sign_49_0_rtn_or_1_nl)};
endmodule




//------> ./rtl.v 
// ----------------------------------------------------------------------
//  HLS HDL:        Verilog Netlister
//  HLS Version:    10.0/264918 Production Release
//  HLS Date:       Mon Aug  8 13:35:54 PDT 2016
// 
//  Generated by:   ezhang@hk-sim-10-184
//  Generated date: Fri Jun 16 21:53:04 2017
// ----------------------------------------------------------------------

// 
// ------------------------------------------------------------------
//  Design Unit:    FP32_ADD_chn_o_rsci_unreg
// ------------------------------------------------------------------


module FP32_ADD_chn_o_rsci_unreg (
  in_0, outsig
);
  input in_0;
  output outsig;



  // Interconnect Declarations for Component Instantiations 
  assign outsig = in_0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    FP32_ADD_chn_b_rsci_unreg
// ------------------------------------------------------------------


module FP32_ADD_chn_b_rsci_unreg (
  in_0, outsig
);
  input in_0;
  output outsig;



  // Interconnect Declarations for Component Instantiations 
  assign outsig = in_0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    FP32_ADD_chn_a_rsci_unreg
// ------------------------------------------------------------------


module FP32_ADD_chn_a_rsci_unreg (
  in_0, outsig
);
  input in_0;
  output outsig;



  // Interconnect Declarations for Component Instantiations 
  assign outsig = in_0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_fp32_add_core_core_fsm
//  FSM Module
// ------------------------------------------------------------------


module HLS_fp32_add_core_core_fsm (
  nvdla_core_clk, nvdla_core_rstn, core_wen, fsm_output
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input core_wen;
  output [1:0] fsm_output;
  reg [1:0] fsm_output;


  // FSM State Type Declaration for HLS_fp32_add_core_core_fsm_1
  parameter
    core_rlp_C_0 = 1'd0,
    main_C_0 = 1'd1;

  reg [0:0] state_var;
  reg [0:0] state_var_NS;


  // Interconnect Declarations for Component Instantiations 
  always @(*)
  begin : HLS_fp32_add_core_core_fsm_1
    case (state_var)
      main_C_0 : begin
        fsm_output = 2'b10;
        state_var_NS = main_C_0;
      end
      // core_rlp_C_0
      default : begin
        fsm_output = 2'b1;
        state_var_NS = main_C_0;
      end
    endcase
  end

  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      state_var <= core_rlp_C_0;
    end
    else if ( core_wen ) begin
      state_var <= state_var_NS;
    end
  end

endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_fp32_add_core_staller
// ------------------------------------------------------------------


module HLS_fp32_add_core_staller (
  nvdla_core_clk, nvdla_core_rstn, core_wen, chn_a_rsci_wen_comp, core_wten, chn_b_rsci_wen_comp,
      chn_o_rsci_wen_comp
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  output core_wen;
  input chn_a_rsci_wen_comp;
  output core_wten;
  reg core_wten;
  input chn_b_rsci_wen_comp;
  input chn_o_rsci_wen_comp;



  // Interconnect Declarations for Component Instantiations 
  assign core_wen = chn_a_rsci_wen_comp & chn_b_rsci_wen_comp & chn_o_rsci_wen_comp;
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      core_wten <= 1'b0;
    end
    else begin
      core_wten <= ~ core_wen;
    end
  end
endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_fp32_add_core_chn_o_rsci_chn_o_wait_dp
// ------------------------------------------------------------------


module HLS_fp32_add_core_chn_o_rsci_chn_o_wait_dp (
  nvdla_core_clk, nvdla_core_rstn, chn_o_rsci_oswt, chn_o_rsci_bawt, chn_o_rsci_wen_comp,
      chn_o_rsci_biwt, chn_o_rsci_bdwt
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input chn_o_rsci_oswt;
  output chn_o_rsci_bawt;
  output chn_o_rsci_wen_comp;
  input chn_o_rsci_biwt;
  input chn_o_rsci_bdwt;


  // Interconnect Declarations
  reg chn_o_rsci_bcwt;


  // Interconnect Declarations for Component Instantiations 
  assign chn_o_rsci_bawt = chn_o_rsci_biwt | chn_o_rsci_bcwt;
  assign chn_o_rsci_wen_comp = (~ chn_o_rsci_oswt) | chn_o_rsci_bawt;
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_o_rsci_bcwt <= 1'b0;
    end
    else begin
      chn_o_rsci_bcwt <= ~((~(chn_o_rsci_bcwt | chn_o_rsci_biwt)) | chn_o_rsci_bdwt);
    end
  end
endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_fp32_add_core_chn_o_rsci_chn_o_wait_ctrl
// ------------------------------------------------------------------


module HLS_fp32_add_core_chn_o_rsci_chn_o_wait_ctrl (
  nvdla_core_clk, nvdla_core_rstn, chn_o_rsci_oswt, core_wen, core_wten, chn_o_rsci_iswt0,
      chn_o_rsci_ld_core_psct, chn_o_rsci_biwt, chn_o_rsci_bdwt, chn_o_rsci_ld_core_sct,
      chn_o_rsci_vd
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input chn_o_rsci_oswt;
  input core_wen;
  input core_wten;
  input chn_o_rsci_iswt0;
  input chn_o_rsci_ld_core_psct;
  output chn_o_rsci_biwt;
  output chn_o_rsci_bdwt;
  output chn_o_rsci_ld_core_sct;
  input chn_o_rsci_vd;


  // Interconnect Declarations
  wire chn_o_rsci_ogwt;
  wire chn_o_rsci_pdswt0;
  reg chn_o_rsci_icwt;


  // Interconnect Declarations for Component Instantiations 
  assign chn_o_rsci_pdswt0 = (~ core_wten) & chn_o_rsci_iswt0;
  assign chn_o_rsci_biwt = chn_o_rsci_ogwt & chn_o_rsci_vd;
  assign chn_o_rsci_ogwt = chn_o_rsci_pdswt0 | chn_o_rsci_icwt;
  assign chn_o_rsci_bdwt = chn_o_rsci_oswt & core_wen;
  assign chn_o_rsci_ld_core_sct = chn_o_rsci_ld_core_psct & chn_o_rsci_ogwt;
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_o_rsci_icwt <= 1'b0;
    end
    else begin
      chn_o_rsci_icwt <= ~((~(chn_o_rsci_icwt | chn_o_rsci_pdswt0)) | chn_o_rsci_biwt);
    end
  end
endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_fp32_add_core_chn_b_rsci_chn_b_wait_dp
// ------------------------------------------------------------------


module HLS_fp32_add_core_chn_b_rsci_chn_b_wait_dp (
  nvdla_core_clk, nvdla_core_rstn, chn_b_rsci_oswt, chn_b_rsci_bawt, chn_b_rsci_wen_comp,
      chn_b_rsci_d_mxwt, chn_b_rsci_biwt, chn_b_rsci_bdwt, chn_b_rsci_d
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input chn_b_rsci_oswt;
  output chn_b_rsci_bawt;
  output chn_b_rsci_wen_comp;
  output [31:0] chn_b_rsci_d_mxwt;
  input chn_b_rsci_biwt;
  input chn_b_rsci_bdwt;
  input [31:0] chn_b_rsci_d;


  // Interconnect Declarations
  reg chn_b_rsci_bcwt;
  reg [31:0] chn_b_rsci_d_bfwt;


  // Interconnect Declarations for Component Instantiations 
  assign chn_b_rsci_bawt = chn_b_rsci_biwt | chn_b_rsci_bcwt;
  assign chn_b_rsci_wen_comp = (~ chn_b_rsci_oswt) | chn_b_rsci_bawt;
  assign chn_b_rsci_d_mxwt = MUX_v_32_2_2(chn_b_rsci_d, chn_b_rsci_d_bfwt, chn_b_rsci_bcwt);
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_b_rsci_bcwt <= 1'b0;
      chn_b_rsci_d_bfwt <= 32'b0;
    end
    else begin
      chn_b_rsci_bcwt <= ~((~(chn_b_rsci_bcwt | chn_b_rsci_biwt)) | chn_b_rsci_bdwt);
      chn_b_rsci_d_bfwt <= chn_b_rsci_d_mxwt;
    end
  end

  function [31:0] MUX_v_32_2_2;
    input [31:0] input_0;
    input [31:0] input_1;
    input [0:0] sel;
    reg [31:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_32_2_2 = result;
  end
  endfunction

endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_fp32_add_core_chn_b_rsci_chn_b_wait_ctrl
// ------------------------------------------------------------------


module HLS_fp32_add_core_chn_b_rsci_chn_b_wait_ctrl (
  nvdla_core_clk, nvdla_core_rstn, chn_b_rsci_oswt, core_wen, core_wten, chn_b_rsci_iswt0,
      chn_b_rsci_ld_core_psct, chn_b_rsci_biwt, chn_b_rsci_bdwt, chn_b_rsci_ld_core_sct,
      chn_b_rsci_vd
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input chn_b_rsci_oswt;
  input core_wen;
  input core_wten;
  input chn_b_rsci_iswt0;
  input chn_b_rsci_ld_core_psct;
  output chn_b_rsci_biwt;
  output chn_b_rsci_bdwt;
  output chn_b_rsci_ld_core_sct;
  input chn_b_rsci_vd;


  // Interconnect Declarations
  wire chn_b_rsci_ogwt;
  wire chn_b_rsci_pdswt0;
  reg chn_b_rsci_icwt;


  // Interconnect Declarations for Component Instantiations 
  assign chn_b_rsci_pdswt0 = (~ core_wten) & chn_b_rsci_iswt0;
  assign chn_b_rsci_biwt = chn_b_rsci_ogwt & chn_b_rsci_vd;
  assign chn_b_rsci_ogwt = chn_b_rsci_pdswt0 | chn_b_rsci_icwt;
  assign chn_b_rsci_bdwt = chn_b_rsci_oswt & core_wen;
  assign chn_b_rsci_ld_core_sct = chn_b_rsci_ld_core_psct & chn_b_rsci_ogwt;
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_b_rsci_icwt <= 1'b0;
    end
    else begin
      chn_b_rsci_icwt <= ~((~(chn_b_rsci_icwt | chn_b_rsci_pdswt0)) | chn_b_rsci_biwt);
    end
  end
endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_fp32_add_core_chn_a_rsci_chn_a_wait_dp
// ------------------------------------------------------------------


module HLS_fp32_add_core_chn_a_rsci_chn_a_wait_dp (
  nvdla_core_clk, nvdla_core_rstn, chn_a_rsci_oswt, chn_a_rsci_bawt, chn_a_rsci_wen_comp,
      chn_a_rsci_d_mxwt, chn_a_rsci_biwt, chn_a_rsci_bdwt, chn_a_rsci_d
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input chn_a_rsci_oswt;
  output chn_a_rsci_bawt;
  output chn_a_rsci_wen_comp;
  output [31:0] chn_a_rsci_d_mxwt;
  input chn_a_rsci_biwt;
  input chn_a_rsci_bdwt;
  input [31:0] chn_a_rsci_d;


  // Interconnect Declarations
  reg chn_a_rsci_bcwt;
  reg [31:0] chn_a_rsci_d_bfwt;


  // Interconnect Declarations for Component Instantiations 
  assign chn_a_rsci_bawt = chn_a_rsci_biwt | chn_a_rsci_bcwt;
  assign chn_a_rsci_wen_comp = (~ chn_a_rsci_oswt) | chn_a_rsci_bawt;
  assign chn_a_rsci_d_mxwt = MUX_v_32_2_2(chn_a_rsci_d, chn_a_rsci_d_bfwt, chn_a_rsci_bcwt);
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_a_rsci_bcwt <= 1'b0;
      chn_a_rsci_d_bfwt <= 32'b0;
    end
    else begin
      chn_a_rsci_bcwt <= ~((~(chn_a_rsci_bcwt | chn_a_rsci_biwt)) | chn_a_rsci_bdwt);
      chn_a_rsci_d_bfwt <= chn_a_rsci_d_mxwt;
    end
  end

  function [31:0] MUX_v_32_2_2;
    input [31:0] input_0;
    input [31:0] input_1;
    input [0:0] sel;
    reg [31:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_32_2_2 = result;
  end
  endfunction

endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_fp32_add_core_chn_a_rsci_chn_a_wait_ctrl
// ------------------------------------------------------------------


module HLS_fp32_add_core_chn_a_rsci_chn_a_wait_ctrl (
  nvdla_core_clk, nvdla_core_rstn, chn_a_rsci_oswt, core_wen, chn_a_rsci_iswt0, chn_a_rsci_ld_core_psct,
      core_wten, chn_a_rsci_biwt, chn_a_rsci_bdwt, chn_a_rsci_ld_core_sct, chn_a_rsci_vd
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input chn_a_rsci_oswt;
  input core_wen;
  input chn_a_rsci_iswt0;
  input chn_a_rsci_ld_core_psct;
  input core_wten;
  output chn_a_rsci_biwt;
  output chn_a_rsci_bdwt;
  output chn_a_rsci_ld_core_sct;
  input chn_a_rsci_vd;


  // Interconnect Declarations
  wire chn_a_rsci_ogwt;
  wire chn_a_rsci_pdswt0;
  reg chn_a_rsci_icwt;


  // Interconnect Declarations for Component Instantiations 
  assign chn_a_rsci_pdswt0 = (~ core_wten) & chn_a_rsci_iswt0;
  assign chn_a_rsci_biwt = chn_a_rsci_ogwt & chn_a_rsci_vd;
  assign chn_a_rsci_ogwt = chn_a_rsci_pdswt0 | chn_a_rsci_icwt;
  assign chn_a_rsci_bdwt = chn_a_rsci_oswt & core_wen;
  assign chn_a_rsci_ld_core_sct = chn_a_rsci_ld_core_psct & chn_a_rsci_ogwt;
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_a_rsci_icwt <= 1'b0;
    end
    else begin
      chn_a_rsci_icwt <= ~((~(chn_a_rsci_icwt | chn_a_rsci_pdswt0)) | chn_a_rsci_biwt);
    end
  end
endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_fp32_add_core_chn_o_rsci
// ------------------------------------------------------------------


module HLS_fp32_add_core_chn_o_rsci (
  nvdla_core_clk, nvdla_core_rstn, chn_o_rsc_z, chn_o_rsc_vz, chn_o_rsc_lz, chn_o_rsci_oswt,
      core_wen, core_wten, chn_o_rsci_iswt0, chn_o_rsci_bawt, chn_o_rsci_wen_comp,
      chn_o_rsci_ld_core_psct, chn_o_rsci_d
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  output [31:0] chn_o_rsc_z;
  input chn_o_rsc_vz;
  output chn_o_rsc_lz;
  input chn_o_rsci_oswt;
  input core_wen;
  input core_wten;
  input chn_o_rsci_iswt0;
  output chn_o_rsci_bawt;
  output chn_o_rsci_wen_comp;
  input chn_o_rsci_ld_core_psct;
  input [31:0] chn_o_rsci_d;


  // Interconnect Declarations
  wire chn_o_rsci_biwt;
  wire chn_o_rsci_bdwt;
  wire chn_o_rsci_ld_core_sct;
  wire chn_o_rsci_vd;


  // Interconnect Declarations for Component Instantiations 
  FP32_ADD_mgc_out_stdreg_wait_v1 #(.rscid(32'sd3),
  .width(32'sd32)) chn_o_rsci (
      .ld(chn_o_rsci_ld_core_sct),
      .vd(chn_o_rsci_vd),
      .d(chn_o_rsci_d),
      .lz(chn_o_rsc_lz),
      .vz(chn_o_rsc_vz),
      .z(chn_o_rsc_z)
    );
  HLS_fp32_add_core_chn_o_rsci_chn_o_wait_ctrl HLS_fp32_add_core_chn_o_rsci_chn_o_wait_ctrl_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_o_rsci_oswt(chn_o_rsci_oswt),
      .core_wen(core_wen),
      .core_wten(core_wten),
      .chn_o_rsci_iswt0(chn_o_rsci_iswt0),
      .chn_o_rsci_ld_core_psct(chn_o_rsci_ld_core_psct),
      .chn_o_rsci_biwt(chn_o_rsci_biwt),
      .chn_o_rsci_bdwt(chn_o_rsci_bdwt),
      .chn_o_rsci_ld_core_sct(chn_o_rsci_ld_core_sct),
      .chn_o_rsci_vd(chn_o_rsci_vd)
    );
  HLS_fp32_add_core_chn_o_rsci_chn_o_wait_dp HLS_fp32_add_core_chn_o_rsci_chn_o_wait_dp_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_o_rsci_oswt(chn_o_rsci_oswt),
      .chn_o_rsci_bawt(chn_o_rsci_bawt),
      .chn_o_rsci_wen_comp(chn_o_rsci_wen_comp),
      .chn_o_rsci_biwt(chn_o_rsci_biwt),
      .chn_o_rsci_bdwt(chn_o_rsci_bdwt)
    );
endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_fp32_add_core_chn_b_rsci
// ------------------------------------------------------------------


module HLS_fp32_add_core_chn_b_rsci (
  nvdla_core_clk, nvdla_core_rstn, chn_b_rsc_z, chn_b_rsc_vz, chn_b_rsc_lz, chn_b_rsci_oswt,
      core_wen, core_wten, chn_b_rsci_iswt0, chn_b_rsci_bawt, chn_b_rsci_wen_comp,
      chn_b_rsci_ld_core_psct, chn_b_rsci_d_mxwt
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [31:0] chn_b_rsc_z;
  input chn_b_rsc_vz;
  output chn_b_rsc_lz;
  input chn_b_rsci_oswt;
  input core_wen;
  input core_wten;
  input chn_b_rsci_iswt0;
  output chn_b_rsci_bawt;
  output chn_b_rsci_wen_comp;
  input chn_b_rsci_ld_core_psct;
  output [31:0] chn_b_rsci_d_mxwt;


  // Interconnect Declarations
  wire chn_b_rsci_biwt;
  wire chn_b_rsci_bdwt;
  wire chn_b_rsci_ld_core_sct;
  wire chn_b_rsci_vd;
  wire [31:0] chn_b_rsci_d;


  // Interconnect Declarations for Component Instantiations 
  FP32_ADD_mgc_in_wire_wait_v1 #(.rscid(32'sd2),
  .width(32'sd32)) chn_b_rsci (
      .ld(chn_b_rsci_ld_core_sct),
      .vd(chn_b_rsci_vd),
      .d(chn_b_rsci_d),
      .lz(chn_b_rsc_lz),
      .vz(chn_b_rsc_vz),
      .z(chn_b_rsc_z)
    );
  HLS_fp32_add_core_chn_b_rsci_chn_b_wait_ctrl HLS_fp32_add_core_chn_b_rsci_chn_b_wait_ctrl_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_b_rsci_oswt(chn_b_rsci_oswt),
      .core_wen(core_wen),
      .core_wten(core_wten),
      .chn_b_rsci_iswt0(chn_b_rsci_iswt0),
      .chn_b_rsci_ld_core_psct(chn_b_rsci_ld_core_psct),
      .chn_b_rsci_biwt(chn_b_rsci_biwt),
      .chn_b_rsci_bdwt(chn_b_rsci_bdwt),
      .chn_b_rsci_ld_core_sct(chn_b_rsci_ld_core_sct),
      .chn_b_rsci_vd(chn_b_rsci_vd)
    );
  HLS_fp32_add_core_chn_b_rsci_chn_b_wait_dp HLS_fp32_add_core_chn_b_rsci_chn_b_wait_dp_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_b_rsci_oswt(chn_b_rsci_oswt),
      .chn_b_rsci_bawt(chn_b_rsci_bawt),
      .chn_b_rsci_wen_comp(chn_b_rsci_wen_comp),
      .chn_b_rsci_d_mxwt(chn_b_rsci_d_mxwt),
      .chn_b_rsci_biwt(chn_b_rsci_biwt),
      .chn_b_rsci_bdwt(chn_b_rsci_bdwt),
      .chn_b_rsci_d(chn_b_rsci_d)
    );
endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_fp32_add_core_chn_a_rsci
// ------------------------------------------------------------------


module HLS_fp32_add_core_chn_a_rsci (
  nvdla_core_clk, nvdla_core_rstn, chn_a_rsc_z, chn_a_rsc_vz, chn_a_rsc_lz, chn_a_rsci_oswt,
      core_wen, chn_a_rsci_iswt0, chn_a_rsci_bawt, chn_a_rsci_wen_comp, chn_a_rsci_ld_core_psct,
      chn_a_rsci_d_mxwt, core_wten
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [31:0] chn_a_rsc_z;
  input chn_a_rsc_vz;
  output chn_a_rsc_lz;
  input chn_a_rsci_oswt;
  input core_wen;
  input chn_a_rsci_iswt0;
  output chn_a_rsci_bawt;
  output chn_a_rsci_wen_comp;
  input chn_a_rsci_ld_core_psct;
  output [31:0] chn_a_rsci_d_mxwt;
  input core_wten;


  // Interconnect Declarations
  wire chn_a_rsci_biwt;
  wire chn_a_rsci_bdwt;
  wire chn_a_rsci_ld_core_sct;
  wire chn_a_rsci_vd;
  wire [31:0] chn_a_rsci_d;


  // Interconnect Declarations for Component Instantiations 
  FP32_ADD_mgc_in_wire_wait_v1 #(.rscid(32'sd1),
  .width(32'sd32)) chn_a_rsci (
      .ld(chn_a_rsci_ld_core_sct),
      .vd(chn_a_rsci_vd),
      .d(chn_a_rsci_d),
      .lz(chn_a_rsc_lz),
      .vz(chn_a_rsc_vz),
      .z(chn_a_rsc_z)
    );
  HLS_fp32_add_core_chn_a_rsci_chn_a_wait_ctrl HLS_fp32_add_core_chn_a_rsci_chn_a_wait_ctrl_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_a_rsci_oswt(chn_a_rsci_oswt),
      .core_wen(core_wen),
      .chn_a_rsci_iswt0(chn_a_rsci_iswt0),
      .chn_a_rsci_ld_core_psct(chn_a_rsci_ld_core_psct),
      .core_wten(core_wten),
      .chn_a_rsci_biwt(chn_a_rsci_biwt),
      .chn_a_rsci_bdwt(chn_a_rsci_bdwt),
      .chn_a_rsci_ld_core_sct(chn_a_rsci_ld_core_sct),
      .chn_a_rsci_vd(chn_a_rsci_vd)
    );
  HLS_fp32_add_core_chn_a_rsci_chn_a_wait_dp HLS_fp32_add_core_chn_a_rsci_chn_a_wait_dp_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_a_rsci_oswt(chn_a_rsci_oswt),
      .chn_a_rsci_bawt(chn_a_rsci_bawt),
      .chn_a_rsci_wen_comp(chn_a_rsci_wen_comp),
      .chn_a_rsci_d_mxwt(chn_a_rsci_d_mxwt),
      .chn_a_rsci_biwt(chn_a_rsci_biwt),
      .chn_a_rsci_bdwt(chn_a_rsci_bdwt),
      .chn_a_rsci_d(chn_a_rsci_d)
    );
endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_fp32_add_core
// ------------------------------------------------------------------


module HLS_fp32_add_core (
  nvdla_core_clk, nvdla_core_rstn, chn_a_rsc_z, chn_a_rsc_vz, chn_a_rsc_lz, chn_b_rsc_z,
      chn_b_rsc_vz, chn_b_rsc_lz, chn_o_rsc_z, chn_o_rsc_vz, chn_o_rsc_lz, chn_a_rsci_oswt,
      chn_b_rsci_oswt, chn_o_rsci_oswt, chn_o_rsci_oswt_unreg, chn_a_rsci_oswt_unreg_pff
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [31:0] chn_a_rsc_z;
  input chn_a_rsc_vz;
  output chn_a_rsc_lz;
  input [31:0] chn_b_rsc_z;
  input chn_b_rsc_vz;
  output chn_b_rsc_lz;
  output [31:0] chn_o_rsc_z;
  input chn_o_rsc_vz;
  output chn_o_rsc_lz;
  input chn_a_rsci_oswt;
  input chn_b_rsci_oswt;
  input chn_o_rsci_oswt;
  output chn_o_rsci_oswt_unreg;
  output chn_a_rsci_oswt_unreg_pff;


  // Interconnect Declarations
  wire core_wen;
  wire chn_a_rsci_bawt;
  wire chn_a_rsci_wen_comp;
  wire [31:0] chn_a_rsci_d_mxwt;
  wire core_wten;
  wire chn_b_rsci_bawt;
  wire chn_b_rsci_wen_comp;
  wire [31:0] chn_b_rsci_d_mxwt;
  reg chn_o_rsci_iswt0;
  wire chn_o_rsci_bawt;
  wire chn_o_rsci_wen_comp;
  reg chn_o_rsci_d_31;
  reg [7:0] chn_o_rsci_d_30_23;
  reg [22:0] chn_o_rsci_d_22_0;
  wire [1:0] fsm_output;
  wire IsNaN_8U_23U_IsNaN_8U_23U_nor_tmp;
  wire FpAdd_8U_23U_is_a_greater_oif_equal_tmp;
  wire FpMantRNE_49U_24U_else_and_tmp;
  wire IsNaN_8U_23U_1_IsNaN_8U_23U_1_nand_tmp;
  wire IsNaN_8U_23U_1_nor_tmp;
  wire nor_tmp_1;
  wire or_tmp_3;
  wire mux_tmp_5;
  wire nor_tmp_11;
  wire or_tmp_16;
  wire and_dcpl_7;
  wire and_dcpl_13;
  wire and_dcpl_14;
  wire and_dcpl_15;
  wire and_dcpl_28;
  wire and_dcpl_29;
  wire and_dcpl_33;
  wire or_tmp_29;
  wire or_tmp_35;
  reg main_stage_v_1;
  reg main_stage_v_2;
  reg main_stage_v_3;
  reg IsNaN_8U_23U_1_land_lpi_1_dfm_3;
  reg IsNaN_8U_23U_1_land_lpi_1_dfm_4;
  reg [31:0] FpSignedBitsToFloat_8U_23U_bits_sva_36;
  reg [31:0] FpSignedBitsToFloat_8U_23U_bits_1_sva_36;
  reg FpAdd_8U_23U_is_a_greater_lor_lpi_1_dfm_4;
  reg FpAdd_8U_23U_is_a_greater_lor_lpi_1_dfm_5;
  reg [7:0] FpAdd_8U_23U_qr_lpi_1_dfm_4;
  reg [7:0] FpAdd_8U_23U_qr_lpi_1_dfm_5;
  reg [7:0] FpAdd_8U_23U_qr_lpi_1_dfm_6;
  reg [48:0] FpAdd_8U_23U_a_int_mant_p1_sva_2;
  reg [48:0] FpAdd_8U_23U_b_int_mant_p1_sva_2;
  reg FpAdd_8U_23U_is_addition_FpAdd_8U_23U_is_addition_xnor_svs_3;
  reg [49:0] FpAdd_8U_23U_int_mant_p1_lpi_1_dfm_2;
  reg IsNaN_8U_23U_land_lpi_1_dfm_5;
  reg IsNaN_8U_23U_land_lpi_1_dfm_6;
  reg FpAdd_8U_23U_IsZero_8U_23U_or_itm_2;
  reg FpAdd_8U_23U_IsZero_8U_23U_1_or_itm_2;
  reg FpNormalize_8U_49U_if_or_itm_2;
  reg IsNaN_8U_23U_1_nor_itm_2;
  reg IsNaN_8U_23U_1_IsNaN_8U_23U_1_nand_itm_2;
  reg [22:0] FpSignedBitsToFloat_8U_23U_1_slc_FpSignedBitsToFloat_8U_23U_1_ubits_22_0_itm_3;
  reg [22:0] FpSignedBitsToFloat_8U_23U_1_slc_FpSignedBitsToFloat_8U_23U_1_ubits_22_0_itm_4;
  reg FpAdd_8U_23U_mux_1_itm_2;
  reg FpAdd_8U_23U_mux_13_itm_3;
  reg FpAdd_8U_23U_mux_13_itm_4;
  reg [7:0] FpSignedBitsToFloat_8U_23U_1_slc_FpSignedBitsToFloat_8U_23U_1_ubits_30_23_itm_3;
  reg [7:0] FpSignedBitsToFloat_8U_23U_1_slc_FpSignedBitsToFloat_8U_23U_1_ubits_30_23_itm_4;
  reg IsNaN_8U_23U_land_lpi_1_dfm_st_4;
  wire FpAdd_8U_23U_mux_2_tmp_49;
  wire main_stage_en_1;
  wire FpAdd_8U_23U_is_inf_lpi_1_dfm_2_mx0;
  wire FpAdd_8U_23U_FpAdd_8U_23U_nor_2_m1c;
  wire FpAdd_8U_23U_is_inf_lpi_1_dfm;
  wire [49:0] FpAdd_8U_23U_int_mant_p1_lpi_1_dfm_mx0;
  wire [7:0] FpAdd_8U_23U_o_expo_lpi_1_dfm_2;
  reg reg_chn_b_rsci_iswt0_cse;
  reg reg_chn_b_rsci_ld_core_psct_cse;
  wire chn_o_and_1_cse;
  wire nor_36_cse;
  wire FpAdd_8U_23U_or_cse;
  reg reg_chn_o_rsci_ld_core_psct_cse;
  wire or_cse;
  wire FpAdd_8U_23U_is_a_greater_FpAdd_8U_23U_is_a_greater_or_cse;
  wire FpSignedBitsToFloat_8U_23U_and_rgt;
  wire FpSignedBitsToFloat_8U_23U_and_1_rgt;
  wire [48:0] FpAdd_8U_23U_a_int_mant_p1_lshift_itm;
  wire [48:0] FpAdd_8U_23U_b_int_mant_p1_lshift_itm;
  wire [48:0] FpNormalize_8U_49U_else_lshift_itm;
  wire chn_o_rsci_d_22_0_mx0c1;
  wire main_stage_v_1_mx0c1;
  wire main_stage_v_2_mx0c1;
  wire main_stage_v_3_mx0c1;
  wire IsNaN_8U_23U_1_land_lpi_1_dfm_mx0w0;
  wire [48:0] FpAdd_8U_23U_addend_larger_qr_lpi_1_dfm_mx0;
  wire [48:0] FpAdd_8U_23U_addend_smaller_qr_lpi_1_dfm_mx0;
  wire [49:0] FpAdd_8U_23U_asn_5_mx0w0;
  wire [50:0] nl_FpAdd_8U_23U_asn_5_mx0w0;
  wire [49:0] FpAdd_8U_23U_asn_4_mx0w1;
  wire [51:0] nl_FpAdd_8U_23U_asn_4_mx0w1;
  wire [48:0] FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0;
  wire FpMantRNE_49U_24U_else_carry_sva;
  wire FpAdd_8U_23U_and_tmp;
  wire [7:0] FpAdd_8U_23U_b_right_shift_qr_lpi_1_dfm;
  wire [7:0] FpAdd_8U_23U_a_right_shift_qr_lpi_1_dfm;
  wire FpNormalize_8U_49U_oelse_not_3;
  wire [5:0] libraries_leading_sign_49_0_e47cea887f8a82708c2da9a42282cded83a3_1;
  wire FpAdd_8U_23U_is_addition_and_cse;
  wire FpAdd_8U_23U_and_8_cse;
  wire IsNaN_8U_23U_aelse_and_cse;
  wire FpSignedBitsToFloat_8U_23U_1_FpSignedBitsToFloat_8U_23U_1_or_1_cse;
  wire FpSignedBitsToFloat_8U_23U_FpAdd_8U_23U_or_1_cse;
  wire IsNaN_8U_23U_1_and_cse;
  reg reg_FpAdd_8U_23U_is_addition_FpAdd_8U_23U_is_addition_xnor_svs_2_cse;
  wire mux_13_cse;
  wire mux_4_cse;
  wire FpSignedBitsToFloat_8U_23U_1_and_1_cse;
  wire FpAdd_8U_23U_is_a_greater_acc_1_itm_8_1;
  wire FpAdd_8U_23U_if_3_if_acc_1_itm_7_1;
  wire FpAdd_8U_23U_if_4_if_acc_1_itm_7_1;
  wire FpAdd_8U_23U_is_a_greater_oif_aelse_acc_itm_23_1;

  wire[22:0] FpAdd_8U_23U_FpAdd_8U_23U_or_1_nl;
  wire[22:0] FpMantRNE_49U_24U_else_acc_nl;
  wire[23:0] nl_FpMantRNE_49U_24U_else_acc_nl;
  wire[0:0] FpSignedBitsToFloat_8U_23U_1_and_nl;
  wire[7:0] FpAdd_8U_23U_if_4_if_acc_nl;
  wire[8:0] nl_FpAdd_8U_23U_if_4_if_acc_nl;
  wire[0:0] FpAdd_8U_23U_and_nl;
  wire[0:0] FpAdd_8U_23U_and_3_nl;
  wire[0:0] FpAdd_8U_23U_and_7_nl;
  wire[0:0] mux_6_nl;
  wire[0:0] mux_8_nl;
  wire[0:0] mux_7_nl;
  wire[0:0] nor_37_nl;
  wire[0:0] nor_7_nl;
  wire[0:0] mux_10_nl;
  wire[0:0] or_10_nl;
  wire[0:0] mux_9_nl;
  wire[0:0] nor_34_nl;
  wire[0:0] and_67_nl;
  wire[0:0] mux_23_nl;
  wire[0:0] mux_22_nl;
  wire[0:0] nor_31_nl;
  wire[0:0] mux_25_nl;
  wire[0:0] mux_24_nl;
  wire[0:0] nor_32_nl;
  wire[0:0] mux_27_nl;
  wire[0:0] nor_28_nl;
  wire[0:0] nor_29_nl;
  wire[0:0] mux_28_nl;
  wire[0:0] nor_26_nl;
  wire[0:0] nor_27_nl;
  wire[8:0] FpAdd_8U_23U_is_a_greater_acc_1_nl;
  wire[10:0] nl_FpAdd_8U_23U_is_a_greater_acc_1_nl;
  wire[7:0] FpAdd_8U_23U_if_3_if_acc_1_nl;
  wire[8:0] nl_FpAdd_8U_23U_if_3_if_acc_1_nl;
  wire[7:0] FpNormalize_8U_49U_FpNormalize_8U_49U_and_nl;
  wire[7:0] FpNormalize_8U_49U_else_acc_nl;
  wire[9:0] nl_FpNormalize_8U_49U_else_acc_nl;
  wire[7:0] FpAdd_8U_23U_if_3_if_acc_nl;
  wire[8:0] nl_FpAdd_8U_23U_if_3_if_acc_nl;
  wire[0:0] FpAdd_8U_23U_and_1_nl;
  wire[0:0] FpAdd_8U_23U_and_2_nl;
  wire[48:0] FpNormalize_8U_49U_FpNormalize_8U_49U_and_1_nl;
  wire[0:0] FpAdd_8U_23U_if_4_FpAdd_8U_23U_if_4_or_nl;
  wire[7:0] FpAdd_8U_23U_if_4_if_acc_1_nl;
  wire[8:0] nl_FpAdd_8U_23U_if_4_if_acc_1_nl;
  wire[7:0] FpAdd_8U_23U_b_right_shift_qif_acc_nl;
  wire[8:0] nl_FpAdd_8U_23U_b_right_shift_qif_acc_nl;
  wire[7:0] FpAdd_8U_23U_a_right_shift_qelse_acc_nl;
  wire[8:0] nl_FpAdd_8U_23U_a_right_shift_qelse_acc_nl;
  wire[0:0] FpAdd_8U_23U_is_a_greater_oelse_not_5_nl;
  wire[8:0] FpNormalize_8U_49U_acc_nl;
  wire[10:0] nl_FpNormalize_8U_49U_acc_nl;
  wire[0:0] nor_38_nl;
  wire[23:0] FpAdd_8U_23U_is_a_greater_oif_aelse_acc_nl;
  wire[25:0] nl_FpAdd_8U_23U_is_a_greater_oif_aelse_acc_nl;

  // Interconnect Declarations for Component Instantiations 
  wire [23:0] nl_FpAdd_8U_23U_a_int_mant_p1_lshift_rg_a;
  assign nl_FpAdd_8U_23U_a_int_mant_p1_lshift_rg_a = {FpAdd_8U_23U_IsZero_8U_23U_or_itm_2
      , (FpSignedBitsToFloat_8U_23U_bits_sva_36[22:0])};
  wire[7:0] FpAdd_8U_23U_a_left_shift_acc_nl;
  wire[8:0] nl_FpAdd_8U_23U_a_left_shift_acc_nl;
  wire [8:0] nl_FpAdd_8U_23U_a_int_mant_p1_lshift_rg_s;
  assign nl_FpAdd_8U_23U_a_left_shift_acc_nl = ({1'b1 , (~ (FpAdd_8U_23U_a_right_shift_qr_lpi_1_dfm[7:1]))})
      + 8'b1101;
  assign FpAdd_8U_23U_a_left_shift_acc_nl = nl_FpAdd_8U_23U_a_left_shift_acc_nl[7:0];
  assign nl_FpAdd_8U_23U_a_int_mant_p1_lshift_rg_s = {(FpAdd_8U_23U_a_left_shift_acc_nl)
      , (~ (FpAdd_8U_23U_a_right_shift_qr_lpi_1_dfm[0]))};
  wire [23:0] nl_FpAdd_8U_23U_b_int_mant_p1_lshift_rg_a;
  assign nl_FpAdd_8U_23U_b_int_mant_p1_lshift_rg_a = {FpAdd_8U_23U_IsZero_8U_23U_1_or_itm_2
      , (FpSignedBitsToFloat_8U_23U_bits_1_sva_36[22:0])};
  wire[7:0] FpAdd_8U_23U_b_left_shift_acc_nl;
  wire[8:0] nl_FpAdd_8U_23U_b_left_shift_acc_nl;
  wire [8:0] nl_FpAdd_8U_23U_b_int_mant_p1_lshift_rg_s;
  assign nl_FpAdd_8U_23U_b_left_shift_acc_nl = ({1'b1 , (~ (FpAdd_8U_23U_b_right_shift_qr_lpi_1_dfm[7:1]))})
      + 8'b1101;
  assign FpAdd_8U_23U_b_left_shift_acc_nl = nl_FpAdd_8U_23U_b_left_shift_acc_nl[7:0];
  assign nl_FpAdd_8U_23U_b_int_mant_p1_lshift_rg_s = {(FpAdd_8U_23U_b_left_shift_acc_nl)
      , (~ (FpAdd_8U_23U_b_right_shift_qr_lpi_1_dfm[0]))};
  wire [48:0] nl_FpNormalize_8U_49U_else_lshift_rg_a;
  assign nl_FpNormalize_8U_49U_else_lshift_rg_a = FpAdd_8U_23U_int_mant_p1_lpi_1_dfm_2[48:0];
  wire [48:0] nl_leading_sign_49_0_rg_mantissa;
  assign nl_leading_sign_49_0_rg_mantissa = FpAdd_8U_23U_int_mant_p1_lpi_1_dfm_2[48:0];
  wire [31:0] nl_HLS_fp32_add_core_chn_o_rsci_inst_chn_o_rsci_d;
  assign nl_HLS_fp32_add_core_chn_o_rsci_inst_chn_o_rsci_d = {chn_o_rsci_d_31 , chn_o_rsci_d_30_23
      , chn_o_rsci_d_22_0};
  FP32_ADD_mgc_shift_bl_v4 #(.width_a(32'sd24),
  .signd_a(32'sd0),
  .width_s(32'sd9),
  .width_z(32'sd49)) FpAdd_8U_23U_a_int_mant_p1_lshift_rg (
      .a(nl_FpAdd_8U_23U_a_int_mant_p1_lshift_rg_a[23:0]),
      .s(nl_FpAdd_8U_23U_a_int_mant_p1_lshift_rg_s[8:0]),
      .z(FpAdd_8U_23U_a_int_mant_p1_lshift_itm)
    );
  FP32_ADD_mgc_shift_bl_v4 #(.width_a(32'sd24),
  .signd_a(32'sd0),
  .width_s(32'sd9),
  .width_z(32'sd49)) FpAdd_8U_23U_b_int_mant_p1_lshift_rg (
      .a(nl_FpAdd_8U_23U_b_int_mant_p1_lshift_rg_a[23:0]),
      .s(nl_FpAdd_8U_23U_b_int_mant_p1_lshift_rg_s[8:0]),
      .z(FpAdd_8U_23U_b_int_mant_p1_lshift_itm)
    );
  FP32_ADD_mgc_shift_l_v4 #(.width_a(32'sd49),
  .signd_a(32'sd0),
  .width_s(32'sd6),
  .width_z(32'sd49)) FpNormalize_8U_49U_else_lshift_rg (
      .a(nl_FpNormalize_8U_49U_else_lshift_rg_a[48:0]),
      .s(libraries_leading_sign_49_0_e47cea887f8a82708c2da9a42282cded83a3_1),
      .z(FpNormalize_8U_49U_else_lshift_itm)
    );
  FP32_ADD_leading_sign_49_0  leading_sign_49_0_rg (
      .mantissa(nl_leading_sign_49_0_rg_mantissa[48:0]),
      .rtn(libraries_leading_sign_49_0_e47cea887f8a82708c2da9a42282cded83a3_1)
    );
  HLS_fp32_add_core_chn_a_rsci HLS_fp32_add_core_chn_a_rsci_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_a_rsc_z(chn_a_rsc_z),
      .chn_a_rsc_vz(chn_a_rsc_vz),
      .chn_a_rsc_lz(chn_a_rsc_lz),
      .chn_a_rsci_oswt(chn_a_rsci_oswt),
      .core_wen(core_wen),
      .chn_a_rsci_iswt0(reg_chn_b_rsci_iswt0_cse),
      .chn_a_rsci_bawt(chn_a_rsci_bawt),
      .chn_a_rsci_wen_comp(chn_a_rsci_wen_comp),
      .chn_a_rsci_ld_core_psct(reg_chn_b_rsci_ld_core_psct_cse),
      .chn_a_rsci_d_mxwt(chn_a_rsci_d_mxwt),
      .core_wten(core_wten)
    );
  HLS_fp32_add_core_chn_b_rsci HLS_fp32_add_core_chn_b_rsci_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_b_rsc_z(chn_b_rsc_z),
      .chn_b_rsc_vz(chn_b_rsc_vz),
      .chn_b_rsc_lz(chn_b_rsc_lz),
      .chn_b_rsci_oswt(chn_b_rsci_oswt),
      .core_wen(core_wen),
      .core_wten(core_wten),
      .chn_b_rsci_iswt0(reg_chn_b_rsci_iswt0_cse),
      .chn_b_rsci_bawt(chn_b_rsci_bawt),
      .chn_b_rsci_wen_comp(chn_b_rsci_wen_comp),
      .chn_b_rsci_ld_core_psct(reg_chn_b_rsci_ld_core_psct_cse),
      .chn_b_rsci_d_mxwt(chn_b_rsci_d_mxwt)
    );
  HLS_fp32_add_core_chn_o_rsci HLS_fp32_add_core_chn_o_rsci_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_o_rsc_z(chn_o_rsc_z),
      .chn_o_rsc_vz(chn_o_rsc_vz),
      .chn_o_rsc_lz(chn_o_rsc_lz),
      .chn_o_rsci_oswt(chn_o_rsci_oswt),
      .core_wen(core_wen),
      .core_wten(core_wten),
      .chn_o_rsci_iswt0(chn_o_rsci_iswt0),
      .chn_o_rsci_bawt(chn_o_rsci_bawt),
      .chn_o_rsci_wen_comp(chn_o_rsci_wen_comp),
      .chn_o_rsci_ld_core_psct(reg_chn_o_rsci_ld_core_psct_cse),
      .chn_o_rsci_d(nl_HLS_fp32_add_core_chn_o_rsci_inst_chn_o_rsci_d[31:0])
    );
  HLS_fp32_add_core_staller HLS_fp32_add_core_staller_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .core_wen(core_wen),
      .chn_a_rsci_wen_comp(chn_a_rsci_wen_comp),
      .core_wten(core_wten),
      .chn_b_rsci_wen_comp(chn_b_rsci_wen_comp),
      .chn_o_rsci_wen_comp(chn_o_rsci_wen_comp)
    );
  HLS_fp32_add_core_core_fsm HLS_fp32_add_core_core_fsm_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .core_wen(core_wen),
      .fsm_output(fsm_output)
    );
  assign chn_o_and_1_cse = core_wen & (~(and_dcpl_7 | (~ main_stage_v_3)));
  assign FpAdd_8U_23U_or_cse = IsNaN_8U_23U_1_land_lpi_1_dfm_4 | IsNaN_8U_23U_land_lpi_1_dfm_6;
  assign IsNaN_8U_23U_aelse_and_cse = core_wen & (~ and_dcpl_7) & mux_13_cse;
  assign FpAdd_8U_23U_is_addition_and_cse = core_wen & (~ and_dcpl_7) & mux_4_cse;
  assign mux_4_cse = MUX_s_1_2_2(main_stage_v_1, main_stage_v_2, nor_36_cse);
  assign mux_6_nl = MUX_s_1_2_2(mux_tmp_5, or_tmp_3, main_stage_v_3);
  assign FpAdd_8U_23U_and_8_cse = core_wen & (~ and_dcpl_7) & (mux_6_nl);
  assign nor_36_cse = ~(chn_o_rsci_bawt | (~ reg_chn_o_rsci_ld_core_psct_cse));
  assign or_10_nl = nor_36_cse | nor_tmp_11;
  assign nor_34_nl = ~(reg_chn_o_rsci_ld_core_psct_cse | (~ nor_tmp_11));
  assign mux_9_nl = MUX_s_1_2_2((nor_34_nl), nor_tmp_11, chn_o_rsci_bawt);
  assign and_67_nl = FpAdd_8U_23U_or_cse & main_stage_v_3;
  assign mux_10_nl = MUX_s_1_2_2((mux_9_nl), (or_10_nl), and_67_nl);
  assign FpSignedBitsToFloat_8U_23U_1_and_1_cse = core_wen & (~ and_dcpl_7) & (mux_10_nl);
  assign FpAdd_8U_23U_is_a_greater_FpAdd_8U_23U_is_a_greater_or_cse = ((~ FpAdd_8U_23U_is_a_greater_oif_aelse_acc_itm_23_1)
      & FpAdd_8U_23U_is_a_greater_oif_equal_tmp) | FpAdd_8U_23U_is_a_greater_acc_1_itm_8_1;
  assign mux_13_cse = MUX_s_1_2_2(nor_tmp_1, main_stage_v_1, nor_36_cse);
  assign FpSignedBitsToFloat_8U_23U_1_FpSignedBitsToFloat_8U_23U_1_or_1_cse = and_dcpl_28
      | and_dcpl_29;
  assign FpSignedBitsToFloat_8U_23U_and_rgt = (~ IsNaN_8U_23U_1_land_lpi_1_dfm_mx0w0)
      & and_dcpl_28;
  assign FpSignedBitsToFloat_8U_23U_and_1_rgt = IsNaN_8U_23U_1_land_lpi_1_dfm_mx0w0
      & and_dcpl_28;
  assign FpSignedBitsToFloat_8U_23U_FpAdd_8U_23U_or_1_cse = (FpAdd_8U_23U_is_a_greater_FpAdd_8U_23U_is_a_greater_or_cse
      & or_cse) | and_dcpl_33;
  assign nor_26_nl = ~(IsNaN_8U_23U_land_lpi_1_dfm_st_4 | (~ main_stage_v_1));
  assign nor_27_nl = ~(IsNaN_8U_23U_IsNaN_8U_23U_nor_tmp | (~ nor_tmp_1));
  assign mux_28_nl = MUX_s_1_2_2((nor_27_nl), (nor_26_nl), nor_36_cse);
  assign IsNaN_8U_23U_1_and_cse = core_wen & (~ and_dcpl_7) & (mux_28_nl);
  assign IsNaN_8U_23U_IsNaN_8U_23U_nor_tmp = ~((~((chn_a_rsci_d_mxwt[22:0]!=23'b00000000000000000000000)))
      | (chn_a_rsci_d_mxwt[30:23]!=8'b11111111));
  assign FpAdd_8U_23U_is_a_greater_oif_equal_tmp = (chn_a_rsci_d_mxwt[30:23]) ==
      (chn_b_rsci_d_mxwt[30:23]);
  assign IsNaN_8U_23U_1_land_lpi_1_dfm_mx0w0 = ~(IsNaN_8U_23U_1_nor_itm_2 | IsNaN_8U_23U_1_IsNaN_8U_23U_1_nand_itm_2);
  assign IsNaN_8U_23U_1_nor_tmp = ~((chn_b_rsci_d_mxwt[22:0]!=23'b00000000000000000000000));
  assign IsNaN_8U_23U_1_IsNaN_8U_23U_1_nand_tmp = ~((chn_b_rsci_d_mxwt[30:23]==8'b11111111));
  assign nl_FpAdd_8U_23U_is_a_greater_acc_1_nl = ({1'b1 , (chn_b_rsci_d_mxwt[30:23])})
      + conv_u2u_8_9(~ (chn_a_rsci_d_mxwt[30:23])) + 9'b1;
  assign FpAdd_8U_23U_is_a_greater_acc_1_nl = nl_FpAdd_8U_23U_is_a_greater_acc_1_nl[8:0];
  assign FpAdd_8U_23U_is_a_greater_acc_1_itm_8_1 = readslicef_9_1_8((FpAdd_8U_23U_is_a_greater_acc_1_nl));
  assign FpAdd_8U_23U_addend_larger_qr_lpi_1_dfm_mx0 = MUX_v_49_2_2(FpAdd_8U_23U_b_int_mant_p1_sva_2,
      FpAdd_8U_23U_a_int_mant_p1_sva_2, FpAdd_8U_23U_is_a_greater_lor_lpi_1_dfm_5);
  assign FpAdd_8U_23U_addend_smaller_qr_lpi_1_dfm_mx0 = MUX_v_49_2_2(FpAdd_8U_23U_a_int_mant_p1_sva_2,
      FpAdd_8U_23U_b_int_mant_p1_sva_2, FpAdd_8U_23U_is_a_greater_lor_lpi_1_dfm_5);
  assign nl_FpAdd_8U_23U_asn_5_mx0w0 = conv_u2u_49_50(FpAdd_8U_23U_addend_larger_qr_lpi_1_dfm_mx0)
      + conv_u2u_49_50(FpAdd_8U_23U_addend_smaller_qr_lpi_1_dfm_mx0);
  assign FpAdd_8U_23U_asn_5_mx0w0 = nl_FpAdd_8U_23U_asn_5_mx0w0[49:0];
  assign nl_FpAdd_8U_23U_asn_4_mx0w1 = ({1'b1 , (~ FpAdd_8U_23U_addend_smaller_qr_lpi_1_dfm_mx0)})
      + conv_u2u_49_50(FpAdd_8U_23U_addend_larger_qr_lpi_1_dfm_mx0) + 50'b1;
  assign FpAdd_8U_23U_asn_4_mx0w1 = nl_FpAdd_8U_23U_asn_4_mx0w1[49:0];
  assign FpAdd_8U_23U_int_mant_p1_lpi_1_dfm_mx0 = MUX_v_50_2_2(FpAdd_8U_23U_asn_4_mx0w1,
      FpAdd_8U_23U_asn_5_mx0w0, reg_FpAdd_8U_23U_is_addition_FpAdd_8U_23U_is_addition_xnor_svs_2_cse);
  assign nl_FpAdd_8U_23U_if_3_if_acc_1_nl = ({1'b1 , (FpAdd_8U_23U_qr_lpi_1_dfm_6[7:1])})
      + 8'b1;
  assign FpAdd_8U_23U_if_3_if_acc_1_nl = nl_FpAdd_8U_23U_if_3_if_acc_1_nl[7:0];
  assign FpAdd_8U_23U_if_3_if_acc_1_itm_7_1 = readslicef_8_1_7((FpAdd_8U_23U_if_3_if_acc_1_nl));
  assign nl_FpNormalize_8U_49U_else_acc_nl = FpAdd_8U_23U_qr_lpi_1_dfm_6 + ({2'b11
      , (~ libraries_leading_sign_49_0_e47cea887f8a82708c2da9a42282cded83a3_1)})
      + 8'b1;
  assign FpNormalize_8U_49U_else_acc_nl = nl_FpNormalize_8U_49U_else_acc_nl[7:0];
  assign FpNormalize_8U_49U_FpNormalize_8U_49U_and_nl = MUX_v_8_2_2(8'b00000000,
      (FpNormalize_8U_49U_else_acc_nl), FpNormalize_8U_49U_oelse_not_3);
  assign nl_FpAdd_8U_23U_if_3_if_acc_nl = FpAdd_8U_23U_qr_lpi_1_dfm_6 + 8'b1;
  assign FpAdd_8U_23U_if_3_if_acc_nl = nl_FpAdd_8U_23U_if_3_if_acc_nl[7:0];
  assign FpAdd_8U_23U_and_1_nl = (~ FpAdd_8U_23U_if_3_if_acc_1_itm_7_1) & (FpAdd_8U_23U_int_mant_p1_lpi_1_dfm_2[49]);
  assign FpAdd_8U_23U_and_2_nl = FpAdd_8U_23U_if_3_if_acc_1_itm_7_1 & (FpAdd_8U_23U_int_mant_p1_lpi_1_dfm_2[49]);
  assign FpAdd_8U_23U_o_expo_lpi_1_dfm_2 = MUX1HOT_v_8_3_2((FpNormalize_8U_49U_FpNormalize_8U_49U_and_nl),
      FpAdd_8U_23U_qr_lpi_1_dfm_6, (FpAdd_8U_23U_if_3_if_acc_nl), {(~ (FpAdd_8U_23U_int_mant_p1_lpi_1_dfm_2[49]))
      , (FpAdd_8U_23U_and_1_nl) , (FpAdd_8U_23U_and_2_nl)});
  assign FpNormalize_8U_49U_FpNormalize_8U_49U_and_1_nl = MUX_v_49_2_2(49'b0000000000000000000000000000000000000000000000000,
      FpNormalize_8U_49U_else_lshift_itm, FpNormalize_8U_49U_oelse_not_3);
  assign FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0 = MUX_v_49_2_2((FpNormalize_8U_49U_FpNormalize_8U_49U_and_1_nl),
      (FpAdd_8U_23U_int_mant_p1_lpi_1_dfm_2[49:1]), FpAdd_8U_23U_int_mant_p1_lpi_1_dfm_2[49]);
  assign FpMantRNE_49U_24U_else_carry_sva = (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[24])
      & ((FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[0]) | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[1])
      | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[2]) | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[3])
      | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[4]) | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[5])
      | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[6]) | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[7])
      | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[8]) | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[9])
      | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[10]) | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[11])
      | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[12]) | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[13])
      | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[14]) | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[15])
      | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[16]) | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[17])
      | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[18]) | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[19])
      | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[20]) | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[21])
      | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[22]) | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[23])
      | (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[25]));
  assign FpAdd_8U_23U_if_4_FpAdd_8U_23U_if_4_or_nl = FpAdd_8U_23U_is_inf_lpi_1_dfm
      | (~ FpAdd_8U_23U_if_4_if_acc_1_itm_7_1);
  assign FpAdd_8U_23U_is_inf_lpi_1_dfm_2_mx0 = MUX_s_1_2_2(FpAdd_8U_23U_is_inf_lpi_1_dfm,
      (FpAdd_8U_23U_if_4_FpAdd_8U_23U_if_4_or_nl), FpMantRNE_49U_24U_else_and_tmp);
  assign nl_FpAdd_8U_23U_if_4_if_acc_1_nl = ({1'b1 , (FpAdd_8U_23U_o_expo_lpi_1_dfm_2[7:1])})
      + 8'b1;
  assign FpAdd_8U_23U_if_4_if_acc_1_nl = nl_FpAdd_8U_23U_if_4_if_acc_1_nl[7:0];
  assign FpAdd_8U_23U_if_4_if_acc_1_itm_7_1 = readslicef_8_1_7((FpAdd_8U_23U_if_4_if_acc_1_nl));
  assign FpAdd_8U_23U_is_inf_lpi_1_dfm = ~(FpAdd_8U_23U_if_3_if_acc_1_itm_7_1 | (~
      (FpAdd_8U_23U_int_mant_p1_lpi_1_dfm_2[49])));
  assign FpAdd_8U_23U_and_tmp = FpAdd_8U_23U_if_4_if_acc_1_itm_7_1 & FpMantRNE_49U_24U_else_and_tmp;
  assign FpAdd_8U_23U_FpAdd_8U_23U_nor_2_m1c = ~(IsNaN_8U_23U_1_land_lpi_1_dfm_4
      | IsNaN_8U_23U_land_lpi_1_dfm_6);
  assign FpMantRNE_49U_24U_else_and_tmp = FpMantRNE_49U_24U_else_carry_sva & (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[48:25]==24'b111111111111111111111111);
  assign or_cse = chn_o_rsci_bawt | (~ reg_chn_o_rsci_ld_core_psct_cse);
  assign main_stage_en_1 = chn_a_rsci_bawt & chn_b_rsci_bawt & or_cse;
  assign nl_FpAdd_8U_23U_b_right_shift_qif_acc_nl = (FpSignedBitsToFloat_8U_23U_bits_sva_36[30:23])
      - (FpSignedBitsToFloat_8U_23U_bits_1_sva_36[30:23]);
  assign FpAdd_8U_23U_b_right_shift_qif_acc_nl = nl_FpAdd_8U_23U_b_right_shift_qif_acc_nl[7:0];
  assign FpAdd_8U_23U_b_right_shift_qr_lpi_1_dfm = MUX_v_8_2_2(8'b00000000, (FpAdd_8U_23U_b_right_shift_qif_acc_nl),
      FpAdd_8U_23U_is_a_greater_lor_lpi_1_dfm_4);
  assign nl_FpAdd_8U_23U_a_right_shift_qelse_acc_nl = (FpSignedBitsToFloat_8U_23U_bits_1_sva_36[30:23])
      - (FpSignedBitsToFloat_8U_23U_bits_sva_36[30:23]);
  assign FpAdd_8U_23U_a_right_shift_qelse_acc_nl = nl_FpAdd_8U_23U_a_right_shift_qelse_acc_nl[7:0];
  assign FpAdd_8U_23U_is_a_greater_oelse_not_5_nl = ~ FpAdd_8U_23U_is_a_greater_lor_lpi_1_dfm_4;
  assign FpAdd_8U_23U_a_right_shift_qr_lpi_1_dfm = MUX_v_8_2_2(8'b00000000, (FpAdd_8U_23U_a_right_shift_qelse_acc_nl),
      (FpAdd_8U_23U_is_a_greater_oelse_not_5_nl));
  assign nl_FpNormalize_8U_49U_acc_nl = ({1'b1 , (~ FpAdd_8U_23U_qr_lpi_1_dfm_6)})
      + conv_u2s_6_9(libraries_leading_sign_49_0_e47cea887f8a82708c2da9a42282cded83a3_1)
      + 9'b1;
  assign FpNormalize_8U_49U_acc_nl = nl_FpNormalize_8U_49U_acc_nl[8:0];
  assign FpNormalize_8U_49U_oelse_not_3 = FpNormalize_8U_49U_if_or_itm_2 & (readslicef_9_1_8((FpNormalize_8U_49U_acc_nl)));
  assign FpAdd_8U_23U_mux_2_tmp_49 = MUX_s_1_2_2((FpAdd_8U_23U_asn_4_mx0w1[49]),
      (FpAdd_8U_23U_asn_5_mx0w0[49]), reg_FpAdd_8U_23U_is_addition_FpAdd_8U_23U_is_addition_xnor_svs_2_cse);
  assign nor_tmp_1 = chn_a_rsci_bawt & chn_b_rsci_bawt;
  assign or_tmp_3 = nor_36_cse | main_stage_v_2;
  assign nor_38_nl = ~(reg_chn_o_rsci_ld_core_psct_cse | (~ main_stage_v_2));
  assign mux_tmp_5 = MUX_s_1_2_2((nor_38_nl), main_stage_v_2, chn_o_rsci_bawt);
  assign nor_tmp_11 = (IsNaN_8U_23U_1_land_lpi_1_dfm_3 | IsNaN_8U_23U_land_lpi_1_dfm_5)
      & main_stage_v_2;
  assign or_tmp_16 = IsNaN_8U_23U_1_nor_itm_2 | IsNaN_8U_23U_1_IsNaN_8U_23U_1_nand_itm_2;
  assign and_dcpl_7 = reg_chn_o_rsci_ld_core_psct_cse & (~ chn_o_rsci_bawt);
  assign and_dcpl_13 = or_cse & main_stage_v_3;
  assign and_dcpl_14 = reg_chn_o_rsci_ld_core_psct_cse & chn_o_rsci_bawt;
  assign and_dcpl_15 = and_dcpl_14 & (~ main_stage_v_3);
  assign and_dcpl_28 = or_cse & (~ IsNaN_8U_23U_land_lpi_1_dfm_st_4);
  assign and_dcpl_29 = or_cse & IsNaN_8U_23U_land_lpi_1_dfm_st_4;
  assign and_dcpl_33 = or_cse & (~ FpAdd_8U_23U_is_a_greater_acc_1_itm_8_1) & (FpAdd_8U_23U_is_a_greater_oif_aelse_acc_itm_23_1
      | (~ FpAdd_8U_23U_is_a_greater_oif_equal_tmp));
  assign or_tmp_29 = main_stage_en_1 | (fsm_output[0]);
  assign or_tmp_35 = chn_b_rsci_bawt & chn_a_rsci_bawt & or_cse & (fsm_output[1]);
  assign chn_o_rsci_d_22_0_mx0c1 = or_cse & main_stage_v_3 & (~ IsNaN_8U_23U_land_lpi_1_dfm_6);
  assign main_stage_v_1_mx0c1 = (~(chn_b_rsci_bawt & chn_a_rsci_bawt)) & main_stage_v_1
      & or_cse;
  assign main_stage_v_2_mx0c1 = main_stage_v_2 & (~ main_stage_v_1) & or_cse;
  assign main_stage_v_3_mx0c1 = or_cse & (~ main_stage_v_2) & main_stage_v_3;
  assign nl_FpAdd_8U_23U_is_a_greater_oif_aelse_acc_nl = ({1'b1 , (chn_a_rsci_d_mxwt[22:0])})
      + conv_u2u_23_24(~ (chn_b_rsci_d_mxwt[22:0])) + 24'b1;
  assign FpAdd_8U_23U_is_a_greater_oif_aelse_acc_nl = nl_FpAdd_8U_23U_is_a_greater_oif_aelse_acc_nl[23:0];
  assign FpAdd_8U_23U_is_a_greater_oif_aelse_acc_itm_23_1 = readslicef_24_1_23((FpAdd_8U_23U_is_a_greater_oif_aelse_acc_nl));
  assign chn_a_rsci_oswt_unreg_pff = or_tmp_35;
  assign chn_o_rsci_oswt_unreg = and_dcpl_14;
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_chn_b_rsci_iswt0_cse <= 1'b0;
      chn_o_rsci_iswt0 <= 1'b0;
    end
    else if ( core_wen ) begin
      reg_chn_b_rsci_iswt0_cse <= ~((~ main_stage_en_1) & (fsm_output[1]));
      chn_o_rsci_iswt0 <= and_dcpl_13;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_chn_b_rsci_ld_core_psct_cse <= 1'b0;
    end
    else if ( core_wen & or_tmp_29 ) begin
      reg_chn_b_rsci_ld_core_psct_cse <= or_tmp_29;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_o_rsci_d_22_0 <= 23'b0;
    end
    else if ( core_wen & ((or_cse & main_stage_v_3 & IsNaN_8U_23U_land_lpi_1_dfm_6)
        | chn_o_rsci_d_22_0_mx0c1) ) begin
      chn_o_rsci_d_22_0 <= MUX_v_23_2_2(FpSignedBitsToFloat_8U_23U_1_slc_FpSignedBitsToFloat_8U_23U_1_ubits_22_0_itm_4,
          (FpAdd_8U_23U_FpAdd_8U_23U_or_1_nl), FpSignedBitsToFloat_8U_23U_1_and_nl);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_o_rsci_d_30_23 <= 8'b0;
      chn_o_rsci_d_31 <= 1'b0;
    end
    else if ( chn_o_and_1_cse ) begin
      chn_o_rsci_d_30_23 <= MUX1HOT_v_8_4_2(FpAdd_8U_23U_o_expo_lpi_1_dfm_2, (FpAdd_8U_23U_if_4_if_acc_nl),
          8'b11111110, FpSignedBitsToFloat_8U_23U_1_slc_FpSignedBitsToFloat_8U_23U_1_ubits_30_23_itm_4,
          {(FpAdd_8U_23U_and_nl) , (FpAdd_8U_23U_and_3_nl) , (FpAdd_8U_23U_and_7_nl)
          , FpAdd_8U_23U_or_cse});
      chn_o_rsci_d_31 <= FpAdd_8U_23U_mux_13_itm_4;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_chn_o_rsci_ld_core_psct_cse <= 1'b0;
    end
    else if ( core_wen & (and_dcpl_13 | and_dcpl_15) ) begin
      reg_chn_o_rsci_ld_core_psct_cse <= ~ and_dcpl_15;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      main_stage_v_1 <= 1'b0;
    end
    else if ( core_wen & (or_tmp_35 | main_stage_v_1_mx0c1) ) begin
      main_stage_v_1 <= ~ main_stage_v_1_mx0c1;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      IsNaN_8U_23U_land_lpi_1_dfm_st_4 <= 1'b0;
      FpAdd_8U_23U_is_a_greater_lor_lpi_1_dfm_4 <= 1'b0;
      FpAdd_8U_23U_is_addition_FpAdd_8U_23U_is_addition_xnor_svs_3 <= 1'b0;
      FpSignedBitsToFloat_8U_23U_bits_sva_36 <= 32'b0;
      FpSignedBitsToFloat_8U_23U_bits_1_sva_36 <= 32'b0;
      FpAdd_8U_23U_IsZero_8U_23U_1_or_itm_2 <= 1'b0;
      FpAdd_8U_23U_IsZero_8U_23U_or_itm_2 <= 1'b0;
    end
    else if ( IsNaN_8U_23U_aelse_and_cse ) begin
      IsNaN_8U_23U_land_lpi_1_dfm_st_4 <= IsNaN_8U_23U_IsNaN_8U_23U_nor_tmp;
      FpAdd_8U_23U_is_a_greater_lor_lpi_1_dfm_4 <= FpAdd_8U_23U_is_a_greater_FpAdd_8U_23U_is_a_greater_or_cse;
      FpAdd_8U_23U_is_addition_FpAdd_8U_23U_is_addition_xnor_svs_3 <= ~((chn_a_rsci_d_mxwt[31])
          ^ (chn_b_rsci_d_mxwt[31]));
      FpSignedBitsToFloat_8U_23U_bits_sva_36 <= chn_a_rsci_d_mxwt;
      FpSignedBitsToFloat_8U_23U_bits_1_sva_36 <= chn_b_rsci_d_mxwt;
      FpAdd_8U_23U_IsZero_8U_23U_1_or_itm_2 <= (chn_b_rsci_d_mxwt[30:0]!=31'b0000000000000000000000000000000);
      FpAdd_8U_23U_IsZero_8U_23U_or_itm_2 <= (chn_a_rsci_d_mxwt[30:0]!=31'b0000000000000000000000000000000);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      main_stage_v_2 <= 1'b0;
    end
    else if ( core_wen & ((or_cse & main_stage_v_1) | main_stage_v_2_mx0c1) ) begin
      main_stage_v_2 <= ~ main_stage_v_2_mx0c1;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_FpAdd_8U_23U_is_addition_FpAdd_8U_23U_is_addition_xnor_svs_2_cse <= 1'b0;
      FpAdd_8U_23U_a_int_mant_p1_sva_2 <= 49'b0;
      FpAdd_8U_23U_b_int_mant_p1_sva_2 <= 49'b0;
      FpAdd_8U_23U_is_a_greater_lor_lpi_1_dfm_5 <= 1'b0;
      IsNaN_8U_23U_1_land_lpi_1_dfm_3 <= 1'b0;
      FpAdd_8U_23U_qr_lpi_1_dfm_5 <= 8'b0;
      IsNaN_8U_23U_land_lpi_1_dfm_5 <= 1'b0;
    end
    else if ( FpAdd_8U_23U_is_addition_and_cse ) begin
      reg_FpAdd_8U_23U_is_addition_FpAdd_8U_23U_is_addition_xnor_svs_2_cse <= FpAdd_8U_23U_is_addition_FpAdd_8U_23U_is_addition_xnor_svs_3;
      FpAdd_8U_23U_a_int_mant_p1_sva_2 <= FpAdd_8U_23U_a_int_mant_p1_lshift_itm;
      FpAdd_8U_23U_b_int_mant_p1_sva_2 <= FpAdd_8U_23U_b_int_mant_p1_lshift_itm;
      FpAdd_8U_23U_is_a_greater_lor_lpi_1_dfm_5 <= FpAdd_8U_23U_is_a_greater_lor_lpi_1_dfm_4;
      IsNaN_8U_23U_1_land_lpi_1_dfm_3 <= IsNaN_8U_23U_1_land_lpi_1_dfm_mx0w0;
      FpAdd_8U_23U_qr_lpi_1_dfm_5 <= FpAdd_8U_23U_qr_lpi_1_dfm_4;
      IsNaN_8U_23U_land_lpi_1_dfm_5 <= IsNaN_8U_23U_land_lpi_1_dfm_st_4;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      main_stage_v_3 <= 1'b0;
    end
    else if ( core_wen & ((or_cse & main_stage_v_2) | main_stage_v_3_mx0c1) ) begin
      main_stage_v_3 <= ~ main_stage_v_3_mx0c1;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpAdd_8U_23U_qr_lpi_1_dfm_6 <= 8'b0;
      FpAdd_8U_23U_int_mant_p1_lpi_1_dfm_2 <= 50'b0;
      IsNaN_8U_23U_1_land_lpi_1_dfm_4 <= 1'b0;
      FpAdd_8U_23U_mux_13_itm_4 <= 1'b0;
      IsNaN_8U_23U_land_lpi_1_dfm_6 <= 1'b0;
    end
    else if ( FpAdd_8U_23U_and_8_cse ) begin
      FpAdd_8U_23U_qr_lpi_1_dfm_6 <= FpAdd_8U_23U_qr_lpi_1_dfm_5;
      FpAdd_8U_23U_int_mant_p1_lpi_1_dfm_2 <= FpAdd_8U_23U_int_mant_p1_lpi_1_dfm_mx0;
      IsNaN_8U_23U_1_land_lpi_1_dfm_4 <= IsNaN_8U_23U_1_land_lpi_1_dfm_3;
      FpAdd_8U_23U_mux_13_itm_4 <= FpAdd_8U_23U_mux_13_itm_3;
      IsNaN_8U_23U_land_lpi_1_dfm_6 <= IsNaN_8U_23U_land_lpi_1_dfm_5;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpNormalize_8U_49U_if_or_itm_2 <= 1'b0;
    end
    else if ( core_wen & (~ and_dcpl_7) & (mux_8_nl) ) begin
      FpNormalize_8U_49U_if_or_itm_2 <= (FpAdd_8U_23U_int_mant_p1_lpi_1_dfm_mx0[48:0]!=49'b0000000000000000000000000000000000000000000000000);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpSignedBitsToFloat_8U_23U_1_slc_FpSignedBitsToFloat_8U_23U_1_ubits_22_0_itm_4
          <= 23'b0;
      FpSignedBitsToFloat_8U_23U_1_slc_FpSignedBitsToFloat_8U_23U_1_ubits_30_23_itm_4
          <= 8'b0;
    end
    else if ( FpSignedBitsToFloat_8U_23U_1_and_1_cse ) begin
      FpSignedBitsToFloat_8U_23U_1_slc_FpSignedBitsToFloat_8U_23U_1_ubits_22_0_itm_4
          <= FpSignedBitsToFloat_8U_23U_1_slc_FpSignedBitsToFloat_8U_23U_1_ubits_22_0_itm_3;
      FpSignedBitsToFloat_8U_23U_1_slc_FpSignedBitsToFloat_8U_23U_1_ubits_30_23_itm_4
          <= FpSignedBitsToFloat_8U_23U_1_slc_FpSignedBitsToFloat_8U_23U_1_ubits_30_23_itm_3;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpSignedBitsToFloat_8U_23U_1_slc_FpSignedBitsToFloat_8U_23U_1_ubits_22_0_itm_3
          <= 23'b0;
    end
    else if ( core_wen & FpSignedBitsToFloat_8U_23U_1_FpSignedBitsToFloat_8U_23U_1_or_1_cse
        & (mux_23_nl) ) begin
      FpSignedBitsToFloat_8U_23U_1_slc_FpSignedBitsToFloat_8U_23U_1_ubits_22_0_itm_3
          <= MUX_v_23_2_2((FpSignedBitsToFloat_8U_23U_bits_1_sva_36[22:0]), (FpSignedBitsToFloat_8U_23U_bits_sva_36[22:0]),
          and_dcpl_29);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpSignedBitsToFloat_8U_23U_1_slc_FpSignedBitsToFloat_8U_23U_1_ubits_30_23_itm_3
          <= 8'b0;
    end
    else if ( core_wen & FpSignedBitsToFloat_8U_23U_1_FpSignedBitsToFloat_8U_23U_1_or_1_cse
        & (mux_25_nl) ) begin
      FpSignedBitsToFloat_8U_23U_1_slc_FpSignedBitsToFloat_8U_23U_1_ubits_30_23_itm_3
          <= MUX_v_8_2_2((FpSignedBitsToFloat_8U_23U_bits_1_sva_36[30:23]), (FpSignedBitsToFloat_8U_23U_bits_sva_36[30:23]),
          and_dcpl_29);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpAdd_8U_23U_mux_13_itm_3 <= 1'b0;
    end
    else if ( core_wen & (and_dcpl_29 | FpSignedBitsToFloat_8U_23U_and_rgt | FpSignedBitsToFloat_8U_23U_and_1_rgt)
        & mux_4_cse ) begin
      FpAdd_8U_23U_mux_13_itm_3 <= MUX1HOT_s_1_3_2((FpSignedBitsToFloat_8U_23U_bits_sva_36[31]),
          FpAdd_8U_23U_mux_1_itm_2, (FpSignedBitsToFloat_8U_23U_bits_1_sva_36[31]),
          {and_dcpl_29 , FpSignedBitsToFloat_8U_23U_and_rgt , FpSignedBitsToFloat_8U_23U_and_1_rgt});
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpAdd_8U_23U_qr_lpi_1_dfm_4 <= 8'b0;
    end
    else if ( core_wen & FpSignedBitsToFloat_8U_23U_FpAdd_8U_23U_or_1_cse & mux_13_cse
        ) begin
      FpAdd_8U_23U_qr_lpi_1_dfm_4 <= MUX_v_8_2_2((chn_a_rsci_d_mxwt[30:23]), (chn_b_rsci_d_mxwt[30:23]),
          and_dcpl_33);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpAdd_8U_23U_mux_1_itm_2 <= 1'b0;
    end
    else if ( core_wen & FpSignedBitsToFloat_8U_23U_FpAdd_8U_23U_or_1_cse & (mux_27_nl)
        ) begin
      FpAdd_8U_23U_mux_1_itm_2 <= MUX_s_1_2_2((chn_a_rsci_d_mxwt[31]), (chn_b_rsci_d_mxwt[31]),
          and_dcpl_33);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      IsNaN_8U_23U_1_nor_itm_2 <= 1'b0;
      IsNaN_8U_23U_1_IsNaN_8U_23U_1_nand_itm_2 <= 1'b0;
    end
    else if ( IsNaN_8U_23U_1_and_cse ) begin
      IsNaN_8U_23U_1_nor_itm_2 <= IsNaN_8U_23U_1_nor_tmp;
      IsNaN_8U_23U_1_IsNaN_8U_23U_1_nand_itm_2 <= IsNaN_8U_23U_1_IsNaN_8U_23U_1_nand_tmp;
    end
  end
  assign nl_FpMantRNE_49U_24U_else_acc_nl = (FpAdd_8U_23U_int_mant_1_lpi_1_dfm_2_mx0[47:25])
      + conv_u2u_1_23(FpMantRNE_49U_24U_else_carry_sva);
  assign FpMantRNE_49U_24U_else_acc_nl = nl_FpMantRNE_49U_24U_else_acc_nl[22:0];
  assign FpAdd_8U_23U_FpAdd_8U_23U_or_1_nl = MUX_v_23_2_2((FpMantRNE_49U_24U_else_acc_nl),
      23'b11111111111111111111111, FpAdd_8U_23U_is_inf_lpi_1_dfm_2_mx0);
  assign FpSignedBitsToFloat_8U_23U_1_and_nl = (~ IsNaN_8U_23U_1_land_lpi_1_dfm_4)
      & chn_o_rsci_d_22_0_mx0c1;
  assign nl_FpAdd_8U_23U_if_4_if_acc_nl = FpAdd_8U_23U_o_expo_lpi_1_dfm_2 + 8'b1;
  assign FpAdd_8U_23U_if_4_if_acc_nl = nl_FpAdd_8U_23U_if_4_if_acc_nl[7:0];
  assign FpAdd_8U_23U_and_nl = (~(FpAdd_8U_23U_and_tmp | FpAdd_8U_23U_is_inf_lpi_1_dfm_2_mx0))
      & FpAdd_8U_23U_FpAdd_8U_23U_nor_2_m1c;
  assign FpAdd_8U_23U_and_3_nl = FpAdd_8U_23U_and_tmp & (~ FpAdd_8U_23U_is_inf_lpi_1_dfm_2_mx0)
      & FpAdd_8U_23U_FpAdd_8U_23U_nor_2_m1c;
  assign FpAdd_8U_23U_and_7_nl = FpAdd_8U_23U_is_inf_lpi_1_dfm_2_mx0 & FpAdd_8U_23U_FpAdd_8U_23U_nor_2_m1c;
  assign mux_7_nl = MUX_s_1_2_2(or_tmp_3, nor_36_cse, FpAdd_8U_23U_mux_2_tmp_49);
  assign nor_37_nl = ~(FpAdd_8U_23U_mux_2_tmp_49 | (~ mux_tmp_5));
  assign nor_7_nl = ~((FpAdd_8U_23U_int_mant_p1_lpi_1_dfm_2[49]) | (~ main_stage_v_3));
  assign mux_8_nl = MUX_s_1_2_2((nor_37_nl), (mux_7_nl), nor_7_nl);
  assign nor_31_nl = ~(IsNaN_8U_23U_1_nor_itm_2 | IsNaN_8U_23U_1_IsNaN_8U_23U_1_nand_itm_2
      | (~ main_stage_v_1));
  assign mux_22_nl = MUX_s_1_2_2((nor_31_nl), main_stage_v_1, IsNaN_8U_23U_land_lpi_1_dfm_st_4);
  assign mux_23_nl = MUX_s_1_2_2((mux_22_nl), nor_tmp_11, nor_36_cse);
  assign nor_32_nl = ~(or_tmp_16 | (~ main_stage_v_1));
  assign mux_24_nl = MUX_s_1_2_2((nor_32_nl), main_stage_v_1, IsNaN_8U_23U_land_lpi_1_dfm_st_4);
  assign mux_25_nl = MUX_s_1_2_2((mux_24_nl), nor_tmp_11, nor_36_cse);
  assign nor_28_nl = ~(IsNaN_8U_23U_land_lpi_1_dfm_st_4 | (~(or_tmp_16 & main_stage_v_1)));
  assign nor_29_nl = ~((~(IsNaN_8U_23U_1_IsNaN_8U_23U_1_nand_tmp | IsNaN_8U_23U_1_nor_tmp))
      | IsNaN_8U_23U_IsNaN_8U_23U_nor_tmp | (~ nor_tmp_1));
  assign mux_27_nl = MUX_s_1_2_2((nor_29_nl), (nor_28_nl), nor_36_cse);

  function [0:0] MUX1HOT_s_1_3_2;
    input [0:0] input_2;
    input [0:0] input_1;
    input [0:0] input_0;
    input [2:0] sel;
    reg [0:0] result;
  begin
    result = input_0 & {1{sel[0]}};
    result = result | ( input_1 & {1{sel[1]}});
    result = result | ( input_2 & {1{sel[2]}});
    MUX1HOT_s_1_3_2 = result;
  end
  endfunction


  function [7:0] MUX1HOT_v_8_3_2;
    input [7:0] input_2;
    input [7:0] input_1;
    input [7:0] input_0;
    input [2:0] sel;
    reg [7:0] result;
  begin
    result = input_0 & {8{sel[0]}};
    result = result | ( input_1 & {8{sel[1]}});
    result = result | ( input_2 & {8{sel[2]}});
    MUX1HOT_v_8_3_2 = result;
  end
  endfunction


  function [7:0] MUX1HOT_v_8_4_2;
    input [7:0] input_3;
    input [7:0] input_2;
    input [7:0] input_1;
    input [7:0] input_0;
    input [3:0] sel;
    reg [7:0] result;
  begin
    result = input_0 & {8{sel[0]}};
    result = result | ( input_1 & {8{sel[1]}});
    result = result | ( input_2 & {8{sel[2]}});
    result = result | ( input_3 & {8{sel[3]}});
    MUX1HOT_v_8_4_2 = result;
  end
  endfunction


  function [0:0] MUX_s_1_2_2;
    input [0:0] input_0;
    input [0:0] input_1;
    input [0:0] sel;
    reg [0:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_s_1_2_2 = result;
  end
  endfunction


  function [22:0] MUX_v_23_2_2;
    input [22:0] input_0;
    input [22:0] input_1;
    input [0:0] sel;
    reg [22:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_23_2_2 = result;
  end
  endfunction


  function [48:0] MUX_v_49_2_2;
    input [48:0] input_0;
    input [48:0] input_1;
    input [0:0] sel;
    reg [48:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_49_2_2 = result;
  end
  endfunction


  function [49:0] MUX_v_50_2_2;
    input [49:0] input_0;
    input [49:0] input_1;
    input [0:0] sel;
    reg [49:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_50_2_2 = result;
  end
  endfunction


  function [7:0] MUX_v_8_2_2;
    input [7:0] input_0;
    input [7:0] input_1;
    input [0:0] sel;
    reg [7:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_8_2_2 = result;
  end
  endfunction


  function [0:0] readslicef_24_1_23;
    input [23:0] vector;
    reg [23:0] tmp;
  begin
    tmp = vector >> 23;
    readslicef_24_1_23 = tmp[0:0];
  end
  endfunction


  function [0:0] readslicef_8_1_7;
    input [7:0] vector;
    reg [7:0] tmp;
  begin
    tmp = vector >> 7;
    readslicef_8_1_7 = tmp[0:0];
  end
  endfunction


  function [0:0] readslicef_9_1_8;
    input [8:0] vector;
    reg [8:0] tmp;
  begin
    tmp = vector >> 8;
    readslicef_9_1_8 = tmp[0:0];
  end
  endfunction


  function  [8:0] conv_u2s_6_9 ;
    input [5:0]  vector ;
  begin
    conv_u2s_6_9 = {{3{1'b0}}, vector};
  end
  endfunction


  function  [22:0] conv_u2u_1_23 ;
    input [0:0]  vector ;
  begin
    conv_u2u_1_23 = {{22{1'b0}}, vector};
  end
  endfunction


  function  [8:0] conv_u2u_8_9 ;
    input [7:0]  vector ;
  begin
    conv_u2u_8_9 = {1'b0, vector};
  end
  endfunction


  function  [23:0] conv_u2u_23_24 ;
    input [22:0]  vector ;
  begin
    conv_u2u_23_24 = {1'b0, vector};
  end
  endfunction


  function  [49:0] conv_u2u_49_50 ;
    input [48:0]  vector ;
  begin
    conv_u2u_49_50 = {1'b0, vector};
  end
  endfunction

endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_fp32_add
// ------------------------------------------------------------------


module HLS_fp32_add (
  nvdla_core_clk, nvdla_core_rstn, chn_a_rsc_z, chn_a_rsc_vz, chn_a_rsc_lz, chn_b_rsc_z,
      chn_b_rsc_vz, chn_b_rsc_lz, chn_o_rsc_z, chn_o_rsc_vz, chn_o_rsc_lz
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [31:0] chn_a_rsc_z;
  input chn_a_rsc_vz;
  output chn_a_rsc_lz;
  input [31:0] chn_b_rsc_z;
  input chn_b_rsc_vz;
  output chn_b_rsc_lz;
  output [31:0] chn_o_rsc_z;
  input chn_o_rsc_vz;
  output chn_o_rsc_lz;


  // Interconnect Declarations
  wire chn_a_rsci_oswt;
  wire chn_b_rsci_oswt;
  wire chn_o_rsci_oswt;
  wire chn_o_rsci_oswt_unreg;
  wire chn_a_rsci_oswt_unreg_iff;


  // Interconnect Declarations for Component Instantiations 
  FP32_ADD_chn_a_rsci_unreg chn_a_rsci_unreg_inst (
      .in_0(chn_a_rsci_oswt_unreg_iff),
      .outsig(chn_a_rsci_oswt)
    );
  FP32_ADD_chn_b_rsci_unreg chn_b_rsci_unreg_inst (
      .in_0(chn_a_rsci_oswt_unreg_iff),
      .outsig(chn_b_rsci_oswt)
    );
  FP32_ADD_chn_o_rsci_unreg chn_o_rsci_unreg_inst (
      .in_0(chn_o_rsci_oswt_unreg),
      .outsig(chn_o_rsci_oswt)
    );
  HLS_fp32_add_core HLS_fp32_add_core_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_a_rsc_z(chn_a_rsc_z),
      .chn_a_rsc_vz(chn_a_rsc_vz),
      .chn_a_rsc_lz(chn_a_rsc_lz),
      .chn_b_rsc_z(chn_b_rsc_z),
      .chn_b_rsc_vz(chn_b_rsc_vz),
      .chn_b_rsc_lz(chn_b_rsc_lz),
      .chn_o_rsc_z(chn_o_rsc_z),
      .chn_o_rsc_vz(chn_o_rsc_vz),
      .chn_o_rsc_lz(chn_o_rsc_lz),
      .chn_a_rsci_oswt(chn_a_rsci_oswt),
      .chn_b_rsci_oswt(chn_b_rsci_oswt),
      .chn_o_rsci_oswt(chn_o_rsci_oswt),
      .chn_o_rsci_oswt_unreg(chn_o_rsci_oswt_unreg),
      .chn_a_rsci_oswt_unreg_pff(chn_a_rsci_oswt_unreg_iff)
    );
endmodule



