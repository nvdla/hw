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
`include "ovm_macros.svh"
import ovm_pkg::*;


class packet extends ovm_object;

  `ovm_object_utils(packet)

  rand shortint cmd;
  rand int addr;
  rand byte data[$];

  function new(string name="");
    super.new(name);
  endfunction

  constraint C_data_size { data.size() inside {[1:16]}; }

  // OVM does not have the `ovm_pack_* macros, so must use the packer API
  virtual function void do_pack(ovm_packer packer);
    packer.pack_field_int(cmd,16);
    packer.pack_field_int(addr,32);
    packer.pack_field_int(data.size(),32);
    foreach (data[i])
      packer.pack_field_int(data[i],8);
  endfunction

  virtual function void do_unpack(ovm_packer packer);
    int sz;
    cmd = packer.unpack_field_int(16);
    addr = packer.unpack_field_int(32);
    sz = packer.unpack_field_int(32);
    data.delete();
    for (int i=0; i < sz; i++)
      data.push_back( packer.unpack_field_int(8) );
  endfunction


  virtual function void do_copy(ovm_object rhs);
    packet rhs_;
    if (!$cast(rhs_,rhs)) begin
      `ovm_fatal("PKT/COPY/BADTYPE",
         $sformatf("Argument rhs (name=%s type=%s), is not of type packet",
                   rhs.get_name(),rhs.get_type_name()))
      return;
    end
    super.do_copy(rhs);
    cmd  = rhs_.cmd;
    addr = rhs_.addr;
    data = rhs_.data;
  endfunction


  virtual function bit do_compare(ovm_object rhs, ovm_comparer comparer);
    packet rhs_;
    if (!$cast(rhs_,rhs)) begin
      `ovm_fatal("PKT/COMPARE/BADTYPE",
         $sformatf("Argument rhs (name=%s type=%s), is not of type packet",
                   rhs.get_name(),rhs.get_type_name()))
      return 0;
    end
    if (!super.do_compare(rhs,comparer))
      return 0;
    if (cmd  != rhs_.cmd)  comparer.result++;
    if (addr != rhs_.addr) comparer.result++;
    if (data != rhs_.data) comparer.result++;
    return (comparer.result == 0);
  endfunction


  function void do_print(ovm_printer printer);
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
