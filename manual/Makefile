DEPTH := ..
include $(DEPTH)/make/common.make

# the output dir
DIRNAME := $(subst .,,$(suffix $(subst /,.,$(shell pwd))))
OUT_DIR = $(DEPTH)/$(OUTDIR)/$(PROJECT)/$(DIRNAME)

#====================================
# FIXME: change below test parameters and rdl input to real one 
#====================================
REG_PARMS = test.parms
REG_RDL = test.rdl

# several backends 
REG_V = regs_v.v
REG_S = sv/
REG_U = regs_ral.sv
REG_C = cmod
REG_D = dmod
default:
	$(JAVA) -jar Ordt.jar -parms $(REG_PARMS) -systemverilog $(REG_S) -verilog $(REG_V) -uvmregs $(REG_U) -cppmod $(REG_C) -cppdrvmod $(REG_D) $(REG_RDL)
	@mkdir -p $(OUT_DIR)
	@cp -f $(REG_V) $(OUT_DIR)/; rm $(REG_V) -rf
	@cp -f $(REG_U) $(OUT_DIR)/; rm $(REG_U) -rf
	@cp -rf $(REG_S) $(OUT_DIR)/; rm $(REG_S) -rf
	@cp -rf $(REG_C) $(OUT_DIR)/; rm $(REG_C) -rf
	@cp -rf $(REG_D) $(OUT_DIR)/; rm $(REG_D) -rf
	@echo "=============================================="
	@echo "files are generated under $(OUT_DIR)"
	@echo "=============================================="

# ======================
.PHONE: clean
clean:
	rm $(OUT_DIR) -rf
