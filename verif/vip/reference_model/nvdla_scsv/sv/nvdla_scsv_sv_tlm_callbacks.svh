`ifndef _NVDLA_SCSV_SC_TLM_CB
`define _NVDLA_SCSV_SC_TLM_CB

typedef class nvdla_scsv_sv_tlm_channel;
/// Callback class for the nvdla_scsv_sv_tlm_channel

/*! \class nvdla_scsv_sv_tlm_callbacks
    \brief This is the Systemverilog side abstract callback class for the SC-SV Language converters 

    This class contains the Systemverilog side pre and post b_transport callback methods.
    The user would derive from this class, implement the abstract methods 

    The expected usecase for these callbacks is to insert code where the user might
    need to manipulate the transaction to ensure smooth operation with the other
    connected components
 */

class nvdla_scsv_sv_tlm_callbacks #(type T) extends uvm_callback;

    `uvm_object_param_utils(nvdla_scsv_sv_tlm_callbacks#(T));

    /// Constructor
    /// \brief Constructor
    /// \param name name string of the component
    function new(string name = "nvdla_scsv_sv_tlm_callbacks");
        super.new(name);
    endfunction: new

    /// Called before a transaction is executed
    /// \brief pre_btransport_cb is the callback that will be triggered before the channel forwards the transaction.
    /// \param converter This is a handle to the converter class this callback is tied to
    /// \param tlm_pkt This is a handle to the payload being transported via the socket
    /// \param tlm_time The time delay that was communicated as part of the initial b_transport call from the parent initiator
    virtual task pre_btransport_cb(nvdla_scsv_sv_tlm_channel#(T) converter, T obj, uvm_tlm_time delay);
        obj.end_tr();
    endtask: pre_btransport_cb

    /// Called after a transaction has been executed
    /// \brief post_btransport_cb is the callback that will be triggered after the channel receives the response transaction.
    /// \param converter This is a handle to the converter class this callback is tied to
    /// \param tlm_pkt This is a handle to the payload being transported via the socket
    /// \param tlm_time The time delay that was communicated as part of the initial b_transport call from the parent initiator
    virtual task post_btransport_cb(nvdla_scsv_sv_tlm_channel#(T) converter, T obj, uvm_tlm_time delay);
    endtask: post_btransport_cb

endclass:nvdla_scsv_sv_tlm_callbacks


`endif //_NVDLA_SCSV_SC_TLM_CB
