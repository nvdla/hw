//============================================================================
// @(#) $Id: producer_loopback.svh 1379 2015-02-17 00:13:20Z jstickle $
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

//________________                                            ________________
// class producer \__________________________________________/ johnS 11-1-2014
//----------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Title: SV -> SC -> SV loopback example
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Topic: SV initiator and target use of config extensions
// ---------------------------------------------------------------------------
//
// This example is was modified from one of the variations
// under ~../xlerate.connections~ to demonstrate the use
// of static and sideband ~configuration extensions~.
//
// Configuration extensions can be passed "piggy back" alongside the generic
// payload (TLM GP) transaction when it is desired to
// do ~static configuration~ register updates/queries or to pass
// along ~sideband configuration~ items.
//
// In this case the configurations being deployed are hypothetical configuration
// objects that might be used in conjunction with AXI bus protocol transactors.
//
// The configuration extensions are used to carry ancillary parameters that need
// to accompany TLM GP's to represent basic AXI bus transactions and AXI
// transactor configuration operations.
//
// See <AXI config extension SV example> for a detailed description of the
// actual *class AxiConfig* config extension used in the examples blow.
//
// In these examples we demonstrate 3 aspects of using configuration extensions,
//
//   - Demonstrate the initiator querying of "read-only" parameters in the
//     target using ~static configuration query~ ops.
//
//   - Demonstrate the initiator updating config parameters in the target
//     using ~static configuration update~ ops.
//
//   - Demonstrate initiator passing extra ancillary parameters with each
//     and every TLM GP transaction using using ~sideband configurations~.
//
// In the example below, because it is demonstrating an SV -> SC -> SV loopback
// both the initiator and the target of each operation is implemented in
// the same SV *class producer* shown blow.
//----------------------------------------------------------------------------

import uvm_pkg::*; 
`include "uvm_macros.svh"

import AxiConfigPkg::*; 

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

// -------------------------------------------------------------
// Group: class producer - SV initiator and target
// -------------------------------------------------------------
//
// The *class producer* is a *uvm_component* that defines both initiator
// and target TLM-2 ports since this is a loopback and the same producer
// plays the role of both initiator and eventual target.
//
// In this example the static config TLM-2 channel is made separate from
// the "mainstream" TLM-2 transaction channel because of a limitation in
// SV-UVM that the same ports cannot be used for both blocking and non-blocking
// transport operations. And because static config query/updates are done
// using non-blocking transports while mainstream transactions use
// blocking transports, two sets of ports are created.
// -------------------------------------------------------------

// (begin inline source)

class producer extends uvm_component; // {

    `uvm_component_utils(producer)

    // All ports default to TLM GP as transaction kind.
    uvm_tlm_b_initiator_socket  #()           out;        // "mainstream" port
    uvm_tlm_nb_initiator_socket #( producer ) out_config; // static config port
    uvm_tlm_b_target_socket     #( producer ) in;
    uvm_tlm_nb_target_socket    #( producer ) in_config;

// (end inline source)

    AxiConfig targetConfig;

    local int unsigned expectedChecksum, actualChecksum;

    //---------------------------------------------------------
    // Constructors/destructors
    //---------------------------------------------------------
   
    function new(string name, uvm_component parent=null);
        super.new(name,parent);

        out = new("out", this);
        out_config = new("out_config", this);
        in = new("in", this);
        in_config = new("in_config", this);

        targetConfig = new();
     
        // Set up static config "READ-ONLY" parameters for subsequent queries.
        targetConfig.setAddrWidth( 64 );
        targetConfig.setDataWidth( 128 );

    endfunction

    //---------------------------------------------------------
    // Method: ::run()
    //
    // This is the test thread that implements the ~initiator~ function of
    // the example.
    //
    // At the high level it performs the following ops,
    //
    // - Learn (query) the static config from the target.
    // - Update the static config back to the target with desired persistent
    //   register field settings.
    // - Re-learn (query) the static config from the target to show that
    //   static config registers were updated from previous op.
    // - Set up BURST_TYPE sideband config value that will be used for
    //   all iterations of the main test loop.
    // - foreach of NUM_TRANSACTIONS
    //   : - Increment AID sideband config value for this transaction
    //   : - Set up remaining main TLM GP fields for transaction
    //   : - Send transaction to target by calling socket's ::b_transport()
    // - Check that checksum of data sent matches that of data received by
    //   target.
    //---------------------------------------------------------

    task run_phase (uvm_phase phase);

        // Allocate GP once
        uvm_tlm_gp gp = new;
        uvm_tlm_time delay = new("del",1e-9);
        int numTrans = `NUM_TRANSACTIONS;

        longint unsigned address = 64'h40000000;

        longint unsigned i, j, offset = 0;

        byte unsigned data[];

        AxiConfig configExt = new();

        // Keep the "run" phase from ending
        phase.raise_objection(this);
        void'(gp.set_extension( configExt ));

        // Get number of transactions desired (default=2)
        void'( uvm_config_db #(uvm_bitstream_t)::get(
            this, "", "numTrans", numTrans ) );

        expectedChecksum = 0;
        actualChecksum = 0;

        #10ns;

        //---------------------------------------------------------
        // First, learn the READ-ONLY AXI bus parameters
        // (DATA_WIDTH, ADDR_WIDTH) and default values for other READ/WRITE'able
        // parameters using a ~static config query~ op.

        learnBusParameters( configExt );

        //---------------------------------------------------------
        // Next, update the target static config with some new values to
        // override default ones using a ~static config update~ op.

        configExt.setLockType( AXI_LOCKED );
        configExt.setCacheType( AXI_CACHE_WTHROUGH_ALLOC_RW );
        configExt.setProtType( AXI_NORM_NONSEC_INST );
        updateTargetConfig( configExt );

        //---------------------------------------------------------
        // OK, let's learn the bus parameters again to confirm we see the newly
        // updated static config items.
        learnBusParameters( configExt );

        gp.set_command( UVM_TLM_WRITE_COMMAND );
        gp.set_data_length( `PAYLOAD_NUM_BYTES );

        // Let's set the BURST_TYPE sideband config item to AXI_INCR for
        // all transactions.
        configExt.setBurstType( AXI_INCR );

        data = new[`PAYLOAD_NUM_BYTES];

        `uvm_info( "producer::run_phase()",
            $psprintf( "[PRODUCER/GP/SEND] NUM_TRANSACTIONS=%0d PAYLOAD_NUM_BYTES=%0d ...", `NUM_TRANSACTIONS, `PAYLOAD_NUM_BYTES ), UVM_MEDIUM );

        for( i=0; i < numTrans; i++ ) begin

            // Here we set up the 'AID' sideband config item to be simply
            // the transaction count. You'll see we factor the AID right into
            // the expected and actual checksum's below to verify it was 
            // properly passed.
            configExt.setAid( i+1 );
            gp.set_address( address );
            gp.set_response_status( UVM_TLM_INCOMPLETE_RESPONSE );

            expectedChecksum += configExt.getAid();
            for( j=0; j < `PAYLOAD_NUM_BYTES; j++) begin
                data[j] = (j+offset) & 8'hff; // Rotating incrementing pattern.
                expectedChecksum += data[j];
            end

            gp.set_data( data );
            delay.set_abstime(10,1e-9);

            out.b_transport( gp, delay );

            address += `PAYLOAD_NUM_BYTES;
            offset++;
        end

        if( actualChecksum > 0 && actualChecksum == expectedChecksum ) begin
            `uvm_info( "producer::run_phase()", $psprintf(
              "... done producing transactions, expectedChecksum=%0x == actualChecksum=%0x Test PASSED !",
             expectedChecksum, actualChecksum ), UVM_MEDIUM );
        end
        else begin
            `uvm_error( "producer::run_phase()", $psprintf(
            "... done producing transactions, expectedChecksum=%0x != actualChecksum=%0x Test FAILED !",
            expectedChecksum, actualChecksum ) );
        end

        gp.clear_extension( configExt );

        `uvm_info("PRODUCER/END_TEST",
            "Dropping objection to ending the test",UVM_LOW)

        phase.drop_objection(this);
    endtask

    //---------------------------------------------------------
    // Method: ::b_transport()
    //
    // This is the target's implementation of the mainstream *::b_transport()*
    // method to process all TLM GP transactions in the SV -> SC -> SV
    // loopback test.
    //
    // Mainly it just updates the checksum that will be checked at the end of
    // the test with the data contents.
    //
    // But notice how it also accesses the *AID* sideband config parameter
    // accompanying the main TLM GP transaction and reflects that in
    // the checksum as well.
    //---------------------------------------------------------

    // (begin inline source)

    virtual task b_transport( uvm_tlm_gp t, uvm_tlm_time delay );

        AxiConfig configExt = new();
        uvmc_xl_config_base configExtension;

        $cast( configExtension, t.get_extension(uvmc_xl_config_base::ID()) );
        assert( configExtension != null );

        configExt.copy( configExtension );

        actualChecksum += configExt.getAid();
        for( int unsigned i=0; i < t.get_data_length(); i++ )
            actualChecksum += t.m_data[i];

        #(delay.get_abstime(1e-9));
        delay.reset();
        t.set_response_status( UVM_TLM_OK_RESPONSE );
    endtask

    // (end inline source)

    //---------------------------------------------------------
    // Method: ::nb_transport_fw()
    //
    // This is the target's implementation of the
    // non-blocking *::nb_transport_fw()* used only for the static config
    // target port.
    //
    // If it is a ~static config query~ (READ op), it copies the
    // local target's config extension object into the static config extension
    // member of the passed in TLM GP for return back to the initiator.
    //
    // Otherwise if it is a ~static config update~ (WRITE op), it from
    // copies from the static config extension member of the passed in TLM GP
    // object arriving from the initiator, into the local target's config
    // extension object.
    //---------------------------------------------------------

    // (begin inline source)

    virtual function uvm_tlm_sync_e nb_transport_fw(
        uvm_tlm_gp trans, ref uvm_tlm_phase_e phase,
        input uvm_tlm_time delay );
    // {
        int status;
        uvmc_xl_config_base configExtension;

        // Standard checks that pure TLM-2.0 base protocol rules are
        // being properly followed ...
        if( phase != BEGIN_REQ )
            `uvm_error( get_type_name(),
                $psprintf(
                    "Phase error on transport socket '%s' expectedPhase=%s actualPhase=%0d",
                    "producer::nb_transport_fw()",
                    "BEGIN_REQ", int'(phase) ) )

        // Innocent until proven guilty.
        trans.set_response_status( UVM_TLM_OK_RESPONSE );

        // If a configuration extension has been passed alongside the
        // generic payload transaction then it is possible we're doing
        // a static configuration register update or query

        $cast( configExtension, trans.get_extension(uvmc_xl_config_base::ID()) );

        if( configExtension != null ) begin // {

            // if( trans.get_data_length() == 0 )
            //     We assume static config if data length=0
            if( trans.get_data_length() == 0 ) begin // {

                // if( we're just querying the static configuration )
                //   We can just transfer it from the local target
                //   config extension.
                if( trans.is_read() )
                    configExtension.copy( targetConfig );

                // else we assume a config update.
                else targetConfig.copy( configExtension );

                return UVM_TLM_COMPLETED;
            end // }
        end // }

        // Proven guilty ! (This function now only handles
        // static config updates/queries - use ::b_transport() for actual
        // LT-mode-only mainstream transactions.)
        trans.set_response_status( UVM_TLM_GENERIC_ERROR_RESPONSE );

        return UVM_TLM_COMPLETED;
    endfunction // }

    // (end inline source)

    // This is required but not used.
    virtual function uvm_tlm_sync_e nb_transport_bw(
        uvm_tlm_gp t, ref uvm_tlm_phase_e p, input uvm_tlm_time delay );
        return UVM_TLM_COMPLETED;  // Not used.
    endfunction

    //---------------------------------------------------------
    // Method: ::learnBusParameters()
    //
    // Send a transaction to QUERY the target configuration.
    // Full configuration will arrive in the generic payload on the
    // on the return path of this *nb_transport_fw()* call.
    //
    // Notice the convenient use of the base
    // class *uvmc_xl_config::query_trans()* method that returns
    // a ~pre-fab'ed~ TLM GP container that can conveniently be
    // used (and reused) as a carrier strictly for the purpose of performing
    // ~config query~ operations.
    //---------------------------------------------------------

    // (begin inline source)

    function void learnBusParameters( AxiConfig configExt ); // {

        uvm_tlm_time delay = new("del",1e-9);
        uvm_tlm_phase_e phase = BEGIN_REQ;
        uvm_tlm_generic_payload q = configExt.query_trans();

        if( out_config.nb_transport_fw( q, phase, delay )
                != UVM_TLM_COMPLETED
            || q.get_response_status() != UVM_TLM_OK_RESPONSE )
        begin
            `uvm_error( get_type_name(),
                $psprintf(
                    "Error on transport socket '%s' ",
                    "producer::learnBusParameters()" ) )
            return;
        end

        `uvm_info( get_type_name(),
            $psprintf( "[PRODUCER/CONFIG/QUERY] ADDR_WIDTH=%0d DATA_WIDTH=%0d LOCK_TYPE=%0d CACHE_TYPE=%0d PROT_TYPE=%0d",
                configExt.getAddrWidth(),
                configExt.getDataWidth(),
                configExt.getLockType(),
                configExt.getCacheType(),
                configExt.getProtType() ), UVM_LOW )
    endfunction // }

    // (end inline source)

   //---------------------------------------------------------
    // Method: ::updateTargetConfig()
    //
    // Send a transaction to UPDATE the initial target configuration.
    // 
    // Again, notice use of the *::update_trans()* method of the base
    // *class uvm_xl_config* as a convenient pre-configured and reusable
    // TLM GP that acts as a carrier for the ~config update~ operations.
    //---------------------------------------------------------

    // (begin inline source)

    function void updateTargetConfig( AxiConfig configExt ); // {

        uvm_tlm_time delay = new("del",1e-9);
        uvm_tlm_phase_e phase = BEGIN_REQ;
        uvm_tlm_generic_payload u = configExt.update_trans();

        if( out_config.nb_transport_fw( u, phase, delay )
                != UVM_TLM_COMPLETED
            || u.get_response_status() != UVM_TLM_OK_RESPONSE )

            `uvm_error( get_type_name(), $psprintf(
                "Error on transport socket '%s' ",
                "producer::updateTargetConfig()" ) )
    endfunction // }

    // (end inline source)

endclass // }
