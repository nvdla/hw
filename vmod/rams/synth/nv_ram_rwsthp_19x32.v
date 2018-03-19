// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: nv_ram_rwsthp_19x32.v

`timescale 1ns / 10ps
`ifdef _SIMULATE_X_VH_
`else

`ifndef SYNTHESIS
`define tick_x_or_0  1'bx
`define tick_x_or_1  1'bx
`else
`define tick_x_or_0  1'b0
`define tick_x_or_1  1'b1
`endif

`endif


module nv_ram_rwsthp_19x32 (
        clk,
        ra,
        re,
        ore,
        dout,
        wa,
        we,
        di,
        byp_sel,
        dbyp,
        pwrbus_ram_pd
        );
parameter FORCE_CONTENTION_ASSERTION_RESET_ACTIVE=1'b0;

// port list
input           clk;
input  [4:0]    ra;
input           re;
input           ore;
output [31:0]   dout;
input  [4:0]    wa;
input           we;
input  [31:0]   di;
input           byp_sel;
input  [31:0]   dbyp;
input  [31:0]   pwrbus_ram_pd;
    wire is_sram = 1'b1;

`ifdef GCS_COMPILE
 `define SYNTHESIS
`endif


`ifndef SYNTHESIS
`ifdef RAMGEN_AVF_PRINTS
 `define NV_Functional_safety_liveness_logging_enabled
`endif
`endif

wire [7:0] sleep_en = pwrbus_ram_pd[7:0];
wire  ret_en = pwrbus_ram_pd[8];
integer l;

`ifdef NV_Functional_safety_liveness_logging_enabled
time liveness[18:0];
time last_write_time[18:0];
time last_read_time[18:0];
reg liveness_logging_start;
integer num_writes[18:0];
integer num_reads[18:0];  
integer ratio_rw[18:0];  
initial begin
  for (l=0; l<19; l=l+1) begin
      liveness[l] = 0;
      last_write_time[l] = 0;
      last_read_time[l] = 0;
      ratio_rw[l] = 0;
      num_writes[l] = 0;
      num_reads[l] = 0;
  end
end
always @(posedge liveness_logging_start) begin
  for (l=0; l<19; l=l+1) last_write_time[l] = $time;
end
`endif
// Wires to check for wr-wr collision 

// storage array
reg    [31:0] M[18:0]; /* synthesis syn_rw_conflict_logic = 1 */

wire internal_sleep_en;
`ifdef RAM_DISABLE_POWER_GATING_FPGA
assign internal_sleep_en = 1'b0;
`else
assign internal_sleep_en = (|sleep_en);
`endif
`ifndef SYNTHESIS
integer i;
//X out the content of the memory array when the array is put in sleep mode 
always @(posedge internal_sleep_en) begin
		if (!ret_en) begin
		for(i=0;i<19;i=i+1) begin
			M[i] <= #0.01 32'dx ;
		end
	end
end
`endif

reg [5 : 0 ] count ; 
reg [4:0] wa_d;
reg  we_d;

//always block for write functionality
always @( posedge clk ) begin
	`ifndef SYNTHESIS
	// Clobber the memory array if we = x or wa = x (when we = 1'b1)
	if(((|we) === 1'bx || (((|we))&&(^wa)) === 1'bx)) begin 
 		#1
		for(count=0;count<19;count=count+1) begin 
			M[count] <= 32'dx ; 
		end 
	end 
	else begin 
	`endif
		we_d <= we;
		// Use == for synthesis and === for non-synthesis model 
		`ifndef SYNTHESIS
		if ( (|we) === 1'b1 ) begin
		`else
		if ( (|we) == 1'b1 ) begin
		`endif
		wa_d <= wa;
		end

		// Disable the addr > ram depth. An assert will flag this
		// spyglass disable_block SYNTH_5130

		//Updating the memory through write port w 
		`ifndef SYNTHESIS
		if ( ( we ) === 1'b1 ) begin
		`else
		if ( ( we ) == 1'b1 ) begin
		`endif
			if (!(ret_en | (internal_sleep_en))) M[wa] <= di; 
			`ifdef NV_Functional_safety_liveness_logging_enabled 
				if (liveness_logging_start) begin 
					last_write_time[wa] = $time;
					num_writes[wa] = num_writes[wa] + 1;
				end
			`endif
		end

		// spyglass enable_block SYNTH_5130
	`ifndef SYNTHESIS
	end 
	`endif 
end // always @ posedge clk



reg  [4:0] ra_d;

reg  re_d;

reg rd_x_clobber_r0 ;
initial rd_x_clobber_r0 = 1'b0;

wire  dout_ram_writethrough = (we_d & re_d & (wa_d == ra_d));
reg   dout_ram_writethrough_d;
    
reg   dout_ram_clobbered_d;

// Conditions to clobber dout 
wire  dout_ram_clobbered = {1{(internal_sleep_en)}} | (we_d & (wa_d == ra_d) & ~dout_ram_writethrough) |  (~re_d & dout_ram_clobbered_d) | ({1{|(internal_sleep_en)}})| {1{rd_x_clobber_r0}} ;
// Disable the addr > ram depth. An assert will flag this
// spyglass disable_block SYNTH_5130

`ifdef SYNTHESIS
       wire [31:0] dout_ram = (internal_sleep_en) ? 32'b0 : M[ra_d];
`else
       wire [31:0] dout_ram = (internal_sleep_en) ? 32'b0 : dout_ram_clobbered ? {32{1'bx}} : M[ra_d];
`endif
// spyglass enable_block SYNTH_5130

wire [31:0] fbypass_dout_ram;

assign fbypass_dout_ram = (byp_sel ? dbyp : dout_ram);

reg  [31:0] dout_r;

assign dout = dout_r;

//always block for read functionality
always @( posedge clk ) begin

    re_d <= ( re  ) ;

	//Clobber the dout if re = x or ra = x (when re = 1)
	`ifndef SYNTHESIS
	if ((re === 1'bx) ||((re)&&(^ra) === 1'bx) ) begin
		rd_x_clobber_r0 <= 1'b1 ;
	end
	else begin
	`else
	begin
	`endif
		//Use == for synthesis and === for non-synthesis model 
		`ifndef SYNTHESIS
		if ( ( re) === 1'b1 ) begin 
			rd_x_clobber_r0 <= 1'b0 ;
		`else 
		if ( ( re) == 1'b1 ) begin 
		`endif
			ra_d <= ra;


`ifdef NV_Functional_safety_liveness_logging_enabled
		if (liveness_logging_start) begin
		if (last_read_time[ra] >  last_write_time[ra]) begin
			// no write after last read to this row, remove factor added from last read
			liveness[ra] = liveness[ra] - (last_read_time[ra] - last_write_time[ra]);
		end
		// add the liveness from last write to this read
		last_read_time[ra] = $time;
		liveness[ra] = liveness[ra] + (last_read_time[ra] - last_write_time[ra]);
		num_reads[ra] = num_reads[ra] + 1;
		end // if liveness_logging_start
`endif
		end 

    dout_ram_writethrough_d <= dout_ram_writethrough;
		if(dout_ram_clobbered) begin
			dout_ram_clobbered_d <= dout_ram_clobbered;
		end else begin 
			dout_ram_clobbered_d <= 1'b0; 
		end
    end

	//Pipelined Read 
	if ( ore ) begin
		dout_r <= fbypass_dout_ram;
	end

end // always @ posedge clk

// expanded storage array
// verilint 528 off - variable set but not used
`ifdef NV_RAM_EXPAND_ARRAY
wire   [31:0] Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;
wire   [31:0] Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15;
wire   [31:0] Q16, Q17, Q18;
// verilint 528 on
assign Q0 = M[0];
assign Q1 = M[1];
assign Q2 = M[2];
assign Q3 = M[3];
assign Q4 = M[4];
assign Q5 = M[5];
assign Q6 = M[6];
assign Q7 = M[7];
assign Q8 = M[8];
assign Q9 = M[9];
assign Q10 = M[10];
assign Q11 = M[11];
assign Q12 = M[12];
assign Q13 = M[13];
assign Q14 = M[14];
assign Q15 = M[15];
assign Q16 = M[16];
assign Q17 = M[17];
assign Q18 = M[18];
`endif

`ifdef ASSERT_ON
`ifndef SYNTHESIS
reg sim_reset_;
initial sim_reset_ = 0;
always @(posedge clk) sim_reset_ <= 1'b1;

wire start_of_sim = sim_reset_;


wire disable_clk_x_test = $test$plusargs ("disable_clk_x_test") ? 1'b1 : 1'b0;
nv_assert_no_x #(1,1,0," Try Reading Ram when clock is x for read port r0") _clk_x_test_read (clk, sim_reset_, ((disable_clk_x_test===1'b0) && (|re===1'b1 )), clk);
nv_assert_no_x #(1,1,0," Try Writing Ram when clock is x for write port w0") _clk_x_test_write (clk, sim_reset_, ((disable_clk_x_test===1'b0) && (|we===1'b1)), clk);

`ifdef RAMGEN_CLOBBER
nv_assert_never  #(0,0,"clobbered high") clobbered_high  (clk,sim_reset_, (dout_ram_clobbered == 1'b1));
`endif
`endif // SYNTHESIS 
`endif // ASSERT_ON

`ifdef ASSERT_ON
`ifndef SYNTHESIS
`endif
`endif

`ifdef ASSERT_ON
`ifndef SYNTHESIS
wire pwrbus_assertion_not_x_while_active = $test$plusargs ("pwrbus_assertion_not_x_while_active");
nv_assert_never #(0, 0, "Power bus cannot be X when read/write enable is set") _pwrbus_assertion_not_x_while_active_we ( we, sim_reset_ && !pwrbus_assertion_not_x_while_active, ^pwrbus_ram_pd === 1'bx);
nv_assert_never #(0, 0, "Power bus cannot be X when read/write enable is set") _pwrbus_assertion_not_x_while_active_re ( re, sim_reset_ && !pwrbus_assertion_not_x_while_active, ^pwrbus_ram_pd === 1'bx);
`endif
`endif

`ifndef SYNTHESIS
task arrangement (output integer arrangment_string[31:0]);
  begin
    arrangment_string[0] = 0  ;     
    arrangment_string[1] = 1  ;     
    arrangment_string[2] = 2  ;     
    arrangment_string[3] = 3  ;     
    arrangment_string[4] = 4  ;     
    arrangment_string[5] = 5  ;     
    arrangment_string[6] = 6  ;     
    arrangment_string[7] = 7  ;     
    arrangment_string[8] = 8  ;     
    arrangment_string[9] = 9  ;     
    arrangment_string[10] = 10  ;     
    arrangment_string[11] = 11  ;     
    arrangment_string[12] = 12  ;     
    arrangment_string[13] = 13  ;     
    arrangment_string[14] = 14  ;     
    arrangment_string[15] = 15  ;     
    arrangment_string[16] = 16  ;     
    arrangment_string[17] = 17  ;     
    arrangment_string[18] = 18  ;     
    arrangment_string[19] = 19  ;     
    arrangment_string[20] = 20  ;     
    arrangment_string[21] = 21  ;     
    arrangment_string[22] = 22  ;     
    arrangment_string[23] = 23  ;     
    arrangment_string[24] = 24  ;     
    arrangment_string[25] = 25  ;     
    arrangment_string[26] = 26  ;     
    arrangment_string[27] = 27  ;     
    arrangment_string[28] = 28  ;     
    arrangment_string[29] = 29  ;     
    arrangment_string[30] = 30  ;     
    arrangment_string[31] = 31  ;     
  end
endtask
`endif

`ifndef SYNTHESIS
`ifndef NO_INIT_MEM_VAL_TASKS
task init_mem_val;
  input [4:0] row;
  input [31:0] data;
  begin
    M[row] = data;
  end
endtask

//This is only needed for latch arrays
task init_mem_commit;
  begin
  end
endtask
`endif
`endif


`ifndef SYNTHESIS
`ifndef NO_INIT_MEM_VAL_TASKS
function [31:0] probe_mem_val;
  input [4:0] row;
  begin
    probe_mem_val = M[row];
  end
endfunction
`endif
`endif


`ifndef SYNTHESIS
`ifndef NO_CLEAR_MEM_TASK
`ifndef NO_INIT_MEM_VAL_TASKS
reg disable_clear_mem = 0;
task clear_mem;
integer i;
begin
  if (!disable_clear_mem) 
  begin
    for (i = 0; i < 19; i = i + 1)
      begin
        init_mem_val(i, 'bx);
      end
    init_mem_commit();
  end
end
endtask
`endif
`endif
`endif

`ifndef SYNTHESIS
`ifndef NO_INIT_MEM_ZERO_TASK
`ifndef NO_INIT_MEM_VAL_TASKS
task init_mem_zero;
integer i;
begin
 for (i = 0; i < 19; i = i + 1)
   begin
     init_mem_val(i, 'b0);
   end
 init_mem_commit();
end
endtask
`endif
`endif
`endif

`ifndef SYNTHESIS
`ifndef NO_INIT_MEM_VAL_TASKS
`ifndef NO_INIT_MEM_FROM_FILE_TASK
task init_mem_from_file;
input string init_file;
integer i;
begin

 $readmemh(init_file,M);

end
endtask
`endif
`endif
`endif

`ifndef SYNTHESIS
`ifndef NO_INIT_MEM_RANDOM_TASK
`ifndef NO_INIT_MEM_VAL_TASKS
RANDFUNC rf0 ();

task init_mem_random;
reg [31:0] random_num;
integer i;
begin
 for (i = 0; i < 19; i = i + 1)
   begin
     random_num = {rf0.rollpli(0,32'hffffffff)};
     init_mem_val(i, random_num);
   end
 init_mem_commit();
end
endtask
`endif
`endif
`endif

`ifndef SYNTHESIS
`ifndef NO_FLIP_TASKS
`ifndef NO_INIT_MEM_VAL_TASKS

RANDFUNC rflip ();

task random_flip;
integer random_num;
integer row;
integer bitnum;
begin
  random_num = rflip.rollpli(0, 608);
  row = random_num / 32;
  bitnum = random_num % 32;
  target_flip(row, bitnum);
end
endtask

task target_flip;
input [4:0] row;
input [31:0] bitnum;
reg [31:0] data;
begin
  if(!$test$plusargs("no_display_target_flips"))
    $display("%m: flipping row %d bit %d at time %t", row, bitnum, $time);

  data = probe_mem_val(row);
  data[bitnum] = ~data[bitnum];
  init_mem_val(row, data);
  init_mem_commit();
end
endtask

`endif
`endif
`endif
`ifndef NO_DO_WRITE_TASK
task do_write; //(wa, we, di);
   input  [4:0] wa;
   input   we;
   input  [31:0] di;
   reg    [31:0] d;
   begin
      d = M[wa];
      d = (we ? di : d);
      M[wa] = d;
   end
endtask

`endif


`ifdef NV_Functional_safety_liveness_logging_enabled
task average_liveness_time;
begin
integer i;
time sum;
time average;
real sum_rds;
real sum_wrs;
real ratio_rw;
sum = 0;
sum_rds = 0;
sum_wrs = 0;
for (i=0; i < 19; i=i+1) begin
   sum = sum + liveness[i];
   sum_rds = sum_rds + num_reads[i];
   sum_wrs = sum_wrs + num_writes[i];
end
average = sum/19;
ratio_rw = sum_rds/sum_wrs;
$display ("nv_ram %m: size 608 bits, AVF liveness %d", average);
$display ("nv_ram %m: AVF ratioRW %f, totalWrites %d, totalReads %d", ratio_rw, sum_wrs, sum_rds);
end
endtask
`endif

`ifdef GCS_COMPILE
 `undef SYNTHESIS
`endif

endmodule
