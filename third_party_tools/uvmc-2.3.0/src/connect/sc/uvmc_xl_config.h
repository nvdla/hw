//============================================================================
// @(#) $Id: uvmc_xl_config.h 1259 2014-11-29 21:16:42Z jstickle $
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

#ifndef _uvmc_xl_config_h
#define _uvmc_xl_config_h

#include <stdio.h>
#include <string>
#include "svdpi.h"

#include "tlm.h"

using namespace tlm;
using namespace sc_core;

namespace uvmc {

//___________________________                                 ________________
// class uvmc_xl_config_base \_______________________________/ johnS 10-3-2011
//
// This class is an ignorable extension that can be used to pass configurations
// that accompany generic payloads that travel from TLM-2.0 initiators to
// targets.
//
// The UVMC config extension base class uvmc_xl_config_base contains a simple
// abstraction of a set configuration registers that can act as shadows of the
// associated configuration register set one might find in the target model.
//
// 1. Static configuration register
//    The static confguration register is a vector of bit fields that
//    can be individually updated from the initiator and automatically
//    reflected into the target if any of the values have changed since
//    the last transport operation. There is a 'dirty bit' mechanism builtin
//    into this class uvmc_xl_config_base that can be used by TLM
//    interconnect fabric to automatically detect any such changes and
//    transmit the updated configuration as a separate forward transaction
//    using the generic payload data array if necessary.
//
//    Static configs can be used for configuring things that don't
//    change often such as UART baud rate, AXI wait randomized wait state
//    bounds and cross channel latencies.
//
// 2. Sideband configuration register
//
//    Sideband confgurations are unconditionally sent with each and
//    every generic payload transaction along the forward path to the target.
//
//    These should be used for things that typically change as frequently
//    as every transaction such as tid's for AXI transactions, tags for
//    Wishbone transactions, etc.
//
// The interconnect itself has no idea of the content or layout of the
// configuration register. That is known only by the initiator and by the
// target model.
//
// The interconnect conduit merely knows the register size in terms of a vector
// of bits and can automatically detect any changes in to the register's value
// and reflect them to the transactor side if necessary.
//----------------------------------------------------------------------------

class uvmc_xl_config_base : public tlm_extension<uvmc_xl_config_base> {
  private:
    unsigned short m_static_config_num_bytes;
    unsigned short m_sideband_config_num_bytes;
    svBitVecVal *m_static_config;
    svBitVecVal *m_sideband_config;
    bool m_is_static_config_dirty;
    bool m_is_deletion_enabled;

  public:
    //---------------------------------------------------------
    // Constructors/Destructors
    //---------------------------------------------------------

    uvmc_xl_config_base(
        unsigned short staticConfigNumBytes=0,
        unsigned short sidebandConfigNumBytes=0 );

    virtual ~uvmc_xl_config_base(){
        if( m_is_deletion_enabled ) {
            if( m_static_config ) delete [] m_static_config;
            if( m_sideband_config ) delete [] m_sideband_config;
        }
    }

    //---------------------------------------------------------
    // Accessors
    //---------------------------------------------------------

    //--------------------------------------
    // ::set_static_config()                      
    // ::get_static_config()
    // ::set_sideband_config()
    // ::get_sideband_config()
    // ::get_static_config_num_bytes()
    // ::get_sideband_config_num_bytes()
    //
    // These set* functions insert values into arbitrary slices anywhere
    // in the configuration register set.
    //
    // These get* functions query values from arbitrary slices anywhere
    // in the configuration register set.
    //--------------------------------------

    void set_static_config( unsigned value, unsigned i, unsigned w );
    unsigned get_static_config( unsigned i, unsigned w ) const;
    void set_sideband_config( unsigned value, unsigned i, unsigned w );
    unsigned get_sideband_config( unsigned i, unsigned w ) const;

    unsigned short get_static_config_num_bytes() const {
        return m_static_config_num_bytes; }
    unsigned short get_sideband_config_num_bytes() const {
        return m_sideband_config_num_bytes; }

    //--------------------------------------
    // ::is_dirty()
    // ::clear_is_dirty() 
    //
    // These set* functions allow 'dirty' querying for static configurations
    // only. During copy operations (see ::do_copy() below), the 'dirty' bit
    // for a static config is automatically set if there is a any change
    // from the current value of the static config register set. This can be
    // used to intellegently decide whether config updates need to be
    // propagated further through various stages the TLM fabric interconnect
    // - in cases where some "shadow" of the config register set is maintained
    // at intermediate points in the fabric.
    //--------------------------------------

    bool is_dirty() const { return m_is_static_config_dirty; }
    void clear_is_dirty() { m_is_static_config_dirty = 0; }

    //--------------------------------------
    // ::get_raw_static_config()
    // ::get_raw_sideband_config() 
    //
    // Accessors to return raw config arrays.
    //--------------------------------------

    unsigned char *get_raw_static_config() {
        return reinterpret_cast<unsigned char *>(m_static_config); }
    unsigned char *get_raw_sideband_config() {
        return reinterpret_cast<unsigned char *>(m_sideband_config); }

    //--------------------------------------
    // ::set_static_config_num_bytes()
    // ::set_raw_static_config()
    // ::set_sideband_config_num_bytes()
    // ::set_raw_sideband_config()
    //
    // These accessors are used only to take on an externally specified 
    // static or sideband config. They prevents deletion of the arrays on
    // destruction. It is meant to be used where efficient processing of
    // static, sideband configs is designed for use as an "in place" automatic
    // variable that can attach itself to storage to avoid heap overhead.
    //--------------------------------------

    void set_static_config_num_bytes( unsigned short staticConfigNumBytes )
    {   m_static_config_num_bytes = staticConfigNumBytes; }

    void set_raw_static_config( const unsigned char *staticConfig )
    {   m_is_deletion_enabled = false;
        m_static_config
            = const_cast<svBitVecVal *>(
                reinterpret_cast<const svBitVecVal *>(staticConfig)); }

    void set_sideband_config_num_bytes( unsigned short sidebandConfigNumBytes )
    {   m_sideband_config_num_bytes = sidebandConfigNumBytes; }

    void set_raw_sideband_config( const unsigned char *sidebandConfig )
    {   m_is_deletion_enabled = false;
        m_sideband_config
            = const_cast<svBitVecVal *>(
                reinterpret_cast<const svBitVecVal *>(sidebandConfig)); }

    //---------------------------------------------------------
    // ::clone()                       
    // ::copy_from()
    // ::copy_from_sideband_only()
    //
    // ::clone() and ::copy_from() are implementations of virtual functions
    // from base class tlm_extensions.
    //
    // ::copy_from() is the "workhorse" function to copy between
    // two config objects. Furthermore, the ::copy_from() function will
    // also automatically set the 'dirty' bit if the update causes a value
    // change in any of the config items. (See comments above for ::is_dirty()).
    //
    // ::copy_from_sideband_only() is a more optimized copy that can be used
    // if it is known only sideband config is needed.
    //---------------------------------------------------------

    virtual tlm_extension_base *clone() const;
    virtual void copy_from( tlm_extension_base const &ext );
    void copy_from_sideband_only( tlm_extension_base const &ext );

    //---------------------------------------------------------
    // Error Handlers                           -- johnS 4-1-11
    //---------------------------------------------------------

    void error_unsupported_call( const char *functionName ) const
    {   char messageBuffer[1024];
        sprintf( messageBuffer,
            "Call '%s' is not supported on this conduit.\n", functionName );
        SC_REPORT_FATAL( "XLVIP-FATAL", messageBuffer ); }

    void error_null_config( const char *functionName,
        int line, const char *file ) const 
    {   char messageBuffer[1024];
        sprintf( messageBuffer,
            "Attempted access of NULL conduit configuration extension, "
            "'%s' [line #%d of '%s'].\n", functionName, line, file );
        SC_REPORT_FATAL( "XLVIP-FATAL", messageBuffer ); }
};

//______________________                                      ________________
// class uvmc_xl_config \____________________________________/ johnS 10-3-2011
//
// This is a container class for the tlm_extension<uvmc_xl_config_base>.
//
// This container supports special operations to install the configuration
// object into a specified generic payload bound for the opposite side of the
// UVM-Connect'ion.
//
// It also has general purpose functions to set slice values anywhere
// in either the static or sideband configuration registers. And to
// prepare a generic payload for a configuration query operation.
//
// This class has two builtin, "pre-fabricated" transactions returned by
// these accessors:
//
//    query_trans()
//    update_trans()
//
// The "query" transaction can be used for querying a static configuration
// from the target endpoint.
//
// Simply pass either of these to a standard TLM-2 transport call and
// the operation will be performed.
//
// After a query op, any calls to access one of the local config register
// slices will return the new values queried from the opposite endpont.
// 
// After an update op, the opposite enpoint will have new values of any
// config register slices that were updated into one of the local config
// register slices prior to the operation.
//----------------------------------------------------------------------------

class uvmc_xl_config : public uvmc_xl_config_base {

  protected:
    // GP transaction holders for config queries and updates.
    tlm_generic_payload m_query_trans, m_update_trans;

  public:
    //---------------------------------------------------------
    // Constructors/Destructors
    //---------------------------------------------------------

    uvmc_xl_config(
        unsigned short staticConfigNumBytes,
        unsigned short sidebandConfigNumBytes = 0 )
        : uvmc_xl_config_base(
            staticConfigNumBytes, sidebandConfigNumBytes )
    {   unsigned char byteEnables = 0xff; // Not used.
        m_query_trans.set_read(); // is_read=1 to indicate static config query.
        m_query_trans.set_extension( this );
        m_query_trans.set_address( 0LL );   // Unused for config update/query.
        m_query_trans.set_data_length( 0 ); // Specify as 0 for config
                                            // update/query.
        m_query_trans.set_byte_enable_ptr( (unsigned char *)(&byteEnables) );
        m_query_trans.set_data_ptr( (unsigned char *)NULL );

        m_update_trans.set_write(); // is_write=1 to indicate static config
                                    // update.
        m_update_trans.set_extension( this );
        m_update_trans.set_address( 0LL );   // Unused for config update/query.
        m_update_trans.set_data_length( 0 ); // Specify as 0 for config
                                             // update/query.
        m_update_trans.set_byte_enable_ptr( (unsigned char *)(&byteEnables) );
        m_update_trans.set_data_ptr( (unsigned char *)NULL );
            // Unused for config update/query
    }

    ~uvmc_xl_config() {
      m_query_trans.clear_extension( this );
      m_update_trans.clear_extension( this );
    }

    //---------------------------------------------------------
    // Accessors

    tlm_generic_payload &query_trans() { return m_query_trans; }
    tlm_generic_payload &update_trans() { return m_update_trans; }
};

//---------------------------------------------------------
// get_partsel_bit()                        johnS 10-3-2012
// put_partsel_bit()
//
// These functions are functionally identical to their svdpi counterparts
// However the svdpi versions of these were replaced for portability to
// remote TLM clients that don't have access to svdpi.
//---------------------------------------------------------

svBitVecVal get_partsel_bit( const svBitVecVal *s, int i, int w );
void put_partsel_bit( svBitVecVal *d, const svBitVecVal s, int i, int w );

}; // namespace uvmc

#endif // _uvmc_xl_config_h
