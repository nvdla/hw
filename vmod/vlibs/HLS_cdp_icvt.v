// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: HLS_cdp_icvt.v

module CDP_ICVT_mgc_in_wire_wait_v1 (ld, vd, d, lz, vz, z);

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


//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/siflibs/CDP_ICVT_mgc_out_stdreg_wait_v1.v 
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


module CDP_ICVT_mgc_out_stdreg_wait_v1 (ld, vd, d, lz, vz, z);

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



//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/siflibs/CDP_ICVT_mgc_in_wire_v1.v 
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


module CDP_ICVT_mgc_in_wire_v1 (d, z);

  parameter integer rscid = 1;
  parameter integer width = 8;

  output [width-1:0] d;
  input  [width-1:0] z;

  wire   [width-1:0] d;

  assign d = z;

endmodule


//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/siflibs/mgc_shift_l_beh_v4.v 
module CDP_ICVT_mgc_shift_l_v4(a,s,z);
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

//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/siflibs/mgc_shift_r_beh_v4.v 
module CDP_ICVT_mgc_shift_r_v4(a,s,z);
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

//------> ../td_ccore_solutions/leading_sign_10_0_8b78af2050cf8551b0aa4ca6a9790ede3d5a_0/rtl.v 
// ----------------------------------------------------------------------
//  HLS HDL:        Verilog Netlister
//  HLS Version:    10.0/264918 Production Release
//  HLS Date:       Mon Aug  8 13:35:54 PDT 2016
// 
//  Generated by:   ezhang@hk-sim-10-062
//  Generated date: Thu Dec 29 17:10:30 2016
// ----------------------------------------------------------------------

// 
// ------------------------------------------------------------------
//  Design Unit:    CDP_ICVT_leading_sign_10_0
// ------------------------------------------------------------------


module CDP_ICVT_leading_sign_10_0 (
  mantissa, rtn
);
  input [9:0] mantissa;
  output [3:0] rtn;


  // Interconnect Declarations
  wire IntLeadZero_10U_leading_sign_10_0_rtn_wrs_c_6_2_sdt_2;
  wire IntLeadZero_10U_leading_sign_10_0_rtn_wrs_c_18_3_sdt_3;
  wire IntLeadZero_10U_leading_sign_10_0_rtn_wrs_c_6_2_sdt_1;
  wire IntLeadZero_10U_leading_sign_10_0_rtn_wrs_c_14_2_sdt_1;
  wire c_h_1_2;
  wire c_h_1_3;
  wire IntLeadZero_10U_leading_sign_10_0_rtn_and_35_ssc;

  wire[0:0] IntLeadZero_10U_leading_sign_10_0_rtn_and_31_nl;
  wire[0:0] IntLeadZero_10U_leading_sign_10_0_rtn_IntLeadZero_10U_leading_sign_10_0_rtn_or_nl;
  wire[0:0] IntLeadZero_10U_leading_sign_10_0_rtn_IntLeadZero_10U_leading_sign_10_0_rtn_nor_6_nl;

  // Interconnect Declarations for Component Instantiations 
  assign IntLeadZero_10U_leading_sign_10_0_rtn_wrs_c_6_2_sdt_2 = ~((mantissa[7:6]!=2'b00));
  assign IntLeadZero_10U_leading_sign_10_0_rtn_wrs_c_6_2_sdt_1 = ~((mantissa[9:8]!=2'b00));
  assign IntLeadZero_10U_leading_sign_10_0_rtn_wrs_c_14_2_sdt_1 = ~((mantissa[5:4]!=2'b00));
  assign c_h_1_2 = IntLeadZero_10U_leading_sign_10_0_rtn_wrs_c_6_2_sdt_1 & IntLeadZero_10U_leading_sign_10_0_rtn_wrs_c_6_2_sdt_2;
  assign IntLeadZero_10U_leading_sign_10_0_rtn_wrs_c_18_3_sdt_3 = (mantissa[3:2]==2'b00)
      & IntLeadZero_10U_leading_sign_10_0_rtn_wrs_c_14_2_sdt_1;
  assign c_h_1_3 = c_h_1_2 & IntLeadZero_10U_leading_sign_10_0_rtn_wrs_c_18_3_sdt_3;
  assign IntLeadZero_10U_leading_sign_10_0_rtn_and_35_ssc = (mantissa[1:0]==2'b00)
      & c_h_1_3;
  assign IntLeadZero_10U_leading_sign_10_0_rtn_and_31_nl = c_h_1_2 & (~ IntLeadZero_10U_leading_sign_10_0_rtn_wrs_c_18_3_sdt_3);
  assign IntLeadZero_10U_leading_sign_10_0_rtn_IntLeadZero_10U_leading_sign_10_0_rtn_or_nl
      = (IntLeadZero_10U_leading_sign_10_0_rtn_wrs_c_6_2_sdt_1 & (IntLeadZero_10U_leading_sign_10_0_rtn_wrs_c_14_2_sdt_1
      | (~ IntLeadZero_10U_leading_sign_10_0_rtn_wrs_c_6_2_sdt_2)) & (~ c_h_1_3))
      | IntLeadZero_10U_leading_sign_10_0_rtn_and_35_ssc;
  assign IntLeadZero_10U_leading_sign_10_0_rtn_IntLeadZero_10U_leading_sign_10_0_rtn_nor_6_nl
      = ~((mantissa[9]) | (~((mantissa[8:7]!=2'b01))) | (((mantissa[5]) | (~((mantissa[4:3]!=2'b01))))
      & c_h_1_2) | ((mantissa[1]) & c_h_1_3) | IntLeadZero_10U_leading_sign_10_0_rtn_and_35_ssc);
  assign rtn = {c_h_1_3 , (IntLeadZero_10U_leading_sign_10_0_rtn_and_31_nl) , (IntLeadZero_10U_leading_sign_10_0_rtn_IntLeadZero_10U_leading_sign_10_0_rtn_or_nl)
      , (IntLeadZero_10U_leading_sign_10_0_rtn_IntLeadZero_10U_leading_sign_10_0_rtn_nor_6_nl)};
endmodule




//------> ./rtl.v 
// ----------------------------------------------------------------------
//  HLS HDL:        Verilog Netlister
//  HLS Version:    10.0/264918 Production Release
//  HLS Date:       Mon Aug  8 13:35:54 PDT 2016
// 
//  Generated by:   ezhang@hk-sim-11-132
//  Generated date: Sat Jun 17 08:05:16 2017
// ----------------------------------------------------------------------

// 
// ------------------------------------------------------------------
//  Design Unit:    CDP_ICVT_chn_data_out_rsci_unreg
// ------------------------------------------------------------------


module CDP_ICVT_chn_data_out_rsci_unreg (
  in_0, outsig
);
  input in_0;
  output outsig;



  // Interconnect Declarations for Component Instantiations 
  assign outsig = in_0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    CDP_ICVT_chn_data_in_rsci_unreg
// ------------------------------------------------------------------


module CDP_ICVT_chn_data_in_rsci_unreg (
  in_0, outsig
);
  input in_0;
  output outsig;



  // Interconnect Declarations for Component Instantiations 
  assign outsig = in_0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_cdp_icvt_core_core_fsm
//  FSM Module
// ------------------------------------------------------------------


module HLS_cdp_icvt_core_core_fsm (
  nvdla_core_clk, nvdla_core_rstn, core_wen, fsm_output
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input core_wen;
  output [1:0] fsm_output;
  reg [1:0] fsm_output;


  // FSM State Type Declaration for HLS_cdp_icvt_core_core_fsm_1
  parameter
    core_rlp_C_0 = 1'd0,
    main_C_0 = 1'd1;

  reg [0:0] state_var;
  reg [0:0] state_var_NS;


  // Interconnect Declarations for Component Instantiations 
  always @(*)
  begin : HLS_cdp_icvt_core_core_fsm_1
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
//  Design Unit:    HLS_cdp_icvt_core_staller
// ------------------------------------------------------------------


module HLS_cdp_icvt_core_staller (
  nvdla_core_clk, nvdla_core_rstn, core_wen, chn_data_in_rsci_wen_comp, core_wten,
      chn_data_out_rsci_wen_comp
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  output core_wen;
  input chn_data_in_rsci_wen_comp;
  output core_wten;
  reg core_wten;
  input chn_data_out_rsci_wen_comp;



  // Interconnect Declarations for Component Instantiations 
  assign core_wen = chn_data_in_rsci_wen_comp & chn_data_out_rsci_wen_comp;
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
//  Design Unit:    HLS_cdp_icvt_core_chn_data_out_rsci_chn_data_out_wait_dp
// ------------------------------------------------------------------


module HLS_cdp_icvt_core_chn_data_out_rsci_chn_data_out_wait_dp (
  nvdla_core_clk, nvdla_core_rstn, chn_data_out_rsci_oswt, chn_data_out_rsci_bawt,
      chn_data_out_rsci_wen_comp, chn_data_out_rsci_biwt, chn_data_out_rsci_bdwt
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input chn_data_out_rsci_oswt;
  output chn_data_out_rsci_bawt;
  output chn_data_out_rsci_wen_comp;
  input chn_data_out_rsci_biwt;
  input chn_data_out_rsci_bdwt;


  // Interconnect Declarations
  reg chn_data_out_rsci_bcwt;


  // Interconnect Declarations for Component Instantiations 
  assign chn_data_out_rsci_bawt = chn_data_out_rsci_biwt | chn_data_out_rsci_bcwt;
  assign chn_data_out_rsci_wen_comp = (~ chn_data_out_rsci_oswt) | chn_data_out_rsci_bawt;
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_data_out_rsci_bcwt <= 1'b0;
    end
    else begin
      chn_data_out_rsci_bcwt <= ~((~(chn_data_out_rsci_bcwt | chn_data_out_rsci_biwt))
          | chn_data_out_rsci_bdwt);
    end
  end
endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_cdp_icvt_core_chn_data_out_rsci_chn_data_out_wait_ctrl
// ------------------------------------------------------------------


module HLS_cdp_icvt_core_chn_data_out_rsci_chn_data_out_wait_ctrl (
  nvdla_core_clk, nvdla_core_rstn, chn_data_out_rsci_oswt, core_wen, core_wten, chn_data_out_rsci_iswt0,
      chn_data_out_rsci_ld_core_psct, chn_data_out_rsci_biwt, chn_data_out_rsci_bdwt,
      chn_data_out_rsci_ld_core_sct, chn_data_out_rsci_vd
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input chn_data_out_rsci_oswt;
  input core_wen;
  input core_wten;
  input chn_data_out_rsci_iswt0;
  input chn_data_out_rsci_ld_core_psct;
  output chn_data_out_rsci_biwt;
  output chn_data_out_rsci_bdwt;
  output chn_data_out_rsci_ld_core_sct;
  input chn_data_out_rsci_vd;


  // Interconnect Declarations
  wire chn_data_out_rsci_ogwt;
  wire chn_data_out_rsci_pdswt0;
  reg chn_data_out_rsci_icwt;


  // Interconnect Declarations for Component Instantiations 
  assign chn_data_out_rsci_pdswt0 = (~ core_wten) & chn_data_out_rsci_iswt0;
  assign chn_data_out_rsci_biwt = chn_data_out_rsci_ogwt & chn_data_out_rsci_vd;
  assign chn_data_out_rsci_ogwt = chn_data_out_rsci_pdswt0 | chn_data_out_rsci_icwt;
  assign chn_data_out_rsci_bdwt = chn_data_out_rsci_oswt & core_wen;
  assign chn_data_out_rsci_ld_core_sct = chn_data_out_rsci_ld_core_psct & chn_data_out_rsci_ogwt;
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_data_out_rsci_icwt <= 1'b0;
    end
    else begin
      chn_data_out_rsci_icwt <= ~((~(chn_data_out_rsci_icwt | chn_data_out_rsci_pdswt0))
          | chn_data_out_rsci_biwt);
    end
  end
endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_cdp_icvt_core_chn_data_in_rsci_chn_data_in_wait_dp
// ------------------------------------------------------------------


module HLS_cdp_icvt_core_chn_data_in_rsci_chn_data_in_wait_dp (
  nvdla_core_clk, nvdla_core_rstn, chn_data_in_rsci_oswt, chn_data_in_rsci_bawt,
      chn_data_in_rsci_wen_comp, chn_data_in_rsci_d_mxwt, chn_data_in_rsci_biwt,
      chn_data_in_rsci_bdwt, chn_data_in_rsci_d
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input chn_data_in_rsci_oswt;
  output chn_data_in_rsci_bawt;
  output chn_data_in_rsci_wen_comp;
  output [15:0] chn_data_in_rsci_d_mxwt;
  input chn_data_in_rsci_biwt;
  input chn_data_in_rsci_bdwt;
  input [15:0] chn_data_in_rsci_d;


  // Interconnect Declarations
  reg chn_data_in_rsci_bcwt;
  reg [15:0] chn_data_in_rsci_d_bfwt;


  // Interconnect Declarations for Component Instantiations 
  assign chn_data_in_rsci_bawt = chn_data_in_rsci_biwt | chn_data_in_rsci_bcwt;
  assign chn_data_in_rsci_wen_comp = (~ chn_data_in_rsci_oswt) | chn_data_in_rsci_bawt;
  assign chn_data_in_rsci_d_mxwt = MUX_v_16_2_2(chn_data_in_rsci_d, chn_data_in_rsci_d_bfwt,
      chn_data_in_rsci_bcwt);
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_data_in_rsci_bcwt <= 1'b0;
      chn_data_in_rsci_d_bfwt <= 16'b0;
    end
    else begin
      chn_data_in_rsci_bcwt <= ~((~(chn_data_in_rsci_bcwt | chn_data_in_rsci_biwt))
          | chn_data_in_rsci_bdwt);
      chn_data_in_rsci_d_bfwt <= chn_data_in_rsci_d_mxwt;
    end
  end

  function [15:0] MUX_v_16_2_2;
    input [15:0] input_0;
    input [15:0] input_1;
    input [0:0] sel;
    reg [15:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_16_2_2 = result;
  end
  endfunction

endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_cdp_icvt_core_chn_data_in_rsci_chn_data_in_wait_ctrl
// ------------------------------------------------------------------


module HLS_cdp_icvt_core_chn_data_in_rsci_chn_data_in_wait_ctrl (
  nvdla_core_clk, nvdla_core_rstn, chn_data_in_rsci_oswt, core_wen, chn_data_in_rsci_iswt0,
      chn_data_in_rsci_ld_core_psct, core_wten, chn_data_in_rsci_biwt, chn_data_in_rsci_bdwt,
      chn_data_in_rsci_ld_core_sct, chn_data_in_rsci_vd
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input chn_data_in_rsci_oswt;
  input core_wen;
  input chn_data_in_rsci_iswt0;
  input chn_data_in_rsci_ld_core_psct;
  input core_wten;
  output chn_data_in_rsci_biwt;
  output chn_data_in_rsci_bdwt;
  output chn_data_in_rsci_ld_core_sct;
  input chn_data_in_rsci_vd;


  // Interconnect Declarations
  wire chn_data_in_rsci_ogwt;
  wire chn_data_in_rsci_pdswt0;
  reg chn_data_in_rsci_icwt;


  // Interconnect Declarations for Component Instantiations 
  assign chn_data_in_rsci_pdswt0 = (~ core_wten) & chn_data_in_rsci_iswt0;
  assign chn_data_in_rsci_biwt = chn_data_in_rsci_ogwt & chn_data_in_rsci_vd;
  assign chn_data_in_rsci_ogwt = chn_data_in_rsci_pdswt0 | chn_data_in_rsci_icwt;
  assign chn_data_in_rsci_bdwt = chn_data_in_rsci_oswt & core_wen;
  assign chn_data_in_rsci_ld_core_sct = chn_data_in_rsci_ld_core_psct & chn_data_in_rsci_ogwt;
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_data_in_rsci_icwt <= 1'b0;
    end
    else begin
      chn_data_in_rsci_icwt <= ~((~(chn_data_in_rsci_icwt | chn_data_in_rsci_pdswt0))
          | chn_data_in_rsci_biwt);
    end
  end
endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_cdp_icvt_core_chn_data_out_rsci
// ------------------------------------------------------------------


module HLS_cdp_icvt_core_chn_data_out_rsci (
  nvdla_core_clk, nvdla_core_rstn, chn_data_out_rsc_z, chn_data_out_rsc_vz, chn_data_out_rsc_lz,
      chn_data_out_rsci_oswt, core_wen, core_wten, chn_data_out_rsci_iswt0, chn_data_out_rsci_bawt,
      chn_data_out_rsci_wen_comp, chn_data_out_rsci_ld_core_psct, chn_data_out_rsci_d
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  output [17:0] chn_data_out_rsc_z;
  input chn_data_out_rsc_vz;
  output chn_data_out_rsc_lz;
  input chn_data_out_rsci_oswt;
  input core_wen;
  input core_wten;
  input chn_data_out_rsci_iswt0;
  output chn_data_out_rsci_bawt;
  output chn_data_out_rsci_wen_comp;
  input chn_data_out_rsci_ld_core_psct;
  input [17:0] chn_data_out_rsci_d;


  // Interconnect Declarations
  wire chn_data_out_rsci_biwt;
  wire chn_data_out_rsci_bdwt;
  wire chn_data_out_rsci_ld_core_sct;
  wire chn_data_out_rsci_vd;


  // Interconnect Declarations for Component Instantiations 
  CDP_ICVT_mgc_out_stdreg_wait_v1 #(.rscid(32'sd6),
  .width(32'sd18)) chn_data_out_rsci (
      .ld(chn_data_out_rsci_ld_core_sct),
      .vd(chn_data_out_rsci_vd),
      .d(chn_data_out_rsci_d),
      .lz(chn_data_out_rsc_lz),
      .vz(chn_data_out_rsc_vz),
      .z(chn_data_out_rsc_z)
    );
  HLS_cdp_icvt_core_chn_data_out_rsci_chn_data_out_wait_ctrl HLS_cdp_icvt_core_chn_data_out_rsci_chn_data_out_wait_ctrl_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_data_out_rsci_oswt(chn_data_out_rsci_oswt),
      .core_wen(core_wen),
      .core_wten(core_wten),
      .chn_data_out_rsci_iswt0(chn_data_out_rsci_iswt0),
      .chn_data_out_rsci_ld_core_psct(chn_data_out_rsci_ld_core_psct),
      .chn_data_out_rsci_biwt(chn_data_out_rsci_biwt),
      .chn_data_out_rsci_bdwt(chn_data_out_rsci_bdwt),
      .chn_data_out_rsci_ld_core_sct(chn_data_out_rsci_ld_core_sct),
      .chn_data_out_rsci_vd(chn_data_out_rsci_vd)
    );
  HLS_cdp_icvt_core_chn_data_out_rsci_chn_data_out_wait_dp HLS_cdp_icvt_core_chn_data_out_rsci_chn_data_out_wait_dp_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_data_out_rsci_oswt(chn_data_out_rsci_oswt),
      .chn_data_out_rsci_bawt(chn_data_out_rsci_bawt),
      .chn_data_out_rsci_wen_comp(chn_data_out_rsci_wen_comp),
      .chn_data_out_rsci_biwt(chn_data_out_rsci_biwt),
      .chn_data_out_rsci_bdwt(chn_data_out_rsci_bdwt)
    );
endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_cdp_icvt_core_chn_data_in_rsci
// ------------------------------------------------------------------


module HLS_cdp_icvt_core_chn_data_in_rsci (
  nvdla_core_clk, nvdla_core_rstn, chn_data_in_rsc_z, chn_data_in_rsc_vz, chn_data_in_rsc_lz,
      chn_data_in_rsci_oswt, core_wen, chn_data_in_rsci_iswt0, chn_data_in_rsci_bawt,
      chn_data_in_rsci_wen_comp, chn_data_in_rsci_ld_core_psct, chn_data_in_rsci_d_mxwt,
      core_wten
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [15:0] chn_data_in_rsc_z;
  input chn_data_in_rsc_vz;
  output chn_data_in_rsc_lz;
  input chn_data_in_rsci_oswt;
  input core_wen;
  input chn_data_in_rsci_iswt0;
  output chn_data_in_rsci_bawt;
  output chn_data_in_rsci_wen_comp;
  input chn_data_in_rsci_ld_core_psct;
  output [15:0] chn_data_in_rsci_d_mxwt;
  input core_wten;


  // Interconnect Declarations
  wire chn_data_in_rsci_biwt;
  wire chn_data_in_rsci_bdwt;
  wire chn_data_in_rsci_ld_core_sct;
  wire chn_data_in_rsci_vd;
  wire [15:0] chn_data_in_rsci_d;


  // Interconnect Declarations for Component Instantiations 
  CDP_ICVT_mgc_in_wire_wait_v1 #(.rscid(32'sd1),
  .width(32'sd16)) chn_data_in_rsci (
      .ld(chn_data_in_rsci_ld_core_sct),
      .vd(chn_data_in_rsci_vd),
      .d(chn_data_in_rsci_d),
      .lz(chn_data_in_rsc_lz),
      .vz(chn_data_in_rsc_vz),
      .z(chn_data_in_rsc_z)
    );
  HLS_cdp_icvt_core_chn_data_in_rsci_chn_data_in_wait_ctrl HLS_cdp_icvt_core_chn_data_in_rsci_chn_data_in_wait_ctrl_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_data_in_rsci_oswt(chn_data_in_rsci_oswt),
      .core_wen(core_wen),
      .chn_data_in_rsci_iswt0(chn_data_in_rsci_iswt0),
      .chn_data_in_rsci_ld_core_psct(chn_data_in_rsci_ld_core_psct),
      .core_wten(core_wten),
      .chn_data_in_rsci_biwt(chn_data_in_rsci_biwt),
      .chn_data_in_rsci_bdwt(chn_data_in_rsci_bdwt),
      .chn_data_in_rsci_ld_core_sct(chn_data_in_rsci_ld_core_sct),
      .chn_data_in_rsci_vd(chn_data_in_rsci_vd)
    );
  HLS_cdp_icvt_core_chn_data_in_rsci_chn_data_in_wait_dp HLS_cdp_icvt_core_chn_data_in_rsci_chn_data_in_wait_dp_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_data_in_rsci_oswt(chn_data_in_rsci_oswt),
      .chn_data_in_rsci_bawt(chn_data_in_rsci_bawt),
      .chn_data_in_rsci_wen_comp(chn_data_in_rsci_wen_comp),
      .chn_data_in_rsci_d_mxwt(chn_data_in_rsci_d_mxwt),
      .chn_data_in_rsci_biwt(chn_data_in_rsci_biwt),
      .chn_data_in_rsci_bdwt(chn_data_in_rsci_bdwt),
      .chn_data_in_rsci_d(chn_data_in_rsci_d)
    );
endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_cdp_icvt_core
// ------------------------------------------------------------------


module HLS_cdp_icvt_core (
  nvdla_core_clk, nvdla_core_rstn, chn_data_in_rsc_z, chn_data_in_rsc_vz, chn_data_in_rsc_lz,
      cfg_alu_in_rsc_z, cfg_mul_in_rsc_z, cfg_truncate_rsc_z, cfg_precision_rsc_z,
      chn_data_out_rsc_z, chn_data_out_rsc_vz, chn_data_out_rsc_lz, chn_data_in_rsci_oswt,
      chn_data_in_rsci_oswt_unreg, chn_data_out_rsci_oswt, chn_data_out_rsci_oswt_unreg
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [15:0] chn_data_in_rsc_z;
  input chn_data_in_rsc_vz;
  output chn_data_in_rsc_lz;
  input [15:0] cfg_alu_in_rsc_z;
  input [15:0] cfg_mul_in_rsc_z;
  input [4:0] cfg_truncate_rsc_z;
  input [1:0] cfg_precision_rsc_z;
  output [17:0] chn_data_out_rsc_z;
  input chn_data_out_rsc_vz;
  output chn_data_out_rsc_lz;
  input chn_data_in_rsci_oswt;
  output chn_data_in_rsci_oswt_unreg;
  input chn_data_out_rsci_oswt;
  output chn_data_out_rsci_oswt_unreg;


  // Interconnect Declarations
  wire core_wen;
  reg chn_data_in_rsci_iswt0;
  wire chn_data_in_rsci_bawt;
  wire chn_data_in_rsci_wen_comp;
  reg chn_data_in_rsci_ld_core_psct;
  wire [15:0] chn_data_in_rsci_d_mxwt;
  wire core_wten;
  wire [15:0] cfg_alu_in_rsci_d;
  wire [15:0] cfg_mul_in_rsci_d;
  wire [4:0] cfg_truncate_rsci_d;
  wire [1:0] cfg_precision_rsci_d;
  reg chn_data_out_rsci_iswt0;
  wire chn_data_out_rsci_bawt;
  wire chn_data_out_rsci_wen_comp;
  reg chn_data_out_rsci_d_17;
  reg chn_data_out_rsci_d_16;
  reg [3:0] chn_data_out_rsci_d_13_10;
  reg chn_data_out_rsci_d_9;
  reg chn_data_out_rsci_d_8;
  reg [6:0] chn_data_out_rsci_d_7_1;
  reg chn_data_out_rsci_d_0;
  reg chn_data_out_rsci_d_15;
  reg chn_data_out_rsci_d_14;
  wire [1:0] fsm_output;
  wire IsDenorm_5U_10U_or_tmp;
  wire and_dcpl;
  wire and_dcpl_3;
  wire and_dcpl_4;
  wire and_dcpl_6;
  wire and_dcpl_9;
  wire or_tmp_15;
  wire and_tmp_4;
  wire or_tmp_35;
  wire not_tmp_22;
  wire and_dcpl_16;
  wire and_dcpl_18;
  wire and_dcpl_19;
  wire or_tmp_80;
  reg main_stage_v_1;
  reg main_stage_v_2;
  reg [15:0] cfg_mul_in_1_sva_2;
  reg nor_tmp_11;
  reg [8:0] IntSubExt_8U_8U_9U_o_acc_itm_2;
  reg [23:0] IntMulExt_9U_16U_25U_o_mul_itm_2;
  reg i_data_slc_i_data_15_1_itm_3;
  reg i_data_slc_i_data_15_1_itm_4;
  reg [1:0] io_read_cfg_precision_rsc_svs_st_3;
  reg [1:0] io_read_cfg_precision_rsc_svs_st_4;
  reg FpExpoWidthInc_5U_6U_10U_1U_1U_o_expo_5_4_lpi_1_dfm_5_1_1;
  reg FpExpoWidthInc_5U_6U_10U_1U_1U_o_expo_5_4_lpi_1_dfm_5_0_1;
  reg FpExpoWidthInc_5U_6U_10U_1U_1U_o_expo_5_4_lpi_1_dfm_6_1_1;
  reg FpExpoWidthInc_5U_6U_10U_1U_1U_o_expo_5_4_lpi_1_dfm_6_0_1;
  wire main_stage_en_1;
  wire IsZero_5U_10U_IsZero_5U_10U_nor_cse_sva;
  wire IsDenorm_5U_10U_land_lpi_1_dfm;
  wire IsInf_5U_10U_land_lpi_1_dfm;
  wire IsInf_5U_10U_IsInf_5U_10U_and_cse_sva;
  wire [55:0] IntShiftRight_25U_5U_9U_mbits_fixed_sva;
  wire [25:0] IntShiftRight_25U_5U_9U_1_obits_fixed_acc_sat_sva;
  wire [26:0] nl_IntShiftRight_25U_5U_9U_1_obits_fixed_acc_sat_sva;
  wire [25:0] IntShiftRight_25U_5U_9U_obits_fixed_acc_sat_sva;
  wire [26:0] nl_IntShiftRight_25U_5U_9U_obits_fixed_acc_sat_sva;
  wire [33:0] IntShiftRight_33U_5U_17U_obits_fixed_acc_sat_sva;
  wire [34:0] nl_IntShiftRight_33U_5U_17U_obits_fixed_acc_sat_sva;
  wire chn_data_out_and_cse;
  wire or_3_cse;
  reg reg_chn_data_out_rsci_ld_core_psct_cse;
  wire or_42_cse;
  wire or_66_cse;
  wire nor_17_cse;
  wire FpExpoWidthInc_5U_6U_10U_1U_1U_FpExpoWidthInc_5U_6U_10U_1U_1U_nor_cse;
  wire and_dcpl_50;
  reg reg_cfg_truncate_1_itm;
  reg [3:0] reg_cfg_truncate_1_2_itm;
  wire [31:0] IntMulExt_17U_16U_33U_o_mux1h_1_itm;
  reg [7:0] reg_IntMulExt_17U_16U_33U_o_mul_itm;
  reg [23:0] reg_IntMulExt_17U_16U_33U_o_mul_1_itm;
  wire [4:0] cfg_truncate_mux1h_3_itm;
  reg reg_cfg_truncate_1_1_itm;
  reg [3:0] reg_cfg_truncate_1_3_itm;
  wire [9:0] FpExpoWidthInc_5U_6U_10U_1U_1U_if_1_if_lshift_itm;
  wire [16:0] IntSubExt_16U_16U_17U_o_mux1h_1_itm;
  reg [6:0] reg_IntSubExt_16U_16U_17U_o_acc_itm;
  reg reg_IntSubExt_16U_16U_17U_o_acc_1_itm;
  reg [8:0] reg_IntSubExt_16U_16U_17U_o_acc_2_itm;
  wire mux_43_itm;
  wire [31:0] z_out;
  wire signed [32:0] nl_z_out;
  wire IntSubExt_16U_16U_17U_o_and_tmp;
  wire [16:0] z_out_1;
  wire [63:0] z_out_2;
  wire chn_data_in_rsci_ld_core_psct_mx0c0;
  wire HLS_cdp_icvt_core_nvdla_int_h_ln333_assert_oWidth_ge_aWidth_p_bWidth_1_sig_mx0w1;
  wire HLS_cdp_icvt_core_nvdla_int_h_ln333_assert_oWidth_ge_aWidth_p_bWidth_2_sig_mx0w1;
  wire main_stage_v_1_mx0c1;
  wire main_stage_v_2_mx0c1;
  wire IntShiftRight_25U_5U_9U_obits_fixed_nor_ovfl_sva;
  wire IntShiftRight_25U_5U_9U_obits_fixed_and_unfl_sva;
  wire [6:0] else_if_ac_int_cctor_16_10_sva;
  wire IntShiftRight_25U_5U_9U_1_obits_fixed_nor_ovfl_sva;
  wire IntShiftRight_25U_5U_9U_1_obits_fixed_and_unfl_sva;
  wire IntShiftRight_33U_5U_17U_obits_fixed_IntShiftRight_33U_5U_17U_obits_fixed_nor_2_seb_sva;
  wire IntShiftRight_33U_5U_17U_obits_fixed_and_unfl_sva;
  wire IntShiftRight_33U_5U_17U_obits_fixed_nor_ovfl_sva;
  wire [14:0] else_else_o_trt_15_1_sva;
  wire [4:0] FpExpoWidthInc_5U_6U_10U_1U_1U_if_1_if_acc_psp_sva;
  wire [5:0] nl_FpExpoWidthInc_5U_6U_10U_1U_1U_if_1_if_acc_psp_sva;
  wire IsNaN_5U_10U_land_lpi_1_dfm;
  wire asn_56;
  wire [3:0] libraries_leading_sign_10_0_8b78af2050cf8551b0aa4ca6a9790ede3d5a_1;
  reg reg_FpExpoWidthInc_5U_6U_10U_1U_1U_o_mant_lpi_1_dfm_6_tmp;
  reg [8:0] reg_FpExpoWidthInc_5U_6U_10U_1U_1U_o_mant_lpi_1_dfm_6_tmp_1;
  wire i_data_and_cse;
  wire and_137_cse;
  wire FpExpoWidthInc_5U_6U_10U_1U_1U_o_expo_and_2_cse;
  wire or_78_cse_1;
  wire nor_23_cse;
  wire and_144_cse;
  wire nor_13_cse;
  wire or_107_cse;

  wire[0:0] iExpoWidth_oExpoWidth_prb;
  wire[0:0] or_52;
  wire[0:0] oWidth_mWidth_prb;
  wire[0:0] oWidth_aWidth_bWidth_prb;
  wire[0:0] oWidth_mWidth_prb_1;
  wire[0:0] oWidth_aWidth_bWidth_prb_1;
  wire[0:0] oWidth_mWidth_prb_2;
  wire[0:0] oWidth_aWidth_bWidth_prb_2;
  wire[0:0] IntShiftRight_25U_5U_9U_obits_fixed_IntShiftRight_25U_5U_9U_obits_fixed_nor_1_nl;
  wire[0:0] IntShiftRight_33U_5U_17U_obits_fixed_IntShiftRight_33U_5U_17U_obits_fixed_nor_1_nl;
  wire[6:0] IntShiftRight_25U_5U_9U_obits_fixed_IntShiftRight_25U_5U_9U_obits_fixed_nor_nl;
  wire[6:0] IntShiftRight_25U_5U_9U_obits_fixed_nor_2_nl;
  wire[0:0] IntShiftRight_25U_5U_9U_1_obits_fixed_IntShiftRight_25U_5U_9U_1_obits_fixed_nor_1_nl;
  wire[0:0] mux_4_nl;
  wire[0:0] or_2_nl;
  wire[0:0] mux_48_nl;
  wire[0:0] or_127_nl;
  wire[0:0] mux_9_nl;
  wire[0:0] nor_24_nl;
  wire[23:0] IntMulExt_9U_16U_25U_1_o_mul_nl;
  wire signed [24:0] nl_IntMulExt_9U_16U_25U_1_o_mul_nl;
  wire[0:0] mux_41_nl;
  wire[0:0] or_70_nl;
  wire[0:0] nor_15_nl;
  wire[0:0] mux_21_nl;
  wire[0:0] nor_21_nl;
  wire[0:0] mux_20_nl;
  wire[0:0] mux_19_nl;
  wire[0:0] mux_18_nl;
  wire[0:0] or_28_nl;
  wire[0:0] or_65_nl;
  wire[0:0] mux_22_nl;
  wire[0:0] or_30_nl;
  wire[0:0] mux_25_nl;
  wire[0:0] nor_30_nl;
  wire[0:0] mux_24_nl;
  wire[0:0] mux_23_nl;
  wire[0:0] nor_5_nl;
  wire[0:0] FpExpoWidthInc_5U_6U_10U_1U_1U_if_1_mux_2_nl;
  wire[0:0] FpExpoWidthInc_5U_6U_10U_1U_1U_FpExpoWidthInc_5U_6U_10U_1U_1U_FpExpoWidthInc_5U_6U_10U_1U_1U_nor_nl;
  wire[3:0] FpExpoWidthInc_5U_6U_10U_1U_1U_if_3_FpExpoWidthInc_5U_6U_10U_1U_1U_if_3_or_1_nl;
  wire[3:0] FpExpoWidthInc_5U_6U_10U_1U_1U_FpExpoWidthInc_5U_6U_10U_1U_1U_mux1h_nl;
  wire[0:0] mux_36_nl;
  wire[0:0] mux_35_nl;
  wire[0:0] mux_33_nl;
  wire[0:0] or_38_nl;
  wire[0:0] or_39_nl;
  wire[0:0] mux_38_nl;
  wire[0:0] nor_19_nl;
  wire[0:0] mux_37_nl;
  wire[0:0] mux_28_nl;
  wire[8:0] IntSubExt_8U_8U_9U_1_o_acc_nl;
  wire[9:0] nl_IntSubExt_8U_8U_9U_1_o_acc_nl;
  wire[9:0] IntSubExt_16U_16U_17U_o_asn_IntSubExt_16U_16U_17U_o_conc_1_cgspt_9_mux_nl;
  wire[9:0] FpExpoWidthInc_5U_6U_10U_1U_1U_FpExpoWidthInc_5U_6U_10U_1U_1U_or_1_nl;
  wire[0:0] and_120_nl;
  wire[0:0] and_76_nl;
  wire[0:0] mux_44_nl;
  wire[0:0] nor_12_nl;
  wire[0:0] or_53_nl;
  wire[0:0] or_54_nl;
  wire[0:0] IntShiftRight_25U_5U_9U_obits_fixed_and_nl;
  wire[6:0] IntShiftRight_25U_5U_9U_1_obits_fixed_nor_2_nl;
  wire[0:0] IntShiftRight_25U_5U_9U_1_obits_fixed_and_nl;
  wire[0:0] IntShiftRight_33U_5U_17U_obits_fixed_and_nl;
  wire[14:0] IntShiftRight_33U_5U_17U_obits_fixed_nor_2_nl;
  wire[0:0] and_108_nl;
  wire[0:0] nor_20_nl;
  wire[0:0] or_83_nl;
  wire[0:0] mux_42_nl;
  wire[16:0] IntMulExt_9U_16U_25U_o_mux_2_nl;
  wire[0:0] IntMulExt_17U_16U_33U_o_and_1_nl;
  wire[17:0] acc_nl;
  wire[18:0] nl_acc_nl;
  wire[7:0] IntSubExt_8U_8U_9U_o_mux_4_nl;
  wire[15:0] IntSubExt_8U_8U_9U_o_mux_5_nl;

  // Interconnect Declarations for Component Instantiations 
  wire [8:0] nl_FpExpoWidthInc_5U_6U_10U_1U_1U_if_1_if_lshift_rg_a;
  assign nl_FpExpoWidthInc_5U_6U_10U_1U_1U_if_1_if_lshift_rg_a = chn_data_in_rsci_d_mxwt[8:0];
  wire [5:0] nl_FpExpoWidthInc_5U_6U_10U_1U_1U_if_1_if_lshift_rg_s;
  assign nl_FpExpoWidthInc_5U_6U_10U_1U_1U_if_1_if_lshift_rg_s = conv_u2u_4_5(libraries_leading_sign_10_0_8b78af2050cf8551b0aa4ca6a9790ede3d5a_1)
      + 5'b1;
  wire [55:0] nl_IntShiftRight_25U_5U_9U_mbits_fixed_rshift_rg_a;
  assign nl_IntShiftRight_25U_5U_9U_mbits_fixed_rshift_rg_a = signext_56_55({IntMulExt_9U_16U_25U_o_mul_itm_2
      , 31'b0});
  wire [4:0] nl_IntShiftRight_25U_5U_9U_mbits_fixed_rshift_rg_s;
  assign nl_IntShiftRight_25U_5U_9U_mbits_fixed_rshift_rg_s = {reg_cfg_truncate_1_itm
      , reg_cfg_truncate_1_2_itm};
  wire [9:0] nl_leading_sign_10_0_rg_mantissa;
  assign nl_leading_sign_10_0_rg_mantissa = chn_data_in_rsci_d_mxwt[9:0];
  wire[7:0] IntShiftRight_25U_5U_9U_1_mbits_fixed_mux_nl;
  wire[0:0] IntShiftRight_33U_5U_17U_mbits_fixed_and_nl;
  wire [63:0] nl_IntShiftRight_25U_5U_9U_1_mbits_fixed_rshift_rg_a;
  assign IntShiftRight_33U_5U_17U_mbits_fixed_and_nl = (fsm_output[1]) & nor_tmp_11;
  assign IntShiftRight_25U_5U_9U_1_mbits_fixed_mux_nl = MUX_v_8_2_2((signext_8_1(reg_IntMulExt_17U_16U_33U_o_mul_1_itm[23])),
      reg_IntMulExt_17U_16U_33U_o_mul_itm, IntShiftRight_33U_5U_17U_mbits_fixed_and_nl);
  assign nl_IntShiftRight_25U_5U_9U_1_mbits_fixed_rshift_rg_a = signext_64_63({(IntShiftRight_25U_5U_9U_1_mbits_fixed_mux_nl)
      , reg_IntMulExt_17U_16U_33U_o_mul_1_itm , 31'b0});
  wire [4:0] nl_IntShiftRight_25U_5U_9U_1_mbits_fixed_rshift_rg_s;
  assign nl_IntShiftRight_25U_5U_9U_1_mbits_fixed_rshift_rg_s = {reg_cfg_truncate_1_itm
      , reg_cfg_truncate_1_2_itm};
  wire [17:0] nl_HLS_cdp_icvt_core_chn_data_out_rsci_inst_chn_data_out_rsci_d;
  assign nl_HLS_cdp_icvt_core_chn_data_out_rsci_inst_chn_data_out_rsci_d = {chn_data_out_rsci_d_17
      , chn_data_out_rsci_d_16 , chn_data_out_rsci_d_15 , chn_data_out_rsci_d_14
      , chn_data_out_rsci_d_13_10 , chn_data_out_rsci_d_9 , chn_data_out_rsci_d_8
      , chn_data_out_rsci_d_7_1 , chn_data_out_rsci_d_0};
  CDP_ICVT_mgc_in_wire_v1 #(.rscid(32'sd2),
  .width(32'sd16)) cfg_alu_in_rsci (
      .d(cfg_alu_in_rsci_d),
      .z(cfg_alu_in_rsc_z)
    );
  CDP_ICVT_mgc_in_wire_v1 #(.rscid(32'sd3),
  .width(32'sd16)) cfg_mul_in_rsci (
      .d(cfg_mul_in_rsci_d),
      .z(cfg_mul_in_rsc_z)
    );
  CDP_ICVT_mgc_in_wire_v1 #(.rscid(32'sd4),
  .width(32'sd5)) cfg_truncate_rsci (
      .d(cfg_truncate_rsci_d),
      .z(cfg_truncate_rsc_z)
    );
  CDP_ICVT_mgc_in_wire_v1 #(.rscid(32'sd5),
  .width(32'sd2)) cfg_precision_rsci (
      .d(cfg_precision_rsci_d),
      .z(cfg_precision_rsc_z)
    );
  CDP_ICVT_mgc_shift_l_v4 #(.width_a(32'sd9),
  .signd_a(32'sd1),
  .width_s(32'sd5),
  .width_z(32'sd10)) FpExpoWidthInc_5U_6U_10U_1U_1U_if_1_if_lshift_rg (
      .a(nl_FpExpoWidthInc_5U_6U_10U_1U_1U_if_1_if_lshift_rg_a[8:0]),
      .s(nl_FpExpoWidthInc_5U_6U_10U_1U_1U_if_1_if_lshift_rg_s[4:0]),
      .z(FpExpoWidthInc_5U_6U_10U_1U_1U_if_1_if_lshift_itm)
    );
  CDP_ICVT_mgc_shift_r_v4 #(.width_a(32'sd56),
  .signd_a(32'sd1),
  .width_s(32'sd5),
  .width_z(32'sd56)) IntShiftRight_25U_5U_9U_mbits_fixed_rshift_rg (
      .a(nl_IntShiftRight_25U_5U_9U_mbits_fixed_rshift_rg_a[55:0]),
      .s(nl_IntShiftRight_25U_5U_9U_mbits_fixed_rshift_rg_s[4:0]),
      .z(IntShiftRight_25U_5U_9U_mbits_fixed_sva)
    );
  CDP_ICVT_leading_sign_10_0  leading_sign_10_0_rg (
      .mantissa(nl_leading_sign_10_0_rg_mantissa[9:0]),
      .rtn(libraries_leading_sign_10_0_8b78af2050cf8551b0aa4ca6a9790ede3d5a_1)
    );
  CDP_ICVT_mgc_shift_r_v4 #(.width_a(32'sd64),
  .signd_a(32'sd1),
  .width_s(32'sd5),
  .width_z(32'sd64)) IntShiftRight_25U_5U_9U_1_mbits_fixed_rshift_rg (
      .a(nl_IntShiftRight_25U_5U_9U_1_mbits_fixed_rshift_rg_a[63:0]),
      .s(nl_IntShiftRight_25U_5U_9U_1_mbits_fixed_rshift_rg_s[4:0]),
      .z(z_out_2)
    );
  HLS_cdp_icvt_core_chn_data_in_rsci HLS_cdp_icvt_core_chn_data_in_rsci_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_data_in_rsc_z(chn_data_in_rsc_z),
      .chn_data_in_rsc_vz(chn_data_in_rsc_vz),
      .chn_data_in_rsc_lz(chn_data_in_rsc_lz),
      .chn_data_in_rsci_oswt(chn_data_in_rsci_oswt),
      .core_wen(core_wen),
      .chn_data_in_rsci_iswt0(chn_data_in_rsci_iswt0),
      .chn_data_in_rsci_bawt(chn_data_in_rsci_bawt),
      .chn_data_in_rsci_wen_comp(chn_data_in_rsci_wen_comp),
      .chn_data_in_rsci_ld_core_psct(chn_data_in_rsci_ld_core_psct),
      .chn_data_in_rsci_d_mxwt(chn_data_in_rsci_d_mxwt),
      .core_wten(core_wten)
    );
  HLS_cdp_icvt_core_chn_data_out_rsci HLS_cdp_icvt_core_chn_data_out_rsci_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_data_out_rsc_z(chn_data_out_rsc_z),
      .chn_data_out_rsc_vz(chn_data_out_rsc_vz),
      .chn_data_out_rsc_lz(chn_data_out_rsc_lz),
      .chn_data_out_rsci_oswt(chn_data_out_rsci_oswt),
      .core_wen(core_wen),
      .core_wten(core_wten),
      .chn_data_out_rsci_iswt0(chn_data_out_rsci_iswt0),
      .chn_data_out_rsci_bawt(chn_data_out_rsci_bawt),
      .chn_data_out_rsci_wen_comp(chn_data_out_rsci_wen_comp),
      .chn_data_out_rsci_ld_core_psct(reg_chn_data_out_rsci_ld_core_psct_cse),
      .chn_data_out_rsci_d(nl_HLS_cdp_icvt_core_chn_data_out_rsci_inst_chn_data_out_rsci_d[17:0])
    );
  HLS_cdp_icvt_core_staller HLS_cdp_icvt_core_staller_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .core_wen(core_wen),
      .chn_data_in_rsci_wen_comp(chn_data_in_rsci_wen_comp),
      .core_wten(core_wten),
      .chn_data_out_rsci_wen_comp(chn_data_out_rsci_wen_comp)
    );
  HLS_cdp_icvt_core_core_fsm HLS_cdp_icvt_core_core_fsm_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .core_wen(core_wen),
      .fsm_output(fsm_output)
    );
  assign or_52 = (main_stage_en_1 & and_dcpl & (fsm_output[1])) | (and_dcpl_4 & and_dcpl);
  assign iExpoWidth_oExpoWidth_prb = MUX1HOT_s_1_1_2(1'b1, or_52);
  // assert(iExpoWidth <= oExpoWidth) - ../include/nvdla_float.h: line 477
  // PSL HLS_cdp_icvt_core_nvdla_float_h_ln477_assert_iExpoWidth_le_oExpoWidth : assert { iExpoWidth_oExpoWidth_prb } @rose(nvdla_core_clk);
  assign oWidth_mWidth_prb = HLS_cdp_icvt_core_nvdla_int_h_ln333_assert_oWidth_ge_aWidth_p_bWidth_1_sig_mx0w1;
  // assert(oWidth > mWidth) - ../include/nvdla_int.h: line 274
  // PSL HLS_cdp_icvt_core_nvdla_int_h_ln274_assert_oWidth_gt_mWidth : assert { oWidth_mWidth_prb } @rose(nvdla_core_clk);
  assign oWidth_aWidth_bWidth_prb = HLS_cdp_icvt_core_nvdla_int_h_ln333_assert_oWidth_ge_aWidth_p_bWidth_1_sig_mx0w1;
  // assert(oWidth >= aWidth+bWidth) - ../include/nvdla_int.h: line 333
  // PSL HLS_cdp_icvt_core_nvdla_int_h_ln333_assert_oWidth_ge_aWidth_p_bWidth : assert { oWidth_aWidth_bWidth_prb } @rose(nvdla_core_clk);
  assign oWidth_mWidth_prb_1 = HLS_cdp_icvt_core_nvdla_int_h_ln333_assert_oWidth_ge_aWidth_p_bWidth_1_sig_mx0w1;
  // assert(oWidth > mWidth) - ../include/nvdla_int.h: line 274
  // PSL HLS_cdp_icvt_core_nvdla_int_h_ln274_assert_oWidth_gt_mWidth_1 : assert { oWidth_mWidth_prb_1 } @rose(nvdla_core_clk);
  assign oWidth_aWidth_bWidth_prb_1 = HLS_cdp_icvt_core_nvdla_int_h_ln333_assert_oWidth_ge_aWidth_p_bWidth_1_sig_mx0w1;
  // assert(oWidth >= aWidth+bWidth) - ../include/nvdla_int.h: line 333
  // PSL HLS_cdp_icvt_core_nvdla_int_h_ln333_assert_oWidth_ge_aWidth_p_bWidth_1 : assert { oWidth_aWidth_bWidth_prb_1 } @rose(nvdla_core_clk);
  assign oWidth_mWidth_prb_2 = HLS_cdp_icvt_core_nvdla_int_h_ln333_assert_oWidth_ge_aWidth_p_bWidth_2_sig_mx0w1;
  // assert(oWidth > mWidth) - ../include/nvdla_int.h: line 274
  // PSL HLS_cdp_icvt_core_nvdla_int_h_ln274_assert_oWidth_gt_mWidth_2 : assert { oWidth_mWidth_prb_2 } @rose(nvdla_core_clk);
  assign oWidth_aWidth_bWidth_prb_2 = HLS_cdp_icvt_core_nvdla_int_h_ln333_assert_oWidth_ge_aWidth_p_bWidth_2_sig_mx0w1;
  // assert(oWidth >= aWidth+bWidth) - ../include/nvdla_int.h: line 333
  // PSL HLS_cdp_icvt_core_nvdla_int_h_ln333_assert_oWidth_ge_aWidth_p_bWidth_2 : assert { oWidth_aWidth_bWidth_prb_2 } @rose(nvdla_core_clk);
  assign chn_data_out_and_cse = core_wen & (~(and_dcpl_16 | (~ main_stage_v_2)));
  assign nor_17_cse = ~((io_read_cfg_precision_rsc_svs_st_4!=2'b00));
  assign or_3_cse = (~ reg_chn_data_out_rsci_ld_core_psct_cse) | chn_data_out_rsci_bawt;
  assign or_66_cse = (io_read_cfg_precision_rsc_svs_st_3!=2'b00);
  assign nor_23_cse = ~((~ main_stage_v_1) | (io_read_cfg_precision_rsc_svs_st_3!=2'b00));
  assign nl_IntMulExt_9U_16U_25U_1_o_mul_nl = $signed(reg_IntSubExt_16U_16U_17U_o_acc_2_itm)
      * $signed(cfg_mul_in_1_sva_2);
  assign IntMulExt_9U_16U_25U_1_o_mul_nl = nl_IntMulExt_9U_16U_25U_1_o_mul_nl[23:0];
  assign or_70_nl = (io_read_cfg_precision_rsc_svs_st_4[0]) | chn_data_out_rsci_bawt
      | (~ reg_chn_data_out_rsci_ld_core_psct_cse);
  assign nor_15_nl = ~((~ (io_read_cfg_precision_rsc_svs_st_4[0])) | chn_data_out_rsci_bawt
      | (~ reg_chn_data_out_rsci_ld_core_psct_cse));
  assign mux_41_nl = MUX_s_1_2_2((nor_15_nl), (or_70_nl), io_read_cfg_precision_rsc_svs_st_3[0]);
  assign IntMulExt_17U_16U_33U_o_mux1h_1_itm = MUX_v_32_2_2(({8'b0 , (IntMulExt_9U_16U_25U_1_o_mul_nl)}),
      z_out, mux_41_nl);
  assign nor_21_nl = ~((io_read_cfg_precision_rsc_svs_st_3[0]) | (~(main_stage_v_1
      & and_tmp_4)));
  assign or_28_nl = (io_read_cfg_precision_rsc_svs_st_3[1]) | (~ or_3_cse);
  assign mux_18_nl = MUX_s_1_2_2(and_tmp_4, (or_28_nl), main_stage_v_2);
  assign mux_19_nl = MUX_s_1_2_2((~ or_tmp_15), (mux_18_nl), main_stage_v_1);
  assign mux_20_nl = MUX_s_1_2_2((mux_19_nl), (~ or_tmp_15), io_read_cfg_precision_rsc_svs_st_3[0]);
  assign or_65_nl = nor_17_cse | nor_tmp_11;
  assign mux_21_nl = MUX_s_1_2_2((mux_20_nl), (nor_21_nl), or_65_nl);
  assign i_data_and_cse = core_wen & (~ and_dcpl_16) & (mux_21_nl);
  assign or_30_nl = main_stage_v_2 | chn_data_out_rsci_bawt | (~ reg_chn_data_out_rsci_ld_core_psct_cse);
  assign mux_22_nl = MUX_s_1_2_2((~ or_tmp_15), (or_30_nl), main_stage_v_1);
  assign and_137_cse = core_wen & (~ and_dcpl_16) & (mux_22_nl);
  assign nor_30_nl = ~((io_read_cfg_precision_rsc_svs_st_3[0]) | (~ main_stage_v_1)
      | or_107_cse);
  assign mux_23_nl = MUX_s_1_2_2((~ or_107_cse), or_tmp_35, chn_data_in_rsci_bawt);
  assign nor_5_nl = ~((io_read_cfg_precision_rsc_svs_st_3[0]) | (~ main_stage_v_1));
  assign mux_24_nl = MUX_s_1_2_2(main_stage_en_1, (mux_23_nl), nor_5_nl);
  assign mux_25_nl = MUX_s_1_2_2((mux_24_nl), (nor_30_nl), or_78_cse_1);
  assign FpExpoWidthInc_5U_6U_10U_1U_1U_o_expo_and_2_cse = core_wen & (~ and_dcpl_16)
      & (mux_25_nl);
  assign or_78_cse_1 = (cfg_precision_rsci_d!=2'b10);
  assign FpExpoWidthInc_5U_6U_10U_1U_1U_FpExpoWidthInc_5U_6U_10U_1U_1U_mux1h_nl =
      MUX1HOT_v_4_3_2((chn_data_in_rsci_d_mxwt[13:10]), (FpExpoWidthInc_5U_6U_10U_1U_1U_if_1_if_acc_psp_sva[3:0]),
      4'b1110, {FpExpoWidthInc_5U_6U_10U_1U_1U_FpExpoWidthInc_5U_6U_10U_1U_1U_nor_cse
      , IsDenorm_5U_10U_land_lpi_1_dfm , IsInf_5U_10U_land_lpi_1_dfm});
  assign FpExpoWidthInc_5U_6U_10U_1U_1U_if_3_FpExpoWidthInc_5U_6U_10U_1U_1U_if_3_or_1_nl
      = MUX_v_4_2_2((FpExpoWidthInc_5U_6U_10U_1U_1U_FpExpoWidthInc_5U_6U_10U_1U_1U_mux1h_nl),
      4'b1111, IsNaN_5U_10U_land_lpi_1_dfm);
  assign cfg_truncate_mux1h_3_itm = MUX_v_5_2_2(({1'b0 , (FpExpoWidthInc_5U_6U_10U_1U_1U_if_3_FpExpoWidthInc_5U_6U_10U_1U_1U_if_3_or_1_nl)}),
      cfg_truncate_rsci_d, mux_43_itm);
  assign and_144_cse = core_wen & chn_data_in_rsci_bawt & or_3_cse;
  assign or_42_cse = (cfg_precision_rsci_d!=2'b00);
  assign nor_13_cse = ~((io_read_cfg_precision_rsc_svs_st_3!=2'b00));
  assign or_107_cse = nor_13_cse | chn_data_out_rsci_bawt | (~ reg_chn_data_out_rsci_ld_core_psct_cse);
  assign nl_IntSubExt_8U_8U_9U_1_o_acc_nl = conv_s2u_8_9(chn_data_in_rsci_d_mxwt[15:8])
      - conv_s2u_8_9(cfg_alu_in_rsci_d[7:0]);
  assign IntSubExt_8U_8U_9U_1_o_acc_nl = nl_IntSubExt_8U_8U_9U_1_o_acc_nl[8:0];
  assign FpExpoWidthInc_5U_6U_10U_1U_1U_FpExpoWidthInc_5U_6U_10U_1U_1U_or_1_nl =
      MUX_v_10_2_2(FpExpoWidthInc_5U_6U_10U_1U_1U_if_1_if_lshift_itm, 10'b1111111111,
      IsInf_5U_10U_land_lpi_1_dfm);
  assign and_120_nl = FpExpoWidthInc_5U_6U_10U_1U_1U_FpExpoWidthInc_5U_6U_10U_1U_1U_nor_cse
      & or_3_cse;
  assign IntSubExt_16U_16U_17U_o_asn_IntSubExt_16U_16U_17U_o_conc_1_cgspt_9_mux_nl
      = MUX_v_10_2_2((FpExpoWidthInc_5U_6U_10U_1U_1U_FpExpoWidthInc_5U_6U_10U_1U_1U_or_1_nl),
      (chn_data_in_rsci_d_mxwt[9:0]), and_120_nl);
  assign and_76_nl = or_3_cse & (cfg_precision_rsci_d[0]);
  assign nor_12_nl = ~((io_read_cfg_precision_rsc_svs_st_3!=2'b00) | chn_data_out_rsci_bawt
      | (~ reg_chn_data_out_rsci_ld_core_psct_cse));
  assign mux_44_nl = MUX_s_1_2_2(or_107_cse, (nor_12_nl), or_42_cse);
  assign IntSubExt_16U_16U_17U_o_mux1h_1_itm = MUX1HOT_v_17_3_2(z_out_1, ({8'b0 ,
      (IntSubExt_8U_8U_9U_1_o_acc_nl)}), ({7'b0 , (IntSubExt_16U_16U_17U_o_asn_IntSubExt_16U_16U_17U_o_conc_1_cgspt_9_mux_nl)}),
      {(and_76_nl) , (mux_44_nl) , (~ mux_43_itm)});
  assign or_53_nl = (main_stage_en_1 & and_dcpl_6 & (fsm_output[1])) | (and_dcpl_4
      & and_dcpl_6);
  assign HLS_cdp_icvt_core_nvdla_int_h_ln333_assert_oWidth_ge_aWidth_p_bWidth_1_sig_mx0w1
      = MUX1HOT_s_1_1_2(1'b1, or_53_nl);
  assign or_54_nl = (or_3_cse & and_dcpl_9 & (fsm_output[1])) | (and_dcpl_3 & and_dcpl_9);
  assign HLS_cdp_icvt_core_nvdla_int_h_ln333_assert_oWidth_ge_aWidth_p_bWidth_2_sig_mx0w1
      = MUX1HOT_s_1_1_2(1'b1, or_54_nl);
  assign IsDenorm_5U_10U_land_lpi_1_dfm = IsDenorm_5U_10U_or_tmp & IsZero_5U_10U_IsZero_5U_10U_nor_cse_sva;
  assign IsDenorm_5U_10U_or_tmp = (chn_data_in_rsci_d_mxwt[9:0]!=10'b0000000000);
  assign IsZero_5U_10U_IsZero_5U_10U_nor_cse_sva = ~((chn_data_in_rsci_d_mxwt[14:10]!=5'b00000));
  assign IntShiftRight_25U_5U_9U_obits_fixed_and_nl = (IntShiftRight_25U_5U_9U_mbits_fixed_sva[30])
      & ((IntShiftRight_25U_5U_9U_mbits_fixed_sva[0]) | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[1])
      | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[2]) | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[3])
      | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[4]) | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[5])
      | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[6]) | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[7])
      | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[8]) | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[9])
      | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[10]) | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[11])
      | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[12]) | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[13])
      | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[14]) | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[15])
      | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[16]) | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[17])
      | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[18]) | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[19])
      | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[20]) | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[21])
      | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[22]) | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[23])
      | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[24]) | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[25])
      | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[26]) | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[27])
      | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[28]) | (IntShiftRight_25U_5U_9U_mbits_fixed_sva[29])
      | (~ (IntShiftRight_25U_5U_9U_mbits_fixed_sva[55])));
  assign nl_IntShiftRight_25U_5U_9U_obits_fixed_acc_sat_sva = conv_s2s_25_26(IntShiftRight_25U_5U_9U_mbits_fixed_sva[55:31])
      + conv_u2s_1_26(IntShiftRight_25U_5U_9U_obits_fixed_and_nl);
  assign IntShiftRight_25U_5U_9U_obits_fixed_acc_sat_sva = nl_IntShiftRight_25U_5U_9U_obits_fixed_acc_sat_sva[25:0];
  assign IntShiftRight_25U_5U_9U_obits_fixed_nor_ovfl_sva = ~((IntShiftRight_25U_5U_9U_obits_fixed_acc_sat_sva[25])
      | (~((IntShiftRight_25U_5U_9U_obits_fixed_acc_sat_sva[24:8]!=17'b00000000000000000))));
  assign IntShiftRight_25U_5U_9U_obits_fixed_and_unfl_sva = (IntShiftRight_25U_5U_9U_obits_fixed_acc_sat_sva[25])
      & (~((IntShiftRight_25U_5U_9U_obits_fixed_acc_sat_sva[24:8]==17'b11111111111111111)));
  assign IntShiftRight_25U_5U_9U_1_obits_fixed_nor_2_nl = ~(MUX_v_7_2_2((IntShiftRight_25U_5U_9U_1_obits_fixed_acc_sat_sva[7:1]),
      7'b1111111, IntShiftRight_25U_5U_9U_1_obits_fixed_nor_ovfl_sva));
  assign else_if_ac_int_cctor_16_10_sva = ~(MUX_v_7_2_2((IntShiftRight_25U_5U_9U_1_obits_fixed_nor_2_nl),
      7'b1111111, IntShiftRight_25U_5U_9U_1_obits_fixed_and_unfl_sva));
  assign IntShiftRight_25U_5U_9U_1_obits_fixed_and_nl = (z_out_2[30]) & ((z_out_2[0])
      | (z_out_2[1]) | (z_out_2[2]) | (z_out_2[3]) | (z_out_2[4]) | (z_out_2[5])
      | (z_out_2[6]) | (z_out_2[7]) | (z_out_2[8]) | (z_out_2[9]) | (z_out_2[10])
      | (z_out_2[11]) | (z_out_2[12]) | (z_out_2[13]) | (z_out_2[14]) | (z_out_2[15])
      | (z_out_2[16]) | (z_out_2[17]) | (z_out_2[18]) | (z_out_2[19]) | (z_out_2[20])
      | (z_out_2[21]) | (z_out_2[22]) | (z_out_2[23]) | (z_out_2[24]) | (z_out_2[25])
      | (z_out_2[26]) | (z_out_2[27]) | (z_out_2[28]) | (z_out_2[29]) | (~ (z_out_2[55])));
  assign nl_IntShiftRight_25U_5U_9U_1_obits_fixed_acc_sat_sva = conv_s2s_25_26(z_out_2[55:31])
      + conv_u2s_1_26(IntShiftRight_25U_5U_9U_1_obits_fixed_and_nl);
  assign IntShiftRight_25U_5U_9U_1_obits_fixed_acc_sat_sva = nl_IntShiftRight_25U_5U_9U_1_obits_fixed_acc_sat_sva[25:0];
  assign IntShiftRight_25U_5U_9U_1_obits_fixed_nor_ovfl_sva = ~((IntShiftRight_25U_5U_9U_1_obits_fixed_acc_sat_sva[25])
      | (~((IntShiftRight_25U_5U_9U_1_obits_fixed_acc_sat_sva[24:8]!=17'b00000000000000000))));
  assign IntShiftRight_25U_5U_9U_1_obits_fixed_and_unfl_sva = (IntShiftRight_25U_5U_9U_1_obits_fixed_acc_sat_sva[25])
      & (~((IntShiftRight_25U_5U_9U_1_obits_fixed_acc_sat_sva[24:8]==17'b11111111111111111)));
  assign IntShiftRight_33U_5U_17U_obits_fixed_IntShiftRight_33U_5U_17U_obits_fixed_nor_2_seb_sva
      = ~((~((IntShiftRight_33U_5U_17U_obits_fixed_acc_sat_sva[16]) | IntShiftRight_33U_5U_17U_obits_fixed_and_unfl_sva))
      | IntShiftRight_33U_5U_17U_obits_fixed_nor_ovfl_sva);
  assign IntShiftRight_33U_5U_17U_obits_fixed_and_nl = (z_out_2[30]) & ((z_out_2[0])
      | (z_out_2[1]) | (z_out_2[2]) | (z_out_2[3]) | (z_out_2[4]) | (z_out_2[5])
      | (z_out_2[6]) | (z_out_2[7]) | (z_out_2[8]) | (z_out_2[9]) | (z_out_2[10])
      | (z_out_2[11]) | (z_out_2[12]) | (z_out_2[13]) | (z_out_2[14]) | (z_out_2[15])
      | (z_out_2[16]) | (z_out_2[17]) | (z_out_2[18]) | (z_out_2[19]) | (z_out_2[20])
      | (z_out_2[21]) | (z_out_2[22]) | (z_out_2[23]) | (z_out_2[24]) | (z_out_2[25])
      | (z_out_2[26]) | (z_out_2[27]) | (z_out_2[28]) | (z_out_2[29]) | (~ (z_out_2[63])));
  assign nl_IntShiftRight_33U_5U_17U_obits_fixed_acc_sat_sva = conv_s2s_33_34(z_out_2[63:31])
      + conv_u2s_1_34(IntShiftRight_33U_5U_17U_obits_fixed_and_nl);
  assign IntShiftRight_33U_5U_17U_obits_fixed_acc_sat_sva = nl_IntShiftRight_33U_5U_17U_obits_fixed_acc_sat_sva[33:0];
  assign IntShiftRight_33U_5U_17U_obits_fixed_and_unfl_sva = (IntShiftRight_33U_5U_17U_obits_fixed_acc_sat_sva[33])
      & (~((IntShiftRight_33U_5U_17U_obits_fixed_acc_sat_sva[32:16]==17'b11111111111111111)));
  assign IntShiftRight_33U_5U_17U_obits_fixed_nor_ovfl_sva = ~((IntShiftRight_33U_5U_17U_obits_fixed_acc_sat_sva[33])
      | (~((IntShiftRight_33U_5U_17U_obits_fixed_acc_sat_sva[32:16]!=17'b00000000000000000))));
  assign IntShiftRight_33U_5U_17U_obits_fixed_nor_2_nl = ~(MUX_v_15_2_2((IntShiftRight_33U_5U_17U_obits_fixed_acc_sat_sva[15:1]),
      15'b111111111111111, IntShiftRight_33U_5U_17U_obits_fixed_nor_ovfl_sva));
  assign else_else_o_trt_15_1_sva = ~(MUX_v_15_2_2((IntShiftRight_33U_5U_17U_obits_fixed_nor_2_nl),
      15'b111111111111111, IntShiftRight_33U_5U_17U_obits_fixed_and_unfl_sva));
  assign main_stage_en_1 = chn_data_in_rsci_bawt & or_3_cse;
  assign nl_FpExpoWidthInc_5U_6U_10U_1U_1U_if_1_if_acc_psp_sva = ({1'b1 , (~ libraries_leading_sign_10_0_8b78af2050cf8551b0aa4ca6a9790ede3d5a_1)})
      + 5'b10001;
  assign FpExpoWidthInc_5U_6U_10U_1U_1U_if_1_if_acc_psp_sva = nl_FpExpoWidthInc_5U_6U_10U_1U_1U_if_1_if_acc_psp_sva[4:0];
  assign FpExpoWidthInc_5U_6U_10U_1U_1U_FpExpoWidthInc_5U_6U_10U_1U_1U_nor_cse =
      ~(IsDenorm_5U_10U_land_lpi_1_dfm | IsInf_5U_10U_land_lpi_1_dfm);
  assign IsInf_5U_10U_land_lpi_1_dfm = ~((chn_data_in_rsci_d_mxwt[9:0]!=10'b0000000000)
      | (~ IsInf_5U_10U_IsInf_5U_10U_and_cse_sva));
  assign IsNaN_5U_10U_land_lpi_1_dfm = IsDenorm_5U_10U_or_tmp & IsInf_5U_10U_IsInf_5U_10U_and_cse_sva;
  assign IsInf_5U_10U_IsInf_5U_10U_and_cse_sva = (chn_data_in_rsci_d_mxwt[14:10]==5'b11111);
  assign asn_56 = ~(nor_17_cse | nor_tmp_11);
  assign and_dcpl = (cfg_precision_rsci_d==2'b10);
  assign and_dcpl_3 = reg_chn_data_out_rsci_ld_core_psct_cse & chn_data_out_rsci_bawt;
  assign and_dcpl_4 = and_dcpl_3 & chn_data_in_rsci_bawt;
  assign and_dcpl_6 = ~((cfg_precision_rsci_d!=2'b00));
  assign and_dcpl_9 = chn_data_in_rsci_bawt & (cfg_precision_rsci_d[0]);
  assign or_tmp_15 = (~ main_stage_v_2) | (~ reg_chn_data_out_rsci_ld_core_psct_cse)
      | chn_data_out_rsci_bawt;
  assign and_tmp_4 = or_66_cse & or_3_cse;
  assign or_tmp_35 = (io_read_cfg_precision_rsc_svs_st_3!=2'b00) | chn_data_out_rsci_bawt
      | (~ reg_chn_data_out_rsci_ld_core_psct_cse);
  assign and_108_nl = main_stage_v_1 & reg_chn_data_out_rsci_ld_core_psct_cse & (~
      chn_data_out_rsci_bawt);
  assign nor_20_nl = ~((io_read_cfg_precision_rsc_svs_st_3[1]) | (~ main_stage_v_1)
      | (~ reg_chn_data_out_rsci_ld_core_psct_cse) | chn_data_out_rsci_bawt);
  assign not_tmp_22 = MUX_s_1_2_2((nor_20_nl), (and_108_nl), io_read_cfg_precision_rsc_svs_st_3[0]);
  assign and_dcpl_16 = reg_chn_data_out_rsci_ld_core_psct_cse & (~ chn_data_out_rsci_bawt);
  assign and_dcpl_18 = or_3_cse & main_stage_v_2;
  assign and_dcpl_19 = and_dcpl_3 & (~ main_stage_v_2);
  assign or_83_nl = (io_read_cfg_precision_rsc_svs_st_3[0]) | nor_13_cse | chn_data_out_rsci_bawt
      | (~ reg_chn_data_out_rsci_ld_core_psct_cse);
  assign mux_42_nl = MUX_s_1_2_2(or_tmp_35, or_3_cse, io_read_cfg_precision_rsc_svs_st_3[0]);
  assign mux_43_itm = MUX_s_1_2_2((~ (mux_42_nl)), (or_83_nl), or_78_cse_1);
  assign or_tmp_80 = or_3_cse & chn_data_in_rsci_bawt & (fsm_output[1]);
  assign chn_data_in_rsci_ld_core_psct_mx0c0 = main_stage_en_1 | (fsm_output[0]);
  assign main_stage_v_1_mx0c1 = or_3_cse & (~ chn_data_in_rsci_bawt) & main_stage_v_1;
  assign main_stage_v_2_mx0c1 = or_3_cse & main_stage_v_2 & (~ main_stage_v_1);
  assign chn_data_in_rsci_oswt_unreg = or_tmp_80;
  assign chn_data_out_rsci_oswt_unreg = and_dcpl_3;
  assign and_dcpl_50 = core_wen & main_stage_v_1;
  assign IntSubExt_16U_16U_17U_o_and_tmp = (fsm_output[1]) & (cfg_precision_rsci_d[0]);
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_data_in_rsci_iswt0 <= 1'b0;
      chn_data_out_rsci_iswt0 <= 1'b0;
    end
    else if ( core_wen ) begin
      chn_data_in_rsci_iswt0 <= ~((~ main_stage_en_1) & (fsm_output[1]));
      chn_data_out_rsci_iswt0 <= and_dcpl_18;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_data_in_rsci_ld_core_psct <= 1'b0;
    end
    else if ( core_wen & chn_data_in_rsci_ld_core_psct_mx0c0 ) begin
      chn_data_in_rsci_ld_core_psct <= chn_data_in_rsci_ld_core_psct_mx0c0;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_data_out_rsci_d_14 <= 1'b0;
      chn_data_out_rsci_d_15 <= 1'b0;
      chn_data_out_rsci_d_0 <= 1'b0;
      chn_data_out_rsci_d_7_1 <= 7'b0;
      chn_data_out_rsci_d_8 <= 1'b0;
      chn_data_out_rsci_d_9 <= 1'b0;
      chn_data_out_rsci_d_13_10 <= 4'b0;
      chn_data_out_rsci_d_16 <= 1'b0;
      chn_data_out_rsci_d_17 <= 1'b0;
    end
    else if ( chn_data_out_and_cse ) begin
      chn_data_out_rsci_d_14 <= MUX1HOT_s_1_3_2(FpExpoWidthInc_5U_6U_10U_1U_1U_o_expo_5_4_lpi_1_dfm_6_0_1,
          (else_if_ac_int_cctor_16_10_sva[4]), (else_else_o_trt_15_1_sva[13]), {asn_56
          , nor_17_cse , nor_tmp_11});
      chn_data_out_rsci_d_15 <= MUX1HOT_s_1_3_2(FpExpoWidthInc_5U_6U_10U_1U_1U_o_expo_5_4_lpi_1_dfm_6_1_1,
          (else_if_ac_int_cctor_16_10_sva[5]), (else_else_o_trt_15_1_sva[14]), {asn_56
          , nor_17_cse , nor_tmp_11});
      chn_data_out_rsci_d_0 <= MUX1HOT_s_1_3_2((reg_FpExpoWidthInc_5U_6U_10U_1U_1U_o_mant_lpi_1_dfm_6_tmp_1[0]),
          (IntShiftRight_25U_5U_9U_obits_fixed_IntShiftRight_25U_5U_9U_obits_fixed_nor_1_nl),
          (IntShiftRight_33U_5U_17U_obits_fixed_IntShiftRight_33U_5U_17U_obits_fixed_nor_1_nl),
          {asn_56 , nor_17_cse , nor_tmp_11});
      chn_data_out_rsci_d_7_1 <= MUX1HOT_v_7_3_2((reg_FpExpoWidthInc_5U_6U_10U_1U_1U_o_mant_lpi_1_dfm_6_tmp_1[7:1]),
          (IntShiftRight_25U_5U_9U_obits_fixed_IntShiftRight_25U_5U_9U_obits_fixed_nor_nl),
          (else_else_o_trt_15_1_sva[6:0]), {asn_56 , nor_17_cse , nor_tmp_11});
      chn_data_out_rsci_d_8 <= MUX1HOT_s_1_3_2((reg_FpExpoWidthInc_5U_6U_10U_1U_1U_o_mant_lpi_1_dfm_6_tmp_1[8]),
          (IntShiftRight_25U_5U_9U_obits_fixed_acc_sat_sva[25]), (else_else_o_trt_15_1_sva[7]),
          {asn_56 , nor_17_cse , nor_tmp_11});
      chn_data_out_rsci_d_9 <= MUX1HOT_s_1_3_2(reg_FpExpoWidthInc_5U_6U_10U_1U_1U_o_mant_lpi_1_dfm_6_tmp,
          (IntShiftRight_25U_5U_9U_1_obits_fixed_IntShiftRight_25U_5U_9U_1_obits_fixed_nor_1_nl),
          (else_else_o_trt_15_1_sva[8]), {asn_56 , nor_17_cse , nor_tmp_11});
      chn_data_out_rsci_d_13_10 <= MUX1HOT_v_4_3_2(reg_cfg_truncate_1_2_itm, (else_if_ac_int_cctor_16_10_sva[3:0]),
          (else_else_o_trt_15_1_sva[12:9]), {asn_56 , nor_17_cse , nor_tmp_11});
      chn_data_out_rsci_d_16 <= MUX1HOT_s_1_3_2(i_data_slc_i_data_15_1_itm_4, (else_if_ac_int_cctor_16_10_sva[6]),
          IntShiftRight_33U_5U_17U_obits_fixed_IntShiftRight_33U_5U_17U_obits_fixed_nor_2_seb_sva,
          {asn_56 , nor_17_cse , nor_tmp_11});
      chn_data_out_rsci_d_17 <= MUX1HOT_s_1_3_2(i_data_slc_i_data_15_1_itm_4, (IntShiftRight_25U_5U_9U_1_obits_fixed_acc_sat_sva[25]),
          IntShiftRight_33U_5U_17U_obits_fixed_IntShiftRight_33U_5U_17U_obits_fixed_nor_2_seb_sva,
          {asn_56 , nor_17_cse , nor_tmp_11});
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_chn_data_out_rsci_ld_core_psct_cse <= 1'b0;
    end
    else if ( core_wen & (and_dcpl_18 | and_dcpl_19) ) begin
      reg_chn_data_out_rsci_ld_core_psct_cse <= ~ and_dcpl_19;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      main_stage_v_1 <= 1'b0;
    end
    else if ( core_wen & (or_tmp_80 | main_stage_v_1_mx0c1) ) begin
      main_stage_v_1 <= ~ main_stage_v_1_mx0c1;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      io_read_cfg_precision_rsc_svs_st_3 <= 2'b0;
    end
    else if ( core_wen & (~ and_dcpl_16) & (mux_4_nl) ) begin
      io_read_cfg_precision_rsc_svs_st_3 <= cfg_precision_rsci_d;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      main_stage_v_2 <= 1'b0;
    end
    else if ( core_wen & ((or_3_cse & main_stage_v_1) | main_stage_v_2_mx0c1) ) begin
      main_stage_v_2 <= ~ main_stage_v_2_mx0c1;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_cfg_truncate_1_itm <= 1'b0;
    end
    else if ( (mux_48_nl) & and_dcpl_50 & or_3_cse ) begin
      reg_cfg_truncate_1_itm <= reg_cfg_truncate_1_1_itm;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_cfg_truncate_1_2_itm <= 4'b0;
    end
    else if ( and_dcpl_50 & or_3_cse ) begin
      reg_cfg_truncate_1_2_itm <= reg_cfg_truncate_1_3_itm;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      IntMulExt_9U_16U_25U_o_mul_itm_2 <= 24'b0;
    end
    else if ( core_wen & (~ and_dcpl_16) & (mux_9_nl) ) begin
      IntMulExt_9U_16U_25U_o_mul_itm_2 <= z_out[23:0];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_IntMulExt_17U_16U_33U_o_mul_itm <= 8'b0;
    end
    else if ( and_dcpl_50 & (io_read_cfg_precision_rsc_svs_st_3[0]) & or_3_cse )
        begin
      reg_IntMulExt_17U_16U_33U_o_mul_itm <= IntMulExt_17U_16U_33U_o_mux1h_1_itm[31:24];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_IntMulExt_17U_16U_33U_o_mul_1_itm <= 24'b0;
    end
    else if ( ((io_read_cfg_precision_rsc_svs_st_3[0]) | (~ or_66_cse)) & and_dcpl_50
        & or_3_cse ) begin
      reg_IntMulExt_17U_16U_33U_o_mul_1_itm <= IntMulExt_17U_16U_33U_o_mux1h_1_itm[23:0];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      i_data_slc_i_data_15_1_itm_4 <= 1'b0;
      FpExpoWidthInc_5U_6U_10U_1U_1U_o_expo_5_4_lpi_1_dfm_6_1_1 <= 1'b0;
      FpExpoWidthInc_5U_6U_10U_1U_1U_o_expo_5_4_lpi_1_dfm_6_0_1 <= 1'b0;
      reg_FpExpoWidthInc_5U_6U_10U_1U_1U_o_mant_lpi_1_dfm_6_tmp <= 1'b0;
      reg_FpExpoWidthInc_5U_6U_10U_1U_1U_o_mant_lpi_1_dfm_6_tmp_1 <= 9'b0;
    end
    else if ( i_data_and_cse ) begin
      i_data_slc_i_data_15_1_itm_4 <= i_data_slc_i_data_15_1_itm_3;
      FpExpoWidthInc_5U_6U_10U_1U_1U_o_expo_5_4_lpi_1_dfm_6_1_1 <= FpExpoWidthInc_5U_6U_10U_1U_1U_o_expo_5_4_lpi_1_dfm_5_1_1;
      FpExpoWidthInc_5U_6U_10U_1U_1U_o_expo_5_4_lpi_1_dfm_6_0_1 <= FpExpoWidthInc_5U_6U_10U_1U_1U_o_expo_5_4_lpi_1_dfm_5_0_1;
      reg_FpExpoWidthInc_5U_6U_10U_1U_1U_o_mant_lpi_1_dfm_6_tmp <= reg_IntSubExt_16U_16U_17U_o_acc_1_itm;
      reg_FpExpoWidthInc_5U_6U_10U_1U_1U_o_mant_lpi_1_dfm_6_tmp_1 <= reg_IntSubExt_16U_16U_17U_o_acc_2_itm;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      nor_tmp_11 <= 1'b0;
      io_read_cfg_precision_rsc_svs_st_4 <= 2'b0;
    end
    else if ( and_137_cse ) begin
      nor_tmp_11 <= io_read_cfg_precision_rsc_svs_st_3[0];
      io_read_cfg_precision_rsc_svs_st_4 <= io_read_cfg_precision_rsc_svs_st_3;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthInc_5U_6U_10U_1U_1U_o_expo_5_4_lpi_1_dfm_5_1_1 <= 1'b0;
      FpExpoWidthInc_5U_6U_10U_1U_1U_o_expo_5_4_lpi_1_dfm_5_0_1 <= 1'b0;
      i_data_slc_i_data_15_1_itm_3 <= 1'b0;
    end
    else if ( FpExpoWidthInc_5U_6U_10U_1U_1U_o_expo_and_2_cse ) begin
      FpExpoWidthInc_5U_6U_10U_1U_1U_o_expo_5_4_lpi_1_dfm_5_1_1 <= chn_data_in_rsci_d_mxwt[14];
      FpExpoWidthInc_5U_6U_10U_1U_1U_o_expo_5_4_lpi_1_dfm_5_0_1 <= (FpExpoWidthInc_5U_6U_10U_1U_1U_if_1_mux_2_nl)
          | IsInf_5U_10U_land_lpi_1_dfm | IsNaN_5U_10U_land_lpi_1_dfm;
      i_data_slc_i_data_15_1_itm_3 <= chn_data_in_rsci_d_mxwt[15];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_cfg_truncate_1_1_itm <= 1'b0;
    end
    else if ( or_3_cse & core_wen & or_78_cse_1 & chn_data_in_rsci_bawt ) begin
      reg_cfg_truncate_1_1_itm <= cfg_truncate_mux1h_3_itm[4];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_cfg_truncate_1_3_itm <= 4'b0;
      reg_IntSubExt_16U_16U_17U_o_acc_2_itm <= 9'b0;
    end
    else if ( and_144_cse ) begin
      reg_cfg_truncate_1_3_itm <= cfg_truncate_mux1h_3_itm[3:0];
      reg_IntSubExt_16U_16U_17U_o_acc_2_itm <= IntSubExt_16U_16U_17U_o_mux1h_1_itm[8:0];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      cfg_mul_in_1_sva_2 <= 16'b0;
    end
    else if ( core_wen & (~ and_dcpl_16) & (mux_36_nl) ) begin
      cfg_mul_in_1_sva_2 <= cfg_mul_in_rsci_d;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      IntSubExt_8U_8U_9U_o_acc_itm_2 <= 9'b0;
    end
    else if ( core_wen & (~ and_dcpl_16) & (mux_38_nl) ) begin
      IntSubExt_8U_8U_9U_o_acc_itm_2 <= z_out_1[8:0];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_IntSubExt_16U_16U_17U_o_acc_itm <= 7'b0;
    end
    else if ( or_3_cse & core_wen & chn_data_in_rsci_bawt & (cfg_precision_rsci_d[0])
        ) begin
      reg_IntSubExt_16U_16U_17U_o_acc_itm <= IntSubExt_16U_16U_17U_o_mux1h_1_itm[16:10];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_IntSubExt_16U_16U_17U_o_acc_1_itm <= 1'b0;
    end
    else if ( or_3_cse & core_wen & or_42_cse & chn_data_in_rsci_bawt ) begin
      reg_IntSubExt_16U_16U_17U_o_acc_1_itm <= IntSubExt_16U_16U_17U_o_mux1h_1_itm[9];
    end
  end
  assign IntShiftRight_25U_5U_9U_obits_fixed_IntShiftRight_25U_5U_9U_obits_fixed_nor_1_nl
      = ~((~((IntShiftRight_25U_5U_9U_obits_fixed_acc_sat_sva[0]) | IntShiftRight_25U_5U_9U_obits_fixed_nor_ovfl_sva))
      | IntShiftRight_25U_5U_9U_obits_fixed_and_unfl_sva);
  assign IntShiftRight_33U_5U_17U_obits_fixed_IntShiftRight_33U_5U_17U_obits_fixed_nor_1_nl
      = ~((~((IntShiftRight_33U_5U_17U_obits_fixed_acc_sat_sva[0]) | IntShiftRight_33U_5U_17U_obits_fixed_nor_ovfl_sva))
      | IntShiftRight_33U_5U_17U_obits_fixed_and_unfl_sva);
  assign IntShiftRight_25U_5U_9U_obits_fixed_nor_2_nl = ~(MUX_v_7_2_2((IntShiftRight_25U_5U_9U_obits_fixed_acc_sat_sva[7:1]),
      7'b1111111, IntShiftRight_25U_5U_9U_obits_fixed_nor_ovfl_sva));
  assign IntShiftRight_25U_5U_9U_obits_fixed_IntShiftRight_25U_5U_9U_obits_fixed_nor_nl
      = ~(MUX_v_7_2_2((IntShiftRight_25U_5U_9U_obits_fixed_nor_2_nl), 7'b1111111,
      IntShiftRight_25U_5U_9U_obits_fixed_and_unfl_sva));
  assign IntShiftRight_25U_5U_9U_1_obits_fixed_IntShiftRight_25U_5U_9U_1_obits_fixed_nor_1_nl
      = ~((~((IntShiftRight_25U_5U_9U_1_obits_fixed_acc_sat_sva[0]) | IntShiftRight_25U_5U_9U_1_obits_fixed_nor_ovfl_sva))
      | IntShiftRight_25U_5U_9U_1_obits_fixed_and_unfl_sva);
  assign or_2_nl = chn_data_in_rsci_bawt | (~ or_3_cse);
  assign mux_4_nl = MUX_s_1_2_2(main_stage_en_1, (or_2_nl), main_stage_v_1);
  assign or_127_nl = (io_read_cfg_precision_rsc_svs_st_3!=2'b10);
  assign mux_48_nl = MUX_s_1_2_2((or_127_nl), (io_read_cfg_precision_rsc_svs_st_3[0]),
      or_66_cse);
  assign nor_24_nl = ~((~ main_stage_v_2) | (io_read_cfg_precision_rsc_svs_st_4!=2'b00));
  assign mux_9_nl = MUX_s_1_2_2((nor_24_nl), nor_23_cse, or_3_cse);
  assign FpExpoWidthInc_5U_6U_10U_1U_1U_FpExpoWidthInc_5U_6U_10U_1U_1U_FpExpoWidthInc_5U_6U_10U_1U_1U_nor_nl
      = ~((chn_data_in_rsci_d_mxwt[14]) | (~((chn_data_in_rsci_d_mxwt[9:0]!=10'b0000000000)
      | (~ IsZero_5U_10U_IsZero_5U_10U_nor_cse_sva))));
  assign FpExpoWidthInc_5U_6U_10U_1U_1U_if_1_mux_2_nl = MUX_s_1_2_2((FpExpoWidthInc_5U_6U_10U_1U_1U_FpExpoWidthInc_5U_6U_10U_1U_1U_FpExpoWidthInc_5U_6U_10U_1U_1U_nor_nl),
      (FpExpoWidthInc_5U_6U_10U_1U_1U_if_1_if_acc_psp_sva[4]), IsDenorm_5U_10U_land_lpi_1_dfm);
  assign or_38_nl = main_stage_v_1 | (~ reg_chn_data_out_rsci_ld_core_psct_cse) |
      chn_data_out_rsci_bawt;
  assign or_39_nl = (~((io_read_cfg_precision_rsc_svs_st_3[1]) | (~ main_stage_v_1)))
      | (~ reg_chn_data_out_rsci_ld_core_psct_cse) | chn_data_out_rsci_bawt;
  assign mux_33_nl = MUX_s_1_2_2((or_39_nl), (or_38_nl), io_read_cfg_precision_rsc_svs_st_3[0]);
  assign mux_35_nl = MUX_s_1_2_2(not_tmp_22, (mux_33_nl), or_78_cse_1);
  assign mux_36_nl = MUX_s_1_2_2(not_tmp_22, (mux_35_nl), chn_data_in_rsci_bawt);
  assign nor_19_nl = ~((io_read_cfg_precision_rsc_svs_st_3!=2'b00) | (~ main_stage_v_1)
      | chn_data_out_rsci_bawt | (~ reg_chn_data_out_rsci_ld_core_psct_cse));
  assign mux_28_nl = MUX_s_1_2_2((~ or_tmp_35), or_107_cse, chn_data_in_rsci_bawt);
  assign mux_37_nl = MUX_s_1_2_2(main_stage_en_1, (mux_28_nl), nor_23_cse);
  assign mux_38_nl = MUX_s_1_2_2((mux_37_nl), (nor_19_nl), or_42_cse);
  assign IntMulExt_17U_16U_33U_o_and_1_nl = (fsm_output[1]) & (io_read_cfg_precision_rsc_svs_st_3[0]);
  assign IntMulExt_9U_16U_25U_o_mux_2_nl = MUX_v_17_2_2(({{8{IntSubExt_8U_8U_9U_o_acc_itm_2[8]}},
      IntSubExt_8U_8U_9U_o_acc_itm_2}), ({reg_IntSubExt_16U_16U_17U_o_acc_itm , reg_IntSubExt_16U_16U_17U_o_acc_1_itm
      , reg_IntSubExt_16U_16U_17U_o_acc_2_itm}), IntMulExt_17U_16U_33U_o_and_1_nl);
  assign nl_z_out = $signed(cfg_mul_in_1_sva_2) * $signed((IntMulExt_9U_16U_25U_o_mux_2_nl));
  assign z_out = nl_z_out[31:0];
  assign IntSubExt_8U_8U_9U_o_mux_4_nl = MUX_v_8_2_2((signext_8_1(chn_data_in_rsci_d_mxwt[7])),
      (chn_data_in_rsci_d_mxwt[15:8]), IntSubExt_16U_16U_17U_o_and_tmp);
  assign IntSubExt_8U_8U_9U_o_mux_5_nl = MUX_v_16_2_2((signext_16_8(~ (cfg_alu_in_rsci_d[7:0]))),
      (~ cfg_alu_in_rsci_d), IntSubExt_16U_16U_17U_o_and_tmp);
  assign nl_acc_nl = conv_s2u_17_18({(IntSubExt_8U_8U_9U_o_mux_4_nl) , (chn_data_in_rsci_d_mxwt[7:0])
      , 1'b1}) + conv_s2u_17_18({(IntSubExt_8U_8U_9U_o_mux_5_nl) , 1'b1});
  assign acc_nl = nl_acc_nl[17:0];
  assign z_out_1 = readslicef_18_17_1((acc_nl));

  function [0:0] MUX1HOT_s_1_1_2;
    input [0:0] input_0;
    input [0:0] sel;
    reg [0:0] result;
  begin
    result = input_0 & {1{sel[0]}};
    MUX1HOT_s_1_1_2 = result;
  end
  endfunction


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


  function [16:0] MUX1HOT_v_17_3_2;
    input [16:0] input_2;
    input [16:0] input_1;
    input [16:0] input_0;
    input [2:0] sel;
    reg [16:0] result;
  begin
    result = input_0 & {17{sel[0]}};
    result = result | ( input_1 & {17{sel[1]}});
    result = result | ( input_2 & {17{sel[2]}});
    MUX1HOT_v_17_3_2 = result;
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


  function [6:0] MUX1HOT_v_7_3_2;
    input [6:0] input_2;
    input [6:0] input_1;
    input [6:0] input_0;
    input [2:0] sel;
    reg [6:0] result;
  begin
    result = input_0 & {7{sel[0]}};
    result = result | ( input_1 & {7{sel[1]}});
    result = result | ( input_2 & {7{sel[2]}});
    MUX1HOT_v_7_3_2 = result;
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


  function [14:0] MUX_v_15_2_2;
    input [14:0] input_0;
    input [14:0] input_1;
    input [0:0] sel;
    reg [14:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_15_2_2 = result;
  end
  endfunction


  function [15:0] MUX_v_16_2_2;
    input [15:0] input_0;
    input [15:0] input_1;
    input [0:0] sel;
    reg [15:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_16_2_2 = result;
  end
  endfunction


  function [16:0] MUX_v_17_2_2;
    input [16:0] input_0;
    input [16:0] input_1;
    input [0:0] sel;
    reg [16:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_17_2_2 = result;
  end
  endfunction


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


  function [6:0] MUX_v_7_2_2;
    input [6:0] input_0;
    input [6:0] input_1;
    input [0:0] sel;
    reg [6:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_7_2_2 = result;
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


  function [16:0] readslicef_18_17_1;
    input [17:0] vector;
    reg [17:0] tmp;
  begin
    tmp = vector >> 1;
    readslicef_18_17_1 = tmp[16:0];
  end
  endfunction


  function [15:0] signext_16_8;
    input [7:0] vector;
  begin
    signext_16_8= {{8{vector[7]}}, vector};
  end
  endfunction


  function [55:0] signext_56_55;
    input [54:0] vector;
  begin
    signext_56_55= {{1{vector[54]}}, vector};
  end
  endfunction


  function [63:0] signext_64_63;
    input [62:0] vector;
  begin
    signext_64_63= {{1{vector[62]}}, vector};
  end
  endfunction


  function [7:0] signext_8_1;
    input [0:0] vector;
  begin
    signext_8_1= {{7{vector[0]}}, vector};
  end
  endfunction


  function  [25:0] conv_s2s_25_26 ;
    input [24:0]  vector ;
  begin
    conv_s2s_25_26 = {vector[24], vector};
  end
  endfunction


  function  [33:0] conv_s2s_33_34 ;
    input [32:0]  vector ;
  begin
    conv_s2s_33_34 = {vector[32], vector};
  end
  endfunction


  function  [8:0] conv_s2u_8_9 ;
    input [7:0]  vector ;
  begin
    conv_s2u_8_9 = {vector[7], vector};
  end
  endfunction


  function  [17:0] conv_s2u_17_18 ;
    input [16:0]  vector ;
  begin
    conv_s2u_17_18 = {vector[16], vector};
  end
  endfunction


  function  [25:0] conv_u2s_1_26 ;
    input [0:0]  vector ;
  begin
    conv_u2s_1_26 = {{25{1'b0}}, vector};
  end
  endfunction


  function  [33:0] conv_u2s_1_34 ;
    input [0:0]  vector ;
  begin
    conv_u2s_1_34 = {{33{1'b0}}, vector};
  end
  endfunction


  function  [4:0] conv_u2u_4_5 ;
    input [3:0]  vector ;
  begin
    conv_u2u_4_5 = {1'b0, vector};
  end
  endfunction

endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_cdp_icvt
// ------------------------------------------------------------------


module HLS_cdp_icvt (
  nvdla_core_clk, nvdla_core_rstn, chn_data_in_rsc_z, chn_data_in_rsc_vz, chn_data_in_rsc_lz,
      cfg_alu_in_rsc_z, cfg_mul_in_rsc_z, cfg_truncate_rsc_z, cfg_precision_rsc_z,
      chn_data_out_rsc_z, chn_data_out_rsc_vz, chn_data_out_rsc_lz
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [15:0] chn_data_in_rsc_z;
  input chn_data_in_rsc_vz;
  output chn_data_in_rsc_lz;
  input [15:0] cfg_alu_in_rsc_z;
  input [15:0] cfg_mul_in_rsc_z;
  input [4:0] cfg_truncate_rsc_z;
  input [1:0] cfg_precision_rsc_z;
  output [17:0] chn_data_out_rsc_z;
  input chn_data_out_rsc_vz;
  output chn_data_out_rsc_lz;


  // Interconnect Declarations
  wire chn_data_in_rsci_oswt;
  wire chn_data_in_rsci_oswt_unreg;
  wire chn_data_out_rsci_oswt;
  wire chn_data_out_rsci_oswt_unreg;


  // Interconnect Declarations for Component Instantiations 
  CDP_ICVT_chn_data_in_rsci_unreg chn_data_in_rsci_unreg_inst (
      .in_0(chn_data_in_rsci_oswt_unreg),
      .outsig(chn_data_in_rsci_oswt)
    );
  CDP_ICVT_chn_data_out_rsci_unreg chn_data_out_rsci_unreg_inst (
      .in_0(chn_data_out_rsci_oswt_unreg),
      .outsig(chn_data_out_rsci_oswt)
    );
  HLS_cdp_icvt_core HLS_cdp_icvt_core_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_data_in_rsc_z(chn_data_in_rsc_z),
      .chn_data_in_rsc_vz(chn_data_in_rsc_vz),
      .chn_data_in_rsc_lz(chn_data_in_rsc_lz),
      .cfg_alu_in_rsc_z(cfg_alu_in_rsc_z),
      .cfg_mul_in_rsc_z(cfg_mul_in_rsc_z),
      .cfg_truncate_rsc_z(cfg_truncate_rsc_z),
      .cfg_precision_rsc_z(cfg_precision_rsc_z),
      .chn_data_out_rsc_z(chn_data_out_rsc_z),
      .chn_data_out_rsc_vz(chn_data_out_rsc_vz),
      .chn_data_out_rsc_lz(chn_data_out_rsc_lz),
      .chn_data_in_rsci_oswt(chn_data_in_rsci_oswt),
      .chn_data_in_rsci_oswt_unreg(chn_data_in_rsci_oswt_unreg),
      .chn_data_out_rsci_oswt(chn_data_out_rsci_oswt),
      .chn_data_out_rsci_oswt_unreg(chn_data_out_rsci_oswt_unreg)
    );
endmodule



