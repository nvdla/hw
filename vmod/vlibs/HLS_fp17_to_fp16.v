// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: HLS_fp17_to_fp16.v

module FP17_TO_FP16_mgc_in_wire_wait_v1 (ld, vd, d, lz, vz, z);

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


//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/siflibs/FP17_TO_FP16_mgc_out_stdreg_wait_v1.v 
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


module FP17_TO_FP16_mgc_out_stdreg_wait_v1 (ld, vd, d, lz, vz, z);

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



//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/siflibs/mgc_shift_r_beh_v4.v 
module FP17_TO_FP16_mgc_shift_r_v4(a,s,z);
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

//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/siflibs/mgc_shift_bl_beh_v4.v 
module FP17_TO_FP16_mgc_shift_bl_v4(a,s,z);
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
module FP17_TO_FP16_mgc_shift_l_v4(a,s,z);
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

//------> ./rtl.v 
// ----------------------------------------------------------------------
//  HLS HDL:        Verilog Netlister
//  HLS Version:    10.0/264918 Production Release
//  HLS Date:       Mon Aug  8 13:35:54 PDT 2016
// 
//  Generated by:   ezhang@hk-sim-10-084
//  Generated date: Mon Mar 20 14:08:09 2017
// ----------------------------------------------------------------------

// 
// ------------------------------------------------------------------
//  Design Unit:    FP17_TO_FP16_chn_o_rsci_unreg
// ------------------------------------------------------------------


module FP17_TO_FP16_chn_o_rsci_unreg (
  in_0, outsig
);
  input in_0;
  output outsig;



  // Interconnect Declarations for Component Instantiations 
  assign outsig = in_0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    FP17_TO_FP16_chn_a_rsci_unreg
// ------------------------------------------------------------------


module FP17_TO_FP16_chn_a_rsci_unreg (
  in_0, outsig
);
  input in_0;
  output outsig;



  // Interconnect Declarations for Component Instantiations 
  assign outsig = in_0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_fp17_to_fp16_core_core_fsm
//  FSM Module
// ------------------------------------------------------------------


module HLS_fp17_to_fp16_core_core_fsm (
  nvdla_core_clk, nvdla_core_rstn, core_wen, fsm_output
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input core_wen;
  output [1:0] fsm_output;
  reg [1:0] fsm_output;


  // FSM State Type Declaration for HLS_fp17_to_fp16_core_core_fsm_1
  parameter
    core_rlp_C_0 = 1'd0,
    main_C_0 = 1'd1;

  reg [0:0] state_var;
  reg [0:0] state_var_NS;


  // Interconnect Declarations for Component Instantiations 
  always @(*)
  begin : HLS_fp17_to_fp16_core_core_fsm_1
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
//  Design Unit:    HLS_fp17_to_fp16_core_staller
// ------------------------------------------------------------------


module HLS_fp17_to_fp16_core_staller (
  nvdla_core_clk, nvdla_core_rstn, core_wen, chn_a_rsci_wen_comp, core_wten, chn_o_rsci_wen_comp
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  output core_wen;
  input chn_a_rsci_wen_comp;
  output core_wten;
  reg core_wten;
  input chn_o_rsci_wen_comp;



  // Interconnect Declarations for Component Instantiations 
  assign core_wen = chn_a_rsci_wen_comp & chn_o_rsci_wen_comp;
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
//  Design Unit:    HLS_fp17_to_fp16_core_chn_o_rsci_chn_o_wait_dp
// ------------------------------------------------------------------


module HLS_fp17_to_fp16_core_chn_o_rsci_chn_o_wait_dp (
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
//  Design Unit:    HLS_fp17_to_fp16_core_chn_o_rsci_chn_o_wait_ctrl
// ------------------------------------------------------------------


module HLS_fp17_to_fp16_core_chn_o_rsci_chn_o_wait_ctrl (
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
//  Design Unit:    HLS_fp17_to_fp16_core_chn_a_rsci_chn_a_wait_dp
// ------------------------------------------------------------------


module HLS_fp17_to_fp16_core_chn_a_rsci_chn_a_wait_dp (
  nvdla_core_clk, nvdla_core_rstn, chn_a_rsci_oswt, chn_a_rsci_bawt, chn_a_rsci_wen_comp,
      chn_a_rsci_d_mxwt, chn_a_rsci_biwt, chn_a_rsci_bdwt, chn_a_rsci_d
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input chn_a_rsci_oswt;
  output chn_a_rsci_bawt;
  output chn_a_rsci_wen_comp;
  output [16:0] chn_a_rsci_d_mxwt;
  input chn_a_rsci_biwt;
  input chn_a_rsci_bdwt;
  input [16:0] chn_a_rsci_d;


  // Interconnect Declarations
  reg chn_a_rsci_bcwt;
  reg [16:0] chn_a_rsci_d_bfwt;


  // Interconnect Declarations for Component Instantiations 
  assign chn_a_rsci_bawt = chn_a_rsci_biwt | chn_a_rsci_bcwt;
  assign chn_a_rsci_wen_comp = (~ chn_a_rsci_oswt) | chn_a_rsci_bawt;
  assign chn_a_rsci_d_mxwt = MUX_v_17_2_2(chn_a_rsci_d, chn_a_rsci_d_bfwt, chn_a_rsci_bcwt);
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_a_rsci_bcwt <= 1'b0;
      chn_a_rsci_d_bfwt <= 17'b0;
    end
    else begin
      chn_a_rsci_bcwt <= ~((~(chn_a_rsci_bcwt | chn_a_rsci_biwt)) | chn_a_rsci_bdwt);
      chn_a_rsci_d_bfwt <= chn_a_rsci_d_mxwt;
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
//  Design Unit:    HLS_fp17_to_fp16_core_chn_a_rsci_chn_a_wait_ctrl
// ------------------------------------------------------------------


module HLS_fp17_to_fp16_core_chn_a_rsci_chn_a_wait_ctrl (
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
//  Design Unit:    HLS_fp17_to_fp16_core_chn_o_rsci
// ------------------------------------------------------------------


module HLS_fp17_to_fp16_core_chn_o_rsci (
  nvdla_core_clk, nvdla_core_rstn, chn_o_rsc_z, chn_o_rsc_vz, chn_o_rsc_lz, chn_o_rsci_oswt,
      core_wen, core_wten, chn_o_rsci_iswt0, chn_o_rsci_bawt, chn_o_rsci_wen_comp,
      chn_o_rsci_ld_core_psct, chn_o_rsci_d
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  output [15:0] chn_o_rsc_z;
  input chn_o_rsc_vz;
  output chn_o_rsc_lz;
  input chn_o_rsci_oswt;
  input core_wen;
  input core_wten;
  input chn_o_rsci_iswt0;
  output chn_o_rsci_bawt;
  output chn_o_rsci_wen_comp;
  input chn_o_rsci_ld_core_psct;
  input [15:0] chn_o_rsci_d;


  // Interconnect Declarations
  wire chn_o_rsci_biwt;
  wire chn_o_rsci_bdwt;
  wire chn_o_rsci_ld_core_sct;
  wire chn_o_rsci_vd;


  // Interconnect Declarations for Component Instantiations 
  FP17_TO_FP16_mgc_out_stdreg_wait_v1 #(.rscid(32'sd2),
  .width(32'sd16)) chn_o_rsci (
      .ld(chn_o_rsci_ld_core_sct),
      .vd(chn_o_rsci_vd),
      .d(chn_o_rsci_d),
      .lz(chn_o_rsc_lz),
      .vz(chn_o_rsc_vz),
      .z(chn_o_rsc_z)
    );
  HLS_fp17_to_fp16_core_chn_o_rsci_chn_o_wait_ctrl HLS_fp17_to_fp16_core_chn_o_rsci_chn_o_wait_ctrl_inst
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
  HLS_fp17_to_fp16_core_chn_o_rsci_chn_o_wait_dp HLS_fp17_to_fp16_core_chn_o_rsci_chn_o_wait_dp_inst
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
//  Design Unit:    HLS_fp17_to_fp16_core_chn_a_rsci
// ------------------------------------------------------------------


module HLS_fp17_to_fp16_core_chn_a_rsci (
  nvdla_core_clk, nvdla_core_rstn, chn_a_rsc_z, chn_a_rsc_vz, chn_a_rsc_lz, chn_a_rsci_oswt,
      core_wen, chn_a_rsci_iswt0, chn_a_rsci_bawt, chn_a_rsci_wen_comp, chn_a_rsci_ld_core_psct,
      chn_a_rsci_d_mxwt, core_wten
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [16:0] chn_a_rsc_z;
  input chn_a_rsc_vz;
  output chn_a_rsc_lz;
  input chn_a_rsci_oswt;
  input core_wen;
  input chn_a_rsci_iswt0;
  output chn_a_rsci_bawt;
  output chn_a_rsci_wen_comp;
  input chn_a_rsci_ld_core_psct;
  output [16:0] chn_a_rsci_d_mxwt;
  input core_wten;


  // Interconnect Declarations
  wire chn_a_rsci_biwt;
  wire chn_a_rsci_bdwt;
  wire chn_a_rsci_ld_core_sct;
  wire chn_a_rsci_vd;
  wire [16:0] chn_a_rsci_d;


  // Interconnect Declarations for Component Instantiations 
  FP17_TO_FP16_mgc_in_wire_wait_v1 #(.rscid(32'sd1),
  .width(32'sd17)) chn_a_rsci (
      .ld(chn_a_rsci_ld_core_sct),
      .vd(chn_a_rsci_vd),
      .d(chn_a_rsci_d),
      .lz(chn_a_rsc_lz),
      .vz(chn_a_rsc_vz),
      .z(chn_a_rsc_z)
    );
  HLS_fp17_to_fp16_core_chn_a_rsci_chn_a_wait_ctrl HLS_fp17_to_fp16_core_chn_a_rsci_chn_a_wait_ctrl_inst
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
  HLS_fp17_to_fp16_core_chn_a_rsci_chn_a_wait_dp HLS_fp17_to_fp16_core_chn_a_rsci_chn_a_wait_dp_inst
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
//  Design Unit:    HLS_fp17_to_fp16_core
// ------------------------------------------------------------------


module HLS_fp17_to_fp16_core (
  nvdla_core_clk, nvdla_core_rstn, chn_a_rsc_z, chn_a_rsc_vz, chn_a_rsc_lz, chn_o_rsc_z,
      chn_o_rsc_vz, chn_o_rsc_lz, chn_a_rsci_oswt, chn_a_rsci_oswt_unreg, chn_o_rsci_oswt,
      chn_o_rsci_oswt_unreg
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [16:0] chn_a_rsc_z;
  input chn_a_rsc_vz;
  output chn_a_rsc_lz;
  output [15:0] chn_o_rsc_z;
  input chn_o_rsc_vz;
  output chn_o_rsc_lz;
  input chn_a_rsci_oswt;
  output chn_a_rsci_oswt_unreg;
  input chn_o_rsci_oswt;
  output chn_o_rsci_oswt_unreg;


  // Interconnect Declarations
  wire core_wen;
  reg chn_a_rsci_iswt0;
  wire chn_a_rsci_bawt;
  wire chn_a_rsci_wen_comp;
  reg chn_a_rsci_ld_core_psct;
  wire [16:0] chn_a_rsci_d_mxwt;
  wire core_wten;
  reg chn_o_rsci_iswt0;
  wire chn_o_rsci_bawt;
  wire chn_o_rsci_wen_comp;
  reg chn_o_rsci_d_15;
  reg chn_o_rsci_d_14;
  reg [3:0] chn_o_rsci_d_13_10;
  reg [9:0] chn_o_rsci_d_9_0;
  wire [1:0] fsm_output;
  wire mux_tmp;
  wire and_tmp_1;
  wire or_tmp_7;
  wire or_tmp_8;
  wire and_dcpl_6;
  wire and_dcpl_8;
  wire and_dcpl_11;
  wire and_dcpl_14;
  wire or_tmp_19;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs;
  reg main_stage_v_1;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_2;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_2;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_2;
  reg [2:0] FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_if_i_shift_acc_psp_1_sva_2;
  wire [3:0] nl_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_if_i_shift_acc_psp_1_sva_2;
  reg IsNaN_6U_10U_nor_itm_2;
  reg IsNaN_6U_10U_IsNaN_6U_10U_nand_itm_2;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_st_2;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_st_2;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_bits_sva_1_16_1;
  reg [14:0] FpExpoWidthDec_6U_5U_10U_1U_1U_bits_sva_1_14_0_1;
  wire and_6_mdf;
  wire chn_o_and_1_cse;
  reg reg_chn_o_rsci_ld_core_psct_cse;
  wire nor_5_cse;
  wire or_cse;
  wire and_35_rgt;
  wire and_37_rgt;
  wire [10:0] FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_itm;
  wire mux_1_itm;
  wire chn_a_rsci_ld_core_psct_mx0c0;
  wire chn_o_rsci_d_9_0_mx0c1;
  wire main_stage_v_1_mx0c1;
  wire [10:0] FpMantDecShiftRight_10U_6U_10U_o_mant_sum_sva;
  wire [11:0] nl_FpMantDecShiftRight_10U_6U_10U_o_mant_sum_sva;
  wire [9:0] FpMantDecShiftRight_10U_6U_10U_guard_bits_9_0_sva;
  wire [10:0] FpMantDecShiftRight_10U_6U_10U_guard_mask_sva;
  wire [9:0] FpMantDecShiftRight_10U_6U_10U_stick_bits_9_0_sva;
  wire [10:0] FpMantDecShiftRight_10U_6U_10U_stick_mask_sva;
  wire [11:0] nl_FpMantDecShiftRight_10U_6U_10U_stick_mask_sva;
  wire [9:0] FpMantDecShiftRight_10U_6U_10U_least_bits_9_0_sva;
  wire [10:0] FpMantDecShiftRight_10U_6U_10U_least_mask_sva;
  wire Fp17ToFp16_and_cse;
  wire FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_itm_6_1;
  wire FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1;
  wire FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1;

  wire[0:0] iExpoWidth_oExpoWidth_prb;
  wire[0:0] shift_0_prb;
  wire[0:0] and_9;
  wire[9:0] FpExpoWidthDec_6U_5U_10U_1U_1U_FpExpoWidthDec_6U_5U_10U_1U_1U_FpExpoWidthDec_6U_5U_10U_1U_1U_nand_nl;
  wire[9:0] FpExpoWidthDec_6U_5U_10U_1U_1U_nand_nl;
  wire[9:0] FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_mux_nl;
  wire[0:0] FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_not_16_nl;
  wire[3:0] FpExpoWidthDec_6U_5U_10U_1U_1U_mux_6_nl;
  wire[3:0] FpExpoWidthDec_6U_5U_10U_1U_1U_else_FpExpoWidthDec_6U_5U_10U_1U_1U_else_and_2_nl;
  wire[3:0] FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_mux_6_nl;
  wire[0:0] FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_not_15_nl;
  wire[0:0] mux_3_nl;
  wire[0:0] nor_7_nl;
  wire[0:0] mux_2_nl;
  wire[0:0] or_6_nl;
  wire[0:0] or_3_nl;
  wire[0:0] mux_5_nl;
  wire[0:0] nor_nl;
  wire[0:0] mux_4_nl;
  wire[0:0] or_10_nl;
  wire[0:0] mux_6_nl;
  wire[0:0] and_60_nl;
  wire[6:0] FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_nl;
  wire[7:0] nl_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_nl;
  wire[5:0] FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_nl;
  wire[6:0] nl_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_nl;
  wire[6:0] FpExpoWidthDec_6U_5U_10U_1U_1U_acc_nl;
  wire[7:0] nl_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_nl;
  wire[0:0] FpMantDecShiftRight_10U_6U_10U_carry_and_nl;
  wire[0:0] or_2_nl;

  // Interconnect Declarations for Component Instantiations 
  wire [10:0] nl_FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_rg_a;
  assign nl_FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_rg_a = {1'b1 , (FpExpoWidthDec_6U_5U_10U_1U_1U_bits_sva_1_14_0_1[9:0])};
  wire [3:0] nl_FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_rg_s;
  assign nl_FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_rg_s = {FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_if_i_shift_acc_psp_1_sva_2
      , (~ (FpExpoWidthDec_6U_5U_10U_1U_1U_bits_sva_1_14_0_1[10]))};
  wire [5:0] nl_FpMantDecShiftRight_10U_6U_10U_guard_mask_lshift_rg_s;
  assign nl_FpMantDecShiftRight_10U_6U_10U_guard_mask_lshift_rg_s = conv_u2s_4_5({FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_if_i_shift_acc_psp_1_sva_2
      , (~ (FpExpoWidthDec_6U_5U_10U_1U_1U_bits_sva_1_14_0_1[10]))}) + 5'b11111;
  wire [3:0] nl_FpMantDecShiftRight_10U_6U_10U_least_mask_lshift_rg_s;
  assign nl_FpMantDecShiftRight_10U_6U_10U_least_mask_lshift_rg_s = {FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_if_i_shift_acc_psp_1_sva_2
      , (~ (FpExpoWidthDec_6U_5U_10U_1U_1U_bits_sva_1_14_0_1[10]))};
  wire [15:0] nl_HLS_fp17_to_fp16_core_chn_o_rsci_inst_chn_o_rsci_d;
  assign nl_HLS_fp17_to_fp16_core_chn_o_rsci_inst_chn_o_rsci_d = {chn_o_rsci_d_15
      , chn_o_rsci_d_14 , chn_o_rsci_d_13_10 , chn_o_rsci_d_9_0};
  FP17_TO_FP16_mgc_shift_r_v4 #(.width_a(32'sd11),
  .signd_a(32'sd0),
  .width_s(32'sd4),
  .width_z(32'sd11)) FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_rg (
      .a(nl_FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_rg_a[10:0]),
      .s(nl_FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_rg_s[3:0]),
      .z(FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_itm)
    );
  FP17_TO_FP16_mgc_shift_bl_v4 #(.width_a(32'sd1),
  .signd_a(32'sd0),
  .width_s(32'sd5),
  .width_z(32'sd11)) FpMantDecShiftRight_10U_6U_10U_guard_mask_lshift_rg (
      .a(1'b1),
      .s(nl_FpMantDecShiftRight_10U_6U_10U_guard_mask_lshift_rg_s[4:0]),
      .z(FpMantDecShiftRight_10U_6U_10U_guard_mask_sva)
    );
  FP17_TO_FP16_mgc_shift_l_v4 #(.width_a(32'sd1),
  .signd_a(32'sd0),
  .width_s(32'sd4),
  .width_z(32'sd11)) FpMantDecShiftRight_10U_6U_10U_least_mask_lshift_rg (
      .a(1'b1),
      .s(nl_FpMantDecShiftRight_10U_6U_10U_least_mask_lshift_rg_s[3:0]),
      .z(FpMantDecShiftRight_10U_6U_10U_least_mask_sva)
    );
  HLS_fp17_to_fp16_core_chn_a_rsci HLS_fp17_to_fp16_core_chn_a_rsci_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_a_rsc_z(chn_a_rsc_z),
      .chn_a_rsc_vz(chn_a_rsc_vz),
      .chn_a_rsc_lz(chn_a_rsc_lz),
      .chn_a_rsci_oswt(chn_a_rsci_oswt),
      .core_wen(core_wen),
      .chn_a_rsci_iswt0(chn_a_rsci_iswt0),
      .chn_a_rsci_bawt(chn_a_rsci_bawt),
      .chn_a_rsci_wen_comp(chn_a_rsci_wen_comp),
      .chn_a_rsci_ld_core_psct(chn_a_rsci_ld_core_psct),
      .chn_a_rsci_d_mxwt(chn_a_rsci_d_mxwt),
      .core_wten(core_wten)
    );
  HLS_fp17_to_fp16_core_chn_o_rsci HLS_fp17_to_fp16_core_chn_o_rsci_inst (
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
      .chn_o_rsci_d(nl_HLS_fp17_to_fp16_core_chn_o_rsci_inst_chn_o_rsci_d[15:0])
    );
  HLS_fp17_to_fp16_core_staller HLS_fp17_to_fp16_core_staller_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .core_wen(core_wen),
      .chn_a_rsci_wen_comp(chn_a_rsci_wen_comp),
      .core_wten(core_wten),
      .chn_o_rsci_wen_comp(chn_o_rsci_wen_comp)
    );
  HLS_fp17_to_fp16_core_core_fsm HLS_fp17_to_fp16_core_core_fsm_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .core_wen(core_wen),
      .fsm_output(fsm_output)
    );
  assign iExpoWidth_oExpoWidth_prb = MUX_s_1_2_2((MUX1HOT_s_1_1_2(1'b1, fsm_output[0])),
      (MUX1HOT_s_1_1_2(1'b1, and_6_mdf & (fsm_output[1]))), fsm_output[1]);
  // assert(iExpoWidth > oExpoWidth) - ../include/nvdla_float.h: line 630
  // PSL HLS_fp17_to_fp16_core_nvdla_float_h_ln630_assert_iExpoWidth_gt_oExpoWidth : assert { iExpoWidth_oExpoWidth_prb } @rose(nvdla_core_clk);
  assign and_9 = or_cse & FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_2
      & (~ FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_st_2)
      & main_stage_v_1 & (~ FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_st_2);
  assign shift_0_prb = MUX1HOT_s_1_1_2(readslicef_5_1_4((({1'b1 , (~ FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_if_i_shift_acc_psp_1_sva_2)
      , (FpExpoWidthDec_6U_5U_10U_1U_1U_bits_sva_1_14_0_1[10])}) + 5'b1)), and_9);
  // assert(shift > 0) - ../include/nvdla_float.h: line 340
  // PSL HLS_fp17_to_fp16_core_nvdla_float_h_ln340_assert_shift_gt_0 : assert { shift_0_prb } @rose(nvdla_core_clk);
  assign nor_5_cse = ~(IsNaN_6U_10U_IsNaN_6U_10U_nand_itm_2 | IsNaN_6U_10U_nor_itm_2);
  assign chn_o_and_1_cse = core_wen & (~(and_dcpl_8 | (~ main_stage_v_1)));
  assign Fp17ToFp16_and_cse = core_wen & (~ and_dcpl_8) & mux_tmp;
  assign and_35_rgt = or_cse & ((~ FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1) |
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1);
  assign and_37_rgt = or_cse & (~ FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1);
  assign nl_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_nl = ({1'b1 , (~ (chn_a_rsci_d_mxwt[15:10]))})
      + 7'b10001;
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_nl = nl_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_nl[6:0];
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_itm_6_1 = readslicef_7_1_6((FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_nl));
  assign nl_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_nl = conv_u2u_5_6(chn_a_rsci_d_mxwt[15:11])
      + 6'b111101;
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_nl = nl_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_nl[5:0];
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1 = readslicef_6_1_5((FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_nl));
  assign nl_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_nl = conv_u2s_6_7(chn_a_rsci_d_mxwt[15:10])
      + 7'b1010001;
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_acc_nl = nl_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_nl[6:0];
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1 = readslicef_7_1_6((FpExpoWidthDec_6U_5U_10U_1U_1U_acc_nl));
  assign FpMantDecShiftRight_10U_6U_10U_carry_and_nl = ((FpMantDecShiftRight_10U_6U_10U_guard_bits_9_0_sva!=10'b0000000000)
      | (FpMantDecShiftRight_10U_6U_10U_guard_mask_sva[10])) & ((FpMantDecShiftRight_10U_6U_10U_stick_bits_9_0_sva!=10'b0000000000)
      | (FpMantDecShiftRight_10U_6U_10U_stick_mask_sva[10]) | (FpMantDecShiftRight_10U_6U_10U_least_bits_9_0_sva!=10'b0000000000)
      | (FpMantDecShiftRight_10U_6U_10U_least_mask_sva[10]));
  assign nl_FpMantDecShiftRight_10U_6U_10U_o_mant_sum_sva = FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_itm
      + conv_u2u_1_11(FpMantDecShiftRight_10U_6U_10U_carry_and_nl);
  assign FpMantDecShiftRight_10U_6U_10U_o_mant_sum_sva = nl_FpMantDecShiftRight_10U_6U_10U_o_mant_sum_sva[10:0];
  assign FpMantDecShiftRight_10U_6U_10U_guard_bits_9_0_sva = (FpExpoWidthDec_6U_5U_10U_1U_1U_bits_sva_1_14_0_1[9:0])
      & (FpMantDecShiftRight_10U_6U_10U_guard_mask_sva[9:0]);
  assign FpMantDecShiftRight_10U_6U_10U_stick_bits_9_0_sva = (FpExpoWidthDec_6U_5U_10U_1U_1U_bits_sva_1_14_0_1[9:0])
      & (FpMantDecShiftRight_10U_6U_10U_stick_mask_sva[9:0]);
  assign nl_FpMantDecShiftRight_10U_6U_10U_stick_mask_sva = FpMantDecShiftRight_10U_6U_10U_guard_mask_sva
      + 11'b11111111111;
  assign FpMantDecShiftRight_10U_6U_10U_stick_mask_sva = nl_FpMantDecShiftRight_10U_6U_10U_stick_mask_sva[10:0];
  assign FpMantDecShiftRight_10U_6U_10U_least_bits_9_0_sva = (FpExpoWidthDec_6U_5U_10U_1U_1U_bits_sva_1_14_0_1[9:0])
      & (FpMantDecShiftRight_10U_6U_10U_least_mask_sva[9:0]);
  assign or_cse = chn_o_rsci_bawt | (~ reg_chn_o_rsci_ld_core_psct_cse);
  assign and_6_mdf = chn_a_rsci_bawt & or_cse;
  assign or_2_nl = chn_a_rsci_bawt | (~ or_cse);
  assign mux_tmp = MUX_s_1_2_2(and_6_mdf, (or_2_nl), main_stage_v_1);
  assign and_tmp_1 = FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1 & chn_a_rsci_bawt
      & or_cse;
  assign or_tmp_7 = (~ FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_2)
      | chn_o_rsci_bawt | (~ reg_chn_o_rsci_ld_core_psct_cse);
  assign or_tmp_8 = ~((~(FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1 & chn_a_rsci_bawt))
      & or_cse);
  assign mux_1_itm = MUX_s_1_2_2(and_tmp_1, or_tmp_8, FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_2);
  assign and_dcpl_6 = reg_chn_o_rsci_ld_core_psct_cse & chn_o_rsci_bawt;
  assign and_dcpl_8 = reg_chn_o_rsci_ld_core_psct_cse & (~ chn_o_rsci_bawt);
  assign and_dcpl_11 = or_cse & main_stage_v_1;
  assign and_dcpl_14 = and_dcpl_6 & (~ main_stage_v_1);
  assign or_tmp_19 = or_cse & chn_a_rsci_bawt & (fsm_output[1]);
  assign chn_a_rsci_ld_core_psct_mx0c0 = and_6_mdf | (fsm_output[0]);
  assign chn_o_rsci_d_9_0_mx0c1 = and_dcpl_11 & (IsNaN_6U_10U_IsNaN_6U_10U_nand_itm_2
      | IsNaN_6U_10U_nor_itm_2);
  assign main_stage_v_1_mx0c1 = or_cse & (~ chn_a_rsci_bawt) & main_stage_v_1;
  assign chn_a_rsci_oswt_unreg = or_tmp_19;
  assign chn_o_rsci_oswt_unreg = and_dcpl_6;
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_a_rsci_iswt0 <= 1'b0;
      chn_o_rsci_iswt0 <= 1'b0;
    end
    else if ( core_wen ) begin
      chn_a_rsci_iswt0 <= ~((~ and_6_mdf) & (fsm_output[1]));
      chn_o_rsci_iswt0 <= and_dcpl_11;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_a_rsci_ld_core_psct <= 1'b0;
    end
    else if ( core_wen & chn_a_rsci_ld_core_psct_mx0c0 ) begin
      chn_a_rsci_ld_core_psct <= chn_a_rsci_ld_core_psct_mx0c0;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_o_rsci_d_9_0 <= 10'b0;
    end
    else if ( core_wen & ((and_dcpl_11 & nor_5_cse) | chn_o_rsci_d_9_0_mx0c1) ) begin
      chn_o_rsci_d_9_0 <= MUX_v_10_2_2((FpExpoWidthDec_6U_5U_10U_1U_1U_bits_sva_1_14_0_1[9:0]),
          (FpExpoWidthDec_6U_5U_10U_1U_1U_FpExpoWidthDec_6U_5U_10U_1U_1U_FpExpoWidthDec_6U_5U_10U_1U_1U_nand_nl),
          chn_o_rsci_d_9_0_mx0c1);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_o_rsci_d_13_10 <= 4'b0;
      chn_o_rsci_d_14 <= 1'b0;
      chn_o_rsci_d_15 <= 1'b0;
    end
    else if ( chn_o_and_1_cse ) begin
      chn_o_rsci_d_13_10 <= MUX_v_4_2_2((FpExpoWidthDec_6U_5U_10U_1U_1U_mux_6_nl),
          4'b1111, nor_5_cse);
      chn_o_rsci_d_14 <= ((~ (FpExpoWidthDec_6U_5U_10U_1U_1U_bits_sva_1_14_0_1[14]))
          & FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_2
          & (~ FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_2))
          | (~ FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_2)
          | nor_5_cse;
      chn_o_rsci_d_15 <= FpExpoWidthDec_6U_5U_10U_1U_1U_bits_sva_1_16_1;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_chn_o_rsci_ld_core_psct_cse <= 1'b0;
    end
    else if ( core_wen & (and_dcpl_11 | and_dcpl_14) ) begin
      reg_chn_o_rsci_ld_core_psct_cse <= ~ and_dcpl_14;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      main_stage_v_1 <= 1'b0;
    end
    else if ( core_wen & (or_tmp_19 | main_stage_v_1_mx0c1) ) begin
      main_stage_v_1 <= ~ main_stage_v_1_mx0c1;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_bits_sva_1_14_0_1 <= 15'b0;
      FpExpoWidthDec_6U_5U_10U_1U_1U_bits_sva_1_16_1 <= 1'b0;
      FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_2
          <= 1'b0;
      IsNaN_6U_10U_nor_itm_2 <= 1'b0;
      IsNaN_6U_10U_IsNaN_6U_10U_nand_itm_2 <= 1'b0;
    end
    else if ( Fp17ToFp16_and_cse ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_bits_sva_1_14_0_1 <= chn_a_rsci_d_mxwt[14:0];
      FpExpoWidthDec_6U_5U_10U_1U_1U_bits_sva_1_16_1 <= chn_a_rsci_d_mxwt[16];
      FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_2
          <= FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1;
      IsNaN_6U_10U_nor_itm_2 <= ~((chn_a_rsci_d_mxwt[9:0]!=10'b0000000000));
      IsNaN_6U_10U_IsNaN_6U_10U_nand_itm_2 <= ~((chn_a_rsci_d_mxwt[15:10]==6'b111111));
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_if_i_shift_acc_psp_1_sva_2 <= 3'b0;
    end
    else if ( core_wen & (~ and_dcpl_8) & (mux_3_nl) ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_if_i_shift_acc_psp_1_sva_2 <= nl_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_if_i_shift_acc_psp_1_sva_2[2:0];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_st_2
          <= 1'b0;
    end
    else if ( core_wen & (~ and_dcpl_8) & (mux_5_nl) ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_st_2
          <= FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_itm_6_1;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_2
          <= 1'b0;
    end
    else if ( core_wen & ((or_cse & FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1 &
        (~ FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1)) | and_35_rgt) & mux_tmp
        ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_2
          <= MUX_s_1_2_2(FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_itm_6_1, FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs,
          and_35_rgt);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_2
          <= 1'b0;
    end
    else if ( core_wen & ((or_cse & FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1) |
        and_37_rgt) & mux_tmp ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_2
          <= MUX_s_1_2_2(FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1, FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs,
          and_37_rgt);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_st_2
          <= 1'b0;
    end
    else if ( core_wen & (~ and_dcpl_8) & (mux_6_nl) ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_st_2
          <= FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs
          <= 1'b0;
    end
    else if ( core_wen & (~(and_dcpl_8 | (~ FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1)
        | (~ chn_a_rsci_bawt) | FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1
        | (fsm_output[0]))) ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs
          <= FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_itm_6_1;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs
          <= 1'b0;
    end
    else if ( core_wen & (~(and_dcpl_8 | (~ FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1)
        | (~ chn_a_rsci_bawt) | (fsm_output[0]))) ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs
          <= FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1;
    end
  end
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_mux_nl = MUX_v_10_2_2((FpMantDecShiftRight_10U_6U_10U_o_mant_sum_sva[9:0]),
      (FpExpoWidthDec_6U_5U_10U_1U_1U_bits_sva_1_14_0_1[9:0]), FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_2);
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_not_16_nl = ~ FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_2;
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_nand_nl = ~(MUX_v_10_2_2(10'b0000000000,
      (FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_mux_nl), (FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_not_16_nl)));
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_FpExpoWidthDec_6U_5U_10U_1U_1U_FpExpoWidthDec_6U_5U_10U_1U_1U_nand_nl
      = ~(MUX_v_10_2_2(10'b0000000000, (FpExpoWidthDec_6U_5U_10U_1U_1U_nand_nl),
      FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_2));
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_mux_6_nl = MUX_v_4_2_2(({3'b0 ,
      (FpMantDecShiftRight_10U_6U_10U_o_mant_sum_sva[10])}), (FpExpoWidthDec_6U_5U_10U_1U_1U_bits_sva_1_14_0_1[13:10]),
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_2);
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_not_15_nl = ~ FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_2;
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_else_FpExpoWidthDec_6U_5U_10U_1U_1U_else_and_2_nl
      = MUX_v_4_2_2(4'b0000, (FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_mux_6_nl),
      (FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_not_15_nl));
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_mux_6_nl = MUX_v_4_2_2(4'b1110, (FpExpoWidthDec_6U_5U_10U_1U_1U_else_FpExpoWidthDec_6U_5U_10U_1U_1U_else_and_2_nl),
      FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_2);
  assign nl_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_if_i_shift_acc_psp_1_sva_2
      = (~ (chn_a_rsci_d_mxwt[13:11])) + 3'b1;
  assign nor_7_nl = ~(FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_itm_6_1 | FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1
      | (~ and_tmp_1));
  assign or_6_nl = FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_itm_6_1 | FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1;
  assign mux_2_nl = MUX_s_1_2_2(mux_1_itm, (~ or_tmp_7), or_6_nl);
  assign or_3_nl = FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_st_2
      | (~ main_stage_v_1) | FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_st_2;
  assign mux_3_nl = MUX_s_1_2_2((mux_2_nl), (nor_7_nl), or_3_nl);
  assign nor_nl = ~(FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1 | (~ and_tmp_1));
  assign mux_4_nl = MUX_s_1_2_2(mux_1_itm, (~ or_tmp_7), FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1);
  assign or_10_nl = (~ main_stage_v_1) | FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_st_2;
  assign mux_5_nl = MUX_s_1_2_2((mux_4_nl), (nor_nl), or_10_nl);
  assign and_60_nl = main_stage_v_1 & FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_2;
  assign mux_6_nl = MUX_s_1_2_2(and_tmp_1, or_tmp_8, and_60_nl);

  function [0:0] MUX1HOT_s_1_1_2;
    input [0:0] input_0;
    input [0:0] sel;
    reg [0:0] result;
  begin
    result = input_0 & {1{sel[0]}};
    MUX1HOT_s_1_1_2 = result;
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


  function [0:0] readslicef_5_1_4;
    input [4:0] vector;
    reg [4:0] tmp;
  begin
    tmp = vector >> 4;
    readslicef_5_1_4 = tmp[0:0];
  end
  endfunction


  function [0:0] readslicef_6_1_5;
    input [5:0] vector;
    reg [5:0] tmp;
  begin
    tmp = vector >> 5;
    readslicef_6_1_5 = tmp[0:0];
  end
  endfunction


  function [0:0] readslicef_7_1_6;
    input [6:0] vector;
    reg [6:0] tmp;
  begin
    tmp = vector >> 6;
    readslicef_7_1_6 = tmp[0:0];
  end
  endfunction


  function  [4:0] conv_u2s_4_5 ;
    input [3:0]  vector ;
  begin
    conv_u2s_4_5 =  {1'b0, vector};
  end
  endfunction


  function  [6:0] conv_u2s_6_7 ;
    input [5:0]  vector ;
  begin
    conv_u2s_6_7 =  {1'b0, vector};
  end
  endfunction


  function  [10:0] conv_u2u_1_11 ;
    input [0:0]  vector ;
  begin
    conv_u2u_1_11 = {{10{1'b0}}, vector};
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
//  Design Unit:    HLS_fp17_to_fp16
// ------------------------------------------------------------------


module HLS_fp17_to_fp16 (
  nvdla_core_clk, nvdla_core_rstn, chn_a_rsc_z, chn_a_rsc_vz, chn_a_rsc_lz, chn_o_rsc_z,
      chn_o_rsc_vz, chn_o_rsc_lz
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [16:0] chn_a_rsc_z;
  input chn_a_rsc_vz;
  output chn_a_rsc_lz;
  output [15:0] chn_o_rsc_z;
  input chn_o_rsc_vz;
  output chn_o_rsc_lz;


  // Interconnect Declarations
  wire chn_a_rsci_oswt;
  wire chn_a_rsci_oswt_unreg;
  wire chn_o_rsci_oswt;
  wire chn_o_rsci_oswt_unreg;


  // Interconnect Declarations for Component Instantiations 
  FP17_TO_FP16_chn_a_rsci_unreg chn_a_rsci_unreg_inst (
      .in_0(chn_a_rsci_oswt_unreg),
      .outsig(chn_a_rsci_oswt)
    );
  FP17_TO_FP16_chn_o_rsci_unreg chn_o_rsci_unreg_inst (
      .in_0(chn_o_rsci_oswt_unreg),
      .outsig(chn_o_rsci_oswt)
    );
  HLS_fp17_to_fp16_core HLS_fp17_to_fp16_core_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_a_rsc_z(chn_a_rsc_z),
      .chn_a_rsc_vz(chn_a_rsc_vz),
      .chn_a_rsc_lz(chn_a_rsc_lz),
      .chn_o_rsc_z(chn_o_rsc_z),
      .chn_o_rsc_vz(chn_o_rsc_vz),
      .chn_o_rsc_lz(chn_o_rsc_lz),
      .chn_a_rsci_oswt(chn_a_rsci_oswt),
      .chn_a_rsci_oswt_unreg(chn_a_rsci_oswt_unreg),
      .chn_o_rsci_oswt(chn_o_rsci_oswt),
      .chn_o_rsci_oswt_unreg(chn_o_rsci_oswt_unreg)
    );
endmodule



