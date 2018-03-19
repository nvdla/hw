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

#ifndef UVMC_PACKER_H
#define UVMC_PACKER_H

#include "systemc.h"

//typedef int unsigned bits_t;
#include "uvmc_common.h"

#include <vector>
#include <list>
#include <map>
using std::vector;
using std::list;
using std::map;


namespace uvmc {

// forward declaration of internal class uvmc_packer_rep

class uvmc_packer_rep;

//------------------------------------------------------------------------------
//
// CLASS- uvmc_packer
//
// Class that provides packing/unpacking policy for data objects.
//
// Unpacking (operator >>) is supported for the following types
//
// - bool
// - char, unsigned char
// - short, unsigned short
// - int, unsigned int
// - long, unsigned long
// - long long, unsigned long long
// - float
// - double
// - sc_bit
// - sc_logic
// - sc_bv<N>
// - sc_int<N>
// - sc_uint<N>
// - sc_bigint<N>
// - sc_biguint<N>
// - enums (converted to int)
// - T[N], where T is one of the above types
// - vector<T>, where T is one of the above types
// - list<T>, where T is one of the above types
// - map<KEY,T>, where KEY and T are among the above types
//------------------------------------------------------------------------------

class uvmc_packer {
public:

  uvmc_packer();
  virtual ~uvmc_packer();

  void init_unpack(const bits_t *bits, int level=0);
  void init_pack(bits_t *bits, int level=0);


  //----------------------------------------------------------------------------
  // Topic- Packing (operator <<)
  //----------------------------------------------------------------------------

  uvmc_packer& operator << (bool a);
  uvmc_packer& operator << (char a);
  uvmc_packer& operator << (unsigned char a);
  uvmc_packer& operator << (short a);
  uvmc_packer& operator << (unsigned short a);
  uvmc_packer& operator << (int a);
  uvmc_packer& operator << (unsigned int a);
  uvmc_packer& operator << (long a);
  uvmc_packer& operator << (unsigned long a);
  uvmc_packer& operator << (long long a);
  uvmc_packer& operator << (unsigned long long a);
  
  uvmc_packer& operator << (float a);
  uvmc_packer& operator << (double a);

  uvmc_packer& operator << (const char*);
 
  uvmc_packer& operator << (const sc_bit& a);
  uvmc_packer& operator << (const sc_logic& a);
  uvmc_packer& operator << (const sc_bv_base& a);
  uvmc_packer& operator << (const sc_lv_base& a);
  uvmc_packer& operator << (const sc_int_base& a);
  uvmc_packer& operator << (const sc_uint_base& a);
  uvmc_packer& operator << (const sc_signed& a);
  uvmc_packer& operator << (const sc_unsigned& a);
  uvmc_packer& operator << (const sc_time& a);

  // STL types (dyn arrays)
  uvmc_packer& operator << (std::string a);

  template <typename T, int N> uvmc_packer& operator<< (const T (&a)[N]) {
    for (int i = 0; i < N; i++) {
      (*this) << a[i];
    }
    return *this;
  }

  template <typename T> uvmc_packer& operator<< (const vector<T>& a) {
    int n = a.size();
    (*this) << n;
    typename vector<T>::const_iterator i;
    for (i = a.begin(); i != a.end(); i++) {
      (*this) << (T)(*i);
    }
    return *this;
  }

  template <typename T> uvmc_packer& operator<< (const list<T>& a) {
    int n = a.size();
    (*this) << n;
    typename list<T>::const_iterator i;
    for (i = a.begin(); i != a.end(); i++) {
      (*this) << *i;
    }
    return *this;
  }

  template <typename KEY, typename T> uvmc_packer& operator<< (const map<KEY,T>& a) {
    int n;
    typename map<KEY,T>::const_iterator iter;
    n = a.size();
    iter = a.begin();
    (*this) << n;
    iter = a.begin();
    while(iter != a.end()) {
      (*this) << (*iter).first;
      (*this) << (*iter).second;
      iter++;
    }
    return *this;
  }


  //----------------------------------------------------------------------------
  // Topic- Unpacking (operator <<)
  //----------------------------------------------------------------------------

  uvmc_packer& operator >> (bool& a);
  uvmc_packer& operator >> (char& a);
  uvmc_packer& operator >> (unsigned char& a);
  uvmc_packer& operator >> (short& a);
  uvmc_packer& operator >> (unsigned short& a);
  uvmc_packer& operator >> (int& a);
  uvmc_packer& operator >> (unsigned int& a);
  uvmc_packer& operator >> (long& a);
  uvmc_packer& operator >> (unsigned long& a);
  uvmc_packer& operator >> (long long& a);
  uvmc_packer& operator >> (unsigned long long& a);

  uvmc_packer& operator >> (float& a);
  uvmc_packer& operator >> (double& a);

  // SC types
  uvmc_packer& operator >> (sc_bit& a);
  uvmc_packer& operator >> (sc_logic& a);
  uvmc_packer& operator >> (sc_signed& a);
  uvmc_packer& operator >> (sc_unsigned& a);
  uvmc_packer& operator >> (sc_time& a);
  void unpack_sc_bv_base(sc_bv_base& a);
  void unpack_sc_lv_base(sc_lv_base& a);
  void unpack_sc_int_base(sc_int_base& a);
  void unpack_sc_uint_base(sc_uint_base& a);
  void unpack_sc_signed(sc_signed& a);
  void unpack_sc_unsigned(sc_unsigned& a);


  // STL types (dyn arrays)

  uvmc_packer& operator >> (string& a);

  template <class T> uvmc_packer& operator >> (std::vector<T>& a) {
    a.clear();
    int n;
    (*this) >> n;
    for (int i = 0; i < n; i++) {
      T t;
      (*this) >> t;
      a.push_back(t);
    }
    return *this;
  }

  template <class T> uvmc_packer& operator >> (std::list<T>& a) {
    a.clear();
    int n;
    (*this) >> n;
    for (int i = 0; i < n; i++) {
      T t;
      (*this) >> t;
      a.push_back(t);
    }
    return *this;
  }

  template <typename KEY, typename T> uvmc_packer& operator >> (std::map<KEY,T>& a) {
    KEY k;
    T t;
    int n;
    a.clear();
    (*this) >> n;
    for (int i = 0; i < n; i++) {
      (*this) >> k >> t;
      a[k] = t;
    }
    return *this;
  }

  // T[N]
  template <typename T, int N> uvmc_packer& operator>> (T (&a)[N]) {
    for (int i = 0; i < N; i++) {
      (*this) >> a[i];
    }
    return *this;
  }

  template <int N> uvmc_packer& operator>> (sc_bv<N>& a) {
    unpack_sc_bv_base(a);
    return *this;
  }

  template <int N> uvmc_packer& operator>> (sc_lv<N>& a) {
    unpack_sc_lv_base(a);
    return *this;
  }

  template <int N> uvmc_packer& operator>> (sc_int<N>& a) {
    unpack_sc_int_base(a);
    return *this;
  }

  template <int N> uvmc_packer& operator>> (sc_uint<N>& a) {
    unpack_sc_uint_base(a);
    return *this;
  }

  template <int N> uvmc_packer& operator>> (sc_bigint<N>& a) {
    unpack_sc_signed(a);
    return *this;
  }

  template <int N> uvmc_packer& operator>> (sc_biguint<N>& a) {
    unpack_sc_unsigned(a);
    return *this;
  }

  // a little dangerous
  template <typename ENUM> uvmc_packer& operator>> (ENUM& a) {
    int enum_val;
    (*this) >> enum_val;
    a = reinterpret_cast<ENUM&>(enum_val);
    return *this;
  }

#ifdef UVMC23_ADDITIONS // {
  // Special accessors to allow converters to query if transaction being
  // unpacked/packed is "owned" by application or UVMC (for knowing when
  // to allocate/ release local config extensions or use application defined
  // ones). See comments in uvmc_xl_converter.h for more details.
  void uvmc_owns_trans( int enable ) { m_uvmc_owns_trans = enable; }
  int does_uvmc_own_trans( ) const { return m_uvmc_owns_trans; }
#endif // } UVMC23_ADDITIONS

  protected:
  uvmc_packer_rep* m_rep;

#ifdef UVMC23_ADDITIONS // {
  int m_uvmc_owns_trans;
#endif // } UVMC23_ADDITIONS

}; // class uvm_packer

} // namespace uvmc

#endif // UVMC_PACKER_H
