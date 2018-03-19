// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cvif.h

#ifndef _NV_NVDLA_CVIF_H_
#define _NV_NVDLA_CVIF_H_
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include <systemc.h>
#include <tlm.h>
#include "tlm_utils/multi_passthrough_initiator_socket.h"
#include "tlm_utils/multi_passthrough_target_socket.h" 

#include "nvdla_dma_wr_req_iface.h"
#include "scsim_common.h"
#include "nvdla_dbb_extension.h"
#include "dla_b_transport_payload.h"
#include "systemc.h"
#include "nvdla_config.h"

#include "NV_NVDLA_cvif_base.h"

#ifndef NVDLA_SECONDARY_MEMIF_MAX_BURST_LENGTH
// fool the compiler to make it pass, if this macro is not defined, it means SECONDARY_MEMIF is not configured thus any value should be fine;
#define NVDLA_SECONDARY_MEMIF_MAX_BURST_LENGTH  4
#define NVDLA_SECONDARY_MEMIF_WIDTH             8
#endif
#undef CVIF_MAX_MEM_TRANSACTION_SIZE
#define CVIF_MAX_MEM_TRANSACTION_SIZE       (NVDLA_SECONDARY_MEMIF_MAX_BURST_LENGTH*NVDLA_SECONDARY_MEMIF_WIDTH/8)
#undef  MEM_TRANSACTION_SIZE
#define MEM_TRANSACTION_SIZE                (NVDLA_SECONDARY_MEMIF_WIDTH/8)
#define DMA_TRANSACTION_SIZE                (DMAIF_WIDTH)

// address alignment should be the same as bus width
#define AXI_ALIGN_SIZE                      (NVDLA_SECONDARY_MEMIF_WIDTH/8)
// NOTE: DMA_ATOMIC is different with DLA ATOMIC-M term: 1 DMA_ATOMIC means MIN_BUS_WIDTH bytes
// while DLA ATOMI_M size equals to DLA_ATOM_SIZE bytes
#define TRANSACTION_DMA_ATOMIC_NUM          (DMAIF_WIDTH/MIN_BUS_WIDTH)
#define TAG_CMD                             0
#define TAG_DATA                            1


#define CDMA_DAT_AXI_ID 8
#define CDMA_WT_AXI_ID 9
#define BDMA_AXI_ID 0
#define SDP_AXI_ID 1
#define PDP_AXI_ID 2
#define CDP_AXI_ID 3
#define SDP_B_AXI_ID 5
#define SDP_N_AXI_ID 6
#define SDP_E_AXI_ID 7
#define RBK_AXI_ID 4


SCSIM_NAMESPACE_START(clib)
    // clib class forward declaration
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)


struct client_cvif_wr_req_t {
    uint64_t addr;
    uint32_t size;
    uint32_t require_ack;
};

class NV_NVDLA_cvif:
    public  NV_NVDLA_cvif_base  // ports
{
    public:
        SC_HAS_PROCESS(NV_NVDLA_cvif);
        NV_NVDLA_cvif( sc_module_name module_name, bool headless_ntb_env_in, uint8_t nvdla_id_in );
        ~NV_NVDLA_cvif();

        bool             headless_ntb_env;
        uint8_t          nvdla_id;
        // Initiator Socket
        // # Write request
        // tlm::tlm_generic_payload                                            cvif2ext_wr_req_gp;
        // scsim::clib::dla_b_transport_payload                                    *cvif2ext_wr_req_payload;
        // dla_b_transport_payload                                    *cvif2ext_wr_req_payload;
        tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cvif, 512>   cvif2ext_wr_req;

        // # Read request
        // tlm::tlm_generic_payload                                            cvif2ext_rd_req_gp;
        // scsim::clib::dla_b_transport_payload                                    *cvif2ext_rd_req_payload;
        // dla_b_transport_payload                                    *cvif2ext_rd_req_payload;
        tlm_utils::multi_passthrough_initiator_socket<NV_NVDLA_cvif, 512>   cvif2ext_rd_req;

        // Target Socket
        // # AXI Write response
        tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cvif, 512>      ext2cvif_wr_rsp;
        virtual void ext2cvif_wr_rsp_b_transport(int ID, tlm::tlm_generic_payload& tlm_gp, sc_time& delay);

        // # AXI Read response
        tlm_utils::multi_passthrough_target_socket<NV_NVDLA_cvif, 512>      ext2cvif_rd_rsp;
        virtual void ext2cvif_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& tlm_gp, sc_time& delay);

        // Overload virtual target functions in base class
        void bdma2cvif_rd_req_b_transport   (int ID, nvdla_dma_rd_req_t*, sc_core::sc_time&);
        void sdp2cvif_rd_req_b_transport   (int ID, nvdla_dma_rd_req_t*, sc_core::sc_time&);
        void pdp2cvif_rd_req_b_transport   (int ID, nvdla_dma_rd_req_t*, sc_core::sc_time&);
        void cdp2cvif_rd_req_b_transport   (int ID, nvdla_dma_rd_req_t*, sc_core::sc_time&);
        void rbk2cvif_rd_req_b_transport   (int ID, nvdla_dma_rd_req_t*, sc_core::sc_time&);
        void sdp_b2cvif_rd_req_b_transport   (int ID, nvdla_dma_rd_req_t*, sc_core::sc_time&);
        void sdp_n2cvif_rd_req_b_transport   (int ID, nvdla_dma_rd_req_t*, sc_core::sc_time&);
        void sdp_e2cvif_rd_req_b_transport   (int ID, nvdla_dma_rd_req_t*, sc_core::sc_time&);
        void cdma_dat2cvif_rd_req_b_transport   (int ID, nvdla_dma_rd_req_t*, sc_core::sc_time&);
        void cdma_wt2cvif_rd_req_b_transport   (int ID, nvdla_dma_rd_req_t*, sc_core::sc_time&);
        void bdma2cvif_wr_req_b_transport   (int ID, nvdla_dma_wr_req_t*, sc_core::sc_time&);
        void sdp2cvif_wr_req_b_transport   (int ID, nvdla_dma_wr_req_t*, sc_core::sc_time&);
        void pdp2cvif_wr_req_b_transport   (int ID, nvdla_dma_wr_req_t*, sc_core::sc_time&);
        void cdp2cvif_wr_req_b_transport   (int ID, nvdla_dma_wr_req_t*, sc_core::sc_time&);
        void rbk2cvif_wr_req_b_transport   (int ID, nvdla_dma_wr_req_t*, sc_core::sc_time&);


    private:
        // Variables
        bool is_there_ongoing_csb2cvif_response_;

        // Request fifos
        sc_core::sc_fifo <scsim::clib::dla_b_transport_payload*>  *bdma_rd_req_fifo_;
        sc_core::sc_fifo    <bool> *bdma_rd_atom_enable_fifo_;

        // fifos storing number of atoms in read request
        sc_core::sc_fifo <uint32_t>  * bdma2cvif_rd_req_atom_num_fifo_;
        scsim::clib::dla_b_transport_payload  * bdma_rd_req_payload_;

        // Data return fifos (from cvif to clients)
        sc_core::sc_fifo <uint8_t*>  *cvif2bdma_rd_rsp_fifo_;
        int32_t                 credit_cvif2bdma_rd_rsp_fifo_;
        // Request fifos
        sc_core::sc_fifo <scsim::clib::dla_b_transport_payload*>  *sdp_rd_req_fifo_;
        sc_core::sc_fifo    <bool> *sdp_rd_atom_enable_fifo_;

        // fifos storing number of atoms in read request
        sc_core::sc_fifo <uint32_t>  * sdp2cvif_rd_req_atom_num_fifo_;
        scsim::clib::dla_b_transport_payload  * sdp_rd_req_payload_;

        // Data return fifos (from cvif to clients)
        sc_core::sc_fifo <uint8_t*>  *cvif2sdp_rd_rsp_fifo_;
        int32_t                 credit_cvif2sdp_rd_rsp_fifo_;
        // Request fifos
        sc_core::sc_fifo <scsim::clib::dla_b_transport_payload*>  *pdp_rd_req_fifo_;
        sc_core::sc_fifo    <bool> *pdp_rd_atom_enable_fifo_;

        // fifos storing number of atoms in read request
        sc_core::sc_fifo <uint32_t>  * pdp2cvif_rd_req_atom_num_fifo_;
        scsim::clib::dla_b_transport_payload  * pdp_rd_req_payload_;

        // Data return fifos (from cvif to clients)
        sc_core::sc_fifo <uint8_t*>  *cvif2pdp_rd_rsp_fifo_;
        int32_t                 credit_cvif2pdp_rd_rsp_fifo_;
        // Request fifos
        sc_core::sc_fifo <scsim::clib::dla_b_transport_payload*>  *cdp_rd_req_fifo_;
        sc_core::sc_fifo    <bool> *cdp_rd_atom_enable_fifo_;

        // fifos storing number of atoms in read request
        sc_core::sc_fifo <uint32_t>  * cdp2cvif_rd_req_atom_num_fifo_;
        scsim::clib::dla_b_transport_payload  * cdp_rd_req_payload_;

        // Data return fifos (from cvif to clients)
        sc_core::sc_fifo <uint8_t*>  *cvif2cdp_rd_rsp_fifo_;
        int32_t                 credit_cvif2cdp_rd_rsp_fifo_;
        // Request fifos
        sc_core::sc_fifo <scsim::clib::dla_b_transport_payload*>  *rbk_rd_req_fifo_;
        sc_core::sc_fifo    <bool> *rbk_rd_atom_enable_fifo_;

        // fifos storing number of atoms in read request
        sc_core::sc_fifo <uint32_t>  * rbk2cvif_rd_req_atom_num_fifo_;
        scsim::clib::dla_b_transport_payload  * rbk_rd_req_payload_;

        // Data return fifos (from cvif to clients)
        sc_core::sc_fifo <uint8_t*>  *cvif2rbk_rd_rsp_fifo_;
        int32_t                 credit_cvif2rbk_rd_rsp_fifo_;
        // Request fifos
        sc_core::sc_fifo <scsim::clib::dla_b_transport_payload*>  *sdp_b_rd_req_fifo_;
        sc_core::sc_fifo    <bool> *sdp_b_rd_atom_enable_fifo_;

        // fifos storing number of atoms in read request
        sc_core::sc_fifo <uint32_t>  * sdp_b2cvif_rd_req_atom_num_fifo_;
        scsim::clib::dla_b_transport_payload  * sdp_b_rd_req_payload_;

        // Data return fifos (from cvif to clients)
        sc_core::sc_fifo <uint8_t*>  *cvif2sdp_b_rd_rsp_fifo_;
        int32_t                 credit_cvif2sdp_b_rd_rsp_fifo_;
        // Request fifos
        sc_core::sc_fifo <scsim::clib::dla_b_transport_payload*>  *sdp_n_rd_req_fifo_;
        sc_core::sc_fifo    <bool> *sdp_n_rd_atom_enable_fifo_;

        // fifos storing number of atoms in read request
        sc_core::sc_fifo <uint32_t>  * sdp_n2cvif_rd_req_atom_num_fifo_;
        scsim::clib::dla_b_transport_payload  * sdp_n_rd_req_payload_;

        // Data return fifos (from cvif to clients)
        sc_core::sc_fifo <uint8_t*>  *cvif2sdp_n_rd_rsp_fifo_;
        int32_t                 credit_cvif2sdp_n_rd_rsp_fifo_;
        // Request fifos
        sc_core::sc_fifo <scsim::clib::dla_b_transport_payload*>  *sdp_e_rd_req_fifo_;
        sc_core::sc_fifo    <bool> *sdp_e_rd_atom_enable_fifo_;

        // fifos storing number of atoms in read request
        sc_core::sc_fifo <uint32_t>  * sdp_e2cvif_rd_req_atom_num_fifo_;
        scsim::clib::dla_b_transport_payload  * sdp_e_rd_req_payload_;

        // Data return fifos (from cvif to clients)
        sc_core::sc_fifo <uint8_t*>  *cvif2sdp_e_rd_rsp_fifo_;
        int32_t                 credit_cvif2sdp_e_rd_rsp_fifo_;
        // Request fifos
        sc_core::sc_fifo <scsim::clib::dla_b_transport_payload*>  *cdma_dat_rd_req_fifo_;
        sc_core::sc_fifo    <bool> *cdma_dat_rd_atom_enable_fifo_;

        // fifos storing number of atoms in read request
        sc_core::sc_fifo <uint32_t>  * cdma_dat2cvif_rd_req_atom_num_fifo_;
        scsim::clib::dla_b_transport_payload  * cdma_dat_rd_req_payload_;

        // Data return fifos (from cvif to clients)
        sc_core::sc_fifo <uint8_t*>  *cvif2cdma_dat_rd_rsp_fifo_;
        int32_t                 credit_cvif2cdma_dat_rd_rsp_fifo_;
        // Request fifos
        sc_core::sc_fifo <scsim::clib::dla_b_transport_payload*>  *cdma_wt_rd_req_fifo_;
        sc_core::sc_fifo    <bool> *cdma_wt_rd_atom_enable_fifo_;

        // fifos storing number of atoms in read request
        sc_core::sc_fifo <uint32_t>  * cdma_wt2cvif_rd_req_atom_num_fifo_;
        scsim::clib::dla_b_transport_payload  * cdma_wt_rd_req_payload_;

        // Data return fifos (from cvif to clients)
        sc_core::sc_fifo <uint8_t*>  *cvif2cdma_wt_rd_rsp_fifo_;
        int32_t                 credit_cvif2cdma_wt_rd_rsp_fifo_;

        // Write response ack control
        //uint32_t    bdma_wr_req_expected_ack_id_;
        uint32_t    bdma_wr_req_expected_ack;
        bool        bdma_wr_req_ack_is_got_;
        uint32_t    bdma_wr_req_size_;
        uint32_t    bdma_wr_req_got_size_;
        bool        has_bdma_onging_wr_req_;
        sc_core::sc_fifo    <bool> *bdma_wr_required_ack_fifo_;
        //sc_core::sc_fifo    <uint32_t> *bdma_wr_cmd_count_fifo_;
        // Request fifos
        sc_core::sc_fifo <scsim::clib::dla_b_transport_payload*>  *bdma_wr_req_fifo_;

        // Client's write cmd to cvif
        sc_core::sc_fifo <client_cvif_wr_req_t*>  *bdma2cvif_wr_cmd_fifo_;

        // Client's write data to cvif (each entry is 32B)
        sc_core::sc_fifo <uint8_t*>  *bdma2cvif_wr_data_fifo_;
        // Write response ack control
        //uint32_t    sdp_wr_req_expected_ack_id_;
        uint32_t    sdp_wr_req_expected_ack;
        bool        sdp_wr_req_ack_is_got_;
        uint32_t    sdp_wr_req_size_;
        uint32_t    sdp_wr_req_got_size_;
        bool        has_sdp_onging_wr_req_;
        sc_core::sc_fifo    <bool> *sdp_wr_required_ack_fifo_;
        //sc_core::sc_fifo    <uint32_t> *sdp_wr_cmd_count_fifo_;
        // Request fifos
        sc_core::sc_fifo <scsim::clib::dla_b_transport_payload*>  *sdp_wr_req_fifo_;

        // Client's write cmd to cvif
        sc_core::sc_fifo <client_cvif_wr_req_t*>  *sdp2cvif_wr_cmd_fifo_;

        // Client's write data to cvif (each entry is 32B)
        sc_core::sc_fifo <uint8_t*>  *sdp2cvif_wr_data_fifo_;
        // Write response ack control
        //uint32_t    pdp_wr_req_expected_ack_id_;
        uint32_t    pdp_wr_req_expected_ack;
        bool        pdp_wr_req_ack_is_got_;
        uint32_t    pdp_wr_req_size_;
        uint32_t    pdp_wr_req_got_size_;
        bool        has_pdp_onging_wr_req_;
        sc_core::sc_fifo    <bool> *pdp_wr_required_ack_fifo_;
        //sc_core::sc_fifo    <uint32_t> *pdp_wr_cmd_count_fifo_;
        // Request fifos
        sc_core::sc_fifo <scsim::clib::dla_b_transport_payload*>  *pdp_wr_req_fifo_;

        // Client's write cmd to cvif
        sc_core::sc_fifo <client_cvif_wr_req_t*>  *pdp2cvif_wr_cmd_fifo_;

        // Client's write data to cvif (each entry is 32B)
        sc_core::sc_fifo <uint8_t*>  *pdp2cvif_wr_data_fifo_;
        // Write response ack control
        //uint32_t    cdp_wr_req_expected_ack_id_;
        uint32_t    cdp_wr_req_expected_ack;
        bool        cdp_wr_req_ack_is_got_;
        uint32_t    cdp_wr_req_size_;
        uint32_t    cdp_wr_req_got_size_;
        bool        has_cdp_onging_wr_req_;
        sc_core::sc_fifo    <bool> *cdp_wr_required_ack_fifo_;
        //sc_core::sc_fifo    <uint32_t> *cdp_wr_cmd_count_fifo_;
        // Request fifos
        sc_core::sc_fifo <scsim::clib::dla_b_transport_payload*>  *cdp_wr_req_fifo_;

        // Client's write cmd to cvif
        sc_core::sc_fifo <client_cvif_wr_req_t*>  *cdp2cvif_wr_cmd_fifo_;

        // Client's write data to cvif (each entry is 32B)
        sc_core::sc_fifo <uint8_t*>  *cdp2cvif_wr_data_fifo_;
        // Write response ack control
        //uint32_t    rbk_wr_req_expected_ack_id_;
        uint32_t    rbk_wr_req_expected_ack;
        bool        rbk_wr_req_ack_is_got_;
        uint32_t    rbk_wr_req_size_;
        uint32_t    rbk_wr_req_got_size_;
        bool        has_rbk_onging_wr_req_;
        sc_core::sc_fifo    <bool> *rbk_wr_required_ack_fifo_;
        //sc_core::sc_fifo    <uint32_t> *rbk_wr_cmd_count_fifo_;
        // Request fifos
        sc_core::sc_fifo <scsim::clib::dla_b_transport_payload*>  *rbk_wr_req_fifo_;

        // Client's write cmd to cvif
        sc_core::sc_fifo <client_cvif_wr_req_t*>  *rbk2cvif_wr_cmd_fifo_;

        // Client's write data to cvif (each entry is 32B)
        sc_core::sc_fifo <uint8_t*>  *rbk2cvif_wr_data_fifo_;


        // Payloads for write dma request

        // Delay
        sc_core::sc_time dma_delay_;
        sc_core::sc_time csb_delay_;
        sc_core::sc_time axi_delay_;

        // Events

        // Function declaration 
        void Reset();
        // # Threads
        void ReadRequestArbiter();
        void WriteRequestArbiter();


        void ReadResp_cvif2bdma();

        void ReadResp_cvif2sdp();

        void ReadResp_cvif2pdp();

        void ReadResp_cvif2cdp();

        void ReadResp_cvif2rbk();

        void ReadResp_cvif2sdp_b();

        void ReadResp_cvif2sdp_n();

        void ReadResp_cvif2sdp_e();

        void ReadResp_cvif2cdma_dat();

        void ReadResp_cvif2cdma_wt();


        void WriteRequest_bdma2cvif();

        void WriteRequest_sdp2cvif();

        void WriteRequest_pdp2cvif();

        void WriteRequest_cdp2cvif();

        void WriteRequest_rbk2cvif();

        void CvifSendCsbResponse(uint8_t type, uint32_t data, uint8_t error_id);
};

SCSIM_NAMESPACE_END()

//extern "C" scsim::cmod::NV_NVDLA_cvif * NV_NVDLA_cvifCon(sc_module_name module_name, uint8_t nvdla_id_in);

#endif

