#include "tlm.h"
#include "scsim_common.h"
#include "nvdla_dbb_extension.h"
#include "nvdla_scsv_extension_packer.h"
#include "nvdla_dbb_scsv_extension_packer.h"

namespace nvdla {

using namespace::tlm;
using namespace::scsim::clib;

nvdla_dbb_scsv_extension_packer::nvdla_dbb_scsv_extension_packer(unsigned int _id):nvdla_scsv_extension_packer<nvdla_dbb_extension>(_id){
    cout << "nvdla_dbb_scsv_extension_packer::Constructed nvdla_dbb_scsv_extension_packer" <<endl;
}

void nvdla_dbb_scsv_extension_packer::pack (nvdla_dbb_extension *extn_to_pack, uvmc_packer &packer){
    packer << extn_to_pack->get_id();
    packer << extn_to_pack->get_sz();
    packer << extn_to_pack->get_length();
}

void nvdla_dbb_scsv_extension_packer::unpack (nvdla_dbb_extension *extn_to_unpack, uvmc_packer &unpacker){
    uint32_t m_id;
    uint32_t m_size;
    uint32_t m_len;
    
    unpacker >> m_id;
    unpacker >> m_size;
    unpacker >> m_len;

    extn_to_unpack->set_id(m_id); 
    extn_to_unpack->set_size(m_size);
    extn_to_unpack->set_length(m_len); 
}

}
