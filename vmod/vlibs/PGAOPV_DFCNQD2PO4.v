// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: PGAOPV_DFCNQD2PO4.v

module  PGAOPV_DFCNQD2PO4 (
	 D
	,CP
	,CDN
	,Q
	);

	//---------------------------------------
	//IO DECLARATIONS

input	 D ;
input	 CP ;
input	 CDN ;
output	 Q ;

reg Q;

always @(posedge CP or negedge CDN)
begin
    if(~CDN)
        Q <= 1'b0;
    else
        Q <= D;
end

endmodule
