// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_DMAIF_wr.v

`include "simulate_x_tick.vh"
module NV_NVDLA_DMAIF_wr (
   nvdla_core_clk      
  ,nvdla_core_rstn     
  ,reg2dp_dst_ram_type
  #ifdef NVDLA_SECONDARY_MEMIF_ENABLE
  ,cvif_wr_req_pd   
  ,cvif_wr_req_valid
  ,cvif_wr_req_ready
  ,cvif_wr_rsp_complete
  #endif
  ,mcif_wr_req_pd    
  ,mcif_wr_req_valid 
  ,mcif_wr_req_ready 
  ,mcif_wr_rsp_complete

  ,dmaif_wr_req_pd
  ,dmaif_wr_req_pvld
  ,dmaif_wr_req_prdy
  ,dmaif_wr_rsp_complete
);
//////////////////////////////////////////////
input       nvdla_core_clk;     
input       nvdla_core_rstn;    
input       reg2dp_dst_ram_type;
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
//: my $dmaif = NVDLA_MEMIF_WIDTH;
//: my $mask = int($dmaif/NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_BPE);
//: my $dmabw = ( $dmaif + $mask );
//: print qq( output   [${dmabw}:0]   cvif_wr_req_pd; \n); 
output                         cvif_wr_req_valid;
input                          cvif_wr_req_ready;
input                          cvif_wr_rsp_complete;
#endif
//: my $dmaif = NVDLA_MEMIF_WIDTH;
//: my $mask = int($dmaif/NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_BPE);
//: my $dmabw = ( $dmaif + $mask );
//: print qq( output   [${dmabw}:0]   mcif_wr_req_pd; \n); 
output                         mcif_wr_req_valid;
input                          mcif_wr_req_ready;
input                          mcif_wr_rsp_complete;

//: my $dmaif = NVDLA_MEMIF_WIDTH;
//: my $mask = int($dmaif/NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_BPE);
//: my $dmabw = ( $dmaif + $mask );
//: print qq( input    [${dmabw}:0]   dmaif_wr_req_pd;  \n);
input                 dmaif_wr_req_pvld;
output                dmaif_wr_req_prdy;
output                 dmaif_wr_rsp_complete;
//////////////////////////////////////////////
reg         dmaif_wr_rsp_complete;
wire        dma_wr_req_type;
wire        mc_dma_wr_req_vld;
wire        mc_dma_wr_req_rdy;
wire        mc_wr_req_rdyi;
wire        wr_req_rdyi;
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
wire        cv_dma_wr_req_vld;
wire        cv_dma_wr_req_rdy;
wire        cv_wr_req_rdyi;
#endif
//==============
// DMA Interface
//==============
assign dma_wr_req_type = reg2dp_dst_ram_type;
// wr Channel: Request 
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
assign cv_dma_wr_req_vld = dmaif_wr_req_pvld & (dma_wr_req_type == 1'b0);
assign cv_wr_req_rdyi = cv_dma_wr_req_rdy & (dma_wr_req_type == 1'b0);
assign wr_req_rdyi = mc_wr_req_rdyi | cv_wr_req_rdyi;
#else
assign wr_req_rdyi = mc_wr_req_rdyi;
#endif
assign mc_dma_wr_req_vld = dmaif_wr_req_pvld & (dma_wr_req_type == 1'b1);
assign mc_wr_req_rdyi = mc_dma_wr_req_rdy & (dma_wr_req_type == 1'b1);
assign dmaif_wr_req_prdy= wr_req_rdyi;
//: my $dmaif = NVDLA_MEMIF_WIDTH;
//: my $mask = int($dmaif/NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_BPE);
//: my $dmabw = ( $dmaif + $mask + 1 );
//: &eperl::pipe(" -wid $dmabw -is -do mcif_wr_req_pd -vo mcif_wr_req_valid -ri mcif_wr_req_ready -di dmaif_wr_req_pd -vi mc_dma_wr_req_vld -ro mc_dma_wr_req_rdy_f  ");
assign mc_dma_wr_req_rdy = mc_dma_wr_req_rdy_f;

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
//: my $dmaif = NVDLA_MEMIF_WIDTH;
//: my $mask = int($dmaif/NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_BPE);
//: my $dmabw = ( $dmaif + $mask + 1 );
//: print " wire    [${dmabw}-1:0]  cv_dma_wr_req_pd ;  \n";
//: print " assign cv_dma_wr_req_pd = dmaif_wr_req_pd;  \n";
//: &eperl::pipe(" -wid $dmabw -is -do cvif_wr_req_pd -vo cvif_wr_req_valid -ri cvif_wr_req_ready -di cv_dma_wr_req_pd -vi cv_dma_wr_req_vld -ro cv_dma_wr_req_rdy_f  ");
assign cv_dma_wr_req_rdy = cv_dma_wr_req_rdy_f;
#endif

// wr Channel: Response
wire        ack_top_rdy;
wire        releasing;
reg         ack_top_vld ;
reg         ack_top_id ;
wire        ack_bot_rdy;
reg         ack_bot_vld ;
reg         ack_bot_id ;
wire        ack_raw_rdy;
wire        ack_raw_id;
wire        ack_raw_vld;
wire        require_ack;
wire        mc_int_wr_rsp_complete;

assign mc_int_wr_rsp_complete = mcif_wr_rsp_complete;
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
wire        cv_int_wr_rsp_complete;
assign cv_int_wr_rsp_complete = cvif_wr_rsp_complete;
#endif
//: my $dmaif = NVDLA_MEMIF_WIDTH;
//: my $mask = int($dmaif/NVDLA_MEMORY_ATOMIC_SIZE/NVDLA_BPE);
//: my $dmabw = ( $dmaif + $mask + 1 );
//: if($dmaif > 64) {
//:     print qq( assign require_ack = (dmaif_wr_req_pd[${dmabw}-1]==0) & (dmaif_wr_req_pd[77]==1);  \n);
//: } else {
//:     print qq( assign require_ack = (dmaif_wr_req_pd[${dmabw}-1]==0) & (dmaif_wr_req_pd[45]==1);  \n);
//: }

// assign require_ack = (dmaif_wr_req_pd[${dmabw}-1]==0) & (dmaif_wr_req_pd[77:77]==1);
assign ack_raw_vld = dmaif_wr_req_pvld & wr_req_rdyi & require_ack;
assign ack_raw_id  = dma_wr_req_type;
// stage1: bot
assign ack_raw_rdy = ack_bot_rdy || !ack_bot_vld;
always @(posedge nvdla_core_clk) begin
  if (ack_raw_vld & ack_raw_rdy)
    ack_bot_id <= ack_raw_id;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ack_bot_vld <= 1'b0;
  end else if (ack_raw_rdy) begin
    ack_bot_vld <= ack_raw_vld;
  end
end
////: &eperl::assert(" -type never -desc `dmaif bot never push back` -expr `ack_raw_vld & !ack_raw_rdy`  "); 

// stage2: top
assign ack_bot_rdy = ack_top_rdy || !ack_top_vld;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ack_top_id <= 1'b0;
  end else if (ack_bot_vld & ack_bot_rdy) begin
    ack_top_id <= ack_bot_id;
  end
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    ack_top_vld <= 1'b0;
  end else if (ack_bot_rdy) begin
    ack_top_vld <= ack_bot_vld;
  end
end
assign ack_top_rdy = releasing;

reg         mc_dma_wr_rsp_complete;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mc_dma_wr_rsp_complete <= 1'b0;
  end else begin
    mc_dma_wr_rsp_complete <= mc_int_wr_rsp_complete;
  end
end
#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
reg         cv_dma_wr_rsp_complete;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cv_dma_wr_rsp_complete <= 1'b0;
  end else begin
    cv_dma_wr_rsp_complete <= cv_int_wr_rsp_complete;
  end
end
#endif
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    dmaif_wr_rsp_complete <= 1'b0;
  end else begin
    dmaif_wr_rsp_complete <= releasing;
  end
end

reg         mc_pending;
wire        mc_releasing;
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    mc_pending <= 1'b0;
  end else begin
        if (ack_top_id==0) begin
            if (mc_dma_wr_rsp_complete) begin
                mc_pending <= 1'b1;
            end
        end else if (ack_top_id==1) begin
            if (mc_pending) begin
                mc_pending <= 1'b0;
            end
        end
  end
end
assign mc_releasing = ack_top_id==1'b1 & (mc_dma_wr_rsp_complete | mc_pending);

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
reg         cv_pending;
wire        cv_releasing;

always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    cv_pending <= 1'b0;
  end else begin
        if (ack_top_id==1) begin
            if (cv_dma_wr_rsp_complete) begin
                cv_pending <= 1'b1;
            end
        end else if (ack_top_id==0) begin
            if (cv_pending) begin
                cv_pending <= 1'b0;
            end
        end
  end
end
assign cv_releasing = ack_top_id==1'b0 & (cv_dma_wr_rsp_complete | cv_pending);
#endif

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
assign releasing = mc_releasing | cv_releasing;
#else
assign releasing = mc_releasing;
#endif

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
// //: &eperl::assert("  -type never -desc 'no release both together'             -expr 'mc_releasing & cv_releasing'   );
// //: &eperl::assert("  -type never -desc 'no cv resp back and pending together' -expr 'cv_pending & cv_dma_wr_rsp_complete'  );
// //: &eperl::assert("  -type never -desc 'no ack_top_vld when resp from cv'     -expr '(cv_pending | cv_dma_wr_rsp_complete) & !ack_top_vld'  );
#endif
////: &eperl::assert("  -type never -desc 'no mc resp back and pending together' -expr 'mc_pending & mc_dma_wr_rsp_complete'  );
////: &eperl::assert("  -type never -desc 'no ack_top_vld when resp from mc'     -expr '(mc_pending | mc_dma_wr_rsp_complete) & !ack_top_vld'  );

//////////////////////////
endmodule

