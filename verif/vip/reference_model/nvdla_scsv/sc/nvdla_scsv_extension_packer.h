#ifndef __NVDLA_SCSV_EXTENSION_PACKER
#define __NVDLA_SCSV_EXTENSION_PACKER

#include "uvmc_packer.h"
using namespace uvmc;
using namespace tlm;

#include "nvdla_scsv_extension_packer_base.h"
#include "nvdla_scsv_converter.h"

/*! \class nvdla_scsv_extension_packer
    \brief This is a templated base class from which user defined extension 
           packer classes should extend. This class is templated by TLM extension type.

    To add support for a new extension type, users should extend this class, 
    pass the extension type as a template parameter and implement the private
    methods pack(..)/unpack(..) to handle packing the fields of the TLM extension
*/
template <typename extn_type>
class nvdla_scsv_extension_packer: public nvdla_scsv_extension_packer_base {

    public:
        /// \brief Constructor. This takes the unique ID as an arguent
        /// \param _id This is the user-defined unique ID associated 
        ///            with a user-defined extension class packer, 
        ///            that will be passed to the base class constructor
        nvdla_scsv_extension_packer(unsigned int _id);

        /// \brief do_pack attempts a t.get_extension(..) for an \c extn_type. If a
        ///        non-null handle is returned, packing is attempted for that type.
        ///        The unique ID is packed first, following which the pack(..) 
        ///        routine is called to pack the fields of the TLM extension itself.
        /// \param t Handle to the TLM generic payload that contains extensions to pack
        /// \param packer Handle to UVMConnect's packer class to use to pack extensions
        /// \return bool that indicates if the extension was packed (true if packed, false otherwise)
        bool do_pack (const tlm_generic_payload &t, uvmc_packer &packer);

        /// \brief do_unpack creates a new extension of type \c extn_type and
        ///        unconditionally calls the user implemented unpack(..) routine
        ///        This function does not check for the presence of the right unique ID.
        ///        The expectation is that is done before this function is called.
        /// \param t Handle to the TLM generic payload to add unpacked extensions to.
        /// \param unpacker Handle to UVMConnect's packer class to use to unpack extensions
        /// \return void
        void do_unpack (tlm_generic_payload &t, uvmc_packer &unpacker);

        /// \brief Helper function to check if a particular extension type exists
        ///        in the TLM generic payload object passed.
        /// \param t Reference to TLM generic payload object in which to check for 
        ///        the presence of the extension type in.
        /// \return bool that indicates if the extension type exists 
        ///         in the payload (true if exists, false otherwise)
        bool is_extension_set (const tlm_generic_payload &t);

        /// \brief  Function to construct an object of extn_type
        /// \return returns a pointer to the object of extn_type created.
        ///         This function calls the default constructor of the extension type
        ///         Users should overload this in the extended class incase a non-default
        ///         constructor should be called instead.
        virtual extn_type* create_extension();
        
    private:
        /// \brief pack(..) should implement the exact field-by-field packing for this
        ///        extension type in the extended class(es). 
        ///        This is a pure virtual function in this class.
        /// \param extn_to_pack Pointer to the extension object, whose fields need
        ///        to be packed.
        /// \param packer Handle to UVMConnect's packer class from which to invoke packing routines from
        /// \return void
        virtual void pack (extn_type *extn_to_pack, uvmc_packer &packer) = 0;

        /// \brief unpack(..) should implement the exact field-by-field unpacking for this
        ///        extension type in the extended class(es). 
        ///        This is a pure virtual function in this class.
        /// \param extn_to_unpack Pointer to the extension object, whose fields need
        ///        to be populated with fields unpacked from the packer's bistream.
        /// \param packer Handle to UVMConnect's packer class from which to invoke unpacking routines from
        /// \return void
        virtual void unpack (extn_type *extn_to_unpack, uvmc_packer &unpacker) = 0;

        /// Pointer to an object of this extension type
        extn_type* extn_handle;
};

template <typename extn_type>
nvdla_scsv_extension_packer<extn_type>::nvdla_scsv_extension_packer(unsigned int _id):
    nvdla_scsv_extension_packer_base(_id){
        extn_handle = NULL;
}

template <typename extn_type>
bool nvdla_scsv_extension_packer<extn_type>::is_extension_set(const tlm_generic_payload &t){
    extn_type *extn_to_check;
    bool retval = false;
    t.get_extension(extn_to_check);
    if (extn_to_check) {
        retval = true;
    } else {
        retval = false;
    }
    return retval;
}

template <typename extn_type>
extn_type* nvdla_scsv_extension_packer<extn_type>::create_extension(){
    extn_handle = new extn_type();
    return extn_handle;

}

template <typename extn_type>
void nvdla_scsv_extension_packer<extn_type>::do_unpack (tlm_generic_payload &t, uvmc_packer &unpacker){
    extn_type *extn_to_unpack = nvdla_scsv_extension_packer<extn_type>::create_extension();
    unpack(extn_to_unpack, unpacker); // Call the user implemented unpack
    t.set_extension(extn_to_unpack);
}

template <typename extn_type>
bool nvdla_scsv_extension_packer<extn_type>::do_pack (const tlm_generic_payload &t, uvmc_packer &packer){
    bool retval = false;
    extn_type *extn_to_pack;
    t.get_extension(extn_to_pack);
    if(extn_to_pack){ // Check if that extension exists
        // Pack in the unique identifier first
        packer << get_unique_identifier();
        // Call the user implemented pack to pack the extension
        pack(extn_to_pack, packer);
        retval = true;
    } else {
        retval = false;
    }
    return retval;
}

#endif
