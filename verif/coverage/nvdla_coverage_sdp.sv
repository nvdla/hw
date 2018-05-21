// SDP unit coverage

class sdp_cov_pool extends nvdla_coverage_base;


    bit_toggle_cg    tg_sdp_flds[string];
    bit_toggle_cg    tg_sdp_rdma_flds[string];
`ifdef NVDLA_SDP_LUT_ENABLE
    bit_toggle_cg    tg_sdp_lut_flds[string];
`endif

    function new(string name, ral_sys_top ral);
        uvm_reg       regs[$];
        uvm_reg_field flds[$];
        string        reg_name;
        super.new(name, ral);

        sdp_cg      = new();
`ifdef NVDLA_SDP_LUT_ENABLE
        sdp_lut_cg  = new();
`endif
        sdp_rdma_cg = new();

        ral.nvdla.NVDLA_SDP_RDMA.get_registers(regs);
        foreach(regs[i]) begin
            if(regs[i].get_rights() == "RW") begin
                regs[i].get_fields(flds);
                foreach(flds[j]) begin
                    name                   = flds[j].get_name();
`ifndef MEM_ADDR_WIDTH_GT_32
                    if(name == "SRC_BASE_ADDR_HIGH"  || 
                       name == "BS_BASE_ADDR_HIGH"   || 
                       name == "BN_BASE_ADDR_HIGH"   || 
                       name == "EW_BASE_ADDR_HIGH") continue;
    `ifndef NVDLA_SDP_BS_ENABLE
                    if(name == "BS_BASE_ADDR_LOW") continue;
    `endif
    `ifndef NVDLA_SDP_BN_ENABLE
                    if(name == "BN_BASE_ADDR_LOW") continue;
    `endif
    `ifndef NVDLA_SDP_EW_ENABLE
                    if(name == "EW_BASE_ADDR_LOW") continue;
    `endif
`endif
                    tg_sdp_rdma_flds[name] = new({"tg_sdp_rdma_",name.tolower()}, flds[j].get_n_bits());
                end
                flds.delete();
            end
        end
        regs.delete();

        ral.nvdla.NVDLA_SDP.get_registers(regs);
        foreach(regs[i]) begin
            if(regs[i].get_rights() == "RW") begin
                reg_name = regs[i].get_name();
                if(reg_name.substr(0,4) == "S_LUT") begin
`ifdef NVDLA_SDP_LUT_ENABLE
                    regs[i].get_fields(flds);
                    foreach(flds[j]) begin
                        name                  = flds[j].get_name();
                        tg_sdp_lut_flds[name] = new({"tg_sdp_",name.tolower()}, flds[j].get_n_bits());
                    end
`endif
                end
                else begin
`ifndef NVDLA_SDP_BS_ENABLE
                    if(reg_name.substr(0,6) == "D_DP_BS") continue;
`endif
`ifndef NVDLA_SDP_BN_ENABLE
                    if(reg_name.substr(0,6) == "D_DP_BN") continue;
`endif
`ifndef NVDLA_SDP_BN_ENABLE
                    if(reg_name.substr(0,6) == "D_DP_EW") continue;
`endif
                    regs[i].get_fields(flds);
                    foreach(flds[j]) begin
                        name              = flds[j].get_name();
`ifndef MEM_ADDR_WIDTH_GT_32
                        if(name == "DST_BASE_ADDR_HIGH") continue;
`endif
`ifndef NVDLA_BATCH_ENABLE
                        if(name == "DST_BATCH_STRIDE") continue;
`endif
                        tg_sdp_flds[name] = new({"tg_sdp_",name.tolower()}, flds[j].get_n_bits());
                    end
                end
                flds.delete();
            end
        end
        regs.delete();
    endfunction : new

    task sdp_sample(ref ral_sys_top ral_mdl);
        `uvm_info(tID, $sformatf("SDP Sample Begin ..."), UVM_LOW)
        sdp_toggle_sample(ral_mdl);
        sdp_cg.sample(ral_mdl);
    endtask : sdp_sample

`ifdef NVDLA_SDP_LUT_ENABLE
    task sdp_lut_sample(ref ral_sys_top ral_mdl);
        `uvm_info(tID, $sformatf("SDP LUT Sample Begin ..."), UVM_LOW)
        sdp_lut_toggle_sample(ral_mdl);
        sdp_lut_cg.sample(ral_mdl);
    endtask : sdp_lut_sample
`endif

    task sdp_rdma_sample(ref ral_sys_top ral_mdl);
        `uvm_info(tID, $sformatf("SDP_RDMA Sample Begin ..."), UVM_LOW)
        sdp_rdma_toggle_sample(ral_mdl);
        sdp_rdma_cg.sample(ral_mdl);
    endtask : sdp_rdma_sample

    function void sdp_toggle_sample(ref ral_sys_top ral_mdl);
        uvm_reg_field fld;
        foreach(tg_sdp_flds[i]) begin
            fld = ral.nvdla.NVDLA_SDP.get_field_by_name(i);
            tg_sdp_flds[i].sample(fld.value);
        end
    endfunction : sdp_toggle_sample

`ifdef NVDLA_SDP_LUT_ENABLE
    function void sdp_lut_toggle_sample(ref ral_sys_top ral_mdl);
        uvm_reg_field fld;
        foreach(tg_sdp_lut_flds[i]) begin
            fld = ral.nvdla.NVDLA_SDP.get_field_by_name(i);
            tg_sdp_lut_flds[i].sample(fld.value);
        end
    endfunction : sdp_lut_toggle_sample
`endif

    function void sdp_rdma_toggle_sample(ref ral_sys_top ral_mdl);
        uvm_reg_field fld;
        foreach(tg_sdp_rdma_flds[i]) begin
            fld = ral.nvdla.NVDLA_SDP_RDMA.get_field_by_name(i);
            tg_sdp_rdma_flds[i].sample(fld.value);
        end
    endfunction : sdp_rdma_toggle_sample

    covergroup sdp_cg with function sample(ref ral_sys_top ral_mdl);
        // ** activation input data
        // feature mode
        cp_flying_mode:              coverpoint ral_mdl.nvdla.NVDLA_SDP.D_FEATURE_MODE_CFG.FLYING_MODE.value[0] {
           bins off_fly = {0};
           bins on_fly  = {1};
        }
        cp_winograd:                 coverpoint ral_mdl.nvdla.NVDLA_SDP.D_FEATURE_MODE_CFG.WINOGRAD.value[0] {
           bins off = {0};
`ifdef NVDLA_WINOGRAD_ENABLE
           bins on  = {1};
`endif
        }
        cr_winograd_flying_mode:     cross cp_winograd, cp_flying_mode {
            ignore_bins off_fly = binsof(cp_flying_mode)intersect{0};
        }
        cp_batch_number:             coverpoint ral_mdl.nvdla.NVDLA_SDP.D_FEATURE_MODE_CFG.BATCH_NUMBER.value[4:0] {
            bins min    = {0};
`ifdef NVDLA_BATCH_ENABLE
            bins mid[6] = {[1:30]};
            bins max    = {31};
`endif
        }
        cr_batch_number_flying_mode: cross cp_batch_number, cp_flying_mode {
`ifdef NVDLA_BATCH_ENABLE
            ignore_bins off_fly = binsof(cp_flying_mode.off_fly) && binsof(cp_batch_number)intersect{[1:31]};
`endif
        }
        // input size
        cp_width:                    coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DATA_CUBE_WIDTH.WIDTH.value[12:0] {
            bins min = {0};
            bins mid[8] = {['h1:'h1FFE]};
            bins max = {'h1FFF};
        }
        cr_width_flying_mode:        cross cp_width, cp_flying_mode;
        cp_height:                   coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DATA_CUBE_HEIGHT.HEIGHT.value[12:0] {
            bins min = {0};
            bins mid[8] = {['h1:'h1FFE]};
            bins max = {'h1FFF};
        }
        cr_height_flying_mode:       cross cp_height, cp_flying_mode;
        cp_channel:                  coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DATA_CUBE_CHANNEL.CHANNEL.value[12:0] {
            bins min = {0};
            bins mid[8] = {['h1:'h1FFE]};
            bins max = {'h1FFF};
        }
        cr_channel_flying_mode:      cross cp_channel, cp_flying_mode;

        // output addr
        cp_output_dst:               coverpoint ral_mdl.nvdla.NVDLA_SDP.D_FEATURE_MODE_CFG.OUTPUT_DST.value[0] {
           bins mem = {0};
           bins pdp = {1};
        }
        cp_dst_ram_type:             coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DST_DMA_CFG.DST_RAM_TYPE.value[0] {
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
            bins cv = {0};
`endif
            bins mc = {1};
        }
        cr_dst_ram_type_output_dst:  cross cp_dst_ram_type, cp_output_dst {
            ignore_bins pdp = binsof(cp_output_dst.pdp);
        }
        cp_dst_base_addr_low:        coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DST_BASE_ADDR_LOW.DST_BASE_ADDR_LOW.value[31:5] {
            wildcard bins align_64  = {27'b??????????????????????????0};
            wildcard bins align_128 = {27'b?????????????????????????00};
            wildcard bins align_256 = {27'b????????????????????????000};
            bins          ful[8]    = {[0:27'h7FF_FFFF]};
        }
`ifdef MEM_ADDR_WIDTH_GT_32
        cp_dst_base_addr_high:       coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DST_BASE_ADDR_HIGH.DST_BASE_ADDR_HIGH.value[`NVDLA_MEM_ADDRESS_WIDTH-32-1:0] {
            bins ful[8]    = {[0:8'hFF]};
        }
`endif
        cr_dst_base_addr_low_dst_ram_type_output_dst:  cross cp_dst_base_addr_low, cp_dst_ram_type, cp_output_dst {
            ignore_bins pdp = binsof(cp_output_dst.pdp);
        }
`ifdef MEM_ADDR_WIDTH_GT_32
        cr_dst_base_addr_high_dst_ram_type_output_dst:  cross cp_dst_base_addr_high, cp_dst_ram_type, cp_output_dst {
            ignore_bins pdp = binsof(cp_output_dst.pdp);
        }
`endif
        cp_dst_line_stride:          coverpoint (ral_mdl.nvdla.NVDLA_SDP.D_DST_LINE_STRIDE.DST_LINE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE-ral_mdl.nvdla.NVDLA_SDP.D_DATA_CUBE_WIDTH.WIDTH.value-1) {
            bins eql     = {0};
            bins mid[7]  = {[1:7]};
            bins high[2] = {[8:16]};
        }
        cr_dst_line_stride_output_dst:                 cross cp_dst_line_stride, cp_output_dst {
            ignore_bins pdp = binsof(cp_output_dst.pdp);
        }
        cp_dst_surface_stride:       coverpoint (ral_mdl.nvdla.NVDLA_SDP.D_DST_SURFACE_STRIDE.DST_SURFACE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE - (ral_mdl.nvdla.NVDLA_SDP.D_DST_LINE_STRIDE.DST_LINE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE*(ral_mdl.nvdla.NVDLA_SDP.D_DATA_CUBE_HEIGHT.HEIGHT.value+1))) {
            bins eql     = {0};
            bins mid[7]  = {[1:7]};
            bins high[2] = {[8:16]};
        }
        cr_dst_surface_stride_output_dst:                 cross cp_dst_surface_stride, cp_output_dst {
            ignore_bins pdp = binsof(cp_output_dst.pdp);
        }
        // batch stride, only cover toggle
        // precision conversion
        cp_proc_precision:             coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DATA_FORMAT.PROC_PRECISION.value {
            bins int8  = {0};
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            bins int16 = {1};
            bins fp16  = {2};
`endif
        }
        cp_out_precision:             coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DATA_FORMAT.OUT_PRECISION.value {
            bins int8  = {0};
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            bins int16 = {1};
            bins fp16  = {2};
`endif
        }
        cr_proc_precision_out_precision:  cross cp_proc_precision, cp_out_precision {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            ignore_bins int8_fp16  = binsof(cp_proc_precision.int8)  && binsof(cp_out_precision.fp16);
            ignore_bins int16_int8 = binsof(cp_proc_precision.int16) && binsof(cp_out_precision.int8);
            ignore_bins fp16_int8  = binsof(cp_proc_precision.fp16)  && binsof(cp_out_precision.int8);
`endif
        }
        cp_cvt_offset:      coverpoint ral_mdl.nvdla.NVDLA_SDP.D_CVT_OFFSET.CVT_OFFSET.value[31:0] {
            wildcard bins pos = {32'b0???????????????????????????????};
            wildcard bins neg = {32'b1???????????????????????????????};
            bins ful[8] = {[0:32'hFFFF_FFFF]};
        }
        cr_cvt_offset_proc_precision:    cross cp_cvt_offset, cp_proc_precision {
            ignore_bins ful = binsof(cp_cvt_offset.ful);
        }
        cp_cvt_scale:      coverpoint ral_mdl.nvdla.NVDLA_SDP.D_CVT_SCALE.CVT_SCALE.value[15:0] {
            wildcard bins pos = {16'b0??????????????};
            wildcard bins neg = {16'b1??????????????};
            bins ful[8] = {[0:16'hFFFF]};
        }
        cr_cvt_scale_proc_precision:    cross cp_cvt_scale, cp_proc_precision {
            ignore_bins ful = binsof(cp_cvt_scale.ful);
        }
        // bias func
        // func bypass
`ifdef NVDLA_SDP_BS_ENABLE
        cp_bs_bypass:          coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_BS_CFG.BS_BYPASS.value {
            bins no  = {0};
            bins yes = {1};
        }
        cp_bs_alu_bypass:      coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_BS_CFG.BS_ALU_BYPASS.value {
            bins no  = {0};
            bins yes = {1};
        }
        cr_bs_alu_bypass_bs_bypass:  cross cp_bs_alu_bypass, cp_bs_bypass {
            ignore_bins bs_off = binsof(cp_bs_bypass.yes);
        }
        cp_bs_mul_bypass:      coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_BS_CFG.BS_MUL_BYPASS.value {
            bins no  = {0};
            bins yes = {1};
        }
        cr_bs_mul_bypass_bs_bypass:  cross cp_bs_mul_bypass, cp_bs_bypass {
            ignore_bins bs_off = binsof(cp_bs_bypass.yes);
        }
        cp_bs_relu_bypass:      coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_BS_CFG.BS_RELU_BYPASS.value {
            bins no  = {0};
            bins yes = {1};
        }
        cr_bs_relu_bypass_bs_bypass:  cross cp_bs_relu_bypass, cp_bs_bypass {
            ignore_bins bs_off = binsof(cp_bs_bypass.yes);
        }
        cr_bs_relu_bypass_bs_mul_bypass_bs_alu_bypass_bs_bypass: cross cp_bs_relu_bypass, cp_bs_mul_bypass, cp_bs_alu_bypass, cp_bs_bypass {
            ignore_bins bs_off = binsof(cp_bs_bypass.yes);
        }
        // bs_alu cfg
        cp_bs_alu_src:    coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_BS_ALU_CFG.BS_ALU_SRC.value {
            bins regi = {0};
            bins memo = {1};
        }
        cr_bs_alu_src_bs_alu_bypass_bs_bypass: cross cp_bs_alu_src, cp_bs_alu_bypass, cp_bs_bypass {
            ignore_bins bs_off     = binsof(cp_bs_bypass.yes);
            ignore_bins bs_alu_off = binsof(cp_bs_alu_bypass.yes);
        }
        cp_bs_alu_algo:      coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_BS_CFG.BS_ALU_ALGO.value {
            bins max = {0};
            bins min = {1};
            bins sum = {2};
        }
        cr_bs_alu_algo_bs_alu_bypass_bs_bypass: cross cp_bs_alu_algo, cp_bs_alu_bypass, cp_bs_bypass {
            ignore_bins bs_off     = binsof(cp_bs_bypass.yes);
            ignore_bins bs_alu_off = binsof(cp_bs_alu_bypass.yes);
        }
        // bs_mul cfg
        cp_bs_mul_src:    coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_BS_MUL_CFG.BS_MUL_SRC.value {
            bins regi = {0};
            bins memo = {1};
        }
        cr_bs_mul_src_bs_mul_bypass_bs_bypass: cross cp_bs_mul_src, cp_bs_mul_bypass, cp_bs_bypass {
            ignore_bins bs_off     = binsof(cp_bs_bypass.yes);
            ignore_bins bs_mul_off = binsof(cp_bs_mul_bypass.yes);
        }
        cp_bs_mul_prelu:    coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_BS_CFG.BS_MUL_PRELU.value {
            bins no  = {0};
            bins yes = {1};
        }
        cr_bs_mul_prelu_bs_mul_bypass_bs_bypass: cross cp_bs_mul_prelu, cp_bs_mul_bypass, cp_bs_bypass {
            ignore_bins bs_off     = binsof(cp_bs_bypass.yes);
            ignore_bins bs_mul_off = binsof(cp_bs_mul_bypass.yes);
        }
`endif // NVDLA_SDP_BS_ENABLE

        // batch_norm func
        // func bypass
`ifdef NVDLA_SDP_BN_ENABLE
        cp_bn_bypass:          coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_BN_CFG.BN_BYPASS.value {
            bins no  = {0};
            bins yes = {1};
        }
        cp_bn_alu_bypass:      coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_BN_CFG.BN_ALU_BYPASS.value {
            bins no  = {0};
            bins yes = {1};
        }
        cr_bn_alu_bypass_bn_bypass:  cross cp_bn_alu_bypass, cp_bn_bypass {
            ignore_bins bn_off = binsof(cp_bn_bypass.yes);
        }
        cp_bn_mul_bypass:      coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_BN_CFG.BN_MUL_BYPASS.value {
            bins no  = {0};
            bins yes = {1};
        }
        cr_bn_mul_bypass_bn_bypass:  cross cp_bn_mul_bypass, cp_bn_bypass {
            ignore_bins bn_off = binsof(cp_bn_bypass.yes);
        }
        cp_bn_relu_bypass:      coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_BN_CFG.BN_RELU_BYPASS.value {
            bins no  = {0};
            bins yes = {1};
        }
        cr_bn_relu_bypass_bn_bypass:  cross cp_bn_relu_bypass, cp_bn_bypass {
            ignore_bins bn_off = binsof(cp_bn_bypass.yes);
        }
        cr_bn_relu_bypass_bn_mul_bypass_bn_alu_bypass_bn_bypass: cross cp_bn_relu_bypass, cp_bn_mul_bypass, cp_bn_alu_bypass, cp_bn_bypass {
            ignore_bins bn_off = binsof(cp_bn_bypass.yes);
        }
        // bn_alu cfg
        cp_bn_alu_src:    coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_BN_ALU_CFG.BN_ALU_SRC.value {
            bins regi = {0};
            bins memo = {1};
        }
        cr_bn_alu_src_bn_alu_bypass_bn_bypass: cross cp_bn_alu_src, cp_bn_alu_bypass, cp_bn_bypass {
            ignore_bins bn_off     = binsof(cp_bn_bypass.yes);
            ignore_bins bn_alu_off = binsof(cp_bn_alu_bypass.yes);
        }
        cp_bn_alu_algo:      coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_BN_CFG.BN_ALU_ALGO.value {
            bins max = {0};
            bins min = {1};
            bins sum = {2};
        }
        cr_bn_alu_algo_bn_alu_bypass_bn_bypass: cross cp_bn_alu_algo, cp_bn_alu_bypass, cp_bn_bypass {
            ignore_bins bn_off     = binsof(cp_bn_bypass.yes);
            ignore_bins bn_alu_off = binsof(cp_bn_alu_bypass.yes);
        }
        // bn_mul cfg
        cp_bn_mul_src:    coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_BN_MUL_CFG.BN_MUL_SRC.value {
            bins regi = {0};
            bins memo = {1};
        }
        cr_bn_mul_src_bn_mul_bypass_bn_bypass: cross cp_bn_mul_src, cp_bn_mul_bypass, cp_bn_bypass {
            ignore_bins bn_off     = binsof(cp_bn_bypass.yes);
            ignore_bins bn_mul_off = binsof(cp_bn_mul_bypass.yes);
        }
        cp_bn_mul_prelu:    coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_BN_CFG.BN_MUL_PRELU.value {
            bins no  = {0};
            bins yes = {1};
        }
        cr_bn_mul_prelu_bn_mul_bypass_bn_bypass: cross cp_bn_mul_prelu, cp_bn_mul_bypass, cp_bn_bypass {
            ignore_bins bn_off     = binsof(cp_bn_bypass.yes);
            ignore_bins bn_mul_off = binsof(cp_bn_mul_bypass.yes);
        }
`endif // NVDLA_SDP_BN_ENABLE

        // element_wise func
        // func bypass
`ifdef NVDLA_SDP_EW_ENABLE
        cp_ew_bypass:          coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_EW_CFG.EW_BYPASS.value {
            bins no  = {0};
            bins yes = {1};
        }
        cp_ew_alu_bypass:      coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_EW_CFG.EW_ALU_BYPASS.value {
            bins no  = {0};
            bins yes = {1};
        }
        cr_ew_alu_bypass_ew_bypass:  cross cp_ew_alu_bypass, cp_ew_bypass {
            ignore_bins ew_off = binsof(cp_ew_bypass.yes);
        }
        cp_ew_mul_bypass:      coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_EW_CFG.EW_MUL_BYPASS.value {
            bins no  = {0};
            bins yes = {1};
        }
        cr_ew_mul_bypass_ew_bypass:  cross cp_ew_mul_bypass, cp_ew_bypass {
            ignore_bins ew_off = binsof(cp_ew_bypass.yes);
        }
        //cp_ew_relu_bypass:      coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_EW_CFG.EW_RELU_BYPASS.value {
        //    bins no  = {0};
        //    bins yes = {1};
        //}
        //cr_ew_relu_bypass_ew_bypass:  cross cp_ew_relu_bypass, cp_ew_bypass {
        //    ignore_bins ew_off = binsof(cp_ew_bypass.yes);
        //}
        //cr_ew_relu_bypass_ew_mul_bypass_ew_alu_bypass_ew_bypass: cross cp_ew_relu_bypass, cp_ew_mul_bypass, cp_ew_alu_bypass, cp_ew_bypass {
        //    ignore_bins ew_off = binsof(cp_ew_bypass.yes);
        //}
        // ew_alu cfg
        cp_ew_alu_src:    coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_EW_ALU_CFG.EW_ALU_SRC.value {
            bins regi = {0};
            bins memo = {1};
        }
        cr_ew_alu_src_ew_alu_bypass_ew_bypass: cross cp_ew_alu_src, cp_ew_alu_bypass, cp_ew_bypass {
            ignore_bins ew_off     = binsof(cp_ew_bypass.yes);
            ignore_bins ew_alu_off = binsof(cp_ew_alu_bypass.yes);
        }
        //ew_alu_cvt
        cp_ew_alu_cvt_bypass:      coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_EW_ALU_CFG.EW_ALU_CVT_BYPASS.value {
            bins no  = {0};
            bins yes = {1};
        }
        cr_ew_alu_cvt_bypass_ew_alu_bypass_ew_bypass: cross cp_ew_alu_cvt_bypass, cp_ew_alu_bypass, cp_ew_bypass {
            ignore_bins ew_off     = binsof(cp_ew_bypass.yes);
            ignore_bins ew_alu_off = binsof(cp_ew_alu_bypass.yes);
        }
        cp_ew_alu_cvt_offset:      coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_EW_ALU_CVT_OFFSET_VALUE.EW_ALU_CVT_OFFSET.value {
            wildcard bins pos = {32'b0???????????????????????????????};
            wildcard bins neg = {32'b1???????????????????????????????};
            bins ful[8] = {[0:32'hFFFF_FFFF]};
        }
        cr_ew_alu_cvt_offset_proc_precision_ew_alu_cvt_bypass_ew_alu_bypass_ew_bypass:    cross cp_ew_alu_cvt_offset, cp_proc_precision, cp_ew_alu_cvt_bypass, cp_ew_alu_bypass, cp_ew_bypass {
            ignore_bins ful = binsof(cp_ew_alu_cvt_offset.ful);
            ignore_bins ew_off     = binsof(cp_ew_bypass.yes);
            ignore_bins ew_alu_off = binsof(cp_ew_alu_bypass.yes);
            ignore_bins ew_alu_cvt_off = binsof(cp_ew_alu_cvt_bypass.yes);
        }
        cp_ew_alu_cvt_scale:      coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_EW_ALU_CVT_SCALE_VALUE.EW_ALU_CVT_SCALE.value {
            wildcard bins pos = {16'b0???????????????};
            wildcard bins neg = {16'b1???????????????};
            bins ful[8] = {[0:16'hFFFF]};
        }
        cr_ew_alu_cvt_scale_proc_precision_ew_alu_cvt_bypass_ew_alu_bypass_ew_bypass:    cross cp_ew_alu_cvt_scale, cp_proc_precision, cp_ew_alu_cvt_bypass, cp_ew_alu_bypass, cp_ew_bypass {
            ignore_bins ful = binsof(cp_ew_alu_cvt_scale.ful);
            ignore_bins ew_off     = binsof(cp_ew_bypass.yes);
            ignore_bins ew_alu_off = binsof(cp_ew_alu_bypass.yes);
            ignore_bins ew_alu_cvt_off = binsof(cp_ew_alu_cvt_bypass.yes);
        }
        cp_ew_alu_algo:      coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_EW_CFG.EW_ALU_ALGO.value {
            bins max = {0};
            bins min = {1};
            bins sum = {2};
        }
        cr_ew_alu_algo_ew_alu_bypass_ew_bypass: cross cp_ew_alu_algo, cp_ew_alu_bypass, cp_ew_bypass {
            ignore_bins ew_off     = binsof(cp_ew_bypass.yes);
            ignore_bins ew_alu_off = binsof(cp_ew_alu_bypass.yes);
        }
        // ew_mul cfg
        cp_ew_mul_src:    coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_EW_MUL_CFG.EW_MUL_SRC.value {
            bins regi = {0};
            bins memo = {1};
        }
        cr_ew_mul_src_ew_mul_bypass_ew_bypass: cross cp_ew_mul_src, cp_ew_mul_bypass, cp_ew_bypass {
            ignore_bins ew_off     = binsof(cp_ew_bypass.yes);
            ignore_bins ew_mul_off = binsof(cp_ew_mul_bypass.yes);
        }
        cp_ew_mul_prelu:    coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_EW_CFG.EW_MUL_PRELU.value {
            bins no  = {0};
            bins yes = {1};
        }
        cr_ew_mul_prelu_ew_mul_bypass_ew_bypass: cross cp_ew_mul_prelu, cp_ew_mul_bypass, cp_ew_bypass {
            ignore_bins ew_off     = binsof(cp_ew_bypass.yes);
            ignore_bins ew_mul_off = binsof(cp_ew_mul_bypass.yes);
        }
        //ew_mul_cvt
        cp_ew_mul_cvt_bypass:      coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_EW_MUL_CFG.EW_MUL_CVT_BYPASS.value {
            bins no  = {0};
            bins yes = {1};
        }
        cr_ew_mul_cvt_bypass_ew_mul_bypass_ew_bypass: cross cp_ew_mul_cvt_bypass, cp_ew_mul_bypass, cp_ew_bypass {
            ignore_bins ew_off     = binsof(cp_ew_bypass.yes);
            ignore_bins ew_mul_off = binsof(cp_ew_mul_bypass.yes);
        }
        cp_ew_mul_cvt_offset:      coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_EW_MUL_CVT_OFFSET_VALUE.EW_MUL_CVT_OFFSET.value {
            wildcard bins pos = {32'b0???????????????????????????????};
            wildcard bins neg = {32'b1???????????????????????????????};
            bins ful[8] = {[0:32'hFFFF_FFFF]};
        }
        cr_ew_mul_cvt_offset_proc_precision_ew_mul_cvt_bypass_ew_mul_bypass_ew_bypass:    cross cp_ew_mul_cvt_offset, cp_proc_precision, cp_ew_mul_cvt_bypass, cp_ew_mul_bypass, cp_ew_bypass {
            ignore_bins ful = binsof(cp_ew_mul_cvt_offset.ful);
            ignore_bins ew_off     = binsof(cp_ew_bypass.yes);
            ignore_bins ew_mul_off = binsof(cp_ew_mul_bypass.yes);
            ignore_bins ew_mul_cvt_off = binsof(cp_ew_mul_cvt_bypass.yes);
        }
        cp_ew_mul_cvt_scale:      coverpoint ral_mdl.nvdla.NVDLA_SDP.D_DP_EW_MUL_CVT_SCALE_VALUE.EW_MUL_CVT_SCALE.value {
            wildcard bins pos = {16'b0???????????????};
            wildcard bins neg = {16'b1???????????????};
            bins ful[8] = {[0:16'hFFFF]};
        }
        cr_ew_mul_cvt_scale_proc_precision_ew_mul_cvt_bypass_ew_mul_bypass_ew_bypass:    cross cp_ew_mul_cvt_scale, cp_proc_precision, cp_ew_mul_cvt_bypass, cp_ew_mul_bypass, cp_ew_bypass {
            ignore_bins ful = binsof(cp_ew_mul_cvt_scale.ful);
            ignore_bins ew_off     = binsof(cp_ew_bypass.yes);
            ignore_bins ew_mul_off = binsof(cp_ew_mul_bypass.yes);
            ignore_bins ew_mul_cvt_off = binsof(cp_ew_mul_cvt_bypass.yes);
        }
`endif // NVDLA_SDP_EW_ENABLE
    endgroup : sdp_cg

`ifdef NVDLA_SDP_LUT_ENABLE
    covergroup sdp_lut_cg with function sample(ref ral_sys_top ral_mdl);
        cp_lut_table_id:        coverpoint ral_mdl.nvdla.NVDLA_SDP.S_LUT_ACCESS_CFG.LUT_TABLE_ID.value {
            bins le = {0};
            bins lo = {1};
        }
        cp_lut_access_type:     coverpoint ral_mdl.nvdla.NVDLA_SDP.S_LUT_ACCESS_CFG.LUT_ACCESS_TYPE.value {
            bins read  = {0};
            bins write = {1};
        }
        cp_lut_le_function:     coverpoint ral_mdl.nvdla.NVDLA_SDP.S_LUT_CFG.LUT_LE_FUNCTION.value {
            bins exponent = {0};
            bins linear   = {1};
        }
        cr_lut_table_id_lut_le_function: cross cp_lut_table_id, cp_lut_le_function {
            ignore_bins lo = binsof(cp_lut_table_id.lo);
        }
        cp_lut_le_index_offset:     coverpoint signed'(ral_mdl.nvdla.NVDLA_SDP.S_LUT_INFO.LUT_LE_INDEX_OFFSET.value[7:0]) {
`ifdef NVDLA_FEATURE_DATA_TYPE_FP16
            bins range[8] = {[-126:127]};
`else
            bins range[8] = {[-64:31]};
`endif
        }
        cr_lut_table_id_lut_le_function_lut_le_index_offset: cross cp_lut_table_id, cp_lut_le_function, cp_lut_le_index_offset {
            ignore_bins lo     = binsof(cp_lut_table_id.lo);
            ignore_bins linear = binsof(cp_lut_le_function.linear);
        }
        cp_lut_le_index_select:     coverpoint signed'(ral_mdl.nvdla.NVDLA_SDP.S_LUT_INFO.LUT_LE_INDEX_SELECT.value[7:0]) {
`ifdef NVDLA_FEATURE_DATA_TYPE_FP16
            bins range[8] = {[$:121]};
`else
            bins range[8] = {[-6:25]};
`endif
        }
        cr_lut_table_id_lut_le_function_lut_le_index_select: cross cp_lut_table_id, cp_lut_le_function, cp_lut_le_index_select {
            ignore_bins lo       = binsof(cp_lut_table_id.lo);
            ignore_bins exponent = binsof(cp_lut_le_function.exponent);
        }
        cp_lut_lo_index_select:     coverpoint signed'(ral_mdl.nvdla.NVDLA_SDP.S_LUT_INFO.LUT_LO_INDEX_SELECT.value[7:0]) {
`ifdef NVDLA_FEATURE_DATA_TYPE_FP16
            bins range[8] = {[$:119]};
`else
            bins range[8] = {[-8:23]};
`endif
        }
        cr_lut_table_id_lut_le_function_lut_lo_index_select: cross cp_lut_table_id, cp_lut_le_function, cp_lut_lo_index_select {
            ignore_bins le       = binsof(cp_lut_table_id.le);
            ignore_bins exponent = binsof(cp_lut_le_function.exponent);
        }
        cp_lut_uflow_priority:      coverpoint ral_mdl.nvdla.NVDLA_SDP.S_LUT_CFG.LUT_UFLOW_PRIORITY.value {
            bins le = {0};
            bins lo = {1};
        }
        cp_lut_oflow_priority:      coverpoint ral_mdl.nvdla.NVDLA_SDP.S_LUT_CFG.LUT_OFLOW_PRIORITY.value {
            bins le = {0};
            bins lo = {1};
        }
        cp_lut_hybrid_priority:      coverpoint ral_mdl.nvdla.NVDLA_SDP.S_LUT_CFG.LUT_OFLOW_PRIORITY.value {
            bins le = {0};
            bins lo = {1};
        }

    endgroup : sdp_lut_cg
`endif

    covergroup sdp_rdma_cg with function sample(ref ral_sys_top ral_mdl);
        // feature mode
        cp_flying_mode:              coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_FEATURE_MODE_CFG.FLYING_MODE.value[0] {
           bins off_fly = {0};
           bins on_fly  = {1};
        }
        cp_winograd:                 coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_FEATURE_MODE_CFG.WINOGRAD.value[0] {
           bins off = {0};
`ifdef NVDLA_WINOGRAD_ENABLE
           bins on  = {1};
`endif
        }
        cr_winograd_flying_mode:     cross cp_winograd, cp_flying_mode {
            ignore_bins off_fly = binsof(cp_flying_mode)intersect{0};
        }
        cp_batch_number:             coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_FEATURE_MODE_CFG.BATCH_NUMBER.value[4:0] {
            bins min    = {0};
`ifdef NVDLA_BATCH_ENABLE
            bins mid[6] = {[1:30]};
            bins max    = {31};
`endif
        }
        cr_batch_number_flying_mode: cross cp_batch_number, cp_flying_mode {
`ifdef NVDLA_BATCH_ENABLE
            ignore_bins off_fly = binsof(cp_flying_mode.off_fly) && binsof(cp_batch_number)intersect{[1:31]};
`endif
        }
        // input size
        cp_width:                    coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.value[12:0] {
            bins min = {0};
            bins mid[8] = {['h1:'h1FFE]};
            bins max = {'h1FFF};
        }
        cr_width_flying_mode:        cross cp_width, cp_flying_mode;
        cp_height:                   coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_DATA_CUBE_HEIGHT.HEIGHT.value[12:0] {
            bins min = {0};
            bins mid[8] = {['h1:'h1FFE]};
            bins max = {'h1FFF};
        }
        cr_height_flying_mode:       cross cp_height, cp_flying_mode;
        cp_channel:                  coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_DATA_CUBE_CHANNEL.CHANNEL.value[12:0] {
            bins min = {0};
            bins mid[8] = {['h1:'h1FFE]};
            bins max = {'h1FFF};
        }
        cr_channel_flying_mode:      cross cp_channel, cp_flying_mode;

        // input addr
        cp_src_ram_type:             coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_SRC_DMA_CFG.SRC_RAM_TYPE.value[0] {
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
            bins cv = {0};
`endif
            bins mc = {1};
        }
        cr_src_ram_rype_flying_mode: cross cp_src_ram_type, cp_flying_mode {
            ignore_bins on_fly = binsof(cp_flying_mode.on_fly);
        }

        cp_src_base_addr_low:        coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_SRC_BASE_ADDR_LOW.SRC_BASE_ADDR_LOW.value[31:5] {
            wildcard bins align_64  = {27'b??????????????????????????0};
            wildcard bins align_128 = {27'b?????????????????????????00};
            wildcard bins align_256 = {27'b????????????????????????000};
            bins          ful[8]    = {[0:27'h7FF_FFFF]};
        }
`ifdef MEM_ADDR_WIDTH_GT_32
        cp_src_base_addr_high:       coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_SRC_BASE_ADDR_HIGH.SRC_BASE_ADDR_HIGH.value[`NVDLA_MEM_ADDRESS_WIDTH-32-1:0] {
            bins ful[8]    = {[0:8'hFF]};
        }
`endif
        cr_src_base_addr_low_src_ram_type_flying_mode:  cross cp_src_base_addr_low, cp_src_ram_type, cp_flying_mode {
            ignore_bins on_fly = binsof(cp_flying_mode.on_fly);
        }
`ifdef MEM_ADDR_WIDTH_GT_32
        cr_src_base_addr_high_src_ram_type_flying_mode: cross cp_src_base_addr_high, cp_src_ram_type, cp_flying_mode {
            ignore_bins on_fly = binsof(cp_flying_mode.on_fly);
        }
`endif
        cp_src_line_stride:          coverpoint (ral_mdl.nvdla.NVDLA_SDP_RDMA.D_SRC_LINE_STRIDE.SRC_LINE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE - ral_mdl.nvdla.NVDLA_SDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.value-1) {
            bins eql     = {0};
            bins mid[7]  = {[1:7]};
            bins high[2] = {[8:16]};
        }
        cr_src_line_stride_flying_mode:                 cross cp_src_line_stride, cp_flying_mode {
            ignore_bins on_fly = binsof(cp_flying_mode.on_fly);
        }
        cp_src_surface_stride:       coverpoint (ral_mdl.nvdla.NVDLA_SDP_RDMA.D_SRC_SURFACE_STRIDE.SRC_SURFACE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE - (ral_mdl.nvdla.NVDLA_SDP_RDMA.D_SRC_LINE_STRIDE.SRC_LINE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE*(ral_mdl.nvdla.NVDLA_SDP_RDMA.D_DATA_CUBE_HEIGHT.HEIGHT.value+1))) {
            bins eql     = {0};
            bins mid[7]  = {[1:7]};
            bins high[2] = {[8:16]};
        }
        cr_src_surface_stride_flying_mode:              cross cp_src_surface_stride, cp_flying_mode {
            ignore_bins on_fly = binsof(cp_flying_mode.on_fly);
        }
        // output addr
        // precision conversion
        cp_in_precision:             coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_FEATURE_MODE_CFG.IN_PRECISION.value {
            bins int8  = {0};
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            bins int16 = {1};
            bins fp16  = {2};
`endif
        }
        cp_proc_precision:             coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_FEATURE_MODE_CFG.PROC_PRECISION.value {
            bins int8  = {0};
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            bins int16 = {1};
            bins fp16  = {2};
`endif
        }
        cr_in_precision_proc_precision:  cross cp_in_precision, cp_proc_precision {
            bins int8_int8   = binsof(cp_in_precision.int8)  && binsof(cp_proc_precision.int8);
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            bins int16_int8  = binsof(cp_in_precision.int16) && binsof(cp_proc_precision.int8);
            bins int16_int16 = binsof(cp_in_precision.int16) && binsof(cp_proc_precision.int16);
            bins fp16_fp16   = binsof(cp_in_precision.fp16)  && binsof(cp_proc_precision.fp16);
`endif

            ignore_bins ignore_int8 = binsof(cp_in_precision.int8) && !binsof(cp_proc_precision.int8);
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            ignore_bins ignore_int16 = binsof(cp_in_precision.int16) && binsof(cp_proc_precision.fp16);
            ignore_bins ingore_fp16 = binsof(cp_in_precision.fp16) && !binsof(cp_proc_precision.fp16);
`endif
        }
        // brdma_cfg
`ifdef NVDLA_SDP_BS_ENABLE
        cp_brdma_disable:         coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_BRDMA_CFG.BRDMA_DISABLE.value {
            bins no  = {0};
            bins yes = {1};
        }
        cp_brdma_data_use:        coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_BRDMA_CFG.BRDMA_DATA_USE.value {
            bins mul  = {0};
            bins alu  = {1};
            bins both = {2};
        }
        cr_brdma_data_use_brdma_disable:    cross cp_brdma_data_use, cp_brdma_disable {
            ignore_bins brdma_off = binsof(cp_brdma_disable.yes);
        }
        cp_brdma_ram_type:        coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_BRDMA_CFG.BRDMA_RAM_TYPE.value {
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
            bins cv = {0};
`endif
            bins mc  = {1};
        }
        cr_brdma_ram_type_brdma_disable:    cross cp_brdma_ram_type, cp_brdma_disable {
            ignore_bins brdma_off = binsof(cp_brdma_disable.yes);
        }
        cp_brdma_data_size:        coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_BRDMA_CFG.BRDMA_DATA_SIZE.value {
            bins one_byte  = {0};
            bins two_byte  = {1};
        }
        cr_brdma_data_size_brdma_disable:    cross cp_brdma_data_size, cp_brdma_disable {
            ignore_bins brdma_off = binsof(cp_brdma_disable.yes);
        }
        cp_brdma_data_mode:        coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_BRDMA_CFG.BRDMA_DATA_MODE.value {
            bins per_kernel   = {0};
            bins per_element  = {1};
        }
        cr_brdma_data_mode_brdma_disable:    cross cp_brdma_data_mode, cp_brdma_disable {
            ignore_bins brdma_off = binsof(cp_brdma_disable.yes);
        }
        // addr
        cp_bs_base_addr_low:        coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_BS_BASE_ADDR_LOW.BS_BASE_ADDR_LOW.value[31:5] {
            wildcard bins align_64  = {27'b??????????????????????????0};
            wildcard bins align_128 = {27'b?????????????????????????00};
            wildcard bins align_256 = {27'b????????????????????????000};
            bins          ful[8]    = {[0:27'h7FF_FFFF]};
        }
`ifdef MEM_ADDR_WIDTH_GT_32
        cp_bs_base_addr_high:       coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_BS_BASE_ADDR_HIGH.BS_BASE_ADDR_HIGH.value[`NVDLA_MEM_ADDRESS_WIDTH-32-1:0] {
            bins ful[8]    = {[0:8'hFF]};
        }
`endif
        cr_bs_base_addr_low_brdma_ram_type_brdma_disable:   cross cp_bs_base_addr_low, cp_brdma_ram_type, cp_brdma_disable {
            ignore_bins brdma_off = binsof(cp_brdma_disable.yes);
        }
`ifdef MEM_ADDR_WIDTH_GT_32
        cr_bs_base_addr_high_brdma_ram_type_brdma_disable:   cross cp_bs_base_addr_high, cp_brdma_ram_type, cp_brdma_disable {
            ignore_bins brdma_off = binsof(cp_brdma_disable.yes);
        }
`endif
        cp_bs_line_stride_1:          coverpoint (ral_mdl.nvdla.NVDLA_SDP_RDMA.D_BS_LINE_STRIDE.BS_LINE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE-ral_mdl.nvdla.NVDLA_SDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.value-1) {
            bins eql     = {0};
            bins mid[7]  = {[1:7]};
            bins high[2] = {[8:16]};
        }
        cr_cp_bs_line_stride_1_brdma_data_mode_brdma_disable: cross cp_bs_line_stride_1, cp_brdma_data_mode, cp_brdma_disable {
            ignore_bins brdma_off  = binsof(cp_brdma_disable.yes);
            ignore_bins per_kernel = binsof(cp_brdma_data_mode.per_kernel);
        }
        cp_bs_line_stride_2:          coverpoint (ral_mdl.nvdla.NVDLA_SDP_RDMA.D_BS_LINE_STRIDE.BS_LINE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE-2*(ral_mdl.nvdla.NVDLA_SDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.value+1)) {
            bins eql     = {0};
            bins mid[7]  = {[1:7]};
            bins high[2] = {[8:16]};
        }
        cr_cp_bs_line_stride_2_brdma_data_mode_brdma_disable: cross cp_bs_line_stride_2, cp_brdma_data_mode, cp_brdma_disable {
            ignore_bins brdma_off  = binsof(cp_brdma_disable.yes);
            ignore_bins per_kernel = binsof(cp_brdma_data_mode.per_kernel);
        }
        cp_bs_line_stride_4:          coverpoint (ral_mdl.nvdla.NVDLA_SDP_RDMA.D_BS_LINE_STRIDE.BS_LINE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE-4*(ral_mdl.nvdla.NVDLA_SDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.value+1)) {
            bins eql     = {0};
            bins mid[7]  = {[1:7]};
            bins high[2] = {[8:16]};
        }
        cr_bs_line_stride_4_brdma_data_mode_brdma_disable: cross cp_bs_line_stride_4, cp_brdma_data_mode, cp_brdma_disable {
            ignore_bins brdma_off  = binsof(cp_brdma_disable.yes);
            ignore_bins per_kernel = binsof(cp_brdma_data_mode.per_kernel);
        }
        cp_bs_surface_stride:       coverpoint (ral_mdl.nvdla.NVDLA_SDP_RDMA.D_BS_SURFACE_STRIDE.BS_SURFACE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE - (ral_mdl.nvdla.NVDLA_SDP_RDMA.D_BS_LINE_STRIDE.BS_LINE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE*(ral_mdl.nvdla.NVDLA_SDP_RDMA.D_DATA_CUBE_HEIGHT.HEIGHT.value+1))) {
            bins eql     = {0};
            bins mid[7]  = {[1:7]};
            bins high[2] = {[8:16]};
        }
        cr_bs_surface_stride_brdma_data_mode_brdma_disable: cross cp_bs_surface_stride, cp_brdma_data_mode, cp_brdma_disable {
            ignore_bins brdma_off  = binsof(cp_brdma_disable.yes);
            ignore_bins per_kernel = binsof(cp_brdma_data_mode.per_kernel);
        }
`endif // NVDLA_SDP_BS_ENABLE

`ifdef NVDLA_SDP_BN_ENABLE
        // nrdma_cfg
        cp_nrdma_disable:         coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_NRDMA_CFG.NRDMA_DISABLE.value {
            bins no  = {0};
            bins yes = {1};
        }
        cp_nrdma_data_use:        coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_NRDMA_CFG.NRDMA_DATA_USE.value {
            bins mul  = {0};
            bins alu  = {1};
            bins both = {2};
        }
        cr_nrdma_data_use_nrdma_disable:    cross cp_nrdma_data_use, cp_nrdma_disable {
            ignore_bins nrdma_off = binsof(cp_nrdma_disable.yes);
        }
        cp_nrdma_ram_type:        coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_NRDMA_CFG.NRDMA_RAM_TYPE.value {
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
            bins cv = {0};
`endif
            bins mc  = {1};
        }
        cr_nrdma_ram_type_nrdma_disable:    cross cp_nrdma_ram_type, cp_nrdma_disable {
            ignore_bins nrdma_off = binsof(cp_nrdma_disable.yes);
        }
        cp_nrdma_data_size:        coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_NRDMA_CFG.NRDMA_DATA_SIZE.value {
            bins one_byte  = {0};
            bins two_byte  = {1};
        }
        cr_nrdma_data_size_nrdma_disable:    cross cp_nrdma_data_size, cp_nrdma_disable {
            ignore_bins nrdma_off = binsof(cp_nrdma_disable.yes);
        }
        cp_nrdma_data_mode:        coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_NRDMA_CFG.NRDMA_DATA_MODE.value {
            bins per_kernel   = {0};
            bins per_element  = {1};
        }
        cr_nrdma_data_mode_nrdma_disable:    cross cp_nrdma_data_mode, cp_nrdma_disable {
            ignore_bins nrdma_off = binsof(cp_nrdma_disable.yes);
        }
        // addr
        cp_bn_base_addr_low:        coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_BN_BASE_ADDR_LOW.BN_BASE_ADDR_LOW.value[31:5] {
            wildcard bins align_64  = {27'b??????????????????????????0};
            wildcard bins align_128 = {27'b?????????????????????????00};
            wildcard bins align_256 = {27'b????????????????????????000};
            bins          ful[8]    = {[0:27'h7FF_FFFF]};
        }
`ifdef MEM_ADDR_WIDTH_GT_32
        cp_bn_base_addr_high:       coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_BN_BASE_ADDR_HIGH.BN_BASE_ADDR_HIGH.value[`NVDLA_MEM_ADDRESS_WIDTH-32-1:0] {
            bins ful[8]    = {[0:8'hFF]};
        }
`endif
        cr_bn_base_addr_low_nrdma_ram_type_nrdma_disable:   cross cp_bn_base_addr_low, cp_nrdma_ram_type, cp_nrdma_disable {
            ignore_bins nrdma_off = binsof(cp_nrdma_disable.yes);
        }
`ifdef MEM_ADDR_WIDTH_GT_32
        cr_bn_base_addr_high_nrdma_ram_type_nrdma_disable:   cross cp_bn_base_addr_high, cp_nrdma_ram_type, cp_nrdma_disable {
            ignore_bins nrdma_off = binsof(cp_nrdma_disable.yes);
        }
`endif
        cp_bn_line_stride_1:          coverpoint (ral_mdl.nvdla.NVDLA_SDP_RDMA.D_BN_LINE_STRIDE.BN_LINE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE-ral_mdl.nvdla.NVDLA_SDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.value-1) {
            bins eql     = {0};
            bins mid[7]  = {[1:7]};
            bins high[2] = {[8:16]};
        }
        cr_cp_bn_line_stride_1_nrdma_data_mode_nrdma_disable: cross cp_bn_line_stride_1, cp_nrdma_data_mode, cp_nrdma_disable {
            ignore_bins nrdma_off  = binsof(cp_nrdma_disable.yes);
            ignore_bins per_kernel = binsof(cp_nrdma_data_mode.per_kernel);
        }
        cp_bn_line_stride_2:          coverpoint (ral_mdl.nvdla.NVDLA_SDP_RDMA.D_BN_LINE_STRIDE.BN_LINE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE-2*(ral_mdl.nvdla.NVDLA_SDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.value+1)) {
            bins eql     = {0};
            bins mid[7]  = {[1:7]};
            bins high[2] = {[8:16]};
        }
        cr_cp_ns_line_stride_2_nrdma_data_mode_nrdma_disable: cross cp_bn_line_stride_2, cp_nrdma_data_mode, cp_nrdma_disable {
            ignore_bins nrdma_off  = binsof(cp_nrdma_disable.yes);
            ignore_bins per_kernel = binsof(cp_nrdma_data_mode.per_kernel);
        }
        cp_bn_line_stride_4:          coverpoint (ral_mdl.nvdla.NVDLA_SDP_RDMA.D_BN_LINE_STRIDE.BN_LINE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE-4*(ral_mdl.nvdla.NVDLA_SDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.value+1)) {
            bins eql     = {0};
            bins mid[7]  = {[1:7]};
            bins high[2] = {[8:16]};
        }
        cr_bn_line_stride_4_nrdma_data_mode_nrdma_disable: cross cp_bn_line_stride_4, cp_nrdma_data_mode, cp_nrdma_disable {
            ignore_bins nrdma_off  = binsof(cp_nrdma_disable.yes);
            ignore_bins per_kernel = binsof(cp_nrdma_data_mode.per_kernel);
        }
        cp_bn_surface_stride:       coverpoint (ral_mdl.nvdla.NVDLA_SDP_RDMA.D_BN_SURFACE_STRIDE.BN_SURFACE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE - (ral_mdl.nvdla.NVDLA_SDP_RDMA.D_BN_LINE_STRIDE.BN_LINE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE*(ral_mdl.nvdla.NVDLA_SDP_RDMA.D_DATA_CUBE_HEIGHT.HEIGHT.value+1))) {
            bins eql     = {0};
            bins mid[7]  = {[1:7]};
            bins high[2] = {[8:16]};
        }
        cr_bn_surface_stride_nrdma_data_mode_nrdma_disable: cross cp_bn_surface_stride, cp_nrdma_data_mode, cp_nrdma_disable {
            ignore_bins nrdma_off  = binsof(cp_nrdma_disable.yes);
            ignore_bins per_kernel = binsof(cp_nrdma_data_mode.per_kernel);
        }
`endif // NVDLA_SDP_BN_ENABLE

`ifdef NVDLA_SDP_EW_ENABLE
        // erdma_cfg
        cp_erdma_disable:         coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_ERDMA_CFG.ERDMA_DISABLE.value {
            bins no  = {0};
            bins yes = {1};
        }
        cp_erdma_data_use:        coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_ERDMA_CFG.ERDMA_DATA_USE.value {
            bins mul  = {0};
            bins alu  = {1};
            bins both = {2};
        }
        cr_erdma_data_use_erdma_disable:    cross cp_erdma_data_use, cp_erdma_disable {
            ignore_bins erdma_off = binsof(cp_erdma_disable.yes);
        }
        cp_erdma_ram_type:        coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_ERDMA_CFG.ERDMA_RAM_TYPE.value {
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
            bins cv = {0};
`endif
            bins mc  = {1};
        }
        cr_erdma_ram_type_erdma_disable:    cross cp_erdma_ram_type, cp_erdma_disable {
            ignore_bins erdma_off = binsof(cp_erdma_disable.yes);
        }
        cp_erdma_data_size:        coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_ERDMA_CFG.ERDMA_DATA_SIZE.value {
            bins one_byte  = {0};
            bins two_byte  = {1};
        }
        cr_erdma_data_size_erdma_disable:    cross cp_erdma_data_size, cp_erdma_disable {
            ignore_bins erdma_off = binsof(cp_erdma_disable.yes);
        }
        cp_erdma_data_mode:        coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_ERDMA_CFG.ERDMA_DATA_MODE.value {
            bins per_kernel   = {0};
            bins per_element  = {1};
        }
        cr_erdma_data_mode_erdma_disable:    cross cp_erdma_data_mode, cp_erdma_disable {
            ignore_bins erdma_off = binsof(cp_erdma_disable.yes);
        }
        // addr
        cp_ew_base_addr_low:        coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_EW_BASE_ADDR_LOW.EW_BASE_ADDR_LOW.value[31:5] {
            wildcard bins align_64  = {27'b??????????????????????????0};
            wildcard bins align_128 = {27'b?????????????????????????00};
            wildcard bins align_256 = {27'b????????????????????????000};
            bins          ful[8]    = {[0:27'h7FF_FFFF]};
        }
`ifdef MEM_ADDR_WIDTH_GT_32
        cp_ew_base_addr_high:       coverpoint ral_mdl.nvdla.NVDLA_SDP_RDMA.D_EW_BASE_ADDR_HIGH.EW_BASE_ADDR_HIGH.value[`NVDLA_MEM_ADDRESS_WIDTH-32-1:0] {
            bins ful[8]    = {[0:8'hF]};
        }
`endif
        cr_ew_base_addr_low_erdma_ram_type_erdma_disable:   cross cp_ew_base_addr_low, cp_erdma_ram_type, cp_erdma_disable {
            ignore_bins erdma_off = binsof(cp_erdma_disable.yes);
        }
`ifdef MEM_ADDR_WIDTH_GT_32
        cr_ew_base_addr_high_erdma_ram_type_erdma_disable:   cross cp_ew_base_addr_high, cp_erdma_ram_type, cp_erdma_disable {
            ignore_bins erdma_off = binsof(cp_erdma_disable.yes);
        }
`endif
        cp_ew_line_stride_1:          coverpoint (ral_mdl.nvdla.NVDLA_SDP_RDMA.D_EW_LINE_STRIDE.EW_LINE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE-ral_mdl.nvdla.NVDLA_SDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.value-1) {
            bins eql     = {0};
            bins mid[7]  = {[1:7]};
            bins high[2] = {[8:16]};
        }
        cr_cp_ew_line_stride_1_erdma_data_mode_erdma_disable: cross cp_ew_line_stride_1, cp_erdma_data_mode, cp_erdma_disable {
            ignore_bins erdma_off  = binsof(cp_erdma_disable.yes);
            ignore_bins per_kernel = binsof(cp_erdma_data_mode.per_kernel);
        }
        cp_ew_line_stride_2:          coverpoint (ral_mdl.nvdla.NVDLA_SDP_RDMA.D_EW_LINE_STRIDE.EW_LINE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE-2*(ral_mdl.nvdla.NVDLA_SDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.value+1)) {
            bins eql     = {0};
            bins mid[7]  = {[1:7]};
            bins high[2] = {[8:16]};
        }
        cr_ew_line_stride_2_erdma_data_mode_erdma_disable: cross cp_ew_line_stride_2, cp_erdma_data_mode, cp_erdma_disable {
            ignore_bins erdma_off  = binsof(cp_erdma_disable.yes);
            ignore_bins per_kernel = binsof(cp_erdma_data_mode.per_kernel);
        }
        cp_ew_line_stride_4:          coverpoint (ral_mdl.nvdla.NVDLA_SDP_RDMA.D_EW_LINE_STRIDE.EW_LINE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE-4*(ral_mdl.nvdla.NVDLA_SDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.value+1)) {
            bins eql     = {0};
            bins mid[7]  = {[1:7]};
            bins high[2] = {[8:16]};
        }
        cr_ew_line_stride_4_erdma_data_mode_erdma_disable: cross cp_ew_line_stride_4, cp_erdma_data_mode, cp_erdma_disable {
            ignore_bins erdma_off  = binsof(cp_erdma_disable.yes);
            ignore_bins per_kernel = binsof(cp_erdma_data_mode.per_kernel);
        }
        cp_ew_surface_stride:       coverpoint (ral_mdl.nvdla.NVDLA_SDP_RDMA.D_EW_SURFACE_STRIDE.EW_SURFACE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE - (ral_mdl.nvdla.NVDLA_SDP_RDMA.D_EW_LINE_STRIDE.EW_LINE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE*(ral_mdl.nvdla.NVDLA_SDP_RDMA.D_DATA_CUBE_HEIGHT.HEIGHT.value+1))) {
            bins eql     = {0};
            bins mid[7]  = {[1:7]};
            bins high[2] = {[8:16]};
        }
        cr_ew_surface_stride_erdma_data_mode_erdma_disable: cross cp_ew_surface_stride, cp_erdma_data_mode, cp_erdma_disable {
            ignore_bins erdma_off  = binsof(cp_erdma_disable.yes);
            ignore_bins per_kernel = binsof(cp_erdma_data_mode.per_kernel);
        }
`endif // NVDLA_SDP_EW_ENABLE
    endgroup : sdp_rdma_cg

endclass : sdp_cov_pool


