// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cbuf.cpp

#include <algorithm>
#include <iomanip>
#include "NV_NVDLA_cbuf.h"
#include "log.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

USING_SCSIM_NAMESPACE(cmod)
USING_SCSIM_NAMESPACE(clib)
using namespace std;
using namespace tlm;
using namespace sc_core;

NV_NVDLA_cbuf::NV_NVDLA_cbuf( sc_module_name module_name ):
    NV_NVDLA_cbuf_base(module_name),
    // Delay setup
    dma_delay_(SC_ZERO_TIME),
    // csb_delay_(SC_ZERO_TIME),
    b_transport_delay_(SC_ZERO_TIME)
{
    // Memory allocation
    cbuf_ram_ = new uint8_t [CBUF_BANK_NUM * CBUF_ENTRY_PER_BANK * CBUF_ENTRY_CMOD_GRAN_PER_ENTRY];

    // Reset
    // Reset();

    // SC_THREAD
    // SC_THREAD()
}

NV_NVDLA_cbuf::~NV_NVDLA_cbuf() {
    if( cbuf_ram_ )      delete [] cbuf_ram_;
}

void NV_NVDLA_cbuf::Reset()
{
    // Clear register and internal states
}

void NV_NVDLA_cbuf::cdma2buf_dat_wr_b_transport(int ID, nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t* payload, sc_time& delay){
    uint8_t *payload_data_ptr;
    uint32_t idx;
    uint32_t cbuf_ram_byte_addr;
    payload_data_ptr = reinterpret_cast <uint8_t *> (payload->data);
    cbuf_ram_byte_addr = (payload->addr * 2 + payload->hsel) * CBUF_HALF_ENTRY_SIZE;
    if (payload->addr >= (CBUF_BANK_NUM - 1) * CBUF_ENTRY_PER_BANK ) {
        FAIL(("NV_NVDLA_cbuf::sc2buf_dat_wr_b_transport, data address shall not access the last bank."));
    }
    cslDebug((50, "NV_NVDLA_cbuf::cdma2buf_dat_wr_b_transport, payload->addr=0x%x\n", uint32_t (payload->addr)));
    cslDebug((50, "NV_NVDLA_cbuf::cdma2buf_dat_wr_b_transport, payload->hsel=%d\n", uint32_t (payload->hsel)));
    cslDebug((50, "NV_NVDLA_cbuf::cdma2buf_dat_wr_b_transport, cbuf_ram_byte_addr is 0x%x\n", cbuf_ram_byte_addr));
    cslDebug((70, "NV_NVDLA_cbuf::cdma2buf_dat_wr_b_transport, payload->data:\n"));
    for (idx = 0; idx < CBUF_HALF_ENTRY_SIZE; idx ++) {
        cslDebug((70, "    0x%02x\n", uint32_t (payload_data_ptr[idx])));
    } 
    memcpy(&cbuf_ram_[cbuf_ram_byte_addr], payload_data_ptr, CBUF_HALF_ENTRY_SIZE);
}

void NV_NVDLA_cbuf::cdma2buf_wt_wr_b_transport(int ID, nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t* payload, sc_time& delay){
    uint8_t *payload_data_ptr;
    uint32_t idx;
    uint32_t cbuf_ram_byte_addr;
    payload_data_ptr = reinterpret_cast <uint8_t *> (payload->data);
    cbuf_ram_byte_addr = (payload->addr * 2 + payload->hsel) * CBUF_HALF_ENTRY_SIZE;
    if (payload->addr < CBUF_ENTRY_PER_BANK ) {
        FAIL(("NV_NVDLA_cbuf::sc2buf_wt_wr_b_transport, weight address shall not access the first bank."));
    }
    else if (payload->addr >= CBUF_BANK_NUM * CBUF_ENTRY_PER_BANK) {
        FAIL(("NV_NVDLA_cbuf::sc2buf_wt_wr_b_transport, weight address is larger than the number of entries of cbuf"));
    }
    cslDebug((50, "NV_NVDLA_cbuf::cdma2buf_wt_wr_b_transport, payload->addr=0x%x\n", uint32_t (payload->addr)));
    cslDebug((50, "NV_NVDLA_cbuf::cdma2buf_wt_wr_b_transport, payload->hsel=%d\n", uint32_t (payload->hsel)));
    cslDebug((50, "NV_NVDLA_cbuf::cdma2buf_wt_wr_b_transport, cbuf_ram_byte_addr is 0x%x\n", cbuf_ram_byte_addr));
    cslDebug((70, "NV_NVDLA_cbuf::cdma2buf_wt_wr_b_transport, payload->data:\n"));
    for (idx = 0; idx < CBUF_HALF_ENTRY_SIZE; idx ++) {
        cslDebug((70, "    0x%02x\n", uint32_t (payload_data_ptr[idx])));
    } 
    memcpy(&cbuf_ram_[cbuf_ram_byte_addr], payload_data_ptr, CBUF_HALF_ENTRY_SIZE);
}

void NV_NVDLA_cbuf::sc2buf_dat_rd_b_transport(int ID, nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t* payload, sc_time& delay){
    uint8_t *payload_data_ptr;
    uint32_t payload_addr;
    uint32_t idx;
    uint32_t cbuf_ram_byte_addr;
    payload_addr = payload->nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr;
    cbuf_ram_byte_addr = payload_addr * CBUF_ENTRY_SIZE;
    if (payload_addr >= (CBUF_BANK_NUM - 1) * CBUF_ENTRY_PER_BANK ) {
        FAIL(("NV_NVDLA_cbuf::sc2buf_dat_rd_b_transport, data address shall not access the last bank."));
    }
    cslDebug((50, "NV_NVDLA_cbuf::sc2buf_dat_rd_b_transport, payload_addr=0x%x\n", uint32_t (payload_addr)));
    cslDebug((50, "NV_NVDLA_cbuf::sc2buf_dat_rd_b_transport, cbuf_ram_byte_addr is 0x%x\n", cbuf_ram_byte_addr));
    payload_data_ptr = reinterpret_cast <uint8_t *> (payload->nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1.data);
    memcpy(payload_data_ptr, &cbuf_ram_[cbuf_ram_byte_addr], CBUF_ENTRY_SIZE);
    cslDebug((70, "NV_NVDLA_cbuf::sc2buf_dat_rd_b_transport, cbuf_ram_ data is\n"));
    for (idx = 0; idx < CBUF_ENTRY_SIZE; idx ++) {
        cslDebug((70, "    0x%02x\n", uint32_t (cbuf_ram_[cbuf_ram_byte_addr + idx])));
    }
}

void NV_NVDLA_cbuf::sc2buf_wt_rd_b_transport(int ID, nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t* payload, sc_time& delay){
    uint8_t *payload_data_ptr;
    uint32_t payload_addr;
    uint32_t idx;
    uint32_t cbuf_ram_byte_addr;
    payload_addr = payload->nvdla_ram_addr_ADDR_WIDTH_12_BE_1.addr;
    cbuf_ram_byte_addr = payload_addr * CBUF_ENTRY_SIZE;
    if (payload_addr < CBUF_ENTRY_PER_BANK ) {
        FAIL(("NV_NVDLA_cbuf::sc2buf_wt_rd_b_transport, weight address shall not access the first bank."));
    }
    else if (payload_addr >= CBUF_BANK_NUM * CBUF_ENTRY_PER_BANK) {
        FAIL(("NV_NVDLA_cbuf::sc2buf_wt_rd_b_transport, weight address is larger than the number of entries of cbuf"));
    }
    cslDebug((50, "NV_NVDLA_cbuf::sc2buf_wt_rd_b_transport, payload_addr=0x%x\n", uint32_t (payload_addr)));
    cslDebug((50, "NV_NVDLA_cbuf::sc2buf_wt_rd_b_transport, cbuf_ram_byte_addr is 0x%x\n", cbuf_ram_byte_addr));
    payload_data_ptr = reinterpret_cast <uint8_t *> (payload->nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1.data);
    memcpy(payload_data_ptr, &cbuf_ram_[cbuf_ram_byte_addr], CBUF_ENTRY_SIZE);
    cslDebug((70, "NV_NVDLA_cbuf::sc2buf_wt_rd_b_transport, cbuf_ram_ data is\n"));
    for (idx = 0; idx < CBUF_ENTRY_SIZE; idx ++) {
        cslDebug((70, "    0x%02x\n", uint32_t (cbuf_ram_[cbuf_ram_byte_addr + idx])));
    }
}

#pragma CTC SKIP
// NV_NVDLA_cbuf::sc2buf_wmb_rd_b_transport is never used
void NV_NVDLA_cbuf::sc2buf_wmb_rd_b_transport(int ID, nvdla_ram_rd_valid_port_RADDR_8_RDATA_1024_t* payload, sc_time& delay){
    uint8_t *payload_data_ptr;
    uint32_t payload_addr;
    uint32_t idx;
    uint32_t cbuf_ram_byte_addr;
    payload_addr = payload->nvdla_ram_addr_ADDR_WIDTH_8_BE_1.addr + 0xF00; // WMB address has been remove the MSB
    cbuf_ram_byte_addr = payload_addr * CBUF_ENTRY_SIZE;
    if ((payload_addr < (CBUF_BANK_NUM - 1) * CBUF_ENTRY_PER_BANK) || (payload_addr >= CBUF_BANK_NUM * CBUF_ENTRY_PER_BANK)) {
        FAIL(("NV_NVDLA_cbuf::sc2buf_wmb_rd_b_transport, wmb address should access the last bank."));
    }
    cslDebug((50, "NV_NVDLA_cbuf::sc2buf_wmb_rd_b_transport, payload_addr=0x%x\n", uint32_t (payload_addr)));
    cslDebug((50, "NV_NVDLA_cbuf::sc2buf_wmb_rd_b_transport, cbuf_ram_byte_addr is 0x%x\n", cbuf_ram_byte_addr));
    payload_data_ptr = reinterpret_cast <uint8_t *> (payload->nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1.data);
    memcpy(payload_data_ptr, &cbuf_ram_[cbuf_ram_byte_addr], CBUF_ENTRY_SIZE);
    cslDebug((70, "NV_NVDLA_cbuf::sc2buf_wmb_rd_b_transport, cbuf_ram_ data is\n"));
    for (idx = 0; idx < CBUF_ENTRY_SIZE; idx ++) {
        cslDebug((70, "    0x%02x\n", uint32_t (cbuf_ram_[cbuf_ram_byte_addr + idx])));
    }
}

NV_NVDLA_cbuf * NV_NVDLA_cbufCon(sc_module_name name)
{
    return new NV_NVDLA_cbuf(name);
}
#pragma CTC ENDSKIP
