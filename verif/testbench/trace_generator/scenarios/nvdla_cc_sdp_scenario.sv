`ifndef _NVDLA_CC_SDP_SCENARIO_SV_
`define _NVDLA_CC_SDP_SCENARIO_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_cc_sdp_scenario
//
// @description: scenario of CONV+SDP
//-------------------------------------------------------------------------------------

class nvdla_cc_sdp_scenario extends nvdla_base_scenario;
    string  cdma_weight_surface_pattern      = "random";
    /*
        resource
    */
    rand nvdla_cdma_resource         cdma;
    rand nvdla_cc_dp_resource        cc_dp;
    rand nvdla_sdp_resource          sdp;

    /*
        constraints:
            * ias_constraint: mandatory constraints from architecture requirement
            * sim_constraint: optional constraints for simulation only
    */
    extern constraint sce_cc_sdp_sim_constraint_for_user_extend;
    extern constraint sce_cc_sdp_ias_constraint;
    /*
        method
    */
    extern function         new(string name, uvm_component parent);
    extern function void    trace_dump(int fh);
    extern function void    surface_dump(int fh);
    extern function void    activate();
    extern function void    set_sync_evt_name();
    extern function void    set_sim_constraint();

    /*
        phase
    */
    extern function void build_phase(uvm_phase phase);

    `uvm_component_utils_begin(nvdla_cc_sdp_scenario)
        `uvm_field_string(cdma_weight_surface_pattern,  UVM_ALL_ON)
    `uvm_component_utils_end

endclass : nvdla_cc_sdp_scenario

function nvdla_cc_sdp_scenario::new(string name, uvm_component parent);
    super.new(name, parent);
    cdma  = nvdla_cdma_resource::get_cdma(this);
    cc_dp = nvdla_cc_dp_resource::get_cc_dp(this);
    sdp   = nvdla_sdp_resource::get_sdp(this);
endfunction : new

function void nvdla_cc_sdp_scenario::build_phase(uvm_phase phase);
    super.build_phase(phase);
    // cdma  = nvdla_cdma_resource::type_id::create("NVDLA_CDMA", this);
    // cc_dp = nvdla_cc_dp_resource::type_id::create("NVDLA_CC_DP", this);
    // sdp   = nvdla_sdp_resource::type_id::create("NVDLA_SDP", this);
    // cdma  = nvdla_cdma_resource::get_cdma();
    // cc_dp = nvdla_cc_dp_resource::get_cc_dp();
endfunction: build_phase

function void nvdla_cc_sdp_scenario::trace_dump(int fh);
    surface_feature_config feature_cfg;
    if(fh==null) begin
        `uvm_fatal(inst_name, "Null handle of trace file ...")
    end
    `uvm_info(inst_name, "Start trace dumping ...", UVM_HIGH)
    print_comment(fh, $sformatf("Scenario CC_SDP:%0d start",active_cnt));

    set_sync_evt_name();

    surface_dump(fh);

    // Get surface setting fro resource register
    // feature_cfg.width =
    // surface_generator.generate_memory_surface_feature(feature_cfg)
    cdma.trace_dump(fh);
    cc_dp.trace_dump(fh);
    sdp.trace_dump(fh);
    check_nothing(fh, sdp.get_sync_evt_name());
    `uvm_info(inst_name, "Finish trace dumping ...", UVM_HIGH)

    if (fcov_en) begin
        `uvm_info(inst_name, "Start to sample coverage ...", UVM_HIGH)
        cov.conv_pool.sample(ral);
`ifdef NVDLA_SDP_LUT_ENABLE
        cov.sdp_pool.sdp_lut_sample(ral);
`endif
        cov.sdp_pool.sdp_sample(ral);
    end
    print_comment(fh, $sformatf("Scenario CC_SDP:%0d end",active_cnt));
endfunction: trace_dump

function void nvdla_cc_sdp_scenario::surface_dump(int fh);
    if(nvdla_cdma_resource::weight_reuse_DISABLE == cdma.weight_reuse) begin
        surface_weight_config surface_config;
        longint unsigned      address_weight;
        longint unsigned      address_wmb;
        longint unsigned      address_wgs;
        string                mem_domain;
        // Get surface setting fro resource register
        // string weight_name; string weight_mask_name; string weight_group_size_name;
        // int unsigned width;int unsigned height;int unsigned channel;int unsigned kernel;
        // int unsigned atomic_channel=8;
        // int unsigned atomic_kernel=8;
        // int unsigned cbuf_entry_byte_size=8;
        // precision_e precision=INT8;
        // string pattern="random";
        // int unsigned comp_en;
        // int unsigned none_zero_rate;
        // int unsigned fp_enabled=0; int unsigned fp_nan_enabled=0; int unsigned fp_inf_enabled=1;
        address_weight  = {cdma.weight_addr_high, cdma.weight_addr_low};
        address_wmb     = {cdma.wmb_addr_high,    cdma.wmb_addr_low};
        address_wgs     = {cdma.wgs_addr_high,    cdma.wgs_addr_low};
        $sformat(surface_config.weight_name, "0x%0h.dat", address_weight);
        $sformat(surface_config.weight_mask_name, "0x%0h.dat", address_wmb);
        $sformat(surface_config.weight_group_size_name, "0x%0h.dat", address_wgs);
        mem_domain             = (nvdla_cdma_resource::weight_ram_type_MCIF==cdma.weight_ram_type) ? 
                                 "pri_mem":"sec_mem";
        surface_config.width   = cc_dp.weight_width_ext+1;
        surface_config.height  = cc_dp.weight_height_ext+1;
        surface_config.channel = cc_dp.weight_channel_ext+1;
        surface_config.kernel  = cc_dp.weight_kernel+1;
        surface_config.atomic_channel = `NVDLA_MAC_ATOMIC_C_SIZE;
        surface_config.atomic_kernel  = `NVDLA_MAC_ATOMIC_K_SIZE;
        surface_config.cbuf_entry_byte_size = `NVDLA_CBUF_ENTRY_WIDTH / 8;  // FIXME, NVDLA_CBUF_ENTRY_WIDTH is bit width
        surface_config.precision = precision_e'(cc_dp.proc_precision);
        surface_config.pattern = cdma_weight_surface_pattern;
        surface_config.comp_en = cc_dp.weight_format;
        surface_gen.generate_memory_surface_weight(surface_config);

        mem_load(fh, mem_domain,address_weight,surface_config.weight_name,cdma.weight_sync_evt_queue[-2]);
        mem_release(fh, mem_domain,address_weight,cdma.weight_sync_evt_queue[ 0]);
        if (surface_config.comp_en) begin
            mem_load( fh, mem_domain,address_wmb,surface_config.weight_mask_name,
                      cdma.weight_sync_evt_queue[-2]);
            mem_load( fh, mem_domain,address_wgs,surface_config.weight_group_size_name,
                      cdma.weight_sync_evt_queue[-2]);
            mem_release(fh, mem_domain,address_wmb,cdma.weight_sync_evt_queue[0]);
            mem_release(fh, mem_domain,address_wgs,cdma.weight_sync_evt_queue[0]);
        end
    end
endfunction: surface_dump

function void nvdla_cc_sdp_scenario::activate();
    active_cnt += 1;
    cdma.activate();
    cc_dp.activate();
    sdp.activate();
endfunction: activate

function void nvdla_cc_sdp_scenario::set_sync_evt_name();
    string cdma_sync_evt_name;
    string cc_dp_sync_evt_name;
    string sdp_sync_evt_name;

    sync_evt_name       = $sformatf("%s_act%0d", inst_name.tolower(), active_cnt);
    cdma_sync_evt_name  = sync_evt_name;
    cc_dp_sync_evt_name = sync_evt_name;
    sdp_sync_evt_name   = $sformatf("%s__%s_act%0d", sync_evt_name, sdp.get_resource_name(), sdp.get_active_cnt());

    /*
        set individual sync evt for each resource
    */
    cdma.set_sync_evt_name(cdma_sync_evt_name);
    cc_dp.set_sync_evt_name(cc_dp_sync_evt_name);
    sdp.set_sync_evt_name(sdp_sync_evt_name);
endfunction: set_sync_evt_name

function void nvdla_cc_sdp_scenario::set_sim_constraint();
    `uvm_info(inst_name, $sformatf("set sim constraint knobs"), UVM_MEDIUM)
    cdma.set_sim_constraint();
    cc_dp.set_sim_constraint();
    sdp.set_sim_constraint();
endfunction: set_sim_constraint

constraint nvdla_cc_sdp_scenario::sce_cc_sdp_sim_constraint_for_user_extend {
}

// FIXME cc reuse mode remains to be done
constraint nvdla_cc_sdp_scenario::sce_cc_sdp_ias_constraint {

    cdma.conv_mode          == int'(cc_dp.conv_mode);
    cdma.in_precision       == int'(cc_dp.in_precision);
    cdma.proc_precision     == int'(cc_dp.proc_precision);
    cdma.data_reuse         == int'(cc_dp.data_reuse);
    cdma.weight_reuse       == int'(cc_dp.weight_reuse);
    cdma.skip_data_rls      == int'(cc_dp.skip_data_rls);
    cdma.skip_weight_rls    == int'(cc_dp.skip_weight_rls);
    cdma.datain_format      == int'(cc_dp.datain_format);
    cdma.datain_width_ext   == cc_dp.datain_width_ext;
    cdma.datain_height_ext  == cc_dp.datain_height_ext;
    cdma.batches            == cc_dp.batches;
    cdma.entries            == cc_dp.entries;
    cdma.weight_format      == int'(cc_dp.weight_format);
    cdma.weight_kernel      == cc_dp.weight_kernel;
    cdma.weight_bytes       == cc_dp.weight_bytes;
    cdma.wmb_bytes          == cc_dp.wmb_bytes;
    cdma.pad_left           == cc_dp.pad_left;
    cdma.pad_top            == cc_dp.pad_top;
    cdma.data_bank          == cc_dp.data_bank;
    cdma.weight_bank        == cc_dp.weight_bank;
    cdma.cya                == cc_dp.cya;

    // cdma && cc_dp constraints
    // pad size
    if (cdma.conv_mode == nvdla_cdma_resource::conv_mode_DIRECT) {  // DC or Image
        // In image input mode, x_dilation_ext = y_dilation_ext = 0
        if(cdma.datain_format == nvdla_cdma_resource::datain_format_PIXEL) {
            cdma.pad_left   < ((((cc_dp.weight_channel_ext+1) / (cdma.datain_channel+1)) - 1)*(cc_dp.x_dilation_ext+1) + 1);
            cdma.pad_right  < ((((cc_dp.weight_channel_ext+1) / (cdma.datain_channel+1)) - 1)*(cc_dp.x_dilation_ext+1) + 1);
        }
        else { // feature
            cdma.pad_right  < ((cc_dp.weight_width_ext+1-1)*(cc_dp.x_dilation_ext+1) + 1);
        }
        cdma.pad_bottom < ((cc_dp.weight_height_ext+1-1)*(cc_dp.y_dilation_ext+1) + 1);
    }

    // post_extension
    if(cdma.conv_mode == nvdla_cdma_resource::conv_mode_DIRECT && cdma.datain_format == nvdla_cdma_resource::datain_format_PIXEL) {
        if(((cc_dp.weight_channel_ext+1) <= `NVDLA_MAC_ATOMIC_C_SIZE/4) && (((cdma.conv_x_stride+1)*(cdma.datain_channel+1)) <= `NVDLA_MAC_ATOMIC_C_SIZE/4)) {
            cc_dp.y_extension inside {[0:2]};
        }
        else if(((cc_dp.weight_channel_ext+1) > `NVDLA_MAC_ATOMIC_C_SIZE/2) || ((cdma.conv_x_stride+1)*(cdma.datain_channel+1) > `NVDLA_MAC_ATOMIC_C_SIZE/2)) {
            cc_dp.y_extension == 0;
        }
        else {
            cc_dp.y_extension inside {[0:1]};
        }
    }
    else { cc_dp.y_extension == 0; }

`ifdef NVDLA_WINOGRAD_ENABLE
    if (cc_dp.conv_mode == nvdla_cc_dp_resource::conv_mode_WINOGRAD) {
        (cc_dp.datain_width_ext  +1) == (cdma.pad_left + cdma.pad_right  + cdma.datain_width +1) / (cdma.conv_x_stride+1);
        (cc_dp.datain_height_ext +1) == (cdma.pad_top  + cdma.pad_bottom + cdma.datain_height+1) / (cdma.conv_y_stride+1);
        (cc_dp.datain_channel_ext+1) == (cdma.datain_channel+1) * (cdma.conv_x_stride+1) * (cdma.conv_y_stride+1);

        (cdma.pad_left + cdma.pad_right  + cdma.datain_width +1) % (cdma.conv_x_stride+1) == 0;
        (cdma.pad_top  + cdma.pad_bottom + cdma.datain_height+1) % (cdma.conv_y_stride+1) == 0;

        (cc_dp.datain_width_ext +1) % 4 == 0;
        (cc_dp.datain_height_ext+1) % 4 == 0;
        (cc_dp.datain_width_ext +1) > 4;
        (cc_dp.datain_height_ext+1) > 4;

        ((cdma.datain_channel+1) * (`NVDLA_BPE/8)) % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    }
`endif

    if (cdma.conv_mode == nvdla_cdma_resource::conv_mode_DIRECT && cdma.datain_format == nvdla_cdma_resource::datain_format_FEATURE) {
        // direct feature datain size
        (cdma.datain_width+1 +  cdma.pad_left + cdma.pad_right -  ((cc_dp.weight_width_ext+1-1) *(cc_dp.x_dilation_ext+1)+1))   >= 0;
        (cdma.datain_height+1 + cdma.pad_top +  cdma.pad_bottom - ((cc_dp.weight_height_ext+1-1)*(cc_dp.y_dilation_ext+1)+1)) >= 0;
        (cdma.datain_width+1 +  cdma.pad_left + cdma.pad_right -  ((cc_dp.weight_width_ext+1-1) *(cc_dp.x_dilation_ext+1)+1)) % (cdma.conv_x_stride+1) == 0;
        (cdma.datain_height+1 + cdma.pad_top +  cdma.pad_bottom - ((cc_dp.weight_height_ext+1-1)*(cc_dp.y_dilation_ext+1)+1)) % (cdma.conv_y_stride+1) == 0;

        cc_dp.datain_width_ext   == cdma.datain_width;
        cc_dp.datain_height_ext  == cdma.datain_height;
        cc_dp.datain_channel_ext == cdma.datain_channel;

        // direct feature dataout size
        (cc_dp.dataout_width+1)  == (cdma.datain_width+1 +  cdma.pad_left + cdma.pad_right -  ((cc_dp.weight_width_ext+1-1) *(cc_dp.x_dilation_ext+1)+1)) / (cdma.conv_x_stride+1) + 1;
        (cc_dp.dataout_height+1) == (cdma.datain_height+1 + cdma.pad_top +  cdma.pad_bottom - ((cc_dp.weight_height_ext+1-1)*(cc_dp.y_dilation_ext+1)+1)) / (cdma.conv_y_stride+1) + 1;

        // direct feature weight size
        cc_dp.weight_channel_ext == cdma.datain_channel;
    }

    if (cdma.conv_mode == nvdla_cdma_resource::conv_mode_DIRECT && cdma.datain_format == nvdla_cdma_resource::datain_format_PIXEL){
        // direct image datain size
        (cdma.datain_width+1 +  cdma.pad_left + cdma.pad_right - ((cc_dp.weight_channel_ext+1)/(cdma.datain_channel+1))) >= 0;
        (cdma.datain_height+1 + cdma.pad_top +  cdma.pad_bottom - (cc_dp.weight_height_ext+1)) >= 0;
        (cdma.datain_width+1 +  cdma.pad_left + cdma.pad_right - ((cc_dp.weight_channel_ext+1)/(cdma.datain_channel+1))) % (cdma.conv_x_stride+1) == 0;
        (cdma.datain_height+1 + cdma.pad_top +  cdma.pad_bottom - (cc_dp.weight_height_ext+1)) % (cdma.conv_y_stride+1) == 0;

        cc_dp.datain_width_ext   == cdma.datain_width;
        cc_dp.datain_height_ext  == cdma.datain_height;
        cc_dp.datain_channel_ext == cdma.datain_channel;

        // direct image dataout size
        (cc_dp.dataout_width+1)  == (cdma.datain_width+1 +  cdma.pad_left + cdma.pad_right - ((cc_dp.weight_channel_ext+1)/(cdma.datain_channel+1)))/(cdma.conv_x_stride+1) + 1;
        (cc_dp.dataout_height+1) == (cdma.datain_height+1 + cdma.pad_top +  cdma.pad_bottom - (cc_dp.weight_height_ext+1))/(cdma.conv_y_stride+1) + 1;

        // direct image weight size
        (cc_dp.weight_channel_ext+1) %   (cdma.datain_channel+1) == 0;   // Original S
        (cc_dp.weight_channel_ext+1) <= ((cdma.datain_channel+1)*(`NVDLA_MAC_ATOMIC_C_SIZE/2));  // Origianl S <= 32
    }

    //weight data
    // byte_per_kernel works both in compressed/uncompressed mode
    (cdma.byte_per_kernel+1) == (cc_dp.weight_width_ext+1)*(cc_dp.weight_height_ext+1)*(cc_dp.weight_channel_ext+1)*(`NVDLA_BPE/8);

    // conv_stride
    if(cdma.conv_mode != nvdla_cdma_resource::conv_mode_WINOGRAD) {
        cc_dp.conv_x_stride_ext == cdma.conv_x_stride;
        cc_dp.conv_y_stride_ext == cdma.conv_y_stride;
    }

    sdp.width           == cc_dp.dataout_width;
    sdp.height          == cc_dp.dataout_height;
    sdp.channel         == cc_dp.dataout_channel;
    // Receive data from Conv
    sdp.proc_precision  == int'(cc_dp.proc_precision);
    if (cc_dp.conv_mode == nvdla_cc_dp_resource::conv_mode_WINOGRAD) {
        sdp.winograd    == nvdla_sdp_resource::winograd_ON;
    } else {
        sdp.winograd    == nvdla_sdp_resource::winograd_OFF;
    }
    sdp.flying_mode     == nvdla_sdp_resource::flying_mode_ON;
    sdp.batch_number    == cc_dp.batches;
    // Destination is MEM
    sdp.output_dst      == nvdla_sdp_resource::output_dst_MEM;

`ifdef NVDLA_BATCH_ENABLE
    if(sdp.batch_number > 0) {
        sdp.dst_line_stride==cc_dp.line_stride;
        sdp.dst_surface_stride==cc_dp.surf_stride;
    }
`endif

    // This sequence doesn't use RDMA, needs to make sure here
    if(sdp.bs_bypass == nvdla_sdp_resource::bs_bypass_NO) {
        if(sdp.bs_alu_bypass == nvdla_sdp_resource::bs_alu_bypass_NO) {
            sdp.bs_alu_src == nvdla_sdp_resource::bs_alu_src_REG;
        }
        if(sdp.bs_mul_bypass == nvdla_sdp_resource::bs_mul_bypass_NO) {
            sdp.bs_mul_src == nvdla_sdp_resource::bs_mul_src_REG;
        }
    }

    if(sdp.bn_bypass == nvdla_sdp_resource::bn_bypass_NO) {
        if(sdp.bn_alu_bypass == nvdla_sdp_resource::bn_alu_bypass_NO) {
            sdp.bn_alu_src == nvdla_sdp_resource::bn_alu_src_REG;
        }
        if(sdp.bn_mul_bypass == nvdla_sdp_resource::bn_mul_bypass_NO) {
            sdp.bn_mul_src == nvdla_sdp_resource::bn_mul_src_REG;
        }
    }

    if(sdp.ew_bypass == nvdla_sdp_resource::ew_bypass_NO) {
        if(sdp.ew_alu_bypass == nvdla_sdp_resource::ew_alu_bypass_NO) {
            sdp.ew_alu_src == nvdla_sdp_resource::ew_alu_src_REG;
        }
        if(sdp.ew_mul_bypass == nvdla_sdp_resource::ew_mul_bypass_NO) {
            sdp.ew_mul_src == nvdla_sdp_resource::ew_mul_src_REG;
        }
    }
}

`endif //_NVDLA_CC_SDP_SCENARIO_SV_
