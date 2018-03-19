`ifndef NVDLA_SCSV_REGISTER_EXTENSION_PACKER_DEFINES_SVH
`define NVDLA_SCSV_REGISTER_EXTENSION_PACKER_DEFINES_SVH

// Description:
//   Use these ID defines when calling
//   nvdla_scsv_register_extension_packer::register_extension(DEFINE_GOES_HERE);
//   These defines match those declared on the SystemC side so that 
//   the correct packer/unpacker gets called
// --------------------------------------------------------------------------

typedef enum {
    NVDLA_DBB_SCSV_EXTENSION_PACKER_ID = 32'h11223344
} NVDLA_SCSV_EXTENSION_PACKER_ENUM;

`endif 
