
# =============================================================================
# Seed CFG
# =============================================================================

seed_desc = '''
# ---------------------------------------------------------------------------------------
# Specify simulation seed, fix to 0 by default
# ---------------------------------------------------------------------------------------
'''

SEED_CFG = {
    '+ntb_random_seed=':
    'SEED: ? '
}

# =============================================================================
# Wave CFG
# =============================================================================

wave_desc = '''
# ---------------------------------------------------------------------------------------
# Enable/Disable(default) waveform dumpping
# ---------------------------------------------------------------------------------------
'''

WAVE_CFG = {
    '':
    'Dump waveform: [y/n]? '
}

# =============================================================================
# Verbosity CFG
# =============================================================================

verb_desc = '''
# ---------------------------------------------------------------------------------------
# Setting uvm_verbosity for information print level control
# Avaliable Level: 
#    UVM_NONE   : default level, almost no info, usually used in regression
#    UVM_LOW    : limited key info will be printed
#    UVM_MEDIUM : normal print level (suggested for debugging)
#    UVM_HIGH   : more detail info (txn info e.g.)(suggested for debugging)
#    UVM_FULL   : all uvm info will be printed (not recommand)
# ---------------------------------------------------------------------------------------
'''

VERBOSITY_CFG = {
    '+UVM_VERBOSITY=':
    'UVM verbosity: ? '
}

# =============================================================================
# Scoreboard CFG
# =============================================================================

sb_desc = '''
# ---------------------------------------------------------------------------------------
# scoreboard comparing mode setting
#
# COMPARE MODE:
#  [1] "COMPARE_MODE_RTL_AHEAD"       : RTL send txn before CMOD (to let CMOD follows 
#                                       RTL's arbiter order in weight compression test)
#  [2] "COMPARE_MODE_RTL_GATING_CMOD" : Involve back-pressure to reduce memory resources 
#                                       occupasion.
#  [3] "COMPARE_MODE_LOOSE_COMPARE"   : CMOD generates all txns one time.
#  [4] "COMPARE_MODE_COUNT_TXN_ONLY"  : Do txn counting, don't push txn to queue.
#  [5] "COMPARE_MODE_DISABLE"         : Disable scoreboard
#
# Default Mode:
#  [5] "COMPARE_MODE_DISABLE"
# ---------------------------------------------------------------------------------------
'''

def mode_val(idx):
    mode_dict = {
        '1': 'COMPARE_MODE_RTL_AHEAD',
        '2': 'COMPARE_MODE_RTL_GATING_CMOD',
        '3': 'COMPARE_MODE_LOOSE_COMPARE',
        '4': 'COMPARE_MODE_COUNT_TXN_ONLY',
        '5': 'COMPARE_MODE_DISABLE',
    }
    return(mode_dict[idx])

# =============================================================================
# CC Scoreboard
# =============================================================================

CDMA_SB_CFG = {
    '+uvm_set_config_string=uvm_test_top,cdma_dat_pri_mem_request_compare_mode,':
    'Scoreboard CDMA_DAT_PRI_MEM_REQ Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,cdma_dat_pri_mem_response_compare_mode,':
    'Scoreboard CDMA_DAT_PRI_MEM_RSP Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,cdma_dat_sec_mem_request_compare_mode,':
    'Scoreboard CDMA_DAT_SEC_MEM_REQ Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,cdma_dat_sec_mem_response_compare_mode,':
    'Scoreboard CDMA_DAT_SEC_MEM_RSP Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,cdma_wt_pri_mem_request_compare_mode,':
    'Scoreboard CDMA_WT_PRI_MEM_REQ  Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,cdma_wt_pri_mem_response_compare_mode,':
    'Scoreboard CDMA_WT_PRI_MEM_RSP  Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,cdma_wt_sec_mem_request_compare_mode,':
    'Scoreboard CDMA_WT_SEC_MEM_REQ  Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,cdma_wt_sec_mem_response_compare_mode,':
    'Scoreboard CDMA_WT_SEC_MEM_RSP  Mode: [1~5]? ',
}

CSC_SB_CFG = {
    '+uvm_set_config_string=uvm_test_top,csc_dat_a_compare_mode,':
    'Scoreboard CSC_DAT_A            Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,csc_dat_b_compare_mode,':
    'Scoreboard CSC_DAT_B            Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,csc_wt_a_compare_mode,':
    'Scoreboard CSC_WT_A             Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,csc_wt_b_compare_mode,':
    'Scoreboard CSC_WT_B             Mode: [1~5]? ',
}

CMAC_SB_CFG = {
    '+uvm_set_config_string=uvm_test_top,cmac_a_compare_mode,':
    'Scoreboard CMAC_A               Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,cmac_b_compare_mode,':
    'Scoreboard CMAC_B               Mode: [1~5]? ',
}    

CACC_SB_CFG = {
    '+uvm_set_config_string=uvm_test_top,cacc_compare_mode,':
    'Scoreboard CACC                 Mode: [1~5]? ',
}    

# =============================================================================
# SDP Scoreboard
# =============================================================================

SDP_SB_CFG = {
    '+uvm_set_config_string=uvm_test_top,sdp_compare_mode,':
    'Scoreboard SDP                  Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,sdp_pri_mem_request_compare_mode,':
    'Scoreboard SDP_PRI_MEM_REQ      Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,sdp_n_pri_mem_request_compare_mode,':
    'Scoreboard SDP_N_PRI_MEM_REQ    Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,sdp_e_pri_mem_request_compare_mode,':
    'Scoreboard SDP_E_PRI_MEM_REQ    Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,sdp_b_pri_mem_request_compare_mode,':
    'Scoreboard SDP_B_PRI_MEM_REQ    Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,sdp_pri_mem_response_compare_mode,':
    'Scoreboard SDP_PRI_MEM_RSP      Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,sdp_n_pri_mem_response_compare_mode,':
    'Scoreboard SDP_N_PRI_MEM_RSP    Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,sdp_e_pri_mem_response_compare_mode,':
    'Scoreboard SDP_E_PRI_MEM_RSP    Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,sdp_b_pri_mem_response_compare_mode,':
    'Scoreboard SDP_B_PRI_MEM_RSP    Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,sdp_sec_mem_request_compare_mode,':
    'Scoreboard SDP_SEC_MEM_REQ      Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,sdp_n_sec_mem_request_compare_mode,':
    'Scoreboard SDP_N_SEC_MEM_REQ    Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,sdp_e_sec_mem_request_compare_mode,':
    'Scoreboard SDP_E_SEC_MEM_REQ    Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,sdp_b_sec_mem_request_compare_mode,':
    'Scoreboard SDP_B_SEC_MEM_REQ    Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,sdp_sec_mem_response_compare_mode,':
    'Scoreboard SDP_SEC_MEM_RSP      Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,sdp_n_sec_mem_response_compare_mode,':
    'Scoreboard SDP_N_SEC_MEM_RSP    Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,sdp_e_sec_mem_response_compare_mode,':
    'Scoreboard SDP_E_SEC_MEM_RSP    Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,sdp_b_sec_mem_response_compare_mode,':
    'Scoreboard SDP_B_SEC_MEM_RSP    Mode: [1~5]? ',
}

# =============================================================================
# PDP Scoreboard
# =============================================================================

PDP_SB_CFG = {
    '+uvm_set_config_string=uvm_test_top,pdp_pri_mem_request_compare_mode,':
    'Scoreboard PDP_PRI_MEM_REQ      Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,pdp_pri_mem_response_compare_mode,':
    'Scoreboard PDP_PRI_MEM_RSP      Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,pdp_sec_mem_request_compare_mode,':
    'Scoreboard PDP_SEC_MEM_REQ      Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,pdp_sec_mem_response_compare_mode,':
    'Scoreboard PDP_SEC_MEM_RSP      Mode: [1~5]? ',
}

# =============================================================================
# CDP Scoreboard 
# =============================================================================

CDP_SB_CFG = {
    '+uvm_set_config_string=uvm_test_top,cdp_pri_mem_request_compare_mode,':
    'Scoreboard CDP_PRI_MEM_REQ      Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,cdp_pri_mem_response_compare_mode,':
    'Scoreboard CDP_PRI_MEM_RSP      Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,cdp_sec_mem_request_compare_mode,':
    'Scoreboard CDP_SEC_MEM_REQ      Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,cdp_sec_mem_response_compare_mode,':
    'Scoreboard CDP_SEC_MEM_RSP      Mode: [1~5]? ',
}

# =============================================================================
# BDMA Scoreboard
# =============================================================================

BDMA_SB_CFG = {
    '+uvm_set_config_string=uvm_test_top,bdma_pri_mem_request_compare_mode,':
    'Scoreboard BDMA_PRI_MEM_REQ     Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,bdma_pri_mem_response_compare_mode,':
    'Scoreboard BDMA_PRI_MEM_RSP     Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,bdma_sec_mem_request_compare_mode,':
    'Scoreboard BDMA_SEC_MEM_REQ     Mode: [1~5]? ',
    '+uvm_set_config_string=uvm_test_top,bdma_sec_mem_response_compare_mode,':
    'Scoreboard BDMA_SEC_MEM_RSP     Mode: [1~5]? ',
}

# =============================================================================
# ALL UNITs Scoreboard
# =============================================================================

SB_CFG = { **CDMA_SB_CFG, 
           **CSC_SB_CFG,
           **CMAC_SB_CFG,
           **CACC_SB_CFG,
           **SDP_SB_CFG,
           **PDP_SB_CFG,
           **CDP_SB_CFG,
           **BDMA_SB_CFG
         }


def arg_gen():
    arg_list = []
    cfg_dict = {}
    print(seed_desc)
    for key,val in SEED_CFG.items():
        seed = input(val) or '0' 
        arg_list.append(key+seed)
    print(wave_desc)
    for key,val in WAVE_CFG.items():
        if input(val) in ['y','Y','yes','YES']:
            wave = '+wave'
            arg_list.append(key+wave)
    print(verb_desc)
    for key,val in VERBOSITY_CFG.items():
        verb = input(val) or 'UVM_NONE' 
        arg_list.append(key+verb)
    print(sb_desc)
    for key,val in SB_CFG.items():
        sel = input(val) or '5'
        arg_list.append(key+mode_val(sel))
    sim_args = ' '.join(arg_list)
    #print('CFG: '+sim_args)
    return ' '+sim_args+' '

