// This is the SystemVerilog side packer class for the dbb_bus_ext class
class nvdla_dbb_scsv_extension_packer extends nvdla_scsv_extension_packer#(dbb_bus_ext);

    function new(int unsigned id);
        super.new(id);
    endfunction:new

    function void pack(dbb_bus_ext extn_to_pack, uvm_packer packer);
        `uvm_pack_int(extn_to_pack.get_id());
        `uvm_pack_int(extn_to_pack.get_size());
        `uvm_pack_int(extn_to_pack.get_length());
    endfunction:pack

    function void unpack(dbb_bus_ext extn_to_unpack, uvm_packer packer);
        int unsigned m_id;
        int unsigned m_size;
        int unsigned m_len;

        `uvm_unpack_int(m_id);
        `uvm_unpack_int(m_size);
        `uvm_unpack_int(m_len);

        extn_to_unpack.set_id(m_id);
        extn_to_unpack.set_size(m_size);
        extn_to_unpack.set_length(m_len); 
    endfunction:unpack

endclass:nvdla_dbb_scsv_extension_packer
