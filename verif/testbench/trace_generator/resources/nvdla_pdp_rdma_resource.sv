`ifndef _NVDLA_PDP_RDMA_RESOURCE_SV_
`define _NVDLA_PDP_RDMA_RESOURCE_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_pdp_rdma_resource
//
// @description: resource class of PDP
//-------------------------------------------------------------------------------------

class nvdla_pdp_rdma_resource extends nvdla_base_resource;
    // singleton handle
    static local nvdla_pdp_rdma_resource inst;

    string pdp_rdma_surface_pattern    = "random";
    // enum define
    //:| import spec2constrain
    //:| global spec2cons
    //:| spec2cons = spec2constrain.Spec2Cons()
    //:| spec2cons.enum_gen(['NVDLA_PDP_RDMA'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    typedef enum{ flying_mode_ON_FLYING            = 'h0
                 ,flying_mode_OFF_FLYING           = 'h1
                } flying_mode_t;
    typedef enum{ src_ram_type_CV                  = 'h0
                 ,src_ram_type_MC                  = 'h1
                } src_ram_type_t;
    typedef enum{ input_data_INT8                  = 'h0
                 ,input_data_INT16                 = 'h1
                 ,input_data_FP16                  = 'h2
                } input_data_t;
    typedef enum{ kernel_width_KERNEL_WIDTH_1      = 'h0
                 ,kernel_width_KERNEL_WIDTH_2      = 'h1
                 ,kernel_width_KERNEL_WIDTH_3      = 'h2
                 ,kernel_width_KERNEL_WIDTH_4      = 'h3
                 ,kernel_width_KERNEL_WIDTH_5      = 'h4
                 ,kernel_width_KERNEL_WIDTH_6      = 'h5
                 ,kernel_width_KERNEL_WIDTH_7      = 'h6
                 ,kernel_width_KERNEL_WIDTH_8      = 'h7
                } kernel_width_t;
    typedef enum{ dma_en_DISABLE                   = 'h0
                 ,dma_en_ENABLE                    = 'h1
                } dma_en_t;
    //:) epython: generated_end (DO NOT EDIT ABOVE)

    // field variables
    //:| spec2cons.state_gen(['NVDLA_PDP_RDMA'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    rand bit [12:0]                 cube_in_width;
    rand bit [12:0]                 cube_in_height;
    rand bit [12:0]                 cube_in_channel;
    rand flying_mode_t              flying_mode;
    rand bit [31:0]                 src_base_addr_low;
    rand bit [31:0]                 src_base_addr_high;
    rand bit [31:0]                 src_line_stride;
    rand bit [31:0]                 src_surface_stride;
    rand src_ram_type_t             src_ram_type;
    rand input_data_t               input_data;
    rand bit [7:0]                  split_num;
    rand kernel_width_t             kernel_width;
    rand bit [3:0]                  kernel_stride_width;
    rand bit [3:0]                  pad_width;
    rand bit [9:0]                  partial_width_in_first;
    rand bit [9:0]                  partial_width_in_last;
    rand bit [9:0]                  partial_width_in_mid;
    rand dma_en_t                   dma_en;
    rand bit [31:0]                 cya;
    //:) epython: generated_end (DO NOT EDIT ABOVE)

    /*
        constraints:
            * ias_constraint: mandatory constraints from architecture requirement
            * sim_constraint: optional constraints for simulation only
    */
    extern constraint c_ias_stride_alignment;
    extern constraint c_ias_cube_size;
    extern constraint c_ias_src_mem;
    extern constraint c_ias_kernel_size;
    extern constraint c_ias_dut_por_requirement;

    extern constraint c_sim_cube_size_weight_dist;
    extern constraint c_sim_src_mem_weight_dist;
    extern constraint c_sim_partial_size_in_weight_dist;
    extern constraint c_sim_kernel_size_weight_dist;
    extern constraint res_pdp_rdma_ias_constraint_for_demo;

    /*
        Methods
    */
    extern function         new(string name="nvdla_pdp_rdma_resource", uvm_component parent);
    extern static function  nvdla_pdp_rdma_resource get_pdp_rdma(uvm_component parent);
    extern function void    trace_dump(int fh);
    extern function void    set_mem_addr();
    extern function void    surface_dump(int fh);
    extern function void    set_register();
    extern function void    post_randomize();

    `uvm_component_utils_begin(nvdla_pdp_rdma_resource)
        `uvm_field_string(pdp_rdma_surface_pattern, UVM_ALL_ON)
        //:| spec2cons.macro_gen(['NVDLA_PDP_RDMA'])
        //:) epython: generated_beg (DO NOT EDIT BELOW)
        `uvm_field_int(cube_in_width,                                  UVM_ALL_ON)
        `uvm_field_int(cube_in_height,                                 UVM_ALL_ON)
        `uvm_field_int(cube_in_channel,                                UVM_ALL_ON)
        `uvm_field_enum(flying_mode_t,            flying_mode,         UVM_ALL_ON)
        `uvm_field_int(src_base_addr_low,                              UVM_ALL_ON)
        `uvm_field_int(src_base_addr_high,                             UVM_ALL_ON)
        `uvm_field_int(src_line_stride,                                UVM_ALL_ON)
        `uvm_field_int(src_surface_stride,                             UVM_ALL_ON)
        `uvm_field_enum(src_ram_type_t,           src_ram_type,        UVM_ALL_ON)
        `uvm_field_enum(input_data_t,             input_data,          UVM_ALL_ON)
        `uvm_field_int(split_num,                                      UVM_ALL_ON)
        `uvm_field_enum(kernel_width_t,           kernel_width,        UVM_ALL_ON)
        `uvm_field_int(kernel_stride_width,                            UVM_ALL_ON)
        `uvm_field_int(pad_width,                                      UVM_ALL_ON)
        `uvm_field_int(partial_width_in_first,                         UVM_ALL_ON)
        `uvm_field_int(partial_width_in_last,                          UVM_ALL_ON)
        `uvm_field_int(partial_width_in_mid,                           UVM_ALL_ON)
        `uvm_field_enum(dma_en_t,                 dma_en,              UVM_ALL_ON)
        `uvm_field_int(cya,                                            UVM_ALL_ON)
        //:) epython: generated_end (DO NOT EDIT ABOVE)
    `uvm_component_utils_end

endclass : nvdla_pdp_rdma_resource

function nvdla_pdp_rdma_resource::new(string name="nvdla_pdp_rdma_resource", uvm_component parent);
    super.new(name, parent);
    `uvm_info(inst_name, $sformatf("Initialize resource %s ...",inst_name),UVM_LOW)
endfunction: new

static function nvdla_pdp_rdma_resource nvdla_pdp_rdma_resource::get_pdp_rdma(uvm_component parent);
    if (null == inst) begin
        inst = new("NVDLA_PDP_RDMA", parent);
    end
    return inst;
endfunction: get_pdp_rdma

function void nvdla_pdp_rdma_resource::trace_dump(int fh);
    if(fh==null) begin
        `uvm_fatal(inst_name, "Null handle of trace file ...")
    end
    `uvm_info(inst_name, "Start trace dumping ...", UVM_HIGH)

    surface_dump(fh);

    // if both groups have been used, resource must wait for the same group released
    if (get_active_cnt > 1) begin
        sync_wait(fh,inst_name,sync_evt_queue[-2]);
    end

    reg_write(fh,{inst_name.toupper(),".S_POINTER"},group_to_use);

    begin
        uvm_reg        reg_q[$];
        uvm_reg_data_t val;
        uvm_status_e   status;

        ral.nvdla.NVDLA_PDP_RDMA.get_registers(reg_q);
        reg_q.shuffle();
        foreach(reg_q[i]) begin
            if(reg_q[i].get_rights() != "RW") begin
                continue;
            end
            case(reg_q[i].get_name())
                "D_OP_ENABLE",
                "S_POINTER": ;
                default: reg_write(fh,{inst_name.toupper(),".",reg_q[i].get_name()},int'(reg_q[i].get()));
            endcase
        end
    end
    ral.nvdla.NVDLA_PDP_RDMA.D_OP_ENABLE.set(1);
    reg_write(fh,{inst_name.toupper(),".D_OP_ENABLE"},1);
    `uvm_info(inst_name, "Finish trace dumping ...", UVM_HIGH)
endfunction: trace_dump

function void nvdla_pdp_rdma_resource::surface_dump(int fh);
    surface_feature_config feature_cfg;
    surface_feature_config feature_cfg_output;
    longint unsigned       address;
    string                 mem_domain_input;
    // Get surface setting fro resource register
    // string name;
    // int unsigned width; int unsigned height;int unsigned channel; int unsigned batch;
    // int unsigned line_stride; int unsigned surface_stride; int unsigned batch_stride=1;
    // int unsigned atomic_memory=8; int unsigned component_per_element=1;
    // precision_e precision=INT8;
    // string pattern="random";
    address                    = {src_base_addr_high, src_base_addr_low};
    $sformat(feature_cfg.name, "0x%0h.dat", address);
    mem_domain_input           = (src_ram_type_MC == src_ram_type) ? "pri_mem":"sec_mem";
    feature_cfg.width          = cube_in_width+1;
    feature_cfg.height         = cube_in_height+1;
    feature_cfg.channel        = cube_in_channel+1;
    feature_cfg.line_stride    = src_line_stride;
    feature_cfg.surface_stride = src_surface_stride;
    feature_cfg.atomic_memory  = `NVDLA_MEMORY_ATOMIC_SIZE;
    feature_cfg.precision      = precision_e'(input_data);
    feature_cfg.pattern        = pdp_rdma_surface_pattern;
    surface_gen.generate_memory_surface_feature(feature_cfg);
    mem_load(fh, mem_domain_input,address,feature_cfg.name,sync_evt_queue[-2]);
    mem_release(fh, mem_domain_input,address,sync_evt_queue[ 0]);
endfunction: surface_dump

function void nvdla_pdp_rdma_resource::set_mem_addr();
    mem_man          mm;
    mem_region       region;
    longint unsigned mem_size;
    string           mem_domain_input;

    mm = mem_man::get_mem_man();

    // RDMA
    mem_domain_input = (src_ram_type_MC == src_ram_type) ? "pri_mem":"sec_mem";
    mem_size         = calc_mem_size(0, 0, cube_in_channel+1, `NVDLA_MEMORY_ATOMIC_SIZE, src_surface_stride);
    region           = mm.request_region_by_size( mem_domain_input, 
                                                  $sformatf("%s_%0d", "PDP_RDMA", get_active_cnt()), 
                                                  mem_size, 
                                                  align_mask[0]);
    {src_base_addr_high, src_base_addr_low} = region.get_start_offset();
endfunction : set_mem_addr

constraint nvdla_pdp_rdma_resource::c_ias_stride_alignment {
    // ATOMIC SIZE alignment
    src_line_stride    % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    src_surface_stride % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
}

constraint nvdla_pdp_rdma_resource::c_ias_cube_size {
    (cube_in_width+1)*(cube_in_height+1)*(cube_in_channel+1) <= 64'h80_0000;
}

constraint nvdla_pdp_rdma_resource::c_ias_src_mem {
    src_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE >= cube_in_width+64'h1;
    (src_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE - (cube_in_width+1)) dist { 0:=30, ['h1:'hF]:=45, ['h10:'h7F]:=20, ['h80:'hFF]:=5};
    src_surface_stride >= src_line_stride*(cube_in_height+64'h1);
    (src_surface_stride - src_line_stride*(cube_in_height+1)) / `NVDLA_MEMORY_ATOMIC_SIZE  dist { 0:=30, ['h1:'hF]:=45, ['h10:'h7F]:=20, ['h80:'hFF]:=5};
    (src_surface_stride*(cube_in_channel+1)) / `NVDLA_MEMORY_ATOMIC_SIZE <= 64'h10_0000;

}

constraint nvdla_pdp_rdma_resource::c_ias_kernel_size {
    pad_width      inside {[3'h0:3'h7]};
}

constraint nvdla_pdp_rdma_resource::c_ias_dut_por_requirement {
`ifndef NVDLA_SECONDARY_MEMIF_ENABLE
    src_ram_type == src_ram_type_MC ;
`endif
    input_data   == input_data_INT8 ;
}

constraint nvdla_pdp_rdma_resource::c_sim_cube_size_weight_dist {
    `weight_dist_13bit(cube_in_width)
    `weight_dist_13bit(cube_in_height)
    `weight_dist_13bit(cube_in_channel)
}

constraint nvdla_pdp_rdma_resource::c_sim_src_mem_weight_dist {
    `weight_dist_32bit(src_base_addr_low)
    `weight_dist_32bit(src_base_addr_high)
    `weight_dist_32bit(src_line_stride)
    `weight_dist_32bit(src_surface_stride)
}

constraint nvdla_pdp_rdma_resource::c_sim_partial_size_in_weight_dist {
    `weight_dist_10bit(partial_width_in_first)
    `weight_dist_10bit(partial_width_in_mid)
    `weight_dist_10bit(partial_width_in_last)
}

constraint nvdla_pdp_rdma_resource::c_sim_kernel_size_weight_dist {
    `weight_dist_8bit(split_num)
}

constraint nvdla_pdp_rdma_resource::res_pdp_rdma_ias_constraint_for_demo {
}

function void nvdla_pdp_rdma_resource::set_register();
    //:| spec2cons.ral_set(['NVDLA_PDP_RDMA'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    ral.nvdla.NVDLA_PDP_RDMA.D_DATA_CUBE_IN_WIDTH.CUBE_IN_WIDTH.set(                   cube_in_width);
    ral.nvdla.NVDLA_PDP_RDMA.D_DATA_CUBE_IN_HEIGHT.CUBE_IN_HEIGHT.set(                 cube_in_height);
    ral.nvdla.NVDLA_PDP_RDMA.D_DATA_CUBE_IN_CHANNEL.CUBE_IN_CHANNEL.set(               cube_in_channel);
    ral.nvdla.NVDLA_PDP_RDMA.D_FLYING_MODE.FLYING_MODE.set(                            flying_mode);
    ral.nvdla.NVDLA_PDP_RDMA.D_SRC_BASE_ADDR_LOW.SRC_BASE_ADDR_LOW.set(                src_base_addr_low);
    ral.nvdla.NVDLA_PDP_RDMA.D_SRC_BASE_ADDR_HIGH.SRC_BASE_ADDR_HIGH.set(              src_base_addr_high);
    ral.nvdla.NVDLA_PDP_RDMA.D_SRC_LINE_STRIDE.SRC_LINE_STRIDE.set(                    src_line_stride);
    ral.nvdla.NVDLA_PDP_RDMA.D_SRC_SURFACE_STRIDE.SRC_SURFACE_STRIDE.set(              src_surface_stride);
    ral.nvdla.NVDLA_PDP_RDMA.D_SRC_RAM_CFG.SRC_RAM_TYPE.set(                           src_ram_type);
    ral.nvdla.NVDLA_PDP_RDMA.D_DATA_FORMAT.INPUT_DATA.set(                             input_data);
    ral.nvdla.NVDLA_PDP_RDMA.D_OPERATION_MODE_CFG.SPLIT_NUM.set(                       split_num);
    ral.nvdla.NVDLA_PDP_RDMA.D_POOLING_KERNEL_CFG.KERNEL_WIDTH.set(                    kernel_width);
    ral.nvdla.NVDLA_PDP_RDMA.D_POOLING_KERNEL_CFG.KERNEL_STRIDE_WIDTH.set(             kernel_stride_width);
    ral.nvdla.NVDLA_PDP_RDMA.D_POOLING_PADDING_CFG.PAD_WIDTH.set(                      pad_width);
    ral.nvdla.NVDLA_PDP_RDMA.D_PARTIAL_WIDTH_IN.PARTIAL_WIDTH_IN_FIRST.set(            partial_width_in_first);
    ral.nvdla.NVDLA_PDP_RDMA.D_PARTIAL_WIDTH_IN.PARTIAL_WIDTH_IN_LAST.set(             partial_width_in_last);
    ral.nvdla.NVDLA_PDP_RDMA.D_PARTIAL_WIDTH_IN.PARTIAL_WIDTH_IN_MID.set(              partial_width_in_mid);
    ral.nvdla.NVDLA_PDP_RDMA.D_PERF_ENABLE.DMA_EN.set(                                 dma_en);
    ral.nvdla.NVDLA_PDP_RDMA.D_CYA.CYA.set(                                            cya);
    //:) epython: generated_end (DO NOT EDIT ABOVE)
endfunction : set_register

function void nvdla_pdp_rdma_resource::post_randomize();
    set_mem_addr();
    set_register();

    `uvm_info(inst_name, {"\n", sprint()}, UVM_HIGH)
endfunction : post_randomize

`endif //_NVDLA_PDP_RDMA_RESOURCE_SV_
