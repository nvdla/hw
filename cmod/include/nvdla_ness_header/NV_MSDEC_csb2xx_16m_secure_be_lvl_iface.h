// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_MSDEC_csb2xx_16m_secure_be_lvl_iface.h

#if !defined(_NV_MSDEC_csb2xx_16m_secure_be_lvl_iface_H_)
#define _NV_MSDEC_csb2xx_16m_secure_be_lvl_iface_H_

#include <stdint.h>
#ifndef _csb2xx_16m_secure_be_lvl_struct_H_
#define _csb2xx_16m_secure_be_lvl_struct_H_

typedef struct csb2xx_16m_secure_be_lvl_s {
    uint32_t addr ; 
    uint32_t wdat ; 
    uint8_t write ; 
    uint8_t nposted ; 
    uint8_t srcpriv ; 
    uint8_t wrbe ; 
    uint8_t secure ; 
    uint8_t level ; 
} csb2xx_16m_secure_be_lvl_t;

#endif

union NV_MSDEC_csb2xx_16m_secure_be_lvl_u {
    csb2xx_16m_secure_be_lvl_t csb2xx_16m_secure_be_lvl;
};
typedef struct NV_MSDEC_csb2xx_16m_secure_be_lvl_s {
    union NV_MSDEC_csb2xx_16m_secure_be_lvl_u pd ; 
} NV_MSDEC_csb2xx_16m_secure_be_lvl_t;

#endif // !defined(_NV_MSDEC_csb2xx_16m_secure_be_lvl_iface_H_)
