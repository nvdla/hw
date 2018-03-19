
#ifndef _NVDLACOREINTERNALMONITOR_H_
#define _NVDLACOREINTERNALMONITOR_H_
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include "nvdla_monitor_dma_transaction.h"
#include "nvdla_dma_rd_req_iface.h"
#include "nvdla_dma_rd_rsp_iface.h"
#include "nvdla_dma_wr_req_iface.h"
#include "nvdla_sc2mac_data_if_iface.h"
#include "nvdla_sc2mac_weight_if_iface.h"
#include "nvdla_mac2accu_data_if_iface.h"
#include "nvdla_sc2mac_data_monitor.h"
#include "nvdla_sc2mac_weight_monitor.h"
#include "nvdla_mac2accu_data_monitor.h"
#include "nvdla_accu2pp_if_iface.h"
#include "nvdla_sdp2pdp_iface.h"
#include "scsim_common.h"
#include <systemc.h>
#include <tlm.h>
#include "tlm_utils/multi_passthrough_initiator_socket.h"
#include "tlm_utils/multi_passthrough_target_socket.h" 
#include "systemc.h"

#define COMMON_FIFO_DEPTH  1024
#define DMA_REQ_FIFO_DEPTH 1024
#define DMA_RSP_FIFO_DEPTH 1024

// #define CDMA_DAT_ID 0
// #define CDMA_MN_ID 1
// #define CDMA_WT_ID 2
// #define BDMA_ID 3
// #define SDP_ID 4
// #define PDP_ID 5
// #define CDP_ID 6

// #define MONITOR_WORKING_MODE_NOT_SAMPLING   2147483647
// #define MONITOR_WORKING_MODE_PASSTHROUGH    2147483646
#define MONITOR_WORKING_MODE_NOT_SAMPLING   -1
#define MONITOR_WORKING_MODE_PASSTHROUGH    -2
#define MONITOR_WORKING_MODE_CREDIT         0


#define CV_BDMA_READ_AXI_ID 0
#define CV_SDP_READ_AXI_ID 1
#define CV_PDP_READ_AXI_ID 2
#define CV_CDP_READ_AXI_ID 3
#define CV_RBK_READ_AXI_ID 4
#define CV_SDP_B_READ_AXI_ID 5
#define CV_SDP_N_READ_AXI_ID 6
#define CV_SDP_E_READ_AXI_ID 7
#define CV_CDMA_DAT_READ_AXI_ID 8
#define CV_CDMA_WT_READ_AXI_ID 9
#define CV_BDMA_WRITE_AXI_ID 0
#define CV_SDP_WRITE_AXI_ID 1
#define CV_PDP_WRITE_AXI_ID 2
#define CV_CDP_WRITE_AXI_ID 3
#define CV_RBK_WRITE_AXI_ID 4
#define MC_BDMA_READ_AXI_ID 0
#define MC_SDP_READ_AXI_ID 1
#define MC_PDP_READ_AXI_ID 2
#define MC_CDP_READ_AXI_ID 3
#define MC_RBK_READ_AXI_ID 4
#define MC_SDP_B_READ_AXI_ID 5
#define MC_SDP_N_READ_AXI_ID 6
#define MC_SDP_E_READ_AXI_ID 7
#define MC_CDMA_DAT_READ_AXI_ID 8
#define MC_CDMA_WT_READ_AXI_ID 9
#define MC_BDMA_WRITE_AXI_ID 0
#define MC_SDP_WRITE_AXI_ID 1
#define MC_PDP_WRITE_AXI_ID 2
#define MC_CDP_WRITE_AXI_ID 3
#define MC_RBK_WRITE_AXI_ID 4


SCSIM_NAMESPACE_START(clib)
// clib class forward declaration
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)

// union nvdla_conv_core_interface_u {
//     nvdla_sc2mac_data_if_t      sc2mac_data;
//     nvdla_sc2mac_weight_if_t    sc2mac_weight;
//     nvdla_mac2accu_data_if_t    mac2accu;
// };

#define TAG_SC2MAC_DAT_A   0
#define TAG_SC2MAC_DAT_B   1
#define TAG_SC2MAC_WT_A 2
#define TAG_SC2MAC_WT_B 3
#define TAG_MAC_A2ACCU      4
#define TAG_MAC_B2ACCU      5 

#define TAG_CACC2SDP    0
#define TAG_SDP2PDP     1

// typedef struct nvdla_conv_core_interface_s {
//     uint8_t tag;
//     union   nvdla_conv_core_interface_u pd; 
// } nvdla_conv_core_interface_t;

typedef struct {
    int32_t     sub_id;
    int32_t     credit;
    int32_t     is_req;
    int32_t     is_read;
    int32_t     txn_id;
} credit_structure;

class NvdlaCoreInternalMonitor: public sc_module
{
    public:
        SC_HAS_PROCESS(NvdlaCoreInternalMonitor);
        NvdlaCoreInternalMonitor(const sc_module_name module_name );
        virtual ~NvdlaCoreInternalMonitor();
        // TLM monitor target sockets, probing internal transaction inside CMOD
        // # DMA        : request and response

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> bdma2cvif_rd_req;
        virtual void bdma2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void bdma2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay);
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> cvif2bdma_rd_rsp;
        virtual void cvif2bdma_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void cvif2bdma_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> sdp2cvif_rd_req;
        virtual void sdp2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void sdp2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay);
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> cvif2sdp_rd_rsp;
        virtual void cvif2sdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void cvif2sdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> pdp2cvif_rd_req;
        virtual void pdp2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void pdp2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay);
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> cvif2pdp_rd_rsp;
        virtual void cvif2pdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void cvif2pdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> cdp2cvif_rd_req;
        virtual void cdp2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void cdp2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay);
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> cvif2cdp_rd_rsp;
        virtual void cvif2cdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void cvif2cdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> rbk2cvif_rd_req;
        virtual void rbk2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void rbk2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay);
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> cvif2rbk_rd_rsp;
        virtual void cvif2rbk_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void cvif2rbk_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> sdp_b2cvif_rd_req;
        virtual void sdp_b2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void sdp_b2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay);
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> cvif2sdp_b_rd_rsp;
        virtual void cvif2sdp_b_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void cvif2sdp_b_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> sdp_n2cvif_rd_req;
        virtual void sdp_n2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void sdp_n2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay);
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> cvif2sdp_n_rd_rsp;
        virtual void cvif2sdp_n_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void cvif2sdp_n_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> sdp_e2cvif_rd_req;
        virtual void sdp_e2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void sdp_e2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay);
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> cvif2sdp_e_rd_rsp;
        virtual void cvif2sdp_e_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void cvif2sdp_e_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> cdma_dat2cvif_rd_req;
        virtual void cdma_dat2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void cdma_dat2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay);
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> cvif2cdma_dat_rd_rsp;
        virtual void cvif2cdma_dat_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void cvif2cdma_dat_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> cdma_wt2cvif_rd_req;
        virtual void cdma_wt2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void cdma_wt2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay);
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> cvif2cdma_wt_rd_rsp;
        virtual void cvif2cdma_wt_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void cvif2cdma_wt_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> bdma2cvif_wr_req;
        virtual void bdma2cvif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void bdma2cvif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay);
        sc_in<bool> cvif2bdma_wr_rsp;

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> sdp2cvif_wr_req;
        virtual void sdp2cvif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void sdp2cvif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay);
        sc_in<bool> cvif2sdp_wr_rsp;

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> pdp2cvif_wr_req;
        virtual void pdp2cvif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void pdp2cvif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay);
        sc_in<bool> cvif2pdp_wr_rsp;

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> cdp2cvif_wr_req;
        virtual void cdp2cvif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void cdp2cvif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay);
        sc_in<bool> cvif2cdp_wr_rsp;

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> rbk2cvif_wr_req;
        virtual void rbk2cvif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void rbk2cvif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay);
        sc_in<bool> cvif2rbk_wr_rsp;

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> bdma2mcif_rd_req;
        virtual void bdma2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void bdma2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay);
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> mcif2bdma_rd_rsp;
        virtual void mcif2bdma_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void mcif2bdma_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> sdp2mcif_rd_req;
        virtual void sdp2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void sdp2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay);
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> mcif2sdp_rd_rsp;
        virtual void mcif2sdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void mcif2sdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> pdp2mcif_rd_req;
        virtual void pdp2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void pdp2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay);
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> mcif2pdp_rd_rsp;
        virtual void mcif2pdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void mcif2pdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> cdp2mcif_rd_req;
        virtual void cdp2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void cdp2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay);
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> mcif2cdp_rd_rsp;
        virtual void mcif2cdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void mcif2cdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> rbk2mcif_rd_req;
        virtual void rbk2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void rbk2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay);
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> mcif2rbk_rd_rsp;
        virtual void mcif2rbk_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void mcif2rbk_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> sdp_b2mcif_rd_req;
        virtual void sdp_b2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void sdp_b2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay);
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> mcif2sdp_b_rd_rsp;
        virtual void mcif2sdp_b_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void mcif2sdp_b_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> sdp_n2mcif_rd_req;
        virtual void sdp_n2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void sdp_n2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay);
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> mcif2sdp_n_rd_rsp;
        virtual void mcif2sdp_n_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void mcif2sdp_n_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> sdp_e2mcif_rd_req;
        virtual void sdp_e2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void sdp_e2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay);
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> mcif2sdp_e_rd_rsp;
        virtual void mcif2sdp_e_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void mcif2sdp_e_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> cdma_dat2mcif_rd_req;
        virtual void cdma_dat2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void cdma_dat2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay);
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> mcif2cdma_dat_rd_rsp;
        virtual void mcif2cdma_dat_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void mcif2cdma_dat_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> cdma_wt2mcif_rd_req;
        virtual void cdma_wt2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void cdma_wt2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay);
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> mcif2cdma_wt_rd_rsp;
        virtual void mcif2cdma_wt_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void mcif2cdma_wt_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> bdma2mcif_wr_req;
        virtual void bdma2mcif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void bdma2mcif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay);
        sc_in<bool> mcif2bdma_wr_rsp;

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> sdp2mcif_wr_req;
        virtual void sdp2mcif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void sdp2mcif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay);
        sc_in<bool> mcif2sdp_wr_rsp;

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> pdp2mcif_wr_req;
        virtual void pdp2mcif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void pdp2mcif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay);
        sc_in<bool> mcif2pdp_wr_rsp;

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> cdp2mcif_wr_req;
        virtual void cdp2mcif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void cdp2mcif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay);
        sc_in<bool> mcif2cdp_wr_rsp;

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> rbk2mcif_wr_req;
        virtual void rbk2mcif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void rbk2mcif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay);
        sc_in<bool> mcif2rbk_wr_rsp;

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> sc2mac_dat_a;
        virtual void sc2mac_dat_a_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void sc2mac_dat_a_b_transport(int ID, nvdla_sc2mac_data_if_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> sc2mac_dat_b;
        virtual void sc2mac_dat_b_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void sc2mac_dat_b_b_transport(int ID, nvdla_sc2mac_data_if_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> sc2mac_wt_a;
        virtual void sc2mac_wt_a_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void sc2mac_wt_a_b_transport(int ID, nvdla_sc2mac_weight_if_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> sc2mac_wt_b;
        virtual void sc2mac_wt_b_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void sc2mac_wt_b_b_transport(int ID, nvdla_sc2mac_weight_if_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> mac_a2accu;
        virtual void mac_a2accu_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void mac_a2accu_b_transport(int ID, nvdla_mac2accu_data_if_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> mac_b2accu;
        virtual void mac_b2accu_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void mac_b2accu_b_transport(int ID, nvdla_mac2accu_data_if_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> cacc2sdp;
        virtual void cacc2sdp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void cacc2sdp_b_transport(int ID, nvdla_accu2pp_if_t* payload, sc_time& delay);

        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> sdp2pdp;
        virtual void sdp2pdp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
        virtual void sdp2pdp_b_transport(int ID, nvdla_sdp2pdp_t* payload, sc_time& delay);


        // Credit granting interface target
        // // Target Socket : convolution_core_monitor_credit_target
        // tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> convolution_core_monitor_credit_target;
        // void convolution_core_monitor_credit_target_b_transport(int ID, tlm::tlm_generic_payload& gp, sc_time& delay);

        // // Target Socket : post_processing_monitor_credit_target
        // tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> post_processing_monitor_credit_target;
        // void post_processing_monitor_credit_target_b_transport(int ID, tlm::tlm_generic_payload& gp, sc_time& delay);

        // Target Socket : dma_monitor_mc_credit
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> dma_monitor_mc_credit;
        void dma_monitor_mc_credit_b_transport(int ID, tlm::tlm_generic_payload& gp, sc_time& delay);

        // Target Socket : dma_monitor_cv_credit
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> dma_monitor_cv_credit;
        void dma_monitor_cv_credit_b_transport(int ID, tlm::tlm_generic_payload& gp, sc_time& delay);

        // Target Socket : convolution_core_monitor_credit
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> convolution_core_monitor_credit;
        void convolution_core_monitor_credit_b_transport(int ID, tlm::tlm_generic_payload& gp, sc_time& delay);

        // Target Socket : post_processing_monitor_credit
        tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> post_processing_monitor_credit;
        void post_processing_monitor_credit_b_transport(int ID, tlm::tlm_generic_payload& gp, sc_time& delay);

//         // # Valid-only :      CSC-to-CMAC, CMAC-to-CACC
//         // # Valid-only :      CSC-to-CMAC, CMAC-to-CACC
//         // Target Socket (unrecognized protocol: nvdla_sc2mac_data_if_t): sc2mac_dat
//         tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> sc2mac_dat_a;
//         tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> sc2mac_dat_b;
//         virtual void sc2mac_dat_a_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
//         virtual void sc2mac_dat_a_b_transport(int ID, nvdla_sc2mac_data_if_t* payload, sc_time& delay);
//         virtual void sc2mac_dat_b_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
//         virtual void sc2mac_dat_b_b_transport(int ID, nvdla_sc2mac_data_if_t* payload, sc_time& delay);
// 
//         // Target Socket (unrecognized protocol: nvdla_sc2mac_weight_if_t): sc2mac_wt
//         tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> sc2mac_wt_a;
//         tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> sc2mac_wt_b;
//         virtual void sc2mac_wt_a_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
//         virtual void sc2mac_wt_a_b_transport(int ID, nvdla_sc2mac_weight_if_t* payload, sc_time& delay);
//         virtual void sc2mac_wt_b_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
//         virtual void sc2mac_wt_b_b_transport(int ID, nvdla_sc2mac_weight_if_t* payload, sc_time& delay);
// 
//         // Target Socket (unrecognized protocol: nvdla_mac2accu_data_if_t): mac_a2accu
//         tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> mac_a2accu;
//         virtual void mac_a2accu_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
//         virtual void mac_a2accu_b_transport(int ID, nvdla_mac2accu_data_if_t* payload, sc_time& delay);
// 
//         // Target Socket (unrecognized protocol: nvdla_mac2accu_data_if_t): mac_b2accu
//         tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> mac_b2accu;
//         virtual void mac_b2accu_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
//         virtual void mac_b2accu_b_transport(int ID, nvdla_mac2accu_data_if_t* payload, sc_time& delay);
// 
//         // # Valid-Ready:   CACC-to-SDP, SDP-to-PDP
//         // Target Socket (unrecognized protocol: nvdla_accu2pp_if_t): cacc2sdp
//         tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> cacc2sdp;
//         virtual void cacc2sdp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
//         virtual void cacc2sdp_b_transport(int ID, nvdla_accu2pp_if_t* payload, sc_time& delay);
// 
//         // Target Socket (unrecognized protocol: nvdla_sdp2pdp_t): sdp2pdp
//         tlm_utils::multi_passthrough_target_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types> sdp2pdp;
//         virtual void sdp2pdp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay);
//         virtual void sdp2pdp_b_transport(int ID, nvdla_sdp2pdp_t* payload, sc_time& delay);

        // TLM monitor initiator sockets, send out transaction to RTL testbench
        // # DMA
        tlm::tlm_generic_payload dma_monitor_payload_mc;
        tlm_utils::multi_passthrough_initiator_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types, 1, sc_core::SC_ZERO_OR_MORE_BOUND> dma_monitor_mc;
        virtual void dma_rd_b_transport_mc(nvdla_monitor_dma_rd_transaction_t* payload, sc_time& delay);
        virtual void dma_wr_b_transport_mc(nvdla_monitor_dma_wr_transaction_t* payload, sc_time& delay);
        tlm::tlm_generic_payload dma_monitor_payload_cv;
        tlm_utils::multi_passthrough_initiator_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types, 1, sc_core::SC_ZERO_OR_MORE_BOUND> dma_monitor_cv;
        virtual void dma_rd_b_transport_cv(nvdla_monitor_dma_rd_transaction_t* payload, sc_time& delay);
        virtual void dma_wr_b_transport_cv(nvdla_monitor_dma_wr_transaction_t* payload, sc_time& delay);
        // # Convolution core, valid-only
        tlm::tlm_generic_payload convolution_core_monitor_initiator_payload;
        tlm_utils::multi_passthrough_initiator_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types, 1, sc_core::SC_ZERO_OR_MORE_BOUND> convolution_core_monitor_initiator;
        virtual void convolution_core_monitor_initiator_b_transport(uint8_t id, nvdla_sc2mac_data_if_t*   payload, sc_time& delay);
        virtual void convolution_core_monitor_initiator_b_transport(uint8_t id, nvdla_sc2mac_weight_if_t* payload, sc_time& delay);
        virtual void convolution_core_monitor_initiator_b_transport(uint8_t id, nvdla_mac2accu_data_if_t* payload, sc_time& delay);
        // # Post processing, valid-ready
        tlm::tlm_generic_payload post_processing_monitor_initiator_payload;
        tlm_utils::multi_passthrough_initiator_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types, 1, sc_core::SC_ZERO_OR_MORE_BOUND> post_processing_monitor_initiator;
        virtual void post_processing_monitor_initiator_b_transport(nvdla_accu2pp_if_t*   payload, sc_time& delay);
        virtual void post_processing_monitor_initiator_b_transport(nvdla_sdp2pdp_t* payload, sc_time& delay);

        // # Special socket for CDMA_WT internal arbiter
        tlm::tlm_generic_payload cdma_wt_dma_arbiter_source_id;
        tlm_utils::multi_passthrough_initiator_socket<NvdlaCoreInternalMonitor, 32, tlm::tlm_base_protocol_types, 1, sc_core::SC_ZERO_OR_MORE_BOUND> cdma_wt_dma_arbiter_source_id_initiator;
        virtual void cdma_wt_dma_arbiter_source_id_initiator_b_transport(int source_id, sc_time& delay);

    private:
        // Variables
        sc_core::sc_time b_transport_delay_;
        // DMA FIFOs


        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *bdma2cvif_rd_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *cvif2bdma_rd_rsp_fifo_;
        int32_t                                                 bdma2cvif_rd_req_credit_;
        int32_t                                                 cvif2bdma_rd_rsp_credit_;
        sc_event                                                bdma2cvif_rd_req_credit_update_event_;
        sc_event                                                cvif2bdma_rd_rsp_credit_update_event_;
        sc_mutex                                                bdma2cvif_rd_req_credit_mutex_;
        sc_mutex                                                cvif2bdma_rd_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *sdp2cvif_rd_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *cvif2sdp_rd_rsp_fifo_;
        int32_t                                                 sdp2cvif_rd_req_credit_;
        int32_t                                                 cvif2sdp_rd_rsp_credit_;
        sc_event                                                sdp2cvif_rd_req_credit_update_event_;
        sc_event                                                cvif2sdp_rd_rsp_credit_update_event_;
        sc_mutex                                                sdp2cvif_rd_req_credit_mutex_;
        sc_mutex                                                cvif2sdp_rd_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *pdp2cvif_rd_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *cvif2pdp_rd_rsp_fifo_;
        int32_t                                                 pdp2cvif_rd_req_credit_;
        int32_t                                                 cvif2pdp_rd_rsp_credit_;
        sc_event                                                pdp2cvif_rd_req_credit_update_event_;
        sc_event                                                cvif2pdp_rd_rsp_credit_update_event_;
        sc_mutex                                                pdp2cvif_rd_req_credit_mutex_;
        sc_mutex                                                cvif2pdp_rd_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *cdp2cvif_rd_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *cvif2cdp_rd_rsp_fifo_;
        int32_t                                                 cdp2cvif_rd_req_credit_;
        int32_t                                                 cvif2cdp_rd_rsp_credit_;
        sc_event                                                cdp2cvif_rd_req_credit_update_event_;
        sc_event                                                cvif2cdp_rd_rsp_credit_update_event_;
        sc_mutex                                                cdp2cvif_rd_req_credit_mutex_;
        sc_mutex                                                cvif2cdp_rd_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *rbk2cvif_rd_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *cvif2rbk_rd_rsp_fifo_;
        int32_t                                                 rbk2cvif_rd_req_credit_;
        int32_t                                                 cvif2rbk_rd_rsp_credit_;
        sc_event                                                rbk2cvif_rd_req_credit_update_event_;
        sc_event                                                cvif2rbk_rd_rsp_credit_update_event_;
        sc_mutex                                                rbk2cvif_rd_req_credit_mutex_;
        sc_mutex                                                cvif2rbk_rd_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *sdp_b2cvif_rd_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *cvif2sdp_b_rd_rsp_fifo_;
        int32_t                                                 sdp_b2cvif_rd_req_credit_;
        int32_t                                                 cvif2sdp_b_rd_rsp_credit_;
        sc_event                                                sdp_b2cvif_rd_req_credit_update_event_;
        sc_event                                                cvif2sdp_b_rd_rsp_credit_update_event_;
        sc_mutex                                                sdp_b2cvif_rd_req_credit_mutex_;
        sc_mutex                                                cvif2sdp_b_rd_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *sdp_n2cvif_rd_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *cvif2sdp_n_rd_rsp_fifo_;
        int32_t                                                 sdp_n2cvif_rd_req_credit_;
        int32_t                                                 cvif2sdp_n_rd_rsp_credit_;
        sc_event                                                sdp_n2cvif_rd_req_credit_update_event_;
        sc_event                                                cvif2sdp_n_rd_rsp_credit_update_event_;
        sc_mutex                                                sdp_n2cvif_rd_req_credit_mutex_;
        sc_mutex                                                cvif2sdp_n_rd_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *sdp_e2cvif_rd_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *cvif2sdp_e_rd_rsp_fifo_;
        int32_t                                                 sdp_e2cvif_rd_req_credit_;
        int32_t                                                 cvif2sdp_e_rd_rsp_credit_;
        sc_event                                                sdp_e2cvif_rd_req_credit_update_event_;
        sc_event                                                cvif2sdp_e_rd_rsp_credit_update_event_;
        sc_mutex                                                sdp_e2cvif_rd_req_credit_mutex_;
        sc_mutex                                                cvif2sdp_e_rd_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *cdma_dat2cvif_rd_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *cvif2cdma_dat_rd_rsp_fifo_;
        int32_t                                                 cdma_dat2cvif_rd_req_credit_;
        int32_t                                                 cvif2cdma_dat_rd_rsp_credit_;
        sc_event                                                cdma_dat2cvif_rd_req_credit_update_event_;
        sc_event                                                cvif2cdma_dat_rd_rsp_credit_update_event_;
        sc_mutex                                                cdma_dat2cvif_rd_req_credit_mutex_;
        sc_mutex                                                cvif2cdma_dat_rd_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *cdma_wt2cvif_rd_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *cvif2cdma_wt_rd_rsp_fifo_;
        int32_t                                                 cdma_wt2cvif_rd_req_credit_;
        int32_t                                                 cvif2cdma_wt_rd_rsp_credit_;
        sc_event                                                cdma_wt2cvif_rd_req_credit_update_event_;
        sc_event                                                cvif2cdma_wt_rd_rsp_credit_update_event_;
        sc_mutex                                                cdma_wt2cvif_rd_req_credit_mutex_;
        sc_mutex                                                cvif2cdma_wt_rd_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_wr_transaction_t*>   *bdma2cvif_wr_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_wr_transaction_t*>   *cvif2bdma_wr_rsp_fifo_;
        int32_t                                                 bdma2cvif_wr_req_credit_;
        int32_t                                                 cvif2bdma_wr_rsp_credit_;
        sc_event                                                bdma2cvif_wr_req_credit_update_event_;
        sc_event                                                cvif2bdma_wr_rsp_credit_update_event_;
        sc_mutex                                                bdma2cvif_wr_req_credit_mutex_;
        sc_mutex                                                cvif2bdma_wr_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_wr_transaction_t*>   *sdp2cvif_wr_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_wr_transaction_t*>   *cvif2sdp_wr_rsp_fifo_;
        int32_t                                                 sdp2cvif_wr_req_credit_;
        int32_t                                                 cvif2sdp_wr_rsp_credit_;
        sc_event                                                sdp2cvif_wr_req_credit_update_event_;
        sc_event                                                cvif2sdp_wr_rsp_credit_update_event_;
        sc_mutex                                                sdp2cvif_wr_req_credit_mutex_;
        sc_mutex                                                cvif2sdp_wr_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_wr_transaction_t*>   *pdp2cvif_wr_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_wr_transaction_t*>   *cvif2pdp_wr_rsp_fifo_;
        int32_t                                                 pdp2cvif_wr_req_credit_;
        int32_t                                                 cvif2pdp_wr_rsp_credit_;
        sc_event                                                pdp2cvif_wr_req_credit_update_event_;
        sc_event                                                cvif2pdp_wr_rsp_credit_update_event_;
        sc_mutex                                                pdp2cvif_wr_req_credit_mutex_;
        sc_mutex                                                cvif2pdp_wr_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_wr_transaction_t*>   *cdp2cvif_wr_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_wr_transaction_t*>   *cvif2cdp_wr_rsp_fifo_;
        int32_t                                                 cdp2cvif_wr_req_credit_;
        int32_t                                                 cvif2cdp_wr_rsp_credit_;
        sc_event                                                cdp2cvif_wr_req_credit_update_event_;
        sc_event                                                cvif2cdp_wr_rsp_credit_update_event_;
        sc_mutex                                                cdp2cvif_wr_req_credit_mutex_;
        sc_mutex                                                cvif2cdp_wr_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_wr_transaction_t*>   *rbk2cvif_wr_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_wr_transaction_t*>   *cvif2rbk_wr_rsp_fifo_;
        int32_t                                                 rbk2cvif_wr_req_credit_;
        int32_t                                                 cvif2rbk_wr_rsp_credit_;
        sc_event                                                rbk2cvif_wr_req_credit_update_event_;
        sc_event                                                cvif2rbk_wr_rsp_credit_update_event_;
        sc_mutex                                                rbk2cvif_wr_req_credit_mutex_;
        sc_mutex                                                cvif2rbk_wr_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *bdma2mcif_rd_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *mcif2bdma_rd_rsp_fifo_;
        int32_t                                                 bdma2mcif_rd_req_credit_;
        int32_t                                                 mcif2bdma_rd_rsp_credit_;
        sc_event                                                bdma2mcif_rd_req_credit_update_event_;
        sc_event                                                mcif2bdma_rd_rsp_credit_update_event_;
        sc_mutex                                                bdma2mcif_rd_req_credit_mutex_;
        sc_mutex                                                mcif2bdma_rd_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *sdp2mcif_rd_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *mcif2sdp_rd_rsp_fifo_;
        int32_t                                                 sdp2mcif_rd_req_credit_;
        int32_t                                                 mcif2sdp_rd_rsp_credit_;
        sc_event                                                sdp2mcif_rd_req_credit_update_event_;
        sc_event                                                mcif2sdp_rd_rsp_credit_update_event_;
        sc_mutex                                                sdp2mcif_rd_req_credit_mutex_;
        sc_mutex                                                mcif2sdp_rd_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *pdp2mcif_rd_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *mcif2pdp_rd_rsp_fifo_;
        int32_t                                                 pdp2mcif_rd_req_credit_;
        int32_t                                                 mcif2pdp_rd_rsp_credit_;
        sc_event                                                pdp2mcif_rd_req_credit_update_event_;
        sc_event                                                mcif2pdp_rd_rsp_credit_update_event_;
        sc_mutex                                                pdp2mcif_rd_req_credit_mutex_;
        sc_mutex                                                mcif2pdp_rd_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *cdp2mcif_rd_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *mcif2cdp_rd_rsp_fifo_;
        int32_t                                                 cdp2mcif_rd_req_credit_;
        int32_t                                                 mcif2cdp_rd_rsp_credit_;
        sc_event                                                cdp2mcif_rd_req_credit_update_event_;
        sc_event                                                mcif2cdp_rd_rsp_credit_update_event_;
        sc_mutex                                                cdp2mcif_rd_req_credit_mutex_;
        sc_mutex                                                mcif2cdp_rd_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *rbk2mcif_rd_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *mcif2rbk_rd_rsp_fifo_;
        int32_t                                                 rbk2mcif_rd_req_credit_;
        int32_t                                                 mcif2rbk_rd_rsp_credit_;
        sc_event                                                rbk2mcif_rd_req_credit_update_event_;
        sc_event                                                mcif2rbk_rd_rsp_credit_update_event_;
        sc_mutex                                                rbk2mcif_rd_req_credit_mutex_;
        sc_mutex                                                mcif2rbk_rd_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *sdp_b2mcif_rd_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *mcif2sdp_b_rd_rsp_fifo_;
        int32_t                                                 sdp_b2mcif_rd_req_credit_;
        int32_t                                                 mcif2sdp_b_rd_rsp_credit_;
        sc_event                                                sdp_b2mcif_rd_req_credit_update_event_;
        sc_event                                                mcif2sdp_b_rd_rsp_credit_update_event_;
        sc_mutex                                                sdp_b2mcif_rd_req_credit_mutex_;
        sc_mutex                                                mcif2sdp_b_rd_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *sdp_n2mcif_rd_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *mcif2sdp_n_rd_rsp_fifo_;
        int32_t                                                 sdp_n2mcif_rd_req_credit_;
        int32_t                                                 mcif2sdp_n_rd_rsp_credit_;
        sc_event                                                sdp_n2mcif_rd_req_credit_update_event_;
        sc_event                                                mcif2sdp_n_rd_rsp_credit_update_event_;
        sc_mutex                                                sdp_n2mcif_rd_req_credit_mutex_;
        sc_mutex                                                mcif2sdp_n_rd_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *sdp_e2mcif_rd_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *mcif2sdp_e_rd_rsp_fifo_;
        int32_t                                                 sdp_e2mcif_rd_req_credit_;
        int32_t                                                 mcif2sdp_e_rd_rsp_credit_;
        sc_event                                                sdp_e2mcif_rd_req_credit_update_event_;
        sc_event                                                mcif2sdp_e_rd_rsp_credit_update_event_;
        sc_mutex                                                sdp_e2mcif_rd_req_credit_mutex_;
        sc_mutex                                                mcif2sdp_e_rd_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *cdma_dat2mcif_rd_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *mcif2cdma_dat_rd_rsp_fifo_;
        int32_t                                                 cdma_dat2mcif_rd_req_credit_;
        int32_t                                                 mcif2cdma_dat_rd_rsp_credit_;
        sc_event                                                cdma_dat2mcif_rd_req_credit_update_event_;
        sc_event                                                mcif2cdma_dat_rd_rsp_credit_update_event_;
        sc_mutex                                                cdma_dat2mcif_rd_req_credit_mutex_;
        sc_mutex                                                mcif2cdma_dat_rd_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *cdma_wt2mcif_rd_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_rd_transaction_t*>   *mcif2cdma_wt_rd_rsp_fifo_;
        int32_t                                                 cdma_wt2mcif_rd_req_credit_;
        int32_t                                                 mcif2cdma_wt_rd_rsp_credit_;
        sc_event                                                cdma_wt2mcif_rd_req_credit_update_event_;
        sc_event                                                mcif2cdma_wt_rd_rsp_credit_update_event_;
        sc_mutex                                                cdma_wt2mcif_rd_req_credit_mutex_;
        sc_mutex                                                mcif2cdma_wt_rd_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_wr_transaction_t*>   *bdma2mcif_wr_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_wr_transaction_t*>   *mcif2bdma_wr_rsp_fifo_;
        int32_t                                                 bdma2mcif_wr_req_credit_;
        int32_t                                                 mcif2bdma_wr_rsp_credit_;
        sc_event                                                bdma2mcif_wr_req_credit_update_event_;
        sc_event                                                mcif2bdma_wr_rsp_credit_update_event_;
        sc_mutex                                                bdma2mcif_wr_req_credit_mutex_;
        sc_mutex                                                mcif2bdma_wr_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_wr_transaction_t*>   *sdp2mcif_wr_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_wr_transaction_t*>   *mcif2sdp_wr_rsp_fifo_;
        int32_t                                                 sdp2mcif_wr_req_credit_;
        int32_t                                                 mcif2sdp_wr_rsp_credit_;
        sc_event                                                sdp2mcif_wr_req_credit_update_event_;
        sc_event                                                mcif2sdp_wr_rsp_credit_update_event_;
        sc_mutex                                                sdp2mcif_wr_req_credit_mutex_;
        sc_mutex                                                mcif2sdp_wr_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_wr_transaction_t*>   *pdp2mcif_wr_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_wr_transaction_t*>   *mcif2pdp_wr_rsp_fifo_;
        int32_t                                                 pdp2mcif_wr_req_credit_;
        int32_t                                                 mcif2pdp_wr_rsp_credit_;
        sc_event                                                pdp2mcif_wr_req_credit_update_event_;
        sc_event                                                mcif2pdp_wr_rsp_credit_update_event_;
        sc_mutex                                                pdp2mcif_wr_req_credit_mutex_;
        sc_mutex                                                mcif2pdp_wr_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_wr_transaction_t*>   *cdp2mcif_wr_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_wr_transaction_t*>   *mcif2cdp_wr_rsp_fifo_;
        int32_t                                                 cdp2mcif_wr_req_credit_;
        int32_t                                                 mcif2cdp_wr_rsp_credit_;
        sc_event                                                cdp2mcif_wr_req_credit_update_event_;
        sc_event                                                mcif2cdp_wr_rsp_credit_update_event_;
        sc_mutex                                                cdp2mcif_wr_req_credit_mutex_;
        sc_mutex                                                mcif2cdp_wr_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_monitor_dma_wr_transaction_t*>   *rbk2mcif_wr_req_fifo_;
        sc_core::sc_fifo      <nvdla_monitor_dma_wr_transaction_t*>   *mcif2rbk_wr_rsp_fifo_;
        int32_t                                                 rbk2mcif_wr_req_credit_;
        int32_t                                                 mcif2rbk_wr_rsp_credit_;
        sc_event                                                rbk2mcif_wr_req_credit_update_event_;
        sc_event                                                mcif2rbk_wr_rsp_credit_update_event_;
        sc_mutex                                                rbk2mcif_wr_req_credit_mutex_;
        sc_mutex                                                mcif2rbk_wr_rsp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_sc2mac_data_if_t*>     *sc2mac_dat_a_fifo_;
        int32_t                                         sc2mac_dat_a_credit_;
        sc_event                                        sc2mac_dat_a_credit_update_event_;
        sc_mutex                                        sc2mac_dat_a_credit_mutex_;

        sc_core::sc_fifo      <nvdla_sc2mac_data_if_t*>     *sc2mac_dat_b_fifo_;
        int32_t                                         sc2mac_dat_b_credit_;
        sc_event                                        sc2mac_dat_b_credit_update_event_;
        sc_mutex                                        sc2mac_dat_b_credit_mutex_;

        sc_core::sc_fifo      <nvdla_sc2mac_weight_if_t*>     *sc2mac_wt_a_fifo_;
        int32_t                                         sc2mac_wt_a_credit_;
        sc_event                                        sc2mac_wt_a_credit_update_event_;
        sc_mutex                                        sc2mac_wt_a_credit_mutex_;

        sc_core::sc_fifo      <nvdla_sc2mac_weight_if_t*>     *sc2mac_wt_b_fifo_;
        int32_t                                         sc2mac_wt_b_credit_;
        sc_event                                        sc2mac_wt_b_credit_update_event_;
        sc_mutex                                        sc2mac_wt_b_credit_mutex_;

        sc_core::sc_fifo      <nvdla_mac2accu_data_if_t*>     *mac_a2accu_fifo_;
        int32_t                                         mac_a2accu_credit_;
        sc_event                                        mac_a2accu_credit_update_event_;
        sc_mutex                                        mac_a2accu_credit_mutex_;

        sc_core::sc_fifo      <nvdla_mac2accu_data_if_t*>     *mac_b2accu_fifo_;
        int32_t                                         mac_b2accu_credit_;
        sc_event                                        mac_b2accu_credit_update_event_;
        sc_mutex                                        mac_b2accu_credit_mutex_;

        sc_core::sc_fifo      <nvdla_accu2pp_if_t*>     *cacc2sdp_fifo_;
        int32_t                                         cacc2sdp_credit_;
        sc_event                                        cacc2sdp_credit_update_event_;
        sc_mutex                                        cacc2sdp_credit_mutex_;

        sc_core::sc_fifo      <nvdla_sdp2pdp_t*>     *sdp2pdp_fifo_;
        int32_t                                         sdp2pdp_credit_;
        sc_event                                        sdp2pdp_credit_update_event_;
        sc_mutex                                        sdp2pdp_credit_mutex_;

        // sc_core::sc_fifo       <nvdla_monitor_dma_rd_transaction_t*>   *bdma2mcif_rd_req_fifo_;
        // sc_core::sc_fifo       <nvdla_monitor_dma_rd_transaction_t*>   *mcif2bdma_rd_rsp_fifo_;
        // sc_core::sc_fifo       <nvdla_monitor_dma_wr_transaction_t*>   *bdma2mcif_wr_req_fifo_;
        // sc_core::sc_fifo       <nvdla_monitor_dma_wr_transaction_t*>   *mcif2bdma_wr_rsp_fifo_;
        // sc_core::sc_fifo          <nvdla_sc2mac_data_if_t*>               *sc2mac_dat_a_fifo_;
        // sc_core::sc_fifo          <nvdla_sc2mac_weight_if_t*>             *sc2mac_wt_a_fifo_;
        // sc_core::sc_fifo          <nvdla_sc2mac_data_if_t*>               *sc2mac_dat_b_fifo_;
        // sc_core::sc_fifo          <nvdla_sc2mac_weight_if_t*>             *sc2mac_wt_b_fifo_;
        // sc_core::sc_fifo          <nvdla_mac2accu_data_if_t*>             *mac_a2accu_fifo_;
        // sc_core::sc_fifo          <nvdla_mac2accu_data_if_t*>             *mac_b2accu_fifo_;
        // sc_core::sc_fifo          <nvdla_accu2pp_if_t*>                   *cacc2sdp_fifo_;
        // sc_core::sc_fifo          <nvdla_sdp2pdp_t*>                      *sdp2pdp_fifo_;
        // uint16_t                                                    sc2mac_dat_a_credit_;
        // uint16_t                                                    sc2mac_wt_a_credit_;
        // uint16_t                                                    sc2mac_dat_b_credit_;
        // uint16_t                                                    sc2mac_wt_b_credit_;
        // uint16_t                                                    mac_a2accu_credit_;
        // uint16_t                                                    mac_b2accu_credit_;
        // uint16_t                                                    cacc2sdp_credit_;
        // uint16_t                                                    sdp2pdp_credit_;
        // sc_event                                                    sc2mac_dat_a_credit_update_event_;
        // sc_event                                                    sc2mac_wt_a_credit_update_event_;
        // sc_event                                                    sc2mac_dat_b_credit_update_event_;
        // sc_event                                                    sc2mac_wt_b_credit_update_event_;
        // sc_event                                                    mac_a2accu_credit_update_event_;
        // sc_event                                                    mac_b2accu_credit_update_event_;
        // sc_event                                                    cacc2sdp_credit_update_event_;
        // sc_event                                                    sdp2pdp_credit_update_event_;
        // sc_mutex                                                    sc2mac_dat_a_credit_mutex_;
        // sc_mutex                                                    sc2mac_wt_a_credit_mutex_;
        // sc_mutex                                                    sc2mac_dat_b_credit_mutex_;
        // sc_mutex                                                    sc2mac_wt_b_credit_mutex_;
        // sc_mutex                                                    mac_a2accu_credit_mutex_;
        // sc_mutex                                                    mac_b2accu_credit_mutex_;
        // sc_mutex                                                    cacc2sdp_credit_mutex_;
        // sc_mutex                                                    sdp2pdp_credit_mutex_;
        // sc_core::sc_fifo       <*>   *_fifo_;
        // Functions
        // #  Thread functions
        void DmaMonitorThread();
        void ConvCoreMonitorThread();
        void PostProcessingMonitorThread();
        // #  Methods for DMA write response


        void Cvif2BdmaWrResponseMethod();

        void Cvif2SdpWrResponseMethod();

        void Cvif2PdpWrResponseMethod();

        void Cvif2CdpWrResponseMethod();

        void Cvif2RbkWrResponseMethod();

        void Mcif2BdmaWrResponseMethod();

        void Mcif2SdpWrResponseMethod();

        void Mcif2PdpWrResponseMethod();

        void Mcif2CdpWrResponseMethod();

        void Mcif2RbkWrResponseMethod();

        // #  Functional functions
        void Reset();
};

SCSIM_NAMESPACE_END()

extern "C" scsim::cmod::NvdlaCoreInternalMonitor * NvdlaCoreInternalMonitorCon(sc_module_name module_name);

#endif

