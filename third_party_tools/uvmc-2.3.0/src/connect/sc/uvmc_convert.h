//
//------------------------------------------------------------//
//   Copyright 2009-2012 Mentor Graphics Corporation          //
//   All Rights Reserved Worldwid                             //
//                                                            //
//   Licensed under the Apache License, Version 2.0 (the      //
//   "License"); you may not use this file except in          //
//   compliance with the License.  You may obtain a copy of   //
//   the License at                                           //
//                                                            //
//       http://www.apache.org/licenses/LICENSE-2.0           //
//                                                            //
//   Unless required by applicable law or agreed to in        //
//   writing, software distributed under the License is       //
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR   //
//   CONDITIONS OF ANY KIND, either express or implied.  See  //
//   the License for the specific language governing          //
//   permissions and limitations under the License.           //
//------------------------------------------------------------//

#ifndef UVMC_CONVERT_H
#define UVMC_CONVERT_H

#include <iostream>
#include <ostream>
#include <iomanip>
#include <tlm.h>

using std::ostream;
using std::cout;
using std::setw;

#include "uvmc_packer.h"

//------------------------------------------------------------------------------
//
// Class- uvmc_converter<T>
//
// Class used to pack/unpack the transaction type T to/from a canonical
// bit format using an instance of the uvmc_packer.
//
// The default implementation delegates to T::pack and 
// T::unpack. If T does not implement these methods and a template
// specialization is not defined for T, a compiler error will result.
//
// We declare outside uvmc namespace to allow users to specialize outside
// the namespace
//------------------------------------------------------------------------------

using namespace tlm;
using namespace uvmc;

template <typename T>
class uvmc_converter {

  static int uvm_version_is_pre11b;

  public:

  static void do_pack(const T &t, uvmc_packer &packer) {
    t.do_pack(packer);
  }
  static void do_unpack(T &t, uvmc_packer &packer) {
    t.do_unpack(packer);
  }

  template <class CVRT>
  static void do_pack_extensions(const T &t, uvmc_packer &packer) {
  }

  static void do_unpack_extensions(T &t, uvmc_packer &packer) {
  }
};



//------------------------------------------------------------------------------
//
// Class- uvmc_converter<tlm_generic_payload>
//
// Converter template specialization for tlm_generic_payload
//------------------------------------------------------------------------------

// pack order- NO extensions
//
//   addr
//   cmd
//   (data_len, data)
//   data_len              (pre-UVM 1.1b only)
//   status
//   (byte_en_len, byte_en)
//   streaming_width
//
// Data_len is no longer packed twice.
//
// Later versions of UVM should not attempt packing/unpack extensions, as those
// must be handled deterministically via custom converters by end-users.


// TODO: use tlm memory manager for data/byte_en array allocation
// Current scheme does not support more than one outstanding transaction.
//unsigned char d[1024];
//unsigned char be[1024];


template <>
class uvmc_converter<tlm_generic_payload> {

  public:

  // do_pack
  // -------

  static void do_pack(const tlm_generic_payload &t, uvmc_packer &packer)
  {
    unsigned char *data_ptr    = t.get_data_ptr();
    unsigned int   data_len    = t.get_data_length();
    unsigned char *byte_en_ptr = t.get_byte_enable_ptr();
    unsigned int   byte_en_len = t.get_byte_enable_length();
    sc_dt::uint64  addr        = t.get_address();

    if (data_len == 0 || data_ptr == NULL) {
      data_len = 0;
      data_ptr = NULL;
    }

    if (byte_en_len == 0 || byte_en_ptr == NULL) {
      byte_en_len = 0;
      byte_en_ptr = NULL;
    }

    packer << addr;
    packer << (int)(t.get_command());
    packer << data_len;

    if (data_ptr != NULL) {
      for (unsigned int i=0;i<data_len;i++) {
        packer << (unsigned char)(data_ptr[i]);
      }
    }

    if (uvmc_uvm_version_is_pre11b) {
      packer << data_len;
      }

    packer << (int)(t.get_response_status());
    packer << byte_en_len;

    if (byte_en_ptr != NULL) {
      for (unsigned int i=0;i<byte_en_len;i++) {
        packer << (unsigned char)(byte_en_ptr[i]);
      }
    }

    packer << t.get_streaming_width();

    // extensions: default converter cannot pack extensions because
    // it cannot determine the concreate converter types and cannot
    // unpack in a deterministic order.

  }

  // do_unpack
  // ---------

  static void do_unpack(tlm_generic_payload &t, uvmc_packer &packer)
  { 
    unsigned char *curr_data_ptr    = t.get_data_ptr();
    unsigned int   curr_data_len    = t.get_data_length();
    unsigned char *curr_byte_en_ptr = t.get_byte_enable_ptr();
    unsigned int   curr_byte_en_len = t.get_byte_enable_length();
    unsigned int   new_byte_en_len;
    int            new_resp_stat;
    unsigned char *new_data_ptr;
    unsigned char *new_byte_en_ptr;
    int            new_stream_width;
    unsigned int new_data_len;
    int new_cmd;
    sc_dt::uint64 new_addr;

    packer >> new_addr;
    packer >> new_cmd;
    packer >> new_data_len;

    if (new_data_len > UVMC_MAX_WORDS*sizeof(bits_t)) {
      SC_REPORT_FATAL("TLM_GP/DATA/TOO_LONG", \
         "TLM GP data array length unpacked as impossibly long. "
         "Make sure pack and unpack algorithms are compatible. "
         "Was the same UVM version used to compile UVM Connect as your user code?"
         );
    }

    // TODO: need dynamic mem allocation; gp argument must have data/be ptr already?
    // (but byte_en may be used--try not to allocate when you don't have to)
    //curr_data_ptr = (unsigned char *)(d);
    //t.set_data_ptr(curr_data_ptr);
    if (curr_data_ptr != NULL) {
      if (new_data_len > curr_data_len) {
        //delete curr_data_ptr;
        new_data_ptr = (unsigned char *)(new int[new_data_len]);
      }
      else {
        new_data_ptr = curr_data_ptr;
      }
    }
    else {
      if (new_data_len)
        new_data_ptr = (unsigned char *)(new int[new_data_len]);
    }

    for (unsigned int i=0;i<new_data_len;i++) {
      char data;
      packer >> data;
      *(new_data_ptr+i) = data;
    }

    if (uvmc_uvm_version_is_pre11b) {
      packer >> new_data_len; // is packed as data, not metadata
     }

    packer >> new_resp_stat;
    packer >> new_byte_en_len;

    if (new_byte_en_len > UVMC_MAX_WORDS*sizeof(bits_t)/2) {
      SC_REPORT_FATAL("TLM_GP/BYTE_EN/TOO_LONG", 
         "TLM GP byte enable array length unpacked as impossibly long. "
         "Make sure pack and unpack algorithms are compatible. "
         "Was the same UVM version used to compile UVM Connect as your user code?"
         );
    }

    // TODO: use tlm memory manager
    //curr_byte_en_ptr = (unsigned char *)(be);
    //t.set_byte_enable_ptr(curr_byte_en_ptr);
    // do we need to allocate memory?
    if (curr_byte_en_ptr != NULL) {
      if (new_byte_en_len > curr_byte_en_len) {
        //delete curr_byte_en_ptr;
        new_byte_en_ptr = (unsigned char *)(new int[new_byte_en_len]);
      }
      else {
        new_byte_en_ptr = curr_byte_en_ptr;
      }
    }
    else {
      if (new_byte_en_len) {
        new_byte_en_ptr = (unsigned char *)(new int[new_byte_en_len]);
      }
    }

    for (unsigned int i=0;i<new_byte_en_len;i++) {
      char byte_en;
      packer >> byte_en;
      *(new_byte_en_ptr+i) = byte_en;
    }

    packer >> new_stream_width;

    t.set_address(new_addr);
    t.set_command((tlm::tlm_command)(new_cmd));
    t.set_data_length(new_data_len);
    t.set_data_ptr(new_data_ptr);
    t.set_response_status((tlm::tlm_response_status)(new_resp_stat));
    t.set_byte_enable_length(new_byte_en_len);
    t.set_byte_enable_ptr(new_byte_en_ptr);
    t.set_streaming_width(new_stream_width);


    // extensions: default converter cannot unpack extensions because
    // it cannot determine the concreate converter types and cannot
    // unpack in a deterministic order.

  }

  /*
      if (new_byte_en_len)
  template <class CVRT>
  static void do_pack_extensions(const T &t, uvmc_packer &packer) {

    for(unsigned int i=0; i<m_extensions.size(); i++) {
      if(!m_extensions[i]) {
      }
    }
  }
  */
};

template class uvmc_converter<tlm_generic_payload>;


//------------------------------------------------------------------------------
//
// Class- uvmc_print<T>
//
// Default implementation delegates to T::print
//
//------------------------------------------------------------------------------

template <typename T>
class uvmc_print {
  public:
  static ostream& print(const T &t, ostream& os=cout) {
    t.print(os);
    return os;
  }
};


//------------------------------------------------------------------------------
//
// Class- uvmc_print<tlm_generic_payload>
//
// Template specialization of uvmc_print class for the tlm_generic_payload type
//
//------------------------------------------------------------------------------

template <>
class uvmc_print<tlm_generic_payload> {
  public:
  static ostream& print(const tlm_generic_payload &t, ostream& os=cout) {
    tlm_command cmd;
    os << "'{";

    os << " addr:" << hex << t.get_address();

    cmd = t.get_command();
    if (cmd == TLM_READ_COMMAND)
      os << " command:"  << "TLM_READ_COMMAND";
    else if (cmd == TLM_WRITE_COMMAND)
      os << " command:"  << "TLM_WRITE_COMMAND";
    else
      os << " command:"  << "TLM_IGNORE_COMMAND";

    unsigned char *data_ptr    = t.get_data_ptr();
    unsigned int data_len      = t.get_data_length();
    os << " length:" << data_len;

    if (data_len != 0) {
      os << " data: {";
      for (unsigned int i=0;i<data_len;i++) {
        os << " [" << dec << i << "]:'x" << hex << (int)(data_ptr[i]);
      }
      os << " }";
    }

    os << " response_status:"  << t.get_response_string();

    unsigned char *byte_en_ptr = t.get_byte_enable_ptr();
    unsigned int byte_en_len   = t.get_byte_enable_length();
    if (byte_en_len != 0) {
      os << " byte_en: {";
      for (unsigned int i=0;i<byte_en_len;i++) {
        os << " [" << dec << i << "]:'x" << hex << (int)(byte_en_ptr[i]);
      }
      os << " }";
    }

    os << dec << " streaming_width:"  << t.get_streaming_width();

    os << " }";

    return os;
  }
};

template class uvmc_print<tlm_generic_payload>;

/*
//------------------------------------------------------------------------------
//
// Function- operator<< (T[N])
//
//------------------------------------------------------------------------------

#ifndef UVMC_NO_COUT_FIXED_ARRAY

template <typename T, int N>
ostream& operator << (ostream& os, const T(&a)[N]) {
  os << "'{" << hex;
  for (int i = 0; i < N; i++) {
    if (i != 0) {
      os << ", ";
    }
    os << a[i];
  }
  os << "}" << dec;
  return os;
}

#endif
*/



//------------------------------------------------------------------------------
// Function- operator<< (char)
//
// So char type prints as numeric value, not ASCII character
//------------------------------------------------------------------------------

template <>
class uvmc_print<const char&> {
  public:
  static ostream& print(const char &v, ostream& os=cout) {
    os << (int)v;
    return os;
  }
};

template <>
class uvmc_print<const unsigned char&> {
  public:
  static ostream& print(const unsigned char &v, ostream& os=cout) {
    os << (int)v;
    return os;
  }
};

#ifndef UVMC_NO_COUT_CHAR
ostream& operator << (ostream& os, const char& v);
ostream& operator << (ostream& os, const unsigned char& v);
ostream& operator << (ostream& os, char& v);
ostream& operator << (ostream& os, unsigned char& v);

//ostream& operator << (ostream& os, string& v);
//ostream& operator << (ostream& os, const string& v);
#endif


//------------------------------------------------------------------------------
//
// Function- operator<< (tlm_generic_payload)
//
//------------------------------------------------------------------------------

#ifndef UVMC_NO_COUT_TLM_GP
ostream& operator << (ostream& os, const tlm_generic_payload & t);
#endif


//------------------------------------------------------------------------------
//
// Function- operator<< (vector<T>)
//
//------------------------------------------------------------------------------

#ifndef UVMC_NO_COUT_STL_VECTOR
#include <vector>
using std::vector;

template <typename T>
ostream& operator << (ostream& os, const vector<T>& v) {
  os << "'{";
  int sz;
  sz = v.size();
  if (sz) {
    os << hex;
    for (int i=0; i < sz; i++) {
      os << (v[i]);
      if (i < sz-1) {
        os << ", ";
      }
    }
  }
  os << "}";
  os << dec;
  return os;
}
#endif


//------------------------------------------------------------------------------
//
// Function- operator<< (list<T>)
//
//------------------------------------------------------------------------------

#ifndef UVMC_NO_COUT_STL_LIST
#include <list>
using std::list;

template <typename T>
ostream& operator << (ostream& os, const list<T>& v) {
  typename list<T>::const_iterator i;
  os << "'{";
  os << hex;
  for (i = v.begin(); i != v.end(); i++) {
    if (i != v.begin()) {
      os << ", ";
    }
    os << *i;
  }
  os << "}";
  os << dec;
  return os;
}
#endif


//------------------------------------------------------------------------------
//
// Function- operator<< (map<KEY,T>)
//
//------------------------------------------------------------------------------

#ifndef UVMC_NO_COUT_STL_MAP
#include <map>
using std::map;

template <typename KEY, typename T>
ostream& operator << (ostream& os, const map<KEY,T>& m) {
  typename map<KEY,T>::const_iterator iter;
  iter = m.begin();
  os << "'{";
  while(iter != m.end()) {
    os << (*iter).first;
    os << ":";
    os << (*iter).second;
    iter++;
    if (iter != m.end()) {
      os << ", ";
    }
  }
  os << "}";
  return os;
}
#endif

#endif // UVMC_CONVERT_H
