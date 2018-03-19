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


//----------------------------------------------------------------------
// Title: UVMC Command API Example - Configuration
//
// This example demonstrates usage the <set_config> and <get_config>
// portion of the UVMC Command API.
//
// For setting an object, a converter must be defined for the object
// being transferred. See <Converters> for how to do that.
// This requirement is most easily met using one of the <UVMC_UTILS> or
// <UVMC_CONVERT> macros, which generate the converter
// specialization class.
//
//
// uvmc_set_config -
// The 1st arg is the full path to the component(s) on whose behalf you
// are setting the configuration. If empty (""), ~uvm_top~ is used.
// The 2nd argument is the path to the component target(s) whose
// configuration value you want to set, relative to the path given
// by the 1st argument. The 3rd argument is the name of the
// configuration field to set (as documented by the target
// component(s)).
// The full path to the target field(s) is thus
//
//| {arg1,".",arg2,".",arg3}
//
//
// uvmc_get_config-
// The 1st arg is the full path to the component target whose
// configuration value you want to get. The 2nd argument is empty.
// (The 2nd arg is there to match the prototype of the
// uvm_config_db::get method in UVM.) The 3rd argument is the name
// of the config field to get. If a configuration was set at the path
// {arg1,".",arg3}, then the 4th argument contains the value of that
// config field and 'true' is returned, otherwise false.
//
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// CLASS: prod_cfg
//
// The ~prod_cfg~ class is the configuration object we'll be sending
// to the producer component on the SV side. It dictates the address
// range, data array length ranges, and the maximum number of transactions
// to produce. We use the <UVMC_UTILS> macro option to quickly
// define a UVMC converter for it.
//----------------------------------------------------------------------

// (begin inline source)

// (begin inline source)
#include "uvmc.h"
#include "uvmc_macros.h"
using namespace uvmc;


class prod_cfg {
  public:
  int min_addr;
  int max_addr;
  int min_data_len;
  int max_data_len;
  int max_trans;
};

UVMC_UTILS_5(prod_cfg,min_addr,max_addr,
             min_data_len,max_data_len,max_trans)

// (end inline source)



//---------------------------------------------------------------------
// CLASS: top
//
// Our top-level SC module does the following
//
// - Creates an instance of a generic <consumer>. The consumer merely
//   prints the transactions it receives side and sends them out its
//   analysis port.
//
// - Spawn a thread function, ~show_uvm_config~
//
// - Register the consumer's ports for UVMC connection.
//
// The ~show_uvm_config~ thread will perform
// a set and get config operation on an integral, string, and object
// type. The object we use, <prod_cfg>, configures in one go the
// SV-side producer with max transaction count and constraints on
// address and data array length. 
//
// Note the use of the UVM_INFO and UVM_ERROR macros, which issue
// reports to UVM for filtering, formatting, and display.
//
//---------------------------------------------------------------------

// (begin inline source)
#include <string>
#include <iostream>
#include "systemc.h"
#include "tlm.h"
#include "uvmc.h"

using namespace std;
using namespace sc_core;
using namespace tlm;
using namespace uvmc;

#include "consumer.cpp"


SC_MODULE(top)
{
  consumer cons;

  SC_CTOR(top) : cons("consumer") {
    SC_THREAD(show_uvm_config);
    uvmc_connect(cons.in,"foo");
    uvmc_connect(cons.analysis_out,"bar");
  }

  void show_uvm_config();

};
// (end inline source)


//--------------------------------------------------------------------
// Function: show_uvm_config
//
// The ~show_uvm_config~ thread will perform
// a set and get config operation on an integral, string, and object
// type. The object we use, <prod_cfg>, configures in one go the
// SV-side producer with max transaction count and constraints on
// address and data array length. 
//
// Note the use of the UVM_INFO and UVM_ERROR macros, which issue
// reports to UVM for filtering, formatting, and display.
//--------------------------------------------------------------------

// (begin inline source)
void top::show_uvm_config()
{
  string s = "Greetings from SystemC";
  uint64 i = 2;
  prod_cfg cfg;

  cfg.min_addr=0x100;
  cfg.max_addr=0x10f;
  cfg.min_data_len=1;
  cfg.max_data_len=8;
  cfg.max_trans=2;

  wait(SC_ZERO_TIME);


  UVMC_INFO("TOP/SET_CFG",
    "Calling set_config_* to SV-side instance 'e.prod'",
    UVM_MEDIUM,"");

  uvmc_set_config_int    ("e.prod", "", "some_int", i);

  uvmc_set_config_string ("", "e.prod", "some_string", s.c_str());

  uvmc_set_config_object ("prod_cfg", "e", "prod", "config", cfg);


  // Wait until the build phase. The SV side will have used get_config
  // to retreive our settings
  uvmc_wait_for_phase("build", UVM_PHASE_ENDED);

  i=0;
  s="";
  cfg.min_addr=0;
  cfg.max_addr=0;

  UVMC_INFO("TOP/GET_CFG", \
    "Calling get_config_* from SV-side context 'e.prod'", \
    UVM_MEDIUM,"");


  // Get and check our int, string, and object configuration 
  if (uvmc_get_config_int ("e.prod", "", "some_int", i))
    cout << "get_config_int : some_int=" << hex << i << endl;
  else
    UVMC_ERROR("GET_CFG_INT_FAIL", "get_config_int failed",name());

  if (uvmc_get_config_string ("e.prod", "", "some_string", s))
    cout << "get_config_string: some_string=" << s << endl;
  else
    UVMC_ERROR("GET_CFG_STR_FAIL", "get_config_string failed",name());

  if (uvmc_get_config_object ("prod_cfg", "e.prod", "", "config", cfg))
    cout << "get_config_object: config = " << cfg << endl;
  else
    UVMC_ERROR("GET_CFG_OBJ_FAIL", "get_config_object failed",name());
}
// (end inline source)


//---------------------------------------------------------------------
// CLASS: SC_MAIN
// 
// Creates an instance of our <top> module then calls ~sc_start~
// to start SC simulation.
//---------------------------------------------------------------------

// (begin inline source)
int sc_main(int argc, char* argv[]) 
{  
  top t("top");
  sc_start();
  return 0;
}
// (end inline source)
