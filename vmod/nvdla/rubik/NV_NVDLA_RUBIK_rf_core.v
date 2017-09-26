// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_RUBIK_rf_core.v

module NV_NVDLA_RUBIK_rf_core (
   nvdla_core_clk      //|< i
  ,nvdla_core_rstn     //|< i
  ,dma_wr_data_rdy     //|< i
  ,pwrbus_ram_pd       //|< i
  ,reg2dp_in_precision //|< i
  ,reg2dp_rubik_mode   //|< i
  ,rf_rd_addr          //|< i
  ,rf_rd_done          //|< i
  ,rf_rd_mask          //|< i
  ,rf_rd_vld           //|< i
  ,rf_wr_addr          //|< i
  ,rf_wr_data          //|< i
  ,rf_wr_done          //|< i
  ,rf_wr_vld           //|< i
  ,dma_wr_data_pd      //|> o
  ,dma_wr_data_vld     //|> o
  ,rf_rd_rdy           //|> o
  ,rf_wr_rdy           //|> o
  );


input          nvdla_core_clk;
input          nvdla_core_rstn;
input   [31:0] pwrbus_ram_pd;

input           rf_wr_vld;
input           rf_wr_done;
input  [4:0]    rf_wr_addr;   //row address,increase one when write 64Bytes
input  [511:0]  rf_wr_data;                      
output          rf_wr_rdy;

input           rf_rd_vld; 
input           rf_rd_done; 
input  [4:0]    rf_rd_addr;   //column address,increase one when read 64Bytes
input  [11:0]   rf_rd_mask;   
output          rf_rd_rdy;

output           dma_wr_data_vld;
output  [513:0]  dma_wr_data_pd;
input            dma_wr_data_rdy;

input  [1:0]            reg2dp_rubik_mode;
input  [1:0]          reg2dp_in_precision;

reg            dma_wr_data_vld;
reg    [511:0] rd_data_raw_reg;
reg      [1:0] reg2dp_in_precision_drv2;
reg      [1:0] reg2dp_rubik_mode_drv2;
reg      [4:0] rf_rd_oaddr_d;
reg     [11:0] rf_rd_omask_d;
reg            rf_rd_osel_d;
reg            rf_rd_pop_d;
reg      [1:0] rf_rptr;
reg      [1:0] rf_wptr;
wire    [31:0] byte_mask_h;
wire    [31:0] byte_mask_l;
wire   [159:0] contract_rd_addr_shift;
wire   [511:0] contract_rd_data;
wire   [511:0] contract_wr_shift;
wire   [511:0] dma_wr_pd_data;
wire     [1:0] dma_wr_pd_mask;
wire           m_byte_data;
wire           m_contract;
wire           m_split;
wire   [159:0] merge16_rd_addr_shift;
wire   [511:0] merge16_rd_data;
wire   [511:0] merge16_wr_shift;
wire   [159:0] merge8_rd_addr_shift;
wire   [511:0] merge8_rd_data;
wire   [511:0] merge8_wr_shift;
wire   [159:0] merge_rd_addr_shift;
wire   [511:0] merge_rd_data;
wire   [511:0] merge_wr_shift;
wire           mon_rd_mask_hc;
wire           mon_rd_mask_lc;
wire           mon_rd_snum;
wire           mon_rd_snum1;
wire           mon_rd_snum2;
wire           mon_wr_snum;
wire           mon_wr_snum1;
wire           mon_wr_snum2;
wire   [159:0] ram_even_seq;
wire   [159:0] ram_gene_seq;
wire   [159:0] ram_halfh_seq;
wire   [159:0] ram_halfl_seq;
wire   [159:0] ram_odd_seq;
wire   [159:0] ram_rd_addr;
wire   [159:0] ram_rd_oaddr;
wire     [5:0] rd_addr_incr4;
wire     [4:0] rd_addr_tmp;
wire   [511:0] rd_data0_raw;
wire   [511:0] rd_data1_raw;
wire   [511:0] rd_data_raw;
wire   [511:0] rd_data_raw_tmp;
wire     [5:0] rd_omask_h;
wire     [5:0] rd_omask_l;
wire     [4:0] rd_shift_num;
wire     [4:0] rd_shift_num1;
wire     [4:0] rd_shift_num2;
wire           rf_empty;
wire           rf_full;
wire   [511:0] rf_rd_data;
wire     [4:0] rf_rd_oaddr;
wire           rf_rd_odone;
wire    [11:0] rf_rd_omask;
wire   [177:0] rf_rd_opd;
wire           rf_rd_ordy;
wire           rf_rd_osel;
wire           rf_rd_ovld;
wire   [177:0] rf_rd_pd;
wire           rf_rd_pop;
wire     [4:0] rf_wr_oaddr;
wire   [511:0] rf_wr_odata;
wire           rf_wr_odone;
wire   [517:0] rf_wr_opd;
wire           rf_wr_ordy;
wire           rf_wr_osel;
wire           rf_wr_ovld;
wire   [517:0] rf_wr_pd;
wire           rf_wr_pop;
wire   [159:0] split16_rd_addr_shift;
wire   [511:0] split16_rd_data;
wire   [511:0] split16_wr_shift;
wire   [159:0] split8_rd_addr_shift;
wire   [511:0] split8_rd_data;
wire   [511:0] split8_wr_shift;
wire   [159:0] split_rd_addr_shift;
wire   [511:0] split_rd_data;
wire   [511:0] split_wr_shift;
wire   [511:0] wr_data_comb16;
wire   [511:0] wr_data_comb8;
wire   [511:0] wr_data_shift;
wire     [4:0] wr_shift_num;
wire     [4:0] wr_shift_num1;
wire     [4:0] wr_shift_num2;

// synoff nets

// monitor nets

// debug nets

// tie high nets

// tie low nets

// no connect nets

// not all bits used nets

// todo nets

    
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_rubik_mode_drv2[1:0] <= {2{1'b0}};
  end else begin
  reg2dp_rubik_mode_drv2[1:0] <= reg2dp_rubik_mode[1:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_in_precision_drv2[1:0] <= {2{1'b0}};
  end else begin
  reg2dp_in_precision_drv2[1:0] <= reg2dp_in_precision[1:0];
  end
end

assign  m_contract  = reg2dp_rubik_mode_drv2[1:0] == 2'h0 ;
assign  m_split     = reg2dp_rubik_mode_drv2[1:0] == 2'h1 ;
//assign  m_merge     = reg2dp_rubik_mode_drv2[1:0] == NVDLA_RBK_D_MISC_CFG_0_RUBIK_MODE_MERGE;
assign  m_byte_data = reg2dp_in_precision_drv2[1:0] == 2'h0 ;

function [511:0] shift512_16b; //shift 512bits data with 16bits per one step
input [511:0] di;
input [4:0] snum;
reg [511:0] shf0;
reg [511:0] shf1;
reg [511:0] shf2;
reg [511:0] shf3;
begin
    shf0[511:0] = snum[4] ? {  di[255:0],  di[511:256]} :   di[511:0];
    shf1[511:0] = snum[3] ? {shf0[127:0],shf0[511:128]} : shf0[511:0];
    shf2[511:0] = snum[2] ? {shf1[63:0],shf1[511:64]} : shf1[511:0];
    shf3[511:0] = snum[1] ? {shf2[31:0],shf2[511:32]} : shf2[511:0];
    shift512_16b= snum[0] ? {shf3[15:0],shf3[511:16]} : shf3[511:0];
end
endfunction

function [159:0] shift160_5b; //shift 160bits ram addr with 5bits per one step 
input [159:0] di;
input [4:0] snum;
reg [159:0] shf0;
reg [159:0] shf1;
reg [159:0] shf2;
reg [159:0] shf3;
begin
    shf0[159:0] = snum[4] ? {  di[79:0],  di[159:80]} :   di[159:0];
    shf1[159:0] = snum[3] ? {shf0[39:0],shf0[159:40]} : shf0[159:0];
    shf2[159:0] = snum[2] ? {shf1[19:0],shf1[159:20]} : shf1[159:0];
    shf3[159:0] = snum[1] ? {shf2[9:0], shf2[159:10]} : shf2[159:0];
    shift160_5b = snum[0] ? {shf3[4:0], shf3[159:5]} : shf3[159:0];
end
endfunction

function [511:0] data_comb8;  //combine atomic0 's element0 with atomic1'element0 in int8 precision  
input [511:0] di;
reg [255:0] di0;
reg [255:0] di1;
begin
    di0 = di[255:0];
    di1 = di[511:256];
    data_comb8 = {di1[255:248], di0[255:248],di1[247:240], di0[247:240],
                  di1[239:232], di0[239:232],di1[231:224], di0[231:224],
                  di1[223:216], di0[223:216],di1[215:208], di0[215:208],
                  di1[207:200], di0[207:200],di1[199:192], di0[199:192], 
                  di1[191:184], di0[191:184],di1[183:176], di0[183:176],
                  di1[175:168], di0[175:168],di1[167:160], di0[167:160],
                  di1[159:152], di0[159:152],di1[151:144], di0[151:144], 
                  di1[143:136], di0[143:136],di1[135:128], di0[135:128],
                  di1[127:120], di0[127:120],di1[119:112], di0[119:112],
                  di1[111:104], di0[111:104],di1[103:96],  di0[103:96],
                  di1[95:88],   di0[95:88],  di1[87:80],   di0[87:80],
                  di1[79:72],   di0[79:72],  di1[71:64],   di0[71:64], 
                  di1[63:56],   di0[63:56],  di1[55:48],   di0[55:48], 
                  di1[47:40],   di0[47:40],  di1[39:32],   di0[39:32], 
                  di1[31:24],   di0[31:24],  di1[23:16],   di0[23:16], 
                  di1[15:8],    di0[15:8] ,  di1[7:0],     di0[7:0]}; 
end 
endfunction

function [511:0] data_comb16;  //combine atomic0 's element0 with atomic1'element0 in int16 precision  
input [511:0] di;
reg [255:0] di0;
reg [255:0] di1;
begin
    di0 = di[255:0];
    di1 = di[511:256];
    data_comb16 = {di1[255:240], di0[255:240],di1[239:224], di0[239:224],
                   di1[223:208], di0[223:208],di1[207:192], di0[207:192],
                   di1[191:176], di0[191:176],di1[175:160], di0[175:160],
                   di1[159:144], di0[159:144],di1[143:128], di0[143:128],
                   di1[127:112], di0[127:112],di1[111:96],  di0[111:96] ,
                   di1[95:80],   di0[95:80]  ,di1[79:64],   di0[79:64],
                   di1[63:48],   di0[63:48]  ,di1[47:32],   di0[47:32],
                   di1[31:16],   di0[31:16]  ,di1[15:0],    di0[15:0]};
end 
endfunction

function [511:0] data_recomb8;  //re-combine atomic0 's element0 with atomic1'element0 in int8 precision  
input  [511:0] di;
reg    [255:0] di1;
reg    [255:0] di0;
reg    [127:0] do3;
reg    [127:0] do2;
reg    [127:0] do1;
reg    [127:0] do0;
begin
    di0 =  di[255:0];
    di1 =  di[511:256];
    do3 = {di1[255:248],di1[239:232], 
           di1[223:216],di1[207:200],  
           di1[191:184],di1[175:168], 
           di1[159:152],di1[143:136], 
           di1[127:120],di1[111:104], 
           di1[95:88],  di1[79:72],   
           di1[63:56],  di1[47:40],   
           di1[31:24],  di1[15:8] };   
    do2 = {di1[247:240],di1[231:224],
           di1[215:208],di1[199:192], 
           di1[183:176],di1[167:160],
           di1[151:144],di1[135:128],
           di1[119:112],di1[103:96],
           di1[87:80],  di1[71:64], 
           di1[55:48],  di1[39:32], 
           di1[23:16],  di1[7:0]}; 
 
    do1 = {di0[255:248],di0[239:232], 
           di0[223:216],di0[207:200],  
           di0[191:184],di0[175:168], 
           di0[159:152],di0[143:136], 
           di0[127:120],di0[111:104], 
           di0[95:88],  di0[79:72],   
           di0[63:56],  di0[47:40],   
           di0[31:24],  di0[15:8] };   
    do0 = {di0[247:240],di0[231:224],
           di0[215:208],di0[199:192], 
           di0[183:176],di0[167:160],
           di0[151:144],di0[135:128],
           di0[119:112],di0[103:96],
           di0[87:80],  di0[71:64], 
           di0[55:48],  di0[39:32], 
           di0[23:16],  di0[7:0]}; 
   data_recomb8 = {do3,do1,do2,do0};
end 
endfunction

function [511:0] data_recomb16;  //re-combine atomic0 's element0 with atomic1'element0 in int16 precision  
input  [511:0] di;
reg    [255:0] di1;
reg    [255:0] di0;
reg    [127:0] do3;
reg    [127:0] do2;
reg    [127:0] do1;
reg    [127:0] do0;
begin
    di0 =  di[255:0];
    di1 =  di[511:256];
    do3 = {di1[255:240],di1[223:208],
           di1[191:176],di1[159:144],
           di1[127:112],di1[95:80]  ,
           di1[63:48]  ,di1[31:16]  };
    do2 = {di1[239:224],di1[207:192],
           di1[175:160],di1[143:128],
           di1[111:96] ,di1[79:64],
           di1[47:32]  ,di1[15:0]};
    
    do1 = {di0[255:240],di0[223:208],
           di0[191:176],di0[159:144],
           di0[127:112],di0[95:80]  ,
           di0[63:48]  ,di0[31:16]  };
    do0 = {di0[239:224],di0[207:192],
           di0[175:160],di0[143:128],
           di0[111:96] ,di0[79:64],
           di0[47:32]  ,di0[15:0]};
    data_recomb16 = {do3,do1,do2,do0};
end 
endfunction

function [255:0] data_mask; 
input [255:0] di;
input [31:0]  byte_mask;
reg   [31:0]  data_mask0; 
reg   [31:0]  data_mask1; 
reg   [31:0]  data_mask2; 
reg   [31:0]  data_mask3; 
reg   [31:0]  data_mask4; 
reg   [31:0]  data_mask5; 
reg   [31:0]  data_mask6; 
reg   [31:0]  data_mask7; 
begin
   data_mask0 = di[31:0]    & {{8{byte_mask[3]}}, {8{byte_mask[2]}}, {8{byte_mask[1]}}, {8{byte_mask[0]}}}; 
   data_mask1 = di[63:32]   & {{8{byte_mask[7]}}, {8{byte_mask[6]}}, {8{byte_mask[5]}}, {8{byte_mask[4]}}}; 
   data_mask2 = di[95:64]   & {{8{byte_mask[11]}},{8{byte_mask[10]}},{8{byte_mask[9]}}, {8{byte_mask[8]}}}; 
   data_mask3 = di[127:96]  & {{8{byte_mask[15]}},{8{byte_mask[14]}},{8{byte_mask[13]}},{8{byte_mask[12]}}}; 
   data_mask4 = di[159:128] & {{8{byte_mask[19]}},{8{byte_mask[18]}},{8{byte_mask[17]}},{8{byte_mask[16]}}}; 
   data_mask5 = di[191:160] & {{8{byte_mask[23]}},{8{byte_mask[22]}},{8{byte_mask[21]}},{8{byte_mask[20]}}}; 
   data_mask6 = di[223:192] & {{8{byte_mask[27]}},{8{byte_mask[26]}},{8{byte_mask[25]}},{8{byte_mask[24]}}}; 
   data_mask7 = di[255:224] & {{8{byte_mask[31]}},{8{byte_mask[30]}},{8{byte_mask[29]}},{8{byte_mask[28]}}};
   data_mask  = {data_mask7,data_mask6,data_mask5,data_mask4,data_mask3,data_mask2,data_mask1,data_mask0}; 
end
endfunction

//write data shift
assign  wr_data_comb8  = data_comb8(rf_wr_data[511:0]);
assign  wr_data_comb16 = data_comb16(rf_wr_data[511:0]);

assign  {mon_wr_snum, wr_shift_num[4:0] } = 6'h20-rf_wr_addr;
assign  {mon_wr_snum1,wr_shift_num1[4:0]} = 6'h20-{rf_wr_addr[4:1],1'b0};
assign  {mon_wr_snum2,wr_shift_num2[4:0]} = 6'h20-{rf_wr_addr[3:0],1'b0};

assign  merge8_wr_shift[511:0]  = shift512_16b(rf_wr_data[511:0],wr_shift_num);     //merge int8 
assign  merge16_wr_shift[511:0] = shift512_16b(rf_wr_data[511:0],wr_shift_num1);
assign  merge_wr_shift[511:0]   = !m_byte_data ? merge16_wr_shift : merge8_wr_shift;

assign  split8_wr_shift[511:0]  = shift512_16b(wr_data_comb8,wr_shift_num);     //split int8 
assign  split16_wr_shift[511:0] = shift512_16b(wr_data_comb16,wr_shift_num2);
assign  split_wr_shift[511:0]   = !m_byte_data ? split16_wr_shift : split8_wr_shift;
 
assign  contract_wr_shift[511:0]= rf_wr_addr[2] ? {rf_wr_data[255:0],rf_wr_data[511:256]} : rf_wr_data[511:0];
assign  wr_data_shift[511:0]    = m_contract ? contract_wr_shift : m_split ? split_wr_shift : merge_wr_shift ;

assign  rf_wr_pd[517:0]         = {rf_wr_done,rf_wr_addr[4:0],wr_data_shift[511:0]};

NV_NVDLA_RUBIK_RF_CORE_pipe_p1 pipe_p1 (
   .nvdla_core_clk  (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)         //|< i
  ,.rf_wr_ordy      (rf_wr_ordy)              //|< w
  ,.rf_wr_pd        (rf_wr_pd[517:0])         //|< w
  ,.rf_wr_vld       (rf_wr_vld)               //|< i
  ,.rf_wr_opd       (rf_wr_opd[517:0])        //|> w
  ,.rf_wr_ovld      (rf_wr_ovld)              //|> w
  ,.rf_wr_rdy       (rf_wr_rdy)               //|> o
  );

assign  rf_wr_ordy  = ~rf_full; 
assign  rf_wr_pop   = rf_wr_ovld & rf_wr_ordy;
assign  rf_wr_odone = rf_wr_pop & rf_wr_opd[517];
assign  rf_wr_oaddr = rf_wr_opd[516:512];
assign  rf_wr_odata = rf_wr_opd[511:0];

assign  rf_wr_osel  = rf_wptr[0];
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rf_wptr[1:0] <= {2{1'b0}};
  end else begin
    if (rf_wr_odone) 
        rf_wptr[1:0] <= rf_wptr[1:0] + 1;
  end
end

////////////////rf status////////////////////
assign  rf_empty  = rf_wptr[1:0]==rf_rptr[1:0];
assign  rf_full   = (rf_wptr[1]^rf_rptr[1]) & (rf_wptr[0]==rf_rptr[0]);

//read sram address shift
assign  ram_gene_seq[159:0] = {5'h1f,5'h1e,5'h1d,5'h1c,5'h1b,5'h1a,5'h19,5'h18,
                               5'h17,5'h16,5'h15,5'h14,5'h13,5'h12,5'h11,5'h10,
                               5'h0f,5'h0e,5'h0d,5'h0c,5'h0b,5'h0a,5'h09,5'h08,
                               5'h07,5'h06,5'h05,5'h04,5'h03,5'h02,5'h01,5'h00};

assign  ram_even_seq[159:0] = {5'h1e,5'h1e,5'h1c,5'h1c,5'h1a,5'h1a,5'h18,5'h18,
                               5'h16,5'h16,5'h14,5'h14,5'h12,5'h12,5'h10,5'h10,
                               5'h0e,5'h0e,5'h0c,5'h0c,5'h0a,5'h0a,5'h08,5'h08,
                               5'h06,5'h06,5'h04,5'h04,5'h02,5'h02,5'h00,5'h00};

assign  ram_odd_seq[159:0]  = {5'h1f,5'h1f,5'h1d,5'h1d,5'h1b,5'h1b,5'h19,5'h19,
                               5'h17,5'h17,5'h15,5'h15,5'h13,5'h13,5'h11,5'h11,
                               5'h0f,5'h0f,5'h0d,5'h0d,5'h0b,5'h0b,5'h09,5'h09,
                               5'h07,5'h07,5'h05,5'h05,5'h03,5'h03,5'h01,5'h01};
                               
assign  ram_halfl_seq[159:0]= {5'h0f,5'h0f,5'h0e,5'h0e,5'h0d,5'h0d,5'h0c,5'h0c,
                               5'h0b,5'h0b,5'h0a,5'h0a,5'h09,5'h09,5'h08,5'h08,
                               5'h07,5'h07,5'h06,5'h06,5'h05,5'h05,5'h04,5'h04,
                               5'h03,5'h03,5'h02,5'h02,5'h01,5'h01,5'h00,5'h00};

assign  ram_halfh_seq[159:0]= {5'h1f,5'h1f,5'h1e,5'h1e,5'h1d,5'h1d,5'h1c,5'h1c,
                               5'h1b,5'h1b,5'h1a,5'h1a,5'h19,5'h19,5'h18,5'h18,
                               5'h17,5'h17,5'h16,5'h16,5'h15,5'h15,5'h14,5'h14,
                               5'h13,5'h13,5'h12,5'h12,5'h11,5'h11,5'h10,5'h10};
 
assign  {mon_rd_snum, rd_shift_num[4:0] } = 6'h20-rf_rd_addr;
assign  {mon_rd_snum1,rd_shift_num1[4:0]} = 6'h20-{rf_rd_addr[4:1],1'b0};
assign  {mon_rd_snum2,rd_shift_num2[4:0]} = 6'h20-{rf_rd_addr[3:0],1'b0};

assign  merge8_rd_addr_shift[159:0]  = shift160_5b(ram_gene_seq,rd_shift_num);
assign  merge16_rd_addr_shift[159:0] = rf_rd_addr[4] ? shift160_5b(ram_odd_seq,rd_shift_num2)  : shift160_5b(ram_even_seq,rd_shift_num2);
assign  merge_rd_addr_shift[159:0]   = !m_byte_data ? merge16_rd_addr_shift : merge8_rd_addr_shift;

assign  split8_rd_addr_shift[159:0]  = shift160_5b(ram_gene_seq,rd_shift_num);
assign  split16_rd_addr_shift[159:0] = rf_rd_addr[0] ? shift160_5b(ram_halfh_seq,rd_shift_num1) : shift160_5b(ram_halfl_seq,rd_shift_num1);
assign  split_rd_addr_shift[159:0]   = !m_byte_data ? split16_rd_addr_shift : split8_rd_addr_shift;

assign  rd_addr_tmp[4:0]   = rf_rd_addr[4:3] + {rf_rd_addr[1:0],3'h0};
assign  rd_addr_incr4[5:0] = rd_addr_tmp[4:0] + 4'h4;
assign  contract_rd_addr_shift[159:0]      = ~rf_rd_addr[2] ? {{16{rd_addr_incr4[4:0]}}, {16{rd_addr_tmp}}} : {{16{rd_addr_tmp}}, {16{rd_addr_incr4[4:0]}}}; 

assign  ram_rd_addr[159:0] = m_contract ? contract_rd_addr_shift : m_split ? split_rd_addr_shift : merge_rd_addr_shift ;

assign  rf_rd_pd[177:0]    = {rf_rd_done,rf_rd_mask[11:0],rf_rd_addr[4:0],ram_rd_addr[159:0]};

NV_NVDLA_RUBIK_RF_CORE_pipe_p2 pipe_p2 (
   .nvdla_core_clk  (nvdla_core_clk)          //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)         //|< i
  ,.rf_rd_ordy      (rf_rd_ordy)              //|< w
  ,.rf_rd_pd        (rf_rd_pd[177:0])         //|< w
  ,.rf_rd_vld       (rf_rd_vld)               //|< i
  ,.rf_rd_opd       (rf_rd_opd[177:0])        //|> w
  ,.rf_rd_ovld      (rf_rd_ovld)              //|> w
  ,.rf_rd_rdy       (rf_rd_rdy)               //|> o
  );

assign  rf_rd_ordy  = dma_wr_data_rdy & ~rf_empty;  
assign  rf_rd_pop   = rf_rd_ovld & rf_rd_ordy;
assign  rf_rd_odone = rf_rd_pop & rf_rd_opd[177];
assign  rf_rd_omask = rf_rd_opd[176:165];
assign  rf_rd_oaddr = rf_rd_opd[164:160];
assign  ram_rd_oaddr= rf_rd_opd[159:0];

assign  rf_rd_osel  = rf_rptr[0];
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rf_rptr[1:0] <= {2{1'b0}};
  end else begin
    if (rf_rd_odone)
        rf_rptr[1:0] <= rf_rptr[1:0]+1;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rf_rd_pop_d <= 1'b0;
  end else begin
  rf_rd_pop_d <= rf_rd_pop;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rf_rd_osel_d <= 1'b0;
  end else begin
  rf_rd_osel_d <= rf_rd_osel;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rf_rd_oaddr_d[4:0] <= {5{1'b0}};
  end else begin
  rf_rd_oaddr_d[4:0] <= dma_wr_data_rdy ? rf_rd_oaddr[4:0]  : rf_rd_oaddr_d[4:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rf_rd_omask_d[11:0] <= {12{1'b0}};
  end else begin
  rf_rd_omask_d[11:0] <= dma_wr_data_rdy ? rf_rd_omask[11:0] : rf_rd_omask_d[11:0];
  end
end

assign  rd_data_raw_tmp[511:0] = rf_rd_osel_d ? rd_data1_raw[511:0] : rd_data0_raw[511:0];
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_data_raw_reg[511:0] <= {512{1'b0}};
  end else begin
    if (rf_rd_pop_d)
        rd_data_raw_reg[511:0] <= rd_data_raw_tmp[511:0];
  end
end
assign  rd_data_raw[511:0] = rf_rd_pop_d & dma_wr_data_rdy ? rd_data_raw_tmp[511:0] : rd_data_raw_reg[511:0];


//read data shift
assign  merge8_rd_data[511:0]  = shift512_16b(rd_data_raw,rf_rd_oaddr_d);
assign  merge16_rd_data[511:0] = shift512_16b(rd_data_raw,{rf_rd_oaddr_d[3:0],1'b0});
assign  merge_rd_data[511:0]   = !m_byte_data ? data_recomb16(merge16_rd_data) : data_recomb8(merge8_rd_data);

assign  split8_rd_data[511:0]  = shift512_16b(rd_data_raw,rf_rd_oaddr_d);
assign  split16_rd_data[511:0] = shift512_16b(rd_data_raw,{rf_rd_oaddr_d[4:1],1'b0});
assign  split_rd_data[511:0]   = !m_byte_data ? split16_rd_data : split8_rd_data;
 
assign  contract_rd_data[511:0]= rf_rd_oaddr_d[2] ? {rd_data_raw[255:0],rd_data_raw[511:256]} : rd_data_raw[511:0];
 
assign  rf_rd_data[511:0]  = m_contract ? contract_rd_data : m_split ? split_rd_data : merge_rd_data ;

//write rf rdata to dma data buffer 
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dma_wr_data_vld <= 1'b0;
  end else begin
    if (rf_rd_pop)
        dma_wr_data_vld <=1'b1;
    else if (dma_wr_data_vld & dma_wr_data_rdy) 
        dma_wr_data_vld <=1'b0;
  end
end

assign  {mon_rd_mask_hc,rd_omask_h[5:0]} = 6'h20-rf_rd_omask_d[11:6];
assign  {mon_rd_mask_lc,rd_omask_l[5:0]} = 6'h20-rf_rd_omask_d[5:0];

assign  byte_mask_h[31:0] = 32'hffffffff >> rd_omask_h; 
assign  byte_mask_l[31:0] = 32'hffffffff >> rd_omask_l;

assign  dma_wr_pd_data[511:0]= {data_mask(rf_rd_data[511:256],byte_mask_h[31:0]),data_mask(rf_rd_data[255:0],byte_mask_l[31:0])};

assign  dma_wr_pd_mask[1:0] = {|rf_rd_omask_d[11:6],|rf_rd_omask_d[5:0]}; 

assign  dma_wr_data_pd[513:0] = {dma_wr_pd_mask,dma_wr_pd_data};

//register file 0 : contain 32 rams,one ram is 32x16
nv_ram_rws_32x16 rubik_rf0_ram0 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[4:0])       //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[15:0])      //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[15:0])       //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram1 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[9:5])       //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[31:16])     //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[31:16])      //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram2 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[14:10])     //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[47:32])     //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[47:32])      //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram3 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[19:15])     //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[63:48])     //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[63:48])      //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram4 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[24:20])     //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[79:64])     //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[79:64])      //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram5 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[29:25])     //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[95:80])     //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[95:80])      //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram6 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[34:30])     //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[111:96])    //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[111:96])     //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram7 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[39:35])     //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[127:112])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[127:112])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram8 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[44:40])     //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[143:128])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[143:128])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram9 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[49:45])     //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[159:144])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[159:144])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram10 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[54:50])     //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[175:160])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[175:160])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram11 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[59:55])     //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[191:176])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[191:176])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram12 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[64:60])     //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[207:192])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[207:192])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram13 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[69:65])     //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[223:208])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[223:208])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram14 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[74:70])     //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[239:224])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[239:224])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram15 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[79:75])     //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[255:240])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[255:240])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram16 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[84:80])     //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[271:256])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[271:256])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram17 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[89:85])     //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[287:272])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[287:272])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram18 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[94:90])     //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[303:288])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[303:288])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram19 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[99:95])     //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[319:304])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[319:304])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram20 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[104:100])   //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[335:320])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[335:320])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram21 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[109:105])   //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[351:336])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[351:336])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram22 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[114:110])   //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[367:352])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[367:352])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram23 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[119:115])   //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[383:368])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[383:368])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram24 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[124:120])   //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[399:384])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[399:384])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram25 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[129:125])   //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[415:400])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[415:400])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram26 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[134:130])   //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[431:416])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[431:416])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram27 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[139:135])   //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[447:432])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[447:432])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram28 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[144:140])   //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[463:448])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[463:448])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram29 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[149:145])   //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[479:464])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[479:464])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram30 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[154:150])   //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[495:480])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[495:480])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf0_ram31 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[159:155])   //|< w
  ,.re              (~rf_rd_osel & rf_rd_pop) //|< ?
  ,.dout            (rd_data0_raw[511:496])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (~rf_wr_osel & rf_wr_pop) //|< ?
  ,.di              (rf_wr_odata[511:496])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );


//register file 1 : contain 32 rams,one ram is 32x16
nv_ram_rws_32x16 rubik_rf1_ram0 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[4:0])       //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[15:0])      //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[15:0])       //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram1 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[9:5])       //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[31:16])     //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[31:16])      //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram2 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[14:10])     //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[47:32])     //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[47:32])      //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram3 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[19:15])     //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[63:48])     //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[63:48])      //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram4 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[24:20])     //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[79:64])     //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[79:64])      //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram5 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[29:25])     //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[95:80])     //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[95:80])      //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram6 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[34:30])     //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[111:96])    //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[111:96])     //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram7 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[39:35])     //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[127:112])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[127:112])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram8 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[44:40])     //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[143:128])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[143:128])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram9 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[49:45])     //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[159:144])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[159:144])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram10 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[54:50])     //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[175:160])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[175:160])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram11 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[59:55])     //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[191:176])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[191:176])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram12 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[64:60])     //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[207:192])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[207:192])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram13 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[69:65])     //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[223:208])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[223:208])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram14 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[74:70])     //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[239:224])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[239:224])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram15 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[79:75])     //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[255:240])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[255:240])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram16 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[84:80])     //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[271:256])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[271:256])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram17 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[89:85])     //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[287:272])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[287:272])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram18 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[94:90])     //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[303:288])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[303:288])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram19 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[99:95])     //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[319:304])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[319:304])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram20 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[104:100])   //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[335:320])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[335:320])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram21 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[109:105])   //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[351:336])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[351:336])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram22 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[114:110])   //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[367:352])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[367:352])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram23 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[119:115])   //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[383:368])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[383:368])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram24 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[124:120])   //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[399:384])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[399:384])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram25 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[129:125])   //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[415:400])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[415:400])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram26 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[134:130])   //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[431:416])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[431:416])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram27 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[139:135])   //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[447:432])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[447:432])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram28 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[144:140])   //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[463:448])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[463:448])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram29 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[149:145])   //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[479:464])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[479:464])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram30 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[154:150])   //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[495:480])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[495:480])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );

nv_ram_rws_32x16 rubik_rf1_ram31 (
   .clk             (nvdla_core_clk)          //|< i
  ,.ra              (ram_rd_oaddr[159:155])   //|< w
  ,.re              (rf_rd_osel & rf_rd_pop)  //|< ?
  ,.dout            (rd_data1_raw[511:496])   //|> w
  ,.wa              (rf_wr_oaddr[4:0])        //|< w
  ,.we              (rf_wr_osel & rf_wr_pop)  //|< ?
  ,.di              (rf_wr_odata[511:496])    //|< w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0])     //|< i
  );



//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    reg funcpoint_cover_off;
    initial begin
        if ( $test$plusargs( "cover_off" ) ) begin
            funcpoint_cover_off = 1'b1;
        end else begin
            funcpoint_cover_off = 1'b0;
        end
    end

    property rubik_rf_core__wr_rf_full__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        rf_wr_ovld & ~rf_wr_ordy;
    endproperty
    // Cover 0 : "rf_wr_ovld & ~rf_wr_ordy"
    FUNCPOINT_rubik_rf_core__wr_rf_full__0_COV : cover property (rubik_rf_core__wr_rf_full__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property rubik_rf_core__rd_rf_empty__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((rf_rd_ovld) && nvdla_core_rstn) |-> (dma_wr_data_rdy & rf_empty);
    endproperty
    // Cover 1 : "dma_wr_data_rdy & rf_empty"
    FUNCPOINT_rubik_rf_core__rd_rf_empty__1_COV : cover property (rubik_rf_core__rd_rf_empty__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property rubik_rf_core__push_rf_rdata_block__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        rf_rd_pop_d & ~dma_wr_data_rdy;
    endproperty
    // Cover 2 : "rf_rd_pop_d & ~dma_wr_data_rdy"
    FUNCPOINT_rubik_rf_core__push_rf_rdata_block__2_COV : cover property (rubik_rf_core__push_rf_rdata_block__2_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_RUBIK_rf_core



// **************************************************************************************************************
// Generated by ::pipe -m -bc -is rf_wr_opd[517:0] (rf_wr_ovld,rf_wr_ordy) <= rf_wr_pd[517:0] (rf_wr_vld,rf_wr_rdy)
// **************************************************************************************************************
module NV_NVDLA_RUBIK_RF_CORE_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,rf_wr_ordy
  ,rf_wr_pd
  ,rf_wr_vld
  ,rf_wr_opd
  ,rf_wr_ovld
  ,rf_wr_rdy
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          rf_wr_ordy;
input  [517:0] rf_wr_pd;
input          rf_wr_vld;
output [517:0] rf_wr_opd;
output         rf_wr_ovld;
output         rf_wr_rdy;
reg    [517:0] p1_pipe_data;
reg    [517:0] p1_pipe_rand_data;
reg            p1_pipe_rand_ready;
reg            p1_pipe_rand_valid;
reg            p1_pipe_ready;
reg            p1_pipe_ready_bc;
reg            p1_pipe_valid;
reg            p1_skid_catch;
reg    [517:0] p1_skid_data;
reg    [517:0] p1_skid_pipe_data;
reg            p1_skid_pipe_ready;
reg            p1_skid_pipe_valid;
reg            p1_skid_ready;
reg            p1_skid_ready_flop;
reg            p1_skid_valid;
reg    [517:0] rf_wr_opd;
reg            rf_wr_ovld;
reg            rf_wr_rdy;
//## pipe (1) randomizer
`ifndef SYNTHESIS
reg p1_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p1_pipe_rand_active
  or 
     `endif
     rf_wr_vld
  or p1_pipe_rand_ready
  or rf_wr_pd
  ) begin
  `ifdef SYNTHESIS
  p1_pipe_rand_valid = rf_wr_vld;
  rf_wr_rdy = p1_pipe_rand_ready;
  p1_pipe_rand_data = rf_wr_pd[517:0];
  `else
  // VCS coverage off
  p1_pipe_rand_valid = (p1_pipe_rand_active)? 1'b0 : rf_wr_vld;
  rf_wr_rdy = (p1_pipe_rand_active)? 1'b0 : p1_pipe_rand_ready;
  p1_pipe_rand_data = (p1_pipe_rand_active)?  'bx : rf_wr_pd[517:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p1_pipe_stall_cycles;
integer p1_pipe_stall_probability;
integer p1_pipe_stall_cycles_min;
integer p1_pipe_stall_cycles_max;
initial begin
  p1_pipe_stall_cycles = 0;
  p1_pipe_stall_probability = 0;
  p1_pipe_stall_cycles_min = 1;
  p1_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_RUBIK_rf_core_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p1_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_RUBIK_rf_core_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p1_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_RUBIK_rf_core_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p1_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_RUBIK_rf_core_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p1_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_RUBIK_rf_core_pipe_stall_probability" ) ) p1_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_RUBIK_rf_core_pipe_stall_cycles_min"  ) ) p1_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_RUBIK_rf_core_pipe_stall_cycles_max"  ) ) p1_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p1_pipe_rand_enable;
reg p1_pipe_rand_poised;
always @(
  p1_pipe_stall_cycles
  or p1_pipe_stall_probability
  or rf_wr_vld
  ) begin
  p1_pipe_rand_active = p1_pipe_stall_cycles != 0;
  p1_pipe_rand_enable = p1_pipe_stall_probability != 0;
  p1_pipe_rand_poised = p1_pipe_rand_enable && !p1_pipe_rand_active && rf_wr_vld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p1_pipe_rand_poised) begin
    if (p1_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p1_pipe_stall_cycles <= prand_inst1(p1_pipe_stall_cycles_min, p1_pipe_stall_cycles_max);
    end
  end else if (p1_pipe_rand_active) begin
    p1_pipe_stall_cycles <= p1_pipe_stall_cycles - 1;
  end else begin
    p1_pipe_stall_cycles <= 0;
  end
  end
end

`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed0;
reg prand_initialized0;
reg prand_no_rollpli0;
`endif
`endif
`endif

function [31:0] prand_inst0;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst0 = min;
`else
`ifdef SYNTHESIS
        prand_inst0 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized0 !== 1'b1) begin
            prand_no_rollpli0 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli0)
                prand_local_seed0 = {$prand_get_seed(0), 16'b0};
            prand_initialized0 = 1'b1;
        end
        if (prand_no_rollpli0) begin
            prand_inst0 = min;
        end else begin
            diff = max - min + 1;
            prand_inst0 = min + prand_local_seed0[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed0 = prand_local_seed0 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst0 = min;
`else
        prand_inst0 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed1;
reg prand_initialized1;
reg prand_no_rollpli1;
`endif
`endif
`endif

function [31:0] prand_inst1;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst1 = min;
`else
`ifdef SYNTHESIS
        prand_inst1 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized1 !== 1'b1) begin
            prand_no_rollpli1 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli1)
                prand_local_seed1 = {$prand_get_seed(1), 16'b0};
            prand_initialized1 = 1'b1;
        end
        if (prand_no_rollpli1) begin
            prand_inst1 = min;
        end else begin
            diff = max - min + 1;
            prand_inst1 = min + prand_local_seed1[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed1 = prand_local_seed1 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst1 = min;
`else
        prand_inst1 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction

`endif
// VCS coverage on
//## pipe (1) skid buffer
always @(
  p1_pipe_rand_valid
  or p1_skid_ready_flop
  or p1_skid_pipe_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = p1_pipe_rand_valid && p1_skid_ready_flop && !p1_skid_pipe_ready;  
  p1_skid_ready = (p1_skid_valid)? p1_skid_pipe_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    p1_pipe_rand_ready <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_skid_pipe_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  p1_pipe_rand_ready <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? p1_pipe_rand_data : p1_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or p1_pipe_rand_valid
  or p1_skid_valid
  or p1_pipe_rand_data
  or p1_skid_data
  ) begin
  p1_skid_pipe_valid = (p1_skid_ready_flop)? p1_pipe_rand_valid : p1_skid_valid; 
  // VCS sop_coverage_off start
  p1_skid_pipe_data = (p1_skid_ready_flop)? p1_pipe_rand_data : p1_skid_data;
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
  or rf_wr_ordy
  or p1_pipe_data
  ) begin
  rf_wr_ovld = p1_pipe_valid;
  p1_pipe_ready = rf_wr_ordy;
  rf_wr_opd[517:0] = p1_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (rf_wr_ovld^rf_wr_ordy^rf_wr_vld^rf_wr_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (rf_wr_vld && !rf_wr_rdy), (rf_wr_vld), (rf_wr_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_RUBIK_RF_CORE_pipe_p1




// **************************************************************************************************************
// Generated by ::pipe -m -bc -is rf_rd_opd[177:0] (rf_rd_ovld,rf_rd_ordy) <= rf_rd_pd[177:0] (rf_rd_vld,rf_rd_rdy)
// **************************************************************************************************************
module NV_NVDLA_RUBIK_RF_CORE_pipe_p2 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,rf_rd_ordy
  ,rf_rd_pd
  ,rf_rd_vld
  ,rf_rd_opd
  ,rf_rd_ovld
  ,rf_rd_rdy
  );
input          nvdla_core_clk;
input          nvdla_core_rstn;
input          rf_rd_ordy;
input  [177:0] rf_rd_pd;
input          rf_rd_vld;
output [177:0] rf_rd_opd;
output         rf_rd_ovld;
output         rf_rd_rdy;
reg    [177:0] p2_pipe_data;
reg    [177:0] p2_pipe_rand_data;
reg            p2_pipe_rand_ready;
reg            p2_pipe_rand_valid;
reg            p2_pipe_ready;
reg            p2_pipe_ready_bc;
reg            p2_pipe_valid;
reg            p2_skid_catch;
reg    [177:0] p2_skid_data;
reg    [177:0] p2_skid_pipe_data;
reg            p2_skid_pipe_ready;
reg            p2_skid_pipe_valid;
reg            p2_skid_ready;
reg            p2_skid_ready_flop;
reg            p2_skid_valid;
reg    [177:0] rf_rd_opd;
reg            rf_rd_ovld;
reg            rf_rd_rdy;
//## pipe (2) randomizer
`ifndef SYNTHESIS
reg p2_pipe_rand_active;
`endif
always @(
  `ifndef SYNTHESIS
  p2_pipe_rand_active
  or 
     `endif
     rf_rd_vld
  or p2_pipe_rand_ready
  or rf_rd_pd
  ) begin
  `ifdef SYNTHESIS
  p2_pipe_rand_valid = rf_rd_vld;
  rf_rd_rdy = p2_pipe_rand_ready;
  p2_pipe_rand_data = rf_rd_pd[177:0];
  `else
  // VCS coverage off
  p2_pipe_rand_valid = (p2_pipe_rand_active)? 1'b0 : rf_rd_vld;
  rf_rd_rdy = (p2_pipe_rand_active)? 1'b0 : p2_pipe_rand_ready;
  p2_pipe_rand_data = (p2_pipe_rand_active)?  'bx : rf_rd_pd[177:0];
  // VCS coverage on
  `endif
end
`ifndef SYNTHESIS
// VCS coverage off
//// randomization init   
integer p2_pipe_stall_cycles;
integer p2_pipe_stall_probability;
integer p2_pipe_stall_cycles_min;
integer p2_pipe_stall_cycles_max;
initial begin
  p2_pipe_stall_cycles = 0;
  p2_pipe_stall_probability = 0;
  p2_pipe_stall_cycles_min = 1;
  p2_pipe_stall_cycles_max = 10;
`ifndef SYNTH_LEVEL1_COMPILE
  if      ( $value$plusargs( "NV_NVDLA_RUBIK_rf_core_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  else if ( $value$plusargs(    "default_pipe_rand_probability=%d",  p2_pipe_stall_probability ) ) ; // deprecated
  if      ( $value$plusargs( "NV_NVDLA_RUBIK_rf_core_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  else if ( $value$plusargs(    "default_pipe_stall_probability=%d", p2_pipe_stall_probability ) ) ; 
  if      ( $value$plusargs( "NV_NVDLA_RUBIK_rf_core_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_min=%d",  p2_pipe_stall_cycles_min  ) ) ;
  if      ( $value$plusargs( "NV_NVDLA_RUBIK_rf_core_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
  else if ( $value$plusargs(    "default_pipe_stall_cycles_max=%d",  p2_pipe_stall_cycles_max  ) ) ;
`endif
end
// randomization globals
`ifndef SYNTH_LEVEL1_COMPILE
`ifdef SIMTOP_RANDOMIZE_STALLS
always @( `SIMTOP_RANDOMIZE_STALLS.global_stall_event ) begin
  if ( ! $test$plusargs( "NV_NVDLA_RUBIK_rf_core_pipe_stall_probability" ) ) p2_pipe_stall_probability = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_probability;
  if ( ! $test$plusargs( "NV_NVDLA_RUBIK_rf_core_pipe_stall_cycles_min"  ) ) p2_pipe_stall_cycles_min  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_min;
  if ( ! $test$plusargs( "NV_NVDLA_RUBIK_rf_core_pipe_stall_cycles_max"  ) ) p2_pipe_stall_cycles_max  = `SIMTOP_RANDOMIZE_STALLS.global_stall_pipe_cycles_max;
end
`endif
`endif
//// randomization active
reg p2_pipe_rand_enable;
reg p2_pipe_rand_poised;
always @(
  p2_pipe_stall_cycles
  or p2_pipe_stall_probability
  or rf_rd_vld
  ) begin
  p2_pipe_rand_active = p2_pipe_stall_cycles != 0;
  p2_pipe_rand_enable = p2_pipe_stall_probability != 0;
  p2_pipe_rand_poised = p2_pipe_rand_enable && !p2_pipe_rand_active && rf_rd_vld === 1'b1;
end
//// randomization cycles
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_pipe_stall_cycles <= 1'b0;
  end else begin
  if (p2_pipe_rand_poised) begin
    if (p2_pipe_stall_probability >= prand_inst0(1, 100)) begin
      p2_pipe_stall_cycles <= prand_inst1(p2_pipe_stall_cycles_min, p2_pipe_stall_cycles_max);
    end
  end else if (p2_pipe_rand_active) begin
    p2_pipe_stall_cycles <= p2_pipe_stall_cycles - 1;
  end else begin
    p2_pipe_stall_cycles <= 0;
  end
  end
end

`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed0;
reg prand_initialized0;
reg prand_no_rollpli0;
`endif
`endif
`endif

function [31:0] prand_inst0;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst0 = min;
`else
`ifdef SYNTHESIS
        prand_inst0 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized0 !== 1'b1) begin
            prand_no_rollpli0 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli0)
                prand_local_seed0 = {$prand_get_seed(0), 16'b0};
            prand_initialized0 = 1'b1;
        end
        if (prand_no_rollpli0) begin
            prand_inst0 = min;
        end else begin
            diff = max - min + 1;
            prand_inst0 = min + prand_local_seed0[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed0 = prand_local_seed0 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst0 = min;
`else
        prand_inst0 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction


`ifdef SYNTH_LEVEL1_COMPILE
`else
`ifdef SYNTHESIS
`else
`ifdef PRAND_VERILOG
// Only verilog needs any local variables
reg [47:0] prand_local_seed1;
reg prand_initialized1;
reg prand_no_rollpli1;
`endif
`endif
`endif

function [31:0] prand_inst1;
//VCS coverage off
    input [31:0] min;
    input [31:0] max;
    reg [32:0] diff;
    
    begin
`ifdef SYNTH_LEVEL1_COMPILE
        prand_inst1 = min;
`else
`ifdef SYNTHESIS
        prand_inst1 = min;
`else
`ifdef PRAND_VERILOG
        if (prand_initialized1 !== 1'b1) begin
            prand_no_rollpli1 = $test$plusargs("NO_ROLLPLI");
            if (!prand_no_rollpli1)
                prand_local_seed1 = {$prand_get_seed(1), 16'b0};
            prand_initialized1 = 1'b1;
        end
        if (prand_no_rollpli1) begin
            prand_inst1 = min;
        end else begin
            diff = max - min + 1;
            prand_inst1 = min + prand_local_seed1[47:16] % diff;
            // magic numbers taken from Java's random class (same as lrand48)
            prand_local_seed1 = prand_local_seed1 * 48'h5deece66d + 48'd11;
        end
`else
`ifdef PRAND_OFF
        prand_inst1 = min;
`else
        prand_inst1 = $RollPLI(min, max, "auto");
`endif
`endif
`endif
`endif
    end
//VCS coverage on
endfunction

`endif
// VCS coverage on
//## pipe (2) skid buffer
always @(
  p2_pipe_rand_valid
  or p2_skid_ready_flop
  or p2_skid_pipe_ready
  or p2_skid_valid
  ) begin
  p2_skid_catch = p2_pipe_rand_valid && p2_skid_ready_flop && !p2_skid_pipe_ready;  
  p2_skid_ready = (p2_skid_valid)? p2_skid_pipe_ready : !p2_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p2_skid_valid <= 1'b0;
    p2_skid_ready_flop <= 1'b1;
    p2_pipe_rand_ready <= 1'b1;
  end else begin
  p2_skid_valid <= (p2_skid_valid)? !p2_skid_pipe_ready : p2_skid_catch;
  p2_skid_ready_flop <= p2_skid_ready;
  p2_pipe_rand_ready <= p2_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
  // VCS sop_coverage_off start
  p2_skid_data <= (p2_skid_catch)? p2_pipe_rand_data : p2_skid_data;
  // VCS sop_coverage_off end
end
always @(
  p2_skid_ready_flop
  or p2_pipe_rand_valid
  or p2_skid_valid
  or p2_pipe_rand_data
  or p2_skid_data
  ) begin
  p2_skid_pipe_valid = (p2_skid_ready_flop)? p2_pipe_rand_valid : p2_skid_valid; 
  // VCS sop_coverage_off start
  p2_skid_pipe_data = (p2_skid_ready_flop)? p2_pipe_rand_data : p2_skid_data;
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
  or rf_rd_ordy
  or p2_pipe_data
  ) begin
  rf_rd_ovld = p2_pipe_valid;
  p2_pipe_ready = rf_rd_ordy;
  rf_rd_opd[177:0] = p2_pipe_data;
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
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals")      zzz_assert_no_x_3x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (rf_rd_ovld^rf_rd_ordy^rf_rd_vld^rf_rd_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready")      zzz_assert_hold_throughout_event_interval_4x (nvdla_core_clk, `ASSERT_RESET, (rf_rd_vld && !rf_rd_rdy), (rf_rd_vld), (rf_rd_rdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
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
endmodule // NV_NVDLA_RUBIK_RF_CORE_pipe_p2



