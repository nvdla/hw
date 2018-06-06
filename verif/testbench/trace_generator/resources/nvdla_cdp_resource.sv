`ifndef _NVDLA_CDP_RESOURCE_SV_
`define _NVDLA_CDP_RESOURCE_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_cdp_resource
//
// @description: various hardware resources of cdp sub module
//-------------------------------------------------------------------------------------

class nvdla_cdp_resource extends nvdla_base_resource;
    // singleton handle
    static local nvdla_cdp_resource inst;

    // LUT data pattern settings
    string cdp_lut_lo_data_pattern = "RANDOM";
    string cdp_lut_le_data_pattern = "RANDOM";

    // enum define
    //:| import spec2constrain
    //:| global spec2cons
    //:| spec2cons = spec2constrain.Spec2Cons()
    //:| spec2cons.enum_gen(['NVDLA_CDP'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    typedef enum{ lut_table_id_LE                  = 'h0
                 ,lut_table_id_LO                  = 'h1
                } lut_table_id_t;
    typedef enum{ lut_access_type_READ             = 'h0
                 ,lut_access_type_WRITE            = 'h1
                } lut_access_type_t;
    typedef enum{ lut_le_function_EXPONENT         = 'h0
                 ,lut_le_function_LINEAR           = 'h1
                } lut_le_function_t;
    typedef enum{ lut_uflow_priority_LE            = 'h0
                 ,lut_uflow_priority_LO            = 'h1
                } lut_uflow_priority_t;
    typedef enum{ lut_oflow_priority_LE            = 'h0
                 ,lut_oflow_priority_LO            = 'h1
                } lut_oflow_priority_t;
    typedef enum{ lut_hybrid_priority_LE           = 'h0
                 ,lut_hybrid_priority_LO           = 'h1
                } lut_hybrid_priority_t;
    typedef enum{ sqsum_bypass_DISABLE             = 'h0
                 ,sqsum_bypass_ENABLE              = 'h1
                } sqsum_bypass_t;
    typedef enum{ mul_bypass_DISABLE               = 'h0
                 ,mul_bypass_ENABLE                = 'h1
                } mul_bypass_t;
    typedef enum{ dst_ram_type_CV                  = 'h0
                 ,dst_ram_type_MC                  = 'h1
                } dst_ram_type_t;
    typedef enum{ input_data_type_INT8             = 'h0
                 ,input_data_type_INT16            = 'h1
                 ,input_data_type_FP16             = 'h2
                } input_data_type_t;
    typedef enum{ nan_to_zero_DISABLE              = 'h0
                 ,nan_to_zero_ENABLE               = 'h1
                } nan_to_zero_t;
    typedef enum{ normalz_len_LEN3                 = 'h0
                 ,normalz_len_LEN5                 = 'h1
                 ,normalz_len_LEN7                 = 'h2
                 ,normalz_len_LEN9                 = 'h3
                } normalz_len_t;
    typedef enum{ dma_en_DISABLE                   = 'h0
                 ,dma_en_ENABLE                    = 'h1
                } dma_en_t;
    typedef enum{ lut_en_DISABLE                   = 'h0
                 ,lut_en_ENABLE                    = 'h1
                } lut_en_t;
    //:) epython: generated_end (DO NOT EDIT ABOVE)

    /*
        LUT_REUSE config: IF working in lut_reuse mode, input data type must be the same with pre layer, 
        set pre_input_data_type(default) to INT8
    */
    rand bit          cdp_lut_reuse        = 0;
    input_data_type_t pre_input_data_type  = input_data_type_INT8;


    // field variables
    //:| spec2cons.state_gen(['NVDLA_CDP'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    rand bit [9:0]                  lut_addr;
    rand lut_table_id_t             lut_table_id;
    rand lut_access_type_t          lut_access_type;
    rand bit [15:0]                 lut_data;
    rand lut_le_function_t          lut_le_function;
    rand lut_uflow_priority_t       lut_uflow_priority;
    rand lut_oflow_priority_t       lut_oflow_priority;
    rand lut_hybrid_priority_t      lut_hybrid_priority;
    rand bit [7:0]                  lut_le_index_offset;
    rand bit [7:0]                  lut_le_index_select;
    rand bit [7:0]                  lut_lo_index_select;
    rand bit [31:0]                 lut_le_start_low;
    rand bit [5:0]                  lut_le_start_high;
    rand bit [31:0]                 lut_le_end_low;
    rand bit [5:0]                  lut_le_end_high;
    rand bit [31:0]                 lut_lo_start_low;
    rand bit [5:0]                  lut_lo_start_high;
    rand bit [31:0]                 lut_lo_end_low;
    rand bit [5:0]                  lut_lo_end_high;
    rand bit [15:0]                 lut_le_slope_uflow_scale;
    rand bit [15:0]                 lut_le_slope_oflow_scale;
    rand bit [4:0]                  lut_le_slope_uflow_shift;
    rand bit [4:0]                  lut_le_slope_oflow_shift;
    rand bit [15:0]                 lut_lo_slope_uflow_scale;
    rand bit [15:0]                 lut_lo_slope_oflow_scale;
    rand bit [4:0]                  lut_lo_slope_uflow_shift;
    rand bit [4:0]                  lut_lo_slope_oflow_shift;
    rand sqsum_bypass_t             sqsum_bypass;
    rand mul_bypass_t               mul_bypass;
    rand bit [31:0]                 dst_base_addr_low;
    rand bit [31:0]                 dst_base_addr_high;
    rand bit [31:0]                 dst_line_stride;
    rand bit [31:0]                 dst_surface_stride;
    rand dst_ram_type_t             dst_ram_type;
    rand input_data_type_t          input_data_type;
    rand nan_to_zero_t              nan_to_zero;
    rand normalz_len_t              normalz_len;
    rand bit [15:0]                 datin_offset;
    rand bit [15:0]                 datin_scale;
    rand bit [4:0]                  datin_shifter;
    rand bit [31:0]                 datout_offset;
    rand bit [15:0]                 datout_scale;
    rand bit [5:0]                  datout_shifter;
    rand dma_en_t                   dma_en;
    rand lut_en_t                   lut_en;
    rand bit [31:0]                 cya;
    //:) epython: generated_end (DO NOT EDIT ABOVE)

    `uvm_component_utils_begin(nvdla_cdp_resource)
        `uvm_field_string(cdp_lut_lo_data_pattern,                     UVM_ALL_ON)
        `uvm_field_string(cdp_lut_le_data_pattern,                     UVM_ALL_ON)
        `uvm_field_int   (cdp_lut_reuse,                               UVM_ALL_ON)
        //:| spec2cons.macro_gen(['NVDLA_CDP'])
        //:) epython: generated_beg (DO NOT EDIT BELOW)
        `uvm_field_int(lut_addr,                                       UVM_ALL_ON)
        `uvm_field_enum(lut_table_id_t,           lut_table_id,        UVM_ALL_ON)
        `uvm_field_enum(lut_access_type_t,        lut_access_type,     UVM_ALL_ON)
        `uvm_field_int(lut_data,                                       UVM_ALL_ON)
        `uvm_field_enum(lut_le_function_t,        lut_le_function,     UVM_ALL_ON)
        `uvm_field_enum(lut_uflow_priority_t,     lut_uflow_priority,  UVM_ALL_ON)
        `uvm_field_enum(lut_oflow_priority_t,     lut_oflow_priority,  UVM_ALL_ON)
        `uvm_field_enum(lut_hybrid_priority_t,    lut_hybrid_priority, UVM_ALL_ON)
        `uvm_field_int(lut_le_index_offset,                            UVM_ALL_ON)
        `uvm_field_int(lut_le_index_select,                            UVM_ALL_ON)
        `uvm_field_int(lut_lo_index_select,                            UVM_ALL_ON)
        `uvm_field_int(lut_le_start_low,                               UVM_ALL_ON)
        `uvm_field_int(lut_le_start_high,                              UVM_ALL_ON)
        `uvm_field_int(lut_le_end_low,                                 UVM_ALL_ON)
        `uvm_field_int(lut_le_end_high,                                UVM_ALL_ON)
        `uvm_field_int(lut_lo_start_low,                               UVM_ALL_ON)
        `uvm_field_int(lut_lo_start_high,                              UVM_ALL_ON)
        `uvm_field_int(lut_lo_end_low,                                 UVM_ALL_ON)
        `uvm_field_int(lut_lo_end_high,                                UVM_ALL_ON)
        `uvm_field_int(lut_le_slope_uflow_scale,                       UVM_ALL_ON)
        `uvm_field_int(lut_le_slope_oflow_scale,                       UVM_ALL_ON)
        `uvm_field_int(lut_le_slope_uflow_shift,                       UVM_ALL_ON)
        `uvm_field_int(lut_le_slope_oflow_shift,                       UVM_ALL_ON)
        `uvm_field_int(lut_lo_slope_uflow_scale,                       UVM_ALL_ON)
        `uvm_field_int(lut_lo_slope_oflow_scale,                       UVM_ALL_ON)
        `uvm_field_int(lut_lo_slope_uflow_shift,                       UVM_ALL_ON)
        `uvm_field_int(lut_lo_slope_oflow_shift,                       UVM_ALL_ON)
        `uvm_field_enum(sqsum_bypass_t,           sqsum_bypass,        UVM_ALL_ON)
        `uvm_field_enum(mul_bypass_t,             mul_bypass,          UVM_ALL_ON)
        `uvm_field_int(dst_base_addr_low,                              UVM_ALL_ON)
        `uvm_field_int(dst_base_addr_high,                             UVM_ALL_ON)
        `uvm_field_int(dst_line_stride,                                UVM_ALL_ON)
        `uvm_field_int(dst_surface_stride,                             UVM_ALL_ON)
        `uvm_field_enum(dst_ram_type_t,           dst_ram_type,        UVM_ALL_ON)
        `uvm_field_enum(input_data_type_t,        input_data_type,     UVM_ALL_ON)
        `uvm_field_enum(nan_to_zero_t,            nan_to_zero,         UVM_ALL_ON)
        `uvm_field_enum(normalz_len_t,            normalz_len,         UVM_ALL_ON)
        `uvm_field_int(datin_offset,                                   UVM_ALL_ON)
        `uvm_field_int(datin_scale,                                    UVM_ALL_ON)
        `uvm_field_int(datin_shifter,                                  UVM_ALL_ON)
        `uvm_field_int(datout_offset,                                  UVM_ALL_ON)
        `uvm_field_int(datout_scale,                                   UVM_ALL_ON)
        `uvm_field_int(datout_shifter,                                 UVM_ALL_ON)
        `uvm_field_enum(dma_en_t,                 dma_en,              UVM_ALL_ON)
        `uvm_field_enum(lut_en_t,                 lut_en,              UVM_ALL_ON)
        `uvm_field_int(cya,                                            UVM_ALL_ON)
        //:) epython: generated_end (DO NOT EDIT ABOVE)
    `uvm_component_utils_end

    /*
        Methods
    */
    extern function         new(string name="nvdla_cdp_resource", uvm_component parent);
    extern static function  nvdla_cdp_resource get_cdp(uvm_component parent);
    extern function void    trace_dump(int fh);
    extern function void    set_lut();
//  extern function void    set_mem_addr();
    extern function void    set_register();
    extern function void    lut_config_dump(int fh);
    extern function void    pre_randomize();
    extern function void    post_randomize();

    /*
        phase
    */
    extern function void    build_phase  (uvm_phase phase);
    extern function void    connect_phase(uvm_phase phase);

    /*
        constraints:
            * ias_constraint: mandatory constraints from architecture requirement
            * sim_constraint: optional constraints for simulation only
    */
    // ias constraint
    extern constraint c_ias_stride_alignment;
    extern constraint c_ias_fp_no_nan_value;
    extern constraint c_ias_fp_no_inf_value;
    extern constraint c_ias_fp_no_denorm_value;
    extern constraint c_ias_lut;
    extern constraint c_ias_cvt;
    extern constraint c_ias_dut_por_requirement;
    // sim constraint
    extern constraint c_sim_lut_weight_dist;
    extern constraint c_sim_dst_mem_weight_dist;
    extern constraint c_sim_cvt_weight_dist;

endclass : nvdla_cdp_resource

function nvdla_cdp_resource::new(string name="nvdla_cdp_resource", uvm_component parent);
    super.new(name, parent);
    `uvm_info(inst_name, $sformatf("Initialize resource %s ... ",inst_name),UVM_LOW);
endfunction: new

static function  nvdla_cdp_resource nvdla_cdp_resource::get_cdp(uvm_component parent);
    if (null == inst) begin
        inst = new("NVDLA_CDP", parent);
    end
    return inst;
endfunction: get_cdp

function void nvdla_cdp_resource::build_phase(uvm_phase phase);
    super.build_phase(phase);

endfunction: build_phase

function void nvdla_cdp_resource::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if(!uvm_config_db#(string)::get(this, "", "cdp_lut_lo_data_pattern", cdp_lut_lo_data_pattern)) begin
        `uvm_info(inst_name, "NO cdp_lut_lo_data_pattern config, using default value: RANDOM", UVM_NONE)
    end
    if(!uvm_config_db#(string)::get(this, "", "cdp_lut_le_data_pattern", cdp_lut_le_data_pattern)) begin
        `uvm_info(inst_name, "NO cdp_lut_le_data_pattern config, using default value: RANDOM", UVM_NONE)
    end
    if(!uvm_config_db#(int)::get(this, "", "cdp_lut_reuse", cdp_lut_reuse)) begin
        `uvm_info(inst_name, $sformatf("NO cdp_lut_reuse config, using random value"), UVM_NONE)
    end
endfunction: connect_phase

function void nvdla_cdp_resource::lut_config_dump(int fh);
    uvm_reg_data_t reg_val;

    if(cdp_lut_reuse == 0 || active_cnt < 1) begin  // NO LUT reuse
        $display("lut_reuse:%0d, active_cnt=%0d", cdp_lut_reuse, active_cnt);
        // LUT is only configurable when there's no active layer running
        if (get_active_cnt() > 0) begin
            sync_wait(fh,inst_name,sync_evt_queue[-1]);
        end
        if (get_active_cnt() > 1) begin
            sync_wait(fh,inst_name,sync_evt_queue[-2]);
        end

        // Configure LUT table
        ral.nvdla.NVDLA_CDP.S_LUT_ACCESS_CFG.LUT_ADDR.set(0);
        ral.nvdla.NVDLA_CDP.S_LUT_ACCESS_CFG.LUT_TABLE_ID.set(0);    // LE
        ral.nvdla.NVDLA_CDP.S_LUT_ACCESS_CFG.LUT_ACCESS_TYPE.set(1); // WRITE
        reg_val = ral.nvdla.NVDLA_CDP.S_LUT_ACCESS_CFG.get();
        reg_write(fh,{inst_name.toupper(),".S_LUT_ACCESS_CFG"}, reg_val);

        if ("LOAD_EXTERNAL_" == cdp_lut_le_data_pattern.toupper().substr(0,13)) begin
            string file_name = cdp_lut_le_data_pattern.substr(14,cdp_lut_le_data_pattern.len()-1);
            bit [15:0] le_table[65];
            bit [15:0] lo_table[257];
            lut_table_load(file_name, le_table, lo_table);
            for(int i=0;i<65;i++) begin
                reg_write(fh,{inst_name.toupper(),".S_LUT_ACCESS_DATA"}, le_table[i]);
            end
        end
        else begin
            for(int i=0;i<65;i++) begin
                // NO FP data format
                if ("INDEX" == cdp_lut_le_data_pattern) begin
                    reg_write(fh,{inst_name.toupper(),".S_LUT_ACCESS_DATA"}, i);
                end else if ("CONSTANT_0X" == cdp_lut_le_data_pattern.toupper().substr(0,10)) begin
                    bit[15:0] lut_val = cdp_lut_le_data_pattern.substr(9,cdp_lut_le_data_pattern.len()-1).atohex();
                    reg_write(fh,{inst_name.toupper(),".S_LUT_ACCESS_DATA"}, lut_val);
                end else begin
                    bit[15:0] lut_val = $urandom_range(0,16'hFFFF);
                    reg_write(fh,{inst_name.toupper(),".S_LUT_ACCESS_DATA"}, lut_val);
                end
            end
        end
        ral.nvdla.NVDLA_CDP.S_LUT_ACCESS_CFG.LUT_ADDR.set(0);
        ral.nvdla.NVDLA_CDP.S_LUT_ACCESS_CFG.LUT_TABLE_ID.set(1);
        ral.nvdla.NVDLA_CDP.S_LUT_ACCESS_CFG.LUT_ACCESS_TYPE.set(1);
        reg_val = ral.nvdla.NVDLA_CDP.S_LUT_ACCESS_CFG.get();
        reg_write(fh,{inst_name.toupper(),".S_LUT_ACCESS_CFG"}, reg_val);

        if ("LOAD_EXTERNAL_" == cdp_lut_lo_data_pattern.toupper().substr(0,13)) begin
            string file_name = cdp_lut_lo_data_pattern.substr(14,cdp_lut_lo_data_pattern.len()-1);
            bit [15:0] le_table[65];
            bit [15:0] lo_table[257];
            lut_table_load(file_name, le_table, lo_table);
            for(int i=0;i<257;i++) begin
                reg_write(fh,{inst_name.toupper(),".S_LUT_ACCESS_DATA"}, lo_table[i]);
            end
        end
        else begin
            for(int i=0;i<257;i++) begin
                // NO FP data format
                if ("INDEX" == cdp_lut_lo_data_pattern) begin
                    reg_write(fh,{inst_name.toupper(),".S_LUT_ACCESS_DATA"}, i);
                end else if ("CONSTANT_0X" == cdp_lut_lo_data_pattern.toupper().substr(0,10)) begin
                    bit[15:0] lut_val = cdp_lut_lo_data_pattern.substr(9,cdp_lut_lo_data_pattern.len()-1).atohex();
                    reg_write(fh,{inst_name.toupper(),".S_LUT_ACCESS_DATA"}, lut_val);
                end else begin
                    bit[15:0] lut_val = $urandom_range(0,16'hFFFF);
                    reg_write(fh,{inst_name.toupper(),".S_LUT_ACCESS_DATA"}, lut_val);
                end
            end
        end
        begin
            reg_val = ral.nvdla.NVDLA_CDP.S_LUT_CFG.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_CFG"}, reg_val);

            reg_val = ral.nvdla.NVDLA_CDP.S_LUT_INFO.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_INFO"}, reg_val);

            reg_val = ral.nvdla.NVDLA_CDP.S_LUT_LE_START_LOW.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_LE_START_LOW"}, reg_val);

            reg_val = ral.nvdla.NVDLA_CDP.S_LUT_LE_START_HIGH.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_LE_START_HIGH"}, reg_val);

            reg_val = ral.nvdla.NVDLA_CDP.S_LUT_LE_END_LOW.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_LE_END_LOW"}, reg_val);

            reg_val = ral.nvdla.NVDLA_CDP.S_LUT_LE_END_HIGH.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_LE_END_HIGH"}, reg_val);

            reg_val = ral.nvdla.NVDLA_CDP.S_LUT_LO_START_LOW.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_LO_START_LOW"}, reg_val);

            reg_val = ral.nvdla.NVDLA_CDP.S_LUT_LO_START_HIGH.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_LO_START_HIGH"}, reg_val);

            reg_val = ral.nvdla.NVDLA_CDP.S_LUT_LO_END_LOW.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_LO_END_LOW"}, reg_val);

            reg_val = ral.nvdla.NVDLA_CDP.S_LUT_LO_END_HIGH.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_LO_END_HIGH"}, reg_val);

            reg_val = ral.nvdla.NVDLA_CDP.S_LUT_LE_SLOPE_SCALE.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_LE_SLOPE_SCALE"}, reg_val);

            reg_val = ral.nvdla.NVDLA_CDP.S_LUT_LE_SLOPE_SHIFT.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_LE_SLOPE_SHIFT"}, reg_val);

            reg_val = ral.nvdla.NVDLA_CDP.S_LUT_LO_SLOPE_SCALE.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_LO_SLOPE_SCALE"}, reg_val);

            reg_val = ral.nvdla.NVDLA_CDP.S_LUT_LO_SLOPE_SHIFT.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_LO_SLOPE_SHIFT"}, reg_val);
        end
    end
endfunction : lut_config_dump

function void nvdla_cdp_resource::trace_dump(int fh);
    if(fh==null) begin
        `uvm_fatal(inst_name, "Null handle of trace file ...")
    end
    `uvm_info(inst_name, "Start trace dumping ...", UVM_HIGH)
    // if both groups have been used, resource must wait for the same group released
    if (get_active_cnt() > 1) begin
        sync_wait(fh,inst_name,sync_evt_queue[-2]);
    end

    reg_write(fh,{inst_name.toupper(),".S_POINTER"},group_to_use);

    begin
        uvm_reg        reg_q[$];
        uvm_reg_data_t val;
        uvm_status_e   status;

        ral.nvdla.NVDLA_CDP.get_registers(reg_q);
        reg_q.shuffle();
        foreach(reg_q[i]) begin
            if(reg_q[i].get_rights() != "RW") begin
                continue;
            end
            else if(reg_q[i].get_name().substr(0,5) == "S_LUT_") begin
                continue;
            end
            case(reg_q[i].get_name())
                "D_OP_ENABLE",
                "S_POINTER": ;
                default: reg_write(fh,{inst_name.toupper(),".",reg_q[i].get_name()},int'(reg_q[i].get()));
            endcase
        end
    end

    // Dump LUT config
    lut_config_dump(fh);

    ral.nvdla.NVDLA_CDP.D_OP_ENABLE.set(1);
    reg_write(fh,{inst_name.toupper(),".D_OP_ENABLE"},1);
    intr_notify(fh,{"CDP_",$sformatf("%0d",group_to_use)}, sync_evt_queue[0]);
    `uvm_info(inst_name, "Finish trace dumping ...", UVM_HIGH)
endfunction : trace_dump

function void nvdla_cdp_resource::set_lut();
    chandle fp32_a = new_FP32();
    chandle fp32_b = new_FP32();
    chandle fp32_o = new_FP32();

    // FP format value post configuration
    if(input_data_type == input_data_type_FP16) begin
        bit [31:0] data_b = 0;
        set_FP32(fp32_a, lut_le_start_low);
        if(lut_le_function == lut_le_function_LINEAR) begin
            data_b[30:23] = (signed'(lut_le_index_select)+6) + 7'h7F;
            set_FP32(fp32_b, data_b);
        end
        else begin
            if(signed'(lut_le_index_offset) <= 63) begin
                data_b[30:23] = (signed'(lut_le_index_offset)+64) + 7'h7F;
            end
            else begin
                data_b[30:23] = 8'hFF;
            end
            set_FP32(fp32_b, data_b);
        end
        FpAdd_FP32_ref(fp32_a, fp32_b, fp32_o);
        get_FP32(fp32_o, lut_le_end_low);
        if((lut_le_end_low[22:0] == 0) && (lut_le_end_low[30:23] == 8'hFF)) begin
            lut_le_end_low = 32'h7F7F_FFFF;
        end
        lut_le_end_high = (lut_le_end_low[31]==0)?6'h0:6'h3F;

        set_FP32(fp32_a, lut_lo_start_low);
        data_b[30:23] = (signed'(lut_lo_index_select)+8) + 7'h7F;
        set_FP32(fp32_b, data_b);
        FpAdd_FP32_ref(fp32_a, fp32_b, fp32_o);
        get_FP32(fp32_o, lut_lo_end_low);
        if((lut_lo_end_low[22:0] == 0) && (lut_lo_end_low[30:23] == 8'hFF)) begin
            lut_lo_end_low = 32'h7F7F_FFFF;
        end
        lut_lo_end_high = (lut_lo_end_low[31]==0)?6'h0:6'h3F;
    end
endfunction : set_lut

// FIXME, require to add channel register
// function void nvdla_cdp_resource::set_mem_addr();
//     mem_man         mm;
//     mem_region      region;
//     int             mem_size;
//
//     mm = mem_man::get_mem_man();
//
//     // WDMA
//     mem_size = calc_mem_size(0, 0, channel+1, `NVDLA_MEMORY_ATOMIC_SIZE, dst_surface_stride);
//     region = mm.request_region_by_size("pri_mem", $sformatf("%s_%0d", "CDP_WDMA", get_active_cnt()), mem_size, align_mask[0]);
//     {dst_base_addr_high, dst_base_addr_low} = region.get_start_offset();
// endfunction : set_mem_addr

constraint nvdla_cdp_resource::c_ias_stride_alignment {
    // alignment according to atomic size
    dst_line_stride    % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    dst_surface_stride % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
}

constraint nvdla_cdp_resource::c_ias_fp_no_nan_value {
    // NONE NAN value in FP format
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    if(input_data_type == input_data_type_FP16) {
        !((lut_data[9:0]                 != 0) && (lut_data[14:10]                 == 5'h1F));
        !((lut_le_start_low[22:0]        != 0) && (lut_le_start_low[30:23]         == 8'hFF));
        !((lut_le_end_low[22:0]          != 0) && (lut_le_end_low[30:23]           == 8'hFF));
        !((lut_lo_start_low[22:0]        != 0) && (lut_lo_start_low[30:23]         == 8'hFF));
        !((lut_lo_end_low[22:0]          != 0) && (lut_lo_end_low[30:23]           == 8'hFF));
        !((lut_le_slope_uflow_scale[9:0] != 0) && (lut_le_slope_uflow_scale[14:10] == 5'h1F));
        !((lut_le_slope_oflow_scale[9:0] != 0) && (lut_le_slope_oflow_scale[14:10] == 5'h1F));
        !((lut_lo_slope_uflow_scale[9:0] != 0) && (lut_lo_slope_uflow_scale[14:10] == 5'h1F));
        !((lut_lo_slope_oflow_scale[9:0] != 0) && (lut_lo_slope_oflow_scale[14:10] == 5'h1F));
    }
`endif
}

constraint nvdla_cdp_resource::c_ias_fp_no_inf_value {
    // NONE INF
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    if(input_data_type == input_data_type_FP16) {
        !((lut_data[9:0]                 == 0) && (lut_data[14:10]                 == 5'h1F));
        !((lut_le_start_low[22:0]        == 0) && (lut_le_start_low[30:23]         == 8'hFF));
        !((lut_le_end_low[22:0]          == 0) && (lut_le_end_low[30:23]           == 8'hFF));
        !((lut_lo_start_low[22:0]        == 0) && (lut_lo_start_low[30:23]         == 8'hFF));
        !((lut_lo_end_low[22:0]          == 0) && (lut_lo_end_low[30:23]           == 8'hFF));
        !((lut_le_slope_uflow_scale[9:0] == 0) && (lut_le_slope_uflow_scale[14:10] == 5'h1F));
        !((lut_le_slope_oflow_scale[9:0] == 0) && (lut_le_slope_oflow_scale[14:10] == 5'h1F));
        !((lut_lo_slope_uflow_scale[9:0] == 0) && (lut_lo_slope_uflow_scale[14:10] == 5'h1F));
        !((lut_lo_slope_oflow_scale[9:0] == 0) && (lut_lo_slope_oflow_scale[14:10] == 5'h1F));
    }
`endif
}

constraint nvdla_cdp_resource::c_ias_fp_no_denorm_value {
    // NONE DENORM
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    if(input_data_type == input_data_type_FP16) {
        !((lut_le_start_low[22:0] != 0) && (lut_le_start_low[30:23] == 0));
        !((lut_le_end_low[22:0]   != 0) && (lut_le_end_low[30:23]   == 0));
        !((lut_lo_start_low[22:0] != 0) && (lut_lo_start_low[30:23] == 0));
        !((lut_lo_end_low[22:0]   != 0) && (lut_lo_end_low[30:23]   == 0));
    }
`endif
}

constraint nvdla_cdp_resource::c_ias_lut {
    solve lut_table_id before lut_addr;
    (lut_table_id == lut_table_id_LE) -> {lut_addr <= 10'h40; }
    (lut_table_id == lut_table_id_LO) -> {lut_addr <= 10'h100;}

    solve lut_table_id    before lut_le_index_offset;
    solve lut_le_function before lut_le_index_offset;
    solve lut_table_id    before lut_le_index_select;
    solve lut_le_function before lut_le_index_select;
    solve input_data_type before lut_le_index_select;
    solve lut_table_id    before lut_lo_index_select;
    solve input_data_type before lut_lo_index_select;
    // Signed Field, constriant for sign bit extension
    // Bug 200287664
    if(lut_le_function == lut_le_function_EXPONENT) {
        lut_le_index_select == 0;
    }
    else if(lut_le_function == lut_le_function_LINEAR) {
        if(input_data_type == input_data_type_INT8) {
                lut_le_index_select[7:5]          inside {3'h0, 3'h7};
                signed'(lut_le_index_select[5:0]) inside {[-6:15]};
        }
        else if(input_data_type == input_data_type_INT16) {
                lut_le_index_select[7:6]          inside {2'h0, 2'h3};
                signed'(lut_le_index_select[6:0]) inside {[-6:31]};
        }
        lut_le_index_offset == 0;
    }
    if(input_data_type == input_data_type_INT8) {
            lut_lo_index_select[7:5]          inside {3'h0, 3'h7};
            signed'(lut_lo_index_select[5:0]) inside {[-8:13]};
    }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    else if(input_data_type == input_data_type_INT16) {
            lut_lo_index_select[7:6]          inside {2'h0, 2'h3};
            signed'(lut_lo_index_select[6:0]) inside {[-8:29]};
    }
`endif
    // Add solve before
    if(lut_le_function == lut_le_function_LINEAR) {
        if(input_data_type == input_data_type_INT8) {
            (signed'(lut_le_end_low[21:0]) > signed'(lut_le_start_low[21:0]));
            (signed'(lut_le_end_low[21:0]) - signed'(lut_le_start_low[21:0])) == (1<<(signed'(lut_le_index_select[5:0])+6));
        }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
        else if(input_data_type == input_data_type_INT16){
            (signed'({lut_le_end_high, lut_le_end_low}) > signed'({lut_le_start_high, lut_le_start_low}));
            (signed'({lut_le_end_high, lut_le_end_low}) - signed'({lut_le_start_high, lut_le_start_low})) == (1<<(signed'(lut_le_index_select[6:0])+6));
        }
        else {
            signed'({1'b0,lut_le_start_low[30:23]}) <= (signed'(lut_le_index_select)+6) + 127 + 23; // constrains for diffrence between le_low and le_index_select
            signed'(lut_le_index_select)            <= 121;
        }
`endif
    }
    else {
        signed'(lut_le_index_offset) != -128;
        if(input_data_type == input_data_type_INT8) {
            (signed'(lut_le_end_low[21:0]) > signed'(lut_le_start_low[21:0]));
            signed'(lut_le_index_offset) dist {[-64:-43]:=80, [-42:20]:=20};
            if(signed'(lut_le_index_offset) <= -43) {
                (signed'(lut_le_end_low[21:0]) - signed'(lut_le_start_low[21:0])) == (1<<(signed'(lut_le_index_offset)+64));
            }
            else {
                lut_le_end_low[21:0] == 22'h1F_FFFF;
            }
        }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
        else if(input_data_type == input_data_type_INT16){
            (signed'({lut_le_end_high, lut_le_end_low}) > signed'({lut_le_start_high, lut_le_start_low}));
            signed'(lut_le_index_offset) dist {[-64:-27]:=80, [-26:36]:=20};
            if(signed'(lut_le_index_offset) <= -27) {
                (signed'({lut_le_end_high, lut_le_end_low}) - signed'({lut_le_start_high, lut_le_start_low})) == (1<<(signed'(lut_le_index_offset)+64));
            }
            else {
                signed'({lut_le_end_high, lut_le_end_low}) == 38'h1F_FFFF_FFFF;
            }
        }
        else {
            signed'({1'b0,lut_le_start_low[30:23]}) <= (signed'(lut_le_index_offset)+64) + 127 + 23;
            signed'(lut_le_index_offset)            <= 127;
            signed'(lut_le_index_offset)            >= -126;
        }
`endif
    }

    if(input_data_type == input_data_type_INT8) {
        (signed'(lut_lo_end_low[21:0]) > signed'(lut_lo_start_low[21:0]));
        (signed'(lut_lo_end_low[21:0]) - signed'(lut_lo_start_low[21:0])) == (1<<(signed'(lut_lo_index_select[5:0])+8));
    }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    else if(input_data_type == input_data_type_INT16){
        (signed'({lut_lo_end_high, lut_lo_end_low}) > signed'({lut_lo_start_high, lut_lo_start_low}));
        (signed'({lut_lo_end_high, lut_lo_end_low}) - signed'({lut_lo_start_high, lut_lo_start_low})) == (1<<(signed'(lut_lo_index_select[6:0])+8));
    }
    else {
        signed'({1'b0,lut_lo_start_low[30:23]}) <= (signed'(lut_lo_index_select)+8) + 127 + 21;
        signed'(lut_lo_index_select)            <= 119;
    }
`endif

    solve input_data_type before lut_le_start_low;
    solve input_data_type before lut_le_start_high;
    if(input_data_type == input_data_type_INT8) {
        if(lut_le_start_low[21] == 0) {
            lut_le_start_high       == 6'h0;
            lut_le_start_low[31:22] == 10'h0;
        }
        else {
            lut_le_start_high == 6'h3F;
            lut_le_start_low[31:22] == 10'h3FF;
        }
    }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    else if(input_data_type == input_data_type_FP16) {
        if(lut_le_start_low[31] == 0) {
            lut_le_start_high == 6'h0;
        }
        else {
            lut_le_start_high == 6'h3F;
        }
        // invalid: NAN, INF, DENORM
        !(lut_le_start_low[30:23] == 8'hFF);
        !((lut_le_start_low[22:0] != 0) && (lut_le_start_low[30:23] == 0));
    }
`endif

    solve input_data_type before lut_le_end_low;
    solve input_data_type before lut_le_end_high;
    if(input_data_type == input_data_type_INT8) {
        if(lut_le_end_low[21] == 0) {
            lut_le_end_high       == 6'h0;
            lut_le_end_low[31:22] == 10'h0;
        }
        else {
            lut_le_end_high       == 6'h3F;
            lut_le_end_low[31:22] == 10'h3FF;
        }
    }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    else if(input_data_type == input_data_type_FP16) {
        if(lut_le_end_low[31] == 0) {
            lut_le_end_high == 6'h0;
        }
        else {
            lut_le_end_high == 6'h3F;
        }
    }
`endif

    solve input_data_type before lut_lo_start_low;
    solve input_data_type before lut_lo_start_high;
    if(input_data_type == input_data_type_INT8) {
        if(lut_lo_start_low[21] == 0) {
            lut_lo_start_high       == 6'h0;
            lut_lo_start_low[31:22] == 10'h0;
        }
        else {
            lut_lo_start_high       == 6'h3F;
            lut_lo_start_low[31:22] == 10'h3FF;
        }
    }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    else if(input_data_type == input_data_type_FP16) {
        if(lut_lo_start_low[31] == 0) {
            lut_lo_start_high == 6'h0;
        }
        else {
            lut_lo_start_high == 6'h3F;
        }
        // invalid: NAN, INF, DENORM
        !(lut_lo_start_low[30:23] == 8'hFF);
        !((lut_lo_start_low[22:0] != 0) && (lut_lo_start_low[30:23] == 0));
    }
`endif

    solve input_data_type before lut_lo_end_low;
    solve input_data_type before lut_lo_end_high;
    if(input_data_type == input_data_type_INT8) {
        if(lut_lo_end_low[21] == 0) {
            lut_lo_end_high       == 6'h0;
            lut_lo_end_low[31:22] == 10'h0;
        }
        else {
            lut_lo_end_high       == 6'h3F;
            lut_lo_end_low[31:22] == 10'h3FF;
        }
    }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    else if(input_data_type == input_data_type_FP16) {
        if(lut_lo_end_low[31] == 0) {
            lut_lo_end_high == 6'h0;
        }
        else {
            lut_lo_end_high == 6'h3F;
        }
    }
`endif
}

constraint nvdla_cdp_resource::c_ias_cvt {
    solve input_data_type before datin_offset;
    solve input_data_type before datout_offset;
    if(input_data_type == input_data_type_INT8) {
        datin_offset[15:7]   inside {9'h0, 9'h1FF};
        datout_offset[31:24] inside {8'h0, 8'hFF};
    }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    else if(input_data_type == input_data_type_FP16) {
        datout_offset[31:15] inside {17'h0, 17'h1_FFFF};
    }
`endif
}

constraint nvdla_cdp_resource::c_ias_dut_por_requirement {
`ifndef NVDLA_SECONDARY_MEMIF_ENABLE
    dst_ram_type    == dst_ram_type_MC ;
`endif
    input_data_type == input_data_type_INT8;
}

constraint nvdla_cdp_resource::c_sim_lut_weight_dist {
    `weight_dist_10bit(lut_addr)
    `weight_dist_8bit(lut_le_index_offset)
    `weight_dist_8bit(lut_le_index_select)
    `weight_dist_8bit(lut_lo_index_select)
    `weight_dist_32bit(lut_le_start_low)
    `weight_dist_6bit(lut_le_start_high)
    `weight_dist_32bit(lut_le_end_low)
    `weight_dist_6bit(lut_le_end_high)
    `weight_dist_32bit(lut_lo_start_low)
    `weight_dist_6bit(lut_lo_start_high)
    `weight_dist_32bit(lut_lo_end_low)
    `weight_dist_6bit(lut_lo_end_high)
    `weight_dist_16bit(lut_le_slope_uflow_scale)
    `weight_dist_16bit(lut_le_slope_oflow_scale)
    `weight_dist_5bit(lut_le_slope_uflow_shift)
    `weight_dist_5bit(lut_le_slope_oflow_shift)
    `weight_dist_16bit(lut_lo_slope_uflow_scale)
    `weight_dist_16bit(lut_lo_slope_oflow_scale)
    `weight_dist_5bit(lut_lo_slope_uflow_shift)
    `weight_dist_5bit(lut_lo_slope_oflow_shift)
}

constraint nvdla_cdp_resource::c_sim_dst_mem_weight_dist {
    `weight_dist_32bit(dst_base_addr_low)
    `weight_dist_32bit(dst_base_addr_high)
    `weight_dist_32bit(dst_line_stride)
    `weight_dist_32bit(dst_surface_stride)
}

constraint nvdla_cdp_resource::c_sim_cvt_weight_dist {
    `weight_dist_16bit(datin_offset)
    `weight_dist_16bit(datin_scale)
    `weight_dist_5bit(datin_shifter)
    `weight_dist_32bit(datout_offset)
    `weight_dist_16bit(datout_scale)
    `weight_dist_6bit(datout_shifter)
}

function void nvdla_cdp_resource::pre_randomize();
    if(cdp_lut_reuse == 1 && active_cnt >= 1) begin
        input_data_type = pre_input_data_type;
        input_data_type.rand_mode(0);
    end
endfunction : pre_randomize

function void nvdla_cdp_resource::post_randomize();
    set_lut();
//  set_mem_addr();
    set_register();
    // For LUT_REUSE usage
    pre_input_data_type = input_data_type;
    input_data_type.rand_mode(1);

    `uvm_info(inst_name, {"\n", sprint()}, UVM_HIGH)
endfunction : post_randomize

function void nvdla_cdp_resource::set_register();
    //:| spec2cons.ral_set(['NVDLA_CDP'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    ral.nvdla.NVDLA_CDP.S_LUT_ACCESS_CFG.LUT_ADDR.set(                                 lut_addr);
    ral.nvdla.NVDLA_CDP.S_LUT_ACCESS_CFG.LUT_TABLE_ID.set(                             lut_table_id);
    ral.nvdla.NVDLA_CDP.S_LUT_ACCESS_CFG.LUT_ACCESS_TYPE.set(                          lut_access_type);
    ral.nvdla.NVDLA_CDP.S_LUT_ACCESS_DATA.LUT_DATA.set(                                lut_data);
    ral.nvdla.NVDLA_CDP.S_LUT_CFG.LUT_LE_FUNCTION.set(                                 lut_le_function);
    ral.nvdla.NVDLA_CDP.S_LUT_CFG.LUT_UFLOW_PRIORITY.set(                              lut_uflow_priority);
    ral.nvdla.NVDLA_CDP.S_LUT_CFG.LUT_OFLOW_PRIORITY.set(                              lut_oflow_priority);
    ral.nvdla.NVDLA_CDP.S_LUT_CFG.LUT_HYBRID_PRIORITY.set(                             lut_hybrid_priority);
    ral.nvdla.NVDLA_CDP.S_LUT_INFO.LUT_LE_INDEX_OFFSET.set(                            lut_le_index_offset);
    ral.nvdla.NVDLA_CDP.S_LUT_INFO.LUT_LE_INDEX_SELECT.set(                            lut_le_index_select);
    ral.nvdla.NVDLA_CDP.S_LUT_INFO.LUT_LO_INDEX_SELECT.set(                            lut_lo_index_select);
    ral.nvdla.NVDLA_CDP.S_LUT_LE_START_LOW.LUT_LE_START_LOW.set(                       lut_le_start_low);
    ral.nvdla.NVDLA_CDP.S_LUT_LE_START_HIGH.LUT_LE_START_HIGH.set(                     lut_le_start_high);
    ral.nvdla.NVDLA_CDP.S_LUT_LE_END_LOW.LUT_LE_END_LOW.set(                           lut_le_end_low);
    ral.nvdla.NVDLA_CDP.S_LUT_LE_END_HIGH.LUT_LE_END_HIGH.set(                         lut_le_end_high);
    ral.nvdla.NVDLA_CDP.S_LUT_LO_START_LOW.LUT_LO_START_LOW.set(                       lut_lo_start_low);
    ral.nvdla.NVDLA_CDP.S_LUT_LO_START_HIGH.LUT_LO_START_HIGH.set(                     lut_lo_start_high);
    ral.nvdla.NVDLA_CDP.S_LUT_LO_END_LOW.LUT_LO_END_LOW.set(                           lut_lo_end_low);
    ral.nvdla.NVDLA_CDP.S_LUT_LO_END_HIGH.LUT_LO_END_HIGH.set(                         lut_lo_end_high);
    ral.nvdla.NVDLA_CDP.S_LUT_LE_SLOPE_SCALE.LUT_LE_SLOPE_UFLOW_SCALE.set(             lut_le_slope_uflow_scale);
    ral.nvdla.NVDLA_CDP.S_LUT_LE_SLOPE_SCALE.LUT_LE_SLOPE_OFLOW_SCALE.set(             lut_le_slope_oflow_scale);
    ral.nvdla.NVDLA_CDP.S_LUT_LE_SLOPE_SHIFT.LUT_LE_SLOPE_UFLOW_SHIFT.set(             lut_le_slope_uflow_shift);
    ral.nvdla.NVDLA_CDP.S_LUT_LE_SLOPE_SHIFT.LUT_LE_SLOPE_OFLOW_SHIFT.set(             lut_le_slope_oflow_shift);
    ral.nvdla.NVDLA_CDP.S_LUT_LO_SLOPE_SCALE.LUT_LO_SLOPE_UFLOW_SCALE.set(             lut_lo_slope_uflow_scale);
    ral.nvdla.NVDLA_CDP.S_LUT_LO_SLOPE_SCALE.LUT_LO_SLOPE_OFLOW_SCALE.set(             lut_lo_slope_oflow_scale);
    ral.nvdla.NVDLA_CDP.S_LUT_LO_SLOPE_SHIFT.LUT_LO_SLOPE_UFLOW_SHIFT.set(             lut_lo_slope_uflow_shift);
    ral.nvdla.NVDLA_CDP.S_LUT_LO_SLOPE_SHIFT.LUT_LO_SLOPE_OFLOW_SHIFT.set(             lut_lo_slope_oflow_shift);
    ral.nvdla.NVDLA_CDP.D_FUNC_BYPASS.SQSUM_BYPASS.set(                                sqsum_bypass);
    ral.nvdla.NVDLA_CDP.D_FUNC_BYPASS.MUL_BYPASS.set(                                  mul_bypass);
    ral.nvdla.NVDLA_CDP.D_DST_BASE_ADDR_LOW.DST_BASE_ADDR_LOW.set(                     dst_base_addr_low);
    ral.nvdla.NVDLA_CDP.D_DST_BASE_ADDR_HIGH.DST_BASE_ADDR_HIGH.set(                   dst_base_addr_high);
    ral.nvdla.NVDLA_CDP.D_DST_LINE_STRIDE.DST_LINE_STRIDE.set(                         dst_line_stride);
    ral.nvdla.NVDLA_CDP.D_DST_SURFACE_STRIDE.DST_SURFACE_STRIDE.set(                   dst_surface_stride);
    ral.nvdla.NVDLA_CDP.D_DST_DMA_CFG.DST_RAM_TYPE.set(                                dst_ram_type);
    ral.nvdla.NVDLA_CDP.D_DATA_FORMAT.INPUT_DATA_TYPE.set(                             input_data_type);
    ral.nvdla.NVDLA_CDP.D_NAN_FLUSH_TO_ZERO.NAN_TO_ZERO.set(                           nan_to_zero);
    ral.nvdla.NVDLA_CDP.D_LRN_CFG.NORMALZ_LEN.set(                                     normalz_len);
    ral.nvdla.NVDLA_CDP.D_DATIN_OFFSET.DATIN_OFFSET.set(                               datin_offset);
    ral.nvdla.NVDLA_CDP.D_DATIN_SCALE.DATIN_SCALE.set(                                 datin_scale);
    ral.nvdla.NVDLA_CDP.D_DATIN_SHIFTER.DATIN_SHIFTER.set(                             datin_shifter);
    ral.nvdla.NVDLA_CDP.D_DATOUT_OFFSET.DATOUT_OFFSET.set(                             datout_offset);
    ral.nvdla.NVDLA_CDP.D_DATOUT_SCALE.DATOUT_SCALE.set(                               datout_scale);
    ral.nvdla.NVDLA_CDP.D_DATOUT_SHIFTER.DATOUT_SHIFTER.set(                           datout_shifter);
    ral.nvdla.NVDLA_CDP.D_PERF_ENABLE.DMA_EN.set(                                      dma_en);
    ral.nvdla.NVDLA_CDP.D_PERF_ENABLE.LUT_EN.set(                                      lut_en);
    ral.nvdla.NVDLA_CDP.D_CYA.CYA.set(                                                 cya);
    //:) epython: generated_end (DO NOT EDIT ABOVE)
endfunction : set_register

`endif //_NVDLA_CDP_RESOURCE_SV_
