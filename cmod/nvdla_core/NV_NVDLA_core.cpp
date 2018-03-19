// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_core.cpp

#include <algorithm>
#include <iomanip>
#include "NV_NVDLA_core.h"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>
#ifdef  NVDLA_REFERENCE_MODEL_ENABLE
#include "nvdla_scsv_register_extension_packer_defines.h"
#include "nvdla_dbb_scsv_extension_packer.h"
using namespace nvdla;
#endif

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace std;
using namespace tlm;
using namespace sc_core;

NV_NVDLA_core::NV_NVDLA_core( sc_module_name module_name, uint8_t nvdla_id_in ):
    NV_NVDLA_core_base(module_name),
    nvdla_id(nvdla_id_in),
    mcif2ext_wr_req("mcif2ext_wr_req"),
    ext2mcif_wr_rsp("ext2mcif_wr_rsp"),
    mcif2ext_rd_req("mcif2ext_rd_req"),
    ext2mcif_rd_rsp("ext2mcif_rd_rsp"),
    cvif2ext_wr_req("cvif2ext_wr_req"),
    ext2cvif_wr_rsp("ext2cvif_wr_rsp"),
    cvif2ext_rd_req("cvif2ext_rd_req"),
    ext2cvif_rd_rsp("ext2cvif_rd_rsp"),
    csb2nvdla_wr_hack("csb2nvdla_wr_hack"),
    mcif2bdma_wr_rsp("mcif2bdma_wr_rsp"),
    mcif2cdp_wr_rsp("mcif2cdp_wr_rsp"),
    mcif2pdp_wr_rsp("mcif2pdp_wr_rsp"),
    mcif2sdp_wr_rsp("mcif2sdp_wr_rsp"),
    mcif2rbk_wr_rsp("mcif2rbk_wr_rsp"),
    cvif2bdma_wr_rsp("cvif2bdma_wr_rsp"),
    cvif2cdp_wr_rsp("cvif2cdp_wr_rsp"),
    cvif2pdp_wr_rsp("cvif2pdp_wr_rsp"),
    cvif2sdp_wr_rsp("cvif2sdp_wr_rsp"),
    cvif2rbk_wr_rsp("cvif2rbk_wr_rsp"),
    cdma_wt_dma_arbiter_override_enable("cdma_wt_dma_arbiter_override_enable")
// For reference model usage, begin
#ifdef  NVDLA_REFERENCE_MODEL_ENABLE
    , dma_monitor_mc("dma_monitor_mc")
    , dma_monitor_cv("dma_monitor_cv")
    , convolution_core_monitor_initiator("convolution_core_monitor_initiator")
    , post_processing_monitor_initiator("post_processing_monitor_initiator")
    , dma_monitor_mc_credit("dma_monitor_mc_credit")
    , dma_monitor_cv_credit("dma_monitor_cv_credit")
    , convolution_core_monitor_credit("convolution_core_monitor_credit")
    , post_processing_monitor_credit("post_processing_monitor_credit")
#endif
{
    Initialize();
}
#pragma CTC SKIP
NV_NVDLA_core::NV_NVDLA_core( sc_module_name module_name ):
    NV_NVDLA_core_base(module_name),
    mcif2ext_wr_req("mcif2ext_wr_req"),
    ext2mcif_wr_rsp("ext2mcif_wr_rsp"),
    mcif2ext_rd_req("mcif2ext_rd_req"),
    ext2mcif_rd_rsp("ext2mcif_rd_rsp"),
    cvif2ext_wr_req("cvif2ext_wr_req"),
    ext2cvif_wr_rsp("ext2cvif_wr_rsp"),
    cvif2ext_rd_req("cvif2ext_rd_req"),
    ext2cvif_rd_rsp("ext2cvif_rd_rsp"),
    csb2nvdla_wr_hack("csb2nvdla_wr_hack"),
    mcif2bdma_wr_rsp("mcif2bdma_wr_rsp"),
    mcif2cdp_wr_rsp("mcif2cdp_wr_rsp"),
    mcif2pdp_wr_rsp("mcif2pdp_wr_rsp"),
    mcif2sdp_wr_rsp("mcif2sdp_wr_rsp"),
    mcif2rbk_wr_rsp("mcif2rbk_wr_rsp"),
    cvif2bdma_wr_rsp("cvif2bdma_wr_rsp"),
    cvif2cdp_wr_rsp("cvif2cdp_wr_rsp"),
    cvif2pdp_wr_rsp("cvif2pdp_wr_rsp"),
    cvif2sdp_wr_rsp("cvif2sdp_wr_rsp"),
    cvif2rbk_wr_rsp("cvif2rbk_wr_rsp"),
    cdma_wt_dma_arbiter_override_enable("cdma_wt_dma_arbiter_override_enable")
// For reference model usage, begin
#ifdef  NVDLA_REFERENCE_MODEL_ENABLE
    , dma_monitor_mc("dma_monitor_mc")
    , dma_monitor_cv("dma_monitor_cv")
    , convolution_core_monitor_initiator("convolution_core_monitor_initiator")
    , post_processing_monitor_initiator("post_processing_monitor_initiator")
    , dma_monitor_mc_credit("dma_monitor_mc_credit")
    , dma_monitor_cv_credit("dma_monitor_cv_credit")
    , convolution_core_monitor_credit("convolution_core_monitor_credit")
    , post_processing_monitor_credit("post_processing_monitor_credit")
#endif
// For reference model usage, end
{
    Initialize();
}
#pragma CTC ENDSKIP
void NV_NVDLA_core::Initialize()
{
    // Subunit instantiaation
    // # Interface modules
    csb_master  = new scsim::cmod::NV_NVDLA_csb_master("csb_master");
    bdma        = new scsim::cmod::NV_NVDLA_bdma("bdma");
    rbk         = new scsim::cmod::NV_NVDLA_rbk("rbk");
#ifdef  NVDLA_REFERENCE_MODEL_ENABLE
    mcif        = new scsim::cmod::NV_NVDLA_mcif("mcif", true, nvdla_id);
    cvif        = new scsim::cmod::NV_NVDLA_cvif("cvif", true, nvdla_id);
#else
    mcif        = new scsim::cmod::NV_NVDLA_mcif("mcif", false, nvdla_id);
    cvif        = new scsim::cmod::NV_NVDLA_cvif("cvif", false, nvdla_id);
#endif
    glb         = new scsim::cmod::NV_NVDLA_glb("glb");
    // # Convolution core
    cdma        = new scsim::cmod::NV_NVDLA_cdma("cdma");
    cbuf        = new scsim::cmod::NV_NVDLA_cbuf("cbuf");
    csc         = new scsim::cmod::NV_NVDLA_csc("csc");
    cmac_a      = new scsim::cmod::NV_NVDLA_cmac("cmac_a");
    cmac_b      = new scsim::cmod::NV_NVDLA_cmac("cmac_b");
    cacc        = new scsim::cmod::NV_NVDLA_cacc("cacc");
    // # Post processors
    sdp         = new scsim::cmod::NV_NVDLA_sdp("sdp");
    pdp         = new scsim::cmod::NV_NVDLA_pdp("pdp");
    cdp         = new scsim::cmod::NV_NVDLA_cdp("cdp");
    core_dummy  = new scsim::cmod::NvdlaCoreDummy("core_dummy");
// For reference model usage, begin
#ifdef  NVDLA_REFERENCE_MODEL_ENABLE
    internal_monitor = new scsim::cmod::NvdlaCoreInternalMonitor("internal_monitor");
    // Register the extension packers
    nvdla_scsv_converter::register_extension_packer<nvdla_dbb_scsv_extension_packer>(NVDLA_DBB_SCSV_EXTENSION_PACKER_ID);
    cdma_wt_dma_arbiter_override_enable = false;
#else
    cdma_wt_dma_arbiter_override_enable = false;
#endif
// For reference model usage, end


// For reference model usage, begin
#ifdef  NVDLA_REFERENCE_MODEL_ENABLE
//: print "    // CVIF read dma list: ";
//: print join(",",@project::NVDLA_GENERIC_CVIF_READ_DMA_LIST);
//: print "\n";
//: for my $index (0 .. $#project::NVDLA_GENERIC_CVIF_READ_DMA_LIST) {
//:     $dma        = lc $project::NVDLA_GENERIC_CVIF_READ_DMA_LIST[$index];
//:     @str_list   = split(/_/, $dma);
//:     $sub_unit   = $str_list[0];
//:     $req_socket_bind_str = sprintf("    ${sub_unit}->${dma}2cvif_rd_req(internal_monitor->${dma}2cvif_rd_req);\n", $sub_unit, $dma);
//:     print $req_socket_bind_str;
//:     chop($req_socket_bind_str);
//:     $rsp_socket_bind_str = sprintf("    cvif->cvif2${dma}_rd_rsp(internal_monitor->cvif2${dma}_rd_rsp);\n", $dma);
//:     print $rsp_socket_bind_str;
//:     chop($rsp_socket_bind_str);
//: }
//: print "    // CVIF write dma list: ";
//: print join(",",@project::NVDLA_GENERIC_CVIF_WRITE_DMA_LIST);
//: print "\n";
//: for my $index (0 .. $#project::NVDLA_GENERIC_CVIF_WRITE_DMA_LIST) {
//:     $dma         = lc $project::NVDLA_GENERIC_CVIF_WRITE_DMA_LIST[$index];
//:     $req_socket_bind_str = sprintf("    ${dma}->${dma}2cvif_wr_req(internal_monitor->${dma}2cvif_wr_req);\n", $dma);
//:     print $req_socket_bind_str;
//:     chop($req_socket_bind_str);
//:     $rsp_socket_bind_str = sprintf("    internal_monitor->cvif2${dma}_wr_rsp(cvif2${dma}_wr_rsp);\n", $dma);
//:     print $rsp_socket_bind_str;
//:     chop($rsp_socket_bind_str);
//: }
//| eperl: generated_beg (DO NOT EDIT BELOW)
    // CVIF read dma list: 
    // CVIF write dma list: 
//| eperl: generated_end (DO NOT EDIT ABOVE)
    // CVIF read dma list: BDMA,SDP,PDP,CDP,RBK,SDP_B,SDP_N,SDP_E,CDMA_DAT,CDMA_WT
    bdma->bdma2cvif_rd_req(internal_monitor->bdma2cvif_rd_req);
    cvif->cvif2bdma_rd_rsp(internal_monitor->cvif2bdma_rd_rsp);
    sdp->sdp2cvif_rd_req(internal_monitor->sdp2cvif_rd_req);
    cvif->cvif2sdp_rd_rsp(internal_monitor->cvif2sdp_rd_rsp);
    pdp->pdp2cvif_rd_req(internal_monitor->pdp2cvif_rd_req);
    cvif->cvif2pdp_rd_rsp(internal_monitor->cvif2pdp_rd_rsp);
    cdp->cdp2cvif_rd_req(internal_monitor->cdp2cvif_rd_req);
    cvif->cvif2cdp_rd_rsp(internal_monitor->cvif2cdp_rd_rsp);
    rbk->rbk2cvif_rd_req(internal_monitor->rbk2cvif_rd_req);
    cvif->cvif2rbk_rd_rsp(internal_monitor->cvif2rbk_rd_rsp);
    sdp->sdp_b2cvif_rd_req(internal_monitor->sdp_b2cvif_rd_req);
    cvif->cvif2sdp_b_rd_rsp(internal_monitor->cvif2sdp_b_rd_rsp);
    sdp->sdp_n2cvif_rd_req(internal_monitor->sdp_n2cvif_rd_req);
    cvif->cvif2sdp_n_rd_rsp(internal_monitor->cvif2sdp_n_rd_rsp);
    sdp->sdp_e2cvif_rd_req(internal_monitor->sdp_e2cvif_rd_req);
    cvif->cvif2sdp_e_rd_rsp(internal_monitor->cvif2sdp_e_rd_rsp);
    cdma->cdma_dat2cvif_rd_req(internal_monitor->cdma_dat2cvif_rd_req);
    cvif->cvif2cdma_dat_rd_rsp(internal_monitor->cvif2cdma_dat_rd_rsp);
    cdma->cdma_wt2cvif_rd_req(internal_monitor->cdma_wt2cvif_rd_req);
    cvif->cvif2cdma_wt_rd_rsp(internal_monitor->cvif2cdma_wt_rd_rsp);
    // CVIF write dma list: BDMA,SDP,PDP,CDP,RBK
    bdma->bdma2cvif_wr_req(internal_monitor->bdma2cvif_wr_req);
    internal_monitor->cvif2bdma_wr_rsp(cvif2bdma_wr_rsp);
    sdp->sdp2cvif_wr_req(internal_monitor->sdp2cvif_wr_req);
    internal_monitor->cvif2sdp_wr_rsp(cvif2sdp_wr_rsp);
    pdp->pdp2cvif_wr_req(internal_monitor->pdp2cvif_wr_req);
    internal_monitor->cvif2pdp_wr_rsp(cvif2pdp_wr_rsp);
    cdp->cdp2cvif_wr_req(internal_monitor->cdp2cvif_wr_req);
    internal_monitor->cvif2cdp_wr_rsp(cvif2cdp_wr_rsp);
    rbk->rbk2cvif_wr_req(internal_monitor->rbk2cvif_wr_req);
    internal_monitor->cvif2rbk_wr_rsp(cvif2rbk_wr_rsp);

//: print "    // MCIF read dma list: ";
//: print join(",",@project::NVDLA_GENERIC_MCIF_READ_DMA_LIST);
//: print "\n";
//: for my $index (0 .. $#project::NVDLA_GENERIC_MCIF_READ_DMA_LIST) {
//:     $dma         = lc $project::NVDLA_GENERIC_MCIF_READ_DMA_LIST[$index];
//:     @str_list   = split(/_/, $dma);
//:     $sub_unit   = $str_list[0];
//:     $req_socket_bind_str = sprintf("    ${sub_unit}->${dma}2mcif_rd_req(internal_monitor->${dma}2mcif_rd_req);\n", $sub_unit, $dma);
//:     print $req_socket_bind_str;
//:     chop($req_socket_bind_str);
//:     $rsp_socket_bind_str = sprintf("    mcif->mcif2${dma}_rd_rsp(internal_monitor->mcif2${dma}_rd_rsp);\n", $dma);
//:     print $rsp_socket_bind_str;
//:     chop($rsp_socket_bind_str);
//: }
//: print "    // MCIF write dma list: ";
//: print join(",",@project::NVDLA_GENERIC_MCIF_WRITE_DMA_LIST);
//: print "\n";
//: for my $index (0 .. $#project::NVDLA_GENERIC_MCIF_WRITE_DMA_LIST) {
//:     $dma         = lc $project::NVDLA_GENERIC_MCIF_WRITE_DMA_LIST[$index];
//:     $req_socket_bind_str = sprintf("    ${dma}->${dma}2mcif_wr_req(internal_monitor->${dma}2mcif_wr_req);\n", $dma);
//:     print $req_socket_bind_str;
//:     chop($req_socket_bind_str);
//:     $rsp_socket_bind_str = sprintf("    internal_monitor->mcif2${dma}_wr_rsp(mcif2${dma}_wr_rsp);\n", $dma);
//:     print $rsp_socket_bind_str;
//:     chop($rsp_socket_bind_str);
//: }
//| eperl: generated_beg (DO NOT EDIT BELOW)
    // MCIF read dma list: 
    // MCIF write dma list: 
//| eperl: generated_end (DO NOT EDIT ABOVE)
    // MCIF read dma list: BDMA,SDP,PDP,CDP,RBK,SDP_B,SDP_N,SDP_E,CDMA_DAT,CDMA_WT
    bdma->bdma2mcif_rd_req(internal_monitor->bdma2mcif_rd_req);
    mcif->mcif2bdma_rd_rsp(internal_monitor->mcif2bdma_rd_rsp);
    sdp->sdp2mcif_rd_req(internal_monitor->sdp2mcif_rd_req);
    mcif->mcif2sdp_rd_rsp(internal_monitor->mcif2sdp_rd_rsp);
    pdp->pdp2mcif_rd_req(internal_monitor->pdp2mcif_rd_req);
    mcif->mcif2pdp_rd_rsp(internal_monitor->mcif2pdp_rd_rsp);
    cdp->cdp2mcif_rd_req(internal_monitor->cdp2mcif_rd_req);
    mcif->mcif2cdp_rd_rsp(internal_monitor->mcif2cdp_rd_rsp);
    rbk->rbk2mcif_rd_req(internal_monitor->rbk2mcif_rd_req);
    mcif->mcif2rbk_rd_rsp(internal_monitor->mcif2rbk_rd_rsp);
    sdp->sdp_b2mcif_rd_req(internal_monitor->sdp_b2mcif_rd_req);
    mcif->mcif2sdp_b_rd_rsp(internal_monitor->mcif2sdp_b_rd_rsp);
    sdp->sdp_n2mcif_rd_req(internal_monitor->sdp_n2mcif_rd_req);
    mcif->mcif2sdp_n_rd_rsp(internal_monitor->mcif2sdp_n_rd_rsp);
    sdp->sdp_e2mcif_rd_req(internal_monitor->sdp_e2mcif_rd_req);
    mcif->mcif2sdp_e_rd_rsp(internal_monitor->mcif2sdp_e_rd_rsp);
    cdma->cdma_dat2mcif_rd_req(internal_monitor->cdma_dat2mcif_rd_req);
    mcif->mcif2cdma_dat_rd_rsp(internal_monitor->mcif2cdma_dat_rd_rsp);
    cdma->cdma_wt2mcif_rd_req(internal_monitor->cdma_wt2mcif_rd_req);
    mcif->mcif2cdma_wt_rd_rsp(internal_monitor->mcif2cdma_wt_rd_rsp);
    // MCIF write dma list: BDMA,SDP,PDP,CDP,RBK
    bdma->bdma2mcif_wr_req(internal_monitor->bdma2mcif_wr_req);
    internal_monitor->mcif2bdma_wr_rsp(mcif2bdma_wr_rsp);
    sdp->sdp2mcif_wr_req(internal_monitor->sdp2mcif_wr_req);
    internal_monitor->mcif2sdp_wr_rsp(mcif2sdp_wr_rsp);
    pdp->pdp2mcif_wr_req(internal_monitor->pdp2mcif_wr_req);
    internal_monitor->mcif2pdp_wr_rsp(mcif2pdp_wr_rsp);
    cdp->cdp2mcif_wr_req(internal_monitor->cdp2mcif_wr_req);
    internal_monitor->mcif2cdp_wr_rsp(mcif2cdp_wr_rsp);
    rbk->rbk2mcif_wr_req(internal_monitor->rbk2mcif_wr_req);
    internal_monitor->mcif2rbk_wr_rsp(mcif2rbk_wr_rsp);
    // Binding convolution core
    csc->sc2mac_dat_a(internal_monitor->sc2mac_dat_a);
    csc->sc2mac_wt_a (internal_monitor->sc2mac_wt_a);
    csc->sc2mac_dat_b(internal_monitor->sc2mac_dat_b);
    csc->sc2mac_wt_b (internal_monitor->sc2mac_wt_b);
    cmac_a->mac2accu (internal_monitor->mac_a2accu);
    cmac_b->mac2accu (internal_monitor->mac_b2accu);
    // Binding post processing
    cacc->cacc2sdp (internal_monitor->cacc2sdp);
    sdp->sdp2pdp   (internal_monitor->sdp2pdp);
    // -> (internal_monitor->);
    internal_monitor->dma_monitor_mc(this->dma_monitor_mc);
    internal_monitor->dma_monitor_cv(this->dma_monitor_cv);
    internal_monitor->convolution_core_monitor_initiator(this->convolution_core_monitor_initiator);
    internal_monitor->post_processing_monitor_initiator (this->post_processing_monitor_initiator);
    this->dma_monitor_mc_credit(internal_monitor->dma_monitor_mc_credit);
    this->dma_monitor_cv_credit(internal_monitor->dma_monitor_cv_credit);
    this->convolution_core_monitor_credit(internal_monitor->convolution_core_monitor_credit);
    this->post_processing_monitor_credit(internal_monitor->post_processing_monitor_credit);
    // Special socket for overriding cdma_weight internal arbiter source selection
    internal_monitor->cdma_wt_dma_arbiter_source_id_initiator(cdma->cdma_wt_dma_arbiter_source_id);
#endif
    // For reference model usage, end

    // Connection, begin
    // # Hierarchical binding external sockets
    // ##   CSB_MASTER
    csb_master->csb2nvdla.bind(this->csb2nvdla);
    csb_master->csb2nvdla_wr_hack(csb2nvdla_wr_hack);
    this->nvdla2csb.bind(csb_master->nvdla2csb);
    // ##   MCIF
    mcif->mcif2ext_wr_req.bind(this->mcif2ext_wr_req);
    mcif->mcif2ext_rd_req.bind(this->mcif2ext_rd_req);
    this->ext2mcif_wr_rsp.bind(mcif->ext2mcif_wr_rsp);
    this->ext2mcif_rd_rsp.bind(mcif->ext2mcif_rd_rsp);
    // ##   CVIF
    cvif->cvif2ext_wr_req.bind(this->cvif2ext_wr_req);
    cvif->cvif2ext_rd_req.bind(this->cvif2ext_rd_req);
    this->ext2cvif_wr_rsp.bind(cvif->ext2cvif_wr_rsp);
    this->ext2cvif_rd_rsp.bind(cvif->ext2cvif_rd_rsp);
    
    // # Connections between subunits
    // ##   CSB_MASTER and its clients
    // ###  Request
    csb_master->csb2bdma_req(bdma->csb2bdma_req);
    csb_master->csb2cdma_req(cdma->csb2cdma_req);
    csb_master->csb2csc_req(csc->csb2csc_req);
    csb_master->csb2cmac_a_req(cmac_a->csb2cmac_req);
    csb_master->csb2cmac_b_req(cmac_b->csb2cmac_req);
    csb_master->csb2cacc_req(cacc->csb2cacc_req);
    csb_master->csb2sdp_rdma_req(sdp->csb2sdp_rdma_req);
    csb_master->csb2sdp_req(sdp->csb2sdp_req);
    csb_master->csb2pdp_rdma_req(pdp->csb2pdp_rdma_req);
    csb_master->csb2pdp_req(pdp->csb2pdp_req);
    csb_master->csb2cdp_rdma_req(cdp->csb2cdp_rdma_req);
    csb_master->csb2cdp_req(cdp->csb2cdp_req);
    csb_master->csb2rbk_req(rbk->csb2rbk_req);
    csb_master->csb2glb_req(glb->csb2glb_req);
    csb_master->csb2gec_req(glb->csb2gec_req);
    csb_master->csb2cvif_req(core_dummy->csb2cvif_req);
    csb_master->csb2mcif_req(core_dummy->csb2mcif_req);
    // ###  Response
    bdma->bdma2csb_resp(csb_master->bdma2csb_resp);
    cdma->cdma2csb_resp(csb_master->cdma2csb_resp);
    csc->csc2csb_resp(csb_master->csc2csb_resp);
    cmac_a->cmac2csb_resp(csb_master->cmac_a2csb_resp);
    cmac_b->cmac2csb_resp(csb_master->cmac_b2csb_resp);
    cacc->cacc2csb_resp(csb_master->cacc2csb_resp);
    sdp->sdp_rdma2csb_resp(csb_master->sdp_rdma2csb_resp);
    sdp->sdp2csb_resp(csb_master->sdp2csb_resp);
    pdp->pdp_rdma2csb_resp(csb_master->pdp_rdma2csb_resp);
    pdp->pdp2csb_resp(csb_master->pdp2csb_resp);
    cdp->cdp_rdma2csb_resp(csb_master->cdp_rdma2csb_resp);
    cdp->cdp2csb_resp(csb_master->cdp2csb_resp);
    rbk->rbk2csb_resp(csb_master->rbk2csb_resp);
    glb->glb2csb_resp(csb_master->glb2csb_resp);
    glb->gec2csb_resp(csb_master->gec2csb_resp);
    core_dummy->cvif2csb_resp(csb_master->cvif2csb_resp);
    core_dummy->mcif2csb_resp(csb_master->mcif2csb_resp);
    // ##   MCIF and its clients
    // ###  Request
    bdma->bdma2mcif_rd_req(mcif->bdma2mcif_rd_req);
    cdma->cdma_dat2mcif_rd_req(mcif->cdma_dat2mcif_rd_req);
    cdma->cdma_wt2mcif_rd_req(mcif->cdma_wt2mcif_rd_req);
    sdp->sdp2mcif_rd_req(mcif->sdp2mcif_rd_req);
    sdp->sdp_b2mcif_rd_req(mcif->sdp_b2mcif_rd_req);
    sdp->sdp_n2mcif_rd_req(mcif->sdp_n2mcif_rd_req);
    sdp->sdp_e2mcif_rd_req(mcif->sdp_e2mcif_rd_req);
    pdp->pdp2mcif_rd_req(mcif->pdp2mcif_rd_req);
    cdp->cdp2mcif_rd_req.bind(mcif->cdp2mcif_rd_req); 
    rbk->rbk2mcif_rd_req(mcif->rbk2mcif_rd_req);
    bdma->bdma2mcif_wr_req(mcif->bdma2mcif_wr_req);
    sdp->sdp2mcif_wr_req(mcif->sdp2mcif_wr_req);
    pdp->pdp2mcif_wr_req(mcif->pdp2mcif_wr_req);
    cdp->cdp2mcif_wr_req(mcif->cdp2mcif_wr_req);
    rbk->rbk2mcif_wr_req(mcif->rbk2mcif_wr_req);
    // ###  Response
    mcif->mcif2bdma_rd_rsp(bdma->mcif2bdma_rd_rsp);
    mcif->mcif2cdma_dat_rd_rsp(cdma->mcif2cdma_dat_rd_rsp);
    mcif->mcif2cdma_wt_rd_rsp(cdma->mcif2cdma_wt_rd_rsp);
    mcif->mcif2sdp_rd_rsp(sdp->mcif2sdp_rd_rsp);
    mcif->mcif2sdp_b_rd_rsp(sdp->mcif2sdp_b_rd_rsp);
    mcif->mcif2sdp_n_rd_rsp(sdp->mcif2sdp_n_rd_rsp);
    mcif->mcif2sdp_e_rd_rsp(sdp->mcif2sdp_e_rd_rsp);
    mcif->mcif2pdp_rd_rsp(pdp->mcif2pdp_rd_rsp);
    mcif->mcif2cdp_rd_rsp(cdp->mcif2cdp_rd_rsp);
    mcif->mcif2rbk_rd_rsp(rbk->mcif2rbk_rd_rsp);
    mcif->mcif2bdma_wr_rsp(mcif2bdma_wr_rsp);
    mcif->mcif2sdp_wr_rsp(mcif2sdp_wr_rsp);
    mcif->mcif2pdp_wr_rsp(mcif2pdp_wr_rsp);
    mcif->mcif2cdp_wr_rsp(mcif2cdp_wr_rsp);
    mcif->mcif2rbk_wr_rsp(mcif2rbk_wr_rsp);
    bdma->mcif2bdma_wr_rsp(mcif2bdma_wr_rsp);
    sdp->mcif2sdp_wr_rsp(mcif2sdp_wr_rsp);
    pdp->mcif2pdp_wr_rsp(mcif2pdp_wr_rsp);
    cdp->mcif2cdp_wr_rsp(mcif2cdp_wr_rsp);
    rbk->mcif2rbk_wr_rsp(mcif2rbk_wr_rsp);
    // ##   CVIF and its clients
    // ###  Request
    bdma->bdma2cvif_rd_req(cvif->bdma2cvif_rd_req);
    cdma->cdma_dat2cvif_rd_req(cvif->cdma_dat2cvif_rd_req);
    cdma->cdma_wt2cvif_rd_req(cvif->cdma_wt2cvif_rd_req);
    sdp->sdp2cvif_rd_req(cvif->sdp2cvif_rd_req);
    sdp->sdp_b2cvif_rd_req(cvif->sdp_b2cvif_rd_req);
    sdp->sdp_n2cvif_rd_req(cvif->sdp_n2cvif_rd_req);
    sdp->sdp_e2cvif_rd_req(cvif->sdp_e2cvif_rd_req);
    pdp->pdp2cvif_rd_req(cvif->pdp2cvif_rd_req);
    cdp->cdp2cvif_rd_req(cvif->cdp2cvif_rd_req);
    rbk->rbk2cvif_rd_req(cvif->rbk2cvif_rd_req);
    bdma->bdma2cvif_wr_req(cvif->bdma2cvif_wr_req);
    sdp->sdp2cvif_wr_req(cvif->sdp2cvif_wr_req);
    pdp->pdp2cvif_wr_req(cvif->pdp2cvif_wr_req);
    cdp->cdp2cvif_wr_req.bind(cvif->cdp2cvif_wr_req);
    rbk->rbk2cvif_wr_req(cvif->rbk2cvif_wr_req);
    // ###  Response
    cvif->cvif2bdma_rd_rsp(bdma->cvif2bdma_rd_rsp);
    cvif->cvif2cdma_dat_rd_rsp(cdma->cvif2cdma_dat_rd_rsp);
    cvif->cvif2cdma_wt_rd_rsp(cdma->cvif2cdma_wt_rd_rsp);
    cvif->cvif2sdp_rd_rsp(sdp->cvif2sdp_rd_rsp);
    cvif->cvif2sdp_b_rd_rsp(sdp->cvif2sdp_b_rd_rsp);
    cvif->cvif2sdp_n_rd_rsp(sdp->cvif2sdp_n_rd_rsp);
    cvif->cvif2sdp_e_rd_rsp(sdp->cvif2sdp_e_rd_rsp);
    cvif->cvif2pdp_rd_rsp(pdp->cvif2pdp_rd_rsp);
    cvif->cvif2cdp_rd_rsp(cdp->cvif2cdp_rd_rsp);
    cvif->cvif2rbk_rd_rsp(rbk->cvif2rbk_rd_rsp);
    cvif->cvif2bdma_wr_rsp(cvif2bdma_wr_rsp);
    cvif->cvif2sdp_wr_rsp(cvif2sdp_wr_rsp);
    cvif->cvif2pdp_wr_rsp(cvif2pdp_wr_rsp);
    cvif->cvif2cdp_wr_rsp(cvif2cdp_wr_rsp);
    cvif->cvif2rbk_wr_rsp(cvif2rbk_wr_rsp);
    bdma->cvif2bdma_wr_rsp(cvif2bdma_wr_rsp);
    sdp->cvif2sdp_wr_rsp(cvif2sdp_wr_rsp);
    pdp->cvif2pdp_wr_rsp(cvif2pdp_wr_rsp);
    cdp->cvif2cdp_wr_rsp(cvif2cdp_wr_rsp);
    rbk->cvif2rbk_wr_rsp(cvif2rbk_wr_rsp);
    bdma->bdma2glb_done_intr[0] (bdma2glb_done_intr[0]); 
    bdma->bdma2glb_done_intr[1] (bdma2glb_done_intr[1]); 
    glb->bdma2glb_done_intr[0] (bdma2glb_done_intr[0]); 
    glb->bdma2glb_done_intr[1] (bdma2glb_done_intr[1]); 

    cdma->cdma_dat2glb_done_intr[0] (cdma_dat2glb_done_intr[0]); 
    cdma->cdma_dat2glb_done_intr[1] (cdma_dat2glb_done_intr[1]); 
    glb->cdma_dat2glb_done_intr[0] (cdma_dat2glb_done_intr[0]); 
    glb->cdma_dat2glb_done_intr[1] (cdma_dat2glb_done_intr[1]); 

    cdma->cdma_wt2glb_done_intr[0] (cdma_wt2glb_done_intr[0]); 
    cdma->cdma_wt2glb_done_intr[1] (cdma_wt2glb_done_intr[1]); 
    glb->cdma_wt2glb_done_intr[0] (cdma_wt2glb_done_intr[0]); 
    glb->cdma_wt2glb_done_intr[1] (cdma_wt2glb_done_intr[1]); 

    pdp->pdp2glb_done_intr[0] (pdp2glb_done_intr[0]); 
    pdp->pdp2glb_done_intr[1] (pdp2glb_done_intr[1]); 
    glb->pdp2glb_done_intr[0] (pdp2glb_done_intr[0]); 
    glb->pdp2glb_done_intr[1] (pdp2glb_done_intr[1]); 

    sdp->sdp2glb_done_intr[0] (sdp2glb_done_intr[0]); 
    sdp->sdp2glb_done_intr[1] (sdp2glb_done_intr[1]); 
    glb->sdp2glb_done_intr[0] (sdp2glb_done_intr[0]); 
    glb->sdp2glb_done_intr[1] (sdp2glb_done_intr[1]); 

    cdp->cdp2glb_done_intr[0] (cdp2glb_done_intr[0]); 
    cdp->cdp2glb_done_intr[1] (cdp2glb_done_intr[1]); 
    glb->cdp2glb_done_intr[0] (cdp2glb_done_intr[0]); 
    glb->cdp2glb_done_intr[1] (cdp2glb_done_intr[1]); 

    rbk->rbk2glb_done_intr[0] (rbk2glb_done_intr[0]); 
    rbk->rbk2glb_done_intr[1] (rbk2glb_done_intr[1]); 
    glb->rbk2glb_done_intr[0] (rbk2glb_done_intr[0]); 
    glb->rbk2glb_done_intr[1] (rbk2glb_done_intr[1]); 

    cacc->cacc2glb_done_intr[0] (cacc2glb_done_intr[0]); 
    cacc->cacc2glb_done_intr[1] (cacc2glb_done_intr[1]); 
    glb->cacc2glb_done_intr[0] (cacc2glb_done_intr[0]); 
    glb->cacc2glb_done_intr[1] (cacc2glb_done_intr[1]); 

    // ## GLB's intr ouput
    glb->nvdla_intr (nvdla_intr);

    // ## CDMA <--> CBUF
    cdma->cdma2buf_dat_wr(cbuf->cdma2buf_dat_wr);
    cdma->cdma2buf_wt_wr(cbuf->cdma2buf_wt_wr);
    // ## CDMA <--> CSC
    cdma->dat_up_cdma2sc(csc->dat_up_cdma2sc);
    cdma->wt_up_cdma2sc(csc->wt_up_cdma2sc);
    csc->dat_up_sc2cdma(cdma->dat_up_sc2cdma);
    csc->wt_up_sc2cdma(cdma->wt_up_sc2cdma);
    // ## CBUF <--> CSC
    csc->sc2buf_dat_rd(cbuf->sc2buf_dat_rd);
    csc->sc2buf_wt_rd (cbuf->sc2buf_wt_rd );
    csc->sc2buf_wmb_rd(cbuf->sc2buf_wmb_rd);
    // ## CSC  <--> CMAC
    csc->sc2mac_dat_a(cmac_a->sc2mac_dat);
    csc->sc2mac_dat_b(cmac_b->sc2mac_dat);
    csc->sc2mac_wt_a (cmac_a->sc2mac_wt);
    csc->sc2mac_wt_b (cmac_b->sc2mac_wt);
    // ## CMAC <--> CACC
    cmac_a->mac2accu(cacc->mac_a2accu);
    cmac_b->mac2accu(cacc->mac_b2accu);
    // ## CSC  <--> CACC
    cacc->accu2sc_credit(csc->accu2sc_credit);
    // ## CACC <--> SDP
    cacc->cacc2sdp(sdp->cacc2sdp);
    // ## SDP  <--> PDP
    sdp->sdp2pdp(pdp->sdp2pdp);

    cdma->cdma_wt_dma_arbiter_override_enable(cdma_wt_dma_arbiter_override_enable);
    // Connection, end


    // AXI workaround
    // # MC
    // this->ext2mcif_wr_rsp.register_b_transport(this, &NV_NVDLA_core::ext2mcif_wr_rsp_b_transport);
    // this->ext2mcif_rd_rsp.register_b_transport(this, &NV_NVDLA_core::ext2mcif_rd_rsp_b_transport);
    // # CVSRAM
    // this->ext2cvif_wr_rsp.register_b_transport(this, &NV_NVDLA_core::ext2cvif_wr_rsp_b_transport);
    // this->ext2cvif_rd_rsp.register_b_transport(this, &NV_NVDLA_core::ext2cvif_rd_rsp_b_transport);
}
#pragma CTC SKIP
NV_NVDLA_core::~NV_NVDLA_core() {
    // # Interface modules
    delete csb_master;
    delete bdma;
    delete rbk;
    delete mcif;
    delete cvif;
    delete glb;
    // # Convolution core
    delete cdma;
    delete cbuf;
    delete csc;
    delete cmac_a;
    delete cmac_b;
    delete cacc;
    // # Post processors
    delete sdp;
    delete pdp;
    delete cdp;
    delete core_dummy;
#ifdef  NVDLA_REFERENCE_MODEL_ENABLE
    delete internal_monitor;
#endif
}
#pragma CTC ENDSKIP
// Target socket hierarchical call, begin
// # CSB_MASTER
// void NV_NVDLA_core::nvdla2csb_b_transport(int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay){
//     csb_master->nvdla2csb_b_transport(ID, payload, delay);
// }

// # MCIF
// void NV_NVDLA_core::ext2mcif_wr_rsp_b_transport(int ID, tlm::tlm_generic_payload& tlm_gp, sc_time& delay) {
//     mcif->ext2mcif_wr_rsp_b_transport(ID, tlm_gp, delay);
// }
// 
// void NV_NVDLA_core::ext2mcif_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& tlm_gp, sc_time& delay) {
//     mcif->ext2mcif_rd_rsp_b_transport(ID, tlm_gp, delay);
// }

// # CVIF
// void NV_NVDLA_core::ext2cvif_wr_rsp_b_transport(int ID, tlm::tlm_generic_payload& tlm_gp, sc_time& delay) {
//     cvif->ext2cvif_wr_rsp_b_transport(ID, tlm_gp, delay);
// }
// 
// void NV_NVDLA_core::ext2cvif_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& tlm_gp, sc_time& delay) {
//     cvif->ext2cvif_rd_rsp_b_transport(ID, tlm_gp, delay);
// }
// Target socket hierarchical call, end

// void NV_NVDLA_core::Reset()
// {
// }

// NV_NVDLA_core * NV_NVDLA_coreCon(sc_module_name name)
// {
//     return new NV_NVDLA_core(name);
// }
