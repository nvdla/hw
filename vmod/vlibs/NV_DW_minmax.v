// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_DW_minmax.v

module NV_DW_minmax (a ,tc ,min_max ,value ,index);
  parameter width = 8;
  parameter num_inputs = 2;
  localparam index_width = ((num_inputs>8)? ((num_inputs> 32)? 6 : ((num_inputs>16)? 5 : 4)) : ((num_inputs>4)? 3 : ((num_inputs>2)? 2 : 1)));
  input [num_inputs*width-1 : 0] a;
  input tc; //dangle, only support unsigned.
  input min_max;
  output [width-1 : 0] value;
  output [index_width-1 : 0] index;
  reg [width-1 : 0] value;
  reg [index_width-1 : 0] index;
  wire tc_NC;
  // synoff nets

  // monitor nets

  // debug nets

  // tie high nets

  // tie low nets

  // no connect nets

  // not all bits used nets

  // todo nets

       
  assign tc_NC = tc;

  function [width-1 : 0] max_unsigned_value;
    input [num_inputs*width-1 : 0] a;
    reg [width-1 : 0] a_v;
    reg [width-1 : 0] value_v;
    reg [index_width : 0] k;
    begin
	value_v = {width{1'b0}};
	for (k = 0; k < num_inputs; k = k+1) begin 
	    a_v = a[width-1 : 0];
	    a = a >> width;
	    if (a_v >= value_v) begin 
	        value_v = a_v;
	    end 
	end
	max_unsigned_value = value_v;
    end
  endfunction

    function  [index_width-1 : 0] max_unsigned_index;
        input [num_inputs*width-1 : 0] a;
        reg [width-1 : 0] a_v;
        reg [index_width-1 : 0] index_v;
        reg [width-1 : 0] value_v;
        reg [index_width : 0] k;
        begin
	    value_v = {width{1'b0}};
	    index_v = {index_width{1'b0}};
	    for (k = 0; k < num_inputs; k = k+1) begin 
	        a_v = a[width-1 : 0];
	        a = a >> width;
	        if (a_v >= value_v) begin 
	            value_v = a_v;
	            index_v = k[index_width-1 : 0];
	        end 
	    end
	    max_unsigned_index = index_v;
        end
    endfunction

  function [width-1 : 0] min_unsigned_value;
    input [num_inputs*width-1 : 0] a;
    reg [width-1 : 0] a_v;
    reg [width-1 : 0] value_v;
    reg [index_width : 0] k;
	begin
    value_v = {width{1'b1}};
	for (k = 0; k < num_inputs; k = k+1) begin 
	    a_v = a[width-1 : 0];
	    a = a >> width;
	    if (a_v < value_v) begin 
	        value_v = a_v;
	    end 
	end
	min_unsigned_value = value_v;
    end
  endfunction

  function [index_width-1 : 0] min_unsigned_index;
    input [num_inputs*width-1 : 0] a;
    reg [width-1 : 0] a_v;
    reg [width-1 : 0] value_v;
    reg [index_width-1 : 0] index_v;
    reg [index_width : 0] k;
	begin
    value_v = {width{1'b1}};
	index_v = {index_width{1'b0}};
	for (k = 0; k < num_inputs; k = k+1) begin 
	    a_v = a[width-1 : 0];
	    a = a >> width;
	    if (a_v < value_v) begin 
	        value_v = a_v;
	        index_v = k[index_width-1 : 0];
	    end 
	end
	min_unsigned_index = index_v;
    end
  endfunction
  
  always @(a or min_max) begin
        if (min_max == 1'b0)  begin
	        value = min_unsigned_value (a);
	        index = min_unsigned_index (a);
        end
	    else begin 
	        value = max_unsigned_value (a);
	        index = max_unsigned_index (a);
        end
  end

endmodule

