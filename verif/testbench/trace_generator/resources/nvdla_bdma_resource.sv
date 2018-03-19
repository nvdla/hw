`ifndef _NVDLA_BDMA_RESOURCE_SV_
`define _NVDLA_BDMA_RESOURCE_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_bdma_resource
//
// @description: various hardware resources of bdma sub module
//-------------------------------------------------------------------------------------

class nvdla_bdma_resource extends nvdla_base_resource;

    // enum define
    //:| import spec2constrain
    //:| global spec2cons
    //:| spec2cons = spec2constrain.Spec2Cons()
    //:| spec2cons.enum_gen(['NVDLA_BDMA'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    typedef enum{ src_ram_type_CVSRAM              = 'h0
                 ,src_ram_type_MC                  = 'h1
                } src_ram_type_t;
    typedef enum{ dst_ram_type_CVSRAM              = 'h0
                 ,dst_ram_type_MC                  = 'h1
                } dst_ram_type_t;
    typedef enum{ en_DISABLE                       = 'h0
                 ,en_ENABLE                        = 'h1
                } en_t;
    typedef enum{ grp0_launch_NO                   = 'h0
                 ,grp0_launch_YES                  = 'h1
                } grp0_launch_t;
    typedef enum{ grp1_launch_NO                   = 'h0
                 ,grp1_launch_YES                  = 'h1
                } grp1_launch_t;
    typedef enum{ stall_count_en_NO                = 'h0
                 ,stall_count_en_YES               = 'h1
                } stall_count_en_t;
    //:) epython: generated_end (DO NOT EDIT ABOVE)
    
    // field variables
    //:| spec2cons.state_gen(['NVDLA_BDMA'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    rand bit [26:0]                 v32;
    rand bit [31:0]                 v8;
    rand bit [12:0]                 size;
    rand src_ram_type_t             src_ram_type;
    rand dst_ram_type_t             dst_ram_type;
    rand bit [23:0]                 number;
    rand bit [26:0]                 stride;
    rand en_t                       en;
    rand grp0_launch_t              grp0_launch;
    rand grp1_launch_t              grp1_launch;
    rand stall_count_en_t           stall_count_en;
    //:) epython: generated_end (DO NOT EDIT ABOVE)

    `uvm_component_utils_begin(nvdla_bdma_resource)
        //:| spec2cons.macro_gen(['NVDLA_BDMA'])
        //:) epython: generated_beg (DO NOT EDIT BELOW)
        `uvm_field_int(v32,                                            UVM_ALL_ON)
        `uvm_field_int(v8,                                             UVM_ALL_ON)
        `uvm_field_int(size,                                           UVM_ALL_ON)
        `uvm_field_enum(src_ram_type_t,           src_ram_type,        UVM_ALL_ON)
        `uvm_field_enum(dst_ram_type_t,           dst_ram_type,        UVM_ALL_ON)
        `uvm_field_int(number,                                         UVM_ALL_ON)
        `uvm_field_int(stride,                                         UVM_ALL_ON)
        `uvm_field_enum(en_t,                     en,                  UVM_ALL_ON)
        `uvm_field_enum(grp0_launch_t,            grp0_launch,         UVM_ALL_ON)
        `uvm_field_enum(grp1_launch_t,            grp1_launch,         UVM_ALL_ON)
        `uvm_field_enum(stall_count_en_t,         stall_count_en,      UVM_ALL_ON)
        //:) epython: generated_end (DO NOT EDIT ABOVE)
    `uvm_component_utils_end

    /*
        Methods
    */
    extern function         new(string name="nvdla_bdma_resource", uvm_component parent);
    extern function void    trace_dump(int fh);
    extern function void    set_register();
    extern function void    post_randomize();

    /*
        constraints: 
            * ias_constraint: mandatory constraints from architecture requirement
            * sim_constraint: optional constraints for simulation only
    */
    // ias constraint
    extern constraint c_ias_XX;
    // sim constraint
    extern constraint c_sim_XX;

endclass : nvdla_bdma_resource

function nvdla_bdma_resource::new(string name="nvdla_bdma_resource", uvm_component parent);
    super.new(name, parent);
    `uvm_info(name, $sformatf("Initialize resource %s ... ",name),UVM_LOW);
endfunction: new

function void nvdla_bdma_resource::trace_dump(int fh);
endfunction : trace_dump

constraint nvdla_bdma_resource::c_ias_XX{}
constraint nvdla_bdma_resource::c_sim_XX{}

function void nvdla_bdma_resource::post_randomize();
endfunction : post_randomize

function void nvdla_bdma_resource::set_register();
    //:| spec2cons.ral_set(['NVDLA_BDMA'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    ral.nvdla.NVDLA_BDMA.CFG_SRC_ADDR_LOW.V32.set(                                     v32);
    ral.nvdla.NVDLA_BDMA.CFG_SRC_ADDR_HIGH.V8.set(                                     v8);
    ral.nvdla.NVDLA_BDMA.CFG_DST_ADDR_LOW.V32.set(                                     v32);
    ral.nvdla.NVDLA_BDMA.CFG_DST_ADDR_HIGH.V8.set(                                     v8);
    ral.nvdla.NVDLA_BDMA.CFG_LINE.SIZE.set(                                            size);
    ral.nvdla.NVDLA_BDMA.CFG_CMD.SRC_RAM_TYPE.set(                                     src_ram_type);
    ral.nvdla.NVDLA_BDMA.CFG_CMD.DST_RAM_TYPE.set(                                     dst_ram_type);
    ral.nvdla.NVDLA_BDMA.CFG_LINE_REPEAT.NUMBER.set(                                   number);
    ral.nvdla.NVDLA_BDMA.CFG_SRC_LINE.STRIDE.set(                                      stride);
    ral.nvdla.NVDLA_BDMA.CFG_DST_LINE.STRIDE.set(                                      stride);
    ral.nvdla.NVDLA_BDMA.CFG_SURF_REPEAT.NUMBER.set(                                   number);
    ral.nvdla.NVDLA_BDMA.CFG_SRC_SURF.STRIDE.set(                                      stride);
    ral.nvdla.NVDLA_BDMA.CFG_DST_SURF.STRIDE.set(                                      stride);
    ral.nvdla.NVDLA_BDMA.CFG_OP.EN.set(                                                en);
    ral.nvdla.NVDLA_BDMA.CFG_LAUNCH0.GRP0_LAUNCH.set(                                  grp0_launch);
    ral.nvdla.NVDLA_BDMA.CFG_LAUNCH1.GRP1_LAUNCH.set(                                  grp1_launch);
    ral.nvdla.NVDLA_BDMA.CFG_STATUS.STALL_COUNT_EN.set(                                stall_count_en);
    //:) epython: generated_end (DO NOT EDIT ABOVE)
endfunction : set_register

`endif //_NVDLA_BDMA_RESOURCE_SV_
