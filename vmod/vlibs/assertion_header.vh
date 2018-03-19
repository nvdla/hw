// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: assertion_header.vh

`define NOEDGE 	    2'd0
`define POSEDGE     2'd1
`define NEGEDGE     2'd2
`define ANYEDGE     2'd3
`define ERROR       2'd0  
`define WARNING     2'd1  
`define INACTIVE    2'd2  
`define FV_ASSERT	1'b0
`define FV_ASSUME   1'b1 
`define FV_CURRENT  1'b0 
`define FV_NEXT     1'b1  
`define FV_HOLD_OR_CHANGE  2'd1 
`define FV_HOLD            2'd2 
`define FV_UNCHANGE        2'd2 
`define FV_CHANGE     	   2'd3 
`define FV_BEFORE          2'd0
`define FV_UNTIL           2'd1
`define FV_AT		       2'd2
`define FV_WHEN		       2'd2
`define FV_AFTER           2'd3
`define IGNORE		       2'd1 
`define RESTART            2'd2 
`define FV_INCLUDING       1'b0 
`define FV_EXCLUDING       1'b1
`define FV_FALSE		   1'b0
`define FV_TRUE		       1'b1
`define FV_NOT_IN_ORDER    1'b0
`define FV_IN_ORDER        1'b1
`define FV_OUT_OF_ORDER    1'b0
`define FV_NON_CONSECUTIVE 1'b0
`define FV_CONSECUTIVE     1'b1
`define FV_NON_OVERLAPPING 1'b0
`define FV_OVERLAPPING     1'b1
`define FV_INFINITY        100000
