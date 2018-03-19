// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CSC_pra_cell.v

module NV_NVDLA_CSC_pra_cell (
   cfg_precision       //|< i
  ,cfg_truncate_rsc_z  //|< i
  ,chn_data_in_rsc_vz  //|< i
  ,chn_data_in_rsc_z   //|< i
  ,chn_data_out_rsc_vz //|< i
  ,nvdla_core_clk      //|< i
  ,nvdla_core_rstn     //|< i
  ,chn_data_in_rsc_lz  //|> o
  ,chn_data_out_rsc_lz //|> o
  ,chn_data_out_rsc_z  //|> o
  );

input    [1:0] cfg_precision;
input    [1:0] cfg_truncate_rsc_z;
input          chn_data_in_rsc_vz;
input  [255:0] chn_data_in_rsc_z;
input          chn_data_out_rsc_vz;
input          nvdla_core_clk;
input          nvdla_core_rstn;
output         chn_data_in_rsc_lz;
output         chn_data_out_rsc_lz;
output [255:0] chn_data_out_rsc_z;

wire     [1:0] cfg_truncate;
wire   [255:0] chn_data_in;
wire    [15:0] chn_data_in_0;
wire    [15:0] chn_data_in_1;
wire    [15:0] chn_data_in_10;
wire    [15:0] chn_data_in_11;
wire    [15:0] chn_data_in_12;
wire    [15:0] chn_data_in_13;
wire    [15:0] chn_data_in_14;
wire    [15:0] chn_data_in_15;
wire    [15:0] chn_data_in_2;
wire    [15:0] chn_data_in_3;
wire    [15:0] chn_data_in_4;
wire    [15:0] chn_data_in_5;
wire    [15:0] chn_data_in_6;
wire    [15:0] chn_data_in_7;
wire    [15:0] chn_data_in_8;
wire    [15:0] chn_data_in_9;
wire   [255:0] chn_data_out;
wire   [255:0] chn_data_reg;
wire   [255:0] chn_dout;
wire           chn_in_prdy;
wire           chn_in_pvld;
wire           chn_out_prdy;
wire           chn_out_pvld;
wire           din_prdy;
wire           din_pvld;
wire           final_out_prdy;
wire           final_out_pvld;
wire   [271:0] mdata_out;
wire    [16:0] mdata_out_0;
wire    [16:0] mdata_out_1;
wire    [16:0] mdata_out_10;
wire    [16:0] mdata_out_11;
wire    [16:0] mdata_out_12;
wire    [16:0] mdata_out_13;
wire    [16:0] mdata_out_14;
wire    [16:0] mdata_out_15;
wire    [16:0] mdata_out_2;
wire    [16:0] mdata_out_3;
wire    [16:0] mdata_out_4;
wire    [16:0] mdata_out_5;
wire    [16:0] mdata_out_6;
wire    [16:0] mdata_out_7;
wire    [16:0] mdata_out_8;
wire    [16:0] mdata_out_9;
wire   [271:0] mdout;
wire    [16:0] mdout_0;
wire    [16:0] mdout_1;
wire    [16:0] mdout_10;
wire    [16:0] mdout_11;
wire    [16:0] mdout_12;
wire    [16:0] mdout_13;
wire    [16:0] mdout_14;
wire    [16:0] mdout_15;
wire    [16:0] mdout_2;
wire    [16:0] mdout_3;
wire    [16:0] mdout_4;
wire    [16:0] mdout_5;
wire    [16:0] mdout_6;
wire    [16:0] mdout_7;
wire    [16:0] mdout_8;
wire    [16:0] mdout_9;
wire           mout_prdy;
wire           mout_pvld;
wire   [287:0] tdata_out;
wire    [17:0] tdata_out_0;
wire    [17:0] tdata_out_1;
wire    [17:0] tdata_out_10;
wire    [17:0] tdata_out_11;
wire    [17:0] tdata_out_12;
wire    [17:0] tdata_out_13;
wire    [17:0] tdata_out_14;
wire    [17:0] tdata_out_15;
wire    [17:0] tdata_out_2;
wire    [17:0] tdata_out_3;
wire    [17:0] tdata_out_4;
wire    [17:0] tdata_out_5;
wire    [17:0] tdata_out_6;
wire    [17:0] tdata_out_7;
wire    [17:0] tdata_out_8;
wire    [17:0] tdata_out_9;
wire   [287:0] tdout;
wire    [17:0] tdout_0;
wire    [17:0] tdout_1;
wire    [17:0] tdout_10;
wire    [17:0] tdout_11;
wire    [17:0] tdout_12;
wire    [17:0] tdout_13;
wire    [17:0] tdout_14;
wire    [17:0] tdout_15;
wire    [17:0] tdout_2;
wire    [17:0] tdout_3;
wire    [17:0] tdout_4;
wire    [17:0] tdout_5;
wire    [17:0] tdout_6;
wire    [17:0] tdout_7;
wire    [17:0] tdout_8;
wire    [17:0] tdout_9;
wire           tout_prdy;
wire           tout_pvld;
wire   [255:0] tru_data_out_int16;
wire   [255:0] tru_data_out_int8;
wire   [255:0] tru_dout_int16;
wire    [15:0] tru_dout_int16_0;
wire    [15:0] tru_dout_int16_1;
wire    [15:0] tru_dout_int16_10;
wire    [15:0] tru_dout_int16_11;
wire    [15:0] tru_dout_int16_12;
wire    [15:0] tru_dout_int16_13;
wire    [15:0] tru_dout_int16_14;
wire    [15:0] tru_dout_int16_15;
wire    [15:0] tru_dout_int16_2;
wire    [15:0] tru_dout_int16_3;
wire    [15:0] tru_dout_int16_4;
wire    [15:0] tru_dout_int16_5;
wire    [15:0] tru_dout_int16_6;
wire    [15:0] tru_dout_int16_7;
wire    [15:0] tru_dout_int16_8;
wire    [15:0] tru_dout_int16_9;
wire     [7:0] tru_dout_int8_0;
wire     [7:0] tru_dout_int8_1;
wire     [7:0] tru_dout_int8_10;
wire     [7:0] tru_dout_int8_11;
wire     [7:0] tru_dout_int8_12;
wire     [7:0] tru_dout_int8_13;
wire     [7:0] tru_dout_int8_14;
wire     [7:0] tru_dout_int8_15;
wire     [7:0] tru_dout_int8_2;
wire     [7:0] tru_dout_int8_3;
wire     [7:0] tru_dout_int8_4;
wire     [7:0] tru_dout_int8_5;
wire     [7:0] tru_dout_int8_6;
wire     [7:0] tru_dout_int8_7;
wire     [7:0] tru_dout_int8_8;
wire     [7:0] tru_dout_int8_9;
wire   [255:0] tru_dout_int8_ext;
wire    [15:0] tru_dout_int8_ext_0;
wire    [15:0] tru_dout_int8_ext_1;
wire    [15:0] tru_dout_int8_ext_10;
wire    [15:0] tru_dout_int8_ext_11;
wire    [15:0] tru_dout_int8_ext_12;
wire    [15:0] tru_dout_int8_ext_13;
wire    [15:0] tru_dout_int8_ext_14;
wire    [15:0] tru_dout_int8_ext_15;
wire    [15:0] tru_dout_int8_ext_2;
wire    [15:0] tru_dout_int8_ext_3;
wire    [15:0] tru_dout_int8_ext_4;
wire    [15:0] tru_dout_int8_ext_5;
wire    [15:0] tru_dout_int8_ext_6;
wire    [15:0] tru_dout_int8_ext_7;
wire    [15:0] tru_dout_int8_ext_8;
wire    [15:0] tru_dout_int8_ext_9;


// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
assign  chn_in_pvld  = chn_data_in_rsc_vz;
assign  chn_out_prdy = chn_data_out_rsc_vz;
assign  cfg_truncate[1:0] = cfg_truncate_rsc_z[1:0];
assign  chn_data_in[255:0] = chn_data_in_rsc_z[255:0];

assign  chn_data_out_rsc_z[255:0] = chn_data_out[255:0];
assign  chn_data_in_rsc_lz  = chn_in_prdy;
assign  chn_data_out_rsc_lz = chn_out_pvld;

NV_NVDLA_CSC_PRA_CELL_pipe_p1 pipe_p1 (
   .nvdla_core_clk     (nvdla_core_clk)            //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)           //|< i
  ,.chn_data_in        (chn_data_in[255:0])        //|< w
  ,.chn_in_pvld        (chn_in_pvld)               //|< w
  ,.din_prdy           (din_prdy)                  //|< w
  ,.chn_data_reg       (chn_data_reg[255:0])       //|> w
  ,.chn_in_prdy        (chn_in_prdy)               //|> w
  ,.din_pvld           (din_pvld)                  //|> w
  );

assign {chn_data_in_15, chn_data_in_14, chn_data_in_13, chn_data_in_12, chn_data_in_11, chn_data_in_10, chn_data_in_9, chn_data_in_8, chn_data_in_7, chn_data_in_6, chn_data_in_5, chn_data_in_4, chn_data_in_3, chn_data_in_2, chn_data_in_1, chn_data_in_0} = chn_data_reg[255:0];

assign mdout_0[16:0] = $signed(chn_data_in_0[15:0]) - $signed(chn_data_in_8[15:0]);
assign mdout_1[16:0] = $signed(chn_data_in_1[15:0]) - $signed(chn_data_in_9[15:0]);
assign mdout_2[16:0] = $signed(chn_data_in_2[15:0]) - $signed(chn_data_in_10[15:0]);
assign mdout_3[16:0] = $signed(chn_data_in_3[15:0]) - $signed(chn_data_in_11[15:0]);

assign mdout_4[16:0] = $signed(chn_data_in_4[15:0]) + $signed(chn_data_in_8[15:0]);
assign mdout_5[16:0] = $signed(chn_data_in_5[15:0]) + $signed(chn_data_in_9[15:0]);
assign mdout_6[16:0] = $signed(chn_data_in_6[15:0]) + $signed(chn_data_in_10[15:0]);
assign mdout_7[16:0] = $signed(chn_data_in_7[15:0]) + $signed(chn_data_in_11[15:0]);

assign mdout_8[16:0] = $signed(chn_data_in_8[15:0]) - $signed(chn_data_in_4[15:0]);
assign mdout_9[16:0] = $signed(chn_data_in_9[15:0]) - $signed(chn_data_in_5[15:0]);
assign mdout_10[16:0] = $signed(chn_data_in_10[15:0]) - $signed(chn_data_in_6[15:0]);
assign mdout_11[16:0] = $signed(chn_data_in_11[15:0]) - $signed(chn_data_in_7[15:0]);

assign mdout_12[16:0] = $signed(chn_data_in_4[15:0]) - $signed(chn_data_in_12[15:0]);
assign mdout_13[16:0] = $signed(chn_data_in_5[15:0]) - $signed(chn_data_in_13[15:0]);
assign mdout_14[16:0] = $signed(chn_data_in_6[15:0]) - $signed(chn_data_in_14[15:0]);
assign mdout_15[16:0] = $signed(chn_data_in_7[15:0]) - $signed(chn_data_in_15[15:0]);

assign tdout_0[17:0] = $signed(mdata_out_0[16:0]) - $signed(mdata_out_2[16:0]);
assign tdout_4[17:0] = $signed(mdata_out_4[16:0]) - $signed(mdata_out_6[16:0]);
assign tdout_8[17:0] = $signed(mdata_out_8[16:0]) - $signed(mdata_out_10[16:0]);
assign tdout_12[17:0] = $signed(mdata_out_12[16:0]) - $signed(mdata_out_14[16:0]);

assign tdout_1[17:0] = $signed(mdata_out_1[16:0]) + $signed(mdata_out_2[16:0]);
assign tdout_5[17:0] = $signed(mdata_out_5[16:0]) + $signed(mdata_out_6[16:0]);
assign tdout_9[17:0] = $signed(mdata_out_9[16:0]) + $signed(mdata_out_10[16:0]);
assign tdout_13[17:0] = $signed(mdata_out_13[16:0]) + $signed(mdata_out_14[16:0]);

assign tdout_2[17:0] = $signed(mdata_out_2[16:0]) - $signed(mdata_out_1[16:0]);
assign tdout_6[17:0] = $signed(mdata_out_6[16:0]) - $signed(mdata_out_5[16:0]);
assign tdout_10[17:0] = $signed(mdata_out_10[16:0]) - $signed(mdata_out_9[16:0]);
assign tdout_14[17:0] = $signed(mdata_out_14[16:0]) - $signed(mdata_out_13[16:0]);

assign tdout_3[17:0] = $signed(mdata_out_1[16:0]) - $signed(mdata_out_3[16:0]);
assign tdout_7[17:0] = $signed(mdata_out_5[16:0]) - $signed(mdata_out_7[16:0]);
assign tdout_11[17:0] = $signed(mdata_out_9[16:0]) - $signed(mdata_out_11[16:0]);
assign tdout_15[17:0] = $signed(mdata_out_13[16:0]) - $signed(mdata_out_15[16:0]);

//row
assign  mdout[271:0] = { mdout_15, mdout_14, mdout_13, mdout_12, mdout_11, mdout_10, mdout_9, mdout_8, mdout_7, mdout_6, mdout_5, mdout_4, mdout_3, mdout_2, mdout_1, mdout_0};

NV_NVDLA_CSC_PRA_CELL_pipe_p2 pipe_p2 (
   .nvdla_core_clk     (nvdla_core_clk)            //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)           //|< i
  ,.din_pvld           (din_pvld)                  //|< w
  ,.mdout              (mdout[271:0])              //|< w
  ,.mout_prdy          (mout_prdy)                 //|< w
  ,.din_prdy           (din_prdy)                  //|> w
  ,.mdata_out          (mdata_out[271:0])          //|> w
  ,.mout_pvld          (mout_pvld)                 //|> w
  );

assign {mdata_out_15, mdata_out_14, mdata_out_13, mdata_out_12, mdata_out_11, mdata_out_10, mdata_out_9, mdata_out_8, mdata_out_7, mdata_out_6, mdata_out_5, mdata_out_4, mdata_out_3, mdata_out_2, mdata_out_1, mdata_out_0} = mdata_out[271:0];

//col
assign  tdout[287:0] = { tdout_15, tdout_14, tdout_13, tdout_12, tdout_11, tdout_10, tdout_9, tdout_8, tdout_7, tdout_6, tdout_5, tdout_4, tdout_3, tdout_2, tdout_1, tdout_0};

NV_NVDLA_CSC_PRA_CELL_pipe_p3 pipe_p3 (
   .nvdla_core_clk     (nvdla_core_clk)            //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)           //|< i
  ,.mout_pvld          (mout_pvld)                 //|< w
  ,.tdout              (tdout[287:0])              //|< w
  ,.tout_prdy          (tout_prdy)                 //|< w
  ,.mout_prdy          (mout_prdy)                 //|> w
  ,.tdata_out          (tdata_out[287:0])          //|> w
  ,.tout_pvld          (tout_pvld)                 //|> w
  );

assign {tdata_out_15, tdata_out_14, tdata_out_13, tdata_out_12, tdata_out_11, tdata_out_10, tdata_out_9, tdata_out_8, tdata_out_7, tdata_out_6, tdata_out_5, tdata_out_4, tdata_out_3, tdata_out_2, tdata_out_1, tdata_out_0} = tdata_out[287:0];

NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(16 ),.SHIFT_WIDTH(2 )) int16_shiftright_su_0 (
   .data_in            (tdata_out_0[17:0])         //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int16_0[15:0])    //|> w
  );
//signed 
//unsigned

NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(8 ),.SHIFT_WIDTH(2 )) int8_shiftright_su_0 (
   .data_in            (tdata_out_0[17:0])         //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int8_0[7:0])      //|> w
  );
//signed 
//unsigned

assign  tru_dout_int8_ext_0[15:0] = {{(16 - 8 ){tru_dout_int8_0[8 -1]}},tru_dout_int8_0[7:0]}; 
NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(16 ),.SHIFT_WIDTH(2 )) int16_shiftright_su_1 (
   .data_in            (tdata_out_1[17:0])         //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int16_1[15:0])    //|> w
  );
//signed 
//unsigned

NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(8 ),.SHIFT_WIDTH(2 )) int8_shiftright_su_1 (
   .data_in            (tdata_out_1[17:0])         //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int8_1[7:0])      //|> w
  );
//signed 
//unsigned

assign  tru_dout_int8_ext_1[15:0] = {{(16 - 8 ){tru_dout_int8_1[8 -1]}},tru_dout_int8_1[7:0]}; 
NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(16 ),.SHIFT_WIDTH(2 )) int16_shiftright_su_2 (
   .data_in            (tdata_out_2[17:0])         //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int16_2[15:0])    //|> w
  );
//signed 
//unsigned

NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(8 ),.SHIFT_WIDTH(2 )) int8_shiftright_su_2 (
   .data_in            (tdata_out_2[17:0])         //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int8_2[7:0])      //|> w
  );
//signed 
//unsigned

assign  tru_dout_int8_ext_2[15:0] = {{(16 - 8 ){tru_dout_int8_2[8 -1]}},tru_dout_int8_2[7:0]}; 
NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(16 ),.SHIFT_WIDTH(2 )) int16_shiftright_su_3 (
   .data_in            (tdata_out_3[17:0])         //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int16_3[15:0])    //|> w
  );
//signed 
//unsigned

NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(8 ),.SHIFT_WIDTH(2 )) int8_shiftright_su_3 (
   .data_in            (tdata_out_3[17:0])         //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int8_3[7:0])      //|> w
  );
//signed 
//unsigned

assign  tru_dout_int8_ext_3[15:0] = {{(16 - 8 ){tru_dout_int8_3[8 -1]}},tru_dout_int8_3[7:0]}; 
NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(16 ),.SHIFT_WIDTH(2 )) int16_shiftright_su_4 (
   .data_in            (tdata_out_4[17:0])         //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int16_4[15:0])    //|> w
  );
//signed 
//unsigned

NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(8 ),.SHIFT_WIDTH(2 )) int8_shiftright_su_4 (
   .data_in            (tdata_out_4[17:0])         //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int8_4[7:0])      //|> w
  );
//signed 
//unsigned

assign  tru_dout_int8_ext_4[15:0] = {{(16 - 8 ){tru_dout_int8_4[8 -1]}},tru_dout_int8_4[7:0]}; 
NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(16 ),.SHIFT_WIDTH(2 )) int16_shiftright_su_5 (
   .data_in            (tdata_out_5[17:0])         //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int16_5[15:0])    //|> w
  );
//signed 
//unsigned

NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(8 ),.SHIFT_WIDTH(2 )) int8_shiftright_su_5 (
   .data_in            (tdata_out_5[17:0])         //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int8_5[7:0])      //|> w
  );
//signed 
//unsigned

assign  tru_dout_int8_ext_5[15:0] = {{(16 - 8 ){tru_dout_int8_5[8 -1]}},tru_dout_int8_5[7:0]}; 
NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(16 ),.SHIFT_WIDTH(2 )) int16_shiftright_su_6 (
   .data_in            (tdata_out_6[17:0])         //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int16_6[15:0])    //|> w
  );
//signed 
//unsigned

NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(8 ),.SHIFT_WIDTH(2 )) int8_shiftright_su_6 (
   .data_in            (tdata_out_6[17:0])         //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int8_6[7:0])      //|> w
  );
//signed 
//unsigned

assign  tru_dout_int8_ext_6[15:0] = {{(16 - 8 ){tru_dout_int8_6[8 -1]}},tru_dout_int8_6[7:0]}; 
NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(16 ),.SHIFT_WIDTH(2 )) int16_shiftright_su_7 (
   .data_in            (tdata_out_7[17:0])         //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int16_7[15:0])    //|> w
  );
//signed 
//unsigned

NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(8 ),.SHIFT_WIDTH(2 )) int8_shiftright_su_7 (
   .data_in            (tdata_out_7[17:0])         //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int8_7[7:0])      //|> w
  );
//signed 
//unsigned

assign  tru_dout_int8_ext_7[15:0] = {{(16 - 8 ){tru_dout_int8_7[8 -1]}},tru_dout_int8_7[7:0]}; 
NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(16 ),.SHIFT_WIDTH(2 )) int16_shiftright_su_8 (
   .data_in            (tdata_out_8[17:0])         //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int16_8[15:0])    //|> w
  );
//signed 
//unsigned

NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(8 ),.SHIFT_WIDTH(2 )) int8_shiftright_su_8 (
   .data_in            (tdata_out_8[17:0])         //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int8_8[7:0])      //|> w
  );
//signed 
//unsigned

assign  tru_dout_int8_ext_8[15:0] = {{(16 - 8 ){tru_dout_int8_8[8 -1]}},tru_dout_int8_8[7:0]}; 
NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(16 ),.SHIFT_WIDTH(2 )) int16_shiftright_su_9 (
   .data_in            (tdata_out_9[17:0])         //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int16_9[15:0])    //|> w
  );
//signed 
//unsigned

NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(8 ),.SHIFT_WIDTH(2 )) int8_shiftright_su_9 (
   .data_in            (tdata_out_9[17:0])         //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int8_9[7:0])      //|> w
  );
//signed 
//unsigned

assign  tru_dout_int8_ext_9[15:0] = {{(16 - 8 ){tru_dout_int8_9[8 -1]}},tru_dout_int8_9[7:0]}; 
NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(16 ),.SHIFT_WIDTH(2 )) int16_shiftright_su_10 (
   .data_in            (tdata_out_10[17:0])        //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int16_10[15:0])   //|> w
  );
//signed 
//unsigned

NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(8 ),.SHIFT_WIDTH(2 )) int8_shiftright_su_10 (
   .data_in            (tdata_out_10[17:0])        //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int8_10[7:0])     //|> w
  );
//signed 
//unsigned

assign  tru_dout_int8_ext_10[15:0] = {{(16 - 8 ){tru_dout_int8_10[8 -1]}},tru_dout_int8_10[7:0]}; 
NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(16 ),.SHIFT_WIDTH(2 )) int16_shiftright_su_11 (
   .data_in            (tdata_out_11[17:0])        //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int16_11[15:0])   //|> w
  );
//signed 
//unsigned

NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(8 ),.SHIFT_WIDTH(2 )) int8_shiftright_su_11 (
   .data_in            (tdata_out_11[17:0])        //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int8_11[7:0])     //|> w
  );
//signed 
//unsigned

assign  tru_dout_int8_ext_11[15:0] = {{(16 - 8 ){tru_dout_int8_11[8 -1]}},tru_dout_int8_11[7:0]}; 
NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(16 ),.SHIFT_WIDTH(2 )) int16_shiftright_su_12 (
   .data_in            (tdata_out_12[17:0])        //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int16_12[15:0])   //|> w
  );
//signed 
//unsigned

NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(8 ),.SHIFT_WIDTH(2 )) int8_shiftright_su_12 (
   .data_in            (tdata_out_12[17:0])        //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int8_12[7:0])     //|> w
  );
//signed 
//unsigned

assign  tru_dout_int8_ext_12[15:0] = {{(16 - 8 ){tru_dout_int8_12[8 -1]}},tru_dout_int8_12[7:0]}; 
NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(16 ),.SHIFT_WIDTH(2 )) int16_shiftright_su_13 (
   .data_in            (tdata_out_13[17:0])        //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int16_13[15:0])   //|> w
  );
//signed 
//unsigned

NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(8 ),.SHIFT_WIDTH(2 )) int8_shiftright_su_13 (
   .data_in            (tdata_out_13[17:0])        //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int8_13[7:0])     //|> w
  );
//signed 
//unsigned

assign  tru_dout_int8_ext_13[15:0] = {{(16 - 8 ){tru_dout_int8_13[8 -1]}},tru_dout_int8_13[7:0]}; 
NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(16 ),.SHIFT_WIDTH(2 )) int16_shiftright_su_14 (
   .data_in            (tdata_out_14[17:0])        //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int16_14[15:0])   //|> w
  );
//signed 
//unsigned

NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(8 ),.SHIFT_WIDTH(2 )) int8_shiftright_su_14 (
   .data_in            (tdata_out_14[17:0])        //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int8_14[7:0])     //|> w
  );
//signed 
//unsigned

assign  tru_dout_int8_ext_14[15:0] = {{(16 - 8 ){tru_dout_int8_14[8 -1]}},tru_dout_int8_14[7:0]}; 
NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(16 ),.SHIFT_WIDTH(2 )) int16_shiftright_su_15 (
   .data_in            (tdata_out_15[17:0])        //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int16_15[15:0])   //|> w
  );
//signed 
//unsigned

NV_NVDLA_HLS_shiftrightsu #(.IN_WIDTH(18 ),.OUT_WIDTH(8 ),.SHIFT_WIDTH(2 )) int8_shiftright_su_15 (
   .data_in            (tdata_out_15[17:0])        //|< w
  ,.shift_num          (cfg_truncate[1:0])         //|< w
  ,.data_out           (tru_dout_int8_15[7:0])     //|> w
  );
//signed 
//unsigned

assign  tru_dout_int8_ext_15[15:0] = {{(16 - 8 ){tru_dout_int8_15[8 -1]}},tru_dout_int8_15[7:0]}; 

assign  tru_dout_int16[255:0] = { tru_dout_int16_15, tru_dout_int16_14, tru_dout_int16_13, tru_dout_int16_12, tru_dout_int16_11, tru_dout_int16_10, tru_dout_int16_9, tru_dout_int16_8, tru_dout_int16_7, tru_dout_int16_6, tru_dout_int16_5, tru_dout_int16_4, tru_dout_int16_3, tru_dout_int16_2, tru_dout_int16_1, tru_dout_int16_0};

assign  tru_dout_int8_ext[255:0] = { tru_dout_int8_ext_15, tru_dout_int8_ext_14, tru_dout_int8_ext_13, tru_dout_int8_ext_12, tru_dout_int8_ext_11, tru_dout_int8_ext_10, tru_dout_int8_ext_9, tru_dout_int8_ext_8, tru_dout_int8_ext_7, tru_dout_int8_ext_6, tru_dout_int8_ext_5, tru_dout_int8_ext_4, tru_dout_int8_ext_3, tru_dout_int8_ext_2, tru_dout_int8_ext_1, tru_dout_int8_ext_0};

NV_NVDLA_CSC_PRA_CELL_pipe_p4 pipe_p4 (
   .nvdla_core_clk     (nvdla_core_clk)            //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)           //|< i
  ,.final_out_prdy     (final_out_prdy)            //|< w
  ,.tout_pvld          (tout_pvld)                 //|< w
  ,.tru_dout_int16     (tru_dout_int16[255:0])     //|< w
  ,.tru_dout_int8_ext  (tru_dout_int8_ext[255:0])  //|< w
  ,.final_out_pvld     (final_out_pvld)            //|> w
  ,.tout_prdy          (tout_prdy)                 //|> w
  ,.tru_data_out_int16 (tru_data_out_int16[255:0]) //|> w
  ,.tru_data_out_int8  (tru_data_out_int8[255:0])  //|> w
  );

assign  chn_dout[255:0] = (cfg_precision[1:0] == 1 ) ? tru_data_out_int16[255:0] :  tru_data_out_int8[255:0];

NV_NVDLA_CSC_PRA_CELL_pipe_p5 pipe_p5 (
   .nvdla_core_clk     (nvdla_core_clk)            //|< i
  ,.nvdla_core_rstn    (nvdla_core_rstn)           //|< i
  ,.chn_dout           (chn_dout[255:0])           //|< w
  ,.chn_out_prdy       (chn_out_prdy)              //|< w
  ,.final_out_pvld     (final_out_pvld)            //|< w
  ,.chn_data_out       (chn_data_out[255:0])       //|> w
  ,.chn_out_pvld       (chn_out_pvld)              //|> w
  ,.final_out_prdy     (final_out_prdy)            //|> w
  );

endmodule // NV_NVDLA_CSC_pra_cell



// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is chn_data_reg[255:0] (din_pvld,din_prdy) <= chn_data_in[255:0] (chn_in_pvld,chn_in_prdy)
// **************************************************************************************************************
module NV_NVDLA_CSC_PRA_CELL_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,chn_data_in
  ,chn_in_pvld
  ,din_prdy
  ,chn_data_reg
  ,chn_in_prdy
  ,din_pvld
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [255:0] chn_data_in;
input          chn_in_pvld;
input          din_prdy;
output [255:0] chn_data_reg;
output         chn_in_prdy;
output         din_pvld;
reg    [255:0] chn_data_reg;
reg            chn_in_prdy;
reg            din_pvld;
reg    [255:0] p1_pipe_data;
reg            p1_pipe_ready;
reg            p1_pipe_ready_bc;
reg            p1_pipe_valid;
reg            p1_skid_catch;
reg    [255:0] p1_skid_data;
reg    [255:0] p1_skid_pipe_data;
reg            p1_skid_pipe_ready;
reg            p1_skid_pipe_valid;
reg            p1_skid_ready;
reg            p1_skid_ready_flop;
reg            p1_skid_valid;
//## pipe (1) skid buffer
always @(
  chn_in_pvld
  or p1_skid_ready_flop
  or p1_skid_pipe_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = chn_in_pvld && p1_skid_ready_flop && !p1_skid_pipe_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_skid_pipe_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    chn_in_prdy <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_skid_pipe_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  chn_in_prdy <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? chn_data_in[255:0] : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or chn_in_pvld
  or p1_skid_valid
  or chn_data_in
  or p1_skid_data
  ) begin
  p1_skid_pipe_valid = (p1_skid_ready_flop)? chn_in_pvld : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_skid_pipe_data = (p1_skid_ready_flop)? chn_data_in[255:0] : p1_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (1) valid-ready-bubble-collapse
always @(
  p1_pipe_ready
  or p1_pipe_valid
  ) begin
  p1_pipe_ready_bc = p1_pipe_ready || !p1_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_valid <= 1'b0;
  end else begin
  p1_pipe_valid <= (p1_pipe_ready_bc)? p1_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && p1_skid_pipe_valid)? p1_skid_pipe_data : p1_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  p1_skid_pipe_ready = p1_pipe_ready_bc;
end
//## pipe (1) output
always @(
  p1_pipe_valid
  or din_prdy
  or p1_pipe_data
  ) begin
  din_pvld = p1_pipe_valid;
  p1_pipe_ready = din_prdy;
  chn_data_reg[255:0] = p1_pipe_data;
end
//## pipe (1) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p1_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (din_pvld^din_prdy^chn_in_pvld^chn_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (chn_in_pvld && !chn_in_prdy), (chn_in_pvld), (chn_in_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`endif
endmodule // NV_NVDLA_CSC_PRA_CELL_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is mdata_out[271:0] (mout_pvld,mout_prdy) <= mdout[271:0] (din_pvld,din_prdy)
// **************************************************************************************************************
module NV_NVDLA_CSC_PRA_CELL_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,din_pvld
  ,mdout
  ,mout_prdy
  ,din_prdy
  ,mdata_out
  ,mout_pvld
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          din_pvld;
input  [271:0] mdout;
input          mout_prdy;
output         din_prdy;
output [271:0] mdata_out;
output         mout_pvld;
reg            din_prdy;
reg    [271:0] mdata_out;
reg            mout_pvld;
reg    [271:0] p2_pipe_data;
reg            p2_pipe_ready;
reg            p2_pipe_ready_bc;
reg            p2_pipe_valid;
reg            p2_skid_catch;
reg    [271:0] p2_skid_data;
reg    [271:0] p2_skid_pipe_data;
reg            p2_skid_pipe_ready;
reg            p2_skid_pipe_valid;
reg            p2_skid_ready;
reg            p2_skid_ready_flop;
reg            p2_skid_valid;
//## pipe (2) skid buffer
always @(
  din_pvld
  or p2_skid_ready_flop
  or p2_skid_pipe_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = din_pvld && p2_skid_ready_flop && !p2_skid_pipe_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_skid_pipe_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    din_prdy <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_skid_pipe_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  din_prdy <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? mdout[271:0] : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or din_pvld
  or p2_skid_valid
  or mdout
  or p2_skid_data
  ) begin
  p2_skid_pipe_valid = (p2_skid_ready_flop)? din_pvld : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_skid_pipe_data = (p2_skid_ready_flop)? mdout[271:0] : p2_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (2) valid-ready-bubble-collapse
always @(
  p2_pipe_ready
  or p2_pipe_valid
  ) begin
  p2_pipe_ready_bc = p2_pipe_ready || !p2_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_valid <= 1'b0;
  end else begin
  p2_pipe_valid <= (p2_pipe_ready_bc)? p2_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_pipe_data <= (p2_pipe_ready_bc && p2_skid_pipe_valid)? p2_skid_pipe_data : p2_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p2_pipe_ready_bc
  ) begin
  p2_skid_pipe_ready = p2_pipe_ready_bc;
end
//## pipe (2) output
always @(
  p2_pipe_valid
  or mout_prdy
  or p2_pipe_data
  ) begin
  mout_pvld = p2_pipe_valid;
  p2_pipe_ready = mout_prdy;
  mdata_out[271:0] = p2_pipe_data;
end
//## pipe (2) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p2_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (mout_pvld^mout_prdy^din_pvld^din_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_4x (nvdla_core_clk, `ASSERT_RESET, (din_pvld && !din_prdy), (din_pvld), (din_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`endif
endmodule // NV_NVDLA_CSC_PRA_CELL_pipe_p2




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is tdata_out[287:0] (tout_pvld,tout_prdy) <= tdout[287:0] (mout_pvld,mout_prdy)
// **************************************************************************************************************
module NV_NVDLA_CSC_PRA_CELL_pipe_p3 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,mout_pvld
  ,tdout
  ,tout_prdy
  ,mout_prdy
  ,tdata_out
  ,tout_pvld
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          mout_pvld;
input  [287:0] tdout;
input          tout_prdy;
output         mout_prdy;
output [287:0] tdata_out;
output         tout_pvld;
reg            mout_prdy;
reg    [287:0] p3_pipe_data;
reg            p3_pipe_ready;
reg            p3_pipe_ready_bc;
reg            p3_pipe_valid;
reg            p3_skid_catch;
reg    [287:0] p3_skid_data;
reg    [287:0] p3_skid_pipe_data;
reg            p3_skid_pipe_ready;
reg            p3_skid_pipe_valid;
reg            p3_skid_ready;
reg            p3_skid_ready_flop;
reg            p3_skid_valid;
reg    [287:0] tdata_out;
reg            tout_pvld;
//## pipe (3) skid buffer
always @(
  mout_pvld
  or p3_skid_ready_flop
  or p3_skid_pipe_ready
  or p3_skid_valid
  ) begin
  p3_skid_catch = mout_pvld && p3_skid_ready_flop && !p3_skid_pipe_ready;  
  p3_skid_ready = (p3_skid_valid)? p3_skid_pipe_ready : !p3_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_skid_valid <= 1'b0;
    p3_skid_ready_flop <= 1'b1;
    mout_prdy <= 1'b1;
  end else begin
  p3_skid_valid <= (p3_skid_valid)? !p3_skid_pipe_ready : p3_skid_catch;
  p3_skid_ready_flop <= p3_skid_ready;
  mout_prdy <= p3_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_skid_data <= (p3_skid_catch)? tdout[287:0] : p3_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p3_skid_ready_flop
  or mout_pvld
  or p3_skid_valid
  or tdout
  or p3_skid_data
  ) begin
  p3_skid_pipe_valid = (p3_skid_ready_flop)? mout_pvld : p3_skid_valid; 
  // VCS sop_coverage_off start
  p3_skid_pipe_data = (p3_skid_ready_flop)? tdout[287:0] : p3_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (3) valid-ready-bubble-collapse
always @(
  p3_pipe_ready
  or p3_pipe_valid
  ) begin
  p3_pipe_ready_bc = p3_pipe_ready || !p3_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p3_pipe_valid <= 1'b0;
  end else begin
  p3_pipe_valid <= (p3_pipe_ready_bc)? p3_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p3_pipe_data <= (p3_pipe_ready_bc && p3_skid_pipe_valid)? p3_skid_pipe_data : p3_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p3_pipe_ready_bc
  ) begin
  p3_skid_pipe_ready = p3_pipe_ready_bc;
end
//## pipe (3) output
always @(
  p3_pipe_valid
  or tout_prdy
  or p3_pipe_data
  ) begin
  tout_pvld = p3_pipe_valid;
  p3_pipe_ready = tout_prdy;
  tdata_out[287:0] = p3_pipe_data;
end
//## pipe (3) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p3_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_5x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (tout_pvld^tout_prdy^mout_pvld^mout_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_6x (nvdla_core_clk, `ASSERT_RESET, (mout_pvld && !mout_prdy), (mout_pvld), (mout_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`endif
endmodule // NV_NVDLA_CSC_PRA_CELL_pipe_p3




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is {tru_data_out_int16[255:0],tru_data_out_int8[255:0]} (final_out_pvld,final_out_prdy) <= {tru_dout_int16[255:0],tru_dout_int8_ext[255:0]} (tout_pvld,tout_prdy)
// **************************************************************************************************************
module NV_NVDLA_CSC_PRA_CELL_pipe_p4 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,final_out_prdy
  ,tout_pvld
  ,tru_dout_int16
  ,tru_dout_int8_ext
  ,final_out_pvld
  ,tout_prdy
  ,tru_data_out_int16
  ,tru_data_out_int8
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          final_out_prdy;
input          tout_pvld;
input  [255:0] tru_dout_int16;
input  [255:0] tru_dout_int8_ext;
output         final_out_pvld;
output         tout_prdy;
output [255:0] tru_data_out_int16;
output [255:0] tru_data_out_int8;
reg            final_out_pvld;
reg    [511:0] p4_pipe_data;
reg            p4_pipe_ready;
reg            p4_pipe_ready_bc;
reg            p4_pipe_valid;
reg            p4_skid_catch;
reg    [511:0] p4_skid_data;
reg    [511:0] p4_skid_pipe_data;
reg            p4_skid_pipe_ready;
reg            p4_skid_pipe_valid;
reg            p4_skid_ready;
reg            p4_skid_ready_flop;
reg            p4_skid_valid;
reg            tout_prdy;
reg    [255:0] tru_data_out_int16;
reg    [255:0] tru_data_out_int8;
//## pipe (4) skid buffer
always @(
  tout_pvld
  or p4_skid_ready_flop
  or p4_skid_pipe_ready
  or p4_skid_valid
  ) begin
  p4_skid_catch = tout_pvld && p4_skid_ready_flop && !p4_skid_pipe_ready;  
  p4_skid_ready = (p4_skid_valid)? p4_skid_pipe_ready : !p4_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_skid_valid <= 1'b0;
    p4_skid_ready_flop <= 1'b1;
    tout_prdy <= 1'b1;
  end else begin
  p4_skid_valid <= (p4_skid_valid)? !p4_skid_pipe_ready : p4_skid_catch;
  p4_skid_ready_flop <= p4_skid_ready;
  tout_prdy <= p4_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_skid_data <= (p4_skid_catch)? {tru_dout_int16[255:0],tru_dout_int8_ext[255:0]} : p4_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p4_skid_ready_flop
  or tout_pvld
  or p4_skid_valid
  or tru_dout_int16
  or tru_dout_int8_ext
  or p4_skid_data
  ) begin
  p4_skid_pipe_valid = (p4_skid_ready_flop)? tout_pvld : p4_skid_valid; 
  // VCS sop_coverage_off start
  p4_skid_pipe_data = (p4_skid_ready_flop)? {tru_dout_int16[255:0],tru_dout_int8_ext[255:0]} : p4_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (4) valid-ready-bubble-collapse
always @(
  p4_pipe_ready
  or p4_pipe_valid
  ) begin
  p4_pipe_ready_bc = p4_pipe_ready || !p4_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p4_pipe_valid <= 1'b0;
  end else begin
  p4_pipe_valid <= (p4_pipe_ready_bc)? p4_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p4_pipe_data <= (p4_pipe_ready_bc && p4_skid_pipe_valid)? p4_skid_pipe_data : p4_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p4_pipe_ready_bc
  ) begin
  p4_skid_pipe_ready = p4_pipe_ready_bc;
end
//## pipe (4) output
always @(
  p4_pipe_valid
  or final_out_prdy
  or p4_pipe_data
  ) begin
  final_out_pvld = p4_pipe_valid;
  p4_pipe_ready = final_out_prdy;
  {tru_data_out_int16[255:0],tru_data_out_int8[255:0]} = p4_pipe_data;
end
//## pipe (4) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p4_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_7x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (final_out_pvld^final_out_prdy^tout_pvld^tout_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_8x (nvdla_core_clk, `ASSERT_RESET, (tout_pvld && !tout_prdy), (tout_pvld), (tout_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`endif
endmodule // NV_NVDLA_CSC_PRA_CELL_pipe_p4




// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is chn_data_out[255:0] (chn_out_pvld,chn_out_prdy) <= chn_dout[255:0] (final_out_pvld,final_out_prdy)
// **************************************************************************************************************
module NV_NVDLA_CSC_PRA_CELL_pipe_p5 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,chn_dout
  ,chn_out_prdy
  ,final_out_pvld
  ,chn_data_out
  ,chn_out_pvld
  ,final_out_prdy
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input  [255:0] chn_dout;
input          chn_out_prdy;
input          final_out_pvld;
output [255:0] chn_data_out;
output         chn_out_pvld;
output         final_out_prdy;
reg    [255:0] chn_data_out;
reg            chn_out_pvld;
reg            final_out_prdy;
reg    [255:0] p5_pipe_data;
reg            p5_pipe_ready;
reg            p5_pipe_ready_bc;
reg            p5_pipe_valid;
reg            p5_skid_catch;
reg    [255:0] p5_skid_data;
reg    [255:0] p5_skid_pipe_data;
reg            p5_skid_pipe_ready;
reg            p5_skid_pipe_valid;
reg            p5_skid_ready;
reg            p5_skid_ready_flop;
reg            p5_skid_valid;
//## pipe (5) skid buffer
always @(
  final_out_pvld
  or p5_skid_ready_flop
  or p5_skid_pipe_ready
  or p5_skid_valid
  ) begin
  p5_skid_catch = final_out_pvld && p5_skid_ready_flop && !p5_skid_pipe_ready;  
  p5_skid_ready = (p5_skid_valid)? p5_skid_pipe_ready : !p5_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p5_skid_valid <= 1'b0;
    p5_skid_ready_flop <= 1'b1;
    final_out_prdy <= 1'b1;
  end else begin
  p5_skid_valid <= (p5_skid_valid)? !p5_skid_pipe_ready : p5_skid_catch;
  p5_skid_ready_flop <= p5_skid_ready;
  final_out_prdy <= p5_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p5_skid_data <= (p5_skid_catch)? chn_dout[255:0] : p5_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p5_skid_ready_flop
  or final_out_pvld
  or p5_skid_valid
  or chn_dout
  or p5_skid_data
  ) begin
  p5_skid_pipe_valid = (p5_skid_ready_flop)? final_out_pvld : p5_skid_valid; 
  // VCS sop_coverage_off start
  p5_skid_pipe_data = (p5_skid_ready_flop)? chn_dout[255:0] : p5_skid_data;
  // VCS sop_coverage_off end
end
//## pipe (5) valid-ready-bubble-collapse
always @(
  p5_pipe_ready
  or p5_pipe_valid
  ) begin
  p5_pipe_ready_bc = p5_pipe_ready || !p5_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p5_pipe_valid <= 1'b0;
  end else begin
  p5_pipe_valid <= (p5_pipe_ready_bc)? p5_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p5_pipe_data <= (p5_pipe_ready_bc && p5_skid_pipe_valid)? p5_skid_pipe_data : p5_pipe_data;
  // VCS sop_coverage_off end
end
always @(
  p5_pipe_ready_bc
  ) begin
  p5_skid_pipe_ready = p5_pipe_ready_bc;
end
//## pipe (5) output
always @(
  p5_pipe_valid
  or chn_out_prdy
  or p5_pipe_data
  ) begin
  chn_out_pvld = p5_pipe_valid;
  p5_pipe_ready = chn_out_prdy;
  chn_data_out[255:0] = p5_pipe_data;
end
//## pipe (5) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p5_assert_clk = nvdla_core_clk;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_9x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (chn_out_pvld^chn_out_prdy^final_out_pvld^final_out_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  // VCS coverage off 
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_10x (nvdla_core_clk, `ASSERT_RESET, (final_out_pvld && !final_out_prdy), (final_out_pvld), (final_out_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
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
`endif
endmodule // NV_NVDLA_CSC_PRA_CELL_pipe_p5



