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

`include "ovm_macros.svh"
import ovm_pkg::*; 

`include "sub_object.sv"

//-----------------------------------------------------------------------------
// Example: Data Type Support
//-----------------------------------------------------------------------------
//
// This example shows a full implementation of a UVM-compliant transaction type
// whose fields represent all the data types supported by the UVMC library.
// Although the example defines all the ~do_*~ operations, UVMC requires only
// ~do_pack~ and ~do_unpack~.
//-----------------------------------------------------------------------------
 

//------------------------------------------------------------------------------
// Class: packet
//
// Defines a packet class containing a field for each of the data types
// supported by UVMC.
//
// integrals - bit, byte, shortint, int, longint long, and their unsigned
//           counterparts.
//
// enum    - user-defined enumeration types are packed by their numeric
//           value. A compatible enumeration type must be defined on
//           the SC side.
//
// reals   - shortreal and real translate to SC-side float and double,
//           respectively.
//
// strings - use only for ASCII strings. Use vector<char> for
//           an array of bytes whose elements can include the '0' value
//
// arrays  - fixed arrays, queues, dynamic arrays, and associate arrays
//           are supported as long as the element and key types are among
//           the supported types. These types are analogous to the STL
//           vector<T>, list<T>, and map<KEY,T> types in C++.
//
// time    - packed as 64-bit values. Equates to the SC 'sc_time' type.
//
// sc data types - The SV bit-vector and logic-vector types are mapped
//           to any of the following SC built-in types: sc_bit, sc_logic,
//           sc_bv<N>, sc_lv<N>, sc_int<N>, sc_uint<N>, sc_bigint<N>, and
//           sc_biguint<N>, for any valid width, N. For any given N, the
//           SV-side declaration should be ~bit [N-1:0] var_name~. See
//           the SC-side definition of ~packet~.
//
// Although <do_pack> and <do_unpack> are the only methods required by UVMC,
// this example also implements <do_copy>, <do_compare>, <do_print>, and
// <do_record>. There are many reasons for opting to implement the ~do_*~
// methods as below instead of using the ~`ovm_field~ macros. For details,
// see the white paper, ~OVM/UVM Macros: A Cost-Benefit Analysis~, at
// http://www.verificationacademy.com. 
//------------------------------------------------------------------------------

// (begin inline source)
class packet extends ovm_object;

   // default converter assumes trans derives from ovm_object
   `ovm_object_utils(packet)

   function new(string name="");
     super.new(name);
   endfunction

    typedef enum { ADD, SUBTRACT, MULTIPLY, DIVIDE } cmds_t;

    rand cmds_t            enum32;

    rand longint           int64;
    rand int               int32;
    rand shortint          int16;
    rand byte              int8;
    rand bit               int1;

    rand longint unsigned  uint64;
    rand int unsigned      uint32;
    rand shortint unsigned uint16;
    rand byte unsigned     uint8;
    rand bit unsigned      uint1;

         real              real64;

    rand time              time64;

         string            str;

    rand int               arr[3];
    rand byte              q[$];
    rand shortint          da[];
         shortint          aa[shortint];

    rand sub_object        obj;

    rand bit               scbit;
    rand logic             sclogic;
    rand bit [16:0]        scbv;
    rand logic [34:0]      sclv;
    rand bit [5:0]         scint;
    rand bit [24:0]        scuint;
    rand bit [36:0]        scbigint;
    rand bit [61:0]        scbiguint;


    constraint C_q_size  { q.size  inside {[1:11]}; }
    constraint C_da_size { da.size inside {[1:11]}; }

    // (end inline source)


    //--------------------------------------------------------------------------
    // Function: do_pack
    //
    // Converts this transaction's contents into a form transferrable outside
    // SystemVerilog.
    //
    // Each field is packed using the smaller, more efficient packing macros
    // included in UVM. Associative arrays are packed by first packing its
    // size in a 32-bit value. Then, you pack each key-value pair use the
    // macro appropriate for their types.
    //
    // Subobjects are packed by calling ~packer.pack_object(subob);~.
    //
    // If your transaction extends a base class with its own fields, call
    // ~super.do_pack(packer)~ before packing anything in this class.

    // (begin inline source)
    virtual function void do_pack(ovm_packer packer);

      packer.pack_field_int(enum32,32);
      packer.pack_field_int(int64,64);
      packer.pack_field_int(int32,32);
      packer.pack_field_int(int16,16);
      packer.pack_field_int(int8,8);
      packer.pack_field_int(int1,1);
      packer.pack_field_int(uint64,64);
      packer.pack_field_int(uint32,32);
      packer.pack_field_int(uint16,16);
      packer.pack_field_int(uint8,8);
      packer.pack_field_int(uint1,1);
      packer.pack_field_int(scbit,1);
      packer.pack_field_int(sclogic,1);
      packer.pack_field_int(scbv,17);
      packer.pack_field_int(sclv,35);
      packer.pack_field_int(scint,6);
      packer.pack_field_int(scuint,25);
      packer.pack_field_int(scbigint,37);
      packer.pack_field_int(scbiguint,62);
      packer.pack_time(time64);
      packer.pack_real(real64);
      packer.pack_string(str);

      foreach (arr[i]) begin
        packer.pack_field_int(arr[i],32);
      end

      packer.pack_field_int(q.size(),32);
      foreach (q[i]) begin
        packer.pack_field_int(q[i],8);
      end

      packer.pack_field_int(da.size(),32);
      foreach (da[i]) begin
        packer.pack_field_int(da[i],16);
      end

      packer.pack_field_int(aa.size(),32);
      foreach (aa[i]) begin
        packer.pack_field_int(i,16);
        packer.pack_field_int(aa[i],16);
      end

      packer.pack_object(obj);

    endfunction
    // (end inline source)


    //--------------------------------------------------------------------------
    // Function: do_unpack
    //
    // Converts a bit-vector representation of a transaction into this
    // transaction object. 
    //
    // The order and manner of unpacking must be identical to
    // how packing was performed. Packing an object then unpacking
    // into a new instance of the object should be equivalent to copying
    // the original object, minus any fields that were not packed.
    //
    // Each field is unpacked using the smaller, more efficient unpacking macros
    // included in UVM.
    //
    // Associative arrays are packed by first packing its
    // size in a 32-bit value. Then, you pack each key-value pair use the
    // macro appropriate for their types.
    //
    // To unpack sub-objects, first call ~packer.is_null()~ to determine if the
    // packed sub-object is null or now. If not, you set this transaction's
    // sub-object to null. If ~is_null~ returns 0, then alloate ~obj~ if
    // its null and call ~packer.unpack_object()~.
    //
    // If your transaction extends a base class with its own fields, call
    // ~super.do_unpack(packer)~ before unpacking anything in this class.
    //
    // Instead of the macros, you could call methods of the packer for every
    // field, just as you do for sub-objects. However, packing of built-in
    // integral types is less efficient, and there is no methods for unpacking
    // arrays.
   
    // (begin inline source)
    virtual function void do_unpack(ovm_packer packer);

      int unsigned n;
       
      n = packer.unpack_field_int(32);
      enum32 = cmds_t'(n);

      int64     = packer.unpack_field_int(64);
      int32     = packer.unpack_field_int(32);
      int16     = packer.unpack_field_int(16);
      int8      = packer.unpack_field_int(8);
      int1      = packer.unpack_field_int(1);
      uint64    = packer.unpack_field_int(64);
      uint32    = packer.unpack_field_int(32);
      uint16    = packer.unpack_field_int(16);
      uint8     = packer.unpack_field_int(8);
      uint1     = packer.unpack_field_int(1);
      scbit     = packer.unpack_field_int(1);
      sclogic   = packer.unpack_field_int(1);
      scbv      = packer.unpack_field_int(17);
      sclv      = packer.unpack_field_int(35);
      scint     = packer.unpack_field_int(6);
      scuint    = packer.unpack_field_int(25);
      scbigint  = packer.unpack_field_int(37);
      scbiguint = packer.unpack_field_int(62);
      time64    = packer.unpack_time();
      real64    = packer.unpack_real();
      str       = packer.unpack_string();


      foreach (arr[i]) begin
        arr[i] = packer.unpack_field_int(32);
      end

      n = packer.unpack_field_int(32);
      q.delete();
      for (int i=0; i<n; i++) begin
        q.push_back(packer.unpack_field_int(8));
      end

      n = packer.unpack_field_int(32);
      da = new[n];
      for (int i=0; i<n; i++) begin
        da[i] = packer.unpack_field_int(16);
      end

      aa.delete();
      n = packer.unpack_field_int(32);
      for (int i=0; i<n; i++) begin
        shortint k, val;
        k = packer.unpack_field_int(16);
        val = packer.unpack_field_int(16);
        aa[k]=val;
      end

      if (packer.is_null())
        obj = null;
      else begin
        if (obj == null)
          obj = new();
        packer.unpack_object(obj);
      end

    endfunction
    // (end inline source)


    //--------------------------------------------------------------------------
    // Function: do_copy
    //
    // Copies the values of fields from another object of the same type into
    // this object. 
    //
    // Do_copy uses the assignment operator for all built-in types. Subobjects
    // are copied by calling ~subobj.copy(_rhs.subobj)~.
    //
    // If your transaction extends a base class with its own fields, call
    // ~super.do_copy(rhs)~ before copying anything in this class.
    //

    // (begin inline source)
    function void do_copy(ovm_object rhs);

      packet _rhs;
      assert($cast(_rhs,rhs));
      
      enum32    = _rhs.enum32;
      int64     = _rhs.int64;
      int32     = _rhs.int32;
      int16     = _rhs.int16;
      int8      = _rhs.int8;
      int1      = _rhs.int1;
      uint64    = _rhs.uint64;
      uint32    = _rhs.uint32;
      uint16    = _rhs.uint16;
      uint8     = _rhs.uint8;
      uint1     = _rhs.uint1;
      time64    = _rhs.time64;
      str       = _rhs.str;
      arr       = _rhs.arr;
      q         = _rhs.q;
      da        = _rhs.da;
      aa        = _rhs.aa;
      real64    = _rhs.real64;
      scbit     = _rhs.scbit;
      sclogic   = _rhs.sclogic;
      scbv      = _rhs.scbv;
      sclv      = _rhs.sclv;
      scint     = _rhs.scint;
      scuint    = _rhs.scuint;
      scbigint  = _rhs.scbigint;
      scbiguint = _rhs.scbiguint;
      obj.copy(_rhs.obj);
    endfunction
    // (end inline source)

    
    //--------------------------------------------------------------------------
    // Function: do_compare
    //
    // Compares the values of fields with those of another object of the same
    // type, returning 1 if a match, 0 otherwise.
    //
    // Use the boolean equality operator (==) for most built-in types.  It is
    // more efficient than the provided methods in the ~comparer~ policy class.
    //
    // If you opt to employ direct comparison with the == operator as in this
    // example, you must still set the ~comparer.result~ to 0 if there were
    // no miscompares, or to if there was a miscompare.
    // 
    // Leverage short-circuit expression evaluation for higher efficiency.
    // Expression evaluation stops as soon as a result is certain. For
    // example, given an expression ~(a && b && c && d)~, if ~a~ or ~b~ are 0,
    // the whole expression evaluates to 0, so there is no point in examining
    // ~c~ or ~d~. The expression evaluates to 0 no matter what their values.
    // In this ~packet~ class, if the ~int64~ property doesn't match with the
    // right hand side, the remaining 25 equality comparisons that follow are
    // not evaluated, thus speeding up the comparison operation considerably.
    //
    // Comparison of scalars is more efficient than comparison of arrays and
    // other composite types  (e.g. sub-objects). So, put composite types at
    // the end of the expression. That way, these types will not be compared
    // unless all the previous expression terms evaluate to true.
    //
    // Subobjects are compared by calling ~subobj.compare(_rhs.subobj,comparer)~.
    //
    // If your transaction extends a base class with its own fields, call
    // ~super.do_compare(rhs,comparer)~ before comparing any fields of this
    // class. If ~super.do_compare~ returns 0, return immediately with 0.
    // Otherwise, continue with comparing this transaction's fields.

    // (begin inline source)
    function bit do_compare(ovm_object rhs, ovm_comparer comparer);

      packet _rhs;
      assert($cast(_rhs,rhs));
      comparer.result = 1;

      do_compare =
              enum32    == _rhs.enum32 &&
              int64     == _rhs.int64 && 
              int32     == _rhs.int32 && 
              int16     == _rhs.int16 && 
              int8      == _rhs.int8 && 
              int1      == _rhs.int1 && 
              uint64    == _rhs.uint64 && 
              uint32    == _rhs.uint32 && 
              uint16    == _rhs.uint16 && 
              uint8     == _rhs.uint8 && 
              uint1     == _rhs.uint1 && 
              time64    == _rhs.time64 && 
              str       == _rhs.str && 
              arr       == _rhs.arr && 
              q         == _rhs.q && 
              da        == _rhs.da && 
              scbit     == _rhs.scbit &&
              sclogic   == _rhs.sclogic &&
              scbv      == _rhs.scbv &&
              sclv      == _rhs.sclv &&
              scint     == _rhs.scint &&
              scuint    == _rhs.scuint &&
              scbigint  == _rhs.scbigint &&
              scbiguint == _rhs.scbiguint &&
              $realtobits(real64) == $realtobits(_rhs.real64)
              ;

      if (!do_compare)
        return 0;

      // temporary limitation: assoc arrays must be compared "item by item"
      if (aa.size() != _rhs.aa.size())
        return 0;
      foreach (aa[i])
        if (!(_rhs.aa.exists(i) && aa[i] == _rhs.aa[i]))
          return 0;

      // compare sub-object deeply
      if (obj == null) begin
        if (_rhs.obj != null)
          return 0;
      end
      else
        do_compare = obj.compare(_rhs.obj,comparer);
      
      comparer.result = 1-do_compare;

    endfunction
    // (end inline source)

    
    //--------------------------------------------------------------------------
    // Function: do_print
    //
    // Implements printing of all fields in this transaction using
    // the provided ~printer~ policy class.
    // 
    // To cut down on repetitive typing, small macros are used to "inline"
    // verbose calls to ~printer.print_generic~.
    //
    // If your transaction extends a base class with its own fields, call
    // ~super.do_print(printer)~ before printing any fields of this class.

    // (begin inline source)
    virtual function void do_print(ovm_printer printer);

      `define do_print_int(VAR,TYP,SZ) \
        printer.print_generic(`"VAR`", `"TYP`",SZ,$sformatf("'h%h",VAR));

      `define do_print_ele(VAR,TYP,SZ) \
        printer.print_generic($sformatf("[%0d]",i),\
              `"TYP`",SZ,$sformatf("'h%h",VAR));

      printer.print_generic("cmd","cmds_t",32,enum32.name());
      `do_print_int(int64,     longint,           64)
      `do_print_int(int32,     int,               32)
      `do_print_int(int16,     shortint,          16)
      `do_print_int(int8,      byte,               8)
      `do_print_int(int1,      bit,                1)
      `do_print_int(uint64,    longint unsigned,  64)
      `do_print_int(uint32,    int unsigned,      32)
      `do_print_int(uint16,    shortint unsigned, 16)
      `do_print_int(uint8,     byte unsigned,      8)
      `do_print_int(uint1,     bit unsigned,       1)
      `do_print_int(scbit,     bit,                1)
      `do_print_int(sclogic,   logic,              1)
      `do_print_int(scbv,      bit[16:0],         17)
      `do_print_int(sclv,      bit[34:0],         35)
      `do_print_int(scint,     bit[5:0],           6)
      `do_print_int(scuint,    bit[24:0],         25)
      `do_print_int(scbigint,  bit[36:0],         37)
      `do_print_int(scbiguint, bit[61:0],         62)
      printer.print_time   ("time64",time64);
      printer.print_field_real   ("real64",real64);
      printer.print_string ("str",  str);

      // print arrays one element at a time, between a header
      // and footer
      printer.print_array_header("arr",3,"int[3]");
      foreach (arr[i])
        `do_print_ele(arr[i],int,32)
      printer.print_array_footer(3);

      printer.print_array_header("q",q.size(),"byte[$]");
      foreach (q[i])
        `do_print_ele(q[i],byte,8)
      printer.print_array_footer(q.size());

      printer.print_array_header("da",da.size(),"shortint[]");
      foreach (da[i])
        `do_print_ele(da[i],shortint,16)
      printer.print_array_footer(da.size());

      printer.print_array_header("aa",aa.num(),"shortint[shortint]");
      foreach (aa[i])
        `do_print_ele(aa[i],shortint,16)
      printer.print_array_footer(aa.num());

      printer.print_object("obj",obj);

    endfunction

    // (end inline source)


    //--------------------------------------------------------------------------
    // Function: do_record
    //
    // Records all members of this transaction class for later viewing in the
    // GUI's wave window.
    //
    // This implementation uses the small ~uvm_record_field~ macro to record
    // most field types. Arrays are recorded iteratively using the same macro.
    //
    // To record a subobject, call the recorder's ~record_object~ method.
    //
    // The component's ~end_tr~ method indirectly calls this method, but only if
    // its ~recording_detail~ configuration parameter is set to something
    // above OVM_NONE.
    //
    // If your transaction extends a base class with its own fields, call
    // ~super.do_record(recorder)~ before recording any fields of this class.

    // (begin inline source)
    virtual function void do_record(ovm_recorder recorder);

      /* RECORD FUNCTIONALITY not needed for OVMC demo */
      /*
      int unsigned real_bits32;
      int unsigned n;
      `uvm_record_field("enum32",enum32)
      `uvm_record_field("int64",int64)
      `uvm_record_field("int32",int32)
      `uvm_record_field("int16",int16)
      `uvm_record_field("int8",int8)
      `uvm_record_field("int1",int1)
      `uvm_record_field("uint64",uint64)
      `uvm_record_field("uint32",uint32)
      `uvm_record_field("uint16",uint16)
      `uvm_record_field("uint8",uint8)
      `uvm_record_field("uint1",uint1)
      `uvm_record_time("time64",time64)
      `uvm_record_field("real64",real64)
      `uvm_record_string("str",str)
      foreach(arr[i])
        `uvm_record_field($sformatf("arr[%0d]",i),arr[i])
      foreach(q[i])
        `uvm_record_field($sformatf("q[%0d]",i),q[i])
      foreach(da[i])
        `uvm_record_field($sformatf("da[%0d]",i),da[i])
      foreach (aa[i]) begin
        string val = $sformatf("'h%h",aa[i]);
        `uvm_record_field($sformatf("aa[%0d]",i),val)
      end
      recorder.record_object("obj",obj);

      `uvm_record_field("scbit",scbit);
      `uvm_record_field("sclogic",sclogic);
      `uvm_record_field("scbv",scbv);
      `uvm_record_field("sclv",sclv);
      `uvm_record_field("scint",scint);
      `uvm_record_field("scuint",scuint);
      `uvm_record_field("scbigint",scbigint);
      `uvm_record_field("scbiguint",scbiguint);
      */
    endfunction
    // (end inline source)


    // Function: pre_randomize
    //
    // Randomizes the string variable, ~str~, and associative array, ~aa~.
    //
    // For strings, we randomize its length to be within a narrow range,
    // then randomize each character to be within the range of printable
    // characters.
    //
    // For the associative array, we randomize its size (number of entries)
    // to be within a narrow range, then randomize each key/value pair.

    // (begin inline source)
    function void pre_randomize();
      int aa_size;
      int str_size;

      // randomize assoc array
      void'(std::randomize(aa_size) with { aa_size inside {[4:11]}; });
      aa.delete();
      for (int i=0; i < aa_size; i++) begin
        shortint key;
        shortint val;
        key = $urandom;
        val = $urandom;
        aa[key] = val;
      end

      // randomize string
      void'(std::randomize(str_size) with { str_size inside {[4:11]}; });
      str = "";
      for (int i=0; i < str_size; i++) begin
        byte ele;
        void'(std::randomize(ele) with { ele inside {[32:126]}; });
	 $sformat(str, "%s%x", str, ele); // str = {str, string'(ele)};	 
      end

      // allocate sub-object 
      if (obj == null)
         obj = new("obj");

    endfunction
    // (end inline source)



    // Function: pre_randomize
    //
    // Provides rough randomization of real and shortreal fields
    // by casting randomized integrals to reals then taking their
    // quotients.

    // (begin inline source)
    function void post_randomize();
      // reals derive from quotient of two randomized ints
      real64 = real'(uint64) / real'(uint32);
    endfunction

endclass : packet 
// (end inline source)



parameter int NUM_PKTS=5;

//-----------------------------------------------------------------------------
// Class: producer
//
// A simple producer that generates packet transactions and sends them out its
// ~out~ blocking-put and ~ap~ analysis ports.
//-----------------------------------------------------------------------------

// (begin inline source)
class producer extends ovm_component;

   ovm_blocking_put_port #(packet) out; 
   ovm_analysis_port #(packet) ap; 

   `ovm_component_utils(producer)
   
   function new(string name, ovm_component parent=null);
      super.new(name,parent);
      out = new("out", this);
      ap = new("ap", this);
   endfunction : new

   virtual task run();

     packet pkt;

     ovm_test_done.raise_objection(this);

     for (int i = 1; i <= NUM_PKTS; i++) begin
       pkt = new;
       assert(pkt.randomize());

       `ovm_info("PRODUCER/SEND",
          $sformatf("Sending packet #%0d",i),OVM_MEDIUM)
          pkt.print();

       ap.write(pkt);
       out.put(pkt);

     end

       `ovm_info("PRODUCER/STOP", "Stopping the test", OVM_LOW);

     ovm_test_done.drop_objection(this);

   endtask

endclass
// (end inline source)



//-----------------------------------------------------------------------------
// Class: scoreboard
//
// A simple scoreboard that implements in-order comparison of ~expect~ and
// ~actual~ packets. The ~expect~ packets arrive via the ~expect_in~ analysis
// export. They are stored in an internal FIFO for later comparison with
// incoming ~actual~ packets, which arrive on its ~actual_in~ analysis imp.
// Strict comparison is performed as each ~actual~ arrives.
// 
//-----------------------------------------------------------------------------

// (begin inline source)
`ovm_analysis_imp_decl(_expect)
`ovm_analysis_imp_decl(_actual)

class scoreboard extends ovm_component;

   packet expect_q[$];
   int drain_time = 10;
   ovm_analysis_imp_expect  #(packet, scoreboard) expect_in;
   ovm_analysis_imp_actual  #(packet, scoreboard) actual_in;

   `ovm_component_utils(scoreboard)
   
   function new(string name, ovm_component parent=null);
      super.new(name,parent);
      actual_in   = new("actual_in", this);
      expect_in   = new("expect_in", this);
      enable_stop_interrupt = 1;
   endfunction : new

   virtual function void write_expect(packet t);
     expect_q.push_back(t);
   endfunction

   virtual function void write_actual(packet t);
     packet exp;

     `ovm_info("SCOREBD/RECV_ACTUAL",
            $sformatf("SV scoreboard recevied actual:\n  %p",t),OVM_HIGH);

     if (expect_q.size() == 0)
       `ovm_fatal("SCOREBD/NO_EXPECT",
         $psprintf("%m: No expect packet to compare with incoming actual."))

     exp = expect_q.pop_front();

     if (!exp.compare(t))
       `ovm_error("SCOREBD/MISCOMPARE",
         $psprintf("Actual does not match expect:\nexpect=%p\nactual=%p",
           exp,t))
   endfunction

   virtual task stop(string ph_name);
     if (expect_q.size()) begin
       `ovm_info("SCOREBD/EXPECT_Q_NOT_EMPTY",
         $psprintf("Expect Q still has %0d outstanding transactions. Waiting %0d time units",
                   expect_q.size(),drain_time),OVM_NONE)
       #drain_time;
       if (expect_q.size()) begin
         `ovm_error("SCOREBD/EXPECT_Q_NOT_EMPTY",
           $psprintf("Expect Q still has %0d outstanding transactions after waiting %0d time units",
                     expect_q.size(),drain_time))
           foreach(expect_q[i]) begin
             $display("  expect_q[",i,"]=",expect_q[i].convert2string());
           end
       end
     end
     else begin
       `ovm_info("SCOREBD/STOP_REQUEST","Expect Q is empty. OK to end the run phase", OVM_NONE)
     end
   endtask

endclass
// (end inline source)



//-----------------------------------------------------------------------------
// Module: sv_main
//
// Creates an instance of a <producer> and <scoreboard>, makes both native and
// cross-language connections using UVM Connect, then calls ~run_test~.
//-----------------------------------------------------------------------------

// (begin inline source)
module sv_main;

  import ovmc_pkg::*;

  producer prod;
  scoreboard sb;

  initial begin

    prod = new("prod");
    sb = new("sb");

    // expect path = normal TLM connection between producer and scoreboard
    prod.ap.connect(sb.expect_in);

    // actual path - SC-side consumer to SV-side scoreboard
    uvmc_tlm1 #(packet)::connect(prod.out,"foo");
    uvmc_tlm1 #(packet)::connect(sb.actual_in,"bar");

    run_test();

  end

endmodule
// (end inline source)

