//============================================================================
// @(#) $Id: loopback.svh 1379 2015-02-17 00:13:20Z jstickle $
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

//________________
// class loopback \___________________________________________________________
//----------------------------------------------------------------------------

import uvm_pkg::*; 
`include "uvm_macros.svh"

class loopback extends uvm_component;

    // All ports default to TLM GP as transaction kind.
    uvm_tlm_b_target_socket     #( loopback ) in;
    uvm_tlm_nb_target_socket    #( loopback ) in_config;
    uvm_tlm_b_initiator_socket  #()           out;
    uvm_tlm_nb_initiator_socket #( loopback ) out_config;

    `uvm_component_utils(loopback)
   
    function new(string name, uvm_component parent=null);
        super.new(name,parent);
        in = new("in",  this);
        in_config = new("in_config",  this);

        out = new("out",  this);
        out_config = new("out_config",  this);
    endfunction

    // task called via 'in' socket, loops back via 'out' socket
    virtual task b_transport (uvm_tlm_gp t, uvm_tlm_time delay);
        out.b_transport( t, delay );
    endtask

    // function called via 'in_config' socket, loops back via
    // 'out_config' socket.
    virtual function uvm_tlm_sync_e nb_transport_fw(
        uvm_tlm_gp t, ref uvm_tlm_phase_e p, input uvm_tlm_time delay );
        return out_config.nb_transport_fw( t, p, delay );
    endfunction

    // This is required but not used.
    virtual function uvm_tlm_sync_e nb_transport_bw(
        uvm_tlm_gp t, ref uvm_tlm_phase_e p, input uvm_tlm_time delay );
        return UVM_TLM_COMPLETED;  // Not used.
    endfunction

endclass
