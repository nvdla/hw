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

//-----------------------------------------------------------------------------
// Title: UVMC Connection Common Code - SC Consumer
//
// Topic: Description
//
// A simple SC consumer TLM model that prints received transactions (of type
// ~tlm_generic_payload~ and sends them out its ~ap~ analysis port.
//
// This example uses the ~simple_target_socket~, a derivative of the TLM
// core class, ~tlm_target_socket~.  Unlike the ~tlm_target_socket~, the simple
// socket does not require the module to inherit and implement all four
// target socket interface methods. Instead, you only need to register the
// interfaces you actually implement, ~b_transport~ in this case. This is what
// makes these sockets simple, flexible, and convenient.
//
// While trivial in functionality, the model demonstrates use of TLM ports
// to facilitate external communication. 
//
// - Users of the model are not coupled to its internal implementation, using
//   only the provided TLM port and socket to communicate.
//
// - The model itself does not refer to anything outside its encapsulated
//   implementation. It does not know nor care about what might
//   be driving its ~in~ socket or who might be listening on its ~ap~
//   analysis port.
//-----------------------------------------------------------------------------

// (inline source)
#include <string>
#include <iomanip>
using std::string;

#include <systemc.h>
#include <tlm.h>
using namespace sc_core;
using namespace tlm;

#include "simple_target_socket.h"
using tlm_utils::simple_target_socket;


class consumer : public sc_module
{

  public:
  simple_target_socket<consumer> in; // defaults to tlm_gp
  tlm_analysis_port<tlm_generic_payload> ap;

  consumer(sc_module_name nm) : in("in"), ap("ap")
  {
    in.register_b_transport(this, &consumer::b_transport);
  }

  virtual void b_transport(tlm_generic_payload &gp, sc_time &t) {
    char unsigned *data;
    int len;
    len = gp.get_data_length();
    data = gp.get_data_ptr();
    cout << sc_time_stamp() << " [CONSUMER/GP/RECV] ";
    cout << "cmd:" << gp.get_command()
         << " addr:" << hex << gp.get_address() << " data:{ ";
    for (int i=0; i<len; i++)
      cout << hex << (int)*(data+i) << " ";
    cout << "}" << endl;
    wait(t);
    t = SC_ZERO_TIME;
    ap.write(gp);
  }
};
