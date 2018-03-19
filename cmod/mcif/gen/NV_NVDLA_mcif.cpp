// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_mcif.cpp

#include <algorithm>
#include <iomanip>
#include "NV_NVDLA_mcif.h"
#include "opendla.uh"
#include "opendla.h"
#include "cmacros.uh"
#include "math.h"
#include "nvdla_config.h"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>


USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace std;
using namespace tlm;
using namespace sc_core;

NV_NVDLA_mcif::NV_NVDLA_mcif( sc_module_name module_name, bool headless_ntb_env_in, uint8_t nvdla_id_in):
    NV_NVDLA_mcif_base(module_name),
    headless_ntb_env(headless_ntb_env_in),
    nvdla_id(nvdla_id_in),
    // Delay setup
    mcif2ext_wr_req ("mcif2ext_wr_req"),
    mcif2ext_rd_req ("mcif2ext_rd_req"),
    ext2mcif_wr_rsp ("ext2mcif_wr_rsp"),
    ext2mcif_rd_rsp ("ext2mcif_rd_rsp"),
    dma_delay_(SC_ZERO_TIME),
    csb_delay_(SC_ZERO_TIME),
    axi_delay_(SC_ZERO_TIME)
{
    // Memory allocation

    // Request fifos
    #undef FIFO_NUM_FACTOR
    #define FIFO_NUM_FACTOR 1
    bdma_rd_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (8192*2*5*FIFO_NUM_FACTOR);
    bdma_rd_atom_enable_fifo_  = new sc_core::sc_fifo    <bool> (8192*4*5 * FIFO_NUM_FACTOR);
    mcif2bdma_rd_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*2*5*FIFO_NUM_FACTOR);             //256 atoms
    credit_mcif2bdma_rd_rsp_fifo_ = 8192*2*5*FIFO_NUM_FACTOR;   // Should be same as the depth of mcif2bdma_rd_rsp_fifo_
    bdma2mcif_rd_req_atom_num_fifo_ = new sc_core::sc_fifo <uint32_t> (8192*2*5*FIFO_NUM_FACTOR);    //1024 outstanding read requests
    bdma_rd_req_payload_ = NULL;
    // Request fifos
    #undef FIFO_NUM_FACTOR
    #define FIFO_NUM_FACTOR 1
    sdp_rd_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (8192*2*5*FIFO_NUM_FACTOR);
    sdp_rd_atom_enable_fifo_  = new sc_core::sc_fifo    <bool> (8192*4*5 * FIFO_NUM_FACTOR);
    mcif2sdp_rd_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*2*5*FIFO_NUM_FACTOR);             //256 atoms
    credit_mcif2sdp_rd_rsp_fifo_ = 8192*2*5*FIFO_NUM_FACTOR;   // Should be same as the depth of mcif2sdp_rd_rsp_fifo_
    sdp2mcif_rd_req_atom_num_fifo_ = new sc_core::sc_fifo <uint32_t> (8192*2*5*FIFO_NUM_FACTOR);    //1024 outstanding read requests
    sdp_rd_req_payload_ = NULL;
    // Request fifos
    #undef FIFO_NUM_FACTOR
    #define FIFO_NUM_FACTOR 1
    pdp_rd_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (8192*2*5*FIFO_NUM_FACTOR);
    pdp_rd_atom_enable_fifo_  = new sc_core::sc_fifo    <bool> (8192*4*5 * FIFO_NUM_FACTOR);
    mcif2pdp_rd_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*2*5*FIFO_NUM_FACTOR);             //256 atoms
    credit_mcif2pdp_rd_rsp_fifo_ = 8192*2*5*FIFO_NUM_FACTOR;   // Should be same as the depth of mcif2pdp_rd_rsp_fifo_
    pdp2mcif_rd_req_atom_num_fifo_ = new sc_core::sc_fifo <uint32_t> (8192*2*5*FIFO_NUM_FACTOR);    //1024 outstanding read requests
    pdp_rd_req_payload_ = NULL;
    // Request fifos
    #undef FIFO_NUM_FACTOR
    #define FIFO_NUM_FACTOR 1
    cdp_rd_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (8192*2*5*FIFO_NUM_FACTOR);
    cdp_rd_atom_enable_fifo_  = new sc_core::sc_fifo    <bool> (8192*4*5 * FIFO_NUM_FACTOR);
    mcif2cdp_rd_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*2*5*FIFO_NUM_FACTOR);             //256 atoms
    credit_mcif2cdp_rd_rsp_fifo_ = 8192*2*5*FIFO_NUM_FACTOR;   // Should be same as the depth of mcif2cdp_rd_rsp_fifo_
    cdp2mcif_rd_req_atom_num_fifo_ = new sc_core::sc_fifo <uint32_t> (8192*2*5*FIFO_NUM_FACTOR);    //1024 outstanding read requests
    cdp_rd_req_payload_ = NULL;
    // Request fifos
    #undef FIFO_NUM_FACTOR
    #define FIFO_NUM_FACTOR 1
    rbk_rd_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (8192*2*5*FIFO_NUM_FACTOR);
    rbk_rd_atom_enable_fifo_  = new sc_core::sc_fifo    <bool> (8192*4*5 * FIFO_NUM_FACTOR);
    mcif2rbk_rd_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*2*5*FIFO_NUM_FACTOR);             //256 atoms
    credit_mcif2rbk_rd_rsp_fifo_ = 8192*2*5*FIFO_NUM_FACTOR;   // Should be same as the depth of mcif2rbk_rd_rsp_fifo_
    rbk2mcif_rd_req_atom_num_fifo_ = new sc_core::sc_fifo <uint32_t> (8192*2*5*FIFO_NUM_FACTOR);    //1024 outstanding read requests
    rbk_rd_req_payload_ = NULL;
    // Request fifos
    #undef FIFO_NUM_FACTOR
    #define FIFO_NUM_FACTOR 1
    sdp_b_rd_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (8192*2*5*FIFO_NUM_FACTOR);
    sdp_b_rd_atom_enable_fifo_  = new sc_core::sc_fifo    <bool> (8192*4*5 * FIFO_NUM_FACTOR);
    mcif2sdp_b_rd_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*2*5*FIFO_NUM_FACTOR);             //256 atoms
    credit_mcif2sdp_b_rd_rsp_fifo_ = 8192*2*5*FIFO_NUM_FACTOR;   // Should be same as the depth of mcif2sdp_b_rd_rsp_fifo_
    sdp_b2mcif_rd_req_atom_num_fifo_ = new sc_core::sc_fifo <uint32_t> (8192*2*5*FIFO_NUM_FACTOR);    //1024 outstanding read requests
    sdp_b_rd_req_payload_ = NULL;
    // Request fifos
    #undef FIFO_NUM_FACTOR
    #define FIFO_NUM_FACTOR 1
    sdp_n_rd_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (8192*2*5*FIFO_NUM_FACTOR);
    sdp_n_rd_atom_enable_fifo_  = new sc_core::sc_fifo    <bool> (8192*4*5 * FIFO_NUM_FACTOR);
    mcif2sdp_n_rd_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*2*5*FIFO_NUM_FACTOR);             //256 atoms
    credit_mcif2sdp_n_rd_rsp_fifo_ = 8192*2*5*FIFO_NUM_FACTOR;   // Should be same as the depth of mcif2sdp_n_rd_rsp_fifo_
    sdp_n2mcif_rd_req_atom_num_fifo_ = new sc_core::sc_fifo <uint32_t> (8192*2*5*FIFO_NUM_FACTOR);    //1024 outstanding read requests
    sdp_n_rd_req_payload_ = NULL;
    // Request fifos
    #undef FIFO_NUM_FACTOR
    #define FIFO_NUM_FACTOR 1
    sdp_e_rd_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (8192*2*5*FIFO_NUM_FACTOR);
    sdp_e_rd_atom_enable_fifo_  = new sc_core::sc_fifo    <bool> (8192*4*5 * FIFO_NUM_FACTOR);
    mcif2sdp_e_rd_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*2*5*FIFO_NUM_FACTOR);             //256 atoms
    credit_mcif2sdp_e_rd_rsp_fifo_ = 8192*2*5*FIFO_NUM_FACTOR;   // Should be same as the depth of mcif2sdp_e_rd_rsp_fifo_
    sdp_e2mcif_rd_req_atom_num_fifo_ = new sc_core::sc_fifo <uint32_t> (8192*2*5*FIFO_NUM_FACTOR);    //1024 outstanding read requests
    sdp_e_rd_req_payload_ = NULL;
    // Request fifos
    #undef FIFO_NUM_FACTOR
    #define FIFO_NUM_FACTOR 1
    cdma_dat_rd_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (8192*2*5*FIFO_NUM_FACTOR);
    cdma_dat_rd_atom_enable_fifo_  = new sc_core::sc_fifo    <bool> (8192*4*5 * FIFO_NUM_FACTOR);
    mcif2cdma_dat_rd_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*2*5*FIFO_NUM_FACTOR);             //256 atoms
    credit_mcif2cdma_dat_rd_rsp_fifo_ = 8192*2*5*FIFO_NUM_FACTOR;   // Should be same as the depth of mcif2cdma_dat_rd_rsp_fifo_
    cdma_dat2mcif_rd_req_atom_num_fifo_ = new sc_core::sc_fifo <uint32_t> (8192*2*5*FIFO_NUM_FACTOR);    //1024 outstanding read requests
    cdma_dat_rd_req_payload_ = NULL;
    // Request fifos
    #undef FIFO_NUM_FACTOR
    #define FIFO_NUM_FACTOR 1
    cdma_wt_rd_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (8192*2*5*FIFO_NUM_FACTOR);
    cdma_wt_rd_atom_enable_fifo_  = new sc_core::sc_fifo    <bool> (8192*4*5 * FIFO_NUM_FACTOR);
    mcif2cdma_wt_rd_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*2*5*FIFO_NUM_FACTOR);             //256 atoms
    credit_mcif2cdma_wt_rd_rsp_fifo_ = 8192*2*5*FIFO_NUM_FACTOR;   // Should be same as the depth of mcif2cdma_wt_rd_rsp_fifo_
    cdma_wt2mcif_rd_req_atom_num_fifo_ = new sc_core::sc_fifo <uint32_t> (8192*2*5*FIFO_NUM_FACTOR);    //1024 outstanding read requests
    cdma_wt_rd_req_payload_ = NULL;

    // Write request fifo
    bdma_wr_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (4096*FIFO_NUM_FACTOR);
    // write response ack control
    bdma_wr_required_ack_fifo_ = new sc_core::sc_fifo    <bool> (8192*5*FIFO_NUM_FACTOR);
    //bdma_wr_cmd_count_fifo_ = new sc_core::sc_fifo    <uint32_t> (4096*5*FIFO_NUM_FACTOR);
    bdma2mcif_wr_cmd_fifo_ = new sc_core::sc_fifo <client_wr_req_t*> (8192*5*FIFO_NUM_FACTOR);     //256 atoms
    bdma2mcif_wr_data_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*5*FIFO_NUM_FACTOR);            //1024 outstanding read requests
    // Write request fifo
    sdp_wr_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (4096*FIFO_NUM_FACTOR);
    // write response ack control
    sdp_wr_required_ack_fifo_ = new sc_core::sc_fifo    <bool> (8192*5*FIFO_NUM_FACTOR);
    //sdp_wr_cmd_count_fifo_ = new sc_core::sc_fifo    <uint32_t> (4096*5*FIFO_NUM_FACTOR);
    sdp2mcif_wr_cmd_fifo_ = new sc_core::sc_fifo <client_wr_req_t*> (8192*5*FIFO_NUM_FACTOR);     //256 atoms
    sdp2mcif_wr_data_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*5*FIFO_NUM_FACTOR);            //1024 outstanding read requests
    // Write request fifo
    pdp_wr_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (4096*FIFO_NUM_FACTOR);
    // write response ack control
    pdp_wr_required_ack_fifo_ = new sc_core::sc_fifo    <bool> (8192*5*FIFO_NUM_FACTOR);
    //pdp_wr_cmd_count_fifo_ = new sc_core::sc_fifo    <uint32_t> (4096*5*FIFO_NUM_FACTOR);
    pdp2mcif_wr_cmd_fifo_ = new sc_core::sc_fifo <client_wr_req_t*> (8192*5*FIFO_NUM_FACTOR);     //256 atoms
    pdp2mcif_wr_data_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*5*FIFO_NUM_FACTOR);            //1024 outstanding read requests
    // Write request fifo
    cdp_wr_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (4096*FIFO_NUM_FACTOR);
    // write response ack control
    cdp_wr_required_ack_fifo_ = new sc_core::sc_fifo    <bool> (8192*5*FIFO_NUM_FACTOR);
    //cdp_wr_cmd_count_fifo_ = new sc_core::sc_fifo    <uint32_t> (4096*5*FIFO_NUM_FACTOR);
    cdp2mcif_wr_cmd_fifo_ = new sc_core::sc_fifo <client_wr_req_t*> (8192*5*FIFO_NUM_FACTOR);     //256 atoms
    cdp2mcif_wr_data_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*5*FIFO_NUM_FACTOR);            //1024 outstanding read requests
    // Write request fifo
    rbk_wr_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (4096*FIFO_NUM_FACTOR);
    // write response ack control
    rbk_wr_required_ack_fifo_ = new sc_core::sc_fifo    <bool> (8192*5*FIFO_NUM_FACTOR);
    //rbk_wr_cmd_count_fifo_ = new sc_core::sc_fifo    <uint32_t> (4096*5*FIFO_NUM_FACTOR);
    rbk2mcif_wr_cmd_fifo_ = new sc_core::sc_fifo <client_wr_req_t*> (8192*5*FIFO_NUM_FACTOR);     //256 atoms
    rbk2mcif_wr_data_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*5*FIFO_NUM_FACTOR);            //1024 outstanding read requests

    
    // Register functions for AXI target sockets
    this->ext2mcif_wr_rsp.register_b_transport(this, &NV_NVDLA_mcif::ext2mcif_wr_rsp_b_transport);
    this->ext2mcif_rd_rsp.register_b_transport(this, &NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport);

    // Reset
    Reset();

    // THREAD

    SC_THREAD(ReadRequestArbiter)
    sensitive  << bdma_rd_req_fifo_->data_written_event()  << sdp_rd_req_fifo_->data_written_event()  << pdp_rd_req_fifo_->data_written_event()  << cdp_rd_req_fifo_->data_written_event()  << rbk_rd_req_fifo_->data_written_event()  << sdp_b_rd_req_fifo_->data_written_event()  << sdp_n_rd_req_fifo_->data_written_event()  << sdp_e_rd_req_fifo_->data_written_event()  << cdma_dat_rd_req_fifo_->data_written_event()  << cdma_wt_rd_req_fifo_->data_written_event()  << mcif2bdma_rd_rsp_fifo_->data_read_event()  << mcif2sdp_rd_rsp_fifo_->data_read_event()  << mcif2pdp_rd_rsp_fifo_->data_read_event()  << mcif2cdp_rd_rsp_fifo_->data_read_event()  << mcif2rbk_rd_rsp_fifo_->data_read_event()  << mcif2sdp_b_rd_rsp_fifo_->data_read_event()  << mcif2sdp_n_rd_rsp_fifo_->data_read_event()  << mcif2sdp_e_rd_rsp_fifo_->data_read_event()  << mcif2cdma_dat_rd_rsp_fifo_->data_read_event()  << mcif2cdma_wt_rd_rsp_fifo_->data_read_event()  ;

    SC_THREAD(WriteRequestArbiter)
    sensitive  << bdma_wr_req_fifo_->data_written_event()  << sdp_wr_req_fifo_->data_written_event()  << pdp_wr_req_fifo_->data_written_event()  << cdp_wr_req_fifo_->data_written_event()  << rbk_wr_req_fifo_->data_written_event()  ;




        SC_THREAD(ReadResp_mcif2bdma);

        SC_THREAD(ReadResp_mcif2sdp);

        SC_THREAD(ReadResp_mcif2pdp);

        SC_THREAD(ReadResp_mcif2cdp);

        SC_THREAD(ReadResp_mcif2rbk);

        SC_THREAD(ReadResp_mcif2sdp_b);

        SC_THREAD(ReadResp_mcif2sdp_n);

        SC_THREAD(ReadResp_mcif2sdp_e);

        SC_THREAD(ReadResp_mcif2cdma_dat);

        SC_THREAD(ReadResp_mcif2cdma_wt);


        SC_THREAD(WriteRequest_bdma2mcif);

        SC_THREAD(WriteRequest_sdp2mcif);

        SC_THREAD(WriteRequest_pdp2mcif);

        SC_THREAD(WriteRequest_cdp2mcif);

        SC_THREAD(WriteRequest_rbk2mcif);

}

#pragma CTC SKIP
NV_NVDLA_mcif::~NV_NVDLA_mcif() {

    // Read related pointers
    if( bdma_rd_req_fifo_ )             delete bdma_rd_req_fifo_;
        if( mcif2bdma_rd_rsp_fifo_ )   delete mcif2bdma_rd_rsp_fifo_;
    if( sdp_rd_req_fifo_ )             delete sdp_rd_req_fifo_;
        if( mcif2sdp_rd_rsp_fifo_ )   delete mcif2sdp_rd_rsp_fifo_;
    if( pdp_rd_req_fifo_ )             delete pdp_rd_req_fifo_;
        if( mcif2pdp_rd_rsp_fifo_ )   delete mcif2pdp_rd_rsp_fifo_;
    if( cdp_rd_req_fifo_ )             delete cdp_rd_req_fifo_;
        if( mcif2cdp_rd_rsp_fifo_ )   delete mcif2cdp_rd_rsp_fifo_;
    if( rbk_rd_req_fifo_ )             delete rbk_rd_req_fifo_;
        if( mcif2rbk_rd_rsp_fifo_ )   delete mcif2rbk_rd_rsp_fifo_;
    if( sdp_b_rd_req_fifo_ )             delete sdp_b_rd_req_fifo_;
        if( mcif2sdp_b_rd_rsp_fifo_ )   delete mcif2sdp_b_rd_rsp_fifo_;
    if( sdp_n_rd_req_fifo_ )             delete sdp_n_rd_req_fifo_;
        if( mcif2sdp_n_rd_rsp_fifo_ )   delete mcif2sdp_n_rd_rsp_fifo_;
    if( sdp_e_rd_req_fifo_ )             delete sdp_e_rd_req_fifo_;
        if( mcif2sdp_e_rd_rsp_fifo_ )   delete mcif2sdp_e_rd_rsp_fifo_;
    if( cdma_dat_rd_req_fifo_ )             delete cdma_dat_rd_req_fifo_;
        if( mcif2cdma_dat_rd_rsp_fifo_ )   delete mcif2cdma_dat_rd_rsp_fifo_;
    if( cdma_wt_rd_req_fifo_ )             delete cdma_wt_rd_req_fifo_;
        if( mcif2cdma_wt_rd_rsp_fifo_ )   delete mcif2cdma_wt_rd_rsp_fifo_;

    // Write related pointers
    if( bdma_wr_req_fifo_ )             delete bdma_wr_req_fifo_;
    if( bdma_wr_required_ack_fifo_ )    delete bdma_wr_required_ack_fifo_;
    if( bdma_rd_atom_enable_fifo_ )     delete bdma_rd_atom_enable_fifo_;
    if( bdma2mcif_wr_cmd_fifo_ )        delete bdma2mcif_wr_cmd_fifo_;
    if( bdma2mcif_wr_data_fifo_ )       delete bdma2mcif_wr_data_fifo_;
    if( sdp_wr_req_fifo_ )             delete sdp_wr_req_fifo_;
    if( sdp_wr_required_ack_fifo_ )    delete sdp_wr_required_ack_fifo_;
    if( sdp_rd_atom_enable_fifo_ )     delete sdp_rd_atom_enable_fifo_;
    if( sdp2mcif_wr_cmd_fifo_ )        delete sdp2mcif_wr_cmd_fifo_;
    if( sdp2mcif_wr_data_fifo_ )       delete sdp2mcif_wr_data_fifo_;
    if( pdp_wr_req_fifo_ )             delete pdp_wr_req_fifo_;
    if( pdp_wr_required_ack_fifo_ )    delete pdp_wr_required_ack_fifo_;
    if( pdp_rd_atom_enable_fifo_ )     delete pdp_rd_atom_enable_fifo_;
    if( pdp2mcif_wr_cmd_fifo_ )        delete pdp2mcif_wr_cmd_fifo_;
    if( pdp2mcif_wr_data_fifo_ )       delete pdp2mcif_wr_data_fifo_;
    if( cdp_wr_req_fifo_ )             delete cdp_wr_req_fifo_;
    if( cdp_wr_required_ack_fifo_ )    delete cdp_wr_required_ack_fifo_;
    if( cdp_rd_atom_enable_fifo_ )     delete cdp_rd_atom_enable_fifo_;
    if( cdp2mcif_wr_cmd_fifo_ )        delete cdp2mcif_wr_cmd_fifo_;
    if( cdp2mcif_wr_data_fifo_ )       delete cdp2mcif_wr_data_fifo_;
    if( rbk_wr_req_fifo_ )             delete rbk_wr_req_fifo_;
    if( rbk_wr_required_ack_fifo_ )    delete rbk_wr_required_ack_fifo_;
    if( rbk_rd_atom_enable_fifo_ )     delete rbk_rd_atom_enable_fifo_;
    if( rbk2mcif_wr_cmd_fifo_ )        delete rbk2mcif_wr_cmd_fifo_;
    if( rbk2mcif_wr_data_fifo_ )       delete rbk2mcif_wr_data_fifo_;

}
#pragma CTC ENDSKIP


// DMA read request target sockets

void NV_NVDLA_mcif::bdma2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    // DMA request size unit is DLA_ATOM_SIZE bytes
    uint64_t base_addr, cur_address;
    uint64_t first_base_addr;
    uint64_t last_base_addr, last_actual_addr, last_aligned_addr;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_read=true;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    dla_b_transport_payload *bt_payload;

    payload_addr = payload->pd.dma_read_cmd.addr;
    payload_size = (payload->pd.dma_read_cmd.size + 1) * DLA_ATOM_SIZE; //payload_size's max value is 2^13

    first_base_addr = (payload_addr/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE; 

    last_actual_addr = payload_addr + payload_size;
    last_aligned_addr= ((last_actual_addr + AXI_ALIGN_SIZE - 1)/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE;
    last_base_addr   = last_aligned_addr - MEM_TRANSACTION_SIZE;
    total_axi_size = last_aligned_addr - first_base_addr;
    cslDebug((30, "XXXXXXX NV_NVDLA_mcif::bdma2mcif_rd_req_b_transport, first_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, total_axi_size, payload_addr, payload_size));

    cur_address = base_addr = first_base_addr;

    // Push the number of atoms of the request
    bdma2mcif_rd_req_atom_num_fifo_->write(payload_size/MIN_BUS_WIDTH);
    cslDebug((50, "NV_NVDLA_mcif::bdma2mcif_rd_req_b_transport, write 0x%x to bdma2mcif_rd_req_atom_num_fifo_, num_free:%d.\x0A", payload_size/MIN_BUS_WIDTH, bdma2mcif_rd_req_atom_num_fifo_->num_free()));

    //Split dma request to axi requests
    while(cur_address <= last_base_addr) {
        base_addr    = cur_address;
        cslDebug((50, "NV_NVDLA_mcif::bdma2mcif_rd_req_b_transport, prepare AXI transaction for address: 0x%lx\x0A", base_addr));
        // base_addr should be aligned to AXI_ALIGN_SIZE Byte
        // size_in_byte should be multiple of MEM_TRANSACTION_SIZE
        // if the data size required by dma mster is 32B, MCIF will drop the extra 32B when AXI returns
        size_in_byte = MEM_TRANSACTION_SIZE;
        while (((cur_address + MEM_TRANSACTION_SIZE) < (last_aligned_addr)) && ((cur_address + MEM_TRANSACTION_SIZE) % MCIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            size_in_byte += MEM_TRANSACTION_SIZE;
            cur_address  += MEM_TRANSACTION_SIZE;
        }
        cur_address += MEM_TRANSACTION_SIZE;
        cslDebug((50, "NV_NVDLA_mcif::bdma2mcif_rd_req_b_transport, cur_address=0x%lx base_addr=0x%lx size_in_byte=0x%x\x0A", cur_address, base_addr, size_in_byte));
    
        // Allocating memory for dla_b_transport_payload
        bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
        bt_payload->configure_gp(base_addr, size_in_byte, is_read);
        bt_payload->gp.get_extension(nvdla_dbb_ext);
        assert(nvdla_dbb_ext != NULL);
        axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
        // Setup byte enable in payload. Always read 64B from mcif and mcif, but drop unneeded 32B
        // Write true to *_rd_atom_enable_fifo_ when the 32B atom is needed by dma client
        // Write false to *_rd_atom_enable_fifo_ when the 32B atom is not needed by dma client (dma's addr is not aligned to 64B
        for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
            if ( ((base_addr + byte_iter >= payload_addr) && (base_addr + byte_iter < last_actual_addr)) ){
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
                if (0 == byte_iter%MIN_BUS_WIDTH) {
                    cslDebug((50, "NV_NVDLA_mcif::bdma2mcif_rd_req_b_transport, write true to bdma_rd_atom_enable_fifo_, num_free:%d\x0A", bdma_rd_atom_enable_fifo_->num_free()));
                    bdma_rd_atom_enable_fifo_->write(true);
                }
            } else {
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
                if (0 == byte_iter%MIN_BUS_WIDTH) {
                    cslDebug((50, "NV_NVDLA_mcif::bdma2mcif_rd_req_b_transport, write false to bdma_rd_atom_enable_fifo_, num_free:%d\x0A", bdma_rd_atom_enable_fifo_->num_free()));
                    bdma_rd_atom_enable_fifo_->write(false);
                }
            }
        }
        nvdla_dbb_ext->set_id(BDMA_AXI_ID);
        nvdla_dbb_ext->set_size(MEM_TRANSACTION_SIZE);
        nvdla_dbb_ext->set_length(size_in_byte/MEM_TRANSACTION_SIZE);
        // avoid warinig for unused variable
#pragma CTC SKIP
        if(size_in_byte%MEM_TRANSACTION_SIZE!=0)
            FAIL(("NV_NVDLA_mcif::bdma2mcif_rd_req_b_transport, size_in_byte is not multiple of MEM_TRANSACTION_SIZE. size_in_byte=0x%x", size_in_byte));
#pragma CTC ENDSKIP
        cslDebug((50, "NV_NVDLA_mcif::bdma2mcif_rd_req_b_transport, before sending data to bdma_rd_req_fifo_ addr=0x%lx, , num_free:%d\x0A", base_addr, bdma_rd_req_fifo_->num_free()));
        bdma_rd_req_fifo_->write(bt_payload);
        cslDebug((50, "NV_NVDLA_mcif::bdma2mcif_rd_req_b_transport, after sending data to bdma_rd_req_fifo_ addr=0x%lx\x0A", base_addr));

    }
    cslDebug((50, "NV_NVDLA_mcif::bdma2mcif_rd_req_b_transport, after spliting DMA transaction\x0A"));
}

void NV_NVDLA_mcif::ReadResp_mcif2bdma() {
    uint8_t    *axi_atom_ptr;
    uint32_t    atom_num_left;
    nvdla_dma_rd_rsp_t* dma_rd_rsp_payload = NULL;
    uint8_t           * dma_payload_data_ptr;
    uint32_t    idx;
    int         dla_atom_num = 0;

    atom_num_left = 0;
    while(true) {
        if(0 == atom_num_left) {
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2bdma, num_available:%d\x0A", bdma2mcif_rd_req_atom_num_fifo_->num_available()));
            atom_num_left = bdma2mcif_rd_req_atom_num_fifo_->read();
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2bdma, update atom_num_left from bdma2mcif_rd_req_atom_num_fifo_, atom_num_left is 0x%x\x0A", atom_num_left));
        }
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2bdma, atom_num_left is 0x%x\x0A", atom_num_left));

        dma_rd_rsp_payload      = new nvdla_dma_rd_rsp_t;
        dma_payload_data_ptr    = reinterpret_cast <uint8_t *> (dma_rd_rsp_payload->pd.dma_read_data.data);
        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x00;

        for(int atom_iter = 0; atom_iter < TRANSACTION_DMA_ATOMIC_NUM && atom_num_left > 0; atom_iter++) {
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2bdma, num_available:%d\x0A", mcif2bdma_rd_rsp_fifo_->num_available()));
            axi_atom_ptr = mcif2bdma_rd_rsp_fifo_->read();
            credit_mcif2bdma_rd_rsp_fifo_ ++;
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2bdma, read 1st atom of the 64B from mcif2bdma_rd_rsp_fifo_\x0A"));
            atom_num_left--;
            dla_atom_num = atom_iter*MIN_BUS_WIDTH/DLA_ATOM_SIZE;

            dma_rd_rsp_payload->pd.dma_read_data.mask |= 0x1 << dla_atom_num;
            memcpy (&dma_payload_data_ptr[atom_iter*MIN_BUS_WIDTH], axi_atom_ptr, MIN_BUS_WIDTH);
            delete[] axi_atom_ptr;
        }

        cslDebug((70, "NV_NVDLA_mcif::ReadResp_mcif2bdma, dma_rd_rsp_payload->pd.dma_read_data.mask is 0x%x\x0A", uint32_t(dma_rd_rsp_payload->pd.dma_read_data.mask)));
        cslDebug((70, "NV_NVDLA_mcif::ReadResp_mcif2bdma, dma_rd_rsp_payload->pd.dma_read_data.data are :\x0A"));
        for (idx = 0; idx < sizeof(dma_rd_rsp_payload->pd.dma_read_data.data)/sizeof(dma_rd_rsp_payload->pd.dma_read_data.data[0]); idx++) {
            cslDebug((70, "    0x%lx\x0A", uint64_t (dma_rd_rsp_payload->pd.dma_read_data.data[idx])));   // The size of data[idx] is 8bytes and its type is "unsigned long"
        }
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2bdma, before NV_NVDLA_mcif_base::mcif2bdma_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        NV_NVDLA_mcif_base::mcif2bdma_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2bdma, after NV_NVDLA_mcif_base::mcif2bdma_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        delete dma_rd_rsp_payload;
    }
}

void NV_NVDLA_mcif::sdp2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    // DMA request size unit is DLA_ATOM_SIZE bytes
    uint64_t base_addr, cur_address;
    uint64_t first_base_addr;
    uint64_t last_base_addr, last_actual_addr, last_aligned_addr;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_read=true;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    dla_b_transport_payload *bt_payload;

    payload_addr = payload->pd.dma_read_cmd.addr;
    payload_size = (payload->pd.dma_read_cmd.size + 1) * DLA_ATOM_SIZE; //payload_size's max value is 2^13

    first_base_addr = (payload_addr/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE; 

    last_actual_addr = payload_addr + payload_size;
    last_aligned_addr= ((last_actual_addr + AXI_ALIGN_SIZE - 1)/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE;
    last_base_addr   = last_aligned_addr - MEM_TRANSACTION_SIZE;
    total_axi_size = last_aligned_addr - first_base_addr;
    cslDebug((30, "XXXXXXX NV_NVDLA_mcif::sdp2mcif_rd_req_b_transport, first_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, total_axi_size, payload_addr, payload_size));

    cur_address = base_addr = first_base_addr;

    // Push the number of atoms of the request
    sdp2mcif_rd_req_atom_num_fifo_->write(payload_size/MIN_BUS_WIDTH);
    cslDebug((50, "NV_NVDLA_mcif::sdp2mcif_rd_req_b_transport, write 0x%x to sdp2mcif_rd_req_atom_num_fifo_, num_free:%d.\x0A", payload_size/MIN_BUS_WIDTH, sdp2mcif_rd_req_atom_num_fifo_->num_free()));

    //Split dma request to axi requests
    while(cur_address <= last_base_addr) {
        base_addr    = cur_address;
        cslDebug((50, "NV_NVDLA_mcif::sdp2mcif_rd_req_b_transport, prepare AXI transaction for address: 0x%lx\x0A", base_addr));
        // base_addr should be aligned to AXI_ALIGN_SIZE Byte
        // size_in_byte should be multiple of MEM_TRANSACTION_SIZE
        // if the data size required by dma mster is 32B, MCIF will drop the extra 32B when AXI returns
        size_in_byte = MEM_TRANSACTION_SIZE;
        while (((cur_address + MEM_TRANSACTION_SIZE) < (last_aligned_addr)) && ((cur_address + MEM_TRANSACTION_SIZE) % MCIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            size_in_byte += MEM_TRANSACTION_SIZE;
            cur_address  += MEM_TRANSACTION_SIZE;
        }
        cur_address += MEM_TRANSACTION_SIZE;
        cslDebug((50, "NV_NVDLA_mcif::sdp2mcif_rd_req_b_transport, cur_address=0x%lx base_addr=0x%lx size_in_byte=0x%x\x0A", cur_address, base_addr, size_in_byte));
    
        // Allocating memory for dla_b_transport_payload
        bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
        bt_payload->configure_gp(base_addr, size_in_byte, is_read);
        bt_payload->gp.get_extension(nvdla_dbb_ext);
        assert(nvdla_dbb_ext != NULL);
        axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
        // Setup byte enable in payload. Always read 64B from mcif and mcif, but drop unneeded 32B
        // Write true to *_rd_atom_enable_fifo_ when the 32B atom is needed by dma client
        // Write false to *_rd_atom_enable_fifo_ when the 32B atom is not needed by dma client (dma's addr is not aligned to 64B
        for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
            if ( ((base_addr + byte_iter >= payload_addr) && (base_addr + byte_iter < last_actual_addr)) ){
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
                if (0 == byte_iter%MIN_BUS_WIDTH) {
                    cslDebug((50, "NV_NVDLA_mcif::sdp2mcif_rd_req_b_transport, write true to sdp_rd_atom_enable_fifo_, num_free:%d\x0A", sdp_rd_atom_enable_fifo_->num_free()));
                    sdp_rd_atom_enable_fifo_->write(true);
                }
            } else {
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
                if (0 == byte_iter%MIN_BUS_WIDTH) {
                    cslDebug((50, "NV_NVDLA_mcif::sdp2mcif_rd_req_b_transport, write false to sdp_rd_atom_enable_fifo_, num_free:%d\x0A", sdp_rd_atom_enable_fifo_->num_free()));
                    sdp_rd_atom_enable_fifo_->write(false);
                }
            }
        }
        nvdla_dbb_ext->set_id(SDP_AXI_ID);
        nvdla_dbb_ext->set_size(MEM_TRANSACTION_SIZE);
        nvdla_dbb_ext->set_length(size_in_byte/MEM_TRANSACTION_SIZE);
        // avoid warinig for unused variable
#pragma CTC SKIP
        if(size_in_byte%MEM_TRANSACTION_SIZE!=0)
            FAIL(("NV_NVDLA_mcif::sdp2mcif_rd_req_b_transport, size_in_byte is not multiple of MEM_TRANSACTION_SIZE. size_in_byte=0x%x", size_in_byte));
#pragma CTC ENDSKIP
        cslDebug((50, "NV_NVDLA_mcif::sdp2mcif_rd_req_b_transport, before sending data to sdp_rd_req_fifo_ addr=0x%lx, , num_free:%d\x0A", base_addr, sdp_rd_req_fifo_->num_free()));
        sdp_rd_req_fifo_->write(bt_payload);
        cslDebug((50, "NV_NVDLA_mcif::sdp2mcif_rd_req_b_transport, after sending data to sdp_rd_req_fifo_ addr=0x%lx\x0A", base_addr));

    }
    cslDebug((50, "NV_NVDLA_mcif::sdp2mcif_rd_req_b_transport, after spliting DMA transaction\x0A"));
}

void NV_NVDLA_mcif::ReadResp_mcif2sdp() {
    uint8_t    *axi_atom_ptr;
    uint32_t    atom_num_left;
    nvdla_dma_rd_rsp_t* dma_rd_rsp_payload = NULL;
    uint8_t           * dma_payload_data_ptr;
    uint32_t    idx;
    int         dla_atom_num = 0;

    atom_num_left = 0;
    while(true) {
        if(0 == atom_num_left) {
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp, num_available:%d\x0A", sdp2mcif_rd_req_atom_num_fifo_->num_available()));
            atom_num_left = sdp2mcif_rd_req_atom_num_fifo_->read();
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp, update atom_num_left from sdp2mcif_rd_req_atom_num_fifo_, atom_num_left is 0x%x\x0A", atom_num_left));
        }
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp, atom_num_left is 0x%x\x0A", atom_num_left));

        dma_rd_rsp_payload      = new nvdla_dma_rd_rsp_t;
        dma_payload_data_ptr    = reinterpret_cast <uint8_t *> (dma_rd_rsp_payload->pd.dma_read_data.data);
        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x00;

        for(int atom_iter = 0; atom_iter < TRANSACTION_DMA_ATOMIC_NUM && atom_num_left > 0; atom_iter++) {
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp, num_available:%d\x0A", mcif2sdp_rd_rsp_fifo_->num_available()));
            axi_atom_ptr = mcif2sdp_rd_rsp_fifo_->read();
            credit_mcif2sdp_rd_rsp_fifo_ ++;
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp, read 1st atom of the 64B from mcif2sdp_rd_rsp_fifo_\x0A"));
            atom_num_left--;
            dla_atom_num = atom_iter*MIN_BUS_WIDTH/DLA_ATOM_SIZE;

            dma_rd_rsp_payload->pd.dma_read_data.mask |= 0x1 << dla_atom_num;
            memcpy (&dma_payload_data_ptr[atom_iter*MIN_BUS_WIDTH], axi_atom_ptr, MIN_BUS_WIDTH);
            delete[] axi_atom_ptr;
        }

        cslDebug((70, "NV_NVDLA_mcif::ReadResp_mcif2sdp, dma_rd_rsp_payload->pd.dma_read_data.mask is 0x%x\x0A", uint32_t(dma_rd_rsp_payload->pd.dma_read_data.mask)));
        cslDebug((70, "NV_NVDLA_mcif::ReadResp_mcif2sdp, dma_rd_rsp_payload->pd.dma_read_data.data are :\x0A"));
        for (idx = 0; idx < sizeof(dma_rd_rsp_payload->pd.dma_read_data.data)/sizeof(dma_rd_rsp_payload->pd.dma_read_data.data[0]); idx++) {
            cslDebug((70, "    0x%lx\x0A", uint64_t (dma_rd_rsp_payload->pd.dma_read_data.data[idx])));   // The size of data[idx] is 8bytes and its type is "unsigned long"
        }
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp, before NV_NVDLA_mcif_base::mcif2sdp_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        NV_NVDLA_mcif_base::mcif2sdp_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp, after NV_NVDLA_mcif_base::mcif2sdp_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        delete dma_rd_rsp_payload;
    }
}

void NV_NVDLA_mcif::pdp2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    // DMA request size unit is DLA_ATOM_SIZE bytes
    uint64_t base_addr, cur_address;
    uint64_t first_base_addr;
    uint64_t last_base_addr, last_actual_addr, last_aligned_addr;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_read=true;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    dla_b_transport_payload *bt_payload;

    payload_addr = payload->pd.dma_read_cmd.addr;
    payload_size = (payload->pd.dma_read_cmd.size + 1) * DLA_ATOM_SIZE; //payload_size's max value is 2^13

    first_base_addr = (payload_addr/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE; 

    last_actual_addr = payload_addr + payload_size;
    last_aligned_addr= ((last_actual_addr + AXI_ALIGN_SIZE - 1)/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE;
    last_base_addr   = last_aligned_addr - MEM_TRANSACTION_SIZE;
    total_axi_size = last_aligned_addr - first_base_addr;
    cslDebug((30, "XXXXXXX NV_NVDLA_mcif::pdp2mcif_rd_req_b_transport, first_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, total_axi_size, payload_addr, payload_size));

    cur_address = base_addr = first_base_addr;

    // Push the number of atoms of the request
    pdp2mcif_rd_req_atom_num_fifo_->write(payload_size/MIN_BUS_WIDTH);
    cslDebug((50, "NV_NVDLA_mcif::pdp2mcif_rd_req_b_transport, write 0x%x to pdp2mcif_rd_req_atom_num_fifo_, num_free:%d.\x0A", payload_size/MIN_BUS_WIDTH, pdp2mcif_rd_req_atom_num_fifo_->num_free()));

    //Split dma request to axi requests
    while(cur_address <= last_base_addr) {
        base_addr    = cur_address;
        cslDebug((50, "NV_NVDLA_mcif::pdp2mcif_rd_req_b_transport, prepare AXI transaction for address: 0x%lx\x0A", base_addr));
        // base_addr should be aligned to AXI_ALIGN_SIZE Byte
        // size_in_byte should be multiple of MEM_TRANSACTION_SIZE
        // if the data size required by dma mster is 32B, MCIF will drop the extra 32B when AXI returns
        size_in_byte = MEM_TRANSACTION_SIZE;
        while (((cur_address + MEM_TRANSACTION_SIZE) < (last_aligned_addr)) && ((cur_address + MEM_TRANSACTION_SIZE) % MCIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            size_in_byte += MEM_TRANSACTION_SIZE;
            cur_address  += MEM_TRANSACTION_SIZE;
        }
        cur_address += MEM_TRANSACTION_SIZE;
        cslDebug((50, "NV_NVDLA_mcif::pdp2mcif_rd_req_b_transport, cur_address=0x%lx base_addr=0x%lx size_in_byte=0x%x\x0A", cur_address, base_addr, size_in_byte));
    
        // Allocating memory for dla_b_transport_payload
        bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
        bt_payload->configure_gp(base_addr, size_in_byte, is_read);
        bt_payload->gp.get_extension(nvdla_dbb_ext);
        assert(nvdla_dbb_ext != NULL);
        axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
        // Setup byte enable in payload. Always read 64B from mcif and mcif, but drop unneeded 32B
        // Write true to *_rd_atom_enable_fifo_ when the 32B atom is needed by dma client
        // Write false to *_rd_atom_enable_fifo_ when the 32B atom is not needed by dma client (dma's addr is not aligned to 64B
        for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
            if ( ((base_addr + byte_iter >= payload_addr) && (base_addr + byte_iter < last_actual_addr)) ){
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
                if (0 == byte_iter%MIN_BUS_WIDTH) {
                    cslDebug((50, "NV_NVDLA_mcif::pdp2mcif_rd_req_b_transport, write true to pdp_rd_atom_enable_fifo_, num_free:%d\x0A", pdp_rd_atom_enable_fifo_->num_free()));
                    pdp_rd_atom_enable_fifo_->write(true);
                }
            } else {
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
                if (0 == byte_iter%MIN_BUS_WIDTH) {
                    cslDebug((50, "NV_NVDLA_mcif::pdp2mcif_rd_req_b_transport, write false to pdp_rd_atom_enable_fifo_, num_free:%d\x0A", pdp_rd_atom_enable_fifo_->num_free()));
                    pdp_rd_atom_enable_fifo_->write(false);
                }
            }
        }
        nvdla_dbb_ext->set_id(PDP_AXI_ID);
        nvdla_dbb_ext->set_size(MEM_TRANSACTION_SIZE);
        nvdla_dbb_ext->set_length(size_in_byte/MEM_TRANSACTION_SIZE);
        // avoid warinig for unused variable
#pragma CTC SKIP
        if(size_in_byte%MEM_TRANSACTION_SIZE!=0)
            FAIL(("NV_NVDLA_mcif::pdp2mcif_rd_req_b_transport, size_in_byte is not multiple of MEM_TRANSACTION_SIZE. size_in_byte=0x%x", size_in_byte));
#pragma CTC ENDSKIP
        cslDebug((50, "NV_NVDLA_mcif::pdp2mcif_rd_req_b_transport, before sending data to pdp_rd_req_fifo_ addr=0x%lx, , num_free:%d\x0A", base_addr, pdp_rd_req_fifo_->num_free()));
        pdp_rd_req_fifo_->write(bt_payload);
        cslDebug((50, "NV_NVDLA_mcif::pdp2mcif_rd_req_b_transport, after sending data to pdp_rd_req_fifo_ addr=0x%lx\x0A", base_addr));

    }
    cslDebug((50, "NV_NVDLA_mcif::pdp2mcif_rd_req_b_transport, after spliting DMA transaction\x0A"));
}

void NV_NVDLA_mcif::ReadResp_mcif2pdp() {
    uint8_t    *axi_atom_ptr;
    uint32_t    atom_num_left;
    nvdla_dma_rd_rsp_t* dma_rd_rsp_payload = NULL;
    uint8_t           * dma_payload_data_ptr;
    uint32_t    idx;
    int         dla_atom_num = 0;

    atom_num_left = 0;
    while(true) {
        if(0 == atom_num_left) {
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2pdp, num_available:%d\x0A", pdp2mcif_rd_req_atom_num_fifo_->num_available()));
            atom_num_left = pdp2mcif_rd_req_atom_num_fifo_->read();
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2pdp, update atom_num_left from pdp2mcif_rd_req_atom_num_fifo_, atom_num_left is 0x%x\x0A", atom_num_left));
        }
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2pdp, atom_num_left is 0x%x\x0A", atom_num_left));

        dma_rd_rsp_payload      = new nvdla_dma_rd_rsp_t;
        dma_payload_data_ptr    = reinterpret_cast <uint8_t *> (dma_rd_rsp_payload->pd.dma_read_data.data);
        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x00;

        for(int atom_iter = 0; atom_iter < TRANSACTION_DMA_ATOMIC_NUM && atom_num_left > 0; atom_iter++) {
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2pdp, num_available:%d\x0A", mcif2pdp_rd_rsp_fifo_->num_available()));
            axi_atom_ptr = mcif2pdp_rd_rsp_fifo_->read();
            credit_mcif2pdp_rd_rsp_fifo_ ++;
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2pdp, read 1st atom of the 64B from mcif2pdp_rd_rsp_fifo_\x0A"));
            atom_num_left--;
            dla_atom_num = atom_iter*MIN_BUS_WIDTH/DLA_ATOM_SIZE;

            dma_rd_rsp_payload->pd.dma_read_data.mask |= 0x1 << dla_atom_num;
            memcpy (&dma_payload_data_ptr[atom_iter*MIN_BUS_WIDTH], axi_atom_ptr, MIN_BUS_WIDTH);
            delete[] axi_atom_ptr;
        }

        cslDebug((70, "NV_NVDLA_mcif::ReadResp_mcif2pdp, dma_rd_rsp_payload->pd.dma_read_data.mask is 0x%x\x0A", uint32_t(dma_rd_rsp_payload->pd.dma_read_data.mask)));
        cslDebug((70, "NV_NVDLA_mcif::ReadResp_mcif2pdp, dma_rd_rsp_payload->pd.dma_read_data.data are :\x0A"));
        for (idx = 0; idx < sizeof(dma_rd_rsp_payload->pd.dma_read_data.data)/sizeof(dma_rd_rsp_payload->pd.dma_read_data.data[0]); idx++) {
            cslDebug((70, "    0x%lx\x0A", uint64_t (dma_rd_rsp_payload->pd.dma_read_data.data[idx])));   // The size of data[idx] is 8bytes and its type is "unsigned long"
        }
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2pdp, before NV_NVDLA_mcif_base::mcif2pdp_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        NV_NVDLA_mcif_base::mcif2pdp_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2pdp, after NV_NVDLA_mcif_base::mcif2pdp_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        delete dma_rd_rsp_payload;
    }
}

void NV_NVDLA_mcif::cdp2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    // DMA request size unit is DLA_ATOM_SIZE bytes
    uint64_t base_addr, cur_address;
    uint64_t first_base_addr;
    uint64_t last_base_addr, last_actual_addr, last_aligned_addr;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_read=true;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    dla_b_transport_payload *bt_payload;

    payload_addr = payload->pd.dma_read_cmd.addr;
    payload_size = (payload->pd.dma_read_cmd.size + 1) * DLA_ATOM_SIZE; //payload_size's max value is 2^13

    first_base_addr = (payload_addr/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE; 

    last_actual_addr = payload_addr + payload_size;
    last_aligned_addr= ((last_actual_addr + AXI_ALIGN_SIZE - 1)/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE;
    last_base_addr   = last_aligned_addr - MEM_TRANSACTION_SIZE;
    total_axi_size = last_aligned_addr - first_base_addr;
    cslDebug((30, "XXXXXXX NV_NVDLA_mcif::cdp2mcif_rd_req_b_transport, first_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, total_axi_size, payload_addr, payload_size));

    cur_address = base_addr = first_base_addr;

    // Push the number of atoms of the request
    cdp2mcif_rd_req_atom_num_fifo_->write(payload_size/MIN_BUS_WIDTH);
    cslDebug((50, "NV_NVDLA_mcif::cdp2mcif_rd_req_b_transport, write 0x%x to cdp2mcif_rd_req_atom_num_fifo_, num_free:%d.\x0A", payload_size/MIN_BUS_WIDTH, cdp2mcif_rd_req_atom_num_fifo_->num_free()));

    //Split dma request to axi requests
    while(cur_address <= last_base_addr) {
        base_addr    = cur_address;
        cslDebug((50, "NV_NVDLA_mcif::cdp2mcif_rd_req_b_transport, prepare AXI transaction for address: 0x%lx\x0A", base_addr));
        // base_addr should be aligned to AXI_ALIGN_SIZE Byte
        // size_in_byte should be multiple of MEM_TRANSACTION_SIZE
        // if the data size required by dma mster is 32B, MCIF will drop the extra 32B when AXI returns
        size_in_byte = MEM_TRANSACTION_SIZE;
        while (((cur_address + MEM_TRANSACTION_SIZE) < (last_aligned_addr)) && ((cur_address + MEM_TRANSACTION_SIZE) % MCIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            size_in_byte += MEM_TRANSACTION_SIZE;
            cur_address  += MEM_TRANSACTION_SIZE;
        }
        cur_address += MEM_TRANSACTION_SIZE;
        cslDebug((50, "NV_NVDLA_mcif::cdp2mcif_rd_req_b_transport, cur_address=0x%lx base_addr=0x%lx size_in_byte=0x%x\x0A", cur_address, base_addr, size_in_byte));
    
        // Allocating memory for dla_b_transport_payload
        bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
        bt_payload->configure_gp(base_addr, size_in_byte, is_read);
        bt_payload->gp.get_extension(nvdla_dbb_ext);
        assert(nvdla_dbb_ext != NULL);
        axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
        // Setup byte enable in payload. Always read 64B from mcif and mcif, but drop unneeded 32B
        // Write true to *_rd_atom_enable_fifo_ when the 32B atom is needed by dma client
        // Write false to *_rd_atom_enable_fifo_ when the 32B atom is not needed by dma client (dma's addr is not aligned to 64B
        for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
            if ( ((base_addr + byte_iter >= payload_addr) && (base_addr + byte_iter < last_actual_addr)) ){
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
                if (0 == byte_iter%MIN_BUS_WIDTH) {
                    cslDebug((50, "NV_NVDLA_mcif::cdp2mcif_rd_req_b_transport, write true to cdp_rd_atom_enable_fifo_, num_free:%d\x0A", cdp_rd_atom_enable_fifo_->num_free()));
                    cdp_rd_atom_enable_fifo_->write(true);
                }
            } else {
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
                if (0 == byte_iter%MIN_BUS_WIDTH) {
                    cslDebug((50, "NV_NVDLA_mcif::cdp2mcif_rd_req_b_transport, write false to cdp_rd_atom_enable_fifo_, num_free:%d\x0A", cdp_rd_atom_enable_fifo_->num_free()));
                    cdp_rd_atom_enable_fifo_->write(false);
                }
            }
        }
        nvdla_dbb_ext->set_id(CDP_AXI_ID);
        nvdla_dbb_ext->set_size(MEM_TRANSACTION_SIZE);
        nvdla_dbb_ext->set_length(size_in_byte/MEM_TRANSACTION_SIZE);
        // avoid warinig for unused variable
#pragma CTC SKIP
        if(size_in_byte%MEM_TRANSACTION_SIZE!=0)
            FAIL(("NV_NVDLA_mcif::cdp2mcif_rd_req_b_transport, size_in_byte is not multiple of MEM_TRANSACTION_SIZE. size_in_byte=0x%x", size_in_byte));
#pragma CTC ENDSKIP
        cslDebug((50, "NV_NVDLA_mcif::cdp2mcif_rd_req_b_transport, before sending data to cdp_rd_req_fifo_ addr=0x%lx, , num_free:%d\x0A", base_addr, cdp_rd_req_fifo_->num_free()));
        cdp_rd_req_fifo_->write(bt_payload);
        cslDebug((50, "NV_NVDLA_mcif::cdp2mcif_rd_req_b_transport, after sending data to cdp_rd_req_fifo_ addr=0x%lx\x0A", base_addr));

    }
    cslDebug((50, "NV_NVDLA_mcif::cdp2mcif_rd_req_b_transport, after spliting DMA transaction\x0A"));
}

void NV_NVDLA_mcif::ReadResp_mcif2cdp() {
    uint8_t    *axi_atom_ptr;
    uint32_t    atom_num_left;
    nvdla_dma_rd_rsp_t* dma_rd_rsp_payload = NULL;
    uint8_t           * dma_payload_data_ptr;
    uint32_t    idx;
    int         dla_atom_num = 0;

    atom_num_left = 0;
    while(true) {
        if(0 == atom_num_left) {
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdp, num_available:%d\x0A", cdp2mcif_rd_req_atom_num_fifo_->num_available()));
            atom_num_left = cdp2mcif_rd_req_atom_num_fifo_->read();
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdp, update atom_num_left from cdp2mcif_rd_req_atom_num_fifo_, atom_num_left is 0x%x\x0A", atom_num_left));
        }
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdp, atom_num_left is 0x%x\x0A", atom_num_left));

        dma_rd_rsp_payload      = new nvdla_dma_rd_rsp_t;
        dma_payload_data_ptr    = reinterpret_cast <uint8_t *> (dma_rd_rsp_payload->pd.dma_read_data.data);
        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x00;

        for(int atom_iter = 0; atom_iter < TRANSACTION_DMA_ATOMIC_NUM && atom_num_left > 0; atom_iter++) {
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdp, num_available:%d\x0A", mcif2cdp_rd_rsp_fifo_->num_available()));
            axi_atom_ptr = mcif2cdp_rd_rsp_fifo_->read();
            credit_mcif2cdp_rd_rsp_fifo_ ++;
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdp, read 1st atom of the 64B from mcif2cdp_rd_rsp_fifo_\x0A"));
            atom_num_left--;
            dla_atom_num = atom_iter*MIN_BUS_WIDTH/DLA_ATOM_SIZE;

            dma_rd_rsp_payload->pd.dma_read_data.mask |= 0x1 << dla_atom_num;
            memcpy (&dma_payload_data_ptr[atom_iter*MIN_BUS_WIDTH], axi_atom_ptr, MIN_BUS_WIDTH);
            delete[] axi_atom_ptr;
        }

        cslDebug((70, "NV_NVDLA_mcif::ReadResp_mcif2cdp, dma_rd_rsp_payload->pd.dma_read_data.mask is 0x%x\x0A", uint32_t(dma_rd_rsp_payload->pd.dma_read_data.mask)));
        cslDebug((70, "NV_NVDLA_mcif::ReadResp_mcif2cdp, dma_rd_rsp_payload->pd.dma_read_data.data are :\x0A"));
        for (idx = 0; idx < sizeof(dma_rd_rsp_payload->pd.dma_read_data.data)/sizeof(dma_rd_rsp_payload->pd.dma_read_data.data[0]); idx++) {
            cslDebug((70, "    0x%lx\x0A", uint64_t (dma_rd_rsp_payload->pd.dma_read_data.data[idx])));   // The size of data[idx] is 8bytes and its type is "unsigned long"
        }
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdp, before NV_NVDLA_mcif_base::mcif2cdp_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        NV_NVDLA_mcif_base::mcif2cdp_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdp, after NV_NVDLA_mcif_base::mcif2cdp_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        delete dma_rd_rsp_payload;
    }
}

void NV_NVDLA_mcif::rbk2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    // DMA request size unit is DLA_ATOM_SIZE bytes
    uint64_t base_addr, cur_address;
    uint64_t first_base_addr;
    uint64_t last_base_addr, last_actual_addr, last_aligned_addr;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_read=true;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    dla_b_transport_payload *bt_payload;

    payload_addr = payload->pd.dma_read_cmd.addr;
    payload_size = (payload->pd.dma_read_cmd.size + 1) * DLA_ATOM_SIZE; //payload_size's max value is 2^13

    first_base_addr = (payload_addr/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE; 

    last_actual_addr = payload_addr + payload_size;
    last_aligned_addr= ((last_actual_addr + AXI_ALIGN_SIZE - 1)/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE;
    last_base_addr   = last_aligned_addr - MEM_TRANSACTION_SIZE;
    total_axi_size = last_aligned_addr - first_base_addr;
    cslDebug((30, "XXXXXXX NV_NVDLA_mcif::rbk2mcif_rd_req_b_transport, first_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, total_axi_size, payload_addr, payload_size));

    cur_address = base_addr = first_base_addr;

    // Push the number of atoms of the request
    rbk2mcif_rd_req_atom_num_fifo_->write(payload_size/MIN_BUS_WIDTH);
    cslDebug((50, "NV_NVDLA_mcif::rbk2mcif_rd_req_b_transport, write 0x%x to rbk2mcif_rd_req_atom_num_fifo_, num_free:%d.\x0A", payload_size/MIN_BUS_WIDTH, rbk2mcif_rd_req_atom_num_fifo_->num_free()));

    //Split dma request to axi requests
    while(cur_address <= last_base_addr) {
        base_addr    = cur_address;
        cslDebug((50, "NV_NVDLA_mcif::rbk2mcif_rd_req_b_transport, prepare AXI transaction for address: 0x%lx\x0A", base_addr));
        // base_addr should be aligned to AXI_ALIGN_SIZE Byte
        // size_in_byte should be multiple of MEM_TRANSACTION_SIZE
        // if the data size required by dma mster is 32B, MCIF will drop the extra 32B when AXI returns
        size_in_byte = MEM_TRANSACTION_SIZE;
        while (((cur_address + MEM_TRANSACTION_SIZE) < (last_aligned_addr)) && ((cur_address + MEM_TRANSACTION_SIZE) % MCIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            size_in_byte += MEM_TRANSACTION_SIZE;
            cur_address  += MEM_TRANSACTION_SIZE;
        }
        cur_address += MEM_TRANSACTION_SIZE;
        cslDebug((50, "NV_NVDLA_mcif::rbk2mcif_rd_req_b_transport, cur_address=0x%lx base_addr=0x%lx size_in_byte=0x%x\x0A", cur_address, base_addr, size_in_byte));
    
        // Allocating memory for dla_b_transport_payload
        bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
        bt_payload->configure_gp(base_addr, size_in_byte, is_read);
        bt_payload->gp.get_extension(nvdla_dbb_ext);
        assert(nvdla_dbb_ext != NULL);
        axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
        // Setup byte enable in payload. Always read 64B from mcif and mcif, but drop unneeded 32B
        // Write true to *_rd_atom_enable_fifo_ when the 32B atom is needed by dma client
        // Write false to *_rd_atom_enable_fifo_ when the 32B atom is not needed by dma client (dma's addr is not aligned to 64B
        for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
            if ( ((base_addr + byte_iter >= payload_addr) && (base_addr + byte_iter < last_actual_addr)) ){
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
                if (0 == byte_iter%MIN_BUS_WIDTH) {
                    cslDebug((50, "NV_NVDLA_mcif::rbk2mcif_rd_req_b_transport, write true to rbk_rd_atom_enable_fifo_, num_free:%d\x0A", rbk_rd_atom_enable_fifo_->num_free()));
                    rbk_rd_atom_enable_fifo_->write(true);
                }
            } else {
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
                if (0 == byte_iter%MIN_BUS_WIDTH) {
                    cslDebug((50, "NV_NVDLA_mcif::rbk2mcif_rd_req_b_transport, write false to rbk_rd_atom_enable_fifo_, num_free:%d\x0A", rbk_rd_atom_enable_fifo_->num_free()));
                    rbk_rd_atom_enable_fifo_->write(false);
                }
            }
        }
        nvdla_dbb_ext->set_id(RBK_AXI_ID);
        nvdla_dbb_ext->set_size(MEM_TRANSACTION_SIZE);
        nvdla_dbb_ext->set_length(size_in_byte/MEM_TRANSACTION_SIZE);
        // avoid warinig for unused variable
#pragma CTC SKIP
        if(size_in_byte%MEM_TRANSACTION_SIZE!=0)
            FAIL(("NV_NVDLA_mcif::rbk2mcif_rd_req_b_transport, size_in_byte is not multiple of MEM_TRANSACTION_SIZE. size_in_byte=0x%x", size_in_byte));
#pragma CTC ENDSKIP
        cslDebug((50, "NV_NVDLA_mcif::rbk2mcif_rd_req_b_transport, before sending data to rbk_rd_req_fifo_ addr=0x%lx, , num_free:%d\x0A", base_addr, rbk_rd_req_fifo_->num_free()));
        rbk_rd_req_fifo_->write(bt_payload);
        cslDebug((50, "NV_NVDLA_mcif::rbk2mcif_rd_req_b_transport, after sending data to rbk_rd_req_fifo_ addr=0x%lx\x0A", base_addr));

    }
    cslDebug((50, "NV_NVDLA_mcif::rbk2mcif_rd_req_b_transport, after spliting DMA transaction\x0A"));
}

void NV_NVDLA_mcif::ReadResp_mcif2rbk() {
    uint8_t    *axi_atom_ptr;
    uint32_t    atom_num_left;
    nvdla_dma_rd_rsp_t* dma_rd_rsp_payload = NULL;
    uint8_t           * dma_payload_data_ptr;
    uint32_t    idx;
    int         dla_atom_num = 0;

    atom_num_left = 0;
    while(true) {
        if(0 == atom_num_left) {
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2rbk, num_available:%d\x0A", rbk2mcif_rd_req_atom_num_fifo_->num_available()));
            atom_num_left = rbk2mcif_rd_req_atom_num_fifo_->read();
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2rbk, update atom_num_left from rbk2mcif_rd_req_atom_num_fifo_, atom_num_left is 0x%x\x0A", atom_num_left));
        }
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2rbk, atom_num_left is 0x%x\x0A", atom_num_left));

        dma_rd_rsp_payload      = new nvdla_dma_rd_rsp_t;
        dma_payload_data_ptr    = reinterpret_cast <uint8_t *> (dma_rd_rsp_payload->pd.dma_read_data.data);
        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x00;

        for(int atom_iter = 0; atom_iter < TRANSACTION_DMA_ATOMIC_NUM && atom_num_left > 0; atom_iter++) {
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2rbk, num_available:%d\x0A", mcif2rbk_rd_rsp_fifo_->num_available()));
            axi_atom_ptr = mcif2rbk_rd_rsp_fifo_->read();
            credit_mcif2rbk_rd_rsp_fifo_ ++;
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2rbk, read 1st atom of the 64B from mcif2rbk_rd_rsp_fifo_\x0A"));
            atom_num_left--;
            dla_atom_num = atom_iter*MIN_BUS_WIDTH/DLA_ATOM_SIZE;

            dma_rd_rsp_payload->pd.dma_read_data.mask |= 0x1 << dla_atom_num;
            memcpy (&dma_payload_data_ptr[atom_iter*MIN_BUS_WIDTH], axi_atom_ptr, MIN_BUS_WIDTH);
            delete[] axi_atom_ptr;
        }

        cslDebug((70, "NV_NVDLA_mcif::ReadResp_mcif2rbk, dma_rd_rsp_payload->pd.dma_read_data.mask is 0x%x\x0A", uint32_t(dma_rd_rsp_payload->pd.dma_read_data.mask)));
        cslDebug((70, "NV_NVDLA_mcif::ReadResp_mcif2rbk, dma_rd_rsp_payload->pd.dma_read_data.data are :\x0A"));
        for (idx = 0; idx < sizeof(dma_rd_rsp_payload->pd.dma_read_data.data)/sizeof(dma_rd_rsp_payload->pd.dma_read_data.data[0]); idx++) {
            cslDebug((70, "    0x%lx\x0A", uint64_t (dma_rd_rsp_payload->pd.dma_read_data.data[idx])));   // The size of data[idx] is 8bytes and its type is "unsigned long"
        }
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2rbk, before NV_NVDLA_mcif_base::mcif2rbk_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        NV_NVDLA_mcif_base::mcif2rbk_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2rbk, after NV_NVDLA_mcif_base::mcif2rbk_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        delete dma_rd_rsp_payload;
    }
}

void NV_NVDLA_mcif::sdp_b2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    // DMA request size unit is DLA_ATOM_SIZE bytes
    uint64_t base_addr, cur_address;
    uint64_t first_base_addr;
    uint64_t last_base_addr, last_actual_addr, last_aligned_addr;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_read=true;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    dla_b_transport_payload *bt_payload;

    payload_addr = payload->pd.dma_read_cmd.addr;
    payload_size = (payload->pd.dma_read_cmd.size + 1) * DLA_ATOM_SIZE; //payload_size's max value is 2^13

    first_base_addr = (payload_addr/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE; 

    last_actual_addr = payload_addr + payload_size;
    last_aligned_addr= ((last_actual_addr + AXI_ALIGN_SIZE - 1)/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE;
    last_base_addr   = last_aligned_addr - MEM_TRANSACTION_SIZE;
    total_axi_size = last_aligned_addr - first_base_addr;
    cslDebug((30, "XXXXXXX NV_NVDLA_mcif::sdp_b2mcif_rd_req_b_transport, first_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, total_axi_size, payload_addr, payload_size));

    cur_address = base_addr = first_base_addr;

    // Push the number of atoms of the request
    sdp_b2mcif_rd_req_atom_num_fifo_->write(payload_size/MIN_BUS_WIDTH);
    cslDebug((50, "NV_NVDLA_mcif::sdp_b2mcif_rd_req_b_transport, write 0x%x to sdp_b2mcif_rd_req_atom_num_fifo_, num_free:%d.\x0A", payload_size/MIN_BUS_WIDTH, sdp_b2mcif_rd_req_atom_num_fifo_->num_free()));

    //Split dma request to axi requests
    while(cur_address <= last_base_addr) {
        base_addr    = cur_address;
        cslDebug((50, "NV_NVDLA_mcif::sdp_b2mcif_rd_req_b_transport, prepare AXI transaction for address: 0x%lx\x0A", base_addr));
        // base_addr should be aligned to AXI_ALIGN_SIZE Byte
        // size_in_byte should be multiple of MEM_TRANSACTION_SIZE
        // if the data size required by dma mster is 32B, MCIF will drop the extra 32B when AXI returns
        size_in_byte = MEM_TRANSACTION_SIZE;
        while (((cur_address + MEM_TRANSACTION_SIZE) < (last_aligned_addr)) && ((cur_address + MEM_TRANSACTION_SIZE) % MCIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            size_in_byte += MEM_TRANSACTION_SIZE;
            cur_address  += MEM_TRANSACTION_SIZE;
        }
        cur_address += MEM_TRANSACTION_SIZE;
        cslDebug((50, "NV_NVDLA_mcif::sdp_b2mcif_rd_req_b_transport, cur_address=0x%lx base_addr=0x%lx size_in_byte=0x%x\x0A", cur_address, base_addr, size_in_byte));
    
        // Allocating memory for dla_b_transport_payload
        bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
        bt_payload->configure_gp(base_addr, size_in_byte, is_read);
        bt_payload->gp.get_extension(nvdla_dbb_ext);
        assert(nvdla_dbb_ext != NULL);
        axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
        // Setup byte enable in payload. Always read 64B from mcif and mcif, but drop unneeded 32B
        // Write true to *_rd_atom_enable_fifo_ when the 32B atom is needed by dma client
        // Write false to *_rd_atom_enable_fifo_ when the 32B atom is not needed by dma client (dma's addr is not aligned to 64B
        for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
            if ( ((base_addr + byte_iter >= payload_addr) && (base_addr + byte_iter < last_actual_addr)) ){
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
                if (0 == byte_iter%MIN_BUS_WIDTH) {
                    cslDebug((50, "NV_NVDLA_mcif::sdp_b2mcif_rd_req_b_transport, write true to sdp_b_rd_atom_enable_fifo_, num_free:%d\x0A", sdp_b_rd_atom_enable_fifo_->num_free()));
                    sdp_b_rd_atom_enable_fifo_->write(true);
                }
            } else {
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
                if (0 == byte_iter%MIN_BUS_WIDTH) {
                    cslDebug((50, "NV_NVDLA_mcif::sdp_b2mcif_rd_req_b_transport, write false to sdp_b_rd_atom_enable_fifo_, num_free:%d\x0A", sdp_b_rd_atom_enable_fifo_->num_free()));
                    sdp_b_rd_atom_enable_fifo_->write(false);
                }
            }
        }
        nvdla_dbb_ext->set_id(SDP_B_AXI_ID);
        nvdla_dbb_ext->set_size(MEM_TRANSACTION_SIZE);
        nvdla_dbb_ext->set_length(size_in_byte/MEM_TRANSACTION_SIZE);
        // avoid warinig for unused variable
#pragma CTC SKIP
        if(size_in_byte%MEM_TRANSACTION_SIZE!=0)
            FAIL(("NV_NVDLA_mcif::sdp_b2mcif_rd_req_b_transport, size_in_byte is not multiple of MEM_TRANSACTION_SIZE. size_in_byte=0x%x", size_in_byte));
#pragma CTC ENDSKIP
        cslDebug((50, "NV_NVDLA_mcif::sdp_b2mcif_rd_req_b_transport, before sending data to sdp_b_rd_req_fifo_ addr=0x%lx, , num_free:%d\x0A", base_addr, sdp_b_rd_req_fifo_->num_free()));
        sdp_b_rd_req_fifo_->write(bt_payload);
        cslDebug((50, "NV_NVDLA_mcif::sdp_b2mcif_rd_req_b_transport, after sending data to sdp_b_rd_req_fifo_ addr=0x%lx\x0A", base_addr));

    }
    cslDebug((50, "NV_NVDLA_mcif::sdp_b2mcif_rd_req_b_transport, after spliting DMA transaction\x0A"));
}

void NV_NVDLA_mcif::ReadResp_mcif2sdp_b() {
    uint8_t    *axi_atom_ptr;
    uint32_t    atom_num_left;
    nvdla_dma_rd_rsp_t* dma_rd_rsp_payload = NULL;
    uint8_t           * dma_payload_data_ptr;
    uint32_t    idx;
    int         dla_atom_num = 0;

    atom_num_left = 0;
    while(true) {
        if(0 == atom_num_left) {
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_b, num_available:%d\x0A", sdp_b2mcif_rd_req_atom_num_fifo_->num_available()));
            atom_num_left = sdp_b2mcif_rd_req_atom_num_fifo_->read();
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_b, update atom_num_left from sdp_b2mcif_rd_req_atom_num_fifo_, atom_num_left is 0x%x\x0A", atom_num_left));
        }
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_b, atom_num_left is 0x%x\x0A", atom_num_left));

        dma_rd_rsp_payload      = new nvdla_dma_rd_rsp_t;
        dma_payload_data_ptr    = reinterpret_cast <uint8_t *> (dma_rd_rsp_payload->pd.dma_read_data.data);
        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x00;

        for(int atom_iter = 0; atom_iter < TRANSACTION_DMA_ATOMIC_NUM && atom_num_left > 0; atom_iter++) {
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_b, num_available:%d\x0A", mcif2sdp_b_rd_rsp_fifo_->num_available()));
            axi_atom_ptr = mcif2sdp_b_rd_rsp_fifo_->read();
            credit_mcif2sdp_b_rd_rsp_fifo_ ++;
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_b, read 1st atom of the 64B from mcif2sdp_b_rd_rsp_fifo_\x0A"));
            atom_num_left--;
            dla_atom_num = atom_iter*MIN_BUS_WIDTH/DLA_ATOM_SIZE;

            dma_rd_rsp_payload->pd.dma_read_data.mask |= 0x1 << dla_atom_num;
            memcpy (&dma_payload_data_ptr[atom_iter*MIN_BUS_WIDTH], axi_atom_ptr, MIN_BUS_WIDTH);
            delete[] axi_atom_ptr;
        }

        cslDebug((70, "NV_NVDLA_mcif::ReadResp_mcif2sdp_b, dma_rd_rsp_payload->pd.dma_read_data.mask is 0x%x\x0A", uint32_t(dma_rd_rsp_payload->pd.dma_read_data.mask)));
        cslDebug((70, "NV_NVDLA_mcif::ReadResp_mcif2sdp_b, dma_rd_rsp_payload->pd.dma_read_data.data are :\x0A"));
        for (idx = 0; idx < sizeof(dma_rd_rsp_payload->pd.dma_read_data.data)/sizeof(dma_rd_rsp_payload->pd.dma_read_data.data[0]); idx++) {
            cslDebug((70, "    0x%lx\x0A", uint64_t (dma_rd_rsp_payload->pd.dma_read_data.data[idx])));   // The size of data[idx] is 8bytes and its type is "unsigned long"
        }
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_b, before NV_NVDLA_mcif_base::mcif2sdp_b_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        NV_NVDLA_mcif_base::mcif2sdp_b_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_b, after NV_NVDLA_mcif_base::mcif2sdp_b_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        delete dma_rd_rsp_payload;
    }
}

void NV_NVDLA_mcif::sdp_n2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    // DMA request size unit is DLA_ATOM_SIZE bytes
    uint64_t base_addr, cur_address;
    uint64_t first_base_addr;
    uint64_t last_base_addr, last_actual_addr, last_aligned_addr;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_read=true;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    dla_b_transport_payload *bt_payload;

    payload_addr = payload->pd.dma_read_cmd.addr;
    payload_size = (payload->pd.dma_read_cmd.size + 1) * DLA_ATOM_SIZE; //payload_size's max value is 2^13

    first_base_addr = (payload_addr/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE; 

    last_actual_addr = payload_addr + payload_size;
    last_aligned_addr= ((last_actual_addr + AXI_ALIGN_SIZE - 1)/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE;
    last_base_addr   = last_aligned_addr - MEM_TRANSACTION_SIZE;
    total_axi_size = last_aligned_addr - first_base_addr;
    cslDebug((30, "XXXXXXX NV_NVDLA_mcif::sdp_n2mcif_rd_req_b_transport, first_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, total_axi_size, payload_addr, payload_size));

    cur_address = base_addr = first_base_addr;

    // Push the number of atoms of the request
    sdp_n2mcif_rd_req_atom_num_fifo_->write(payload_size/MIN_BUS_WIDTH);
    cslDebug((50, "NV_NVDLA_mcif::sdp_n2mcif_rd_req_b_transport, write 0x%x to sdp_n2mcif_rd_req_atom_num_fifo_, num_free:%d.\x0A", payload_size/MIN_BUS_WIDTH, sdp_n2mcif_rd_req_atom_num_fifo_->num_free()));

    //Split dma request to axi requests
    while(cur_address <= last_base_addr) {
        base_addr    = cur_address;
        cslDebug((50, "NV_NVDLA_mcif::sdp_n2mcif_rd_req_b_transport, prepare AXI transaction for address: 0x%lx\x0A", base_addr));
        // base_addr should be aligned to AXI_ALIGN_SIZE Byte
        // size_in_byte should be multiple of MEM_TRANSACTION_SIZE
        // if the data size required by dma mster is 32B, MCIF will drop the extra 32B when AXI returns
        size_in_byte = MEM_TRANSACTION_SIZE;
        while (((cur_address + MEM_TRANSACTION_SIZE) < (last_aligned_addr)) && ((cur_address + MEM_TRANSACTION_SIZE) % MCIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            size_in_byte += MEM_TRANSACTION_SIZE;
            cur_address  += MEM_TRANSACTION_SIZE;
        }
        cur_address += MEM_TRANSACTION_SIZE;
        cslDebug((50, "NV_NVDLA_mcif::sdp_n2mcif_rd_req_b_transport, cur_address=0x%lx base_addr=0x%lx size_in_byte=0x%x\x0A", cur_address, base_addr, size_in_byte));
    
        // Allocating memory for dla_b_transport_payload
        bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
        bt_payload->configure_gp(base_addr, size_in_byte, is_read);
        bt_payload->gp.get_extension(nvdla_dbb_ext);
        assert(nvdla_dbb_ext != NULL);
        axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
        // Setup byte enable in payload. Always read 64B from mcif and mcif, but drop unneeded 32B
        // Write true to *_rd_atom_enable_fifo_ when the 32B atom is needed by dma client
        // Write false to *_rd_atom_enable_fifo_ when the 32B atom is not needed by dma client (dma's addr is not aligned to 64B
        for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
            if ( ((base_addr + byte_iter >= payload_addr) && (base_addr + byte_iter < last_actual_addr)) ){
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
                if (0 == byte_iter%MIN_BUS_WIDTH) {
                    cslDebug((50, "NV_NVDLA_mcif::sdp_n2mcif_rd_req_b_transport, write true to sdp_n_rd_atom_enable_fifo_, num_free:%d\x0A", sdp_n_rd_atom_enable_fifo_->num_free()));
                    sdp_n_rd_atom_enable_fifo_->write(true);
                }
            } else {
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
                if (0 == byte_iter%MIN_BUS_WIDTH) {
                    cslDebug((50, "NV_NVDLA_mcif::sdp_n2mcif_rd_req_b_transport, write false to sdp_n_rd_atom_enable_fifo_, num_free:%d\x0A", sdp_n_rd_atom_enable_fifo_->num_free()));
                    sdp_n_rd_atom_enable_fifo_->write(false);
                }
            }
        }
        nvdla_dbb_ext->set_id(SDP_N_AXI_ID);
        nvdla_dbb_ext->set_size(MEM_TRANSACTION_SIZE);
        nvdla_dbb_ext->set_length(size_in_byte/MEM_TRANSACTION_SIZE);
        // avoid warinig for unused variable
#pragma CTC SKIP
        if(size_in_byte%MEM_TRANSACTION_SIZE!=0)
            FAIL(("NV_NVDLA_mcif::sdp_n2mcif_rd_req_b_transport, size_in_byte is not multiple of MEM_TRANSACTION_SIZE. size_in_byte=0x%x", size_in_byte));
#pragma CTC ENDSKIP
        cslDebug((50, "NV_NVDLA_mcif::sdp_n2mcif_rd_req_b_transport, before sending data to sdp_n_rd_req_fifo_ addr=0x%lx, , num_free:%d\x0A", base_addr, sdp_n_rd_req_fifo_->num_free()));
        sdp_n_rd_req_fifo_->write(bt_payload);
        cslDebug((50, "NV_NVDLA_mcif::sdp_n2mcif_rd_req_b_transport, after sending data to sdp_n_rd_req_fifo_ addr=0x%lx\x0A", base_addr));

    }
    cslDebug((50, "NV_NVDLA_mcif::sdp_n2mcif_rd_req_b_transport, after spliting DMA transaction\x0A"));
}

void NV_NVDLA_mcif::ReadResp_mcif2sdp_n() {
    uint8_t    *axi_atom_ptr;
    uint32_t    atom_num_left;
    nvdla_dma_rd_rsp_t* dma_rd_rsp_payload = NULL;
    uint8_t           * dma_payload_data_ptr;
    uint32_t    idx;
    int         dla_atom_num = 0;

    atom_num_left = 0;
    while(true) {
        if(0 == atom_num_left) {
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_n, num_available:%d\x0A", sdp_n2mcif_rd_req_atom_num_fifo_->num_available()));
            atom_num_left = sdp_n2mcif_rd_req_atom_num_fifo_->read();
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_n, update atom_num_left from sdp_n2mcif_rd_req_atom_num_fifo_, atom_num_left is 0x%x\x0A", atom_num_left));
        }
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_n, atom_num_left is 0x%x\x0A", atom_num_left));

        dma_rd_rsp_payload      = new nvdla_dma_rd_rsp_t;
        dma_payload_data_ptr    = reinterpret_cast <uint8_t *> (dma_rd_rsp_payload->pd.dma_read_data.data);
        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x00;

        for(int atom_iter = 0; atom_iter < TRANSACTION_DMA_ATOMIC_NUM && atom_num_left > 0; atom_iter++) {
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_n, num_available:%d\x0A", mcif2sdp_n_rd_rsp_fifo_->num_available()));
            axi_atom_ptr = mcif2sdp_n_rd_rsp_fifo_->read();
            credit_mcif2sdp_n_rd_rsp_fifo_ ++;
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_n, read 1st atom of the 64B from mcif2sdp_n_rd_rsp_fifo_\x0A"));
            atom_num_left--;
            dla_atom_num = atom_iter*MIN_BUS_WIDTH/DLA_ATOM_SIZE;

            dma_rd_rsp_payload->pd.dma_read_data.mask |= 0x1 << dla_atom_num;
            memcpy (&dma_payload_data_ptr[atom_iter*MIN_BUS_WIDTH], axi_atom_ptr, MIN_BUS_WIDTH);
            delete[] axi_atom_ptr;
        }

        cslDebug((70, "NV_NVDLA_mcif::ReadResp_mcif2sdp_n, dma_rd_rsp_payload->pd.dma_read_data.mask is 0x%x\x0A", uint32_t(dma_rd_rsp_payload->pd.dma_read_data.mask)));
        cslDebug((70, "NV_NVDLA_mcif::ReadResp_mcif2sdp_n, dma_rd_rsp_payload->pd.dma_read_data.data are :\x0A"));
        for (idx = 0; idx < sizeof(dma_rd_rsp_payload->pd.dma_read_data.data)/sizeof(dma_rd_rsp_payload->pd.dma_read_data.data[0]); idx++) {
            cslDebug((70, "    0x%lx\x0A", uint64_t (dma_rd_rsp_payload->pd.dma_read_data.data[idx])));   // The size of data[idx] is 8bytes and its type is "unsigned long"
        }
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_n, before NV_NVDLA_mcif_base::mcif2sdp_n_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        NV_NVDLA_mcif_base::mcif2sdp_n_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_n, after NV_NVDLA_mcif_base::mcif2sdp_n_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        delete dma_rd_rsp_payload;
    }
}

void NV_NVDLA_mcif::sdp_e2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    // DMA request size unit is DLA_ATOM_SIZE bytes
    uint64_t base_addr, cur_address;
    uint64_t first_base_addr;
    uint64_t last_base_addr, last_actual_addr, last_aligned_addr;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_read=true;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    dla_b_transport_payload *bt_payload;

    payload_addr = payload->pd.dma_read_cmd.addr;
    payload_size = (payload->pd.dma_read_cmd.size + 1) * DLA_ATOM_SIZE; //payload_size's max value is 2^13

    first_base_addr = (payload_addr/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE; 

    last_actual_addr = payload_addr + payload_size;
    last_aligned_addr= ((last_actual_addr + AXI_ALIGN_SIZE - 1)/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE;
    last_base_addr   = last_aligned_addr - MEM_TRANSACTION_SIZE;
    total_axi_size = last_aligned_addr - first_base_addr;
    cslDebug((30, "XXXXXXX NV_NVDLA_mcif::sdp_e2mcif_rd_req_b_transport, first_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, total_axi_size, payload_addr, payload_size));

    cur_address = base_addr = first_base_addr;

    // Push the number of atoms of the request
    sdp_e2mcif_rd_req_atom_num_fifo_->write(payload_size/MIN_BUS_WIDTH);
    cslDebug((50, "NV_NVDLA_mcif::sdp_e2mcif_rd_req_b_transport, write 0x%x to sdp_e2mcif_rd_req_atom_num_fifo_, num_free:%d.\x0A", payload_size/MIN_BUS_WIDTH, sdp_e2mcif_rd_req_atom_num_fifo_->num_free()));

    //Split dma request to axi requests
    while(cur_address <= last_base_addr) {
        base_addr    = cur_address;
        cslDebug((50, "NV_NVDLA_mcif::sdp_e2mcif_rd_req_b_transport, prepare AXI transaction for address: 0x%lx\x0A", base_addr));
        // base_addr should be aligned to AXI_ALIGN_SIZE Byte
        // size_in_byte should be multiple of MEM_TRANSACTION_SIZE
        // if the data size required by dma mster is 32B, MCIF will drop the extra 32B when AXI returns
        size_in_byte = MEM_TRANSACTION_SIZE;
        while (((cur_address + MEM_TRANSACTION_SIZE) < (last_aligned_addr)) && ((cur_address + MEM_TRANSACTION_SIZE) % MCIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            size_in_byte += MEM_TRANSACTION_SIZE;
            cur_address  += MEM_TRANSACTION_SIZE;
        }
        cur_address += MEM_TRANSACTION_SIZE;
        cslDebug((50, "NV_NVDLA_mcif::sdp_e2mcif_rd_req_b_transport, cur_address=0x%lx base_addr=0x%lx size_in_byte=0x%x\x0A", cur_address, base_addr, size_in_byte));
    
        // Allocating memory for dla_b_transport_payload
        bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
        bt_payload->configure_gp(base_addr, size_in_byte, is_read);
        bt_payload->gp.get_extension(nvdla_dbb_ext);
        assert(nvdla_dbb_ext != NULL);
        axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
        // Setup byte enable in payload. Always read 64B from mcif and mcif, but drop unneeded 32B
        // Write true to *_rd_atom_enable_fifo_ when the 32B atom is needed by dma client
        // Write false to *_rd_atom_enable_fifo_ when the 32B atom is not needed by dma client (dma's addr is not aligned to 64B
        for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
            if ( ((base_addr + byte_iter >= payload_addr) && (base_addr + byte_iter < last_actual_addr)) ){
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
                if (0 == byte_iter%MIN_BUS_WIDTH) {
                    cslDebug((50, "NV_NVDLA_mcif::sdp_e2mcif_rd_req_b_transport, write true to sdp_e_rd_atom_enable_fifo_, num_free:%d\x0A", sdp_e_rd_atom_enable_fifo_->num_free()));
                    sdp_e_rd_atom_enable_fifo_->write(true);
                }
            } else {
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
                if (0 == byte_iter%MIN_BUS_WIDTH) {
                    cslDebug((50, "NV_NVDLA_mcif::sdp_e2mcif_rd_req_b_transport, write false to sdp_e_rd_atom_enable_fifo_, num_free:%d\x0A", sdp_e_rd_atom_enable_fifo_->num_free()));
                    sdp_e_rd_atom_enable_fifo_->write(false);
                }
            }
        }
        nvdla_dbb_ext->set_id(SDP_E_AXI_ID);
        nvdla_dbb_ext->set_size(MEM_TRANSACTION_SIZE);
        nvdla_dbb_ext->set_length(size_in_byte/MEM_TRANSACTION_SIZE);
        // avoid warinig for unused variable
#pragma CTC SKIP
        if(size_in_byte%MEM_TRANSACTION_SIZE!=0)
            FAIL(("NV_NVDLA_mcif::sdp_e2mcif_rd_req_b_transport, size_in_byte is not multiple of MEM_TRANSACTION_SIZE. size_in_byte=0x%x", size_in_byte));
#pragma CTC ENDSKIP
        cslDebug((50, "NV_NVDLA_mcif::sdp_e2mcif_rd_req_b_transport, before sending data to sdp_e_rd_req_fifo_ addr=0x%lx, , num_free:%d\x0A", base_addr, sdp_e_rd_req_fifo_->num_free()));
        sdp_e_rd_req_fifo_->write(bt_payload);
        cslDebug((50, "NV_NVDLA_mcif::sdp_e2mcif_rd_req_b_transport, after sending data to sdp_e_rd_req_fifo_ addr=0x%lx\x0A", base_addr));

    }
    cslDebug((50, "NV_NVDLA_mcif::sdp_e2mcif_rd_req_b_transport, after spliting DMA transaction\x0A"));
}

void NV_NVDLA_mcif::ReadResp_mcif2sdp_e() {
    uint8_t    *axi_atom_ptr;
    uint32_t    atom_num_left;
    nvdla_dma_rd_rsp_t* dma_rd_rsp_payload = NULL;
    uint8_t           * dma_payload_data_ptr;
    uint32_t    idx;
    int         dla_atom_num = 0;

    atom_num_left = 0;
    while(true) {
        if(0 == atom_num_left) {
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_e, num_available:%d\x0A", sdp_e2mcif_rd_req_atom_num_fifo_->num_available()));
            atom_num_left = sdp_e2mcif_rd_req_atom_num_fifo_->read();
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_e, update atom_num_left from sdp_e2mcif_rd_req_atom_num_fifo_, atom_num_left is 0x%x\x0A", atom_num_left));
        }
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_e, atom_num_left is 0x%x\x0A", atom_num_left));

        dma_rd_rsp_payload      = new nvdla_dma_rd_rsp_t;
        dma_payload_data_ptr    = reinterpret_cast <uint8_t *> (dma_rd_rsp_payload->pd.dma_read_data.data);
        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x00;

        for(int atom_iter = 0; atom_iter < TRANSACTION_DMA_ATOMIC_NUM && atom_num_left > 0; atom_iter++) {
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_e, num_available:%d\x0A", mcif2sdp_e_rd_rsp_fifo_->num_available()));
            axi_atom_ptr = mcif2sdp_e_rd_rsp_fifo_->read();
            credit_mcif2sdp_e_rd_rsp_fifo_ ++;
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_e, read 1st atom of the 64B from mcif2sdp_e_rd_rsp_fifo_\x0A"));
            atom_num_left--;
            dla_atom_num = atom_iter*MIN_BUS_WIDTH/DLA_ATOM_SIZE;

            dma_rd_rsp_payload->pd.dma_read_data.mask |= 0x1 << dla_atom_num;
            memcpy (&dma_payload_data_ptr[atom_iter*MIN_BUS_WIDTH], axi_atom_ptr, MIN_BUS_WIDTH);
            delete[] axi_atom_ptr;
        }

        cslDebug((70, "NV_NVDLA_mcif::ReadResp_mcif2sdp_e, dma_rd_rsp_payload->pd.dma_read_data.mask is 0x%x\x0A", uint32_t(dma_rd_rsp_payload->pd.dma_read_data.mask)));
        cslDebug((70, "NV_NVDLA_mcif::ReadResp_mcif2sdp_e, dma_rd_rsp_payload->pd.dma_read_data.data are :\x0A"));
        for (idx = 0; idx < sizeof(dma_rd_rsp_payload->pd.dma_read_data.data)/sizeof(dma_rd_rsp_payload->pd.dma_read_data.data[0]); idx++) {
            cslDebug((70, "    0x%lx\x0A", uint64_t (dma_rd_rsp_payload->pd.dma_read_data.data[idx])));   // The size of data[idx] is 8bytes and its type is "unsigned long"
        }
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_e, before NV_NVDLA_mcif_base::mcif2sdp_e_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        NV_NVDLA_mcif_base::mcif2sdp_e_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2sdp_e, after NV_NVDLA_mcif_base::mcif2sdp_e_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        delete dma_rd_rsp_payload;
    }
}

void NV_NVDLA_mcif::cdma_dat2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    // DMA request size unit is DLA_ATOM_SIZE bytes
    uint64_t base_addr, cur_address;
    uint64_t first_base_addr;
    uint64_t last_base_addr, last_actual_addr, last_aligned_addr;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_read=true;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    dla_b_transport_payload *bt_payload;

    payload_addr = payload->pd.dma_read_cmd.addr;
    payload_size = (payload->pd.dma_read_cmd.size + 1) * DLA_ATOM_SIZE; //payload_size's max value is 2^13

    first_base_addr = (payload_addr/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE; 

    last_actual_addr = payload_addr + payload_size;
    last_aligned_addr= ((last_actual_addr + AXI_ALIGN_SIZE - 1)/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE;
    last_base_addr   = last_aligned_addr - MEM_TRANSACTION_SIZE;
    total_axi_size = last_aligned_addr - first_base_addr;
    cslDebug((30, "XXXXXXX NV_NVDLA_mcif::cdma_dat2mcif_rd_req_b_transport, first_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, total_axi_size, payload_addr, payload_size));

    cur_address = base_addr = first_base_addr;

    // Push the number of atoms of the request
    cdma_dat2mcif_rd_req_atom_num_fifo_->write(payload_size/MIN_BUS_WIDTH);
    cslDebug((50, "NV_NVDLA_mcif::cdma_dat2mcif_rd_req_b_transport, write 0x%x to cdma_dat2mcif_rd_req_atom_num_fifo_, num_free:%d.\x0A", payload_size/MIN_BUS_WIDTH, cdma_dat2mcif_rd_req_atom_num_fifo_->num_free()));

    //Split dma request to axi requests
    while(cur_address <= last_base_addr) {
        base_addr    = cur_address;
        cslDebug((50, "NV_NVDLA_mcif::cdma_dat2mcif_rd_req_b_transport, prepare AXI transaction for address: 0x%lx\x0A", base_addr));
        // base_addr should be aligned to AXI_ALIGN_SIZE Byte
        // size_in_byte should be multiple of MEM_TRANSACTION_SIZE
        // if the data size required by dma mster is 32B, MCIF will drop the extra 32B when AXI returns
        size_in_byte = MEM_TRANSACTION_SIZE;
        while (((cur_address + MEM_TRANSACTION_SIZE) < (last_aligned_addr)) && ((cur_address + MEM_TRANSACTION_SIZE) % MCIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            size_in_byte += MEM_TRANSACTION_SIZE;
            cur_address  += MEM_TRANSACTION_SIZE;
        }
        cur_address += MEM_TRANSACTION_SIZE;
        cslDebug((50, "NV_NVDLA_mcif::cdma_dat2mcif_rd_req_b_transport, cur_address=0x%lx base_addr=0x%lx size_in_byte=0x%x\x0A", cur_address, base_addr, size_in_byte));
    
        // Allocating memory for dla_b_transport_payload
        bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
        bt_payload->configure_gp(base_addr, size_in_byte, is_read);
        bt_payload->gp.get_extension(nvdla_dbb_ext);
        assert(nvdla_dbb_ext != NULL);
        axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
        // Setup byte enable in payload. Always read 64B from mcif and mcif, but drop unneeded 32B
        // Write true to *_rd_atom_enable_fifo_ when the 32B atom is needed by dma client
        // Write false to *_rd_atom_enable_fifo_ when the 32B atom is not needed by dma client (dma's addr is not aligned to 64B
        for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
            if ( ((base_addr + byte_iter >= payload_addr) && (base_addr + byte_iter < last_actual_addr)) ){
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
                if (0 == byte_iter%MIN_BUS_WIDTH) {
                    cslDebug((50, "NV_NVDLA_mcif::cdma_dat2mcif_rd_req_b_transport, write true to cdma_dat_rd_atom_enable_fifo_, num_free:%d\x0A", cdma_dat_rd_atom_enable_fifo_->num_free()));
                    cdma_dat_rd_atom_enable_fifo_->write(true);
                }
            } else {
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
                if (0 == byte_iter%MIN_BUS_WIDTH) {
                    cslDebug((50, "NV_NVDLA_mcif::cdma_dat2mcif_rd_req_b_transport, write false to cdma_dat_rd_atom_enable_fifo_, num_free:%d\x0A", cdma_dat_rd_atom_enable_fifo_->num_free()));
                    cdma_dat_rd_atom_enable_fifo_->write(false);
                }
            }
        }
        nvdla_dbb_ext->set_id(CDMA_DAT_AXI_ID);
        nvdla_dbb_ext->set_size(MEM_TRANSACTION_SIZE);
        nvdla_dbb_ext->set_length(size_in_byte/MEM_TRANSACTION_SIZE);
        // avoid warinig for unused variable
#pragma CTC SKIP
        if(size_in_byte%MEM_TRANSACTION_SIZE!=0)
            FAIL(("NV_NVDLA_mcif::cdma_dat2mcif_rd_req_b_transport, size_in_byte is not multiple of MEM_TRANSACTION_SIZE. size_in_byte=0x%x", size_in_byte));
#pragma CTC ENDSKIP
        cslDebug((50, "NV_NVDLA_mcif::cdma_dat2mcif_rd_req_b_transport, before sending data to cdma_dat_rd_req_fifo_ addr=0x%lx, , num_free:%d\x0A", base_addr, cdma_dat_rd_req_fifo_->num_free()));
        cdma_dat_rd_req_fifo_->write(bt_payload);
        cslDebug((50, "NV_NVDLA_mcif::cdma_dat2mcif_rd_req_b_transport, after sending data to cdma_dat_rd_req_fifo_ addr=0x%lx\x0A", base_addr));

    }
    cslDebug((50, "NV_NVDLA_mcif::cdma_dat2mcif_rd_req_b_transport, after spliting DMA transaction\x0A"));
}

void NV_NVDLA_mcif::ReadResp_mcif2cdma_dat() {
    uint8_t    *axi_atom_ptr;
    uint32_t    atom_num_left;
    nvdla_dma_rd_rsp_t* dma_rd_rsp_payload = NULL;
    uint8_t           * dma_payload_data_ptr;
    uint32_t    idx;
    int         dla_atom_num = 0;

    atom_num_left = 0;
    while(true) {
        if(0 == atom_num_left) {
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdma_dat, num_available:%d\x0A", cdma_dat2mcif_rd_req_atom_num_fifo_->num_available()));
            atom_num_left = cdma_dat2mcif_rd_req_atom_num_fifo_->read();
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdma_dat, update atom_num_left from cdma_dat2mcif_rd_req_atom_num_fifo_, atom_num_left is 0x%x\x0A", atom_num_left));
        }
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdma_dat, atom_num_left is 0x%x\x0A", atom_num_left));

        dma_rd_rsp_payload      = new nvdla_dma_rd_rsp_t;
        dma_payload_data_ptr    = reinterpret_cast <uint8_t *> (dma_rd_rsp_payload->pd.dma_read_data.data);
        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x00;

        for(int atom_iter = 0; atom_iter < TRANSACTION_DMA_ATOMIC_NUM && atom_num_left > 0; atom_iter++) {
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdma_dat, num_available:%d\x0A", mcif2cdma_dat_rd_rsp_fifo_->num_available()));
            axi_atom_ptr = mcif2cdma_dat_rd_rsp_fifo_->read();
            credit_mcif2cdma_dat_rd_rsp_fifo_ ++;
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdma_dat, read 1st atom of the 64B from mcif2cdma_dat_rd_rsp_fifo_\x0A"));
            atom_num_left--;
            dla_atom_num = atom_iter*MIN_BUS_WIDTH/DLA_ATOM_SIZE;

            dma_rd_rsp_payload->pd.dma_read_data.mask |= 0x1 << dla_atom_num;
            memcpy (&dma_payload_data_ptr[atom_iter*MIN_BUS_WIDTH], axi_atom_ptr, MIN_BUS_WIDTH);
            delete[] axi_atom_ptr;
        }

        cslDebug((70, "NV_NVDLA_mcif::ReadResp_mcif2cdma_dat, dma_rd_rsp_payload->pd.dma_read_data.mask is 0x%x\x0A", uint32_t(dma_rd_rsp_payload->pd.dma_read_data.mask)));
        cslDebug((70, "NV_NVDLA_mcif::ReadResp_mcif2cdma_dat, dma_rd_rsp_payload->pd.dma_read_data.data are :\x0A"));
        for (idx = 0; idx < sizeof(dma_rd_rsp_payload->pd.dma_read_data.data)/sizeof(dma_rd_rsp_payload->pd.dma_read_data.data[0]); idx++) {
            cslDebug((70, "    0x%lx\x0A", uint64_t (dma_rd_rsp_payload->pd.dma_read_data.data[idx])));   // The size of data[idx] is 8bytes and its type is "unsigned long"
        }
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdma_dat, before NV_NVDLA_mcif_base::mcif2cdma_dat_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        NV_NVDLA_mcif_base::mcif2cdma_dat_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdma_dat, after NV_NVDLA_mcif_base::mcif2cdma_dat_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        delete dma_rd_rsp_payload;
    }
}

void NV_NVDLA_mcif::cdma_wt2mcif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    // DMA request size unit is DLA_ATOM_SIZE bytes
    uint64_t base_addr, cur_address;
    uint64_t first_base_addr;
    uint64_t last_base_addr, last_actual_addr, last_aligned_addr;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_read=true;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    dla_b_transport_payload *bt_payload;

    payload_addr = payload->pd.dma_read_cmd.addr;
    payload_size = (payload->pd.dma_read_cmd.size + 1) * DLA_ATOM_SIZE; //payload_size's max value is 2^13

    first_base_addr = (payload_addr/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE; 

    last_actual_addr = payload_addr + payload_size;
    last_aligned_addr= ((last_actual_addr + AXI_ALIGN_SIZE - 1)/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE;
    last_base_addr   = last_aligned_addr - MEM_TRANSACTION_SIZE;
    total_axi_size = last_aligned_addr - first_base_addr;
    cslDebug((30, "XXXXXXX NV_NVDLA_mcif::cdma_wt2mcif_rd_req_b_transport, first_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, total_axi_size, payload_addr, payload_size));

    cur_address = base_addr = first_base_addr;

    // Push the number of atoms of the request
    cdma_wt2mcif_rd_req_atom_num_fifo_->write(payload_size/MIN_BUS_WIDTH);
    cslDebug((50, "NV_NVDLA_mcif::cdma_wt2mcif_rd_req_b_transport, write 0x%x to cdma_wt2mcif_rd_req_atom_num_fifo_, num_free:%d.\x0A", payload_size/MIN_BUS_WIDTH, cdma_wt2mcif_rd_req_atom_num_fifo_->num_free()));

    //Split dma request to axi requests
    while(cur_address <= last_base_addr) {
        base_addr    = cur_address;
        cslDebug((50, "NV_NVDLA_mcif::cdma_wt2mcif_rd_req_b_transport, prepare AXI transaction for address: 0x%lx\x0A", base_addr));
        // base_addr should be aligned to AXI_ALIGN_SIZE Byte
        // size_in_byte should be multiple of MEM_TRANSACTION_SIZE
        // if the data size required by dma mster is 32B, MCIF will drop the extra 32B when AXI returns
        size_in_byte = MEM_TRANSACTION_SIZE;
        while (((cur_address + MEM_TRANSACTION_SIZE) < (last_aligned_addr)) && ((cur_address + MEM_TRANSACTION_SIZE) % MCIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            size_in_byte += MEM_TRANSACTION_SIZE;
            cur_address  += MEM_TRANSACTION_SIZE;
        }
        cur_address += MEM_TRANSACTION_SIZE;
        cslDebug((50, "NV_NVDLA_mcif::cdma_wt2mcif_rd_req_b_transport, cur_address=0x%lx base_addr=0x%lx size_in_byte=0x%x\x0A", cur_address, base_addr, size_in_byte));
    
        // Allocating memory for dla_b_transport_payload
        bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
        bt_payload->configure_gp(base_addr, size_in_byte, is_read);
        bt_payload->gp.get_extension(nvdla_dbb_ext);
        assert(nvdla_dbb_ext != NULL);
        axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
        // Setup byte enable in payload. Always read 64B from mcif and mcif, but drop unneeded 32B
        // Write true to *_rd_atom_enable_fifo_ when the 32B atom is needed by dma client
        // Write false to *_rd_atom_enable_fifo_ when the 32B atom is not needed by dma client (dma's addr is not aligned to 64B
        for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
            if ( ((base_addr + byte_iter >= payload_addr) && (base_addr + byte_iter < last_actual_addr)) ){
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
                if (0 == byte_iter%MIN_BUS_WIDTH) {
                    cslDebug((50, "NV_NVDLA_mcif::cdma_wt2mcif_rd_req_b_transport, write true to cdma_wt_rd_atom_enable_fifo_, num_free:%d\x0A", cdma_wt_rd_atom_enable_fifo_->num_free()));
                    cdma_wt_rd_atom_enable_fifo_->write(true);
                }
            } else {
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
                if (0 == byte_iter%MIN_BUS_WIDTH) {
                    cslDebug((50, "NV_NVDLA_mcif::cdma_wt2mcif_rd_req_b_transport, write false to cdma_wt_rd_atom_enable_fifo_, num_free:%d\x0A", cdma_wt_rd_atom_enable_fifo_->num_free()));
                    cdma_wt_rd_atom_enable_fifo_->write(false);
                }
            }
        }
        nvdla_dbb_ext->set_id(CDMA_WT_AXI_ID);
        nvdla_dbb_ext->set_size(MEM_TRANSACTION_SIZE);
        nvdla_dbb_ext->set_length(size_in_byte/MEM_TRANSACTION_SIZE);
        // avoid warinig for unused variable
#pragma CTC SKIP
        if(size_in_byte%MEM_TRANSACTION_SIZE!=0)
            FAIL(("NV_NVDLA_mcif::cdma_wt2mcif_rd_req_b_transport, size_in_byte is not multiple of MEM_TRANSACTION_SIZE. size_in_byte=0x%x", size_in_byte));
#pragma CTC ENDSKIP
        cslDebug((50, "NV_NVDLA_mcif::cdma_wt2mcif_rd_req_b_transport, before sending data to cdma_wt_rd_req_fifo_ addr=0x%lx, , num_free:%d\x0A", base_addr, cdma_wt_rd_req_fifo_->num_free()));
        cdma_wt_rd_req_fifo_->write(bt_payload);
        cslDebug((50, "NV_NVDLA_mcif::cdma_wt2mcif_rd_req_b_transport, after sending data to cdma_wt_rd_req_fifo_ addr=0x%lx\x0A", base_addr));

    }
    cslDebug((50, "NV_NVDLA_mcif::cdma_wt2mcif_rd_req_b_transport, after spliting DMA transaction\x0A"));
}

void NV_NVDLA_mcif::ReadResp_mcif2cdma_wt() {
    uint8_t    *axi_atom_ptr;
    uint32_t    atom_num_left;
    nvdla_dma_rd_rsp_t* dma_rd_rsp_payload = NULL;
    uint8_t           * dma_payload_data_ptr;
    uint32_t    idx;
    int         dla_atom_num = 0;

    atom_num_left = 0;
    while(true) {
        if(0 == atom_num_left) {
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdma_wt, num_available:%d\x0A", cdma_wt2mcif_rd_req_atom_num_fifo_->num_available()));
            atom_num_left = cdma_wt2mcif_rd_req_atom_num_fifo_->read();
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdma_wt, update atom_num_left from cdma_wt2mcif_rd_req_atom_num_fifo_, atom_num_left is 0x%x\x0A", atom_num_left));
        }
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdma_wt, atom_num_left is 0x%x\x0A", atom_num_left));

        dma_rd_rsp_payload      = new nvdla_dma_rd_rsp_t;
        dma_payload_data_ptr    = reinterpret_cast <uint8_t *> (dma_rd_rsp_payload->pd.dma_read_data.data);
        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x00;

        for(int atom_iter = 0; atom_iter < TRANSACTION_DMA_ATOMIC_NUM && atom_num_left > 0; atom_iter++) {
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdma_wt, num_available:%d\x0A", mcif2cdma_wt_rd_rsp_fifo_->num_available()));
            axi_atom_ptr = mcif2cdma_wt_rd_rsp_fifo_->read();
            credit_mcif2cdma_wt_rd_rsp_fifo_ ++;
            cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdma_wt, read 1st atom of the 64B from mcif2cdma_wt_rd_rsp_fifo_\x0A"));
            atom_num_left--;
            dla_atom_num = atom_iter*MIN_BUS_WIDTH/DLA_ATOM_SIZE;

            dma_rd_rsp_payload->pd.dma_read_data.mask |= 0x1 << dla_atom_num;
            memcpy (&dma_payload_data_ptr[atom_iter*MIN_BUS_WIDTH], axi_atom_ptr, MIN_BUS_WIDTH);
            delete[] axi_atom_ptr;
        }

        cslDebug((70, "NV_NVDLA_mcif::ReadResp_mcif2cdma_wt, dma_rd_rsp_payload->pd.dma_read_data.mask is 0x%x\x0A", uint32_t(dma_rd_rsp_payload->pd.dma_read_data.mask)));
        cslDebug((70, "NV_NVDLA_mcif::ReadResp_mcif2cdma_wt, dma_rd_rsp_payload->pd.dma_read_data.data are :\x0A"));
        for (idx = 0; idx < sizeof(dma_rd_rsp_payload->pd.dma_read_data.data)/sizeof(dma_rd_rsp_payload->pd.dma_read_data.data[0]); idx++) {
            cslDebug((70, "    0x%lx\x0A", uint64_t (dma_rd_rsp_payload->pd.dma_read_data.data[idx])));   // The size of data[idx] is 8bytes and its type is "unsigned long"
        }
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdma_wt, before NV_NVDLA_mcif_base::mcif2cdma_wt_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        NV_NVDLA_mcif_base::mcif2cdma_wt_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_mcif::ReadResp_mcif2cdma_wt, after NV_NVDLA_mcif_base::mcif2cdma_wt_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        delete dma_rd_rsp_payload;
    }
}

// DMA read request target sockets

void NV_NVDLA_mcif::bdma2mcif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) {
    uint32_t packet_id;
    uint8_t  *dma_payload_data_ptr;
    uint8_t  *data_ptr;
    uint32_t rest_size, incoming_size;
    client_wr_req_t * bdma_wr_req;

    packet_id = payload->tag;
    if (TAG_CMD == packet_id) {
        bdma_wr_req_count_ ++;
#pragma CTC SKIP
        if (true == has_bdma_onging_wr_req_) {
            FAIL(("NV_NVDLA_mcif::bdma2mcif_wr_req_b_transport, got two consective command request, one command request shall be followed by one or more data request."));
        }
#pragma CTC ENDSKIP
	    else {
            has_bdma_onging_wr_req_ = true;
        }

        bdma_wr_req = new client_wr_req_t;
        bdma_wr_req->addr  = payload->pd.dma_write_cmd.addr;
        bdma_wr_req->size  = (payload->pd.dma_write_cmd.size + 1) * DLA_ATOM_SIZE;    //In byte
        bdma_wr_req->require_ack = payload->pd.dma_write_cmd.require_ack;
        cslDebug((50, "write to bdma2mcif_wr_cmd_fifo_, addr:%lx, size:%d, num_free:%d, req_ack:%d\x0A", bdma_wr_req->addr, bdma_wr_req->size, bdma2mcif_wr_cmd_fifo_->num_free(),bdma_wr_req->require_ack));
        bdma2mcif_wr_cmd_fifo_->write(bdma_wr_req);
        bdma_wr_req_got_size_ = 0;
        bdma_wr_req_size_ = bdma_wr_req->size;

    } else {
        dma_payload_data_ptr = reinterpret_cast <uint8_t *> (payload->pd.dma_write_data.data);
        rest_size = bdma_wr_req_size_ - bdma_wr_req_got_size_;
        incoming_size = min(rest_size, uint32_t (DMAIF_WIDTH));
        for(int atom_iter = 0; atom_iter < incoming_size/MIN_BUS_WIDTH; atom_iter++) {
            data_ptr = new uint8_t[MIN_BUS_WIDTH];
            memcpy(data_ptr, dma_payload_data_ptr + MIN_BUS_WIDTH*atom_iter, MIN_BUS_WIDTH);
            cslDebug((50, "write to bdma2mcif_wr_data_fifo_, num_free:%d\x0A", bdma2mcif_wr_data_fifo_->num_free()));
            cslDebug((50, "bdma2mcif_wr_data_fifo_ data:\x0A"));
            for(int i = 0; i < MIN_BUS_WIDTH; i++) {
                cslDebug((50, "%x ", data_ptr[i]));
            }
            cslDebug((50, "\x0A"));

            bdma2mcif_wr_data_fifo_->write(data_ptr);   // Write to FIFO in 32Byte atom
        }
        bdma_wr_req_got_size_ += incoming_size;
       
        if (bdma_wr_req_got_size_ == bdma_wr_req_size_) {
            cslDebug((50, "one write request done on bdma\x0A"));
            has_bdma_onging_wr_req_ = false;
        }
    }
}

void NV_NVDLA_mcif::WriteRequest_bdma2mcif() {
    uint64_t base_addr, cur_address;
    uint64_t first_base_addr;
    uint64_t last_base_addr, last_actual_addr, last_aligned_addr;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_base_aligned;
    bool     is_rear_aligned;
    bool     is_read=false;
    uint8_t  *axi_atom_ptr;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    client_wr_req_t   * bdma_wr_req;
    dla_b_transport_payload *bt_payload;
    int      atom_num;

    while(true) {
        // Read one write command
        bdma_wr_req = bdma2mcif_wr_cmd_fifo_->read();
        payload_addr = bdma_wr_req->addr;   // It's aligend to 32B, not 64B
        payload_size = bdma_wr_req->size;

        is_base_aligned      = (payload_addr%AXI_ALIGN_SIZE) == 0;
        first_base_addr     = (payload_addr/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE;
        last_actual_addr    = payload_addr + payload_size;
        last_aligned_addr   = ((last_actual_addr + AXI_ALIGN_SIZE -1)/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE;
        last_base_addr      = last_aligned_addr - MEM_TRANSACTION_SIZE;
        is_rear_aligned     = ((payload_addr + payload_size) % AXI_ALIGN_SIZE) == 0;
        total_axi_size      = last_aligned_addr - first_base_addr;
        cslDebug((30, "XXXXXXX NV_NVDLA_mcif::WriteRequest_bdma2mcif, first_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, total_axi_size, payload_addr, payload_size));

        cur_address = base_addr = first_base_addr;
        while (cur_address <= last_base_addr) {
            base_addr = cur_address;
            size_in_byte = MEM_TRANSACTION_SIZE;

            // Check whether next ATOM belongs to current AXI transaction
            while (((cur_address + MEM_TRANSACTION_SIZE) < last_aligned_addr) && ((cur_address + MEM_TRANSACTION_SIZE) % MCIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
                size_in_byte += MEM_TRANSACTION_SIZE;
                cur_address  += MEM_TRANSACTION_SIZE;
            }
            // start address of next axi transaction
            cur_address += MEM_TRANSACTION_SIZE;

            atom_num = size_in_byte / MIN_BUS_WIDTH;
            bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
            axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
            for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
                if ( base_addr + byte_iter < payload_addr) {
                    // Diable 1st DMA atom of the unaligned first_base_addr
                    assert(is_base_aligned == false);
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                } else if (base_addr + byte_iter >= last_actual_addr) {
                    // Diable last unaligned last_base_addr
                    assert(is_rear_aligned == false);
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                } else {
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;  // All bytes should be enabled
                }
            }
            cslDebug((50, "NV_NVDLA_mcif::WriteRequest_bdma2mcif, TLM_BYTE_ENABLE is done\x0A"));

            for (int atom_iter=0; atom_iter < atom_num; atom_iter++) {
                if ( axi_byte_enable_ptr[atom_iter*MIN_BUS_WIDTH] == TLM_BYTE_DISABLED) {
                    // Disable 1st DMA atom of the unaligned first_base_addr
                    // Use unaligned address as required by DBB_PV
                    for(int elt_iter = 0; elt_iter < MIN_BUS_WIDTH; elt_iter++) {
                        bt_payload->data[atom_iter*MIN_BUS_WIDTH + elt_iter] = 0;
                    }
                } else {
                    cslDebug((50, "NV_NVDLA_mcif::WriteRequest_bdma2mcif, before read an atom from bdma2mcif_wr_data_fifo_, base_addr = 0x%lx, atom_iter=0x%x\x0A", base_addr, atom_iter));

                    axi_atom_ptr = bdma2mcif_wr_data_fifo_->read();
                    cslDebug((50, "NV_NVDLA_mcif::WriteRequest_bdma2mcif, after read an atom from bdma2mcif_wr_data_fifo_\x0A"));
                    for(int i=0; i<MIN_BUS_WIDTH; i++) {
                        cslDebug((50, "%02x ", axi_atom_ptr[i]));
                    }
                    cslDebug((50, "\x0A"));
                    for(int elt_iter = 0; elt_iter < MIN_BUS_WIDTH; elt_iter++) {
                        bt_payload->data[atom_iter*MIN_BUS_WIDTH + elt_iter] = axi_atom_ptr[elt_iter];
                    }
                    delete[] axi_atom_ptr;
                }
            }


            if ( (cur_address >= last_actual_addr) && (bdma_wr_req->require_ack != 0) ) {
                cslDebug((30, "NV_NVDLA_mcif::WriteRequest_bdma2mcif, required ack.\x0A"));
                bdma_wr_required_ack_fifo_->write(true);
            }
            else {
                cslDebug((30, "NV_NVDLA_mcif::WriteRequest_bdma2mcif, did not require ack.\x0A"));
                bdma_wr_required_ack_fifo_->write(false);
            }

            // Prepare write payload
            bt_payload->configure_gp(base_addr, size_in_byte, is_read);
            bt_payload->gp.get_extension(nvdla_dbb_ext);
            cslDebug((50, "NV_NVDLA_mcif::WriteRequest_bdma2mcif, sending write command to bdma_wr_req_fifo_.\x0A"));
            cslDebug((50, "    addr: 0x%lx\x0A", base_addr));
            cslDebug((50, "    size: %d\x0A", size_in_byte));
            nvdla_dbb_ext->set_id(BDMA_AXI_ID);
            nvdla_dbb_ext->set_size(MEM_TRANSACTION_SIZE);
            nvdla_dbb_ext->set_length(size_in_byte/MEM_TRANSACTION_SIZE);

#pragma CTC SKIP
            if(size_in_byte%AXI_ALIGN_SIZE!=0)
                FAIL(("NV_NVDLA_mcif::bdma2mcif_rd_req_b_transport, size_in_byte is not multiple of AXI_ALIGN_SIZE. size_in_byte=0x%x", size_in_byte));
#pragma CTC ENDSKIP

            // write payload to arbiter fifo
            bdma_wr_req_fifo_->write(bt_payload);
        }
        delete bdma_wr_req;
    }
}

void NV_NVDLA_mcif::sdp2mcif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) {
    uint32_t packet_id;
    uint8_t  *dma_payload_data_ptr;
    uint8_t  *data_ptr;
    uint32_t rest_size, incoming_size;
    client_wr_req_t * sdp_wr_req;

    packet_id = payload->tag;
    if (TAG_CMD == packet_id) {
        sdp_wr_req_count_ ++;
#pragma CTC SKIP
        if (true == has_sdp_onging_wr_req_) {
            FAIL(("NV_NVDLA_mcif::sdp2mcif_wr_req_b_transport, got two consective command request, one command request shall be followed by one or more data request."));
        }
#pragma CTC ENDSKIP
	    else {
            has_sdp_onging_wr_req_ = true;
        }

        sdp_wr_req = new client_wr_req_t;
        sdp_wr_req->addr  = payload->pd.dma_write_cmd.addr;
        sdp_wr_req->size  = (payload->pd.dma_write_cmd.size + 1) * DLA_ATOM_SIZE;    //In byte
        sdp_wr_req->require_ack = payload->pd.dma_write_cmd.require_ack;
        cslDebug((50, "write to sdp2mcif_wr_cmd_fifo_, addr:%lx, size:%d, num_free:%d, req_ack:%d\x0A", sdp_wr_req->addr, sdp_wr_req->size, sdp2mcif_wr_cmd_fifo_->num_free(),sdp_wr_req->require_ack));
        sdp2mcif_wr_cmd_fifo_->write(sdp_wr_req);
        sdp_wr_req_got_size_ = 0;
        sdp_wr_req_size_ = sdp_wr_req->size;

    } else {
        dma_payload_data_ptr = reinterpret_cast <uint8_t *> (payload->pd.dma_write_data.data);
        rest_size = sdp_wr_req_size_ - sdp_wr_req_got_size_;
        incoming_size = min(rest_size, uint32_t (DMAIF_WIDTH));
        for(int atom_iter = 0; atom_iter < incoming_size/MIN_BUS_WIDTH; atom_iter++) {
            data_ptr = new uint8_t[MIN_BUS_WIDTH];
            memcpy(data_ptr, dma_payload_data_ptr + MIN_BUS_WIDTH*atom_iter, MIN_BUS_WIDTH);
            cslDebug((50, "write to sdp2mcif_wr_data_fifo_, num_free:%d\x0A", sdp2mcif_wr_data_fifo_->num_free()));
            cslDebug((50, "sdp2mcif_wr_data_fifo_ data:\x0A"));
            for(int i = 0; i < MIN_BUS_WIDTH; i++) {
                cslDebug((50, "%x ", data_ptr[i]));
            }
            cslDebug((50, "\x0A"));

            sdp2mcif_wr_data_fifo_->write(data_ptr);   // Write to FIFO in 32Byte atom
        }
        sdp_wr_req_got_size_ += incoming_size;
       
        if (sdp_wr_req_got_size_ == sdp_wr_req_size_) {
            cslDebug((50, "one write request done on sdp\x0A"));
            has_sdp_onging_wr_req_ = false;
        }
    }
}

void NV_NVDLA_mcif::WriteRequest_sdp2mcif() {
    uint64_t base_addr, cur_address;
    uint64_t first_base_addr;
    uint64_t last_base_addr, last_actual_addr, last_aligned_addr;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_base_aligned;
    bool     is_rear_aligned;
    bool     is_read=false;
    uint8_t  *axi_atom_ptr;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    client_wr_req_t   * sdp_wr_req;
    dla_b_transport_payload *bt_payload;
    int      atom_num;

    while(true) {
        // Read one write command
        sdp_wr_req = sdp2mcif_wr_cmd_fifo_->read();
        payload_addr = sdp_wr_req->addr;   // It's aligend to 32B, not 64B
        payload_size = sdp_wr_req->size;

        is_base_aligned      = (payload_addr%AXI_ALIGN_SIZE) == 0;
        first_base_addr     = (payload_addr/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE;
        last_actual_addr    = payload_addr + payload_size;
        last_aligned_addr   = ((last_actual_addr + AXI_ALIGN_SIZE -1)/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE;
        last_base_addr      = last_aligned_addr - MEM_TRANSACTION_SIZE;
        is_rear_aligned     = ((payload_addr + payload_size) % AXI_ALIGN_SIZE) == 0;
        total_axi_size      = last_aligned_addr - first_base_addr;
        cslDebug((30, "XXXXXXX NV_NVDLA_mcif::WriteRequest_sdp2mcif, first_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, total_axi_size, payload_addr, payload_size));

        cur_address = base_addr = first_base_addr;
        while (cur_address <= last_base_addr) {
            base_addr = cur_address;
            size_in_byte = MEM_TRANSACTION_SIZE;

            // Check whether next ATOM belongs to current AXI transaction
            while (((cur_address + MEM_TRANSACTION_SIZE) < last_aligned_addr) && ((cur_address + MEM_TRANSACTION_SIZE) % MCIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
                size_in_byte += MEM_TRANSACTION_SIZE;
                cur_address  += MEM_TRANSACTION_SIZE;
            }
            // start address of next axi transaction
            cur_address += MEM_TRANSACTION_SIZE;

            atom_num = size_in_byte / MIN_BUS_WIDTH;
            bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
            axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
            for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
                if ( base_addr + byte_iter < payload_addr) {
                    // Diable 1st DMA atom of the unaligned first_base_addr
                    assert(is_base_aligned == false);
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                } else if (base_addr + byte_iter >= last_actual_addr) {
                    // Diable last unaligned last_base_addr
                    assert(is_rear_aligned == false);
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                } else {
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;  // All bytes should be enabled
                }
            }
            cslDebug((50, "NV_NVDLA_mcif::WriteRequest_sdp2mcif, TLM_BYTE_ENABLE is done\x0A"));

            for (int atom_iter=0; atom_iter < atom_num; atom_iter++) {
                if ( axi_byte_enable_ptr[atom_iter*MIN_BUS_WIDTH] == TLM_BYTE_DISABLED) {
                    // Disable 1st DMA atom of the unaligned first_base_addr
                    // Use unaligned address as required by DBB_PV
                    for(int elt_iter = 0; elt_iter < MIN_BUS_WIDTH; elt_iter++) {
                        bt_payload->data[atom_iter*MIN_BUS_WIDTH + elt_iter] = 0;
                    }
                } else {
                    cslDebug((50, "NV_NVDLA_mcif::WriteRequest_sdp2mcif, before read an atom from sdp2mcif_wr_data_fifo_, base_addr = 0x%lx, atom_iter=0x%x\x0A", base_addr, atom_iter));

                    axi_atom_ptr = sdp2mcif_wr_data_fifo_->read();
                    cslDebug((50, "NV_NVDLA_mcif::WriteRequest_sdp2mcif, after read an atom from sdp2mcif_wr_data_fifo_\x0A"));
                    for(int i=0; i<MIN_BUS_WIDTH; i++) {
                        cslDebug((50, "%02x ", axi_atom_ptr[i]));
                    }
                    cslDebug((50, "\x0A"));
                    for(int elt_iter = 0; elt_iter < MIN_BUS_WIDTH; elt_iter++) {
                        bt_payload->data[atom_iter*MIN_BUS_WIDTH + elt_iter] = axi_atom_ptr[elt_iter];
                    }
                    delete[] axi_atom_ptr;
                }
            }


            if ( (cur_address >= last_actual_addr) && (sdp_wr_req->require_ack != 0) ) {
                cslDebug((30, "NV_NVDLA_mcif::WriteRequest_sdp2mcif, required ack.\x0A"));
                sdp_wr_required_ack_fifo_->write(true);
            }
            else {
                cslDebug((30, "NV_NVDLA_mcif::WriteRequest_sdp2mcif, did not require ack.\x0A"));
                sdp_wr_required_ack_fifo_->write(false);
            }

            // Prepare write payload
            bt_payload->configure_gp(base_addr, size_in_byte, is_read);
            bt_payload->gp.get_extension(nvdla_dbb_ext);
            cslDebug((50, "NV_NVDLA_mcif::WriteRequest_sdp2mcif, sending write command to sdp_wr_req_fifo_.\x0A"));
            cslDebug((50, "    addr: 0x%lx\x0A", base_addr));
            cslDebug((50, "    size: %d\x0A", size_in_byte));
            nvdla_dbb_ext->set_id(SDP_AXI_ID);
            nvdla_dbb_ext->set_size(MEM_TRANSACTION_SIZE);
            nvdla_dbb_ext->set_length(size_in_byte/MEM_TRANSACTION_SIZE);

#pragma CTC SKIP
            if(size_in_byte%AXI_ALIGN_SIZE!=0)
                FAIL(("NV_NVDLA_mcif::sdp2mcif_rd_req_b_transport, size_in_byte is not multiple of AXI_ALIGN_SIZE. size_in_byte=0x%x", size_in_byte));
#pragma CTC ENDSKIP

            // write payload to arbiter fifo
            sdp_wr_req_fifo_->write(bt_payload);
        }
        delete sdp_wr_req;
    }
}

void NV_NVDLA_mcif::pdp2mcif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) {
    uint32_t packet_id;
    uint8_t  *dma_payload_data_ptr;
    uint8_t  *data_ptr;
    uint32_t rest_size, incoming_size;
    client_wr_req_t * pdp_wr_req;

    packet_id = payload->tag;
    if (TAG_CMD == packet_id) {
        pdp_wr_req_count_ ++;
#pragma CTC SKIP
        if (true == has_pdp_onging_wr_req_) {
            FAIL(("NV_NVDLA_mcif::pdp2mcif_wr_req_b_transport, got two consective command request, one command request shall be followed by one or more data request."));
        }
#pragma CTC ENDSKIP
	    else {
            has_pdp_onging_wr_req_ = true;
        }

        pdp_wr_req = new client_wr_req_t;
        pdp_wr_req->addr  = payload->pd.dma_write_cmd.addr;
        pdp_wr_req->size  = (payload->pd.dma_write_cmd.size + 1) * DLA_ATOM_SIZE;    //In byte
        pdp_wr_req->require_ack = payload->pd.dma_write_cmd.require_ack;
        cslDebug((50, "write to pdp2mcif_wr_cmd_fifo_, addr:%lx, size:%d, num_free:%d, req_ack:%d\x0A", pdp_wr_req->addr, pdp_wr_req->size, pdp2mcif_wr_cmd_fifo_->num_free(),pdp_wr_req->require_ack));
        pdp2mcif_wr_cmd_fifo_->write(pdp_wr_req);
        pdp_wr_req_got_size_ = 0;
        pdp_wr_req_size_ = pdp_wr_req->size;

    } else {
        dma_payload_data_ptr = reinterpret_cast <uint8_t *> (payload->pd.dma_write_data.data);
        rest_size = pdp_wr_req_size_ - pdp_wr_req_got_size_;
        incoming_size = min(rest_size, uint32_t (DMAIF_WIDTH));
        for(int atom_iter = 0; atom_iter < incoming_size/MIN_BUS_WIDTH; atom_iter++) {
            data_ptr = new uint8_t[MIN_BUS_WIDTH];
            memcpy(data_ptr, dma_payload_data_ptr + MIN_BUS_WIDTH*atom_iter, MIN_BUS_WIDTH);
            cslDebug((50, "write to pdp2mcif_wr_data_fifo_, num_free:%d\x0A", pdp2mcif_wr_data_fifo_->num_free()));
            cslDebug((50, "pdp2mcif_wr_data_fifo_ data:\x0A"));
            for(int i = 0; i < MIN_BUS_WIDTH; i++) {
                cslDebug((50, "%x ", data_ptr[i]));
            }
            cslDebug((50, "\x0A"));

            pdp2mcif_wr_data_fifo_->write(data_ptr);   // Write to FIFO in 32Byte atom
        }
        pdp_wr_req_got_size_ += incoming_size;
       
        if (pdp_wr_req_got_size_ == pdp_wr_req_size_) {
            cslDebug((50, "one write request done on pdp\x0A"));
            has_pdp_onging_wr_req_ = false;
        }
    }
}

void NV_NVDLA_mcif::WriteRequest_pdp2mcif() {
    uint64_t base_addr, cur_address;
    uint64_t first_base_addr;
    uint64_t last_base_addr, last_actual_addr, last_aligned_addr;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_base_aligned;
    bool     is_rear_aligned;
    bool     is_read=false;
    uint8_t  *axi_atom_ptr;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    client_wr_req_t   * pdp_wr_req;
    dla_b_transport_payload *bt_payload;
    int      atom_num;

    while(true) {
        // Read one write command
        pdp_wr_req = pdp2mcif_wr_cmd_fifo_->read();
        payload_addr = pdp_wr_req->addr;   // It's aligend to 32B, not 64B
        payload_size = pdp_wr_req->size;

        is_base_aligned      = (payload_addr%AXI_ALIGN_SIZE) == 0;
        first_base_addr     = (payload_addr/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE;
        last_actual_addr    = payload_addr + payload_size;
        last_aligned_addr   = ((last_actual_addr + AXI_ALIGN_SIZE -1)/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE;
        last_base_addr      = last_aligned_addr - MEM_TRANSACTION_SIZE;
        is_rear_aligned     = ((payload_addr + payload_size) % AXI_ALIGN_SIZE) == 0;
        total_axi_size      = last_aligned_addr - first_base_addr;
        cslDebug((30, "XXXXXXX NV_NVDLA_mcif::WriteRequest_pdp2mcif, first_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, total_axi_size, payload_addr, payload_size));

        cur_address = base_addr = first_base_addr;
        while (cur_address <= last_base_addr) {
            base_addr = cur_address;
            size_in_byte = MEM_TRANSACTION_SIZE;

            // Check whether next ATOM belongs to current AXI transaction
            while (((cur_address + MEM_TRANSACTION_SIZE) < last_aligned_addr) && ((cur_address + MEM_TRANSACTION_SIZE) % MCIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
                size_in_byte += MEM_TRANSACTION_SIZE;
                cur_address  += MEM_TRANSACTION_SIZE;
            }
            // start address of next axi transaction
            cur_address += MEM_TRANSACTION_SIZE;

            atom_num = size_in_byte / MIN_BUS_WIDTH;
            bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
            axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
            for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
                if ( base_addr + byte_iter < payload_addr) {
                    // Diable 1st DMA atom of the unaligned first_base_addr
                    assert(is_base_aligned == false);
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                } else if (base_addr + byte_iter >= last_actual_addr) {
                    // Diable last unaligned last_base_addr
                    assert(is_rear_aligned == false);
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                } else {
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;  // All bytes should be enabled
                }
            }
            cslDebug((50, "NV_NVDLA_mcif::WriteRequest_pdp2mcif, TLM_BYTE_ENABLE is done\x0A"));

            for (int atom_iter=0; atom_iter < atom_num; atom_iter++) {
                if ( axi_byte_enable_ptr[atom_iter*MIN_BUS_WIDTH] == TLM_BYTE_DISABLED) {
                    // Disable 1st DMA atom of the unaligned first_base_addr
                    // Use unaligned address as required by DBB_PV
                    for(int elt_iter = 0; elt_iter < MIN_BUS_WIDTH; elt_iter++) {
                        bt_payload->data[atom_iter*MIN_BUS_WIDTH + elt_iter] = 0;
                    }
                } else {
                    cslDebug((50, "NV_NVDLA_mcif::WriteRequest_pdp2mcif, before read an atom from pdp2mcif_wr_data_fifo_, base_addr = 0x%lx, atom_iter=0x%x\x0A", base_addr, atom_iter));

                    axi_atom_ptr = pdp2mcif_wr_data_fifo_->read();
                    cslDebug((50, "NV_NVDLA_mcif::WriteRequest_pdp2mcif, after read an atom from pdp2mcif_wr_data_fifo_\x0A"));
                    for(int i=0; i<MIN_BUS_WIDTH; i++) {
                        cslDebug((50, "%02x ", axi_atom_ptr[i]));
                    }
                    cslDebug((50, "\x0A"));
                    for(int elt_iter = 0; elt_iter < MIN_BUS_WIDTH; elt_iter++) {
                        bt_payload->data[atom_iter*MIN_BUS_WIDTH + elt_iter] = axi_atom_ptr[elt_iter];
                    }
                    delete[] axi_atom_ptr;
                }
            }


            if ( (cur_address >= last_actual_addr) && (pdp_wr_req->require_ack != 0) ) {
                cslDebug((30, "NV_NVDLA_mcif::WriteRequest_pdp2mcif, required ack.\x0A"));
                pdp_wr_required_ack_fifo_->write(true);
            }
            else {
                cslDebug((30, "NV_NVDLA_mcif::WriteRequest_pdp2mcif, did not require ack.\x0A"));
                pdp_wr_required_ack_fifo_->write(false);
            }

            // Prepare write payload
            bt_payload->configure_gp(base_addr, size_in_byte, is_read);
            bt_payload->gp.get_extension(nvdla_dbb_ext);
            cslDebug((50, "NV_NVDLA_mcif::WriteRequest_pdp2mcif, sending write command to pdp_wr_req_fifo_.\x0A"));
            cslDebug((50, "    addr: 0x%lx\x0A", base_addr));
            cslDebug((50, "    size: %d\x0A", size_in_byte));
            nvdla_dbb_ext->set_id(PDP_AXI_ID);
            nvdla_dbb_ext->set_size(MEM_TRANSACTION_SIZE);
            nvdla_dbb_ext->set_length(size_in_byte/MEM_TRANSACTION_SIZE);

#pragma CTC SKIP
            if(size_in_byte%AXI_ALIGN_SIZE!=0)
                FAIL(("NV_NVDLA_mcif::pdp2mcif_rd_req_b_transport, size_in_byte is not multiple of AXI_ALIGN_SIZE. size_in_byte=0x%x", size_in_byte));
#pragma CTC ENDSKIP

            // write payload to arbiter fifo
            pdp_wr_req_fifo_->write(bt_payload);
        }
        delete pdp_wr_req;
    }
}

void NV_NVDLA_mcif::cdp2mcif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) {
    uint32_t packet_id;
    uint8_t  *dma_payload_data_ptr;
    uint8_t  *data_ptr;
    uint32_t rest_size, incoming_size;
    client_wr_req_t * cdp_wr_req;

    packet_id = payload->tag;
    if (TAG_CMD == packet_id) {
        cdp_wr_req_count_ ++;
#pragma CTC SKIP
        if (true == has_cdp_onging_wr_req_) {
            FAIL(("NV_NVDLA_mcif::cdp2mcif_wr_req_b_transport, got two consective command request, one command request shall be followed by one or more data request."));
        }
#pragma CTC ENDSKIP
	    else {
            has_cdp_onging_wr_req_ = true;
        }

        cdp_wr_req = new client_wr_req_t;
        cdp_wr_req->addr  = payload->pd.dma_write_cmd.addr;
        cdp_wr_req->size  = (payload->pd.dma_write_cmd.size + 1) * DLA_ATOM_SIZE;    //In byte
        cdp_wr_req->require_ack = payload->pd.dma_write_cmd.require_ack;
        cslDebug((50, "write to cdp2mcif_wr_cmd_fifo_, addr:%lx, size:%d, num_free:%d, req_ack:%d\x0A", cdp_wr_req->addr, cdp_wr_req->size, cdp2mcif_wr_cmd_fifo_->num_free(),cdp_wr_req->require_ack));
        cdp2mcif_wr_cmd_fifo_->write(cdp_wr_req);
        cdp_wr_req_got_size_ = 0;
        cdp_wr_req_size_ = cdp_wr_req->size;

    } else {
        dma_payload_data_ptr = reinterpret_cast <uint8_t *> (payload->pd.dma_write_data.data);
        rest_size = cdp_wr_req_size_ - cdp_wr_req_got_size_;
        incoming_size = min(rest_size, uint32_t (DMAIF_WIDTH));
        for(int atom_iter = 0; atom_iter < incoming_size/MIN_BUS_WIDTH; atom_iter++) {
            data_ptr = new uint8_t[MIN_BUS_WIDTH];
            memcpy(data_ptr, dma_payload_data_ptr + MIN_BUS_WIDTH*atom_iter, MIN_BUS_WIDTH);
            cslDebug((50, "write to cdp2mcif_wr_data_fifo_, num_free:%d\x0A", cdp2mcif_wr_data_fifo_->num_free()));
            cslDebug((50, "cdp2mcif_wr_data_fifo_ data:\x0A"));
            for(int i = 0; i < MIN_BUS_WIDTH; i++) {
                cslDebug((50, "%x ", data_ptr[i]));
            }
            cslDebug((50, "\x0A"));

            cdp2mcif_wr_data_fifo_->write(data_ptr);   // Write to FIFO in 32Byte atom
        }
        cdp_wr_req_got_size_ += incoming_size;
       
        if (cdp_wr_req_got_size_ == cdp_wr_req_size_) {
            cslDebug((50, "one write request done on cdp\x0A"));
            has_cdp_onging_wr_req_ = false;
        }
    }
}

void NV_NVDLA_mcif::WriteRequest_cdp2mcif() {
    uint64_t base_addr, cur_address;
    uint64_t first_base_addr;
    uint64_t last_base_addr, last_actual_addr, last_aligned_addr;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_base_aligned;
    bool     is_rear_aligned;
    bool     is_read=false;
    uint8_t  *axi_atom_ptr;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    client_wr_req_t   * cdp_wr_req;
    dla_b_transport_payload *bt_payload;
    int      atom_num;

    while(true) {
        // Read one write command
        cdp_wr_req = cdp2mcif_wr_cmd_fifo_->read();
        payload_addr = cdp_wr_req->addr;   // It's aligend to 32B, not 64B
        payload_size = cdp_wr_req->size;

        is_base_aligned      = (payload_addr%AXI_ALIGN_SIZE) == 0;
        first_base_addr     = (payload_addr/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE;
        last_actual_addr    = payload_addr + payload_size;
        last_aligned_addr   = ((last_actual_addr + AXI_ALIGN_SIZE -1)/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE;
        last_base_addr      = last_aligned_addr - MEM_TRANSACTION_SIZE;
        is_rear_aligned     = ((payload_addr + payload_size) % AXI_ALIGN_SIZE) == 0;
        total_axi_size      = last_aligned_addr - first_base_addr;
        cslDebug((30, "XXXXXXX NV_NVDLA_mcif::WriteRequest_cdp2mcif, first_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, total_axi_size, payload_addr, payload_size));

        cur_address = base_addr = first_base_addr;
        while (cur_address <= last_base_addr) {
            base_addr = cur_address;
            size_in_byte = MEM_TRANSACTION_SIZE;

            // Check whether next ATOM belongs to current AXI transaction
            while (((cur_address + MEM_TRANSACTION_SIZE) < last_aligned_addr) && ((cur_address + MEM_TRANSACTION_SIZE) % MCIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
                size_in_byte += MEM_TRANSACTION_SIZE;
                cur_address  += MEM_TRANSACTION_SIZE;
            }
            // start address of next axi transaction
            cur_address += MEM_TRANSACTION_SIZE;

            atom_num = size_in_byte / MIN_BUS_WIDTH;
            bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
            axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
            for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
                if ( base_addr + byte_iter < payload_addr) {
                    // Diable 1st DMA atom of the unaligned first_base_addr
                    assert(is_base_aligned == false);
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                } else if (base_addr + byte_iter >= last_actual_addr) {
                    // Diable last unaligned last_base_addr
                    assert(is_rear_aligned == false);
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                } else {
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;  // All bytes should be enabled
                }
            }
            cslDebug((50, "NV_NVDLA_mcif::WriteRequest_cdp2mcif, TLM_BYTE_ENABLE is done\x0A"));

            for (int atom_iter=0; atom_iter < atom_num; atom_iter++) {
                if ( axi_byte_enable_ptr[atom_iter*MIN_BUS_WIDTH] == TLM_BYTE_DISABLED) {
                    // Disable 1st DMA atom of the unaligned first_base_addr
                    // Use unaligned address as required by DBB_PV
                    for(int elt_iter = 0; elt_iter < MIN_BUS_WIDTH; elt_iter++) {
                        bt_payload->data[atom_iter*MIN_BUS_WIDTH + elt_iter] = 0;
                    }
                } else {
                    cslDebug((50, "NV_NVDLA_mcif::WriteRequest_cdp2mcif, before read an atom from cdp2mcif_wr_data_fifo_, base_addr = 0x%lx, atom_iter=0x%x\x0A", base_addr, atom_iter));

                    axi_atom_ptr = cdp2mcif_wr_data_fifo_->read();
                    cslDebug((50, "NV_NVDLA_mcif::WriteRequest_cdp2mcif, after read an atom from cdp2mcif_wr_data_fifo_\x0A"));
                    for(int i=0; i<MIN_BUS_WIDTH; i++) {
                        cslDebug((50, "%02x ", axi_atom_ptr[i]));
                    }
                    cslDebug((50, "\x0A"));
                    for(int elt_iter = 0; elt_iter < MIN_BUS_WIDTH; elt_iter++) {
                        bt_payload->data[atom_iter*MIN_BUS_WIDTH + elt_iter] = axi_atom_ptr[elt_iter];
                    }
                    delete[] axi_atom_ptr;
                }
            }


            if ( (cur_address >= last_actual_addr) && (cdp_wr_req->require_ack != 0) ) {
                cslDebug((30, "NV_NVDLA_mcif::WriteRequest_cdp2mcif, required ack.\x0A"));
                cdp_wr_required_ack_fifo_->write(true);
            }
            else {
                cslDebug((30, "NV_NVDLA_mcif::WriteRequest_cdp2mcif, did not require ack.\x0A"));
                cdp_wr_required_ack_fifo_->write(false);
            }

            // Prepare write payload
            bt_payload->configure_gp(base_addr, size_in_byte, is_read);
            bt_payload->gp.get_extension(nvdla_dbb_ext);
            cslDebug((50, "NV_NVDLA_mcif::WriteRequest_cdp2mcif, sending write command to cdp_wr_req_fifo_.\x0A"));
            cslDebug((50, "    addr: 0x%lx\x0A", base_addr));
            cslDebug((50, "    size: %d\x0A", size_in_byte));
            nvdla_dbb_ext->set_id(CDP_AXI_ID);
            nvdla_dbb_ext->set_size(MEM_TRANSACTION_SIZE);
            nvdla_dbb_ext->set_length(size_in_byte/MEM_TRANSACTION_SIZE);

#pragma CTC SKIP
            if(size_in_byte%AXI_ALIGN_SIZE!=0)
                FAIL(("NV_NVDLA_mcif::cdp2mcif_rd_req_b_transport, size_in_byte is not multiple of AXI_ALIGN_SIZE. size_in_byte=0x%x", size_in_byte));
#pragma CTC ENDSKIP

            // write payload to arbiter fifo
            cdp_wr_req_fifo_->write(bt_payload);
        }
        delete cdp_wr_req;
    }
}

void NV_NVDLA_mcif::rbk2mcif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) {
    uint32_t packet_id;
    uint8_t  *dma_payload_data_ptr;
    uint8_t  *data_ptr;
    uint32_t rest_size, incoming_size;
    client_wr_req_t * rbk_wr_req;

    packet_id = payload->tag;
    if (TAG_CMD == packet_id) {
        rbk_wr_req_count_ ++;
#pragma CTC SKIP
        if (true == has_rbk_onging_wr_req_) {
            FAIL(("NV_NVDLA_mcif::rbk2mcif_wr_req_b_transport, got two consective command request, one command request shall be followed by one or more data request."));
        }
#pragma CTC ENDSKIP
	    else {
            has_rbk_onging_wr_req_ = true;
        }

        rbk_wr_req = new client_wr_req_t;
        rbk_wr_req->addr  = payload->pd.dma_write_cmd.addr;
        rbk_wr_req->size  = (payload->pd.dma_write_cmd.size + 1) * DLA_ATOM_SIZE;    //In byte
        rbk_wr_req->require_ack = payload->pd.dma_write_cmd.require_ack;
        cslDebug((50, "write to rbk2mcif_wr_cmd_fifo_, addr:%lx, size:%d, num_free:%d, req_ack:%d\x0A", rbk_wr_req->addr, rbk_wr_req->size, rbk2mcif_wr_cmd_fifo_->num_free(),rbk_wr_req->require_ack));
        rbk2mcif_wr_cmd_fifo_->write(rbk_wr_req);
        rbk_wr_req_got_size_ = 0;
        rbk_wr_req_size_ = rbk_wr_req->size;

    } else {
        dma_payload_data_ptr = reinterpret_cast <uint8_t *> (payload->pd.dma_write_data.data);
        rest_size = rbk_wr_req_size_ - rbk_wr_req_got_size_;
        incoming_size = min(rest_size, uint32_t (DMAIF_WIDTH));
        for(int atom_iter = 0; atom_iter < incoming_size/MIN_BUS_WIDTH; atom_iter++) {
            data_ptr = new uint8_t[MIN_BUS_WIDTH];
            memcpy(data_ptr, dma_payload_data_ptr + MIN_BUS_WIDTH*atom_iter, MIN_BUS_WIDTH);
            cslDebug((50, "write to rbk2mcif_wr_data_fifo_, num_free:%d\x0A", rbk2mcif_wr_data_fifo_->num_free()));
            cslDebug((50, "rbk2mcif_wr_data_fifo_ data:\x0A"));
            for(int i = 0; i < MIN_BUS_WIDTH; i++) {
                cslDebug((50, "%x ", data_ptr[i]));
            }
            cslDebug((50, "\x0A"));

            rbk2mcif_wr_data_fifo_->write(data_ptr);   // Write to FIFO in 32Byte atom
        }
        rbk_wr_req_got_size_ += incoming_size;
       
        if (rbk_wr_req_got_size_ == rbk_wr_req_size_) {
            cslDebug((50, "one write request done on rbk\x0A"));
            has_rbk_onging_wr_req_ = false;
        }
    }
}

void NV_NVDLA_mcif::WriteRequest_rbk2mcif() {
    uint64_t base_addr, cur_address;
    uint64_t first_base_addr;
    uint64_t last_base_addr, last_actual_addr, last_aligned_addr;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_base_aligned;
    bool     is_rear_aligned;
    bool     is_read=false;
    uint8_t  *axi_atom_ptr;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    client_wr_req_t   * rbk_wr_req;
    dla_b_transport_payload *bt_payload;
    int      atom_num;

    while(true) {
        // Read one write command
        rbk_wr_req = rbk2mcif_wr_cmd_fifo_->read();
        payload_addr = rbk_wr_req->addr;   // It's aligend to 32B, not 64B
        payload_size = rbk_wr_req->size;

        is_base_aligned      = (payload_addr%AXI_ALIGN_SIZE) == 0;
        first_base_addr     = (payload_addr/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE;
        last_actual_addr    = payload_addr + payload_size;
        last_aligned_addr   = ((last_actual_addr + AXI_ALIGN_SIZE -1)/AXI_ALIGN_SIZE)*AXI_ALIGN_SIZE;
        last_base_addr      = last_aligned_addr - MEM_TRANSACTION_SIZE;
        is_rear_aligned     = ((payload_addr + payload_size) % AXI_ALIGN_SIZE) == 0;
        total_axi_size      = last_aligned_addr - first_base_addr;
        cslDebug((30, "XXXXXXX NV_NVDLA_mcif::WriteRequest_rbk2mcif, first_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, total_axi_size, payload_addr, payload_size));

        cur_address = base_addr = first_base_addr;
        while (cur_address <= last_base_addr) {
            base_addr = cur_address;
            size_in_byte = MEM_TRANSACTION_SIZE;

            // Check whether next ATOM belongs to current AXI transaction
            while (((cur_address + MEM_TRANSACTION_SIZE) < last_aligned_addr) && ((cur_address + MEM_TRANSACTION_SIZE) % MCIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
                size_in_byte += MEM_TRANSACTION_SIZE;
                cur_address  += MEM_TRANSACTION_SIZE;
            }
            // start address of next axi transaction
            cur_address += MEM_TRANSACTION_SIZE;

            atom_num = size_in_byte / MIN_BUS_WIDTH;
            bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
            axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
            for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
                if ( base_addr + byte_iter < payload_addr) {
                    // Diable 1st DMA atom of the unaligned first_base_addr
                    assert(is_base_aligned == false);
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                } else if (base_addr + byte_iter >= last_actual_addr) {
                    // Diable last unaligned last_base_addr
                    assert(is_rear_aligned == false);
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                } else {
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;  // All bytes should be enabled
                }
            }
            cslDebug((50, "NV_NVDLA_mcif::WriteRequest_rbk2mcif, TLM_BYTE_ENABLE is done\x0A"));

            for (int atom_iter=0; atom_iter < atom_num; atom_iter++) {
                if ( axi_byte_enable_ptr[atom_iter*MIN_BUS_WIDTH] == TLM_BYTE_DISABLED) {
                    // Disable 1st DMA atom of the unaligned first_base_addr
                    // Use unaligned address as required by DBB_PV
                    for(int elt_iter = 0; elt_iter < MIN_BUS_WIDTH; elt_iter++) {
                        bt_payload->data[atom_iter*MIN_BUS_WIDTH + elt_iter] = 0;
                    }
                } else {
                    cslDebug((50, "NV_NVDLA_mcif::WriteRequest_rbk2mcif, before read an atom from rbk2mcif_wr_data_fifo_, base_addr = 0x%lx, atom_iter=0x%x\x0A", base_addr, atom_iter));

                    axi_atom_ptr = rbk2mcif_wr_data_fifo_->read();
                    cslDebug((50, "NV_NVDLA_mcif::WriteRequest_rbk2mcif, after read an atom from rbk2mcif_wr_data_fifo_\x0A"));
                    for(int i=0; i<MIN_BUS_WIDTH; i++) {
                        cslDebug((50, "%02x ", axi_atom_ptr[i]));
                    }
                    cslDebug((50, "\x0A"));
                    for(int elt_iter = 0; elt_iter < MIN_BUS_WIDTH; elt_iter++) {
                        bt_payload->data[atom_iter*MIN_BUS_WIDTH + elt_iter] = axi_atom_ptr[elt_iter];
                    }
                    delete[] axi_atom_ptr;
                }
            }


            if ( (cur_address >= last_actual_addr) && (rbk_wr_req->require_ack != 0) ) {
                cslDebug((30, "NV_NVDLA_mcif::WriteRequest_rbk2mcif, required ack.\x0A"));
                rbk_wr_required_ack_fifo_->write(true);
            }
            else {
                cslDebug((30, "NV_NVDLA_mcif::WriteRequest_rbk2mcif, did not require ack.\x0A"));
                rbk_wr_required_ack_fifo_->write(false);
            }

            // Prepare write payload
            bt_payload->configure_gp(base_addr, size_in_byte, is_read);
            bt_payload->gp.get_extension(nvdla_dbb_ext);
            cslDebug((50, "NV_NVDLA_mcif::WriteRequest_rbk2mcif, sending write command to rbk_wr_req_fifo_.\x0A"));
            cslDebug((50, "    addr: 0x%lx\x0A", base_addr));
            cslDebug((50, "    size: %d\x0A", size_in_byte));
            nvdla_dbb_ext->set_id(RBK_AXI_ID);
            nvdla_dbb_ext->set_size(MEM_TRANSACTION_SIZE);
            nvdla_dbb_ext->set_length(size_in_byte/MEM_TRANSACTION_SIZE);

#pragma CTC SKIP
            if(size_in_byte%AXI_ALIGN_SIZE!=0)
                FAIL(("NV_NVDLA_mcif::rbk2mcif_rd_req_b_transport, size_in_byte is not multiple of AXI_ALIGN_SIZE. size_in_byte=0x%x", size_in_byte));
#pragma CTC ENDSKIP

            // write payload to arbiter fifo
            rbk_wr_req_fifo_->write(bt_payload);
        }
        delete rbk_wr_req;
    }
}


void NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& tlm_gp, sc_time& delay) {
    uint32_t            dma_sent_size;
    // uint64_t            axi_address;
    uint8_t*            axi_data_ptr;
    uint32_t            axi_length;
    uint8_t*            axi_byte_enable_ptr;
    uint32_t            axi_byte_enable_length;
    uint32_t            idx;
    uint32_t            axi_id;
    // uint8_t             axi2dma_byte_iter;
    // uint8_t             axi_byte_enable_checker;
    uint8_t             dma_payload_atom_mask;  // mask for one DMA atom
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    uint8_t           * axi_atom_ptr;
    
    // Get DBB extension
    tlm_gp.get_extension(nvdla_dbb_ext);
#pragma CTC SKIP
    if(!nvdla_dbb_ext) {
        FAIL(("NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, DBB extension is required, ar_id is needed to forward data to corresponding DMA."));
    }
#pragma CTC ENDSKIP

    axi_data_ptr           =  tlm_gp.get_data_ptr();
    axi_length             =  tlm_gp.get_data_length();
    axi_id                 =  nvdla_dbb_ext->get_id();
    axi_byte_enable_ptr    =  tlm_gp.get_byte_enable_ptr();
    axi_byte_enable_length =  tlm_gp.get_byte_enable_length();
    axi_id                 =  nvdla_dbb_ext->get_id();
    cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport\x0A"));
    cslDebug((50, "axi_id: 0x%x\x0A", axi_id));
    cslDebug((50, "axi_data_ptr: 0x%p\x0A", (void *) axi_data_ptr));
    cslDebug((50, "axi_length: %d\x0A", axi_length));
    cslDebug((50, "axi_byte_enable_ptr: 0x%p\x0A", (void *) axi_byte_enable_ptr));
    cslDebug((50, "axi_byte_enable_length: %d\x0A", axi_byte_enable_length));

    // Data from general payload
#pragma CTC SKIP
    if (axi_length > MCIF_MAX_MEM_TRANSACTION_SIZE) {
        FAIL(("NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, Max AXI transaction length is %d byte, current AXI transaction length is %d byte", MCIF_MAX_MEM_TRANSACTION_SIZE, axi_length));
    }
    if (0 != (axi_length%MIN_BUS_WIDTH)) {
        FAIL(("NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, AXI transaction length shall be an integral multiple of %d byte, current AXI transaction length is %d byte", MIN_BUS_WIDTH, axi_length));
    }
#pragma CTC ENDSKIP
    //  Parsing AXI payload and generating DMA response payloads
    dma_sent_size = 0;
    for (dma_sent_size = 0; dma_sent_size < axi_length; dma_sent_size += MIN_BUS_WIDTH) {
        cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, dma_sent_size: 0x%x\x0A", dma_sent_size));
        switch (axi_id) {

           case BDMA_AXI_ID:
                    dma_payload_atom_mask = (true == bdma_rd_atom_enable_fifo_->read())?0x1:0;
                    cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, read bdma_rd_atom_enable_fifo_, bdma payload atom mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
                break;
           case SDP_AXI_ID:
                    dma_payload_atom_mask = (true == sdp_rd_atom_enable_fifo_->read())?0x1:0;
                    cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, read sdp_rd_atom_enable_fifo_, sdp payload atom mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
                break;
           case PDP_AXI_ID:
                    dma_payload_atom_mask = (true == pdp_rd_atom_enable_fifo_->read())?0x1:0;
                    cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, read pdp_rd_atom_enable_fifo_, pdp payload atom mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
                break;
           case CDP_AXI_ID:
                    dma_payload_atom_mask = (true == cdp_rd_atom_enable_fifo_->read())?0x1:0;
                    cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, read cdp_rd_atom_enable_fifo_, cdp payload atom mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
                break;
           case RBK_AXI_ID:
                    dma_payload_atom_mask = (true == rbk_rd_atom_enable_fifo_->read())?0x1:0;
                    cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, read rbk_rd_atom_enable_fifo_, rbk payload atom mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
                break;
           case SDP_B_AXI_ID:
                    dma_payload_atom_mask = (true == sdp_b_rd_atom_enable_fifo_->read())?0x1:0;
                    cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, read sdp_b_rd_atom_enable_fifo_, sdp_b payload atom mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
                break;
           case SDP_N_AXI_ID:
                    dma_payload_atom_mask = (true == sdp_n_rd_atom_enable_fifo_->read())?0x1:0;
                    cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, read sdp_n_rd_atom_enable_fifo_, sdp_n payload atom mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
                break;
           case SDP_E_AXI_ID:
                    dma_payload_atom_mask = (true == sdp_e_rd_atom_enable_fifo_->read())?0x1:0;
                    cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, read sdp_e_rd_atom_enable_fifo_, sdp_e payload atom mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
                break;
           case CDMA_DAT_AXI_ID:
                    dma_payload_atom_mask = (true == cdma_dat_rd_atom_enable_fifo_->read())?0x1:0;
                    cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, read cdma_dat_rd_atom_enable_fifo_, cdma_dat payload atom mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
                break;
           case CDMA_WT_AXI_ID:
                    dma_payload_atom_mask = (true == cdma_wt_rd_atom_enable_fifo_->read())?0x1:0;
                    cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, read cdma_wt_rd_atom_enable_fifo_, cdma_wt payload atom mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
                break;

#pragma CTC SKIP
            default:
                FAIL(("NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, unexpected AXI ID"));
#pragma CTC ENDSKIP
        }
        // Push read returned data atom(32B) into fifo
        if (0x1 == dma_payload_atom_mask) {
            axi_atom_ptr = new uint8_t[MIN_BUS_WIDTH];
            for(int elt_iter = 0; elt_iter < MIN_BUS_WIDTH; elt_iter++) {{
                axi_atom_ptr[elt_iter] = axi_data_ptr[dma_sent_size + elt_iter];
            }}
            switch (axi_id) {

                 case BDMA_AXI_ID:
                        cslDebug((70, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, num_free:%d, axi_atom_ptr value:\x0A", mcif2bdma_rd_rsp_fifo_->num_free()));
                        for (idx = 0; idx < MIN_BUS_WIDTH; idx ++) {
                            cslDebug((70, "    0x%lx\x0A", uint64_t (axi_atom_ptr[idx])));
                        }
                        mcif2bdma_rd_rsp_fifo_->write(axi_atom_ptr);
                        cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, bdma payload atom mask is 0x1, write an atom to mcif2bdma_rd_rsp_fifo_, num_free:%d.\x0A", mcif2bdma_rd_rsp_fifo_->num_free()));
                    break;
                 case SDP_AXI_ID:
                        cslDebug((70, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, num_free:%d, axi_atom_ptr value:\x0A", mcif2sdp_rd_rsp_fifo_->num_free()));
                        for (idx = 0; idx < MIN_BUS_WIDTH; idx ++) {
                            cslDebug((70, "    0x%lx\x0A", uint64_t (axi_atom_ptr[idx])));
                        }
                        mcif2sdp_rd_rsp_fifo_->write(axi_atom_ptr);
                        cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, sdp payload atom mask is 0x1, write an atom to mcif2sdp_rd_rsp_fifo_, num_free:%d.\x0A", mcif2sdp_rd_rsp_fifo_->num_free()));
                    break;
                 case PDP_AXI_ID:
                        cslDebug((70, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, num_free:%d, axi_atom_ptr value:\x0A", mcif2pdp_rd_rsp_fifo_->num_free()));
                        for (idx = 0; idx < MIN_BUS_WIDTH; idx ++) {
                            cslDebug((70, "    0x%lx\x0A", uint64_t (axi_atom_ptr[idx])));
                        }
                        mcif2pdp_rd_rsp_fifo_->write(axi_atom_ptr);
                        cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, pdp payload atom mask is 0x1, write an atom to mcif2pdp_rd_rsp_fifo_, num_free:%d.\x0A", mcif2pdp_rd_rsp_fifo_->num_free()));
                    break;
                 case CDP_AXI_ID:
                        cslDebug((70, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, num_free:%d, axi_atom_ptr value:\x0A", mcif2cdp_rd_rsp_fifo_->num_free()));
                        for (idx = 0; idx < MIN_BUS_WIDTH; idx ++) {
                            cslDebug((70, "    0x%lx\x0A", uint64_t (axi_atom_ptr[idx])));
                        }
                        mcif2cdp_rd_rsp_fifo_->write(axi_atom_ptr);
                        cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, cdp payload atom mask is 0x1, write an atom to mcif2cdp_rd_rsp_fifo_, num_free:%d.\x0A", mcif2cdp_rd_rsp_fifo_->num_free()));
                    break;
                 case RBK_AXI_ID:
                        cslDebug((70, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, num_free:%d, axi_atom_ptr value:\x0A", mcif2rbk_rd_rsp_fifo_->num_free()));
                        for (idx = 0; idx < MIN_BUS_WIDTH; idx ++) {
                            cslDebug((70, "    0x%lx\x0A", uint64_t (axi_atom_ptr[idx])));
                        }
                        mcif2rbk_rd_rsp_fifo_->write(axi_atom_ptr);
                        cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, rbk payload atom mask is 0x1, write an atom to mcif2rbk_rd_rsp_fifo_, num_free:%d.\x0A", mcif2rbk_rd_rsp_fifo_->num_free()));
                    break;
                 case SDP_B_AXI_ID:
                        cslDebug((70, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, num_free:%d, axi_atom_ptr value:\x0A", mcif2sdp_b_rd_rsp_fifo_->num_free()));
                        for (idx = 0; idx < MIN_BUS_WIDTH; idx ++) {
                            cslDebug((70, "    0x%lx\x0A", uint64_t (axi_atom_ptr[idx])));
                        }
                        mcif2sdp_b_rd_rsp_fifo_->write(axi_atom_ptr);
                        cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, sdp_b payload atom mask is 0x1, write an atom to mcif2sdp_b_rd_rsp_fifo_, num_free:%d.\x0A", mcif2sdp_b_rd_rsp_fifo_->num_free()));
                    break;
                 case SDP_N_AXI_ID:
                        cslDebug((70, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, num_free:%d, axi_atom_ptr value:\x0A", mcif2sdp_n_rd_rsp_fifo_->num_free()));
                        for (idx = 0; idx < MIN_BUS_WIDTH; idx ++) {
                            cslDebug((70, "    0x%lx\x0A", uint64_t (axi_atom_ptr[idx])));
                        }
                        mcif2sdp_n_rd_rsp_fifo_->write(axi_atom_ptr);
                        cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, sdp_n payload atom mask is 0x1, write an atom to mcif2sdp_n_rd_rsp_fifo_, num_free:%d.\x0A", mcif2sdp_n_rd_rsp_fifo_->num_free()));
                    break;
                 case SDP_E_AXI_ID:
                        cslDebug((70, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, num_free:%d, axi_atom_ptr value:\x0A", mcif2sdp_e_rd_rsp_fifo_->num_free()));
                        for (idx = 0; idx < MIN_BUS_WIDTH; idx ++) {
                            cslDebug((70, "    0x%lx\x0A", uint64_t (axi_atom_ptr[idx])));
                        }
                        mcif2sdp_e_rd_rsp_fifo_->write(axi_atom_ptr);
                        cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, sdp_e payload atom mask is 0x1, write an atom to mcif2sdp_e_rd_rsp_fifo_, num_free:%d.\x0A", mcif2sdp_e_rd_rsp_fifo_->num_free()));
                    break;
                 case CDMA_DAT_AXI_ID:
                        cslDebug((70, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, num_free:%d, axi_atom_ptr value:\x0A", mcif2cdma_dat_rd_rsp_fifo_->num_free()));
                        for (idx = 0; idx < MIN_BUS_WIDTH; idx ++) {
                            cslDebug((70, "    0x%lx\x0A", uint64_t (axi_atom_ptr[idx])));
                        }
                        mcif2cdma_dat_rd_rsp_fifo_->write(axi_atom_ptr);
                        cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, cdma_dat payload atom mask is 0x1, write an atom to mcif2cdma_dat_rd_rsp_fifo_, num_free:%d.\x0A", mcif2cdma_dat_rd_rsp_fifo_->num_free()));
                    break;
                 case CDMA_WT_AXI_ID:
                        cslDebug((70, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, num_free:%d, axi_atom_ptr value:\x0A", mcif2cdma_wt_rd_rsp_fifo_->num_free()));
                        for (idx = 0; idx < MIN_BUS_WIDTH; idx ++) {
                            cslDebug((70, "    0x%lx\x0A", uint64_t (axi_atom_ptr[idx])));
                        }
                        mcif2cdma_wt_rd_rsp_fifo_->write(axi_atom_ptr);
                        cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, cdma_wt payload atom mask is 0x1, write an atom to mcif2cdma_wt_rd_rsp_fifo_, num_free:%d.\x0A", mcif2cdma_wt_rd_rsp_fifo_->num_free()));
                    break;

#pragma CTC SKIP
                default:
                    FAIL(("NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, unexpected AXI ID"));
#pragma CTC ENDSKIP
            }
        } else {
            cslDebug((50, "NV_NVDLA_mcif::ext2mcif_rd_rsp_b_transport, {client} payload atom mask is 0x0, ignore current atom, dma_payload_atom_mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
        }
    }

    tlm_gp.set_response_status(tlm::TLM_OK_RESPONSE);
}

void NV_NVDLA_mcif::ext2mcif_wr_rsp_b_transport(int ID, tlm::tlm_generic_payload& tlm_gp, sc_time& delay) {
    uint8_t             axi_id;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    cslDebug((50, "NV_NVDLA_mcif::ext2mcif_wr_rsp_b_transport.\x0A"));

    // Get DBB extension
    tlm_gp.get_extension(nvdla_dbb_ext);
#pragma CTC SKIP
    if(!nvdla_dbb_ext) {
        FAIL(("NV_NVDLA_mcif::ext2mcif_wr_rsp_b_transport, DBB extension is required, ar_id is needed to forward data to corresponding DMA."));
    }
#pragma CTC ENDSKIP
    axi_id  = nvdla_dbb_ext->get_id();
    switch (axi_id) {

        case BDMA_AXI_ID:
            bdma_wr_rsp_count_ ++;
            // Read a new reques id from fifo
            bdma_wr_req_expected_ack = bdma_wr_required_ack_fifo_->read();
            cslDebug((50, "NV_NVDLA_mcif::ext2bdma_wr_rsp_b_transport, bdma_wr_req_expected_ack=0x%x\x0A", bdma_wr_req_expected_ack));
            if (true == bdma_wr_req_expected_ack) {
                cslDebug((50, "send wr rsp to bdma\x0A"));
                NV_NVDLA_mcif_base::mcif2bdma_wr_rsp.write(true);
            }
            break;
        case SDP_AXI_ID:
            sdp_wr_rsp_count_ ++;
            // Read a new reques id from fifo
            sdp_wr_req_expected_ack = sdp_wr_required_ack_fifo_->read();
            cslDebug((50, "NV_NVDLA_mcif::ext2sdp_wr_rsp_b_transport, sdp_wr_req_expected_ack=0x%x\x0A", sdp_wr_req_expected_ack));
            if (true == sdp_wr_req_expected_ack) {
                cslDebug((50, "send wr rsp to sdp\x0A"));
                NV_NVDLA_mcif_base::mcif2sdp_wr_rsp.write(true);
            }
            break;
        case PDP_AXI_ID:
            pdp_wr_rsp_count_ ++;
            // Read a new reques id from fifo
            pdp_wr_req_expected_ack = pdp_wr_required_ack_fifo_->read();
            cslDebug((50, "NV_NVDLA_mcif::ext2pdp_wr_rsp_b_transport, pdp_wr_req_expected_ack=0x%x\x0A", pdp_wr_req_expected_ack));
            if (true == pdp_wr_req_expected_ack) {
                cslDebug((50, "send wr rsp to pdp\x0A"));
                NV_NVDLA_mcif_base::mcif2pdp_wr_rsp.write(true);
            }
            break;
        case CDP_AXI_ID:
            cdp_wr_rsp_count_ ++;
            // Read a new reques id from fifo
            cdp_wr_req_expected_ack = cdp_wr_required_ack_fifo_->read();
            cslDebug((50, "NV_NVDLA_mcif::ext2cdp_wr_rsp_b_transport, cdp_wr_req_expected_ack=0x%x\x0A", cdp_wr_req_expected_ack));
            if (true == cdp_wr_req_expected_ack) {
                cslDebug((50, "send wr rsp to cdp\x0A"));
                NV_NVDLA_mcif_base::mcif2cdp_wr_rsp.write(true);
            }
            break;
        case RBK_AXI_ID:
            rbk_wr_rsp_count_ ++;
            // Read a new reques id from fifo
            rbk_wr_req_expected_ack = rbk_wr_required_ack_fifo_->read();
            cslDebug((50, "NV_NVDLA_mcif::ext2rbk_wr_rsp_b_transport, rbk_wr_req_expected_ack=0x%x\x0A", rbk_wr_req_expected_ack));
            if (true == rbk_wr_req_expected_ack) {
                cslDebug((50, "send wr rsp to rbk\x0A"));
                NV_NVDLA_mcif_base::mcif2rbk_wr_rsp.write(true);
            }
            break;

#pragma CTC SKIP
        default:
            FAIL(("NV_NVDLA_mcif::ext2mcif_wr_rsp_b_transport, unexpected AXI ID"));
#pragma CTC ENDSKIP
    }
    wait( SC_ZERO_TIME );
    tlm_gp.set_response_status(tlm::TLM_OK_RESPONSE);
}

void NV_NVDLA_mcif::ReadRequestArbiter() {
    bool bdma_ready, cdma_dat_ready, cdma_wt_ready, sdp_ready, pdp_ready, cdp_ready;
    bool rbk_ready, sdp_b_ready, sdp_n_ready, sdp_e_ready;
    while (true) {
        if (bdma_rd_req_payload_ == NULL) {
            bdma_rd_req_fifo_->nb_read(bdma_rd_req_payload_);
        }
        if (bdma_rd_req_payload_ != NULL) {
            int payload_size = (bdma_rd_req_payload_->gp.get_data_length());
            int atom_num = payload_size/MIN_BUS_WIDTH;
            if (credit_mcif2bdma_rd_rsp_fifo_ >= atom_num) {
                bdma_ready = true;
            } else {
                bdma_ready = false;
            }
        } else {
            bdma_ready = false;
        }
        if (cdma_dat_rd_req_payload_ == NULL) {
            cdma_dat_rd_req_fifo_->nb_read(cdma_dat_rd_req_payload_);
        }
        if (cdma_dat_rd_req_payload_ != NULL) {
            int payload_size = (cdma_dat_rd_req_payload_->gp.get_data_length());
            int atom_num = payload_size/MIN_BUS_WIDTH;
            if (credit_mcif2cdma_dat_rd_rsp_fifo_ >= atom_num) {
                cdma_dat_ready = true;
            } else {
                cdma_dat_ready = false;
            }
        } else {
            cdma_dat_ready = false;
        }
        
        if (cdma_wt_rd_req_payload_ == NULL) {
            cdma_wt_rd_req_fifo_->nb_read(cdma_wt_rd_req_payload_);
        }
        if (cdma_wt_rd_req_payload_ != NULL) {
            int payload_size = (cdma_wt_rd_req_payload_->gp.get_data_length());
            int atom_num = payload_size/MIN_BUS_WIDTH;
            if (credit_mcif2cdma_wt_rd_rsp_fifo_ >= atom_num) {
                cdma_wt_ready = true;
            } else {
                cdma_wt_ready = false;
            }
        } else {
            cdma_wt_ready = false;
        }

        if (sdp_rd_req_payload_ == NULL) {
            sdp_rd_req_fifo_->nb_read(sdp_rd_req_payload_);
        }
        if (sdp_rd_req_payload_ != NULL) {
            int payload_size = (sdp_rd_req_payload_->gp.get_data_length());
            int atom_num = payload_size/MIN_BUS_WIDTH;
            if (credit_mcif2sdp_rd_rsp_fifo_ >= atom_num) {
                sdp_ready = true;
            } else {
                sdp_ready = false;
            }
        } else {
            sdp_ready = false;
        }
        if (sdp_b_rd_req_payload_ == NULL) {
            sdp_b_rd_req_fifo_->nb_read(sdp_b_rd_req_payload_);
        }
        if (sdp_b_rd_req_payload_ != NULL) {
            int payload_size = (sdp_b_rd_req_payload_->gp.get_data_length());
            int atom_num = payload_size/MIN_BUS_WIDTH;
            if (credit_mcif2sdp_b_rd_rsp_fifo_ >= atom_num) {
                sdp_b_ready = true;
            } else {
                sdp_b_ready = false;
            }
        } else {
            sdp_b_ready = false;
        }
        if (sdp_n_rd_req_payload_ == NULL) {
            sdp_n_rd_req_fifo_->nb_read(sdp_n_rd_req_payload_);
        }
        if (sdp_n_rd_req_payload_ != NULL) {
            int payload_size = (sdp_n_rd_req_payload_->gp.get_data_length());
            int atom_num = payload_size/MIN_BUS_WIDTH;
            if (credit_mcif2sdp_n_rd_rsp_fifo_ >= atom_num) {
                sdp_n_ready = true;
            } else {
                sdp_n_ready = false;
            }
        } else {
            sdp_n_ready = false;
        }
        if (sdp_e_rd_req_payload_ == NULL) {
            sdp_e_rd_req_fifo_->nb_read(sdp_e_rd_req_payload_);
        }
        if (sdp_e_rd_req_payload_ != NULL) {
            int payload_size = (sdp_e_rd_req_payload_->gp.get_data_length());
            int atom_num = payload_size/MIN_BUS_WIDTH;
            if (credit_mcif2sdp_e_rd_rsp_fifo_ >= atom_num) {
                sdp_e_ready = true;
            } else {
                sdp_e_ready = false;
            }
        } else {
            sdp_e_ready = false;
        }
        if (rbk_rd_req_payload_ == NULL) {
            rbk_rd_req_fifo_->nb_read(rbk_rd_req_payload_);
        }
        if (rbk_rd_req_payload_ != NULL) {
            int payload_size = (rbk_rd_req_payload_->gp.get_data_length());
            int atom_num = payload_size/MIN_BUS_WIDTH;
            if (credit_mcif2rbk_rd_rsp_fifo_ >= atom_num) {
                rbk_ready = true;
            } else {
                rbk_ready = false;
            }
        } else {
            rbk_ready = false;
        }
        if (pdp_rd_req_payload_ == NULL) {
            pdp_rd_req_fifo_->nb_read(pdp_rd_req_payload_);
        }
        if (pdp_rd_req_payload_ != NULL) {
            int payload_size = (pdp_rd_req_payload_->gp.get_data_length());
            int atom_num = payload_size/MIN_BUS_WIDTH;
            if (credit_mcif2pdp_rd_rsp_fifo_ >= atom_num) {
                pdp_ready = true;
            } else {
                pdp_ready = false;
            }
        } else {
            pdp_ready = false;
        }
        if (cdp_rd_req_payload_ == NULL) {
            cdp_rd_req_fifo_->nb_read(cdp_rd_req_payload_);
        }
        if (cdp_rd_req_payload_ != NULL) {
            int payload_size = (cdp_rd_req_payload_->gp.get_data_length());
            int atom_num = payload_size/MIN_BUS_WIDTH;
            if (credit_mcif2cdp_rd_rsp_fifo_ >= atom_num) {
                cdp_ready = true;
            } else {
                cdp_ready = false;
            }
        } else {
            cdp_ready = false;
        }
        
        if( !cdma_dat_ready && !cdma_wt_ready && !bdma_ready && !sdp_ready &&
        !pdp_ready && !cdp_ready && !rbk_ready && !sdp_b_ready && !sdp_n_ready && !sdp_e_ready) {{
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, no pending request, waiting.\x0A"));
                wait();
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, get new request, wake up.\x0A"));
            }}

        // Get a FIFO write event, query dma read request FIFOs

        // For BDMA
        if (bdma_rd_req_payload_ != NULL) {
            uint8_t* axi_byte_enable_ptr = (bdma_rd_req_payload_->gp.get_byte_enable_ptr());
            int payload_size = bdma_rd_req_payload_->gp.get_data_length();
            int atom_num = 0;
            for (int i=0; i<payload_size/MIN_BUS_WIDTH; i++)
                atom_num += axi_byte_enable_ptr[i*MIN_BUS_WIDTH] == TLM_BYTE_ENABLED;
            if (credit_mcif2bdma_rd_rsp_fifo_ >= atom_num) {   // Same as bdma_ready
                credit_mcif2bdma_rd_rsp_fifo_ -= atom_num;
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, send read request, payload from bdma, begin, atom:%d, num_free:%d credit_mcif2bdma_rd_rsp_fifo_=%d.\x0A", atom_num, mcif2bdma_rd_rsp_fifo_->num_free(), credit_mcif2bdma_rd_rsp_fifo_));
                mcif2ext_rd_req->b_transport(bdma_rd_req_payload_->gp, axi_delay_);
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, send read request, bdma_rd_req_payload_ from bdma, end.\x0A"));
                delete bdma_rd_req_payload_;
                bdma_rd_req_payload_ = NULL;
            } else {
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, skip send read request from bdma\x0A"));
            }
        }
        // For SDP
        if (sdp_rd_req_payload_ != NULL) {
            uint8_t* axi_byte_enable_ptr = (sdp_rd_req_payload_->gp.get_byte_enable_ptr());
            int payload_size = sdp_rd_req_payload_->gp.get_data_length();
            int atom_num = 0;
            for (int i=0; i<payload_size/MIN_BUS_WIDTH; i++)
                atom_num += axi_byte_enable_ptr[i*MIN_BUS_WIDTH] == TLM_BYTE_ENABLED;
            if (credit_mcif2sdp_rd_rsp_fifo_ >= atom_num) {   // Same as sdp_ready
                credit_mcif2sdp_rd_rsp_fifo_ -= atom_num;
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, send read request, payload from sdp, begin, atom:%d, num_free:%d credit_mcif2sdp_rd_rsp_fifo_=%d.\x0A", atom_num, mcif2sdp_rd_rsp_fifo_->num_free(), credit_mcif2sdp_rd_rsp_fifo_));
                mcif2ext_rd_req->b_transport(sdp_rd_req_payload_->gp, axi_delay_);
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, send read request, sdp_rd_req_payload_ from sdp, end.\x0A"));
                delete sdp_rd_req_payload_;
                sdp_rd_req_payload_ = NULL;
            } else {
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, skip send read request from sdp\x0A"));
            }
        }
        // For PDP
        if (pdp_rd_req_payload_ != NULL) {
            uint8_t* axi_byte_enable_ptr = (pdp_rd_req_payload_->gp.get_byte_enable_ptr());
            int payload_size = pdp_rd_req_payload_->gp.get_data_length();
            int atom_num = 0;
            for (int i=0; i<payload_size/MIN_BUS_WIDTH; i++)
                atom_num += axi_byte_enable_ptr[i*MIN_BUS_WIDTH] == TLM_BYTE_ENABLED;
            if (credit_mcif2pdp_rd_rsp_fifo_ >= atom_num) {   // Same as pdp_ready
                credit_mcif2pdp_rd_rsp_fifo_ -= atom_num;
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, send read request, payload from pdp, begin, atom:%d, num_free:%d credit_mcif2pdp_rd_rsp_fifo_=%d.\x0A", atom_num, mcif2pdp_rd_rsp_fifo_->num_free(), credit_mcif2pdp_rd_rsp_fifo_));
                mcif2ext_rd_req->b_transport(pdp_rd_req_payload_->gp, axi_delay_);
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, send read request, pdp_rd_req_payload_ from pdp, end.\x0A"));
                delete pdp_rd_req_payload_;
                pdp_rd_req_payload_ = NULL;
            } else {
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, skip send read request from pdp\x0A"));
            }
        }
        // For CDP
        if (cdp_rd_req_payload_ != NULL) {
            uint8_t* axi_byte_enable_ptr = (cdp_rd_req_payload_->gp.get_byte_enable_ptr());
            int payload_size = cdp_rd_req_payload_->gp.get_data_length();
            int atom_num = 0;
            for (int i=0; i<payload_size/MIN_BUS_WIDTH; i++)
                atom_num += axi_byte_enable_ptr[i*MIN_BUS_WIDTH] == TLM_BYTE_ENABLED;
            if (credit_mcif2cdp_rd_rsp_fifo_ >= atom_num) {   // Same as cdp_ready
                credit_mcif2cdp_rd_rsp_fifo_ -= atom_num;
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, send read request, payload from cdp, begin, atom:%d, num_free:%d credit_mcif2cdp_rd_rsp_fifo_=%d.\x0A", atom_num, mcif2cdp_rd_rsp_fifo_->num_free(), credit_mcif2cdp_rd_rsp_fifo_));
                mcif2ext_rd_req->b_transport(cdp_rd_req_payload_->gp, axi_delay_);
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, send read request, cdp_rd_req_payload_ from cdp, end.\x0A"));
                delete cdp_rd_req_payload_;
                cdp_rd_req_payload_ = NULL;
            } else {
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, skip send read request from cdp\x0A"));
            }
        }
        // For RBK
        if (rbk_rd_req_payload_ != NULL) {
            uint8_t* axi_byte_enable_ptr = (rbk_rd_req_payload_->gp.get_byte_enable_ptr());
            int payload_size = rbk_rd_req_payload_->gp.get_data_length();
            int atom_num = 0;
            for (int i=0; i<payload_size/MIN_BUS_WIDTH; i++)
                atom_num += axi_byte_enable_ptr[i*MIN_BUS_WIDTH] == TLM_BYTE_ENABLED;
            if (credit_mcif2rbk_rd_rsp_fifo_ >= atom_num) {   // Same as rbk_ready
                credit_mcif2rbk_rd_rsp_fifo_ -= atom_num;
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, send read request, payload from rbk, begin, atom:%d, num_free:%d credit_mcif2rbk_rd_rsp_fifo_=%d.\x0A", atom_num, mcif2rbk_rd_rsp_fifo_->num_free(), credit_mcif2rbk_rd_rsp_fifo_));
                mcif2ext_rd_req->b_transport(rbk_rd_req_payload_->gp, axi_delay_);
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, send read request, rbk_rd_req_payload_ from rbk, end.\x0A"));
                delete rbk_rd_req_payload_;
                rbk_rd_req_payload_ = NULL;
            } else {
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, skip send read request from rbk\x0A"));
            }
        }
        // For SDP_B
        if (sdp_b_rd_req_payload_ != NULL) {
            uint8_t* axi_byte_enable_ptr = (sdp_b_rd_req_payload_->gp.get_byte_enable_ptr());
            int payload_size = sdp_b_rd_req_payload_->gp.get_data_length();
            int atom_num = 0;
            for (int i=0; i<payload_size/MIN_BUS_WIDTH; i++)
                atom_num += axi_byte_enable_ptr[i*MIN_BUS_WIDTH] == TLM_BYTE_ENABLED;
            if (credit_mcif2sdp_b_rd_rsp_fifo_ >= atom_num) {   // Same as sdp_b_ready
                credit_mcif2sdp_b_rd_rsp_fifo_ -= atom_num;
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, send read request, payload from sdp_b, begin, atom:%d, num_free:%d credit_mcif2sdp_b_rd_rsp_fifo_=%d.\x0A", atom_num, mcif2sdp_b_rd_rsp_fifo_->num_free(), credit_mcif2sdp_b_rd_rsp_fifo_));
                mcif2ext_rd_req->b_transport(sdp_b_rd_req_payload_->gp, axi_delay_);
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, send read request, sdp_b_rd_req_payload_ from sdp_b, end.\x0A"));
                delete sdp_b_rd_req_payload_;
                sdp_b_rd_req_payload_ = NULL;
            } else {
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, skip send read request from sdp_b\x0A"));
            }
        }
        // For SDP_N
        if (sdp_n_rd_req_payload_ != NULL) {
            uint8_t* axi_byte_enable_ptr = (sdp_n_rd_req_payload_->gp.get_byte_enable_ptr());
            int payload_size = sdp_n_rd_req_payload_->gp.get_data_length();
            int atom_num = 0;
            for (int i=0; i<payload_size/MIN_BUS_WIDTH; i++)
                atom_num += axi_byte_enable_ptr[i*MIN_BUS_WIDTH] == TLM_BYTE_ENABLED;
            if (credit_mcif2sdp_n_rd_rsp_fifo_ >= atom_num) {   // Same as sdp_n_ready
                credit_mcif2sdp_n_rd_rsp_fifo_ -= atom_num;
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, send read request, payload from sdp_n, begin, atom:%d, num_free:%d credit_mcif2sdp_n_rd_rsp_fifo_=%d.\x0A", atom_num, mcif2sdp_n_rd_rsp_fifo_->num_free(), credit_mcif2sdp_n_rd_rsp_fifo_));
                mcif2ext_rd_req->b_transport(sdp_n_rd_req_payload_->gp, axi_delay_);
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, send read request, sdp_n_rd_req_payload_ from sdp_n, end.\x0A"));
                delete sdp_n_rd_req_payload_;
                sdp_n_rd_req_payload_ = NULL;
            } else {
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, skip send read request from sdp_n\x0A"));
            }
        }
        // For SDP_E
        if (sdp_e_rd_req_payload_ != NULL) {
            uint8_t* axi_byte_enable_ptr = (sdp_e_rd_req_payload_->gp.get_byte_enable_ptr());
            int payload_size = sdp_e_rd_req_payload_->gp.get_data_length();
            int atom_num = 0;
            for (int i=0; i<payload_size/MIN_BUS_WIDTH; i++)
                atom_num += axi_byte_enable_ptr[i*MIN_BUS_WIDTH] == TLM_BYTE_ENABLED;
            if (credit_mcif2sdp_e_rd_rsp_fifo_ >= atom_num) {   // Same as sdp_e_ready
                credit_mcif2sdp_e_rd_rsp_fifo_ -= atom_num;
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, send read request, payload from sdp_e, begin, atom:%d, num_free:%d credit_mcif2sdp_e_rd_rsp_fifo_=%d.\x0A", atom_num, mcif2sdp_e_rd_rsp_fifo_->num_free(), credit_mcif2sdp_e_rd_rsp_fifo_));
                mcif2ext_rd_req->b_transport(sdp_e_rd_req_payload_->gp, axi_delay_);
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, send read request, sdp_e_rd_req_payload_ from sdp_e, end.\x0A"));
                delete sdp_e_rd_req_payload_;
                sdp_e_rd_req_payload_ = NULL;
            } else {
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, skip send read request from sdp_e\x0A"));
            }
        }
        // For CDMA_DAT
        if (cdma_dat_rd_req_payload_ != NULL) {
            uint8_t* axi_byte_enable_ptr = (cdma_dat_rd_req_payload_->gp.get_byte_enable_ptr());
            int payload_size = cdma_dat_rd_req_payload_->gp.get_data_length();
            int atom_num = 0;
            for (int i=0; i<payload_size/MIN_BUS_WIDTH; i++)
                atom_num += axi_byte_enable_ptr[i*MIN_BUS_WIDTH] == TLM_BYTE_ENABLED;
            if (credit_mcif2cdma_dat_rd_rsp_fifo_ >= atom_num) {   // Same as cdma_dat_ready
                credit_mcif2cdma_dat_rd_rsp_fifo_ -= atom_num;
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, send read request, payload from cdma_dat, begin, atom:%d, num_free:%d credit_mcif2cdma_dat_rd_rsp_fifo_=%d.\x0A", atom_num, mcif2cdma_dat_rd_rsp_fifo_->num_free(), credit_mcif2cdma_dat_rd_rsp_fifo_));
                mcif2ext_rd_req->b_transport(cdma_dat_rd_req_payload_->gp, axi_delay_);
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, send read request, cdma_dat_rd_req_payload_ from cdma_dat, end.\x0A"));
                delete cdma_dat_rd_req_payload_;
                cdma_dat_rd_req_payload_ = NULL;
            } else {
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, skip send read request from cdma_dat\x0A"));
            }
        }
        // For CDMA_WT
        if (cdma_wt_rd_req_payload_ != NULL) {
            uint8_t* axi_byte_enable_ptr = (cdma_wt_rd_req_payload_->gp.get_byte_enable_ptr());
            int payload_size = cdma_wt_rd_req_payload_->gp.get_data_length();
            int atom_num = 0;
            for (int i=0; i<payload_size/MIN_BUS_WIDTH; i++)
                atom_num += axi_byte_enable_ptr[i*MIN_BUS_WIDTH] == TLM_BYTE_ENABLED;
            if (credit_mcif2cdma_wt_rd_rsp_fifo_ >= atom_num) {   // Same as cdma_wt_ready
                credit_mcif2cdma_wt_rd_rsp_fifo_ -= atom_num;
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, send read request, payload from cdma_wt, begin, atom:%d, num_free:%d credit_mcif2cdma_wt_rd_rsp_fifo_=%d.\x0A", atom_num, mcif2cdma_wt_rd_rsp_fifo_->num_free(), credit_mcif2cdma_wt_rd_rsp_fifo_));
                mcif2ext_rd_req->b_transport(cdma_wt_rd_req_payload_->gp, axi_delay_);
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, send read request, cdma_wt_rd_req_payload_ from cdma_wt, end.\x0A"));
                delete cdma_wt_rd_req_payload_;
                cdma_wt_rd_req_payload_ = NULL;
            } else {
                cslDebug((50, "NV_NVDLA_mcif::ReadRequestArbiter, skip send read request from cdma_wt\x0A"));
            }
        }

        // delete payload; // Release memory
    }
}

void NV_NVDLA_mcif::WriteRequestArbiter() {
    dla_b_transport_payload *payload;
    while (true) {
        cslDebug((50, "Calling WriteRequestArbiter\x0A"));
        if((bdma_wr_req_fifo_->num_available()==0) && (rbk_wr_req_fifo_->num_available()==0) && (sdp_wr_req_fifo_->num_available()==0) && (pdp_wr_req_fifo_->num_available()==0) && (cdp_wr_req_fifo_->num_available()==0))
            wait();

        // Get a FIFO write event, query dma read request FIFOs

        // For BDMA
        if (bdma_wr_req_fifo_->nb_read(payload)) {
            cslDebug((50, "NV_NVDLA_mcif::WriteRequestArbiter, send write request, payload from bdma.\x0A"));
            mcif2ext_wr_req->b_transport(payload->gp, axi_delay_);
            delete payload;
        }
        // For SDP
        if (sdp_wr_req_fifo_->nb_read(payload)) {
            cslDebug((50, "NV_NVDLA_mcif::WriteRequestArbiter, send write request, payload from sdp.\x0A"));
            mcif2ext_wr_req->b_transport(payload->gp, axi_delay_);
            delete payload;
        }
        // For PDP
        if (pdp_wr_req_fifo_->nb_read(payload)) {
            cslDebug((50, "NV_NVDLA_mcif::WriteRequestArbiter, send write request, payload from pdp.\x0A"));
            mcif2ext_wr_req->b_transport(payload->gp, axi_delay_);
            delete payload;
        }
        // For CDP
        if (cdp_wr_req_fifo_->nb_read(payload)) {
            cslDebug((50, "NV_NVDLA_mcif::WriteRequestArbiter, send write request, payload from cdp.\x0A"));
            mcif2ext_wr_req->b_transport(payload->gp, axi_delay_);
            delete payload;
        }
        // For RBK
        if (rbk_wr_req_fifo_->nb_read(payload)) {
            cslDebug((50, "NV_NVDLA_mcif::WriteRequestArbiter, send write request, payload from rbk.\x0A"));
            mcif2ext_wr_req->b_transport(payload->gp, axi_delay_);
            delete payload;
        }

        // delete payload; // Release memory
    }
}

void NV_NVDLA_mcif::Reset() {
    // Clear register and internal states

    // For BDMA
    bdma_wr_req_count_ = 0;
    bdma_wr_rsp_count_ = 0;
    bdma_wr_req_ack_is_got_ = false;
    has_bdma_onging_wr_req_ = false;
    // Reset write response wires
    // mcif2bdma_wr_rsp.initialize(false);
    // For SDP
    sdp_wr_req_count_ = 0;
    sdp_wr_rsp_count_ = 0;
    sdp_wr_req_ack_is_got_ = false;
    has_sdp_onging_wr_req_ = false;
    // Reset write response wires
    // mcif2sdp_wr_rsp.initialize(false);
    // For PDP
    pdp_wr_req_count_ = 0;
    pdp_wr_rsp_count_ = 0;
    pdp_wr_req_ack_is_got_ = false;
    has_pdp_onging_wr_req_ = false;
    // Reset write response wires
    // mcif2pdp_wr_rsp.initialize(false);
    // For CDP
    cdp_wr_req_count_ = 0;
    cdp_wr_rsp_count_ = 0;
    cdp_wr_req_ack_is_got_ = false;
    has_cdp_onging_wr_req_ = false;
    // Reset write response wires
    // mcif2cdp_wr_rsp.initialize(false);
    // For RBK
    rbk_wr_req_count_ = 0;
    rbk_wr_rsp_count_ = 0;
    rbk_wr_req_ack_is_got_ = false;
    has_rbk_onging_wr_req_ = false;
    // Reset write response wires
    // mcif2rbk_wr_rsp.initialize(false);

    // mcif2ext_wr_req_payload = NULL;
    // mcif2ext_rd_req_payload = NULL;
}

//NV_NVDLA_mcif * NV_NVDLA_mcifCon(sc_module_name name, uint8_t nvdla_id_in)
//{
//    return new NV_NVDLA_mcif(name, nvdla_id_in);
//}
