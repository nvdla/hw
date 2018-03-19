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

#include "systemc.h"
#include "tlm.h"

using namespace sc_core;
using namespace tlm;

//-----------------------------------------------------------------------------
// Title: UVMC Connection Example - Hierarchical Connection, SC side
//
// This example illustrates how to make hierarchical UVMC connections, i.e. how
// to promote a ~port~, ~export~, ~imp~, or ~socket~ from a child component to
// a parent that resides in the other language. In effect, we are using a
// component written in SV as the implementation for a component in SC.
// See <UVMC Connection Example - Hierarchical Connection, SV side> to see 
// the SC portion of the example.
//
// (see UVMC_Connections_SCwrapsSV.png)
//
// By hiding the SV implementation, we create what appears to be a pure SC-based
// testbench, just like the <UVMC Connection Example - Native SC to SC>.
// However, the SC producer is implemented in SV and uses UVMC to make a
// behind-the-scenes connection. 
//
// This example illustates good programming principles by exposing only standard
// TLM interfaces to the user. The implementation of those interfaces is hidden
// and therefore can change (or be implemented in another language) without
// affecting end user code. 
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Class: producer
//
// Our ~producer~ module is merely a wrapper around an SV-side implementation,
// but users of this producer will not be aware of that. The producer does not
// actually instantiate a SV component. It simply promotes the socket in the 
// SV producer to a corresponding socket in the SC producer. From the outside,
// the SC producer appears as an ordinary SC component with a TLM2 socket as
// its public interface.
//-----------------------------------------------------------------------------

//(begin inline source)
#include "uvmc.h"
using namespace uvmc;

#include "packet.h"

class producer: public sc_module
{
  public:
  sc_port<tlm_blocking_put_if<packet> > out;

  SC_CTOR(producer) : out("out") {
    uvmc_connect_hier(out,"sv_out");
  }
};
//(end inline source)


//-----------------------------------------------------------------------------
// Group: sc_main
//
// The ~sv_main~ top-level module below creates and starts the SV portion of this
// example. It instantiates our "pure" SC producer and consumer, binds their
// sockets to complete the local connection, then starts SC simulation.
//
// Notice that the code is identical to that used in the 
// <UVMC Connection Example - Native SC to SC> example. From the SC user's
// perspective, there is no difference between the two testbenches. We've
// hidden the UVMC implementation details from the user.
//-----------------------------------------------------------------------------

//(begin inline source)
#include "consumer.h"

int sc_main(int argc, char* argv[]) 
{
  producer prod("prod");
  consumer cons("cons");

  prod.out.bind(cons.in);

  sc_start(-1);
  return 0;
};
//(end inline source)
