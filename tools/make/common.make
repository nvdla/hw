#!/usr/bin/make
#
##
## Common.make - common defs and rules (figures out machine dependent stuff)
##

#include $(NV_MAKE_TOOL_DATA)
#include $(NV_MAKE_MK_CHECK)

ECHO ?= echo
EXIT ?= exit


ifeq (1,$(QUITE))
AT := @
else 
AT :=
endif


##
## _default should always be the first dependency (you can add extra local actions with default::)
##
_default:: default

##
## always include the top-level user-editable configuration file tree.make to pick up PROJECTS
##
TREE_MAKE ?= tree.make
include $(DEPTH)/$(TREE_MAKE)

PROJECT ?= $(firstword $(PROJECTS))

OUTDIR ?= outdir

# use the gnu tools in preference to others
include $(DEPTH)/tools/make/tools.mk

# this gross little gmakism returns the last directory component of PWD
#PWD := $(shell pwd)
#DIRNAME := $(subst .,,$(suffix $(subst /,.,$(PWD))))

##
## paths to useful places in the tree
TOT := $(shell $(DEPTH)/tools/bin/depth -abs_tot)
REL_PATH_FROM_TOT := $(shell $(DEPTH)/tools/bin/depth -from_tot)
OUT_DIR := $(TOT)/$(OUTDIR)/$(PROJECT)/$(REL_PATH_FROM_TOT)

PATH_VMOD_INCLUDE := $(TOT)/vmod/include
PATH_SPEC_MANUAL := $(TOT)/spec/manual
PATH_SPEC_ODIF := $(TOT)/spec/odif


OUT_DEF_DIR := $(DEPTH)/$(OUTDIR)/$(PROJECT)/spec/defs
OUT_MAN_DIR := $(DEPTH)/$(OUTDIR)/$(PROJECT)/spec/manual
PROJ_HEAD   := $(OUT_DEF_DIR)/project.h

# Useful target to get the value of a variable.
ifneq (,$(filter getvar_%,$(MAKECMDGOALS)))
$(filter getvar_%,$(MAKECMDGOALS)): getvar_% :
	@echo $($*)
endif
