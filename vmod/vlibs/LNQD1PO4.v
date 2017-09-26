// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: LNQD1PO4.v

module  LNQD1PO4 (
	 D
	,EN
	,Q
	);

input	 D ;
input	 EN ;
output	 Q ;


reg Q;
always @(negedge EN)
    Q <= D;

endmodule
