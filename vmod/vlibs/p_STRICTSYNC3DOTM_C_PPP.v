// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: p_STRICTSYNC3DOTM_C_PPP.v

module  p_STRICTSYNC3DOTM_C_PPP (
	 SRC_D_NEXT
	,SRC_CLK
	,SRC_CLRN
	,DST_CLK
	,DST_CLRN
	,SRC_D
	,DST_Q
	,ATPG_CTL
	,TEST_MODE
	);

input	 SRC_D_NEXT ;
input	 SRC_CLK ;
input	 SRC_CLRN ;
input	 DST_CLK ;
input	 DST_CLRN ;
output	 SRC_D ;
output	 DST_Q ;
input	 ATPG_CTL ;
input	 TEST_MODE ;

wire src_sel,dst_sel;
reg  src_d_f;
//reg dst_d2,dst_d1,dst_d0;

assign src_sel = SRC_D_NEXT;
always @(posedge SRC_CLK or negedge SRC_CLRN)
begin
    if(~SRC_CLRN)
        src_d_f <= 1'b0;
    else
        src_d_f <= src_sel;
end
assign SRC_D = src_d_f;

assign dst_sel = src_d_f;
//always @(posedge DST_CLK or negedge DST_CLRN)
//begin
//    if(~DST_CLRN)
//        {dst_d2,dst_d1,dst_d0} <= 3'd0;
//    else
//        {dst_d2,dst_d1,dst_d0} <= {dst_d1,dst_d0,dst_sel};
//end
//assign DST_Q = dst_d2;
p_SSYNC3DO_C_PPP sync3d(.clk (DST_CLK),.d (dst_sel), .clr_ (DST_CLRN)	,.q(DST_Q));



endmodule

