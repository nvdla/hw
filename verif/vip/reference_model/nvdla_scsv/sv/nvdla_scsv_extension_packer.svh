//  This file contains a parametrized base class from which user defined extension 
//  packer classes should extend. This class is parametrized by TLM extension type.

/*! \class nvdla_scsv_extension_packer
    \brief This is a parametrized base class from which user defined extension 
           packer classes should extend. This class is templated by TLM extension type.

    To add support for a new extension type, users should extend this class, 
    pass the extension type as a template parameter and implement the private
    methods pack(..)/unpack(..) to handle packing the fields of the TLM extension
*/
class nvdla_scsv_extension_packer#(type extn_type) extends nvdla_scsv_extension_packer_base;

    /// Variable to hold the object of the extension this class is parametrized by
    extn_type extn_handle;
    
    /// Constructor
    /// \brief Constructor. Takes the unique id as an argument
    /// \return none.
    function new(int unsigned _id);
        super.new(_id);
    endfunction:new

    /// create_extension 
    /// \brief This function creates an object of type extn_type, and returns
    ///        a handle to it. This calls the default constructor.
    ///        Incase the extension needs a specific constructor/arguments, 
    ///        implement this function in the extended packer class.
    /// \params none
    /// return Handle to an object of extn_type
    virtual function extn_type create_extension();
        extn_handle = new();
        return extn_handle;
    endfunction:create_extension

    /// \brief do_pack attempts a t.get_extension(..) for an \c extn_type. If a
    ///        non-null handle is returned, packing is attempted for that type.
    ///        The unique ID is packed first, following which the pack(..) 
    ///        routine is called to pack the fields of the TLM extension itself.
    /// \param t Handle to the TLM generic payload that contains extensions to pack
    /// \param packer Handle to UVMConnect's packer class to use to pack extensions
    /// \return bit that indicates if the extension was packed (1 if packed, 0 otherwise)
    function bit do_pack (uvm_tlm_generic_payload t, uvm_packer packer);
        bit retval = 0;
        extn_type extn_to_pack = create_extension();

        // Get the extension object to pack
        `uvm_info("SCSV_EXTENSION_PACKER/DO_PACK",{"Attempting to pack payload : \n",t.sprint()},UVM_HIGH);
        if ($cast(extn_to_pack,t.get_extension(extn_type::ID())) && (extn_to_pack!=null)) begin
            `uvm_pack_intN(get_unique_identifier(),32); // Pack the unique ID
            pack(extn_to_pack, packer); //Call pack(..) to handle packing the actual extn
            `uvm_info("SCSV_EXTENSION_PACKER/DO_PACK",{"Packed Extension : \n",extn_to_pack.sprint()},UVM_HIGH);
            retval = 1;
        end else begin
            retval = 0;
        end
        return retval;

    endfunction:do_pack
    
    /// \brief do_unpack creates a new extension of type \c extn_type and
    ///        unconditionally calls the user implemented unpack(..) routine
    ///        This function does not check for the presence of the right unique ID.
    ///        The expectation is that is done before this function is called.
    /// \param t Handle to the TLM generic payload to add unpacked extensions to.
    /// \param packer Handle to UVMConnect's packer class to use to unpack extensions
    /// \return void
    function void do_unpack (uvm_tlm_generic_payload t, uvm_packer packer);
        extn_type extn_to_unpack = create_extension();
        // Call the user defined unpack(..) to populate the fileds of extn_to_unack
        unpack(extn_to_unpack, packer);
        `uvm_info("SCSV_EXTENSION_PACKER/DO_UNPACK",{"Unpacked Extension: \n",extn_to_unpack.sprint()},UVM_HIGH);
        // Set the newly created & populated extension in the TLM payload
        t.set_extension(extn_to_unpack);
        `uvm_info("SCSV_EXTENSION_PACKER/DO_UNPACK",{"Post-Extension GP: \n",t.sprint()},UVM_DEBUG);
    endfunction:do_unpack

    /// \brief pack(..) should implement the exact field-by-field packing for this
    ///        extension type in the extended class(es). 
    ///        This is an empty virtual function in this class.
    /// \param extn_to_pack Handle to the extension object, whose fields need
    ///        to be packed.
    /// \param packer Handle to UVM's packer class from which to invoke packing routines from
    /// \return void
    virtual function void pack(extn_type extn_to_pack, uvm_packer packer);
    endfunction:pack

    /// \brief unpack(..) should implement the exact field-by-field unpacking for this
    ///        extension type in the extended class(es). 
    ///        This is a pure virtual function in this class.
    /// \param extn_to_unpack Pointer to the extension object, whose fields need
    ///        to be populated with fields unpacked from the packer's bistream.
    /// \param packer Handle to UVMConnect's packer class from which to invoke unpacking routines from
    /// \return void
    virtual function void unpack(extn_type extn_to_unpack, uvm_packer packer);
    endfunction:unpack

endclass:nvdla_scsv_extension_packer


