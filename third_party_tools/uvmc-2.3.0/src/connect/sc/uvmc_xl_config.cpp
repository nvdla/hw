
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

#include "svdpi.h"

#include "uvmc_xl_config.h"

using namespace uvmc;

namespace uvmc {

//---------------------------------------------------------
// get_partsel_bit()                        johnS 10-3-2012
// put_partsel_bit()
//
// These functions are functionally identical to their svdpi counterparts
// However the svdpi versions of these were replaced for portability to
// remote TLM clients that don't have access to svdpi.
//---------------------------------------------------------

svBitVecVal get_partsel_bit(
    const svBitVecVal *s, int i, int w )
{   assert(w <= 32);
    svBitVecVal d=0;
    unsigned iMod32 = i & 0x1f;
    unsigned iPlusRange = iMod32 + w;
    unsigned loMask = 0xffffffff << iMod32;
    if (iPlusRange <= 32)
        loMask &= 0xffffffff >> (32 - iPlusRange);
    else {
        unsigned hiMask = ~(0xffffffff << (iPlusRange-32));
        d |= (((svBitVecVal*)s)[(i / 32) + 1] & hiMask) << (32 - iMod32);
    }
    d |= (((svBitVecVal*)s)[i / 32] & loMask) >> iMod32;
    return d;
}

/* actual <-- canonical */
void put_partsel_bit(
    svBitVecVal *d, const svBitVecVal s, int i, int w )
{   assert(w <= 32);

    unsigned iMod32 = i & 0x1f;
    unsigned iPlusRange = iMod32 + w;
    unsigned loMask = 0xffffffff << iMod32;
    if (iPlusRange <= 32)
        loMask &= 0xffffffff >> (32 - iPlusRange);
    else {
        iPlusRange -= 32;
        unsigned hiMask = ~(0xffffffff << iPlusRange);
        ((svBitVecVal*)d)[(i / 32) + 1] &= ~hiMask;
        ((svBitVecVal*)d)[(i / 32) + 1] |= hiMask & (s >> (w - iPlusRange));
    }
    ((svBitVecVal*)d)[i / 32] &= ~loMask;
    ((svBitVecVal*)d)[i / 32] |= loMask&(s << iMod32);
}

}; // namespace uvmc

//___________________________                                 ________________
// class uvmc_xl_config_base \_______________________________/ johnS 10-3-2011
//----------------------------------------------------------------------------
  
//---------------------------------------------------------
// Constructors/Destructors
//---------------------------------------------------------
  
uvmc_xl_config_base::uvmc_xl_config_base(
    unsigned short static_config_num_bytes,
    unsigned short sideband_config_num_bytes )
    : m_static_config_num_bytes(static_config_num_bytes),
      m_sideband_config_num_bytes(sideband_config_num_bytes),
      m_static_config(NULL), m_sideband_config(NULL),
      m_is_static_config_dirty(false),
      m_is_deletion_enabled(true)
{   unsigned short i;

    // Allocate and initialize static and sideband shadow configuration
    // registers. The actual static configuration register is in the
    // HDL target transactor connected to this conduit. And sideband
    // configurations are sent with each and every normal generic payload
    // transfer to the target.
    if( static_config_num_bytes ) {
        m_static_config = new svBitVecVal[
            SV_PACKED_DATA_NELEMS(static_config_num_bytes*8) ];
        for( i=0; i < SV_PACKED_DATA_NELEMS(static_config_num_bytes*8); i++ )
            m_static_config[i] = 0;
    }
    if( sideband_config_num_bytes ) {
        m_sideband_config = new svBitVecVal[
            SV_PACKED_DATA_NELEMS( sideband_config_num_bytes * 8 ) ];
        for( i=0; i < SV_PACKED_DATA_NELEMS(sideband_config_num_bytes*8); i++ )
            m_sideband_config[i] = 0;
    }
}

//---------------------------------------------------------
// ::set_static_config()                      johnS 10-3-11
// ::get_static_config()
// ::set_sideband_config()
// ::get_sideband_config()
//---------------------------------------------------------

void uvmc_xl_config_base::set_static_config(
        unsigned value, unsigned i, unsigned w )
{
    if( m_static_config == NULL ) {
        error_null_config( "uvmc_xl_config_base::set_static_config()",
            __LINE__, __FILE__ );
        return;
    }
    // NOTE: svdpi versions of these were replaced for portability to
    // remote TLM clients that don't have access to svdpi.
    put_partsel_bit( m_static_config, value, i, w );
}

unsigned uvmc_xl_config_base::get_static_config(
        unsigned i, unsigned w ) const
{
    if( m_static_config == NULL ) {
        error_null_config( "uvmc_xl_config_base::get_static_config()",
            __LINE__, __FILE__ );
        return 0;
    }
    return get_partsel_bit( m_static_config, i, w );
}

void uvmc_xl_config_base::set_sideband_config(
        unsigned value, unsigned i, unsigned w )
{
    if( m_sideband_config == NULL ) {
        error_null_config( "uvmc_xl_config_base::set_sideband_config()",
            __LINE__, __FILE__ );
        return;
    }
    put_partsel_bit( m_sideband_config, value, i, w );
}

unsigned uvmc_xl_config_base::get_sideband_config(
        unsigned i, unsigned w ) const
{  if( m_sideband_config == NULL ) {
        error_null_config( "uvmc_xl_config_base::get_sideband_config()",
            __LINE__, __FILE__ );
        return 0;
    }
    return get_partsel_bit( m_sideband_config, i, w );
}

//---------------------------------------------------------
// ::clone()                                  johnS 10-3-11
//---------------------------------------------------------

tlm_extension_base *uvmc_xl_config_base::clone() const {
    error_unsupported_call( "uvmc_xl_config_base::clone()" );
    return NULL;
}

//---------------------------------------------------------
// ::copy_from()                              johnS 10-3-11
//---------------------------------------------------------

void uvmc_xl_config_base::copy_from( tlm_extension_base const &ext ) {

    const uvmc_xl_config_base &rhs
        = static_cast<const uvmc_xl_config_base &>(ext);

    unsigned i, numBytes = m_static_config_num_bytes;

    if( numBytes > rhs.m_static_config_num_bytes ) // Copy only min # bytes.
        numBytes = rhs.m_static_config_num_bytes;
    
    for( i=0; i<numBytes; i++ ) {

        // Update config register and set 'is dirty' if changed.
        // This will allow the conduit to avoid a configuration update
        // being reflected to the HDL side unless it has actually changed.
        svBitVecVal value = 0, rhsValue = 0;

        value = get_partsel_bit( m_static_config, i*8, 8 );
        rhsValue = get_partsel_bit( rhs.m_static_config, i*8, 8 );
         
        if( value != rhsValue ) {
            m_is_static_config_dirty = true;
            put_partsel_bit( m_static_config, rhsValue, i*8, 8 );
        }
    }

    numBytes = m_sideband_config_num_bytes;
    if( numBytes > rhs.m_sideband_config_num_bytes ) // Copy only min # bytes.
        numBytes = rhs.m_sideband_config_num_bytes;
    for( i=0; i<SV_PACKED_DATA_NELEMS( numBytes*8 ); i++ )
        m_sideband_config[i] = rhs.m_sideband_config[i];
}

//---------------------------------------------------------
// ::copy_from_sideband_only()                johnS 10-3-11
//---------------------------------------------------------

void uvmc_xl_config_base::copy_from_sideband_only(
        tlm_extension_base const &ext ) {

    const uvmc_xl_config_base &rhs
        = static_cast<const uvmc_xl_config_base &>(ext);

    unsigned i, numBytes = m_sideband_config_num_bytes;
    for( i=0; i<SV_PACKED_DATA_NELEMS( numBytes*8 ); i++ )
        m_sideband_config[i] = rhs.m_sideband_config[i];
}
