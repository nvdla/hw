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

# We end up hardcoding this, because the .f file applies only to nv_full,
# living in outdir, right now.  Otherwise, you're on your own...
$(DEPTH)/outdir/nv_full/verilator/VNV_nvdla.mk: verilator.f ../../outdir/nv_full/vmod # and a lot of RTL...
	$(VERILATOR) --cc --exe -f verilator.f --Mdir ../../outdir/nv_full/verilator/ nvdla.cpp --compiler clang --output-split 250000000

$(DEPTH)/$(OUTDIR)/$(PROJECT)/verilator/VNV_nvdla: $(DEPTH)/$(OUTDIR)/$(PROJECT)/verilator/VNV_nvdla.mk nvdla.cpp
	rm -f $(DEPTH)/$(OUTDIR)/$(PROJECT)/verilator/nvdla.cpp
	cp nvdla.cpp $(DEPTH)/$(OUTDIR)/$(PROJECT)/verilator/nvdla.cpp
	make -C $(DEPTH)/$(OUTDIR)/$(PROJECT)/verilator -f VNV_nvdla.mk CC=$(CLANG) CXX=$(CLANG)++ VM_PARALLEL_BUILDS=1

$(DEPTH)/$(OUTDIR)/$(PROJECT)/verilator/test/%/trace.bin: $(DEPTH)/verif/traces/traceplayer/% input_txn_to_verilator.pl
	rm -rf $@
	mkdir -p $(dir $@)
	$(PERL) input_txn_to_verilator.pl $< $@

run: $(DEPTH)/$(OUTDIR)/$(PROJECT)/verilator/test/$(TEST)/trace.bin $(DEPTH)/$(OUTDIR)/$(PROJECT)/verilator/VNV_nvdla
	cd $(DEPTH)/$(OUTDIR)/$(PROJECT)/verilator/test/$(TEST) && ../../VNV_nvdla trace.bin
