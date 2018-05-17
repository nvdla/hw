// CDP unit coverage

class cdp_cov_pool extends nvdla_coverage_base;

    // enum define
    //:| import spec2constrain
    //:| global spec2cons
    //:| spec2cons = spec2constrain.Spec2Cons()
    //:| spec2cons.enum_gen(['NVDLA_CDP', 'NVDLA_CDP_RDMA'])

    bit_toggle_cg    tg_cdp_cube_width;
    bit_toggle_cg    tg_cdp_cube_height;
    bit_toggle_cg    tg_cdp_cube_channel;
    bit_toggle_cg    tg_cdp_src_base_addr_low;
`ifdef MEM_ADDR_WIDTH_GT_32
    bit_toggle_cg    tg_cdp_src_base_addr_high;
`endif
    bit_toggle_cg    tg_cdp_src_line_stride;
    bit_toggle_cg    tg_cdp_src_surface_stride;
    bit_toggle_cg    tg_cdp_dst_base_addr_low;
`ifdef MEM_ADDR_WIDTH_GT_32
    bit_toggle_cg    tg_cdp_dst_base_addr_high;
`endif
    bit_toggle_cg    tg_cdp_dst_line_stride;
    bit_toggle_cg    tg_cdp_dst_surface_stride;

    // lut
    bit_toggle_cg    tg_cdp_lut_le_index_offset;
    bit_toggle_cg    tg_cdp_lut_le_index_select;
    bit_toggle_cg    tg_cdp_lut_lo_index_select;
    bit_toggle_cg    tg_cdp_lut_le_start_low;
    bit_toggle_cg    tg_cdp_lut_le_start_high;
    bit_toggle_cg    tg_cdp_lut_le_end_low;
    bit_toggle_cg    tg_cdp_lut_le_end_high;
    bit_toggle_cg    tg_cdp_lut_lo_start_low;
    bit_toggle_cg    tg_cdp_lut_lo_start_high;
    bit_toggle_cg    tg_cdp_lut_lo_end_low;
    bit_toggle_cg    tg_cdp_lut_lo_end_high;
    bit_toggle_cg    tg_cdp_lut_le_slope_uflow_scale;
    bit_toggle_cg    tg_cdp_lut_le_slope_oflow_scale;
    bit_toggle_cg    tg_cdp_lut_le_slope_uflow_shift;
    bit_toggle_cg    tg_cdp_lut_le_slope_oflow_shift;
    bit_toggle_cg    tg_cdp_lut_lo_slope_uflow_scale;
    bit_toggle_cg    tg_cdp_lut_lo_slope_oflow_scale;
    bit_toggle_cg    tg_cdp_lut_lo_slope_uflow_shift;
    bit_toggle_cg    tg_cdp_lut_lo_slope_oflow_shift;

    function new(string name, ral_sys_top ral);
        super.new(name, ral);

        cdp_cg     = new();
        cdp_lut_cg = new();

        tg_cdp_cube_width        = new("tg_cdp_cube_width",           ral.nvdla.NVDLA_CDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.get_n_bits());
        tg_cdp_cube_height       = new("tg_cdp_cube_height",          ral.nvdla.NVDLA_CDP_RDMA.D_DATA_CUBE_HEIGHT.HEIGHT.get_n_bits());
        tg_cdp_cube_channel      = new("tg_cdp_cube_channel",         ral.nvdla.NVDLA_CDP_RDMA.D_DATA_CUBE_CHANNEL.CHANNEL.get_n_bits());
        tg_cdp_src_base_addr_low = new("tg_cdp_src_base_addr_low",    ral.nvdla.NVDLA_CDP_RDMA.D_SRC_BASE_ADDR_LOW.SRC_BASE_ADDR_LOW.get_n_bits());
`ifdef MEM_ADDR_WIDTH_GT_32
        tg_cdp_src_base_addr_high= new("tg_cdp_src_base_addr_high",   ral.nvdla.NVDLA_CDP_RDMA.D_SRC_BASE_ADDR_HIGH.SRC_BASE_ADDR_HIGH.get_n_bits());
`endif
        tg_cdp_src_line_stride   = new("tg_cdp_src_line_stride",      ral.nvdla.NVDLA_CDP_RDMA.D_SRC_LINE_STRIDE.SRC_LINE_STRIDE.get_n_bits());
        tg_cdp_src_surface_stride= new("tg_cdp_src_surface_stride",   ral.nvdla.NVDLA_CDP_RDMA.D_SRC_SURFACE_STRIDE.SRC_SURFACE_STRIDE.get_n_bits());
        tg_cdp_dst_base_addr_low = new("tg_cdp_dst_base_addr_low",    ral.nvdla.NVDLA_CDP.D_DST_BASE_ADDR_LOW.DST_BASE_ADDR_LOW.get_n_bits());
`ifdef MEM_ADDR_WIDTH_GT_32
        tg_cdp_dst_base_addr_high= new("tg_cdp_dst_base_addr_high",   ral.nvdla.NVDLA_CDP.D_DST_BASE_ADDR_HIGH.DST_BASE_ADDR_HIGH.get_n_bits());
`endif
        tg_cdp_dst_line_stride   = new("tg_cdp_dst_line_stride",      ral.nvdla.NVDLA_CDP.D_DST_LINE_STRIDE.DST_LINE_STRIDE.get_n_bits());
        tg_cdp_dst_surface_stride= new("tg_cdp_dst_surface_stride",   ral.nvdla.NVDLA_CDP.D_DST_SURFACE_STRIDE.DST_SURFACE_STRIDE.get_n_bits());

        // cdp lut
        tg_cdp_lut_le_index_offset      = new("tg_cdp_lut_le_index_offset",      ral.nvdla.NVDLA_CDP.S_LUT_INFO.LUT_LE_INDEX_OFFSET.get_n_bits());
        tg_cdp_lut_le_index_select      = new("tg_cdp_lut_le_index_select",      ral.nvdla.NVDLA_CDP.S_LUT_INFO.LUT_LE_INDEX_SELECT.get_n_bits());
        tg_cdp_lut_lo_index_select      = new("tg_cdp_lut_lo_index_select",      ral.nvdla.NVDLA_CDP.S_LUT_INFO.LUT_LO_INDEX_SELECT.get_n_bits());
        tg_cdp_lut_le_start_low         = new("tg_cdp_lut_le_start_low",         ral.nvdla.NVDLA_CDP.S_LUT_LE_START_LOW.LUT_LE_START_LOW.get_n_bits());
        tg_cdp_lut_le_start_high        = new("tg_cdp_lut_le_start_high",        ral.nvdla.NVDLA_CDP.S_LUT_LE_START_HIGH.LUT_LE_START_HIGH.get_n_bits());
        tg_cdp_lut_le_end_low           = new("tg_cdp_lut_le_end_low",           ral.nvdla.NVDLA_CDP.S_LUT_LE_END_LOW.LUT_LE_END_LOW.get_n_bits());
        tg_cdp_lut_le_end_high          = new("tg_cdp_lut_le_end_high",          ral.nvdla.NVDLA_CDP.S_LUT_LE_END_HIGH.LUT_LE_END_HIGH.get_n_bits());
        tg_cdp_lut_lo_start_low         = new("tg_cdp_lut_lo_start_low",         ral.nvdla.NVDLA_CDP.S_LUT_LO_START_LOW.LUT_LO_START_LOW.get_n_bits());
        tg_cdp_lut_lo_start_high        = new("tg_cdp_lut_lo_start_high",        ral.nvdla.NVDLA_CDP.S_LUT_LO_START_HIGH.LUT_LO_START_HIGH.get_n_bits());
        tg_cdp_lut_lo_end_low           = new("tg_cdp_lut_lo_end_low",           ral.nvdla.NVDLA_CDP.S_LUT_LO_END_LOW.LUT_LO_END_LOW.get_n_bits());
        tg_cdp_lut_lo_end_high          = new("tg_cdp_lut_lo_end_high",          ral.nvdla.NVDLA_CDP.S_LUT_LO_END_HIGH.LUT_LO_END_HIGH.get_n_bits());
        tg_cdp_lut_le_slope_uflow_scale = new("tg_cdp_lut_le_slope_uflow_scale", ral.nvdla.NVDLA_CDP.S_LUT_LE_SLOPE_SCALE.LUT_LE_SLOPE_UFLOW_SCALE.get_n_bits());
        tg_cdp_lut_le_slope_oflow_scale = new("tg_cdp_lut_le_slope_oflow_scale", ral.nvdla.NVDLA_CDP.S_LUT_LE_SLOPE_SCALE.LUT_LE_SLOPE_OFLOW_SCALE.get_n_bits());
        tg_cdp_lut_le_slope_uflow_shift = new("tg_cdp_lut_le_slope_uflow_shift", ral.nvdla.NVDLA_CDP.S_LUT_LE_SLOPE_SHIFT.LUT_LE_SLOPE_UFLOW_SHIFT.get_n_bits());
        tg_cdp_lut_le_slope_oflow_shift = new("tg_cdp_lut_le_slope_oflow_shift", ral.nvdla.NVDLA_CDP.S_LUT_LE_SLOPE_SHIFT.LUT_LE_SLOPE_OFLOW_SHIFT.get_n_bits());
        tg_cdp_lut_lo_slope_uflow_scale = new("tg_cdp_lut_lo_slope_uflow_scale", ral.nvdla.NVDLA_CDP.S_LUT_LO_SLOPE_SCALE.LUT_LO_SLOPE_UFLOW_SCALE.get_n_bits());
        tg_cdp_lut_lo_slope_oflow_scale = new("tg_cdp_lut_lo_slope_oflow_scale", ral.nvdla.NVDLA_CDP.S_LUT_LO_SLOPE_SCALE.LUT_LO_SLOPE_OFLOW_SCALE.get_n_bits());
        tg_cdp_lut_lo_slope_uflow_shift = new("tg_cdp_lut_lo_slope_uflow_shift", ral.nvdla.NVDLA_CDP.S_LUT_LO_SLOPE_SHIFT.LUT_LO_SLOPE_UFLOW_SHIFT.get_n_bits());
        tg_cdp_lut_lo_slope_oflow_shift = new("tg_cdp_lut_lo_slope_oflow_shift", ral.nvdla.NVDLA_CDP.S_LUT_LO_SLOPE_SHIFT.LUT_LO_SLOPE_OFLOW_SHIFT.get_n_bits());
    endfunction : new

    task sample();
        `uvm_info(tID, $sformatf("Sample Begin ..."), UVM_LOW)
        cdp_toggle_sample();    // Sample toggle coverage
        cdp_cg.sample();        // Sample coverage group
    endtask : sample

    task cdp_lut_sample();
        `uvm_info(tID, $sformatf("CDP LUT Sample Begin ..."), UVM_LOW)
        cdp_lut_toggle_sample();    // Sample toggle coverage
        cdp_lut_cg.sample();        // Sample coverage group
    endtask : cdp_lut_sample

    // Write individual coverpoint first
    // Divide into small covergroups later
    covergroup cdp_cg;

        // Cube size
        cp_cube_width:          coverpoint ral.nvdla.NVDLA_CDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.value iff (1 == ral.nvdla.NVDLA_CDP_RDMA.D_OP_ENABLE.OP_EN.value) {
            bins zero       = {13'h0};
            bins max        = {13'h1FFF};
            bins low        = {['h0   :13'hF]};
            bins middle     = {['h10  :13'h3F]};
            bins high       = {['h40  :13'hFFF]};
            bins extreme    = {['h1000:13'h1FFF]};
            bins full[`CDP_COV_BIN_NUM_DEFAULT]    = {['h0   :13'h1FFF]};
        }
        cp_cube_height:         coverpoint ral.nvdla.NVDLA_CDP_RDMA.D_DATA_CUBE_HEIGHT.HEIGHT.value iff (1 == ral.nvdla.NVDLA_CDP_RDMA.D_OP_ENABLE.OP_EN.value) {
            bins zero       = {13'h0};
            bins max        = {13'h1FFF};
            bins low        = {['h0   :13'hF]};
            bins middle     = {['h10  :13'h3F]};
            bins high       = {['h40  :13'hFFF]};
            bins extreme    = {['h1000:13'h1FFF]};
            bins full[`CDP_COV_BIN_NUM_DEFAULT]    = {['h0   :13'h1FFF]};
        }
        cp_cube_channel:        coverpoint ral.nvdla.NVDLA_CDP_RDMA.D_DATA_CUBE_CHANNEL.CHANNEL.value iff (1 == ral.nvdla.NVDLA_CDP_RDMA.D_OP_ENABLE.OP_EN.value) {
            bins zero       = {13'h0};
            bins max        = {13'h1FFF};
            bins low        = {['h0   :13'hF]};
            bins middle     = {['h10  :13'h3F]};
            bins high       = {['h40  :13'hFFF]};
            bins extreme    = {['h1000:13'h1FFF]};
            bins full[`CDP_COV_BIN_NUM_DEFAULT]    = {['h0   :13'h1FFF]};
        }

        // Source/Input memory settings
        cp_src_base_addr_low:   coverpoint ral.nvdla.NVDLA_CDP_RDMA.D_SRC_BASE_ADDR_LOW.SRC_BASE_ADDR_LOW.value[31:5] iff (1 == ral.nvdla.NVDLA_CDP_RDMA.D_OP_ENABLE.OP_EN.value) {
            wildcard bins align_64  = {27'b??????????????????????????0};
            wildcard bins align_128 = {27'b?????????????????????????00};
            wildcard bins align_256 = {27'b????????????????????????000};
            bins full[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: `MAX_VALUE_27BITS]};
        }
`ifdef MEM_ADDR_WIDTH_GT_32
        cp_src_base_addr_high:  coverpoint ral.nvdla.NVDLA_CDP_RDMA.D_SRC_BASE_ADDR_HIGH.SRC_BASE_ADDR_HIGH.value[`NVDLA_MEM_ADDRESS_WIDTH-32-1:0] iff (1 == ral.nvdla.NVDLA_CDP_RDMA.D_OP_ENABLE.OP_EN.value) {
            bins full[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: `MAX_VALUE_8BITS]};
        }
`endif
//      cp_src_line_stride:     coverpoint ral.nvdla.NVDLA_CDP_RDMA.D_SRC_LINE_STRIDE.SRC_LINE_STRIDE.value[31:5] iff (1 == ral.nvdla.NVDLA_CDP_RDMA.D_OP_ENABLE.OP_EN.value) {
//          bins full[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: `MAX_VALUE_27BITS]};
//      }
//      cp_src_surface_stride:  coverpoint ral.nvdla.NVDLA_CDP_RDMA.D_SRC_SURFACE_STRIDE.SRC_SURFACE_STRIDE.value[31:5] iff (1 == ral.nvdla.NVDLA_CDP_RDMA.D_OP_ENABLE.OP_EN.value) {
//          bins full[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: `MAX_VALUE_27BITS]};
//      }
        cp_src_line_stride_size_diff:  coverpoint ((ral.nvdla.NVDLA_CDP_RDMA.D_SRC_LINE_STRIDE.SRC_LINE_STRIDE.value - ral.nvdla.NVDLA_CDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.value - 64'h1)%8) iff (1 == ral.nvdla.NVDLA_CDP_RDMA.D_OP_ENABLE.OP_EN.value) {
            bins diff[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: `MAX_VALUE_3BITS]};
        }
        cp_src_surface_stride_size_diff:  coverpoint ((ral.nvdla.NVDLA_CDP_RDMA.D_SRC_SURFACE_STRIDE.SRC_SURFACE_STRIDE.value - ral.nvdla.NVDLA_CDP_RDMA.D_SRC_LINE_STRIDE.SRC_LINE_STRIDE.value*(ral.nvdla.NVDLA_CDP_RDMA.D_DATA_CUBE_HEIGHT.HEIGHT.value) - ral.nvdla.NVDLA_CDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.value - 64'h1)%8) iff (1 == ral.nvdla.NVDLA_CDP_RDMA.D_OP_ENABLE.OP_EN.value) {
            bins diff[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0:3'h7]};
        }
        cp_src_ram_type:        coverpoint ral.nvdla.NVDLA_CDP_RDMA.D_SRC_DMA_CFG.SRC_RAM_TYPE.value iff (1 == ral.nvdla.NVDLA_CDP_RDMA.D_OP_ENABLE.OP_EN.value) {
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
            bins CV = {src_ram_type_CV};
`endif
            bins MC = {src_ram_type_MC};
        }
        cp_src_end_addr:        coverpoint ((64'h1+ral.nvdla.NVDLA_CDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.value+{ral.nvdla.NVDLA_CDP_RDMA.D_SRC_BASE_ADDR_HIGH.SRC_BASE_ADDR_HIGH.value, ral.nvdla.NVDLA_CDP_RDMA.D_SRC_BASE_ADDR_LOW.SRC_BASE_ADDR_LOW.value})%8) iff (1 == ral.nvdla.NVDLA_CDP_RDMA.D_OP_ENABLE.OP_EN.value) {
            bins diff[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0:3'h7]};
        }

        // Destination/Output memory settings
        cp_dst_base_addr_low:   coverpoint ral.nvdla.NVDLA_CDP.D_DST_BASE_ADDR_LOW.DST_BASE_ADDR_LOW.value[31:5] iff (1 == ral.nvdla.NVDLA_CDP.D_OP_ENABLE.OP_EN.value) {
            bins full[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: `MAX_VALUE_27BITS]};
        }
`ifdef MEM_ADDR_WIDTH_GT_32
        cp_dst_base_addr_high:  coverpoint ral.nvdla.NVDLA_CDP.D_DST_BASE_ADDR_HIGH.DST_BASE_ADDR_HIGH.value[`NVDLA_MEM_ADDRESS_WIDTH-32-1:0] iff (1 == ral.nvdla.NVDLA_CDP.D_OP_ENABLE.OP_EN.value) {
            bins full[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: `MAX_VALUE_8BITS]};
        }
`endif
//      cp_dst_line_stride:     coverpoint ral.nvdla.NVDLA_CDP.D_DST_LINE_STRIDE.DST_LINE_STRIDE.value[31:5] iff (1 == ral.nvdla.NVDLA_CDP.D_OP_ENABLE.OP_EN.value) {
//          bins full[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: `MAX_VALUE_27BITS]};
//      }
//      cp_dst_surface_stride:  coverpoint ral.nvdla.NVDLA_CDP.D_DST_SURFACE_STRIDE.DST_SURFACE_STRIDE.value[31:5] iff (1 == ral.nvdla.NVDLA_CDP.D_OP_ENABLE.OP_EN.value) {
//          bins full[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: `MAX_VALUE_27BITS]};
//      }
        cp_dst_line_stride_size_diff:   coverpoint ((ral.nvdla.NVDLA_CDP.D_DST_LINE_STRIDE.DST_LINE_STRIDE.value - ral.nvdla.NVDLA_CDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.value - 64'h1)%8) iff (1 == ral.nvdla.NVDLA_CDP.D_OP_ENABLE.OP_EN.value) {
            bins diff[`CDP_COV_BIN_NUM_DEFAULT]         = {['h0:3'h7]};
        }
        cp_dst_surface_stride_size_diff:  coverpoint ((ral.nvdla.NVDLA_CDP.D_DST_SURFACE_STRIDE.DST_SURFACE_STRIDE.value - ral.nvdla.NVDLA_CDP.D_DST_LINE_STRIDE.DST_LINE_STRIDE.value*(ral.nvdla.NVDLA_CDP_RDMA.D_DATA_CUBE_HEIGHT.HEIGHT.value)- ral.nvdla.NVDLA_CDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.value - 64'h1)%8) iff (1 == ral.nvdla.NVDLA_CDP.D_OP_ENABLE.OP_EN.value) {
            bins diff[`CDP_COV_BIN_NUM_DEFAULT]         = {['h0:3'h7]};
        }
        cp_dst_ram_type:        coverpoint ral.nvdla.NVDLA_CDP.D_DST_DMA_CFG.DST_RAM_TYPE.value iff (1 == ral.nvdla.NVDLA_CDP.D_OP_ENABLE.OP_EN.value) {
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
            bins CV = {dst_ram_type_CV};
`endif
            bins MC = {dst_ram_type_MC};
        }
        cp_dst_end_addr:        coverpoint ((64'h1+ral.nvdla.NVDLA_CDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.value+{ral.nvdla.NVDLA_CDP.D_DST_BASE_ADDR_HIGH.DST_BASE_ADDR_HIGH.value, ral.nvdla.NVDLA_CDP.D_DST_BASE_ADDR_LOW.DST_BASE_ADDR_LOW.value})%8) iff (1 == ral.nvdla.NVDLA_CDP.D_OP_ENABLE.OP_EN.value) {
            bins diff[`CDP_COV_BIN_NUM_DEFAULT]         = {['h0:3'h7]};
        }

        // Processing precision
        cp_precision:           coverpoint ral.nvdla.NVDLA_CDP.D_DATA_FORMAT.INPUT_DATA_TYPE.value iff (1 == ral.nvdla.NVDLA_CDP.D_OP_ENABLE.OP_EN.value) {
            bins INT8   = {input_data_type_INT8};
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            bins INT16  = {input_data_type_INT16};
            bins FP16   = {input_data_type_FP16};
`endif
        }

        // LRN algorithm setting
        cp_normalized_length:   coverpoint ral.nvdla.NVDLA_CDP.D_LRN_CFG.NORMALZ_LEN.value iff (1 == ral.nvdla.NVDLA_CDP.D_OP_ENABLE.OP_EN.value) {
            bins LEN3   = {normalz_len_LEN3};
            bins LEN5   = {normalz_len_LEN5};
            bins LEN7   = {normalz_len_LEN7};
            bins LEN9   = {normalz_len_LEN9};
        }

        // Floating point settings
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
        cp_nan_to_zero:         coverpoint ral.nvdla.NVDLA_CDP.D_NAN_FLUSH_TO_ZERO.NAN_TO_ZERO.value iff ((input_data_type_FP16 == ral.nvdla.NVDLA_CDP.D_DATA_FORMAT.INPUT_DATA_TYPE.value) && (1 == ral.nvdla.NVDLA_CDP.D_OP_ENABLE.OP_EN.value)) {
            bins DISABLE = {nan_to_zero_DISABLE};
            bins ENABLE  = {nan_to_zero_ENABLE};
        }
`endif

        // Input data conversion, data convertor settings are ignored in FP16
        cp_datin_offset:        coverpoint ral.nvdla.NVDLA_CDP.D_DATIN_OFFSET.DATIN_OFFSET.value iff (input_data_type_FP16 != ral.nvdla.NVDLA_CDP.D_DATA_FORMAT.INPUT_DATA_TYPE.value) {
            bins full_pos_int8[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: 7'h7F]};
            bins full_neg_int8[`CDP_COV_BIN_NUM_DEFAULT]   = {[16'hFF80: 16'hFFFF]};
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            bins full[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: 16'hFFFF]};
`endif
        }
        cp_datin_scale:         coverpoint ral.nvdla.NVDLA_CDP.D_DATIN_SCALE.DATIN_SCALE.value iff (1 == ral.nvdla.NVDLA_CDP.D_OP_ENABLE.OP_EN.value) {
            bins full[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: 16'hFFFF]};
        }
        cp_datin_shifter:       coverpoint ral.nvdla.NVDLA_CDP.D_DATIN_SHIFTER.DATIN_SHIFTER.value iff (1 == ral.nvdla.NVDLA_CDP.D_OP_ENABLE.OP_EN.value) {
            bins full[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: 5'h1F]};
        }

        // Output data conversion, data convertor settings are ignored in FP16
        cp_datout_offset:       coverpoint ral.nvdla.NVDLA_CDP.D_DATOUT_OFFSET.DATOUT_OFFSET.value iff ((input_data_type_FP16 != ral.nvdla.NVDLA_CDP.D_DATA_FORMAT.INPUT_DATA_TYPE.value) && (1 == ral.nvdla.NVDLA_CDP.D_OP_ENABLE.OP_EN.value)) {
            bins full_pos_int8[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: 24'hFF_FFFF]};
            bins full_neg_int8[`CDP_COV_BIN_NUM_DEFAULT]   = {[32'hFF00_0000: 32'hFFFF_FFFF]};
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            bins full[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: 32'hFFFF_FFFF]};
`endif
        }
        cp_datout_scale:        coverpoint ral.nvdla.NVDLA_CDP.D_DATOUT_SCALE.DATOUT_SCALE.value iff (1 == ral.nvdla.NVDLA_CDP.D_OP_ENABLE.OP_EN.value) {
            bins full[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: 16'hFFFF]};
        }
        cp_datout_shifter:      coverpoint ral.nvdla.NVDLA_CDP.D_DATOUT_SHIFTER.DATOUT_SHIFTER.value iff (1 == ral.nvdla.NVDLA_CDP.D_OP_ENABLE.OP_EN.value) {
            bins full[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: 5'h1F]};
        }

        // Cross points
        cr_src_addr_low_ram_type:   cross cp_src_base_addr_low, cp_src_ram_type;
        cr_dst_addr_low_ram_type:   cross cp_dst_base_addr_low, cp_dst_ram_type;
`ifdef MEM_ADDR_WIDTH_GT_32
        cr_src_addr_high_ram_type:  cross cp_src_base_addr_high, cp_src_ram_type;
        cr_dst_addr_high_ram_type:  cross cp_dst_base_addr_high, cp_dst_ram_type;
`endif
        cr_src_dst_ram_type:        cross cp_src_ram_type, cp_dst_ram_type;
        cr_precsion_datin_offset:   cross cp_precision, cp_datin_offset {
            ignore_bins int8_not_used_bits =binsof(cp_precision) intersect {input_data_type_INT8} && binsof (cp_datin_offset) intersect {[16'h100: 16'hFFFF]};
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            ignore_bins not_working_in_FP16=binsof(cp_precision) intersect {input_data_type_FP16};
`endif
        }
        cr_precsion_datin_scale:    cross cp_precision, cp_datin_scale {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            ignore_bins not_working_in_FP16=binsof(cp_precision) intersect {input_data_type_FP16};
`endif
        }
        cr_precsion_datin_shifter:  cross cp_precision, cp_datin_shifter {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            ignore_bins not_working_in_FP16=binsof(cp_precision) intersect {input_data_type_FP16};
`endif
        }
        cr_precsion_datout_offset:  cross cp_precision, cp_datout_offset {
            ignore_bins int8_not_used_bits =binsof(cp_precision) intersect {input_data_type_INT8} && binsof (cp_datout_offset) intersect {['h200000: $]};
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            ignore_bins not_working_in_FP16=binsof(cp_precision) intersect {input_data_type_FP16};
`endif
        }
        cr_precsion_datout_scale:   cross cp_precision, cp_datout_scale {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            ignore_bins not_working_in_FP16=binsof(cp_precision) intersect {input_data_type_FP16};
`endif
        }
        cr_precsion_datout_shifter: cross cp_precision, cp_datout_shifter {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            ignore_bins not_working_in_FP16=binsof(cp_precision) intersect {input_data_type_FP16};
`endif
        }
    endgroup : cdp_cg

    covergroup cdp_lut_cg;
        cp_lut_table_id:        coverpoint ral.nvdla.NVDLA_CDP.S_LUT_ACCESS_CFG.LUT_TABLE_ID.value {
            bins le = {0};
            bins lo = {1};
        }
        // cp_lut_addr:            coverpoint ral.nvdla.NVDLA_CDP.S_LUT_ACCESS_CFG.LUT_ADDR.value {
        //     bins le_addr[] = {[0:64]};
        //     bins lo_addr[] = {[65:256]};
        // }
        // cr_lut_table_id_lut_addr:    cross cp_lut_table_id, cp_lut_addr {
        //     ignore_bins no_use_addr = binsof(cp_lut_table_id.le) && binsof(cp_lut_addr.lo_addr);
        // }
        cp_lut_access_type:     coverpoint ral.nvdla.NVDLA_CDP.S_LUT_ACCESS_CFG.LUT_ACCESS_TYPE.value {
            bins read  = {0};
            bins write = {1};
        }
        // cr_lut_table_id_lut_addr_lut_access_type:  cross cp_lut_table_id, cp_lut_addr, cp_lut_access_type {
        //     ignore_bins no_use_addr = binsof(cp_lut_table_id.le) && binsof(cp_lut_addr.lo_addr);
        // }
        cp_lut_le_function:     coverpoint ral.nvdla.NVDLA_CDP.S_LUT_CFG.LUT_LE_FUNCTION.value {
            bins exponent = {0};
            bins linear   = {1};
        }
        cr_lut_table_id_lut_le_function: cross cp_lut_table_id, cp_lut_le_function {
            ignore_bins lo = binsof(cp_lut_table_id.lo);
        }
        cp_lut_le_index_offset:     coverpoint signed'(ral.nvdla.NVDLA_CDP.S_LUT_INFO.LUT_LE_INDEX_OFFSET.value[7:0]) {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            bins range[8] = {[-126:127]};
`else
            bins range[8] = {[-64:20]};
`endif
        }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
        cp_lut_le_index_select:     coverpoint signed'(ral.nvdla.NVDLA_CDP.S_LUT_INFO.LUT_LE_INDEX_SELECT.value[6:0]) {
            bins range[8] = {[-6:31]};
`else
        cp_lut_le_index_select:     coverpoint signed'(ral.nvdla.NVDLA_CDP.S_LUT_INFO.LUT_LE_INDEX_SELECT.value[5:0]) {
            bins range[8] = {[-6:15]};
`endif
        }
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
        cp_lut_lo_index_select:     coverpoint signed'(ral.nvdla.NVDLA_CDP.S_LUT_INFO.LUT_LO_INDEX_SELECT.value[6:0]) {
            bins range[8] = {[-8:29]};
`else
        cp_lut_lo_index_select:     coverpoint signed'(ral.nvdla.NVDLA_CDP.S_LUT_INFO.LUT_LO_INDEX_SELECT.value[5:0]) {
            bins range[8] = {[-8:13]};
`endif
        }
        cp_lut_le_start_high:       coverpoint ral.nvdla.NVDLA_CDP.S_LUT_LE_START_HIGH.LUT_LE_START_HIGH.value {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT8
            bins pos = {0};
            bins neg = {6'h3F};
`elsif NVDLA_FEATURE_DATA_TYPE_INT16 // FIXME: Need add this macro
            bins range[8] = {[6'h0:6'h3F]};
`else
            bins pos = {0};
            bins neg = {6'h3F};
`endif
        }
        cp_lut_le_start_low:        coverpoint ral.nvdla.NVDLA_CDP.S_LUT_LE_START_LOW.LUT_LE_START_LOW.value {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT8
            bins full_pos_int8[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: 'h1F_FFFF]};
            bins full_neg_int8[`CDP_COV_BIN_NUM_DEFAULT]   = {['hFFE0_0000: 'hFFFF_FFFF]};
`else
            bins range[8] = {[32'h0:32'hFFFF_FFFF]};
`endif
        }
        cp_lut_le_end_high:         coverpoint ral.nvdla.NVDLA_CDP.S_LUT_LE_END_HIGH.LUT_LE_END_HIGH.value {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT8
            bins pos = {0};
            bins neg = {6'h3F};
`elsif NVDLA_FEATURE_DATA_TYPE_INT16 // FIXME: Need add this macro
            bins range[8] = {[6'h0:6'h3F]};
`else
            bins pos = {0};
            bins neg = {6'h3F};
`endif
        }
        cp_lut_le_end_low:          coverpoint ral.nvdla.NVDLA_CDP.S_LUT_LE_END_LOW.LUT_LE_END_LOW.value {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT8
            bins full_pos_int8[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: 'h1F_FFFF]};
            bins full_neg_int8[`CDP_COV_BIN_NUM_DEFAULT]   = {['hFFE0_0000: 'hFFFF_FFFF]};
`else
            bins range[8] = {[32'h0:32'hFFFF_FFFF]};
`endif
        }
        cp_lut_lo_start_high:       coverpoint ral.nvdla.NVDLA_CDP.S_LUT_LO_START_HIGH.LUT_LO_START_HIGH.value {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT8
            bins pos = {0};
            bins neg = {6'h3F};
`elsif NVDLA_FEATURE_DATA_TYPE_INT16 // FIXME: Need add this macro
            bins range[8] = {[6'h0:6'h3F]};
`else
            bins pos = {0};
            bins neg = {6'h3F};
`endif
        }
        cp_lut_lo_start_low:        coverpoint ral.nvdla.NVDLA_CDP.S_LUT_LO_START_LOW.LUT_LO_START_LOW.value {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT8
            bins full_pos_int8[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: 'h1F_FFFF]};
            bins full_neg_int8[`CDP_COV_BIN_NUM_DEFAULT]   = {['hFFE0_0000: 'hFFFF_FFFF]};
`else
            bins range[8] = {[32'h0:32'hFFFF_FFFF]};
`endif
        }
        cp_lut_lo_end_high:         coverpoint ral.nvdla.NVDLA_CDP.S_LUT_LO_END_HIGH.LUT_LO_END_HIGH.value {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT8
            bins pos = {0};
            bins neg = {6'h3F};
`elsif NVDLA_FEATURE_DATA_TYPE_INT16 // FIXME: Need add this macro
            bins range[8] = {[6'h0:6'h3F]};
`else
            bins pos = {0};
            bins neg = {6'h3F};
`endif
        }
        cp_lut_lo_end_low:          coverpoint ral.nvdla.NVDLA_CDP.S_LUT_LO_END_LOW.LUT_LO_END_LOW.value {
`ifdef NVDLA_FEATURE_DATA_TYPE_INT8
            bins full_pos_int8[`CDP_COV_BIN_NUM_DEFAULT]   = {['h0: 'h1F_FFFF]};
            bins full_neg_int8[`CDP_COV_BIN_NUM_DEFAULT]   = {['hFFE0_0000: 'hFFFF_FFFF]};
`else
            bins range[8] = {[32'h0:32'hFFFF_FFFF]};
`endif
        }
        cp_lut_le_slope_uflow_scale:coverpoint ral.nvdla.NVDLA_CDP.S_LUT_LE_SLOPE_SCALE.LUT_LE_SLOPE_UFLOW_SCALE.value {
            bins range[8]       = {[16'h0   :16'hFFFF]};
            bins pos_max_range  = {[16'h7FF0:16'h7FFF]};
            bins neg_max_range  = {[16'h8000:16'h800F]};
        }
        cp_lut_le_slope_oflow_scale:coverpoint ral.nvdla.NVDLA_CDP.S_LUT_LE_SLOPE_SCALE.LUT_LE_SLOPE_OFLOW_SCALE.value {
            bins range[8]       = {[16'h0   :16'hFFFF]};
            bins pos_max_range  = {[16'h7FF0:16'h7FFF]};
            bins neg_max_range  = {[16'h8000:16'h800F]};
        }
        cp_lut_le_slope_uflow_shift:coverpoint ral.nvdla.NVDLA_CDP.S_LUT_LE_SLOPE_SHIFT.LUT_LE_SLOPE_UFLOW_SHIFT.value {
            bins range[8]       = {[5'h0    :5'h1F]};
        }
        cp_lut_le_slope_oflow_shift:coverpoint ral.nvdla.NVDLA_CDP.S_LUT_LE_SLOPE_SHIFT.LUT_LE_SLOPE_OFLOW_SHIFT.value {
            bins range[8]       = {[5'h0    :5'h1F]};
        }
        cp_lut_lo_slope_uflow_scale:coverpoint ral.nvdla.NVDLA_CDP.S_LUT_LO_SLOPE_SCALE.LUT_LO_SLOPE_UFLOW_SCALE.value {
            bins range[8]       = {[16'h0   :16'hFFFF]};
            bins pos_max_range  = {[16'h7FF0:16'h7FFF]};
            bins neg_max_range  = {[16'h8000:16'h800F]};
        }
        cp_lut_lo_slope_oflow_scale:coverpoint ral.nvdla.NVDLA_CDP.S_LUT_LO_SLOPE_SCALE.LUT_LO_SLOPE_OFLOW_SCALE.value {
            bins range[8]       = {[16'h0   :16'hFFFF]};
            bins pos_max_range  = {[16'h7FF0:16'h7FFF]};
            bins neg_max_range  = {[16'h8000:16'h800F]};
        }
        cp_lut_lo_slope_uflow_shift:coverpoint ral.nvdla.NVDLA_CDP.S_LUT_LO_SLOPE_SHIFT.LUT_LO_SLOPE_UFLOW_SHIFT.value {
            bins range[8]       = {[5'h0    :5'h1F]};
        }
        cp_lut_lo_slope_oflow_shift:coverpoint ral.nvdla.NVDLA_CDP.S_LUT_LO_SLOPE_SHIFT.LUT_LO_SLOPE_OFLOW_SHIFT.value {
            bins range[8]       = {[5'h0    :5'h1F]};
        }
        cr_lut_table_id_lut_le_function_lut_le_index_offset: cross cp_lut_table_id, cp_lut_le_function, cp_lut_le_index_offset {
            ignore_bins lo     = binsof(cp_lut_table_id.lo);
            ignore_bins linear = binsof(cp_lut_le_function.linear);
        }
        cr_lut_table_id_lut_le_function_lut_le_index_select: cross cp_lut_table_id, cp_lut_le_function, cp_lut_le_index_select {
            ignore_bins lo       = binsof(cp_lut_table_id.lo);
            ignore_bins exponent = binsof(cp_lut_le_function.exponent);
        }
        cr_lut_table_id_lut_le_function_lut_lo_index_select: cross cp_lut_table_id, cp_lut_le_function, cp_lut_lo_index_select {
            ignore_bins le       = binsof(cp_lut_table_id.le);
            ignore_bins exponent = binsof(cp_lut_le_function.exponent);
        }
        cp_lut_uflow_priority:      coverpoint ral.nvdla.NVDLA_CDP.S_LUT_CFG.LUT_UFLOW_PRIORITY.value {
            bins le = {0};
            bins lo = {1};
        }
        cp_lut_oflow_priority:      coverpoint ral.nvdla.NVDLA_CDP.S_LUT_CFG.LUT_OFLOW_PRIORITY.value {
            bins le = {0};
            bins lo = {1};
        }
        cp_lut_hybrid_priority:      coverpoint ral.nvdla.NVDLA_CDP.S_LUT_CFG.LUT_OFLOW_PRIORITY.value {
            bins le = {0};
            bins lo = {1};
        }

    endgroup : cdp_lut_cg

    function void cdp_toggle_sample();
        tg_cdp_cube_width.sample(ral.nvdla.NVDLA_CDP_RDMA.D_DATA_CUBE_WIDTH.WIDTH.value);
        tg_cdp_cube_height.sample(ral.nvdla.NVDLA_CDP_RDMA.D_DATA_CUBE_HEIGHT.HEIGHT.value);
        tg_cdp_cube_channel.sample(ral.nvdla.NVDLA_CDP_RDMA.D_DATA_CUBE_CHANNEL.CHANNEL.value);
        tg_cdp_src_base_addr_low.sample(ral.nvdla.NVDLA_CDP_RDMA.D_SRC_BASE_ADDR_LOW.SRC_BASE_ADDR_LOW.value);
`ifdef MEM_ADDR_WIDTH_GT_32
        tg_cdp_src_base_addr_high.sample(ral.nvdla.NVDLA_CDP_RDMA.D_SRC_BASE_ADDR_HIGH.SRC_BASE_ADDR_HIGH.value);
`endif
        tg_cdp_src_line_stride.sample(ral.nvdla.NVDLA_CDP_RDMA.D_SRC_LINE_STRIDE.SRC_LINE_STRIDE.value);
        tg_cdp_src_surface_stride.sample(ral.nvdla.NVDLA_CDP_RDMA.D_SRC_SURFACE_STRIDE.SRC_SURFACE_STRIDE.value);
        tg_cdp_dst_base_addr_low.sample(ral.nvdla.NVDLA_CDP.D_DST_BASE_ADDR_LOW.DST_BASE_ADDR_LOW.value);
`ifdef MEM_ADDR_WIDTH_GT_32
        tg_cdp_dst_base_addr_high.sample(ral.nvdla.NVDLA_CDP.D_DST_BASE_ADDR_HIGH.DST_BASE_ADDR_HIGH.value);
`endif
        tg_cdp_dst_line_stride.sample(ral.nvdla.NVDLA_CDP.D_DST_LINE_STRIDE.DST_LINE_STRIDE.value);
        tg_cdp_dst_surface_stride.sample(ral.nvdla.NVDLA_CDP.D_DST_SURFACE_STRIDE.DST_SURFACE_STRIDE.value);
    endfunction : cdp_toggle_sample

    function void cdp_lut_toggle_sample();
        if(ral.nvdla.NVDLA_CDP.S_LUT_CFG.LUT_LE_FUNCTION.value == 0) begin // le table && exponent function
            tg_cdp_lut_le_index_offset.sample(ral.nvdla.NVDLA_CDP.S_LUT_INFO.LUT_LE_INDEX_OFFSET.value);
        end
        if(ral.nvdla.NVDLA_CDP.S_LUT_CFG.LUT_LE_FUNCTION.value == 1) begin // le table && linear function
            tg_cdp_lut_le_index_select.sample(ral.nvdla.NVDLA_CDP.S_LUT_INFO.LUT_LE_INDEX_SELECT.value);
        end
        tg_cdp_lut_lo_index_select.sample(ral.nvdla.NVDLA_CDP.S_LUT_INFO.LUT_LO_INDEX_SELECT.value);
        tg_cdp_lut_le_start_low.sample(ral.nvdla.NVDLA_CDP.S_LUT_LE_START_LOW.LUT_LE_START_LOW.value);
        tg_cdp_lut_le_start_high.sample(ral.nvdla.NVDLA_CDP.S_LUT_LE_START_HIGH.LUT_LE_START_HIGH.value);
        tg_cdp_lut_le_end_low.sample(ral.nvdla.NVDLA_CDP.S_LUT_LE_END_LOW.LUT_LE_END_LOW.value);
        tg_cdp_lut_le_end_high.sample(ral.nvdla.NVDLA_CDP.S_LUT_LE_END_HIGH.LUT_LE_END_HIGH.value);
        tg_cdp_lut_lo_start_low.sample(ral.nvdla.NVDLA_CDP.S_LUT_LO_START_LOW.LUT_LO_START_LOW.value);
        tg_cdp_lut_lo_start_high.sample(ral.nvdla.NVDLA_CDP.S_LUT_LO_START_HIGH.LUT_LO_START_HIGH.value);
        tg_cdp_lut_lo_end_low.sample(ral.nvdla.NVDLA_CDP.S_LUT_LO_END_LOW.LUT_LO_END_LOW.value);
        tg_cdp_lut_lo_end_high.sample(ral.nvdla.NVDLA_CDP.S_LUT_LO_END_HIGH.LUT_LO_END_HIGH.value);
        tg_cdp_lut_le_slope_uflow_scale.sample(ral.nvdla.NVDLA_CDP.S_LUT_LE_SLOPE_SCALE.LUT_LE_SLOPE_UFLOW_SCALE.value);
        tg_cdp_lut_le_slope_oflow_scale.sample(ral.nvdla.NVDLA_CDP.S_LUT_LE_SLOPE_SCALE.LUT_LE_SLOPE_OFLOW_SCALE.value);
        tg_cdp_lut_le_slope_uflow_shift.sample(ral.nvdla.NVDLA_CDP.S_LUT_LE_SLOPE_SHIFT.LUT_LE_SLOPE_UFLOW_SHIFT.value);
        tg_cdp_lut_le_slope_oflow_shift.sample(ral.nvdla.NVDLA_CDP.S_LUT_LE_SLOPE_SHIFT.LUT_LE_SLOPE_OFLOW_SHIFT.value);
        tg_cdp_lut_lo_slope_uflow_scale.sample(ral.nvdla.NVDLA_CDP.S_LUT_LO_SLOPE_SCALE.LUT_LO_SLOPE_UFLOW_SCALE.value);
        tg_cdp_lut_lo_slope_oflow_scale.sample(ral.nvdla.NVDLA_CDP.S_LUT_LO_SLOPE_SCALE.LUT_LO_SLOPE_OFLOW_SCALE.value);
        tg_cdp_lut_lo_slope_uflow_shift.sample(ral.nvdla.NVDLA_CDP.S_LUT_LO_SLOPE_SHIFT.LUT_LO_SLOPE_UFLOW_SHIFT.value);
        tg_cdp_lut_lo_slope_oflow_shift.sample(ral.nvdla.NVDLA_CDP.S_LUT_LO_SLOPE_SHIFT.LUT_LO_SLOPE_OFLOW_SHIFT.value);
    endfunction : cdp_lut_toggle_sample

endclass : cdp_cov_pool

