# ===================================================================
# File: syn/scripts/dc_run.tcl
# NVDLA Open Source Project
# Reference synthesis methodology script for Design Compiler
#
# Copyright (c) 2016 – 2017 NVIDIA Corporation. Licensed under the
# NVDLA Open Hardware License; see the "LICENSE.txt" file that came
# with this distribution for more information.
# ===================================================================

# =====================
# Setup variables/procs
# =====================

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

# PROC: profileSystem => Print general machine information. 
proc profileSystem {} {
    global env tcl_platform synMsgInfo

    puts "${synMsgInfo} date = [clock format [clock seconds] -format {%c}]"
    puts "${synMsgInfo} cwd = [pwd]"
    set myHost [info hostname]
    puts "${synMsgInfo} executing on $myHost"
    exec lsb_release -idrc
    exec lscpu
}

# PROC: writeReports => Common reporting proc. 
proc writeReports {{prefix "default"}} {
    global synMsgInfo
    global REPORT_DIR MODULE
    set syn_report_max_paths               50
    set syn_report_nworst                  5
    set syn_report_simple                  0
    set path_graph_max_paths 10000
    set syn_report_flags   "-input_pins -nets"
    set timing_flags [concat -nosplit -nworst $syn_report_nworst -max_paths $syn_report_max_paths -significant_digits 4 -attribute]
    if { [shell_is_in_topographical_mode] } {
        set timing_flags [concat $timing_flags -nets -physical -trans -cap] 
    }
    if {[info exists syn_report_flags]} {
        set timing_flags [concat $timing_flags $syn_report_flags]
    }

    set module_report ${REPORT_DIR}/${MODULE}.${prefix}.report
    suppress_message [list "TIM-175"]
    redirect $module_report { report_qor -significant_digits 4 }
    unsuppress_message [list "TIM-175"]
    redirect -append $module_report { eval { report_timing } $timing_flags }
    redirect -append $module_report { report_constraint -all -sig 4 -nosplit }
    if { [shell_is_in_topographical_mode] } {
	    redirect -append $module_report { report_congestion }
    }
    redirect -append $module_report { report_resources -hierarchy }
    redirect -append $module_report { report_clock -nosplit }
    redirect -append $module_report { report_clock -skew -nosplit }
    redirect -append $module_report { eval report_power -nosplit }
    redirect -append $module_report { report_threshold_voltage_group }
    #redirect -append $module_report { nvSynGeneral::reportLibAttributes }
    redirect -append $module_report { report_design }
    redirect -append $module_report { report_reference -hierarchy }

}

# =================
# ===== BEGIN =====
# =================
# Print some information on host OS and resources
profileSystem

# Print env snapshot into the log
foreach key [array names env] {
    global synMsgInfo
	puts "${synMsgInfo} (ENV) $key = $env($key)"
}

# SYN_MODE: "wlm" (wireload model - DEFAULT) , "dcg" (physical, using -spg) or "de" (physical, using Design Explorer)
setVar SYN_MODE wlm

# Name of top-level design
setVar MODULE

# Directories
setVar CONS_DIR cons
setVar DB_DIR db
setVar LOG_DIR log
setVar REPORT_DIR report
setVar NET_DIR net
setVar FV_DIR fv
setVar MW_DIR mw
setVar DLIB_DIR design_lib
setVar DEF_DIR def
setVar SCRIPTS_DIR scripts
setVar SEARCH_PATH "."
setVar RTL_EXTENSIONS ".v .sv .gv"
setVar SAIF_FILE ""
setVar TB_PATH "top.nvdla_top"
setVar INSTANCE ""

proc verilog_inst_to_dc_inst { inst_path } {
    return [regsub -all {\.} $inst_path "/"]
}


# Dont proceed if you cant find the scripts directory for app vars and other settings. 
if {![file exists $SCRIPTS_DIR]} {
   puts "${synMsgErr} Unable to proceed, please specify SCRITPS_DIR. "
   exit 1
}

# Extensions
setVar DB_EXT ddc
setVar NET_EXT gv
setVar SDC_VER "1.7"

# Library settings
setVar TARGET_LIB ""
setVar LINK_LIB ""
setVar MW_LIB ""
setVar TF_FILE
setVar TLUPLUS_FILE
setVar TLUPLUS_MAPPING_FILE
setVar DONT_USE_LIST ""
setVar MIN_ROUTING_LAYER ""
setVar MAX_ROUTING_LAYER ""
setVar CLOCK_GATING_CELL ""
setVar DONT_UNGROUP_LIST ""
setVar HORIZONTAL_LAYERS ""
setVar VERTICAL_LAYERS ""

setVar QA_MODE ""

if {[shell_is_in_exploration_mode]} {
    set de_log_html_filename ${LOG_DIR}/${MODULE}_de.html
}

set_app_var link_path ${LINK_LIB}
set_app_var target_library ${TARGET_LIB}
set library_name [file rootname [file tail [lindex ${TARGET_LIB} 0]]]


# SVF, to guide Formality
set_svf ${FV_DIR}/${MODULE}/${MODULE}.svf
puts "${synMsgInfo} Setting SVF to  ${FV_DIR}/${MODULE}/${MODULE}.svf"

# Start keeping track of name changes
saif_map -start


# Misc Synthesis recipe variables
setVar DC_NUM_CORES 1; # Assume calling scripts sets this up correctly
setVar TIGHTEN_CGE 1; # Choose whether or not to overconstrain CG enable paths. 
set suppress_errors "VER-130 UID-95"

set_host_options -max_cores ${DC_NUM_CORES}

# Set up some application vars
if {[file exists "${SCRIPTS_DIR}/dc_app_vars.tcl"]} {
    puts "${synMsgInfo} Sourcing ${SCRIPTS_DIR}/dc_app_vars.tcl"
    source -echo -verbose ${SCRIPTS_DIR}/dc_app_vars.tcl
}

# Make DC-G use the track definitions and not fill in the gaps with more routing resource!
#set_route_zrt_common_options -track_auto_fill false

# force all reporting into work directory  (issue NV_GR_GPMSD_pri_target)
define_design_lib WORK -path     ${DLIB_DIR}/${MODULE}/work
set alib_library_analysis_path   ${DLIB_DIR}/${MODULE}

# Read logical/timing libs
puts "${synMsgInfo} Read library and create alib"
read_file -format db $target_library


# Search path
set_app_var search_path "${SEARCH_PATH}"

# ungroup the clock gate level of hierarchy
set power_cg_flatten true


######################
## Section : synthesis
#####################
setVar RTL_DEPS ""
set vcsOpt "{-f $RTL_DEPS}"
catch {eval {analyze -format sverilog -work WORK} -vcs $vcsOpt} analyzeStatus
if { $analyzeStatus != 1 } {
    puts "${synMsgErr} Analyze failed!  Aborting..."
    exit 1
}

# Elaborate and switch design to current block.
elaborate ${MODULE}
current_design ${MODULE}


# Libraries for physical synthesis
# remove mw first
if {[shell_is_in_exploration_mode]} {
    if {[ file exists ${MW_DIR}/${MODULE}_de.mw]} {
        exec rm -rf ${MW_DIR}/${MODULE}_de.mw
    }
} else {
	if {[ file exists ${MW_DIR}/${MODULE}_dcg.mw]} {
    	exec rm -rf ${MW_DIR}/${MODULE}_dcg.mw
	}
}
if {[shell_is_in_topographical_mode]} {
 set mw_logic1_net "VDD"
 set mw_logic0_net "VSS"
}


set mw_reference_library [list]
if {[shell_is_in_topographical_mode]} {
    set mw_reference_library ${MW_LIB}
	set_app_var mw_reference_library $mw_reference_library
    
    # Create milkyway design database for block
    extend_mw_layers
	if {[shell_is_in_exploration_mode]} {
    	create_mw_lib -technology ${TF_FILE} -mw_reference_library $mw_reference_library -open ${MW_DIR}/${MODULE}_de.mw
	} else {
		create_mw_lib -technology ${TF_FILE} -mw_reference_library $mw_reference_library -open ${MW_DIR}/${MODULE}_dcg.mw
	}
    # read technology files
    set_tlu_plus_files -max_tluplus ${TLUPLUS_FILE} -min_tluplus ${TLUPLUS_FILE} -tech2itf_map ${TLUPLUS_MAPPING_FILE}
    redirect -file ${REPORT_DIR}/itf_check.rpt { check_tlu_plus_files }
	redirect -file ${REPORT_DIR}/lib_report.rpt { report_lib $library_name }

    if { ${HORIZONTAL_LAYERS} != "" } {
        set_preferred_routing_direction -layers "$HORIZONTAL_LAYERS" -direction horizontal 
    }
    if { ${VERTICAL_LAYERS} != "" } {
        set_preferred_routing_direction -layers "$VERTICAL_LAYERS" -direction vertical 
    }
    
}




if ![ link ] {
    puts "${synMsgErr} Failed to link. Aborting..."
    exit 1
}

if {$QA_MODE == "link_only"} {
    puts "${synMsgInfo} Design linked successfully. Exiting gracefully."
    exit 0
}

puts "${synMsgInfo} Analyze alibs"
alib_analyze_libs

# Write out a DDC at this point. 
write -f ddc -hier -o ${DB_DIR}/${MODULE}.elaborated.ddc

# Set wireload model
setVar WIRELOAD_MODEL_NAME ""
setVar WIRELOAD_MODEL_FILE ""
if {![shell_is_in_topographical_mode] && ![shell_is_in_exploration_mode]} {
    if { $WIRELOAD_MODEL_FILE != "" } {
        update_lib $library_name $WIRELOAD_MODEL_FILE -no_warnings
        puts "${synMsgInfo} Reading in wireload model file $WIRELOAD_MODEL_FILE ..."
    }
    if { $WIRELOAD_MODEL_NAME != ""} {
        set_wire_load_model  -name $WIRELOAD_MODEL_NAME
        set_wire_load_mode   top
        puts "${synMsgInfo} Setting wireload model to $WIRELOAD_MODEL_NAME"
    }
}


# Set dont use on user cells
if {[info exists DONT_USE_LIST] && (${DONT_USE_LIST} != "")} {
    set list_du [list]
	foreach tempCelltLib ${DONT_USE_LIST} {
        set detectLibCells [get_lib_cells -regexp -quiet ".*/${tempCelltLib}"]
        if { [sizeof_collection $detectLibCells] > 0 } {
			foreach_in_collection cell $detectLibCells {
                lappend list_du [get_object_name $cell]
	            puts "${synMsgInfo} Putting dont_use attributes on [get_object_name $cell]"
            }
        }
    }
	set_dont_use $list_du
}

# Connect const port to inv to avoid having shorted ports
set_fix_multiple_port_nets -all -buffer_constants [get_designs *] 


# Read in a floorplan/macro placement TCL , and set up min/max routing layers if specified
if {[shell_is_in_topographical_mode]} {
    if {[file exists "${DEF_DIR}/${MODULE}.def"]} {
		puts "${synMsgInfo} Reading input floorplan file ${DEF_DIR}/${MODULE}.def"
		extract_physical_constraints -verbose "${DEF_DIR}/${MODULE}.def"
        report_physical_constraints
	} else {
		puts "${synMsgWarn} No DEF file found. Continuing without defnining a floorplan."
	}
    
    # source the macro placement file if it exists
	if {[info exists CONS_DIR] && [file exists "${CONS_DIR}/${MODULE}.macroplacement.tcl"]} {
		source -echo -verbose ${CONS_DIR}/${MODULE}.macroplacement.tcl
	} else {
		puts "${synMsgWarn} No macro placement file found. Continuing without defnining a floorplan."
	}
	
    if {[info exists MAX_ROUTING_LAYER] && ${MAX_ROUTING_LAYER} != "" && [info exists MIN_ROUTING_LAYER] && ${MIN_ROUTING_LAYER} != "" } {
		puts "${synMsgInfo} Min/max routing layers specified - ${MIN_ROUTING_LAYER}/${MAX_ROUTING_LAYER}"
		set_ignored_layers -min_routing_layer ${MIN_ROUTING_LAYER} -max_routing_layer ${MAX_ROUTING_LAYER}
	}	
}

# Clock gating command
set power_cg_auto_identify  true
#if {[info exiists CLOCK_GATING_CELL] && ${CLOCK_GATING_CELL} != ""} {
#    set_clock_gating_style -sequential_cell latch -positive_edge_logic integrated:${CLOCK_GATING_CELL} -max_fanout 1000000000 -minimum_bitwidth 4 -control_point before -control_signal scan_enable
#}


# Latest constraints file SDC/cons
# source SDC file
if  {[info exists CONS_DIR] && [file exists "${CONS_DIR}/${MODULE}.sdc"]} {
    puts "${synMsgInfo} Reading input SDC ${CONS_DIR}/${MODULE}.sdc using \"read_sdc\""
	read_sdc "${CONS_DIR}/${MODULE}.sdc"
}

if  {[info exists CONS_DIR] && [file exists "${CONS_DIR}/${MODULE}.tcl"]} {
    puts "${synMsgInfo} Reading additional (non-SDC) constraints from ${CONS_DIR}/${MODULE}.tcl using \"source\""
	source -echo -verbose "${CONS_DIR}/${MODULE}.tcl"
} 
 
# Tighten synthesis constraints for enable signals to clock gates
setVar CGLUT_FILE ""
if {![shell_is_in_exploration_mode]} {
    if { ${TIGHTEN_CGE} == 1 && [file exists $CGLUT_FILE]  } {
        puts "${synMsgInfo} Start tighten_cg_enable_constraints"
        # Reset all the clock gate latency apply in sdc
        reset_clock_gate_latency
    	source $CGLUT_FILE
    	set i 1
    	set size [llength [array names timingDeltaTableForCgEnable]]
    	set end_1st [expr $size/2]
    	set start_2nd [expr $end_1st + 1]
    	foreach tableIndex [lsort -integer [array names timingDeltaTableForCgEnable]] {
            if { $i=="1" } {
    			set lat [expr 1.0 * $timingDeltaTableForCgEnable($tableIndex) / 1000.0]
    			set start 1
    		} elseif { $i < "$end_1st"} {
    			set end [expr $tableIndex -1]
    			set fanoutTable($i) "${start}-${end} -${lat}"
    			set start $tableIndex
    			set lat [expr 1.0 * $timingDeltaTableForCgEnable($tableIndex) / 1000.0]
    		} elseif {$i == "$end_1st"} {
    			set fanoutTable($i) "${start}-inf -${lat}"
    			set start $tableIndex
    			set lat [expr 1.0 * $timingDeltaTableForCgEnable($tableIndex) / 1000.0]
    		} elseif {$i == "$size"} {
    			set end [expr $tableIndex -1]
    			set fanoutTable2nd($i) "${start}-${end} -${lat}"
    			set start $tableIndex
    			set lat [expr 1.0 * $timingDeltaTableForCgEnable($tableIndex) / 1000.0]
    		} elseif {$i > "$end_1st"} {
    			set end [expr $tableIndex -1]
    			set fanoutTable2nd($i) "${start}-${end} -${lat}"
    			set start $tableIndex
    			set lat [expr 1.0 * $timingDeltaTableForCgEnable($tableIndex) / 1000.0]
    		}
    		incr i 
        }
    	set fanoutTable2nd($i) "${start}-inf -${lat}"
    	puts "set_clock_gate_latency -stage 0 -fanout_latency {1-inf 0} -overwrite"
    	set_clock_gate_latency -stage 0 -fanout_latency {1-inf 0} -overwrite
    	set i 0
    	foreach fanout_lat [lsort -integer [array names fanoutTable]] {
    		if {$i == "0"} {
    			set fanout_latency "$fanoutTable($fanout_lat)"
    			incr i
    		} else {
    			set fanout_latency "$fanout_latency, $fanoutTable($fanout_lat)"
    		}
    	}
    	set i 0
    	foreach fanout_lat [lsort -integer [array names fanoutTable2nd]] {
    		if {$i == "0"} {
    			set fanout_latency2nd "$fanoutTable2nd($fanout_lat)"
    			incr i
    		} else {
    			set fanout_latency2nd "$fanout_latency2nd, $fanoutTable2nd($fanout_lat)"
    		}
    	}
    	
    	puts "set_clock_gate_latency -stage 1 -fanout_latency {$fanout_latency} -overwrite"
    	set_clock_gate_latency -stage 1 -fanout_latency "$fanout_latency" -overwrite
    	puts "set_clock_gate_latency -stage 2 -fanout_latency {$fanout_latency2nd} -overwrite"
    	set_clock_gate_latency -stage 2 -fanout_latency "$fanout_latency2nd" -overwrite
    }
}


# Prevent ungrouping of specific hierarchies
if {[info exists DONT_UNGROUP_LIST] && ${DONT_UNGROUP_LIST} != ""} {
    set retVal {}
    foreach single_design $DONT_UNGROUP_LIST {
        set gdCmd1 "get_designs \"$single_design\""
        set gdList1 [eval $gdCmd1]
        if { [sizeof_collection $gdList1] > 0 } {
            set retVal [add_to_collection $retVal $gdList1]
        }
        set gdCmd2 "get_designs \"*\" -filter \"((defined(@original_design_name) && @original_design_name=~${single_design}) || (defined(@hdl_template) && @hdl_template=~${single_design})) \""
        set gdList2 [eval $gdCmd2]
        if { [sizeof_collection $gdList2] > 0 } {
        	set retVal [add_to_collection $retVal $gdList2 -unique]
        }
    }
    foreach_in_collection local_design $retVal {
        puts "Setting ungroup and boundary_optimization to false for [get_object_name $local_design]"
        set_ungroup 			   [get_object_name $local_design] false
        set_boundary_optimization  [get_object_name $local_design] false
    }
    if { [sizeof_collection $retVal]} {
        if {[shell_is_in_topographical_mode] && ![shell_is_in_exploration_mode]} {
           puts " Also calling set_ahfs_options command to prevent certain forms of boundary optimization"
           set_ahfs_options -preserve_boundary_phase true -no_port_punching $retVal
       }
    }
}

# Ungroup for area reduction
setVar AREA_RECOVERY 1
if {[info exists AREA_RECOVERY] && ${AREA_RECOVERY} == 1} {
	set_cost_priority {max_design_rules}
	set_max_area 0.0
}

# Optional: Retiming (using the set_optimize_registers command recommended by Synopsys)
setVar RETIME_LIST ""
setVar RETIME_TRANSFORM "multiclass"
setVar RETIME_JUSTIFICATION_EFFORT "high"
if {[info exists RETIME_LIST] && $RETIME_LIST != ""} {
    foreach pattern $RETIME_LIST {
        set retimeDesign [lindex [split $pattern ":"] 0]
        set retimeClock [lindex [split $pattern ":"] 1]
        set retimeColl {}
        append_to_collection retimeColl [get_designs -q $retimeDesign]
        # Also handle cases where the design names have been uniquified. 
        append_to_collection retimeColl [get_designs -q -filter "((defined(@original_design_name) && @original_design_name=~${retimeDesign}) || (defined(@hdl_template) && @hdl_template=~${retimeDesign}))"]
        set retimeColl [add_to_collection -unique $retimeColl {}]   
        if {[sizeof_collection $retimeColl]} {
            set retimeList [get_object_name $retimeColl]
            puts "${synMsgInfo} Retiming enabled for design $retimeDesign"
            set optregCmd "set_optimize_registers -design \"$retimeList\" -clock $retimeClock true -sync_transform $RETIME_TRANSFORM -async_transform $RETIME_TRANSFORM -print_critical_loop -check_design -verbose -justification_effort $RETIME_JUSTIFICATION_EFFORT"
            puts "Running command: \n$optregCmd"
            eval $optregCmd
        }
    }
}

write -f ddc -hier -o ${DB_DIR}/${MODULE}.precompile.ddc


# Compile commands
set compile_command ""
if {[shell_is_in_topographical_mode] && ${SYN_MODE} == "dcg" && ![shell_is_in_exploration_mode]} {
	set compile_command "compile_ultra -no_seq_output_inversion  -gate_clock -spg -scan"
} elseif {[shell_is_in_topographical_mode] && ![shell_is_in_exploration_mode]} {
	set compile_command "compile_ultra -no_seq_output_inversion  -gate_clock -scan"
} elseif {[shell_is_in_exploration_mode]} {
    set compile_command "compile_exploration  -no_seq_output_inversion -gate_clock"
}  else {
    set compile_command "compile_ultra -no_seq_output_inversion -no_autoungroup -scan"
}

puts "${synMsgInfo} Structuring from scratch with compile command: $compile_command"
eval $compile_command

# Dump database and generate reports 
write -f ddc -hier -o ${DB_DIR}/${MODULE}.preincr.ddc
writeReports "preincr"

setVar INCREMENTAL_RECOMPILE_COUNT 0
if {![shell_is_in_exploration_mode]} {
    set incr_recompile_command "${compile_command} -incremental" 
    for { set currentIncrRecompilePass 0 } { $currentIncrRecompilePass < $INCREMENTAL_RECOMPILE_COUNT  } { incr currentIncrRecompilePass } {
        puts "${synMsgInfo} Incrementally recompiling (PASS [expr $currentIncrRecompilePass + 1] ), with command: $incr_recompile_command"
        eval $incr_recompile_command
        
        # Dump database and generate reports 
        write -f ddc -hier -o ${DB_DIR}/${MODULE}.postincr.[expr $currentIncrRecompilePass + 1].ddc
        writeReports "postincr.[expr $currentIncrRecompilePass + 1]"
    }
} else {
    puts "${synMsgInfo} Incremental compiles are not supported in Design Explorer. Skipping" 
}

# Make sure DC-inserted CG hierarchy is ungrouped.
set power_cg_flatten true
ungroup -all -flatten  

# Run area recovery
if {![shell_is_in_exploration_mode]} {
    if {[info exists AREA_RECOVERY] && $AREA_RECOVERY ==1 } {
	optimize_netlist -area
    }
}

# Dump all design collaterals
write -f ddc -hier -o ${DB_DIR}/${MODULE}.ddc
write_sdc -nosplit ${NET_DIR}/${MODULE}.sdc 
write -format verilog -hierarchy -out ${NET_DIR}/${MODULE}.gv
# Invoking write_def commands requires a Design Compiler Graphical license or an IC Compiler
if {[shell_is_in_topographical_mode] && ($SYN_MODE == "dcg")} {
	write_def -output ${NET_DIR}/${MODULE}.full.def -all_vias -routed_nets -vias -components -specialnets -pins -blockages
}

# Generate final reports
writeReports "final"
redirect ${REPORT_DIR}/${MODULE}.check_design { check_design }
redirect ${REPORT_DIR}/${MODULE}.check_timing { check_timing }

# Stop recording the SVF. 
set_svf -off

# Write a name map 
if { ${SAIF_FILE} != "" } {
    foreach instance $INSTANCE {
        saif_map -create_map -input ${SAIF_FILE} -source_instance [verilog_inst_to_dc_inst "${TB_PATH}.${instance}"]
        saif_map -write_map ${REPORT_DIR}/${MODULE}.${instance}.saif.name_map -type ptpx
    }
}

# Write Parasitics
write_parasitics -output ${REPORT_DIR}/${MODULE}.spef -format reduced
write_parasitics -output ${REPORT_DIR}/${MODULE}.parasitics.tcl -script
write_sdf -significant_digits 4 ${REPORT_DIR}/${MODULE}.sdf

# Print out summary of generated design collateral
puts "${synMsgInfo} GENERATED NETLIST: ${NET_DIR}/${MODULE}.gv"
puts "${synMsgInfo} GENERATED DEF:     ${NET_DIR}/${MODULE}.full.def"
puts "${synMsgInfo} GENERATED SDC:     ${NET_DIR}/${MODULE}.sdc"
puts "${synMsgInfo} GENERATED DDC:     ${DB_DIR}/${MODULE}.ddc"
puts "${synMsgInfo} GENERATED REPORTS: \n\t[join [glob "${REPORT_DIR}/*${MODULE}*"] "\n\t"]"


# Close the MW libs
if {[shell_is_in_topographical_mode]} {
    close_mw_lib 
}

# finish
exit

