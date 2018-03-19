
Title: OVM Version Requirements

The OVM library does not have an accessor method that allows
UVM Connect to check for compatible port/export/imp connections
across the language boundary. To enable this check, you can
replace the file $OVM_HOME/src/base/ovm_port_base.svh with the
one included in this directory. It simply defines an accessor
in the definition of the ovm_port_base #(IF) class:

|   function int m_get_if_mask();
|     return m_if_mask;
|   endfunction

The file is in every other respect identical to that found in
the OVM 2.1.2 release.


| //------------------------------------------------------------//
| //   Copyright 2012 Mentor Graphics Corporation               //
| //   All Rights Reserved Worldwid                             //
| //                                                            //
| //   Licensed under the Apache License, Version 2.0 (the      //
| //   "License"); you may not use this file except in          //
| //   compliance with the License.  You may obtain a copy of   //
| //   the License at                                           //
| //                                                            //
| //       http://www.apache.org/licenses/LICENSE-2.0           //
| //                                                            //
| //   Unless required by applicable law or agreed to in        //
| //   writing, software distributed under the License is       //
| //   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR   //
| //   CONDITIONS OF ANY KIND, either express or implied.  See  //
| //   the License for the specific language governing          //
| //   permissions and limitations under the License.           //
| //------------------------------------------------------------//
