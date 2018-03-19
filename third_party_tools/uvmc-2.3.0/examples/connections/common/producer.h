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

#ifndef PRODUCER_H
#define PRODUCER_H

#include <string>
#include <iomanip>
//#include <stdlib>
using std::string;

#include <systemc.h>
#include <tlm.h>
using namespace sc_core;
using namespace tlm;

#include "simple_initiator_socket.h"
using tlm_utils::simple_initiator_socket;


//-----------------------------------------------------------------------------
// Title: UVMC Connection Common Code - SC Producer
//
// Topic: Description
//
// A generic producer that creates ~tlm_generic_payload~ transactions and sends
// them out its ~out~ socket and ~ap~ analysis ports.
//
// This example uses the ~simple_initiator_socket~, a derivative of the TLM
// core class, ~tlm_initiator_socket~.  Unlike the ~tlm_initiator_socket~, the
// simple socket does not require the module to inherit and implement the
// initiator socket interface methods.  Instead, you only need to register
// the interfaces you actually implement, none in this example. This is
// what makes these sockets simple, flexible, and convenient.
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
class producer : public sc_module {
  public:
  simple_initiator_socket<producer> out; // uses tlm_gp
  tlm_analysis_port<tlm_generic_payload> ap;

  int num_trans;
  sc_event done;

  producer(sc_module_name nm) : out("out"),
                                ap("ap"),
                                num_trans(2) {
    SC_THREAD(run);
  }

  SC_HAS_PROCESS(producer);

  void run() {
    tlm_generic_payload gp; 
    char unsigned data[8];
    gp.set_data_ptr(data);
    sc_time delay;

    while (num_trans--) {

      gp.set_command(TLM_WRITE_COMMAND);
      gp.set_address(rand());
      delay = sc_time(10,SC_NS);

      int d_size;

      d_size = (rand() % 8) + 1; // between 1 and 8

      gp.set_data_length(d_size);

      for (int i=0; i < d_size; i++) {
        data[i] = rand();
      }

      cout << sc_time_stamp()
           << " [PRODUCER/GP/SEND] "
           << "cmd:" << gp.get_command()
           << " addr:" << hex << gp.get_address() << " data:{ ";

      for (int i=0;i<gp.get_data_length();i++)
        cout << hex << (int)(data[i]) << " ";

      cout << "}" << endl;

      out->b_transport(gp,delay);

      ap.write(gp);
    }

    cout << sc_time_stamp()
         << " [PRODUCER/ENDING] "
         << "Ending test" << endl;
    done.notify();
  }
};
#endif

