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
// Title: SC Consumer
//
// Topic: Description
//
// A simple SC consumer TLM model that prints received transactions (of type
// ~packet~ and sends them out its ~ap~ analysis port.
//
// This example uses the ~tlm_blocking_put_if~ interface.
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

#include "packet.h"

class consumer : public sc_module,
                 public tlm_blocking_put_if<packet>
{

  public:
  sc_export<tlm_blocking_put_if<packet> > in;
  tlm_analysis_port<packet> ap;

  consumer(sc_module_name nm) : in("in"), ap("ap")
  {
    in.bind(*this);
  }

  virtual void put(const packet &pkt) {
    char unsigned *data;
    int len;
    len = pkt.data.size();
    cout << sc_time_stamp() << " [CONSUMER/PKT/RECV] " << pkt << endl;
    wait(10,SC_NS);
    ap.write(pkt);
  }
};
