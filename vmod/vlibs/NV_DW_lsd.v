// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_DW_lsd.v

module NV_DW_lsd (a, dec, enc);
  parameter a_width = 8;
  parameter b_width = a_width-1;
  localparam enc_width = ((a_width>16)?((a_width>64)?((a_width>128)?8:7):((a_width>32)?6:5)):((a_width>4)?((a_width>8)?4:3):((a_width>2)?2:1)));
  input     [a_width-1:0] a;
  output    [a_width-1:0] dec;
  output [enc_width-1:0] enc;

//get the encoded output: the number of sign bits.
function [enc_width-1:0] DWF_lsd_enc (input  [a_width-1:0] A);
  reg [enc_width-1:0] temp_enc;
  reg [enc_width-1:0] i;
  reg done;
  begin 
  done =0;
  temp_enc = a_width-1; 
  for (i=a_width-2; done==0; i=i-1) begin
    if (A[i+1] != A[i]) begin
      temp_enc = a_width - i -2;
      done =1;
    end
    else if(i==0) begin
        temp_enc = a_width-1;
        done =1;
    end
  end
  DWF_lsd_enc = temp_enc;
  end
endfunction


//get the sign bit position of input.
function [a_width-1:0] DWF_lsd (input  [a_width-1:0] A);
  reg [enc_width-1:0] temp_enc;
  reg    [a_width-1:0] temp_dec;
  reg [enc_width-1:0] temp;
  temp_enc = DWF_lsd_enc (A);
  temp_dec = {a_width{1'b0}};
  temp = b_width - temp_enc;
  temp_dec[temp] = 1'b1;
  DWF_lsd = temp_dec;
endfunction

assign enc = DWF_lsd_enc (a);
assign dec = DWF_lsd (a);
endmodule

