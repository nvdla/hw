`ifndef _NVDLA_REG_ADAPTER_SV_
`define _NVDLA_REG_ADAPTER_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_reg_adapter
//
// Extends from uvm_reg_adapter and implement two tasks: reg2bus & bus2reg, for 
// transformation between ral reg transaction and nvdla bus reg transaction (csb)
//-------------------------------------------------------------------------------------
import csb_pkg::*;
import uvm_pkg::*;

class nvdla_reg_adapter #(type T = uvm_sequence_item) extends uvm_reg_adapter;

    string tID;

    `uvm_object_param_utils(nvdla_reg_adapter#(T))

    extern function new(string name = "nvdla_reg_adapter");
    extern function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    extern function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);

endclass : nvdla_reg_adapter

// Function: new
// Creates a new nvdla_reg_adapter component
function nvdla_reg_adapter::new(string name = "nvdla_reg_adapter");
    super.new(name);
    tID = get_type_name().toupper();
endfunction : new

// Function: reg2bus
// Converts register transactions to nvdla bus transaction 
function uvm_sequence_item nvdla_reg_adapter::reg2bus(const ref uvm_reg_bus_op rw);
    T             bus_txn;
    byte unsigned bus_data[];
    byte unsigned byte_en[];
    csb_bus_ext   extension;
    csb_ctrl_ext  ctrl_extension;

    bus_txn   = new("bus_txn");
    //try to get extension from ral.reg.write(.extension())
    $cast(extension, get_item().extension);

    if(extension == null) begin
        extension = new();
        extension.randomize();
    end
    ctrl_extension = new();
    ctrl_extension.randomize();
    bus_txn.set_extension(extension);
    bus_txn.set_extension(ctrl_extension);

    if(rw.kind == UVM_READ) begin
        bus_txn.set_read();
    end
    else if(rw.kind == UVM_WRITE) begin
        bus_txn.set_write();
    end
    bus_txn.set_streaming_width(`CSB_DATA_WIDTH/8);
    bus_txn.set_address(rw.addr);
    byte_en = new[`CSB_DATA_WIDTH/8];
    {<<byte{byte_en}} = {`CSB_DATA_WIDTH{1'b1}};
    bus_txn.set_byte_enable(byte_en);
    bus_txn.set_byte_enable_length(`CSB_DATA_WIDTH/8);

    bus_data = new[`CSB_DATA_WIDTH/8];
    {<<byte{bus_data}} = rw.data[`CSB_DATA_WIDTH-1:0];
    bus_txn.set_data(bus_data);
    bus_txn.set_data_length(`CSB_DATA_WIDTH/8);

    return bus_txn;
endfunction : reg2bus

// Function: bus2reg
// Converts nvdla bus transaction to register transactions
function void nvdla_reg_adapter::bus2reg(uvm_sequence_item bus_item,ref uvm_reg_bus_op rw);
    T             bus_t; 
    byte unsigned bus_data[];

    if(!$cast(bus_t, bus_item)) begin
        `uvm_fatal(tID, "Transaction Type not compatiable")
    end

    if(bus_t.is_read()) begin
        rw.kind = UVM_READ;
    end
    else if(bus_t.is_write()) begin
        rw.kind = UVM_READ;
    end
    rw.addr = bus_t.get_address();
    bus_t.get_data(bus_data);
    rw.data[`CSB_DATA_WIDTH-1:0] = {<<byte{bus_data}};
    rw.status = UVM_IS_OK;
endfunction : bus2reg

`endif // _NVDLA_REG_ADAPTER_SV_
