// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_nvdla.cpp

#include "NV_nvdla.h"
#include "NV_NVDLA_core.h"
#include "NvdlaAxiAdaptor.h"
#include "NvdlaTopDummy.h"
#include "NvdlaCsbAdaptor.h"
USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace tlm;
using namespace sc_core;

NV_nvdla::NV_nvdla( sc_module_name module_name, uint8_t id, bool sctb_args )
    : NV_nvdla_base(module_name),
      nvdla_core( 0 ), 
      csb_adaptor( 0 ),
      axi_adaptor_mc( 0 ), axi_adaptor_cv( 0 ),
      nvdla_top_dummy( 0 )
// For reference model usage, begin
#ifdef  NVDLA_REFERENCE_MODEL_ENABLE
      , dma_monitor_mc("dma_monitor_mc")
      , dma_monitor_cv("dma_monitor_cv")
      , convolution_core_monitor_initiator("convolution_core_monitor_initiator" )
      , post_processing_monitor_initiator("post_processing_monitor_initiator")
      , dma_monitor_mc_credit("dma_monitor_mc_credit")
      , dma_monitor_cv_credit("dma_monitor_cv_credit")
      , convolution_core_monitor_credit("convolution_core_monitor_credit")
      , post_processing_monitor_credit("post_processing_monitor_credit")
#endif
// For reference model usage, end
{
    csb_adaptor = new NvdlaCsbAdaptor( "nvdla_csb_adaptor" );
    axi_adaptor_mc = new NvdlaAxiAdaptor("axi_adaptor_mc");
    axi_adaptor_cv = new NvdlaAxiAdaptor("axi_adaptor_cv");
    nvdla_top_dummy = new NvdlaTopDummy("nvdla_top_dummy");

#define QUOTE(name) #name
#define STR(macro) QUOTE(macro)


    nvdla_core = new NV_NVDLA_core("nvdla_core", 1);
        
    // CSB
    this->nvdla_host_master_if.bind( csb_adaptor->csb_nvdla_bus );
#pragma CTC ENDSKIP
    csb_adaptor->adaptor2csb.bind( nvdla_core->nvdla2csb );
    nvdla_core->csb2nvdla.bind( csb_adaptor->csb2adaptor );

    // NVDLA core to DBB, CVSRAM
    nvdla_core->mcif2ext_wr_req.bind( axi_adaptor_mc->customized_wr_req );
    nvdla_core->mcif2ext_rd_req.bind( axi_adaptor_mc->customized_rd_req );
    nvdla_core->cvif2ext_wr_req.bind( axi_adaptor_cv->customized_wr_req );
    nvdla_core->cvif2ext_rd_req.bind( axi_adaptor_cv->customized_rd_req );
    axi_adaptor_mc->customized_wr_rsp.bind( nvdla_core->ext2mcif_wr_rsp );
    axi_adaptor_mc->customized_rd_rsp.bind( nvdla_core->ext2mcif_rd_rsp );
    axi_adaptor_cv->customized_wr_rsp.bind( nvdla_core->ext2cvif_wr_rsp );
    axi_adaptor_cv->customized_rd_rsp.bind( nvdla_core->ext2cvif_rd_rsp );
    axi_adaptor_mc->standard_axi.bind( this->nvdla_core2dbb_axi4 );
    axi_adaptor_cv->standard_axi.bind( this->nvdla_core2cvsram_axi4 );


    // Interrupts

    nvdla_core->nvdla_intr( nvdla_intr );

    // Dummy
    nvdla_core->csb2nvdla_wr_hack( nvdla_top_dummy->m_target );

// For reference model usage, begin
#ifdef  NVDLA_REFERENCE_MODEL_ENABLE
    nvdla_core->dma_monitor_mc(dma_monitor_mc);
    nvdla_core->dma_monitor_cv(dma_monitor_cv);
    nvdla_core->convolution_core_monitor_initiator(convolution_core_monitor_initiator);                                                                                                   
    nvdla_core->post_processing_monitor_initiator(post_processing_monitor_initiator);
    dma_monitor_mc_credit(nvdla_core->dma_monitor_mc_credit);
    dma_monitor_cv_credit(nvdla_core->dma_monitor_cv_credit);
    convolution_core_monitor_credit(nvdla_core->convolution_core_monitor_credit);
    post_processing_monitor_credit(nvdla_core->post_processing_monitor_credit);
#endif
// For reference model usage, end
}
#pragma CTC SKIP
NV_nvdla::~NV_nvdla()
{
    if( nvdla_core     ) delete nvdla_core;
    if( nvdla_top_dummy) delete nvdla_top_dummy;
    if( axi_adaptor_cv ) delete axi_adaptor_cv;
    if( axi_adaptor_mc ) delete axi_adaptor_mc;
    if( csb_adaptor    ) delete csb_adaptor;

}

NV_nvdla * NV_nvdlaCon(sc_module_name name, uint8_t inst)
{
    return new NV_nvdla(name, inst);
}
#pragma CTC ENDSKIP
