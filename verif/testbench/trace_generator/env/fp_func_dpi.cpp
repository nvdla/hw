#include <stdio.h>
#include <svdpi.h>     
#include <time.h>
#include <stdlib.h>
#include <float.h>
//#include <match.h>

extern "C" {
// Add hls fp function wrapper 
typedef struct INT_16
{
    unsigned nInt      : 16;
}INT16;

typedef struct FLOAT_16
{
    unsigned nFraction : 10;
    unsigned nExponent :  5;
    unsigned nSign     :  1;
}FP16;

typedef struct FLOAT_17
{
    unsigned nFraction : 10;
    unsigned nExponent :  6;
    unsigned nSign     :  1;
}FP17;

typedef struct FLOAT_32
{
    unsigned nFraction : 23;
    unsigned nExponent :  8;
    unsigned nSign     :  1;
}FP32;


void* new_FP16() {
    FP16 *fp16 = (FP16 *)malloc(sizeof(FP16));
    return fp16;
}

void* new_FP17() {
    FP17 *fp17 = (FP17 *)malloc(sizeof(FP17));
    return fp17;
}

void* new_FP32() {
    FP32 *fp32 = (FP32 *)malloc(sizeof(FP32));
    return fp32;
}

void set_FP16(FP16 *fp16, const svBitVecVal *value) {
    fp16->nFraction = (*value) & 0x3FF;
    fp16->nExponent = ((*value) & 0x7C00) >> 10;
    fp16->nSign     = ((*value) & 0x8000) >> 15;
}

void get_FP16(const FP16 *fp16, svBitVecVal* value) {
    *value = fp16->nFraction + (fp16->nExponent<<10) + (fp16->nSign<<15);
}

void set_FP17(FP17 *fp17, const svBitVecVal *value) {
    fp17->nFraction = (*value) & 0x3FF;
    fp17->nExponent = ((*value) & 0xFC00) >> 10;
    fp17->nSign     = ((*value) & 0x10000) >> 16;
}

void get_FP17(const FP17 *fp17, svBitVecVal* value) {
    *value = fp17->nFraction + (fp17->nExponent<<10) + (fp17->nSign<<16);
}

void set_FP32(FP32 *fp32, const svBitVecVal *value) {
    fp32->nFraction = (*value) & 0x7FFFFF;
    fp32->nExponent = ((*value) & 0x7F800000) >> 23;
    fp32->nSign     = ((*value) & 0x80000000) >> 31;
}

void get_FP32(const FP32 *fp32, svBitVecVal* value) {
    *value = fp32->nFraction + (fp32->nExponent<<23) + (fp32->nSign<<31);
}


unsigned bits_count (unsigned input_a) {
  unsigned bits;
  bits = 0;

  while (input_a !=0) {
    input_a = input_a >> 1;
    bits++;
  }
  return (bits);
}


void Fp16To17_ref (FP16* input_a, FP17* result_a) {
  unsigned bits;
  unsigned input_fraction;
  if (input_a->nExponent==0) {
    input_fraction = input_a->nFraction;
    bits = bits_count(input_fraction);
    if (bits == 0) {
      result_a->nExponent=0;
      result_a->nSign = input_a->nSign;
      result_a->nFraction = 0;
    } else {
      result_a->nSign = input_a->nSign;
      result_a->nExponent = 31 - 14 - 11 + bits;
      result_a->nFraction = (input_a->nFraction << (11 - bits)) - (1ull << 10);
    }
  } else if (input_a->nExponent == ((1ull << 5) - 1)) {
    if (input_a->nFraction == 0) {
      result_a->nSign = input_a->nSign;
      result_a->nFraction = (1ull << 10) - 1;
      result_a->nExponent = (1ull << 6) - 2;
    } else {
      result_a->nSign = input_a->nSign;
      result_a->nFraction = input_a->nFraction;
      result_a->nExponent = (1ull << 6) - 1;
    }
  } else {
    result_a->nSign=input_a->nSign;
    result_a->nFraction=input_a->nFraction;
    result_a->nExponent=input_a->nExponent+31-15;
  }
}

void FpMul_FP17_ref(FP17* input_a, FP17* input_b, FP17* result_a) {
  unsigned fraction_of_a;
  unsigned fraction_of_b;
  unsigned fraction_result;
  unsigned bits;
  int      exponent_result;

  const unsigned FRA_BITS = 10;
  const unsigned EXP_BITS = 6;
  const unsigned MAX_EXPONENT = (1ull << EXP_BITS) - 1;
  const unsigned MIN_EXPONENT = 0;
  fraction_of_a = input_a->nFraction + (1ull << FRA_BITS);
  fraction_of_b = input_b->nFraction + (1ull << FRA_BITS);
  fraction_result = fraction_of_a * fraction_of_b;

  if (input_a->nExponent == ((1ull << EXP_BITS) - 1)) {
    result_a->nExponent = input_a->nExponent;
    result_a->nSign     = input_a->nSign;
    result_a->nFraction = input_a->nFraction;
  } else if (input_b->nExponent == ((1ull << EXP_BITS) - 1)) {
    result_a->nExponent = input_b->nExponent;
    result_a->nSign     = input_b->nSign;
    result_a->nFraction = input_b->nFraction;
  } else if ((input_a->nExponent == 0) && (input_a->nFraction == 0)) {
    result_a->nExponent = input_a->nExponent;
    result_a->nSign     = (input_a->nSign + input_b->nSign) & 1;
    result_a->nFraction = input_a->nFraction;
  } else if ((input_b->nExponent == 0) && (input_b->nFraction == 0)) {
    result_a->nExponent = input_b->nExponent;
    result_a->nSign     = (input_a->nSign + input_b->nSign) & 1;
    result_a->nFraction = input_b->nFraction;
  } else {
    bits = bits_count(fraction_result);
    if (bits > 22) {
      fraction_result = fraction_result >> (bits - 22);
    } else {
      fraction_result = fraction_result << (22 - bits);
    }

    if ((fraction_result & ((1ull << 11) - 1)) > (1ull << 10)) {
      fraction_result = (fraction_result >> 11) + 1;
    } else if ((fraction_result & ((1ull << 11) - 1)) == (1ull << 10)) {
      if (((fraction_result >> 11) & 1) == 0) {
        fraction_result = fraction_result >> 11;
      } else {
        fraction_result = (fraction_result >> 11) + 1;
      }
    } else {
      fraction_result = fraction_result >> 11;
    }

    if (((fraction_result >> 11) & 1) == 1) {
      bits ++;
      fraction_result >> 1;
    }

  
    exponent_result = input_a->nExponent + input_b->nExponent - 31 - 22 + bits + 1;
   
    // calculate the sign bit
    result_a->nSign = (input_a->nSign + input_b->nSign) & 1;
    //
    //if ((input_a->nExponent + input_b->nExponent + bits + 1) <= (22 + 31)) {
    if (exponent_result <= 0) {
      result_a->nExponent = 0;
      result_a->nFraction = 0;
    } else if (exponent_result >= MAX_EXPONENT) {
      result_a->nExponent = (1ull << EXP_BITS) - 2;
      result_a->nFraction = (1ull << FRA_BITS) - 1;
    } else {
      result_a->nExponent = exponent_result;
      result_a->nFraction = fraction_result & ((1ull << FRA_BITS) - 1);
    }
  }
}

void FpFractionToFloat_ref (INT16* input_a, FP17* result_a) {
  int valid_bits=bits_count(input_a->nInt);
  unsigned expo_incr = 0;
  
  if (valid_bits > 11) {
    if ((input_a->nInt & (((1ull << (valid_bits - 11)) - 1))) == (1ull << (valid_bits - 12))) {
      if (((input_a->nInt >> (valid_bits - 11)) & 1) == 0) {
        result_a->nFraction = input_a->nInt >> (valid_bits - 11);
      } else {
        result_a->nFraction = (input_a->nInt >> (valid_bits - 11)) + 1;
	if (((input_a->nInt >> (valid_bits - 11)) & ((1ull << 10) - 1)) == ((1ull << 10) - 1)) {
	  expo_incr = 1;
        }
      }
    } else if ((input_a->nInt & (((1ull << (valid_bits - 11)) - 1))) < (1ull << (valid_bits - 12))) {
      result_a->nFraction = input_a->nInt >> (valid_bits - 11);
    } else {
      result_a->nFraction = (input_a->nInt >> (valid_bits - 11)) + 1;
      if (((input_a->nInt >> (valid_bits - 11)) & ((1ull << 10) - 1)) == ((1ull << 10) - 1)) {
        expo_incr = 1;
      }
      
    }
    result_a->nExponent = valid_bits - 16 - 1 + 31 + expo_incr;
    result_a->nSign     = 0;
  } else if (valid_bits > 0) {
    result_a->nFraction = (input_a->nInt << (11 - valid_bits));
    result_a->nExponent = valid_bits - 16 - 1 + 31;
    result_a->nSign     = 0;
  } else {
    result_a->nFraction = 0;
    result_a->nExponent = 0;
    result_a->nSign     = 0;
  }
}

void Fp17To16_ref (FP17* input_a, FP16* result_a) {
  unsigned shift_cnt;
  if (input_a->nExponent == ((1ull << 6) - 1)) {
    if (input_a->nFraction == 0) {
      result_a->nSign     = input_a->nSign;
      result_a->nFraction = (1ull << 10) - 1;
      result_a->nExponent = (1ull << 5) - 2;
    } else {
      result_a->nSign     = input_a->nSign;
      result_a->nFraction = input_a->nFraction;
      result_a->nExponent = (1ull << 5) - 1;
    }
  } else if (input_a->nExponent>(15 + 31)){ // to max
    result_a->nSign     = input_a->nSign;
    result_a->nFraction = (1ull << 10)-1;
    result_a->nExponent = 30;
  } else if (input_a->nExponent>(31-15)) {  // to normal
    result_a->nSign     = input_a->nSign;
    result_a->nFraction = input_a->nFraction;
    result_a->nExponent = input_a->nExponent - 31 + 15;
  } else {  // denormalized
    result_a->nSign     = input_a->nSign;
    result_a->nExponent = 0;
    shift_cnt = 31 - 15 + 1 - input_a->nExponent;
    if (shift_cnt > 11) { // zero
      result_a->nFraction = 0;
    } else if (((input_a->nFraction + (1ull << 10)) & ((1ull << shift_cnt)-1)) == (1ull << (shift_cnt-1))) {
      if ((((input_a->nFraction + (1ull << 10)) >> shift_cnt) & 1) == 0) {
        result_a->nFraction = (input_a->nFraction + (1ull << 10)) >> shift_cnt;
      } else {
        result_a->nFraction = ((input_a->nFraction + (1ull << 10)) >> shift_cnt) + 1;
	if (result_a->nFraction == 0) {
	  result_a->nExponent = 1;
	}
      }
    } else if (((input_a->nFraction + (1ull << 10)) & ((1ull << shift_cnt)-1)) < (1ull << (shift_cnt-1))) {
      result_a->nFraction = (input_a->nFraction + (1ull << 10)) >> shift_cnt;
    } else {
      result_a->nFraction = ((input_a->nFraction + (1ull << 10)) >> shift_cnt) + 1;
      if (result_a->nFraction == 0) {
        result_a->nExponent = 1;
      }
    }
  }
}


void FpIntToFloat_ref (INT16* input_a, FP16* result_a) { // only INT16 to FP16, no denorm/Inf/NaN support
  FP17* temp_result = (FP17 *)malloc(sizeof(FP17));
  unsigned sign = (input_a->nInt >> 15) & 1;
  if (sign == 1) {
    input_a->nInt = (1ull << 16) - input_a->nInt;
  }

  FpFractionToFloat_ref (input_a, temp_result);
  temp_result->nExponent += 16;
  if (input_a->nInt == 0) {
    result_a->nSign = 0;
    result_a->nFraction = 0;
    result_a->nExponent = 0;
  } else {
    Fp17To16_ref (temp_result, result_a);
    result_a->nSign = sign;
  }
}

void FpAdd_FP32_ref(FP32* input_a, FP32* input_b, FP32* result_a)
{
  unsigned exponent_delta;
  unsigned new_fraction_high_24;
  unsigned new_fraction_low_24;
  unsigned temp_fraction_low_24;
  unsigned bits;
  unsigned additional_bit;

  additional_bit = 0;

  const unsigned EXP_BITS = 8;
  const unsigned EXP_BITS_PLUS1 = EXP_BITS + 1;
  const unsigned FRA_BITS = 23;
  const unsigned FULL_FRA_BITS = FRA_BITS + 1;
  const unsigned PRECISION_FRA_BITS = 2*FULL_FRA_BITS;

  FP32* larger = (FP32 *)malloc(sizeof(FP32));
  FP32* little = (FP32 *)malloc(sizeof(FP32));
  
  // NAN check
  if (input_a->nExponent == ((1ull << EXP_BITS) -1)) {
    result_a->nSign     = input_a->nSign;
    result_a->nExponent = input_a->nExponent;
    result_a->nFraction = input_a->nFraction;
  } else if (input_b->nExponent == ((1ull << EXP_BITS) - 1)){
    result_a->nSign     = input_b->nSign;
    result_a->nExponent = input_b->nExponent;
    result_a->nFraction = input_b->nFraction;
  } else if (input_b->nExponent == 0) {
    result_a->nSign     = input_a->nSign;
    result_a->nExponent = input_a->nExponent;
    result_a->nFraction = input_a->nFraction;
  } else if (input_a->nExponent == 0) {
    result_a->nSign     = input_b->nSign;
    result_a->nExponent = input_b->nExponent;
    result_a->nFraction = input_b->nFraction;
  } else { // normal pipeline
    if ((input_a->nExponent > input_b->nExponent) || ((input_a->nExponent == input_b->nExponent) && (input_a->nFraction >= input_b->nFraction))) {
      result_a->nSign = input_a->nSign;
      larger->nExponent = input_a->nExponent;
      larger->nFraction = input_a->nFraction;
      larger->nSign = input_a->nSign;
      little->nExponent = input_b->nExponent;
      little->nFraction = input_b->nFraction;
      little->nSign = input_b->nSign;
    } else {
      result_a->nSign = input_b->nSign;
      larger->nExponent = input_b->nExponent;
      larger->nFraction = input_b->nFraction;
      larger->nSign = input_b->nSign;
      little->nExponent = input_a->nExponent;
      little->nFraction = input_a->nFraction;
      little->nSign = input_a->nSign;
    }

      exponent_delta = larger->nExponent - little->nExponent;
      if (exponent_delta <= 23) {
	if (larger->nSign == little->nSign) {
	  temp_fraction_low_24 = ((little->nFraction << (24 - exponent_delta)) & ((1ull << 24) - 1));
	  new_fraction_low_24   = temp_fraction_low_24 & ((1ull << 24) - 1);
	  if (temp_fraction_low_24 > (1ull << 31)) {
	    new_fraction_high_24 = (1ull << 23) + larger->nFraction + (1ull << (23 - exponent_delta)) + (little->nFraction >> (exponent_delta)) - (1ull << 8) + (temp_fraction_low_24 >> 24);
	  } else {
	    new_fraction_high_24 = (1ull << 23) + larger->nFraction + (1ull << (23 - exponent_delta)) + (little->nFraction >> (exponent_delta)) + (temp_fraction_low_24 >> 24);
	  }
	} else {
	  temp_fraction_low_24 = 0 - ((little->nFraction << (24 - exponent_delta)) & ((1ull << 24) - 1));
	  new_fraction_low_24   = temp_fraction_low_24 & ((1ull << 24) - 1);
	  if (temp_fraction_low_24 > (1ull << 31)) {
	    new_fraction_high_24 = (1ull << 23) + larger->nFraction - (1ull << (23 - exponent_delta)) - (little->nFraction >> (exponent_delta)) - (1ull << 8) + (temp_fraction_low_24 >> 24);
	  } else {
	    new_fraction_high_24 = (1ull << 23) + larger->nFraction - (1ull << (23 - exponent_delta)) - (little->nFraction >> (exponent_delta)) + (temp_fraction_low_24 >> 24);
	  }
	}
      } else if (exponent_delta <= 48) {
	if (larger->nSign == little->nSign) {
	  temp_fraction_low_24 = (1ull << (47 - exponent_delta)) + ((little->nFraction >> (exponent_delta - 23)) & ((1ull << 24) - 1));
	  new_fraction_low_24   = temp_fraction_low_24 & ((1ull << 24) - 1);
	  if (temp_fraction_low_24 > (1ull << 31)) {
	    new_fraction_high_24 = (1ull << 23) + larger->nFraction - (1ull << 8) + (temp_fraction_low_24 >> 24);
	  } else {
	    new_fraction_high_24 = (1ull << 23) + larger->nFraction + (temp_fraction_low_24 >> 24);
	  }
	} else {
	  temp_fraction_low_24 = 0 - (1ull << (47 - exponent_delta)) - ((little->nFraction >> (exponent_delta - 23)) & ((1ull << 24) - 1));
	  new_fraction_low_24   = temp_fraction_low_24 & ((1ull << 24) - 1);
	  if (temp_fraction_low_24 > (1ull << 31)) {
	    new_fraction_high_24 = (1ull << 23) + larger->nFraction - (1ull << 8) + (temp_fraction_low_24 >> 24);
	  } else {
	    new_fraction_high_24 = (1ull << 23) + larger->nFraction + (temp_fraction_low_24 >> 24);
	  }
	}
      } else {
	new_fraction_high_24 = (1ull << 23) + larger->nFraction;
	new_fraction_low_24  = 0;
      }



      bits = bits_count(new_fraction_high_24);
      if (bits == 0) {
        bits = bits_count(new_fraction_low_24);
      } else {
        bits = bits + 24;
      }

      if (bits >= 48) {
	new_fraction_low_24 = ((new_fraction_low_24 >> (bits - 48)) + (new_fraction_high_24 << (24 + 48 - bits))) & ((1ull << 24) - 1);
        new_fraction_high_24 = new_fraction_high_24 >> (bits - 48);
      } else {
        new_fraction_high_24 = ((new_fraction_high_24 << (48 - bits)) + (new_fraction_low_24 >> (24 + bits - 48))) & ((1ull << 24) - 1);
	new_fraction_low_24  = (new_fraction_low_24 << (48 - bits)) & ((1ull << 24) - 1);
      }


      if (new_fraction_low_24 == (1ull << 23)) {
        if ((new_fraction_high_24 & 1) == 0) {
          new_fraction_high_24 = new_fraction_high_24;
	} else {
	  new_fraction_high_24 = new_fraction_high_24 + 1;
	  if (new_fraction_high_24 == (1ull << 24)) {
	    additional_bit = 1;
	  }
        }
      } else if (new_fraction_low_24 > (1ull << 23)) {
        new_fraction_high_24 = new_fraction_high_24 + 1;
	if (new_fraction_high_24 == (1ull << 24)) {
	  additional_bit = 1;
	}
      } else {
        new_fraction_high_24 = new_fraction_high_24;
      }
      

      result_a->nFraction = new_fraction_high_24;
      if ((larger->nExponent + bits + additional_bit) >= ((1ull << EXP_BITS) - 1) + FULL_FRA_BITS + 24) {
        result_a->nFraction = (1ull << FRA_BITS) - 1;
	result_a->nExponent = (1ull << EXP_BITS_PLUS1) - 2;
      } else if ((larger->nExponent + bits + additional_bit) <= FULL_FRA_BITS + 24) {
        result_a->nFraction = 0;
	result_a->nExponent = 0;
      } else if (bits == 0) {
        result_a->nFraction = 0;
	result_a->nExponent = 0;
      } else {
        result_a->nExponent = larger->nExponent - FULL_FRA_BITS + bits - 24 + additional_bit;
      }
  }
}



// extern "C"
}


