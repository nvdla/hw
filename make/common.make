#!/usr/bin/make
#
##
## Common.make - common defs and rules (figures out machine dependent stuff)
##

#include $(NV_MAKE_TOOL_DATA)
#include $(NV_MAKE_MK_CHECK)

ECHO ?= echo
EXIT ?= exit

##
## _default should always be the first dependency (you can add extra local actions with default::)
##
_default:: default

##
## always include the top-level user-editable configuration file tree.make to pick up PROJECTS
##
#TREE_MAKE ?= tree.make
#include $(TREE_ROOT)/$(TREE_MAKE)
PROJECT ?= $(firstword $(PROJECTS))

OUTDIR ?= outdir

# use the gnu tools in preference to others
include $(TREE_ROOT)/make/tools.mk

# this gross little gmakism returns the last directory component of PWD
#PWD := $(shell pwd)
#DIRNAME := $(subst .,,$(suffix $(subst /,.,$(PWD))))

##
## paths to useful places in the tree
##

#DEFDIR := $(TREE_ROOT)/defs
#MANDIR := $(TREE_ROOT)/manuals
#MAKDIR := $(TREE_ROOT)/make
#CMODDIR := $(TREE_ROOT)/cmod
#VMODDIR := $(TREE_ROOT)/vmod
#VINCDIR := $(VMODDIR)/include
#VLIBDIR := $(VMODDIR)/vlibs
#SYNTH_RAMDIR := $(VMODDIR)/rams/synth
#MODEL_RAMDIR := $(VMODDIR)/rams/model

# include $(OUTDIR)/$(PROJECT)/defs/project.mk

# Useful target to get the value of a variable.
ifneq (,$(filter getvar_%,$(MAKECMDGOALS)))
$(filter getvar_%,$(MAKECMDGOALS)): getvar_% :
	@echo $($*)
endif
