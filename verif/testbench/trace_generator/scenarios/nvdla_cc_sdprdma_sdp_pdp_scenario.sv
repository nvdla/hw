`ifndef _NVDLA_CC_SDPRDMA_SDP_PDP_SCENARIO_SV_
`define _NVDLA_CC_SDPRDMA_SDP_PDP_SCENARIO_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_cc_sdprdma_sdp_pdp_scenario
//
// @description: scenario of CONV+SDP_RDMA+SDP+PDP
//-------------------------------------------------------------------------------------

class nvdla_cc_sdprdma_sdp_pdp_scenario extends nvdla_base_scenario;
    string  cdma_weight_surface_pattern      = "random";
    /*
        resource
    */
    rand nvdla_cdma_resource      cdma;
    rand nvdla_cc_dp_resource     cc_dp;
    rand nvdla_sdp_rdma_resource  sdp_rdma;
    rand nvdla_sdp_resource       sdp;
    rand nvdla_pdp_resource       pdp;

    /*
        constraints:
            * ias_constraint: mandatory constraints from architecture requirement
            * sim_constraint: optional constraints for simulation only
    */
    extern constraint c_ias_cc;
    extern constraint c_ias_pdp;

    /*
        method
    */
    extern function         new(string name, uvm_component parent);
    extern function void    trace_dump(int fh);
    extern function void    surface_dump(int fh);
    extern function void    activate();
    extern function void    set_sync_evt_name();
    extern function void    update_sync_evt_queue();
    extern function void    set_sim_constraint();
    extern function void    pre_randomize();
    extern function void    post_randomize();

    /*
        phase
    */
    extern function void build_phase(uvm_phase phase);

    `uvm_component_utils_begin(nvdla_cc_sdprdma_sdp_pdp_scenario)
        `uvm_field_string(cdma_weight_surface_pattern,  UVM_ALL_ON)
    `uvm_component_utils_end

endclass : nvdla_cc_sdprdma_sdp_pdp_scenario

function nvdla_cc_sdprdma_sdp_pdp_scenario::new(string name, uvm_component parent);
    super.new(name, parent);
    cdma        = nvdla_cdma_resource::get_cdma(this);
    cc_dp       = nvdla_cc_dp_resource::get_cc_dp(this);
    sdp         = nvdla_sdp_resource::get_sdp(this);
    sdp_rdma    = nvdla_sdp_rdma_resource::get_sdp_rdma(this);
    pdp         = nvdla_pdp_resource::get_pdp(this);
endfunction : new

function void nvdla_cc_sdprdma_sdp_pdp_scenario::build_phase(uvm_phase phase);
    super.build_phase(phase);
    // cdma = nvdla_cdma_resource::type_id::create("NVDLA_CDMA", this);
    // cc_dp = nvdla_cc_dp_resource::type_id::create("NVDLA_CCDP", this);
    // sdp = nvdla_sdp_resource::type_id::create("NVDLA_SDP", this);
    // sdp_rdma = nvdla_sdp_rdma_resource::type_id::create("NVDLA_SDP_RDMA", this);
    // pdp = nvdla_pdp_resource::type_id::create("NVDLA_PDP", this);
    // cdma  = nvdla_cdma_resource::get_cdma();
    // cc_dp = nvdla_cc_dp_resource::get_cc_dp();
endfunction: build_phase

function void nvdla_cc_sdprdma_sdp_pdp_scenario::trace_dump(int fh);
    surface_feature_config feature_cfg;
    if(fh == null) begin
        `uvm_fatal(inst_name, "Null handle of trace file ...")
    end
    `uvm_info(inst_name, "Start trace dumping ...", UVM_HIGH)
    print_comment(fh, $sformatf("Scenario CC_SDPRDMA_SDP_PDP:%0d start",active_cnt));

    surface_dump(fh);

    set_sync_evt_name();
    cdma.trace_dump(fh);
    cc_dp.trace_dump(fh);
    sdp_rdma.trace_dump(fh);
    sdp.trace_dump(fh);
    pdp.trace_dump(fh);
    check_nothing(fh, pdp.get_sync_evt_name());
    update_sync_evt_queue();
    `uvm_info(inst_name, "Finish trace dumping ...", UVM_HIGH)

    if (fcov_en) begin
        `uvm_info(inst_name, "Start to sample coverage ...", UVM_HIGH)
        cov.conv_pool.sample();
        cov.sdp_pool.sdp_rdma_sample();
`ifdef NVDLA_SDP_EW_ENABLE
        cov.sdp_pool.sdp_lut_sample();
`endif
        cov.sdp_pool.sdp_sample();
        cov.pdp_pool.sample();
    end
    print_comment(fh, $sformatf("Scenario CC_SDPRDMA_SDP_PDP:%0d end",active_cnt));
endfunction: trace_dump

function void nvdla_cc_sdprdma_sdp_pdp_scenario::surface_dump(int fh);
    if(nvdla_cdma_resource::weight_reuse_DISABLE == cdma.weight_reuse) begin
        surface_weight_config surface_config;
        longint unsigned address_weight, address_wmb, address_wgs;
        string mem_domain="pri_mem";
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
        mem_load(fh,mem_domain,address_weight,surface_config.weight_name);
        if(surface_config.comp_en) begin
            mem_load(fh,mem_domain,address_wmb,surface_config.weight_mask_name);
            mem_load(fh,mem_domain,address_wgs,surface_config.weight_group_size_name);
        end
    end
endfunction: surface_dump

function void nvdla_cc_sdprdma_sdp_pdp_scenario::activate();
    active_cnt += 1;
    cdma.activate();
    cc_dp.activate();
    sdp_rdma.activate();
    sdp.activate();
    pdp.activate();
endfunction: activate

function void nvdla_cc_sdprdma_sdp_pdp_scenario::update_sync_evt_queue();
    cdma.update_sync_evt_queue();
    cc_dp.update_sync_evt_queue();
    sdp_rdma.update_sync_evt_queue();
    sdp.update_sync_evt_queue();
    pdp.update_sync_evt_queue();
endfunction: update_sync_evt_queue

function void nvdla_cc_sdprdma_sdp_pdp_scenario::set_sync_evt_name();
    string cdma_sync_evt_name;
    string cc_dp_sync_evt_name;
    string sdp_sync_evt_name;
    string pdp_sync_evt_name;

    sync_evt_name = {inst_name.tolower(), "_act", $sformatf("%0d",active_cnt)};
    // cdma_sync_evt_name = {sync_evt_name, "_", cdma.get_resource_name(), "_act", $sformatf("%0d", cdma.get_active_cnt())};
    // cc_dp_sync_evt_name = {sync_evt_name, "_", cc_dp.get_resource_name(), "_act", $sformatf("%0d", cc_dp.get_active_cnt())};
    cdma_sync_evt_name  = sync_evt_name;
    cc_dp_sync_evt_name = sync_evt_name;
    sdp_sync_evt_name = {sync_evt_name, "_", sdp.get_resource_name(),"_act", $sformatf("%0d",sdp.get_active_cnt()),
                         "_", sdp_rdma.get_resource_name(), "_act", $sformatf("%0d",sdp_rdma.get_active_cnt())};
    pdp_sync_evt_name = {sync_evt_name, "_",pdp.get_resource_name(),"_act",$sformatf("%0d",pdp.get_active_cnt())};

    cdma.set_sync_evt_name(cdma_sync_evt_name);
    cc_dp.set_sync_evt_name(cc_dp_sync_evt_name);
    sdp_rdma.set_sync_evt_name(sdp_sync_evt_name);
    sdp.set_sync_evt_name(sdp_sync_evt_name);
    pdp.set_sync_evt_name(pdp_sync_evt_name);
endfunction: set_sync_evt_name

function void nvdla_cc_sdprdma_sdp_pdp_scenario::set_sim_constraint();
    `uvm_info(inst_name, $sformatf("set sim constraint knobs"), UVM_MEDIUM)
    cdma.set_sim_constraint();
    cc_dp.set_sim_constraint();
    sdp.set_sim_constraint();
    pdp.set_sim_constraint();
endfunction: set_sim_constraint

function void nvdla_cc_sdprdma_sdp_pdp_scenario::pre_randomize();
    sdp.rand_mode(0);
    sdp_rdma.rand_mode(0);
    set_sim_constraint();
    // c_ias_sdp.constraint_mode(0);
    // c_ias_sdp_rdma.constraint_mode(0);
endfunction: pre_randomize

function void nvdla_cc_sdprdma_sdp_pdp_scenario::post_randomize();
    sdp.rand_mode(1);
    sdp_rdma.rand_mode(1);
    // c_ias_sdp.constraint_mode(1);
    // c_ias_sdp_rdma.constraint_mode(1);
    assert(sdp.randomize() with {
        sdp.width           == cc_dp.dataout_width;
        sdp.height          == cc_dp.dataout_height;
        sdp.channel         == cc_dp.dataout_channel;
        sdp.proc_precision  == int'(cc_dp.proc_precision);
        if (cc_dp.conv_mode == nvdla_cc_dp_resource::conv_mode_WINOGRAD) {
            sdp.winograd    == nvdla_sdp_resource::winograd_ON;
        } else {
            sdp.winograd    == nvdla_sdp_resource::winograd_OFF;
        }
        sdp.flying_mode     == nvdla_sdp_resource::flying_mode_ON;
        sdp.batch_number    == 0;
        sdp.output_dst      == nvdla_sdp_resource::output_dst_PDP;

        // Make sure at least one of B/N/E RDMA shall be enabled
        (    (   (sdp.bs_bypass == nvdla_sdp_resource::bs_bypass_NO)
             && (   (   sdp.bs_alu_bypass == nvdla_sdp_resource::bs_alu_bypass_NO
                     && sdp.bs_alu_src    == nvdla_sdp_resource::bs_alu_src_MEM  )
                 || (   sdp.bs_mul_bypass == nvdla_sdp_resource::bs_mul_bypass_NO
                     && sdp.bs_mul_src    == nvdla_sdp_resource::bs_mul_src_MEM  )))
         || (   (sdp.bn_bypass == nvdla_sdp_resource::bn_bypass_NO)
             && (   (   sdp.bn_alu_bypass == nvdla_sdp_resource::bn_alu_bypass_NO
                     && sdp.bn_alu_src    == nvdla_sdp_resource::bn_alu_src_MEM  )
                 || (   sdp.bn_mul_bypass == nvdla_sdp_resource::bn_mul_bypass_NO
                     && sdp.bn_mul_src    == nvdla_sdp_resource::bn_mul_src_MEM  )))
         || (   (sdp.ew_bypass == nvdla_sdp_resource::ew_bypass_NO)
             && (   (   sdp.ew_alu_bypass == nvdla_sdp_resource::ew_alu_bypass_NO
                     && sdp.ew_alu_src    == nvdla_sdp_resource::ew_alu_src_MEM  )
                 || (   sdp.ew_mul_bypass == nvdla_sdp_resource::ew_mul_bypass_NO
                     && sdp.ew_mul_src    == nvdla_sdp_resource::ew_mul_src_MEM  )))) == 1;
    }) else `uvm_fatal(inst_name, "SDP resource randomize failed")
    assert(sdp_rdma.randomize() with {
        sdp_rdma.width          == sdp.width;
        sdp_rdma.height         == sdp.height;
        sdp_rdma.channel        == sdp.channel;
        sdp_rdma.flying_mode    == int'(sdp.flying_mode);
        sdp_rdma.winograd       == int'(sdp.winograd);
        sdp_rdma.proc_precision == int'(sdp.proc_precision);
        sdp_rdma.out_precision  == int'(sdp.out_precision);
        sdp_rdma.batch_number   == sdp.batch_number;

        (   sdp.proc_precision == nvdla_sdp_resource::proc_precision_INT8
         && sdp.out_precision  == nvdla_sdp_resource::out_precision_INT8 ) -> {
            sdp_rdma.in_precision inside {
                nvdla_sdp_rdma_resource::in_precision_INT8,
                nvdla_sdp_rdma_resource::in_precision_INT16
            };
        }

        (   sdp.proc_precision == nvdla_sdp_resource::proc_precision_INT8
         && sdp.out_precision  == nvdla_sdp_resource::out_precision_INT16) -> {
            sdp_rdma.in_precision == nvdla_sdp_rdma_resource::in_precision_INT8;
        }

        (sdp.proc_precision == nvdla_sdp_resource::proc_precision_INT16) -> {
            sdp_rdma.in_precision == nvdla_sdp_rdma_resource::in_precision_INT16;
        }

        (sdp.proc_precision == nvdla_sdp_resource::proc_precision_FP16) -> {
            sdp_rdma.in_precision == nvdla_sdp_rdma_resource::in_precision_FP16;
        }

        if (   (sdp.bs_bypass == nvdla_sdp_resource::bs_bypass_NO)
            && (   (   sdp.bs_alu_bypass == nvdla_sdp_resource::bs_alu_bypass_NO
                    && sdp.bs_alu_src    == nvdla_sdp_resource::bs_alu_src_MEM  )
                || (   sdp.bs_mul_bypass == nvdla_sdp_resource::bs_mul_bypass_NO
                    && sdp.bs_mul_src    == nvdla_sdp_resource::bs_mul_src_MEM  ))) {
            sdp_rdma.brdma_disable == nvdla_sdp_rdma_resource::brdma_disable_NO;
        } else {
            sdp_rdma.brdma_disable == nvdla_sdp_rdma_resource::brdma_disable_YES;
        }

        (   sdp.bs_bypass     == nvdla_sdp_resource::bs_bypass_NO
         && sdp.bs_mul_bypass == nvdla_sdp_resource::bs_mul_bypass_NO
         && sdp.bs_alu_bypass == nvdla_sdp_resource::bs_alu_bypass_YES) -> {
            sdp_rdma.brdma_data_use == nvdla_sdp_rdma_resource::brdma_data_use_MUL;
        }

        (   sdp.bs_bypass     == nvdla_sdp_resource::bs_bypass_NO
         && sdp.bs_mul_bypass == nvdla_sdp_resource::bs_mul_bypass_YES
         && sdp.bs_alu_bypass == nvdla_sdp_resource::bs_alu_bypass_NO ) -> {
            sdp_rdma.brdma_data_use == nvdla_sdp_rdma_resource::brdma_data_use_ALU;
        }

        (   sdp.bs_bypass     == nvdla_sdp_resource::bs_bypass_NO
         && sdp.bs_mul_bypass == nvdla_sdp_resource::bs_mul_bypass_NO
         && sdp.bs_alu_bypass == nvdla_sdp_resource::bs_alu_bypass_NO) -> {
            sdp_rdma.brdma_data_use == nvdla_sdp_rdma_resource::brdma_data_use_BOTH;
        }

        if (   (sdp.bn_bypass == nvdla_sdp_resource::bn_bypass_NO)
            && (   (   sdp.bn_alu_bypass == nvdla_sdp_resource::bn_alu_bypass_NO
                    && sdp.bn_alu_src    == nvdla_sdp_resource::bn_alu_src_MEM  )
                || (   sdp.bn_mul_bypass == nvdla_sdp_resource::bn_mul_bypass_NO
                    && sdp.bn_mul_src    == nvdla_sdp_resource::bn_mul_src_MEM  ))) {
            sdp_rdma.nrdma_disable == nvdla_sdp_rdma_resource::nrdma_disable_NO;
        } else {
            sdp_rdma.nrdma_disable == nvdla_sdp_rdma_resource::nrdma_disable_YES;
        }

        (   sdp.bn_bypass     == nvdla_sdp_resource::bn_bypass_NO
         && sdp.bn_mul_bypass == nvdla_sdp_resource::bn_mul_bypass_NO
         && sdp.bn_alu_bypass == nvdla_sdp_resource::bn_alu_bypass_YES) -> {
            sdp_rdma.nrdma_data_use == nvdla_sdp_rdma_resource::nrdma_data_use_MUL;
        }

        (   sdp.bn_bypass     == nvdla_sdp_resource::bn_bypass_NO
         && sdp.bn_mul_bypass == nvdla_sdp_resource::bn_mul_bypass_YES
         && sdp.bn_alu_bypass == nvdla_sdp_resource::bn_alu_bypass_NO ) -> {
            sdp_rdma.nrdma_data_use == nvdla_sdp_rdma_resource::nrdma_data_use_ALU;
        }

        (   sdp.bn_bypass     == nvdla_sdp_resource::bn_bypass_NO
         && sdp.bn_mul_bypass == nvdla_sdp_resource::bn_mul_bypass_NO
         && sdp.bn_alu_bypass == nvdla_sdp_resource::bn_alu_bypass_NO) -> {
            sdp_rdma.nrdma_data_use == nvdla_sdp_rdma_resource::nrdma_data_use_BOTH;
        }

        if (   (sdp.ew_bypass == nvdla_sdp_resource::ew_bypass_NO)
            && (   (   sdp.ew_alu_bypass == nvdla_sdp_resource::ew_alu_bypass_NO
                    && sdp.ew_alu_src    == nvdla_sdp_resource::ew_alu_src_MEM  )
                || (   sdp.ew_mul_bypass == nvdla_sdp_resource::ew_mul_bypass_NO
                    && sdp.ew_mul_src    == nvdla_sdp_resource::ew_mul_src_MEM  ))) {
            sdp_rdma.erdma_disable == nvdla_sdp_rdma_resource::erdma_disable_NO;
        } else {
            sdp_rdma.erdma_disable == nvdla_sdp_rdma_resource::erdma_disable_YES;
        }

        (   sdp.ew_bypass     == nvdla_sdp_resource::ew_bypass_NO
         && sdp.ew_mul_bypass == nvdla_sdp_resource::ew_mul_bypass_NO
         && sdp.ew_alu_bypass == nvdla_sdp_resource::ew_alu_bypass_YES) -> {
            sdp_rdma.erdma_data_use == nvdla_sdp_rdma_resource::erdma_data_use_MUL;
        }

        (   sdp.ew_bypass     == nvdla_sdp_resource::ew_bypass_NO
         && sdp.ew_mul_bypass == nvdla_sdp_resource::ew_mul_bypass_YES
         && sdp.ew_alu_bypass == nvdla_sdp_resource::ew_alu_bypass_NO ) -> {
            sdp_rdma.erdma_data_use == nvdla_sdp_rdma_resource::erdma_data_use_ALU;
        }

        (   sdp.ew_bypass     == nvdla_sdp_resource::ew_bypass_NO
         && sdp.ew_mul_bypass == nvdla_sdp_resource::ew_mul_bypass_NO
         && sdp.ew_alu_bypass == nvdla_sdp_resource::ew_alu_bypass_NO) -> {
            sdp_rdma.erdma_data_use == nvdla_sdp_rdma_resource::erdma_data_use_BOTH;
        }
    }) else `uvm_fatal(inst_name, "SDP_RDMA resource randomize failed")
endfunction: post_randomize

/*
    constraints
 */
constraint nvdla_cc_sdprdma_sdp_pdp_scenario::c_ias_cc {
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
    // No winograd
    cc_dp.conv_mode         == nvdla_cc_dp_resource::conv_mode_DIRECT;
    cc_dp.batches           == 0;

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

        ((cdma.datain_channel+1) * ((cdma.in_precision==nvdla_cdma_resource::in_precision_INT8)?1:2)) % 32 == 0;
    }
    else if (cdma.conv_mode == nvdla_cdma_resource::conv_mode_DIRECT && cdma.datain_format == nvdla_cdma_resource::datain_format_FEATURE) {
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
    else if(cdma.conv_mode == nvdla_cdma_resource::conv_mode_DIRECT && cdma.datain_format == nvdla_cdma_resource::datain_format_PIXEL){ 
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
    (cdma.byte_per_kernel+1) == (cc_dp.weight_width_ext+1)*(cc_dp.weight_height_ext+1)*(cc_dp.weight_channel_ext+1)*((cdma.proc_precision==nvdla_cdma_resource::proc_precision_INT8)?1:2);

    // conv_stride
    if(cdma.conv_mode != nvdla_cdma_resource::conv_mode_WINOGRAD) {
        cc_dp.conv_x_stride_ext == cdma.conv_x_stride;
        cc_dp.conv_y_stride_ext == cdma.conv_y_stride;
    }

}

//constraint nvdla_cc_sdprdma_sdp_pdp_scenario::c_ias_sdp {
//    sdp.width           == cc_dp.dataout_width;
//    sdp.height          == cc_dp.dataout_height;
//    sdp.channel         == cc_dp.dataout_channel;
//    sdp.proc_precision  == int'(cc_dp.proc_precision);
//    if (cc_dp.conv_mode == nvdla_cc_dp_resource::conv_mode_WINOGRAD) {
//        sdp.winograd    == nvdla_sdp_resource::winograd_ON;
//    } else {
//        sdp.winograd    == nvdla_sdp_resource::winograd_OFF;
//    }
//    sdp.flying_mode     == nvdla_sdp_resource::flying_mode_ON;
//    sdp.batch_number    == 0;
//    sdp.output_dst      == nvdla_sdp_resource::output_dst_PDP;
//
//    // Make sure at least one of B/N/E RDMA shall be enabled
//        (   (sdp.bs_bypass == nvdla_sdp_resource::bs_bypass_NO)
//         && (   (   sdp.bs_alu_bypass == nvdla_sdp_resource::bs_alu_bypass_NO
//                 && sdp.bs_alu_src    == nvdla_sdp_resource::bs_alu_src_MEM  )
//             || (   sdp.bs_mul_bypass == nvdla_sdp_resource::bs_mul_bypass_NO
//                 && sdp.bs_mul_src    == nvdla_sdp_resource::bs_mul_src_MEM  )))
//     || (   (sdp.bn_bypass == nvdla_sdp_resource::bn_bypass_NO)
//         && (   (   sdp.bn_alu_bypass == nvdla_sdp_resource::bn_alu_bypass_NO
//                 && sdp.bn_alu_src    == nvdla_sdp_resource::bn_alu_src_MEM  )
//             || (   sdp.bn_mul_bypass == nvdla_sdp_resource::bn_mul_bypass_NO
//                 && sdp.bn_mul_src    == nvdla_sdp_resource::bn_mul_src_MEM  )))
//     || (   (sdp.ew_bypass == nvdla_sdp_resource::ew_bypass_NO)
//         && (   (   sdp.ew_alu_bypass == nvdla_sdp_resource::ew_alu_bypass_NO
//                 && sdp.ew_alu_src    == nvdla_sdp_resource::ew_alu_src_MEM  )
//             || (   sdp.ew_mul_bypass == nvdla_sdp_resource::ew_mul_bypass_NO
//                 && sdp.ew_mul_src    == nvdla_sdp_resource::ew_mul_src_MEM  )));
//}

//constraint nvdla_cc_sdprdma_sdp_pdp_scenario::c_ias_sdp_rdma {
//    sdp_rdma.width          == sdp.width;
//    sdp_rdma.height         == sdp.height;
//    sdp_rdma.channel        == sdp.channel;
//    sdp_rdma.flying_mode    == int'(sdp.flying_mode);
//    sdp_rdma.winograd       == int'(sdp.winograd);
//    sdp_rdma.proc_precision == int'(sdp.proc_precision);
//    sdp_rdma.out_precision  == int'(sdp.out_precision);
//    sdp_rdma.batch_number   == sdp.batch_number;
//
//    (   sdp.proc_precision == nvdla_sdp_resource::proc_precision_INT8
//     && sdp.out_precision  == nvdla_sdp_resource::out_precision_INT8 ) -> {
//        sdp_rdma.in_precision inside {
//            nvdla_sdp_rdma_resource::in_precision_INT8,
//            nvdla_sdp_rdma_resource::in_precision_INT16
//        };
//    }
//
//    (   sdp.proc_precision == nvdla_sdp_resource::proc_precision_INT8
//     && sdp.out_precision  == nvdla_sdp_resource::out_precision_INT16) -> {
//        sdp_rdma.in_precision == nvdla_sdp_rdma_resource::in_precision_INT8;
//    }
//
//    (sdp.proc_precision == nvdla_sdp_resource::proc_precision_INT16) -> {
//        sdp_rdma.in_precision == nvdla_sdp_rdma_resource::in_precision_INT16;
//    }
//
//    (sdp.proc_precision == nvdla_sdp_resource::proc_precision_FP16) -> {
//        sdp_rdma.in_precision == nvdla_sdp_rdma_resource::in_precision_FP16;
//    }
//
//    if (   (sdp.bs_bypass == nvdla_sdp_resource::bs_bypass_NO)
//        && (   (   sdp.bs_alu_bypass == nvdla_sdp_resource::bs_alu_bypass_NO
//                && sdp.bs_alu_src    == nvdla_sdp_resource::bs_alu_src_MEM  )
//            || (   sdp.bs_mul_bypass == nvdla_sdp_resource::bs_mul_bypass_NO
//                && sdp.bs_mul_src    == nvdla_sdp_resource::bs_mul_src_MEM  ))) {
//        sdp_rdma.brdma_disable == nvdla_sdp_rdma_resource::brdma_disable_NO;
//    } else {
//        sdp_rdma.brdma_disable == nvdla_sdp_rdma_resource::brdma_disable_YES;
//    }
//
//    (   sdp.bs_bypass     == nvdla_sdp_resource::bs_bypass_NO
//     && sdp.bs_mul_bypass == nvdla_sdp_resource::bs_mul_bypass_NO
//     && sdp.bs_alu_bypass == nvdla_sdp_resource::bs_alu_bypass_YES) -> {
//        sdp_rdma.brdma_data_use == nvdla_sdp_rdma_resource::brdma_data_use_MUL;
//    }
//
//    (   sdp.bs_bypass     == nvdla_sdp_resource::bs_bypass_NO
//     && sdp.bs_mul_bypass == nvdla_sdp_resource::bs_mul_bypass_YES
//     && sdp.bs_alu_bypass == nvdla_sdp_resource::bs_alu_bypass_NO ) -> {
//        sdp_rdma.brdma_data_use == nvdla_sdp_rdma_resource::brdma_data_use_ALU;
//    }
//
//    (   sdp.bs_bypass     == nvdla_sdp_resource::bs_bypass_NO
//     && sdp.bs_mul_bypass == nvdla_sdp_resource::bs_mul_bypass_NO
//     && sdp.bs_alu_bypass == nvdla_sdp_resource::bs_alu_bypass_NO) -> {
//        sdp_rdma.brdma_data_use == nvdla_sdp_rdma_resource::brdma_data_use_BOTH;
//    }
//
//    if (   (sdp.bn_bypass == nvdla_sdp_resource::bn_bypass_NO)
//        && (   (   sdp.bn_alu_bypass == nvdla_sdp_resource::bn_alu_bypass_NO
//                && sdp.bn_alu_src    == nvdla_sdp_resource::bn_alu_src_MEM  )
//            || (   sdp.bn_mul_bypass == nvdla_sdp_resource::bn_mul_bypass_NO
//                && sdp.bn_mul_src    == nvdla_sdp_resource::bn_mul_src_MEM  ))) {
//        sdp_rdma.nrdma_disable == nvdla_sdp_rdma_resource::nrdma_disable_NO;
//    } else {
//        sdp_rdma.nrdma_disable == nvdla_sdp_rdma_resource::nrdma_disable_YES;
//    }
//
//    (   sdp.bn_bypass     == nvdla_sdp_resource::bn_bypass_NO
//     && sdp.bn_mul_bypass == nvdla_sdp_resource::bn_mul_bypass_NO
//     && sdp.bn_alu_bypass == nvdla_sdp_resource::bn_alu_bypass_YES) -> {
//        sdp_rdma.nrdma_data_use == nvdla_sdp_rdma_resource::nrdma_data_use_MUL;
//    }
//
//    (   sdp.bn_bypass     == nvdla_sdp_resource::bn_bypass_NO
//     && sdp.bn_mul_bypass == nvdla_sdp_resource::bn_mul_bypass_YES
//     && sdp.bn_alu_bypass == nvdla_sdp_resource::bn_alu_bypass_NO ) -> {
//        sdp_rdma.nrdma_data_use == nvdla_sdp_rdma_resource::nrdma_data_use_ALU;
//    }
//
//    (   sdp.bn_bypass     == nvdla_sdp_resource::bn_bypass_NO
//     && sdp.bn_mul_bypass == nvdla_sdp_resource::bn_mul_bypass_NO
//     && sdp.bn_alu_bypass == nvdla_sdp_resource::bn_alu_bypass_NO) -> {
//        sdp_rdma.nrdma_data_use == nvdla_sdp_rdma_resource::nrdma_data_use_BOTH;
//    }
//
//    if (   (sdp.ew_bypass == nvdla_sdp_resource::ew_bypass_NO)
//        && (   (   sdp.ew_alu_bypass == nvdla_sdp_resource::ew_alu_bypass_NO
//                && sdp.ew_alu_src    == nvdla_sdp_resource::ew_alu_src_MEM  )
//            || (   sdp.ew_mul_bypass == nvdla_sdp_resource::ew_mul_bypass_NO
//                && sdp.ew_mul_src    == nvdla_sdp_resource::ew_mul_src_MEM  ))) {
//        sdp_rdma.erdma_disable == nvdla_sdp_rdma_resource::erdma_disable_NO;
//    } else {
//        sdp_rdma.erdma_disable == nvdla_sdp_rdma_resource::erdma_disable_YES;
//    }
//
//    (   sdp.ew_bypass     == nvdla_sdp_resource::ew_bypass_NO
//     && sdp.ew_mul_bypass == nvdla_sdp_resource::ew_mul_bypass_NO
//     && sdp.ew_alu_bypass == nvdla_sdp_resource::ew_alu_bypass_YES) -> {
//        sdp_rdma.erdma_data_use == nvdla_sdp_rdma_resource::erdma_data_use_MUL;
//    }
//
//    (   sdp.ew_bypass     == nvdla_sdp_resource::ew_bypass_NO
//     && sdp.ew_mul_bypass == nvdla_sdp_resource::ew_mul_bypass_YES
//     && sdp.ew_alu_bypass == nvdla_sdp_resource::ew_alu_bypass_NO ) -> {
//        sdp_rdma.erdma_data_use == nvdla_sdp_rdma_resource::erdma_data_use_ALU;
//    }
//
//    (   sdp.ew_bypass     == nvdla_sdp_resource::ew_bypass_NO
//     && sdp.ew_mul_bypass == nvdla_sdp_resource::ew_mul_bypass_NO
//     && sdp.ew_alu_bypass == nvdla_sdp_resource::ew_alu_bypass_NO) -> {
//        sdp_rdma.erdma_data_use == nvdla_sdp_rdma_resource::erdma_data_use_BOTH;
//    }
//}

constraint nvdla_cc_sdprdma_sdp_pdp_scenario::c_ias_pdp {
    pdp.split_num       == 0;
    pdp.flying_mode     == nvdla_pdp_resource::flying_mode_ON_FLYING;
    pdp.cube_in_width   == cc_dp.dataout_width;
    pdp.cube_in_height  == cc_dp.dataout_height;
    pdp.cube_in_channel == cc_dp.dataout_channel;
    pdp.input_data      == int'(cc_dp.proc_precision);
}

`endif //_NVDLA_CC_SDPRDMA_SDP_PDP_SCENARIO_SV_
