// Rubik unit coverage

class rubik_cov_pool extends nvdla_coverage_base;

    // enum define
    //:| import spec2constrain
    //:| global spec2cons
    //:| spec2cons = spec2constrain.Spec2Cons()
    //:| spec2cons.enum_gen(['NVDLA_RBK'])

    bit_toggle_cg    tg_rbk_flds[string];

    int dain_line_stride_diff;
    int dain_surf_stride_diff;
    int dain_planar_stride_diff;

    int daout_line_stride_diff;
    int daout_surf_stride_diff;
    int daout_planar_stride_diff;

    function new(string name, ral_sys_top ral);
        uvm_reg       regs[$];
        uvm_reg_field flds[$];
        super.new(name, ral);

        rubik_cg = new();
        ral.nvdla.NVDLA_RBK.get_registers(regs);
        foreach(regs[i]) begin
            if(regs[i].get_rights() == "RW") begin
                regs[i].get_fields(flds);
                foreach(flds[j]) begin
                    name              = flds[j].get_name();
                    tg_rbk_flds[name] = new({"tg_rbk_",name.tolower()}, flds[j].get_n_bits());
                end
                flds.delete();
            end
        end
        regs.delete();
    endfunction: new

    function void rubik_toggle_sample(ref ral_sys_top ral_mdl);
        uvm_reg_field fld;
        foreach(tg_rbk_flds[i]) begin
            fld = ral.nvdla.NVDLA_RBK.get_field_by_name(i);
            tg_rbk_flds[i].sample(fld.value);
        end
    endfunction: rubik_toggle_sample

    covergroup rubik_cg with function sample(ref ral_sys_top ral_mdl);
        cp_rubik_mode: coverpoint ral_mdl.nvdla.NVDLA_RBK.D_MISC_CFG.RUBIK_MODE.value {
            bins mode[] = {rubik_mode_CONTRACT, rubik_mode_SPLIT, rubik_mode_MERGE};
        }
        cp_in_precision: coverpoint ral_mdl.nvdla.NVDLA_RBK.D_MISC_CFG.IN_PRECISION.value {
            bins precision[] = {in_precision_INT8, in_precision_INT16, in_precision_FP16};
        }
        cp_datain_width: coverpoint ral_mdl.nvdla.NVDLA_RBK.D_DATAIN_SIZE_0.DATAIN_WIDTH.value {
            bins zero      = {'h0};
            bins max       = {'h1FFF};
            bins extreme   = {['h1000:'h1FFF]};
            bins full[8]   = {['h0   :'h1FFF]};
        }
        cp_datain_height: coverpoint ral_mdl.nvdla.NVDLA_RBK.D_DATAIN_SIZE_0.DATAIN_HEIGHT.value {
            bins zero      = {'h0};
            bins max       = {'h1FFF};
            bins extreme   = {['h1000:'h1FFF]};
            bins full[8]   = {['h0   :'h1FFF]};
        }

        cp_datain_channel: coverpoint ral_mdl.nvdla.NVDLA_RBK.D_DATAIN_SIZE_1.DATAIN_CHANNEL.value {
            bins zero      = {'h0};
            bins max       = {'h1FFF};
            bins extreme   = {['h1000:'h1FFF]};
            bins full[8]   = {['h0   :'h1FFF]};
        }

        cp_datain_channel_merge: coverpoint ral_mdl.nvdla.NVDLA_RBK.D_DATAIN_SIZE_1.DATAIN_CHANNEL.value iff (rubik_mode_CONTRACT == ral_mdl.nvdla.NVDLA_RBK.D_MISC_CFG.RUBIK_MODE.value )
        {
            bins le_31_in_merge = {[0:30]};
            bins eq_31_in_merge = {31};
            bins gt_31_in_merge = {[32:$]};
        }

        cp_dain_ram_type: coverpoint ral_mdl.nvdla.NVDLA_RBK.D_DAIN_RAM_TYPE.DATAIN_RAM_TYPE.value {
            bins mem_id[] = {0,1};
        }

`ifdef MEM_ADDR_WIDTH_GT_32
        cp_dain_addr_high: coverpoint ral_mdl.nvdla.NVDLA_RBK.D_DAIN_ADDR_HIGH.DAIN_ADDR_HIGH.value {
           bins full[8] = {['h0:'hFF]};
        }
        cr_dain_addr_high_x_dain_ram_type: cross cp_dain_ram_type, cp_dain_addr_high;
`endif

        cp_dain_addr_low: coverpoint ral_mdl.nvdla.NVDLA_RBK.D_DAIN_ADDR_LOW.DAIN_ADDR_LOW.value {
           bins full[8] = {['h0:'h7FF_FFFF]};
        }
        cr_dain_addr_low_x_dain_ram_type: cross cp_dain_ram_type, cp_dain_addr_low;

        cp_dain_line_stride: coverpoint dain_line_stride_diff {
            bins full[] = {[0:7]};
            //illegal_bins illegal = {[8:$]};
        }
        cp_dain_surf_stride: coverpoint dain_surf_stride_diff iff (rubik_mode_MERGE != ral_mdl.nvdla.NVDLA_RBK.D_MISC_CFG.RUBIK_MODE.value ) {
            bins full[] = {[0:7]};
        }

        cp_dain_planar_stride: coverpoint dain_planar_stride_diff iff (rubik_mode_MERGE == ral_mdl.nvdla.NVDLA_RBK.D_MISC_CFG.RUBIK_MODE.value ) {
            bins full[] = {0,2,4,6};
        }

        cp_daout_ram_type: coverpoint ral_mdl.nvdla.NVDLA_RBK.D_DAOUT_RAM_TYPE.DATAOUT_RAM_TYPE.value {
            bins mem_id[] = {0,1};
        }

`ifdef MEM_ADDR_WIDTH_GT_32
        cp_daout_addr_high: coverpoint ral_mdl.nvdla.NVDLA_RBK.D_DAOUT_ADDR_HIGH.DAOUT_ADDR_HIGH.value {
           bins full[8] = {['h0:'hFF]};
        }
        cr_daout_addr_high_x_daout_ram_type: cross cp_daout_ram_type, cp_daout_addr_high;
`endif
        cp_daout_addr_low: coverpoint ral_mdl.nvdla.NVDLA_RBK.D_DAOUT_ADDR_LOW.DAOUT_ADDR_LOW.value {
           bins full[8] = {['h0:'h7FF_FFFF]};
        }
        cr_daout_addr_low_x_daout_ram_type: cross cp_daout_ram_type, cp_daout_addr_low;

        cp_daout_line_stride: coverpoint daout_line_stride_diff {
            bins full[] = {[0:7]};
        }

        cp_daout_surf_stride: coverpoint daout_surf_stride_diff iff (rubik_mode_SPLIT != ral_mdl.nvdla.NVDLA_RBK.D_MISC_CFG.RUBIK_MODE.value ) {
            bins full[] = {[0:7]};
        }
        cp_daout_planar_stride: coverpoint daout_planar_stride_diff iff (rubik_mode_SPLIT == ral_mdl.nvdla.NVDLA_RBK.D_MISC_CFG.RUBIK_MODE.value ) {
            bins full[] = {0,2,4,6};
        }

        cp_deconv_x_stride: coverpoint  ral_mdl.nvdla.NVDLA_RBK.D_DECONV_STRIDE.DECONV_X_STRIDE.value iff (rubik_mode_CONTRACT == ral_mdl.nvdla.NVDLA_RBK.D_MISC_CFG.RUBIK_MODE.value ) {
            bins full[] = {[0:31]};
        }
        cp_deconv_y_stride: coverpoint  ral_mdl.nvdla.NVDLA_RBK.D_DECONV_STRIDE.DECONV_Y_STRIDE.value iff (rubik_mode_CONTRACT == ral_mdl.nvdla.NVDLA_RBK.D_MISC_CFG.RUBIK_MODE.value ) {
            bins full[] = {[0:31]};
        }
        cr_deconv_x_stride_x_deconv_y_stride: cross cp_deconv_y_stride,cp_deconv_x_stride;

        cp_dataout_channel: coverpoint ral_mdl.nvdla.NVDLA_RBK.D_DATAOUT_SIZE_1.DATAOUT_CHANNEL.value {
            bins zero       = {'h0};
            bins max        = {'h1FFF};
            bins full[8]   = {['h0   :'h1FFF]};
        }
    endgroup: rubik_cg;

    task sample(ref ral_sys_top ral_mdl);
        `uvm_info(tID, $sformatf("Sample RUBIK Begin ..."), UVM_LOW)
        /*
            Calculation of intermediate variables
        */
        dain_line_stride_diff = (ral_mdl.nvdla.NVDLA_RBK.D_DAIN_LINE_STRIDE.DAIN_LINE_STRIDE.value - ral_mdl.nvdla.NVDLA_RBK.D_DATAIN_SIZE_0.DATAIN_WIDTH.value - 1) & 'h7;
        dain_surf_stride_diff = (ral_mdl.nvdla.NVDLA_RBK.D_DAIN_SURF_STRIDE.DAIN_SURF_STRIDE.value - (ral_mdl.nvdla.NVDLA_RBK.D_DAIN_LINE_STRIDE.DAIN_LINE_STRIDE.value*(ral_mdl.nvdla.NVDLA_RBK.D_DATAIN_SIZE_0.DATAIN_HEIGHT.value +1))) & 'h7;
        dain_planar_stride_diff = (ral_mdl.nvdla.NVDLA_RBK.D_DAIN_PLANAR_STRIDE.DAIN_PLANAR_STRIDE.value - (ral_mdl.nvdla.NVDLA_RBK.D_DAIN_LINE_STRIDE.DAIN_LINE_STRIDE.value*(ral_mdl.nvdla.NVDLA_RBK.D_DATAIN_SIZE_0.DATAIN_HEIGHT.value +1))) & 'h7;

        daout_line_stride_diff = (ral_mdl.nvdla.NVDLA_RBK.D_DAOUT_LINE_STRIDE.DAOUT_LINE_STRIDE.value - ral_mdl.nvdla.NVDLA_RBK.D_DATAIN_SIZE_0.DATAIN_WIDTH.value - 1) & 'h7;
        daout_surf_stride_diff = (ral_mdl.nvdla.NVDLA_RBK.D_DAOUT_SURF_STRIDE.DAOUT_SURF_STRIDE.value - (ral_mdl.nvdla.NVDLA_RBK.D_DAOUT_LINE_STRIDE.DAOUT_LINE_STRIDE.value*(ral_mdl.nvdla.NVDLA_RBK.D_DATAIN_SIZE_0.DATAIN_HEIGHT.value +1))) & 'h7;
        daout_planar_stride_diff = (ral_mdl.nvdla.NVDLA_RBK.D_DAOUT_PLANAR_STRIDE.DAOUT_PLANAR_STRIDE.value - (ral_mdl.nvdla.NVDLA_RBK.D_DAOUT_LINE_STRIDE.DAOUT_LINE_STRIDE.value*(ral_mdl.nvdla.NVDLA_RBK.D_DATAIN_SIZE_0.DATAIN_HEIGHT.value +1))) & 'h7;

        rubik_cg.sample(ral_mdl);
        rubik_toggle_sample(ral_mdl);
    endtask: sample

endclass: rubik_cov_pool
