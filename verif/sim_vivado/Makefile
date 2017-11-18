# ----------------------------------------------------------------------------
#      ___                                   _____                      ___     
#     /__/\          ___        ___         /  /::\       ___          /  /\
#     \  \:\        /__/\      /  /\       /  /:/\:\     /  /\        /  /::\
#      \  \:\       \  \:\    /  /:/      /  /:/  \:\   /  /:/       /  /:/\:\
#  _____\__\:\       \  \:\  /__/::\     /__/:/ \__\:| /__/::\      /  /:/~/::\
# /__/::::::::\  ___  \__\:\ \__\/\:\__  \  \:\ /  /:/ \__\/\:\__  /__/:/ /:/\:\
# \  \:\~~\~~\/ /__/\ |  |:|    \  \:\/\  \  \:\  /:/     \  \:\/\ \  \:\/:/__\/
#  \  \:\  ~~~  \  \:\|  |:|     \__\::/   \  \:\/:/       \__\::/  \  \::/     
#   \  \:\       \  \:\__|:|     /__/:/     \  \::/        /__/:/    \  \:\
#    \  \:\       \__\::::/      \__\/       \__\/         \__\/      \  \:\
#     \__\/           ~~~~                                             \__\/    
#                                     ___                            ___   
#         _____                      /  /\             ___          /  /\
#        /  /::\                    /  /::\           /  /\        /  /::\
#       /  /:/\:\                  /  /:/\:\         /  /:/       /  /:/\:\
#      /  /:/  \:\   __      __   /  /:/~/::\       /__/::\      /  /:/~/:/
#     /__/:/ \__\:/ /__/\   /  /\/__/:/ /:/\:\      \__\/\:\__  /__/:/ /:/ 
#     \  \:\ /  /:/ \  \:\ /  /:/\  \:\/:/__\/         \  \:\/\ \  \:\/:/  
#      \  \:\  /:/   \  \:\  /:/  \  \::/               \__\::/  \  \::/   
#       \  \:\/:/     \  \:\/:/    \  \:\               /__/:/    \  \:\
#        \  \::/       \  \::/      \  \:\              \__\/      \  \:\
#         \__\/         \__\/        \__\/                          \__\/  
# ----------------------------------------------------------------------------
#
# Component: Makefile
#
# Package:   
#
# Support:   
#
# ----------------------------------------------------------------------------
help:
	${QUIET}${ECHO} "---------------------------------------------------------"
	${QUIET}${ECHO} "This makefile is for running simulation using VIVADO xsim"
	${QUIET}${ECHO} "---------------------------------------------------------"
	${QUIET}${ECHO} "Remove compilation files and test dirs"
	${QUIET}${ECHO} " > make clean"
	${QUIET}${ECHO} ""
	${QUIET}${ECHO} "Normal build and run single test"
	${QUIET}${ECHO} " > make build"
	${QUIET}${ECHO} " > make run TESTDIR=../traces/traceplayer/sanity0"
	${QUIET}${ECHO} ""
	${QUIET}${ECHO} "Run with GUI "
	${QUIET}${ECHO} " > make run GUI=1 TESTDIR=../traces/traceplayer/sanity0"
	${QUIET}${ECHO} ""
	${QUIET}${ECHO} "Run with test with VCD Dump"
	${QUIET}${ECHO} " > make build DUMP=1"
	${QUIET}${ECHO} " > make run DUMP=1 TESTDIR=../traces/traceplayer/sanity0 "
	${QUIET}${ECHO} ""
	${QUIET}${ECHO} "Regression"
	${QUIET}${ECHO} " > make regress"
	${QUIET}${ECHO} " > make regress MINIREGRESS=1"
	${QUIET}${ECHO} ""
	${QUIET}${ECHO} "Cleanup"
	${QUIET}${ECHO} " > make clean"
	${QUIET}${ECHO} ""
								  
# ----------------------------------------------------------------------------
# TOOL LOCATIONS

#define XILINX_HOME in your environment to override this
ifeq ($(origin XILINX_HOME), undefined)
  export XILINX_HOME   := /home/tools/Xilinx/SDx/2017.1/Vivado
endif

  SIMULATOR    := xsim
  XILINX_EXECUTABLE    := ./xsim.dir

# ----------------------------------------------------------------------------
# GENERAL CMDS

QUIET	:= @
SLEEP	:= /bin/sleep
ECHO	:= /bin/echo
LN	:= /bin/ln
RM	:= /bin/rm
GREP	:= /bin/grep
EGREP	:= /bin/egrep
PERL	:= /home/utils/perl-5.16/5.16.1-nothreads-64/bin/perl
AWK	:= /usr/bin/awk
CP	:= /bin/cp
TEE	:= /home/gnu/bin/tee
CSH	:= /bin/csh
MV	:= /bin/mv
CP	:= /bin/cp
PWD	:= /bin/pwd
MKDIR	:= /bin/mkdir
CHDIR	:= cd

#
# ----------------------------------------------------------------------------
# If using LSF or some type of tool to launch to a farm of machines use the
# variable below to provide the launch command.
# example: LSF_COMMAND       := qsub -P maxwell -q o_vcs_16G -m rel4or5 -I 
# -K = block

LSF_COMMAND       ?= 

# ----------------------------------------------------------------------------
# MAKE CMDLINE OVERRIDES
#
#  DUMP=1	 : generate wave file
#  GUI=1	 : Run with Vivado GUI

DUMP	   ?= 0
GUI	?= 0

# Set to 1 if you do not have access to Synopsys Designware modules
DESIGNWARE_NOEXIST ?= 1


# ----------------------------------------------------------------------------
# DIRECTORIES

TOPDIR       := ${dir ${shell ${PWD}}}
DUTDIR       := ${TOPDIR}dut
SIMDIR       := ${TOPDIR}sim_vivado
SYNTHTBDIR   := ${TOPDIR}synth_tb
VLIBDIR      := ${TOPDIR}../outdir/nv_full/vmod/vlibs
VMODINCDIR   := ${TOPDIR}../outdir/nv_full/vmod/include
ifeq (${DESIGNWARE_NOEXIST},1)
DWDIR        := ${TOPDIR}../outdir/nv_full/vmod/vlibs
DWFILES      := ${DWDIR}/NV_DW02_tree.v \
                    ${DWDIR}/NV_DW_lsd.v \
                    ${DWDIR}/NV_DW_minmax.v
else
DWDIR        := ${TOPDIR}../vmod/dw_components
DWFILES      := ${DWDIR}/DW02_tree.v \
                    ${DWDIR}/DW_lsd.v \
                    ${DWDIR}/DW_minmax.v
endif

# ----------------------------------------------------------------------------
# FILE AND LOG NAMES

DUTFILE      := ${DUTDIR}/dut.vivado.f 
COMPILELOG   := ${SIMULATOR}.compile.log
TRACELOG     := trace.log
TESTDIR      ?= ../traces/traceplayer/sanity0
FULLTESTDIR  := ${SIMDIR}/${TESTDIR}
TESTNAME     := ${notdir ${TESTDIR}}
TESTSUFFIX   ?= 
SIMTESTDIR   := ${SIMDIR}/${TESTNAME}${TESTSUFFIX}
INPUTVECTORS ?= input.txn
TESTLOG_BASE ?= test
TESTLOGSUFFIX ?= .log
TESTLOG := ${TESTLOG_BASE}${TESTLOGSUFFIX}

SYNTHINPUTVECTORS ?= input.txn.raw

# ----------------------------------------------------------------------------
# which TB version to use - sv_tb or synth_tb
# determine the TB_FILES also here

TB_TARGET ?= synth_tb
ifeq (${TB_TARGET},sv_tb)
# Not supported yet
else
	ifeq (${TB_TARGET},synth_tb)
		TBDIR := ${SYNTHTBDIR}
		VCS_LOGFILE    := ${TESTLOG}

		NOT_TOP_TB_FILES := ${TBDIR}/csb_master.v \
		    ${TBDIR}/csb_master_seq.v \
		    ${TBDIR}/axi_slave.v \
		    ${TBDIR}/id_fifo.v \
		    ${TBDIR}/memory.v \
		    ${TBDIR}/memresp_fifo.v \
		    ${TBDIR}/raddr_fifo.v \
		    ${TBDIR}/slave_mem_wrap.v \
		    ${TBDIR}/waddr_fifo.v \
		    ${TBDIR}/wdata_fifo.v \
		    ${TBDIR}/wstrb_fifo.v \
		    ${TBDIR}/clk_divider.v \
		    ${TBDIR}/slave2mem_rd.v \
		    ${TBDIR}/slave2mem_wr.v \
                    ${DWFILES}
		#TB_FILES       := ${TBDIR}/tb_top.v ${NOT_TOP_TB_FILES}
		TB_FILES       := ${NOT_TOP_TB_FILES} ${TBDIR}/tb_top.v

                #Two step way to ensure we don't create a lower higherarchy with new files
		TB_PREP := ${MKDIR} -p ${SIMTESTDIR} ; \
				${CP} -Trf ${FULLTESTDIR} ${SIMTESTDIR} ; \
				${CHDIR} ${SIMTESTDIR} ; \
				${LN} -fs ${SIMDIR}/${XILINX_EXECUTABLE} 

		SYNTHINPVECMODE := 
		SYNTHINPVECGEN  := ${SYNTHTBDIR}/sim_scripts/inp_txn_to_hexdump.pl ${SYNTHINPVECMODE}
		SYNTHCFGGEN     := ${SYNTHTBDIR}/sim_scripts/slave_mem.cfg.pl -outFile ./slave_mem.cfg
		CHECKTEST       := ${SYNTHTBDIR}/sim_scripts/checktest_synthtb.pl
		TB_SIM_DIRS     := --sourcelibdir ${TBDIR} \
		    --sourcelibdir ${VLIBDIR} \
		    -include ${TBDIR} \
	            -include ${DUTDIR} \
	            -sourcelibdir ${VLIBDIR} \
	            -include ${VMODINCDIR} \
	            -include ${DWDIR} \
		    -include .. 
		TB_VCS_BLD_ARGS := ${TB_SIM_DIRS}
		ifeq (${DESIGNWARE_NOEXIST},1)
			TB_VCS_BLD_ARGS += -d DESIGNWARE_NOEXIST
		endif 
	else
		ifeq (${TB_TARGET},qt_synth_tb)
		#not supported
		endif # if TB_TARGET == qt_synth_tb
	endif # if TB_TARGET == synth_tb
endif # if TB_TARGET == sv_tb

# ----------------------------------------------------------------------------
# which dut version to use - cleartext

TARGET := cleartext
# link directories, default to cleartext
ifeq (${TARGET},cleartext)
DUTDIR := dut
VIPDIR := vip
LNMSG  := Using cleartext directories
else # TARGET != cleartext
endif # if TARGET == cleartext

# default:
default:    all

# ----------------------------------------------------------------------------
# REGRESSION SUITE
MINIREGRESS  :? 0
REGRESSTYPE  :? ALL


#Dont use trailing backslash for last test, messes with regress target
ifeq ($(MINIREGRESS),1)
FUNC_REGRESS_LIST := ../traces/traceplayer/sanity0 \
	 		../traces/traceplayer/sanity1 \
			../traces/traceplayer/sanity2 \
			../traces/traceplayer/sanity3 \
			../traces/traceplayer/sanity3_cvsram \
			../traces/traceplayer/conv_8x8_fc_int16 \
			../traces/traceplayer/pdp_max_pooling_int16 \
		 	../traces/traceplayer/sdp_relu_int16

PERF_REGRESS_LIST :=
APP_REGRESS_LIST  := 
else
FUNC_REGRESS_LIST := ../traces/traceplayer/sanity0 \
			../traces/traceplayer/sanity1 \
			../traces/traceplayer/sanity2 \
			../traces/traceplayer/sanity3 \
			../traces/traceplayer/sanity3_cvsram \
			../traces/traceplayer/conv_8x8_fc_int16 \
			../traces/traceplayer/pdp_max_pooling_int16 \
			../traces/traceplayer/sdp_relu_int16

APP_REGRESS_LIST  := 
PERF_REGRESS_LIST := 


endif

REGRESS_LIST := ${PERF_REGRESS_LIST} ${APP_REGRESS_LIST} ${FUNC_REGRESS_LIST}



# ----------------------------------------------------------------------------
# VERDI DETAILS


# ----------------------------------------------------------------------------

DUT_DEFINES    := 

# ----------------------------------------------------------------------------
# RUNTIME

#DEFAULT_PLUSARGS ?= +continue_on_fail 
#+read_reg_poll_retries=100 +read_reg_poll_interval_clocks=55 +read_reg_timeout_clocks=10000 
ifeq ($(DUMP),1)
DEFAULT_PLUSARGS += -testplusarg dump_vcd 
endif

ifdef CUSTOM_PLUSARGS
DEFAULT_PLUSARGS += $(CUSTOM_PLUSARGS)
endif


define TESTDIR_PLUSARGS
$(shell cat $</plusargs.txt)
endef

#$(shell cat ${FULLTESTDIR}/plusargs.txt)
#$(shell while read a; do echo ${a//+/-testplusarg};done < ${FULLTESTDIR}/plusargs.txt)

#$(shell while read a; do echo ${a//+/-testplusarg };done < ${FULLTESTDIR}/plusargs.txt)

define TESTDIR_PLUSARGS_ONE
$(shell while read a; do echo $${a//+/-testplusarg };done < ${FULLTESTDIR}/plusargs.txt)
endef

show_plusargs : 
	${QUIET}${ECHO} "Test plusargs will be set to : ${PLUSARGS} ${TESTDIR_PLUSARGS_ONE} ${DEFAULT_PLUSARGS}"
	${QUIET}${ECHO} "Other VCS args will be : ${VCS_ARGS}"



ifeq ($(DUMP),1)
  ifeq ($(DUMPER),SILOTI)
    #DUMP_ARGS  := +dump_fsdb +dump_name=${SIMTESTDIR}/${SILOTI_DUMP_NAME} +fsdb+esdb=${ESA_ESDB_NAME} +fsdb+dump_log=off
  else
    ifeq ($(DUMPER),VERDI)
      #DUMP_ARGS  := +dump_fsdb +fsdb+dump_log=off +fsdbfile+${SIMTESTDIR}/${VERDI_DUMP_NAME}
    else
      #DUMP_ARGS  := +dump_vpd +vpd_dump_name=${SIMTESTDIR}/${VPD_DUMP_NAME} 
    endif
  endif
endif

# ----------------------------------------------------------------------------
# COMPILETIME

#Needed GENERIC_CELL for compile
#Needed to turn off perfmon_histogram, couldn't find
#Needed to turn PRAND_OFF since no $RollPLI
XSIM_ARGS     := ${DEFFILE} \
		${TB_VCS_BLD_ARGS} \
                -d VIVADO \
                -d NVTOOLS_SYNC2D_GENERIC_CELL \
                -d NO_PERFMON_HISTOGRAM \
                -d PRAND_OFF \
		-sv \

		
		#${TB_VCS_BLD_ARGS} \
                #+define+NVTOOLS_SYNC2D_GENERIC_CELL \
                #+define+NO_PERFMON_HISTOGRAM \
                #+define+PRAND_OFF \


ifeq ($(DUMP),1)
	XSIM_ARGS += -d WAVES
endif

ifeq ($(GUI),1)
  XSIM_RUN_ARGS := --gui
else
  XSIM_RUN_ARGS := --runall
endif

# ----------------------------------------------------------------------------
# TO UNIQUIFY LOGS

DATE	 := $(shell date "+%s")

# ----------------------------------------------------------------------------
# MAKE TARGETS

dut: 
	${QUIET}${ECHO} "DUTDIR = ${DUTDIR}"
	${QUIET}${ECHO} "VIPDIR = ${VIPDIR}"
	${QUIET}${ECHO} "${LNMSG}"

# Build and run sanity
sanity: build run

# Build and run
all:    build regress

#	${QUIET}${TB_PREP} ; \

# Run the compiled simulation
#run: ${COMPILELOG} ${XILINX_EXECUTABLE}
	#${LSF_COMMAND} $(XILINX_HOME)/bin/xsim top --log ${VCS_LOGFILE} ${PLUSARGS} ${TESTDIR_PLUSARGS_ONE} ${DEFAULT_PLUSARGS} ${DUMP_ARGS} +input_file=${SIMTESTDIR}/${INPUTVECTORS} +input_dir=${SIMTESTDIR} ; \

run: ${XILINX_EXECUTABLE}
	${TB_PREP} ; \
	${RM} -f ${SYNTHINPUTVECTORS} ; \
	${RM} -f *.raw2 ; \
	${RM} -f ${VCS_LOGFILE} ; \
	${SYNTHCFGGEN} ${PLUSARGS} ${DEFAULT_PLUSARGS}; \
	${SYNTHINPVECGEN} ${SIMTESTDIR} ; \
	${LSF_COMMAND} $(XILINX_HOME)/bin/xsim top --log ${VCS_LOGFILE} ${XSIM_RUN_ARGS} ${PLUSARGS} ${TESTDIR_PLUSARGS_ONE} ${DEFAULT_PLUSARGS} ${DUMP_ARGS} -testplusarg input_file=${SIMTESTDIR}/${INPUTVECTORS} -testplusarg input_dir=${SIMTESTDIR} ; \
	${CHECKTEST} ./$(TESTLOG); \
	${ECHO} " " ; \
	${ECHO} "NVINFO : ===============================================================" ; \
	${ECHO} "NVINFO : To summarize the results again, run : make check TESTDIR=${TESTDIR}" ; \
	${ECHO} "NVINFO : ===============================================================" ; \
	${ECHO} " "



FUNCTESTLOGLIST=$(FUNC_REGRESS_LIST:=/${TESTLOG})

APPTESTLOGLIST=$(APP_REGRESS_LIST:=/${TESTLOG})

PERFTESTLOGLIST=$(PERF_REGRESS_LIST:=/${TESTLOG})

ALLTESTLOGLIST=$(REGRESS_LIST:=/${TESTLOG})

ifeq ($(REGRESSTYPE),APP)
FULLTESTLOGLIST=$(APPTESTLOGLIST)
FULL_REGRESS_LIST=$(APP_REGRESS_LIST)
else
ifeq ($(REGRESSTYPE),FUNC)
FULLTESTLOGLIST=$(FUNCTESTLOGLIST)
FULL_REGRESS_LIST=$(FUNC_REGRESS_LIST)
else
ifeq ($(REGRESSTYPE),PERF)
FULLTESTLOGLIST=$(PERFTESTLOGLIST)
FULL_REGRESS_LIST=$(PERF_REGRESS_LIST)
else
FULLTESTLOGLIST=$(ALLTESTLOGLIST)
FULL_REGRESS_LIST=$(REGRESS_LIST)
endif
endif
endif

#test.log to ${TESTLOG}?
%/test.log : %
	#TESTDIR      := $<
	#FULLTESTDIR  := ${SIMDIR}/$<
	#TESTNAME     := ${notdir $<}
	#SIMTESTDIR   := ${SIMDIR}/${notdir $<}${TESTSUFFIX}
	${MKDIR} -p ${notdir $<} ; \
	${CP} -Trf ${SIMDIR}/$< ${SIMDIR}/${notdir $<}${TESTSUFFIX} ; \
	${CHDIR} ${SIMDIR}/${notdir $<}${TESTSUFFIX} ; \
	${LN} -fs ${SIMDIR}/${XILINX_EXECUTABLE} ; \
	${RM} -f ${SYNTHINPUTVECTORS} ; \
	${RM} -f *.raw2 ; \
	${RM} -f ${VCS_LOGFILE} ; \
	${SYNTHCFGGEN} ${PLUSARGS} ${DEFAULT_PLUSARGS}; \
	${SYNTHINPVECGEN} ${SIMDIR}/${notdir $<}${TESTSUFFIX} ; \
	${LSF_COMMAND} $(XILINX_HOME)/bin/xsim top --log ${VCS_LOGFILE} ${XSIM_RUN_ARGS} ${PLUSARGS} ${TESTDIR_PLUSARGS_ONE} ${DEFAULT_PLUSARGS} ${DUMP_ARGS} -testplusarg input_file=${SIMTESTDIR}/${INPUTVECTORS} -testplusarg input_dir=${SIMTESTDIR} ; \

regress_list :
	${QUIET}${ECHO} $(FULLTESTLOGLIST)

regress : $(XILINX_EXECUTABLE) $(FULLTESTLOGLIST)
	${QUIET}${ECHO} " "
	${QUIET}${ECHO} "NVINFO : ================================================="
	${QUIET}${ECHO} "NVINFO : Results are as follows:"
	${QUIET}${ECHO} " "
	@- $(foreach T, $(FULL_REGRESS_LIST), \
	     $(CHECKTEST) ${notdir $(T)} $(TESTLOG); \
	     )
	${QUIET}${ECHO} " "
	${QUIET}${ECHO} "NVINFO : ================================================="
ifeq ($(MINIREGRESS),1)
	${QUIET}${ECHO} "NVINFO : To summarize the results again, run : make check_regress MINIREGRESS=1"
else
	${QUIET}${ECHO} "NVINFO : To summarize the results again, run : make check_regress"
endif
	${QUIET}${ECHO} "NVINFO : ================================================="
	${QUIET}${ECHO} " "


regress_check check_regress check_all:  
	@- $(foreach T, $(FULL_REGRESS_LIST), \
	     $(CHECKTEST) ${notdir $(T)} $(TESTLOG); \
	     )

check_cde_tests:  
	@- $(foreach T, $(CDE_REGRESS_LIST), \
	     ./checkCdeTest.pl -dir $(T) -check 1; \
	     )

# Build the example testbench 
${XILINX_EXECUTABLE}:
	${LSF_COMMAND} $(XILINX_HOME)/bin/xvlog timescale.v -f ${DUTFILE} ${XSIM_ARGS} ${TB_FILES} -L ${COMPILELOG} ${DUT_DEFINES}; $(XILINX_HOME)/bin/xelab top --debug all

build : dut
	${LSF_COMMAND} $(XILINX_HOME)/bin/xvlog timescale.v -f ${DUTFILE} ${XSIM_ARGS} ${TB_FILES} -L ${COMPILELOG} ${DUT_DEFINES}; $(XILINX_HOME)/bin/xelab top --debug all




# Deletes all test directory, waveform and logfiles, compile directories and everything generated. The big hammer.
clean:
	${QUIET}${ECHO} "NVINFO : !!!Cleaning directory!!!,  5 seconds to hit ^C to halt!"
	${QUIET}${SLEEP} 5
	${QUIET}${ECHO} "NVINFO : Cleaning ..."
	${QUIET}${RM} -rf *.pb *.log ${XILINX_EXECUTABLE}* webtalk* .Xil
	${QUIET}${RM} -rf ${notdir ${REGRESS_LIST}}
	${QUIET}${ECHO} "NVINFO : Done."

