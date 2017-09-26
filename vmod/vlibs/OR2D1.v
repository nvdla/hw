// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: OR2D1.v

module  OR2D1 (
	 A1
	,A2
	,Z
	);

input	 A1 ;
input	 A2 ;
output	 Z ;

assign Z = A1 | A2;

endmodule

