// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_CVT_cell.v

module CDMA_mgc_in_wire_wait_v1 (ld, vd, d, lz, vz, z);

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


//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/siflibs/CDMA_mgc_out_stdreg_wait_v1.v 
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


module CDMA_mgc_out_stdreg_wait_v1 (ld, vd, d, lz, vz, z);

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



//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/siflibs/CDMA_mgc_in_wire_v1.v 
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


module CDMA_mgc_in_wire_v1 (d, z);

  parameter integer rscid = 1;
  parameter integer width = 8;

  output [width-1:0] d;
  input  [width-1:0] z;

  wire   [width-1:0] d;

  assign d = z;

endmodule


//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/hls_pkgs/mgc_comps_src/mgc_shift_r_beh_v2.v 
module CDMA_mgc_shift_r(a,s,z);
   parameter    width_a = 4;
   parameter    signd_a = 1;
   parameter    width_s = 2;
   parameter    width_z = 8;

   input [width_a-1:0] a;
   input [width_s-1:0] s;
   output [width_z -1:0] z;

   assign z = signd_a ? fshr_u(a,s,a[width_a-1]) : fshr_u(a,s,1'b0);

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

   //Shift right - signed shift argument
   function [width_z-1:0] fshr_s;
     input [width_a-1:0] arg1;
     input [width_s-1:0] arg2;
     input sbit;
     begin
       if ( arg2[width_s-1] == 1'b0 )
       begin
         fshr_s = fshr_u(arg1, arg2, sbit);
       end
       else
       begin
         fshr_s = fshl_u_1({arg1, 1'b0},~arg2, sbit);
       end
     end
   endfunction 

endmodule

//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/hls_pkgs/mgc_comps_src/mgc_shift_l_beh_v2.v 
module CDMA_mgc_shift_l(a,s,z);
   parameter    width_a = 4;
   parameter    signd_a = 1;
   parameter    width_s = 2;
   parameter    width_z = 8;

   input [width_a-1:0] a;
   input [width_s-1:0] s;
   output [width_z -1:0] z;

   assign z = signd_a ? fshl_u(a,s,a[width_a-1]) : fshl_u(a,s,1'b0);

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

   //Shift right - signed shift argument
   function [width_z-1:0] fshr_s;
     input [width_a-1:0] arg1;
     input [width_s-1:0] arg2;
     input sbit;
     begin
       if ( arg2[width_s-1] == 1'b0 )
       begin
         fshr_s = fshr_u(arg1, arg2, sbit);
       end
       else
       begin
         fshr_s = fshl_u_1({arg1, 1'b0},~arg2, sbit);
       end
     end
   endfunction 

endmodule

//------> ../td_ccore_solutions/leading_sign_17_0_41e60b6cae787099c94cb08258e79dd04a6f_0/rtl.v 
// ----------------------------------------------------------------------
//  HLS HDL:        Verilog Netlister
//  HLS Version:    10.0/264918 Production Release
//  HLS Date:       Mon Aug  8 13:35:54 PDT 2016
// 
//  Generated by:   ezhang@hk-sim-11-114
//  Generated date: Fri Apr 14 13:52:22 2017
// ----------------------------------------------------------------------

// 
// ------------------------------------------------------------------
//  Design Unit:    CDMA_leading_sign_17_0
// ------------------------------------------------------------------


module CDMA_leading_sign_17_0 (
  mantissa, rtn
);
  input [16:0] mantissa;
  output [4:0] rtn;


  // Interconnect Declarations
  wire IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_6_2_sdt_2;
  wire IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_18_3_sdt_3;
  wire IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_26_2_sdt_2;
  wire IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_42_4_sdt_4;
  wire IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_6_2_sdt_1;
  wire IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_14_2_sdt_1;
  wire IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_26_2_sdt_1;
  wire IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_34_2_sdt_1;
  wire c_h_1_2;
  wire c_h_1_5;
  wire c_h_1_6;
  wire c_h_1_7;

  wire[0:0] IntLeadZero_17U_leading_sign_17_0_rtn_and_63_nl;
  wire[0:0] IntLeadZero_17U_leading_sign_17_0_rtn_IntLeadZero_17U_leading_sign_17_0_rtn_nor_nl;
  wire[0:0] IntLeadZero_17U_leading_sign_17_0_rtn_IntLeadZero_17U_leading_sign_17_0_rtn_nor_10_nl;
  wire[0:0] IntLeadZero_17U_leading_sign_17_0_rtn_IntLeadZero_17U_leading_sign_17_0_rtn_or_nl;

  // Interconnect Declarations for Component Instantiations 
  assign IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_6_2_sdt_2 = ~((mantissa[14:13]!=2'b00));
  assign IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_6_2_sdt_1 = ~((mantissa[16:15]!=2'b00));
  assign IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_14_2_sdt_1 = ~((mantissa[12:11]!=2'b00));
  assign c_h_1_2 = IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_6_2_sdt_1 & IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_6_2_sdt_2;
  assign IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_18_3_sdt_3 = (mantissa[10:9]==2'b00)
      & IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_14_2_sdt_1;
  assign IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_26_2_sdt_2 = ~((mantissa[6:5]!=2'b00));
  assign IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_26_2_sdt_1 = ~((mantissa[8:7]!=2'b00));
  assign IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_34_2_sdt_1 = ~((mantissa[4:3]!=2'b00));
  assign c_h_1_5 = IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_26_2_sdt_1 & IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_26_2_sdt_2;
  assign c_h_1_6 = c_h_1_2 & IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_18_3_sdt_3;
  assign IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_42_4_sdt_4 = (mantissa[2:1]==2'b00)
      & IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_34_2_sdt_1 & c_h_1_5;
  assign c_h_1_7 = c_h_1_6 & IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_42_4_sdt_4;
  assign IntLeadZero_17U_leading_sign_17_0_rtn_and_63_nl = c_h_1_6 & (~ IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_42_4_sdt_4);
  assign IntLeadZero_17U_leading_sign_17_0_rtn_IntLeadZero_17U_leading_sign_17_0_rtn_nor_nl
      = ~((~(c_h_1_2 & (c_h_1_5 | (~ IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_18_3_sdt_3))))
      | c_h_1_7);
  assign IntLeadZero_17U_leading_sign_17_0_rtn_IntLeadZero_17U_leading_sign_17_0_rtn_nor_10_nl
      = ~((~(IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_6_2_sdt_1 & (IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_14_2_sdt_1
      | (~ IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_6_2_sdt_2)) & (~((~(IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_26_2_sdt_1
      & (IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_34_2_sdt_1 | (~ IntLeadZero_17U_leading_sign_17_0_rtn_wrs_c_26_2_sdt_2))))
      & c_h_1_6)))) | c_h_1_7);
  assign IntLeadZero_17U_leading_sign_17_0_rtn_IntLeadZero_17U_leading_sign_17_0_rtn_or_nl
      = (~((~((~((mantissa[16]) | (~((mantissa[15:14]!=2'b01))))) & (~(((mantissa[12])
      | (~((mantissa[11:10]!=2'b01)))) & c_h_1_2)) & (~((~((~((mantissa[8]) | (~((mantissa[7:6]!=2'b01)))))
      & (~(((mantissa[4]) | (~((mantissa[3:2]!=2'b01)))) & c_h_1_5)))) & c_h_1_6))))
      | c_h_1_7)) | ((~ (mantissa[0])) & c_h_1_7);
  assign rtn = {c_h_1_7 , (IntLeadZero_17U_leading_sign_17_0_rtn_and_63_nl) , (IntLeadZero_17U_leading_sign_17_0_rtn_IntLeadZero_17U_leading_sign_17_0_rtn_nor_nl)
      , (IntLeadZero_17U_leading_sign_17_0_rtn_IntLeadZero_17U_leading_sign_17_0_rtn_nor_10_nl)
      , (IntLeadZero_17U_leading_sign_17_0_rtn_IntLeadZero_17U_leading_sign_17_0_rtn_or_nl)};
endmodule




//------> ./rtl.v 
// ----------------------------------------------------------------------
//  HLS HDL:        Verilog Netlister
//  HLS Version:    10.0/264918 Production Release
//  HLS Date:       Mon Aug  8 13:35:54 PDT 2016
// 
//  Generated by:   ezhang@hk-sim-10-184
//  Generated date: Fri Jun 16 21:45:31 2017
// ----------------------------------------------------------------------

// 
// ------------------------------------------------------------------
//  Design Unit:    CDMA_chn_data_out_rsci_unreg
// ------------------------------------------------------------------


module CDMA_chn_data_out_rsci_unreg (
  in_0, outsig
);
  input in_0;
  output outsig;



  // Interconnect Declarations for Component Instantiations 
  assign outsig = in_0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    CDMA_chn_alu_in_rsci_unreg
// ------------------------------------------------------------------


module CDMA_chn_alu_in_rsci_unreg (
  in_0, outsig
);
  input in_0;
  output outsig;



  // Interconnect Declarations for Component Instantiations 
  assign outsig = in_0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    CDMA_chn_data_in_rsci_unreg
// ------------------------------------------------------------------


module CDMA_chn_data_in_rsci_unreg (
  in_0, outsig
);
  input in_0;
  output outsig;



  // Interconnect Declarations for Component Instantiations 
  assign outsig = in_0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    NV_NVDLA_CDMA_CVT_cell_core_core_fsm
//  FSM Module
// ------------------------------------------------------------------


module NV_NVDLA_CDMA_CVT_cell_core_core_fsm (
  nvdla_core_clk, nvdla_core_rstn, core_wen, fsm_output
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input core_wen;
  output [1:0] fsm_output;
  reg [1:0] fsm_output;


  // FSM State Type Declaration for NV_NVDLA_CDMA_CVT_cell_core_core_fsm_1
  parameter
    core_rlp_C_0 = 1'd0,
    main_C_0 = 1'd1;

  reg [0:0] state_var;
  reg [0:0] state_var_NS;


  // Interconnect Declarations for Component Instantiations 
  always @(*)
  begin : NV_NVDLA_CDMA_CVT_cell_core_core_fsm_1
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
//  Design Unit:    NV_NVDLA_CDMA_CVT_cell_core_staller
// ------------------------------------------------------------------


module NV_NVDLA_CDMA_CVT_cell_core_staller (
  nvdla_core_clk, nvdla_core_rstn, core_wen, chn_data_in_rsci_wen_comp, core_wten,
      chn_alu_in_rsci_wen_comp, chn_data_out_rsci_wen_comp
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  output core_wen;
  input chn_data_in_rsci_wen_comp;
  output core_wten;
  reg core_wten;
  input chn_alu_in_rsci_wen_comp;
  input chn_data_out_rsci_wen_comp;



  // Interconnect Declarations for Component Instantiations 
  assign core_wen = chn_data_in_rsci_wen_comp & chn_alu_in_rsci_wen_comp & chn_data_out_rsci_wen_comp;
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
//  Design Unit:    NV_NVDLA_CDMA_CVT_cell_core_chn_data_out_rsci_chn_data_out_wait_dp
// ------------------------------------------------------------------


module NV_NVDLA_CDMA_CVT_cell_core_chn_data_out_rsci_chn_data_out_wait_dp (
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
//  Design Unit:    NV_NVDLA_CDMA_CVT_cell_core_chn_data_out_rsci_chn_data_out_wait_ctrl
// ------------------------------------------------------------------


module NV_NVDLA_CDMA_CVT_cell_core_chn_data_out_rsci_chn_data_out_wait_ctrl (
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
//  Design Unit:    NV_NVDLA_CDMA_CVT_cell_core_chn_alu_in_rsci_chn_alu_in_wait_dp
// ------------------------------------------------------------------


module NV_NVDLA_CDMA_CVT_cell_core_chn_alu_in_rsci_chn_alu_in_wait_dp (
  nvdla_core_clk, nvdla_core_rstn, chn_alu_in_rsci_oswt, chn_alu_in_rsci_bawt, chn_alu_in_rsci_wen_comp,
      chn_alu_in_rsci_d_mxwt, chn_alu_in_rsci_biwt, chn_alu_in_rsci_bdwt, chn_alu_in_rsci_d
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input chn_alu_in_rsci_oswt;
  output chn_alu_in_rsci_bawt;
  output chn_alu_in_rsci_wen_comp;
  output [15:0] chn_alu_in_rsci_d_mxwt;
  input chn_alu_in_rsci_biwt;
  input chn_alu_in_rsci_bdwt;
  input [15:0] chn_alu_in_rsci_d;


  // Interconnect Declarations
  reg chn_alu_in_rsci_bcwt;
  reg [15:0] chn_alu_in_rsci_d_bfwt;


  // Interconnect Declarations for Component Instantiations 
  assign chn_alu_in_rsci_bawt = chn_alu_in_rsci_biwt | chn_alu_in_rsci_bcwt;
  assign chn_alu_in_rsci_wen_comp = (~ chn_alu_in_rsci_oswt) | chn_alu_in_rsci_bawt;
  assign chn_alu_in_rsci_d_mxwt = MUX_v_16_2_2(chn_alu_in_rsci_d, chn_alu_in_rsci_d_bfwt,
      chn_alu_in_rsci_bcwt);
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_alu_in_rsci_bcwt <= 1'b0;
      chn_alu_in_rsci_d_bfwt <= 16'b0;
    end
    else begin
      chn_alu_in_rsci_bcwt <= ~((~(chn_alu_in_rsci_bcwt | chn_alu_in_rsci_biwt))
          | chn_alu_in_rsci_bdwt);
      chn_alu_in_rsci_d_bfwt <= chn_alu_in_rsci_d_mxwt;
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
//  Design Unit:    NV_NVDLA_CDMA_CVT_cell_core_chn_alu_in_rsci_chn_alu_in_wait_ctrl
// ------------------------------------------------------------------


module NV_NVDLA_CDMA_CVT_cell_core_chn_alu_in_rsci_chn_alu_in_wait_ctrl (
  nvdla_core_clk, nvdla_core_rstn, chn_alu_in_rsci_oswt, core_wen, core_wten, chn_alu_in_rsci_iswt0,
      chn_alu_in_rsci_ld_core_psct, chn_alu_in_rsci_biwt, chn_alu_in_rsci_bdwt, chn_alu_in_rsci_ld_core_sct,
      chn_alu_in_rsci_vd
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input chn_alu_in_rsci_oswt;
  input core_wen;
  input core_wten;
  input chn_alu_in_rsci_iswt0;
  input chn_alu_in_rsci_ld_core_psct;
  output chn_alu_in_rsci_biwt;
  output chn_alu_in_rsci_bdwt;
  output chn_alu_in_rsci_ld_core_sct;
  input chn_alu_in_rsci_vd;


  // Interconnect Declarations
  wire chn_alu_in_rsci_ogwt;
  wire chn_alu_in_rsci_pdswt0;
  reg chn_alu_in_rsci_icwt;


  // Interconnect Declarations for Component Instantiations 
  assign chn_alu_in_rsci_pdswt0 = (~ core_wten) & chn_alu_in_rsci_iswt0;
  assign chn_alu_in_rsci_biwt = chn_alu_in_rsci_ogwt & chn_alu_in_rsci_vd;
  assign chn_alu_in_rsci_ogwt = chn_alu_in_rsci_pdswt0 | chn_alu_in_rsci_icwt;
  assign chn_alu_in_rsci_bdwt = chn_alu_in_rsci_oswt & core_wen;
  assign chn_alu_in_rsci_ld_core_sct = chn_alu_in_rsci_ld_core_psct & chn_alu_in_rsci_ogwt;
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_alu_in_rsci_icwt <= 1'b0;
    end
    else begin
      chn_alu_in_rsci_icwt <= ~((~(chn_alu_in_rsci_icwt | chn_alu_in_rsci_pdswt0))
          | chn_alu_in_rsci_biwt);
    end
  end
endmodule

// ------------------------------------------------------------------
//  Design Unit:    NV_NVDLA_CDMA_CVT_cell_core_chn_data_in_rsci_chn_data_in_wait_dp
// ------------------------------------------------------------------


module NV_NVDLA_CDMA_CVT_cell_core_chn_data_in_rsci_chn_data_in_wait_dp (
  nvdla_core_clk, nvdla_core_rstn, chn_data_in_rsci_oswt, chn_data_in_rsci_bawt,
      chn_data_in_rsci_wen_comp, chn_data_in_rsci_d_mxwt, chn_data_in_rsci_biwt,
      chn_data_in_rsci_bdwt, chn_data_in_rsci_d
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input chn_data_in_rsci_oswt;
  output chn_data_in_rsci_bawt;
  output chn_data_in_rsci_wen_comp;
  output [16:0] chn_data_in_rsci_d_mxwt;
  input chn_data_in_rsci_biwt;
  input chn_data_in_rsci_bdwt;
  input [16:0] chn_data_in_rsci_d;


  // Interconnect Declarations
  reg chn_data_in_rsci_bcwt;
  reg [16:0] chn_data_in_rsci_d_bfwt;


  // Interconnect Declarations for Component Instantiations 
  assign chn_data_in_rsci_bawt = chn_data_in_rsci_biwt | chn_data_in_rsci_bcwt;
  assign chn_data_in_rsci_wen_comp = (~ chn_data_in_rsci_oswt) | chn_data_in_rsci_bawt;
  assign chn_data_in_rsci_d_mxwt = MUX_v_17_2_2(chn_data_in_rsci_d, chn_data_in_rsci_d_bfwt,
      chn_data_in_rsci_bcwt);
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_data_in_rsci_bcwt <= 1'b0;
      chn_data_in_rsci_d_bfwt <= 17'b0;
    end
    else begin
      chn_data_in_rsci_bcwt <= ~((~(chn_data_in_rsci_bcwt | chn_data_in_rsci_biwt))
          | chn_data_in_rsci_bdwt);
      chn_data_in_rsci_d_bfwt <= chn_data_in_rsci_d_mxwt;
    end
  end

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

endmodule

// ------------------------------------------------------------------
//  Design Unit:    NV_NVDLA_CDMA_CVT_cell_core_chn_data_in_rsci_chn_data_in_wait_ctrl
// ------------------------------------------------------------------


module NV_NVDLA_CDMA_CVT_cell_core_chn_data_in_rsci_chn_data_in_wait_ctrl (
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
//  Design Unit:    NV_NVDLA_CDMA_CVT_cell_core_chn_data_out_rsci
// ------------------------------------------------------------------


module NV_NVDLA_CDMA_CVT_cell_core_chn_data_out_rsci (
  nvdla_core_clk, nvdla_core_rstn, chn_data_out_rsc_z, chn_data_out_rsc_vz, chn_data_out_rsc_lz,
      chn_data_out_rsci_oswt, core_wen, core_wten, chn_data_out_rsci_iswt0, chn_data_out_rsci_bawt,
      chn_data_out_rsci_wen_comp, chn_data_out_rsci_ld_core_psct, chn_data_out_rsci_d
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  output [15:0] chn_data_out_rsc_z;
  input chn_data_out_rsc_vz;
  output chn_data_out_rsc_lz;
  input chn_data_out_rsci_oswt;
  input core_wen;
  input core_wten;
  input chn_data_out_rsci_iswt0;
  output chn_data_out_rsci_bawt;
  output chn_data_out_rsci_wen_comp;
  input chn_data_out_rsci_ld_core_psct;
  input [15:0] chn_data_out_rsci_d;


  // Interconnect Declarations
  wire chn_data_out_rsci_biwt;
  wire chn_data_out_rsci_bdwt;
  wire chn_data_out_rsci_ld_core_sct;
  wire chn_data_out_rsci_vd;


  // Interconnect Declarations for Component Instantiations 
  CDMA_mgc_out_stdreg_wait_v1 #(.rscid(32'sd7),
  .width(32'sd16)) chn_data_out_rsci (
      .ld(chn_data_out_rsci_ld_core_sct),
      .vd(chn_data_out_rsci_vd),
      .d(chn_data_out_rsci_d),
      .lz(chn_data_out_rsc_lz),
      .vz(chn_data_out_rsc_vz),
      .z(chn_data_out_rsc_z)
    );
  NV_NVDLA_CDMA_CVT_cell_core_chn_data_out_rsci_chn_data_out_wait_ctrl NV_NVDLA_CDMA_CVT_cell_core_chn_data_out_rsci_chn_data_out_wait_ctrl_inst
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
  NV_NVDLA_CDMA_CVT_cell_core_chn_data_out_rsci_chn_data_out_wait_dp NV_NVDLA_CDMA_CVT_cell_core_chn_data_out_rsci_chn_data_out_wait_dp_inst
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
//  Design Unit:    NV_NVDLA_CDMA_CVT_cell_core_chn_alu_in_rsci
// ------------------------------------------------------------------


module NV_NVDLA_CDMA_CVT_cell_core_chn_alu_in_rsci (
  nvdla_core_clk, nvdla_core_rstn, chn_alu_in_rsc_z, chn_alu_in_rsc_vz, chn_alu_in_rsc_lz,
      chn_alu_in_rsci_oswt, core_wen, core_wten, chn_alu_in_rsci_iswt0, chn_alu_in_rsci_bawt,
      chn_alu_in_rsci_wen_comp, chn_alu_in_rsci_ld_core_psct, chn_alu_in_rsci_d_mxwt
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [15:0] chn_alu_in_rsc_z;
  input chn_alu_in_rsc_vz;
  output chn_alu_in_rsc_lz;
  input chn_alu_in_rsci_oswt;
  input core_wen;
  input core_wten;
  input chn_alu_in_rsci_iswt0;
  output chn_alu_in_rsci_bawt;
  output chn_alu_in_rsci_wen_comp;
  input chn_alu_in_rsci_ld_core_psct;
  output [15:0] chn_alu_in_rsci_d_mxwt;


  // Interconnect Declarations
  wire chn_alu_in_rsci_biwt;
  wire chn_alu_in_rsci_bdwt;
  wire chn_alu_in_rsci_ld_core_sct;
  wire chn_alu_in_rsci_vd;
  wire [15:0] chn_alu_in_rsci_d;


  // Interconnect Declarations for Component Instantiations 
  CDMA_mgc_in_wire_wait_v1 #(.rscid(32'sd2),
  .width(32'sd16)) chn_alu_in_rsci (
      .ld(chn_alu_in_rsci_ld_core_sct),
      .vd(chn_alu_in_rsci_vd),
      .d(chn_alu_in_rsci_d),
      .lz(chn_alu_in_rsc_lz),
      .vz(chn_alu_in_rsc_vz),
      .z(chn_alu_in_rsc_z)
    );
  NV_NVDLA_CDMA_CVT_cell_core_chn_alu_in_rsci_chn_alu_in_wait_ctrl NV_NVDLA_CDMA_CVT_cell_core_chn_alu_in_rsci_chn_alu_in_wait_ctrl_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_alu_in_rsci_oswt(chn_alu_in_rsci_oswt),
      .core_wen(core_wen),
      .core_wten(core_wten),
      .chn_alu_in_rsci_iswt0(chn_alu_in_rsci_iswt0),
      .chn_alu_in_rsci_ld_core_psct(chn_alu_in_rsci_ld_core_psct),
      .chn_alu_in_rsci_biwt(chn_alu_in_rsci_biwt),
      .chn_alu_in_rsci_bdwt(chn_alu_in_rsci_bdwt),
      .chn_alu_in_rsci_ld_core_sct(chn_alu_in_rsci_ld_core_sct),
      .chn_alu_in_rsci_vd(chn_alu_in_rsci_vd)
    );
  NV_NVDLA_CDMA_CVT_cell_core_chn_alu_in_rsci_chn_alu_in_wait_dp NV_NVDLA_CDMA_CVT_cell_core_chn_alu_in_rsci_chn_alu_in_wait_dp_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_alu_in_rsci_oswt(chn_alu_in_rsci_oswt),
      .chn_alu_in_rsci_bawt(chn_alu_in_rsci_bawt),
      .chn_alu_in_rsci_wen_comp(chn_alu_in_rsci_wen_comp),
      .chn_alu_in_rsci_d_mxwt(chn_alu_in_rsci_d_mxwt),
      .chn_alu_in_rsci_biwt(chn_alu_in_rsci_biwt),
      .chn_alu_in_rsci_bdwt(chn_alu_in_rsci_bdwt),
      .chn_alu_in_rsci_d(chn_alu_in_rsci_d)
    );
endmodule

// ------------------------------------------------------------------
//  Design Unit:    NV_NVDLA_CDMA_CVT_cell_core_chn_data_in_rsci
// ------------------------------------------------------------------


module NV_NVDLA_CDMA_CVT_cell_core_chn_data_in_rsci (
  nvdla_core_clk, nvdla_core_rstn, chn_data_in_rsc_z, chn_data_in_rsc_vz, chn_data_in_rsc_lz,
      chn_data_in_rsci_oswt, core_wen, chn_data_in_rsci_iswt0, chn_data_in_rsci_bawt,
      chn_data_in_rsci_wen_comp, chn_data_in_rsci_ld_core_psct, chn_data_in_rsci_d_mxwt,
      core_wten
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [16:0] chn_data_in_rsc_z;
  input chn_data_in_rsc_vz;
  output chn_data_in_rsc_lz;
  input chn_data_in_rsci_oswt;
  input core_wen;
  input chn_data_in_rsci_iswt0;
  output chn_data_in_rsci_bawt;
  output chn_data_in_rsci_wen_comp;
  input chn_data_in_rsci_ld_core_psct;
  output [16:0] chn_data_in_rsci_d_mxwt;
  input core_wten;


  // Interconnect Declarations
  wire chn_data_in_rsci_biwt;
  wire chn_data_in_rsci_bdwt;
  wire chn_data_in_rsci_ld_core_sct;
  wire chn_data_in_rsci_vd;
  wire [16:0] chn_data_in_rsci_d;


  // Interconnect Declarations for Component Instantiations 
  CDMA_mgc_in_wire_wait_v1 #(.rscid(32'sd1),
  .width(32'sd17)) chn_data_in_rsci (
      .ld(chn_data_in_rsci_ld_core_sct),
      .vd(chn_data_in_rsci_vd),
      .d(chn_data_in_rsci_d),
      .lz(chn_data_in_rsc_lz),
      .vz(chn_data_in_rsc_vz),
      .z(chn_data_in_rsc_z)
    );
  NV_NVDLA_CDMA_CVT_cell_core_chn_data_in_rsci_chn_data_in_wait_ctrl NV_NVDLA_CDMA_CVT_cell_core_chn_data_in_rsci_chn_data_in_wait_ctrl_inst
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
  NV_NVDLA_CDMA_CVT_cell_core_chn_data_in_rsci_chn_data_in_wait_dp NV_NVDLA_CDMA_CVT_cell_core_chn_data_in_rsci_chn_data_in_wait_dp_inst
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
//  Design Unit:    NV_NVDLA_CDMA_CVT_cell_core
// ------------------------------------------------------------------


module NV_NVDLA_CDMA_CVT_cell_core (
  nvdla_core_clk, nvdla_core_rstn, chn_data_in_rsc_z, chn_data_in_rsc_vz, chn_data_in_rsc_lz,
      chn_alu_in_rsc_z, chn_alu_in_rsc_vz, chn_alu_in_rsc_lz, cfg_mul_in_rsc_z, cfg_in_precision,
      cfg_out_precision, cfg_truncate, chn_data_out_rsc_z, chn_data_out_rsc_vz, chn_data_out_rsc_lz,
      chn_data_in_rsci_oswt, chn_alu_in_rsci_oswt, chn_data_out_rsci_oswt, chn_data_out_rsci_oswt_unreg,
      chn_data_in_rsci_oswt_unreg_pff
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [16:0] chn_data_in_rsc_z;
  input chn_data_in_rsc_vz;
  output chn_data_in_rsc_lz;
  input [15:0] chn_alu_in_rsc_z;
  input chn_alu_in_rsc_vz;
  output chn_alu_in_rsc_lz;
  input [15:0] cfg_mul_in_rsc_z;
  input [1:0] cfg_in_precision;
  input [1:0] cfg_out_precision;
  input [5:0] cfg_truncate;
  output [15:0] chn_data_out_rsc_z;
  input chn_data_out_rsc_vz;
  output chn_data_out_rsc_lz;
  input chn_data_in_rsci_oswt;
  input chn_alu_in_rsci_oswt;
  input chn_data_out_rsci_oswt;
  output chn_data_out_rsci_oswt_unreg;
  output chn_data_in_rsci_oswt_unreg_pff;


  // Interconnect Declarations
  wire core_wen;
  wire chn_data_in_rsci_bawt;
  wire chn_data_in_rsci_wen_comp;
  wire [16:0] chn_data_in_rsci_d_mxwt;
  wire core_wten;
  wire chn_alu_in_rsci_bawt;
  wire chn_alu_in_rsci_wen_comp;
  wire [15:0] chn_alu_in_rsci_d_mxwt;
  wire [15:0] cfg_mul_in_rsci_d;
  reg chn_data_out_rsci_iswt0;
  wire chn_data_out_rsci_bawt;
  wire chn_data_out_rsci_wen_comp;
  reg chn_data_out_rsci_d_15;
  reg [4:0] chn_data_out_rsci_d_14_10;
  reg [8:0] chn_data_out_rsci_d_9_1;
  reg chn_data_out_rsci_d_0;
  wire [1:0] fsm_output;
  wire FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_tmp;
  wire IntShiftRight_34U_6U_17U_obits_fixed_and_1_tmp;
  wire IntShiftRight_34U_6U_17U_obits_fixed_nor_tmp;
  wire [34:0] IntShiftRight_34U_6U_17U_obits_fixed_acc_tmp;
  wire [35:0] nl_IntShiftRight_34U_6U_17U_obits_fixed_acc_tmp;
  wire FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_nor_tmp;
  wire FpMantRNE_17U_11U_else_and_tmp;
  wire and_dcpl_1;
  wire and_dcpl_2;
  wire or_dcpl;
  wire and_dcpl_3;
  wire and_dcpl_5;
  wire and_dcpl_6;
  wire and_dcpl_8;
  wire mux_tmp_6;
  wire mux_tmp_7;
  wire or_tmp_11;
  wire mux_tmp_8;
  wire and_tmp_1;
  wire or_tmp_14;
  wire mux_tmp_19;
  wire and_dcpl_20;
  wire and_dcpl_22;
  wire and_dcpl_24;
  wire and_dcpl_25;
  wire and_dcpl_26;
  wire and_dcpl_33;
  wire and_dcpl_41;
  wire or_dcpl_20;
  wire and_dcpl_44;
  wire and_dcpl_45;
  wire and_dcpl_48;
  wire and_dcpl_49;
  wire and_dcpl_50;
  wire xor_dcpl_2;
  wire and_dcpl_58;
  wire or_dcpl_29;
  wire or_dcpl_30;
  wire or_tmp_29;
  wire or_tmp_35;
  reg [14:0] else_o_i17_15_1_sva;
  reg FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_svs;
  reg [14:0] FpIntToFloat_17U_5U_10U_else_i_abs_15_1_lpi_1_dfm;
  reg FpIntToFloat_17U_5U_10U_else_i_abs_0_lpi_1_dfm;
  reg FpMantRNE_17U_11U_else_and_svs;
  reg main_stage_v_1;
  reg main_stage_v_2;
  reg IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_2;
  reg else_o_i17_0_sva_2;
  reg else_o_i17_16_sva_2;
  reg [14:0] IntSaturation_17U_16U_o_15_1_lpi_1_dfm_5;
  reg [14:0] else_o_i17_15_1_sva_2;
  reg FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_svs_2;
  reg [14:0] FpIntToFloat_17U_5U_10U_else_i_abs_15_1_lpi_1_dfm_5;
  reg FpIntToFloat_17U_5U_10U_else_i_abs_0_lpi_1_dfm_5;
  reg [32:0] IntMulExt_18U_16U_34U_o_mul_itm;
  reg [32:0] IntMulExt_18U_16U_34U_o_mul_itm_2;
  reg FpIntToFloat_17U_5U_10U_else_if_slc_FpIntToFloat_17U_5U_10U_else_if_ac_int_cctor_16_itm;
  reg FpIntToFloat_17U_5U_10U_else_if_slc_FpIntToFloat_17U_5U_10U_else_if_ac_int_cctor_16_itm_2;
  reg IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_st;
  reg IntSaturation_17U_16U_IntSaturation_17U_16U_or_itm_2;
  reg IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_st_2;
  reg [15:0] i_data_sva_1_15_0_1;
  reg [15:0] i_data_sva_2_15_0_1;
  wire main_stage_en_1;
  wire else_nor_tmp;
  wire unequal_tmp;
  wire else_equal_tmp;
  wire else_nor_dfs;
  wire else_o_i17_16_sva_mx0w0;
  wire [14:0] else_o_i17_15_1_sva_mx0w0;
  reg reg_chn_alu_in_rsci_iswt0_cse;
  reg reg_chn_alu_in_rsci_ld_core_psct_cse;
  wire chn_data_out_and_1_cse;
  wire chn_data_out_and_cse;
  reg reg_chn_data_out_rsci_ld_core_psct_cse;
  wire FpIntToFloat_17U_5U_10U_else_i_abs_and_cse;
  wire or_cse;
  wire xnor_1_cse;
  wire nor_5_cse;
  wire nor_23_cse;
  wire mux_20_cse;
  wire else_else_and_1_cse;
  wire IntShiftRight_34U_6U_17U_obits_fixed_nor_4_cse;
  wire nand_11_cse;
  wire and_65_cse;
  wire [16:0] FpIntToFloat_17U_5U_10U_else_if_ac_int_cctor_sva;
  wire [17:0] nl_FpIntToFloat_17U_5U_10U_else_if_ac_int_cctor_sva;
  wire IntSaturation_17U_16U_o_IntSaturation_17U_16U_o_nor_rgt;
  wire IntSaturation_17U_16U_and_1_rgt;
  wire IntSaturation_17U_16U_o_and_1_rgt;
  wire and_84_rgt;
  wire mux_17_itm;
  wire mux_30_itm;
  wire IntSaturation_17U_8U_else_if_and_tmp;
  wire [10:0] z_out;
  wire [11:0] nl_z_out;
  wire NV_NVDLA_CDMA_CVT_cell_core_nvdla_int_h_ln333_assert_oWidth_ge_aWidth_p_bWidth_sig_mx0w1;
  wire main_stage_v_1_mx0c1;
  wire [32:0] IntMulExt_18U_16U_34U_o_mul_itm_mx0w0;
  wire signed [33:0] nl_IntMulExt_18U_16U_34U_o_mul_itm_mx0w0;
  wire main_stage_v_2_mx0c1;
  wire else_o_i17_0_sva_mx0w0;
  wire [96:0] IntShiftRight_34U_6U_17U_mbits_fixed_sva;
  wire [9:0] FpIntToFloat_17U_5U_10U_o_mant_lpi_1_dfm_1;
  wire [6:0] IntSaturation_17U_8U_o_7_1_lpi_1_dfm_1;
  wire FpMantRNE_17U_11U_else_carry_sva;
  wire [16:0] FpIntToFloat_17U_5U_10U_else_int_mant_sva;
  wire asn_21;
  wire asn_23;
  wire asn_25;
  wire FpIntToFloat_17U_5U_10U_else_i_abs_conc_3_16;
  wire [4:0] libraries_leading_sign_17_0_41e60b6cae787099c94cb08258e79dd04a6f_1;
  wire else_o_i17_and_cse;
  wire FpIntToFloat_17U_5U_10U_else_i_abs_and_2_cse;
  wire FpIntToFloat_17U_5U_10U_else_if_FpIntToFloat_17U_5U_10U_else_if_or_cse;
  wire IntMulExt_18U_16U_34U_o_IntMulExt_18U_16U_34U_o_or_cse;
  wire FpIntToFloat_17U_5U_10U_else_i_abs_and_4_cse;
  wire mux_32_itm;
  wire IntSaturation_17U_8U_if_acc_itm_10_1;
  wire IntSaturation_17U_16U_if_acc_itm_2_1;
  wire FpIntToFloat_17U_5U_10U_else_else_1_if_if_acc_1_itm_4_1;
  wire IntSaturation_17U_16U_else_if_acc_itm_2_1;

  wire[0:0] oWidth_mWidth_prb;
  wire[0:0] oWidth_aWidth_bWidth_prb;
  wire[0:0] oWidth_iWidth_prb;
  wire[0:0] or_28;
  wire[0:0] oWidth_iWidth_prb_1;
  wire[0:0] or_29;
  wire[0:0] else_mux1h_11_nl;
  wire[0:0] IntSaturation_17U_8U_IntSaturation_17U_8U_or_nl;
  wire[4:0] FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_and_2_nl;
  wire[4:0] FpIntToFloat_17U_5U_10U_else_FpIntToFloat_17U_5U_10U_else_FpIntToFloat_17U_5U_10U_else_mux_nl;
  wire[4:0] FpIntToFloat_17U_5U_10U_else_else_1_if_if_acc_nl;
  wire[5:0] nl_FpIntToFloat_17U_5U_10U_else_else_1_if_if_acc_nl;
  wire[0:0] FpIntToFloat_17U_5U_10U_else_and_2_nl;
  wire[0:0] FpIntToFloat_17U_5U_10U_if_not_12_nl;
  wire[0:0] and_134_nl;
  wire[0:0] and_135_nl;
  wire[0:0] else_mux1h_12_nl;
  wire[0:0] mux_27_nl;
  wire[0:0] mux_25_nl;
  wire[0:0] mux_26_nl;
  wire[0:0] mux_5_nl;
  wire[0:0] or_4_nl;
  wire[0:0] nor_nl;
  wire[0:0] mux_10_nl;
  wire[0:0] mux_9_nl;
  wire[0:0] mux_7_nl;
  wire[0:0] mux_8_nl;
  wire[0:0] and_43_nl;
  wire[17:0] IntSubExt_17U_16U_18U_o_acc_nl;
  wire[18:0] nl_IntSubExt_17U_16U_18U_o_acc_nl;
  wire[10:0] IntSaturation_17U_8U_if_acc_nl;
  wire[11:0] nl_IntSaturation_17U_8U_if_acc_nl;
  wire[14:0] IntShiftRight_34U_6U_17U_obits_fixed_nor_2_nl;
  wire[2:0] IntSaturation_17U_16U_if_acc_nl;
  wire[3:0] nl_IntSaturation_17U_16U_if_acc_nl;
  wire[0:0] IntShiftRight_34U_6U_17U_obits_fixed_and_nl;
  wire[9:0] FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_and_1_nl;
  wire[0:0] FpIntToFloat_17U_5U_10U_if_not_14_nl;
  wire[0:0] IntSaturation_17U_8U_IntSaturation_17U_8U_nor_nl;
  wire[0:0] IntSaturation_17U_8U_and_1_nl;
  wire[4:0] FpIntToFloat_17U_5U_10U_else_else_1_if_if_acc_1_nl;
  wire[5:0] nl_FpIntToFloat_17U_5U_10U_else_else_1_if_if_acc_1_nl;
  wire[0:0] FpMantRNE_17U_11U_else_mux_1_nl;
  wire[2:0] IntSaturation_17U_16U_else_if_acc_nl;
  wire[3:0] nl_IntSaturation_17U_16U_else_if_acc_nl;
  wire[0:0] nand_10_nl;
  wire[0:0] or_10_nl;
  wire[0:0] nor_22_nl;
  wire[0:0] nor_21_nl;
  wire[0:0] mux_16_nl;
  wire[0:0] mux_15_nl;
  wire[0:0] mux_14_nl;
  wire[0:0] nor_3_nl;
  wire[0:0] or_20_nl;
  wire[0:0] and_128_nl;
  wire[0:0] mux_23_nl;
  wire[0:0] or_22_nl;
  wire[0:0] mux_29_nl;
  wire[0:0] mux_28_nl;
  wire[0:0] nor_14_nl;
  wire[9:0] FpMantRNE_17U_11U_else_mux_2_nl;
  wire[0:0] FpMantRNE_17U_11U_else_or_1_nl;

  // Interconnect Declarations for Component Instantiations 
  wire [96:0] nl_IntShiftRight_34U_6U_17U_mbits_fixed_rshift_rg_a;
  assign nl_IntShiftRight_34U_6U_17U_mbits_fixed_rshift_rg_a = signext_97_96({IntMulExt_18U_16U_34U_o_mul_itm_2
      , 63'b0});
  wire [16:0] nl_FpIntToFloat_17U_5U_10U_else_int_mant_lshift_rg_a;
  assign nl_FpIntToFloat_17U_5U_10U_else_int_mant_lshift_rg_a = {FpIntToFloat_17U_5U_10U_else_i_abs_conc_3_16
      , FpIntToFloat_17U_5U_10U_else_i_abs_15_1_lpi_1_dfm_5 , FpIntToFloat_17U_5U_10U_else_i_abs_0_lpi_1_dfm_5};
  wire [16:0] nl_leading_sign_17_0_rg_mantissa;
  assign nl_leading_sign_17_0_rg_mantissa = {FpIntToFloat_17U_5U_10U_else_i_abs_conc_3_16
      , FpIntToFloat_17U_5U_10U_else_i_abs_15_1_lpi_1_dfm_5 , FpIntToFloat_17U_5U_10U_else_i_abs_0_lpi_1_dfm_5};
  wire [15:0] nl_NV_NVDLA_CDMA_CVT_cell_core_chn_data_out_rsci_inst_chn_data_out_rsci_d;
  assign nl_NV_NVDLA_CDMA_CVT_cell_core_chn_data_out_rsci_inst_chn_data_out_rsci_d
      = {chn_data_out_rsci_d_15 , chn_data_out_rsci_d_14_10 , chn_data_out_rsci_d_9_1
      , chn_data_out_rsci_d_0};
  CDMA_mgc_in_wire_v1 #(.rscid(32'sd3),
  .width(32'sd16)) cfg_mul_in_rsci (
      .d(cfg_mul_in_rsci_d),
      .z(cfg_mul_in_rsc_z)
    );
  CDMA_mgc_shift_r #(.width_a(32'sd97),
  .signd_a(32'sd1),
  .width_s(32'sd6),
  .width_z(32'sd97)) IntShiftRight_34U_6U_17U_mbits_fixed_rshift_rg (
      .a(nl_IntShiftRight_34U_6U_17U_mbits_fixed_rshift_rg_a[96:0]),
      .s(cfg_truncate),
      .z(IntShiftRight_34U_6U_17U_mbits_fixed_sva)
    );
  CDMA_mgc_shift_l #(.width_a(32'sd17),
  .signd_a(32'sd0),
  .width_s(32'sd5),
  .width_z(32'sd17)) FpIntToFloat_17U_5U_10U_else_int_mant_lshift_rg (
      .a(nl_FpIntToFloat_17U_5U_10U_else_int_mant_lshift_rg_a[16:0]),
      .s(libraries_leading_sign_17_0_41e60b6cae787099c94cb08258e79dd04a6f_1),
      .z(FpIntToFloat_17U_5U_10U_else_int_mant_sva)
    );
  CDMA_leading_sign_17_0  leading_sign_17_0_rg (
      .mantissa(nl_leading_sign_17_0_rg_mantissa[16:0]),
      .rtn(libraries_leading_sign_17_0_41e60b6cae787099c94cb08258e79dd04a6f_1)
    );
  NV_NVDLA_CDMA_CVT_cell_core_chn_data_in_rsci NV_NVDLA_CDMA_CVT_cell_core_chn_data_in_rsci_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_data_in_rsc_z(chn_data_in_rsc_z),
      .chn_data_in_rsc_vz(chn_data_in_rsc_vz),
      .chn_data_in_rsc_lz(chn_data_in_rsc_lz),
      .chn_data_in_rsci_oswt(chn_data_in_rsci_oswt),
      .core_wen(core_wen),
      .chn_data_in_rsci_iswt0(reg_chn_alu_in_rsci_iswt0_cse),
      .chn_data_in_rsci_bawt(chn_data_in_rsci_bawt),
      .chn_data_in_rsci_wen_comp(chn_data_in_rsci_wen_comp),
      .chn_data_in_rsci_ld_core_psct(reg_chn_alu_in_rsci_ld_core_psct_cse),
      .chn_data_in_rsci_d_mxwt(chn_data_in_rsci_d_mxwt),
      .core_wten(core_wten)
    );
  NV_NVDLA_CDMA_CVT_cell_core_chn_alu_in_rsci NV_NVDLA_CDMA_CVT_cell_core_chn_alu_in_rsci_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_alu_in_rsc_z(chn_alu_in_rsc_z),
      .chn_alu_in_rsc_vz(chn_alu_in_rsc_vz),
      .chn_alu_in_rsc_lz(chn_alu_in_rsc_lz),
      .chn_alu_in_rsci_oswt(chn_alu_in_rsci_oswt),
      .core_wen(core_wen),
      .core_wten(core_wten),
      .chn_alu_in_rsci_iswt0(reg_chn_alu_in_rsci_iswt0_cse),
      .chn_alu_in_rsci_bawt(chn_alu_in_rsci_bawt),
      .chn_alu_in_rsci_wen_comp(chn_alu_in_rsci_wen_comp),
      .chn_alu_in_rsci_ld_core_psct(reg_chn_alu_in_rsci_ld_core_psct_cse),
      .chn_alu_in_rsci_d_mxwt(chn_alu_in_rsci_d_mxwt)
    );
  NV_NVDLA_CDMA_CVT_cell_core_chn_data_out_rsci NV_NVDLA_CDMA_CVT_cell_core_chn_data_out_rsci_inst
      (
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
      .chn_data_out_rsci_d(nl_NV_NVDLA_CDMA_CVT_cell_core_chn_data_out_rsci_inst_chn_data_out_rsci_d[15:0])
    );
  NV_NVDLA_CDMA_CVT_cell_core_staller NV_NVDLA_CDMA_CVT_cell_core_staller_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .core_wen(core_wen),
      .chn_data_in_rsci_wen_comp(chn_data_in_rsci_wen_comp),
      .core_wten(core_wten),
      .chn_alu_in_rsci_wen_comp(chn_alu_in_rsci_wen_comp),
      .chn_data_out_rsci_wen_comp(chn_data_out_rsci_wen_comp)
    );
  NV_NVDLA_CDMA_CVT_cell_core_core_fsm NV_NVDLA_CDMA_CVT_cell_core_core_fsm_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .core_wen(core_wen),
      .fsm_output(fsm_output)
    );
  assign oWidth_mWidth_prb = NV_NVDLA_CDMA_CVT_cell_core_nvdla_int_h_ln333_assert_oWidth_ge_aWidth_p_bWidth_sig_mx0w1;
  // assert(oWidth > mWidth) - ../include/nvdla_int.h: line 274
  // PSL NV_NVDLA_CDMA_CVT_cell_core_nvdla_int_h_ln274_assert_oWidth_gt_mWidth : assert { oWidth_mWidth_prb } @rose(nvdla_core_clk);
  assign oWidth_aWidth_bWidth_prb = NV_NVDLA_CDMA_CVT_cell_core_nvdla_int_h_ln333_assert_oWidth_ge_aWidth_p_bWidth_sig_mx0w1;
  // assert(oWidth >= aWidth+bWidth) - ../include/nvdla_int.h: line 333
  // PSL NV_NVDLA_CDMA_CVT_cell_core_nvdla_int_h_ln333_assert_oWidth_ge_aWidth_p_bWidth : assert { oWidth_aWidth_bWidth_prb } @rose(nvdla_core_clk);
  assign or_28 = (and_dcpl_3 & and_dcpl_2 & (fsm_output[1])) | (and_dcpl_6 & and_dcpl_2);
  assign oWidth_iWidth_prb = MUX1HOT_s_1_1_2(1'b1, or_28);
  // assert(oWidth <= iWidth) - ../include/nvdla_int.h: line 438
  // PSL NV_NVDLA_CDMA_CVT_cell_core_nvdla_int_h_ln438_assert_oWidth_le_iWidth : assert { oWidth_iWidth_prb } @rose(nvdla_core_clk);
  assign or_29 = (and_dcpl_3 & and_dcpl_8 & (fsm_output[1])) | (and_dcpl_6 & and_dcpl_8);
  assign oWidth_iWidth_prb_1 = MUX1HOT_s_1_1_2(1'b1, or_29);
  // assert(oWidth <= iWidth) - ../include/nvdla_int.h: line 438
  // PSL NV_NVDLA_CDMA_CVT_cell_core_nvdla_int_h_ln438_assert_oWidth_le_iWidth_1 : assert { oWidth_iWidth_prb_1 } @rose(nvdla_core_clk);
  assign chn_data_out_and_cse = core_wen & ((and_dcpl_22 & or_dcpl) | and_dcpl_25);
  assign chn_data_out_and_1_cse = core_wen & (~(and_dcpl_20 | (~ main_stage_v_2)));
  assign IntMulExt_18U_16U_34U_o_IntMulExt_18U_16U_34U_o_or_cse = and_dcpl_3 | and_dcpl_33;
  assign and_65_cse = or_cse & main_stage_v_1;
  assign else_o_i17_and_cse = core_wen & (~ and_dcpl_20) & mux_tmp_7;
  assign IntSaturation_17U_16U_o_IntSaturation_17U_16U_o_nor_rgt = ~(IntSaturation_17U_16U_else_if_acc_itm_2_1
      | IntSaturation_17U_16U_if_acc_itm_2_1 | and_dcpl_20);
  assign IntSaturation_17U_16U_and_1_rgt = IntSaturation_17U_16U_else_if_acc_itm_2_1
      & (~ IntSaturation_17U_16U_if_acc_itm_2_1) & (~ and_dcpl_20);
  assign IntSaturation_17U_16U_o_and_1_rgt = IntSaturation_17U_16U_if_acc_itm_2_1
      & (~ and_dcpl_20);
  assign FpIntToFloat_17U_5U_10U_else_i_abs_and_2_cse = core_wen & (and_dcpl_45 |
      and_dcpl_49 | and_dcpl_50) & (~ mux_17_itm);
  assign FpIntToFloat_17U_5U_10U_else_if_FpIntToFloat_17U_5U_10U_else_if_or_cse =
      (and_dcpl_3 & else_else_and_1_cse) | and_dcpl_50;
  assign xnor_1_cse = ~((cfg_out_precision[1]) ^ (cfg_out_precision[0]));
  assign and_84_rgt = (and_dcpl_24 | xor_dcpl_2) & or_cse;
  assign FpIntToFloat_17U_5U_10U_else_i_abs_and_cse = core_wen & (~ (fsm_output[0]));
  assign FpIntToFloat_17U_5U_10U_else_i_abs_and_4_cse = FpIntToFloat_17U_5U_10U_else_i_abs_and_cse
      & ((and_dcpl_44 & else_else_and_1_cse & (~ IntShiftRight_34U_6U_17U_obits_fixed_nor_tmp)
      & main_stage_v_1) | and_dcpl_58) & (~ mux_30_itm);
  assign or_4_nl = IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_st
      | chn_data_out_rsci_bawt | (~ reg_chn_data_out_rsci_ld_core_psct_cse);
  assign nor_nl = ~((~ IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_st)
      | chn_data_out_rsci_bawt | (~ reg_chn_data_out_rsci_ld_core_psct_cse));
  assign mux_5_nl = MUX_s_1_2_2((nor_nl), (or_4_nl), IntSaturation_17U_8U_if_acc_itm_10_1);
  assign mux_32_itm = MUX_s_1_2_2((mux_5_nl), IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_st,
      nor_23_cse);
  assign and_43_nl = or_cse & chn_alu_in_rsci_bawt & or_dcpl & chn_data_in_rsci_bawt
      & (fsm_output[1]);
  assign NV_NVDLA_CDMA_CVT_cell_core_nvdla_int_h_ln333_assert_oWidth_ge_aWidth_p_bWidth_sig_mx0w1
      = MUX1HOT_s_1_1_2(1'b1, and_43_nl);
  assign nl_IntSubExt_17U_16U_18U_o_acc_nl = conv_s2s_17_18(chn_data_in_rsci_d_mxwt)
      - conv_s2s_16_18(chn_alu_in_rsci_d_mxwt);
  assign IntSubExt_17U_16U_18U_o_acc_nl = nl_IntSubExt_17U_16U_18U_o_acc_nl[17:0];
  assign nl_IntMulExt_18U_16U_34U_o_mul_itm_mx0w0 = $signed((IntSubExt_17U_16U_18U_o_acc_nl))
      * $signed((cfg_mul_in_rsci_d));
  assign IntMulExt_18U_16U_34U_o_mul_itm_mx0w0 = nl_IntMulExt_18U_16U_34U_o_mul_itm_mx0w0[32:0];
  assign IntShiftRight_34U_6U_17U_obits_fixed_nor_4_cse = ~((IntShiftRight_34U_6U_17U_obits_fixed_acc_tmp[16])
      | IntShiftRight_34U_6U_17U_obits_fixed_and_1_tmp);
  assign else_o_i17_16_sva_mx0w0 = ~(IntShiftRight_34U_6U_17U_obits_fixed_nor_4_cse
      | IntShiftRight_34U_6U_17U_obits_fixed_nor_tmp);
  assign nl_IntSaturation_17U_8U_if_acc_nl = conv_s2u_10_11({(~ else_o_i17_16_sva_mx0w0)
      , (~ (else_o_i17_15_1_sva_mx0w0[14:6]))}) + 11'b1;
  assign IntSaturation_17U_8U_if_acc_nl = nl_IntSaturation_17U_8U_if_acc_nl[10:0];
  assign IntSaturation_17U_8U_if_acc_itm_10_1 = readslicef_11_1_10((IntSaturation_17U_8U_if_acc_nl));
  assign else_o_i17_0_sva_mx0w0 = ~((~((IntShiftRight_34U_6U_17U_obits_fixed_acc_tmp[0])
      | IntShiftRight_34U_6U_17U_obits_fixed_nor_tmp)) | IntShiftRight_34U_6U_17U_obits_fixed_and_1_tmp);
  assign FpMantRNE_17U_11U_else_and_tmp = FpMantRNE_17U_11U_else_carry_sva & (FpIntToFloat_17U_5U_10U_else_int_mant_sva[16:6]==11'b11111111111);
  assign FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_tmp = ~(else_o_i17_16_sva_mx0w0
      | (else_o_i17_15_1_sva_mx0w0!=15'b000000000000000) | else_o_i17_0_sva_mx0w0);
  assign IntShiftRight_34U_6U_17U_obits_fixed_nor_2_nl = ~(MUX_v_15_2_2((IntShiftRight_34U_6U_17U_obits_fixed_acc_tmp[15:1]),
      15'b111111111111111, IntShiftRight_34U_6U_17U_obits_fixed_nor_tmp));
  assign else_o_i17_15_1_sva_mx0w0 = ~(MUX_v_15_2_2((IntShiftRight_34U_6U_17U_obits_fixed_nor_2_nl),
      15'b111111111111111, IntShiftRight_34U_6U_17U_obits_fixed_and_1_tmp));
  assign nl_IntSaturation_17U_16U_if_acc_nl = conv_s2u_2_3({(~ else_o_i17_16_sva_mx0w0)
      , (~ (else_o_i17_15_1_sva_mx0w0[14]))}) + 3'b1;
  assign IntSaturation_17U_16U_if_acc_nl = nl_IntSaturation_17U_16U_if_acc_nl[2:0];
  assign IntSaturation_17U_16U_if_acc_itm_2_1 = readslicef_3_1_2((IntSaturation_17U_16U_if_acc_nl));
  assign IntShiftRight_34U_6U_17U_obits_fixed_and_nl = (IntShiftRight_34U_6U_17U_mbits_fixed_sva[62])
      & ((IntShiftRight_34U_6U_17U_mbits_fixed_sva[0]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[1])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[2]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[3])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[4]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[5])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[6]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[7])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[8]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[9])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[10]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[11])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[12]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[13])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[14]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[15])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[16]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[17])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[18]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[19])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[20]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[21])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[22]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[23])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[24]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[25])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[26]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[27])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[28]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[29])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[30]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[31])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[32]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[33])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[34]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[35])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[36]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[37])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[38]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[39])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[40]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[41])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[42]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[43])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[44]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[45])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[46]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[47])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[48]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[49])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[50]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[51])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[52]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[53])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[54]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[55])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[56]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[57])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[58]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[59])
      | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[60]) | (IntShiftRight_34U_6U_17U_mbits_fixed_sva[61])
      | (~ (IntShiftRight_34U_6U_17U_mbits_fixed_sva[96])));
  assign nl_IntShiftRight_34U_6U_17U_obits_fixed_acc_tmp = conv_s2s_34_35(IntShiftRight_34U_6U_17U_mbits_fixed_sva[96:63])
      + conv_u2s_1_35(IntShiftRight_34U_6U_17U_obits_fixed_and_nl);
  assign IntShiftRight_34U_6U_17U_obits_fixed_acc_tmp = nl_IntShiftRight_34U_6U_17U_obits_fixed_acc_tmp[34:0];
  assign IntShiftRight_34U_6U_17U_obits_fixed_and_1_tmp = (IntShiftRight_34U_6U_17U_obits_fixed_acc_tmp[34])
      & (~((IntShiftRight_34U_6U_17U_obits_fixed_acc_tmp[33:16]==18'b111111111111111111)));
  assign IntShiftRight_34U_6U_17U_obits_fixed_nor_tmp = ~((IntShiftRight_34U_6U_17U_obits_fixed_acc_tmp[34])
      | (~((IntShiftRight_34U_6U_17U_obits_fixed_acc_tmp[33:16]!=18'b000000000000000000))));
  assign FpIntToFloat_17U_5U_10U_if_not_14_nl = ~ FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_svs_2;
  assign FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_and_1_nl = MUX_v_10_2_2(10'b0000000000,
      (z_out[9:0]), (FpIntToFloat_17U_5U_10U_if_not_14_nl));
  assign FpIntToFloat_17U_5U_10U_o_mant_lpi_1_dfm_1 = MUX_v_10_2_2((FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_and_1_nl),
      10'b1111111111, FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_nor_tmp);
  assign IntSaturation_17U_8U_IntSaturation_17U_8U_nor_nl = ~((z_out[10]) | IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_2);
  assign IntSaturation_17U_8U_and_1_nl = (z_out[10]) & (~ IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_2);
  assign IntSaturation_17U_8U_o_7_1_lpi_1_dfm_1 = MUX1HOT_v_7_3_2((else_o_i17_15_1_sva_2[6:0]),
      7'b1000000, 7'b111111, {(IntSaturation_17U_8U_IntSaturation_17U_8U_nor_nl)
      , (IntSaturation_17U_8U_and_1_nl) , IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_2});
  assign else_nor_dfs = ~(else_equal_tmp | else_nor_tmp);
  assign else_equal_tmp = (cfg_out_precision==2'b01);
  assign else_else_and_1_cse = (cfg_out_precision==2'b10);
  assign else_nor_tmp = ~(else_else_and_1_cse | else_equal_tmp);
  assign nl_FpIntToFloat_17U_5U_10U_else_else_1_if_if_acc_1_nl = ({1'b1 , (~ (libraries_leading_sign_17_0_41e60b6cae787099c94cb08258e79dd04a6f_1[4:1]))})
      + 5'b1;
  assign FpIntToFloat_17U_5U_10U_else_else_1_if_if_acc_1_nl = nl_FpIntToFloat_17U_5U_10U_else_else_1_if_if_acc_1_nl[4:0];
  assign FpIntToFloat_17U_5U_10U_else_else_1_if_if_acc_1_itm_4_1 = readslicef_5_1_4((FpIntToFloat_17U_5U_10U_else_else_1_if_if_acc_1_nl));
  assign FpMantRNE_17U_11U_else_carry_sva = (FpIntToFloat_17U_5U_10U_else_int_mant_sva[5])
      & ((FpIntToFloat_17U_5U_10U_else_int_mant_sva[0]) | (FpIntToFloat_17U_5U_10U_else_int_mant_sva[1])
      | (FpIntToFloat_17U_5U_10U_else_int_mant_sva[2]) | (FpIntToFloat_17U_5U_10U_else_int_mant_sva[3])
      | (FpIntToFloat_17U_5U_10U_else_int_mant_sva[4]) | (FpIntToFloat_17U_5U_10U_else_int_mant_sva[6]));
  assign FpMantRNE_17U_11U_else_mux_1_nl = MUX_s_1_2_2(FpMantRNE_17U_11U_else_and_tmp,
      FpMantRNE_17U_11U_else_and_svs, and_dcpl_41);
  assign FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_nor_tmp
      = ~(((~((~ FpIntToFloat_17U_5U_10U_else_else_1_if_if_acc_1_itm_4_1) & (FpMantRNE_17U_11U_else_mux_1_nl)))
      & ((libraries_leading_sign_17_0_41e60b6cae787099c94cb08258e79dd04a6f_1!=5'b00000)))
      | FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_svs_2);
  assign unequal_tmp = ~((cfg_in_precision==2'b10));
  assign or_cse = chn_data_out_rsci_bawt | (~ reg_chn_data_out_rsci_ld_core_psct_cse);
  assign main_stage_en_1 = chn_data_in_rsci_bawt & chn_alu_in_rsci_bawt & or_cse;
  assign nl_IntSaturation_17U_16U_else_if_acc_nl = conv_s2u_2_3({else_o_i17_16_sva_mx0w0
      , (else_o_i17_15_1_sva_mx0w0[14])}) + 3'b1;
  assign IntSaturation_17U_16U_else_if_acc_nl = nl_IntSaturation_17U_16U_else_if_acc_nl[2:0];
  assign IntSaturation_17U_16U_else_if_acc_itm_2_1 = readslicef_3_1_2((IntSaturation_17U_16U_else_if_acc_nl));
  assign nl_FpIntToFloat_17U_5U_10U_else_if_ac_int_cctor_sva = conv_u2u_16_17({(~
      else_o_i17_15_1_sva_mx0w0) , (~ else_o_i17_0_sva_mx0w0)}) + 17'b1;
  assign FpIntToFloat_17U_5U_10U_else_if_ac_int_cctor_sva = nl_FpIntToFloat_17U_5U_10U_else_if_ac_int_cctor_sva[16:0];
  assign asn_21 = else_nor_dfs & unequal_tmp;
  assign asn_23 = else_equal_tmp & unequal_tmp;
  assign asn_25 = else_nor_tmp & unequal_tmp;
  assign and_dcpl_1 = chn_alu_in_rsci_bawt & chn_data_in_rsci_bawt;
  assign and_dcpl_2 = and_dcpl_1 & (cfg_out_precision==2'b01);
  assign or_dcpl = (cfg_in_precision!=2'b10);
  assign and_dcpl_3 = or_cse & or_dcpl;
  assign and_dcpl_5 = reg_chn_data_out_rsci_ld_core_psct_cse & chn_data_out_rsci_bawt;
  assign and_dcpl_6 = and_dcpl_5 & or_dcpl;
  assign and_dcpl_8 = and_dcpl_1 & xnor_1_cse;
  assign nor_23_cse = ~((cfg_in_precision!=2'b10));
  assign nand_11_cse = ~(chn_data_in_rsci_bawt & chn_alu_in_rsci_bawt);
  assign nand_10_nl = ~(nand_11_cse & or_cse);
  assign mux_tmp_6 = MUX_s_1_2_2(main_stage_en_1, (nand_10_nl), main_stage_v_1);
  assign or_10_nl = main_stage_v_2 | chn_data_out_rsci_bawt | (~ reg_chn_data_out_rsci_ld_core_psct_cse);
  assign nor_22_nl = ~((~ main_stage_v_2) | chn_data_out_rsci_bawt | (~ reg_chn_data_out_rsci_ld_core_psct_cse));
  assign mux_tmp_7 = MUX_s_1_2_2((nor_22_nl), (or_10_nl), main_stage_v_1);
  assign or_tmp_11 = FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_svs_2
      | (~ main_stage_v_2) | chn_data_out_rsci_bawt | (~ reg_chn_data_out_rsci_ld_core_psct_cse);
  assign nor_5_cse = ~(FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_svs_2
      | (~ main_stage_v_2));
  assign nor_21_nl = ~(nor_5_cse | chn_data_out_rsci_bawt | (~ reg_chn_data_out_rsci_ld_core_psct_cse));
  assign mux_tmp_8 = MUX_s_1_2_2((nor_21_nl), or_tmp_11, FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_svs);
  assign and_tmp_1 = FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_tmp &
      or_cse;
  assign or_tmp_14 = FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_tmp |
      (~ or_cse);
  assign mux_14_nl = MUX_s_1_2_2(or_tmp_14, and_tmp_1, nor_5_cse);
  assign mux_15_nl = MUX_s_1_2_2((mux_14_nl), mux_tmp_8, nor_23_cse);
  assign nor_3_nl = ~((cfg_out_precision!=2'b10));
  assign mux_16_nl = MUX_s_1_2_2(mux_tmp_8, (mux_15_nl), nor_3_nl);
  assign mux_17_itm = MUX_s_1_2_2(or_tmp_11, (mux_16_nl), main_stage_v_1);
  assign or_20_nl = main_stage_v_1 | (~ or_cse);
  assign and_128_nl = (~(IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_2
      & IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_st_2)) & main_stage_v_2;
  assign mux_20_cse = MUX_s_1_2_2(and_65_cse, (or_20_nl), and_128_nl);
  assign or_22_nl = (IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_2
      & IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_st_2) | (~
      main_stage_v_2) | (~ reg_chn_data_out_rsci_ld_core_psct_cse) | chn_data_out_rsci_bawt;
  assign mux_23_nl = MUX_s_1_2_2((~ mux_20_cse), (or_22_nl), IntSaturation_17U_8U_if_acc_itm_10_1);
  assign mux_tmp_19 = MUX_s_1_2_2((mux_23_nl), (~ mux_20_cse), nor_23_cse);
  assign mux_28_nl = MUX_s_1_2_2(and_tmp_1, or_tmp_14, FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_svs);
  assign mux_29_nl = MUX_s_1_2_2((mux_28_nl), FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_svs,
      nor_23_cse);
  assign nor_14_nl = ~((~ main_stage_v_1) | (cfg_out_precision!=2'b10));
  assign mux_30_itm = MUX_s_1_2_2(FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_svs,
      (mux_29_nl), nor_14_nl);
  assign and_dcpl_20 = reg_chn_data_out_rsci_ld_core_psct_cse & (~ chn_data_out_rsci_bawt);
  assign and_dcpl_22 = or_cse & main_stage_v_2;
  assign and_dcpl_24 = (cfg_in_precision==2'b10);
  assign and_dcpl_25 = and_dcpl_22 & and_dcpl_24;
  assign and_dcpl_26 = and_dcpl_5 & (~ main_stage_v_2);
  assign and_dcpl_33 = or_cse & and_dcpl_24;
  assign and_dcpl_41 = (libraries_leading_sign_17_0_41e60b6cae787099c94cb08258e79dd04a6f_1==5'b00000);
  assign or_dcpl_20 = (cfg_out_precision!=2'b10);
  assign and_dcpl_44 = and_dcpl_3 & ((IntShiftRight_34U_6U_17U_obits_fixed_acc_tmp[16])
      | IntShiftRight_34U_6U_17U_obits_fixed_and_1_tmp);
  assign and_dcpl_45 = and_dcpl_44 & else_else_and_1_cse & (~ IntShiftRight_34U_6U_17U_obits_fixed_nor_tmp);
  assign and_dcpl_48 = (IntShiftRight_34U_6U_17U_obits_fixed_nor_4_cse | IntShiftRight_34U_6U_17U_obits_fixed_nor_tmp)
      & or_cse & or_dcpl;
  assign and_dcpl_49 = and_dcpl_48 & else_else_and_1_cse;
  assign and_dcpl_50 = (and_dcpl_24 | or_dcpl_20) & or_cse;
  assign xor_dcpl_2 = (cfg_out_precision[1]) ^ (cfg_out_precision[0]);
  assign and_dcpl_58 = and_dcpl_48 & else_else_and_1_cse & main_stage_v_1;
  assign or_dcpl_29 = and_dcpl_20 | and_dcpl_24;
  assign or_dcpl_30 = or_dcpl_29 | or_dcpl_20 | (~ main_stage_v_1);
  assign or_tmp_29 = main_stage_en_1 | (fsm_output[0]);
  assign or_tmp_35 = or_cse & and_dcpl_1 & (fsm_output[1]);
  assign main_stage_v_1_mx0c1 = or_cse & nand_11_cse & main_stage_v_1;
  assign main_stage_v_2_mx0c1 = or_cse & main_stage_v_2 & (~ main_stage_v_1);
  assign FpIntToFloat_17U_5U_10U_else_i_abs_conc_3_16 = FpIntToFloat_17U_5U_10U_else_if_slc_FpIntToFloat_17U_5U_10U_else_if_ac_int_cctor_16_itm_2
      & else_o_i17_16_sva_2;
  assign chn_data_in_rsci_oswt_unreg_pff = or_tmp_35;
  assign chn_data_out_rsci_oswt_unreg = and_dcpl_5;
  assign IntSaturation_17U_8U_else_if_and_tmp = (fsm_output[1]) & xnor_1_cse;
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_chn_alu_in_rsci_iswt0_cse <= 1'b0;
      chn_data_out_rsci_iswt0 <= 1'b0;
    end
    else if ( core_wen ) begin
      reg_chn_alu_in_rsci_iswt0_cse <= ~((~ main_stage_en_1) & (fsm_output[1]));
      chn_data_out_rsci_iswt0 <= and_dcpl_22;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_chn_alu_in_rsci_ld_core_psct_cse <= 1'b0;
    end
    else if ( core_wen & or_tmp_29 ) begin
      reg_chn_alu_in_rsci_ld_core_psct_cse <= or_tmp_29;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_data_out_rsci_d_0 <= 1'b0;
      chn_data_out_rsci_d_15 <= 1'b0;
    end
    else if ( chn_data_out_and_cse ) begin
      chn_data_out_rsci_d_0 <= MUX_s_1_2_2((else_mux1h_11_nl), (i_data_sva_2_15_0_1[0]),
          and_dcpl_25);
      chn_data_out_rsci_d_15 <= MUX_s_1_2_2((else_mux1h_12_nl), (i_data_sva_2_15_0_1[15]),
          and_dcpl_25);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_data_out_rsci_d_9_1 <= 9'b0;
      chn_data_out_rsci_d_14_10 <= 5'b0;
    end
    else if ( chn_data_out_and_1_cse ) begin
      chn_data_out_rsci_d_9_1 <= MUX1HOT_v_9_4_2((i_data_sva_2_15_0_1[9:1]), (FpIntToFloat_17U_5U_10U_o_mant_lpi_1_dfm_1[9:1]),
          (IntSaturation_17U_16U_o_15_1_lpi_1_dfm_5[8:0]), ({{2{IntSaturation_17U_8U_o_7_1_lpi_1_dfm_1[6]}},
          IntSaturation_17U_8U_o_7_1_lpi_1_dfm_1}), {(~ unequal_tmp) , asn_21 , asn_23
          , asn_25});
      chn_data_out_rsci_d_14_10 <= MUX1HOT_v_5_5_2((i_data_sva_2_15_0_1[14:10]),
          (FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_and_2_nl), 5'b11110, (IntSaturation_17U_16U_o_15_1_lpi_1_dfm_5[13:9]),
          (signext_5_1(IntSaturation_17U_8U_o_7_1_lpi_1_dfm_1[6])), {(~ unequal_tmp)
          , (and_134_nl) , (and_135_nl) , asn_23 , asn_25});
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_chn_data_out_rsci_ld_core_psct_cse <= 1'b0;
    end
    else if ( core_wen & (and_dcpl_22 | and_dcpl_26) ) begin
      reg_chn_data_out_rsci_ld_core_psct_cse <= ~ and_dcpl_26;
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
      IntMulExt_18U_16U_34U_o_mul_itm_2 <= 33'b0;
    end
    else if ( core_wen & IntMulExt_18U_16U_34U_o_IntMulExt_18U_16U_34U_o_or_cse &
        mux_tmp_6 ) begin
      IntMulExt_18U_16U_34U_o_mul_itm_2 <= MUX_v_33_2_2(IntMulExt_18U_16U_34U_o_mul_itm_mx0w0,
          IntMulExt_18U_16U_34U_o_mul_itm, and_dcpl_33);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      main_stage_v_2 <= 1'b0;
    end
    else if ( core_wen & (and_65_cse | main_stage_v_2_mx0c1) ) begin
      main_stage_v_2 <= ~ main_stage_v_2_mx0c1;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      else_o_i17_16_sva_2 <= 1'b0;
      IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_2 <= 1'b0;
      else_o_i17_0_sva_2 <= 1'b0;
      IntSaturation_17U_16U_IntSaturation_17U_16U_or_itm_2 <= 1'b0;
      i_data_sva_2_15_0_1 <= 16'b0;
    end
    else if ( else_o_i17_and_cse ) begin
      else_o_i17_16_sva_2 <= else_o_i17_16_sva_mx0w0;
      IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_2 <= IntSaturation_17U_8U_if_acc_itm_10_1;
      else_o_i17_0_sva_2 <= else_o_i17_0_sva_mx0w0;
      IntSaturation_17U_16U_IntSaturation_17U_16U_or_itm_2 <= (else_o_i17_0_sva_mx0w0
          & (~ IntSaturation_17U_16U_else_if_acc_itm_2_1)) | IntSaturation_17U_16U_if_acc_itm_2_1;
      i_data_sva_2_15_0_1 <= i_data_sva_1_15_0_1;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      IntSaturation_17U_16U_o_15_1_lpi_1_dfm_5 <= 15'b0;
    end
    else if ( core_wen & (IntSaturation_17U_16U_o_IntSaturation_17U_16U_o_nor_rgt
        | IntSaturation_17U_16U_and_1_rgt | IntSaturation_17U_16U_o_and_1_rgt) &
        mux_tmp_7 ) begin
      IntSaturation_17U_16U_o_15_1_lpi_1_dfm_5 <= MUX1HOT_v_15_3_2(else_o_i17_15_1_sva_mx0w0,
          15'b100000000000000, 15'b11111111111111, {IntSaturation_17U_16U_o_IntSaturation_17U_16U_o_nor_rgt
          , IntSaturation_17U_16U_and_1_rgt , IntSaturation_17U_16U_o_and_1_rgt});
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpMantRNE_17U_11U_else_and_svs <= 1'b0;
    end
    else if ( core_wen & (~(and_dcpl_41 | and_dcpl_20 | and_dcpl_24 | (~ main_stage_v_2)
        | FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_svs_2 | (cfg_out_precision!=2'b10)))
        ) begin
      FpMantRNE_17U_11U_else_and_svs <= FpMantRNE_17U_11U_else_and_tmp;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpIntToFloat_17U_5U_10U_else_i_abs_15_1_lpi_1_dfm_5 <= 15'b0;
      FpIntToFloat_17U_5U_10U_else_i_abs_0_lpi_1_dfm_5 <= 1'b0;
    end
    else if ( FpIntToFloat_17U_5U_10U_else_i_abs_and_2_cse ) begin
      FpIntToFloat_17U_5U_10U_else_i_abs_15_1_lpi_1_dfm_5 <= MUX1HOT_v_15_3_2((FpIntToFloat_17U_5U_10U_else_if_ac_int_cctor_sva[15:1]),
          else_o_i17_15_1_sva_mx0w0, FpIntToFloat_17U_5U_10U_else_i_abs_15_1_lpi_1_dfm,
          {and_dcpl_45 , and_dcpl_49 , and_dcpl_50});
      FpIntToFloat_17U_5U_10U_else_i_abs_0_lpi_1_dfm_5 <= MUX1HOT_s_1_3_2((FpIntToFloat_17U_5U_10U_else_if_ac_int_cctor_sva[0]),
          else_o_i17_0_sva_mx0w0, FpIntToFloat_17U_5U_10U_else_i_abs_0_lpi_1_dfm,
          {and_dcpl_45 , and_dcpl_49 , and_dcpl_50});
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpIntToFloat_17U_5U_10U_else_if_slc_FpIntToFloat_17U_5U_10U_else_if_ac_int_cctor_16_itm_2
          <= 1'b0;
    end
    else if ( core_wen & FpIntToFloat_17U_5U_10U_else_if_FpIntToFloat_17U_5U_10U_else_if_or_cse
        & (~ mux_17_itm) ) begin
      FpIntToFloat_17U_5U_10U_else_if_slc_FpIntToFloat_17U_5U_10U_else_if_ac_int_cctor_16_itm_2
          <= MUX_s_1_2_2((FpIntToFloat_17U_5U_10U_else_if_ac_int_cctor_sva[16]),
          FpIntToFloat_17U_5U_10U_else_if_slc_FpIntToFloat_17U_5U_10U_else_if_ac_int_cctor_16_itm,
          and_dcpl_50);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_svs_2 <= 1'b0;
    end
    else if ( core_wen & FpIntToFloat_17U_5U_10U_else_if_FpIntToFloat_17U_5U_10U_else_if_or_cse
        & mux_tmp_7 ) begin
      FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_svs_2 <= MUX_s_1_2_2(FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_tmp,
          FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_svs, and_dcpl_50);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      else_o_i17_15_1_sva_2 <= 15'b0;
    end
    else if ( core_wen & IntMulExt_18U_16U_34U_o_IntMulExt_18U_16U_34U_o_or_cse &
        (~ (mux_27_nl)) ) begin
      else_o_i17_15_1_sva_2 <= MUX_v_15_2_2(else_o_i17_15_1_sva_mx0w0, else_o_i17_15_1_sva,
          and_dcpl_33);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_st_2 <= 1'b0;
    end
    else if ( core_wen & ((and_dcpl_3 & xnor_1_cse) | and_84_rgt) & mux_tmp_7 ) begin
      IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_st_2 <= MUX_s_1_2_2(IntSaturation_17U_8U_if_acc_itm_10_1,
          IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_st, and_84_rgt);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpIntToFloat_17U_5U_10U_else_i_abs_0_lpi_1_dfm <= 1'b0;
      FpIntToFloat_17U_5U_10U_else_i_abs_15_1_lpi_1_dfm <= 15'b0;
    end
    else if ( FpIntToFloat_17U_5U_10U_else_i_abs_and_4_cse ) begin
      FpIntToFloat_17U_5U_10U_else_i_abs_0_lpi_1_dfm <= MUX_s_1_2_2((FpIntToFloat_17U_5U_10U_else_if_ac_int_cctor_sva[0]),
          else_o_i17_0_sva_mx0w0, and_dcpl_58);
      FpIntToFloat_17U_5U_10U_else_i_abs_15_1_lpi_1_dfm <= MUX_v_15_2_2((FpIntToFloat_17U_5U_10U_else_if_ac_int_cctor_sva[15:1]),
          else_o_i17_15_1_sva_mx0w0, and_dcpl_58);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpIntToFloat_17U_5U_10U_else_if_slc_FpIntToFloat_17U_5U_10U_else_if_ac_int_cctor_16_itm
          <= 1'b0;
    end
    else if ( FpIntToFloat_17U_5U_10U_else_i_abs_and_cse & (~ or_dcpl_30) & (~ mux_30_itm)
        ) begin
      FpIntToFloat_17U_5U_10U_else_if_slc_FpIntToFloat_17U_5U_10U_else_if_ac_int_cctor_16_itm
          <= FpIntToFloat_17U_5U_10U_else_if_ac_int_cctor_sva[16];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_svs <= 1'b0;
    end
    else if ( core_wen & (~ or_dcpl_30) ) begin
      FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_svs <= FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_tmp;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      else_o_i17_15_1_sva <= 15'b0;
    end
    else if ( FpIntToFloat_17U_5U_10U_else_i_abs_and_cse & (~(or_dcpl_29 | (~ main_stage_v_1)))
        & (~ (mux_10_nl)) ) begin
      else_o_i17_15_1_sva <= else_o_i17_15_1_sva_mx0w0;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_st <= 1'b0;
    end
    else if ( core_wen & (~(or_dcpl_29 | xor_dcpl_2 | (~ main_stage_v_1))) ) begin
      IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_st <= IntSaturation_17U_8U_if_acc_itm_10_1;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      IntMulExt_18U_16U_34U_o_mul_itm <= 33'b0;
    end
    else if ( core_wen & (~(and_dcpl_20 | (~ chn_alu_in_rsci_bawt) | and_dcpl_24
        | (~ chn_data_in_rsci_bawt) | (fsm_output[0]))) ) begin
      IntMulExt_18U_16U_34U_o_mul_itm <= IntMulExt_18U_16U_34U_o_mul_itm_mx0w0;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      i_data_sva_1_15_0_1 <= 16'b0;
    end
    else if ( core_wen & (~ and_dcpl_20) & mux_tmp_6 ) begin
      i_data_sva_1_15_0_1 <= chn_data_in_rsci_d_mxwt[15:0];
    end
  end
  assign IntSaturation_17U_8U_IntSaturation_17U_8U_or_nl = (else_o_i17_0_sva_2 &
      (~ (z_out[10]))) | IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_2;
  assign else_mux1h_11_nl = MUX1HOT_s_1_3_2((FpIntToFloat_17U_5U_10U_o_mant_lpi_1_dfm_1[0]),
      IntSaturation_17U_16U_IntSaturation_17U_16U_or_itm_2, (IntSaturation_17U_8U_IntSaturation_17U_8U_or_nl),
      {else_nor_dfs , else_equal_tmp , else_nor_tmp});
  assign else_mux1h_12_nl = MUX1HOT_s_1_3_2(else_o_i17_16_sva_2, (IntSaturation_17U_16U_o_15_1_lpi_1_dfm_5[14]),
      (IntSaturation_17U_8U_o_7_1_lpi_1_dfm_1[6]), {else_nor_dfs , else_equal_tmp
      , else_nor_tmp});
  assign nl_FpIntToFloat_17U_5U_10U_else_else_1_if_if_acc_nl = (~ libraries_leading_sign_17_0_41e60b6cae787099c94cb08258e79dd04a6f_1)
      + 5'b1;
  assign FpIntToFloat_17U_5U_10U_else_else_1_if_if_acc_nl = nl_FpIntToFloat_17U_5U_10U_else_else_1_if_if_acc_nl[4:0];
  assign FpIntToFloat_17U_5U_10U_else_and_2_nl = FpIntToFloat_17U_5U_10U_else_else_1_if_if_acc_1_itm_4_1
      & FpMantRNE_17U_11U_else_and_tmp & (~ and_dcpl_41);
  assign FpIntToFloat_17U_5U_10U_else_FpIntToFloat_17U_5U_10U_else_FpIntToFloat_17U_5U_10U_else_mux_nl
      = MUX_v_5_2_2((~ libraries_leading_sign_17_0_41e60b6cae787099c94cb08258e79dd04a6f_1),
      (FpIntToFloat_17U_5U_10U_else_else_1_if_if_acc_nl), FpIntToFloat_17U_5U_10U_else_and_2_nl);
  assign FpIntToFloat_17U_5U_10U_if_not_12_nl = ~ FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_if_nor_svs_2;
  assign FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_and_2_nl = MUX_v_5_2_2(5'b00000,
      (FpIntToFloat_17U_5U_10U_else_FpIntToFloat_17U_5U_10U_else_FpIntToFloat_17U_5U_10U_else_mux_nl),
      (FpIntToFloat_17U_5U_10U_if_not_12_nl));
  assign and_134_nl = (~ FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_nor_tmp)
      & asn_21;
  assign and_135_nl = FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_FpIntToFloat_17U_5U_10U_nor_tmp
      & asn_21;
  assign mux_25_nl = MUX_s_1_2_2((~ mux_20_cse), mux_tmp_19, cfg_out_precision[1]);
  assign mux_26_nl = MUX_s_1_2_2(mux_tmp_19, (~ mux_20_cse), cfg_out_precision[1]);
  assign mux_27_nl = MUX_s_1_2_2((mux_26_nl), (mux_25_nl), cfg_out_precision[0]);
  assign mux_7_nl = MUX_s_1_2_2(IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_st,
      mux_32_itm, cfg_out_precision[1]);
  assign mux_8_nl = MUX_s_1_2_2(mux_32_itm, IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_st,
      cfg_out_precision[1]);
  assign mux_9_nl = MUX_s_1_2_2((mux_8_nl), (mux_7_nl), cfg_out_precision[0]);
  assign mux_10_nl = MUX_s_1_2_2(IntSaturation_17U_8U_if_slc_IntSaturation_17U_8U_if_acc_10_svs_st,
      (mux_9_nl), main_stage_v_1);
  assign FpMantRNE_17U_11U_else_mux_2_nl = MUX_v_10_2_2((FpIntToFloat_17U_5U_10U_else_int_mant_sva[15:6]),
      ({else_o_i17_16_sva_2 , (else_o_i17_15_1_sva_2[14:6])}), IntSaturation_17U_8U_else_if_and_tmp);
  assign FpMantRNE_17U_11U_else_or_1_nl = FpMantRNE_17U_11U_else_carry_sva | IntSaturation_17U_8U_else_if_and_tmp;
  assign nl_z_out = conv_s2u_10_11(FpMantRNE_17U_11U_else_mux_2_nl) + conv_u2u_1_11(FpMantRNE_17U_11U_else_or_1_nl);
  assign z_out = nl_z_out[10:0];

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


  function [14:0] MUX1HOT_v_15_3_2;
    input [14:0] input_2;
    input [14:0] input_1;
    input [14:0] input_0;
    input [2:0] sel;
    reg [14:0] result;
  begin
    result = input_0 & {15{sel[0]}};
    result = result | ( input_1 & {15{sel[1]}});
    result = result | ( input_2 & {15{sel[2]}});
    MUX1HOT_v_15_3_2 = result;
  end
  endfunction


  function [4:0] MUX1HOT_v_5_5_2;
    input [4:0] input_4;
    input [4:0] input_3;
    input [4:0] input_2;
    input [4:0] input_1;
    input [4:0] input_0;
    input [4:0] sel;
    reg [4:0] result;
  begin
    result = input_0 & {5{sel[0]}};
    result = result | ( input_1 & {5{sel[1]}});
    result = result | ( input_2 & {5{sel[2]}});
    result = result | ( input_3 & {5{sel[3]}});
    result = result | ( input_4 & {5{sel[4]}});
    MUX1HOT_v_5_5_2 = result;
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


  function [8:0] MUX1HOT_v_9_4_2;
    input [8:0] input_3;
    input [8:0] input_2;
    input [8:0] input_1;
    input [8:0] input_0;
    input [3:0] sel;
    reg [8:0] result;
  begin
    result = input_0 & {9{sel[0]}};
    result = result | ( input_1 & {9{sel[1]}});
    result = result | ( input_2 & {9{sel[2]}});
    result = result | ( input_3 & {9{sel[3]}});
    MUX1HOT_v_9_4_2 = result;
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


  function [32:0] MUX_v_33_2_2;
    input [32:0] input_0;
    input [32:0] input_1;
    input [0:0] sel;
    reg [32:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_33_2_2 = result;
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


  function [0:0] readslicef_11_1_10;
    input [10:0] vector;
    reg [10:0] tmp;
  begin
    tmp = vector >> 10;
    readslicef_11_1_10 = tmp[0:0];
  end
  endfunction


  function [0:0] readslicef_3_1_2;
    input [2:0] vector;
    reg [2:0] tmp;
  begin
    tmp = vector >> 2;
    readslicef_3_1_2 = tmp[0:0];
  end
  endfunction


  function [0:0] readslicef_5_1_4;
    input [4:0] vector;
    reg [4:0] tmp;
  begin
    tmp = vector >> 4;
    readslicef_5_1_4 = tmp[0:0];
  end
  endfunction


  function [4:0] signext_5_1;
    input [0:0] vector;
  begin
    signext_5_1= {{4{vector[0]}}, vector};
  end
  endfunction


  function [96:0] signext_97_96;
    input [95:0] vector;
  begin
    signext_97_96= {{1{vector[95]}}, vector};
  end
  endfunction


  function  [17:0] conv_s2s_16_18 ;
    input [15:0]  vector ;
  begin
    conv_s2s_16_18 = {{2{vector[15]}}, vector};
  end
  endfunction


  function  [17:0] conv_s2s_17_18 ;
    input [16:0]  vector ;
  begin
    conv_s2s_17_18 = {vector[16], vector};
  end
  endfunction


  function  [34:0] conv_s2s_34_35 ;
    input [33:0]  vector ;
  begin
    conv_s2s_34_35 = {vector[33], vector};
  end
  endfunction


  function  [2:0] conv_s2u_2_3 ;
    input [1:0]  vector ;
  begin
    conv_s2u_2_3 = {vector[1], vector};
  end
  endfunction


  function  [10:0] conv_s2u_10_11 ;
    input [9:0]  vector ;
  begin
    conv_s2u_10_11 = {vector[9], vector};
  end
  endfunction


  function  [34:0] conv_u2s_1_35 ;
    input [0:0]  vector ;
  begin
    conv_u2s_1_35 = {{34{1'b0}}, vector};
  end
  endfunction


  function  [10:0] conv_u2u_1_11 ;
    input [0:0]  vector ;
  begin
    conv_u2u_1_11 = {{10{1'b0}}, vector};
  end
  endfunction


  function  [16:0] conv_u2u_16_17 ;
    input [15:0]  vector ;
  begin
    conv_u2u_16_17 = {1'b0, vector};
  end
  endfunction

endmodule

// ------------------------------------------------------------------
//  Design Unit:    NV_NVDLA_CDMA_CVT_cell
// ------------------------------------------------------------------


module NV_NVDLA_CDMA_CVT_cell (
  nvdla_core_clk, nvdla_core_rstn, chn_data_in_rsc_z, chn_data_in_rsc_vz, chn_data_in_rsc_lz,
      chn_alu_in_rsc_z, chn_alu_in_rsc_vz, chn_alu_in_rsc_lz, cfg_mul_in_rsc_z, cfg_in_precision,
      cfg_out_precision, cfg_truncate, chn_data_out_rsc_z, chn_data_out_rsc_vz, chn_data_out_rsc_lz
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [16:0] chn_data_in_rsc_z;
  input chn_data_in_rsc_vz;
  output chn_data_in_rsc_lz;
  input [15:0] chn_alu_in_rsc_z;
  input chn_alu_in_rsc_vz;
  output chn_alu_in_rsc_lz;
  input [15:0] cfg_mul_in_rsc_z;
  input [1:0] cfg_in_precision;
  input [1:0] cfg_out_precision;
  input [5:0] cfg_truncate;
  output [15:0] chn_data_out_rsc_z;
  input chn_data_out_rsc_vz;
  output chn_data_out_rsc_lz;


  // Interconnect Declarations
  wire chn_data_in_rsci_oswt;
  wire chn_alu_in_rsci_oswt;
  wire chn_data_out_rsci_oswt;
  wire chn_data_out_rsci_oswt_unreg;
  wire chn_data_in_rsci_oswt_unreg_iff;


  // Interconnect Declarations for Component Instantiations 
  CDMA_chn_data_in_rsci_unreg chn_data_in_rsci_unreg_inst (
      .in_0(chn_data_in_rsci_oswt_unreg_iff),
      .outsig(chn_data_in_rsci_oswt)
    );
  CDMA_chn_alu_in_rsci_unreg chn_alu_in_rsci_unreg_inst (
      .in_0(chn_data_in_rsci_oswt_unreg_iff),
      .outsig(chn_alu_in_rsci_oswt)
    );
  CDMA_chn_data_out_rsci_unreg chn_data_out_rsci_unreg_inst (
      .in_0(chn_data_out_rsci_oswt_unreg),
      .outsig(chn_data_out_rsci_oswt)
    );
  NV_NVDLA_CDMA_CVT_cell_core NV_NVDLA_CDMA_CVT_cell_core_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_data_in_rsc_z(chn_data_in_rsc_z),
      .chn_data_in_rsc_vz(chn_data_in_rsc_vz),
      .chn_data_in_rsc_lz(chn_data_in_rsc_lz),
      .chn_alu_in_rsc_z(chn_alu_in_rsc_z),
      .chn_alu_in_rsc_vz(chn_alu_in_rsc_vz),
      .chn_alu_in_rsc_lz(chn_alu_in_rsc_lz),
      .cfg_mul_in_rsc_z(cfg_mul_in_rsc_z),
      .cfg_in_precision(cfg_in_precision),
      .cfg_out_precision(cfg_out_precision),
      .cfg_truncate(cfg_truncate),
      .chn_data_out_rsc_z(chn_data_out_rsc_z),
      .chn_data_out_rsc_vz(chn_data_out_rsc_vz),
      .chn_data_out_rsc_lz(chn_data_out_rsc_lz),
      .chn_data_in_rsci_oswt(chn_data_in_rsci_oswt),
      .chn_alu_in_rsci_oswt(chn_alu_in_rsci_oswt),
      .chn_data_out_rsci_oswt(chn_data_out_rsci_oswt),
      .chn_data_out_rsci_oswt_unreg(chn_data_out_rsci_oswt_unreg),
      .chn_data_in_rsci_oswt_unreg_pff(chn_data_in_rsci_oswt_unreg_iff)
    );
endmodule



