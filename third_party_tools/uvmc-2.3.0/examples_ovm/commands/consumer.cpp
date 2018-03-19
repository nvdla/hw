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

//---------------------------------------------------------------------
// Title: SC Consumer
//
// Topic: Description
// A generic consumer that receives and processes transactions coming
// from its blocking-transport ~in~ export. It performs no meaningful
// functionality--it prints the transaction, waits the specified delay,
// then sends it out its analysis port.
//---------------------------------------------------------------------

// (inline source)
#include "systemc.h"
#include "tlm.h"
#include <iostream>

#include "packet.cpp"

using namespace std;
using namespace sc_core;
using namespace tlm;

class consumer : public sc_module,
                 public tlm_blocking_put_if<packet> {

  public:
  sc_export<tlm_blocking_put_if<packet> > in;
  tlm_analysis_port<packet> ap;

  consumer(sc_module_name nm) : in("in"),
                                ap("ap")
  {
    in(*this);
  }

  virtual void put (const packet& t) {
    cout << sc_time_stamp() << " SC consumer executing packet:"
       << endl << "  " << t << endl;
    wait(10,SC_NS);
    ap.write(t);
  }
};


