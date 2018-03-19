`ifndef NVDLA_DBB_DEFINES__SVH
`define NVDLA_DBB_DEFINES__SVH

`define CAST_DBB_EXT(BASE,VAR,EXT) \
  $cast(VAR``_``EXT, BASE``VAR``.get_extension(dbb_``EXT``_ext#()::ID)); \
  if (VAR``_``EXT == null) begin \
      $display("Error: uvm_tlm_gp did not have ``EXT`` extension in %m"); \
  end \

`define CAST_DBB_EXT_PRE(BASE,PREFIX,VAR,EXT) \
  $cast(PREFIX``_``VAR``_``EXT, BASE``VAR``.get_extension(dbb_``EXT``_ext#()::ID)); \
  if (PREFIX``_``VAR``_``EXT == null) begin \
      $display("Error: uvm_tlm_gp did not have ``EXT`` extension in %m"); \
  end \

`endif
