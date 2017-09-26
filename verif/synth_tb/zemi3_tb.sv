`include "syn_tb_defines.vh"

module zemi3_tb (
  input clk,
  output reg resetn,
  input dollar_finish,
  input [7:0] cs,
  input [`MSEQ_CMD_SIZE-1:0] curr_cmd
);

  parameter MSEQ_MEM_LD = 8'h20;
  parameter MSEQ_MEM_DMP = 8'h28;

  // Because there are no outputs in the imported functions, Zemi3 compiler will make these functions streaming by default
  // Explicitely disable streaming

  (* zemi3_stream = 0 *)
  import "DPI-C" function void z_initialize ();

  (* zemi3_stream = 0 *)
  import "DPI-C" function void z_readmemh ( input bit  [255:0] file_name,
                                            input bit [1023:0] dut_mem_path,
                                            input bit   [`AXI_ADDR_WIDTH-1:0] start_addr,
                                            input bit   [`AXI_ADDR_WIDTH-1:0] end_addr        );

  (* zemi3_stream = 0 *)
  import "DPI-C" function void z_writememh( input bit  [255:0] file_name,
                                            input bit [1023:0] dut_mem_path,
                                            input bit   [`AXI_ADDR_WIDTH-1:0] start_addr,
                                            input bit   [`AXI_ADDR_WIDTH-1:0] end_addr        );

  (* zemi3_stream = 0 *)
  import "DPI-C" function void z_finish ();

  initial begin
    z_initialize();
  end

  initial begin
    repeat (1000) @(posedge clk);
    resetn = 1;
  end

  always @(posedge clk) begin
    if (dollar_finish == 1'b1) begin
      z_finish();
    end
  end

  always @(posedge clk) begin
    case (cs)
      MSEQ_MEM_LD : begin
        z_readmemh(curr_cmd[`MSEQ_FILENAME_BITS], "top.slave_mem_wrap.syn_mem.memory", curr_cmd[`MSEQ_MEM_ADDR_BITS]/(`ZRM_CHANGE_BYTES) - (`DLA_ADDR_START >> `ZRM_LOG2_MEM), (curr_cmd[`MSEQ_MEM_ADDR_BITS] + curr_cmd[`MSEQ_MEM_SIZE_BITS])/(`ZRM_CHANGE_BYTES) - (`DLA_ADDR_START >> `ZRM_LOG2_MEM) - 1);
      end
      MSEQ_MEM_DMP : begin
        z_writememh(curr_cmd[`MSEQ_FILENAME_BITS], "top.slave_mem_wrap.syn_mem.memory", curr_cmd[`MSEQ_MEM_ADDR_BITS]/(`ZRM_CHANGE_BYTES) - (`DLA_ADDR_START >> `ZRM_LOG2_MEM), (curr_cmd[`MSEQ_MEM_ADDR_BITS] + curr_cmd[`MSEQ_MEM_SIZE_BITS])/(`ZRM_CHANGE_BYTES) - (`DLA_ADDR_START >> `ZRM_LOG2_MEM) - 1);
      end
    endcase
  end

endmodule
