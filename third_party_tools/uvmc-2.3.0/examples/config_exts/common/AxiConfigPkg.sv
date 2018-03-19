//============================================================================
// @(#) $Id: AxiConfigPkg.sv 1379 2015-02-17 00:13:20Z jstickle $
//============================================================================

   //_______________________
  // Mentor Graphics, Corp. \_________________________________________________
 //                                                                         //
//   (C) Copyright, Mentor Graphics, Corp. 2003-2014                        //
//   All Rights Reserved                                                    //
//                                                                          //
//    Licensed under the Apache License, Version 2.0 (the                   //
//    "License"); you may not use this file except in                       //
//    compliance with the License.  You may obtain a copy of                //
//    the License at                                                        //
//                                                                          //
//        http://www.apache.org/licenses/LICENSE-2.0                        //
//                                                                          //
//    Unless required by applicable law or agreed to in                     //
//    writing, software distributed under the License is                    //
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR                //
//    CONDITIONS OF ANY KIND, either express or implied.  See               //
//    the License for the specific language governing                      //
//    permissions and limitations under the License.                      //
//-----------------------------------------------------------------------//

//______________________                                      ________________
// package AxiConfigPkg \____________________________________/ johnS 8-31-2012
//
// This package packages class AxiConfig described below.
//----------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Title: AXI config extension SV example
// ---------------------------------------------------------------------------
//
// For the SV-side we necessarily define all the AXi config fields exactly
// identically to those for the SC-side. See <AXI config extension SC example>
// for details of field definitions for static and sideband configuration
// extensions.
//
// -------------------------------------------------------------
// Group: package AxiConfigPkg (SV-side definition)
// -------------------------------------------------------------
//
// For the SV-side we define a package to contain the config extension
// class as well as the *class AxiConfig* definition itself, again
// as an extension of reusable *class uvmc_xl_config*.
//----------------------------------------------------------------------------

// (begin inline source)

package AxiConfigPkg; // {

// (end inline source)


    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import uvmc_pkg::*;

    typedef enum bit [1:0] {
        AXI_FIXED = 2'd0,
        AXI_INCR = 2'd1,
        AXI_WRAP = 2'd2,
        AXI_BURST_RSVD = 2'd3
    } axi_burst_e;

    typedef enum bit [1:0] {
        AXI_NORMAL = 2'd0,
        AXI_EXCLUSIVE = 2'd1,
        AXI_LOCKED = 2'd2,
        AXI_LOCK_RSVD = 2'd3
    } axi_lock_e;

    typedef enum bit [2:0] {
        AXI_NORM_SEC_DATA = 3'd0,
        AXI_PRIV_SEC_DATA = 3'd1,
        AXI_NORM_NONSEC_DATA = 3'd2,
        AXI_PRIV_NONSEC_DATA = 3'd3,
        AXI_NORM_SEC_INST = 3'd4,
        AXI_PRIV_SEC_INST = 3'd5,
        AXI_NORM_NONSEC_INST = 3'd6,
        AXI_PRIV_NONSEC_INST = 3'd7
    } axi_prot_e;

    typedef enum bit [3:0] {
        AXI_NONCACHE_NONBUF = 4'd0,
        AXI_BUF_ONLY = 4'd1,
        AXI_CACHE_NOALLOC = 4'd2,
        AXI_CACHE_BUF_NOALLOC = 4'd3,
        AXI_CACHE_RSVD0 = 4'd4,
        AXI_CACHE_RSVD1 = 4'd5,
        AXI_CACHE_WTHROUGH_ALLOC_R_ONLY = 4'd6,
        AXI_CACHE_WBACK_ALLOC_R_ONLY = 4'd7,
        AXI_CACHE_RSVD2 = 4'd8,
        AXI_CACHE_RSVD3 = 4'd9,
        AXI_CACHE_WTHROUGH_ALLOC_W_ONLY = 4'd10,
        AXI_CACHE_WBACK_ALLOC_W_ONLY = 4'd11,
        AXI_CACHE_RSVD4 = 4'd12,
        AXI_CACHE_RSVD5 = 4'd13,
        AXI_CACHE_WTHROUGH_ALLOC_RW = 4'd14,
        AXI_CACHE_WBACK_ALLOC_RW = 4'd15
    } axi_cache_e;

//_________________                                            _______________
// class AxiConfig \__________________________________________/ johnS 1-2-2013
//----------------------------------------------------------------------------

// -------------------------------------------------------------
// Topic: class AxiConfig (SV-side definition)
// -------------------------------------------------------------
//
// This is an AXI master transactor protocol specific extension to the
// TLM generic payload that can be used as an ignorable extension to the
// generic payload transactions used by AXI master initiators.
//
// Notice that in the SV-side definition, the static and sideband configuration
// dimensioning is done using class parametrization (in contrast to SC-side
// which uses constructor args).
//
// See comments in SC-side AxiConfig.h for more details.
//----------------------------------------------------------------------------

// (begin inline source)
class AxiConfig extends uvmc_xl_config #(
    ( 16*2 + 8*3 ) / 8,      // staticConfigNumBytes
    ( 32*1 + 8*1 ) / 8 );    // sidebandConfigNumBytes
// {
    `uvm_object_utils( AxiConfig )

// ...
// (end inline source)

  //public:

    function new( string name="AxiConfig" );
        super.new( name );
    endfunction

    // -------------------------------------------------------------
    // Topic: AXI configuration register field accessors
    //
    // Like its SC-side counterpart, our *class AxiConfig* will need special
    // accessors to access the individual register fields to ~set~ and ~get~
    // individual register field values. See ~AxiConfig.h~ for more explanation
    // of the SC-side accessors as these are defined in an identical way here.
    // -------------------------------------------------------------

    // (begin inline source)

    // Static config 'set' accessors
    function void setDataWidth( int unsigned dataWidth );
        set_static_config( dataWidth, 0, 16 ); endfunction
    function void setAddrWidth( int unsigned addrWidth );
        set_static_config( addrWidth, 16, 16 ); endfunction

    function void setLockType( axi_lock_e lockType );
        set_static_config( unsigned'(lockType), 32, 8 ); endfunction
    function void setCacheType( axi_cache_e cacheType );
        set_static_config( unsigned'(cacheType), 40, 8 ); endfunction
    function void setProtType( axi_prot_e protType );
        set_static_config( unsigned'(protType), 48, 8 ); endfunction

    // Sideband config 'set' accessors
    function void setAid( int unsigned aid );
        set_sideband_config( aid, 0, 32 ); endfunction
    function void setBurstType( axi_burst_e burstType );
        set_sideband_config( unsigned'(burstType), 32, 8 ); endfunction

    // Static config 'get' accessors
    function int unsigned getDataWidth();
        return get_static_config(  0, 16 ); endfunction
    function int unsigned getAddrWidth();
        return get_static_config( 16, 16 ); endfunction

    function axi_lock_e getLockType();
        return axi_lock_e'(get_static_config( 32, 8 )); endfunction
    function axi_cache_e getCacheType();
        return axi_cache_e'(get_static_config( 40, 8 )); endfunction
    function axi_prot_e getProtType();
        return axi_prot_e'(get_static_config( 48, 8 )); endfunction

    // Sideband config 'get' accessors
    function int unsigned getAid();
        return get_sideband_config( 0, 32 ); endfunction
    function axi_burst_e getBurstType();
        return axi_burst_e'(get_sideband_config( 32, 8 )); endfunction

    // (end inline source)

endclass // } AxiConfig

endpackage // } AxiConfigPkg
