// ===================================================================
// CLASS: nvdla_coverage_top
//     a) build covergroup for each module
//     b) receive csb gp and conduct coverage sample
// ===================================================================

class nvdla_coverage_top extends uvm_subscriber#(uvm_tlm_gp);

    string                  tID;

    ral_sys_top             ral;

    conv_cov_pool           conv_pool;
//  bdma_cov_pool           bdma_pool;
    sdp_cov_pool            sdp_pool;
    cdp_cov_pool            cdp_pool;
    pdp_cov_pool            pdp_pool;
//  rubik_cov_pool          rubik_pool;

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
//      bdma_pool  = new("bdma_pool" , ral);
        sdp_pool   = new("sdp_pool"  , ral);
        cdp_pool   = new("cdp_pool"  , ral);
        pdp_pool   = new("pdp_pool"  , ral);
//      rubik_pool = new("rubik_pool", ral);
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
            sdp_pool.sdp_lut_sample();
        end
        else if (gp.get_address() >= ral.nvdla.NVDLA_CDP.S_LUT_ACCESS_CFG.get_address()
              && gp.get_address() <= ral.nvdla.NVDLA_CDP.S_LUT_LO_SLOPE_SHIFT.get_address()) begin // CDP LUT
            cdp_pool.cdp_lut_sample();
        end
        else begin
            case(gp.get_address())
                ral.nvdla.NVDLA_CDMA.D_OP_ENABLE.get_address():       conv_pool.sample();
//              ral.nvdla.NVDLA_BDMA.CFG_OP.get_address():            bdma_pool.sample();
//              ral.nvdla.NVDLA_BDMA.CFG_LAUNCH0.get_address():       bdma_pool.sample();
//              ral.nvdla.NVDLA_BDMA.CFG_LAUNCH1.get_address():       bdma_pool.sample();
                ral.nvdla.NVDLA_SDP_RDMA.D_OP_ENABLE.get_address():   sdp_pool.sdp_rdma_sample();
                ral.nvdla.NVDLA_SDP.D_OP_ENABLE.get_address():        sdp_pool.sdp_sample();
                ral.nvdla.NVDLA_CDP_RDMA.D_OP_ENABLE.get_address():   cdp_pool.sample();
                ral.nvdla.NVDLA_CDP.D_OP_ENABLE.get_address():        cdp_pool.sample();
                ral.nvdla.NVDLA_PDP_RDMA.D_OP_ENABLE.get_address():   pdp_pool.sample();
                ral.nvdla.NVDLA_PDP.D_OP_ENABLE.get_address():        pdp_pool.sample();
//              ral.nvdla.NVDLA_RBK.D_OP_ENABLE.get_address():        rubik_pool.sample();
                default: `uvm_info(tID, $sformatf("Common Reg, No Coverage Sample"), UVM_HIGH)
            endcase
        end
    endtask : cov_sample

endclass : nvdla_coverage_top

