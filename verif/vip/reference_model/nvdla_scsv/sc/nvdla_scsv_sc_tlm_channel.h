#ifndef _NVDLA_SCSV_SC_TLM_CHANNEL
#define _NVDLA_SCSV_SC_TLM_CHANNEL

#include "nvdla_scsv_sc_includes.h"
#include "nvdla_scsv_sc_tlm_callbacks.h"

/*! \class nvdla_scsv_sc_tlm_channel
    \brief This is the SystemC side class of the SC-SV Language converters 

    This class is the SystemC side implementation of the UVMConnect based
    SystemC <-> SystemVerilog TLM Converters. It is a template class and expects 
    the TLM bus width, and a struct that contains the payload type and phase type. 
    See $SYSTEMC_HOME/include/tlm_core/tlm_2/tlm_2_interfaces/tlm_fw_bw_ifs.h for an
    example of this struct
*/
template <unsigned int BUSWIDTH = 32,
          typename TYPES = tlm_base_protocol_types
         > 
class nvdla_scsv_sc_tlm_channel : public sc_module {

    public:
        /// type the tlm_payload_type from the struct of types to a local typename
        typedef typename TYPES::tlm_payload_type  tlm_payload_type;
        /// type the tlm_phase_type to from the struct of types to a local typename
        typedef typename TYPES::tlm_phase_type   tlm_phase_type;

        ///Constructor
        nvdla_scsv_sc_tlm_channel(sc_module_name name);

        /// \name TLM 2.0 Sockets
        /// The initiator and target sockets that would connect UVMConnect side
        /// to the SystemC side,or vice-versa.
        ///@{
        /// TLM 2.0 Target Socket
        /// Depending on whether we are doing SC->SV,or
        /// SV->SC, this would be connected to the SystemC model
        /// or UVMConnect
        multi_passthrough_target_socket<nvdla_scsv_sc_tlm_channel,BUSWIDTH,TYPES> sc_tlm_target;

        /// TLM 2.0 Initiator Socket
        /// Depending on whether we are doing SC->SV,or
        /// SV->SC, this would be connected to the SystemC model
        /// or UVMConnect
        multi_passthrough_initiator_socket<nvdla_scsv_sc_tlm_channel,BUSWIDTH,TYPES> sc_tlm_initiator;
        ///@}
       
        /// \name TLM 1.0 Anaylsis Ports
        /// The connector provides two analysis ports for subscribers
        /// to see the transactiond during both phases - the response and request complete phase.
        ///@{        
        /// The \c sc_pre_complete_tlm_analysis port will be used to push
        /// the tlm payload before the b_transport call,
        tlm_analysis_port<tlm_payload_type> sc_pre_complete_tlm_analysis_port;
        
        /// TLM 1.0 Anaylsis Ports
        /// The \c sc_complete_tlm_analysis_port will be used to push the tlm payload
        /// after the b_transport call has returned.
        tlm_analysis_port<tlm_payload_type> sc_complete_tlm_analysis_port;
        ///@}

        /// \brief Accessor Method to set the pointer to the user's callback class
        /// \param tlm_cb This is a pointer to the callback class that the user has derived from \c nvdla_scsv_sc_tlm_callbacks
        /// \return void
        void register_tlm_callbacks(nvdla_scsv_sc_tlm_callbacks<tlm_payload_type> *tlm_cb);

        /// \brief b_transport call that the initiator side would call on the sc_tlm_target_port
        /// \param id This will be the id that identifies the particular link in the multi-passthrough connection
        /// \param tlm_pkt This should be the payload thats meant to be transferred across the socket
        /// \param tlm_time Time delay that the transfer should be associated with
        /// \return void
        void b_transport(int id, tlm_payload_type &tlm_pkt, sc_time &tlm_time);

    private: 
        ///Pointer to the callback class,which will be set via the \c register_tlm_callbacks method 
        nvdla_scsv_sc_tlm_callbacks<tlm_payload_type> *tlm_cb_ptr;

        ///Flag set when the user registers a valid callback class
        /// Value of 0 indicates no callback pointer is set
        /// Value of 1 indicuates that a callback pointer is set via the accessor method \c register_tlm_callbacks
        bool callback_pointer_set;
};



template <unsigned int BUSWIDTH,
         typename TYPES
         >
nvdla_scsv_sc_tlm_channel<BUSWIDTH,TYPES>::nvdla_scsv_sc_tlm_channel(sc_module_name name): 
    sc_tlm_initiator("sc_tlm_initiator"),
    sc_tlm_target("sc_tlm_target"),
    sc_pre_complete_tlm_analysis_port("sc_pre_complete_tlm_analysis_port"),
    sc_complete_tlm_analysis_port("sc_complete_tlm_analysis_port")
{
    tlm_cb_ptr = NULL;
    callback_pointer_set = 0;
    sc_tlm_target.register_b_transport(this,&nvdla_scsv_sc_tlm_channel::b_transport);  
}

template <unsigned int BUSWIDTH,
         typename TYPES
         >
void nvdla_scsv_sc_tlm_channel<BUSWIDTH,TYPES>::register_tlm_callbacks(nvdla_scsv_sc_tlm_callbacks<tlm_payload_type> *tlm_cb){
    if(tlm_cb != NULL){
        tlm_cb_ptr = tlm_cb;
        SC_REPORT_INFO("REG_TLM_CALLBACKS/REG_DONE","Callback class pointer registered");
        callback_pointer_set = 1;
    } else {
        SC_REPORT_FATAL("REG_TLM_CALLBACKS/BAD_PTR","Callback class pointer provided for registration is NULL");
    }
}

template <unsigned int BUSWIDTH,
         typename TYPES
         >
void nvdla_scsv_sc_tlm_channel<BUSWIDTH,TYPES>::b_transport(int id, tlm_payload_type &tlm_pkt, sc_time &tlm_time) {

    //Check the callback class pointer before calling its callback methods
    if (tlm_cb_ptr != NULL ) { 
        tlm_cb_ptr->pre_btransport_cb(tlm_pkt,tlm_time);
    } else if ((tlm_cb_ptr == NULL) && (callback_pointer_set == 1)){
        //Error out, because the earlier set pointer is no longer valid, i.e. got destroyed(free'd) somehow.
        SC_REPORT_FATAL("B_TRANSPORT/PRE_TRANSPORT_CB/FAILED","Callback class pointer provided for registration earlier is now NULL");
    }

    //Push the transaction to the pre_complete analysis port 
    sc_pre_complete_tlm_analysis_port.write(tlm_pkt);
    
    //Do the actual b_transport to forward the transaction
    //Note that the same tlm_time param is passed forward,as 
    //this component is just a passthrough and should not consume any tlm_time 
    sc_tlm_initiator->b_transport(tlm_pkt,tlm_time);
    
    //Push the transaction to the tlm_complete analysis port 
    sc_complete_tlm_analysis_port.write(tlm_pkt);

    //Check the callback class pointer before calling its callback methods
    if(tlm_cb_ptr != NULL){
        tlm_cb_ptr->post_btransport_cb(tlm_pkt,tlm_time);
    } else if ((tlm_cb_ptr == NULL) && (callback_pointer_set == 1)){
        //Error out, because the earlier set pointer is no longer valid,and got destroyed somehow.
        SC_REPORT_FATAL("B_TRANSPORT/POST_TRANSPORT_CB/FAILED","Callback class pointer provided for registration earlier is now NULL");
    }

}

#endif //_NVDLA_SCSV_SC_TLM_CHANNEL
