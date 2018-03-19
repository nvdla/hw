//
//------------------------------------------------------------//
//   Copyright 2009-2012 Mentor Graphics Corporation          //
//   All Rights Reserved Worldwid                             //
//                                                            //
//   Licensed under the Apache License, Version 2.0 (the      //
//   "License"); you may not use this file except in          //
//   compliance with the License.  You may obtain a copy of   //
//   the License at                                           //
//                                                            //
//       http://www.apache.org/licenses/LICENSE-2.0           //
//                                                            //
//   Unless required by applicable law or agreed to in        //
//   writing, software distributed under the License is       //
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR   //
//   CONDITIONS OF ANY KIND, either express or implied.  See  //
//   the License for the specific language governing          //
//   permissions and limitations under the License.           //
//------------------------------------------------------------//

`ifndef PACKET__SV
`define PACKET__SV

//-----------------------------------------------------------------------------
// Class- packet
//-----------------------------------------------------------------------------
`include "uvm_macros.svh"
import uvm_pkg::*;


class packet extends uvm_object;

  `uvm_object_utils(packet)

  rand shortint cmd;
  rand int addr;
  rand byte data[$];

  function new(string name="");
    super.new(name);
  endfunction

  constraint C_data { data.size() inside {[1:8]}; }

  virtual function void do_pack(uvm_packer packer);
    super.do_pack(packer);
    `uvm_pack_int(cmd)
    `uvm_pack_int(addr)
    `uvm_pack_queue(data)
  endfunction

  virtual function void do_unpack(uvm_packer packer);
    super.do_unpack(packer);
    `uvm_unpack_int(cmd)
    `uvm_unpack_int(addr)
    `uvm_unpack_queue(data)
  endfunction


  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    packet rhs_;
    if (!$cast(rhs_,rhs)) begin
      `uvm_fatal("PKT/COMPARE/BADTYPE",$sformatf("Argument rhs (name=%s type=%s), is not of type packet",rhs.get_name(),rhs.get_type_name()))
      return 0;
    end
    if (!super.do_compare(rhs,comparer))
      return 0;
    if (cmd  != rhs_.cmd)  comparer.result++;
    if (addr != rhs_.addr) comparer.result++;
    if (data != rhs_.data) comparer.result++;
    return (comparer.result == 0);
  endfunction


  function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field("cmd",cmd,16);
    printer.print_field("addr",addr,32);
    printer.print_array_header("data",data.size(),"queue(byte)");
    foreach (data[i])
      printer.print_field($sformatf("[%0d]",i),data[i],8);
    printer.print_array_footer(data.size());
  endfunction

endclass

`endif
