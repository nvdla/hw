//============================================================================
// @(#) $Id: producer_loopback.h 1379 2015-02-17 00:13:20Z jstickle $
//============================================================================

   //_______________________
  // Mentor Graphics, Corp. \_________________________________________________
 //                                                                         //
//   (C) Copyright, Mentor Graphics, Corp. 2003-2015                        //
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

#include "AxiConfig.h"

//________________                                            ________________
// class producer \__________________________________________/ johnS 11-1-2014
//----------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Title: SC -> SV -> SC loopback example
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Topic: SC initiator and target use of config extensions
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
// In this case the configurations begin deployed are hypothetical configuration
// objects that might be used in conjunction with AXI bus protocol transactors.
//
// The configuration extensions are used to carry ancillary parameters that need
// to accompany TLM GP's to represent basic AXI bus transactions and AXI
// transactor configuration operations.
//
// See <AXI config extension SC example> for a detailed description of the
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
// In the example below, because it is demonstrating an SC -> SV -> SC loopback
// both the initiator and the target of each operation is implemented in
// the same SC *class producer* shown blow.
//----------------------------------------------------------------------------

#ifndef NUM_TRANSACTIONS
#define NUM_TRANSACTIONS 81920
#endif

#ifndef PAYLOAD_NUM_BYTES
#define PAYLOAD_NUM_BYTES 2048
#endif

// -------------------------------------------------------------
// Group: class producer - SC initiator and target
// -------------------------------------------------------------
//
// The *class producer* is an *sc_module* that defines both initiator
// and target TLM-2 ports since this is a loopback and the same
// producer plays the role of both initiator and eventual target.
//
// In this example the static config TLM-2 channel is made separate from
// the "mainstream" TLM-2 channel although this does not need to be the case.
// Because static configs are handled as distinct operations, a
// single TLM-2 channel can be overloaded for use with static config ops
// and mainstream TLM GP transation ops (with optionally "piggy backed"
// sideband configs).
// -------------------------------------------------------------

// (begin inline source)

class producer : public sc_module {

  public:
    simple_initiator_socket<producer> out;        // "mainstream" port
    simple_initiator_socket<producer> out_config; // static config port
    simple_target_socket<producer> in;
    simple_target_socket<producer> in_config;

// (end inline source)

    int i;
    sc_event done;
    AxiConfig targetConfig;

    unsigned long long expectedChecksum, actualChecksum;

    SC_HAS_PROCESS(producer);

    //---------------------------------------------------------
    // Constructors/destructors
    //---------------------------------------------------------

    producer(sc_module_name nm)
      : out("out"), out_config("out_config"), in("in"), in_config("in_config"),
        expectedChecksum(0LL), actualChecksum(0LL)
    {
        SC_THREAD(run);

        in.register_b_transport(this, &producer::b_transport);
        in_config.register_nb_transport_fw(this, &producer::nb_transport_fw);

        // Set up static config "READ-ONLY" parameters for subsequent queries.
        targetConfig.setAddrWidth( 64 );
        targetConfig.setDataWidth( 128 );
    }

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

    void run() {
        tlm_generic_payload gp; 
        unsigned char *data = new unsigned char [PAYLOAD_NUM_BYTES];
        sc_time delay;

        // Set up a config extension to be used for static config
        // queries/updates and sideband config updates (aid).
        AxiConfig config;
        gp.set_extension( &config );

        wait( 10, SC_NS );

        //---------------------------------------------------------
        // First, learn the READ-ONLY AXI bus parameters
        // (DATA_WIDTH, ADDR_WIDTH) and default values for other READ/WRITE'able
        // parameters using a ~static config query~ op.

        learnBusParameters( config );

        //---------------------------------------------------------
        // Next, update the target static config with some new values to
        // override default ones using a ~static config update~ op.

        config.setLockType( AxiConfig::AXI_LOCKED );
        config.setCacheType( AxiConfig::AXI_CACHE_WTHROUGH_ALLOC_RW );
        config.setProtType( AxiConfig::AXI_NORM_NONSEC_INST );
        updateTargetConfig( config );

        //---------------------------------------------------------
        // OK, let's learn the bus parameters again to confirm we see the newly
        // updated static config items.
        learnBusParameters( config );

        sc_dt::uint64 address = 0x40000000;

        gp.set_command(TLM_WRITE_COMMAND);
        gp.set_data_length( PAYLOAD_NUM_BYTES );

        // Let's set the BURST_TYPE sideband config item to AXI_INCR for
        // all transactions.
        config.setBurstType( AxiConfig::AXI_INCR );

        cout << sc_time_stamp()
             << " [PRODUCER/GP/SEND]"
             << " cmd: " << gp.get_command()
             << " addr:" << hex << gp.get_address()
             << " PAYLOAD_NUM_BYTES:" << dec << gp.get_data_length()
             << " NUM_TRANSACTIONS:" << dec << NUM_TRANSACTIONS
             << endl;

        unsigned offset = 0;

        for( i=0; i<NUM_TRANSACTIONS; i++ )  {

            // Here we set up the 'AID' sideband config item to be simply
            // the transaction count. You'll see we factor the AID right into
            // the expected and actual checksum's below to verify it was 
            // properly passed.
            config.setAid( i+1 );
            gp.set_address( address );
            gp.set_response_status( tlm::TLM_INCOMPLETE_RESPONSE );

            expectedChecksum += config.getAid();
            for( unsigned i=0; i<PAYLOAD_NUM_BYTES; i++ ) {
                data[i] = (i+offset) & 0xff;  // Rotating incrementing pattern.
                expectedChecksum += data[i];
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

        if( actualChecksum > 0 && actualChecksum == expectedChecksum )
            fprintf( stdout,
                "expectedChecksum=%llx == actualChecksum=%llx test PASSED !\n",
                expectedChecksum, actualChecksum );
        else
            fprintf( stdout,
                "expectedChecksum=%llx != actualChecksum=%llx test FAILED !\n",
                expectedChecksum, actualChecksum );
        fflush( stdout );

        gp.clear_extension( &config );

        done.notify();
    }

    //---------------------------------------------------------
    // Method: ::b_transport()
    //
    // This is the target's implementation of the mainstream *::b_transport()*
    // method to process all TLM GP transactions in the SC -> SV -> SC
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

    virtual void b_transport(tlm_generic_payload &gp, sc_time &t) {
        char unsigned *data = gp.get_data_ptr();

        AxiConfig *configExt;

        gp.get_extension( configExt );

        actualChecksum += configExt->getAid();
        for( unsigned long long i=0; i<gp.get_data_length(); i++ )
            actualChecksum += data[i];

        wait(t);
        t = SC_ZERO_TIME;
        gp.set_response_status( tlm::TLM_OK_RESPONSE );
    }

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
    
    tlm::tlm_sync_enum nb_transport_fw(
        tlm::tlm_generic_payload &trans,
        tlm::tlm_phase &phase,
        sc_time &delay )
    {   
        int status;
        AxiConfig *configExtension;

        // Standard checks that pure TLM-2.0 base protocol rules are
        // being properly followed ...
        if( phase != BEGIN_REQ )
            errorOnTransportPhase(
                "producer::nb_transport_fw()", "BEGIN_REQ", phase,
                __LINE__, __FILE__ );

        // Innocent until proven guilty.
        trans.set_response_status( tlm::TLM_OK_RESPONSE );

        trans.get_extension( configExtension );

        // If a configuration extension has been passed alongside the
        // generic payload transaction then it is possible we're doing
        // a static configuration register update or query

        if( configExtension ) {

            // if( trans.get_data_length() == 0 )
            //     We assume static config if data length=0
            if( trans.get_data_length() == 0 ) {
                // if( we're just querying the static configuration )
                //   We can just transfer it from the local target
                //   config extension.
                if( trans.is_read() )
                    configExtension->copy_from( targetConfig );

                // else we assume a config update.
                else targetConfig.copy_from( *configExtension );

                return tlm::TLM_COMPLETED;
            }
        }

        // Proven guilty ! (This function now only handles
        // static config updates/queries - use ::b_transport() for actual
        // LT-mode-only mainstream transactions.)
        trans.set_response_status( tlm::TLM_GENERIC_ERROR_RESPONSE );

        return tlm::TLM_COMPLETED;
    }

    // (end inline source)

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

    void learnBusParameters( AxiConfig &config ) {

        sc_time delay = SC_ZERO_TIME;
        tlm_phase phase = BEGIN_REQ;

        if( out_config->nb_transport_fw(
                config.query_trans(), phase, delay ) != TLM_COMPLETED ||
                config.query_trans().get_response_status() != TLM_OK_RESPONSE ){
            errorOnTransport( "producer::learnBusParameters()",
                __LINE__, __FILE__ );
            return;
        }

        cout << sc_time_stamp()
             << " [PRODUCER/CONFIG/QUERY]"
             << " ADDR_WIDTH=" << config.getAddrWidth()
             << " DATA_WIDTH=" << config.getDataWidth()
             << " LOCK_TYPE=" << config.getLockType()
             << " CACHE_TYPE=" << config.getCacheType()
             << " PROT_TYPE=" << config.getProtType()
             << endl;
    }

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

    void updateTargetConfig( AxiConfig &config ) {

        sc_time delay = SC_ZERO_TIME;
        tlm_phase phase = BEGIN_REQ;

        if( out_config->nb_transport_fw(
                config.update_trans(), phase, delay ) != TLM_COMPLETED ||
                config.update_trans().get_response_status()
                    != TLM_OK_RESPONSE )
            errorOnTransport( "producer::updateTargetConfig()",
                __LINE__, __FILE__ );
          return;
    }

    // (end inline source)

    //---------------------------------------------------------
    // Error Handlers                           -- johnS 4-1-11
    //---------------------------------------------------------

    void errorOnTransport(
        const char *functionName, int line, const char *file ) const
    {   char messageBuffer[1024];
        sprintf( messageBuffer,
            "Error on transport socket '%s' [line #%d of '%s'].\n",
            functionName, line, file );
        SC_REPORT_FATAL( "FATAL", messageBuffer ); }

    void errorOnTransportPhase( const char *functionName,
        const char *expectedPhase, tlm::tlm_phase actualPhase,
        int line, const char *file )
    {   char messageBuffer[1024];
        const char *actualPhaseStr;
        switch( actualPhase ){
            case tlm::UNINITIALIZED_PHASE:
                actualPhaseStr = "tlm::UNINITIALIZED_PHASE"; break;
            case tlm::BEGIN_REQ:  actualPhaseStr = "tlm::BEGIN_REQ";  break;
            case tlm::END_REQ:    actualPhaseStr = "tlm::END_REQ";    break;
            case tlm::BEGIN_RESP: actualPhaseStr = "tlm::BEGIN_RESP"; break;
            case tlm::END_RESP:   actualPhaseStr = "tlm::END_RESP";   break;
            default: actualPhaseStr = "UNKNOWN PHASE"; break;
        }
        sprintf( messageBuffer,
            "Phase error on transport socket '%s' "
            "expectedPhase=%s actualPhase=%s [line #%d of '%s'].\n",
            functionName, expectedPhase, actualPhaseStr, line, file );
        SC_REPORT_FATAL( "FATAL", messageBuffer );
    }
};

#endif // PRODUCER_LOOPBACK_H
