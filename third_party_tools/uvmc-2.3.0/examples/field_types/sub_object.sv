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

class sub_object extends uvm_sequence_item;

    `uvm_object_utils(sub_object)

    rand int extra_int;

    function new(string name="");
      super.new(name);
    endfunction

    virtual function void do_pack(uvm_packer packer);
      `uvm_pack_int(extra_int)
    endfunction

    virtual function void do_unpack(uvm_packer packer);
      `uvm_unpack_int(extra_int)
    endfunction

    virtual function void do_copy(uvm_object rhs);
      sub_object _rhs;
      assert($cast(_rhs,rhs));
      extra_int = _rhs.extra_int;
    endfunction

    virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      sub_object _rhs;
      assert($cast(_rhs,rhs));
      do_compare = extra_int == _rhs.extra_int;
      comparer.result = 1-do_compare;
    endfunction

    virtual function void do_print(uvm_printer printer);
      printer.print_int("extra_int",extra_int,32,UVM_HEX);
    endfunction

    virtual function void do_record(uvm_recorder recorder);
      `uvm_record_field("extra_int",extra_int)
    endfunction

    virtual function string convert2string();
      return $sformatf("extra_int:%h",extra_int);
    endfunction

  endclass

