// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_common.h

#ifndef _NVDLA_COMMON_H_
#define _NVDLA_COMMON_H_

#include "ac_int.h"
#include "ac_fixed.h"

#define ACINTT(x) ac_int<x,true>
#define ACINTF(x) ac_int<x,false>

#define ACFIXT(x,y) ac_fixed<x,y,true, AC_RND_INF,AC_SAT>
#define ACFIXF(x,y) ac_fixed<x,y,false,AC_RND_INF,AC_SAT>

#define ACFIXTZT(x,y) ac_fixed<x,y,true, AC_TRN_ZERO,AC_SAT>
#define ACFIXTZF(x,y) ac_fixed<x,y,false,AC_TRN_ZERO,AC_SAT>

#define NAN_NO 0x0
#define NAN_YES 0x1

#define DENORM_NO 0x0
#define DENORM_YES 0x1

#define INF_NO 0x0
#define INF_YES 0x1

enum RoundingMode {
     TRUNCATE  
    ,ROUND_INF
};

//#define ACFIXT(x) ac_fixed<x,x,true>
//#define ACFIXF(x) ac_fixed<x,x,false>

#endif
