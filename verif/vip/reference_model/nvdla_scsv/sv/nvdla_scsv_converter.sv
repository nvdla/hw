// This is the SystemVerilog side of the custom converter meant to pack a TLM
// generic payload which TLM extensions attached. This uses uvmc_default_converter
// to pack the GP, and then calls the right user-defined extension packer classes
// to handle packing the extensions themselves.

class nvdla_scsv_converter extends uvmc_default_converter#(uvm_tlm_generic_payload);

    /// static map to hold handles to the user-defined packer classes,
    /// indexed by their unique ID.
    static nvdla_scsv_extension_packer_base extension_packer_map[int unsigned];

    /// \brief do_pack is called by UVMConnect's infrastructure to handle packing
    ///        the TLM payload in its entirety. The implementation here calls
    ///        UVMConnect's default converter to pack the fields of the TLM GP
    ///        and then calls do_pack_extensions(..) which is expected to pack
    ///        all supported extension types.
    /// \param t Handle the TLM payload to pack
    /// \param packer Handle to UVM's Packer class which will be 
    ///        used to pack the GP and its extensions
    /// \return void
    static function void do_pack(uvm_tlm_generic_payload t, uvm_packer packer);

        // Call uvmc_default_converter::do_pack to handle packing the actual GP
        uvmc_default_converter#(uvm_tlm_generic_payload)::do_pack(t,packer); 

        // Call do_pack_extensions to handle packing the extension types
        do_pack_extensions(t,packer); 

    endfunction: do_pack

    /// \brief do_unpack is called by UVMConnect's infrastructure to handle unpacking
    ///        the TLM payload in its entirety. The implementation here calls
    ///        UVMConnect's default converter to unpack the fields of the TLM GP
    ///        and then calls do_unpack_extensions(..) which is expected to unpack
    ///        all supported extension types, and attach these to the unpacked TLM GP.
    /// \param t Handle the TLM payload to populate with unpacked data
    /// \param unpacker Handle to UVM's Packer class which will be 
    ///        used to unpack the GP and its extensions
    /// \return void
    static function void do_unpack(uvm_tlm_generic_payload t, uvm_packer unpacker);
        
        // Call default_converter::do_unpack to handle unpacking the actual GP
        uvmc_default_converter#(uvm_tlm_generic_payload)::do_unpack(t,unpacker); 
       
        // Call do_unpack_extensions to handle packing the extension types
        do_unpack_extensions(t,unpacker);

    endfunction: do_unpack

    /// \brief do_pack_extensions iterates over all the registered user-defined extension packer
    ///        classes and calls each class' do_pack routine to pack the extension type
    ///        supported by that user-defined extension packer class.
    /// \param t Handle the TLM payload that has extensions attached which need to be packed
    /// \param packer Handle to UVM's Packer class which will be used to pack fields of the
    ///        extension
    /// \return void
    static function void do_pack_extensions(uvm_tlm_generic_payload t, uvm_packer packer);
        int unsigned unique_identifier;
        int unsigned num_extns_packed = 0;
        bit packed_extension;
        // Iterate over the extension_packer_map associative array
        // and call do_pack(..) on each registered class
        if (extension_packer_map.first(unique_identifier))
        do begin
            `uvm_info("DO_PACK_EXTENSIONS/DO_PACK_EXTN",$psprintf("Trying to pack %h",unique_identifier),UVM_HIGH);
            packed_extension = extension_packer_map[unique_identifier].do_pack(t,packer);
            if (packed_extension) begin
               `uvm_info("DO_PACK_EXTENSIONS/DO_PACK_EXTN",$psprintf("Successfully packed %h",unique_identifier),UVM_HIGH);	       
                num_extns_packed++;
            end
	    else begin
               `uvm_info("DO_PACK_EXTENSIONS/DO_PACK_EXTN",$psprintf("Did not successfully pack %h",unique_identifier),UVM_HIGH);	       
	    end
        end while (extension_packer_map.next(unique_identifier));

        // Check if we packed all the attached extensions.
        // Incase there are extensions attached that we do not support,
        // this count will mismatch and that will be an error.
        if (num_extns_packed != t.get_num_extensions()) begin
            `uvm_info("DO_PACK_EXTENSIONS/UNSUPPORTED_EXTN",
                 $psprintf("All tlm extensions not packed. Packed %0d extensions, but the payload contains %0d extensions.",
                 num_extns_packed, t.get_num_extensions()), UVM_HIGH);
        end else begin 
            `uvm_info("DO_PACK_EXTENSIONS/PACKED_EXTNS", $psprintf("Packed %0d extensions",num_extns_packed),UVM_HIGH);
        end

    endfunction:do_pack_extensions

    static function void do_unpack_extensions(uvm_tlm_generic_payload t, uvm_packer packer);
        int unsigned unique_identifier;

        for (int unsigned i=0; i < extension_packer_map.num(); i++) begin
            // Unpack the unique identifier first
            `uvm_unpack_intN(unique_identifier,32);
            // Look through our extension map to see if we have a converter for
            // that ID
            if(extension_packer_map.exists(unique_identifier)) begin
                `uvm_info("DO_UNPACK_EXTENSIONS/DO_UNPACK_EXTN",$psprintf("Found a valid ID! Trying to unpack %d",unique_identifier),UVM_HIGH);
                // Call do_unpack if we have a valid extension packer found for that ID
                extension_packer_map[unique_identifier].do_unpack(t, packer);
            end else begin
                `uvm_info("DO_UNPACK_EXTENSIONS/DO_UNPACK_EXTN",$psprintf("ID %d not found in registery, skipping conversion",unique_identifier),UVM_HIGH);	
            end
        end
    endfunction:do_unpack_extensions

endclass: nvdla_scsv_converter


/*! \class nvdla_scsv_register_extension_packer
    \brief This is a parametrized class (parametrized by packer class type)
           which provides a static method to add user-defined packers in the converter's
           associative array
*/
class nvdla_scsv_register_extension_packer#(type packer_type);

    /// register
    /// \brief This function should be called to register a user-defined
    ///        extension packer class. 
    /// \params id The unique ID associated with that packer class
    /// \return void
    static function void register_extension(int unsigned id);
        packer_type packer_handle = new(id);
        if (nvdla_scsv_converter::extension_packer_map.exists(id)) begin
            // If we already have a packer registered for this ID, 
            // thats a fatal error. ID<->packer should be uniquely associated.
            `uvm_fatal("DUPLICATE_EXTN_ID",$psprintf("ID:%d already exists. Duplicate extension IDs not allowed\n",id));
        end else begin
            // If it doesn't exist, add it in extension_packer_map
            `uvm_info("REGISTER_EXTN",$psprintf("Registered extension packer class with ID:%d",id),UVM_MEDIUM);
            nvdla_scsv_converter::extension_packer_map[id] = packer_handle;
        end
endfunction:register_extension

endclass: nvdla_scsv_register_extension_packer
