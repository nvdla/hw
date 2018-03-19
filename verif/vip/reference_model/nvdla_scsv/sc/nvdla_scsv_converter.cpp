#include "nvdla_scsv_converter.h"

// Declare the static map
// which will hold the registered extension packer classes
nvdla_scsv_converter::nvdla_scsv_extension_packer_map nvdla_scsv_converter::extension_packer_map;

void nvdla_scsv_converter::do_pack( const tlm_generic_payload &t, uvmc_packer &packer){
    // Call uvmc_converter's do_pack to handle packing the actual GP
    uvmc_converter<tlm_generic_payload>::do_pack(t,packer);
    // Call the extension packer to pack the extensions
    do_pack_extensions(t, packer);
}

void nvdla_scsv_converter::do_unpack( tlm_generic_payload &t, uvmc_packer &unpacker){
    // Call uvmc_converter's do_unpack to handle unpacking the actual GP
    uvmc_converter<tlm_generic_payload>::do_unpack(t,unpacker);
    // Call the extension packer to unpack the extensions
    do_unpack_extensions(t,unpacker);
}

void nvdla_scsv_converter::do_pack_extensions( const tlm_generic_payload &t, uvmc_packer &packer){
    unsigned int num_extns_packed = 0;
    bool packed_extension;
    nvdla_scsv_extension_packer_map::iterator ext_iter;

    // Iterate over the registered extension packer classes, and 
    // call do_pack on each of them
    for(ext_iter = extension_packer_map.begin() ; ext_iter != extension_packer_map.end() ; ext_iter++){
        packed_extension =  ext_iter->second->do_pack(t,packer);
        if (packed_extension) {
           num_extns_packed++; 
        }
    }
    // Check if we packed all the attached extensions
    // If num_extns_packed != get_num_extensions, then we have some unsupported extensions.
    // if(num_extns_packed != get_num_extensions(t)){
    //     SC_REPORT_WARNING("DO_PACK_EXTENSIONS/UNSUPPORTED_EXTN","Unsupported extension(s) found! Please add packers for all extension types present.");
    // }
}

void nvdla_scsv_converter::do_unpack_extensions(tlm_generic_payload &t, uvmc_packer &unpacker){
    unsigned int unique_identifier;
    nvdla_scsv_extension_packer_map::iterator ext_iter;
    for (nvdla_scsv_extension_packer_map::size_type i=0; i< extension_packer_map.size(); i++){
        // Unpack the unique identifier first
        unpacker >> unique_identifier;
        // Look through our extension_map to see if we have a converter
        // for that id.
        ext_iter = extension_packer_map.find(unique_identifier);
        if ( ext_iter == extension_packer_map.end()){
            continue;
        } else {
            // Found a packer class registered for this identifier
            // So, call do_unpack on that class to unpack the extension type it supports
            ext_iter->second->do_unpack(t,unpacker);
        }
    }
}

unsigned int nvdla_scsv_converter::get_num_extensions(const tlm_generic_payload &t){
    tlm_extension_base* base_ptr;
    unsigned int num_extensions = 0;
    unsigned int max_num_extns = max_num_extensions(false);
    for (unsigned int i=0; i < max_num_extns; i++){
        base_ptr = t.get_extension(i);
        if(base_ptr){
            num_extensions++;
        }
    }
    return num_extensions;
}

