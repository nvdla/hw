`ifndef MEM_MAN_PKG_SV
`define MEM_MAN_PKG_SV

package mem_man_pkg;

    import uvm_pkg::*;

    `include "mem_man_define.svh"
    `include "mem_region.svh"
    `include "mem_domain.svh"
    `include "mem_man.svh"

endpackage

/*

// cmd:
//     vcs -sverilog -ntb_opts uvm -R mem_man_pkg.sv

module mem_man_test;

    import mem_man_pkg::*;

    initial begin
        mem_man mm;
        mem_region rgn;

        mm = mem_man::get_mem_man();
        mm.register_domain("DRAM"   , 'h0_0000, 'hffff);
        mm.register_domain("SRAM_LO", 'h0_0000, 'hffff);
        mm.register_domain("SRAM_HI", 'h8_0000, 'h8_ffff, 1); // allocate from limit end side

        rgn = mm.request_region_by_addr("DRAM", "dram_0", 'h0000, 'h00ff);
        $display(rgn.convert2string());
        rgn = mm.request_region_by_addr("DRAM", "dram_1", 'h0100, 'h02ff);
        $display(rgn.convert2string());
        rgn = mm.request_region_by_addr("SRAM_LO", "sram_0", 'h0000, 'h01ff);
        $display(rgn.convert2string());
        rgn = mm.request_region_by_addr("SRAM_LO", "sram_1", 'hf000, 'hf0ff);
        $display(rgn.convert2string());

        for (int i=0; i<5; i++) begin
            rgn = mm.request_region_by_size("DRAM", $sformatf("dram_%0d", i+2), 'h1000, 'h1f);
            if (rgn == null) begin
                mm.display();
                $display("request_region failed: size = %#0x, align_mask = %#0x", 'h1000, 'h1f);
            end else begin
                $display(rgn.convert2string());
            end
        end

        for (int i=0; i<5; i++) begin
            rgn = mm.request_region_by_size("SRAM_LO", $sformatf("sram_%0d", i+2), 'h1000, 'hf);
            if (rgn == null) begin
                mm.display();
                $display("request_region failed: size = %#0x, align_mask = %#0x", 'h1000, 'hf);
            end else begin
                $display(rgn.convert2string());
            end
        end

        for (int i=0; i<5; i++) begin
            rgn = mm.request_region_by_size("SRAM_HI", $sformatf("sram_%0d", i), 'h1000, 'hf);
            if (rgn == null) begin
                mm.display();
                $display("request_region failed: size = %#0x, align_mask = %#0x", 'h1000, 'hf);
            end else begin
                $display(rgn.convert2string());
            end
        end

        mm.display();
    end

endmodule

*/

`endif
