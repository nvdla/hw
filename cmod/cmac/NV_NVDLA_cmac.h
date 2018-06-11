// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cmac.h

#ifndef _NV_NVDLA_CMAC_H_
#define _NV_NVDLA_CMAC_H_
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include <systemc.h>
#include <tlm.h>
#include "tlm_utils/multi_passthrough_initiator_socket.h"
#include "tlm_utils/multi_passthrough_target_socket.h" 
#include "scsim_common.h"
// #include "nvdla_mac_dat_if_DATA_2944_MASK_16_iface.h"
// #include "nvdla_mac_dat_if_DATA_1280_MASK_64_iface.h"
// #include "nvdla_mac_wt_if_DATA_1024_MASK_64_SEL_16_iface.h"
#include "nvdla_xx2csb_resp_iface.h"
#include "NV_NVDLA_cmac_base.h"
#include "cmac_a_reg_model.h"
#include "opendla.h"
#include "nvdla_config.h"
#include "log.h"
#include "math.h"

#define DATA_OPERAND_BIT_WIDTH_INT8         8
#define DATA_OPERAND_BIT_WIDTH_INT16        16
#define WEIGHT_OPERAND_BIT_WIDTH_INT8       8
#define WEIGHT_OPERAND_BIT_WIDTH_INT16      16
#define OUTPUT_BIT_WIDTH_INT8               22
#define OUTPUT_BIT_WIDTH_INT16              44

#define MAC_CELL_NUM                        (NVDLA_MAC_ATOMIC_K_SIZE / 2)
#define DATA_ELEMENT_NUM                    NVDLA_MAC_ATOMIC_C_SIZE
#define WEIGHT_ELEMENT_NUM                  (MAC_CELL_NUM * DATA_ELEMENT_NUM)
#define RESULT_NUM_PER_MACELL               4

#define FP16_SIGN_BIT_WIDTH                 1
#define FP16_EXP_BIT_WIDTH                  5
#define FP16_FRA_BIT_WIDTH                  10
#define FP16_MUL_BIT_WIDTH                  38
#define FP16_OEXP_BIT_WIDTH                 6

//#define DEBUG_ERROR_CHECK

#define LOG_DETAIL                          0

#ifdef DEBUG_ERROR_CHECK
#include "half.hpp"
#endif

SCSIM_NAMESPACE_START(clib)
// clib class forward declaration
SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)
class NvdlaMacCell {
public:
    NvdlaMacCell () {
        mac_cell_enable_        = false;
        winograd_op_            = false;
    }
    // Following are for hookup with externel module
    sc_int<DATA_OPERAND_BIT_WIDTH_INT8>     *data_operand_ptr_;
    sc_int<WEIGHT_OPERAND_BIT_WIDTH_INT8>   *weight_operand_ptr_;
    sc_int<OUTPUT_BIT_WIDTH_INT8>           *result_ptr_;
    uint64_t                                *wt_mask_ptr_;
    uint64_t                                *dat_mask_ptr_;

    uint8_t precision_;
    bool mac_cell_enable_;
    bool winograd_op_;

    void calculation_int8(uint64_t* wt_mask, uint64_t* dat_mask, sc_int<DATA_OPERAND_BIT_WIDTH_INT8> *data_operand, sc_int<WEIGHT_OPERAND_BIT_WIDTH_INT8> *weight_operand, sc_int<OUTPUT_BIT_WIDTH_INT8> *result){
        uint32_t channel_iter, result_iter;
        sc_int<DATA_OPERAND_BIT_WIDTH_INT8>   data;
        sc_int<WEIGHT_OPERAND_BIT_WIDTH_INT8> weight;
        sc_int<OUTPUT_BIT_WIDTH_INT8> product;
        sc_int<OUTPUT_BIT_WIDTH_INT8> accu;
        sc_int<OUTPUT_BIT_WIDTH_INT8> accu_wino_phase1[16];
        sc_int<OUTPUT_BIT_WIDTH_INT8> accu_wino_phase2[8];
        sc_int<OUTPUT_BIT_WIDTH_INT8> accu_wino_phase3[4];
        int8_t wt_mask_k0;
        int8_t wt_mask_k1;
        int8_t dat_mask_k0;
        int8_t dat_mask_k1;

        for (result_iter=0; result_iter < RESULT_NUM_PER_MACELL; result_iter++) {
             result[result_iter] = 0;
        }

#if 0   //For Winograd
        int8_t data_array[8][4][4], weight_array[8][4][4];
        for(int c = 0; c < 8; c++) {
            for(int y = 0; y < 4; y++) {
                for(int x = 0; x < 4; x++) {
                    data_array[c][y][x] = data_operand[(y*4+x)*8+c];
                    weight_array[c][y][x]= weight_operand[(y*4+x)*8+c];
                }
            }
        }

        for(int x = 0; x < 4; x++) {
            for(int y = 0; y < 4; y++) {
                for(int c = 0; c < 8; c++) {
                    cslDebug((30, "x=%d y=%d c=%d data:0x%x, weight:0x%x\n", x, y, c, data_array[c][y][x], weight_array[c][y][x]));
                }
            }
        }
#endif
        //cslDebug((30, "%s data:0x%x, weight:0x%x\n", basename(), data_array[0][0][0], weight_array[0][0][0]));
        //cslDebug((30, "%s data:0x%x, weight:0x%x\n", basename(), data_array[0][0][1], weight_array[0][0][1]));
        //cslDebug((30, "data:0x%x, weight:0x%x\n", data_array[0][0][0], weight_array[0][0][0]));
        //cslDebug((30, "data:0x%x, weight:0x%x\n", data_array[1][0][0], weight_array[1][0][0]));

        cslDebug((50, "Calculation_int8: mac_cell_enable_ is %s\n", mac_cell_enable_? "true": "false"));
        cslDebug((50, "    wt_mask[0]  : 0x%016lx\n", wt_mask[0]));
        cslDebug((50, "    wt_mask[1]  : 0x%016lx\n", wt_mask[1]));
        cslDebug((50, "    dat_mask[0] : 0x%016lx\n", dat_mask[0]));
        cslDebug((50, "    dat_mask[1] : 0x%016lx\n", dat_mask[1]));
        if (true == mac_cell_enable_) {
            if (winograd_op_) {
                uint32_t i;
                uint32_t channel_num = NVDLA_MAC_ATOMIC_C_SIZE / (4 * 4);
                // Phase1: Generate 16 partial sums
                for (i = 0; i < 16; i++) {
                    accu_wino_phase1[i]   = 0;
                    for (channel_iter = 0; channel_iter < channel_num; channel_iter++) {
                        data = data_operand[i * channel_num + channel_iter];
                        weight = weight_operand[i * channel_num + channel_iter];
                        accu_wino_phase1[i] = accu_wino_phase1[i] + data * weight;
                    }
                    cslDebug((70, "    calculation_int8 winograd accu_wino_phase1[%d] = 0x%x\n", i, (uint32_t)accu_wino_phase1[i].to_int()));
                }
                // Phase2: multiply transposition of matrix A. Generate 8 parital sums.
                for (i = 0; i < 4; i++) {
                    accu_wino_phase2[i+0] = accu_wino_phase1[i+0] + accu_wino_phase1[i+4] + accu_wino_phase1[i+8];
                    accu_wino_phase2[i+4] = accu_wino_phase1[i+4] - accu_wino_phase1[i+8] - accu_wino_phase1[i+12];
                }
                // Phase3: multiply matrix A. Generate 4 parital sums.
                for(i = 0; i < 2; i++) {
                    accu_wino_phase3[i*2+0] = accu_wino_phase2[i*4+0] + accu_wino_phase2[i*4+1] + accu_wino_phase2[i*4+2];
                    accu_wino_phase3[i*2+1] = accu_wino_phase2[i*4+1] - accu_wino_phase2[i*4+2] - accu_wino_phase2[i*4+3];
                }

                for (int i = 0; i < RESULT_NUM_PER_MACELL; i++) {
                    result[i] = accu_wino_phase3[i];
                    cslDebug((70, "    calculation_int8 winograd result = 0x%x\n", (uint32_t)result[i].to_int()));
                }
            } else {
                accu = 0;

                for (channel_iter = 0; channel_iter < NVDLA_MAC_ATOMIC_C_SIZE; channel_iter++) {
                    data   = data_operand[channel_iter];
                    weight = weight_operand[channel_iter];
                    cslDebug((70, "    channel_iter is 0x%x\n", channel_iter));
                    cslDebug((70, "    Data        : 0x%02x\n", (uint8_t)data));
                    cslDebug((70, "    Weight      : 0x%02x\n", (uint8_t)weight));
                    if (channel_iter < NVDLA_MAC_ATOMIC_C_SIZE / 2) {
                        wt_mask_k0  = (wt_mask[1] >> channel_iter) & 0x1;
                        dat_mask_k0 = (dat_mask[1] >> channel_iter) & 0x1;
                        cslDebug((70, "    dat_mask_k0 : %d\n", dat_mask_k0));
                        cslDebug((70, "    wt_mask_k0  : %d\n", wt_mask_k0));
                        if((wt_mask_k0 == 0) || (dat_mask_k0 == 0))
                            continue;
                    } else {
                        wt_mask_k1 = (wt_mask[0] >> (channel_iter - NVDLA_MAC_ATOMIC_C_SIZE / 2)) & 0x1;
                        dat_mask_k1 = (dat_mask[0] >> (channel_iter - NVDLA_MAC_ATOMIC_C_SIZE / 2)) & 0x1;
                        cslDebug((70, "    dat_mask_k1 : %d\n", dat_mask_k1));
                        cslDebug((70, "    wt_mask_k1  : %d\n", wt_mask_k1));
                        if((wt_mask_k1 == 0) || (dat_mask_k1 == 0))
                            continue;
                    }
                    //accu  = accu + data * weight;
                    product = data * weight;
                    accu    = accu + product;
                    cslDebug((70, "    product    : 0x%x\n", (uint32_t)product));
                    cslDebug((70, "    accu       : 0x%x\n", (uint32_t)accu));
                }
                result[0] = accu; // save to index 0 and 4 of result array which contains 8 elements
                cslDebug((70, "    calculation_int8 result = 0x%x\n", (uint32_t)accu.to_int()));
            }
        }
    }

    void calculation_int16(uint64_t* wt_mask, uint64_t* dat_mask, sc_int<DATA_OPERAND_BIT_WIDTH_INT8> *data_operand, sc_int<WEIGHT_OPERAND_BIT_WIDTH_INT8> *weight_operand, sc_int<OUTPUT_BIT_WIDTH_INT8> *result){
        sc_int<DATA_OPERAND_BIT_WIDTH_INT16>   data;
        sc_int<WEIGHT_OPERAND_BIT_WIDTH_INT16> weight;
        sc_int<OUTPUT_BIT_WIDTH_INT16> accu;
        sc_int<OUTPUT_BIT_WIDTH_INT16> accu_wino_phase1[16];
        sc_int<OUTPUT_BIT_WIDTH_INT16> accu_wino_phase2[8];
        sc_int<OUTPUT_BIT_WIDTH_INT16> accu_wino_phase3[4];
        uint32_t    channel_iter, result_iter;
        int         i;
        int16_t     data_array[4][4][4], weight_array[4][4][4];
        for (result_iter=0; result_iter < RESULT_NUM_PER_MACELL; result_iter++) {
             result[result_iter] = 0;
        }

        for(int c = 0; c < 4; c++) {
            for(int y = 0; y < 4; y++) {
                for(int x = 0; x < 4; x++) {
                    data_array[c][y][x] = (data_operand[(y * 4 + x) * 8 + c * 2 + 1].range(7, 0), data_operand[(y * 4 + x) * 8 + c * 2].range(7, 0));
                    weight_array[c][y][x] = (weight_operand[(y * 4 + x) * 8 + c * 2 + 1], weight_operand[(y * 4 + x) * 8 + c * 2]);
                }
            }
        }
        cslDebug((30, "data:%d, weight:%d\n", data_array[0][0][0], weight_array[0][0][0]));

        cslDebug((50, "Calculation_int16: mac_cell_enable_ is %s\n", mac_cell_enable_? "true": "false"));
        cslDebug((50, "    wt_mask[0]  : 0x%016lx\n", wt_mask[0]));
        cslDebug((50, "    wt_mask[1]  : 0x%016lx\n", wt_mask[1]));
        cslDebug((50, "    dat_mask[0] : 0x%016lx\n", dat_mask[0]));
        cslDebug((50, "    dat_mask[1] : 0x%016lx\n", dat_mask[1]));
        if (true == mac_cell_enable_) {
            if (winograd_op_) {
                uint32_t channel_num = NVDLA_MAC_ATOMIC_C_SIZE / (4 * 4);
                // Phase1: Generate 16 partial sums
                for (i = 0; i< 16; i++) {
                    accu_wino_phase1[i]   = 0;
                    for (channel_iter = 0; channel_iter < channel_num; channel_iter++) {
                        data = (data_operand[i * channel_num * 2 + channel_iter * 2 + 1].range(7, 0), data_operand[i * channel_num * 2 + channel_iter * 2].range(7, 0));
                        weight = (weight_operand[i * channel_num * 2 + channel_iter * 2 + 1], weight_operand[i * channel_num * 2 + channel_iter * 2]);
                        accu_wino_phase1[i] = accu_wino_phase1[i] + data * weight;
                    }
                }
                // Phase2: multiply transposition of matrix A. Generate 8 parital sums.
                for (i = 0; i < 4; i++) {
                    accu_wino_phase2[i+0] = accu_wino_phase1[i+0] + accu_wino_phase1[i+4] + accu_wino_phase1[i+8];
                    accu_wino_phase2[i+4] = accu_wino_phase1[i+4] - accu_wino_phase1[i+8] - accu_wino_phase1[i+12];
                }
                // Phase3: multiply matrix A. Generate 4 parital sums.
                for(i = 0; i < 2; i++) {
                    accu_wino_phase3[i*2+0] = accu_wino_phase2[i*4+0] + accu_wino_phase2[i*4+1] + accu_wino_phase2[i*4+2];
                    accu_wino_phase3[i*2+1] = accu_wino_phase2[i*4+1] - accu_wino_phase2[i*4+2] - accu_wino_phase2[i*4+3];
                }
                (result[1], result[0]) = accu_wino_phase3[0];
                (result[3], result[2]) = accu_wino_phase3[1];
                (result[5], result[4]) = accu_wino_phase3[2];
                (result[7], result[6]) = accu_wino_phase3[3];
            } else {
                accu   = 0;
                for (channel_iter = 0; channel_iter < NVDLA_MAC_ATOMIC_C_SIZE; channel_iter++) {
                    data = (data_operand[channel_iter * 2 + 1].range(7, 0), data_operand[channel_iter * 2].range(7, 0));
                    weight = (weight_operand[channel_iter * 2 + 1], weight_operand[channel_iter * 2]);
                    if (channel_iter < NVDLA_MAC_ATOMIC_C_SIZE / 2) {
                        if (((wt_mask[1] >> (channel_iter * 2)) & 0x1) != ((wt_mask[1] >> (channel_iter * 2 + 1)) & 0x1))
                            FAIL(("Incorrect wt_mask[1]\n")); 
                        if (((dat_mask[1] >> (channel_iter * 2)) & 0x1) != ((dat_mask[1] >> (channel_iter * 2 + 1)) & 0x1))
                            FAIL(("Incorrect dat_mask[1]\n")); 
                        if (((wt_mask[1] >> (channel_iter * 2)) & 0x1) == 0) {
                            if (weight != 0)
                                FAIL(("Incorrect weight and wt_mask[1]\n"));
                            continue;
                        }
                        if (((dat_mask[1] >> (channel_iter * 2)) & 0x1) == 0) {
                            continue;
                        }
                    }
                    else {
                        if (((wt_mask[0] >> ((channel_iter - NVDLA_MAC_ATOMIC_C_SIZE / 2) * 2)) & 0x1) != ((wt_mask[0] >> ((channel_iter - NVDLA_MAC_ATOMIC_C_SIZE / 2) * 2 + 1)) & 0x1))
                            FAIL(("Incorrect wt_mask[0]\n")); 
                        if (((dat_mask[0] >> ((channel_iter - NVDLA_MAC_ATOMIC_C_SIZE / 2) * 2)) & 0x1) != ((dat_mask[0] >> ((channel_iter - NVDLA_MAC_ATOMIC_C_SIZE / 2) * 2 + 1)) & 0x1))
                            FAIL(("Incorrect dat_mask[0]\n")); 
                        if (((wt_mask[0] >> ((channel_iter - NVDLA_MAC_ATOMIC_C_SIZE / 2) * 2)) & 0x1) == 0) {
                            if (weight != 0)
                                FAIL(("Incorrect weight and wt_mask[0]\n"));
                            continue;
                        }
                        if (((dat_mask[0] >> ((channel_iter - NVDLA_MAC_ATOMIC_C_SIZE / 2) * 2)) & 0x1) == 0) {
                            continue;
                        }
                    }
                    accu = accu + data * weight;
                    cslDebug((70, "    channel_iter is 0x%x\n", channel_iter));
                    cslDebug((70, "    Data        : 0x%x\n", (uint32_t)data));
                    cslDebug((70, "    Weight      : 0x%x\n", (uint32_t)weight));
                    cslDebug((70, "    accu       : 0x%lx\n", (uint64_t)accu));
                }
                (result[1], result[0]) = accu;
                cslDebug((70, "    calculation_int16 result[0] = 0x%x result[1] = 0x%x\n", (uint32_t)result[0], (uint32_t)result[1]));
            }
        }
    }

    void cal_fp16_nan(uint64_t* wt_mask, uint64_t* dat_mask, sc_int<DATA_OPERAND_BIT_WIDTH_INT8> *data_operand, sc_int<WEIGHT_OPERAND_BIT_WIDTH_INT8> *weight_operand, sc_int<OUTPUT_BIT_WIDTH_INT16> *nan_value, uint32_t* nan_flag) {
        uint32_t    ch_iter;
        sc_int<FP16_EXP_BIT_WIDTH>      fp16_exp;
        sc_int<FP16_FRA_BIT_WIDTH>      fp16_fra;
        uint32_t    nan_idx, cur_idx;

#ifdef DEBUG_CHECK
        int8_t mask_k0;
        int8_t mask_k1;
        uint32_t    i;
#endif
    
        *nan_flag = 0; 
        *nan_value = 0;
        nan_idx = NVDLA_MAC_ATOMIC_C_SIZE * 2;
#pragma CTC SKIP
        // There is no NaN in weight
        for (ch_iter = 0; ch_iter < NVDLA_MAC_ATOMIC_C_SIZE; ch_iter++) {
            fp16_exp = weight_operand[ch_iter * 2 + 1].range(6, 2);
            fp16_fra = (weight_operand[ch_iter * 2 + 1].range(1, 0), weight_operand[ch_iter * 2](7, 0));
            cur_idx = ch_iter;
            if((fp16_exp == -1) && (fp16_fra != 0) && (cur_idx < nan_idx)) {
#if LOG_DETAIL
                cslDebug((70, "[FP16_NAN] find weight nan, cur_idx = %d\n\n", cur_idx));
#endif
                *nan_flag = 1;
                nan_idx = cur_idx;
                nan_value->range(43,38) = 0x3f;
                nan_value->range(26,0) = 0;
                nan_value->range(37, 37) = weight_operand[ch_iter * 2 + 1].range(7, 7);
                nan_value->range(36,27) = fp16_fra;
            }

#ifdef DEBUG_CHECK
            i = 1 - int(ch_iter / (NVDLA_MAC_ATOMIC_C_SIZE / 2));
            mask_k0 = (wt_mask[i] >> (channel_iter*2)) & 0x1;
            mask_k1 = (wt_mask[i] >> (channel_iter*2+1)) & 0x1;
            if(fp16_exp == 0 && fp16_fra == 0 && (mask_k0 != 0 || mask_k1 != 0)) {
                FAIL(("Incorrect wt_mask, non-zero mask for zero value\n"));
            } else if ((fp16_exp != 0 || fp16_fra != 0) && (mask_k0 == 0 || mask_k1 == 0)) {
                FAIL(("Incorrect wt_mask, zero mask for non-zero value\n"));
            }
#else
            if(*nan_flag == 1) {
                return;
            }
#endif
        }
#pragma CTC ENDSKIP
        
        for (ch_iter = 0; ch_iter < NVDLA_MAC_ATOMIC_C_SIZE; ch_iter++) {
            fp16_exp = data_operand[ch_iter * 2 + 1].range(6, 2);
            fp16_fra = (data_operand[ch_iter * 2 + 1].range(1, 0), data_operand[ch_iter * 2](7, 0));
            cur_idx = ch_iter + NVDLA_MAC_ATOMIC_C_SIZE;
            if((fp16_exp == -1) && (fp16_fra != 0) && (cur_idx < nan_idx)) {
#if LOG_DETAIL
                cslDebug((70, "[FP16_NAN] find data nan, cur_idx = %d\n\n", cur_idx));
#endif
                *nan_flag = 1;
                nan_idx = cur_idx;
                nan_value->range(43,38) = 0x3f;
                nan_value->range(26,0) = 0;
                nan_value->range(37,37) = data_operand[ch_iter*2+1].range(7,7);
                nan_value->range(36,27) = fp16_fra;
            }

#ifdef DEBUG_CHECK
            i = 1 - int(ch_iter / (NVDLA_MAC_ATOMIC_C_SIZE / 2));
            mask_k0 = (dat_mask[i] >> (channel_iter*2)) & 0x1;
            mask_k1 = (dat_mask[i] >> (channel_iter*2+1)) & 0x1;
            if(fp16_exp == 0 && fp16_fra == 0 && (mask_k0 != 0 || mask_k1 != 0)) {
                FAIL(("Incorrect dat_mask, non-zero mask for zero value\n"));
            } else if ((fp16_exp != 0 || fp16_fra != 0) && (mask_k0 == 0 || mask_k1 == 0)) {
                FAIL(("Incorrect dat_mask, zero mask for non-zero value\n"));
            }
#endif
            if(*nan_flag == 1) {
                return;
            }
        }

        return;
    }

    void cal_fp16_exp(uint64_t* wt_mask, uint64_t* dat_mask, sc_int<DATA_OPERAND_BIT_WIDTH_INT8> *data_operand, sc_int<WEIGHT_OPERAND_BIT_WIDTH_INT8> *weight_operand, uint32_t* dat_exp_sft, uint32_t* wt_exp_sft, uint32_t* sum_exp_sft, uint32_t* max_exp) {
        int32_t     i, j;
        uint32_t    exp_iter;
        uint32_t    dat_exp, wt_exp;

        *max_exp = 0;
        for(exp_iter = 0; exp_iter < NVDLA_MAC_ATOMIC_C_SIZE; exp_iter ++) {
            i = 1 - int(exp_iter / (NVDLA_MAC_ATOMIC_C_SIZE / 2));
            j = (exp_iter % (NVDLA_MAC_ATOMIC_C_SIZE / 2)) * 2;
            dat_exp = data_operand[exp_iter * 2 + 1].range(6, 2);
            wt_exp = weight_operand[exp_iter * 2 + 1].range(6, 2);

            if(!((wt_mask[i] >> j) & 0x1) || !((dat_mask[i] >> j) & 0x1)) {
                dat_exp_sft[exp_iter] = 0;
                wt_exp_sft[exp_iter] = 0;
                sum_exp_sft[exp_iter] = 0;
            } else {
                if(dat_exp == 0) {
                    dat_exp_sft[exp_iter] = 1;
                } else {
                    dat_exp_sft[exp_iter] = dat_exp & 0x3;
                }

                if(wt_exp == 0) {
                    wt_exp_sft[exp_iter] = 1;
                } else {
                    wt_exp_sft[exp_iter] = wt_exp & 0x3;
                }

                sum_exp_sft[exp_iter] = (dat_exp >> 2) + (wt_exp >> 2);
            }

            if(sum_exp_sft[exp_iter] > *max_exp) {
                *max_exp = sum_exp_sft[exp_iter];
            }
        }

#if LOG_DETAIL
        cslDebug((50, "[FP16_EXP]: max_exp = %x\n\n", *max_exp));
#endif
        for(exp_iter = 0; exp_iter < NVDLA_MAC_ATOMIC_C_SIZE; exp_iter ++) {
            sum_exp_sft[exp_iter] = ((*max_exp - sum_exp_sft[exp_iter]) << 2);
        }
        *max_exp = *max_exp << 2;
    }

    inline void cal_fp16_booth(uint32_t res_sign, uint32_t wt_mts, uint32_t dat_mts, uint32_t sum_exp_sft, int32_t *mts_product) {
        int32_t     booth_code;
        int32_t     code_rev;
        uint32_t    booth_pp[8];
        int32_t     booth_inv[8];
        uint32_t    csa_pp[10];
        uint32_t    csa_sum, csa_carry;
        int32_t     i, j, k;
        int32_t     cur_pp, cur_group, st;
        uint32_t    sign_comp;
        int64_t     sum;

        *mts_product = 0;
#if LOG_DETAIL
        cslDebug((70, "[FP16_BOOTH]: wt_mts = 0x%04x, dat_mts = 0x%04x, sign = %d, sum_exp_sft = %d\n", wt_mts, dat_mts, res_sign, sum_exp_sft));
#endif

        if(sum_exp_sft >= 32) {
#if LOG_DETAIL
            cslDebug((70, "[FP16_BOOTH]: pp_0_sft = 0x00000000, pp_1_sft = 0x00000000\n"));
            cslDebug((70, "[FP16_MUL]: Booth result = 0x00000000, sign_comp = 0x00000000\n"));
#endif
            return;
        }

        code_rev = res_sign ? 0x7 : 0x0;
        wt_mts = wt_mts << 1;
        for(i = 0; i < 8; i ++) {
            booth_code = (wt_mts & 0x7) ^ code_rev;
            wt_mts = wt_mts >> 2;
            switch(booth_code) {
                case 0:
                case 7:
                    booth_pp[i] = 0x10000;
                    booth_inv[i] = 0;
                    break;

                case 1:
                case 2:
                    booth_pp[i] = dat_mts | 0x10000;
                    booth_inv[i] = 0;
                    break;

                case 3:
                    booth_pp[i] = (dat_mts << 1) | 0x10000;
                    booth_inv[i] = 0;
                    break;

                case 4:
                    booth_pp[i] = ~(dat_mts << 1) & 0xffff;
                    booth_inv[i] = 1;
                    break;

                case 5:
                case 6:
                    booth_pp[i] = ~dat_mts & 0xffff;
                    booth_inv[i] = 1;
                    break;

                default:
                    FAIL(("Invalid case when booth coding, booth_code = %d\n", booth_code)); 
            }
#if LOG_DETAIL
            //cslDebug((50, "[FP16_BOOTH]: booth_code[%02d] = %x, booth_pp[%02d] = %08x, booth_inv[%02d] = %d\n", i, booth_code, i, booth_pp[i], i, booth_inv[i]));
#endif
        }

        csa_pp[0] = booth_pp[0];
        csa_pp[1] = (booth_pp[1] << 2) | (booth_inv[0] << 0);
        csa_pp[2] = (booth_pp[2] << 4) | (booth_inv[1] << 2);
        csa_pp[3] = (booth_pp[3] << 6) | (booth_inv[2] << 4);
        csa_pp[4] = (booth_inv[3] << 6);
        csa_pp[5] = (booth_pp[4] << 8);
        csa_pp[6] = (booth_pp[5] << 10) | (booth_inv[4] << 8);
        csa_pp[7] = (booth_pp[6] << 12) | (booth_inv[5] << 10);
        csa_pp[8] = (booth_pp[7] << 14) | (booth_inv[6] << 12);
        csa_pp[9] = (booth_inv[7] << 14);

#if LOG_DETAIL
        //for(i = 0; i < 10; i ++) {
        //    cslDebug((50, "[FP16_BOOTH]: csa_pp[%02d] = %08x\n", i, csa_pp[i]));
        //}
#endif

        for(i = 0; i < 3; i ++) {
            if(i == 0) {
                cur_pp = 5;
                st = 0;
            } else if(i == 1) {
                cur_pp = 5;
                st = 5;
            } else {
                csa_pp[2] = csa_pp[5];
                csa_pp[3] = csa_pp[6];
                cur_pp = 4;
                st = 0;
            }

            while(cur_pp >= 3) {
                cur_group = int(cur_pp / 3);
                for(j = 0; j < cur_group; j ++) {
                    csa_sum = csa_pp[st+j*3] ^ csa_pp[st+j*3+1] ^ csa_pp[st+j*3+2];
                    csa_carry = (csa_pp[st+j*3] & csa_pp[st+j*3+1]) |
                                (csa_pp[st+j*3+1] & csa_pp[st+j*3+2]) |
                                (csa_pp[st+j*3+0] & csa_pp[st+j*3+2]);
                    csa_carry = (csa_carry << 1);
                    csa_pp[st+j*2] = csa_sum;
                    csa_pp[st+j*2+1] = csa_carry;
                }
                for(j = cur_group*3; j < cur_pp; j ++) {
                    k = j - cur_group;
                    csa_pp[st+k] = csa_pp[st+j];
                }
                cur_pp -= cur_group;
            }
        }

#if LOG_DETAIL
        //cslDebug((50, "[FP16_BOOTH]: pp_0 = 0x%08x, pp_1 = 0x%08x\n", csa_pp[0], csa_pp[1]));
#endif
        csa_pp[0] = (csa_pp[0] >> sum_exp_sft);
        csa_pp[1] = (csa_pp[1] >> sum_exp_sft);

        if(sum_exp_sft > 28) {
            sign_comp = 0;
        } else if(sum_exp_sft == 28) {
            sign_comp = 0xfffffffb;
        } else if(sum_exp_sft == 24) {
            sign_comp = 0xffffffab;
        } else if(sum_exp_sft == 20) {
            sign_comp = 0xfffffaab;
        } else if(sum_exp_sft == 16) {
            sign_comp = 0xffffaaab;
        } else if(sum_exp_sft == 12) {
            sign_comp = 0xfffaaab0;
        } else if(sum_exp_sft == 8) {
            sign_comp = 0xffaaab00;
        } else if(sum_exp_sft == 4) {
            sign_comp = 0xfaaab000;
        } else if(sum_exp_sft == 0) {
            sign_comp = 0xaaab0000;
        } else {
            FAIL(("FP16 shift error! sum_exp_sft = %d\n", sum_exp_sft)); 
        }

#if LOG_DETAIL
        cslDebug((70, "[FP16_BOOTH]: pp_0_sft = 0x%08x, pp_1_sft = 0x%08x\n", csa_pp[0], csa_pp[1]));
        cslDebug((70, "[FP16_MUL]: Booth result = 0x%08x, sign_comp = 0x%08x\n", (csa_pp[0]+csa_pp[1]), sign_comp));
#endif
        sum = csa_pp[0] + csa_pp[1] + sign_comp;
        sum = sum & 0x00000000ffffffff;

        if(sum >= 0x80000000) {
            sum = sum - 0x100000000;
        }
        *mts_product = sum;
    }

    void cal_fp16_mul(uint64_t* wt_mask, uint64_t* dat_mask, sc_int<DATA_OPERAND_BIT_WIDTH_INT8> *data_operand, sc_int<WEIGHT_OPERAND_BIT_WIDTH_INT8> *weight_operand,
                      uint32_t* dat_exp_sft, uint32_t* wt_exp_sft, uint32_t* sum_exp_sft, int32_t* mts_product) {
        uint32_t    ch_iter;
        sc_int<DATA_OPERAND_BIT_WIDTH_INT16>    fp16_mts;
        uint32_t    res_sign;
        uint32_t    dat_mts, wt_mts;
        int32_t     i, j;
#ifdef DEBUG_ERROR_CHECK
        int32_t     dat_val, wt_val;
        int32_t     res_veri;
        int32_t     res_delta;

#endif

        fp16_mts.range(15,11) = 0;
        for(ch_iter = 0; ch_iter < NVDLA_MAC_ATOMIC_C_SIZE; ch_iter ++) {
#if LOG_DETAIL
            cslDebug((50, "[FP16_MUL] mul_idx = %d\n", ch_iter));
#endif
            i = 1 - int(ch_iter / (NVDLA_MAC_ATOMIC_C_SIZE / 2));
            j = (ch_iter % (NVDLA_MAC_ATOMIC_C_SIZE / 2)) * 2;

            if(!((wt_mask[i] >> j) & 0x1) || !((dat_mask[i] >> j) & 0x1)) {
#if LOG_DETAIL
                cslDebug((70, "[FP16_MUL]: Booth result = 0x00000000, sign_comp = 0x00000000\n"));
                cslDebug((50, "[FP16_MUL]: wt_val = 0x%04x, dat_val = 0x%04x, sum_exp_sft = %d, sign = %d\n", wt_val, dat_val, sum_exp_sft[ch_iter], res_sign));
                cslDebug((50, "[FP16_MUL]: Real result = 0x00000000, stand result = 0x00000000, result delta = 0\n\n"));
#endif
                mts_product[ch_iter] = 0;
                continue;
            } else {
                res_sign = weight_operand[ch_iter*2+1].range(7,7) ^ data_operand[ch_iter*2+1](7,7);

                fp16_mts.range(9,0) = (weight_operand[ch_iter*2+1].range(1,0), weight_operand[ch_iter*2].range(7,0));
                if(weight_operand[ch_iter*2+1].range(6,2) != 0) {
                    fp16_mts.range(10,10) = 1;
                } else {
                    fp16_mts.range(10,10) = 0;
                }
                wt_mts = (fp16_mts << wt_exp_sft[ch_iter]);

                fp16_mts.range(9,0) = (data_operand[ch_iter*2+1].range(1,0), data_operand[ch_iter*2].range(7,0));
                if(data_operand[ch_iter*2+1].range(6,2) != 0) {
                    fp16_mts.range(10,10) = 1;
                } else {
                    fp16_mts.range(10,10) = 0;
                }
                dat_mts = (fp16_mts << dat_exp_sft[ch_iter]);

                cal_fp16_booth(res_sign, wt_mts, dat_mts, sum_exp_sft[ch_iter], &(mts_product[ch_iter]));

#ifdef DEBUG_ERROR_CHECK
                wt_val = wt_mts;
                dat_val = dat_mts;
                if(sum_exp_sft[ch_iter] < 32) {
                    res_veri = (dat_val * wt_val);
                    if(res_sign) {
                        res_veri = 0 - res_veri;
                    }
                    res_veri = res_veri >> sum_exp_sft[ch_iter];
                } else {
                    res_veri = 0;
                }

                res_delta = res_veri - mts_product[ch_iter];
#if LOG_DETAIL
                cslDebug((50, "[FP16_MUL]: wt_val = 0x%04x, dat_val = 0x%04x, sum_exp_sft = %d, sign = %d\n", wt_val, dat_val, sum_exp_sft[ch_iter], res_sign));
                cslDebug((50, "[FP16_MUL]: Real result = 0x%08x, stand result = 0x%08x, result delta = %d\n\n", mts_product[ch_iter], res_veri, res_delta));
#endif
                if(res_delta > 1 || res_delta < -1) {
                    FAIL(("FP16 mantissa error is out of range! res_delta = %x\n", res_delta)); 
                }
#endif
            }
        }
    }


    void calculation_fp16(uint64_t* wt_mask, uint64_t* dat_mask, sc_int<DATA_OPERAND_BIT_WIDTH_INT8> *data_operand, sc_int<WEIGHT_OPERAND_BIT_WIDTH_INT8> *weight_operand, sc_int<OUTPUT_BIT_WIDTH_INT8> *result){
        sc_int<DATA_OPERAND_BIT_WIDTH_INT16>   data;
        sc_int<WEIGHT_OPERAND_BIT_WIDTH_INT16> weight;
        sc_int<OUTPUT_BIT_WIDTH_INT16>         nan_value;
        uint32_t    nan_flag;
        uint32_t    result_iter;
        uint32_t    max_exp;
        uint32_t    dat_exp_sft[NVDLA_MAC_ATOMIC_C_SIZE];
        uint32_t    wt_exp_sft[NVDLA_MAC_ATOMIC_C_SIZE];
        uint32_t    sum_exp_sft[NVDLA_MAC_ATOMIC_C_SIZE];
        int32_t     mts_product[NVDLA_MAC_ATOMIC_C_SIZE];
        uint32_t    i;
        sc_int<FP16_MUL_BIT_WIDTH>             pp_phase1[16];
        sc_int<FP16_MUL_BIT_WIDTH>             pp_phase2[8];
        sc_int<FP16_MUL_BIT_WIDTH>             pp_phase3[4];
        sc_int<FP16_OEXP_BIT_WIDTH>            exp_dc;
        sc_int<FP16_OEXP_BIT_WIDTH>            exp_wg;

#ifdef DEBUG_ERROR_CHECK
        //using namespace half_float::detail;
        float  float_data=0;
        float  float_weight=0;
        half_float::detail::uint16 uint16_data_input;
        half_float::detail::uint16 uint16_weight_input;
        sc_uint<16> uint16_data;
        sc_uint<16> uint16_weight;
        double double_data=0;
        double double_weight=0;
        double double_out[4]={0,0,0,0};
        uint32_t j=0;
        double cmac_delta;
        double cal_out[4]={0,0,0,0};
        int32_t exp_new;
        double add4[16];
        double marray[NVDLA_MAC_ATOMIC_C_SIZE];
#endif

        for (result_iter=0; result_iter < RESULT_NUM_PER_MACELL; result_iter++) {
             result[result_iter] = 0;
        }

        cslDebug((50, "Calculation_fp16: mac_cell_enable_ is %s\n", mac_cell_enable_? "true": "false"));
        cslDebug((50, "    wt_mask[0]  : 0x%016lx\n", wt_mask[0]));
        cslDebug((50, "    wt_mask[1]  : 0x%016lx\n", wt_mask[1]));
        cslDebug((50, "    dat_mask[0] : 0x%016lx\n", dat_mask[0]));
        cslDebug((50, "    dat_mask[1] : 0x%016lx\n", dat_mask[1]));
        if (true == mac_cell_enable_) {
            cal_fp16_nan(wt_mask, dat_mask, data_operand, weight_operand, &nan_value, &nan_flag);

            if(nan_flag && winograd_op_) {
                (result[1], result[0]) = nan_value;
                (result[3], result[2]) = nan_value;
                (result[5], result[4]) = nan_value;
                (result[7], result[6]) = nan_value;
            } else if(nan_flag && !winograd_op_) {
                (result[1], result[0]) = nan_value;
            } else {
                cal_fp16_exp(wt_mask, dat_mask, data_operand, weight_operand, dat_exp_sft, wt_exp_sft, sum_exp_sft, &max_exp);
                cal_fp16_mul(wt_mask, dat_mask, data_operand, weight_operand, dat_exp_sft, wt_exp_sft, sum_exp_sft, mts_product);

                uint32_t channel_num = NVDLA_MAC_ATOMIC_C_SIZE / (4 * 4);

                for(i = 0; i < 4; i ++) {
                    pp_phase3[i] = 0;
                }

                for (i = 0; i < 16; i++) {
                    pp_phase1[i] = mts_product[i * channel_num] + mts_product[i * channel_num + 1] + mts_product[i * channel_num + 2] + mts_product[i * channel_num + 3];
                }

                if(!winograd_op_) {
                    for (i = 0; i < 16; i++) {
                        pp_phase3[0] += pp_phase1[i];
                    }
                    exp_dc = max_exp;
                    exp_wg = 0;
                } else {
                    for(i = 0; i < 4; i++) {
                        pp_phase2[i+0] = pp_phase1[i+0] + pp_phase1[i+4] + pp_phase1[i+8];
                        pp_phase2[i+4] = pp_phase1[i+4] - pp_phase1[i+8] - pp_phase1[i+12];
                    }

                    for(i = 0; i < 2; i ++) {
                        pp_phase3[i*2+0] = pp_phase2[i*4+0] + pp_phase2[i*4+1] + pp_phase2[i*4+2];
                        pp_phase3[i*2+1] = pp_phase2[i*4+1] - pp_phase2[i*4+2] - pp_phase2[i*4+3];
                    }
                    exp_dc = max_exp;
                    exp_wg = max_exp;
                }

                (result[1], result[0]) = (exp_dc, pp_phase3[0]);
                (result[3], result[2]) = (exp_wg, pp_phase3[1]);
                (result[5], result[4]) = (exp_wg, pp_phase3[2]);
                (result[7], result[6]) = (exp_wg, pp_phase3[3]);

                //stepheng. 20170406, add float checker.
#ifdef DEBUG_ERROR_CHECK
                for (j = 0; j < NVDLA_MAC_ATOMIC_C_SIZE; j++){
                    uint16_data_input = (data_operand[j * 2 + 1].range(7, 0), data_operand[j * 2].range(7, 0));
                    uint16_weight_input = (weight_operand[j * 2 + 1].range(7, 0), weight_operand[j * 2].range(7, 0));
                    uint16_data = uint16_data_input;
                    uint16_weight = uint16_weight_input;
                    if (uint16_data.range(14,0) == 0x7c00) {   //is max
                        if (uint16_data[15]) {float_data = -65536;} else {float_data = 65536;}
                    }
                    else
                        float_data = half_float::detail::half2float(uint16_data_input);

                    if (uint16_weight.range(14, 0) == 0x7c00){ //is max
                        if (uint16_weight[15]) {float_weight = -65536;} else {float_weight = 65536;}                    
                    }
                    else
                        float_weight= half_float::detail::half2float(uint16_weight_input);
                    double_data = float_data;
                    double_weight = float_weight;
                    marray[j]= double_data * double_weight;
                    cslDebug((50, "CMAC:index=0x%d data=0x%04x weight=0x%04x mul_result=0x%016lx marray[%d]=%e\n", j, uint16_data_input, uint16_weight_input, ((uint64_t)(result[1], result[0])), j, marray[j]));
                }
                exp_new = exp_dc;
                if(exp_new < 0) {
                	exp_new += 64;
                }
                exp_new -= 50;

                if(winograd_op_){
                    for (j = 0; j < NVDLA_MAC_ATOMIC_C_SIZE / 4; j++){
                        add4[j] = marray[j * 4] + marray[j * 4 + 1] + marray[j * 4 + 2] + marray[j * 4 + 3];
                    }
                    double_out[0] = add4[0] + add4[4] + add4[8] + add4[1] + add4[5] + add4[9] + add4[2] + add4[6] + add4[10];
                    double_out[1] = add4[1] + add4[5] + add4[9] - add4[2] - add4[6] - add4[10] - add4[3] - add4[7] - add4[11];
                    double_out[2] = add4[4] - add4[8] - add4[12] + add4[5] - add4[9] - add4[13] + add4[6] - add4[10] - add4[14];
                    double_out[3] = add4[5] - add4[9] - add4[13] - add4[6] + add4[10] + add4[14] - add4[7] + add4[11] + add4[15];
                    cmac_delta = 72 * pow(2, exp_new);
                    for (j = 0; j < 4; j++){
                        cal_out[j] = pp_phase3[j] * pow(2, exp_new);
                        if (fabs(double_out[j] - cal_out[j])> cmac_delta){
#ifdef LOG_DETAIL
                            cslDebug((50, "stepheng:the 0x%d\n th output, total 4", j));
                            //cslDebug((50, "stepheng:cmac pure V output origninal high 22bits: 0x%06lx\n",result[j*2+1] ));
                            //cslDebug((50, "stepheng:cmac pure V output origninal low 22bits: 0x%06lx\n",result[j*2] ));
                            cslDebug((50, "stepheng:cmac pure C double-2-hex output: 0x%016lx\n",*((uint64_t*)(&double_out[j])) ));
                            cslDebug((50, "stepheng:cmac pure V double-2-hex output: 0x%016lx\n",*((uint64_t*)(&cal_out[j])) ));                            
#endif
                            FAIL(("Error: CMAC output is not sync with high level checker!!\n"));
                        }
                    }
                }
                else {
                    for (j = 0; j < NVDLA_MAC_ATOMIC_C_SIZE; j++){
                        double_out[0] += marray[j];
                    }
                    cmac_delta = 128 * pow(2, exp_new);
                    cal_out[0] = pp_phase3[0] * pow(2, exp_new);
                    if (fabs(double_out[0] - cal_out[0])> cmac_delta) {
                        //cslDebug((50, "stepheng:cmac pure V output origninal high 22bits: 0x%06lx\n",result[1] ));
                        //cslDebug((50, "stepheng:cmac pure V output origninal low 22bits: 0x%06lx\n",result[0] ));
                        cslDebug((50, "stepheng:cmac pure C double-2-hex output: 0x%016lx\n",*((uint64_t*)(&double_out[0])) ));
                        cslDebug((50, "stepheng:cmac pure V double-2-hex output: 0x%016lx\n",*((uint64_t*)(&cal_out)) ));
                        FAIL(("Error: CMAC output is not sync with high level checker!!\n"));
                    }
                    else {
                        cslDebug((50, "stepheng:cmac pure C double-2-hex output: 0x%016lx (%e)\n", *((uint64_t*)(&double_out[0])), double_out[0]));
                    }
                }
#endif

            }
        }
    }
    
    void do_calc(bool enabled, bool wino_op) {
        mac_cell_enable_ = enabled;
        winograd_op_     = wino_op;
        switch (precision_) {
            case NVDLA_CMAC_A_D_MISC_CFG_0_PROC_PRECISION_INT8:
                calculation_int8(wt_mask_ptr_, dat_mask_ptr_, data_operand_ptr_, weight_operand_ptr_, result_ptr_);
                break;
            case NVDLA_CMAC_A_D_MISC_CFG_0_PROC_PRECISION_INT16:
                calculation_int16(wt_mask_ptr_, dat_mask_ptr_, data_operand_ptr_, weight_operand_ptr_, result_ptr_);
                break;
            case NVDLA_CMAC_A_D_MISC_CFG_0_PROC_PRECISION_FP16:
                calculation_fp16(wt_mask_ptr_, dat_mask_ptr_, data_operand_ptr_, weight_operand_ptr_, result_ptr_);
                break;
            default:
                break;
        }
    }
};

class NV_NVDLA_cmac:
    public  NV_NVDLA_cmac_base, // ports
    private cmac_a_reg_model      // cmac data path and write dma register accessing
{
    public:
        SC_HAS_PROCESS(NV_NVDLA_cmac);
        NV_NVDLA_cmac( sc_module_name module_name );
        ~NV_NVDLA_cmac();
        // Overload for pure virtual TLM target functions
        // # CSB request transport implementation shall in generated code
        void csb2cmac_a_req_b_transport (int ID, NV_MSDEC_csb2xx_16m_secure_be_lvl_t* payload, sc_time& delay);
        // # CSC-CMAC
        void sc2mac_dat_b_transport(int ID, nvdla_sc2mac_data_if_t* payload, sc_time& delay);
        void sc2mac_wt_b_transport(int ID, nvdla_sc2mac_weight_if_t* payload, sc_time& delay);
        

    private:
        // Variables
        bool is_there_ongoing_csb2cmac_a_response_;
        bool is_working_;
        sc_int<WEIGHT_OPERAND_BIT_WIDTH_INT8>   *weight_operand_shadow_;
        sc_int<WEIGHT_OPERAND_BIT_WIDTH_INT8>   *weight_operand_;
        sc_int<DATA_OPERAND_BIT_WIDTH_INT8>     *data_operand_;
        sc_int<OUTPUT_BIT_WIDTH_INT8>           *mac_result_;
        uint64_t                                 wt_mask[MAC_CELL_NUM][2];
        uint64_t                                 wt_mask_shadow[MAC_CELL_NUM][2];
        uint64_t                                 dat_mask[2];

        NvdlaMacCell *mac_cell_array;
        // Payloads

        // Delay
        sc_core::sc_time dma_delay_;
        sc_core::sc_time csb_delay_;
        sc_core::sc_time b_transport_delay_;

        // Events
        sc_event cmac_kickoff_;
        sc_event cmac_done_;

        // Operation mode
        uint32_t    cmac_operation_mode_;
        uint64_t    enabled_mac_cell_shadow_;
        uint64_t    enabled_mac_cell_active_;

        // Function declaration 
        // # Threads
        void CmacConsumerThread();
        // # Hardware layer trigger function
        void CmacHardwareLayerExecutionTrigger();
        // #  Functional functions
        void Reset();
        void CmacASendCsbResponse(uint8_t type, uint32_t data, uint8_t error_id);
        void UpdateWeightFromShadowToActive();

};

SCSIM_NAMESPACE_END()

extern "C" scsim::cmod::NV_NVDLA_cmac * NV_NVDLA_cmacCon(sc_module_name module_name);

#endif

