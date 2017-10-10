DEPTH := ..
include $(DEPTH)/tree.make
include $(DEPTH)/make/common.make

# ======================
# BACKENDS: define the output file type, add more if you want
# ======================
BACKENDS = h vh

# ======================
OBJECTS = $(BACKENDS:%=project.%)

# the output dir
DIRNAME := $(subst .,,$(suffix $(subst /,.,$(shell pwd))))
OUT_DIR = $(DEPTH)/$(OUTDIR)/$(PROJECT)/$(DIRNAME)

default: $(OBJECTS)
	@rm $(OUT_DIR)/project.def
	@echo "=============================================="
	@echo "files are generated under $(OUT_DIR)"
	@echo "=============================================="

$(OUT_DIR)/project.def : $(PROJECT).spec Makefile
	@mkdir -p $(OUT_DIR)
	$(CPP) -undef -nostdinc -P -C $< -o $@

# ======================
# RULES: do text substitution for different backends, add more rules when you add more backends
# ======================
project.h : $(OUT_DIR)/project.def
	@$(SED) 's/DEFINE/#define/g' $< > $(OUT_DIR)/$@

project.vh : $(OUT_DIR)/project.def
	@$(SED) 's/DEFINE/`define/g' $< > $(OUT_DIR)/$@

# ======================
.PHONE: clean
clean:
	rm $(OUT_DIR) -rf
