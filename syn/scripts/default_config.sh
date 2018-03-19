# ===================================================================
# File: syn/scripts/default_config.sh
# NVDLA Open Source Project
# Default values for all the variables supported in the synthesis 
# reference methodology
#
# Copyright (c) 2016 – 2017 NVIDIA Corporation. Licensed under the
# NVDLA Open Hardware License; see the "LICENSE.txt" file that came
# with this distribution for more information.
# ===================================================================

# ===========================
# DESIGN RELATED VARIABLES
# ===========================
export TOP_NAMES="NV_NVDLA_partition_a NV_NVDLA_partition_c NV_NVDLA_partition_o NV_NVDLA_partition_m NV_NVDLA_partition_p"

# Where do I find the RTL source verilog/system verilog files?
export RTL_SEARCH_PATH=""
export EXTRA_RTL=""

# If there are verilog header files, where do I find them?
export RTL_INCLUDE_SEARCH_PATH=""

# File extensions for source files...
export RTL_EXTENSIONS=".v .sv .gv"
export RTL_INCLUDE_EXTENSIONS=".vh .svh"

# Constraints and floorplans
export CONS="config"
export DEF="def"

# ===========================
# TOOL RELATED VARIABLES
# ===========================
# Design Compiler Installation - Where do I find the dc_shell executable
export DC_PATH=""

# ===========================
# LIBRARY RELATED VARIABLES
# ===========================
export TARGET_LIB=""
export LINK_LIB=""
export MW_LIB=""
export TF_FILE=""
export TLUPLUS_FILE=""
export TLUPLUS_MAPPING_FILE=""
export MIN_ROUTING_LAYER=""
export MAX_ROUTING_LAYER=""
export HORIZONTAL_LAYERS=""
export VERTICAL_LAYERS=""
export WIRELOAD_MODEL_NAME=""
export WIRELOAD_MODEL_FILE=""
export DONT_USE_LIST=""

# ==========================
# MISCELLANEOUS VARIABLES 
#===========================
# Set host options in the DC session. 
export DC_NUM_CORES="1"

# Apply constraints to tighten CG enable paths to model post-CTS insertion delays
export TIGHTEN_CGE="0"

# Enable Area recovery (run optimize_netlist -area)
export AREA_RECOVERY="1"

# Number of incremental recompile loops
export INCREMENTAL_RECOMPILE_COUNT="1"

# Some other variables
export CLK_GATING_CELL=""
export DONT_UNGROUP_LIST=""
export RETIME_LIST=""
export RETIME_TRANSFORM="multiclass"

# For Job management
export COMMAND_PREFIX=""

