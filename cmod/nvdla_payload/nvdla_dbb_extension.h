// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_dbb_extension.h

#ifndef _NVDLA_DBB_EXTENSION_H_
#define _NVDLA_DBB_EXTENSION_H_

SCSIM_NAMESPACE_START(clib)

class nvdla_dbb_extension: public tlm::tlm_extension<nvdla_dbb_extension> {
private:
    uint32_t m_id;
    uint32_t m_size;
    uint32_t m_len;
public:
    nvdla_dbb_extension()
        : m_id(0)
        , m_size(8)
        , m_len(4)
        {}
    void set_id(uint32_t id) { m_id = id; }
    void set_size(uint32_t sz) { m_size = sz; }
    void set_length(uint32_t len) { m_len = len; }

    const uint32_t get_id() { return m_id; }
    const uint32_t get_sz() { return m_size; }
    const uint32_t get_length() { return m_len; }

    /* clone() virtual function*/
    tlm::tlm_extension_base *clone() const {
        return (new nvdla_dbb_extension(* this));
    }

    /*copy_from() virtual function*/
    void copy_from(tlm::tlm_extension_base const &ext) {
        sc_assert(m_id == static_cast<nvdla_dbb_extension const &>(ext).m_id);
        sc_assert(m_size == static_cast<nvdla_dbb_extension const &>(ext).m_size);
        sc_assert(m_len == static_cast<nvdla_dbb_extension const &>(ext).m_len);
        operator =(static_cast<nvdla_dbb_extension const &>(ext));
    }


};
SCSIM_NAMESPACE_END()
#endif
