//============================================================================
// @(#) $Id: AxiConfig.h 1379 2015-02-17 00:13:20Z jstickle $
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

#ifndef _AxiConfig_h
#define _AxiConfig_h

#include "tlm.h"
#include "uvmc_xl_config.h"

using namespace std;

//_________________                                            _______________
// class AxiConfig \__________________________________________/ johnS 1-2-2013
//----------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Title: AXI config extension SC example
// ---------------------------------------------------------------------------

// -------------------------------------------------------------
// Topic: Customizing class uvmc_xl_config for AXI configuration
// -------------------------------------------------------------
//
// This example demonstrates an AXI master transactor protocol specific
// extension to the TLM generic payload that can be used as an ignorable
// extension to the generic payload transactions used by AXI master
// initiators and targets.
//
// Specifically it can be used to specify AXI master transactor
// configurations and to allow ~config query~ and ~config update~ operations
// on those configurations.
//
// This allows for optionally simultaneously updating the configuration
// when using the generic payload for its normal purpose which is to
// allow the AXI master client to send WRITE or READ transactions along the
// forward path.
//
// This extension is ignorable as per the definition of "ignorable extensions"
// in the TLM-2.0 LRM. If not specified, configurations are not updated
// in the transactor - just the bus transaction is sent.
//
// So, it is possible to send a transaction to the target conduit in
// 4 modes:
//
// - Send a mainstream GP transaction only
// - Send a transaction + *sideband confuration* update, by specifying
//   a config extension piggy-backed on a non-empty mainstream TLM GP
// - *Update* the ~static configuration only~, by specifying extension and
//   indicating *numBytes=0, is_write()* in TLM GP (all other fields of the
//   TLM GP are unused in this mode)
// - *Query* the ~static configuration only~, by specifying extension and
//   indicating *numBytes=0, is_read()* in the TLM GP (all other fields of the
//   TLM GP are unused in this mode)
//
// For ~static config upate~ operations the new values of the register fields
// will be propgated from the initiator to the target.
//
// For ~static config query~ operations the current values of the register
// fields on the target side queried (i.e. read) by the initiator.
//
// For example an AXI master transactor IP model's API might allow specification
// of multiple parameters related to the transactions and/or transactor
// register configurations all of which must received over the UVM-Connect'ed
// TLM-2 socket via the TLM GP in any of the 4 modes shown above.
//
// If there is no corresponding pre-defined TLM GP field for a given AXI
// parameter (such as address, command, data, byte enables) then it is passed
// in a special way via TLM GP extensions as either a ~static configuration~
// or a ~sideband configuration~. The next section explains more about this
// in detail.
//
// -------------------------------------------------------------
// Topic: AXI configuration register field definitions
// -------------------------------------------------------------
//
// The following table shows our AXI master target IP's API parameters and how
// they might map directly to TLM GP fields or indirectly to config extension
// fields,
//
// | AXI param      Data type      What it is     TLM GP parameter
// | ---------      ---------      ----------     ----------------
// | addr           uint_64t       address        address
// | size           axi_size_e     beat size      streaming width
// | burst          axi_burst_e    burst type     sideband config (GP extension)
// | lock           axi_lock_e     lock type      static config (GP extension)
// | cache          axi_cache_e    cache type     static config (GP extension)
// | prot           axi_prot_e     prot type      static config (GP extension)
// | id             unsigned       AID            sideband config (GP extension)
// | burst_length   unsigned       burst length   data_length
// | data_words     svBitVecVal[]  payload        data_ptr
// | write_strobes  svBitVecVal[]  byte enables   byte_enables
// | resp           axi_response_e response       status response
// | auser_resp     svBitVecVal[]                 unsupported for now
//
// Static configurations are automatically passed via the generic
// payload as a ~separate dedicated transaction~ from the intiator
// to transactor IP target whenever the conduit automatically detects
// they have changed on the intiator side.
//
// Based on the table above, for our AXI transactor example we'll choose the
// following config register parameters to be represented by the ~static
// configuration only~,
//
// | Static configuration data payload layout LSWs -> MSWs:
// |     [16] DATA_WIDTH - READ ONLY
// |     [16] ADDR_WIDTH - READ ONLY
// |     [ 8] LOCK_TYPE
// |     [ 8] CACHE_TYPE
// |     [ 8] PROT_TYPE
//
// Sideband configurations are things that can change frequently (i.e. with
// each transaction typically). So they are "piggy backed" with each
// TLM GP transaction as an extension.
//
// For our AXI transactor example we'll choose the following config register
// parameters to be represented by the ~sideband configuration only~,
//
// | Sideband configuration data payload layout LSBs -> MSBs:
// |     [32] AID - Xaction ID
// |     [ 8] BURST_TYPE
//
// -------------------------------------------------------------
// Group: class AxiConfig (SC-side definition)
// -------------------------------------------------------------
//
// Now that we've decided the width of each register field and which
// fields should be included as part of the static configuration vs. the
// sideband configuration, we can define the *class AxiConfig* itself
// as an extension of reusable *class uvmc_xl_config*.
//----------------------------------------------------------------------------

// (begin inline source)

class AxiConfig : public uvmc::uvmc_xl_config {

// (end inline source)

  public:

    typedef enum {
        AXI_FIXED = 0,
        AXI_INCR,
        AXI_WRAP
    } axi_burst_e;

    typedef enum {
        AXI_NORMAL = 0,
        AXI_EXCLUSIVE,
        AXI_LOCKED
    } axi_lock_e;

    typedef enum {
        AXI_NORM_SEC_DATA = 0,
        AXI_PRIV_SEC_DATA,
        AXI_NORM_NONSEC_DATA,
        AXI_PRIV_NONSEC_DATA,
        AXI_NORM_SEC_INST,
        AXI_PRIV_SEC_INST,
        AXI_NORM_NONSEC_INST,
        AXI_PRIV_NONSEC_INST
    } axi_prot_e;

    typedef enum {
        AXI_NONCACHE_NONBUF = 0,
        AXI_BUF_ONLY = 1,
        AXI_CACHE_NOALLOC = 2,
        AXI_CACHE_BUF_NOALLOC = 3,
        AXI_CACHE_WTHROUGH_ALLOC_R_ONLY = 6,
        AXI_CACHE_WBACK_ALLOC_R_ONLY = 7,
        AXI_CACHE_WTHROUGH_ALLOC_W_ONLY = 10,
        AXI_CACHE_WBACK_ALLOC_W_ONLY = 11,
        AXI_CACHE_WTHROUGH_ALLOC_RW = 14,
        AXI_CACHE_WBACK_ALLOC_RW = 15
    } axi_cache_e;

    // -------------------------------------------------------------
    // Method: ::AxiConfig()
    //
    // And, in the definition of its constructor we can specify the total
    // number of bytes taken up by the static config and that taken up
    // by the sideband config ...

    // (begin inline source)
    AxiConfig()
      : uvmc::uvmc_xl_config(
          ( 16*2 + 8*3 ) / 8,      // staticConfigNumBytes
          ( 32*1 + 8*1 ) / 8 ) { } // sidebandConfigNumBytes
    // (end inline source)

    // -------------------------------------------------------------
    // Topic: AXI configuration register field accessors
    //
    // OK, now our *class AxiConfig* will need special accessors to access
    // the individual fields to ~set~ and ~get~ individual register
    // field values. Each of these accessors can use the underlying
    // ~::set_static_config(), ::get_static_config(), ::set_sideband_config()~,
    // and ~::get_sideband_config()~ accessors of base *class uvmc_xl_config*.
    //
    // The ~::set_*()~ base class accessor functions each take value, 
    // starting bit, and field width values as follows,
    //
    // | void uvmc_xl_config::set_static_config(
    // |     unsigned value, unsigned i, unsigned w );
    // |
    // | void uvmc_xl_config::set_sideband_config(
    // |     unsigned value, unsigned i, unsigned w )
    //
    // The ~::get_*()~ base class accessor functions each take starting bit,
    // and field width and return values as follows,
    //
    // | unsigned uvmc_xl_config::get_static_config(
    // |     unsigned i, unsigned w ) const
    // |
    // | unsigned uvmc_xl_config::get_sideband_config(
    // |     unsigned i, unsigned w ) const
    //
    // NOTE: These are modeled after SV 1800 DPI utility functions,
    // ~svPutPartselBit()~ and ~svGetPartselBit()~. Each value can have a
    // width up to, but not exceeding 32 bits. Larger widths will need
    // to be represented with multiple fields. Doing it this way facilitates
    // dovetailing UVM-Connect TLM fabric with DPI based APIs.
    //
    // OK, here then are the specific accessors for our *class AxiConfig*,
    // -------------------------------------------------------------

    // (begin inline source)

    // Static config 'set' accessors
    void setDataWidth( unsigned dataWidth ) {
        set_static_config( dataWidth, 0, 16 ); }
    void setAddrWidth( unsigned addrWidth ) {
        set_static_config( addrWidth, 16, 16 ); }

    void setLockType( axi_lock_e lockType ) {
        set_static_config( (unsigned)lockType, 32, 8 ); }
    void setCacheType( axi_cache_e cacheType ) {
        set_static_config( (unsigned)cacheType, 40, 8 ); }
    void setProtType( axi_prot_e protType ) {
        set_static_config( (unsigned)protType, 48, 8 ); }

    // Sideband config 'set' accessors
    void setAid( unsigned aid ) { set_sideband_config( aid, 0, 32 ); }
    void setBurstType( axi_burst_e burstType ) {
        set_sideband_config( (unsigned)burstType, 32, 8 ); }

    // Configuration queries are always sent back via the return payload of
    // a static configuration update with identical layout.

    // Static config 'get' accessors
    unsigned getDataWidth() const   { return get_static_config(  0, 16 ); }
    unsigned getAddrWidth() const   { return get_static_config( 16, 16 ); }

    axi_lock_e  getLockType() const{
        return (axi_lock_e)get_static_config( 32, 8 ); }
    axi_cache_e getCacheType() const{
        return (axi_cache_e)get_static_config( 40, 8 ); }
    axi_prot_e getProtType() const{
        return (axi_prot_e)get_static_config( 48, 8 ); }

    // Sideband config 'get' accessors
    unsigned getAid() const { return get_sideband_config( 0, 32 ); }
    axi_burst_e getBurstType() const{
        return (axi_burst_e)get_sideband_config( 32, 8 ); }

    // (end inline source)
};

#endif // _AxiConfig_h
