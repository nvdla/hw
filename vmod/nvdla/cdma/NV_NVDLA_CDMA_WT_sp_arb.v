// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CDMA_WT_sp_arb.v

`include "simulate_x_tick.vh"
module NV_NVDLA_CDMA_WT_sp_arb (
   req0
  ,req1
  ,gnt_busy
  ,gnt0
  ,gnt1
  );

//Declaring ports

input req0;
input req1;
input gnt_busy;
output gnt0;
output gnt1;


//Declaring registers and wires

reg  [1:0] gnt;
reg  [1:0] gnt_pre;
wire [1:0] req;


assign  req = {
 req1
,req0
};

assign {
 gnt1
,gnt0
} = gnt;


always @(
  gnt_busy
  or gnt_pre
  ) begin
    gnt = {2{!gnt_busy}} & gnt_pre;
end

// verilint 69 off - Case statement without default clause, but all the cases are covered
// verilint 71 off - Case statement without default clause
// verilint 264 off - Not all possible cases covered
always @(
  req
  ) begin
    gnt_pre = 2'd0;
    casez (req)
        2'b?1: begin
            gnt_pre[0] = 1'b1;
        end
        2'b10: begin
            gnt_pre[1] = 1'b1;
        end
        2'b00: begin
            gnt_pre = 2'd0;
        end
            //VCS coverage off
            default : begin 
                        gnt_pre[1:0] = {2{`x_or_0}};
                      end  
            //VCS coverage on
    endcase
end

// verilint 69 on - Case statement without default clause, but all the cases are covered
// verilint 71 on - Case statement without default clause
// verilint 264 on - Not all possible cases covered

endmodule // NV_NVDLA_CDMA_WT_sp_arb



