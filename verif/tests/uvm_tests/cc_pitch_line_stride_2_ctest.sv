`ifndef _CC_PITCH_LINE_STRIDE_2_CTEST_SV_
`define _CC_PITCH_LINE_STRIDE_2_CTEST_SV_

//-------------------------------------------------------------------------------------
// CLASS: cc_pitch_line_stride_2_ctest 
//-------------------------------------------------------------------------------------
  
// This test is used to cover below cross cover points (see nvdla_coverage_conv.sv):
// - cr_data_reuse_datain_format_pixel_mapping_pixel_format_line_stride_pitch_2
//
// subtest must be set using cmdline "+uvm_set_config_int=*,subtest,<N>"
// pixel_format must be set using cmdline "+uvm_set_config_int=*,pixel_format,<N>"

class cc_pitch_line_stride_2_ctest_cc_sdp_scenario extends nvdla_cc_sdp_scenario;
    localparam N_SUBTESTS = 10;

    int      subtest = -1;
    bit[9:0] line_stride_pitch;
    int      pixel_format = 0;

    function new(string name="cc_pitch_line_stride_2_ctest_cc_sdp_scenario", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void pre_randomize();
        super.pre_randomize();

        if (!(subtest inside {[0:N_SUBTESTS-1]}))
            `uvm_fatal(get_name(), $sformatf("# Invalid subtest (%0d), valid range is [0:%0d]", subtest, N_SUBTESTS-1))

        std::randomize(line_stride_pitch) with {
            line_stride_pitch[1:0] == 0;
            subtest == 0 -> line_stride_pitch == 0;
            subtest == 1 -> line_stride_pitch inside {['h001:'h024]};
            subtest == 2 -> line_stride_pitch inside {['h025:'h048]};
            subtest == 3 -> line_stride_pitch inside {['h049:'h06c]};
            subtest == 4 -> line_stride_pitch inside {['h06d:'h090]};
            subtest == 5 -> line_stride_pitch inside {['h091:'h0b4]};
            subtest == 6 -> line_stride_pitch inside {['h0b5:'h0d8]};
            subtest == 7 -> line_stride_pitch inside {['h0d9:'h0ff]};
            subtest == 8 -> line_stride_pitch inside {['h100:'h17f]};
            subtest == 9 -> line_stride_pitch inside {['h180:'h200]};
        };

        `uvm_info("pre_randomize",
            $sformatf("line_stride_pitch = %0d", line_stride_pitch), UVM_NONE)
    endfunction

    constraint sce_cc_sdp_sim_constraint_for_user_extend {
        cdma.data_reuse     == nvdla_cdma_resource::data_reuse_DISABLE;
        cdma.weight_reuse   == nvdla_cdma_resource::weight_reuse_DISABLE;
        cdma.skip_data_rls  == nvdla_cdma_resource::skip_data_rls_DISABLE;
        cdma.skip_weight_rls== nvdla_cdma_resource::skip_weight_rls_DISABLE;
        cdma.datain_format  == nvdla_cdma_resource::datain_format_PIXEL;
        cdma.pixel_format   == nvdla_cdma_resource::pixel_format_t'(this.pixel_format);
        cdma.datain_height  == 0;

        this.line_stride_pitch == (
            cdma.line_stride - (cdma.pixel_x_offset + cdma.datain_width + 1)
                              *(cdma.in_precision == nvdla_cdma_resource::in_precision_INT8 ? 1 : 2)
                              *(cdma.datain_channel + 1)
        );
    }

    `uvm_component_utils_begin(cc_pitch_line_stride_2_ctest_cc_sdp_scenario)
        `uvm_field_int(subtest     , UVM_DEFAULT)
        `uvm_field_int(pixel_format, UVM_DEFAULT)
    `uvm_component_utils_end
endclass: cc_pitch_line_stride_2_ctest_cc_sdp_scenario

class cc_pitch_line_stride_2_ctest extends nvdla_tg_base_test;
    function new(string name="cc_pitch_line_stride_2_ctest", uvm_component parent);
        super.new(name, parent);
        set_inst_name("cc_pitch_line_stride_2_ctest");
        set_type_override_by_type(nvdla_cc_sdp_scenario::get_type(), cc_pitch_line_stride_2_ctest_cc_sdp_scenario::get_type());        
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

    function override_scenario_pool();
        generator.delete_scenario_pool();
        generator.push_scenario_pool(SCE_CC_SDP);
    endfunction: override_scenario_pool

    `uvm_component_utils(cc_pitch_line_stride_2_ctest)
endclass : cc_pitch_line_stride_2_ctest

`endif

