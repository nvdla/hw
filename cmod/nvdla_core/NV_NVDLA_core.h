// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_core.h

#ifndef _NV_NVDLA_CORE_H_
#define _NV_NVDLA_CORE_H_
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include <systemc.h>
#include <tlm.h>
#include "tlm_utils/multi_passthrough_initiator_socket.h"
#include "tlm_utils/multi_passthrough_target_socket.h" 

#include "scsim_common.h"


#include "NV_NVDLA_core_base.h"
// # Interface modules
#include "NV_NVDLA_csb_master.h"
#include "NV_NVDLA_bdma.h"
#include "NV_NVDLA_rbk.h"
#include "NV_NVDLA_mcif.h"
#include "NV_NVDLA_cvif.h"
#include "NV_NVDLA_glb.h"
// # Convolution core
#include "NV_NVDLA_cdma.h"
#include "NV_NVDLA_cbuf.h"
#include "NV_NVDLA_csc.h"
#include "NV_NVDLA_cmac.h"
#include "NV_NVDLA_cacc.h"
// # Post processors
#include "NV_NVDLA_sdp.h"
#include "NV_NVDLA_pdp.h"
#include "NV_NVDLA_cdp.h"
#include "NvdlaCoreDummy.h"
// For reference model usage, begin
#ifdef  NVDLA_REFERENCE_MODEL_ENABLE
#include "NvdlaCoreInternalMonitor.h"
#include "nvdla_scsv_converter.h"
#endif
// For reference model usage, end

SCSIM_NAMESPACE_START(clib)
// clib class forward declaration
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)


class NV_NVDLA_core:
    public  NV_NVDLA_core_base  // ports
{
    public:
        SC_HAS_PROCESS(NV_NVDLA_core);
        NV_NVDLA_core( sc_module_name module_name );
        NV_NVDLA_core( sc_module_name module_name, uint8_t nvdla_id_in );
        ~NV_NVDLA_core();
        void Initialize();
        // Overload for pure virtual TLM target functions
        // void nvdla2csb_b_transport(int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);

        uint8_t              nvdla_id;

        // Subunit declaration
        // # Interface modules
        NV_NVDLA_csb_master *csb_master;
        NV_NVDLA_bdma       *bdma;
        NV_NVDLA_rbk        *rbk;
        NV_NVDLA_mcif       *mcif;
        NV_NVDLA_cvif       *cvif;
        NV_NVDLA_glb        *glb;
        // # Convolution core
        NV_NVDLA_cdma       *cdma;
        NV_NVDLA_cbuf       *cbuf;
        NV_NVDLA_csc        *csc;
        NV_NVDLA_cmac       *cmac_a;
        NV_NVDLA_cmac       *cmac_b;
        NV_NVDLA_cacc       *cacc;
        // # Post processors
        NV_NVDLA_sdp        *sdp;
        NV_NVDLA_pdp        *pdp;
        NV_NVDLA_cdp        *cdp;
        NvdlaCoreDummy      *core_dummy;
// For reference model usage, begin
#ifdef  NVDLA_REFERENCE_MODEL_ENABLE
        NvdlaCoreInternalMonitor *internal_monitor;
#endif
// For reference model usage, end

        // AXI workaround
        // # MC
        // MC write request (initiator)
        tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_core, 512>   mcif2ext_wr_req;
        // MC write response (target)
        tlm_utils::multi_passthrough_target_socket<NV_NVDLA_core, 512>      ext2mcif_wr_rsp;
        // virtual void ext2mcif_wr_rsp_b_transport(int ID, tlm::tlm_generic_payload& tlm_gp, sc_time& delay);
        // MC read request (initiator)
        tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_core, 512>   mcif2ext_rd_req;
        // MC read response (target)
        tlm_utils::multi_passthrough_target_socket<NV_NVDLA_core, 512>      ext2mcif_rd_rsp;
        // virtual void ext2mcif_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& tlm_gp, sc_time& delay);

        // # CVSRAM
        // CV write request (initiator)
        tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_core, 512>   cvif2ext_wr_req;
        // CV write response (target)
        tlm_utils::multi_passthrough_target_socket<NV_NVDLA_core, 512>      ext2cvif_wr_rsp;
        // virtual void ext2cvif_wr_rsp_b_transport(int ID, tlm::tlm_generic_payload& tlm_gp, sc_time& delay);
        // CV read request (initiator)
        tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_core, 512>   cvif2ext_rd_req;
        // CV read response (target)
        tlm_utils::multi_passthrough_target_socket<NV_NVDLA_core, 512>      ext2cvif_rd_rsp;
        // virtual void ext2cvif_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& tlm_gp, sc_time& delay);

        tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_core, 32, tlm::tlm_base_protocol_types, 0, sc_core::SC_ONE_OR_MORE_BOUND> csb2nvdla_wr_hack;

        sc_buffer<bool> mcif2bdma_wr_rsp;
        sc_buffer<bool> mcif2cdp_wr_rsp;
        sc_buffer<bool> mcif2pdp_wr_rsp;
        sc_buffer<bool> mcif2sdp_wr_rsp;
        sc_buffer<bool> mcif2rbk_wr_rsp;
        sc_buffer<bool> cvif2bdma_wr_rsp;
        sc_buffer<bool> cvif2cdp_wr_rsp;
        sc_buffer<bool> cvif2pdp_wr_rsp;
        sc_buffer<bool> cvif2sdp_wr_rsp;
        sc_buffer<bool> cvif2rbk_wr_rsp;

        // interrupt signals
        sc_buffer<bool> bdma2glb_done_intr[2];
        sc_buffer<bool> cdma_dat2glb_done_intr[2];
        sc_buffer<bool> cdma_wt2glb_done_intr[2];
        sc_buffer<bool> pdp2glb_done_intr[2];
        sc_buffer<bool> sdp2glb_done_intr[2];
        sc_buffer<bool> cdp2glb_done_intr[2];
        sc_buffer<bool> rbk2glb_done_intr[2];
        sc_buffer<bool> cacc2glb_done_intr[2];

        sc_signal<bool> cdma_wt_dma_arbiter_override_enable;

        // For reference model usage, begin
#ifdef  NVDLA_REFERENCE_MODEL_ENABLE
        tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_core, 32, tlm::tlm_base_protocol_types, 1, sc_core::SC_ZERO_OR_MORE_BOUND> dma_monitor_mc;
        tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_core, 32, tlm::tlm_base_protocol_types, 1, sc_core::SC_ZERO_OR_MORE_BOUND> dma_monitor_cv;
        tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_core, 32, tlm::tlm_base_protocol_types, 1, sc_core::SC_ZERO_OR_MORE_BOUND> convolution_core_monitor_initiator;
        tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_core, 32, tlm::tlm_base_protocol_types, 1, sc_core::SC_ZERO_OR_MORE_BOUND> post_processing_monitor_initiator;
        // Credit grant targets
        tlm_utils::multi_passthrough_target_socket<NV_NVDLA_core, 32, tlm::tlm_base_protocol_types> dma_monitor_mc_credit;
        tlm_utils::multi_passthrough_target_socket<NV_NVDLA_core, 32, tlm::tlm_base_protocol_types> dma_monitor_cv_credit;
        tlm_utils::multi_passthrough_target_socket<NV_NVDLA_core, 32, tlm::tlm_base_protocol_types> convolution_core_monitor_credit;
        tlm_utils::multi_passthrough_target_socket<NV_NVDLA_core, 32, tlm::tlm_base_protocol_types> post_processing_monitor_credit;
#endif
        // For reference model usage, end

    private:
        // Variables
        // Payloads
        // Delay
        // Events
        // FIFOs

        // Function declaration 
        // # Threads
        // # Functional functions
};

SCSIM_NAMESPACE_END()

//extern "C" scsim::cmod::NV_NVDLA_core * NV_NVDLA_coreCon(sc_module_name module_name);

#endif

