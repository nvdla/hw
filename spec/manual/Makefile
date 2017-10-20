DEPTH := ../..
include $(DEPTH)/tools/make/common.make

# the output dir
OUT_DIR = $(TOT)/$(OUTDIR)/$(PROJECT)/$(REL_PATH_FROM_TOT)

#====================================
# FIXME: change below test parameters and rdl input to real one 
#====================================
REG_PARMS = test.parms
REG_RDL = test.rdl

# several backends 
REG_V = $(OUT_DIR)/regs_v.v
REG_S = $(OUT_DIR)/sv/
REG_U = $(OUT_DIR)/regs_ral.sv
REG_C = $(OUT_DIR)/cmod
REG_D = $(OUT_DIR)/dmod
default:
	@mkdir -p $(OUT_DIR)
	$(AT)$(JAVA) -jar Ordt.jar -parms $(REG_PARMS) -systemverilog $(REG_S) -verilog $(REG_V) -uvmregs $(REG_U) -cppmod $(REG_C) -cppdrvmod $(REG_D) $(REG_RDL)
	#@cp -f $(REG_V) $(OUT_DIR)/; rm $(REG_V) -rf
	#@cp -f $(REG_U) $(OUT_DIR)/; rm $(REG_U) -rf
	#@cp -rf $(REG_S) $(OUT_DIR)/; rm $(REG_S) -rf
	#@cp -rf $(REG_C) $(OUT_DIR)/; rm $(REG_C) -rf
	#@cp -rf $(REG_D) $(OUT_DIR)/; rm $(REG_D) -rf
	@echo "=============================================="
	@echo "files are generated under $(OUT_DIR)"
	@echo "=============================================="

# ======================
.PHONE: clean
clean:
	rm $(OUT_DIR) -rf
