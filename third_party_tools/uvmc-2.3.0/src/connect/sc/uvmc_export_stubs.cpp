//
//------------------------------------------------------------//
//   Copyright 2009-2012 Mentor Graphics Corporation          //
//   All Rights Reserved Worldwid                             //
//                                                            //
//   Licensed under the Apache License, Version 2.0 (the      //
//   "License"); you may not use this file except in          //
//   compliance with the License.  You may obtain a copy of   //
//   the License at                                           //
//                                                            //
//       http://www.apache.org/licenses/LICENSE-2.0           //
//                                                            //
//   Unless required by applicable law or agreed to in        //
//   writing, software distributed under the License is       //
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR   //
//   CONDITIONS OF ANY KIND, either express or implied.  See  //
//   the License for the specific language governing          //
//   permissions and limitations under the License.           //
//------------------------------------------------------------//

#include "uvmc_commands.h"
#include "vpi_user.h"

//----------------------------------------------------------------------------
// UVMC export DPI functions "weak symbol linkeage" stubs.
//
// The following functions are normally provided as export "DPI-C" functions
// from the UVM-Connect SV side. However, of UVM-Connect SV is not being
// used (as may be the case for remote client or XRTL clients TLM endpoints
// at the opposite end of a SystemC UVM-Connect TLM endpoint) these functions
// must be defined to avoid unresolved external errors.
//
// By defining them with weak linkeage, they will be overriden by any
// symbols provided by strong linkeage in the case where UVM-Connect SV
// infrastructure actually is deployed. But in case not, these functions
// default "fallback stubs" that keep the linker happy.
//
// If any code attempts to call these functions, a graceful error message
// will result.
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
// UVMC export DPI functions from sv/uvmc_commands.sv
//----------------------------------------------------------------------------

extern "C" {

static const char *errorMessageForStubFunctions =
    "UVMC-ERROR: Attempted call to non-existent %s "
    "function on HVL side.  Be sure you have included all HVL-side "
    "SV modules that have export DPI-C functions in addition to "
    "HDL-side ones when running vsim -dpiexportobj option.\n";

// Internal API (SV DPI Export Functions)

void UVMC_print_topology(const char* context, int depth)
    __attribute__ ((weak));
void UVMC_print_topology(const char* context, int depth)
{   printf( errorMessageForStubFunctions, "UVMC_print_topology()" ); }

bool UVMC_report_enabled    (const char* context,
                             int verbosity,
                             int severity,
                             const char* id)
    __attribute__ ((weak));
bool UVMC_report_enabled    (const char* context,
                             int verbosity,
                             int severity,
                             const char* id)
{   printf( errorMessageForStubFunctions, "UVMC_report_enabled()" ); return false; }

void UVMC_set_report_verbosity(int level,
                             const char* context,
                             bool  recurse)
    __attribute__ ((weak));
void UVMC_set_report_verbosity(int level,
                             const char* context,
                             bool  recurse)
{   printf( errorMessageForStubFunctions, "UVMC_set_report_verbosity()" ); }

void UVMC_report            (int severity,
                             const char* id,
                             const char* message,
                             int verbosity,
                             const char* context,
                             const char* filename,
                             int line)
    __attribute__ ((weak));
void UVMC_report            (int severity,
                             const char* id,
                             const char* message,
                             int verbosity,
                             const char* context,
                             const char* filename,
                             int line)
{   printf( errorMessageForStubFunctions, "UVMC_report()" ); }
// up to 64 bits
void UVMC_set_config_int    (const char* context, const char* inst_name,
                             const char* field_name, uint64 value)
    __attribute__ ((weak));
void UVMC_set_config_int    (const char* context, const char* inst_name,
                             const char* field_name, uint64 value)
{   printf( errorMessageForStubFunctions, "UVMC_set_config_int()" ); }
void UVMC_set_config_object (const char* type_name,
                             const char* context, const char* inst_name,
                             const char* field_name, const bits_t *value)
    __attribute__ ((weak));
void UVMC_set_config_object (const char* type_name,
                             const char* context, const char* inst_name,
                             const char* field_name, const bits_t *value)
{   printf( errorMessageForStubFunctions, "UVMC_set_config_object()" ); }
void UVMC_set_config_string (const char* context, const char* inst_name,
                             const char* field_name, const char* value)
    __attribute__ ((weak));
void UVMC_set_config_string (const char* context, const char* inst_name,
                             const char* field_name, const char* value)
{   printf( errorMessageForStubFunctions, "UVMC_set_config_string()" ); }
bool UVMC_get_config_int    (const char* context, const char* inst_name,
                             const char* field_name, uint64 *value)
    __attribute__ ((weak));
bool UVMC_get_config_int    (const char* context, const char* inst_name,
                             const char* field_name, uint64 *value)
{   printf( errorMessageForStubFunctions, "UVMC_get_config_int()" ); return false; }
bool UVMC_get_config_object (const char* type_name,
                             const char* context, const char* inst_name,
                             const char* field_name, bits_t* bits)
    __attribute__ ((weak));
bool UVMC_get_config_object (const char* type_name,
                             const char* context, const char* inst_name,
                             const char* field_name, bits_t* bits)
{   printf( errorMessageForStubFunctions, "UVMC_get_config_object()" ); return false; }
bool UVMC_get_config_string (const char* context, const char* inst_name,
                             const char* field_name, const char** value)
    __attribute__ ((weak));
bool UVMC_get_config_string (const char* context, const char* inst_name,
                             const char* field_name, const char** value)
{   printf( errorMessageForStubFunctions, "UVMC_get_config_string()" ); return false; }


void UVMC_raise_objection   (const char* name, const char* context,
                             const char* description, unsigned int count)
    __attribute__ ((weak));
void UVMC_raise_objection   (const char* name, const char* context,
                             const char* description, unsigned int count)
{   printf( errorMessageForStubFunctions, "UVMC_raise_objection()" ); }

void UVMC_drop_objection    (const char* name, const char* context,
                             const char* description, unsigned int count)
    __attribute__ ((weak));
void UVMC_drop_objection    (const char* name, const char* context,
                             const char* description, unsigned int count)
{   printf( errorMessageForStubFunctions, "UVMC_drop_objection()" ); }

void UVMC_print_factory (int all_types)
    __attribute__ ((weak));
void UVMC_print_factory (int all_types)
{   printf( errorMessageForStubFunctions, "UVMC_print_factory()" ); }

void UVMC_set_factory_inst_override
                            (const char* original_type_name,
                             const char* override_type_name,
                             const char* full_inst_path)
    __attribute__ ((weak));
void UVMC_set_factory_inst_override
                            (const char* original_type_name,
                             const char* override_type_name,
                             const char* full_inst_path)
{   printf( errorMessageForStubFunctions, "UVMC_set_factory_inst_override()" ); }

void UVMC_set_factory_type_override (const char* original_type_name,
                             const char* override_type_name,
                             bool replace)
    __attribute__ ((weak));
void UVMC_set_factory_type_override (const char* original_type_name,
                             const char* override_type_name,
                             bool replace)
{   printf( errorMessageForStubFunctions, "UVMC_set_factory_type_override()" ); }

void UVMC_debug_factory_create (const char* requested_type,
                             const char* context)
    __attribute__ ((weak));
void UVMC_debug_factory_create (const char* requested_type,
                             const char* context)
{   printf( errorMessageForStubFunctions, "UVMC_debug_factory_create()" ); }

void UVMC_find_factory_override (const char* requested_type,
                             const char* context,
                             const char** override_type_name)
    __attribute__ ((weak));
void UVMC_find_factory_override (const char* requested_type,
                             const char* context,
                             const char** override_type_name)
{   printf( errorMessageForStubFunctions, "UVMC_find_factory_override()" ); }

int   UVMC_wait_for_phase_request(const char *phase, int state, int op)
    __attribute__ ((weak));
int   UVMC_wait_for_phase_request(const char *phase, int state, int op)
{   printf( errorMessageForStubFunctions, "UVMC_wait_for_phase_request()" ); return(0); }

void UVMC_get_uvm_version (  unsigned int* major,
                             unsigned int* minor,
                             char** fix)
    __attribute__ ((weak));
void UVMC_get_uvm_version (  unsigned int* major,
                             unsigned int* minor,
                             char ** fix)
{   // Hard code it to 1.1b
    *major = 1;
    *minor = 1;
    *fix = const_cast<char *>( "b" );
}

bool  SV2C_phase_notification(int id)
    __attribute__ ((weak));
bool  SV2C_phase_notification(int id)
{   printf( errorMessageForStubFunctions, "SV2C_phase_notification()" );
    return false; }

//----------------------------------------------------------------------------
// UVMC export DPI functions from sv/uvmc_common.sv
//----------------------------------------------------------------------------

void  C2SV_blocking_req_done (int x_id)
    __attribute__ ((weak));
void  C2SV_blocking_req_done (int x_id)
{   printf( errorMessageForStubFunctions, "C2SV_blocking_req_done()" ); }

void  C2SV_blocking_rsp_done (int x_id,
                              const bits_t *bits,
                              uint64 delay)
    __attribute__ ((weak));
void  C2SV_blocking_rsp_done (int x_id,
                              const bits_t *bits,
                              uint64 delay)
{   printf( errorMessageForStubFunctions, "C2SV_blocking_rsp_done()" ); }

//----------------------------------------------------------------------------
// UVMC export DPI functions from sv/uvmc_tlm1.sv, sv/uvmc_tlm2.sv
//----------------------------------------------------------------------------

void  C2SV_put      (int x_id, const bits_t *bits)
    __attribute__ ((weak));
void  C2SV_put      (int x_id, const bits_t *bits)
{   printf( errorMessageForStubFunctions, "C2SV_put()" ); }

bool  C2SV_try_put  (int x_id, const bits_t *bits)
    __attribute__ ((weak));
bool  C2SV_try_put  (int x_id, const bits_t *bits)
{   printf( errorMessageForStubFunctions, "C2SV_try_put()" ); return false; }

bool  C2SV_can_put  (int x_id)
    __attribute__ ((weak));
bool  C2SV_can_put  (int x_id)
{   printf( errorMessageForStubFunctions, "C2SV_can_put()" ); return false; }

void  C2SV_get      (int x_id)
    __attribute__ ((weak));
void  C2SV_get      (int x_id)
{   printf( errorMessageForStubFunctions, "C2SV_get()" ); }

bool  C2SV_try_get  (int x_id, bits_t *bits)
    __attribute__ ((weak));
bool  C2SV_try_get  (int x_id, bits_t *bits)
{   printf( errorMessageForStubFunctions, "C2SV_try_get()" ); return false; }

bool  C2SV_can_get  (int x_id)
    __attribute__ ((weak));
bool  C2SV_can_get  (int x_id)
{   printf( errorMessageForStubFunctions, "C2SV_can_get()" ); return false; }

void  C2SV_peek     (int x_id)
    __attribute__ ((weak));
void  C2SV_peek     (int x_id)
{   printf( errorMessageForStubFunctions, "C2SV_peek()" ); }

bool  C2SV_try_peek (int x_id, bits_t *bits)
    __attribute__ ((weak));
bool  C2SV_try_peek (int x_id, bits_t *bits)
{   printf( errorMessageForStubFunctions, "C2SV_try_peek()" ); return false; }

bool  C2SV_can_peek (int x_id)
    __attribute__ ((weak));
bool  C2SV_can_peek (int x_id)
{   printf( errorMessageForStubFunctions, "C2SV_can_peek()" ); return false; }

void  C2SV_write    (int x_id, const bits_t *bits)
    __attribute__ ((weak));
void  C2SV_write    (int x_id, const bits_t *bits)
{   printf( errorMessageForStubFunctions, "C2SV_write()" ); }

void  C2SV_transport    (int x_id, bits_t *bits)
    __attribute__ ((weak));
void  C2SV_transport    (int x_id, bits_t *bits)
{   printf( errorMessageForStubFunctions, "C2SV_transport()" ); }

bool  C2SV_try_transport(int x_id, bits_t *bits)
    __attribute__ ((weak));
bool  C2SV_try_transport(int x_id, bits_t *bits)
{   printf( errorMessageForStubFunctions, "C2SV_try_transport()" ); return false; }

int   C2SV_nb_transport_fw (int x_id,
                            bits_t *bits,
                            unsigned int *phase,
                            uint64 *delay)
    __attribute__ ((weak));
int   C2SV_nb_transport_fw (int x_id,
                            bits_t *bits,
                            unsigned int *phase,
                            uint64 *delay)
{   printf( errorMessageForStubFunctions, "C2SV_nb_transport_fw()" ); return 0; }

int   C2SV_nb_transport_bw (int x_id,
                            bits_t *bits,
                            unsigned int *phase,
                            uint64 *delay)
    __attribute__ ((weak));
int   C2SV_nb_transport_bw (int x_id,
                            bits_t *bits,
                            unsigned int *phase,
                            uint64 *delay)
{   printf( errorMessageForStubFunctions, "C2SV_nb_transport_bw()" ); return 0; }

void  C2SV_b_transport     (int x_id,
                            bits_t *bits,
                            uint64 delay)
    __attribute__ ((weak));
void  C2SV_b_transport     (int x_id,
                            bits_t *bits,
                            uint64 delay)
{   printf( errorMessageForStubFunctions, "C2SV_b_transport()" ); }

//----------------------------------------------------------------------------
// VPI library stub functions
//----------------------------------------------------------------------------


vpiHandle vpi_handle_by_name( PLI_BYTE8 *name, vpiHandle scope)
    __attribute__ ((weak));
vpiHandle vpi_handle_by_name( PLI_BYTE8 *name, vpiHandle scope)
{   printf( errorMessageForStubFunctions, "vpi_handle_by_name()" ); return NULL; }

void vpi_get_value( vpiHandle expr, p_vpi_value value_p)
    __attribute__ ((weak));
void vpi_get_value( vpiHandle expr, p_vpi_value value_p)
{   printf( errorMessageForStubFunctions, "vpi_get_value()" ); }

PLI_INT32 vpi_release_handle( vpiHandle object )
    __attribute__ ((weak));
PLI_INT32 vpi_release_handle( vpiHandle object )
{   printf( errorMessageForStubFunctions, "vpi_release_handle()" ); return 0; }

PLI_INT32 vpi_get_vlog_info( p_vpi_vlog_info vlog_info_p )
    __attribute__ ((weak));
PLI_INT32 vpi_get_vlog_info( p_vpi_vlog_info vlog_info_p )
{   printf( errorMessageForStubFunctions, "vpi_get_vlog_info()" ); return 0; }

PLI_INT32 vpi_printf( PLI_BYTE8 *format, ...)
    __attribute__ ((weak));
PLI_INT32 vpi_printf( PLI_BYTE8 *format, ...)
{   printf( errorMessageForStubFunctions, "vpi_printf()" ); return 0; }

vpiHandle vpi_put_value(
    vpiHandle object, p_vpi_value value_p, p_vpi_time time_p, PLI_INT32 flags)
    __attribute__ ((weak));
vpiHandle vpi_put_value(
    vpiHandle object, p_vpi_value value_p, p_vpi_time time_p, PLI_INT32 flags)
{   printf( errorMessageForStubFunctions, "vpi_put_value()" ); return NULL; }

} // extern "C"
