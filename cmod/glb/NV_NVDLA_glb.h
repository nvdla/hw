// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_glb.h

#ifndef _NV_NVDLA_GLB_H_
#define _NV_NVDLA_GLB_H_
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include <systemc.h>
#include <tlm.h>
#include "tlm_utils/multi_passthrough_initiator_socket.h"
#include "tlm_utils/multi_passthrough_target_socket.h" 

#include "scsim_common.h"
#include "nvdla_dma_wr_req_iface.h"
#include <systemc.h>
#include "nvdla_xx2csb_resp_iface.h"
#include "NV_NVDLA_glb_base.h"
#include "glb_reg_model.h"
#include "gec_reg_model.h"
#include "NvdlaDataFormatConvertor.h"

// class NvdlaDataFormatConvertor;
SCSIM_NAMESPACE_START(clib)
// clib class forward declaration
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)

class NV_NVDLA_glb:
    public NV_NVDLA_glb_base,   // ports
    private glb_reg_model,      // glb register accessing
    private gec_reg_model       // gec register accessing
{
    public:
        SC_HAS_PROCESS(NV_NVDLA_glb);
        NV_NVDLA_glb( sc_module_name module_name );
        ~NV_NVDLA_glb();
        // CSB request transport implementation shall in generated code
        void csb2glb_req_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        void csb2gec_req_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);

    private:
        // Variables
        bool is_there_ongoing_csb2glb_response_;
        bool is_there_ongoing_csb2gec_response_;

        // Delay
        sc_core::sc_time csb_delay_;
        sc_core::sc_time b_transport_delay_;

        // Events
        // GLB config evaluation is done
        sc_event event_glb_config_evaluation_done;

        // Function declaration 
        void UpdateBdmaIntrStatus_0();
        void UpdateBdmaIntrStatus_1();
        void UpdatePdpIntrStatus_0();
        void UpdatePdpIntrStatus_1();
        void UpdateSdpIntrStatus_0();
        void UpdateSdpIntrStatus_1();
        void UpdateCdpIntrStatus_0();
        void UpdateCdpIntrStatus_1();
        void UpdateRbkIntrStatus_0();
        void UpdateRbkIntrStatus_1();
        void UpdateCaccIntrStatus_0();
        void UpdateCaccIntrStatus_1();
        void UpdateCdmaDatIntrStatus_0();
        void UpdateCdmaDatIntrStatus_1();
        void UpdateCdmaWtIntrStatus_0();
        void UpdateCdmaWtIntrStatus_1();

        void Update_nvdla_intr_bdma_0();
        void Update_nvdla_intr_bdma_1();
        void Update_nvdla_intr_pdp_0();
        void Update_nvdla_intr_pdp_1();
        void Update_nvdla_intr_sdp_0();
        void Update_nvdla_intr_sdp_1();
        void Update_nvdla_intr_cdp_0();
        void Update_nvdla_intr_cdp_1();
        void Update_nvdla_intr_rbk_0();
        void Update_nvdla_intr_rbk_1();
        void Update_nvdla_intr_cacc_0();
        void Update_nvdla_intr_cacc_1();
        void Update_nvdla_intr_cdma_dat_0();
        void Update_nvdla_intr_cdma_dat_1();
        void Update_nvdla_intr_cdma_wt_0();
        void Update_nvdla_intr_cdma_wt_1();
        void Update_nvdla_intr_w();

        // ## Reset 
        void Reset();
        void GlbSendCsbResponse(uint8_t type, uint32_t data, uint8_t error_id);
        void GecSendCsbResponse(uint8_t type, uint32_t data, uint8_t error_id);
};

SCSIM_NAMESPACE_END()

extern "C" scsim::cmod::NV_NVDLA_glb * NV_NVDLA_glbCon(sc_module_name module_name);

#endif

