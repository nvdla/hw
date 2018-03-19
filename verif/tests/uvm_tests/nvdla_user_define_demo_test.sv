`ifndef _NVDLA_USER_DEFINE_DEMO_TEST_SV_
`define _NVDLA_USER_DEFINE_DEMO_TEST_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_user_define_demo_test 
//
// @description: demo test
//-------------------------------------------------------------------------------------

class nvdla_user_define_demo_test extends nvdla_tg_base_test;

    function new(string name="nvdla_user_define_demo_test", uvm_component parent);
        super.new(name, parent);
        set_inst_name("nvdla_user_define_demo_test");
		layers=3;
    endfunction : new

    `uvm_component_utils(nvdla_user_define_demo_test)
endclass : nvdla_user_define_demo_test

`endif //_NVDLA_USER_DEFINE_DEMO_TEST_SV_
