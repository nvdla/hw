DEPTH   := ../..
-include ${DEPTH}/tools/make/common.make
-include ${DEPTH}/tree.make
-include $(TOT)/$(OUTDIR)/$(PROJECT)/spec/defs/project.mk
OUT_DIR := ${DEPTH}/${OUTDIR}/${PROJECT}/${REL_PATH_FROM_TOT}/

MKDIR	:= /bin/mkdir
CP		:= /bin/cp
CHDIR	:= cd
## =========================================================================================
## make target
## =========================================================================================

default: run

run:
	${MKDIR} -p ${OUT_DIR}
	${CP} run_protection.py ${OUT_DIR}/.
	${CHDIR} ${OUT_DIR}; ${PYTHON} run_protection.py -P ${PROJECT}

.PHONY : clean

.PHONY : run

clean:
	${RM} -rf ${OUT_DIR}

