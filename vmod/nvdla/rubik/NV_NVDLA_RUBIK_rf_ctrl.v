// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_RUBIK_rf_ctrl.v

module NV_NVDLA_RUBIK_rf_ctrl (
   nvdla_core_clk      //|< i
  ,nvdla_core_rstn     //|< i
  ,contract_lit_dx     //|< i
  ,data_fifo_pd        //|< i
  ,data_fifo_vld       //|< i
  ,inwidth             //|< i
  ,pwrbus_ram_pd       //|< i
  ,reg2dp_in_precision //|< i
  ,reg2dp_rubik_mode   //|< i
  ,rf_rd_cmd_pd        //|< i
  ,rf_rd_cmd_vld       //|< i
  ,rf_rd_rdy           //|< i
  ,rf_wr_cmd_pd        //|< i
  ,rf_wr_cmd_vld       //|< i
  ,rf_wr_rdy           //|< i
  ,data_fifo_rdy       //|> o
  ,rf_rd_addr          //|> o
  ,rf_rd_cmd_rdy       //|> o
  ,rf_rd_done          //|> o
  ,rf_rd_mask          //|> o
  ,rf_rd_vld           //|> o
  ,rf_wr_addr          //|> o
  ,rf_wr_cmd_rdy       //|> o
  ,rf_wr_data          //|> o
  ,rf_wr_done          //|> o
  ,rf_wr_vld           //|> o
  );


input         nvdla_core_clk;
input         nvdla_core_rstn;
input         contract_lit_dx;
input  [13:0] inwidth;
input  [31:0] pwrbus_ram_pd;

input            rf_wr_cmd_vld;
input   [10:0]   rf_wr_cmd_pd;
output           rf_wr_cmd_rdy;

input            rf_rd_cmd_vld;
input   [11:0]   rf_rd_cmd_pd;
output           rf_rd_cmd_rdy;

input            data_fifo_vld;
input   [511:0]  data_fifo_pd;
output           data_fifo_rdy;

output           rf_wr_vld;
output           rf_wr_done;
output  [4:0]    rf_wr_addr;   
output  [511:0]  rf_wr_data;                 
input            rf_wr_rdy;   
  
output           rf_rd_vld;
output           rf_rd_done;
output  [11:0]   rf_rd_mask;
output  [4:0]    rf_rd_addr;
input            rf_rd_rdy;

input  [1:0]            reg2dp_rubik_mode;
input  [1:0]          reg2dp_in_precision;

reg           mon_rf_rd_ccnt;
reg           mon_rf_rd_gcnt;
reg           mon_rf_rd_rcnt;
reg           mon_rf_wr_ccnt;
reg           mon_rf_wr_rcnt;
reg     [6:0] rd_total_col_reg;
reg     [6:0] rd_total_row_reg;
reg     [1:0] reg2dp_in_precision_drv1;
reg     [1:0] reg2dp_rubik_mode_drv1;
reg     [4:0] rf_rd_addr;
reg     [4:0] rf_rd_ccnt;
reg           rf_rd_cmd_open;
reg           rf_rd_cmd_ordy_hold;
reg    [10:0] rf_rd_gcnt;
reg     [5:0] rf_rd_rcnt;
reg     [1:0] rf_rptr;
reg     [1:0] rf_wptr;
reg     [4:0] rf_wr_addr;
reg     [4:0] rf_wr_ccnt;
reg           rf_wr_cmd_open;
reg           rf_wr_cmd_ordy_hold;
reg     [4:0] rf_wr_rcnt;
reg     [6:0] wr_total_col_reg;
reg     [5:0] wr_total_row_reg;
wire    [1:0] contract_atom_mask;
wire   [11:0] contract_rd_mask;
wire          m_byte_data;
wire          m_contract;
wire          m_split;
wire    [1:0] merge_atom_mask;
wire    [5:0] merge_byte_mask;
wire   [11:0] merge_rd_mask;
wire          mon_rd_tcol_c;
wire          mon_remain_byte;
wire          mon_remain_byte1;
wire          mon_remain_rd_col;
wire          mon_remain_rd_row;
wire          mon_wr_tcol_c;
wire    [7:0] rd_byte_num;
wire   [11:0] rd_grp_num;
wire    [6:0] rd_total_col;
wire    [6:0] rd_total_col_tmp;
wire    [5:0] rd_total_colm;
wire    [6:0] rd_total_pcol;
wire    [6:0] rd_total_prow;
wire    [6:0] rd_total_row;
wire    [6:0] rd_total_row_tmp;
wire    [7:0] remain_byte;
wire    [7:0] remain_byte1;
wire    [6:0] remain_rd_col;
wire    [6:0] remain_rd_row;
wire          rf_full;
wire          rf_nempty;
wire    [5:0] rf_rd_ccnt_inc;
wire   [11:0] rf_rd_cmd_opd;
wire          rf_rd_cmd_ordy;
wire          rf_rd_cmd_ovld;
wire          rf_rd_col_end;
wire   [11:0] rf_rd_gcnt_inc;
wire          rf_rd_grp_end;
wire    [6:0] rf_rd_rcnt_inc;
wire          rf_rd_row_end;
wire    [5:0] rf_wr_ccnt_inc;
wire   [10:0] rf_wr_cmd_opd;
wire          rf_wr_cmd_ordy;
wire          rf_wr_cmd_ovld;
wire          rf_wr_col_end;
wire    [5:0] rf_wr_rcnt_inc;
wire          rf_wr_row_end;
wire   [11:0] split_rd_mask;
wire    [6:0] wr_total_col;
wire    [5:0] wr_total_colm;
wire    [6:0] wr_total_pcol;
wire    [5:0] wr_total_prow;
wire    [5:0] wr_total_row;

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
    reg2dp_rubik_mode_drv1[1:0] <= {2{1'b0}};
  end else begin
  reg2dp_rubik_mode_drv1[1:0] <= reg2dp_rubik_mode[1:0];
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    reg2dp_in_precision_drv1[1:0] <= {2{1'b0}};
  end else begin
  reg2dp_in_precision_drv1[1:0] <= reg2dp_in_precision[1:0];
  end
end

assign  m_contract  = reg2dp_rubik_mode_drv1[1:0] == 2'h0 ;
assign  m_split     = reg2dp_rubik_mode_drv1[1:0] == 2'h1 ;
//assign  m_merge     = reg2dp_rubik_mode_drv1[1:0] == NVDLA_RBK_D_MISC_CFG_0_RUBIK_MODE_MERGE;
assign  m_byte_data = reg2dp_in_precision_drv1[1:0] == 2'h0 ;

////////////////////////////////////////////////////////////////////////////////
//////////////pop total row,total columun from rf_wr_cmd_fifo//////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rf_wr_cmd_ordy_hold <= 1'b1;
  end else begin
    if (rf_wr_cmd_ordy_hold & rf_wr_cmd_ovld)  
        rf_wr_cmd_ordy_hold <= 1'b0;
    else if(rf_wr_row_end & ~rf_wr_cmd_ovld) 
        rf_wr_cmd_ordy_hold <= 1'b1;
  end
end

assign  rf_wr_cmd_ordy = rf_wr_row_end | rf_wr_cmd_ordy_hold;

assign  wr_total_pcol[6:0] = rf_wr_cmd_opd[5:0]+1; 
assign  wr_total_prow[5:0] = rf_wr_cmd_opd[10:6]+1; 

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    wr_total_col_reg[6:0] <= {7{1'b0}};
    wr_total_row_reg[5:0] <= {6{1'b0}};
  end else begin
    if (rf_wr_cmd_ovld & rf_wr_cmd_ordy) begin  
        wr_total_col_reg[6:0] <= wr_total_pcol[6:0];
        wr_total_row_reg[5:0] <= wr_total_prow[5:0];
    end
  end
end

assign  wr_total_col[6:0] = wr_total_col_reg[6:0]; 
assign  wr_total_row[5:0] = wr_total_row_reg[5:0]; 

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rf_wr_cmd_open <= 1'b0;
  end else begin
    if (rf_wr_cmd_ovld & rf_wr_cmd_ordy)  
        rf_wr_cmd_open <= 1'b1;
    else if(rf_wr_row_end) 
        rf_wr_cmd_open <= 1'b0;
  end
end

////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////generate rf write address & data ////////////////////////////
assign  data_fifo_rdy = rf_wr_cmd_open & rf_wr_rdy & ~rf_full & data_fifo_vld;  //fifo random stall
assign  rf_wr_vld  = data_fifo_vld & data_fifo_rdy;
assign  rf_wr_data = data_fifo_pd[511:0]; 
assign  rf_wr_done = rf_wr_row_end;

//in contract mode,when write one row is done,wr_addr should skip to a fix address
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rf_wr_addr <= {5{1'b0}};
  end else begin
    if (rf_wr_row_end) begin
        rf_wr_addr <= 5'h0;
    end 
    else if(m_contract & rf_wr_col_end) begin  
        rf_wr_addr <= {rf_wr_rcnt_inc[2:0],2'b0};
    end
    else if(~m_split & ~m_contract & ~m_byte_data & rf_wr_col_end) begin  
        rf_wr_addr <= {rf_wr_rcnt_inc[3:0],1'b0};
    end
    else if(rf_wr_vld) begin
        rf_wr_addr <= rf_wr_addr + 1'b1;
    end
  end
end

//rf column counter & row counter
assign  rf_wr_ccnt_inc[5:0] = rf_wr_ccnt + 1;
assign  {mon_wr_tcol_c,wr_total_colm[5:0]} = wr_total_col[6:1]+wr_total_col[0];
assign  rf_wr_col_end  = rf_wr_vld & (rf_wr_ccnt_inc >= wr_total_colm);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rf_wr_ccnt <= {5{1'b0}};
    {mon_rf_wr_ccnt,rf_wr_ccnt} <= {6{1'b0}};
  end else begin
    if (rf_wr_col_end) begin
        rf_wr_ccnt <= 5'h0;
    end 
    else if(rf_wr_vld) begin
        {mon_rf_wr_ccnt,rf_wr_ccnt} <= rf_wr_ccnt_inc;
    end
  end
end

assign  rf_wr_rcnt_inc[5:0] = rf_wr_rcnt + 1;
assign  rf_wr_row_end  = rf_wr_col_end  & (rf_wr_rcnt_inc == wr_total_row);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rf_wr_rcnt <= {5{1'b0}};
    {mon_rf_wr_rcnt,rf_wr_rcnt} <= {6{1'b0}};
  end else begin
    if (rf_wr_row_end) begin
        rf_wr_rcnt <= 5'h0;
    end 
    else if(rf_wr_col_end) begin
        {mon_rf_wr_rcnt,rf_wr_rcnt} <= rf_wr_rcnt_inc;
    end
  end
end

NV_NVDLA_RUBIK_rf_wcmd rbk_rf_wr_cmd_fifo (
   .nvdla_core_clk  (nvdla_core_clk)      //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)     //|< i
  ,.idata_prdy      (rf_wr_cmd_rdy)       //|> o
  ,.idata_pvld      (rf_wr_cmd_vld)       //|< i
  ,.idata_pd        (rf_wr_cmd_pd[10:0])  //|< i
  ,.odata_prdy      (rf_wr_cmd_ordy)      //|< w
  ,.odata_pvld      (rf_wr_cmd_ovld)      //|> w
  ,.odata_pd        (rf_wr_cmd_opd[10:0]) //|> w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0]) //|< i
  );

////////////////////////////////////////////////////////////////////////////////
//////////////pop total row,total columun from rf_rd_cmd_fifo//////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rf_rd_cmd_ordy_hold <= 1'b1;
  end else begin
    if (rf_rd_cmd_ordy_hold & rf_rd_cmd_ovld)  
        rf_rd_cmd_ordy_hold <= 1'b0;
    else if(rf_rd_grp_end & ~rf_rd_cmd_ovld) 
        rf_rd_cmd_ordy_hold <= 1'b1;
  end
end

assign  rf_rd_cmd_ordy = rf_rd_grp_end | rf_rd_cmd_ordy_hold;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rf_rd_cmd_open <= 1'b0;
  end else begin
    if (rf_rd_cmd_ovld & rf_rd_cmd_ordy)  
        rf_rd_cmd_open <= 1'b1;
    else if(rf_rd_grp_end) 
        rf_rd_cmd_open <= 1'b0;
  end
end

//merge and split of read total column unit is element(1byte or 2byte), but contract unit is 32bytes 
assign  rd_total_pcol[6:0] = rf_rd_cmd_opd[5:0]+1; 
assign  rd_total_prow[6:0] = rf_rd_cmd_opd[11:6]+1;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rd_total_col_reg[6:0] <= {7{1'b0}};
    rd_total_row_reg[6:0] <= {7{1'b0}};
  end else begin
    if (rf_rd_cmd_ovld & rf_rd_cmd_ordy) begin  
        rd_total_col_reg[6:0] <= rd_total_pcol[6:0];
        rd_total_row_reg[6:0] <= rd_total_prow[6:0];
    end
  end
end

assign  rd_total_col_tmp[6:0] = rd_total_col_reg[6:0]; 
assign  rd_total_row_tmp[6:0] = rd_total_row_reg[6:0]; 

assign  rd_grp_num[11:0]  = |inwidth[2:0] ? inwidth[13:3]+1 : inwidth[13:3];
assign  rd_total_col[6:0] = m_contract ? rd_total_col_tmp : m_split ? (m_byte_data ? 2'h2 : rd_total_col_tmp > 8'h20 ? 4'h4 : 4'h2) : rd_total_row_tmp;  
assign  rd_total_row[6:0] = contract_lit_dx ? (rf_rd_gcnt_inc == rd_grp_num ? (|inwidth[2:0] ? inwidth[2:0] : 7'h8) : 7'h8) : (m_contract | m_split) ? rd_total_row_tmp : 1'b1;  

////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////generate rf read address ///////////////////////////////////
assign   rf_rd_vld  = rf_rd_rdy & rf_nempty & rf_rd_cmd_open; 
assign   rf_rd_done = rf_rd_row_end;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rf_rd_addr <= {5{1'b0}};
  end else begin
    if (rf_rd_row_end) begin
        rf_rd_addr <= 5'h0;
    end 
    else if(m_contract & rf_rd_col_end) begin  
        rf_rd_addr <= {rf_rd_rcnt_inc[2:0],2'b0};
    end
    else if(m_split & ~m_byte_data & rf_rd_col_end) begin  
        rf_rd_addr <= {rf_rd_rcnt_inc[3:0],1'b0};
    end
    else if(rf_rd_vld) begin
        rf_rd_addr <= rf_rd_addr + 1'b1;
    end
  end
end

assign  rf_rd_ccnt_inc[5:0] = rf_rd_ccnt + 1; 
assign  {mon_rd_tcol_c,rd_total_colm[5:0]} = rd_total_col[6:1] + rd_total_col[0];
assign  rf_rd_col_end   = rf_rd_vld & (rf_rd_ccnt_inc >= rd_total_colm);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rf_rd_ccnt <= {5{1'b0}};
    {mon_rf_rd_ccnt,rf_rd_ccnt} <= {6{1'b0}};
  end else begin
    if (rf_rd_col_end) begin
        rf_rd_ccnt <= 5'h0;
    end 
    else if(rf_rd_vld) begin
        {mon_rf_rd_ccnt,rf_rd_ccnt} <= rf_rd_ccnt_inc;
    end
  end
end

assign  rf_rd_rcnt_inc[6:0] = rf_rd_rcnt + 1;
assign  rf_rd_row_end  = rf_rd_col_end  & (rf_rd_rcnt_inc == rd_total_row);
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rf_rd_rcnt <= {6{1'b0}};
    {mon_rf_rd_rcnt,rf_rd_rcnt} <= {7{1'b0}};
  end else begin
    if (rf_rd_row_end) begin
        rf_rd_rcnt <= 6'h0;
    end 
    else if(rf_rd_col_end) begin
        {mon_rf_rd_rcnt,rf_rd_rcnt} <= rf_rd_rcnt_inc;
    end
  end
end

assign  rf_rd_gcnt_inc[11:0] = rf_rd_gcnt + 1;
assign  rf_rd_grp_end  = rf_rd_row_end  & (rf_rd_gcnt_inc == (contract_lit_dx ? rd_grp_num : 1'b1));
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rf_rd_gcnt <= {11{1'b0}};
    {mon_rf_rd_gcnt,rf_rd_gcnt} <= {12{1'b0}};
  end else begin
    if (rf_rd_grp_end) begin
        rf_rd_gcnt <= 11'h0;
    end 
    else if(rf_rd_row_end) begin
        {mon_rf_rd_gcnt,rf_rd_gcnt} <= rf_rd_gcnt_inc;
    end
  end
end

/////////////generate the 64byte data mask//////////
//rf_rd_mask[5:0]  : how many valid byte of atomic0
//rf_rd_mask[11:6] : how many valid byte of atomic1
assign  {mon_remain_rd_row,remain_rd_row[6:0]} = rd_total_row_tmp - {rf_rd_ccnt,1'b0};
assign  {mon_remain_rd_col,remain_rd_col[6:0]} = rd_total_col_tmp - {rf_rd_ccnt,1'b0};

assign  rd_byte_num[7:0]  = m_byte_data ? {1'b0,rd_total_col_tmp} : {rd_total_col_tmp,1'b0};
assign  {mon_remain_byte, remain_byte[7:0] } = rd_byte_num - {rf_rd_ccnt[1:0],6'h0};
assign  {mon_remain_byte1,remain_byte1[7:0]} = rd_byte_num - {rf_rd_ccnt[1:0],6'h0} - 8'h20;

assign  split_rd_mask[11:0] = (remain_byte >= 8'h40) ? {6'h20,6'h20} : 
                              (remain_byte >= 8'h20) ? {remain_byte1[5:0],6'h20} : {6'h0,remain_byte[5:0]}; 

assign  merge_byte_mask[5:0] = m_byte_data ? rd_total_col_tmp[5:0] : {rd_total_col_tmp[4:0],1'b0};  
assign  merge_atom_mask[1:0] = remain_rd_row == 7'b1 ? 2'b01 : 2'b11; 
assign  merge_rd_mask[11:0]  = ~merge_atom_mask[1] ? {6'h0,merge_byte_mask[5:0]} : {merge_byte_mask[5:0],merge_byte_mask[5:0]}; 

assign  contract_atom_mask[1:0] = remain_rd_col == 7'b1 ? 2'b01 : 2'b11;
assign  contract_rd_mask[11:0]  = ~contract_atom_mask[1] ? {6'h0,6'h20} : {6'h20,6'h20}; 

assign  rf_rd_mask[11:0] = m_contract ? contract_rd_mask : m_split ? split_rd_mask : merge_rd_mask;

NV_NVDLA_RUBIK_rf_rcmd rbk_rf_rd_cmd_fifo (
   .nvdla_core_clk  (nvdla_core_clk)      //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn)     //|< i
  ,.idata_prdy      (rf_rd_cmd_rdy)       //|> o
  ,.idata_pvld      (rf_rd_cmd_vld)       //|< i
  ,.idata_pd        (rf_rd_cmd_pd[11:0])  //|< i
  ,.odata_prdy      (rf_rd_cmd_ordy)      //|< w
  ,.odata_pvld      (rf_rd_cmd_ovld)      //|> w
  ,.odata_pd        (rf_rd_cmd_opd[11:0]) //|> w
  ,.pwrbus_ram_pd   (pwrbus_ram_pd[31:0]) //|< i
  );

////////////////rf status////////////////////
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rf_wptr[1:0] <= {2{1'b0}};
  end else begin
    if (rf_wr_done)
        rf_wptr[1:0] <= rf_wptr[1:0] + 1;
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    rf_rptr[1:0] <= {2{1'b0}};
  end else begin
    if (rf_rd_done)
        rf_rptr[1:0] <= rf_rptr[1:0]+1;
  end
end

assign  rf_nempty = ~(rf_wptr[1:0]==rf_rptr[1:0]);
assign  rf_full   = (rf_wptr[1]^rf_rptr[1]) & (rf_wptr[0]==rf_rptr[0]);


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

    property rubik_rf_ctrl__rf_wr_cmd_pop_block__0_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        rf_wr_row_end & ~rf_wr_cmd_ovld;
    endproperty
    // Cover 0 : "rf_wr_row_end & ~rf_wr_cmd_ovld"
    FUNCPOINT_rubik_rf_ctrl__rf_wr_cmd_pop_block__0_COV : cover property (rubik_rf_ctrl__rf_wr_cmd_pop_block__0_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property rubik_rf_ctrl__rf_wr_data_full__1_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((data_fifo_vld) && nvdla_core_rstn) |-> (rf_wr_rdy & rf_full);
    endproperty
    // Cover 1 : "rf_wr_rdy & rf_full"
    FUNCPOINT_rubik_rf_ctrl__rf_wr_data_full__1_COV : cover property (rubik_rf_ctrl__rf_wr_data_full__1_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property rubik_rf_ctrl__rf_rd_cmd_pop_block__2_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        rf_rd_grp_end & ~rf_rd_cmd_ovld;
    endproperty
    // Cover 2 : "rf_rd_grp_end & ~rf_rd_cmd_ovld"
    FUNCPOINT_rubik_rf_ctrl__rf_rd_cmd_pop_block__2_COV : cover property (rubik_rf_ctrl__rf_rd_cmd_pop_block__2_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property rubik_rf_ctrl__rf_rd_data_after_cmd__3_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ~rf_rd_cmd_open & rf_rd_rdy & rf_nempty;
    endproperty
    // Cover 3 : "~rf_rd_cmd_open & rf_rd_rdy & rf_nempty"
    FUNCPOINT_rubik_rf_ctrl__rf_rd_data_after_cmd__3_COV : cover property (rubik_rf_ctrl__rf_rd_data_after_cmd__3_cov);

  `endif
`endif
//VCS coverage on

//VCS coverage off
`ifndef DISABLE_FUNCPOINT
  `ifdef ENABLE_FUNCPOINT

    property rubik_rf_ctrl__rf_rd_data_empty__4_cov;
        disable iff((nvdla_core_rstn !== 1) || funcpoint_cover_off)
        @(posedge nvdla_core_clk)
        ((rf_rd_cmd_open) && nvdla_core_rstn) |-> (rf_rd_rdy & ~rf_nempty);
    endproperty
    // Cover 4 : "rf_rd_rdy & ~rf_nempty"
    FUNCPOINT_rubik_rf_ctrl__rf_rd_data_empty__4_COV : cover property (rubik_rf_ctrl__rf_rd_data_empty__4_cov);

  `endif
`endif
//VCS coverage on


endmodule // NV_NVDLA_RUBIK_rf_ctrl

