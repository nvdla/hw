`ifdef INC_farm_structs_SVH
`else
`define INC_farm_structs_SVH

`ifndef SV_STRUCT_DEFINED_farm
`define SV_STRUCT_DEFINED_farm
typedef struct packed {
  bit [6:0] addr;
  bit [2:0] size;
  bit [1:0] flush;
  bit [1:0][2:0] reset; // field reset[2] 3
} farm_struct;
`endif

`endif // !defined(INC_farm_structs_SVH)
