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

#ifndef UVMC_MACROS_H
#define UVMC_MACROS_H

//------------------------------------------------------------------------------
// Title: SC Macros
//
// UVMC defines simple convenience macros for generating converter
// definitions and output stream operator (~operator<<(ostream&)~) so that you
// may use ~cout~ to print the contents of your SC transactions. These macros
// do not present any performance or debug difficulties beyond the very nature
// of their being macros. The code they expand into would be identical to code
// you would write yourself.
//
// These macros are completely optional. You are encouraged to learn how to write
// converters and operator<<, perhaps using the macro definitions as templates
// to get you started.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// MACROS- Report Macros
//
// Convenience macros to <uvmc_report>
// See <uvmc_report> for details on macro arguments.
//------------------------------------------------------------------------------

#define UVMC_INFO(ID,MSG,VERB,CONTEXT) \
    if (uvmc_report_enabled(VERB,UVM_INFO,ID,CONTEXT)) \
      uvmc_report(UVM_INFO,ID,MSG,VERB,CONTEXT,__FILE__,__LINE__)

#define UVMC_WARNING(ID,MSG,CONTEXT) \
    if (uvmc_report_enabled(UVM_NONE,UVM_WARNING,ID,CONTEXT)) \
      uvmc_report(UVM_WARNING,ID,MSG,UVM_NONE,CONTEXT,__FILE__,__LINE__)

#define UVMC_ERROR(ID,MSG,CONTEXT) \
    if (uvmc_report_enabled(UVM_NONE,UVM_ERROR,ID,CONTEXT)) \
      uvmc_report(UVM_ERROR,ID,MSG,UVM_NONE,CONTEXT,__FILE__,__LINE__)

#define UVMC_FATAL(ID,MSG,CONTEXT) \
    if (uvmc_report_enabled(UVM_NONE,UVM_FATAL,ID,CONTEXT)) \
      uvmc_report(UVM_FATAL,ID,MSG,UVM_NONE,CONTEXT,__FILE__,__LINE__)


//------------------------------------------------------------------------------
// MACROS- UVMC_CONVERT_CLASS[_EXT]
//
// Convenience macros for defining template specializations of
// uvmc_converter<T>. 
// Not intended for public usage. See UVMC_PRINT and UVMC_UTILS.
// for direct use by users. See UVMC_UTILS for public user macros.
//
//------------------------------------------------------------------------------

#define UVMC_CONVERT_CLASS(TYPE,TO,FROM) \
template <> \
class uvmc_converter<TYPE> { \
  public: \
  static void do_pack(const TYPE &t, uvmc_packer &packer) { \
    packer << TO; \
  } \
  static void do_unpack(TYPE &t, uvmc_packer &packer) { \
    packer >> FROM; \
  } \
};

#define UVMC_CONVERT_CLASS_EXT(TYPE,BASE,TO,FROM) \
template <> \
class uvmc_converter<TYPE> { \
  public: \
  static void do_pack(const TYPE &t, uvmc_packer &packer) { \
    uvmc_converter<BASE>::do_pack(t,packer); \
    packer << TO; \
  } \
  static void do_unpack(TYPE &t, uvmc_packer &packer) { \
    uvmc_converter<BASE>::do_unpack(t,packer); \
    packer >> FROM; \
  } \
};


//------------------------------------------------------------------------------
// MACROS- UVMC_PRINT_CLASS[_EXT]
//
// Convenience macros for defining template specializations of uvmc_print<T>.
// Not intended for public usage. See UVMC_PRINT and UVMC_UTILS.
// 
// Default implementation delegates to T::print. These macros aide users in
// defining specializations that do not delegate to T.
//
// Requirement: cout defines operator<< for each named member. These macros
// satisfy this requirement for the given TYPE.
//------------------------------------------------------------------------------


#define UVMC_PRINT_CLASS(TYPE,V) \
template <> \
class uvmc_print<TYPE> { \
  public: \
  static void do_print(const TYPE& t, ostream& os=cout) { \
    V \
  } \
  static void print(const TYPE& t, ostream& os=cout) { \
    os << "'{"; \
    do_print(t,os); \
    os << " }"; \
  } \
}; \
ostream& operator << (ostream& os, const TYPE& v) { \
  uvmc_print<TYPE>::print(v,os); \
  return os; \
}


#define UVMC_PRINT_CLASS_EXT(TYPE,BASE,V) \
template <> \
class uvmc_print<TYPE> { \
  public: \
  static void do_print(const TYPE& t, ostream& os=cout) { \
    uvmc_print<BASE>::do_print(t,os); \
    os << " "; \
    V \
  } \
  static void print(const TYPE& t, ostream& os=cout) { \
    os << "'{"; \
    do_print(t,os); \
    os << " }"; \
  } \
}; \
ostream& operator << (ostream& os, const TYPE& v) { \
  uvmc_print<TYPE>::print(v,os); \
  return os; \
}

#define UVMC_PRINT_ARG(V) \
    os << " " #V ":" << hex << t.V << dec;


//------------------------------------------------------------------------------
// MACROS- UVMC_CONVERT_ENUM
// MACROS- UVMC_PRINT_ENUM
//
// Start of convenience macros for converting and printing enum types.
//------------------------------------------------------------------------------

/*
#define UVMC_CONVERT_ENUM(TYPE,TO,FROM) \
template <> \
class uvmc_convert<TYPE> : public uvmc_convert_base<TYPE> { \
  public: \
  void pack(const TYPE &t) { \
    packer << TO; \
  } \
  void unpack(TYPE &t) { \
    packer >> FROM; \
  } \
};

#define UVMC_PRINT_ENUM(TYPE,V) \
template <> \
class uvmc_print<TYPE> { \
  public: \
  static void do_print(const TYPE& t, ostream& os=cout) { \
    V \
  } \
  static void print(const TYPE& t, ostream& os=cout) { \
    os << "'{"; \
    do_print(t,os); \
    os << " }"; \
  } \
}; \
ostream& operator << (ostream& os, const TYPE& v) { \
  uvmc_print<TYPE>::print(v,os); \
  return os; \
}
*/

//#define UVMC_TYPE_NAME(TYPE) 
//  string get_type_name() const { return #TYPE; }



//------------------------------------------------------------------------------
// Topic: UVMC_CONVERT
//
// Generate a converter specialization of ~uvmc_convert<T>~ for the given
// transaction ~TYPE~. 
//
// | UVMC_CONVERT_N (TYPE, <list of N variables> )
// | UVMC_CONVERT_EXT_N (TYPE, BASE, <list of N variables> )
//
// For the second form, the generated converter will pack/unpack the members
// in the provided ~BASE~ class before those in ~TYPE~.
//
// Invoke the macro whose numeric suffix equals the number of field members you
// wish to include in the pack, unpack, and print operations. These must all
// appear in the list of macro arguments in the order you want them streamed.
//
// Example:
//
// | UVMC_CONVERT_3( bus_trans, cmd, addr, data)
// | UVMC_CONVERT_EXT_1 (bus_error, bus_trans, crc)
//
// The first macro generates a converter for the ~bus_trans~
// class. Three member variables of ~bus_trans~ are included in the pack and
// unpack operations, in the order given: ~cmd~, ~addr~, and ~data~.
// If there were other members in ~bus_trans~, they will not be included
// in the converter implementations.
//
// The second macro generates a converter and ~operator<<~ for the ~bus_error~
// class. Packing, unpacking, and output streaming for the base type, ~bus_trans~
// is performed first, followed by the ~crc~ field in ~bus_error~.
//
// The macros above generate the following code
//
//| template <>
//| class uvmc_converter<bus_trans> {
//|   public:
//|   static void do_pack(const bus_trans &t, uvmc_packer &packer) {
//|     packer << cmd << addr << data;
//|   }
//|   static void do_unpack(bus_trans &t, uvmc_packer &packer) {
//|     packer >> cmd >> addr >> data;
//|   }
//| };
//
//| template <>
//| class uvmc_converter<bus_error> {
//|   public:
//|   static void do_pack(const bus_error &t, uvmc_packer &packer) {
//|     uvmc_converter<base_trans>::do_pack(t,packer);
//|     packer << crc;
//|   }
//|   static void do_unpack(bus_error &t, uvmc_packer &packer) {
//|     uvmc_converter<base_trans>::do_unpack(t,packer);
//|     packer >> crc;
//|   }
//| };
//
// Usage notes:
//
//  - The default converter delegates to ~T.do_pack~ and ~T.do_unpack~. For
//    transactions that do not possess these member functions (likely most),
//    use one of these macros to generate a simple converter class that packs
//    and unpacks your transaction from outside your transaction class.
//
//  - All class members given in the list must be public members.
//
//  - The ~uvmc_packer~ must provide ~operator>>~ and ~operator<<~ for all the
//    types passed in the list. See <UVMC Type Support> for a list of supported
//    types.
//
//  - These macros define a simple converter that does bit-by-bit packing and
//    unpacking in the order provided. Any customized conversions would require
//    you write your own converter.  See <Converter Specialization> for details.
//
//  - The macros support up to 20 member variables, i.e. up through
//    UVM_UTILS_20 and UVM_UTILS_EXT_20.
//------------------------------------------------------------------------------

#define UVMC_CONVERT_1(TYPE,V1) \
  UVMC_CONVERT_CLASS(TYPE,\
    t.V1, \
    t.V1)

#define UVMC_CONVERT_2(TYPE,V1,V2) \
  UVMC_CONVERT_CLASS(TYPE,\
    t.V1 << t.V2, \
    t.V1 >> t.V2)

#define UVMC_CONVERT_3(TYPE,V1,V2,V3) \
  UVMC_CONVERT_CLASS(TYPE,\
    t.V1 << t.V2 << t.V3, \
    t.V1 >> t.V2 >> t.V3)

#define UVMC_CONVERT_4(TYPE,V1,V2,V3,V4) \
  UVMC_CONVERT_CLASS(TYPE,\
    t.V1 << t.V2 << t.V3 << t.V4, \
    t.V1 >> t.V2 >> t.V3 >> t.V4)

#define UVMC_CONVERT_5(TYPE,V1,V2,V3,V4,V5) \
  UVMC_CONVERT_CLASS(TYPE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5)

#define UVMC_CONVERT_6(TYPE,V1,V2,V3,V4,V5,V6) \
  UVMC_CONVERT_CLASS(TYPE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6)

#define UVMC_CONVERT_7(TYPE,V1,V2,V3,V4,V5,V6,V7) \
  UVMC_CONVERT_CLASS(TYPE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7)

#define UVMC_CONVERT_8(TYPE,V1,V2,V3,V4,V5,V6,V7,V8) \
  UVMC_CONVERT_CLASS(TYPE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8)

#define UVMC_CONVERT_9(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9) \
  UVMC_CONVERT_CLASS(TYPE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9)

#define UVMC_CONVERT_10(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10) \
  UVMC_CONVERT_CLASS(TYPE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10)

#define UVMC_CONVERT_11(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11) \
  UVMC_CONVERT_CLASS(TYPE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10 << t.V11, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10 >> t.V11)

#define UVMC_CONVERT_12(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12) \
  UVMC_CONVERT_CLASS(TYPE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10 << t.V11 << t.V12, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10 >> t.V11 >> t.V12)

#define UVMC_CONVERT_13(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13) \
  UVMC_CONVERT_CLASS(TYPE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10 << t.V11 << t.V12 << t.V13, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10 >> t.V11 >> t.V12 >> t.V13)

#define UVMC_CONVERT_14(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14) \
  UVMC_CONVERT_CLASS(TYPE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10 << t.V11 << t.V12 << t.V13 << t.V14, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10 >> t.V11 >> t.V12 >> t.V13 >> t.V14)

#define UVMC_CONVERT_15(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15) \
  UVMC_CONVERT_CLASS(TYPE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10 << t.V11 << t.V12 << t.V13 << t.V14 << t.V15, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10 >> t.V11 >> t.V12 >> t.V13 >> t.V14 >> t.V15)

#define UVMC_CONVERT_16(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16) \
  UVMC_CONVERT_CLASS(TYPE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10 << t.V11 << t.V12 << t.V13 << t.V14 << t.V15 << t.V16, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10 >> t.V11 >> t.V12 >> t.V13 >> t.V14 >> t.V15 >> t.V16)

#define UVMC_CONVERT_17(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17) \
  UVMC_CONVERT_CLASS(TYPE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10 << t.V11 << t.V12 << t.V13 << t.V14 << t.V15 << t.V16 << t.V17, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10 >> t.V11 >> t.V12 >> t.V13 >> t.V14 >> t.V15 >> t.V16 >> t.V17)

#define UVMC_CONVERT_18(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18) \
  UVMC_CONVERT_CLASS(TYPE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10 << t.V11 << t.V12 << t.V13 << t.V14 << t.V15 << t.V16 << t.V17 << t.V18, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10 >> t.V11 >> t.V12 >> t.V13 >> t.V14 >> t.V15 >> t.V16 >> t.V17 >> t.V18)

#define UVMC_CONVERT_19(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19) \
  UVMC_CONVERT_CLASS(TYPE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10 << t.V11 << t.V12 << t.V13 << t.V14 << t.V15 << t.V16 << t.V17 << t.V18 << t.V19, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10 >> t.V11 >> t.V12 >> t.V13 >> t.V14 >> t.V15 >> t.V16 >> t.V17 >> t.V18 >> t.V19)

#define UVMC_CONVERT_20(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19,V20) \
  UVMC_CONVERT_CLASS(TYPE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10 << t.V11 << t.V12 << t.V13 << t.V14 << t.V15 << t.V16 << t.V17 << t.V18 << t.V19 << t.V20, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10 >> t.V11 >> t.V12 >> t.V13 >> t.V14 >> t.V15 >> t.V16 >> t.V17 >> t.V18 >> t.V19 >> t.V20)


#define UVMC_CONVERT_EXT_1(TYPE,BASE,V1) \
  UVMC_CONVERT_CLASS_EXT(TYPE,BASE,\
    t.V1, \
    t.V1)

#define UVMC_CONVERT_EXT_2(TYPE,BASE,V1,V2) \
  UVMC_CONVERT_CLASS_EXT(TYPE,BASE,\
    t.V1 << t.V2, \
    t.V1 >> t.V2)

#define UVMC_CONVERT_EXT_3(TYPE,BASE,V1,V2,V3) \
  UVMC_CONVERT_CLASS_EXT(TYPE,BASE,\
    t.V1 << t.V2 << t.V3, \
    t.V1 >> t.V2 >> t.V3)

#define UVMC_CONVERT_EXT_4(TYPE,BASE,V1,V2,V3,V4) \
  UVMC_CONVERT_CLASS_EXT(TYPE,BASE,\
    t.V1 << t.V2 << t.V3 << t.V4, \
    t.V1 >> t.V2 >> t.V3 >> t.V4)

#define UVMC_CONVERT_EXT_5(TYPE,BASE,V1,V2,V3,V4,V5) \
  UVMC_CONVERT_CLASS_EXT(TYPE,BASE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5)

#define UVMC_CONVERT_EXT_6(TYPE,BASE,V1,V2,V3,V4,V5,V6) \
  UVMC_CONVERT_CLASS_EXT(TYPE,BASE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6)

#define UVMC_CONVERT_EXT_7(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7) \
  UVMC_CONVERT_CLASS_EXT(TYPE,BASE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7)

#define UVMC_CONVERT_EXT_8(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8) \
  UVMC_CONVERT_CLASS_EXT(TYPE,BASE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8)

#define UVMC_CONVERT_EXT_9(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9) \
  UVMC_CONVERT_CLASS_EXT(TYPE,BASE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9)

#define UVMC_CONVERT_EXT_10(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10) \
  UVMC_CONVERT_CLASS_EXT(TYPE,BASE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10)

#define UVMC_CONVERT_EXT_11(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11) \
  UVMC_CONVERT_CLASS_EXT(TYPE,BASE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10 << t.V11, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10 >> t.V11)

#define UVMC_CONVERT_EXT_12(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12) \
  UVMC_CONVERT_CLASS_EXT(TYPE,BASE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10 << t.V11 << t.V12, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10 >> t.V11 >> t.V12)

#define UVMC_CONVERT_EXT_13(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13) \
  UVMC_CONVERT_CLASS_EXT(TYPE,BASE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10 << t.V11 << t.V12 << t.V13, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10 >> t.V11 >> t.V12 >> t.V13)

#define UVMC_CONVERT_EXT_14(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14) \
  UVMC_CONVERT_CLASS_EXT(TYPE,BASE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10 << t.V11 << t.V12 << t.V13 << t.V14, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10 >> t.V11 >> t.V12 >> t.V13 >> t.V14)

#define UVMC_CONVERT_EXT_15(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15) \
  UVMC_CONVERT_CLASS_EXT(TYPE,BASE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10 << t.V11 << t.V12 << t.V13 << t.V14 << t.V15, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10 >> t.V11 >> t.V12 >> t.V13 >> t.V14 >> t.V15)

#define UVMC_CONVERT_EXT_16(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16) \
  UVMC_CONVERT_CLASS_EXT(TYPE,BASE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10 << t.V11 << t.V12 << t.V13 << t.V14 << t.V15 << t.V16, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10 >> t.V11 >> t.V12 >> t.V13 >> t.V14 >> t.V15 >> t.V16)

#define UVMC_CONVERT_EXT_17(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17) \
  UVMC_CONVERT_CLASS_EXT(TYPE,BASE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10 << t.V11 << t.V12 << t.V13 << t.V14 << t.V15 << t.V16 << t.V17, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10 >> t.V11 >> t.V12 >> t.V13 >> t.V14 >> t.V15 >> t.V16 >> t.V17)

#define UVMC_CONVERT_EXT_18(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18) \
  UVMC_CONVERT_CLASS_EXT(TYPE,BASE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10 << t.V11 << t.V12 << t.V13 << t.V14 << t.V15 << t.V16 << t.V17 << t.V18, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10 >> t.V11 >> t.V12 >> t.V13 >> t.V14 >> t.V15 >> t.V16 >> t.V17 >> t.V18)

#define UVMC_CONVERT_EXT_19(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19) \
  UVMC_CONVERT_CLASS_EXT(TYPE,BASE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10 << t.V11 << t.V12 << t.V13 << t.V14 << t.V15 << t.V16 << t.V17 << t.V18 << t.V19, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10 >> t.V11 >> t.V12 >> t.V13 >> t.V14 >> t.V15 >> t.V16 >> t.V17 >> t.V18 >> t.V19)

#define UVMC_CONVERT_EXT_20(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19,V20) \
  UVMC_CONVERT_CLASS_EXT(TYPE,BASE,\
    t.V1 << t.V2 << t.V3 << t.V4 << t.V5 << t.V6 << t.V7 << t.V8 << t.V9 << t.V10 << t.V11 << t.V12 << t.V13 << t.V14 << t.V15 << t.V16 << t.V17 << t.V18 << t.V19 << t.V20, \
    t.V1 >> t.V2 >> t.V3 >> t.V4 >> t.V5 >> t.V6 >> t.V7 >> t.V8 >> t.V9 >> t.V10 >> t.V11 >> t.V12 >> t.V13 >> t.V14 >> t.V15 >> t.V16 >> t.V17 >> t.V18 >> t.V19 >> t.V20)


//------------------------------------------------------------------------------
// Topic: UVMC_PRINT
//
// Generate an ~operator<<(ostream&)~ implementation for use with ~cout~ and
// other output streams for the given transaction ~TYPE~. 
//
// | UVMC_PRINT_<N> (TYPE, <list of N variables> )
// | UVMC_PRINT_EXT_<N> (TYPE, BASE, <list of N variables> )
//
// For the second form, the generated output stream operator will stream
// the contents of the provided ~BASE~ class before streaming those of
// ~TYPE~.
//
// Invoke the macro whose numeric suffix equals the number of field members you
// wish to include in the pack, unpack, and print operations. These must all
// appear in the list of macro arguments in the order you want them streamed.
//
// Example:
//
// | UVMC_PRINT_3( bus_trans, cmd, addr, data)
// | UVMC_PRINT_EXT_1 (bus_error, bus_trans, crc)
//
// The first macro generates an ~operator<<~ for the ~bus_trans~
// class. Three member variables of ~bus_trans~ are included in the 
// output stream operation, in the order given: cmd, addr, and data.
// If there were other members in ~bus_trans~, they will not be included
// in the ~operator<<~ implementations.
//
// The second macro generates an ~operator<<~ for the ~bus_error~
// class. Output streaming for the base type, ~bus_trans~
// is performed first, followed by the ~crc~ field in ~bus_error~.
//
// The macros above generate the following code
//
//| template <>
//| class uvmc_print<bus_trans> {
//|   public:
//|   static void do_print(const bus_trans& t, ostream& os=cout) {
//|     os << hex << "cmd"  ":" << t.cmd << " " 
//|                  "addr" ":" << t.addr << " "
//|                  "data" ":" << t.data << dec; 
//|   }
//|   static void print(const bus_trans& t, ostream& os=cout) {
//|     os << "'{";
//|     do_print(t,os);
//|     os << " }";
//|   }
//| };
//| ostream& operator << (ostream& os, const bus_trans& v) {
//|   uvmc_print<bus_trans>::print(v,os);
//| }
//
//| template <>
//| class uvmc_print<bus_error> {
//|   public:
//|   static void do_print(const bus_error& t, ostream& os=cout) {
//|     uvmc_print<bus_trans>::do_print(t,os);
//|     os << " ";
//|     os << hex << "crc" ":" << t.cmd << " " 
//|   }
//|   static void print(const bus_error& t, ostream& os=cout) {
//|     os << "'{";
//|     do_print(t,os);
//|     os << " }";
//|   }
//| };
//| ostream& operator << (ostream& os, const bus_error& v) {
//|   uvmc_print<bus_error>::print(v,os);
//| }
//
// Usage notes:
//
//  - All class members given in the list must be public members
//
//  - An ~operator<<(ostream)~ must be defined for each class member type listed.
//    This is true for integral, string, and SystemC data types. UVMC also
//    defines ~operator<<(ostream&)~ for STL ~vector<T>~, ~map<KEY,T>~,
//    and ~list<T>~ types.
//
//  - The macros support up to 20 member variables, i.e. ~UVM_UTILS_20~ and
//    ~UVM_UTILS_EXT_20~.
//
// Before using these macros, be sure the ~#include~ the appropriate headers
// that define ~ostream~ and other I/O utilities.
//
//    | #include <iostream>
//    | #include <iomanp>
//
//------------------------------------------------------------------------------

#define UVMC_PRINT_1(TYPE,V1) \
  UVMC_PRINT_CLASS(TYPE,\
    os << hex <<      #V1 ":" <<  t.V1 << dec; ) 

#define UVMC_PRINT_2(TYPE,V1,V2) \
  UVMC_PRINT_CLASS(TYPE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << dec; ) 

#define UVMC_PRINT_3(TYPE,V1,V2,V3) \
  UVMC_PRINT_CLASS(TYPE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << dec; ) 

#define UVMC_PRINT_4(TYPE,V1,V2,V3,V4) \
  UVMC_PRINT_CLASS(TYPE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << dec; ) 

#define UVMC_PRINT_5(TYPE,V1,V2,V3,V4,V5) \
  UVMC_PRINT_CLASS(TYPE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 << dec; ) 

#define UVMC_PRINT_6(TYPE,V1,V2,V3,V4,V5,V6) \
  UVMC_PRINT_CLASS(TYPE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << dec; ) 

#define UVMC_PRINT_7(TYPE,V1,V2,V3,V4,V5,V6,V7) \
  UVMC_PRINT_CLASS(TYPE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << dec; ) 

#define UVMC_PRINT_8(TYPE,V1,V2,V3,V4,V5,V6,V7,V8) \
  UVMC_PRINT_CLASS(TYPE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << dec; ) 

#define UVMC_PRINT_9(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9) \
  UVMC_PRINT_CLASS(TYPE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << dec; ) 

#define UVMC_PRINT_10(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10) \
  UVMC_PRINT_CLASS(TYPE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 << dec; ) 

#define UVMC_PRINT_11(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11) \
  UVMC_PRINT_CLASS(TYPE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 \
              << " " #V11 ":" << t.V11 << dec; ) 

#define UVMC_PRINT_12(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12) \
  UVMC_PRINT_CLASS(TYPE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 \
              << " " #V11 ":" << t.V11 << " " #V12 ":" << t.V12 << dec; ) 

#define UVMC_PRINT_13(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13) \
  UVMC_PRINT_CLASS(TYPE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 \
              << " " #V11 ":" << t.V11 << " " #V12 ":" << t.V12 << " " #V13 ":" << t.V13 << dec; ) 

#define UVMC_PRINT_14(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14) \
  UVMC_PRINT_CLASS(TYPE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 \
              << " " #V11 ":" << t.V11 << " " #V12 ":" << t.V12 << " " #V13 ":" << t.V13 << " " #V14 ":" << t.V14 << dec; ) 

#define UVMC_PRINT_15(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15) \
  UVMC_PRINT_CLASS(TYPE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 \
              << " " #V11 ":" << t.V11 << " " #V12 ":" << t.V12 << " " #V13 ":" << t.V13 << " " #V14 ":" << t.V14 << " " #V15 ":" << t.V15 << dec; ) 

#define UVMC_PRINT_16(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16) \
  UVMC_PRINT_CLASS(TYPE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 \
              << " " #V11 ":" << t.V11 << " " #V12 ":" << t.V12 << " " #V13 ":" << t.V13 << " " #V14 ":" << t.V14 << " " #V15 ":" << t.V15 \
              << " " #V16 ":" << t.V16 << dec; ) 

#define UVMC_PRINT_17(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17) \
  UVMC_PRINT_CLASS(TYPE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 \
              << " " #V11 ":" << t.V11 << " " #V12 ":" << t.V12 << " " #V13 ":" << t.V13 << " " #V14 ":" << t.V14 << " " #V15 ":" << t.V15 \
              << " " #V16 ":" << t.V16 << " " #V17 ":" << t.V17 << dec; ) 

#define UVMC_PRINT_18(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18) \
  UVMC_PRINT_CLASS(TYPE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 \
              << " " #V11 ":" << t.V11 << " " #V12 ":" << t.V12 << " " #V13 ":" << t.V13 << " " #V14 ":" << t.V14 << " " #V15 ":" << t.V15 \
              << " " #V16 ":" << t.V16 << " " #V17 ":" << t.V17 << " " #V18 ":" << t.V18 << dec; ) 

#define UVMC_PRINT_19(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19) \
  UVMC_PRINT_CLASS(TYPE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 \
              << " " #V11 ":" << t.V11 << " " #V12 ":" << t.V12 << " " #V13 ":" << t.V13 << " " #V14 ":" << t.V14 << " " #V15 ":" << t.V15 \
              << " " #V16 ":" << t.V16 << " " #V17 ":" << t.V17 << " " #V18 ":" << t.V18 << " " #V19 ":" << t.V19 << dec; ) 

#define UVMC_PRINT_20(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19,V20) \
  UVMC_PRINT_CLASS(TYPE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 \
              << " " #V11 ":" << t.V11 << " " #V12 ":" << t.V12 << " " #V13 ":" << t.V13 << " " #V14 ":" << t.V14 << " " #V15 ":" << t.V15 \
              << " " #V16 ":" << t.V16 << " " #V17 ":" << t.V17 << " " #V18 ":" << t.V18 << " " #V19 ":" << t.V19 << " " #V20 ":" << t.V20 << dec; ) 


#define UVMC_PRINT_EXT_1(TYPE,BASE,V1) \
  UVMC_PRINT_CLASS_EXT(TYPE,BASE,\
    os << hex <<      #V1 ":" <<  t.V1 << dec; ) 

#define UVMC_PRINT_EXT_2(TYPE,BASE,V1,V2) \
  UVMC_PRINT_CLASS_EXT(TYPE,BASE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << dec; ) 

#define UVMC_PRINT_EXT_3(TYPE,BASE,V1,V2,V3) \
  UVMC_PRINT_CLASS_EXT(TYPE,BASE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << dec; ) 

#define UVMC_PRINT_EXT_4(TYPE,BASE,V1,V2,V3,V4) \
  UVMC_PRINT_CLASS_EXT(TYPE,BASE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << dec; ) 

#define UVMC_PRINT_EXT_5(TYPE,BASE,V1,V2,V3,V4,V5) \
  UVMC_PRINT_CLASS_EXT(TYPE,BASE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 << dec; ) 

#define UVMC_PRINT_EXT_6(TYPE,BASE,V1,V2,V3,V4,V5,V6) \
  UVMC_PRINT_CLASS_EXT(TYPE,BASE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << dec; ) 

#define UVMC_PRINT_EXT_7(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7) \
  UVMC_PRINT_CLASS_EXT(TYPE,BASE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << dec; ) 

#define UVMC_PRINT_EXT_8(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8) \
  UVMC_PRINT_CLASS_EXT(TYPE,BASE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << dec; ) 

#define UVMC_PRINT_EXT_9(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9) \
  UVMC_PRINT_CLASS_EXT(TYPE,BASE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << dec; ) 

#define UVMC_PRINT_EXT_10(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10) \
  UVMC_PRINT_CLASS_EXT(TYPE,BASE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 << dec; ) 

#define UVMC_PRINT_EXT_11(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11) \
  UVMC_PRINT_CLASS_EXT(TYPE,BASE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 \
              << " " #V11 ":" << t.V11 << dec; ) 

#define UVMC_PRINT_EXT_12(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12) \
  UVMC_PRINT_CLASS_EXT(TYPE,BASE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 \
              << " " #V11 ":" << t.V11 << " " #V12 ":" << t.V12 << dec; ) 

#define UVMC_PRINT_EXT_13(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13) \
  UVMC_PRINT_CLASS_EXT(TYPE,BASE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 \
              << " " #V11 ":" << t.V11 << " " #V12 ":" << t.V12 << " " #V13 ":" << t.V13 << dec; ) 

#define UVMC_PRINT_EXT_14(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14) \
  UVMC_PRINT_CLASS_EXT(TYPE,BASE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 \
              << " " #V11 ":" << t.V11 << " " #V12 ":" << t.V12 << " " #V13 ":" << t.V13 << " " #V14 ":" << t.V14 << dec; ) 

#define UVMC_PRINT_EXT_15(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15) \
  UVMC_PRINT_CLASS_EXT(TYPE,BASE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 \
              << " " #V11 ":" << t.V11 << " " #V12 ":" << t.V12 << " " #V13 ":" << t.V13 << " " #V14 ":" << t.V14 << " " #V15 ":" << t.V15 << dec; ) 

#define UVMC_PRINT_EXT_16(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16) \
  UVMC_PRINT_CLASS_EXT(TYPE,BASE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 \
              << " " #V11 ":" << t.V11 << " " #V12 ":" << t.V12 << " " #V13 ":" << t.V13 << " " #V14 ":" << t.V14 << " " #V15 ":" << t.V15 \
              << " " #V16 ":" << t.V16 << dec; ) 

#define UVMC_PRINT_EXT_17(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17) \
  UVMC_PRINT_CLASS_EXT(TYPE,BASE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 \
              << " " #V11 ":" << t.V11 << " " #V12 ":" << t.V12 << " " #V13 ":" << t.V13 << " " #V14 ":" << t.V14 << " " #V15 ":" << t.V15 \
              << " " #V16 ":" << t.V16 << " " #V17 ":" << t.V17 << dec; ) 

#define UVMC_PRINT_EXT_18(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18) \
  UVMC_PRINT_CLASS_EXT(TYPE,BASE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 \
              << " " #V11 ":" << t.V11 << " " #V12 ":" << t.V12 << " " #V13 ":" << t.V13 << " " #V14 ":" << t.V14 << " " #V15 ":" << t.V15 \
              << " " #V16 ":" << t.V16 << " " #V17 ":" << t.V17 << " " #V18 ":" << t.V18 << dec; ) 

#define UVMC_PRINT_EXT_19(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19) \
  UVMC_PRINT_CLASS_EXT(TYPE,BASE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 \
              << " " #V11 ":" << t.V11 << " " #V12 ":" << t.V12 << " " #V13 ":" << t.V13 << " " #V14 ":" << t.V14 << " " #V15 ":" << t.V15 \
              << " " #V16 ":" << t.V16 << " " #V17 ":" << t.V17 << " " #V18 ":" << t.V18 << " " #V19 ":" << t.V19 << dec; ) 

#define UVMC_PRINT_EXT_20(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19,V20) \
  UVMC_PRINT_CLASS_EXT(TYPE,BASE,\
    os << hex <<      #V1 ":" <<  t.V1 << " "  #V2 ":" <<  t.V2 << " "  #V3 ":" <<  t.V3 << " "  #V4 ":" <<  t.V4 << " "  #V5 ":" <<  t.V5 \
              << " "  #V6 ":" <<  t.V6 << " "  #V7 ":" <<  t.V7 << " "  #V8 ":" <<  t.V8 << " "  #V9 ":" <<  t.V9 << " " #V10 ":" << t.V10 \
              << " " #V11 ":" << t.V11 << " " #V12 ":" << t.V12 << " " #V13 ":" << t.V13 << " " #V14 ":" << t.V14 << " " #V15 ":" << t.V15 \
              << " " #V16 ":" << t.V16 << " " #V17 ":" << t.V17 << " " #V18 ":" << t.V18 << " " #V19 ":" << t.V19 << " " #V20 ":" << t.V20 << dec; ) 




//------------------------------------------------------------------------------
// Topic: UVMC_UTILS
//
// Generate both a converter specialization and output stream ~operator<<~ for
// the given transaction ~TYPE~.
//
// | UVMC_UTILS_<N> (TYPE, <list of N variables> )
// | UVMC_UTILS_EXT_<N> (TYPE, BASE, <list of N variables> )
//
// For the second form, the generated converter and output stream operator
// will perform the operation in ~BASE~ before doing the same in ~TYPE~.
//
// Invoke the macro whose numeric suffix equals the number of field members
// you wish to include in the pack, unpack, and print operations.
//
// The ~UVMC_UTILS~ macro simply calls the corresponding ~UVMC_CONVERT~ and
// ~UVMC_PRINT~ macros. See <UVMC_CONVERT> and <UVMC_PRINT> for detailed
// usage information.
//
// Example:
//
// | UVMC_UTILS_3( bus_trans, cmd, addr, data)
// | UVMC_UTILS_EXT_1 (bus_error, bus_trans, crc)
//
// The first macro generates converter and output stream implementions for
// ~bus_trans~. Three member variables are included in the pack, unpack,
// and output stream operations, in the order given: ~cmd~, ~addr~, and ~data~.
// If there were other members in ~bus_trans~, they will not be included
// in the converter or ~operator<<~ implementations.
//
// The second macro generates a converter and ~operator<<~ for the ~bus_error~
// class. Packing, unpacking, and output streaming for the base type, ~bus_trans~
// is performed first, followed by the ~crc~ field in ~bus_error~.
//
// The code that these macros expand into are provided in the descriptions
// of <UVMC_CONVERT> and <UVMC_PRINT>.
//------------------------------------------------------------------------------


#define UVMC_UTILS_1(TYPE,V1) \
  UVMC_CONVERT_1(TYPE,V1)\
  UVMC_PRINT_1  (TYPE,V1)

#define UVMC_UTILS_2(TYPE,V1,V2) \
  UVMC_CONVERT_2(TYPE,V1,V2)\
  UVMC_PRINT_2  (TYPE,V1,V2)

#define UVMC_UTILS_3(TYPE,V1,V2,V3) \
  UVMC_CONVERT_3(TYPE,V1,V2,V3)\
  UVMC_PRINT_3  (TYPE,V1,V2,V3)

#define UVMC_UTILS_4(TYPE,V1,V2,V3,V4) \
  UVMC_CONVERT_4(TYPE,V1,V2,V3,V4)\
  UVMC_PRINT_4  (TYPE,V1,V2,V3,V4)

#define UVMC_UTILS_5(TYPE,V1,V2,V3,V4,V5) \
  UVMC_CONVERT_5(TYPE,V1,V2,V3,V4,V5)\
  UVMC_PRINT_5  (TYPE,V1,V2,V3,V4,V5)

#define UVMC_UTILS_6(TYPE,V1,V2,V3,V4,V5,V6) \
  UVMC_CONVERT_6(TYPE,V1,V2,V3,V4,V5,V6)\
  UVMC_PRINT_6  (TYPE,V1,V2,V3,V4,V5,V6)

#define UVMC_UTILS_7(TYPE,V1,V2,V3,V4,V5,V6,V7) \
  UVMC_CONVERT_7(TYPE,V1,V2,V3,V4,V5,V6,V7)\
  UVMC_PRINT_7  (TYPE,V1,V2,V3,V4,V5,V6,V7)

#define UVMC_UTILS_8(TYPE,V1,V2,V3,V4,V5,V6,V7,V8) \
  UVMC_CONVERT_8(TYPE,V1,V2,V3,V4,V5,V6,V7,V8)\
  UVMC_PRINT_8  (TYPE,V1,V2,V3,V4,V5,V6,V7,V8)

#define UVMC_UTILS_9(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9) \
  UVMC_CONVERT_9(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9)\
  UVMC_PRINT_9  (TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9)

#define UVMC_UTILS_10(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10) \
  UVMC_CONVERT_10(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10)\
  UVMC_PRINT_10  (TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10)

#define UVMC_UTILS_11(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11) \
  UVMC_CONVERT_11(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11)\
  UVMC_PRINT_11  (TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11)

#define UVMC_UTILS_12(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12) \
  UVMC_CONVERT_12(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12)\
  UVMC_PRINT_12  (TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12)

#define UVMC_UTILS_13(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13) \
  UVMC_CONVERT_13(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13)\
  UVMC_PRINT_13  (TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13)

#define UVMC_UTILS_14(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14) \
  UVMC_CONVERT_14(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14)\
  UVMC_PRINT_14  (TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14)

#define UVMC_UTILS_15(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15) \
  UVMC_CONVERT_15(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15)\
  UVMC_PRINT_15  (TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15)

#define UVMC_UTILS_16(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16) \
  UVMC_CONVERT_16(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16)\
  UVMC_PRINT_16  (TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16)

#define UVMC_UTILS_17(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17) \
  UVMC_CONVERT_17(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17)\
  UVMC_PRINT_17  (TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17)

#define UVMC_UTILS_18(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18) \
  UVMC_CONVERT_18(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18)\
  UVMC_PRINT_18  (TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18)

#define UVMC_UTILS_19(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19) \
  UVMC_CONVERT_19(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19)\
  UVMC_PRINT_19  (TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19)

#define UVMC_UTILS_20(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19,V20) \
  UVMC_CONVERT_20(TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19,V20)\
  UVMC_PRINT_20  (TYPE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19,V20)



#define UVMC_UTILS_EXT_1(TYPE,BASE,V1) \
  UVMC_CONVERT_EXT_1(TYPE,BASE,V1)\
  UVMC_PRINT_EXT_1  (TYPE,BASE,V1)

#define UVMC_UTILS_EXT_2(TYPE,BASE,V1,V2) \
  UVMC_CONVERT_EXT_2(TYPE,BASE,V1,V2)\
  UVMC_PRINT_EXT_2  (TYPE,BASE,V1,V2)

#define UVMC_UTILS_EXT_3(TYPE,BASE,V1,V2,V3) \
  UVMC_CONVERT_EXT_3(TYPE,BASE,V1,V2,V3)\
  UVMC_PRINT_EXT_3  (TYPE,BASE,V1,V2,V3)

#define UVMC_UTILS_EXT_4(TYPE,BASE,V1,V2,V3,V4) \
  UVMC_CONVERT_EXT_4(TYPE,BASE,V1,V2,V3,V4)\
  UVMC_PRINT_EXT_4  (TYPE,BASE,V1,V2,V3,V4)

#define UVMC_UTILS_EXT_5(TYPE,BASE,V1,V2,V3,V4,V5) \
  UVMC_CONVERT_EXT_5(TYPE,BASE,V1,V2,V3,V4,V5)\
  UVMC_PRINT_EXT_5  (TYPE,BASE,V1,V2,V3,V4,V5)

#define UVMC_UTILS_EXT_6(TYPE,BASE,V1,V2,V3,V4,V5,V6) \
  UVMC_CONVERT_EXT_6(TYPE,BASE,V1,V2,V3,V4,V5,V6)\
  UVMC_PRINT_EXT_6  (TYPE,BASE,V1,V2,V3,V4,V5,V6)

#define UVMC_UTILS_EXT_7(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7) \
  UVMC_CONVERT_EXT_7(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7)\
  UVMC_PRINT_EXT_7  (TYPE,BASE,V1,V2,V3,V4,V5,V6,V7)

#define UVMC_UTILS_EXT_8(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8) \
  UVMC_CONVERT_EXT_8(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8)\
  UVMC_PRINT_EXT_8  (TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8)

#define UVMC_UTILS_EXT_9(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9) \
  UVMC_CONVERT_EXT_9(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9)\
  UVMC_PRINT_EXT_9  (TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9)

#define UVMC_UTILS_EXT_10(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10) \
  UVMC_CONVERT_EXT_10(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10)\
  UVMC_PRINT_EXT_10  (TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10)

#define UVMC_UTILS_EXT_11(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11) \
  UVMC_CONVERT_EXT_11(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11)\
  UVMC_PRINT_EXT_11  (TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11)

#define UVMC_UTILS_EXT_12(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12) \
  UVMC_CONVERT_EXT_12(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12)\
  UVMC_PRINT_EXT_12  (TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12)

#define UVMC_UTILS_EXT_13(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13) \
  UVMC_CONVERT_EXT_13(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13)\
  UVMC_PRINT_EXT_13  (TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13)

#define UVMC_UTILS_EXT_14(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14) \
  UVMC_CONVERT_EXT_14(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14)\
  UVMC_PRINT_EXT_14  (TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14)

#define UVMC_UTILS_EXT_15(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15) \
  UVMC_CONVERT_EXT_15(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15)\
  UVMC_PRINT_EXT_15  (TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15)

#define UVMC_UTILS_EXT_16(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16) \
  UVMC_CONVERT_EXT_16(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16)\
  UVMC_PRINT_EXT_16  (TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16)

#define UVMC_UTILS_EXT_17(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17) \
  UVMC_CONVERT_EXT_17(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17)\
  UVMC_PRINT_EXT_17  (TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17)

#define UVMC_UTILS_EXT_18(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18) \
  UVMC_CONVERT_EXT_18(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18)\
  UVMC_PRINT_EXT_18  (TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18)

#define UVMC_UTILS_EXT_19(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19) \
  UVMC_CONVERT_EXT_19(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19)\
  UVMC_PRINT_EXT_19  (TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19)

#define UVMC_UTILS_EXT_20(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19,V20) \
  UVMC_CONVERT_EXT_20(TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19,V20)\
  UVMC_PRINT_EXT_20  (TYPE,BASE,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19,V20)



#endif
