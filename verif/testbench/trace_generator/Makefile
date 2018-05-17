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

## =========================================================================================
## Setting testbench / rtl / reference model dir variables
## =========================================================================================

OUT_DIR := ${DEPTH}/${OUTDIR}/${PROJECT}/${REL_PATH_FROM_TOT}

TRACE_GEN_DIR        := ${TOT}/verif/testbench/trace_generator
MANUAL_DIR           := ${TOT}/spec/manual
RAL_DIR              := ${TOT}/verif/ral
VIP_DIR              := ${TOT}/verif/vip
VIP_MEM_MAN_DIR      := ${VIP_DIR}/mem_man
VIP_SURFACE_GEN_DIR  := ${VIP_DIR}/surface_generator
VIP_SURFACE_GEN_DIR  := ${VIP_DIR}/surface_generator
VIP_CSB_DIR          := ${VIP_DIR}/csb_agent
TEST_DIR             := ${TOT}/verif/tests/uvm_tests
COVERAGE_DIR         := ${TOT}/verif/coverage
TRACE_GEN_ENV_DIR    := ${TOT}/verif/testbench/trace_generator/env
TRACE_GEN_RES_DIR    := ${TOT}/verif/testbench/trace_generator/resources
TRACE_GEN_SCE_DIR    := ${TOT}/verif/testbench/trace_generator/scenarios

## =========================================================================================
## Setting log file name variables
## =========================================================================================

COMPILELOG  := ${OUT_DIR}/simv.build.log
SIMLOG      := ${OUT_DIR}/run.log
VCS_EXE     := ${OUT_DIR}/simv

## =========================================================================================
## Generating file lists
## =========================================================================================

DEFS_FILE := ${TOT}/${OUTDIR}/${PROJECT}/spec/defs/project.vh

VERIF_SRC_FILES += ${shell find ${TRACE_GEN_DIR} -name "*.sv" -o -name "*.svh" -o -name "*.cpp"}
VERIF_SRC_FILES += ${shell find ${TEST_DIR} -name "*.sv" -o -name "*.svh"}
VERIF_SRC_FILES += ${shell find ${COVERAGE_DIR} -name "*.sv" -o -name "*.svh"}
VERIF_SRC_FILES += ${shell find ${VIP_CSB_DIR} -name "*.sv" -o -name "*.svh"}
VERIF_SRC_FILES += ${shell find ${RAL_DIR} -name "*.sv" -o -name "*.svh"}

VERIF_DST_FILES := ${subst ${TOT},${DEPTH}/${OUTDIR}/${PROJECT},${VERIF_SRC_FILES}}

VERIF_FILES := \
               ${MANUAL_DIR}/ordt_uvm_reg_pkg.sv \
               ${RAL_DIR}/nvdla_ral_pkg.sv \
               ${VIP_CSB_DIR}/csb_pkg.sv \
               ${COVERAGE_DIR}/nvdla_coverage_pkg.sv \
               ${TRACE_GEN_RES_DIR}/nvdla_resource_pkg.sv \
               ${TRACE_GEN_SCE_DIR}/nvdla_scenario_pkg.sv \
               ${TRACE_GEN_ENV_DIR}/nvdla_tg_common.svh \
               ${TRACE_GEN_ENV_DIR}/nvdla_tg_core.sv \
               ${TRACE_GEN_ENV_DIR}/nvdla_tg_base_test.sv \
               ${TRACE_GEN_ENV_DIR}/nvdla_tg_top.sv \
               ${TEST_DIR}/nvdla_test_suite.sv

TB_FILES    := \
               ${VIP_MEM_MAN_DIR}/mem_man_pkg.sv \
               ${VIP_SURFACE_GEN_DIR}/surface_generator_pkg.sv

TB_FILES  += ${subst ${TOT},${TOT}/${OUTDIR}/${PROJECT},${VERIF_FILES}}

DPI_FILES_TB := ${TRACE_GEN_ENV_DIR}/fp_func_dpi.cpp
DPI_FILES    := ${subst ${TOT},${TOT}/${OUTDIR}/${PROJECT},${DPI_FILES_TB}}

VERIF_DIRS  :=  \
				+incdir+${MANUAL_DIR} \
                +incdir+${RAL_DIR} \
                +incdir+${VIP_CSB_DIR} \
				+incdir+${TRACE_GEN_ENV_DIR} \
				+incdir+${TRACE_GEN_SCE_DIR} \
				+incdir+${TRACE_GEN_RES_DIR} \
				+incdir+${TEST_DIR} \
				+incdir+${COVERAGE_DIR} \

COMMON_DIRS  := \
                ${subst ${TOT},${TOT}/${OUTDIR}/${PROJECT},${VERIF_DIRS}} 

COMMON_DIRS  += \
				+incdir+${VIP_MEM_MAN_DIR} \
				+incdir+${VIP_SURFACE_GEN_DIR} \
				+incdir+${VIP_CSB_DIR} \

VCS_OK_WARNINGS     := +warn=noTFIPC +warn=noTMR

VCS_ARGS    := ${COMMON_DIRS} \
               -sverilog \
               -ntb_opts uvm-1.2 \
               -timescale=1ns/1ns \
               -assert enable_diag \
               -line \
               -full64 \
               +v2k \
               +libext+.vlib+.v+.sv+.svh \
               ${VCS_OK_WARNINGS} \
               ${VERDI_HOME}/share/PLI/VCS/LINUX64/pli.a \
               +vcsd \
               -P ${VERDI_HOME}/share/PLI/VCS/LINUX64/novas.tab 

# add 'COVERAGE := 1' in tree.make
ifeq (${COVERAGE},1)
VCS_ARGS += -cm line+tgl+cond+fsm+branch+assert
VCS_ARGS += -cm_tgl portsonly -cm_cond allops -cm_line contassign
VCS_ARGS += -cm_libs yv
VCS_ARGS += -cm_hier ${COVERAGE_DIR}/nvdla.hier
#VCS_ARGS += -cm_dir simv.cm
endif

SIMV_ARGS	:= +UVM_OBJECTION_TRACE

VERDI_ARGS  := ${COMMON_DIRS} \
               -ssv -ssy -nologo \
               +libext+.vlib+.v+.vh+.sv+.svh \
               ${DEFS_FILE} \
               -sv ${TB_FILES} \

## =========================================================================================
## make target
## =========================================================================================

default: build

build: vcs_build

vcs_build: ${DEFS_FILE}  ${VERIF_DST_FILES}
	${MKDIRP} ${OUT_DIR}
	$(VCS_HOME)/bin/vcs ${VCS_ARGS} ${DEFS_FILE} ${DPI_FILES} ${TB_FILES} -l ${COMPILELOG} -o ${VCS_EXE} -Mdir=${OUT_DIR}/csrc

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

run:
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=cc_feature_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,1 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=cc_feature_data_full_reuse_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,2 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=cc_feature_weight_full_reuse_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,2 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=cc_image_data_full_reuse_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,2 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=cc_pitch_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,1 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=cc_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,1 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=sdp_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,1 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=sdp_bs_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,1 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=sdp_bn_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,1 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=cdp_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,3 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=cdp_exp_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,1 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=cdp_lin_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,1 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=pdp_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,1 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=pdp_split_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,1 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=pdp_non_split_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,1 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=pdp_non_split_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,1 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=cc_sdprdma_sdp_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,1 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=cc_sdp_pdp_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,1 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=cc_sdprdma_sdp_pdp_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,1 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=sdprdma_sdp_pdp_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,1 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py
	#${VCS_EXE} -l ${SIMLOG} ${SIMV_ARGS} +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=multi_scenario_rtest +UVM_VERBOSITY=UVM_LOW +uvm_set_config_int=uvm_test_top,layers,1 +uvm_set_config_string=*,memory_surface_generator_path,${TOT}/verif/tools/surface_generator/surface_generator.py

