## =========================================================================================
## Setting environment variables
## =========================================================================================
DEPTH   := ../../..
-include ${DEPTH}/tree.make
-include ${DEPTH}/tools/make/common.make
-include $(TOT)/$(OUTDIR)/$(PROJECT)/spec/defs/project.mk

# Collect setting from tree.make and export as env variable
export VERDI_HOME        := ${VERDI_HOME}
export VCS_HOME			 := ${VCS_HOME}
export NOVAS_HOME		 := ${NOVAS_HOME}
export PATH              := ${VERDI_HOME}/bin:${VCS_HOME}/bin:${PATH}
export VCS_ARCH_OVERRIDE := linux

## =========================================================================================
## Setting command
## =========================================================================================

MKDIRP = /bin/mkdir -p
CP     = cp -f
RM     = rm -rf
MV     = mv -f 

# USE_DESIGNWARE shall be defined in tree.make
USE_DESIGNWARE ?= 1
# Three work modes: RTL_ONLY/CMOD_ONLY/CROSS_CHECK
WORK_MODE := CROSS_CHECK

# Set NVDLA_SAIF_ENABLE to 1 to compile SAIF testbench code
NVDLA_SAIF_ENABLE ?= 0

## =========================================================================================
## Setting testbench / rtl / reference model dir variables
## =========================================================================================

OUT_DIR := ${DEPTH}/${OUTDIR}/${PROJECT}/${REL_PATH_FROM_TOT}/
UVMCONNECT_HOME      := ${TOT}/third_party_tools/uvmc-2.3.0

VMOD_DIR             := ${TOT}/${OUTDIR}/${PROJECT}/vmod
VMOD_LIB_DIR         := ${TOT}/${OUTDIR}/${PROJECT}/vmod/vlibs
VMOD_INC_DIR         := ${TOT}/${OUTDIR}/${PROJECT}/vmod/include
VMOD_SRC_DIRS        := ${VMOD_DIR}/nvdla
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/cdma
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/cbuf
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/csc
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/cmac
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/cacc
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/sdp
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/car
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/glb
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/cfgrom
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/csb_master
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/nocif
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/top
ifdef NVDLA_PDP_ENABLE
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/pdp
endif
ifdef NVDLA_CDP_ENABLE
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/cdp
endif
ifdef NVDLA_BDMA_ENABLE
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/bdma
endif
ifdef NVDLA_RUBIK_ENABLE
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/rubik
endif
ifdef NVDLA_RETIMING_ENABLE
VMOD_SRC_DIRS        += ${VMOD_DIR}/nvdla/retiming
endif
VMOD_SRC_DIRS_ALL    := ${VMOD_SRC_DIRS:%=+incdir+%}

VMOD_RAM_DIRS        := ${VMOD_DIR}/rams
VMOD_RAM_DIRS        += ${VMOD_DIR}/rams/model
VMOD_RAM_DIRS        += ${VMOD_DIR}/rams/synth
VMOD_RAM_DIRS_ALL    := ${VMOD_RAM_DIRS:%=+incdir+%}
VMOD_FIFO_DIR        := ${VMOD_DIR}/fifos
VLIBS                := ${VMOD_DIR}/nvdla/nocif/NV_NVDLA_XXIF_libs.v
VLIBS                += ${VMOD_LIB_DIR}/RANDFUNC.vlib
VLIBS                += ${VMOD_LIB_DIR}/nv_assert_no_x.vlib
VLIBS                += ${shell find ${VMOD_FIFO_DIR} -name '*.v'}
ifeq (${USE_DESIGNWARE},0)
DWDIR                := ${TOT}/${OUTDIR}/${PROJECT}/vmod/vlibs
DWFILES              := ${DWDIR}/NV_DW02_tree.v \
                        ${DWDIR}/NV_DW_lsd.v \
						${DWDIR}/NV_DW_minmax.v
else                           
DWDIR                =  ${DESIGNWARE_DIR}
endif                          
VLIBS                += ${DWFILES}
VCS_LIBS_ALL         := ${VLIBS:%=-v %}

TRACE_PLAYER_DIR     := ${TOT}/verif/testbench/trace_player
MANUAL_DIR           := ${TOT}/${OUTDIR}/${PROJECT}/spec/manual
DEFS_DIR             := ${TOT}/${OUTDIR}/${PROJECT}/spec/defs
RAL_DIR              := ${TOT}/verif/ral
CSB_VIP_DIR          := ${TOT}/verif/vip/csb_agent
DBB_VIP_DIR          := ${TOT}/verif/vip/dbb_agent
MEM_MODEL_DIR        := ${TOT}/verif/vip/mem_model
CMOD_DIR             := ${TOT}/${OUTDIR}/${PROJECT}/verif/vip/reference_model/nvdla_cmod_wrap/release
UVMC_DIR             := ${UVMCONNECT_HOME}/src/connect/sv
SCSV_COMMON_DIR      := ${TOT}/verif/vip/reference_model/nvdla_scsv
TOP_SCSV_ADAPTER_DIR := ${TOT}/verif/vip/reference_model/nvdla_top_scsv_adapter
DMA_VIP_DIR          := ${TOT}/verif/vip/dma_agent
DP_VIP_DIR           := ${TOT}/verif/vip/dp_agent
CC_VIP_DIR           := ${TOT}/verif/vip/cc_agent
RM_VIP_DIR           := ${TOT}/verif/vip/reference_model/rm_nvdla_top
COVERAGE_DIR		 := ${TOT}/verif/coverage

## =========================================================================================
## Setting log file name variables
## =========================================================================================

COMPILELOG  := simv.build.log
SIMLOG      := run.log
SYSCLOG     := sysc.log
VCS_EXE     := simv

## =========================================================================================
## Generating file lists
## =========================================================================================

DEFS_FILE := ${TOT}/${OUTDIR}/${PROJECT}/spec/defs/project.vh

VERIF_SRC_FILES := ${shell find ${TOT}/verif/testbench/trace_player -name "*.sv" -o -name "*.svh"}
VERIF_SRC_FILES += ${shell find ${TOT}/verif/ral -name "*.sv" -o -name "*.svh"}
VERIF_SRC_FILES += ${shell find ${TOT}/verif/vip -name "*.sv" -o -name "*.cpp" -o -name "*.h" -o -name "*.svh"}
VERIF_SRC_FILES += ${shell find ${COVERAGE_DIR} -name "*.sv" -o -name "*.svh"}
VERIF_DST_FILES := ${subst ${TOT},${DEPTH}/${OUTDIR}/${PROJECT},${VERIF_SRC_FILES}}

UVMC_FILES  := ${UVMC_DIR}/uvmc_pkg.sv \

VERIF_FILES := ${TRACE_PLAYER_DIR}/nvdla_tb_common.svh \
			   ${DBB_VIP_DIR}/dbb_pkg.sv \
			   ${MEM_MODEL_DIR}/mem_pkg.sv \
			   ${RAL_DIR}/nvdla_ral_pkg.sv \
			   ${CSB_VIP_DIR}/csb_pkg.sv \
			   ${RAL_DIR}/nvdla_reg_adapter.sv \
 			   ${SCSV_COMMON_DIR}/sv/nvdla_scsv_pkg.sv \
			   ${TOP_SCSV_ADAPTER_DIR}/sv/nvdla_top_scsv_pkg.sv \
			   ${DMA_VIP_DIR}/dma_pkg.sv \
			   ${DP_VIP_DIR}/dp_pkg.sv \
			   ${CC_VIP_DIR}/cc_pkg.sv \
			   ${RM_VIP_DIR}/rm_nvdla_top_pkg.sv \
			   ${COVERAGE_DIR}/nvdla_coverage_pkg.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_scoreboard.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_override.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_txn.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_sequence.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_intr_handler.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_result_checker.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_env.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_trace_parser.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_base_test.sv \
			   ${TRACE_PLAYER_DIR}/nvdla_tb_top.sv \

TB_FILES    := ${UVMC_FILES} ${subst ${TOT},${TOT}/${OUTDIR}/${PROJECT},${VERIF_FILES}}
			
DPI_FILES_TB := ${RM_VIP_DIR}/rm_convertor_dpi.cpp
DPI_FILES    := ${subst ${TOT},${TOT}/${OUTDIR}/${PROJECT},${DPI_FILES_TB}}

DUT_FILES := ${VMOD_DIR}/nvdla/top/NV_nvdla.v

VERIF_DIRS  := +incdir+${CSB_VIP_DIR} \
               +incdir+${DBB_VIP_DIR} \
               +incdir+${MEM_MODEL_DIR} \
               +incdir+${RAL_DIR} \
               +incdir+${SCSV_COMMON_DIR}/sv \
               +incdir+${DMA_VIP_DIR} \
               +incdir+${DP_VIP_DIR} \
               +incdir+${CC_VIP_DIR} \
               +incdir+${TOP_SCSV_ADAPTER_DIR}/sv \
               +incdir+${RM_VIP_DIR} \
               +incdir+${TRACE_PLAYER_DIR} \
               +incdir+${COVERAGE_DIR} \

COMMON_DIRS  := +incdir+${VMOD_INC_DIR} \
                ${VMOD_SRC_DIRS_ALL} \
                ${VMOD_RAM_DIRS_ALL} \
                +incdir+${VMOD_LIB_DIR} \
		        +incdir+${MANUAL_DIR} \
                +incdir+${DEFS_DIR} \
		        +incdir+${UVMC_DIR} \
                ${subst ${TOT},${TOT}/${OUTDIR}/${PROJECT},${VERIF_DIRS}} \

## =========================================================================================
## Setting VCS options
## =========================================================================================

ifeq (${USE_DESIGNWARE},1)
VCS_LIBS_ALL += ${DWDIR:%=-y %}
endif

VCS_LIBS_ALL += ${VMOD_SRC_DIRS:%=-y %}
VCS_LIBS_ALL += ${VMOD_RAM_DIRS:%=-y %}
VCS_LIBS_ALL += ${VMOD_LIB_DIR:%=-y %}

VCS_LDFLAGS_PATH += ${CMOD_DIR}/lib
VCS_LDFLAGS_PATH += ${VCS_HOME}/linux64/lib
VCS_LDFLAGS_PATH_ALL = $(VCS_LDFLAGS_PATH:%=-L%)

EMPTY :=
SPACE := ${EMPTY} ${EMPTY}
export LD_LIBRARY_PATH := ${subst ${SPACE},:,${VCS_LDFLAGS_PATH}}:${LD_LIBRARY_PATH}

VCS_LDFLAGS_LIB += nvdla_cmod
VCS_LDFLAGS_LIB_ALL := $(VCS_LDFLAGS_LIB:%=-l%)

VCS_LDFLAGS := -LDFLAGS "${VCS_LDFLAGS_PATH_ALL} ${VCS_LDFLAGS_LIB_ALL}"


VCS_CFLAGS_PATH     += ${TOT}/cmod/include
VCS_CFLAGS_PATH     += ${TOT}/cmod/include/nvdla_ness_header
VCS_CFLAGS_PATH     += ${TOT}/${OUTDIR}/${PROJECT}/spec/defs
VCS_CFLAGS_PATH_ALL := $(VCS_CFLAGS_PATH:%=-I%)
VCS_CFLAGS          := -CFLAGS "${VCS_CFLAGS_PATH_ALL}"

VCS_OK_WARNINGS     := +warn=noTFIPC +warn=noTMR

VCS_ARGS    := ${COMMON_DIRS} \
               -sverilog \
               -ntb_opts uvm-1.2 \
               -timescale=1ns/1ns \
               -assert enable_diag \
               -line \
               -cc ${GCC} -cpp ${CXX} -ld ${CXX} -Xcombo=0x11 \
               -full64 \
               +v2k \
               +libext+.vlib+.v+.sv+.svh \
               +define+NVTOOLS_SYNC2D_GENERIC_CELL \
               +define+PRAND_OFF \
               ${VCS_OK_WARNINGS} \
               ${VERDI_HOME}/share/PLI/VCS/LINUX64/pli.a \
               +vcsd \
			   -parallel+sva+tgl \
               -P ${VERDI_HOME}/share/PLI/VCS/LINUX64/novas.tab 

# add 'COVERAGE := 1' in tree.make
ifeq (${COVERAGE},1)
VCS_ARGS += -cm line+tgl+cond+fsm+branch+assert
VCS_ARGS += -cm_tgl portsonly -cm_cond allops -cm_line contassign
VCS_ARGS += -cm_libs yv
VCS_ARGS += -cm_hier ${COVERAGE_DIR}/nvdla.hier
VCS_ARGS += -cm_glitch 0
#VCS_ARGS += -cm_dir simv.cm
endif

SIMV_ARGS   := +wave \
               +UVM_OBJECTION_TRACE \
               +WORK_MODE=${WORK_MODE} \

VERDI_ARGS  := ${COMMON_DIRS} \
               -ssv -ssy -nologo \
               +define+NVTOOLS_SYNC2D_GENERIC_CELL \
               +define+PRAND_OFF \
               +libext+.vlib+.v+.vh+.sv+.svh \
               ${DEFS_FILE} \
               -sv ${TB_FILES} \

ifeq (${NVDLA_SAIF_ENABLE},1)
	VCS_ARGS  += +vcs+saif_libcell +define+NVDLA_SAIF_ENABLE
endif


## =========================================================================================
## VCS syscan setup                                                                                   
## =========================================================================================
# Variables:
#   SYSC_SRC = This should have all the cpp files
#   SYSC_CINCDIRS = This should have all the include directories (without -I)
#   SYSC_CDEFINES = This should have all the C defines you need (without -D) 
#   SYSCAN_CFLAGS = Any cflags you want to pass (without -cflags) to syscan
#   SYSCAN_EXTRA_ARGS = Any misc args the user wants to supply to syscan
#   SYSC_VER = Specify the SystemC version that Syscan should use (For example 230,220)

SYSCAN_EXE   := syscan
SYSC_VER     ?= 230
_SYSC_VER    ?= -sysc=$(SYSC_VER)


SYSC_SRC_UVMC += ${UVMCONNECT_HOME}/src/connect/sc/uvmc.cpp
SYSC_SRC_TB   += ${SCSV_COMMON_DIR}/sc/nvdla_dbb_scsv_extension_packer.cpp
SYSC_SRC_TB   += ${SCSV_COMMON_DIR}/sc/nvdla_scsv_converter.cpp
SYSC_SRC_TB   += ${TOP_SCSV_ADAPTER_DIR}/sc/nvdla_top_sc_layer.cpp
SYSC_SRC_TB   += ${TOP_SCSV_ADAPTER_DIR}/sc/log.cpp
SYSC_SRC_TB   += ${TOP_SCSV_ADAPTER_DIR}/sc/nvdla_top_sc_adapter.cpp:nvdla_top_sc_adapter
SYSC_SRC      := ${SYSC_SRC_UVMC} ${subst ${TOT},${TOT}/${OUTDIR}/${PROJECT},${SYSC_SRC_TB}}

SYSC_CINCDIRS    := ${UVMCONNECT_HOME}/src/connect/sc
SYSC_CINCDIRS    += $(VCS_HOME)/include/systemc23
SYSC_CINCDIRS    += ${CMOD_DIR}/include
SYSC_CINCDIRS_TB += ${SCSV_COMMON_DIR}/sc
SYSC_CINCDIRS_TB += ${TOP_SCSV_ADAPTER_DIR}/sc
SYSC_CINCDIRS    += ${subst ${TOT},${TOT}/${OUTDIR}/${PROJECT},${SYSC_CINCDIRS_TB}}
SYSCAN_CINCDIRS_ALL = $(SYSC_CINCDIRS:%=-I%)

SYSC_CDEFINES += VCS
SYSCAN_CDEFINES_ALL = $(SYSC_CDEFINES:%=-D%)

# Add debug options to syscan
SYSCAN_FLAGS  += $(if $(filter 1,$(VCS_DEBUG_ALL)),-debug_all )
SYSCAN_CFLAGS += $(if $(filter 1,$(VCS_DEBUG_ALL)),-g )

SYSCAN_CFLAGS += -D__STDC_FORMAT_MACROS
SYSCAN_CFLAGS += -DNVDLA_REFERENCE_MODEL_ENABLE 
SYSCAN_CFLAGS += -DUVMC_MAX_WORDS=2048

# Add -full64 if doing a 64bit compile
SYSCAN_FLAGS += -full64
SYSCAN_FLAGS += -cc ${GCC} -cpp ${CXX}

# Add TLM-2.0 libs to the compile
SYSCAN_FLAGS += -tlm2 -sysc=opt_if


SYSCAN_FLAGS_ALL  += $(SYSCAN_FLAGS) $(SYSCAN_EXTRA_ARGS)
SYSCAN_CFLAGS_ALL += -cflags "$(SYSCAN_CFLAGS) $(SYSCAN_CDEFINES_ALL) $(SYSCAN_CINCDIRS_ALL)"

## =========================================================================================
## make target
## =========================================================================================

default: build

build: vcs_build gen_verdi_cmd

sysc_build: ${VERIF_DST_FILES}
	${MKDIRP} ${OUT_DIR} && cd ${OUT_DIR} && \
	${SYSCAN_EXE} ${_SYSC_VER} -V -work DEFAULT -l ${SYSCLOG} \
	${SYSCAN_FLAGS_ALL} ${SYSCAN_CFLAGS_ALL} ${SYSC_SRC} -Mdir=csrc

vcs_build: sysc_build ${DEFS_FILE} ${DUT_FILES} ${DPI_FILES} ${UVMC_FILES}
	${MKDIRP} ${OUT_DIR} && cd ${OUT_DIR} && \
	$(VCS_HOME)/bin/vcs -sysc=230 ${VCS_ARGS} ${VCS_LIBS_ALL} ${VCS_LDFLAGS} ${VCS_CFLAGS} ${DEFS_FILE} ${DUT_FILES} ${TB_FILES} ${DPI_FILES} -l ${COMPILELOG} -o ${VCS_EXE} -Mdir=csrc

gen_verdi_cmd:
	@echo "#!/bin/sh"                        > ${OUT_DIR}/run_verdi.sh
	@echo ""                                >> ${OUT_DIR}/run_verdi.sh
	@echo "export VERDI_HOME=${VERDI_HOME}" >> ${OUT_DIR}/run_verdi.sh
	@echo "export NOVAS_HOME=${VERDI_HOME}" >> ${OUT_DIR}/run_verdi.sh
	@echo ""                                >> ${OUT_DIR}/run_verdi.sh
	@echo "\$$VERDI_HOME/bin/verdi ${VERDI_ARGS} ${VCS_LIBS_ALL} -ntb_opts uvm-1.2 -top nvdla_tb_top -ssf nvdla.fsdb &" >> ${OUT_DIR}/run_verdi.sh
	@chmod 754 ${OUT_DIR}/run_verdi.sh

run:
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +uvm_set_config_int=*,auto_dump_surface,1 +uvm_set_config_string=*,trace_file_path,../../tests/trace_tests/${PROJECT}/cc_8x8x32_32x1x1x32_pack_all_zero_int8/cc_8x8x32_32x1x1x32_pack_all_zero_int8.cfg
	${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +uvm_set_config_int=*,auto_dump_surface,1 +uvm_set_config_string=*,trace_file_path,../../tests/trace_tests/${PROJECT}/sdp_passthrough_8x8x32_pack_inc_int8/sdp_passthrough_8x8x32_pack_inc_int8.cfg
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +uvm_set_config_int=*,auto_dump_surface,1 +uvm_set_config_string=*,trace_file_path,../../tests/trace_tests/${PROJECT}/pdp_passthrough_8x8x32_pack_inc_int8/pdp_passthrough_8x8x32_pack_inc_int8.cfg
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +uvm_set_config_int=*,auto_dump_surface,1 +uvm_set_config_string=*,trace_file_path,../../tests/trace_tests/${PROJECT}/cdp_passthrough_8x8x32_pack_inc_int8/cdp_passthrough_8x8x32_pack_inc_int8.cfg

run_gui:
	${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_TESTNAME=${TEST} -gui

verdi:
	${VERDI_HOME}/bin/verdi ${VERDI_ARGS} ${VCS_LIBS_ALL}  -ntb_opts uvm-1.2  -top nvdla_tb_top &

${VERIF_DST_FILES}: ${DEPTH}/${OUTDIR}/${PROJECT}/% : ${TOT}/%
	@${MKDIRP} ${dir $@}
	@${CP} $< $@
	${PYTHON} ${EPYTHON} -p ${PROJECT} -u $@ 

.PHONY : clean

.PHONY : run

clean: clear
	${RM} ${OUT_DIR}

clear:
	${RM}  *.log *.dat DVEfiles simv* urgReport *.prof vc_hdrs.h ucli.key *.fsdb novas* verdiLog AN.DB .vlogan*

