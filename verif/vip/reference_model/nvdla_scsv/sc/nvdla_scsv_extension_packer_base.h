#ifndef NVDLA_SCSV_EXTENSION_PACKER_BASE__
#define NVDLA_SCSV_EXTENSION_PACKER_BASE__

#include "uvmc_packer.h"
using namespace uvmc;
using namespace tlm;

/*! \class nvdla_scsv_extension_packer_base
    \brief This class is a polymorphic container for user defined extension
           packer classes
*/
class nvdla_scsv_extension_packer_base{
    public:
        /// \brief Constructor. Takes the unique ID as an argument
        /// \param _id This is the user-defined unique ID associated with a user-defined
        ///             extension class packer
        nvdla_scsv_extension_packer_base(unsigned int _id){
            uniq_id = _id;
        }
        
        /// \brief Accessor method to retrieve the unique ID associated with this packer class
        /// \param none
        /// \return unique ID associated with this packer class 
        unsigned int get_unique_identifier(){
            return uniq_id;
        }

        /// \brief do_pack This function is empty here. This class is only
        ///        meant to be a container for its derived classes
        /// \param t Handle to the TLM generic payload to retrieve extensions from.
        /// \param packer Handle to UVMConnect's packer class to use to pack extensions
        /// \return bool that indicates if the extension was packed (true if packed, false otherwise)
        virtual bool do_pack (const tlm_generic_payload &t, uvmc_packer &packer){
          return false;
        }

        /// \brief do_unpack This function is empty here. This class is only
        ///        meant to be a container for its derived classes
        /// \param t Handle to the TLM generic payload to add unpacked extensions to.
        /// \param unpacker Handle to UVMConnect's packer class to use to unpack extensions
        virtual void do_unpack (tlm_generic_payload &t, uvmc_packer &unpacker){
        }
    protected:
        /// Unique identifier that shall be used to identify the extension in a stream of bytes
        unsigned int uniq_id;
};

#endif // nvdla_scsv_extension_packer__
