# Makefile
# Build system for Verilator testbench
# NVDLA Open Source Project
#
# Copyright (c) 2017 NVIDIA Corporation.  Licensed under the NVDLA Open
# Hardware License.  For more information, see the "LICENSE" file that came
# with this distribution.

DEPTH = ../..
include $(DEPTH)/tools/make/common.make

default: $(DEPTH)/$(OUTDIR)/$(PROJECT)/verilator/VNV_nvdla

VERILATOR_PARAMS ?= --compiler clang --output-split 250000000
# Perhaps you need to trace?
#   VERILATOR_PARAMS += --trace --trace-depth 7 --trace-max-array 8

# Perhaps you want to optimize?
#   VERILATOR_PARAMS += -O3
#   VMAKE_PARAMS += OPT_FAST=-O

# We end up hardcoding this, because the .f file applies only to nv_full,
# living in outdir, right now.  Otherwise, you're on your own...
$(DEPTH)/outdir/$(PROJECT)/verilator/VNV_nvdla.mk: verilator_$(PROJECT).f ../../outdir/$(PROJECT)/vmod # and a lot of RTL...
	$(VERILATOR) $(VERILATOR_PARAMS) --cc --exe -f verilator_$(PROJECT).f --Mdir ../../outdir/$(PROJECT)/verilator/ nvdla.cpp --compiler clang --output-split 250000000

$(DEPTH)/$(OUTDIR)/$(PROJECT)/verilator/VNV_nvdla: $(DEPTH)/$(OUTDIR)/$(PROJECT)/verilator/VNV_nvdla.mk nvdla.cpp
	rm -f $(DEPTH)/$(OUTDIR)/$(PROJECT)/verilator/nvdla.cpp
	cp nvdla.cpp $(DEPTH)/$(OUTDIR)/$(PROJECT)/verilator/nvdla.cpp
	make -C $(DEPTH)/$(OUTDIR)/$(PROJECT)/verilator -f VNV_nvdla.mk CC=$(CLANG) CXX=$(CLANG)++ VM_PARALLEL_BUILDS=1 $(VMAKE_PARAMS)

$(DEPTH)/$(OUTDIR)/$(PROJECT)/verilator/test/%/trace.bin: $(DEPTH)/verif/tests/trace_tests/$(PROJECT)/%/ new_trace_to_verilator.py
	rm -rf $@
	mkdir -p $(dir $@)
	cd $(dir $@) && $(abspath $(DEPTH))/verif/tools/nvdla_trace_parser.py --file_path $(abspath $</$*.cfg)
	PYTHONPATH=$(DEPTH)/outdir/nv_small/spec/manual $(PYTHON) new_trace_to_verilator.py $(dir $@) $@

run: $(DEPTH)/$(OUTDIR)/$(PROJECT)/verilator/test/$(TEST)/trace.bin $(DEPTH)/$(OUTDIR)/$(PROJECT)/verilator/VNV_nvdla
	cd $(DEPTH)/$(OUTDIR)/$(PROJECT)/verilator/test/$(TEST) && ../../VNV_nvdla trace.bin
