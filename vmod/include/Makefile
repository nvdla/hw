DEPTH := ../..
include $(DEPTH)/make/common.make

# ======================
V_FILES := $(shell find . -name "*.vh")
V_FILES += $(shell find . -name "*.h")
V_FILES += $(shell find . -name "*.v")

S_FILES  := $(filter-out ./HLS%,$(V_FILES))

# the output dir
DIRNAME := $(subst .,,$(suffix $(subst /,.,$(shell pwd))))
OUT_DIR := $(DEPTH)/$(OUTDIR)/$(PROJECT)/vmod/$(DIRNAME)

O_FILES := $(addprefix $(OUT_DIR)/,$(S_FILES))

DEF_DIR := $(DEPTH)/$(OUTDIR)/$(PROJECT)/defs
PROJ_HEAD := $(DEF_DIR)/project.h

ifeq (,$(wildcard $(PROJ_HEAD)))
    $(error $(PROJ_HEAD) does not exists, please make hw/defs first, exiting...)
endif

default: $(O_FILES)
	@echo "=============================================="
	@echo "files are generated under $(OUT_DIR)"
	@echo "=============================================="

$(O_FILES) : $(OUT_DIR)/% : % Makefile $(PROJ_HEAD) $(VCP) 
	mkdir -p $(OUT_DIR)
	$(VCP) -i $< -o $@ -imacros $(PROJ_HEAD) -cpp $(CPP)

# ======================
.PHONE: clean
clean:
	rm $(OUT_DIR) -rf
