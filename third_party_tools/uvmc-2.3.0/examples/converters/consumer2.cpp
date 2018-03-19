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
// CLASS: UVMC Converter Common Code - consumer2
//
// Topic: Description
// A generic consumer parameterized on the transaction type. Used to illustrate
// different converter options using the same consumer class. Functionally,
// this consumer merely prints the transaction and inverts its address and
// data before returning. The producer will verify that the address and data
// have been inverted, which proves reasonably that the transaction 
// successfully made the round trip to SV and back.
//-----------------------------------------------------------------------------

// (inline source)
template <class T>
class consumer : public sc_module, public tlm_blocking_transport_if<T> {

  public:
  sc_export<tlm_blocking_transport_if<T> > in;

  consumer(sc_module_name nm) : in("in")
  {
    in(*this);
  }

  virtual void b_transport(T& t, sc_core::sc_time& delay) {

    cout << sc_time_stamp() << " SC consumer executing packet:" 
       << endl << "  " << t << " payload:{ ";

    for (int i=0; i < 4; i++) {
      cout << hex << t.payload[i];
      if (i != 3)
        cout << ", ";
    }
    cout << " }" << endl;

    wait(delay);

    // invert address
    t.addr_lo = ~t.addr_lo;
    t.addr_hi = ~t.addr_hi;

    // invert data
    for (int i=0; i<4; i++)
      t.payload[i] = ~t.payload[i];

    cout << sc_time_stamp() << " SC consumer packet executed:"
       << endl << "  " << t << " payload:{ ";

    for (int i=0; i < 4; i++) {
      cout << hex << t.payload[i];
      if (i != 3)
        cout << ", ";
    }
    cout << " }" << endl;

    delay = SC_ZERO_TIME;
  }
};

