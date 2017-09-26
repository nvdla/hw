// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_CORE_Y_cvt.v

module SDP_Y_CVT_mgc_in_wire_wait_v1 (ld, vd, d, lz, vz, z);

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


//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/siflibs/SDP_Y_CVT_mgc_out_stdreg_wait_v1.v 
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


module SDP_Y_CVT_mgc_out_stdreg_wait_v1 (ld, vd, d, lz, vz, z);

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



//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/siflibs/SDP_Y_CVT_mgc_in_wire_v1.v 
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


module SDP_Y_CVT_mgc_in_wire_v1 (d, z);

  parameter integer rscid = 1;
  parameter integer width = 8;

  output [width-1:0] d;
  input  [width-1:0] z;

  wire   [width-1:0] d;

  assign d = z;

endmodule


//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/siflibs/mgc_shift_r_beh_v4.v 
module SDP_Y_CVT_mgc_shift_r_v4(a,s,z);
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
       assign z = fshr_u(a,s,a[width_a-1]);
     end
     else
     begin: UNSIGNED
       assign z = fshr_u(a,s,1'b0);
     end
   endgenerate

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

endmodule

//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/siflibs/mgc_shift_l_beh_v4.v 
module SDP_Y_CVT_mgc_shift_l_v4(a,s,z);
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

//------> ../td_ccore_solutions/leading_sign_23_0_aebf38bbf639c970da88b55f070b6a2d5444_0/rtl.v 
// ----------------------------------------------------------------------
//  HLS HDL:        Verilog Netlister
//  HLS Version:    10.0/264918 Production Release
//  HLS Date:       Mon Aug  8 13:35:54 PDT 2016
// 
//  Generated by:   ezhang@hk-sim-10-192
//  Generated date: Thu Dec  8 22:25:07 2016
// ----------------------------------------------------------------------

// 
// ------------------------------------------------------------------
//  Design Unit:    SDP_Y_CVT_leading_sign_23_0
// ------------------------------------------------------------------


module SDP_Y_CVT_leading_sign_23_0 (
  mantissa, rtn
);
  input [22:0] mantissa;
  output [4:0] rtn;


  // Interconnect Declarations
  wire IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_6_2_sdt_2;
  wire IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_18_3_sdt_3;
  wire IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_26_2_sdt_2;
  wire IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_42_4_sdt_4;
  wire IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_50_2_sdt_2;
  wire IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_6_2_sdt_1;
  wire IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_14_2_sdt_1;
  wire IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_26_2_sdt_1;
  wire IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_34_2_sdt_1;
  wire IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_50_2_sdt_1;
  wire IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_56_2_sdt_1;
  wire c_h_1_2;
  wire c_h_1_5;
  wire c_h_1_6;
  wire c_h_1_9;
  wire c_h_1_10;

  wire[0:0] IntLeadZero_23U_leading_sign_23_0_rtn_and_85_nl;
  wire[0:0] IntLeadZero_23U_leading_sign_23_0_rtn_and_83_nl;
  wire[0:0] IntLeadZero_23U_leading_sign_23_0_rtn_and_90_nl;
  wire[0:0] IntLeadZero_23U_leading_sign_23_0_rtn_IntLeadZero_23U_leading_sign_23_0_rtn_or_2_nl;

  // Interconnect Declarations for Component Instantiations 
  assign IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_6_2_sdt_2 = ~((mantissa[20:19]!=2'b00));
  assign IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_6_2_sdt_1 = ~((mantissa[22:21]!=2'b00));
  assign IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_14_2_sdt_1 = ~((mantissa[18:17]!=2'b00));
  assign c_h_1_2 = IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_6_2_sdt_1 & IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_6_2_sdt_2;
  assign IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_18_3_sdt_3 = (mantissa[16:15]==2'b00)
      & IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_14_2_sdt_1;
  assign IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_26_2_sdt_2 = ~((mantissa[12:11]!=2'b00));
  assign IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_26_2_sdt_1 = ~((mantissa[14:13]!=2'b00));
  assign IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_34_2_sdt_1 = ~((mantissa[10:9]!=2'b00));
  assign c_h_1_5 = IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_26_2_sdt_1 & IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_26_2_sdt_2;
  assign c_h_1_6 = c_h_1_2 & IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_18_3_sdt_3;
  assign IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_42_4_sdt_4 = (mantissa[8:7]==2'b00)
      & IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_34_2_sdt_1 & c_h_1_5;
  assign IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_50_2_sdt_2 = ~((mantissa[4:3]!=2'b00));
  assign IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_50_2_sdt_1 = ~((mantissa[6:5]!=2'b00));
  assign IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_56_2_sdt_1 = ~((mantissa[2:1]!=2'b00));
  assign c_h_1_9 = IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_50_2_sdt_1 & IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_50_2_sdt_2;
  assign c_h_1_10 = c_h_1_6 & IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_42_4_sdt_4;
  assign IntLeadZero_23U_leading_sign_23_0_rtn_and_85_nl = c_h_1_6 & (~ IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_42_4_sdt_4);
  assign IntLeadZero_23U_leading_sign_23_0_rtn_and_83_nl = c_h_1_2 & (c_h_1_5 | (~
      IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_18_3_sdt_3)) & (c_h_1_9 | (~ c_h_1_10));
  assign IntLeadZero_23U_leading_sign_23_0_rtn_and_90_nl = IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_6_2_sdt_1
      & (IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_14_2_sdt_1 | (~ IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_6_2_sdt_2))
      & (~((~(IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_26_2_sdt_1 & (IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_34_2_sdt_1
      | (~ IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_26_2_sdt_2)))) & c_h_1_6))
      & (~((~(IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_50_2_sdt_1 & (IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_56_2_sdt_1
      | (~ IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_50_2_sdt_2)))) & c_h_1_10));
  assign IntLeadZero_23U_leading_sign_23_0_rtn_IntLeadZero_23U_leading_sign_23_0_rtn_or_2_nl
      = ((~((mantissa[22]) | (~((mantissa[21:20]!=2'b01))))) & (~(((mantissa[18])
      | (~((mantissa[17:16]!=2'b01)))) & c_h_1_2)) & (~((~((~((mantissa[14]) | (~((mantissa[13:12]!=2'b01)))))
      & (~(((mantissa[10]) | (~((mantissa[9:8]!=2'b01)))) & c_h_1_5)))) & c_h_1_6))
      & (~((~((~((mantissa[6]) | (~((mantissa[5:4]!=2'b01))))) & (~((~((mantissa[2:1]==2'b01)))
      & c_h_1_9)))) & c_h_1_10))) | ((~ (mantissa[0])) & IntLeadZero_23U_leading_sign_23_0_rtn_wrs_c_56_2_sdt_1
      & c_h_1_9 & c_h_1_10);
  assign rtn = {c_h_1_10 , (IntLeadZero_23U_leading_sign_23_0_rtn_and_85_nl) , (IntLeadZero_23U_leading_sign_23_0_rtn_and_83_nl)
      , (IntLeadZero_23U_leading_sign_23_0_rtn_and_90_nl) , (IntLeadZero_23U_leading_sign_23_0_rtn_IntLeadZero_23U_leading_sign_23_0_rtn_or_2_nl)};
endmodule




//------> ./rtl.v 
// ----------------------------------------------------------------------
//  HLS HDL:        Verilog Netlister
//  HLS Version:    10.0/264918 Production Release
//  HLS Date:       Mon Aug  8 13:35:54 PDT 2016
// 
//  Generated by:   ezhang@hk-sim-10-089
//  Generated date: Thu Jul  6 10:55:20 2017
// ----------------------------------------------------------------------

// 
// ------------------------------------------------------------------
//  Design Unit:    SDP_Y_CVT_chn_out_rsci_unreg
// ------------------------------------------------------------------


module SDP_Y_CVT_chn_out_rsci_unreg (
  in_0, outsig
);
  input in_0;
  output outsig;



  // Interconnect Declarations for Component Instantiations 
  assign outsig = in_0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    SDP_Y_CVT_chn_in_rsci_unreg
// ------------------------------------------------------------------


module SDP_Y_CVT_chn_in_rsci_unreg (
  in_0, outsig
);
  input in_0;
  output outsig;



  // Interconnect Declarations for Component Instantiations 
  assign outsig = in_0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    NV_NVDLA_SDP_CORE_Y_cvt_core_core_fsm
//  FSM Module
// ------------------------------------------------------------------


module NV_NVDLA_SDP_CORE_Y_cvt_core_core_fsm (
  nvdla_core_clk, nvdla_core_rstn, core_wen, fsm_output
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input core_wen;
  output [1:0] fsm_output;
  reg [1:0] fsm_output;


  // FSM State Type Declaration for NV_NVDLA_SDP_CORE_Y_cvt_core_core_fsm_1
  parameter
    core_rlp_C_0 = 1'd0,
    main_C_0 = 1'd1;

  reg [0:0] state_var;
  reg [0:0] state_var_NS;


  // Interconnect Declarations for Component Instantiations 
  always @(*)
  begin : NV_NVDLA_SDP_CORE_Y_cvt_core_core_fsm_1
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
//  Design Unit:    NV_NVDLA_SDP_CORE_Y_cvt_core_staller
// ------------------------------------------------------------------


module NV_NVDLA_SDP_CORE_Y_cvt_core_staller (
  nvdla_core_clk, nvdla_core_rstn, core_wen, chn_in_rsci_wen_comp, core_wten, chn_out_rsci_wen_comp
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  output core_wen;
  input chn_in_rsci_wen_comp;
  output core_wten;
  reg core_wten;
  input chn_out_rsci_wen_comp;



  // Interconnect Declarations for Component Instantiations 
  assign core_wen = chn_in_rsci_wen_comp & chn_out_rsci_wen_comp;
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
//  Design Unit:    NV_NVDLA_SDP_CORE_Y_cvt_core_chn_out_rsci_chn_out_wait_dp
// ------------------------------------------------------------------


module NV_NVDLA_SDP_CORE_Y_cvt_core_chn_out_rsci_chn_out_wait_dp (
  nvdla_core_clk, nvdla_core_rstn, chn_out_rsci_oswt, chn_out_rsci_bawt, chn_out_rsci_wen_comp,
      chn_out_rsci_biwt, chn_out_rsci_bdwt
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input chn_out_rsci_oswt;
  output chn_out_rsci_bawt;
  output chn_out_rsci_wen_comp;
  input chn_out_rsci_biwt;
  input chn_out_rsci_bdwt;


  // Interconnect Declarations
  reg chn_out_rsci_bcwt;


  // Interconnect Declarations for Component Instantiations 
  assign chn_out_rsci_bawt = chn_out_rsci_biwt | chn_out_rsci_bcwt;
  assign chn_out_rsci_wen_comp = (~ chn_out_rsci_oswt) | chn_out_rsci_bawt;
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_out_rsci_bcwt <= 1'b0;
    end
    else begin
      chn_out_rsci_bcwt <= ~((~(chn_out_rsci_bcwt | chn_out_rsci_biwt)) | chn_out_rsci_bdwt);
    end
  end
endmodule

// ------------------------------------------------------------------
//  Design Unit:    NV_NVDLA_SDP_CORE_Y_cvt_core_chn_out_rsci_chn_out_wait_ctrl
// ------------------------------------------------------------------


module NV_NVDLA_SDP_CORE_Y_cvt_core_chn_out_rsci_chn_out_wait_ctrl (
  nvdla_core_clk, nvdla_core_rstn, chn_out_rsci_oswt, core_wen, core_wten, chn_out_rsci_iswt0,
      chn_out_rsci_ld_core_psct, chn_out_rsci_biwt, chn_out_rsci_bdwt, chn_out_rsci_ld_core_sct,
      chn_out_rsci_vd
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input chn_out_rsci_oswt;
  input core_wen;
  input core_wten;
  input chn_out_rsci_iswt0;
  input chn_out_rsci_ld_core_psct;
  output chn_out_rsci_biwt;
  output chn_out_rsci_bdwt;
  output chn_out_rsci_ld_core_sct;
  input chn_out_rsci_vd;


  // Interconnect Declarations
  wire chn_out_rsci_ogwt;
  wire chn_out_rsci_pdswt0;
  reg chn_out_rsci_icwt;


  // Interconnect Declarations for Component Instantiations 
  assign chn_out_rsci_pdswt0 = (~ core_wten) & chn_out_rsci_iswt0;
  assign chn_out_rsci_biwt = chn_out_rsci_ogwt & chn_out_rsci_vd;
  assign chn_out_rsci_ogwt = chn_out_rsci_pdswt0 | chn_out_rsci_icwt;
  assign chn_out_rsci_bdwt = chn_out_rsci_oswt & core_wen;
  assign chn_out_rsci_ld_core_sct = chn_out_rsci_ld_core_psct & chn_out_rsci_ogwt;
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_out_rsci_icwt <= 1'b0;
    end
    else begin
      chn_out_rsci_icwt <= ~((~(chn_out_rsci_icwt | chn_out_rsci_pdswt0)) | chn_out_rsci_biwt);
    end
  end
endmodule

// ------------------------------------------------------------------
//  Design Unit:    NV_NVDLA_SDP_CORE_Y_cvt_core_chn_in_rsci_chn_in_wait_dp
// ------------------------------------------------------------------


module NV_NVDLA_SDP_CORE_Y_cvt_core_chn_in_rsci_chn_in_wait_dp (
  nvdla_core_clk, nvdla_core_rstn, chn_in_rsci_oswt, chn_in_rsci_bawt, chn_in_rsci_wen_comp,
      chn_in_rsci_d_mxwt, chn_in_rsci_biwt, chn_in_rsci_bdwt, chn_in_rsci_d
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input chn_in_rsci_oswt;
  output chn_in_rsci_bawt;
  output chn_in_rsci_wen_comp;
  output [63:0] chn_in_rsci_d_mxwt;
  input chn_in_rsci_biwt;
  input chn_in_rsci_bdwt;
  input [63:0] chn_in_rsci_d;


  // Interconnect Declarations
  reg chn_in_rsci_bcwt;
  reg [63:0] chn_in_rsci_d_bfwt;


  // Interconnect Declarations for Component Instantiations 
  assign chn_in_rsci_bawt = chn_in_rsci_biwt | chn_in_rsci_bcwt;
  assign chn_in_rsci_wen_comp = (~ chn_in_rsci_oswt) | chn_in_rsci_bawt;
  assign chn_in_rsci_d_mxwt = MUX_v_64_2_2(chn_in_rsci_d, chn_in_rsci_d_bfwt, chn_in_rsci_bcwt);
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_in_rsci_bcwt <= 1'b0;
      chn_in_rsci_d_bfwt <= 64'b0;
    end
    else begin
      chn_in_rsci_bcwt <= ~((~(chn_in_rsci_bcwt | chn_in_rsci_biwt)) | chn_in_rsci_bdwt);
      chn_in_rsci_d_bfwt <= chn_in_rsci_d_mxwt;
    end
  end

  function [63:0] MUX_v_64_2_2;
    input [63:0] input_0;
    input [63:0] input_1;
    input [0:0] sel;
    reg [63:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_64_2_2 = result;
  end
  endfunction

endmodule

// ------------------------------------------------------------------
//  Design Unit:    NV_NVDLA_SDP_CORE_Y_cvt_core_chn_in_rsci_chn_in_wait_ctrl
// ------------------------------------------------------------------


module NV_NVDLA_SDP_CORE_Y_cvt_core_chn_in_rsci_chn_in_wait_ctrl (
  nvdla_core_clk, nvdla_core_rstn, chn_in_rsci_oswt, core_wen, chn_in_rsci_iswt0,
      chn_in_rsci_ld_core_psct, core_wten, chn_in_rsci_biwt, chn_in_rsci_bdwt, chn_in_rsci_ld_core_sct,
      chn_in_rsci_vd
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input chn_in_rsci_oswt;
  input core_wen;
  input chn_in_rsci_iswt0;
  input chn_in_rsci_ld_core_psct;
  input core_wten;
  output chn_in_rsci_biwt;
  output chn_in_rsci_bdwt;
  output chn_in_rsci_ld_core_sct;
  input chn_in_rsci_vd;


  // Interconnect Declarations
  wire chn_in_rsci_ogwt;
  wire chn_in_rsci_pdswt0;
  reg chn_in_rsci_icwt;


  // Interconnect Declarations for Component Instantiations 
  assign chn_in_rsci_pdswt0 = (~ core_wten) & chn_in_rsci_iswt0;
  assign chn_in_rsci_biwt = chn_in_rsci_ogwt & chn_in_rsci_vd;
  assign chn_in_rsci_ogwt = chn_in_rsci_pdswt0 | chn_in_rsci_icwt;
  assign chn_in_rsci_bdwt = chn_in_rsci_oswt & core_wen;
  assign chn_in_rsci_ld_core_sct = chn_in_rsci_ld_core_psct & chn_in_rsci_ogwt;
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_in_rsci_icwt <= 1'b0;
    end
    else begin
      chn_in_rsci_icwt <= ~((~(chn_in_rsci_icwt | chn_in_rsci_pdswt0)) | chn_in_rsci_biwt);
    end
  end
endmodule

// ------------------------------------------------------------------
//  Design Unit:    NV_NVDLA_SDP_CORE_Y_cvt_core_chn_out_rsci
// ------------------------------------------------------------------


module NV_NVDLA_SDP_CORE_Y_cvt_core_chn_out_rsci (
  nvdla_core_clk, nvdla_core_rstn, chn_out_rsc_z, chn_out_rsc_vz, chn_out_rsc_lz,
      chn_out_rsci_oswt, core_wen, core_wten, chn_out_rsci_iswt0, chn_out_rsci_bawt,
      chn_out_rsci_wen_comp, chn_out_rsci_ld_core_psct, chn_out_rsci_d
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  output [127:0] chn_out_rsc_z;
  input chn_out_rsc_vz;
  output chn_out_rsc_lz;
  input chn_out_rsci_oswt;
  input core_wen;
  input core_wten;
  input chn_out_rsci_iswt0;
  output chn_out_rsci_bawt;
  output chn_out_rsci_wen_comp;
  input chn_out_rsci_ld_core_psct;
  input [127:0] chn_out_rsci_d;


  // Interconnect Declarations
  wire chn_out_rsci_biwt;
  wire chn_out_rsci_bdwt;
  wire chn_out_rsci_ld_core_sct;
  wire chn_out_rsci_vd;


  // Interconnect Declarations for Component Instantiations 
  SDP_Y_CVT_mgc_out_stdreg_wait_v1 #(.rscid(32'sd8),
  .width(32'sd128)) chn_out_rsci (
      .ld(chn_out_rsci_ld_core_sct),
      .vd(chn_out_rsci_vd),
      .d(chn_out_rsci_d),
      .lz(chn_out_rsc_lz),
      .vz(chn_out_rsc_vz),
      .z(chn_out_rsc_z)
    );
  NV_NVDLA_SDP_CORE_Y_cvt_core_chn_out_rsci_chn_out_wait_ctrl NV_NVDLA_SDP_CORE_Y_cvt_core_chn_out_rsci_chn_out_wait_ctrl_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_out_rsci_oswt(chn_out_rsci_oswt),
      .core_wen(core_wen),
      .core_wten(core_wten),
      .chn_out_rsci_iswt0(chn_out_rsci_iswt0),
      .chn_out_rsci_ld_core_psct(chn_out_rsci_ld_core_psct),
      .chn_out_rsci_biwt(chn_out_rsci_biwt),
      .chn_out_rsci_bdwt(chn_out_rsci_bdwt),
      .chn_out_rsci_ld_core_sct(chn_out_rsci_ld_core_sct),
      .chn_out_rsci_vd(chn_out_rsci_vd)
    );
  NV_NVDLA_SDP_CORE_Y_cvt_core_chn_out_rsci_chn_out_wait_dp NV_NVDLA_SDP_CORE_Y_cvt_core_chn_out_rsci_chn_out_wait_dp_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_out_rsci_oswt(chn_out_rsci_oswt),
      .chn_out_rsci_bawt(chn_out_rsci_bawt),
      .chn_out_rsci_wen_comp(chn_out_rsci_wen_comp),
      .chn_out_rsci_biwt(chn_out_rsci_biwt),
      .chn_out_rsci_bdwt(chn_out_rsci_bdwt)
    );
endmodule

// ------------------------------------------------------------------
//  Design Unit:    NV_NVDLA_SDP_CORE_Y_cvt_core_chn_in_rsci
// ------------------------------------------------------------------


module NV_NVDLA_SDP_CORE_Y_cvt_core_chn_in_rsci (
  nvdla_core_clk, nvdla_core_rstn, chn_in_rsc_z, chn_in_rsc_vz, chn_in_rsc_lz, chn_in_rsci_oswt,
      core_wen, chn_in_rsci_iswt0, chn_in_rsci_bawt, chn_in_rsci_wen_comp, chn_in_rsci_ld_core_psct,
      chn_in_rsci_d_mxwt, core_wten
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [63:0] chn_in_rsc_z;
  input chn_in_rsc_vz;
  output chn_in_rsc_lz;
  input chn_in_rsci_oswt;
  input core_wen;
  input chn_in_rsci_iswt0;
  output chn_in_rsci_bawt;
  output chn_in_rsci_wen_comp;
  input chn_in_rsci_ld_core_psct;
  output [63:0] chn_in_rsci_d_mxwt;
  input core_wten;


  // Interconnect Declarations
  wire chn_in_rsci_biwt;
  wire chn_in_rsci_bdwt;
  wire chn_in_rsci_ld_core_sct;
  wire chn_in_rsci_vd;
  wire [63:0] chn_in_rsci_d;


  // Interconnect Declarations for Component Instantiations 
  SDP_Y_CVT_mgc_in_wire_wait_v1 #(.rscid(32'sd1),
  .width(32'sd64)) chn_in_rsci (
      .ld(chn_in_rsci_ld_core_sct),
      .vd(chn_in_rsci_vd),
      .d(chn_in_rsci_d),
      .lz(chn_in_rsc_lz),
      .vz(chn_in_rsc_vz),
      .z(chn_in_rsc_z)
    );
  NV_NVDLA_SDP_CORE_Y_cvt_core_chn_in_rsci_chn_in_wait_ctrl NV_NVDLA_SDP_CORE_Y_cvt_core_chn_in_rsci_chn_in_wait_ctrl_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_in_rsci_oswt(chn_in_rsci_oswt),
      .core_wen(core_wen),
      .chn_in_rsci_iswt0(chn_in_rsci_iswt0),
      .chn_in_rsci_ld_core_psct(chn_in_rsci_ld_core_psct),
      .core_wten(core_wten),
      .chn_in_rsci_biwt(chn_in_rsci_biwt),
      .chn_in_rsci_bdwt(chn_in_rsci_bdwt),
      .chn_in_rsci_ld_core_sct(chn_in_rsci_ld_core_sct),
      .chn_in_rsci_vd(chn_in_rsci_vd)
    );
  NV_NVDLA_SDP_CORE_Y_cvt_core_chn_in_rsci_chn_in_wait_dp NV_NVDLA_SDP_CORE_Y_cvt_core_chn_in_rsci_chn_in_wait_dp_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_in_rsci_oswt(chn_in_rsci_oswt),
      .chn_in_rsci_bawt(chn_in_rsci_bawt),
      .chn_in_rsci_wen_comp(chn_in_rsci_wen_comp),
      .chn_in_rsci_d_mxwt(chn_in_rsci_d_mxwt),
      .chn_in_rsci_biwt(chn_in_rsci_biwt),
      .chn_in_rsci_bdwt(chn_in_rsci_bdwt),
      .chn_in_rsci_d(chn_in_rsci_d)
    );
endmodule

// ------------------------------------------------------------------
//  Design Unit:    NV_NVDLA_SDP_CORE_Y_cvt_core
// ------------------------------------------------------------------


module NV_NVDLA_SDP_CORE_Y_cvt_core (
  nvdla_core_clk, nvdla_core_rstn, chn_in_rsc_z, chn_in_rsc_vz, chn_in_rsc_lz, cfg_bypass_rsc_z,
      cfg_offset_rsc_z, cfg_scale_rsc_z, cfg_truncate_rsc_z, cfg_nan_to_zero_rsc_z,
      cfg_precision_rsc_z, chn_out_rsc_z, chn_out_rsc_vz, chn_out_rsc_lz, chn_in_rsci_oswt,
      chn_in_rsci_oswt_unreg, chn_out_rsci_oswt, chn_out_rsci_oswt_unreg
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [63:0] chn_in_rsc_z;
  input chn_in_rsc_vz;
  output chn_in_rsc_lz;
  input cfg_bypass_rsc_z;
  input [31:0] cfg_offset_rsc_z;
  input [15:0] cfg_scale_rsc_z;
  input [5:0] cfg_truncate_rsc_z;
  input cfg_nan_to_zero_rsc_z;
  input [1:0] cfg_precision_rsc_z;
  output [127:0] chn_out_rsc_z;
  input chn_out_rsc_vz;
  output chn_out_rsc_lz;
  input chn_in_rsci_oswt;
  output chn_in_rsci_oswt_unreg;
  input chn_out_rsci_oswt;
  output chn_out_rsci_oswt_unreg;


  // Interconnect Declarations
  wire core_wen;
  reg chn_in_rsci_iswt0;
  wire chn_in_rsci_bawt;
  wire chn_in_rsci_wen_comp;
  reg chn_in_rsci_ld_core_psct;
  wire [63:0] chn_in_rsci_d_mxwt;
  wire core_wten;
  wire cfg_bypass_rsci_d;
  wire [31:0] cfg_offset_rsci_d;
  wire [15:0] cfg_scale_rsci_d;
  wire [5:0] cfg_truncate_rsci_d;
  wire cfg_nan_to_zero_rsci_d;
  wire [1:0] cfg_precision_rsci_d;
  reg chn_out_rsci_iswt0;
  wire chn_out_rsci_bawt;
  wire chn_out_rsci_wen_comp;
  reg chn_out_rsci_d_127;
  reg [3:0] chn_out_rsci_d_122_119;
  reg chn_out_rsci_d_96;
  reg chn_out_rsci_d_95;
  reg [3:0] chn_out_rsci_d_90_87;
  reg chn_out_rsci_d_64;
  reg chn_out_rsci_d_63;
  reg [3:0] chn_out_rsci_d_58_55;
  reg chn_out_rsci_d_32;
  reg chn_out_rsci_d_31;
  reg [3:0] chn_out_rsci_d_26_23;
  reg chn_out_rsci_d_0;
  reg [1:0] chn_out_rsci_d_126_125;
  reg [1:0] chn_out_rsci_d_124_123;
  reg [9:0] chn_out_rsci_d_118_109;
  reg [2:0] chn_out_rsci_d_108_106;
  reg [8:0] chn_out_rsci_d_105_97;
  reg [1:0] chn_out_rsci_d_94_93;
  reg [1:0] chn_out_rsci_d_92_91;
  reg [9:0] chn_out_rsci_d_86_77;
  reg [2:0] chn_out_rsci_d_76_74;
  reg [8:0] chn_out_rsci_d_73_65;
  reg [1:0] chn_out_rsci_d_62_61;
  reg [1:0] chn_out_rsci_d_60_59;
  reg [9:0] chn_out_rsci_d_54_45;
  reg [2:0] chn_out_rsci_d_44_42;
  reg [8:0] chn_out_rsci_d_41_33;
  reg [1:0] chn_out_rsci_d_30_29;
  reg [1:0] chn_out_rsci_d_28_27;
  reg [9:0] chn_out_rsci_d_22_13;
  reg [2:0] chn_out_rsci_d_12_10;
  reg [8:0] chn_out_rsci_d_9_1;
  wire [1:0] fsm_output;
  wire IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_3_tmp;
  wire IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_2_tmp;
  wire IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_1_tmp;
  wire IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_tmp;
  wire and_dcpl;
  wire and_dcpl_3;
  wire and_dcpl_7;
  wire and_tmp;
  wire or_tmp_2;
  wire or_tmp_5;
  wire mux_tmp;
  wire mux_tmp_1;
  wire and_tmp_3;
  wire and_dcpl_17;
  wire and_dcpl_19;
  wire and_dcpl_22;
  wire and_dcpl_23;
  wire or_tmp_63;
  reg main_stage_v_1;
  reg [3:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_3_0_lpi_1_dfm_6;
  reg [3:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_3_0_3_lpi_1_dfm_6;
  reg [3:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_3_0_2_lpi_1_dfm_6;
  reg cfg_bypass_1_sva_2;
  reg [63:0] data_in_data_sva_78;
  reg [48:0] cvt_1_IntMulExt_33U_16U_49U_o_mul_itm_2;
  reg [48:0] cvt_2_IntMulExt_33U_16U_49U_o_mul_1_itm_2;
  reg [48:0] cvt_3_IntMulExt_33U_16U_49U_o_mul_itm_2;
  reg [48:0] cvt_4_IntMulExt_33U_16U_49U_o_mul_1_itm_2;
  reg cvt_1_if_cvt_1_if_and_9_itm_2;
  reg cvt_1_if_cvt_1_if_and_3_itm_2;
  reg cvt_1_if_cvt_1_if_and_6_itm_2;
  reg cvt_1_if_cvt_1_if_and_itm_2;
  reg [1:0] cfg_precision_1_sva_st_6;
  reg cfg_bypass_1_sva_st_10;
  reg [1:0] cfg_precision_1_sva_st_8;
  reg [1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_lpi_1_dfm_5_3_2_1;
  reg [1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_lpi_1_dfm_5_1_0_1;
  reg [9:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_lpi_1_dfm_5_22_13_1;
  reg [2:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_lpi_1_dfm_5_12_10_1;
  reg [9:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_lpi_1_dfm_5_9_0_1;
  reg [1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_3_lpi_1_dfm_5_3_2_1;
  reg [1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_3_lpi_1_dfm_5_1_0_1;
  reg [9:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_3_lpi_1_dfm_5_22_13_1;
  reg [2:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_3_lpi_1_dfm_5_12_10_1;
  reg [9:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_3_lpi_1_dfm_5_9_0_1;
  reg [1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_2_lpi_1_dfm_5_3_2_1;
  reg [1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_2_lpi_1_dfm_5_1_0_1;
  reg [9:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_2_lpi_1_dfm_5_22_13_1;
  reg [2:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_2_lpi_1_dfm_5_12_10_1;
  reg [9:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_2_lpi_1_dfm_5_9_0_1;
  reg [1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_1_lpi_1_dfm_5_3_2_1;
  reg [1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_1_lpi_1_dfm_5_1_0_1;
  reg [9:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_1_lpi_1_dfm_5_22_13_1;
  reg [2:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_1_lpi_1_dfm_5_12_10_1;
  reg [9:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_1_lpi_1_dfm_5_9_0_1;
  wire and_6_mdf;
  wire IsZero_5U_23U_IsZero_5U_23U_nor_cse_sva;
  wire IsNaN_5U_10U_nor_3_cse;
  wire IsZero_5U_23U_IsZero_5U_23U_nor_cse_3_sva;
  wire IsNaN_5U_10U_nor_2_cse;
  wire IsZero_5U_23U_IsZero_5U_23U_nor_cse_2_sva;
  wire IsNaN_5U_10U_nor_1_cse;
  wire IsZero_5U_23U_IsZero_5U_23U_nor_cse_1_sva;
  wire IsNaN_5U_10U_nor_cse;
  wire cvt_1_unequal_tmp;
  wire IsDenorm_5U_23U_land_lpi_1_dfm;
  wire IsInf_5U_23U_land_lpi_1_dfm;
  wire IsInf_5U_23U_IsInf_5U_23U_and_cse_sva;
  wire IsDenorm_5U_23U_land_3_lpi_1_dfm;
  wire IsInf_5U_23U_land_3_lpi_1_dfm;
  wire IsInf_5U_23U_IsInf_5U_23U_and_cse_3_sva;
  wire IsDenorm_5U_23U_land_2_lpi_1_dfm;
  wire IsInf_5U_23U_land_2_lpi_1_dfm;
  wire IsInf_5U_23U_IsInf_5U_23U_and_cse_2_sva;
  wire IsDenorm_5U_23U_land_1_lpi_1_dfm;
  wire IsInf_5U_23U_land_1_lpi_1_dfm;
  wire IsInf_5U_23U_IsInf_5U_23U_and_cse_1_sva;
  wire cvt_1_if_land_lpi_1_dfm;
  wire cvt_1_if_land_3_lpi_1_dfm;
  wire cvt_1_if_land_2_lpi_1_dfm;
  wire cvt_1_if_land_1_lpi_1_dfm;
  wire [111:0] IntShiftRight_49U_6U_32U_mbits_fixed_sva;
  wire [111:0] IntShiftRight_49U_6U_32U_mbits_fixed_3_sva;
  wire [111:0] IntShiftRight_49U_6U_32U_mbits_fixed_2_sva;
  wire [111:0] IntShiftRight_49U_6U_32U_mbits_fixed_1_sva;
  wire [9:0] FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_lpi_1_dfm;
  wire [4:0] cvt_1_if_op_expo_lpi_1_dfm;
  wire [9:0] FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_3_lpi_1_dfm;
  wire [4:0] cvt_1_if_op_expo_3_lpi_1_dfm;
  wire [9:0] FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_2_lpi_1_dfm;
  wire [4:0] cvt_1_if_op_expo_2_lpi_1_dfm;
  wire [9:0] FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_1_lpi_1_dfm;
  wire [4:0] cvt_1_if_op_expo_1_lpi_1_dfm;
  wire [9:0] cvt_1_if_op_mant_lpi_1_dfm;
  wire [9:0] cvt_1_if_op_mant_3_lpi_1_dfm;
  wire [9:0] cvt_1_if_op_mant_2_lpi_1_dfm;
  wire [9:0] cvt_1_if_op_mant_1_lpi_1_dfm;
  wire [49:0] IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_sva;
  wire [50:0] nl_IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_sva;
  wire [49:0] IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_3_sva;
  wire [50:0] nl_IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_3_sva;
  wire [49:0] IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_2_sva;
  wire [50:0] nl_IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_2_sva;
  wire [49:0] IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_1_sva;
  wire [50:0] nl_IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_1_sva;
  wire [9:0] FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_9_0_lpi_1_dfm;
  wire [9:0] FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_9_0_3_lpi_1_dfm;
  wire [9:0] FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_9_0_2_lpi_1_dfm;
  wire [9:0] FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_9_0_1_lpi_1_dfm;
  wire chn_out_and_cse;
  wire chn_out_and_20_cse;
  wire or_66_cse;
  wire nor_6_cse;
  reg reg_chn_out_rsci_ld_core_psct_cse;
  wire or_dcpl;
  wire or_dcpl_10;
  wire or_dcpl_11;
  wire or_dcpl_12;
  wire FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_ssc;
  wire FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_6_ssc;
  wire FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_2_ssc;
  wire FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_4_ssc;
  wire [22:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_1_sva_2;
  wire [22:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_sva_2;
  wire [22:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_2_sva_2;
  wire [22:0] FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_3_sva_2;
  wire [5:0] cfg_truncate_mux1h_1_itm;
  reg [1:0] reg_cfg_truncate_1_itm;
  reg [3:0] reg_cfg_truncate_1_1_itm;
  wire [5:0] z_out;
  wire [6:0] nl_z_out;
  wire [5:0] z_out_1;
  wire [6:0] nl_z_out_1;
  wire [5:0] z_out_2;
  wire [6:0] nl_z_out_2;
  wire [5:0] z_out_3;
  wire [6:0] nl_z_out_3;
  wire chn_in_rsci_ld_core_psct_mx0c0;
  wire cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth_1_sig_mx0w1;
  wire cvt_1_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_sig_mx0w1;
  wire main_stage_v_1_mx0c1;
  wire IsNaN_5U_23U_land_lpi_1_dfm;
  wire IsNaN_5U_23U_land_3_lpi_1_dfm;
  wire IsNaN_5U_23U_land_2_lpi_1_dfm;
  wire IsNaN_5U_23U_land_1_lpi_1_dfm;
  wire [29:0] cvt_1_else_else_o_tct_30_1_1_sva;
  wire IntShiftRight_49U_6U_32U_obits_fixed_nor_ovfl_1_sva;
  wire IntShiftRight_49U_6U_32U_obits_fixed_and_unfl_1_sva;
  wire [29:0] cvt_1_else_else_o_tct_30_1_2_sva;
  wire IntShiftRight_49U_6U_32U_obits_fixed_nor_ovfl_2_sva;
  wire IntShiftRight_49U_6U_32U_obits_fixed_and_unfl_2_sva;
  wire [29:0] cvt_1_else_else_o_tct_30_1_3_sva;
  wire IntShiftRight_49U_6U_32U_obits_fixed_nor_ovfl_3_sva;
  wire IntShiftRight_49U_6U_32U_obits_fixed_and_unfl_3_sva;
  wire [29:0] cvt_1_else_else_o_tct_30_1_sva;
  wire IntShiftRight_49U_6U_32U_obits_fixed_nor_ovfl_sva;
  wire IntShiftRight_49U_6U_32U_obits_fixed_and_unfl_sva;
  wire [5:0] FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_1_sva;
  wire [6:0] nl_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_1_sva;
  wire [5:0] FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_2_sva;
  wire [6:0] nl_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_2_sva;
  wire [5:0] FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_3_sva;
  wire [6:0] nl_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_3_sva;
  wire [5:0] FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_sva;
  wire [6:0] nl_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_sva;
  wire cvt_1_asn_63;
  wire cvt_1_asn_65;
  wire FpExpoWidthInc_5U_8U_23U_1U_1U_exs_71_0;
  wire FpExpoWidthInc_5U_8U_23U_1U_1U_exs_79_0;
  wire FpExpoWidthInc_5U_8U_23U_1U_1U_exs_87_0;
  wire FpExpoWidthInc_5U_8U_23U_1U_1U_exs_95_0;
  wire [4:0] libraries_leading_sign_23_0_aebf38bbf639c970da88b55f070b6a2d5444_4;
  wire [4:0] libraries_leading_sign_23_0_aebf38bbf639c970da88b55f070b6a2d5444_5;
  wire [4:0] libraries_leading_sign_23_0_aebf38bbf639c970da88b55f070b6a2d5444_6;
  wire [4:0] libraries_leading_sign_23_0_aebf38bbf639c970da88b55f070b6a2d5444_7;
  wire or_110_cse;
  wire cfg_precision_and_cse;
  wire cvt_1_if_and_cse;
  wire cfg_bypass_and_4_cse;
  wire or_109_cse;
  wire IntMulExt_33U_16U_49U_o_and_cse;
  wire IntMulExt_33U_16U_49U_o_and_1_cse;

  wire[0:0] iExpoWidth_oExpoWidth_prb;
  wire[0:0] iMantWidth_oMantWidth_prb;
  wire[0:0] iMantWidth_oMantWidth_prb_1;
  wire[0:0] iExpoWidth_oExpoWidth_prb_1;
  wire[0:0] iExpoWidth_oExpoWidth_prb_2;
  wire[0:0] iMantWidth_oMantWidth_prb_2;
  wire[0:0] iMantWidth_oMantWidth_prb_3;
  wire[0:0] iExpoWidth_oExpoWidth_prb_3;
  wire[0:0] iExpoWidth_oExpoWidth_prb_4;
  wire[0:0] iMantWidth_oMantWidth_prb_4;
  wire[0:0] iMantWidth_oMantWidth_prb_5;
  wire[0:0] iExpoWidth_oExpoWidth_prb_5;
  wire[0:0] iExpoWidth_oExpoWidth_prb_6;
  wire[0:0] iMantWidth_oMantWidth_prb_6;
  wire[0:0] iMantWidth_oMantWidth_prb_7;
  wire[0:0] iExpoWidth_oExpoWidth_prb_7;
  wire[0:0] oWidth_mWidth_prb;
  wire[0:0] oWidth_aWidth_bWidth_prb;
  wire[0:0] oWidth_mWidth_prb_1;
  wire[0:0] oWidth_aWidth_bWidth_prb_1;
  wire[0:0] oWidth_mWidth_prb_2;
  wire[0:0] oWidth_aWidth_bWidth_prb_2;
  wire[0:0] oWidth_mWidth_prb_3;
  wire[0:0] oWidth_aWidth_bWidth_prb_3;
  wire[0:0] cvt_1_else_mux_39_nl;
  wire[0:0] cvt_1_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_1_nl;
  wire[0:0] cvt_1_else_mux_40_nl;
  wire[0:0] cvt_1_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_2_nl;
  wire[0:0] cvt_1_else_mux_41_nl;
  wire[0:0] cvt_2_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_4_nl;
  wire[0:0] cvt_1_else_mux_42_nl;
  wire[0:0] cvt_2_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_5_nl;
  wire[0:0] cvt_1_else_mux_43_nl;
  wire[0:0] cvt_3_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_1_nl;
  wire[0:0] cvt_1_else_mux_44_nl;
  wire[0:0] cvt_3_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_2_nl;
  wire[0:0] cvt_1_else_mux_45_nl;
  wire[0:0] cvt_4_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_4_nl;
  wire[0:0] cvt_1_else_mux_46_nl;
  wire[0:0] cvt_4_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_5_nl;
  wire[0:0] mux_6_nl;
  wire[0:0] mux_46_nl;
  wire[0:0] mux_4_nl;
  wire[0:0] mux_3_nl;
  wire[0:0] or_3_nl;
  wire[32:0] cvt_1_IntSubExt_16U_32U_33U_o_acc_nl;
  wire[33:0] nl_cvt_1_IntSubExt_16U_32U_33U_o_acc_nl;
  wire[3:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_3_nl;
  wire[3:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_mux1h_nl;
  wire[0:0] mux_30_nl;
  wire[0:0] or_68_nl;
  wire[0:0] mux_19_nl;
  wire[0:0] nor_20_nl;
  wire[0:0] nor_22_nl;
  wire[32:0] cvt_2_IntSubExt_16U_32U_33U_o_acc_1_nl;
  wire[33:0] nl_cvt_2_IntSubExt_16U_32U_33U_o_acc_1_nl;
  wire[32:0] cvt_3_IntSubExt_16U_32U_33U_o_acc_nl;
  wire[33:0] nl_cvt_3_IntSubExt_16U_32U_33U_o_acc_nl;
  wire[32:0] cvt_4_IntSubExt_16U_32U_33U_o_acc_1_nl;
  wire[33:0] nl_cvt_4_IntSubExt_16U_32U_33U_o_acc_1_nl;
  wire[0:0] mux_47_nl;
  wire[0:0] and_166_nl;
  wire[0:0] mux_25_nl;
  wire[0:0] nand_nl;
  wire[0:0] and_224_nl;
  wire[0:0] nor_13_nl;
  wire[0:0] mux_28_nl;
  wire[0:0] mux_27_nl;
  wire[0:0] mux_26_nl;
  wire[0:0] mux_9_nl;
  wire[0:0] or_14_nl;
  wire[9:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_27_nl;
  wire[1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_mux_58_nl;
  wire[1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_23_nl;
  wire[1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_mux_42_nl;
  wire[1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_14_nl;
  wire[9:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_29_nl;
  wire[2:0] FpExpoWidthInc_5U_8U_23U_1U_1U_nor_nl;
  wire[2:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_nl;
  wire[0:0] FpExpoWidthInc_5U_8U_23U_1U_1U_not_nl;
  wire[3:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_mux1h_3_nl;
  wire[9:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_30_nl;
  wire[9:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_31_nl;
  wire[2:0] FpExpoWidthInc_5U_8U_23U_1U_1U_nor_3_nl;
  wire[2:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_22_nl;
  wire[0:0] FpExpoWidthInc_5U_8U_23U_1U_1U_not_3_nl;
  wire[1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_mux_46_nl;
  wire[1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_17_nl;
  wire[1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_mux_36_nl;
  wire[1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_2_nl;
  wire[9:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_32_nl;
  wire[1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_mux_54_nl;
  wire[1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_21_nl;
  wire[1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_mux_40_nl;
  wire[1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_10_nl;
  wire[9:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_33_nl;
  wire[2:0] FpExpoWidthInc_5U_8U_23U_1U_1U_nor_1_nl;
  wire[2:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_18_nl;
  wire[0:0] FpExpoWidthInc_5U_8U_23U_1U_1U_not_1_nl;
  wire[3:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_mux1h_2_nl;
  wire[3:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_mux1h_1_nl;
  wire[9:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_34_nl;
  wire[9:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_35_nl;
  wire[2:0] FpExpoWidthInc_5U_8U_23U_1U_1U_nor_2_nl;
  wire[2:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_20_nl;
  wire[0:0] FpExpoWidthInc_5U_8U_23U_1U_1U_not_2_nl;
  wire[1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_mux_50_nl;
  wire[1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_19_nl;
  wire[1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_mux_38_nl;
  wire[1:0] FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_6_nl;
  wire[0:0] or_56_nl;
  wire[0:0] or_57_nl;
  wire[0:0] cvt_1_if_aelse_not_20_nl;
  wire[0:0] IsNaN_5U_23U_aelse_not_11_nl;
  wire[0:0] cvt_1_if_aelse_not_12_nl;
  wire[0:0] cvt_1_if_aelse_not_22_nl;
  wire[0:0] IsNaN_5U_23U_aelse_not_10_nl;
  wire[0:0] cvt_1_if_aelse_not_14_nl;
  wire[0:0] cvt_1_if_aelse_not_24_nl;
  wire[0:0] IsNaN_5U_23U_aelse_not_9_nl;
  wire[0:0] cvt_1_if_aelse_not_16_nl;
  wire[0:0] cvt_1_if_aelse_not_26_nl;
  wire[0:0] IsNaN_5U_23U_aelse_not_8_nl;
  wire[0:0] cvt_1_if_aelse_not_18_nl;
  wire[29:0] cvt_1_IntShiftRight_49U_6U_32U_obits_fixed_nor_2_nl;
  wire[0:0] cvt_1_IntShiftRight_49U_6U_32U_obits_fixed_and_nl;
  wire[29:0] cvt_2_IntShiftRight_49U_6U_32U_obits_fixed_nor_7_nl;
  wire[0:0] cvt_2_IntShiftRight_49U_6U_32U_obits_fixed_and_2_nl;
  wire[29:0] cvt_3_IntShiftRight_49U_6U_32U_obits_fixed_nor_2_nl;
  wire[0:0] cvt_3_IntShiftRight_49U_6U_32U_obits_fixed_and_nl;
  wire[29:0] cvt_4_IntShiftRight_49U_6U_32U_obits_fixed_nor_7_nl;
  wire[0:0] cvt_4_IntShiftRight_49U_6U_32U_obits_fixed_and_2_nl;
  wire[0:0] or_9_nl;
  wire[4:0] FpExpoWidthInc_5U_8U_23U_1U_1U_else_mux_4_nl;
  wire[0:0] FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_and_4_nl;
  wire[4:0] FpExpoWidthInc_5U_8U_23U_1U_1U_else_mux_5_nl;
  wire[0:0] FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_and_5_nl;
  wire[4:0] FpExpoWidthInc_5U_8U_23U_1U_1U_else_mux_6_nl;
  wire[0:0] FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_and_6_nl;
  wire[4:0] FpExpoWidthInc_5U_8U_23U_1U_1U_else_mux_7_nl;
  wire[0:0] FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_and_7_nl;

  // Interconnect Declarations for Component Instantiations 
  wire [111:0] nl_cvt_1_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_rg_a;
  assign nl_cvt_1_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_rg_a = {cvt_1_IntMulExt_33U_16U_49U_o_mul_itm_2
      , 63'b0};
  wire [5:0] nl_cvt_1_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_rg_s;
  assign nl_cvt_1_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_rg_s = {reg_cfg_truncate_1_itm
      , reg_cfg_truncate_1_1_itm};
  wire [111:0] nl_cvt_2_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_1_rg_a;
  assign nl_cvt_2_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_1_rg_a = {cvt_2_IntMulExt_33U_16U_49U_o_mul_1_itm_2
      , 63'b0};
  wire [5:0] nl_cvt_2_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_1_rg_s;
  assign nl_cvt_2_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_1_rg_s = {reg_cfg_truncate_1_itm
      , reg_cfg_truncate_1_1_itm};
  wire [111:0] nl_cvt_3_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_rg_a;
  assign nl_cvt_3_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_rg_a = {cvt_3_IntMulExt_33U_16U_49U_o_mul_itm_2
      , 63'b0};
  wire [5:0] nl_cvt_3_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_rg_s;
  assign nl_cvt_3_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_rg_s = {reg_cfg_truncate_1_itm
      , reg_cfg_truncate_1_1_itm};
  wire [111:0] nl_cvt_4_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_1_rg_a;
  assign nl_cvt_4_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_1_rg_a = {cvt_4_IntMulExt_33U_16U_49U_o_mul_1_itm_2
      , 63'b0};
  wire [5:0] nl_cvt_4_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_1_rg_s;
  assign nl_cvt_4_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_1_rg_s = {reg_cfg_truncate_1_itm
      , reg_cfg_truncate_1_1_itm};
  wire [21:0] nl_cvt_1_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_rg_a;
  assign nl_cvt_1_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_rg_a = {(FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_1_lpi_1_dfm[8:0])
      , 13'b0};
  wire [5:0] nl_cvt_1_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_rg_s;
  assign nl_cvt_1_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_rg_s = z_out;
  wire [22:0] nl_cvt_1_leading_sign_23_0_rg_mantissa;
  assign nl_cvt_1_leading_sign_23_0_rg_mantissa = {cvt_1_if_op_mant_1_lpi_1_dfm ,
      13'b0};
  wire [21:0] nl_cvt_2_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_1_rg_a;
  assign nl_cvt_2_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_1_rg_a = {(FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_2_lpi_1_dfm[8:0])
      , 13'b0};
  wire [5:0] nl_cvt_2_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_1_rg_s;
  assign nl_cvt_2_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_1_rg_s = z_out_1;
  wire [22:0] nl_cvt_2_leading_sign_23_0_1_rg_mantissa;
  assign nl_cvt_2_leading_sign_23_0_1_rg_mantissa = {cvt_1_if_op_mant_2_lpi_1_dfm
      , 13'b0};
  wire [21:0] nl_cvt_3_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_rg_a;
  assign nl_cvt_3_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_rg_a = {(FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_3_lpi_1_dfm[8:0])
      , 13'b0};
  wire [5:0] nl_cvt_3_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_rg_s;
  assign nl_cvt_3_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_rg_s = z_out_2;
  wire [22:0] nl_cvt_3_leading_sign_23_0_rg_mantissa;
  assign nl_cvt_3_leading_sign_23_0_rg_mantissa = {cvt_1_if_op_mant_3_lpi_1_dfm ,
      13'b0};
  wire [21:0] nl_cvt_4_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_1_rg_a;
  assign nl_cvt_4_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_1_rg_a = {(FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_lpi_1_dfm[8:0])
      , 13'b0};
  wire [5:0] nl_cvt_4_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_1_rg_s;
  assign nl_cvt_4_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_1_rg_s = z_out_3;
  wire [22:0] nl_cvt_4_leading_sign_23_0_1_rg_mantissa;
  assign nl_cvt_4_leading_sign_23_0_1_rg_mantissa = {cvt_1_if_op_mant_lpi_1_dfm ,
      13'b0};
  wire [127:0] nl_NV_NVDLA_SDP_CORE_Y_cvt_core_chn_out_rsci_inst_chn_out_rsci_d;
  assign nl_NV_NVDLA_SDP_CORE_Y_cvt_core_chn_out_rsci_inst_chn_out_rsci_d = {chn_out_rsci_d_127
      , chn_out_rsci_d_126_125 , chn_out_rsci_d_124_123 , chn_out_rsci_d_122_119
      , chn_out_rsci_d_118_109 , chn_out_rsci_d_108_106 , chn_out_rsci_d_105_97 ,
      chn_out_rsci_d_96 , chn_out_rsci_d_95 , chn_out_rsci_d_94_93 , chn_out_rsci_d_92_91
      , chn_out_rsci_d_90_87 , chn_out_rsci_d_86_77 , chn_out_rsci_d_76_74 , chn_out_rsci_d_73_65
      , chn_out_rsci_d_64 , chn_out_rsci_d_63 , chn_out_rsci_d_62_61 , chn_out_rsci_d_60_59
      , chn_out_rsci_d_58_55 , chn_out_rsci_d_54_45 , chn_out_rsci_d_44_42 , chn_out_rsci_d_41_33
      , chn_out_rsci_d_32 , chn_out_rsci_d_31 , chn_out_rsci_d_30_29 , chn_out_rsci_d_28_27
      , chn_out_rsci_d_26_23 , chn_out_rsci_d_22_13 , chn_out_rsci_d_12_10 , chn_out_rsci_d_9_1
      , chn_out_rsci_d_0};
  SDP_Y_CVT_mgc_in_wire_v1 #(.rscid(32'sd2),
  .width(32'sd1)) cfg_bypass_rsci (
      .d(cfg_bypass_rsci_d),
      .z(cfg_bypass_rsc_z)
    );
  SDP_Y_CVT_mgc_in_wire_v1 #(.rscid(32'sd3),
  .width(32'sd32)) cfg_offset_rsci (
      .d(cfg_offset_rsci_d),
      .z(cfg_offset_rsc_z)
    );
  SDP_Y_CVT_mgc_in_wire_v1 #(.rscid(32'sd4),
  .width(32'sd16)) cfg_scale_rsci (
      .d(cfg_scale_rsci_d),
      .z(cfg_scale_rsc_z)
    );
  SDP_Y_CVT_mgc_in_wire_v1 #(.rscid(32'sd5),
  .width(32'sd6)) cfg_truncate_rsci (
      .d(cfg_truncate_rsci_d),
      .z(cfg_truncate_rsc_z)
    );
  SDP_Y_CVT_mgc_in_wire_v1 #(.rscid(32'sd6),
  .width(32'sd1)) cfg_nan_to_zero_rsci (
      .d(cfg_nan_to_zero_rsci_d),
      .z(cfg_nan_to_zero_rsc_z)
    );
  SDP_Y_CVT_mgc_in_wire_v1 #(.rscid(32'sd7),
  .width(32'sd2)) cfg_precision_rsci (
      .d(cfg_precision_rsci_d),
      .z(cfg_precision_rsc_z)
    );
  SDP_Y_CVT_mgc_shift_r_v4 #(.width_a(32'sd112),
  .signd_a(32'sd1),
  .width_s(32'sd6),
  .width_z(32'sd112)) cvt_1_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_rg (
      .a(nl_cvt_1_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_rg_a[111:0]),
      .s(nl_cvt_1_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_rg_s[5:0]),
      .z(IntShiftRight_49U_6U_32U_mbits_fixed_1_sva)
    );
  SDP_Y_CVT_mgc_shift_r_v4 #(.width_a(32'sd112),
  .signd_a(32'sd1),
  .width_s(32'sd6),
  .width_z(32'sd112)) cvt_2_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_1_rg (
      .a(nl_cvt_2_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_1_rg_a[111:0]),
      .s(nl_cvt_2_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_1_rg_s[5:0]),
      .z(IntShiftRight_49U_6U_32U_mbits_fixed_2_sva)
    );
  SDP_Y_CVT_mgc_shift_r_v4 #(.width_a(32'sd112),
  .signd_a(32'sd1),
  .width_s(32'sd6),
  .width_z(32'sd112)) cvt_3_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_rg (
      .a(nl_cvt_3_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_rg_a[111:0]),
      .s(nl_cvt_3_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_rg_s[5:0]),
      .z(IntShiftRight_49U_6U_32U_mbits_fixed_3_sva)
    );
  SDP_Y_CVT_mgc_shift_r_v4 #(.width_a(32'sd112),
  .signd_a(32'sd1),
  .width_s(32'sd6),
  .width_z(32'sd112)) cvt_4_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_1_rg (
      .a(nl_cvt_4_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_1_rg_a[111:0]),
      .s(nl_cvt_4_IntShiftRight_49U_6U_32U_mbits_fixed_rshift_1_rg_s[5:0]),
      .z(IntShiftRight_49U_6U_32U_mbits_fixed_sva)
    );
  SDP_Y_CVT_mgc_shift_l_v4 #(.width_a(32'sd22),
  .signd_a(32'sd0),
  .width_s(32'sd6),
  .width_z(32'sd23)) cvt_1_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_rg (
      .a(nl_cvt_1_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_rg_a[21:0]),
      .s(nl_cvt_1_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_rg_s[5:0]),
      .z(FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_1_sva_2)
    );
  SDP_Y_CVT_leading_sign_23_0  cvt_1_leading_sign_23_0_rg (
      .mantissa(nl_cvt_1_leading_sign_23_0_rg_mantissa[22:0]),
      .rtn(libraries_leading_sign_23_0_aebf38bbf639c970da88b55f070b6a2d5444_4)
    );
  SDP_Y_CVT_mgc_shift_l_v4 #(.width_a(32'sd22),
  .signd_a(32'sd0),
  .width_s(32'sd6),
  .width_z(32'sd23)) cvt_2_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_1_rg (
      .a(nl_cvt_2_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_1_rg_a[21:0]),
      .s(nl_cvt_2_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_1_rg_s[5:0]),
      .z(FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_2_sva_2)
    );
  SDP_Y_CVT_leading_sign_23_0  cvt_2_leading_sign_23_0_1_rg (
      .mantissa(nl_cvt_2_leading_sign_23_0_1_rg_mantissa[22:0]),
      .rtn(libraries_leading_sign_23_0_aebf38bbf639c970da88b55f070b6a2d5444_5)
    );
  SDP_Y_CVT_mgc_shift_l_v4 #(.width_a(32'sd22),
  .signd_a(32'sd0),
  .width_s(32'sd6),
  .width_z(32'sd23)) cvt_3_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_rg (
      .a(nl_cvt_3_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_rg_a[21:0]),
      .s(nl_cvt_3_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_rg_s[5:0]),
      .z(FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_3_sva_2)
    );
  SDP_Y_CVT_leading_sign_23_0  cvt_3_leading_sign_23_0_rg (
      .mantissa(nl_cvt_3_leading_sign_23_0_rg_mantissa[22:0]),
      .rtn(libraries_leading_sign_23_0_aebf38bbf639c970da88b55f070b6a2d5444_6)
    );
  SDP_Y_CVT_mgc_shift_l_v4 #(.width_a(32'sd22),
  .signd_a(32'sd0),
  .width_s(32'sd6),
  .width_z(32'sd23)) cvt_4_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_1_rg (
      .a(nl_cvt_4_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_1_rg_a[21:0]),
      .s(nl_cvt_4_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_lshift_1_rg_s[5:0]),
      .z(FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_sva_2)
    );
  SDP_Y_CVT_leading_sign_23_0  cvt_4_leading_sign_23_0_1_rg (
      .mantissa(nl_cvt_4_leading_sign_23_0_1_rg_mantissa[22:0]),
      .rtn(libraries_leading_sign_23_0_aebf38bbf639c970da88b55f070b6a2d5444_7)
    );
  NV_NVDLA_SDP_CORE_Y_cvt_core_chn_in_rsci NV_NVDLA_SDP_CORE_Y_cvt_core_chn_in_rsci_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_in_rsc_z(chn_in_rsc_z),
      .chn_in_rsc_vz(chn_in_rsc_vz),
      .chn_in_rsc_lz(chn_in_rsc_lz),
      .chn_in_rsci_oswt(chn_in_rsci_oswt),
      .core_wen(core_wen),
      .chn_in_rsci_iswt0(chn_in_rsci_iswt0),
      .chn_in_rsci_bawt(chn_in_rsci_bawt),
      .chn_in_rsci_wen_comp(chn_in_rsci_wen_comp),
      .chn_in_rsci_ld_core_psct(chn_in_rsci_ld_core_psct),
      .chn_in_rsci_d_mxwt(chn_in_rsci_d_mxwt),
      .core_wten(core_wten)
    );
  NV_NVDLA_SDP_CORE_Y_cvt_core_chn_out_rsci NV_NVDLA_SDP_CORE_Y_cvt_core_chn_out_rsci_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_out_rsc_z(chn_out_rsc_z),
      .chn_out_rsc_vz(chn_out_rsc_vz),
      .chn_out_rsc_lz(chn_out_rsc_lz),
      .chn_out_rsci_oswt(chn_out_rsci_oswt),
      .core_wen(core_wen),
      .core_wten(core_wten),
      .chn_out_rsci_iswt0(chn_out_rsci_iswt0),
      .chn_out_rsci_bawt(chn_out_rsci_bawt),
      .chn_out_rsci_wen_comp(chn_out_rsci_wen_comp),
      .chn_out_rsci_ld_core_psct(reg_chn_out_rsci_ld_core_psct_cse),
      .chn_out_rsci_d(nl_NV_NVDLA_SDP_CORE_Y_cvt_core_chn_out_rsci_inst_chn_out_rsci_d[127:0])
    );
  NV_NVDLA_SDP_CORE_Y_cvt_core_staller NV_NVDLA_SDP_CORE_Y_cvt_core_staller_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .core_wen(core_wen),
      .chn_in_rsci_wen_comp(chn_in_rsci_wen_comp),
      .core_wten(core_wten),
      .chn_out_rsci_wen_comp(chn_out_rsci_wen_comp)
    );
  NV_NVDLA_SDP_CORE_Y_cvt_core_core_fsm NV_NVDLA_SDP_CORE_Y_cvt_core_core_fsm_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .core_wen(core_wen),
      .fsm_output(fsm_output)
    );
  assign iExpoWidth_oExpoWidth_prb = cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth_1_sig_mx0w1;
  // assert(iExpoWidth <= oExpoWidth) - ../include/nvdla_float.h: line 556
  // PSL cvt_1_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln556_assert_iExpoWidth_le_oExpoWidth : assert { iExpoWidth_oExpoWidth_prb } @rose(nvdla_core_clk);
  assign iMantWidth_oMantWidth_prb = cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth_1_sig_mx0w1;
  // assert(iMantWidth <= oMantWidth) - ../include/nvdla_float.h: line 557
  // PSL cvt_1_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln557_assert_iMantWidth_le_oMantWidth : assert { iMantWidth_oMantWidth_prb } @rose(nvdla_core_clk);
  assign iMantWidth_oMantWidth_prb_1 = cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth_1_sig_mx0w1;
  // assert(iMantWidth <= oMantWidth) - ../include/nvdla_float.h: line 508
  // PSL cvt_1_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln508_assert_iMantWidth_le_oMantWidth : assert { iMantWidth_oMantWidth_prb_1 } @rose(nvdla_core_clk);
  assign iExpoWidth_oExpoWidth_prb_1 = cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth_1_sig_mx0w1;
  // assert(iExpoWidth <= oExpoWidth) - ../include/nvdla_float.h: line 433
  // PSL cvt_1_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth : assert { iExpoWidth_oExpoWidth_prb_1 } @rose(nvdla_core_clk);
  assign iExpoWidth_oExpoWidth_prb_2 = cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth_1_sig_mx0w1;
  // assert(iExpoWidth <= oExpoWidth) - ../include/nvdla_float.h: line 556
  // PSL cvt_2_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln556_assert_iExpoWidth_le_oExpoWidth_1 : assert { iExpoWidth_oExpoWidth_prb_2 } @rose(nvdla_core_clk);
  assign iMantWidth_oMantWidth_prb_2 = cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth_1_sig_mx0w1;
  // assert(iMantWidth <= oMantWidth) - ../include/nvdla_float.h: line 557
  // PSL cvt_2_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln557_assert_iMantWidth_le_oMantWidth_1 : assert { iMantWidth_oMantWidth_prb_2 } @rose(nvdla_core_clk);
  assign iMantWidth_oMantWidth_prb_3 = cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth_1_sig_mx0w1;
  // assert(iMantWidth <= oMantWidth) - ../include/nvdla_float.h: line 508
  // PSL cvt_2_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln508_assert_iMantWidth_le_oMantWidth_1 : assert { iMantWidth_oMantWidth_prb_3 } @rose(nvdla_core_clk);
  assign iExpoWidth_oExpoWidth_prb_3 = cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth_1_sig_mx0w1;
  // assert(iExpoWidth <= oExpoWidth) - ../include/nvdla_float.h: line 433
  // PSL cvt_2_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth_1 : assert { iExpoWidth_oExpoWidth_prb_3 } @rose(nvdla_core_clk);
  assign iExpoWidth_oExpoWidth_prb_4 = cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth_1_sig_mx0w1;
  // assert(iExpoWidth <= oExpoWidth) - ../include/nvdla_float.h: line 556
  // PSL cvt_3_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln556_assert_iExpoWidth_le_oExpoWidth : assert { iExpoWidth_oExpoWidth_prb_4 } @rose(nvdla_core_clk);
  assign iMantWidth_oMantWidth_prb_4 = cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth_1_sig_mx0w1;
  // assert(iMantWidth <= oMantWidth) - ../include/nvdla_float.h: line 557
  // PSL cvt_3_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln557_assert_iMantWidth_le_oMantWidth : assert { iMantWidth_oMantWidth_prb_4 } @rose(nvdla_core_clk);
  assign iMantWidth_oMantWidth_prb_5 = cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth_1_sig_mx0w1;
  // assert(iMantWidth <= oMantWidth) - ../include/nvdla_float.h: line 508
  // PSL cvt_3_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln508_assert_iMantWidth_le_oMantWidth : assert { iMantWidth_oMantWidth_prb_5 } @rose(nvdla_core_clk);
  assign iExpoWidth_oExpoWidth_prb_5 = cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth_1_sig_mx0w1;
  // assert(iExpoWidth <= oExpoWidth) - ../include/nvdla_float.h: line 433
  // PSL cvt_3_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth : assert { iExpoWidth_oExpoWidth_prb_5 } @rose(nvdla_core_clk);
  assign iExpoWidth_oExpoWidth_prb_6 = cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth_1_sig_mx0w1;
  // assert(iExpoWidth <= oExpoWidth) - ../include/nvdla_float.h: line 556
  // PSL cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln556_assert_iExpoWidth_le_oExpoWidth_1 : assert { iExpoWidth_oExpoWidth_prb_6 } @rose(nvdla_core_clk);
  assign iMantWidth_oMantWidth_prb_6 = cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth_1_sig_mx0w1;
  // assert(iMantWidth <= oMantWidth) - ../include/nvdla_float.h: line 557
  // PSL cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln557_assert_iMantWidth_le_oMantWidth_1 : assert { iMantWidth_oMantWidth_prb_6 } @rose(nvdla_core_clk);
  assign iMantWidth_oMantWidth_prb_7 = cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth_1_sig_mx0w1;
  // assert(iMantWidth <= oMantWidth) - ../include/nvdla_float.h: line 508
  // PSL cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln508_assert_iMantWidth_le_oMantWidth_1 : assert { iMantWidth_oMantWidth_prb_7 } @rose(nvdla_core_clk);
  assign iExpoWidth_oExpoWidth_prb_7 = cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth_1_sig_mx0w1;
  // assert(iExpoWidth <= oExpoWidth) - ../include/nvdla_float.h: line 433
  // PSL cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth_1 : assert { iExpoWidth_oExpoWidth_prb_7 } @rose(nvdla_core_clk);
  assign oWidth_mWidth_prb = cvt_1_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_sig_mx0w1;
  // assert(oWidth > mWidth) - ../include/nvdla_int.h: line 281
  // PSL cvt_1_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_int_h_ln281_assert_oWidth_gt_mWidth : assert { oWidth_mWidth_prb } @rose(nvdla_core_clk);
  assign oWidth_aWidth_bWidth_prb = cvt_1_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_sig_mx0w1;
  // assert(oWidth >= aWidth+bWidth) - ../include/nvdla_int.h: line 346
  // PSL cvt_1_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth : assert { oWidth_aWidth_bWidth_prb } @rose(nvdla_core_clk);
  assign oWidth_mWidth_prb_1 = cvt_1_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_sig_mx0w1;
  // assert(oWidth > mWidth) - ../include/nvdla_int.h: line 281
  // PSL cvt_2_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_int_h_ln281_assert_oWidth_gt_mWidth_1 : assert { oWidth_mWidth_prb_1 } @rose(nvdla_core_clk);
  assign oWidth_aWidth_bWidth_prb_1 = cvt_1_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_sig_mx0w1;
  // assert(oWidth >= aWidth+bWidth) - ../include/nvdla_int.h: line 346
  // PSL cvt_2_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_1 : assert { oWidth_aWidth_bWidth_prb_1 } @rose(nvdla_core_clk);
  assign oWidth_mWidth_prb_2 = cvt_1_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_sig_mx0w1;
  // assert(oWidth > mWidth) - ../include/nvdla_int.h: line 281
  // PSL cvt_3_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_int_h_ln281_assert_oWidth_gt_mWidth : assert { oWidth_mWidth_prb_2 } @rose(nvdla_core_clk);
  assign oWidth_aWidth_bWidth_prb_2 = cvt_1_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_sig_mx0w1;
  // assert(oWidth >= aWidth+bWidth) - ../include/nvdla_int.h: line 346
  // PSL cvt_3_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth : assert { oWidth_aWidth_bWidth_prb_2 } @rose(nvdla_core_clk);
  assign oWidth_mWidth_prb_3 = cvt_1_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_sig_mx0w1;
  // assert(oWidth > mWidth) - ../include/nvdla_int.h: line 281
  // PSL cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_int_h_ln281_assert_oWidth_gt_mWidth_1 : assert { oWidth_mWidth_prb_3 } @rose(nvdla_core_clk);
  assign oWidth_aWidth_bWidth_prb_3 = cvt_1_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_sig_mx0w1;
  // assert(oWidth >= aWidth+bWidth) - ../include/nvdla_int.h: line 346
  // PSL cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_1 : assert { oWidth_aWidth_bWidth_prb_3 } @rose(nvdla_core_clk);
  assign chn_out_and_cse = core_wen & (~(and_dcpl_17 | (~ main_stage_v_1)));
  assign chn_out_and_20_cse = core_wen & ((and_dcpl_19 & or_66_cse) | and_dcpl_22);
  assign mux_3_nl = MUX_s_1_2_2((~ mux_tmp_1), or_tmp_5, cfg_bypass_rsci_d);
  assign mux_4_nl = MUX_s_1_2_2(or_tmp_2, (mux_3_nl), or_66_cse);
  assign mux_46_nl = MUX_s_1_2_2((mux_4_nl), or_tmp_2, nor_6_cse);
  assign or_3_nl = cfg_bypass_1_sva_st_10 | cfg_bypass_1_sva_2;
  assign mux_6_nl = MUX_s_1_2_2((mux_46_nl), or_tmp_2, or_3_nl);
  assign IntMulExt_33U_16U_49U_o_and_cse = core_wen & (~ and_dcpl_17) & (~ (mux_6_nl));
  assign or_66_cse = (cfg_precision_1_sva_st_6!=2'b10);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_mux1h_nl =
      MUX1HOT_v_4_3_2((cvt_1_if_op_expo_1_lpi_1_dfm[3:0]), (FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_1_sva[3:0]),
      4'b1110, {FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_ssc
      , IsDenorm_5U_23U_land_1_lpi_1_dfm , IsInf_5U_23U_land_1_lpi_1_dfm});
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_3_nl =
      MUX_v_4_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_mux1h_nl),
      4'b1111, IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_tmp);
  assign or_68_nl = (cfg_precision_rsci_d!=2'b10) | and_dcpl_17;
  assign mux_30_nl = MUX_s_1_2_2(and_dcpl_7, (or_68_nl), or_66_cse);
  assign cfg_truncate_mux1h_1_itm = MUX_v_6_2_2(({2'b0 , (FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_3_nl)}),
      cfg_truncate_rsci_d, mux_30_nl);
  assign or_109_cse = (cfg_precision_rsci_d!=2'b10);
  assign or_110_cse = chn_out_rsci_bawt | (~ reg_chn_out_rsci_ld_core_psct_cse);
  assign nor_6_cse = ~((cfg_precision_1_sva_st_6!=2'b10));
  assign nor_20_nl = ~((~((cfg_precision_rsci_d!=2'b10))) | cfg_bypass_rsci_d | (~
      chn_in_rsci_bawt));
  assign nor_22_nl = ~((~((cfg_precision_1_sva_st_8!=2'b10))) | nor_6_cse | (~ main_stage_v_1)
      | cfg_bypass_1_sva_2 | cfg_bypass_1_sva_st_10);
  assign mux_19_nl = MUX_s_1_2_2((nor_22_nl), (nor_20_nl), or_110_cse);
  assign IntMulExt_33U_16U_49U_o_and_1_cse = core_wen & (~ and_dcpl_17) & (mux_19_nl);
  assign and_166_nl = or_66_cse & main_stage_v_1;
  assign mux_47_nl = MUX_s_1_2_2(and_tmp, mux_tmp, and_166_nl);
  assign cfg_precision_and_cse = core_wen & (~ and_dcpl_17) & (mux_47_nl);
  assign nand_nl = ~(((~ chn_in_rsci_bawt) | (cfg_precision_rsci_d!=2'b10)) & or_110_cse);
  assign and_224_nl = chn_in_rsci_bawt & (cfg_precision_rsci_d==2'b10) & or_110_cse;
  assign nor_13_nl = ~((cfg_precision_1_sva_st_6!=2'b10) | (~ main_stage_v_1));
  assign mux_25_nl = MUX_s_1_2_2((and_224_nl), (nand_nl), nor_13_nl);
  assign cvt_1_if_and_cse = core_wen & (~ and_dcpl_17) & (mux_25_nl);
  assign or_14_nl = chn_in_rsci_bawt | (~ or_110_cse);
  assign mux_9_nl = MUX_s_1_2_2(and_6_mdf, (or_14_nl), main_stage_v_1);
  assign cfg_bypass_and_4_cse = core_wen & (~ and_dcpl_17) & (mux_9_nl);
  assign or_56_nl = (or_110_cse & (~ (cfg_precision_rsci_d[0])) & and_dcpl & (fsm_output[1]))
      | (and_dcpl_3 & (~ (cfg_precision_rsci_d[0])) & and_dcpl);
  assign cvt_4_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_float_h_ln433_assert_iExpoWidth_le_oExpoWidth_1_sig_mx0w1
      = MUX1HOT_s_1_1_2(1'b1, or_56_nl);
  assign or_57_nl = (and_dcpl_7 & chn_in_rsci_bawt & (~ cfg_bypass_rsci_d) & (fsm_output[1]))
      | (or_109_cse & reg_chn_out_rsci_ld_core_psct_cse & chn_out_rsci_bawt & chn_in_rsci_bawt
      & (~ cfg_bypass_rsci_d));
  assign cvt_1_NV_NVDLA_SDP_CORE_Y_cvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_sig_mx0w1
      = MUX1HOT_s_1_1_2(1'b1, or_57_nl);
  assign IsDenorm_5U_23U_land_lpi_1_dfm = ((cvt_1_if_op_mant_lpi_1_dfm[9]) | (FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_lpi_1_dfm[8:0]!=9'b000000000))
      & IsZero_5U_23U_IsZero_5U_23U_nor_cse_sva;
  assign cvt_1_if_aelse_not_20_nl = ~ cvt_1_if_land_lpi_1_dfm;
  assign cvt_1_if_op_mant_lpi_1_dfm = MUX_v_10_2_2(10'b0000000000, (chn_in_rsci_d_mxwt[57:48]),
      (cvt_1_if_aelse_not_20_nl));
  assign IsNaN_5U_23U_aelse_not_11_nl = ~ IsNaN_5U_23U_land_lpi_1_dfm;
  assign FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_lpi_1_dfm = MUX_v_10_2_2(10'b0000000000,
      cvt_1_if_op_mant_lpi_1_dfm, (IsNaN_5U_23U_aelse_not_11_nl));
  assign IsZero_5U_23U_IsZero_5U_23U_nor_cse_sva = ~((cvt_1_if_op_expo_lpi_1_dfm!=5'b00000));
  assign cvt_1_if_aelse_not_12_nl = ~ cvt_1_if_land_lpi_1_dfm;
  assign cvt_1_if_op_expo_lpi_1_dfm = MUX_v_5_2_2(5'b00000, (chn_in_rsci_d_mxwt[62:58]),
      (cvt_1_if_aelse_not_12_nl));
  assign IsNaN_5U_23U_land_lpi_1_dfm = ~(IsNaN_5U_10U_nor_3_cse | (cvt_1_if_op_expo_lpi_1_dfm!=5'b11111));
  assign IsNaN_5U_10U_nor_3_cse = ~((chn_in_rsci_d_mxwt[57:48]!=10'b0000000000));
  assign cvt_1_if_land_lpi_1_dfm = (~(IsNaN_5U_10U_nor_3_cse | (chn_in_rsci_d_mxwt[62:58]!=5'b11111)))
      & cfg_nan_to_zero_rsci_d;
  assign IsDenorm_5U_23U_land_3_lpi_1_dfm = ((cvt_1_if_op_mant_3_lpi_1_dfm[9]) |
      (FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_3_lpi_1_dfm[8:0]!=9'b000000000))
      & IsZero_5U_23U_IsZero_5U_23U_nor_cse_3_sva;
  assign cvt_1_if_aelse_not_22_nl = ~ cvt_1_if_land_3_lpi_1_dfm;
  assign cvt_1_if_op_mant_3_lpi_1_dfm = MUX_v_10_2_2(10'b0000000000, (chn_in_rsci_d_mxwt[41:32]),
      (cvt_1_if_aelse_not_22_nl));
  assign IsNaN_5U_23U_aelse_not_10_nl = ~ IsNaN_5U_23U_land_3_lpi_1_dfm;
  assign FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_3_lpi_1_dfm = MUX_v_10_2_2(10'b0000000000,
      cvt_1_if_op_mant_3_lpi_1_dfm, (IsNaN_5U_23U_aelse_not_10_nl));
  assign IsZero_5U_23U_IsZero_5U_23U_nor_cse_3_sva = ~((cvt_1_if_op_expo_3_lpi_1_dfm!=5'b00000));
  assign cvt_1_if_aelse_not_14_nl = ~ cvt_1_if_land_3_lpi_1_dfm;
  assign cvt_1_if_op_expo_3_lpi_1_dfm = MUX_v_5_2_2(5'b00000, (chn_in_rsci_d_mxwt[46:42]),
      (cvt_1_if_aelse_not_14_nl));
  assign IsNaN_5U_23U_land_3_lpi_1_dfm = ~(IsNaN_5U_10U_nor_2_cse | (cvt_1_if_op_expo_3_lpi_1_dfm!=5'b11111));
  assign IsNaN_5U_10U_nor_2_cse = ~((chn_in_rsci_d_mxwt[41:32]!=10'b0000000000));
  assign cvt_1_if_land_3_lpi_1_dfm = (~(IsNaN_5U_10U_nor_2_cse | (chn_in_rsci_d_mxwt[46:42]!=5'b11111)))
      & cfg_nan_to_zero_rsci_d;
  assign IsDenorm_5U_23U_land_2_lpi_1_dfm = ((cvt_1_if_op_mant_2_lpi_1_dfm[9]) |
      (FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_2_lpi_1_dfm[8:0]!=9'b000000000))
      & IsZero_5U_23U_IsZero_5U_23U_nor_cse_2_sva;
  assign cvt_1_if_aelse_not_24_nl = ~ cvt_1_if_land_2_lpi_1_dfm;
  assign cvt_1_if_op_mant_2_lpi_1_dfm = MUX_v_10_2_2(10'b0000000000, (chn_in_rsci_d_mxwt[25:16]),
      (cvt_1_if_aelse_not_24_nl));
  assign IsNaN_5U_23U_aelse_not_9_nl = ~ IsNaN_5U_23U_land_2_lpi_1_dfm;
  assign FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_2_lpi_1_dfm = MUX_v_10_2_2(10'b0000000000,
      cvt_1_if_op_mant_2_lpi_1_dfm, (IsNaN_5U_23U_aelse_not_9_nl));
  assign IsZero_5U_23U_IsZero_5U_23U_nor_cse_2_sva = ~((cvt_1_if_op_expo_2_lpi_1_dfm!=5'b00000));
  assign cvt_1_if_aelse_not_16_nl = ~ cvt_1_if_land_2_lpi_1_dfm;
  assign cvt_1_if_op_expo_2_lpi_1_dfm = MUX_v_5_2_2(5'b00000, (chn_in_rsci_d_mxwt[30:26]),
      (cvt_1_if_aelse_not_16_nl));
  assign IsNaN_5U_23U_land_2_lpi_1_dfm = ~(IsNaN_5U_10U_nor_1_cse | (cvt_1_if_op_expo_2_lpi_1_dfm!=5'b11111));
  assign IsNaN_5U_10U_nor_1_cse = ~((chn_in_rsci_d_mxwt[25:16]!=10'b0000000000));
  assign cvt_1_if_land_2_lpi_1_dfm = (~(IsNaN_5U_10U_nor_1_cse | (chn_in_rsci_d_mxwt[30:26]!=5'b11111)))
      & cfg_nan_to_zero_rsci_d;
  assign IsDenorm_5U_23U_land_1_lpi_1_dfm = ((cvt_1_if_op_mant_1_lpi_1_dfm[9]) |
      (FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_1_lpi_1_dfm[8:0]!=9'b000000000))
      & IsZero_5U_23U_IsZero_5U_23U_nor_cse_1_sva;
  assign cvt_1_if_aelse_not_26_nl = ~ cvt_1_if_land_1_lpi_1_dfm;
  assign cvt_1_if_op_mant_1_lpi_1_dfm = MUX_v_10_2_2(10'b0000000000, (chn_in_rsci_d_mxwt[9:0]),
      (cvt_1_if_aelse_not_26_nl));
  assign IsNaN_5U_23U_aelse_not_8_nl = ~ IsNaN_5U_23U_land_1_lpi_1_dfm;
  assign FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_1_lpi_1_dfm = MUX_v_10_2_2(10'b0000000000,
      cvt_1_if_op_mant_1_lpi_1_dfm, (IsNaN_5U_23U_aelse_not_8_nl));
  assign IsZero_5U_23U_IsZero_5U_23U_nor_cse_1_sva = ~((cvt_1_if_op_expo_1_lpi_1_dfm!=5'b00000));
  assign cvt_1_if_aelse_not_18_nl = ~ cvt_1_if_land_1_lpi_1_dfm;
  assign cvt_1_if_op_expo_1_lpi_1_dfm = MUX_v_5_2_2(5'b00000, (chn_in_rsci_d_mxwt[14:10]),
      (cvt_1_if_aelse_not_18_nl));
  assign IsNaN_5U_23U_land_1_lpi_1_dfm = ~(IsNaN_5U_10U_nor_cse | (cvt_1_if_op_expo_1_lpi_1_dfm!=5'b11111));
  assign IsNaN_5U_10U_nor_cse = ~((chn_in_rsci_d_mxwt[9:0]!=10'b0000000000));
  assign cvt_1_if_land_1_lpi_1_dfm = (~(IsNaN_5U_10U_nor_cse | (chn_in_rsci_d_mxwt[14:10]!=5'b11111)))
      & cfg_nan_to_zero_rsci_d;
  assign cvt_1_IntShiftRight_49U_6U_32U_obits_fixed_nor_2_nl = ~(MUX_v_30_2_2((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_1_sva[30:1]),
      30'b111111111111111111111111111111, IntShiftRight_49U_6U_32U_obits_fixed_nor_ovfl_1_sva));
  assign cvt_1_else_else_o_tct_30_1_1_sva = ~(MUX_v_30_2_2((cvt_1_IntShiftRight_49U_6U_32U_obits_fixed_nor_2_nl),
      30'b111111111111111111111111111111, IntShiftRight_49U_6U_32U_obits_fixed_and_unfl_1_sva));
  assign cvt_1_IntShiftRight_49U_6U_32U_obits_fixed_and_nl = (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[62])
      & ((IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[0]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[1])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[2]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[3])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[4]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[5])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[6]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[7])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[8]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[9])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[10]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[11])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[12]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[13])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[14]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[15])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[16]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[17])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[18]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[19])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[20]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[21])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[22]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[23])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[24]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[25])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[26]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[27])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[28]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[29])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[30]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[31])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[32]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[33])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[34]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[35])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[36]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[37])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[38]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[39])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[40]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[41])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[42]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[43])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[44]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[45])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[46]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[47])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[48]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[49])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[50]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[51])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[52]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[53])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[54]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[55])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[56]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[57])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[58]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[59])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[60]) | (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[61])
      | (~ (IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[111])));
  assign nl_IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_1_sva = conv_s2s_49_50(IntShiftRight_49U_6U_32U_mbits_fixed_1_sva[111:63])
      + conv_u2s_1_50(cvt_1_IntShiftRight_49U_6U_32U_obits_fixed_and_nl);
  assign IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_1_sva = nl_IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_1_sva[49:0];
  assign IntShiftRight_49U_6U_32U_obits_fixed_nor_ovfl_1_sva = ~((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_1_sva[49])
      | (~((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_1_sva[48:31]!=18'b000000000000000000))));
  assign IntShiftRight_49U_6U_32U_obits_fixed_and_unfl_1_sva = (IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_1_sva[49])
      & (~((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_1_sva[48:31]==18'b111111111111111111)));
  assign cvt_2_IntShiftRight_49U_6U_32U_obits_fixed_nor_7_nl = ~(MUX_v_30_2_2((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_2_sva[30:1]),
      30'b111111111111111111111111111111, IntShiftRight_49U_6U_32U_obits_fixed_nor_ovfl_2_sva));
  assign cvt_1_else_else_o_tct_30_1_2_sva = ~(MUX_v_30_2_2((cvt_2_IntShiftRight_49U_6U_32U_obits_fixed_nor_7_nl),
      30'b111111111111111111111111111111, IntShiftRight_49U_6U_32U_obits_fixed_and_unfl_2_sva));
  assign cvt_2_IntShiftRight_49U_6U_32U_obits_fixed_and_2_nl = (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[62])
      & ((IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[0]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[1])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[2]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[3])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[4]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[5])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[6]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[7])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[8]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[9])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[10]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[11])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[12]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[13])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[14]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[15])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[16]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[17])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[18]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[19])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[20]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[21])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[22]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[23])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[24]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[25])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[26]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[27])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[28]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[29])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[30]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[31])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[32]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[33])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[34]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[35])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[36]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[37])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[38]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[39])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[40]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[41])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[42]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[43])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[44]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[45])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[46]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[47])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[48]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[49])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[50]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[51])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[52]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[53])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[54]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[55])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[56]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[57])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[58]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[59])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[60]) | (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[61])
      | (~ (IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[111])));
  assign nl_IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_2_sva = conv_s2s_49_50(IntShiftRight_49U_6U_32U_mbits_fixed_2_sva[111:63])
      + conv_u2s_1_50(cvt_2_IntShiftRight_49U_6U_32U_obits_fixed_and_2_nl);
  assign IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_2_sva = nl_IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_2_sva[49:0];
  assign IntShiftRight_49U_6U_32U_obits_fixed_nor_ovfl_2_sva = ~((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_2_sva[49])
      | (~((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_2_sva[48:31]!=18'b000000000000000000))));
  assign IntShiftRight_49U_6U_32U_obits_fixed_and_unfl_2_sva = (IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_2_sva[49])
      & (~((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_2_sva[48:31]==18'b111111111111111111)));
  assign cvt_3_IntShiftRight_49U_6U_32U_obits_fixed_nor_2_nl = ~(MUX_v_30_2_2((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_3_sva[30:1]),
      30'b111111111111111111111111111111, IntShiftRight_49U_6U_32U_obits_fixed_nor_ovfl_3_sva));
  assign cvt_1_else_else_o_tct_30_1_3_sva = ~(MUX_v_30_2_2((cvt_3_IntShiftRight_49U_6U_32U_obits_fixed_nor_2_nl),
      30'b111111111111111111111111111111, IntShiftRight_49U_6U_32U_obits_fixed_and_unfl_3_sva));
  assign cvt_3_IntShiftRight_49U_6U_32U_obits_fixed_and_nl = (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[62])
      & ((IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[0]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[1])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[2]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[3])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[4]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[5])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[6]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[7])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[8]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[9])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[10]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[11])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[12]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[13])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[14]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[15])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[16]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[17])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[18]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[19])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[20]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[21])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[22]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[23])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[24]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[25])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[26]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[27])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[28]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[29])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[30]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[31])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[32]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[33])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[34]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[35])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[36]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[37])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[38]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[39])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[40]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[41])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[42]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[43])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[44]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[45])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[46]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[47])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[48]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[49])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[50]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[51])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[52]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[53])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[54]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[55])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[56]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[57])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[58]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[59])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[60]) | (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[61])
      | (~ (IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[111])));
  assign nl_IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_3_sva = conv_s2s_49_50(IntShiftRight_49U_6U_32U_mbits_fixed_3_sva[111:63])
      + conv_u2s_1_50(cvt_3_IntShiftRight_49U_6U_32U_obits_fixed_and_nl);
  assign IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_3_sva = nl_IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_3_sva[49:0];
  assign IntShiftRight_49U_6U_32U_obits_fixed_nor_ovfl_3_sva = ~((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_3_sva[49])
      | (~((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_3_sva[48:31]!=18'b000000000000000000))));
  assign IntShiftRight_49U_6U_32U_obits_fixed_and_unfl_3_sva = (IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_3_sva[49])
      & (~((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_3_sva[48:31]==18'b111111111111111111)));
  assign cvt_4_IntShiftRight_49U_6U_32U_obits_fixed_nor_7_nl = ~(MUX_v_30_2_2((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_sva[30:1]),
      30'b111111111111111111111111111111, IntShiftRight_49U_6U_32U_obits_fixed_nor_ovfl_sva));
  assign cvt_1_else_else_o_tct_30_1_sva = ~(MUX_v_30_2_2((cvt_4_IntShiftRight_49U_6U_32U_obits_fixed_nor_7_nl),
      30'b111111111111111111111111111111, IntShiftRight_49U_6U_32U_obits_fixed_and_unfl_sva));
  assign cvt_4_IntShiftRight_49U_6U_32U_obits_fixed_and_2_nl = (IntShiftRight_49U_6U_32U_mbits_fixed_sva[62])
      & ((IntShiftRight_49U_6U_32U_mbits_fixed_sva[0]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[1])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[2]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[3])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[4]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[5])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[6]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[7])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[8]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[9])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[10]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[11])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[12]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[13])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[14]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[15])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[16]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[17])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[18]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[19])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[20]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[21])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[22]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[23])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[24]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[25])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[26]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[27])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[28]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[29])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[30]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[31])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[32]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[33])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[34]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[35])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[36]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[37])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[38]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[39])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[40]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[41])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[42]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[43])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[44]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[45])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[46]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[47])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[48]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[49])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[50]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[51])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[52]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[53])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[54]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[55])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[56]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[57])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[58]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[59])
      | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[60]) | (IntShiftRight_49U_6U_32U_mbits_fixed_sva[61])
      | (~ (IntShiftRight_49U_6U_32U_mbits_fixed_sva[111])));
  assign nl_IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_sva = conv_s2s_49_50(IntShiftRight_49U_6U_32U_mbits_fixed_sva[111:63])
      + conv_u2s_1_50(cvt_4_IntShiftRight_49U_6U_32U_obits_fixed_and_2_nl);
  assign IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_sva = nl_IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_sva[49:0];
  assign IntShiftRight_49U_6U_32U_obits_fixed_nor_ovfl_sva = ~((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_sva[49])
      | (~((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_sva[48:31]!=18'b000000000000000000))));
  assign IntShiftRight_49U_6U_32U_obits_fixed_and_unfl_sva = (IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_sva[49])
      & (~((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_sva[48:31]==18'b111111111111111111)));
  assign cvt_1_unequal_tmp = ~((cfg_precision_1_sva_st_6==2'b10));
  assign and_6_mdf = chn_in_rsci_bawt & or_110_cse;
  assign nl_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_1_sva = ({1'b1 , (~ libraries_leading_sign_23_0_aebf38bbf639c970da88b55f070b6a2d5444_4)})
      + 6'b110001;
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_1_sva = nl_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_1_sva[5:0];
  assign nl_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_2_sva = ({1'b1 , (~ libraries_leading_sign_23_0_aebf38bbf639c970da88b55f070b6a2d5444_5)})
      + 6'b110001;
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_2_sva = nl_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_2_sva[5:0];
  assign nl_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_3_sva = ({1'b1 , (~ libraries_leading_sign_23_0_aebf38bbf639c970da88b55f070b6a2d5444_6)})
      + 6'b110001;
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_3_sva = nl_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_3_sva[5:0];
  assign nl_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_sva = ({1'b1 , (~ libraries_leading_sign_23_0_aebf38bbf639c970da88b55f070b6a2d5444_7)})
      + 6'b110001;
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_sva = nl_FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_sva[5:0];
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_6_ssc
      = ~(IsDenorm_5U_23U_land_lpi_1_dfm | IsInf_5U_23U_land_lpi_1_dfm);
  assign IsInf_5U_23U_land_lpi_1_dfm = ~((FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_lpi_1_dfm!=10'b0000000000)
      | (FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_9_0_lpi_1_dfm!=10'b0000000000) |
      (~ IsInf_5U_23U_IsInf_5U_23U_and_cse_sva));
  assign IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_3_tmp = ((FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_lpi_1_dfm!=10'b0000000000)
      | (FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_9_0_lpi_1_dfm!=10'b0000000000)) &
      IsInf_5U_23U_IsInf_5U_23U_and_cse_sva;
  assign FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_9_0_lpi_1_dfm = MUX_v_10_2_2(10'b0000000000,
      (chn_in_rsci_d_mxwt[57:48]), IsNaN_5U_23U_land_lpi_1_dfm);
  assign IsInf_5U_23U_IsInf_5U_23U_and_cse_sva = (cvt_1_if_op_expo_lpi_1_dfm==5'b11111);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_4_ssc
      = ~(IsDenorm_5U_23U_land_3_lpi_1_dfm | IsInf_5U_23U_land_3_lpi_1_dfm);
  assign IsInf_5U_23U_land_3_lpi_1_dfm = ~((FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_3_lpi_1_dfm!=10'b0000000000)
      | (FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_9_0_3_lpi_1_dfm!=10'b0000000000)
      | (~ IsInf_5U_23U_IsInf_5U_23U_and_cse_3_sva));
  assign IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_2_tmp = ((FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_3_lpi_1_dfm!=10'b0000000000)
      | (FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_9_0_3_lpi_1_dfm!=10'b0000000000))
      & IsInf_5U_23U_IsInf_5U_23U_and_cse_3_sva;
  assign FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_9_0_3_lpi_1_dfm = MUX_v_10_2_2(10'b0000000000,
      (chn_in_rsci_d_mxwt[41:32]), IsNaN_5U_23U_land_3_lpi_1_dfm);
  assign IsInf_5U_23U_IsInf_5U_23U_and_cse_3_sva = (cvt_1_if_op_expo_3_lpi_1_dfm==5'b11111);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_2_ssc
      = ~(IsDenorm_5U_23U_land_2_lpi_1_dfm | IsInf_5U_23U_land_2_lpi_1_dfm);
  assign IsInf_5U_23U_land_2_lpi_1_dfm = ~((FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_2_lpi_1_dfm!=10'b0000000000)
      | (FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_9_0_2_lpi_1_dfm!=10'b0000000000)
      | (~ IsInf_5U_23U_IsInf_5U_23U_and_cse_2_sva));
  assign IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_1_tmp = ((FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_2_lpi_1_dfm!=10'b0000000000)
      | (FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_9_0_2_lpi_1_dfm!=10'b0000000000))
      & IsInf_5U_23U_IsInf_5U_23U_and_cse_2_sva;
  assign FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_9_0_2_lpi_1_dfm = MUX_v_10_2_2(10'b0000000000,
      (chn_in_rsci_d_mxwt[25:16]), IsNaN_5U_23U_land_2_lpi_1_dfm);
  assign IsInf_5U_23U_IsInf_5U_23U_and_cse_2_sva = (cvt_1_if_op_expo_2_lpi_1_dfm==5'b11111);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_ssc =
      ~(IsDenorm_5U_23U_land_1_lpi_1_dfm | IsInf_5U_23U_land_1_lpi_1_dfm);
  assign IsInf_5U_23U_land_1_lpi_1_dfm = ~((FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_1_lpi_1_dfm!=10'b0000000000)
      | (FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_9_0_1_lpi_1_dfm!=10'b0000000000)
      | (~ IsInf_5U_23U_IsInf_5U_23U_and_cse_1_sva));
  assign IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_tmp = ((FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_1_lpi_1_dfm!=10'b0000000000)
      | (FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_9_0_1_lpi_1_dfm!=10'b0000000000))
      & IsInf_5U_23U_IsInf_5U_23U_and_cse_1_sva;
  assign FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_9_0_1_lpi_1_dfm = MUX_v_10_2_2(10'b0000000000,
      (chn_in_rsci_d_mxwt[9:0]), IsNaN_5U_23U_land_1_lpi_1_dfm);
  assign IsInf_5U_23U_IsInf_5U_23U_and_cse_1_sva = (cvt_1_if_op_expo_1_lpi_1_dfm==5'b11111);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_exs_71_0 = (cvt_1_if_op_mant_lpi_1_dfm[9])
      | (FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_lpi_1_dfm[8:0]!=9'b000000000)
      | (~ IsZero_5U_23U_IsZero_5U_23U_nor_cse_sva);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_exs_79_0 = (cvt_1_if_op_mant_3_lpi_1_dfm[9])
      | (FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_3_lpi_1_dfm[8:0]!=9'b000000000)
      | (~ IsZero_5U_23U_IsZero_5U_23U_nor_cse_3_sva);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_exs_87_0 = (cvt_1_if_op_mant_2_lpi_1_dfm[9])
      | (FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_2_lpi_1_dfm[8:0]!=9'b000000000)
      | (~ IsZero_5U_23U_IsZero_5U_23U_nor_cse_2_sva);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_exs_95_0 = (cvt_1_if_op_mant_1_lpi_1_dfm[9])
      | (FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_1_lpi_1_dfm[8:0]!=9'b000000000)
      | (~ IsZero_5U_23U_IsZero_5U_23U_nor_cse_1_sva);
  assign cvt_1_asn_63 = (~ cfg_bypass_1_sva_2) & cvt_1_unequal_tmp;
  assign cvt_1_asn_65 = cfg_bypass_1_sva_2 & cvt_1_unequal_tmp;
  assign and_dcpl = (cfg_precision_rsci_d[1]) & chn_in_rsci_bawt;
  assign and_dcpl_3 = reg_chn_out_rsci_ld_core_psct_cse & chn_out_rsci_bawt;
  assign and_dcpl_7 = or_110_cse & or_109_cse;
  assign and_tmp = chn_in_rsci_bawt & and_dcpl_7;
  assign or_tmp_2 = cfg_bypass_rsci_d | (~ and_tmp);
  assign or_tmp_5 = (~ main_stage_v_1) | chn_out_rsci_bawt | (~ reg_chn_out_rsci_ld_core_psct_cse);
  assign or_9_nl = (cfg_precision_rsci_d!=2'b10) | (~ or_110_cse);
  assign mux_tmp = MUX_s_1_2_2((~ or_110_cse), (or_9_nl), chn_in_rsci_bawt);
  assign mux_tmp_1 = MUX_s_1_2_2(and_tmp, mux_tmp, main_stage_v_1);
  assign and_tmp_3 = cfg_bypass_rsci_d & chn_in_rsci_bawt & and_dcpl_7;
  assign and_dcpl_17 = (~ chn_out_rsci_bawt) & reg_chn_out_rsci_ld_core_psct_cse;
  assign and_dcpl_19 = or_110_cse & main_stage_v_1;
  assign and_dcpl_22 = and_dcpl_19 & (cfg_precision_1_sva_st_6==2'b10);
  assign and_dcpl_23 = and_dcpl_3 & (~ main_stage_v_1);
  assign or_tmp_63 = or_110_cse & chn_in_rsci_bawt & (fsm_output[1]);
  assign chn_in_rsci_ld_core_psct_mx0c0 = and_6_mdf | (fsm_output[0]);
  assign main_stage_v_1_mx0c1 = or_110_cse & (~ chn_in_rsci_bawt) & main_stage_v_1;
  assign chn_in_rsci_oswt_unreg = or_tmp_63;
  assign chn_out_rsci_oswt_unreg = and_dcpl_3;
  assign or_dcpl = (or_110_cse & (~ IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_tmp)
      & FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_ssc) |
      (or_110_cse & IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_tmp);
  assign or_dcpl_10 = (or_110_cse & (~ IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_3_tmp)
      & FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_6_ssc)
      | (or_110_cse & IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_3_tmp);
  assign or_dcpl_11 = (or_110_cse & (~ IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_1_tmp)
      & FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_2_ssc)
      | (or_110_cse & IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_1_tmp);
  assign or_dcpl_12 = (or_110_cse & (~ IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_2_tmp)
      & FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_4_ssc)
      | (or_110_cse & IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_2_tmp);
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_in_rsci_iswt0 <= 1'b0;
      chn_out_rsci_iswt0 <= 1'b0;
    end
    else if ( core_wen ) begin
      chn_in_rsci_iswt0 <= ~((~ and_6_mdf) & (fsm_output[1]));
      chn_out_rsci_iswt0 <= and_dcpl_19;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_in_rsci_ld_core_psct <= 1'b0;
    end
    else if ( core_wen & chn_in_rsci_ld_core_psct_mx0c0 ) begin
      chn_in_rsci_ld_core_psct <= chn_in_rsci_ld_core_psct_mx0c0;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_out_rsci_d_9_1 <= 9'b0;
      chn_out_rsci_d_12_10 <= 3'b0;
      chn_out_rsci_d_22_13 <= 10'b0;
      chn_out_rsci_d_28_27 <= 2'b0;
      chn_out_rsci_d_30_29 <= 2'b0;
      chn_out_rsci_d_41_33 <= 9'b0;
      chn_out_rsci_d_44_42 <= 3'b0;
      chn_out_rsci_d_54_45 <= 10'b0;
      chn_out_rsci_d_60_59 <= 2'b0;
      chn_out_rsci_d_62_61 <= 2'b0;
      chn_out_rsci_d_73_65 <= 9'b0;
      chn_out_rsci_d_76_74 <= 3'b0;
      chn_out_rsci_d_86_77 <= 10'b0;
      chn_out_rsci_d_92_91 <= 2'b0;
      chn_out_rsci_d_94_93 <= 2'b0;
      chn_out_rsci_d_105_97 <= 9'b0;
      chn_out_rsci_d_108_106 <= 3'b0;
      chn_out_rsci_d_118_109 <= 10'b0;
      chn_out_rsci_d_124_123 <= 2'b0;
      chn_out_rsci_d_126_125 <= 2'b0;
      chn_out_rsci_d_26_23 <= 4'b0;
      chn_out_rsci_d_58_55 <= 4'b0;
      chn_out_rsci_d_90_87 <= 4'b0;
      chn_out_rsci_d_122_119 <= 4'b0;
    end
    else if ( chn_out_and_cse ) begin
      chn_out_rsci_d_9_1 <= MUX1HOT_v_9_3_2((FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_1_lpi_1_dfm_5_9_0_1[9:1]),
          (cvt_1_else_else_o_tct_30_1_1_sva[8:0]), (data_in_data_sva_78[9:1]), {(~
          cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_12_10 <= MUX1HOT_v_3_3_2(FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_1_lpi_1_dfm_5_12_10_1,
          (cvt_1_else_else_o_tct_30_1_1_sva[11:9]), (data_in_data_sva_78[12:10]),
          {(~ cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_22_13 <= MUX1HOT_v_10_3_2(FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_1_lpi_1_dfm_5_22_13_1,
          (cvt_1_else_else_o_tct_30_1_1_sva[21:12]), (signext_10_3(data_in_data_sva_78[15:13])),
          {(~ cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_28_27 <= MUX1HOT_v_2_3_2(FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_1_lpi_1_dfm_5_1_0_1,
          (cvt_1_else_else_o_tct_30_1_1_sva[27:26]), (signext_2_1(data_in_data_sva_78[15])),
          {(~ cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_30_29 <= MUX1HOT_v_2_3_2(FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_1_lpi_1_dfm_5_3_2_1,
          (cvt_1_else_else_o_tct_30_1_1_sva[29:28]), (signext_2_1(data_in_data_sva_78[15])),
          {(~ cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_41_33 <= MUX1HOT_v_9_3_2((FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_2_lpi_1_dfm_5_9_0_1[9:1]),
          (cvt_1_else_else_o_tct_30_1_2_sva[8:0]), (data_in_data_sva_78[25:17]),
          {(~ cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_44_42 <= MUX1HOT_v_3_3_2(FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_2_lpi_1_dfm_5_12_10_1,
          (cvt_1_else_else_o_tct_30_1_2_sva[11:9]), (data_in_data_sva_78[28:26]),
          {(~ cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_54_45 <= MUX1HOT_v_10_3_2(FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_2_lpi_1_dfm_5_22_13_1,
          (cvt_1_else_else_o_tct_30_1_2_sva[21:12]), (signext_10_3(data_in_data_sva_78[31:29])),
          {(~ cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_60_59 <= MUX1HOT_v_2_3_2(FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_2_lpi_1_dfm_5_1_0_1,
          (cvt_1_else_else_o_tct_30_1_2_sva[27:26]), (signext_2_1(data_in_data_sva_78[31])),
          {(~ cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_62_61 <= MUX1HOT_v_2_3_2(FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_2_lpi_1_dfm_5_3_2_1,
          (cvt_1_else_else_o_tct_30_1_2_sva[29:28]), (signext_2_1(data_in_data_sva_78[31])),
          {(~ cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_73_65 <= MUX1HOT_v_9_3_2((FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_3_lpi_1_dfm_5_9_0_1[9:1]),
          (cvt_1_else_else_o_tct_30_1_3_sva[8:0]), (data_in_data_sva_78[41:33]),
          {(~ cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_76_74 <= MUX1HOT_v_3_3_2(FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_3_lpi_1_dfm_5_12_10_1,
          (cvt_1_else_else_o_tct_30_1_3_sva[11:9]), (data_in_data_sva_78[44:42]),
          {(~ cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_86_77 <= MUX1HOT_v_10_3_2(FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_3_lpi_1_dfm_5_22_13_1,
          (cvt_1_else_else_o_tct_30_1_3_sva[21:12]), (signext_10_3(data_in_data_sva_78[47:45])),
          {(~ cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_92_91 <= MUX1HOT_v_2_3_2(FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_3_lpi_1_dfm_5_1_0_1,
          (cvt_1_else_else_o_tct_30_1_3_sva[27:26]), (signext_2_1(data_in_data_sva_78[47])),
          {(~ cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_94_93 <= MUX1HOT_v_2_3_2(FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_3_lpi_1_dfm_5_3_2_1,
          (cvt_1_else_else_o_tct_30_1_3_sva[29:28]), (signext_2_1(data_in_data_sva_78[47])),
          {(~ cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_105_97 <= MUX1HOT_v_9_3_2((FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_lpi_1_dfm_5_9_0_1[9:1]),
          (cvt_1_else_else_o_tct_30_1_sva[8:0]), (data_in_data_sva_78[57:49]), {(~
          cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_108_106 <= MUX1HOT_v_3_3_2(FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_lpi_1_dfm_5_12_10_1,
          (cvt_1_else_else_o_tct_30_1_sva[11:9]), (data_in_data_sva_78[60:58]), {(~
          cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_118_109 <= MUX1HOT_v_10_3_2(FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_lpi_1_dfm_5_22_13_1,
          (cvt_1_else_else_o_tct_30_1_sva[21:12]), (signext_10_3(data_in_data_sva_78[63:61])),
          {(~ cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_124_123 <= MUX1HOT_v_2_3_2(FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_lpi_1_dfm_5_1_0_1,
          (cvt_1_else_else_o_tct_30_1_sva[27:26]), (signext_2_1(data_in_data_sva_78[63])),
          {(~ cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_126_125 <= MUX1HOT_v_2_3_2(FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_lpi_1_dfm_5_3_2_1,
          (cvt_1_else_else_o_tct_30_1_sva[29:28]), (signext_2_1(data_in_data_sva_78[63])),
          {(~ cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_26_23 <= MUX1HOT_v_4_3_2(reg_cfg_truncate_1_1_itm, (cvt_1_else_else_o_tct_30_1_1_sva[25:22]),
          (signext_4_1(data_in_data_sva_78[15])), {(~ cvt_1_unequal_tmp) , cvt_1_asn_63
          , cvt_1_asn_65});
      chn_out_rsci_d_58_55 <= MUX1HOT_v_4_3_2(FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_3_0_2_lpi_1_dfm_6,
          (cvt_1_else_else_o_tct_30_1_2_sva[25:22]), (signext_4_1(data_in_data_sva_78[31])),
          {(~ cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_90_87 <= MUX1HOT_v_4_3_2(FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_3_0_3_lpi_1_dfm_6,
          (cvt_1_else_else_o_tct_30_1_3_sva[25:22]), (signext_4_1(data_in_data_sva_78[47])),
          {(~ cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
      chn_out_rsci_d_122_119 <= MUX1HOT_v_4_3_2(FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_3_0_lpi_1_dfm_6,
          (cvt_1_else_else_o_tct_30_1_sva[25:22]), (signext_4_1(data_in_data_sva_78[63])),
          {(~ cvt_1_unequal_tmp) , cvt_1_asn_63 , cvt_1_asn_65});
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_out_rsci_d_0 <= 1'b0;
      chn_out_rsci_d_31 <= 1'b0;
      chn_out_rsci_d_32 <= 1'b0;
      chn_out_rsci_d_63 <= 1'b0;
      chn_out_rsci_d_64 <= 1'b0;
      chn_out_rsci_d_95 <= 1'b0;
      chn_out_rsci_d_96 <= 1'b0;
      chn_out_rsci_d_127 <= 1'b0;
    end
    else if ( chn_out_and_20_cse ) begin
      chn_out_rsci_d_0 <= MUX_s_1_2_2((cvt_1_else_mux_39_nl), (FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_1_lpi_1_dfm_5_9_0_1[0]),
          and_dcpl_22);
      chn_out_rsci_d_31 <= MUX_s_1_2_2((cvt_1_else_mux_40_nl), cvt_1_if_cvt_1_if_and_itm_2,
          and_dcpl_22);
      chn_out_rsci_d_32 <= MUX_s_1_2_2((cvt_1_else_mux_41_nl), (FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_2_lpi_1_dfm_5_9_0_1[0]),
          and_dcpl_22);
      chn_out_rsci_d_63 <= MUX_s_1_2_2((cvt_1_else_mux_42_nl), cvt_1_if_cvt_1_if_and_3_itm_2,
          and_dcpl_22);
      chn_out_rsci_d_64 <= MUX_s_1_2_2((cvt_1_else_mux_43_nl), (FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_3_lpi_1_dfm_5_9_0_1[0]),
          and_dcpl_22);
      chn_out_rsci_d_95 <= MUX_s_1_2_2((cvt_1_else_mux_44_nl), cvt_1_if_cvt_1_if_and_6_itm_2,
          and_dcpl_22);
      chn_out_rsci_d_96 <= MUX_s_1_2_2((cvt_1_else_mux_45_nl), (FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_lpi_1_dfm_5_9_0_1[0]),
          and_dcpl_22);
      chn_out_rsci_d_127 <= MUX_s_1_2_2((cvt_1_else_mux_46_nl), cvt_1_if_cvt_1_if_and_9_itm_2,
          and_dcpl_22);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_chn_out_rsci_ld_core_psct_cse <= 1'b0;
    end
    else if ( core_wen & (and_dcpl_19 | and_dcpl_23) ) begin
      reg_chn_out_rsci_ld_core_psct_cse <= ~ and_dcpl_23;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      main_stage_v_1 <= 1'b0;
    end
    else if ( core_wen & (or_tmp_63 | main_stage_v_1_mx0c1) ) begin
      main_stage_v_1 <= ~ main_stage_v_1_mx0c1;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      cvt_1_IntMulExt_33U_16U_49U_o_mul_itm_2 <= 49'b0;
      cvt_3_IntMulExt_33U_16U_49U_o_mul_itm_2 <= 49'b0;
    end
    else if ( IntMulExt_33U_16U_49U_o_and_cse ) begin
      cvt_1_IntMulExt_33U_16U_49U_o_mul_itm_2 <= conv_s2u_49_49($signed((cvt_1_IntSubExt_16U_32U_33U_o_acc_nl))
          * $signed((cfg_scale_rsci_d)));
      cvt_3_IntMulExt_33U_16U_49U_o_mul_itm_2 <= conv_s2u_49_49($signed((cvt_3_IntSubExt_16U_32U_33U_o_acc_nl))
          * $signed((cfg_scale_rsci_d)));
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_cfg_truncate_1_itm <= 2'b0;
    end
    else if ( core_wen & chn_in_rsci_bawt & or_109_cse & (~((~(chn_out_rsci_bawt
        | (~ reg_chn_out_rsci_ld_core_psct_cse))) | cfg_bypass_rsci_d)) ) begin
      reg_cfg_truncate_1_itm <= cfg_truncate_mux1h_1_itm[5:4];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_cfg_truncate_1_1_itm <= 4'b0;
    end
    else if ( (~((~((cfg_precision_rsci_d==2'b10))) & cfg_bypass_rsci_d)) & core_wen
        & or_110_cse & chn_in_rsci_bawt ) begin
      reg_cfg_truncate_1_1_itm <= cfg_truncate_mux1h_1_itm[3:0];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      cvt_2_IntMulExt_33U_16U_49U_o_mul_1_itm_2 <= 49'b0;
      cvt_4_IntMulExt_33U_16U_49U_o_mul_1_itm_2 <= 49'b0;
    end
    else if ( IntMulExt_33U_16U_49U_o_and_1_cse ) begin
      cvt_2_IntMulExt_33U_16U_49U_o_mul_1_itm_2 <= conv_s2u_49_49($signed((cvt_2_IntSubExt_16U_32U_33U_o_acc_1_nl))
          * $signed((cfg_scale_rsci_d)));
      cvt_4_IntMulExt_33U_16U_49U_o_mul_1_itm_2 <= conv_s2u_49_49($signed((cvt_4_IntSubExt_16U_32U_33U_o_acc_1_nl))
          * $signed((cfg_scale_rsci_d)));
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      cfg_precision_1_sva_st_8 <= 2'b0;
      cfg_bypass_1_sva_st_10 <= 1'b0;
    end
    else if ( cfg_precision_and_cse ) begin
      cfg_precision_1_sva_st_8 <= cfg_precision_rsci_d;
      cfg_bypass_1_sva_st_10 <= cfg_bypass_rsci_d;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      cvt_1_if_cvt_1_if_and_9_itm_2 <= 1'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_1_lpi_1_dfm_5_9_0_1 <= 10'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_lpi_1_dfm_5_3_2_1 <= 2'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_lpi_1_dfm_5_1_0_1 <= 2'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_1_lpi_1_dfm_5_22_13_1 <= 10'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_1_lpi_1_dfm_5_12_10_1 <= 3'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_3_0_lpi_1_dfm_6 <= 4'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_lpi_1_dfm_5_22_13_1 <= 10'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_lpi_1_dfm_5_9_0_1 <= 10'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_lpi_1_dfm_5_12_10_1 <= 3'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_1_lpi_1_dfm_5_3_2_1 <= 2'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_1_lpi_1_dfm_5_1_0_1 <= 2'b0;
      cvt_1_if_cvt_1_if_and_itm_2 <= 1'b0;
      cvt_1_if_cvt_1_if_and_6_itm_2 <= 1'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_2_lpi_1_dfm_5_9_0_1 <= 10'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_3_lpi_1_dfm_5_3_2_1 <= 2'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_3_lpi_1_dfm_5_1_0_1 <= 2'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_2_lpi_1_dfm_5_22_13_1 <= 10'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_2_lpi_1_dfm_5_12_10_1 <= 3'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_3_0_3_lpi_1_dfm_6 <= 4'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_3_0_2_lpi_1_dfm_6 <= 4'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_3_lpi_1_dfm_5_22_13_1 <= 10'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_3_lpi_1_dfm_5_9_0_1 <= 10'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_3_lpi_1_dfm_5_12_10_1 <= 3'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_2_lpi_1_dfm_5_3_2_1 <= 2'b0;
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_2_lpi_1_dfm_5_1_0_1 <= 2'b0;
      cvt_1_if_cvt_1_if_and_3_itm_2 <= 1'b0;
    end
    else if ( cvt_1_if_and_cse ) begin
      cvt_1_if_cvt_1_if_and_9_itm_2 <= (chn_in_rsci_d_mxwt[63]) & (~ cvt_1_if_land_lpi_1_dfm);
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_1_lpi_1_dfm_5_9_0_1 <= MUX_v_10_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_27_nl),
          FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_9_0_1_lpi_1_dfm, or_dcpl);
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_lpi_1_dfm_5_3_2_1 <= (FpExpoWidthInc_5U_8U_23U_1U_1U_mux_58_nl)
          | ({{1{IsInf_5U_23U_land_lpi_1_dfm}}, IsInf_5U_23U_land_lpi_1_dfm}) | ({{1{IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_3_tmp}},
          IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_3_tmp});
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_lpi_1_dfm_5_1_0_1 <= (FpExpoWidthInc_5U_8U_23U_1U_1U_mux_42_nl)
          | ({{1{IsInf_5U_23U_land_lpi_1_dfm}}, IsInf_5U_23U_land_lpi_1_dfm}) | ({{1{IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_3_tmp}},
          IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_3_tmp});
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_1_lpi_1_dfm_5_22_13_1 <= MUX_v_10_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_29_nl),
          FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_1_lpi_1_dfm, or_dcpl);
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_1_lpi_1_dfm_5_12_10_1 <= ~(MUX_v_3_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_nor_nl),
          3'b111, IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_tmp));
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_3_0_lpi_1_dfm_6 <= MUX_v_4_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_mux1h_3_nl),
          4'b1111, IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_3_tmp);
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_lpi_1_dfm_5_22_13_1 <= MUX_v_10_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_30_nl),
          FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_lpi_1_dfm, or_dcpl_10);
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_lpi_1_dfm_5_9_0_1 <= MUX_v_10_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_31_nl),
          FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_9_0_lpi_1_dfm, or_dcpl_10);
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_lpi_1_dfm_5_12_10_1 <= ~(MUX_v_3_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_nor_3_nl),
          3'b111, IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_3_tmp));
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_1_lpi_1_dfm_5_3_2_1 <= (FpExpoWidthInc_5U_8U_23U_1U_1U_mux_46_nl)
          | ({{1{IsInf_5U_23U_land_1_lpi_1_dfm}}, IsInf_5U_23U_land_1_lpi_1_dfm})
          | ({{1{IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_tmp}}, IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_tmp});
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_1_lpi_1_dfm_5_1_0_1 <= (FpExpoWidthInc_5U_8U_23U_1U_1U_mux_36_nl)
          | ({{1{IsInf_5U_23U_land_1_lpi_1_dfm}}, IsInf_5U_23U_land_1_lpi_1_dfm})
          | ({{1{IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_tmp}}, IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_tmp});
      cvt_1_if_cvt_1_if_and_itm_2 <= (chn_in_rsci_d_mxwt[15]) & (~ cvt_1_if_land_1_lpi_1_dfm);
      cvt_1_if_cvt_1_if_and_6_itm_2 <= (chn_in_rsci_d_mxwt[47]) & (~ cvt_1_if_land_3_lpi_1_dfm);
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_2_lpi_1_dfm_5_9_0_1 <= MUX_v_10_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_32_nl),
          FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_9_0_2_lpi_1_dfm, or_dcpl_11);
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_3_lpi_1_dfm_5_3_2_1 <= (FpExpoWidthInc_5U_8U_23U_1U_1U_mux_54_nl)
          | ({{1{IsInf_5U_23U_land_3_lpi_1_dfm}}, IsInf_5U_23U_land_3_lpi_1_dfm})
          | ({{1{IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_2_tmp}}, IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_2_tmp});
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_3_lpi_1_dfm_5_1_0_1 <= (FpExpoWidthInc_5U_8U_23U_1U_1U_mux_40_nl)
          | ({{1{IsInf_5U_23U_land_3_lpi_1_dfm}}, IsInf_5U_23U_land_3_lpi_1_dfm})
          | ({{1{IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_2_tmp}}, IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_2_tmp});
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_2_lpi_1_dfm_5_22_13_1 <= MUX_v_10_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_33_nl),
          FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_2_lpi_1_dfm, or_dcpl_11);
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_2_lpi_1_dfm_5_12_10_1 <= ~(MUX_v_3_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_nor_1_nl),
          3'b111, IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_1_tmp));
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_3_0_3_lpi_1_dfm_6 <= MUX_v_4_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_mux1h_2_nl),
          4'b1111, IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_2_tmp);
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_3_0_2_lpi_1_dfm_6 <= MUX_v_4_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_mux1h_1_nl),
          4'b1111, IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_1_tmp);
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_3_lpi_1_dfm_5_22_13_1 <= MUX_v_10_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_34_nl),
          FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_22_13_3_lpi_1_dfm, or_dcpl_12);
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_3_lpi_1_dfm_5_9_0_1 <= MUX_v_10_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_35_nl),
          FpMantWidthInc_5U_10U_23U_1U_1U_o_mant_9_0_3_lpi_1_dfm, or_dcpl_12);
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_3_lpi_1_dfm_5_12_10_1 <= ~(MUX_v_3_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_nor_2_nl),
          3'b111, IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_2_tmp));
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_2_lpi_1_dfm_5_3_2_1 <= (FpExpoWidthInc_5U_8U_23U_1U_1U_mux_50_nl)
          | ({{1{IsInf_5U_23U_land_2_lpi_1_dfm}}, IsInf_5U_23U_land_2_lpi_1_dfm})
          | ({{1{IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_1_tmp}}, IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_1_tmp});
      FpExpoWidthInc_5U_8U_23U_1U_1U_o_expo_7_4_2_lpi_1_dfm_5_1_0_1 <= (FpExpoWidthInc_5U_8U_23U_1U_1U_mux_38_nl)
          | ({{1{IsInf_5U_23U_land_2_lpi_1_dfm}}, IsInf_5U_23U_land_2_lpi_1_dfm})
          | ({{1{IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_1_tmp}}, IsNaN_5U_23U_1_IsNaN_5U_23U_1_IsNaN_5U_23U_1_and_1_tmp});
      cvt_1_if_cvt_1_if_and_3_itm_2 <= (chn_in_rsci_d_mxwt[31]) & (~ cvt_1_if_land_2_lpi_1_dfm);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      data_in_data_sva_78 <= 64'b0;
    end
    else if ( core_wen & (~ and_dcpl_17) & (mux_28_nl) ) begin
      data_in_data_sva_78 <= chn_in_rsci_d_mxwt;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      cfg_bypass_1_sva_2 <= 1'b0;
      cfg_precision_1_sva_st_6 <= 2'b0;
    end
    else if ( cfg_bypass_and_4_cse ) begin
      cfg_bypass_1_sva_2 <= cfg_bypass_rsci_d;
      cfg_precision_1_sva_st_6 <= cfg_precision_rsci_d;
    end
  end
  assign cvt_1_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_1_nl
      = ~((~((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_1_sva[0]) | IntShiftRight_49U_6U_32U_obits_fixed_nor_ovfl_1_sva))
      | IntShiftRight_49U_6U_32U_obits_fixed_and_unfl_1_sva);
  assign cvt_1_else_mux_39_nl = MUX_s_1_2_2((cvt_1_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_1_nl),
      (data_in_data_sva_78[0]), cfg_bypass_1_sva_2);
  assign cvt_1_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_2_nl
      = ~((~((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_1_sva[31]) | IntShiftRight_49U_6U_32U_obits_fixed_and_unfl_1_sva))
      | IntShiftRight_49U_6U_32U_obits_fixed_nor_ovfl_1_sva);
  assign cvt_1_else_mux_40_nl = MUX_s_1_2_2((cvt_1_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_2_nl),
      (data_in_data_sva_78[15]), cfg_bypass_1_sva_2);
  assign cvt_2_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_4_nl
      = ~((~((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_2_sva[0]) | IntShiftRight_49U_6U_32U_obits_fixed_nor_ovfl_2_sva))
      | IntShiftRight_49U_6U_32U_obits_fixed_and_unfl_2_sva);
  assign cvt_1_else_mux_41_nl = MUX_s_1_2_2((cvt_2_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_4_nl),
      (data_in_data_sva_78[16]), cfg_bypass_1_sva_2);
  assign cvt_2_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_5_nl
      = ~((~((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_2_sva[31]) | IntShiftRight_49U_6U_32U_obits_fixed_and_unfl_2_sva))
      | IntShiftRight_49U_6U_32U_obits_fixed_nor_ovfl_2_sva);
  assign cvt_1_else_mux_42_nl = MUX_s_1_2_2((cvt_2_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_5_nl),
      (data_in_data_sva_78[31]), cfg_bypass_1_sva_2);
  assign cvt_3_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_1_nl
      = ~((~((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_3_sva[0]) | IntShiftRight_49U_6U_32U_obits_fixed_nor_ovfl_3_sva))
      | IntShiftRight_49U_6U_32U_obits_fixed_and_unfl_3_sva);
  assign cvt_1_else_mux_43_nl = MUX_s_1_2_2((cvt_3_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_1_nl),
      (data_in_data_sva_78[32]), cfg_bypass_1_sva_2);
  assign cvt_3_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_2_nl
      = ~((~((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_3_sva[31]) | IntShiftRight_49U_6U_32U_obits_fixed_and_unfl_3_sva))
      | IntShiftRight_49U_6U_32U_obits_fixed_nor_ovfl_3_sva);
  assign cvt_1_else_mux_44_nl = MUX_s_1_2_2((cvt_3_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_2_nl),
      (data_in_data_sva_78[47]), cfg_bypass_1_sva_2);
  assign cvt_4_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_4_nl
      = ~((~((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_sva[0]) | IntShiftRight_49U_6U_32U_obits_fixed_nor_ovfl_sva))
      | IntShiftRight_49U_6U_32U_obits_fixed_and_unfl_sva);
  assign cvt_1_else_mux_45_nl = MUX_s_1_2_2((cvt_4_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_4_nl),
      (data_in_data_sva_78[48]), cfg_bypass_1_sva_2);
  assign cvt_4_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_5_nl
      = ~((~((IntShiftRight_49U_6U_32U_obits_fixed_acc_sat_sva[31]) | IntShiftRight_49U_6U_32U_obits_fixed_and_unfl_sva))
      | IntShiftRight_49U_6U_32U_obits_fixed_nor_ovfl_sva);
  assign cvt_1_else_mux_46_nl = MUX_s_1_2_2((cvt_4_IntShiftRight_49U_6U_32U_obits_fixed_IntShiftRight_49U_6U_32U_obits_fixed_nor_5_nl),
      (data_in_data_sva_78[63]), cfg_bypass_1_sva_2);
  assign nl_cvt_1_IntSubExt_16U_32U_33U_o_acc_nl = conv_s2s_16_33(chn_in_rsci_d_mxwt[15:0])
      - conv_s2s_32_33(cfg_offset_rsci_d);
  assign cvt_1_IntSubExt_16U_32U_33U_o_acc_nl = nl_cvt_1_IntSubExt_16U_32U_33U_o_acc_nl[32:0];
  assign nl_cvt_3_IntSubExt_16U_32U_33U_o_acc_nl = conv_s2s_16_33(chn_in_rsci_d_mxwt[47:32])
      - conv_s2s_32_33(cfg_offset_rsci_d);
  assign cvt_3_IntSubExt_16U_32U_33U_o_acc_nl = nl_cvt_3_IntSubExt_16U_32U_33U_o_acc_nl[32:0];
  assign nl_cvt_2_IntSubExt_16U_32U_33U_o_acc_1_nl = conv_s2s_16_33(chn_in_rsci_d_mxwt[31:16])
      - conv_s2s_32_33(cfg_offset_rsci_d);
  assign cvt_2_IntSubExt_16U_32U_33U_o_acc_1_nl = nl_cvt_2_IntSubExt_16U_32U_33U_o_acc_1_nl[32:0];
  assign nl_cvt_4_IntSubExt_16U_32U_33U_o_acc_1_nl = conv_s2s_16_33(chn_in_rsci_d_mxwt[63:48])
      - conv_s2s_32_33(cfg_offset_rsci_d);
  assign cvt_4_IntSubExt_16U_32U_33U_o_acc_1_nl = nl_cvt_4_IntSubExt_16U_32U_33U_o_acc_1_nl[32:0];
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_27_nl =
      MUX_v_10_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_1_sva_2[9:0]), 10'b1111111111,
      IsInf_5U_23U_land_1_lpi_1_dfm);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_23_nl
      = MUX_v_2_2_2(2'b00, (z_out_3[3:2]), FpExpoWidthInc_5U_8U_23U_1U_1U_exs_71_0);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_mux_58_nl = MUX_v_2_2_2(2'b1, (FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_23_nl),
      FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_6_ssc);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_14_nl
      = MUX_v_2_2_2(2'b00, ({{1{FpExpoWidthInc_5U_8U_23U_1U_1U_exs_71_0}}, FpExpoWidthInc_5U_8U_23U_1U_1U_exs_71_0}),
      (z_out_3[0]));
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_mux_42_nl = MUX_v_2_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_sva[5:4]),
      (FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_14_nl),
      FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_6_ssc);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_29_nl =
      MUX_v_10_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_1_sva_2[22:13]), 10'b1111111111,
      IsInf_5U_23U_land_1_lpi_1_dfm);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_not_nl = ~ FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_ssc;
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_nl = MUX_v_3_2_2(3'b000,
      (FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_1_sva_2[12:10]), (FpExpoWidthInc_5U_8U_23U_1U_1U_not_nl));
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_nor_nl = ~(MUX_v_3_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_nl),
      3'b111, IsInf_5U_23U_land_1_lpi_1_dfm));
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_mux1h_3_nl
      = MUX1HOT_v_4_3_2((cvt_1_if_op_expo_lpi_1_dfm[3:0]), (FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_sva[3:0]),
      4'b1110, {FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_6_ssc
      , IsDenorm_5U_23U_land_lpi_1_dfm , IsInf_5U_23U_land_lpi_1_dfm});
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_30_nl =
      MUX_v_10_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_sva_2[22:13]), 10'b1111111111,
      IsInf_5U_23U_land_lpi_1_dfm);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_31_nl =
      MUX_v_10_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_sva_2[9:0]), 10'b1111111111,
      IsInf_5U_23U_land_lpi_1_dfm);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_not_3_nl = ~ FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_6_ssc;
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_22_nl
      = MUX_v_3_2_2(3'b000, (FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_sva_2[12:10]),
      (FpExpoWidthInc_5U_8U_23U_1U_1U_not_3_nl));
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_nor_3_nl = ~(MUX_v_3_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_22_nl),
      3'b111, IsInf_5U_23U_land_lpi_1_dfm));
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_17_nl
      = MUX_v_2_2_2(2'b00, (z_out[3:2]), FpExpoWidthInc_5U_8U_23U_1U_1U_exs_95_0);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_mux_46_nl = MUX_v_2_2_2(2'b1, (FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_17_nl),
      FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_ssc);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_2_nl =
      MUX_v_2_2_2(2'b00, ({{1{FpExpoWidthInc_5U_8U_23U_1U_1U_exs_95_0}}, FpExpoWidthInc_5U_8U_23U_1U_1U_exs_95_0}),
      (z_out[0]));
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_mux_36_nl = MUX_v_2_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_1_sva[5:4]),
      (FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_2_nl), FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_ssc);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_32_nl =
      MUX_v_10_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_2_sva_2[9:0]), 10'b1111111111,
      IsInf_5U_23U_land_2_lpi_1_dfm);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_21_nl
      = MUX_v_2_2_2(2'b00, (z_out_2[3:2]), FpExpoWidthInc_5U_8U_23U_1U_1U_exs_79_0);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_mux_54_nl = MUX_v_2_2_2(2'b1, (FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_21_nl),
      FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_4_ssc);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_10_nl
      = MUX_v_2_2_2(2'b00, ({{1{FpExpoWidthInc_5U_8U_23U_1U_1U_exs_79_0}}, FpExpoWidthInc_5U_8U_23U_1U_1U_exs_79_0}),
      (z_out_2[0]));
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_mux_40_nl = MUX_v_2_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_3_sva[5:4]),
      (FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_10_nl),
      FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_4_ssc);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_33_nl =
      MUX_v_10_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_2_sva_2[22:13]), 10'b1111111111,
      IsInf_5U_23U_land_2_lpi_1_dfm);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_not_1_nl = ~ FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_2_ssc;
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_18_nl
      = MUX_v_3_2_2(3'b000, (FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_2_sva_2[12:10]),
      (FpExpoWidthInc_5U_8U_23U_1U_1U_not_1_nl));
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_nor_1_nl = ~(MUX_v_3_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_18_nl),
      3'b111, IsInf_5U_23U_land_2_lpi_1_dfm));
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_mux1h_2_nl
      = MUX1HOT_v_4_3_2((cvt_1_if_op_expo_3_lpi_1_dfm[3:0]), (FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_3_sva[3:0]),
      4'b1110, {FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_4_ssc
      , IsDenorm_5U_23U_land_3_lpi_1_dfm , IsInf_5U_23U_land_3_lpi_1_dfm});
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_mux1h_1_nl
      = MUX1HOT_v_4_3_2((cvt_1_if_op_expo_2_lpi_1_dfm[3:0]), (FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_2_sva[3:0]),
      4'b1110, {FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_2_ssc
      , IsDenorm_5U_23U_land_2_lpi_1_dfm , IsInf_5U_23U_land_2_lpi_1_dfm});
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_34_nl =
      MUX_v_10_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_3_sva_2[22:13]), 10'b1111111111,
      IsInf_5U_23U_land_3_lpi_1_dfm);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_or_35_nl =
      MUX_v_10_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_3_sva_2[9:0]), 10'b1111111111,
      IsInf_5U_23U_land_3_lpi_1_dfm);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_not_2_nl = ~ FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_4_ssc;
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_20_nl
      = MUX_v_3_2_2(3'b000, (FpExpoWidthInc_5U_8U_23U_1U_1U_o_mant_3_sva_2[12:10]),
      (FpExpoWidthInc_5U_8U_23U_1U_1U_not_2_nl));
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_nor_2_nl = ~(MUX_v_3_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_20_nl),
      3'b111, IsInf_5U_23U_land_3_lpi_1_dfm));
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_19_nl
      = MUX_v_2_2_2(2'b00, (z_out_1[3:2]), FpExpoWidthInc_5U_8U_23U_1U_1U_exs_87_0);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_mux_50_nl = MUX_v_2_2_2(2'b1, (FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_19_nl),
      FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_2_ssc);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_6_nl =
      MUX_v_2_2_2(2'b00, ({{1{FpExpoWidthInc_5U_8U_23U_1U_1U_exs_87_0}}, FpExpoWidthInc_5U_8U_23U_1U_1U_exs_87_0}),
      (z_out_1[0]));
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_mux_38_nl = MUX_v_2_2_2((FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_acc_psp_2_sva[5:4]),
      (FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_and_6_nl), FpExpoWidthInc_5U_8U_23U_1U_1U_FpExpoWidthInc_5U_8U_23U_1U_1U_nor_2_ssc);
  assign mux_26_nl = MUX_s_1_2_2((~ or_tmp_5), mux_tmp_1, cfg_bypass_rsci_d);
  assign mux_27_nl = MUX_s_1_2_2(and_tmp_3, (mux_26_nl), or_66_cse);
  assign mux_28_nl = MUX_s_1_2_2(and_tmp_3, (mux_27_nl), cfg_bypass_1_sva_2);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_and_4_nl = (fsm_output[1]) & (chn_in_rsci_d_mxwt[14:10]==5'b00000);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_else_mux_4_nl = MUX_v_5_2_2(({4'b11 , (cvt_1_if_op_expo_1_lpi_1_dfm[4])}),
      libraries_leading_sign_23_0_aebf38bbf639c970da88b55f070b6a2d5444_4, FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_and_4_nl);
  assign nl_z_out = conv_u2u_5_6(FpExpoWidthInc_5U_8U_23U_1U_1U_else_mux_4_nl) +
      6'b1;
  assign z_out = nl_z_out[5:0];
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_and_5_nl = (fsm_output[1]) & (chn_in_rsci_d_mxwt[30:26]==5'b00000);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_else_mux_5_nl = MUX_v_5_2_2(({4'b11 , (cvt_1_if_op_expo_2_lpi_1_dfm[4])}),
      libraries_leading_sign_23_0_aebf38bbf639c970da88b55f070b6a2d5444_5, FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_and_5_nl);
  assign nl_z_out_1 = conv_u2u_5_6(FpExpoWidthInc_5U_8U_23U_1U_1U_else_mux_5_nl)
      + 6'b1;
  assign z_out_1 = nl_z_out_1[5:0];
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_and_6_nl = (fsm_output[1]) & (chn_in_rsci_d_mxwt[46:42]==5'b00000);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_else_mux_6_nl = MUX_v_5_2_2(({4'b11 , (cvt_1_if_op_expo_3_lpi_1_dfm[4])}),
      libraries_leading_sign_23_0_aebf38bbf639c970da88b55f070b6a2d5444_6, FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_and_6_nl);
  assign nl_z_out_2 = conv_u2u_5_6(FpExpoWidthInc_5U_8U_23U_1U_1U_else_mux_6_nl)
      + 6'b1;
  assign z_out_2 = nl_z_out_2[5:0];
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_and_7_nl = (fsm_output[1]) & (chn_in_rsci_d_mxwt[62:58]==5'b00000);
  assign FpExpoWidthInc_5U_8U_23U_1U_1U_else_mux_7_nl = MUX_v_5_2_2(({4'b11 , (cvt_1_if_op_expo_lpi_1_dfm[4])}),
      libraries_leading_sign_23_0_aebf38bbf639c970da88b55f070b6a2d5444_7, FpExpoWidthInc_5U_8U_23U_1U_1U_if_1_if_and_7_nl);
  assign nl_z_out_3 = conv_u2u_5_6(FpExpoWidthInc_5U_8U_23U_1U_1U_else_mux_7_nl)
      + 6'b1;
  assign z_out_3 = nl_z_out_3[5:0];

  function [0:0] MUX1HOT_s_1_1_2;
    input [0:0] input_0;
    input [0:0] sel;
    reg [0:0] result;
  begin
    result = input_0 & {1{sel[0]}};
    MUX1HOT_s_1_1_2 = result;
  end
  endfunction


  function [9:0] MUX1HOT_v_10_3_2;
    input [9:0] input_2;
    input [9:0] input_1;
    input [9:0] input_0;
    input [2:0] sel;
    reg [9:0] result;
  begin
    result = input_0 & {10{sel[0]}};
    result = result | ( input_1 & {10{sel[1]}});
    result = result | ( input_2 & {10{sel[2]}});
    MUX1HOT_v_10_3_2 = result;
  end
  endfunction


  function [1:0] MUX1HOT_v_2_3_2;
    input [1:0] input_2;
    input [1:0] input_1;
    input [1:0] input_0;
    input [2:0] sel;
    reg [1:0] result;
  begin
    result = input_0 & {2{sel[0]}};
    result = result | ( input_1 & {2{sel[1]}});
    result = result | ( input_2 & {2{sel[2]}});
    MUX1HOT_v_2_3_2 = result;
  end
  endfunction


  function [2:0] MUX1HOT_v_3_3_2;
    input [2:0] input_2;
    input [2:0] input_1;
    input [2:0] input_0;
    input [2:0] sel;
    reg [2:0] result;
  begin
    result = input_0 & {3{sel[0]}};
    result = result | ( input_1 & {3{sel[1]}});
    result = result | ( input_2 & {3{sel[2]}});
    MUX1HOT_v_3_3_2 = result;
  end
  endfunction


  function [3:0] MUX1HOT_v_4_3_2;
    input [3:0] input_2;
    input [3:0] input_1;
    input [3:0] input_0;
    input [2:0] sel;
    reg [3:0] result;
  begin
    result = input_0 & {4{sel[0]}};
    result = result | ( input_1 & {4{sel[1]}});
    result = result | ( input_2 & {4{sel[2]}});
    MUX1HOT_v_4_3_2 = result;
  end
  endfunction


  function [8:0] MUX1HOT_v_9_3_2;
    input [8:0] input_2;
    input [8:0] input_1;
    input [8:0] input_0;
    input [2:0] sel;
    reg [8:0] result;
  begin
    result = input_0 & {9{sel[0]}};
    result = result | ( input_1 & {9{sel[1]}});
    result = result | ( input_2 & {9{sel[2]}});
    MUX1HOT_v_9_3_2 = result;
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


  function [9:0] MUX_v_10_2_2;
    input [9:0] input_0;
    input [9:0] input_1;
    input [0:0] sel;
    reg [9:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_10_2_2 = result;
  end
  endfunction


  function [1:0] MUX_v_2_2_2;
    input [1:0] input_0;
    input [1:0] input_1;
    input [0:0] sel;
    reg [1:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_2_2_2 = result;
  end
  endfunction


  function [29:0] MUX_v_30_2_2;
    input [29:0] input_0;
    input [29:0] input_1;
    input [0:0] sel;
    reg [29:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_30_2_2 = result;
  end
  endfunction


  function [2:0] MUX_v_3_2_2;
    input [2:0] input_0;
    input [2:0] input_1;
    input [0:0] sel;
    reg [2:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_3_2_2 = result;
  end
  endfunction


  function [3:0] MUX_v_4_2_2;
    input [3:0] input_0;
    input [3:0] input_1;
    input [0:0] sel;
    reg [3:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_4_2_2 = result;
  end
  endfunction


  function [4:0] MUX_v_5_2_2;
    input [4:0] input_0;
    input [4:0] input_1;
    input [0:0] sel;
    reg [4:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_5_2_2 = result;
  end
  endfunction


  function [5:0] MUX_v_6_2_2;
    input [5:0] input_0;
    input [5:0] input_1;
    input [0:0] sel;
    reg [5:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_6_2_2 = result;
  end
  endfunction


  function [9:0] signext_10_3;
    input [2:0] vector;
  begin
    signext_10_3= {{7{vector[2]}}, vector};
  end
  endfunction


  function [1:0] signext_2_1;
    input [0:0] vector;
  begin
    signext_2_1= {{1{vector[0]}}, vector};
  end
  endfunction


  function [3:0] signext_4_1;
    input [0:0] vector;
  begin
    signext_4_1= {{3{vector[0]}}, vector};
  end
  endfunction


  function  [32:0] conv_s2s_16_33 ;
    input [15:0]  vector ;
  begin
    conv_s2s_16_33 = {{17{vector[15]}}, vector};
  end
  endfunction


  function  [32:0] conv_s2s_32_33 ;
    input [31:0]  vector ;
  begin
    conv_s2s_32_33 = {vector[31], vector};
  end
  endfunction


  function  [49:0] conv_s2s_49_50 ;
    input [48:0]  vector ;
  begin
    conv_s2s_49_50 = {vector[48], vector};
  end
  endfunction


  function  [48:0] conv_s2u_49_49 ;
    input [48:0]  vector ;
  begin
    conv_s2u_49_49 = vector;
  end
  endfunction


  function  [49:0] conv_u2s_1_50 ;
    input [0:0]  vector ;
  begin
    conv_u2s_1_50 = {{49{1'b0}}, vector};
  end
  endfunction


  function  [5:0] conv_u2u_5_6 ;
    input [4:0]  vector ;
  begin
    conv_u2u_5_6 = {1'b0, vector};
  end
  endfunction

endmodule

// ------------------------------------------------------------------
//  Design Unit:    NV_NVDLA_SDP_CORE_Y_cvt
// ------------------------------------------------------------------


module NV_NVDLA_SDP_CORE_Y_cvt (
  nvdla_core_clk, nvdla_core_rstn, chn_in_rsc_z, chn_in_rsc_vz, chn_in_rsc_lz, cfg_bypass_rsc_z,
      cfg_offset_rsc_z, cfg_scale_rsc_z, cfg_truncate_rsc_z, cfg_nan_to_zero_rsc_z,
      cfg_precision_rsc_z, chn_out_rsc_z, chn_out_rsc_vz, chn_out_rsc_lz
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [63:0] chn_in_rsc_z;
  input chn_in_rsc_vz;
  output chn_in_rsc_lz;
  input cfg_bypass_rsc_z;
  input [31:0] cfg_offset_rsc_z;
  input [15:0] cfg_scale_rsc_z;
  input [5:0] cfg_truncate_rsc_z;
  input cfg_nan_to_zero_rsc_z;
  input [1:0] cfg_precision_rsc_z;
  output [127:0] chn_out_rsc_z;
  input chn_out_rsc_vz;
  output chn_out_rsc_lz;


  // Interconnect Declarations
  wire chn_in_rsci_oswt;
  wire chn_in_rsci_oswt_unreg;
  wire chn_out_rsci_oswt;
  wire chn_out_rsci_oswt_unreg;


  // Interconnect Declarations for Component Instantiations 
  SDP_Y_CVT_chn_in_rsci_unreg chn_in_rsci_unreg_inst (
      .in_0(chn_in_rsci_oswt_unreg),
      .outsig(chn_in_rsci_oswt)
    );
  SDP_Y_CVT_chn_out_rsci_unreg chn_out_rsci_unreg_inst (
      .in_0(chn_out_rsci_oswt_unreg),
      .outsig(chn_out_rsci_oswt)
    );
  NV_NVDLA_SDP_CORE_Y_cvt_core NV_NVDLA_SDP_CORE_Y_cvt_core_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_in_rsc_z(chn_in_rsc_z),
      .chn_in_rsc_vz(chn_in_rsc_vz),
      .chn_in_rsc_lz(chn_in_rsc_lz),
      .cfg_bypass_rsc_z(cfg_bypass_rsc_z),
      .cfg_offset_rsc_z(cfg_offset_rsc_z),
      .cfg_scale_rsc_z(cfg_scale_rsc_z),
      .cfg_truncate_rsc_z(cfg_truncate_rsc_z),
      .cfg_nan_to_zero_rsc_z(cfg_nan_to_zero_rsc_z),
      .cfg_precision_rsc_z(cfg_precision_rsc_z),
      .chn_out_rsc_z(chn_out_rsc_z),
      .chn_out_rsc_vz(chn_out_rsc_vz),
      .chn_out_rsc_lz(chn_out_rsc_lz),
      .chn_in_rsci_oswt(chn_in_rsci_oswt),
      .chn_in_rsci_oswt_unreg(chn_in_rsci_oswt_unreg),
      .chn_out_rsci_oswt(chn_out_rsci_oswt),
      .chn_out_rsci_oswt_unreg(chn_out_rsci_oswt_unreg)
    );
endmodule



