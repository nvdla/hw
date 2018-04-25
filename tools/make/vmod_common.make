#!/usr/bin/make
##
## vmod_common.make - common defs and rules for vmod
##
include $(DEPTH)/tools/make/common.make

I_FILES := $(shell find . -name "*.vh")
I_FILES += $(shell find . -name "*.v")
I_FILES += $(shell find . -name "*.vlib")
I_FILES += $(shell find . -name "*.swl")
V_FILES  := $(I_FILES:./%=%)

H_FILES := $(shell find . -name "*.h")
H_FILES += $(shell find $(PATH_VMOD_INCLUDE) -name "*.h")

# GET Project Define file path/name

#===================================
# Variables
#===================================
# GET OUTPUT FILE PATH
OUT_DIR := $(DEPTH)/$(OUTDIR)/$(PROJECT)/$(REL_PATH_FROM_TOT)
O_FILES := $(addprefix $(OUT_DIR)/,$(V_FILES))
VCP_FILES  := $(V_FILES:%=%.vcp)
O_VCP_FILES := $(addprefix $(OUT_DIR)/,$(VCP_FILES))

#===================================
# Rules
#===================================
default: $(O_FILES)
	@echo "=============================================="
	@echo "files are generated under $(TOT)/$(OUTDIR)/$(PROJECT)/$(REL_PATH_FROM_TOT)"
	@echo "=============================================="

$(O_VCP_FILES) : $(OUT_DIR)/%.vcp : % $(PROJ_HEAD) $(H_FILES) $(VCP) Makefile
ifeq (,$(wildcard $(OUT_DIR)))
	@mkdir -p $(OUT_DIR)
endif
	$(VCP) -i $< -o $@ -imacros $(PROJ_HEAD) -inc $(PATH_VMOD_INCLUDE) -inc $(OUT_MAN_DIR) -cpp $(CPP)

$(O_FILES) : % : %.vcp Makefile $(EPERL)
ifeq (,$(wildcard $(OUT_DIR)))
	@mkdir -p $(OUT_DIR)
endif
	$(PERL) -I $(DEPTH)/vmod/plugins -Meperl $(EPERL) -o $@ $< 

# ======================
.PHONE: clean
clean:
	rm $(OUT_DIR) -rf
