// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: p_SSYNC3DO_S_PPP.v

module  p_SSYNC3DO_S_PPP (
	 clk
	,d
	,set_
	,q
	);

	//---------------------------------------
	//IO DECLARATIONS

input	 clk ;
input	 d ;
input	 set_ ;
output	 q ;

reg q,d1,d0;
always @(posedge clk or negedge set_)
begin
    if(~set_)
        {q,d1,d0} <= 3'b111;
    else
        {q,d1,d0} <= {d1,d0,d};
end

endmodule

