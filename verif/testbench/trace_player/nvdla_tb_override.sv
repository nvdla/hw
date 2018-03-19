// nvdla_tb_override.sv - All overrided type are put here

class my_uvm_tlm_gp extends uvm_tlm_gp;
    `uvm_object_utils(my_uvm_tlm_gp)

    function new(string name = "my_uvm_tlm_gp");
        super.new(name);
    endfunction

    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        uvm_tlm_generic_payload gp;
        $cast(gp, rhs);

        do_compare = (m_address == gp.m_address &&
                      m_command == gp.m_command &&
                      m_length  == gp.m_length  &&
                      m_dmi     == gp.m_dmi &&
                      m_byte_enable_length == gp.m_byte_enable_length  &&
                      m_response_status    == gp.m_response_status &&
                      m_streaming_width    == gp.m_streaming_width );
         
        `uvm_info("TLM/GP", $sformatf("AAA: do_compare = %0d", do_compare), UVM_HIGH)

        // HACK to skip read data comparison for read request GP
        if (do_compare && m_length == gp.m_length
         && m_command != UVM_TLM_READ_COMMAND
         && m_response_status != UVM_TLM_INCOMPLETE_RESPONSE) begin
            byte unsigned lhs_be, rhs_be;
            for (int i=0; do_compare && i < m_length && i < m_data.size(); i++) begin
                if (m_byte_enable_length) begin
                    lhs_be = m_byte_enable[i % m_byte_enable_length];
                    rhs_be = gp.m_byte_enable[i % gp.m_byte_enable_length];
                    do_compare = ((m_data[i] & lhs_be) == (gp.m_data[i] & rhs_be));
                end
                else begin
                    do_compare = (m_data[i] == gp.m_data[i]);
                end
            end
            `uvm_info("TLM/GP", $sformatf("BBB: do_compare = %0d", do_compare), UVM_HIGH)
        end

        // Hack to only compare dbb_bus_ext
        if (do_compare) begin
            foreach (m_extensions[ext]) begin
                if (gp.m_extensions.exists(ext)) begin
                    `uvm_info("TLM/GP/EXT", $sformatf("CCC: ID = %p", ext), UVM_FULL)
                    do_compare = comparer.compare_object(ext.get_name(),
                                                         m_extensions[ext], gp.m_extensions[ext]);
                    if (!do_compare) break;
                end
            end
            `uvm_info("TLM/GP/EXT", $sformatf("CCC: do_compare = %0d", do_compare), UVM_HIGH)
        end

        if (!do_compare && comparer.show_max > 0) begin
            string msg = $sformatf("GP miscompare between '%s' and '%s':\nlhs = %s\nrhs = %s",
                                   get_full_name(), gp.get_full_name(), this.convert2string(), gp.convert2string());
            case (comparer.sev)
                UVM_WARNING: `uvm_warning("MISCMP", msg)
                UVM_ERROR:   `uvm_error("MISCMP", msg)
                default:     `uvm_info("MISCMP", msg, UVM_LOW)
            endcase
        end
    endfunction
    
endclass

