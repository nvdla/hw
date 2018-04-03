// BDMA unit Coverage

class bdma_cov_pool extends nvdla_coverage_base;

    bit_toggle_cg           cfg_src_addr_low_tog_cg;
    bit_toggle_cg           cfg_dst_addr_low_tog_cg;
`ifdef MEM_ADDR_WIDTH_GT_32
    bit_toggle_cg           cfg_src_addr_high_tog_cg;
    bit_toggle_cg           cfg_dst_addr_high_tog_cg;
`endif
    bit_toggle_cg           cfg_line_tog_cg;
    bit_toggle_cg           cfg_line_repeat_tog_cg;
    bit_toggle_cg           cfg_surf_repeat_tog_cg;
    bit_toggle_cg           cfg_src_line_tog_cg;
    bit_toggle_cg           cfg_dst_line_tog_cg;
    bit_toggle_cg           cfg_src_surf_tog_cg;
    bit_toggle_cg           cfg_dst_surf_tog_cg;

    function new(string name, ral_sys_top ral);
        super.new(name, ral);

        bdma_cg = new();

        cfg_src_addr_low_tog_cg  = new("cfg_src_addr_low",  ral.nvdla.NVDLA_BDMA.CFG_SRC_ADDR_LOW.V32.get_n_bits());
        cfg_dst_addr_low_tog_cg  = new("cfg_dst_addr_low",  ral.nvdla.NVDLA_BDMA.CFG_DST_ADDR_LOW.V32.get_n_bits());
`ifdef MEM_ADDR_WIDTH_GT_32
        cfg_src_addr_high_tog_cg = new("cfg_src_addr_high", ral.nvdla.NVDLA_BDMA.CFG_SRC_ADDR_HIGH.V8.get_n_bits());
        cfg_dst_addr_high_tog_cg = new("cfg_dst_addr_high", ral.nvdla.NVDLA_BDMA.CFG_DST_ADDR_HIGH.V8.get_n_bits());
`endif
        cfg_line_tog_cg          = new("cfg_line",          ral.nvdla.NVDLA_BDMA.CFG_LINE.SIZE.get_n_bits());
        cfg_line_repeat_tog_cg   = new("cfg_line_repeat",   ral.nvdla.NVDLA_BDMA.CFG_LINE_REPEAT.NUMBER.get_n_bits());
        cfg_surf_repeat_tog_cg   = new("cfg_surf_repeat",   ral.nvdla.NVDLA_BDMA.CFG_SURF_REPEAT.NUMBER.get_n_bits());
        cfg_src_line_tog_cg      = new("cfg_src_line",      ral.nvdla.NVDLA_BDMA.CFG_SRC_LINE.STRIDE.get_n_bits());
        cfg_dst_line_tog_cg      = new("cfg_dst_line",      ral.nvdla.NVDLA_BDMA.CFG_DST_LINE.STRIDE.get_n_bits());
        cfg_src_surf_tog_cg      = new("cfg_src_surf",      ral.nvdla.NVDLA_BDMA.CFG_SRC_SURF.STRIDE.get_n_bits());
        cfg_dst_surf_tog_cg      = new("cfg_dst_surf",      ral.nvdla.NVDLA_BDMA.CFG_DST_SURF.STRIDE.get_n_bits());
    endfunction : new

    covergroup bdma_cg;
        cp_cfg_src_addr_low:      coverpoint ral.nvdla.NVDLA_BDMA.CFG_SRC_ADDR_LOW.V32.value[2: 0];
        cp_cfg_dst_addr_low:      coverpoint ral.nvdla.NVDLA_BDMA.CFG_DST_ADDR_LOW.V32.value[2: 0];
        cp_line_align:            coverpoint ral.nvdla.NVDLA_BDMA.CFG_LINE.SIZE.value[2: 0];
        cp_line:                  coverpoint ral.nvdla.NVDLA_BDMA.CFG_LINE.SIZE.value {
            bins hi[]   = {[13'h1FF0:13'h1FFF]};
            bins fu[8]  = {[13'h0:13'h1FFF]};
        }
        cp_src_end_addr:          coverpoint ((ral.nvdla.NVDLA_BDMA.CFG_LINE.SIZE.value+{ral.nvdla.NVDLA_BDMA.CFG_SRC_ADDR_HIGH.V8.value,ral.nvdla.NVDLA_BDMA.CFG_SRC_ADDR_LOW.V32.value})%8) {
            bins end_addr_pos[] = {[0:7]};
        }

        cp_dst_end_addr:          coverpoint ((ral.nvdla.NVDLA_BDMA.CFG_LINE.SIZE.value+{ral.nvdla.NVDLA_BDMA.CFG_DST_ADDR_HIGH.V8.value,ral.nvdla.NVDLA_BDMA.CFG_DST_ADDR_LOW.V32.value})%8) {
            bins end_addr_pos[] = {[0:7]};
        }

        cp_src_ram_type:          coverpoint ral.nvdla.NVDLA_BDMA.CFG_CMD.SRC_RAM_TYPE.value {
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
            bins cv = {0};
`endif
            bins mc = {1};
        }
        cp_dst_ram_type:          coverpoint ral.nvdla.NVDLA_BDMA.CFG_CMD.DST_RAM_TYPE.value {
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
            bins cv = {0};
`endif
            bins mc = {1};
        }
        cr_src_dst_ram_type:      cross cp_src_ram_type , cp_dst_ram_type;
        cr_src_addr_low_ram_type: cross cp_cfg_src_addr_low  , cp_src_ram_type;
        cr_dst_addr_low_ram_type: cross cp_cfg_dst_addr_low  , cp_dst_ram_type;
        cp_op_en:                 coverpoint ral.nvdla.NVDLA_BDMA.CFG_OP.EN.value[0];
        cp_grp0_launch:           coverpoint ral.nvdla.NVDLA_BDMA.CFG_LAUNCH0.GRP0_LAUNCH.value[0];
        cp_grp1_launch:           coverpoint ral.nvdla.NVDLA_BDMA.CFG_LAUNCH1.GRP1_LAUNCH.value[0];
        cp_cfg_line_repeat:       coverpoint ral.nvdla.NVDLA_BDMA.CFG_LINE_REPEAT.NUMBER.value {
            bins lo[]              = {['h0:'hF]};
            bins hi[]              = {[13'h1FF0:13'h1FFF]};
            bins fu[8]             = {[13'h0:13'h1FFF]};
        }
        cp_cfg_surf_repeat:       coverpoint ral.nvdla.NVDLA_BDMA.CFG_SURF_REPEAT.NUMBER.value {
            bins lo[]              = {['h0:'hF]};
            bins hi[]              = {[13'h1FF0:13'h1FFF]};
            bins fu[8]             = {[13'h0:13'h1FFF]};
        }
        cp_cfg_src_line:          coverpoint ral.nvdla.NVDLA_BDMA.CFG_SRC_LINE.STRIDE.value[2:  0];
        cp_cfg_dst_line:          coverpoint ral.nvdla.NVDLA_BDMA.CFG_DST_LINE.STRIDE.value[2:  0];
        cp_cfg_src_surf:          coverpoint ral.nvdla.NVDLA_BDMA.CFG_SRC_SURF.STRIDE.value[2:  0];
        cp_cfg_dst_surf:          coverpoint ral.nvdla.NVDLA_BDMA.CFG_DST_SURF.STRIDE.value[2:  0];
        cp_idle:                  coverpoint ral.nvdla.NVDLA_BDMA.STATUS.IDLE.value[0];
        cp_free_slot:             coverpoint ral.nvdla.NVDLA_BDMA.STATUS.FREE_SLOT.value {
            bins val[] = {[0:20]};
        }
        cp_grp0_busy:             coverpoint ral.nvdla.NVDLA_BDMA.STATUS.GRP0_BUSY.value[0];
        cp_grp1_busy:             coverpoint ral.nvdla.NVDLA_BDMA.STATUS.GRP1_BUSY.value[0];
    endgroup : bdma_cg

    task sample();
        uvm_status_e  status;

        `uvm_info(tID, $sformatf("Sample Begin ..."), UVM_LOW)
        ral.nvdla.NVDLA_BDMA.STATUS.mirror(status, UVM_NO_CHECK, UVM_FRONTDOOR);
        bdma_toggle_sample();
        bdma_cg.sample();

    endtask : sample

    function void bdma_toggle_sample();
        cfg_src_addr_low_tog_cg.sample(ral.nvdla.NVDLA_BDMA.CFG_SRC_ADDR_LOW.V32.value);
        cfg_dst_addr_low_tog_cg.sample(ral.nvdla.NVDLA_BDMA.CFG_DST_ADDR_LOW.V32.value);
`ifdef MEM_ADDR_WIDTH_GT_32
        cfg_src_addr_high_tog_cg.sample(ral.nvdla.NVDLA_BDMA.CFG_SRC_ADDR_HIGH.V8.value);
        cfg_dst_addr_high_tog_cg.sample(ral.nvdla.NVDLA_BDMA.CFG_DST_ADDR_HIGH.V8.value);
`endif
        cfg_line_tog_cg.sample(ral.nvdla.NVDLA_BDMA.CFG_LINE.SIZE.value);
        cfg_line_repeat_tog_cg.sample(ral.nvdla.NVDLA_BDMA.CFG_LINE_REPEAT.NUMBER.value);
        cfg_src_line_tog_cg.sample(ral.nvdla.NVDLA_BDMA.CFG_SRC_LINE.STRIDE.value);
        cfg_dst_line_tog_cg.sample(ral.nvdla.NVDLA_BDMA.CFG_DST_LINE.STRIDE.value);
        cfg_surf_repeat_tog_cg.sample(ral.nvdla.NVDLA_BDMA.CFG_SURF_REPEAT.NUMBER.value);
        cfg_src_surf_tog_cg.sample(ral.nvdla.NVDLA_BDMA.CFG_SRC_SURF.STRIDE.value);
        cfg_dst_surf_tog_cg.sample(ral.nvdla.NVDLA_BDMA.CFG_DST_SURF.STRIDE.value);
    endfunction : bdma_toggle_sample

endclass : bdma_cov_pool

