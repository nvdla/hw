
//
// NvdlaCoreInternalMonitor.cpp
//

#include <algorithm>
#include <iomanip>
#include "NvdlaCoreInternalMonitor.h"
#include "math.h"

#include "log.h"

#define __STDC_FORMAT_MACROS
#include <inttypes.h>

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace std;
using namespace tlm;
using namespace sc_core;

#define get_array_len(array) (sizeof(array)/sizeof(array[0]))

NvdlaCoreInternalMonitor::NvdlaCoreInternalMonitor(const sc_module_name module_name ):
    sc_module(module_name),
    // Target socket initialization 
    // # DMA


    bdma2cvif_rd_req("bdma2cvif_rd_req"),
    cvif2bdma_rd_rsp("cvif2bdma_rd_rsp"),

    sdp2cvif_rd_req("sdp2cvif_rd_req"),
    cvif2sdp_rd_rsp("cvif2sdp_rd_rsp"),

    pdp2cvif_rd_req("pdp2cvif_rd_req"),
    cvif2pdp_rd_rsp("cvif2pdp_rd_rsp"),

    cdp2cvif_rd_req("cdp2cvif_rd_req"),
    cvif2cdp_rd_rsp("cvif2cdp_rd_rsp"),

    rbk2cvif_rd_req("rbk2cvif_rd_req"),
    cvif2rbk_rd_rsp("cvif2rbk_rd_rsp"),

    sdp_b2cvif_rd_req("sdp_b2cvif_rd_req"),
    cvif2sdp_b_rd_rsp("cvif2sdp_b_rd_rsp"),

    sdp_n2cvif_rd_req("sdp_n2cvif_rd_req"),
    cvif2sdp_n_rd_rsp("cvif2sdp_n_rd_rsp"),

    sdp_e2cvif_rd_req("sdp_e2cvif_rd_req"),
    cvif2sdp_e_rd_rsp("cvif2sdp_e_rd_rsp"),

    cdma_dat2cvif_rd_req("cdma_dat2cvif_rd_req"),
    cvif2cdma_dat_rd_rsp("cvif2cdma_dat_rd_rsp"),

    cdma_wt2cvif_rd_req("cdma_wt2cvif_rd_req"),
    cvif2cdma_wt_rd_rsp("cvif2cdma_wt_rd_rsp"),

    bdma2cvif_wr_req("bdma2cvif_wr_req"),

    sdp2cvif_wr_req("sdp2cvif_wr_req"),

    pdp2cvif_wr_req("pdp2cvif_wr_req"),

    cdp2cvif_wr_req("cdp2cvif_wr_req"),

    rbk2cvif_wr_req("rbk2cvif_wr_req"),

    bdma2mcif_rd_req("bdma2mcif_rd_req"),
    mcif2bdma_rd_rsp("mcif2bdma_rd_rsp"),

    sdp2mcif_rd_req("sdp2mcif_rd_req"),
    mcif2sdp_rd_rsp("mcif2sdp_rd_rsp"),

    pdp2mcif_rd_req("pdp2mcif_rd_req"),
    mcif2pdp_rd_rsp("mcif2pdp_rd_rsp"),

    cdp2mcif_rd_req("cdp2mcif_rd_req"),
    mcif2cdp_rd_rsp("mcif2cdp_rd_rsp"),

    rbk2mcif_rd_req("rbk2mcif_rd_req"),
    mcif2rbk_rd_rsp("mcif2rbk_rd_rsp"),

    sdp_b2mcif_rd_req("sdp_b2mcif_rd_req"),
    mcif2sdp_b_rd_rsp("mcif2sdp_b_rd_rsp"),

    sdp_n2mcif_rd_req("sdp_n2mcif_rd_req"),
    mcif2sdp_n_rd_rsp("mcif2sdp_n_rd_rsp"),

    sdp_e2mcif_rd_req("sdp_e2mcif_rd_req"),
    mcif2sdp_e_rd_rsp("mcif2sdp_e_rd_rsp"),

    cdma_dat2mcif_rd_req("cdma_dat2mcif_rd_req"),
    mcif2cdma_dat_rd_rsp("mcif2cdma_dat_rd_rsp"),

    cdma_wt2mcif_rd_req("cdma_wt2mcif_rd_req"),
    mcif2cdma_wt_rd_rsp("mcif2cdma_wt_rd_rsp"),

    bdma2mcif_wr_req("bdma2mcif_wr_req"),

    sdp2mcif_wr_req("sdp2mcif_wr_req"),

    pdp2mcif_wr_req("pdp2mcif_wr_req"),

    cdp2mcif_wr_req("cdp2mcif_wr_req"),

    rbk2mcif_wr_req("rbk2mcif_wr_req"),

    sc2mac_dat_a("sc2mac_dat_a"),

    sc2mac_dat_b("sc2mac_dat_b"),

    sc2mac_wt_a("sc2mac_wt_a"),

    sc2mac_wt_b("sc2mac_wt_b"),

    mac_a2accu("mac_a2accu"),

    mac_b2accu("mac_b2accu"),

    cacc2sdp("cacc2sdp"),

    sdp2pdp("sdp2pdp"),

    // // # Valid-only :      CSC-to-CMAC, CMAC-to-CACC
    // sc2mac_dat_a("sc2mac_dat_a"),
    // sc2mac_dat_b("sc2mac_dat_b"),
    // sc2mac_wt_a("sc2mac_wt_a"),
    // sc2mac_wt_b("sc2mac_wt_b"),
    // mac_a2accu("mac_a2accu"),
    // mac_b2accu("mac_b2accu"),
    // // # Valid-Ready:   CACC-to-SDP, SDP-to-PDP
    // cacc2sdp("cacc2sdp"),
    // sdp2pdp("sdp2pdp"),
    // Initiator socket initialization
    // # DMA
    dma_monitor_mc_credit("dma_monitor_mc_credit"),
    dma_monitor_cv_credit("dma_monitor_cv_credit"),
    dma_monitor_mc("dma_monitor_mc"),
    dma_monitor_cv("dma_monitor_cv"),
    // # Valid-only :   CSC-to-CMAC, CMAC-to-CACC
    convolution_core_monitor_initiator("convolution_core_monitor_initiator"),
    // # Valid-Ready:   CACC-to-SDP, SDP-to-PDP
    post_processing_monitor_initiator("post_processing_monitor_initiator"),
    cdma_wt_dma_arbiter_source_id_initiator("cdma_wt_dma_arbiter_source_id_initiator"),
    b_transport_delay_(SC_ZERO_TIME)
{
    // Register b_transport to target sockets
    // #DMA

    // # DMA

    this->bdma2cvif_rd_req.register_b_transport(this, &NvdlaCoreInternalMonitor::bdma2cvif_rd_req_b_transport);
    this->cvif2bdma_rd_rsp.register_b_transport(this, &NvdlaCoreInternalMonitor::cvif2bdma_rd_rsp_b_transport);

    this->sdp2cvif_rd_req.register_b_transport(this, &NvdlaCoreInternalMonitor::sdp2cvif_rd_req_b_transport);
    this->cvif2sdp_rd_rsp.register_b_transport(this, &NvdlaCoreInternalMonitor::cvif2sdp_rd_rsp_b_transport);

    this->pdp2cvif_rd_req.register_b_transport(this, &NvdlaCoreInternalMonitor::pdp2cvif_rd_req_b_transport);
    this->cvif2pdp_rd_rsp.register_b_transport(this, &NvdlaCoreInternalMonitor::cvif2pdp_rd_rsp_b_transport);

    this->cdp2cvif_rd_req.register_b_transport(this, &NvdlaCoreInternalMonitor::cdp2cvif_rd_req_b_transport);
    this->cvif2cdp_rd_rsp.register_b_transport(this, &NvdlaCoreInternalMonitor::cvif2cdp_rd_rsp_b_transport);

    this->rbk2cvif_rd_req.register_b_transport(this, &NvdlaCoreInternalMonitor::rbk2cvif_rd_req_b_transport);
    this->cvif2rbk_rd_rsp.register_b_transport(this, &NvdlaCoreInternalMonitor::cvif2rbk_rd_rsp_b_transport);

    this->sdp_b2cvif_rd_req.register_b_transport(this, &NvdlaCoreInternalMonitor::sdp_b2cvif_rd_req_b_transport);
    this->cvif2sdp_b_rd_rsp.register_b_transport(this, &NvdlaCoreInternalMonitor::cvif2sdp_b_rd_rsp_b_transport);

    this->sdp_n2cvif_rd_req.register_b_transport(this, &NvdlaCoreInternalMonitor::sdp_n2cvif_rd_req_b_transport);
    this->cvif2sdp_n_rd_rsp.register_b_transport(this, &NvdlaCoreInternalMonitor::cvif2sdp_n_rd_rsp_b_transport);

    this->sdp_e2cvif_rd_req.register_b_transport(this, &NvdlaCoreInternalMonitor::sdp_e2cvif_rd_req_b_transport);
    this->cvif2sdp_e_rd_rsp.register_b_transport(this, &NvdlaCoreInternalMonitor::cvif2sdp_e_rd_rsp_b_transport);

    this->cdma_dat2cvif_rd_req.register_b_transport(this, &NvdlaCoreInternalMonitor::cdma_dat2cvif_rd_req_b_transport);
    this->cvif2cdma_dat_rd_rsp.register_b_transport(this, &NvdlaCoreInternalMonitor::cvif2cdma_dat_rd_rsp_b_transport);

    this->cdma_wt2cvif_rd_req.register_b_transport(this, &NvdlaCoreInternalMonitor::cdma_wt2cvif_rd_req_b_transport);
    this->cvif2cdma_wt_rd_rsp.register_b_transport(this, &NvdlaCoreInternalMonitor::cvif2cdma_wt_rd_rsp_b_transport);

    this->bdma2cvif_wr_req.register_b_transport(this, &NvdlaCoreInternalMonitor::bdma2cvif_wr_req_b_transport);

    this->sdp2cvif_wr_req.register_b_transport(this, &NvdlaCoreInternalMonitor::sdp2cvif_wr_req_b_transport);

    this->pdp2cvif_wr_req.register_b_transport(this, &NvdlaCoreInternalMonitor::pdp2cvif_wr_req_b_transport);

    this->cdp2cvif_wr_req.register_b_transport(this, &NvdlaCoreInternalMonitor::cdp2cvif_wr_req_b_transport);

    this->rbk2cvif_wr_req.register_b_transport(this, &NvdlaCoreInternalMonitor::rbk2cvif_wr_req_b_transport);

    this->bdma2mcif_rd_req.register_b_transport(this, &NvdlaCoreInternalMonitor::bdma2mcif_rd_req_b_transport);
    this->mcif2bdma_rd_rsp.register_b_transport(this, &NvdlaCoreInternalMonitor::mcif2bdma_rd_rsp_b_transport);

    this->sdp2mcif_rd_req.register_b_transport(this, &NvdlaCoreInternalMonitor::sdp2mcif_rd_req_b_transport);
    this->mcif2sdp_rd_rsp.register_b_transport(this, &NvdlaCoreInternalMonitor::mcif2sdp_rd_rsp_b_transport);

    this->pdp2mcif_rd_req.register_b_transport(this, &NvdlaCoreInternalMonitor::pdp2mcif_rd_req_b_transport);
    this->mcif2pdp_rd_rsp.register_b_transport(this, &NvdlaCoreInternalMonitor::mcif2pdp_rd_rsp_b_transport);

    this->cdp2mcif_rd_req.register_b_transport(this, &NvdlaCoreInternalMonitor::cdp2mcif_rd_req_b_transport);
    this->mcif2cdp_rd_rsp.register_b_transport(this, &NvdlaCoreInternalMonitor::mcif2cdp_rd_rsp_b_transport);

    this->rbk2mcif_rd_req.register_b_transport(this, &NvdlaCoreInternalMonitor::rbk2mcif_rd_req_b_transport);
    this->mcif2rbk_rd_rsp.register_b_transport(this, &NvdlaCoreInternalMonitor::mcif2rbk_rd_rsp_b_transport);

    this->sdp_b2mcif_rd_req.register_b_transport(this, &NvdlaCoreInternalMonitor::sdp_b2mcif_rd_req_b_transport);
    this->mcif2sdp_b_rd_rsp.register_b_transport(this, &NvdlaCoreInternalMonitor::mcif2sdp_b_rd_rsp_b_transport);

    this->sdp_n2mcif_rd_req.register_b_transport(this, &NvdlaCoreInternalMonitor::sdp_n2mcif_rd_req_b_transport);
    this->mcif2sdp_n_rd_rsp.register_b_transport(this, &NvdlaCoreInternalMonitor::mcif2sdp_n_rd_rsp_b_transport);

    this->sdp_e2mcif_rd_req.register_b_transport(this, &NvdlaCoreInternalMonitor::sdp_e2mcif_rd_req_b_transport);
    this->mcif2sdp_e_rd_rsp.register_b_transport(this, &NvdlaCoreInternalMonitor::mcif2sdp_e_rd_rsp_b_transport);

    this->cdma_dat2mcif_rd_req.register_b_transport(this, &NvdlaCoreInternalMonitor::cdma_dat2mcif_rd_req_b_transport);
    this->mcif2cdma_dat_rd_rsp.register_b_transport(this, &NvdlaCoreInternalMonitor::mcif2cdma_dat_rd_rsp_b_transport);

    this->cdma_wt2mcif_rd_req.register_b_transport(this, &NvdlaCoreInternalMonitor::cdma_wt2mcif_rd_req_b_transport);
    this->mcif2cdma_wt_rd_rsp.register_b_transport(this, &NvdlaCoreInternalMonitor::mcif2cdma_wt_rd_rsp_b_transport);

    this->bdma2mcif_wr_req.register_b_transport(this, &NvdlaCoreInternalMonitor::bdma2mcif_wr_req_b_transport);

    this->sdp2mcif_wr_req.register_b_transport(this, &NvdlaCoreInternalMonitor::sdp2mcif_wr_req_b_transport);

    this->pdp2mcif_wr_req.register_b_transport(this, &NvdlaCoreInternalMonitor::pdp2mcif_wr_req_b_transport);

    this->cdp2mcif_wr_req.register_b_transport(this, &NvdlaCoreInternalMonitor::cdp2mcif_wr_req_b_transport);

    this->rbk2mcif_wr_req.register_b_transport(this, &NvdlaCoreInternalMonitor::rbk2mcif_wr_req_b_transport);

    // Target Socket (nvdla_sc2mac_data_if_t): sc2mac_dat_a
    this->sc2mac_dat_a.register_b_transport(this, &NvdlaCoreInternalMonitor::sc2mac_dat_a_b_transport);

    // Target Socket (nvdla_sc2mac_data_if_t): sc2mac_dat_b
    this->sc2mac_dat_b.register_b_transport(this, &NvdlaCoreInternalMonitor::sc2mac_dat_b_b_transport);

    // Target Socket (nvdla_sc2mac_weight_if_t): sc2mac_wt_a
    this->sc2mac_wt_a.register_b_transport(this, &NvdlaCoreInternalMonitor::sc2mac_wt_a_b_transport);

    // Target Socket (nvdla_sc2mac_weight_if_t): sc2mac_wt_b
    this->sc2mac_wt_b.register_b_transport(this, &NvdlaCoreInternalMonitor::sc2mac_wt_b_b_transport);

    // Target Socket (nvdla_mac2accu_data_if_t): mac_a2accu
    this->mac_a2accu.register_b_transport(this, &NvdlaCoreInternalMonitor::mac_a2accu_b_transport);

    // Target Socket (nvdla_mac2accu_data_if_t): mac_b2accu
    this->mac_b2accu.register_b_transport(this, &NvdlaCoreInternalMonitor::mac_b2accu_b_transport);

    // Target Socket (nvdla_accu2pp_if_t): cacc2sdp
    this->cacc2sdp.register_b_transport(this, &NvdlaCoreInternalMonitor::cacc2sdp_b_transport);

    // Target Socket (nvdla_sdp2pdp_t): sdp2pdp
    this->sdp2pdp.register_b_transport(this, &NvdlaCoreInternalMonitor::sdp2pdp_b_transport);


    // #Credit grant target
    this->dma_monitor_cv_credit.register_b_transport(this, &NvdlaCoreInternalMonitor::dma_monitor_cv_credit_b_transport);
    this->dma_monitor_mc_credit.register_b_transport(this, &NvdlaCoreInternalMonitor::dma_monitor_mc_credit_b_transport);
    this->convolution_core_monitor_credit.register_b_transport(this, &NvdlaCoreInternalMonitor::convolution_core_monitor_credit_b_transport);
    this->post_processing_monitor_credit.register_b_transport(this, &NvdlaCoreInternalMonitor::post_processing_monitor_credit_b_transport);
//     // # Convolution core, valid-only
//     // Target Socket (unrecognized protocol: nvdla_sc2mac_data_if_t): sc2mac_dat
//     this->sc2mac_dat_a.register_b_transport(this, &NvdlaCoreInternalMonitor::sc2mac_dat_a_b_transport);
//     this->sc2mac_dat_b.register_b_transport(this, &NvdlaCoreInternalMonitor::sc2mac_dat_b_b_transport);
// 
//     // Target Socket (unrecognized protocol: nvdla_sc2mac_weight_if_t): sc2mac_wt
//     this->sc2mac_wt_a.register_b_transport(this, &NvdlaCoreInternalMonitor::sc2mac_wt_a_b_transport);
//     this->sc2mac_wt_b.register_b_transport(this, &NvdlaCoreInternalMonitor::sc2mac_wt_b_b_transport);
// 
//     // Target Socket (unrecognized protocol: nvdla_mac2accu_data_if_t): mac_a2accu
//     this->mac_a2accu.register_b_transport(this, &NvdlaCoreInternalMonitor::mac_a2accu_b_transport);
// 
//     // Target Socket (unrecognized protocol: nvdla_mac2accu_data_if_t): mac_b2accu
//     this->mac_b2accu.register_b_transport(this, &NvdlaCoreInternalMonitor::mac_b2accu_b_transport);
// 
//     // # Post processing, valid-ready
//     // Target Socket (unrecognized protocol: nvdla_accu2pp_if_t): cacc2sdp
//     this->cacc2sdp.register_b_transport(this, &NvdlaCoreInternalMonitor::cacc2sdp_b_transport);
// 
//     // Target Socket (unrecognized protocol: nvdla_sdp2pdp_t): sdp2pdp
//     this->sdp2pdp.register_b_transport(this, &NvdlaCoreInternalMonitor::sdp2pdp_b_transport);

    // Memory allocation


    bdma2cvif_rd_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cvif2bdma_rd_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    bdma2cvif_rd_req_credit_= 0;
    cvif2bdma_rd_rsp_credit_= 0;

    sdp2cvif_rd_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cvif2sdp_rd_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    sdp2cvif_rd_req_credit_= 0;
    cvif2sdp_rd_rsp_credit_= 0;

    pdp2cvif_rd_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cvif2pdp_rd_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    pdp2cvif_rd_req_credit_= 0;
    cvif2pdp_rd_rsp_credit_= 0;

    cdp2cvif_rd_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cvif2cdp_rd_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cdp2cvif_rd_req_credit_= 0;
    cvif2cdp_rd_rsp_credit_= 0;

    rbk2cvif_rd_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cvif2rbk_rd_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    rbk2cvif_rd_req_credit_= 0;
    cvif2rbk_rd_rsp_credit_= 0;

    sdp_b2cvif_rd_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cvif2sdp_b_rd_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    sdp_b2cvif_rd_req_credit_= 0;
    cvif2sdp_b_rd_rsp_credit_= 0;

    sdp_n2cvif_rd_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cvif2sdp_n_rd_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    sdp_n2cvif_rd_req_credit_= 0;
    cvif2sdp_n_rd_rsp_credit_= 0;

    sdp_e2cvif_rd_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cvif2sdp_e_rd_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    sdp_e2cvif_rd_req_credit_= 0;
    cvif2sdp_e_rd_rsp_credit_= 0;

    cdma_dat2cvif_rd_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cvif2cdma_dat_rd_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cdma_dat2cvif_rd_req_credit_= 0;
    cvif2cdma_dat_rd_rsp_credit_= 0;

    cdma_wt2cvif_rd_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cvif2cdma_wt_rd_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cdma_wt2cvif_rd_req_credit_= 0;
    cvif2cdma_wt_rd_rsp_credit_= 0;

    bdma2cvif_wr_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_wr_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cvif2bdma_wr_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_wr_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    bdma2cvif_wr_req_credit_= 0;
    cvif2bdma_wr_rsp_credit_= 0;

    sdp2cvif_wr_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_wr_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cvif2sdp_wr_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_wr_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    sdp2cvif_wr_req_credit_= 0;
    cvif2sdp_wr_rsp_credit_= 0;

    pdp2cvif_wr_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_wr_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cvif2pdp_wr_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_wr_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    pdp2cvif_wr_req_credit_= 0;
    cvif2pdp_wr_rsp_credit_= 0;

    cdp2cvif_wr_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_wr_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cvif2cdp_wr_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_wr_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cdp2cvif_wr_req_credit_= 0;
    cvif2cdp_wr_rsp_credit_= 0;

    rbk2cvif_wr_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_wr_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cvif2rbk_wr_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_wr_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    rbk2cvif_wr_req_credit_= 0;
    cvif2rbk_wr_rsp_credit_= 0;

    bdma2mcif_rd_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    mcif2bdma_rd_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    bdma2mcif_rd_req_credit_= 0;
    mcif2bdma_rd_rsp_credit_= 0;

    sdp2mcif_rd_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    mcif2sdp_rd_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    sdp2mcif_rd_req_credit_= 0;
    mcif2sdp_rd_rsp_credit_= 0;

    pdp2mcif_rd_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    mcif2pdp_rd_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    pdp2mcif_rd_req_credit_= 0;
    mcif2pdp_rd_rsp_credit_= 0;

    cdp2mcif_rd_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    mcif2cdp_rd_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cdp2mcif_rd_req_credit_= 0;
    mcif2cdp_rd_rsp_credit_= 0;

    rbk2mcif_rd_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    mcif2rbk_rd_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    rbk2mcif_rd_req_credit_= 0;
    mcif2rbk_rd_rsp_credit_= 0;

    sdp_b2mcif_rd_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    mcif2sdp_b_rd_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    sdp_b2mcif_rd_req_credit_= 0;
    mcif2sdp_b_rd_rsp_credit_= 0;

    sdp_n2mcif_rd_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    mcif2sdp_n_rd_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    sdp_n2mcif_rd_req_credit_= 0;
    mcif2sdp_n_rd_rsp_credit_= 0;

    sdp_e2mcif_rd_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    mcif2sdp_e_rd_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    sdp_e2mcif_rd_req_credit_= 0;
    mcif2sdp_e_rd_rsp_credit_= 0;

    cdma_dat2mcif_rd_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    mcif2cdma_dat_rd_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cdma_dat2mcif_rd_req_credit_= 0;
    mcif2cdma_dat_rd_rsp_credit_= 0;

    cdma_wt2mcif_rd_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    mcif2cdma_wt_rd_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_rd_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cdma_wt2mcif_rd_req_credit_= 0;
    mcif2cdma_wt_rd_rsp_credit_= 0;

    bdma2mcif_wr_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_wr_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    mcif2bdma_wr_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_wr_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    bdma2mcif_wr_req_credit_= 0;
    mcif2bdma_wr_rsp_credit_= 0;

    sdp2mcif_wr_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_wr_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    mcif2sdp_wr_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_wr_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    sdp2mcif_wr_req_credit_= 0;
    mcif2sdp_wr_rsp_credit_= 0;

    pdp2mcif_wr_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_wr_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    mcif2pdp_wr_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_wr_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    pdp2mcif_wr_req_credit_= 0;
    mcif2pdp_wr_rsp_credit_= 0;

    cdp2mcif_wr_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_wr_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    mcif2cdp_wr_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_wr_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    cdp2mcif_wr_req_credit_= 0;
    mcif2cdp_wr_rsp_credit_= 0;

    rbk2mcif_wr_req_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_wr_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    mcif2rbk_wr_rsp_fifo_  = new sc_core::sc_fifo<nvdla_monitor_dma_wr_transaction_t*> (DMA_REQ_FIFO_DEPTH);
    rbk2mcif_wr_req_credit_= 0;
    mcif2rbk_wr_rsp_credit_= 0;

    sc2mac_dat_a_fifo_              = new sc_core::sc_fifo      <nvdla_sc2mac_data_if_t*> (1);
    sc2mac_dat_a_credit_            = 0;

    sc2mac_dat_b_fifo_              = new sc_core::sc_fifo      <nvdla_sc2mac_data_if_t*> (1);
    sc2mac_dat_b_credit_            = 0;

    sc2mac_wt_a_fifo_              = new sc_core::sc_fifo      <nvdla_sc2mac_weight_if_t*> (1);
    sc2mac_wt_a_credit_            = 0;

    sc2mac_wt_b_fifo_              = new sc_core::sc_fifo      <nvdla_sc2mac_weight_if_t*> (1);
    sc2mac_wt_b_credit_            = 0;

    mac_a2accu_fifo_              = new sc_core::sc_fifo      <nvdla_mac2accu_data_if_t*> (1);
    mac_a2accu_credit_            = 0;

    mac_b2accu_fifo_              = new sc_core::sc_fifo      <nvdla_mac2accu_data_if_t*> (1);
    mac_b2accu_credit_            = 0;

    cacc2sdp_fifo_              = new sc_core::sc_fifo      <nvdla_accu2pp_if_t*> (1);
    cacc2sdp_credit_            = 0;

    sdp2pdp_fifo_              = new sc_core::sc_fifo      <nvdla_sdp2pdp_t*> (1);
    sdp2pdp_credit_            = 0;

    // sc2mac_dat_a_fifo_  = new sc_core::sc_fifo          <nvdla_sc2mac_data_if_t*>     (COMMON_FIFO_DEPTH);
    // sc2mac_wt_a_fifo_   = new sc_core::sc_fifo          <nvdla_sc2mac_weight_if_t*>   (COMMON_FIFO_DEPTH);
    // sc2mac_dat_b_fifo_  = new sc_core::sc_fifo          <nvdla_sc2mac_data_if_t*>     (COMMON_FIFO_DEPTH);
    // sc2mac_wt_b_fifo_   = new sc_core::sc_fifo          <nvdla_sc2mac_weight_if_t*>   (COMMON_FIFO_DEPTH);
    // mac_a2accu_fifo_    = new sc_core::sc_fifo          <nvdla_mac2accu_data_if_t*>   (COMMON_FIFO_DEPTH);
    // mac_b2accu_fifo_    = new sc_core::sc_fifo          <nvdla_mac2accu_data_if_t*>   (COMMON_FIFO_DEPTH);
    // cacc2sdp_fifo_      = new sc_core::sc_fifo          <nvdla_accu2pp_if_t*>         (COMMON_FIFO_DEPTH);
    // sdp2pdp_fifo_       = new sc_core::sc_fifo          <nvdla_sdp2pdp_t*>            (COMMON_FIFO_DEPTH);
    // sc2mac_dat_a_credit_    =0;
    // sc2mac_wt_a_credit_     =0;
    // sc2mac_dat_b_credit_    =0;
    // sc2mac_wt_b_credit_     =0;
    // mac_a2accu_credit_      =0;
    // mac_b2accu_credit_      =0;
    // cacc2sdp_credit_        =0;
    // sdp2pdp_credit_         =0;
    // = new sc_core::sc_fifo          <*> (COMMON_FIFO_DEPTH);
    
    // Reset
    Reset();

    // THREAD
    SC_THREAD(DmaMonitorThread)
    sensitive 
        << bdma2cvif_rd_req_fifo_->data_written_event() << cvif2bdma_rd_rsp_fifo_->data_written_event() 
        << sdp2cvif_rd_req_fifo_->data_written_event() << cvif2sdp_rd_rsp_fifo_->data_written_event() 
        << pdp2cvif_rd_req_fifo_->data_written_event() << cvif2pdp_rd_rsp_fifo_->data_written_event() 
        << cdp2cvif_rd_req_fifo_->data_written_event() << cvif2cdp_rd_rsp_fifo_->data_written_event() 
        << rbk2cvif_rd_req_fifo_->data_written_event() << cvif2rbk_rd_rsp_fifo_->data_written_event() 
        << sdp_b2cvif_rd_req_fifo_->data_written_event() << cvif2sdp_b_rd_rsp_fifo_->data_written_event() 
        << sdp_n2cvif_rd_req_fifo_->data_written_event() << cvif2sdp_n_rd_rsp_fifo_->data_written_event() 
        << sdp_e2cvif_rd_req_fifo_->data_written_event() << cvif2sdp_e_rd_rsp_fifo_->data_written_event() 
        << cdma_dat2cvif_rd_req_fifo_->data_written_event() << cvif2cdma_dat_rd_rsp_fifo_->data_written_event() 
        << cdma_wt2cvif_rd_req_fifo_->data_written_event() << cvif2cdma_wt_rd_rsp_fifo_->data_written_event() 
        << bdma2cvif_wr_req_fifo_->data_written_event() << cvif2bdma_wr_rsp_fifo_->data_written_event() 
        << sdp2cvif_wr_req_fifo_->data_written_event() << cvif2sdp_wr_rsp_fifo_->data_written_event() 
        << pdp2cvif_wr_req_fifo_->data_written_event() << cvif2pdp_wr_rsp_fifo_->data_written_event() 
        << cdp2cvif_wr_req_fifo_->data_written_event() << cvif2cdp_wr_rsp_fifo_->data_written_event() 
        << rbk2cvif_wr_req_fifo_->data_written_event() << cvif2rbk_wr_rsp_fifo_->data_written_event() 
        << bdma2mcif_rd_req_fifo_->data_written_event() << mcif2bdma_rd_rsp_fifo_->data_written_event() 
        << sdp2mcif_rd_req_fifo_->data_written_event() << mcif2sdp_rd_rsp_fifo_->data_written_event() 
        << pdp2mcif_rd_req_fifo_->data_written_event() << mcif2pdp_rd_rsp_fifo_->data_written_event() 
        << cdp2mcif_rd_req_fifo_->data_written_event() << mcif2cdp_rd_rsp_fifo_->data_written_event() 
        << rbk2mcif_rd_req_fifo_->data_written_event() << mcif2rbk_rd_rsp_fifo_->data_written_event() 
        << sdp_b2mcif_rd_req_fifo_->data_written_event() << mcif2sdp_b_rd_rsp_fifo_->data_written_event() 
        << sdp_n2mcif_rd_req_fifo_->data_written_event() << mcif2sdp_n_rd_rsp_fifo_->data_written_event() 
        << sdp_e2mcif_rd_req_fifo_->data_written_event() << mcif2sdp_e_rd_rsp_fifo_->data_written_event() 
        << cdma_dat2mcif_rd_req_fifo_->data_written_event() << mcif2cdma_dat_rd_rsp_fifo_->data_written_event() 
        << cdma_wt2mcif_rd_req_fifo_->data_written_event() << mcif2cdma_wt_rd_rsp_fifo_->data_written_event() 
        << bdma2mcif_wr_req_fifo_->data_written_event() << mcif2bdma_wr_rsp_fifo_->data_written_event() 
        << sdp2mcif_wr_req_fifo_->data_written_event() << mcif2sdp_wr_rsp_fifo_->data_written_event() 
        << pdp2mcif_wr_req_fifo_->data_written_event() << mcif2pdp_wr_rsp_fifo_->data_written_event() 
        << cdp2mcif_wr_req_fifo_->data_written_event() << mcif2cdp_wr_rsp_fifo_->data_written_event() 
        << rbk2mcif_wr_req_fifo_->data_written_event() << mcif2rbk_wr_rsp_fifo_->data_written_event() ;

    SC_THREAD(ConvCoreMonitorThread)
    sensitive << sc2mac_dat_a_fifo_->data_written_event() << sc2mac_wt_a_fifo_->data_written_event() << mac_a2accu_fifo_->data_written_event();
    sensitive << sc2mac_dat_b_fifo_->data_written_event() << sc2mac_wt_b_fifo_->data_written_event() << mac_b2accu_fifo_->data_written_event();
    SC_THREAD(PostProcessingMonitorThread)
    sensitive << cacc2sdp_fifo_->data_written_event() << sdp2pdp_fifo_->data_written_event();
    // SC_THREAD()
    // sensitive << ->data_written_event() << ->data_written_event() << ->data_written_event();

    // SC_METHOD

    SC_METHOD (Cvif2BdmaWrResponseMethod)
    sensitive  << cvif2bdma_wr_rsp;

    SC_METHOD (Cvif2SdpWrResponseMethod)
    sensitive  << cvif2sdp_wr_rsp;

    SC_METHOD (Cvif2PdpWrResponseMethod)
    sensitive  << cvif2pdp_wr_rsp;

    SC_METHOD (Cvif2CdpWrResponseMethod)
    sensitive  << cvif2cdp_wr_rsp;

    SC_METHOD (Cvif2RbkWrResponseMethod)
    sensitive  << cvif2rbk_wr_rsp;

    SC_METHOD (Mcif2BdmaWrResponseMethod)
    sensitive  << mcif2bdma_wr_rsp;

    SC_METHOD (Mcif2SdpWrResponseMethod)
    sensitive  << mcif2sdp_wr_rsp;

    SC_METHOD (Mcif2PdpWrResponseMethod)
    sensitive  << mcif2pdp_wr_rsp;

    SC_METHOD (Mcif2CdpWrResponseMethod)
    sensitive  << mcif2cdp_wr_rsp;

    SC_METHOD (Mcif2RbkWrResponseMethod)
    sensitive  << mcif2rbk_wr_rsp;

    // SC_METHOD()
}

NvdlaCoreInternalMonitor::~NvdlaCoreInternalMonitor() {


    if (bdma2cvif_rd_req_fifo_) delete bdma2cvif_rd_req_fifo_;
    if (cvif2bdma_rd_rsp_fifo_) delete cvif2bdma_rd_rsp_fifo_;

    if (sdp2cvif_rd_req_fifo_) delete sdp2cvif_rd_req_fifo_;
    if (cvif2sdp_rd_rsp_fifo_) delete cvif2sdp_rd_rsp_fifo_;

    if (pdp2cvif_rd_req_fifo_) delete pdp2cvif_rd_req_fifo_;
    if (cvif2pdp_rd_rsp_fifo_) delete cvif2pdp_rd_rsp_fifo_;

    if (cdp2cvif_rd_req_fifo_) delete cdp2cvif_rd_req_fifo_;
    if (cvif2cdp_rd_rsp_fifo_) delete cvif2cdp_rd_rsp_fifo_;

    if (rbk2cvif_rd_req_fifo_) delete rbk2cvif_rd_req_fifo_;
    if (cvif2rbk_rd_rsp_fifo_) delete cvif2rbk_rd_rsp_fifo_;

    if (sdp_b2cvif_rd_req_fifo_) delete sdp_b2cvif_rd_req_fifo_;
    if (cvif2sdp_b_rd_rsp_fifo_) delete cvif2sdp_b_rd_rsp_fifo_;

    if (sdp_n2cvif_rd_req_fifo_) delete sdp_n2cvif_rd_req_fifo_;
    if (cvif2sdp_n_rd_rsp_fifo_) delete cvif2sdp_n_rd_rsp_fifo_;

    if (sdp_e2cvif_rd_req_fifo_) delete sdp_e2cvif_rd_req_fifo_;
    if (cvif2sdp_e_rd_rsp_fifo_) delete cvif2sdp_e_rd_rsp_fifo_;

    if (cdma_dat2cvif_rd_req_fifo_) delete cdma_dat2cvif_rd_req_fifo_;
    if (cvif2cdma_dat_rd_rsp_fifo_) delete cvif2cdma_dat_rd_rsp_fifo_;

    if (cdma_wt2cvif_rd_req_fifo_) delete cdma_wt2cvif_rd_req_fifo_;
    if (cvif2cdma_wt_rd_rsp_fifo_) delete cvif2cdma_wt_rd_rsp_fifo_;

    if (bdma2cvif_wr_req_fifo_) delete bdma2cvif_wr_req_fifo_;
    if (cvif2bdma_wr_rsp_fifo_) delete cvif2bdma_wr_rsp_fifo_;

    if (sdp2cvif_wr_req_fifo_) delete sdp2cvif_wr_req_fifo_;
    if (cvif2sdp_wr_rsp_fifo_) delete cvif2sdp_wr_rsp_fifo_;

    if (pdp2cvif_wr_req_fifo_) delete pdp2cvif_wr_req_fifo_;
    if (cvif2pdp_wr_rsp_fifo_) delete cvif2pdp_wr_rsp_fifo_;

    if (cdp2cvif_wr_req_fifo_) delete cdp2cvif_wr_req_fifo_;
    if (cvif2cdp_wr_rsp_fifo_) delete cvif2cdp_wr_rsp_fifo_;

    if (rbk2cvif_wr_req_fifo_) delete rbk2cvif_wr_req_fifo_;
    if (cvif2rbk_wr_rsp_fifo_) delete cvif2rbk_wr_rsp_fifo_;

    if (bdma2mcif_rd_req_fifo_) delete bdma2mcif_rd_req_fifo_;
    if (mcif2bdma_rd_rsp_fifo_) delete mcif2bdma_rd_rsp_fifo_;

    if (sdp2mcif_rd_req_fifo_) delete sdp2mcif_rd_req_fifo_;
    if (mcif2sdp_rd_rsp_fifo_) delete mcif2sdp_rd_rsp_fifo_;

    if (pdp2mcif_rd_req_fifo_) delete pdp2mcif_rd_req_fifo_;
    if (mcif2pdp_rd_rsp_fifo_) delete mcif2pdp_rd_rsp_fifo_;

    if (cdp2mcif_rd_req_fifo_) delete cdp2mcif_rd_req_fifo_;
    if (mcif2cdp_rd_rsp_fifo_) delete mcif2cdp_rd_rsp_fifo_;

    if (rbk2mcif_rd_req_fifo_) delete rbk2mcif_rd_req_fifo_;
    if (mcif2rbk_rd_rsp_fifo_) delete mcif2rbk_rd_rsp_fifo_;

    if (sdp_b2mcif_rd_req_fifo_) delete sdp_b2mcif_rd_req_fifo_;
    if (mcif2sdp_b_rd_rsp_fifo_) delete mcif2sdp_b_rd_rsp_fifo_;

    if (sdp_n2mcif_rd_req_fifo_) delete sdp_n2mcif_rd_req_fifo_;
    if (mcif2sdp_n_rd_rsp_fifo_) delete mcif2sdp_n_rd_rsp_fifo_;

    if (sdp_e2mcif_rd_req_fifo_) delete sdp_e2mcif_rd_req_fifo_;
    if (mcif2sdp_e_rd_rsp_fifo_) delete mcif2sdp_e_rd_rsp_fifo_;

    if (cdma_dat2mcif_rd_req_fifo_) delete cdma_dat2mcif_rd_req_fifo_;
    if (mcif2cdma_dat_rd_rsp_fifo_) delete mcif2cdma_dat_rd_rsp_fifo_;

    if (cdma_wt2mcif_rd_req_fifo_) delete cdma_wt2mcif_rd_req_fifo_;
    if (mcif2cdma_wt_rd_rsp_fifo_) delete mcif2cdma_wt_rd_rsp_fifo_;

    if (bdma2mcif_wr_req_fifo_) delete bdma2mcif_wr_req_fifo_;
    if (mcif2bdma_wr_rsp_fifo_) delete mcif2bdma_wr_rsp_fifo_;

    if (sdp2mcif_wr_req_fifo_) delete sdp2mcif_wr_req_fifo_;
    if (mcif2sdp_wr_rsp_fifo_) delete mcif2sdp_wr_rsp_fifo_;

    if (pdp2mcif_wr_req_fifo_) delete pdp2mcif_wr_req_fifo_;
    if (mcif2pdp_wr_rsp_fifo_) delete mcif2pdp_wr_rsp_fifo_;

    if (cdp2mcif_wr_req_fifo_) delete cdp2mcif_wr_req_fifo_;
    if (mcif2cdp_wr_rsp_fifo_) delete mcif2cdp_wr_rsp_fifo_;

    if (rbk2mcif_wr_req_fifo_) delete rbk2mcif_wr_req_fifo_;
    if (mcif2rbk_wr_rsp_fifo_) delete mcif2rbk_wr_rsp_fifo_;

    if (sc2mac_dat_a_fifo_) delete sc2mac_dat_a_fifo_;

    if (sc2mac_dat_b_fifo_) delete sc2mac_dat_b_fifo_;

    if (sc2mac_wt_a_fifo_) delete sc2mac_wt_a_fifo_;

    if (sc2mac_wt_b_fifo_) delete sc2mac_wt_b_fifo_;

    if (mac_a2accu_fifo_) delete mac_a2accu_fifo_;

    if (mac_b2accu_fifo_) delete mac_b2accu_fifo_;

    if (cacc2sdp_fifo_) delete cacc2sdp_fifo_;

    if (sdp2pdp_fifo_) delete sdp2pdp_fifo_;

    // if(  )  delete ;
}


void NvdlaCoreInternalMonitor::dma_monitor_cv_credit_b_transport(int ID, tlm::tlm_generic_payload& gp, sc_time& delay) {{
    uint8_t *data_ptr = gp.get_data_ptr();
    credit_structure *credit_ptr = (credit_structure*) gp.get_data_ptr();
    cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_cv_credit_b_transport: got a credit:\n"));
    cslDebug((50, "    txn_id:  0x%x\n"    , credit_ptr->txn_id));
    cslDebug((50, "    is_read: 0x%x\n"   , credit_ptr->is_read));
    cslDebug((50, "    is_req:  0x%x\n"    , credit_ptr->is_req));
    cslDebug((50, "    credit:  0x%x\n"    , credit_ptr->credit));
    cslDebug((50, "    sub_id:  0x%x\n"    , credit_ptr->sub_id));
    for (uint32_t i; i < gp.get_data_length(); i ++) {{
        cslDebug((70, "    data_ptr[0x%x]:0x%x", i, uint32_t(data_ptr[i]) ));
    }}
    cslDebug((70, "\n"));
    if (credit_ptr->is_read == 0) {{
        switch (credit_ptr->txn_id) {{

            case CV_BDMA_WRITE_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_cv_credit_b_transport: got a credit to BDMA_WRITE:\n"));
                if (credit_ptr->is_req == 1) {
                    bdma2cvif_wr_req_credit_mutex_.lock();
                    bdma2cvif_wr_req_credit_ += credit_ptr->credit;
                    bdma2cvif_wr_req_credit_mutex_.unlock();
                    bdma2cvif_wr_req_credit_update_event_.notify();
                } else {
                    // cvif2bdma_wr_rsp_credit_mutex_.lock();
                    // cvif2bdma_wr_rsp_credit_ += credit_ptr->credit;
                    // cvif2bdma_wr_rsp_credit_mutex_.unlock();
                    // cvif2bdma_wr_rsp_credit_update_event_.notify();
                }
                break;

            case CV_SDP_WRITE_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_cv_credit_b_transport: got a credit to SDP_WRITE:\n"));
                if (credit_ptr->is_req == 1) {
                    sdp2cvif_wr_req_credit_mutex_.lock();
                    sdp2cvif_wr_req_credit_ += credit_ptr->credit;
                    sdp2cvif_wr_req_credit_mutex_.unlock();
                    sdp2cvif_wr_req_credit_update_event_.notify();
                } else {
                    // cvif2sdp_wr_rsp_credit_mutex_.lock();
                    // cvif2sdp_wr_rsp_credit_ += credit_ptr->credit;
                    // cvif2sdp_wr_rsp_credit_mutex_.unlock();
                    // cvif2sdp_wr_rsp_credit_update_event_.notify();
                }
                break;

            case CV_PDP_WRITE_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_cv_credit_b_transport: got a credit to PDP_WRITE:\n"));
                if (credit_ptr->is_req == 1) {
                    pdp2cvif_wr_req_credit_mutex_.lock();
                    pdp2cvif_wr_req_credit_ += credit_ptr->credit;
                    pdp2cvif_wr_req_credit_mutex_.unlock();
                    pdp2cvif_wr_req_credit_update_event_.notify();
                } else {
                    // cvif2pdp_wr_rsp_credit_mutex_.lock();
                    // cvif2pdp_wr_rsp_credit_ += credit_ptr->credit;
                    // cvif2pdp_wr_rsp_credit_mutex_.unlock();
                    // cvif2pdp_wr_rsp_credit_update_event_.notify();
                }
                break;

            case CV_CDP_WRITE_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_cv_credit_b_transport: got a credit to CDP_WRITE:\n"));
                if (credit_ptr->is_req == 1) {
                    cdp2cvif_wr_req_credit_mutex_.lock();
                    cdp2cvif_wr_req_credit_ += credit_ptr->credit;
                    cdp2cvif_wr_req_credit_mutex_.unlock();
                    cdp2cvif_wr_req_credit_update_event_.notify();
                } else {
                    // cvif2cdp_wr_rsp_credit_mutex_.lock();
                    // cvif2cdp_wr_rsp_credit_ += credit_ptr->credit;
                    // cvif2cdp_wr_rsp_credit_mutex_.unlock();
                    // cvif2cdp_wr_rsp_credit_update_event_.notify();
                }
                break;

            case CV_RBK_WRITE_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_cv_credit_b_transport: got a credit to RBK_WRITE:\n"));
                if (credit_ptr->is_req == 1) {
                    rbk2cvif_wr_req_credit_mutex_.lock();
                    rbk2cvif_wr_req_credit_ += credit_ptr->credit;
                    rbk2cvif_wr_req_credit_mutex_.unlock();
                    rbk2cvif_wr_req_credit_update_event_.notify();
                } else {
                    // cvif2rbk_wr_rsp_credit_mutex_.lock();
                    // cvif2rbk_wr_rsp_credit_ += credit_ptr->credit;
                    // cvif2rbk_wr_rsp_credit_mutex_.unlock();
                    // cvif2rbk_wr_rsp_credit_update_event_.notify();
                }
                break;

            default: break;
        }}
    }} else {{
        switch (credit_ptr->txn_id) {{

            case CV_BDMA_READ_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_cv_credit_b_transport: got a credit to BDMA_READ:\n"));
                if (credit_ptr->is_req == 1) {
                    bdma2cvif_rd_req_credit_mutex_.lock();
                    bdma2cvif_rd_req_credit_ += credit_ptr->credit;
                    if ( (CV_BDMA_READ_AXI_ID == CV_CDMA_WT_READ_AXI_ID) && (credit_ptr->credit > 0) ) {
                        cdma_wt_dma_arbiter_source_id_initiator_b_transport(credit_ptr->sub_id, b_transport_delay_);
                    }
                    bdma2cvif_rd_req_credit_mutex_.unlock();
                    bdma2cvif_rd_req_credit_update_event_.notify();
                } else {
                    // cvif2bdma_rd_rsp_credit_mutex_.lock();
                    // cvif2bdma_rd_rsp_credit_ += credit_ptr->credit;
                    // cvif2bdma_rd_rsp_credit_mutex_.unlock();
                    // cvif2bdma_rd_rsp_credit_update_event_.notify();
                }
                break;

            case CV_SDP_READ_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_cv_credit_b_transport: got a credit to SDP_READ:\n"));
                if (credit_ptr->is_req == 1) {
                    sdp2cvif_rd_req_credit_mutex_.lock();
                    sdp2cvif_rd_req_credit_ += credit_ptr->credit;
                    if ( (CV_SDP_READ_AXI_ID == CV_CDMA_WT_READ_AXI_ID) && (credit_ptr->credit > 0) ) {
                        cdma_wt_dma_arbiter_source_id_initiator_b_transport(credit_ptr->sub_id, b_transport_delay_);
                    }
                    sdp2cvif_rd_req_credit_mutex_.unlock();
                    sdp2cvif_rd_req_credit_update_event_.notify();
                } else {
                    // cvif2sdp_rd_rsp_credit_mutex_.lock();
                    // cvif2sdp_rd_rsp_credit_ += credit_ptr->credit;
                    // cvif2sdp_rd_rsp_credit_mutex_.unlock();
                    // cvif2sdp_rd_rsp_credit_update_event_.notify();
                }
                break;

            case CV_PDP_READ_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_cv_credit_b_transport: got a credit to PDP_READ:\n"));
                if (credit_ptr->is_req == 1) {
                    pdp2cvif_rd_req_credit_mutex_.lock();
                    pdp2cvif_rd_req_credit_ += credit_ptr->credit;
                    if ( (CV_PDP_READ_AXI_ID == CV_CDMA_WT_READ_AXI_ID) && (credit_ptr->credit > 0) ) {
                        cdma_wt_dma_arbiter_source_id_initiator_b_transport(credit_ptr->sub_id, b_transport_delay_);
                    }
                    pdp2cvif_rd_req_credit_mutex_.unlock();
                    pdp2cvif_rd_req_credit_update_event_.notify();
                } else {
                    // cvif2pdp_rd_rsp_credit_mutex_.lock();
                    // cvif2pdp_rd_rsp_credit_ += credit_ptr->credit;
                    // cvif2pdp_rd_rsp_credit_mutex_.unlock();
                    // cvif2pdp_rd_rsp_credit_update_event_.notify();
                }
                break;

            case CV_CDP_READ_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_cv_credit_b_transport: got a credit to CDP_READ:\n"));
                if (credit_ptr->is_req == 1) {
                    cdp2cvif_rd_req_credit_mutex_.lock();
                    cdp2cvif_rd_req_credit_ += credit_ptr->credit;
                    if ( (CV_CDP_READ_AXI_ID == CV_CDMA_WT_READ_AXI_ID) && (credit_ptr->credit > 0) ) {
                        cdma_wt_dma_arbiter_source_id_initiator_b_transport(credit_ptr->sub_id, b_transport_delay_);
                    }
                    cdp2cvif_rd_req_credit_mutex_.unlock();
                    cdp2cvif_rd_req_credit_update_event_.notify();
                } else {
                    // cvif2cdp_rd_rsp_credit_mutex_.lock();
                    // cvif2cdp_rd_rsp_credit_ += credit_ptr->credit;
                    // cvif2cdp_rd_rsp_credit_mutex_.unlock();
                    // cvif2cdp_rd_rsp_credit_update_event_.notify();
                }
                break;

            case CV_RBK_READ_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_cv_credit_b_transport: got a credit to RBK_READ:\n"));
                if (credit_ptr->is_req == 1) {
                    rbk2cvif_rd_req_credit_mutex_.lock();
                    rbk2cvif_rd_req_credit_ += credit_ptr->credit;
                    if ( (CV_RBK_READ_AXI_ID == CV_CDMA_WT_READ_AXI_ID) && (credit_ptr->credit > 0) ) {
                        cdma_wt_dma_arbiter_source_id_initiator_b_transport(credit_ptr->sub_id, b_transport_delay_);
                    }
                    rbk2cvif_rd_req_credit_mutex_.unlock();
                    rbk2cvif_rd_req_credit_update_event_.notify();
                } else {
                    // cvif2rbk_rd_rsp_credit_mutex_.lock();
                    // cvif2rbk_rd_rsp_credit_ += credit_ptr->credit;
                    // cvif2rbk_rd_rsp_credit_mutex_.unlock();
                    // cvif2rbk_rd_rsp_credit_update_event_.notify();
                }
                break;

            case CV_SDP_B_READ_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_cv_credit_b_transport: got a credit to SDP_B_READ:\n"));
                if (credit_ptr->is_req == 1) {
                    sdp_b2cvif_rd_req_credit_mutex_.lock();
                    sdp_b2cvif_rd_req_credit_ += credit_ptr->credit;
                    if ( (CV_SDP_B_READ_AXI_ID == CV_CDMA_WT_READ_AXI_ID) && (credit_ptr->credit > 0) ) {
                        cdma_wt_dma_arbiter_source_id_initiator_b_transport(credit_ptr->sub_id, b_transport_delay_);
                    }
                    sdp_b2cvif_rd_req_credit_mutex_.unlock();
                    sdp_b2cvif_rd_req_credit_update_event_.notify();
                } else {
                    // cvif2sdp_b_rd_rsp_credit_mutex_.lock();
                    // cvif2sdp_b_rd_rsp_credit_ += credit_ptr->credit;
                    // cvif2sdp_b_rd_rsp_credit_mutex_.unlock();
                    // cvif2sdp_b_rd_rsp_credit_update_event_.notify();
                }
                break;

            case CV_SDP_N_READ_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_cv_credit_b_transport: got a credit to SDP_N_READ:\n"));
                if (credit_ptr->is_req == 1) {
                    sdp_n2cvif_rd_req_credit_mutex_.lock();
                    sdp_n2cvif_rd_req_credit_ += credit_ptr->credit;
                    if ( (CV_SDP_N_READ_AXI_ID == CV_CDMA_WT_READ_AXI_ID) && (credit_ptr->credit > 0) ) {
                        cdma_wt_dma_arbiter_source_id_initiator_b_transport(credit_ptr->sub_id, b_transport_delay_);
                    }
                    sdp_n2cvif_rd_req_credit_mutex_.unlock();
                    sdp_n2cvif_rd_req_credit_update_event_.notify();
                } else {
                    // cvif2sdp_n_rd_rsp_credit_mutex_.lock();
                    // cvif2sdp_n_rd_rsp_credit_ += credit_ptr->credit;
                    // cvif2sdp_n_rd_rsp_credit_mutex_.unlock();
                    // cvif2sdp_n_rd_rsp_credit_update_event_.notify();
                }
                break;

            case CV_SDP_E_READ_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_cv_credit_b_transport: got a credit to SDP_E_READ:\n"));
                if (credit_ptr->is_req == 1) {
                    sdp_e2cvif_rd_req_credit_mutex_.lock();
                    sdp_e2cvif_rd_req_credit_ += credit_ptr->credit;
                    if ( (CV_SDP_E_READ_AXI_ID == CV_CDMA_WT_READ_AXI_ID) && (credit_ptr->credit > 0) ) {
                        cdma_wt_dma_arbiter_source_id_initiator_b_transport(credit_ptr->sub_id, b_transport_delay_);
                    }
                    sdp_e2cvif_rd_req_credit_mutex_.unlock();
                    sdp_e2cvif_rd_req_credit_update_event_.notify();
                } else {
                    // cvif2sdp_e_rd_rsp_credit_mutex_.lock();
                    // cvif2sdp_e_rd_rsp_credit_ += credit_ptr->credit;
                    // cvif2sdp_e_rd_rsp_credit_mutex_.unlock();
                    // cvif2sdp_e_rd_rsp_credit_update_event_.notify();
                }
                break;

            case CV_CDMA_DAT_READ_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_cv_credit_b_transport: got a credit to CDMA_DAT_READ:\n"));
                if (credit_ptr->is_req == 1) {
                    cdma_dat2cvif_rd_req_credit_mutex_.lock();
                    cdma_dat2cvif_rd_req_credit_ += credit_ptr->credit;
                    if ( (CV_CDMA_DAT_READ_AXI_ID == CV_CDMA_WT_READ_AXI_ID) && (credit_ptr->credit > 0) ) {
                        cdma_wt_dma_arbiter_source_id_initiator_b_transport(credit_ptr->sub_id, b_transport_delay_);
                    }
                    cdma_dat2cvif_rd_req_credit_mutex_.unlock();
                    cdma_dat2cvif_rd_req_credit_update_event_.notify();
                } else {
                    // cvif2cdma_dat_rd_rsp_credit_mutex_.lock();
                    // cvif2cdma_dat_rd_rsp_credit_ += credit_ptr->credit;
                    // cvif2cdma_dat_rd_rsp_credit_mutex_.unlock();
                    // cvif2cdma_dat_rd_rsp_credit_update_event_.notify();
                }
                break;

            case CV_CDMA_WT_READ_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_cv_credit_b_transport: got a credit to CDMA_WT_READ:\n"));
                if (credit_ptr->is_req == 1) {
                    cdma_wt2cvif_rd_req_credit_mutex_.lock();
                    cdma_wt2cvif_rd_req_credit_ += credit_ptr->credit;
                    if ( (CV_CDMA_WT_READ_AXI_ID == CV_CDMA_WT_READ_AXI_ID) && (credit_ptr->credit > 0) ) {
                        cdma_wt_dma_arbiter_source_id_initiator_b_transport(credit_ptr->sub_id, b_transport_delay_);
                    }
                    cdma_wt2cvif_rd_req_credit_mutex_.unlock();
                    cdma_wt2cvif_rd_req_credit_update_event_.notify();
                } else {
                    // cvif2cdma_wt_rd_rsp_credit_mutex_.lock();
                    // cvif2cdma_wt_rd_rsp_credit_ += credit_ptr->credit;
                    // cvif2cdma_wt_rd_rsp_credit_mutex_.unlock();
                    // cvif2cdma_wt_rd_rsp_credit_update_event_.notify();
                }
                break;

            default: break;
        }}
    }}
}}

void NvdlaCoreInternalMonitor::dma_monitor_mc_credit_b_transport(int ID, tlm::tlm_generic_payload& gp, sc_time& delay) {{
    uint8_t *data_ptr = gp.get_data_ptr();
    credit_structure *credit_ptr = (credit_structure*) gp.get_data_ptr();
    cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_mc_credit_b_transport: got a credit:\n"));
    cslDebug((50, "    txn_id:  0x%x\n"    , credit_ptr->txn_id));
    cslDebug((50, "    is_read: 0x%x\n"   , credit_ptr->is_read));
    cslDebug((50, "    is_req:  0x%x\n"    , credit_ptr->is_req));
    cslDebug((50, "    credit:  0x%x\n"    , credit_ptr->credit));
    cslDebug((50, "    sub_id:  0x%x\n"    , credit_ptr->sub_id));
    for (uint32_t i; i < gp.get_data_length(); i ++) {{
        cslDebug((70, "    data_ptr[0x%x]:0x%x", i, uint32_t(data_ptr[i]) ));
    }}
    cslDebug((70, "\n"));
    if (credit_ptr->is_read == 0) {{
        switch (credit_ptr->txn_id) {{

            case MC_BDMA_WRITE_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_mc_credit_b_transport: got a credit to BDMA_WRITE:\n"));
                if (credit_ptr->is_req == 1) {
                    bdma2mcif_wr_req_credit_mutex_.lock();
                    bdma2mcif_wr_req_credit_ += credit_ptr->credit;
                    bdma2mcif_wr_req_credit_mutex_.unlock();
                    bdma2mcif_wr_req_credit_update_event_.notify();
                } else {
                    // mcif2bdma_wr_rsp_credit_mutex_.lock();
                    // mcif2bdma_wr_rsp_credit_ += credit_ptr->credit;
                    // mcif2bdma_wr_rsp_credit_mutex_.unlock();
                    // mcif2bdma_wr_rsp_credit_update_event_.notify();
                }
                break;

            case MC_SDP_WRITE_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_mc_credit_b_transport: got a credit to SDP_WRITE:\n"));
                if (credit_ptr->is_req == 1) {
                    sdp2mcif_wr_req_credit_mutex_.lock();
                    sdp2mcif_wr_req_credit_ += credit_ptr->credit;
                    sdp2mcif_wr_req_credit_mutex_.unlock();
                    sdp2mcif_wr_req_credit_update_event_.notify();
                } else {
                    mcif2sdp_wr_rsp_credit_mutex_.lock();
                    mcif2sdp_wr_rsp_credit_ += credit_ptr->credit;
                    mcif2sdp_wr_rsp_credit_mutex_.unlock();
                    mcif2sdp_wr_rsp_credit_update_event_.notify();
                }
                break;

            case MC_PDP_WRITE_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_mc_credit_b_transport: got a credit to PDP_WRITE:\n"));
                if (credit_ptr->is_req == 1) {
                    pdp2mcif_wr_req_credit_mutex_.lock();
                    pdp2mcif_wr_req_credit_ += credit_ptr->credit;
                    pdp2mcif_wr_req_credit_mutex_.unlock();
                    pdp2mcif_wr_req_credit_update_event_.notify();
                } else {
                    mcif2pdp_wr_rsp_credit_mutex_.lock();
                    mcif2pdp_wr_rsp_credit_ += credit_ptr->credit;
                    mcif2pdp_wr_rsp_credit_mutex_.unlock();
                    mcif2pdp_wr_rsp_credit_update_event_.notify();
                }
                break;

            case MC_CDP_WRITE_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_mc_credit_b_transport: got a credit to CDP_WRITE:\n"));
                if (credit_ptr->is_req == 1) {
                    cdp2mcif_wr_req_credit_mutex_.lock();
                    cdp2mcif_wr_req_credit_ += credit_ptr->credit;
                    cdp2mcif_wr_req_credit_mutex_.unlock();
                    cdp2mcif_wr_req_credit_update_event_.notify();
                } else {
                    mcif2cdp_wr_rsp_credit_mutex_.lock();
                    mcif2cdp_wr_rsp_credit_ += credit_ptr->credit;
                    mcif2cdp_wr_rsp_credit_mutex_.unlock();
                    mcif2cdp_wr_rsp_credit_update_event_.notify();
                }
                break;

            case MC_RBK_WRITE_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_mc_credit_b_transport: got a credit to RBK_WRITE:\n"));
                if (credit_ptr->is_req == 1) {
                    rbk2mcif_wr_req_credit_mutex_.lock();
                    rbk2mcif_wr_req_credit_ += credit_ptr->credit;
                    rbk2mcif_wr_req_credit_mutex_.unlock();
                    rbk2mcif_wr_req_credit_update_event_.notify();
                } else {
                    // mcif2rbk_wr_rsp_credit_mutex_.lock();
                    // mcif2rbk_wr_rsp_credit_ += credit_ptr->credit;
                    // mcif2rbk_wr_rsp_credit_mutex_.unlock();
                    // mcif2rbk_wr_rsp_credit_update_event_.notify();
                }
                break;

            default: break;
        }}
    }} else {{
        switch (credit_ptr->txn_id) {{

            case MC_BDMA_READ_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_mc_credit_b_transport: got a credit to BDMA_READ:\n"));
                if (credit_ptr->is_req == 1) {
                    bdma2mcif_rd_req_credit_mutex_.lock();
                    bdma2mcif_rd_req_credit_ += credit_ptr->credit;
                    if ( (CV_BDMA_READ_AXI_ID == CV_CDMA_WT_READ_AXI_ID) && (credit_ptr->credit > 0) ) {
                        cdma_wt_dma_arbiter_source_id_initiator_b_transport(credit_ptr->sub_id, b_transport_delay_);
                    }
                    bdma2mcif_rd_req_credit_mutex_.unlock();
                    bdma2mcif_rd_req_credit_update_event_.notify();
                } else {
                    // mcif2bdma_rd_rsp_credit_mutex_.lock();
                    // mcif2bdma_rd_rsp_credit_ += credit_ptr->credit;
                    // mcif2bdma_rd_rsp_credit_mutex_.unlock();
                    // mcif2bdma_rd_rsp_credit_update_event_.notify();
                }
                break;

            case MC_SDP_READ_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_mc_credit_b_transport: got a credit to SDP_READ:\n"));
                if (credit_ptr->is_req == 1) {
                    sdp2mcif_rd_req_credit_mutex_.lock();
                    sdp2mcif_rd_req_credit_ += credit_ptr->credit;
                    if ( (CV_SDP_READ_AXI_ID == CV_CDMA_WT_READ_AXI_ID) && (credit_ptr->credit > 0) ) {
                        cdma_wt_dma_arbiter_source_id_initiator_b_transport(credit_ptr->sub_id, b_transport_delay_);
                    }
                    sdp2mcif_rd_req_credit_mutex_.unlock();
                    sdp2mcif_rd_req_credit_update_event_.notify();
                } else {
                    mcif2sdp_rd_rsp_credit_mutex_.lock();
                    mcif2sdp_rd_rsp_credit_ += credit_ptr->credit;
                    mcif2sdp_rd_rsp_credit_mutex_.unlock();
                    mcif2sdp_rd_rsp_credit_update_event_.notify();
                }
                break;

            case MC_PDP_READ_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_mc_credit_b_transport: got a credit to PDP_READ:\n"));
                if (credit_ptr->is_req == 1) {
                    pdp2mcif_rd_req_credit_mutex_.lock();
                    pdp2mcif_rd_req_credit_ += credit_ptr->credit;
                    if ( (CV_PDP_READ_AXI_ID == CV_CDMA_WT_READ_AXI_ID) && (credit_ptr->credit > 0) ) {
                        cdma_wt_dma_arbiter_source_id_initiator_b_transport(credit_ptr->sub_id, b_transport_delay_);
                    }
                    pdp2mcif_rd_req_credit_mutex_.unlock();
                    pdp2mcif_rd_req_credit_update_event_.notify();
                } else {
                    mcif2pdp_rd_rsp_credit_mutex_.lock();
                    mcif2pdp_rd_rsp_credit_ += credit_ptr->credit;
                    mcif2pdp_rd_rsp_credit_mutex_.unlock();
                    mcif2pdp_rd_rsp_credit_update_event_.notify();
                }
                break;

            case MC_CDP_READ_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_mc_credit_b_transport: got a credit to CDP_READ:\n"));
                if (credit_ptr->is_req == 1) {
                    cdp2mcif_rd_req_credit_mutex_.lock();
                    cdp2mcif_rd_req_credit_ += credit_ptr->credit;
                    if ( (CV_CDP_READ_AXI_ID == CV_CDMA_WT_READ_AXI_ID) && (credit_ptr->credit > 0) ) {
                        cdma_wt_dma_arbiter_source_id_initiator_b_transport(credit_ptr->sub_id, b_transport_delay_);
                    }
                    cdp2mcif_rd_req_credit_mutex_.unlock();
                    cdp2mcif_rd_req_credit_update_event_.notify();
                } else {
                    mcif2cdp_rd_rsp_credit_mutex_.lock();
                    mcif2cdp_rd_rsp_credit_ += credit_ptr->credit;
                    mcif2cdp_rd_rsp_credit_mutex_.unlock();
                    mcif2cdp_rd_rsp_credit_update_event_.notify();
                }
                break;

            case MC_RBK_READ_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_mc_credit_b_transport: got a credit to RBK_READ:\n"));
                if (credit_ptr->is_req == 1) {
                    rbk2mcif_rd_req_credit_mutex_.lock();
                    rbk2mcif_rd_req_credit_ += credit_ptr->credit;
                    if ( (CV_RBK_READ_AXI_ID == CV_CDMA_WT_READ_AXI_ID) && (credit_ptr->credit > 0) ) {
                        cdma_wt_dma_arbiter_source_id_initiator_b_transport(credit_ptr->sub_id, b_transport_delay_);
                    }
                    rbk2mcif_rd_req_credit_mutex_.unlock();
                    rbk2mcif_rd_req_credit_update_event_.notify();
                } else {
                    // mcif2rbk_rd_rsp_credit_mutex_.lock();
                    // mcif2rbk_rd_rsp_credit_ += credit_ptr->credit;
                    // mcif2rbk_rd_rsp_credit_mutex_.unlock();
                    // mcif2rbk_rd_rsp_credit_update_event_.notify();
                }
                break;

            case MC_SDP_B_READ_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_mc_credit_b_transport: got a credit to SDP_B_READ:\n"));
                if (credit_ptr->is_req == 1) {
                    sdp_b2mcif_rd_req_credit_mutex_.lock();
                    sdp_b2mcif_rd_req_credit_ += credit_ptr->credit;
                    if ( (CV_SDP_B_READ_AXI_ID == CV_CDMA_WT_READ_AXI_ID) && (credit_ptr->credit > 0) ) {
                        cdma_wt_dma_arbiter_source_id_initiator_b_transport(credit_ptr->sub_id, b_transport_delay_);
                    }
                    sdp_b2mcif_rd_req_credit_mutex_.unlock();
                    sdp_b2mcif_rd_req_credit_update_event_.notify();
                } else {
                    // mcif2sdp_b_rd_rsp_credit_mutex_.lock();
                    // mcif2sdp_b_rd_rsp_credit_ += credit_ptr->credit;
                    // mcif2sdp_b_rd_rsp_credit_mutex_.unlock();
                    // mcif2sdp_b_rd_rsp_credit_update_event_.notify();
                }
                break;

            case MC_SDP_N_READ_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_mc_credit_b_transport: got a credit to SDP_N_READ:\n"));
                if (credit_ptr->is_req == 1) {
                    sdp_n2mcif_rd_req_credit_mutex_.lock();
                    sdp_n2mcif_rd_req_credit_ += credit_ptr->credit;
                    if ( (CV_SDP_N_READ_AXI_ID == CV_CDMA_WT_READ_AXI_ID) && (credit_ptr->credit > 0) ) {
                        cdma_wt_dma_arbiter_source_id_initiator_b_transport(credit_ptr->sub_id, b_transport_delay_);
                    }
                    sdp_n2mcif_rd_req_credit_mutex_.unlock();
                    sdp_n2mcif_rd_req_credit_update_event_.notify();
                } else {
                    // mcif2sdp_n_rd_rsp_credit_mutex_.lock();
                    // mcif2sdp_n_rd_rsp_credit_ += credit_ptr->credit;
                    // mcif2sdp_n_rd_rsp_credit_mutex_.unlock();
                    // mcif2sdp_n_rd_rsp_credit_update_event_.notify();
                }
                break;

            case MC_SDP_E_READ_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_mc_credit_b_transport: got a credit to SDP_E_READ:\n"));
                if (credit_ptr->is_req == 1) {
                    sdp_e2mcif_rd_req_credit_mutex_.lock();
                    sdp_e2mcif_rd_req_credit_ += credit_ptr->credit;
                    if ( (CV_SDP_E_READ_AXI_ID == CV_CDMA_WT_READ_AXI_ID) && (credit_ptr->credit > 0) ) {
                        cdma_wt_dma_arbiter_source_id_initiator_b_transport(credit_ptr->sub_id, b_transport_delay_);
                    }
                    sdp_e2mcif_rd_req_credit_mutex_.unlock();
                    sdp_e2mcif_rd_req_credit_update_event_.notify();
                } else {
                    // mcif2sdp_e_rd_rsp_credit_mutex_.lock();
                    // mcif2sdp_e_rd_rsp_credit_ += credit_ptr->credit;
                    // mcif2sdp_e_rd_rsp_credit_mutex_.unlock();
                    // mcif2sdp_e_rd_rsp_credit_update_event_.notify();
                }
                break;

            case MC_CDMA_DAT_READ_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_mc_credit_b_transport: got a credit to CDMA_DAT_READ:\n"));
                if (credit_ptr->is_req == 1) {
                    cdma_dat2mcif_rd_req_credit_mutex_.lock();
                    cdma_dat2mcif_rd_req_credit_ += credit_ptr->credit;
                    if ( (CV_CDMA_DAT_READ_AXI_ID == CV_CDMA_WT_READ_AXI_ID) && (credit_ptr->credit > 0) ) {
                        cdma_wt_dma_arbiter_source_id_initiator_b_transport(credit_ptr->sub_id, b_transport_delay_);
                    }
                    cdma_dat2mcif_rd_req_credit_mutex_.unlock();
                    cdma_dat2mcif_rd_req_credit_update_event_.notify();
                } else {
                    mcif2cdma_dat_rd_rsp_credit_mutex_.lock();
                    mcif2cdma_dat_rd_rsp_credit_ += credit_ptr->credit;
                    mcif2cdma_dat_rd_rsp_credit_mutex_.unlock();
                    mcif2cdma_dat_rd_rsp_credit_update_event_.notify();
                }
                break;

            case MC_CDMA_WT_READ_AXI_ID:
                cslDebug((50, "NvdlaCoreInternalMonitor::dma_monitor_mc_credit_b_transport: got a credit to CDMA_WT_READ:\n"));
                if (credit_ptr->is_req == 1) {
                    cdma_wt2mcif_rd_req_credit_mutex_.lock();
                    cdma_wt2mcif_rd_req_credit_ += credit_ptr->credit;
                    if ( (CV_CDMA_WT_READ_AXI_ID == CV_CDMA_WT_READ_AXI_ID) && (credit_ptr->credit > 0) ) {
                        cdma_wt_dma_arbiter_source_id_initiator_b_transport(credit_ptr->sub_id, b_transport_delay_);
                    }
                    cdma_wt2mcif_rd_req_credit_mutex_.unlock();
                    cdma_wt2mcif_rd_req_credit_update_event_.notify();
                } else {
                    mcif2cdma_wt_rd_rsp_credit_mutex_.lock();
                    mcif2cdma_wt_rd_rsp_credit_ += credit_ptr->credit;
                    mcif2cdma_wt_rd_rsp_credit_mutex_.unlock();
                    mcif2cdma_wt_rd_rsp_credit_update_event_.notify();
                }
                break;

            default: break;
        }}
    }}
}}

void NvdlaCoreInternalMonitor::bdma2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    // cslAssert(0 > bdma2cvif_rd_req_credit_);
    switch (bdma2cvif_rd_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::bdma2cvif_rd_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::bdma2cvif_rd_req_b_transport, working mode is pass through, directly forward\n"));
            bdma2cvif_rd_req_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == bdma2cvif_rd_req_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::bdma2cvif_rd_req_b_transport, wait credit update event, halt CMOD\n"));
                wait(bdma2cvif_rd_req_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::bdma2cvif_rd_req_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::bdma2cvif_rd_req_b_transport, credit is not zero\n"));
            bdma2cvif_rd_req_credit_mutex_.lock();
            bdma2cvif_rd_req_b_transport(ID, payload, delay);
            bdma2cvif_rd_req_credit_--;
            bdma2cvif_rd_req_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::bdma2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_BDMA_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_rd_req_t));
    // if ( ! bdma2cvif_rd_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::bdma2cvif_rd_req_b_transport, ERROR, FIFO bdma2cvif_rd_req_fifo is stuck." << endl;
    // } else {
    //     cslDebug((70, "NvdlaCoreInternalMonitor::bdma2cvif_rd_req_b_transport:\n"));
    //     cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    //     cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    // }
    bdma2cvif_rd_req_fifo_->write(payload_copy);
    cslDebug((70, "NvdlaCoreInternalMonitor::bdma2cvif_rd_req_b_transport:\n"));
    cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    cslDebug((50, "NvdlaCoreInternalMonitor::bdma2cvif_rd_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::cvif2bdma_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    // cslAssert(0 > cvif2bdma_rd_rsp_credit_);
    switch (cvif2bdma_rd_rsp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::cvif2bdma_rd_rsp_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::cvif2bdma_rd_rsp_b_transport, working mode is not sampling, directly forward\n"));
            cvif2bdma_rd_rsp_b_transport(ID, payload, delay);
            break;
        default:
            // For response transaction, will not add gating mechenism
            cvif2bdma_rd_rsp_b_transport(ID, payload, delay);
            // while (0 == cvif2bdma_rd_rsp_credit_) {
            //     cslDebug((50, "NvdlaCoreInternalMonitor::cvif2bdma_rd_rsp_b_transport, wait credit update event, halt CMOD\n"));
            //     wait(cvif2bdma_rd_rsp_credit_update_event_);
            //     cslDebug((50, "NvdlaCoreInternalMonitor::cvif2bdma_rd_rsp_b_transport, got credit update event, unhalt cmod\n"));
            // }
            // cslDebug((50, "NvdlaCoreInternalMonitor::cvif2bdma_rd_rsp_b_transport, credit is not zero\n"));
            // cvif2bdma_rd_rsp_credit_mutex_.lock();
            // cvif2bdma_rd_rsp_b_transport(ID, payload, delay);
            // cvif2bdma_rd_rsp_credit_--;
            // cvif2bdma_rd_rsp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::cvif2bdma_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_BDMA_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
    cslDebug((70, "NvdlaCoreInternalMonitor::cvif2bdma_rd_rsp_b_transport, dma_id: 0x%x\n", uint32_t(payload_copy->dma_id) ));
    cslDebug((70, "NvdlaCoreInternalMonitor::cvif2bdma_rd_rsp_b_transport, status: 0x%x\n", uint32_t(payload_copy->status) ));
    memcpy ((void *)(&payload_copy->rsp), (void *)payload, sizeof(nvdla_dma_rd_rsp_t));
    // if ( ! cvif2bdma_rd_rsp_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::cvif2bdma_rd_rsp_b_transport, ERROR, FIFO cvif2bdma_rd_rsp_fifo is stuck." << endl;
    // }
    cvif2bdma_rd_rsp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::cvif2bdma_rd_rsp_b_transport, push data to fifo\n"));
}

void NvdlaCoreInternalMonitor::sdp2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    // cslAssert(0 > sdp2cvif_rd_req_credit_);
    switch (sdp2cvif_rd_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::sdp2cvif_rd_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::sdp2cvif_rd_req_b_transport, working mode is pass through, directly forward\n"));
            sdp2cvif_rd_req_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == sdp2cvif_rd_req_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp2cvif_rd_req_b_transport, wait credit update event, halt CMOD\n"));
                wait(sdp2cvif_rd_req_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp2cvif_rd_req_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::sdp2cvif_rd_req_b_transport, credit is not zero\n"));
            sdp2cvif_rd_req_credit_mutex_.lock();
            sdp2cvif_rd_req_b_transport(ID, payload, delay);
            sdp2cvif_rd_req_credit_--;
            sdp2cvif_rd_req_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::sdp2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_SDP_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_rd_req_t));
    // if ( ! sdp2cvif_rd_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::sdp2cvif_rd_req_b_transport, ERROR, FIFO sdp2cvif_rd_req_fifo is stuck." << endl;
    // } else {
    //     cslDebug((70, "NvdlaCoreInternalMonitor::sdp2cvif_rd_req_b_transport:\n"));
    //     cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    //     cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    // }
    sdp2cvif_rd_req_fifo_->write(payload_copy);
    cslDebug((70, "NvdlaCoreInternalMonitor::sdp2cvif_rd_req_b_transport:\n"));
    cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    cslDebug((50, "NvdlaCoreInternalMonitor::sdp2cvif_rd_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::cvif2sdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    // cslAssert(0 > cvif2sdp_rd_rsp_credit_);
    switch (cvif2sdp_rd_rsp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::cvif2sdp_rd_rsp_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::cvif2sdp_rd_rsp_b_transport, working mode is not sampling, directly forward\n"));
            cvif2sdp_rd_rsp_b_transport(ID, payload, delay);
            break;
        default:
            // For response transaction, will not add gating mechenism
            cvif2sdp_rd_rsp_b_transport(ID, payload, delay);
            // while (0 == cvif2sdp_rd_rsp_credit_) {
            //     cslDebug((50, "NvdlaCoreInternalMonitor::cvif2sdp_rd_rsp_b_transport, wait credit update event, halt CMOD\n"));
            //     wait(cvif2sdp_rd_rsp_credit_update_event_);
            //     cslDebug((50, "NvdlaCoreInternalMonitor::cvif2sdp_rd_rsp_b_transport, got credit update event, unhalt cmod\n"));
            // }
            // cslDebug((50, "NvdlaCoreInternalMonitor::cvif2sdp_rd_rsp_b_transport, credit is not zero\n"));
            // cvif2sdp_rd_rsp_credit_mutex_.lock();
            // cvif2sdp_rd_rsp_b_transport(ID, payload, delay);
            // cvif2sdp_rd_rsp_credit_--;
            // cvif2sdp_rd_rsp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::cvif2sdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_SDP_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
    cslDebug((70, "NvdlaCoreInternalMonitor::cvif2sdp_rd_rsp_b_transport, dma_id: 0x%x\n", uint32_t(payload_copy->dma_id) ));
    cslDebug((70, "NvdlaCoreInternalMonitor::cvif2sdp_rd_rsp_b_transport, status: 0x%x\n", uint32_t(payload_copy->status) ));
    memcpy ((void *)(&payload_copy->rsp), (void *)payload, sizeof(nvdla_dma_rd_rsp_t));
    // if ( ! cvif2sdp_rd_rsp_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::cvif2sdp_rd_rsp_b_transport, ERROR, FIFO cvif2sdp_rd_rsp_fifo is stuck." << endl;
    // }
    cvif2sdp_rd_rsp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::cvif2sdp_rd_rsp_b_transport, push data to fifo\n"));
}

void NvdlaCoreInternalMonitor::pdp2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    // cslAssert(0 > pdp2cvif_rd_req_credit_);
    switch (pdp2cvif_rd_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::pdp2cvif_rd_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::pdp2cvif_rd_req_b_transport, working mode is pass through, directly forward\n"));
            pdp2cvif_rd_req_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == pdp2cvif_rd_req_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::pdp2cvif_rd_req_b_transport, wait credit update event, halt CMOD\n"));
                wait(pdp2cvif_rd_req_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::pdp2cvif_rd_req_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::pdp2cvif_rd_req_b_transport, credit is not zero\n"));
            pdp2cvif_rd_req_credit_mutex_.lock();
            pdp2cvif_rd_req_b_transport(ID, payload, delay);
            pdp2cvif_rd_req_credit_--;
            pdp2cvif_rd_req_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::pdp2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_PDP_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_rd_req_t));
    // if ( ! pdp2cvif_rd_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::pdp2cvif_rd_req_b_transport, ERROR, FIFO pdp2cvif_rd_req_fifo is stuck." << endl;
    // } else {
    //     cslDebug((70, "NvdlaCoreInternalMonitor::pdp2cvif_rd_req_b_transport:\n"));
    //     cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    //     cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    // }
    pdp2cvif_rd_req_fifo_->write(payload_copy);
    cslDebug((70, "NvdlaCoreInternalMonitor::pdp2cvif_rd_req_b_transport:\n"));
    cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    cslDebug((50, "NvdlaCoreInternalMonitor::pdp2cvif_rd_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::cvif2pdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    // cslAssert(0 > cvif2pdp_rd_rsp_credit_);
    switch (cvif2pdp_rd_rsp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::cvif2pdp_rd_rsp_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::cvif2pdp_rd_rsp_b_transport, working mode is not sampling, directly forward\n"));
            cvif2pdp_rd_rsp_b_transport(ID, payload, delay);
            break;
        default:
            // For response transaction, will not add gating mechenism
            cvif2pdp_rd_rsp_b_transport(ID, payload, delay);
            // while (0 == cvif2pdp_rd_rsp_credit_) {
            //     cslDebug((50, "NvdlaCoreInternalMonitor::cvif2pdp_rd_rsp_b_transport, wait credit update event, halt CMOD\n"));
            //     wait(cvif2pdp_rd_rsp_credit_update_event_);
            //     cslDebug((50, "NvdlaCoreInternalMonitor::cvif2pdp_rd_rsp_b_transport, got credit update event, unhalt cmod\n"));
            // }
            // cslDebug((50, "NvdlaCoreInternalMonitor::cvif2pdp_rd_rsp_b_transport, credit is not zero\n"));
            // cvif2pdp_rd_rsp_credit_mutex_.lock();
            // cvif2pdp_rd_rsp_b_transport(ID, payload, delay);
            // cvif2pdp_rd_rsp_credit_--;
            // cvif2pdp_rd_rsp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::cvif2pdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_PDP_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
    cslDebug((70, "NvdlaCoreInternalMonitor::cvif2pdp_rd_rsp_b_transport, dma_id: 0x%x\n", uint32_t(payload_copy->dma_id) ));
    cslDebug((70, "NvdlaCoreInternalMonitor::cvif2pdp_rd_rsp_b_transport, status: 0x%x\n", uint32_t(payload_copy->status) ));
    memcpy ((void *)(&payload_copy->rsp), (void *)payload, sizeof(nvdla_dma_rd_rsp_t));
    // if ( ! cvif2pdp_rd_rsp_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::cvif2pdp_rd_rsp_b_transport, ERROR, FIFO cvif2pdp_rd_rsp_fifo is stuck." << endl;
    // }
    cvif2pdp_rd_rsp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::cvif2pdp_rd_rsp_b_transport, push data to fifo\n"));
}

void NvdlaCoreInternalMonitor::cdp2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    // cslAssert(0 > cdp2cvif_rd_req_credit_);
    switch (cdp2cvif_rd_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::cdp2cvif_rd_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::cdp2cvif_rd_req_b_transport, working mode is pass through, directly forward\n"));
            cdp2cvif_rd_req_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == cdp2cvif_rd_req_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::cdp2cvif_rd_req_b_transport, wait credit update event, halt CMOD\n"));
                wait(cdp2cvif_rd_req_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::cdp2cvif_rd_req_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::cdp2cvif_rd_req_b_transport, credit is not zero\n"));
            cdp2cvif_rd_req_credit_mutex_.lock();
            cdp2cvif_rd_req_b_transport(ID, payload, delay);
            cdp2cvif_rd_req_credit_--;
            cdp2cvif_rd_req_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::cdp2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_CDP_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_rd_req_t));
    // if ( ! cdp2cvif_rd_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::cdp2cvif_rd_req_b_transport, ERROR, FIFO cdp2cvif_rd_req_fifo is stuck." << endl;
    // } else {
    //     cslDebug((70, "NvdlaCoreInternalMonitor::cdp2cvif_rd_req_b_transport:\n"));
    //     cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    //     cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    // }
    cdp2cvif_rd_req_fifo_->write(payload_copy);
    cslDebug((70, "NvdlaCoreInternalMonitor::cdp2cvif_rd_req_b_transport:\n"));
    cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    cslDebug((50, "NvdlaCoreInternalMonitor::cdp2cvif_rd_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::cvif2cdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    // cslAssert(0 > cvif2cdp_rd_rsp_credit_);
    switch (cvif2cdp_rd_rsp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::cvif2cdp_rd_rsp_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::cvif2cdp_rd_rsp_b_transport, working mode is not sampling, directly forward\n"));
            cvif2cdp_rd_rsp_b_transport(ID, payload, delay);
            break;
        default:
            // For response transaction, will not add gating mechenism
            cvif2cdp_rd_rsp_b_transport(ID, payload, delay);
            // while (0 == cvif2cdp_rd_rsp_credit_) {
            //     cslDebug((50, "NvdlaCoreInternalMonitor::cvif2cdp_rd_rsp_b_transport, wait credit update event, halt CMOD\n"));
            //     wait(cvif2cdp_rd_rsp_credit_update_event_);
            //     cslDebug((50, "NvdlaCoreInternalMonitor::cvif2cdp_rd_rsp_b_transport, got credit update event, unhalt cmod\n"));
            // }
            // cslDebug((50, "NvdlaCoreInternalMonitor::cvif2cdp_rd_rsp_b_transport, credit is not zero\n"));
            // cvif2cdp_rd_rsp_credit_mutex_.lock();
            // cvif2cdp_rd_rsp_b_transport(ID, payload, delay);
            // cvif2cdp_rd_rsp_credit_--;
            // cvif2cdp_rd_rsp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::cvif2cdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_CDP_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
    cslDebug((70, "NvdlaCoreInternalMonitor::cvif2cdp_rd_rsp_b_transport, dma_id: 0x%x\n", uint32_t(payload_copy->dma_id) ));
    cslDebug((70, "NvdlaCoreInternalMonitor::cvif2cdp_rd_rsp_b_transport, status: 0x%x\n", uint32_t(payload_copy->status) ));
    memcpy ((void *)(&payload_copy->rsp), (void *)payload, sizeof(nvdla_dma_rd_rsp_t));
    // if ( ! cvif2cdp_rd_rsp_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::cvif2cdp_rd_rsp_b_transport, ERROR, FIFO cvif2cdp_rd_rsp_fifo is stuck." << endl;
    // }
    cvif2cdp_rd_rsp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::cvif2cdp_rd_rsp_b_transport, push data to fifo\n"));
}

void NvdlaCoreInternalMonitor::rbk2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    // cslAssert(0 > rbk2cvif_rd_req_credit_);
    switch (rbk2cvif_rd_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::rbk2cvif_rd_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::rbk2cvif_rd_req_b_transport, working mode is pass through, directly forward\n"));
            rbk2cvif_rd_req_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == rbk2cvif_rd_req_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::rbk2cvif_rd_req_b_transport, wait credit update event, halt CMOD\n"));
                wait(rbk2cvif_rd_req_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::rbk2cvif_rd_req_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::rbk2cvif_rd_req_b_transport, credit is not zero\n"));
            rbk2cvif_rd_req_credit_mutex_.lock();
            rbk2cvif_rd_req_b_transport(ID, payload, delay);
            rbk2cvif_rd_req_credit_--;
            rbk2cvif_rd_req_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::rbk2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_RBK_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_rd_req_t));
    // if ( ! rbk2cvif_rd_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::rbk2cvif_rd_req_b_transport, ERROR, FIFO rbk2cvif_rd_req_fifo is stuck." << endl;
    // } else {
    //     cslDebug((70, "NvdlaCoreInternalMonitor::rbk2cvif_rd_req_b_transport:\n"));
    //     cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    //     cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    // }
    rbk2cvif_rd_req_fifo_->write(payload_copy);
    cslDebug((70, "NvdlaCoreInternalMonitor::rbk2cvif_rd_req_b_transport:\n"));
    cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    cslDebug((50, "NvdlaCoreInternalMonitor::rbk2cvif_rd_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::cvif2rbk_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    // cslAssert(0 > cvif2rbk_rd_rsp_credit_);
    switch (cvif2rbk_rd_rsp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::cvif2rbk_rd_rsp_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::cvif2rbk_rd_rsp_b_transport, working mode is not sampling, directly forward\n"));
            cvif2rbk_rd_rsp_b_transport(ID, payload, delay);
            break;
        default:
            // For response transaction, will not add gating mechenism
            cvif2rbk_rd_rsp_b_transport(ID, payload, delay);
            // while (0 == cvif2rbk_rd_rsp_credit_) {
            //     cslDebug((50, "NvdlaCoreInternalMonitor::cvif2rbk_rd_rsp_b_transport, wait credit update event, halt CMOD\n"));
            //     wait(cvif2rbk_rd_rsp_credit_update_event_);
            //     cslDebug((50, "NvdlaCoreInternalMonitor::cvif2rbk_rd_rsp_b_transport, got credit update event, unhalt cmod\n"));
            // }
            // cslDebug((50, "NvdlaCoreInternalMonitor::cvif2rbk_rd_rsp_b_transport, credit is not zero\n"));
            // cvif2rbk_rd_rsp_credit_mutex_.lock();
            // cvif2rbk_rd_rsp_b_transport(ID, payload, delay);
            // cvif2rbk_rd_rsp_credit_--;
            // cvif2rbk_rd_rsp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::cvif2rbk_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_RBK_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
    cslDebug((70, "NvdlaCoreInternalMonitor::cvif2rbk_rd_rsp_b_transport, dma_id: 0x%x\n", uint32_t(payload_copy->dma_id) ));
    cslDebug((70, "NvdlaCoreInternalMonitor::cvif2rbk_rd_rsp_b_transport, status: 0x%x\n", uint32_t(payload_copy->status) ));
    memcpy ((void *)(&payload_copy->rsp), (void *)payload, sizeof(nvdla_dma_rd_rsp_t));
    // if ( ! cvif2rbk_rd_rsp_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::cvif2rbk_rd_rsp_b_transport, ERROR, FIFO cvif2rbk_rd_rsp_fifo is stuck." << endl;
    // }
    cvif2rbk_rd_rsp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::cvif2rbk_rd_rsp_b_transport, push data to fifo\n"));
}

void NvdlaCoreInternalMonitor::sdp_b2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    // cslAssert(0 > sdp_b2cvif_rd_req_credit_);
    switch (sdp_b2cvif_rd_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::sdp_b2cvif_rd_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::sdp_b2cvif_rd_req_b_transport, working mode is pass through, directly forward\n"));
            sdp_b2cvif_rd_req_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == sdp_b2cvif_rd_req_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp_b2cvif_rd_req_b_transport, wait credit update event, halt CMOD\n"));
                wait(sdp_b2cvif_rd_req_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp_b2cvif_rd_req_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::sdp_b2cvif_rd_req_b_transport, credit is not zero\n"));
            sdp_b2cvif_rd_req_credit_mutex_.lock();
            sdp_b2cvif_rd_req_b_transport(ID, payload, delay);
            sdp_b2cvif_rd_req_credit_--;
            sdp_b2cvif_rd_req_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::sdp_b2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_SDP_B_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_rd_req_t));
    // if ( ! sdp_b2cvif_rd_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::sdp_b2cvif_rd_req_b_transport, ERROR, FIFO sdp_b2cvif_rd_req_fifo is stuck." << endl;
    // } else {
    //     cslDebug((70, "NvdlaCoreInternalMonitor::sdp_b2cvif_rd_req_b_transport:\n"));
    //     cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    //     cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    // }
    sdp_b2cvif_rd_req_fifo_->write(payload_copy);
    cslDebug((70, "NvdlaCoreInternalMonitor::sdp_b2cvif_rd_req_b_transport:\n"));
    cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    cslDebug((50, "NvdlaCoreInternalMonitor::sdp_b2cvif_rd_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::cvif2sdp_b_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    // cslAssert(0 > cvif2sdp_b_rd_rsp_credit_);
    switch (cvif2sdp_b_rd_rsp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::cvif2sdp_b_rd_rsp_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::cvif2sdp_b_rd_rsp_b_transport, working mode is not sampling, directly forward\n"));
            cvif2sdp_b_rd_rsp_b_transport(ID, payload, delay);
            break;
        default:
            // For response transaction, will not add gating mechenism
            cvif2sdp_b_rd_rsp_b_transport(ID, payload, delay);
            // while (0 == cvif2sdp_b_rd_rsp_credit_) {
            //     cslDebug((50, "NvdlaCoreInternalMonitor::cvif2sdp_b_rd_rsp_b_transport, wait credit update event, halt CMOD\n"));
            //     wait(cvif2sdp_b_rd_rsp_credit_update_event_);
            //     cslDebug((50, "NvdlaCoreInternalMonitor::cvif2sdp_b_rd_rsp_b_transport, got credit update event, unhalt cmod\n"));
            // }
            // cslDebug((50, "NvdlaCoreInternalMonitor::cvif2sdp_b_rd_rsp_b_transport, credit is not zero\n"));
            // cvif2sdp_b_rd_rsp_credit_mutex_.lock();
            // cvif2sdp_b_rd_rsp_b_transport(ID, payload, delay);
            // cvif2sdp_b_rd_rsp_credit_--;
            // cvif2sdp_b_rd_rsp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::cvif2sdp_b_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_SDP_B_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
    cslDebug((70, "NvdlaCoreInternalMonitor::cvif2sdp_b_rd_rsp_b_transport, dma_id: 0x%x\n", uint32_t(payload_copy->dma_id) ));
    cslDebug((70, "NvdlaCoreInternalMonitor::cvif2sdp_b_rd_rsp_b_transport, status: 0x%x\n", uint32_t(payload_copy->status) ));
    memcpy ((void *)(&payload_copy->rsp), (void *)payload, sizeof(nvdla_dma_rd_rsp_t));
    // if ( ! cvif2sdp_b_rd_rsp_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::cvif2sdp_b_rd_rsp_b_transport, ERROR, FIFO cvif2sdp_b_rd_rsp_fifo is stuck." << endl;
    // }
    cvif2sdp_b_rd_rsp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::cvif2sdp_b_rd_rsp_b_transport, push data to fifo\n"));
}

void NvdlaCoreInternalMonitor::sdp_n2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    // cslAssert(0 > sdp_n2cvif_rd_req_credit_);
    switch (sdp_n2cvif_rd_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::sdp_n2cvif_rd_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::sdp_n2cvif_rd_req_b_transport, working mode is pass through, directly forward\n"));
            sdp_n2cvif_rd_req_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == sdp_n2cvif_rd_req_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp_n2cvif_rd_req_b_transport, wait credit update event, halt CMOD\n"));
                wait(sdp_n2cvif_rd_req_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp_n2cvif_rd_req_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::sdp_n2cvif_rd_req_b_transport, credit is not zero\n"));
            sdp_n2cvif_rd_req_credit_mutex_.lock();
            sdp_n2cvif_rd_req_b_transport(ID, payload, delay);
            sdp_n2cvif_rd_req_credit_--;
            sdp_n2cvif_rd_req_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::sdp_n2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_SDP_N_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_rd_req_t));
    // if ( ! sdp_n2cvif_rd_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::sdp_n2cvif_rd_req_b_transport, ERROR, FIFO sdp_n2cvif_rd_req_fifo is stuck." << endl;
    // } else {
    //     cslDebug((70, "NvdlaCoreInternalMonitor::sdp_n2cvif_rd_req_b_transport:\n"));
    //     cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    //     cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    // }
    sdp_n2cvif_rd_req_fifo_->write(payload_copy);
    cslDebug((70, "NvdlaCoreInternalMonitor::sdp_n2cvif_rd_req_b_transport:\n"));
    cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    cslDebug((50, "NvdlaCoreInternalMonitor::sdp_n2cvif_rd_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::cvif2sdp_n_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    // cslAssert(0 > cvif2sdp_n_rd_rsp_credit_);
    switch (cvif2sdp_n_rd_rsp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::cvif2sdp_n_rd_rsp_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::cvif2sdp_n_rd_rsp_b_transport, working mode is not sampling, directly forward\n"));
            cvif2sdp_n_rd_rsp_b_transport(ID, payload, delay);
            break;
        default:
            // For response transaction, will not add gating mechenism
            cvif2sdp_n_rd_rsp_b_transport(ID, payload, delay);
            // while (0 == cvif2sdp_n_rd_rsp_credit_) {
            //     cslDebug((50, "NvdlaCoreInternalMonitor::cvif2sdp_n_rd_rsp_b_transport, wait credit update event, halt CMOD\n"));
            //     wait(cvif2sdp_n_rd_rsp_credit_update_event_);
            //     cslDebug((50, "NvdlaCoreInternalMonitor::cvif2sdp_n_rd_rsp_b_transport, got credit update event, unhalt cmod\n"));
            // }
            // cslDebug((50, "NvdlaCoreInternalMonitor::cvif2sdp_n_rd_rsp_b_transport, credit is not zero\n"));
            // cvif2sdp_n_rd_rsp_credit_mutex_.lock();
            // cvif2sdp_n_rd_rsp_b_transport(ID, payload, delay);
            // cvif2sdp_n_rd_rsp_credit_--;
            // cvif2sdp_n_rd_rsp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::cvif2sdp_n_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_SDP_N_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
    cslDebug((70, "NvdlaCoreInternalMonitor::cvif2sdp_n_rd_rsp_b_transport, dma_id: 0x%x\n", uint32_t(payload_copy->dma_id) ));
    cslDebug((70, "NvdlaCoreInternalMonitor::cvif2sdp_n_rd_rsp_b_transport, status: 0x%x\n", uint32_t(payload_copy->status) ));
    memcpy ((void *)(&payload_copy->rsp), (void *)payload, sizeof(nvdla_dma_rd_rsp_t));
    // if ( ! cvif2sdp_n_rd_rsp_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::cvif2sdp_n_rd_rsp_b_transport, ERROR, FIFO cvif2sdp_n_rd_rsp_fifo is stuck." << endl;
    // }
    cvif2sdp_n_rd_rsp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::cvif2sdp_n_rd_rsp_b_transport, push data to fifo\n"));
}

void NvdlaCoreInternalMonitor::sdp_e2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    // cslAssert(0 > sdp_e2cvif_rd_req_credit_);
    switch (sdp_e2cvif_rd_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::sdp_e2cvif_rd_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::sdp_e2cvif_rd_req_b_transport, working mode is pass through, directly forward\n"));
            sdp_e2cvif_rd_req_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == sdp_e2cvif_rd_req_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp_e2cvif_rd_req_b_transport, wait credit update event, halt CMOD\n"));
                wait(sdp_e2cvif_rd_req_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp_e2cvif_rd_req_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::sdp_e2cvif_rd_req_b_transport, credit is not zero\n"));
            sdp_e2cvif_rd_req_credit_mutex_.lock();
            sdp_e2cvif_rd_req_b_transport(ID, payload, delay);
            sdp_e2cvif_rd_req_credit_--;
            sdp_e2cvif_rd_req_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::sdp_e2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_SDP_E_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_rd_req_t));
    // if ( ! sdp_e2cvif_rd_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::sdp_e2cvif_rd_req_b_transport, ERROR, FIFO sdp_e2cvif_rd_req_fifo is stuck." << endl;
    // } else {
    //     cslDebug((70, "NvdlaCoreInternalMonitor::sdp_e2cvif_rd_req_b_transport:\n"));
    //     cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    //     cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    // }
    sdp_e2cvif_rd_req_fifo_->write(payload_copy);
    cslDebug((70, "NvdlaCoreInternalMonitor::sdp_e2cvif_rd_req_b_transport:\n"));
    cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    cslDebug((50, "NvdlaCoreInternalMonitor::sdp_e2cvif_rd_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::cvif2sdp_e_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    // cslAssert(0 > cvif2sdp_e_rd_rsp_credit_);
    switch (cvif2sdp_e_rd_rsp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::cvif2sdp_e_rd_rsp_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::cvif2sdp_e_rd_rsp_b_transport, working mode is not sampling, directly forward\n"));
            cvif2sdp_e_rd_rsp_b_transport(ID, payload, delay);
            break;
        default:
            // For response transaction, will not add gating mechenism
            cvif2sdp_e_rd_rsp_b_transport(ID, payload, delay);
            // while (0 == cvif2sdp_e_rd_rsp_credit_) {
            //     cslDebug((50, "NvdlaCoreInternalMonitor::cvif2sdp_e_rd_rsp_b_transport, wait credit update event, halt CMOD\n"));
            //     wait(cvif2sdp_e_rd_rsp_credit_update_event_);
            //     cslDebug((50, "NvdlaCoreInternalMonitor::cvif2sdp_e_rd_rsp_b_transport, got credit update event, unhalt cmod\n"));
            // }
            // cslDebug((50, "NvdlaCoreInternalMonitor::cvif2sdp_e_rd_rsp_b_transport, credit is not zero\n"));
            // cvif2sdp_e_rd_rsp_credit_mutex_.lock();
            // cvif2sdp_e_rd_rsp_b_transport(ID, payload, delay);
            // cvif2sdp_e_rd_rsp_credit_--;
            // cvif2sdp_e_rd_rsp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::cvif2sdp_e_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_SDP_E_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
    cslDebug((70, "NvdlaCoreInternalMonitor::cvif2sdp_e_rd_rsp_b_transport, dma_id: 0x%x\n", uint32_t(payload_copy->dma_id) ));
    cslDebug((70, "NvdlaCoreInternalMonitor::cvif2sdp_e_rd_rsp_b_transport, status: 0x%x\n", uint32_t(payload_copy->status) ));
    memcpy ((void *)(&payload_copy->rsp), (void *)payload, sizeof(nvdla_dma_rd_rsp_t));
    // if ( ! cvif2sdp_e_rd_rsp_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::cvif2sdp_e_rd_rsp_b_transport, ERROR, FIFO cvif2sdp_e_rd_rsp_fifo is stuck." << endl;
    // }
    cvif2sdp_e_rd_rsp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::cvif2sdp_e_rd_rsp_b_transport, push data to fifo\n"));
}

void NvdlaCoreInternalMonitor::cdma_dat2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    // cslAssert(0 > cdma_dat2cvif_rd_req_credit_);
    switch (cdma_dat2cvif_rd_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::cdma_dat2cvif_rd_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::cdma_dat2cvif_rd_req_b_transport, working mode is pass through, directly forward\n"));
            cdma_dat2cvif_rd_req_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == cdma_dat2cvif_rd_req_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::cdma_dat2cvif_rd_req_b_transport, wait credit update event, halt CMOD\n"));
                wait(cdma_dat2cvif_rd_req_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::cdma_dat2cvif_rd_req_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::cdma_dat2cvif_rd_req_b_transport, credit is not zero\n"));
            cdma_dat2cvif_rd_req_credit_mutex_.lock();
            cdma_dat2cvif_rd_req_b_transport(ID, payload, delay);
            cdma_dat2cvif_rd_req_credit_--;
            cdma_dat2cvif_rd_req_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::cdma_dat2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_CDMA_DAT_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_rd_req_t));
    // if ( ! cdma_dat2cvif_rd_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::cdma_dat2cvif_rd_req_b_transport, ERROR, FIFO cdma_dat2cvif_rd_req_fifo is stuck." << endl;
    // } else {
    //     cslDebug((70, "NvdlaCoreInternalMonitor::cdma_dat2cvif_rd_req_b_transport:\n"));
    //     cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    //     cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    // }
    cdma_dat2cvif_rd_req_fifo_->write(payload_copy);
    cslDebug((70, "NvdlaCoreInternalMonitor::cdma_dat2cvif_rd_req_b_transport:\n"));
    cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    cslDebug((50, "NvdlaCoreInternalMonitor::cdma_dat2cvif_rd_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::cvif2cdma_dat_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    // cslAssert(0 > cvif2cdma_dat_rd_rsp_credit_);
    switch (cvif2cdma_dat_rd_rsp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::cvif2cdma_dat_rd_rsp_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::cvif2cdma_dat_rd_rsp_b_transport, working mode is not sampling, directly forward\n"));
            cvif2cdma_dat_rd_rsp_b_transport(ID, payload, delay);
            break;
        default:
            // For response transaction, will not add gating mechenism
            cvif2cdma_dat_rd_rsp_b_transport(ID, payload, delay);
            // while (0 == cvif2cdma_dat_rd_rsp_credit_) {
            //     cslDebug((50, "NvdlaCoreInternalMonitor::cvif2cdma_dat_rd_rsp_b_transport, wait credit update event, halt CMOD\n"));
            //     wait(cvif2cdma_dat_rd_rsp_credit_update_event_);
            //     cslDebug((50, "NvdlaCoreInternalMonitor::cvif2cdma_dat_rd_rsp_b_transport, got credit update event, unhalt cmod\n"));
            // }
            // cslDebug((50, "NvdlaCoreInternalMonitor::cvif2cdma_dat_rd_rsp_b_transport, credit is not zero\n"));
            // cvif2cdma_dat_rd_rsp_credit_mutex_.lock();
            // cvif2cdma_dat_rd_rsp_b_transport(ID, payload, delay);
            // cvif2cdma_dat_rd_rsp_credit_--;
            // cvif2cdma_dat_rd_rsp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::cvif2cdma_dat_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_CDMA_DAT_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
    cslDebug((70, "NvdlaCoreInternalMonitor::cvif2cdma_dat_rd_rsp_b_transport, dma_id: 0x%x\n", uint32_t(payload_copy->dma_id) ));
    cslDebug((70, "NvdlaCoreInternalMonitor::cvif2cdma_dat_rd_rsp_b_transport, status: 0x%x\n", uint32_t(payload_copy->status) ));
    memcpy ((void *)(&payload_copy->rsp), (void *)payload, sizeof(nvdla_dma_rd_rsp_t));
    // if ( ! cvif2cdma_dat_rd_rsp_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::cvif2cdma_dat_rd_rsp_b_transport, ERROR, FIFO cvif2cdma_dat_rd_rsp_fifo is stuck." << endl;
    // }
    cvif2cdma_dat_rd_rsp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::cvif2cdma_dat_rd_rsp_b_transport, push data to fifo\n"));
}

void NvdlaCoreInternalMonitor::cdma_wt2cvif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    // cslAssert(0 > cdma_wt2cvif_rd_req_credit_);
    switch (cdma_wt2cvif_rd_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::cdma_wt2cvif_rd_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::cdma_wt2cvif_rd_req_b_transport, working mode is pass through, directly forward\n"));
            cdma_wt2cvif_rd_req_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == cdma_wt2cvif_rd_req_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::cdma_wt2cvif_rd_req_b_transport, wait credit update event, halt CMOD\n"));
                wait(cdma_wt2cvif_rd_req_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::cdma_wt2cvif_rd_req_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::cdma_wt2cvif_rd_req_b_transport, credit is not zero\n"));
            cdma_wt2cvif_rd_req_credit_mutex_.lock();
            cdma_wt2cvif_rd_req_b_transport(ID, payload, delay);
            cdma_wt2cvif_rd_req_credit_--;
            cdma_wt2cvif_rd_req_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::cdma_wt2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_CDMA_WT_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_rd_req_t));
    // if ( ! cdma_wt2cvif_rd_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::cdma_wt2cvif_rd_req_b_transport, ERROR, FIFO cdma_wt2cvif_rd_req_fifo is stuck." << endl;
    // } else {
    //     cslDebug((70, "NvdlaCoreInternalMonitor::cdma_wt2cvif_rd_req_b_transport:\n"));
    //     cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    //     cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    // }
    cdma_wt2cvif_rd_req_fifo_->write(payload_copy);
    cslDebug((70, "NvdlaCoreInternalMonitor::cdma_wt2cvif_rd_req_b_transport:\n"));
    cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    cslDebug((50, "NvdlaCoreInternalMonitor::cdma_wt2cvif_rd_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::cvif2cdma_wt_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    // cslAssert(0 > cvif2cdma_wt_rd_rsp_credit_);
    switch (cvif2cdma_wt_rd_rsp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::cvif2cdma_wt_rd_rsp_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::cvif2cdma_wt_rd_rsp_b_transport, working mode is not sampling, directly forward\n"));
            cvif2cdma_wt_rd_rsp_b_transport(ID, payload, delay);
            break;
        default:
            // For response transaction, will not add gating mechenism
            cvif2cdma_wt_rd_rsp_b_transport(ID, payload, delay);
            // while (0 == cvif2cdma_wt_rd_rsp_credit_) {
            //     cslDebug((50, "NvdlaCoreInternalMonitor::cvif2cdma_wt_rd_rsp_b_transport, wait credit update event, halt CMOD\n"));
            //     wait(cvif2cdma_wt_rd_rsp_credit_update_event_);
            //     cslDebug((50, "NvdlaCoreInternalMonitor::cvif2cdma_wt_rd_rsp_b_transport, got credit update event, unhalt cmod\n"));
            // }
            // cslDebug((50, "NvdlaCoreInternalMonitor::cvif2cdma_wt_rd_rsp_b_transport, credit is not zero\n"));
            // cvif2cdma_wt_rd_rsp_credit_mutex_.lock();
            // cvif2cdma_wt_rd_rsp_b_transport(ID, payload, delay);
            // cvif2cdma_wt_rd_rsp_credit_--;
            // cvif2cdma_wt_rd_rsp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::cvif2cdma_wt_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_CDMA_WT_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
    cslDebug((70, "NvdlaCoreInternalMonitor::cvif2cdma_wt_rd_rsp_b_transport, dma_id: 0x%x\n", uint32_t(payload_copy->dma_id) ));
    cslDebug((70, "NvdlaCoreInternalMonitor::cvif2cdma_wt_rd_rsp_b_transport, status: 0x%x\n", uint32_t(payload_copy->status) ));
    memcpy ((void *)(&payload_copy->rsp), (void *)payload, sizeof(nvdla_dma_rd_rsp_t));
    // if ( ! cvif2cdma_wt_rd_rsp_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::cvif2cdma_wt_rd_rsp_b_transport, ERROR, FIFO cvif2cdma_wt_rd_rsp_fifo is stuck." << endl;
    // }
    cvif2cdma_wt_rd_rsp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::cvif2cdma_wt_rd_rsp_b_transport, push data to fifo\n"));
}

void NvdlaCoreInternalMonitor::bdma2cvif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_wr_req_t* payload = (nvdla_dma_wr_req_t*) bp.get_data_ptr();
    // cslAssert(0 > bdma2cvif_wr_req_credit_);
    switch (bdma2cvif_wr_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::bdma2cvif_wr_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::bdma2cvif_wr_req_b_transport, working mode is pass through, directly forward\n"));
            bdma2cvif_wr_req_b_transport(ID, payload, delay);
            break;
        default:
            if (TAG_DATA == payload->tag) {
                // Data frame, will not be blocked
                bdma2cvif_wr_req_b_transport(ID, payload, delay);
            } else {
                while (0 == bdma2cvif_wr_req_credit_) {
                    cslDebug((50, "NvdlaCoreInternalMonitor::bdma2cvif_wr_req_b_transport, wait credit update event, halt CMOD\n"));
                    wait(bdma2cvif_wr_req_credit_update_event_);
                    cslDebug((50, "NvdlaCoreInternalMonitor::bdma2cvif_wr_req_b_transport, got credit update event, unhalt cmod\n"));
                }
                cslDebug((50, "NvdlaCoreInternalMonitor::bdma2cvif_wr_req_b_transport, credit is not zero\n"));
                bdma2cvif_wr_req_credit_mutex_.lock();
                bdma2cvif_wr_req_b_transport(ID, payload, delay);
                bdma2cvif_wr_req_credit_--;
                bdma2cvif_wr_req_credit_mutex_.unlock();
                cslDebug((50, "NvdlaCoreInternalMonitor::bdma2cvif_wr_req_b_transport, pushed data to fifo\n"));
            }
            break;
    }
}

void NvdlaCoreInternalMonitor::bdma2cvif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) {
    nvdla_monitor_dma_wr_transaction_t *payload_copy = new nvdla_monitor_dma_wr_transaction_t;
    payload_copy->dma_id = CV_BDMA_WRITE_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_wr_req_t));
    // if ( ! bdma2cvif_wr_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::bdma2cvif_wr_req_b_transport, ERROR, FIFO bdma2cvif_wr_req_fifo is stuck." << endl;
    // }
    bdma2cvif_wr_req_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::bdma2cvif_wr_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::sdp2cvif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_wr_req_t* payload = (nvdla_dma_wr_req_t*) bp.get_data_ptr();
    // cslAssert(0 > sdp2cvif_wr_req_credit_);
    switch (sdp2cvif_wr_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::sdp2cvif_wr_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::sdp2cvif_wr_req_b_transport, working mode is pass through, directly forward\n"));
            sdp2cvif_wr_req_b_transport(ID, payload, delay);
            break;
        default:
            if (TAG_DATA == payload->tag) {
                // Data frame, will not be blocked
                sdp2cvif_wr_req_b_transport(ID, payload, delay);
            } else {
                while (0 == sdp2cvif_wr_req_credit_) {
                    cslDebug((50, "NvdlaCoreInternalMonitor::sdp2cvif_wr_req_b_transport, wait credit update event, halt CMOD\n"));
                    wait(sdp2cvif_wr_req_credit_update_event_);
                    cslDebug((50, "NvdlaCoreInternalMonitor::sdp2cvif_wr_req_b_transport, got credit update event, unhalt cmod\n"));
                }
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp2cvif_wr_req_b_transport, credit is not zero\n"));
                sdp2cvif_wr_req_credit_mutex_.lock();
                sdp2cvif_wr_req_b_transport(ID, payload, delay);
                sdp2cvif_wr_req_credit_--;
                sdp2cvif_wr_req_credit_mutex_.unlock();
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp2cvif_wr_req_b_transport, pushed data to fifo\n"));
            }
            break;
    }
}

void NvdlaCoreInternalMonitor::sdp2cvif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) {
    nvdla_monitor_dma_wr_transaction_t *payload_copy = new nvdla_monitor_dma_wr_transaction_t;
    payload_copy->dma_id = CV_SDP_WRITE_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_wr_req_t));
    // if ( ! sdp2cvif_wr_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::sdp2cvif_wr_req_b_transport, ERROR, FIFO sdp2cvif_wr_req_fifo is stuck." << endl;
    // }
    sdp2cvif_wr_req_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::sdp2cvif_wr_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::pdp2cvif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_wr_req_t* payload = (nvdla_dma_wr_req_t*) bp.get_data_ptr();
    // cslAssert(0 > pdp2cvif_wr_req_credit_);
    switch (pdp2cvif_wr_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::pdp2cvif_wr_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::pdp2cvif_wr_req_b_transport, working mode is pass through, directly forward\n"));
            pdp2cvif_wr_req_b_transport(ID, payload, delay);
            break;
        default:
            if (TAG_DATA == payload->tag) {
                // Data frame, will not be blocked
                pdp2cvif_wr_req_b_transport(ID, payload, delay);
            } else {
                while (0 == pdp2cvif_wr_req_credit_) {
                    cslDebug((50, "NvdlaCoreInternalMonitor::pdp2cvif_wr_req_b_transport, wait credit update event, halt CMOD\n"));
                    wait(pdp2cvif_wr_req_credit_update_event_);
                    cslDebug((50, "NvdlaCoreInternalMonitor::pdp2cvif_wr_req_b_transport, got credit update event, unhalt cmod\n"));
                }
                cslDebug((50, "NvdlaCoreInternalMonitor::pdp2cvif_wr_req_b_transport, credit is not zero\n"));
                pdp2cvif_wr_req_credit_mutex_.lock();
                pdp2cvif_wr_req_b_transport(ID, payload, delay);
                pdp2cvif_wr_req_credit_--;
                pdp2cvif_wr_req_credit_mutex_.unlock();
                cslDebug((50, "NvdlaCoreInternalMonitor::pdp2cvif_wr_req_b_transport, pushed data to fifo\n"));
            }
            break;
    }
}

void NvdlaCoreInternalMonitor::pdp2cvif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) {
    nvdla_monitor_dma_wr_transaction_t *payload_copy = new nvdla_monitor_dma_wr_transaction_t;
    payload_copy->dma_id = CV_PDP_WRITE_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_wr_req_t));
    // if ( ! pdp2cvif_wr_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::pdp2cvif_wr_req_b_transport, ERROR, FIFO pdp2cvif_wr_req_fifo is stuck." << endl;
    // }
    pdp2cvif_wr_req_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::pdp2cvif_wr_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::cdp2cvif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_wr_req_t* payload = (nvdla_dma_wr_req_t*) bp.get_data_ptr();
    // cslAssert(0 > cdp2cvif_wr_req_credit_);
    switch (cdp2cvif_wr_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::cdp2cvif_wr_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::cdp2cvif_wr_req_b_transport, working mode is pass through, directly forward\n"));
            cdp2cvif_wr_req_b_transport(ID, payload, delay);
            break;
        default:
            if (TAG_DATA == payload->tag) {
                // Data frame, will not be blocked
                cdp2cvif_wr_req_b_transport(ID, payload, delay);
            } else {
                while (0 == cdp2cvif_wr_req_credit_) {
                    cslDebug((50, "NvdlaCoreInternalMonitor::cdp2cvif_wr_req_b_transport, wait credit update event, halt CMOD\n"));
                    wait(cdp2cvif_wr_req_credit_update_event_);
                    cslDebug((50, "NvdlaCoreInternalMonitor::cdp2cvif_wr_req_b_transport, got credit update event, unhalt cmod\n"));
                }
                cslDebug((50, "NvdlaCoreInternalMonitor::cdp2cvif_wr_req_b_transport, credit is not zero\n"));
                cdp2cvif_wr_req_credit_mutex_.lock();
                cdp2cvif_wr_req_b_transport(ID, payload, delay);
                cdp2cvif_wr_req_credit_--;
                cdp2cvif_wr_req_credit_mutex_.unlock();
                cslDebug((50, "NvdlaCoreInternalMonitor::cdp2cvif_wr_req_b_transport, pushed data to fifo\n"));
            }
            break;
    }
}

void NvdlaCoreInternalMonitor::cdp2cvif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) {
    nvdla_monitor_dma_wr_transaction_t *payload_copy = new nvdla_monitor_dma_wr_transaction_t;
    payload_copy->dma_id = CV_CDP_WRITE_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_wr_req_t));
    // if ( ! cdp2cvif_wr_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::cdp2cvif_wr_req_b_transport, ERROR, FIFO cdp2cvif_wr_req_fifo is stuck." << endl;
    // }
    cdp2cvif_wr_req_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::cdp2cvif_wr_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::rbk2cvif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_wr_req_t* payload = (nvdla_dma_wr_req_t*) bp.get_data_ptr();
    // cslAssert(0 > rbk2cvif_wr_req_credit_);
    switch (rbk2cvif_wr_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::rbk2cvif_wr_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::rbk2cvif_wr_req_b_transport, working mode is pass through, directly forward\n"));
            rbk2cvif_wr_req_b_transport(ID, payload, delay);
            break;
        default:
            if (TAG_DATA == payload->tag) {
                // Data frame, will not be blocked
                rbk2cvif_wr_req_b_transport(ID, payload, delay);
            } else {
                while (0 == rbk2cvif_wr_req_credit_) {
                    cslDebug((50, "NvdlaCoreInternalMonitor::rbk2cvif_wr_req_b_transport, wait credit update event, halt CMOD\n"));
                    wait(rbk2cvif_wr_req_credit_update_event_);
                    cslDebug((50, "NvdlaCoreInternalMonitor::rbk2cvif_wr_req_b_transport, got credit update event, unhalt cmod\n"));
                }
                cslDebug((50, "NvdlaCoreInternalMonitor::rbk2cvif_wr_req_b_transport, credit is not zero\n"));
                rbk2cvif_wr_req_credit_mutex_.lock();
                rbk2cvif_wr_req_b_transport(ID, payload, delay);
                rbk2cvif_wr_req_credit_--;
                rbk2cvif_wr_req_credit_mutex_.unlock();
                cslDebug((50, "NvdlaCoreInternalMonitor::rbk2cvif_wr_req_b_transport, pushed data to fifo\n"));
            }
            break;
    }
}

void NvdlaCoreInternalMonitor::rbk2cvif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) {
    nvdla_monitor_dma_wr_transaction_t *payload_copy = new nvdla_monitor_dma_wr_transaction_t;
    payload_copy->dma_id = CV_RBK_WRITE_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_wr_req_t));
    // if ( ! rbk2cvif_wr_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::rbk2cvif_wr_req_b_transport, ERROR, FIFO rbk2cvif_wr_req_fifo is stuck." << endl;
    // }
    rbk2cvif_wr_req_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::rbk2cvif_wr_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::bdma2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    // cslAssert(0 > bdma2mcif_rd_req_credit_);
    switch (bdma2mcif_rd_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::bdma2mcif_rd_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::bdma2mcif_rd_req_b_transport, working mode is pass through, directly forward\n"));
            bdma2mcif_rd_req_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == bdma2mcif_rd_req_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::bdma2mcif_rd_req_b_transport, wait credit update event, halt CMOD\n"));
                wait(bdma2mcif_rd_req_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::bdma2mcif_rd_req_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::bdma2mcif_rd_req_b_transport, credit is not zero\n"));
            bdma2mcif_rd_req_credit_mutex_.lock();
            bdma2mcif_rd_req_b_transport(ID, payload, delay);
            bdma2mcif_rd_req_credit_--;
            bdma2mcif_rd_req_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::bdma2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_BDMA_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_rd_req_t));
    // if ( ! bdma2mcif_rd_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::bdma2mcif_rd_req_b_transport, ERROR, FIFO bdma2mcif_rd_req_fifo is stuck." << endl;
    // } else {
    //     cslDebug((70, "NvdlaCoreInternalMonitor::bdma2mcif_rd_req_b_transport:\n"));
    //     cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    //     cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    // }
    bdma2mcif_rd_req_fifo_->write(payload_copy);
    cslDebug((70, "NvdlaCoreInternalMonitor::bdma2mcif_rd_req_b_transport:\n"));
    cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    cslDebug((50, "NvdlaCoreInternalMonitor::bdma2mcif_rd_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::mcif2bdma_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    // cslAssert(0 > mcif2bdma_rd_rsp_credit_);
    switch (mcif2bdma_rd_rsp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::mcif2bdma_rd_rsp_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::mcif2bdma_rd_rsp_b_transport, working mode is pass through, directly forward\n"));
            mcif2bdma_rd_rsp_b_transport(ID, payload, delay);
            break;
        default:
            // For response transaction, will not add gating mechenism
            mcif2bdma_rd_rsp_b_transport(ID, payload, delay);
            // while (0 == mcif2bdma_rd_rsp_credit_) {
            //     cslDebug((50, "NvdlaCoreInternalMonitor::mcif2bdma_rd_rsp_b_transport, wait credit update event, halt CMOD\n"));
            //     wait(mcif2bdma_rd_rsp_credit_update_event_);
            //     cslDebug((50, "NvdlaCoreInternalMonitor::mcif2bdma_rd_rsp_b_transport, got credit update event, unhalt cmod\n"));
            // }
            // cslDebug((50, "NvdlaCoreInternalMonitor::mcif2bdma_rd_rsp_b_transport, credit is not zero\n"));
            // mcif2bdma_rd_rsp_credit_mutex_.lock();
            // mcif2bdma_rd_rsp_b_transport(ID, payload, delay);
            // mcif2bdma_rd_rsp_credit_--;
            // mcif2bdma_rd_rsp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::mcif2bdma_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_BDMA_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
    cslDebug((70,"NvdlaCoreInternalMonitor::mcif2bdma_rd_rsp_b_transport, dma_id: 0x%x\n", uint32_t(payload_copy->dma_id) ));
    cslDebug((70,"NvdlaCoreInternalMonitor::mcif2bdma_rd_rsp_b_transport, status: 0x%x\n", uint32_t(payload_copy->status) ));
    memcpy ((void *)(&payload_copy->rsp), (void *)payload, sizeof(nvdla_dma_rd_rsp_t));
    // if ( ! mcif2bdma_rd_rsp_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::mcif2bdma_rd_rsp_b_transport, ERROR, FIFO mcif2bdma_rd_rsp_fifo is stuck." << endl;
    // }
    mcif2bdma_rd_rsp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::mcif2bdma_rd_rsp_b_transport, push data to fifo\n"));
}

void NvdlaCoreInternalMonitor::sdp2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    // cslAssert(0 > sdp2mcif_rd_req_credit_);
    switch (sdp2mcif_rd_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::sdp2mcif_rd_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::sdp2mcif_rd_req_b_transport, working mode is pass through, directly forward\n"));
            sdp2mcif_rd_req_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == sdp2mcif_rd_req_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp2mcif_rd_req_b_transport, wait credit update event, halt CMOD\n"));
                wait(sdp2mcif_rd_req_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp2mcif_rd_req_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::sdp2mcif_rd_req_b_transport, credit is not zero\n"));
            sdp2mcif_rd_req_credit_mutex_.lock();
            sdp2mcif_rd_req_b_transport(ID, payload, delay);
            sdp2mcif_rd_req_credit_--;
            sdp2mcif_rd_req_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::sdp2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_SDP_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_rd_req_t));
    // if ( ! sdp2mcif_rd_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::sdp2mcif_rd_req_b_transport, ERROR, FIFO sdp2mcif_rd_req_fifo is stuck." << endl;
    // } else {
    //     cslDebug((70, "NvdlaCoreInternalMonitor::sdp2mcif_rd_req_b_transport:\n"));
    //     cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    //     cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    // }
    sdp2mcif_rd_req_fifo_->write(payload_copy);
    cslDebug((70, "NvdlaCoreInternalMonitor::sdp2mcif_rd_req_b_transport:\n"));
    cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    cslDebug((50, "NvdlaCoreInternalMonitor::sdp2mcif_rd_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::mcif2sdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    // cslAssert(0 > mcif2sdp_rd_rsp_credit_);
    switch (mcif2sdp_rd_rsp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::mcif2sdp_rd_rsp_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::mcif2sdp_rd_rsp_b_transport, working mode is pass through, directly forward\n"));
            mcif2sdp_rd_rsp_b_transport(ID, payload, delay);
            break;
        default:
            // For response transaction, will not add gating mechenism
            mcif2sdp_rd_rsp_b_transport(ID, payload, delay);
            // while (0 == mcif2sdp_rd_rsp_credit_) {
            //     cslDebug((50, "NvdlaCoreInternalMonitor::mcif2sdp_rd_rsp_b_transport, wait credit update event, halt CMOD\n"));
            //     wait(mcif2sdp_rd_rsp_credit_update_event_);
            //     cslDebug((50, "NvdlaCoreInternalMonitor::mcif2sdp_rd_rsp_b_transport, got credit update event, unhalt cmod\n"));
            // }
            // cslDebug((50, "NvdlaCoreInternalMonitor::mcif2sdp_rd_rsp_b_transport, credit is not zero\n"));
            // mcif2sdp_rd_rsp_credit_mutex_.lock();
            // mcif2sdp_rd_rsp_b_transport(ID, payload, delay);
            // mcif2sdp_rd_rsp_credit_--;
            // mcif2sdp_rd_rsp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::mcif2sdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_SDP_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
    cslDebug((70,"NvdlaCoreInternalMonitor::mcif2sdp_rd_rsp_b_transport, dma_id: 0x%x\n", uint32_t(payload_copy->dma_id) ));
    cslDebug((70,"NvdlaCoreInternalMonitor::mcif2sdp_rd_rsp_b_transport, status: 0x%x\n", uint32_t(payload_copy->status) ));
    memcpy ((void *)(&payload_copy->rsp), (void *)payload, sizeof(nvdla_dma_rd_rsp_t));
    // if ( ! mcif2sdp_rd_rsp_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::mcif2sdp_rd_rsp_b_transport, ERROR, FIFO mcif2sdp_rd_rsp_fifo is stuck." << endl;
    // }
    mcif2sdp_rd_rsp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::mcif2sdp_rd_rsp_b_transport, push data to fifo\n"));
}

void NvdlaCoreInternalMonitor::pdp2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    // cslAssert(0 > pdp2mcif_rd_req_credit_);
    switch (pdp2mcif_rd_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::pdp2mcif_rd_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::pdp2mcif_rd_req_b_transport, working mode is pass through, directly forward\n"));
            pdp2mcif_rd_req_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == pdp2mcif_rd_req_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::pdp2mcif_rd_req_b_transport, wait credit update event, halt CMOD\n"));
                wait(pdp2mcif_rd_req_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::pdp2mcif_rd_req_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::pdp2mcif_rd_req_b_transport, credit is not zero\n"));
            pdp2mcif_rd_req_credit_mutex_.lock();
            pdp2mcif_rd_req_b_transport(ID, payload, delay);
            pdp2mcif_rd_req_credit_--;
            pdp2mcif_rd_req_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::pdp2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_PDP_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_rd_req_t));
    // if ( ! pdp2mcif_rd_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::pdp2mcif_rd_req_b_transport, ERROR, FIFO pdp2mcif_rd_req_fifo is stuck." << endl;
    // } else {
    //     cslDebug((70, "NvdlaCoreInternalMonitor::pdp2mcif_rd_req_b_transport:\n"));
    //     cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    //     cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    // }
    pdp2mcif_rd_req_fifo_->write(payload_copy);
    cslDebug((70, "NvdlaCoreInternalMonitor::pdp2mcif_rd_req_b_transport:\n"));
    cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    cslDebug((50, "NvdlaCoreInternalMonitor::pdp2mcif_rd_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::mcif2pdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    // cslAssert(0 > mcif2pdp_rd_rsp_credit_);
    switch (mcif2pdp_rd_rsp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::mcif2pdp_rd_rsp_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::mcif2pdp_rd_rsp_b_transport, working mode is pass through, directly forward\n"));
            mcif2pdp_rd_rsp_b_transport(ID, payload, delay);
            break;
        default:
            // For response transaction, will not add gating mechenism
            mcif2pdp_rd_rsp_b_transport(ID, payload, delay);
            // while (0 == mcif2pdp_rd_rsp_credit_) {
            //     cslDebug((50, "NvdlaCoreInternalMonitor::mcif2pdp_rd_rsp_b_transport, wait credit update event, halt CMOD\n"));
            //     wait(mcif2pdp_rd_rsp_credit_update_event_);
            //     cslDebug((50, "NvdlaCoreInternalMonitor::mcif2pdp_rd_rsp_b_transport, got credit update event, unhalt cmod\n"));
            // }
            // cslDebug((50, "NvdlaCoreInternalMonitor::mcif2pdp_rd_rsp_b_transport, credit is not zero\n"));
            // mcif2pdp_rd_rsp_credit_mutex_.lock();
            // mcif2pdp_rd_rsp_b_transport(ID, payload, delay);
            // mcif2pdp_rd_rsp_credit_--;
            // mcif2pdp_rd_rsp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::mcif2pdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_PDP_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
    cslDebug((70,"NvdlaCoreInternalMonitor::mcif2pdp_rd_rsp_b_transport, dma_id: 0x%x\n", uint32_t(payload_copy->dma_id) ));
    cslDebug((70,"NvdlaCoreInternalMonitor::mcif2pdp_rd_rsp_b_transport, status: 0x%x\n", uint32_t(payload_copy->status) ));
    memcpy ((void *)(&payload_copy->rsp), (void *)payload, sizeof(nvdla_dma_rd_rsp_t));
    // if ( ! mcif2pdp_rd_rsp_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::mcif2pdp_rd_rsp_b_transport, ERROR, FIFO mcif2pdp_rd_rsp_fifo is stuck." << endl;
    // }
    mcif2pdp_rd_rsp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::mcif2pdp_rd_rsp_b_transport, push data to fifo\n"));
}

void NvdlaCoreInternalMonitor::cdp2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    // cslAssert(0 > cdp2mcif_rd_req_credit_);
    switch (cdp2mcif_rd_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::cdp2mcif_rd_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::cdp2mcif_rd_req_b_transport, working mode is pass through, directly forward\n"));
            cdp2mcif_rd_req_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == cdp2mcif_rd_req_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::cdp2mcif_rd_req_b_transport, wait credit update event, halt CMOD\n"));
                wait(cdp2mcif_rd_req_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::cdp2mcif_rd_req_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::cdp2mcif_rd_req_b_transport, credit is not zero\n"));
            cdp2mcif_rd_req_credit_mutex_.lock();
            cdp2mcif_rd_req_b_transport(ID, payload, delay);
            cdp2mcif_rd_req_credit_--;
            cdp2mcif_rd_req_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::cdp2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_CDP_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_rd_req_t));
    // if ( ! cdp2mcif_rd_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::cdp2mcif_rd_req_b_transport, ERROR, FIFO cdp2mcif_rd_req_fifo is stuck." << endl;
    // } else {
    //     cslDebug((70, "NvdlaCoreInternalMonitor::cdp2mcif_rd_req_b_transport:\n"));
    //     cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    //     cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    // }
    cdp2mcif_rd_req_fifo_->write(payload_copy);
    cslDebug((70, "NvdlaCoreInternalMonitor::cdp2mcif_rd_req_b_transport:\n"));
    cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    cslDebug((50, "NvdlaCoreInternalMonitor::cdp2mcif_rd_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::mcif2cdp_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    // cslAssert(0 > mcif2cdp_rd_rsp_credit_);
    switch (mcif2cdp_rd_rsp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::mcif2cdp_rd_rsp_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::mcif2cdp_rd_rsp_b_transport, working mode is pass through, directly forward\n"));
            mcif2cdp_rd_rsp_b_transport(ID, payload, delay);
            break;
        default:
            // For response transaction, will not add gating mechenism
            mcif2cdp_rd_rsp_b_transport(ID, payload, delay);
            // while (0 == mcif2cdp_rd_rsp_credit_) {
            //     cslDebug((50, "NvdlaCoreInternalMonitor::mcif2cdp_rd_rsp_b_transport, wait credit update event, halt CMOD\n"));
            //     wait(mcif2cdp_rd_rsp_credit_update_event_);
            //     cslDebug((50, "NvdlaCoreInternalMonitor::mcif2cdp_rd_rsp_b_transport, got credit update event, unhalt cmod\n"));
            // }
            // cslDebug((50, "NvdlaCoreInternalMonitor::mcif2cdp_rd_rsp_b_transport, credit is not zero\n"));
            // mcif2cdp_rd_rsp_credit_mutex_.lock();
            // mcif2cdp_rd_rsp_b_transport(ID, payload, delay);
            // mcif2cdp_rd_rsp_credit_--;
            // mcif2cdp_rd_rsp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::mcif2cdp_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_CDP_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
    cslDebug((70,"NvdlaCoreInternalMonitor::mcif2cdp_rd_rsp_b_transport, dma_id: 0x%x\n", uint32_t(payload_copy->dma_id) ));
    cslDebug((70,"NvdlaCoreInternalMonitor::mcif2cdp_rd_rsp_b_transport, status: 0x%x\n", uint32_t(payload_copy->status) ));
    memcpy ((void *)(&payload_copy->rsp), (void *)payload, sizeof(nvdla_dma_rd_rsp_t));
    // if ( ! mcif2cdp_rd_rsp_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::mcif2cdp_rd_rsp_b_transport, ERROR, FIFO mcif2cdp_rd_rsp_fifo is stuck." << endl;
    // }
    mcif2cdp_rd_rsp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::mcif2cdp_rd_rsp_b_transport, push data to fifo\n"));
}

void NvdlaCoreInternalMonitor::rbk2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    // cslAssert(0 > rbk2mcif_rd_req_credit_);
    switch (rbk2mcif_rd_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::rbk2mcif_rd_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::rbk2mcif_rd_req_b_transport, working mode is pass through, directly forward\n"));
            rbk2mcif_rd_req_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == rbk2mcif_rd_req_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::rbk2mcif_rd_req_b_transport, wait credit update event, halt CMOD\n"));
                wait(rbk2mcif_rd_req_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::rbk2mcif_rd_req_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::rbk2mcif_rd_req_b_transport, credit is not zero\n"));
            rbk2mcif_rd_req_credit_mutex_.lock();
            rbk2mcif_rd_req_b_transport(ID, payload, delay);
            rbk2mcif_rd_req_credit_--;
            rbk2mcif_rd_req_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::rbk2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_RBK_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_rd_req_t));
    // if ( ! rbk2mcif_rd_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::rbk2mcif_rd_req_b_transport, ERROR, FIFO rbk2mcif_rd_req_fifo is stuck." << endl;
    // } else {
    //     cslDebug((70, "NvdlaCoreInternalMonitor::rbk2mcif_rd_req_b_transport:\n"));
    //     cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    //     cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    // }
    rbk2mcif_rd_req_fifo_->write(payload_copy);
    cslDebug((70, "NvdlaCoreInternalMonitor::rbk2mcif_rd_req_b_transport:\n"));
    cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    cslDebug((50, "NvdlaCoreInternalMonitor::rbk2mcif_rd_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::mcif2rbk_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    // cslAssert(0 > mcif2rbk_rd_rsp_credit_);
    switch (mcif2rbk_rd_rsp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::mcif2rbk_rd_rsp_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::mcif2rbk_rd_rsp_b_transport, working mode is pass through, directly forward\n"));
            mcif2rbk_rd_rsp_b_transport(ID, payload, delay);
            break;
        default:
            // For response transaction, will not add gating mechenism
            mcif2rbk_rd_rsp_b_transport(ID, payload, delay);
            // while (0 == mcif2rbk_rd_rsp_credit_) {
            //     cslDebug((50, "NvdlaCoreInternalMonitor::mcif2rbk_rd_rsp_b_transport, wait credit update event, halt CMOD\n"));
            //     wait(mcif2rbk_rd_rsp_credit_update_event_);
            //     cslDebug((50, "NvdlaCoreInternalMonitor::mcif2rbk_rd_rsp_b_transport, got credit update event, unhalt cmod\n"));
            // }
            // cslDebug((50, "NvdlaCoreInternalMonitor::mcif2rbk_rd_rsp_b_transport, credit is not zero\n"));
            // mcif2rbk_rd_rsp_credit_mutex_.lock();
            // mcif2rbk_rd_rsp_b_transport(ID, payload, delay);
            // mcif2rbk_rd_rsp_credit_--;
            // mcif2rbk_rd_rsp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::mcif2rbk_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_RBK_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
    cslDebug((70,"NvdlaCoreInternalMonitor::mcif2rbk_rd_rsp_b_transport, dma_id: 0x%x\n", uint32_t(payload_copy->dma_id) ));
    cslDebug((70,"NvdlaCoreInternalMonitor::mcif2rbk_rd_rsp_b_transport, status: 0x%x\n", uint32_t(payload_copy->status) ));
    memcpy ((void *)(&payload_copy->rsp), (void *)payload, sizeof(nvdla_dma_rd_rsp_t));
    // if ( ! mcif2rbk_rd_rsp_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::mcif2rbk_rd_rsp_b_transport, ERROR, FIFO mcif2rbk_rd_rsp_fifo is stuck." << endl;
    // }
    mcif2rbk_rd_rsp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::mcif2rbk_rd_rsp_b_transport, push data to fifo\n"));
}

void NvdlaCoreInternalMonitor::sdp_b2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    // cslAssert(0 > sdp_b2mcif_rd_req_credit_);
    switch (sdp_b2mcif_rd_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::sdp_b2mcif_rd_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::sdp_b2mcif_rd_req_b_transport, working mode is pass through, directly forward\n"));
            sdp_b2mcif_rd_req_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == sdp_b2mcif_rd_req_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp_b2mcif_rd_req_b_transport, wait credit update event, halt CMOD\n"));
                wait(sdp_b2mcif_rd_req_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp_b2mcif_rd_req_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::sdp_b2mcif_rd_req_b_transport, credit is not zero\n"));
            sdp_b2mcif_rd_req_credit_mutex_.lock();
            sdp_b2mcif_rd_req_b_transport(ID, payload, delay);
            sdp_b2mcif_rd_req_credit_--;
            sdp_b2mcif_rd_req_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::sdp_b2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_SDP_B_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_rd_req_t));
    // if ( ! sdp_b2mcif_rd_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::sdp_b2mcif_rd_req_b_transport, ERROR, FIFO sdp_b2mcif_rd_req_fifo is stuck." << endl;
    // } else {
    //     cslDebug((70, "NvdlaCoreInternalMonitor::sdp_b2mcif_rd_req_b_transport:\n"));
    //     cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    //     cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    // }
    sdp_b2mcif_rd_req_fifo_->write(payload_copy);
    cslDebug((70, "NvdlaCoreInternalMonitor::sdp_b2mcif_rd_req_b_transport:\n"));
    cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    cslDebug((50, "NvdlaCoreInternalMonitor::sdp_b2mcif_rd_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::mcif2sdp_b_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    // cslAssert(0 > mcif2sdp_b_rd_rsp_credit_);
    switch (mcif2sdp_b_rd_rsp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::mcif2sdp_b_rd_rsp_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::mcif2sdp_b_rd_rsp_b_transport, working mode is pass through, directly forward\n"));
            mcif2sdp_b_rd_rsp_b_transport(ID, payload, delay);
            break;
        default:
            // For response transaction, will not add gating mechenism
            mcif2sdp_b_rd_rsp_b_transport(ID, payload, delay);
            // while (0 == mcif2sdp_b_rd_rsp_credit_) {
            //     cslDebug((50, "NvdlaCoreInternalMonitor::mcif2sdp_b_rd_rsp_b_transport, wait credit update event, halt CMOD\n"));
            //     wait(mcif2sdp_b_rd_rsp_credit_update_event_);
            //     cslDebug((50, "NvdlaCoreInternalMonitor::mcif2sdp_b_rd_rsp_b_transport, got credit update event, unhalt cmod\n"));
            // }
            // cslDebug((50, "NvdlaCoreInternalMonitor::mcif2sdp_b_rd_rsp_b_transport, credit is not zero\n"));
            // mcif2sdp_b_rd_rsp_credit_mutex_.lock();
            // mcif2sdp_b_rd_rsp_b_transport(ID, payload, delay);
            // mcif2sdp_b_rd_rsp_credit_--;
            // mcif2sdp_b_rd_rsp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::mcif2sdp_b_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_SDP_B_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
    cslDebug((70,"NvdlaCoreInternalMonitor::mcif2sdp_b_rd_rsp_b_transport, dma_id: 0x%x\n", uint32_t(payload_copy->dma_id) ));
    cslDebug((70,"NvdlaCoreInternalMonitor::mcif2sdp_b_rd_rsp_b_transport, status: 0x%x\n", uint32_t(payload_copy->status) ));
    memcpy ((void *)(&payload_copy->rsp), (void *)payload, sizeof(nvdla_dma_rd_rsp_t));
    // if ( ! mcif2sdp_b_rd_rsp_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::mcif2sdp_b_rd_rsp_b_transport, ERROR, FIFO mcif2sdp_b_rd_rsp_fifo is stuck." << endl;
    // }
    mcif2sdp_b_rd_rsp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::mcif2sdp_b_rd_rsp_b_transport, push data to fifo\n"));
}

void NvdlaCoreInternalMonitor::sdp_n2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    // cslAssert(0 > sdp_n2mcif_rd_req_credit_);
    switch (sdp_n2mcif_rd_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::sdp_n2mcif_rd_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::sdp_n2mcif_rd_req_b_transport, working mode is pass through, directly forward\n"));
            sdp_n2mcif_rd_req_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == sdp_n2mcif_rd_req_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp_n2mcif_rd_req_b_transport, wait credit update event, halt CMOD\n"));
                wait(sdp_n2mcif_rd_req_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp_n2mcif_rd_req_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::sdp_n2mcif_rd_req_b_transport, credit is not zero\n"));
            sdp_n2mcif_rd_req_credit_mutex_.lock();
            sdp_n2mcif_rd_req_b_transport(ID, payload, delay);
            sdp_n2mcif_rd_req_credit_--;
            sdp_n2mcif_rd_req_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::sdp_n2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_SDP_N_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_rd_req_t));
    // if ( ! sdp_n2mcif_rd_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::sdp_n2mcif_rd_req_b_transport, ERROR, FIFO sdp_n2mcif_rd_req_fifo is stuck." << endl;
    // } else {
    //     cslDebug((70, "NvdlaCoreInternalMonitor::sdp_n2mcif_rd_req_b_transport:\n"));
    //     cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    //     cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    // }
    sdp_n2mcif_rd_req_fifo_->write(payload_copy);
    cslDebug((70, "NvdlaCoreInternalMonitor::sdp_n2mcif_rd_req_b_transport:\n"));
    cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    cslDebug((50, "NvdlaCoreInternalMonitor::sdp_n2mcif_rd_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::mcif2sdp_n_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    // cslAssert(0 > mcif2sdp_n_rd_rsp_credit_);
    switch (mcif2sdp_n_rd_rsp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::mcif2sdp_n_rd_rsp_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::mcif2sdp_n_rd_rsp_b_transport, working mode is pass through, directly forward\n"));
            mcif2sdp_n_rd_rsp_b_transport(ID, payload, delay);
            break;
        default:
            // For response transaction, will not add gating mechenism
            mcif2sdp_n_rd_rsp_b_transport(ID, payload, delay);
            // while (0 == mcif2sdp_n_rd_rsp_credit_) {
            //     cslDebug((50, "NvdlaCoreInternalMonitor::mcif2sdp_n_rd_rsp_b_transport, wait credit update event, halt CMOD\n"));
            //     wait(mcif2sdp_n_rd_rsp_credit_update_event_);
            //     cslDebug((50, "NvdlaCoreInternalMonitor::mcif2sdp_n_rd_rsp_b_transport, got credit update event, unhalt cmod\n"));
            // }
            // cslDebug((50, "NvdlaCoreInternalMonitor::mcif2sdp_n_rd_rsp_b_transport, credit is not zero\n"));
            // mcif2sdp_n_rd_rsp_credit_mutex_.lock();
            // mcif2sdp_n_rd_rsp_b_transport(ID, payload, delay);
            // mcif2sdp_n_rd_rsp_credit_--;
            // mcif2sdp_n_rd_rsp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::mcif2sdp_n_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_SDP_N_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
    cslDebug((70,"NvdlaCoreInternalMonitor::mcif2sdp_n_rd_rsp_b_transport, dma_id: 0x%x\n", uint32_t(payload_copy->dma_id) ));
    cslDebug((70,"NvdlaCoreInternalMonitor::mcif2sdp_n_rd_rsp_b_transport, status: 0x%x\n", uint32_t(payload_copy->status) ));
    memcpy ((void *)(&payload_copy->rsp), (void *)payload, sizeof(nvdla_dma_rd_rsp_t));
    // if ( ! mcif2sdp_n_rd_rsp_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::mcif2sdp_n_rd_rsp_b_transport, ERROR, FIFO mcif2sdp_n_rd_rsp_fifo is stuck." << endl;
    // }
    mcif2sdp_n_rd_rsp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::mcif2sdp_n_rd_rsp_b_transport, push data to fifo\n"));
}

void NvdlaCoreInternalMonitor::sdp_e2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    // cslAssert(0 > sdp_e2mcif_rd_req_credit_);
    switch (sdp_e2mcif_rd_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::sdp_e2mcif_rd_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::sdp_e2mcif_rd_req_b_transport, working mode is pass through, directly forward\n"));
            sdp_e2mcif_rd_req_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == sdp_e2mcif_rd_req_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp_e2mcif_rd_req_b_transport, wait credit update event, halt CMOD\n"));
                wait(sdp_e2mcif_rd_req_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp_e2mcif_rd_req_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::sdp_e2mcif_rd_req_b_transport, credit is not zero\n"));
            sdp_e2mcif_rd_req_credit_mutex_.lock();
            sdp_e2mcif_rd_req_b_transport(ID, payload, delay);
            sdp_e2mcif_rd_req_credit_--;
            sdp_e2mcif_rd_req_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::sdp_e2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_SDP_E_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_rd_req_t));
    // if ( ! sdp_e2mcif_rd_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::sdp_e2mcif_rd_req_b_transport, ERROR, FIFO sdp_e2mcif_rd_req_fifo is stuck." << endl;
    // } else {
    //     cslDebug((70, "NvdlaCoreInternalMonitor::sdp_e2mcif_rd_req_b_transport:\n"));
    //     cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    //     cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    // }
    sdp_e2mcif_rd_req_fifo_->write(payload_copy);
    cslDebug((70, "NvdlaCoreInternalMonitor::sdp_e2mcif_rd_req_b_transport:\n"));
    cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    cslDebug((50, "NvdlaCoreInternalMonitor::sdp_e2mcif_rd_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::mcif2sdp_e_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    // cslAssert(0 > mcif2sdp_e_rd_rsp_credit_);
    switch (mcif2sdp_e_rd_rsp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::mcif2sdp_e_rd_rsp_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::mcif2sdp_e_rd_rsp_b_transport, working mode is pass through, directly forward\n"));
            mcif2sdp_e_rd_rsp_b_transport(ID, payload, delay);
            break;
        default:
            // For response transaction, will not add gating mechenism
            mcif2sdp_e_rd_rsp_b_transport(ID, payload, delay);
            // while (0 == mcif2sdp_e_rd_rsp_credit_) {
            //     cslDebug((50, "NvdlaCoreInternalMonitor::mcif2sdp_e_rd_rsp_b_transport, wait credit update event, halt CMOD\n"));
            //     wait(mcif2sdp_e_rd_rsp_credit_update_event_);
            //     cslDebug((50, "NvdlaCoreInternalMonitor::mcif2sdp_e_rd_rsp_b_transport, got credit update event, unhalt cmod\n"));
            // }
            // cslDebug((50, "NvdlaCoreInternalMonitor::mcif2sdp_e_rd_rsp_b_transport, credit is not zero\n"));
            // mcif2sdp_e_rd_rsp_credit_mutex_.lock();
            // mcif2sdp_e_rd_rsp_b_transport(ID, payload, delay);
            // mcif2sdp_e_rd_rsp_credit_--;
            // mcif2sdp_e_rd_rsp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::mcif2sdp_e_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_SDP_E_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
    cslDebug((70,"NvdlaCoreInternalMonitor::mcif2sdp_e_rd_rsp_b_transport, dma_id: 0x%x\n", uint32_t(payload_copy->dma_id) ));
    cslDebug((70,"NvdlaCoreInternalMonitor::mcif2sdp_e_rd_rsp_b_transport, status: 0x%x\n", uint32_t(payload_copy->status) ));
    memcpy ((void *)(&payload_copy->rsp), (void *)payload, sizeof(nvdla_dma_rd_rsp_t));
    // if ( ! mcif2sdp_e_rd_rsp_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::mcif2sdp_e_rd_rsp_b_transport, ERROR, FIFO mcif2sdp_e_rd_rsp_fifo is stuck." << endl;
    // }
    mcif2sdp_e_rd_rsp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::mcif2sdp_e_rd_rsp_b_transport, push data to fifo\n"));
}

void NvdlaCoreInternalMonitor::cdma_dat2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    // cslAssert(0 > cdma_dat2mcif_rd_req_credit_);
    switch (cdma_dat2mcif_rd_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::cdma_dat2mcif_rd_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::cdma_dat2mcif_rd_req_b_transport, working mode is pass through, directly forward\n"));
            cdma_dat2mcif_rd_req_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == cdma_dat2mcif_rd_req_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::cdma_dat2mcif_rd_req_b_transport, wait credit update event, halt CMOD\n"));
                wait(cdma_dat2mcif_rd_req_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::cdma_dat2mcif_rd_req_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::cdma_dat2mcif_rd_req_b_transport, credit is not zero\n"));
            cdma_dat2mcif_rd_req_credit_mutex_.lock();
            cdma_dat2mcif_rd_req_b_transport(ID, payload, delay);
            cdma_dat2mcif_rd_req_credit_--;
            cdma_dat2mcif_rd_req_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::cdma_dat2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_CDMA_DAT_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_rd_req_t));
    // if ( ! cdma_dat2mcif_rd_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::cdma_dat2mcif_rd_req_b_transport, ERROR, FIFO cdma_dat2mcif_rd_req_fifo is stuck." << endl;
    // } else {
    //     cslDebug((70, "NvdlaCoreInternalMonitor::cdma_dat2mcif_rd_req_b_transport:\n"));
    //     cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    //     cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    // }
    cdma_dat2mcif_rd_req_fifo_->write(payload_copy);
    cslDebug((70, "NvdlaCoreInternalMonitor::cdma_dat2mcif_rd_req_b_transport:\n"));
    cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    cslDebug((50, "NvdlaCoreInternalMonitor::cdma_dat2mcif_rd_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::mcif2cdma_dat_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    // cslAssert(0 > mcif2cdma_dat_rd_rsp_credit_);
    switch (mcif2cdma_dat_rd_rsp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::mcif2cdma_dat_rd_rsp_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::mcif2cdma_dat_rd_rsp_b_transport, working mode is pass through, directly forward\n"));
            mcif2cdma_dat_rd_rsp_b_transport(ID, payload, delay);
            break;
        default:
            // For response transaction, will not add gating mechenism
            mcif2cdma_dat_rd_rsp_b_transport(ID, payload, delay);
            // while (0 == mcif2cdma_dat_rd_rsp_credit_) {
            //     cslDebug((50, "NvdlaCoreInternalMonitor::mcif2cdma_dat_rd_rsp_b_transport, wait credit update event, halt CMOD\n"));
            //     wait(mcif2cdma_dat_rd_rsp_credit_update_event_);
            //     cslDebug((50, "NvdlaCoreInternalMonitor::mcif2cdma_dat_rd_rsp_b_transport, got credit update event, unhalt cmod\n"));
            // }
            // cslDebug((50, "NvdlaCoreInternalMonitor::mcif2cdma_dat_rd_rsp_b_transport, credit is not zero\n"));
            // mcif2cdma_dat_rd_rsp_credit_mutex_.lock();
            // mcif2cdma_dat_rd_rsp_b_transport(ID, payload, delay);
            // mcif2cdma_dat_rd_rsp_credit_--;
            // mcif2cdma_dat_rd_rsp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::mcif2cdma_dat_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_CDMA_DAT_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
    cslDebug((70,"NvdlaCoreInternalMonitor::mcif2cdma_dat_rd_rsp_b_transport, dma_id: 0x%x\n", uint32_t(payload_copy->dma_id) ));
    cslDebug((70,"NvdlaCoreInternalMonitor::mcif2cdma_dat_rd_rsp_b_transport, status: 0x%x\n", uint32_t(payload_copy->status) ));
    memcpy ((void *)(&payload_copy->rsp), (void *)payload, sizeof(nvdla_dma_rd_rsp_t));
    // if ( ! mcif2cdma_dat_rd_rsp_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::mcif2cdma_dat_rd_rsp_b_transport, ERROR, FIFO mcif2cdma_dat_rd_rsp_fifo is stuck." << endl;
    // }
    mcif2cdma_dat_rd_rsp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::mcif2cdma_dat_rd_rsp_b_transport, push data to fifo\n"));
}

void NvdlaCoreInternalMonitor::cdma_wt2mcif_rd_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_req_t* payload = (nvdla_dma_rd_req_t*) bp.get_data_ptr();
    // cslAssert(0 > cdma_wt2mcif_rd_req_credit_);
    switch (cdma_wt2mcif_rd_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::cdma_wt2mcif_rd_req_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::cdma_wt2mcif_rd_req_b_transport, working mode is pass through, directly forward\n"));
            cdma_wt2mcif_rd_req_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == cdma_wt2mcif_rd_req_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::cdma_wt2mcif_rd_req_b_transport, wait credit update event, halt CMOD\n"));
                wait(cdma_wt2mcif_rd_req_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::cdma_wt2mcif_rd_req_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::cdma_wt2mcif_rd_req_b_transport, credit is not zero\n"));
            cdma_wt2mcif_rd_req_credit_mutex_.lock();
            cdma_wt2mcif_rd_req_b_transport(ID, payload, delay);
            cdma_wt2mcif_rd_req_credit_--;
            cdma_wt2mcif_rd_req_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::cdma_wt2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_CDMA_WT_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_rd_req_t));
    // if ( ! cdma_wt2mcif_rd_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::cdma_wt2mcif_rd_req_b_transport, ERROR, FIFO cdma_wt2mcif_rd_req_fifo is stuck." << endl;
    // } else {
    //     cslDebug((70, "NvdlaCoreInternalMonitor::cdma_wt2mcif_rd_req_b_transport:\n"));
    //     cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    //     cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    // }
    cdma_wt2mcif_rd_req_fifo_->write(payload_copy);
    cslDebug((70, "NvdlaCoreInternalMonitor::cdma_wt2mcif_rd_req_b_transport:\n"));
    cslDebug((70, "    Address: 0x%lx\n", payload->pd.dma_read_cmd.addr));
    cslDebug((70, "    Size: 0x%x\n",    payload->pd.dma_read_cmd.size));
    cslDebug((50, "NvdlaCoreInternalMonitor::cdma_wt2mcif_rd_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::mcif2cdma_wt_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_rd_rsp_t* payload = (nvdla_dma_rd_rsp_t*) bp.get_data_ptr();
    // cslAssert(0 > mcif2cdma_wt_rd_rsp_credit_);
    switch (mcif2cdma_wt_rd_rsp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::mcif2cdma_wt_rd_rsp_b_transport, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::mcif2cdma_wt_rd_rsp_b_transport, working mode is pass through, directly forward\n"));
            mcif2cdma_wt_rd_rsp_b_transport(ID, payload, delay);
            break;
        default:
            // For response transaction, will not add gating mechenism
            mcif2cdma_wt_rd_rsp_b_transport(ID, payload, delay);
            // while (0 == mcif2cdma_wt_rd_rsp_credit_) {
            //     cslDebug((50, "NvdlaCoreInternalMonitor::mcif2cdma_wt_rd_rsp_b_transport, wait credit update event, halt CMOD\n"));
            //     wait(mcif2cdma_wt_rd_rsp_credit_update_event_);
            //     cslDebug((50, "NvdlaCoreInternalMonitor::mcif2cdma_wt_rd_rsp_b_transport, got credit update event, unhalt cmod\n"));
            // }
            // cslDebug((50, "NvdlaCoreInternalMonitor::mcif2cdma_wt_rd_rsp_b_transport, credit is not zero\n"));
            // mcif2cdma_wt_rd_rsp_credit_mutex_.lock();
            // mcif2cdma_wt_rd_rsp_b_transport(ID, payload, delay);
            // mcif2cdma_wt_rd_rsp_credit_--;
            // mcif2cdma_wt_rd_rsp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::mcif2cdma_wt_rd_rsp_b_transport(int ID, nvdla_dma_rd_rsp_t* payload, sc_core::sc_time& delay){
    nvdla_monitor_dma_rd_transaction_t *payload_copy = new nvdla_monitor_dma_rd_transaction_t;
    payload_copy->dma_id = CV_CDMA_WT_READ_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
    cslDebug((70,"NvdlaCoreInternalMonitor::mcif2cdma_wt_rd_rsp_b_transport, dma_id: 0x%x\n", uint32_t(payload_copy->dma_id) ));
    cslDebug((70,"NvdlaCoreInternalMonitor::mcif2cdma_wt_rd_rsp_b_transport, status: 0x%x\n", uint32_t(payload_copy->status) ));
    memcpy ((void *)(&payload_copy->rsp), (void *)payload, sizeof(nvdla_dma_rd_rsp_t));
    // if ( ! mcif2cdma_wt_rd_rsp_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::mcif2cdma_wt_rd_rsp_b_transport, ERROR, FIFO mcif2cdma_wt_rd_rsp_fifo is stuck." << endl;
    // }
    mcif2cdma_wt_rd_rsp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::mcif2cdma_wt_rd_rsp_b_transport, push data to fifo\n"));
}

void NvdlaCoreInternalMonitor::bdma2mcif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_wr_req_t* payload = (nvdla_dma_wr_req_t*) bp.get_data_ptr();
    // cslAssert(0 > bdma2mcif_wr_req_credit_);
    switch (bdma2mcif_wr_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is pass through, directly forward\n"));
            bdma2mcif_wr_req_b_transport(ID, payload, delay);
            break;
        default:
            if (TAG_DATA == payload->tag) {
                // Data frame, will not be blocked
                bdma2mcif_wr_req_b_transport(ID, payload, delay);
            } else {
                while (0 == bdma2mcif_wr_req_credit_) {
                    cslDebug((50, "NvdlaCoreInternalMonitor::bdma2mcif_wr_req_b_transport, wait credit update event, halt CMOD\n"));
                    wait(bdma2mcif_wr_req_credit_update_event_);
                    cslDebug((50, "NvdlaCoreInternalMonitor::bdma2mcif_wr_req_b_transport, got credit update event, unhalt cmod\n"));
                }
                cslDebug((50, "NvdlaCoreInternalMonitor::bdma2mcif_wr_req_b_transport, credit is not zero\n"));
                bdma2mcif_wr_req_credit_mutex_.lock();
                bdma2mcif_wr_req_b_transport(ID, payload, delay);
                bdma2mcif_wr_req_credit_--;
                bdma2mcif_wr_req_credit_mutex_.unlock();
            }
            break;
    }
}

void NvdlaCoreInternalMonitor::bdma2mcif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) {
    nvdla_monitor_dma_wr_transaction_t *payload_copy = new nvdla_monitor_dma_wr_transaction_t;
    payload_copy->dma_id = CV_BDMA_WRITE_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_wr_req_t));
    // if ( ! bdma2mcif_wr_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::bdma2mcif_wr_req_b_transport, ERROR, FIFO bdma2mcif_wr_req_fifo is stuck." << endl;
    // }
    wait(10, SC_PS);
    bdma2mcif_wr_req_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::bdma2mcif_wr_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::sdp2mcif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_wr_req_t* payload = (nvdla_dma_wr_req_t*) bp.get_data_ptr();
    // cslAssert(0 > sdp2mcif_wr_req_credit_);
    switch (sdp2mcif_wr_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is pass through, directly forward\n"));
            sdp2mcif_wr_req_b_transport(ID, payload, delay);
            break;
        default:
            if (TAG_DATA == payload->tag) {
                // Data frame, will not be blocked
                sdp2mcif_wr_req_b_transport(ID, payload, delay);
            } else {
                while (0 == sdp2mcif_wr_req_credit_) {
                    cslDebug((50, "NvdlaCoreInternalMonitor::sdp2mcif_wr_req_b_transport, wait credit update event, halt CMOD\n"));
                    wait(sdp2mcif_wr_req_credit_update_event_);
                    cslDebug((50, "NvdlaCoreInternalMonitor::sdp2mcif_wr_req_b_transport, got credit update event, unhalt cmod\n"));
                }
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp2mcif_wr_req_b_transport, credit is not zero\n"));
                sdp2mcif_wr_req_credit_mutex_.lock();
                sdp2mcif_wr_req_b_transport(ID, payload, delay);
                sdp2mcif_wr_req_credit_--;
                sdp2mcif_wr_req_credit_mutex_.unlock();
            }
            break;
    }
}

void NvdlaCoreInternalMonitor::sdp2mcif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) {
    nvdla_monitor_dma_wr_transaction_t *payload_copy = new nvdla_monitor_dma_wr_transaction_t;
    payload_copy->dma_id = CV_SDP_WRITE_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_wr_req_t));
    // if ( ! sdp2mcif_wr_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::sdp2mcif_wr_req_b_transport, ERROR, FIFO sdp2mcif_wr_req_fifo is stuck." << endl;
    // }
    wait(10, SC_PS);
    sdp2mcif_wr_req_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::sdp2mcif_wr_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::pdp2mcif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_wr_req_t* payload = (nvdla_dma_wr_req_t*) bp.get_data_ptr();
    // cslAssert(0 > pdp2mcif_wr_req_credit_);
    switch (pdp2mcif_wr_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is pass through, directly forward\n"));
            pdp2mcif_wr_req_b_transport(ID, payload, delay);
            break;
        default:
            if (TAG_DATA == payload->tag) {
                // Data frame, will not be blocked
                pdp2mcif_wr_req_b_transport(ID, payload, delay);
            } else {
                while (0 == pdp2mcif_wr_req_credit_) {
                    cslDebug((50, "NvdlaCoreInternalMonitor::pdp2mcif_wr_req_b_transport, wait credit update event, halt CMOD\n"));
                    wait(pdp2mcif_wr_req_credit_update_event_);
                    cslDebug((50, "NvdlaCoreInternalMonitor::pdp2mcif_wr_req_b_transport, got credit update event, unhalt cmod\n"));
                }
                cslDebug((50, "NvdlaCoreInternalMonitor::pdp2mcif_wr_req_b_transport, credit is not zero\n"));
                pdp2mcif_wr_req_credit_mutex_.lock();
                pdp2mcif_wr_req_b_transport(ID, payload, delay);
                pdp2mcif_wr_req_credit_--;
                pdp2mcif_wr_req_credit_mutex_.unlock();
            }
            break;
    }
}

void NvdlaCoreInternalMonitor::pdp2mcif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) {
    nvdla_monitor_dma_wr_transaction_t *payload_copy = new nvdla_monitor_dma_wr_transaction_t;
    payload_copy->dma_id = CV_PDP_WRITE_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_wr_req_t));
    // if ( ! pdp2mcif_wr_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::pdp2mcif_wr_req_b_transport, ERROR, FIFO pdp2mcif_wr_req_fifo is stuck." << endl;
    // }
    wait(10, SC_PS);
    pdp2mcif_wr_req_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::pdp2mcif_wr_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::cdp2mcif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_wr_req_t* payload = (nvdla_dma_wr_req_t*) bp.get_data_ptr();
    // cslAssert(0 > cdp2mcif_wr_req_credit_);
    switch (cdp2mcif_wr_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is pass through, directly forward\n"));
            cdp2mcif_wr_req_b_transport(ID, payload, delay);
            break;
        default:
            if (TAG_DATA == payload->tag) {
                // Data frame, will not be blocked
                cdp2mcif_wr_req_b_transport(ID, payload, delay);
            } else {
                while (0 == cdp2mcif_wr_req_credit_) {
                    cslDebug((50, "NvdlaCoreInternalMonitor::cdp2mcif_wr_req_b_transport, wait credit update event, halt CMOD\n"));
                    wait(cdp2mcif_wr_req_credit_update_event_);
                    cslDebug((50, "NvdlaCoreInternalMonitor::cdp2mcif_wr_req_b_transport, got credit update event, unhalt cmod\n"));
                }
                cslDebug((50, "NvdlaCoreInternalMonitor::cdp2mcif_wr_req_b_transport, credit is not zero\n"));
                cdp2mcif_wr_req_credit_mutex_.lock();
                cdp2mcif_wr_req_b_transport(ID, payload, delay);
                cdp2mcif_wr_req_credit_--;
                cdp2mcif_wr_req_credit_mutex_.unlock();
            }
            break;
    }
}

void NvdlaCoreInternalMonitor::cdp2mcif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) {
    nvdla_monitor_dma_wr_transaction_t *payload_copy = new nvdla_monitor_dma_wr_transaction_t;
    payload_copy->dma_id = CV_CDP_WRITE_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_wr_req_t));
    // if ( ! cdp2mcif_wr_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::cdp2mcif_wr_req_b_transport, ERROR, FIFO cdp2mcif_wr_req_fifo is stuck." << endl;
    // }
    wait(10, SC_PS);
    cdp2mcif_wr_req_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::cdp2mcif_wr_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::rbk2mcif_wr_req_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_dma_wr_req_t* payload = (nvdla_dma_wr_req_t*) bp.get_data_ptr();
    // cslAssert(0 > rbk2mcif_wr_req_credit_);
    switch (rbk2mcif_wr_req_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is pass through, directly forward\n"));
            rbk2mcif_wr_req_b_transport(ID, payload, delay);
            break;
        default:
            if (TAG_DATA == payload->tag) {
                // Data frame, will not be blocked
                rbk2mcif_wr_req_b_transport(ID, payload, delay);
            } else {
                while (0 == rbk2mcif_wr_req_credit_) {
                    cslDebug((50, "NvdlaCoreInternalMonitor::rbk2mcif_wr_req_b_transport, wait credit update event, halt CMOD\n"));
                    wait(rbk2mcif_wr_req_credit_update_event_);
                    cslDebug((50, "NvdlaCoreInternalMonitor::rbk2mcif_wr_req_b_transport, got credit update event, unhalt cmod\n"));
                }
                cslDebug((50, "NvdlaCoreInternalMonitor::rbk2mcif_wr_req_b_transport, credit is not zero\n"));
                rbk2mcif_wr_req_credit_mutex_.lock();
                rbk2mcif_wr_req_b_transport(ID, payload, delay);
                rbk2mcif_wr_req_credit_--;
                rbk2mcif_wr_req_credit_mutex_.unlock();
            }
            break;
    }
}

void NvdlaCoreInternalMonitor::rbk2mcif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) {
    nvdla_monitor_dma_wr_transaction_t *payload_copy = new nvdla_monitor_dma_wr_transaction_t;
    payload_copy->dma_id = CV_RBK_WRITE_AXI_ID;
    payload_copy->status = NVDLA_MONITOR_DMA_STATUS_REQUEST;
    memcpy ((void *)(&payload_copy->req), (void *)payload, sizeof(nvdla_dma_wr_req_t));
    // if ( ! rbk2mcif_wr_req_fifo_->nb_write(payload_copy)) {
    //     cout << "NvdlaCoreInternalMonitor::rbk2mcif_wr_req_b_transport, ERROR, FIFO rbk2mcif_wr_req_fifo is stuck." << endl;
    // }
    wait(10, SC_PS);
    rbk2mcif_wr_req_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::rbk2mcif_wr_req_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::convolution_core_monitor_credit_b_transport(int ID, tlm::tlm_generic_payload& gp, sc_time& delay) {
    uint8_t *data_ptr = gp.get_data_ptr();
    credit_structure *credit_ptr = (credit_structure*) gp.get_data_ptr();
    cslDebug((50, "NvdlaCoreInternalMonitor::convolution_core_monitor_credit_b_transport: got a credit:\n"));
    cslDebug((50, "    txn_id:  0x%x\n"    , credit_ptr->txn_id));
    cslDebug((50, "    is_read: 0x%x\n"   , credit_ptr->is_read));
    cslDebug((50, "    is_req:  0x%x\n"    , credit_ptr->is_req));
    cslDebug((50, "    credit:  0x%x\n"    , credit_ptr->credit));
    cslDebug((50, "    sub_id:  0x%x\n"    , credit_ptr->sub_id));
    for (uint32_t i; i < gp.get_data_length(); i ++) {
        cslDebug((70, "    data_ptr[0x%x]:0x%x", i, uint32_t(data_ptr[i]) ));
    }
    cslDebug((70, "\n"));
    switch (credit_ptr->txn_id) {

        case TAG_SC2MAC_DAT_A:
            cslDebug((50, "NvdlaCoreInternalMonitor::convolution_core_monitor_credit_b_transport: got a credit to SC2MAC_DAT_A\n"));
            sc2mac_dat_a_credit_mutex_.lock();
            sc2mac_dat_a_credit_ += credit_ptr->credit;
            sc2mac_dat_a_credit_mutex_.unlock();
            sc2mac_dat_a_credit_update_event_.notify();
            break;

        case TAG_SC2MAC_DAT_B:
            cslDebug((50, "NvdlaCoreInternalMonitor::convolution_core_monitor_credit_b_transport: got a credit to SC2MAC_DAT_B\n"));
            sc2mac_dat_b_credit_mutex_.lock();
            sc2mac_dat_b_credit_ += credit_ptr->credit;
            sc2mac_dat_b_credit_mutex_.unlock();
            sc2mac_dat_b_credit_update_event_.notify();
            break;

        case TAG_SC2MAC_WT_A:
            cslDebug((50, "NvdlaCoreInternalMonitor::convolution_core_monitor_credit_b_transport: got a credit to SC2MAC_WT_A\n"));
            sc2mac_wt_a_credit_mutex_.lock();
            sc2mac_wt_a_credit_ += credit_ptr->credit;
            sc2mac_wt_a_credit_mutex_.unlock();
            sc2mac_wt_a_credit_update_event_.notify();
            break;

        case TAG_SC2MAC_WT_B:
            cslDebug((50, "NvdlaCoreInternalMonitor::convolution_core_monitor_credit_b_transport: got a credit to SC2MAC_WT_B\n"));
            sc2mac_wt_b_credit_mutex_.lock();
            sc2mac_wt_b_credit_ += credit_ptr->credit;
            sc2mac_wt_b_credit_mutex_.unlock();
            sc2mac_wt_b_credit_update_event_.notify();
            break;

        case TAG_MAC_A2ACCU:
            cslDebug((50, "NvdlaCoreInternalMonitor::convolution_core_monitor_credit_b_transport: got a credit to MAC_A2ACCU\n"));
            mac_a2accu_credit_mutex_.lock();
            mac_a2accu_credit_ += credit_ptr->credit;
            mac_a2accu_credit_mutex_.unlock();
            mac_a2accu_credit_update_event_.notify();
            break;

        case TAG_MAC_B2ACCU:
            cslDebug((50, "NvdlaCoreInternalMonitor::convolution_core_monitor_credit_b_transport: got a credit to MAC_B2ACCU\n"));
            mac_b2accu_credit_mutex_.lock();
            mac_b2accu_credit_ += credit_ptr->credit;
            mac_b2accu_credit_mutex_.unlock();
            mac_b2accu_credit_update_event_.notify();
            break;

        default:
            FAIL(("NvdlaCoreInternalMonitor::convolution_core_monitor_credit_b_transport, unknown supported ID"));
            break;
    }
}

void NvdlaCoreInternalMonitor::post_processing_monitor_credit_b_transport(int ID, tlm::tlm_generic_payload& gp, sc_time& delay) {
    uint8_t *data_ptr = gp.get_data_ptr();
    credit_structure *credit_ptr = (credit_structure*) gp.get_data_ptr();
    cslDebug((50, "NvdlaCoreInternalMonitor::post_processing_monitor_credit_b_transport: got a credit:\n"));
    cslDebug((50, "    txn_id:  0x%x\n"    , credit_ptr->txn_id));
    cslDebug((50, "    is_read: 0x%x\n"   , credit_ptr->is_read));
    cslDebug((50, "    is_req:  0x%x\n"    , credit_ptr->is_req));
    cslDebug((50, "    credit:  0x%x\n"    , credit_ptr->credit));
    cslDebug((50, "    sub_id:  0x%x\n"    , credit_ptr->sub_id));
    for (uint32_t i; i < gp.get_data_length(); i ++) {
        cslDebug((70, "    data_ptr[0x%x]:0x%x", i, uint32_t(data_ptr[i]) ));
    }
    cslDebug((70, "\n"));
    switch (credit_ptr->txn_id) {

        case TAG_CACC2SDP:
            cslDebug((50, "NvdlaCoreInternalMonitor::post_processing_monitor_credit_b_transport: got a credit to CACC2SDP\n"));
            cacc2sdp_credit_mutex_.lock();
            cacc2sdp_credit_ += credit_ptr->credit;
            cacc2sdp_credit_mutex_.unlock();
            cacc2sdp_credit_update_event_.notify();
            break;

        case TAG_SDP2PDP:
            cslDebug((50, "NvdlaCoreInternalMonitor::post_processing_monitor_credit_b_transport: got a credit to SDP2PDP\n"));
            sdp2pdp_credit_mutex_.lock();
            sdp2pdp_credit_ += credit_ptr->credit;
            sdp2pdp_credit_mutex_.unlock();
            sdp2pdp_credit_update_event_.notify();
            break;

        default:
            FAIL(("NvdlaCoreInternalMonitor::post_processing_monitor_credit_b_transport, unknown supported ID"));
            break;
    }
}

void NvdlaCoreInternalMonitor::sc2mac_dat_a_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_sc2mac_data_if_t* payload = (nvdla_sc2mac_data_if_t*) bp.get_data_ptr();
    cslDebug((70, "NvdlaCoreInternalMonitor::sc2mac_dat_a_b_transport, monitor a sc2mac_dat_a transaction.\n"));
    // cslAssert(0 > sc2mac_dat_a_credit_);
    switch (sc2mac_dat_a_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is pass through, directly forward\n"));
            sc2mac_dat_a_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == sc2mac_dat_a_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::sc2mac_dat_a_b_transport, wait credit update event, halt CMOD\n"));
                wait(sc2mac_dat_a_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::sc2mac_dat_a_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::sc2mac_dat_a_b_transport, credit is not zero\n"));
            sc2mac_dat_a_credit_mutex_.lock();
            sc2mac_dat_a_b_transport(ID, payload, delay);
            sc2mac_dat_a_credit_--;
            sc2mac_dat_a_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::sc2mac_dat_a_b_transport(int ID, nvdla_sc2mac_data_if_t* payload, sc_time& delay){
    nvdla_sc2mac_data_if_t *payload_copy = new nvdla_sc2mac_data_if_t;
    memcpy ((void *)(payload_copy), (void *)payload, sizeof(nvdla_sc2mac_data_if_t));
    sc2mac_dat_a_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::sc2mac_dat_a_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::sc2mac_dat_b_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_sc2mac_data_if_t* payload = (nvdla_sc2mac_data_if_t*) bp.get_data_ptr();
    cslDebug((70, "NvdlaCoreInternalMonitor::sc2mac_dat_b_b_transport, monitor a sc2mac_dat_b transaction.\n"));
    // cslAssert(0 > sc2mac_dat_b_credit_);
    switch (sc2mac_dat_b_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is pass through, directly forward\n"));
            sc2mac_dat_b_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == sc2mac_dat_b_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::sc2mac_dat_b_b_transport, wait credit update event, halt CMOD\n"));
                wait(sc2mac_dat_b_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::sc2mac_dat_b_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::sc2mac_dat_b_b_transport, credit is not zero\n"));
            sc2mac_dat_b_credit_mutex_.lock();
            sc2mac_dat_b_b_transport(ID, payload, delay);
            sc2mac_dat_b_credit_--;
            sc2mac_dat_b_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::sc2mac_dat_b_b_transport(int ID, nvdla_sc2mac_data_if_t* payload, sc_time& delay){
    nvdla_sc2mac_data_if_t *payload_copy = new nvdla_sc2mac_data_if_t;
    memcpy ((void *)(payload_copy), (void *)payload, sizeof(nvdla_sc2mac_data_if_t));
    sc2mac_dat_b_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::sc2mac_dat_b_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::sc2mac_wt_a_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_sc2mac_weight_if_t* payload = (nvdla_sc2mac_weight_if_t*) bp.get_data_ptr();
    cslDebug((70, "NvdlaCoreInternalMonitor::sc2mac_wt_a_b_transport, monitor a sc2mac_wt_a transaction.\n"));
    // cslAssert(0 > sc2mac_wt_a_credit_);
    switch (sc2mac_wt_a_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is pass through, directly forward\n"));
            sc2mac_wt_a_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == sc2mac_wt_a_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::sc2mac_wt_a_b_transport, wait credit update event, halt CMOD\n"));
                wait(sc2mac_wt_a_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::sc2mac_wt_a_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::sc2mac_wt_a_b_transport, credit is not zero\n"));
            sc2mac_wt_a_credit_mutex_.lock();
            sc2mac_wt_a_b_transport(ID, payload, delay);
            sc2mac_wt_a_credit_--;
            sc2mac_wt_a_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::sc2mac_wt_a_b_transport(int ID, nvdla_sc2mac_weight_if_t* payload, sc_time& delay){
    nvdla_sc2mac_weight_if_t *payload_copy = new nvdla_sc2mac_weight_if_t;
    memcpy ((void *)(payload_copy), (void *)payload, sizeof(nvdla_sc2mac_weight_if_t));
    sc2mac_wt_a_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::sc2mac_wt_a_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::sc2mac_wt_b_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_sc2mac_weight_if_t* payload = (nvdla_sc2mac_weight_if_t*) bp.get_data_ptr();
    cslDebug((70, "NvdlaCoreInternalMonitor::sc2mac_wt_b_b_transport, monitor a sc2mac_wt_b transaction.\n"));
    // cslAssert(0 > sc2mac_wt_b_credit_);
    switch (sc2mac_wt_b_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is pass through, directly forward\n"));
            sc2mac_wt_b_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == sc2mac_wt_b_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::sc2mac_wt_b_b_transport, wait credit update event, halt CMOD\n"));
                wait(sc2mac_wt_b_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::sc2mac_wt_b_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::sc2mac_wt_b_b_transport, credit is not zero\n"));
            sc2mac_wt_b_credit_mutex_.lock();
            sc2mac_wt_b_b_transport(ID, payload, delay);
            sc2mac_wt_b_credit_--;
            sc2mac_wt_b_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::sc2mac_wt_b_b_transport(int ID, nvdla_sc2mac_weight_if_t* payload, sc_time& delay){
    nvdla_sc2mac_weight_if_t *payload_copy = new nvdla_sc2mac_weight_if_t;
    memcpy ((void *)(payload_copy), (void *)payload, sizeof(nvdla_sc2mac_weight_if_t));
    sc2mac_wt_b_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::sc2mac_wt_b_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::mac_a2accu_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_mac2accu_data_if_t* payload = (nvdla_mac2accu_data_if_t*) bp.get_data_ptr();
    cslDebug((70, "NvdlaCoreInternalMonitor::mac_a2accu_b_transport, monitor a mac_a2accu transaction.\n"));
    // cslAssert(0 > mac_a2accu_credit_);
    switch (mac_a2accu_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is pass through, directly forward\n"));
            mac_a2accu_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == mac_a2accu_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::mac_a2accu_b_transport, wait credit update event, halt CMOD\n"));
                wait(mac_a2accu_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::mac_a2accu_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::mac_a2accu_b_transport, credit is not zero\n"));
            mac_a2accu_credit_mutex_.lock();
            mac_a2accu_b_transport(ID, payload, delay);
            mac_a2accu_credit_--;
            mac_a2accu_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::mac_a2accu_b_transport(int ID, nvdla_mac2accu_data_if_t* payload, sc_time& delay){
    nvdla_mac2accu_data_if_t *payload_copy = new nvdla_mac2accu_data_if_t;
    memcpy ((void *)(payload_copy), (void *)payload, sizeof(nvdla_mac2accu_data_if_t));
    mac_a2accu_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::mac_a2accu_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::mac_b2accu_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_mac2accu_data_if_t* payload = (nvdla_mac2accu_data_if_t*) bp.get_data_ptr();
    cslDebug((70, "NvdlaCoreInternalMonitor::mac_b2accu_b_transport, monitor a mac_b2accu transaction.\n"));
    // cslAssert(0 > mac_b2accu_credit_);
    switch (mac_b2accu_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is pass through, directly forward\n"));
            mac_b2accu_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == mac_b2accu_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::mac_b2accu_b_transport, wait credit update event, halt CMOD\n"));
                wait(mac_b2accu_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::mac_b2accu_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::mac_b2accu_b_transport, credit is not zero\n"));
            mac_b2accu_credit_mutex_.lock();
            mac_b2accu_b_transport(ID, payload, delay);
            mac_b2accu_credit_--;
            mac_b2accu_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::mac_b2accu_b_transport(int ID, nvdla_mac2accu_data_if_t* payload, sc_time& delay){
    nvdla_mac2accu_data_if_t *payload_copy = new nvdla_mac2accu_data_if_t;
    memcpy ((void *)(payload_copy), (void *)payload, sizeof(nvdla_mac2accu_data_if_t));
    mac_b2accu_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::mac_b2accu_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::cacc2sdp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_accu2pp_if_t* payload = (nvdla_accu2pp_if_t*) bp.get_data_ptr();
    cslDebug((70, "NvdlaCoreInternalMonitor::cacc2sdp_b_transport, monitor a cacc2sdp transaction.\n"));
    // cslAssert(0 > cacc2sdp_credit_);
    switch (cacc2sdp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is pass through, directly forward\n"));
            cacc2sdp_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == cacc2sdp_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::cacc2sdp_b_transport, wait credit update event, halt CMOD\n"));
                wait(cacc2sdp_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::cacc2sdp_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::cacc2sdp_b_transport, credit is not zero\n"));
            cacc2sdp_credit_mutex_.lock();
            cacc2sdp_b_transport(ID, payload, delay);
            cacc2sdp_credit_--;
            cacc2sdp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::cacc2sdp_b_transport(int ID, nvdla_accu2pp_if_t* payload, sc_time& delay){
    nvdla_accu2pp_if_t *payload_copy = new nvdla_accu2pp_if_t;
    memcpy ((void *)(payload_copy), (void *)payload, sizeof(nvdla_accu2pp_if_t));
    cacc2sdp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::cacc2sdp_b_transport, pushed data to fifo\n"));
}

void NvdlaCoreInternalMonitor::sdp2pdp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
    nvdla_sdp2pdp_t* payload = (nvdla_sdp2pdp_t*) bp.get_data_ptr();
    cslDebug((70, "NvdlaCoreInternalMonitor::sdp2pdp_b_transport, monitor a sdp2pdp transaction.\n"));
    // cslAssert(0 > sdp2pdp_credit_);
    switch (sdp2pdp_credit_) {
        case MONITOR_WORKING_MODE_NOT_SAMPLING:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is not sampling, skip\n"));
            break;
        case MONITOR_WORKING_MODE_PASSTHROUGH:
            cslDebug((70, "NvdlaCoreInternalMonitor::, working mode is pass through, directly forward\n"));
            sdp2pdp_b_transport(ID, payload, delay);
            break;
        default:
            while (0 == sdp2pdp_credit_) {
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp2pdp_b_transport, wait credit update event, halt CMOD\n"));
                wait(sdp2pdp_credit_update_event_);
                cslDebug((50, "NvdlaCoreInternalMonitor::sdp2pdp_b_transport, got credit update event, unhalt cmod\n"));
            }
            cslDebug((50, "NvdlaCoreInternalMonitor::sdp2pdp_b_transport, credit is not zero\n"));
            sdp2pdp_credit_mutex_.lock();
            sdp2pdp_b_transport(ID, payload, delay);
            sdp2pdp_credit_--;
            sdp2pdp_credit_mutex_.unlock();
            break;
    }
}

void NvdlaCoreInternalMonitor::sdp2pdp_b_transport(int ID, nvdla_sdp2pdp_t* payload, sc_time& delay){
    nvdla_sdp2pdp_t *payload_copy = new nvdla_sdp2pdp_t;
    memcpy ((void *)(payload_copy), (void *)payload, sizeof(nvdla_sdp2pdp_t));
    sdp2pdp_fifo_->write(payload_copy);
    cslDebug((50, "NvdlaCoreInternalMonitor::sdp2pdp_b_transport, pushed data to fifo\n"));
}




void NvdlaCoreInternalMonitor::Cvif2BdmaWrResponseMethod() {
    if ( true == cvif2bdma_wr_rsp.read()) {
        nvdla_monitor_dma_wr_transaction_t *payload_copy = new nvdla_monitor_dma_wr_transaction_t;
// #ifdef NVDLA_CMOD_DEBUG
        cslDebug((50, "NvdlaCoreInternalMonitor::Cvif2BdmaWrResponseMethod, got a cvif2bdma write response.\n"));
// #endif
        
        payload_copy->dma_id = MC_BDMA_WRITE_AXI_ID;
        payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
        // if ( ! cvif2bdma_wr_rsp_fifo_->nb_write(payload_copy)) {
        //     cout << "NvdlaCoreInternalMonitor::Cvif2BdmaWrResponseMethod, ERROR, FIFO cvif2bdma_wr_rsp_fifo_ is stuck." << endl;
        // }
        cvif2bdma_wr_rsp_fifo_->write(payload_copy);
        // if (cvif2bdma_wr_rsp_credit_ != 0) {
        //     cvif2bdma_wr_rsp_credit_mutex_.lock();
        //     if ( ! cvif2bdma_wr_rsp_fifo_->nb_write(payload_copy)) {
        //         cout << "NvdlaCoreInternalMonitor::Cvif2BdmaWrResponseMethod, ERROR, FIFO cvif2bdma_wr_rsp_fifo_ is stuck." << endl;
        //     }
        //     cvif2bdma_wr_rsp_credit_--;
        //     cvif2bdma_wr_rsp_credit_mutex_.unlock();
        // } else {
        //     wait ( cvif2bdma_wr_rsp_credit_update_event_);
        // }
    }
}

void NvdlaCoreInternalMonitor::Cvif2SdpWrResponseMethod() {
    if ( true == cvif2sdp_wr_rsp.read()) {
        nvdla_monitor_dma_wr_transaction_t *payload_copy = new nvdla_monitor_dma_wr_transaction_t;
// #ifdef NVDLA_CMOD_DEBUG
        cslDebug((50, "NvdlaCoreInternalMonitor::Cvif2SdpWrResponseMethod, got a cvif2sdp write response.\n"));
// #endif
        
        payload_copy->dma_id = MC_SDP_WRITE_AXI_ID;
        payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
        // if ( ! cvif2sdp_wr_rsp_fifo_->nb_write(payload_copy)) {
        //     cout << "NvdlaCoreInternalMonitor::Cvif2SdpWrResponseMethod, ERROR, FIFO cvif2sdp_wr_rsp_fifo_ is stuck." << endl;
        // }
        cvif2sdp_wr_rsp_fifo_->write(payload_copy);
        // if (cvif2sdp_wr_rsp_credit_ != 0) {
        //     cvif2sdp_wr_rsp_credit_mutex_.lock();
        //     if ( ! cvif2sdp_wr_rsp_fifo_->nb_write(payload_copy)) {
        //         cout << "NvdlaCoreInternalMonitor::Cvif2SdpWrResponseMethod, ERROR, FIFO cvif2sdp_wr_rsp_fifo_ is stuck." << endl;
        //     }
        //     cvif2sdp_wr_rsp_credit_--;
        //     cvif2sdp_wr_rsp_credit_mutex_.unlock();
        // } else {
        //     wait ( cvif2sdp_wr_rsp_credit_update_event_);
        // }
    }
}

void NvdlaCoreInternalMonitor::Cvif2PdpWrResponseMethod() {
    if ( true == cvif2pdp_wr_rsp.read()) {
        nvdla_monitor_dma_wr_transaction_t *payload_copy = new nvdla_monitor_dma_wr_transaction_t;
// #ifdef NVDLA_CMOD_DEBUG
        cslDebug((50, "NvdlaCoreInternalMonitor::Cvif2PdpWrResponseMethod, got a cvif2pdp write response.\n"));
// #endif
        
        payload_copy->dma_id = MC_PDP_WRITE_AXI_ID;
        payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
        // if ( ! cvif2pdp_wr_rsp_fifo_->nb_write(payload_copy)) {
        //     cout << "NvdlaCoreInternalMonitor::Cvif2PdpWrResponseMethod, ERROR, FIFO cvif2pdp_wr_rsp_fifo_ is stuck." << endl;
        // }
        cvif2pdp_wr_rsp_fifo_->write(payload_copy);
        // if (cvif2pdp_wr_rsp_credit_ != 0) {
        //     cvif2pdp_wr_rsp_credit_mutex_.lock();
        //     if ( ! cvif2pdp_wr_rsp_fifo_->nb_write(payload_copy)) {
        //         cout << "NvdlaCoreInternalMonitor::Cvif2PdpWrResponseMethod, ERROR, FIFO cvif2pdp_wr_rsp_fifo_ is stuck." << endl;
        //     }
        //     cvif2pdp_wr_rsp_credit_--;
        //     cvif2pdp_wr_rsp_credit_mutex_.unlock();
        // } else {
        //     wait ( cvif2pdp_wr_rsp_credit_update_event_);
        // }
    }
}

void NvdlaCoreInternalMonitor::Cvif2CdpWrResponseMethod() {
    if ( true == cvif2cdp_wr_rsp.read()) {
        nvdla_monitor_dma_wr_transaction_t *payload_copy = new nvdla_monitor_dma_wr_transaction_t;
// #ifdef NVDLA_CMOD_DEBUG
        cslDebug((50, "NvdlaCoreInternalMonitor::Cvif2CdpWrResponseMethod, got a cvif2cdp write response.\n"));
// #endif
        
        payload_copy->dma_id = MC_CDP_WRITE_AXI_ID;
        payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
        // if ( ! cvif2cdp_wr_rsp_fifo_->nb_write(payload_copy)) {
        //     cout << "NvdlaCoreInternalMonitor::Cvif2CdpWrResponseMethod, ERROR, FIFO cvif2cdp_wr_rsp_fifo_ is stuck." << endl;
        // }
        cvif2cdp_wr_rsp_fifo_->write(payload_copy);
        // if (cvif2cdp_wr_rsp_credit_ != 0) {
        //     cvif2cdp_wr_rsp_credit_mutex_.lock();
        //     if ( ! cvif2cdp_wr_rsp_fifo_->nb_write(payload_copy)) {
        //         cout << "NvdlaCoreInternalMonitor::Cvif2CdpWrResponseMethod, ERROR, FIFO cvif2cdp_wr_rsp_fifo_ is stuck." << endl;
        //     }
        //     cvif2cdp_wr_rsp_credit_--;
        //     cvif2cdp_wr_rsp_credit_mutex_.unlock();
        // } else {
        //     wait ( cvif2cdp_wr_rsp_credit_update_event_);
        // }
    }
}

void NvdlaCoreInternalMonitor::Cvif2RbkWrResponseMethod() {
    if ( true == cvif2rbk_wr_rsp.read()) {
        nvdla_monitor_dma_wr_transaction_t *payload_copy = new nvdla_monitor_dma_wr_transaction_t;
// #ifdef NVDLA_CMOD_DEBUG
        cslDebug((50, "NvdlaCoreInternalMonitor::Cvif2RbkWrResponseMethod, got a cvif2rbk write response.\n"));
// #endif
        
        payload_copy->dma_id = MC_RBK_WRITE_AXI_ID;
        payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
        // if ( ! cvif2rbk_wr_rsp_fifo_->nb_write(payload_copy)) {
        //     cout << "NvdlaCoreInternalMonitor::Cvif2RbkWrResponseMethod, ERROR, FIFO cvif2rbk_wr_rsp_fifo_ is stuck." << endl;
        // }
        cvif2rbk_wr_rsp_fifo_->write(payload_copy);
        // if (cvif2rbk_wr_rsp_credit_ != 0) {
        //     cvif2rbk_wr_rsp_credit_mutex_.lock();
        //     if ( ! cvif2rbk_wr_rsp_fifo_->nb_write(payload_copy)) {
        //         cout << "NvdlaCoreInternalMonitor::Cvif2RbkWrResponseMethod, ERROR, FIFO cvif2rbk_wr_rsp_fifo_ is stuck." << endl;
        //     }
        //     cvif2rbk_wr_rsp_credit_--;
        //     cvif2rbk_wr_rsp_credit_mutex_.unlock();
        // } else {
        //     wait ( cvif2rbk_wr_rsp_credit_update_event_);
        // }
    }
}

void NvdlaCoreInternalMonitor::Mcif2BdmaWrResponseMethod() {
    if ( true == mcif2bdma_wr_rsp.read()) {
        nvdla_monitor_dma_wr_transaction_t *payload_copy = new nvdla_monitor_dma_wr_transaction_t;
// #ifdef NVDLA_CMOD_DEBUG
        cslDebug((50, "NvdlaCoreInternalMonitor::Mcif2BdmaWrResponseMethod, got a mcif2bdma write response.\n"));
// #endif
        
        payload_copy->dma_id = MC_BDMA_WRITE_AXI_ID;
        payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
        // if ( ! mcif2bdma_wr_rsp_fifo_->nb_write(payload_copy)) {
        //     cout << "NvdlaCoreInternalMonitor::Mcif2BdmaWrResponseMethod, ERROR, FIFO mcif2bdma_wr_rsp_fifo_ is stuck." << endl;
        // }
        mcif2bdma_wr_rsp_fifo_->write(payload_copy);
        // if (mcif2bdma_wr_rsp_credit_ != 0) {
        //     mcif2bdma_wr_rsp_credit_mutex_.lock();
        //     if ( ! mcif2bdma_wr_rsp_fifo_->nb_write(payload_copy)) {
        //         cout << "NvdlaCoreInternalMonitor::Mcif2BdmaWrResponseMethod, ERROR, FIFO mcif2bdma_wr_rsp_fifo_ is stuck." << endl;
        //     }
        //     mcif2bdma_wr_rsp_credit_--;
        //     mcif2bdma_wr_rsp_credit_mutex_.unlock();
        // } else {
        //     wait ( mcif2bdma_wr_rsp_credit_update_event_);
        // }
    }
}

void NvdlaCoreInternalMonitor::Mcif2SdpWrResponseMethod() {
    if ( true == mcif2sdp_wr_rsp.read()) {
        nvdla_monitor_dma_wr_transaction_t *payload_copy = new nvdla_monitor_dma_wr_transaction_t;
// #ifdef NVDLA_CMOD_DEBUG
        cslDebug((50, "NvdlaCoreInternalMonitor::Mcif2SdpWrResponseMethod, got a mcif2sdp write response.\n"));
// #endif
        
        payload_copy->dma_id = MC_SDP_WRITE_AXI_ID;
        payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
        // if ( ! mcif2sdp_wr_rsp_fifo_->nb_write(payload_copy)) {
        //     cout << "NvdlaCoreInternalMonitor::Mcif2SdpWrResponseMethod, ERROR, FIFO mcif2sdp_wr_rsp_fifo_ is stuck." << endl;
        // }
        mcif2sdp_wr_rsp_fifo_->write(payload_copy);
        // if (mcif2sdp_wr_rsp_credit_ != 0) {
        //     mcif2sdp_wr_rsp_credit_mutex_.lock();
        //     if ( ! mcif2sdp_wr_rsp_fifo_->nb_write(payload_copy)) {
        //         cout << "NvdlaCoreInternalMonitor::Mcif2SdpWrResponseMethod, ERROR, FIFO mcif2sdp_wr_rsp_fifo_ is stuck." << endl;
        //     }
        //     mcif2sdp_wr_rsp_credit_--;
        //     mcif2sdp_wr_rsp_credit_mutex_.unlock();
        // } else {
        //     wait ( mcif2sdp_wr_rsp_credit_update_event_);
        // }
    }
}

void NvdlaCoreInternalMonitor::Mcif2PdpWrResponseMethod() {
    if ( true == mcif2pdp_wr_rsp.read()) {
        nvdla_monitor_dma_wr_transaction_t *payload_copy = new nvdla_monitor_dma_wr_transaction_t;
// #ifdef NVDLA_CMOD_DEBUG
        cslDebug((50, "NvdlaCoreInternalMonitor::Mcif2PdpWrResponseMethod, got a mcif2pdp write response.\n"));
// #endif
        
        payload_copy->dma_id = MC_PDP_WRITE_AXI_ID;
        payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
        // if ( ! mcif2pdp_wr_rsp_fifo_->nb_write(payload_copy)) {
        //     cout << "NvdlaCoreInternalMonitor::Mcif2PdpWrResponseMethod, ERROR, FIFO mcif2pdp_wr_rsp_fifo_ is stuck." << endl;
        // }
        mcif2pdp_wr_rsp_fifo_->write(payload_copy);
        // if (mcif2pdp_wr_rsp_credit_ != 0) {
        //     mcif2pdp_wr_rsp_credit_mutex_.lock();
        //     if ( ! mcif2pdp_wr_rsp_fifo_->nb_write(payload_copy)) {
        //         cout << "NvdlaCoreInternalMonitor::Mcif2PdpWrResponseMethod, ERROR, FIFO mcif2pdp_wr_rsp_fifo_ is stuck." << endl;
        //     }
        //     mcif2pdp_wr_rsp_credit_--;
        //     mcif2pdp_wr_rsp_credit_mutex_.unlock();
        // } else {
        //     wait ( mcif2pdp_wr_rsp_credit_update_event_);
        // }
    }
}

void NvdlaCoreInternalMonitor::Mcif2CdpWrResponseMethod() {
    if ( true == mcif2cdp_wr_rsp.read()) {
        nvdla_monitor_dma_wr_transaction_t *payload_copy = new nvdla_monitor_dma_wr_transaction_t;
// #ifdef NVDLA_CMOD_DEBUG
        cslDebug((50, "NvdlaCoreInternalMonitor::Mcif2CdpWrResponseMethod, got a mcif2cdp write response.\n"));
// #endif
        
        payload_copy->dma_id = MC_CDP_WRITE_AXI_ID;
        payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
        // if ( ! mcif2cdp_wr_rsp_fifo_->nb_write(payload_copy)) {
        //     cout << "NvdlaCoreInternalMonitor::Mcif2CdpWrResponseMethod, ERROR, FIFO mcif2cdp_wr_rsp_fifo_ is stuck." << endl;
        // }
        mcif2cdp_wr_rsp_fifo_->write(payload_copy);
        // if (mcif2cdp_wr_rsp_credit_ != 0) {
        //     mcif2cdp_wr_rsp_credit_mutex_.lock();
        //     if ( ! mcif2cdp_wr_rsp_fifo_->nb_write(payload_copy)) {
        //         cout << "NvdlaCoreInternalMonitor::Mcif2CdpWrResponseMethod, ERROR, FIFO mcif2cdp_wr_rsp_fifo_ is stuck." << endl;
        //     }
        //     mcif2cdp_wr_rsp_credit_--;
        //     mcif2cdp_wr_rsp_credit_mutex_.unlock();
        // } else {
        //     wait ( mcif2cdp_wr_rsp_credit_update_event_);
        // }
    }
}

void NvdlaCoreInternalMonitor::Mcif2RbkWrResponseMethod() {
    if ( true == mcif2rbk_wr_rsp.read()) {
        nvdla_monitor_dma_wr_transaction_t *payload_copy = new nvdla_monitor_dma_wr_transaction_t;
// #ifdef NVDLA_CMOD_DEBUG
        cslDebug((50, "NvdlaCoreInternalMonitor::Mcif2RbkWrResponseMethod, got a mcif2rbk write response.\n"));
// #endif
        
        payload_copy->dma_id = MC_RBK_WRITE_AXI_ID;
        payload_copy->status = NVDLA_MONITOR_DMA_STATUS_RESPONSE;
        // if ( ! mcif2rbk_wr_rsp_fifo_->nb_write(payload_copy)) {
        //     cout << "NvdlaCoreInternalMonitor::Mcif2RbkWrResponseMethod, ERROR, FIFO mcif2rbk_wr_rsp_fifo_ is stuck." << endl;
        // }
        mcif2rbk_wr_rsp_fifo_->write(payload_copy);
        // if (mcif2rbk_wr_rsp_credit_ != 0) {
        //     mcif2rbk_wr_rsp_credit_mutex_.lock();
        //     if ( ! mcif2rbk_wr_rsp_fifo_->nb_write(payload_copy)) {
        //         cout << "NvdlaCoreInternalMonitor::Mcif2RbkWrResponseMethod, ERROR, FIFO mcif2rbk_wr_rsp_fifo_ is stuck." << endl;
        //     }
        //     mcif2rbk_wr_rsp_credit_--;
        //     mcif2rbk_wr_rsp_credit_mutex_.unlock();
        // } else {
        //     wait ( mcif2rbk_wr_rsp_credit_update_event_);
        // }
    }
}


// void NvdlaCoreInternalMonitor::sc2mac_dat_a_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
// #ifdef NVDLA_CMOD_DEBUG
//     cslDebug((50, "NvdlaCoreInternalMonitor::sc2mac_dat_a_b_transport, monitor a sc2mac_a data transaction.\\n"));
// #endif
//     nvdla_sc2mac_data_if_t* payload = (nvdla_sc2mac_data_if_t*) bp.get_data_ptr();
//     sc2mac_dat_a_b_transport(ID, payload, delay);
// }
// 
// void NvdlaCoreInternalMonitor::sc2mac_wt_a_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
// #ifdef NVDLA_CMOD_DEBUG
//     cslDebug((50, "NvdlaCoreInternalMonitor::sc2mac_wt_a_b_transport, monitor a sc2mac_a weight transaction.\\n"));
// #endif
//     nvdla_sc2mac_weight_if_t* payload = (nvdla_sc2mac_weight_if_t*) bp.get_data_ptr();
//     sc2mac_wt_a_b_transport(ID, payload, delay);
// }
// 
// void NvdlaCoreInternalMonitor::sc2mac_dat_b_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
// #ifdef NVDLA_CMOD_DEBUG
//     cslDebug((50, "NvdlaCoreInternalMonitor::sc2mac_dat_b_b_transport, monitor a sc2mac_a data transaction.\\n"));
// #endif
//     nvdla_sc2mac_data_if_t* payload = (nvdla_sc2mac_data_if_t*) bp.get_data_ptr();
//     sc2mac_dat_b_b_transport(ID, payload, delay);
// }
// 
// void NvdlaCoreInternalMonitor::sc2mac_wt_b_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
// #ifdef NVDLA_CMOD_DEBUG
//     cslDebug((50, "NvdlaCoreInternalMonitor::sc2mac_wt_b_b_transport, monitor a sc2mac_a weight transaction.\\n"));
// #endif
//     nvdla_sc2mac_weight_if_t* payload = (nvdla_sc2mac_weight_if_t*) bp.get_data_ptr();
//     sc2mac_wt_b_b_transport(ID, payload, delay);
// }
// 
// void NvdlaCoreInternalMonitor::mac_a2accu_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
// #ifdef NVDLA_CMOD_DEBUG
//     cslDebug((50, "NvdlaCoreInternalMonitor::mac_a2accu_b_transport, monitor a mac_a2accu transaction.\\n"));
// #endif
//     nvdla_mac2accu_data_if_t* payload = (nvdla_mac2accu_data_if_t*) bp.get_data_ptr();
//     mac_a2accu_b_transport(ID, payload, delay);
// }
// 
// void NvdlaCoreInternalMonitor::mac_b2accu_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
// #ifdef NVDLA_CMOD_DEBUG
//     cslDebug((50, "NvdlaCoreInternalMonitor::mac_b2accu_b_transport, monitor a mac_b2accu transaction.\\n"));
// #endif
//     nvdla_mac2accu_data_if_t* payload = (nvdla_mac2accu_data_if_t*) bp.get_data_ptr();
//     mac_b2accu_b_transport(ID, payload, delay);
// }
// 
// void NvdlaCoreInternalMonitor::cacc2sdp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
// #ifdef NVDLA_CMOD_DEBUG
//     cslDebug((50, "NvdlaCoreInternalMonitor::cacc2sdp_b_transport, monitor a cacc2sdp transaction.\\n"));
// #endif
//     nvdla_accu2pp_if_t* payload = (nvdla_accu2pp_if_t*) bp.get_data_ptr();
//     cacc2sdp_b_transport(ID, payload, delay);
// }
// 
// void NvdlaCoreInternalMonitor::sdp2pdp_b_transport(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
// #ifdef NVDLA_CMOD_DEBUG
//     cslDebug((50, "NvdlaCoreInternalMonitor::sdp2pdp_b_transport, monitor a sdp2pdp transaction.\\n"));
// #endif
//     nvdla_sdp2pdp_t* payload = (nvdla_sdp2pdp_t*) bp.get_data_ptr();
//     sdp2pdp_b_transport(ID, payload, delay);
// }

// void NvdlaCoreInternalMonitor::(int ID, tlm::tlm_generic_payload& bp, sc_time& delay) {
//     * payload = (*) bp.get_data_ptr();
//     (ID, payload, delay);
// }

// void NvdlaCoreInternalMonitor::sc2mac_dat_a_b_transport(int ID, nvdla_sc2mac_data_if_t* payload, sc_time& delay){
//     nvdla_sc2mac_data_if_t *payload_copy = new nvdla_sc2mac_data_if_t;
//     memcpy ((void *)(payload_copy), (void *)payload, sizeof(nvdla_sc2mac_data_if_t));
//     if (sc2mac_dat_a_credit_ != 0) {
//         sc2mac_dat_a_credit_mutex_.lock();
//         sc2mac_dat_a_fifo_->write(payload_copy);
//         sc2mac_dat_a_credit_--;
//         sc2mac_dat_a_credit_mutex_.unlock();
//     } else {
//         wait(sc2mac_dat_a_credit_update_event_);
//     }
//     // if ( ! sc2mac_dat_a_fifo_->nb_write(payload_copy)) {
//     //     cout << "NvdlaCoreInternalMonitor::sc2mac_dat_a_b_transport, ERROR, FIFO sc2mac_dat_a_fifo is stuck." << endl;
//     // }
// }
// 
// void NvdlaCoreInternalMonitor::sc2mac_wt_a_b_transport(int ID, nvdla_sc2mac_weight_if_t* payload, sc_time& delay){
//     nvdla_sc2mac_weight_if_t *payload_copy = new nvdla_sc2mac_weight_if_t;
//     memcpy ((void *)(payload_copy), (void *)payload, sizeof(nvdla_sc2mac_weight_if_t));
//     sc2mac_wt_a_fifo_->write(payload_copy);
//     // if ( ! sc2mac_wt_a_fifo_->nb_write(payload_copy)) {
//     //     cout << "NvdlaCoreInternalMonitor::sc2mac_wt_a_b_transport, ERROR, FIFO sc2mac_wt_a_fifo is stuck." << endl;
//     // }
// }
// 
// void NvdlaCoreInternalMonitor::sc2mac_dat_b_b_transport(int ID, nvdla_sc2mac_data_if_t* payload, sc_time& delay){
//     nvdla_sc2mac_data_if_t *payload_copy = new nvdla_sc2mac_data_if_t;
//     memcpy ((void *)(payload_copy), (void *)payload, sizeof(nvdla_sc2mac_data_if_t));
//     sc2mac_dat_b_fifo_->write(payload_copy);
//     // if ( ! sc2mac_dat_b_fifo_->nb_write(payload_copy)) {
//     //     cout << "NvdlaCoreInternalMonitor::sc2mac_dat_b_b_transport, ERROR, FIFO sc2mac_dat_b_fifo is stuck." << endl;
//     // }
// }
// 
// void NvdlaCoreInternalMonitor::sc2mac_wt_b_b_transport(int ID, nvdla_sc2mac_weight_if_t* payload, sc_time& delay){
//     nvdla_sc2mac_weight_if_t *payload_copy = new nvdla_sc2mac_weight_if_t;
//     memcpy ((void *)(payload_copy), (void *)payload, sizeof(nvdla_sc2mac_weight_if_t));
//     sc2mac_wt_b_fifo_->write(payload_copy);
//     // if ( ! sc2mac_wt_b_fifo_->nb_write(payload_copy)) {
//     //     cout << "NvdlaCoreInternalMonitor::sc2mac_wt_b_b_transport, ERROR, FIFO sc2mac_wt_b_fifo is stuck." << endl;
//     // }
// }
// 
// void NvdlaCoreInternalMonitor::mac_a2accu_b_transport(int ID, nvdla_mac2accu_data_if_t* payload, sc_time& delay){
//     nvdla_mac2accu_data_if_t *payload_copy = new nvdla_mac2accu_data_if_t;
//     memcpy ((void *)(payload_copy), (void *)payload, sizeof(nvdla_mac2accu_data_if_t));
//     mac_a2accu_fifo_->write(payload_copy);
//     // if ( ! mac_a2accu_fifo_->nb_write(payload_copy)) {
//     //     cout << "NvdlaCoreInternalMonitor::mac_a2accu_b_transport, ERROR, FIFO mac_a2accu_fifo is stuck." << endl;
//     // }
// }
// 
// void NvdlaCoreInternalMonitor::mac_b2accu_b_transport(int ID, nvdla_mac2accu_data_if_t* payload, sc_time& delay){
//     nvdla_mac2accu_data_if_t *payload_copy = new nvdla_mac2accu_data_if_t;
//     memcpy ((void *)(payload_copy), (void *)payload, sizeof(nvdla_mac2accu_data_if_t));
//     mac_b2accu_fifo_->write(payload_copy);
//     // if ( ! mac_a2accu_fifo_->nb_write(payload_copy)) {
//     //     cout << "NvdlaCoreInternalMonitor::mac_b2accu_b_transport, ERROR, FIFO mac_a2accu_fifo is stuck." << endl;
//     // }
// }
// 
// void NvdlaCoreInternalMonitor::cacc2sdp_b_transport(int ID, nvdla_accu2pp_if_t* payload, sc_time& delay){
//     nvdla_accu2pp_if_t *payload_copy = new nvdla_accu2pp_if_t;
//     memcpy ((void *)(payload_copy), (void *)payload, sizeof(nvdla_accu2pp_if_t));
//     cacc2sdp_fifo_->write(payload_copy);
//     // if ( ! cacc2sdp_fifo_->nb_write(payload_copy)) {
//     //     cout << "NvdlaCoreInternalMonitor::cacc2sdp_b_transport, ERROR, FIFO cacc2sdp_fifo is stuck." << endl;
//     // }
// }
// 
// void NvdlaCoreInternalMonitor::sdp2pdp_b_transport(int ID, nvdla_sdp2pdp_t* payload, sc_time& delay){
//     nvdla_sdp2pdp_t *payload_copy = new nvdla_sdp2pdp_t;
//     memcpy ((void *)(payload_copy), (void *)payload, sizeof(nvdla_sdp2pdp_t));
//     sdp2pdp_fifo_->write(payload_copy);
//     // if ( ! sdp2pdp_fifo_->nb_write(payload_copy)) {
//     //     cout << "NvdlaCoreInternalMonitor::sdp2pdp_b_transport, ERROR, FIFO sdp2pdp_fifo is stuck." << endl;
//     // }
// }

// void NvdlaCoreInternalMonitor::(int ID, * payload, sc_time& delay){
//      *payload_copy = new ;
//     memcpy ((void *)(payload_copy), (void *)payload, sizeof());
//     if ( ! _fifo_->nb_write(payload_copy)) {
//         cout << "NvdlaCoreInternalMonitor::, ERROR, FIFO _fifo is stuck." << endl;
//     }
// }

void NvdlaCoreInternalMonitor::Reset() {
}

void NvdlaCoreInternalMonitor::DmaMonitorThread() {
    nvdla_monitor_dma_rd_transaction_t *read_payload;
    nvdla_monitor_dma_wr_transaction_t *write_payload;
    while (true) {

        if( (bdma2cvif_rd_req_fifo_->num_available()==0) && (cvif2bdma_rd_rsp_fifo_->num_available()==0)
 && (sdp2cvif_rd_req_fifo_->num_available()==0) && (cvif2sdp_rd_rsp_fifo_->num_available()==0)
 && (pdp2cvif_rd_req_fifo_->num_available()==0) && (cvif2pdp_rd_rsp_fifo_->num_available()==0)
 && (cdp2cvif_rd_req_fifo_->num_available()==0) && (cvif2cdp_rd_rsp_fifo_->num_available()==0)
 && (rbk2cvif_rd_req_fifo_->num_available()==0) && (cvif2rbk_rd_rsp_fifo_->num_available()==0)
 && (sdp_b2cvif_rd_req_fifo_->num_available()==0) && (cvif2sdp_b_rd_rsp_fifo_->num_available()==0)
 && (sdp_n2cvif_rd_req_fifo_->num_available()==0) && (cvif2sdp_n_rd_rsp_fifo_->num_available()==0)
 && (sdp_e2cvif_rd_req_fifo_->num_available()==0) && (cvif2sdp_e_rd_rsp_fifo_->num_available()==0)
 && (cdma_dat2cvif_rd_req_fifo_->num_available()==0) && (cvif2cdma_dat_rd_rsp_fifo_->num_available()==0)
 && (cdma_wt2cvif_rd_req_fifo_->num_available()==0) && (cvif2cdma_wt_rd_rsp_fifo_->num_available()==0)

        && (bdma2cvif_wr_req_fifo_->num_available()==0) && (cvif2bdma_wr_rsp_fifo_->num_available()==0)

        && (sdp2cvif_wr_req_fifo_->num_available()==0) && (cvif2sdp_wr_rsp_fifo_->num_available()==0)

        && (pdp2cvif_wr_req_fifo_->num_available()==0) && (cvif2pdp_wr_rsp_fifo_->num_available()==0)

        && (cdp2cvif_wr_req_fifo_->num_available()==0) && (cvif2cdp_wr_rsp_fifo_->num_available()==0)

        && (rbk2cvif_wr_req_fifo_->num_available()==0) && (cvif2rbk_wr_rsp_fifo_->num_available()==0)

        && (bdma2mcif_rd_req_fifo_->num_available()==0) && (mcif2bdma_rd_rsp_fifo_->num_available()==0)

        && (sdp2mcif_rd_req_fifo_->num_available()==0) && (mcif2sdp_rd_rsp_fifo_->num_available()==0)

        && (pdp2mcif_rd_req_fifo_->num_available()==0) && (mcif2pdp_rd_rsp_fifo_->num_available()==0)

        && (cdp2mcif_rd_req_fifo_->num_available()==0) && (mcif2cdp_rd_rsp_fifo_->num_available()==0)

        && (rbk2mcif_rd_req_fifo_->num_available()==0) && (mcif2rbk_rd_rsp_fifo_->num_available()==0)

        && (sdp_b2mcif_rd_req_fifo_->num_available()==0) && (mcif2sdp_b_rd_rsp_fifo_->num_available()==0)

        && (sdp_n2mcif_rd_req_fifo_->num_available()==0) && (mcif2sdp_n_rd_rsp_fifo_->num_available()==0)

        && (sdp_e2mcif_rd_req_fifo_->num_available()==0) && (mcif2sdp_e_rd_rsp_fifo_->num_available()==0)

        && (cdma_dat2mcif_rd_req_fifo_->num_available()==0) && (mcif2cdma_dat_rd_rsp_fifo_->num_available()==0)

        && (cdma_wt2mcif_rd_req_fifo_->num_available()==0) && (mcif2cdma_wt_rd_rsp_fifo_->num_available()==0)

        && (bdma2mcif_wr_req_fifo_->num_available()==0) && (mcif2bdma_wr_rsp_fifo_->num_available()==0)

        && (sdp2mcif_wr_req_fifo_->num_available()==0) && (mcif2sdp_wr_rsp_fifo_->num_available()==0)

        && (pdp2mcif_wr_req_fifo_->num_available()==0) && (mcif2pdp_wr_rsp_fifo_->num_available()==0)

        && (cdp2mcif_wr_req_fifo_->num_available()==0) && (mcif2cdp_wr_rsp_fifo_->num_available()==0)

        && (rbk2mcif_wr_req_fifo_->num_available()==0) && (mcif2rbk_wr_rsp_fifo_->num_available()==0)
) {
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, no pending transactions, go to sleep.\n"));
            wait();
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, got new transactions, wake up.\n"));
        }

        if (bdma2cvif_rd_req_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send BDMA (CV) read request, begin\n"));
// #endif
            dma_rd_b_transport_cv(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send BDMA (CV) read request, end\n"));
            delete read_payload; // Release memory
        }

        if (cvif2bdma_rd_rsp_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send BDMA (CV) read response, begin\n"));
// #endif
            dma_rd_b_transport_cv(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send BDMA (CV) read response, end\n"));
            delete read_payload; // Release memory
        }

        if (sdp2cvif_rd_req_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP (CV) read request, begin\n"));
// #endif
            dma_rd_b_transport_cv(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP (CV) read request, end\n"));
            delete read_payload; // Release memory
        }

        if (cvif2sdp_rd_rsp_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP (CV) read response, begin\n"));
// #endif
            dma_rd_b_transport_cv(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP (CV) read response, end\n"));
            delete read_payload; // Release memory
        }

        if (pdp2cvif_rd_req_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send PDP (CV) read request, begin\n"));
// #endif
            dma_rd_b_transport_cv(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send PDP (CV) read request, end\n"));
            delete read_payload; // Release memory
        }

        if (cvif2pdp_rd_rsp_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send PDP (CV) read response, begin\n"));
// #endif
            dma_rd_b_transport_cv(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send PDP (CV) read response, end\n"));
            delete read_payload; // Release memory
        }

        if (cdp2cvif_rd_req_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDP (CV) read request, begin\n"));
// #endif
            dma_rd_b_transport_cv(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDP (CV) read request, end\n"));
            delete read_payload; // Release memory
        }

        if (cvif2cdp_rd_rsp_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDP (CV) read response, begin\n"));
// #endif
            dma_rd_b_transport_cv(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDP (CV) read response, end\n"));
            delete read_payload; // Release memory
        }

        if (rbk2cvif_rd_req_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send RBK (CV) read request, begin\n"));
// #endif
            dma_rd_b_transport_cv(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send RBK (CV) read request, end\n"));
            delete read_payload; // Release memory
        }

        if (cvif2rbk_rd_rsp_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send RBK (CV) read response, begin\n"));
// #endif
            dma_rd_b_transport_cv(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send RBK (CV) read response, end\n"));
            delete read_payload; // Release memory
        }

        if (sdp_b2cvif_rd_req_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_B (CV) read request, begin\n"));
// #endif
            dma_rd_b_transport_cv(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_B (CV) read request, end\n"));
            delete read_payload; // Release memory
        }

        if (cvif2sdp_b_rd_rsp_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_B (CV) read response, begin\n"));
// #endif
            dma_rd_b_transport_cv(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_B (CV) read response, end\n"));
            delete read_payload; // Release memory
        }

        if (sdp_n2cvif_rd_req_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_N (CV) read request, begin\n"));
// #endif
            dma_rd_b_transport_cv(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_N (CV) read request, end\n"));
            delete read_payload; // Release memory
        }

        if (cvif2sdp_n_rd_rsp_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_N (CV) read response, begin\n"));
// #endif
            dma_rd_b_transport_cv(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_N (CV) read response, end\n"));
            delete read_payload; // Release memory
        }

        if (sdp_e2cvif_rd_req_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_E (CV) read request, begin\n"));
// #endif
            dma_rd_b_transport_cv(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_E (CV) read request, end\n"));
            delete read_payload; // Release memory
        }

        if (cvif2sdp_e_rd_rsp_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_E (CV) read response, begin\n"));
// #endif
            dma_rd_b_transport_cv(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_E (CV) read response, end\n"));
            delete read_payload; // Release memory
        }

        if (cdma_dat2cvif_rd_req_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDMA_DAT (CV) read request, begin\n"));
// #endif
            dma_rd_b_transport_cv(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDMA_DAT (CV) read request, end\n"));
            delete read_payload; // Release memory
        }

        if (cvif2cdma_dat_rd_rsp_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDMA_DAT (CV) read response, begin\n"));
// #endif
            dma_rd_b_transport_cv(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDMA_DAT (CV) read response, end\n"));
            delete read_payload; // Release memory
        }

        if (cdma_wt2cvif_rd_req_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDMA_WT (CV) read request, begin\n"));
// #endif
            dma_rd_b_transport_cv(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDMA_WT (CV) read request, end\n"));
            delete read_payload; // Release memory
        }

        if (cvif2cdma_wt_rd_rsp_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDMA_WT (CV) read response, begin\n"));
// #endif
            dma_rd_b_transport_cv(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDMA_WT (CV) read response, end\n"));
            delete read_payload; // Release memory
        }

        if (bdma2cvif_wr_req_fifo_->nb_read(write_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send BDMA (CV) write request, begin\n"));
// #endif
            dma_wr_b_transport_cv(write_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send BDMA (CV) write request, end\n"));
            delete write_payload; // Release memory
        }

        if (cvif2bdma_wr_rsp_fifo_->nb_read(write_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send BDMA (CV) write response, begin\n"));
// #endif
            dma_wr_b_transport_cv(write_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send BDMA (CV) write response, end\n"));
            delete write_payload; // Release memory
        }

        if (sdp2cvif_wr_req_fifo_->nb_read(write_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP (CV) write request, begin\n"));
// #endif
            dma_wr_b_transport_cv(write_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP (CV) write request, end\n"));
            delete write_payload; // Release memory
        }

        if (cvif2sdp_wr_rsp_fifo_->nb_read(write_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP (CV) write response, begin\n"));
// #endif
            dma_wr_b_transport_cv(write_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP (CV) write response, end\n"));
            delete write_payload; // Release memory
        }

        if (pdp2cvif_wr_req_fifo_->nb_read(write_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send PDP (CV) write request, begin\n"));
// #endif
            dma_wr_b_transport_cv(write_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send PDP (CV) write request, end\n"));
            delete write_payload; // Release memory
        }

        if (cvif2pdp_wr_rsp_fifo_->nb_read(write_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send PDP (CV) write response, begin\n"));
// #endif
            dma_wr_b_transport_cv(write_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send PDP (CV) write response, end\n"));
            delete write_payload; // Release memory
        }

        if (cdp2cvif_wr_req_fifo_->nb_read(write_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDP (CV) write request, begin\n"));
// #endif
            dma_wr_b_transport_cv(write_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDP (CV) write request, end\n"));
            delete write_payload; // Release memory
        }

        if (cvif2cdp_wr_rsp_fifo_->nb_read(write_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDP (CV) write response, begin\n"));
// #endif
            dma_wr_b_transport_cv(write_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDP (CV) write response, end\n"));
            delete write_payload; // Release memory
        }

        if (rbk2cvif_wr_req_fifo_->nb_read(write_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send RBK (CV) write request, begin\n"));
// #endif
            dma_wr_b_transport_cv(write_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send RBK (CV) write request, end\n"));
            delete write_payload; // Release memory
        }

        if (cvif2rbk_wr_rsp_fifo_->nb_read(write_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send RBK (CV) write response, begin\n"));
// #endif
            dma_wr_b_transport_cv(write_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send RBK (CV) write response, end\n"));
            delete write_payload; // Release memory
        }

        if (bdma2mcif_rd_req_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send BDMA (MC) read request, begin\n"));
// #endif
            dma_rd_b_transport_mc(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send BDMA (MC) read request, end\n"));
            delete read_payload; // Release memory
        }

        if (mcif2bdma_rd_rsp_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send BDMA (MC) read response, begin\n"));
// #endif
            dma_rd_b_transport_mc(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send BDMA (MC) read response, end\n"));
            delete read_payload; // Release memory
        }

        if (sdp2mcif_rd_req_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP (MC) read request, begin\n"));
// #endif
            dma_rd_b_transport_mc(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP (MC) read request, end\n"));
            delete read_payload; // Release memory
        }

        if (mcif2sdp_rd_rsp_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP (MC) read response, begin\n"));
// #endif
            dma_rd_b_transport_mc(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP (MC) read response, end\n"));
            delete read_payload; // Release memory
        }

        if (pdp2mcif_rd_req_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send PDP (MC) read request, begin\n"));
// #endif
            dma_rd_b_transport_mc(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send PDP (MC) read request, end\n"));
            delete read_payload; // Release memory
        }

        if (mcif2pdp_rd_rsp_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send PDP (MC) read response, begin\n"));
// #endif
            dma_rd_b_transport_mc(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send PDP (MC) read response, end\n"));
            delete read_payload; // Release memory
        }

        if (cdp2mcif_rd_req_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDP (MC) read request, begin\n"));
// #endif
            dma_rd_b_transport_mc(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDP (MC) read request, end\n"));
            delete read_payload; // Release memory
        }

        if (mcif2cdp_rd_rsp_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDP (MC) read response, begin\n"));
// #endif
            dma_rd_b_transport_mc(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDP (MC) read response, end\n"));
            delete read_payload; // Release memory
        }

        if (rbk2mcif_rd_req_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send RBK (MC) read request, begin\n"));
// #endif
            dma_rd_b_transport_mc(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send RBK (MC) read request, end\n"));
            delete read_payload; // Release memory
        }

        if (mcif2rbk_rd_rsp_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send RBK (MC) read response, begin\n"));
// #endif
            dma_rd_b_transport_mc(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send RBK (MC) read response, end\n"));
            delete read_payload; // Release memory
        }

        if (sdp_b2mcif_rd_req_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_B (MC) read request, begin\n"));
// #endif
            dma_rd_b_transport_mc(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_B (MC) read request, end\n"));
            delete read_payload; // Release memory
        }

        if (mcif2sdp_b_rd_rsp_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_B (MC) read response, begin\n"));
// #endif
            dma_rd_b_transport_mc(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_B (MC) read response, end\n"));
            delete read_payload; // Release memory
        }

        if (sdp_n2mcif_rd_req_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_N (MC) read request, begin\n"));
// #endif
            dma_rd_b_transport_mc(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_N (MC) read request, end\n"));
            delete read_payload; // Release memory
        }

        if (mcif2sdp_n_rd_rsp_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_N (MC) read response, begin\n"));
// #endif
            dma_rd_b_transport_mc(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_N (MC) read response, end\n"));
            delete read_payload; // Release memory
        }

        if (sdp_e2mcif_rd_req_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_E (MC) read request, begin\n"));
// #endif
            dma_rd_b_transport_mc(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_E (MC) read request, end\n"));
            delete read_payload; // Release memory
        }

        if (mcif2sdp_e_rd_rsp_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_E (MC) read response, begin\n"));
// #endif
            dma_rd_b_transport_mc(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP_E (MC) read response, end\n"));
            delete read_payload; // Release memory
        }

        if (cdma_dat2mcif_rd_req_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDMA_DAT (MC) read request, begin\n"));
// #endif
            dma_rd_b_transport_mc(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDMA_DAT (MC) read request, end\n"));
            delete read_payload; // Release memory
        }

        if (mcif2cdma_dat_rd_rsp_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDMA_DAT (MC) read response, begin\n"));
// #endif
            dma_rd_b_transport_mc(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDMA_DAT (MC) read response, end\n"));
            delete read_payload; // Release memory
        }

        if (cdma_wt2mcif_rd_req_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDMA_WT (MC) read request, begin\n"));
// #endif
            dma_rd_b_transport_mc(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDMA_WT (MC) read request, end\n"));
            delete read_payload; // Release memory
        }

        if (mcif2cdma_wt_rd_rsp_fifo_->nb_read(read_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDMA_WT (MC) read response, begin\n"));
// #endif
            dma_rd_b_transport_mc(read_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDMA_WT (MC) read response, end\n"));
            delete read_payload; // Release memory
        }

        if (bdma2mcif_wr_req_fifo_->nb_read(write_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send BDMA (MC) write request, begin\n"));
// #endif
            dma_wr_b_transport_mc(write_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send BDMA (MC) write request, end\n"));
            delete write_payload; // Release memory
        }

        if (mcif2bdma_wr_rsp_fifo_->nb_read(write_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send BDMA (MC) write response, begin\n"));
// #endif
            dma_wr_b_transport_mc(write_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send BDMA (MC) write response, end\n"));
            delete write_payload; // Release memory
        }

        if (sdp2mcif_wr_req_fifo_->nb_read(write_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP (MC) write request, begin\n"));
// #endif
            dma_wr_b_transport_mc(write_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP (MC) write request, end\n"));
            delete write_payload; // Release memory
        }

        if (mcif2sdp_wr_rsp_fifo_->nb_read(write_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP (MC) write response, begin\n"));
// #endif
            dma_wr_b_transport_mc(write_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send SDP (MC) write response, end\n"));
            delete write_payload; // Release memory
        }

        if (pdp2mcif_wr_req_fifo_->nb_read(write_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send PDP (MC) write request, begin\n"));
// #endif
            dma_wr_b_transport_mc(write_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send PDP (MC) write request, end\n"));
            delete write_payload; // Release memory
        }

        if (mcif2pdp_wr_rsp_fifo_->nb_read(write_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send PDP (MC) write response, begin\n"));
// #endif
            dma_wr_b_transport_mc(write_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send PDP (MC) write response, end\n"));
            delete write_payload; // Release memory
        }

        if (cdp2mcif_wr_req_fifo_->nb_read(write_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDP (MC) write request, begin\n"));
// #endif
            dma_wr_b_transport_mc(write_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDP (MC) write request, end\n"));
            delete write_payload; // Release memory
        }

        if (mcif2cdp_wr_rsp_fifo_->nb_read(write_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDP (MC) write response, begin\n"));
// #endif
            dma_wr_b_transport_mc(write_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send CDP (MC) write response, end\n"));
            delete write_payload; // Release memory
        }

        if (rbk2mcif_wr_req_fifo_->nb_read(write_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send RBK (MC) write request, begin\n"));
// #endif
            dma_wr_b_transport_mc(write_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send RBK (MC) write request, end\n"));
            delete write_payload; // Release memory
        }

        if (mcif2rbk_wr_rsp_fifo_->nb_read(write_payload)) {
// #ifdef NVDLA_CMOD_DEBUG
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send RBK (MC) write response, begin\n"));
// #endif
            dma_wr_b_transport_mc(write_payload, b_transport_delay_);
            cslDebug((50, "NvdlaCoreInternalMonitor::DmaMonitorThread, send RBK (MC) write response, end\n"));
            delete write_payload; // Release memory
        }

    }
}

void NvdlaCoreInternalMonitor::ConvCoreMonitorThread() {
    nvdla_sc2mac_data_if_t*     sc2mac_dat_a_ptr;
    nvdla_sc2mac_weight_if_t*   sc2mac_wt_a_ptr;
    nvdla_sc2mac_data_if_t*     sc2mac_dat_b_ptr;
    nvdla_sc2mac_weight_if_t*   sc2mac_wt_b_ptr;
    nvdla_mac2accu_data_if_t*   mac_a2accu_ptr;
    nvdla_mac2accu_data_if_t*   mac_b2accu_ptr;
    while (true) {
        if ( (sc2mac_dat_a_fifo_->num_available()==0) && (sc2mac_wt_a_fifo_->num_available()==0)
         &&  (sc2mac_dat_b_fifo_->num_available()==0) && (sc2mac_wt_b_fifo_->num_available()==0)
         && (mac_a2accu_fifo_->num_available()==0) && (mac_b2accu_fifo_->num_available()==0) ) {
            cslDebug((50, "NvdlaCoreInternalMonitor::ConvCoreMonitorThread, no pending transactions, go to sleep.\n"));
            wait();
            cslDebug((50, "NvdlaCoreInternalMonitor::ConvCoreMonitorThread, got new transactions, wake up.\n"));
        }

        if (sc2mac_dat_a_fifo_->nb_read(sc2mac_dat_a_ptr)) {
            cslDebug((50, "NvdlaCoreInternalMonitor::ConvCoreMonitorThread, send sc2mac_dat_a.\n"));
            convolution_core_monitor_initiator_b_transport(TAG_SC2MAC_DAT_A, sc2mac_dat_a_ptr, b_transport_delay_);
            delete sc2mac_dat_a_ptr; // Release memory
        }

        if (sc2mac_wt_a_fifo_->nb_read(sc2mac_wt_a_ptr)) {
            cslDebug((50, "NvdlaCoreInternalMonitor::ConvCoreMonitorThread, send sc2mac_wt_a.\n"));
            convolution_core_monitor_initiator_b_transport(TAG_SC2MAC_WT_A, sc2mac_wt_a_ptr, b_transport_delay_);
            delete sc2mac_wt_a_ptr; // Release memory
        }

        if (sc2mac_dat_b_fifo_->nb_read(sc2mac_dat_b_ptr)) {
            cslDebug((50, "NvdlaCoreInternalMonitor::ConvCoreMonitorThread, send sc2mac_dat_b.\n"));
            convolution_core_monitor_initiator_b_transport(TAG_SC2MAC_DAT_B, sc2mac_dat_b_ptr, b_transport_delay_);
            delete sc2mac_dat_b_ptr; // Release memory
        }

        if (sc2mac_wt_b_fifo_->nb_read(sc2mac_wt_b_ptr)) {
            cslDebug((50, "NvdlaCoreInternalMonitor::ConvCoreMonitorThread, send sc2mac_wt_b.\n"));
            convolution_core_monitor_initiator_b_transport(TAG_SC2MAC_WT_B, sc2mac_wt_b_ptr, b_transport_delay_);
            delete sc2mac_wt_b_ptr; // Release memory
        }
        if (mac_a2accu_fifo_->nb_read(mac_a2accu_ptr)) {
            cslDebug((50, "NvdlaCoreInternalMonitor::ConvCoreMonitorThread, send cmac_a2cacc.\n"));
            convolution_core_monitor_initiator_b_transport(TAG_MAC_A2ACCU, mac_a2accu_ptr, b_transport_delay_);
            delete mac_a2accu_ptr; // Release memory
        }
        if (mac_b2accu_fifo_->nb_read(mac_b2accu_ptr)) {
            cslDebug((50, "NvdlaCoreInternalMonitor::ConvCoreMonitorThread, send cmac_b2cacc.\n"));
            convolution_core_monitor_initiator_b_transport(TAG_MAC_B2ACCU, mac_b2accu_ptr, b_transport_delay_);
            delete mac_b2accu_ptr; // Release memory
        }
    }
}

void NvdlaCoreInternalMonitor::PostProcessingMonitorThread() {
    nvdla_accu2pp_if_t  *cacc2sdp_ptr;
    nvdla_sdp2pdp_t     *sdp2pdp_ptr;
    while (true) {
        if ( (cacc2sdp_fifo_->num_available()==0) && (sdp2pdp_fifo_->num_available()==0) ) {
            wait();
        }

        if (cacc2sdp_fifo_->nb_read(cacc2sdp_ptr)) {
            cslDebug((50, "NvdlaCoreInternalMonitor::PostProcessingMonitorThread, send cacc2sdp data.\\n"));
            post_processing_monitor_initiator_b_transport(cacc2sdp_ptr, b_transport_delay_);
            delete cacc2sdp_ptr; // Release memory
        }

        if (sdp2pdp_fifo_->nb_read(sdp2pdp_ptr)) {
            cslDebug((50, "NvdlaCoreInternalMonitor::PostProcessingMonitorThread, send sdp2pdp data.\\n"));
            post_processing_monitor_initiator_b_transport(sdp2pdp_ptr, b_transport_delay_);
            delete sdp2pdp_ptr; // Release memory
        }

    }
}

// void NvdlaCoreInternalMonitor::MonitorThread() {
//     *     _ptr;
//     *     _ptr;
//     *     _ptr;
//     while (true) {
//         if ( (->num_available()==0) && (->num_available()==0) && (->num_available()==0) ) {
//             wait();
//         }
// 
//         if (->nb_read()) {
//             cslDebug((50, "NvdlaCoreInternalMonitor::, send  data.\\n"));
//             (, b_transport_delay_);
//             delete ; // Release memory
//         }
// 
//         if (->nb_read()) {
//             cslDebug((50, "NvdlaCoreInternalMonitor::, send  data.\\n"));
//             (, b_transport_delay_);
//             delete ; // Release memory
//         }
// 
//         if (->nb_read()) {
//             cslDebug((50, "NvdlaCoreInternalMonitor::, send  data.\\n"));
//             (, b_transport_delay_);
//             delete ; // Release memory
//         }
// 
//     }
// }

// Initiator b_transport
// # DMA
void NvdlaCoreInternalMonitor::dma_rd_b_transport_mc(nvdla_monitor_dma_rd_transaction_t* payload, sc_time& delay) {
    uint8_t  *tlm_gp_byte_enable_ptr;
    uint32_t  payload_byte_size;
    payload_byte_size = sizeof(nvdla_monitor_dma_rd_transaction_t);
    tlm_gp_byte_enable_ptr   = new uint8_t[payload_byte_size];
    memset(tlm_gp_byte_enable_ptr, 0xFF, payload_byte_size);
    dma_monitor_payload_mc.set_data_ptr( (uint8_t *) payload);
    dma_monitor_payload_mc.set_data_length(payload_byte_size);
    dma_monitor_payload_mc.set_byte_enable_ptr(tlm_gp_byte_enable_ptr);
    dma_monitor_payload_mc.set_byte_enable_length(payload_byte_size);
    dma_monitor_payload_mc.set_command(tlm::TLM_READ_COMMAND);
// #ifdef NVDLA_CMOD_DEBUG
    cslDebug((50, "NvdlaCoreInternalMonitor::dma_rd_b_transport_mc, before b_transport\n"));
// #endif
    dma_monitor_mc->b_transport (dma_monitor_payload_mc, delay);
// #ifdef NVDLA_CMOD_DEBUG
    cslDebug((50, "NvdlaCoreInternalMonitor::dma_rd_b_transport_mc, after b_transport\n"));
// #endif
    delete [] tlm_gp_byte_enable_ptr;
}

void NvdlaCoreInternalMonitor::dma_wr_b_transport_mc(nvdla_monitor_dma_wr_transaction_t* payload, sc_time& delay) {
    uint8_t  *tlm_gp_byte_enable_ptr;
    uint32_t  payload_byte_size;
    payload_byte_size = sizeof(nvdla_monitor_dma_wr_transaction_t);
    tlm_gp_byte_enable_ptr   = new uint8_t[payload_byte_size];
    memset(tlm_gp_byte_enable_ptr, 0xFF, payload_byte_size);
    dma_monitor_payload_mc.set_data_ptr( (uint8_t *) payload);
    dma_monitor_payload_mc.set_data_length(payload_byte_size);
    dma_monitor_payload_mc.set_byte_enable_ptr(tlm_gp_byte_enable_ptr);
    dma_monitor_payload_mc.set_byte_enable_length(payload_byte_size);
    dma_monitor_payload_mc.set_command(tlm::TLM_WRITE_COMMAND);
    dma_monitor_mc->b_transport (dma_monitor_payload_mc, delay);
    delete [] tlm_gp_byte_enable_ptr;
}

void NvdlaCoreInternalMonitor::dma_rd_b_transport_cv(nvdla_monitor_dma_rd_transaction_t* payload, sc_time& delay) {
    uint8_t  *tlm_gp_byte_enable_ptr;
    uint32_t  payload_byte_size;
    payload_byte_size = sizeof(nvdla_monitor_dma_rd_transaction_t);
    tlm_gp_byte_enable_ptr   = new uint8_t[payload_byte_size];
    memset(tlm_gp_byte_enable_ptr, 0xFF, payload_byte_size);
    dma_monitor_payload_cv.set_data_ptr( (uint8_t *) payload);
    dma_monitor_payload_cv.set_data_length(payload_byte_size);
    dma_monitor_payload_cv.set_byte_enable_ptr(tlm_gp_byte_enable_ptr);
    dma_monitor_payload_cv.set_byte_enable_length(payload_byte_size);
    dma_monitor_payload_cv.set_command(tlm::TLM_READ_COMMAND);
    dma_monitor_cv->b_transport (dma_monitor_payload_cv, delay);
    delete [] tlm_gp_byte_enable_ptr;
}

void NvdlaCoreInternalMonitor::dma_wr_b_transport_cv(nvdla_monitor_dma_wr_transaction_t* payload, sc_time& delay) {
    uint8_t  *tlm_gp_byte_enable_ptr;
    uint32_t  payload_byte_size;
    payload_byte_size = sizeof(nvdla_monitor_dma_wr_transaction_t);
    tlm_gp_byte_enable_ptr   = new uint8_t[payload_byte_size];
    memset(tlm_gp_byte_enable_ptr, 0xFF, payload_byte_size);
    dma_monitor_payload_cv.set_data_ptr( (uint8_t *) payload);
    dma_monitor_payload_cv.set_data_length(payload_byte_size);
    dma_monitor_payload_cv.set_byte_enable_ptr(tlm_gp_byte_enable_ptr);
    dma_monitor_payload_cv.set_byte_enable_length(payload_byte_size);
    dma_monitor_payload_cv.set_command(tlm::TLM_WRITE_COMMAND);
    dma_monitor_cv->b_transport (dma_monitor_payload_cv, delay);
    delete [] tlm_gp_byte_enable_ptr;
}

// # Convolution core
// # Valid-only :      CSC-to-CMAC, CMAC-to-CACC
void NvdlaCoreInternalMonitor::convolution_core_monitor_initiator_b_transport(uint8_t id, nvdla_sc2mac_data_if_t* payload, sc_time& delay) {
    nvdla_sc2mac_data_monitor_t *cc_payload_ptr = new nvdla_sc2mac_data_monitor_t;
    uint8_t  *tlm_gp_data_ptr;
    uint8_t  *tlm_gp_byte_enable_ptr;
    uint32_t  payload_byte_size;
    uint32_t  iter;
    // Copy data from nvdla_sc2mac_data_if_t to nvdla_sc2mac_data_monitor_t
    // Mask
    cslAssert(get_array_len(cc_payload_ptr->mask) == get_array_len(payload->mask));
    for (iter = 0; iter < get_array_len(cc_payload_ptr->mask); iter ++) {
        cc_payload_ptr->mask[iter] = payload->mask[iter];
    }
    // Data
    cslAssert(get_array_len(cc_payload_ptr->data) == get_array_len(payload->data));
    for (iter = 0; iter < get_array_len(cc_payload_ptr->data); iter ++) {
        cc_payload_ptr->data[iter] = payload->data[iter].to_int();
    }
    // Stripe info
    cc_payload_ptr->nvdla_stripe_info = payload->pd.nvdla_stripe_info;
    payload_byte_size           = sizeof(nvdla_sc2mac_data_monitor_t)+1;
    cslDebug((70, "NvdlaCoreInternalMonitor::convolution_core_monitor_initiator_b_transport (nvdla_sc2mac_data_if_t), payload_byte_size is %0d", payload_byte_size));
    tlm_gp_data_ptr             = new uint8_t[payload_byte_size];
    tlm_gp_byte_enable_ptr      = new uint8_t[payload_byte_size];
    tlm_gp_data_ptr[0]          = id;
    // memcpy ((void*) &tlm_gp_data_ptr[1], (void *)payload, payload_byte_size-1);
    memcpy ((void*) &tlm_gp_data_ptr[1], (void *)cc_payload_ptr, payload_byte_size-1);
    memset(tlm_gp_byte_enable_ptr, 0xFF, payload_byte_size);
    convolution_core_monitor_initiator_payload.set_data_ptr( tlm_gp_data_ptr);
    convolution_core_monitor_initiator_payload.set_data_length(payload_byte_size);
    convolution_core_monitor_initiator_payload.set_byte_enable_ptr(tlm_gp_byte_enable_ptr);
    convolution_core_monitor_initiator_payload.set_byte_enable_length(payload_byte_size);
    convolution_core_monitor_initiator_payload.set_command(tlm::TLM_WRITE_COMMAND);
    convolution_core_monitor_initiator->b_transport (convolution_core_monitor_initiator_payload, delay);
    delete [] tlm_gp_data_ptr;
    delete [] tlm_gp_byte_enable_ptr;
    delete cc_payload_ptr;
}

void NvdlaCoreInternalMonitor::convolution_core_monitor_initiator_b_transport(uint8_t id, nvdla_sc2mac_weight_if_t* payload, sc_time& delay) {
    nvdla_sc2mac_weight_monitor_t *cc_payload_ptr = new nvdla_sc2mac_weight_monitor_t;
    uint8_t  *tlm_gp_data_ptr;
    uint8_t  *tlm_gp_byte_enable_ptr;
    uint32_t  payload_byte_size;
    uint32_t  iter;
    // Copy data from nvdla_sc2mac_weight_if_t to nvdla_sc2mac_weight_monitor_t
    // Mask
    cslAssert(get_array_len(cc_payload_ptr->mask) == get_array_len(payload->mask));
    for (iter = 0; iter < get_array_len(cc_payload_ptr->mask); iter ++) {
        cc_payload_ptr->mask[iter] = payload->mask[iter];
    }
    // Data
    cslAssert(get_array_len(cc_payload_ptr->data) == get_array_len(payload->data));
    for (iter = 0; iter < get_array_len(cc_payload_ptr->data); iter ++) {
        cc_payload_ptr->data[iter] = payload->data[iter].to_int();
    }
    // Select
    cc_payload_ptr->sel = payload->sel;
    payload_byte_size           = sizeof(nvdla_sc2mac_weight_monitor_t)+1;
    cslDebug((70, "NvdlaCoreInternalMonitor::convolution_core_monitor_initiator_b_transport (nvdla_sc2mac_weight_if_t), payload_byte_size is %0d", payload_byte_size));
    tlm_gp_data_ptr             = new uint8_t[payload_byte_size];
    tlm_gp_byte_enable_ptr      = new uint8_t[payload_byte_size];
    tlm_gp_data_ptr[0]          = id;
    // memcpy ((void*) &tlm_gp_data_ptr[1], (void *)payload, payload_byte_size-1);
    memcpy ((void*) &tlm_gp_data_ptr[1], (void *)cc_payload_ptr, payload_byte_size-1);
    memset(tlm_gp_byte_enable_ptr, 0xFF, payload_byte_size);
    convolution_core_monitor_initiator_payload.set_data_ptr( tlm_gp_data_ptr);
    convolution_core_monitor_initiator_payload.set_data_length(payload_byte_size);
    convolution_core_monitor_initiator_payload.set_byte_enable_ptr(tlm_gp_byte_enable_ptr);
    convolution_core_monitor_initiator_payload.set_byte_enable_length(payload_byte_size);
    convolution_core_monitor_initiator_payload.set_command(tlm::TLM_WRITE_COMMAND);
    convolution_core_monitor_initiator->b_transport (convolution_core_monitor_initiator_payload, delay);
    delete [] tlm_gp_data_ptr;
    delete [] tlm_gp_byte_enable_ptr;
    delete cc_payload_ptr;
}

void NvdlaCoreInternalMonitor::convolution_core_monitor_initiator_b_transport(uint8_t id, nvdla_mac2accu_data_if_t* payload, sc_time& delay) {
    nvdla_mac2accu_data_monitor_t *cc_payload_ptr = new nvdla_mac2accu_data_monitor_t;
    uint8_t  *tlm_gp_data_ptr;
    uint8_t  *tlm_gp_byte_enable_ptr;
    uint32_t  payload_byte_size;
    uint32_t  iter;
    // Copy data from nvdla_mac2accu_data_if_t to nvdla_mac2accu_data_monitor_t
    // Mask
    cc_payload_ptr->mask = payload->mask;
    cslDebug((70, "NvdlaCoreInternalMonitor::convolution_core_monitor_initiator_b_transport: cc_payload_ptr->mask is 0x%x, payload->mask is 0x%x\n", cc_payload_ptr->mask, payload->mask ));
    // Mode
    cc_payload_ptr->mode = payload->mode;
    cslDebug((70, "NvdlaCoreInternalMonitor::convolution_core_monitor_initiator_b_transport: cc_payload_ptr->mode is 0x%x, payload->mode is 0x%x\n", cc_payload_ptr->mode, payload->mode ));
    // Data
    cslAssert(get_array_len(cc_payload_ptr->data) == get_array_len(payload->data));
    for (iter = 0; iter < sizeof(cc_payload_ptr->data)/sizeof(cc_payload_ptr->data[0]); iter ++) {
        cc_payload_ptr->data[iter] = payload->data[iter].to_int();
    }
    // Stripe info
    cc_payload_ptr->nvdla_stripe_info = payload->pd.nvdla_stripe_info;
    payload_byte_size           = sizeof(nvdla_mac2accu_data_monitor_t)+1;
    cslDebug((70, "NvdlaCoreInternalMonitor::convolution_core_monitor_initiator_b_transport (nvdla_mac2accu_data_if_t), payload_byte_size is %0d", payload_byte_size));
    tlm_gp_data_ptr             = new uint8_t[payload_byte_size];
    tlm_gp_byte_enable_ptr      = new uint8_t[payload_byte_size];
    tlm_gp_data_ptr[0]          = id;
    // memcpy ((void*) &tlm_gp_data_ptr[1], (void *)payload, payload_byte_size-1);
    memcpy ((void*) &tlm_gp_data_ptr[1], (void *)cc_payload_ptr, payload_byte_size-1);
    memset(tlm_gp_byte_enable_ptr, 0xFF, payload_byte_size);
    convolution_core_monitor_initiator_payload.set_data_ptr( tlm_gp_data_ptr);
    convolution_core_monitor_initiator_payload.set_data_length(payload_byte_size);
    convolution_core_monitor_initiator_payload.set_byte_enable_ptr(tlm_gp_byte_enable_ptr);
    convolution_core_monitor_initiator_payload.set_byte_enable_length(payload_byte_size);
    convolution_core_monitor_initiator_payload.set_command(tlm::TLM_WRITE_COMMAND);
    convolution_core_monitor_initiator->b_transport (convolution_core_monitor_initiator_payload, delay);
    delete [] tlm_gp_data_ptr;
    delete [] tlm_gp_byte_enable_ptr;
    delete cc_payload_ptr;
}

// # Valid-Ready:   CACC-to-SDP, SDP-to-PDP
void NvdlaCoreInternalMonitor::post_processing_monitor_initiator_b_transport(nvdla_accu2pp_if_t* payload, sc_time& delay) {
    uint8_t  *tlm_gp_data_ptr;
    uint8_t  *tlm_gp_byte_enable_ptr;
    uint32_t  payload_byte_size;
    payload_byte_size           = sizeof(nvdla_accu2pp_if_t)+1;
    cslDebug((70, "NvdlaCoreInternalMonitor::post_processing_monitor_initiator_b_transport (nvdla_accu2pp_if_t), payload_byte_size is %0d", payload_byte_size));
    tlm_gp_data_ptr             = new uint8_t[payload_byte_size];
    tlm_gp_byte_enable_ptr      = new uint8_t[payload_byte_size];
    tlm_gp_data_ptr[0]          = TAG_CACC2SDP;
    memcpy ((void*) &tlm_gp_data_ptr[1], (void *)payload, payload_byte_size-1);
    memset(tlm_gp_byte_enable_ptr, 0xFF, payload_byte_size);
    post_processing_monitor_initiator_payload.set_data_ptr( tlm_gp_data_ptr);
    post_processing_monitor_initiator_payload.set_data_length(payload_byte_size);
    post_processing_monitor_initiator_payload.set_byte_enable_ptr(tlm_gp_byte_enable_ptr);
    post_processing_monitor_initiator_payload.set_byte_enable_length(payload_byte_size);
    post_processing_monitor_initiator_payload.set_command(tlm::TLM_WRITE_COMMAND);
    post_processing_monitor_initiator->b_transport (post_processing_monitor_initiator_payload, delay);
    delete [] tlm_gp_data_ptr;
    delete [] tlm_gp_byte_enable_ptr;
}

void NvdlaCoreInternalMonitor::post_processing_monitor_initiator_b_transport(nvdla_sdp2pdp_t* payload, sc_time& delay) {
    uint8_t  *tlm_gp_data_ptr;
    uint8_t  *tlm_gp_byte_enable_ptr;
    uint32_t  payload_byte_size;
    payload_byte_size           = sizeof(nvdla_sdp2pdp_t)+1;
    cslDebug((70, "NvdlaCoreInternalMonitor::post_processing_monitor_initiator_b_transport (nvdla_sdp2pdp_t), payload_byte_size is %0d", payload_byte_size));
    tlm_gp_data_ptr             = new uint8_t[payload_byte_size];
    tlm_gp_byte_enable_ptr      = new uint8_t[payload_byte_size];
    tlm_gp_data_ptr[0]          = TAG_SDP2PDP;
    memcpy ((void*) &tlm_gp_data_ptr[1], (void *)payload, payload_byte_size-1);
    memset(tlm_gp_byte_enable_ptr, 0xFF, payload_byte_size);
    post_processing_monitor_initiator_payload.set_data_ptr( tlm_gp_data_ptr);
    post_processing_monitor_initiator_payload.set_data_length(payload_byte_size);
    post_processing_monitor_initiator_payload.set_byte_enable_ptr(tlm_gp_byte_enable_ptr);
    post_processing_monitor_initiator_payload.set_byte_enable_length(payload_byte_size);
    post_processing_monitor_initiator_payload.set_command(tlm::TLM_WRITE_COMMAND);
    post_processing_monitor_initiator->b_transport (post_processing_monitor_initiator_payload, delay);
    delete [] tlm_gp_data_ptr;
    delete [] tlm_gp_byte_enable_ptr;
}

void NvdlaCoreInternalMonitor::cdma_wt_dma_arbiter_source_id_initiator_b_transport(int source_id, sc_time& delay) {
    uint8_t  *tlm_gp_data_ptr;
    uint8_t  *tlm_gp_byte_enable_ptr;
    uint32_t  payload_byte_size;
    payload_byte_size           = sizeof(int);
    tlm_gp_data_ptr             = new uint8_t[payload_byte_size];
    tlm_gp_byte_enable_ptr      = new uint8_t[payload_byte_size];
    memcpy ((void *) tlm_gp_data_ptr, (void *) &source_id, payload_byte_size);
    memset(tlm_gp_byte_enable_ptr, 0xFF, payload_byte_size);
    cdma_wt_dma_arbiter_source_id.set_data_ptr( tlm_gp_data_ptr);
    cdma_wt_dma_arbiter_source_id.set_data_length(payload_byte_size);
    cdma_wt_dma_arbiter_source_id.set_byte_enable_ptr(tlm_gp_byte_enable_ptr);
    cdma_wt_dma_arbiter_source_id.set_byte_enable_length(payload_byte_size);
    cdma_wt_dma_arbiter_source_id.set_command(tlm::TLM_WRITE_COMMAND);
    cdma_wt_dma_arbiter_source_id_initiator->b_transport (cdma_wt_dma_arbiter_source_id, delay);
    delete tlm_gp_data_ptr;
    delete tlm_gp_byte_enable_ptr;
}

// void NvdlaCoreInternalMonitor::(* payload, sc_time& delay) {
//     uint8_t  *tlm_gp_data_ptr;
//     uint8_t  *tlm_gp_byte_enable_ptr;
//     uint32_t  payload_byte_size;
//     payload_byte_size           = sizeof()+1;
//     tlm_gp_data_ptr             = new uint8_t[payload_byte_size];
//     tlm_gp_byte_enable_ptr      = new uint8_t[payload_byte_size];
//     tlm_gp_data_ptr[0]          = ;
//     memcpy ((void*) &tlm_gp_data_ptr[1], (void *)payload, payload_byte_size-1);
//     memset(tlm_gp_byte_enable_ptr, 0xFF, payload_byte_size);
//     .set_data_ptr( tlm_gp_data_ptr);
//     .set_data_length(payload_byte_size);
//     .set_byte_enable_ptr(tlm_gp_byte_enable_ptr);
//     .set_byte_enable_length(payload_byte_size);
//     .set_command(tlm::TLM_WRITE_COMMAND);
//     ->b_transport (, delay);
//     delete tlm_gp_data_ptr;
//     delete tlm_gp_byte_enable_ptr;
// }

NvdlaCoreInternalMonitor * NvdlaCoreInternalMonitorCon(sc_module_name name)
{
    return new NvdlaCoreInternalMonitor(name);
}

