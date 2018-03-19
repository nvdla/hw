`ifndef _NVDLA_SCSV_SV_TLM_CONNECTOR
`define _NVDLA_SCSV_SV_TLM_CONNECTOR

// -----------------------------------------------------------------------------
// Component: TLM proxy for the SystemVerilog side of the Mixed language channels
//
// Package:  SystemC-SystemVerilog Mixed Language Connectors based on UVMConnect 2.3.1 
//
// Description:
/// \file nvdla_scsv_sv_tlm_channel.svh
//  This file contains the SystemVerilog TLM proxy of the SystemVerilog-SystemC TLM channels
// -----------------------------------------------------------------------------

`include "nvdla_scsv_sv_tlm_callbacks.svh"

/*! \class nvdla_scsv_sv_tlm_channel
    \brief This is the Systemverilog side class of the SC-SV Language converters 

    This class is the Systemverilog side implementation of the UVMConnect based
    SystemC <-> SystemVerilog TLM Converters. It is a parameterized class and expects 
    payload type. The default payload type is uvm_tlm_generic_payload 
*/

class nvdla_scsv_sv_tlm_channel #(type T) extends uvm_component;

    `uvm_component_param_utils(nvdla_scsv_sv_tlm_channel#(T))

    // Work around to get around uvm_register_cb unable to take parameterized class in second argument
    typedef nvdla_scsv_sv_tlm_callbacks#(T) nvdla_scsv_sv_tlm_callbacks_parameterized;

    `uvm_register_cb(nvdla_scsv_sv_tlm_channel#(T), nvdla_scsv_sv_tlm_callbacks_parameterized)

    /// \name TLM 2.0 Sockets
    /// The initiator and target sockets that would connect UVMConnect side
    /// to the Systemverilog side,or vice-versa.
    ///@{
    /// TLM 2.0 Target Socket
    /// Depending on whether we are doing SC->SV,or
    /// SV->SC, this would be connected to the Systemverilog side
    /// or UVMConnect
    uvm_tlm_b_target_socket #(nvdla_scsv_sv_tlm_channel#(T), T) sv_tlm_target;

    /// TLM 2.0 Initiator Socket
    /// Depending on whether we are doing SC->SV,or
    /// SV->SC, this would be connected to the Systemverilog side
    /// or UVMConnect
    uvm_tlm_b_initiator_socket #(T) sv_tlm_initiator;
    ///@}

    /// TLM Analysis port for initiated observed transactions.
    /// \name TLM 1.0 Anaylsis Ports
    /// The channel provides two analysis ports for subscribers
    /// to see the transactiond during both phases - the response and request complete phase.
    ///@{        
    /// The \c sv_pre_complete_tlm_analysis port will be used to push
    /// the tlm payload before the b_transport call,
    uvm_analysis_port #(T) sv_pre_complete_tlm_analysis_port;

    /// TLM 1.0 Anaylsis Ports
    /// The \c sv_complete_tlm_analysis_port will be used to push the tlm payload
    /// after the b_transport call has returned.
    uvm_analysis_port #(T) sv_complete_tlm_analysis_port;

    /// Constructor
    function new (string name,uvm_component parent=null);
        super.new(name,parent);
    endfunction:new

    /// Build Phase
    virtual function void build_phase (uvm_phase phase);
        //Build the TLM Target Port
        sv_tlm_target = new("sv_tlm_target",this);
        //Build the TLM Initiator Port
        sv_tlm_initiator = new ("sv_tlm_initiator",this);
        //Build the pre-complete/pre_b_transport tlm analysis port
        sv_pre_complete_tlm_analysis_port = new ("sv_pre_complete_tlm_analysis_port",this);
        //Build the complete tlm/post_b_transport analysis port
        sv_complete_tlm_analysis_port = new ("sv_complete_tlm_analysis_port",this);
    endfunction:build_phase

    /// \brief b_transport call that the initiator side would call on the sv_tlm_target_port
    /// \param obj This should be the payload thats meant to be transferred across the socket
    /// \param tlm_time Time delay that the transfer should be associated with
    /// \return void
    virtual task b_transport(T obj, uvm_tlm_time tlm_time);
        
        `uvm_info({get_name(),"/GOT_OBJ"},{"\n",obj.sprint()},UVM_DEBUG)

        //Do the pre b_transport callback
        `uvm_do_callbacks(nvdla_scsv_sv_tlm_channel#(T),nvdla_scsv_sv_tlm_callbacks#(T),
                          pre_btransport_cb(this, obj, tlm_time))

        //Write to the sv_pre_complete_tlm_analysis_port
        sv_pre_complete_tlm_analysis_port.write(obj);

        //Forward the TLM packet
        sv_tlm_initiator.b_transport(obj,tlm_time);

        //Write to the sv_complete_tlm_analysis_port
        sv_complete_tlm_analysis_port.write(obj);

        //Do the post b_transport callback
        `uvm_do_callbacks(nvdla_scsv_sv_tlm_channel#(T),nvdla_scsv_sv_tlm_callbacks#(T),
                          post_btransport_cb(this, obj, tlm_time))
    endtask: b_transport

endclass:nvdla_scsv_sv_tlm_channel

`endif //_NVDLA_SCSV_SV_TLM_CONNECTOR
