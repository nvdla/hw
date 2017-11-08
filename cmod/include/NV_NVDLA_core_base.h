// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_core_base.h

#ifndef _NV_NVDLA_CORE_BASE_H_
#define _NV_NVDLA_CORE_BASE_H_

#define SC_INCLUDE_DYNAMIC_PROCESSES
#include "NV_MSDEC_csb2xx_16m_secure_be_lvl_iface.h"
#include "NV_MSDEC_xx2csb_erpt_iface.h"

#include "scsim_common.h"
#include <systemc.h>
#include <tlm.h>
#include <tlm_utils/multi_passthrough_initiator_socket.h>
#include <tlm_utils/multi_passthrough_target_socket.h>

SCSIM_NAMESPACE_START(cmod)

// Base SystemC class for module NV_NVDLA_core
class NV_NVDLA_core_base : public sc_module
{
    public:

    // Constructor
    NV_NVDLA_core_base(const sc_module_name name);

    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): nvdla2csb
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_core_base, 32, tlm::tlm_base_protocol_types> nvdla2csb;
    // virtual void nvdla2csb_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    // virtual void nvdla2csb_b_transport(int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay) = 0;

    // Initiator Socket (unrecognized protocol: NV_MSDEC_xx2csb_erpt_t): csb2nvdla
    tlm::tlm_generic_payload csb2nvdla_bp;
    NV_MSDEC_xx2csb_erpt_t csb2nvdla_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_core_base, 32, tlm::tlm_base_protocol_types> csb2nvdla;
    virtual void csb2nvdla_b_transport(NV_MSDEC_xx2csb_erpt_t* payload, sc_time& delay);

    // Port has no flow: nvdla_fault_report_corrected
    // sc_out<bool> nvdla_fault_report_corrected;

    // Port has no flow: nvdla_fault_report_uncorrected
    // sc_out<bool> nvdla_fault_report_uncorrected;

    // Port has no flow: nvdla_intr
    sc_out<bool> nvdla_intr;

    // Destructor
    virtual ~NV_NVDLA_core_base() {}

};

// Constructor for base SystemC class for module NV_NVDLA_core
inline NV_NVDLA_core_base::NV_NVDLA_core_base(const sc_module_name name)
    : sc_module(name),
    nvdla2csb("nvdla2csb"),
    csb2nvdla_bp(),
    csb2nvdla("csb2nvdla"),
    nvdla_intr("nvdla_intr")
{
    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_16m_secure_be_lvl_t): nvdla2csb
    // this->nvdla2csb.register_b_transport(this, &NV_NVDLA_core_base::nvdla2csb_b_transport);

}

// inline void
// NV_NVDLA_core_base::nvdla2csb_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
// {
//     NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload = (NV_MSDEC_csb2xx_16m_secure_be_lvl_t*) bp.get_data_ptr();
//     nvdla2csb_b_transport(ID, payload, delay);
// }
// 
inline void
NV_NVDLA_core_base::csb2nvdla_b_transport(NV_MSDEC_xx2csb_erpt_t* payload, sc_time& delay)
{
    csb2nvdla_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < csb2nvdla.size(); socket_id++) {
        csb2nvdla[socket_id]->b_transport(csb2nvdla_bp, delay);
    }
}

SCSIM_NAMESPACE_END()

#endif
