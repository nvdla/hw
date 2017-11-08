// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_conv_base.h

#ifndef _NV_NVDLA_CONV_BASE_H_
#define _NV_NVDLA_CONV_BASE_H_

#define SC_INCLUDE_DYNAMIC_PROCESSES
#include "NV_MSDEC_csb2xx_adr32_iface.h"
#include "NV_MSDEC_xx2csb_erpt_iface.h"

#include "nvdla_data_only_24B_iface.h"
#include "nvdla_fc_sc_credit_iface.h"
#include "nvdla_ram_rd_addr_iface.h"
#include "nvdla_ram_rd_data_128B_iface.h"
#include "scsim_common.h"
#include <systemc.h>
#include <tlm.h>
#include <tlm_utils/multi_passthrough_initiator_socket.h>
#include <tlm_utils/multi_passthrough_target_socket.h>

SCSIM_NAMESPACE_START(cmod)

// Base SystemC class for module NV_NVDLA_conv
class NV_NVDLA_conv_base : public sc_module
{
    public:

    // Constructor
    NV_NVDLA_conv_base(const sc_module_name name);

    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_adr32_t): csb_req
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_conv_base, 32, tlm::tlm_base_protocol_types> csb_req;
    virtual void csb_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void csb_req_b_transport(int ID, NV_MSDEC_csb2xx_adr32_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_data_only_24B_t): data_out
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_conv_base, 32, tlm::tlm_base_protocol_types> data_out;
    virtual void data_out_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void data_out_b_transport(int ID, nvdla_data_only_24B_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_fc_sc_credit_t): act_data_debit
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_conv_base, 32, tlm::tlm_base_protocol_types> act_data_debit;
    virtual void act_data_debit_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void act_data_debit_b_transport(int ID, nvdla_fc_sc_credit_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_fc_sc_credit_t): weight_debit
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_conv_base, 32, tlm::tlm_base_protocol_types> weight_debit;
    virtual void weight_debit_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void weight_debit_b_transport(int ID, nvdla_fc_sc_credit_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_fc_sc_credit_t): weight_mask_debit
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_conv_base, 32, tlm::tlm_base_protocol_types> weight_mask_debit;
    virtual void weight_mask_debit_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void weight_mask_debit_b_transport(int ID, nvdla_fc_sc_credit_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_ram_rd_data_128B_t): act_data
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_conv_base, 32, tlm::tlm_base_protocol_types> act_data;
    virtual void act_data_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void act_data_b_transport(int ID, nvdla_ram_rd_data_128B_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_ram_rd_data_128B_t): weight_data
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_conv_base, 32, tlm::tlm_base_protocol_types> weight_data;
    virtual void weight_data_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void weight_data_b_transport(int ID, nvdla_ram_rd_data_128B_t* payload, sc_time& delay) = 0;

    // Target Socket (unrecognized protocol: nvdla_ram_rd_data_128B_t): weight_mask_data
    tlm_utils::multi_passthrough_target_socket<NV_NVDLA_conv_base, 32, tlm::tlm_base_protocol_types> weight_mask_data;
    virtual void weight_mask_data_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
    virtual void weight_mask_data_b_transport(int ID, nvdla_ram_rd_data_128B_t* payload, sc_time& delay) = 0;

    // Initiator Socket (unrecognized protocol: NV_MSDEC_xx2csb_erpt_t): csb_rrsp
    tlm::tlm_generic_payload csb_rrsp_bp;
    NV_MSDEC_xx2csb_erpt_t csb_rrsp_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_conv_base, 32, tlm::tlm_base_protocol_types> csb_rrsp;
    virtual void csb_rrsp_b_transport(NV_MSDEC_xx2csb_erpt_t* payload, sc_time& delay);

    // Port has no flow: csb_wrsp
    sc_out<bool> csb_wrsp [34];

    // Initiator Socket (unrecognized protocol: nvdla_fc_sc_credit_t): act_data_credit
    tlm::tlm_generic_payload act_data_credit_bp;
    nvdla_fc_sc_credit_t act_data_credit_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_conv_base, 32, tlm::tlm_base_protocol_types> act_data_credit;
    virtual void act_data_credit_b_transport(nvdla_fc_sc_credit_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_fc_sc_credit_t): weight_credit
    tlm::tlm_generic_payload weight_credit_bp;
    nvdla_fc_sc_credit_t weight_credit_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_conv_base, 32, tlm::tlm_base_protocol_types> weight_credit;
    virtual void weight_credit_b_transport(nvdla_fc_sc_credit_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_fc_sc_credit_t): weight_mask_credit
    tlm::tlm_generic_payload weight_mask_credit_bp;
    nvdla_fc_sc_credit_t weight_mask_credit_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_conv_base, 32, tlm::tlm_base_protocol_types> weight_mask_credit;
    virtual void weight_mask_credit_b_transport(nvdla_fc_sc_credit_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_ram_rd_addr_t): act_addr
    tlm::tlm_generic_payload act_addr_bp;
    nvdla_ram_rd_addr_t act_addr_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_conv_base, 32, tlm::tlm_base_protocol_types> act_addr;
    virtual void act_addr_b_transport(nvdla_ram_rd_addr_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_ram_rd_addr_t): weight_addr
    tlm::tlm_generic_payload weight_addr_bp;
    nvdla_ram_rd_addr_t weight_addr_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_conv_base, 32, tlm::tlm_base_protocol_types> weight_addr;
    virtual void weight_addr_b_transport(nvdla_ram_rd_addr_t* payload, sc_time& delay);

    // Initiator Socket (unrecognized protocol: nvdla_ram_rd_addr_t): weight_mask_addr
    tlm::tlm_generic_payload weight_mask_addr_bp;
    nvdla_ram_rd_addr_t weight_mask_addr_payload;
    tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_conv_base, 32, tlm::tlm_base_protocol_types> weight_mask_addr;
    virtual void weight_mask_addr_b_transport(nvdla_ram_rd_addr_t* payload, sc_time& delay);

    // Destructor
    virtual ~NV_NVDLA_conv_base() {}

};

// Constructor for base SystemC class for module NV_NVDLA_conv
inline NV_NVDLA_conv_base::NV_NVDLA_conv_base(const sc_module_name name)
    : sc_module(name),
    csb_req("csb_req"),
    data_out("data_out"),
    act_data_debit("act_data_debit"),
    weight_debit("weight_debit"),
    weight_mask_debit("weight_mask_debit"),
    act_data("act_data"),
    weight_data("weight_data"),
    weight_mask_data("weight_mask_data"),
    csb_rrsp_bp(),
    csb_rrsp("csb_rrsp"),
    act_data_credit_bp(),
    act_data_credit("act_data_credit"),
    weight_credit_bp(),
    weight_credit("weight_credit"),
    weight_mask_credit_bp(),
    weight_mask_credit("weight_mask_credit"),
    act_addr_bp(),
    act_addr("act_addr"),
    weight_addr_bp(),
    weight_addr("weight_addr"),
    weight_mask_addr_bp(),
    weight_mask_addr("weight_mask_addr")
{
    // Target Socket (unrecognized protocol: NV_MSDEC_csb2xx_adr32_t): csb_req
    this->csb_req.register_b_transport(this, &NV_NVDLA_conv_base::csb_req_b_transport);

    // Target Socket (unrecognized protocol: nvdla_data_only_24B_t): data_out
    this->data_out.register_b_transport(this, &NV_NVDLA_conv_base::data_out_b_transport);

    // Target Socket (unrecognized protocol: nvdla_fc_sc_credit_t): act_data_debit
    this->act_data_debit.register_b_transport(this, &NV_NVDLA_conv_base::act_data_debit_b_transport);

    // Target Socket (unrecognized protocol: nvdla_fc_sc_credit_t): weight_debit
    this->weight_debit.register_b_transport(this, &NV_NVDLA_conv_base::weight_debit_b_transport);

    // Target Socket (unrecognized protocol: nvdla_fc_sc_credit_t): weight_mask_debit
    this->weight_mask_debit.register_b_transport(this, &NV_NVDLA_conv_base::weight_mask_debit_b_transport);

    // Target Socket (unrecognized protocol: nvdla_ram_rd_data_128B_t): act_data
    this->act_data.register_b_transport(this, &NV_NVDLA_conv_base::act_data_b_transport);

    // Target Socket (unrecognized protocol: nvdla_ram_rd_data_128B_t): weight_data
    this->weight_data.register_b_transport(this, &NV_NVDLA_conv_base::weight_data_b_transport);

    // Target Socket (unrecognized protocol: nvdla_ram_rd_data_128B_t): weight_mask_data
    this->weight_mask_data.register_b_transport(this, &NV_NVDLA_conv_base::weight_mask_data_b_transport);

}

inline void
NV_NVDLA_conv_base::csb_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    NV_MSDEC_csb2xx_adr32_t* payload = (NV_MSDEC_csb2xx_adr32_t*) bp.get_data_ptr();
    csb_req_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_conv_base::data_out_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_data_only_24B_t* payload = (nvdla_data_only_24B_t*) bp.get_data_ptr();
    data_out_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_conv_base::act_data_debit_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_fc_sc_credit_t* payload = (nvdla_fc_sc_credit_t*) bp.get_data_ptr();
    act_data_debit_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_conv_base::weight_debit_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_fc_sc_credit_t* payload = (nvdla_fc_sc_credit_t*) bp.get_data_ptr();
    weight_debit_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_conv_base::weight_mask_debit_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_fc_sc_credit_t* payload = (nvdla_fc_sc_credit_t*) bp.get_data_ptr();
    weight_mask_debit_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_conv_base::act_data_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_ram_rd_data_128B_t* payload = (nvdla_ram_rd_data_128B_t*) bp.get_data_ptr();
    act_data_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_conv_base::weight_data_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_ram_rd_data_128B_t* payload = (nvdla_ram_rd_data_128B_t*) bp.get_data_ptr();
    weight_data_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_conv_base::weight_mask_data_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay)
{
    nvdla_ram_rd_data_128B_t* payload = (nvdla_ram_rd_data_128B_t*) bp.get_data_ptr();
    weight_mask_data_b_transport(ID, payload, delay);
}

inline void
NV_NVDLA_conv_base::csb_rrsp_b_transport(NV_MSDEC_xx2csb_erpt_t* payload, sc_time& delay)
{
    csb_rrsp_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < csb_rrsp.size(); socket_id++) {
        csb_rrsp[socket_id]->b_transport(csb_rrsp_bp, delay);
    }
}

inline void
NV_NVDLA_conv_base::act_data_credit_b_transport(nvdla_fc_sc_credit_t* payload, sc_time& delay)
{
    act_data_credit_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < act_data_credit.size(); socket_id++) {
        act_data_credit[socket_id]->b_transport(act_data_credit_bp, delay);
    }
}

inline void
NV_NVDLA_conv_base::weight_credit_b_transport(nvdla_fc_sc_credit_t* payload, sc_time& delay)
{
    weight_credit_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < weight_credit.size(); socket_id++) {
        weight_credit[socket_id]->b_transport(weight_credit_bp, delay);
    }
}

inline void
NV_NVDLA_conv_base::weight_mask_credit_b_transport(nvdla_fc_sc_credit_t* payload, sc_time& delay)
{
    weight_mask_credit_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < weight_mask_credit.size(); socket_id++) {
        weight_mask_credit[socket_id]->b_transport(weight_mask_credit_bp, delay);
    }
}

inline void
NV_NVDLA_conv_base::act_addr_b_transport(nvdla_ram_rd_addr_t* payload, sc_time& delay)
{
    act_addr_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < act_addr.size(); socket_id++) {
        act_addr[socket_id]->b_transport(act_addr_bp, delay);
    }
}

inline void
NV_NVDLA_conv_base::weight_addr_b_transport(nvdla_ram_rd_addr_t* payload, sc_time& delay)
{
    weight_addr_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < weight_addr.size(); socket_id++) {
        weight_addr[socket_id]->b_transport(weight_addr_bp, delay);
    }
}

inline void
NV_NVDLA_conv_base::weight_mask_addr_b_transport(nvdla_ram_rd_addr_t* payload, sc_time& delay)
{
    weight_mask_addr_bp.set_data_ptr((unsigned char*) payload);
    for (uint8_t socket_id=0; socket_id < weight_mask_addr.size(); socket_id++) {
        weight_mask_addr[socket_id]->b_transport(weight_mask_addr_bp, delay);
    }
}

SCSIM_NAMESPACE_END()

#endif
