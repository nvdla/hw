// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cbuf.h

#ifndef _NV_NVDLA_CBUF_H_
#define _NV_NVDLA_CBUF_H_
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include <systemc.h>
#include <tlm.h>
#include "tlm_utils/multi_passthrough_initiator_socket.h"
#include "tlm_utils/multi_passthrough_target_socket.h" 
#include "scsim_common.h"
// #include "nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1_iface.h"
#include "NV_NVDLA_cbuf_base.h"
#include "nvdla_config.h"

#define ELEMENT_SIZE_INT8           1
#define ELEMENT_SIZE_INT16          2
#define ELEMENT_SIZE_FP16           2

#define ATOM_SIZE_INT8              (NVDLA_MEMORY_ATOMIC_SIZE*ELEMENT_SIZE_INT8)
#define ATOM_SIZE_INT16             (NVDLA_MEMORY_ATOMIC_SIZE*ELEMENT_SIZE_INT16)
#define ATOM_SIZE_FP16              (NVDLA_MEMORY_ATOMIC_SIZE*ELEMENT_SIZE_FP16)

#define CBUF_ENTRY_NUM                      (NVDLA_CBUF_BANK_NUMBER*NVDLA_CBUF_BANK_DEPTH)
#define CBUF_ENTRY_CMOD_GRANULARITY_SIZE    1
#define CBUF_ENTRY_CMOD_GRAN_PER_ENTRY      (NVDLA_CBUF_BANK_WIDTH/CBUF_ENTRY_CMOD_GRANULARITY_SIZE)

#define DEBUG_DUMP

SCSIM_NAMESPACE_START(clib)
// clib class forward declaration
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)
class NV_NVDLA_cbuf:
    public  NV_NVDLA_cbuf_base  // ports
{
    public:
        SC_HAS_PROCESS(NV_NVDLA_cbuf);
        NV_NVDLA_cbuf( sc_module_name module_name );
        ~NV_NVDLA_cbuf();
        // Overload for pure virtual TLM target functions
        // # CDMA 2 CBUF: data and weight
        void cdma2buf_dat_wr_b_transport(int ID, nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t* payload, sc_time& delay);
        void cdma2buf_wt_wr_b_transport(int ID, nvdla_ram_wr_port_WADDR_12_WDATA_512_BE_1_t* payload, sc_time& delay);
        // # CSC 2 CBUF: activation, weight and WMB
        void sc2buf_dat_rd_b_transport(int ID, nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t* payload, sc_time& delay);
        void sc2buf_wt_rd_b_transport(int ID, nvdla_ram_rd_valid_port_RADDR_12_RDATA_1024_t* payload, sc_time& delay);
        void sc2buf_wmb_rd_b_transport(int ID, nvdla_ram_rd_valid_port_RADDR_8_RDATA_1024_t* payload, sc_time& delay);

    private:
        // Variables
        // Convolution buffer
        // Buffer composed by sc_uint<64>
        // sc_uint<64>     *cbuf_ram_;
        // Buffer composed by uint8_t
        uint8_t *cbuf_ram_;
        // Delay
        sc_core::sc_time dma_delay_;
        // sc_core::sc_time csb_delay_;
        sc_core::sc_time b_transport_delay_;

        // Events

        // FIFOs

        // Function declaration
        void Reset();
#ifdef DEBUG_DUMP
        FILE        *fp_cdma2cbuf_data;
        FILE        *fp_cdma2cbuf_weight;
#endif
};

SCSIM_NAMESPACE_END()

extern "C" scsim::cmod::NV_NVDLA_cbuf * NV_NVDLA_cbufCon(sc_module_name module_name);

#endif

