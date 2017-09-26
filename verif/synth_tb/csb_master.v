
module syn_csb_master (
    clk,
    reset,

    mcsb2scsb_pvld,
    mcsb2scsb_prdy,
    mcsb2scsb_pd,

    scsb2mcsb_valid,
    scsb2mcsb_pd,
    scsb2mcsb_error,
    scsb2mcsb_wr_complete,
    scsb2mcsb_wr_err,
    scsb2mcsb_wr_rdat,

    mseq_pending_req,
    mcsb2mseq_consumed_req,
    mseq2mcsb_pd,
    mcsb2mseq_rdata,
    mcsb2mseq_rvalid
);

input clk;
input reset;

output reg mcsb2scsb_pvld;
input mcsb2scsb_prdy;
output reg [62:0] mcsb2scsb_pd;
// level 62:61
// nposted 55
// addr 21:0
// wrbe 60:57
// srcpriv 56
// write 54
// wdat 53:52
wire [1:0] mcsb2scsb_pd_level;
wire mcsb2scsb_pd_nposted;
wire [21:0] mcsb2scsb_pd_addr;
wire [3:0] mcsb2scsb_pd_wrbe;
wire mcsb2scsb_pd_srcpriv;
wire mcsb2scsb_pd_write;
wire [31:0] mcsb2scsb_pd_wdat;
assign mcsb2scsb_pd_level = mcsb2scsb_pd[62:61];
assign mcsb2scsb_pd_wrbe = mcsb2scsb_pd[60:57];
assign mcsb2scsb_pd_srcpriv = mcsb2scsb_pd[56:56];
assign mcsb2scsb_pd_nposted = mcsb2scsb_pd[55:55];
assign mcsb2scsb_pd_write = mcsb2scsb_pd[54:54];
assign mcsb2scsb_pd_wdat = mcsb2scsb_pd[53:22];
assign mcsb2scsb_pd_addr = mcsb2scsb_pd[21:0];

input scsb2mcsb_valid;
input [31:0] scsb2mcsb_pd;
input scsb2mcsb_error;
input scsb2mcsb_wr_complete;
input scsb2mcsb_wr_err;
input scsb2mcsb_wr_rdat;

input mseq_pending_req;
input [62:0] mseq2mcsb_pd;
output reg mcsb2mseq_consumed_req;
output reg [31:0] mcsb2mseq_rdata;
output reg mcsb2mseq_rvalid;

reg [62:0] latched_mseq_pd;

// Response channel wires
wire scsb2mcsb_valid;
wire scsb2mcsb_error;
wire scsb2mcsb_wr_complete;
wire scsb2mcsb_wr_err;
wire scsb2mcsb_wr_rdat;

//wire mcsb2mseq_rdata;
//wire mcsb2mseq_rvalid;

reg latch_req;

reg [31:0] latched_scsb2mcsb_pd;

reg [2:0]  m_csb_st_next;
reg [2:0]  m_csb_st_curr;
// MASTER CSB FSM
`define M_CSB_IDLE              3'b000
`define M_CSB_START_REQ         3'b001
`define M_CSB_HOLD_REQ          3'b010
`define M_CSB_WAIT_FOR_WR_COMP  3'b011
`define M_CSB_WAIT_FOR_RD_VALID 3'b100

always @(posedge clk) begin
  latched_scsb2mcsb_pd <= scsb2mcsb_valid ? scsb2mcsb_pd : 0;
end

always @ (*) begin
  m_csb_st_next = m_csb_st_curr;
  mcsb2mseq_consumed_req = 0;
  latch_req = 0;
  mcsb2scsb_pvld = 1'b0;
  mcsb2scsb_pd = 63'b0;
  mcsb2mseq_rdata = 0;
  mcsb2mseq_rvalid = 0;
  // Initial values. May be overwritten in cases 
 
  begin
    casez (m_csb_st_curr)
      `M_CSB_IDLE: begin
        //output signals = 0
        if (mseq_pending_req) begin
          m_csb_st_next = `M_CSB_START_REQ;
        end
      end
      `M_CSB_START_REQ: begin
        latch_req = 1;
        if (mcsb2scsb_prdy) begin
          // output signals = mseq req
          mcsb2scsb_pvld = 1'b1;
          mcsb2scsb_pd = mseq2mcsb_pd;
          mcsb2mseq_consumed_req = 1;
          if (mcsb2scsb_pd_write & mcsb2scsb_pd_nposted) begin
            m_csb_st_next = `M_CSB_WAIT_FOR_WR_COMP;
          end else if (mcsb2scsb_pd_write & !mcsb2scsb_pd_nposted) begin
            mcsb2mseq_rvalid = 1;
            if (mseq_pending_req) begin
              m_csb_st_next = `M_CSB_START_REQ;
            end else begin
              m_csb_st_next = `M_CSB_IDLE;
            end
          end else if (!mcsb2scsb_pd_write) begin
            m_csb_st_next = `M_CSB_WAIT_FOR_RD_VALID;
          end
        end else begin
          m_csb_st_next = `M_CSB_HOLD_REQ;
        end
      end
      `M_CSB_HOLD_REQ: begin
        //output signals = latched_req
        mcsb2scsb_pvld = 1'b1;
        mcsb2scsb_pd = latched_mseq_pd;
        if (mcsb2scsb_prdy) begin
          if (mcsb2scsb_pd_write & mcsb2scsb_pd_nposted) begin
            m_csb_st_next = `M_CSB_WAIT_FOR_WR_COMP;
          end else if (mcsb2scsb_pd_write & !mcsb2scsb_pd_nposted) begin
            mcsb2mseq_rvalid = 1;
            if (mseq_pending_req) begin
              m_csb_st_next = `M_CSB_START_REQ;
            end else begin
              m_csb_st_next = `M_CSB_IDLE;
            end
          end else if (!mcsb2scsb_pd_write) begin
            m_csb_st_next = `M_CSB_WAIT_FOR_RD_VALID;
          end
        end else if (!mcsb2scsb_prdy) begin
          m_csb_st_next = `M_CSB_HOLD_REQ;
        end        
      end
      `M_CSB_WAIT_FOR_WR_COMP: begin
        //output signals = 0
        if (scsb2mcsb_wr_complete) begin
          mcsb2mseq_rvalid = 1;
          if (mseq_pending_req) begin
              m_csb_st_next = `M_CSB_START_REQ;
          end else begin
              m_csb_st_next = `M_CSB_IDLE;
          end
        end
      end
      `M_CSB_WAIT_FOR_RD_VALID: begin
        //output signals = 0
        if (scsb2mcsb_valid) begin
          mcsb2mseq_rvalid = 1;
          mcsb2mseq_rdata = scsb2mcsb_pd;
          if (mseq_pending_req) begin
            m_csb_st_next = `M_CSB_START_REQ;
          end else if (!mseq_pending_req) begin
            m_csb_st_next = `M_CSB_IDLE;
          end
        end
      end
    endcase
  end
end

// Updating FSM state
always @(posedge clk or negedge reset) begin
  if(!reset) begin
    m_csb_st_curr <= `M_CSB_IDLE;
    latched_mseq_pd <= 0;
  end else begin
    m_csb_st_curr <= m_csb_st_next;
    if (latch_req) begin
      latched_mseq_pd <= mseq2mcsb_pd;
    end
  end
end

endmodule
