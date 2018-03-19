#ifndef NVDLA_DBB_SCSV_EXTENSION_PACKER_
#define NVDLA_DBB_SCSV_EXTENSION_PACKER_

#include "nvdla_scsv_extension_packer.h"

namespace nvdla {

class nvdla_dbb_scsv_extension_packer: public nvdla_scsv_extension_packer<scsim::clib::nvdla_dbb_extension>{

    public:
        nvdla_dbb_scsv_extension_packer(unsigned int _id);
        virtual void pack (scsim::clib::nvdla_dbb_extension *extn_to_pack, uvmc_packer &packer);
        virtual void unpack (scsim::clib::nvdla_dbb_extension *extn_to_unpack, uvmc_packer &unpacker);
};

}
#endif
