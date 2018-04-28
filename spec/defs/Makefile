DEPTH := ../..
-include ${DEPTH}/tree.make
include $(DEPTH)/tools/make/common.make

# ======================
# BACKENDS: define the output file type, add more if you want
# ======================
BACKENDS = h vh py mk pm

# ======================
OBJECTS = $(BACKENDS:%=project.%)

# the output dir
OUT_DIR = $(TOT)/$(OUTDIR)/$(PROJECT)/$(REL_PATH_FROM_TOT)

default: $(OBJECTS)
	@echo "=============================================="
	@echo "files are generated under $(OUT_DIR)"
	@echo "=============================================="

$(OUT_DIR)/project.def : $(PROJECT).spec projects.spec Makefile
	@mkdir -p $(OUT_DIR)
	$(AT)$(CPP) -undef -nostdinc -P -C $< -o $@

# ======================
# RULES: do text substitution for different backends, add more rules when you add more backends
# ======================
project.h : $(OUT_DIR)/project.def
	$(AT)$(PYTHON) $(DEFGEN) -i $< -o $(OUT_DIR)/$@ -b c
	@echo "" >> $(OUT_DIR)/$@
	@echo "#define USE_DESIGNWARE ${USE_DESIGNWARE}" >> $(OUT_DIR)/$@

project.vh : $(OUT_DIR)/project.def
	$(AT)$(PYTHON) $(DEFGEN) -i $< -o $(OUT_DIR)/$@ -b v
#ifeq (${USE_DESIGNWARE},0)
#	@echo "" >> $(OUT_DIR)/$@
#	@echo "\`define DESIGNWARE_NOEXIST 1" >> $(OUT_DIR)/$@
#endif

project.py : $(OUT_DIR)/project.def
	$(AT)$(PYTHON) $(DEFGEN) -i $< -o $(OUT_DIR)/$@ -b py

project.mk : $(OUT_DIR)/project.def
	$(AT)$(PYTHON) $(DEFGEN) -i $< -o $(OUT_DIR)/$@ -b mk

project.pm : $(OUT_DIR)/project.def
	$(AT)$(PYTHON) $(DEFGEN) -i $< -o $(OUT_DIR)/$@ -b pm

# ======================

# ======================
.PHONE: clean
clean:
	rm $(OUT_DIR) -rf
