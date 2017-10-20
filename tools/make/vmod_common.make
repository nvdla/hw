#!/usr/bin/make
##
## vmod_common.make - common defs and rules for vmod
##
include $(DEPTH)/tools/make/common.make

V_FILES := $(shell find . -name "*.vh")
V_FILES += $(shell find . -name "*.h")
V_FILES += $(shell find . -name "*.v")
V_FILES += $(shell find . -name "*.vlib")

# GET Project Define file path/name
OUT_DEF_DIR := $(DEPTH)/$(OUTDIR)/$(PROJECT)/spec/defs
PROJ_HEAD   := $(OUT_DEF_DIR)/project.h
ifeq (,$(wildcard $(PROJ_HEAD)))
    $(error $(PROJ_HEAD) does not exists, please make hw/spec/defs first, exiting...)
endif

# GET OUTPUT FILE PATH
OUT_DIR := $(DEPTH)/$(OUTDIR)/$(PROJECT)/$(REL_PATH_FROM_TOT)
O_FILES := $(addprefix $(OUT_DIR)/,$(V_FILES))

default: $(O_FILES)
	@echo "=============================================="
	@echo "files are generated under $(TOT)/$(OUTDIR)/$(PROJECT)/$(REL_PATH_FROM_TOT)"
	@echo "=============================================="

VCP_FILES  := $(V_FILES:%=%.vcp)
$(VCP_FILES) : %.vcp : % $(PROJ_HEAD) $(VCP) 
	$(VCP) -i $< -o $@ -imacros $(PROJ_HEAD) -cpp $(CPP)

$(O_FILES) : $(OUT_DIR)/% : %.vcp Makefile $(EPERL)
ifeq (,$(wildcard $(OUT_DIR)))
	@mkdir -p $(OUT_DIR)
endif
	#$(EPERL) -o $@ $< 
	$(PERL) -I $(DEPTH)/vmod/plugins -Meperl $(EPERL) -o $@ $< 
	@rm $<

# ======================
.PHONE: clean
clean:
	rm $(OUT_DIR) -rf
