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
# Remove compilation files and test dirs
#   make clean
# Normal build and run single test
#   make build
#   make run TESTDIR=../traces/traceplayer/sanity0
# Run with test with waves, use verdi to open
#   make build DUMP=1 DUMPER=VERDI
#   make vericom DUMP=1 DUMPER=VERDI
#   make run DUMP=1 DUMPER=VERDI TESTDIR=../traces/traceplayer/sanity0 
#   make verdi DUMP=1 DUMPER=VERDI TESTDIR=../traces/traceplayer/sanity0 
#
								  
# ----------------------------------------------------------------------------
# TOOL LOCATIONS

  export VCS_HOME   := /home/tools/vcs/mx-2015.09-SP2-9-T0426

  VCS_EXECUTABLE    := ./simv

  export VERDI_HOME := /home/tools/debussy/verdi3_2015.09-SP2-11

  export NOVAS_HOME := /home/tools/debussy/verdi3_2015.09-SP2-11

  export LM_LICENSE_FILE := /home/tools/admin/license_files

  export VCS_CC     := /home/utils/gcc-4.7.2/bin/g++

  export SPYGLASS_HOME := /home/tools/spyglass/SpyGlass-5.2.1.2/SPYGLASS_HOME

  IMAGEVIEWER       := gimp

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
#  DUMPER=DVE    : generate wave file in form for DVE to read
#  DUMPER=VERDI  : generate wave file in form for VERDI to read
#  DUMPER=SILOTI : generate wave file in form for SILOTI to read
#  XPROP=1       : run with xprop args
#  SAIF=1	 : compile and run to generate saif files
#

DUMP	   ?= 0
DUMPER	   ?= DVE

VPD_DUMP_NAME    ?= vcdplus.vpd
VERDI_DUMP_NAME  ?= debussy.fsdb
SILOTI_DUMP_NAME ?= siloti
# Set to 1 if you do not have access to Synopsys Designware modules
DESIGNWARE_NOEXIST ?= 0

XPROP	    ?= 0
SAIF	    ?= 0

# ----------------------------------------------------------------------------
# DIRECTORIES

TOPDIR       := ${dir ${shell ${PWD}}}
DUTDIR       := ${TOPDIR}dut
SIMDIR       := ${TOPDIR}sim
SYNTHTBDIR   := ${TOPDIR}synth_tb
VLIBDIR      := ${TOPDIR}../vmod/vlibs
VMODINCDIR   := ${TOPDIR}../vmod/include
ifeq (${DESIGNWARE_NOEXIST},1)
DWDIR        := ${TOPDIR}../vmod/vlibs
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

DUTFILE      := ${DUTDIR}/dut.f 
LOGFILE      := vcs.log
COMPILELOG   := ${VCS_EXECUTABLE}.compile.log
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
	TBDIR := ${TBDIR}
	VCS_LOGFILE := ${SIMTESTDIR}/${TESTLOG}
	TB_FILES := ${TBDIR}/tb_top.v \
			${AXI_VIPDIR}/nitro_axi_pkg.sv \
			${TBDIR}/tb_test.sv
	TB_PREP	 := ${ECHO}
	SYNTHINPVECMODE := 
	SYNTHINPVECGEN  := /bin/ls
	SYNTHCFGGEN     := ${ECHO}
	CHECKTEST       := ./checktest.pl
	TB_SIM_DIRS     := -y ${AXI_VIPDIR} \
				-y ${TBDIR} \
				+incdir+${AXI_VIPDIR} \
				+incdir+${TBDIR} \
				+incdir+.. 
	TB_VCS_BLD_ARGS := ${TB_SIM_DIRS} \
				-ntb_opts uvm \
				+define+UVM_DISABLE_AUTO_ITEM_RECORDING  \
			 	+define+UVM_NO_RELNOTES 
	ifeq (${DESIGNWARE_NOEXIST},1)
				TB_VCS_BLD_ARGS += +define+DESIGNWARE_NOEXIST
	endif 
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
		TB_FILES       := ${TBDIR}/tb_top.v ${NOT_TOP_TB_FILES}

                #Two step way to ensure we don't create a lower higherarchy with new files
		TB_PREP := ${MKDIR} -p ${SIMTESTDIR} ; \
				${CP} -Trf ${FULLTESTDIR} ${SIMTESTDIR} ; \
				${CHDIR} ${SIMTESTDIR} ; \
				${LN} -fs ${SIMDIR}/${VCS_EXECUTABLE} ; \
				${LN} -fs ${SIMDIR}/${VCS_EXECUTABLE}.daidir

		SYNTHINPVECMODE := 
		SYNTHINPVECGEN  := ${SYNTHTBDIR}/sim_scripts/inp_txn_to_hexdump.pl ${SYNTHINPVECMODE}
		SYNTHCFGGEN     := ${SYNTHTBDIR}/sim_scripts/slave_mem.cfg.pl -outFile ./slave_mem.cfg
		CHECKTEST       := ${SYNTHTBDIR}/sim_scripts/checktest_synthtb.pl
		TB_SIM_DIRS     := -y ${TBDIR} \
		    -y ${VLIBDIR} \
		    +incdir+${TBDIR} \
	            +incdir+${DUTDIR} \
	            +incdir+${VLIBDIR} \
	            +incdir+${VMODINCDIR} \
	            +incdir+${DWDIR} \
		    +incdir+.. 
		TB_VCS_BLD_ARGS := ${TB_SIM_DIRS}
		ifeq (${DESIGNWARE_NOEXIST},1)
			TB_VCS_BLD_ARGS += +define+DESIGNWARE_NOEXIST
		endif 
	else
		ifeq (${TB_TARGET},qt_synth_tb)
			STARTBOARD := "2"
			ifdef USERBOARD
				STARTBOARD := ${USERBOARD}
			endif
			#Loai SIMPWD := ${PWD}
			SIMPWD := ${shell ${PWD}}
			TBDIR	   := ${SYNTHTBDIR}/HDL-ICE
			VCS_LOGFILE     := ${TESTLOG}
			QTTESTDIR       := ${SYNTHTBDIR}/qt_run
			ifdef USERID
				QTTESTDIR   := ${SYNTHTBDIR}/qt_run_${USERID}
			endif
			QTSYNTHESIS    := run_hdlice.qel

			TB_PREP	 := ${MKDIR} -p ${SIMTESTDIR} ; \
					${CP} -Trf ${FULLTESTDIR} ${SIMTESTDIR} ; \
					${CHDIR} ${SIMTESTDIR} ; \
					${LN} -f ${SIMDIR}/${VCS_EXECUTABLE} ; \
					${LN} -f ${SIMDIR}/${VCS_EXECUTABLE}.daidir
			SYNTHINPVECMODE := 256
			SYNTHINPVECGEN := ${SYNTHTBDIR}/sim_scripts/inp_txn_to_hexdump.pl ${SYNTHINPVECMODE}
			#Loai SYNTHCFGGEN     := ${SYNTHTBDIR}/sim_scripts/slave_mem.cfg.pl -outFile ./slave_mem.cfg
			SYNTHCFGGEN     := ${SYNTHTBDIR}/sim_scripts/slave_mem.cfg.pl -outFile /${SYNTHTBDIR}/sim_scripts/slave_mem.cfg
			CHECKTEST      := ${SYNTHTBDIR}/sim_scripts/checktest_synthtb.pl
			TB_SIM_DIRS    := -y ${TBDIR} \
			    +incdir+${TBDIR} \
			    +incdir+.. 
			TB_VCS_BLD_ARGS := ${TB_SIM_DIRS}
			ifeq (${DESIGNWARE_NOEXIST},1)
				TB_VCS_BLD_ARGS += +define+DESIGNWARE_NOEXIST
			endif 
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



# ----------------------------------------------------------------------------
# REGRESSION SUITE
MINIREGRESS  :? 0
REGRESSTYPE  :? ALL


#Dont use trailing backslash for last test, messes with regress target
ifeq ($(MINIREGRESS),1)
FUNC_REGRESS_LIST := ../traces/traceplayer/sanity0 \
		     ../traces/traceplayer/sanity1 \
		     ../traces/traceplayer/sanity2 \
		     ../traces/traceplayer/sanity3

PERF_REGRESS_LIST :=
APP_REGRESS_LIST  := 
else
FUNC_REGRESS_LIST := ../traces/traceplayer/sanity0 \
			../traces/traceplayer/sanity1 \
			../traces/traceplayer/sanity2 \
			../traces/traceplayer/sanity3 \
			../traces/first_release/conv_8x8_fc_int16

APP_REGRESS_LIST  := 
PERF_REGRESS_LIST := 


endif

REGRESS_LIST := ${PERF_REGRESS_LIST} ${APP_REGRESS_LIST} ${FUNC_REGRESS_LIST}



# ----------------------------------------------------------------------------
# VERDI DETAILS

ifeq ($(DUMP),1)
  ifeq ($(DUMPER),SILOTI)
    VERDI_PLI	  :=  +vpi +vcsd -P $(VERDI_HOME)/share/PLI/VCS/LINUX64/novas.tab $(VERDI_HOME)/share/PLI/VCS/LINUX64/pli.a  
    VERDI_LD_FLAGS     :=  -LDFLAGS -Wl,-rpath,$(VERDI_HOME)/share/PLI/VCS/LINUX64
  else
    ifeq ($(DUMPER),VERDI)
      VERDI_PLI	  :=  +vpi +vcsd -P $(VERDI_HOME)/share/PLI/VCS/LINUX64/novas.tab $(VERDI_HOME)/share/PLI/VCS/LINUX64/pli.a  
      VERDI_LD_FLAGS     :=  -LDFLAGS -Wl,-rpath,$(VERDI_HOME)/share/PLI/VCS/LINUX64
    else
      VERDI_PLI	  := 
      VERDI_LD_FLAGS     :=
    endif
  endif
else
  VERDI_PLI	  := +define+NO_DUMPS
  VERDI_LD_FLAGS     :=
endif


VERICOM_LIB	:= ${VCS_EXECUTABLE}work
VERICOM_LIB_DIR := $(VERICOM_LIB).lib++
VERICOM_LOG_DIR := ${VCS_EXECUTABLE}vericomLog
VERICOM_LOG	:= $(VERICOM_LOG_DIR)/compiler.log

VERICOM_DUTFILE     := ../${DUTDIR}/dut.f
VERICOM_TOPFILE     := ${TBDIR}/tb_top.v
ESA_BBOX_FLAGS      :=  
VERICOM_DUT_DEFINES := +define+VERDI_VIEWING +define+NO_PERFMON_HISTOGRAM
VERDI_BDB_OPTIONS   := -bdb_load ${VERICOM_LIB_DIR}/${VCS_EXECUTABLE}work.bdb

ifeq ($(XPROP),1)
VERICOM_DUT_DEFINES += +define+XPROP
endif

ESA_ESDB_NAME    := ${VCS_EXECUTABLE}esa
ESA_LOG_DIR	 := ${VCS_EXECUTABLE}esaLog


# ----------------------------------------------------------------------------

DUT_DEFINES    := 

# ----------------------------------------------------------------------------
# RUNTIME

DEFAULT_PLUSARGS ?= +continue_on_fail +read_reg_poll_retries=100 +read_reg_poll_interval_clocks=100 +read_reg_timeout_clocks=100000 

ifdef CUSTOM_PLUSARGS
DEFAULT_PLUSARGS += $(CUSTOM_PLUSARGS)
endif


ifeq ($(SAIF),1)
DEFAULT_PLUSARGS += +dump_saif +saif_start_trans=229000 +saif_end_trans=231600 +dump_top_saif +dump_smm_saif
endif

define TESTDIR_PLUSARGS
$(shell cat $</plusargs.txt)
endef

define TESTDIR_PLUSARGS_ONE
$(shell cat ${FULLTESTDIR}/plusargs.txt)
endef

show_plusargs : 
	${QUIET}${ECHO} "Test plusargs will be set to : ${PLUSARGS} ${TESTDIR_PLUSARGS_ONE} ${DEFAULT_PLUSARGS}"
	${QUIET}${ECHO} "Other VCS args will be : ${VCS_ARGS}"


#TODO - pick one . right now 2013.06 can drop upsched and vcsevalorder
# VCS_TIMING_ARGS  := +nospecify +notimingchecks +udpsched +vcsevalorder +define+VLIB_NO_UDP
VCS_TIMING_ARGS  := +nospecify +notimingchecks +define+VLIB_NO_UDP
VCS_OK_WARNINGS  := +warn=noTFIPC +warn=noTMR

VCS_64BIT_ARGS   := -full64

ifeq ($(DUMP),1)
  ifeq ($(DUMPER),SILOTI)
    DUMP_ARGS  := +dump_fsdb +dump_name=${SIMTESTDIR}/${SILOTI_DUMP_NAME} +fsdb+esdb=${ESA_ESDB_NAME} +fsdb+dump_log=off
  else
    ifeq ($(DUMPER),VERDI)
      DUMP_ARGS  := +dump_fsdb +fsdb+dump_log=off +fsdbfile+${SIMTESTDIR}/${VERDI_DUMP_NAME}
    else
      DUMP_ARGS  := +dump_vpd +vpd_dump_name=${SIMTESTDIR}/${VPD_DUMP_NAME} 
    endif
  endif
endif

# ----------------------------------------------------------------------------
# COMPILETIME

#Needed GENERIC_CELL for compile
#Needed to turn off perfmon_histogram, couldn't find
#Needed to turn PRAND_OFF since no $RollPLI
VCS_ARGS     := ${DEFFILE} \
		${VCS_TIMING_ARGS} \
		${VCS_OK_WARNINGS} \
		${VCS_64BIT_ARGS} \
		${TB_VCS_BLD_ARGS} \
		+vcs+lic+wait \
		-sverilog \
		+libext+.v \
		+libext+.sv \
		-timescale=1ns/1ns \
		-debug_all \
                +define+NVTOOLS_SYNC2D_GENERIC_CELL \
		+define+NO_PERFMON_HISTOGRAM \
		+define+PRAND_OFF \

ifeq ($(SAIF),1)
	VCS_ARGS += +vcs+saif_libcell
	VCS_ARGS += +define+SAIF
endif

ifeq ($(XPROP),1)
	VCS_ARGS += -xprop=xp_merge
	VCS_ARGS += +define+XPROP
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
run: ${COMPILELOG} ${VCS_EXECUTABLE}
	${TB_PREP} ; \
	${RM} -f ${SYNTHINPUTVECTORS} ; \
	${RM} -f *.raw2 ; \
	${RM} -f ${VCS_LOGFILE} ; \
	${SYNTHCFGGEN} ${PLUSARGS} ${DEFAULT_PLUSARGS}; \
	${SYNTHINPVECGEN} ${SIMTESTDIR} ; \
	${LSF_COMMAND} ${VCS_EXECUTABLE} -l ${VCS_LOGFILE} ${PLUSARGS} ${TESTDIR_PLUSARGS_ONE} ${DEFAULT_PLUSARGS} ${DUMP_ARGS} +input_file=${SIMTESTDIR}/${INPUTVECTORS} +input_dir=${SIMTESTDIR} ; \
	${CHECKTEST} ./$(TESTLOG); \
	${ECHO} " " ; \
	${ECHO} "NVINFO : ===============================================================" ; \
	${ECHO} "NVINFO : To summarize the results again, run : make check TESTDIR=${TESTDIR}" ; \
	${ECHO} "NVINFO : ===============================================================" ; \
	${ECHO} " "

runqt: 
	if [ -a ${QTTESTDIR}/run_${USERID}.qel ]; then chmod +w ${QTTESTDIR}/run_${USERID}.qel; fi;
	if [ -a ${QTTESTDIR}/qt_setup.pl ]; then chmod +w ${QTTESTDIR}/qt_setup.pl; fi;
	if [ -a ${QTTESTDIR}/createSession ]; then chmod +w ${QTTESTDIR}/createSession; fi;
	#cp qt_setup.pl ${QTTESTDIR}; cp run_${USERID}.qel ${QTTESTDIR}; cd ${QTTESTDIR}; ./qt_setup.pl $(shell echo "-t ${TESTDIR} -b ${STARTBOARD} -p ${SIMPWD} -u ${USERID}"); xeDebug -gui run_${USERID}.qel $(shell echo "${TESTDIR}_${USERID}" | sed 's,^.*/,,');  ./qt_setup.pl $(shell echo "-k -u ${USERID}")
	cp qt_setup.pl ${QTTESTDIR}; touch ${QTTESTDIR}/hdfuse.qel; cp createSession ${QTTESTDIR}; cp run_${USERID}.qel ${QTTESTDIR}; cd ${QTTESTDIR}; ./qt_setup.pl $(shell echo "-t ${TESTDIR} -b ${STARTBOARD} -p ${SIMPWD} -u ${USERID}"); ./createSession $(shell echo "${TESTDIR}_${USERID}_${STARTBOARD}" | sed 's,^.*/,,')  run_${USERID}.qel;  ./qt_setup.pl $(shell echo "-k -u ${USERID}")

checkqt:
	if [ -a ${QTTESTDIR}/qt_setup.pl ]; then chmod +w ${QTTESTDIR}/qt_setup.pl; fi;
	cp qt_setup.pl ${QTTESTDIR}; cd ${QTTESTDIR}; ./qt_setup.pl $(shell echo "-t ${TESTDIR} -b ${STARTBOARD} -p ${SIMPWD} -v -u ${USERID}")

check:
	${QUIET}${ECHO} "Checking $(SIMTESTDIR)/$(TESTLOG) "
	${CHECKTEST} ${TESTNAME} ${TESTLOG}; 

view:
	${QUIET}${RM} -f ${SIMTESTDIR}/out.bmp
	${QUIET}${ECHO} "Generating ${SIMTESTDIR}/out.bmp "
	${QUIET}  ./bin2bmp.pl -src ${SIMTESTDIR}/bmp.info
	${QUIET}${IMAGEVIEWER} ${SIMTESTDIR}/out.bmp


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
	${LN} -fs ${SIMDIR}/${VCS_EXECUTABLE} ; \
	${LN} -fs ${SIMDIR}/${VCS_EXECUTABLE}.daidir ; \
	${RM} -f ${SYNTHINPUTVECTORS} ; \
	${RM} -f *.raw2 ; \
	${RM} -f ${VCS_LOGFILE} ; \
	${SYNTHCFGGEN} ${PLUSARGS} ${DEFAULT_PLUSARGS}; \
	${SYNTHINPVECGEN} ${SIMDIR}/${notdir $<}${TESTSUFFIX} ; \
	${LSF_COMMAND} ${VCS_EXECUTABLE} -l ${VCS_LOGFILE} ${PLUSARGS} ${TESTDIR_PLUSARGS_ONE} ${DEFAULT_PLUSARGS} ${DUMP_ARGS} +input_file=${SIMDIR}/${notdir $<}${TESTSUFFIX}/${INPUTVECTORS} +input_dir=${SIMDIR}/${notdir $<}${TESTSUFFIX} ;

regress_list :
	${QUIET}${ECHO} $(FULLTESTLOGLIST)

regress : $(VCS_EXECUTABLE) $(FULLTESTLOGLIST)
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
${VCS_EXECUTABLE}:
	${LSF_COMMAND} $(VCS_HOME)/bin/vcs -f ${DUTFILE} -Xddg=0x1 -o ${VCS_EXECUTABLE} -cpp ${VCS_CC} ${VCS_ARGS} ${VERDI_PLI} ${TB_FILES} -l ${COMPILELOG} ${DUT_DEFINES} ${VERDI_LD_FLAGS} ${VCS_PARTIION_ARGS}

build : dut
	${LSF_COMMAND} $(VCS_HOME)/bin/vcs -f ${DUTFILE} -Xddg=0x1 -o ${VCS_EXECUTABLE} -cpp ${VCS_CC} ${VCS_ARGS} ${VERDI_PLI} ${TB_FILES} -l ${COMPILELOG} ${DUT_DEFINES} ${VERDI_LD_FLAGS} ${VCS_PARTIION_ARGS} -Mdir=${VCS_EXECUTABLE}Csrc ; ./checkcompile.pl ${COMPILELOG} ${VCS_EXECUTABLE}

# Build dumper
dumper:  vericom esa

buildqt : 
	if [ -a ${TBDIR}/run_hdlice.qel ]; then chmod +w ${TBDIR}/run_hdlice.qel; fi;
	mkdir ${TBDIR}; cp run_hdlice.qel ${TBDIR}; cd ${TBDIR}; xeCompile ${QTSYNTHESIS}

buildsg:
	${SPYGLASS_HOME}/bin/spyglass -verilog \
	-enable_pass_exit_codes \
	-enableSV \
	-report moresimple \
	-wdir spyglass \
	+define+SYNTHESIS \
	+define+EMU_TB \
	+incdir+${SYNTHTBDIR} \
	-batch \
	-top top \
	-waiver synth_tb.swl \
	-templatedir /home/nvtools/engr/2014/12/31_04_57_36/nvtools/spyglass/nvidia-policies/SpyGlass-5.2.1.2 \
	-template Lint  \
	${TBDIR}/tb_top.v \
	${TBDIR}/csb_master.v \
	${TBDIR}/csb_master_seq.v \
	${TBDIR}/axi_slave.v \
	${TBDIR}/id_fifo.v \
	${TBDIR}/memresp_fifo.v \
	${TBDIR}/raddr_fifo.v \
	${TBDIR}/slave_mem_wrap.v \
	${TBDIR}/waddr_fifo.v \
	${TBDIR}/wdata_fifo.v \
	${TBDIR}/wstrb_fifo.v

#	${TBDIR}/memory.v 
#		${TB_FILES}
#		${SYNTHTBDIR}/tb_top.v 
#		${SYNTHTBDIR}/clk_divider.v 
#		${SYNTHTBDIR}/slave2mem_rd.v 
#		${SYNTHTBDIR}/slave2mem_wr.v 

vericom ${VERICOM_LOG} :
	${LSF_COMMAND} ${VERDI_HOME}/bin/vericom -vc -sv ${TB_SIM_DIRS} ${VERICOM_TOPFILE} ${VERICOM_DUT_DEFINES} ${NOT_TOP_TB_FILES} +libext+.v+.sv -y ${VLIBDIR} +incdir+${VLIBDIR} +incdir+${VMODINCDIR} $(if $(VERICOM_DUTFILE), -f ${VERICOM_DUTFILE},)  -logdir ${VERICOM_LOG_DIR} -lib ${VERICOM_LIB}

# Build esential signal list
esa  : ${VERICOM_LOG}
	${LSF_COMMAND} ${VERDI_HOME}/bin/esa -ssy -ssv -top top  -lib_cell 1 -exclude 'p_PGAOPV_SEDFCND2 PGAOPV_BUFFD2 PGAOPV_BUFFD8 sync_reset sync1d sync1d_c_p sync1d_cs_p sync1d_s_p sync1dn sync1dn_c_p sync2d sync2d_c_np sync2d_c_pp sync2d_lvt sync2d_lvt_c_pp sync2d_lvt_s_pp sync2d_np sync2d_s_pp sync2d_w140lvt_c_pp sync2d_w140lvt_s_pp sync3d sync3d_c_ppp sync3d_lvt sync3d_lvt_c_ppp sync3d_lvt_reset sync3d_lvt_s_ppp sync3d_reset sync3d_reset_g sync3d_s_ppp sync4d sync4d_c_pppp sync4d_reset sync4d_s_pppp' -libPath ${VERICOM_LIB_DIR} -lib ${VERICOM_LIB} -db ${ESA_ESDB_NAME} -bdb_file ${VERICOM_LIB} ${ESA_BBOX_FLAGS} -logdir ${ESA_LOG_DIR}

# Run the Verdi waveform viewer
verdi :
	${LSF_COMMAND} $(VERDI_HOME)/bin/verdi -ssy -ssv -nologo -lib ${VERICOM_LIB} ${VERDI_BDB_OPTIONS} -top 'top' -DE '-full_time'  ${VERICOM_DUT_DEFINES} -tkName siloti_tkName_nvdla -ssf ${SIMTESTDIR}/${VERDI_DUMP_NAME} &

# Run the Verdi waveform viewer with smaller esa fsdb
siloti :
	${LSF_COMMAND} $(VERDI_HOME)/bin/verdi -ssy -ssv -nologo -lib ${VERICOM_LIB} ${VERDI_BDB_OPTIONS} -top 'top' -DE '-full_time' -tkName siloti_tkName_nvdla -logdir silotiLog -ssf ${SIMTESTDIR}/${SILOTI_DUMP_NAME} &

# Run the DVE waveform viewer
dve:
	${LSF_COMMAND} ${VCS_HOME}/bin/dve -full64 -vpd ${SIMTESTDIR}/${VPD_DUMP_NAME} &

# Deletes all test directory, waveform and logfiles.
clean_tests:
	${QUIET}${ECHO} "NVINFO : !!!Cleaning Test directories!!!,  5 seconds to hit ^C to halt!"
	${QUIET}${SLEEP} 5
	${QUIET}${ECHO} "NVINFO : Cleaning ..."
	${QUIET}${RM} -f tests/*/*.log tests/*/*.fsdb tests/*/*.vf test/*/*.vpd

clean_regress_logs :
	${QUIET}${ECHO} "NVINFO : Removing The following logs in  5 seconds.  hit ^C to halt!"
	${QUIET}${ECHO} $(FULLTESTLOGLIST)
	${QUIET}${SLEEP} 5
	${QUIET}${RM} $(FULLTESTLOGLIST)

# Deletes all test directory, waveform and logfiles, compile directories and everything generated. The big hammer.
clean:
	${QUIET}${ECHO} "NVINFO : !!!Cleaning directory!!!,  5 seconds to hit ^C to halt!"
	${QUIET}${SLEEP} 5
	${QUIET}${ECHO} "NVINFO : Cleaning ..."
	${QUIET}${RM} -rf ${VCS_EXECUTABLE}Csrc csrc *.vpd *.fsdb *.vf *.log DVEfiles ${VCS_EXECUTABLE}* urgReport *.prof vcs.key novas.* vc_hdrs.h .vcsmx_rebuild ucli.key silotiLog verdiLog ${ESA_ESDB_NAME}.esdb++ esaLog ${VERICOM_LOG_DIR} ${VERICOM_LIB_DIR} tests/*/*.log tests/*/*.fsdb tests/*/*.vf test/*/*.vpd
	${QUIET}${ECHO} "NVINFO : Done."
