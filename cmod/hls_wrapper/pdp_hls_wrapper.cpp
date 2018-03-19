// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: pdp_hls_wrapper.cpp

#include <systemc.h>
#include "opendla.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#include "vlibs.h"

#include "log.h"
#include "pdp_hls_wrapper.h"

#define POOLING_METHOD_AVE              NVDLA_PDP_D_OPERATION_MODE_CFG_0_POOLING_METHOD_POOLING_METHOD_AVERAGE
#define POOLING_METHOD_MAX              NVDLA_PDP_D_OPERATION_MODE_CFG_0_POOLING_METHOD_POOLING_METHOD_MAX
#define POOLING_METHOD_MIN              NVDLA_PDP_D_OPERATION_MODE_CFG_0_POOLING_METHOD_POOLING_METHOD_MIN

// Inputs:
//  atomic_data_in: FP16 for W direction
//  line_buffer_ptr: FP17 format  (stored in 32bits)
// Outputs:
//  line_buffer_ptr: FP17 format
void HLS_PDP_PoolingStage0Calc_FP16_W(
    bool        is_first_element,
    uint32_t    padding_value_left,
    uint32_t    padding_value_right,
    uint8_t     pdp_pooling_method_,
    uint32_t    des_element_idx,
    uint32_t*   line_buffer_ptr,
    uint32_t    src_element_idx,
    uint16_t*   atomic_data_in
)
{
    vFp17Type o;
    ac_channel<vFp17Type> chn_a;
    ac_channel<vFp17Type> chn_b;
    ac_channel<vFp17Type> chn_o;
        
    ac_channel<vFp16Type> chn_a_fp16;
    ac_channel<vFp16Type> chn_b_fp16;
    ac_channel<vFp16Type> chn_o_fp16;

    vFp17Type pad_left = padding_value_left;
    vFp17Type pad_right = padding_value_right;
    ac_channel<vFp17Type> chn_pad_left; 
    ac_channel<vFp17Type> chn_pad_right; 
    chn_pad_left.write(pad_left);
    chn_pad_right.write(pad_right);

    if(pdp_pooling_method_ != POOLING_METHOD_AVE)
    {
        vFp16Type a = line_buffer_ptr[des_element_idx];   // Read HLS_FP16 from uint32_t
        chn_a_fp16.write(a);

        vFp16Type b = atomic_data_in[src_element_idx];
        chn_b_fp16.write(b);

        cslDebug((70, "HLS_PDP_PoolingStage0Calc_FP16_W, a=0x%x, b=0x%x, pl=0x%x, pr=0x%x, is_first=%d\n", (uint32_t)a, (uint32_t)b, padding_value_left, padding_value_right, is_first_element));
    }
    else
    {
        vFp17Type a = line_buffer_ptr[des_element_idx];   // Read HLS_FP17 from uint32_t
        chn_a.write(a);

        vFp16Type b = atomic_data_in[src_element_idx];
        chn_b_fp16.write(b);

        HLS_fp16_to_fp17(chn_b_fp16, chn_b);
        
        cslDebug((70, "HLS_PDP_PoolingStage0Calc_FP16_W, a=0x%x, b=0x%x, pl=0x%x, pr=0x%x, is_first=%d\n", (uint32_t)a, (uint32_t)b, padding_value_left, padding_value_right, is_first_element));
    }

    if (true == is_first_element) {
        if(pdp_pooling_method_ == POOLING_METHOD_AVE)
        {
            HLS_fp17_add(chn_b, chn_pad_left, chn_o);
            o = chn_o.read();

            chn_b.write(o);
            HLS_fp17_add(chn_b, chn_pad_right, chn_o);
            o = chn_o.read();
        }
        else   
        {
            o = chn_b_fp16.read();
        }
        line_buffer_ptr[des_element_idx] = o;
    } else {
        switch (pdp_pooling_method_) {
            case POOLING_METHOD_MIN:
                HLS_fp16_min(chn_a_fp16, chn_b_fp16, chn_o_fp16);
                o = chn_o_fp16.read();
                break;
            case POOLING_METHOD_MAX:
                HLS_fp16_max(chn_a_fp16, chn_b_fp16, chn_o_fp16);
                o = chn_o_fp16.read();
                break;
            case POOLING_METHOD_AVE:
                HLS_fp17_add(chn_a, chn_b, chn_o);
                o = chn_o.read();
                
                chn_a.write(o);
                HLS_fp17_add(chn_a, chn_pad_left, chn_o);
                o = chn_o.read();

                chn_a.write(o);
                HLS_fp17_add(chn_a, chn_pad_right, chn_o);
                o = chn_o.read();
                break;
 #pragma CTC SKIP
            default: 
                FAIL(("NV_NVDLA_pdp::PoolingStage0Calc: Invalid pooling method."));
 #pragma CTC ENDSKIP
        }
        line_buffer_ptr[des_element_idx] = o;
    }
}

vFp17Type kernel_width_map[8] = {
0x0000, //0.0
0x7c00, //1.0
0x8000, //2.0
0x8200, //3.0
0x8400, //4.0
0x8500, //5.0
0x8600, //6.0
0x8700};//7.0

// Inputs:
//  atomic_data_in: FP17 for H direction
//  line_buffer_ptr: FP17 format  (stored in 32bits)
// Outputs:
//  line_buffer_ptr: FP17 format
void HLS_PDP_PoolingStage0Calc_FP16_H(
    bool        is_first_element,
    uint32_t    padding_value_top,
    uint32_t    padding_value_bottom,
    uint32_t    kernel_width,
    uint8_t     pdp_pooling_method_,
    uint32_t    des_element_idx,
    uint32_t*   line_buffer_ptr,
    uint32_t    src_element_idx,
    uint32_t*   atomic_data_in
)
{
    ac_channel<vFp17Type> chn_kw_fp17, chn_pv_top_fp17, chn_pv_bottom_fp17, chn_pad_top, chn_pad_bottom;

    vFp17Type kw_fp17 = kernel_width_map[kernel_width];
    vFp17Type pv_top_fp17 = padding_value_top;
    vFp17Type pv_bottom_fp17 = padding_value_bottom;
    
    chn_pv_top_fp17.write(pv_top_fp17);
    chn_pv_bottom_fp17.write(pv_bottom_fp17);

    chn_kw_fp17.write(kw_fp17);
    HLS_fp17_mul(chn_pv_top_fp17, chn_kw_fp17, chn_pad_top);
    chn_kw_fp17.write(kw_fp17);
    HLS_fp17_mul(chn_pv_bottom_fp17, chn_kw_fp17, chn_pad_bottom);
    //============================================================
    vFp17Type o;
    ac_channel<vFp17Type> chn_a;
    ac_channel<vFp17Type> chn_b;
    ac_channel<vFp17Type> chn_o;
        
    ac_channel<vFp16Type> chn_a_fp16;
    ac_channel<vFp16Type> chn_b_fp16;
    ac_channel<vFp16Type> chn_o_fp16;
       
    if(pdp_pooling_method_ != POOLING_METHOD_AVE)
    {
        vFp16Type a = atomic_data_in[src_element_idx];
        chn_a_fp16.write(a);

        vFp16Type b = line_buffer_ptr[des_element_idx];   // Read HLS_FP16 from uint32_t
        chn_b_fp16.write(b);

        cslDebug((70, "HLS_PDP_PoolingStage0Calc_FP16_H, a=0x%x, b=0x%x, is_first=%d\n", (uint32_t)a, (uint32_t)b, is_first_element));
    }
    else
    {
        vFp17Type a = atomic_data_in[src_element_idx];
        chn_a.write(a);

        vFp17Type b = line_buffer_ptr[des_element_idx];   // Read HLS_FP17 from uint32_t
        chn_b.write(b);

        cslDebug((70, "HLS_PDP_PoolingStage0Calc_FP16_H, a=0x%x, b=0x%x, is_first=%d\n", (uint32_t)a, (uint32_t)b, is_first_element));
    }

    if (true == is_first_element) {
        if(pdp_pooling_method_ == POOLING_METHOD_AVE)
        {
            HLS_fp17_add(chn_a, chn_pad_top, chn_o);
            o = chn_o.read();
            
            chn_a.write(o);
            HLS_fp17_add(chn_a, chn_pad_bottom, chn_o);
            o = chn_o.read();
        }
        else   
        {
            o = chn_a_fp16.read();
        }
        line_buffer_ptr[des_element_idx] = o;
    } else {
        switch (pdp_pooling_method_) {
            case POOLING_METHOD_MIN:
                HLS_fp16_min(chn_a_fp16, chn_b_fp16, chn_o_fp16);
                o = chn_o_fp16.read();
                break;
            case POOLING_METHOD_MAX:
                HLS_fp16_max(chn_a_fp16, chn_b_fp16, chn_o_fp16);
                o = chn_o_fp16.read();
                break;
            case POOLING_METHOD_AVE:
                HLS_fp17_add(chn_a, chn_b, chn_o);
                o = chn_o.read();
         
                chn_a.write(o);
                HLS_fp17_add(chn_a, chn_pad_top, chn_o);
                o = chn_o.read();

                chn_a.write(o);
                HLS_fp17_add(chn_a, chn_pad_bottom, chn_o);
                o = chn_o.read();
                break;
 #pragma CTC SKIP
            default: 
                FAIL(("NV_NVDLA_pdp::PoolingStage0Calc: Invalid pooling method."));
 #pragma CTC ENDSKIP
        }
        line_buffer_ptr[des_element_idx] = o;
    }
}


// Inputs:
//  recip_kernel_width: HLS_FP17 format  (stored in 32bits)
//  recip_kernel_height: HLS_FP17 format  (stored in 32bits)
//  line_buffer_ptr: HLS_FP17 format  (stored in 32bits)
// Outputs:
//  atomic_data_out: FP16 format
void HLS_PDP_PoolingStage1Calc_FP16(
    uint8_t     pdp_pooling_method_,
    uint32_t    recip_kernel_width,
    uint32_t    recip_kernel_height,
    uint32_t    des_element_idx,
    uint16_t*   atomic_data_out,
    uint32_t    src_element_idx,
    uint32_t*   line_buffer_ptr
)
{
    vFp17Type recip_kernel_width_fp17 = recip_kernel_width;
    vFp17Type recip_kernel_height_fp17 = recip_kernel_height;
    ac_channel<vFp17Type> chn_recip_kernel_width_fp17;
    ac_channel<vFp17Type> chn_recip_kernel_height_fp17;
    chn_recip_kernel_width_fp17.write(recip_kernel_width_fp17);
    chn_recip_kernel_height_fp17.write(recip_kernel_height_fp17);
                
    cslDebug((70, "HLS_PDP_PoolingStage1Calc_FP16, recip_kernel_width=0x%x\n", recip_kernel_width));
    cslDebug((70, "HLS_PDP_PoolingStage1Calc_FP16, recip_kernel_height=0x%x\n", recip_kernel_height));

    switch (pdp_pooling_method_) {
        case POOLING_METHOD_MIN:
        case POOLING_METHOD_MAX:
            atomic_data_out[des_element_idx] = line_buffer_ptr[src_element_idx];
            break;
        case POOLING_METHOD_AVE: {
            vFp17Type a;
            vFp17Type o1;
            vFp17Type o2;
            vFp16Type o3;
            ac_channel<vFp17Type> chn_a;
            ac_channel<vFp17Type> chn_o1;
            ac_channel<vFp17Type> chn_o2;
            ac_channel<vFp16Type> chn_o3;

            // Read HLS_FP17 from uint32_t
            a = line_buffer_ptr[src_element_idx];
            chn_a.write(a);
            cslDebug((70, "HLS_PDP_PoolingStage1Calc_FP16, sum=0x%x\n", (uint32_t)a));
            HLS_fp17_mul(chn_a, chn_recip_kernel_width_fp17, chn_o1);
            o1 = chn_o1.read();
            cslDebug((70, "HLS_PDP_PoolingStage1Calc_FP16, sum*rw=0x%x\n", (uint32_t)o1));
            chn_o1.write(o1);
            HLS_fp17_mul(chn_o1, chn_recip_kernel_height_fp17, chn_o2);
            o2 = chn_o2.read();
            cslDebug((70, "HLS_PDP_PoolingStage1Calc_FP16, sum*rw*rh=0x%x\n", (uint32_t)o2));
            chn_o2.write(o2);
            HLS_fp17_to_fp16(chn_o2, chn_o3);
            o3 = chn_o3.read();
            cslDebug((70, "HLS_PDP_PoolingStage1Calc_FP16, result=0x%x\n", (uint32_t)o3));
            atomic_data_out[des_element_idx] = o3;
            break;
        }
 #pragma CTC SKIP
        default: 
                FAIL(("NV_NVDLA_pdp::PoolingStage0Calc: Invalid pooling method."));
 #pragma CTC ENDSKIP
    }
}
