// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_float.h

#ifndef _NVDLA_FLOAT_H_
#define _NVDLA_FLOAT_H_

#include "nvdla_int.h"

//==========================================================
// B = 2^E/2-1
// D = 2^E/
//NAN:     ^E-1 & f!=0.
//INF:     ^E-1 & f==0. 
//Denorm:   e==0 & f!=0. X=(-1)^s * 2^(0-D) * (0.f)
//0:        e==0 & f==0. X=(-1)^s0
//Norm:     e=(0,2^E-1). X=(-1)^s * 2^(e-B) * (1.f)
//
// RNE: Rounding to Nearest Even: 4drop,6carry,5makeLSBeven
//==========================================================

//===========================================================================
// FUNCTION
//===========================================================================
template< unsigned int ExpoWidth, unsigned int MantWidth>
bool IsDenorm (ACINTF(ExpoWidth) expo, ACINTF(MantWidth) mant) {
    return (expo == 0 && mant != 0);
}

template< unsigned int ExpoWidth, unsigned int MantWidth>
bool IsNaN (ACINTF(ExpoWidth) expo, ACINTF(MantWidth) mant) {
    return (expo == (1 << ExpoWidth) -1 && mant != 0);
}

template< unsigned int ExpoWidth, unsigned int MantWidth>
bool IsInf (ACINTF(ExpoWidth) expo, ACINTF(MantWidth) mant) {
    return (expo == (1 << ExpoWidth) -1 && mant == 0);
}

#pragma CTC SKIP
template< unsigned int ExpoWidth, unsigned int MantWidth>
bool IsPosInf (ACINTF(1) sign, ACINTF(ExpoWidth) expo, ACINTF(MantWidth) mant) {
    bool is_inf = IsInf<ExpoWidth,MantWidth>(expo, mant);
    return (sign == 0 && is_inf);
}
#pragma CTC ENDSKIP

#pragma CTC SKIP
template< unsigned int ExpoWidth, unsigned int MantWidth>
bool IsNegInf (ACINTF(1) sign, ACINTF(ExpoWidth) expo, ACINTF(MantWidth) mant) {
    bool is_inf = IsInf<ExpoWidth,MantWidth>(expo, mant);
    return (sign == 1 && is_inf);
}
#pragma CTC ENDSKIP

template< unsigned int ExpoWidth, unsigned int MantWidth>
bool IsZero (ACINTF(ExpoWidth) expo, ACINTF(MantWidth) mant) {
    return (expo == 0 && mant == 0);
}

template< unsigned int ExpoWidth, unsigned int MantWidth>
void SetToZero (ACINTF(1)& sign, ACINTF(ExpoWidth)& expo, ACINTF(MantWidth)& mant) {
    sign = sign;
    expo = 0;
    mant = 0;
}

#pragma CTC SKIP
template< unsigned int ExpoWidth, unsigned int MantWidth>
void SetToPosZero (ACINTF(1)& sign, ACINTF(ExpoWidth)& expo, ACINTF(MantWidth)& mant) {
    sign = 0;
    expo = 0;
    mant = 0;
}
#pragma CTC ENDSKIP

#pragma CTC SKIP
template< unsigned int ExpoWidth, unsigned int MantWidth>
void SetToNegZero (ACINTF(1)& sign, ACINTF(ExpoWidth)& expo, ACINTF(MantWidth)& mant) {
    sign = 1;
    expo = 0;
    mant = 0;
}
#pragma CTC ENDSKIP

template< unsigned int ExpoWidth, unsigned int MantWidth>
void SetToInf (ACINTF(1)& sign, ACINTF(ExpoWidth)& expo, ACINTF(MantWidth)& mant) {
    
    const unsigned int kExpoMax = (1ull << ExpoWidth) - 1 ;
    const unsigned int kMantMax = (1ull << MantWidth) - 1 ;
    sign = sign;
    expo = kExpoMax - 1;
    mant = kMantMax;
}

template<unsigned int ExpoWidth, unsigned int MantWidth >
void FpBitsToFloat (
     ACINTF(1+ExpoWidth+MantWidth) ubits 
    ,ACINTF(1)& o_sign
    ,ACINTF(ExpoWidth)& o_expo
    ,ACINTF(MantWidth)& o_mant
    ) {

    o_mant = ubits.template slc<MantWidth>(0);
    o_expo = ubits.template slc<ExpoWidth>(MantWidth);
    o_sign = ubits.template slc<1>(MantWidth+ExpoWidth);
}

template<unsigned int ExpoWidth, unsigned int MantWidth >
void FpSignedBitsToFloat (
     ACINTT(1+ExpoWidth+MantWidth) bits 
    ,ACINTF(1)& o_sign
    ,ACINTF(ExpoWidth)& o_expo
    ,ACINTF(MantWidth)& o_mant
    ) {
    
    typedef ACINTF(1+ExpoWidth+MantWidth) uT;

    uT ubits = (uT)bits;
    o_mant = ubits.template slc<MantWidth>(0);
    o_expo = ubits.template slc<ExpoWidth>(MantWidth);
    o_sign = ubits.template slc<1>(MantWidth+ExpoWidth);
}

//===========================================================================
// FUNCTION
//===========================================================================
template<unsigned int ExpoWidth, unsigned int MantWidth >
ACINTF(1+ExpoWidth+MantWidth) FpFloatToBits (
     ACINTF(1)& o_sign
    ,ACINTF(ExpoWidth)& o_expo
    ,ACINTF(MantWidth)& o_mant
    ) {

    typedef ACINTF(1+ExpoWidth+MantWidth) uT;
    typedef ACINTT(1+ExpoWidth+MantWidth) sT;

    uT ubits;

    ubits.template set_slc(0,o_mant);
    ubits.template set_slc(MantWidth,o_expo);
    ubits.template set_slc(MantWidth+ExpoWidth,o_sign);
    
    return ubits;
}

#pragma CTC SKIP
template<unsigned int ExpoWidth, unsigned int MantWidth >
ACINTF(1) FpGetSign (
     ACINTT(1+ExpoWidth+MantWidth) bits 
    ) {
    
    typedef ACINTF(1+ExpoWidth+MantWidth) uT;

    uT ubits = (uT)bits;
    return ubits.template slc<1>(MantWidth+ExpoWidth);
}
#pragma CTC ENDSKIP

#pragma CTC SKIP
//template<unsigned int ExpoWidth, unsigned int MantWidth >
//ACINTF(1) FpGetExpo (
//     ACINTT(1+ExpoWidth+MantWidth) bits 
//    ) {
//    
//    typedef ACINTF(1+ExpoWidth+MantWidth) uT;
//
//    uT ubits = (uT)bits;
//    return ubits.template slc<ExpoWidth>(MantWidth);
//}
#pragma CTC ENDSKIP

//template<unsigned int ExpoWidth, unsigned int MantWidth >
//ACINTF(1) FpGetMant (
//     ACINTT(1+ExpoWidth+MantWidth) bits 
//    ) {
//    
//    typedef ACINTF(1+ExpoWidth+MantWidth) uT;
//
//    uT ubits = (uT)bits;
//    return ubits.template slc<MantWidth>(0);
//}

//===========================================================================
// FUNCTION
//===========================================================================
template<unsigned int ExpoWidth, unsigned int MantWidth >
ACINTT(1+ExpoWidth+MantWidth) FpFloatToSignedBits (
     ACINTF(1)& o_sign
    ,ACINTF(ExpoWidth)& o_expo
    ,ACINTF(MantWidth)& o_mant
    ) {

    typedef ACINTF(1+ExpoWidth+MantWidth) uT;
    typedef ACINTT(1+ExpoWidth+MantWidth) sT;

    uT ubits;

    ubits.template set_slc(0,o_mant);
    ubits.template set_slc(MantWidth,o_expo);
    ubits.template set_slc(MantWidth+ExpoWidth,o_sign);
    
    sT bits = (sT)ubits;

    return bits;
}

//===========================================================================
// FUNCTION
//===========================================================================
// This is to shorten the width of mant with fixed value
// RNE: Rounding to Nearest Even
template<unsigned int iMantWidth, unsigned int oMantWidth >
bool FpMantRNE (
     ACINTF(iMantWidth) i_data
    ,ACINTF(oMantWidth)& o_data
    ) {
    
    //====================================================
    const unsigned int TruncWidth = iMantWidth-oMantWidth;
    const unsigned int StickWidth = iMantWidth-oMantWidth-1;
    
    typedef ACINTF(TruncWidth) TruncType;
    typedef ACINTF(StickWidth) StickType;
    typedef ACINTF(1)          GuardType;
    typedef ACINTF(1)          CarryType;
    //
    typedef ACINTF(iMantWidth) iDataType;
    typedef ACINTF(oMantWidth) oDataType;

    bool overflow = false;
    #pragma CTC SKIP
    if (iMantWidth <= oMantWidth) {
        o_data = ((oDataType)(i_data)) << (oMantWidth - iMantWidth);
        overflow = false;
    #pragma CTC ENDSKIP
    } else {
        // Exmaple: original 5 bits, need keep 2 MSB bits
        // L: LSB; G: GUARD; S:STICK; T: TRUNC
        // x  x  x  x  x 
        //   [L][G][ S  ] 
        //      [   T   ]


        TruncType t_mant = i_data.template slc<TruncWidth>(0);
        StickType s_mant = i_data.template slc<StickWidth>(0);
        GuardType g_mant = i_data.template slc<1>(StickWidth);
        oDataType o_mant = i_data.template slc<oMantWidth>(TruncWidth);
        #ifdef SVDEBUG    
        printf("\n RNE:i_data  = %x",i_data);
        printf("\n RNE:t_mant  = %x",t_mant);
        printf("\n RNE:s_mant  = %x",s_mant);
        printf("\n RNE:g_mant  = %x",g_mant);
        printf("\n RNE:o_mant  = %x",o_mant);
        #endif
        
        ACINTF(1) stick = s_mant.or_reduce();
        ACINTF(1) guard = g_mant==1;
        ACINTF(1) lsb   = o_mant[0]==1;
        CarryType carry = guard & (stick | lsb);
        #ifdef SVDEBUG    
        printf("\n RNE:stick  = %x",stick);
        printf("\n RNE:guard  = %x",guard);
        printf("\n RNE:lsb  = %x",lsb);
        printf("\n RNE:carry  = %x",carry);
        #endif

        o_data = o_mant + (oDataType)carry;
        
        overflow = (carry & o_mant.and_reduce()) ? true : false;

    }

    return overflow;
}

//===========================================================================
// FUNCTION
//===========================================================================
// This is to shorten the width of mant with variables(shift)
// RNE: Rounding to Nearest Even
template<unsigned int iMantWidth, unsigned int ShiftWidth, unsigned int oMantWidth>
bool FpMantDecShiftRight (
     ACINTF(iMantWidth) i_mant
    ,ACINTF(ShiftWidth) shift
    ,ACINTF(oMantWidth)& o_mant
    ) {
    
    #pragma CTC SKIP
    assert (shift > 0);
    #pragma CTC ENDSKIP
    
    const unsigned int DeltaWidth = iMantWidth-oMantWidth;

    typedef ACINTF(iMantWidth)  iMantType;
    typedef ACINTF(iMantWidth+1)  iMantPlusOneType;
    typedef ACINTF(oMantWidth)    oMantType;
    typedef ACINTF(oMantWidth+1)  oMantPlusOneType;
        
    iMantPlusOneType  i_mant_p1; i_mant_p1 = i_mant;
    i_mant_p1[iMantWidth] = 1; // add the implied 1

    iMantPlusOneType guard_mask = ((iMantPlusOneType)1)<<(DeltaWidth+shift-1);
    iMantPlusOneType stick_mask = (((iMantPlusOneType)1)<<(DeltaWidth+shift-1)) - 1;
    iMantPlusOneType least_mask = ((iMantPlusOneType)1)<<(DeltaWidth+shift);

    iMantPlusOneType guard_bits = i_mant_p1 & guard_mask; 
    iMantPlusOneType stick_bits = i_mant_p1 & stick_mask; 
    iMantPlusOneType least_bits = i_mant_p1 & least_mask; 

    ACINTF(1) guard = guard_bits.or_reduce();
    ACINTF(1) stick = stick_bits.or_reduce();
    ACINTF(1) least = least_bits.or_reduce();

    ACINTF(1) carry = guard & (stick | least);

    iMantPlusOneType i_mant_s = i_mant_p1 >> shift;
    oMantPlusOneType o_mant_p1 = i_mant_s.template slc<11>(DeltaWidth);

    oMantPlusOneType o_mant_sum = o_mant_p1 + carry;

    o_mant = o_mant_sum.template slc<oMantWidth>(0);
    bool overflow = o_mant_sum[oMantWidth];
    
    return overflow;
}

//===========================================================================
// FUNCTION
//===========================================================================
// in dla, this function will never used in Denorm Mode
template<unsigned int ExpoWidth, unsigned int iMantWidth, unsigned int oMantWidth, unsigned int DENORM, unsigned int NANMODE >
ACINTT(1+ExpoWidth+oMantWidth) FpMantWidthDec (
    ACINTT(1+ExpoWidth+iMantWidth) bits
    ) {

    #pragma CTC SKIP
    assert (iMantWidth > oMantWidth);
    #pragma CTC ENDSKIP
	
    enum { kExpoMax  = (1ull << ExpoWidth) - 1 };

    // Exmaple: original 5 bits, need keep 2 MSB bits
    // L: LSB; G: GUARD; S:STICK; T: TRUNC
    // x  x  x  x  x 
    //   [L][G][ S  ] 
    //      [   T   ]
    const unsigned int TruncWidth = iMantWidth-oMantWidth;
    const unsigned int StickWidth = iMantWidth-oMantWidth-1;

    typedef ACINTF(1+ExpoWidth+iMantWidth) uT;
    
    typedef ACINTF(1) SignType;
    typedef ACINTF(iMantWidth) iMantType;
    typedef ACINTF(iMantWidth+1) iMantPlusOneType;
    typedef ACINTF(oMantWidth) oMantType;
    typedef ACINTF(1+oMantWidth) oMantPlusOneType;
    typedef ACINTF(2+oMantWidth) oMantPlusTwoType;
    typedef ACINTF(ExpoWidth)  ExpoType;

    typedef ACINTF(TruncWidth) TruncType;
    typedef ACINTF(StickWidth) StickType;
    typedef ACINTF(1)          GuardType;
    typedef ACINTF(1)          CarryType;
    
    iMantType i_mant;
    oMantType o_mant;
    
    ExpoType  i_expo;
    SignType  i_sign;
    
    SignType  o_sign;

    FpSignedBitsToFloat<ExpoWidth,iMantWidth>(bits,i_sign,i_expo,i_mant);

    o_sign = i_sign;

    // + implied 1
    iMantPlusOneType i_mant_p1; i_mant_p1 = i_mant;
    i_mant_p1[iMantWidth] = 1; // add implied 1 on msb

    #pragma CTC SKIP
    if (DENORM == DENORM_YES) {
        bool is_denorm = IsDenorm<ExpoWidth,iMantWidth>(i_expo,i_mant);
        if (is_denorm) {
            i_mant_p1[iMantWidth] = 0; // add implied 0 on msb
        }
    }
    #pragma CTC ENDSKIP
    
    oMantPlusOneType o_mant_p1;
    bool overflow = FpMantRNE<iMantWidth+1,oMantWidth+1>(i_mant_p1,o_mant_p1);
    o_mant = (oMantType)o_mant_p1;

    ExpoType  o_expo; o_expo=i_expo;
    if (overflow) { // a denorm can never overflow 
        o_expo++;
        if (o_expo==kExpoMax) {
            SetToInf<ExpoWidth,oMantWidth>(o_sign,o_expo,o_mant);
        }
    } else {
        #pragma CTC SKIP
        if (DENORM == DENORM_YES) {
            bool is_denorm = IsDenorm<ExpoWidth,iMantWidth>(i_expo,i_mant);
            if (is_denorm && (o_mant_p1[oMantWidth] == 1)) {
                o_expo = 1; // a denorm becomes a norm after rounding
            }
        }
        #pragma CTC ENDSKIP
    }
    
    // NAN propagation
    #pragma CTC SKIP
    if (NANMODE == NAN_YES) {
        bool is_nan = IsNaN<ExpoWidth,iMantWidth>(i_expo,i_mant);
        if (is_nan) {
            o_sign = i_sign;
            o_expo = i_expo;
            o_mant = i_mant;
        }
    }
    #pragma CTC ENDSKIP

    return FpFloatToSignedBits<ExpoWidth,oMantWidth>(o_sign,o_expo,o_mant);
}

//===========================================================================
// FUNCTION
//===========================================================================
// Inc will change nothing 
template<unsigned int iExpoWidth, unsigned int oExpoWidth, unsigned int MantWidth, unsigned int DENORM, unsigned int NANMODE >
ACINTT(1+oExpoWidth+MantWidth) FpExpoWidthInc (
    ACINTT(1+iExpoWidth+MantWidth) bits
    ) {

    #pragma CTC SKIP
    assert (iExpoWidth <= oExpoWidth);
    #pragma CTC ENDSKIP
    
    const unsigned int koExpoBias = (1ull<< oExpoWidth)/2 - 1;
    const unsigned int kiExpoBias = (1ull<< iExpoWidth)/2 - 1;
    const unsigned int kExpoBiasDelta = koExpoBias - kiExpoBias;
    
    //const unsigned int kiExpoMax = (1ull << iExpoWidth) - 1 ;
    const unsigned int koExpoMax = (1ull << oExpoWidth) - 1 ;
    
    typedef ACINTF(1)          SignType;
    typedef ACINTF(iExpoWidth) iExpoType;
    typedef ACINTF(oExpoWidth) oExpoType;
    
    typedef ACINTF(MantWidth) MantType;
    typedef ACINTF(MantWidth+1) MantPlusOneType;

    SignType  i_sign;
    iExpoType i_expo;
    MantType i_mant;
    
    SignType  o_sign;
    oExpoType o_expo;
    MantType o_mant;
    MantPlusOneType o_mant_p1;
    //const unsigned int ShiftWidth = oExpoWidth - iExpoWidth;
    FpSignedBitsToFloat<iExpoWidth,MantWidth>(bits,i_sign,i_expo,i_mant);
    
    o_sign = i_sign;
    o_mant = (MantType)(i_mant);

    if (IsZero<iExpoWidth,MantWidth>(i_expo,i_mant)) {
        SetToZero<oExpoWidth,MantWidth>(o_sign,o_expo,o_mant);
    } else {
        o_expo = (oExpoType)(i_expo + kExpoBiasDelta);
    }

    if (DENORM == DENORM_YES) {
        bool is_denorm = IsDenorm<iExpoWidth,MantWidth>(i_expo,i_mant);
        if (is_denorm) {
            // convert a denorm to a norm who has large expo width
            MantType zero_count = IntLeadZero<MantWidth>(i_mant);
            o_expo = kExpoBiasDelta - zero_count;
            o_mant = ((MantPlusOneType)i_mant)<<(zero_count+1); // add MSB, shift, and cut MSB
        }
    }

    // INF based on the increased one
    if (IsInf<iExpoWidth,MantWidth>(i_expo,i_mant)) {
        SetToInf<oExpoWidth,MantWidth>(o_sign,o_expo,o_mant);
    }
    
    // NAN propagation
    //if (NANMODE == NAN_YES) {
        bool is_nan = IsNaN<iExpoWidth,MantWidth>(i_expo,i_mant);
        if (is_nan) {
            o_sign = i_sign;
            o_expo = koExpoMax;
            o_mant = i_mant;
        }
    //}

    return FpFloatToSignedBits<oExpoWidth,MantWidth>(o_sign,o_expo,o_mant);
}

//===========================================================================
// FUNCTION
//===========================================================================
// Inc will change nothing, and same if is denorm
template<unsigned int ExpoWidth, unsigned int iMantWidth, unsigned int oMantWidth,unsigned int DENORM, unsigned int NANMODE >
ACINTT(1+ExpoWidth+oMantWidth) FpMantWidthInc (
    ACINTT(1+ExpoWidth+iMantWidth) bits
    ) {

    #pragma CTC SKIP
    assert (iMantWidth <= oMantWidth);
    #pragma CTC ENDSKIP
    
    typedef ACINTF(1)          SignType;
    typedef ACINTF(ExpoWidth) ExpoType;
    
    typedef ACINTF(iMantWidth) iMantType;
    typedef ACINTF(oMantWidth) oMantType;

    SignType  i_sign;
    ExpoType i_expo;
    iMantType i_mant;
    
    SignType  o_sign;
    ExpoType o_expo;
    oMantType o_mant;
    
    const unsigned int ShiftWidth = oMantWidth - iMantWidth;

    FpSignedBitsToFloat<ExpoWidth,iMantWidth>(bits,i_sign,i_expo,i_mant);
    
    o_sign = i_sign;
    o_expo = i_expo;
    o_mant = ((oMantType)i_mant) << ShiftWidth;
    
    // NAN propagation
    //if (NANMODE == NAN_YES) {
        bool is_nan = IsNaN<ExpoWidth,oMantWidth>(i_expo,i_mant);
        if (is_nan) {
            o_sign = i_sign;
            o_expo = i_expo;
            o_mant = i_mant;
        }
    //}
    
    return FpFloatToSignedBits<ExpoWidth,oMantWidth>(o_sign,o_expo,o_mant);
}

//===========================================================================
// FUNCTION
//===========================================================================
// Inc will change nothing 
template<unsigned int iExpoWidth, unsigned int iMantWidth, unsigned int oExpoWidth, unsigned int oMantWidth, unsigned int DENORM, unsigned int NANMODE >
ACINTT(1+oExpoWidth+oMantWidth) FpWidthInc (
    ACINTT(1+iExpoWidth+iMantWidth) bits
    ) {

    #pragma CTC SKIP
    assert (iExpoWidth <= oExpoWidth);
    assert (iMantWidth <= oMantWidth);
    #pragma CTC ENDSKIP
    
    typedef ACINTT(1+iExpoWidth+oMantWidth)  mType;
    typedef ACINTT(1+oExpoWidth+oMantWidth)  oType;


    mType m;
    #pragma CTC SKIP
    if (iMantWidth == oMantWidth) {
        m = bits;
    #pragma CTC ENDSKIP
    } else {
        m =  FpMantWidthInc<iExpoWidth,iMantWidth,oMantWidth,DENORM, NANMODE>(bits);
    }

    oType o;
    #pragma CTC SKIP
    if (iExpoWidth == oExpoWidth) {
        o = m;
    #pragma CTC ENDSKIP
    } else {
        o =  FpExpoWidthInc<iExpoWidth,oExpoWidth,oMantWidth,DENORM, NANMODE>(m);
    }

    return o;
}

//===========================================================================
// FUNCTION
//===========================================================================
// 1, if >max, or <min, set to INF | 0
// 2, if result is denorm, right shift mant with NRE
// 3, if result is norm, change expo accordingly
template<unsigned int iExpoWidth, unsigned int oExpoWidth, unsigned int MantWidth, unsigned int DENORM, unsigned int NANMODE >
ACINTT(1+oExpoWidth+MantWidth) FpExpoWidthDec (
    ACINTT(1+iExpoWidth+MantWidth) bits
    ) {
    
    #pragma CTC SKIP
    assert (iExpoWidth > oExpoWidth);
    #pragma CTC ENDSKIP
    
    const unsigned int koExpoMax = (1ull << oExpoWidth) - 1 ;
    //const unsigned int kiExpoMax = (1ull << iExpoWidth) - 1 ;
    const unsigned int koExpoBias = (1ull<< oExpoWidth)/2 - 1;
    const unsigned int kiExpoBias = (1ull<< iExpoWidth)/2 - 1;
    const unsigned int kExpoBiasDelta = kiExpoBias - koExpoBias;

    typedef ACINTF(1)          SignType;
    typedef ACINTF(iExpoWidth) iExpoType;
    typedef ACINTF(oExpoWidth) oExpoType;
    typedef ACINTF(MantWidth)  MantType;
    typedef ACINTF(MantWidth+1)  MantPlusOneType;

    SignType  i_sign;
    iExpoType i_expo;
    MantType  i_mant;
    
    FpSignedBitsToFloat<iExpoWidth,MantWidth>(bits,i_sign,i_expo,i_mant);
    
    SignType  o_sign; o_sign=i_sign;
    oExpoType o_expo;
    MantType  o_mant;
    
    if (i_expo >= koExpoMax + kExpoBiasDelta ) { // set to INF if greater than koExpoMax
        SetToInf<oExpoWidth,MantWidth>(o_sign,o_expo,o_mant);
    } else if (i_expo < kExpoBiasDelta - MantWidth) { // 0, small enough which can NOT be denorm
        SetToZero<oExpoWidth,MantWidth>(o_sign,o_expo,o_mant);
    } else if (i_expo <= kExpoBiasDelta ) { // Denorm : 1.xxx * 2^(-15) = 0.1xxx * 2^(-14)
        //if (DENORM == DENORM_YES) {
            iExpoType i_shift = kExpoBiasDelta - i_expo + 1;

            bool overflow = FpMantDecShiftRight<MantWidth,iExpoWidth,MantWidth>(i_mant,i_shift,o_mant);

            if (overflow) { // become a norm value: 1.0*2^1
                o_expo = 1;
            } else {
                o_expo = 0;
            }
        //} else {
        //    SetToZero<oExpoWidth,MantWidth>(o_sign,o_expo,o_mant);
        //}
    } else { // norm
        o_expo = i_expo - kExpoBiasDelta;
        o_mant = i_mant;
    }
    
    // NAN propagation
    //if (NANMODE == NAN_YES) {
        bool is_nan = IsNaN<iExpoWidth,MantWidth>(i_expo,i_mant);
        if (is_nan) {
            o_sign = i_sign;
            o_expo = koExpoMax;
            o_mant = i_mant;
        }
    //}
    
    return FpFloatToBits<oExpoWidth,MantWidth>(o_sign,o_expo,o_mant);
}

//===========================================================================
// FUNCTION
//===========================================================================
//1, convert iMant -> oMant firstly, with RNE 
//2, convert iOxpo -> oExpo secondly
template<unsigned int iExpoWidth, unsigned int iMantWidth, unsigned int oExpoWidth, unsigned int oMantWidth, unsigned int DENORM, unsigned int NANMODE >
ACINTT(1+oExpoWidth+oMantWidth) FpWidthDec (
    ACINTT(1+iExpoWidth+iMantWidth) bits
    ) {

    #pragma CTC SKIP
    assert (iMantWidth >= oMantWidth);
    assert (iExpoWidth >= oExpoWidth);
    #pragma CTC ENDSKIP
	
    const unsigned int koExpoMax = (1ull << oExpoWidth) - 1 ;
    //const unsigned int kiExpoMax = (1ull << iExpoWidth) - 1 ;
    const unsigned int kiExpoBias = (1ull<< iExpoWidth)/2 - 1;
    const unsigned int koExpoBias = (1ull<< oExpoWidth)/2 - 1;
    const unsigned int kExpoBiasDelta = kiExpoBias - koExpoBias;

    // Exmaple: original 5 bits, need keep 2 MSB bits
    // L: LSB; G: GUARD; S:STICK; T: TRUNC
    // x  x  x  x  x 
    //   [L][G][ S  ] 
    //      [   T   ]
    const unsigned int TruncWidth = iMantWidth-oMantWidth;
    const unsigned int StickWidth = iMantWidth-oMantWidth-1;

    typedef ACINTF(1+iExpoWidth+iMantWidth) uIn;
    
    typedef ACINTF(1) SignType;
    
    typedef ACINTF(iMantWidth)      iMantType;
    typedef ACINTF(iMantWidth+1)    iMantPlusOneType;
    
    typedef ACINTF(oMantWidth)      oMantType;
    typedef ACINTF(1+oMantWidth)    oMantPlusOneType;
    typedef ACINTF(2+oMantWidth)    oMantPlusTwoType;

    typedef ACINTF(iExpoWidth) iExpoType;
    typedef ACINTF(oExpoWidth) oExpoType;

    typedef ACINTF(TruncWidth) TruncType;
    typedef ACINTF(StickWidth) StickType;
    typedef ACINTF(1)          GuardType;
    typedef ACINTF(1)          CarryType;
    
    SignType  i_sign;
    iExpoType i_expo;
    iMantType i_mant;
    
    FpSignedBitsToFloat<iExpoWidth,iMantWidth>(bits,i_sign,i_expo,i_mant);

    SignType  o_sign = i_sign;
    oExpoType o_expo;
    oMantType o_mant;

    bool is_inf = 0;
    bool is_zero = 0;
    // ====================
    if (i_expo >= koExpoMax + kExpoBiasDelta ) { // set to INF if greater than koExpoMax`
        is_inf = 1;
    } else if (i_expo < kExpoBiasDelta - oMantWidth) { // 0, small enough which can NOT be denorm
        is_zero = 1;
    } else if (i_expo <= kExpoBiasDelta ) { // Denorm : fp16: 1.xxx * 2^(-15) = 0.1xxx * 2^(-14)
            iExpoType i_shift = kExpoBiasDelta - i_expo + 1;

            bool overflow = FpMantDecShiftRight<iMantWidth,iExpoWidth,oMantWidth>(i_mant,i_shift,o_mant);

        if (DENORM == DENORM_YES) {
            if (overflow) { // become a norm value, and mant must be ZERO
                o_expo = 1;
            } else {
                o_expo = 0;
            }
        } else {
            if (overflow) { // become a norm value, and mant must be ZERO
                o_expo = 1;
            } else {
                is_zero = 1;
            }
        }
    } else { // norm
        // EXPO
        o_expo = i_expo - kExpoBiasDelta;

        // MANT
        iMantPlusOneType i_mant_p1; i_mant_p1 = i_mant;
        i_mant_p1[iMantWidth] = 1; // add implied 1 on msb
    
        oMantPlusOneType o_mant_p1;

        bool overflow= FpMantRNE<iMantWidth+1,oMantWidth+1>(i_mant_p1,o_mant_p1);
        o_mant = o_mant_p1; // remove the implied MSB 1

        if (overflow) {
            o_expo++;
            if (o_expo==koExpoMax) {
                is_inf = 1;
            }
        }
    }

    if (is_inf) {
        SetToInf<oExpoWidth,oMantWidth>(o_sign,o_expo,o_mant);
    }

    if (DENORM == DENORM_YES) {
        if (is_zero) {
            SetToZero<oExpoWidth,oMantWidth>(o_sign,o_expo,o_mant);
        }
    } else {
        //if (is_zero || o_expo==0) {
        if (is_zero) {
            SetToZero<oExpoWidth,oMantWidth>(o_sign,o_expo,o_mant);
        }
    }
    
    // NAN propagation
    //if (NANMODE == NAN_YES) {
        bool is_nan = IsNaN<iExpoWidth,iMantWidth>(i_expo,i_mant);
        if (is_nan) {
            o_sign = i_sign;
            o_expo = koExpoMax;
            o_mant = i_mant;
        }
    //}

    return FpFloatToSignedBits<oExpoWidth,oMantWidth>(o_sign,o_expo,o_mant);
}

//===========================================================================
// FUNCTION: INTEGER to FLOAT
// with assumption:
// Fraction will not become a Denorm
// Fraction will not become a Inf
//===========================================================================
template<unsigned int FractionWidth, unsigned int ExpoWidth, unsigned int MantWidth >
ACINTF(1+ExpoWidth+MantWidth) FpFractionToFloat (
    ACINTF(FractionWidth) fraction
    ) {
    
    const unsigned int kExpoBias = (1ull<<ExpoWidth)/2 - 1;
    
    typedef ACINTF(FractionWidth) FracType;
    typedef ACINTF(FractionWidth+1) FracPlusOneType;
    
    typedef ACINTF(ExpoWidth) ExpoType;
    typedef ACINTF(MantWidth) MantType;
    typedef ACINTF(MantWidth+1) MantPlusOneType;
    typedef ACINTF(1)         SignType;
    
    SignType o_sign = 0;
    ExpoType o_expo = kExpoBias;
    MantType o_mant = 0;

    
    bool is_zero = 0;
    if (fraction != 0) {
        FracType zero_count = IntLeadZero<FractionWidth>(fraction);
        FracType zero_count_p1 = zero_count + 1;
        FracPlusOneType fraction_p1 = fraction;
        FracPlusOneType shifted_frac_p1 = fraction_p1 << zero_count_p1;

        #pragma CTC SKIP
        if (FractionWidth<=MantWidth) {
            FracType shifted_frac = shifted_frac_p1; // remove the MSB 1
            o_mant = shifted_frac<<(MantWidth - FractionWidth);
            o_expo -= zero_count+1;
        #pragma CTC ENDSKIP
        } else {
            MantPlusOneType o_mant_p1;
            bool overflow = FpMantRNE<FractionWidth+1,MantWidth+1>(shifted_frac_p1,o_mant_p1);
            if (overflow) {
                //if (o_expo <= zero_count) {
                //    is_zero = 1;
                //} else {
                    o_expo -= zero_count;
                    o_mant = o_mant_p1>>1;
                //}
            } else {
                if (o_expo <= zero_count + 1) {
                    is_zero = 1;
                } else {
                    o_mant = o_mant_p1;
                    o_expo -= zero_count + 1;
                }
            }
        }
    } else {
        is_zero = 1;
    }

    if (is_zero) {
        SetToZero<ExpoWidth,MantWidth>(o_sign,o_expo,o_mant);
    }
    
    return FpFloatToBits<ExpoWidth,MantWidth>(o_sign,o_expo,o_mant);

}

// float to float with same format, change INF to MAX
//template< unsigned int ExpoWidth, unsigned int MantWidth, unsigned int DENORM, unsigned int NAN, unsigned int INF >
//template< unsigned int ExpoWidth, unsigned int MantWidth>
//ACINTT( 1 + ExpoWidth + MantWidth ) FpFloatToFloat (
//    ACINTT(1+ExpoWidth+MantWidth) bits
//    ) {
//    
//    typedef ACINTF(1)         SignType;
//    typedef ACINTF(ExpoWidth) ExpoType;
//    typedef ACINTF(MantWidth) MantType;
//
//    SignType i_sign;
//    ExpoType i_expo;
//    MantType i_mant;
//    FpSignedBitsToFloat<ExpoWidth,MantWidth>(bits,i_sign,i_expo,i_mant);
//
//    bool is_inf = IsInf<ExpoWidth,MantWidth>(i_expo,i_mant);
//
//    SignType o_sign = i_sign;
//    ExpoType o_expo = i_expo;
//    MantType o_mant = i_mant;
//    if (is_inf) {
//        SetToInf<ExpoWidth,MantWidth>(o_sign,o_expo,o_mant);
//    }
//    return FpFloatToSignedBits<ExpoWidth,MantWidth>(o_sign,o_expo,o_mant);
//}


//===========================================================================
// FUNCTION
//===========================================================================
// DENORM_YES means the smaller one can be denorm or not. if not, will be set to 0;
inline ACINTT(1+8+23) Fp16ToFp32 (
    ACINTT(1+5+10) bits
    ) {
    return FpWidthInc<5,10,8,23,DENORM_YES, NAN_YES>(bits);
}

inline ACINTT(1+5+10) Fp32ToFp16 (
    ACINTT(1+8+23) bits
    ) {
    return FpWidthDec<8,23,5,10,DENORM_YES, NAN_YES>(bits);
}

inline ACINTT(1+6+10) Fp16ToFp17 (
    ACINTT(1+5+10) bits
    ) {
    return FpExpoWidthInc<5,6,10,DENORM_YES, NAN_YES>(bits);
}
inline ACINTT(1+5+10) Fp17ToFp16 (
    ACINTT(1+6+10) bits
    ) {
    return FpExpoWidthDec<6,5,10,DENORM_YES, NAN_YES>(bits);
}

inline ACINTT(1+8+23) Fp17ToFp32 (
    ACINTT(1+6+10) bits
    ) {
    return FpWidthInc<6,10,8,23,DENORM_NO, NAN_YES>(bits);
}

inline ACINTT(1+6+10) Fp32ToFp17 (
    ACINTT(1+8+23) bits
    ) {
    return FpWidthDec<8,23,6,10,DENORM_NO, NAN_YES>(bits);
}

//inline ACINTT(1+5+10) Fp16ToFp16 (
//    ACINTT(1+5+10) bits
//    ) {
//    //return FpFloatToFloat<5,10,DENORM_NO,NAN_NO,INF_YES>(bits);
//    return FpFloatToFloat<5,10>(bits);
//}

//===========================================================================
// FUNCTION
//===========================================================================
template<unsigned int ExpoWidth, unsigned int MantWidth >
void FpNormalize (
     ACINTF(1)& sign
    ,ACINTF(ExpoWidth)& expo
    ,ACINTF(MantWidth)& mant
    ) {

    typedef ACINTF(ExpoWidth) ExpoType; 
    typedef ACINTF(MantWidth) MantType; 

    MantType zero_count = IntLeadZero<MantWidth>(mant);

    if (expo <= zero_count || mant == 0) {
        SetToZero<ExpoWidth,MantWidth>(sign,expo,mant);
    } else {
        sign  = sign;
        expo -= zero_count;
        mant <<= zero_count;
    }
}
//===========================================================================
// FUNCTION
//===========================================================================
// 1, increase the input a/b to InternalMantWidth, which should be 2*MantWIdth+2 to keep all precision
// 2, add the mantissa and do RNE
// 3, 
template <unsigned int ExpoWidth, unsigned int MantWidth >
ACINTT(1+ExpoWidth+MantWidth) FpAdd (
      ACINTT(1+ExpoWidth+MantWidth) a
     ,ACINTT(1+ExpoWidth+MantWidth) b
    ) {
    
    const unsigned int kExpoMax = (1ull << ExpoWidth) - 1;
    const unsigned int kMantMoreWidth = MantWidth+2; // No precision lost
    const unsigned int InternalMantWidth = kMantMoreWidth + MantWidth + 1; // No precision lost
    
    typedef ACINTT(1+ExpoWidth+MantWidth)   sT;
    typedef ACINTF(1+ExpoWidth+MantWidth)   uT;

    typedef ACINTF(1)           SignType;
    typedef ACINTF(MantWidth)   MantType;
    typedef ACINTF(ExpoWidth)   ExpoType;
    
    typedef ACINTF(1+ExpoWidth) ExpoPlusOneType;

    typedef ACINTF(1+MantWidth) MantPlusOneType; // PlusOne is to hold the implied 1
    typedef ACINTF(2+MantWidth) MantPlusTwoType; // PlusTwo is to check whether overflow
    typedef ACINTF(2*MantWidth+1) MantX2PlusOneType; 
    typedef ACINTF(InternalMantWidth)  InternalMantType; 
    typedef ACINTF(1+InternalMantWidth) InternalMantPlusOneType; 

    typedef ACINTT(1+ExpoWidth) SignedShiftType;
    typedef ACINTF(ExpoWidth)   ShiftType;
    
    typedef SignType            oSignType;
    typedef ExpoPlusOneType     oExpoType;
    typedef MantType            oMantType;
    
    ACINTF(1)   a_sign,b_sign,o_sign;
    ExpoType    a_expo,b_expo,o_expo;
    MantType    a_mant,b_mant,o_mant;
    
    FpSignedBitsToFloat<ExpoWidth,MantWidth>(a,a_sign,a_expo,a_mant);
    FpSignedBitsToFloat<ExpoWidth,MantWidth>(b,b_sign,b_expo,b_mant);

    MantPlusOneType a_mant_p1 = a_mant;
    //if (is_a_denorm) {
    //    a_expo=1; // make it 1 to treat as norm
    //    a_mant_p1[MantWidth] = 0; // add implied 0 on msb
    //} else {
    if (IsZero<ExpoWidth,MantWidth>(a_expo,a_mant)) {
          a_mant_p1[MantWidth] = 0; // add implied 0 on msb
    } else {
          a_mant_p1[MantWidth] = 1; // add implied 1 on msb
    }
    //}

    MantPlusOneType b_mant_p1 = b_mant;
    if (IsZero<ExpoWidth,MantWidth>(b_expo,b_mant)) {
          b_mant_p1[MantWidth] = 0; // add implied 0 on msb
    } else {
          b_mant_p1[MantWidth] = 1; // add implied 1 on msb
    }

    bool is_a_greater = (a_expo > b_expo) || (a_expo == b_expo && a_mant >= b_mant); // a_ may be less when a_expo==b_expo
    o_expo = (is_a_greater) ? (a_expo) : (b_expo);

    ShiftType a_right_shift = (is_a_greater) ?  (ShiftType)0 : (ShiftType)(b_expo - a_expo);
    ShiftType b_right_shift = (is_a_greater) ?  (ShiftType)(a_expo - b_expo) : (ShiftType)0;
    
    SignedShiftType a_left_shift = kMantMoreWidth - a_right_shift;
    SignedShiftType b_left_shift = kMantMoreWidth - b_right_shift;
    
    InternalMantType a_int_mant_p1 = ((InternalMantType)a_mant_p1) << a_left_shift;
    InternalMantType b_int_mant_p1 = ((InternalMantType)b_mant_p1) << b_left_shift;
    #ifdef SVDEBUG    
    printf("\n a_mant  = %x",a_mant);
    printf("\n b_mant  = %x",b_mant);
    printf("\n a_mant_p1  = %x",a_mant_p1);
    printf("\n b_mant_p1  = %x",b_mant_p1);
    printf("\n a_int_mant_p1  = %x",a_int_mant_p1);
    printf("\n b_int_mant_p1  = %x",b_int_mant_p1);
    #endif
            
    bool is_addition = (a_sign == b_sign);
    
    // If this is wrong when a_expo==b_expo, we'll recover later on(KEY: RECOVERY).
    o_sign = is_a_greater ? a_sign : b_sign;

    InternalMantType addend_larger  = is_a_greater ? a_int_mant_p1 : b_int_mant_p1;
    InternalMantType addend_smaller = is_a_greater ? b_int_mant_p1 : a_int_mant_p1;
    
    //InternalMantType int_mant;

    InternalMantPlusOneType int_mant_p1;
    if (is_addition) {
        int_mant_p1 = (InternalMantPlusOneType)addend_larger + (InternalMantPlusOneType)addend_smaller;
    } else {
        int_mant_p1 = (InternalMantPlusOneType)addend_larger - (InternalMantPlusOneType)addend_smaller;
    }
        
    #ifdef SVDEBUG    
    printf("\n addend_larger  = %x",addend_larger);
    printf("\n addend_smaller = %x",addend_smaller);
    #endif

    bool is_inf = 0;
    InternalMantType int_mant;
    if (int_mant_p1[InternalMantWidth]) {
        if (o_expo<kExpoMax-1) {
            o_expo++;
            int_mant = int_mant_p1>>1;
        } else {
            is_inf = 1;
            // set as INF
            //SetToInf<ExpoWidth,MantWidth>(o_sign,o_expo,o_mant);
        }
        #ifdef SVDEBUG    
        printf("\n p0:int_mant  = %x",int_mant);
        printf("\n p0:o_expo  = %x",o_expo);
        #endif
    } else {
        int_mant = int_mant_p1; // remove the MSB, which is 0 for sure
        #ifdef SVDEBUG    
        printf("\n p1:int_mant  = %x",int_mant);
        printf("\n p1:o_expo  = %x",o_expo);
        #endif
        FpNormalize<ExpoWidth,InternalMantWidth>(o_sign,o_expo,int_mant); // make MSB of o_mant_p1 to be 1, or set mant = 0 if < norm
        #ifdef SVDEBUG    
        printf("\n p2:int_mant  = %x",int_mant);
        printf("\n p2:o_expo  = %x",o_expo);
        #endif
    }

    MantPlusOneType o_mant_p1;
    bool overflow = FpMantRNE<InternalMantWidth,MantWidth+1>(int_mant,o_mant_p1);
    #ifdef SVDEBUG    
    printf("\n FpMantRNE:int_mant  = %x",int_mant);
    printf("\n FpMantRNE:o_mant_p1  = %x",o_mant_p1);
    printf("\n overflow  = %x",overflow);
    #endif

    if (overflow) {
        if (o_expo<kExpoMax-1) {
            o_expo++;
        } else {
            is_inf = 1;
        }
    }

    o_mant = o_mant_p1; // remove implied 1 on MSB, or o_mant is 0 if in case of overflow

    if (is_inf) {
        SetToInf<ExpoWidth,MantWidth>(o_sign,o_expo,o_mant);
    }
    
    // NaN pro
    bool is_a_nan = IsNaN<ExpoWidth,MantWidth>(a_expo,a_mant);
    bool is_b_nan = IsNaN<ExpoWidth,MantWidth>(b_expo,b_mant);

    if (is_a_nan) {
        o_sign = a_sign;
        o_expo = a_expo;
        o_mant = a_mant;
    } else if (is_b_nan) {
        o_sign = b_sign;
        o_expo = b_expo;
        o_mant = b_mant;
    }

    sT o = FpFloatToSignedBits<ExpoWidth,MantWidth>(o_sign,o_expo,o_mant);
    return o;
}

template <unsigned int ExpoWidth, unsigned int MantWidth >
ACINTT(1+ExpoWidth+MantWidth) FpSub (
      ACINTT(1+ExpoWidth+MantWidth) a
     ,ACINTT(1+ExpoWidth+MantWidth) b
    ) {

    typedef ACINTF(1)           SignType;
    typedef ACINTF(ExpoWidth)   ExpoType;
    typedef ACINTF(MantWidth)   MantType;

    SignType b_sign;
    ExpoType b_expo;
    MantType b_mant;

    FpSignedBitsToFloat<ExpoWidth,MantWidth>(b,b_sign,b_expo,b_mant);
    b_sign = ~b_sign;

    b = FpFloatToSignedBits<ExpoWidth,MantWidth>(b_sign,b_expo,b_mant);

    return FpAdd<ExpoWidth,MantWidth>(a,b);
}
//===========================================================================
// FUNCTION
//===========================================================================
// return true if a > b
// return false if a <= b
template <unsigned int ExpoWidth, unsigned int MantWidth >
ACINTT(1+ExpoWidth+MantWidth) FpEql (
     ACINTT(1+ExpoWidth+MantWidth) a
    ,ACINTT(1+ExpoWidth+MantWidth) b
    ) {

    ACINTT(1+ExpoWidth+MantWidth) o;

    o = (a==b) ? 1 : 0; 

    return o;
}

//===========================================================================
// FUNCTION
//===========================================================================
// return true if a > b
// return false if a <= b
template <unsigned int ExpoWidth, unsigned int MantWidth, bool MAX >
ACINTT(1+ExpoWidth+MantWidth) FpCmp (
     ACINTT(1+ExpoWidth+MantWidth) a
    ,ACINTT(1+ExpoWidth+MantWidth) b
    ) {

    typedef ACINTF(1)           SignType;
    typedef ACINTF(ExpoWidth)   ExpoType;
    typedef ACINTF(MantWidth)   MantType;
    typedef ACINTT(1+ExpoWidth+MantWidth)   oType;

    SignType a_sign,b_sign;
    ExpoType a_expo,b_expo;
    MantType a_mant,b_mant;
    
    FpSignedBitsToFloat<ExpoWidth,MantWidth>(a,a_sign,a_expo,a_mant);
    FpSignedBitsToFloat<ExpoWidth,MantWidth>(b,b_sign,b_expo,b_mant);
    
    bool is_abs_a_greater = true;
    if (a_expo > b_expo) {
        is_abs_a_greater = true;
    } else if (a_expo < b_expo) {
        is_abs_a_greater = false;
    } else {
        if (a_mant > b_mant) {
            is_abs_a_greater = true;
        } else {
            is_abs_a_greater = false;
        }
    }

    bool is_a_postive = (a_sign==0);
    bool is_b_postive = (b_sign==0);
    bool is_a_greater;

    if (is_a_postive) {
        if (is_b_postive) {
            is_a_greater = is_abs_a_greater ? true : false;
        } else {
            is_a_greater = true;
        }
    } else {
        if (is_b_postive) {
            is_a_greater = false;
        } else {
            is_a_greater = is_abs_a_greater ? false : true;
        }
    }

    oType o;
    if (MAX==true) {
        o = is_a_greater ? a : b;
    } else {
        o = is_a_greater ? b : a;
    }
    
    bool is_a_nan = IsNaN<ExpoWidth,MantWidth>(a_expo,a_mant);
    bool is_b_nan = IsNaN<ExpoWidth,MantWidth>(b_expo,b_mant);

    if (is_a_nan) {
        o = a;
    } else if (is_b_nan) {
        o = b;
    }

    return o;
}

//===========================================================================
// FUNCTION
//===========================================================================
template <unsigned int ExpoWidth, unsigned int MantWidth >
ACINTT(1+ExpoWidth+MantWidth) FpMax (
      ACINTT(1+ExpoWidth+MantWidth) a
     ,ACINTT(1+ExpoWidth+MantWidth) b
    ) {

    return FpCmp<ExpoWidth,MantWidth,true>(a,b);
}

//===========================================================================
// FUNCTION
//===========================================================================
template <unsigned int ExpoWidth, unsigned int MantWidth >
ACINTT(1+ExpoWidth+MantWidth) FpMin (
      ACINTT(1+ExpoWidth+MantWidth) a
     ,ACINTT(1+ExpoWidth+MantWidth) b
    ) {

    return FpCmp<ExpoWidth,MantWidth,false> (a,b);
}

//===========================================================================
// FUNCTION
//===========================================================================
// o = a * b
// a*b ->(full width) m -(narrow expo.width)-> n -(narrow mant.width)-> o
template <unsigned int ExpoWidth, unsigned int MantWidth >
ACINTT(1+ExpoWidth+MantWidth) FpMul (
      ACINTT(1+ExpoWidth+MantWidth) a
     ,ACINTT(1+ExpoWidth+MantWidth) b
    ) {

    const unsigned int pMantWidth = 2 * MantWidth + 1;
    const unsigned int pExpoWidth = ExpoWidth;
    const unsigned int kExpoBias = (1ull<<ExpoWidth)/2 - 1;
    
    const unsigned int pExpoMax = (1ull << pExpoWidth) - 1;

    typedef ACINTF(1)               SignType;
    typedef ACINTF(ExpoWidth)       ExpoType;
    typedef ACINTF(MantWidth)       MantType;
    typedef ACINTF(1+MantWidth)     MantPlusOneType;
    
    typedef ACINTF(pExpoWidth)      pExpoType;
    typedef ACINTT(pExpoWidth+2)    pSignedExpoPlusOneType;
    typedef ACINTF(pMantWidth)      pMantType;
    typedef ACINTF(pMantWidth+1)    pMantPlusOneType;
    
    typedef ACINTT(1+ExpoWidth+MantWidth)   sT;
    typedef ACINTT(1+pExpoWidth+pMantWidth) pT;
    
    typedef ACINTF(1+ExpoWidth+MantWidth)   uT;

    // p is the product p = a * b

    SignType a_sign,b_sign,o_sign;
    ExpoType a_expo,b_expo,o_expo;
    MantType a_mant,b_mant,o_mant;
    
    SignType  p_sign;
    pExpoType p_expo;
    pMantType p_mant;

    uT ua = (uT)a;
    uT ub = (uT)b;
    
    FpBitsToFloat<ExpoWidth,MantWidth>(ua,a_sign,a_expo,a_mant);
    FpBitsToFloat<ExpoWidth,MantWidth>(ub,b_sign,b_expo,b_mant);

    bool is_a_zero = IsZero<ExpoWidth,MantWidth>(a_expo,a_mant);
    bool is_b_zero = IsZero<ExpoWidth,MantWidth>(b_expo,b_mant);

    // + implied 1
    MantPlusOneType a_mant_p1; a_mant_p1=a_mant;
    if (is_a_zero) {
        a_mant_p1[MantWidth] = 0; // add implied 0 on msb
    } else {
        a_mant_p1[MantWidth] = 1; // add implied 1 on msb
    }

    MantPlusOneType b_mant_p1; b_mant_p1=b_mant;
    if (is_b_zero) {
        b_mant_p1[MantWidth] = 0; // add implied 0 on msb
    } else {
        b_mant_p1[MantWidth] = 1; // add implied 1 on msb
    }

    pMantPlusOneType p_mant_p1 = a_mant_p1 * b_mant_p1;
    
    // sign
    p_sign = a_sign ^ b_sign;

    // expo
    bool is_inf = 0;
    bool is_zero = 0;
    if (is_a_zero || is_b_zero || a_expo + b_expo < kExpoBias ) {
        is_zero = 1;
    } else if (a_expo + b_expo >= pExpoMax + kExpoBias) {
        //SetToInf<pExpoWidth,pMantWidth>(p_sign,p_expo,p_mant);
        is_inf = 1;
    } else {
        p_expo = a_expo + b_expo - kExpoBias;

        // normalize and then remove the MSB 1 to make it implied
        if (p_mant_p1[pMantWidth]) {
            if (p_expo<pExpoMax-1) {
                p_expo++;
                p_mant = p_mant_p1;
            } else {
                is_inf = 1;
            }
        } else {
            p_mant = p_mant_p1<<1; // shift 0 from LSB, and remove 2bits from MSB
        }
    }
    
    // Convert to uBits
    pT p  = FpFloatToSignedBits<pExpoWidth,pMantWidth>(p_sign,p_expo,p_mant);

    //uT uo = FpWidthDec<pExpoWidth,pMantWidth,ExpoWidth,MantWidth,DENORM_NO,NAN_NO>(p);
    uT uo = FpMantWidthDec<ExpoWidth,pMantWidth,MantWidth,DENORM_NO,NAN_NO>(p);
    FpBitsToFloat<ExpoWidth,MantWidth>(uo,o_sign,o_expo,o_mant);

    // set to inf
    if (is_inf) {
        SetToInf<ExpoWidth,MantWidth>(o_sign,o_expo,o_mant);
    } 
    
    // set to zero
    if (is_zero || o_expo==0) {
        SetToZero<ExpoWidth,MantWidth>(o_sign,o_expo,o_mant);
    }
    
    // for NaN propogation
    bool is_a_nan = IsNaN<ExpoWidth,MantWidth>(a_expo,a_mant);
    bool is_b_nan = IsNaN<ExpoWidth,MantWidth>(b_expo,b_mant);
    if (is_a_nan) {
        o_sign = a_sign;
        o_expo = a_expo;
        o_mant = a_mant;
    } else if (is_b_nan) {
        o_sign = b_sign;
        o_expo = b_expo;
        o_mant = b_mant;
    }
    
    sT o  = FpFloatToSignedBits<ExpoWidth,MantWidth>(o_sign,o_expo,o_mant);

    return o;
}

//===========================================================================
// FUNCTION
//===========================================================================
// RELU:  out = (in > 0) ? in : 0;
// PRELU: out = (in > 0) ? in : in * cfg_scale;
template <unsigned int ExpoWidth, unsigned int MantWidth >
ACINTT(1+ExpoWidth+MantWidth) FpRelu (
      ACINTT(1+ExpoWidth+MantWidth) i
    ) {

    typedef ACINTF(1)         SignType;
    typedef ACINTF(ExpoWidth) ExpoType;
    typedef ACINTF(MantWidth) MantType;

    SignType i_sign,o_sign;
    ExpoType i_expo,o_expo;
    MantType i_mant,o_mant;
    
    FpSignedBitsToFloat<ExpoWidth,MantWidth>(i,i_sign,i_expo,i_mant);

    bool is_nan = IsNaN<ExpoWidth,MantWidth>(i_expo,i_mant);
    if (is_nan || i_sign==0) {
        o_sign = i_sign;
        o_expo = i_expo;
        o_mant = i_mant;
    } else {
        o_sign = (SignType)0;
        o_expo = (ExpoType)0;
        o_mant = (MantType)0;
    }

    return FpFloatToSignedBits<ExpoWidth,MantWidth>(o_sign,o_expo,o_mant);
}

// INT to FLOAT
template <unsigned int IntWidth, unsigned int ExpoWidth, unsigned int MantWidth >
ACINTT(1+ExpoWidth+MantWidth) FpIntToFloat (
      ACINTT(IntWidth) i
    ) {
    //const unsigned int kDropBits = IntWidth - 2 - MantWidth;
    const unsigned int kExpoBias = (1ull<<ExpoWidth)/2 - 1;
    const unsigned int kExpoMax = (1ull << ExpoWidth) - 1;

    typedef ACINTF(1)         SignType;
    typedef ACINTF(ExpoWidth) ExpoType;
    typedef ACINTF(MantWidth) MantType;
    typedef ACINTF(MantWidth+1) MantPlusOneType;

    typedef ACINTF(IntWidth)   iTypeF;
    typedef ACINTT(IntWidth)   iType;

    SignType o_sign;
    ExpoType o_expo;
    MantType o_mant;
    MantPlusOneType o_mant_p1;

    bool is_inf = false;

    o_sign  = i.template slc<1>(IntWidth-1);
    iType i_value = i;
    if (i == 0) {
        SetToZero<ExpoWidth,MantWidth>(o_sign,o_expo,o_mant);
    } else {
        iTypeF  i_abs;
        if (o_sign) { // negtive
            //i_abs = ~i_value; // NOTE: in HLS ~ means invert(A) + 1, but in VCS it is invert(A), or use (0-i_value) to get complement
            i_abs = -i_value;
        } else { // postive
            i_abs = i_value;
        }

        iTypeF lead_zero_count = IntLeadZero<IntWidth>(i_abs);
        iTypeF int_mant = i_abs << lead_zero_count;

        o_expo = IntWidth - 1 - lead_zero_count + kExpoBias;
        // below shift should be replaced by RNE
        bool overflow = FpMantRNE<IntWidth,MantWidth+1>(int_mant,o_mant_p1);
        if (o_expo == kExpoMax) {
                is_inf = 1;
        } else if (overflow) {
            if (o_expo < kExpoMax-1) {
                o_expo++; // o_mant_p1 must be 0;
            } else {
                is_inf = 1;
            }
        }
        // remove MSB
        o_mant = o_mant_p1; // remove MSB
        // remove MSB done

    }

    if (is_inf) {
        SetToInf<ExpoWidth,MantWidth>(o_sign,o_expo,o_mant);
    }
    
    return FpFloatToSignedBits<ExpoWidth,MantWidth>(o_sign,o_expo,o_mant);
}

// Float to Int
template <unsigned int IntWidth, unsigned int ExpoWidth, unsigned int MantWidth >
ACINTT(IntWidth) FpFloatToInt (
      ACINTT(1+ExpoWidth+MantWidth) bits
    ) {
    const long int kExpoBias = (1ull<<ExpoWidth)/2 - 1;
    const long int internalSize = kExpoBias+1+MantWidth;

    typedef ACINTT(IntWidth)   intType;
    typedef ACINTF(1)         SignType;
    typedef ACINTF(ExpoWidth) ExpoType;
    typedef ACINTT(ExpoWidth+1) SignedExpoType;
    typedef ACINTF(MantWidth) MantType;
    typedef ACINTF(MantWidth+1) MantPlusOneType;
    typedef ACINTF(MantWidth+2) MantPlusTwoType;

    typedef ACINTF(internalSize) internalType;
    
    intType oIntMax =  (1ull<<(IntWidth-1)) - 1;
    intType oIntMin = -(1ull<<(IntWidth-1));
    //ExpoType kExpoBias = (1ull<<(ExpoWidth-1)) - 1;
    
    SignType i_sign;
    ExpoType i_expo;
    MantType i_mant;
    FpSignedBitsToFloat<ExpoWidth,MantWidth>(bits,i_sign,i_expo,i_mant);

    MantPlusOneType i_mant_p1; i_mant_p1=i_mant;
    i_mant_p1[MantWidth] = 1;

    MantPlusTwoType i_mant_p2 = i_mant_p1;

    SignedExpoType shift = MantWidth - (i_expo - kExpoBias);
    //internalType internal_int = ((internalType)(i_mant_p1)) >> shift;
    internalType internal_int = IntSignedShiftRight<MantWidth+2,ExpoWidth+1,internalSize>(i_mant_p2,shift);

    intType o_int;
    if (internal_int > oIntMax) {
        o_int = i_sign ? oIntMin : oIntMax;
    } else {
        if (i_sign) {
            o_int = -internal_int;
        } else {
            o_int = internal_int;
        }
    }

    // for NaN propogation: set to MAX
    bool is_nan = IsNaN<ExpoWidth,MantWidth>(i_expo,i_mant);
    if (is_nan) {
        o_int = oIntMin;
    }

    return o_int;
}

// Float to Int
template <unsigned int ExpoWidth, unsigned int MantWidth, unsigned int SftWidth, unsigned int IntWidth, unsigned int FraWidth >
void FpFloatToIntFrac (
      ACINTT(1+ExpoWidth+MantWidth) i_float
     ,ACINTT(SftWidth)& i_rshift
     ,ACINTF(IntWidth)& o_int
     ,ACINTF(FraWidth)& o_fra
    ) {
    const unsigned int kExpoBias = (1ull<<ExpoWidth)/2 - 1;
    const unsigned int kExpoMax = (1ull<<ExpoWidth)/2;
    const unsigned int kSftMax = (1ull<<SftWidth)/2;
    const unsigned int kMax = kExpoMax + kSftMax;


    typedef ACINTF(IntWidth)  intType;
    typedef ACINTF(FraWidth)  fraType;

    intType intMax = (1ull<<IntWidth) - 1;

    typedef ACINTF(1)         SignType;

    typedef ACINTF(ExpoWidth)   ExpoType;
    typedef ACINTT(ExpoWidth)   SignedExpoType;
    typedef ACINTT(ExpoWidth+2) SignedExpoPlusTwoType;

    typedef ACINTF(MantWidth)   MantType;
    typedef ACINTF(MantWidth+1) MantPlusOneType;
    
    typedef ACINTT(SftWidth) SftType;
    typedef ACINTF(kMax) maxType;
    
    SignType i_sign;
    ExpoType i_expo;
    MantType i_mant;
    FpSignedBitsToFloat<ExpoWidth,MantWidth>(i_float,i_sign,i_expo,i_mant);

    MantPlusOneType i_mant_p1; i_mant_p1=i_mant;
    //if (IsZero<ExpoWidth,MantWidth>(i_expo,i_mant)) {
    //    i_mant_p1[MantWidth] = 0;
    //} else {
        i_mant_p1[MantWidth] = 1;
    //}

    SignedExpoType abs_expo = (i_expo - kExpoBias);
    SignedExpoPlusTwoType lshift = (abs_expo - i_rshift) - MantWidth;

    maxType m_int = (maxType)(i_mant_p1) << lshift;

    if (lshift >= 0) {
        o_fra = 0;
    } else {
        o_fra = (fraType)(i_mant_p1) << (FraWidth + lshift);
    }

    if (m_int > intMax) {
        o_int = intMax;
    } else {
        o_int = m_int;
    }

    // for NaN propogation: UINT is 0
    #pragma CTC SKIP
    bool is_nan = IsNaN<ExpoWidth,MantWidth>(i_expo,i_mant);
    if (is_nan) {
        o_int = 0;
        o_fra = 0;
    }
    #pragma CTC ENDSKIP
}

#pragma CTC SKIP
inline ACINTT(16) Fp16ToInt16 (
    ACINTT(1+5+10) bits
    ) {
    return FpFloatToInt<16,5,10>(bits);
}

inline ACINTT(1+5+10) Int16ToFp16 (
    ACINTT(16) bits
    ) {
    return FpIntToFloat<16,5,10>(bits);
}
inline ACINTT(1+5+10) Int17ToFp16 (
    ACINTT(17) bits
    ) {
    return FpIntToFloat<17,5,10>(bits);
}

inline ACINTT(17) Fp17Mul (
      ACINTT(17) a
     ,ACINTT(17) b
    ) {
    return FpMul<6,10>(a,b);
}

inline ACINTT(17) Fp17Add (
      ACINTT(17) a
     ,ACINTT(17) b
    ) {
    return FpAdd<6,10>(a,b);
}

inline ACINTT(17) Fp17Sub (
      ACINTT(17) a
     ,ACINTT(17) b
    ) {
    return FpSub<6,10>(a,b);
}

inline ACINTT(32) Fp32Mul (
      ACINTT(32) a
     ,ACINTT(32) b
    ) {
    return FpMul<8,23>(a,b);
}

inline ACINTT(32) Fp32Add (
      ACINTT(32) a
     ,ACINTT(32) b
    ) {
    return FpAdd<8,23>(a,b);
}

inline ACINTT(32) Fp32Sub (
      ACINTT(32) a
     ,ACINTT(32) b
    ) {
    return FpSub<8,23>(a,b);
}
#pragma CTC ENDSKIP


#endif
