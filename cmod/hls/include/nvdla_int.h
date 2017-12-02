// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nvdla_int.h

#ifndef _NVDLA_INT_H_
#define _NVDLA_INT_H_

#include "nvdla_common.h"
//===========================================================================
// FUNCTION
//===========================================================================
//template<unsigned int Width >
//bool IntIsNeg (
//     ACINTT(Width) bits
//    ) {
//
//    ACINTF(1) sign = bits.template slc<1>(Width-1);
//
//    bool is_neg = (sign==1) ? true : false;
//
//    return is_neg;
//}

//===========================================================================
// FUNCTION
//===========================================================================
template<unsigned int iWidth, unsigned int sWidth, unsigned int oWidth >
ACINTT(oWidth) IntShiftRight (
     ACINTT(iWidth) ibits
    ,ACINTF(sWidth) shift
    ) {

    const unsigned long ExtraRight = (1ull << sWidth) - 1;
    const unsigned long ExtraLeft  = 0;
    const unsigned long Extra = ExtraRight + ExtraLeft;
    const unsigned long totWidth = iWidth + Extra;
    const unsigned long intWidth = iWidth + ExtraLeft;
    
    typedef ACFIXT(totWidth,intWidth) mFixType;
    typedef ACFIXT(oWidth,oWidth) oFixType;
    typedef ACINTT(oWidth) oType;
    
    mFixType mbits_fixed = (mFixType)(ibits) >> shift; 
    oFixType obits_fixed = mbits_fixed;

    oType obits = obits_fixed.to_ac_int();
    
    return obits;
}
template<unsigned int iWidth, unsigned int sWidth, unsigned int oWidth >
ACINTT(oWidth) IntShiftRightSat (
     ACINTT(iWidth) ibits
    ,ACINTF(sWidth) shift
    ,ACINTF(1) & saturation
    ) {

    typedef ACINTT(iWidth) iType;
    typedef ACINTT(oWidth) oType;

    oType o = IntShiftRight<iWidth,sWidth,oWidth>(ibits,shift);

    // Saturation
    iType i = ibits>>shift;
    if (i == o || i==(o+1) || i==(o-1) ) {
        saturation = false;
    } else {
        saturation = true;
    }

    return o;
}


template<unsigned int iWidth, unsigned int sWidth, unsigned int oWidth >
ACINTT(oWidth) IntShiftLeft (
     ACINTT(iWidth) ibits
    ,ACINTF(sWidth) shift
    ) {

    const unsigned long ExtraRight = 0;
    const unsigned long ExtraLeft  = (1ull << sWidth) - 1;
    const unsigned long Extra = ExtraRight + ExtraLeft;
    const unsigned long totWidth = iWidth + Extra;
    const unsigned long intWidth = iWidth + ExtraLeft;
    
    typedef ACFIXT(totWidth,intWidth) mFixType;
    typedef ACFIXT(oWidth,oWidth) oFixType;
    typedef ACINTT(oWidth) oType;
    
    mFixType mbits_fixed = (mFixType)(ibits) << shift; 
    oFixType obits_fixed = mbits_fixed;

    oType obits = obits_fixed.to_ac_int();
    
    return obits;
}

#pragma CTC SKIP
template<unsigned int iWidth, unsigned int sWidth, unsigned int oWidth>
ACINTT(oWidth) IntSignedShiftLeft (
     ACINTT(iWidth) ibits
    ,ACINTT(sWidth) shift
    ) {
    
    const unsigned long ExtraRight =  ((int)1) << (sWidth-1);
    const unsigned long ExtraLeft = (((int)1) << (sWidth-1)) - 1;
    const unsigned long Extra = ExtraRight + ExtraLeft;
    const unsigned long totWidth = iWidth + Extra;
    const unsigned long intWidth = iWidth + ExtraLeft;
    
    typedef ACFIXT(totWidth,intWidth) mFixType;
    typedef ACFIXT(oWidth,oWidth) oFixType;
    typedef ACINTT(oWidth) oType;
    
    mFixType mbits_fixed = (mFixType)(ibits) << shift; 
    oFixType obits_fixed = mbits_fixed;

    oType obits = obits_fixed.to_ac_int();
    

    return obits;
}
#pragma CTC ENDSKIP

template<unsigned int iWidth, unsigned int sWidth, unsigned int oWidth >
ACINTT(oWidth) IntSignedShiftRight (
     ACINTT(iWidth) ibits
    ,ACINTT(sWidth) shift
    ) {
    
    const unsigned long ExtraLeft =  ((int)1) << (sWidth-1);
    const unsigned long ExtraRight = (((int)1) << (sWidth-1)) - 1;
    const unsigned long Extra = ExtraRight + ExtraLeft;
    const unsigned long totWidth = iWidth + Extra;
    const unsigned long intWidth = iWidth + ExtraLeft;
    
    typedef ACFIXT(totWidth,intWidth) mFixType;
    typedef ACFIXT(oWidth,oWidth) oFixType;
    typedef ACINTT(oWidth) oType;
    
    mFixType mbits_fixed = (mFixType)(ibits) >> shift; 
    oFixType obits_fixed = mbits_fixed;

    oType obits = obits_fixed.to_ac_int();

    return obits;
}

template<unsigned int iWidth, unsigned int sWidth, unsigned int oWidth >
ACINTT(oWidth) IntSignedShiftRightTZ(
     ACINTF(iWidth) ibits
    ,ACINTT(sWidth) shift
    ) {
    
    const unsigned long ExtraLeft =  ((int)1) << (sWidth-1);
    const unsigned long ExtraRight = (((int)1) << (sWidth-1)) - 1;
    const unsigned long Extra = ExtraRight + ExtraLeft;
    const unsigned long totWidth = iWidth + Extra;
    const unsigned long intWidth = iWidth + ExtraLeft;
    
    typedef ACFIXTZF(totWidth,intWidth) mFixType;
    typedef ACFIXTZF(oWidth,oWidth) oFixType;
    typedef ACINTF(oWidth) oType;
    
    mFixType mbits_fixed = (mFixType)(ibits) >> shift; 
    oFixType obits_fixed = mbits_fixed;

    oType obits = obits_fixed.to_ac_int();

    return obits;
}

#pragma CTC SKIP
template< unsigned int iWidth, unsigned int oWidth>
ACINTT(oWidth) IntWidthDec (
    ACINTT(iWidth) i
    ) {

    #pragma CTC SKIP
    assert (iWidth > oWidth);
    #pragma CTC ENDSKIP

    typedef ACINTT(oWidth) oType;
    oType oMAX =  (1ull<<(oWidth-1)) - 1;
    oType oMIN = -(1ull<<(oWidth-1));

    oType o;
    if (i > oMAX) {
        o = oMAX;
    } else if (i < oMIN) {
        o = oMIN;
    } else {
        o = i;
    }

    return o;
}
#pragma CTC ENDSKIP

#pragma CTC SKIP
// Width of a and b must be equal, and the return value is also have the same width
// This also means satuation is effective when overflow
template< unsigned int Width >
ACINTT(Width) IntAdd (
     ACINTT(Width) a
    ,ACINTT(Width) b
    ) {

    typedef ACINTT(Width)   Type;
    typedef ACINTT(Width+1) mType;
     
    Type kMAX = (1ull<<(Width-1)) - 1;
    Type kMIN = -(1ull<<(Width-1));

    mType m = (mType)a + (mType)b;
    
    Type o;
    if (m > kMAX) {
        o = (Type)kMAX;
    } else if (m < kMIN) {
        o = (Type)kMIN;
    } else {
        o = (Type)m;
    }

    return o;
}
#pragma CTC ENDSKIP

// Width of a and b must be equal, and the return value is also have the same width
// This also means satuation is effective when overflow
#pragma CTC SKIP
template< unsigned int Width >
ACINTT(Width) IntSub (
     ACINTT(Width) a
    ,ACINTT(Width) b
    ) {

    typedef ACINTT(Width)   Type;
    typedef ACINTT(Width+1) mType;

    Type kMAX =  (1ull<<(Width-1)) - 1;
    Type kMIN = -(1ull<<(Width-1));

    mType m = (mType)a - (mType)b;

    Type o; 
    if      (m > kMAX) { o = kMAX; } 
    else if (m < kMIN) { o = kMIN; } 
    else               { o = m;    }

    return o;
}
#pragma CTC ENDSKIP

// IntAddExt need oWidth big enough to hold all result from a+b, 
// This also means the result has no rounding or satuation
template< unsigned int aWidth, unsigned int bWidth, unsigned int oWidth >
ACINTT(oWidth) IntAddExt (
     ACINTT(aWidth) a
    ,ACINTT(bWidth) b
    ) {

    const long unsigned int mWidth = (aWidth>bWidth) ? aWidth : bWidth;
    #pragma CTC SKIP
    assert (oWidth > mWidth);
    #pragma CTC ENDSKIP

    typedef ACINTT(oWidth) oType;
    oType o = (oType)a + (oType)b;

    return o;
}

// IntSubExt need oWidth big enough to hold all result from a+b, 
// This also means the result has no rounding or satuation
template< unsigned int aWidth, unsigned int bWidth, unsigned int oWidth >
ACINTT(oWidth) IntSubExt (
     ACINTT(aWidth) a
    ,ACINTT(bWidth) b
    ) {

    const long unsigned int mWidth = (aWidth>bWidth) ? aWidth : bWidth;
    #pragma CTC SKIP
    assert (oWidth > mWidth);
    #pragma CTC ENDSKIP

    typedef ACINTT(oWidth) oType;
    oType o = (oType)a - (oType)b;

    return o;
}

#pragma CTC SKIP
template< unsigned int Width >
ACINTT(Width) IntMul (
     ACINTT(Width) a
    ,ACINTT(Width) b
    ) {

    typedef ACINTT(2*Width) mType;
    typedef ACINTT(Width)   oType;

    mType m = (mType)a * (mType)b;

    oType kMAX =  (1ull<<(Width-1)) - 1;
    oType kMIN = -(1ull<<(Width-1));

    oType o;

    if (m > kMAX) {
        o = kMAX;
    } else if (m < kMIN) {
        o = kMIN;
    } else {
        o = m;
    }

    return o;
}
#pragma CTC ENDSKIP

#pragma CTC SKIP
template< unsigned int Width >
ACINTF(2*Width-1) IntSq (
     ACINTT(Width) a
    ) {

    typedef ACINTT(2*Width) mType;
    typedef ACINTT(2*Width) mTypeF;
    
    typedef ACINTT(2*Width-1) oTypeF;

    mType m = (mType)a * (mType)a;
    mTypeF um = (mTypeF)m;

    oTypeF o = um.template slc<2*Width-1>(0);

    return o;
}
#pragma CTC ENDSKIP

template< unsigned int aWidth,unsigned int bWidth,unsigned int oWidth >
ACINTT(oWidth) IntMulExt (
     ACINTT(aWidth) a
    ,ACINTT(bWidth) b
    ) {

    #pragma CTC SKIP
    assert (oWidth >= aWidth+bWidth);
    #pragma CTC ENDSKIP

    typedef ACINTT(oWidth) oType;

    oType oa = (oType)a;
    oType ob = (oType)b;
    oType o = oa * ob;

    return o;
}

#pragma CTC SKIP
template< unsigned int iWidth, unsigned int oWidth, unsigned int sWidth >
ACINTT(oWidth) IntTruncate (
     ACINTT(iWidth) ibits
    ,ACINTF(sWidth) shift
    ) {

    typedef ACINTT(oWidth) oType;

    oType o = IntShiftRight<iWidth,sWidth,oWidth>(ibits,shift);

    return o;
}
#pragma CTC ENDSKIP

template< unsigned int Width >
ACINTF(Width) IntLeadZero (
     ACINTF(Width) x
    ) {

    return x.leading_sign();
}

template< unsigned int Width >
void IntLog2 (
     ACINTF(Width) & idata
    ,ACINTF(Width) & index
    ,ACINTF(Width) & fraction
    ) {

    typedef ACINTF(Width) iType;

    iType leadzero = IntLeadZero<Width>(idata);
    index = Width - 1 - leadzero;
    fraction = idata & ((1ull << index) - 1 );
}


template< unsigned int iWidth, unsigned int oWidth >
ACINTT(oWidth) IntSaturation (
     ACINTT(iWidth) i
    ) {

    #pragma CTC SKIP
    assert (oWidth <= iWidth);
    #pragma CTC ENDSKIP
    
    typedef ACINTT(iWidth) iType;
    typedef ACINTT(oWidth) oType;
    
    oType oMax =   (1ull<<(oWidth-1)) - 1;
    oType oMin =  -(1ull<<(oWidth-1));

    oType o;
    if (i > oMax) {
        o = oMax;
    } else if (i < oMin) {
        o = oMin;
    } else {
        o = i;
    }

    return o;
}

#endif
