//============================================================================
// @(#) $Id: uvmc_xl_config.svh 1259 2014-11-29 21:16:42Z jstickle $
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

`ifndef _uvmc_xl_config_svh_
`define _uvmc_xl_config_svh_

//____________________________                                ________________
// package uvmc_xl_config_pkg \______________________________/ johnS 6/10/2012
//
// This package defines the following classes that support UVM-Connect
// configuration extensions for both 'static' and 'sideband' configurations.
//
//   class uvmc_config_buffer
//   class uvmc_xl_config_base
//   class uvmc_xl_config
//----------------------------------------------------------------------------

//__________________________                                  ________________
// class uvmc_config_buffer \________________________________/ johnS 8-31-2012
//
// Helper class to provide a raw buffer for the config register storage and
// associated utility functions to pack/unpack bit slices of that buffer
// using similar techniques to those used for SV-P1800 DPI utility functions
// svGetPartselBit(), svPutParselBit().
//----------------------------------------------------------------------------

class uvmc_config_buffer; // {

    int unsigned m_length_in_bytes;
    int unsigned m_data_array[];

    //---------------------------------------------------------
    // Constructor                              johnS 7-26-2010
    //---------------------------------------------------------

    function new( int unsigned numBytes = 0 );
        m_length_in_bytes = numBytes;
        if( m_length_in_bytes != 0 )
            m_data_array = new[ ((m_length_in_bytes-1)/4) + 1 ];
    endfunction

    //---------------------------------------------------------
    // void resize()                         -- johnS 7-26-2010
    //---------------------------------------------------------

    function void resize( int unsigned newLengthInBytes );
        if( newLengthInBytes > m_length_in_bytes ) begin
            m_length_in_bytes = newLengthInBytes;
            m_data_array = new[ ((m_length_in_bytes-1)/4) + 1 ]( m_data_array );
        end
    endfunction


    //---------------------------------------------------------
    // void get_partsel_bit()                -- johnS 7-26-2010
    // void put_partsel_bit()
    //
    // These routines extract/pack an arbitrary slice up to 32 bits
    // in width from/to an arbitrary bit position in the m_data_array.
    //
    // These routines are modeled after the svGet/PutPartselBit() routines
    // that are part of the SystemVerilog DPI standard for bit slice
    // extraction/packing from/to an svBitVecVal[] bit vector abstraction
    // represented in C.
    //
    // For extraction a narrow (<= 32 bits) part select is extracted from
    // the m_data_array representation and written into the destination word.
    //
    // For packing a narrow (<= 32 bits) part select is selected in
    // the m_data_array representation to be the target of the source slice.
    //
    // Normalized ranges and indexing [n-1:0] are used for both arrays.
    //
    // s = source, d = destination, i = starting bit index, w = width
    //---------------------------------------------------------

    function int unsigned  get_partsel_bit(
            input int unsigned i,
            input int unsigned w );
    // {
        bit[31:0] d;

        int unsigned iMod32 = i & 32'h1f;
        int unsigned iPlusRange = iMod32 + w;

        bit [31:0] hiMask;
        bit [31:0] loMask = 32'hffffffff << iMod32;

        d = 0;

        if( iPlusRange <= 32 )
            loMask &= 32'hffffffff >> (32 - iPlusRange);

        else begin
            hiMask = ~(32'hffffffff << (iPlusRange - 32));
            d |= (m_data_array[i/32+1] & hiMask) << (32 - iMod32);
        end

        d |= (m_data_array[i/32] & loMask) >> iMod32;

        return d;

    endfunction // }

    function void put_partsel_bit(
            input int unsigned i,
            input int unsigned w,
            input bit [31:0] s );
    // {
        int unsigned iMod32 = i & 32'h1f;
        int unsigned iPlusRange = iMod32 + w;

        bit [31:0] hiMask;
        bit [31:0] loMask = 32'hffffffff << iMod32;

        if( iPlusRange <= 32 )
            loMask &= 32'hffffffff >> (32 - iPlusRange);

        else begin
            iPlusRange -= 32;
            hiMask = ~(32'hffffffff << iPlusRange);

            m_data_array[i/32+1] &= ~hiMask;
            m_data_array[i/32+1] |= hiMask & (s >> (w-iPlusRange));
        end

        m_data_array[i/32] &= ~loMask;
        m_data_array[i/32] |= loMask & (s << iMod32);

    endfunction // }

endclass // }

//___________________________                                 ________________
// class uvmc_xl_config_base \_______________________________/ johnS 8-31-2012
//----------------------------------------------------------------------------

class uvmc_xl_config_base extends uvm_tlm_extension#( uvmc_xl_config_base );
// {
    `uvm_object_utils( uvmc_xl_config_base )

  // private:
    uvmc_config_buffer m_static_config;
    uvmc_config_buffer m_sideband_config;
    local bit m_is_static_config_dirty;

  //public:

    //-------------------------------------------
    // Constructor

    function new( string name = "uvmc_xl_config_base" );
        super.new(name);
    endfunction

    function void setup(
            shortint unsigned staticConfigNumBytes,
            shortint unsigned sidebandConfigNumBytes );
        int unsigned i;
        m_static_config = new( staticConfigNumBytes );
        if( staticConfigNumBytes ) begin
            for( i=0; i < ((staticConfigNumBytes-1)/4)+1; i++ )
                m_static_config.m_data_array[i] = 0;
        end
        m_sideband_config = new( sidebandConfigNumBytes );
        if( sidebandConfigNumBytes ) begin
            for( i=0; i < ((sidebandConfigNumBytes-1)/4)+1; i++ )
                m_sideband_config.m_data_array[i] = 0;
        end
    endfunction

    //---------------------------------------------------------
    // Accessors
    //
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
    //---------------------------------------------------------

    function void set_static_config(
            int unsigned value, int unsigned i, int unsigned w );
        m_static_config.put_partsel_bit( i, w, value );
    endfunction

    function int unsigned get_static_config( int unsigned i, int unsigned w );
        return m_static_config.get_partsel_bit( i, w );
    endfunction

    function void set_sideband_config(
            int unsigned value, int unsigned i, int unsigned w );
        m_sideband_config.put_partsel_bit( i, w, value );
    endfunction

    function int unsigned get_sideband_config( int unsigned i, int unsigned w );
        return m_sideband_config.get_partsel_bit( i, w );
    endfunction

    function int unsigned get_static_config_num_bytes();
        return m_static_config.m_length_in_bytes;
    endfunction

    function int unsigned get_sideband_config_num_bytes();
        return m_sideband_config.m_length_in_bytes;
    endfunction

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

    function bit is_dirty(); return m_is_static_config_dirty; endfunction
    function void clear_is_dirty(); m_is_static_config_dirty = 0; endfunction

    //---------------------------------------------------------
    // ::do_copy()                      
    //
    // This is an implementation of the ::do_copy() virtual function
    // from base class uvm_object.
    //
    // It is the "workhorse" function to copy between
    // two config objects. Furthermore, the ::do_copy() function will
    // also automatically set the 'dirty' bit if the update causes a value
    // change in any of the config items. (See comments above for ::is_dirty()).
    //---------------------------------------------------------

    virtual function void do_copy( uvm_object rhs );

        uvmc_xl_config_base rhsc;

        if( $cast(rhsc, rhs ) ) begin

            int unsigned i, numBytes = get_static_config_num_bytes();

            if( numBytes > rhsc.get_static_config_num_bytes() )
                numBytes = rhsc.get_static_config_num_bytes();

            if( numBytes > 0 ) begin
                int unsigned value, rhsValue;

                for( i=0; i < numBytes; i++ ) begin

                    value = m_static_config.get_partsel_bit( i*8, 8 );
                    rhsValue = rhsc.m_static_config.get_partsel_bit( i*8, 8 );

                    if( value != rhsValue ) begin
                        m_is_static_config_dirty = 1;
                        m_static_config.put_partsel_bit( i*8, 8, rhsValue );
                    end
                end
            end

            numBytes = get_sideband_config_num_bytes();
            if( numBytes > rhsc.get_sideband_config_num_bytes() )
                numBytes = rhsc.get_sideband_config_num_bytes();

            if( numBytes > 0 ) begin
                int unsigned numWords = ((numBytes-1)/4) + 1;

                for( i=0; i < numWords; i++ )
                    m_sideband_config.m_data_array[i]
                        = rhsc.m_sideband_config.m_data_array[i];
            end
        end
    endfunction
endclass // }

//______________________                                      ________________
// class uvmc_xl_config \____________________________________/ johnS 10-3-2011
//
// See comments in class uvmc_xl_config ../sc/uvmc_xl_config.h, the SystemC
// counterpart for this class, for the detailed description.
//----------------------------------------------------------------------------

class uvmc_xl_config #(
        shortint unsigned STATIC_CONFIG_NUM_BYTES = 1,
        shortint unsigned SIDEBAND_CONFIG_NUM_BYTES = 0 )
            extends uvmc_xl_config_base; // {
    `uvm_object_param_utils( uvmc_xl_config
        #(STATIC_CONFIG_NUM_BYTES, SIDEBAND_CONFIG_NUM_BYTES) )

  //private:
    local uvm_tlm_generic_payload m_query_trans, m_update_trans;

  //public:
    //---------------------------------------------------------
    // Constructor
    //---------------------------------------------------------

    function new( string name="uvmc_xl_config" );
        super.new( name );

        setup( STATIC_CONFIG_NUM_BYTES, SIDEBAND_CONFIG_NUM_BYTES );

        m_query_trans = new();
        m_query_trans.set_read(); // is_read=1 to indicate static config query.
        void'(m_query_trans.set_extension( this ));
        m_query_trans.set_address( 0 );     // Unused for config update/query.
        m_query_trans.set_data_length( 0 ); // Specify as 0 for config
                                            // update/query.

        m_update_trans = new();
        m_update_trans.set_write(); // is_write=1 to indicate static config
                                    // update.
        void'(m_update_trans.set_extension( this ));
        m_update_trans.set_address( 0 );     // Unused for config update/query.
        m_update_trans.set_data_length( 0 ); // Specify as 0 for config
                                             // update/query.
    endfunction

    //---------------------------------------------------------
    // Accessors

    function uvm_tlm_generic_payload query_trans();
        return m_query_trans; endfunction
    function uvm_tlm_generic_payload update_trans();
        return m_update_trans; endfunction

endclass // }

`endif // _uvmc_xl_config_svh_
