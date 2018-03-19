`ifndef RAL_TOP
`define RAL_TOP

class ral_sys_top extends uvm_reg_block;

   rand block_addrmap_NVDLA nvdla;

	function new(string name = "top");
		super.new(name);
	endfunction: new

	function void build();
      this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);
      this.nvdla = block_addrmap_NVDLA::type_id::create("nvdla",,get_full_name());
      this.nvdla.configure(this, "ntb_dut.u_nvdla");
      this.nvdla.build();
      this.default_map.add_submap(this.nvdla.default_map, `UVM_REG_ADDR_WIDTH'h0);
	endfunction : build

	`uvm_object_utils(ral_sys_top)
endclass : ral_sys_top



`endif
