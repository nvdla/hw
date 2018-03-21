`ifndef _NVDLA_CC_DP_RESOURCE_SV_
`define _NVDLA_CC_DP_RESOURCE_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_cc_dp_resource
//
// @description: various hardware resources of csc/cmac/cacc sub module
//-------------------------------------------------------------------------------------

class nvdla_cc_dp_resource extends nvdla_base_resource;
    // singleton handle
    static local nvdla_cc_dp_resource       inst;
    string  cc_weight_cube_size             = "NORMAL";
    string  cc_output_cube_size             = "NORMAL";

    // enum define
    //:| import spec2constrain
    //:| global spec2cons
    //:| spec2cons = spec2constrain.Spec2Cons()
    //:| spec2cons.enum_gen(['NVDLA_CSC','NVDLA_CMAC_A','NVDLA_CACC'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    typedef enum{ conv_mode_DIRECT                 = 'h0
                 ,conv_mode_WINOGRAD               = 'h1
                } conv_mode_t;
    typedef enum{ in_precision_INT8                = 'h0
                 ,in_precision_INT16               = 'h1
                 ,in_precision_FP16                = 'h2
                } in_precision_t;
    typedef enum{ proc_precision_INT8              = 'h0
                 ,proc_precision_INT16             = 'h1
                 ,proc_precision_FP16              = 'h2
                } proc_precision_t;
    typedef enum{ data_reuse_DISABLE               = 'h0
                 ,data_reuse_ENABLE                = 'h1
                } data_reuse_t;
    typedef enum{ weight_reuse_DISABLE             = 'h0
                 ,weight_reuse_ENABLE              = 'h1
                } weight_reuse_t;
    typedef enum{ skip_data_rls_DISABLE            = 'h0
                 ,skip_data_rls_ENABLE             = 'h1
                } skip_data_rls_t;
    typedef enum{ skip_weight_rls_DISABLE          = 'h0
                 ,skip_weight_rls_ENABLE           = 'h1
                } skip_weight_rls_t;
    typedef enum{ datain_format_FEATURE            = 'h0
                 ,datain_format_PIXEL              = 'h1
                } datain_format_t;
    typedef enum{ weight_format_UNCOMPRESSED       = 'h0
                 ,weight_format_COMPRESSED         = 'h1
                } weight_format_t;
    typedef enum{ line_packed_FALSE                = 'h0
                 ,line_packed_TRUE                 = 'h1
                } line_packed_t;
    typedef enum{ surf_packed_FALSE                = 'h0
                 ,surf_packed_TRUE                 = 'h1
                } surf_packed_t;
    //:) epython: generated_end (DO NOT EDIT ABOVE)


    // Used for controling memory data 0 value rate:
    // weight: [0:10000]
    rand int weight_none_zero_rate;

    // field variables
    //:| spec2cons.state_gen(['NVDLA_CSC','NVDLA_CMAC_A','NVDLA_CACC'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    rand conv_mode_t                conv_mode;
    rand in_precision_t             in_precision;
    rand proc_precision_t           proc_precision;
    rand data_reuse_t               data_reuse;
    rand weight_reuse_t             weight_reuse;
    rand skip_data_rls_t            skip_data_rls;
    rand skip_weight_rls_t          skip_weight_rls;
    rand datain_format_t            datain_format;
    rand bit [12:0]                 datain_width_ext;
    rand bit [12:0]                 datain_height_ext;
    rand bit [12:0]                 datain_channel_ext;
    rand bit [4:0]                  batches;
    rand bit [1:0]                  y_extension;
    rand bit [13:0]                 entries;
    rand weight_format_t            weight_format;
    rand bit [4:0]                  weight_width_ext;
    rand bit [4:0]                  weight_height_ext;
    rand bit [12:0]                 weight_channel_ext;
    rand bit [12:0]                 weight_kernel;
    rand bit [24:0]                 weight_bytes;
    rand bit [20:0]                 wmb_bytes;
    rand bit [12:0]                 dataout_width;
    rand bit [12:0]                 dataout_height;
    rand bit [12:0]                 dataout_channel;
    rand bit [20:0]                 atomics;
    rand bit [11:0]                 rls_slices;
    rand bit [2:0]                  conv_x_stride_ext;
    rand bit [2:0]                  conv_y_stride_ext;
    rand bit [4:0]                  x_dilation_ext;
    rand bit [4:0]                  y_dilation_ext;
    rand bit [4:0]                  pad_left;
    rand bit [4:0]                  pad_top;
    rand bit [15:0]                 pad_value;
    rand bit [4:0]                  data_bank;
    rand bit [4:0]                  weight_bank;
    rand bit [1:0]                  pra_truncate;
    rand bit [31:0]                 cya;
    rand bit [31:0]                 dataout_addr;
    rand bit [23:0]                 line_stride;
    rand bit [23:0]                 surf_stride;
    rand line_packed_t              line_packed;
    rand surf_packed_t              surf_packed;
    rand bit [4:0]                  clip_truncate;
    //:) epython: generated_end (DO NOT EDIT ABOVE)

    `uvm_component_utils_begin(nvdla_cc_dp_resource)
        `uvm_field_string(cc_weight_cube_size,          UVM_ALL_ON)
        `uvm_field_string(cc_output_cube_size,          UVM_ALL_ON)
        //:| spec2cons.macro_gen(['NVDLA_CSC','NVDLA_CMAC_A','NVDLA_CACC'])
        //:) epython: generated_beg (DO NOT EDIT BELOW)
        `uvm_field_enum(conv_mode_t,              conv_mode,           UVM_ALL_ON)
        `uvm_field_enum(in_precision_t,           in_precision,        UVM_ALL_ON)
        `uvm_field_enum(proc_precision_t,         proc_precision,      UVM_ALL_ON)
        `uvm_field_enum(data_reuse_t,             data_reuse,          UVM_ALL_ON)
        `uvm_field_enum(weight_reuse_t,           weight_reuse,        UVM_ALL_ON)
        `uvm_field_enum(skip_data_rls_t,          skip_data_rls,       UVM_ALL_ON)
        `uvm_field_enum(skip_weight_rls_t,        skip_weight_rls,     UVM_ALL_ON)
        `uvm_field_enum(datain_format_t,          datain_format,       UVM_ALL_ON)
        `uvm_field_int(datain_width_ext,                               UVM_ALL_ON)
        `uvm_field_int(datain_height_ext,                              UVM_ALL_ON)
        `uvm_field_int(datain_channel_ext,                             UVM_ALL_ON)
        `uvm_field_int(batches,                                        UVM_ALL_ON)
        `uvm_field_int(y_extension,                                    UVM_ALL_ON)
        `uvm_field_int(entries,                                        UVM_ALL_ON)
        `uvm_field_enum(weight_format_t,          weight_format,       UVM_ALL_ON)
        `uvm_field_int(weight_width_ext,                               UVM_ALL_ON)
        `uvm_field_int(weight_height_ext,                              UVM_ALL_ON)
        `uvm_field_int(weight_channel_ext,                             UVM_ALL_ON)
        `uvm_field_int(weight_kernel,                                  UVM_ALL_ON)
        `uvm_field_int(weight_bytes,                                   UVM_ALL_ON)
        `uvm_field_int(wmb_bytes,                                      UVM_ALL_ON)
        `uvm_field_int(dataout_width,                                  UVM_ALL_ON)
        `uvm_field_int(dataout_height,                                 UVM_ALL_ON)
        `uvm_field_int(dataout_channel,                                UVM_ALL_ON)
        `uvm_field_int(atomics,                                        UVM_ALL_ON)
        `uvm_field_int(rls_slices,                                     UVM_ALL_ON)
        `uvm_field_int(conv_x_stride_ext,                              UVM_ALL_ON)
        `uvm_field_int(conv_y_stride_ext,                              UVM_ALL_ON)
        `uvm_field_int(x_dilation_ext,                                 UVM_ALL_ON)
        `uvm_field_int(y_dilation_ext,                                 UVM_ALL_ON)
        `uvm_field_int(pad_left,                                       UVM_ALL_ON)
        `uvm_field_int(pad_top,                                        UVM_ALL_ON)
        `uvm_field_int(pad_value,                                      UVM_ALL_ON)
        `uvm_field_int(data_bank,                                      UVM_ALL_ON)
        `uvm_field_int(weight_bank,                                    UVM_ALL_ON)
        `uvm_field_int(pra_truncate,                                   UVM_ALL_ON)
        `uvm_field_int(cya,                                            UVM_ALL_ON)
        `uvm_field_int(dataout_addr,                                   UVM_ALL_ON)
        `uvm_field_int(line_stride,                                    UVM_ALL_ON)
        `uvm_field_int(surf_stride,                                    UVM_ALL_ON)
        `uvm_field_enum(line_packed_t,            line_packed,         UVM_ALL_ON)
        `uvm_field_enum(surf_packed_t,            surf_packed,         UVM_ALL_ON)
        `uvm_field_int(clip_truncate,                                  UVM_ALL_ON)
        //:) epython: generated_end (DO NOT EDIT ABOVE)
    `uvm_component_utils_end

    /*
        Methods
    */
    extern function         new(string name="nvdla_cc_dp_resource", uvm_component parent);
    extern static function  nvdla_cc_dp_resource get_cc_dp(uvm_component parent);
    extern function void    trace_dump(int fh);
    extern function void    set_register();
    extern function void    post_randomize();
    extern function void    set_sim_constraint();

    /*
        constraints:
            * ias_constraint: mandatory constraints from architecture requirement
            * sim_constraint: optional constraints for simulation only
    */
    // ias constraint
    extern constraint c_ias_datain_ext;
    extern constraint c_ias_weight_data;
    extern constraint c_ias_pad_size;
    extern constraint c_ias_reuse_mode;
    extern constraint c_ias_multi_batch;
    extern constraint c_ias_dataout;
    extern constraint c_ias_conv_stride;
    extern constraint c_ias_dilation;
    extern constraint c_ias_clip_setting;
    extern constraint c_ias_dut_por_requirement;
    // sim constraint
    extern constraint c_sim_weight_none_zero_rate;
    extern constraint c_sim_dataout_dist;
    extern constraint c_sim_entry_dist;
    extern constraint c_sim_dilation_dist;
    extern constraint c_sim_weight_cube_size_small;
    extern constraint c_sim_weight_cube_size_medium;
    extern constraint c_sim_weight_cube_size_large;
    extern constraint c_sim_weight_cube_size_normal;
    extern constraint c_sim_output_cube_size_small;
    extern constraint c_sim_output_cube_size_medium;
    extern constraint c_sim_output_cube_size_large;
    extern constraint c_sim_output_cube_size_normal;
    extern constraint c_sim_datain_ext;

endclass : nvdla_cc_dp_resource

function nvdla_cc_dp_resource::new(string name="nvdla_cc_dp_resource", uvm_component parent);
    super.new(name, parent);
    `uvm_info(inst_name, $sformatf("Initialize resource %s ... ",inst_name),UVM_LOW);
endfunction: new

static function  nvdla_cc_dp_resource nvdla_cc_dp_resource::get_cc_dp(uvm_component parent);
    if (null == inst) begin
        inst = new("nvdla_cc_dp_resource", parent);
    end
    return inst;
endfunction: get_cc_dp

function void nvdla_cc_dp_resource::trace_dump(int fh);
    if(fh==null) begin
        `uvm_fatal(inst_name, "Null handle of trace file ...")
    end
    `uvm_info(inst_name, "Start trace dumping ...", UVM_HIGH)
    // if both groups have been used, resource must wait for at least one group releases
    if(sync_evt_queue.size()==2) begin
        string sync_wait_event = sync_evt_queue.pop_front();
        sync_wait(fh,"NVDLA_CACC",sync_wait_event);
        sync_wait(fh,"NVDLA_CMAC_A",sync_wait_event);
        sync_wait(fh,"NVDLA_CMAC_B",sync_wait_event);
        sync_wait(fh,"NVDLA_CSC",sync_wait_event);
    end

    reg_write(fh,"NVDLA_CSC.S_POINTER",group_to_use);
    reg_write(fh,"NVDLA_CMAC_A.S_POINTER",group_to_use);
    reg_write(fh,"NVDLA_CMAC_B.S_POINTER",group_to_use);
    reg_write(fh,"NVDLA_CACC.S_POINTER",group_to_use);

    begin
        uvm_reg        reg_q[$];
        uvm_reg_data_t val;
        uvm_status_e   status;

        ral.nvdla.NVDLA_CSC.get_registers(reg_q);
        reg_q.shuffle();
        foreach(reg_q[i]) begin
            if(reg_q[i].get_rights() != "RW") begin
                continue;
            end
            case(reg_q[i].get_name())
                "D_OP_ENABLE",
                "S_POINTER": ;
                default: reg_write(fh,{"NVDLA_CSC.",reg_q[i].get_name()},int'(reg_q[i].get()));
            endcase
        end
        sync_wait(fh,"NVDLA_CSC",{inst_name,"_cmac_a_",$sformatf("%0d",active_cnt)});
        sync_wait(fh,"NVDLA_CSC",{inst_name,"_cmac_b_",$sformatf("%0d",active_cnt)});
        ral.nvdla.NVDLA_CSC.D_OP_ENABLE.set(1);
        reg_write(fh,"NVDLA_CSC.D_OP_ENABLE",1);
    end
    begin
        uvm_reg        reg_q[$];
        uvm_reg_data_t val;
        uvm_status_e   status;

        ral.nvdla.NVDLA_CMAC_A.get_registers(reg_q);
        reg_q.shuffle();
        foreach(reg_q[i]) begin
            if(reg_q[i].get_rights() != "RW") begin
                continue;
            end
            case(reg_q[i].get_name())
                "D_OP_ENABLE",
                "S_POINTER": ;
                default: reg_write(fh,{"NVDLA_CMAC_A.",reg_q[i].get_name()},int'(reg_q[i].get()));
            endcase
        end
        sync_wait(fh,"NVDLA_CMAC_A",{inst_name,"_cacc_",$sformatf("%0d",active_cnt)});
        ral.nvdla.NVDLA_CMAC_A.D_OP_ENABLE.set(1);
        reg_write(fh,"NVDLA_CMAC_A.D_OP_ENABLE",1);
        sync_notify(fh,"NVDLA_CMAC_A",{inst_name,"_cmac_a_",$sformatf("%0d",active_cnt)});
    end
    begin
        uvm_reg        reg_q[$];
        uvm_reg_data_t val;
        uvm_status_e   status;

        ral.nvdla.NVDLA_CMAC_B.get_registers(reg_q);
        reg_q.shuffle();
        foreach(reg_q[i]) begin
            if(reg_q[i].get_rights() != "RW") begin
                continue;
            end
            case(reg_q[i].get_name())
                "D_OP_ENABLE",
                "S_POINTER": ;
                default: reg_write(fh,{"NVDLA_CMAC_B.",reg_q[i].get_name()},int'(reg_q[i].get()));
            endcase
        end
        sync_wait(fh,"NVDLA_CMAC_B",{inst_name,"_cacc_",$sformatf("%0d",active_cnt)});
        ral.nvdla.NVDLA_CMAC_B.D_OP_ENABLE.set(1);
        reg_write(fh,"NVDLA_CMAC_B.D_OP_ENABLE",1);
        sync_notify(fh,"NVDLA_CMAC_B",{inst_name,"_cmac_b_",$sformatf("%0d",active_cnt)});
    end
    begin
        uvm_reg        reg_q[$];
        uvm_reg_data_t val;
        uvm_status_e   status;

        ral.nvdla.NVDLA_CACC.get_registers(reg_q);
        reg_q.shuffle();
        foreach(reg_q[i]) begin
            if(reg_q[i].get_rights() != "RW") begin
                continue;
            end
            case(reg_q[i].get_name())
                "D_OP_ENABLE",
                "S_POINTER": ;
                default: reg_write(fh,{"NVDLA_CACC.",reg_q[i].get_name()},int'(reg_q[i].get()));
            endcase
        end
        ral.nvdla.NVDLA_CACC.D_OP_ENABLE.set(1); // coverage needs this
        reg_write(fh,"NVDLA_CACC.D_OP_ENABLE",1);
        sync_notify(fh,"NVDLA_CACC",{inst_name,"_cacc_",$sformatf("%0d",active_cnt)});
    end
    intr_notify(fh,{"CACC","_",$sformatf("%0d",group_to_use)},curr_sync_evt_name);
    `uvm_info(inst_name, "Finish trace dumping ...", UVM_HIGH)
endfunction : trace_dump

// ias constraint
constraint nvdla_cc_dp_resource::c_ias_datain_ext {
    if(conv_mode == conv_mode_WINOGRAD && datain_format == datain_format_FEATURE) {
        (weight_width_ext+1)   == 4;
        (weight_height_ext+1)  == 4;
        (weight_channel_ext+1) == (datain_channel_ext+1);
    }
    if(conv_mode == conv_mode_DIRECT && datain_format == datain_format_PIXEL){
        (weight_width_ext+1) == 1;
    }
}

constraint nvdla_cc_dp_resource::c_ias_weight_data {
    if(weight_format == weight_format_UNCOMPRESSED) { // non-compression mode
        weight_bytes == ((weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1)*((proc_precision == proc_precision_INT8)?1:2)*(weight_kernel+1)+NVDLA_CBUF_ENTRY_BYTE_WIDTH-1)/NVDLA_CBUF_ENTRY_BYTE_WIDTH;
    }
    else {
        // depends on VDC generated memory, will be configured in sequence
    }

    // Only work when weight data in compression mode
    // one bit of wmb for one element of kernel
    // wmb size <= one bank
    // bug 200312556, weiht bank must be able to hold one max kernel group + NVDLA_CBUF_ENTRY_BYTE_WIDTH bytes
    (weight_format == weight_format_COMPRESSED) -> {
        wmb_bytes == (((weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1)*(weight_kernel+1)+7)/8 +NVDLA_CBUF_ENTRY_BYTE_WIDTH-1)/NVDLA_CBUF_ENTRY_BYTE_WIDTH;
        if(wmb_bytes > `NVDLA_CBUF_BANK_DEPTH) {  // can't work on full weight mode
            // wmb_bytes per group must <= one bank
            if(proc_precision == proc_precision_INT8) { // 32 kernel per group
                ((((weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1)*`NVDLA_MAC_ATOMIC_K_SIZE+7)/8 +NVDLA_CBUF_ENTRY_BYTE_WIDTH-1)/NVDLA_CBUF_ENTRY_BYTE_WIDTH + 1) <= `NVDLA_CBUF_BANK_DEPTH;
            }
            else { // 16 kernel per group
                ((((weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1)*16+7)/8 +NVDLA_CBUF_ENTRY_BYTE_WIDTH-1)/NVDLA_CBUF_ENTRY_BYTE_WIDTH + 1) <= `NVDLA_CBUF_BANK_DEPTH;
            }
        }
    }
}

constraint nvdla_cc_dp_resource::c_ias_pad_size {
    // bug 200291495
    if (conv_mode == conv_mode_DIRECT) {  // DC or Image
        // In image input mode, x_dilation_ext = y_dilation_ext = 0
        if(datain_format == datain_format_PIXEL) {
            //move to sce layer
        }
        else { // feature
            pad_left   < ((weight_width_ext+1-1)*(x_dilation_ext+1) + 1);
        }
        pad_top    < ((weight_height_ext+1-1)*(y_dilation_ext+1) + 1);
    }
}

constraint nvdla_cc_dp_resource::c_ias_reuse_mode {
    rls_slices <= datain_height_ext;
    (rls_slices+1) <= (data_bank+1) * `NVDLA_CBUF_BANK_DEPTH / (entries+1);
    if(skip_data_rls == skip_data_rls_DISABLE) {
        (conv_mode == conv_mode_WINOGRAD) -> { (rls_slices+1) % 4 == 0; }
    }

    if((((((weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1)*((proc_precision==proc_precision_INT8)?1:2)*(weight_kernel+1)+NVDLA_CBUF_ENTRY_BYTE_WIDTH-1) / NVDLA_CBUF_ENTRY_BYTE_WIDTH ) + `NVDLA_CBUF_BANK_DEPTH-1) / `NVDLA_CBUF_BANK_DEPTH) + (data_bank+1) > ((weight_format==weight_format_COMPRESSED)?15:16)) {// can't work in full weight mode
        skip_weight_rls == skip_weight_rls_DISABLE;
    }
    if((((((weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1)*((proc_precision==proc_precision_INT8)?1:2)*(weight_kernel+1)+NVDLA_CBUF_ENTRY_BYTE_WIDTH-1) / NVDLA_CBUF_ENTRY_BYTE_WIDTH ) + `NVDLA_CBUF_BANK_DEPTH-1) / `NVDLA_CBUF_BANK_DEPTH) > (weight_bank+1)) {// can't work in full weight mode
        skip_weight_rls == skip_weight_rls_DISABLE;
    }

    // if enable skip_weight_rls, means work in full weight mode
    if(weight_format == weight_format_UNCOMPRESSED) { // non-compression mode
        if(skip_weight_rls == skip_weight_rls_ENABLE) { // Must work in full weight mode
            (weight_bank+1) >= ((((weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1)*((proc_precision==proc_precision_INT8)?1:2)*(weight_kernel+1)+NVDLA_CBUF_ENTRY_BYTE_WIDTH-1) / NVDLA_CBUF_ENTRY_BYTE_WIDTH ) + `NVDLA_CBUF_BANK_DEPTH-1) / `NVDLA_CBUF_BANK_DEPTH;
        }
        else {
            // weight_bank >= min_weight_bank
            if((proc_precision == proc_precision_INT8 && weight_kernel < `NVDLA_MAC_ATOMIC_K_SIZE) || (proc_precision!=proc_precision_INT8 && weight_kernel < 16)) {
                (weight_bank+1) >= ((((weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1)*((proc_precision==proc_precision_INT8)?1:2)*(weight_kernel+1)+NVDLA_CBUF_ENTRY_BYTE_WIDTH-1) / NVDLA_CBUF_ENTRY_BYTE_WIDTH) + 1 + `NVDLA_CBUF_BANK_DEPTH-1) / `NVDLA_CBUF_BANK_DEPTH;
            }
            else {
                (weight_bank+1) >= ((((weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1)*`NVDLA_MAC_ATOMIC_K_SIZE+NVDLA_CBUF_ENTRY_BYTE_WIDTH-1) / NVDLA_CBUF_ENTRY_BYTE_WIDTH) + 1 + `NVDLA_CBUF_BANK_DEPTH-1) / `NVDLA_CBUF_BANK_DEPTH;
            }
        }
    }
    else {
        if( wmb_bytes > `NVDLA_CBUF_BANK_DEPTH) { // can't work in full weight mode
            skip_weight_rls == skip_weight_rls_DISABLE;
        }
        //(weight_bank+1) >= ((weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1)*`NVDLA_MAC_ATOMIC_K_SIZE*weight_none_zero_rate/1000-1) / (NVDLA_CBUF_ENTRY_BYTE_WIDTH*`NVDLA_CBUF_BANK_DEPTH) + 1;
        if(skip_weight_rls == skip_weight_rls_ENABLE) { // Must work in full weight mode
            (weight_bank+1) >= ((((weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1)*((proc_precision==proc_precision_INT8)?1:2)*(weight_kernel+1)*weight_none_zero_rate/1000+NVDLA_CBUF_ENTRY_BYTE_WIDTH-1) / NVDLA_CBUF_ENTRY_BYTE_WIDTH ) + `NVDLA_CBUF_BANK_DEPTH-1) / `NVDLA_CBUF_BANK_DEPTH;
        }
        else {
            // weight_bank >= min_weight_bank
            if((proc_precision == proc_precision_INT8 && weight_kernel < 32) || (proc_precision!=proc_precision_INT8 && weight_kernel < 16)) {
                (weight_bank+1) >= ((((weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1)*((proc_precision==proc_precision_INT8)?1:2)*(weight_kernel+1)*weight_none_zero_rate/1000+NVDLA_CBUF_ENTRY_BYTE_WIDTH-1) / NVDLA_CBUF_ENTRY_BYTE_WIDTH) + 1 + `NVDLA_CBUF_BANK_DEPTH-1) / `NVDLA_CBUF_BANK_DEPTH;
            }
            else {
                (weight_bank+1) >= ((((weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1)*`NVDLA_MAC_ATOMIC_K_SIZE*weight_none_zero_rate/1000+NVDLA_CBUF_ENTRY_BYTE_WIDTH-1) / NVDLA_CBUF_ENTRY_BYTE_WIDTH) + 1 + `NVDLA_CBUF_BANK_DEPTH-1) / `NVDLA_CBUF_BANK_DEPTH;
            }
        }
    }
}

constraint nvdla_cc_dp_resource::c_ias_multi_batch {
    if(conv_mode == conv_mode_DIRECT && datain_format == datain_format_FEATURE) {
        if(batches > 0) {
            if(!((dataout_width == 0) && (dataout_height == 0))) {
                line_stride % 2 == 0;
                surf_stride % 2 == 0;
            }
        }
    }
}

constraint nvdla_cc_dp_resource::c_ias_dataout {
    if((dataout_width == 0) && (dataout_height == 0)) { // only 1x1 support pack mode
        (line_stride*32 - (dataout_width+1)*32) == 0; // 32byte per unit
        (surf_stride - line_stride*(dataout_height+1))  == 0;
        line_packed == line_packed_TRUE;
        surf_packed == surf_packed_TRUE;
    }
    else {
        line_packed == line_packed_FALSE;
        surf_packed == surf_packed_FALSE;
        (line_stride - (dataout_width+1)) dist { [1:4]:=10, [5:8]:=50, [9:12]:=30, [13:16]:=10};  // 0~256byte
        (surf_stride - line_stride*(dataout_height+1)) dist { [1:4]:=10, [5:8]:=50, [9:12]:=30, [13:16]:=10}; // 0~256byte
    }
    (surf_stride*(dataout_channel+1)) <= 64'h4_0000;

    if(conv_mode == conv_mode_WINOGRAD && datain_format == datain_format_FEATURE) {
        (dataout_width+1)  == (datain_width_ext+1-4);
        (dataout_height+1) == (datain_height_ext+1-4);
        (dataout_width+1)  % 4 == 0;
        (dataout_height+1) % 4 == 0;
    }

    dataout_channel == weight_kernel;
    atomics == (dataout_width+1) * (dataout_height+1) - 1;
}

constraint nvdla_cc_dp_resource::c_ias_conv_stride {
    if(conv_mode == conv_mode_WINOGRAD) {
        conv_x_stride_ext == 0;
        conv_y_stride_ext == 0;

    }
}

constraint nvdla_cc_dp_resource::c_ias_dilation {
    if(conv_mode==conv_mode_WINOGRAD || datain_format==datain_format_PIXEL) {
        x_dilation_ext == 0;
        y_dilation_ext == 0;
    }
    pra_truncate inside { 0, 1, 2 };
}

constraint nvdla_cc_dp_resource::c_ias_clip_setting {
    clip_truncate <= 16; // TODO cover to magic number to ACCU_ASSEMBLY_BIT_WIDTH - ACCU_DELIVERY_BIT_WIDTH
}

constraint nvdla_cc_dp_resource::c_ias_dut_por_requirement {
    conv_mode      == conv_mode_DIRECT ;
    in_precision   == in_precision_INT8 ;
    proc_precision == proc_precision_INT8 ;
    weight_format  == weight_format_UNCOMPRESSED ;
    batches        == 0;
}

// sim constraint
constraint nvdla_cc_dp_resource::c_sim_weight_none_zero_rate {
    // rate = (value/10000)
    if(weight_format == weight_format_UNCOMPRESSED) {
        weight_none_zero_rate dist { [0:8999]:=10, [9000:10000]:=90 };
    } else {
        weight_none_zero_rate  dist { [1:3999]:=10, [4000:5999]:=80, [6000:10000]:=10 };
    }
}

constraint nvdla_cc_dp_resource::c_sim_dataout_dist {
    `weight_dist_21bit(atomics)
    `weight_dist_27bit(dataout_addr)
    `weight_dist_19bit(line_stride)
    `weight_dist_19bit(surf_stride)
}

constraint nvdla_cc_dp_resource::c_sim_entry_dist {
    `weight_dist_14bit(entries)
    `weight_dist_12bit(rls_slices)
}


constraint nvdla_cc_dp_resource::c_sim_datain_ext {
    `weight_dist_13bit(datain_channel_ext)
}

constraint nvdla_cc_dp_resource::c_sim_dilation_dist {
    `weight_dist_5bit(x_dilation_ext)
    `weight_dist_5bit(y_dilation_ext)
}

constraint nvdla_cc_dp_resource::c_sim_weight_cube_size_small {
    weight_kernel       inside {[0:'h1F]};
}

constraint nvdla_cc_dp_resource::c_sim_weight_cube_size_medium {
    weight_kernel       inside {[0:'h7F]};
    if (conv_mode == conv_mode_DIRECT && datain_format == datain_format_PIXEL) {
        (weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1) > 64'h100;
    } else {
        (weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1) > 64'h200;
    }
    (weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1)*(weight_kernel+1) <= 64'h8000; // 0x1000*0x80 = 0x8_0000
}

constraint nvdla_cc_dp_resource::c_sim_weight_cube_size_large {
    weight_kernel       inside {[0:'h1FFF]};
    if (conv_mode == conv_mode_DIRECT && datain_format == datain_format_PIXEL) {
        (weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1) > 64'h100;
    } else {
        (weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1) > 64'h1000;
    }
    (weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1)*(weight_kernel+1) <= 64'h10_0000;
}

constraint nvdla_cc_dp_resource::c_sim_weight_cube_size_normal {
    weight_width_ext    dist { [5'h0:5'h7]:=15,   [5'h8:5'hF]:=50,     [5'h10:5'h17]:=25,     [5'h18:5'h1E]:=9,       5'h1F :=1 };
    weight_height_ext   dist { [5'h0:5'h7]:=15,   [5'h8:5'hF]:=50,     [5'h10:5'h17]:=25,     [5'h18:5'h1E]:=9,       5'h1F :=1 };
    weight_channel_ext  dist { [13'h0:13'hF]:=15, [13'h10:13'hFF]:=50, [13'h100:13'hFFF]:=25, [13'h1000:13'h1FFE]:=9, 13'h1FFF :=1 };
    weight_kernel       dist { [13'h0:13'hF]:=15, [13'h10:13'hFF]:=70, [13'h100:13'hFFF]:=9,  [13'h1000:13'h1FFE]:=5, 13'h1FFF := 1 };
    (weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1)*(weight_kernel+1) <= 64'h10_0000;
}

constraint nvdla_cc_dp_resource::c_sim_output_cube_size_small {
    dataout_width   inside {[0:'h1F]};
    dataout_height  inside {[0:'h1F]};
    dataout_channel inside {[0:'h1F]};
    (dataout_width+1)*(dataout_height+1)*(dataout_channel+1)    <= 64'h8000;
}

constraint nvdla_cc_dp_resource::c_sim_output_cube_size_medium {
    dataout_width   inside {[0:'h7F]};
    dataout_height  inside {[0:'h7F]};
    dataout_channel inside {[0:'h7F]};
    (dataout_width+1)*(dataout_height+1)*(dataout_channel+1)    >  64'h8000;
    (dataout_width+1)*(dataout_height+1)*(dataout_channel+1)    <= 64'h2_0000;
}

constraint nvdla_cc_dp_resource::c_sim_output_cube_size_large {
    dataout_width   inside {[0:'h1FFF]};
    dataout_height  inside {[0:'h1FFF]};
    dataout_channel inside {[0:'h1FFF]};
    (dataout_width+1)*(dataout_height+1)*(dataout_channel+1)    > 64'h2_0000;
    (dataout_width+1)*(dataout_height+1)*(dataout_channel+1)    <= 64'h20_0000;
}

constraint nvdla_cc_dp_resource::c_sim_output_cube_size_normal {
    dataout_width   dist { [13'h0:13'hF]:=15, [13'h10:13'h7F]:=65, [13'h80:13'hFFF]:=10, [13'h1000:13'h1FFE]:=9, 13'h1FFF :=1 };
    dataout_height  dist { [13'h0:13'hF]:=15, [13'h10:13'h7F]:=65, [13'h80:13'hFFF]:=10, [13'h1000:13'h1FFE]:=9, 13'h1FFF :=1 };
    dataout_channel dist { [13'h0:13'hF]:=15, [13'h10:13'h7F]:=65, [13'h80:13'hFFF]:=10, [13'h1000:13'h1FFE]:=9, 13'h1FFF :=1 };
    (dataout_width+1)*(dataout_height+1)*(dataout_channel+1) <= 64'h4_0000;
}

function void nvdla_cc_dp_resource::post_randomize();
    set_register();

    `uvm_info(inst_name, {"\n", sprint()}, UVM_HIGH)
endfunction : post_randomize

function void nvdla_cc_dp_resource::set_sim_constraint();
    `uvm_info(inst_name, $sformatf("set sim constraint constraint"), UVM_LOW)
    if ("SMALL"== cc_weight_cube_size.toupper()) begin
        c_sim_weight_cube_size_small.constraint_mode(1);
        c_sim_weight_cube_size_medium.constraint_mode(0);
        c_sim_weight_cube_size_large.constraint_mode(0);
        c_sim_weight_cube_size_normal.constraint_mode(0);
    end else if ("MEDIUM"== cc_weight_cube_size.toupper()) begin
        c_sim_weight_cube_size_small.constraint_mode(0);
        c_sim_weight_cube_size_medium.constraint_mode(1);
        c_sim_weight_cube_size_large.constraint_mode(0);
        c_sim_weight_cube_size_normal.constraint_mode(0);
    end else if ("LARGE"== cc_weight_cube_size.toupper()) begin
        c_sim_weight_cube_size_small.constraint_mode(0);
        c_sim_weight_cube_size_medium.constraint_mode(0);
        c_sim_weight_cube_size_large.constraint_mode(1);
        c_sim_weight_cube_size_normal.constraint_mode(0);
    end else if ("NORMAL"== cc_weight_cube_size.toupper()) begin
        c_sim_weight_cube_size_small.constraint_mode(0);
        c_sim_weight_cube_size_medium.constraint_mode(0);
        c_sim_weight_cube_size_large.constraint_mode(0);
        c_sim_weight_cube_size_normal.constraint_mode(1);
    end else `uvm_fatal(inst_name, $sformatf("Unknown cc_weight_cube_size option:%0s",cc_weight_cube_size.toupper()))

    if ("SMALL"== cc_output_cube_size.toupper()) begin
        c_sim_output_cube_size_small.constraint_mode(1);
        c_sim_output_cube_size_medium.constraint_mode(0);
        c_sim_output_cube_size_large.constraint_mode(0);
        c_sim_output_cube_size_normal.constraint_mode(0);
    end else if ("MEDIUM"== cc_output_cube_size.toupper()) begin
        c_sim_output_cube_size_small.constraint_mode(0);
        c_sim_output_cube_size_medium.constraint_mode(1);
        c_sim_output_cube_size_large.constraint_mode(0);
        c_sim_output_cube_size_normal.constraint_mode(0);
    end else if ("LARGE"== cc_output_cube_size.toupper()) begin
        c_sim_output_cube_size_small.constraint_mode(0);
        c_sim_output_cube_size_medium.constraint_mode(0);
        c_sim_output_cube_size_large.constraint_mode(1);
        c_sim_output_cube_size_normal.constraint_mode(0);
    end else if ("NORMAL"== cc_output_cube_size.toupper()) begin
        c_sim_output_cube_size_small.constraint_mode(0);
        c_sim_output_cube_size_medium.constraint_mode(0);
        c_sim_output_cube_size_large.constraint_mode(0);
        c_sim_output_cube_size_normal.constraint_mode(1);
    end else `uvm_fatal(inst_name, $sformatf("Unknown cc_output_cube_size option:%0s",cc_output_cube_size.toupper()))
endfunction: set_sim_constraint

function void nvdla_cc_dp_resource::set_register();
    //:| spec2cons.ral_set(['NVDLA_CSC','NVDLA_CMAC_A','NVDLA_CMAC_B','NVDLA_CACC'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    ral.nvdla.NVDLA_CSC.D_MISC_CFG.CONV_MODE.set(                                      conv_mode);
    ral.nvdla.NVDLA_CSC.D_MISC_CFG.IN_PRECISION.set(                                   in_precision);
    ral.nvdla.NVDLA_CSC.D_MISC_CFG.PROC_PRECISION.set(                                 proc_precision);
    ral.nvdla.NVDLA_CSC.D_MISC_CFG.DATA_REUSE.set(                                     data_reuse);
    ral.nvdla.NVDLA_CSC.D_MISC_CFG.WEIGHT_REUSE.set(                                   weight_reuse);
    ral.nvdla.NVDLA_CSC.D_MISC_CFG.SKIP_DATA_RLS.set(                                  skip_data_rls);
    ral.nvdla.NVDLA_CSC.D_MISC_CFG.SKIP_WEIGHT_RLS.set(                                skip_weight_rls);
    ral.nvdla.NVDLA_CSC.D_DATAIN_FORMAT.DATAIN_FORMAT.set(                             datain_format);
    ral.nvdla.NVDLA_CSC.D_DATAIN_SIZE_EXT_0.DATAIN_WIDTH_EXT.set(                      datain_width_ext);
    ral.nvdla.NVDLA_CSC.D_DATAIN_SIZE_EXT_0.DATAIN_HEIGHT_EXT.set(                     datain_height_ext);
    ral.nvdla.NVDLA_CSC.D_DATAIN_SIZE_EXT_1.DATAIN_CHANNEL_EXT.set(                    datain_channel_ext);
    ral.nvdla.NVDLA_CSC.D_BATCH_NUMBER.BATCHES.set(                                    batches);
    ral.nvdla.NVDLA_CSC.D_POST_Y_EXTENSION.Y_EXTENSION.set(                            y_extension);
    ral.nvdla.NVDLA_CSC.D_ENTRY_PER_SLICE.ENTRIES.set(                                 entries);
    ral.nvdla.NVDLA_CSC.D_WEIGHT_FORMAT.WEIGHT_FORMAT.set(                             weight_format);
    ral.nvdla.NVDLA_CSC.D_WEIGHT_SIZE_EXT_0.WEIGHT_WIDTH_EXT.set(                      weight_width_ext);
    ral.nvdla.NVDLA_CSC.D_WEIGHT_SIZE_EXT_0.WEIGHT_HEIGHT_EXT.set(                     weight_height_ext);
    ral.nvdla.NVDLA_CSC.D_WEIGHT_SIZE_EXT_1.WEIGHT_CHANNEL_EXT.set(                    weight_channel_ext);
    ral.nvdla.NVDLA_CSC.D_WEIGHT_SIZE_EXT_1.WEIGHT_KERNEL.set(                         weight_kernel);
    ral.nvdla.NVDLA_CSC.D_WEIGHT_BYTES.WEIGHT_BYTES.set(                               weight_bytes);
    ral.nvdla.NVDLA_CSC.D_WMB_BYTES.WMB_BYTES.set(                                     wmb_bytes);
    ral.nvdla.NVDLA_CSC.D_DATAOUT_SIZE_0.DATAOUT_WIDTH.set(                            dataout_width);
    ral.nvdla.NVDLA_CSC.D_DATAOUT_SIZE_0.DATAOUT_HEIGHT.set(                           dataout_height);
    ral.nvdla.NVDLA_CSC.D_DATAOUT_SIZE_1.DATAOUT_CHANNEL.set(                          dataout_channel);
    ral.nvdla.NVDLA_CSC.D_ATOMICS.ATOMICS.set(                                         atomics);
    ral.nvdla.NVDLA_CSC.D_RELEASE.RLS_SLICES.set(                                      rls_slices);
    ral.nvdla.NVDLA_CSC.D_CONV_STRIDE_EXT.CONV_X_STRIDE_EXT.set(                       conv_x_stride_ext);
    ral.nvdla.NVDLA_CSC.D_CONV_STRIDE_EXT.CONV_Y_STRIDE_EXT.set(                       conv_y_stride_ext);
    ral.nvdla.NVDLA_CSC.D_DILATION_EXT.X_DILATION_EXT.set(                             x_dilation_ext);
    ral.nvdla.NVDLA_CSC.D_DILATION_EXT.Y_DILATION_EXT.set(                             y_dilation_ext);
    ral.nvdla.NVDLA_CSC.D_ZERO_PADDING.PAD_LEFT.set(                                   pad_left);
    ral.nvdla.NVDLA_CSC.D_ZERO_PADDING.PAD_TOP.set(                                    pad_top);
    ral.nvdla.NVDLA_CSC.D_ZERO_PADDING_VALUE.PAD_VALUE.set(                            pad_value);
    ral.nvdla.NVDLA_CSC.D_BANK.DATA_BANK.set(                                          data_bank);
    ral.nvdla.NVDLA_CSC.D_BANK.WEIGHT_BANK.set(                                        weight_bank);
    ral.nvdla.NVDLA_CSC.D_PRA_CFG.PRA_TRUNCATE.set(                                    pra_truncate);
    ral.nvdla.NVDLA_CSC.D_CYA.CYA.set(                                                 cya);
    ral.nvdla.NVDLA_CMAC_A.D_MISC_CFG.CONV_MODE.set(                                   conv_mode);
    ral.nvdla.NVDLA_CMAC_A.D_MISC_CFG.PROC_PRECISION.set(                              proc_precision);
    ral.nvdla.NVDLA_CMAC_B.D_MISC_CFG.CONV_MODE.set(                                   conv_mode);
    ral.nvdla.NVDLA_CMAC_B.D_MISC_CFG.PROC_PRECISION.set(                              proc_precision);
    ral.nvdla.NVDLA_CACC.D_MISC_CFG.CONV_MODE.set(                                     conv_mode);
    ral.nvdla.NVDLA_CACC.D_MISC_CFG.PROC_PRECISION.set(                                proc_precision);
    ral.nvdla.NVDLA_CACC.D_DATAOUT_SIZE_0.DATAOUT_WIDTH.set(                           dataout_width);
    ral.nvdla.NVDLA_CACC.D_DATAOUT_SIZE_0.DATAOUT_HEIGHT.set(                          dataout_height);
    ral.nvdla.NVDLA_CACC.D_DATAOUT_SIZE_1.DATAOUT_CHANNEL.set(                         dataout_channel);
    ral.nvdla.NVDLA_CACC.D_DATAOUT_ADDR.DATAOUT_ADDR.set(                              dataout_addr);
    ral.nvdla.NVDLA_CACC.D_BATCH_NUMBER.BATCHES.set(                                   batches);
    ral.nvdla.NVDLA_CACC.D_LINE_STRIDE.LINE_STRIDE.set(                                line_stride);
    ral.nvdla.NVDLA_CACC.D_SURF_STRIDE.SURF_STRIDE.set(                                surf_stride);
    ral.nvdla.NVDLA_CACC.D_DATAOUT_MAP.LINE_PACKED.set(                                line_packed);
    ral.nvdla.NVDLA_CACC.D_DATAOUT_MAP.SURF_PACKED.set(                                surf_packed);
    ral.nvdla.NVDLA_CACC.D_CLIP_CFG.CLIP_TRUNCATE.set(                                 clip_truncate);
    ral.nvdla.NVDLA_CACC.D_CYA.CYA.set(                                                cya);
    //:) epython: generated_end (DO NOT EDIT ABOVE)
endfunction : set_register

`endif //_NVDLA_CC_DP_RESOURCE_SV_
