#ifndef NVDLA_SCSV_CONVERTER_
#define NVDLA_SCSV_CONVERTER_

#include <iostream>
#include <map>

// tlm.h has -Wmaybe-unitizialed warnings if compiled with -Wall -Werror.
// We can't fix SystemC, ignore these warnings with diagnostic pragmas.
// Found with SystemC 2.3.0.
// Only applicable to GCC.
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wmaybe-uninitialized"
#include <tlm.h>
#pragma GCC diagnostic pop

#include "uvmc.h"
#include "nvdla_scsv_extension_packer_base.h"

using namespace std;
using namespace uvmc;
using namespace tlm;

/*! \class nvdla_scsv_converter
    \brief This is the SystemC side class of the custom converter for TLM-GP+Extensions

    This class is the SystemC side class of the custom converter for transactions
    that consist of a TLM generic payload, which has an arbitray number of TLM extensions attached.
    It leverages the default UVMConnect converter routines to handle packing the TLM GP,
    and requires the use of UVMConnect's packer in diferent custom packer classes to pack fields 
    of the different TLM Extensions. (one user-defined packer class per user-defined extension type)
    Those packer classes are 'registered' with this converter class, that invokes them
    appropriately in its routines (see do_(un)pack_extensions  
*/

class nvdla_scsv_converter: public uvmc_converter<tlm_generic_payload>{
    public:
        /// \brief  The do_pack routine will be called by UVMConnect to handle packing
        ///         the entire TLM payload (including extensions)
        ///  \param t This is a reference to the TLM generic payload that we need to pack
        ///         using the packer handle passed.
        ///  \param packer This is a reference to UVMConnect's packer class, which will be
        ///         passed on to routines that will use this to pack the TLM extensions & the GP.
        ///  \return void
        static void do_pack( const tlm_generic_payload &t, uvmc_packer &packer );

        /// \brief  The do_unpack routine will be called by UVMConnect to handle unpacking
        ///         the entire TLM payload (including extensions)
        /// \param t This is a reference to the TLM generic payload that we need to populate
        ///         with the data from the bitstream that the unpacker class contains.
        /// \param unpacker This is a reference to UVMConnect's packer object, which will be
        ///         passed on to routines that will use this to unpack the TLM extensions & the GP.
        /// \return void
        static void do_unpack( tlm_generic_payload &t, uvmc_packer &unpacker );

        /// \brief register_extension_packer is a function template that implements the
        ///        registration of user-defined packer classes for various 
        ///        user-defined extension types 
        /// \param id This is a unique ID that identifies the user-defined packer class 
        //            and indirectly, the extension type it deals with. Users should set this
        //            to the same value while registering the SC and SV side extension packer
        //            classes
        /// \return void
        template <typename packer>
        static void register_extension_packer (unsigned int id);

        /// \brief get_num_extensions will query the payload for non-null
        ///         extensions and return the total count.
        /// \param t This is a reference to the TLM generic payload in which
        ///          we will find the number of non-null extensions
        /// \return Number of non-null extensions
        static unsigned int get_num_extensions(const tlm_generic_payload &t);
    private:

        /// \brief do_pack_extensions iterates over the STL map of registered extension
        ///         packer classes and calls each of their do_pack functions
        /// \param  t This is a reference to the TLM generic payload that contains the
        ///           extensions to be packed
        /// \param packer This is a reference to UVMConnect's packer object, which will be
        ///         passed on to routines that will use this to pack the TLM extensions & the GP.
        static void do_pack_extensions(const tlm_generic_payload &t, uvmc_packer &packer);

        /// \brief do_unpack_extensions iterates over the STL map of registered extension
        ///         packer classes and calls each of their do_unpack functions
        /// \param  t This is a reference to the TLM generic payload that needs to be populated
        ///           with unpacked extensions from the unpacker's bitstream.
        /// \param unpacker This is a reference to UVMConnect's packer object, which will be
        ///         passed on to routines that will use this to unpack the TLM extensions & the GP.
        static void do_unpack_extensions(tlm_generic_payload &t, uvmc_packer &unpacker);

        /// static map that contains handles to the user-defined extension packer objects
        typedef map <unsigned int, nvdla_scsv_extension_packer_base*> nvdla_scsv_extension_packer_map;
        static nvdla_scsv_extension_packer_map extension_packer_map;
};


template <typename packer>
void nvdla_scsv_converter::register_extension_packer (unsigned int id){
    printf("nvdla_scsv_converter::Registering packer ID: 0x%x\n", id);
    
    // Check if the ID already exists
    if (nvdla_scsv_converter::extension_packer_map.count(id) == 0) {
        // Add a new ID<->Class handle key,value pair to the map.
        nvdla_scsv_converter::extension_packer_map[id] = new packer(id);

        // Check if packer is already associated with an ID
        unsigned int unique_packer_count = 0;
        for(nvdla_scsv_extension_packer_map::iterator iter = extension_packer_map.begin();
            iter != extension_packer_map.end();
            ++iter){
            if(iter->second == extension_packer_map[id]){
                unique_packer_count++;
            }
        }

        if(unique_packer_count > 1){
            char dup_reg_err_msg[100];
            sprintf(dup_reg_err_msg, "This packer is already associated with ID: 0x%x.\n",id);
            SC_REPORT_FATAL("DUPLICATE_PACKER",dup_reg_err_msg);
        }
    } else {
        char dup_reg_err_msg[100];
        sprintf(dup_reg_err_msg, "ID:%x already exists. Duplicate extension IDs not allowed.\n",id);
        // If it does, error out. These IDs must be unique between packer classes
        SC_REPORT_FATAL("DUPLICATE_EXTN_ID",dup_reg_err_msg);
    }

        
}
#endif // NVDLA_SCSV_CONVERTER_
