//============================================================================
// @(#) $Id: producer_loopback.svh 1268 2014-12-01 22:03:42Z jstickle $
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

//-----------------------------------------------------------------------------
// Title: Another SV producer
//
// Topic: Description
//
//-----------------------------------------------------------------------------

// (inline source)
import uvm_pkg::*; 
`include "uvm_macros.svh"

// We want to benchmark the transfer 80 2MB "HD-image" payloads.
//
// See producer_loopback.h for comments about how we set up parameters for
// this benchmark.

`ifndef NUM_TRANSACTIONS
`define NUM_TRANSACTIONS 81920
`endif

`ifndef PAYLOAD_NUM_BYTES
`define PAYLOAD_NUM_BYTES 2048
`endif

class producer extends uvm_component;

   //uvm_tlm_b_initiator_socket #() out;
   uvm_tlm_b_transport_port #(uvm_tlm_generic_payload) out;
   //uvm_tlm_b_target_socket #(producer) in;
   uvm_tlm_b_transport_imp #(uvm_tlm_generic_payload, producer) in;

   `uvm_component_utils(producer)

   local int unsigned expected_checksum, actual_checksum;
   
   function new(string name, uvm_component parent=null);
      super.new(name,parent);
      in = new("in", this);
      out = new("out", this);
   endfunction

   task run_phase (uvm_phase phase);

      // Allocate GP once
      uvm_tlm_gp gp = new;
      uvm_tlm_time delay = new("del",1e-9);
      int num_trans = `NUM_TRANSACTIONS;

      longint unsigned address = 64'h40000000;

      longint unsigned i, j, offset = 0;

      byte unsigned data[];

      // Keep the "run" phase from ending
      phase.raise_objection(this);

      // Get number of transactions desired (default=2)
      uvm_config_db #(uvm_bitstream_t)::get(this,"","num_trans",num_trans);

      expected_checksum = 0;
      actual_checksum = 0;

      gp.set_command( UVM_TLM_WRITE_COMMAND );
      gp.set_data_length( `PAYLOAD_NUM_BYTES );

      data = new[`PAYLOAD_NUM_BYTES];

      `uvm_info( "producer::run_phase()",
        $psprintf( "[PRODUCER/GP/SEND] NUM_TRANSACTIONS=%0d PAYLOAD_NUM_BYTES=%0d ...", `NUM_TRANSACTIONS, `PAYLOAD_NUM_BYTES ), UVM_MEDIUM );

      for( i=0; i < num_trans; i++ ) begin
        gp.set_address( address );
        gp.set_response_status( UVM_TLM_INCOMPLETE_RESPONSE );

        for( j=0; j < `PAYLOAD_NUM_BYTES; j++) begin
          data[j] = (j+offset) & 8'hff;
          expected_checksum += data[j];
        end
        gp.set_data( data );

        delay.set_abstime(10,1e-9);

        out.b_transport( gp, delay );

        address += `PAYLOAD_NUM_BYTES;
        offset++;
      end

      if( actual_checksum > 0 && actual_checksum == expected_checksum ) begin
        `uvm_info( "producer::run_phase()", $psprintf(
          "... done producing transactions, expected_checksum=%0x == actual_checksum=%0x Test PASSED !",
          expected_checksum, actual_checksum ), UVM_MEDIUM );
      end
      else begin
        `uvm_error( "producer::run_phase()", $psprintf(
          "... done producing transactions, expected_checksum=%0x != actual_checksum=%0x Test FAILED !",
          expected_checksum, actual_checksum ) );
      end

      `uvm_info("PRODUCER/END_TEST",
                "Dropping objection to ending the test",UVM_LOW)
      phase.drop_objection(this);
   endtask

   virtual task b_transport( uvm_tlm_gp t, uvm_tlm_time delay );

      for( int unsigned i=0; i < t.get_data_length(); i++ )
         actual_checksum += t.m_data[i];

      #(delay.get_abstime(1e-9));
      delay.reset();
      t.set_response_status( UVM_TLM_OK_RESPONSE );
   endtask
endclass
