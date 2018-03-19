// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cfgrom.v

`include "simulate_x_tick.vh"
module NV_NVDLA_cfgrom (
   nvdla_core_clk     
  ,nvdla_core_rstn    
  ,csb2cfgrom_req_pd  
  ,csb2cfgrom_req_pvld
  ,csb2cfgrom_req_prdy
  ,cfgrom2csb_resp_pd 
  ,cfgrom2csb_resp_valid
  );

input         nvdla_core_clk;
input         nvdla_core_rstn;
input  [62:0] csb2cfgrom_req_pd;
input         csb2cfgrom_req_pvld;
output        csb2cfgrom_req_prdy;
output [33:0] cfgrom2csb_resp_pd;
output        cfgrom2csb_resp_valid;
/////////////////////////////////////////////
wire          csb_rresp_error;
wire   [33:0] csb_rresp_pd_w;
wire   [31:0] csb_rresp_rdat;
wire          csb_wresp_error;
wire   [33:0] csb_wresp_pd_w;
wire   [31:0] csb_wresp_rdat;
wire   [23:0] reg_offset;
wire   [31:0] reg_rd_data;
wire          reg_rd_en;
wire   [31:0] reg_wr_data;
wire          reg_wr_en;
wire   [21:0] req_addr;
wire    [1:0] req_level;
wire          req_nposted;
wire          req_srcpriv;
wire   [31:0] req_wdat;
wire    [3:0] req_wrbe;
wire          req_write;
reg    [33:0] cfgrom2csb_resp_pd;
reg           cfgrom2csb_resp_valid;
reg    [62:0] req_pd;
reg           req_pvld;
////////////////////////////////////////////////////////////////////////

NV_NVDLA_CFGROM_rom u_NV_NVDLA_CFGROM_rom (
   .reg_rd_data             (reg_rd_data[31:0])
  ,.reg_offset              (reg_offset[11:0]) 
  ,.reg_wr_data             (reg_wr_data[31:0])
  ,.reg_wr_en               (reg_wr_en)        
  ,.nvdla_core_clk          (nvdla_core_clk)      
  ,.nvdla_core_rstn         (nvdla_core_rstn)     
  );
////////////////////////////////////////////////////////////////////////
//                                                                    //
// GENERATE CSB TO REGISTER CONNECTION LOGIC                          //
//                                                                    //
////////////////////////////////////////////////////////////////////////

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_pvld <= 1'b0;
  end else begin
  req_pvld <= csb2cfgrom_req_pvld;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    req_pd <= {63{1'b0}};
  end else begin
  if ((csb2cfgrom_req_pvld) == 1'b1) begin
    req_pd <= csb2cfgrom_req_pd;
  end
  end
end


// PKT_UNPACK_WIRE( csb2xx_16m_be_lvl ,  req_ ,  req_pd )
assign        req_addr[21:0] =     req_pd[21:0];
assign        req_wdat[31:0] =     req_pd[53:22];
assign         req_write  =     req_pd[54];
assign         req_nposted  =     req_pd[55];
assign         req_srcpriv  =     req_pd[56];
assign        req_wrbe[3:0] =     req_pd[60:57];
assign        req_level[1:0] =     req_pd[62:61];

assign csb2cfgrom_req_prdy = 1'b1;


//Address in CSB master is word aligned while address in regfile is byte aligned.
assign reg_offset = {req_addr, 2'b0};
assign reg_wr_data = req_wdat;
assign reg_wr_en = req_pvld & req_write;
assign reg_rd_en = req_pvld & ~req_write;


assign       csb_rresp_pd_w[31:0] =     csb_rresp_rdat[31:0];
assign       csb_rresp_pd_w[32] =     csb_rresp_error ;

assign   csb_rresp_pd_w[33:33] = 1'd0  /* PKT_nvdla_xx2csb_resp_dla_xx2csb_rd_erpt_ID  */ ;

assign       csb_wresp_pd_w[31:0] =     csb_wresp_rdat[31:0];
assign       csb_wresp_pd_w[32] =     csb_wresp_error ;

assign   csb_wresp_pd_w[33:33] = 1'd1  /* PKT_nvdla_xx2csb_resp_dla_xx2csb_wr_erpt_ID  */ ;

assign csb_rresp_rdat = reg_rd_data;
assign csb_rresp_error = 1'b0;
assign csb_wresp_rdat = {32{1'b0}};
assign csb_wresp_error = 1'b0;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfgrom2csb_resp_pd <= {34{1'b0}};
  end else begin
    if(reg_rd_en)
    begin
        cfgrom2csb_resp_pd <= csb_rresp_pd_w;
    end
    else if(reg_wr_en & req_nposted)
    begin
        cfgrom2csb_resp_pd <= csb_wresp_pd_w;
    end
  end
end

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cfgrom2csb_resp_valid <= 1'b0;
  end else begin
    cfgrom2csb_resp_valid <= (reg_wr_en & req_nposted) | reg_rd_en;
  end
end


endmodule

