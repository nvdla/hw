// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: HLS_cdp_ocvt.v

module CDP_OCVT_mgc_in_wire_wait_v1 (ld, vd, d, lz, vz, z);

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


//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/siflibs/CDP_OCVT_mgc_out_stdreg_wait_v1.v 
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


module CDP_OCVT_mgc_out_stdreg_wait_v1 (ld, vd, d, lz, vz, z);

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



//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/siflibs/CDP_OCVT_mgc_in_wire_v1.v 
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


module CDP_OCVT_mgc_in_wire_v1 (d, z);

  parameter integer rscid = 1;
  parameter integer width = 8;

  output [width-1:0] d;
  input  [width-1:0] z;

  wire   [width-1:0] d;

  assign d = z;

endmodule


//------> /home/tools/calypto/catapult-10.0-264918/Mgc_home/pkgs/siflibs/mgc_shift_r_beh_v4.v 
module CDP_OCVT_mgc_shift_r_v4(a,s,z);
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
module CDP_OCVT_mgc_shift_bl_v4(a,s,z);
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
module CDP_OCVT_mgc_shift_l_v4(a,s,z);
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
//  Generated by:   ezhang@hk-sim-11-186
//  Generated date: Tue Jul  4 15:52:44 2017
// ----------------------------------------------------------------------

// 
// ------------------------------------------------------------------
//  Design Unit:    CDP_OCVT_chn_data_out_rsci_unreg
// ------------------------------------------------------------------


module CDP_OCVT_chn_data_out_rsci_unreg (
  in_0, outsig
);
  input in_0;
  output outsig;



  // Interconnect Declarations for Component Instantiations 
  assign outsig = in_0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    CDP_OCVT_chn_data_in_rsci_unreg
// ------------------------------------------------------------------


module CDP_OCVT_chn_data_in_rsci_unreg (
  in_0, outsig
);
  input in_0;
  output outsig;



  // Interconnect Declarations for Component Instantiations 
  assign outsig = in_0;
endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_cdp_ocvt_core_core_fsm
//  FSM Module
// ------------------------------------------------------------------


module HLS_cdp_ocvt_core_core_fsm (
  nvdla_core_clk, nvdla_core_rstn, core_wen, fsm_output
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input core_wen;
  output [1:0] fsm_output;
  reg [1:0] fsm_output;


  // FSM State Type Declaration for HLS_cdp_ocvt_core_core_fsm_1
  parameter
    core_rlp_C_0 = 1'd0,
    main_C_0 = 1'd1;

  reg [0:0] state_var;
  reg [0:0] state_var_NS;


  // Interconnect Declarations for Component Instantiations 
  always @(*)
  begin : HLS_cdp_ocvt_core_core_fsm_1
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
//  Design Unit:    HLS_cdp_ocvt_core_staller
// ------------------------------------------------------------------


module HLS_cdp_ocvt_core_staller (
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
//  Design Unit:    HLS_cdp_ocvt_core_chn_data_out_rsci_chn_data_out_wait_dp
// ------------------------------------------------------------------


module HLS_cdp_ocvt_core_chn_data_out_rsci_chn_data_out_wait_dp (
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
//  Design Unit:    HLS_cdp_ocvt_core_chn_data_out_rsci_chn_data_out_wait_ctrl
// ------------------------------------------------------------------


module HLS_cdp_ocvt_core_chn_data_out_rsci_chn_data_out_wait_ctrl (
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
//  Design Unit:    HLS_cdp_ocvt_core_chn_data_in_rsci_chn_data_in_wait_dp
// ------------------------------------------------------------------


module HLS_cdp_ocvt_core_chn_data_in_rsci_chn_data_in_wait_dp (
  nvdla_core_clk, nvdla_core_rstn, chn_data_in_rsci_oswt, chn_data_in_rsci_bawt,
      chn_data_in_rsci_wen_comp, chn_data_in_rsci_d_mxwt, chn_data_in_rsci_biwt,
      chn_data_in_rsci_bdwt, chn_data_in_rsci_d
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input chn_data_in_rsci_oswt;
  output chn_data_in_rsci_bawt;
  output chn_data_in_rsci_wen_comp;
  output [49:0] chn_data_in_rsci_d_mxwt;
  input chn_data_in_rsci_biwt;
  input chn_data_in_rsci_bdwt;
  input [49:0] chn_data_in_rsci_d;


  // Interconnect Declarations
  reg chn_data_in_rsci_bcwt;
  reg [49:0] chn_data_in_rsci_d_bfwt;


  // Interconnect Declarations for Component Instantiations 
  assign chn_data_in_rsci_bawt = chn_data_in_rsci_biwt | chn_data_in_rsci_bcwt;
  assign chn_data_in_rsci_wen_comp = (~ chn_data_in_rsci_oswt) | chn_data_in_rsci_bawt;
  assign chn_data_in_rsci_d_mxwt = MUX_v_50_2_2(chn_data_in_rsci_d, chn_data_in_rsci_d_bfwt,
      chn_data_in_rsci_bcwt);
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_data_in_rsci_bcwt <= 1'b0;
      chn_data_in_rsci_d_bfwt <= 50'b0;
    end
    else begin
      chn_data_in_rsci_bcwt <= ~((~(chn_data_in_rsci_bcwt | chn_data_in_rsci_biwt))
          | chn_data_in_rsci_bdwt);
      chn_data_in_rsci_d_bfwt <= chn_data_in_rsci_d_mxwt;
    end
  end

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

endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_cdp_ocvt_core_chn_data_in_rsci_chn_data_in_wait_ctrl
// ------------------------------------------------------------------


module HLS_cdp_ocvt_core_chn_data_in_rsci_chn_data_in_wait_ctrl (
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
//  Design Unit:    HLS_cdp_ocvt_core_chn_data_out_rsci
// ------------------------------------------------------------------


module HLS_cdp_ocvt_core_chn_data_out_rsci (
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
  CDP_OCVT_mgc_out_stdreg_wait_v1 #(.rscid(32'sd6),
  .width(32'sd18)) chn_data_out_rsci (
      .ld(chn_data_out_rsci_ld_core_sct),
      .vd(chn_data_out_rsci_vd),
      .d(chn_data_out_rsci_d),
      .lz(chn_data_out_rsc_lz),
      .vz(chn_data_out_rsc_vz),
      .z(chn_data_out_rsc_z)
    );
  HLS_cdp_ocvt_core_chn_data_out_rsci_chn_data_out_wait_ctrl HLS_cdp_ocvt_core_chn_data_out_rsci_chn_data_out_wait_ctrl_inst
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
  HLS_cdp_ocvt_core_chn_data_out_rsci_chn_data_out_wait_dp HLS_cdp_ocvt_core_chn_data_out_rsci_chn_data_out_wait_dp_inst
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
//  Design Unit:    HLS_cdp_ocvt_core_chn_data_in_rsci
// ------------------------------------------------------------------


module HLS_cdp_ocvt_core_chn_data_in_rsci (
  nvdla_core_clk, nvdla_core_rstn, chn_data_in_rsc_z, chn_data_in_rsc_vz, chn_data_in_rsc_lz,
      chn_data_in_rsci_oswt, core_wen, chn_data_in_rsci_iswt0, chn_data_in_rsci_bawt,
      chn_data_in_rsci_wen_comp, chn_data_in_rsci_ld_core_psct, chn_data_in_rsci_d_mxwt,
      core_wten
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [49:0] chn_data_in_rsc_z;
  input chn_data_in_rsc_vz;
  output chn_data_in_rsc_lz;
  input chn_data_in_rsci_oswt;
  input core_wen;
  input chn_data_in_rsci_iswt0;
  output chn_data_in_rsci_bawt;
  output chn_data_in_rsci_wen_comp;
  input chn_data_in_rsci_ld_core_psct;
  output [49:0] chn_data_in_rsci_d_mxwt;
  input core_wten;


  // Interconnect Declarations
  wire chn_data_in_rsci_biwt;
  wire chn_data_in_rsci_bdwt;
  wire chn_data_in_rsci_ld_core_sct;
  wire chn_data_in_rsci_vd;
  wire [49:0] chn_data_in_rsci_d;


  // Interconnect Declarations for Component Instantiations 
  CDP_OCVT_mgc_in_wire_wait_v1 #(.rscid(32'sd1),
  .width(32'sd50)) chn_data_in_rsci (
      .ld(chn_data_in_rsci_ld_core_sct),
      .vd(chn_data_in_rsci_vd),
      .d(chn_data_in_rsci_d),
      .lz(chn_data_in_rsc_lz),
      .vz(chn_data_in_rsc_vz),
      .z(chn_data_in_rsc_z)
    );
  HLS_cdp_ocvt_core_chn_data_in_rsci_chn_data_in_wait_ctrl HLS_cdp_ocvt_core_chn_data_in_rsci_chn_data_in_wait_ctrl_inst
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
  HLS_cdp_ocvt_core_chn_data_in_rsci_chn_data_in_wait_dp HLS_cdp_ocvt_core_chn_data_in_rsci_chn_data_in_wait_dp_inst
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
//  Design Unit:    HLS_cdp_ocvt_core
// ------------------------------------------------------------------


module HLS_cdp_ocvt_core (
  nvdla_core_clk, nvdla_core_rstn, chn_data_in_rsc_z, chn_data_in_rsc_vz, chn_data_in_rsc_lz,
      cfg_alu_in_rsc_z, cfg_mul_in_rsc_z, cfg_truncate_rsc_z, cfg_precision_rsc_z,
      chn_data_out_rsc_z, chn_data_out_rsc_vz, chn_data_out_rsc_lz, chn_data_in_rsci_oswt,
      chn_data_in_rsci_oswt_unreg, chn_data_out_rsci_oswt, chn_data_out_rsci_oswt_unreg
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [49:0] chn_data_in_rsc_z;
  input chn_data_in_rsc_vz;
  output chn_data_in_rsc_lz;
  input [31:0] cfg_alu_in_rsc_z;
  input [15:0] cfg_mul_in_rsc_z;
  input [5:0] cfg_truncate_rsc_z;
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
  wire [49:0] chn_data_in_rsci_d_mxwt;
  wire core_wten;
  wire [31:0] cfg_alu_in_rsci_d;
  wire [15:0] cfg_mul_in_rsci_d;
  wire [5:0] cfg_truncate_rsci_d;
  wire [1:0] cfg_precision_rsci_d;
  reg chn_data_out_rsci_iswt0;
  wire chn_data_out_rsci_bawt;
  wire chn_data_out_rsci_wen_comp;
  reg chn_data_out_rsci_d_17;
  reg chn_data_out_rsci_d_16;
  reg chn_data_out_rsci_d_15;
  reg chn_data_out_rsci_d_14;
  reg [3:0] chn_data_out_rsci_d_13_10;
  reg chn_data_out_rsci_d_9;
  reg chn_data_out_rsci_d_8;
  reg chn_data_out_rsci_d_7;
  reg [5:0] chn_data_out_rsci_d_6_1;
  reg chn_data_out_rsci_d_0;
  wire [1:0] fsm_output;
  wire IntShiftRightSat_50U_6U_16U_IntShiftRightSat_50U_6U_16U_oelse_IntShiftRightSat_50U_6U_16U_if_unequal_tmp;
  wire IntShiftRight_42U_6U_8U_1_obits_fixed_nand_tmp;
  wire [42:0] IntShiftRight_42U_6U_8U_1_obits_fixed_acc_tmp;
  wire [43:0] nl_IntShiftRight_42U_6U_8U_1_obits_fixed_acc_tmp;
  wire IntShiftRight_42U_6U_8U_obits_fixed_nand_tmp;
  wire [42:0] IntShiftRight_42U_6U_8U_obits_fixed_acc_tmp;
  wire [43:0] nl_IntShiftRight_42U_6U_8U_obits_fixed_acc_tmp;
  wire and_dcpl_6;
  wire and_dcpl_9;
  wire and_dcpl_10;
  wire and_dcpl_12;
  wire and_dcpl_15;
  wire and_dcpl_16;
  wire or_tmp_11;
  wire or_tmp_17;
  wire or_tmp_25;
  wire or_tmp_28;
  wire not_tmp_24;
  wire not_tmp_25;
  wire mux_tmp_22;
  wire or_tmp_39;
  wire or_tmp_59;
  wire not_tmp_42;
  wire mux_tmp_41;
  wire or_tmp_71;
  wire nor_tmp_26;
  wire mux_tmp_50;
  wire nor_tmp_29;
  wire not_tmp_57;
  wire or_tmp_94;
  wire and_tmp_6;
  wire or_tmp_117;
  wire mux_tmp_66;
  wire and_dcpl_22;
  wire and_dcpl_24;
  wire and_dcpl_25;
  wire and_dcpl_35;
  wire and_dcpl_40;
  wire and_dcpl_41;
  wire or_dcpl_10;
  wire or_tmp_146;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs;
  reg IntShiftRightSat_42U_6U_8U_1_lor_lpi_1_dfm;
  reg main_stage_v_1;
  reg main_stage_v_2;
  reg main_stage_v_3;
  reg IsNaN_6U_10U_land_lpi_1_dfm_4;
  reg IsNaN_6U_10U_land_lpi_1_dfm_5;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_4;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_5;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_6;
  reg IntShiftRightSat_50U_6U_16U_o_15_sva_3;
  reg IntShiftRightSat_50U_6U_16U_o_15_sva_4;
  reg IntShiftRightSat_50U_6U_16U_o_0_sva_3;
  reg IntShiftRightSat_50U_6U_16U_o_0_sva_4;
  reg [15:0] cfg_mul_in_1_sva_3;
  reg [5:0] cfg_truncate_1_sva_3;
  reg [5:0] cfg_truncate_1_sva_4;
  reg equal_tmp_2;
  reg nor_tmp_42;
  reg nor_tmp_43;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_3;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_4;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_3;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_4;
  reg [9:0] FpMantDecShiftRight_10U_6U_10U_least_bits_9_0_sva_2;
  reg [41:0] IntMulExt_26U_16U_42U_return_sva_2;
  reg IntShiftRight_42U_6U_8U_obits_fixed_nor_ovfl_sva_2;
  reg [41:0] IntShiftRightSat_42U_6U_8U_i_sva_2;
  reg IntShiftRight_42U_6U_8U_1_obits_fixed_nor_ovfl_sva_2;
  reg [41:0] IntShiftRightSat_42U_6U_8U_1_i_sva_2;
  reg [49:0] IntMulExt_34U_16U_50U_return_sva_2;
  reg [10:0] FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_itm_2;
  reg FpMantDecShiftRight_10U_6U_10U_guard_or_itm_2;
  reg FpMantDecShiftRight_10U_6U_10U_least_bits_slc_FpMantDecShiftRight_10U_6U_10U_least_mask_10_itm_2;
  reg IsNaN_6U_10U_nor_itm_2;
  reg IsNaN_6U_10U_IsNaN_6U_10U_nand_itm_2;
  reg [25:0] IntSubExt_25U_25U_26U_o_acc_itm_2;
  wire [26:0] nl_IntSubExt_25U_25U_26U_o_acc_itm_2;
  reg IntShiftRight_42U_6U_8U_obits_fixed_nand_itm_2;
  reg [5:0] IntShiftRight_42U_6U_8U_obits_fixed_nor_2_itm_2;
  reg [25:0] IntSubExt_25U_25U_26U_1_o_acc_itm_2;
  wire [26:0] nl_IntSubExt_25U_25U_26U_1_o_acc_itm_2;
  reg IntShiftRight_42U_6U_8U_1_obits_fixed_nand_itm_2;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_FpExpoWidthDec_6U_5U_10U_1U_1U_or_2_itm_2;
  reg [1:0] io_read_cfg_precision_rsc_svs_st_4;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_st_3;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_st_3;
  reg [1:0] io_read_cfg_precision_rsc_svs_st_5;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_st_4;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_st_4;
  reg FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_st_4;
  reg [1:0] io_read_cfg_precision_rsc_svs_st_6;
  reg [16:0] i_data_sva_1_16_0_1;
  reg i_data_sva_2_16_1;
  reg [14:0] i_data_sva_2_14_0_1;
  reg IntShiftRight_42U_6U_8U_obits_fixed_acc_sat_sva_1_42_1;
  reg IntShiftRight_42U_6U_8U_obits_fixed_acc_sat_sva_1_7_1;
  reg IntShiftRight_42U_6U_8U_obits_fixed_acc_sat_sva_1_0_1;
  reg IntShiftRight_42U_6U_8U_1_obits_fixed_acc_sat_sva_1_42_1;
  reg IntShiftRight_42U_6U_8U_1_obits_fixed_acc_sat_sva_1_7_1;
  reg IntShiftRight_42U_6U_8U_1_obits_fixed_acc_sat_sva_1_0_1;
  wire main_stage_en_1;
  wire [112:0] IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva;
  wire [50:0] IntShiftRight_50U_6U_16U_obits_fixed_acc_sat_sva;
  wire [51:0] nl_IntShiftRight_50U_6U_16U_obits_fixed_acc_sat_sva;
  wire IntShiftRightSat_42U_6U_8U_1_o_7_sva;
  wire IntShiftRightSat_42U_6U_8U_o_7_sva;
  wire [5:0] IntShiftRightSat_42U_6U_8U_1_o_6_1_sva;
  wire IntShiftRightSat_42U_6U_8U_1_o_0_sva;
  wire [5:0] IntShiftRightSat_42U_6U_8U_o_6_1_sva;
  wire IntShiftRightSat_42U_6U_8U_o_0_sva;
  wire chn_data_out_and_cse;
  wire or_2_cse;
  wire nor_82_cse;
  wire or_28_cse;
  wire or_27_cse;
  wire and_133_cse;
  wire nor_10_cse;
  reg reg_chn_data_out_rsci_ld_core_psct_cse;
  wire or_16_cse;
  wire and_137_cse;
  wire and_135_cse;
  wire or_64_cse;
  wire or_112_cse;
  wire and_70_cse;
  wire or_7_cse;
  wire and_dcpl_52;
  wire nor_tmp;
  wire or_tmp_164;
  wire and_89_rgt;
  wire and_92_rgt;
  wire [49:0] IntShiftRightSat_50U_6U_16U_i_mux1h_1_itm;
  reg [7:0] reg_IntShiftRightSat_50U_6U_16U_i_itm;
  reg [41:0] reg_IntShiftRightSat_50U_6U_16U_i_1_itm;
  wire [13:0] IntShiftRightSat_50U_6U_16U_o_mux1h_2_itm;
  reg [2:0] reg_IntShiftRightSat_50U_6U_16U_o_14_1_itm;
  reg [10:0] reg_IntShiftRightSat_50U_6U_16U_o_14_1_2_itm;
  wire [41:0] IntShiftRightSat_42U_6U_8U_i_rshift_itm;
  wire [41:0] IntShiftRightSat_42U_6U_8U_1_i_rshift_itm;
  wire [5:0] IntShiftRight_42U_6U_8U_1_obits_fixed_mux1h_4_itm;
  reg [1:0] reg_IntShiftRight_42U_6U_8U_1_obits_fixed_nor_2_itm;
  reg [3:0] reg_IntShiftRight_42U_6U_8U_1_obits_fixed_nor_2_1_itm;
  reg [9:0] reg_IntShiftRightSat_50U_6U_16U_o_14_1_3_itm;
  wire [10:0] FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_itm;
  wire mux_75_itm;
  wire chn_data_in_rsci_ld_core_psct_mx0c0;
  wire HLS_cdp_ocvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_1_sig_mx0w1;
  wire HLS_cdp_ocvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_2_sig_mx0w1;
  wire main_stage_v_1_mx0c1;
  wire main_stage_v_2_mx0c1;
  wire [49:0] IntShiftRightSat_50U_6U_16U_i_sva_mx0w0;
  wire IntShiftRightSat_50U_6U_16U_o_15_sva_mx0w0;
  wire [13:0] IntShiftRightSat_50U_6U_16U_o_14_1_sva_mx0w0;
  wire IntShiftRightSat_50U_6U_16U_o_0_sva_mx0w0;
  wire main_stage_v_3_mx0c1;
  wire IntShiftRightSat_42U_6U_8U_1_lor_lpi_1_dfm_mx1w0;
  wire IntShiftRight_42U_6U_8U_1_obits_fixed_nor_ovfl_sva_mx0w0;
  wire IntShiftRight_42U_6U_8U_obits_fixed_nor_ovfl_sva_mx0w0;
  wire [10:0] FpMantDecShiftRight_10U_6U_10U_guard_mask_sva_mx0w0;
  wire [4:0] FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_i_shift_acc_psp_sva;
  wire [5:0] nl_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_i_shift_acc_psp_sva;
  wire nor_dfs;
  wire IntShiftRight_50U_6U_16U_obits_fixed_and_unfl_sva;
  wire IntShiftRight_50U_6U_16U_obits_fixed_nor_ovfl_sva;
  wire [10:0] FpMantDecShiftRight_10U_6U_10U_o_mant_sum_sva;
  wire [11:0] nl_FpMantDecShiftRight_10U_6U_10U_o_mant_sum_sva;
  wire [9:0] FpMantDecShiftRight_10U_6U_10U_stick_bits_9_0_sva;
  wire [10:0] FpMantDecShiftRight_10U_6U_10U_stick_mask_sva;
  wire [11:0] nl_FpMantDecShiftRight_10U_6U_10U_stick_mask_sva;
  wire [104:0] IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva;
  wire [104:0] IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva;
  wire [10:0] FpMantDecShiftRight_10U_6U_10U_least_mask_sva;
  wire [9:0] FpMantDecShiftRight_10U_6U_10U_guard_bits_9_0_sva;
  wire mux_84_tmp;
  wire and_86_tmp;
  wire and_187_ssc;
  reg [2:0] reg_IntShiftRightSat_50U_6U_16U_o_14_1_1_itm_3_1;
  reg reg_IntShiftRightSat_50U_6U_16U_o_14_1_1_itm_0;
  wire FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_or_1_cse;
  wire IntShiftRightSat_50U_6U_16U_o_and_cse;
  wire IntShiftRightSat_42U_6U_8U_i_and_cse;
  wire and_183_cse;
  wire FpExpoWidthDec_6U_5U_10U_1U_1U_if_FpExpoWidthDec_6U_5U_10U_1U_1U_if_or_cse;
  wire FpExpoWidthDec_6U_5U_10U_1U_1U_if_and_3_cse;
  wire and_173_cse;
  wire FpMantDecShiftRight_10U_6U_10U_i_mant_s_and_cse;
  wire cfg_truncate_and_1_cse;
  wire IsNaN_6U_10U_and_cse;
  wire IntSubExt_25U_25U_26U_1_o_and_cse;
  wire or_209_cse;
  wire nor_77_cse;
  wire FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_itm_6;
  wire FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1;
  wire FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1;

  wire[0:0] shift_0_prb;
  wire[0:0] and_15;
  wire[0:0] iExpoWidth_oExpoWidth_prb;
  wire[0:0] or_132;
  wire[0:0] oWidth_mWidth_prb;
  wire[0:0] oWidth_aWidth_bWidth_prb;
  wire[0:0] oWidth_mWidth_prb_1;
  wire[0:0] oWidth_aWidth_bWidth_prb_1;
  wire[0:0] oWidth_mWidth_prb_2;
  wire[0:0] oWidth_aWidth_bWidth_prb_2;
  wire[3:0] FpExpoWidthDec_6U_5U_10U_1U_1U_FpExpoWidthDec_6U_5U_10U_1U_1U_or_3_nl;
  wire[3:0] FpExpoWidthDec_6U_5U_10U_1U_1U_mux_6_nl;
  wire[0:0] mux_nl;
  wire[0:0] IntShiftRightSat_42U_6U_8U_if_IntShiftRightSat_42U_6U_8U_if_or_1_nl;
  wire[8:0] IntShiftRightSat_42U_6U_8U_oif_1_acc_nl;
  wire[9:0] nl_IntShiftRightSat_42U_6U_8U_oif_1_acc_nl;
  wire[8:0] IntShiftRightSat_42U_6U_8U_oif_acc_nl;
  wire[9:0] nl_IntShiftRightSat_42U_6U_8U_oif_acc_nl;
  wire[8:0] IntShiftRightSat_42U_6U_8U_1_oif_1_acc_nl;
  wire[9:0] nl_IntShiftRightSat_42U_6U_8U_1_oif_1_acc_nl;
  wire[0:0] IntShiftRightSat_42U_6U_8U_1_oelse_mux_1_nl;
  wire[0:0] mux_8_nl;
  wire[0:0] nor_nl;
  wire[0:0] and_151_nl;
  wire[0:0] mux_10_nl;
  wire[0:0] nor_87_nl;
  wire[0:0] mux_9_nl;
  wire[0:0] or_11_nl;
  wire[0:0] or_8_nl;
  wire[0:0] mux_12_nl;
  wire[0:0] mux_11_nl;
  wire[0:0] or_13_nl;
  wire[0:0] and_149_nl;
  wire[0:0] and_150_nl;
  wire[0:0] mux_15_nl;
  wire[0:0] mux_18_nl;
  wire[0:0] mux_16_nl;
  wire[0:0] and_147_nl;
  wire[0:0] mux_17_nl;
  wire[0:0] and_148_nl;
  wire[0:0] mux_21_nl;
  wire[0:0] mux_20_nl;
  wire[0:0] mux_19_nl;
  wire[0:0] nand_1_nl;
  wire[0:0] nor_9_nl;
  wire[0:0] and_146_nl;
  wire[0:0] or_24_nl;
  wire[0:0] mux_24_nl;
  wire[0:0] mux_23_nl;
  wire[0:0] mux_22_nl;
  wire[41:0] IntMulExt_26U_16U_42U_1_o_mul_nl;
  wire[0:0] mux_80_nl;
  wire[0:0] or_144_nl;
  wire[0:0] nor_43_nl;
  wire[0:0] mux_85_nl;
  wire[0:0] mux_33_nl;
  wire[0:0] mux_32_nl;
  wire[0:0] and_197_nl;
  wire[0:0] and_142_nl;
  wire[0:0] mux_82_nl;
  wire[0:0] nor_95_nl;
  wire[0:0] mux_81_nl;
  wire[0:0] or_148_nl;
  wire[0:0] mux_39_nl;
  wire[0:0] nor_73_nl;
  wire[0:0] IntShiftRightSat_50U_6U_16U_if_IntShiftRightSat_50U_6U_16U_if_or_1_nl;
  wire[16:0] IntShiftRightSat_50U_6U_16U_oif_1_acc_nl;
  wire[17:0] nl_IntShiftRightSat_50U_6U_16U_oif_1_acc_nl;
  wire[16:0] IntShiftRightSat_50U_6U_16U_oif_acc_nl;
  wire[17:0] nl_IntShiftRightSat_50U_6U_16U_oif_acc_nl;
  wire[0:0] mux_41_nl;
  wire[0:0] mux_40_nl;
  wire[0:0] nor_70_nl;
  wire[0:0] and_139_nl;
  wire[0:0] mux_42_nl;
  wire[0:0] nor_67_nl;
  wire[0:0] nor_69_nl;
  wire[0:0] mux_48_nl;
  wire[0:0] mux_43_nl;
  wire[0:0] mux_47_nl;
  wire[0:0] mux_44_nl;
  wire[0:0] mux_46_nl;
  wire[0:0] mux_45_nl;
  wire[0:0] nor_63_nl;
  wire[0:0] mux_52_nl;
  wire[0:0] nor_60_nl;
  wire[0:0] mux_51_nl;
  wire[0:0] nor_61_nl;
  wire[0:0] mux_50_nl;
  wire[0:0] or_69_nl;
  wire[3:0] FpExpoWidthDec_6U_5U_10U_1U_1U_else_FpExpoWidthDec_6U_5U_10U_1U_1U_else_and_2_nl;
  wire[3:0] FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_mux_6_nl;
  wire[0:0] FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_not_15_nl;
  wire[5:0] IntShiftRight_42U_6U_8U_1_obits_fixed_nor_2_nl;
  wire[0:0] mux_83_nl;
  wire[0:0] or_152_nl;
  wire[0:0] and_83_nl;
  wire[0:0] mux_88_nl;
  wire[0:0] mux_87_nl;
  wire[0:0] nor_93_nl;
  wire[0:0] or_202_nl;
  wire[0:0] mux_56_nl;
  wire[0:0] nor_55_nl;
  wire[0:0] nand_12_nl;
  wire[0:0] or_80_nl;
  wire[0:0] mux_57_nl;
  wire[0:0] mux_60_nl;
  wire[0:0] mux_59_nl;
  wire[0:0] or_87_nl;
  wire[0:0] or_85_nl;
  wire[0:0] or_153_nl;
  wire[9:0] FpExpoWidthDec_6U_5U_10U_1U_1U_FpExpoWidthDec_6U_5U_10U_1U_1U_FpExpoWidthDec_6U_5U_10U_1U_1U_nand_nl;
  wire[9:0] FpExpoWidthDec_6U_5U_10U_1U_1U_nand_nl;
  wire[9:0] FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_mux_nl;
  wire[0:0] FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_not_13_nl;
  wire[0:0] IntShiftRightSat_50U_6U_16U_o_IntShiftRightSat_50U_6U_16U_o_nor_nl;
  wire[0:0] IntShiftRightSat_50U_6U_16U_o_and_7_nl;
  wire[0:0] mux_62_nl;
  wire[0:0] or_89_nl;
  wire[0:0] mux_61_nl;
  wire[0:0] nor_53_nl;
  wire[0:0] and_131_nl;
  wire[0:0] mux_64_nl;
  wire[0:0] or_94_nl;
  wire[0:0] mux_63_nl;
  wire[0:0] nor_52_nl;
  wire[0:0] or_91_nl;
  wire[0:0] mux_66_nl;
  wire[0:0] mux_65_nl;
  wire[0:0] or_100_nl;
  wire[33:0] IntSubExt_33U_32U_34U_o_acc_nl;
  wire[34:0] nl_IntSubExt_33U_32U_34U_o_acc_nl;
  wire[0:0] mux_67_nl;
  wire[0:0] nand_9_nl;
  wire[0:0] and_130_nl;
  wire[0:0] mux_69_nl;
  wire[0:0] mux_68_nl;
  wire[0:0] nand_7_nl;
  wire[0:0] nor_37_nl;
  wire[0:0] mux_70_nl;
  wire[0:0] and_129_nl;
  wire[0:0] nor_49_nl;
  wire[0:0] mux_72_nl;
  wire[0:0] nor_46_nl;
  wire[0:0] mux_71_nl;
  wire[0:0] mux_76_nl;
  wire[0:0] nor_6_nl;
  wire[0:0] mux_78_nl;
  wire[0:0] nor_44_nl;
  wire[0:0] mux_77_nl;
  wire[0:0] or_133_nl;
  wire[0:0] or_134_nl;
  wire[6:0] FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_nl;
  wire[7:0] nl_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_nl;
  wire[5:0] FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_nl;
  wire[6:0] nl_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_nl;
  wire[6:0] FpExpoWidthDec_6U_5U_10U_1U_1U_acc_nl;
  wire[7:0] nl_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_nl;
  wire[13:0] IntShiftRight_50U_6U_16U_obits_fixed_nor_2_nl;
  wire[8:0] IntShiftRightSat_42U_6U_8U_1_oif_acc_nl;
  wire[9:0] nl_IntShiftRightSat_42U_6U_8U_1_oif_acc_nl;
  wire[0:0] IntShiftRight_42U_6U_8U_1_obits_fixed_and_nl;
  wire[0:0] IntShiftRight_42U_6U_8U_obits_fixed_and_nl;
  wire[0:0] IntShiftRight_50U_6U_16U_obits_fixed_and_nl;
  wire[0:0] FpMantDecShiftRight_10U_6U_10U_carry_and_nl;
  wire[0:0] mux_28_nl;
  wire[0:0] or_37_nl;
  wire[0:0] nor_78_nl;
  wire[0:0] nor_62_nl;
  wire[0:0] nor_54_nl;
  wire[0:0] mux_73_nl;
  wire[0:0] nor_45_nl;

  // Interconnect Declarations for Component Instantiations 
  wire [10:0] nl_FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_rg_a;
  assign nl_FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_rg_a = {1'b1 , (i_data_sva_1_16_0_1[9:0])};
  wire [5:0] nl_FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_rg_s;
  assign nl_FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_rg_s = {FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_i_shift_acc_psp_sva
      , (~ (i_data_sva_1_16_0_1[10]))};
  wire [7:0] nl_FpMantDecShiftRight_10U_6U_10U_guard_mask_lshift_rg_s;
  assign nl_FpMantDecShiftRight_10U_6U_10U_guard_mask_lshift_rg_s = conv_u2s_6_7({FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_i_shift_acc_psp_sva
      , (~ (i_data_sva_1_16_0_1[10]))}) + 7'b1111111;
  wire [112:0] nl_IntShiftRight_50U_6U_16U_mbits_fixed_rshift_rg_a;
  assign nl_IntShiftRight_50U_6U_16U_mbits_fixed_rshift_rg_a = {IntMulExt_34U_16U_50U_return_sva_2
      , 63'b0};
  wire [104:0] nl_IntShiftRight_42U_6U_8U_1_mbits_fixed_rshift_rg_a;
  assign nl_IntShiftRight_42U_6U_8U_1_mbits_fixed_rshift_rg_a = {reg_IntShiftRightSat_50U_6U_16U_i_1_itm
      , 63'b0};
  wire [104:0] nl_IntShiftRight_42U_6U_8U_mbits_fixed_rshift_rg_a;
  assign nl_IntShiftRight_42U_6U_8U_mbits_fixed_rshift_rg_a = {IntMulExt_26U_16U_42U_return_sva_2
      , 63'b0};
  wire [5:0] nl_FpMantDecShiftRight_10U_6U_10U_least_mask_lshift_rg_s;
  assign nl_FpMantDecShiftRight_10U_6U_10U_least_mask_lshift_rg_s = {FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_i_shift_acc_psp_sva
      , (~ (i_data_sva_1_16_0_1[10]))};
  wire [17:0] nl_HLS_cdp_ocvt_core_chn_data_out_rsci_inst_chn_data_out_rsci_d;
  assign nl_HLS_cdp_ocvt_core_chn_data_out_rsci_inst_chn_data_out_rsci_d = {chn_data_out_rsci_d_17
      , chn_data_out_rsci_d_16 , chn_data_out_rsci_d_15 , chn_data_out_rsci_d_14
      , chn_data_out_rsci_d_13_10 , chn_data_out_rsci_d_9 , chn_data_out_rsci_d_8
      , chn_data_out_rsci_d_7 , chn_data_out_rsci_d_6_1 , chn_data_out_rsci_d_0};
  CDP_OCVT_mgc_in_wire_v1 #(.rscid(32'sd2),
  .width(32'sd32)) cfg_alu_in_rsci (
      .d(cfg_alu_in_rsci_d),
      .z(cfg_alu_in_rsc_z)
    );
  CDP_OCVT_mgc_in_wire_v1 #(.rscid(32'sd3),
  .width(32'sd16)) cfg_mul_in_rsci (
      .d(cfg_mul_in_rsci_d),
      .z(cfg_mul_in_rsc_z)
    );
  CDP_OCVT_mgc_in_wire_v1 #(.rscid(32'sd4),
  .width(32'sd6)) cfg_truncate_rsci (
      .d(cfg_truncate_rsci_d),
      .z(cfg_truncate_rsc_z)
    );
  CDP_OCVT_mgc_in_wire_v1 #(.rscid(32'sd5),
  .width(32'sd2)) cfg_precision_rsci (
      .d(cfg_precision_rsci_d),
      .z(cfg_precision_rsc_z)
    );
  CDP_OCVT_mgc_shift_r_v4 #(.width_a(32'sd42),
  .signd_a(32'sd1),
  .width_s(32'sd6),
  .width_z(32'sd42)) IntShiftRightSat_42U_6U_8U_i_rshift_rg (
      .a(IntMulExt_26U_16U_42U_return_sva_2),
      .s(cfg_truncate_1_sva_4),
      .z(IntShiftRightSat_42U_6U_8U_i_rshift_itm)
    );
  CDP_OCVT_mgc_shift_r_v4 #(.width_a(32'sd42),
  .signd_a(32'sd1),
  .width_s(32'sd6),
  .width_z(32'sd42)) IntShiftRightSat_42U_6U_8U_1_i_rshift_rg (
      .a(reg_IntShiftRightSat_50U_6U_16U_i_1_itm),
      .s(cfg_truncate_1_sva_4),
      .z(IntShiftRightSat_42U_6U_8U_1_i_rshift_itm)
    );
  CDP_OCVT_mgc_shift_r_v4 #(.width_a(32'sd11),
  .signd_a(32'sd0),
  .width_s(32'sd6),
  .width_z(32'sd11)) FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_rg (
      .a(nl_FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_rg_a[10:0]),
      .s(nl_FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_rg_s[5:0]),
      .z(FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_itm)
    );
  CDP_OCVT_mgc_shift_r_v4 #(.width_a(32'sd50),
  .signd_a(32'sd1),
  .width_s(32'sd6),
  .width_z(32'sd50)) IntShiftRightSat_50U_6U_16U_i_rshift_rg (
      .a(IntMulExt_34U_16U_50U_return_sva_2),
      .s(cfg_truncate_1_sva_3),
      .z(IntShiftRightSat_50U_6U_16U_i_sva_mx0w0)
    );
  CDP_OCVT_mgc_shift_bl_v4 #(.width_a(32'sd1),
  .signd_a(32'sd0),
  .width_s(32'sd7),
  .width_z(32'sd11)) FpMantDecShiftRight_10U_6U_10U_guard_mask_lshift_rg (
      .a(1'b1),
      .s(nl_FpMantDecShiftRight_10U_6U_10U_guard_mask_lshift_rg_s[6:0]),
      .z(FpMantDecShiftRight_10U_6U_10U_guard_mask_sva_mx0w0)
    );
  CDP_OCVT_mgc_shift_r_v4 #(.width_a(32'sd113),
  .signd_a(32'sd1),
  .width_s(32'sd6),
  .width_z(32'sd113)) IntShiftRight_50U_6U_16U_mbits_fixed_rshift_rg (
      .a(nl_IntShiftRight_50U_6U_16U_mbits_fixed_rshift_rg_a[112:0]),
      .s(cfg_truncate_1_sva_3),
      .z(IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva)
    );
  CDP_OCVT_mgc_shift_r_v4 #(.width_a(32'sd105),
  .signd_a(32'sd1),
  .width_s(32'sd6),
  .width_z(32'sd105)) IntShiftRight_42U_6U_8U_1_mbits_fixed_rshift_rg (
      .a(nl_IntShiftRight_42U_6U_8U_1_mbits_fixed_rshift_rg_a[104:0]),
      .s(cfg_truncate_1_sva_4),
      .z(IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva)
    );
  CDP_OCVT_mgc_shift_r_v4 #(.width_a(32'sd105),
  .signd_a(32'sd1),
  .width_s(32'sd6),
  .width_z(32'sd105)) IntShiftRight_42U_6U_8U_mbits_fixed_rshift_rg (
      .a(nl_IntShiftRight_42U_6U_8U_mbits_fixed_rshift_rg_a[104:0]),
      .s(cfg_truncate_1_sva_4),
      .z(IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva)
    );
  CDP_OCVT_mgc_shift_l_v4 #(.width_a(32'sd1),
  .signd_a(32'sd0),
  .width_s(32'sd6),
  .width_z(32'sd11)) FpMantDecShiftRight_10U_6U_10U_least_mask_lshift_rg (
      .a(1'b1),
      .s(nl_FpMantDecShiftRight_10U_6U_10U_least_mask_lshift_rg_s[5:0]),
      .z(FpMantDecShiftRight_10U_6U_10U_least_mask_sva)
    );
  HLS_cdp_ocvt_core_chn_data_in_rsci HLS_cdp_ocvt_core_chn_data_in_rsci_inst (
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
  HLS_cdp_ocvt_core_chn_data_out_rsci HLS_cdp_ocvt_core_chn_data_out_rsci_inst (
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
      .chn_data_out_rsci_d(nl_HLS_cdp_ocvt_core_chn_data_out_rsci_inst_chn_data_out_rsci_d[17:0])
    );
  HLS_cdp_ocvt_core_staller HLS_cdp_ocvt_core_staller_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .core_wen(core_wen),
      .chn_data_in_rsci_wen_comp(chn_data_in_rsci_wen_comp),
      .core_wten(core_wten),
      .chn_data_out_rsci_wen_comp(chn_data_out_rsci_wen_comp)
    );
  HLS_cdp_ocvt_core_core_fsm HLS_cdp_ocvt_core_core_fsm_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .core_wen(core_wen),
      .fsm_output(fsm_output)
    );
  assign and_15 = or_2_cse & (~(FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_st_3
      | FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_st_3))
      & FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_4
      & (io_read_cfg_precision_rsc_svs_st_4==2'b10) & main_stage_v_1;
  assign shift_0_prb = MUX1HOT_s_1_1_2(readslicef_7_1_6((({1'b1 , (~ FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_i_shift_acc_psp_sva)
      , (i_data_sva_1_16_0_1[10])}) + 7'b1)), and_15);
  // assert(shift > 0) - ../include/nvdla_float.h: line 286
  // PSL HLS_cdp_ocvt_core_nvdla_float_h_ln286_assert_shift_gt_0 : assert { shift_0_prb } @rose(nvdla_core_clk);
  assign or_132 = (main_stage_en_1 & and_dcpl_6 & (fsm_output[1])) | (and_dcpl_10
      & and_dcpl_6);
  assign iExpoWidth_oExpoWidth_prb = MUX1HOT_s_1_1_2(1'b1, or_132);
  // assert(iExpoWidth > oExpoWidth) - ../include/nvdla_float.h: line 597
  // PSL HLS_cdp_ocvt_core_nvdla_float_h_ln597_assert_iExpoWidth_gt_oExpoWidth : assert { iExpoWidth_oExpoWidth_prb } @rose(nvdla_core_clk);
  assign oWidth_mWidth_prb = HLS_cdp_ocvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_1_sig_mx0w1;
  // assert(oWidth > mWidth) - ../include/nvdla_int.h: line 281
  // PSL HLS_cdp_ocvt_core_nvdla_int_h_ln281_assert_oWidth_gt_mWidth : assert { oWidth_mWidth_prb } @rose(nvdla_core_clk);
  assign oWidth_aWidth_bWidth_prb = HLS_cdp_ocvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_1_sig_mx0w1;
  // assert(oWidth >= aWidth+bWidth) - ../include/nvdla_int.h: line 346
  // PSL HLS_cdp_ocvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth : assert { oWidth_aWidth_bWidth_prb } @rose(nvdla_core_clk);
  assign oWidth_mWidth_prb_1 = HLS_cdp_ocvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_1_sig_mx0w1;
  // assert(oWidth > mWidth) - ../include/nvdla_int.h: line 281
  // PSL HLS_cdp_ocvt_core_nvdla_int_h_ln281_assert_oWidth_gt_mWidth_1 : assert { oWidth_mWidth_prb_1 } @rose(nvdla_core_clk);
  assign oWidth_aWidth_bWidth_prb_1 = HLS_cdp_ocvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_1_sig_mx0w1;
  // assert(oWidth >= aWidth+bWidth) - ../include/nvdla_int.h: line 346
  // PSL HLS_cdp_ocvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_1 : assert { oWidth_aWidth_bWidth_prb_1 } @rose(nvdla_core_clk);
  assign oWidth_mWidth_prb_2 = HLS_cdp_ocvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_2_sig_mx0w1;
  // assert(oWidth > mWidth) - ../include/nvdla_int.h: line 281
  // PSL HLS_cdp_ocvt_core_nvdla_int_h_ln281_assert_oWidth_gt_mWidth_2 : assert { oWidth_mWidth_prb_2 } @rose(nvdla_core_clk);
  assign oWidth_aWidth_bWidth_prb_2 = HLS_cdp_ocvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_2_sig_mx0w1;
  // assert(oWidth >= aWidth+bWidth) - ../include/nvdla_int.h: line 346
  // PSL HLS_cdp_ocvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_2 : assert { oWidth_aWidth_bWidth_prb_2 } @rose(nvdla_core_clk);
  assign chn_data_out_and_cse = core_wen & (~(and_dcpl_22 | (~ main_stage_v_3)));
  assign or_2_cse = (~ reg_chn_data_out_rsci_ld_core_psct_cse) | chn_data_out_rsci_bawt;
  assign nor_82_cse = ~((io_read_cfg_precision_rsc_svs_st_4!=2'b00));
  assign or_7_cse = nor_82_cse | (io_read_cfg_precision_rsc_svs_st_4[0]);
  assign or_16_cse = (cfg_precision_rsci_d!=2'b10);
  assign and_70_cse = or_2_cse & main_stage_v_1;
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_or_1_cse
      = (or_2_cse & (~ (io_read_cfg_precision_rsc_svs_st_4[0]))) | and_dcpl_35;
  assign nor_10_cse = ~(chn_data_out_rsci_bawt | (~ reg_chn_data_out_rsci_ld_core_psct_cse));
  assign or_28_cse = (io_read_cfg_precision_rsc_svs_st_5!=2'b00);
  assign or_27_cse = (io_read_cfg_precision_rsc_svs_st_4!=2'b00);
  assign IntMulExt_26U_16U_42U_1_o_mul_nl = conv_u2u_42_42($signed(IntSubExt_25U_25U_26U_1_o_acc_itm_2)
      * $signed(cfg_mul_in_1_sva_3));
  assign or_144_nl = (io_read_cfg_precision_rsc_svs_st_5[0]) | chn_data_out_rsci_bawt
      | (~ reg_chn_data_out_rsci_ld_core_psct_cse);
  assign nor_43_nl = ~((~ (io_read_cfg_precision_rsc_svs_st_5[0])) | chn_data_out_rsci_bawt
      | (~ reg_chn_data_out_rsci_ld_core_psct_cse));
  assign mux_80_nl = MUX_s_1_2_2((nor_43_nl), (or_144_nl), io_read_cfg_precision_rsc_svs_st_4[0]);
  assign IntShiftRightSat_50U_6U_16U_i_mux1h_1_itm = MUX_v_50_2_2(({8'b0 , (IntMulExt_26U_16U_42U_1_o_mul_nl)}),
      IntShiftRightSat_50U_6U_16U_i_sva_mx0w0, mux_80_nl);
  assign and_197_nl = and_70_cse & (io_read_cfg_precision_rsc_svs_st_4[0]);
  assign and_142_nl = (io_read_cfg_precision_rsc_svs_st_5[0]) & FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_st_4;
  assign mux_32_nl = MUX_s_1_2_2((and_197_nl), mux_tmp_22, and_142_nl);
  assign mux_33_nl = MUX_s_1_2_2((mux_32_nl), mux_tmp_22, nor_tmp_42);
  assign IntShiftRightSat_50U_6U_16U_o_and_cse = core_wen & (~ and_dcpl_22) & (mux_33_nl);
  assign nor_95_nl = ~((io_read_cfg_precision_rsc_svs_st_5[0]) | chn_data_out_rsci_bawt
      | (~ reg_chn_data_out_rsci_ld_core_psct_cse) | nor_tmp_42);
  assign or_148_nl = chn_data_out_rsci_bawt | (~(reg_chn_data_out_rsci_ld_core_psct_cse
      & nor_tmp_42));
  assign mux_81_nl = MUX_s_1_2_2((or_148_nl), or_2_cse, io_read_cfg_precision_rsc_svs_st_5[0]);
  assign mux_82_nl = MUX_s_1_2_2((mux_81_nl), (nor_95_nl), io_read_cfg_precision_rsc_svs_st_4[0]);
  assign IntShiftRightSat_50U_6U_16U_o_mux1h_2_itm = MUX_v_14_2_2(IntShiftRightSat_50U_6U_16U_o_14_1_sva_mx0w0,
      ({3'b0 , FpMantDecShiftRight_10U_6U_10U_guard_mask_sva_mx0w0}), mux_82_nl);
  assign nor_73_nl = ~(chn_data_out_rsci_bawt | not_tmp_24);
  assign mux_39_nl = MUX_s_1_2_2((nor_73_nl), or_tmp_28, main_stage_v_1);
  assign and_173_cse = core_wen & (~ and_dcpl_22) & (mux_39_nl);
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_if_FpExpoWidthDec_6U_5U_10U_1U_1U_if_or_cse
      = and_dcpl_40 | and_dcpl_41;
  assign or_64_cse = (cfg_precision_rsci_d!=2'b00);
  assign nor_60_nl = ~((~ main_stage_v_3) | (io_read_cfg_precision_rsc_svs_st_6!=2'b00)
      | chn_data_out_rsci_bawt | (~ reg_chn_data_out_rsci_ld_core_psct_cse));
  assign nor_61_nl = ~((io_read_cfg_precision_rsc_svs_st_5[1]) | (~ mux_tmp_41));
  assign mux_50_nl = MUX_s_1_2_2(or_tmp_71, (~ or_2_cse), io_read_cfg_precision_rsc_svs_st_5[1]);
  assign or_69_nl = (~ main_stage_v_3) | (io_read_cfg_precision_rsc_svs_st_6!=2'b00);
  assign mux_51_nl = MUX_s_1_2_2((mux_50_nl), (nor_61_nl), or_69_nl);
  assign mux_52_nl = MUX_s_1_2_2((mux_51_nl), (nor_60_nl), io_read_cfg_precision_rsc_svs_st_5[0]);
  assign IntShiftRightSat_42U_6U_8U_i_and_cse = core_wen & (~ and_dcpl_22) & (mux_52_nl);
  assign and_137_cse = IntShiftRight_42U_6U_8U_1_obits_fixed_acc_sat_sva_1_42_1 &
      IntShiftRight_42U_6U_8U_1_obits_fixed_nand_itm_2;
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_mux_6_nl = MUX_v_4_2_2(({3'b0 ,
      (FpMantDecShiftRight_10U_6U_10U_o_mant_sum_sva[10])}), (i_data_sva_2_14_0_1[13:10]),
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_4);
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_not_15_nl = ~ FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_4;
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_else_FpExpoWidthDec_6U_5U_10U_1U_1U_else_and_2_nl
      = MUX_v_4_2_2(4'b0000, (FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_mux_6_nl),
      (FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_not_15_nl));
  assign IntShiftRight_42U_6U_8U_1_obits_fixed_nor_2_nl = ~(MUX_v_6_2_2((IntShiftRight_42U_6U_8U_1_obits_fixed_acc_tmp[6:1]),
      6'b111111, IntShiftRight_42U_6U_8U_1_obits_fixed_nor_ovfl_sva_mx0w0));
  assign or_152_nl = (io_read_cfg_precision_rsc_svs_st_5[1]) | and_dcpl_22;
  assign and_83_nl = (io_read_cfg_precision_rsc_svs_st_5[1]) & or_2_cse;
  assign mux_83_nl = MUX_s_1_2_2((and_83_nl), (or_152_nl), io_read_cfg_precision_rsc_svs_st_6[1]);
  assign IntShiftRight_42U_6U_8U_1_obits_fixed_mux1h_4_itm = MUX_v_6_2_2((IntShiftRight_42U_6U_8U_1_obits_fixed_nor_2_nl),
      ({2'b0 , (FpExpoWidthDec_6U_5U_10U_1U_1U_else_FpExpoWidthDec_6U_5U_10U_1U_1U_else_and_2_nl)}),
      mux_83_nl);
  assign and_133_cse = IntShiftRight_42U_6U_8U_obits_fixed_nand_tmp & (IntShiftRight_42U_6U_8U_obits_fixed_acc_tmp[42]);
  assign and_135_cse = IntShiftRight_42U_6U_8U_obits_fixed_acc_sat_sva_1_42_1 & IntShiftRight_42U_6U_8U_obits_fixed_nand_itm_2;
  assign mux_57_nl = MUX_s_1_2_2(mux_tmp_41, or_tmp_71, main_stage_v_3);
  assign and_183_cse = core_wen & (~ and_dcpl_22) & (mux_57_nl);
  assign nor_77_cse = ~((io_read_cfg_precision_rsc_svs_st_5!=2'b00));
  assign or_153_nl = nor_10_cse | nor_tmp_42;
  assign mux_84_tmp = MUX_s_1_2_2(and_dcpl_41, (or_153_nl), nor_tmp_43);
  assign and_86_tmp = or_2_cse & (~ IsNaN_6U_10U_land_lpi_1_dfm_4);
  assign and_187_ssc = core_wen & main_stage_v_2 & nor_tmp_42 & or_2_cse;
  assign or_209_cse = nor_tmp_42 | (io_read_cfg_precision_rsc_svs_st_5!=2'b00);
  assign mux_65_nl = MUX_s_1_2_2(or_7_cse, or_tmp_94, nor_10_cse);
  assign or_100_nl = chn_data_out_rsci_bawt | (~ reg_chn_data_out_rsci_ld_core_psct_cse)
      | nor_tmp_42 | not_tmp_57;
  assign mux_66_nl = MUX_s_1_2_2((or_100_nl), (mux_65_nl), main_stage_v_1);
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_if_and_3_cse = core_wen & (~ and_dcpl_22)
      & (~ (mux_66_nl));
  assign and_129_nl = or_tmp_39 & (~((~ main_stage_v_1) | (io_read_cfg_precision_rsc_svs_st_4!=2'b10)
      | (~ FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_4)
      | FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_st_3
      | FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_st_3
      | FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_3
      | FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_3));
  assign nor_49_nl = ~((~ main_stage_v_2) | (io_read_cfg_precision_rsc_svs_st_5!=2'b10)
      | (~ FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_st_4)
      | FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_st_4
      | FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_st_4
      | nor_tmp_42 | (~ FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_5)
      | IsNaN_6U_10U_land_lpi_1_dfm_4 | FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_4
      | FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_4);
  assign mux_70_nl = MUX_s_1_2_2((nor_49_nl), (and_129_nl), or_2_cse);
  assign FpMantDecShiftRight_10U_6U_10U_i_mant_s_and_cse = core_wen & (~ and_dcpl_22)
      & (mux_70_nl);
  assign nor_46_nl = ~((io_read_cfg_precision_rsc_svs_st_5!=2'b00) | chn_data_out_rsci_bawt
      | not_tmp_24);
  assign mux_71_nl = MUX_s_1_2_2(or_tmp_28, or_2_cse, or_28_cse);
  assign mux_72_nl = MUX_s_1_2_2((mux_71_nl), (nor_46_nl), or_112_cse);
  assign cfg_truncate_and_1_cse = core_wen & (~ and_dcpl_22) & (mux_72_nl);
  assign and_89_rgt = or_2_cse & (~ FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1);
  assign and_92_rgt = or_2_cse & ((~ FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1)
      | FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1);
  assign nor_6_nl = ~((~ main_stage_v_1) | (io_read_cfg_precision_rsc_svs_st_4!=2'b10));
  assign mux_76_nl = MUX_s_1_2_2(or_tmp_17, mux_tmp_66, nor_6_nl);
  assign IsNaN_6U_10U_and_cse = core_wen & (~ and_dcpl_22) & (~ (mux_76_nl));
  assign nor_44_nl = ~((cfg_precision_rsci_d!=2'b00) | (~ main_stage_en_1));
  assign mux_77_nl = MUX_s_1_2_2(or_tmp_11, (~ or_2_cse), or_64_cse);
  assign mux_78_nl = MUX_s_1_2_2((mux_77_nl), (nor_44_nl), or_112_cse);
  assign IntSubExt_25U_25U_26U_1_o_and_cse = core_wen & (~ and_dcpl_22) & (mux_78_nl);
  assign or_133_nl = (main_stage_en_1 & and_dcpl_12 & (fsm_output[1])) | (and_dcpl_10
      & and_dcpl_12);
  assign HLS_cdp_ocvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_1_sig_mx0w1
      = MUX1HOT_s_1_1_2(1'b1, or_133_nl);
  assign or_134_nl = (and_dcpl_16 & (fsm_output[1])) | (and_dcpl_9 & and_dcpl_15);
  assign HLS_cdp_ocvt_core_nvdla_int_h_ln346_assert_oWidth_ge_aWidth_p_bWidth_2_sig_mx0w1
      = MUX1HOT_s_1_1_2(1'b1, or_134_nl);
  assign nl_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_nl = ({1'b1 , (~ (chn_data_in_rsci_d_mxwt[15:10]))})
      + 7'b10001;
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_nl = nl_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_nl[6:0];
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_itm_6 = readslicef_7_1_6((FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_nl));
  assign nl_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_nl = conv_u2u_5_6(chn_data_in_rsci_d_mxwt[15:11])
      + 6'b111101;
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_nl = nl_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_nl[5:0];
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1 = readslicef_6_1_5((FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_nl));
  assign nl_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_nl = conv_u2s_6_7(chn_data_in_rsci_d_mxwt[15:10])
      + 7'b1010001;
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_acc_nl = nl_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_nl[6:0];
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1 = readslicef_7_1_6((FpExpoWidthDec_6U_5U_10U_1U_1U_acc_nl));
  assign IntShiftRightSat_50U_6U_16U_IntShiftRightSat_50U_6U_16U_oelse_IntShiftRightSat_50U_6U_16U_if_unequal_tmp
      = IntShiftRightSat_50U_6U_16U_i_sva_mx0w0 != conv_s2s_16_50({IntShiftRightSat_50U_6U_16U_o_15_sva_mx0w0
      , IntShiftRightSat_50U_6U_16U_o_14_1_sva_mx0w0 , IntShiftRightSat_50U_6U_16U_o_0_sva_mx0w0});
  assign IntShiftRightSat_50U_6U_16U_o_15_sva_mx0w0 = ~((~((IntShiftRight_50U_6U_16U_obits_fixed_acc_sat_sva[15])
      | IntShiftRight_50U_6U_16U_obits_fixed_and_unfl_sva)) | IntShiftRight_50U_6U_16U_obits_fixed_nor_ovfl_sva);
  assign IntShiftRight_50U_6U_16U_obits_fixed_nor_2_nl = ~(MUX_v_14_2_2((IntShiftRight_50U_6U_16U_obits_fixed_acc_sat_sva[14:1]),
      14'b11111111111111, IntShiftRight_50U_6U_16U_obits_fixed_nor_ovfl_sva));
  assign IntShiftRightSat_50U_6U_16U_o_14_1_sva_mx0w0 = ~(MUX_v_14_2_2((IntShiftRight_50U_6U_16U_obits_fixed_nor_2_nl),
      14'b11111111111111, IntShiftRight_50U_6U_16U_obits_fixed_and_unfl_sva));
  assign IntShiftRightSat_50U_6U_16U_o_0_sva_mx0w0 = ~((~((IntShiftRight_50U_6U_16U_obits_fixed_acc_sat_sva[0])
      | IntShiftRight_50U_6U_16U_obits_fixed_nor_ovfl_sva)) | IntShiftRight_50U_6U_16U_obits_fixed_and_unfl_sva);
  assign nl_IntShiftRightSat_42U_6U_8U_1_oif_acc_nl = conv_s2s_8_9({IntShiftRightSat_42U_6U_8U_1_o_7_sva
      , IntShiftRightSat_42U_6U_8U_1_o_6_1_sva , IntShiftRightSat_42U_6U_8U_1_o_0_sva})
      + 9'b1;
  assign IntShiftRightSat_42U_6U_8U_1_oif_acc_nl = nl_IntShiftRightSat_42U_6U_8U_1_oif_acc_nl[8:0];
  assign IntShiftRightSat_42U_6U_8U_1_lor_lpi_1_dfm_mx1w0 = (IntShiftRightSat_42U_6U_8U_1_i_sva_2
      == conv_s2s_9_42(IntShiftRightSat_42U_6U_8U_1_oif_acc_nl)) | (IntShiftRightSat_42U_6U_8U_1_i_sva_2
      == conv_s2s_8_42({IntShiftRightSat_42U_6U_8U_1_o_7_sva , IntShiftRightSat_42U_6U_8U_1_o_6_1_sva
      , IntShiftRightSat_42U_6U_8U_1_o_0_sva}));
  assign IntShiftRight_42U_6U_8U_1_obits_fixed_nor_ovfl_sva_mx0w0 = ~((IntShiftRight_42U_6U_8U_1_obits_fixed_acc_tmp[42])
      | (~((IntShiftRight_42U_6U_8U_1_obits_fixed_acc_tmp[41:7]!=35'b00000000000000000000000000000000000))));
  assign IntShiftRight_42U_6U_8U_1_obits_fixed_nand_tmp = ~((IntShiftRight_42U_6U_8U_1_obits_fixed_acc_tmp[41:7]==35'b11111111111111111111111111111111111));
  assign IntShiftRight_42U_6U_8U_obits_fixed_nor_ovfl_sva_mx0w0 = ~((IntShiftRight_42U_6U_8U_obits_fixed_acc_tmp[42])
      | (~((IntShiftRight_42U_6U_8U_obits_fixed_acc_tmp[41:7]!=35'b00000000000000000000000000000000000))));
  assign IntShiftRight_42U_6U_8U_obits_fixed_nand_tmp = ~((IntShiftRight_42U_6U_8U_obits_fixed_acc_tmp[41:7]==35'b11111111111111111111111111111111111));
  assign nl_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_i_shift_acc_psp_sva = (~
      (i_data_sva_1_16_0_1[15:11])) + 5'b1001;
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_i_shift_acc_psp_sva = nl_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_i_shift_acc_psp_sva[4:0];
  assign IntShiftRightSat_42U_6U_8U_o_7_sva = ~((~(IntShiftRight_42U_6U_8U_obits_fixed_acc_sat_sva_1_7_1
      | and_135_cse)) | IntShiftRight_42U_6U_8U_obits_fixed_nor_ovfl_sva_2);
  assign IntShiftRightSat_42U_6U_8U_o_6_1_sva = ~(MUX_v_6_2_2(IntShiftRight_42U_6U_8U_obits_fixed_nor_2_itm_2,
      6'b111111, and_135_cse));
  assign IntShiftRightSat_42U_6U_8U_o_0_sva = ~((~(IntShiftRight_42U_6U_8U_obits_fixed_acc_sat_sva_1_0_1
      | IntShiftRight_42U_6U_8U_obits_fixed_nor_ovfl_sva_2)) | and_135_cse);
  assign IntShiftRightSat_42U_6U_8U_1_o_7_sva = ~((~(IntShiftRight_42U_6U_8U_1_obits_fixed_acc_sat_sva_1_7_1
      | and_137_cse)) | IntShiftRight_42U_6U_8U_1_obits_fixed_nor_ovfl_sva_2);
  assign IntShiftRightSat_42U_6U_8U_1_o_6_1_sva = ~(MUX_v_6_2_2(({reg_IntShiftRight_42U_6U_8U_1_obits_fixed_nor_2_itm
      , reg_IntShiftRight_42U_6U_8U_1_obits_fixed_nor_2_1_itm}), 6'b111111, and_137_cse));
  assign IntShiftRightSat_42U_6U_8U_1_o_0_sva = ~((~(IntShiftRight_42U_6U_8U_1_obits_fixed_acc_sat_sva_1_0_1
      | IntShiftRight_42U_6U_8U_1_obits_fixed_nor_ovfl_sva_2)) | and_137_cse);
  assign nor_dfs = ~(equal_tmp_2 | nor_tmp_43);
  assign main_stage_en_1 = chn_data_in_rsci_bawt & or_2_cse;
  assign IntShiftRight_42U_6U_8U_1_obits_fixed_and_nl = (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[62])
      & ((IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[0]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[1])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[2]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[3])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[4]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[5])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[6]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[7])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[8]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[9])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[10]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[11])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[12]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[13])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[14]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[15])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[16]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[17])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[18]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[19])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[20]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[21])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[22]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[23])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[24]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[25])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[26]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[27])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[28]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[29])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[30]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[31])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[32]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[33])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[34]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[35])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[36]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[37])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[38]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[39])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[40]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[41])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[42]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[43])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[44]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[45])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[46]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[47])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[48]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[49])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[50]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[51])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[52]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[53])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[54]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[55])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[56]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[57])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[58]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[59])
      | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[60]) | (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[61])
      | (~ (IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[104])));
  assign nl_IntShiftRight_42U_6U_8U_1_obits_fixed_acc_tmp = conv_s2s_42_43(IntShiftRight_42U_6U_8U_1_obits_fixed_asn_rndi_sva[104:63])
      + conv_u2s_1_43(IntShiftRight_42U_6U_8U_1_obits_fixed_and_nl);
  assign IntShiftRight_42U_6U_8U_1_obits_fixed_acc_tmp = nl_IntShiftRight_42U_6U_8U_1_obits_fixed_acc_tmp[42:0];
  assign IntShiftRight_42U_6U_8U_obits_fixed_and_nl = (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[62])
      & ((IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[0]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[1])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[2]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[3])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[4]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[5])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[6]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[7])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[8]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[9])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[10]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[11])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[12]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[13])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[14]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[15])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[16]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[17])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[18]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[19])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[20]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[21])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[22]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[23])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[24]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[25])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[26]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[27])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[28]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[29])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[30]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[31])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[32]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[33])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[34]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[35])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[36]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[37])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[38]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[39])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[40]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[41])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[42]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[43])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[44]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[45])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[46]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[47])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[48]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[49])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[50]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[51])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[52]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[53])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[54]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[55])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[56]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[57])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[58]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[59])
      | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[60]) | (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[61])
      | (~ (IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[104])));
  assign nl_IntShiftRight_42U_6U_8U_obits_fixed_acc_tmp = conv_s2s_42_43(IntShiftRight_42U_6U_8U_obits_fixed_asn_rndi_sva[104:63])
      + conv_u2s_1_43(IntShiftRight_42U_6U_8U_obits_fixed_and_nl);
  assign IntShiftRight_42U_6U_8U_obits_fixed_acc_tmp = nl_IntShiftRight_42U_6U_8U_obits_fixed_acc_tmp[42:0];
  assign IntShiftRight_50U_6U_16U_obits_fixed_and_nl = (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[62])
      & ((IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[0]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[1])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[2]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[3])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[4]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[5])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[6]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[7])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[8]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[9])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[10]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[11])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[12]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[13])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[14]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[15])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[16]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[17])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[18]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[19])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[20]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[21])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[22]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[23])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[24]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[25])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[26]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[27])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[28]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[29])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[30]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[31])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[32]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[33])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[34]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[35])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[36]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[37])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[38]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[39])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[40]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[41])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[42]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[43])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[44]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[45])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[46]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[47])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[48]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[49])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[50]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[51])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[52]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[53])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[54]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[55])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[56]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[57])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[58]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[59])
      | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[60]) | (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[61])
      | (~ (IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[112])));
  assign nl_IntShiftRight_50U_6U_16U_obits_fixed_acc_sat_sva = conv_s2s_50_51(IntShiftRight_50U_6U_16U_obits_fixed_asn_rndi_sva[112:63])
      + conv_u2s_1_51(IntShiftRight_50U_6U_16U_obits_fixed_and_nl);
  assign IntShiftRight_50U_6U_16U_obits_fixed_acc_sat_sva = nl_IntShiftRight_50U_6U_16U_obits_fixed_acc_sat_sva[50:0];
  assign IntShiftRight_50U_6U_16U_obits_fixed_and_unfl_sva = (IntShiftRight_50U_6U_16U_obits_fixed_acc_sat_sva[50])
      & (~((IntShiftRight_50U_6U_16U_obits_fixed_acc_sat_sva[49:15]==35'b11111111111111111111111111111111111)));
  assign IntShiftRight_50U_6U_16U_obits_fixed_nor_ovfl_sva = ~((IntShiftRight_50U_6U_16U_obits_fixed_acc_sat_sva[50])
      | (~((IntShiftRight_50U_6U_16U_obits_fixed_acc_sat_sva[49:15]!=35'b00000000000000000000000000000000000))));
  assign FpMantDecShiftRight_10U_6U_10U_carry_and_nl = FpMantDecShiftRight_10U_6U_10U_guard_or_itm_2
      & ((FpMantDecShiftRight_10U_6U_10U_stick_bits_9_0_sva!=10'b0000000000) | (FpMantDecShiftRight_10U_6U_10U_stick_mask_sva[10])
      | (FpMantDecShiftRight_10U_6U_10U_least_bits_9_0_sva_2!=10'b0000000000) | FpMantDecShiftRight_10U_6U_10U_least_bits_slc_FpMantDecShiftRight_10U_6U_10U_least_mask_10_itm_2);
  assign nl_FpMantDecShiftRight_10U_6U_10U_o_mant_sum_sva = FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_itm_2
      + conv_u2u_1_11(FpMantDecShiftRight_10U_6U_10U_carry_and_nl);
  assign FpMantDecShiftRight_10U_6U_10U_o_mant_sum_sva = nl_FpMantDecShiftRight_10U_6U_10U_o_mant_sum_sva[10:0];
  assign FpMantDecShiftRight_10U_6U_10U_stick_bits_9_0_sva = (i_data_sva_2_14_0_1[9:0])
      & (FpMantDecShiftRight_10U_6U_10U_stick_mask_sva[9:0]);
  assign nl_FpMantDecShiftRight_10U_6U_10U_stick_mask_sva = reg_IntShiftRightSat_50U_6U_16U_o_14_1_2_itm
      + 11'b11111111111;
  assign FpMantDecShiftRight_10U_6U_10U_stick_mask_sva = nl_FpMantDecShiftRight_10U_6U_10U_stick_mask_sva[10:0];
  assign FpMantDecShiftRight_10U_6U_10U_guard_bits_9_0_sva = (i_data_sva_1_16_0_1[9:0])
      & (FpMantDecShiftRight_10U_6U_10U_guard_mask_sva_mx0w0[9:0]);
  assign and_dcpl_6 = (cfg_precision_rsci_d==2'b10);
  assign and_dcpl_9 = reg_chn_data_out_rsci_ld_core_psct_cse & chn_data_out_rsci_bawt;
  assign and_dcpl_10 = and_dcpl_9 & chn_data_in_rsci_bawt;
  assign and_dcpl_12 = ~((cfg_precision_rsci_d!=2'b00));
  assign and_dcpl_15 = chn_data_in_rsci_bawt & (cfg_precision_rsci_d[0]);
  assign and_dcpl_16 = or_2_cse & and_dcpl_15;
  assign or_tmp_11 = chn_data_in_rsci_bawt | (~ or_2_cse);
  assign or_tmp_17 = (cfg_precision_rsci_d!=2'b10) | (~ main_stage_en_1);
  assign or_tmp_25 = (io_read_cfg_precision_rsc_svs_st_5!=2'b10) | chn_data_out_rsci_bawt
      | (~(reg_chn_data_out_rsci_ld_core_psct_cse & FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_st_4
      & main_stage_v_2));
  assign or_tmp_28 = chn_data_out_rsci_bawt | (~ reg_chn_data_out_rsci_ld_core_psct_cse)
      | main_stage_v_2;
  assign not_tmp_24 = ~(reg_chn_data_out_rsci_ld_core_psct_cse & main_stage_v_2);
  assign not_tmp_25 = ~(nor_77_cse | chn_data_out_rsci_bawt | not_tmp_24);
  assign or_37_nl = main_stage_v_1 | (~ or_2_cse);
  assign mux_28_nl = MUX_s_1_2_2(and_70_cse, (or_37_nl), main_stage_v_2);
  assign nor_78_nl = ~((~ main_stage_v_2) | (~ reg_chn_data_out_rsci_ld_core_psct_cse)
      | chn_data_out_rsci_bawt);
  assign mux_tmp_22 = MUX_s_1_2_2((nor_78_nl), (mux_28_nl), io_read_cfg_precision_rsc_svs_st_4[0]);
  assign or_tmp_39 = IsNaN_6U_10U_nor_itm_2 | IsNaN_6U_10U_IsNaN_6U_10U_nand_itm_2;
  assign or_tmp_59 = (~ main_stage_v_3) | (io_read_cfg_precision_rsc_svs_st_6!=2'b00)
      | (~ reg_chn_data_out_rsci_ld_core_psct_cse) | chn_data_out_rsci_bawt;
  assign not_tmp_42 = main_stage_v_3 & (~((~((io_read_cfg_precision_rsc_svs_st_6!=2'b00)))
      | (~ reg_chn_data_out_rsci_ld_core_psct_cse) | chn_data_out_rsci_bawt));
  assign nor_62_nl = ~(reg_chn_data_out_rsci_ld_core_psct_cse | (~ main_stage_v_2));
  assign mux_tmp_41 = MUX_s_1_2_2((nor_62_nl), main_stage_v_2, chn_data_out_rsci_bawt);
  assign or_tmp_71 = nor_10_cse | main_stage_v_2;
  assign nor_tmp_26 = or_209_cse & main_stage_v_2;
  assign nor_54_nl = ~(reg_chn_data_out_rsci_ld_core_psct_cse | (~ nor_tmp_26));
  assign mux_tmp_50 = MUX_s_1_2_2((nor_54_nl), nor_tmp_26, chn_data_out_rsci_bawt);
  assign nor_tmp_29 = nor_tmp_42 & main_stage_v_2;
  assign not_tmp_57 = ~(or_28_cse & main_stage_v_2);
  assign or_tmp_94 = nor_tmp_42 | not_tmp_57;
  assign and_tmp_6 = or_16_cse & chn_data_in_rsci_bawt & or_2_cse;
  assign or_112_cse = (~ main_stage_v_1) | (io_read_cfg_precision_rsc_svs_st_4!=2'b00);
  assign or_tmp_117 = chn_data_out_rsci_bawt | (~ reg_chn_data_out_rsci_ld_core_psct_cse)
      | (io_read_cfg_precision_rsc_svs_st_4[0]) | nor_82_cse;
  assign nor_45_nl = ~(chn_data_out_rsci_bawt | (~(reg_chn_data_out_rsci_ld_core_psct_cse
      & or_7_cse)));
  assign mux_73_nl = MUX_s_1_2_2(or_tmp_117, (nor_45_nl), chn_data_in_rsci_bawt);
  assign mux_tmp_66 = MUX_s_1_2_2((mux_73_nl), or_tmp_117, or_16_cse);
  assign mux_75_itm = MUX_s_1_2_2(or_tmp_17, mux_tmp_66, main_stage_v_1);
  assign and_dcpl_22 = reg_chn_data_out_rsci_ld_core_psct_cse & (~ chn_data_out_rsci_bawt);
  assign and_dcpl_24 = or_2_cse & main_stage_v_3;
  assign and_dcpl_25 = and_dcpl_9 & (~ main_stage_v_3);
  assign and_dcpl_35 = or_2_cse & (io_read_cfg_precision_rsc_svs_st_4[0]);
  assign and_dcpl_40 = or_2_cse & (~ nor_tmp_42);
  assign and_dcpl_41 = or_2_cse & nor_tmp_42;
  assign or_dcpl_10 = (io_read_cfg_precision_rsc_svs_st_6!=2'b00);
  assign or_tmp_146 = or_2_cse & chn_data_in_rsci_bawt & (fsm_output[1]);
  assign chn_data_in_rsci_ld_core_psct_mx0c0 = main_stage_en_1 | (fsm_output[0]);
  assign main_stage_v_1_mx0c1 = or_2_cse & (~ chn_data_in_rsci_bawt) & main_stage_v_1;
  assign main_stage_v_2_mx0c1 = or_2_cse & main_stage_v_2 & (~ main_stage_v_1);
  assign main_stage_v_3_mx0c1 = or_2_cse & (~ main_stage_v_2) & main_stage_v_3;
  assign chn_data_in_rsci_oswt_unreg = or_tmp_146;
  assign chn_data_out_rsci_oswt_unreg = and_dcpl_9;
  assign and_dcpl_52 = core_wen & main_stage_v_1;
  assign nor_tmp = IntShiftRight_42U_6U_8U_1_obits_fixed_nand_tmp & (IntShiftRight_42U_6U_8U_1_obits_fixed_acc_tmp[42]);
  assign or_tmp_164 = (io_read_cfg_precision_rsc_svs_st_5[1]) | nor_tmp;
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_data_in_rsci_iswt0 <= 1'b0;
      chn_data_out_rsci_iswt0 <= 1'b0;
    end
    else if ( core_wen ) begin
      chn_data_in_rsci_iswt0 <= ~((~ main_stage_en_1) & (fsm_output[1]));
      chn_data_out_rsci_iswt0 <= and_dcpl_24;
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
      chn_data_out_rsci_d_0 <= 1'b0;
      chn_data_out_rsci_d_6_1 <= 6'b0;
      chn_data_out_rsci_d_7 <= 1'b0;
      chn_data_out_rsci_d_8 <= 1'b0;
      chn_data_out_rsci_d_9 <= 1'b0;
      chn_data_out_rsci_d_13_10 <= 4'b0;
      chn_data_out_rsci_d_14 <= 1'b0;
      chn_data_out_rsci_d_15 <= 1'b0;
      chn_data_out_rsci_d_16 <= 1'b0;
      chn_data_out_rsci_d_17 <= 1'b0;
    end
    else if ( chn_data_out_and_cse ) begin
      chn_data_out_rsci_d_0 <= MUX1HOT_s_1_3_2((reg_IntShiftRightSat_50U_6U_16U_o_14_1_3_itm[0]),
          IntShiftRightSat_42U_6U_8U_o_0_sva, IntShiftRightSat_50U_6U_16U_o_0_sva_4,
          {nor_dfs , equal_tmp_2 , nor_tmp_43});
      chn_data_out_rsci_d_6_1 <= MUX1HOT_v_6_3_2((reg_IntShiftRightSat_50U_6U_16U_o_14_1_3_itm[6:1]),
          IntShiftRightSat_42U_6U_8U_o_6_1_sva, (reg_IntShiftRightSat_50U_6U_16U_o_14_1_3_itm[5:0]),
          {nor_dfs , equal_tmp_2 , nor_tmp_43});
      chn_data_out_rsci_d_7 <= MUX1HOT_s_1_3_2((reg_IntShiftRightSat_50U_6U_16U_o_14_1_3_itm[7]),
          IntShiftRightSat_42U_6U_8U_o_7_sva, (reg_IntShiftRightSat_50U_6U_16U_o_14_1_3_itm[6]),
          {nor_dfs , equal_tmp_2 , nor_tmp_43});
      chn_data_out_rsci_d_8 <= MUX1HOT_s_1_3_2((reg_IntShiftRightSat_50U_6U_16U_o_14_1_3_itm[8]),
          IntShiftRightSat_42U_6U_8U_1_o_0_sva, (reg_IntShiftRightSat_50U_6U_16U_o_14_1_3_itm[7]),
          {nor_dfs , equal_tmp_2 , nor_tmp_43});
      chn_data_out_rsci_d_9 <= MUX1HOT_s_1_3_2((reg_IntShiftRightSat_50U_6U_16U_o_14_1_3_itm[9]),
          (IntShiftRightSat_42U_6U_8U_1_o_6_1_sva[0]), (reg_IntShiftRightSat_50U_6U_16U_o_14_1_3_itm[8]),
          {nor_dfs , equal_tmp_2 , nor_tmp_43});
      chn_data_out_rsci_d_13_10 <= MUX1HOT_v_4_3_2((FpExpoWidthDec_6U_5U_10U_1U_1U_FpExpoWidthDec_6U_5U_10U_1U_1U_or_3_nl),
          (IntShiftRightSat_42U_6U_8U_1_o_6_1_sva[4:1]), ({(reg_IntShiftRightSat_50U_6U_16U_o_14_1_1_itm_3_1[1:0])
          , reg_IntShiftRightSat_50U_6U_16U_o_14_1_1_itm_0 , (reg_IntShiftRightSat_50U_6U_16U_o_14_1_3_itm[9])}),
          {nor_dfs , equal_tmp_2 , nor_tmp_43});
      chn_data_out_rsci_d_14 <= MUX1HOT_s_1_3_2(FpExpoWidthDec_6U_5U_10U_1U_1U_FpExpoWidthDec_6U_5U_10U_1U_1U_or_2_itm_2,
          (IntShiftRightSat_42U_6U_8U_1_o_6_1_sva[5]), (reg_IntShiftRightSat_50U_6U_16U_o_14_1_1_itm_3_1[2]),
          {nor_dfs , equal_tmp_2 , nor_tmp_43});
      chn_data_out_rsci_d_15 <= MUX1HOT_s_1_3_2(IntShiftRightSat_50U_6U_16U_o_0_sva_4,
          IntShiftRightSat_42U_6U_8U_1_o_7_sva, IntShiftRightSat_50U_6U_16U_o_15_sva_4,
          {nor_dfs , equal_tmp_2 , nor_tmp_43});
      chn_data_out_rsci_d_16 <= ~((mux_nl) | nor_dfs);
      chn_data_out_rsci_d_17 <= ~((IntShiftRightSat_42U_6U_8U_1_i_sva_2 == conv_s2s_9_42(IntShiftRightSat_42U_6U_8U_1_oif_1_acc_nl))
          | (IntShiftRightSat_42U_6U_8U_1_oelse_mux_1_nl) | nor_dfs | nor_tmp_43);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_chn_data_out_rsci_ld_core_psct_cse <= 1'b0;
    end
    else if ( core_wen & (and_dcpl_24 | and_dcpl_25) ) begin
      reg_chn_data_out_rsci_ld_core_psct_cse <= ~ and_dcpl_25;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      main_stage_v_1 <= 1'b0;
    end
    else if ( core_wen & (or_tmp_146 | main_stage_v_1_mx0c1) ) begin
      main_stage_v_1 <= ~ main_stage_v_1_mx0c1;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      i_data_sva_1_16_0_1 <= 17'b0;
    end
    else if ( core_wen & (~ and_dcpl_22) & (mux_8_nl) ) begin
      i_data_sva_1_16_0_1 <= chn_data_in_rsci_d_mxwt[16:0];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_st_3
          <= 1'b0;
    end
    else if ( core_wen & (~ and_dcpl_22) & (mux_10_nl) ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_st_3
          <= FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_itm_6;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_st_3
          <= 1'b0;
    end
    else if ( core_wen & (~ and_dcpl_22) & (mux_12_nl) ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_st_3
          <= FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      io_read_cfg_precision_rsc_svs_st_4 <= 2'b0;
    end
    else if ( core_wen & (~ and_dcpl_22) & (mux_15_nl) ) begin
      io_read_cfg_precision_rsc_svs_st_4 <= cfg_precision_rsci_d;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      main_stage_v_2 <= 1'b0;
    end
    else if ( core_wen & (and_70_cse | main_stage_v_2_mx0c1) ) begin
      main_stage_v_2 <= ~ main_stage_v_2_mx0c1;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_st_4
          <= 1'b0;
    end
    else if ( core_wen & FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_or_1_cse
        & (mux_18_nl) ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_st_4
          <= MUX_s_1_2_2(FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_st_3,
          IntShiftRightSat_50U_6U_16U_IntShiftRightSat_50U_6U_16U_oelse_IntShiftRightSat_50U_6U_16U_if_unequal_tmp,
          and_dcpl_35);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_st_4
          <= 1'b0;
    end
    else if ( core_wen & (~ and_dcpl_22) & (~ (mux_21_nl)) ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_st_4
          <= FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_st_3;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_st_4
          <= 1'b0;
    end
    else if ( core_wen & FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_or_1_cse
        & (mux_24_nl) ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_st_4
          <= MUX_s_1_2_2(FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_4,
          IntShiftRightSat_50U_6U_16U_IntShiftRightSat_50U_6U_16U_oelse_IntShiftRightSat_50U_6U_16U_if_unequal_tmp,
          and_dcpl_35);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_IntShiftRightSat_50U_6U_16U_i_itm <= 8'b0;
    end
    else if ( and_dcpl_52 & IntShiftRightSat_50U_6U_16U_IntShiftRightSat_50U_6U_16U_oelse_IntShiftRightSat_50U_6U_16U_if_unequal_tmp
        & or_2_cse & (io_read_cfg_precision_rsc_svs_st_4[0]) ) begin
      reg_IntShiftRightSat_50U_6U_16U_i_itm <= IntShiftRightSat_50U_6U_16U_i_mux1h_1_itm[49:42];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_IntShiftRightSat_50U_6U_16U_i_1_itm <= 42'b0;
    end
    else if ( (mux_85_nl) & core_wen & or_2_cse & main_stage_v_1 ) begin
      reg_IntShiftRightSat_50U_6U_16U_i_1_itm <= IntShiftRightSat_50U_6U_16U_i_mux1h_1_itm[41:0];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      IntShiftRightSat_50U_6U_16U_o_15_sva_3 <= 1'b0;
      IntShiftRightSat_50U_6U_16U_o_0_sva_3 <= 1'b0;
    end
    else if ( IntShiftRightSat_50U_6U_16U_o_and_cse ) begin
      IntShiftRightSat_50U_6U_16U_o_15_sva_3 <= IntShiftRightSat_50U_6U_16U_o_15_sva_mx0w0;
      IntShiftRightSat_50U_6U_16U_o_0_sva_3 <= IntShiftRightSat_50U_6U_16U_o_0_sva_mx0w0;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_IntShiftRightSat_50U_6U_16U_o_14_1_itm <= 3'b0;
    end
    else if ( and_dcpl_52 & or_2_cse & (io_read_cfg_precision_rsc_svs_st_4[0]) )
        begin
      reg_IntShiftRightSat_50U_6U_16U_o_14_1_itm <= IntShiftRightSat_50U_6U_16U_o_mux1h_2_itm[13:11];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_IntShiftRightSat_50U_6U_16U_o_14_1_2_itm <= 11'b0;
    end
    else if ( ((~((~ (io_read_cfg_precision_rsc_svs_st_4[1])) | (~ FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_4)
        | FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_st_3
        | FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_st_3
        | FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_3
        | FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_3
        | (~ or_tmp_39))) | (io_read_cfg_precision_rsc_svs_st_4[0])) & and_dcpl_52
        & or_2_cse ) begin
      reg_IntShiftRightSat_50U_6U_16U_o_14_1_2_itm <= IntShiftRightSat_50U_6U_16U_o_mux1h_2_itm[10:0];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      io_read_cfg_precision_rsc_svs_st_5 <= 2'b0;
      nor_tmp_42 <= 1'b0;
    end
    else if ( and_173_cse ) begin
      io_read_cfg_precision_rsc_svs_st_5 <= io_read_cfg_precision_rsc_svs_st_4;
      nor_tmp_42 <= io_read_cfg_precision_rsc_svs_st_4[0];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      main_stage_v_3 <= 1'b0;
    end
    else if ( core_wen & ((or_2_cse & main_stage_v_2) | main_stage_v_3_mx0c1) ) begin
      main_stage_v_3 <= ~ main_stage_v_3_mx0c1;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_6
          <= 1'b0;
    end
    else if ( core_wen & FpExpoWidthDec_6U_5U_10U_1U_1U_if_FpExpoWidthDec_6U_5U_10U_1U_1U_if_or_cse
        & (mux_41_nl) ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_6
          <= MUX_s_1_2_2(FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_5,
          (IntShiftRightSat_50U_6U_16U_if_IntShiftRightSat_50U_6U_16U_if_or_1_nl),
          and_dcpl_41);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      IsNaN_6U_10U_land_lpi_1_dfm_5 <= 1'b0;
    end
    else if ( core_wen & (~ and_dcpl_22) & (mux_42_nl) ) begin
      IsNaN_6U_10U_land_lpi_1_dfm_5 <= IsNaN_6U_10U_land_lpi_1_dfm_4;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      IntShiftRightSat_42U_6U_8U_1_lor_lpi_1_dfm <= 1'b0;
    end
    else if ( core_wen & (~ (fsm_output[0])) & (~(or_dcpl_10 | (~ main_stage_v_3)))
        & (mux_48_nl) ) begin
      IntShiftRightSat_42U_6U_8U_1_lor_lpi_1_dfm <= IntShiftRightSat_42U_6U_8U_1_lor_lpi_1_dfm_mx1w0;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      IntShiftRightSat_42U_6U_8U_i_sva_2 <= 42'b0;
      IntShiftRightSat_42U_6U_8U_1_i_sva_2 <= 42'b0;
      IntShiftRight_42U_6U_8U_1_obits_fixed_acc_sat_sva_1_7_1 <= 1'b0;
      IntShiftRight_42U_6U_8U_1_obits_fixed_nor_ovfl_sva_2 <= 1'b0;
      IntShiftRight_42U_6U_8U_1_obits_fixed_acc_sat_sva_1_0_1 <= 1'b0;
      IntShiftRight_42U_6U_8U_1_obits_fixed_acc_sat_sva_1_42_1 <= 1'b0;
      IntShiftRight_42U_6U_8U_1_obits_fixed_nand_itm_2 <= 1'b0;
      IntShiftRight_42U_6U_8U_obits_fixed_acc_sat_sva_1_7_1 <= 1'b0;
      IntShiftRight_42U_6U_8U_obits_fixed_nor_ovfl_sva_2 <= 1'b0;
      IntShiftRight_42U_6U_8U_obits_fixed_acc_sat_sva_1_0_1 <= 1'b0;
      IntShiftRight_42U_6U_8U_obits_fixed_acc_sat_sva_1_42_1 <= 1'b0;
      IntShiftRight_42U_6U_8U_obits_fixed_nand_itm_2 <= 1'b0;
    end
    else if ( IntShiftRightSat_42U_6U_8U_i_and_cse ) begin
      IntShiftRightSat_42U_6U_8U_i_sva_2 <= IntShiftRightSat_42U_6U_8U_i_rshift_itm;
      IntShiftRightSat_42U_6U_8U_1_i_sva_2 <= IntShiftRightSat_42U_6U_8U_1_i_rshift_itm;
      IntShiftRight_42U_6U_8U_1_obits_fixed_acc_sat_sva_1_7_1 <= IntShiftRight_42U_6U_8U_1_obits_fixed_acc_tmp[7];
      IntShiftRight_42U_6U_8U_1_obits_fixed_nor_ovfl_sva_2 <= IntShiftRight_42U_6U_8U_1_obits_fixed_nor_ovfl_sva_mx0w0;
      IntShiftRight_42U_6U_8U_1_obits_fixed_acc_sat_sva_1_0_1 <= IntShiftRight_42U_6U_8U_1_obits_fixed_acc_tmp[0];
      IntShiftRight_42U_6U_8U_1_obits_fixed_acc_sat_sva_1_42_1 <= IntShiftRight_42U_6U_8U_1_obits_fixed_acc_tmp[42];
      IntShiftRight_42U_6U_8U_1_obits_fixed_nand_itm_2 <= IntShiftRight_42U_6U_8U_1_obits_fixed_nand_tmp;
      IntShiftRight_42U_6U_8U_obits_fixed_acc_sat_sva_1_7_1 <= IntShiftRight_42U_6U_8U_obits_fixed_acc_tmp[7];
      IntShiftRight_42U_6U_8U_obits_fixed_nor_ovfl_sva_2 <= IntShiftRight_42U_6U_8U_obits_fixed_nor_ovfl_sva_mx0w0;
      IntShiftRight_42U_6U_8U_obits_fixed_acc_sat_sva_1_0_1 <= IntShiftRight_42U_6U_8U_obits_fixed_acc_tmp[0];
      IntShiftRight_42U_6U_8U_obits_fixed_acc_sat_sva_1_42_1 <= IntShiftRight_42U_6U_8U_obits_fixed_acc_tmp[42];
      IntShiftRight_42U_6U_8U_obits_fixed_nand_itm_2 <= IntShiftRight_42U_6U_8U_obits_fixed_nand_tmp;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_IntShiftRight_42U_6U_8U_1_obits_fixed_nor_2_itm <= 2'b0;
    end
    else if ( core_wen & (~ (io_read_cfg_precision_rsc_svs_st_5[0])) & (~((IntShiftRight_42U_6U_8U_1_obits_fixed_acc_tmp[42])
        & IntShiftRight_42U_6U_8U_1_obits_fixed_nand_tmp)) & main_stage_v_2 & (~
        (io_read_cfg_precision_rsc_svs_st_5[1])) & or_2_cse ) begin
      reg_IntShiftRight_42U_6U_8U_1_obits_fixed_nor_2_itm <= IntShiftRight_42U_6U_8U_1_obits_fixed_mux1h_4_itm[5:4];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_IntShiftRight_42U_6U_8U_1_obits_fixed_nor_2_1_itm <= 4'b0;
    end
    else if ( (~ (mux_88_nl)) & core_wen & (~ (io_read_cfg_precision_rsc_svs_st_5[0]))
        & main_stage_v_2 & or_2_cse ) begin
      reg_IntShiftRight_42U_6U_8U_1_obits_fixed_nor_2_1_itm <= IntShiftRight_42U_6U_8U_1_obits_fixed_mux1h_4_itm[3:0];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      IntShiftRight_42U_6U_8U_obits_fixed_nor_2_itm_2 <= 6'b0;
    end
    else if ( core_wen & (~ and_dcpl_22) & (mux_56_nl) ) begin
      IntShiftRight_42U_6U_8U_obits_fixed_nor_2_itm_2 <= ~(MUX_v_6_2_2((IntShiftRight_42U_6U_8U_obits_fixed_acc_tmp[6:1]),
          6'b111111, IntShiftRight_42U_6U_8U_obits_fixed_nor_ovfl_sva_mx0w0));
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      nor_tmp_43 <= 1'b0;
      equal_tmp_2 <= 1'b0;
      io_read_cfg_precision_rsc_svs_st_6 <= 2'b0;
    end
    else if ( and_183_cse ) begin
      nor_tmp_43 <= nor_tmp_42;
      equal_tmp_2 <= nor_77_cse;
      io_read_cfg_precision_rsc_svs_st_6 <= io_read_cfg_precision_rsc_svs_st_5;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      IntShiftRightSat_50U_6U_16U_o_0_sva_4 <= 1'b0;
    end
    else if ( core_wen & FpExpoWidthDec_6U_5U_10U_1U_1U_if_FpExpoWidthDec_6U_5U_10U_1U_1U_if_or_cse
        & (mux_60_nl) ) begin
      IntShiftRightSat_50U_6U_16U_o_0_sva_4 <= MUX_s_1_2_2(IntShiftRightSat_50U_6U_16U_o_0_sva_3,
          i_data_sva_2_16_1, and_dcpl_40);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_IntShiftRightSat_50U_6U_16U_o_14_1_1_itm_3_1 <= 3'b0;
      reg_IntShiftRightSat_50U_6U_16U_o_14_1_1_itm_0 <= 1'b0;
    end
    else if ( and_187_ssc ) begin
      reg_IntShiftRightSat_50U_6U_16U_o_14_1_1_itm_3_1 <= reg_IntShiftRightSat_50U_6U_16U_o_14_1_itm;
      reg_IntShiftRightSat_50U_6U_16U_o_14_1_1_itm_0 <= reg_IntShiftRightSat_50U_6U_16U_o_14_1_2_itm[10];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      reg_IntShiftRightSat_50U_6U_16U_o_14_1_3_itm <= 10'b0;
    end
    else if ( or_209_cse & core_wen & or_2_cse & main_stage_v_2 ) begin
      reg_IntShiftRightSat_50U_6U_16U_o_14_1_3_itm <= MUX1HOT_v_10_3_2((i_data_sva_2_14_0_1[9:0]),
          (FpExpoWidthDec_6U_5U_10U_1U_1U_FpExpoWidthDec_6U_5U_10U_1U_1U_FpExpoWidthDec_6U_5U_10U_1U_1U_nand_nl),
          (reg_IntShiftRightSat_50U_6U_16U_o_14_1_2_itm[9:0]), {(IntShiftRightSat_50U_6U_16U_o_IntShiftRightSat_50U_6U_16U_o_nor_nl)
          , (IntShiftRightSat_50U_6U_16U_o_and_7_nl) , mux_84_tmp});
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      IntShiftRightSat_50U_6U_16U_o_15_sva_4 <= 1'b0;
    end
    else if ( core_wen & (~ and_dcpl_22) & (mux_62_nl) ) begin
      IntShiftRightSat_50U_6U_16U_o_15_sva_4 <= IntShiftRightSat_50U_6U_16U_o_15_sva_3;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_FpExpoWidthDec_6U_5U_10U_1U_1U_or_2_itm_2 <=
          1'b0;
    end
    else if ( core_wen & (~ and_dcpl_22) & (~ (mux_64_nl)) ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_FpExpoWidthDec_6U_5U_10U_1U_1U_or_2_itm_2 <=
          ((~ (i_data_sva_2_14_0_1[14])) & FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_4
          & (~ FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_4))
          | (~ FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_5)
          | IsNaN_6U_10U_land_lpi_1_dfm_4;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_5
          <= 1'b0;
      IsNaN_6U_10U_land_lpi_1_dfm_4 <= 1'b0;
      i_data_sva_2_14_0_1 <= 15'b0;
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_4
          <= 1'b0;
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_4
          <= 1'b0;
      i_data_sva_2_16_1 <= 1'b0;
    end
    else if ( FpExpoWidthDec_6U_5U_10U_1U_1U_if_and_3_cse ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_5
          <= FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_4;
      IsNaN_6U_10U_land_lpi_1_dfm_4 <= ~(IsNaN_6U_10U_nor_itm_2 | IsNaN_6U_10U_IsNaN_6U_10U_nand_itm_2);
      i_data_sva_2_14_0_1 <= i_data_sva_1_16_0_1[14:0];
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_4
          <= FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_3;
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_4
          <= FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_3;
      i_data_sva_2_16_1 <= i_data_sva_1_16_0_1[16];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      IntMulExt_34U_16U_50U_return_sva_2 <= 50'b0;
    end
    else if ( core_wen & (~ and_dcpl_22) & (mux_67_nl) ) begin
      IntMulExt_34U_16U_50U_return_sva_2 <= conv_s2u_50_50($signed((IntSubExt_33U_32U_34U_o_acc_nl))
          * $signed((cfg_mul_in_rsci_d)));
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      cfg_truncate_1_sva_3 <= 6'b0;
    end
    else if ( core_wen & (~ and_dcpl_22) & (mux_69_nl) ) begin
      cfg_truncate_1_sva_3 <= cfg_truncate_rsci_d;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_itm_2 <= 11'b0;
      FpMantDecShiftRight_10U_6U_10U_guard_or_itm_2 <= 1'b0;
      FpMantDecShiftRight_10U_6U_10U_least_bits_9_0_sva_2 <= 10'b0;
      FpMantDecShiftRight_10U_6U_10U_least_bits_slc_FpMantDecShiftRight_10U_6U_10U_least_mask_10_itm_2
          <= 1'b0;
    end
    else if ( FpMantDecShiftRight_10U_6U_10U_i_mant_s_and_cse ) begin
      FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_itm_2 <= FpMantDecShiftRight_10U_6U_10U_i_mant_s_rshift_itm;
      FpMantDecShiftRight_10U_6U_10U_guard_or_itm_2 <= (FpMantDecShiftRight_10U_6U_10U_guard_bits_9_0_sva!=10'b0000000000)
          | (FpMantDecShiftRight_10U_6U_10U_guard_mask_sva_mx0w0[10]);
      FpMantDecShiftRight_10U_6U_10U_least_bits_9_0_sva_2 <= (i_data_sva_1_16_0_1[9:0])
          & (FpMantDecShiftRight_10U_6U_10U_least_mask_sva[9:0]);
      FpMantDecShiftRight_10U_6U_10U_least_bits_slc_FpMantDecShiftRight_10U_6U_10U_least_mask_10_itm_2
          <= FpMantDecShiftRight_10U_6U_10U_least_mask_sva[10];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      cfg_truncate_1_sva_4 <= 6'b0;
      IntMulExt_26U_16U_42U_return_sva_2 <= 42'b0;
    end
    else if ( cfg_truncate_and_1_cse ) begin
      cfg_truncate_1_sva_4 <= cfg_truncate_1_sva_3;
      IntMulExt_26U_16U_42U_return_sva_2 <= conv_s2u_42_42($signed(IntSubExt_25U_25U_26U_o_acc_itm_2)
          * $signed(cfg_mul_in_1_sva_3));
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_4
          <= 1'b0;
    end
    else if ( core_wen & (~ and_dcpl_22) & (~ mux_75_itm) ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_4
          <= FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_3
          <= 1'b0;
    end
    else if ( core_wen & ((or_2_cse & FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1)
        | and_89_rgt) & (~ mux_75_itm) ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_3
          <= MUX_s_1_2_2(FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1, FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs,
          and_89_rgt);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_3
          <= 1'b0;
    end
    else if ( core_wen & ((or_2_cse & FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1
        & (~ FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1)) | and_92_rgt) &
        (~ mux_75_itm) ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_3
          <= MUX_s_1_2_2(FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_itm_6, FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs,
          and_92_rgt);
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      IsNaN_6U_10U_nor_itm_2 <= 1'b0;
      IsNaN_6U_10U_IsNaN_6U_10U_nand_itm_2 <= 1'b0;
    end
    else if ( IsNaN_6U_10U_and_cse ) begin
      IsNaN_6U_10U_nor_itm_2 <= ~((chn_data_in_rsci_d_mxwt[9:0]!=10'b0000000000));
      IsNaN_6U_10U_IsNaN_6U_10U_nand_itm_2 <= ~((chn_data_in_rsci_d_mxwt[15:10]==6'b111111));
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      IntSubExt_25U_25U_26U_1_o_acc_itm_2 <= 26'b0;
      cfg_mul_in_1_sva_3 <= 16'b0;
      IntSubExt_25U_25U_26U_o_acc_itm_2 <= 26'b0;
    end
    else if ( IntSubExt_25U_25U_26U_1_o_and_cse ) begin
      IntSubExt_25U_25U_26U_1_o_acc_itm_2 <= nl_IntSubExt_25U_25U_26U_1_o_acc_itm_2[25:0];
      cfg_mul_in_1_sva_3 <= cfg_mul_in_rsci_d;
      IntSubExt_25U_25U_26U_o_acc_itm_2 <= nl_IntSubExt_25U_25U_26U_o_acc_itm_2[25:0];
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs
          <= 1'b0;
    end
    else if ( core_wen & (~(and_dcpl_22 | (~ chn_data_in_rsci_bawt) | (cfg_precision_rsci_d!=2'b10)
        | (~ FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1) | FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1
        | (fsm_output[0]))) ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs
          <= FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_itm_6;
    end
  end
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs
          <= 1'b0;
    end
    else if ( core_wen & (~(and_dcpl_22 | (~ chn_data_in_rsci_bawt) | (cfg_precision_rsci_d!=2'b10)
        | (~ FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1) | (fsm_output[0]))) ) begin
      FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs
          <= FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1;
    end
  end
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_mux_6_nl = MUX_v_4_2_2(4'b1110, reg_IntShiftRight_42U_6U_8U_1_obits_fixed_nor_2_1_itm,
      FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_6);
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_FpExpoWidthDec_6U_5U_10U_1U_1U_or_3_nl =
      MUX_v_4_2_2((FpExpoWidthDec_6U_5U_10U_1U_1U_mux_6_nl), 4'b1111, IsNaN_6U_10U_land_lpi_1_dfm_5);
  assign nl_IntShiftRightSat_42U_6U_8U_oif_1_acc_nl = conv_s2s_8_9({IntShiftRightSat_42U_6U_8U_o_7_sva
      , IntShiftRightSat_42U_6U_8U_o_6_1_sva , IntShiftRightSat_42U_6U_8U_o_0_sva})
      + 9'b111111111;
  assign IntShiftRightSat_42U_6U_8U_oif_1_acc_nl = nl_IntShiftRightSat_42U_6U_8U_oif_1_acc_nl[8:0];
  assign nl_IntShiftRightSat_42U_6U_8U_oif_acc_nl = conv_s2s_8_9({IntShiftRightSat_42U_6U_8U_o_7_sva
      , IntShiftRightSat_42U_6U_8U_o_6_1_sva , IntShiftRightSat_42U_6U_8U_o_0_sva})
      + 9'b1;
  assign IntShiftRightSat_42U_6U_8U_oif_acc_nl = nl_IntShiftRightSat_42U_6U_8U_oif_acc_nl[8:0];
  assign IntShiftRightSat_42U_6U_8U_if_IntShiftRightSat_42U_6U_8U_if_or_1_nl = (IntShiftRightSat_42U_6U_8U_i_sva_2
      == conv_s2s_9_42(IntShiftRightSat_42U_6U_8U_oif_1_acc_nl)) | (IntShiftRightSat_42U_6U_8U_i_sva_2
      == conv_s2s_9_42(IntShiftRightSat_42U_6U_8U_oif_acc_nl)) | (IntShiftRightSat_42U_6U_8U_i_sva_2
      == conv_s2s_8_42({IntShiftRightSat_42U_6U_8U_o_7_sva , IntShiftRightSat_42U_6U_8U_o_6_1_sva
      , IntShiftRightSat_42U_6U_8U_o_0_sva}));
  assign mux_nl = MUX_s_1_2_2((IntShiftRightSat_42U_6U_8U_if_IntShiftRightSat_42U_6U_8U_if_or_1_nl),
      FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_6,
      nor_tmp_43);
  assign nl_IntShiftRightSat_42U_6U_8U_1_oif_1_acc_nl = conv_s2s_8_9({IntShiftRightSat_42U_6U_8U_1_o_7_sva
      , IntShiftRightSat_42U_6U_8U_1_o_6_1_sva , IntShiftRightSat_42U_6U_8U_1_o_0_sva})
      + 9'b111111111;
  assign IntShiftRightSat_42U_6U_8U_1_oif_1_acc_nl = nl_IntShiftRightSat_42U_6U_8U_1_oif_1_acc_nl[8:0];
  assign IntShiftRightSat_42U_6U_8U_1_oelse_mux_1_nl = MUX_s_1_2_2(IntShiftRightSat_42U_6U_8U_1_lor_lpi_1_dfm_mx1w0,
      IntShiftRightSat_42U_6U_8U_1_lor_lpi_1_dfm, or_dcpl_10);
  assign nor_nl = ~((cfg_precision_rsci_d!=2'b10) | (~ chn_data_in_rsci_bawt));
  assign and_151_nl = main_stage_v_1 & (~ or_7_cse);
  assign mux_8_nl = MUX_s_1_2_2((and_151_nl), (nor_nl), or_2_cse);
  assign nor_87_nl = ~(FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1 | (~ FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1)
      | (cfg_precision_rsci_d!=2'b10) | (~ main_stage_en_1));
  assign or_11_nl = FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_itm_5_1 | (~ FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1)
      | (cfg_precision_rsci_d!=2'b10);
  assign mux_9_nl = MUX_s_1_2_2(or_tmp_11, (~ or_2_cse), or_11_nl);
  assign or_8_nl = (~ main_stage_v_1) | (io_read_cfg_precision_rsc_svs_st_4!=2'b10)
      | (~ FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_4)
      | FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_st_3;
  assign mux_10_nl = MUX_s_1_2_2((mux_9_nl), (nor_87_nl), or_8_nl);
  assign or_13_nl = (~ FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1) | (cfg_precision_rsci_d!=2'b10);
  assign mux_11_nl = MUX_s_1_2_2(or_tmp_11, (~ or_2_cse), or_13_nl);
  assign and_149_nl = FpExpoWidthDec_6U_5U_10U_1U_1U_acc_itm_6_1 & (cfg_precision_rsci_d==2'b10)
      & main_stage_en_1;
  assign and_150_nl = main_stage_v_1 & (io_read_cfg_precision_rsc_svs_st_4==2'b10)
      & FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_4;
  assign mux_12_nl = MUX_s_1_2_2((and_149_nl), (mux_11_nl), and_150_nl);
  assign mux_15_nl = MUX_s_1_2_2(main_stage_en_1, or_tmp_11, main_stage_v_1);
  assign and_147_nl = (io_read_cfg_precision_rsc_svs_st_4[1]) & FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_4
      & (~ FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_st_3)
      & main_stage_v_1;
  assign mux_16_nl = MUX_s_1_2_2((and_147_nl), main_stage_v_1, io_read_cfg_precision_rsc_svs_st_4[0]);
  assign and_148_nl = (io_read_cfg_precision_rsc_svs_st_5[1]) & FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_st_4
      & (~ FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_st_4)
      & main_stage_v_2;
  assign mux_17_nl = MUX_s_1_2_2((and_148_nl), main_stage_v_2, io_read_cfg_precision_rsc_svs_st_5[0]);
  assign mux_18_nl = MUX_s_1_2_2((mux_17_nl), (mux_16_nl), or_2_cse);
  assign nand_1_nl = ~(nor_10_cse & (~(FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_st_4
      & main_stage_v_2)));
  assign nor_9_nl = ~((io_read_cfg_precision_rsc_svs_st_5!=2'b10));
  assign mux_19_nl = MUX_s_1_2_2(or_2_cse, (nand_1_nl), nor_9_nl);
  assign and_146_nl = (io_read_cfg_precision_rsc_svs_st_4[1]) & FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_4;
  assign mux_20_nl = MUX_s_1_2_2(or_tmp_25, (~ (mux_19_nl)), and_146_nl);
  assign or_24_nl = (~ main_stage_v_1) | (io_read_cfg_precision_rsc_svs_st_4[0]);
  assign mux_21_nl = MUX_s_1_2_2((mux_20_nl), or_tmp_25, or_24_nl);
  assign mux_22_nl = MUX_s_1_2_2(or_2_cse, or_tmp_28, or_28_cse);
  assign mux_23_nl = MUX_s_1_2_2(not_tmp_25, (mux_22_nl), or_27_cse);
  assign mux_24_nl = MUX_s_1_2_2(not_tmp_25, (mux_23_nl), main_stage_v_1);
  assign mux_85_nl = MUX_s_1_2_2((~ (io_read_cfg_precision_rsc_svs_st_4[1])), IntShiftRightSat_50U_6U_16U_IntShiftRightSat_50U_6U_16U_oelse_IntShiftRightSat_50U_6U_16U_if_unequal_tmp,
      io_read_cfg_precision_rsc_svs_st_4[0]);
  assign nl_IntShiftRightSat_50U_6U_16U_oif_1_acc_nl = conv_s2s_16_17({IntShiftRightSat_50U_6U_16U_o_15_sva_3
      , reg_IntShiftRightSat_50U_6U_16U_o_14_1_itm , reg_IntShiftRightSat_50U_6U_16U_o_14_1_2_itm
      , IntShiftRightSat_50U_6U_16U_o_0_sva_3}) + 17'b11111111111111111;
  assign IntShiftRightSat_50U_6U_16U_oif_1_acc_nl = nl_IntShiftRightSat_50U_6U_16U_oif_1_acc_nl[16:0];
  assign nl_IntShiftRightSat_50U_6U_16U_oif_acc_nl = conv_s2s_16_17({IntShiftRightSat_50U_6U_16U_o_15_sva_3
      , reg_IntShiftRightSat_50U_6U_16U_o_14_1_itm , reg_IntShiftRightSat_50U_6U_16U_o_14_1_2_itm
      , IntShiftRightSat_50U_6U_16U_o_0_sva_3}) + 17'b1;
  assign IntShiftRightSat_50U_6U_16U_oif_acc_nl = nl_IntShiftRightSat_50U_6U_16U_oif_acc_nl[16:0];
  assign IntShiftRightSat_50U_6U_16U_if_IntShiftRightSat_50U_6U_16U_if_or_1_nl =
      (({reg_IntShiftRightSat_50U_6U_16U_i_itm , reg_IntShiftRightSat_50U_6U_16U_i_1_itm})
      == conv_s2s_17_50(IntShiftRightSat_50U_6U_16U_oif_1_acc_nl)) | (~((({reg_IntShiftRightSat_50U_6U_16U_i_itm
      , reg_IntShiftRightSat_50U_6U_16U_i_1_itm}) != conv_s2s_17_50(IntShiftRightSat_50U_6U_16U_oif_acc_nl))
      & FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_st_4));
  assign nor_70_nl = ~((io_read_cfg_precision_rsc_svs_st_5!=2'b10) | IsNaN_6U_10U_land_lpi_1_dfm_4
      | (~ main_stage_v_2));
  assign mux_40_nl = MUX_s_1_2_2((nor_70_nl), main_stage_v_2, nor_tmp_42);
  assign and_139_nl = ((~(equal_tmp_2 | (io_read_cfg_precision_rsc_svs_st_6!=2'b10)
      | IsNaN_6U_10U_land_lpi_1_dfm_5)) | nor_tmp_43) & main_stage_v_3;
  assign mux_41_nl = MUX_s_1_2_2((and_139_nl), (mux_40_nl), or_2_cse);
  assign nor_67_nl = ~((~ main_stage_v_2) | (io_read_cfg_precision_rsc_svs_st_5!=2'b10)
      | nor_tmp_42);
  assign nor_69_nl = ~((~ main_stage_v_3) | equal_tmp_2 | nor_tmp_43 | (io_read_cfg_precision_rsc_svs_st_6!=2'b10));
  assign mux_42_nl = MUX_s_1_2_2((nor_69_nl), (nor_67_nl), or_2_cse);
  assign mux_43_nl = MUX_s_1_2_2(not_tmp_42, or_tmp_59, or_28_cse);
  assign mux_44_nl = MUX_s_1_2_2(not_tmp_42, or_tmp_59, or_27_cse);
  assign nor_63_nl = ~((~((~ main_stage_v_3) | (io_read_cfg_precision_rsc_svs_st_6!=2'b00)))
      | (~ reg_chn_data_out_rsci_ld_core_psct_cse) | chn_data_out_rsci_bawt);
  assign mux_45_nl = MUX_s_1_2_2(or_tmp_59, (nor_63_nl), chn_data_in_rsci_bawt);
  assign mux_46_nl = MUX_s_1_2_2((mux_45_nl), or_tmp_59, or_64_cse);
  assign mux_47_nl = MUX_s_1_2_2((mux_46_nl), (mux_44_nl), main_stage_v_1);
  assign mux_48_nl = MUX_s_1_2_2((mux_47_nl), (mux_43_nl), main_stage_v_2);
  assign nor_93_nl = ~((io_read_cfg_precision_rsc_svs_st_5[1]) | (~ nor_tmp));
  assign mux_87_nl = MUX_s_1_2_2(or_tmp_164, (nor_93_nl), or_28_cse);
  assign or_202_nl = nor_tmp_42 | (~ FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_5)
      | IsNaN_6U_10U_land_lpi_1_dfm_4;
  assign mux_88_nl = MUX_s_1_2_2((mux_87_nl), or_tmp_164, or_202_nl);
  assign nor_55_nl = ~(and_133_cse | (~ main_stage_v_2) | (io_read_cfg_precision_rsc_svs_st_5!=2'b00)
      | (~ or_2_cse));
  assign nand_12_nl = ~((and_133_cse | (~ main_stage_v_2) | (io_read_cfg_precision_rsc_svs_st_5!=2'b00))
      & or_2_cse);
  assign or_80_nl = and_135_cse | (~ main_stage_v_3) | (io_read_cfg_precision_rsc_svs_st_6!=2'b00);
  assign mux_56_nl = MUX_s_1_2_2((nand_12_nl), (nor_55_nl), or_80_nl);
  assign or_87_nl = nor_10_cse | nor_tmp_26;
  assign or_85_nl = (~ equal_tmp_2) | nor_tmp_43;
  assign mux_59_nl = MUX_s_1_2_2(mux_tmp_50, (or_87_nl), or_85_nl);
  assign mux_60_nl = MUX_s_1_2_2(mux_tmp_50, (mux_59_nl), main_stage_v_3);
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_mux_nl = MUX_v_10_2_2((FpMantDecShiftRight_10U_6U_10U_o_mant_sum_sva[9:0]),
      (i_data_sva_2_14_0_1[9:0]), FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_acc_6_svs_4);
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_not_13_nl = ~ FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_acc_5_svs_4;
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_nand_nl = ~(MUX_v_10_2_2(10'b0000000000,
      (FpExpoWidthDec_6U_5U_10U_1U_1U_else_else_mux_nl), (FpExpoWidthDec_6U_5U_10U_1U_1U_else_if_not_13_nl)));
  assign FpExpoWidthDec_6U_5U_10U_1U_1U_FpExpoWidthDec_6U_5U_10U_1U_1U_FpExpoWidthDec_6U_5U_10U_1U_1U_nand_nl
      = ~(MUX_v_10_2_2(10'b0000000000, (FpExpoWidthDec_6U_5U_10U_1U_1U_nand_nl),
      FpExpoWidthDec_6U_5U_10U_1U_1U_if_slc_FpExpoWidthDec_6U_5U_10U_1U_1U_acc_6_svs_5));
  assign IntShiftRightSat_50U_6U_16U_o_IntShiftRightSat_50U_6U_16U_o_nor_nl = ~(and_86_tmp
      | mux_84_tmp);
  assign IntShiftRightSat_50U_6U_16U_o_and_7_nl = and_86_tmp & (~ mux_84_tmp);
  assign or_89_nl = nor_10_cse | nor_tmp_29;
  assign nor_53_nl = ~(reg_chn_data_out_rsci_ld_core_psct_cse | (~ nor_tmp_29));
  assign mux_61_nl = MUX_s_1_2_2((nor_53_nl), nor_tmp_29, chn_data_out_rsci_bawt);
  assign and_131_nl = main_stage_v_3 & nor_tmp_43;
  assign mux_62_nl = MUX_s_1_2_2((mux_61_nl), (or_89_nl), and_131_nl);
  assign or_94_nl = nor_10_cse | nor_tmp_42 | not_tmp_57;
  assign nor_52_nl = ~(reg_chn_data_out_rsci_ld_core_psct_cse | (~ or_tmp_94));
  assign mux_63_nl = MUX_s_1_2_2((nor_52_nl), or_tmp_94, chn_data_out_rsci_bawt);
  assign or_91_nl = (~ main_stage_v_3) | equal_tmp_2 | nor_tmp_43;
  assign mux_64_nl = MUX_s_1_2_2((mux_63_nl), (or_94_nl), or_91_nl);
  assign nl_IntSubExt_33U_32U_34U_o_acc_nl = conv_s2s_33_34(chn_data_in_rsci_d_mxwt[32:0])
      - conv_s2s_32_34(cfg_alu_in_rsci_d);
  assign IntSubExt_33U_32U_34U_o_acc_nl = nl_IntSubExt_33U_32U_34U_o_acc_nl[33:0];
  assign nand_9_nl = ~((~((cfg_precision_rsci_d[0]) & chn_data_in_rsci_bawt)) & or_2_cse);
  assign and_130_nl = main_stage_v_1 & (io_read_cfg_precision_rsc_svs_st_4[0]);
  assign mux_67_nl = MUX_s_1_2_2(and_dcpl_16, (nand_9_nl), and_130_nl);
  assign nand_7_nl = ~((~(or_16_cse & chn_data_in_rsci_bawt)) & or_2_cse);
  assign nor_37_nl = ~((io_read_cfg_precision_rsc_svs_st_4!=2'b10));
  assign mux_68_nl = MUX_s_1_2_2((nand_7_nl), and_tmp_6, nor_37_nl);
  assign mux_69_nl = MUX_s_1_2_2(and_tmp_6, (mux_68_nl), main_stage_v_1);
  assign nl_IntSubExt_25U_25U_26U_1_o_acc_itm_2  = conv_s2s_25_26(chn_data_in_rsci_d_mxwt[49:25])
      - conv_s2s_25_26(cfg_alu_in_rsci_d[24:0]);
  assign nl_IntSubExt_25U_25U_26U_o_acc_itm_2  = conv_s2s_25_26(chn_data_in_rsci_d_mxwt[24:0])
      - conv_s2s_25_26(cfg_alu_in_rsci_d[24:0]);

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


  function [5:0] MUX1HOT_v_6_3_2;
    input [5:0] input_2;
    input [5:0] input_1;
    input [5:0] input_0;
    input [2:0] sel;
    reg [5:0] result;
  begin
    result = input_0 & {6{sel[0]}};
    result = result | ( input_1 & {6{sel[1]}});
    result = result | ( input_2 & {6{sel[2]}});
    MUX1HOT_v_6_3_2 = result;
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


  function [13:0] MUX_v_14_2_2;
    input [13:0] input_0;
    input [13:0] input_1;
    input [0:0] sel;
    reg [13:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_14_2_2 = result;
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


  function  [8:0] conv_s2s_8_9 ;
    input [7:0]  vector ;
  begin
    conv_s2s_8_9 = {vector[7], vector};
  end
  endfunction


  function  [41:0] conv_s2s_8_42 ;
    input [7:0]  vector ;
  begin
    conv_s2s_8_42 = {{34{vector[7]}}, vector};
  end
  endfunction


  function  [41:0] conv_s2s_9_42 ;
    input [8:0]  vector ;
  begin
    conv_s2s_9_42 = {{33{vector[8]}}, vector};
  end
  endfunction


  function  [16:0] conv_s2s_16_17 ;
    input [15:0]  vector ;
  begin
    conv_s2s_16_17 = {vector[15], vector};
  end
  endfunction


  function  [49:0] conv_s2s_16_50 ;
    input [15:0]  vector ;
  begin
    conv_s2s_16_50 = {{34{vector[15]}}, vector};
  end
  endfunction


  function  [49:0] conv_s2s_17_50 ;
    input [16:0]  vector ;
  begin
    conv_s2s_17_50 = {{33{vector[16]}}, vector};
  end
  endfunction


  function  [25:0] conv_s2s_25_26 ;
    input [24:0]  vector ;
  begin
    conv_s2s_25_26 = {vector[24], vector};
  end
  endfunction


  function  [33:0] conv_s2s_32_34 ;
    input [31:0]  vector ;
  begin
    conv_s2s_32_34 = {{2{vector[31]}}, vector};
  end
  endfunction


  function  [33:0] conv_s2s_33_34 ;
    input [32:0]  vector ;
  begin
    conv_s2s_33_34 = {vector[32], vector};
  end
  endfunction


  function  [42:0] conv_s2s_42_43 ;
    input [41:0]  vector ;
  begin
    conv_s2s_42_43 = {vector[41], vector};
  end
  endfunction


  function  [50:0] conv_s2s_50_51 ;
    input [49:0]  vector ;
  begin
    conv_s2s_50_51 = {vector[49], vector};
  end
  endfunction


  function  [41:0] conv_s2u_42_42 ;
    input [41:0]  vector ;
  begin
    conv_s2u_42_42 = vector;
  end
  endfunction


  function  [49:0] conv_s2u_50_50 ;
    input [49:0]  vector ;
  begin
    conv_s2u_50_50 = vector;
  end
  endfunction


  function  [42:0] conv_u2s_1_43 ;
    input [0:0]  vector ;
  begin
    conv_u2s_1_43 = {{42{1'b0}}, vector};
  end
  endfunction


  function  [50:0] conv_u2s_1_51 ;
    input [0:0]  vector ;
  begin
    conv_u2s_1_51 = {{50{1'b0}}, vector};
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


  function  [41:0] conv_u2u_42_42 ;
    input [41:0]  vector ;
  begin
    conv_u2u_42_42 = vector;
  end
  endfunction

endmodule

// ------------------------------------------------------------------
//  Design Unit:    HLS_cdp_ocvt
// ------------------------------------------------------------------


module HLS_cdp_ocvt (
  nvdla_core_clk, nvdla_core_rstn, chn_data_in_rsc_z, chn_data_in_rsc_vz, chn_data_in_rsc_lz,
      cfg_alu_in_rsc_z, cfg_mul_in_rsc_z, cfg_truncate_rsc_z, cfg_precision_rsc_z,
      chn_data_out_rsc_z, chn_data_out_rsc_vz, chn_data_out_rsc_lz
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [49:0] chn_data_in_rsc_z;
  input chn_data_in_rsc_vz;
  output chn_data_in_rsc_lz;
  input [31:0] cfg_alu_in_rsc_z;
  input [15:0] cfg_mul_in_rsc_z;
  input [5:0] cfg_truncate_rsc_z;
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
  CDP_OCVT_chn_data_in_rsci_unreg chn_data_in_rsci_unreg_inst (
      .in_0(chn_data_in_rsci_oswt_unreg),
      .outsig(chn_data_in_rsci_oswt)
    );
  CDP_OCVT_chn_data_out_rsci_unreg chn_data_out_rsci_unreg_inst (
      .in_0(chn_data_out_rsci_oswt_unreg),
      .outsig(chn_data_out_rsci_oswt)
    );
  HLS_cdp_ocvt_core HLS_cdp_ocvt_core_inst (
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



