`ifdef INC_eric_structs_SVH
`else
`define INC_eric_structs_SVH

`ifndef SV_STRUCT_DEFINED_aaa0
`define SV_STRUCT_DEFINED_aaa0
typedef struct packed {
  bit [6:0] addr;
  bit [2:0] size;
  bit [1:0] flush;
} aaa0_struct;
`endif

`ifndef SV_STRUCT_DEFINED_aaa1
`define SV_STRUCT_DEFINED_aaa1
typedef struct packed {
  bit [6:0] addr;
  bit [2:0] size;
  bit [2:0][4:0] data; // field data[3] 5
} aaa1_struct;
`endif

`ifndef SV_STRUCT_DEFINED_aaa2
`define SV_STRUCT_DEFINED_aaa2
typedef struct packed {
  bit [2:0] cmd;
} aaa2_struct;
`endif

`ifndef SV_STRUCT_DEFINED_eric
`define SV_STRUCT_DEFINED_eric
typedef enum {
  eric_PKT_aaa0,
  eric_PKT_aaa1,
  eric_PKT_aaa2,
  eric_PKT_INVALID
} eric_packets;
typedef struct packed {
  struct packed {
    bit [1:0] tag;
    union packed {
      struct packed { bit [12:0] pad; aaa0_struct pkt; } aaa0;
      struct packed { aaa1_struct pkt; } aaa1;
      struct packed { bit [21:0] pad; aaa2_struct pkt; } aaa2;
    } payload;
  } pd;
} eric_struct;
`endif

`endif // !defined(INC_eric_structs_SVH)
