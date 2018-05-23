DEPTH := ../..
include $(DEPTH)/tools/make/common.make

# define the sub modules

ODIF_FILES := $(shell find . -name "*.odif")
#ODIF_TOP := example.top.odif
ODIF_TOP := nvdla.top.odif

VCP_ODIF_FILES  := $(ODIF_FILES:%=%.vcp)
OUT_ODIF_FILES := $(addprefix $(OUT_DIR)/,$(ODIF_FILES))
OUT_ODIF_TOP := $(addprefix $(OUT_DIR)/,$(ODIF_TOP))

# Make Rules
default: $(OUT_ODIF_TOP)
	@echo "=============================================="
	@echo "files are generated under $(OUT_DIR)"
	@echo "=============================================="

$(OUT_ODIF_FILES) : $(OUT_DIR)/% : % $(PROJ_HEAD) $(VCP) Makefile
ifeq (,$(wildcard $(OUT_DIR)))
	@mkdir -p $(OUT_DIR)
endif
	$(AT)$(VCP) -i $< -o $@ -imacros $(PROJ_HEAD) -cpp $(CPP)

$(OUT_ODIF_TOP) : $(OUT_ODIF_FILES) $(PATH_SPEC_ODIF)/ODIF2others.pl
	$(AT)$(PERL) $(PATH_SPEC_ODIF)/ODIF2others.pl -o $(OUT_DIR) -f $@ -c -sv -v -m

# ======================
.PHONE: clean
clean:
	rm $(OUT_DIR) -rf
