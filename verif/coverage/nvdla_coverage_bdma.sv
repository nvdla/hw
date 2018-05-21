// BDMA unit Coverage

class bdma_cov_pool extends nvdla_coverage_base;

    bit_toggle_cg    tg_bdma_flds[string];

    function new(string name, ral_sys_top ral);
        uvm_reg       regs[$];
        uvm_reg_field flds[$];
        super.new(name, ral);

        bdma_cg = new();
        ral.nvdla.NVDLA_BDMA.get_registers(regs);
        foreach(regs[i]) begin
            if(regs[i].get_rights() == "RW") begin
                regs[i].get_fields(flds);
                foreach(flds[j]) begin
                    name                   = flds[j].get_name();
`ifndef MEM_ADDR_WIDTH_GT_32
                    // Need to update field name in spec
                    if(name == "V8") continue;
`endif
                    tg_bdma_flds[name] = new({"tg_bdma_",name.tolower()}, flds[j].get_n_bits());
                end
                flds.delete();
            end
        end
        regs.delete();

    endfunction : new

    covergroup bdma_cg with function sample(ref ral_sys_top ral_mdl);
        cp_cfg_src_addr_low:      coverpoint ral_mdl.nvdla.NVDLA_BDMA.CFG_SRC_ADDR_LOW.V32.value[2: 0];
        cp_cfg_dst_addr_low:      coverpoint ral_mdl.nvdla.NVDLA_BDMA.CFG_DST_ADDR_LOW.V32.value[2: 0];
        cp_line_align:            coverpoint ral_mdl.nvdla.NVDLA_BDMA.CFG_LINE.SIZE.value[2: 0];
        cp_line:                  coverpoint ral_mdl.nvdla.NVDLA_BDMA.CFG_LINE.SIZE.value {
            bins hi[]   = {[13'h1FF0:13'h1FFF]};
            bins fu[8]  = {[13'h0:13'h1FFF]};
        }
        cp_src_end_addr:          coverpoint ((ral_mdl.nvdla.NVDLA_BDMA.CFG_LINE.SIZE.value+{ral_mdl.nvdla.NVDLA_BDMA.CFG_SRC_ADDR_HIGH.V8.value,ral_mdl.nvdla.NVDLA_BDMA.CFG_SRC_ADDR_LOW.V32.value})%8) {
            bins end_addr_pos[] = {[0:7]};
        }

        cp_dst_end_addr:          coverpoint ((ral_mdl.nvdla.NVDLA_BDMA.CFG_LINE.SIZE.value+{ral_mdl.nvdla.NVDLA_BDMA.CFG_DST_ADDR_HIGH.V8.value,ral_mdl.nvdla.NVDLA_BDMA.CFG_DST_ADDR_LOW.V32.value})%8) {
            bins end_addr_pos[] = {[0:7]};
        }

        cp_src_ram_type:          coverpoint ral_mdl.nvdla.NVDLA_BDMA.CFG_CMD.SRC_RAM_TYPE.value {
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
            bins cv = {0};
`endif
            bins mc = {1};
        }
        cp_dst_ram_type:          coverpoint ral_mdl.nvdla.NVDLA_BDMA.CFG_CMD.DST_RAM_TYPE.value {
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
            bins cv = {0};
`endif
            bins mc = {1};
        }
        cr_src_dst_ram_type:      cross cp_src_ram_type , cp_dst_ram_type;
        cr_src_addr_low_ram_type: cross cp_cfg_src_addr_low  , cp_src_ram_type;
        cr_dst_addr_low_ram_type: cross cp_cfg_dst_addr_low  , cp_dst_ram_type;
        cp_op_en:                 coverpoint ral_mdl.nvdla.NVDLA_BDMA.CFG_OP.EN.value[0];
        cp_grp0_launch:           coverpoint ral_mdl.nvdla.NVDLA_BDMA.CFG_LAUNCH0.GRP0_LAUNCH.value[0];
        cp_grp1_launch:           coverpoint ral_mdl.nvdla.NVDLA_BDMA.CFG_LAUNCH1.GRP1_LAUNCH.value[0];
        cp_cfg_line_repeat:       coverpoint ral_mdl.nvdla.NVDLA_BDMA.CFG_LINE_REPEAT.NUMBER.value {
            bins lo[]              = {['h0:'hF]};
            bins hi[]              = {[13'h1FF0:13'h1FFF]};
            bins fu[8]             = {[13'h0:13'h1FFF]};
        }
        cp_cfg_surf_repeat:       coverpoint ral_mdl.nvdla.NVDLA_BDMA.CFG_SURF_REPEAT.NUMBER.value {
            bins lo[]              = {['h0:'hF]};
            bins hi[]              = {[13'h1FF0:13'h1FFF]};
            bins fu[8]             = {[13'h0:13'h1FFF]};
        }
        cp_cfg_src_line:          coverpoint ral_mdl.nvdla.NVDLA_BDMA.CFG_SRC_LINE.STRIDE.value[2:  0];
        cp_cfg_dst_line:          coverpoint ral_mdl.nvdla.NVDLA_BDMA.CFG_DST_LINE.STRIDE.value[2:  0];
        cp_cfg_src_surf:          coverpoint ral_mdl.nvdla.NVDLA_BDMA.CFG_SRC_SURF.STRIDE.value[2:  0];
        cp_cfg_dst_surf:          coverpoint ral_mdl.nvdla.NVDLA_BDMA.CFG_DST_SURF.STRIDE.value[2:  0];
        cp_idle:                  coverpoint ral_mdl.nvdla.NVDLA_BDMA.STATUS.IDLE.value[0];
        cp_free_slot:             coverpoint ral_mdl.nvdla.NVDLA_BDMA.STATUS.FREE_SLOT.value {
            bins val[] = {[0:20]};
        }
        cp_grp0_busy:             coverpoint ral_mdl.nvdla.NVDLA_BDMA.STATUS.GRP0_BUSY.value[0];
        cp_grp1_busy:             coverpoint ral_mdl.nvdla.NVDLA_BDMA.STATUS.GRP1_BUSY.value[0];
    endgroup : bdma_cg

    task sample(ref ral_sys_top ral_mdl);
        uvm_status_e  status;

        `uvm_info(tID, $sformatf("Sample Begin ..."), UVM_LOW)
        ral.nvdla.NVDLA_BDMA.STATUS.mirror(status, UVM_NO_CHECK, UVM_FRONTDOOR);
        bdma_toggle_sample(ral_mdl);
        bdma_cg.sample(ral_mdl);

    endtask : sample

    function void bdma_toggle_sample(ref ral_sys_top ral_mdl);
        uvm_reg_field fld;
        foreach(tg_bdma_flds[i]) begin
            fld = ral_mdl.nvdla.NVDLA_BDMA.get_field_by_name(i);
            tg_bdma_flds[i].sample(fld.value);
        end

    endfunction : bdma_toggle_sample

endclass : bdma_cov_pool

