#ifndef _NVDLA_SCSV_SC_TLM_CB
#define _NVDLA_SCSV_SC_TLM_CB

#include <string>
#include <systemc.h>
#include <tlm.h>

using namespace std;
using namespace sc_core;
using namespace tlm;

/*! \class nvdla_scsv_sc_tlm_callbacks
    \brief This is the SystemC side abstract callback class for the SC-SV Language converters 

    This class contains the SystemC side pre and post b_transport callback methods.
    The user would derive from this class, implement the abstract methods and use the \c register_tlm_callbacks method in the connector class

    The expected usecase for these callbacks is to insert code where the user might
    need to manipulate the transaction to ensure smooth operation with the other
    connected components
 */
template <class T >
class nvdla_scsv_sc_tlm_callbacks : public sc_module{
    public:
        /// Constructor
        nvdla_scsv_sc_tlm_callbacks(sc_module_name name):sc_module(name){ 
        }

        /// \brief pre_btransport_cb is the callback that will be triggered before the connector forwards the transaction.
        /// \param tlm_pkt This is a handle to the payload being transported via the socket
        /// \param tlm_time The time delay that was communicated as part of the initial b_transport call from the parent initiator 
        virtual void pre_btransport_cb(T &tlm_pkt, sc_time &tlm_time) = 0;

        /// \brief pre_btransport_cb is the callback that will be triggered before the connector forwards the transaction.
        /// \param tlm_pkt This is a handle to the payload being transported via the socket
        /// \param tlm_time The time delay that was communicated as part of the initial b_transport call from the parent initiator
        virtual void post_btransport_cb(T &tlm_pkt, sc_time &tlm_time) = 0;

};

#endif //NVDLA_SCSV_SC_TLM_CB
