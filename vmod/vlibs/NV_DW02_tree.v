// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_DW02_tree.v

module NV_DW02_tree( INPUT, OUT0, OUT1 );
parameter num_inputs = 8;
parameter input_width = 8;
input [num_inputs*input_width-1 : 0]	INPUT;
output [input_width-1:0]		OUT0, OUT1;

reg [input_width-1 : 0] input_array [num_inputs-1 : 0];
reg [input_width-1 : 0] temp_array [num_inputs-1 : 0];
reg [input_width-1 : 0] input_slice;
integer num_in;
integer i, j;

always @ (INPUT) begin  
    for (i=0 ; i < num_inputs ; i=i+1) begin
        for (j=0 ; j < input_width ; j=j+1) begin
            input_slice[j] = INPUT[i*input_width+j];
        end 
        input_array[i] = input_slice;
    end 

    for (num_in = num_inputs; num_in > 2 ; num_in = num_in - (num_in/3)) begin
        for (i=0 ; i < (num_in/3) ; i = i+1) begin
            temp_array[i*2] = input_array[i*3] ^ input_array[i*3+1] ^ input_array[i*3+2]; //get partial sum
            temp_array[i*2+1] = ((input_array[i*3] & input_array[i*3+1]) |(input_array[i*3+1] & input_array[i*3+2]) | (input_array[i*3] & input_array[i*3+2])) << 1; //get shift carry
        end
        if ((num_in % 3) > 0) begin 
            for (i=0 ; i < (num_in % 3) ; i = i + 1)
                temp_array[2 * (num_in/3) + i] = input_array[3 * (num_in/3) + i];
        end 
        for (i=0 ; i < num_in ; i = i + 1)
             input_array[i] = temp_array[i];  //update input array.
    end
end

assign OUT0 = input_array[0];
assign OUT1 = input_array[1];
endmodule

