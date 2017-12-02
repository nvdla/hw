DEPTH := ../..
include $(DEPTH)/tools/make/common.make

# ======================
# BACKENDS: define the output file type, add more if you want
# ======================
BACKENDS = h vh

# ======================
OBJECTS = $(BACKENDS:%=project.%)

# the output dir
OUT_DIR = $(TOT)/$(OUTDIR)/$(PROJECT)/$(REL_PATH_FROM_TOT)

default: $(OBJECTS)
	@rm $(OUT_DIR)/project.def
	@echo "=============================================="
	@echo "files are generated under $(OUT_DIR)"
	@echo "=============================================="

$(OUT_DIR)/project.def : $(PROJECT).spec Makefile
	@mkdir -p $(OUT_DIR)
	$(AT)$(CPP) -undef -nostdinc -P -C $< -o $@

# ======================
# RULES: do text substitution for different backends, add more rules when you add more backends
# ======================
project.h : $(OUT_DIR)/project.def
	$(AT)$(DEFGEN) -i $< -o $(OUT_DIR)/$@ -b c

project.vh : $(OUT_DIR)/project.def
	$(AT)$(DEFGEN) -i $< -o $(OUT_DIR)/$@ -b v

# ======================
.PHONE: clean
clean:
	rm $(OUT_DIR) -rf
