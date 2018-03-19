//============================================================================
// @(#) $Id: producer_loopback.h 1379 2015-02-17 00:13:20Z jstickle $
//============================================================================

   //_______________________
  // Mentor Graphics, Corp. \_________________________________________________
 //                                                                         //
//   (C) Copyright, Mentor Graphics, Corp. 2003-2014                        //
//   All Rights Reserved                                                    //
//                                                                          //
//    Licensed under the Apache License, Version 2.0 (the                   //
//    "License"); you may not use this file except in                       //
//    compliance with the License.  You may obtain a copy of                //
//    the License at                                                        //
//                                                                          //
//        http://www.apache.org/licenses/LICENSE-2.0                        //
//                                                                          //
//    Unless required by applicable law or agreed to in                     //
//    writing, software distributed under the License is                    //
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR                //
//    CONDITIONS OF ANY KIND, either express or implied.  See               //
//    the License for the specific language governing                      //
//    permissions and limitations under the License.                      //
//-----------------------------------------------------------------------//

#ifndef PRODUCER_LOOPBACK_H
#define PRODUCER_LOOPBACK_H

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

#include "simple_target_socket.h"
using tlm_utils::simple_target_socket;

//-----------------------------------------------------------------------------
// Title: SC Producer
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

// We want to benchmark the transfer of 80 2MB "HD-image" payloads.
// With true generic payloads, we can represent each image as a single
// GP transaction. However, because the default UVM packer based
// implementation limits the entire payload to 4KBytes (see default value
// of `UVM_PACKER_MAX_BYTES for UVM packers) we must break the image down
// into a series of small payload fragments. Each fragment must fit in a
// maximally sized generic payload as supported by UVMC. This means, address,
// command, status, byte enables, lengths, and the payload data itself must
// all fit in the 4KB payload.
//
// So, the tests below that use default UVMC packers (see
// tests ~sc2sv2sc_loopback~ and ~sv2sc2sv_loopback~) need the actual data
// payloads themselves to fit in 2KByte fragments which would leave ample
// room for the rest of the fixed sized data fields (address, command, byte
// enables, etc) of the TLM GP to fit in the remaining 2KB of the payload.
//
// So with this in mind we can fragment our 80 2MB HD-image's as,
//
//   80 x 2 x 1024   x 1024 bytes
// = 80 x 2 x 1024/2 x 2048 bytes
// = 80 x 2 x 512            2048 byte payloads
// = 81920                   2048 byte payloads
//
//   i.e. NUM_TRANSACTIONS = 81920, PAYLOAD_NUM_BYTES = 2048
//
// Now with the improved packer, in addition to getting better
// trans-language performance, there is no limit on payload size.
// In fact, there is no need for a globally defined static maximum byte stream
// size at all.
//
// Having a statically specified global maximum of any kind always begs
// the "how big is big enough ?" question. And so in many accelerated
// applications we try to avoid statically specified maximum payload sizes
// entirely on the HVL side of the link.
//
// So without this limitation, we can restructure the test as,
//
//   80 x 2MB payloads
//
//   i.e. NUM_TRANSACTIONS = 80, PAYLOAD_NUM_BYTES = 2 * 1024 * 1024 = 2 MB

#ifndef NUM_TRANSACTIONS
#define NUM_TRANSACTIONS 81920
#endif

#ifndef PAYLOAD_NUM_BYTES
#define PAYLOAD_NUM_BYTES 2048
#endif

// (inline source)
class producer : public sc_module {
  public:
  simple_initiator_socket<producer> out; // uses tlm_gp
  simple_target_socket<producer> in; // defaults to tlm_gp

  int num_trans;
  sc_event done;

  unsigned long long expected_checksum, actual_checksum;

  producer(sc_module_name nm) : out("out"), in("in"),
                                num_trans(NUM_TRANSACTIONS),
                                expected_checksum(0LL),
                                actual_checksum(0LL) {
    SC_THREAD(run);
    in.register_b_transport(this, &producer::b_transport);
  }

  SC_HAS_PROCESS(producer);

  void run() {
    tlm_generic_payload gp; 
    unsigned char *data = new unsigned char [PAYLOAD_NUM_BYTES];
    sc_time delay;

    sc_dt::uint64 address = 0x40000000;

    gp.set_command(TLM_WRITE_COMMAND);
    gp.set_data_length( PAYLOAD_NUM_BYTES );

    cout << sc_time_stamp()
         << " [PRODUCER/GP/SEND]"
         << " cmd: " << gp.get_command()
         << " addr:" << hex << gp.get_address()
         << " PAYLOAD_NUM_BYTES:" << dec << gp.get_data_length()
         << " NUM_TRANSACTIONS:" << dec << NUM_TRANSACTIONS
         << endl;

    unsigned offset = 0;
    while (num_trans--) {
      gp.set_address( address );
      gp.set_response_status( tlm::TLM_INCOMPLETE_RESPONSE );

      for( unsigned i=0; i<PAYLOAD_NUM_BYTES; i++ ) {
        data[i] = (i+offset) & 0xff;  // Rotating incrementing pattern.
        expected_checksum += data[i];
      }

      gp.set_data_ptr(data);
      delay = sc_time( 10, SC_NS );

      out->b_transport(gp,delay);

      address += PAYLOAD_NUM_BYTES;
      offset++;
    }

    cout << endl
         << sc_time_stamp()
         << " [PRODUCER/ENDING] " << endl;;

    if( actual_checksum > 0 && actual_checksum == expected_checksum )
      fprintf( stdout,
        "expected_checksum=%llx == actual_checksum=%llx test PASSED !\n",
        expected_checksum, actual_checksum );
    else
      fprintf( stdout,
        "expected_checksum=%llx != actual_checksum=%llx test FAILED !\n",
        expected_checksum, actual_checksum );
    fflush( stdout );

    delete [] data;

    done.notify();
  }

  virtual void b_transport(tlm_generic_payload &gp, sc_time &t) {
    char unsigned *data = gp.get_data_ptr();

    for( unsigned long long i=0; i<gp.get_data_length(); i++ )
        actual_checksum += data[i];

    wait(t);
    t = SC_ZERO_TIME;
    gp.set_response_status( tlm::TLM_OK_RESPONSE );
  }
};

#endif // PRODUCER_LOOPBACK_H
