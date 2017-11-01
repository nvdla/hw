#!/usr/bin/env make

## VARIABLES
TREE_MAKE := tree.make

##
## _default should always be the first dependency (you can add extra local actions with default::)
##

default: $(TREE_MAKE)

DEFAULT_CPP  := /home/utils/gcc-4.0.0/bin/cpp
DEFAULT_GCC  := /home/utils/gcc-4.0.0/bin/g++
DEFAULT_PERL := /home/utils/perl-5.8.8/bin/perl
DEFAULT_JAVA := /home/utils/java/jdk1.8.0_131/bin/java
DEFAULT_PROJ := nv_large nv_small

$(TREE_MAKE): Makefile
	@echo "Creating tree.make to setup your working environment and projects"
	@echo "## ================================================================" >  $@
	@echo "## NVDLA Open Source Project" >> $@
	@echo "## " >> $@
	@echo "## Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the" >> $@
	@echo "## NVDLA Open Hardware License; Check LICENSE which comes with     " >> $@
	@echo "## this distribution for more information. " >> $@
	@echo "## ================================================================" >> $@
	@echo "" >> $@ 	
	@echo "" >> $@ 	
	@echo "##======================= 										  " >> $@ 	
	@echo "## Project Name Setup, multiple projects supported			  	  " >> $@
	@echo "##======================= 										  " >> $@ 	
	@read -p "Enter project names      (Press ENTER to use: $(DEFAULT_PROJ)):" opt_proj; if [ "_$$opt_proj" = "_" ]; then echo "PROJECTS := $(DEFAULT_PROJ)" >> $@;  else echo "PROJECTS := $$opt_proj" >> $@; fi
	@echo "" >> $@ 	
	@echo "##======================= 										  " >> $@ 	
	@echo "##Linux Environment Setup 										  " >> $@ 	
	@echo "##======================= 										  " >> $@ 	
	@echo "  																  " >> $@ 	
	@echo "## c pre-processor			   									  " >> $@
	@read -p "Enter c pre-processor path (Press ENTER to use: $(DEFAULT_CPP)):" opt_cpp; if [ "_$$opt_cpp" = "_" ]; then echo "CPP  := $(DEFAULT_CPP)" >> $@;  else echo "CPP  := $$opt_cpp" >> $@; fi
	@echo "  																  " >> $@ 	
	@echo "## c++ compiler	      		   									  " >> $@
	@read -p "Enter g++ path           (Press ENTER to use: $(DEFAULT_GCC)):" opt_gcc; if [ "_$$opt_gcc" = "_" ]; then echo "GCC  := $(DEFAULT_GCC)" >> $@;  else echo "GCC  := $$opt_gcc" >> $@; fi
	@echo "  																  " >> $@ 	
	@echo "## perl: many scripts is written in perl 							  " >> $@
	@read -p "Enter perl path          (Press ENTER to use: $(DEFAULT_PERL)):" opt_perl; if [ "_$$opt_perl" = "_" ]; then echo "PERL := $(DEFAULT_PERL)" >> $@;  else echo "PERL := $$opt_perl" >> $@; fi
	@echo "  																  " >> $@ 	
	@echo "## java: used in hardware regester spec compilation (not in current release)                       " >> $@
	@read -p "Enter java path          (Press ENTER to use: $(DEFAULT_JAVA)):" opt_java; if [ "_$$opt_java" = "_" ]; then echo "JAVA := $(DEFAULT_JAVA)" >> $@;  else echo "JAVA := $$opt_java" >> $@; fi
	@echo
	@echo "====================================================================="
	@echo "$@ is created successfully, and you can edit $@ manually if necessary"
	@echo "====================================================================="
