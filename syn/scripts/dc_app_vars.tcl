# ===================================================================
# File: syn/scripts/dc_app_vars.tcl
# NVDLA Open Source Project
# Reference application variables for Design Compiler to get the 
# best QoR with Design Compiler. 
#
# Copyright (c) 2016 – 2017 NVIDIA Corporation. Licensed under the
# NVDLA Open Hardware License; see the "LICENSE.txt" file that came
# with this distribution for more information.
# ===================================================================

# HDL Compiler settings
set hdl_preferred_license                       verilog
set hdlin_preserve_sequential                   true
set hdlin_check_no_latch		                true
set hdlin_enable_rtldrc_info                    false
set hdlin_infer_hdlc_compliant_set_reset        true
set hdlin_remove_set_reset_from_activation      true
set hdlin_infer_complex_enable                  true
set hdlin_no_group_register                     true
set hdlin_vhdl93_concat                         TRUE

# Allow PG pins connected in RTL.
set dc_allow_rtl_pg                 true
set mv_allow_upf_cells_without_upf  true
set_app_var mv_upf_tracking false

# Allow reset timing analysis
set enable_recovery_removal_arcs	  true

# Variables affecting wall time of compilations vs quality
set compile_limit_down_sizing			     false  
set compile_use_fast_sequential_mode		     false
set timing_enable_multiple_clocks_per_reg true
set timing_disable_data_checks false
set_app_var sh_continue_on_error false
set timing_separate_clock_gating_group true
set ignore_tf_error      true

# Design naming styles
# set template_naming_style			   "%s_%p_${module}"
set template_parameter_style			 %d
set template_separator_style			 _
set port_complement_naming_style		 %s_

# Verilog output 
set verilogout_higher_designs_first		 false
set verilogout_no_tri				 true
set verilogout_equation 			 false
set verilogout_single_bit			 false
set write_name_nets_same_as_ports		 true
    
set bind_unused_hierarchical_pins            false
# this defaulted to true in 2003.12, but don't want it on by default
# enable with caution -- it could have fec implications.
set fsm_auto_inferring 			  false

set compile_log_format                       "%elap_time %area %wns(.4) %tns(.4) %drc %endpoint"

# so DC doesn't change the type of clock gating cell that we specify
set power_do_not_size_icg_cells 		 true

# Required for compile_ultra -gate_clock to match -global flag in
# insert_clock_gating
set compile_clock_gating_through_hierarchy	 true

# Configure advanced datapath options
set_dp_smartgen_options -4to2_compressor_cell false -carry_select_adder_cell false
set optimize_reg_no_generic_logic_for_comp_incr  false

# don't put set_load commands in the SDC we write out
set write_sdc_output_lumped_net_capacitance false
set lib_cell_using_delay_from_ccs            false

set power_cg_print_enable_conditions             true
set power_cg_print_enable_conditions_max_terms   25
set high_fanout_net_threshold                   0
set compile_disable_hierarchical_inverter_opt   true
set compile_seqmap_enable_output_inversion      false
set optimize_reg_rewire_clock_gating false
set compile_retime_exception_registers true 

## limit synthesis to try and keep hieracrchy names.
if {![shell_is_in_exploration_mode]} {
	set compile_seqmap_propagate_high_effort true
	set compile_seqmap_propagate_constants true
	#set_verification_priority [current_design] -high
	set compile_timing_high_effort true
	set compile_ultra_ungroup_dw true
	set compile_ultra_ungroup_small_hierarchies true
}
set dont_bind_unused_pins_to_logic_constant  false
set compile_seqmap_propagate_constants_size_only  true

if {[shell_is_in_topographical_mode] && ![shell_is_in_exploration_mode]} {
	set physopt_enable_via_res_support "true"; # Enables support of via resistance for virtual route RC estimation.
	set dct_prioritize_area_correlation "true"; # prioritize area correlation between DC-T and ICC.
	
	set_self_gating_options \
              -max_fanout 100   \
              -min_fanout 25
}

if {![shell_is_in_topographical_mode]} {

    # Variables affecting wall time of compilations vs quality
    set compile_use_fast_delay_mode              true
    set hdlin_enable_vpp                         true
    
}

# Enable physical flow in DCE
if {[shell_is_in_exploration_mode]} {
	set_app_var  de_enable_physical_flow true
}



