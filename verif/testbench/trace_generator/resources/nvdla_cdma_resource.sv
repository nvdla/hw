`ifndef _NVDLA_CDMA_RESOURCE_SV_
`define _NVDLA_CDMA_RESOURCE_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_cdma_resource
//
// @description: various hardware resources of cdma sub module
//-------------------------------------------------------------------------------------

typedef class nvdla_cc_dp_resource;

class nvdla_cdma_resource extends nvdla_base_resource;

    // singleton handle
    static local nvdla_cdma_resource        inst;
    string  cdma_feature_surface_pattern    = "random";
    string  cdma_image_surface_pattern      = "random";
    string  cdma_weight_surface_pattern     = "random";
    string  data_sync_evt_queue[-2:0];
    string  weight_sync_evt_queue[-2:0];

    string  cc_input_cube_size              = "NORMAL";

    // enum define
    //:| import spec2constrain
    //:| global spec2cons
    //:| spec2cons = spec2constrain.Spec2Cons()
    //:| spec2cons.enum_gen(['NVDLA_CDMA'])
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
    typedef enum{ pixel_format_T_R8                = 'h0
                 ,pixel_format_T_R10               = 'h1
                 ,pixel_format_T_R12               = 'h2
                 ,pixel_format_T_R16               = 'h3
                 ,pixel_format_T_R16_I             = 'h4
                 ,pixel_format_T_R16_F             = 'h5
                 ,pixel_format_T_A16B16G16R16      = 'h6
                 ,pixel_format_T_X16B16G16R16      = 'h7
                 ,pixel_format_T_A16B16G16R16_F    = 'h8
                 ,pixel_format_T_A16Y16U16V16      = 'h9
                 ,pixel_format_T_V16U16Y16A16      = 'ha
                 ,pixel_format_T_A16Y16U16V16_F    = 'hb
                 ,pixel_format_T_A8B8G8R8          = 'hc
                 ,pixel_format_T_A8R8G8B8          = 'hd
                 ,pixel_format_T_B8G8R8A8          = 'he
                 ,pixel_format_T_R8G8B8A8          = 'hf
                 ,pixel_format_T_X8B8G8R8          = 'h10
                 ,pixel_format_T_X8R8G8B8          = 'h11
                 ,pixel_format_T_B8G8R8X8          = 'h12
                 ,pixel_format_T_R8G8B8X8          = 'h13
                 ,pixel_format_T_A2B10G10R10       = 'h14
                 ,pixel_format_T_A2R10G10B10       = 'h15
                 ,pixel_format_T_B10G10R10A2       = 'h16
                 ,pixel_format_T_R10G10B10A2       = 'h17
                 ,pixel_format_T_A2Y10U10V10       = 'h18
                 ,pixel_format_T_V10U10Y10A2       = 'h19
                 ,pixel_format_T_A8Y8U8V8          = 'h1a
                 ,pixel_format_T_V8U8Y8A8          = 'h1b
                 ,pixel_format_T_Y8___U8V8_N444    = 'h1c
                 ,pixel_format_T_Y8___V8U8_N444    = 'h1d
                 ,pixel_format_T_Y10___U10V10_N444 = 'h1e
                 ,pixel_format_T_Y10___V10U10_N444 = 'h1f
                 ,pixel_format_T_Y12___U12V12_N444 = 'h20
                 ,pixel_format_T_Y12___V12U12_N444 = 'h21
                 ,pixel_format_T_Y16___U16V16_N444 = 'h22
                 ,pixel_format_T_Y16___V16U16_N444 = 'h23
                } pixel_format_t;
    typedef enum{ pixel_mapping_PITCH_LINEAR       = 'h0
                 ,pixel_mapping_RESERVED_LINEAR    = 'h1
                } pixel_mapping_t;
    typedef enum{ pixel_sign_override_UNSIGNED_INT = 'h0
                 ,pixel_sign_override_SIGNED_INT   = 'h1
                } pixel_sign_override_t;
    typedef enum{ datain_ram_type_CVIF             = 'h0
                 ,datain_ram_type_MCIF             = 'h1
                } datain_ram_type_t;
    typedef enum{ line_packed_FALSE                = 'h0
                 ,line_packed_TRUE                 = 'h1
                } line_packed_t;
    typedef enum{ surf_packed_FALSE                = 'h0
                 ,surf_packed_TRUE                 = 'h1
                } surf_packed_t;
    typedef enum{ weight_format_UNCOMPRESSED       = 'h0
                 ,weight_format_COMPRESSED         = 'h1
                } weight_format_t;
    typedef enum{ weight_ram_type_CVIF             = 'h0
                 ,weight_ram_type_MCIF             = 'h1
                } weight_ram_type_t;
    typedef enum{ mean_format_DISABLE              = 'h0
                 ,mean_format_ENABLE               = 'h1
                } mean_format_t;
    typedef enum{ cvt_en_DISABLE                   = 'h0
                 ,cvt_en_ENABLE                    = 'h1
                } cvt_en_t;
    typedef enum{ nan_to_zero_DISABLE              = 'h0
                 ,nan_to_zero_ENABLE               = 'h1
                } nan_to_zero_t;
    //:) epython: generated_end (DO NOT EDIT ABOVE)

    // Used for controling memory data 0 value rate:
    // feature: [0:10000]
    rand int feature_none_zero_rate;

    // field variables
    //:| spec2cons.state_gen(['NVDLA_CDMA'])
    //:| spec2cons.state_gen(['NVDLA_CDMA'], 'prev_', False)
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    rand bit [3:0]                  arb_weight;
    rand bit [3:0]                  arb_wmb;
    rand conv_mode_t                conv_mode;
    rand in_precision_t             in_precision;
    rand proc_precision_t           proc_precision;
    rand data_reuse_t               data_reuse;
    rand weight_reuse_t             weight_reuse;
    rand skip_data_rls_t            skip_data_rls;
    rand skip_weight_rls_t          skip_weight_rls;
    rand datain_format_t            datain_format;
    rand pixel_format_t             pixel_format;
    rand pixel_mapping_t            pixel_mapping;
    rand pixel_sign_override_t      pixel_sign_override;
    rand bit [12:0]                 datain_width;
    rand bit [12:0]                 datain_height;
    rand bit [12:0]                 datain_channel;
    rand bit [12:0]                 datain_width_ext;
    rand bit [12:0]                 datain_height_ext;
    rand bit [4:0]                  pixel_x_offset;
    rand bit [2:0]                  pixel_y_offset;
    rand datain_ram_type_t          datain_ram_type;
    rand bit [31:0]                 datain_addr_high_0;
    rand bit [31:0]                 datain_addr_low_0;
    rand bit [31:0]                 datain_addr_high_1;
    rand bit [31:0]                 datain_addr_low_1;
    rand bit [31:0]                 line_stride;
    rand bit [31:0]                 uv_line_stride;
    rand bit [31:0]                 surf_stride;
    rand line_packed_t              line_packed;
    rand surf_packed_t              surf_packed;
    rand bit [9:0]                  rsv_per_line;
    rand bit [9:0]                  rsv_per_uv_line;
    rand bit [2:0]                  rsv_height;
    rand bit [4:0]                  rsv_y_index;
    rand bit [4:0]                  batches;
    rand bit [31:0]                 batch_stride;
    rand bit [13:0]                 entries;
    rand bit [11:0]                 grains;
    rand weight_format_t            weight_format;
    rand bit [17:0]                 byte_per_kernel;
    rand bit [12:0]                 weight_kernel;
    rand weight_ram_type_t          weight_ram_type;
    rand bit [31:0]                 weight_addr_high;
    rand bit [31:0]                 weight_addr_low;
    rand bit [28:0]                 weight_bytes;
    rand bit [31:0]                 wgs_addr_high;
    rand bit [31:0]                 wgs_addr_low;
    rand bit [31:0]                 wmb_addr_high;
    rand bit [31:0]                 wmb_addr_low;
    rand bit [24:0]                 wmb_bytes;
    rand mean_format_t              mean_format;
    rand bit [15:0]                 mean_ry;
    rand bit [15:0]                 mean_gu;
    rand bit [15:0]                 mean_bv;
    rand bit [15:0]                 mean_ax;
    rand cvt_en_t                   cvt_en;
    rand bit [5:0]                  cvt_truncate;
    rand bit [15:0]                 cvt_offset;
    rand bit [15:0]                 cvt_scale;
    rand bit [2:0]                  conv_x_stride;
    rand bit [2:0]                  conv_y_stride;
    rand bit [4:0]                  pad_left;
    rand bit [5:0]                  pad_right;
    rand bit [4:0]                  pad_top;
    rand bit [5:0]                  pad_bottom;
    rand bit [15:0]                 pad_value;
    rand bit [4:0]                  data_bank;
    rand bit [4:0]                  weight_bank;
    rand nan_to_zero_t              nan_to_zero;
    rand bit [0:0]                  dma_en;
    rand bit [31:0]                 cya;
    bit [3:0]                       prev_arb_weight;
    bit [3:0]                       prev_arb_wmb;
    conv_mode_t                     prev_conv_mode;
    in_precision_t                  prev_in_precision;
    proc_precision_t                prev_proc_precision;
    data_reuse_t                    prev_data_reuse;
    weight_reuse_t                  prev_weight_reuse;
    skip_data_rls_t                 prev_skip_data_rls;
    skip_weight_rls_t               prev_skip_weight_rls;
    datain_format_t                 prev_datain_format;
    pixel_format_t                  prev_pixel_format;
    pixel_mapping_t                 prev_pixel_mapping;
    pixel_sign_override_t           prev_pixel_sign_override;
    bit [12:0]                      prev_datain_width;
    bit [12:0]                      prev_datain_height;
    bit [12:0]                      prev_datain_channel;
    bit [12:0]                      prev_datain_width_ext;
    bit [12:0]                      prev_datain_height_ext;
    bit [4:0]                       prev_pixel_x_offset;
    bit [2:0]                       prev_pixel_y_offset;
    datain_ram_type_t               prev_datain_ram_type;
    bit [31:0]                      prev_datain_addr_high_0;
    bit [31:0]                      prev_datain_addr_low_0;
    bit [31:0]                      prev_datain_addr_high_1;
    bit [31:0]                      prev_datain_addr_low_1;
    bit [31:0]                      prev_line_stride;
    bit [31:0]                      prev_uv_line_stride;
    bit [31:0]                      prev_surf_stride;
    line_packed_t                   prev_line_packed;
    surf_packed_t                   prev_surf_packed;
    bit [9:0]                       prev_rsv_per_line;
    bit [9:0]                       prev_rsv_per_uv_line;
    bit [2:0]                       prev_rsv_height;
    bit [4:0]                       prev_rsv_y_index;
    bit [4:0]                       prev_batches;
    bit [31:0]                      prev_batch_stride;
    bit [13:0]                      prev_entries;
    bit [11:0]                      prev_grains;
    weight_format_t                 prev_weight_format;
    bit [17:0]                      prev_byte_per_kernel;
    bit [12:0]                      prev_weight_kernel;
    weight_ram_type_t               prev_weight_ram_type;
    bit [31:0]                      prev_weight_addr_high;
    bit [31:0]                      prev_weight_addr_low;
    bit [28:0]                      prev_weight_bytes;
    bit [31:0]                      prev_wgs_addr_high;
    bit [31:0]                      prev_wgs_addr_low;
    bit [31:0]                      prev_wmb_addr_high;
    bit [31:0]                      prev_wmb_addr_low;
    bit [24:0]                      prev_wmb_bytes;
    mean_format_t                   prev_mean_format;
    bit [15:0]                      prev_mean_ry;
    bit [15:0]                      prev_mean_gu;
    bit [15:0]                      prev_mean_bv;
    bit [15:0]                      prev_mean_ax;
    cvt_en_t                        prev_cvt_en;
    bit [5:0]                       prev_cvt_truncate;
    bit [15:0]                      prev_cvt_offset;
    bit [15:0]                      prev_cvt_scale;
    bit [2:0]                       prev_conv_x_stride;
    bit [2:0]                       prev_conv_y_stride;
    bit [4:0]                       prev_pad_left;
    bit [5:0]                       prev_pad_right;
    bit [4:0]                       prev_pad_top;
    bit [5:0]                       prev_pad_bottom;
    bit [15:0]                      prev_pad_value;
    bit [4:0]                       prev_data_bank;
    bit [4:0]                       prev_weight_bank;
    nan_to_zero_t                   prev_nan_to_zero;
    bit [0:0]                       prev_dma_en;
    bit [31:0]                      prev_cya;
    //:) epython: generated_end (DO NOT EDIT ABOVE)
    rand byte                       plane_number;
    rand byte                       element_byte_size_plane_0;
    rand byte                       element_byte_size_plane_1;
    rand int unsigned               atomic_m;   // atomic memory
    rand int unsigned               atomic_c;   // atomic channel
    rand int unsigned               atomic_e;   // atomic entry
    rand int unsigned               atomic_e2m; // atomic_e//atomic_m
    rand int unsigned               n_atomic_m; // (channel_in+atomic_m-1)//atomic_m
    bit                             is_data_bank_changed;
    bit                             is_weight_bank_changed;
    bit                             is_weight_format_changed;

    `uvm_component_utils_begin(nvdla_cdma_resource)
        `uvm_field_string(cdma_feature_surface_pattern, UVM_ALL_ON)
        `uvm_field_string(cdma_image_surface_pattern,   UVM_ALL_ON)
        `uvm_field_string(cdma_weight_surface_pattern,  UVM_ALL_ON)
        `uvm_field_string(cc_input_cube_size,           UVM_ALL_ON)
        //:| spec2cons.macro_gen(['NVDLA_CDMA'])
        //:) epython: generated_beg (DO NOT EDIT BELOW)
        `uvm_field_int(arb_weight,                                     UVM_ALL_ON)
        `uvm_field_int(arb_wmb,                                        UVM_ALL_ON)
        `uvm_field_enum(conv_mode_t,              conv_mode,           UVM_ALL_ON)
        `uvm_field_enum(in_precision_t,           in_precision,        UVM_ALL_ON)
        `uvm_field_enum(proc_precision_t,         proc_precision,      UVM_ALL_ON)
        `uvm_field_enum(data_reuse_t,             data_reuse,          UVM_ALL_ON)
        `uvm_field_enum(weight_reuse_t,           weight_reuse,        UVM_ALL_ON)
        `uvm_field_enum(skip_data_rls_t,          skip_data_rls,       UVM_ALL_ON)
        `uvm_field_enum(skip_weight_rls_t,        skip_weight_rls,     UVM_ALL_ON)
        `uvm_field_enum(datain_format_t,          datain_format,       UVM_ALL_ON)
        `uvm_field_enum(pixel_format_t,           pixel_format,        UVM_ALL_ON)
        `uvm_field_enum(pixel_mapping_t,          pixel_mapping,       UVM_ALL_ON)
        `uvm_field_enum(pixel_sign_override_t,    pixel_sign_override, UVM_ALL_ON)
        `uvm_field_int(datain_width,                                   UVM_ALL_ON)
        `uvm_field_int(datain_height,                                  UVM_ALL_ON)
        `uvm_field_int(datain_channel,                                 UVM_ALL_ON)
        `uvm_field_int(datain_width_ext,                               UVM_ALL_ON)
        `uvm_field_int(datain_height_ext,                              UVM_ALL_ON)
        `uvm_field_int(pixel_x_offset,                                 UVM_ALL_ON)
        `uvm_field_int(pixel_y_offset,                                 UVM_ALL_ON)
        `uvm_field_enum(datain_ram_type_t,        datain_ram_type,     UVM_ALL_ON)
        `uvm_field_int(datain_addr_high_0,                             UVM_ALL_ON)
        `uvm_field_int(datain_addr_low_0,                              UVM_ALL_ON)
        `uvm_field_int(datain_addr_high_1,                             UVM_ALL_ON)
        `uvm_field_int(datain_addr_low_1,                              UVM_ALL_ON)
        `uvm_field_int(line_stride,                                    UVM_ALL_ON)
        `uvm_field_int(uv_line_stride,                                 UVM_ALL_ON)
        `uvm_field_int(surf_stride,                                    UVM_ALL_ON)
        `uvm_field_enum(line_packed_t,            line_packed,         UVM_ALL_ON)
        `uvm_field_enum(surf_packed_t,            surf_packed,         UVM_ALL_ON)
        `uvm_field_int(rsv_per_line,                                   UVM_ALL_ON)
        `uvm_field_int(rsv_per_uv_line,                                UVM_ALL_ON)
        `uvm_field_int(rsv_height,                                     UVM_ALL_ON)
        `uvm_field_int(rsv_y_index,                                    UVM_ALL_ON)
        `uvm_field_int(batches,                                        UVM_ALL_ON)
        `uvm_field_int(batch_stride,                                   UVM_ALL_ON)
        `uvm_field_int(entries,                                        UVM_ALL_ON)
        `uvm_field_int(grains,                                         UVM_ALL_ON)
        `uvm_field_enum(weight_format_t,          weight_format,       UVM_ALL_ON)
        `uvm_field_int(byte_per_kernel,                                UVM_ALL_ON)
        `uvm_field_int(weight_kernel,                                  UVM_ALL_ON)
        `uvm_field_enum(weight_ram_type_t,        weight_ram_type,     UVM_ALL_ON)
        `uvm_field_int(weight_addr_high,                               UVM_ALL_ON)
        `uvm_field_int(weight_addr_low,                                UVM_ALL_ON)
        `uvm_field_int(weight_bytes,                                   UVM_ALL_ON)
        `uvm_field_int(wgs_addr_high,                                  UVM_ALL_ON)
        `uvm_field_int(wgs_addr_low,                                   UVM_ALL_ON)
        `uvm_field_int(wmb_addr_high,                                  UVM_ALL_ON)
        `uvm_field_int(wmb_addr_low,                                   UVM_ALL_ON)
        `uvm_field_int(wmb_bytes,                                      UVM_ALL_ON)
        `uvm_field_enum(mean_format_t,            mean_format,         UVM_ALL_ON)
        `uvm_field_int(mean_ry,                                        UVM_ALL_ON)
        `uvm_field_int(mean_gu,                                        UVM_ALL_ON)
        `uvm_field_int(mean_bv,                                        UVM_ALL_ON)
        `uvm_field_int(mean_ax,                                        UVM_ALL_ON)
        `uvm_field_enum(cvt_en_t,                 cvt_en,              UVM_ALL_ON)
        `uvm_field_int(cvt_truncate,                                   UVM_ALL_ON)
        `uvm_field_int(cvt_offset,                                     UVM_ALL_ON)
        `uvm_field_int(cvt_scale,                                      UVM_ALL_ON)
        `uvm_field_int(conv_x_stride,                                  UVM_ALL_ON)
        `uvm_field_int(conv_y_stride,                                  UVM_ALL_ON)
        `uvm_field_int(pad_left,                                       UVM_ALL_ON)
        `uvm_field_int(pad_right,                                      UVM_ALL_ON)
        `uvm_field_int(pad_top,                                        UVM_ALL_ON)
        `uvm_field_int(pad_bottom,                                     UVM_ALL_ON)
        `uvm_field_int(pad_value,                                      UVM_ALL_ON)
        `uvm_field_int(data_bank,                                      UVM_ALL_ON)
        `uvm_field_int(weight_bank,                                    UVM_ALL_ON)
        `uvm_field_enum(nan_to_zero_t,            nan_to_zero,         UVM_ALL_ON)
        `uvm_field_int(dma_en,                                         UVM_ALL_ON)
        `uvm_field_int(cya,                                            UVM_ALL_ON)
        //:) epython: generated_end (DO NOT EDIT ABOVE)
    `uvm_component_utils_end

    /*
        Methods
    */
    extern function         new(string name="nvdla_cdma_resource", uvm_component parent);
    extern static function  nvdla_cdma_resource get_cdma(uvm_component parent);
    extern function void    set_sync_evt_name(string sync_evt_name);
    extern function void    trace_dump(int fh);
    extern function void    set_mem_addr();
    extern function void    surface_dump(int fh);
    extern function void    set_register();
    extern function void    record_rand_variable();
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
    extern constraint c_ias_precision_cvt;
    extern constraint c_ias_atomic_setting;
    extern constraint c_ias_work_mode;
    extern constraint c_ias_pixel;
    extern constraint c_ias_datain_winograd;
    extern constraint c_ias_datain_direct;
    extern constraint c_ias_stride_size;
    extern constraint c_ias_reserved_linear;
    extern constraint c_ias_pack_mode;
    extern constraint c_ias_multi_batch;
    extern constraint c_ias_grains;
    extern constraint c_ias_weight_data;
    extern constraint c_ias_entries;
    extern constraint c_ias_cvt;
    extern constraint c_ias_pad_size;
    extern constraint c_ias_bank_size;
    extern constraint c_ias_reuse_mode;
    extern constraint c_ias_dataout;
    extern constraint c_ias_conv_stride;
    extern constraint c_ias_reuse_keep_previouse_setting;
    extern constraint c_ias_dut_por_requirement;
    extern constraint c_ias_cbuf_size_limit_por_requirement;
    // sim constraint
    extern constraint c_sim_feature_none_zero_rate;
    extern constraint c_sim_datain_dist;
    extern constraint c_sim_grain_dist;
    extern constraint c_sim_reserved_linear_dist;
    extern constraint c_sim_weight_dist;
    extern constraint c_sim_mean_dist;
    extern constraint c_sim_cvt_dist;
    extern constraint c_sim_pad_dist;
    extern constraint c_sim_input_cube_size_small;
    extern constraint c_sim_input_cube_size_medium;
    extern constraint c_sim_input_cube_size_large;
    extern constraint c_sim_input_cube_size_normal;
    extern constraint c_sim_solve_height_before_width;
    extern constraint c_sim_solve_channel_before_width;

endclass : nvdla_cdma_resource

function nvdla_cdma_resource::new(string name="nvdla_cdma_resource", uvm_component parent);
    super.new(name, parent);
    `uvm_info(inst_name, $sformatf("Initialize resource %s ... ",inst_name),UVM_LOW);
endfunction: new

static function  nvdla_cdma_resource nvdla_cdma_resource::get_cdma(uvm_component parent);
    if (null == inst) begin
        inst = new("NVDLA_CDMA", parent);
    end
    return inst;
endfunction: get_cdma

function void nvdla_cdma_resource::set_sync_evt_name(string sync_evt_name);
    string data_sync_evt_name = $sformatf("%s__cdma_data_done_%0d", sync_evt_name, group_to_use);
    string weight_sync_evt_name = $sformatf("%s__cdma_weight_done_%0d", sync_evt_name, group_to_use);

    data_sync_evt_queue[-2:0] = {data_sync_evt_queue[-1:0], data_sync_evt_name};
    weight_sync_evt_queue[-2:0] = {weight_sync_evt_queue[-1:0], weight_sync_evt_name};
endfunction: set_sync_evt_name

function void nvdla_cdma_resource::trace_dump(int fh);
    if(fh==null) begin
        `uvm_fatal(inst_name, "Null handle of trace file ...")
    end
    `uvm_info(inst_name, "Start trace dumping ...", UVM_HIGH)
    if(0 == get_active_cnt()) begin
        // The first CC layer after reset, wait CBUF flush
        poll_reg_equal(fh, "NVDLA_CDMA.S_CBUF_FLUSH_STATUS", 1);
    end
    surface_dump(fh);
    // if both groups have been used, resource must wait for the same group released
    if (get_active_cnt() >= 2) begin
        // There are two interrupt events needs to be waited
        //   Data done interrupt
        //   Weight done interrupt
        sync_wait(fh,inst_name, data_sync_evt_queue[-2]);
        sync_wait(fh,inst_name, weight_sync_evt_queue[-2]);
    end

    reg_write(fh,"NVDLA_CDMA.S_POINTER",group_to_use);

    begin
        uvm_reg        reg_q[$];
        uvm_reg_data_t val;
        uvm_status_e   status;

        ral.nvdla.NVDLA_CDMA.get_registers(reg_q);
        reg_q.shuffle();
        foreach(reg_q[i]) begin
            if(reg_q[i].get_rights() != "RW") begin
                continue;
            end
            case(reg_q[i].get_name())
                "D_OP_ENABLE",
                "S_POINTER": ;
                default: reg_write(fh,{"NVDLA_CDMA.",reg_q[i].get_name()},int'(reg_q[i].get()));
            endcase
        end
    end
    ral.nvdla.NVDLA_CDMA.D_OP_ENABLE.set(1);
    // Make sure CSC enable is always before CDMA
    begin
        nvdla_cc_dp_resource cc_dp = nvdla_cc_dp_resource::get_cc_dp(this);
        sync_wait(fh, "NVDLA_CDMA", cc_dp.get_csc_enabled_event_name());
    end
    reg_write(fh,"NVDLA_CDMA.D_OP_ENABLE",1);

    // Wait interrupt and then trigger interrupt sync events.
    intr_notify(fh,$sformatf("CDMA_DAT_%0d", group_to_use), data_sync_evt_queue[0]);
    intr_notify(fh,$sformatf("CDMA_WT_%0d" , group_to_use), weight_sync_evt_queue[0]);
    `uvm_info(inst_name, "Finish trace dumping ...", UVM_HIGH)
endfunction : trace_dump

function void nvdla_cdma_resource::surface_dump(int fh);
    if(data_reuse_DISABLE == data_reuse) begin
        if(datain_format_FEATURE == datain_format) begin
            surface_feature_config feature_cfg;
            longint unsigned address;
            string           mem_domain_input;

            // Get surface setting from resource register
            // string name;
            // int unsigned width; int unsigned height;int unsigned channel; int unsigned batch;
            // int unsigned line_stride; int unsigned surface_stride; int unsigned batch_stride=1;
            // int unsigned atomic_memory=8; int unsigned component_per_element=1;
            // precision_e precision=INT8;
            // string pattern="random";

            address = {datain_addr_high_0, datain_addr_low_0};
            $sformat(feature_cfg.name, "0x%0h.dat", address);
            mem_domain_input = (datain_ram_type_MCIF==datain_ram_type) ? "pri_mem":"sec_mem";
            feature_cfg.width   = datain_width+1;
            feature_cfg.height  = datain_height+1;
            feature_cfg.channel = datain_channel+1;
            feature_cfg.line_stride = line_stride;
            feature_cfg.surface_stride = surf_stride;
            feature_cfg.atomic_memory = `NVDLA_MEMORY_ATOMIC_SIZE;
            feature_cfg.precision = precision_e'(in_precision);
            feature_cfg.pattern = cdma_feature_surface_pattern;
            surface_gen.generate_memory_surface_feature(feature_cfg);
            mem_load(fh, mem_domain_input,address,feature_cfg.name,data_sync_evt_queue[-2]);
            mem_release(fh, mem_domain_input,address,data_sync_evt_queue[ 0]);
        end else if (datain_format_PIXEL == datain_format) begin
            if(pixel_mapping_PITCH_LINEAR == pixel_mapping) begin
                surface_image_pitch_config surface_cfg;
                longint unsigned address_0, address_1;
                string           mem_domain_input;
                // Get surface setting fro resource register
                // string name;
                // int unsigned width=1; int unsigned height=1;int unsigned channel=1;
                // int unsigned line_stride_0; int unsigned line_stride_1;
                // int unsigned atomic_memory=8; int unsigned offset_x=0;
                // precision_e precision=INT8;
                // string pixel_format_name="T_A8R8G8B8";
                // string pattern="random";
                // int unsigned none_zero_rate=100;
                // int unsigned fp_nan_enabled=1; int unsigned fp_inf_enabled=1;

                address_0 = {datain_addr_high_0, datain_addr_low_0};
                address_1 = {datain_addr_high_1, datain_addr_low_1};
                $sformat(surface_cfg.name, "0x%0h.dat,0x%0h.dat", address_0, address_1);
                mem_domain_input = (datain_ram_type_MCIF==datain_ram_type) ? "pri_mem":"sec_mem";
                surface_cfg.width   = datain_width+1;
                surface_cfg.height  = datain_height+1;
                surface_cfg.channel = datain_channel+1;
                surface_cfg.line_stride_0 = line_stride;
                surface_cfg.line_stride_1 = uv_line_stride;
                surface_cfg.atomic_memory = `NVDLA_MEMORY_ATOMIC_SIZE;
                surface_cfg.offset_x = pixel_x_offset;
                surface_cfg.precision = precision_e'(in_precision);
                surface_cfg.pixel_format_name = pixel_format.name().substr(12,pixel_format.name().len()-1);
                // `uvm_info(inst_name, {"pixel_format.name ", pixel_format.name, " surface_cfg.pixel_format_name ", surface_cfg.pixel_format_name}, UVM_NONE)
                surface_cfg.pattern = cdma_feature_surface_pattern;
                surface_gen.generate_memory_surface_image_pitch(surface_cfg);
                mem_load(fh, mem_domain_input,address_0,$sformatf("0x%0h.dat", address_0),data_sync_evt_queue[-2]);
                mem_release(fh, mem_domain_input,address_0,data_sync_evt_queue[ 0]);
                if (plane_number > 1) begin
                    mem_load(fh, mem_domain_input,address_1,$sformatf("0x%0h.dat", address_1),data_sync_evt_queue[-2]);
                    mem_release(fh, mem_domain_input,address_1,data_sync_evt_queue[ 0]);
                end
            end
        end
    end
endfunction: surface_dump

constraint nvdla_cdma_resource::c_ias_stride_alignment {
    // ATOMIC SIZE alignment
    line_stride    % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    uv_line_stride % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    surf_stride    % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
    batch_stride   % `NVDLA_MEMORY_ATOMIC_SIZE == 0;
}

constraint nvdla_cdma_resource::c_ias_precision_cvt {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    if(datain_format == datain_format_PIXEL) {
        !(in_precision == in_precision_FP16 && (proc_precision == proc_precision_INT8 || proc_precision == proc_precision_INT16));
    }
`endif
    if(datain_format == datain_format_FEATURE) {
        in_precision == in_precision_t'(proc_precision);
    }
}

constraint nvdla_cdma_resource::c_ias_atomic_setting {
    if(in_precision == in_precision_INT8) {
        atomic_m == `NVDLA_MEMORY_ATOMIC_SIZE;
        atomic_c == `NVDLA_MAC_ATOMIC_C_SIZE;
        atomic_e == NVDLA_CBUF_ENTRY_BYTE_WIDTH;
    }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    if(in_precision == in_precision_INT16) {
        // TODO, current NVDLA_MEMORY_ATOMIC_SIZE and NVDLA_MAC_ATOMIC_C_SIZE are for INT8 only
        atomic_m == `NVDLA_MEMORY_ATOMIC_SIZE/2;
        atomic_c == `NVDLA_MAC_ATOMIC_C_SIZE/2;
        atomic_e == NVDLA_CBUF_ENTRY_BYTE_WIDTH/2;
    }

    if(in_precision == in_precision_FP16) {
        // TODO, current NVDLA_MEMORY_ATOMIC_SIZE and NVDLA_MAC_ATOMIC_C_SIZE are for INT8 only
        atomic_m == `NVDLA_MEMORY_ATOMIC_SIZE/2;
        atomic_c == `NVDLA_MAC_ATOMIC_C_SIZE/2;
        atomic_e == NVDLA_CBUF_ENTRY_BYTE_WIDTH/2;
    }
`endif
    (atomic_e2m == atomic_e/atomic_m);
    (n_atomic_m == (datain_channel + atomic_m)/atomic_m);
}

constraint nvdla_cdma_resource::c_ias_work_mode {
    !(conv_mode == conv_mode_WINOGRAD && datain_format == datain_format_PIXEL);
}

constraint nvdla_cdma_resource::c_ias_pixel {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT8
    pixel_format inside {
        pixel_format_T_R8
       ,pixel_format_T_A8B8G8R8
       ,pixel_format_T_A8R8G8B8
       ,pixel_format_T_B8G8R8A8
       ,pixel_format_T_R8G8B8A8
       ,pixel_format_T_X8B8G8R8
       ,pixel_format_T_X8R8G8B8
       ,pixel_format_T_B8G8R8X8
       ,pixel_format_T_R8G8B8X8
       ,pixel_format_T_A8Y8U8V8
       ,pixel_format_T_V8U8Y8A8
       ,pixel_format_T_Y8___U8V8_N444
       ,pixel_format_T_Y8___V8U8_N444
    };
`endif

    if(conv_mode == conv_mode_DIRECT && datain_format == datain_format_PIXEL){
        (pixel_format == pixel_format_T_R8)                -> {(datain_channel+1) == 1; in_precision == in_precision_INT8;  element_byte_size_plane_0 == 1; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
        (pixel_format == pixel_format_T_R10)               -> {(datain_channel+1) == 1; in_precision == in_precision_INT16; element_byte_size_plane_0 == 2; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_R12)               -> {(datain_channel+1) == 1; in_precision == in_precision_INT16; element_byte_size_plane_0 == 2; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_R16)               -> {(datain_channel+1) == 1; in_precision == in_precision_INT16; element_byte_size_plane_0 == 2; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_R16_I)             -> {(datain_channel+1) == 1; in_precision == in_precision_INT16; element_byte_size_plane_0 == 2; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0; pixel_sign_override == pixel_sign_override_SIGNED_INT;}
        (pixel_format == pixel_format_T_R16_F)             -> {(datain_channel+1) == 1; in_precision == in_precision_FP16;  element_byte_size_plane_0 == 2; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_A16B16G16R16)      -> {(datain_channel+1) == 4; in_precision == in_precision_INT16; element_byte_size_plane_0 == 8; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_X16B16G16R16)      -> {(datain_channel+1) == 4; in_precision == in_precision_INT16; element_byte_size_plane_0 == 8; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_A16B16G16R16_F)    -> {(datain_channel+1) == 4; in_precision == in_precision_FP16;  element_byte_size_plane_0 == 8; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_A16Y16U16V16)      -> {(datain_channel+1) == 4; in_precision == in_precision_INT16; element_byte_size_plane_0 == 8; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_V16U16Y16A16)      -> {(datain_channel+1) == 4; in_precision == in_precision_INT16; element_byte_size_plane_0 == 8; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_A16Y16U16V16_F)    -> {(datain_channel+1) == 4; in_precision == in_precision_FP16;  element_byte_size_plane_0 == 8; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
`endif
        (pixel_format == pixel_format_T_A8B8G8R8)          -> {(datain_channel+1) == 4; in_precision == in_precision_INT8;  element_byte_size_plane_0 == 4; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_A8R8G8B8)          -> {(datain_channel+1) == 4; in_precision == in_precision_INT8;  element_byte_size_plane_0 == 4; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_B8G8R8A8)          -> {(datain_channel+1) == 4; in_precision == in_precision_INT8;  element_byte_size_plane_0 == 4; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_R8G8B8A8)          -> {(datain_channel+1) == 4; in_precision == in_precision_INT8;  element_byte_size_plane_0 == 4; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_X8B8G8R8)          -> {(datain_channel+1) == 4; in_precision == in_precision_INT8;  element_byte_size_plane_0 == 4; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_X8R8G8B8)          -> {(datain_channel+1) == 4; in_precision == in_precision_INT8;  element_byte_size_plane_0 == 4; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_B8G8R8X8)          -> {(datain_channel+1) == 4; in_precision == in_precision_INT8;  element_byte_size_plane_0 == 4; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_R8G8B8X8)          -> {(datain_channel+1) == 4; in_precision == in_precision_INT8;  element_byte_size_plane_0 == 4; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
        (pixel_format == pixel_format_T_A2B10G10R10)       -> {(datain_channel+1) == 4; in_precision == in_precision_INT16; element_byte_size_plane_0 == 4; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_A2R10G10B10)       -> {(datain_channel+1) == 4; in_precision == in_precision_INT16; element_byte_size_plane_0 == 4; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_B10G10R10A2)       -> {(datain_channel+1) == 4; in_precision == in_precision_INT16; element_byte_size_plane_0 == 4; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_R10G10B10A2)       -> {(datain_channel+1) == 4; in_precision == in_precision_INT16; element_byte_size_plane_0 == 4; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_A2Y10U10V10)       -> {(datain_channel+1) == 4; in_precision == in_precision_INT16; element_byte_size_plane_0 == 4; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_V10U10Y10A2)       -> {(datain_channel+1) == 4; in_precision == in_precision_INT16; element_byte_size_plane_0 == 4; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
`endif
        (pixel_format == pixel_format_T_A8Y8U8V8)          -> {(datain_channel+1) == 4; in_precision == in_precision_INT8;  element_byte_size_plane_0 == 4; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_V8U8Y8A8)          -> {(datain_channel+1) == 4; in_precision == in_precision_INT8;  element_byte_size_plane_0 == 4; element_byte_size_plane_1 == 0; plane_number == 1; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_Y8___U8V8_N444)    -> {(datain_channel+1) == 3; in_precision == in_precision_INT8;  element_byte_size_plane_0 == 1; element_byte_size_plane_1 == 2; plane_number == 2; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_Y8___V8U8_N444)    -> {(datain_channel+1) == 3; in_precision == in_precision_INT8;  element_byte_size_plane_0 == 1; element_byte_size_plane_1 == 2; plane_number == 2; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
        (pixel_format == pixel_format_T_Y10___U10V10_N444) -> {(datain_channel+1) == 3; in_precision == in_precision_INT16; element_byte_size_plane_0 == 2; element_byte_size_plane_1 == 4; plane_number == 2; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_Y10___V10U10_N444) -> {(datain_channel+1) == 3; in_precision == in_precision_INT16; element_byte_size_plane_0 == 2; element_byte_size_plane_1 == 4; plane_number == 2; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_Y12___U12V12_N444) -> {(datain_channel+1) == 3; in_precision == in_precision_INT16; element_byte_size_plane_0 == 2; element_byte_size_plane_1 == 4; plane_number == 2; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_Y12___V12U12_N444) -> {(datain_channel+1) == 3; in_precision == in_precision_INT16; element_byte_size_plane_0 == 2; element_byte_size_plane_1 == 4; plane_number == 2; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_Y16___U16V16_N444) -> {(datain_channel+1) == 3; in_precision == in_precision_INT16; element_byte_size_plane_0 == 2; element_byte_size_plane_1 == 4; plane_number == 2; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
        (pixel_format == pixel_format_T_Y16___V16U16_N444) -> {(datain_channel+1) == 3; in_precision == in_precision_INT16; element_byte_size_plane_0 == 2; element_byte_size_plane_1 == 4; plane_number == 2; pixel_x_offset < `NVDLA_MEMORY_ATOMIC_SIZE/element_byte_size_plane_0;}
`endif
    }
    if(datain_format == datain_format_PIXEL && pixel_mapping == pixel_mapping_PITCH_LINEAR) {
        pixel_y_offset == 0;
    }
}

constraint nvdla_cdma_resource::c_ias_datain_winograd {
`ifdef NVDLA_WINOGRAD_ENABLE
    if(conv_mode == conv_mode_WINOGRAD) {
        (datain_width_ext+1)   == (pad_left + pad_right + datain_width+1)  / (conv_x_stride+1);
        (datain_height_ext+1)  == (pad_top + pad_bottom + datain_height+1) / (conv_y_stride+1);

        (pad_left + pad_right + datain_width+1) % (conv_x_stride+1)  == 0;
        (pad_top + pad_bottom + datain_height+1) % (conv_y_stride+1) == 0;

        (datain_width_ext+1)  % 4 == 0;
        (datain_height_ext+1) % 4 == 0;
        (datain_width_ext+1)  > 4;
        (datain_height_ext+1) > 4;

        (datain_channel+1) % atomic_m == 0;
    }
`endif
}
constraint nvdla_cdma_resource::c_ias_datain_direct {
    if(conv_mode == conv_mode_DIRECT && datain_format == datain_format_FEATURE){
    // move to sce layer
    }

    if(conv_mode == conv_mode_DIRECT && datain_format == datain_format_PIXEL){
    // move to sce layer
    }
}

constraint nvdla_cdma_resource::c_ias_stride_size {
    if(datain_format == datain_format_FEATURE) {
        (line_stride - (datain_width+64'h1)*`NVDLA_MEMORY_ATOMIC_SIZE)/`NVDLA_MEMORY_ATOMIC_SIZE dist { 0:=30, ['h1:'hF]:=45, ['h10:'h7F]:=20, ['h80:'hFF]:=5};
        (line_stride/`NVDLA_MEMORY_ATOMIC_SIZE >= (datain_width+64'h1));
        (surf_stride - line_stride*(datain_height+1))/`NVDLA_MEMORY_ATOMIC_SIZE dist { 0:=45, ['h1:'hF]:=45, ['h10:'h7F]:=5, ['h80:'hFF]:=5};

        // Total size shall be less then 16 MiB
        if(batches == 0) {
            if(in_precision==in_precision_INT8) {
                surf_stride * ((datain_channel+`NVDLA_MEMORY_ATOMIC_SIZE) /`NVDLA_MEMORY_ATOMIC_SIZE) <= 64'h800_0000;
            }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            else {
                surf_stride * ((datain_channel+1+15) /16) <= 64'h800_0000;
            }
`endif
        }
    }
    else if(pixel_mapping==pixel_mapping_RESERVED_LINEAR) {
        // line_stride don't care
    }
    else if(pixel_mapping==pixel_mapping_PITCH_LINEAR) {
        // semi-planar, line_stride is used to address Y planar
        if((pixel_format >= pixel_format_T_A2B10G10R10) && (pixel_format <= pixel_format_T_V10U10Y10A2) ) {
            (line_stride - (pixel_x_offset+datain_width+64'h1)*(datain_channel+1))/`NVDLA_MEMORY_ATOMIC_SIZE dist { 0:=48, ['h1:'hF]:=48, ['h10:'h7F]:=2, ['h80:'hFF]:=2};
            (line_stride >= (pixel_x_offset+datain_width+64'h1)*(datain_channel+1));
        }
        else if(pixel_format >= pixel_format_T_Y8___U8V8_N444) { // semi-planar
            (line_stride - (pixel_x_offset+datain_width+64'h1)*(`NVDLA_BPE/8))/`NVDLA_MEMORY_ATOMIC_SIZE dist { 0:=48, ['h1:'hF]:=48, ['h10:'h7F]:=2, ['h80:'hFF]:=2};
            (line_stride >= (pixel_x_offset+datain_width+64'h1)*(`NVDLA_BPE/8));
            // Semi-planar, add contraint to the second surface
            // line_uv_stride only valide in semi-planar mode && pitch linear
            uv_line_stride * (datain_height + 1) / `NVDLA_MEMORY_ATOMIC_SIZE <= 64'h800_0000;
            uv_line_stride == (line_stride * 2);
        }
        else {
            (line_stride - (pixel_x_offset+datain_width+64'h1)*(`NVDLA_BPE/8)*(datain_channel+1))/`NVDLA_MEMORY_ATOMIC_SIZE dist { 0:=48, ['h1:'hF]:=48, ['h10:'h7F]:=2, ['h80:'hFF]:=2};
            (line_stride >= (pixel_x_offset+datain_width+64'h1)*(`NVDLA_BPE/8)*(datain_channel+1));
        }
        line_stride * (datain_height + 1) / `NVDLA_MEMORY_ATOMIC_SIZE <= 64'h800_0000;
    }
}

constraint nvdla_cdma_resource::c_ias_reserved_linear {
    if(datain_format == datain_format_PIXEL && pixel_mapping == pixel_mapping_RESERVED_LINEAR) {
        datain_addr_low_0[2:0] == 3'b0;
        if(pixel_format >= pixel_format_T_Y8___U8V8_N444) { // semi-planar
            datain_addr_low_1[2:0] == 3'b0;
        }
    }
}

constraint nvdla_cdma_resource::c_ias_pack_mode {
    // Only work in feature format
    if(datain_format == datain_format_FEATURE && ((datain_width+1)*`NVDLA_MEMORY_ATOMIC_SIZE==line_stride)) { line_packed == line_packed_TRUE; }
    else { line_packed == line_packed_FALSE; }
    if(datain_format == datain_format_FEATURE && ((datain_height+1)*(datain_width+1)*`NVDLA_MEMORY_ATOMIC_SIZE==surf_stride)) { surf_packed == surf_packed_TRUE; }
    else { surf_packed == surf_packed_FALSE; }
}

constraint nvdla_cdma_resource::c_ias_multi_batch {
    if(conv_mode == conv_mode_DIRECT && datain_format == datain_format_FEATURE) {
`ifdef NVDLA_BATCH_ENABLE
        if(batches > 0) {
            batch_stride * batches <= 64'h100_0000;
            (batch_stride >= surf_stride*((datain_channel+1-1)/atomic_m + 64'h1));
            (batch_stride - surf_stride*((datain_channel+1-1)/atomic_m + 64'h1))/32 dist { 24'h0:=40, [24'h1:24'hF]:=50, [24'h10:24'hFF]:=10, [24'h100:24'hFF_FFFF]:=0 };
        }
`endif
    }
    else { batches == 0; }
}

constraint nvdla_cdma_resource::c_ias_dataout {
    if(conv_mode == conv_mode_DIRECT && datain_format == datain_format_FEATURE){
        // move to sce layer
    }
    else if(conv_mode == conv_mode_DIRECT && datain_format == datain_format_PIXEL){
        // move to sce layer
    }
}

constraint nvdla_cdma_resource::c_ias_entries {
    // entries per slice (Wx1xC)
    // 256 entries per bank
    if(datain_format == datain_format_PIXEL) {
        (entries+1) == ((datain_width+1 + pad_left + pad_right)*(datain_channel+1)+atomic_e-1) / atomic_e;
    }
    else {  // feature
        if(conv_mode == conv_mode_DIRECT) {
            // N_m:  how many atomic_m in channel dimension: (channel + ATOMIC_M - 1) // ATOMIC_M == ((datain_channel + atomic_m)/atomic_m)
            // AE_m: how many atomic_m could be accomondated in one entry: ATOMIC_ENTRY // ATOMIC_M  == (atomic_e/atomic_m)
            // sharing_factor: AE_m/(N_m%AE_m) == (atomic_e2m/(n_atomic_m%atomic_e2m)) == ((atomic_e/atomic_m)/(((datain_channel + atomic_m)/atomic_m)%(atomic_e/atomic_m)))
            // entry_per_slice : quotient_part + remainder_part
            //     quotient_part:    N_m // AE_m * width
            //     remainder_part:
            //                      1. if N_m % AE_m == 0: 0
            //                      2. if N_m % AE_m != 0: ((width+sharing_factor-1) // sharing_factor) == (datain_width+((atomic_e/atomic_m)/(((datain_channel + atomic_m)/atomic_m)%(atomic_e/atomic_m)))/((atomic_e/atomic_m)/(((datain_channel + atomic_m)/atomic_m)%(atomic_e/atomic_m))))
            if( (0 == n_atomic_m%atomic_e2m) || (1 == atomic_e2m) ) {
                (entries+1) == n_atomic_m/atomic_e2m * (datain_width+1);
            } else {
                (entries+1) == n_atomic_m/atomic_e2m * (datain_width+1) + (datain_width+(atomic_e2m/(n_atomic_m%atomic_e2m)))/(atomic_e2m/(n_atomic_m%atomic_e2m)) ;
            }
        }
        else { // winograd
            (entries+1) == (((datain_width+1+pad_left+pad_right) / (4*(conv_x_stride+1)))*((((datain_channel+1) + atomic_m-1) / atomic_m)*(conv_x_stride+1)*(conv_y_stride+1)));
        }
    }
}

constraint nvdla_cdma_resource::c_ias_grains {
    if(line_packed == line_packed_FALSE) {
        grains == 0;
    }
    else {
        grains <= datain_height;
    }
}

constraint nvdla_cdma_resource::c_ias_weight_data {
    if(conv_mode == conv_mode_DIRECT && datain_format == datain_format_PIXEL){
        // move to sce layer
    }
    else if(conv_mode == conv_mode_DIRECT && datain_format == datain_format_FEATURE){
        // move to sce layer
    }
}

constraint nvdla_cdma_resource::c_ias_cvt {
    if(datain_format == datain_format_PIXEL) {
`ifdef PRECISION_CONVERSION_ENABLE
        if(in_precision != in_precision_t'(proc_precision)) {
            cvt_en == cvt_en_ENABLE;
        }
`endif
        if(pixel_sign_override == pixel_sign_override_UNSIGNED_INT) {
            cvt_en == cvt_en_ENABLE;
        }
    }
    if(in_precision != in_precision_FP16) {
        cvt_truncate inside {[0:34]};
    }

    // pad_value, [7:0] for int8, [15:8] don't care in int8, [15:0] for int16/fp16
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
    if((in_precision == in_precision_FP16) && (proc_precision == proc_precision_FP16)) {
        pad_value     == 0;
        cvt_en        == cvt_en_DISABLE;
    }
    else if((in_precision != in_precision_FP16) && (proc_precision == proc_precision_FP16)) {
        cvt_en        == cvt_en_ENABLE;
        cvt_offset    == 0;
        pad_value     == 0;
    }
`endif
`ifdef NVDLA_WINOGRAD_ENABLE
    if(conv_mode == conv_mode_WINOGRAD) {
        cvt_en   == cvt_en_DISABLE;
    }
`endif
}

constraint nvdla_cdma_resource::c_ias_pad_size {
    // bug 200291495
    if (conv_mode == conv_mode_DIRECT) {  // DC or Image
        // In image input mode, x_dilation_ext = y_dilation_ext = 0
        if(datain_format == datain_format_PIXEL) {
            // move to sce layer
        }
        else { // feature
            // move to sce layer
        }
    }
`ifdef NVDLA_WINOGRAD_ENABLE
    else { // Winograd
        pad_left < 3*(conv_x_stride+1);
        pad_top  < 3*(conv_y_stride+1);
        ((conv_x_stride+1) == 1) -> { pad_left <= 1;}
        ((conv_y_stride+1) == 1) -> { pad_top  <= 1;}
    }
`endif
}

constraint nvdla_cdma_resource::c_ias_bank_size {
    // data_bank assignment is not allowed to be changed when data reuse is set
    if((datain_format == datain_format_PIXEL) || (conv_mode == conv_mode_DIRECT &&  datain_format == datain_format_FEATURE)) {
        (data_bank+1) >= ((entries+1)*(datain_height+1)*(batches+1) + `NVDLA_CBUF_BANK_DEPTH - 1) / `NVDLA_CBUF_BANK_DEPTH;
    }
    else {
        (data_bank+1) >= ((entries+1)*(datain_height_ext+1)*(batches+1) + `NVDLA_CBUF_BANK_DEPTH - 1) / `NVDLA_CBUF_BANK_DEPTH;
    }
    if(weight_format == weight_format_COMPRESSED) {
        // one bank for WMB
        (data_bank+1) + (weight_bank+1) <= `NVDLA_CBUF_BANK_NUMBER - 1;
    }
    else {
        (data_bank+1) + (weight_bank+1) <= `NVDLA_CBUF_BANK_NUMBER;
    }
}

constraint nvdla_cdma_resource::c_ias_reuse_mode {
    // 3 Mode:
    // weight_bank > total_weight_bank: full weight mode
    // weight_bank > 2*min_weight_bank: ping-pong weight mode
    // weight_bank > min_weight_bank: normal weight mode
    // total_weight_banks = ((((weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1)*(`NVDLA_BPE/8)*(weight_kernel+1)+127) / 128 ) + 255) / 256;
    // min_weight_banks = ((((weight_width_ext+1)*(weight_height_ext+1)*(weight_channel_ext+1)*(`NVDLA_BPE/8)*kernel_per_group+127) / 128) + 255) / 256;
    // bug 200312556, weiht bank must be able to hold one max kernel group + 128 bytes

    /* REUSE mode cfg
     *   Layer       | Pre         | Cur
     *   Data/Weight | release     | not_reuse
     *   Data/Weight | not_release | reuse
     *   Data/Weight | NULL        | not_reuse
     */
    if (prev_skip_data_rls == skip_data_rls_DISABLE || get_active_cnt() == 0) {
        data_reuse == data_reuse_DISABLE;
    }
    else if (prev_skip_data_rls == skip_data_rls_ENABLE) {
        data_reuse == data_reuse_ENABLE;
    }

    if (prev_skip_weight_rls == skip_weight_rls_DISABLE || get_active_cnt() == 0) {
        weight_reuse == weight_reuse_DISABLE;
    }
    else if (prev_skip_weight_rls == skip_weight_rls_ENABLE) {
        weight_reuse == weight_reuse_ENABLE;
    }

    // if(skip_data_rls == skip_data_rls_DISABLE) {
    //     (datain_height+1 + pad_top + pad_bottom)*(entries+1) <= (data_bank+1) * 256;
    // }
}

constraint nvdla_cdma_resource::c_ias_conv_stride {
    // move to sce layer
}

constraint nvdla_cdma_resource::c_ias_reuse_keep_previouse_setting {
    if(data_reuse == data_reuse_ENABLE) {
        conv_mode           == prev_conv_mode;
        in_precision        == prev_in_precision;
        proc_precision      == prev_proc_precision;
        datain_format       == prev_datain_format;
        pixel_format        == prev_pixel_format;
        pixel_mapping       == prev_pixel_mapping;
        pixel_sign_override == prev_pixel_sign_override;
        datain_width        == prev_datain_width;
        datain_height       == prev_datain_height;
        datain_channel      == prev_datain_channel;
        datain_width_ext    == prev_datain_width_ext;
        datain_height_ext   == prev_datain_height_ext;
        pixel_x_offset      == prev_pixel_x_offset;
        pixel_y_offset      == prev_pixel_y_offset;
        datain_ram_type     == prev_datain_ram_type;
        datain_addr_high_0  == prev_datain_addr_high_0;
        datain_addr_low_0   == prev_datain_addr_low_0;
        datain_addr_high_1  == prev_datain_addr_high_1;
        datain_addr_low_1   == prev_datain_addr_low_1;
        line_stride         == prev_line_stride;
        uv_line_stride      == prev_uv_line_stride;
        surf_stride         == prev_surf_stride;
        line_packed         == prev_line_packed;
        surf_packed         == prev_surf_packed;
        batches             == prev_batches;
        batch_stride        == prev_batch_stride;
        entries             == prev_entries;
        //grains            ==
        weight_format       == prev_weight_format;
        byte_per_kernel     == prev_byte_per_kernel;
        //weight_kernel     ==
        weight_ram_type     == prev_weight_ram_type;
        //weight_addr_high  ==
        //weight_addr_low   ==
        //weight_bytes      ==
        //wgs_addr_high     ==
        //wgs_addr_low      ==
        //wmb_addr_high     ==
        //wmb_addr_low      ==
        //wmb_bytes         ==
        mean_format         == prev_mean_format;
        //mean_ry           ==
        //mean_gu           ==
        //mean_bv           ==
        //mean_ax           ==
        cvt_en              == prev_cvt_en;
        cvt_truncate        == prev_cvt_truncate;
        cvt_offset          == prev_cvt_offset;
        cvt_scale           == prev_cvt_scale;
        conv_x_stride       == prev_conv_x_stride;
        conv_y_stride       == prev_conv_y_stride;
        pad_left            == prev_pad_left;
        pad_right           == prev_pad_right;
        pad_top             == prev_pad_top;
        pad_bottom          == prev_pad_bottom;
        pad_value           == prev_pad_value;
        data_bank           == prev_data_bank;
        weight_bank         == prev_weight_bank;
        nan_to_zero         == prev_nan_to_zero;
        //cya               ==
        // datain_channel_ext  == prev_datain_channel_ext;
        // y_extension         == prev_y_extension;
        // weight_width_ext    == prev_weight_width_ext;
        // weight_height_ext   == prev_weight_height_ext;
        // weight_channel_ext  == prev_weight_channel_ext;
        //dataout_width     ==
        //dataout_height    ==
        //dataout_channel   ==
        //atomics           ==
        //rls_slices        ==
        // conv_x_stride_ext   == prev_conv_x_stride_ext;
        // conv_y_stride_ext   == prev_conv_y_stride_ext;
        // x_dilation_ext      == prev_x_dilation_ext;
        // y_dilation_ext      == prev_y_dilation_ext;
        //pad_value_csc     ==
        // pra_truncate        == prev_pra_truncate;
        //dataout_addr      ==
        //line_stride_cacc  ==
        //surf_stride_cacc  ==
        // clip_truncate       == prev_clip_truncate;
    }
    if(weight_reuse == weight_reuse_ENABLE) {
        // weight_none_zero_rate == prev_weight_none_zero_rate;
        conv_mode           == prev_conv_mode;
        in_precision        == prev_in_precision;
        proc_precision      == prev_proc_precision;
        datain_format       == prev_datain_format;
        pixel_format        == prev_pixel_format;
        pixel_mapping       == prev_pixel_mapping;
        pixel_sign_override == prev_pixel_sign_override;
        //datain_width        == prev_datain_width;
        //datain_height       == prev_datain_height;
        datain_channel      == prev_datain_channel;
        //datain_width_ext    == prev_datain_width_ext;
        //datain_height_ext   == prev_datain_height_ext;
        pixel_x_offset      == prev_pixel_x_offset;
        pixel_y_offset      == prev_pixel_y_offset;
        datain_ram_type     == prev_datain_ram_type;
        //datain_addr_high_0  == prev_datain_addr_high_0;
        //datain_addr_low_0   == prev_datain_addr_low_0;
        //datain_addr_high_1  == prev_datain_addr_high_1;
        //datain_addr_low_1   == prev_datain_addr_low_1;
        //line_stride         == prev_line_stride;
        //uv_line_stride      == prev_uv_line_stride;
        //surf_stride         == prev_surf_stride;
        //line_packed         == prev_line_packed;
        //surf_packed         == prev_surf_packed;
        //gob_per_line        == prev_gob_per_line;
        //gob_per_uv_line     == prev_gob_per_uv_line;
        //gob_height          == prev_gob_height;
        //gob_y_index         == prev_gob_y_index;
        //batches             == prev_batches;
        //batch_stride        == prev_batch_stride;
        //entries             == prev_entries;
        //grains            ==
        weight_format       == prev_weight_format;
        byte_per_kernel     == prev_byte_per_kernel;
        weight_kernel       == prev_weight_kernel;
        weight_ram_type     == prev_weight_ram_type;
        //weight_addr_high  ==
        //weight_addr_low   ==
        weight_bytes        == prev_weight_bytes;
        //wgs_addr_high     ==
        //wgs_addr_low      ==
        //wmb_addr_high     ==
        //wmb_addr_low      ==
        wmb_bytes           == prev_wmb_bytes;
        mean_format         == prev_mean_format;
        //mean_ry           ==
        //mean_gu           ==
        //mean_bv           ==
        //mean_ax           ==
        cvt_en              == prev_cvt_en;
        cvt_truncate        == prev_cvt_truncate;
        cvt_offset          == prev_cvt_offset;
        cvt_scale           == prev_cvt_scale;
        conv_x_stride       == prev_conv_x_stride;
        conv_y_stride       == prev_conv_y_stride;
        //pad_left            == prev_pad_left;
        //pad_right           == prev_pad_right;
        //pad_top             == prev_pad_top;
        //pad_bottom          == prev_pad_bottom;
        pad_value           == prev_pad_value;
        data_bank           == prev_data_bank;
        weight_bank         == prev_weight_bank;
        //nan_to_zero         == prev_nan_to_zero;
        //cya               ==
        // datain_channel_ext  == prev_datain_channel_ext;
        //y_extension         == prev_y_extension;
        // weight_width_ext    == prev_weight_width_ext;
        // weight_height_ext   == prev_weight_height_ext;
        // weight_channel_ext  == prev_weight_channel_ext;
        //dataout_width     ==
        //dataout_height    ==
        //dataout_channel   ==
        //atomics           ==
        //rls_slices        ==
        // conv_x_stride_ext   == prev_conv_x_stride_ext;
        // conv_y_stride_ext   == prev_conv_y_stride_ext;
        // x_dilation_ext      == prev_x_dilation_ext;
        // y_dilation_ext      == prev_y_dilation_ext;
        //pad_value_csc     ==
        //pra_truncate        == prev_pra_truncate;
        //dataout_addr      ==
        //line_stride_cacc  ==
        //surf_stride_cacc  ==
        //clip_truncate       == prev_clip_truncate;
    }
}

constraint nvdla_cdma_resource::c_ias_dut_por_requirement {
    conv_mode       == conv_mode_DIRECT ;
    in_precision    == in_precision_INT8 ;
    proc_precision  == proc_precision_INT8 ;
    weight_format   == weight_format_UNCOMPRESSED ;
    pixel_mapping   == pixel_mapping_PITCH_LINEAR ;
`ifndef NVDLA_SECONDARY_MEMIF_ENABLE
    datain_ram_type == datain_ram_type_MCIF;
    weight_ram_type == weight_ram_type_MCIF;
`endif
    batches         == 0;
}
constraint nvdla_cdma_resource::c_ias_cbuf_size_limit_por_requirement {
    // input cube size must be no greater than 31 cbuffer bank size
    (datain_width+1)*(datain_height+1)*(datain_channel+1) <= 64'h1f000;
}

// sim constraint
constraint nvdla_cdma_resource::c_sim_feature_none_zero_rate {
    // rate = (value/10000)
    feature_none_zero_rate dist { [0:8999]:=10, [9000:10000]:=90 };
}

constraint nvdla_cdma_resource::c_sim_datain_dist {
    `weight_dist_13bit(datain_width_ext)
    `weight_dist_13bit(datain_height_ext)
    `weight_dist_32bit(line_stride)
    `weight_dist_32bit(surf_stride)
    `weight_dist_5bit(batches)
}

constraint nvdla_cdma_resource::c_sim_grain_dist {
    `weight_dist_12bit(grains)
}

constraint nvdla_cdma_resource::c_sim_reserved_linear_dist {
    `weight_dist_32bit(uv_line_stride)
}

constraint nvdla_cdma_resource::c_sim_weight_dist {
    `weight_dist_18bit(byte_per_kernel)
    `weight_dist_25bit(weight_bytes)
    `weight_dist_21bit(wmb_bytes)
}

constraint nvdla_cdma_resource::c_sim_mean_dist {
    `weight_dist_16bit(mean_ry)
    `weight_dist_16bit(mean_gu)
    `weight_dist_16bit(mean_bv)
    `weight_dist_16bit(mean_ax)
}
constraint nvdla_cdma_resource::c_sim_cvt_dist {
    `weight_dist_6bit(cvt_truncate)
    `weight_dist_16bit(cvt_offset)
    `weight_dist_16bit(cvt_scale)
}
constraint nvdla_cdma_resource::c_sim_pad_dist {
    `weight_dist_5bit(pad_left)
    `weight_dist_6bit(pad_right)
    `weight_dist_5bit(pad_top)
    `weight_dist_6bit(pad_bottom)
    `weight_dist_16bit(pad_value)
}

constraint nvdla_cdma_resource::c_sim_input_cube_size_small {
    datain_width   inside {[0:'h1F]};
    datain_height  inside {[0:'h1F]};
    datain_channel inside {[0:'h1F]};
    (datain_width+1)*(datain_height+1)*(datain_channel+1)    <= 64'h8000;
}

constraint nvdla_cdma_resource::c_sim_input_cube_size_medium {
    datain_width   inside {[0:'h7F]};
    datain_height  inside {[0:'h7F]};
    datain_channel inside {[0:'h7F]};
    if (conv_mode == conv_mode_DIRECT && datain_format == datain_format_PIXEL) {
        // datain_channel = 0
        (datain_width+1)*(datain_height+1)*(datain_channel+1) > 64'h2000;
    } else {
        (datain_width+1)*(datain_height+1)*(datain_channel+1) > 64'h8000;
    }
    (datain_width+1)*(datain_height+1)*(datain_channel+1)    <= 64'h2_0000;
}

constraint nvdla_cdma_resource::c_sim_input_cube_size_large {
    datain_width   inside {[0:'h1FFF]};
    datain_height  inside {[0:'h1FFF]};
    datain_channel inside {[0:'h1FFF]};
}

constraint nvdla_cdma_resource::c_sim_input_cube_size_normal {
    datain_width   dist { [13'h0:13'hF]:=15, [13'h10:13'h7F]:=65, [13'h80:13'hFFF]:=10, [13'h1000:13'h1FFE]:=9, 13'h1FFF :=1 };
    datain_height  dist { [13'h0:13'hF]:=15, [13'h10:13'h7F]:=65, [13'h80:13'hFFF]:=10, [13'h1000:13'h1FFE]:=9, 13'h1FFF :=1 };
    datain_channel dist { [13'h0:13'hF]:=15, [13'h10:13'h7F]:=65, [13'h80:13'hFFF]:=10, [13'h1000:13'h1FFE]:=9, 13'h1FFF :=1 };
    (datain_width+1)*(datain_height+1)*(datain_channel+1) <= 64'h10_0000;
}

constraint nvdla_cdma_resource::c_sim_solve_height_before_width {
    solve datain_height  before datain_width;
}

constraint nvdla_cdma_resource::c_sim_solve_channel_before_width {
    solve datain_channel before datain_width;
}

function void nvdla_cdma_resource::record_rand_variable();
    is_data_bank_changed    = (data_bank != prev_data_bank);
    is_weight_bank_changed  = (weight_bank != prev_weight_bank);
    is_weight_format_changed= (weight_format != prev_weight_format);

    prev_conv_mode           = conv_mode;
    prev_in_precision        = in_precision;
    prev_proc_precision      = proc_precision;
    prev_skip_data_rls       = skip_data_rls;
    prev_skip_weight_rls     = skip_weight_rls;
    prev_datain_format       = datain_format;
    prev_pixel_format        = pixel_format;
    prev_pixel_mapping       = pixel_mapping;
    prev_pixel_sign_override = pixel_sign_override;
    prev_datain_width        = datain_width;
    prev_datain_height       = datain_height;
    prev_datain_channel      = datain_channel;
    prev_datain_width_ext    = datain_width_ext;
    prev_datain_height_ext   = datain_height_ext;
    prev_pixel_x_offset      = pixel_x_offset;
    prev_pixel_y_offset      = pixel_y_offset;
    prev_datain_ram_type     = datain_ram_type;
    prev_datain_addr_high_0  = datain_addr_high_0;
    prev_datain_addr_low_0   = datain_addr_low_0;
    prev_datain_addr_high_1  = datain_addr_high_1;
    prev_datain_addr_low_1   = datain_addr_low_1;
    prev_line_stride         = line_stride;
    prev_uv_line_stride      = uv_line_stride;
    prev_surf_stride         = surf_stride;
    prev_line_packed         = line_packed;
    prev_surf_packed         = surf_packed;
    prev_batches             = batches;
    prev_batch_stride        = batch_stride;
    prev_entries             = entries;
    //grains            =
    prev_weight_format       = weight_format;
    prev_byte_per_kernel     = byte_per_kernel;
    //weight_kernel     =
    prev_weight_ram_type     = weight_ram_type;
    //weight_addr_high  =
    //weight_addr_low   =
    //weight_bytes      =
    //wgs_addr_high     =
    //wgs_addr_low      =
    //wmb_addr_high     =
    //wmb_addr_low      =
    //wmb_bytes         =
    prev_mean_format         = mean_format;
    //mean_ry           =
    //mean_gu           =
    //mean_bv           =
    //mean_ax           =
    prev_cvt_en              = cvt_en;
    prev_cvt_truncate        = cvt_truncate;
    prev_cvt_offset          = cvt_offset;
    prev_cvt_scale           = cvt_scale;
    prev_conv_x_stride       = conv_x_stride;
    prev_conv_y_stride       = conv_y_stride;
    prev_pad_left            = pad_left;
    prev_pad_right           = pad_right;
    prev_pad_top             = pad_top;
    prev_pad_bottom          = pad_bottom;
    prev_pad_value           = pad_value;
    prev_data_bank           = data_bank;
    prev_weight_bank         = weight_bank;
    prev_nan_to_zero         = nan_to_zero;
    //cya               =
    // datain_channel_ext  = datain_channel_ext;
    // y_extension         = y_extension;
    // weight_width_ext    = weight_width_ext;
    // weight_height_ext   = weight_height_ext;
    // weight_channel_ext  = weight_channel_ext;
    //dataout_width     =
    //dataout_height    =
    //dataout_channel   =
    //atomics           =
    //rls_slices        =
    // conv_x_stride_ext   = conv_x_stride_ext;
    // conv_y_stride_ext   = conv_y_stride_ext;
    // x_dilation_ext      = x_dilation_ext;
    // y_dilation_ext      = y_dilation_ext;
    //pad_value_csc     =
    // pra_truncate        = pra_truncate;
    //dataout_addr      =
    //line_stride_cacc  =
    //surf_stride_cacc  =
    // clip_truncate       = clip_truncate;
    // weight_none_zero_rate = weight_none_zero_rate;
    prev_conv_mode           = conv_mode;
    prev_in_precision        = in_precision;
    prev_proc_precision      = proc_precision;
    prev_datain_format       = datain_format;
    prev_pixel_format        = pixel_format;
    prev_pixel_mapping       = pixel_mapping;
    prev_pixel_sign_override = pixel_sign_override;
    //datain_width        = datain_width;
    //datain_height       = datain_height;
    prev_datain_channel      = datain_channel;
    //datain_width_ext    = datain_width_ext;
    //datain_height_ext   = datain_height_ext;
    prev_pixel_x_offset      = pixel_x_offset;
    prev_pixel_y_offset      = pixel_y_offset;
    prev_datain_ram_type     = datain_ram_type;
    //datain_addr_high_0  = datain_addr_high_0;
    //datain_addr_low_0   = datain_addr_low_0;
    //datain_addr_high_1  = datain_addr_high_1;
    //datain_addr_low_1   = datain_addr_low_1;
    //line_stride         = line_stride;
    //uv_line_stride      = uv_line_stride;
    //surf_stride         = surf_stride;
    //line_packed         = line_packed;
    //surf_packed         = surf_packed;
    //gob_per_line        = gob_per_line;
    //gob_per_uv_line     = gob_per_uv_line;
    //gob_height          = gob_height;
    //gob_y_index         = gob_y_index;
    //batches             = batches;
    //batch_stride        = batch_stride;
    //entries             = entries;
    //grains            =
    prev_weight_format       = weight_format;
    prev_byte_per_kernel     = byte_per_kernel;
    prev_weight_kernel       = weight_kernel;
    prev_weight_ram_type     = weight_ram_type;
    //weight_addr_high  =
    //weight_addr_low   =
    prev_weight_bytes        = weight_bytes;
    //wgs_addr_high     =
    //wgs_addr_low      =
    //wmb_addr_high     =
    //wmb_addr_low      =
    prev_wmb_bytes           = wmb_bytes;
    prev_mean_format         = mean_format;
    //mean_ry           =
    //mean_gu           =
    //mean_bv           =
    //mean_ax           =
    prev_cvt_en              = cvt_en;
    prev_cvt_truncate        = cvt_truncate;
    prev_cvt_offset          = cvt_offset;
    prev_cvt_scale           = cvt_scale;
    prev_conv_x_stride       = conv_x_stride;
    prev_conv_y_stride       = conv_y_stride;
    //pad_left            = pad_left;
    //pad_right           = pad_right;
    //pad_top             = pad_top;
    //pad_bottom          = pad_bottom;
    prev_pad_value           = pad_value;
    prev_data_bank           = data_bank;
    prev_weight_bank         = weight_bank;
    //nan_to_zero         = nan_to_zero;
    //cya               =
    // datain_channel_ext  = datain_channel_ext;
    //y_extension         = y_extension;
    // weight_width_ext    = weight_width_ext;
    // weight_height_ext   = weight_height_ext;
    // weight_channel_ext  = weight_channel_ext;
    //dataout_width     =
    //dataout_height    =
    //dataout_channel   =
    //atomics           =
    //rls_slices        =
    // conv_x_stride_ext   = conv_x_stride_ext;
    // conv_y_stride_ext   = conv_y_stride_ext;
    // x_dilation_ext      = x_dilation_ext;
    // y_dilation_ext      = y_dilation_ext;
    //pad_value_csc     =
    //pra_truncate        = pra_truncate;
    //dataout_addr      =
    //line_stride_cacc  =
    //surf_stride_cacc  =
    //clip_truncate       = clip_truncate;
endfunction : record_rand_variable

function void nvdla_cdma_resource::pre_randomize();
    super.pre_randomize();
    c_sim_solve_height_before_width.constraint_mode($urandom_range(0, 1));
    c_sim_solve_channel_before_width.constraint_mode($urandom_range(0, 1));
endfunction : pre_randomize

function void nvdla_cdma_resource::post_randomize();
    set_mem_addr();
    set_register();
    record_rand_variable();

    `uvm_info(inst_name, {"\n", sprint()}, UVM_HIGH)
endfunction : post_randomize

function void nvdla_cdma_resource::set_sim_constraint();
    `uvm_info(inst_name, $sformatf("set sim constraint constraint"), UVM_LOW)
    if ("SMALL"== cc_input_cube_size.toupper()) begin
        c_sim_input_cube_size_small.constraint_mode(1);
        c_sim_input_cube_size_medium.constraint_mode(0);
        c_sim_input_cube_size_large.constraint_mode(0);
        c_sim_input_cube_size_normal.constraint_mode(0);
    end else if ("MEDIUM"== cc_input_cube_size.toupper()) begin
        c_sim_input_cube_size_small.constraint_mode(0);
        c_sim_input_cube_size_medium.constraint_mode(1);
        c_sim_input_cube_size_large.constraint_mode(0);
        c_sim_input_cube_size_normal.constraint_mode(0);
    end else if ("LARGE"== cc_input_cube_size.toupper()) begin
        c_sim_input_cube_size_small.constraint_mode(0);
        c_sim_input_cube_size_medium.constraint_mode(0);
        c_sim_input_cube_size_large.constraint_mode(1);
        c_sim_input_cube_size_normal.constraint_mode(0);
    end else if ("NORMAL"== cc_input_cube_size.toupper()) begin
        c_sim_input_cube_size_small.constraint_mode(0);
        c_sim_input_cube_size_medium.constraint_mode(0);
        c_sim_input_cube_size_large.constraint_mode(0);
        c_sim_input_cube_size_normal.constraint_mode(1);
    end else `uvm_fatal(inst_name, $sformatf("Unknown cc_input_cube_size option:%0s",cc_input_cube_size.toupper()))
endfunction: set_sim_constraint

function void nvdla_cdma_resource::set_mem_addr();
    mem_man          mm;
    mem_region       region;
    longint unsigned mem_size;
    string           mem_domain_input;

    mm = mem_man::get_mem_man();
    if(data_reuse_DISABLE == data_reuse) begin
        mem_domain_input = (datain_ram_type_MCIF==datain_ram_type) ? "pri_mem":"sec_mem";
        if(datain_format_FEATURE == datain_format) begin
            // Feature
            mem_size = calc_mem_size(batches+1, batch_stride, datain_channel+1,
                                    `NVDLA_MEMORY_ATOMIC_SIZE, surf_stride);
            `uvm_info(inst_name, $sformatf("FEATURE_SIZE:feature byte size is: 0x%h", mem_size), UVM_HIGH)
            region = mm.request_region_by_size( mem_domain_input, 
                                                $sformatf("%s_%0d", "CDMA_DATA", get_active_cnt()), 
                                                mem_size, 
                                                align_mask[0]);
            {datain_addr_high_0, datain_addr_low_0} = region.get_start_offset();
        end
        else begin
            // Image, plane 0
            mem_size = calc_mem_size_plane(datain_height+1, line_stride, `NVDLA_MEMORY_ATOMIC_SIZE);
            `uvm_info(inst_name, $sformatf("Image:plane 0 byte size is: 0x%h", mem_size), UVM_HIGH)
            region = mm.request_region_by_size( mem_domain_input, 
                                                $sformatf("%s_%0d", "CDMA_DATA_PLANE_0", get_active_cnt()), 
                                                mem_size, 
                                                align_mask[0]);
            {datain_addr_high_0, datain_addr_low_0} = region.get_start_offset();
            // Image, plane 1
            if(plane_number > 1) begin
                mem_size = calc_mem_size_plane(datain_height+1, uv_line_stride, `NVDLA_MEMORY_ATOMIC_SIZE);
                `uvm_info(inst_name, $sformatf("Image:plane 1 byte size is: 0x%h", mem_size), UVM_HIGH)
                region = mm.request_region_by_size( mem_domain_input, 
                                                    $sformatf("%s_%0d", "CDMA_DATA_PLANE_1", get_active_cnt()),
                                                    mem_size, 
                                                    align_mask[0]);
                {datain_addr_high_1, datain_addr_low_1} = region.get_start_offset();
            end
        end
    end

    if(weight_reuse_DISABLE == weight_reuse) begin
        mem_domain_input = (weight_ram_type_MCIF==weight_ram_type) ? "pri_mem":"sec_mem";
        // Weight surface: uncompressed and comppressed
        mem_size = weight_bytes;
        `uvm_info(inst_name, $sformatf("WEIGHT_SIZE:weight byte size is: 0x%h", mem_size), UVM_HIGH)
        region = mm.request_region_by_size( mem_domain_input, 
                                            $sformatf("%s_%0d", "CDMA_WEIGHT", get_active_cnt()), 
                                            mem_size, 
                                            'h7f);
        {weight_addr_high, weight_addr_low} = region.get_start_offset();
        if(weight_format_COMPRESSED == weight_format) begin
            // Weight mask surface
            mem_size = wmb_bytes;
            `uvm_info(inst_name, $sformatf("WMB_SIZE:weight mask byte size is: 0x%h", mem_size), UVM_HIGH)
            region = mm.request_region_by_size( mem_domain_input, 
                                                $sformatf("%s_%0d", "CDMA_WEIGHT", get_active_cnt()), 
                                                mem_size, 
                                                'h7f);
            {wmb_addr_high, wmb_addr_low} = region.get_start_offset();
            // Weight group size surface
            mem_size = ((weight_kernel + `NVDLA_MAC_ATOMIC_K_SIZE)/`NVDLA_MAC_ATOMIC_K_SIZE + `NVDLA_MAC_ATOMIC_C_SIZE - 1)/`NVDLA_MAC_ATOMIC_C_SIZE * `NVDLA_MAC_ATOMIC_C_SIZE;
            `uvm_info(inst_name, $sformatf("WGS_SIZE:weight group byte size is: 0x%h", mem_size), UVM_HIGH)
            region = mm.request_region_by_size( mem_domain_input,
                                                $sformatf("%s_%0d", "CDMA_WEIGHT", get_active_cnt()), 
                                                mem_size, 
                                                'h7f);
            {wgs_addr_high, wgs_addr_low} = region.get_start_offset();
        end
    end
endfunction : set_mem_addr

function void nvdla_cdma_resource::set_register();
    //:| spec2cons.ral_set(['NVDLA_CDMA'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    ral.nvdla.NVDLA_CDMA.S_ARBITER.ARB_WEIGHT.set(                               arb_weight);
    ral.nvdla.NVDLA_CDMA.S_ARBITER.ARB_WMB.set(                                  arb_wmb);
    ral.nvdla.NVDLA_CDMA.D_MISC_CFG.CONV_MODE.set(                               conv_mode);
    ral.nvdla.NVDLA_CDMA.D_MISC_CFG.IN_PRECISION.set(                            in_precision);
    ral.nvdla.NVDLA_CDMA.D_MISC_CFG.PROC_PRECISION.set(                          proc_precision);
    ral.nvdla.NVDLA_CDMA.D_MISC_CFG.DATA_REUSE.set(                              data_reuse);
    ral.nvdla.NVDLA_CDMA.D_MISC_CFG.WEIGHT_REUSE.set(                            weight_reuse);
    ral.nvdla.NVDLA_CDMA.D_MISC_CFG.SKIP_DATA_RLS.set(                           skip_data_rls);
    ral.nvdla.NVDLA_CDMA.D_MISC_CFG.SKIP_WEIGHT_RLS.set(                         skip_weight_rls);
    ral.nvdla.NVDLA_CDMA.D_DATAIN_FORMAT.DATAIN_FORMAT.set(                      datain_format);
    ral.nvdla.NVDLA_CDMA.D_DATAIN_FORMAT.PIXEL_FORMAT.set(                       pixel_format);
    ral.nvdla.NVDLA_CDMA.D_DATAIN_FORMAT.PIXEL_MAPPING.set(                      pixel_mapping);
    ral.nvdla.NVDLA_CDMA.D_DATAIN_FORMAT.PIXEL_SIGN_OVERRIDE.set(                pixel_sign_override);
    ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_0.DATAIN_WIDTH.set(                       datain_width);
    ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_0.DATAIN_HEIGHT.set(                      datain_height);
    ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_1.DATAIN_CHANNEL.set(                     datain_channel);
    ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_EXT_0.DATAIN_WIDTH_EXT.set(               datain_width_ext);
    ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_EXT_0.DATAIN_HEIGHT_EXT.set(              datain_height_ext);
    ral.nvdla.NVDLA_CDMA.D_PIXEL_OFFSET.PIXEL_X_OFFSET.set(                      pixel_x_offset);
    ral.nvdla.NVDLA_CDMA.D_PIXEL_OFFSET.PIXEL_Y_OFFSET.set(                      pixel_y_offset);
    ral.nvdla.NVDLA_CDMA.D_DAIN_RAM_TYPE.DATAIN_RAM_TYPE.set(                    datain_ram_type);
    ral.nvdla.NVDLA_CDMA.D_DAIN_ADDR_HIGH_0.DATAIN_ADDR_HIGH_0.set(              datain_addr_high_0);
    ral.nvdla.NVDLA_CDMA.D_DAIN_ADDR_LOW_0.DATAIN_ADDR_LOW_0.set(                datain_addr_low_0);
    ral.nvdla.NVDLA_CDMA.D_DAIN_ADDR_HIGH_1.DATAIN_ADDR_HIGH_1.set(              datain_addr_high_1);
    ral.nvdla.NVDLA_CDMA.D_DAIN_ADDR_LOW_1.DATAIN_ADDR_LOW_1.set(                datain_addr_low_1);
    ral.nvdla.NVDLA_CDMA.D_LINE_STRIDE.LINE_STRIDE.set(                          line_stride);
    ral.nvdla.NVDLA_CDMA.D_LINE_UV_STRIDE.UV_LINE_STRIDE.set(                    uv_line_stride);
    ral.nvdla.NVDLA_CDMA.D_SURF_STRIDE.SURF_STRIDE.set(                          surf_stride);
    ral.nvdla.NVDLA_CDMA.D_DAIN_MAP.LINE_PACKED.set(                             line_packed);
    ral.nvdla.NVDLA_CDMA.D_DAIN_MAP.SURF_PACKED.set(                             surf_packed);
    ral.nvdla.NVDLA_CDMA.D_RESERVED_X_CFG.RSV_PER_LINE.set(                      rsv_per_line);
    ral.nvdla.NVDLA_CDMA.D_RESERVED_X_CFG.RSV_PER_UV_LINE.set(                   rsv_per_uv_line);
    ral.nvdla.NVDLA_CDMA.D_RESERVED_Y_CFG.RSV_HEIGHT.set(                        rsv_height);
    ral.nvdla.NVDLA_CDMA.D_RESERVED_Y_CFG.RSV_Y_INDEX.set(                       rsv_y_index);
    ral.nvdla.NVDLA_CDMA.D_BATCH_NUMBER.BATCHES.set(                             batches);
    ral.nvdla.NVDLA_CDMA.D_BATCH_STRIDE.BATCH_STRIDE.set(                        batch_stride);
    ral.nvdla.NVDLA_CDMA.D_ENTRY_PER_SLICE.ENTRIES.set(                          entries);
    ral.nvdla.NVDLA_CDMA.D_FETCH_GRAIN.GRAINS.set(                               grains);
    ral.nvdla.NVDLA_CDMA.D_WEIGHT_FORMAT.WEIGHT_FORMAT.set(                      weight_format);
    ral.nvdla.NVDLA_CDMA.D_WEIGHT_SIZE_0.BYTE_PER_KERNEL.set(                    byte_per_kernel);
    ral.nvdla.NVDLA_CDMA.D_WEIGHT_SIZE_1.WEIGHT_KERNEL.set(                      weight_kernel);
    ral.nvdla.NVDLA_CDMA.D_WEIGHT_RAM_TYPE.WEIGHT_RAM_TYPE.set(                  weight_ram_type);
    ral.nvdla.NVDLA_CDMA.D_WEIGHT_ADDR_HIGH.WEIGHT_ADDR_HIGH.set(                weight_addr_high);
    ral.nvdla.NVDLA_CDMA.D_WEIGHT_ADDR_LOW.WEIGHT_ADDR_LOW.set(                  weight_addr_low);
    ral.nvdla.NVDLA_CDMA.D_WEIGHT_BYTES.WEIGHT_BYTES.set(                        weight_bytes);
    ral.nvdla.NVDLA_CDMA.D_WGS_ADDR_HIGH.WGS_ADDR_HIGH.set(                      wgs_addr_high);
    ral.nvdla.NVDLA_CDMA.D_WGS_ADDR_LOW.WGS_ADDR_LOW.set(                        wgs_addr_low);
    ral.nvdla.NVDLA_CDMA.D_WMB_ADDR_HIGH.WMB_ADDR_HIGH.set(                      wmb_addr_high);
    ral.nvdla.NVDLA_CDMA.D_WMB_ADDR_LOW.WMB_ADDR_LOW.set(                        wmb_addr_low);
    ral.nvdla.NVDLA_CDMA.D_WMB_BYTES.WMB_BYTES.set(                              wmb_bytes);
    ral.nvdla.NVDLA_CDMA.D_MEAN_FORMAT.MEAN_FORMAT.set(                          mean_format);
    ral.nvdla.NVDLA_CDMA.D_MEAN_GLOBAL_0.MEAN_RY.set(                            mean_ry);
    ral.nvdla.NVDLA_CDMA.D_MEAN_GLOBAL_0.MEAN_GU.set(                            mean_gu);
    ral.nvdla.NVDLA_CDMA.D_MEAN_GLOBAL_1.MEAN_BV.set(                            mean_bv);
    ral.nvdla.NVDLA_CDMA.D_MEAN_GLOBAL_1.MEAN_AX.set(                            mean_ax);
    ral.nvdla.NVDLA_CDMA.D_CVT_CFG.CVT_EN.set(                                   cvt_en);
    ral.nvdla.NVDLA_CDMA.D_CVT_CFG.CVT_TRUNCATE.set(                             cvt_truncate);
    ral.nvdla.NVDLA_CDMA.D_CVT_OFFSET.CVT_OFFSET.set(                            cvt_offset);
    ral.nvdla.NVDLA_CDMA.D_CVT_SCALE.CVT_SCALE.set(                              cvt_scale);
    ral.nvdla.NVDLA_CDMA.D_CONV_STRIDE.CONV_X_STRIDE.set(                        conv_x_stride);
    ral.nvdla.NVDLA_CDMA.D_CONV_STRIDE.CONV_Y_STRIDE.set(                        conv_y_stride);
    ral.nvdla.NVDLA_CDMA.D_ZERO_PADDING.PAD_LEFT.set(                            pad_left);
    ral.nvdla.NVDLA_CDMA.D_ZERO_PADDING.PAD_RIGHT.set(                           pad_right);
    ral.nvdla.NVDLA_CDMA.D_ZERO_PADDING.PAD_TOP.set(                             pad_top);
    ral.nvdla.NVDLA_CDMA.D_ZERO_PADDING.PAD_BOTTOM.set(                          pad_bottom);
    ral.nvdla.NVDLA_CDMA.D_ZERO_PADDING_VALUE.PAD_VALUE.set(                     pad_value);
    ral.nvdla.NVDLA_CDMA.D_BANK.DATA_BANK.set(                                   data_bank);
    ral.nvdla.NVDLA_CDMA.D_BANK.WEIGHT_BANK.set(                                 weight_bank);
    ral.nvdla.NVDLA_CDMA.D_NAN_FLUSH_TO_ZERO.NAN_TO_ZERO.set(                    nan_to_zero);
    ral.nvdla.NVDLA_CDMA.D_PERF_ENABLE.DMA_EN.set(                               dma_en);
    ral.nvdla.NVDLA_CDMA.D_CYA.CYA.set(                                          cya);
    //:) epython: generated_end (DO NOT EDIT ABOVE)
endfunction : set_register

`endif //_NVDLA_CDMA_RESOURCE_SV_
