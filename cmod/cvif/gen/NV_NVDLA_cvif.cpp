// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cvif.cpp

#include <algorithm>
#include <iomanip>
#include "NV_NVDLA_cvif.h"
#include "arnvdla.uh"
#include "arnvdla.h"
#include "cmacros.uh"
#include "math.h"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>


USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace std;
using namespace tlm;
using namespace sc_core;

NV_NVDLA_cvif::NV_NVDLA_cvif( sc_module_name module_name, bool headless_ntb_env_in, uint8_t nvdla_id_in):
    NV_NVDLA_cvif_base(module_name),
    headless_ntb_env(headless_ntb_env_in),
    nvdla_id(nvdla_id_in),
    // Delay setup
    cvif2ext_wr_req ("cvif2ext_wr_req"),
    cvif2ext_rd_req ("cvif2ext_rd_req"),
    ext2cvif_wr_rsp ("ext2cvif_wr_rsp"),
    ext2cvif_rd_rsp ("ext2cvif_rd_rsp"),
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
    cvif2bdma_rd_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*2*5*FIFO_NUM_FACTOR);              //1024 atoms
    credit_cvif2bdma_rd_rsp_fifo_ = 8192*2*5*FIFO_NUM_FACTOR;   // Should be same as the depth of cvif2bdma_rd_rsp_fifo_
    bdma2cvif_rd_req_atom_num_fifo_ = new sc_core::sc_fifo <uint32_t> (8192*2*5*FIFO_NUM_FACTOR);     //1024 outstanding read requests
    bdma_rd_req_payload_ = NULL;
    // Request fifos
    #undef FIFO_NUM_FACTOR
    #define FIFO_NUM_FACTOR 1
    sdp_rd_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (8192*2*5*FIFO_NUM_FACTOR);
    sdp_rd_atom_enable_fifo_  = new sc_core::sc_fifo    <bool> (8192*4*5 * FIFO_NUM_FACTOR);
    cvif2sdp_rd_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*2*5*FIFO_NUM_FACTOR);              //1024 atoms
    credit_cvif2sdp_rd_rsp_fifo_ = 8192*2*5*FIFO_NUM_FACTOR;   // Should be same as the depth of cvif2sdp_rd_rsp_fifo_
    sdp2cvif_rd_req_atom_num_fifo_ = new sc_core::sc_fifo <uint32_t> (8192*2*5*FIFO_NUM_FACTOR);     //1024 outstanding read requests
    sdp_rd_req_payload_ = NULL;
    // Request fifos
    #undef FIFO_NUM_FACTOR
    #define FIFO_NUM_FACTOR 1
    pdp_rd_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (8192*2*5*FIFO_NUM_FACTOR);
    pdp_rd_atom_enable_fifo_  = new sc_core::sc_fifo    <bool> (8192*4*5 * FIFO_NUM_FACTOR);
    cvif2pdp_rd_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*2*5*FIFO_NUM_FACTOR);              //1024 atoms
    credit_cvif2pdp_rd_rsp_fifo_ = 8192*2*5*FIFO_NUM_FACTOR;   // Should be same as the depth of cvif2pdp_rd_rsp_fifo_
    pdp2cvif_rd_req_atom_num_fifo_ = new sc_core::sc_fifo <uint32_t> (8192*2*5*FIFO_NUM_FACTOR);     //1024 outstanding read requests
    pdp_rd_req_payload_ = NULL;
    // Request fifos
    #undef FIFO_NUM_FACTOR
    #define FIFO_NUM_FACTOR 1
    cdp_rd_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (8192*2*5*FIFO_NUM_FACTOR);
    cdp_rd_atom_enable_fifo_  = new sc_core::sc_fifo    <bool> (8192*4*5 * FIFO_NUM_FACTOR);
    cvif2cdp_rd_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*2*5*FIFO_NUM_FACTOR);              //1024 atoms
    credit_cvif2cdp_rd_rsp_fifo_ = 8192*2*5*FIFO_NUM_FACTOR;   // Should be same as the depth of cvif2cdp_rd_rsp_fifo_
    cdp2cvif_rd_req_atom_num_fifo_ = new sc_core::sc_fifo <uint32_t> (8192*2*5*FIFO_NUM_FACTOR);     //1024 outstanding read requests
    cdp_rd_req_payload_ = NULL;
    // Request fifos
    #undef FIFO_NUM_FACTOR
    #define FIFO_NUM_FACTOR 1
    rbk_rd_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (8192*2*5*FIFO_NUM_FACTOR);
    rbk_rd_atom_enable_fifo_  = new sc_core::sc_fifo    <bool> (8192*4*5 * FIFO_NUM_FACTOR);
    cvif2rbk_rd_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*2*5*FIFO_NUM_FACTOR);              //1024 atoms
    credit_cvif2rbk_rd_rsp_fifo_ = 8192*2*5*FIFO_NUM_FACTOR;   // Should be same as the depth of cvif2rbk_rd_rsp_fifo_
    rbk2cvif_rd_req_atom_num_fifo_ = new sc_core::sc_fifo <uint32_t> (8192*2*5*FIFO_NUM_FACTOR);     //1024 outstanding read requests
    rbk_rd_req_payload_ = NULL;
    // Request fifos
    #undef FIFO_NUM_FACTOR
    #define FIFO_NUM_FACTOR 1
    sdp_b_rd_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (8192*2*5*FIFO_NUM_FACTOR);
    sdp_b_rd_atom_enable_fifo_  = new sc_core::sc_fifo    <bool> (8192*4*5 * FIFO_NUM_FACTOR);
    cvif2sdp_b_rd_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*2*5*FIFO_NUM_FACTOR);              //1024 atoms
    credit_cvif2sdp_b_rd_rsp_fifo_ = 8192*2*5*FIFO_NUM_FACTOR;   // Should be same as the depth of cvif2sdp_b_rd_rsp_fifo_
    sdp_b2cvif_rd_req_atom_num_fifo_ = new sc_core::sc_fifo <uint32_t> (8192*2*5*FIFO_NUM_FACTOR);     //1024 outstanding read requests
    sdp_b_rd_req_payload_ = NULL;
    // Request fifos
    #undef FIFO_NUM_FACTOR
    #define FIFO_NUM_FACTOR 1
    sdp_n_rd_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (8192*2*5*FIFO_NUM_FACTOR);
    sdp_n_rd_atom_enable_fifo_  = new sc_core::sc_fifo    <bool> (8192*4*5 * FIFO_NUM_FACTOR);
    cvif2sdp_n_rd_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*2*5*FIFO_NUM_FACTOR);              //1024 atoms
    credit_cvif2sdp_n_rd_rsp_fifo_ = 8192*2*5*FIFO_NUM_FACTOR;   // Should be same as the depth of cvif2sdp_n_rd_rsp_fifo_
    sdp_n2cvif_rd_req_atom_num_fifo_ = new sc_core::sc_fifo <uint32_t> (8192*2*5*FIFO_NUM_FACTOR);     //1024 outstanding read requests
    sdp_n_rd_req_payload_ = NULL;
    // Request fifos
    #undef FIFO_NUM_FACTOR
    #define FIFO_NUM_FACTOR 1
    sdp_e_rd_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (8192*2*5*FIFO_NUM_FACTOR);
    sdp_e_rd_atom_enable_fifo_  = new sc_core::sc_fifo    <bool> (8192*4*5 * FIFO_NUM_FACTOR);
    cvif2sdp_e_rd_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*2*5*FIFO_NUM_FACTOR);              //1024 atoms
    credit_cvif2sdp_e_rd_rsp_fifo_ = 8192*2*5*FIFO_NUM_FACTOR;   // Should be same as the depth of cvif2sdp_e_rd_rsp_fifo_
    sdp_e2cvif_rd_req_atom_num_fifo_ = new sc_core::sc_fifo <uint32_t> (8192*2*5*FIFO_NUM_FACTOR);     //1024 outstanding read requests
    sdp_e_rd_req_payload_ = NULL;
    // Request fifos
    #undef FIFO_NUM_FACTOR
    #define FIFO_NUM_FACTOR 1
    cdma_dat_rd_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (8192*2*5*FIFO_NUM_FACTOR);
    cdma_dat_rd_atom_enable_fifo_  = new sc_core::sc_fifo    <bool> (8192*4*5 * FIFO_NUM_FACTOR);
    cvif2cdma_dat_rd_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*2*5*FIFO_NUM_FACTOR);              //1024 atoms
    credit_cvif2cdma_dat_rd_rsp_fifo_ = 8192*2*5*FIFO_NUM_FACTOR;   // Should be same as the depth of cvif2cdma_dat_rd_rsp_fifo_
    cdma_dat2cvif_rd_req_atom_num_fifo_ = new sc_core::sc_fifo <uint32_t> (8192*2*5*FIFO_NUM_FACTOR);     //1024 outstanding read requests
    cdma_dat_rd_req_payload_ = NULL;
    // Request fifos
    #undef FIFO_NUM_FACTOR
    #define FIFO_NUM_FACTOR 1
    cdma_wt_rd_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (8192*2*5*FIFO_NUM_FACTOR);
    cdma_wt_rd_atom_enable_fifo_  = new sc_core::sc_fifo    <bool> (8192*4*5 * FIFO_NUM_FACTOR);
    cvif2cdma_wt_rd_rsp_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*2*5*FIFO_NUM_FACTOR);              //1024 atoms
    credit_cvif2cdma_wt_rd_rsp_fifo_ = 8192*2*5*FIFO_NUM_FACTOR;   // Should be same as the depth of cvif2cdma_wt_rd_rsp_fifo_
    cdma_wt2cvif_rd_req_atom_num_fifo_ = new sc_core::sc_fifo <uint32_t> (8192*2*5*FIFO_NUM_FACTOR);     //1024 outstanding read requests
    cdma_wt_rd_req_payload_ = NULL;

    // Write request fifo
    bdma_wr_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (4096*FIFO_NUM_FACTOR); //FIXME: if it's too small, there will be issue
    // write response ack control
    // FIXME(skip-t19): the count is set to 8192. Not sure the fifo will overflow.
    bdma_wr_required_ack_fifo_ = new sc_core::sc_fifo    <bool> (8192*5*FIFO_NUM_FACTOR);
    bdma2cvif_wr_cmd_fifo_ = new sc_core::sc_fifo <client_cvif_wr_req_t*> (8192*5*FIFO_NUM_FACTOR);    //256 atoms
    bdma2cvif_wr_data_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*5*FIFO_NUM_FACTOR);                //256 atoms
    // Write request fifo
    sdp_wr_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (4096*FIFO_NUM_FACTOR); //FIXME: if it's too small, there will be issue
    // write response ack control
    // FIXME(skip-t19): the count is set to 8192. Not sure the fifo will overflow.
    sdp_wr_required_ack_fifo_ = new sc_core::sc_fifo    <bool> (8192*5*FIFO_NUM_FACTOR);
    sdp2cvif_wr_cmd_fifo_ = new sc_core::sc_fifo <client_cvif_wr_req_t*> (8192*5*FIFO_NUM_FACTOR);    //256 atoms
    sdp2cvif_wr_data_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*5*FIFO_NUM_FACTOR);                //256 atoms
    // Write request fifo
    pdp_wr_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (4096*FIFO_NUM_FACTOR); //FIXME: if it's too small, there will be issue
    // write response ack control
    // FIXME(skip-t19): the count is set to 8192. Not sure the fifo will overflow.
    pdp_wr_required_ack_fifo_ = new sc_core::sc_fifo    <bool> (8192*5*FIFO_NUM_FACTOR);
    pdp2cvif_wr_cmd_fifo_ = new sc_core::sc_fifo <client_cvif_wr_req_t*> (8192*5*FIFO_NUM_FACTOR);    //256 atoms
    pdp2cvif_wr_data_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*5*FIFO_NUM_FACTOR);                //256 atoms
    // Write request fifo
    cdp_wr_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (4096*FIFO_NUM_FACTOR); //FIXME: if it's too small, there will be issue
    // write response ack control
    // FIXME(skip-t19): the count is set to 8192. Not sure the fifo will overflow.
    cdp_wr_required_ack_fifo_ = new sc_core::sc_fifo    <bool> (8192*5*FIFO_NUM_FACTOR);
    cdp2cvif_wr_cmd_fifo_ = new sc_core::sc_fifo <client_cvif_wr_req_t*> (8192*5*FIFO_NUM_FACTOR);    //256 atoms
    cdp2cvif_wr_data_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*5*FIFO_NUM_FACTOR);                //256 atoms
    // Write request fifo
    rbk_wr_req_fifo_ = new sc_core::sc_fifo <dla_b_transport_payload*> (4096*FIFO_NUM_FACTOR); //FIXME: if it's too small, there will be issue
    // write response ack control
    // FIXME(skip-t19): the count is set to 8192. Not sure the fifo will overflow.
    rbk_wr_required_ack_fifo_ = new sc_core::sc_fifo    <bool> (8192*5*FIFO_NUM_FACTOR);
    rbk2cvif_wr_cmd_fifo_ = new sc_core::sc_fifo <client_cvif_wr_req_t*> (8192*5*FIFO_NUM_FACTOR);    //256 atoms
    rbk2cvif_wr_data_fifo_ = new sc_core::sc_fifo <uint8_t*> (8192*5*FIFO_NUM_FACTOR);                //256 atoms

    
    // Register functions for AXI target sockets
    this->ext2cvif_wr_rsp.register_b_transport(this, &NV_NVDLA_cvif::ext2cvif_wr_rsp_b_transport);
    this->ext2cvif_rd_rsp.register_b_transport(this, &NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport);

    // Reset
    Reset();

    // THREAD

    SC_THREAD(ReadRequestArbiter)
    sensitive  << bdma_rd_req_fifo_->data_written_event()  << sdp_rd_req_fifo_->data_written_event()  << pdp_rd_req_fifo_->data_written_event()  << cdp_rd_req_fifo_->data_written_event()  << rbk_rd_req_fifo_->data_written_event()  << sdp_b_rd_req_fifo_->data_written_event()  << sdp_n_rd_req_fifo_->data_written_event()  << sdp_e_rd_req_fifo_->data_written_event()  << cdma_dat_rd_req_fifo_->data_written_event()  << cdma_wt_rd_req_fifo_->data_written_event()  << cvif2bdma_rd_rsp_fifo_->data_read_event()  << cvif2sdp_rd_rsp_fifo_->data_read_event()  << cvif2pdp_rd_rsp_fifo_->data_read_event()  << cvif2cdp_rd_rsp_fifo_->data_read_event()  << cvif2rbk_rd_rsp_fifo_->data_read_event()  << cvif2sdp_b_rd_rsp_fifo_->data_read_event()  << cvif2sdp_n_rd_rsp_fifo_->data_read_event()  << cvif2sdp_e_rd_rsp_fifo_->data_read_event()  << cvif2cdma_dat_rd_rsp_fifo_->data_read_event()  << cvif2cdma_wt_rd_rsp_fifo_->data_read_event()  ;

    SC_THREAD(WriteRequestArbiter)
    sensitive  << bdma_wr_req_fifo_->data_written_event()  << sdp_wr_req_fifo_->data_written_event()  << pdp_wr_req_fifo_->data_written_event()  << cdp_wr_req_fifo_->data_written_event()  << rbk_wr_req_fifo_->data_written_event()  ;




        SC_THREAD(ReadResp_cvif2bdma);

        SC_THREAD(ReadResp_cvif2sdp);

        SC_THREAD(ReadResp_cvif2pdp);

        SC_THREAD(ReadResp_cvif2cdp);

        SC_THREAD(ReadResp_cvif2rbk);

        SC_THREAD(ReadResp_cvif2sdp_b);

        SC_THREAD(ReadResp_cvif2sdp_n);

        SC_THREAD(ReadResp_cvif2sdp_e);

        SC_THREAD(ReadResp_cvif2cdma_dat);

        SC_THREAD(ReadResp_cvif2cdma_wt);


        SC_THREAD(WriteRequest_bdma2cvif);

        SC_THREAD(WriteRequest_sdp2cvif);

        SC_THREAD(WriteRequest_pdp2cvif);

        SC_THREAD(WriteRequest_cdp2cvif);

        SC_THREAD(WriteRequest_rbk2cvif);

}

#pragma CTC SKIP
NV_NVDLA_cvif::~NV_NVDLA_cvif() {

    // Read related pointers
    if( bdma_rd_req_fifo_ )             delete bdma_rd_req_fifo_;
        if( cvif2bdma_rd_rsp_fifo_ )   delete cvif2bdma_rd_rsp_fifo_;
    if( sdp_rd_req_fifo_ )             delete sdp_rd_req_fifo_;
        if( cvif2sdp_rd_rsp_fifo_ )   delete cvif2sdp_rd_rsp_fifo_;
    if( pdp_rd_req_fifo_ )             delete pdp_rd_req_fifo_;
        if( cvif2pdp_rd_rsp_fifo_ )   delete cvif2pdp_rd_rsp_fifo_;
    if( cdp_rd_req_fifo_ )             delete cdp_rd_req_fifo_;
        if( cvif2cdp_rd_rsp_fifo_ )   delete cvif2cdp_rd_rsp_fifo_;
    if( rbk_rd_req_fifo_ )             delete rbk_rd_req_fifo_;
        if( cvif2rbk_rd_rsp_fifo_ )   delete cvif2rbk_rd_rsp_fifo_;
    if( sdp_b_rd_req_fifo_ )             delete sdp_b_rd_req_fifo_;
        if( cvif2sdp_b_rd_rsp_fifo_ )   delete cvif2sdp_b_rd_rsp_fifo_;
    if( sdp_n_rd_req_fifo_ )             delete sdp_n_rd_req_fifo_;
        if( cvif2sdp_n_rd_rsp_fifo_ )   delete cvif2sdp_n_rd_rsp_fifo_;
    if( sdp_e_rd_req_fifo_ )             delete sdp_e_rd_req_fifo_;
        if( cvif2sdp_e_rd_rsp_fifo_ )   delete cvif2sdp_e_rd_rsp_fifo_;
    if( cdma_dat_rd_req_fifo_ )             delete cdma_dat_rd_req_fifo_;
        if( cvif2cdma_dat_rd_rsp_fifo_ )   delete cvif2cdma_dat_rd_rsp_fifo_;
    if( cdma_wt_rd_req_fifo_ )             delete cdma_wt_rd_req_fifo_;
        if( cvif2cdma_wt_rd_rsp_fifo_ )   delete cvif2cdma_wt_rd_rsp_fifo_;

    // Write related pointers
    if( bdma_wr_req_fifo_ )             delete bdma_wr_req_fifo_;
    if( bdma_wr_required_ack_fifo_ )    delete bdma_wr_required_ack_fifo_;
    if( bdma_rd_atom_enable_fifo_ )     delete bdma_rd_atom_enable_fifo_;
    if( bdma2cvif_wr_cmd_fifo_ )        delete bdma2cvif_wr_cmd_fifo_;
    if( bdma2cvif_wr_data_fifo_ )       delete bdma2cvif_wr_data_fifo_;
    if( sdp_wr_req_fifo_ )             delete sdp_wr_req_fifo_;
    if( sdp_wr_required_ack_fifo_ )    delete sdp_wr_required_ack_fifo_;
    if( sdp_rd_atom_enable_fifo_ )     delete sdp_rd_atom_enable_fifo_;
    if( sdp2cvif_wr_cmd_fifo_ )        delete sdp2cvif_wr_cmd_fifo_;
    if( sdp2cvif_wr_data_fifo_ )       delete sdp2cvif_wr_data_fifo_;
    if( pdp_wr_req_fifo_ )             delete pdp_wr_req_fifo_;
    if( pdp_wr_required_ack_fifo_ )    delete pdp_wr_required_ack_fifo_;
    if( pdp_rd_atom_enable_fifo_ )     delete pdp_rd_atom_enable_fifo_;
    if( pdp2cvif_wr_cmd_fifo_ )        delete pdp2cvif_wr_cmd_fifo_;
    if( pdp2cvif_wr_data_fifo_ )       delete pdp2cvif_wr_data_fifo_;
    if( cdp_wr_req_fifo_ )             delete cdp_wr_req_fifo_;
    if( cdp_wr_required_ack_fifo_ )    delete cdp_wr_required_ack_fifo_;
    if( cdp_rd_atom_enable_fifo_ )     delete cdp_rd_atom_enable_fifo_;
    if( cdp2cvif_wr_cmd_fifo_ )        delete cdp2cvif_wr_cmd_fifo_;
    if( cdp2cvif_wr_data_fifo_ )       delete cdp2cvif_wr_data_fifo_;
    if( rbk_wr_req_fifo_ )             delete rbk_wr_req_fifo_;
    if( rbk_wr_required_ack_fifo_ )    delete rbk_wr_required_ack_fifo_;
    if( rbk_rd_atom_enable_fifo_ )     delete rbk_rd_atom_enable_fifo_;
    if( rbk2cvif_wr_cmd_fifo_ )        delete rbk2cvif_wr_cmd_fifo_;
    if( rbk2cvif_wr_data_fifo_ )       delete rbk2cvif_wr_data_fifo_;

}
#pragma CTC ENDSKIP


// DMA read request target sockets

void NV_NVDLA_cvif::bdma2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    // DMA request size unit is 32 bytes
    uint64_t base_addr;
    uint64_t first_base_addr;
    uint64_t last_base_addr;
    uint64_t cur_address;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_base_64byte_align;
    bool     is_rear_64byte_align;
    bool     is_read=true;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    dla_b_transport_payload *bt_payload;

    payload_addr = payload->pd.dma_read_cmd.addr;
    payload_size = (payload->pd.dma_read_cmd.size + 1) * DMA_TRANSACTION_ATOM_SIZE; //payload_size's max value is 2^13

    is_base_64byte_align = payload_addr%AXI_TRANSACTION_ATOM_SIZE == 0;
    first_base_addr = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B
    cur_address = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B

    is_rear_64byte_align = (payload_addr + payload_size) % AXI_TRANSACTION_ATOM_SIZE == 0;
    total_axi_size = payload_size + (is_base_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE) + (is_rear_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE);
    last_base_addr = first_base_addr + total_axi_size - AXI_TRANSACTION_ATOM_SIZE;
    cslDebug((30, "NV_NVDLA_cvif::bdma2cvif_rd_req_b_transport, first_base_addr=0x%lx last_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, last_base_addr, total_axi_size, payload_addr, payload_size));
    // if ( total_axi_size <= (first_base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) ) {
    //     last_base_addr = first_base_addr;
    // } else if ((first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE != 0) {
    //     if (total_axi_size >= (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE) {
    //         last_base_addr = first_base_addr + total_axi_size - (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE;
    //     } else {
    //         last_base_addr = first_base_addr;
    //     }
    // } else {
    //     if (total_axi_size >= CVIF_MAX_MEM_TRANSACTION_SIZE) {
    //         last_base_addr = first_base_addr + total_axi_size - CVIF_MAX_MEM_TRANSACTION_SIZE;
    //     } else {
    //         last_base_addr = first_base_addr;
    //     }
    // }

    base_addr = first_base_addr;

    // Push the number of atoms of the request
    // bdma2cvif_rd_req_atom_num_fifo_->write(total_axi_size/DMA_TRANSACTION_ATOM_SIZE);
    bdma2cvif_rd_req_atom_num_fifo_->write(payload_size/DMA_TRANSACTION_ATOM_SIZE);
    cslDebug((50, "NV_NVDLA_cvif::bdma2cvif_rd_req_b_transport, write 0x%x to bdma2cvif_rd_req_atom_num_fifo_.\x0A", payload_size/DMA_TRANSACTION_ATOM_SIZE));

    //Split dma request to axi requests
    cslDebug((50, "NV_NVDLA_cvif::bdma2cvif_rd_req_b_transport, before spliting DMA transaction\x0A"));
    while(cur_address <= last_base_addr) {
        base_addr    = cur_address;
        size_in_byte = AXI_TRANSACTION_ATOM_SIZE;
        cslDebug((50, "NV_NVDLA_cvif::bdma2cvif_rd_req_b_transport, prepare AXI transaction for address: 0x%lx\x0A", base_addr));
        // base_addr should be aligned to 64B
        // size_in_byte should be multiple of 64
        // if the data size required by dma mster is 32B, MCIF will drop the extra 32B when AXI returns
        // size_in_byte = total_axi_size > (CVIF_MAX_MEM_TRANSACTION_SIZE) ? CVIF_MAX_MEM_TRANSACTION_SIZE : total_axi_size;
        // size_in_byte = (total_axi_size - base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) < (CVIF_MAX_MEM_TRANSACTION_SIZE) ? (total_axi_size - base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) : CVIF_MAX_MEM_TRANSACTION_SIZE;
        // if (base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE == 0) {
        //     size_in_byte = total_axi_size > CVIF_MAX_MEM_TRANSACTION_SIZE?CVIF_MAX_MEM_TRANSACTION_SIZE:total_axi_size;
        // } else if ( total_axi_size > (base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE)) {
        //     size_in_byte = base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE;
        // } else {
        //     size_in_byte = total_axi_size;
        // }
        while (((cur_address + AXI_TRANSACTION_ATOM_SIZE) < (first_base_addr + total_axi_size)) && ((cur_address + AXI_TRANSACTION_ATOM_SIZE) % CVIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            size_in_byte += AXI_TRANSACTION_ATOM_SIZE;
            cur_address  += AXI_TRANSACTION_ATOM_SIZE;
        }
        // start address of next axi transaction
        cur_address += AXI_TRANSACTION_ATOM_SIZE;
        cslDebug((50, "NV_NVDLA_cvif::bdma2cvif_rd_req_b_transport, cur_address=0x%lx base_addr=0x%lx size_in_byte=0x%x\x0A", cur_address, base_addr, size_in_byte));

        // Allocating memory for dla_b_transport_payload
        bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
        axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
        // Setup byte enable in payload. Always read 64B from cvif and cvif, but drop unneeded 32B
        // Write true to *_rd_atom_enable_fifo_ when the 32B atom is needed by dma client
        // Write false to *_rd_atom_enable_fifo_ when the 32B atom is not needed by dma client (dma's addr is not aligned to 64B
        // for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
        //     if(base_addr == last_base_addr) {   // compare with last_base_addr before first_base_addr for the case of only one axi transaction
        //         if ( (((true == is_rear_64byte_align) || (byte_iter < (size_in_byte - DMA_TRANSACTION_ATOM_SIZE))) && (first_base_addr != base_addr)) || 
        //                 ( ( ( (true == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE) ) || ( (true == is_rear_64byte_align) && (byte_iter >= DMA_TRANSACTION_ATOM_SIZE)) ) && (first_base_addr == base_addr)) ){
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::bdma2cvif_rd_req_b_transport, write true to bdma_rd_atom_enable_fifo_\x0A"));
        //                 bdma_rd_atom_enable_fifo_->write(true);
        //             }
        //         } else {
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::bdma2cvif_rd_req_b_transport, write false to bdma_rd_atom_enable_fifo_\x0A"));
        //                 bdma_rd_atom_enable_fifo_->write(false);
        //             }
        //         }
        //     }
        //     else if(base_addr == first_base_addr) {
        //         if ( (true == is_base_64byte_align) || (byte_iter >= DMA_TRANSACTION_ATOM_SIZE) ){
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::bdma2cvif_rd_req_b_transport, write true to bdma_rd_atom_enable_fifo_\x0A"));
        //                 bdma_rd_atom_enable_fifo_->write(true);
        //             }
        //         } else {
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::bdma2cvif_rd_req_b_transport, write false to bdma_rd_atom_enable_fifo_\x0A"));
        //                 bdma_rd_atom_enable_fifo_->write(false);
        //             }
        //         }
        //     }
        //     else {
        //         axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //         if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //             cslDebug((50, "NV_NVDLA_cvif::bdma2cvif_rd_req_b_transport, write true to bdma_rd_atom_enable_fifo_\x0A"));
        //             bdma_rd_atom_enable_fifo_->write(true);
        //         }
        //     }
        // }
        for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
            if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE)) {
                // Diable 1st DMA atom of the unaligned first_base_addr
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::bdma2cvif_rd_req_b_transport, write true to bdma_rd_atom_enable_fifo_\x0A"));
                    bdma_rd_atom_enable_fifo_->write(false);
                }
            } else if (( (base_addr + size_in_byte) == (last_base_addr+AXI_TRANSACTION_ATOM_SIZE)) && (false == is_rear_64byte_align) && (byte_iter >= size_in_byte - DMA_TRANSACTION_ATOM_SIZE)) {
                // Diable 2nd DMA atom of the unaligned last_base_addr
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::bdma2cvif_rd_req_b_transport, write true to bdma_rd_atom_enable_fifo_\x0A"));
                    bdma_rd_atom_enable_fifo_->write(false);
                }
            } else {
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::bdma2cvif_rd_req_b_transport, write true to bdma_rd_atom_enable_fifo_\x0A"));
                    bdma_rd_atom_enable_fifo_->write(true);
                }
            }
        }
        cslDebug((50, "NV_NVDLA_cvif::bdma2cvif_rd_req_b_transport, TLM_BYTE_ENABLE is done\x0A"));
        bt_payload->configure_gp(base_addr, size_in_byte, is_read);
        bt_payload->gp.get_extension(nvdla_dbb_ext);
        nvdla_dbb_ext->set_id(BDMA_AXI_ID);
        nvdla_dbb_ext->set_size(64);
        nvdla_dbb_ext->set_length(size_in_byte/AXI_TRANSACTION_ATOM_SIZE);
#pragma CTC SKIP
        if(size_in_byte%AXI_TRANSACTION_ATOM_SIZE!=0) {
            FAIL(("NV_NVDLA_cvif::bdma2cvif_rd_req_b_transport, size_in_byte is not multiple of AXI_TRANSACTION_ATOM_SIZE. size_in_byte=0x%x", size_in_byte));
        }
#pragma CTC ENDSKIP
        cslDebug((50, "NV_NVDLA_cvif::bdma2cvif_rd_req_b_transport, before sending data to bdma_rd_req_fifo_ addr=0x%lx\x0A", base_addr));
        bdma_rd_req_fifo_->write(bt_payload);
        cslDebug((50, "NV_NVDLA_cvif::bdma2cvif_rd_req_b_transport, after sending data to bdma_rd_req_fifo_ addr=0x%lx\x0A", base_addr));

        // total_axi_size -= size_in_byte;
        // base_addr      += size_in_byte;
    }
    cslDebug((50, "NV_NVDLA_cvif::bdma2cvif_rd_req_b_transport, after spliting DMA transaction\x0A"));
}

void NV_NVDLA_cvif::ReadResp_cvif2bdma() {
    uint8_t    *axi_atom_ptr;
    uint32_t    atom_num_left;
    nvdla_dma_rd_rsp_t* dma_rd_rsp_payload = NULL;
    uint8_t           * dma_payload_data_ptr;
    uint32_t    idx;

    atom_num_left = 0;
    while(true) {
        if(0 == atom_num_left) {
            atom_num_left = bdma2cvif_rd_req_atom_num_fifo_->read();
            cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2bdma, update atom_num_left from bdma2cvif_rd_req_atom_num_fifo_, atom_num_left is 0x%x\x0A", atom_num_left));
        }
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2bdma, atom_num_left is 0x%x\x0A", atom_num_left));

        dma_rd_rsp_payload      = new nvdla_dma_rd_rsp_t;
        dma_payload_data_ptr    = reinterpret_cast <uint8_t *> (dma_rd_rsp_payload->pd.dma_read_data.data);
        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x00;

        // 1st atom of the 64B
        // Aligen to 32B
        axi_atom_ptr = cvif2bdma_rd_rsp_fifo_->read();
        credit_cvif2bdma_rd_rsp_fifo_ ++;
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2bdma, read 1st atom of the 64B from cvif2bdma_rd_rsp_fifo_\x0A"));
        atom_num_left--;

        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x1;
        memcpy (&dma_payload_data_ptr[0], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
        delete[] axi_atom_ptr;

        if(atom_num_left>0) {
            // 2nd atom of the 64B
            axi_atom_ptr = cvif2bdma_rd_rsp_fifo_->read();
            credit_cvif2bdma_rd_rsp_fifo_ ++;
            cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2bdma, read 2nd atom of the 64B from cvif2bdma_rd_rsp_fifo_\x0A"));
            atom_num_left--;
            dma_rd_rsp_payload->pd.dma_read_data.mask = (dma_rd_rsp_payload->pd.dma_read_data.mask << 0x1) + 0x1;
            memcpy (&dma_payload_data_ptr[DMA_TRANSACTION_ATOM_SIZE], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
            delete[] axi_atom_ptr;
        }

        cslDebug((70, "NV_NVDLA_cvif::ReadResp_cvif2bdma, dma_rd_rsp_payload->pd.dma_read_data.mask is 0x%x\x0A", uint32_t(dma_rd_rsp_payload->pd.dma_read_data.mask)));
        cslDebug((70, "NV_NVDLA_cvif::ReadResp_cvif2bdma, dma_rd_rsp_payload->pd.dma_read_data.data are :\x0A"));
        for (idx = 0; idx < sizeof(dma_rd_rsp_payload->pd.dma_read_data.data)/sizeof(dma_rd_rsp_payload->pd.dma_read_data.data[0]); idx++) {
            cslDebug((70, "    0x%lx\x0A", uint64_t (dma_rd_rsp_payload->pd.dma_read_data.data[idx])));   // The size of data[idx] is 8bytes and its type is "unsigned long"
        }
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2bdma, before NV_NVDLA_cvif_base::cvif2bdma_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        NV_NVDLA_cvif_base::cvif2bdma_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2bdma, after NV_NVDLA_cvif_base::cvif2bdma_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        delete dma_rd_rsp_payload;
    }
}

void NV_NVDLA_cvif::sdp2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    // DMA request size unit is 32 bytes
    uint64_t base_addr;
    uint64_t first_base_addr;
    uint64_t last_base_addr;
    uint64_t cur_address;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_base_64byte_align;
    bool     is_rear_64byte_align;
    bool     is_read=true;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    dla_b_transport_payload *bt_payload;

    payload_addr = payload->pd.dma_read_cmd.addr;
    payload_size = (payload->pd.dma_read_cmd.size + 1) * DMA_TRANSACTION_ATOM_SIZE; //payload_size's max value is 2^13

    is_base_64byte_align = payload_addr%AXI_TRANSACTION_ATOM_SIZE == 0;
    first_base_addr = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B
    cur_address = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B

    is_rear_64byte_align = (payload_addr + payload_size) % AXI_TRANSACTION_ATOM_SIZE == 0;
    total_axi_size = payload_size + (is_base_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE) + (is_rear_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE);
    last_base_addr = first_base_addr + total_axi_size - AXI_TRANSACTION_ATOM_SIZE;
    cslDebug((30, "NV_NVDLA_cvif::sdp2cvif_rd_req_b_transport, first_base_addr=0x%lx last_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, last_base_addr, total_axi_size, payload_addr, payload_size));
    // if ( total_axi_size <= (first_base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) ) {
    //     last_base_addr = first_base_addr;
    // } else if ((first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE != 0) {
    //     if (total_axi_size >= (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE) {
    //         last_base_addr = first_base_addr + total_axi_size - (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE;
    //     } else {
    //         last_base_addr = first_base_addr;
    //     }
    // } else {
    //     if (total_axi_size >= CVIF_MAX_MEM_TRANSACTION_SIZE) {
    //         last_base_addr = first_base_addr + total_axi_size - CVIF_MAX_MEM_TRANSACTION_SIZE;
    //     } else {
    //         last_base_addr = first_base_addr;
    //     }
    // }

    base_addr = first_base_addr;

    // Push the number of atoms of the request
    // sdp2cvif_rd_req_atom_num_fifo_->write(total_axi_size/DMA_TRANSACTION_ATOM_SIZE);
    sdp2cvif_rd_req_atom_num_fifo_->write(payload_size/DMA_TRANSACTION_ATOM_SIZE);
    cslDebug((50, "NV_NVDLA_cvif::sdp2cvif_rd_req_b_transport, write 0x%x to sdp2cvif_rd_req_atom_num_fifo_.\x0A", payload_size/DMA_TRANSACTION_ATOM_SIZE));

    //Split dma request to axi requests
    cslDebug((50, "NV_NVDLA_cvif::sdp2cvif_rd_req_b_transport, before spliting DMA transaction\x0A"));
    while(cur_address <= last_base_addr) {
        base_addr    = cur_address;
        size_in_byte = AXI_TRANSACTION_ATOM_SIZE;
        cslDebug((50, "NV_NVDLA_cvif::sdp2cvif_rd_req_b_transport, prepare AXI transaction for address: 0x%lx\x0A", base_addr));
        // base_addr should be aligned to 64B
        // size_in_byte should be multiple of 64
        // if the data size required by dma mster is 32B, MCIF will drop the extra 32B when AXI returns
        // size_in_byte = total_axi_size > (CVIF_MAX_MEM_TRANSACTION_SIZE) ? CVIF_MAX_MEM_TRANSACTION_SIZE : total_axi_size;
        // size_in_byte = (total_axi_size - base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) < (CVIF_MAX_MEM_TRANSACTION_SIZE) ? (total_axi_size - base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) : CVIF_MAX_MEM_TRANSACTION_SIZE;
        // if (base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE == 0) {
        //     size_in_byte = total_axi_size > CVIF_MAX_MEM_TRANSACTION_SIZE?CVIF_MAX_MEM_TRANSACTION_SIZE:total_axi_size;
        // } else if ( total_axi_size > (base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE)) {
        //     size_in_byte = base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE;
        // } else {
        //     size_in_byte = total_axi_size;
        // }
        while (((cur_address + AXI_TRANSACTION_ATOM_SIZE) < (first_base_addr + total_axi_size)) && ((cur_address + AXI_TRANSACTION_ATOM_SIZE) % CVIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            size_in_byte += AXI_TRANSACTION_ATOM_SIZE;
            cur_address  += AXI_TRANSACTION_ATOM_SIZE;
        }
        // start address of next axi transaction
        cur_address += AXI_TRANSACTION_ATOM_SIZE;
        cslDebug((50, "NV_NVDLA_cvif::sdp2cvif_rd_req_b_transport, cur_address=0x%lx base_addr=0x%lx size_in_byte=0x%x\x0A", cur_address, base_addr, size_in_byte));

        // Allocating memory for dla_b_transport_payload
        bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
        axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
        // Setup byte enable in payload. Always read 64B from cvif and cvif, but drop unneeded 32B
        // Write true to *_rd_atom_enable_fifo_ when the 32B atom is needed by dma client
        // Write false to *_rd_atom_enable_fifo_ when the 32B atom is not needed by dma client (dma's addr is not aligned to 64B
        // for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
        //     if(base_addr == last_base_addr) {   // compare with last_base_addr before first_base_addr for the case of only one axi transaction
        //         if ( (((true == is_rear_64byte_align) || (byte_iter < (size_in_byte - DMA_TRANSACTION_ATOM_SIZE))) && (first_base_addr != base_addr)) || 
        //                 ( ( ( (true == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE) ) || ( (true == is_rear_64byte_align) && (byte_iter >= DMA_TRANSACTION_ATOM_SIZE)) ) && (first_base_addr == base_addr)) ){
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::sdp2cvif_rd_req_b_transport, write true to sdp_rd_atom_enable_fifo_\x0A"));
        //                 sdp_rd_atom_enable_fifo_->write(true);
        //             }
        //         } else {
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::sdp2cvif_rd_req_b_transport, write false to sdp_rd_atom_enable_fifo_\x0A"));
        //                 sdp_rd_atom_enable_fifo_->write(false);
        //             }
        //         }
        //     }
        //     else if(base_addr == first_base_addr) {
        //         if ( (true == is_base_64byte_align) || (byte_iter >= DMA_TRANSACTION_ATOM_SIZE) ){
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::sdp2cvif_rd_req_b_transport, write true to sdp_rd_atom_enable_fifo_\x0A"));
        //                 sdp_rd_atom_enable_fifo_->write(true);
        //             }
        //         } else {
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::sdp2cvif_rd_req_b_transport, write false to sdp_rd_atom_enable_fifo_\x0A"));
        //                 sdp_rd_atom_enable_fifo_->write(false);
        //             }
        //         }
        //     }
        //     else {
        //         axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //         if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //             cslDebug((50, "NV_NVDLA_cvif::sdp2cvif_rd_req_b_transport, write true to sdp_rd_atom_enable_fifo_\x0A"));
        //             sdp_rd_atom_enable_fifo_->write(true);
        //         }
        //     }
        // }
        for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
            if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE)) {
                // Diable 1st DMA atom of the unaligned first_base_addr
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::sdp2cvif_rd_req_b_transport, write true to sdp_rd_atom_enable_fifo_\x0A"));
                    sdp_rd_atom_enable_fifo_->write(false);
                }
            } else if (( (base_addr + size_in_byte) == (last_base_addr+AXI_TRANSACTION_ATOM_SIZE)) && (false == is_rear_64byte_align) && (byte_iter >= size_in_byte - DMA_TRANSACTION_ATOM_SIZE)) {
                // Diable 2nd DMA atom of the unaligned last_base_addr
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::sdp2cvif_rd_req_b_transport, write true to sdp_rd_atom_enable_fifo_\x0A"));
                    sdp_rd_atom_enable_fifo_->write(false);
                }
            } else {
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::sdp2cvif_rd_req_b_transport, write true to sdp_rd_atom_enable_fifo_\x0A"));
                    sdp_rd_atom_enable_fifo_->write(true);
                }
            }
        }
        cslDebug((50, "NV_NVDLA_cvif::sdp2cvif_rd_req_b_transport, TLM_BYTE_ENABLE is done\x0A"));
        bt_payload->configure_gp(base_addr, size_in_byte, is_read);
        bt_payload->gp.get_extension(nvdla_dbb_ext);
        nvdla_dbb_ext->set_id(SDP_AXI_ID);
        nvdla_dbb_ext->set_size(64);
        nvdla_dbb_ext->set_length(size_in_byte/AXI_TRANSACTION_ATOM_SIZE);
#pragma CTC SKIP
        if(size_in_byte%AXI_TRANSACTION_ATOM_SIZE!=0) {
            FAIL(("NV_NVDLA_cvif::sdp2cvif_rd_req_b_transport, size_in_byte is not multiple of AXI_TRANSACTION_ATOM_SIZE. size_in_byte=0x%x", size_in_byte));
        }
#pragma CTC ENDSKIP
        cslDebug((50, "NV_NVDLA_cvif::sdp2cvif_rd_req_b_transport, before sending data to sdp_rd_req_fifo_ addr=0x%lx\x0A", base_addr));
        sdp_rd_req_fifo_->write(bt_payload);
        cslDebug((50, "NV_NVDLA_cvif::sdp2cvif_rd_req_b_transport, after sending data to sdp_rd_req_fifo_ addr=0x%lx\x0A", base_addr));

        // total_axi_size -= size_in_byte;
        // base_addr      += size_in_byte;
    }
    cslDebug((50, "NV_NVDLA_cvif::sdp2cvif_rd_req_b_transport, after spliting DMA transaction\x0A"));
}

void NV_NVDLA_cvif::ReadResp_cvif2sdp() {
    uint8_t    *axi_atom_ptr;
    uint32_t    atom_num_left;
    nvdla_dma_rd_rsp_t* dma_rd_rsp_payload = NULL;
    uint8_t           * dma_payload_data_ptr;
    uint32_t    idx;

    atom_num_left = 0;
    while(true) {
        if(0 == atom_num_left) {
            atom_num_left = sdp2cvif_rd_req_atom_num_fifo_->read();
            cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp, update atom_num_left from sdp2cvif_rd_req_atom_num_fifo_, atom_num_left is 0x%x\x0A", atom_num_left));
        }
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp, atom_num_left is 0x%x\x0A", atom_num_left));

        dma_rd_rsp_payload      = new nvdla_dma_rd_rsp_t;
        dma_payload_data_ptr    = reinterpret_cast <uint8_t *> (dma_rd_rsp_payload->pd.dma_read_data.data);
        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x00;

        // 1st atom of the 64B
        // Aligen to 32B
        axi_atom_ptr = cvif2sdp_rd_rsp_fifo_->read();
        credit_cvif2sdp_rd_rsp_fifo_ ++;
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp, read 1st atom of the 64B from cvif2sdp_rd_rsp_fifo_\x0A"));
        atom_num_left--;

        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x1;
        memcpy (&dma_payload_data_ptr[0], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
        delete[] axi_atom_ptr;

        if(atom_num_left>0) {
            // 2nd atom of the 64B
            axi_atom_ptr = cvif2sdp_rd_rsp_fifo_->read();
            credit_cvif2sdp_rd_rsp_fifo_ ++;
            cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp, read 2nd atom of the 64B from cvif2sdp_rd_rsp_fifo_\x0A"));
            atom_num_left--;
            dma_rd_rsp_payload->pd.dma_read_data.mask = (dma_rd_rsp_payload->pd.dma_read_data.mask << 0x1) + 0x1;
            memcpy (&dma_payload_data_ptr[DMA_TRANSACTION_ATOM_SIZE], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
            delete[] axi_atom_ptr;
        }

        cslDebug((70, "NV_NVDLA_cvif::ReadResp_cvif2sdp, dma_rd_rsp_payload->pd.dma_read_data.mask is 0x%x\x0A", uint32_t(dma_rd_rsp_payload->pd.dma_read_data.mask)));
        cslDebug((70, "NV_NVDLA_cvif::ReadResp_cvif2sdp, dma_rd_rsp_payload->pd.dma_read_data.data are :\x0A"));
        for (idx = 0; idx < sizeof(dma_rd_rsp_payload->pd.dma_read_data.data)/sizeof(dma_rd_rsp_payload->pd.dma_read_data.data[0]); idx++) {
            cslDebug((70, "    0x%lx\x0A", uint64_t (dma_rd_rsp_payload->pd.dma_read_data.data[idx])));   // The size of data[idx] is 8bytes and its type is "unsigned long"
        }
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp, before NV_NVDLA_cvif_base::cvif2sdp_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        NV_NVDLA_cvif_base::cvif2sdp_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp, after NV_NVDLA_cvif_base::cvif2sdp_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        delete dma_rd_rsp_payload;
    }
}

void NV_NVDLA_cvif::pdp2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    // DMA request size unit is 32 bytes
    uint64_t base_addr;
    uint64_t first_base_addr;
    uint64_t last_base_addr;
    uint64_t cur_address;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_base_64byte_align;
    bool     is_rear_64byte_align;
    bool     is_read=true;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    dla_b_transport_payload *bt_payload;

    payload_addr = payload->pd.dma_read_cmd.addr;
    payload_size = (payload->pd.dma_read_cmd.size + 1) * DMA_TRANSACTION_ATOM_SIZE; //payload_size's max value is 2^13

    is_base_64byte_align = payload_addr%AXI_TRANSACTION_ATOM_SIZE == 0;
    first_base_addr = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B
    cur_address = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B

    is_rear_64byte_align = (payload_addr + payload_size) % AXI_TRANSACTION_ATOM_SIZE == 0;
    total_axi_size = payload_size + (is_base_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE) + (is_rear_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE);
    last_base_addr = first_base_addr + total_axi_size - AXI_TRANSACTION_ATOM_SIZE;
    cslDebug((30, "NV_NVDLA_cvif::pdp2cvif_rd_req_b_transport, first_base_addr=0x%lx last_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, last_base_addr, total_axi_size, payload_addr, payload_size));
    // if ( total_axi_size <= (first_base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) ) {
    //     last_base_addr = first_base_addr;
    // } else if ((first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE != 0) {
    //     if (total_axi_size >= (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE) {
    //         last_base_addr = first_base_addr + total_axi_size - (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE;
    //     } else {
    //         last_base_addr = first_base_addr;
    //     }
    // } else {
    //     if (total_axi_size >= CVIF_MAX_MEM_TRANSACTION_SIZE) {
    //         last_base_addr = first_base_addr + total_axi_size - CVIF_MAX_MEM_TRANSACTION_SIZE;
    //     } else {
    //         last_base_addr = first_base_addr;
    //     }
    // }

    base_addr = first_base_addr;

    // Push the number of atoms of the request
    // pdp2cvif_rd_req_atom_num_fifo_->write(total_axi_size/DMA_TRANSACTION_ATOM_SIZE);
    pdp2cvif_rd_req_atom_num_fifo_->write(payload_size/DMA_TRANSACTION_ATOM_SIZE);
    cslDebug((50, "NV_NVDLA_cvif::pdp2cvif_rd_req_b_transport, write 0x%x to pdp2cvif_rd_req_atom_num_fifo_.\x0A", payload_size/DMA_TRANSACTION_ATOM_SIZE));

    //Split dma request to axi requests
    cslDebug((50, "NV_NVDLA_cvif::pdp2cvif_rd_req_b_transport, before spliting DMA transaction\x0A"));
    while(cur_address <= last_base_addr) {
        base_addr    = cur_address;
        size_in_byte = AXI_TRANSACTION_ATOM_SIZE;
        cslDebug((50, "NV_NVDLA_cvif::pdp2cvif_rd_req_b_transport, prepare AXI transaction for address: 0x%lx\x0A", base_addr));
        // base_addr should be aligned to 64B
        // size_in_byte should be multiple of 64
        // if the data size required by dma mster is 32B, MCIF will drop the extra 32B when AXI returns
        // size_in_byte = total_axi_size > (CVIF_MAX_MEM_TRANSACTION_SIZE) ? CVIF_MAX_MEM_TRANSACTION_SIZE : total_axi_size;
        // size_in_byte = (total_axi_size - base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) < (CVIF_MAX_MEM_TRANSACTION_SIZE) ? (total_axi_size - base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) : CVIF_MAX_MEM_TRANSACTION_SIZE;
        // if (base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE == 0) {
        //     size_in_byte = total_axi_size > CVIF_MAX_MEM_TRANSACTION_SIZE?CVIF_MAX_MEM_TRANSACTION_SIZE:total_axi_size;
        // } else if ( total_axi_size > (base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE)) {
        //     size_in_byte = base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE;
        // } else {
        //     size_in_byte = total_axi_size;
        // }
        while (((cur_address + AXI_TRANSACTION_ATOM_SIZE) < (first_base_addr + total_axi_size)) && ((cur_address + AXI_TRANSACTION_ATOM_SIZE) % CVIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            size_in_byte += AXI_TRANSACTION_ATOM_SIZE;
            cur_address  += AXI_TRANSACTION_ATOM_SIZE;
        }
        // start address of next axi transaction
        cur_address += AXI_TRANSACTION_ATOM_SIZE;
        cslDebug((50, "NV_NVDLA_cvif::pdp2cvif_rd_req_b_transport, cur_address=0x%lx base_addr=0x%lx size_in_byte=0x%x\x0A", cur_address, base_addr, size_in_byte));

        // Allocating memory for dla_b_transport_payload
        bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
        axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
        // Setup byte enable in payload. Always read 64B from cvif and cvif, but drop unneeded 32B
        // Write true to *_rd_atom_enable_fifo_ when the 32B atom is needed by dma client
        // Write false to *_rd_atom_enable_fifo_ when the 32B atom is not needed by dma client (dma's addr is not aligned to 64B
        // for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
        //     if(base_addr == last_base_addr) {   // compare with last_base_addr before first_base_addr for the case of only one axi transaction
        //         if ( (((true == is_rear_64byte_align) || (byte_iter < (size_in_byte - DMA_TRANSACTION_ATOM_SIZE))) && (first_base_addr != base_addr)) || 
        //                 ( ( ( (true == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE) ) || ( (true == is_rear_64byte_align) && (byte_iter >= DMA_TRANSACTION_ATOM_SIZE)) ) && (first_base_addr == base_addr)) ){
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::pdp2cvif_rd_req_b_transport, write true to pdp_rd_atom_enable_fifo_\x0A"));
        //                 pdp_rd_atom_enable_fifo_->write(true);
        //             }
        //         } else {
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::pdp2cvif_rd_req_b_transport, write false to pdp_rd_atom_enable_fifo_\x0A"));
        //                 pdp_rd_atom_enable_fifo_->write(false);
        //             }
        //         }
        //     }
        //     else if(base_addr == first_base_addr) {
        //         if ( (true == is_base_64byte_align) || (byte_iter >= DMA_TRANSACTION_ATOM_SIZE) ){
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::pdp2cvif_rd_req_b_transport, write true to pdp_rd_atom_enable_fifo_\x0A"));
        //                 pdp_rd_atom_enable_fifo_->write(true);
        //             }
        //         } else {
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::pdp2cvif_rd_req_b_transport, write false to pdp_rd_atom_enable_fifo_\x0A"));
        //                 pdp_rd_atom_enable_fifo_->write(false);
        //             }
        //         }
        //     }
        //     else {
        //         axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //         if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //             cslDebug((50, "NV_NVDLA_cvif::pdp2cvif_rd_req_b_transport, write true to pdp_rd_atom_enable_fifo_\x0A"));
        //             pdp_rd_atom_enable_fifo_->write(true);
        //         }
        //     }
        // }
        for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
            if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE)) {
                // Diable 1st DMA atom of the unaligned first_base_addr
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::pdp2cvif_rd_req_b_transport, write true to pdp_rd_atom_enable_fifo_\x0A"));
                    pdp_rd_atom_enable_fifo_->write(false);
                }
            } else if (( (base_addr + size_in_byte) == (last_base_addr+AXI_TRANSACTION_ATOM_SIZE)) && (false == is_rear_64byte_align) && (byte_iter >= size_in_byte - DMA_TRANSACTION_ATOM_SIZE)) {
                // Diable 2nd DMA atom of the unaligned last_base_addr
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::pdp2cvif_rd_req_b_transport, write true to pdp_rd_atom_enable_fifo_\x0A"));
                    pdp_rd_atom_enable_fifo_->write(false);
                }
            } else {
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::pdp2cvif_rd_req_b_transport, write true to pdp_rd_atom_enable_fifo_\x0A"));
                    pdp_rd_atom_enable_fifo_->write(true);
                }
            }
        }
        cslDebug((50, "NV_NVDLA_cvif::pdp2cvif_rd_req_b_transport, TLM_BYTE_ENABLE is done\x0A"));
        bt_payload->configure_gp(base_addr, size_in_byte, is_read);
        bt_payload->gp.get_extension(nvdla_dbb_ext);
        nvdla_dbb_ext->set_id(PDP_AXI_ID);
        nvdla_dbb_ext->set_size(64);
        nvdla_dbb_ext->set_length(size_in_byte/AXI_TRANSACTION_ATOM_SIZE);
#pragma CTC SKIP
        if(size_in_byte%AXI_TRANSACTION_ATOM_SIZE!=0) {
            FAIL(("NV_NVDLA_cvif::pdp2cvif_rd_req_b_transport, size_in_byte is not multiple of AXI_TRANSACTION_ATOM_SIZE. size_in_byte=0x%x", size_in_byte));
        }
#pragma CTC ENDSKIP
        cslDebug((50, "NV_NVDLA_cvif::pdp2cvif_rd_req_b_transport, before sending data to pdp_rd_req_fifo_ addr=0x%lx\x0A", base_addr));
        pdp_rd_req_fifo_->write(bt_payload);
        cslDebug((50, "NV_NVDLA_cvif::pdp2cvif_rd_req_b_transport, after sending data to pdp_rd_req_fifo_ addr=0x%lx\x0A", base_addr));

        // total_axi_size -= size_in_byte;
        // base_addr      += size_in_byte;
    }
    cslDebug((50, "NV_NVDLA_cvif::pdp2cvif_rd_req_b_transport, after spliting DMA transaction\x0A"));
}

void NV_NVDLA_cvif::ReadResp_cvif2pdp() {
    uint8_t    *axi_atom_ptr;
    uint32_t    atom_num_left;
    nvdla_dma_rd_rsp_t* dma_rd_rsp_payload = NULL;
    uint8_t           * dma_payload_data_ptr;
    uint32_t    idx;

    atom_num_left = 0;
    while(true) {
        if(0 == atom_num_left) {
            atom_num_left = pdp2cvif_rd_req_atom_num_fifo_->read();
            cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2pdp, update atom_num_left from pdp2cvif_rd_req_atom_num_fifo_, atom_num_left is 0x%x\x0A", atom_num_left));
        }
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2pdp, atom_num_left is 0x%x\x0A", atom_num_left));

        dma_rd_rsp_payload      = new nvdla_dma_rd_rsp_t;
        dma_payload_data_ptr    = reinterpret_cast <uint8_t *> (dma_rd_rsp_payload->pd.dma_read_data.data);
        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x00;

        // 1st atom of the 64B
        // Aligen to 32B
        axi_atom_ptr = cvif2pdp_rd_rsp_fifo_->read();
        credit_cvif2pdp_rd_rsp_fifo_ ++;
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2pdp, read 1st atom of the 64B from cvif2pdp_rd_rsp_fifo_\x0A"));
        atom_num_left--;

        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x1;
        memcpy (&dma_payload_data_ptr[0], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
        delete[] axi_atom_ptr;

        if(atom_num_left>0) {
            // 2nd atom of the 64B
            axi_atom_ptr = cvif2pdp_rd_rsp_fifo_->read();
            credit_cvif2pdp_rd_rsp_fifo_ ++;
            cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2pdp, read 2nd atom of the 64B from cvif2pdp_rd_rsp_fifo_\x0A"));
            atom_num_left--;
            dma_rd_rsp_payload->pd.dma_read_data.mask = (dma_rd_rsp_payload->pd.dma_read_data.mask << 0x1) + 0x1;
            memcpy (&dma_payload_data_ptr[DMA_TRANSACTION_ATOM_SIZE], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
            delete[] axi_atom_ptr;
        }

        cslDebug((70, "NV_NVDLA_cvif::ReadResp_cvif2pdp, dma_rd_rsp_payload->pd.dma_read_data.mask is 0x%x\x0A", uint32_t(dma_rd_rsp_payload->pd.dma_read_data.mask)));
        cslDebug((70, "NV_NVDLA_cvif::ReadResp_cvif2pdp, dma_rd_rsp_payload->pd.dma_read_data.data are :\x0A"));
        for (idx = 0; idx < sizeof(dma_rd_rsp_payload->pd.dma_read_data.data)/sizeof(dma_rd_rsp_payload->pd.dma_read_data.data[0]); idx++) {
            cslDebug((70, "    0x%lx\x0A", uint64_t (dma_rd_rsp_payload->pd.dma_read_data.data[idx])));   // The size of data[idx] is 8bytes and its type is "unsigned long"
        }
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2pdp, before NV_NVDLA_cvif_base::cvif2pdp_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        NV_NVDLA_cvif_base::cvif2pdp_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2pdp, after NV_NVDLA_cvif_base::cvif2pdp_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        delete dma_rd_rsp_payload;
    }
}

void NV_NVDLA_cvif::cdp2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    // DMA request size unit is 32 bytes
    uint64_t base_addr;
    uint64_t first_base_addr;
    uint64_t last_base_addr;
    uint64_t cur_address;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_base_64byte_align;
    bool     is_rear_64byte_align;
    bool     is_read=true;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    dla_b_transport_payload *bt_payload;

    payload_addr = payload->pd.dma_read_cmd.addr;
    payload_size = (payload->pd.dma_read_cmd.size + 1) * DMA_TRANSACTION_ATOM_SIZE; //payload_size's max value is 2^13

    is_base_64byte_align = payload_addr%AXI_TRANSACTION_ATOM_SIZE == 0;
    first_base_addr = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B
    cur_address = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B

    is_rear_64byte_align = (payload_addr + payload_size) % AXI_TRANSACTION_ATOM_SIZE == 0;
    total_axi_size = payload_size + (is_base_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE) + (is_rear_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE);
    last_base_addr = first_base_addr + total_axi_size - AXI_TRANSACTION_ATOM_SIZE;
    cslDebug((30, "NV_NVDLA_cvif::cdp2cvif_rd_req_b_transport, first_base_addr=0x%lx last_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, last_base_addr, total_axi_size, payload_addr, payload_size));
    // if ( total_axi_size <= (first_base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) ) {
    //     last_base_addr = first_base_addr;
    // } else if ((first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE != 0) {
    //     if (total_axi_size >= (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE) {
    //         last_base_addr = first_base_addr + total_axi_size - (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE;
    //     } else {
    //         last_base_addr = first_base_addr;
    //     }
    // } else {
    //     if (total_axi_size >= CVIF_MAX_MEM_TRANSACTION_SIZE) {
    //         last_base_addr = first_base_addr + total_axi_size - CVIF_MAX_MEM_TRANSACTION_SIZE;
    //     } else {
    //         last_base_addr = first_base_addr;
    //     }
    // }

    base_addr = first_base_addr;

    // Push the number of atoms of the request
    // cdp2cvif_rd_req_atom_num_fifo_->write(total_axi_size/DMA_TRANSACTION_ATOM_SIZE);
    cdp2cvif_rd_req_atom_num_fifo_->write(payload_size/DMA_TRANSACTION_ATOM_SIZE);
    cslDebug((50, "NV_NVDLA_cvif::cdp2cvif_rd_req_b_transport, write 0x%x to cdp2cvif_rd_req_atom_num_fifo_.\x0A", payload_size/DMA_TRANSACTION_ATOM_SIZE));

    //Split dma request to axi requests
    cslDebug((50, "NV_NVDLA_cvif::cdp2cvif_rd_req_b_transport, before spliting DMA transaction\x0A"));
    while(cur_address <= last_base_addr) {
        base_addr    = cur_address;
        size_in_byte = AXI_TRANSACTION_ATOM_SIZE;
        cslDebug((50, "NV_NVDLA_cvif::cdp2cvif_rd_req_b_transport, prepare AXI transaction for address: 0x%lx\x0A", base_addr));
        // base_addr should be aligned to 64B
        // size_in_byte should be multiple of 64
        // if the data size required by dma mster is 32B, MCIF will drop the extra 32B when AXI returns
        // size_in_byte = total_axi_size > (CVIF_MAX_MEM_TRANSACTION_SIZE) ? CVIF_MAX_MEM_TRANSACTION_SIZE : total_axi_size;
        // size_in_byte = (total_axi_size - base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) < (CVIF_MAX_MEM_TRANSACTION_SIZE) ? (total_axi_size - base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) : CVIF_MAX_MEM_TRANSACTION_SIZE;
        // if (base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE == 0) {
        //     size_in_byte = total_axi_size > CVIF_MAX_MEM_TRANSACTION_SIZE?CVIF_MAX_MEM_TRANSACTION_SIZE:total_axi_size;
        // } else if ( total_axi_size > (base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE)) {
        //     size_in_byte = base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE;
        // } else {
        //     size_in_byte = total_axi_size;
        // }
        while (((cur_address + AXI_TRANSACTION_ATOM_SIZE) < (first_base_addr + total_axi_size)) && ((cur_address + AXI_TRANSACTION_ATOM_SIZE) % CVIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            size_in_byte += AXI_TRANSACTION_ATOM_SIZE;
            cur_address  += AXI_TRANSACTION_ATOM_SIZE;
        }
        // start address of next axi transaction
        cur_address += AXI_TRANSACTION_ATOM_SIZE;
        cslDebug((50, "NV_NVDLA_cvif::cdp2cvif_rd_req_b_transport, cur_address=0x%lx base_addr=0x%lx size_in_byte=0x%x\x0A", cur_address, base_addr, size_in_byte));

        // Allocating memory for dla_b_transport_payload
        bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
        axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
        // Setup byte enable in payload. Always read 64B from cvif and cvif, but drop unneeded 32B
        // Write true to *_rd_atom_enable_fifo_ when the 32B atom is needed by dma client
        // Write false to *_rd_atom_enable_fifo_ when the 32B atom is not needed by dma client (dma's addr is not aligned to 64B
        // for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
        //     if(base_addr == last_base_addr) {   // compare with last_base_addr before first_base_addr for the case of only one axi transaction
        //         if ( (((true == is_rear_64byte_align) || (byte_iter < (size_in_byte - DMA_TRANSACTION_ATOM_SIZE))) && (first_base_addr != base_addr)) || 
        //                 ( ( ( (true == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE) ) || ( (true == is_rear_64byte_align) && (byte_iter >= DMA_TRANSACTION_ATOM_SIZE)) ) && (first_base_addr == base_addr)) ){
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::cdp2cvif_rd_req_b_transport, write true to cdp_rd_atom_enable_fifo_\x0A"));
        //                 cdp_rd_atom_enable_fifo_->write(true);
        //             }
        //         } else {
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::cdp2cvif_rd_req_b_transport, write false to cdp_rd_atom_enable_fifo_\x0A"));
        //                 cdp_rd_atom_enable_fifo_->write(false);
        //             }
        //         }
        //     }
        //     else if(base_addr == first_base_addr) {
        //         if ( (true == is_base_64byte_align) || (byte_iter >= DMA_TRANSACTION_ATOM_SIZE) ){
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::cdp2cvif_rd_req_b_transport, write true to cdp_rd_atom_enable_fifo_\x0A"));
        //                 cdp_rd_atom_enable_fifo_->write(true);
        //             }
        //         } else {
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::cdp2cvif_rd_req_b_transport, write false to cdp_rd_atom_enable_fifo_\x0A"));
        //                 cdp_rd_atom_enable_fifo_->write(false);
        //             }
        //         }
        //     }
        //     else {
        //         axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //         if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //             cslDebug((50, "NV_NVDLA_cvif::cdp2cvif_rd_req_b_transport, write true to cdp_rd_atom_enable_fifo_\x0A"));
        //             cdp_rd_atom_enable_fifo_->write(true);
        //         }
        //     }
        // }
        for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
            if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE)) {
                // Diable 1st DMA atom of the unaligned first_base_addr
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::cdp2cvif_rd_req_b_transport, write true to cdp_rd_atom_enable_fifo_\x0A"));
                    cdp_rd_atom_enable_fifo_->write(false);
                }
            } else if (( (base_addr + size_in_byte) == (last_base_addr+AXI_TRANSACTION_ATOM_SIZE)) && (false == is_rear_64byte_align) && (byte_iter >= size_in_byte - DMA_TRANSACTION_ATOM_SIZE)) {
                // Diable 2nd DMA atom of the unaligned last_base_addr
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::cdp2cvif_rd_req_b_transport, write true to cdp_rd_atom_enable_fifo_\x0A"));
                    cdp_rd_atom_enable_fifo_->write(false);
                }
            } else {
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::cdp2cvif_rd_req_b_transport, write true to cdp_rd_atom_enable_fifo_\x0A"));
                    cdp_rd_atom_enable_fifo_->write(true);
                }
            }
        }
        cslDebug((50, "NV_NVDLA_cvif::cdp2cvif_rd_req_b_transport, TLM_BYTE_ENABLE is done\x0A"));
        bt_payload->configure_gp(base_addr, size_in_byte, is_read);
        bt_payload->gp.get_extension(nvdla_dbb_ext);
        nvdla_dbb_ext->set_id(CDP_AXI_ID);
        nvdla_dbb_ext->set_size(64);
        nvdla_dbb_ext->set_length(size_in_byte/AXI_TRANSACTION_ATOM_SIZE);
#pragma CTC SKIP
        if(size_in_byte%AXI_TRANSACTION_ATOM_SIZE!=0) {
            FAIL(("NV_NVDLA_cvif::cdp2cvif_rd_req_b_transport, size_in_byte is not multiple of AXI_TRANSACTION_ATOM_SIZE. size_in_byte=0x%x", size_in_byte));
        }
#pragma CTC ENDSKIP
        cslDebug((50, "NV_NVDLA_cvif::cdp2cvif_rd_req_b_transport, before sending data to cdp_rd_req_fifo_ addr=0x%lx\x0A", base_addr));
        cdp_rd_req_fifo_->write(bt_payload);
        cslDebug((50, "NV_NVDLA_cvif::cdp2cvif_rd_req_b_transport, after sending data to cdp_rd_req_fifo_ addr=0x%lx\x0A", base_addr));

        // total_axi_size -= size_in_byte;
        // base_addr      += size_in_byte;
    }
    cslDebug((50, "NV_NVDLA_cvif::cdp2cvif_rd_req_b_transport, after spliting DMA transaction\x0A"));
}

void NV_NVDLA_cvif::ReadResp_cvif2cdp() {
    uint8_t    *axi_atom_ptr;
    uint32_t    atom_num_left;
    nvdla_dma_rd_rsp_t* dma_rd_rsp_payload = NULL;
    uint8_t           * dma_payload_data_ptr;
    uint32_t    idx;

    atom_num_left = 0;
    while(true) {
        if(0 == atom_num_left) {
            atom_num_left = cdp2cvif_rd_req_atom_num_fifo_->read();
            cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2cdp, update atom_num_left from cdp2cvif_rd_req_atom_num_fifo_, atom_num_left is 0x%x\x0A", atom_num_left));
        }
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2cdp, atom_num_left is 0x%x\x0A", atom_num_left));

        dma_rd_rsp_payload      = new nvdla_dma_rd_rsp_t;
        dma_payload_data_ptr    = reinterpret_cast <uint8_t *> (dma_rd_rsp_payload->pd.dma_read_data.data);
        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x00;

        // 1st atom of the 64B
        // Aligen to 32B
        axi_atom_ptr = cvif2cdp_rd_rsp_fifo_->read();
        credit_cvif2cdp_rd_rsp_fifo_ ++;
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2cdp, read 1st atom of the 64B from cvif2cdp_rd_rsp_fifo_\x0A"));
        atom_num_left--;

        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x1;
        memcpy (&dma_payload_data_ptr[0], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
        delete[] axi_atom_ptr;

        if(atom_num_left>0) {
            // 2nd atom of the 64B
            axi_atom_ptr = cvif2cdp_rd_rsp_fifo_->read();
            credit_cvif2cdp_rd_rsp_fifo_ ++;
            cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2cdp, read 2nd atom of the 64B from cvif2cdp_rd_rsp_fifo_\x0A"));
            atom_num_left--;
            dma_rd_rsp_payload->pd.dma_read_data.mask = (dma_rd_rsp_payload->pd.dma_read_data.mask << 0x1) + 0x1;
            memcpy (&dma_payload_data_ptr[DMA_TRANSACTION_ATOM_SIZE], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
            delete[] axi_atom_ptr;
        }

        cslDebug((70, "NV_NVDLA_cvif::ReadResp_cvif2cdp, dma_rd_rsp_payload->pd.dma_read_data.mask is 0x%x\x0A", uint32_t(dma_rd_rsp_payload->pd.dma_read_data.mask)));
        cslDebug((70, "NV_NVDLA_cvif::ReadResp_cvif2cdp, dma_rd_rsp_payload->pd.dma_read_data.data are :\x0A"));
        for (idx = 0; idx < sizeof(dma_rd_rsp_payload->pd.dma_read_data.data)/sizeof(dma_rd_rsp_payload->pd.dma_read_data.data[0]); idx++) {
            cslDebug((70, "    0x%lx\x0A", uint64_t (dma_rd_rsp_payload->pd.dma_read_data.data[idx])));   // The size of data[idx] is 8bytes and its type is "unsigned long"
        }
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2cdp, before NV_NVDLA_cvif_base::cvif2cdp_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        NV_NVDLA_cvif_base::cvif2cdp_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2cdp, after NV_NVDLA_cvif_base::cvif2cdp_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        delete dma_rd_rsp_payload;
    }
}

void NV_NVDLA_cvif::rbk2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    // DMA request size unit is 32 bytes
    uint64_t base_addr;
    uint64_t first_base_addr;
    uint64_t last_base_addr;
    uint64_t cur_address;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_base_64byte_align;
    bool     is_rear_64byte_align;
    bool     is_read=true;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    dla_b_transport_payload *bt_payload;

    payload_addr = payload->pd.dma_read_cmd.addr;
    payload_size = (payload->pd.dma_read_cmd.size + 1) * DMA_TRANSACTION_ATOM_SIZE; //payload_size's max value is 2^13

    is_base_64byte_align = payload_addr%AXI_TRANSACTION_ATOM_SIZE == 0;
    first_base_addr = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B
    cur_address = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B

    is_rear_64byte_align = (payload_addr + payload_size) % AXI_TRANSACTION_ATOM_SIZE == 0;
    total_axi_size = payload_size + (is_base_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE) + (is_rear_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE);
    last_base_addr = first_base_addr + total_axi_size - AXI_TRANSACTION_ATOM_SIZE;
    cslDebug((30, "NV_NVDLA_cvif::rbk2cvif_rd_req_b_transport, first_base_addr=0x%lx last_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, last_base_addr, total_axi_size, payload_addr, payload_size));
    // if ( total_axi_size <= (first_base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) ) {
    //     last_base_addr = first_base_addr;
    // } else if ((first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE != 0) {
    //     if (total_axi_size >= (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE) {
    //         last_base_addr = first_base_addr + total_axi_size - (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE;
    //     } else {
    //         last_base_addr = first_base_addr;
    //     }
    // } else {
    //     if (total_axi_size >= CVIF_MAX_MEM_TRANSACTION_SIZE) {
    //         last_base_addr = first_base_addr + total_axi_size - CVIF_MAX_MEM_TRANSACTION_SIZE;
    //     } else {
    //         last_base_addr = first_base_addr;
    //     }
    // }

    base_addr = first_base_addr;

    // Push the number of atoms of the request
    // rbk2cvif_rd_req_atom_num_fifo_->write(total_axi_size/DMA_TRANSACTION_ATOM_SIZE);
    rbk2cvif_rd_req_atom_num_fifo_->write(payload_size/DMA_TRANSACTION_ATOM_SIZE);
    cslDebug((50, "NV_NVDLA_cvif::rbk2cvif_rd_req_b_transport, write 0x%x to rbk2cvif_rd_req_atom_num_fifo_.\x0A", payload_size/DMA_TRANSACTION_ATOM_SIZE));

    //Split dma request to axi requests
    cslDebug((50, "NV_NVDLA_cvif::rbk2cvif_rd_req_b_transport, before spliting DMA transaction\x0A"));
    while(cur_address <= last_base_addr) {
        base_addr    = cur_address;
        size_in_byte = AXI_TRANSACTION_ATOM_SIZE;
        cslDebug((50, "NV_NVDLA_cvif::rbk2cvif_rd_req_b_transport, prepare AXI transaction for address: 0x%lx\x0A", base_addr));
        // base_addr should be aligned to 64B
        // size_in_byte should be multiple of 64
        // if the data size required by dma mster is 32B, MCIF will drop the extra 32B when AXI returns
        // size_in_byte = total_axi_size > (CVIF_MAX_MEM_TRANSACTION_SIZE) ? CVIF_MAX_MEM_TRANSACTION_SIZE : total_axi_size;
        // size_in_byte = (total_axi_size - base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) < (CVIF_MAX_MEM_TRANSACTION_SIZE) ? (total_axi_size - base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) : CVIF_MAX_MEM_TRANSACTION_SIZE;
        // if (base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE == 0) {
        //     size_in_byte = total_axi_size > CVIF_MAX_MEM_TRANSACTION_SIZE?CVIF_MAX_MEM_TRANSACTION_SIZE:total_axi_size;
        // } else if ( total_axi_size > (base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE)) {
        //     size_in_byte = base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE;
        // } else {
        //     size_in_byte = total_axi_size;
        // }
        while (((cur_address + AXI_TRANSACTION_ATOM_SIZE) < (first_base_addr + total_axi_size)) && ((cur_address + AXI_TRANSACTION_ATOM_SIZE) % CVIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            size_in_byte += AXI_TRANSACTION_ATOM_SIZE;
            cur_address  += AXI_TRANSACTION_ATOM_SIZE;
        }
        // start address of next axi transaction
        cur_address += AXI_TRANSACTION_ATOM_SIZE;
        cslDebug((50, "NV_NVDLA_cvif::rbk2cvif_rd_req_b_transport, cur_address=0x%lx base_addr=0x%lx size_in_byte=0x%x\x0A", cur_address, base_addr, size_in_byte));

        // Allocating memory for dla_b_transport_payload
        bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
        axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
        // Setup byte enable in payload. Always read 64B from cvif and cvif, but drop unneeded 32B
        // Write true to *_rd_atom_enable_fifo_ when the 32B atom is needed by dma client
        // Write false to *_rd_atom_enable_fifo_ when the 32B atom is not needed by dma client (dma's addr is not aligned to 64B
        // for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
        //     if(base_addr == last_base_addr) {   // compare with last_base_addr before first_base_addr for the case of only one axi transaction
        //         if ( (((true == is_rear_64byte_align) || (byte_iter < (size_in_byte - DMA_TRANSACTION_ATOM_SIZE))) && (first_base_addr != base_addr)) || 
        //                 ( ( ( (true == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE) ) || ( (true == is_rear_64byte_align) && (byte_iter >= DMA_TRANSACTION_ATOM_SIZE)) ) && (first_base_addr == base_addr)) ){
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::rbk2cvif_rd_req_b_transport, write true to rbk_rd_atom_enable_fifo_\x0A"));
        //                 rbk_rd_atom_enable_fifo_->write(true);
        //             }
        //         } else {
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::rbk2cvif_rd_req_b_transport, write false to rbk_rd_atom_enable_fifo_\x0A"));
        //                 rbk_rd_atom_enable_fifo_->write(false);
        //             }
        //         }
        //     }
        //     else if(base_addr == first_base_addr) {
        //         if ( (true == is_base_64byte_align) || (byte_iter >= DMA_TRANSACTION_ATOM_SIZE) ){
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::rbk2cvif_rd_req_b_transport, write true to rbk_rd_atom_enable_fifo_\x0A"));
        //                 rbk_rd_atom_enable_fifo_->write(true);
        //             }
        //         } else {
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::rbk2cvif_rd_req_b_transport, write false to rbk_rd_atom_enable_fifo_\x0A"));
        //                 rbk_rd_atom_enable_fifo_->write(false);
        //             }
        //         }
        //     }
        //     else {
        //         axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //         if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //             cslDebug((50, "NV_NVDLA_cvif::rbk2cvif_rd_req_b_transport, write true to rbk_rd_atom_enable_fifo_\x0A"));
        //             rbk_rd_atom_enable_fifo_->write(true);
        //         }
        //     }
        // }
        for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
            if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE)) {
                // Diable 1st DMA atom of the unaligned first_base_addr
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::rbk2cvif_rd_req_b_transport, write true to rbk_rd_atom_enable_fifo_\x0A"));
                    rbk_rd_atom_enable_fifo_->write(false);
                }
            } else if (( (base_addr + size_in_byte) == (last_base_addr+AXI_TRANSACTION_ATOM_SIZE)) && (false == is_rear_64byte_align) && (byte_iter >= size_in_byte - DMA_TRANSACTION_ATOM_SIZE)) {
                // Diable 2nd DMA atom of the unaligned last_base_addr
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::rbk2cvif_rd_req_b_transport, write true to rbk_rd_atom_enable_fifo_\x0A"));
                    rbk_rd_atom_enable_fifo_->write(false);
                }
            } else {
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::rbk2cvif_rd_req_b_transport, write true to rbk_rd_atom_enable_fifo_\x0A"));
                    rbk_rd_atom_enable_fifo_->write(true);
                }
            }
        }
        cslDebug((50, "NV_NVDLA_cvif::rbk2cvif_rd_req_b_transport, TLM_BYTE_ENABLE is done\x0A"));
        bt_payload->configure_gp(base_addr, size_in_byte, is_read);
        bt_payload->gp.get_extension(nvdla_dbb_ext);
        nvdla_dbb_ext->set_id(RBK_AXI_ID);
        nvdla_dbb_ext->set_size(64);
        nvdla_dbb_ext->set_length(size_in_byte/AXI_TRANSACTION_ATOM_SIZE);
#pragma CTC SKIP
        if(size_in_byte%AXI_TRANSACTION_ATOM_SIZE!=0) {
            FAIL(("NV_NVDLA_cvif::rbk2cvif_rd_req_b_transport, size_in_byte is not multiple of AXI_TRANSACTION_ATOM_SIZE. size_in_byte=0x%x", size_in_byte));
        }
#pragma CTC ENDSKIP
        cslDebug((50, "NV_NVDLA_cvif::rbk2cvif_rd_req_b_transport, before sending data to rbk_rd_req_fifo_ addr=0x%lx\x0A", base_addr));
        rbk_rd_req_fifo_->write(bt_payload);
        cslDebug((50, "NV_NVDLA_cvif::rbk2cvif_rd_req_b_transport, after sending data to rbk_rd_req_fifo_ addr=0x%lx\x0A", base_addr));

        // total_axi_size -= size_in_byte;
        // base_addr      += size_in_byte;
    }
    cslDebug((50, "NV_NVDLA_cvif::rbk2cvif_rd_req_b_transport, after spliting DMA transaction\x0A"));
}

void NV_NVDLA_cvif::ReadResp_cvif2rbk() {
    uint8_t    *axi_atom_ptr;
    uint32_t    atom_num_left;
    nvdla_dma_rd_rsp_t* dma_rd_rsp_payload = NULL;
    uint8_t           * dma_payload_data_ptr;
    uint32_t    idx;

    atom_num_left = 0;
    while(true) {
        if(0 == atom_num_left) {
            atom_num_left = rbk2cvif_rd_req_atom_num_fifo_->read();
            cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2rbk, update atom_num_left from rbk2cvif_rd_req_atom_num_fifo_, atom_num_left is 0x%x\x0A", atom_num_left));
        }
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2rbk, atom_num_left is 0x%x\x0A", atom_num_left));

        dma_rd_rsp_payload      = new nvdla_dma_rd_rsp_t;
        dma_payload_data_ptr    = reinterpret_cast <uint8_t *> (dma_rd_rsp_payload->pd.dma_read_data.data);
        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x00;

        // 1st atom of the 64B
        // Aligen to 32B
        axi_atom_ptr = cvif2rbk_rd_rsp_fifo_->read();
        credit_cvif2rbk_rd_rsp_fifo_ ++;
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2rbk, read 1st atom of the 64B from cvif2rbk_rd_rsp_fifo_\x0A"));
        atom_num_left--;

        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x1;
        memcpy (&dma_payload_data_ptr[0], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
        delete[] axi_atom_ptr;

        if(atom_num_left>0) {
            // 2nd atom of the 64B
            axi_atom_ptr = cvif2rbk_rd_rsp_fifo_->read();
            credit_cvif2rbk_rd_rsp_fifo_ ++;
            cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2rbk, read 2nd atom of the 64B from cvif2rbk_rd_rsp_fifo_\x0A"));
            atom_num_left--;
            dma_rd_rsp_payload->pd.dma_read_data.mask = (dma_rd_rsp_payload->pd.dma_read_data.mask << 0x1) + 0x1;
            memcpy (&dma_payload_data_ptr[DMA_TRANSACTION_ATOM_SIZE], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
            delete[] axi_atom_ptr;
        }

        cslDebug((70, "NV_NVDLA_cvif::ReadResp_cvif2rbk, dma_rd_rsp_payload->pd.dma_read_data.mask is 0x%x\x0A", uint32_t(dma_rd_rsp_payload->pd.dma_read_data.mask)));
        cslDebug((70, "NV_NVDLA_cvif::ReadResp_cvif2rbk, dma_rd_rsp_payload->pd.dma_read_data.data are :\x0A"));
        for (idx = 0; idx < sizeof(dma_rd_rsp_payload->pd.dma_read_data.data)/sizeof(dma_rd_rsp_payload->pd.dma_read_data.data[0]); idx++) {
            cslDebug((70, "    0x%lx\x0A", uint64_t (dma_rd_rsp_payload->pd.dma_read_data.data[idx])));   // The size of data[idx] is 8bytes and its type is "unsigned long"
        }
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2rbk, before NV_NVDLA_cvif_base::cvif2rbk_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        NV_NVDLA_cvif_base::cvif2rbk_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2rbk, after NV_NVDLA_cvif_base::cvif2rbk_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        delete dma_rd_rsp_payload;
    }
}

void NV_NVDLA_cvif::sdp_b2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    // DMA request size unit is 32 bytes
    uint64_t base_addr;
    uint64_t first_base_addr;
    uint64_t last_base_addr;
    uint64_t cur_address;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_base_64byte_align;
    bool     is_rear_64byte_align;
    bool     is_read=true;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    dla_b_transport_payload *bt_payload;

    payload_addr = payload->pd.dma_read_cmd.addr;
    payload_size = (payload->pd.dma_read_cmd.size + 1) * DMA_TRANSACTION_ATOM_SIZE; //payload_size's max value is 2^13

    is_base_64byte_align = payload_addr%AXI_TRANSACTION_ATOM_SIZE == 0;
    first_base_addr = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B
    cur_address = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B

    is_rear_64byte_align = (payload_addr + payload_size) % AXI_TRANSACTION_ATOM_SIZE == 0;
    total_axi_size = payload_size + (is_base_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE) + (is_rear_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE);
    last_base_addr = first_base_addr + total_axi_size - AXI_TRANSACTION_ATOM_SIZE;
    cslDebug((30, "NV_NVDLA_cvif::sdp_b2cvif_rd_req_b_transport, first_base_addr=0x%lx last_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, last_base_addr, total_axi_size, payload_addr, payload_size));
    // if ( total_axi_size <= (first_base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) ) {
    //     last_base_addr = first_base_addr;
    // } else if ((first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE != 0) {
    //     if (total_axi_size >= (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE) {
    //         last_base_addr = first_base_addr + total_axi_size - (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE;
    //     } else {
    //         last_base_addr = first_base_addr;
    //     }
    // } else {
    //     if (total_axi_size >= CVIF_MAX_MEM_TRANSACTION_SIZE) {
    //         last_base_addr = first_base_addr + total_axi_size - CVIF_MAX_MEM_TRANSACTION_SIZE;
    //     } else {
    //         last_base_addr = first_base_addr;
    //     }
    // }

    base_addr = first_base_addr;

    // Push the number of atoms of the request
    // sdp_b2cvif_rd_req_atom_num_fifo_->write(total_axi_size/DMA_TRANSACTION_ATOM_SIZE);
    sdp_b2cvif_rd_req_atom_num_fifo_->write(payload_size/DMA_TRANSACTION_ATOM_SIZE);
    cslDebug((50, "NV_NVDLA_cvif::sdp_b2cvif_rd_req_b_transport, write 0x%x to sdp_b2cvif_rd_req_atom_num_fifo_.\x0A", payload_size/DMA_TRANSACTION_ATOM_SIZE));

    //Split dma request to axi requests
    cslDebug((50, "NV_NVDLA_cvif::sdp_b2cvif_rd_req_b_transport, before spliting DMA transaction\x0A"));
    while(cur_address <= last_base_addr) {
        base_addr    = cur_address;
        size_in_byte = AXI_TRANSACTION_ATOM_SIZE;
        cslDebug((50, "NV_NVDLA_cvif::sdp_b2cvif_rd_req_b_transport, prepare AXI transaction for address: 0x%lx\x0A", base_addr));
        // base_addr should be aligned to 64B
        // size_in_byte should be multiple of 64
        // if the data size required by dma mster is 32B, MCIF will drop the extra 32B when AXI returns
        // size_in_byte = total_axi_size > (CVIF_MAX_MEM_TRANSACTION_SIZE) ? CVIF_MAX_MEM_TRANSACTION_SIZE : total_axi_size;
        // size_in_byte = (total_axi_size - base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) < (CVIF_MAX_MEM_TRANSACTION_SIZE) ? (total_axi_size - base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) : CVIF_MAX_MEM_TRANSACTION_SIZE;
        // if (base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE == 0) {
        //     size_in_byte = total_axi_size > CVIF_MAX_MEM_TRANSACTION_SIZE?CVIF_MAX_MEM_TRANSACTION_SIZE:total_axi_size;
        // } else if ( total_axi_size > (base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE)) {
        //     size_in_byte = base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE;
        // } else {
        //     size_in_byte = total_axi_size;
        // }
        while (((cur_address + AXI_TRANSACTION_ATOM_SIZE) < (first_base_addr + total_axi_size)) && ((cur_address + AXI_TRANSACTION_ATOM_SIZE) % CVIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            size_in_byte += AXI_TRANSACTION_ATOM_SIZE;
            cur_address  += AXI_TRANSACTION_ATOM_SIZE;
        }
        // start address of next axi transaction
        cur_address += AXI_TRANSACTION_ATOM_SIZE;
        cslDebug((50, "NV_NVDLA_cvif::sdp_b2cvif_rd_req_b_transport, cur_address=0x%lx base_addr=0x%lx size_in_byte=0x%x\x0A", cur_address, base_addr, size_in_byte));

        // Allocating memory for dla_b_transport_payload
        bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
        axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
        // Setup byte enable in payload. Always read 64B from cvif and cvif, but drop unneeded 32B
        // Write true to *_rd_atom_enable_fifo_ when the 32B atom is needed by dma client
        // Write false to *_rd_atom_enable_fifo_ when the 32B atom is not needed by dma client (dma's addr is not aligned to 64B
        // for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
        //     if(base_addr == last_base_addr) {   // compare with last_base_addr before first_base_addr for the case of only one axi transaction
        //         if ( (((true == is_rear_64byte_align) || (byte_iter < (size_in_byte - DMA_TRANSACTION_ATOM_SIZE))) && (first_base_addr != base_addr)) || 
        //                 ( ( ( (true == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE) ) || ( (true == is_rear_64byte_align) && (byte_iter >= DMA_TRANSACTION_ATOM_SIZE)) ) && (first_base_addr == base_addr)) ){
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::sdp_b2cvif_rd_req_b_transport, write true to sdp_b_rd_atom_enable_fifo_\x0A"));
        //                 sdp_b_rd_atom_enable_fifo_->write(true);
        //             }
        //         } else {
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::sdp_b2cvif_rd_req_b_transport, write false to sdp_b_rd_atom_enable_fifo_\x0A"));
        //                 sdp_b_rd_atom_enable_fifo_->write(false);
        //             }
        //         }
        //     }
        //     else if(base_addr == first_base_addr) {
        //         if ( (true == is_base_64byte_align) || (byte_iter >= DMA_TRANSACTION_ATOM_SIZE) ){
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::sdp_b2cvif_rd_req_b_transport, write true to sdp_b_rd_atom_enable_fifo_\x0A"));
        //                 sdp_b_rd_atom_enable_fifo_->write(true);
        //             }
        //         } else {
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::sdp_b2cvif_rd_req_b_transport, write false to sdp_b_rd_atom_enable_fifo_\x0A"));
        //                 sdp_b_rd_atom_enable_fifo_->write(false);
        //             }
        //         }
        //     }
        //     else {
        //         axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //         if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //             cslDebug((50, "NV_NVDLA_cvif::sdp_b2cvif_rd_req_b_transport, write true to sdp_b_rd_atom_enable_fifo_\x0A"));
        //             sdp_b_rd_atom_enable_fifo_->write(true);
        //         }
        //     }
        // }
        for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
            if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE)) {
                // Diable 1st DMA atom of the unaligned first_base_addr
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::sdp_b2cvif_rd_req_b_transport, write true to sdp_b_rd_atom_enable_fifo_\x0A"));
                    sdp_b_rd_atom_enable_fifo_->write(false);
                }
            } else if (( (base_addr + size_in_byte) == (last_base_addr+AXI_TRANSACTION_ATOM_SIZE)) && (false == is_rear_64byte_align) && (byte_iter >= size_in_byte - DMA_TRANSACTION_ATOM_SIZE)) {
                // Diable 2nd DMA atom of the unaligned last_base_addr
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::sdp_b2cvif_rd_req_b_transport, write true to sdp_b_rd_atom_enable_fifo_\x0A"));
                    sdp_b_rd_atom_enable_fifo_->write(false);
                }
            } else {
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::sdp_b2cvif_rd_req_b_transport, write true to sdp_b_rd_atom_enable_fifo_\x0A"));
                    sdp_b_rd_atom_enable_fifo_->write(true);
                }
            }
        }
        cslDebug((50, "NV_NVDLA_cvif::sdp_b2cvif_rd_req_b_transport, TLM_BYTE_ENABLE is done\x0A"));
        bt_payload->configure_gp(base_addr, size_in_byte, is_read);
        bt_payload->gp.get_extension(nvdla_dbb_ext);
        nvdla_dbb_ext->set_id(SDP_B_AXI_ID);
        nvdla_dbb_ext->set_size(64);
        nvdla_dbb_ext->set_length(size_in_byte/AXI_TRANSACTION_ATOM_SIZE);
#pragma CTC SKIP
        if(size_in_byte%AXI_TRANSACTION_ATOM_SIZE!=0) {
            FAIL(("NV_NVDLA_cvif::sdp_b2cvif_rd_req_b_transport, size_in_byte is not multiple of AXI_TRANSACTION_ATOM_SIZE. size_in_byte=0x%x", size_in_byte));
        }
#pragma CTC ENDSKIP
        cslDebug((50, "NV_NVDLA_cvif::sdp_b2cvif_rd_req_b_transport, before sending data to sdp_b_rd_req_fifo_ addr=0x%lx\x0A", base_addr));
        sdp_b_rd_req_fifo_->write(bt_payload);
        cslDebug((50, "NV_NVDLA_cvif::sdp_b2cvif_rd_req_b_transport, after sending data to sdp_b_rd_req_fifo_ addr=0x%lx\x0A", base_addr));

        // total_axi_size -= size_in_byte;
        // base_addr      += size_in_byte;
    }
    cslDebug((50, "NV_NVDLA_cvif::sdp_b2cvif_rd_req_b_transport, after spliting DMA transaction\x0A"));
}

void NV_NVDLA_cvif::ReadResp_cvif2sdp_b() {
    uint8_t    *axi_atom_ptr;
    uint32_t    atom_num_left;
    nvdla_dma_rd_rsp_t* dma_rd_rsp_payload = NULL;
    uint8_t           * dma_payload_data_ptr;
    uint32_t    idx;

    atom_num_left = 0;
    while(true) {
        if(0 == atom_num_left) {
            atom_num_left = sdp_b2cvif_rd_req_atom_num_fifo_->read();
            cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp_b, update atom_num_left from sdp_b2cvif_rd_req_atom_num_fifo_, atom_num_left is 0x%x\x0A", atom_num_left));
        }
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp_b, atom_num_left is 0x%x\x0A", atom_num_left));

        dma_rd_rsp_payload      = new nvdla_dma_rd_rsp_t;
        dma_payload_data_ptr    = reinterpret_cast <uint8_t *> (dma_rd_rsp_payload->pd.dma_read_data.data);
        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x00;

        // 1st atom of the 64B
        // Aligen to 32B
        axi_atom_ptr = cvif2sdp_b_rd_rsp_fifo_->read();
        credit_cvif2sdp_b_rd_rsp_fifo_ ++;
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp_b, read 1st atom of the 64B from cvif2sdp_b_rd_rsp_fifo_\x0A"));
        atom_num_left--;

        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x1;
        memcpy (&dma_payload_data_ptr[0], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
        delete[] axi_atom_ptr;

        if(atom_num_left>0) {
            // 2nd atom of the 64B
            axi_atom_ptr = cvif2sdp_b_rd_rsp_fifo_->read();
            credit_cvif2sdp_b_rd_rsp_fifo_ ++;
            cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp_b, read 2nd atom of the 64B from cvif2sdp_b_rd_rsp_fifo_\x0A"));
            atom_num_left--;
            dma_rd_rsp_payload->pd.dma_read_data.mask = (dma_rd_rsp_payload->pd.dma_read_data.mask << 0x1) + 0x1;
            memcpy (&dma_payload_data_ptr[DMA_TRANSACTION_ATOM_SIZE], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
            delete[] axi_atom_ptr;
        }

        cslDebug((70, "NV_NVDLA_cvif::ReadResp_cvif2sdp_b, dma_rd_rsp_payload->pd.dma_read_data.mask is 0x%x\x0A", uint32_t(dma_rd_rsp_payload->pd.dma_read_data.mask)));
        cslDebug((70, "NV_NVDLA_cvif::ReadResp_cvif2sdp_b, dma_rd_rsp_payload->pd.dma_read_data.data are :\x0A"));
        for (idx = 0; idx < sizeof(dma_rd_rsp_payload->pd.dma_read_data.data)/sizeof(dma_rd_rsp_payload->pd.dma_read_data.data[0]); idx++) {
            cslDebug((70, "    0x%lx\x0A", uint64_t (dma_rd_rsp_payload->pd.dma_read_data.data[idx])));   // The size of data[idx] is 8bytes and its type is "unsigned long"
        }
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp_b, before NV_NVDLA_cvif_base::cvif2sdp_b_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        NV_NVDLA_cvif_base::cvif2sdp_b_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp_b, after NV_NVDLA_cvif_base::cvif2sdp_b_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        delete dma_rd_rsp_payload;
    }
}

void NV_NVDLA_cvif::sdp_n2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    // DMA request size unit is 32 bytes
    uint64_t base_addr;
    uint64_t first_base_addr;
    uint64_t last_base_addr;
    uint64_t cur_address;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_base_64byte_align;
    bool     is_rear_64byte_align;
    bool     is_read=true;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    dla_b_transport_payload *bt_payload;

    payload_addr = payload->pd.dma_read_cmd.addr;
    payload_size = (payload->pd.dma_read_cmd.size + 1) * DMA_TRANSACTION_ATOM_SIZE; //payload_size's max value is 2^13

    is_base_64byte_align = payload_addr%AXI_TRANSACTION_ATOM_SIZE == 0;
    first_base_addr = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B
    cur_address = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B

    is_rear_64byte_align = (payload_addr + payload_size) % AXI_TRANSACTION_ATOM_SIZE == 0;
    total_axi_size = payload_size + (is_base_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE) + (is_rear_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE);
    last_base_addr = first_base_addr + total_axi_size - AXI_TRANSACTION_ATOM_SIZE;
    cslDebug((30, "NV_NVDLA_cvif::sdp_n2cvif_rd_req_b_transport, first_base_addr=0x%lx last_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, last_base_addr, total_axi_size, payload_addr, payload_size));
    // if ( total_axi_size <= (first_base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) ) {
    //     last_base_addr = first_base_addr;
    // } else if ((first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE != 0) {
    //     if (total_axi_size >= (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE) {
    //         last_base_addr = first_base_addr + total_axi_size - (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE;
    //     } else {
    //         last_base_addr = first_base_addr;
    //     }
    // } else {
    //     if (total_axi_size >= CVIF_MAX_MEM_TRANSACTION_SIZE) {
    //         last_base_addr = first_base_addr + total_axi_size - CVIF_MAX_MEM_TRANSACTION_SIZE;
    //     } else {
    //         last_base_addr = first_base_addr;
    //     }
    // }

    base_addr = first_base_addr;

    // Push the number of atoms of the request
    // sdp_n2cvif_rd_req_atom_num_fifo_->write(total_axi_size/DMA_TRANSACTION_ATOM_SIZE);
    sdp_n2cvif_rd_req_atom_num_fifo_->write(payload_size/DMA_TRANSACTION_ATOM_SIZE);
    cslDebug((50, "NV_NVDLA_cvif::sdp_n2cvif_rd_req_b_transport, write 0x%x to sdp_n2cvif_rd_req_atom_num_fifo_.\x0A", payload_size/DMA_TRANSACTION_ATOM_SIZE));

    //Split dma request to axi requests
    cslDebug((50, "NV_NVDLA_cvif::sdp_n2cvif_rd_req_b_transport, before spliting DMA transaction\x0A"));
    while(cur_address <= last_base_addr) {
        base_addr    = cur_address;
        size_in_byte = AXI_TRANSACTION_ATOM_SIZE;
        cslDebug((50, "NV_NVDLA_cvif::sdp_n2cvif_rd_req_b_transport, prepare AXI transaction for address: 0x%lx\x0A", base_addr));
        // base_addr should be aligned to 64B
        // size_in_byte should be multiple of 64
        // if the data size required by dma mster is 32B, MCIF will drop the extra 32B when AXI returns
        // size_in_byte = total_axi_size > (CVIF_MAX_MEM_TRANSACTION_SIZE) ? CVIF_MAX_MEM_TRANSACTION_SIZE : total_axi_size;
        // size_in_byte = (total_axi_size - base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) < (CVIF_MAX_MEM_TRANSACTION_SIZE) ? (total_axi_size - base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) : CVIF_MAX_MEM_TRANSACTION_SIZE;
        // if (base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE == 0) {
        //     size_in_byte = total_axi_size > CVIF_MAX_MEM_TRANSACTION_SIZE?CVIF_MAX_MEM_TRANSACTION_SIZE:total_axi_size;
        // } else if ( total_axi_size > (base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE)) {
        //     size_in_byte = base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE;
        // } else {
        //     size_in_byte = total_axi_size;
        // }
        while (((cur_address + AXI_TRANSACTION_ATOM_SIZE) < (first_base_addr + total_axi_size)) && ((cur_address + AXI_TRANSACTION_ATOM_SIZE) % CVIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            size_in_byte += AXI_TRANSACTION_ATOM_SIZE;
            cur_address  += AXI_TRANSACTION_ATOM_SIZE;
        }
        // start address of next axi transaction
        cur_address += AXI_TRANSACTION_ATOM_SIZE;
        cslDebug((50, "NV_NVDLA_cvif::sdp_n2cvif_rd_req_b_transport, cur_address=0x%lx base_addr=0x%lx size_in_byte=0x%x\x0A", cur_address, base_addr, size_in_byte));

        // Allocating memory for dla_b_transport_payload
        bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
        axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
        // Setup byte enable in payload. Always read 64B from cvif and cvif, but drop unneeded 32B
        // Write true to *_rd_atom_enable_fifo_ when the 32B atom is needed by dma client
        // Write false to *_rd_atom_enable_fifo_ when the 32B atom is not needed by dma client (dma's addr is not aligned to 64B
        // for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
        //     if(base_addr == last_base_addr) {   // compare with last_base_addr before first_base_addr for the case of only one axi transaction
        //         if ( (((true == is_rear_64byte_align) || (byte_iter < (size_in_byte - DMA_TRANSACTION_ATOM_SIZE))) && (first_base_addr != base_addr)) || 
        //                 ( ( ( (true == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE) ) || ( (true == is_rear_64byte_align) && (byte_iter >= DMA_TRANSACTION_ATOM_SIZE)) ) && (first_base_addr == base_addr)) ){
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::sdp_n2cvif_rd_req_b_transport, write true to sdp_n_rd_atom_enable_fifo_\x0A"));
        //                 sdp_n_rd_atom_enable_fifo_->write(true);
        //             }
        //         } else {
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::sdp_n2cvif_rd_req_b_transport, write false to sdp_n_rd_atom_enable_fifo_\x0A"));
        //                 sdp_n_rd_atom_enable_fifo_->write(false);
        //             }
        //         }
        //     }
        //     else if(base_addr == first_base_addr) {
        //         if ( (true == is_base_64byte_align) || (byte_iter >= DMA_TRANSACTION_ATOM_SIZE) ){
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::sdp_n2cvif_rd_req_b_transport, write true to sdp_n_rd_atom_enable_fifo_\x0A"));
        //                 sdp_n_rd_atom_enable_fifo_->write(true);
        //             }
        //         } else {
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::sdp_n2cvif_rd_req_b_transport, write false to sdp_n_rd_atom_enable_fifo_\x0A"));
        //                 sdp_n_rd_atom_enable_fifo_->write(false);
        //             }
        //         }
        //     }
        //     else {
        //         axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //         if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //             cslDebug((50, "NV_NVDLA_cvif::sdp_n2cvif_rd_req_b_transport, write true to sdp_n_rd_atom_enable_fifo_\x0A"));
        //             sdp_n_rd_atom_enable_fifo_->write(true);
        //         }
        //     }
        // }
        for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
            if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE)) {
                // Diable 1st DMA atom of the unaligned first_base_addr
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::sdp_n2cvif_rd_req_b_transport, write true to sdp_n_rd_atom_enable_fifo_\x0A"));
                    sdp_n_rd_atom_enable_fifo_->write(false);
                }
            } else if (( (base_addr + size_in_byte) == (last_base_addr+AXI_TRANSACTION_ATOM_SIZE)) && (false == is_rear_64byte_align) && (byte_iter >= size_in_byte - DMA_TRANSACTION_ATOM_SIZE)) {
                // Diable 2nd DMA atom of the unaligned last_base_addr
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::sdp_n2cvif_rd_req_b_transport, write true to sdp_n_rd_atom_enable_fifo_\x0A"));
                    sdp_n_rd_atom_enable_fifo_->write(false);
                }
            } else {
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::sdp_n2cvif_rd_req_b_transport, write true to sdp_n_rd_atom_enable_fifo_\x0A"));
                    sdp_n_rd_atom_enable_fifo_->write(true);
                }
            }
        }
        cslDebug((50, "NV_NVDLA_cvif::sdp_n2cvif_rd_req_b_transport, TLM_BYTE_ENABLE is done\x0A"));
        bt_payload->configure_gp(base_addr, size_in_byte, is_read);
        bt_payload->gp.get_extension(nvdla_dbb_ext);
        nvdla_dbb_ext->set_id(SDP_N_AXI_ID);
        nvdla_dbb_ext->set_size(64);
        nvdla_dbb_ext->set_length(size_in_byte/AXI_TRANSACTION_ATOM_SIZE);
#pragma CTC SKIP
        if(size_in_byte%AXI_TRANSACTION_ATOM_SIZE!=0) {
            FAIL(("NV_NVDLA_cvif::sdp_n2cvif_rd_req_b_transport, size_in_byte is not multiple of AXI_TRANSACTION_ATOM_SIZE. size_in_byte=0x%x", size_in_byte));
        }
#pragma CTC ENDSKIP
        cslDebug((50, "NV_NVDLA_cvif::sdp_n2cvif_rd_req_b_transport, before sending data to sdp_n_rd_req_fifo_ addr=0x%lx\x0A", base_addr));
        sdp_n_rd_req_fifo_->write(bt_payload);
        cslDebug((50, "NV_NVDLA_cvif::sdp_n2cvif_rd_req_b_transport, after sending data to sdp_n_rd_req_fifo_ addr=0x%lx\x0A", base_addr));

        // total_axi_size -= size_in_byte;
        // base_addr      += size_in_byte;
    }
    cslDebug((50, "NV_NVDLA_cvif::sdp_n2cvif_rd_req_b_transport, after spliting DMA transaction\x0A"));
}

void NV_NVDLA_cvif::ReadResp_cvif2sdp_n() {
    uint8_t    *axi_atom_ptr;
    uint32_t    atom_num_left;
    nvdla_dma_rd_rsp_t* dma_rd_rsp_payload = NULL;
    uint8_t           * dma_payload_data_ptr;
    uint32_t    idx;

    atom_num_left = 0;
    while(true) {
        if(0 == atom_num_left) {
            atom_num_left = sdp_n2cvif_rd_req_atom_num_fifo_->read();
            cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp_n, update atom_num_left from sdp_n2cvif_rd_req_atom_num_fifo_, atom_num_left is 0x%x\x0A", atom_num_left));
        }
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp_n, atom_num_left is 0x%x\x0A", atom_num_left));

        dma_rd_rsp_payload      = new nvdla_dma_rd_rsp_t;
        dma_payload_data_ptr    = reinterpret_cast <uint8_t *> (dma_rd_rsp_payload->pd.dma_read_data.data);
        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x00;

        // 1st atom of the 64B
        // Aligen to 32B
        axi_atom_ptr = cvif2sdp_n_rd_rsp_fifo_->read();
        credit_cvif2sdp_n_rd_rsp_fifo_ ++;
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp_n, read 1st atom of the 64B from cvif2sdp_n_rd_rsp_fifo_\x0A"));
        atom_num_left--;

        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x1;
        memcpy (&dma_payload_data_ptr[0], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
        delete[] axi_atom_ptr;

        if(atom_num_left>0) {
            // 2nd atom of the 64B
            axi_atom_ptr = cvif2sdp_n_rd_rsp_fifo_->read();
            credit_cvif2sdp_n_rd_rsp_fifo_ ++;
            cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp_n, read 2nd atom of the 64B from cvif2sdp_n_rd_rsp_fifo_\x0A"));
            atom_num_left--;
            dma_rd_rsp_payload->pd.dma_read_data.mask = (dma_rd_rsp_payload->pd.dma_read_data.mask << 0x1) + 0x1;
            memcpy (&dma_payload_data_ptr[DMA_TRANSACTION_ATOM_SIZE], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
            delete[] axi_atom_ptr;
        }

        cslDebug((70, "NV_NVDLA_cvif::ReadResp_cvif2sdp_n, dma_rd_rsp_payload->pd.dma_read_data.mask is 0x%x\x0A", uint32_t(dma_rd_rsp_payload->pd.dma_read_data.mask)));
        cslDebug((70, "NV_NVDLA_cvif::ReadResp_cvif2sdp_n, dma_rd_rsp_payload->pd.dma_read_data.data are :\x0A"));
        for (idx = 0; idx < sizeof(dma_rd_rsp_payload->pd.dma_read_data.data)/sizeof(dma_rd_rsp_payload->pd.dma_read_data.data[0]); idx++) {
            cslDebug((70, "    0x%lx\x0A", uint64_t (dma_rd_rsp_payload->pd.dma_read_data.data[idx])));   // The size of data[idx] is 8bytes and its type is "unsigned long"
        }
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp_n, before NV_NVDLA_cvif_base::cvif2sdp_n_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        NV_NVDLA_cvif_base::cvif2sdp_n_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp_n, after NV_NVDLA_cvif_base::cvif2sdp_n_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        delete dma_rd_rsp_payload;
    }
}

void NV_NVDLA_cvif::sdp_e2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    // DMA request size unit is 32 bytes
    uint64_t base_addr;
    uint64_t first_base_addr;
    uint64_t last_base_addr;
    uint64_t cur_address;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_base_64byte_align;
    bool     is_rear_64byte_align;
    bool     is_read=true;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    dla_b_transport_payload *bt_payload;

    payload_addr = payload->pd.dma_read_cmd.addr;
    payload_size = (payload->pd.dma_read_cmd.size + 1) * DMA_TRANSACTION_ATOM_SIZE; //payload_size's max value is 2^13

    is_base_64byte_align = payload_addr%AXI_TRANSACTION_ATOM_SIZE == 0;
    first_base_addr = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B
    cur_address = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B

    is_rear_64byte_align = (payload_addr + payload_size) % AXI_TRANSACTION_ATOM_SIZE == 0;
    total_axi_size = payload_size + (is_base_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE) + (is_rear_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE);
    last_base_addr = first_base_addr + total_axi_size - AXI_TRANSACTION_ATOM_SIZE;
    cslDebug((30, "NV_NVDLA_cvif::sdp_e2cvif_rd_req_b_transport, first_base_addr=0x%lx last_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, last_base_addr, total_axi_size, payload_addr, payload_size));
    // if ( total_axi_size <= (first_base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) ) {
    //     last_base_addr = first_base_addr;
    // } else if ((first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE != 0) {
    //     if (total_axi_size >= (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE) {
    //         last_base_addr = first_base_addr + total_axi_size - (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE;
    //     } else {
    //         last_base_addr = first_base_addr;
    //     }
    // } else {
    //     if (total_axi_size >= CVIF_MAX_MEM_TRANSACTION_SIZE) {
    //         last_base_addr = first_base_addr + total_axi_size - CVIF_MAX_MEM_TRANSACTION_SIZE;
    //     } else {
    //         last_base_addr = first_base_addr;
    //     }
    // }

    base_addr = first_base_addr;

    // Push the number of atoms of the request
    // sdp_e2cvif_rd_req_atom_num_fifo_->write(total_axi_size/DMA_TRANSACTION_ATOM_SIZE);
    sdp_e2cvif_rd_req_atom_num_fifo_->write(payload_size/DMA_TRANSACTION_ATOM_SIZE);
    cslDebug((50, "NV_NVDLA_cvif::sdp_e2cvif_rd_req_b_transport, write 0x%x to sdp_e2cvif_rd_req_atom_num_fifo_.\x0A", payload_size/DMA_TRANSACTION_ATOM_SIZE));

    //Split dma request to axi requests
    cslDebug((50, "NV_NVDLA_cvif::sdp_e2cvif_rd_req_b_transport, before spliting DMA transaction\x0A"));
    while(cur_address <= last_base_addr) {
        base_addr    = cur_address;
        size_in_byte = AXI_TRANSACTION_ATOM_SIZE;
        cslDebug((50, "NV_NVDLA_cvif::sdp_e2cvif_rd_req_b_transport, prepare AXI transaction for address: 0x%lx\x0A", base_addr));
        // base_addr should be aligned to 64B
        // size_in_byte should be multiple of 64
        // if the data size required by dma mster is 32B, MCIF will drop the extra 32B when AXI returns
        // size_in_byte = total_axi_size > (CVIF_MAX_MEM_TRANSACTION_SIZE) ? CVIF_MAX_MEM_TRANSACTION_SIZE : total_axi_size;
        // size_in_byte = (total_axi_size - base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) < (CVIF_MAX_MEM_TRANSACTION_SIZE) ? (total_axi_size - base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) : CVIF_MAX_MEM_TRANSACTION_SIZE;
        // if (base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE == 0) {
        //     size_in_byte = total_axi_size > CVIF_MAX_MEM_TRANSACTION_SIZE?CVIF_MAX_MEM_TRANSACTION_SIZE:total_axi_size;
        // } else if ( total_axi_size > (base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE)) {
        //     size_in_byte = base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE;
        // } else {
        //     size_in_byte = total_axi_size;
        // }
        while (((cur_address + AXI_TRANSACTION_ATOM_SIZE) < (first_base_addr + total_axi_size)) && ((cur_address + AXI_TRANSACTION_ATOM_SIZE) % CVIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            size_in_byte += AXI_TRANSACTION_ATOM_SIZE;
            cur_address  += AXI_TRANSACTION_ATOM_SIZE;
        }
        // start address of next axi transaction
        cur_address += AXI_TRANSACTION_ATOM_SIZE;
        cslDebug((50, "NV_NVDLA_cvif::sdp_e2cvif_rd_req_b_transport, cur_address=0x%lx base_addr=0x%lx size_in_byte=0x%x\x0A", cur_address, base_addr, size_in_byte));

        // Allocating memory for dla_b_transport_payload
        bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
        axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
        // Setup byte enable in payload. Always read 64B from cvif and cvif, but drop unneeded 32B
        // Write true to *_rd_atom_enable_fifo_ when the 32B atom is needed by dma client
        // Write false to *_rd_atom_enable_fifo_ when the 32B atom is not needed by dma client (dma's addr is not aligned to 64B
        // for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
        //     if(base_addr == last_base_addr) {   // compare with last_base_addr before first_base_addr for the case of only one axi transaction
        //         if ( (((true == is_rear_64byte_align) || (byte_iter < (size_in_byte - DMA_TRANSACTION_ATOM_SIZE))) && (first_base_addr != base_addr)) || 
        //                 ( ( ( (true == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE) ) || ( (true == is_rear_64byte_align) && (byte_iter >= DMA_TRANSACTION_ATOM_SIZE)) ) && (first_base_addr == base_addr)) ){
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::sdp_e2cvif_rd_req_b_transport, write true to sdp_e_rd_atom_enable_fifo_\x0A"));
        //                 sdp_e_rd_atom_enable_fifo_->write(true);
        //             }
        //         } else {
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::sdp_e2cvif_rd_req_b_transport, write false to sdp_e_rd_atom_enable_fifo_\x0A"));
        //                 sdp_e_rd_atom_enable_fifo_->write(false);
        //             }
        //         }
        //     }
        //     else if(base_addr == first_base_addr) {
        //         if ( (true == is_base_64byte_align) || (byte_iter >= DMA_TRANSACTION_ATOM_SIZE) ){
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::sdp_e2cvif_rd_req_b_transport, write true to sdp_e_rd_atom_enable_fifo_\x0A"));
        //                 sdp_e_rd_atom_enable_fifo_->write(true);
        //             }
        //         } else {
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::sdp_e2cvif_rd_req_b_transport, write false to sdp_e_rd_atom_enable_fifo_\x0A"));
        //                 sdp_e_rd_atom_enable_fifo_->write(false);
        //             }
        //         }
        //     }
        //     else {
        //         axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //         if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //             cslDebug((50, "NV_NVDLA_cvif::sdp_e2cvif_rd_req_b_transport, write true to sdp_e_rd_atom_enable_fifo_\x0A"));
        //             sdp_e_rd_atom_enable_fifo_->write(true);
        //         }
        //     }
        // }
        for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
            if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE)) {
                // Diable 1st DMA atom of the unaligned first_base_addr
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::sdp_e2cvif_rd_req_b_transport, write true to sdp_e_rd_atom_enable_fifo_\x0A"));
                    sdp_e_rd_atom_enable_fifo_->write(false);
                }
            } else if (( (base_addr + size_in_byte) == (last_base_addr+AXI_TRANSACTION_ATOM_SIZE)) && (false == is_rear_64byte_align) && (byte_iter >= size_in_byte - DMA_TRANSACTION_ATOM_SIZE)) {
                // Diable 2nd DMA atom of the unaligned last_base_addr
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::sdp_e2cvif_rd_req_b_transport, write true to sdp_e_rd_atom_enable_fifo_\x0A"));
                    sdp_e_rd_atom_enable_fifo_->write(false);
                }
            } else {
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::sdp_e2cvif_rd_req_b_transport, write true to sdp_e_rd_atom_enable_fifo_\x0A"));
                    sdp_e_rd_atom_enable_fifo_->write(true);
                }
            }
        }
        cslDebug((50, "NV_NVDLA_cvif::sdp_e2cvif_rd_req_b_transport, TLM_BYTE_ENABLE is done\x0A"));
        bt_payload->configure_gp(base_addr, size_in_byte, is_read);
        bt_payload->gp.get_extension(nvdla_dbb_ext);
        nvdla_dbb_ext->set_id(SDP_E_AXI_ID);
        nvdla_dbb_ext->set_size(64);
        nvdla_dbb_ext->set_length(size_in_byte/AXI_TRANSACTION_ATOM_SIZE);
#pragma CTC SKIP
        if(size_in_byte%AXI_TRANSACTION_ATOM_SIZE!=0) {
            FAIL(("NV_NVDLA_cvif::sdp_e2cvif_rd_req_b_transport, size_in_byte is not multiple of AXI_TRANSACTION_ATOM_SIZE. size_in_byte=0x%x", size_in_byte));
        }
#pragma CTC ENDSKIP
        cslDebug((50, "NV_NVDLA_cvif::sdp_e2cvif_rd_req_b_transport, before sending data to sdp_e_rd_req_fifo_ addr=0x%lx\x0A", base_addr));
        sdp_e_rd_req_fifo_->write(bt_payload);
        cslDebug((50, "NV_NVDLA_cvif::sdp_e2cvif_rd_req_b_transport, after sending data to sdp_e_rd_req_fifo_ addr=0x%lx\x0A", base_addr));

        // total_axi_size -= size_in_byte;
        // base_addr      += size_in_byte;
    }
    cslDebug((50, "NV_NVDLA_cvif::sdp_e2cvif_rd_req_b_transport, after spliting DMA transaction\x0A"));
}

void NV_NVDLA_cvif::ReadResp_cvif2sdp_e() {
    uint8_t    *axi_atom_ptr;
    uint32_t    atom_num_left;
    nvdla_dma_rd_rsp_t* dma_rd_rsp_payload = NULL;
    uint8_t           * dma_payload_data_ptr;
    uint32_t    idx;

    atom_num_left = 0;
    while(true) {
        if(0 == atom_num_left) {
            atom_num_left = sdp_e2cvif_rd_req_atom_num_fifo_->read();
            cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp_e, update atom_num_left from sdp_e2cvif_rd_req_atom_num_fifo_, atom_num_left is 0x%x\x0A", atom_num_left));
        }
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp_e, atom_num_left is 0x%x\x0A", atom_num_left));

        dma_rd_rsp_payload      = new nvdla_dma_rd_rsp_t;
        dma_payload_data_ptr    = reinterpret_cast <uint8_t *> (dma_rd_rsp_payload->pd.dma_read_data.data);
        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x00;

        // 1st atom of the 64B
        // Aligen to 32B
        axi_atom_ptr = cvif2sdp_e_rd_rsp_fifo_->read();
        credit_cvif2sdp_e_rd_rsp_fifo_ ++;
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp_e, read 1st atom of the 64B from cvif2sdp_e_rd_rsp_fifo_\x0A"));
        atom_num_left--;

        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x1;
        memcpy (&dma_payload_data_ptr[0], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
        delete[] axi_atom_ptr;

        if(atom_num_left>0) {
            // 2nd atom of the 64B
            axi_atom_ptr = cvif2sdp_e_rd_rsp_fifo_->read();
            credit_cvif2sdp_e_rd_rsp_fifo_ ++;
            cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp_e, read 2nd atom of the 64B from cvif2sdp_e_rd_rsp_fifo_\x0A"));
            atom_num_left--;
            dma_rd_rsp_payload->pd.dma_read_data.mask = (dma_rd_rsp_payload->pd.dma_read_data.mask << 0x1) + 0x1;
            memcpy (&dma_payload_data_ptr[DMA_TRANSACTION_ATOM_SIZE], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
            delete[] axi_atom_ptr;
        }

        cslDebug((70, "NV_NVDLA_cvif::ReadResp_cvif2sdp_e, dma_rd_rsp_payload->pd.dma_read_data.mask is 0x%x\x0A", uint32_t(dma_rd_rsp_payload->pd.dma_read_data.mask)));
        cslDebug((70, "NV_NVDLA_cvif::ReadResp_cvif2sdp_e, dma_rd_rsp_payload->pd.dma_read_data.data are :\x0A"));
        for (idx = 0; idx < sizeof(dma_rd_rsp_payload->pd.dma_read_data.data)/sizeof(dma_rd_rsp_payload->pd.dma_read_data.data[0]); idx++) {
            cslDebug((70, "    0x%lx\x0A", uint64_t (dma_rd_rsp_payload->pd.dma_read_data.data[idx])));   // The size of data[idx] is 8bytes and its type is "unsigned long"
        }
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp_e, before NV_NVDLA_cvif_base::cvif2sdp_e_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        NV_NVDLA_cvif_base::cvif2sdp_e_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2sdp_e, after NV_NVDLA_cvif_base::cvif2sdp_e_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        delete dma_rd_rsp_payload;
    }
}

void NV_NVDLA_cvif::cdma_dat2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    // DMA request size unit is 32 bytes
    uint64_t base_addr;
    uint64_t first_base_addr;
    uint64_t last_base_addr;
    uint64_t cur_address;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_base_64byte_align;
    bool     is_rear_64byte_align;
    bool     is_read=true;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    dla_b_transport_payload *bt_payload;

    payload_addr = payload->pd.dma_read_cmd.addr;
    payload_size = (payload->pd.dma_read_cmd.size + 1) * DMA_TRANSACTION_ATOM_SIZE; //payload_size's max value is 2^13

    is_base_64byte_align = payload_addr%AXI_TRANSACTION_ATOM_SIZE == 0;
    first_base_addr = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B
    cur_address = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B

    is_rear_64byte_align = (payload_addr + payload_size) % AXI_TRANSACTION_ATOM_SIZE == 0;
    total_axi_size = payload_size + (is_base_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE) + (is_rear_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE);
    last_base_addr = first_base_addr + total_axi_size - AXI_TRANSACTION_ATOM_SIZE;
    cslDebug((30, "NV_NVDLA_cvif::cdma_dat2cvif_rd_req_b_transport, first_base_addr=0x%lx last_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, last_base_addr, total_axi_size, payload_addr, payload_size));
    // if ( total_axi_size <= (first_base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) ) {
    //     last_base_addr = first_base_addr;
    // } else if ((first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE != 0) {
    //     if (total_axi_size >= (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE) {
    //         last_base_addr = first_base_addr + total_axi_size - (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE;
    //     } else {
    //         last_base_addr = first_base_addr;
    //     }
    // } else {
    //     if (total_axi_size >= CVIF_MAX_MEM_TRANSACTION_SIZE) {
    //         last_base_addr = first_base_addr + total_axi_size - CVIF_MAX_MEM_TRANSACTION_SIZE;
    //     } else {
    //         last_base_addr = first_base_addr;
    //     }
    // }

    base_addr = first_base_addr;

    // Push the number of atoms of the request
    // cdma_dat2cvif_rd_req_atom_num_fifo_->write(total_axi_size/DMA_TRANSACTION_ATOM_SIZE);
    cdma_dat2cvif_rd_req_atom_num_fifo_->write(payload_size/DMA_TRANSACTION_ATOM_SIZE);
    cslDebug((50, "NV_NVDLA_cvif::cdma_dat2cvif_rd_req_b_transport, write 0x%x to cdma_dat2cvif_rd_req_atom_num_fifo_.\x0A", payload_size/DMA_TRANSACTION_ATOM_SIZE));

    //Split dma request to axi requests
    cslDebug((50, "NV_NVDLA_cvif::cdma_dat2cvif_rd_req_b_transport, before spliting DMA transaction\x0A"));
    while(cur_address <= last_base_addr) {
        base_addr    = cur_address;
        size_in_byte = AXI_TRANSACTION_ATOM_SIZE;
        cslDebug((50, "NV_NVDLA_cvif::cdma_dat2cvif_rd_req_b_transport, prepare AXI transaction for address: 0x%lx\x0A", base_addr));
        // base_addr should be aligned to 64B
        // size_in_byte should be multiple of 64
        // if the data size required by dma mster is 32B, MCIF will drop the extra 32B when AXI returns
        // size_in_byte = total_axi_size > (CVIF_MAX_MEM_TRANSACTION_SIZE) ? CVIF_MAX_MEM_TRANSACTION_SIZE : total_axi_size;
        // size_in_byte = (total_axi_size - base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) < (CVIF_MAX_MEM_TRANSACTION_SIZE) ? (total_axi_size - base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) : CVIF_MAX_MEM_TRANSACTION_SIZE;
        // if (base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE == 0) {
        //     size_in_byte = total_axi_size > CVIF_MAX_MEM_TRANSACTION_SIZE?CVIF_MAX_MEM_TRANSACTION_SIZE:total_axi_size;
        // } else if ( total_axi_size > (base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE)) {
        //     size_in_byte = base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE;
        // } else {
        //     size_in_byte = total_axi_size;
        // }
        while (((cur_address + AXI_TRANSACTION_ATOM_SIZE) < (first_base_addr + total_axi_size)) && ((cur_address + AXI_TRANSACTION_ATOM_SIZE) % CVIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            size_in_byte += AXI_TRANSACTION_ATOM_SIZE;
            cur_address  += AXI_TRANSACTION_ATOM_SIZE;
        }
        // start address of next axi transaction
        cur_address += AXI_TRANSACTION_ATOM_SIZE;
        cslDebug((50, "NV_NVDLA_cvif::cdma_dat2cvif_rd_req_b_transport, cur_address=0x%lx base_addr=0x%lx size_in_byte=0x%x\x0A", cur_address, base_addr, size_in_byte));

        // Allocating memory for dla_b_transport_payload
        bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
        axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
        // Setup byte enable in payload. Always read 64B from cvif and cvif, but drop unneeded 32B
        // Write true to *_rd_atom_enable_fifo_ when the 32B atom is needed by dma client
        // Write false to *_rd_atom_enable_fifo_ when the 32B atom is not needed by dma client (dma's addr is not aligned to 64B
        // for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
        //     if(base_addr == last_base_addr) {   // compare with last_base_addr before first_base_addr for the case of only one axi transaction
        //         if ( (((true == is_rear_64byte_align) || (byte_iter < (size_in_byte - DMA_TRANSACTION_ATOM_SIZE))) && (first_base_addr != base_addr)) || 
        //                 ( ( ( (true == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE) ) || ( (true == is_rear_64byte_align) && (byte_iter >= DMA_TRANSACTION_ATOM_SIZE)) ) && (first_base_addr == base_addr)) ){
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::cdma_dat2cvif_rd_req_b_transport, write true to cdma_dat_rd_atom_enable_fifo_\x0A"));
        //                 cdma_dat_rd_atom_enable_fifo_->write(true);
        //             }
        //         } else {
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::cdma_dat2cvif_rd_req_b_transport, write false to cdma_dat_rd_atom_enable_fifo_\x0A"));
        //                 cdma_dat_rd_atom_enable_fifo_->write(false);
        //             }
        //         }
        //     }
        //     else if(base_addr == first_base_addr) {
        //         if ( (true == is_base_64byte_align) || (byte_iter >= DMA_TRANSACTION_ATOM_SIZE) ){
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::cdma_dat2cvif_rd_req_b_transport, write true to cdma_dat_rd_atom_enable_fifo_\x0A"));
        //                 cdma_dat_rd_atom_enable_fifo_->write(true);
        //             }
        //         } else {
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::cdma_dat2cvif_rd_req_b_transport, write false to cdma_dat_rd_atom_enable_fifo_\x0A"));
        //                 cdma_dat_rd_atom_enable_fifo_->write(false);
        //             }
        //         }
        //     }
        //     else {
        //         axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //         if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //             cslDebug((50, "NV_NVDLA_cvif::cdma_dat2cvif_rd_req_b_transport, write true to cdma_dat_rd_atom_enable_fifo_\x0A"));
        //             cdma_dat_rd_atom_enable_fifo_->write(true);
        //         }
        //     }
        // }
        for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
            if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE)) {
                // Diable 1st DMA atom of the unaligned first_base_addr
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::cdma_dat2cvif_rd_req_b_transport, write true to cdma_dat_rd_atom_enable_fifo_\x0A"));
                    cdma_dat_rd_atom_enable_fifo_->write(false);
                }
            } else if (( (base_addr + size_in_byte) == (last_base_addr+AXI_TRANSACTION_ATOM_SIZE)) && (false == is_rear_64byte_align) && (byte_iter >= size_in_byte - DMA_TRANSACTION_ATOM_SIZE)) {
                // Diable 2nd DMA atom of the unaligned last_base_addr
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::cdma_dat2cvif_rd_req_b_transport, write true to cdma_dat_rd_atom_enable_fifo_\x0A"));
                    cdma_dat_rd_atom_enable_fifo_->write(false);
                }
            } else {
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::cdma_dat2cvif_rd_req_b_transport, write true to cdma_dat_rd_atom_enable_fifo_\x0A"));
                    cdma_dat_rd_atom_enable_fifo_->write(true);
                }
            }
        }
        cslDebug((50, "NV_NVDLA_cvif::cdma_dat2cvif_rd_req_b_transport, TLM_BYTE_ENABLE is done\x0A"));
        bt_payload->configure_gp(base_addr, size_in_byte, is_read);
        bt_payload->gp.get_extension(nvdla_dbb_ext);
        nvdla_dbb_ext->set_id(CDMA_DAT_AXI_ID);
        nvdla_dbb_ext->set_size(64);
        nvdla_dbb_ext->set_length(size_in_byte/AXI_TRANSACTION_ATOM_SIZE);
#pragma CTC SKIP
        if(size_in_byte%AXI_TRANSACTION_ATOM_SIZE!=0) {
            FAIL(("NV_NVDLA_cvif::cdma_dat2cvif_rd_req_b_transport, size_in_byte is not multiple of AXI_TRANSACTION_ATOM_SIZE. size_in_byte=0x%x", size_in_byte));
        }
#pragma CTC ENDSKIP
        cslDebug((50, "NV_NVDLA_cvif::cdma_dat2cvif_rd_req_b_transport, before sending data to cdma_dat_rd_req_fifo_ addr=0x%lx\x0A", base_addr));
        cdma_dat_rd_req_fifo_->write(bt_payload);
        cslDebug((50, "NV_NVDLA_cvif::cdma_dat2cvif_rd_req_b_transport, after sending data to cdma_dat_rd_req_fifo_ addr=0x%lx\x0A", base_addr));

        // total_axi_size -= size_in_byte;
        // base_addr      += size_in_byte;
    }
    cslDebug((50, "NV_NVDLA_cvif::cdma_dat2cvif_rd_req_b_transport, after spliting DMA transaction\x0A"));
}

void NV_NVDLA_cvif::ReadResp_cvif2cdma_dat() {
    uint8_t    *axi_atom_ptr;
    uint32_t    atom_num_left;
    nvdla_dma_rd_rsp_t* dma_rd_rsp_payload = NULL;
    uint8_t           * dma_payload_data_ptr;
    uint32_t    idx;

    atom_num_left = 0;
    while(true) {
        if(0 == atom_num_left) {
            atom_num_left = cdma_dat2cvif_rd_req_atom_num_fifo_->read();
            cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2cdma_dat, update atom_num_left from cdma_dat2cvif_rd_req_atom_num_fifo_, atom_num_left is 0x%x\x0A", atom_num_left));
        }
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2cdma_dat, atom_num_left is 0x%x\x0A", atom_num_left));

        dma_rd_rsp_payload      = new nvdla_dma_rd_rsp_t;
        dma_payload_data_ptr    = reinterpret_cast <uint8_t *> (dma_rd_rsp_payload->pd.dma_read_data.data);
        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x00;

        // 1st atom of the 64B
        // Aligen to 32B
        axi_atom_ptr = cvif2cdma_dat_rd_rsp_fifo_->read();
        credit_cvif2cdma_dat_rd_rsp_fifo_ ++;
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2cdma_dat, read 1st atom of the 64B from cvif2cdma_dat_rd_rsp_fifo_\x0A"));
        atom_num_left--;

        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x1;
        memcpy (&dma_payload_data_ptr[0], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
        delete[] axi_atom_ptr;

        if(atom_num_left>0) {
            // 2nd atom of the 64B
            axi_atom_ptr = cvif2cdma_dat_rd_rsp_fifo_->read();
            credit_cvif2cdma_dat_rd_rsp_fifo_ ++;
            cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2cdma_dat, read 2nd atom of the 64B from cvif2cdma_dat_rd_rsp_fifo_\x0A"));
            atom_num_left--;
            dma_rd_rsp_payload->pd.dma_read_data.mask = (dma_rd_rsp_payload->pd.dma_read_data.mask << 0x1) + 0x1;
            memcpy (&dma_payload_data_ptr[DMA_TRANSACTION_ATOM_SIZE], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
            delete[] axi_atom_ptr;
        }

        cslDebug((70, "NV_NVDLA_cvif::ReadResp_cvif2cdma_dat, dma_rd_rsp_payload->pd.dma_read_data.mask is 0x%x\x0A", uint32_t(dma_rd_rsp_payload->pd.dma_read_data.mask)));
        cslDebug((70, "NV_NVDLA_cvif::ReadResp_cvif2cdma_dat, dma_rd_rsp_payload->pd.dma_read_data.data are :\x0A"));
        for (idx = 0; idx < sizeof(dma_rd_rsp_payload->pd.dma_read_data.data)/sizeof(dma_rd_rsp_payload->pd.dma_read_data.data[0]); idx++) {
            cslDebug((70, "    0x%lx\x0A", uint64_t (dma_rd_rsp_payload->pd.dma_read_data.data[idx])));   // The size of data[idx] is 8bytes and its type is "unsigned long"
        }
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2cdma_dat, before NV_NVDLA_cvif_base::cvif2cdma_dat_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        NV_NVDLA_cvif_base::cvif2cdma_dat_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2cdma_dat, after NV_NVDLA_cvif_base::cvif2cdma_dat_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        delete dma_rd_rsp_payload;
    }
}

void NV_NVDLA_cvif::cdma_wt2cvif_rd_req_b_transport(int ID, nvdla_dma_rd_req_t* payload, sc_time& delay) {
    // DMA request size unit is 32 bytes
    uint64_t base_addr;
    uint64_t first_base_addr;
    uint64_t last_base_addr;
    uint64_t cur_address;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    bool     is_base_64byte_align;
    bool     is_rear_64byte_align;
    bool     is_read=true;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    dla_b_transport_payload *bt_payload;

    payload_addr = payload->pd.dma_read_cmd.addr;
    payload_size = (payload->pd.dma_read_cmd.size + 1) * DMA_TRANSACTION_ATOM_SIZE; //payload_size's max value is 2^13

    is_base_64byte_align = payload_addr%AXI_TRANSACTION_ATOM_SIZE == 0;
    first_base_addr = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B
    cur_address = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B

    is_rear_64byte_align = (payload_addr + payload_size) % AXI_TRANSACTION_ATOM_SIZE == 0;
    total_axi_size = payload_size + (is_base_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE) + (is_rear_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE);
    last_base_addr = first_base_addr + total_axi_size - AXI_TRANSACTION_ATOM_SIZE;
    cslDebug((30, "NV_NVDLA_cvif::cdma_wt2cvif_rd_req_b_transport, first_base_addr=0x%lx last_base_addr=0x%lx total_axi_size is 0x%x payload_addr=0x%lx payload_size=0x%x\x0A", first_base_addr, last_base_addr, total_axi_size, payload_addr, payload_size));
    // if ( total_axi_size <= (first_base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) ) {
    //     last_base_addr = first_base_addr;
    // } else if ((first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE != 0) {
    //     if (total_axi_size >= (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE) {
    //         last_base_addr = first_base_addr + total_axi_size - (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE;
    //     } else {
    //         last_base_addr = first_base_addr;
    //     }
    // } else {
    //     if (total_axi_size >= CVIF_MAX_MEM_TRANSACTION_SIZE) {
    //         last_base_addr = first_base_addr + total_axi_size - CVIF_MAX_MEM_TRANSACTION_SIZE;
    //     } else {
    //         last_base_addr = first_base_addr;
    //     }
    // }

    base_addr = first_base_addr;

    // Push the number of atoms of the request
    // cdma_wt2cvif_rd_req_atom_num_fifo_->write(total_axi_size/DMA_TRANSACTION_ATOM_SIZE);
    cdma_wt2cvif_rd_req_atom_num_fifo_->write(payload_size/DMA_TRANSACTION_ATOM_SIZE);
    cslDebug((50, "NV_NVDLA_cvif::cdma_wt2cvif_rd_req_b_transport, write 0x%x to cdma_wt2cvif_rd_req_atom_num_fifo_.\x0A", payload_size/DMA_TRANSACTION_ATOM_SIZE));

    //Split dma request to axi requests
    cslDebug((50, "NV_NVDLA_cvif::cdma_wt2cvif_rd_req_b_transport, before spliting DMA transaction\x0A"));
    while(cur_address <= last_base_addr) {
        base_addr    = cur_address;
        size_in_byte = AXI_TRANSACTION_ATOM_SIZE;
        cslDebug((50, "NV_NVDLA_cvif::cdma_wt2cvif_rd_req_b_transport, prepare AXI transaction for address: 0x%lx\x0A", base_addr));
        // base_addr should be aligned to 64B
        // size_in_byte should be multiple of 64
        // if the data size required by dma mster is 32B, MCIF will drop the extra 32B when AXI returns
        // size_in_byte = total_axi_size > (CVIF_MAX_MEM_TRANSACTION_SIZE) ? CVIF_MAX_MEM_TRANSACTION_SIZE : total_axi_size;
        // size_in_byte = (total_axi_size - base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) < (CVIF_MAX_MEM_TRANSACTION_SIZE) ? (total_axi_size - base_addr % (CVIF_MAX_MEM_TRANSACTION_SIZE)) : CVIF_MAX_MEM_TRANSACTION_SIZE;
        // if (base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE == 0) {
        //     size_in_byte = total_axi_size > CVIF_MAX_MEM_TRANSACTION_SIZE?CVIF_MAX_MEM_TRANSACTION_SIZE:total_axi_size;
        // } else if ( total_axi_size > (base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE)) {
        //     size_in_byte = base_addr % CVIF_MAX_MEM_TRANSACTION_SIZE;
        // } else {
        //     size_in_byte = total_axi_size;
        // }
        while (((cur_address + AXI_TRANSACTION_ATOM_SIZE) < (first_base_addr + total_axi_size)) && ((cur_address + AXI_TRANSACTION_ATOM_SIZE) % CVIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            size_in_byte += AXI_TRANSACTION_ATOM_SIZE;
            cur_address  += AXI_TRANSACTION_ATOM_SIZE;
        }
        // start address of next axi transaction
        cur_address += AXI_TRANSACTION_ATOM_SIZE;
        cslDebug((50, "NV_NVDLA_cvif::cdma_wt2cvif_rd_req_b_transport, cur_address=0x%lx base_addr=0x%lx size_in_byte=0x%x\x0A", cur_address, base_addr, size_in_byte));

        // Allocating memory for dla_b_transport_payload
        bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
        axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
        // Setup byte enable in payload. Always read 64B from cvif and cvif, but drop unneeded 32B
        // Write true to *_rd_atom_enable_fifo_ when the 32B atom is needed by dma client
        // Write false to *_rd_atom_enable_fifo_ when the 32B atom is not needed by dma client (dma's addr is not aligned to 64B
        // for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
        //     if(base_addr == last_base_addr) {   // compare with last_base_addr before first_base_addr for the case of only one axi transaction
        //         if ( (((true == is_rear_64byte_align) || (byte_iter < (size_in_byte - DMA_TRANSACTION_ATOM_SIZE))) && (first_base_addr != base_addr)) || 
        //                 ( ( ( (true == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE) ) || ( (true == is_rear_64byte_align) && (byte_iter >= DMA_TRANSACTION_ATOM_SIZE)) ) && (first_base_addr == base_addr)) ){
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::cdma_wt2cvif_rd_req_b_transport, write true to cdma_wt_rd_atom_enable_fifo_\x0A"));
        //                 cdma_wt_rd_atom_enable_fifo_->write(true);
        //             }
        //         } else {
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::cdma_wt2cvif_rd_req_b_transport, write false to cdma_wt_rd_atom_enable_fifo_\x0A"));
        //                 cdma_wt_rd_atom_enable_fifo_->write(false);
        //             }
        //         }
        //     }
        //     else if(base_addr == first_base_addr) {
        //         if ( (true == is_base_64byte_align) || (byte_iter >= DMA_TRANSACTION_ATOM_SIZE) ){
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::cdma_wt2cvif_rd_req_b_transport, write true to cdma_wt_rd_atom_enable_fifo_\x0A"));
        //                 cdma_wt_rd_atom_enable_fifo_->write(true);
        //             }
        //         } else {
        //             axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;
        //             if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //                 cslDebug((50, "NV_NVDLA_cvif::cdma_wt2cvif_rd_req_b_transport, write false to cdma_wt_rd_atom_enable_fifo_\x0A"));
        //                 cdma_wt_rd_atom_enable_fifo_->write(false);
        //             }
        //         }
        //     }
        //     else {
        //         axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;
        //         if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
        //             cslDebug((50, "NV_NVDLA_cvif::cdma_wt2cvif_rd_req_b_transport, write true to cdma_wt_rd_atom_enable_fifo_\x0A"));
        //             cdma_wt_rd_atom_enable_fifo_->write(true);
        //         }
        //     }
        // }
        for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
            if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE)) {
                // Diable 1st DMA atom of the unaligned first_base_addr
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::cdma_wt2cvif_rd_req_b_transport, write true to cdma_wt_rd_atom_enable_fifo_\x0A"));
                    cdma_wt_rd_atom_enable_fifo_->write(false);
                }
            } else if (( (base_addr + size_in_byte) == (last_base_addr+AXI_TRANSACTION_ATOM_SIZE)) && (false == is_rear_64byte_align) && (byte_iter >= size_in_byte - DMA_TRANSACTION_ATOM_SIZE)) {
                // Diable 2nd DMA atom of the unaligned last_base_addr
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::cdma_wt2cvif_rd_req_b_transport, write true to cdma_wt_rd_atom_enable_fifo_\x0A"));
                    cdma_wt_rd_atom_enable_fifo_->write(false);
                }
            } else {
                axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;  // All bytes should be enabled
                if (0 == byte_iter%DMA_TRANSACTION_ATOM_SIZE) {
                    cslDebug((50, "NV_NVDLA_cvif::cdma_wt2cvif_rd_req_b_transport, write true to cdma_wt_rd_atom_enable_fifo_\x0A"));
                    cdma_wt_rd_atom_enable_fifo_->write(true);
                }
            }
        }
        cslDebug((50, "NV_NVDLA_cvif::cdma_wt2cvif_rd_req_b_transport, TLM_BYTE_ENABLE is done\x0A"));
        bt_payload->configure_gp(base_addr, size_in_byte, is_read);
        bt_payload->gp.get_extension(nvdla_dbb_ext);
        nvdla_dbb_ext->set_id(CDMA_WT_AXI_ID);
        nvdla_dbb_ext->set_size(64);
        nvdla_dbb_ext->set_length(size_in_byte/AXI_TRANSACTION_ATOM_SIZE);
#pragma CTC SKIP
        if(size_in_byte%AXI_TRANSACTION_ATOM_SIZE!=0) {
            FAIL(("NV_NVDLA_cvif::cdma_wt2cvif_rd_req_b_transport, size_in_byte is not multiple of AXI_TRANSACTION_ATOM_SIZE. size_in_byte=0x%x", size_in_byte));
        }
#pragma CTC ENDSKIP
        cslDebug((50, "NV_NVDLA_cvif::cdma_wt2cvif_rd_req_b_transport, before sending data to cdma_wt_rd_req_fifo_ addr=0x%lx\x0A", base_addr));
        cdma_wt_rd_req_fifo_->write(bt_payload);
        cslDebug((50, "NV_NVDLA_cvif::cdma_wt2cvif_rd_req_b_transport, after sending data to cdma_wt_rd_req_fifo_ addr=0x%lx\x0A", base_addr));

        // total_axi_size -= size_in_byte;
        // base_addr      += size_in_byte;
    }
    cslDebug((50, "NV_NVDLA_cvif::cdma_wt2cvif_rd_req_b_transport, after spliting DMA transaction\x0A"));
}

void NV_NVDLA_cvif::ReadResp_cvif2cdma_wt() {
    uint8_t    *axi_atom_ptr;
    uint32_t    atom_num_left;
    nvdla_dma_rd_rsp_t* dma_rd_rsp_payload = NULL;
    uint8_t           * dma_payload_data_ptr;
    uint32_t    idx;

    atom_num_left = 0;
    while(true) {
        if(0 == atom_num_left) {
            atom_num_left = cdma_wt2cvif_rd_req_atom_num_fifo_->read();
            cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2cdma_wt, update atom_num_left from cdma_wt2cvif_rd_req_atom_num_fifo_, atom_num_left is 0x%x\x0A", atom_num_left));
        }
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2cdma_wt, atom_num_left is 0x%x\x0A", atom_num_left));

        dma_rd_rsp_payload      = new nvdla_dma_rd_rsp_t;
        dma_payload_data_ptr    = reinterpret_cast <uint8_t *> (dma_rd_rsp_payload->pd.dma_read_data.data);
        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x00;

        // 1st atom of the 64B
        // Aligen to 32B
        axi_atom_ptr = cvif2cdma_wt_rd_rsp_fifo_->read();
        credit_cvif2cdma_wt_rd_rsp_fifo_ ++;
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2cdma_wt, read 1st atom of the 64B from cvif2cdma_wt_rd_rsp_fifo_\x0A"));
        atom_num_left--;

        dma_rd_rsp_payload->pd.dma_read_data.mask = 0x1;
        memcpy (&dma_payload_data_ptr[0], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
        delete[] axi_atom_ptr;

        if(atom_num_left>0) {
            // 2nd atom of the 64B
            axi_atom_ptr = cvif2cdma_wt_rd_rsp_fifo_->read();
            credit_cvif2cdma_wt_rd_rsp_fifo_ ++;
            cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2cdma_wt, read 2nd atom of the 64B from cvif2cdma_wt_rd_rsp_fifo_\x0A"));
            atom_num_left--;
            dma_rd_rsp_payload->pd.dma_read_data.mask = (dma_rd_rsp_payload->pd.dma_read_data.mask << 0x1) + 0x1;
            memcpy (&dma_payload_data_ptr[DMA_TRANSACTION_ATOM_SIZE], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
            delete[] axi_atom_ptr;
        }

        cslDebug((70, "NV_NVDLA_cvif::ReadResp_cvif2cdma_wt, dma_rd_rsp_payload->pd.dma_read_data.mask is 0x%x\x0A", uint32_t(dma_rd_rsp_payload->pd.dma_read_data.mask)));
        cslDebug((70, "NV_NVDLA_cvif::ReadResp_cvif2cdma_wt, dma_rd_rsp_payload->pd.dma_read_data.data are :\x0A"));
        for (idx = 0; idx < sizeof(dma_rd_rsp_payload->pd.dma_read_data.data)/sizeof(dma_rd_rsp_payload->pd.dma_read_data.data[0]); idx++) {
            cslDebug((70, "    0x%lx\x0A", uint64_t (dma_rd_rsp_payload->pd.dma_read_data.data[idx])));   // The size of data[idx] is 8bytes and its type is "unsigned long"
        }
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2cdma_wt, before NV_NVDLA_cvif_base::cvif2cdma_wt_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        NV_NVDLA_cvif_base::cvif2cdma_wt_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_);
        cslDebug((50, "NV_NVDLA_cvif::ReadResp_cvif2cdma_wt, after NV_NVDLA_cvif_base::cvif2cdma_wt_rd_rsp_b_transport(dma_rd_rsp_payload, dma_delay_)\x0A"));
        delete dma_rd_rsp_payload;
    }
}

// DMA read request target sockets

void NV_NVDLA_cvif::bdma2cvif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) {
    uint32_t packet_id;
    uint8_t  *dma_payload_data_ptr;
    uint8_t  *data_ptr;
    uint32_t rest_size, incoming_size;
    client_cvif_wr_req_t * bdma_wr_req;

    packet_id = payload->tag;
    if (TAG_CMD == packet_id) {
        bdma_wr_req_count_ ++;
#pragma CTC SKIP
        if (true == has_bdma_onging_wr_req_) {
            FAIL(("NV_NVDLA_cvif::bdma2cvif_wr_req_b_transport, got two consective command request, one command request shall be followed by one or more data request."));
        }
#pragma CTC ENDSKIP
	else {
            has_bdma_onging_wr_req_ = true;
        }

        bdma_wr_req = new client_cvif_wr_req_t;
        bdma_wr_req->addr  = payload->pd.dma_write_cmd.addr;
        bdma_wr_req->size  = (payload->pd.dma_write_cmd.size + 1) * DMA_TRANSACTION_ATOM_SIZE;    //In byte
        bdma_wr_req->require_ack = payload->pd.dma_write_cmd.require_ack;
        cslDebug((50, "before write to bdma2cvif_wr_cmd_fifo_\x0A"));
        bdma2cvif_wr_cmd_fifo_->write(bdma_wr_req);
        cslDebug((50, "after write to bdma2cvif_wr_cmd_fifo_\x0A"));
        bdma_wr_req_got_size_ = 0;
        bdma_wr_req_size_ = bdma_wr_req->size;

    } else {
        dma_payload_data_ptr = reinterpret_cast <uint8_t *> (payload->pd.dma_write_data.data);
        rest_size = bdma_wr_req_size_ - bdma_wr_req_got_size_;
        incoming_size = min(rest_size, uint32_t (DMA_TRANSACTION_MAX_SIZE));
        data_ptr = new uint8_t[DMA_TRANSACTION_ATOM_SIZE];
        memcpy(data_ptr, dma_payload_data_ptr, DMA_TRANSACTION_ATOM_SIZE);
        cslDebug((50, "before write to bdma2cvif_wr_data_fifo_\x0A"));
        bdma2cvif_wr_data_fifo_->write(data_ptr);   // Write to FIFO in 32Byte atom
        cslDebug((50, "after write to bdma2cvif_wr_data_fifo_\x0A"));
        bdma_wr_req_got_size_ += incoming_size;
        for(int i = 0; i < DMA_TRANSACTION_ATOM_SIZE; i++) {
            cslDebug((50, "%x ", data_ptr[i]));
        }
        cslDebug((50, "\x0A"));
        if (incoming_size==DMA_TRANSACTION_MAX_SIZE) { // The payload is 64B
            data_ptr = new uint8_t[DMA_TRANSACTION_ATOM_SIZE];
            memcpy(data_ptr, &dma_payload_data_ptr[DMA_TRANSACTION_ATOM_SIZE], DMA_TRANSACTION_ATOM_SIZE);
            cslDebug((50, "write to bdma2cvif_wr_data_fifo_\x0A"));
            bdma2cvif_wr_data_fifo_->write(data_ptr);
            for(int i = 0; i < DMA_TRANSACTION_ATOM_SIZE; i++) {
                cslDebug((50, "%x ", data_ptr[i]));
            }
            cslDebug((50, "\x0A"));
        }

        if (bdma_wr_req_got_size_ == bdma_wr_req_size_) {
            has_bdma_onging_wr_req_ = false;
        }
    }
}

void NV_NVDLA_cvif::WriteRequest_bdma2cvif() {
    uint64_t base_addr;
    uint64_t first_base_addr;
    uint64_t last_base_addr;
    uint64_t cur_address;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    uint32_t atom_iter;
    uint32_t atom_num;
    bool     is_base_64byte_align;
    bool     is_rear_64byte_align;
    bool     is_read=false;
    uint8_t  *axi_atom_ptr;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    client_cvif_wr_req_t   * bdma_wr_req;
    dla_b_transport_payload *bt_payload;

    while(true) {
        // Read one write command
        bdma_wr_req = bdma2cvif_wr_cmd_fifo_->read();
        payload_addr = bdma_wr_req->addr;   // It's aligend to 32B, not 64B
        payload_size = bdma_wr_req->size;
        cslDebug((50, "NV_NVDLA_cvif::WriteRequest_bdma2cvif, got one write command from bdma2cvif_wr_cmd_fifo_\x0A"));
        cslDebug((50, "    payload_addr: 0x%lx\x0A", payload_addr));
        cslDebug((50, "    payload_size: 0x%x\x0A", payload_size));

        is_base_64byte_align = payload_addr%AXI_TRANSACTION_ATOM_SIZE == 0;
        first_base_addr = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B
        is_rear_64byte_align = (payload_addr + payload_size) % AXI_TRANSACTION_ATOM_SIZE == 0;
        // According to DBB_PV standard, data_length shall be equal or greater than DBB_PV m_size * m_length no matter the transactions is aglined or not
        total_axi_size = payload_size + (is_base_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE) + (is_rear_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE);
        last_base_addr = first_base_addr + total_axi_size - AXI_TRANSACTION_ATOM_SIZE;
        // if ( total_axi_size <= AXI_TRANSACTION_ATOM_SIZE ) {
        //     // The first and last transaction is actually the same
        //     last_base_addr = first_base_addr;
        // } else {
        //     last_base_addr = (first_base_addr + total_axi_size) - (first_base_addr + total_axi_size)%AXI_TRANSACTION_ATOM_SIZE;
        // }
        // if (total_axi_size + first_base_addr%CVIF_MAX_MEM_TRANSACTION_SIZE <= CVIF_MAX_MEM_TRANSACTION_SIZE) {
        //     // Base and last are in the same AXI transaction
        // } else {
        //     // Base and last are in different AXI transaction
        //     last_base_addr = 
        // }
        // } else if ((first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE != 0) {
        //     if (total_axi_size >= (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE) {
        //         last_base_addr = first_base_addr + total_axi_size - (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE;
        //     } else {
        //         last_base_addr = first_base_addr;
        //     }
        // } else {
        //     if (total_axi_size >= CVIF_MAX_MEM_TRANSACTION_SIZE) {
        //         last_base_addr = first_base_addr + total_axi_size - CVIF_MAX_MEM_TRANSACTION_SIZE;
        //     } else {
        //         last_base_addr = first_base_addr;
        //     }
        // }
        cslDebug((50, "NV_NVDLA_cvif::WriteRequest_bdma2cvif:\x0A"));
        cslDebug((50, "    first_base_addr: 0x%lx\x0A", first_base_addr));
        cslDebug((50, "    last_base_addr: 0x%lx\x0A", last_base_addr));
        cslDebug((50, "    total_axi_size: 0x%x\x0A", total_axi_size));

        // cur_address = payload_addr;
        cur_address = is_base_64byte_align? payload_addr: first_base_addr; // Align to 64B
        //Split dma request to axi requests
        // while(cur_address < payload_addr + payload_size) {}
        while(cur_address <= last_base_addr) {
            base_addr    = cur_address;
            size_in_byte = AXI_TRANSACTION_ATOM_SIZE;
            // Check whether next ATOM belongs to current AXI transaction
            // while (((cur_address + DMA_TRANSACTION_ATOM_SIZE) < (payload_addr + payload_size)) && ((cur_address + DMA_TRANSACTION_ATOM_SIZE) % CVIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            //     size_in_byte += DMA_TRANSACTION_ATOM_SIZE;
            //     cur_address  += DMA_TRANSACTION_ATOM_SIZE;
            // }
            while (((cur_address + AXI_TRANSACTION_ATOM_SIZE) < (first_base_addr + total_axi_size)) && ((cur_address + AXI_TRANSACTION_ATOM_SIZE) % CVIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
                size_in_byte += AXI_TRANSACTION_ATOM_SIZE;
                cur_address  += AXI_TRANSACTION_ATOM_SIZE;
            }
            // start address of next axi transaction
            cur_address += AXI_TRANSACTION_ATOM_SIZE;

            atom_num = size_in_byte / DMA_TRANSACTION_ATOM_SIZE;

            bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
            axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
            cslDebug((50, "NV_NVDLA_cvif::WriteRequest_bdma2cvif, base_addr=0x%lx size_in_byte=0x%x atom_num=0x%x\x0A", base_addr, size_in_byte, atom_num));

            for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
                if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE)) {
                    // Diable 1st DMA atom of the unaligned first_base_addr
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                } else if (( (base_addr + size_in_byte) == (last_base_addr+AXI_TRANSACTION_ATOM_SIZE)) && (false == is_rear_64byte_align) && (byte_iter >= size_in_byte - DMA_TRANSACTION_ATOM_SIZE)) {
                    // Diable 2nd DMA atom of the unaligned last_base_addr
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                } else {
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;  // All bytes should be enabled
                }
            }
            cslDebug((50, "NV_NVDLA_cvif::WriteRequest_bdma2cvif, TLM_BYTE_ENABLE is done\x0A"));

            for (atom_iter=0; atom_iter < atom_num; atom_iter++) {
                if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) && (0 == atom_iter)) {
                    // Disable 1st DMA atom of the unaligned first_base_addr
                    // Use unaligned address as required by DBB_PV
                    memset(&bt_payload->data[atom_iter*DMA_TRANSACTION_ATOM_SIZE], 0, DMA_TRANSACTION_ATOM_SIZE);
                } else if (((base_addr + size_in_byte) == (last_base_addr+AXI_TRANSACTION_ATOM_SIZE)) && (false == is_rear_64byte_align) && ( (atom_iter + 1) == atom_num)) {
                    // Disable 2nd DMA atom of the unaligned last_base_addr
                    memset(&bt_payload->data[atom_iter*DMA_TRANSACTION_ATOM_SIZE], 0, DMA_TRANSACTION_ATOM_SIZE);
                } else {
                    cslDebug((50, "NV_NVDLA_cvif::WriteRequest_bdma2cvif, before read an atom from bdma2cvif_wr_data_fifo_, base_addr = 0x%lx, atom_iter=0x%x\x0A", base_addr, atom_iter));

                    axi_atom_ptr = bdma2cvif_wr_data_fifo_->read();
                    for(int i=0; i<DMA_TRANSACTION_ATOM_SIZE; i++) {
                        cslDebug((50, "%02x ", axi_atom_ptr[i]));
                    }
                    cslDebug((50, "\x0A"));
                    cslDebug((50, "NV_NVDLA_cvif::WriteRequest_bdma2cvif, after read an atom from bdma2cvif_wr_data_fifo_\x0A"));
                    memcpy(&bt_payload->data[atom_iter*DMA_TRANSACTION_ATOM_SIZE], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
                    delete[] axi_atom_ptr;
                }
            }

            if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) ) {
                base_addr += DMA_TRANSACTION_ATOM_SIZE;
            }
            cslDebug((50, "NV_NVDLA_cvif::WriteRequest_bdma2cvif, base_address=0x%lx size in byte=0x%x\x0A", base_addr, size_in_byte));
            // Prepare write payload
            bt_payload->configure_gp(base_addr, size_in_byte, is_read);
            bt_payload->gp.get_extension(nvdla_dbb_ext);
            cslDebug((50, "NV_NVDLA_cvif::WriteRequest_bdma2cvif, sending write command to bdma_wr_req_fifo_.\x0A"));
            cslDebug((50, "    addr: 0x%016lx\x0A", base_addr));
            cslDebug((50, "    size: %d\x0A", size_in_byte));
            nvdla_dbb_ext->set_id(BDMA_AXI_ID);
            nvdla_dbb_ext->set_size(64);
            nvdla_dbb_ext->set_length(size_in_byte/AXI_TRANSACTION_ATOM_SIZE);
            // if (base_addr%AXI_TRANSACTION_ATOM_SIZE != 0) //Set length(in unit of 64B) to be same as RTL
            //     nvdla_dbb_ext->set_length(((size_in_byte - DMA_TRANSACTION_ATOM_SIZE) + DMA_TRANSACTION_ATOM_SIZE)/AXI_TRANSACTION_ATOM_SIZE);
            // else // base_addr is aligned to 64Bytes
            //     nvdla_dbb_ext->set_length((size_in_byte + DMA_TRANSACTION_ATOM_SIZE)/AXI_TRANSACTION_ATOM_SIZE-1);

            // write payload to arbiter fifo
            bdma_wr_req_fifo_->write(bt_payload);

            // When the last split req is sent to ext, write true to bdma_wr_required_ack_fifo_ when ack is required.
            if (cur_address >= (payload_addr + payload_size)) {
                if(bdma_wr_req->require_ack!=0) {
                    cslDebug((50, "NV_NVDLA_cvif::WriteRequest_bdma2cvif, require ack.\x0A"));
                    bdma_wr_required_ack_fifo_->write(true);
                }
                else {
                    cslDebug((50, "NV_NVDLA_cvif::WriteRequest_bdma2cvif, does not require ack.\x0A"));
                    bdma_wr_required_ack_fifo_->write(false);
                }
            }
            else {
                cslDebug((50, "NV_NVDLA_cvif::WriteRequest_bdma2cvif, does not require ack.\x0A"));
                bdma_wr_required_ack_fifo_->write(false);
            }
        }
        delete bdma_wr_req;
        cslDebug((50, "NV_NVDLA_cvif::WriteRequest_bdma2cvif, write command processing done\x0A"));
    }
}

void NV_NVDLA_cvif::sdp2cvif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) {
    uint32_t packet_id;
    uint8_t  *dma_payload_data_ptr;
    uint8_t  *data_ptr;
    uint32_t rest_size, incoming_size;
    client_cvif_wr_req_t * sdp_wr_req;

    packet_id = payload->tag;
    if (TAG_CMD == packet_id) {
        sdp_wr_req_count_ ++;
#pragma CTC SKIP
        if (true == has_sdp_onging_wr_req_) {
            FAIL(("NV_NVDLA_cvif::sdp2cvif_wr_req_b_transport, got two consective command request, one command request shall be followed by one or more data request."));
        }
#pragma CTC ENDSKIP
	else {
            has_sdp_onging_wr_req_ = true;
        }

        sdp_wr_req = new client_cvif_wr_req_t;
        sdp_wr_req->addr  = payload->pd.dma_write_cmd.addr;
        sdp_wr_req->size  = (payload->pd.dma_write_cmd.size + 1) * DMA_TRANSACTION_ATOM_SIZE;    //In byte
        sdp_wr_req->require_ack = payload->pd.dma_write_cmd.require_ack;
        cslDebug((50, "before write to sdp2cvif_wr_cmd_fifo_\x0A"));
        sdp2cvif_wr_cmd_fifo_->write(sdp_wr_req);
        cslDebug((50, "after write to sdp2cvif_wr_cmd_fifo_\x0A"));
        sdp_wr_req_got_size_ = 0;
        sdp_wr_req_size_ = sdp_wr_req->size;

    } else {
        dma_payload_data_ptr = reinterpret_cast <uint8_t *> (payload->pd.dma_write_data.data);
        rest_size = sdp_wr_req_size_ - sdp_wr_req_got_size_;
        incoming_size = min(rest_size, uint32_t (DMA_TRANSACTION_MAX_SIZE));
        data_ptr = new uint8_t[DMA_TRANSACTION_ATOM_SIZE];
        memcpy(data_ptr, dma_payload_data_ptr, DMA_TRANSACTION_ATOM_SIZE);
        cslDebug((50, "before write to sdp2cvif_wr_data_fifo_\x0A"));
        sdp2cvif_wr_data_fifo_->write(data_ptr);   // Write to FIFO in 32Byte atom
        cslDebug((50, "after write to sdp2cvif_wr_data_fifo_\x0A"));
        sdp_wr_req_got_size_ += incoming_size;
        for(int i = 0; i < DMA_TRANSACTION_ATOM_SIZE; i++) {
            cslDebug((50, "%x ", data_ptr[i]));
        }
        cslDebug((50, "\x0A"));
        if (incoming_size==DMA_TRANSACTION_MAX_SIZE) { // The payload is 64B
            data_ptr = new uint8_t[DMA_TRANSACTION_ATOM_SIZE];
            memcpy(data_ptr, &dma_payload_data_ptr[DMA_TRANSACTION_ATOM_SIZE], DMA_TRANSACTION_ATOM_SIZE);
            cslDebug((50, "write to sdp2cvif_wr_data_fifo_\x0A"));
            sdp2cvif_wr_data_fifo_->write(data_ptr);
            for(int i = 0; i < DMA_TRANSACTION_ATOM_SIZE; i++) {
                cslDebug((50, "%x ", data_ptr[i]));
            }
            cslDebug((50, "\x0A"));
        }

        if (sdp_wr_req_got_size_ == sdp_wr_req_size_) {
            has_sdp_onging_wr_req_ = false;
        }
    }
}

void NV_NVDLA_cvif::WriteRequest_sdp2cvif() {
    uint64_t base_addr;
    uint64_t first_base_addr;
    uint64_t last_base_addr;
    uint64_t cur_address;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    uint32_t atom_iter;
    uint32_t atom_num;
    bool     is_base_64byte_align;
    bool     is_rear_64byte_align;
    bool     is_read=false;
    uint8_t  *axi_atom_ptr;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    client_cvif_wr_req_t   * sdp_wr_req;
    dla_b_transport_payload *bt_payload;

    while(true) {
        // Read one write command
        sdp_wr_req = sdp2cvif_wr_cmd_fifo_->read();
        payload_addr = sdp_wr_req->addr;   // It's aligend to 32B, not 64B
        payload_size = sdp_wr_req->size;
        cslDebug((50, "NV_NVDLA_cvif::WriteRequest_sdp2cvif, got one write command from sdp2cvif_wr_cmd_fifo_\x0A"));
        cslDebug((50, "    payload_addr: 0x%lx\x0A", payload_addr));
        cslDebug((50, "    payload_size: 0x%x\x0A", payload_size));

        is_base_64byte_align = payload_addr%AXI_TRANSACTION_ATOM_SIZE == 0;
        first_base_addr = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B
        is_rear_64byte_align = (payload_addr + payload_size) % AXI_TRANSACTION_ATOM_SIZE == 0;
        // According to DBB_PV standard, data_length shall be equal or greater than DBB_PV m_size * m_length no matter the transactions is aglined or not
        total_axi_size = payload_size + (is_base_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE) + (is_rear_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE);
        last_base_addr = first_base_addr + total_axi_size - AXI_TRANSACTION_ATOM_SIZE;
        // if ( total_axi_size <= AXI_TRANSACTION_ATOM_SIZE ) {
        //     // The first and last transaction is actually the same
        //     last_base_addr = first_base_addr;
        // } else {
        //     last_base_addr = (first_base_addr + total_axi_size) - (first_base_addr + total_axi_size)%AXI_TRANSACTION_ATOM_SIZE;
        // }
        // if (total_axi_size + first_base_addr%CVIF_MAX_MEM_TRANSACTION_SIZE <= CVIF_MAX_MEM_TRANSACTION_SIZE) {
        //     // Base and last are in the same AXI transaction
        // } else {
        //     // Base and last are in different AXI transaction
        //     last_base_addr = 
        // }
        // } else if ((first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE != 0) {
        //     if (total_axi_size >= (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE) {
        //         last_base_addr = first_base_addr + total_axi_size - (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE;
        //     } else {
        //         last_base_addr = first_base_addr;
        //     }
        // } else {
        //     if (total_axi_size >= CVIF_MAX_MEM_TRANSACTION_SIZE) {
        //         last_base_addr = first_base_addr + total_axi_size - CVIF_MAX_MEM_TRANSACTION_SIZE;
        //     } else {
        //         last_base_addr = first_base_addr;
        //     }
        // }
        cslDebug((50, "NV_NVDLA_cvif::WriteRequest_sdp2cvif:\x0A"));
        cslDebug((50, "    first_base_addr: 0x%lx\x0A", first_base_addr));
        cslDebug((50, "    last_base_addr: 0x%lx\x0A", last_base_addr));
        cslDebug((50, "    total_axi_size: 0x%x\x0A", total_axi_size));

        // cur_address = payload_addr;
        cur_address = is_base_64byte_align? payload_addr: first_base_addr; // Align to 64B
        //Split dma request to axi requests
        // while(cur_address < payload_addr + payload_size) {}
        while(cur_address <= last_base_addr) {
            base_addr    = cur_address;
            size_in_byte = AXI_TRANSACTION_ATOM_SIZE;
            // Check whether next ATOM belongs to current AXI transaction
            // while (((cur_address + DMA_TRANSACTION_ATOM_SIZE) < (payload_addr + payload_size)) && ((cur_address + DMA_TRANSACTION_ATOM_SIZE) % CVIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            //     size_in_byte += DMA_TRANSACTION_ATOM_SIZE;
            //     cur_address  += DMA_TRANSACTION_ATOM_SIZE;
            // }
            while (((cur_address + AXI_TRANSACTION_ATOM_SIZE) < (first_base_addr + total_axi_size)) && ((cur_address + AXI_TRANSACTION_ATOM_SIZE) % CVIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
                size_in_byte += AXI_TRANSACTION_ATOM_SIZE;
                cur_address  += AXI_TRANSACTION_ATOM_SIZE;
            }
            // start address of next axi transaction
            cur_address += AXI_TRANSACTION_ATOM_SIZE;

            atom_num = size_in_byte / DMA_TRANSACTION_ATOM_SIZE;

            bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
            axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
            cslDebug((50, "NV_NVDLA_cvif::WriteRequest_sdp2cvif, base_addr=0x%lx size_in_byte=0x%x atom_num=0x%x\x0A", base_addr, size_in_byte, atom_num));

            for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
                if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE)) {
                    // Diable 1st DMA atom of the unaligned first_base_addr
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                } else if (( (base_addr + size_in_byte) == (last_base_addr+AXI_TRANSACTION_ATOM_SIZE)) && (false == is_rear_64byte_align) && (byte_iter >= size_in_byte - DMA_TRANSACTION_ATOM_SIZE)) {
                    // Diable 2nd DMA atom of the unaligned last_base_addr
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                } else {
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;  // All bytes should be enabled
                }
            }
            cslDebug((50, "NV_NVDLA_cvif::WriteRequest_sdp2cvif, TLM_BYTE_ENABLE is done\x0A"));

            for (atom_iter=0; atom_iter < atom_num; atom_iter++) {
                if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) && (0 == atom_iter)) {
                    // Disable 1st DMA atom of the unaligned first_base_addr
                    // Use unaligned address as required by DBB_PV
                    memset(&bt_payload->data[atom_iter*DMA_TRANSACTION_ATOM_SIZE], 0, DMA_TRANSACTION_ATOM_SIZE);
                } else if (((base_addr + size_in_byte) == (last_base_addr+AXI_TRANSACTION_ATOM_SIZE)) && (false == is_rear_64byte_align) && ( (atom_iter + 1) == atom_num)) {
                    // Disable 2nd DMA atom of the unaligned last_base_addr
                    memset(&bt_payload->data[atom_iter*DMA_TRANSACTION_ATOM_SIZE], 0, DMA_TRANSACTION_ATOM_SIZE);
                } else {
                    cslDebug((50, "NV_NVDLA_cvif::WriteRequest_sdp2cvif, before read an atom from sdp2cvif_wr_data_fifo_, base_addr = 0x%lx, atom_iter=0x%x\x0A", base_addr, atom_iter));

                    axi_atom_ptr = sdp2cvif_wr_data_fifo_->read();
                    for(int i=0; i<DMA_TRANSACTION_ATOM_SIZE; i++) {
                        cslDebug((50, "%02x ", axi_atom_ptr[i]));
                    }
                    cslDebug((50, "\x0A"));
                    cslDebug((50, "NV_NVDLA_cvif::WriteRequest_sdp2cvif, after read an atom from sdp2cvif_wr_data_fifo_\x0A"));
                    memcpy(&bt_payload->data[atom_iter*DMA_TRANSACTION_ATOM_SIZE], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
                    delete[] axi_atom_ptr;
                }
            }

            if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) ) {
                base_addr += DMA_TRANSACTION_ATOM_SIZE;
            }
            cslDebug((50, "NV_NVDLA_cvif::WriteRequest_sdp2cvif, base_address=0x%lx size in byte=0x%x\x0A", base_addr, size_in_byte));
            // Prepare write payload
            bt_payload->configure_gp(base_addr, size_in_byte, is_read);
            bt_payload->gp.get_extension(nvdla_dbb_ext);
            cslDebug((50, "NV_NVDLA_cvif::WriteRequest_sdp2cvif, sending write command to sdp_wr_req_fifo_.\x0A"));
            cslDebug((50, "    addr: 0x%016lx\x0A", base_addr));
            cslDebug((50, "    size: %d\x0A", size_in_byte));
            nvdla_dbb_ext->set_id(SDP_AXI_ID);
            nvdla_dbb_ext->set_size(64);
            nvdla_dbb_ext->set_length(size_in_byte/AXI_TRANSACTION_ATOM_SIZE);
            // if (base_addr%AXI_TRANSACTION_ATOM_SIZE != 0) //Set length(in unit of 64B) to be same as RTL
            //     nvdla_dbb_ext->set_length(((size_in_byte - DMA_TRANSACTION_ATOM_SIZE) + DMA_TRANSACTION_ATOM_SIZE)/AXI_TRANSACTION_ATOM_SIZE);
            // else // base_addr is aligned to 64Bytes
            //     nvdla_dbb_ext->set_length((size_in_byte + DMA_TRANSACTION_ATOM_SIZE)/AXI_TRANSACTION_ATOM_SIZE-1);

            // write payload to arbiter fifo
            sdp_wr_req_fifo_->write(bt_payload);

            // When the last split req is sent to ext, write true to sdp_wr_required_ack_fifo_ when ack is required.
            if (cur_address >= (payload_addr + payload_size)) {
                if(sdp_wr_req->require_ack!=0) {
                    cslDebug((50, "NV_NVDLA_cvif::WriteRequest_sdp2cvif, require ack.\x0A"));
                    sdp_wr_required_ack_fifo_->write(true);
                }
                else {
                    cslDebug((50, "NV_NVDLA_cvif::WriteRequest_sdp2cvif, does not require ack.\x0A"));
                    sdp_wr_required_ack_fifo_->write(false);
                }
            }
            else {
                cslDebug((50, "NV_NVDLA_cvif::WriteRequest_sdp2cvif, does not require ack.\x0A"));
                sdp_wr_required_ack_fifo_->write(false);
            }
        }
        delete sdp_wr_req;
        cslDebug((50, "NV_NVDLA_cvif::WriteRequest_sdp2cvif, write command processing done\x0A"));
    }
}

void NV_NVDLA_cvif::pdp2cvif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) {
    uint32_t packet_id;
    uint8_t  *dma_payload_data_ptr;
    uint8_t  *data_ptr;
    uint32_t rest_size, incoming_size;
    client_cvif_wr_req_t * pdp_wr_req;

    packet_id = payload->tag;
    if (TAG_CMD == packet_id) {
        pdp_wr_req_count_ ++;
#pragma CTC SKIP
        if (true == has_pdp_onging_wr_req_) {
            FAIL(("NV_NVDLA_cvif::pdp2cvif_wr_req_b_transport, got two consective command request, one command request shall be followed by one or more data request."));
        }
#pragma CTC ENDSKIP
	else {
            has_pdp_onging_wr_req_ = true;
        }

        pdp_wr_req = new client_cvif_wr_req_t;
        pdp_wr_req->addr  = payload->pd.dma_write_cmd.addr;
        pdp_wr_req->size  = (payload->pd.dma_write_cmd.size + 1) * DMA_TRANSACTION_ATOM_SIZE;    //In byte
        pdp_wr_req->require_ack = payload->pd.dma_write_cmd.require_ack;
        cslDebug((50, "before write to pdp2cvif_wr_cmd_fifo_\x0A"));
        pdp2cvif_wr_cmd_fifo_->write(pdp_wr_req);
        cslDebug((50, "after write to pdp2cvif_wr_cmd_fifo_\x0A"));
        pdp_wr_req_got_size_ = 0;
        pdp_wr_req_size_ = pdp_wr_req->size;

    } else {
        dma_payload_data_ptr = reinterpret_cast <uint8_t *> (payload->pd.dma_write_data.data);
        rest_size = pdp_wr_req_size_ - pdp_wr_req_got_size_;
        incoming_size = min(rest_size, uint32_t (DMA_TRANSACTION_MAX_SIZE));
        data_ptr = new uint8_t[DMA_TRANSACTION_ATOM_SIZE];
        memcpy(data_ptr, dma_payload_data_ptr, DMA_TRANSACTION_ATOM_SIZE);
        cslDebug((50, "before write to pdp2cvif_wr_data_fifo_\x0A"));
        pdp2cvif_wr_data_fifo_->write(data_ptr);   // Write to FIFO in 32Byte atom
        cslDebug((50, "after write to pdp2cvif_wr_data_fifo_\x0A"));
        pdp_wr_req_got_size_ += incoming_size;
        for(int i = 0; i < DMA_TRANSACTION_ATOM_SIZE; i++) {
            cslDebug((50, "%x ", data_ptr[i]));
        }
        cslDebug((50, "\x0A"));
        if (incoming_size==DMA_TRANSACTION_MAX_SIZE) { // The payload is 64B
            data_ptr = new uint8_t[DMA_TRANSACTION_ATOM_SIZE];
            memcpy(data_ptr, &dma_payload_data_ptr[DMA_TRANSACTION_ATOM_SIZE], DMA_TRANSACTION_ATOM_SIZE);
            cslDebug((50, "write to pdp2cvif_wr_data_fifo_\x0A"));
            pdp2cvif_wr_data_fifo_->write(data_ptr);
            for(int i = 0; i < DMA_TRANSACTION_ATOM_SIZE; i++) {
                cslDebug((50, "%x ", data_ptr[i]));
            }
            cslDebug((50, "\x0A"));
        }

        if (pdp_wr_req_got_size_ == pdp_wr_req_size_) {
            has_pdp_onging_wr_req_ = false;
        }
    }
}

void NV_NVDLA_cvif::WriteRequest_pdp2cvif() {
    uint64_t base_addr;
    uint64_t first_base_addr;
    uint64_t last_base_addr;
    uint64_t cur_address;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    uint32_t atom_iter;
    uint32_t atom_num;
    bool     is_base_64byte_align;
    bool     is_rear_64byte_align;
    bool     is_read=false;
    uint8_t  *axi_atom_ptr;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    client_cvif_wr_req_t   * pdp_wr_req;
    dla_b_transport_payload *bt_payload;

    while(true) {
        // Read one write command
        pdp_wr_req = pdp2cvif_wr_cmd_fifo_->read();
        payload_addr = pdp_wr_req->addr;   // It's aligend to 32B, not 64B
        payload_size = pdp_wr_req->size;
        cslDebug((50, "NV_NVDLA_cvif::WriteRequest_pdp2cvif, got one write command from pdp2cvif_wr_cmd_fifo_\x0A"));
        cslDebug((50, "    payload_addr: 0x%lx\x0A", payload_addr));
        cslDebug((50, "    payload_size: 0x%x\x0A", payload_size));

        is_base_64byte_align = payload_addr%AXI_TRANSACTION_ATOM_SIZE == 0;
        first_base_addr = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B
        is_rear_64byte_align = (payload_addr + payload_size) % AXI_TRANSACTION_ATOM_SIZE == 0;
        // According to DBB_PV standard, data_length shall be equal or greater than DBB_PV m_size * m_length no matter the transactions is aglined or not
        total_axi_size = payload_size + (is_base_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE) + (is_rear_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE);
        last_base_addr = first_base_addr + total_axi_size - AXI_TRANSACTION_ATOM_SIZE;
        // if ( total_axi_size <= AXI_TRANSACTION_ATOM_SIZE ) {
        //     // The first and last transaction is actually the same
        //     last_base_addr = first_base_addr;
        // } else {
        //     last_base_addr = (first_base_addr + total_axi_size) - (first_base_addr + total_axi_size)%AXI_TRANSACTION_ATOM_SIZE;
        // }
        // if (total_axi_size + first_base_addr%CVIF_MAX_MEM_TRANSACTION_SIZE <= CVIF_MAX_MEM_TRANSACTION_SIZE) {
        //     // Base and last are in the same AXI transaction
        // } else {
        //     // Base and last are in different AXI transaction
        //     last_base_addr = 
        // }
        // } else if ((first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE != 0) {
        //     if (total_axi_size >= (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE) {
        //         last_base_addr = first_base_addr + total_axi_size - (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE;
        //     } else {
        //         last_base_addr = first_base_addr;
        //     }
        // } else {
        //     if (total_axi_size >= CVIF_MAX_MEM_TRANSACTION_SIZE) {
        //         last_base_addr = first_base_addr + total_axi_size - CVIF_MAX_MEM_TRANSACTION_SIZE;
        //     } else {
        //         last_base_addr = first_base_addr;
        //     }
        // }
        cslDebug((50, "NV_NVDLA_cvif::WriteRequest_pdp2cvif:\x0A"));
        cslDebug((50, "    first_base_addr: 0x%lx\x0A", first_base_addr));
        cslDebug((50, "    last_base_addr: 0x%lx\x0A", last_base_addr));
        cslDebug((50, "    total_axi_size: 0x%x\x0A", total_axi_size));

        // cur_address = payload_addr;
        cur_address = is_base_64byte_align? payload_addr: first_base_addr; // Align to 64B
        //Split dma request to axi requests
        // while(cur_address < payload_addr + payload_size) {}
        while(cur_address <= last_base_addr) {
            base_addr    = cur_address;
            size_in_byte = AXI_TRANSACTION_ATOM_SIZE;
            // Check whether next ATOM belongs to current AXI transaction
            // while (((cur_address + DMA_TRANSACTION_ATOM_SIZE) < (payload_addr + payload_size)) && ((cur_address + DMA_TRANSACTION_ATOM_SIZE) % CVIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            //     size_in_byte += DMA_TRANSACTION_ATOM_SIZE;
            //     cur_address  += DMA_TRANSACTION_ATOM_SIZE;
            // }
            while (((cur_address + AXI_TRANSACTION_ATOM_SIZE) < (first_base_addr + total_axi_size)) && ((cur_address + AXI_TRANSACTION_ATOM_SIZE) % CVIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
                size_in_byte += AXI_TRANSACTION_ATOM_SIZE;
                cur_address  += AXI_TRANSACTION_ATOM_SIZE;
            }
            // start address of next axi transaction
            cur_address += AXI_TRANSACTION_ATOM_SIZE;

            atom_num = size_in_byte / DMA_TRANSACTION_ATOM_SIZE;

            bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
            axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
            cslDebug((50, "NV_NVDLA_cvif::WriteRequest_pdp2cvif, base_addr=0x%lx size_in_byte=0x%x atom_num=0x%x\x0A", base_addr, size_in_byte, atom_num));

            for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
                if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE)) {
                    // Diable 1st DMA atom of the unaligned first_base_addr
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                } else if (( (base_addr + size_in_byte) == (last_base_addr+AXI_TRANSACTION_ATOM_SIZE)) && (false == is_rear_64byte_align) && (byte_iter >= size_in_byte - DMA_TRANSACTION_ATOM_SIZE)) {
                    // Diable 2nd DMA atom of the unaligned last_base_addr
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                } else {
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;  // All bytes should be enabled
                }
            }
            cslDebug((50, "NV_NVDLA_cvif::WriteRequest_pdp2cvif, TLM_BYTE_ENABLE is done\x0A"));

            for (atom_iter=0; atom_iter < atom_num; atom_iter++) {
                if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) && (0 == atom_iter)) {
                    // Disable 1st DMA atom of the unaligned first_base_addr
                    // Use unaligned address as required by DBB_PV
                    memset(&bt_payload->data[atom_iter*DMA_TRANSACTION_ATOM_SIZE], 0, DMA_TRANSACTION_ATOM_SIZE);
                } else if (((base_addr + size_in_byte) == (last_base_addr+AXI_TRANSACTION_ATOM_SIZE)) && (false == is_rear_64byte_align) && ( (atom_iter + 1) == atom_num)) {
                    // Disable 2nd DMA atom of the unaligned last_base_addr
                    memset(&bt_payload->data[atom_iter*DMA_TRANSACTION_ATOM_SIZE], 0, DMA_TRANSACTION_ATOM_SIZE);
                } else {
                    cslDebug((50, "NV_NVDLA_cvif::WriteRequest_pdp2cvif, before read an atom from pdp2cvif_wr_data_fifo_, base_addr = 0x%lx, atom_iter=0x%x\x0A", base_addr, atom_iter));

                    axi_atom_ptr = pdp2cvif_wr_data_fifo_->read();
                    for(int i=0; i<DMA_TRANSACTION_ATOM_SIZE; i++) {
                        cslDebug((50, "%02x ", axi_atom_ptr[i]));
                    }
                    cslDebug((50, "\x0A"));
                    cslDebug((50, "NV_NVDLA_cvif::WriteRequest_pdp2cvif, after read an atom from pdp2cvif_wr_data_fifo_\x0A"));
                    memcpy(&bt_payload->data[atom_iter*DMA_TRANSACTION_ATOM_SIZE], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
                    delete[] axi_atom_ptr;
                }
            }

            if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) ) {
                base_addr += DMA_TRANSACTION_ATOM_SIZE;
            }
            cslDebug((50, "NV_NVDLA_cvif::WriteRequest_pdp2cvif, base_address=0x%lx size in byte=0x%x\x0A", base_addr, size_in_byte));
            // Prepare write payload
            bt_payload->configure_gp(base_addr, size_in_byte, is_read);
            bt_payload->gp.get_extension(nvdla_dbb_ext);
            cslDebug((50, "NV_NVDLA_cvif::WriteRequest_pdp2cvif, sending write command to pdp_wr_req_fifo_.\x0A"));
            cslDebug((50, "    addr: 0x%016lx\x0A", base_addr));
            cslDebug((50, "    size: %d\x0A", size_in_byte));
            nvdla_dbb_ext->set_id(PDP_AXI_ID);
            nvdla_dbb_ext->set_size(64);
            nvdla_dbb_ext->set_length(size_in_byte/AXI_TRANSACTION_ATOM_SIZE);
            // if (base_addr%AXI_TRANSACTION_ATOM_SIZE != 0) //Set length(in unit of 64B) to be same as RTL
            //     nvdla_dbb_ext->set_length(((size_in_byte - DMA_TRANSACTION_ATOM_SIZE) + DMA_TRANSACTION_ATOM_SIZE)/AXI_TRANSACTION_ATOM_SIZE);
            // else // base_addr is aligned to 64Bytes
            //     nvdla_dbb_ext->set_length((size_in_byte + DMA_TRANSACTION_ATOM_SIZE)/AXI_TRANSACTION_ATOM_SIZE-1);

            // write payload to arbiter fifo
            pdp_wr_req_fifo_->write(bt_payload);

            // When the last split req is sent to ext, write true to pdp_wr_required_ack_fifo_ when ack is required.
            if (cur_address >= (payload_addr + payload_size)) {
                if(pdp_wr_req->require_ack!=0) {
                    cslDebug((50, "NV_NVDLA_cvif::WriteRequest_pdp2cvif, require ack.\x0A"));
                    pdp_wr_required_ack_fifo_->write(true);
                }
                else {
                    cslDebug((50, "NV_NVDLA_cvif::WriteRequest_pdp2cvif, does not require ack.\x0A"));
                    pdp_wr_required_ack_fifo_->write(false);
                }
            }
            else {
                cslDebug((50, "NV_NVDLA_cvif::WriteRequest_pdp2cvif, does not require ack.\x0A"));
                pdp_wr_required_ack_fifo_->write(false);
            }
        }
        delete pdp_wr_req;
        cslDebug((50, "NV_NVDLA_cvif::WriteRequest_pdp2cvif, write command processing done\x0A"));
    }
}

void NV_NVDLA_cvif::cdp2cvif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) {
    uint32_t packet_id;
    uint8_t  *dma_payload_data_ptr;
    uint8_t  *data_ptr;
    uint32_t rest_size, incoming_size;
    client_cvif_wr_req_t * cdp_wr_req;

    packet_id = payload->tag;
    if (TAG_CMD == packet_id) {
        cdp_wr_req_count_ ++;
#pragma CTC SKIP
        if (true == has_cdp_onging_wr_req_) {
            FAIL(("NV_NVDLA_cvif::cdp2cvif_wr_req_b_transport, got two consective command request, one command request shall be followed by one or more data request."));
        }
#pragma CTC ENDSKIP
	else {
            has_cdp_onging_wr_req_ = true;
        }

        cdp_wr_req = new client_cvif_wr_req_t;
        cdp_wr_req->addr  = payload->pd.dma_write_cmd.addr;
        cdp_wr_req->size  = (payload->pd.dma_write_cmd.size + 1) * DMA_TRANSACTION_ATOM_SIZE;    //In byte
        cdp_wr_req->require_ack = payload->pd.dma_write_cmd.require_ack;
        cslDebug((50, "before write to cdp2cvif_wr_cmd_fifo_\x0A"));
        cdp2cvif_wr_cmd_fifo_->write(cdp_wr_req);
        cslDebug((50, "after write to cdp2cvif_wr_cmd_fifo_\x0A"));
        cdp_wr_req_got_size_ = 0;
        cdp_wr_req_size_ = cdp_wr_req->size;

    } else {
        dma_payload_data_ptr = reinterpret_cast <uint8_t *> (payload->pd.dma_write_data.data);
        rest_size = cdp_wr_req_size_ - cdp_wr_req_got_size_;
        incoming_size = min(rest_size, uint32_t (DMA_TRANSACTION_MAX_SIZE));
        data_ptr = new uint8_t[DMA_TRANSACTION_ATOM_SIZE];
        memcpy(data_ptr, dma_payload_data_ptr, DMA_TRANSACTION_ATOM_SIZE);
        cslDebug((50, "before write to cdp2cvif_wr_data_fifo_\x0A"));
        cdp2cvif_wr_data_fifo_->write(data_ptr);   // Write to FIFO in 32Byte atom
        cslDebug((50, "after write to cdp2cvif_wr_data_fifo_\x0A"));
        cdp_wr_req_got_size_ += incoming_size;
        for(int i = 0; i < DMA_TRANSACTION_ATOM_SIZE; i++) {
            cslDebug((50, "%x ", data_ptr[i]));
        }
        cslDebug((50, "\x0A"));
        if (incoming_size==DMA_TRANSACTION_MAX_SIZE) { // The payload is 64B
            data_ptr = new uint8_t[DMA_TRANSACTION_ATOM_SIZE];
            memcpy(data_ptr, &dma_payload_data_ptr[DMA_TRANSACTION_ATOM_SIZE], DMA_TRANSACTION_ATOM_SIZE);
            cslDebug((50, "write to cdp2cvif_wr_data_fifo_\x0A"));
            cdp2cvif_wr_data_fifo_->write(data_ptr);
            for(int i = 0; i < DMA_TRANSACTION_ATOM_SIZE; i++) {
                cslDebug((50, "%x ", data_ptr[i]));
            }
            cslDebug((50, "\x0A"));
        }

        if (cdp_wr_req_got_size_ == cdp_wr_req_size_) {
            has_cdp_onging_wr_req_ = false;
        }
    }
}

void NV_NVDLA_cvif::WriteRequest_cdp2cvif() {
    uint64_t base_addr;
    uint64_t first_base_addr;
    uint64_t last_base_addr;
    uint64_t cur_address;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    uint32_t atom_iter;
    uint32_t atom_num;
    bool     is_base_64byte_align;
    bool     is_rear_64byte_align;
    bool     is_read=false;
    uint8_t  *axi_atom_ptr;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    client_cvif_wr_req_t   * cdp_wr_req;
    dla_b_transport_payload *bt_payload;

    while(true) {
        // Read one write command
        cdp_wr_req = cdp2cvif_wr_cmd_fifo_->read();
        payload_addr = cdp_wr_req->addr;   // It's aligend to 32B, not 64B
        payload_size = cdp_wr_req->size;
        cslDebug((50, "NV_NVDLA_cvif::WriteRequest_cdp2cvif, got one write command from cdp2cvif_wr_cmd_fifo_\x0A"));
        cslDebug((50, "    payload_addr: 0x%lx\x0A", payload_addr));
        cslDebug((50, "    payload_size: 0x%x\x0A", payload_size));

        is_base_64byte_align = payload_addr%AXI_TRANSACTION_ATOM_SIZE == 0;
        first_base_addr = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B
        is_rear_64byte_align = (payload_addr + payload_size) % AXI_TRANSACTION_ATOM_SIZE == 0;
        // According to DBB_PV standard, data_length shall be equal or greater than DBB_PV m_size * m_length no matter the transactions is aglined or not
        total_axi_size = payload_size + (is_base_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE) + (is_rear_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE);
        last_base_addr = first_base_addr + total_axi_size - AXI_TRANSACTION_ATOM_SIZE;
        // if ( total_axi_size <= AXI_TRANSACTION_ATOM_SIZE ) {
        //     // The first and last transaction is actually the same
        //     last_base_addr = first_base_addr;
        // } else {
        //     last_base_addr = (first_base_addr + total_axi_size) - (first_base_addr + total_axi_size)%AXI_TRANSACTION_ATOM_SIZE;
        // }
        // if (total_axi_size + first_base_addr%CVIF_MAX_MEM_TRANSACTION_SIZE <= CVIF_MAX_MEM_TRANSACTION_SIZE) {
        //     // Base and last are in the same AXI transaction
        // } else {
        //     // Base and last are in different AXI transaction
        //     last_base_addr = 
        // }
        // } else if ((first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE != 0) {
        //     if (total_axi_size >= (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE) {
        //         last_base_addr = first_base_addr + total_axi_size - (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE;
        //     } else {
        //         last_base_addr = first_base_addr;
        //     }
        // } else {
        //     if (total_axi_size >= CVIF_MAX_MEM_TRANSACTION_SIZE) {
        //         last_base_addr = first_base_addr + total_axi_size - CVIF_MAX_MEM_TRANSACTION_SIZE;
        //     } else {
        //         last_base_addr = first_base_addr;
        //     }
        // }
        cslDebug((50, "NV_NVDLA_cvif::WriteRequest_cdp2cvif:\x0A"));
        cslDebug((50, "    first_base_addr: 0x%lx\x0A", first_base_addr));
        cslDebug((50, "    last_base_addr: 0x%lx\x0A", last_base_addr));
        cslDebug((50, "    total_axi_size: 0x%x\x0A", total_axi_size));

        // cur_address = payload_addr;
        cur_address = is_base_64byte_align? payload_addr: first_base_addr; // Align to 64B
        //Split dma request to axi requests
        // while(cur_address < payload_addr + payload_size) {}
        while(cur_address <= last_base_addr) {
            base_addr    = cur_address;
            size_in_byte = AXI_TRANSACTION_ATOM_SIZE;
            // Check whether next ATOM belongs to current AXI transaction
            // while (((cur_address + DMA_TRANSACTION_ATOM_SIZE) < (payload_addr + payload_size)) && ((cur_address + DMA_TRANSACTION_ATOM_SIZE) % CVIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            //     size_in_byte += DMA_TRANSACTION_ATOM_SIZE;
            //     cur_address  += DMA_TRANSACTION_ATOM_SIZE;
            // }
            while (((cur_address + AXI_TRANSACTION_ATOM_SIZE) < (first_base_addr + total_axi_size)) && ((cur_address + AXI_TRANSACTION_ATOM_SIZE) % CVIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
                size_in_byte += AXI_TRANSACTION_ATOM_SIZE;
                cur_address  += AXI_TRANSACTION_ATOM_SIZE;
            }
            // start address of next axi transaction
            cur_address += AXI_TRANSACTION_ATOM_SIZE;

            atom_num = size_in_byte / DMA_TRANSACTION_ATOM_SIZE;

            bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
            axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
            cslDebug((50, "NV_NVDLA_cvif::WriteRequest_cdp2cvif, base_addr=0x%lx size_in_byte=0x%x atom_num=0x%x\x0A", base_addr, size_in_byte, atom_num));

            for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
                if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE)) {
                    // Diable 1st DMA atom of the unaligned first_base_addr
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                } else if (( (base_addr + size_in_byte) == (last_base_addr+AXI_TRANSACTION_ATOM_SIZE)) && (false == is_rear_64byte_align) && (byte_iter >= size_in_byte - DMA_TRANSACTION_ATOM_SIZE)) {
                    // Diable 2nd DMA atom of the unaligned last_base_addr
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                } else {
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;  // All bytes should be enabled
                }
            }
            cslDebug((50, "NV_NVDLA_cvif::WriteRequest_cdp2cvif, TLM_BYTE_ENABLE is done\x0A"));

            for (atom_iter=0; atom_iter < atom_num; atom_iter++) {
                if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) && (0 == atom_iter)) {
                    // Disable 1st DMA atom of the unaligned first_base_addr
                    // Use unaligned address as required by DBB_PV
                    memset(&bt_payload->data[atom_iter*DMA_TRANSACTION_ATOM_SIZE], 0, DMA_TRANSACTION_ATOM_SIZE);
                } else if (((base_addr + size_in_byte) == (last_base_addr+AXI_TRANSACTION_ATOM_SIZE)) && (false == is_rear_64byte_align) && ( (atom_iter + 1) == atom_num)) {
                    // Disable 2nd DMA atom of the unaligned last_base_addr
                    memset(&bt_payload->data[atom_iter*DMA_TRANSACTION_ATOM_SIZE], 0, DMA_TRANSACTION_ATOM_SIZE);
                } else {
                    cslDebug((50, "NV_NVDLA_cvif::WriteRequest_cdp2cvif, before read an atom from cdp2cvif_wr_data_fifo_, base_addr = 0x%lx, atom_iter=0x%x\x0A", base_addr, atom_iter));

                    axi_atom_ptr = cdp2cvif_wr_data_fifo_->read();
                    for(int i=0; i<DMA_TRANSACTION_ATOM_SIZE; i++) {
                        cslDebug((50, "%02x ", axi_atom_ptr[i]));
                    }
                    cslDebug((50, "\x0A"));
                    cslDebug((50, "NV_NVDLA_cvif::WriteRequest_cdp2cvif, after read an atom from cdp2cvif_wr_data_fifo_\x0A"));
                    memcpy(&bt_payload->data[atom_iter*DMA_TRANSACTION_ATOM_SIZE], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
                    delete[] axi_atom_ptr;
                }
            }

            if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) ) {
                base_addr += DMA_TRANSACTION_ATOM_SIZE;
            }
            cslDebug((50, "NV_NVDLA_cvif::WriteRequest_cdp2cvif, base_address=0x%lx size in byte=0x%x\x0A", base_addr, size_in_byte));
            // Prepare write payload
            bt_payload->configure_gp(base_addr, size_in_byte, is_read);
            bt_payload->gp.get_extension(nvdla_dbb_ext);
            cslDebug((50, "NV_NVDLA_cvif::WriteRequest_cdp2cvif, sending write command to cdp_wr_req_fifo_.\x0A"));
            cslDebug((50, "    addr: 0x%016lx\x0A", base_addr));
            cslDebug((50, "    size: %d\x0A", size_in_byte));
            nvdla_dbb_ext->set_id(CDP_AXI_ID);
            nvdla_dbb_ext->set_size(64);
            nvdla_dbb_ext->set_length(size_in_byte/AXI_TRANSACTION_ATOM_SIZE);
            // if (base_addr%AXI_TRANSACTION_ATOM_SIZE != 0) //Set length(in unit of 64B) to be same as RTL
            //     nvdla_dbb_ext->set_length(((size_in_byte - DMA_TRANSACTION_ATOM_SIZE) + DMA_TRANSACTION_ATOM_SIZE)/AXI_TRANSACTION_ATOM_SIZE);
            // else // base_addr is aligned to 64Bytes
            //     nvdla_dbb_ext->set_length((size_in_byte + DMA_TRANSACTION_ATOM_SIZE)/AXI_TRANSACTION_ATOM_SIZE-1);

            // write payload to arbiter fifo
            cdp_wr_req_fifo_->write(bt_payload);

            // When the last split req is sent to ext, write true to cdp_wr_required_ack_fifo_ when ack is required.
            if (cur_address >= (payload_addr + payload_size)) {
                if(cdp_wr_req->require_ack!=0) {
                    cslDebug((50, "NV_NVDLA_cvif::WriteRequest_cdp2cvif, require ack.\x0A"));
                    cdp_wr_required_ack_fifo_->write(true);
                }
                else {
                    cslDebug((50, "NV_NVDLA_cvif::WriteRequest_cdp2cvif, does not require ack.\x0A"));
                    cdp_wr_required_ack_fifo_->write(false);
                }
            }
            else {
                cslDebug((50, "NV_NVDLA_cvif::WriteRequest_cdp2cvif, does not require ack.\x0A"));
                cdp_wr_required_ack_fifo_->write(false);
            }
        }
        delete cdp_wr_req;
        cslDebug((50, "NV_NVDLA_cvif::WriteRequest_cdp2cvif, write command processing done\x0A"));
    }
}

void NV_NVDLA_cvif::rbk2cvif_wr_req_b_transport(int ID, nvdla_dma_wr_req_t* payload, sc_time& delay) {
    uint32_t packet_id;
    uint8_t  *dma_payload_data_ptr;
    uint8_t  *data_ptr;
    uint32_t rest_size, incoming_size;
    client_cvif_wr_req_t * rbk_wr_req;

    packet_id = payload->tag;
    if (TAG_CMD == packet_id) {
        rbk_wr_req_count_ ++;
#pragma CTC SKIP
        if (true == has_rbk_onging_wr_req_) {
            FAIL(("NV_NVDLA_cvif::rbk2cvif_wr_req_b_transport, got two consective command request, one command request shall be followed by one or more data request."));
        }
#pragma CTC ENDSKIP
	else {
            has_rbk_onging_wr_req_ = true;
        }

        rbk_wr_req = new client_cvif_wr_req_t;
        rbk_wr_req->addr  = payload->pd.dma_write_cmd.addr;
        rbk_wr_req->size  = (payload->pd.dma_write_cmd.size + 1) * DMA_TRANSACTION_ATOM_SIZE;    //In byte
        rbk_wr_req->require_ack = payload->pd.dma_write_cmd.require_ack;
        cslDebug((50, "before write to rbk2cvif_wr_cmd_fifo_\x0A"));
        rbk2cvif_wr_cmd_fifo_->write(rbk_wr_req);
        cslDebug((50, "after write to rbk2cvif_wr_cmd_fifo_\x0A"));
        rbk_wr_req_got_size_ = 0;
        rbk_wr_req_size_ = rbk_wr_req->size;

    } else {
        dma_payload_data_ptr = reinterpret_cast <uint8_t *> (payload->pd.dma_write_data.data);
        rest_size = rbk_wr_req_size_ - rbk_wr_req_got_size_;
        incoming_size = min(rest_size, uint32_t (DMA_TRANSACTION_MAX_SIZE));
        data_ptr = new uint8_t[DMA_TRANSACTION_ATOM_SIZE];
        memcpy(data_ptr, dma_payload_data_ptr, DMA_TRANSACTION_ATOM_SIZE);
        cslDebug((50, "before write to rbk2cvif_wr_data_fifo_\x0A"));
        rbk2cvif_wr_data_fifo_->write(data_ptr);   // Write to FIFO in 32Byte atom
        cslDebug((50, "after write to rbk2cvif_wr_data_fifo_\x0A"));
        rbk_wr_req_got_size_ += incoming_size;
        for(int i = 0; i < DMA_TRANSACTION_ATOM_SIZE; i++) {
            cslDebug((50, "%x ", data_ptr[i]));
        }
        cslDebug((50, "\x0A"));
        if (incoming_size==DMA_TRANSACTION_MAX_SIZE) { // The payload is 64B
            data_ptr = new uint8_t[DMA_TRANSACTION_ATOM_SIZE];
            memcpy(data_ptr, &dma_payload_data_ptr[DMA_TRANSACTION_ATOM_SIZE], DMA_TRANSACTION_ATOM_SIZE);
            cslDebug((50, "write to rbk2cvif_wr_data_fifo_\x0A"));
            rbk2cvif_wr_data_fifo_->write(data_ptr);
            for(int i = 0; i < DMA_TRANSACTION_ATOM_SIZE; i++) {
                cslDebug((50, "%x ", data_ptr[i]));
            }
            cslDebug((50, "\x0A"));
        }

        if (rbk_wr_req_got_size_ == rbk_wr_req_size_) {
            has_rbk_onging_wr_req_ = false;
        }
    }
}

void NV_NVDLA_cvif::WriteRequest_rbk2cvif() {
    uint64_t base_addr;
    uint64_t first_base_addr;
    uint64_t last_base_addr;
    uint64_t cur_address;
    uint32_t size_in_byte;
    uint32_t total_axi_size;
    uint64_t payload_addr;
    uint32_t payload_size;
    uint8_t* axi_byte_enable_ptr;
    uint32_t byte_iter;
    uint32_t atom_iter;
    uint32_t atom_num;
    bool     is_base_64byte_align;
    bool     is_rear_64byte_align;
    bool     is_read=false;
    uint8_t  *axi_atom_ptr;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    client_cvif_wr_req_t   * rbk_wr_req;
    dla_b_transport_payload *bt_payload;

    while(true) {
        // Read one write command
        rbk_wr_req = rbk2cvif_wr_cmd_fifo_->read();
        payload_addr = rbk_wr_req->addr;   // It's aligend to 32B, not 64B
        payload_size = rbk_wr_req->size;
        cslDebug((50, "NV_NVDLA_cvif::WriteRequest_rbk2cvif, got one write command from rbk2cvif_wr_cmd_fifo_\x0A"));
        cslDebug((50, "    payload_addr: 0x%lx\x0A", payload_addr));
        cslDebug((50, "    payload_size: 0x%x\x0A", payload_size));

        is_base_64byte_align = payload_addr%AXI_TRANSACTION_ATOM_SIZE == 0;
        first_base_addr = is_base_64byte_align? payload_addr: payload_addr - DMA_TRANSACTION_ATOM_SIZE; // Align to 64B
        is_rear_64byte_align = (payload_addr + payload_size) % AXI_TRANSACTION_ATOM_SIZE == 0;
        // According to DBB_PV standard, data_length shall be equal or greater than DBB_PV m_size * m_length no matter the transactions is aglined or not
        total_axi_size = payload_size + (is_base_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE) + (is_rear_64byte_align? 0: DMA_TRANSACTION_ATOM_SIZE);
        last_base_addr = first_base_addr + total_axi_size - AXI_TRANSACTION_ATOM_SIZE;
        // if ( total_axi_size <= AXI_TRANSACTION_ATOM_SIZE ) {
        //     // The first and last transaction is actually the same
        //     last_base_addr = first_base_addr;
        // } else {
        //     last_base_addr = (first_base_addr + total_axi_size) - (first_base_addr + total_axi_size)%AXI_TRANSACTION_ATOM_SIZE;
        // }
        // if (total_axi_size + first_base_addr%CVIF_MAX_MEM_TRANSACTION_SIZE <= CVIF_MAX_MEM_TRANSACTION_SIZE) {
        //     // Base and last are in the same AXI transaction
        // } else {
        //     // Base and last are in different AXI transaction
        //     last_base_addr = 
        // }
        // } else if ((first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE != 0) {
        //     if (total_axi_size >= (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE) {
        //         last_base_addr = first_base_addr + total_axi_size - (first_base_addr + total_axi_size)%CVIF_MAX_MEM_TRANSACTION_SIZE;
        //     } else {
        //         last_base_addr = first_base_addr;
        //     }
        // } else {
        //     if (total_axi_size >= CVIF_MAX_MEM_TRANSACTION_SIZE) {
        //         last_base_addr = first_base_addr + total_axi_size - CVIF_MAX_MEM_TRANSACTION_SIZE;
        //     } else {
        //         last_base_addr = first_base_addr;
        //     }
        // }
        cslDebug((50, "NV_NVDLA_cvif::WriteRequest_rbk2cvif:\x0A"));
        cslDebug((50, "    first_base_addr: 0x%lx\x0A", first_base_addr));
        cslDebug((50, "    last_base_addr: 0x%lx\x0A", last_base_addr));
        cslDebug((50, "    total_axi_size: 0x%x\x0A", total_axi_size));

        // cur_address = payload_addr;
        cur_address = is_base_64byte_align? payload_addr: first_base_addr; // Align to 64B
        //Split dma request to axi requests
        // while(cur_address < payload_addr + payload_size) {}
        while(cur_address <= last_base_addr) {
            base_addr    = cur_address;
            size_in_byte = AXI_TRANSACTION_ATOM_SIZE;
            // Check whether next ATOM belongs to current AXI transaction
            // while (((cur_address + DMA_TRANSACTION_ATOM_SIZE) < (payload_addr + payload_size)) && ((cur_address + DMA_TRANSACTION_ATOM_SIZE) % CVIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
            //     size_in_byte += DMA_TRANSACTION_ATOM_SIZE;
            //     cur_address  += DMA_TRANSACTION_ATOM_SIZE;
            // }
            while (((cur_address + AXI_TRANSACTION_ATOM_SIZE) < (first_base_addr + total_axi_size)) && ((cur_address + AXI_TRANSACTION_ATOM_SIZE) % CVIF_MAX_MEM_TRANSACTION_SIZE != 0)) {
                size_in_byte += AXI_TRANSACTION_ATOM_SIZE;
                cur_address  += AXI_TRANSACTION_ATOM_SIZE;
            }
            // start address of next axi transaction
            cur_address += AXI_TRANSACTION_ATOM_SIZE;

            atom_num = size_in_byte / DMA_TRANSACTION_ATOM_SIZE;

            bt_payload = new dla_b_transport_payload(size_in_byte, dla_b_transport_payload::DLA_B_TRANSPORT_PAYLOAD_TYPE_MC);
            axi_byte_enable_ptr = bt_payload->gp.get_byte_enable_ptr();
            cslDebug((50, "NV_NVDLA_cvif::WriteRequest_rbk2cvif, base_addr=0x%lx size_in_byte=0x%x atom_num=0x%x\x0A", base_addr, size_in_byte, atom_num));

            for (byte_iter=0; byte_iter < size_in_byte; byte_iter++) {
                if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) && (byte_iter < DMA_TRANSACTION_ATOM_SIZE)) {
                    // Diable 1st DMA atom of the unaligned first_base_addr
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                } else if (( (base_addr + size_in_byte) == (last_base_addr+AXI_TRANSACTION_ATOM_SIZE)) && (false == is_rear_64byte_align) && (byte_iter >= size_in_byte - DMA_TRANSACTION_ATOM_SIZE)) {
                    // Diable 2nd DMA atom of the unaligned last_base_addr
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_DISABLED;  // All bytes should be enabled
                } else {
                    axi_byte_enable_ptr[byte_iter] = TLM_BYTE_ENABLED;  // All bytes should be enabled
                }
            }
            cslDebug((50, "NV_NVDLA_cvif::WriteRequest_rbk2cvif, TLM_BYTE_ENABLE is done\x0A"));

            for (atom_iter=0; atom_iter < atom_num; atom_iter++) {
                if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) && (0 == atom_iter)) {
                    // Disable 1st DMA atom of the unaligned first_base_addr
                    // Use unaligned address as required by DBB_PV
                    memset(&bt_payload->data[atom_iter*DMA_TRANSACTION_ATOM_SIZE], 0, DMA_TRANSACTION_ATOM_SIZE);
                } else if (((base_addr + size_in_byte) == (last_base_addr+AXI_TRANSACTION_ATOM_SIZE)) && (false == is_rear_64byte_align) && ( (atom_iter + 1) == atom_num)) {
                    // Disable 2nd DMA atom of the unaligned last_base_addr
                    memset(&bt_payload->data[atom_iter*DMA_TRANSACTION_ATOM_SIZE], 0, DMA_TRANSACTION_ATOM_SIZE);
                } else {
                    cslDebug((50, "NV_NVDLA_cvif::WriteRequest_rbk2cvif, before read an atom from rbk2cvif_wr_data_fifo_, base_addr = 0x%lx, atom_iter=0x%x\x0A", base_addr, atom_iter));

                    axi_atom_ptr = rbk2cvif_wr_data_fifo_->read();
                    for(int i=0; i<DMA_TRANSACTION_ATOM_SIZE; i++) {
                        cslDebug((50, "%02x ", axi_atom_ptr[i]));
                    }
                    cslDebug((50, "\x0A"));
                    cslDebug((50, "NV_NVDLA_cvif::WriteRequest_rbk2cvif, after read an atom from rbk2cvif_wr_data_fifo_\x0A"));
                    memcpy(&bt_payload->data[atom_iter*DMA_TRANSACTION_ATOM_SIZE], axi_atom_ptr, DMA_TRANSACTION_ATOM_SIZE);
                    delete[] axi_atom_ptr;
                }
            }

            if ( (base_addr == first_base_addr) && (false == is_base_64byte_align) ) {
                base_addr += DMA_TRANSACTION_ATOM_SIZE;
            }
            cslDebug((50, "NV_NVDLA_cvif::WriteRequest_rbk2cvif, base_address=0x%lx size in byte=0x%x\x0A", base_addr, size_in_byte));
            // Prepare write payload
            bt_payload->configure_gp(base_addr, size_in_byte, is_read);
            bt_payload->gp.get_extension(nvdla_dbb_ext);
            cslDebug((50, "NV_NVDLA_cvif::WriteRequest_rbk2cvif, sending write command to rbk_wr_req_fifo_.\x0A"));
            cslDebug((50, "    addr: 0x%016lx\x0A", base_addr));
            cslDebug((50, "    size: %d\x0A", size_in_byte));
            nvdla_dbb_ext->set_id(RBK_AXI_ID);
            nvdla_dbb_ext->set_size(64);
            nvdla_dbb_ext->set_length(size_in_byte/AXI_TRANSACTION_ATOM_SIZE);
            // if (base_addr%AXI_TRANSACTION_ATOM_SIZE != 0) //Set length(in unit of 64B) to be same as RTL
            //     nvdla_dbb_ext->set_length(((size_in_byte - DMA_TRANSACTION_ATOM_SIZE) + DMA_TRANSACTION_ATOM_SIZE)/AXI_TRANSACTION_ATOM_SIZE);
            // else // base_addr is aligned to 64Bytes
            //     nvdla_dbb_ext->set_length((size_in_byte + DMA_TRANSACTION_ATOM_SIZE)/AXI_TRANSACTION_ATOM_SIZE-1);

            // write payload to arbiter fifo
            rbk_wr_req_fifo_->write(bt_payload);

            // When the last split req is sent to ext, write true to rbk_wr_required_ack_fifo_ when ack is required.
            if (cur_address >= (payload_addr + payload_size)) {
                if(rbk_wr_req->require_ack!=0) {
                    cslDebug((50, "NV_NVDLA_cvif::WriteRequest_rbk2cvif, require ack.\x0A"));
                    rbk_wr_required_ack_fifo_->write(true);
                }
                else {
                    cslDebug((50, "NV_NVDLA_cvif::WriteRequest_rbk2cvif, does not require ack.\x0A"));
                    rbk_wr_required_ack_fifo_->write(false);
                }
            }
            else {
                cslDebug((50, "NV_NVDLA_cvif::WriteRequest_rbk2cvif, does not require ack.\x0A"));
                rbk_wr_required_ack_fifo_->write(false);
            }
        }
        delete rbk_wr_req;
        cslDebug((50, "NV_NVDLA_cvif::WriteRequest_rbk2cvif, write command processing done\x0A"));
    }
}


void NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport(int ID, tlm::tlm_generic_payload& tlm_gp, sc_time& delay) {
    uint32_t            dma_sent_size;
    // uint64_t            axi_address;
    uint8_t*            axi_data_ptr;
    uint32_t            axi_length;
    uint8_t*            axi_byte_enable_ptr;
    uint32_t            axi_byte_enable_length;
    uint8_t             axi_id;
    // uint8_t             axi2dma_byte_iter;
    // uint8_t             axi_byte_enable_checker;
    uint8_t             dma_payload_atom_mask;  // mask for one DMA atom
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    uint8_t           * axi_atom_ptr;
    uint32_t            idx;
    
    // Get DBB extension
    tlm_gp.get_extension(nvdla_dbb_ext);
#pragma CTC SKIP
    if(!nvdla_dbb_ext) {
        FAIL(("NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, DBB extension is required, ar_id is needed to forward data to corresponding DMA."));
    }
#pragma CTC ENDSKIP

    axi_data_ptr           =  tlm_gp.get_data_ptr();
    axi_length             =  tlm_gp.get_data_length();  // axi_length is max 256B for CVIF
    axi_byte_enable_ptr    =  tlm_gp.get_byte_enable_ptr();
    axi_byte_enable_length =  tlm_gp.get_byte_enable_length();
    cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport\x0A"));
    cslDebug((50, "axi_data_ptr: 0x%p\x0A", (void *) axi_data_ptr));
    cslDebug((50, "axi_length: %d\x0A", axi_length));
    cslDebug((50, "axi_byte_enable_ptr: 0x%p\x0A", (void *) axi_byte_enable_ptr));
    cslDebug((50, "axi_byte_enable_length: %d\x0A", axi_byte_enable_length));
    axi_id                 =  nvdla_dbb_ext->get_id();

    // Data from general payload
    //  # AXI transaction size shall not be greater than 256 bytes
    //  # NVDLA dma request atom size is 32 byte, so the AXI lenght shall also be 32 byte algined
    //  # byte enables within 32 bytes shall be the same
#pragma CTC SKIP
    if (axi_length > CVIF_MAX_MEM_TRANSACTION_SIZE) {
        FAIL(("NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, Max AXI transaction length is %d byte, current AXI transaction length is %d byte", CVIF_MAX_MEM_TRANSACTION_SIZE, axi_length));
    }
    if (0 != (axi_length%DMA_TRANSACTION_ATOM_SIZE)) {
        FAIL(("NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, AXI transaction length shall be an integral multiple of %d byte, current AXI transaction length is %d byte", DMA_TRANSACTION_ATOM_SIZE, axi_length));
    }
#pragma CTC ENDSKIP
    //  Parsing AXI payload and generating DMA response payloads
    dma_sent_size = 0;
    for (dma_sent_size = 0; dma_sent_size < axi_length; dma_sent_size += DMA_TRANSACTION_ATOM_SIZE) {
        cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, dma_sent_size: 0x%x\x0A", dma_sent_size));
        switch (axi_id) {

           case BDMA_AXI_ID:
                    dma_payload_atom_mask = (true == bdma_rd_atom_enable_fifo_->read())?0x1:0;
                    cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, read bdma_rd_atom_enable_fifo_, bdma payload atom mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
                break;
           case SDP_AXI_ID:
                    dma_payload_atom_mask = (true == sdp_rd_atom_enable_fifo_->read())?0x1:0;
                    cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, read sdp_rd_atom_enable_fifo_, sdp payload atom mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
                break;
           case PDP_AXI_ID:
                    dma_payload_atom_mask = (true == pdp_rd_atom_enable_fifo_->read())?0x1:0;
                    cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, read pdp_rd_atom_enable_fifo_, pdp payload atom mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
                break;
           case CDP_AXI_ID:
                    dma_payload_atom_mask = (true == cdp_rd_atom_enable_fifo_->read())?0x1:0;
                    cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, read cdp_rd_atom_enable_fifo_, cdp payload atom mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
                break;
           case RBK_AXI_ID:
                    dma_payload_atom_mask = (true == rbk_rd_atom_enable_fifo_->read())?0x1:0;
                    cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, read rbk_rd_atom_enable_fifo_, rbk payload atom mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
                break;
           case SDP_B_AXI_ID:
                    dma_payload_atom_mask = (true == sdp_b_rd_atom_enable_fifo_->read())?0x1:0;
                    cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, read sdp_b_rd_atom_enable_fifo_, sdp_b payload atom mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
                break;
           case SDP_N_AXI_ID:
                    dma_payload_atom_mask = (true == sdp_n_rd_atom_enable_fifo_->read())?0x1:0;
                    cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, read sdp_n_rd_atom_enable_fifo_, sdp_n payload atom mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
                break;
           case SDP_E_AXI_ID:
                    dma_payload_atom_mask = (true == sdp_e_rd_atom_enable_fifo_->read())?0x1:0;
                    cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, read sdp_e_rd_atom_enable_fifo_, sdp_e payload atom mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
                break;
           case CDMA_DAT_AXI_ID:
                    dma_payload_atom_mask = (true == cdma_dat_rd_atom_enable_fifo_->read())?0x1:0;
                    cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, read cdma_dat_rd_atom_enable_fifo_, cdma_dat payload atom mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
                break;
           case CDMA_WT_AXI_ID:
                    dma_payload_atom_mask = (true == cdma_wt_rd_atom_enable_fifo_->read())?0x1:0;
                    cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, read cdma_wt_rd_atom_enable_fifo_, cdma_wt payload atom mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
                break;

#pragma CTC SKIP
            default:
                FAIL(("NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, unexpected AXI ID"));
#pragma CTC ENDSKIP
        }
        // Push read returned data atom(32B) into fifo
        if (0x1 == dma_payload_atom_mask) {
            axi_atom_ptr = new uint8_t[DMA_TRANSACTION_ATOM_SIZE];
            memcpy (axi_atom_ptr, &axi_data_ptr[dma_sent_size], DMA_TRANSACTION_ATOM_SIZE);
            switch (axi_id) {

                 case BDMA_AXI_ID:
                        cslDebug((70, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, axi_atom_ptr value:\x0A"));
                        for (idx = 0; idx < DMA_TRANSACTION_ATOM_SIZE; idx ++) {
                            cslDebug((70, "    0x%lx\x0A", uint64_t (axi_atom_ptr[idx])));
                        }
                        cvif2bdma_rd_rsp_fifo_->write(axi_atom_ptr);
                        cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, bdma payload atom mask is 0x1, write an atom to cvif2bdma_rd_rsp_fifo_.\x0A"));
                    break;
                 case SDP_AXI_ID:
                        cslDebug((70, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, axi_atom_ptr value:\x0A"));
                        for (idx = 0; idx < DMA_TRANSACTION_ATOM_SIZE; idx ++) {
                            cslDebug((70, "    0x%lx\x0A", uint64_t (axi_atom_ptr[idx])));
                        }
                        cvif2sdp_rd_rsp_fifo_->write(axi_atom_ptr);
                        cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, sdp payload atom mask is 0x1, write an atom to cvif2sdp_rd_rsp_fifo_.\x0A"));
                    break;
                 case PDP_AXI_ID:
                        cslDebug((70, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, axi_atom_ptr value:\x0A"));
                        for (idx = 0; idx < DMA_TRANSACTION_ATOM_SIZE; idx ++) {
                            cslDebug((70, "    0x%lx\x0A", uint64_t (axi_atom_ptr[idx])));
                        }
                        cvif2pdp_rd_rsp_fifo_->write(axi_atom_ptr);
                        cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, pdp payload atom mask is 0x1, write an atom to cvif2pdp_rd_rsp_fifo_.\x0A"));
                    break;
                 case CDP_AXI_ID:
                        cslDebug((70, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, axi_atom_ptr value:\x0A"));
                        for (idx = 0; idx < DMA_TRANSACTION_ATOM_SIZE; idx ++) {
                            cslDebug((70, "    0x%lx\x0A", uint64_t (axi_atom_ptr[idx])));
                        }
                        cvif2cdp_rd_rsp_fifo_->write(axi_atom_ptr);
                        cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, cdp payload atom mask is 0x1, write an atom to cvif2cdp_rd_rsp_fifo_.\x0A"));
                    break;
                 case RBK_AXI_ID:
                        cslDebug((70, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, axi_atom_ptr value:\x0A"));
                        for (idx = 0; idx < DMA_TRANSACTION_ATOM_SIZE; idx ++) {
                            cslDebug((70, "    0x%lx\x0A", uint64_t (axi_atom_ptr[idx])));
                        }
                        cvif2rbk_rd_rsp_fifo_->write(axi_atom_ptr);
                        cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, rbk payload atom mask is 0x1, write an atom to cvif2rbk_rd_rsp_fifo_.\x0A"));
                    break;
                 case SDP_B_AXI_ID:
                        cslDebug((70, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, axi_atom_ptr value:\x0A"));
                        for (idx = 0; idx < DMA_TRANSACTION_ATOM_SIZE; idx ++) {
                            cslDebug((70, "    0x%lx\x0A", uint64_t (axi_atom_ptr[idx])));
                        }
                        cvif2sdp_b_rd_rsp_fifo_->write(axi_atom_ptr);
                        cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, sdp_b payload atom mask is 0x1, write an atom to cvif2sdp_b_rd_rsp_fifo_.\x0A"));
                    break;
                 case SDP_N_AXI_ID:
                        cslDebug((70, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, axi_atom_ptr value:\x0A"));
                        for (idx = 0; idx < DMA_TRANSACTION_ATOM_SIZE; idx ++) {
                            cslDebug((70, "    0x%lx\x0A", uint64_t (axi_atom_ptr[idx])));
                        }
                        cvif2sdp_n_rd_rsp_fifo_->write(axi_atom_ptr);
                        cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, sdp_n payload atom mask is 0x1, write an atom to cvif2sdp_n_rd_rsp_fifo_.\x0A"));
                    break;
                 case SDP_E_AXI_ID:
                        cslDebug((70, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, axi_atom_ptr value:\x0A"));
                        for (idx = 0; idx < DMA_TRANSACTION_ATOM_SIZE; idx ++) {
                            cslDebug((70, "    0x%lx\x0A", uint64_t (axi_atom_ptr[idx])));
                        }
                        cvif2sdp_e_rd_rsp_fifo_->write(axi_atom_ptr);
                        cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, sdp_e payload atom mask is 0x1, write an atom to cvif2sdp_e_rd_rsp_fifo_.\x0A"));
                    break;
                 case CDMA_DAT_AXI_ID:
                        cslDebug((70, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, axi_atom_ptr value:\x0A"));
                        for (idx = 0; idx < DMA_TRANSACTION_ATOM_SIZE; idx ++) {
                            cslDebug((70, "    0x%lx\x0A", uint64_t (axi_atom_ptr[idx])));
                        }
                        cvif2cdma_dat_rd_rsp_fifo_->write(axi_atom_ptr);
                        cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, cdma_dat payload atom mask is 0x1, write an atom to cvif2cdma_dat_rd_rsp_fifo_.\x0A"));
                    break;
                 case CDMA_WT_AXI_ID:
                        cslDebug((70, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, axi_atom_ptr value:\x0A"));
                        for (idx = 0; idx < DMA_TRANSACTION_ATOM_SIZE; idx ++) {
                            cslDebug((70, "    0x%lx\x0A", uint64_t (axi_atom_ptr[idx])));
                        }
                        cvif2cdma_wt_rd_rsp_fifo_->write(axi_atom_ptr);
                        cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, cdma_wt payload atom mask is 0x1, write an atom to cvif2cdma_wt_rd_rsp_fifo_.\x0A"));
                    break;

#pragma CTC SKIP
                default:
                    FAIL(("NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, unexpected AXI ID"));
#pragma CTC ENDSKIP
            }
        } else {
            cslDebug((50, "NV_NVDLA_cvif::ext2cvif_rd_rsp_b_transport, {client} payload atom mask is 0x0, ignore current atom, dma_payload_atom_mask is 0x%x\x0A", uint32_t(dma_payload_atom_mask)));
        }
    }

    tlm_gp.set_response_status(tlm::TLM_OK_RESPONSE);
}

void NV_NVDLA_cvif::ext2cvif_wr_rsp_b_transport(int ID, tlm::tlm_generic_payload& tlm_gp, sc_time& delay) {
    uint8_t             axi_id;
    nvdla_dbb_extension *nvdla_dbb_ext = NULL;
    cslDebug((50, "NV_NVDLA_cvif::ext2cvif_wr_rsp_b_transport.\x0A"));

    // Get DBB extension
    tlm_gp.get_extension(nvdla_dbb_ext);
#pragma CTC SKIP
    if(!nvdla_dbb_ext) {
        FAIL(("NV_NVDLA_cvif::ext2cvif_wr_rsp_b_transport, DBB extension is required, ar_id is needed to forward data to corresponding DMA."));
    }
#pragma CTC ENDSKIP

    axi_id  = nvdla_dbb_ext->get_id();
    switch (axi_id) {

        case BDMA_AXI_ID:
            bdma_wr_rsp_count_ ++;
            // Read a new reques id from fifo
            bdma_wr_req_expected_ack = bdma_wr_required_ack_fifo_->read();
            if (true == bdma_wr_req_expected_ack) {
                cslDebug((50, "send wr rsp to bdma\x0A"));
                //FIXME(skip-t194): we can add assertion bdma_wr_rsp_count_ == bdma_wr_cmd_count_fifo_->read 
                NV_NVDLA_cvif_base::cvif2bdma_wr_rsp.write(true);
                //FIXME(skip-t194): WAR to add wait here. Otherwise, the client will not receive the signal when two "true" are sent to client continuously.
                // wait(0, SC_NS);
                // NV_NVDLA_cvif_base::cvif2bdma_wr_rsp.write(false);
            } else {
                // NV_NVDLA_cvif_base::cvif2bdma_wr_rsp.write(false);
            }
            break;
        case SDP_AXI_ID:
            sdp_wr_rsp_count_ ++;
            // Read a new reques id from fifo
            sdp_wr_req_expected_ack = sdp_wr_required_ack_fifo_->read();
            if (true == sdp_wr_req_expected_ack) {
                cslDebug((50, "send wr rsp to sdp\x0A"));
                //FIXME(skip-t194): we can add assertion sdp_wr_rsp_count_ == sdp_wr_cmd_count_fifo_->read 
                NV_NVDLA_cvif_base::cvif2sdp_wr_rsp.write(true);
                //FIXME(skip-t194): WAR to add wait here. Otherwise, the client will not receive the signal when two "true" are sent to client continuously.
                // wait(0, SC_NS);
                // NV_NVDLA_cvif_base::cvif2sdp_wr_rsp.write(false);
            } else {
                // NV_NVDLA_cvif_base::cvif2sdp_wr_rsp.write(false);
            }
            break;
        case PDP_AXI_ID:
            pdp_wr_rsp_count_ ++;
            // Read a new reques id from fifo
            pdp_wr_req_expected_ack = pdp_wr_required_ack_fifo_->read();
            if (true == pdp_wr_req_expected_ack) {
                cslDebug((50, "send wr rsp to pdp\x0A"));
                //FIXME(skip-t194): we can add assertion pdp_wr_rsp_count_ == pdp_wr_cmd_count_fifo_->read 
                NV_NVDLA_cvif_base::cvif2pdp_wr_rsp.write(true);
                //FIXME(skip-t194): WAR to add wait here. Otherwise, the client will not receive the signal when two "true" are sent to client continuously.
                // wait(0, SC_NS);
                // NV_NVDLA_cvif_base::cvif2pdp_wr_rsp.write(false);
            } else {
                // NV_NVDLA_cvif_base::cvif2pdp_wr_rsp.write(false);
            }
            break;
        case CDP_AXI_ID:
            cdp_wr_rsp_count_ ++;
            // Read a new reques id from fifo
            cdp_wr_req_expected_ack = cdp_wr_required_ack_fifo_->read();
            if (true == cdp_wr_req_expected_ack) {
                cslDebug((50, "send wr rsp to cdp\x0A"));
                //FIXME(skip-t194): we can add assertion cdp_wr_rsp_count_ == cdp_wr_cmd_count_fifo_->read 
                NV_NVDLA_cvif_base::cvif2cdp_wr_rsp.write(true);
                //FIXME(skip-t194): WAR to add wait here. Otherwise, the client will not receive the signal when two "true" are sent to client continuously.
                // wait(0, SC_NS);
                // NV_NVDLA_cvif_base::cvif2cdp_wr_rsp.write(false);
            } else {
                // NV_NVDLA_cvif_base::cvif2cdp_wr_rsp.write(false);
            }
            break;
        case RBK_AXI_ID:
            rbk_wr_rsp_count_ ++;
            // Read a new reques id from fifo
            rbk_wr_req_expected_ack = rbk_wr_required_ack_fifo_->read();
            if (true == rbk_wr_req_expected_ack) {
                cslDebug((50, "send wr rsp to rbk\x0A"));
                //FIXME(skip-t194): we can add assertion rbk_wr_rsp_count_ == rbk_wr_cmd_count_fifo_->read 
                NV_NVDLA_cvif_base::cvif2rbk_wr_rsp.write(true);
                //FIXME(skip-t194): WAR to add wait here. Otherwise, the client will not receive the signal when two "true" are sent to client continuously.
                // wait(0, SC_NS);
                // NV_NVDLA_cvif_base::cvif2rbk_wr_rsp.write(false);
            } else {
                // NV_NVDLA_cvif_base::cvif2rbk_wr_rsp.write(false);
            }
            break;

#pragma CTC SKIP
        default:
            FAIL(("NV_NVDLA_cvif::ext2cvif_wr_rsp_b_transport, unexpected AXI ID"));
#pragma CTC ENDSKIP
    }
    // wait( SC_ZERO_TIME);
    tlm_gp.set_response_status(tlm::TLM_OK_RESPONSE);
}

void NV_NVDLA_cvif::ReadRequestArbiter() {
    bool bdma_ready, cdma_dat_ready, cdma_wt_ready, sdp_ready, pdp_ready, cdp_ready;
    bool rbk_ready, sdp_b_ready, sdp_n_ready, sdp_e_ready;
    while (true) {
        if (bdma_rd_req_payload_ == NULL) {
            bdma_rd_req_fifo_->nb_read(bdma_rd_req_payload_);
        }
        if (bdma_rd_req_payload_ != NULL) {
            int payload_size = (bdma_rd_req_payload_->gp.get_data_length());
            int atom_num = payload_size/DMA_TRANSACTION_ATOM_SIZE;
            if (credit_cvif2bdma_rd_rsp_fifo_ >= atom_num) {
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
            int atom_num = payload_size/DMA_TRANSACTION_ATOM_SIZE;
            if (credit_cvif2cdma_dat_rd_rsp_fifo_ >= atom_num) {
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
            int atom_num = payload_size/DMA_TRANSACTION_ATOM_SIZE;
            if (credit_cvif2cdma_wt_rd_rsp_fifo_ >= atom_num) {
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
            int atom_num = payload_size/DMA_TRANSACTION_ATOM_SIZE;
            if (credit_cvif2sdp_rd_rsp_fifo_ >= atom_num) {
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
            int atom_num = payload_size/DMA_TRANSACTION_ATOM_SIZE;
            if (credit_cvif2sdp_b_rd_rsp_fifo_ >= atom_num) {
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
            int atom_num = payload_size/DMA_TRANSACTION_ATOM_SIZE;
            if (credit_cvif2sdp_n_rd_rsp_fifo_ >= atom_num) {
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
            int atom_num = payload_size/DMA_TRANSACTION_ATOM_SIZE;
            if (credit_cvif2sdp_e_rd_rsp_fifo_ >= atom_num) {
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
            int atom_num = payload_size/DMA_TRANSACTION_ATOM_SIZE;
            if (credit_cvif2rbk_rd_rsp_fifo_ >= atom_num) {
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
            int atom_num = payload_size/DMA_TRANSACTION_ATOM_SIZE;
            if (credit_cvif2pdp_rd_rsp_fifo_ >= atom_num) {
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
            int atom_num = payload_size/DMA_TRANSACTION_ATOM_SIZE;
            if (credit_cvif2cdp_rd_rsp_fifo_ >= atom_num) {
                cdp_ready = true;
            } else {
                cdp_ready = false;
            }
        } else {
            cdp_ready = false;
        }
               
        if( !cdma_dat_ready && !cdma_wt_ready && !bdma_ready && !sdp_ready &&
        !pdp_ready && !cdp_ready && !rbk_ready && !sdp_b_ready && !sdp_n_ready && !sdp_e_ready) {{   
            cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, no pending request, waiting.\x0A"));
            wait();
            cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, get new request, wake up.\x0A"));
        }}

        // Get a FIFO write event, query dma read request FIFOs

        // For BDMA
        if (bdma_rd_req_payload_ != NULL) {
            int payload_size = bdma_rd_req_payload_->gp.get_data_length();
            uint8_t* axi_byte_enable_ptr = bdma_rd_req_payload_->gp.get_byte_enable_ptr();
            int atom_num = 0;
            for (int i=0; i<payload_size/DMA_TRANSACTION_ATOM_SIZE; i++)
                atom_num += axi_byte_enable_ptr[i*DMA_TRANSACTION_ATOM_SIZE] == TLM_BYTE_ENABLED;
            if (credit_cvif2bdma_rd_rsp_fifo_ >= atom_num) {   // Same as bdma_ready
                credit_cvif2bdma_rd_rsp_fifo_ -= atom_num;
                cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, send read request, payload from bdma, begin, atom:%d, num_free:%d credit_cvif2bdma_rd_rsp_fifo_=%d.\x0A", atom_num, cvif2bdma_rd_rsp_fifo_->num_free(), credit_cvif2bdma_rd_rsp_fifo_));

                cvif2ext_rd_req->b_transport(bdma_rd_req_payload_->gp, axi_delay_);
                cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, send read request, payload from bdma, end.\x0A"));
                delete bdma_rd_req_payload_;
                bdma_rd_req_payload_ = NULL;
            }
        }
        // For SDP
        if (sdp_rd_req_payload_ != NULL) {
            int payload_size = sdp_rd_req_payload_->gp.get_data_length();
            uint8_t* axi_byte_enable_ptr = sdp_rd_req_payload_->gp.get_byte_enable_ptr();
            int atom_num = 0;
            for (int i=0; i<payload_size/DMA_TRANSACTION_ATOM_SIZE; i++)
                atom_num += axi_byte_enable_ptr[i*DMA_TRANSACTION_ATOM_SIZE] == TLM_BYTE_ENABLED;
            if (credit_cvif2sdp_rd_rsp_fifo_ >= atom_num) {   // Same as sdp_ready
                credit_cvif2sdp_rd_rsp_fifo_ -= atom_num;
                cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, send read request, payload from sdp, begin, atom:%d, num_free:%d credit_cvif2sdp_rd_rsp_fifo_=%d.\x0A", atom_num, cvif2sdp_rd_rsp_fifo_->num_free(), credit_cvif2sdp_rd_rsp_fifo_));

                cvif2ext_rd_req->b_transport(sdp_rd_req_payload_->gp, axi_delay_);
                cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, send read request, payload from sdp, end.\x0A"));
                delete sdp_rd_req_payload_;
                sdp_rd_req_payload_ = NULL;
            }
        }
        // For PDP
        if (pdp_rd_req_payload_ != NULL) {
            int payload_size = pdp_rd_req_payload_->gp.get_data_length();
            uint8_t* axi_byte_enable_ptr = pdp_rd_req_payload_->gp.get_byte_enable_ptr();
            int atom_num = 0;
            for (int i=0; i<payload_size/DMA_TRANSACTION_ATOM_SIZE; i++)
                atom_num += axi_byte_enable_ptr[i*DMA_TRANSACTION_ATOM_SIZE] == TLM_BYTE_ENABLED;
            if (credit_cvif2pdp_rd_rsp_fifo_ >= atom_num) {   // Same as pdp_ready
                credit_cvif2pdp_rd_rsp_fifo_ -= atom_num;
                cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, send read request, payload from pdp, begin, atom:%d, num_free:%d credit_cvif2pdp_rd_rsp_fifo_=%d.\x0A", atom_num, cvif2pdp_rd_rsp_fifo_->num_free(), credit_cvif2pdp_rd_rsp_fifo_));

                cvif2ext_rd_req->b_transport(pdp_rd_req_payload_->gp, axi_delay_);
                cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, send read request, payload from pdp, end.\x0A"));
                delete pdp_rd_req_payload_;
                pdp_rd_req_payload_ = NULL;
            }
        }
        // For CDP
        if (cdp_rd_req_payload_ != NULL) {
            int payload_size = cdp_rd_req_payload_->gp.get_data_length();
            uint8_t* axi_byte_enable_ptr = cdp_rd_req_payload_->gp.get_byte_enable_ptr();
            int atom_num = 0;
            for (int i=0; i<payload_size/DMA_TRANSACTION_ATOM_SIZE; i++)
                atom_num += axi_byte_enable_ptr[i*DMA_TRANSACTION_ATOM_SIZE] == TLM_BYTE_ENABLED;
            if (credit_cvif2cdp_rd_rsp_fifo_ >= atom_num) {   // Same as cdp_ready
                credit_cvif2cdp_rd_rsp_fifo_ -= atom_num;
                cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, send read request, payload from cdp, begin, atom:%d, num_free:%d credit_cvif2cdp_rd_rsp_fifo_=%d.\x0A", atom_num, cvif2cdp_rd_rsp_fifo_->num_free(), credit_cvif2cdp_rd_rsp_fifo_));

                cvif2ext_rd_req->b_transport(cdp_rd_req_payload_->gp, axi_delay_);
                cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, send read request, payload from cdp, end.\x0A"));
                delete cdp_rd_req_payload_;
                cdp_rd_req_payload_ = NULL;
            }
        }
        // For RBK
        if (rbk_rd_req_payload_ != NULL) {
            int payload_size = rbk_rd_req_payload_->gp.get_data_length();
            uint8_t* axi_byte_enable_ptr = rbk_rd_req_payload_->gp.get_byte_enable_ptr();
            int atom_num = 0;
            for (int i=0; i<payload_size/DMA_TRANSACTION_ATOM_SIZE; i++)
                atom_num += axi_byte_enable_ptr[i*DMA_TRANSACTION_ATOM_SIZE] == TLM_BYTE_ENABLED;
            if (credit_cvif2rbk_rd_rsp_fifo_ >= atom_num) {   // Same as rbk_ready
                credit_cvif2rbk_rd_rsp_fifo_ -= atom_num;
                cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, send read request, payload from rbk, begin, atom:%d, num_free:%d credit_cvif2rbk_rd_rsp_fifo_=%d.\x0A", atom_num, cvif2rbk_rd_rsp_fifo_->num_free(), credit_cvif2rbk_rd_rsp_fifo_));

                cvif2ext_rd_req->b_transport(rbk_rd_req_payload_->gp, axi_delay_);
                cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, send read request, payload from rbk, end.\x0A"));
                delete rbk_rd_req_payload_;
                rbk_rd_req_payload_ = NULL;
            }
        }
        // For SDP_B
        if (sdp_b_rd_req_payload_ != NULL) {
            int payload_size = sdp_b_rd_req_payload_->gp.get_data_length();
            uint8_t* axi_byte_enable_ptr = sdp_b_rd_req_payload_->gp.get_byte_enable_ptr();
            int atom_num = 0;
            for (int i=0; i<payload_size/DMA_TRANSACTION_ATOM_SIZE; i++)
                atom_num += axi_byte_enable_ptr[i*DMA_TRANSACTION_ATOM_SIZE] == TLM_BYTE_ENABLED;
            if (credit_cvif2sdp_b_rd_rsp_fifo_ >= atom_num) {   // Same as sdp_b_ready
                credit_cvif2sdp_b_rd_rsp_fifo_ -= atom_num;
                cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, send read request, payload from sdp_b, begin, atom:%d, num_free:%d credit_cvif2sdp_b_rd_rsp_fifo_=%d.\x0A", atom_num, cvif2sdp_b_rd_rsp_fifo_->num_free(), credit_cvif2sdp_b_rd_rsp_fifo_));

                cvif2ext_rd_req->b_transport(sdp_b_rd_req_payload_->gp, axi_delay_);
                cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, send read request, payload from sdp_b, end.\x0A"));
                delete sdp_b_rd_req_payload_;
                sdp_b_rd_req_payload_ = NULL;
            }
        }
        // For SDP_N
        if (sdp_n_rd_req_payload_ != NULL) {
            int payload_size = sdp_n_rd_req_payload_->gp.get_data_length();
            uint8_t* axi_byte_enable_ptr = sdp_n_rd_req_payload_->gp.get_byte_enable_ptr();
            int atom_num = 0;
            for (int i=0; i<payload_size/DMA_TRANSACTION_ATOM_SIZE; i++)
                atom_num += axi_byte_enable_ptr[i*DMA_TRANSACTION_ATOM_SIZE] == TLM_BYTE_ENABLED;
            if (credit_cvif2sdp_n_rd_rsp_fifo_ >= atom_num) {   // Same as sdp_n_ready
                credit_cvif2sdp_n_rd_rsp_fifo_ -= atom_num;
                cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, send read request, payload from sdp_n, begin, atom:%d, num_free:%d credit_cvif2sdp_n_rd_rsp_fifo_=%d.\x0A", atom_num, cvif2sdp_n_rd_rsp_fifo_->num_free(), credit_cvif2sdp_n_rd_rsp_fifo_));

                cvif2ext_rd_req->b_transport(sdp_n_rd_req_payload_->gp, axi_delay_);
                cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, send read request, payload from sdp_n, end.\x0A"));
                delete sdp_n_rd_req_payload_;
                sdp_n_rd_req_payload_ = NULL;
            }
        }
        // For SDP_E
        if (sdp_e_rd_req_payload_ != NULL) {
            int payload_size = sdp_e_rd_req_payload_->gp.get_data_length();
            uint8_t* axi_byte_enable_ptr = sdp_e_rd_req_payload_->gp.get_byte_enable_ptr();
            int atom_num = 0;
            for (int i=0; i<payload_size/DMA_TRANSACTION_ATOM_SIZE; i++)
                atom_num += axi_byte_enable_ptr[i*DMA_TRANSACTION_ATOM_SIZE] == TLM_BYTE_ENABLED;
            if (credit_cvif2sdp_e_rd_rsp_fifo_ >= atom_num) {   // Same as sdp_e_ready
                credit_cvif2sdp_e_rd_rsp_fifo_ -= atom_num;
                cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, send read request, payload from sdp_e, begin, atom:%d, num_free:%d credit_cvif2sdp_e_rd_rsp_fifo_=%d.\x0A", atom_num, cvif2sdp_e_rd_rsp_fifo_->num_free(), credit_cvif2sdp_e_rd_rsp_fifo_));

                cvif2ext_rd_req->b_transport(sdp_e_rd_req_payload_->gp, axi_delay_);
                cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, send read request, payload from sdp_e, end.\x0A"));
                delete sdp_e_rd_req_payload_;
                sdp_e_rd_req_payload_ = NULL;
            }
        }
        // For CDMA_DAT
        if (cdma_dat_rd_req_payload_ != NULL) {
            int payload_size = cdma_dat_rd_req_payload_->gp.get_data_length();
            uint8_t* axi_byte_enable_ptr = cdma_dat_rd_req_payload_->gp.get_byte_enable_ptr();
            int atom_num = 0;
            for (int i=0; i<payload_size/DMA_TRANSACTION_ATOM_SIZE; i++)
                atom_num += axi_byte_enable_ptr[i*DMA_TRANSACTION_ATOM_SIZE] == TLM_BYTE_ENABLED;
            if (credit_cvif2cdma_dat_rd_rsp_fifo_ >= atom_num) {   // Same as cdma_dat_ready
                credit_cvif2cdma_dat_rd_rsp_fifo_ -= atom_num;
                cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, send read request, payload from cdma_dat, begin, atom:%d, num_free:%d credit_cvif2cdma_dat_rd_rsp_fifo_=%d.\x0A", atom_num, cvif2cdma_dat_rd_rsp_fifo_->num_free(), credit_cvif2cdma_dat_rd_rsp_fifo_));

                cvif2ext_rd_req->b_transport(cdma_dat_rd_req_payload_->gp, axi_delay_);
                cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, send read request, payload from cdma_dat, end.\x0A"));
                delete cdma_dat_rd_req_payload_;
                cdma_dat_rd_req_payload_ = NULL;
            }
        }
        // For CDMA_WT
        if (cdma_wt_rd_req_payload_ != NULL) {
            int payload_size = cdma_wt_rd_req_payload_->gp.get_data_length();
            uint8_t* axi_byte_enable_ptr = cdma_wt_rd_req_payload_->gp.get_byte_enable_ptr();
            int atom_num = 0;
            for (int i=0; i<payload_size/DMA_TRANSACTION_ATOM_SIZE; i++)
                atom_num += axi_byte_enable_ptr[i*DMA_TRANSACTION_ATOM_SIZE] == TLM_BYTE_ENABLED;
            if (credit_cvif2cdma_wt_rd_rsp_fifo_ >= atom_num) {   // Same as cdma_wt_ready
                credit_cvif2cdma_wt_rd_rsp_fifo_ -= atom_num;
                cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, send read request, payload from cdma_wt, begin, atom:%d, num_free:%d credit_cvif2cdma_wt_rd_rsp_fifo_=%d.\x0A", atom_num, cvif2cdma_wt_rd_rsp_fifo_->num_free(), credit_cvif2cdma_wt_rd_rsp_fifo_));

                cvif2ext_rd_req->b_transport(cdma_wt_rd_req_payload_->gp, axi_delay_);
                cslDebug((50, "NV_NVDLA_cvif::ReadRequestArbiter, send read request, payload from cdma_wt, end.\x0A"));
                delete cdma_wt_rd_req_payload_;
                cdma_wt_rd_req_payload_ = NULL;
            }
        }

        // delete payload; // Release memory
    }
}

void NV_NVDLA_cvif::WriteRequestArbiter() {
    dla_b_transport_payload *payload;
    while (true) {
        cslDebug((50, "Calling WriteRequestArbiter\x0A"));
        if((bdma_wr_req_fifo_->num_available()==0) && (rbk_wr_req_fifo_->num_available()==0) && (sdp_wr_req_fifo_->num_available()==0) && (pdp_wr_req_fifo_->num_available()==0) && (cdp_wr_req_fifo_->num_available()==0))
            wait();

        // Get a FIFO write event, query dma read request FIFOs

        // For BDMA
        if (bdma_wr_req_fifo_->nb_read(payload)) {
            cslDebug((50, "NV_NVDLA_cvif::WriteRequestArbiter, send write request, payload from bdma.\x0A"));
            cvif2ext_wr_req->b_transport(payload->gp, axi_delay_);
            delete payload;
        }
        // For SDP
        if (sdp_wr_req_fifo_->nb_read(payload)) {
            cslDebug((50, "NV_NVDLA_cvif::WriteRequestArbiter, send write request, payload from sdp.\x0A"));
            cvif2ext_wr_req->b_transport(payload->gp, axi_delay_);
            delete payload;
        }
        // For PDP
        if (pdp_wr_req_fifo_->nb_read(payload)) {
            cslDebug((50, "NV_NVDLA_cvif::WriteRequestArbiter, send write request, payload from pdp.\x0A"));
            cvif2ext_wr_req->b_transport(payload->gp, axi_delay_);
            delete payload;
        }
        // For CDP
        if (cdp_wr_req_fifo_->nb_read(payload)) {
            cslDebug((50, "NV_NVDLA_cvif::WriteRequestArbiter, send write request, payload from cdp.\x0A"));
            cvif2ext_wr_req->b_transport(payload->gp, axi_delay_);
            delete payload;
        }
        // For RBK
        if (rbk_wr_req_fifo_->nb_read(payload)) {
            cslDebug((50, "NV_NVDLA_cvif::WriteRequestArbiter, send write request, payload from rbk.\x0A"));
            cvif2ext_wr_req->b_transport(payload->gp, axi_delay_);
            delete payload;
        }

        // delete payload; // Release memory
    }
}

void NV_NVDLA_cvif::Reset() {
    // Clear register and internal states

    // For BDMA
    bdma_wr_req_count_ = 0;
    bdma_wr_rsp_count_ = 0;
    bdma_wr_req_ack_is_got_ = false;
    has_bdma_onging_wr_req_ = false;
    // Reset write response wires
    // cvif2bdma_wr_rsp.initialize(false);
    // For SDP
    sdp_wr_req_count_ = 0;
    sdp_wr_rsp_count_ = 0;
    sdp_wr_req_ack_is_got_ = false;
    has_sdp_onging_wr_req_ = false;
    // Reset write response wires
    // cvif2sdp_wr_rsp.initialize(false);
    // For PDP
    pdp_wr_req_count_ = 0;
    pdp_wr_rsp_count_ = 0;
    pdp_wr_req_ack_is_got_ = false;
    has_pdp_onging_wr_req_ = false;
    // Reset write response wires
    // cvif2pdp_wr_rsp.initialize(false);
    // For CDP
    cdp_wr_req_count_ = 0;
    cdp_wr_rsp_count_ = 0;
    cdp_wr_req_ack_is_got_ = false;
    has_cdp_onging_wr_req_ = false;
    // Reset write response wires
    // cvif2cdp_wr_rsp.initialize(false);
    // For RBK
    rbk_wr_req_count_ = 0;
    rbk_wr_rsp_count_ = 0;
    rbk_wr_req_ack_is_got_ = false;
    has_rbk_onging_wr_req_ = false;
    // Reset write response wires
    // cvif2rbk_wr_rsp.initialize(false);

    // cvif2ext_wr_req_payload = NULL;
    // cvif2ext_rd_req_payload = NULL;
}

//NV_NVDLA_cvif * NV_NVDLA_cvifCon(sc_module_name name, uint8_t nvdla_id_in)
//{
//    return new NV_NVDLA_cvif(name, nvdla_id_in);
//}
