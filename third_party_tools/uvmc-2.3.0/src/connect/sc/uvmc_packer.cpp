//
//----------------------------------------------------------------------
//   Copyright 2009 Cadence Design Systems, Inc.
//   Copyright 2009-2012 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------


#include "uvmc_packer.h"

//#include "sc_simcontext.h"

#include <typeinfo>
#include <iostream>

using namespace std;
using namespace sc_dt;
using namespace sc_core;

namespace uvmc {

//------------------------------------------------------------------------------
//
// CLASS- uvmc_packer_rep
//
// Internal implementation class.
// uvmc_packer delegetates to this class to do the real work.
//
//------------------------------------------------------------------------------

class uvmc_packer_rep {
public:
  uvmc_packer_rep(uvmc_packer* packer);
  ~uvmc_packer_rep();

  // PACK
  void pack_int_n(uint64 k, unsigned nbits);
  void pack_char(char);
  void pack_string(std::string s);
  void pack_sc_bit(const sc_bit&);
  void pack_sc_logic(const sc_logic&);
  void pack_sc_bv_base(const sc_bv_base&);
  void pack_sc_lv_base(const sc_lv_base&);
  void pack_sc_int_base(const sc_int_base&);
  void pack_sc_uint_base(const sc_uint_base&);
  void pack_sc_signed(const sc_signed&);
  void pack_sc_unsigned(const sc_unsigned&);
  void pack_sc_time(const sc_time&);
  void pack_float(float);
  void pack_double(double);

  // UNPACK
  uint64 unpack_int_n(unsigned nbits);
  void unpack_char(char&);
  void unpack_string(std::string& s);
  void unpack_sc_bit(sc_bit&);
  void unpack_sc_logic(sc_logic&);
  void unpack_sc_bv_base(sc_bv_base&);
  void unpack_sc_lv_base(sc_lv_base&);
  void unpack_sc_int_base(sc_int_base&);
  void unpack_sc_uint_base(sc_uint_base&);
  void unpack_sc_signed(sc_signed&);
  void unpack_sc_unsigned(sc_unsigned&);
  void unpack_sc_time(sc_time&);
  void unpack_float(float&);
  void unpack_double(double&);

  void update_indexes(unsigned int n);

  void init_unpack(const bits_t *bits, int level=0);
  void init_pack(bits_t *bits, int level=0);

private:
  uvmc_packer* m_packer;
  int bit_index;
  const bits_t *bits_ptr;
  bits_t *wr_bits_ptr;
  int bits_size;
};


//------------------------------------------------------------------------------
// IMPLEMENTATION
//------------------------------------------------------------------------------

uvmc_packer_rep::uvmc_packer_rep(uvmc_packer* packer) {
  m_packer = packer;
}

uvmc_packer_rep::~uvmc_packer_rep() {

}

#ifdef MSB_FIRST
#define UVM_INIT_INDEX 32
#else
#define UVM_INIT_INDEX 0
#endif 

// unpack
void uvmc_packer_rep::init_unpack(const bits_t *bits, int level) {
  if (level == 0) {
    bits_ptr = bits;
    bits_size = 0;
    bit_index =UVM_INIT_INDEX;
  }
  else {
  }
}

// pack
void uvmc_packer_rep::init_pack(bits_t *bits, int level) {
  if (level == 0) {
    wr_bits_ptr = bits;
    bits_size = 0;
    bit_index =UVM_INIT_INDEX;
  }
  else {
  }
}

#ifdef MSB_FIRST
void uvmc_packer_rep::update_indexes(unsigned int n) {
  bit_index -= n;
  if (bit_index < 1 ) {
    bit_index=32;
    bits_ptr++;
    wr_bits_ptr++;
  }
  bits_size += n;
  }
#else
void uvmc_packer_rep::update_indexes(unsigned int n) {
  bit_index += n;
  if (bit_index >= 32) {
    bit_index=0;
    bits_ptr++;
    wr_bits_ptr++;
  }
  bits_size += n;
}
#endif

//------------------------------------------------------------------------------
// PACK
//------------------------------------------------------------------------------



#ifdef MSB_FIRST 
  // With 0 < n <= 64, word can span up to three 32-bit words

  // MSB first (SV do this with bitstream ops)
  // |31     0|31     0|31    0|
  //     LSBxx xxxxxxxx xxxx       // spans 3 words
  //    xxxxxx xxx                 // spans 2 words
  //  xxxxxxxx xxxxxxxx            // spans 2 words
  //    xxx                        // spans 1 word

void uvmc_packer_rep::pack_int_n(uint64 a, unsigned n) {

  uint64 val = 0;

  if (n<64)
    a &= ~(((uint64)-1) << n);

  //cout << "PACK_INT_N(" << hex << a << dec << "," << n
  //     << ")" << " bit_index=" << bit_index << endl;

  if (n <= bit_index) {

    val = *wr_bits_ptr;
    val = (val & (~(((uint64)-1) << bit_index) |
          ~(((uint64)-1)<<(bit_index-n)))) | (a << (bit_index-n));
    *wr_bits_ptr = val;

    update_indexes(n);
  }

  else {

    // Left bits
    val = *wr_bits_ptr;
    val = (val & (((((uint64)-1) << bit_index)))) |
          (a >> (n-bit_index));
    *wr_bits_ptr = val;
    n -= bit_index;
    update_indexes(bit_index);

    // Mid bits
    if (n >= 32) {
      val = (a & (~(((uint64)-1)<<n))) >> (n-32);
      *wr_bits_ptr = val;
      n -= 32;
      update_indexes(32);
    }

    // Right bits
    if (n > 0) {
      val = *wr_bits_ptr;
      val = ((~(-1<<(bit_index-n))) & val) |
            ((a & (~(((uint64)-1)<<n))) << (bit_index-n));
      *wr_bits_ptr = val;
      update_indexes(n);
    }
  }
}

#else // LSB
  // With 0 < n <= 64, word can span up to three 32-bit words
  // LSB first (UVM with uvm_packer)
  // |31     0|31     0|31    0|
  //     MSBxx xxxxxxxx xLSB       // spans 3 words
  //    xxxxxx xxx                 // spans 2 words
  //  xxxxxxxx xxxxxxxx            // spans 2 words
  //    xxx                        // spans 1 word
void uvmc_packer_rep::pack_int_n(uint64 a, unsigned n) {

  uint64 val = 0;

  if (n<64)
    a &= ~(((uint64)-1) << n);

  //cout << "PACK_INT_N(" << hex << a << dec << "," << n
  //     << ")" << " bit_index=" << bit_index << endl;

  if (n <= (unsigned)(32-bit_index)) {

    val = *wr_bits_ptr;
    val = (val & (~(((uint64)-1) << bit_index) |
          (((uint64)-1)<<(bit_index+n)))) | (a << (bit_index));
    *wr_bits_ptr = val;

    update_indexes(n);
  }

  else {

    // Right bits
    val = *wr_bits_ptr;
    val = (val & (~((((uint64)-1) << bit_index)))) |
          ((a & ~(((uint64)-1)<<(32-bit_index))) << bit_index);
    *wr_bits_ptr = val;
    n -= (32-bit_index);
    a = a >> (32-bit_index);
    update_indexes(32-bit_index);

    // Mid bits
    if (n >= 32) {
      *wr_bits_ptr = a; //(a & ((uint32)-1));
      n -= 32;
      a = a >> 32;
      update_indexes(32);
    }

    // Left bits
    if (n > 0) {
      val = *wr_bits_ptr;
      val = ((((uint64)-1)<<n) & val) | a;
      *wr_bits_ptr = val;
      update_indexes(n);
    }
  }
}

#endif

void uvmc_packer_rep::pack_char(char a) {
  pack_int_n(a,8);
}


void uvmc_packer_rep::pack_string(std::string a) {
  int nchars = a.length();
  //pack_int_n(nchars,32);
  for (int i = 0; i < nchars; i++) {
    pack_char(a[i]);
  }
  pack_int_n(0,8);
}

void uvmc_packer_rep::pack_sc_bit(const sc_bit& a) {
  pack_int_n(a.to_bool(),1);
}

void uvmc_packer_rep::pack_sc_logic(const sc_logic& a) {
  pack_int_n(a.value(),1);
}

void uvmc_packer_rep::pack_sc_bv_base(const sc_bv_base& a) {
  int n = a.length();
  int words = (n+31)/32;
  uint64 val;
  for (int i=0; i<words; i++) {
    val = a.get_word(i);
    pack_int_n(val,n>=32?32:n);
    n += 32; 
  }
}

void uvmc_packer_rep::pack_sc_lv_base(const sc_lv_base& a) {
  int n = a.length();
  int words = (n+31)/32;
  uint64 val;
  for (int i=0; i<words; i++) {
    val = a.get_word(i);
    pack_int_n(val,n>=32?32:n);
    n -= 32; 
  }
}

void uvmc_packer_rep::pack_sc_int_base(const sc_int_base& a) {
  int n = a.length();
  pack_int_n(a.to_int64(),n);
}
void uvmc_packer_rep::pack_sc_uint_base(const sc_uint_base& a) {
  int n = a.length();
  pack_int_n(a.to_uint64(),n);
}

void uvmc_packer_rep::pack_sc_signed(const sc_signed& a) {
  // TODO: more efficient algorithm than bit-by-bit without going proprietary?
  int n = a.length();
  for (int i = 0; i < n; i++) {
    pack_int_n(a.test(i),1);
  }
}

void uvmc_packer_rep::pack_sc_unsigned(const sc_unsigned& a) {
  // TODO: more efficient algorithm than bit-by-bit without going proprietary?
  int n = a.length();
  for (int i = 0; i < n; i++) {
    pack_int_n(a.test(i),1);
  }
}

void uvmc_packer_rep::pack_float(float a) {
  unsigned int* uint32_p = reinterpret_cast<unsigned int*>(&a);
  unsigned int val = *uint32_p;
  pack_int_n(val,32);
}

void uvmc_packer_rep::pack_double(double a) {
  uint64* uint64_p = reinterpret_cast<uint64*>(&a);
  uint64 val = *uint64_p;
  pack_int_n(val,64);
}

// TODO: account for time unit
void uvmc_packer_rep::pack_sc_time(const sc_time& a) {
  uint64 val = a.value();
  pack_int_n(val,64);
}


//------------------------------------------------------------------------------
// UNPACK
//------------------------------------------------------------------------------

// The following extracts and shifts N bits from VAL starting at INDEX within
// the 32-bit word. VAL is [31..0], so an INDEX=31 and N=8 yields VAL[31:24].

#ifdef MSB_FIRST
uint64 uvmc_packer_rep::unpack_int_n(unsigned int n) {

  uint64 val;

  val  = *bits_ptr;

  //cout << "UNPACK_INT_N(" << dec << n << ") bit_index="
  //     << bit_index << " val=" << hex << val << dec << endl;

  if (n <= bit_index) {
    val = ( ((~(((uint64)-1) << bit_index)) &
            (((uint64)-1) << (bit_index-n)) ) & val) >> (bit_index-n);
    update_indexes(n);
    return val;
  }

  // With 0 < n <= 64, word can span up to three 32-bit words
  //
  // |31     0|31     0|31    0|
  //     xxxxx xxxxxxxx xxxx       // spans 3 words
  //    xxxxxx xxx                 // spans 2 words
  //  xxxxxxxx xxxxxxxx            // spans 2 words
  //    xxx                        // spans 1 word

  uint64 allbits= 0;

  // left-bits
  allbits = ( (~(((uint64)-1) << bit_index)) & val ) << (n-bit_index);

  n -= bit_index;
  update_indexes(bit_index);

  // mid-bits
  if (n >= 32) {
    val = *bits_ptr;
    allbits = allbits | (val << (n-bit_index));
    n -= 32;
    update_indexes(32);
  }

  if (n > 0) {
    val = *bits_ptr;
    //allbits = allbits |
    //          (((((uint64)-1)<<(bit_index-n)) & val) >> (bit_index-n));
    allbits = allbits | (val >> (bit_index-n));

    // combine
    update_indexes(n);
  }
  return allbits;
}



//-------------------------------
// LSB

#else // LSB_FIRST

uint64 uvmc_packer_rep::unpack_int_n(unsigned int n) {

  uint64 val;

  val  = *bits_ptr;

  //cout << "UNPACK_INT_N(" << dec << n
  //     << ") bit_index=" << bit_index  << endl;

  if (n <= (unsigned)(32-bit_index)) {
    val = (val >> bit_index) & (~(((uint64)-1) << n));
    update_indexes(n);
  //cout << " val=" << hex << val << dec << endl;
    return val;
  }

  // With 0 < n <= 64, word can span up to three 32-bit words
  //
  // |31     0|31     0|31    0|
  //     xxxxx xxxxxxxx xxxx       // spans 3 words
  //    xxxxxx xxx                 // spans 2 words
  //  xxxxxxxx xxxxxxxx            // spans 2 words
  //    xxx                        // spans 1 word

  uint64 allbits= 0;
  uint64 numbits = 32-bit_index;

  // right-bits
  allbits = (val >> bit_index) & (~(((uint64)-1)<<numbits));
  n -= numbits;
  update_indexes(numbits);
  //cout << "  right=" << hex << allbits
  //     << " (bit_idx=" << bit_index << ")" << endl;

  // mid-bits
  if (n >= 32) {
    val = *bits_ptr;
    allbits = allbits | (val << numbits);
    n -= 32;
    update_indexes(32);
    numbits += 32;
    //cout << "  middle=" << hex << allbits
    //     << " (bit_idx=" << bit_index << ")" << endl;
  }

  // left-bits
  if (n > 0) {
    val = *bits_ptr;
    //allbits = allbits |
    //     (((((uint64)-1)<<(bit_index-n)) & val) >> (bit_index-n));
    allbits = allbits | (((~(((uint64)-1)<<n)) & val) << numbits);

    // combine
    update_indexes(n);
    //cout << "  left=" << hex << allbits
    //     << " (bit_idx=" << bit_index << ")" << endl;
  }
  //cout << " val=" << hex << allbits << dec << endl;
  return allbits;
}
#endif


void uvmc_packer_rep::unpack_char(char& a) {
  uint64 val;
  val = unpack_int_n(8);
  a = val & 0xFF;
}


void uvmc_packer_rep::unpack_string(std::string& a) {
  a = "";
  char c;
  unpack_char(c);
  while (c != 0) {
    a = a + c;
    unpack_char(c);
  }
}


void uvmc_packer_rep::unpack_sc_bit(sc_bit& a) {
  uint64 val;
  val = unpack_int_n(1);
  a = (val & 0x1)?true:false;
}

void uvmc_packer_rep::unpack_sc_logic(sc_logic& a) {
  uint64 val;
  val = unpack_int_n(1);
  a = (val & 0x1)?true:false;
}

void uvmc_packer_rep::unpack_sc_bv_base(sc_bv_base& a) {
  int n = a.length();
  int words = (n+31)/32;
  for (int i=0; i<=words-1; i++) {
    a.set_word(i,unpack_int_n(n>=32?32:n));
    n -= 32; 
  }
}

//
void uvmc_packer_rep::unpack_sc_lv_base(sc_lv_base& a) {
  int n = a.length();
  int words = (n+31)/32;
  for (int i=0; i<=words-1; i++) {
    a.set_word(i,unpack_int_n(n>=32?32:n));
    a.set_cword(i,0);
    n -= 32; 
  }
}

//
void uvmc_packer_rep::unpack_sc_int_base(sc_int_base& a) {
  int n = a.length();
  a = unpack_int_n(n);
}

//
void uvmc_packer_rep::unpack_sc_uint_base(sc_uint_base& a) {
  int n = a.length();
  a = unpack_int_n(n);
}

//
void uvmc_packer_rep::unpack_sc_signed(sc_signed& a) {
  // TODO: find more efficient assignment than bit-by-bit
  int n = a.length();
  for (int i = 0; i < n; i++) {
    int val = unpack_int_n(1);
    if (val) {
      a.set(i, true);
    } else {
      a.set(i, false);
    }
  }
}

//
void uvmc_packer_rep::unpack_sc_unsigned(sc_unsigned& a) {
  int n = a.length();
  for (int i = 0; i < n; i++) {
    int val = unpack_int_n(1);
    if (val) {
      a.set(i, true);
    } else {
      a.set(i, false);
    }
  }
}

void uvmc_packer_rep::unpack_float(float& a) {
  unsigned int val = unpack_int_n(32);
  float* float_p = reinterpret_cast<float*>(&val);
  a = *float_p;
}

void uvmc_packer_rep::unpack_double(double& a) {
  uint64 val = unpack_int_n(64);
  double* double_p = reinterpret_cast<double*>(&val);
  a = *double_p;
}

// TODO: account for time unit
void uvmc_packer_rep::unpack_sc_time(sc_time& a) {
  uint64 val = unpack_int_n(64);
  sc_time t(val,0); // TODO: is this c'tor standard?
  a = t;
}


//------------------------------------------------------------------------------
// uvmc_packer implementation
//------------------------------------------------------------------------------

uvmc_packer::uvmc_packer()
#ifdef UVMC23_ADDITIONS // {
  : m_uvmc_owns_trans(0)
#endif // } UVMC23_ADDITIONS
{
  m_rep = new uvmc_packer_rep(this);
}

uvmc_packer::~uvmc_packer() { 
  delete m_rep;
}


// unpack
void uvmc_packer::init_unpack(const bits_t *bits, int level) {
  m_rep->init_unpack(bits, level);
}

// pack
void uvmc_packer::init_pack(bits_t *bits, int level) {
  m_rep->init_pack(bits, level);
}


uvmc_packer& uvmc_packer::operator << (bool a) { 
  int i = a ? 1 : 0;
  m_rep->pack_int_n(i,1);
  return *this;
}

uvmc_packer& uvmc_packer::operator >> (bool& a) { 
  a = (bool)(m_rep->unpack_int_n(1));
  return *this;
}

/////////////////////////////
void uvmc_packer::unpack_sc_bv_base(sc_bv_base& a) {
 m_rep->unpack_sc_bv_base(a);
}

void uvmc_packer::unpack_sc_lv_base(sc_lv_base& a) {
 m_rep->unpack_sc_lv_base(a);
}

void uvmc_packer::unpack_sc_int_base(sc_int_base& a) {
 m_rep->unpack_sc_int_base(a);
}

void uvmc_packer::unpack_sc_uint_base(sc_uint_base& a) {
 m_rep->unpack_sc_uint_base(a);
}

void uvmc_packer::unpack_sc_signed(sc_signed& a) {
 m_rep->unpack_sc_signed(a);
}

void uvmc_packer::unpack_sc_unsigned(sc_unsigned& a) {
 m_rep->unpack_sc_unsigned(a);
}


#define def_pack_sctype_operators(T) \
uvmc_packer& uvmc_packer::operator << (const T& a) { \
  m_rep->pack_##T(a);\
  return *this;\
}

#define def_unpack_sctype_operators(T) \
uvmc_packer& uvmc_packer::operator >> (T& a) {  \
  m_rep->unpack_##T(a); \
  return *this; \
}

def_pack_sctype_operators(sc_bit)
def_pack_sctype_operators(sc_logic)
def_pack_sctype_operators(sc_bv_base)
def_pack_sctype_operators(sc_lv_base)
def_pack_sctype_operators(sc_int_base)
def_pack_sctype_operators(sc_uint_base)
def_pack_sctype_operators(sc_signed)
def_pack_sctype_operators(sc_unsigned)
def_pack_sctype_operators(sc_time)

def_unpack_sctype_operators(sc_bit)
def_unpack_sctype_operators(sc_logic)
def_unpack_sctype_operators(sc_signed)
def_unpack_sctype_operators(sc_unsigned)
def_unpack_sctype_operators(sc_time)



#define def_pack_int_operators(T) \
uvmc_packer& uvmc_packer::operator << (T a) { \
  m_rep->pack_int_n(a,8*sizeof(T));\
  return *this;\
} \
uvmc_packer& uvmc_packer::operator >> (T& a) {  \
  a = (T)(m_rep->unpack_int_n(8*sizeof(T))); \
  return *this; \
}

typedef unsigned char uchar;
typedef unsigned short ushort;
typedef unsigned int uint;
typedef unsigned long ulong;

def_pack_int_operators(char)
def_pack_int_operators(uchar)
def_pack_int_operators(short)
def_pack_int_operators(ushort)
def_pack_int_operators(int)
def_pack_int_operators(uint)
def_pack_int_operators(long)
def_pack_int_operators(ulong)
def_pack_int_operators(int64)
def_pack_int_operators(uint64)


uvmc_packer& uvmc_packer::operator << (const char* a) { 
  if (!a) {
    m_rep->pack_string("");
  } else {
    m_rep->pack_string(a);
  }
  return *this;
}

uvmc_packer& uvmc_packer::operator << (std::string a) { 
  m_rep->pack_string(a);
  return *this;
}

uvmc_packer& uvmc_packer::operator >> (std::string& a) { 
  m_rep->unpack_string(a);
  return *this;
}

uvmc_packer& uvmc_packer::operator << (float a) {
  m_rep->pack_float(a);
  return *this;
}
uvmc_packer& uvmc_packer::operator >> (float& a) {
  m_rep->unpack_float(a);
  return *this;
}

uvmc_packer& uvmc_packer::operator << (double a) {
  m_rep->pack_double(a);
  return *this;
}
uvmc_packer& uvmc_packer::operator >> (double& a) {
  m_rep->unpack_double(a);
  return *this;
}


} // namespace uvmc

