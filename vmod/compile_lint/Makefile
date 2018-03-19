####### common
DEPTH := ../..
include $(DEPTH)/tools/make/common.make
include $(TOT)/$(OUTDIR)/$(PROJECT)/spec/defs/project.mk
OUT_DIR = $(TOT)/$(OUTDIR)/$(PROJECT)/$(REL_PATH_FROM_TOT)
##########################

include ../../tree.make

  VCS_EXECUTABLE    := $(OUT_DIR)/simv

  export VCS_CC     := $(CXX)


QUIET	:= @
SLEEP	:= /bin/sleep
ECHO	:= /bin/echo
LN		:= /bin/ln
RM		:= /bin/rm
GREP	:= /bin/grep
EGREP	:= /bin/egrep
AWK		:= /usr/bin/awk
CP		:= /bin/cp
CSH		:= /bin/csh
MV		:= /bin/mv
CP		:= /bin/cp
PWD		:= /bin/pwd
MKDIR	:= /bin/mkdir
CHDIR	:= cd
FIND	:= /bin/find

LSF_COMMAND       	?= 
DESIGNWARE_NOEXIST 	?= 1
MAX_ERROR_NUM		?= 20

ORIGIN_DIR       	:= ${dir ${shell ${PWD}}}
VMOD_DIR			:= ${OUT_DIR}/..
VLIB_DIR      		:= ${VMOD_DIR}/vlibs
VMOD_INCDIR   		:= ${VMOD_DIR}/include
VMOD_SRCDIR_LIST    := ${VMOD_DIR}/nvdla \
						${VMOD_DIR}/nvdla/cdma \
						${VMOD_DIR}/nvdla/cbuf \
						${VMOD_DIR}/nvdla/csc \
						${VMOD_DIR}/nvdla/cmac \
						${VMOD_DIR}/nvdla/cacc \
						${VMOD_DIR}/nvdla/sdp \
						${VMOD_DIR}/nvdla/car \
						${VMOD_DIR}/nvdla/glb \
						${VMOD_DIR}/nvdla/csb_master \
						${VMOD_DIR}/nvdla/nocif \
						${VMOD_DIR}/nvdla/top

ifdef NVDLA_PDP_ENABLE
VMOD_SRCDIR_LIST    += ${VMOD_DIR}/nvdla/pdp
endif
ifdef NVDLA_CDP_ENABLE
VMOD_SRCDIR_LIST    += ${VMOD_DIR}/nvdla/cdp
endif
ifdef NVDLA_BDMA_ENABLE
VMOD_SRCDIR_LIST    += ${VMOD_DIR}/nvdla/bdma
endif
ifdef NVDLA_RUBIK_ENABLE
VMOD_SRCDIR_LIST    += ${VMOD_DIR}/nvdla/rubik
endif
ifdef NVDLA_RETIMING_ENABLE
VMOD_SRCDIR_LIST    += ${VMOD_DIR}/nvdla/retiming
endif

VMOD_RAM_DIR_LIST	:= ${VMOD_DIR}/rams \
						${VMOD_DIR}/rams/model \
						${VMOD_DIR}/rams/synth

DUT_SRC_PARSING		:= $(VMOD_SRCDIR_LIST:%=-y %)
DUT_SRC_PARSING		+= $(VMOD_RAM_DIR_LIST:%=-y %)
DUT_SRC_PARSING		+= -y ${VLIB_DIR}
#VLIBS				:= $(shell find ${VLIB_DIR} -name '*.vlib' -type f)
VLIBS				+= ${VMOD_DIR}/nvdla/nocif/NV_NVDLA_XXIF_libs.v
VLIBS				+= ${VLIB_DIR}/RANDFUNC.vlib
VLIBS				+= ${VLIB_DIR}/nv_assert_no_x.vlib
ifeq (${DESIGNWARE_NOEXIST},1)
	DW_DIR			:= ${VMOD_DIR}/vlibs
	DWFILES      	:= ${DW_DIR}/NV_DW02_tree.v \
		${DW_DIR}/NV_DW_lsd.v \
		${DW_DIR}/NV_DW_minmax.v
else
	DW_DIR        	:= ${VMOD_DIR}/dw_components
	DWFILES      	:= ${DW_DIR}/DW02_tree.v \
		${DW_DIR}/DW_lsd.v \
		${DW_DIR}/DW_minmax.v
endif

VLIBS				+= ${DWFILES}

DUT_DEFINE_LIST		:= NVTOOLS_SYNC2D_GENERIC_CELL \
	PRAND_OFF

DUT_ARGS     := ${VMOD_DIR}/nvdla/top/NV_nvdla.v \
			${VLIBS} \
			${DUT_SRC_PARSING} \
			+incdir+${VLIB_DIR} \
			+incdir+${VMOD_INCDIR} \
			+incdir+${DW_DIR}

ifeq (${DESIGNWARE_NOEXIST},1)
	DUT_DEFINE_LIST += DESIGNWARE_NOEXIST
endif

DUT_DEFINE_ARGS	 := $(DUT_DEFINE_LIST:%=+define+%)
VCS_TIMING_ARGS  := +nospecify +notimingchecks +define+VLIB_NO_UDP
VCS_OK_WARNINGS  := +warn=noTFIPC +warn=noTMR
VCS_64BIT_ARGS   := -full64

VCS_ARGS     := ${VCS_TIMING_ARGS} \
		${VCS_OK_WARNINGS} \
		${VCS_64BIT_ARGS} \
		${DUT_ARGS} \
		${DUT_DEFINE_ARGS} \
		+vcs+lic+wait \
		-sverilog \
		+systemverilogext+.sv+.svi+.svh+.svt \
		+v2k +verilog2001ext+.v95+.vt+.vp \
		+libext+.v \
		+libext+.sv \
		-timescale=1ns/1ns \
		+error+${MAX_ERROR_NUM} \
		-debug_all


COMPILELOG   := ${VCS_EXECUTABLE}.compile.log
############################# Build targets ############################

build :
	${QUIET}${ECHO} "OUT_DIR = ${OUT_DIR}"
	${MKDIR} -p $(OUT_DIR)
	${LSF_COMMAND} $(VCS_HOME)/bin/vcs  -Xddg=0x1 -o ${VCS_EXECUTABLE} -cpp ${VCS_CC} ${VCS_ARGS}   -l ${COMPILELOG} ${DUT_DEFINES}  -Mdir=${VCS_EXECUTABLE}Csrc

default: all

check:
	${ORIGIN_DIR}/checkcompile.pl ${COMPILELOG} ${VCS_EXECUTABLE}

all: build check

clean:
	${QUIET}${ECHO} "NVINFO : !!!Cleaning directory!!!,  5 seconds to hit ^C to halt!"
	${QUIET}${SLEEP} 5
	${QUIET}${ECHO} "NVINFO : Cleaning ..."
	${QUIET}${RM} -rf ${VCS_EXECUTABLE}Csrc csrc *.vpd *.fsdb *.vf *.log DVEfiles ${VCS_EXECUTABLE}* urgReport *.prof vcs.key novas.* vc_hdrs.h .vcsmx_rebuild ucli.key silotiLog verdiLog ${ESA_ESDB_NAME}.esdb++ esaLog ${VERICOM_LOG_DIR} ${VERICOM_LIB_DIR} tests/*/*.log tests/*/*.fsdb tests/*/*.vf test/*/*.vpd
	${QUIET}${ECHO} "NVINFO : Done."
