// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CMAC_CORE_MAC_nan.v

module NV_NVDLA_CMAC_CORE_MAC_nan (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,cfg_is_fp16
  ,cfg_reg_en
  ,dat_actv_data
  ,dat_actv_nan
  ,wt_actv_data
  ,wt_actv_nan
  ,out_nan_mts
  ,out_nan_pvld
  );

input           nvdla_core_clk;
input           nvdla_core_rstn;
input           cfg_is_fp16;
input           cfg_reg_en;
input  [1023:0] dat_actv_data;
input    [63:0] dat_actv_nan;
input  [1023:0] wt_actv_data;
input    [63:0] wt_actv_nan;
output   [10:0] out_nan_mts;
output          out_nan_pvld;
reg      [32:0] cfg_is_fp16_d1;
reg    [2047:0] cur_data;
reg     [127:0] nan_flag_l0;
reg      [63:0] nan_flag_l1;
reg      [31:0] nan_flag_l2;
reg      [15:0] nan_flag_l3;
reg       [7:0] nan_flag_l4;
reg       [3:0] nan_flag_l5;
reg       [1:0] nan_flag_l6;
reg       [0:0] nan_flag_l7;
reg      [10:0] nan_mts_l0n0;
reg      [10:0] nan_mts_l0n1;
reg      [10:0] nan_mts_l0n10;
reg      [10:0] nan_mts_l0n100;
reg      [10:0] nan_mts_l0n101;
reg      [10:0] nan_mts_l0n102;
reg      [10:0] nan_mts_l0n103;
reg      [10:0] nan_mts_l0n104;
reg      [10:0] nan_mts_l0n105;
reg      [10:0] nan_mts_l0n106;
reg      [10:0] nan_mts_l0n107;
reg      [10:0] nan_mts_l0n108;
reg      [10:0] nan_mts_l0n109;
reg      [10:0] nan_mts_l0n11;
reg      [10:0] nan_mts_l0n110;
reg      [10:0] nan_mts_l0n111;
reg      [10:0] nan_mts_l0n112;
reg      [10:0] nan_mts_l0n113;
reg      [10:0] nan_mts_l0n114;
reg      [10:0] nan_mts_l0n115;
reg      [10:0] nan_mts_l0n116;
reg      [10:0] nan_mts_l0n117;
reg      [10:0] nan_mts_l0n118;
reg      [10:0] nan_mts_l0n119;
reg      [10:0] nan_mts_l0n12;
reg      [10:0] nan_mts_l0n120;
reg      [10:0] nan_mts_l0n121;
reg      [10:0] nan_mts_l0n122;
reg      [10:0] nan_mts_l0n123;
reg      [10:0] nan_mts_l0n124;
reg      [10:0] nan_mts_l0n125;
reg      [10:0] nan_mts_l0n126;
reg      [10:0] nan_mts_l0n127;
reg      [10:0] nan_mts_l0n13;
reg      [10:0] nan_mts_l0n14;
reg      [10:0] nan_mts_l0n15;
reg      [10:0] nan_mts_l0n16;
reg      [10:0] nan_mts_l0n17;
reg      [10:0] nan_mts_l0n18;
reg      [10:0] nan_mts_l0n19;
reg      [10:0] nan_mts_l0n2;
reg      [10:0] nan_mts_l0n20;
reg      [10:0] nan_mts_l0n21;
reg      [10:0] nan_mts_l0n22;
reg      [10:0] nan_mts_l0n23;
reg      [10:0] nan_mts_l0n24;
reg      [10:0] nan_mts_l0n25;
reg      [10:0] nan_mts_l0n26;
reg      [10:0] nan_mts_l0n27;
reg      [10:0] nan_mts_l0n28;
reg      [10:0] nan_mts_l0n29;
reg      [10:0] nan_mts_l0n3;
reg      [10:0] nan_mts_l0n30;
reg      [10:0] nan_mts_l0n31;
reg      [10:0] nan_mts_l0n32;
reg      [10:0] nan_mts_l0n33;
reg      [10:0] nan_mts_l0n34;
reg      [10:0] nan_mts_l0n35;
reg      [10:0] nan_mts_l0n36;
reg      [10:0] nan_mts_l0n37;
reg      [10:0] nan_mts_l0n38;
reg      [10:0] nan_mts_l0n39;
reg      [10:0] nan_mts_l0n4;
reg      [10:0] nan_mts_l0n40;
reg      [10:0] nan_mts_l0n41;
reg      [10:0] nan_mts_l0n42;
reg      [10:0] nan_mts_l0n43;
reg      [10:0] nan_mts_l0n44;
reg      [10:0] nan_mts_l0n45;
reg      [10:0] nan_mts_l0n46;
reg      [10:0] nan_mts_l0n47;
reg      [10:0] nan_mts_l0n48;
reg      [10:0] nan_mts_l0n49;
reg      [10:0] nan_mts_l0n5;
reg      [10:0] nan_mts_l0n50;
reg      [10:0] nan_mts_l0n51;
reg      [10:0] nan_mts_l0n52;
reg      [10:0] nan_mts_l0n53;
reg      [10:0] nan_mts_l0n54;
reg      [10:0] nan_mts_l0n55;
reg      [10:0] nan_mts_l0n56;
reg      [10:0] nan_mts_l0n57;
reg      [10:0] nan_mts_l0n58;
reg      [10:0] nan_mts_l0n59;
reg      [10:0] nan_mts_l0n6;
reg      [10:0] nan_mts_l0n60;
reg      [10:0] nan_mts_l0n61;
reg      [10:0] nan_mts_l0n62;
reg      [10:0] nan_mts_l0n63;
reg      [10:0] nan_mts_l0n64;
reg      [10:0] nan_mts_l0n65;
reg      [10:0] nan_mts_l0n66;
reg      [10:0] nan_mts_l0n67;
reg      [10:0] nan_mts_l0n68;
reg      [10:0] nan_mts_l0n69;
reg      [10:0] nan_mts_l0n7;
reg      [10:0] nan_mts_l0n70;
reg      [10:0] nan_mts_l0n71;
reg      [10:0] nan_mts_l0n72;
reg      [10:0] nan_mts_l0n73;
reg      [10:0] nan_mts_l0n74;
reg      [10:0] nan_mts_l0n75;
reg      [10:0] nan_mts_l0n76;
reg      [10:0] nan_mts_l0n77;
reg      [10:0] nan_mts_l0n78;
reg      [10:0] nan_mts_l0n79;
reg      [10:0] nan_mts_l0n8;
reg      [10:0] nan_mts_l0n80;
reg      [10:0] nan_mts_l0n81;
reg      [10:0] nan_mts_l0n82;
reg      [10:0] nan_mts_l0n83;
reg      [10:0] nan_mts_l0n84;
reg      [10:0] nan_mts_l0n85;
reg      [10:0] nan_mts_l0n86;
reg      [10:0] nan_mts_l0n87;
reg      [10:0] nan_mts_l0n88;
reg      [10:0] nan_mts_l0n89;
reg      [10:0] nan_mts_l0n9;
reg      [10:0] nan_mts_l0n90;
reg      [10:0] nan_mts_l0n91;
reg      [10:0] nan_mts_l0n92;
reg      [10:0] nan_mts_l0n93;
reg      [10:0] nan_mts_l0n94;
reg      [10:0] nan_mts_l0n95;
reg      [10:0] nan_mts_l0n96;
reg      [10:0] nan_mts_l0n97;
reg      [10:0] nan_mts_l0n98;
reg      [10:0] nan_mts_l0n99;
reg      [10:0] nan_mts_l1n0;
reg      [10:0] nan_mts_l1n1;
reg      [10:0] nan_mts_l1n10;
reg      [10:0] nan_mts_l1n11;
reg      [10:0] nan_mts_l1n12;
reg      [10:0] nan_mts_l1n13;
reg      [10:0] nan_mts_l1n14;
reg      [10:0] nan_mts_l1n15;
reg      [10:0] nan_mts_l1n16;
reg      [10:0] nan_mts_l1n17;
reg      [10:0] nan_mts_l1n18;
reg      [10:0] nan_mts_l1n19;
reg      [10:0] nan_mts_l1n2;
reg      [10:0] nan_mts_l1n20;
reg      [10:0] nan_mts_l1n21;
reg      [10:0] nan_mts_l1n22;
reg      [10:0] nan_mts_l1n23;
reg      [10:0] nan_mts_l1n24;
reg      [10:0] nan_mts_l1n25;
reg      [10:0] nan_mts_l1n26;
reg      [10:0] nan_mts_l1n27;
reg      [10:0] nan_mts_l1n28;
reg      [10:0] nan_mts_l1n29;
reg      [10:0] nan_mts_l1n3;
reg      [10:0] nan_mts_l1n30;
reg      [10:0] nan_mts_l1n31;
reg      [10:0] nan_mts_l1n32;
reg      [10:0] nan_mts_l1n33;
reg      [10:0] nan_mts_l1n34;
reg      [10:0] nan_mts_l1n35;
reg      [10:0] nan_mts_l1n36;
reg      [10:0] nan_mts_l1n37;
reg      [10:0] nan_mts_l1n38;
reg      [10:0] nan_mts_l1n39;
reg      [10:0] nan_mts_l1n4;
reg      [10:0] nan_mts_l1n40;
reg      [10:0] nan_mts_l1n41;
reg      [10:0] nan_mts_l1n42;
reg      [10:0] nan_mts_l1n43;
reg      [10:0] nan_mts_l1n44;
reg      [10:0] nan_mts_l1n45;
reg      [10:0] nan_mts_l1n46;
reg      [10:0] nan_mts_l1n47;
reg      [10:0] nan_mts_l1n48;
reg      [10:0] nan_mts_l1n49;
reg      [10:0] nan_mts_l1n5;
reg      [10:0] nan_mts_l1n50;
reg      [10:0] nan_mts_l1n51;
reg      [10:0] nan_mts_l1n52;
reg      [10:0] nan_mts_l1n53;
reg      [10:0] nan_mts_l1n54;
reg      [10:0] nan_mts_l1n55;
reg      [10:0] nan_mts_l1n56;
reg      [10:0] nan_mts_l1n57;
reg      [10:0] nan_mts_l1n58;
reg      [10:0] nan_mts_l1n59;
reg      [10:0] nan_mts_l1n6;
reg      [10:0] nan_mts_l1n60;
reg      [10:0] nan_mts_l1n61;
reg      [10:0] nan_mts_l1n62;
reg      [10:0] nan_mts_l1n63;
reg      [10:0] nan_mts_l1n7;
reg      [10:0] nan_mts_l1n8;
reg      [10:0] nan_mts_l1n9;
reg      [10:0] nan_mts_l2n0;
reg      [10:0] nan_mts_l2n1;
reg      [10:0] nan_mts_l2n10;
reg      [10:0] nan_mts_l2n11;
reg      [10:0] nan_mts_l2n12;
reg      [10:0] nan_mts_l2n13;
reg      [10:0] nan_mts_l2n14;
reg      [10:0] nan_mts_l2n15;
reg      [10:0] nan_mts_l2n16;
reg      [10:0] nan_mts_l2n17;
reg      [10:0] nan_mts_l2n18;
reg      [10:0] nan_mts_l2n19;
reg      [10:0] nan_mts_l2n2;
reg      [10:0] nan_mts_l2n20;
reg      [10:0] nan_mts_l2n21;
reg      [10:0] nan_mts_l2n22;
reg      [10:0] nan_mts_l2n23;
reg      [10:0] nan_mts_l2n24;
reg      [10:0] nan_mts_l2n25;
reg      [10:0] nan_mts_l2n26;
reg      [10:0] nan_mts_l2n27;
reg      [10:0] nan_mts_l2n28;
reg      [10:0] nan_mts_l2n29;
reg      [10:0] nan_mts_l2n3;
reg      [10:0] nan_mts_l2n30;
reg      [10:0] nan_mts_l2n31;
reg      [10:0] nan_mts_l2n4;
reg      [10:0] nan_mts_l2n5;
reg      [10:0] nan_mts_l2n6;
reg      [10:0] nan_mts_l2n7;
reg      [10:0] nan_mts_l2n8;
reg      [10:0] nan_mts_l2n9;
reg      [10:0] nan_mts_l3n0;
reg      [10:0] nan_mts_l3n1;
reg      [10:0] nan_mts_l3n10;
reg      [10:0] nan_mts_l3n11;
reg      [10:0] nan_mts_l3n12;
reg      [10:0] nan_mts_l3n13;
reg      [10:0] nan_mts_l3n14;
reg      [10:0] nan_mts_l3n15;
reg      [10:0] nan_mts_l3n2;
reg      [10:0] nan_mts_l3n3;
reg      [10:0] nan_mts_l3n4;
reg      [10:0] nan_mts_l3n5;
reg      [10:0] nan_mts_l3n6;
reg      [10:0] nan_mts_l3n7;
reg      [10:0] nan_mts_l3n8;
reg      [10:0] nan_mts_l3n9;
reg      [10:0] nan_mts_l4n0;
reg      [10:0] nan_mts_l4n1;
reg      [10:0] nan_mts_l4n2;
reg      [10:0] nan_mts_l4n3;
reg      [10:0] nan_mts_l4n4;
reg      [10:0] nan_mts_l4n5;
reg      [10:0] nan_mts_l4n6;
reg      [10:0] nan_mts_l4n7;
reg      [10:0] nan_mts_l5n0;
reg      [10:0] nan_mts_l5n1;
reg      [10:0] nan_mts_l5n2;
reg      [10:0] nan_mts_l5n3;
reg      [10:0] nan_mts_l6n0;
reg      [10:0] nan_mts_l6n1;
reg      [10:0] nan_mts_l7n0;
reg             out_nan_pvld;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    

//==========================================================
// Config logic
//==========================================================

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfg_is_fp16_d1 <= {33{1'b0}};
  end else begin
  if ((cfg_reg_en) == 1'b1) begin
    cfg_is_fp16_d1 <= {33{cfg_is_fp16}};
  // VCS coverage off
  end else if ((cfg_reg_en) == 1'b0) begin
  end else begin
    cfg_is_fp16_d1 <= 'bx;  // spyglass disable STARC-2.10.1.6 W443 NoWidthInBasedNum-ML -- (Constant containing x or z used, Based number `bx contains an X, Width specification missing for based number)
  // VCS coverage on
  end
  end
end
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, 1'd1,  (^(cfg_reg_en))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

//==========================================================
// Search nan matissa
//==========================================================
always @(
  cfg_is_fp16_d1
  or dat_actv_nan
  or wt_actv_nan
  ) begin
    nan_flag_l0 = {4{cfg_is_fp16_d1[31:0]}} & {dat_actv_nan, wt_actv_nan};
end

always @(
  dat_actv_data
  or wt_actv_data
  ) begin
    cur_data = {dat_actv_data, wt_actv_data};
end

always @(
  cur_data
  ) begin
    nan_mts_l0n0 = {cur_data[15], cur_data[12:3]};
    nan_mts_l0n1 = {cur_data[31], cur_data[28:19]};
    nan_mts_l0n2 = {cur_data[47], cur_data[44:35]};
    nan_mts_l0n3 = {cur_data[63], cur_data[60:51]};
    nan_mts_l0n4 = {cur_data[79], cur_data[76:67]};
    nan_mts_l0n5 = {cur_data[95], cur_data[92:83]};
    nan_mts_l0n6 = {cur_data[111], cur_data[108:99]};
    nan_mts_l0n7 = {cur_data[127], cur_data[124:115]};
    nan_mts_l0n8 = {cur_data[143], cur_data[140:131]};
    nan_mts_l0n9 = {cur_data[159], cur_data[156:147]};
    nan_mts_l0n10 = {cur_data[175], cur_data[172:163]};
    nan_mts_l0n11 = {cur_data[191], cur_data[188:179]};
    nan_mts_l0n12 = {cur_data[207], cur_data[204:195]};
    nan_mts_l0n13 = {cur_data[223], cur_data[220:211]};
    nan_mts_l0n14 = {cur_data[239], cur_data[236:227]};
    nan_mts_l0n15 = {cur_data[255], cur_data[252:243]};
    nan_mts_l0n16 = {cur_data[271], cur_data[268:259]};
    nan_mts_l0n17 = {cur_data[287], cur_data[284:275]};
    nan_mts_l0n18 = {cur_data[303], cur_data[300:291]};
    nan_mts_l0n19 = {cur_data[319], cur_data[316:307]};
    nan_mts_l0n20 = {cur_data[335], cur_data[332:323]};
    nan_mts_l0n21 = {cur_data[351], cur_data[348:339]};
    nan_mts_l0n22 = {cur_data[367], cur_data[364:355]};
    nan_mts_l0n23 = {cur_data[383], cur_data[380:371]};
    nan_mts_l0n24 = {cur_data[399], cur_data[396:387]};
    nan_mts_l0n25 = {cur_data[415], cur_data[412:403]};
    nan_mts_l0n26 = {cur_data[431], cur_data[428:419]};
    nan_mts_l0n27 = {cur_data[447], cur_data[444:435]};
    nan_mts_l0n28 = {cur_data[463], cur_data[460:451]};
    nan_mts_l0n29 = {cur_data[479], cur_data[476:467]};
    nan_mts_l0n30 = {cur_data[495], cur_data[492:483]};
    nan_mts_l0n31 = {cur_data[511], cur_data[508:499]};
    nan_mts_l0n32 = {cur_data[527], cur_data[524:515]};
    nan_mts_l0n33 = {cur_data[543], cur_data[540:531]};
    nan_mts_l0n34 = {cur_data[559], cur_data[556:547]};
    nan_mts_l0n35 = {cur_data[575], cur_data[572:563]};
    nan_mts_l0n36 = {cur_data[591], cur_data[588:579]};
    nan_mts_l0n37 = {cur_data[607], cur_data[604:595]};
    nan_mts_l0n38 = {cur_data[623], cur_data[620:611]};
    nan_mts_l0n39 = {cur_data[639], cur_data[636:627]};
    nan_mts_l0n40 = {cur_data[655], cur_data[652:643]};
    nan_mts_l0n41 = {cur_data[671], cur_data[668:659]};
    nan_mts_l0n42 = {cur_data[687], cur_data[684:675]};
    nan_mts_l0n43 = {cur_data[703], cur_data[700:691]};
    nan_mts_l0n44 = {cur_data[719], cur_data[716:707]};
    nan_mts_l0n45 = {cur_data[735], cur_data[732:723]};
    nan_mts_l0n46 = {cur_data[751], cur_data[748:739]};
    nan_mts_l0n47 = {cur_data[767], cur_data[764:755]};
    nan_mts_l0n48 = {cur_data[783], cur_data[780:771]};
    nan_mts_l0n49 = {cur_data[799], cur_data[796:787]};
    nan_mts_l0n50 = {cur_data[815], cur_data[812:803]};
    nan_mts_l0n51 = {cur_data[831], cur_data[828:819]};
    nan_mts_l0n52 = {cur_data[847], cur_data[844:835]};
    nan_mts_l0n53 = {cur_data[863], cur_data[860:851]};
    nan_mts_l0n54 = {cur_data[879], cur_data[876:867]};
    nan_mts_l0n55 = {cur_data[895], cur_data[892:883]};
    nan_mts_l0n56 = {cur_data[911], cur_data[908:899]};
    nan_mts_l0n57 = {cur_data[927], cur_data[924:915]};
    nan_mts_l0n58 = {cur_data[943], cur_data[940:931]};
    nan_mts_l0n59 = {cur_data[959], cur_data[956:947]};
    nan_mts_l0n60 = {cur_data[975], cur_data[972:963]};
    nan_mts_l0n61 = {cur_data[991], cur_data[988:979]};
    nan_mts_l0n62 = {cur_data[1007], cur_data[1004:995]};
    nan_mts_l0n63 = {cur_data[1023], cur_data[1020:1011]};
    nan_mts_l0n64 = {cur_data[1039], cur_data[1036:1027]};
    nan_mts_l0n65 = {cur_data[1055], cur_data[1052:1043]};
    nan_mts_l0n66 = {cur_data[1071], cur_data[1068:1059]};
    nan_mts_l0n67 = {cur_data[1087], cur_data[1084:1075]};
    nan_mts_l0n68 = {cur_data[1103], cur_data[1100:1091]};
    nan_mts_l0n69 = {cur_data[1119], cur_data[1116:1107]};
    nan_mts_l0n70 = {cur_data[1135], cur_data[1132:1123]};
    nan_mts_l0n71 = {cur_data[1151], cur_data[1148:1139]};
    nan_mts_l0n72 = {cur_data[1167], cur_data[1164:1155]};
    nan_mts_l0n73 = {cur_data[1183], cur_data[1180:1171]};
    nan_mts_l0n74 = {cur_data[1199], cur_data[1196:1187]};
    nan_mts_l0n75 = {cur_data[1215], cur_data[1212:1203]};
    nan_mts_l0n76 = {cur_data[1231], cur_data[1228:1219]};
    nan_mts_l0n77 = {cur_data[1247], cur_data[1244:1235]};
    nan_mts_l0n78 = {cur_data[1263], cur_data[1260:1251]};
    nan_mts_l0n79 = {cur_data[1279], cur_data[1276:1267]};
    nan_mts_l0n80 = {cur_data[1295], cur_data[1292:1283]};
    nan_mts_l0n81 = {cur_data[1311], cur_data[1308:1299]};
    nan_mts_l0n82 = {cur_data[1327], cur_data[1324:1315]};
    nan_mts_l0n83 = {cur_data[1343], cur_data[1340:1331]};
    nan_mts_l0n84 = {cur_data[1359], cur_data[1356:1347]};
    nan_mts_l0n85 = {cur_data[1375], cur_data[1372:1363]};
    nan_mts_l0n86 = {cur_data[1391], cur_data[1388:1379]};
    nan_mts_l0n87 = {cur_data[1407], cur_data[1404:1395]};
    nan_mts_l0n88 = {cur_data[1423], cur_data[1420:1411]};
    nan_mts_l0n89 = {cur_data[1439], cur_data[1436:1427]};
    nan_mts_l0n90 = {cur_data[1455], cur_data[1452:1443]};
    nan_mts_l0n91 = {cur_data[1471], cur_data[1468:1459]};
    nan_mts_l0n92 = {cur_data[1487], cur_data[1484:1475]};
    nan_mts_l0n93 = {cur_data[1503], cur_data[1500:1491]};
    nan_mts_l0n94 = {cur_data[1519], cur_data[1516:1507]};
    nan_mts_l0n95 = {cur_data[1535], cur_data[1532:1523]};
    nan_mts_l0n96 = {cur_data[1551], cur_data[1548:1539]};
    nan_mts_l0n97 = {cur_data[1567], cur_data[1564:1555]};
    nan_mts_l0n98 = {cur_data[1583], cur_data[1580:1571]};
    nan_mts_l0n99 = {cur_data[1599], cur_data[1596:1587]};
    nan_mts_l0n100 = {cur_data[1615], cur_data[1612:1603]};
    nan_mts_l0n101 = {cur_data[1631], cur_data[1628:1619]};
    nan_mts_l0n102 = {cur_data[1647], cur_data[1644:1635]};
    nan_mts_l0n103 = {cur_data[1663], cur_data[1660:1651]};
    nan_mts_l0n104 = {cur_data[1679], cur_data[1676:1667]};
    nan_mts_l0n105 = {cur_data[1695], cur_data[1692:1683]};
    nan_mts_l0n106 = {cur_data[1711], cur_data[1708:1699]};
    nan_mts_l0n107 = {cur_data[1727], cur_data[1724:1715]};
    nan_mts_l0n108 = {cur_data[1743], cur_data[1740:1731]};
    nan_mts_l0n109 = {cur_data[1759], cur_data[1756:1747]};
    nan_mts_l0n110 = {cur_data[1775], cur_data[1772:1763]};
    nan_mts_l0n111 = {cur_data[1791], cur_data[1788:1779]};
    nan_mts_l0n112 = {cur_data[1807], cur_data[1804:1795]};
    nan_mts_l0n113 = {cur_data[1823], cur_data[1820:1811]};
    nan_mts_l0n114 = {cur_data[1839], cur_data[1836:1827]};
    nan_mts_l0n115 = {cur_data[1855], cur_data[1852:1843]};
    nan_mts_l0n116 = {cur_data[1871], cur_data[1868:1859]};
    nan_mts_l0n117 = {cur_data[1887], cur_data[1884:1875]};
    nan_mts_l0n118 = {cur_data[1903], cur_data[1900:1891]};
    nan_mts_l0n119 = {cur_data[1919], cur_data[1916:1907]};
    nan_mts_l0n120 = {cur_data[1935], cur_data[1932:1923]};
    nan_mts_l0n121 = {cur_data[1951], cur_data[1948:1939]};
    nan_mts_l0n122 = {cur_data[1967], cur_data[1964:1955]};
    nan_mts_l0n123 = {cur_data[1983], cur_data[1980:1971]};
    nan_mts_l0n124 = {cur_data[1999], cur_data[1996:1987]};
    nan_mts_l0n125 = {cur_data[2015], cur_data[2012:2003]};
    nan_mts_l0n126 = {cur_data[2031], cur_data[2028:2019]};
    nan_mts_l0n127 = {cur_data[2047], cur_data[2044:2035]};
end

always @(
  nan_flag_l0
  or nan_mts_l0n0
  or nan_mts_l0n1
  or nan_mts_l0n2
  or nan_mts_l0n3
  or nan_mts_l0n4
  or nan_mts_l0n5
  or nan_mts_l0n6
  or nan_mts_l0n7
  or nan_mts_l0n8
  or nan_mts_l0n9
  or nan_mts_l0n10
  or nan_mts_l0n11
  or nan_mts_l0n12
  or nan_mts_l0n13
  or nan_mts_l0n14
  or nan_mts_l0n15
  or nan_mts_l0n16
  or nan_mts_l0n17
  or nan_mts_l0n18
  or nan_mts_l0n19
  or nan_mts_l0n20
  or nan_mts_l0n21
  or nan_mts_l0n22
  or nan_mts_l0n23
  or nan_mts_l0n24
  or nan_mts_l0n25
  or nan_mts_l0n26
  or nan_mts_l0n27
  or nan_mts_l0n28
  or nan_mts_l0n29
  or nan_mts_l0n30
  or nan_mts_l0n31
  or nan_mts_l0n32
  or nan_mts_l0n33
  or nan_mts_l0n34
  or nan_mts_l0n35
  or nan_mts_l0n36
  or nan_mts_l0n37
  or nan_mts_l0n38
  or nan_mts_l0n39
  or nan_mts_l0n40
  or nan_mts_l0n41
  or nan_mts_l0n42
  or nan_mts_l0n43
  or nan_mts_l0n44
  or nan_mts_l0n45
  or nan_mts_l0n46
  or nan_mts_l0n47
  or nan_mts_l0n48
  or nan_mts_l0n49
  or nan_mts_l0n50
  or nan_mts_l0n51
  or nan_mts_l0n52
  or nan_mts_l0n53
  or nan_mts_l0n54
  or nan_mts_l0n55
  or nan_mts_l0n56
  or nan_mts_l0n57
  or nan_mts_l0n58
  or nan_mts_l0n59
  or nan_mts_l0n60
  or nan_mts_l0n61
  or nan_mts_l0n62
  or nan_mts_l0n63
  or nan_mts_l0n64
  or nan_mts_l0n65
  or nan_mts_l0n66
  or nan_mts_l0n67
  or nan_mts_l0n68
  or nan_mts_l0n69
  or nan_mts_l0n70
  or nan_mts_l0n71
  or nan_mts_l0n72
  or nan_mts_l0n73
  or nan_mts_l0n74
  or nan_mts_l0n75
  or nan_mts_l0n76
  or nan_mts_l0n77
  or nan_mts_l0n78
  or nan_mts_l0n79
  or nan_mts_l0n80
  or nan_mts_l0n81
  or nan_mts_l0n82
  or nan_mts_l0n83
  or nan_mts_l0n84
  or nan_mts_l0n85
  or nan_mts_l0n86
  or nan_mts_l0n87
  or nan_mts_l0n88
  or nan_mts_l0n89
  or nan_mts_l0n90
  or nan_mts_l0n91
  or nan_mts_l0n92
  or nan_mts_l0n93
  or nan_mts_l0n94
  or nan_mts_l0n95
  or nan_mts_l0n96
  or nan_mts_l0n97
  or nan_mts_l0n98
  or nan_mts_l0n99
  or nan_mts_l0n100
  or nan_mts_l0n101
  or nan_mts_l0n102
  or nan_mts_l0n103
  or nan_mts_l0n104
  or nan_mts_l0n105
  or nan_mts_l0n106
  or nan_mts_l0n107
  or nan_mts_l0n108
  or nan_mts_l0n109
  or nan_mts_l0n110
  or nan_mts_l0n111
  or nan_mts_l0n112
  or nan_mts_l0n113
  or nan_mts_l0n114
  or nan_mts_l0n115
  or nan_mts_l0n116
  or nan_mts_l0n117
  or nan_mts_l0n118
  or nan_mts_l0n119
  or nan_mts_l0n120
  or nan_mts_l0n121
  or nan_mts_l0n122
  or nan_mts_l0n123
  or nan_mts_l0n124
  or nan_mts_l0n125
  or nan_mts_l0n126
  or nan_mts_l0n127
  ) begin
    nan_mts_l1n0 = nan_flag_l0[0] ? nan_mts_l0n0 : nan_mts_l0n1;
    nan_mts_l1n1 = nan_flag_l0[2] ? nan_mts_l0n2 : nan_mts_l0n3;
    nan_mts_l1n2 = nan_flag_l0[4] ? nan_mts_l0n4 : nan_mts_l0n5;
    nan_mts_l1n3 = nan_flag_l0[6] ? nan_mts_l0n6 : nan_mts_l0n7;
    nan_mts_l1n4 = nan_flag_l0[8] ? nan_mts_l0n8 : nan_mts_l0n9;
    nan_mts_l1n5 = nan_flag_l0[10] ? nan_mts_l0n10 : nan_mts_l0n11;
    nan_mts_l1n6 = nan_flag_l0[12] ? nan_mts_l0n12 : nan_mts_l0n13;
    nan_mts_l1n7 = nan_flag_l0[14] ? nan_mts_l0n14 : nan_mts_l0n15;
    nan_mts_l1n8 = nan_flag_l0[16] ? nan_mts_l0n16 : nan_mts_l0n17;
    nan_mts_l1n9 = nan_flag_l0[18] ? nan_mts_l0n18 : nan_mts_l0n19;
    nan_mts_l1n10 = nan_flag_l0[20] ? nan_mts_l0n20 : nan_mts_l0n21;
    nan_mts_l1n11 = nan_flag_l0[22] ? nan_mts_l0n22 : nan_mts_l0n23;
    nan_mts_l1n12 = nan_flag_l0[24] ? nan_mts_l0n24 : nan_mts_l0n25;
    nan_mts_l1n13 = nan_flag_l0[26] ? nan_mts_l0n26 : nan_mts_l0n27;
    nan_mts_l1n14 = nan_flag_l0[28] ? nan_mts_l0n28 : nan_mts_l0n29;
    nan_mts_l1n15 = nan_flag_l0[30] ? nan_mts_l0n30 : nan_mts_l0n31;
    nan_mts_l1n16 = nan_flag_l0[32] ? nan_mts_l0n32 : nan_mts_l0n33;
    nan_mts_l1n17 = nan_flag_l0[34] ? nan_mts_l0n34 : nan_mts_l0n35;
    nan_mts_l1n18 = nan_flag_l0[36] ? nan_mts_l0n36 : nan_mts_l0n37;
    nan_mts_l1n19 = nan_flag_l0[38] ? nan_mts_l0n38 : nan_mts_l0n39;
    nan_mts_l1n20 = nan_flag_l0[40] ? nan_mts_l0n40 : nan_mts_l0n41;
    nan_mts_l1n21 = nan_flag_l0[42] ? nan_mts_l0n42 : nan_mts_l0n43;
    nan_mts_l1n22 = nan_flag_l0[44] ? nan_mts_l0n44 : nan_mts_l0n45;
    nan_mts_l1n23 = nan_flag_l0[46] ? nan_mts_l0n46 : nan_mts_l0n47;
    nan_mts_l1n24 = nan_flag_l0[48] ? nan_mts_l0n48 : nan_mts_l0n49;
    nan_mts_l1n25 = nan_flag_l0[50] ? nan_mts_l0n50 : nan_mts_l0n51;
    nan_mts_l1n26 = nan_flag_l0[52] ? nan_mts_l0n52 : nan_mts_l0n53;
    nan_mts_l1n27 = nan_flag_l0[54] ? nan_mts_l0n54 : nan_mts_l0n55;
    nan_mts_l1n28 = nan_flag_l0[56] ? nan_mts_l0n56 : nan_mts_l0n57;
    nan_mts_l1n29 = nan_flag_l0[58] ? nan_mts_l0n58 : nan_mts_l0n59;
    nan_mts_l1n30 = nan_flag_l0[60] ? nan_mts_l0n60 : nan_mts_l0n61;
    nan_mts_l1n31 = nan_flag_l0[62] ? nan_mts_l0n62 : nan_mts_l0n63;
    nan_mts_l1n32 = nan_flag_l0[64] ? nan_mts_l0n64 : nan_mts_l0n65;
    nan_mts_l1n33 = nan_flag_l0[66] ? nan_mts_l0n66 : nan_mts_l0n67;
    nan_mts_l1n34 = nan_flag_l0[68] ? nan_mts_l0n68 : nan_mts_l0n69;
    nan_mts_l1n35 = nan_flag_l0[70] ? nan_mts_l0n70 : nan_mts_l0n71;
    nan_mts_l1n36 = nan_flag_l0[72] ? nan_mts_l0n72 : nan_mts_l0n73;
    nan_mts_l1n37 = nan_flag_l0[74] ? nan_mts_l0n74 : nan_mts_l0n75;
    nan_mts_l1n38 = nan_flag_l0[76] ? nan_mts_l0n76 : nan_mts_l0n77;
    nan_mts_l1n39 = nan_flag_l0[78] ? nan_mts_l0n78 : nan_mts_l0n79;
    nan_mts_l1n40 = nan_flag_l0[80] ? nan_mts_l0n80 : nan_mts_l0n81;
    nan_mts_l1n41 = nan_flag_l0[82] ? nan_mts_l0n82 : nan_mts_l0n83;
    nan_mts_l1n42 = nan_flag_l0[84] ? nan_mts_l0n84 : nan_mts_l0n85;
    nan_mts_l1n43 = nan_flag_l0[86] ? nan_mts_l0n86 : nan_mts_l0n87;
    nan_mts_l1n44 = nan_flag_l0[88] ? nan_mts_l0n88 : nan_mts_l0n89;
    nan_mts_l1n45 = nan_flag_l0[90] ? nan_mts_l0n90 : nan_mts_l0n91;
    nan_mts_l1n46 = nan_flag_l0[92] ? nan_mts_l0n92 : nan_mts_l0n93;
    nan_mts_l1n47 = nan_flag_l0[94] ? nan_mts_l0n94 : nan_mts_l0n95;
    nan_mts_l1n48 = nan_flag_l0[96] ? nan_mts_l0n96 : nan_mts_l0n97;
    nan_mts_l1n49 = nan_flag_l0[98] ? nan_mts_l0n98 : nan_mts_l0n99;
    nan_mts_l1n50 = nan_flag_l0[100] ? nan_mts_l0n100 : nan_mts_l0n101;
    nan_mts_l1n51 = nan_flag_l0[102] ? nan_mts_l0n102 : nan_mts_l0n103;
    nan_mts_l1n52 = nan_flag_l0[104] ? nan_mts_l0n104 : nan_mts_l0n105;
    nan_mts_l1n53 = nan_flag_l0[106] ? nan_mts_l0n106 : nan_mts_l0n107;
    nan_mts_l1n54 = nan_flag_l0[108] ? nan_mts_l0n108 : nan_mts_l0n109;
    nan_mts_l1n55 = nan_flag_l0[110] ? nan_mts_l0n110 : nan_mts_l0n111;
    nan_mts_l1n56 = nan_flag_l0[112] ? nan_mts_l0n112 : nan_mts_l0n113;
    nan_mts_l1n57 = nan_flag_l0[114] ? nan_mts_l0n114 : nan_mts_l0n115;
    nan_mts_l1n58 = nan_flag_l0[116] ? nan_mts_l0n116 : nan_mts_l0n117;
    nan_mts_l1n59 = nan_flag_l0[118] ? nan_mts_l0n118 : nan_mts_l0n119;
    nan_mts_l1n60 = nan_flag_l0[120] ? nan_mts_l0n120 : nan_mts_l0n121;
    nan_mts_l1n61 = nan_flag_l0[122] ? nan_mts_l0n122 : nan_mts_l0n123;
    nan_mts_l1n62 = nan_flag_l0[124] ? nan_mts_l0n124 : nan_mts_l0n125;
    nan_mts_l1n63 = nan_flag_l0[126] ? nan_mts_l0n126 : nan_mts_l0n127;
end

always @(
  nan_flag_l0
  ) begin
    nan_flag_l1[0] = nan_flag_l0[0] | nan_flag_l0[1];
    nan_flag_l1[1] = nan_flag_l0[2] | nan_flag_l0[3];
    nan_flag_l1[2] = nan_flag_l0[4] | nan_flag_l0[5];
    nan_flag_l1[3] = nan_flag_l0[6] | nan_flag_l0[7];
    nan_flag_l1[4] = nan_flag_l0[8] | nan_flag_l0[9];
    nan_flag_l1[5] = nan_flag_l0[10] | nan_flag_l0[11];
    nan_flag_l1[6] = nan_flag_l0[12] | nan_flag_l0[13];
    nan_flag_l1[7] = nan_flag_l0[14] | nan_flag_l0[15];
    nan_flag_l1[8] = nan_flag_l0[16] | nan_flag_l0[17];
    nan_flag_l1[9] = nan_flag_l0[18] | nan_flag_l0[19];
    nan_flag_l1[10] = nan_flag_l0[20] | nan_flag_l0[21];
    nan_flag_l1[11] = nan_flag_l0[22] | nan_flag_l0[23];
    nan_flag_l1[12] = nan_flag_l0[24] | nan_flag_l0[25];
    nan_flag_l1[13] = nan_flag_l0[26] | nan_flag_l0[27];
    nan_flag_l1[14] = nan_flag_l0[28] | nan_flag_l0[29];
    nan_flag_l1[15] = nan_flag_l0[30] | nan_flag_l0[31];
    nan_flag_l1[16] = nan_flag_l0[32] | nan_flag_l0[33];
    nan_flag_l1[17] = nan_flag_l0[34] | nan_flag_l0[35];
    nan_flag_l1[18] = nan_flag_l0[36] | nan_flag_l0[37];
    nan_flag_l1[19] = nan_flag_l0[38] | nan_flag_l0[39];
    nan_flag_l1[20] = nan_flag_l0[40] | nan_flag_l0[41];
    nan_flag_l1[21] = nan_flag_l0[42] | nan_flag_l0[43];
    nan_flag_l1[22] = nan_flag_l0[44] | nan_flag_l0[45];
    nan_flag_l1[23] = nan_flag_l0[46] | nan_flag_l0[47];
    nan_flag_l1[24] = nan_flag_l0[48] | nan_flag_l0[49];
    nan_flag_l1[25] = nan_flag_l0[50] | nan_flag_l0[51];
    nan_flag_l1[26] = nan_flag_l0[52] | nan_flag_l0[53];
    nan_flag_l1[27] = nan_flag_l0[54] | nan_flag_l0[55];
    nan_flag_l1[28] = nan_flag_l0[56] | nan_flag_l0[57];
    nan_flag_l1[29] = nan_flag_l0[58] | nan_flag_l0[59];
    nan_flag_l1[30] = nan_flag_l0[60] | nan_flag_l0[61];
    nan_flag_l1[31] = nan_flag_l0[62] | nan_flag_l0[63];
    nan_flag_l1[32] = nan_flag_l0[64] | nan_flag_l0[65];
    nan_flag_l1[33] = nan_flag_l0[66] | nan_flag_l0[67];
    nan_flag_l1[34] = nan_flag_l0[68] | nan_flag_l0[69];
    nan_flag_l1[35] = nan_flag_l0[70] | nan_flag_l0[71];
    nan_flag_l1[36] = nan_flag_l0[72] | nan_flag_l0[73];
    nan_flag_l1[37] = nan_flag_l0[74] | nan_flag_l0[75];
    nan_flag_l1[38] = nan_flag_l0[76] | nan_flag_l0[77];
    nan_flag_l1[39] = nan_flag_l0[78] | nan_flag_l0[79];
    nan_flag_l1[40] = nan_flag_l0[80] | nan_flag_l0[81];
    nan_flag_l1[41] = nan_flag_l0[82] | nan_flag_l0[83];
    nan_flag_l1[42] = nan_flag_l0[84] | nan_flag_l0[85];
    nan_flag_l1[43] = nan_flag_l0[86] | nan_flag_l0[87];
    nan_flag_l1[44] = nan_flag_l0[88] | nan_flag_l0[89];
    nan_flag_l1[45] = nan_flag_l0[90] | nan_flag_l0[91];
    nan_flag_l1[46] = nan_flag_l0[92] | nan_flag_l0[93];
    nan_flag_l1[47] = nan_flag_l0[94] | nan_flag_l0[95];
    nan_flag_l1[48] = nan_flag_l0[96] | nan_flag_l0[97];
    nan_flag_l1[49] = nan_flag_l0[98] | nan_flag_l0[99];
    nan_flag_l1[50] = nan_flag_l0[100] | nan_flag_l0[101];
    nan_flag_l1[51] = nan_flag_l0[102] | nan_flag_l0[103];
    nan_flag_l1[52] = nan_flag_l0[104] | nan_flag_l0[105];
    nan_flag_l1[53] = nan_flag_l0[106] | nan_flag_l0[107];
    nan_flag_l1[54] = nan_flag_l0[108] | nan_flag_l0[109];
    nan_flag_l1[55] = nan_flag_l0[110] | nan_flag_l0[111];
    nan_flag_l1[56] = nan_flag_l0[112] | nan_flag_l0[113];
    nan_flag_l1[57] = nan_flag_l0[114] | nan_flag_l0[115];
    nan_flag_l1[58] = nan_flag_l0[116] | nan_flag_l0[117];
    nan_flag_l1[59] = nan_flag_l0[118] | nan_flag_l0[119];
    nan_flag_l1[60] = nan_flag_l0[120] | nan_flag_l0[121];
    nan_flag_l1[61] = nan_flag_l0[122] | nan_flag_l0[123];
    nan_flag_l1[62] = nan_flag_l0[124] | nan_flag_l0[125];
    nan_flag_l1[63] = nan_flag_l0[126] | nan_flag_l0[127];
end

always @(
  nan_flag_l1
  or nan_mts_l1n0
  or nan_mts_l1n1
  or nan_mts_l1n2
  or nan_mts_l1n3
  or nan_mts_l1n4
  or nan_mts_l1n5
  or nan_mts_l1n6
  or nan_mts_l1n7
  or nan_mts_l1n8
  or nan_mts_l1n9
  or nan_mts_l1n10
  or nan_mts_l1n11
  or nan_mts_l1n12
  or nan_mts_l1n13
  or nan_mts_l1n14
  or nan_mts_l1n15
  or nan_mts_l1n16
  or nan_mts_l1n17
  or nan_mts_l1n18
  or nan_mts_l1n19
  or nan_mts_l1n20
  or nan_mts_l1n21
  or nan_mts_l1n22
  or nan_mts_l1n23
  or nan_mts_l1n24
  or nan_mts_l1n25
  or nan_mts_l1n26
  or nan_mts_l1n27
  or nan_mts_l1n28
  or nan_mts_l1n29
  or nan_mts_l1n30
  or nan_mts_l1n31
  or nan_mts_l1n32
  or nan_mts_l1n33
  or nan_mts_l1n34
  or nan_mts_l1n35
  or nan_mts_l1n36
  or nan_mts_l1n37
  or nan_mts_l1n38
  or nan_mts_l1n39
  or nan_mts_l1n40
  or nan_mts_l1n41
  or nan_mts_l1n42
  or nan_mts_l1n43
  or nan_mts_l1n44
  or nan_mts_l1n45
  or nan_mts_l1n46
  or nan_mts_l1n47
  or nan_mts_l1n48
  or nan_mts_l1n49
  or nan_mts_l1n50
  or nan_mts_l1n51
  or nan_mts_l1n52
  or nan_mts_l1n53
  or nan_mts_l1n54
  or nan_mts_l1n55
  or nan_mts_l1n56
  or nan_mts_l1n57
  or nan_mts_l1n58
  or nan_mts_l1n59
  or nan_mts_l1n60
  or nan_mts_l1n61
  or nan_mts_l1n62
  or nan_mts_l1n63
  ) begin
    nan_mts_l2n0 = nan_flag_l1[0] ? nan_mts_l1n0 : nan_mts_l1n1;
    nan_mts_l2n1 = nan_flag_l1[2] ? nan_mts_l1n2 : nan_mts_l1n3;
    nan_mts_l2n2 = nan_flag_l1[4] ? nan_mts_l1n4 : nan_mts_l1n5;
    nan_mts_l2n3 = nan_flag_l1[6] ? nan_mts_l1n6 : nan_mts_l1n7;
    nan_mts_l2n4 = nan_flag_l1[8] ? nan_mts_l1n8 : nan_mts_l1n9;
    nan_mts_l2n5 = nan_flag_l1[10] ? nan_mts_l1n10 : nan_mts_l1n11;
    nan_mts_l2n6 = nan_flag_l1[12] ? nan_mts_l1n12 : nan_mts_l1n13;
    nan_mts_l2n7 = nan_flag_l1[14] ? nan_mts_l1n14 : nan_mts_l1n15;
    nan_mts_l2n8 = nan_flag_l1[16] ? nan_mts_l1n16 : nan_mts_l1n17;
    nan_mts_l2n9 = nan_flag_l1[18] ? nan_mts_l1n18 : nan_mts_l1n19;
    nan_mts_l2n10 = nan_flag_l1[20] ? nan_mts_l1n20 : nan_mts_l1n21;
    nan_mts_l2n11 = nan_flag_l1[22] ? nan_mts_l1n22 : nan_mts_l1n23;
    nan_mts_l2n12 = nan_flag_l1[24] ? nan_mts_l1n24 : nan_mts_l1n25;
    nan_mts_l2n13 = nan_flag_l1[26] ? nan_mts_l1n26 : nan_mts_l1n27;
    nan_mts_l2n14 = nan_flag_l1[28] ? nan_mts_l1n28 : nan_mts_l1n29;
    nan_mts_l2n15 = nan_flag_l1[30] ? nan_mts_l1n30 : nan_mts_l1n31;
    nan_mts_l2n16 = nan_flag_l1[32] ? nan_mts_l1n32 : nan_mts_l1n33;
    nan_mts_l2n17 = nan_flag_l1[34] ? nan_mts_l1n34 : nan_mts_l1n35;
    nan_mts_l2n18 = nan_flag_l1[36] ? nan_mts_l1n36 : nan_mts_l1n37;
    nan_mts_l2n19 = nan_flag_l1[38] ? nan_mts_l1n38 : nan_mts_l1n39;
    nan_mts_l2n20 = nan_flag_l1[40] ? nan_mts_l1n40 : nan_mts_l1n41;
    nan_mts_l2n21 = nan_flag_l1[42] ? nan_mts_l1n42 : nan_mts_l1n43;
    nan_mts_l2n22 = nan_flag_l1[44] ? nan_mts_l1n44 : nan_mts_l1n45;
    nan_mts_l2n23 = nan_flag_l1[46] ? nan_mts_l1n46 : nan_mts_l1n47;
    nan_mts_l2n24 = nan_flag_l1[48] ? nan_mts_l1n48 : nan_mts_l1n49;
    nan_mts_l2n25 = nan_flag_l1[50] ? nan_mts_l1n50 : nan_mts_l1n51;
    nan_mts_l2n26 = nan_flag_l1[52] ? nan_mts_l1n52 : nan_mts_l1n53;
    nan_mts_l2n27 = nan_flag_l1[54] ? nan_mts_l1n54 : nan_mts_l1n55;
    nan_mts_l2n28 = nan_flag_l1[56] ? nan_mts_l1n56 : nan_mts_l1n57;
    nan_mts_l2n29 = nan_flag_l1[58] ? nan_mts_l1n58 : nan_mts_l1n59;
    nan_mts_l2n30 = nan_flag_l1[60] ? nan_mts_l1n60 : nan_mts_l1n61;
    nan_mts_l2n31 = nan_flag_l1[62] ? nan_mts_l1n62 : nan_mts_l1n63;
end

always @(
  nan_flag_l1
  ) begin
    nan_flag_l2[0] = nan_flag_l1[0] | nan_flag_l1[1];
    nan_flag_l2[1] = nan_flag_l1[2] | nan_flag_l1[3];
    nan_flag_l2[2] = nan_flag_l1[4] | nan_flag_l1[5];
    nan_flag_l2[3] = nan_flag_l1[6] | nan_flag_l1[7];
    nan_flag_l2[4] = nan_flag_l1[8] | nan_flag_l1[9];
    nan_flag_l2[5] = nan_flag_l1[10] | nan_flag_l1[11];
    nan_flag_l2[6] = nan_flag_l1[12] | nan_flag_l1[13];
    nan_flag_l2[7] = nan_flag_l1[14] | nan_flag_l1[15];
    nan_flag_l2[8] = nan_flag_l1[16] | nan_flag_l1[17];
    nan_flag_l2[9] = nan_flag_l1[18] | nan_flag_l1[19];
    nan_flag_l2[10] = nan_flag_l1[20] | nan_flag_l1[21];
    nan_flag_l2[11] = nan_flag_l1[22] | nan_flag_l1[23];
    nan_flag_l2[12] = nan_flag_l1[24] | nan_flag_l1[25];
    nan_flag_l2[13] = nan_flag_l1[26] | nan_flag_l1[27];
    nan_flag_l2[14] = nan_flag_l1[28] | nan_flag_l1[29];
    nan_flag_l2[15] = nan_flag_l1[30] | nan_flag_l1[31];
    nan_flag_l2[16] = nan_flag_l1[32] | nan_flag_l1[33];
    nan_flag_l2[17] = nan_flag_l1[34] | nan_flag_l1[35];
    nan_flag_l2[18] = nan_flag_l1[36] | nan_flag_l1[37];
    nan_flag_l2[19] = nan_flag_l1[38] | nan_flag_l1[39];
    nan_flag_l2[20] = nan_flag_l1[40] | nan_flag_l1[41];
    nan_flag_l2[21] = nan_flag_l1[42] | nan_flag_l1[43];
    nan_flag_l2[22] = nan_flag_l1[44] | nan_flag_l1[45];
    nan_flag_l2[23] = nan_flag_l1[46] | nan_flag_l1[47];
    nan_flag_l2[24] = nan_flag_l1[48] | nan_flag_l1[49];
    nan_flag_l2[25] = nan_flag_l1[50] | nan_flag_l1[51];
    nan_flag_l2[26] = nan_flag_l1[52] | nan_flag_l1[53];
    nan_flag_l2[27] = nan_flag_l1[54] | nan_flag_l1[55];
    nan_flag_l2[28] = nan_flag_l1[56] | nan_flag_l1[57];
    nan_flag_l2[29] = nan_flag_l1[58] | nan_flag_l1[59];
    nan_flag_l2[30] = nan_flag_l1[60] | nan_flag_l1[61];
    nan_flag_l2[31] = nan_flag_l1[62] | nan_flag_l1[63];
end

always @(
  nan_flag_l2
  or nan_mts_l2n0
  or nan_mts_l2n1
  or nan_mts_l2n2
  or nan_mts_l2n3
  or nan_mts_l2n4
  or nan_mts_l2n5
  or nan_mts_l2n6
  or nan_mts_l2n7
  or nan_mts_l2n8
  or nan_mts_l2n9
  or nan_mts_l2n10
  or nan_mts_l2n11
  or nan_mts_l2n12
  or nan_mts_l2n13
  or nan_mts_l2n14
  or nan_mts_l2n15
  or nan_mts_l2n16
  or nan_mts_l2n17
  or nan_mts_l2n18
  or nan_mts_l2n19
  or nan_mts_l2n20
  or nan_mts_l2n21
  or nan_mts_l2n22
  or nan_mts_l2n23
  or nan_mts_l2n24
  or nan_mts_l2n25
  or nan_mts_l2n26
  or nan_mts_l2n27
  or nan_mts_l2n28
  or nan_mts_l2n29
  or nan_mts_l2n30
  or nan_mts_l2n31
  ) begin
    nan_mts_l3n0 = nan_flag_l2[0] ? nan_mts_l2n0 : nan_mts_l2n1;
    nan_mts_l3n1 = nan_flag_l2[2] ? nan_mts_l2n2 : nan_mts_l2n3;
    nan_mts_l3n2 = nan_flag_l2[4] ? nan_mts_l2n4 : nan_mts_l2n5;
    nan_mts_l3n3 = nan_flag_l2[6] ? nan_mts_l2n6 : nan_mts_l2n7;
    nan_mts_l3n4 = nan_flag_l2[8] ? nan_mts_l2n8 : nan_mts_l2n9;
    nan_mts_l3n5 = nan_flag_l2[10] ? nan_mts_l2n10 : nan_mts_l2n11;
    nan_mts_l3n6 = nan_flag_l2[12] ? nan_mts_l2n12 : nan_mts_l2n13;
    nan_mts_l3n7 = nan_flag_l2[14] ? nan_mts_l2n14 : nan_mts_l2n15;
    nan_mts_l3n8 = nan_flag_l2[16] ? nan_mts_l2n16 : nan_mts_l2n17;
    nan_mts_l3n9 = nan_flag_l2[18] ? nan_mts_l2n18 : nan_mts_l2n19;
    nan_mts_l3n10 = nan_flag_l2[20] ? nan_mts_l2n20 : nan_mts_l2n21;
    nan_mts_l3n11 = nan_flag_l2[22] ? nan_mts_l2n22 : nan_mts_l2n23;
    nan_mts_l3n12 = nan_flag_l2[24] ? nan_mts_l2n24 : nan_mts_l2n25;
    nan_mts_l3n13 = nan_flag_l2[26] ? nan_mts_l2n26 : nan_mts_l2n27;
    nan_mts_l3n14 = nan_flag_l2[28] ? nan_mts_l2n28 : nan_mts_l2n29;
    nan_mts_l3n15 = nan_flag_l2[30] ? nan_mts_l2n30 : nan_mts_l2n31;
end

always @(
  nan_flag_l2
  ) begin
    nan_flag_l3[0] = nan_flag_l2[0] | nan_flag_l2[1];
    nan_flag_l3[1] = nan_flag_l2[2] | nan_flag_l2[3];
    nan_flag_l3[2] = nan_flag_l2[4] | nan_flag_l2[5];
    nan_flag_l3[3] = nan_flag_l2[6] | nan_flag_l2[7];
    nan_flag_l3[4] = nan_flag_l2[8] | nan_flag_l2[9];
    nan_flag_l3[5] = nan_flag_l2[10] | nan_flag_l2[11];
    nan_flag_l3[6] = nan_flag_l2[12] | nan_flag_l2[13];
    nan_flag_l3[7] = nan_flag_l2[14] | nan_flag_l2[15];
    nan_flag_l3[8] = nan_flag_l2[16] | nan_flag_l2[17];
    nan_flag_l3[9] = nan_flag_l2[18] | nan_flag_l2[19];
    nan_flag_l3[10] = nan_flag_l2[20] | nan_flag_l2[21];
    nan_flag_l3[11] = nan_flag_l2[22] | nan_flag_l2[23];
    nan_flag_l3[12] = nan_flag_l2[24] | nan_flag_l2[25];
    nan_flag_l3[13] = nan_flag_l2[26] | nan_flag_l2[27];
    nan_flag_l3[14] = nan_flag_l2[28] | nan_flag_l2[29];
    nan_flag_l3[15] = nan_flag_l2[30] | nan_flag_l2[31];
end

always @(
  nan_flag_l3
  or nan_mts_l3n0
  or nan_mts_l3n1
  or nan_mts_l3n2
  or nan_mts_l3n3
  or nan_mts_l3n4
  or nan_mts_l3n5
  or nan_mts_l3n6
  or nan_mts_l3n7
  or nan_mts_l3n8
  or nan_mts_l3n9
  or nan_mts_l3n10
  or nan_mts_l3n11
  or nan_mts_l3n12
  or nan_mts_l3n13
  or nan_mts_l3n14
  or nan_mts_l3n15
  ) begin
    nan_mts_l4n0 = nan_flag_l3[0] ? nan_mts_l3n0 : nan_mts_l3n1;
    nan_mts_l4n1 = nan_flag_l3[2] ? nan_mts_l3n2 : nan_mts_l3n3;
    nan_mts_l4n2 = nan_flag_l3[4] ? nan_mts_l3n4 : nan_mts_l3n5;
    nan_mts_l4n3 = nan_flag_l3[6] ? nan_mts_l3n6 : nan_mts_l3n7;
    nan_mts_l4n4 = nan_flag_l3[8] ? nan_mts_l3n8 : nan_mts_l3n9;
    nan_mts_l4n5 = nan_flag_l3[10] ? nan_mts_l3n10 : nan_mts_l3n11;
    nan_mts_l4n6 = nan_flag_l3[12] ? nan_mts_l3n12 : nan_mts_l3n13;
    nan_mts_l4n7 = nan_flag_l3[14] ? nan_mts_l3n14 : nan_mts_l3n15;
end

always @(
  nan_flag_l3
  ) begin
    nan_flag_l4[0] = nan_flag_l3[0] | nan_flag_l3[1];
    nan_flag_l4[1] = nan_flag_l3[2] | nan_flag_l3[3];
    nan_flag_l4[2] = nan_flag_l3[4] | nan_flag_l3[5];
    nan_flag_l4[3] = nan_flag_l3[6] | nan_flag_l3[7];
    nan_flag_l4[4] = nan_flag_l3[8] | nan_flag_l3[9];
    nan_flag_l4[5] = nan_flag_l3[10] | nan_flag_l3[11];
    nan_flag_l4[6] = nan_flag_l3[12] | nan_flag_l3[13];
    nan_flag_l4[7] = nan_flag_l3[14] | nan_flag_l3[15];
end

always @(
  nan_flag_l4
  or nan_mts_l4n0
  or nan_mts_l4n1
  or nan_mts_l4n2
  or nan_mts_l4n3
  or nan_mts_l4n4
  or nan_mts_l4n5
  or nan_mts_l4n6
  or nan_mts_l4n7
  ) begin
    nan_mts_l5n0 = nan_flag_l4[0] ? nan_mts_l4n0 : nan_mts_l4n1;
    nan_mts_l5n1 = nan_flag_l4[2] ? nan_mts_l4n2 : nan_mts_l4n3;
    nan_mts_l5n2 = nan_flag_l4[4] ? nan_mts_l4n4 : nan_mts_l4n5;
    nan_mts_l5n3 = nan_flag_l4[6] ? nan_mts_l4n6 : nan_mts_l4n7;
end

always @(
  nan_flag_l4
  ) begin
    nan_flag_l5[0] = nan_flag_l4[0] | nan_flag_l4[1];
    nan_flag_l5[1] = nan_flag_l4[2] | nan_flag_l4[3];
    nan_flag_l5[2] = nan_flag_l4[4] | nan_flag_l4[5];
    nan_flag_l5[3] = nan_flag_l4[6] | nan_flag_l4[7];
end

always @(
  nan_flag_l5
  or nan_mts_l5n0
  or nan_mts_l5n1
  or nan_mts_l5n2
  or nan_mts_l5n3
  ) begin
    nan_mts_l6n0 = nan_flag_l5[0] ? nan_mts_l5n0 : nan_mts_l5n1;
    nan_mts_l6n1 = nan_flag_l5[2] ? nan_mts_l5n2 : nan_mts_l5n3;
end

always @(
  nan_flag_l5
  ) begin
    nan_flag_l6[0] = nan_flag_l5[0] | nan_flag_l5[1];
    nan_flag_l6[1] = nan_flag_l5[2] | nan_flag_l5[3];
end

always @(
  nan_flag_l6
  or nan_mts_l6n0
  or nan_mts_l6n1
  ) begin
    nan_mts_l7n0 = nan_flag_l6[0] ? nan_mts_l6n0 : nan_mts_l6n1;
end

always @(
  nan_flag_l6
  ) begin
    nan_flag_l7[0] = nan_flag_l6[0] | nan_flag_l6[1];
end


always @(
  cfg_is_fp16_d1
  or wt_actv_nan
  or dat_actv_nan
  ) begin
    out_nan_pvld = cfg_is_fp16_d1[32] & (|{wt_actv_nan, dat_actv_nan});
end

assign out_nan_mts = nan_mts_l7n0 & {11{nan_flag_l7[0]}};

endmodule // NV_NVDLA_CMAC_CORE_MAC_nan


