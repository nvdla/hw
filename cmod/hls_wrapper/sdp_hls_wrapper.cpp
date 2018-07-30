// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: sdp_hls_wrapper.cpp

#include "ac_int.h"
#include "ac_channel.h"
#include "opendla.h"
#include "log.h"
#include "sdp_hls_wrapper.h"
sdp_hls_wrapper::sdp_hls_wrapper() {
}

#pragma CTC SKIP
sdp_hls_wrapper::~sdp_hls_wrapper() {
}
#pragma CTC ENDSKIP

void sdp_hls_wrapper::sdp_x(bool is_x1, int32_t *sdp_data_in, int16_t *sdp_alu_op, int16_t *sdp_mul_op, int32_t *sdp_data)
{
    int i;
// Input data
    static int hls_call_iter = 1;
    ac_channel<xDataInStruct> chn_data_in;
    ac_channel<xAluOpStruct> chn_alu_op;
    ac_channel<xMulOpStruct> chn_mul_op;

    xDataInStruct data_in;
    xAluOpStruct alu_op;
    xMulOpStruct mul_op;
    for (i=0; i<SDP_PARALLEL_PROC_NUM; i++) {
        data_in.data[i] = (xDataInType)sdp_data_in[i];   //sdp_data_in[i] is actually signed value
        alu_op.data[i]  = (xAluOpType)sdp_alu_op[i];
        mul_op.data[i]  = (xMulOpType)sdp_mul_op[i];
    }
    for(i = SDP_PARALLEL_PROC_NUM; i < HLS_MAX_THROUGHPUT; i++) {
        data_in.data[i] = 0; 
        alu_op.data[i]  = 0; 
        mul_op.data[i]  = 0; 
    }
    chn_data_in.write(data_in);
    chn_alu_op.write(alu_op);
    chn_mul_op.write(mul_op);

    // Output Data
    ac_channel<xDataOutStruct> chn_data_out;

    // Call SDP_X HLS
    NV_NVDLA_SDP_CORE_x(
             chn_data_in
            ,chn_alu_op
            ,chn_mul_op

            ,is_x1 ? (xMulOpType)sdp_cfg_x1_mul_op : (xMulOpType)sdp_cfg_x2_mul_op
            ,is_x1 ? (xAluOpType)sdp_cfg_x1_alu_op : (xAluOpType)sdp_cfg_x2_alu_op
            ,is_x1 ? (ACINTF(1))sdp_cfg_x1_alu_bypass : (ACINTF(1))sdp_cfg_x2_alu_bypass
            ,is_x1 ? (ACINTF(2))sdp_cfg_x1_alu_algo : (ACINTF(2))sdp_cfg_x2_alu_algo
            ,is_x1 ? (ACINTF(1))sdp_cfg_x1_alu_src : (ACINTF(1))sdp_cfg_x2_alu_src
            ,is_x1 ? (ACINTF(8))sdp_cfg_x1_alu_shift_value : (ACINTF(8))sdp_cfg_x2_alu_shift_value
            ,is_x1 ? (ACINTF(1))sdp_cfg_x1_mul_bypass : (ACINTF(1))sdp_cfg_x2_mul_bypass
            ,is_x1 ? (ACINTF(1))sdp_cfg_x1_mul_prelu  : (ACINTF(1))sdp_cfg_x2_mul_prelu
            ,is_x1 ? (ACINTF(1))sdp_cfg_x1_mul_src : (ACINTF(1))sdp_cfg_x2_mul_src
            ,is_x1 ? (ACINTF(6))sdp_cfg_x1_mul_shift_value: (ACINTF(6))sdp_cfg_x2_mul_shift_value
            ,is_x1 ? (ACINTF(1))sdp_cfg_x1_relu_bypass : (ACINTF(1))sdp_cfg_x2_relu_bypass
            ,sdp_cfg_nan_to_zero
            ,sdp_cfg_proc_precision

            ,sdp_x_data_out
            );
    xDataOutStruct x_data_out = sdp_x_data_out.read();
    for (i=0; i<SDP_PARALLEL_PROC_NUM; i++) {
        sdp_data[i] = x_data_out.data[i].to_int();
    }
#ifdef HLS_TRACE
    cslDebug((30, "%s call NV_NVDLA_SDP_CORE_x on %d iter\n", HLS_TRACE, hls_call_iter++));
    cslDebug((30, "data_in:\n"));
    for (i=0; i<SDP_PARALLEL_PROC_NUM; i++) {
        cslDebug((30, "0x%08x ", (uint32_t)data_in.data[i]));
    }
    cslDebug((30, "\n"));
    cslDebug((30, "alu_op:\n"));
    for (i=0; i<SDP_PARALLEL_PROC_NUM; i++) {
        cslDebug((30, "0x%08x ", (uint32_t)sdp_alu_op[i]));
    }
    cslDebug((30, "\n"));
    cslDebug((30, "mul_op:\n"));
    for (i=0; i<SDP_PARALLEL_PROC_NUM; i++) {
        cslDebug((30, "0x%08x ", (uint32_t)sdp_mul_op[i]));
    }
    cslDebug((30, "\n"));
    cslDebug((30, "cfg_mul_op:      0x%x\n", (uint32_t)(is_x1 ? (xMulOpType)sdp_cfg_x1_mul_op : (xMulOpType)sdp_cfg_x2_mul_op )));
    cslDebug((30, "cfg_alu_op:      0x%x\n", (uint32_t)(is_x1 ? (xAluOpType)sdp_cfg_x1_alu_op : (xAluOpType)sdp_cfg_x2_alu_op )));
    cslDebug((30, "cfg_alu_bypass:  0x%x\n", (uint32_t)(is_x1 ? (ACINTF(1))sdp_cfg_x1_alu_bypass : (ACINTF(1))sdp_cfg_x2_alu_bypass )));
    cslDebug((30, "cfg_alu_algo:    0x%x\n", (uint32_t)(is_x1 ? (ACINTF(2))sdp_cfg_x1_alu_algo : (ACINTF(2))sdp_cfg_x2_alu_algo )));
    cslDebug((30, "cfg_alu_src:     0x%x\n", (uint32_t)(is_x1 ? (ACINTF(1))sdp_cfg_x1_alu_src : (ACINTF(1))sdp_cfg_x2_alu_src )));
    cslDebug((30, "cfg_alu_shift_value:0x%x\n",         (uint32_t)(is_x1 ? (ACINTF(8))sdp_cfg_x1_alu_shift_value : (ACINTF(8))sdp_cfg_x2_alu_shift_value)));
    cslDebug((30, "cfg_mul_bypass:  0x%x\n",            (uint32_t)(is_x1 ? (ACINTF(1))sdp_cfg_x1_mul_bypass : (ACINTF(1))sdp_cfg_x2_mul_bypass          )));
    cslDebug((30, "cfg_mul_src:     0x%x\n",            (uint32_t)(is_x1 ? (ACINTF(1))sdp_cfg_x1_mul_src : (ACINTF(1))sdp_cfg_x2_mul_src                )));
    cslDebug((30, "cfg_mul_shift_value:0x%x\n",         (uint32_t)(is_x1 ? (ACINTF(8))sdp_cfg_x1_mul_shift_value : (ACINTF(8))sdp_cfg_x2_mul_shift_value)));
    cslDebug((30, "cfg_mul_prelu    :0x%x\n",           (uint32_t)(is_x1 ? (ACINTF(1))sdp_cfg_x1_mul_prelu : (ACINTF(1))sdp_cfg_x2_mul_prelu            )));
    cslDebug((30, "cfg_relu_bypass  :0x%x\n",           (uint32_t)(is_x1 ? (ACINTF(1))sdp_cfg_x1_relu_bypass : (ACINTF(1))sdp_cfg_x2_relu_bypass        )));
    cslDebug((30, "cfg_nan_to_zero  :0x%x\n", (uint32_t)sdp_cfg_nan_to_zero));
    cslDebug((30, "cfg_precision    :0x%x\n", (uint32_t)sdp_cfg_proc_precision));
    cslDebug((30, "chn_data_out:\n"));
    for (i=0; i<SDP_PARALLEL_PROC_NUM; i++) {
        cslDebug((30, "0x%08x ", (uint32_t)sdp_data[i]));
    }
    cslDebug((30, "\n"));
#endif


}

void sdp_hls_wrapper::reset_stats_regs()
{
    total_num  = 0;
    lut_o_flow = 0;
    lut_u_flow = 0;
    lut_le_hit = 0;
    lut_lo_hit = 0;
    lut_hybrid_hit = 0;
    o_cvt_o_flow = 0;
    o_cvt_u_flow = 0;
    i_nan_cnt    = 0;
    i_inf_cnt    = 0;
    o_nan_cnt    = 0;
}

uint16_t sdp_hls_wrapper::read_lut(uint32_t tbl_id, uint32_t addr)
{
    if (tbl_id == NVDLA_SDP_S_LUT_ACCESS_CFG_0_LUT_TABLE_ID_LE) {
#pragma CTC SKIP
        assert(addr < LE_TBL_ENTRY);
#pragma CTC ENDSKIP
        return (uint16_t)(le_tbl[addr]);
    } else {
#pragma CTC SKIP
        assert(addr < LO_TBL_ENTRY);
#pragma CTC ENDSKIP
        return (uint16_t)lo_tbl[addr];
    }
}

void sdp_hls_wrapper::write_lut(uint32_t tbl_id, uint32_t addr, uint16_t val)
{
    if (tbl_id == NVDLA_SDP_S_LUT_ACCESS_CFG_0_LUT_TABLE_ID_LE) {
#pragma CTC SKIP
        assert(addr < LE_TBL_ENTRY);
#pragma CTC ENDSKIP
        le_tbl[addr] = (int16_t)val;
    } else {
#pragma CTC SKIP
        assert(addr < LO_TBL_ENTRY);
#pragma CTC ENDSKIP
        lo_tbl[addr] = (int16_t)val;
    }

    return ;
}

void sdp_hls_wrapper::sdp_y(int32_t *sdp_data_in, int16_t *sdp_alu_op, int16_t *sdp_mul_op, int32_t *out)
{
    int i;
    // Input data
    static int hls_core_y_iter = 1;
    static int hls_core_y_inp_iter = 1;
    ac_channel<yDataInStruct> chn_data_in;
    ac_channel<eDataInStruct> chn_alu_op;
    ac_channel<eDataInStruct> chn_mul_op;
    ac_channel<yInpInStruct> chn_inp_op;
    ac_channel<yDataOutStruct>  chn_y_data_out;
    ac_channel<yInpOutStruct>  chn_y_inp_out;
    ac_channel<yLutOutStruct>  chn_y_lut_out;
    yLutOutStruct y_lut_out;
    yDataOutStruct y_out;

    yDataInStruct data_in;
    eDataInStruct alu_op;
    eDataInStruct mul_op;
    yInpInStruct  inp_op;
    int sdp_y_loop_cnt = (SDP_PARALLEL_PROC_NUM+SPEED_Y-1)/SPEED_Y;

    //assert(SDP_PARALLEL_PROC_NUM%SPEED_Y == 0);
    for(int iter = 0; iter < sdp_y_loop_cnt; iter++) {
        for (i=0; i<SPEED_Y; i++) {
            data_in.data[i] = (yDataInType)sdp_data_in[iter*SPEED_Y + i];
            alu_op.data[i]  = (eDataInType)sdp_alu_op[iter*SPEED_Y + i];
            mul_op.data[i]  = (eDataInType)sdp_mul_op[iter*SPEED_Y + i];
        }
        chn_data_in.write(data_in);
        chn_alu_op.write(alu_op);
        chn_mul_op.write(mul_op);

        // Output Data
        ac_channel<xDataOutStruct> chn_data_out;

        // Call SDP_Y HLS
        NV_NVDLA_SDP_CORE_Y_top(
                chn_data_in
                ,(ACINTF(1))sdp_cfg_y_alu_bypass
                ,(ACINTF(2))sdp_cfg_y_alu_algo
                ,(ACINTF(1))sdp_cfg_y_mul_bypass
                ,(yTruncateType)sdp_cfg_y_truncate
                ,(ACINTF(1))sdp_cfg_y_mul_prelu
                ,(ACINTF(1))sdp_cfg_nan_to_zero
                ,(ACINTF(2))sdp_cfg_proc_precision
                ,chn_alu_op
                ,(eDataOutType)sdp_cfg_y_alu_op
                ,(ACINTF(1))sdp_cfg_y_alu_src
                ,(ACINTF(1))sdp_cfg_y_alu_cvt_bypass
                ,(eAluOpType)sdp_cfg_y_alu_cvt_offset
                ,(eMulOpType)sdp_cfg_y_alu_cvt_scale
                ,(eTruncateType)sdp_cfg_y_alu_cvt_truncate
                ,chn_mul_op
                ,(eDataOutType)sdp_cfg_y_mul_op
                ,(ACINTF(1))sdp_cfg_y_mul_src
                ,(ACINTF(1))sdp_cfg_y_mul_cvt_bypass
                ,(eAluOpType)sdp_cfg_y_mul_cvt_offset
                ,(eMulOpType)sdp_cfg_y_mul_cvt_scale
                ,(eTruncateType)sdp_cfg_y_mul_cvt_truncate
                ,(yLutRegType)sdp_cfg_y_lut_le_start
                //,(yLutRegType)sdp_cfg_y_lut_le_end
                ,(yLutRegType)sdp_cfg_y_lut_lo_start
                //,(yLutRegType)sdp_cfg_y_lut_lo_end
                ,(yLutRegIdxType)sdp_cfg_y_lut_le_index_offset
                ,(yLutRegIdxType)sdp_cfg_y_lut_le_index_select
                ,(yLutRegIdxType)sdp_cfg_y_lut_lo_index_select
                ,(ACINTF(1))sdp_cfg_y_lut_le_function
                ,(ACINTF(1))sdp_cfg_y_lut_out_sel_u_miss
                ,(ACINTF(1))sdp_cfg_y_lut_out_sel_o_miss
                ,(ACINTF(1))sdp_cfg_y_lut_out_sel_hybrid
                ,(ACINTF(1))sdp_cfg_y_lut_bypass
                ,chn_y_lut_out
                ,chn_y_data_out
                );

#ifdef  HLS_TRACE
        cslDebug((30, "%s call NV_NVDLA_SDP_CORE_Y_top on %d iter\n", HLS_TRACE, hls_core_y_iter++));
        cslDebug((30, "chn_data_in:\n"));
        for(i = 0; i < SPEED_Y; i++) {
            cslDebug((30, "0x%08x ", (uint32_t)data_in.data[i]));
        }
        cslDebug((30, "\n"));
        cslDebug((30, "cfg_alu_bypass:      0x%x\n", (uint32_t)sdp_cfg_y_alu_bypass));
        cslDebug((30, "cfg_alu_algo:        0x%x\n", (uint32_t)sdp_cfg_y_alu_algo));
        cslDebug((30, "cfg_mul_bypass:      0x%x\n", (uint32_t)sdp_cfg_y_mul_bypass));
        cslDebug((30, "cfg_truncate:        0x%x\n", (uint32_t)sdp_cfg_y_truncate));
        cslDebug((30, "cfg_mul_prelu:       0x%x\n", (uint32_t)sdp_cfg_y_mul_prelu));
        cslDebug((30, "cfg_nan_to_zero:     0x%x\n", (uint32_t)sdp_cfg_nan_to_zero));
        cslDebug((30, "cfg_precision:       0x%x\n", (uint32_t)sdp_cfg_proc_precision));
        cslDebug((30, "chn_alu_in:\n"));
        for(i = 0; i < SPEED_Y; i++) {
            cslDebug((30, "0x%08x ", (uint32_t)alu_op.data[i]));
        }
        cslDebug((30, "\n"));
        cslDebug((30, "cfg_alu_in:          0x%x\n", (uint32_t)sdp_cfg_y_alu_op));
        cslDebug((30, "cfg_alu_src:         0x%x\n", (uint32_t)sdp_cfg_y_alu_src));
        cslDebug((30, "cfg_alu_cvt_bypass:  0x%x\n", (uint32_t)sdp_cfg_y_alu_cvt_bypass));
        cslDebug((30, "cfg_alu_cvt_offset:  0x%x\n", (uint32_t)sdp_cfg_y_alu_cvt_offset));
        cslDebug((30, "cfg_alu_cvt_scale:   0x%x\n", (uint32_t)sdp_cfg_y_alu_cvt_scale));
        cslDebug((30, "cfg_alu_cvt_truncate:0x%x\n", (uint32_t)sdp_cfg_y_alu_cvt_truncate));
        cslDebug((30, "chn_mul_in:\n"));
        for(i = 0; i < SPEED_Y; i++) {
            cslDebug((30, "0x%08x ", (uint32_t)mul_op.data[i]));
        }
        cslDebug((30, "\n"));
        cslDebug((30, "cfg_mul_in:          0x%x\n", (uint32_t)sdp_cfg_y_mul_op));
        cslDebug((30, "cfg_mul_src:         0x%x\n", (uint32_t)sdp_cfg_y_mul_src));
        cslDebug((30, "cfg_mul_cvt_bypass:  0x%x\n", (uint32_t)sdp_cfg_y_mul_cvt_bypass));
        cslDebug((30, "cfg_mul_cvt_offset:  0x%x\n", (uint32_t)sdp_cfg_y_mul_cvt_offset));
        cslDebug((30, "cfg_mul_cvt_scale:   0x%x\n", (uint32_t)sdp_cfg_y_mul_cvt_scale));
        cslDebug((30, "cfg_mul_cvt_truncate:0x%x\n", (uint32_t)sdp_cfg_y_mul_cvt_truncate));

        cslDebug((30, "cfg_lut_le_start:0x%x\n",        (uint32_t)sdp_cfg_y_lut_le_start));
        cslDebug((30, "cfg_lut_lo_start:0x%x\n",        (uint32_t)sdp_cfg_y_lut_lo_start));
        cslDebug((30, "cfg_lut_le_index_offset:0x%x\n", (uint32_t)sdp_cfg_y_lut_le_index_offset));
        cslDebug((30, "cfg_lut_le_index_select:0x%x\n", (uint32_t)sdp_cfg_y_lut_le_index_select));
        cslDebug((30, "cfg_lut_lo_index_select:0x%x\n", (uint32_t)sdp_cfg_y_lut_lo_index_select));
        cslDebug((30, "cfg_lut_le_function:0x%x\n",     (uint32_t)sdp_cfg_y_lut_le_function));
        cslDebug((30, "cfg_lut_uflow_priority:0x%x\n",  (uint32_t)sdp_cfg_y_lut_out_sel_u_miss));
        cslDebug((30, "cfg_lut_oflow_priority:0x%x\n",  (uint32_t)sdp_cfg_y_lut_out_sel_o_miss));
        cslDebug((30, "cfg_lut_hybrid_priority:0x%x\n", (uint32_t)sdp_cfg_y_lut_out_sel_hybrid));
        cslDebug((30, "cfg_lut_bypass:0x%x\n",          (uint32_t)sdp_cfg_y_lut_bypass));
        if (chn_y_lut_out.size() > 0) {
            y_lut_out = chn_y_lut_out.read();

            cslDebug((30, "chn_y_lut_out.fraction:\n"));
            for(i = 0; i < SPEED_Y; i++) {
                cslDebug((30, "0x%016lx ", (int64_t)y_lut_out.fraction[i].to_int64()));
            }
            cslDebug((30, "\n"));   
            cslDebug((30, "chn_y_lut_out.x:\n"));
            for(i = 0; i < SPEED_Y; i++) {
                cslDebug((30, "0x%08x ", (uint32_t)y_lut_out.x[i]));
            }
            cslDebug((30, "\n"));   
            cslDebug((30, "chn_y_lut_out.oflow:\n"));
            for(i = 0; i < SPEED_Y; i++) {
                cslDebug((30, "0x%08x ", (uint32_t)y_lut_out.oflow[i]));
            }
            cslDebug((30, "\n"));   
            cslDebug((30, "chn_y_lut_out.uflow:\n"));
            for(i = 0; i < SPEED_Y; i++) {
                cslDebug((30, "0x%08x ", (uint32_t)y_lut_out.uflow[i]));
            }
            cslDebug((30, "\n"));   
            cslDebug((30, "chn_y_lut_out.ram_sel:\n"));
            for(i = 0; i < SPEED_Y; i++) {
                cslDebug((30, "0x%08x ", (uint32_t)y_lut_out.ram_sel[i]));
            }
            cslDebug((30, "\n"));   
            cslDebug((30, "chn_y_lut_out.ram_addr:\n"));
            for(i = 0; i < SPEED_Y; i++) {
                cslDebug((30, "0x%08x ", (uint32_t)y_lut_out.ram_addr[i]));
            }
            cslDebug((30, "\n"));   
            cslDebug((30, "chn_y_lut_out.le_hit:\n"));
            for(i = 0; i < SPEED_Y; i++) {
                cslDebug((30, "0x%08x ", (uint32_t)y_lut_out.le_hit[i]));
            }
            cslDebug((30, "\n"));   
            cslDebug((30, "chn_y_lut_out.lo_hit:\n"));
            for(i = 0; i < SPEED_Y; i++) {
                cslDebug((30, "0x%08x ", (uint32_t)y_lut_out.lo_hit[i]));
            }
            cslDebug((30, "\n"));  
        }
        if (chn_y_data_out.size() > 0) {
            y_out = chn_y_data_out.read();
            cslDebug((30, "chn_y_data_out.data:\n"));
            for(i = 0; i < SPEED_Y; i++) {
                cslDebug((30, "0x%08x ", (uint32_t)y_out.data[i].to_int()));
            }
            cslDebug((30, "\n"));   
        }
#endif

        if (sdp_cfg_y_lut_bypass == NVDLA_SDP_D_DP_EW_CFG_0_EW_LUT_BYPASS_NO) {

            for( int i = 0; i < SPEED_Y; i++) {
                inp_op.x[i]         = (yInpDataInType)y_lut_out.x[i];
                inp_op.fraction[i]  = y_lut_out.fraction[i];
                inp_op.y0[i]        = read_lut(y_lut_out.ram_sel[i], y_lut_out.ram_addr[i]);
                if (y_lut_out.oflow[i] == false && y_lut_out.uflow[i] == false ) {
                    inp_op.y1[i]    = read_lut(y_lut_out.ram_sel[i], y_lut_out.ram_addr[i]+1);
                }
                inp_op.flow[i]      = y_lut_out.oflow[i] || y_lut_out.uflow[i];
                inp_op.bias[i]      = 0;
                if (inp_op.flow[i] == true && y_lut_out.ram_sel[i] == NVDLA_SDP_S_LUT_ACCESS_CFG_0_LUT_TABLE_ID_LE &&
                    sdp_cfg_y_lut_le_function == NVDLA_SDP_S_LUT_CFG_0_LUT_LE_FUNCTION_EXPONENT &&
                    y_lut_out.oflow[i] == false) {
                    if (sdp_cfg_proc_precision == NVDLA_SDP_D_DATA_FORMAT_0_PROC_PRECISION_FP16) {
                        float temp;
                        int32_t *p = (int32_t*)&temp;

                        temp = pow(2.0, sdp_cfg_y_lut_le_index_offset);
                        inp_op.bias[i] = *p;
                    } else if (sdp_cfg_y_lut_le_index_offset > 0){
                        inp_op.bias[i] = ((uint32_t)0x1)<<sdp_cfg_y_lut_le_index_offset;
                    }
                }
                if (inp_op.flow[i] == true) {
                    if (y_lut_out.ram_sel[i] == NVDLA_SDP_S_LUT_ACCESS_CFG_0_LUT_TABLE_ID_LE) {
                        inp_op.scale[i] = y_lut_out.oflow[i] ? sdp_cfg_y_le_oflow_scale : sdp_cfg_y_le_uflow_scale;
                        inp_op.shift[i] = y_lut_out.oflow[i] ? sdp_cfg_y_le_oflow_shift : sdp_cfg_y_le_uflow_shift;
                        inp_op.offset[i] = y_lut_out.oflow[i] ? sdp_cfg_y_lut_le_end : sdp_cfg_y_lut_le_start;
                    } else {
                        inp_op.scale[i] = y_lut_out.oflow[i] ? sdp_cfg_y_lo_oflow_scale : sdp_cfg_y_lo_uflow_scale;
                        inp_op.shift[i] = y_lut_out.oflow[i] ? sdp_cfg_y_lo_oflow_shift : sdp_cfg_y_lo_uflow_shift;
                        inp_op.offset[i] = y_lut_out.oflow[i] ? sdp_cfg_y_lut_lo_end : sdp_cfg_y_lut_lo_start;
                    }
                }

                if (y_lut_out.oflow[i]) {
                    lut_o_flow++;
                }
                if (y_lut_out.uflow[i]) {
                    lut_u_flow++;
                }
                if (y_lut_out.le_hit[i]) {
                    lut_le_hit++;
                }
                if (y_lut_out.lo_hit[i]) {
                    lut_lo_hit++;
                }
                if (!(y_lut_out.uflow[i]||y_lut_out.oflow[i])) {
                    lut_hybrid_hit++;
                }
                total_num++;
            }

            
            chn_inp_op.write(inp_op);
            NV_NVDLA_SDP_CORE_Y_inp(
                    chn_inp_op
                    ,(ACINTF(2))sdp_cfg_proc_precision
                    ,chn_y_inp_out
                    );
            yInpOutStruct inp_out = chn_y_inp_out.read();;
            for(int i = 0; i < SPEED_Y; i++) {
                out[iter*SPEED_Y + i] = inp_out.data[i].to_int();
            }
#ifdef HLS_TRACE
            cslDebug((30, "%s call NV_NVDLA_SDP_CORE_Y_inp on %d iter\n", HLS_TRACE, hls_core_y_inp_iter++));
            cslDebug((70, "\t inp_op.x:\n\t"));
            for(int i = 0; i < SPEED_Y; i++) {
                cslDebug((70, "0x%08x, ", (uint32_t)inp_op.x[i]));
            }
            cslDebug((70, "\n"));
            cslDebug((70, "\t inp_op.fraction:\n\t"));
            for(int i = 0; i < SPEED_Y; i++) {
                cslDebug((70, "0x%020lx, ", (uint64_t)inp_op.fraction[i]));
            }
            cslDebug((70, "\n"));
            cslDebug((70, "\t inp_op.y0:\n\t"));
            for(int i = 0; i < SPEED_Y; i++) {
                cslDebug((70, "0x%08x, ", (uint32_t)inp_op.y0[i]));
            }
            cslDebug((70, "\n"));
            cslDebug((70, "\t inp_op.y1:\n\t"));
            for(int i = 0; i < SPEED_Y; i++) {
                cslDebug((70, "0x%08x, ", (uint32_t)inp_op.y1[i]));
            }
            cslDebug((70, "\n"));
            cslDebug((70, "\t inp_op.scale:\n\t"));
            for(int i = 0; i < SPEED_Y; i++) {
                cslDebug((70, "0x%08x, ", (uint32_t)inp_op.scale[i]));
            }
            cslDebug((70, "\n"));
            cslDebug((70, "\t inp_op.shift:\n\t"));
            for(int i = 0; i < SPEED_Y; i++) {
                cslDebug((70, "0x%08x, ", (uint32_t)inp_op.shift[i]));
            }
            cslDebug((70, "\n"));
            cslDebug((70, "\t inp_op.offset:\n\t"));
            for(int i = 0; i < SPEED_Y; i++) {
                cslDebug((70, "0x%08x, ", (uint32_t)inp_op.offset[i]));
            }
            cslDebug((70, "\n"));
            cslDebug((70, "\t inp_op.flow:\n\t"));
            for(int i = 0; i < SPEED_Y; i++) {
                cslDebug((70, "0x%08x, ", (uint32_t)inp_op.flow[i]));
            }
            cslDebug((70, "\n"));
            cslDebug((70, "\t inp_op.bias:\n\t"));
            for(int i = 0; i < SPEED_Y; i++) {
                cslDebug((70, "0x%08x, ", (uint32_t)inp_op.bias[i]));
            }
            cslDebug((70, "\n"));
            cslDebug((70, "\t chn_inp_out.data:\n\t"));
            for(int i = 0; i < SPEED_Y; i++) {
                cslDebug((70, "0x%08x, ", (uint32_t)out[iter*SPEED_Y+i]));
            }
            cslDebug((70, "\n"));
#endif

        } else {
            for(int i = 0; i < SPEED_Y; i++) {
                out[iter*SPEED_Y + i] = y_out.data[i].to_int();
            }
        }
    }
}


void sdp_hls_wrapper::sdp_c(ac_channel<cDataInStruct> & chn_in)
{
    int i;
    static int hls_core_c_iter = 1;
// Output Data
    ac_channel<cDataOutStruct> chn_out;
    cDataInStruct in = chn_in.read();

    chn_in.write(in);

// Call SDP_C HLS
    NV_NVDLA_SDP_CORE_c(
             chn_in
            ,(cAluOpType)sdp_cfg_cvt_offset
            ,(cMulOpType)sdp_cfg_cvt_scale
            ,(cTruncateType)sdp_cfg_cvt_shift
            ,(ACINTF(2))sdp_cfg_proc_precision
            ,(ACINTF(2))sdp_cfg_out_precision
            ,(ACINTF(1))sdp_cfg_mode_eql
            ,chn_out
            );

    cDataOutStruct data_out = chn_out.read();
    uint16_t saturate[SDP_PARALLEL_PROC_NUM];
    for (i=0; i<SDP_PARALLEL_PROC_NUM; i++) {
        sdp_data_out[i] = data_out.data[i].to_int();
        if (sdp_cfg_out_precision == NVDLA_SDP_D_DATA_FORMAT_0_PROC_PRECISION_FP16) {
            saturate[i] = (sdp_data_out[i]&0x7FFF) == 0x7bff ? 1:0;
        } else {
            saturate[i] = (uint16_t)data_out.sat[i].to_uint();
        }
        o_cvt_o_flow += saturate[i];
    }

#ifdef HLS_TRACE
    cslDebug((30, "%s call NV_NVDLA_SDP_CORE_c on %d iter\n", HLS_TRACE, hls_core_c_iter++));
    cslDebug((30, "chn_in.data:\n"));
    for(i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
        cslDebug((30, "0x%08x ", in.data[i].to_int()));
    }
    cslDebug((30, "\n"));   
    cslDebug((30, "cfg_offset:          0x%x\n", (uint32_t)sdp_cfg_cvt_offset));
    cslDebug((30, "cfg_scale:           0x%x\n", (uint32_t)sdp_cfg_cvt_scale));
    cslDebug((30, "cfg_shift:           0x%x\n", (uint32_t)sdp_cfg_cvt_shift));
    cslDebug((30, "cfg_proc_precision:  0x%x\n", (uint32_t)sdp_cfg_proc_precision));
    cslDebug((30, "cfg_out_precision:   0x%x\n", (uint32_t)sdp_cfg_out_precision));
    //cslDebug((30, "status_saturation:   0x%x\n", status_saturation));
    cslDebug((30, "chn_out.data:\n"));
    for(i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
        cslDebug((30, "0x%08x ", (uint32_t)sdp_data_out[i]));
        cslDebug((30, "0x%08x ", (uint32_t)saturate[i]));
    }
    cslDebug((30, "\n"));   
#endif
}

void sdp_hls_wrapper::sdp(int32_t *sdp_data_in,
        int16_t *sdp_x1_alu_op, int16_t *sdp_x1_mul_op,
        int16_t *sdp_x2_alu_op, int16_t *sdp_x2_mul_op,
        int16_t *sdp_y_alu_op,  int16_t *sdp_y_mul_op)
{
    int i;
    int32_t sdp_data[HLS_MAX_THROUGHPUT];     //Use int32_t instead of uint32_t.  Bug200228448
    int16_t sdp_x_alu_op[HLS_MAX_THROUGHPUT], sdp_x_mul_op[HLS_MAX_THROUGHPUT];
                                //Otherwise, "(FIX32)sdp_data[i]" may overflow and the result value will be MAX_INT.(0xffffb3ff->0x7fffffff, but we need to keep the bits unchanged)
    ac_channel<cDataInStruct> chn_in;
    if (sdp_cfg_nan_flush && sdp_cfg_proc_precision == NVDLA_SDP_D_DATA_FORMAT_0_PROC_PRECISION_FP16) {
        for(i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
            if (((sdp_data_in[i]&0x7FFFFF) != 0) && (((sdp_data_in[i]>>23)&0xFF) == 255)) {
                sdp_data_in[i] = 0;
            }
        }
    }
    if (!sdp_cfg_x1_bypass) {
        for(i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
            sdp_x_alu_op[i] = (xMulOpType)sdp_x1_alu_op[i];
            sdp_x_mul_op[i] = (xMulOpType)sdp_x1_mul_op[i];
        }

        // X1
        sdp_x(true, sdp_data_in, sdp_x_alu_op, sdp_x_mul_op, sdp_data); // Output is sdp_data_out
    } else {
        for (i=0; i< SDP_PARALLEL_PROC_NUM; i++) {
            sdp_data[i] = sdp_data_in[i];
        }
    }
    
    if (!sdp_cfg_x2_bypass) {
        for (i=0; i<SDP_PARALLEL_PROC_NUM; i++) {
            sdp_x_alu_op[i] = (xMulOpType)(sdp_x2_alu_op[i]);
            sdp_x_mul_op[i] = (xMulOpType)(sdp_x2_mul_op[i]);
        }

        // X2
        sdp_x(false, sdp_data, sdp_x_alu_op, sdp_x_mul_op, sdp_data); // Output is sdp_data_out
    }
    
    if (!sdp_cfg_y_bypass) {
        // Y
        sdp_y(sdp_data, sdp_y_alu_op, sdp_y_mul_op, sdp_data); // Output is sdp_data_out
    }

    // Convert output of sdp_x to sdp_c
    cDataInStruct c_data_in;
    for (i=0; i<SDP_PARALLEL_PROC_NUM; i++) {
        c_data_in.data[i] = sdp_data[i];
    }
    chn_in.write(c_data_in);

    sdp_c(chn_in);
    if (sdp_cfg_perf_out_nan_cnt_en) {
        for(i = 0; i < SDP_PARALLEL_PROC_NUM; i++) {
            if (((sdp_data_out[i]&0x3FF) != 0) && (((sdp_data_out[i]>>10)&0x1F) == 0x1F)) {
                o_nan_cnt++;
            }
        }
    }
}
