# ===================================================================
# File: syn/scripts/dc_interactive.tcl
# NVDLA Open Source Project
# Reference synthesis methodology script for loading interactive session
# with Design Compiler. 
#
# Copyright (c) 2016 – 2017 NVIDIA Corporation. Licensed under the
# NVDLA Open Hardware License; see the "LICENSE.txt" file that came
# with this distribution for more information.
# ===================================================================
set ignore_tf_error      true

set synMsgInfo "Info:"
set synMsgErr  "Error:"
set synMsgWarn "Warning:"


# PROC: setVar => Utility proc to set flow variables 
# Env vars get highest priority, followed by TCL vars, followed by default vars.
proc setVar {var {default ""}} {
    global $var
    global synMsgInfo synMsgWarn
    if {[info exists ::env($var)]} {
        set $var $::env($var)
        puts "$synMsgInfo Setting $var from env, value = [set $var]"
    } elseif {[info exists $var]} {
        set $var [set $var]
        puts "$synMsgInfo Setting $var to [set $var]"
    } else {
        set $var $default
        puts "${synMsgWarn} Setting $var to default value \"[set $var]\""
        return
    }
}

setVar MW_DIR mw
setVar MODULE ""
setVar SYN_MODE wlm
setVar SEARCH_PATH "." 
setVar MW_LIB ""
setVar TF_FILE ""
setVar TLUPLUS_FILE ""
setVar TLUPLUS_MAPPING_FILE "" 
setVar DB_DIR ""
setVar RESTORE_DB ""
setVar LINK_LIB ""
setVar TARGET_LIB "" 
setVar MW_LIB ""

if { $RESTORE_DB == "" } {
    set RESTORE_DB "${DB_DIR}/${MODULE}.ddc"
}

# set up search paths
set mw_design_library ${MW_DIR}/${MODULE}_${SYN_MODE}.mw
set_app_var search_path "${SEARCH_PATH}"

# if in topo mode read milkyway libs
set mw_reference_library [list]
if {[shell_is_in_topographical_mode]} {
    set mw_reference_library $MW_LIB
}

# read all lib files.
set_app_var link_path $LINK_LIB
set_app_var target_library $TARGET_LIB
set_app_var mw_reference_library $mw_reference_library

if {[shell_is_in_topographical_mode]} {
    # remove mw first
    exec rm -rf ${MW_DIR}/${MODULE}_debug.mw
    # Create milkyway design database for block
    extend_mw_layers
    create_mw_lib -technology ${TF_FILE} -mw_reference_library $mw_reference_library -open ${MW_DIR}/${MODULE}_debug.mw
    set_tlu_plus_files -max_tluplus ${TLUPLUS_FILE} -min_tluplus ${TLUPLUS_FILE} -tech2itf_map ${TLUPLUS_MAPPING_FILE}
}

read_ddc $RESTORE_DB


