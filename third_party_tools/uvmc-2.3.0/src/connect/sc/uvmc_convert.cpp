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

#include "uvmc_convert.h"

#ifndef UVMC_NO_COUT_CHAR
ostream& operator << (ostream& os, const char& v) {
  os << (int)v;
  return os;
}

ostream& operator << (ostream& os, const unsigned char& v) {
  os << (int unsigned)v;
  return os;
}

ostream& operator << (ostream& os, char& v) {
  os << (int)v;
  return os;
}

ostream& operator << (ostream& os, unsigned char& v) {
  os << (int unsigned)v;
  return os;
}


/*
ostream& operator << (ostream& os, string& v) {
  os << (int unsigned)v;
  return os;
}
ostream& operator << (ostream& os, const string& v) {
  os << (int)v;
  return os;
}
*/

#endif

#ifndef UVMC_NO_COUT_TLM_GP
ostream& operator << (ostream& os, const tlm_generic_payload & t) {
  return uvmc_print<tlm_generic_payload>::print(t,os);
}
#endif

