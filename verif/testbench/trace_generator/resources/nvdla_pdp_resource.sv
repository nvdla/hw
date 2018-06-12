`ifndef _NVDLA_PDP_RESOURCE_SV_
`define _NVDLA_PDP_RESOURCE_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_pdp_resource
//
// @description: resource class of PDP
//-------------------------------------------------------------------------------------
`define PDP_ATOM_PER_LINE `PDP_SINGLE_LBUF_WIDTH/(`NVDLA_MEMORY_ATOMIC_SIZE/`NVDLA_PDP_THROUGHPUT)
class nvdla_pdp_resource extends nvdla_base_resource;
    // singleton handle
    static local nvdla_pdp_resource         inst;
    string  pdp_input_cube_size             = "NORMAL";
    string  pdp_output_cube_size            = "NORMAL";

    // enum define
    //:| import spec2constrain
    //:| global spec2cons
    //:| spec2cons = spec2constrain.Spec2Cons()
    //:| spec2cons.enum_gen(['NVDLA_PDP'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    typedef enum{ pooling_method_POOLING_METHOD_AVERAGE = 'h0
                 ,pooling_method_POOLING_METHOD_MAX = 'h1
                 ,pooling_method_POOLING_METHOD_MIN = 'h2
                } pooling_method_t;
    typedef enum{ flying_mode_ON_FLYING            = 'h0
                 ,flying_mode_OFF_FLYING           = 'h1
                } flying_mode_t;
    typedef enum{ nan_to_zero_DISABLE              = 'h0
                 ,nan_to_zero_ENABLE               = 'h1
                } nan_to_zero_t;
    typedef enum{ kernel_width_KERNEL_WIDTH_1      = 'h0
                 ,kernel_width_KERNEL_WIDTH_2      = 'h1
                 ,kernel_width_KERNEL_WIDTH_3      = 'h2
                 ,kernel_width_KERNEL_WIDTH_4      = 'h3
                 ,kernel_width_KERNEL_WIDTH_5      = 'h4
                 ,kernel_width_KERNEL_WIDTH_6      = 'h5
                 ,kernel_width_KERNEL_WIDTH_7      = 'h6
                 ,kernel_width_KERNEL_WIDTH_8      = 'h7
                } kernel_width_t;
    typedef enum{ kernel_height_KERNEL_HEIGHT_1    = 'h0
                 ,kernel_height_KERNEL_HEIGHT_2    = 'h1
                 ,kernel_height_KERNEL_HEIGHT_3    = 'h2
                 ,kernel_height_KERNEL_HEIGHT_4    = 'h3
                 ,kernel_height_KERNEL_HEIGHT_5    = 'h4
                 ,kernel_height_KERNEL_HEIGHT_6    = 'h5
                 ,kernel_height_KERNEL_HEIGHT_7    = 'h6
                 ,kernel_height_KERNEL_HEIGHT_8    = 'h7
                } kernel_height_t;
    typedef enum{ dst_ram_type_CV                  = 'h0
                 ,dst_ram_type_MC                  = 'h1
                } dst_ram_type_t;
    typedef enum{ input_data_INT8                  = 'h0
                 ,input_data_INT16                 = 'h1
                 ,input_data_FP16                  = 'h2
                } input_data_t;
    typedef enum{ dma_en_DISABLE                   = 'h0
                 ,dma_en_ENABLE                    = 'h1
                } dma_en_t;
    //:) epython: generated_end (DO NOT EDIT ABOVE)

    // field variables
    //:| spec2cons.state_gen(['NVDLA_PDP'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    rand bit [12:0]                 cube_in_width;
    rand bit [12:0]                 cube_in_height;
    rand bit [12:0]                 cube_in_channel;
    rand bit [12:0]                 cube_out_width;
    rand bit [12:0]                 cube_out_height;
    rand bit [12:0]                 cube_out_channel;
    rand pooling_method_t           pooling_method;
    rand flying_mode_t              flying_mode;
    rand bit [7:0]                  split_num;
    rand nan_to_zero_t              nan_to_zero;
    rand bit [9:0]                  partial_width_in_first;
    rand bit [9:0]                  partial_width_in_last;
    rand bit [9:0]                  partial_width_in_mid;
    rand bit [9:0]                  partial_width_out_first;
    rand bit [9:0]                  partial_width_out_last;
    rand bit [9:0]                  partial_width_out_mid;
    rand kernel_width_t             kernel_width;
    rand kernel_height_t            kernel_height;
    rand bit [3:0]                  kernel_stride_width;
    rand bit [3:0]                  kernel_stride_height;
    rand bit [16:0]                 recip_kernel_width;
    rand bit [16:0]                 recip_kernel_height;
    rand bit [2:0]                  pad_left;
    rand bit [2:0]                  pad_top;
    rand bit [2:0]                  pad_right;
    rand bit [2:0]                  pad_bottom;
    rand bit [18:0]                 pad_value_1x;
    rand bit [18:0]                 pad_value_2x;
    rand bit [18:0]                 pad_value_3x;
    rand bit [18:0]                 pad_value_4x;
    rand bit [18:0]                 pad_value_5x;
    rand bit [18:0]                 pad_value_6x;
    rand bit [18:0]                 pad_value_7x;
    rand bit [31:0]                 src_base_addr_low;
    rand bit [31:0]                 src_base_addr_high;
    rand bit [31:0]                 src_line_stride;
    rand bit [31:0]                 src_surface_stride;
    rand bit [31:0]                 dst_base_addr_low;
    rand bit [31:0]                 dst_base_addr_high;
    rand bit [31:0]                 dst_line_stride;
    rand bit [31:0]                 dst_surface_stride;
    rand dst_ram_type_t             dst_ram_type;
    rand input_data_t               input_data;
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
    extern constraint c_ias_split_num;
    extern constraint c_ias_partial_size_out;
    extern constraint c_ias_partial_size_in;
    extern constraint c_ias_kernel_size;
    extern constraint c_ias_pad_value;
    extern constraint c_ias_src_mem;
    extern constraint c_ias_dst_mem;
    extern constraint c_ias_dut_por_requirement;

    extern constraint c_sim_split_num_weight_dist;
    extern constraint c_sim_partial_size_weight_dist;
    extern constraint c_sim_kernel_size_weight_dist;
    extern constraint c_sim_mem_weight_dist;
    extern constraint c_sim_input_cube_size_small;
    extern constraint c_sim_input_cube_size_medium;
    extern constraint c_sim_input_cube_size_large;
    extern constraint c_sim_input_cube_size_normal;
    /*
        Methods
    */
    extern function         new(string name="nvdla_pdp_resource", uvm_component parent);
    extern static function  nvdla_pdp_resource get_pdp(uvm_component parent);
    extern function void    trace_dump(int fh);
    extern function void    set_fp16_padding();
    extern function void    set_mem_addr();
    extern function void    set_register();
    extern function void    post_randomize();
    extern function void    set_sim_constraint();

    `uvm_component_utils_begin(nvdla_pdp_resource)
        `uvm_field_string(pdp_input_cube_size,          UVM_ALL_ON)
        `uvm_field_string(pdp_output_cube_size,         UVM_ALL_ON)
        //:| spec2cons.macro_gen(['NVDLA_PDP'])
        //:) epython: generated_beg (DO NOT EDIT BELOW)
        `uvm_field_int(cube_in_width,                                  UVM_ALL_ON)
        `uvm_field_int(cube_in_height,                                 UVM_ALL_ON)
        `uvm_field_int(cube_in_channel,                                UVM_ALL_ON)
        `uvm_field_int(cube_out_width,                                 UVM_ALL_ON)
        `uvm_field_int(cube_out_height,                                UVM_ALL_ON)
        `uvm_field_int(cube_out_channel,                               UVM_ALL_ON)
        `uvm_field_enum(pooling_method_t,         pooling_method,      UVM_ALL_ON)
        `uvm_field_enum(flying_mode_t,            flying_mode,         UVM_ALL_ON)
        `uvm_field_int(split_num,                                      UVM_ALL_ON)
        `uvm_field_enum(nan_to_zero_t,            nan_to_zero,         UVM_ALL_ON)
        `uvm_field_int(partial_width_in_first,                         UVM_ALL_ON)
        `uvm_field_int(partial_width_in_last,                          UVM_ALL_ON)
        `uvm_field_int(partial_width_in_mid,                           UVM_ALL_ON)
        `uvm_field_int(partial_width_out_first,                        UVM_ALL_ON)
        `uvm_field_int(partial_width_out_last,                         UVM_ALL_ON)
        `uvm_field_int(partial_width_out_mid,                          UVM_ALL_ON)
        `uvm_field_enum(kernel_width_t,           kernel_width,        UVM_ALL_ON)
        `uvm_field_enum(kernel_height_t,          kernel_height,       UVM_ALL_ON)
        `uvm_field_int(kernel_stride_width,                            UVM_ALL_ON)
        `uvm_field_int(kernel_stride_height,                           UVM_ALL_ON)
        `uvm_field_int(recip_kernel_width,                             UVM_ALL_ON)
        `uvm_field_int(recip_kernel_height,                            UVM_ALL_ON)
        `uvm_field_int(pad_left,                                       UVM_ALL_ON)
        `uvm_field_int(pad_top,                                        UVM_ALL_ON)
        `uvm_field_int(pad_right,                                      UVM_ALL_ON)
        `uvm_field_int(pad_bottom,                                     UVM_ALL_ON)
        `uvm_field_int(pad_value_1x,                                   UVM_ALL_ON)
        `uvm_field_int(pad_value_2x,                                   UVM_ALL_ON)
        `uvm_field_int(pad_value_3x,                                   UVM_ALL_ON)
        `uvm_field_int(pad_value_4x,                                   UVM_ALL_ON)
        `uvm_field_int(pad_value_5x,                                   UVM_ALL_ON)
        `uvm_field_int(pad_value_6x,                                   UVM_ALL_ON)
        `uvm_field_int(pad_value_7x,                                   UVM_ALL_ON)
        `uvm_field_int(src_base_addr_low,                              UVM_ALL_ON)
        `uvm_field_int(src_base_addr_high,                             UVM_ALL_ON)
        `uvm_field_int(src_line_stride,                                UVM_ALL_ON)
        `uvm_field_int(src_surface_stride,                             UVM_ALL_ON)
        `uvm_field_int(dst_base_addr_low,                              UVM_ALL_ON)
        `uvm_field_int(dst_base_addr_high,                             UVM_ALL_ON)
        `uvm_field_int(dst_line_stride,                                UVM_ALL_ON)
        `uvm_field_int(dst_surface_stride,                             UVM_ALL_ON)
        `uvm_field_enum(dst_ram_type_t,           dst_ram_type,        UVM_ALL_ON)
        `uvm_field_enum(input_data_t,             input_data,          UVM_ALL_ON)
        `uvm_field_enum(dma_en_t,                 dma_en,              UVM_ALL_ON)
        `uvm_field_int(cya,                                            UVM_ALL_ON)
        //:) epython: generated_end (DO NOT EDIT ABOVE)
    `uvm_component_utils_end

endclass : nvdla_pdp_resource

function nvdla_pdp_resource::new(string name="nvdla_pdp_resource", uvm_component parent);
    super.new(name, parent);
    `uvm_info(inst_name, $sformatf("Initialize resource %s ... ",inst_name),UVM_LOW);
endfunction: new

static function nvdla_pdp_resource nvdla_pdp_resource::get_pdp(uvm_component parent);
    if (null == inst) begin
        inst = nvdla_pdp_resource::type_id::create("NVDLA_PDP", parent);
    end
    return inst;
endfunction: get_pdp

function void nvdla_pdp_resource::trace_dump(int fh);
    if(fh==null) begin
        `uvm_fatal(inst_name, "Null handle of trace file ...")
    end
    `uvm_info(inst_name, "Start trace dumping ...", UVM_HIGH)
    // if both groups have been used, resource must wait for the group released
    if (get_active_cnt() > 1) begin
        sync_wait(fh,inst_name,sync_evt_queue[-2]);
    end

    reg_write(fh,{inst_name.toupper(),".S_POINTER"},group_to_use);

    begin
        uvm_reg        reg_q[$];
        uvm_reg_data_t val;
        uvm_status_e   status;

        ral.nvdla.NVDLA_PDP.get_registers(reg_q);
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
    ral.nvdla.NVDLA_PDP.D_OP_ENABLE.set(1);
    reg_write(fh,{inst_name.toupper(),".D_OP_ENABLE"},1);
    intr_notify(fh,{"PDP_",$sformatf("%0d",group_to_use)}, sync_evt_queue[0]);
    begin
        // Reserve mem region to write into
        longint unsigned mem_size;
        string           mem_domain_output;
        mem_size          = calc_mem_size(0, 0, cube_in_channel+1, `NVDLA_MEMORY_ATOMIC_SIZE, dst_surface_stride);
        mem_domain_output = (dst_ram_type_MC==dst_ram_type) ? "pri_mem":"sec_mem";
        mem_reserve(fh, mem_domain_output, {dst_base_addr_high, dst_base_addr_low}, mem_size, sync_evt_queue[-2]);
        // Release mem region when write done
        mem_release(fh, mem_domain_output, {dst_base_addr_high, dst_base_addr_low}, sync_evt_queue[0]);
    end
    `uvm_info(inst_name, "Finish trace dumping ...", UVM_HIGH)
endfunction: trace_dump

// Share Line Buffer Size:
// DEPTH = 16*(`NVDLA_MEMORY_ATOMIC_SIZE/`NVDLA_PDP_THROUGHPUT)
// WIDTH = `NVDLA_PDP_THROUGHPUT*(`NVDLA_BPE+6)
// SIZE  = DEPTH*WIDTH*8 = 128*`NVDLA_MEMORY_ATOMIC_SIZE*(`NVDLA_BPE+6)

constraint nvdla_pdp_resource::c_ias_stride_alignment {
    // alignment according to atomic size
    src_line_stride    % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    src_surface_stride % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    dst_line_stride    % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    dst_surface_stride % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
}

constraint nvdla_pdp_resource::c_ias_cube_size {
    solve pooling_method      before cube_in_width;
    solve pooling_method      before cube_in_height;
    solve pooling_method      before cube_in_channel;
    solve cube_in_width       before cube_out_width;
    solve cube_in_width       before kernel_width;
    solve kernel_width        before pad_left;
    solve kernel_width        before pad_right;
    solve kernel_width        before cube_out_width;
    solve pad_left            before cube_out_width;
    solve pad_right           before cube_out_width;
    solve kernel_stride_width before cube_out_width;
    (cube_out_width +64'h1) == ((cube_in_width+64'h1) + pad_left + pad_right - (kernel_width+1) + (kernel_stride_width+1) ) / (kernel_stride_width+1);

    solve cube_in_height       before cube_out_height;
    solve cube_in_height       before kernel_height;
    solve kernel_height        before pad_top;
    solve kernel_height        before pad_bottom;
    solve kernel_height        before cube_out_height;
    solve pad_top              before cube_out_height;
    solve pad_bottom           before cube_out_height;
    solve kernel_stride_height before cube_out_height;
    (cube_out_height+64'h1) == ((cube_in_height+64'h1) + pad_top + pad_bottom - (kernel_height+1) + (kernel_stride_height+1)) / (kernel_stride_height+1);

    solve cube_in_channel before cube_out_channel;
    cube_in_channel == cube_out_channel;
}

constraint nvdla_pdp_resource::c_ias_split_num {
    solve cube_in_width        before split_num;
    solve pad_left             before split_num;
    solve pad_right            before split_num;
    solve kernel_height        before split_num;
    solve kernel_width         before split_num;
    solve kernel_stride_height before split_num;
    solve kernel_stride_width  before split_num;

    solve cube_out_width       before split_num;
    // Require: atomic_m*(bpe+6)*width_o*ceil(kernel_h/stride_h) <= buffer_size
    if ( (cube_out_width+1) > (8/(((kernel_height + 1) + (kernel_stride_height + 1) - 1)/(kernel_stride_height + 1)))*`PDP_ATOM_PER_LINE ) {
        split_num > 0;
    }

    solve split_num            before flying_mode;
    if (split_num > 0) {
        flying_mode == flying_mode_OFF_FLYING;
    }
}

constraint nvdla_pdp_resource::c_ias_partial_size_out {
    solve cube_out_width before partial_width_out_first;
    solve cube_out_width before partial_width_out_last;
    solve cube_out_width before partial_width_out_mid;
    solve split_num      before partial_width_out_first;
    solve split_num      before partial_width_out_last;
    solve split_num      before partial_width_out_mid;

    solve partial_width_out_mid before partial_width_out_first;
    solve partial_width_out_mid before partial_width_out_last;

    if(split_num >= 2) {
        // Only when split number greater than 2, partial_width_out_mid would take effect
        (partial_width_out_mid+1) <= (8/(((kernel_height + 1) + (kernel_stride_height + 1) - 1)/(kernel_stride_height + 1)))*`PDP_ATOM_PER_LINE;
    } else {
        // partial_width_out_mid   == 0;
        // partial_width_out_mid   dist { [10'h0:10'hF]:=30, [10'h10:10'hFF]:=30, [10'h100:10'h2FF]:=30, [10'h300:10'h3FF]:=10};
    }

    solve partial_width_out_first before partial_width_in_first;
    solve partial_width_out_last  before partial_width_in_last;
    solve partial_width_out_mid   before partial_width_in_mid;

    if(split_num == 0) {
        // partial_width_out_first == 0;
        // partial_width_out_last  == 0;
        // partial_width_out_first dist { [10'h0:10'hF]:=30, [10'h10:10'hFF]:=30, [10'h100:10'h2FF]:=30, [10'h300:10'h3FF]:=10};
        // partial_width_out_last  dist { [10'h0:10'hF]:=30, [10'h10:10'hFF]:=30, [10'h100:10'h2FF]:=30, [10'h300:10'h3FF]:=10};
    }
    else if (split_num == 1) {
        (cube_out_width+1)          == (partial_width_out_first+1) + (partial_width_out_last+1);
        (partial_width_out_first+1) <= (8/(((kernel_height + 1) + (kernel_stride_height + 1) - 1)/(kernel_stride_height + 1)))*`PDP_ATOM_PER_LINE;
        (partial_width_out_last+1)  <= (8/(((kernel_height + 1) + (kernel_stride_height + 1) - 1)/(kernel_stride_height + 1)))*`PDP_ATOM_PER_LINE;
        // (cube_in_width+1)  == (partial_width_in_first+1)  + (partial_width_in_last+1);
    }
    else if (split_num >= 2) {
        (cube_out_width+1) == partial_width_out_first+1 + partial_width_out_last+1 + (partial_width_out_mid+1)*(split_num+1-2);
        partial_width_out_mid       >= partial_width_out_last;
        partial_width_out_mid       >= partial_width_out_first;
        (partial_width_out_first+1) <= (8/(((kernel_height + 1) + (kernel_stride_height + 1) - 1)/(kernel_stride_height + 1)))*`PDP_ATOM_PER_LINE;
        (partial_width_out_mid+1)   <= (8/(((kernel_height + 1) + (kernel_stride_height + 1) - 1)/(kernel_stride_height + 1)))*`PDP_ATOM_PER_LINE;
        (partial_width_out_last+1)  <= (8/(((kernel_height + 1) + (kernel_stride_height + 1) - 1)/(kernel_stride_height + 1)))*`PDP_ATOM_PER_LINE;
        // (cube_in_width+1)  == partial_width_in_first+1  + partial_width_in_last+1  + (partial_width_in_mid+1)*(split_num+1-2);
    }
}

constraint nvdla_pdp_resource::c_ias_partial_size_in {
    if (split_num == 0) {
        //
    }
    else if(split_num == 1) {
        (partial_width_in_first+1+pad_left) == (partial_width_out_first + 1) * (kernel_stride_width+1)+(kernel_width-kernel_stride_width);
        (partial_width_in_last+1+pad_right) == (partial_width_out_last + 1) * (kernel_stride_width+1);
    }
    else if(split_num >= 2) {
        (partial_width_in_first+1+pad_left) == (partial_width_out_first + 1) * (kernel_stride_width+1)+(kernel_width-kernel_stride_width);
        (partial_width_in_mid+1)            == (partial_width_out_mid + 1) * (kernel_stride_width+1);
        (partial_width_in_last+1+pad_right) == (partial_width_out_last + 1) * (kernel_stride_width+1);
    }
}

constraint nvdla_pdp_resource::c_ias_kernel_size {
    (kernel_width+1)  <= (cube_in_width+1  + pad_left + pad_right);
    (kernel_height+1) <= (cube_in_height+1 + pad_top  + pad_bottom);
    (cube_in_width+1  + pad_left + pad_right  - (kernel_width+1) + (kernel_stride_width+1))   % (kernel_stride_width+1 ) == 0;
    (cube_in_height+1 + pad_top  + pad_bottom - (kernel_height+1) + (kernel_stride_height+1)) % (kernel_stride_height+1) == 0;

    if (split_num == 1) {
        if (kernel_width >= kernel_stride_width) {
            kernel_width - kernel_stride_width <= partial_width_in_first+ 32'h1;
        } else {
            kernel_stride_width - kernel_width < partial_width_in_last  + 32'h1;
        }
    } else if (split_num > 1) {
        if (kernel_width >= kernel_stride_width) {
            kernel_width - kernel_stride_width <= partial_width_in_first+ 32'h1;
            kernel_width - kernel_stride_width <= partial_width_in_mid  + 32'h1;
        } else {
            kernel_stride_width - kernel_width < partial_width_in_last  + 32'h1;
            kernel_stride_width - kernel_width < partial_width_in_mid   + 32'h1;
        }
    }

    if(pooling_method == pooling_method_POOLING_METHOD_AVERAGE) {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
        if(input_data == input_data_FP16) {
            (kernel_width  == 0) ->  recip_kernel_width  == 'h7c00;
            (kernel_width  == 1) ->  recip_kernel_width  == 'h7800;
            (kernel_width  == 2) ->  recip_kernel_width  == 'h7555;
            (kernel_width  == 3) ->  recip_kernel_width  == 'h7400;
            (kernel_width  == 4) ->  recip_kernel_width  == 'h7266;
            (kernel_width  == 5) ->  recip_kernel_width  == 'h7155;
            (kernel_width  == 6) ->  recip_kernel_width  == 'h7092;
            (kernel_width  == 7) ->  recip_kernel_width  == 'h7000;
            (kernel_height == 0) ->  recip_kernel_height == 'h7c00;
            (kernel_height == 1) ->  recip_kernel_height == 'h7800;
            (kernel_height == 2) ->  recip_kernel_height == 'h7555;
            (kernel_height == 3) ->  recip_kernel_height == 'h7400;
            (kernel_height == 4) ->  recip_kernel_height == 'h7266;
            (kernel_height == 5) ->  recip_kernel_height == 'h7155;
            (kernel_height == 6) ->  recip_kernel_height == 'h7092;
            (kernel_height == 7) ->  recip_kernel_height == 'h7000;
        }
        else
`endif
        {
            recip_kernel_width  == ((2**16)/(kernel_width+1));
            recip_kernel_height == ((2**16)/(kernel_height+1));
        }
    }
}

constraint nvdla_pdp_resource::c_ias_pad_value {
    pad_left   < (kernel_width+1);
    pad_right  < (kernel_width+1);
    pad_top    < (kernel_height+1);
    pad_bottom < (kernel_height+1);
    //pad_right = (kernel_width+1) - ((pad_left+(cube_in_width+1))%(kernel_stride_width+1)+X*(kernel_stride_width+1))
    //X is the MIN integer of 0,1,2...  that meet condition of pad_right <= pad_left
    //(kernel_width+1 - pad_right - (pad_left+cube_in_width+1)%(kernel_stride_width+1)) % (kernel_stride_width+1) == 0;

    // pad_value only active for AVERAGE pooling mode
    solve pad_value_1x before pad_value_2x;
    solve pad_value_1x before pad_value_3x;
    solve pad_value_1x before pad_value_4x;
    solve pad_value_1x before pad_value_5x;
    solve pad_value_1x before pad_value_6x;
    solve pad_value_1x before pad_value_7x;
    if(pooling_method == pooling_method_POOLING_METHOD_AVERAGE) {
        if(input_data == input_data_INT8) {
            // Signal Bits: [18:7]
            if(pad_value_1x[7]==0) { pad_value_1x[18:8] == 11'h0; }
            else if(pad_value_1x[7]==1) { pad_value_1x[18:8] == 11'h7FF; }
        }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
        else if(input_data == input_data_INT16) {
            // Signal Bits: [18:15]
            if(pad_value_1x[15]==0) { pad_value_1x[18:16] == 3'h0; }
            else if(pad_value_1x[15]==1) { pad_value_1x[18:16] == 3'h7; }
        }
        else if(input_data == input_data_FP16) {
            // FP16 (using FP17 format, only +0/-0)
            pad_value_1x inside {19'h0, 19'h7_0000};
        }
`endif
        if(input_data != input_data_FP16) {
            pad_value_2x == pad_value_1x * 2;
            pad_value_3x == pad_value_1x * 3;
            pad_value_4x == pad_value_1x * 4;
            pad_value_5x == pad_value_1x * 5;
            pad_value_6x == pad_value_1x * 6;
            pad_value_7x == pad_value_1x * 7;
        }
    }
}

constraint nvdla_pdp_resource::c_ias_src_mem {
    // memory stride size control
    src_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE >= (cube_in_width+64'h1);
    (src_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE - (cube_in_width+1))                     dist { 0:=30, ['h1:'hF]:=45, ['h10:'h7F]:=20, ['h80:'hFF]:=5};
    src_surface_stride >= src_line_stride*(cube_in_height+64'h1);
    (src_surface_stride - src_line_stride*(cube_in_height+1)) / `NVDLA_MEMORY_ATOMIC_SIZE dist { 0:=30, ['h1:'hF]:=45, ['h10:'h7F]:=20, ['h80:'hFF]:=5};
    64'(src_surface_stride*((cube_in_channel+1+`NVDLA_MEMORY_ATOMIC_SIZE-1) / `NVDLA_MEMORY_ATOMIC_SIZE)) <= 64'h10_0000;

}

constraint nvdla_pdp_resource::c_ias_dst_mem {
    solve cube_out_width  before dst_line_stride;
    solve dst_line_stride before dst_surface_stride;
    solve cube_out_height before dst_surface_stride;
    dst_line_stride  / `NVDLA_MEMORY_ATOMIC_SIZE >= cube_out_width+64'h1;
    (dst_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE - (cube_out_width+1)) dist { 0:=30, ['h1:'hF]:=45, ['h10:'h7F]:=20, ['h80:'hFF]:=5};
    64'(dst_surface_stride) >= 64'(dst_line_stride*(cube_out_height+64'h1));
    (dst_surface_stride - dst_line_stride*(cube_out_height+1)) / `NVDLA_MEMORY_ATOMIC_SIZE dist { 0:=30, ['h1:'hF]:=45, ['h10:'h7F]:=20, ['h80:'hFF]:=5};
    64'(dst_surface_stride*((cube_out_channel+1+`NVDLA_MEMORY_ATOMIC_SIZE-1) / `NVDLA_MEMORY_ATOMIC_SIZE)) <= 64'h10_0000;

}

constraint nvdla_pdp_resource::c_ias_dut_por_requirement {
`ifndef NVDLA_SECONDARY_MEMIF_ENABLE
    dst_ram_type == dst_ram_type_MC ;
`endif
    input_data   == input_data_INT8 ;
}

constraint nvdla_pdp_resource::c_sim_split_num_weight_dist {
    `weight_dist_8bit(split_num)
}

constraint nvdla_pdp_resource::c_sim_partial_size_weight_dist {
    `weight_dist_10bit(partial_width_in_first)
    `weight_dist_10bit(partial_width_in_mid)
    `weight_dist_10bit(partial_width_in_last)
    `weight_dist_10bit(partial_width_out_first)
    `weight_dist_10bit(partial_width_out_mid)
    `weight_dist_10bit(partial_width_out_last)
}

constraint nvdla_pdp_resource::c_sim_kernel_size_weight_dist {
    `weight_dist_5bit(kernel_width)
    `weight_dist_5bit(kernel_height)
    `weight_dist_5bit(kernel_stride_width)
    `weight_dist_5bit(kernel_stride_height)
    `weight_dist_17bit(recip_kernel_width)
    `weight_dist_17bit(recip_kernel_height)
    `weight_dist_19bit(pad_value_1x)
}

constraint nvdla_pdp_resource::c_sim_mem_weight_dist {
    `weight_dist_32bit(src_base_addr_low)
    `weight_dist_32bit(src_base_addr_high)
    `weight_dist_32bit(src_line_stride)
    `weight_dist_32bit(src_surface_stride)
    `weight_dist_32bit(dst_base_addr_low)
    `weight_dist_32bit(dst_base_addr_high)
    `weight_dist_32bit(dst_line_stride)
    `weight_dist_32bit(dst_surface_stride)
}

constraint nvdla_pdp_resource::c_sim_input_cube_size_small {
    cube_in_width   inside {[0:'h1F]};
    cube_in_height  inside {[0:'h1F]};
    cube_in_channel inside {[0:'h1F]};
    (cube_in_width+1)*(cube_in_height+1)*(cube_in_channel+1)    <= 64'h8000;
}

constraint nvdla_pdp_resource::c_sim_input_cube_size_medium {
    cube_in_width   inside {[0:'h7F]};
    cube_in_height  inside {[0:'h7F]};
    cube_in_channel inside {[0:'h7F]};
    (cube_in_width+1)*(cube_in_height+1)*(cube_in_channel+1)    >  64'h8000;
    (cube_in_width+1)*(cube_in_height+1)*(cube_in_channel+1)    <= 64'h2_0000;
}

constraint nvdla_pdp_resource::c_sim_input_cube_size_large {
    cube_in_width   inside {[0:'h1FFF]};
    cube_in_height  inside {[0:'h1FFF]};
    cube_in_channel inside {[0:'h1FFF]};
    (cube_in_width+1)*(cube_in_height+1)*(cube_in_channel+1)    > 64'h2_0000;
    (cube_in_width+1)*(cube_in_height+1)*(cube_in_channel+1)    <= 64'h20_0000;
}

constraint nvdla_pdp_resource::c_sim_input_cube_size_normal {
    (cube_in_width+1)*(cube_in_height+1)*(cube_in_channel+1) <= 64'h4_0000;
}

function void nvdla_pdp_resource::post_randomize();
    set_fp16_padding();
    set_mem_addr();
    set_register();

    `uvm_info(inst_name, {"\n", sprint()}, UVM_HIGH)
endfunction : post_randomize

function void nvdla_pdp_resource::set_sim_constraint();
    `uvm_info(inst_name, $sformatf("set sim constraint constraint"), UVM_LOW)
    if ("SMALL"== pdp_input_cube_size.toupper()) begin
        c_sim_input_cube_size_small.constraint_mode(1);
        c_sim_input_cube_size_medium.constraint_mode(0);
        c_sim_input_cube_size_large.constraint_mode(0);
        c_sim_input_cube_size_normal.constraint_mode(0);
    end else if ("MEDIUM"== pdp_input_cube_size.toupper()) begin
        c_sim_input_cube_size_small.constraint_mode(0);
        c_sim_input_cube_size_medium.constraint_mode(1);
        c_sim_input_cube_size_large.constraint_mode(0);
        c_sim_input_cube_size_normal.constraint_mode(0);
    end else if ("LARGE"== pdp_input_cube_size.toupper()) begin
        c_sim_input_cube_size_small.constraint_mode(0);
        c_sim_input_cube_size_medium.constraint_mode(0);
        c_sim_input_cube_size_large.constraint_mode(1);
        c_sim_input_cube_size_normal.constraint_mode(0);
    end else if ("NORMAL"== pdp_input_cube_size.toupper()) begin
        c_sim_input_cube_size_small.constraint_mode(0);
        c_sim_input_cube_size_medium.constraint_mode(0);
        c_sim_input_cube_size_large.constraint_mode(0);
        c_sim_input_cube_size_normal.constraint_mode(1);
    end else `uvm_fatal(inst_name, $sformatf("Unknown pdp_input_cube_size option:%0s",pdp_input_cube_size.toupper()))
endfunction: set_sim_constraint

function void nvdla_pdp_resource::set_fp16_padding();
    // FP format value post configuration
    bit [16:0] data_in;
    bit [16:0] data_out;
    chandle    fp17_base = new_FP17();
    chandle    fp17_scal = new_FP17();
    chandle    fp17_out  = new_FP17();

    if ((pooling_method == pooling_method_POOLING_METHOD_AVERAGE) && (input_data == input_data_FP16)) begin
        set_FP17(fp17_base, pad_value_1x[16:0]);
        data_in = 17'h8000;  // value: 2
        set_FP17(fp17_scal, data_in);
        FpMul_FP17_ref(fp17_base, fp17_scal, fp17_out);
        get_FP17(fp17_out, data_out);
        pad_value_2x[16:0] = data_out;
        pad_value_2x[18:17] = (data_out[16]==0)?0:2'b11;

        data_in = 17'h8200;  // value: 3
        set_FP17(fp17_scal, data_in);
        FpMul_FP17_ref(fp17_base, fp17_scal, fp17_out);
        get_FP17(fp17_out, data_out);
        pad_value_3x[16:0] = data_out;
        pad_value_3x[18:17] = (data_out[16]==0)?0:2'b11;

        data_in = 17'h8400;  // value: 4
        set_FP17(fp17_scal, data_in);
        FpMul_FP17_ref(fp17_base, fp17_scal, fp17_out);
        get_FP17(fp17_out, data_out);
        pad_value_4x[16:0] = data_out;
        pad_value_4x[18:17] = (data_out[16]==0)?0:2'b11;

        data_in = 17'h8500;  // value: 5
        set_FP17(fp17_scal, data_in);
        FpMul_FP17_ref(fp17_base, fp17_scal, fp17_out);
        get_FP17(fp17_out, data_out);
        pad_value_5x[16:0] = data_out;
        pad_value_5x[18:17] = (data_out[16]==0)?0:2'b11;

        data_in = 17'h8600;  // value: 6
        set_FP17(fp17_scal, data_in);
        FpMul_FP17_ref(fp17_base, fp17_scal, fp17_out);
        get_FP17(fp17_out, data_out);
        pad_value_6x[16:0] = data_out;
        pad_value_6x[18:17] = (data_out[16]==0)?0:2'b11;

        data_in = 17'h8700;  // value: 7
        set_FP17(fp17_scal, data_in);
        FpMul_FP17_ref(fp17_base, fp17_scal, fp17_out);
        get_FP17(fp17_out, data_out);
        pad_value_7x[16:0] = data_out;
        pad_value_7x[18:17] = (data_out[16]==0)?0:2'b11;
    end
endfunction : set_fp16_padding

function void nvdla_pdp_resource::set_mem_addr();
    mem_man          mm;
    mem_region       region;
    longint unsigned mem_size;
    string           mem_domain_output;

    mm = mem_man::get_mem_man();

    // WDMA
    mem_domain_output = (dst_ram_type_MC==dst_ram_type) ? "pri_mem":"sec_mem";
    mem_size          = calc_mem_size(0, 0, cube_in_channel+1, `NVDLA_MEMORY_ATOMIC_SIZE, dst_surface_stride);
    region            = mm.request_region_by_size( mem_domain_output, 
                                                   $sformatf("%s_%0d", "PDP_WDMA", get_active_cnt()), 
                                                   mem_size, 
                                                   align_mask[0]);
    {dst_base_addr_high, dst_base_addr_low} = region.get_start_offset();
endfunction : set_mem_addr

function void nvdla_pdp_resource::set_register();
    //:| spec2cons.ral_set(['NVDLA_PDP'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    ral.nvdla.NVDLA_PDP.D_DATA_CUBE_IN_WIDTH.CUBE_IN_WIDTH.set(                        cube_in_width);
    ral.nvdla.NVDLA_PDP.D_DATA_CUBE_IN_HEIGHT.CUBE_IN_HEIGHT.set(                      cube_in_height);
    ral.nvdla.NVDLA_PDP.D_DATA_CUBE_IN_CHANNEL.CUBE_IN_CHANNEL.set(                    cube_in_channel);
    ral.nvdla.NVDLA_PDP.D_DATA_CUBE_OUT_WIDTH.CUBE_OUT_WIDTH.set(                      cube_out_width);
    ral.nvdla.NVDLA_PDP.D_DATA_CUBE_OUT_HEIGHT.CUBE_OUT_HEIGHT.set(                    cube_out_height);
    ral.nvdla.NVDLA_PDP.D_DATA_CUBE_OUT_CHANNEL.CUBE_OUT_CHANNEL.set(                  cube_out_channel);
    ral.nvdla.NVDLA_PDP.D_OPERATION_MODE_CFG.POOLING_METHOD.set(                       pooling_method);
    ral.nvdla.NVDLA_PDP.D_OPERATION_MODE_CFG.FLYING_MODE.set(                          flying_mode);
    ral.nvdla.NVDLA_PDP.D_OPERATION_MODE_CFG.SPLIT_NUM.set(                            split_num);
    ral.nvdla.NVDLA_PDP.D_NAN_FLUSH_TO_ZERO.NAN_TO_ZERO.set(                           nan_to_zero);
    ral.nvdla.NVDLA_PDP.D_PARTIAL_WIDTH_IN.PARTIAL_WIDTH_IN_FIRST.set(                 partial_width_in_first);
    ral.nvdla.NVDLA_PDP.D_PARTIAL_WIDTH_IN.PARTIAL_WIDTH_IN_LAST.set(                  partial_width_in_last);
    ral.nvdla.NVDLA_PDP.D_PARTIAL_WIDTH_IN.PARTIAL_WIDTH_IN_MID.set(                   partial_width_in_mid);
    ral.nvdla.NVDLA_PDP.D_PARTIAL_WIDTH_OUT.PARTIAL_WIDTH_OUT_FIRST.set(               partial_width_out_first);
    ral.nvdla.NVDLA_PDP.D_PARTIAL_WIDTH_OUT.PARTIAL_WIDTH_OUT_LAST.set(                partial_width_out_last);
    ral.nvdla.NVDLA_PDP.D_PARTIAL_WIDTH_OUT.PARTIAL_WIDTH_OUT_MID.set(                 partial_width_out_mid);
    ral.nvdla.NVDLA_PDP.D_POOLING_KERNEL_CFG.KERNEL_WIDTH.set(                         kernel_width);
    ral.nvdla.NVDLA_PDP.D_POOLING_KERNEL_CFG.KERNEL_HEIGHT.set(                        kernel_height);
    ral.nvdla.NVDLA_PDP.D_POOLING_KERNEL_CFG.KERNEL_STRIDE_WIDTH.set(                  kernel_stride_width);
    ral.nvdla.NVDLA_PDP.D_POOLING_KERNEL_CFG.KERNEL_STRIDE_HEIGHT.set(                 kernel_stride_height);
    ral.nvdla.NVDLA_PDP.D_RECIP_KERNEL_WIDTH.RECIP_KERNEL_WIDTH.set(                   recip_kernel_width);
    ral.nvdla.NVDLA_PDP.D_RECIP_KERNEL_HEIGHT.RECIP_KERNEL_HEIGHT.set(                 recip_kernel_height);
    ral.nvdla.NVDLA_PDP.D_POOLING_PADDING_CFG.PAD_LEFT.set(                            pad_left);
    ral.nvdla.NVDLA_PDP.D_POOLING_PADDING_CFG.PAD_TOP.set(                             pad_top);
    ral.nvdla.NVDLA_PDP.D_POOLING_PADDING_CFG.PAD_RIGHT.set(                           pad_right);
    ral.nvdla.NVDLA_PDP.D_POOLING_PADDING_CFG.PAD_BOTTOM.set(                          pad_bottom);
    ral.nvdla.NVDLA_PDP.D_POOLING_PADDING_VALUE_1_CFG.PAD_VALUE_1X.set(                pad_value_1x);
    ral.nvdla.NVDLA_PDP.D_POOLING_PADDING_VALUE_2_CFG.PAD_VALUE_2X.set(                pad_value_2x);
    ral.nvdla.NVDLA_PDP.D_POOLING_PADDING_VALUE_3_CFG.PAD_VALUE_3X.set(                pad_value_3x);
    ral.nvdla.NVDLA_PDP.D_POOLING_PADDING_VALUE_4_CFG.PAD_VALUE_4X.set(                pad_value_4x);
    ral.nvdla.NVDLA_PDP.D_POOLING_PADDING_VALUE_5_CFG.PAD_VALUE_5X.set(                pad_value_5x);
    ral.nvdla.NVDLA_PDP.D_POOLING_PADDING_VALUE_6_CFG.PAD_VALUE_6X.set(                pad_value_6x);
    ral.nvdla.NVDLA_PDP.D_POOLING_PADDING_VALUE_7_CFG.PAD_VALUE_7X.set(                pad_value_7x);
    ral.nvdla.NVDLA_PDP.D_SRC_BASE_ADDR_LOW.SRC_BASE_ADDR_LOW.set(                     src_base_addr_low);
    ral.nvdla.NVDLA_PDP.D_SRC_BASE_ADDR_HIGH.SRC_BASE_ADDR_HIGH.set(                   src_base_addr_high);
    ral.nvdla.NVDLA_PDP.D_SRC_LINE_STRIDE.SRC_LINE_STRIDE.set(                         src_line_stride);
    ral.nvdla.NVDLA_PDP.D_SRC_SURFACE_STRIDE.SRC_SURFACE_STRIDE.set(                   src_surface_stride);
    ral.nvdla.NVDLA_PDP.D_DST_BASE_ADDR_LOW.DST_BASE_ADDR_LOW.set(                     dst_base_addr_low);
    ral.nvdla.NVDLA_PDP.D_DST_BASE_ADDR_HIGH.DST_BASE_ADDR_HIGH.set(                   dst_base_addr_high);
    ral.nvdla.NVDLA_PDP.D_DST_LINE_STRIDE.DST_LINE_STRIDE.set(                         dst_line_stride);
    ral.nvdla.NVDLA_PDP.D_DST_SURFACE_STRIDE.DST_SURFACE_STRIDE.set(                   dst_surface_stride);
    ral.nvdla.NVDLA_PDP.D_DST_RAM_CFG.DST_RAM_TYPE.set(                                dst_ram_type);
    ral.nvdla.NVDLA_PDP.D_DATA_FORMAT.INPUT_DATA.set(                                  input_data);
    ral.nvdla.NVDLA_PDP.D_PERF_ENABLE.DMA_EN.set(                                      dma_en);
    ral.nvdla.NVDLA_PDP.D_CYA.CYA.set(                                                 cya);
    //:) epython: generated_end (DO NOT EDIT ABOVE)
endfunction : set_register

`endif //_NVDLA_PDP_RESOURCE_SV_
