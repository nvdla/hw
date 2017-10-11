DEPTH := ../../..
include $(DEPTH)/make/common.make

# ======================
V_FILES := $(shell find . -name "*.v")
V_FILES += $(shell find . -name "*.vh")

# the output dir
DIRNAME := $(subst .,,$(suffix $(subst /,.,$(shell pwd))))
OUT_DIR := $(DEPTH)/$(OUTDIR)/$(PROJECT)/vmod/rams/$(DIRNAME)

DEF_DIR := $(DEPTH)/$(OUTDIR)/$(PROJECT)/defs
PROJ_HEAD := $(DEF_DIR)/project.h

ifeq (,$(wildcard $(PROJ_HEAD)))
    $(error $(PROJ_HEAD) does not exists, please make hw/defs first, exiting...)
endif

O_FILES := $(addprefix $(OUT_DIR)/,$(V_FILES))
default: $(O_FILES)
	@echo "=============================================="
	@echo "files are generated under $(OUT_DIR)"
	@echo "=============================================="

VCP_FILES  := $(V_FILES:%=%.vcp)
$(VCP_FILES) : %.vcp : % $(PROJ_HEAD) $(VCP) 
	$(AT)$(VCP) -i $< -o $@ -imacros $(PROJ_HEAD) -cpp $(CPP)

$(O_FILES) : $(OUT_DIR)/% : %.vcp Makefile $(EPERL)
ifeq (,$(wildcard $(OUT_DIR)))
	@mkdir -p $(OUT_DIR)
endif
	$(AT)$(EPERL) -q -o $@ $< 
	@rm $<

# ======================
.PHONE: clean
clean:
	rm $(OUT_DIR) -rf
