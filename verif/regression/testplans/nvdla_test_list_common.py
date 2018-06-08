import random
import project

def get_next_seed(min=1,max=100000):
    return random.randint(min, max)

def get_seed_args(min=1,max=100000):
    return " -rtlarg ' +ntb_random_seed=%d ' " % get_next_seed(min, max)

FIXED_SEED_ARG = " -rtlarg ' +ntb_random_seed=0 '"

# -----------------------------------------------------------------------------
# scoreboard comparing mode setting
#
# COMPARE MODE:
#  - "COMPARE_MODE_RTL_AHEAD"       : RTL send txn before CMOD (to let CMOD follows RTL's arbiter order in weight compression test)
#  - "COMPARE_MODE_RTL_GATING_CMOD" : Involve back-pressure to reduce memory resources occupasion.
#  - "COMPARE_MODE_LOOSE_COMPARE"   : CMOD generates all txns one time.
#  - "COMPARE_MODE_COUNT_TXN_ONLY"  : Do txn counting, don't push txn to queue.
#  - "COMPARE_MODE_DISABLE"         : Disable scoreboard
# -----------------------------------------------------------------------------

# =============================================================================
# CC
# =============================================================================

DISABLE_COMPARE_CDMA_SB_ARG = (" -rtlarg"
                               " '"
                               " +uvm_set_config_string=uvm_test_top,cdma_dat_pri_mem_request_compare_mode,COMPARE_MODE_DISABLE"
                               " +uvm_set_config_string=uvm_test_top,cdma_dat_pri_mem_response_compare_mode,COMPARE_MODE_DISABLE"
                               " +uvm_set_config_string=uvm_test_top,cdma_dat_sec_mem_request_compare_mode,COMPARE_MODE_DISABLE"
                               " +uvm_set_config_string=uvm_test_top,cdma_dat_sec_mem_response_compare_mode,COMPARE_MODE_DISABLE"
                               " +uvm_set_config_string=uvm_test_top,cdma_wt_pri_mem_request_compare_mode,COMPARE_MODE_DISABLE"
                               " +uvm_set_config_string=uvm_test_top,cdma_wt_pri_mem_response_compare_mode,COMPARE_MODE_DISABLE"
                               " +uvm_set_config_string=uvm_test_top,cdma_wt_sec_mem_request_compare_mode,COMPARE_MODE_DISABLE"
                               " +uvm_set_config_string=uvm_test_top,cdma_wt_sec_mem_response_compare_mode,COMPARE_MODE_DISABLE"
                               " '"
                               )

DISABLE_COMPARE_CSC_SB_ARG = (" -rtlarg"
                              " '"
                              " +uvm_set_config_string=uvm_test_top,csc_dat_a_compare_mode,COMPARE_MODE_DISABLE"
                              " +uvm_set_config_string=uvm_test_top,csc_dat_b_compare_mode,COMPARE_MODE_DISABLE"
                              " +uvm_set_config_string=uvm_test_top,csc_wt_a_compare_mode,COMPARE_MODE_DISABLE"
                              " +uvm_set_config_string=uvm_test_top,csc_wt_b_compare_mode,COMPARE_MODE_DISABLE"
                              " '"
                              )

DISABLE_COMPARE_CMAC_SB_ARG = (" -rtlarg"
                               " '"
                               " +uvm_set_config_string=uvm_test_top,cmac_a_compare_mode,COMPARE_MODE_DISABLE"
                               " +uvm_set_config_string=uvm_test_top,cmac_b_compare_mode,COMPARE_MODE_DISABLE"
                               " '"
                               )

DISABLE_COMPARE_CACC_SB_ARG = " -rtlarg +uvm_set_config_string=uvm_test_top,cacc_compare_mode,COMPARE_MODE_DISABLE"

DISABLE_COMPARE_CC_SB_ARG   = ( DISABLE_COMPARE_CDMA_SB_ARG
                              + DISABLE_COMPARE_CSC_SB_ARG
                              + DISABLE_COMPARE_CMAC_SB_ARG
                              + DISABLE_COMPARE_CACC_SB_ARG
                              )

# =============================================================================
# SDP
# =============================================================================

DISABLE_COMPARE_SDP2PDP_SB_ARG       = " -rtlarg '+uvm_set_config_string=uvm_test_top,sdp_compare_mode,COMPARE_MODE_DISABLE'"
DISABLE_COMPARE_SDP_PRI_MEM_SB_ARG   = " -rtlarg '+uvm_set_config_string=uvm_test_top,sdp_pri_mem_request_compare_mode,COMPARE_MODE_DISABLE'"
DISABLE_COMPARE_SDP_N_PRI_MEM_SB_ARG = " -rtlarg '+uvm_set_config_string=uvm_test_top,sdp_n_pri_mem_request_compare_mode,COMPARE_MODE_DISABLE'"
DISABLE_COMPARE_SDP_E_PRI_MEM_SB_ARG = " -rtlarg '+uvm_set_config_string=uvm_test_top,sdp_e_pri_mem_request_compare_mode,COMPARE_MODE_DISABLE'"
DISABLE_COMPARE_SDP_B_PRI_MEM_SB_ARG = " -rtlarg '+uvm_set_config_string=uvm_test_top,sdp_b_pri_mem_request_compare_mode,COMPARE_MODE_DISABLE'"
DISABLE_COMPARE_SDP_PRI_MEM_SB_ARG   += " -rtlarg '+uvm_set_config_string=uvm_test_top,sdp_pri_mem_response_compare_mode,COMPARE_MODE_DISABLE'"
DISABLE_COMPARE_SDP_N_PRI_MEM_SB_ARG += " -rtlarg '+uvm_set_config_string=uvm_test_top,sdp_n_pri_mem_response_compare_mode,COMPARE_MODE_DISABLE'"
DISABLE_COMPARE_SDP_E_PRI_MEM_SB_ARG += " -rtlarg '+uvm_set_config_string=uvm_test_top,sdp_e_pri_mem_response_compare_mode,COMPARE_MODE_DISABLE'"
DISABLE_COMPARE_SDP_B_PRI_MEM_SB_ARG += " -rtlarg '+uvm_set_config_string=uvm_test_top,sdp_b_pri_mem_response_compare_mode,COMPARE_MODE_DISABLE'"
DISABLE_COMPARE_SDP_SEC_MEM_SB_ARG   = " -rtlarg '+uvm_set_config_string=uvm_test_top,sdp_sec_mem_request_compare_mode,COMPARE_MODE_DISABLE'"
DISABLE_COMPARE_SDP_N_SEC_MEM_SB_ARG = " -rtlarg '+uvm_set_config_string=uvm_test_top,sdp_n_sec_mem_request_compare_mode,COMPARE_MODE_DISABLE'"
DISABLE_COMPARE_SDP_E_SEC_MEM_SB_ARG = " -rtlarg '+uvm_set_config_string=uvm_test_top,sdp_e_sec_mem_request_compare_mode,COMPARE_MODE_DISABLE'"
DISABLE_COMPARE_SDP_B_SEC_MEM_SB_ARG = " -rtlarg '+uvm_set_config_string=uvm_test_top,sdp_b_sec_mem_request_compare_mode,COMPARE_MODE_DISABLE'"
DISABLE_COMPARE_SDP_SEC_MEM_SB_ARG   += " -rtlarg '+uvm_set_config_string=uvm_test_top,sdp_sec_mem_response_compare_mode,COMPARE_MODE_DISABLE'"
DISABLE_COMPARE_SDP_N_SEC_MEM_SB_ARG += " -rtlarg '+uvm_set_config_string=uvm_test_top,sdp_n_sec_mem_response_compare_mode,COMPARE_MODE_DISABLE'"
DISABLE_COMPARE_SDP_E_SEC_MEM_SB_ARG += " -rtlarg '+uvm_set_config_string=uvm_test_top,sdp_e_sec_mem_response_compare_mode,COMPARE_MODE_DISABLE'"
DISABLE_COMPARE_SDP_B_SEC_MEM_SB_ARG += " -rtlarg '+uvm_set_config_string=uvm_test_top,sdp_b_sec_mem_response_compare_mode,COMPARE_MODE_DISABLE'"

DISABLE_COMPARE_SDP_SB_ARG = ( DISABLE_COMPARE_SDP2PDP_SB_ARG
                             + DISABLE_COMPARE_SDP_PRI_MEM_SB_ARG
                             + DISABLE_COMPARE_SDP_N_PRI_MEM_SB_ARG
                             + DISABLE_COMPARE_SDP_E_PRI_MEM_SB_ARG
                             + DISABLE_COMPARE_SDP_B_PRI_MEM_SB_ARG
                             + DISABLE_COMPARE_SDP_SEC_MEM_SB_ARG
                             + DISABLE_COMPARE_SDP_N_SEC_MEM_SB_ARG
                             + DISABLE_COMPARE_SDP_E_SEC_MEM_SB_ARG
                             + DISABLE_COMPARE_SDP_B_SEC_MEM_SB_ARG
                             )

# =============================================================================
# PDP
# =============================================================================

DISABLE_COMPARE_PDP_SB_ARG = (" -rtlarg"
                              " '"
                              " +uvm_set_config_string=uvm_test_top,pdp_pri_mem_response_compare_mode,COMPARE_MODE_DISABLE"
                              " +uvm_set_config_string=uvm_test_top,pdp_pri_mem_request_compare_mode,COMPARE_MODE_DISABLE"
                              " +uvm_set_config_string=uvm_test_top,pdp_sec_mem_request_compare_mode,COMPARE_MODE_DISABLE"
                              " +uvm_set_config_string=uvm_test_top,pdp_sec_mem_response_compare_mode,COMPARE_MODE_DISABLE"
                              " '"
                              )

# =============================================================================
# CDP
# =============================================================================

DISABLE_COMPARE_CDP_SB_ARG = (" -rtlarg"
                              " '"
                              " +uvm_set_config_string=uvm_test_top,cdp_sec_mem_request_compare_mode,COMPARE_MODE_DISABLE"
                              " +uvm_set_config_string=uvm_test_top,cdp_sec_mem_response_compare_mode,COMPARE_MODE_DISABLE"
                              " +uvm_set_config_string=uvm_test_top,cdp_pri_mem_response_compare_mode,COMPARE_MODE_DISABLE"
                              " +uvm_set_config_string=uvm_test_top,cdp_pri_mem_request_compare_mode,COMPARE_MODE_DISABLE"
                              " '"
                              )

# =============================================================================
# BDMA
# =============================================================================

DISABLE_COMPARE_BDMA_SB_ARG = (" -rtlarg"
                               " '"
                               " +uvm_set_config_string=uvm_test_top,bdma_sec_mem_request_compare_mode,COMPARE_MODE_DISABLE"
                               " +uvm_set_config_string=uvm_test_top,bdma_sec_mem_response_compare_mode,COMPARE_MODE_DISABLE"
                               " +uvm_set_config_string=uvm_test_top,bdma_pri_mem_request_compare_mode,COMPARE_MODE_DISABLE"
                               " +uvm_set_config_string=uvm_test_top,bdma_pri_mem_response_compare_mode,COMPARE_MODE_DISABLE"
                               " '"
                               )

# =============================================================================
# ALL UNITs
# =============================================================================
DISABLE_COMPARE_ALL_UNITS_SB_ARG = ( DISABLE_COMPARE_CC_SB_ARG
                                   + DISABLE_COMPARE_SDP_SB_ARG
                                   + DISABLE_COMPARE_PDP_SB_ARG
                                   + DISABLE_COMPARE_CDP_SB_ARG
                                   + DISABLE_COMPARE_BDMA_SB_ARG
                                   )
