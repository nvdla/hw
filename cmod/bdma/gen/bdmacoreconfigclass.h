// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: bdmacoreconfigclass.h

#ifndef _BDMACORECONFIGCLASS_H_
#define _BDMACORECONFIGCLASS_H_

#include <iomanip>
#include <systemc.h>

#include "scsim_common.h"

using namespace std;
SCSIM_NAMESPACE_START(cmod)

// Configuration class, just a wrapper, all variables shall be in public, there shall be no member function
class BdmaCoreConfig {
public:
        uint32_t  cfg_src_addr_low_v32_;
        uint32_t  cfg_src_addr_high_v8_;
        uint32_t  cfg_dst_addr_low_v32_;
        uint32_t  cfg_dst_addr_high_v8_;
        uint16_t  cfg_line_size_;
        uint8_t   cfg_cmd_src_ram_type_;
        uint8_t   cfg_cmd_dst_ram_type_;
        uint32_t  cfg_line_repeat_number_;
        uint32_t  cfg_src_line_stride_;
        uint32_t  cfg_dst_line_stride_;
        uint32_t  cfg_surf_repeat_number_;
        uint32_t  cfg_src_surf_stride_;
        uint32_t  cfg_dst_surf_stride_;
        uint8_t   cfg_op_en_;
        uint8_t   cfg_launch0_grp0_launch_;
        uint8_t   cfg_launch1_grp1_launch_;
        uint8_t   cfg_status_stall_count_en_;
        uint8_t   status_free_slot_;
        uint8_t   status_idle_;
        uint8_t   status_grp0_busy_;
        uint8_t   status_grp1_busy_;
        uint32_t  status_grp0_read_stall_count_;
        uint32_t  status_grp0_write_stall_count_;
        uint32_t  status_grp1_read_stall_count_;
        uint32_t  status_grp1_write_stall_count_;

};

class BdmaCoreInt {
public:
    bool    int_enable;
    uint8_t int_ptr;    // 0: ptr0, 1: ptr1
    uint16_t op_count;
};

// Operator for being a SC_FIFO payload
inline std::ostream& operator<<(std::ostream& out, const BdmaCoreConfig & obj) {
    return out << "Just to fool compiler" << endl;
}

// Operator for being a SC_FIFO payload
inline std::ostream& operator<<(std::ostream& out, const BdmaCoreInt & obj) {
    return out << "Just to fool compiler" << endl;
}

SCSIM_NAMESPACE_END()

#endif
