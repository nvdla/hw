// PDP unit coverage

class pdp_cov_pool extends nvdla_coverage_base;

    // enum define
    //:| import spec2constrain
    //:| global spec2cons
    //:| spec2cons = spec2constrain.Spec2Cons()
    //:| spec2cons.enum_gen(['NVDLA_PDP', 'NVDLA_PDP_RDMA'])

    bit_toggle_cg    tg_pdp_flds[string];
    bit_toggle_cg    tg_pdp_rdma_flds[string];

    function new(string name, ral_sys_top ral);
        uvm_reg       regs[$];
        uvm_reg_field flds[$];
        super.new(name, ral);

        pdp_cg = new();

        ral.nvdla.NVDLA_PDP.get_registers(regs);
        foreach(regs[i]) begin
            if(regs[i].get_rights() == "RW") begin
                regs[i].get_fields(flds);
                foreach(flds[j]) begin
                    name              = flds[j].get_name();
`ifndef MEM_ADDR_WIDTH_GT_32
                    if(name == "SRC_BASE_ADDR_HIGH" || 
                       name == "DST_BASE_ADDR_HIGH") continue;
`endif
                    tg_pdp_flds[name] = new({"tg_pdp_",name.tolower()}, flds[j].get_n_bits());
                end
                flds.delete();
            end
        end
        regs.delete();
        ral.nvdla.NVDLA_PDP_RDMA.get_registers(regs);
        foreach(regs[i]) begin
            if(regs[i].get_rights() == "RW") begin
                regs[i].get_fields(flds);
                foreach(flds[j]) begin
                    name                   = flds[j].get_name();
                    tg_pdp_rdma_flds[name] = new({"tg_pdp_rdma_",name.tolower()}, flds[j].get_n_bits());
                end
                flds.delete();
            end
        end
        regs.delete();
    endfunction : new

    task sample();
        `uvm_info(tID, $sformatf("Sample Begin ..."), UVM_LOW)
        pdp_toggle_sample();    // Sample toggle coverage
        pdp_cg.sample();        // Sample coverage group
    endtask : sample

    // Write individual coverpoint first
    // Divide into small covergroups later
    covergroup pdp_cg;

        // Cube in size
        cp_cube_in_width:          coverpoint ral.nvdla.NVDLA_PDP.D_DATA_CUBE_IN_WIDTH.CUBE_IN_WIDTH.value iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value) {
            bins zero       = {'h0};
            bins max        = {'h1FFF};
            bins low        = {['h0   :'hF]};
            bins middle     = {['h10  :'h3F]};
            bins high       = {['h40  :'hFFF]};
            bins extreme    = {['h1000:'h1FFF]};
            bins full[`PDP_COV_BIN_NUM_DEFAULT]     = {['h0   :'h1FFF]};
        }
        cp_cube_in_height:         coverpoint ral.nvdla.NVDLA_PDP.D_DATA_CUBE_IN_HEIGHT.CUBE_IN_HEIGHT.value iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value) {
            bins zero       = {'h0};
            bins max        = {'h1FFF};
            bins low        = {['h0   :'hF]};
            bins middle     = {['h10  :'h3F]};
            bins high       = {['h40  :'hFFF]};
            bins extreme    = {['h1000:'h1FFF]};
            bins full[`PDP_COV_BIN_NUM_DEFAULT]   = {['h0   :'h1FFF]};
        }
        cp_cube_in_channel:        coverpoint ral.nvdla.NVDLA_PDP.D_DATA_CUBE_IN_CHANNEL.CUBE_IN_CHANNEL.value iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value) {
            bins zero       = {'h0};
            bins max        = {'h1FFF};
            bins low        = {['h0   :'hF]};
            bins middle     = {['h10  :'h3F]};
            bins high       = {['h40  :'hFFF]};
            bins extreme    = {['h1000:'h1FFF]};
            bins full[`PDP_COV_BIN_NUM_DEFAULT]   = {['h0   :'h1FFF]};
        }
        cp_src_ram_type:        coverpoint ral.nvdla.NVDLA_PDP_RDMA.D_SRC_RAM_CFG.SRC_RAM_TYPE.value iff (1 == ral.nvdla.NVDLA_PDP_RDMA.D_OP_ENABLE.OP_EN.value) {
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
            bins CV = {src_ram_type_CV};
`endif
            bins MC = {src_ram_type_MC};
        }

        // Source/Input memory settings
        cp_src_base_addr_low:   coverpoint ral.nvdla.NVDLA_PDP_RDMA.D_SRC_BASE_ADDR_LOW.SRC_BASE_ADDR_LOW.value[31:5] iff (1 == ral.nvdla.NVDLA_PDP_RDMA.D_OP_ENABLE.OP_EN.value) {
            wildcard bins align_64  = {27'b??????????????????????????0};
            wildcard bins align_128 = {27'b?????????????????????????00};
            wildcard bins align_256 = {27'b????????????????????????000};
            bins full[`PDP_COV_BIN_NUM_DEFAULT]      = {['h0: `MAX_VALUE_27BITS]};
        }
`ifdef MEM_ADDR_WIDTH_GT_32
        cp_src_base_addr_high:  coverpoint ral.nvdla.NVDLA_PDP_RDMA.D_SRC_BASE_ADDR_HIGH.SRC_BASE_ADDR_HIGH.value[`NVDLA_MEM_ADDRESS_WIDTH-32-1:0] iff (1 == ral.nvdla.NVDLA_PDP_RDMA.D_OP_ENABLE.OP_EN.value) {
            bins full[`PDP_COV_BIN_NUM_DEFAULT]      = {['h0: `MAX_VALUE_8BITS]};
        }
`endif
//      cp_src_line_stride:     coverpoint ral.nvdla.NVDLA_PDP_RDMA.D_SRC_LINE_STRIDE.SRC_LINE_STRIDE.value[31:5] iff (1 == ral.nvdla.NVDLA_PDP_RDMA.D_OP_ENABLE.OP_EN.value) {
//          bins full[`PDP_COV_BIN_NUM_DEFAULT]      = {['h0: `MAX_VALUE_27BITS]};
//      }
//      cp_src_surface_stride:  coverpoint ral.nvdla.NVDLA_PDP_RDMA.D_SRC_SURFACE_STRIDE.SRC_SURFACE_STRIDE.value[31:5] iff (1 == ral.nvdla.NVDLA_PDP_RDMA.D_OP_ENABLE.OP_EN.value) {
//          bins full[`PDP_COV_BIN_NUM_DEFAULT]      = {['h0: `MAX_VALUE_27BITS]};
//      }
        cp_src_line_stride_size_split_disable_diff: coverpoint ((ral.nvdla.NVDLA_PDP_RDMA.D_SRC_LINE_STRIDE.SRC_LINE_STRIDE.value - ral.nvdla.NVDLA_PDP_RDMA.D_DATA_CUBE_IN_WIDTH.CUBE_IN_WIDTH.value - 64'h1)%8) iff ((0 == ral.nvdla.NVDLA_PDP_RDMA.D_OPERATION_MODE_CFG.SPLIT_NUM.value) && (1 == ral.nvdla.NVDLA_PDP_RDMA.D_OP_ENABLE.OP_EN.value)) {
            bins diff[`PDP_COV_BIN_NUM_DEFAULT]         = {['h0:3'h7]};
        }
        cp_src_line_stride_size_split_enable_diff:  coverpoint ((ral.nvdla.NVDLA_PDP_RDMA.D_SRC_LINE_STRIDE.SRC_LINE_STRIDE.value - ral.nvdla.NVDLA_PDP_RDMA.D_PARTIAL_WIDTH_IN.PARTIAL_WIDTH_IN_FIRST.value - ral.nvdla.NVDLA_PDP_RDMA.D_PARTIAL_WIDTH_IN.PARTIAL_WIDTH_IN_MID.value*(ral.nvdla.NVDLA_PDP.D_OPERATION_MODE_CFG.SPLIT_NUM.value - 64'h1) - ral.nvdla.NVDLA_PDP_RDMA.D_PARTIAL_WIDTH_IN.PARTIAL_WIDTH_IN_LAST.value - 64'h1)%8) iff ((1 < ral.nvdla.NVDLA_PDP_RDMA.D_OPERATION_MODE_CFG.SPLIT_NUM.value) && (1 == ral.nvdla.NVDLA_PDP_RDMA.D_OP_ENABLE.OP_EN.value)) {
            bins diff[`PDP_COV_BIN_NUM_DEFAULT]         = {['h0:'h7]};
        }
        // Cross points
        cr_src_addr_low_ram_type:   cross cp_src_base_addr_low,cp_src_ram_type;
`ifdef MEM_ADDR_WIDTH_GT_32
        cr_src_addr_high_ram_type:  cross cp_src_base_addr_high,cp_src_ram_type;
`endif

        // Cube out size
        cp_cube_out_width:          coverpoint ral.nvdla.NVDLA_PDP.D_DATA_CUBE_OUT_WIDTH.CUBE_OUT_WIDTH.value iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value) {
            bins zero       = {'h0};
            bins max        = {'h1FFF};
            bins low        = {['h0   :'hF]};
            bins middle     = {['h10  :'h3F]};
            bins high       = {['h40  :'hFFF]};
            bins extreme    = {['h1000:'h1FFF]};
            bins full[`PDP_COV_BIN_NUM_DEFAULT]   = {['h0   :'h1FFF]};
        }
        cp_cube_out_height:         coverpoint ral.nvdla.NVDLA_PDP.D_DATA_CUBE_OUT_HEIGHT.CUBE_OUT_HEIGHT.value iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value) {
            bins zero       = {'h0};
            bins max        = {'h1FFF};
            bins low        = {['h0   :'hF]};
            bins middle     = {['h10  :'h3F]};
            bins high       = {['h40  :'hFFF]};
            bins extreme    = {['h1000:'h1FFF]};
            bins full[`PDP_COV_BIN_NUM_DEFAULT]   = {['h0   :'h1FFF]};
        }
        cp_cube_out_channel:        coverpoint ral.nvdla.NVDLA_PDP.D_DATA_CUBE_OUT_CHANNEL.CUBE_OUT_CHANNEL.value iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value) {
            bins zero       = {'h0};
            bins max        = {'h1FFF};
            bins low        = {['h0   :'hF]};
            bins middle     = {['h10  :'h3F]};
            bins high       = {['h40  :'hFFF]};
            bins extreme    = {['h1000:'h1FFF]};
            bins full[`PDP_COV_BIN_NUM_DEFAULT]   = {['h0   :'h1FFF]};
        }
        cp_dst_ram_type:        coverpoint ral.nvdla.NVDLA_PDP.D_DST_RAM_CFG.DST_RAM_TYPE.value iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value) {
`ifdef NVDLA_SECONDARY_MEMIF_ENABLE
            bins CV = {dst_ram_type_CV};
`endif
            bins MC = {dst_ram_type_MC};
        }

        // Source/Input memory settings
        cp_dst_base_addr_low:   coverpoint ral.nvdla.NVDLA_PDP.D_DST_BASE_ADDR_LOW.DST_BASE_ADDR_LOW.value[31:5] iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value) {
            wildcard bins align_64  = {27'b??????????????????????????0};
            wildcard bins align_128 = {27'b?????????????????????????00};
            wildcard bins align_256 = {27'b????????????????????????000};
            bins full[`PDP_COV_BIN_NUM_DEFAULT]       = {['h0: `MAX_VALUE_27BITS]};
        }
`ifdef MEM_ADDR_WIDTH_GT_32
        cp_dst_base_addr_high:  coverpoint ral.nvdla.NVDLA_PDP.D_DST_BASE_ADDR_HIGH.DST_BASE_ADDR_HIGH.value[`NVDLA_MEM_ADDRESS_WIDTH-32-1:0] iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value) {
            bins full[`PDP_COV_BIN_NUM_DEFAULT]       = {['h0: `MAX_VALUE_8BITS]};
        }
`endif
//      cp_dst_line_stride:     coverpoint ral.nvdla.NVDLA_PDP.D_DST_LINE_STRIDE.DST_LINE_STRIDE.value[31:5] iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value) {
//          bins full[`PDP_COV_BIN_NUM_DEFAULT]       = {['h0: `MAX_VALUE_27BITS]};
//      }
//      cp_dst_surface_stride:  coverpoint ral.nvdla.NVDLA_PDP.D_DST_SURFACE_STRIDE.DST_SURFACE_STRIDE.value[31:5] iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value) {
//          bins full[`PDP_COV_BIN_NUM_DEFAULT]       = {['h0: `MAX_VALUE_27BITS]};
//      }
        cp_dst_line_stride_size_split_disable_diff: coverpoint ((ral.nvdla.NVDLA_PDP.D_DST_LINE_STRIDE.DST_LINE_STRIDE.value - ral.nvdla.NVDLA_PDP.D_DATA_CUBE_OUT_WIDTH.CUBE_OUT_WIDTH.value - 64'h1)%8) iff ((0 == ral.nvdla.NVDLA_PDP.D_OPERATION_MODE_CFG.SPLIT_NUM.value) && (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value)) {
            bins diff[`PDP_COV_BIN_NUM_DEFAULT]         = {['h0:3'h7]};
        }
        cp_dst_line_stride_size_split_enable_diff:  coverpoint ((ral.nvdla.NVDLA_PDP.D_DST_LINE_STRIDE.DST_LINE_STRIDE.value - ral.nvdla.NVDLA_PDP.D_PARTIAL_WIDTH_OUT.PARTIAL_WIDTH_OUT_FIRST.value - ral.nvdla.NVDLA_PDP.D_PARTIAL_WIDTH_OUT.PARTIAL_WIDTH_OUT_MID.value*(ral.nvdla.NVDLA_PDP.D_OPERATION_MODE_CFG.SPLIT_NUM.value - 64'h1) - ral.nvdla.NVDLA_PDP.D_PARTIAL_WIDTH_OUT.PARTIAL_WIDTH_OUT_LAST.value - 64'h1)%8) iff ((1 < ral.nvdla.NVDLA_PDP.D_OPERATION_MODE_CFG.SPLIT_NUM.value) && (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value)) {
            bins diff[`PDP_COV_BIN_NUM_DEFAULT]         = {['h0:3'h7]};
        }
        // Cross points
        cr_dst_addr_low_ram_type:   cross cp_dst_base_addr_low,cp_dst_ram_type;
`ifdef MEM_ADDR_WIDTH_GT_32
        cr_dst_addr_high_ram_type:  cross cp_dst_base_addr_high,cp_dst_ram_type;
`endif

        // Flying mode
        cp_flying_mode:         coverpoint (ral.nvdla.NVDLA_PDP.D_OPERATION_MODE_CFG.FLYING_MODE.value) iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value) {
            bins ON_FLYING  = {flying_mode_ON_FLYING};
            bins OFF_FLYING = {flying_mode_OFF_FLYING};
        }

        // Precision setting
        cp_precision:           coverpoint ral.nvdla.NVDLA_PDP.D_DATA_FORMAT.INPUT_DATA.value iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value) {
            bins INT8       = {input_data_INT8};
`ifdef NVDLA_FEATURE_DATA_TYPE_INT16_FP16
            bins INT16      = {input_data_INT16};
            bins FP16       = {input_data_FP16};
`endif
        }

        // Split setting
        cp_split_num:           coverpoint (ral.nvdla.NVDLA_PDP.D_OPERATION_MODE_CFG.SPLIT_NUM.value) iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value) {
            bins zero       = {'h0};
            bins max        = {'h3F};
            bins full[`PDP_COV_BIN_NUM_DEFAULT]   = {['h0   :'h3F]};
        }
        cp_split_mode:           coverpoint (0 == ral.nvdla.NVDLA_PDP.D_OPERATION_MODE_CFG.SPLIT_NUM.value) iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value) {
            bins DISABLE = {'h0};
            bins ENABLE  = {'h1};
        }
        cp_partial_width_in_first:  coverpoint (ral.nvdla.NVDLA_PDP_RDMA.D_PARTIAL_WIDTH_IN.PARTIAL_WIDTH_IN_FIRST.value) iff ((0 < ral.nvdla.NVDLA_PDP_RDMA.D_OPERATION_MODE_CFG.SPLIT_NUM.value) && (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value)) {
            bins zero       = {'h0};
            bins max        = {'h3FF};
            bins low        = {['h0   :'hF]};
            bins middle     = {['h10  :'h3F]};
            bins high       = {['h40  :'h1FF]};
            bins extreme    = {['h200 :'h3FF]};
            bins full[`PDP_COV_BIN_NUM_DEFAULT]   = {['h0  :'h3FF]};
        }
        cp_partial_width_in_mid:    coverpoint (ral.nvdla.NVDLA_PDP_RDMA.D_PARTIAL_WIDTH_IN.PARTIAL_WIDTH_IN_MID.value)   iff ((1 < ral.nvdla.NVDLA_PDP_RDMA.D_OPERATION_MODE_CFG.SPLIT_NUM.value) && (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value)) {
            bins zero       = {'h0};
            bins max        = {'h3FF};
            bins low        = {['h0   :'hF]};
            bins middle     = {['h10  :'h3F]};
            bins high       = {['h40  :'h1FF]};
            bins extreme    = {['h200:'h3FF]};
            bins full[`PDP_COV_BIN_NUM_DEFAULT]   = {['h0   :'h3FF]};
        }
        cp_partial_width_in_last:   coverpoint (ral.nvdla.NVDLA_PDP_RDMA.D_PARTIAL_WIDTH_IN.PARTIAL_WIDTH_IN_LAST.value)  iff ((0 < ral.nvdla.NVDLA_PDP_RDMA.D_OPERATION_MODE_CFG.SPLIT_NUM.value) && (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value)) {
            bins zero       = {'h0};
            bins max        = {'h3FF};
            bins low        = {['h0   :'hF]};
            bins middle     = {['h10  :'h3F]};
            bins high       = {['h40  :'h1FF]};
            bins extreme    = {['h200 :'h3FF]};
            bins full[`PDP_COV_BIN_NUM_DEFAULT]   = {['h0   :'h3FF]};
        }
        cp_partial_width_out_first:  coverpoint (ral.nvdla.NVDLA_PDP.D_PARTIAL_WIDTH_OUT.PARTIAL_WIDTH_OUT_FIRST.value) iff ((0 < ral.nvdla.NVDLA_PDP.D_OPERATION_MODE_CFG.SPLIT_NUM.value) && (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value)) {
            bins zero       = {'h0};
            bins max        = {'h7F};
            bins full[`PDP_COV_BIN_NUM_DEFAULT]   = {['h0   :'h7F]};
        }
        cp_partial_width_out_mid:    coverpoint (ral.nvdla.NVDLA_PDP.D_PARTIAL_WIDTH_OUT.PARTIAL_WIDTH_OUT_MID.value)   iff ((1 < ral.nvdla.NVDLA_PDP.D_OPERATION_MODE_CFG.SPLIT_NUM.value) && (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value)) {
            bins zero       = {'h0};
            bins max        = {'h7F};
            bins full[`PDP_COV_BIN_NUM_DEFAULT]   = {['h0   :'h7F]};
        }
        cp_partial_width_out_last:   coverpoint (ral.nvdla.NVDLA_PDP.D_PARTIAL_WIDTH_OUT.PARTIAL_WIDTH_OUT_LAST.value)  iff ((0 < ral.nvdla.NVDLA_PDP.D_OPERATION_MODE_CFG.SPLIT_NUM.value) && (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value)) {
            bins zero       = {'h0};
            bins max        = {'h7F};
            bins full[`PDP_COV_BIN_NUM_DEFAULT]   = {['h0   :'h7F]};
        }
        cp_overlap_line:            coverpoint (((ral.nvdla.NVDLA_PDP.D_POOLING_KERNEL_CFG.KERNEL_HEIGHT.value + 1) + (ral.nvdla.NVDLA_PDP.D_POOLING_KERNEL_CFG.KERNEL_STRIDE_HEIGHT.value + 1) - 1)/(ral.nvdla.NVDLA_PDP.D_POOLING_KERNEL_CFG.KERNEL_STRIDE_HEIGHT.value)-64'h1) iff ((0 < ral.nvdla.NVDLA_PDP_RDMA.D_OPERATION_MODE_CFG.SPLIT_NUM.value) && (ral.nvdla.NVDLA_PDP.D_POOLING_KERNEL_CFG.KERNEL_HEIGHT.value >= ral.nvdla.NVDLA_PDP.D_POOLING_KERNEL_CFG.KERNEL_STRIDE_HEIGHT.value) && (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value)) {
            bins range [`PDP_COV_BIN_NUM_DEFAULT] = {[0:7]};
        }

        // Pooling configs
        //  Pooling method
        cp_pooling_method:      coverpoint (ral.nvdla.NVDLA_PDP.D_OPERATION_MODE_CFG.POOLING_METHOD.value) iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value) {
            bins MAX        = {pooling_method_POOLING_METHOD_MAX};
            bins MIN        = {pooling_method_POOLING_METHOD_MIN};
            bins AVERAGE    = {pooling_method_POOLING_METHOD_AVERAGE};
        }

        // Pooling size
        cp_kernel_width:        coverpoint (ral.nvdla.NVDLA_PDP.D_POOLING_KERNEL_CFG.KERNEL_WIDTH.value) iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value) {
            bins width[]    = {[4'h0: 4'h7]};
        }
        cp_kernel_height:       coverpoint (ral.nvdla.NVDLA_PDP.D_POOLING_KERNEL_CFG.KERNEL_HEIGHT.value) iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value) {
            bins height[]   = {[4'h0: 4'h7]};
        }
//      cp_recip_kernel_width:  coverpoint (ral.nvdla.NVDLA_PDP.D_RECIP_KERNEL_WIDTH.RECIP_KERNEL_WIDTH.value) iff ((pooling_method_POOLING_METHOD_AVERAGE == ral.nvdla.NVDLA_PDP.D_OPERATION_MODE_CFG.POOLING_METHOD.value) && (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value)) {
//          bins recip_width[`PDP_COV_BIN_NUM_DEFAULT]    = {[17'h0: 17'h1_FFFF]};
//      }
//      cp_recip_kernel_height: coverpoint (ral.nvdla.NVDLA_PDP.D_RECIP_KERNEL_HEIGHT.RECIP_KERNEL_HEIGHT.value) iff ((pooling_method_POOLING_METHOD_AVERAGE == ral.nvdla.NVDLA_PDP.D_OPERATION_MODE_CFG.POOLING_METHOD.value) && (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value)) {
//          bins recip_height[`PDP_COV_BIN_NUM_DEFAULT]   = {[17'h0: 17'h1_FFFF]};
//      }
//      cr_kernel_size_combination: cross cp_kernel_width, cp_kernel_height {
//      }

        // Pooling stride
        cp_kernel_stride_width: coverpoint (ral.nvdla.NVDLA_PDP.D_POOLING_KERNEL_CFG.KERNEL_STRIDE_WIDTH.value) iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value) {
            bins width[`PDP_COV_BIN_NUM_DEFAULT]    = {[4'h0: 4'hF]};
        }
        cp_kernel_stride_height:coverpoint (ral.nvdla.NVDLA_PDP.D_POOLING_KERNEL_CFG.KERNEL_STRIDE_HEIGHT.value) iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value) {
            bins height[`PDP_COV_BIN_NUM_DEFAULT]   = {[4'h0: 4'hF]};
        }
        cr_kernel_stride_combination: cross cp_kernel_stride_width, cp_kernel_stride_height {
        }

        // Padding setting
        cp_pad_left:            coverpoint (ral.nvdla.NVDLA_PDP.D_POOLING_PADDING_CFG.PAD_LEFT.value)   iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value)   {
            bins range[`PDP_COV_BIN_NUM_DEFAULT]   = {[3'h0: 3'h7]};
        }
        cp_pad_top:             coverpoint (ral.nvdla.NVDLA_PDP.D_POOLING_PADDING_CFG.PAD_TOP.value)   iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value)    {
            bins range[`PDP_COV_BIN_NUM_DEFAULT]   = {[3'h0: 3'h7]};
        }
        cp_pad_right:           coverpoint (ral.nvdla.NVDLA_PDP.D_POOLING_PADDING_CFG.PAD_RIGHT.value)  iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value)   {
            bins range[`PDP_COV_BIN_NUM_DEFAULT]   = {[3'h0: 3'h7]};
        }
        cp_pad_bottom:          coverpoint (ral.nvdla.NVDLA_PDP.D_POOLING_PADDING_CFG.PAD_BOTTOM.value)  iff (1 == ral.nvdla.NVDLA_PDP.D_OP_ENABLE.OP_EN.value)  {
            bins range[`PDP_COV_BIN_NUM_DEFAULT]   = {[3'h0: 3'h7]};
        }

        // Cross flying mode with the same configs between PDP_RDMA and PDP
        cr_flying_mode_cube_in_width: cross cp_flying_mode, cp_cube_in_width {
            ignore_bins large_width_on_fly = binsof(cp_flying_mode.ON_FLYING) && binsof(cp_cube_in_width)intersect{['h800:$]};
        }
        cr_flying_mode_cube_in_height: cross cp_flying_mode, cp_cube_in_height;
        cr_flying_mode_cube_in_channel: cross cp_flying_mode, cp_cube_in_channel;
        cr_flying_mode_partial_width_in_first:  cross cp_flying_mode, cp_partial_width_in_first {
            ignore_bins on_flying = binsof(cp_flying_mode.ON_FLYING);
        }
        cr_flying_mode_partial_width_in_mid:    cross cp_flying_mode, cp_partial_width_in_mid {
            ignore_bins on_flying = binsof(cp_flying_mode.ON_FLYING);
        }
        cr_flying_mode_partial_width_in_last:   cross cp_flying_mode, cp_partial_width_in_last {
            ignore_bins on_flying = binsof(cp_flying_mode.ON_FLYING);
        }
    endgroup : pdp_cg

    function void pdp_toggle_sample();
        uvm_reg_field fld;
        foreach(tg_pdp_flds[i]) begin
            fld = ral.nvdla.NVDLA_PDP.get_field_by_name(i);
            tg_pdp_flds[i].sample(fld.value);
        end
        foreach(tg_pdp_rdma_flds[i]) begin
            fld = ral.nvdla.NVDLA_PDP_RDMA.get_field_by_name(i);
            tg_pdp_rdma_flds[i].sample(fld.value);
        end
    endfunction : pdp_toggle_sample
endclass : pdp_cov_pool


