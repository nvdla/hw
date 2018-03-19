#ifndef _NVDLA_SCSV_SC_INCLUDES
#define _NVDLA_SCSV_SC_INCLUDES

#include <string>
#include <systemc>
#include <tlm>
#include "tlm_utils/multi_passthrough_target_socket.h" 
#include "tlm_utils/multi_passthrough_initiator_socket.h"

///
/// UVMConnect code is protected by __EDG__ defines because
/// VCS Syscan internally uses g++ compiler for 
/// compiling the SystemC code. The g++ compiler allows some additional 
/// syntax/constructs which is not legal as per the ANSI C++ standard. But while 
/// creating a Verilog wrapper, syscan internally uses EDG compiler in addition to 
/// the g++ compiler. The EDG compiler does not allow syntax/constructs which are 
/// not legal as per the ANSI C++ standard.
/// See SolvNet Article - https://solvnet.synopsys.com/retrieve/038729.html
///
#ifndef __EDG__
#include "uvmc.h"
using namespace uvmc;
#endif

using std::string;
using namespace sc_core;
using namespace tlm;
using namespace tlm_utils;

#endif //_NVDLA_SCSV_SC_INCLUDES
