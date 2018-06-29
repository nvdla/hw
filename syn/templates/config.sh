# ===================================================================
# File: syn/templates/config.sh
# NVDLA Open Source Project
# Template configuration file for reference synthesis methodology
#
# Copyright (c) 2016 – 2017 NVIDIA Corporation. Licensed under the
# NVDLA Open Hardware License; see the "LICENSE.txt" file that came
# with this distribution for more information.
# ===================================================================

# ===========================
# DESIGN RELATED VARIABLES
# ===========================

export TOP_NAMES="NV_NVDLA_partition_a NV_NVDLA_partition_c NV_NVDLA_partition_o NV_NVDLA_partition_m NV_NVDLA_partition_p"

export TB_PATH="top.nvdla_top"
TOP_INSTS_NV_NVDLA_partition_a="u_partition_a"
TOP_INSTS_NV_NVDLA_partition_c="u_partition_c"
TOP_INSTS_NV_NVDLA_partition_o="u_partition_o"
TOP_INSTS_NV_NVDLA_partition_m="u_partition_ma u_partition_mb"
TOP_INSTS_NV_NVDLA_partition_p="u_partition_p"

export NVDLA_ROOT=$(pwd) # or: "<path_to_release>/hw"

# Where do I find the RTL source verilog/system verilog files?
export RTL_SEARCH_PATH=" \
    $(ls -d ${NVDLA_ROOT}/outdir/${PROJECT}/vmod/nvdla/*) \
    ${NVDLA_ROOT}/outdir/${PROJECT}/vmod/rams/synth \
    ${NVDLA_ROOT}/outdir/${PROJECT}/vmod/vlibs \
"

# For verilog source files that do not match the module name. 
export EXTRA_RTL=" \
    ${NVDLA_ROOT}/outdir/${PROJECT}/vmod/nvdla/nocif/NV_NVDLA_XXIF_libs.v \
    $(ls -d ${NVDLA_ROOT}/outdir/${PROJECT}/vmod/fifos/*.v) \
"

# If there are verilog header files, where do I find them?
export RTL_INCLUDE_SEARCH_PATH=" \
    ${NVDLA_ROOT}/outdir/${PROJECT}/vmod/include \
    ${NVDLA_ROOT}/outdir/${PROJECT}/spec/defs \
"


# File extensions for source files...
export RTL_EXTENSIONS=".v .sv .gv"
export RTL_INCLUDE_EXTENSIONS=".vh .svh"

# FLoorplans and constraints
export DEF="def"
export CONS="cons"

# Power related files
#export SAIF_FILE="$NVDLA_ROOT/outdir/nv_large/verif/synth_tb_sim/googlenet_conv2_3x3_int16/top0.snps.saif"
export SAIF_FILE=""

# ===========================
# TOOL RELATED VARIABLES
# ===========================


# Design Compiler Installation - Where do I find the dc_shell executable
export DC_PATH="/home/tools/synopsys/syn_2016.12-SP5-1/bin"
export PT_PATH="/home/tools/synopsys/pt_2016.12-SP3-2/bin"


# ===========================
# LIBRARY RELATED VARIABLES
# ===========================

export RELEASE_DIR="/home/libs/t194_syn/11399272_08212017"
export RAM_LIB_DIR="../tools/data"
export TARGET_LIB="${RELEASE_DIR}/std_cell/nvstd/syn.A01/nvstd_stdcell_tsmc16ff_t9_po4svt_std_ssg_0c_0p72v.db"
export LINK_LIB="\
    ${RELEASE_DIR}/std_cell/nvstd/syn.A01/nvstd_stdcell_tsmc16ff_t9_po4svt_std_ssg_0c_0p72v.db \
    ${RELEASE_DIR}/std_cell/nvstd/syn.A01/nvstd_stdcell_tsmc16ff_t9_hvt_std_ssg_0c_0p72v.db \
    ${RELEASE_DIR}/std_cell/nvstd/syn.A01/nvstd_stdcell_tsmc16ff_t9_svt_std_ssg_0c_0p72v.db \
    ${RELEASE_DIR}/std_cell/nvidia/syn.A01/nvidia_stdcell_tsmc16ff_t9_sup_std_ssg_0c_0p72v.db \
    ${RELEASE_DIR}/std_cell/nvidia/syn.A01/nvidia_stdcell_tsmc16ff_t9_po4svt_std_ssg_0c_0p72v.db \
    ${RELEASE_DIR}/std_cell/nvidia/syn.A01/nvidia_stdcell_tsmc16ff_t9_svt_std_ssg_0c_0p72v.db \
    ${RAM_LIB_DIR}/nvgen_rams_tsmc16ff_cust_mixvt_std_ssg_0c_0p72v0p72v.db \
    ${DC_PATH}/../libraries/syn/dw_foundation.sldb \
    ${DC_PATH}/../libraries/syn/standard.sldb \
"

export MW_LIB="\
    ${RELEASE_DIR}/std_cell/nvstd/apollo.A01/nvstd_stdcell_tsmc16ff_t9_po4svt_std \
    ${RELEASE_DIR}/std_cell/nvstd/apollo.A01/nvstd_stdcell_tsmc16ff_t9_hvt_std \
    ${RELEASE_DIR}/std_cell/nvstd/apollo.A01/nvstd_stdcell_tsmc16ff_t9_svt_std \
    ${RELEASE_DIR}/std_cell/nvidia/apollo.A01/nvidia_stdcell_tsmc16ff_t9_sup_std \
    ${RELEASE_DIR}/std_cell/nvidia/apollo.A01/nvidia_stdcell_tsmc16ff_t9_po4svt_std \
    ${RELEASE_DIR}/std_cell/nvidia/apollo.A01/nvidia_stdcell_tsmc16ff_t9_svt_std \
    ${RAM_LIB_DIR}/nvgen_rams_tsmc16ff_cust_mixvt_std \
"

export TF_FILE="${RELEASE_DIR}/tech.A01/astro/v1d0_1e/N16_ICC_14M_4Xa1Xd6Xe2Z_UTRDL_1.0_1e.tf_vhv.20160404.production.pnr"
export TLUPLUS_FILE="${RELEASE_DIR}/tech.A01/star/plusv1d0p2/cln16ff+_1p14m_4xa1xd6xe2z_mim_ut-alrdl_typical.tluplus"
export TLUPLUS_MAPPING_FILE="${RELEASE_DIR}/tech.A01/star/mapping/cln16ff_14m_1x4xa1xd6xe2vm_tluplus.mapping"
export MIN_ROUTING_LAYER="M2A"
export MAX_ROUTING_LAYER="M12E"
export HORIZONTAL_LAYERS="M2A M4A M6D M8E M10E M12E VM1 RDL"
export VERTICAL_LAYERS="M1 M3A M5A M7E M9E M11E VM2 UBM"
export WIRELOAD_MODEL_NAME="tsmc16ff_from_smq"
export WIRELOAD_MODEL_FILE=""
export DONT_USE_LIST=""

# ==========================
# MISCELLANEOUS VARIABLES 
#===========================
# Set host options in the DC session. 
export DC_NUM_CORES="8"

# Apply constraints to tighten CG enable paths to model post-CTS insertion delays
export TIGHTEN_CGE="1"

# Enable Area recovery (run optimize_netlist -area)
export AREA_RECOVERY="1"

# Number of incremental recompile loops
export INCREMENTAL_RECOMPILE_COUNT="2"

# Modules to retime (DC's set_optimize_registers feature)
export RETIME_LIST="NV_NVDLA_CMAC_CORE_mac:nvdla_core_clk"

# For Job management
export COMMAND_PREFIX="qsub -q o_timing_cpu_32G -app syn -n 4 -R span[hosts=1] -oo <LOG>/<MODULE>.lsf.log -N "
export PTPX_COMMAND_PREFIX="qsub -q o_timing_cpu_32G -app timing -n 2 -R span[hosts=1] -oo <LOG>/<MODULE>.ptpxb.log -N "

export CGLUT_FILE="$NVDLA_ROOT/templates/cg_latency_lut.tcl"
