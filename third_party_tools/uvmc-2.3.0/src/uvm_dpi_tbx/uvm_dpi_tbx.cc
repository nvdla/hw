static const char* svnid = "@(#) $Id: uvm_dpi_tbx.cc 1234 2014-07-15 04:56:14Z jstickle $";
static void* gccnowarn = &gccnowarn + (long)&svnid;

   //_______________________
  // Mentor Graphics, Corp. \_________________________________________________
 //                                                                         //
//   (C) Copyright, Mentor Graphics, Corp. 2003-2014                        //
//   Copyright 2007-2011 Cadence Design Systems, Inc.                       //
//   Copyright 2010-2011 Synopsys, Inc.                                     //
//   All Rights Reserved Worldwide                                          //
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

#include <malloc.h>
#include <string.h>
#include <stdio.h>
#include "vpi_user.h"
#include "svdpi.h"

//----------------------------------------------------------------------------
// These definitions of function prototypes from the TBX vendor proprietary
// tbx_perform_*() API (for register access) were lifted verbatim from
// tbxChannel.hxx. The reason that tbxChannel.hxx itself is not included
// directly is because it uses a non-standard definition of svdpi.h which
// which is inconsistent with Questa's compliant standard version of svdpi.h.
//----------------------------------------------------------------------------

void tbx_perform_force_impl(
    const char* file, int line,
    const char* signal_name, svBitVecVal* signal_value );
#define tbx_perform_force(signal_name,signal_value) \
    tbx_perform_force_impl(__FILE__,__LINE__,signal_name,signal_value) 

void tbx_perform_set_impl(
    const char* file, int line,
    const char* signal_name, svBitVecVal* signal_value);
#define tbx_perform_set(signal_name,signal_value) \
    tbx_perform_set_impl(__FILE__,__LINE__,signal_name,signal_value) 

void tbx_perform_release_impl(
    const char* file, int line,
    const char* signal_name);
#define tbx_perform_release(signal_name) \
    tbx_perform_release_impl(__FILE__,__LINE__,signal_name) 

void tbx_perform_get_impl(
    const char* file, int line,
    const char* signal_name, svBitVecVal* &signal_value, int &size);
#define tbx_perform_get(signal_name,signal_value,size) \
    tbx_perform_get_impl(__FILE__,__LINE__,signal_name,signal_value,size) 

//_____________                                              ________________
// uvm_hdl_tbx \____________________________________________/ johnS 1-10-2014
//
// The uvm_hdl_*() calls below form the core C API that provides register
// access for the SV-UVM package as well as for the SCEMI standard.
//
// The current UVM standard implements these functions using a reference
// implementation underneath based on the standard VPI API. Therefore, by
// making the SCEMI standard adopt this API verbatim, current simulators
// that provide the uvm_dpi.cc layer will automatically be SCEMI compliant.
//
// Moreover, for the SCEMI version, vendors can substitute other implementations
// underneath the 'uvm_hdl_*' calls as an alternative to the VPI implementation
// that is there now while keeping the API function definitions intact and
// allow existing applications to use them with no changes.
//
// The particular implementation below is the one for Mentor's TBX product.
//---------------------------------------------------------------------------

//---------------------------------------------------------
// copy4StateTo2State()                     johnS 1-10-2014
// copy2StateTo4State()
//
// These are local helper functions that copy between
// svBitVecVal and svLogicVecVal arrays. They are needed
// because the standard UVM uvm_dpi layer uses svLogicVecVal
// (which is the same as VPI s_vpi_vecval) whereas TBX's
// 'tbx_perform_*()' API uses svBitVecVal.
//---------------------------------------------------------

static void copy4StateTo2State(
    const char *path, unsigned width,
    const svLogicVecVal *from, svBitVecVal *to )
{
    unsigned i, numElems = SV_PACKED_DATA_NELEMS( width );

    for( i=0; i<numElems; i++ ) to[i] = from[i].aval;
}

static void copy2StateTo4State(
    const char *path, unsigned width,
    const svBitVecVal *from, svLogicVecVal *to )
{
    unsigned i, numElems = SV_PACKED_DATA_NELEMS( width );

    for( i=0; i<numElems; i++ ) {
        to[i].bval = 0;
        to[i].aval = from[i];
    }
}

extern "C" {

//---------------------------------------------------------
// UVM/SCEMI register access API calls      johnS 1-10-2014
//
// uvm_hdl_check_path()       - Check if signal denoted by path is present
// uvm_hdl_read()             - Get value of signal denoted by given path
// uvm_hdl_deposit()          - Set value of signal denoted by given path
// uvm_hdl_force()            - Force value of signal denoted by given path
// uvm_hdl_release()          - Release signal denoted by given path
// uvm_hdl_release_and_read() - Release signal denoted by given path
//
// See comments at the top of this file describing how these calls form the
// core C API that provides register access for the SV-UVM package as well
// as for the SCEMI standard.
//---------------------------------------------------------

/*
 * Given a path, look the path name up using the PLI,
 * but don't set or get. Just check.
 *
 * Return 0 if NOT found.
 * Return 1 if found.
 *
 * This function is provided as required by the uvm_dpi layer
 * for UVM.
 */
int uvm_hdl_check_path( const char *path ) {

    svBitVecVal *valueVec;
    int width;

    // TODO: TBX needs to have this function return a "found/not found"
    // indication rather than aborting the simulation if the path is
    // invalid. Or it needs to provide another function that can check
    // validity of a signal that can be used here instead.
    tbx_perform_get( path, valueVec, width );

    delete [] valueVec;

    return 1;
}

/*
 * Given a path, look the path name up using the tbx_perform_*() API
 * and read its value.
 */
int uvm_hdl_read( const char *path, p_vpi_vecval value ) {

    svBitVecVal *valueVec;
    int width;

    tbx_perform_get( path, valueVec, width );

    copy2StateTo4State( path, (unsigned)width, valueVec, value );

    delete [] valueVec;

    return 1;
}

/*
 * Given a path, look the path name up using the tbx_perform_*() API
 * and set its value.
 */
int uvm_hdl_deposit( const char *path, p_vpi_vecval value ) {

    svBitVecVal *valueVec;
    int width;

    tbx_perform_get( path, valueVec, width );

    copy4StateTo2State( path, width, value, valueVec );

    tbx_perform_set( path, valueVec );

    delete [] valueVec;

    return 1;
}

/*
 * Given a path, look the path name up using the tbx_perform_*() API
 * and force it to 'value'.
 */
int uvm_hdl_force( const char *path, p_vpi_vecval value ) {

    svBitVecVal *valueVec;
    int width;

    tbx_perform_get( path, valueVec, width );

    copy4StateTo2State( path, width, value, valueVec );

    tbx_perform_force( path, valueVec );

    delete [] valueVec;

    return 1;
}

/*
 * Given a path, look the path name up using the tbx_perform_*() API
 * and release it after reading its value.
 */
int uvm_hdl_release_and_read(const char *path, p_vpi_vecval value) {
    if( uvm_hdl_read( path, value ) ) {
        tbx_perform_release( path );
        return 1;
    }
    else return 0;
}

/*
 * Given a path, look the path name up using the tbx_perform_*() API
 * and release it.
 */
int uvm_hdl_release( const char *path ) {
    tbx_perform_release( path );
    return 1;
}

};
