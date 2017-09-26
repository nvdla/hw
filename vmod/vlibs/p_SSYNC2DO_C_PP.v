// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: p_SSYNC2DO_C_PP.v

module  p_SSYNC2DO_C_PP (
	 clk
	,d
	,clr_
	,q
	);

	//---------------------------------------
	//IO DECLARATIONS

input	 clk ;
input	 d ;
input	 clr_ ;
output	 q ;

reg q,d0;

always @(posedge clk or negedge clr_)
begin
    if(~clr_)
        {q,d0} <= 2'd0;
    else
        {q,d0} <= {d0,d};
end


endmodule
