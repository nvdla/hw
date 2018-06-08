`ifndef _NVDLA_SDP_RESOURCE_SV_
`define _NVDLA_SDP_RESOURCE_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_sdp_resource
//
// @description: various hardware resources of sdp sub module
//-------------------------------------------------------------------------------------

class nvdla_sdp_resource extends nvdla_base_resource;
    // singleton handle
    static local nvdla_sdp_resource        inst;
    string sdp_cube_size           = "NORMAL";

    // LUT data pattern settings
    string sdp_lut_lo_data_pattern = "RANDOM";
    string sdp_lut_le_data_pattern = "RANDOM";

    // enum define
    //:| import spec2constrain
    //:| global spec2cons
    //:| spec2cons = spec2constrain.Spec2Cons()
    //:| spec2cons.enum_gen(['NVDLA_SDP'])
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
    typedef enum{ bs_bypass_NO                     = 'h0
                 ,bs_bypass_YES                    = 'h1
                } bs_bypass_t;
    typedef enum{ bs_alu_bypass_NO                 = 'h0
                 ,bs_alu_bypass_YES                = 'h1
                } bs_alu_bypass_t;
    typedef enum{ bs_alu_algo_MAX                  = 'h0
                 ,bs_alu_algo_MIN                  = 'h1
                 ,bs_alu_algo_SUM                  = 'h2
                } bs_alu_algo_t;
    typedef enum{ bs_mul_bypass_NO                 = 'h0
                 ,bs_mul_bypass_YES                = 'h1
                } bs_mul_bypass_t;
    typedef enum{ bs_mul_prelu_NO                  = 'h0
                 ,bs_mul_prelu_YES                 = 'h1
                } bs_mul_prelu_t;
    typedef enum{ bs_relu_bypass_NO                = 'h0
                 ,bs_relu_bypass_YES               = 'h1
                } bs_relu_bypass_t;
    typedef enum{ bs_alu_src_REG                   = 'h0
                 ,bs_alu_src_MEM                   = 'h1
                } bs_alu_src_t;
    typedef enum{ bs_mul_src_REG                   = 'h0
                 ,bs_mul_src_MEM                   = 'h1
                } bs_mul_src_t;
    typedef enum{ bn_bypass_NO                     = 'h0
                 ,bn_bypass_YES                    = 'h1
                } bn_bypass_t;
    typedef enum{ bn_alu_bypass_NO                 = 'h0
                 ,bn_alu_bypass_YES                = 'h1
                } bn_alu_bypass_t;
    typedef enum{ bn_alu_algo_MAX                  = 'h0
                 ,bn_alu_algo_MIN                  = 'h1
                 ,bn_alu_algo_SUM                  = 'h2
                } bn_alu_algo_t;
    typedef enum{ bn_mul_bypass_NO                 = 'h0
                 ,bn_mul_bypass_YES                = 'h1
                } bn_mul_bypass_t;
    typedef enum{ bn_mul_prelu_NO                  = 'h0
                 ,bn_mul_prelu_YES                 = 'h1
                } bn_mul_prelu_t;
    typedef enum{ bn_relu_bypass_NO                = 'h0
                 ,bn_relu_bypass_YES               = 'h1
                } bn_relu_bypass_t;
    typedef enum{ bn_alu_src_REG                   = 'h0
                 ,bn_alu_src_MEM                   = 'h1
                } bn_alu_src_t;
    typedef enum{ bn_mul_src_REG                   = 'h0
                 ,bn_mul_src_MEM                   = 'h1
                } bn_mul_src_t;
    typedef enum{ ew_bypass_NO                     = 'h0
                 ,ew_bypass_YES                    = 'h1
                } ew_bypass_t;
    typedef enum{ ew_alu_bypass_NO                 = 'h0
                 ,ew_alu_bypass_YES                = 'h1
                } ew_alu_bypass_t;
    typedef enum{ ew_alu_algo_MAX                  = 'h0
                 ,ew_alu_algo_MIN                  = 'h1
                 ,ew_alu_algo_SUM                  = 'h2
                 ,ew_alu_algo_EQL                  = 'h3
                } ew_alu_algo_t;
    typedef enum{ ew_mul_bypass_NO                 = 'h0
                 ,ew_mul_bypass_YES                = 'h1
                } ew_mul_bypass_t;
    typedef enum{ ew_mul_prelu_NO                  = 'h0
                 ,ew_mul_prelu_YES                 = 'h1
                } ew_mul_prelu_t;
    typedef enum{ ew_lut_bypass_NO                 = 'h0
                 ,ew_lut_bypass_YES                = 'h1
                } ew_lut_bypass_t;
    typedef enum{ ew_alu_src_REG                   = 'h0
                 ,ew_alu_src_MEM                   = 'h1
                } ew_alu_src_t;
    typedef enum{ ew_alu_cvt_bypass_NO             = 'h0
                 ,ew_alu_cvt_bypass_YES            = 'h1
                } ew_alu_cvt_bypass_t;
    typedef enum{ ew_mul_src_REG                   = 'h0
                 ,ew_mul_src_MEM                   = 'h1
                } ew_mul_src_t;
    typedef enum{ ew_mul_cvt_bypass_NO             = 'h0
                 ,ew_mul_cvt_bypass_YES            = 'h1
                } ew_mul_cvt_bypass_t;
    typedef enum{ flying_mode_OFF                  = 'h0
                 ,flying_mode_ON                   = 'h1
                } flying_mode_t;
    typedef enum{ output_dst_MEM                   = 'h0
                 ,output_dst_PDP                   = 'h1
                } output_dst_t;
    typedef enum{ winograd_OFF                     = 'h0
                 ,winograd_ON                      = 'h1
                } winograd_t;
    typedef enum{ nan_to_zero_DISABLE              = 'h0
                 ,nan_to_zero_ENABLE               = 'h1
                } nan_to_zero_t;
    typedef enum{ dst_ram_type_CV                  = 'h0
                 ,dst_ram_type_MC                  = 'h1
                } dst_ram_type_t;
    typedef enum{ proc_precision_INT8              = 'h0
                 ,proc_precision_INT16             = 'h1
                 ,proc_precision_FP16              = 'h2
                } proc_precision_t;
    typedef enum{ out_precision_INT8               = 'h0
                 ,out_precision_INT16              = 'h1
                 ,out_precision_FP16               = 'h2
                } out_precision_t;
    typedef enum{ perf_dma_en_NO                   = 'h0
                 ,perf_dma_en_YES                  = 'h1
                } perf_dma_en_t;
    typedef enum{ perf_lut_en_NO                   = 'h0
                 ,perf_lut_en_YES                  = 'h1
                } perf_lut_en_t;
    typedef enum{ perf_sat_en_NO                   = 'h0
                 ,perf_sat_en_YES                  = 'h1
                } perf_sat_en_t;
    typedef enum{ perf_nan_inf_count_en_NO         = 'h0
                 ,perf_nan_inf_count_en_YES        = 'h1
                } perf_nan_inf_count_en_t;
    //:) epython: generated_end (DO NOT EDIT ABOVE)
    
    /*
        LUT_REUSE config: IF working in lut_reuse mode, input data type must be the same with pre layer, 
        set pre_input_data_type(default) to -1
    */
    rand bit          sdp_lut_reuse        = 0;
    int               pre_proc_precision   = -1;

    // field variables
    //:| spec2cons.state_gen(['NVDLA_SDP'])
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
    rand bit [31:0]                 lut_le_start;
    rand bit [31:0]                 lut_le_end;
    rand bit [31:0]                 lut_lo_start;
    rand bit [31:0]                 lut_lo_end;
    rand bit [15:0]                 lut_le_slope_uflow_scale;
    rand bit [15:0]                 lut_le_slope_oflow_scale;
    rand bit [4:0]                  lut_le_slope_uflow_shift;
    rand bit [4:0]                  lut_le_slope_oflow_shift;
    rand bit [15:0]                 lut_lo_slope_uflow_scale;
    rand bit [15:0]                 lut_lo_slope_oflow_scale;
    rand bit [4:0]                  lut_lo_slope_uflow_shift;
    rand bit [4:0]                  lut_lo_slope_oflow_shift;
    rand bit [12:0]                 width;
    rand bit [12:0]                 height;
    rand bit [12:0]                 channel;
    rand bit [31:0]                 dst_base_addr_low;
    rand bit [31:0]                 dst_base_addr_high;
    rand bit [31:0]                 dst_line_stride;
    rand bit [31:0]                 dst_surface_stride;
    rand bs_bypass_t                bs_bypass;
    rand bs_alu_bypass_t            bs_alu_bypass;
    rand bs_alu_algo_t              bs_alu_algo;
    rand bs_mul_bypass_t            bs_mul_bypass;
    rand bs_mul_prelu_t             bs_mul_prelu;
    rand bs_relu_bypass_t           bs_relu_bypass;
    rand bs_alu_src_t               bs_alu_src;
    rand bit [5:0]                  bs_alu_shift_value;
    rand bit [15:0]                 bs_alu_operand;
    rand bs_mul_src_t               bs_mul_src;
    rand bit [7:0]                  bs_mul_shift_value;
    rand bit [15:0]                 bs_mul_operand;
    rand bn_bypass_t                bn_bypass;
    rand bn_alu_bypass_t            bn_alu_bypass;
    rand bn_alu_algo_t              bn_alu_algo;
    rand bn_mul_bypass_t            bn_mul_bypass;
    rand bn_mul_prelu_t             bn_mul_prelu;
    rand bn_relu_bypass_t           bn_relu_bypass;
    rand bn_alu_src_t               bn_alu_src;
    rand bit [5:0]                  bn_alu_shift_value;
    rand bit [15:0]                 bn_alu_operand;
    rand bn_mul_src_t               bn_mul_src;
    rand bit [7:0]                  bn_mul_shift_value;
    rand bit [15:0]                 bn_mul_operand;
    rand ew_bypass_t                ew_bypass;
    rand ew_alu_bypass_t            ew_alu_bypass;
    rand ew_alu_algo_t              ew_alu_algo;
    rand ew_mul_bypass_t            ew_mul_bypass;
    rand ew_mul_prelu_t             ew_mul_prelu;
    rand ew_lut_bypass_t            ew_lut_bypass;
    rand ew_alu_src_t               ew_alu_src;
    rand ew_alu_cvt_bypass_t        ew_alu_cvt_bypass;
    rand bit [31:0]                 ew_alu_operand;
    rand bit [31:0]                 ew_alu_cvt_offset;
    rand bit [15:0]                 ew_alu_cvt_scale;
    rand bit [5:0]                  ew_alu_cvt_truncate;
    rand ew_mul_src_t               ew_mul_src;
    rand ew_mul_cvt_bypass_t        ew_mul_cvt_bypass;
    rand bit [31:0]                 ew_mul_operand;
    rand bit [31:0]                 ew_mul_cvt_offset;
    rand bit [15:0]                 ew_mul_cvt_scale;
    rand bit [5:0]                  ew_mul_cvt_truncate;
    rand bit [9:0]                  ew_truncate;
    rand flying_mode_t              flying_mode;
    rand output_dst_t               output_dst;
    rand winograd_t                 winograd;
    rand nan_to_zero_t              nan_to_zero;
    rand bit [4:0]                  batch_number;
    rand dst_ram_type_t             dst_ram_type;
    rand bit [31:0]                 dst_batch_stride;
    rand proc_precision_t           proc_precision;
    rand out_precision_t            out_precision;
    rand bit [31:0]                 cvt_offset;
    rand bit [15:0]                 cvt_scale;
    rand bit [5:0]                  cvt_shift;
    rand perf_dma_en_t              perf_dma_en;
    rand perf_lut_en_t              perf_lut_en;
    rand perf_sat_en_t              perf_sat_en;
    rand perf_nan_inf_count_en_t    perf_nan_inf_count_en;
    //:) epython: generated_end (DO NOT EDIT ABOVE)

    `uvm_component_utils_begin(nvdla_sdp_resource)
        `uvm_field_string(sdp_cube_size,                               UVM_ALL_ON)
        `uvm_field_string(sdp_lut_lo_data_pattern,                     UVM_ALL_ON)
        `uvm_field_string(sdp_lut_le_data_pattern,                     UVM_ALL_ON)
        `uvm_field_int   (sdp_lut_reuse,                               UVM_ALL_ON)
        //:| spec2cons.macro_gen(['NVDLA_SDP'])
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
        `uvm_field_int(lut_le_start,                                   UVM_ALL_ON)
        `uvm_field_int(lut_le_end,                                     UVM_ALL_ON)
        `uvm_field_int(lut_lo_start,                                   UVM_ALL_ON)
        `uvm_field_int(lut_lo_end,                                     UVM_ALL_ON)
        `uvm_field_int(lut_le_slope_uflow_scale,                       UVM_ALL_ON)
        `uvm_field_int(lut_le_slope_oflow_scale,                       UVM_ALL_ON)
        `uvm_field_int(lut_le_slope_uflow_shift,                       UVM_ALL_ON)
        `uvm_field_int(lut_le_slope_oflow_shift,                       UVM_ALL_ON)
        `uvm_field_int(lut_lo_slope_uflow_scale,                       UVM_ALL_ON)
        `uvm_field_int(lut_lo_slope_oflow_scale,                       UVM_ALL_ON)
        `uvm_field_int(lut_lo_slope_uflow_shift,                       UVM_ALL_ON)
        `uvm_field_int(lut_lo_slope_oflow_shift,                       UVM_ALL_ON)
        `uvm_field_int(width,                                          UVM_ALL_ON)
        `uvm_field_int(height,                                         UVM_ALL_ON)
        `uvm_field_int(channel,                                        UVM_ALL_ON)
        `uvm_field_int(dst_base_addr_low,                              UVM_ALL_ON)
        `uvm_field_int(dst_base_addr_high,                             UVM_ALL_ON)
        `uvm_field_int(dst_line_stride,                                UVM_ALL_ON)
        `uvm_field_int(dst_surface_stride,                             UVM_ALL_ON)
        `uvm_field_enum(bs_bypass_t,              bs_bypass,           UVM_ALL_ON)
        `uvm_field_enum(bs_alu_bypass_t,          bs_alu_bypass,       UVM_ALL_ON)
        `uvm_field_enum(bs_alu_algo_t,            bs_alu_algo,         UVM_ALL_ON)
        `uvm_field_enum(bs_mul_bypass_t,          bs_mul_bypass,       UVM_ALL_ON)
        `uvm_field_enum(bs_mul_prelu_t,           bs_mul_prelu,        UVM_ALL_ON)
        `uvm_field_enum(bs_relu_bypass_t,         bs_relu_bypass,      UVM_ALL_ON)
        `uvm_field_enum(bs_alu_src_t,             bs_alu_src,          UVM_ALL_ON)
        `uvm_field_int(bs_alu_shift_value,                             UVM_ALL_ON)
        `uvm_field_int(bs_alu_operand,                                 UVM_ALL_ON)
        `uvm_field_enum(bs_mul_src_t,             bs_mul_src,          UVM_ALL_ON)
        `uvm_field_int(bs_mul_shift_value,                             UVM_ALL_ON)
        `uvm_field_int(bs_mul_operand,                                 UVM_ALL_ON)
        `uvm_field_enum(bn_bypass_t,              bn_bypass,           UVM_ALL_ON)
        `uvm_field_enum(bn_alu_bypass_t,          bn_alu_bypass,       UVM_ALL_ON)
        `uvm_field_enum(bn_alu_algo_t,            bn_alu_algo,         UVM_ALL_ON)
        `uvm_field_enum(bn_mul_bypass_t,          bn_mul_bypass,       UVM_ALL_ON)
        `uvm_field_enum(bn_mul_prelu_t,           bn_mul_prelu,        UVM_ALL_ON)
        `uvm_field_enum(bn_relu_bypass_t,         bn_relu_bypass,      UVM_ALL_ON)
        `uvm_field_enum(bn_alu_src_t,             bn_alu_src,          UVM_ALL_ON)
        `uvm_field_int(bn_alu_shift_value,                             UVM_ALL_ON)
        `uvm_field_int(bn_alu_operand,                                 UVM_ALL_ON)
        `uvm_field_enum(bn_mul_src_t,             bn_mul_src,          UVM_ALL_ON)
        `uvm_field_int(bn_mul_shift_value,                             UVM_ALL_ON)
        `uvm_field_int(bn_mul_operand,                                 UVM_ALL_ON)
        `uvm_field_enum(ew_bypass_t,              ew_bypass,           UVM_ALL_ON)
        `uvm_field_enum(ew_alu_bypass_t,          ew_alu_bypass,       UVM_ALL_ON)
        `uvm_field_enum(ew_alu_algo_t,            ew_alu_algo,         UVM_ALL_ON)
        `uvm_field_enum(ew_mul_bypass_t,          ew_mul_bypass,       UVM_ALL_ON)
        `uvm_field_enum(ew_mul_prelu_t,           ew_mul_prelu,        UVM_ALL_ON)
        `uvm_field_enum(ew_lut_bypass_t,          ew_lut_bypass,       UVM_ALL_ON)
        `uvm_field_enum(ew_alu_src_t,             ew_alu_src,          UVM_ALL_ON)
        `uvm_field_enum(ew_alu_cvt_bypass_t,      ew_alu_cvt_bypass,   UVM_ALL_ON)
        `uvm_field_int(ew_alu_operand,                                 UVM_ALL_ON)
        `uvm_field_int(ew_alu_cvt_offset,                              UVM_ALL_ON)
        `uvm_field_int(ew_alu_cvt_scale,                               UVM_ALL_ON)
        `uvm_field_int(ew_alu_cvt_truncate,                            UVM_ALL_ON)
        `uvm_field_enum(ew_mul_src_t,             ew_mul_src,          UVM_ALL_ON)
        `uvm_field_enum(ew_mul_cvt_bypass_t,      ew_mul_cvt_bypass,   UVM_ALL_ON)
        `uvm_field_int(ew_mul_operand,                                 UVM_ALL_ON)
        `uvm_field_int(ew_mul_cvt_offset,                              UVM_ALL_ON)
        `uvm_field_int(ew_mul_cvt_scale,                               UVM_ALL_ON)
        `uvm_field_int(ew_mul_cvt_truncate,                            UVM_ALL_ON)
        `uvm_field_int(ew_truncate,                                    UVM_ALL_ON)
        `uvm_field_enum(flying_mode_t,            flying_mode,         UVM_ALL_ON)
        `uvm_field_enum(output_dst_t,             output_dst,          UVM_ALL_ON)
        `uvm_field_enum(winograd_t,               winograd,            UVM_ALL_ON)
        `uvm_field_enum(nan_to_zero_t,            nan_to_zero,         UVM_ALL_ON)
        `uvm_field_int(batch_number,                                   UVM_ALL_ON)
        `uvm_field_enum(dst_ram_type_t,           dst_ram_type,        UVM_ALL_ON)
        `uvm_field_int(dst_batch_stride,                               UVM_ALL_ON)
        `uvm_field_enum(proc_precision_t,         proc_precision,      UVM_ALL_ON)
        `uvm_field_enum(out_precision_t,          out_precision,       UVM_ALL_ON)
        `uvm_field_int(cvt_offset,                                     UVM_ALL_ON)
        `uvm_field_int(cvt_scale,                                      UVM_ALL_ON)
        `uvm_field_int(cvt_shift,                                      UVM_ALL_ON)
        `uvm_field_enum(perf_dma_en_t,            perf_dma_en,         UVM_ALL_ON)
        `uvm_field_enum(perf_lut_en_t,            perf_lut_en,         UVM_ALL_ON)
        `uvm_field_enum(perf_sat_en_t,            perf_sat_en,         UVM_ALL_ON)
        `uvm_field_enum(perf_nan_inf_count_en_t,  perf_nan_inf_count_en, UVM_ALL_ON)
        //:) epython: generated_end (DO NOT EDIT ABOVE)
    `uvm_component_utils_end

    /*
        Methods
    */
    extern function         new(string name="nvdla_sdp_resource", uvm_component parent);
    extern static function  nvdla_sdp_resource get_sdp(uvm_component parent);
    extern function void    trace_dump(int fh);
    extern function void    set_lut();
    extern function void    set_mem_addr();
    extern function void    set_register();
    extern function void    lut_config_dump(int fh);
    extern function void    pre_randomize();
    extern function void    post_randomize();
    extern function void    set_sim_constraint();

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
    extern constraint c_ias_winograd;
    extern constraint c_ias_dst_mem;
    extern constraint c_ias_multi_batch;
    extern constraint c_ias_bs;
    extern constraint c_ias_bn;
    extern constraint c_ias_ew;
    extern constraint c_ias_feature;
    extern constraint c_ias_dut_por_requirement;
    // sim constraint
    extern constraint c_sim_dst_mem_weight_dist;
    extern constraint c_sim_bs_weight_dist;
    extern constraint c_sim_bn_weight_dist;
    extern constraint c_sim_ew_weight_dist;
    extern constraint c_sim_cvt_weight_dist;
    extern constraint c_sim_batch_num_dist;
    extern constraint c_sim_cube_size_small;
    extern constraint c_sim_cube_size_medium;
    extern constraint c_sim_cube_size_large;
    extern constraint c_sim_cube_size_normal;

endclass : nvdla_sdp_resource

function nvdla_sdp_resource::new(string name="nvdla_sdp_resource", uvm_component parent);
    super.new(name, parent);
    `uvm_info(inst_name, $sformatf("Initialize resource %s ... \n",inst_name),UVM_LOW);
endfunction: new

function void nvdla_sdp_resource::build_phase(uvm_phase phase);
    super.build_phase(phase);

endfunction: build_phase

function void nvdla_sdp_resource::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if(!uvm_config_db#(string)::get(this, "", "sdp_lut_lo_data_pattern", sdp_lut_lo_data_pattern)) begin
        `uvm_info(inst_name, "NO sdp_lut_lo_data_pattern config, using default value: RANDOM", UVM_NONE)
    end
    if(!uvm_config_db#(string)::get(this, "", "sdp_lut_le_data_pattern", sdp_lut_le_data_pattern)) begin
        `uvm_info(inst_name, "NO sdp_lut_le_data_pattern config, using default value: RANDOM", UVM_NONE)
    end
    if(!uvm_config_db#(int)::get(this, "", "sdp_lut_reuse", sdp_lut_reuse)) begin
        `uvm_info(inst_name, $sformatf("NO sdp_lut_reuse config, using random value"), UVM_NONE)
    end
endfunction: connect_phase

function void nvdla_sdp_resource::lut_config_dump(int fh);
    uvm_reg_data_t reg_val;

    if(sdp_lut_reuse == 0 || pre_proc_precision == -1) begin  // NO LUT reuse
        // LUT is only configurable when there's no active layer running, in other case
        // just (skip) waiting  (if not forced LUT_REUSE)
        if (get_active_cnt() > 0) begin
            sync_wait(fh,inst_name,sync_evt_queue[-1]);
        end
        if (get_active_cnt() > 1) begin
            sync_wait(fh,inst_name,sync_evt_queue[-2]);
        end

        // Configure LUT table
        ral.nvdla.NVDLA_SDP.S_LUT_ACCESS_CFG.LUT_ADDR.set(0);
        ral.nvdla.NVDLA_SDP.S_LUT_ACCESS_CFG.LUT_TABLE_ID.set(0);    // LE
        ral.nvdla.NVDLA_SDP.S_LUT_ACCESS_CFG.LUT_ACCESS_TYPE.set(1); // WRITE
        reg_val = ral.nvdla.NVDLA_SDP.S_LUT_ACCESS_CFG.get();
        reg_write(fh,{inst_name.toupper(),".S_LUT_ACCESS_CFG"}, reg_val);

        if ("LOAD_EXTERNAL_" == sdp_lut_le_data_pattern.toupper().substr(0,13)) begin
            string file_name = sdp_lut_le_data_pattern.substr(14,sdp_lut_le_data_pattern.len()-1);
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
                if ("INDEX" == sdp_lut_le_data_pattern) begin
                    reg_write(fh,{inst_name.toupper(),".S_LUT_ACCESS_DATA"}, i);
                end else if ("CONSTANT_0X" == sdp_lut_le_data_pattern.toupper().substr(0,10)) begin
                    bit[15:0] lut_val = sdp_lut_le_data_pattern.substr(9,sdp_lut_le_data_pattern.len()-1).atohex();
                    reg_write(fh,{inst_name.toupper(),".S_LUT_ACCESS_DATA"}, lut_val);
                end else begin
                    bit[15:0] lut_val = $urandom_range(0,16'hFFFF);
                    reg_write(fh,{inst_name.toupper(),".S_LUT_ACCESS_DATA"}, lut_val);
                end
            end
        end
        ral.nvdla.NVDLA_SDP.S_LUT_ACCESS_CFG.LUT_ADDR.set(0);
        ral.nvdla.NVDLA_SDP.S_LUT_ACCESS_CFG.LUT_TABLE_ID.set(1);    // LO
        ral.nvdla.NVDLA_SDP.S_LUT_ACCESS_CFG.LUT_ACCESS_TYPE.set(1); // WRITE
        reg_val = ral.nvdla.NVDLA_SDP.S_LUT_ACCESS_CFG.get();
        reg_write(fh,{inst_name.toupper(),".S_LUT_ACCESS_CFG"}, reg_val);

        if ("LOAD_EXTERNAL_" == sdp_lut_lo_data_pattern.toupper().substr(0,13)) begin
            string file_name = sdp_lut_lo_data_pattern.substr(14,sdp_lut_lo_data_pattern.len()-1);
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
                if ("INDEX" == sdp_lut_lo_data_pattern) begin
                    reg_write(fh,{inst_name.toupper(),".S_LUT_ACCESS_DATA"}, i);
                end else if ("CONSTANT_0X" == sdp_lut_lo_data_pattern.toupper().substr(0,10)) begin
                    bit[15:0] lut_val = sdp_lut_lo_data_pattern.substr(9,sdp_lut_lo_data_pattern.len()-1).atohex();
                    reg_write(fh,{inst_name.toupper(),".S_LUT_ACCESS_DATA"}, lut_val);
                end else begin
                    bit[15:0] lut_val = $urandom_range(0,16'hFFFF);
                    reg_write(fh,{inst_name.toupper(),".S_LUT_ACCESS_DATA"}, lut_val);
                end
            end
        end
        begin
            reg_val = ral.nvdla.NVDLA_SDP.S_LUT_CFG.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_CFG"}, reg_val);

            reg_val = ral.nvdla.NVDLA_SDP.S_LUT_INFO.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_INFO"}, reg_val);

            reg_val = ral.nvdla.NVDLA_SDP.S_LUT_LE_START.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_LE_START"}, reg_val);

            reg_val = ral.nvdla.NVDLA_SDP.S_LUT_LE_END.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_LE_END"}, reg_val);

            reg_val = ral.nvdla.NVDLA_SDP.S_LUT_LO_START.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_LO_START"}, reg_val);

            reg_val = ral.nvdla.NVDLA_SDP.S_LUT_LO_END.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_LO_END"}, reg_val);

            reg_val = ral.nvdla.NVDLA_SDP.S_LUT_LE_SLOPE_SCALE.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_LE_SLOPE_SCALE"}, reg_val);

            reg_val = ral.nvdla.NVDLA_SDP.S_LUT_LE_SLOPE_SHIFT.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_LE_SLOPE_SHIFT"}, reg_val);

            reg_val = ral.nvdla.NVDLA_SDP.S_LUT_LO_SLOPE_SCALE.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_LO_SLOPE_SCALE"}, reg_val);

            reg_val = ral.nvdla.NVDLA_SDP.S_LUT_LO_SLOPE_SHIFT.get();
            reg_write(fh,{inst_name.toupper(),".S_LUT_LO_SLOPE_SHIFT"}, reg_val);
        end
    end
endfunction : lut_config_dump

static function  nvdla_sdp_resource nvdla_sdp_resource::get_sdp(uvm_component parent);
    if (null == inst) begin
        inst = nvdla_sdp_resource::type_id::create("NVDLA_SDP", parent);
    end
    return inst;
endfunction: get_sdp

function void nvdla_sdp_resource::trace_dump(int fh);
    // FIXME need to handle lut config dump
    if(fh==null) begin
        `uvm_fatal(inst_name, "Null handle of trace file ...")
    end
    `uvm_info(inst_name, "Start trace dumping ...", UVM_HIGH)
    // if both groups have been used, resource must wait for the group released
    if (get_active_cnt() > 1) begin
        sync_wait(fh,inst_name,sync_evt_queue[-2]);
    end

    reg_write(fh,"NVDLA_SDP.S_POINTER",group_to_use);

    begin
        uvm_reg        reg_q[$];
        uvm_reg_data_t val;
        uvm_status_e   status;

        ral.nvdla.NVDLA_SDP.get_registers(reg_q);
        reg_q.shuffle();
        foreach(reg_q[i]) begin
            if(reg_q[i].get_rights() != "RW") begin
                continue;
            end
`ifndef NVDLA_SDP_BS_ENABLE
            else if(reg_q[i].get_name().substr(0,7) == "D_DP_BS_") begin
                continue;
            end
`endif
`ifndef NVDLA_SDP_BN_ENABLE
            else if(reg_q[i].get_name().substr(0,7) == "D_DP_BN_") begin
                continue;
            end
`endif
`ifndef NVDLA_SDP_EW_ENABLE
            else if(reg_q[i].get_name().substr(0,7) == "D_DP_EW_") begin
                continue;
            end
`endif
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
    // Skip if LUT_REUSE is set or EW(LUT) is disabled
`ifdef NVDLA_SDP_LUT_ENABLE 
    if(ral.nvdla.NVDLA_SDP.D_DP_EW_CFG.EW_BYPASS.get()==0 && ral.nvdla.NVDLA_SDP.D_DP_EW_CFG.EW_LUT_BYPASS.get()==0) begin
        lut_config_dump(fh);
    end
`endif

    ral.nvdla.NVDLA_SDP.D_OP_ENABLE.set(1);
    reg_write(fh,{inst_name.toupper(),".D_OP_ENABLE"},1);
    intr_notify(fh,{"SDP_",$sformatf("%0d",group_to_use)}, sync_evt_queue[0]);
    if (output_dst == output_dst_MEM)  begin
        // Reserve mem region to write into
        longint unsigned mem_size;
        string           mem_domain_output;
        mem_domain_output = (dst_ram_type_MC == dst_ram_type) ? "pri_mem":"sec_mem";
        mem_size          = calc_mem_size(batch_number+1, dst_batch_stride, channel+1, 
                                          `NVDLA_MEMORY_ATOMIC_SIZE, dst_surface_stride);
        mem_reserve(fh, mem_domain_output, {dst_base_addr_high,dst_base_addr_low}, mem_size, sync_evt_queue[-2]);
        // Release mem region when write done
        mem_release(fh, mem_domain_output, {dst_base_addr_high,dst_base_addr_low}, sync_evt_queue[0]);
    end
    `uvm_info(inst_name, "Finish trace dumping ...", UVM_HIGH)
endfunction : trace_dump

constraint nvdla_sdp_resource::c_ias_stride_alignment {
    // alignment according to atomic size
    dst_line_stride    % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    dst_surface_stride % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    dst_batch_stride   % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
}

// NONE NAN value in FP format
constraint nvdla_sdp_resource::c_ias_fp_no_nan_value {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    if(proc_precision == proc_precision_FP16) {
        if(ew_bypass == ew_bypass_NO && ew_lut_bypass == ew_lut_bypass_NO) {
            !((lut_data[9:0]                 != 0) && (lut_data[14:10]                 == 5'h1F));
            !((lut_le_start[22:0]            != 0) && (lut_le_start[30:23]             == 8'hFF));
            !((lut_le_end[22:0]              != 0) && (lut_le_end[30:23]               == 8'hFF));
            !((lut_lo_start[22:0]            != 0) && (lut_lo_start[30:23]             == 8'hFF));
            !((lut_lo_end[22:0]              != 0) && (lut_lo_end[30:23]               == 8'hFF));
            !((lut_le_slope_uflow_scale[9:0] != 0) && (lut_le_slope_uflow_scale[14:10] == 5'h1F));
            !((lut_le_slope_oflow_scale[9:0] != 0) && (lut_le_slope_oflow_scale[14:10] == 5'h1F));
            !((lut_lo_slope_uflow_scale[9:0] != 0) && (lut_lo_slope_uflow_scale[14:10] == 5'h1F));
            !((lut_lo_slope_oflow_scale[9:0] != 0) && (lut_lo_slope_oflow_scale[14:10] == 5'h1F));
        }
        !((bs_alu_operand[9:0]  != 0) && (bs_alu_operand[14:10] == 5'h1F));
        !((bs_mul_operand[9:0]  != 0) && (bs_mul_operand[14:10] == 5'h1F));
        !((bn_alu_operand[9:0]  != 0) && (bn_alu_operand[14:10] == 5'h1F));
        !((bn_mul_operand[9:0]  != 0) && (bn_mul_operand[14:10] == 5'h1F));
        !((ew_alu_operand[22:0] != 0) && (ew_alu_operand[30:23] == 8'hFF));
        !((ew_mul_operand[22:0] != 0) && (ew_mul_operand[30:23] == 8'hFF));
    }
`endif
}

// NONE INF value in FP format
constraint nvdla_sdp_resource::c_ias_fp_no_inf_value {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    if(proc_precision == proc_precision_FP16) {
        if(ew_bypass == ew_bypass_NO && ew_lut_bypass == ew_lut_bypass_NO) {
            !((lut_data[9:0]                 == 0) && (lut_data[14:10]                 == 5'h1F));
            !((lut_le_start[22:0]            == 0) && (lut_le_start[30:23]             == 8'hFF));
            !((lut_le_end[22:0]              == 0) && (lut_le_end[30:23]               == 8'hFF));
            !((lut_lo_start[22:0]            == 0) && (lut_lo_start[30:23]             == 8'hFF));
            !((lut_lo_end[22:0]              == 0) && (lut_lo_end[30:23]               == 8'hFF));
            !((lut_le_slope_uflow_scale[9:0] == 0) && (lut_le_slope_uflow_scale[14:10] == 5'h1F));
            !((lut_le_slope_oflow_scale[9:0] == 0) && (lut_le_slope_oflow_scale[14:10] == 5'h1F));
            !((lut_lo_slope_uflow_scale[9:0] == 0) && (lut_lo_slope_uflow_scale[14:10] == 5'h1F));
            !((lut_lo_slope_oflow_scale[9:0] == 0) && (lut_lo_slope_oflow_scale[14:10] == 5'h1F));
        }
        !((bs_alu_operand[9:0]  == 0) && (bs_alu_operand[14:10] == 5'h1F));
        !((bs_mul_operand[9:0]  == 0) && (bs_mul_operand[14:10] == 5'h1F));
        !((bn_alu_operand[9:0]  == 0) && (bn_alu_operand[14:10] == 5'h1F));
        !((bn_mul_operand[9:0]  == 0) && (bn_mul_operand[14:10] == 5'h1F));
        !((ew_alu_operand[22:0] == 0) && (ew_alu_operand[30:23] == 8'hFF));
        !((ew_mul_operand[22:0] == 0) && (ew_mul_operand[30:23] == 8'hFF));
    }
`endif
}

// NONE DENORM value in FP format
constraint nvdla_sdp_resource::c_ias_fp_no_denorm_value {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    if(proc_precision == proc_precision_FP16) {
        if(ew_bypass == ew_bypass_NO && ew_lut_bypass == ew_lut_bypass_NO) {
            !((lut_le_start[22:0] != 0) && (lut_le_start[30:23] == 0));
            !((lut_le_end[22:0]   != 0) && (lut_le_end[30:23]   == 0));
            !((lut_lo_start[22:0] != 0) && (lut_lo_start[30:23] == 0));
            !((lut_lo_end[22:0]   != 0) && (lut_lo_end[30:23]   == 0));
        }
        !((ew_alu_operand[22:0] != 0) && (ew_alu_operand[30:23] == 0));
        !((ew_mul_operand[22:0] != 0) && (ew_mul_operand[30:23] == 0));
    }
`endif
}

// --------------------------------------------------
// lUT Constraint Setup
// --------------------------------------------------
constraint nvdla_sdp_resource::c_ias_lut {
    if(proc_precision != proc_precision_FP16) {
        signed'(lut_le_end) > signed'(lut_le_start);
        if(lut_le_function == lut_le_function_LINEAR) {
            (signed'(lut_le_end) - signed'(lut_le_start)) == (1 << (signed'(lut_le_index_select)+6));
            signed'(lut_le_index_select) inside {[-6:25]};
        }
        else {
            signed'(lut_le_index_offset) dist { [-64:-33]:=80, [-34:31]:=20} ;
            if(signed'(lut_le_index_offset) <= -33) {
                (signed'(lut_le_end) - signed'(lut_le_start)) == (1 << (signed'(lut_le_index_offset)+64));
            }
            else {
                lut_le_end == 32'h7FFF_FFFF;
            }
        }

        signed'(lut_lo_end) > signed'(lut_lo_start);
        (signed'(lut_lo_end) - signed'(lut_lo_start)) == (1 << (signed'(lut_lo_index_select)+8));
        signed'(lut_lo_index_select) inside {[-8:23]};
    }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    else { // FP16
        if(lut_le_function == lut_le_function_LINEAR) {
            signed'({1'b0,lut_le_start[30:23]}) <= (signed'(lut_le_index_select)+6) + 127 + 23;
            signed'(lut_le_index_select) <= 121;
        }
        else {
            signed'({1'b0,lut_le_start[30:23]}) <= (signed'(lut_le_index_offset)+64) + 127 + 23;
            signed'(lut_le_index_offset) <= 127;
            signed'(lut_le_index_offset) >= -126;
        }
        signed'({1'b0,lut_lo_start[30:23]}) <= (signed'(lut_lo_index_select)+8) + 127 + 21;
        signed'(lut_lo_index_select) <= 119;
    }
`endif
}

constraint nvdla_sdp_resource::c_ias_winograd {
`ifdef NVDLA_WINOGRAD_ENABLE
    if (winograd == winograd_ON) {
        (width+1)  % 4 == 0;
        (height+1) % 4 == 0;
        proc_precision == proc_precision_t'(out_precision);  // bug 1921999
        ew_alu_algo    != ew_alu_algo_EQL;
    }
`endif
}

constraint nvdla_sdp_resource::c_ias_dst_mem {
    if(output_dst == output_dst_MEM) {
        if((width == 0) && (height == 0)) { // 1x1 only support pack mode
            dst_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE == (width+1); // `NVDLA_MEMORY_ATOMIC_SIZE byte per unit
            64'(dst_surface_stride) == 64'(dst_line_stride*(height+64'h1));
        }
        else {
            (dst_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE) >= (width+1);
            (dst_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE - (width+1)) dist { [0:4]:=10, [5:8]:=50, [9:12]:=30, [13:16]:=10};
            64'(dst_surface_stride) >= 64'(dst_line_stride*(height+64'h1));
            (dst_surface_stride - dst_line_stride*(height+64'h1)) / `NVDLA_MEMORY_ATOMIC_SIZE dist { [0:4]:=10, [5:8]:=50, [9:12]:=30, [13:16]:=10};
        }
        if(out_precision == out_precision_INT8) {
            (dst_surface_stride*((channel+`NVDLA_MEMORY_ATOMIC_SIZE)/`NVDLA_MEMORY_ATOMIC_SIZE)) <= 64'h400_0000;
        }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
        else {
            (dst_surface_stride*((channel+`NVDLA_MEMORY_ATOMIC_SIZE/2)/(`NVDLA_MEMORY_ATOMIC_SIZE/2))) <= 64'h400_0000;
        }
`endif
    }
}

constraint nvdla_sdp_resource::c_ias_multi_batch {
    if(output_dst == output_dst_MEM) {
`ifdef NVDLA_BATCH_ENABLE
        if((batch_number > 0)) {
            if(!((width==0) && (height==0))) {
                (dst_line_stride / `NVDLA_MEMORY_ATOMIC_SIZE) % 2 == 0;
                (dst_surface_stride / `NVDLA_MEMORY_ATOMIC_SIZE) % 2 == 0;
            }
            if(out_precision == out_precision_INT8) {
                dst_batch_stride >= dst_surface_stride*((channel+64'h1+`NVDLA_MEMORY_ATOMIC_SIZE-1)/`NVDLA_MEMORY_ATOMIC_SIZE);
                (dst_batch_stride - dst_surface_stride*((channel+64'h1+`NVDLA_MEMORY_ATOMIC_SIZE-1)/`NVDLA_MEMORY_ATOMIC_SIZE)) / `NVDLA_MEMORY_ATOMIC_SIZE dist { [0:4]:=10, [5:8]:=50, [9:12]:=30, [13:16]:=10}; // 0~256byte
            }
            else {
                dst_batch_stride >= dst_surface_stride*((channel+64'h1+`NVDLA_MEMORY_ATOMIC_SIZE/2-1)/(`NVDLA_MEMORY_ATOMIC_SIZE/2));
                (dst_batch_stride - dst_surface_stride*((channel+64'h1+`NVDLA_MEMORY_ATOMIC_SIZE/2-1)/(`NVDLA_MEMORY_ATOMIC_SIZE/2))) / `NVDLA_MEMORY_ATOMIC_SIZE dist { [0:4]:=10, [5:8]:=50, [9:12]:=30, [13:16]:=10}; // 0~256byte
            }
            (dst_batch_stride*(batch_number+1)) / `NVDLA_MEMORY_ATOMIC_SIZE <= 64'h400_0000;
            proc_precision == proc_precision_t'(out_precision); // bug 200314538
            ew_alu_algo != ew_alu_algo_EQL;
        }
`endif
    }
}

constraint nvdla_sdp_resource::c_ias_bs {
    !((bs_alu_bypass == bs_alu_bypass_NO) && (bs_mul_prelu == bs_mul_prelu_YES));
    (bs_alu_src == bs_alu_src_REG) -> {
        bs_alu_operand      dist { [16'h0:16'hFFFF]:=100};
    }
    // Bug 200284824
    if(proc_precision == proc_precision_FP16) {
        bs_alu_shift_value inside {[0:63]};
    }
    else {
        bs_alu_shift_value inside {[0:30]};
    }
    (bs_mul_src == bs_mul_src_REG) -> {
        bs_mul_operand dist { [16'h0:16'hFFFF]:=100};
    }
    if(proc_precision != proc_precision_FP16) {
        bs_mul_shift_value inside {[0:63]};
    }
    else {
    }
    (bs_alu_bypass == bs_alu_bypass_NO && bs_mul_bypass == bs_mul_bypass_NO && bs_bypass == bs_bypass_NO) -> {
        bs_alu_src == bs_alu_src_t'(bs_mul_src);
    }
}

constraint nvdla_sdp_resource::c_ias_bn {
    !((bn_alu_bypass == bn_alu_bypass_NO) && (bn_mul_prelu == bn_mul_prelu_YES));
    if(proc_precision != proc_precision_FP16) {
        bn_mul_shift_value inside {[0:63]};
    }
    (bn_alu_bypass == bn_alu_bypass_NO && bn_mul_bypass == bn_mul_bypass_NO && bn_bypass == bn_bypass_NO) -> {
        bn_alu_src == bn_alu_src_t'(bn_mul_src);
    }
}

constraint nvdla_sdp_resource::c_ias_ew {
    (ew_bypass == ew_bypass_NO && ew_mul_bypass == ew_mul_bypass_NO && proc_precision == proc_precision_FP16) -> (ew_mul_cvt_bypass == ew_mul_cvt_bypass_NO);
    if(ew_bypass == ew_bypass_NO && ew_alu_bypass == ew_alu_bypass_NO) {
        if(proc_precision == proc_precision_FP16) {ew_alu_cvt_bypass == ew_alu_cvt_bypass_NO;}
        else if(ew_alu_algo == ew_alu_algo_EQL) {ew_alu_cvt_bypass == ew_alu_cvt_bypass_YES;}
    }
    (ew_bypass == ew_bypass_NO && ew_alu_bypass == ew_alu_bypass_NO && ew_alu_algo == ew_alu_algo_EQL) -> {
        ew_mul_bypass     == ew_mul_bypass_YES;
        ew_lut_bypass     == ew_lut_bypass_YES;
        ew_mul_cvt_bypass == ew_mul_cvt_bypass_YES;
        cvt_offset        == 0;
        cvt_scale         == 1;
        cvt_shift         == 0;
        proc_precision    == proc_precision_t'(out_precision);
    }
    !((ew_bypass == ew_bypass_NO) && (ew_alu_bypass == ew_alu_bypass_NO) && (ew_mul_prelu == ew_mul_prelu_YES));
    (ew_alu_src == ew_alu_src_REG) -> {
        ew_alu_operand dist { [16'h0:16'hFFFF]:=100};
    }
    (ew_alu_cvt_bypass == ew_alu_cvt_bypass_NO && proc_precision != proc_precision_FP16) -> {
        ew_alu_cvt_truncate inside {[0:48]};
    }
    (ew_mul_src == ew_mul_src_REG) -> {
        ew_mul_operand dist { [16'h0:16'hFFFF]:=100};
    }
    (ew_mul_cvt_bypass == ew_mul_cvt_bypass_NO && proc_precision != proc_precision_FP16) -> {
        ew_mul_cvt_truncate inside {[0:48]};
    }

    if(proc_precision != proc_precision_FP16) {
        ew_truncate inside {[0:62]};
    }

    (ew_alu_bypass == ew_alu_bypass_NO && ew_mul_bypass == ew_mul_bypass_NO && ew_bypass == ew_bypass_NO) -> {
        ew_alu_src == ew_alu_src_t'(ew_mul_src);
    }
}

constraint nvdla_sdp_resource::c_ias_feature {
    (flying_mode == flying_mode_ON) -> { !((batch_number!=0) && (winograd==winograd_ON)); }
    (flying_mode == flying_mode_OFF) -> { !((batch_number!=0) && (winograd==winograd_ON)); }

`ifdef PRECISION_CONVERSION_ENABLE
    (proc_precision == proc_precision_INT8)  -> out_precision inside {out_precision_INT8, out_precision_INT16};
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    (proc_precision == proc_precision_INT16) -> out_precision inside {out_precision_INT16, out_precision_FP16};
    (proc_precision == proc_precision_FP16)  -> out_precision inside {out_precision_INT16, out_precision_FP16};
`endif
`endif

    if(flying_mode == flying_mode_ON) {
        proc_precision == proc_precision_t'(out_precision);
        !(ew_bypass == ew_bypass_NO && ew_alu_bypass == ew_alu_bypass_NO && ew_alu_algo == ew_alu_algo_EQL);
    }
}

constraint nvdla_sdp_resource::c_ias_dut_por_requirement {
`ifndef NVDLA_SDP_EW_ENABLE
    ew_bypass      == ew_bypass_YES      ;
`endif
    winograd       == winograd_OFF       ;
`ifndef NVDLA_SECONDARY_MEMIF_ENABLE
    dst_ram_type   == dst_ram_type_MC    ;
`endif
    proc_precision == proc_precision_INT8;
    out_precision  == out_precision_INT8 ;
    batch_number   == 0                  ;
}

// ----------------------------------
// Weight Distribution Control
// ----------------------------------
constraint nvdla_sdp_resource::c_sim_dst_mem_weight_dist {
    `weight_dist_32bit(dst_base_addr_high)
    `weight_dist_32bit(dst_base_addr_low)
    `weight_dist_32bit(dst_line_stride)
    `weight_dist_32bit(dst_surface_stride)
    `weight_dist_32bit(dst_batch_stride)
}

constraint nvdla_sdp_resource::c_sim_bs_weight_dist {
    `weight_dist_6bit(bs_alu_shift_value)
    `weight_dist_6bit(bs_mul_shift_value)
}

constraint nvdla_sdp_resource::c_sim_bn_weight_dist {
    `weight_dist_6bit(bn_alu_shift_value)
    `weight_dist_8bit(bn_mul_shift_value)
}

constraint nvdla_sdp_resource::c_sim_ew_weight_dist {
    `weight_dist_32bit(ew_alu_cvt_offset)
    `weight_dist_16bit(ew_alu_cvt_scale)
    `weight_dist_10bit(ew_alu_cvt_truncate)
    `weight_dist_32bit(ew_mul_cvt_offset)
    `weight_dist_16bit(ew_mul_cvt_scale)
    `weight_dist_10bit(ew_mul_cvt_truncate)
    `weight_dist_10bit(ew_truncate)
}

constraint nvdla_sdp_resource::c_sim_cvt_weight_dist {
    `weight_dist_32bit(cvt_offset)
    `weight_dist_16bit(cvt_scale)
    `weight_dist_6bit(cvt_shift)
}

constraint nvdla_sdp_resource::c_sim_batch_num_dist {
    `weight_dist_5bit(batch_number)
}


constraint nvdla_sdp_resource::c_sim_cube_size_small {
    batch_number inside {[0:'h3]};

    if (batch_number == 0) {
        width   inside {[0:'h18]};
        height  inside {[0:'h18]};
        channel inside {[0:'h3F]};
        (width+1)*(height+1)*(channel+1)    <= 64'h8000;
    }
`ifdef NVDLA_BATCH_ENABLE
    else {
        width   inside {[0:'h0F]};
        height  inside {[0:'h0F]};
        channel inside {[0:'h3F]};
        (width+1)*(height+1)*(channel+1)    <= 64'h4000;
    }
`endif
}

constraint nvdla_sdp_resource::c_sim_cube_size_medium {
    batch_number inside {[0:'h7]};

    if (batch_number == 0) {
        width   inside {[0:'h7F]};
        height  inside {[0:'h7F]};
        channel inside {[0:'h7F]};
        (width+1)*(height+1)*(channel+1)    >  64'h8000;
        (width+1)*(height+1)*(channel+1)    <= 64'h2_0000;
    }
`ifdef NVDLA_BATCH_ENABLE
    else {
        width   inside {[0:'h2F]};
        height  inside {[0:'h2F]};
        channel inside {[0:'h5F]};
        (width+1)*(height+1)*(channel+1)    >  64'h4000;
        (width+1)*(height+1)*(channel+1)    <= 64'h1_0000;
    }
`endif
}

constraint nvdla_sdp_resource::c_sim_cube_size_large {
    width   inside {[0:'h1FFF]};
    height  inside {[0:'h1FFF]};
    channel inside {[0:'h1FFF]};
    (width+1)*(height+1)*(channel+1)    > 64'h2_0000;
    (width+1)*(height+1)*(channel+1)    <= 64'h20_0000;
}

constraint nvdla_sdp_resource::c_sim_cube_size_normal {
    width   dist { [13'h0:13'hF]:=15, [13'h10:13'h7F]:=65, [13'h80:13'hFFF]:=10, [13'h1000:13'h1FFE]:=9, 13'h1FFF :=1 };
    height  dist { [13'h0:13'hF]:=15, [13'h10:13'h7F]:=65, [13'h80:13'hFFF]:=10, [13'h1000:13'h1FFE]:=9, 13'h1FFF :=1 };
    channel dist { [13'h0:13'hF]:=15, [13'h10:13'h7F]:=65, [13'h80:13'hFFF]:=10, [13'h1000:13'h1FFE]:=9, 13'h1FFF :=1 };
    (width+1)*(height+1)*(channel+1)    <= 64'h4_0000;
}

function void nvdla_sdp_resource::pre_randomize();
    if(sdp_lut_reuse == 1 && pre_proc_precision != -1) begin
        proc_precision = proc_precision_t'(pre_proc_precision);
        proc_precision.rand_mode(0);
    end
endfunction : pre_randomize

function void nvdla_sdp_resource::post_randomize();
    set_lut();
    if (output_dst == output_dst_MEM) set_mem_addr();
    set_register();
    // For LUT_REUSE usage
    pre_proc_precision = proc_precision;
    proc_precision.rand_mode(1);

    `uvm_info(inst_name, {"\n", sprint()}, UVM_HIGH)
endfunction : post_randomize

function void nvdla_sdp_resource::set_sim_constraint();
    `uvm_info(inst_name, $sformatf("set sim constraint constraint"), UVM_LOW)
    if ("SMALL"== sdp_cube_size.toupper()) begin
        c_sim_cube_size_small.constraint_mode(1);
        c_sim_cube_size_medium.constraint_mode(0);
        c_sim_cube_size_large.constraint_mode(0);
        c_sim_cube_size_normal.constraint_mode(0);
    end else if ("MEDIUM"== sdp_cube_size.toupper()) begin
        c_sim_cube_size_small.constraint_mode(0);
        c_sim_cube_size_medium.constraint_mode(1);
        c_sim_cube_size_large.constraint_mode(0);
        c_sim_cube_size_normal.constraint_mode(0);
    end else if ("LARGE"== sdp_cube_size.toupper()) begin
        c_sim_cube_size_small.constraint_mode(0);
        c_sim_cube_size_medium.constraint_mode(0);
        c_sim_cube_size_large.constraint_mode(1);
        c_sim_cube_size_normal.constraint_mode(0);
    end else if ("NORMAL"== sdp_cube_size.toupper()) begin
        c_sim_cube_size_small.constraint_mode(0);
        c_sim_cube_size_medium.constraint_mode(0);
        c_sim_cube_size_large.constraint_mode(0);
        c_sim_cube_size_normal.constraint_mode(1);
    end else `uvm_fatal(inst_name, $sformatf("Unknown sdp_cube_size option:%0s",sdp_cube_size.toupper()))
endfunction: set_sim_constraint

function void nvdla_sdp_resource::set_lut();
    chandle fp32_a = new_FP32();
    chandle fp32_b = new_FP32();
    chandle fp32_o = new_FP32();

    // FP format value post configuration
    if(proc_precision == proc_precision_FP16) begin
        bit [31:0] data_b = 0;
        set_FP32(fp32_a, lut_le_start);
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
        get_FP32(fp32_o, lut_le_end);
        if((lut_le_end[22:0] == 0) && (lut_le_end[30:23] == 8'hFF)) begin
            lut_le_end = 32'h7F7F_FFFF;
        end

        set_FP32(fp32_a, lut_lo_start);
        data_b[30:23] = (signed'(lut_lo_index_select)+8) + 7'h7F;
        set_FP32(fp32_b, data_b);
        FpAdd_FP32_ref(fp32_a, fp32_b, fp32_o);
        get_FP32(fp32_o, lut_lo_end);
        if((lut_lo_end[22:0] == 0) && (lut_lo_end[30:23] == 8'hFF)) begin
            lut_lo_end = 32'h7F7F_FFFF;
        end
    end
endfunction : set_lut

function void nvdla_sdp_resource::set_mem_addr();
    mem_man             mm;
    mem_region          region;
    longint unsigned    mem_size;
    string              mem_domain_output;

    mm = mem_man::get_mem_man();

    // WDMA
    mem_domain_output = (dst_ram_type_MC==dst_ram_type) ? "pri_mem":"sec_mem";
    mem_size          = calc_mem_size( batch_number+1, dst_batch_stride, channel+1, 
                                       `NVDLA_MEMORY_ATOMIC_SIZE, dst_surface_stride);
    region            = mm.request_region_by_size( mem_domain_output, 
                                                   $sformatf("%s_%0d", "SDP_WDMA", get_active_cnt()),
                                                   mem_size, 
                                                   align_mask[0]);
    {dst_base_addr_high, dst_base_addr_low} = region.get_start_offset();
endfunction : set_mem_addr

function void nvdla_sdp_resource::set_register();
    //:| spec2cons.ral_set(['NVDLA_SDP'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    ral.nvdla.NVDLA_SDP.S_LUT_ACCESS_CFG.LUT_ADDR.set(                                 lut_addr);
    ral.nvdla.NVDLA_SDP.S_LUT_ACCESS_CFG.LUT_TABLE_ID.set(                             lut_table_id);
    ral.nvdla.NVDLA_SDP.S_LUT_ACCESS_CFG.LUT_ACCESS_TYPE.set(                          lut_access_type);
    ral.nvdla.NVDLA_SDP.S_LUT_ACCESS_DATA.LUT_DATA.set(                                lut_data);
    ral.nvdla.NVDLA_SDP.S_LUT_CFG.LUT_LE_FUNCTION.set(                                 lut_le_function);
    ral.nvdla.NVDLA_SDP.S_LUT_CFG.LUT_UFLOW_PRIORITY.set(                              lut_uflow_priority);
    ral.nvdla.NVDLA_SDP.S_LUT_CFG.LUT_OFLOW_PRIORITY.set(                              lut_oflow_priority);
    ral.nvdla.NVDLA_SDP.S_LUT_CFG.LUT_HYBRID_PRIORITY.set(                             lut_hybrid_priority);
    ral.nvdla.NVDLA_SDP.S_LUT_INFO.LUT_LE_INDEX_OFFSET.set(                            lut_le_index_offset);
    ral.nvdla.NVDLA_SDP.S_LUT_INFO.LUT_LE_INDEX_SELECT.set(                            lut_le_index_select);
    ral.nvdla.NVDLA_SDP.S_LUT_INFO.LUT_LO_INDEX_SELECT.set(                            lut_lo_index_select);
    ral.nvdla.NVDLA_SDP.S_LUT_LE_START.LUT_LE_START.set(                               lut_le_start);
    ral.nvdla.NVDLA_SDP.S_LUT_LE_END.LUT_LE_END.set(                                   lut_le_end);
    ral.nvdla.NVDLA_SDP.S_LUT_LO_START.LUT_LO_START.set(                               lut_lo_start);
    ral.nvdla.NVDLA_SDP.S_LUT_LO_END.LUT_LO_END.set(                                   lut_lo_end);
    ral.nvdla.NVDLA_SDP.S_LUT_LE_SLOPE_SCALE.LUT_LE_SLOPE_UFLOW_SCALE.set(             lut_le_slope_uflow_scale);
    ral.nvdla.NVDLA_SDP.S_LUT_LE_SLOPE_SCALE.LUT_LE_SLOPE_OFLOW_SCALE.set(             lut_le_slope_oflow_scale);
    ral.nvdla.NVDLA_SDP.S_LUT_LE_SLOPE_SHIFT.LUT_LE_SLOPE_UFLOW_SHIFT.set(             lut_le_slope_uflow_shift);
    ral.nvdla.NVDLA_SDP.S_LUT_LE_SLOPE_SHIFT.LUT_LE_SLOPE_OFLOW_SHIFT.set(             lut_le_slope_oflow_shift);
    ral.nvdla.NVDLA_SDP.S_LUT_LO_SLOPE_SCALE.LUT_LO_SLOPE_UFLOW_SCALE.set(             lut_lo_slope_uflow_scale);
    ral.nvdla.NVDLA_SDP.S_LUT_LO_SLOPE_SCALE.LUT_LO_SLOPE_OFLOW_SCALE.set(             lut_lo_slope_oflow_scale);
    ral.nvdla.NVDLA_SDP.S_LUT_LO_SLOPE_SHIFT.LUT_LO_SLOPE_UFLOW_SHIFT.set(             lut_lo_slope_uflow_shift);
    ral.nvdla.NVDLA_SDP.S_LUT_LO_SLOPE_SHIFT.LUT_LO_SLOPE_OFLOW_SHIFT.set(             lut_lo_slope_oflow_shift);
    ral.nvdla.NVDLA_SDP.D_DATA_CUBE_WIDTH.WIDTH.set(                                   width);
    ral.nvdla.NVDLA_SDP.D_DATA_CUBE_HEIGHT.HEIGHT.set(                                 height);
    ral.nvdla.NVDLA_SDP.D_DATA_CUBE_CHANNEL.CHANNEL.set(                               channel);
    ral.nvdla.NVDLA_SDP.D_DST_BASE_ADDR_LOW.DST_BASE_ADDR_LOW.set(                     dst_base_addr_low);
    ral.nvdla.NVDLA_SDP.D_DST_BASE_ADDR_HIGH.DST_BASE_ADDR_HIGH.set(                   dst_base_addr_high);
    ral.nvdla.NVDLA_SDP.D_DST_LINE_STRIDE.DST_LINE_STRIDE.set(                         dst_line_stride);
    ral.nvdla.NVDLA_SDP.D_DST_SURFACE_STRIDE.DST_SURFACE_STRIDE.set(                   dst_surface_stride);
    ral.nvdla.NVDLA_SDP.D_DP_BS_CFG.BS_BYPASS.set(                                     bs_bypass);
    ral.nvdla.NVDLA_SDP.D_DP_BS_CFG.BS_ALU_BYPASS.set(                                 bs_alu_bypass);
    ral.nvdla.NVDLA_SDP.D_DP_BS_CFG.BS_ALU_ALGO.set(                                   bs_alu_algo);
    ral.nvdla.NVDLA_SDP.D_DP_BS_CFG.BS_MUL_BYPASS.set(                                 bs_mul_bypass);
    ral.nvdla.NVDLA_SDP.D_DP_BS_CFG.BS_MUL_PRELU.set(                                  bs_mul_prelu);
    ral.nvdla.NVDLA_SDP.D_DP_BS_CFG.BS_RELU_BYPASS.set(                                bs_relu_bypass);
    ral.nvdla.NVDLA_SDP.D_DP_BS_ALU_CFG.BS_ALU_SRC.set(                                bs_alu_src);
    ral.nvdla.NVDLA_SDP.D_DP_BS_ALU_CFG.BS_ALU_SHIFT_VALUE.set(                        bs_alu_shift_value);
    ral.nvdla.NVDLA_SDP.D_DP_BS_ALU_SRC_VALUE.BS_ALU_OPERAND.set(                      bs_alu_operand);
    ral.nvdla.NVDLA_SDP.D_DP_BS_MUL_CFG.BS_MUL_SRC.set(                                bs_mul_src);
    ral.nvdla.NVDLA_SDP.D_DP_BS_MUL_CFG.BS_MUL_SHIFT_VALUE.set(                        bs_mul_shift_value);
    ral.nvdla.NVDLA_SDP.D_DP_BS_MUL_SRC_VALUE.BS_MUL_OPERAND.set(                      bs_mul_operand);
    ral.nvdla.NVDLA_SDP.D_DP_BN_CFG.BN_BYPASS.set(                                     bn_bypass);
    ral.nvdla.NVDLA_SDP.D_DP_BN_CFG.BN_ALU_BYPASS.set(                                 bn_alu_bypass);
    ral.nvdla.NVDLA_SDP.D_DP_BN_CFG.BN_ALU_ALGO.set(                                   bn_alu_algo);
    ral.nvdla.NVDLA_SDP.D_DP_BN_CFG.BN_MUL_BYPASS.set(                                 bn_mul_bypass);
    ral.nvdla.NVDLA_SDP.D_DP_BN_CFG.BN_MUL_PRELU.set(                                  bn_mul_prelu);
    ral.nvdla.NVDLA_SDP.D_DP_BN_CFG.BN_RELU_BYPASS.set(                                bn_relu_bypass);
    ral.nvdla.NVDLA_SDP.D_DP_BN_ALU_CFG.BN_ALU_SRC.set(                                bn_alu_src);
    ral.nvdla.NVDLA_SDP.D_DP_BN_ALU_CFG.BN_ALU_SHIFT_VALUE.set(                        bn_alu_shift_value);
    ral.nvdla.NVDLA_SDP.D_DP_BN_ALU_SRC_VALUE.BN_ALU_OPERAND.set(                      bn_alu_operand);
    ral.nvdla.NVDLA_SDP.D_DP_BN_MUL_CFG.BN_MUL_SRC.set(                                bn_mul_src);
    ral.nvdla.NVDLA_SDP.D_DP_BN_MUL_CFG.BN_MUL_SHIFT_VALUE.set(                        bn_mul_shift_value);
    ral.nvdla.NVDLA_SDP.D_DP_BN_MUL_SRC_VALUE.BN_MUL_OPERAND.set(                      bn_mul_operand);
    ral.nvdla.NVDLA_SDP.D_DP_EW_CFG.EW_BYPASS.set(                                     ew_bypass);
    ral.nvdla.NVDLA_SDP.D_DP_EW_CFG.EW_ALU_BYPASS.set(                                 ew_alu_bypass);
    ral.nvdla.NVDLA_SDP.D_DP_EW_CFG.EW_ALU_ALGO.set(                                   ew_alu_algo);
    ral.nvdla.NVDLA_SDP.D_DP_EW_CFG.EW_MUL_BYPASS.set(                                 ew_mul_bypass);
    ral.nvdla.NVDLA_SDP.D_DP_EW_CFG.EW_MUL_PRELU.set(                                  ew_mul_prelu);
    ral.nvdla.NVDLA_SDP.D_DP_EW_CFG.EW_LUT_BYPASS.set(                                 ew_lut_bypass);
    ral.nvdla.NVDLA_SDP.D_DP_EW_ALU_CFG.EW_ALU_SRC.set(                                ew_alu_src);
    ral.nvdla.NVDLA_SDP.D_DP_EW_ALU_CFG.EW_ALU_CVT_BYPASS.set(                         ew_alu_cvt_bypass);
    ral.nvdla.NVDLA_SDP.D_DP_EW_ALU_SRC_VALUE.EW_ALU_OPERAND.set(                      ew_alu_operand);
    ral.nvdla.NVDLA_SDP.D_DP_EW_ALU_CVT_OFFSET_VALUE.EW_ALU_CVT_OFFSET.set(            ew_alu_cvt_offset);
    ral.nvdla.NVDLA_SDP.D_DP_EW_ALU_CVT_SCALE_VALUE.EW_ALU_CVT_SCALE.set(              ew_alu_cvt_scale);
    ral.nvdla.NVDLA_SDP.D_DP_EW_ALU_CVT_TRUNCATE_VALUE.EW_ALU_CVT_TRUNCATE.set(        ew_alu_cvt_truncate);
    ral.nvdla.NVDLA_SDP.D_DP_EW_MUL_CFG.EW_MUL_SRC.set(                                ew_mul_src);
    ral.nvdla.NVDLA_SDP.D_DP_EW_MUL_CFG.EW_MUL_CVT_BYPASS.set(                         ew_mul_cvt_bypass);
    ral.nvdla.NVDLA_SDP.D_DP_EW_MUL_SRC_VALUE.EW_MUL_OPERAND.set(                      ew_mul_operand);
    ral.nvdla.NVDLA_SDP.D_DP_EW_MUL_CVT_OFFSET_VALUE.EW_MUL_CVT_OFFSET.set(            ew_mul_cvt_offset);
    ral.nvdla.NVDLA_SDP.D_DP_EW_MUL_CVT_SCALE_VALUE.EW_MUL_CVT_SCALE.set(              ew_mul_cvt_scale);
    ral.nvdla.NVDLA_SDP.D_DP_EW_MUL_CVT_TRUNCATE_VALUE.EW_MUL_CVT_TRUNCATE.set(        ew_mul_cvt_truncate);
    ral.nvdla.NVDLA_SDP.D_DP_EW_TRUNCATE_VALUE.EW_TRUNCATE.set(                        ew_truncate);
    ral.nvdla.NVDLA_SDP.D_FEATURE_MODE_CFG.FLYING_MODE.set(                            flying_mode);
    ral.nvdla.NVDLA_SDP.D_FEATURE_MODE_CFG.OUTPUT_DST.set(                             output_dst);
    ral.nvdla.NVDLA_SDP.D_FEATURE_MODE_CFG.WINOGRAD.set(                               winograd);
    ral.nvdla.NVDLA_SDP.D_FEATURE_MODE_CFG.NAN_TO_ZERO.set(                            nan_to_zero);
    ral.nvdla.NVDLA_SDP.D_FEATURE_MODE_CFG.BATCH_NUMBER.set(                           batch_number);
    ral.nvdla.NVDLA_SDP.D_DST_DMA_CFG.DST_RAM_TYPE.set(                                dst_ram_type);
    ral.nvdla.NVDLA_SDP.D_DST_BATCH_STRIDE.DST_BATCH_STRIDE.set(                       dst_batch_stride);
    ral.nvdla.NVDLA_SDP.D_DATA_FORMAT.PROC_PRECISION.set(                              proc_precision);
    ral.nvdla.NVDLA_SDP.D_DATA_FORMAT.OUT_PRECISION.set(                               out_precision);
    ral.nvdla.NVDLA_SDP.D_CVT_OFFSET.CVT_OFFSET.set(                                   cvt_offset);
    ral.nvdla.NVDLA_SDP.D_CVT_SCALE.CVT_SCALE.set(                                     cvt_scale);
    ral.nvdla.NVDLA_SDP.D_CVT_SHIFT.CVT_SHIFT.set(                                     cvt_shift);
    ral.nvdla.NVDLA_SDP.D_PERF_ENABLE.PERF_DMA_EN.set(                                 perf_dma_en);
    ral.nvdla.NVDLA_SDP.D_PERF_ENABLE.PERF_LUT_EN.set(                                 perf_lut_en);
    ral.nvdla.NVDLA_SDP.D_PERF_ENABLE.PERF_SAT_EN.set(                                 perf_sat_en);
    ral.nvdla.NVDLA_SDP.D_PERF_ENABLE.PERF_NAN_INF_COUNT_EN.set(                       perf_nan_inf_count_en);
    //:) epython: generated_end (DO NOT EDIT ABOVE)
endfunction : set_register

`endif //_NVDLA_SDP_RESOURCE_SV_
