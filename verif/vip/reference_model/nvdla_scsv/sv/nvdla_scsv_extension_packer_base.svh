// File: nvdla_scsv_extension_packer_base.svh
// 
// Component: SystemVerilog side of the SC/SV converter
//
// Package:  SystemC-SystemVerilog Mixed Language Connectors based on
//           UVMConnect 2.3.1 
//
// Description:
//   This file contains a parametrized base class which is meant to act as 
//   a polymorphic container for the user defined extension packer classes.
//
//
// class: nvdla_scsv_extension_packer_base
//   This class is a polymorphic container for user defined extension
//   packer classes

class nvdla_scsv_extension_packer_base;

    /// Unique identifier that shall be used to identify the extension in a stream of bytes
    protected int unsigned uniq_id;

    /// \brief Constructor. Takes the unique ID as an argument
    /// \param _id This is the user-defined unique ID associated with a user-defined
    ///            extension class packer
    function new(int unsigned _id);
        uniq_id = _id;
    endfunction: new

    /// \brief Accessor method to retrieve the unique ID associated with this packer class
    /// \param none
    /// \return unique ID associated with this packer class 
    function int unsigned get_unique_identifier();
        return uniq_id;
    endfunction:get_unique_identifier


    /// \brief do_pack This function is empty here. This class is only
    ///        meant to be a container for its derived classes
    /// \param t Handle to the TLM generic payload to retrieve extensions from.
    /// \param packer Handle to UVMConnect's packer class to use to pack extensions
    /// \return bit that indicates if the extension was packed (1 if packed, 0 otherwise)
    virtual function bit do_pack(uvm_tlm_generic_payload t, uvm_packer packer);
    endfunction:do_pack

    /// \brief do_unpack This function is empty here. This class is only
    ///        meant to be a container for its derived classes
    /// \param t Handle to the TLM generic payload to add unpacked extensions to.
    /// \param unpacker Handle to UVMConnect's packer class to use to unpack extensions
    virtual function void do_unpack(uvm_tlm_generic_payload t, uvm_packer packer);
    endfunction:do_unpack

endclass: nvdla_scsv_extension_packer_base
