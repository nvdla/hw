`ifndef RM_CMOD_NVDLA_TOP_SV
`define RM_CMOD_NVDLA_TOP_SV

// Component: Cmod nvdla_top wrapper  
//
// Description:
//      a) CMOD TLM_GP+ext could not be directly connected with monitors and scoreboard
//      b) CMOD sv module wrapper will be instanced
//    ---------------------------------------------------------------------------------------
//    |                                                                                     |
//    |              -------          --------------------------------           -------    |
//   >|---  Req   -->| CSB | >=====>  |                              |  >=====>  | AXI |    |
//   <|<-- W_Resp ---| CVT | <=====<  | nvdla_top_sv_module_wrapper |  >=====>  | CVT |    |
//   <|<-- R_Resp ---|     | <=====<  |                              |  <=====<  |     |    |
//    |              |     |          |                              |  <=====<  |     |    |
//    |              -------          --------------------------------           -------    |
//    |    TLM FIFO         TLM Sockets                                                     |
//    ---------------------------------------------------------------------------------------
/// @file 
//


/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
///
///              class rm_cmod_nvdla_top
///
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////

// Forward declaration instance class
typedef class rm_nvdla_dma_convertor;
typedef class rm_nvdla_conv_core_socket_convertor;
typedef class rm_nvdla_post_processing_socket_convertor;

class rm_cmod_nvdla_top extends uvm_component;
    string tID;
    `uvm_component_utils(rm_cmod_nvdla_top)

    // SCSV adapter: used to communicate with CMOD through UVMCONNECTION
    nvdla_top_sv_adapter            nvdla_top_sv_adapter_inst;

    // NVDLA convertors: used to connect with CMOD internal interfaces and do txn
    // conversion between DUT and CMOD
    rm_nvdla_dma_convertor          rm_nvdla_dma_convertor_pri;
    `ifdef NVDLA_SECONDARY_MEMIF_ENABLE
    rm_nvdla_dma_convertor          rm_nvdla_dma_convertor_sec;
    `endif
    // Convolution core convertor
    rm_nvdla_conv_core_socket_convertor       rm_nvdla_conv_core_socket_convertor_inst;
    rm_nvdla_post_processing_socket_convertor rm_nvdla_post_processing_socket_convertor_inst;

    // Socket to connect CMOD and memory model
    uvm_tlm_b_passthrough_initiator_socket#(uvm_tlm_generic_payload) rm_primary_mem_initator;
    `ifdef NVDLA_SECONDARY_MEMIF_ENABLE
    uvm_tlm_b_passthrough_initiator_socket#(uvm_tlm_generic_payload) rm_secondary_mem_initator;
    `endif

    // Socket to transfer CSB txn between DUT and CMOD
    uvm_tlm_b_passthrough_target_socket#(uvm_tlm_generic_payload)    rm_csb_target;

    uvm_factory                     factory_inst;

    /////////////////////////////////////////////////////////////
    // Layer component instantiation
    /////////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////////
    //// constructor
    /////////////////////////////////////////////////////////////
    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        tID = get_type_name();
        tID = tID.toupper();
    endfunction : new
    
      
    /////////////////////////////////////////////////////////////
    /// build phase()
    /////////////////////////////////////////////////////////////
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        /////////////////////////////////////////////////////////
        // Instance Constructions
        ///////////////////////////////////////////////////////// 
        nvdla_top_sv_adapter_inst                      = nvdla_top_sv_adapter::type_id::create("nvdla_top_sv_adapter_inst", this);

        rm_nvdla_dma_convertor_pri                     = rm_nvdla_dma_convertor::type_id::create("rm_nvdla_dma_convertor_pri", this);
        rm_nvdla_conv_core_socket_convertor_inst       = rm_nvdla_conv_core_socket_convertor::type_id::create("rm_nvdla_conv_core_socket_convertor_inst", this);
        rm_nvdla_post_processing_socket_convertor_inst = rm_nvdla_post_processing_socket_convertor::type_id::create("rm_nvdla_post_processing_socket_convertor_inst", this);

        rm_primary_mem_initator                        = new("rm_primary_mem_initator", this);
        rm_csb_target                                  = new("rm_csb_target", this);

        `ifdef NVDLA_SECONDARY_MEMIF_ENABLE
        rm_nvdla_dma_convertor_sec                     = rm_nvdla_dma_convertor::type_id::create("rm_nvdla_dma_convertor_sec", this);
        rm_secondary_mem_initator                      = new("rm_secondary_mem_initator", this);
        `endif

        nvdla_scsv_register_extension_packer#(nvdla_dbb_scsv_extension_packer)::register_extension(nvdla_scsv_pkg::NVDLA_DBB_SCSV_EXTENSION_PACKER_ID);

        `uvm_info(tID, "build_phase is executed", UVM_FULL)
    endfunction : build_phase
    
      
    /////////////////////////////////////////////////////////////
    /// connect phase()
    /////////////////////////////////////////////////////////////
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Connect convertor and scsv adapter
        // nvdla_top sockets
        rm_csb_target.connect(nvdla_top_sv_adapter_inst.nvdla_top_sv2sc_nvdla_host_master_if_target_pt);
        nvdla_top_sv_adapter_inst.nvdla_top_sc2sv_nvdla_core2dbb_axi4_initiator_pt.connect(rm_primary_mem_initator);
        // Internal monitor target sockets
        nvdla_top_sv_adapter_inst.nvdla_top_sc2sv_dma_monitor_mc_initiator_pt.connect(rm_nvdla_dma_convertor_pri.rm_nvdla_dma_convertor_target); 
        nvdla_top_sv_adapter_inst.nvdla_top_sc2sv_convolution_core_monitor_initiator_initiator_pt.connect(rm_nvdla_conv_core_socket_convertor_inst.rm_nvdla_conv_core_socket_convertor_target);
        nvdla_top_sv_adapter_inst.nvdla_top_sc2sv_post_processing_monitor_initiator_initiator_pt.connect(rm_nvdla_post_processing_socket_convertor_inst.rm_nvdla_post_processing_socket_convertor_target);
        // Internal monitor credit initiator sockets
        rm_nvdla_dma_convertor_pri.rm_nvdla_dma_convertor_credit_initiator.connect(nvdla_top_sv_adapter_inst.nvdla_top_sv2sc_dma_monitor_mc_credit_target_pt);
        rm_nvdla_conv_core_socket_convertor_inst.rm_nvdla_conv_core_socket_convertor_credit_initiator.connect(nvdla_top_sv_adapter_inst.nvdla_top_sv2sc_convolution_core_monitor_credit_target_pt);
        rm_nvdla_post_processing_socket_convertor_inst.rm_nvdla_post_processing_socket_convertor_credit_initiator.connect(nvdla_top_sv_adapter_inst.nvdla_top_sv2sc_post_processing_monitor_credit_target_pt);
        `ifdef NVDLA_SECONDARY_MEMIF_ENABLE
        nvdla_top_sv_adapter_inst.nvdla_top_sc2sv_nvdla_core2cvsram_axi4_initiator_pt.connect(rm_secondary_mem_initator);
        nvdla_top_sv_adapter_inst.nvdla_top_sc2sv_dma_monitor_cv_initiator_pt.connect(rm_nvdla_dma_convertor_sec.rm_nvdla_dma_convertor_target);
        rm_nvdla_dma_convertor_sec.rm_nvdla_dma_convertor_credit_initiator.connect(nvdla_top_sv_adapter_inst.nvdla_top_sv2sc_dma_monitor_cv_credit_target_pt);
        `endif

        `uvm_info(tID, "connect_phase is executed", UVM_FULL)
    endfunction : connect_phase

endclass: rm_cmod_nvdla_top

`endif // RM_CMOD_NVDLA_TOP_SV
