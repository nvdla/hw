// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: int_sum_block_tp1.v

module int_sum_block_tp1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,len5
  ,len7
  ,len9
  ,load_din_2d
  ,load_din_d
  ,reg2dp_normalz_len
  ,sq_pd_int8_0
  ,sq_pd_int8_1
  ,sq_pd_int8_2
  ,sq_pd_int8_3
  ,sq_pd_int8_4
  ,sq_pd_int8_5
  ,sq_pd_int8_6
  ,sq_pd_int8_7
  ,sq_pd_int8_8
  ,int8_sum
  );
/////////////////////////////////////////////
parameter pINT8_BW = 9;

/////////////////////////////////////////////
input         nvdla_core_clk;
input         nvdla_core_rstn;
input         len5;
input         len7;
input         len9;
input         load_din_2d;
input         load_din_d;
input   [1:0] reg2dp_normalz_len;
input  [pINT8_BW*2-2:0] sq_pd_int8_0;
input  [pINT8_BW*2-2:0] sq_pd_int8_1;
input  [pINT8_BW*2-2:0] sq_pd_int8_2;
input  [pINT8_BW*2-2:0] sq_pd_int8_3;
input  [pINT8_BW*2-2:0] sq_pd_int8_4;
input  [pINT8_BW*2-2:0] sq_pd_int8_5;
input  [pINT8_BW*2-2:0] sq_pd_int8_6;
input  [pINT8_BW*2-2:0] sq_pd_int8_7;
input  [pINT8_BW*2-2:0] sq_pd_int8_8;
output [pINT8_BW*2+2:0] int8_sum;
/////////////////////////////////////////////
reg    [pINT8_BW*2+2:0] int8_sum;
reg    [pINT8_BW*2:0] int8_sum3;
reg    [pINT8_BW*2+1:0] int8_sum5;
reg    [pINT8_BW*2+1:0] int8_sum7;
reg    [pINT8_BW*2+2:0] int8_sum9;
reg    [pINT8_BW*2-1:0] int8_sum_0_8;
reg    [pINT8_BW*2-1:0] int8_sum_1_7;
reg    [pINT8_BW*2-1:0] int8_sum_2_6;
reg    [pINT8_BW*2-1:0] int8_sum_3_5;
reg    [pINT8_BW*2-2:0] sq_pd_int8_4_d;
wire   [pINT8_BW*2-2:0] sq0;
wire   [pINT8_BW*2-2:0] sq1;
wire   [pINT8_BW*2-2:0] sq2;
wire   [pINT8_BW*2-2:0] sq3;
wire   [pINT8_BW*2-2:0] sq5;
wire   [pINT8_BW*2-2:0] sq6;
wire   [pINT8_BW*2-2:0] sq7;
wire   [pINT8_BW*2-2:0] sq8;
/////////////////////////////////////////////
assign sq3 = sq_pd_int8_3;
assign sq5 = sq_pd_int8_5;
assign sq2 = sq_pd_int8_2;
assign sq6 = sq_pd_int8_6;
assign sq1 = sq_pd_int8_1;
assign sq7 = sq_pd_int8_7;
assign sq0 = sq_pd_int8_0;
assign sq8 = sq_pd_int8_8;

//sum process
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int8_sum_3_5 <= {(pINT8_BW*2){1'b0}};
  end else if (load_din_d) begin
    int8_sum_3_5 <= (sq3 + sq5);
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int8_sum_2_6 <= {(pINT8_BW*2){1'b0}};
  end else if (load_din_d & (len5|len7|len9)) begin
    int8_sum_2_6 <= (sq2 + sq6);
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int8_sum_1_7 <= {(pINT8_BW*2){1'b0}};
  end else if (load_din_d & (len7|len9)) begin
    int8_sum_1_7 <= (sq1 + sq7);
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int8_sum_0_8 <= {(pINT8_BW*2){1'b0}};
  end else if (load_din_d & (len9)) begin
    int8_sum_0_8 <= (sq0 + sq8);
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    sq_pd_int8_4_d <= {(pINT8_BW*2-1){1'b0}};
  end else if (load_din_d) begin
    sq_pd_int8_4_d <= sq_pd_int8_4;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int8_sum3 <= {(pINT8_BW*2+1){1'b0}};
  end else if (load_din_2d ) begin
    int8_sum3 <= (int8_sum_3_5 + {1'b0,sq_pd_int8_4_d});
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int8_sum5 <= {(pINT8_BW*2+2){1'b0}};
  end else if (load_din_2d &(len5|len7|len9)) begin
    int8_sum5 <= ((int8_sum_3_5 + {1'b0,sq_pd_int8_4_d}) + {1'b0,int8_sum_2_6});
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int8_sum7 <= {(pINT8_BW*2+2){1'b0}};
  end else if (load_din_2d &(len7|len9)) begin
    int8_sum7 <= ((int8_sum_3_5 + {1'b0,sq_pd_int8_4_d}) + (int8_sum_2_6 + int8_sum_1_7));
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    int8_sum9 <= {(pINT8_BW*2+3){1'b0}};
  end else if (load_din_2d &(len9)) begin
    int8_sum9 <= (((int8_sum_3_5 + {1'b0,sq_pd_int8_4_d}) + (int8_sum_2_6 + int8_sum_1_7)) + {2'd0,int8_sum_0_8});
  end
end

always @(*) begin
    case(reg2dp_normalz_len[1:0]) 
    2'h0 : begin
        int8_sum = {2'd0,int8_sum3};
    end
    2'h1 : begin
        int8_sum = {1'd0,int8_sum5};
    end
    2'h2 : begin
        int8_sum = {1'b0,int8_sum7};
    end
    default: begin
        int8_sum = int8_sum9;
    end
    endcase
end

endmodule // int_sum_block


