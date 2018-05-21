// ===================================================================
// CLASS: nvdla_coverage_top
//     a) build covergroup for each module
//     b) receive csb gp and conduct coverage sample
// ===================================================================

class nvdla_coverage_top extends uvm_subscriber#(uvm_tlm_gp);

    string                  tID;

    ral_sys_top             ral;
    /*
        Ping-Pong RAL Pool:
        Used for sampling coverage of different groups of scenario, which contains
        multiple resources and must be sampled together, for example: cdprdma_cdp
    */
    ral_sys_top             ral_grps[2];

    conv_cov_pool           conv_pool;
`ifdef NVDLA_BDMA_ENABLE
    bdma_cov_pool           bdma_pool;
`endif
    sdp_cov_pool            sdp_pool;
    cdp_cov_pool            cdp_pool;
    pdp_cov_pool            pdp_pool;
`ifdef NVDLA_RUBIK_ENABLE
    rubik_cov_pool          rubik_pool;
`endif

    uvm_tlm_gp              txn_queue[$];

    `uvm_component_utils(nvdla_coverage_top)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        tID = name.toupper();
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `uvm_info(tID, "build_phase is executed", UVM_HIGH)

        if (!uvm_config_db#(ral_sys_top)::get(this, "", "ral", ral)) begin
            `uvm_fatal(tID, "Can't find RAL resource in config db")
        end

        conv_pool  = new("conv_pool" , ral);
`ifdef NVDLA_BDMA_ENABLE
        bdma_pool  = new("bdma_pool" , ral);
`endif
        sdp_pool   = new("sdp_pool"  , ral);
        cdp_pool   = new("cdp_pool"  , ral);
        pdp_pool   = new("pdp_pool"  , ral);
`ifdef NVDLA_RUBIK_ENABLE
        rubik_pool = new("rubik_pool", ral);
`endif

        foreach(ral_grps[i]) begin
            ral_grps[i] = ral_sys_top::type_id::create({"ral_grp_",i}, this);
            ral_grps[i].build();
            ral_grps[i].reset();
            ral_grps[i].lock_model();
        end
    endfunction : build_phase

    function void write(uvm_tlm_gp t);
        if (t.is_read()) return;
        txn_queue.push_back(t);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_tlm_gp txn;
        forever begin
            wait (txn_queue.size() > 0);
            txn = txn_queue.pop_front();
            cov_sample(txn);
        end
    endtask

    task cov_sample(uvm_tlm_gp gp);
        `uvm_info(tID, $sformatf("Got csb txn for coverage sample:\n%s", gp.sprint()), UVM_HIGH)

        if (gp.get_address() >= ral.nvdla.NVDLA_SDP.S_LUT_ACCESS_CFG.get_address()
         && gp.get_address() <= ral.nvdla.NVDLA_SDP.S_LUT_LO_SLOPE_SHIFT.get_address()) begin // SDP LUT
`ifdef NVDLA_SDP_LUT_ENABLE
            sdp_pool.sdp_lut_sample(ral);
`endif
        end
        else if (gp.get_address() >= ral.nvdla.NVDLA_CDP.S_LUT_ACCESS_CFG.get_address()
              && gp.get_address() <= ral.nvdla.NVDLA_CDP.S_LUT_LO_SLOPE_SHIFT.get_address()) begin // CDP LUT
            cdp_pool.cdp_lut_sample(ral);
        end
        else begin
            case(gp.get_address())
                ral.nvdla.NVDLA_CDMA.D_OP_ENABLE.get_address():       begin
                    if(ral_grps[0].nvdla.NVDLA_CSC.D_OP_ENABLE.OP_EN.value == 1) begin
                        ral_copy(ral_grps[0].nvdla, ral.nvdla, "NVDLA_CDMA");
                        conv_pool.sample(ral_grps[0]);
                        ral_grps[0].nvdla.NVDLA_CDMA.reset();
                        ral_grps[0].nvdla.NVDLA_CSC.reset();
                        ral_grps[0].nvdla.NVDLA_CMAC_A.reset();
                        ral_grps[0].nvdla.NVDLA_CMAC_B.reset();
                        ral_grps[0].nvdla.NVDLA_CACC.reset();
                    end
                    else if(ral_grps[1].nvdla.NVDLA_CSC.D_OP_ENABLE.OP_EN.value == 1) begin
                        ral_copy(ral_grps[1].nvdla, ral.nvdla, "NVDLA_CDMA");
                        conv_pool.sample(ral_grps[1]);
                        ral_grps[1].nvdla.NVDLA_CDMA.reset();
                        ral_grps[1].nvdla.NVDLA_CSC.reset();
                        ral_grps[1].nvdla.NVDLA_CMAC_A.reset();
                        ral_grps[1].nvdla.NVDLA_CMAC_B.reset();
                        ral_grps[1].nvdla.NVDLA_CACC.reset();
                    end
                    else if(ral_grps[0].nvdla.NVDLA_CDMA.D_OP_ENABLE.OP_EN.value == 0) begin
                        ral_copy(ral_grps[0].nvdla, ral.nvdla, "NVDLA_CDMA");
                    end
                    else begin
                        ral_copy(ral_grps[1].nvdla, ral.nvdla, "NVDLA_CDMA");
                    end
                end
                ral.nvdla.NVDLA_CSC.D_OP_ENABLE.get_address():        begin
                    if(ral_grps[0].nvdla.NVDLA_CDMA.D_OP_ENABLE.OP_EN.value == 1) begin
                        ral_copy(ral_grps[0].nvdla, ral.nvdla, "NVDLA_CSC");
                        ral_copy(ral_grps[0].nvdla, ral.nvdla, "NVDLA_CMAC_A");
                        ral_copy(ral_grps[0].nvdla, ral.nvdla, "NVDLA_CMAC_B");
                        ral_copy(ral_grps[0].nvdla, ral.nvdla, "NVDLA_CACC");
                        conv_pool.sample(ral_grps[0]);
                        ral_grps[0].nvdla.NVDLA_CDMA.reset();
                        ral_grps[0].nvdla.NVDLA_CSC.reset();
                        ral_grps[0].nvdla.NVDLA_CMAC_A.reset();
                        ral_grps[0].nvdla.NVDLA_CMAC_B.reset();
                        ral_grps[0].nvdla.NVDLA_CACC.reset();
                    end
                    else if(ral_grps[1].nvdla.NVDLA_CDMA.D_OP_ENABLE.OP_EN.value == 1) begin
                        ral_copy(ral_grps[1].nvdla, ral.nvdla, "NVDLA_CSC");
                        ral_copy(ral_grps[1].nvdla, ral.nvdla, "NVDLA_CMAC_A");
                        ral_copy(ral_grps[1].nvdla, ral.nvdla, "NVDLA_CMAC_B");
                        ral_copy(ral_grps[1].nvdla, ral.nvdla, "NVDLA_CACC");
                        conv_pool.sample(ral_grps[1]);
                        ral_grps[1].nvdla.NVDLA_CDMA.reset();
                        ral_grps[1].nvdla.NVDLA_CSC.reset();
                        ral_grps[1].nvdla.NVDLA_CMAC_A.reset();
                        ral_grps[1].nvdla.NVDLA_CMAC_B.reset();
                        ral_grps[1].nvdla.NVDLA_CACC.reset();
                    end
                    else if(ral_grps[0].nvdla.NVDLA_CSC.D_OP_ENABLE.OP_EN.value == 0) begin
                        ral_copy(ral_grps[0].nvdla, ral.nvdla, "NVDLA_CSC");
                        ral_copy(ral_grps[0].nvdla, ral.nvdla, "NVDLA_CMAC_A");
                        ral_copy(ral_grps[0].nvdla, ral.nvdla, "NVDLA_CMAC_B");
                        ral_copy(ral_grps[0].nvdla, ral.nvdla, "NVDLA_CACC");
                    end
                    else begin
                        ral_copy(ral_grps[1].nvdla, ral.nvdla, "NVDLA_CSC");
                        ral_copy(ral_grps[1].nvdla, ral.nvdla, "NVDLA_CMAC_A");
                        ral_copy(ral_grps[1].nvdla, ral.nvdla, "NVDLA_CMAC_B");
                        ral_copy(ral_grps[1].nvdla, ral.nvdla, "NVDLA_CACC");
                    end
                end
`ifdef NVDLA_BDMA_ENABLE
                ral.nvdla.NVDLA_BDMA.CFG_OP.get_address():            bdma_pool.sample(ral);
                ral.nvdla.NVDLA_BDMA.CFG_LAUNCH0.get_address():       bdma_pool.sample(ral);
                ral.nvdla.NVDLA_BDMA.CFG_LAUNCH1.get_address():       bdma_pool.sample(ral);
`endif
                ral.nvdla.NVDLA_SDP_RDMA.D_OP_ENABLE.get_address():   sdp_pool.sdp_rdma_sample(ral);
                ral.nvdla.NVDLA_SDP.D_OP_ENABLE.get_address():        sdp_pool.sdp_sample(ral);
                ral.nvdla.NVDLA_CDP_RDMA.D_OP_ENABLE.get_address():   begin
                    if(ral_grps[0].nvdla.NVDLA_CDP.D_OP_ENABLE.OP_EN.value == 1) begin
                        ral_copy(ral_grps[0].nvdla, ral.nvdla, "NVDLA_CDP_RDMA");
                        cdp_pool.sample(ral_grps[0]);
                        ral_grps[0].nvdla.NVDLA_CDP.reset();
                        ral_grps[0].nvdla.NVDLA_CDP_RDMA.reset();
                    end
                    else if(ral_grps[1].nvdla.NVDLA_CDP.D_OP_ENABLE.OP_EN.value == 1) begin
                        ral_copy(ral_grps[1].nvdla, ral.nvdla, "NVDLA_CDP_RDMA");
                        cdp_pool.sample(ral_grps[1]);
                        ral_grps[1].nvdla.NVDLA_CDP.reset();
                        ral_grps[1].nvdla.NVDLA_CDP_RDMA.reset();
                    end
                    else if(ral_grps[0].nvdla.NVDLA_CDP_RDMA.D_OP_ENABLE.OP_EN.value == 0) begin
                        ral_copy(ral_grps[0].nvdla, ral.nvdla, "NVDLA_CDP_RDMA");
                    end
                    else begin
                        ral_copy(ral_grps[1].nvdla, ral.nvdla, "NVDLA_CDP_RDMA");
                    end
                end
                ral.nvdla.NVDLA_CDP.D_OP_ENABLE.get_address():        begin
                    if(ral_grps[0].nvdla.NVDLA_CDP_RDMA.D_OP_ENABLE.OP_EN.value == 1) begin
                        ral_copy(ral_grps[0].nvdla, ral.nvdla, "NVDLA_CDP");
                        cdp_pool.sample(ral_grps[0]);
                        ral_grps[0].nvdla.NVDLA_CDP.reset();
                        ral_grps[0].nvdla.NVDLA_CDP_RDMA.reset();
                    end
                    else if(ral_grps[1].nvdla.NVDLA_CDP_RDMA.D_OP_ENABLE.OP_EN.value == 1) begin
                        ral_copy(ral_grps[1].nvdla, ral.nvdla, "NVDLA_CDP");
                        cdp_pool.sample(ral_grps[1]);
                        ral_grps[1].nvdla.NVDLA_CDP.reset();
                        ral_grps[1].nvdla.NVDLA_CDP_RDMA.reset();
                    end
                    else if(ral_grps[0].nvdla.NVDLA_CDP.D_OP_ENABLE.OP_EN.value == 0) begin
                        ral_copy(ral_grps[0].nvdla, ral.nvdla, "NVDLA_CDP");
                    end
                    else begin
                        ral_copy(ral_grps[1].nvdla, ral.nvdla, "NVDLA_CDP");
                    end
                end
                ral.nvdla.NVDLA_PDP_RDMA.D_OP_ENABLE.get_address():   pdp_pool.pdp_rdma_sample(ral);
                ral.nvdla.NVDLA_PDP.D_OP_ENABLE.get_address():        pdp_pool.pdp_sample(ral);
`ifdef NVDLA_RUBIK_ENABLE
                ral.nvdla.NVDLA_RBK.D_OP_ENABLE.get_address():        rubik_pool.sample(ral);
`endif
                default: `uvm_info(tID, $sformatf("Common Reg, No Coverage Sample"), UVM_HIGH)
            endcase
        end
    endtask : cov_sample

    task ral_copy(ref block_addrmap_NVDLA dst_ral, input block_addrmap_NVDLA src_ral, input string blk_name);
        uvm_reg_block dst_blk;
        uvm_reg_block src_blk;
        uvm_reg       regs[$];
        uvm_reg_field flds[$];
        uvm_reg       reg_;
        uvm_reg_field fld_;

        dst_blk = dst_ral.get_block_by_name(blk_name);
        src_blk = src_ral.get_block_by_name(blk_name);
        src_blk.get_registers(regs);
        foreach(regs[i]) begin
            reg_ = dst_blk.get_reg_by_name(regs[i].get_name());
            regs[i].get_fields(flds);
            foreach(flds[j]) begin
                fld_ = reg_.get_field_by_name(flds[j].get_name());
                fld_.randomize() with {value == flds[j].value;};
            end
            flds.delete();
        end
        regs.delete();
    endtask : ral_copy

endclass : nvdla_coverage_top

