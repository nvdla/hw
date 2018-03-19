//This is the release area for the Open Source UVMConnect Library from Mentor Graphics
//
//UVM Connect is an open-source UVM-based library that provides TLM1 and TLM2 connectivity and object passing between SystemC and SystemVerilog UVM models and components. It also provides a UVM Command API for accessing and controlling UVM simulation from SystemC (or C or C++). 
//UVM Connect allows you to reuse your SystemC architectural models as reference models in UVM verification and/or reuse SystemVerilog UVM agents to verify models in SystemC. It also effectively expands your VIP portfolio since you now have access to VIP in both languages. UVM Connect allows you easily to develop integrated verification environments where you take advantage of the strengths of each language to maximize your verification productivity.

//Files:
//uvmc-2.3.0/ - This folder contains the extracted version of the above package with some fixes to the example code.

Added uvm_1.2 compatiblity fixes:
* Removed the use of factory variable, instead use the uvm_factory::get()
** File: src/connect/sv/uvmc_commands.sv
** Function: UVMC_set_config_object
** Modification: add factory variable declaration
