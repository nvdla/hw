`ifndef _NVDLA_CDP_RDMA_RESOURCE_SV_
`define _NVDLA_CDP_RDMA_RESOURCE_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_cdp_rdma_resource
//
// @description: various hardware resources of cdp sub module
//-------------------------------------------------------------------------------------

typedef class nvdla_cdp_resource;

class nvdla_cdp_rdma_resource extends nvdla_base_resource;
    // singleton handle
    static local nvdla_cdp_rdma_resource inst;

    string  cdp_rdma_surface_pattern    = "random";
    string  cdp_cube_size               = "NORMAL";
    // enum define
    //:| import spec2constrain
    //:| global spec2cons
    //:| spec2cons = spec2constrain.Spec2Cons()
    //:| spec2cons.enum_gen(['NVDLA_CDP_RDMA'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    typedef enum{ src_ram_type_CV                  = 'h0
                 ,src_ram_type_MC                  = 'h1
                } src_ram_type_t;
    typedef enum{ input_data_INT8                  = 'h0
                 ,input_data_INT16                 = 'h1
                 ,input_data_FP16                  = 'h2
                } input_data_t;
    typedef enum{ dma_en_DISABLE                   = 'h0
                 ,dma_en_ENABLE                    = 'h1
                } dma_en_t;
    //:) epython: generated_end (DO NOT EDIT ABOVE)

    // field variables
    //:| spec2cons.state_gen(['NVDLA_CDP_RDMA'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    rand bit [12:0]                 width;
    rand bit [12:0]                 height;
    rand bit [12:0]                 channel;
    rand bit [31:0]                 src_base_addr_low;
    rand bit [31:0]                 src_base_addr_high;
    rand bit [31:0]                 src_line_stride;
    rand bit [31:0]                 src_surface_stride;
    rand src_ram_type_t             src_ram_type;
    rand input_data_t               input_data;
    rand dma_en_t                   dma_en;
    rand bit [31:0]                 cya;
    //:) epython: generated_end (DO NOT EDIT ABOVE)

    `uvm_component_utils_begin(nvdla_cdp_rdma_resource)
        `uvm_field_string(cdp_rdma_surface_pattern, UVM_ALL_ON)
        `uvm_field_string(cdp_cube_size,            UVM_ALL_ON)
        //:| spec2cons.macro_gen(['NVDLA_CDP_RDMA'])
        //:) epython: generated_beg (DO NOT EDIT BELOW)
        `uvm_field_int(width,                                          UVM_ALL_ON)
        `uvm_field_int(height,                                         UVM_ALL_ON)
        `uvm_field_int(channel,                                        UVM_ALL_ON)
        `uvm_field_int(src_base_addr_low,                              UVM_ALL_ON)
        `uvm_field_int(src_base_addr_high,                             UVM_ALL_ON)
        `uvm_field_int(src_line_stride,                                UVM_ALL_ON)
        `uvm_field_int(src_surface_stride,                             UVM_ALL_ON)
        `uvm_field_enum(src_ram_type_t,           src_ram_type,        UVM_ALL_ON)
        `uvm_field_enum(input_data_t,             input_data,          UVM_ALL_ON)
        `uvm_field_enum(dma_en_t,                 dma_en,              UVM_ALL_ON)
        `uvm_field_int(cya,                                            UVM_ALL_ON)
        //:) epython: generated_end (DO NOT EDIT ABOVE)
    `uvm_component_utils_end

    /*
        Methods
    */
    extern function         new(string name="nvdla_cdp_rdma_resource", uvm_component parent);
    extern static function  nvdla_cdp_rdma_resource get_cdp_rdma(uvm_component parent);
    extern function void    trace_dump(int fh);
    extern function void    set_mem_addr();
    extern function void    surface_dump(int fh);
    extern function void    set_register();
    extern function void    pre_randomize();
    extern function void    post_randomize();
    extern function void    set_sim_constraint();

    /*
        constraints:
            * ias_constraint: mandatory constraints from architecture requirement
            * sim_constraint: optional constraints for simulation only
    */
    // ias constraint
    extern constraint c_ias_stride_alignment;
    extern constraint c_ias_src_mem;
    extern constraint c_ias_dut_por_requirement;

    // sim constraint
    extern constraint c_sim_src_cube_size;
    extern constraint c_sim_cube_size_small;
    extern constraint c_sim_cube_size_medium;
    extern constraint c_sim_cube_size_large;
    extern constraint c_sim_cube_size_normal;
    extern constraint c_sim_solve_height_before_width;
    extern constraint c_sim_solve_channel_before_width;

endclass : nvdla_cdp_rdma_resource

function nvdla_cdp_rdma_resource::new(string name="nvdla_cdp_rdma_resource", uvm_component parent);
    super.new(name, parent);
    `uvm_info(inst_name, $sformatf("Initialize resource %s ... ",inst_name),UVM_LOW);
endfunction: new

static function  nvdla_cdp_rdma_resource nvdla_cdp_rdma_resource::get_cdp_rdma(uvm_component parent);
    if (null == inst) begin
        inst = new("NVDLA_CDP_RDMA", parent);
    end
    return inst;
endfunction: get_cdp_rdma

function void nvdla_cdp_rdma_resource::surface_dump(int fh);
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
    feature_cfg.width          = width+1;
    feature_cfg.height         = height+1;
    feature_cfg.channel        = channel+1;
    feature_cfg.line_stride    = src_line_stride;
    feature_cfg.surface_stride = src_surface_stride;
    feature_cfg.atomic_memory  = `NVDLA_MEMORY_ATOMIC_SIZE;
    feature_cfg.precision      = precision_e'(input_data);
    feature_cfg.pattern        = cdp_rdma_surface_pattern;
    surface_gen.generate_memory_surface_feature(feature_cfg);
    mem_load(fh, mem_domain_input,address,feature_cfg.name,sync_evt_queue[-2]);
    mem_release(fh, mem_domain_input,address,sync_evt_queue[ 0]);
endfunction: surface_dump

function void nvdla_cdp_rdma_resource::set_mem_addr();
    mem_man          mm;
    mem_region       region;
    longint unsigned mem_size;
    string           mem_domain_input;

    mm               = mem_man::get_mem_man();

    // RDMA
    mem_domain_input = (src_ram_type_MC == src_ram_type) ? "pri_mem":"sec_mem";
    mem_size         = calc_mem_size(0, 0, channel+1, `NVDLA_MEMORY_ATOMIC_SIZE, src_surface_stride);
    region           = mm.request_region_by_size( mem_domain_input, 
                                                  $sformatf("%s_%0d", "CDP_RDMA", get_active_cnt()), 
                                                  mem_size, 
                                                  align_mask[0]);
    {src_base_addr_high, src_base_addr_low} = region.get_start_offset();
endfunction : set_mem_addr

function void nvdla_cdp_rdma_resource::trace_dump(int fh);
    if(fh==null) begin
        `uvm_fatal(inst_name, "Null handle of trace file ...")
    end
    `uvm_info(inst_name, "Start trace dumping ...", UVM_HIGH)

    surface_dump(fh);

    // if both groups have been used, resource must wait for the group released
    if (get_active_cnt() > 1) begin
        sync_wait(fh,inst_name, sync_evt_queue[-2]);
    end

    reg_write(fh,{inst_name.toupper(),".S_POINTER"},group_to_use);

    begin
        uvm_reg        reg_q[$];
        uvm_reg_data_t val;
        uvm_status_e   status;

        ral.nvdla.NVDLA_CDP_RDMA.get_registers(reg_q);
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
    ral.nvdla.NVDLA_CDP_RDMA.D_OP_ENABLE.set(1);
    reg_write(fh,{inst_name.toupper(),".D_OP_ENABLE"},1);
    `uvm_info(inst_name, "Finish trace dumping ...", UVM_HIGH)
endfunction : trace_dump

constraint nvdla_cdp_rdma_resource::c_ias_stride_alignment {
    // alignment according to atomic size
    src_line_stride    % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    src_surface_stride % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
}

constraint nvdla_cdp_rdma_resource::c_ias_src_mem {
    src_line_stride     >= (width+64'h1)*`NVDLA_MEMORY_ATOMIC_SIZE;
    src_surface_stride  >= src_line_stride*(height+64'h1);
    (src_surface_stride - src_line_stride*(height+64'h1)) / `NVDLA_MEMORY_ATOMIC_SIZE dist { 0:=30, ['h1:'hF]:=60, ['h10:'h7F]:=5, ['h80:'hFF]:=4, ['h100:'1]:=1};

}

constraint nvdla_cdp_rdma_resource::c_ias_dut_por_requirement {
    input_data   == input_data_INT8;
`ifndef NVDLA_SECONDARY_MEMIF_ENABLE
    src_ram_type == src_ram_type_MC;
`endif
}

constraint nvdla_cdp_rdma_resource::c_sim_src_cube_size {
    // Total size shall be less then 16 MiB
    if (input_data == input_data_INT8) {
        src_surface_stride * ((channel+1+`NVDLA_MEMORY_ATOMIC_SIZE-1) / `NVDLA_MEMORY_ATOMIC_SIZE)      <= 64'h100_0000;
    } else {
        src_surface_stride * ((channel+1+`NVDLA_MEMORY_ATOMIC_SIZE/2-1) / (`NVDLA_MEMORY_ATOMIC_SIZE/2)) <= 64'h100_0000;
    }
}

constraint nvdla_cdp_rdma_resource::c_sim_cube_size_small {
    width   inside {[0:'h1F]};
    height  inside {[0:'h1F]};
    channel inside {[0:'h1F]};
    (width+1)*(height+1)*(channel+1)    <= 64'h8000;
}

constraint nvdla_cdp_rdma_resource::c_sim_cube_size_medium {
    width   inside {[0:'h7F]};
    height  inside {[0:'h7F]};
    channel inside {[0:'h7F]};
    (width+1)*(height+1)*(channel+1)    >  64'h8000;
    (width+1)*(height+1)*(channel+1)    <= 64'h2_0000;
}

constraint nvdla_cdp_rdma_resource::c_sim_cube_size_large {
    width   inside {[0:'h1FFF]};
    height  inside {[0:'h1FFF]};
    channel inside {[0:'h1FFF]};
    (width+1)*(height+1)*(channel+1)    > 64'h2_0000;
    (width+1)*(height+1)*(channel+1)    <= 64'h20_0000;
}

constraint nvdla_cdp_rdma_resource::c_sim_cube_size_normal {
    (width+1)*(height+1)*(channel+1) <= 64'h4_0000;
}

constraint nvdla_cdp_rdma_resource::c_sim_solve_height_before_width {
    solve height before width;
}

constraint nvdla_cdp_rdma_resource::c_sim_solve_channel_before_width {
    solve channel before width;
}

function void nvdla_cdp_rdma_resource::pre_randomize();
    super.pre_randomize();
    c_sim_solve_height_before_width.constraint_mode($urandom_range(0, 1));
    c_sim_solve_channel_before_width.constraint_mode($urandom_range(0, 1));
endfunction : pre_randomize

function void nvdla_cdp_rdma_resource::post_randomize();
    set_mem_addr();
    set_register();

    `uvm_info(inst_name, {"\n", sprint()}, UVM_HIGH)
endfunction : post_randomize

function void nvdla_cdp_rdma_resource::set_sim_constraint();
    `uvm_info(inst_name, $sformatf("set sim constraint constraint"), UVM_LOW)
    if ("SMALL"== cdp_cube_size.toupper()) begin
        c_sim_cube_size_small.constraint_mode(1);
        c_sim_cube_size_medium.constraint_mode(0);
        c_sim_cube_size_large.constraint_mode(0);
        c_sim_cube_size_normal.constraint_mode(0);
    end else if ("MEDIUM"== cdp_cube_size.toupper()) begin
        c_sim_cube_size_small.constraint_mode(0);
        c_sim_cube_size_medium.constraint_mode(1);
        c_sim_cube_size_large.constraint_mode(0);
        c_sim_cube_size_normal.constraint_mode(0);
    end else if ("LARGE"== cdp_cube_size.toupper()) begin
        c_sim_cube_size_small.constraint_mode(0);
        c_sim_cube_size_medium.constraint_mode(0);
        c_sim_cube_size_large.constraint_mode(1);
        c_sim_cube_size_normal.constraint_mode(0);
    end else if ("NORMAL"== cdp_cube_size.toupper()) begin
        c_sim_cube_size_small.constraint_mode(0);
        c_sim_cube_size_medium.constraint_mode(0);
        c_sim_cube_size_large.constraint_mode(0);
        c_sim_cube_size_normal.constraint_mode(1);
    end else `uvm_fatal(inst_name, $sformatf("Unknown cdp_cube_size option:%0s",cdp_cube_size.toupper()))
endfunction: set_sim_constraint

function void nvdla_cdp_rdma_resource::set_register();
    //:| spec2cons.ral_set(['NVDLA_CDP_RDMA'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    ral.nvdla.NVDLA_CDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.set(                              width);
    ral.nvdla.NVDLA_CDP_RDMA.D_DATA_CUBE_HEIGHT.HEIGHT.set(                            height);
    ral.nvdla.NVDLA_CDP_RDMA.D_DATA_CUBE_CHANNEL.CHANNEL.set(                          channel);
    ral.nvdla.NVDLA_CDP_RDMA.D_SRC_BASE_ADDR_LOW.SRC_BASE_ADDR_LOW.set(                src_base_addr_low);
    ral.nvdla.NVDLA_CDP_RDMA.D_SRC_BASE_ADDR_HIGH.SRC_BASE_ADDR_HIGH.set(              src_base_addr_high);
    ral.nvdla.NVDLA_CDP_RDMA.D_SRC_LINE_STRIDE.SRC_LINE_STRIDE.set(                    src_line_stride);
    ral.nvdla.NVDLA_CDP_RDMA.D_SRC_SURFACE_STRIDE.SRC_SURFACE_STRIDE.set(              src_surface_stride);
    ral.nvdla.NVDLA_CDP_RDMA.D_SRC_DMA_CFG.SRC_RAM_TYPE.set(                           src_ram_type);
    ral.nvdla.NVDLA_CDP_RDMA.D_DATA_FORMAT.INPUT_DATA.set(                             input_data);
    ral.nvdla.NVDLA_CDP_RDMA.D_PERF_ENABLE.DMA_EN.set(                                 dma_en);
    ral.nvdla.NVDLA_CDP_RDMA.D_CYA.CYA.set(                                            cya);
    //:) epython: generated_end (DO NOT EDIT ABOVE)
endfunction : set_register

`endif //_NVDLA_CDP_RDMA_RESOURCE_SV_
