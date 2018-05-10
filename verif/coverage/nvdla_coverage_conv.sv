// Convolution unit coverage

class conv_cov_pool extends nvdla_coverage_base;

    bit_toggle_cg    cc_datain_width_tog_cg;
    bit_toggle_cg    cc_datain_height_tog_cg;
    bit_toggle_cg    cc_datain_channel_tog_cg;
    bit_toggle_cg    cc_datain_width_ext_tog_cg;
    bit_toggle_cg    cc_datain_height_ext_tog_cg;
    bit_toggle_cg    cc_datain_channel_ext_tog_cg;
    bit_toggle_cg    cc_datain_addr_low_0_tog_cg;
    bit_toggle_cg    cc_weight_addr_low_tog_cg;
    bit_toggle_cg    cc_wgs_addr_low_tog_cg;
    bit_toggle_cg    cc_wmb_addr_low_tog_cg;
`ifdef MEM_ADDR_WIDTH_GT_32
    bit_toggle_cg    cc_datain_addr_high_0_tog_cg;
    bit_toggle_cg    cc_weight_addr_high_tog_cg;
    bit_toggle_cg    cc_wgs_addr_high_tog_cg;
    bit_toggle_cg    cc_wmb_addr_high_tog_cg;
`endif
    bit_toggle_cg    cc_batch_stride_tog_cg;
    bit_toggle_cg    cc_wmb_bytes_tog_cg;
    bit_toggle_cg    cc_weight_width_ext_tog_cg;
    bit_toggle_cg    cc_weight_height_ext_tog_cg;
    bit_toggle_cg    cc_weight_channel_ext_tog_cg;
    bit_toggle_cg    cc_weight_kernel_tog_cg;
    bit_toggle_cg    cc_weight_bytes_tog_cg;
    bit_toggle_cg    cc_byte_per_kernel_tog_cg;
    bit_toggle_cg    cc_mean_ry_tog_cg;
    bit_toggle_cg    cc_mean_gu_tog_cg;
    bit_toggle_cg    cc_mean_bv_tog_cg;
    bit_toggle_cg    cc_mean_ax_tog_cg;
    bit_toggle_cg    cc_pad_value_tog_cg;
    bit_toggle_cg    cc_entries_tog_cg;
    bit_toggle_cg    cc_grains_tog_cg;
    bit_toggle_cg    cc_rls_slices_tog_cg;
    bit_toggle_cg    cc_dataout_width_tog_cg;
    bit_toggle_cg    cc_dataout_height_tog_cg;
    bit_toggle_cg    cc_dataout_channel_tog_cg;
    bit_toggle_cg    cc_atomics_tog_cg;
    bit_toggle_cg    cc_cvt_truncate_tog_cg;
    bit_toggle_cg    cc_cvt_offset_tog_cg;
    bit_toggle_cg    cc_cvt_scale_tog_cg;

    function new(string name, ral_sys_top ral);
        super.new(name, ral);

        conv_cg  = new();

        cc_datain_width_tog_cg       = new("cc_datain_width_tog_cg",       ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_0.DATAIN_WIDTH.get_n_bits());
        cc_datain_height_tog_cg      = new("cc_datain_height_tog_cg",      ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_0.DATAIN_HEIGHT.get_n_bits());
        cc_datain_channel_tog_cg     = new("cc_datain_channel_tog_cg",     ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_1.DATAIN_CHANNEL.get_n_bits());
        cc_datain_width_ext_tog_cg   = new("cc_datain_width_ext_tog_cg",   ral.nvdla.NVDLA_CSC.D_DATAIN_SIZE_EXT_0.DATAIN_WIDTH_EXT.get_n_bits());
        cc_datain_height_ext_tog_cg  = new("cc_datain_height_ext_tog_cg",  ral.nvdla.NVDLA_CSC.D_DATAIN_SIZE_EXT_0.DATAIN_HEIGHT_EXT.get_n_bits());
        cc_datain_channel_ext_tog_cg = new("cc_datain_channel_ext_tog_cg", ral.nvdla.NVDLA_CSC.D_DATAIN_SIZE_EXT_1.DATAIN_CHANNEL_EXT.get_n_bits());
        cc_datain_addr_low_0_tog_cg  = new("cc_datain_addr_low_0_tog_cg",  ral.nvdla.NVDLA_CDMA.D_DAIN_ADDR_LOW_0.DATAIN_ADDR_LOW_0.get_n_bits());
        cc_weight_addr_low_tog_cg    = new("cc_weight_addr_low_tog_cg",    ral.nvdla.NVDLA_CDMA.D_WEIGHT_ADDR_LOW.WEIGHT_ADDR_LOW.get_n_bits());
        cc_wgs_addr_low_tog_cg       = new("cc_wgs_addr_low_tog_cg",       ral.nvdla.NVDLA_CDMA.D_WGS_ADDR_LOW.WGS_ADDR_LOW.get_n_bits());
        cc_wmb_addr_low_tog_cg       = new("cc_wmb_addr_low_tog_cg",       ral.nvdla.NVDLA_CDMA.D_WMB_ADDR_LOW.WMB_ADDR_LOW.get_n_bits());
`ifdef MEM_ADDR_WIDTH_GT_32
        cc_datain_addr_high_0_tog_cg = new("cc_datain_addr_high_0_tog_cg", ral.nvdla.NVDLA_CDMA.D_DAIN_ADDR_HIGH_0.DATAIN_ADDR_HIGH_0.get_n_bits());
        cc_weight_addr_high_tog_cg   = new("cc_weight_addr_high_tog_cg",   ral.nvdla.NVDLA_CDMA.D_WEIGHT_ADDR_HIGH.WEIGHT_ADDR_HIGH.get_n_bits());
        cc_wgs_addr_high_tog_cg      = new("cc_wgs_addr_high_tog_cg",      ral.nvdla.NVDLA_CDMA.D_WGS_ADDR_HIGH.WGS_ADDR_HIGH.get_n_bits());
        cc_wmb_addr_high_tog_cg      = new("cc_wmb_addr_high_tog_cg",      ral.nvdla.NVDLA_CDMA.D_WMB_ADDR_HIGH.WMB_ADDR_HIGH.get_n_bits());
`endif
        cc_batch_stride_tog_cg       = new("cc_batch_stride_tog_cg",       ral.nvdla.NVDLA_CDMA.D_BATCH_STRIDE.BATCH_STRIDE.get_n_bits());
        cc_wmb_bytes_tog_cg          = new("cc_wmb_bytes_tog_cg",          ral.nvdla.NVDLA_CDMA.D_WMB_BYTES.WMB_BYTES.get_n_bits());
        cc_weight_width_ext_tog_cg   = new("cc_weight_width_ext_tog_cg",   ral.nvdla.NVDLA_CSC.D_WEIGHT_SIZE_EXT_0.WEIGHT_WIDTH_EXT.get_n_bits());
        cc_weight_height_ext_tog_cg  = new("cc_weight_height_ext_tog_cg",  ral.nvdla.NVDLA_CSC.D_WEIGHT_SIZE_EXT_0.WEIGHT_HEIGHT_EXT.get_n_bits());
        cc_weight_channel_ext_tog_cg = new("cc_weight_channel_ext_tog_cg", ral.nvdla.NVDLA_CSC.D_WEIGHT_SIZE_EXT_1.WEIGHT_CHANNEL_EXT.get_n_bits());
        cc_weight_kernel_tog_cg      = new("cc_weight_kernel_tog_cg",      ral.nvdla.NVDLA_CSC.D_WEIGHT_SIZE_EXT_1.WEIGHT_KERNEL.get_n_bits());
        cc_weight_bytes_tog_cg       = new("cc_weight_bytes_tog_cg",       ral.nvdla.NVDLA_CSC.D_WEIGHT_BYTES.WEIGHT_BYTES.get_n_bits());
        cc_byte_per_kernel_tog_cg    = new("cc_byte_per_kernel_tog_cg",    ral.nvdla.NVDLA_CDMA.D_WEIGHT_SIZE_0.BYTE_PER_KERNEL.get_n_bits());
        cc_mean_ry_tog_cg            = new("cc_mean_ry_tog_cg",            ral.nvdla.NVDLA_CDMA.D_MEAN_GLOBAL_0.MEAN_RY.get_n_bits());
        cc_mean_gu_tog_cg            = new("cc_mean_gu_tog_cg",            ral.nvdla.NVDLA_CDMA.D_MEAN_GLOBAL_0.MEAN_GU.get_n_bits());
        cc_mean_bv_tog_cg            = new("cc_mean_bv_tog_cg",            ral.nvdla.NVDLA_CDMA.D_MEAN_GLOBAL_1.MEAN_BV.get_n_bits());
        cc_mean_ax_tog_cg            = new("cc_mean_ax_tog_cg",            ral.nvdla.NVDLA_CDMA.D_MEAN_GLOBAL_1.MEAN_BV.get_n_bits());
        cc_pad_value_tog_cg          = new("cc_pad_value_tog_cg",          ral.nvdla.NVDLA_CDMA.D_ZERO_PADDING_VALUE.PAD_VALUE.get_n_bits());
        cc_entries_tog_cg            = new("cc_entries_tog_cg",            ral.nvdla.NVDLA_CDMA.D_ENTRY_PER_SLICE.ENTRIES.get_n_bits());
        cc_grains_tog_cg             = new("cc_grains_tog_cg",             ral.nvdla.NVDLA_CDMA.D_FETCH_GRAIN.GRAINS.get_n_bits());
        cc_rls_slices_tog_cg         = new("cc_rls_slices_tog_cg",         ral.nvdla.NVDLA_CSC.D_RELEASE.RLS_SLICES.get_n_bits());
        cc_dataout_width_tog_cg      = new("cc_dataout_width_tog_cg",      ral.nvdla.NVDLA_CSC.D_DATAOUT_SIZE_0.DATAOUT_WIDTH.get_n_bits());
        cc_dataout_height_tog_cg     = new("cc_dataout_height_tog_cg",     ral.nvdla.NVDLA_CSC.D_DATAOUT_SIZE_0.DATAOUT_HEIGHT.get_n_bits());
        cc_dataout_channel_tog_cg    = new("cc_dataout_channel_tog_cg",    ral.nvdla.NVDLA_CSC.D_DATAOUT_SIZE_1.DATAOUT_CHANNEL.get_n_bits());
        cc_atomics_tog_cg            = new("cc_atomics_tog_cg",            ral.nvdla.NVDLA_CSC.D_ATOMICS.ATOMICS.get_n_bits());
        cc_cvt_truncate_tog_cg       = new("cc_cvt_truncate_tog_cg",       ral.nvdla.NVDLA_CDMA.D_CVT_CFG.CVT_TRUNCATE.get_n_bits());
        cc_cvt_offset_tog_cg         = new("cc_cvt_offset_tog_cg",         ral.nvdla.NVDLA_CDMA.D_CVT_OFFSET.CVT_OFFSET.get_n_bits());
        cc_cvt_scale_tog_cg          = new("cc_cvt_scale_tog_cg",          ral.nvdla.NVDLA_CDMA.D_CVT_SCALE.CVT_SCALE.get_n_bits());
    endfunction : new

    task sample();
        `uvm_info(tID, $sformatf("CONV Sample Begin ..."), UVM_LOW)
        conv_toggle_sample();
        conv_cg.sample();
    endtask : sample

    function void conv_toggle_sample();
        cc_datain_width_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_0.DATAIN_WIDTH.value);
        cc_datain_height_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_0.DATAIN_HEIGHT.value);
        cc_datain_channel_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_1.DATAIN_CHANNEL.value);
        cc_datain_width_ext_tog_cg.sample(ral.nvdla.NVDLA_CSC.D_DATAIN_SIZE_EXT_0.DATAIN_WIDTH_EXT.value);
        cc_datain_height_ext_tog_cg.sample(ral.nvdla.NVDLA_CSC.D_DATAIN_SIZE_EXT_0.DATAIN_HEIGHT_EXT.value);
        cc_datain_channel_ext_tog_cg.sample(ral.nvdla.NVDLA_CSC.D_DATAIN_SIZE_EXT_1.DATAIN_CHANNEL_EXT.value);
        cc_datain_addr_low_0_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_DAIN_ADDR_LOW_0.DATAIN_ADDR_LOW_0.value);
        cc_weight_addr_low_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_WEIGHT_ADDR_LOW.WEIGHT_ADDR_LOW.value);
        cc_wgs_addr_low_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_WGS_ADDR_LOW.WGS_ADDR_LOW.value);
        cc_wmb_addr_low_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_WMB_ADDR_LOW.WMB_ADDR_LOW.value);
`ifdef MEM_ADDR_WIDTH_GT_32
        cc_datain_addr_high_0_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_DAIN_ADDR_HIGH_0.DATAIN_ADDR_HIGH_0.value);
        cc_weight_addr_high_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_WEIGHT_ADDR_HIGH.WEIGHT_ADDR_HIGH.value);
        cc_wgs_addr_high_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_WGS_ADDR_HIGH.WGS_ADDR_HIGH.value);
        cc_wmb_addr_high_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_WMB_ADDR_HIGH.WMB_ADDR_HIGH.value);
`endif
        cc_batch_stride_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_BATCH_STRIDE.BATCH_STRIDE.value);
        cc_wmb_bytes_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_WMB_BYTES.WMB_BYTES.value);
        cc_weight_width_ext_tog_cg.sample(ral.nvdla.NVDLA_CSC.D_WEIGHT_SIZE_EXT_0.WEIGHT_WIDTH_EXT.value);
        cc_weight_height_ext_tog_cg.sample(ral.nvdla.NVDLA_CSC.D_WEIGHT_SIZE_EXT_0.WEIGHT_HEIGHT_EXT.value);
        cc_weight_channel_ext_tog_cg.sample(ral.nvdla.NVDLA_CSC.D_WEIGHT_SIZE_EXT_1.WEIGHT_CHANNEL_EXT.value);
        cc_weight_kernel_tog_cg.sample(ral.nvdla.NVDLA_CSC.D_WEIGHT_SIZE_EXT_1.WEIGHT_KERNEL.value);
        cc_weight_bytes_tog_cg.sample(ral.nvdla.NVDLA_CSC.D_WEIGHT_BYTES.WEIGHT_BYTES.value);
        cc_byte_per_kernel_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_WEIGHT_SIZE_0.BYTE_PER_KERNEL.value);
        cc_mean_ry_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_MEAN_GLOBAL_0.MEAN_RY.value);
        cc_mean_gu_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_MEAN_GLOBAL_0.MEAN_GU.value);
        cc_mean_bv_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_MEAN_GLOBAL_1.MEAN_BV.value);
        cc_mean_ax_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_MEAN_GLOBAL_1.MEAN_BV.value);
        cc_pad_value_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_ZERO_PADDING_VALUE.PAD_VALUE.value);
        cc_entries_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_ENTRY_PER_SLICE.ENTRIES.value);
        cc_grains_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_FETCH_GRAIN.GRAINS.value);
        cc_rls_slices_tog_cg.sample(ral.nvdla.NVDLA_CSC.D_RELEASE.RLS_SLICES.value);
        cc_dataout_width_tog_cg.sample(ral.nvdla.NVDLA_CSC.D_DATAOUT_SIZE_0.DATAOUT_WIDTH.value);
        cc_dataout_height_tog_cg.sample(ral.nvdla.NVDLA_CSC.D_DATAOUT_SIZE_0.DATAOUT_HEIGHT.value);
        cc_dataout_channel_tog_cg.sample(ral.nvdla.NVDLA_CSC.D_DATAOUT_SIZE_1.DATAOUT_CHANNEL.value);
        cc_atomics_tog_cg.sample(ral.nvdla.NVDLA_CSC.D_ATOMICS.ATOMICS.value);
        cc_cvt_truncate_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_CVT_CFG.CVT_TRUNCATE.value);
        cc_cvt_offset_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_CVT_OFFSET.CVT_OFFSET.value);
        cc_cvt_scale_tog_cg.sample(ral.nvdla.NVDLA_CDMA.D_CVT_SCALE.CVT_SCALE.value);
    endfunction : conv_toggle_sample


    covergroup conv_cg;
        // ** conv mode **
        cp_conv_mode:          coverpoint ral.nvdla.NVDLA_CDMA.D_MISC_CFG.CONV_MODE.value {
            bins dc       = {0};
`ifdef NVDLA_WINOGRAD_ENABLE
            bins winograd = {1};
`endif
        }
        cp_in_precision:       coverpoint ral.nvdla.NVDLA_CDMA.D_MISC_CFG.IN_PRECISION.value {
            bins int8  = {0};
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            bins int16 = {1};
            bins fp16  = {2};
`endif
        }
        cp_proc_precision:       coverpoint ral.nvdla.NVDLA_CDMA.D_MISC_CFG.PROC_PRECISION.value {
            bins int8  = {0};
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            bins int16 = {1};
            bins fp16  = {2};
`endif
        }
        // ** activation input **
        // image input
        cp_datain_format:      coverpoint ral.nvdla.NVDLA_CDMA.D_DATAIN_FORMAT.DATAIN_FORMAT.value {
            bins feature = {0};
            bins pixel   = {1};
        }
        cp_pixel_format:       coverpoint ral.nvdla.NVDLA_CDMA.D_DATAIN_FORMAT.PIXEL_FORMAT.value {
            bins pixel_format_T_R8                       = {0};
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            bins pixel_format_T_R10                      = {1};
            bins pixel_format_T_R12                      = {2};
            bins pixel_format_T_R16                      = {3};
            bins pixel_format_T_R16_I                    = {4};
            bins pixel_format_T_R16_F                    = {5};
            bins pixel_format_T_A16B16G16R16             = {6};
            bins pixel_format_T_X16B16G16R16             = {7};
            bins pixel_format_T_A16B16G16R16_F           = {8};
            bins pixel_format_T_A16Y16U16V16             = {9};
            bins pixel_format_T_V16U16Y16A16             = {10};
            bins pixel_format_T_A16Y16U16V16_F           = {11};
`endif
            bins pixel_format_T_A8B8G8R8                 = {12};
            bins pixel_format_T_A8R8G8B8                 = {13};
            bins pixel_format_T_B8G8R8A8                 = {14};
            bins pixel_format_T_R8G8B8A8                 = {15};
            bins pixel_format_T_X8B8G8R8                 = {16};
            bins pixel_format_T_X8R8G8B8                 = {17};
            bins pixel_format_T_B8G8R8X8                 = {18};
            bins pixel_format_T_R8G8B8X8                 = {19};
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            bins pixel_format_T_A2B10G10R10              = {20};
            bins pixel_format_T_A2R10G10B10              = {21};
            bins pixel_format_T_B10G10R10A2              = {22};
            bins pixel_format_T_R10G10B10A2              = {23};
            bins pixel_format_T_A2Y10U10V10              = {24};
            bins pixel_format_T_V10U10Y10A2              = {25};
`endif
            bins pixel_format_T_A8Y8U8V8                 = {26};
            bins pixel_format_T_V8U8Y8A8                 = {27};
            bins pixel_format_T_Y8___U8V8_N444           = {28};
            bins pixel_format_T_Y8___V8U8_N444           = {29};
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            bins pixel_format_T_Y10___U10V10_N444        = {30};
            bins pixel_format_T_Y10___V10U10_N444        = {31};
            bins pixel_format_T_Y12___U12V12_N444        = {32};
            bins pixel_format_T_Y12___V12U12_N444        = {33};
            bins pixel_format_T_Y16___U16V16_N444        = {34};
            bins pixel_format_T_Y16___V16U16_N444        = {35};
`endif
        }

        cp_pixel_mapping:      coverpoint ral.nvdla.NVDLA_CDMA.D_DATAIN_FORMAT.PIXEL_MAPPING.value {
            bins pitch_linear = {0};
            ignore_bins non_pitch_linear = {1};
        }

        cr_datain_format_pixel_format_pixel_mapping:     cross cp_datain_format, cp_pixel_format, cp_pixel_mapping {
            ignore_bins feature = binsof(cp_datain_format.feature);
        }
        cp_pixel_x_offset:     coverpoint ral.nvdla.NVDLA_CDMA.D_PIXEL_OFFSET.PIXEL_X_OFFSET.value {
            bins ful[4] = {[0:`NVDLA_MEMORY_ATOMIC_SIZE-1]};
        }
        cr_datain_format_pixel_format_pixel_x_offset:    cross cp_datain_format, cp_pixel_format, cp_pixel_x_offset {
            ignore_bins feature = binsof(cp_datain_format.feature);
            ignore_bins offset  = binsof(cp_pixel_format)intersect{['hc:'h1b]}
                               && binsof(cp_pixel_x_offset)intersect{[`NVDLA_MEMORY_ATOMIC_SIZE/4:$]};
        }
        cp_pixel_y_offset:     coverpoint ral.nvdla.NVDLA_CDMA.D_PIXEL_OFFSET.PIXEL_Y_OFFSET.value[2:0];
        cr_datain_format_pixel_mapping_pixel_y_offset:    cross cp_datain_format, cp_pixel_mapping, cp_pixel_y_offset {
            ignore_bins feature      = binsof(cp_datain_format.feature);
            ignore_bins pitch_linear = binsof(cp_pixel_mapping.pitch_linear);
        }
        cp_pixel_sign_override:coverpoint ral.nvdla.NVDLA_CDMA.D_DATAIN_FORMAT.PIXEL_SIGN_OVERRIDE.value {
            bins unsign = {0};
            bins sign   = {1};
        }
        // ** feature input **
        // cp_datain_format (define above)
        cp_datain_ram_type:    coverpoint ral.nvdla.NVDLA_CDMA.D_DAIN_RAM_TYPE.DATAIN_RAM_TYPE.value {
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
            bins cv = {0};
`endif
            bins mc = {1};
        }
        cp_data_reuse:         coverpoint ral.nvdla.NVDLA_CDMA.D_MISC_CFG.DATA_REUSE.value {
            bins off = {0};
            bins on  = {1};
        }
        cr_datain_ram_type_data_reuse:                    cross cp_datain_ram_type, cp_data_reuse {
            ignore_bins on = binsof(cp_data_reuse.on);
        }
        // input size
        cp_datain_width:       coverpoint ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_0.DATAIN_WIDTH.value[12:0] {
            bins min = {0};
            bins mid[8] = {['h1:'h1FFE]};
            bins max = {'h1FFF};
        }
        cp_datain_height:      coverpoint ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_0.DATAIN_HEIGHT.value[12:0] {
            bins min = {0};
            bins mid[8] = {[1:3838]};
            bins max = {3839};
        }
        cp_datain_channel:     coverpoint ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_1.DATAIN_CHANNEL.value[12:0] {
            bins min = {0};
            bins mid[8] = {['h1:'h1FFE]};
            bins max = {'h1FFF};
        }
        cr_datain_channel_datain_format:                  cross cp_datain_channel, cp_datain_format {
            ignore_bins pixel = binsof(cp_datain_format.pixel) && binsof(cp_datain_channel)intersect{1,[4:$]};
        }
        // input_size_ext
        cp_datain_width_ext:   coverpoint ral.nvdla.NVDLA_CSC.D_DATAIN_SIZE_EXT_0.DATAIN_WIDTH_EXT.value[12:0] {
            bins min = {0};
            bins mid[8] = {['h1:'h1FFE]};
            bins max = {'h1FFF};
        }
        cp_datain_height_ext:  coverpoint ral.nvdla.NVDLA_CSC.D_DATAIN_SIZE_EXT_0.DATAIN_HEIGHT_EXT.value[12:0] {
            bins min = {0};
            bins mid[8] = {[1:3838]};
            bins max = {3839};
        }
        cp_datain_channel_ext: coverpoint ral.nvdla.NVDLA_CSC.D_DATAIN_SIZE_EXT_1.DATAIN_CHANNEL_EXT.value[12:0] {
            bins min = {0};
            bins mid[8] = {['h1:'h1FFE]};
            bins max = {'h1FFF};
        }
        // input address
        cp_datain_addr_low_0:  coverpoint ral.nvdla.NVDLA_CDMA.D_DAIN_ADDR_LOW_0.DATAIN_ADDR_LOW_0.value[31:5] {
            wildcard bins align_64  = {27'b??????????????????????????0};
            wildcard bins align_128 = {27'b?????????????????????????00};
            wildcard bins align_256 = {27'b????????????????????????000};
            bins          ful[8]    = {[0:$]};
        }
        cr_data_reuse_datain_addr_low_0_datain_ram_type:  cross cp_data_reuse, cp_datain_addr_low_0, cp_datain_ram_type {
            ignore_bins reuse = binsof(cp_data_reuse.on);
        }
`ifdef MEM_ADDR_WIDTH_GT_32
        cp_datain_addr_high_0:   coverpoint ral.nvdla.NVDLA_CDMA.D_DAIN_ADDR_HIGH_0.DATAIN_ADDR_HIGH_0.value[7:0] {
            bins ful[8]    = {[0:$]};
        }
        cr_data_reuse_datain_addr_high_0_datain_ram_type: cross cp_data_reuse, cp_datain_addr_high_0, cp_datain_ram_type {
            ignore_bins reuse = binsof(cp_data_reuse.on);
        }
`endif
        cp_datain_addr_low_1:  coverpoint ral.nvdla.NVDLA_CDMA.D_DAIN_ADDR_LOW_1.DATAIN_ADDR_LOW_1.value[31:5] {
            wildcard bins align_64  = {27'b??????????????????????????0};
            wildcard bins align_128 = {27'b?????????????????????????00};
            wildcard bins align_256 = {27'b????????????????????????000};
            bins          ful[8]    = {[0:$]};
        }
        cr_data_reuse_datain_format_datain_addr_low_1_datain_ram_type:  cross cp_data_reuse, cp_datain_format, cp_datain_addr_low_1, cp_datain_ram_type {
            ignore_bins reuse   = binsof(cp_data_reuse.on);
            ignore_bins feature = binsof(cp_datain_format.feature);
        }
`ifdef MEM_ADDR_WIDTH_GT_32
        cp_datain_addr_high_1:   coverpoint ral.nvdla.NVDLA_CDMA.D_DAIN_ADDR_HIGH_1.DATAIN_ADDR_HIGH_1.value[7:0] {
            bins ful[8]    = {[0:$]};
        }
        cr_data_reuse_datain_format_datain_addr_high_1_datain_ram_type:  cross cp_data_reuse, cp_datain_format, cp_datain_addr_high_1, cp_datain_ram_type {
            ignore_bins reuse   = binsof(cp_data_reuse.on);
            ignore_bins feature = binsof(cp_datain_format.feature);
        }
`endif
        // line_stride
        cp_line_stride_feature:        coverpoint (ral.nvdla.NVDLA_CDMA.D_LINE_STRIDE.LINE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE-ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_0.DATAIN_WIDTH.value-1) {
            bins eql     = {0};
            bins mid[7]  = {[1:7]};
            bins high[2] = {[8:16]};
            //option.weight = 0;
        }
        cr_data_reuse_datain_format_line_stride_feature:        cross cp_data_reuse, cp_datain_format, cp_line_stride_feature {
            ignore_bins pixel = binsof(cp_datain_format.pixel);
            ignore_bins reuse = binsof(cp_data_reuse.on);
        }
        cp_line_stride_pitch_0:        coverpoint (ral.nvdla.NVDLA_CDMA.D_LINE_STRIDE.LINE_STRIDE.value-(ral.nvdla.NVDLA_CDMA.D_PIXEL_OFFSET.PIXEL_X_OFFSET.value + ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_0.DATAIN_WIDTH.value+1)*(ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_1.DATAIN_CHANNEL.value+1)) {
            bins eql     = {0};
            bins mid[7]  = {[1:255]};
            bins high[2] = {[256:512]};
            //option.weight = 0;
        }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
        cr_data_reuse_datain_format_pixel_mapping_pixel_format_line_stride_pitch_0:        cross cp_data_reuse, cp_datain_format, cp_pixel_mapping, cp_pixel_format, cp_line_stride_pitch_0 {
            ignore_bins feature      = binsof(cp_datain_format.feature);
            ignore_bins format       = binsof(cp_pixel_format)intersect{[0:19], [26:35]};
            ignore_bins reuse        = binsof(cp_data_reuse.on);
        }
`endif
        cp_line_stride_pitch_1:        coverpoint (ral.nvdla.NVDLA_CDMA.D_LINE_STRIDE.LINE_STRIDE.value-(ral.nvdla.NVDLA_CDMA.D_PIXEL_OFFSET.PIXEL_X_OFFSET.value + ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_0.DATAIN_WIDTH.value+1)*((ral.nvdla.NVDLA_CDMA.D_MISC_CFG.IN_PRECISION.value==0)?1:2)) {
            bins eql     = {0};
            bins mid[7]  = {[1:255]};
            bins high[2] = {[256:512]};
            //option.weight = 0;
        }
        cr_data_reuse_datain_format_pixel_mapping_pixel_format_line_stride_pitch_1:        cross cp_data_reuse, cp_datain_format, cp_pixel_mapping, cp_pixel_format, cp_line_stride_pitch_1 {
            ignore_bins feature      = binsof(cp_datain_format.feature);
            ignore_bins format       = binsof(cp_pixel_format)intersect{[0:27]};
            ignore_bins reuse        = binsof(cp_data_reuse.on);
        }
        cp_line_stride_pitch_2:        coverpoint (ral.nvdla.NVDLA_CDMA.D_LINE_STRIDE.LINE_STRIDE.value-(ral.nvdla.NVDLA_CDMA.D_PIXEL_OFFSET.PIXEL_X_OFFSET.value + ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_0.DATAIN_WIDTH.value+1)*((ral.nvdla.NVDLA_CDMA.D_MISC_CFG.IN_PRECISION.value==0)?1:2)*(ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_1.DATAIN_CHANNEL.value+1)) {
            bins eql     = {0};
            bins mid[7]  = {[1:255]};
            bins high[2] = {[256:512]};
            //option.weight = 0;
        }
        cr_data_reuse_datain_format_pixel_mapping_pixel_format_line_stride_pitch_2:        cross cp_data_reuse, cp_datain_format, cp_pixel_mapping, cp_pixel_format, cp_line_stride_pitch_2 {
            ignore_bins feature      = binsof(cp_datain_format.feature);
            ignore_bins format       = binsof(cp_pixel_format)intersect{[20:25], [28:35]};
            ignore_bins reuse        = binsof(cp_data_reuse.on);
        }
        cp_uv_line_stride:             coverpoint (ral.nvdla.NVDLA_CDMA.D_LINE_UV_STRIDE.UV_LINE_STRIDE.value-2*(ral.nvdla.NVDLA_CDMA.D_PIXEL_OFFSET.PIXEL_X_OFFSET.value + ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_0.DATAIN_WIDTH.value+1)*((ral.nvdla.NVDLA_CDMA.D_MISC_CFG.IN_PRECISION.value==0)?1:2)) {
            bins eql     = {0};
            bins mid[7]  = {[1:255]};
            bins high[2] = {[256:512]};
            //option.weight = 0;
        }
        cr_data_reuse_datain_format_pixel_mapping_pixel_format_uv_line_stride:        cross cp_data_reuse, cp_datain_format, cp_pixel_mapping, cp_pixel_format, cp_uv_line_stride {
            ignore_bins feature      = binsof(cp_datain_format.feature);
            ignore_bins format       = binsof(cp_pixel_format)intersect{[0:27]};
            ignore_bins reuse        = binsof(cp_data_reuse.on);
        }
        cp_surf_stride:       coverpoint (ral.nvdla.NVDLA_CDMA.D_SURF_STRIDE.SURF_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE - (ral.nvdla.NVDLA_CDMA.D_LINE_STRIDE.LINE_STRIDE.value/`NVDLA_MEMORY_ATOMIC_SIZE*(ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_0.DATAIN_HEIGHT.value+1))) {
            bins eql     = {0};
            bins mid[7]  = {[1:7]};
            bins high[2] = {[8:16]};
        }
        cr_data_reuse_datain_format_surf_stride:        cross cp_data_reuse, cp_datain_format, cp_surf_stride {
            ignore_bins pixel      = binsof(cp_datain_format.pixel);
            ignore_bins reuse      = binsof(cp_data_reuse.on);
        }
        cp_line_packed:       coverpoint ral.nvdla.NVDLA_CDMA.D_DAIN_MAP.LINE_PACKED.value {
            bins unpack = {0};
            bins pack   = {1};
        }
        cr_data_reuse_datain_format_line_packed:    cross cp_data_reuse, cp_datain_format, cp_line_packed {
            ignore_bins pixel      = binsof(cp_datain_format.pixel);
            ignore_bins reuse      = binsof(cp_data_reuse.on);
        }
        cp_surf_packed:       coverpoint ral.nvdla.NVDLA_CDMA.D_DAIN_MAP.SURF_PACKED.value {
            bins unpack = {0};
            bins pack   = {1};
        }
        cr_data_reuse_datain_format_surf_packed:    cross cp_data_reuse, cp_datain_format, cp_surf_packed {
            ignore_bins pixel      = binsof(cp_datain_format.pixel);
            ignore_bins reuse      = binsof(cp_data_reuse.on);
        }
        cp_line_packed_cacc:       coverpoint ral.nvdla.NVDLA_CACC.D_DATAOUT_MAP.LINE_PACKED.value {
            bins unpack = {0};
            bins pack   = {1};
        }
        cp_dataout_width:       coverpoint ral.nvdla.NVDLA_CSC.D_DATAOUT_SIZE_0.DATAOUT_WIDTH.value[12:0] {
            bins min = {0};
            bins mid[8] = {['h1:'h1FFE]};
            bins max = {'h1FFF};
        }
        cp_dataout_height:      coverpoint ral.nvdla.NVDLA_CSC.D_DATAOUT_SIZE_0.DATAOUT_HEIGHT.value[12:0] {
            bins min = {0};
            bins mid[8] = {[1:3838]};
            bins max = {3839};
        }
        cp_dataout_channel:     coverpoint ral.nvdla.NVDLA_CSC.D_DATAOUT_SIZE_1.DATAOUT_CHANNEL.value[12:0] {
            bins min = {0};
            bins mid[8] = {['h1:'h1FFE]};
            bins max = {'h1FFF};
        }
        cr_data_reuse_datain_format_line_packed_cacc_dataout_width_dataout_height:    cross cp_data_reuse, cp_line_packed_cacc, cp_dataout_width, cp_dataout_height {
            //ignore_bins feature    = binsof(cp_datain_format.feature);
            ignore_bins reuse          = binsof(cp_data_reuse.on);
            ignore_bins illegle_pack   = binsof(cp_line_packed_cacc.pack) && (binsof(cp_dataout_width)intersect{[1:$]} || binsof(cp_dataout_height)intersect{[1:$]});
            ignore_bins illegle_unpack = binsof(cp_line_packed_cacc.unpack) && binsof(cp_dataout_width)intersect{0} && binsof(cp_dataout_height)intersect{0};
            bins        pack           = binsof(cp_line_packed_cacc.pack) && binsof(cp_dataout_width)intersect{0} && binsof(cp_dataout_height)intersect{0};
            bins        unpack         = binsof(cp_line_packed_cacc.unpack) && binsof(cp_dataout_width)intersect{[1:$]} && binsof(cp_dataout_height)intersect{[1:$]};
        } // not cross datain_format

        cp_surf_packed_cacc:       coverpoint ral.nvdla.NVDLA_CACC.D_DATAOUT_MAP.SURF_PACKED.value {
            bins unpack = {0};
            bins pack   = {1};
        }
        cr_data_reuse_datain_format_surf_packed_cacc_dataout_width_dataout_height:    cross cp_data_reuse, cp_surf_packed_cacc, cp_dataout_width, cp_dataout_height {
            //ignore_bins feature    = binsof(cp_datain_format.feature);
            ignore_bins reuse      = binsof(cp_data_reuse.on);
            ignore_bins illegle_pack   = binsof(cp_surf_packed_cacc.pack) && (binsof(cp_dataout_width)intersect{[1:$]} || binsof(cp_dataout_height)intersect{[1:$]});
            ignore_bins illegle_unpack = binsof(cp_surf_packed_cacc.unpack) && binsof(cp_dataout_width)intersect{0} && binsof(cp_dataout_height)intersect{0};
            bins        pack       = binsof(cp_surf_packed_cacc.pack) && binsof(cp_dataout_width)intersect{0} && binsof(cp_dataout_height)intersect{0};
            bins        unpack     = binsof(cp_surf_packed_cacc.unpack) && binsof(cp_dataout_width)intersect{[1:$]} && binsof(cp_dataout_height)intersect{[1:$]};
        } // not cross datain_format
        // activation batch
        cp_batches:           coverpoint ral.nvdla.NVDLA_CDMA.D_BATCH_NUMBER.BATCHES.value {
            bins single      = {0};
`ifdef NVDLA_BATCH_ENABLE
            bins multiple[8] = {[1:31]};
`endif
        }

        // ** weight input **
        cp_weight_reuse:      coverpoint ral.nvdla.NVDLA_CDMA.D_MISC_CFG.WEIGHT_REUSE.value {
            bins off = {0};
            bins on  = {1};
        }
        cp_weight_format:     coverpoint ral.nvdla.NVDLA_CDMA.D_WEIGHT_FORMAT.WEIGHT_FORMAT.value {
            bins uncompress = {0};
`ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
            bins compress   = {1};
`endif
        }
        cp_weight_ram_type:   coverpoint ral.nvdla.NVDLA_CDMA.D_WEIGHT_RAM_TYPE.WEIGHT_RAM_TYPE.value {
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
            bins cv = {0};
`endif
            bins mc = {1};
        }
        cr_weight_reuse_weight_ram_type:     cross cp_weight_reuse, cp_weight_ram_type {
            ignore_bins reuse = binsof(cp_weight_reuse.on);
        }
        cp_weight_addr_low:  coverpoint ral.nvdla.NVDLA_CDMA.D_WEIGHT_ADDR_LOW.WEIGHT_ADDR_LOW.value[31:5] {
            wildcard bins align_64  = {27'b??????????????????????????0};
            wildcard bins align_128 = {27'b?????????????????????????00};
            wildcard bins align_256 = {27'b????????????????????????000};
            bins          ful[8]    = {[0:$]};
        }
        cr_weight_reuse_weight_addr_low_weight_ram_type:  cross cp_weight_reuse, cp_weight_addr_low, cp_weight_ram_type {
            ignore_bins reuse = binsof(cp_weight_reuse.on);
        }
`ifdef MEM_ADDR_WIDTH_GT_32
        cp_weight_addr_high:  coverpoint ral.nvdla.NVDLA_CDMA.D_WEIGHT_ADDR_HIGH.WEIGHT_ADDR_HIGH.value[`NVDLA_MEM_ADDRESS_WIDTH-32-1:0] {
            bins ful[8]    = {[0:$]};
        }
        cr_weight_reuse_weight_addr_high_weight_ram_type:  cross cp_weight_reuse, cp_weight_addr_high, cp_weight_ram_type {
            ignore_bins reuse = binsof(cp_weight_reuse.on);
        }
`endif
        cp_wgs_addr_low:  coverpoint ral.nvdla.NVDLA_CDMA.D_WGS_ADDR_LOW.WGS_ADDR_LOW.value[31:5] {
            wildcard bins align_64  = {27'b??????????????????????????0};
            wildcard bins align_128 = {27'b?????????????????????????00};
            wildcard bins align_256 = {27'b????????????????????????000};
            bins          ful[8]    = {[0:$]};
        }
        cr_weight_reuse_weight_format_wgs_addr_low_weight_ram_type:  cross cp_weight_reuse, cp_weight_format, cp_wgs_addr_low, cp_weight_ram_type {
            ignore_bins reuse = binsof(cp_weight_reuse.on);
            ignore_bins uncompress = binsof(cp_weight_format.uncompress);
        }
`ifdef MEM_ADDR_WIDTH_GT_32
        cp_wgs_addr_high:  coverpoint ral.nvdla.NVDLA_CDMA.D_WGS_ADDR_HIGH.WGS_ADDR_HIGH.value[`NVDLA_MEM_ADDRESS_WIDTH-32-1:0] {
            bins ful[8]    = {[0:$]};
        }
        cr_weight_reuse_weight_format_wgs_addr_high_weight_ram_type:  cross cp_weight_reuse, cp_weight_format, cp_wgs_addr_high, cp_weight_ram_type {
            ignore_bins reuse      = binsof(cp_weight_reuse.on);
            ignore_bins uncompress = binsof(cp_weight_format.uncompress);
        }
`endif
        cp_wmb_addr_low:  coverpoint ral.nvdla.NVDLA_CDMA.D_WMB_ADDR_LOW.WMB_ADDR_LOW.value[31:5] {
            wildcard bins align_64  = {27'b??????????????????????????0};
            wildcard bins align_128 = {27'b?????????????????????????00};
            wildcard bins align_256 = {27'b????????????????????????000};
            bins          ful[8]    = {[0:$]};
        }
        cr_weight_reuse_weight_format_wmb_addr_low_weight_ram_type:  cross cp_weight_reuse, cp_weight_format, cp_wmb_addr_low, cp_weight_ram_type {
            ignore_bins reuse = binsof(cp_weight_reuse.on);
            ignore_bins uncompress = binsof(cp_weight_format.uncompress);
        }
`ifdef MEM_ADDR_WIDTH_GT_32
        cp_wmb_addr_high:  coverpoint ral.nvdla.NVDLA_CDMA.D_WMB_ADDR_HIGH.WMB_ADDR_HIGH.value[`NVDLA_MEM_ADDRESS_WIDTH-32-1:0] {
            bins ful[8]    = {[0:$]};
        }
        cr_weight_reuse_weight_format_wmb_addr_high_weight_ram_type:  cross cp_weight_reuse, cp_weight_format, cp_wmb_addr_high, cp_weight_ram_type {
            ignore_bins reuse      = binsof(cp_weight_reuse.on);
            ignore_bins uncompress = binsof(cp_weight_format.uncompress);
        }
`endif
        // ** weight size **
        cp_weight_width_ext:       coverpoint ral.nvdla.NVDLA_CSC.D_WEIGHT_SIZE_EXT_0.WEIGHT_WIDTH_EXT.value[4:0] {
            bins ful[8] = {[0:$]};
        }
        cp_weight_height_ext:      coverpoint ral.nvdla.NVDLA_CSC.D_WEIGHT_SIZE_EXT_0.WEIGHT_HEIGHT_EXT.value[4:0] {
            bins ful[8] = {[0:$]};
        }
        cp_weight_channel_ext:     coverpoint ral.nvdla.NVDLA_CSC.D_WEIGHT_SIZE_EXT_1.WEIGHT_CHANNEL_EXT.value[12:0] {
            bins ful[8] = {[0:$]};
        }
        cp_y_extension:            coverpoint ral.nvdla.NVDLA_CSC.D_POST_Y_EXTENSION.Y_EXTENSION.value {
            bins ful[] = {[0:2]};
        }
        // dilation
        cp_x_dilation_ext:         coverpoint ral.nvdla.NVDLA_CSC.D_DILATION_EXT.X_DILATION_EXT.value {
            bins ful[] = {[0:31]};
        }
        cr_conv_mode_datain_format_x_dilation_ext:      cross cp_conv_mode, cp_datain_format, cp_x_dilation_ext {
            //bins dc = binsof(cp_conv_mode.dc) && binsof(cp_datain_format.feature);
`ifdef NVDLA_WINOGRAD_ENABLE
            ignore_bins winograd = binsof(cp_conv_mode.winograd);
`endif
            ignore_bins pixel    = binsof(cp_datain_format.pixel);
        }
        cp_y_dilation_ext:         coverpoint ral.nvdla.NVDLA_CSC.D_DILATION_EXT.Y_DILATION_EXT.value {
            bins ful[] = {[0:31]};
        }
        cr_conv_mode_datain_format_y_dilation_ext:      cross cp_conv_mode, cp_datain_format, cp_y_dilation_ext {
            //bins dc = binsof(cp_conv_mode.dc) && binsof(cp_datain_format.feature);
`ifdef NVDLA_WINOGRAD_ENABLE
            ignore_bins winograd = binsof(cp_conv_mode.winograd);
`endif
            ignore_bins pixel    = binsof(cp_datain_format.pixel);
        }
        // mean input
        cp_mean_format:            coverpoint ral.nvdla.NVDLA_CDMA.D_MEAN_FORMAT.MEAN_FORMAT.value {
            bins off = {0};
            bins on  = {1};
        }
        // ** convolution mode **
        cr_conv_mode_datain_format:         cross cp_conv_mode, cp_datain_format {
`ifdef NVDLA_WINOGRAD_ENABLE
            ignore_bins illegle_mode = binsof(cp_conv_mode.winograd) && binsof(cp_datain_format.pixel);
`endif
        }
        cp_conv_x_stride_0:          coverpoint ral.nvdla.NVDLA_CDMA.D_CONV_STRIDE.CONV_X_STRIDE.value[2:0];
        cp_conv_y_stride_0:          coverpoint ral.nvdla.NVDLA_CDMA.D_CONV_STRIDE.CONV_Y_STRIDE.value[2:0];
        //cp_conv_x_stride_1:          coverpoint signed'(ral.nvdla.NVDLA_CDMA.D_CONV_STRIDE.CONV_X_STRIDE.value - ral.nvdla.NVDLA_CSC.D_WEIGHT_SIZE_EXT_0.WEIGHT_WIDTH_EXT.value) {
        //    bins neg  = {[$:-1]};
        //    bins zero = {0};
        //    bins pos  = {[1:$]};
        //}
        //cp_conv_y_stride_1:          coverpoint signed'(ral.nvdla.NVDLA_CDMA.D_CONV_STRIDE.CONV_Y_STRIDE.value - ral.nvdla.NVDLA_CSC.D_WEIGHT_SIZE_EXT_0.WEIGHT_HEIGHT_EXT.value) {
        //    bins neg  = {[$:-1]};
        //    bins zero = {0};
        //    bins pos  = {[1:$]};
        //}
        cp_conv_x_stride_ext:      coverpoint ral.nvdla.NVDLA_CSC.D_CONV_STRIDE_EXT.CONV_X_STRIDE_EXT.value[2:0];
        cp_conv_y_stride_ext:      coverpoint ral.nvdla.NVDLA_CSC.D_CONV_STRIDE_EXT.CONV_Y_STRIDE_EXT.value[2:0];
        // ** padding **
        cp_pad_left:               coverpoint ral.nvdla.NVDLA_CDMA.D_ZERO_PADDING.PAD_LEFT.value[4:0] {
            bins ful[8] = {[0:$]};
        }
        cp_pad_right:              coverpoint ral.nvdla.NVDLA_CDMA.D_ZERO_PADDING.PAD_RIGHT.value[5:0] {
            bins ful[8] = {[0:$]};
        }
        cp_pad_top:                coverpoint ral.nvdla.NVDLA_CDMA.D_ZERO_PADDING.PAD_TOP.value[4:0] {
            bins ful[8] = {[0:$]};
        }
        cp_pad_bottom:             coverpoint ral.nvdla.NVDLA_CDMA.D_ZERO_PADDING.PAD_BOTTOM.value[5:0] {
            bins ful[8] = {[0:$]};
        }
        // cbuf control
        cp_data_bank:              coverpoint ral.nvdla.NVDLA_CDMA.D_BANK.DATA_BANK.value[3:0];
        cr_data_reuse_data_bank:         cross cp_data_reuse, cp_data_bank {
            ignore_bins reuse = binsof(cp_data_reuse.on);
        }
        cp_weight_bank:            coverpoint ral.nvdla.NVDLA_CDMA.D_BANK.WEIGHT_BANK.value[3:0];
        cr_weight_reuse_weight_bank:         cross cp_weight_reuse, cp_weight_bank {
            ignore_bins reuse = binsof(cp_weight_reuse.on);
        }
        // reuse
        cp_skip_data_rls:          coverpoint ral.nvdla.NVDLA_CSC.D_MISC_CFG.SKIP_DATA_RLS.value {
            bins off = {0};
            bins on  = {1};
        }
        cp_skip_weight_rls:        coverpoint ral.nvdla.NVDLA_CSC.D_MISC_CFG.SKIP_WEIGHT_RLS.value {
            bins off = {0};
            bins on  = {1};
        }
        cp_rtl_padded_width_alignment:  coverpoint ((ral.nvdla.NVDLA_CDMA.D_ZERO_PADDING.PAD_LEFT.value[4:0] + ral.nvdla.NVDLA_CDMA.D_DATAIN_SIZE_0.DATAIN_WIDTH.value[12:0] + 64'h1 + ral.nvdla.NVDLA_CDMA.D_ZERO_PADDING.PAD_RIGHT.value[4:0]) % `NVDLA_MEMORY_ATOMIC_SIZE) {
            bins ful[]  = {[0:`NVDLA_MEMORY_ATOMIC_SIZE-1]};
        }
        cr_pixel_format_rtl_yuv_padded_width_alignment: cross cp_pixel_format, cp_rtl_padded_width_alignment {
            ignore_bins single_plane  = binsof(cp_pixel_format) intersect {[0:27]};
        }
        cr_skip_data_rls_skip_weight_rls: cross cp_skip_data_rls, cp_skip_weight_rls;
        cr_data_reuse_weight_reuse:       cross cp_data_reuse, cp_weight_reuse {
            ignore_bins reuse_both = binsof(cp_data_reuse.on) && binsof(cp_weight_reuse.on);
        }
        // ** precision conversion **
        cr_datain_format_in_precision:    cross cp_datain_format, cp_in_precision;
        cr_datain_format_proc_precision:  cross cp_datain_format, cp_proc_precision;
        cp_pra_truncate:                  coverpoint ral.nvdla.NVDLA_CSC.D_PRA_CFG.PRA_TRUNCATE.value {
            bins ful[] = {0, 1, 2};
        }
        cr_conv_mode_in_precision_pra_truncate:  cross cp_conv_mode, cp_in_precision, cp_pra_truncate {
            ignore_bins dc = binsof(cp_conv_mode.dc);
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            ignore_bins fp = binsof(cp_in_precision.fp16);
`endif
        }
        cr_in_precision_proc_precision_feature:          cross cp_in_precision, cp_proc_precision, cp_datain_format{
            ignore_bins pixel = binsof(cp_datain_format.pixel);
            bins        int8  = binsof(cp_in_precision.int8) && binsof(cp_proc_precision.int8);
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            bins        int16 = binsof(cp_in_precision.int16) && binsof(cp_proc_precision.int16);
            bins        fp16  = binsof(cp_in_precision.fp16) && binsof(cp_proc_precision.fp16);
`endif
            ignore_bins ignore_int8 = binsof(cp_in_precision.int8) && !binsof(cp_proc_precision.int8);
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            ignore_bins ignore_int16 = binsof(cp_in_precision.int16) && !binsof(cp_proc_precision.int16);
            ignore_bins ignore_fp16  = binsof(cp_in_precision.fp16) && !binsof(cp_proc_precision.fp16);
`endif
        }
        cr_in_precision_proc_precision_pixel:          cross cp_in_precision, cp_proc_precision, cp_datain_format{
            ignore_bins feature = binsof(cp_datain_format.feature);
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            ignore_bins fp2int  = binsof(cp_in_precision.fp16) && binsof(cp_proc_precision)intersect{0,1};
`endif
        }


    endgroup : conv_cg


endclass : conv_cov_pool


