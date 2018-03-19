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

#include "packet.h"


//-----------------------------------------------------------------------------
// Title: SC Producer
//
// Topic: Description
//
// A generic producer that creates ~packet~ transactions and sends
// them out its ~out~ port and ~ap~ analysis ports.
//
// While trivial in functionality, the model demonstrates use of TLM ports
// to facilitate external communication. 
//
// - Users of the model are not coupled to its internal implementation, using
//   only the public TLM ports to communicate.
//
// - The model itself does not refer to anything outside its
//   implementation. It does not know nor care about who is receiving
//   transactions from its ~out~ port or who might be listening on its ~ap~
//   analysis port.
//-----------------------------------------------------------------------------

// (inline source)
class producer : public sc_module {
  public:
  sc_port<tlm_blocking_put_if<packet> > out;
  tlm_analysis_port<packet> ap;

  int num_trans;
  sc_event done;

  producer(sc_module_name nm) : out("out"),
                                ap("ap"),
                                num_trans(2) {
    SC_THREAD(run);
  }

  SC_HAS_PROCESS(producer);

  virtual void run() {
    packet pkt; 

    while (num_trans--) {

      pkt.cmd = 1; // write
      pkt.addr = rand();

      int d_size;

      d_size = (rand() % 8) + 1; // between 1 and 8

      for (int i=0; i < d_size; i++) {
        pkt.data.push_back(rand());
      }

      cout << sc_time_stamp() << " [PRODUCER/PKT/SEND] " << pkt << endl;

      out->put(pkt);

      ap.write(pkt);
    }

    cout << sc_time_stamp() << " [PRODUCER/ENDING] " << "Ending test" << endl;

    done.notify();
  }
};
#endif

