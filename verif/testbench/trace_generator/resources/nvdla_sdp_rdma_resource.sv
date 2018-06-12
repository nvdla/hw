`ifndef _NVDLA_SDP_RDMA_RESOURCE_SV_
`define _NVDLA_SDP_RDMA_RESOURCE_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_sdp_rdma_resource
//
// @description: various hardware resources of sdp sub module
//-------------------------------------------------------------------------------------

class nvdla_sdp_rdma_resource extends nvdla_base_resource;
    // singleton handle
    static local nvdla_sdp_rdma_resource        inst;

    // enum define
    //:| import spec2constrain
    //:| global spec2cons
    //:| spec2cons = spec2constrain.Spec2Cons()
    //:| spec2cons.enum_gen(['NVDLA_SDP_RDMA'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    typedef enum{ brdma_disable_NO                 = 'h0
                 ,brdma_disable_YES                = 'h1
                } brdma_disable_t;
    typedef enum{ brdma_data_use_MUL               = 'h0
                 ,brdma_data_use_ALU               = 'h1
                 ,brdma_data_use_BOTH              = 'h2
                } brdma_data_use_t;
    typedef enum{ brdma_data_size_ONE_BYTE         = 'h0
                 ,brdma_data_size_TWO_BYTE         = 'h1
                } brdma_data_size_t;
    typedef enum{ brdma_data_mode_PER_KERNEL       = 'h0
                 ,brdma_data_mode_PER_ELEMENT      = 'h1
                } brdma_data_mode_t;
    typedef enum{ brdma_ram_type_CV                = 'h0
                 ,brdma_ram_type_MC                = 'h1
                } brdma_ram_type_t;
    typedef enum{ nrdma_disable_NO                 = 'h0
                 ,nrdma_disable_YES                = 'h1
                } nrdma_disable_t;
    typedef enum{ nrdma_data_use_MUL               = 'h0
                 ,nrdma_data_use_ALU               = 'h1
                 ,nrdma_data_use_BOTH              = 'h2
                } nrdma_data_use_t;
    typedef enum{ nrdma_data_size_ONE_BYTE         = 'h0
                 ,nrdma_data_size_TWO_BYTE         = 'h1
                } nrdma_data_size_t;
    typedef enum{ nrdma_data_mode_PER_KERNEL       = 'h0
                 ,nrdma_data_mode_PER_ELEMENT      = 'h1
                } nrdma_data_mode_t;
    typedef enum{ nrdma_ram_type_CV                = 'h0
                 ,nrdma_ram_type_MC                = 'h1
                } nrdma_ram_type_t;
    typedef enum{ erdma_disable_NO                 = 'h0
                 ,erdma_disable_YES                = 'h1
                } erdma_disable_t;
    typedef enum{ erdma_data_use_MUL               = 'h0
                 ,erdma_data_use_ALU               = 'h1
                 ,erdma_data_use_BOTH              = 'h2
                } erdma_data_use_t;
    typedef enum{ erdma_data_size_ONE_BYTE         = 'h0
                 ,erdma_data_size_TWO_BYTE         = 'h1
                } erdma_data_size_t;
    typedef enum{ erdma_data_mode_PER_KERNEL       = 'h0
                 ,erdma_data_mode_PER_ELEMENT      = 'h1
                } erdma_data_mode_t;
    typedef enum{ erdma_ram_type_CV                = 'h0
                 ,erdma_ram_type_MC                = 'h1
                } erdma_ram_type_t;
    typedef enum{ flying_mode_OFF                  = 'h0
                 ,flying_mode_ON                   = 'h1
                } flying_mode_t;
    typedef enum{ winograd_OFF                     = 'h0
                 ,winograd_ON                      = 'h1
                } winograd_t;
    typedef enum{ in_precision_INT8                = 'h0
                 ,in_precision_INT16               = 'h1
                 ,in_precision_FP16                = 'h2
                } in_precision_t;
    typedef enum{ proc_precision_INT8              = 'h0
                 ,proc_precision_INT16             = 'h1
                 ,proc_precision_FP16              = 'h2
                } proc_precision_t;
    typedef enum{ out_precision_INT8               = 'h0
                 ,out_precision_INT16              = 'h1
                 ,out_precision_FP16               = 'h2
                } out_precision_t;
    typedef enum{ src_ram_type_CV                  = 'h0
                 ,src_ram_type_MC                  = 'h1
                } src_ram_type_t;
    typedef enum{ perf_dma_en_NO                   = 'h0
                 ,perf_dma_en_YES                  = 'h1
                } perf_dma_en_t;
    typedef enum{ perf_nan_inf_count_en_NO         = 'h0
                 ,perf_nan_inf_count_en_YES        = 'h1
                } perf_nan_inf_count_en_t;
    //:) epython: generated_end (DO NOT EDIT ABOVE)

    // field variables
    //:| spec2cons.state_gen(['NVDLA_SDP_RDMA'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    rand bit [12:0]                 width;
    rand bit [12:0]                 height;
    rand bit [12:0]                 channel;
    rand bit [31:0]                 src_base_addr_low;
    rand bit [31:0]                 src_base_addr_high;
    rand bit [31:0]                 src_line_stride;
    rand bit [31:0]                 src_surface_stride;
    rand brdma_disable_t            brdma_disable;
    rand brdma_data_use_t           brdma_data_use;
    rand brdma_data_size_t          brdma_data_size;
    rand brdma_data_mode_t          brdma_data_mode;
    rand brdma_ram_type_t           brdma_ram_type;
    rand bit [31:0]                 bs_base_addr_low;
    rand bit [31:0]                 bs_base_addr_high;
    rand bit [31:0]                 bs_line_stride;
    rand bit [31:0]                 bs_surface_stride;
    rand bit [31:0]                 bs_batch_stride;
    rand nrdma_disable_t            nrdma_disable;
    rand nrdma_data_use_t           nrdma_data_use;
    rand nrdma_data_size_t          nrdma_data_size;
    rand nrdma_data_mode_t          nrdma_data_mode;
    rand nrdma_ram_type_t           nrdma_ram_type;
    rand bit [31:0]                 bn_base_addr_low;
    rand bit [31:0]                 bn_base_addr_high;
    rand bit [31:0]                 bn_line_stride;
    rand bit [31:0]                 bn_surface_stride;
    rand bit [31:0]                 bn_batch_stride;
    rand erdma_disable_t            erdma_disable;
    rand erdma_data_use_t           erdma_data_use;
    rand erdma_data_size_t          erdma_data_size;
    rand erdma_data_mode_t          erdma_data_mode;
    rand erdma_ram_type_t           erdma_ram_type;
    rand bit [31:0]                 ew_base_addr_low;
    rand bit [31:0]                 ew_base_addr_high;
    rand bit [31:0]                 ew_line_stride;
    rand bit [31:0]                 ew_surface_stride;
    rand bit [31:0]                 ew_batch_stride;
    rand flying_mode_t              flying_mode;
    rand winograd_t                 winograd;
    rand in_precision_t             in_precision;
    rand proc_precision_t           proc_precision;
    rand out_precision_t            out_precision;
    rand bit [4:0]                  batch_number;
    rand src_ram_type_t             src_ram_type;
    rand perf_dma_en_t              perf_dma_en;
    rand perf_nan_inf_count_en_t    perf_nan_inf_count_en;
    //:) epython: generated_end (DO NOT EDIT ABOVE)

    string sdp_mrdma_surface_pattern    = "random";
    string sdp_brdma_surface_pattern    = "random";
    string sdp_nrdma_surface_pattern    = "random";
    string sdp_erdma_surface_pattern    = "random";
    `uvm_component_utils_begin(nvdla_sdp_rdma_resource)
        `uvm_field_string(sdp_mrdma_surface_pattern, UVM_ALL_ON)
        `uvm_field_string(sdp_brdma_surface_pattern, UVM_ALL_ON)
        `uvm_field_string(sdp_nrdma_surface_pattern, UVM_ALL_ON)
        `uvm_field_string(sdp_erdma_surface_pattern, UVM_ALL_ON)
        //:| spec2cons.macro_gen(['NVDLA_SDP_RDMA'])
        //:) epython: generated_beg (DO NOT EDIT BELOW)
        `uvm_field_int(width,                                          UVM_ALL_ON)
        `uvm_field_int(height,                                         UVM_ALL_ON)
        `uvm_field_int(channel,                                        UVM_ALL_ON)
        `uvm_field_int(src_base_addr_low,                              UVM_ALL_ON)
        `uvm_field_int(src_base_addr_high,                             UVM_ALL_ON)
        `uvm_field_int(src_line_stride,                                UVM_ALL_ON)
        `uvm_field_int(src_surface_stride,                             UVM_ALL_ON)
        `uvm_field_enum(brdma_disable_t,          brdma_disable,       UVM_ALL_ON)
        `uvm_field_enum(brdma_data_use_t,         brdma_data_use,      UVM_ALL_ON)
        `uvm_field_enum(brdma_data_size_t,        brdma_data_size,     UVM_ALL_ON)
        `uvm_field_enum(brdma_data_mode_t,        brdma_data_mode,     UVM_ALL_ON)
        `uvm_field_enum(brdma_ram_type_t,         brdma_ram_type,      UVM_ALL_ON)
        `uvm_field_int(bs_base_addr_low,                               UVM_ALL_ON)
        `uvm_field_int(bs_base_addr_high,                              UVM_ALL_ON)
        `uvm_field_int(bs_line_stride,                                 UVM_ALL_ON)
        `uvm_field_int(bs_surface_stride,                              UVM_ALL_ON)
        `uvm_field_int(bs_batch_stride,                                UVM_ALL_ON)
        `uvm_field_enum(nrdma_disable_t,          nrdma_disable,       UVM_ALL_ON)
        `uvm_field_enum(nrdma_data_use_t,         nrdma_data_use,      UVM_ALL_ON)
        `uvm_field_enum(nrdma_data_size_t,        nrdma_data_size,     UVM_ALL_ON)
        `uvm_field_enum(nrdma_data_mode_t,        nrdma_data_mode,     UVM_ALL_ON)
        `uvm_field_enum(nrdma_ram_type_t,         nrdma_ram_type,      UVM_ALL_ON)
        `uvm_field_int(bn_base_addr_low,                               UVM_ALL_ON)
        `uvm_field_int(bn_base_addr_high,                              UVM_ALL_ON)
        `uvm_field_int(bn_line_stride,                                 UVM_ALL_ON)
        `uvm_field_int(bn_surface_stride,                              UVM_ALL_ON)
        `uvm_field_int(bn_batch_stride,                                UVM_ALL_ON)
        `uvm_field_enum(erdma_disable_t,          erdma_disable,       UVM_ALL_ON)
        `uvm_field_enum(erdma_data_use_t,         erdma_data_use,      UVM_ALL_ON)
        `uvm_field_enum(erdma_data_size_t,        erdma_data_size,     UVM_ALL_ON)
        `uvm_field_enum(erdma_data_mode_t,        erdma_data_mode,     UVM_ALL_ON)
        `uvm_field_enum(erdma_ram_type_t,         erdma_ram_type,      UVM_ALL_ON)
        `uvm_field_int(ew_base_addr_low,                               UVM_ALL_ON)
        `uvm_field_int(ew_base_addr_high,                              UVM_ALL_ON)
        `uvm_field_int(ew_line_stride,                                 UVM_ALL_ON)
        `uvm_field_int(ew_surface_stride,                              UVM_ALL_ON)
        `uvm_field_int(ew_batch_stride,                                UVM_ALL_ON)
        `uvm_field_enum(flying_mode_t,            flying_mode,         UVM_ALL_ON)
        `uvm_field_enum(winograd_t,               winograd,            UVM_ALL_ON)
        `uvm_field_enum(in_precision_t,           in_precision,        UVM_ALL_ON)
        `uvm_field_enum(proc_precision_t,         proc_precision,      UVM_ALL_ON)
        `uvm_field_enum(out_precision_t,          out_precision,       UVM_ALL_ON)
        `uvm_field_int(batch_number,                                   UVM_ALL_ON)
        `uvm_field_enum(src_ram_type_t,           src_ram_type,        UVM_ALL_ON)
        `uvm_field_enum(perf_dma_en_t,            perf_dma_en,         UVM_ALL_ON)
        `uvm_field_enum(perf_nan_inf_count_en_t,  perf_nan_inf_count_en, UVM_ALL_ON)
        //:) epython: generated_end (DO NOT EDIT ABOVE)
    `uvm_component_utils_end

    /*
        Methods
    */
    extern function         new(string name="nvdla_sdp_rdma_resource", uvm_component parent);
    extern static function  nvdla_sdp_rdma_resource get_sdp_rdma(uvm_component parent);
    extern function void    trace_dump(int fh);
    extern function void    surface_dump(int fh);
    extern function void    set_mem_addr();
    extern function void    set_register();
    extern function void    post_randomize();

    /*
        constraints:
            * ias_constraint: mandatory constraints from architecture requirement
            * sim_constraint: optional constraints for simulation only
    */
    // ias constraint
    extern constraint c_ias_stride_alignment;
    extern constraint c_ias_src_mem;
    extern constraint c_ias_bs_mem;
    extern constraint c_ias_bn_mem;
    extern constraint c_ias_ew_mem;
    extern constraint c_ias_precision;
    extern constraint c_ias_dut_por_requirement;
    // sim constraint
    extern constraint c_sim_src_mem_weight_dist;
    extern constraint c_sim_bs_weight_dist;
    extern constraint c_sim_bn_weight_dist;
    extern constraint c_sim_ew_weight_dist;
    extern constraint c_sim_feature_weight_dist;

endclass : nvdla_sdp_rdma_resource

function nvdla_sdp_rdma_resource::new(string name="nvdla_sdp_rdma_resource", uvm_component parent);
    super.new(name, parent);
    `uvm_info(inst_name, $sformatf("Initialize resource %s ... ",inst_name),UVM_LOW);
endfunction: new

static function  nvdla_sdp_rdma_resource nvdla_sdp_rdma_resource::get_sdp_rdma(uvm_component parent);
    if (null == inst) begin
        inst = new("NVDLA_SDP_RDMA", parent);
    end
    return inst;
endfunction: get_sdp_rdma

function void nvdla_sdp_rdma_resource::surface_dump(int fh);
    // Use surface generator to dump memory surface
    if(flying_mode_OFF == flying_mode) begin
        // SDP M-RDMA
        surface_feature_config feature_cfg;
        longint unsigned       address;
        string                 mem_domain_input;
        address                    = {src_base_addr_high, src_base_addr_low};
        $sformat(feature_cfg.name, "0x%0h.dat", address);
        mem_domain_input           = (src_ram_type_MC==src_ram_type) ? "pri_mem":"sec_mem";
        feature_cfg.width          = width+1;
        feature_cfg.height         = height+1;
        feature_cfg.channel        = channel+1;
        feature_cfg.line_stride    = src_line_stride;
        feature_cfg.surface_stride = src_surface_stride;
        feature_cfg.atomic_memory  = `NVDLA_MEMORY_ATOMIC_SIZE;
        feature_cfg.precision      = precision_e'(in_precision);
        feature_cfg.pattern        = sdp_mrdma_surface_pattern;
        `uvm_info(inst_name, "Generate surface for SDP_M_RDMA ...", UVM_NONE)
        surface_gen.generate_memory_surface_feature(feature_cfg);
        mem_load(fh, mem_domain_input,address,feature_cfg.name,sync_evt_queue[-2]);
        mem_release(fh, mem_domain_input,address,sync_evt_queue[ 0]);
    end
`ifdef NVDLA_SDP_BS_ENABLE
    if(brdma_disable_NO == brdma_disable) begin
        // SDP B-RDMA
        surface_feature_config feature_cfg;
        longint unsigned       address;
        string                 mem_domain_input;
        address                            = {bs_base_addr_high, bs_base_addr_low};
        $sformat(feature_cfg.name, "0x%0h.dat", address);
        mem_domain_input                   = (brdma_ram_type_MC==brdma_ram_type) ? "pri_mem":"sec_mem";
        if(brdma_data_mode == brdma_data_mode_PER_ELEMENT) begin
            feature_cfg.width              = width+1;
            feature_cfg.height             = height+1;
        end else begin
            feature_cfg.width              = 1;
            feature_cfg.height             = 1;
        end
        feature_cfg.channel                = channel+1;
        feature_cfg.line_stride            = bs_line_stride;
        feature_cfg.surface_stride         = bs_surface_stride;
        feature_cfg.atomic_memory          = `NVDLA_MEMORY_ATOMIC_SIZE;
        feature_cfg.component_per_element  = (brdma_data_use_BOTH == brdma_data_use?2:1);
        if(proc_precision_FP16 == proc_precision) begin
            feature_cfg.precision          = precision_e'(proc_precision);
        end else begin
            if(brdma_data_size_ONE_BYTE == brdma_data_size) begin
                feature_cfg.precision      = INT8;
            end else begin
                feature_cfg.precision      = INT16;
            end
        end
        feature_cfg.pattern                = sdp_brdma_surface_pattern;
        `uvm_info(inst_name, "Generate surface for SDP_B_RDMA ...", UVM_NONE)
        surface_gen.generate_memory_surface_feature(feature_cfg);
        mem_load(fh, mem_domain_input,address,feature_cfg.name,sync_evt_queue[-2]);
        mem_release(fh, mem_domain_input,address,sync_evt_queue[ 0]);
    end
`endif
`ifdef NVDLA_SDP_BN_ENABLE
    if(nrdma_disable_NO == nrdma_disable) begin
        // SDP N-RDMA
        surface_feature_config feature_cfg;
        longint unsigned       address;
        string                 mem_domain_input;
        address                            = {bn_base_addr_high, bn_base_addr_low};
        $sformat(feature_cfg.name, "0x%0h.dat", address);
        mem_domain_input                   = (nrdma_ram_type_MC==nrdma_ram_type) ? "pri_mem":"sec_mem";
        if(nrdma_data_mode == nrdma_data_mode_PER_ELEMENT) begin
            feature_cfg.width              = width+1;
            feature_cfg.height             = height+1;
        end else begin
            feature_cfg.width              = 1;
            feature_cfg.height             = 1;
        end
        feature_cfg.channel                = channel+1;
        feature_cfg.line_stride            = bn_line_stride;
        feature_cfg.surface_stride         = bn_surface_stride;
        feature_cfg.atomic_memory          = `NVDLA_MEMORY_ATOMIC_SIZE;
        feature_cfg.component_per_element  = (nrdma_data_use_BOTH==nrdma_data_use?2:1);
        if(proc_precision_FP16 == proc_precision) begin
            feature_cfg.precision          = precision_e'(proc_precision);
        end else begin
            if(nrdma_data_size_ONE_BYTE == nrdma_data_size) begin
                feature_cfg.precision      = INT8;
            end else begin
                feature_cfg.precision      = INT16;
            end
        end
        feature_cfg.pattern                = sdp_nrdma_surface_pattern;
        `uvm_info(inst_name, "Generate surface for SDP_N_RDMA ...", UVM_NONE)
        surface_gen.generate_memory_surface_feature(feature_cfg);
        mem_load(fh, mem_domain_input,address,feature_cfg.name,sync_evt_queue[-2]);
        mem_release(fh, mem_domain_input,address,sync_evt_queue[ 0]);
    end
`endif
`ifdef NVDLA_SDP_EW_ENABLE
    if(erdma_disable_NO == erdma_disable) begin
        // SDP E-RDMA
        surface_feature_config feature_cfg;
        longint unsigned address;
        string mem_domain_input;
        address                            = {ew_base_addr_high, ew_base_addr_low};
        $sformat(feature_cfg.name, "0x%0h.dat", address);
        mem_domain_input                   = (erdma_ram_type_MC==erdma_ram_type) ? "pri_mem":"sec_mem";
        if(erdma_data_mode == erdma_data_mode_PER_ELEMENT) begin
            feature_cfg.width              = width+1;
            feature_cfg.height             = height+1;
        end else begin
            feature_cfg.width              = 1;
            feature_cfg.height             = 1;
        end
        feature_cfg.channel                = channel+1;
        feature_cfg.line_stride            = ew_line_stride;
        feature_cfg.surface_stride         = ew_surface_stride;
        feature_cfg.atomic_memory          = `NVDLA_MEMORY_ATOMIC_SIZE;
        feature_cfg.component_per_element  = (erdma_data_use_BOTH==erdma_data_use?2:1);
        if(proc_precision_FP16 == proc_precision) begin
            feature_cfg.precision          = precision_e'(proc_precision);
        end else begin
            if(erdma_data_size_ONE_BYTE == erdma_data_size) begin
                feature_cfg.precision      = INT8;
            end else begin
                feature_cfg.precision      = INT16;
            end
        end
        feature_cfg.pattern                = sdp_erdma_surface_pattern;
        `uvm_info(inst_name, "Generate surface for SDP_E_RDMA ...", UVM_NONE)
        surface_gen.generate_memory_surface_feature(feature_cfg);
        mem_load(fh, mem_domain_input,address,feature_cfg.name,sync_evt_queue[-2]);
        mem_release(fh, mem_domain_input,address,sync_evt_queue[ 0]);
    end
`endif
endfunction: surface_dump

function void nvdla_sdp_rdma_resource::trace_dump(int fh);
    if(fh==null) begin
        `uvm_fatal(inst_name, "Null handle of trace file ...")
    end
    `uvm_info(inst_name, "Start trace dumping ...", UVM_HIGH)

    surface_dump(fh);

    // if both groups have been used, resource must wait for the group released
    if (get_active_cnt() > 1) begin
        sync_wait(fh,inst_name,sync_evt_queue[-2]);
    end

    reg_write(fh,{inst_name.toupper(),".S_POINTER"},group_to_use);

    begin
        uvm_reg        reg_q[$];
        uvm_reg_data_t val;
        uvm_status_e   status;

        ral.nvdla.NVDLA_SDP_RDMA.get_registers(reg_q);
        reg_q.shuffle();
        foreach(reg_q[i]) begin
            if(reg_q[i].get_rights() != "RW") begin
                continue;
            end
`ifndef NVDLA_SDP_BS_ENABLE
            else if(reg_q[i].get_name().substr(0,4) == "D_BS_") begin
                continue;
            end
            else if(reg_q[i].get_name().substr(0,7) == "D_BRDMA_") begin
                continue;
            end
`endif
`ifndef NVDLA_SDP_BN_ENABLE
            else if(reg_q[i].get_name().substr(0,4) == "D_BN_") begin
                continue;
            end
            else if(reg_q[i].get_name().substr(0,7) == "D_NRDMA_") begin
                continue;
            end
`endif
`ifndef NVDLA_SDP_EW_ENABLE
            else if(reg_q[i].get_name().substr(0,4) == "D_EW_") begin
                continue;
            end
            else if(reg_q[i].get_name().substr(0,7) == "D_ERDMA_") begin
                continue;
            end
`endif
            case(reg_q[i].get_name())
                "D_OP_ENABLE",
                "S_POINTER": ;
                default: reg_write(fh,{inst_name.toupper(),".",reg_q[i].get_name()},int'(reg_q[i].get()));
            endcase
        end
    end
    ral.nvdla.NVDLA_SDP_RDMA.D_OP_ENABLE.set(1);
    reg_write(fh,{inst_name.toupper(),".D_OP_ENABLE"},1);
    `uvm_info(inst_name, "Finish trace dumping ...", UVM_HIGH)
endfunction : trace_dump

constraint nvdla_sdp_rdma_resource::c_ias_stride_alignment {
    // alignment according to atomic size
    src_line_stride    % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    src_surface_stride % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    bs_line_stride     % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    bs_surface_stride  % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    bs_batch_stride    % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    bn_line_stride     % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    bn_surface_stride  % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    bn_batch_stride    % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    ew_line_stride     % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    ew_surface_stride  % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    ew_batch_stride    % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
}

constraint nvdla_sdp_rdma_resource::c_ias_src_mem {
    (width+1)*(height+1)*(channel+1) <= 64'h20_0000;
    if(flying_mode == flying_mode_OFF) {
        if((width==0) && (height==0)) { // 1x1 only support pack mode
            src_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE == (width+64'h1);
            src_surface_stride == src_line_stride*(height+64'h1);
        }
        else {
            src_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE >= (width+64'h1);
            (src_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE - (width+1)) dist { [0:4]:=10, [5:8]:=50, [9:12]:=30, [13:16]:=10};  // 0~256byte
            src_surface_stride >= src_line_stride*(height+64'h1);
            // (src_surface_stride - src_line_stride*(height+64'h1)) dist { [0:4]:=10, [5:8]:=50, [9:12]:=30, [13:16]:=10}; // 0~256byte, conflict with pdp_full_feature_14
            (src_surface_stride - src_line_stride*(height+1)) / `NVDLA_MEMORY_ATOMIC_SIZE dist { 0:=30, ['h1:'h8]:=60, ['h9:'hF]:=60, ['h10:'h7F]:=5, ['h80:'hFF]:=4, ['h100:'1]:=1};
        }
        //  cube size limit: 64MB
        if(in_precision == in_precision_INT8) {
            (src_surface_stride*((channel+1+`NVDLA_MEMORY_ATOMIC_SIZE-1)/`NVDLA_MEMORY_ATOMIC_SIZE))    <= 64'h200_0000;
        }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
        else {
            (src_surface_stride*((channel+1+`NVDLA_MEMORY_ATOMIC_SIZE-1)/(`NVDLA_MEMORY_ATOMIC_SIZE/2))) <= 64'h200_0000;
        }
`endif
    }
}
constraint nvdla_sdp_rdma_resource::c_ias_bs_mem {
    (brdma_disable == brdma_disable_NO) -> {
        // int8 can be one_byte or two_byte
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
        ((proc_precision == proc_precision_INT16) || (proc_precision == proc_precision_FP16))-> { brdma_data_size == brdma_data_size_TWO_BYTE; }
`endif
        if((width==0) && (height==0)) {  // 1x1 Mode requirement
            brdma_data_mode == brdma_data_mode_PER_KERNEL;
        }
    }
    if(brdma_data_mode == brdma_data_mode_PER_ELEMENT) {
        if ( ((brdma_data_size == brdma_data_size_ONE_BYTE) && (brdma_data_use != brdma_data_use_BOTH) && (proc_precision == proc_precision_INT8)) || ((brdma_data_size == brdma_data_size_TWO_BYTE) && (brdma_data_use != brdma_data_use_BOTH) && (proc_precision != proc_precision_INT8)) ) {
            (bs_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE - (width+1)) dist { [0:4]:=10, [5:8]:=50, [9:12]:=30, [13:16]:=10};  // 0~256byte
            bs_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE >= (width+64'h1);
        }
        else if ( (brdma_data_size == brdma_data_size_TWO_BYTE) && (brdma_data_use == brdma_data_use_BOTH) && (proc_precision == proc_precision_INT8) ) {
            (bs_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE - (width+1)*4) dist { [0:4]:=10, [5:8]:=50, [9:12]:=30, [13:16]:=10};  // 0~256byte
            bs_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE >= (width+1)*4;
        }
        else {
            (bs_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE - (width+1)*2) dist { [0:4]:=10, [5:8]:=50, [9:12]:=30, [13:16]:=10};  // 0~256byte
            bs_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE >= (width+1)*2;
        }
        (bs_surface_stride - bs_line_stride*(height+64'h1)) / `NVDLA_MEMORY_ATOMIC_SIZE dist { [0:4]:=10, [5:8]:=50, [9:12]:=30, [13:16]:=10};  // 0~256byte
        bs_surface_stride >= bs_line_stride*(height+64'h1);
    } else {
        // Per kernel
        if ( ((brdma_data_size == brdma_data_size_ONE_BYTE) && (brdma_data_use != brdma_data_use_BOTH) && (proc_precision == proc_precision_INT8)) || ((brdma_data_size == brdma_data_size_TWO_BYTE) && (brdma_data_use != brdma_data_use_BOTH) && (proc_precision != proc_precision_INT8)) ) {
            bs_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE == 1;
        }
        else if ( (brdma_data_size == brdma_data_size_TWO_BYTE) && (brdma_data_use == brdma_data_use_BOTH) && (proc_precision == proc_precision_INT8) ) {
            bs_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE == 4;
        }
        else {
            bs_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE == 2;
        }
        bs_surface_stride == bs_line_stride;
    }
    if(proc_precision == proc_precision_INT8) {
        (bs_surface_stride*((channel+1+`NVDLA_MEMORY_ATOMIC_SIZE-1)/`NVDLA_MEMORY_ATOMIC_SIZE)) <= 64'h200_0000;
    }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    else {
        (bs_surface_stride*((channel+1+`NVDLA_MEMORY_ATOMIC_SIZE/2-1)/(`NVDLA_MEMORY_ATOMIC_SIZE/2))) <= 64'h200_0000;
    }
`endif
}

constraint nvdla_sdp_rdma_resource::c_ias_bn_mem {
    (nrdma_disable == nrdma_disable_NO) -> {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
        ((proc_precision == proc_precision_INT16) || (proc_precision == proc_precision_FP16))-> { nrdma_data_size == nrdma_data_size_TWO_BYTE; }
`endif
        if((width==0) && (height==0)) {  // 1x1 Mode requirement
            nrdma_data_mode == nrdma_data_mode_PER_KERNEL;
        }
    }
    if(nrdma_data_mode == nrdma_data_mode_PER_ELEMENT) {
        if ( ((nrdma_data_size == nrdma_data_size_ONE_BYTE) && (nrdma_data_use != nrdma_data_use_BOTH) && (proc_precision == proc_precision_INT8)) || ((nrdma_data_size == nrdma_data_size_TWO_BYTE) && (nrdma_data_use != nrdma_data_use_BOTH) && (proc_precision != proc_precision_INT8)) ) {
            (bn_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE - (width+1)) dist { [0:4]:=10, [5:8]:=50, [9:12]:=30, [13:16]:=10};  // 0~256byte
            bn_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE >= (width+1);
        }
        else if ( (nrdma_data_size == nrdma_data_size_TWO_BYTE) && (nrdma_data_use == nrdma_data_use_BOTH) && (proc_precision == proc_precision_INT8) ) {
            (bn_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE - (width+1)*4) dist { [0:4]:=10, [5:8]:=50, [9:12]:=30, [13:16]:=10};  // 0~256byte
            bn_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE >= (width+1)*4;
        } else {
            (bn_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE - (width+1)*2) dist { [0:4]:=10, [5:8]:=50, [9:12]:=30, [13:16]:=10};  // 0~256byte
            bn_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE >= (width+1)*2;
        }
        (bn_surface_stride - bn_line_stride*(height+64'h1)) / `NVDLA_MEMORY_ATOMIC_SIZE dist { [0:4]:=10, [5:8]:=50, [9:12]:=30, [13:16]:=10};  // 0~256byte
        bn_surface_stride >= bn_line_stride*(height+64'h1);
    } else {
        // Per kernel
        if ( ((nrdma_data_size == nrdma_data_size_ONE_BYTE) && (nrdma_data_use != nrdma_data_use_BOTH) && (proc_precision == proc_precision_INT8)) || ((nrdma_data_size == nrdma_data_size_TWO_BYTE) && (nrdma_data_use != nrdma_data_use_BOTH) && (proc_precision != proc_precision_INT8)) ) {
            bn_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE == 1;
        }
        else if ( (nrdma_data_size == nrdma_data_size_TWO_BYTE) && (nrdma_data_use == nrdma_data_use_BOTH) && (proc_precision == proc_precision_INT8) ) {
            bn_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE == 4;
        } else {
            bn_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE == 2;
        }
        bn_surface_stride == bn_line_stride;
    }
    if(proc_precision == proc_precision_INT8) {
        (bn_surface_stride*((channel+1+`NVDLA_MEMORY_ATOMIC_SIZE-1)/`NVDLA_MEMORY_ATOMIC_SIZE)) <= 64'h200_0000;
    }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    else {
        (bn_surface_stride*((channel+1+`NVDLA_MEMORY_ATOMIC_SIZE/2-1)/(`NVDLA_MEMORY_ATOMIC_SIZE/2))) <= 64'h200_0000;
    }
`endif
}
constraint nvdla_sdp_rdma_resource::c_ias_ew_mem {
    (erdma_disable == erdma_disable_NO) -> {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
        ((proc_precision == proc_precision_INT16) || (proc_precision == proc_precision_FP16))-> { erdma_data_size == erdma_data_size_TWO_BYTE; }
`endif
        if((width==0) && (height==0)) {  // 1x1 Mode requirement
            erdma_data_mode == erdma_data_mode_PER_KERNEL;
        }
    }
    if(erdma_data_mode == erdma_data_mode_PER_ELEMENT) {
        if ( ((erdma_data_size == erdma_data_size_ONE_BYTE) && (erdma_data_use != erdma_data_use_BOTH) && (proc_precision == proc_precision_INT8)) || ((erdma_data_size == erdma_data_size_TWO_BYTE) && (erdma_data_use != erdma_data_use_BOTH) && (proc_precision != proc_precision_INT8)) ) {
            (ew_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE - (width+1)) dist { [0:4]:=10, [5:8]:=50, [9:12]:=30, [13:16]:=10};  // 0~256byte
            ew_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE >= (width+1);
        }
        else if ( (erdma_data_size == erdma_data_size_TWO_BYTE) && (erdma_data_use == erdma_data_use_BOTH) && (proc_precision == proc_precision_INT8) ) {
            (ew_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE - (width+1)*4) dist { [0:4]:=10, [5:8]:=50, [9:12]:=30, [13:16]:=10};  // 0~256byte
            ew_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE >= (width+1)*4;
        } else {
            (ew_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE - (width+1)*2) dist { [0:4]:=10, [5:8]:=50, [9:12]:=30, [13:16]:=10};  // 0~256byte
            ew_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE >= (width+1)*2;
        }
        (ew_surface_stride - ew_line_stride*(height+64'h1)) / `NVDLA_MEMORY_ATOMIC_SIZE dist { [0:4]:=10, [5:8]:=50, [9:12]:=30, [13:16]:=10};  // 0~256byte
        ew_surface_stride >= ew_line_stride*(height+64'h1);
    } else {
        // Per kernel
        if ( ((erdma_data_size == erdma_data_size_ONE_BYTE) && (erdma_data_use != erdma_data_use_BOTH) && (proc_precision == proc_precision_INT8)) || ((erdma_data_size == erdma_data_size_TWO_BYTE) && (erdma_data_use != erdma_data_use_BOTH) && (proc_precision != proc_precision_INT8)) ) {
            ew_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE == 1;
        }
        else if ( (erdma_data_size == erdma_data_size_TWO_BYTE) && (erdma_data_use == erdma_data_use_BOTH) && (proc_precision == proc_precision_INT8) ) {
            ew_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE == 4;
        } else {
            ew_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE == 2;
        }
        ew_surface_stride == ew_line_stride;
    }
    if(proc_precision == proc_precision_INT8) {
        (ew_surface_stride*((channel+1+`NVDLA_MEMORY_ATOMIC_SIZE-1)/`NVDLA_MEMORY_ATOMIC_SIZE)) <= 64'h200_0000;
    }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    else {
        (ew_surface_stride*((channel+1+`NVDLA_MEMORY_ATOMIC_SIZE/2-1)/(`NVDLA_MEMORY_ATOMIC_SIZE/2))) <= 64'h200_0000;
    }
`endif
}
constraint nvdla_sdp_rdma_resource::c_ias_precision {
    if((winograd == winograd_ON) || (batch_number > 0)) {  // bug 1921999 bug 200314538
        in_precision  == in_precision_t'(proc_precision);
        out_precision == out_precision_t'(proc_precision);
    }
}

constraint nvdla_sdp_rdma_resource::c_ias_dut_por_requirement {
    winograd       == winograd_OFF       ;
    in_precision   == in_precision_INT8  ;
    proc_precision == proc_precision_INT8;
    out_precision  == out_precision_INT8 ;
`ifndef NVDLA_SDP_EW_ENABLE
    erdma_disable  == erdma_disable_YES  ;
`endif
`ifndef NVDLA_SECONDARY_MEMIF_ENABLE
    brdma_ram_type == brdma_ram_type_MC  ;
    nrdma_ram_type == nrdma_ram_type_MC  ;
    erdma_ram_type == erdma_ram_type_MC  ;
    src_ram_type   == src_ram_type_MC    ;
`endif
    batch_number   == 0                  ;
}

constraint nvdla_sdp_rdma_resource::c_sim_src_mem_weight_dist {
    `weight_dist_13bit(width)
    `weight_dist_13bit(height)
    `weight_dist_13bit(channel)

    `weight_dist_32bit(src_base_addr_high)
    `weight_dist_32bit(src_base_addr_low)
    `weight_dist_32bit(src_line_stride)
    `weight_dist_32bit(src_surface_stride)
}

constraint nvdla_sdp_rdma_resource::c_sim_bs_weight_dist {
    `weight_dist_32bit(bs_base_addr_high)
    `weight_dist_32bit(bs_base_addr_low)
    `weight_dist_32bit(bs_line_stride)
    `weight_dist_32bit(bs_surface_stride)
}

constraint nvdla_sdp_rdma_resource::c_sim_bn_weight_dist {
    `weight_dist_32bit(bn_base_addr_high)
    `weight_dist_32bit(bn_base_addr_low)
    `weight_dist_32bit(bn_line_stride)
    `weight_dist_32bit(bn_surface_stride)
}

constraint nvdla_sdp_rdma_resource::c_sim_ew_weight_dist {
    `weight_dist_32bit(ew_base_addr_high)
    `weight_dist_32bit(ew_base_addr_low)
    `weight_dist_32bit(ew_line_stride)
    `weight_dist_32bit(ew_surface_stride)
}

constraint nvdla_sdp_rdma_resource::c_sim_feature_weight_dist {
    `weight_dist_5bit(batch_number)
}



function void nvdla_sdp_rdma_resource::post_randomize();
    set_mem_addr();
    set_register();

    `uvm_info(inst_name, {"\n", sprint()}, UVM_HIGH)
endfunction : post_randomize

function void nvdla_sdp_rdma_resource::set_mem_addr();
    mem_man          mm;
    mem_region       region;
    longint unsigned mem_size;
    string           mem_domain_input;

    mm = mem_man::get_mem_man();

    // M-RDMA
    if (flying_mode == flying_mode_OFF) begin
        mem_domain_input = (src_ram_type_MC==src_ram_type) ? "pri_mem":"sec_mem";
        mem_size         = calc_mem_size(0, 0, channel+1, `NVDLA_MEMORY_ATOMIC_SIZE, src_surface_stride);
        region           = mm.request_region_by_size( mem_domain_input, 
                                                      $sformatf("%s_%0d", "SDP_M_RDMA", get_active_cnt()), 
                                                      mem_size, 
                                                      align_mask[0]);
        {src_base_addr_high, src_base_addr_low} = region.get_start_offset();
    end

    // B-RDMA
    if (!brdma_disable) begin
        mem_domain_input = (brdma_ram_type_MC==brdma_ram_type) ? "pri_mem":"sec_mem";
        mem_size         = calc_mem_size(0, 0, channel+1, `NVDLA_MEMORY_ATOMIC_SIZE, bs_surface_stride);
        region           = mm.request_region_by_size( mem_domain_input, 
                                                      $sformatf("%s_%0d", "SDP_B_RDMA", get_active_cnt()),
                                                      mem_size, 
                                                      align_mask[1]);
        {bs_base_addr_high, bs_base_addr_low} = region.get_start_offset();
    end

    // N-RDMA
    if (!nrdma_disable) begin
        mem_domain_input = (nrdma_ram_type_MC==nrdma_ram_type) ? "pri_mem":"sec_mem";
        mem_size         = calc_mem_size(0, 0, channel+1, `NVDLA_MEMORY_ATOMIC_SIZE, bn_surface_stride);
        region           = mm.request_region_by_size( mem_domain_input, 
                                                      $sformatf("%s_%0d", "SDP_N_RDMA", get_active_cnt()), 
                                                      mem_size, 
                                                      align_mask[2]);
        {bn_base_addr_high, bn_base_addr_low} = region.get_start_offset();
    end

    // E-RDMA
    if (!erdma_disable) begin
        mem_domain_input = (erdma_ram_type_MC==erdma_ram_type) ? "pri_mem":"sec_mem";
        mem_size         = calc_mem_size(0, 0, channel+1, `NVDLA_MEMORY_ATOMIC_SIZE, ew_surface_stride);
        region           = mm.request_region_by_size( mem_domain_input, 
                                                      $sformatf("%s_%0d", "SDP_E_RDMA", get_active_cnt()), 
                                                      mem_size, 
                                                      align_mask[3]);
        {ew_base_addr_high, ew_base_addr_low} = region.get_start_offset();
    end
endfunction : set_mem_addr

function void nvdla_sdp_rdma_resource::set_register();
    //:| spec2cons.ral_set(['NVDLA_SDP_RDMA'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    ral.nvdla.NVDLA_SDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.set(                              width);
    ral.nvdla.NVDLA_SDP_RDMA.D_DATA_CUBE_HEIGHT.HEIGHT.set(                            height);
    ral.nvdla.NVDLA_SDP_RDMA.D_DATA_CUBE_CHANNEL.CHANNEL.set(                          channel);
    ral.nvdla.NVDLA_SDP_RDMA.D_SRC_BASE_ADDR_LOW.SRC_BASE_ADDR_LOW.set(                src_base_addr_low);
    ral.nvdla.NVDLA_SDP_RDMA.D_SRC_BASE_ADDR_HIGH.SRC_BASE_ADDR_HIGH.set(              src_base_addr_high);
    ral.nvdla.NVDLA_SDP_RDMA.D_SRC_LINE_STRIDE.SRC_LINE_STRIDE.set(                    src_line_stride);
    ral.nvdla.NVDLA_SDP_RDMA.D_SRC_SURFACE_STRIDE.SRC_SURFACE_STRIDE.set(              src_surface_stride);
    ral.nvdla.NVDLA_SDP_RDMA.D_BRDMA_CFG.BRDMA_DISABLE.set(                            brdma_disable);
    ral.nvdla.NVDLA_SDP_RDMA.D_BRDMA_CFG.BRDMA_DATA_USE.set(                           brdma_data_use);
    ral.nvdla.NVDLA_SDP_RDMA.D_BRDMA_CFG.BRDMA_DATA_SIZE.set(                          brdma_data_size);
    ral.nvdla.NVDLA_SDP_RDMA.D_BRDMA_CFG.BRDMA_DATA_MODE.set(                          brdma_data_mode);
    ral.nvdla.NVDLA_SDP_RDMA.D_BRDMA_CFG.BRDMA_RAM_TYPE.set(                           brdma_ram_type);
    ral.nvdla.NVDLA_SDP_RDMA.D_BS_BASE_ADDR_LOW.BS_BASE_ADDR_LOW.set(                  bs_base_addr_low);
    ral.nvdla.NVDLA_SDP_RDMA.D_BS_BASE_ADDR_HIGH.BS_BASE_ADDR_HIGH.set(                bs_base_addr_high);
    ral.nvdla.NVDLA_SDP_RDMA.D_BS_LINE_STRIDE.BS_LINE_STRIDE.set(                      bs_line_stride);
    ral.nvdla.NVDLA_SDP_RDMA.D_BS_SURFACE_STRIDE.BS_SURFACE_STRIDE.set(                bs_surface_stride);
    ral.nvdla.NVDLA_SDP_RDMA.D_BS_BATCH_STRIDE.BS_BATCH_STRIDE.set(                    bs_batch_stride);
    ral.nvdla.NVDLA_SDP_RDMA.D_NRDMA_CFG.NRDMA_DISABLE.set(                            nrdma_disable);
    ral.nvdla.NVDLA_SDP_RDMA.D_NRDMA_CFG.NRDMA_DATA_USE.set(                           nrdma_data_use);
    ral.nvdla.NVDLA_SDP_RDMA.D_NRDMA_CFG.NRDMA_DATA_SIZE.set(                          nrdma_data_size);
    ral.nvdla.NVDLA_SDP_RDMA.D_NRDMA_CFG.NRDMA_DATA_MODE.set(                          nrdma_data_mode);
    ral.nvdla.NVDLA_SDP_RDMA.D_NRDMA_CFG.NRDMA_RAM_TYPE.set(                           nrdma_ram_type);
    ral.nvdla.NVDLA_SDP_RDMA.D_BN_BASE_ADDR_LOW.BN_BASE_ADDR_LOW.set(                  bn_base_addr_low);
    ral.nvdla.NVDLA_SDP_RDMA.D_BN_BASE_ADDR_HIGH.BN_BASE_ADDR_HIGH.set(                bn_base_addr_high);
    ral.nvdla.NVDLA_SDP_RDMA.D_BN_LINE_STRIDE.BN_LINE_STRIDE.set(                      bn_line_stride);
    ral.nvdla.NVDLA_SDP_RDMA.D_BN_SURFACE_STRIDE.BN_SURFACE_STRIDE.set(                bn_surface_stride);
    ral.nvdla.NVDLA_SDP_RDMA.D_BN_BATCH_STRIDE.BN_BATCH_STRIDE.set(                    bn_batch_stride);
    ral.nvdla.NVDLA_SDP_RDMA.D_ERDMA_CFG.ERDMA_DISABLE.set(                            erdma_disable);
    ral.nvdla.NVDLA_SDP_RDMA.D_ERDMA_CFG.ERDMA_DATA_USE.set(                           erdma_data_use);
    ral.nvdla.NVDLA_SDP_RDMA.D_ERDMA_CFG.ERDMA_DATA_SIZE.set(                          erdma_data_size);
    ral.nvdla.NVDLA_SDP_RDMA.D_ERDMA_CFG.ERDMA_DATA_MODE.set(                          erdma_data_mode);
    ral.nvdla.NVDLA_SDP_RDMA.D_ERDMA_CFG.ERDMA_RAM_TYPE.set(                           erdma_ram_type);
    ral.nvdla.NVDLA_SDP_RDMA.D_EW_BASE_ADDR_LOW.EW_BASE_ADDR_LOW.set(                  ew_base_addr_low);
    ral.nvdla.NVDLA_SDP_RDMA.D_EW_BASE_ADDR_HIGH.EW_BASE_ADDR_HIGH.set(                ew_base_addr_high);
    ral.nvdla.NVDLA_SDP_RDMA.D_EW_LINE_STRIDE.EW_LINE_STRIDE.set(                      ew_line_stride);
    ral.nvdla.NVDLA_SDP_RDMA.D_EW_SURFACE_STRIDE.EW_SURFACE_STRIDE.set(                ew_surface_stride);
    ral.nvdla.NVDLA_SDP_RDMA.D_EW_BATCH_STRIDE.EW_BATCH_STRIDE.set(                    ew_batch_stride);
    ral.nvdla.NVDLA_SDP_RDMA.D_FEATURE_MODE_CFG.FLYING_MODE.set(                       flying_mode);
    ral.nvdla.NVDLA_SDP_RDMA.D_FEATURE_MODE_CFG.WINOGRAD.set(                          winograd);
    ral.nvdla.NVDLA_SDP_RDMA.D_FEATURE_MODE_CFG.IN_PRECISION.set(                      in_precision);
    ral.nvdla.NVDLA_SDP_RDMA.D_FEATURE_MODE_CFG.PROC_PRECISION.set(                    proc_precision);
    ral.nvdla.NVDLA_SDP_RDMA.D_FEATURE_MODE_CFG.OUT_PRECISION.set(                     out_precision);
    ral.nvdla.NVDLA_SDP_RDMA.D_FEATURE_MODE_CFG.BATCH_NUMBER.set(                      batch_number);
    ral.nvdla.NVDLA_SDP_RDMA.D_SRC_DMA_CFG.SRC_RAM_TYPE.set(                           src_ram_type);
    ral.nvdla.NVDLA_SDP_RDMA.D_PERF_ENABLE.PERF_DMA_EN.set(                            perf_dma_en);
    ral.nvdla.NVDLA_SDP_RDMA.D_PERF_ENABLE.PERF_NAN_INF_COUNT_EN.set(                  perf_nan_inf_count_en);
    //:) epython: generated_end (DO NOT EDIT ABOVE)
endfunction : set_register

`endif //_NVDLA_SDP_RDMA_RESOURCE_SV_
