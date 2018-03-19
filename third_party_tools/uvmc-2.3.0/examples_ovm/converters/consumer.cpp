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
// CLASS: consumer
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
class consumer : public sc_module, public tlm_blocking_put_if<T> {

  public:
  sc_export<tlm_blocking_put_if<T> > in;
  tlm_analysis_port<T> ap;

  consumer(sc_module_name nm) : in("in"), ap("ap")
  {
    in(*this);
  }

  virtual void put(const T& t) {

    cout << sc_time_stamp() << " SC consumer executing packet:" 
       << endl << "  " << t << endl;

    wait(10,SC_NS);

    ap.write(t);
  }
};

