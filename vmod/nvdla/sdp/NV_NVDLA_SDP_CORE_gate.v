// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_SDP_CORE_gate.v

module NV_NVDLA_SDP_CORE_gate (
   bcore_slcg_en
  ,dla_clk_ovr_on_sync
  ,ecore_slcg_en
  ,global_clk_ovr_on_sync
  ,ncore_slcg_en
  ,nvdla_core_clk
  ,nvdla_core_rstn
  ,tmc2slcg_disable_clock_gating
  ,nvdla_gated_bcore_clk
  ,nvdla_gated_ecore_clk
  ,nvdla_gated_ncore_clk
  );

input   bcore_slcg_en;
input   dla_clk_ovr_on_sync;
input   ecore_slcg_en;
input   global_clk_ovr_on_sync;
input   ncore_slcg_en;
input   nvdla_core_clk;
input   nvdla_core_rstn;
input   tmc2slcg_disable_clock_gating;
output  nvdla_gated_bcore_clk;
output  nvdla_gated_ecore_clk;
output  nvdla_gated_ncore_clk;

//=======================================
//CLock Gating: when BRDMA_MODE = NONE

`ifndef NO_SIMTOP_END_OF_SIM
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off
reg nvdla_core_clk_slcg_0_icg_disable_eos;
initial begin
   nvdla_core_clk_slcg_0_icg_disable_eos = 1'b0;
   if ($test$plusargs ("icg_no_eos_disable")) nvdla_core_clk_slcg_0_icg_disable_eos = 1'b1;
end
wire nvdla_core_clk_slcg_0_end_of_sim_clock_enable;
`ifndef SIMTOP_EOS_SIGNAL
assign nvdla_core_clk_slcg_0_end_of_sim_clock_enable = ~nvdla_core_clk_slcg_0_icg_disable_eos & 0;
`else
assign nvdla_core_clk_slcg_0_end_of_sim_clock_enable = ~nvdla_core_clk_slcg_0_icg_disable_eos & `SIMTOP_EOS_SIGNAL;
`endif // SIMTOP_EOS_SIGNAL

reg nvdla_core_clk_slcg_0_icg_override_to_ungated;
reg nvdla_core_clk_slcg_0_icg_override_to_gateable;
initial begin
   nvdla_core_clk_slcg_0_icg_override_to_ungated   = 1'b0;
   nvdla_core_clk_slcg_0_icg_override_to_gateable  = 1'b0;
   if ($test$plusargs ("icg_override_to_ungated"))  nvdla_core_clk_slcg_0_icg_override_to_ungated  = 1'b1;
   if ($test$plusargs ("icg_override_to_gateable")) nvdla_core_clk_slcg_0_icg_override_to_gateable = 1'b1;
end

// VCS coverage on
`endif // SYNTHESIS
`endif // SYNTH_LEVEL1_COMPILE
`endif // NO_SIMTOP_END_OF_SIM
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off
initial begin
   if ($test$plusargs ("icg_global_force_message_on"))
       $display("ICG_Assert::Found ICG instance: %m :: %s","nvdla_core_clk_slcg_0");
end
wire assert2slcg_disable_clock_gating_0;
assign  assert2slcg_disable_clock_gating_0 = tmc2slcg_disable_clock_gating;
always @(posedge assert2slcg_disable_clock_gating_0) begin
   if ($test$plusargs ("icg_global_force_message_on")) begin
           $display(" ICG_Assert::Found global_force_on tmc2slcg_disable_clock_gating change from 0->1 for ICG instance %m :: %s","nvdla_core_clk_slcg_0");
   end
end
always @(negedge assert2slcg_disable_clock_gating_0) begin
   if ($test$plusargs ("icg_global_force_message_on")) begin
           $display(" ICG_Assert::Found global_force_on tmc2slcg_disable_clock_gating change from 1->0 for ICG instance %m :: %s","nvdla_core_clk_slcg_0");
   end
end
always @(posedge global_clk_ovr_on_sync) begin
   if ($test$plusargs ("icg_global_force_message_on")) begin
           $display(" ICG_Assert::Found global_force_on global_clk_ovr_on_sync change from 0->1 for ICG instance %m :: %s","nvdla_core_clk_slcg_0");
   end
end
always @(negedge global_clk_ovr_on_sync) begin
   if ($test$plusargs ("icg_global_force_message_on")) begin
           $display(" ICG_Assert::Found global_force_on global_clk_ovr_on_sync change from 1->0 for ICG instance %m :: %s","nvdla_core_clk_slcg_0");
   end
end
// VCS coverage on
`endif // SYNTHESIS
`endif // SYNTH_LEVEL1_COMPILE
wire nvdla_core_clk_slcg_0_en;
assign nvdla_core_clk_slcg_0_en = bcore_slcg_en | (dla_clk_ovr_on_sync 
`ifndef NO_SIMTOP_END_OF_SIM
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off
    &&  !nvdla_core_clk_slcg_0_icg_override_to_gateable
// VCS coverage on
`endif // SYNTHESIS
`endif // SYNTH_LEVEL1_COMPILE
`endif // NO_SIMTOP_END_OF_SIM
   )
 | ((tmc2slcg_disable_clock_gating|global_clk_ovr_on_sync) 
`ifndef NO_SIMTOP_END_OF_SIM
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off
    && !nvdla_core_clk_slcg_0_icg_override_to_gateable
// VCS coverage on
`endif // SYNTHESIS
`endif // SYNTH_LEVEL1_COMPILE
`endif // NO_SIMTOP_END_OF_SIM
   )

`ifndef NO_SIMTOP_END_OF_SIM
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off
 | nvdla_core_clk_slcg_0_end_of_sim_clock_enable
 | nvdla_core_clk_slcg_0_icg_override_to_ungated
// VCS coverage on
`endif // SYNTHESIS
`endif // SYNTH_LEVEL1_COMPILE
`endif // NO_SIMTOP_END_OF_SIM
;
NV_CLK_gate_power nvdla_core_clk_slcg_0 (
  .clk(nvdla_core_clk),
  .reset_(nvdla_core_rstn),
  .clk_en(nvdla_core_clk_slcg_0_en),
  .clk_gated(nvdla_gated_bcore_clk) ); // spyglass disable GatedClock


`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_0___1_b1_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_0___1_b1_OR_COVER
  `endif // COVER

  `ifdef TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_0___1_b1
    `define COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_0___1_b1_OR_COVER
  `endif // TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_0___1_b1

`ifdef COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_0___1_b1_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME=":Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_0 = 1'b1"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_0_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_0_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_0_internal_nvdla_core_rstn
    //  Clock signal: testpoint_0_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_0_internal_nvdla_core_clk or negedge testpoint_0_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_0
        if (~testpoint_0_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_0_count_0;

    reg testpoint_0_goal_0;
    initial testpoint_0_goal_0 = 0;
    initial testpoint_0_count_0 = 0;
    always@(testpoint_0_count_0) begin
        if(testpoint_0_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_0_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_SDP_CORE_gate ::: :Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_0 = 1'b1 ::: (dla_clk_ovr_on_sync)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_SDP_CORE_gate ::: :Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_0 = 1'b1 ::: testpoint_0_goal_0
            testpoint_0_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_0_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_0_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_0
        if (testpoint_0_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((dla_clk_ovr_on_sync)) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_SDP_CORE_gate ::: :Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_0 = 1'b1 ::: testpoint_0_goal_0");
 `endif
            if (((dla_clk_ovr_on_sync)) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk)
                testpoint_0_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk) begin
 `endif
                testpoint_0_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_0_goal_0_active = (((dla_clk_ovr_on_sync)) && testpoint_got_reset_testpoint_0_internal_nvdla_core_rstn_with_clock_testpoint_0_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_0_goal_0 (.clk (testpoint_0_internal_nvdla_core_clk), .tp(testpoint_0_goal_0_active));
 `else
    system_verilog_testpoint svt__Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_0__1_b1_0 (.clk (testpoint_0_internal_nvdla_core_clk), .tp(testpoint_0_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_0___1_b1_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_0___1_b0_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_0___1_b0_OR_COVER
  `endif // COVER

  `ifdef TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_0___1_b0
    `define COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_0___1_b0_OR_COVER
  `endif // TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_0___1_b0

`ifdef COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_0___1_b0_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME=":Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_0 = 1'b0"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_1_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_1_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_1_internal_nvdla_core_rstn
    //  Clock signal: testpoint_1_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_1_internal_nvdla_core_clk or negedge testpoint_1_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_1
        if (~testpoint_1_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_1_count_0;

    reg testpoint_1_goal_0;
    initial testpoint_1_goal_0 = 0;
    initial testpoint_1_count_0 = 0;
    always@(testpoint_1_count_0) begin
        if(testpoint_1_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_1_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_SDP_CORE_gate ::: :Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_0 = 1'b0 ::: (!(dla_clk_ovr_on_sync))");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_SDP_CORE_gate ::: :Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_0 = 1'b0 ::: testpoint_1_goal_0
            testpoint_1_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_1_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_1_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_1
        if (testpoint_1_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((!(dla_clk_ovr_on_sync))) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_SDP_CORE_gate ::: :Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_0 = 1'b0 ::: testpoint_1_goal_0");
 `endif
            if (((!(dla_clk_ovr_on_sync))) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk)
                testpoint_1_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk) begin
 `endif
                testpoint_1_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_1_goal_0_active = (((!(dla_clk_ovr_on_sync))) && testpoint_got_reset_testpoint_1_internal_nvdla_core_rstn_with_clock_testpoint_1_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_1_goal_0 (.clk (testpoint_1_internal_nvdla_core_clk), .tp(testpoint_1_goal_0_active));
 `else
    system_verilog_testpoint svt__Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_0__1_b0_0 (.clk (testpoint_1_internal_nvdla_core_clk), .tp(testpoint_1_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_0___1_b0_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END


  `ifdef ICG_SUMMARY
  `ifndef NO_SIMTOP_END_OF_SIM
  `ifndef SYNTH_LEVEL1_COMPILE
  `ifndef SYNTHESIS
  // VCS coverage off


//  reg monitor_icg_summary_0;
  reg done_monitor_0;
  integer  clk_count_0;
  integer  clk_disable_count_0; 
 
  initial begin
    clk_count_0 = 0;
    clk_disable_count_0 = 0;
//    monitor_icg_summary_0 = 0;
    done_monitor_0= 0;
    if ($test$plusargs( "icg_summary" ) ) begin
//      monitor_icg_summary_0 = 1;
      forever begin
        @ (posedge nvdla_core_clk);
        if(nvdla_core_rstn === 1'b0) begin
          clk_count_0 <= 0;
          clk_disable_count_0 <= 0;
        end else begin
          clk_count_0 <= clk_count_0 + 1;           
          if ( ~(nvdla_core_clk_slcg_0_en) == 1'b1) begin
            clk_disable_count_0 <= clk_disable_count_0 + 1;
          end
          `ifndef SIMTOP_EOS_SIGNAL
          if (0 == 1 && done_monitor_0 == 0) begin
          `else
          if (`SIMTOP_EOS_SIGNAL == 1 && done_monitor_0 == 0) begin
          `endif // SIMTOP_EOS_SIGNAL
            // $display ("(%0d): INFO: %m (icg_template): ICG (0) summary. Number of disabled clks = %0d, Total clks = %0d, Enabled %0f", $stime, clk_disable_count_0, clk_count_0, enabled_percent_0);
            $display ("(%0d): INFO: %m (icg_template): ICG (0) summary. Number of disabled clks = %0d, Total clks = %0d, Enabled %0f", $stime, clk_disable_count_0, clk_count_0, 1.0 - (1.0 * (clk_disable_count_0) / (clk_count_0)));
            done_monitor_0 <= 1;
          end
        end
      end
    end
  end  

  ////integer enabled_percent_0;
  ////&Always;
  ////  if (monitor_icg_summary_0 == 1) begin
  ////    enabled_percent_0 = 1.0 - ( ( clk_disable_count_0 ) / ( clk_count_0 ) );
  ////  end
  ////&End;

  // VCS coverage on
  `endif // SYNTHESIS
  `endif // SYNTH_LEVEL1_COMPILE
  `endif // NO_SIMTOP_END_OF_SIM
  `else
  `ifndef NO_SIMTOP_END_OF_SIM
  `ifndef SYNTH_LEVEL1_COMPILE
  `ifndef SYNTHESIS
  initial begin
    if ($test$plusargs( "icg_summary" ) ) begin
      `ifndef SIMTOP_EOS_SIGNAL
      @(posedge (0)) begin
      `else
      @(posedge (`SIMTOP_EOS_SIGNAL)) begin
      `endif // SIMTOP_EOS_SIGNAL
        $display ("(%0d): INFO: %m (icg_template): ICG (0) summary feature was not enabled at compile time.  Please define ICG_SUMMARY, re-compile and re-run for icg summary",$stime);
      end
    end
  end
  `endif // SYNTHESIS
  `endif // SYNTH_LEVEL1_COMPILE
  `endif // NO_SIMTOP_END_OF_SIM
  `endif // ICG_SUMMARY

`ifndef NO_SIMTOP_END_OF_SIM
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off
reg nvdla_core_clk_slcg_1_icg_disable_eos;
initial begin
   nvdla_core_clk_slcg_1_icg_disable_eos = 1'b0;
   if ($test$plusargs ("icg_no_eos_disable")) nvdla_core_clk_slcg_1_icg_disable_eos = 1'b1;
end
wire nvdla_core_clk_slcg_1_end_of_sim_clock_enable;
`ifndef SIMTOP_EOS_SIGNAL
assign nvdla_core_clk_slcg_1_end_of_sim_clock_enable = ~nvdla_core_clk_slcg_1_icg_disable_eos & 0;
`else
assign nvdla_core_clk_slcg_1_end_of_sim_clock_enable = ~nvdla_core_clk_slcg_1_icg_disable_eos & `SIMTOP_EOS_SIGNAL;
`endif // SIMTOP_EOS_SIGNAL

reg nvdla_core_clk_slcg_1_icg_override_to_ungated;
reg nvdla_core_clk_slcg_1_icg_override_to_gateable;
initial begin
   nvdla_core_clk_slcg_1_icg_override_to_ungated   = 1'b0;
   nvdla_core_clk_slcg_1_icg_override_to_gateable  = 1'b0;
   if ($test$plusargs ("icg_override_to_ungated"))  nvdla_core_clk_slcg_1_icg_override_to_ungated  = 1'b1;
   if ($test$plusargs ("icg_override_to_gateable")) nvdla_core_clk_slcg_1_icg_override_to_gateable = 1'b1;
end

// VCS coverage on
`endif // SYNTHESIS
`endif // SYNTH_LEVEL1_COMPILE
`endif // NO_SIMTOP_END_OF_SIM
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off
initial begin
   if ($test$plusargs ("icg_global_force_message_on"))
       $display("ICG_Assert::Found ICG instance: %m :: %s","nvdla_core_clk_slcg_1");
end
wire assert2slcg_disable_clock_gating_1;
assign  assert2slcg_disable_clock_gating_1 = tmc2slcg_disable_clock_gating;
always @(posedge assert2slcg_disable_clock_gating_1) begin
   if ($test$plusargs ("icg_global_force_message_on")) begin
           $display(" ICG_Assert::Found global_force_on tmc2slcg_disable_clock_gating change from 0->1 for ICG instance %m :: %s","nvdla_core_clk_slcg_1");
   end
end
always @(negedge assert2slcg_disable_clock_gating_1) begin
   if ($test$plusargs ("icg_global_force_message_on")) begin
           $display(" ICG_Assert::Found global_force_on tmc2slcg_disable_clock_gating change from 1->0 for ICG instance %m :: %s","nvdla_core_clk_slcg_1");
   end
end
always @(posedge global_clk_ovr_on_sync) begin
   if ($test$plusargs ("icg_global_force_message_on")) begin
           $display(" ICG_Assert::Found global_force_on global_clk_ovr_on_sync change from 0->1 for ICG instance %m :: %s","nvdla_core_clk_slcg_1");
   end
end
always @(negedge global_clk_ovr_on_sync) begin
   if ($test$plusargs ("icg_global_force_message_on")) begin
           $display(" ICG_Assert::Found global_force_on global_clk_ovr_on_sync change from 1->0 for ICG instance %m :: %s","nvdla_core_clk_slcg_1");
   end
end
// VCS coverage on
`endif // SYNTHESIS
`endif // SYNTH_LEVEL1_COMPILE
wire nvdla_core_clk_slcg_1_en;
assign nvdla_core_clk_slcg_1_en = ncore_slcg_en | (dla_clk_ovr_on_sync 
`ifndef NO_SIMTOP_END_OF_SIM
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off
    &&  !nvdla_core_clk_slcg_1_icg_override_to_gateable
// VCS coverage on
`endif // SYNTHESIS
`endif // SYNTH_LEVEL1_COMPILE
`endif // NO_SIMTOP_END_OF_SIM
   )
 | ((tmc2slcg_disable_clock_gating|global_clk_ovr_on_sync) 
`ifndef NO_SIMTOP_END_OF_SIM
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off
    && !nvdla_core_clk_slcg_1_icg_override_to_gateable
// VCS coverage on
`endif // SYNTHESIS
`endif // SYNTH_LEVEL1_COMPILE
`endif // NO_SIMTOP_END_OF_SIM
   )

`ifndef NO_SIMTOP_END_OF_SIM
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off
 | nvdla_core_clk_slcg_1_end_of_sim_clock_enable
 | nvdla_core_clk_slcg_1_icg_override_to_ungated
// VCS coverage on
`endif // SYNTHESIS
`endif // SYNTH_LEVEL1_COMPILE
`endif // NO_SIMTOP_END_OF_SIM
;
NV_CLK_gate_power nvdla_core_clk_slcg_1 (
  .clk(nvdla_core_clk),
  .reset_(nvdla_core_rstn),
  .clk_en(nvdla_core_clk_slcg_1_en),
  .clk_gated(nvdla_gated_ncore_clk) ); // spyglass disable GatedClock

`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_1___1_b1_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_1___1_b1_OR_COVER
  `endif // COVER

  `ifdef TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_1___1_b1
    `define COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_1___1_b1_OR_COVER
  `endif // TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_1___1_b1

`ifdef COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_1___1_b1_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME=":Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_1 = 1'b1"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_2_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_2_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_2_internal_nvdla_core_rstn
    //  Clock signal: testpoint_2_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_2_internal_nvdla_core_clk or negedge testpoint_2_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_2
        if (~testpoint_2_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_2_count_0;

    reg testpoint_2_goal_0;
    initial testpoint_2_goal_0 = 0;
    initial testpoint_2_count_0 = 0;
    always@(testpoint_2_count_0) begin
        if(testpoint_2_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_2_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_SDP_CORE_gate ::: :Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_1 = 1'b1 ::: (dla_clk_ovr_on_sync)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_SDP_CORE_gate ::: :Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_1 = 1'b1 ::: testpoint_2_goal_0
            testpoint_2_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_2_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_2_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_2
        if (testpoint_2_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((dla_clk_ovr_on_sync)) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_SDP_CORE_gate ::: :Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_1 = 1'b1 ::: testpoint_2_goal_0");
 `endif
            if (((dla_clk_ovr_on_sync)) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk)
                testpoint_2_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk) begin
 `endif
                testpoint_2_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_2_goal_0_active = (((dla_clk_ovr_on_sync)) && testpoint_got_reset_testpoint_2_internal_nvdla_core_rstn_with_clock_testpoint_2_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_2_goal_0 (.clk (testpoint_2_internal_nvdla_core_clk), .tp(testpoint_2_goal_0_active));
 `else
    system_verilog_testpoint svt__Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_1__1_b1_0 (.clk (testpoint_2_internal_nvdla_core_clk), .tp(testpoint_2_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_1___1_b1_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_1___1_b0_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_1___1_b0_OR_COVER
  `endif // COVER

  `ifdef TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_1___1_b0
    `define COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_1___1_b0_OR_COVER
  `endif // TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_1___1_b0

`ifdef COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_1___1_b0_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME=":Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_1 = 1'b0"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_3_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_3_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_3_internal_nvdla_core_rstn
    //  Clock signal: testpoint_3_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_3_internal_nvdla_core_clk or negedge testpoint_3_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_3
        if (~testpoint_3_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_3_count_0;

    reg testpoint_3_goal_0;
    initial testpoint_3_goal_0 = 0;
    initial testpoint_3_count_0 = 0;
    always@(testpoint_3_count_0) begin
        if(testpoint_3_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_3_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_SDP_CORE_gate ::: :Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_1 = 1'b0 ::: (!(dla_clk_ovr_on_sync))");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_SDP_CORE_gate ::: :Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_1 = 1'b0 ::: testpoint_3_goal_0
            testpoint_3_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_3_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_3_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_3
        if (testpoint_3_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((!(dla_clk_ovr_on_sync))) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_SDP_CORE_gate ::: :Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_1 = 1'b0 ::: testpoint_3_goal_0");
 `endif
            if (((!(dla_clk_ovr_on_sync))) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk)
                testpoint_3_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk) begin
 `endif
                testpoint_3_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_3_goal_0_active = (((!(dla_clk_ovr_on_sync))) && testpoint_got_reset_testpoint_3_internal_nvdla_core_rstn_with_clock_testpoint_3_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_3_goal_0 (.clk (testpoint_3_internal_nvdla_core_clk), .tp(testpoint_3_goal_0_active));
 `else
    system_verilog_testpoint svt__Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_1__1_b0_0 (.clk (testpoint_3_internal_nvdla_core_clk), .tp(testpoint_3_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_1___1_b0_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END


  `ifdef ICG_SUMMARY
  `ifndef NO_SIMTOP_END_OF_SIM
  `ifndef SYNTH_LEVEL1_COMPILE
  `ifndef SYNTHESIS
  // VCS coverage off


//  reg monitor_icg_summary_1;
  reg done_monitor_1;
  integer  clk_count_1;
  integer  clk_disable_count_1; 
 
  initial begin
    clk_count_1 = 0;
    clk_disable_count_1 = 0;
//    monitor_icg_summary_1 = 0;
    done_monitor_1= 0;
    if ($test$plusargs( "icg_summary" ) ) begin
//      monitor_icg_summary_1 = 1;
      forever begin
        @ (posedge nvdla_core_clk);
        if(nvdla_core_rstn === 1'b0) begin
          clk_count_1 <= 0;
          clk_disable_count_1 <= 0;
        end else begin
          clk_count_1 <= clk_count_1 + 1;           
          if ( ~(nvdla_core_clk_slcg_1_en) == 1'b1) begin
            clk_disable_count_1 <= clk_disable_count_1 + 1;
          end
          `ifndef SIMTOP_EOS_SIGNAL
          if (0 == 1 && done_monitor_1 == 0) begin
          `else
          if (`SIMTOP_EOS_SIGNAL == 1 && done_monitor_1 == 0) begin
          `endif // SIMTOP_EOS_SIGNAL
            // $display ("(%0d): INFO: %m (icg_template): ICG (1) summary. Number of disabled clks = %0d, Total clks = %0d, Enabled %0f", $stime, clk_disable_count_1, clk_count_1, enabled_percent_1);
            $display ("(%0d): INFO: %m (icg_template): ICG (1) summary. Number of disabled clks = %0d, Total clks = %0d, Enabled %0f", $stime, clk_disable_count_1, clk_count_1, 1.0 - (1.0 * (clk_disable_count_1) / (clk_count_1)));
            done_monitor_1 <= 1;
          end
        end
      end
    end
  end  

  ////integer enabled_percent_1;
  ////&Always;
  ////  if (monitor_icg_summary_1 == 1) begin
  ////    enabled_percent_1 = 1.0 - ( ( clk_disable_count_1 ) / ( clk_count_1 ) );
  ////  end
  ////&End;

  // VCS coverage on
  `endif // SYNTHESIS
  `endif // SYNTH_LEVEL1_COMPILE
  `endif // NO_SIMTOP_END_OF_SIM
  `else
  `ifndef NO_SIMTOP_END_OF_SIM
  `ifndef SYNTH_LEVEL1_COMPILE
  `ifndef SYNTHESIS
  initial begin
    if ($test$plusargs( "icg_summary" ) ) begin
      `ifndef SIMTOP_EOS_SIGNAL
      @(posedge (0)) begin
      `else
      @(posedge (`SIMTOP_EOS_SIGNAL)) begin
      `endif // SIMTOP_EOS_SIGNAL
        $display ("(%0d): INFO: %m (icg_template): ICG (1) summary feature was not enabled at compile time.  Please define ICG_SUMMARY, re-compile and re-run for icg summary",$stime);
      end
    end
  end
  `endif // SYNTHESIS
  `endif // SYNTH_LEVEL1_COMPILE
  `endif // NO_SIMTOP_END_OF_SIM
  `endif // ICG_SUMMARY

`ifndef NO_SIMTOP_END_OF_SIM
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off
reg nvdla_core_clk_slcg_2_icg_disable_eos;
initial begin
   nvdla_core_clk_slcg_2_icg_disable_eos = 1'b0;
   if ($test$plusargs ("icg_no_eos_disable")) nvdla_core_clk_slcg_2_icg_disable_eos = 1'b1;
end
wire nvdla_core_clk_slcg_2_end_of_sim_clock_enable;
`ifndef SIMTOP_EOS_SIGNAL
assign nvdla_core_clk_slcg_2_end_of_sim_clock_enable = ~nvdla_core_clk_slcg_2_icg_disable_eos & 0;
`else
assign nvdla_core_clk_slcg_2_end_of_sim_clock_enable = ~nvdla_core_clk_slcg_2_icg_disable_eos & `SIMTOP_EOS_SIGNAL;
`endif // SIMTOP_EOS_SIGNAL

reg nvdla_core_clk_slcg_2_icg_override_to_ungated;
reg nvdla_core_clk_slcg_2_icg_override_to_gateable;
initial begin
   nvdla_core_clk_slcg_2_icg_override_to_ungated   = 1'b0;
   nvdla_core_clk_slcg_2_icg_override_to_gateable  = 1'b0;
   if ($test$plusargs ("icg_override_to_ungated"))  nvdla_core_clk_slcg_2_icg_override_to_ungated  = 1'b1;
   if ($test$plusargs ("icg_override_to_gateable")) nvdla_core_clk_slcg_2_icg_override_to_gateable = 1'b1;
end

// VCS coverage on
`endif // SYNTHESIS
`endif // SYNTH_LEVEL1_COMPILE
`endif // NO_SIMTOP_END_OF_SIM
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off
initial begin
   if ($test$plusargs ("icg_global_force_message_on"))
       $display("ICG_Assert::Found ICG instance: %m :: %s","nvdla_core_clk_slcg_2");
end
wire assert2slcg_disable_clock_gating_2;
assign  assert2slcg_disable_clock_gating_2 = tmc2slcg_disable_clock_gating;
always @(posedge assert2slcg_disable_clock_gating_2) begin
   if ($test$plusargs ("icg_global_force_message_on")) begin
           $display(" ICG_Assert::Found global_force_on tmc2slcg_disable_clock_gating change from 0->1 for ICG instance %m :: %s","nvdla_core_clk_slcg_2");
   end
end
always @(negedge assert2slcg_disable_clock_gating_2) begin
   if ($test$plusargs ("icg_global_force_message_on")) begin
           $display(" ICG_Assert::Found global_force_on tmc2slcg_disable_clock_gating change from 1->0 for ICG instance %m :: %s","nvdla_core_clk_slcg_2");
   end
end
always @(posedge global_clk_ovr_on_sync) begin
   if ($test$plusargs ("icg_global_force_message_on")) begin
           $display(" ICG_Assert::Found global_force_on global_clk_ovr_on_sync change from 0->1 for ICG instance %m :: %s","nvdla_core_clk_slcg_2");
   end
end
always @(negedge global_clk_ovr_on_sync) begin
   if ($test$plusargs ("icg_global_force_message_on")) begin
           $display(" ICG_Assert::Found global_force_on global_clk_ovr_on_sync change from 1->0 for ICG instance %m :: %s","nvdla_core_clk_slcg_2");
   end
end
// VCS coverage on
`endif // SYNTHESIS
`endif // SYNTH_LEVEL1_COMPILE
wire nvdla_core_clk_slcg_2_en;
assign nvdla_core_clk_slcg_2_en = ecore_slcg_en | (dla_clk_ovr_on_sync 
`ifndef NO_SIMTOP_END_OF_SIM
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off
    &&  !nvdla_core_clk_slcg_2_icg_override_to_gateable
// VCS coverage on
`endif // SYNTHESIS
`endif // SYNTH_LEVEL1_COMPILE
`endif // NO_SIMTOP_END_OF_SIM
   )
 | ((tmc2slcg_disable_clock_gating|global_clk_ovr_on_sync) 
`ifndef NO_SIMTOP_END_OF_SIM
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off
    && !nvdla_core_clk_slcg_2_icg_override_to_gateable
// VCS coverage on
`endif // SYNTHESIS
`endif // SYNTH_LEVEL1_COMPILE
`endif // NO_SIMTOP_END_OF_SIM
   )

`ifndef NO_SIMTOP_END_OF_SIM
`ifndef SYNTH_LEVEL1_COMPILE
`ifndef SYNTHESIS
// VCS coverage off
 | nvdla_core_clk_slcg_2_end_of_sim_clock_enable
 | nvdla_core_clk_slcg_2_icg_override_to_ungated
// VCS coverage on
`endif // SYNTHESIS
`endif // SYNTH_LEVEL1_COMPILE
`endif // NO_SIMTOP_END_OF_SIM
;
NV_CLK_gate_power nvdla_core_clk_slcg_2 (
  .clk(nvdla_core_clk),
  .reset_(nvdla_core_rstn),
  .clk_en(nvdla_core_clk_slcg_2_en),
  .clk_gated(nvdla_gated_ecore_clk) ); // spyglass disable GatedClock

`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_2___1_b1_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_2___1_b1_OR_COVER
  `endif // COVER

  `ifdef TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_2___1_b1
    `define COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_2___1_b1_OR_COVER
  `endif // TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_2___1_b1

`ifdef COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_2___1_b1_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME=":Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_2 = 1'b1"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_4_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_4_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_4_internal_nvdla_core_rstn
    //  Clock signal: testpoint_4_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_4_internal_nvdla_core_clk or negedge testpoint_4_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_4
        if (~testpoint_4_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_4_count_0;

    reg testpoint_4_goal_0;
    initial testpoint_4_goal_0 = 0;
    initial testpoint_4_count_0 = 0;
    always@(testpoint_4_count_0) begin
        if(testpoint_4_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_4_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_SDP_CORE_gate ::: :Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_2 = 1'b1 ::: (dla_clk_ovr_on_sync)");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_SDP_CORE_gate ::: :Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_2 = 1'b1 ::: testpoint_4_goal_0
            testpoint_4_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_4_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_4_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_4
        if (testpoint_4_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((dla_clk_ovr_on_sync)) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_SDP_CORE_gate ::: :Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_2 = 1'b1 ::: testpoint_4_goal_0");
 `endif
            if (((dla_clk_ovr_on_sync)) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk)
                testpoint_4_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk) begin
 `endif
                testpoint_4_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_4_goal_0_active = (((dla_clk_ovr_on_sync)) && testpoint_got_reset_testpoint_4_internal_nvdla_core_rstn_with_clock_testpoint_4_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_4_goal_0 (.clk (testpoint_4_internal_nvdla_core_clk), .tp(testpoint_4_goal_0_active));
 `else
    system_verilog_testpoint svt__Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_2__1_b1_0 (.clk (testpoint_4_internal_nvdla_core_clk), .tp(testpoint_4_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_2___1_b1_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END
`ifndef DISABLE_TESTPOINTS
  `ifdef COVER
    `define COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_2___1_b0_OR_COVER
  `endif // COVER

  `ifdef COVER
    `define COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_2___1_b0_OR_COVER
  `endif // COVER

  `ifdef TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_2___1_b0
    `define COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_2___1_b0_OR_COVER
  `endif // TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_2___1_b0

`ifdef COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_2___1_b0_OR_COVER


//VCS coverage off
    // TESTPOINT_START
    // NAME=":Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_2 = 1'b0"
    // TYPE=OCCURRENCE
    // AUTOGEN=true
    // COUNT=1
    // GROUP="DEFAULT"
    // INFO=""
    // RANDOM_COVER=true
    // ASYNC_RESET=1
    // ACTIVE_HIGH_RESET=0
wire testpoint_5_internal_nvdla_core_clk   = nvdla_core_clk;
wire testpoint_5_internal_nvdla_core_rstn = nvdla_core_rstn;

`ifdef FV_COVER_ON
    // Synthesizable code for SFV.
    wire testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk = 1'b1;
`else
    // Must be clocked with reset active before we start gathering
    // coverage.
    //  Reset signal: testpoint_5_internal_nvdla_core_rstn
    //  Clock signal: testpoint_5_internal_nvdla_core_clk
    reg testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk;

    initial
        testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk <= 1'b0;

    always @(posedge testpoint_5_internal_nvdla_core_clk or negedge testpoint_5_internal_nvdla_core_rstn) begin: HAS_RETENTION_TESTPOINT_RESET_5
        if (~testpoint_5_internal_nvdla_core_rstn)
            testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk <= 1'b1;
    end
`endif

`ifndef LINE_TESTPOINTS_OFF
    reg testpoint_5_count_0;

    reg testpoint_5_goal_0;
    initial testpoint_5_goal_0 = 0;
    initial testpoint_5_count_0 = 0;
    always@(testpoint_5_count_0) begin
        if(testpoint_5_count_0 >= 1)
         begin
 `ifdef COVER_PRINT_TESTPOINT_HITS
            if (testpoint_5_goal_0 != 1'b1)
                $display("TESTPOINT_HIT: NV_NVDLA_SDP_CORE_gate ::: :Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_2 = 1'b0 ::: (!(dla_clk_ovr_on_sync))");
 `endif
            //VCS coverage on
            //coverage name NV_NVDLA_SDP_CORE_gate ::: :Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_2 = 1'b0 ::: testpoint_5_goal_0
            testpoint_5_goal_0 = 1'b1;
            //VCS coverage off
        end
        else
            testpoint_5_goal_0 = 1'b0;
    end

    // Increment counters for every condition that's true this clock.
    always @(posedge testpoint_5_internal_nvdla_core_clk) begin: HAS_RETENTION_TESTPOINT_GOAL_5
        if (testpoint_5_internal_nvdla_core_rstn) begin
 `ifdef ASSOCIATE_TESTPOINT_NAME_GOAL_NUMBER
            if (((!(dla_clk_ovr_on_sync))) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk)
                $display("NVIDIA TESTPOINT: NV_NVDLA_SDP_CORE_gate ::: :Test dla_clk_ovr_on_sync for nvdla_core_clk_slcg_2 = 1'b0 ::: testpoint_5_goal_0");
 `endif
            if (((!(dla_clk_ovr_on_sync))) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk)
                testpoint_5_count_0 <= 1'd1;
        end
        else begin
 `ifndef FV_COVER_ON
            if (!testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk) begin
 `endif
                testpoint_5_count_0 <= 1'd0;
 `ifndef FV_COVER_ON
            end
 `endif
        end
    end
`endif // LINE_TESTPOINTS_OFF

`ifndef SV_TESTPOINTS_OFF
    wire testpoint_5_goal_0_active = (((!(dla_clk_ovr_on_sync))) && testpoint_got_reset_testpoint_5_internal_nvdla_core_rstn_with_clock_testpoint_5_internal_nvdla_core_clk);

    // system verilog testpoints, to leverage vcs testpoint coverage tools
 `ifndef SV_TESTPOINTS_DESCRIPTIVE
    system_verilog_testpoint svt_testpoint_5_goal_0 (.clk (testpoint_5_internal_nvdla_core_clk), .tp(testpoint_5_goal_0_active));
 `else
    system_verilog_testpoint svt__Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_2__1_b0_0 (.clk (testpoint_5_internal_nvdla_core_clk), .tp(testpoint_5_goal_0_active));
 `endif
`endif

    //VCS coverage on
`endif //COVER_OR_TP___Test_dla_clk_ovr_on_sync_for_nvdla_core_clk_slcg_2___1_b0_OR_COVER
`endif //  DISABLE_TESTPOINTS

    // TESTPOINT_END


  `ifdef ICG_SUMMARY
  `ifndef NO_SIMTOP_END_OF_SIM
  `ifndef SYNTH_LEVEL1_COMPILE
  `ifndef SYNTHESIS
  // VCS coverage off


//  reg monitor_icg_summary_2;
  reg done_monitor_2;
  integer  clk_count_2;
  integer  clk_disable_count_2; 
 
  initial begin
    clk_count_2 = 0;
    clk_disable_count_2 = 0;
//    monitor_icg_summary_2 = 0;
    done_monitor_2= 0;
    if ($test$plusargs( "icg_summary" ) ) begin
//      monitor_icg_summary_2 = 1;
      forever begin
        @ (posedge nvdla_core_clk);
        if(nvdla_core_rstn === 1'b0) begin
          clk_count_2 <= 0;
          clk_disable_count_2 <= 0;
        end else begin
          clk_count_2 <= clk_count_2 + 1;           
          if ( ~(nvdla_core_clk_slcg_2_en) == 1'b1) begin
            clk_disable_count_2 <= clk_disable_count_2 + 1;
          end
          `ifndef SIMTOP_EOS_SIGNAL
          if (0 == 1 && done_monitor_2 == 0) begin
          `else
          if (`SIMTOP_EOS_SIGNAL == 1 && done_monitor_2 == 0) begin
          `endif // SIMTOP_EOS_SIGNAL
            // $display ("(%0d): INFO: %m (icg_template): ICG (2) summary. Number of disabled clks = %0d, Total clks = %0d, Enabled %0f", $stime, clk_disable_count_2, clk_count_2, enabled_percent_2);
            $display ("(%0d): INFO: %m (icg_template): ICG (2) summary. Number of disabled clks = %0d, Total clks = %0d, Enabled %0f", $stime, clk_disable_count_2, clk_count_2, 1.0 - (1.0 * (clk_disable_count_2) / (clk_count_2)));
            done_monitor_2 <= 1;
          end
        end
      end
    end
  end  

  ////integer enabled_percent_2;
  ////&Always;
  ////  if (monitor_icg_summary_2 == 1) begin
  ////    enabled_percent_2 = 1.0 - ( ( clk_disable_count_2 ) / ( clk_count_2 ) );
  ////  end
  ////&End;

  // VCS coverage on
  `endif // SYNTHESIS
  `endif // SYNTH_LEVEL1_COMPILE
  `endif // NO_SIMTOP_END_OF_SIM
  `else
  `ifndef NO_SIMTOP_END_OF_SIM
  `ifndef SYNTH_LEVEL1_COMPILE
  `ifndef SYNTHESIS
  initial begin
    if ($test$plusargs( "icg_summary" ) ) begin
      `ifndef SIMTOP_EOS_SIGNAL
      @(posedge (0)) begin
      `else
      @(posedge (`SIMTOP_EOS_SIGNAL)) begin
      `endif // SIMTOP_EOS_SIGNAL
        $display ("(%0d): INFO: %m (icg_template): ICG (2) summary feature was not enabled at compile time.  Please define ICG_SUMMARY, re-compile and re-run for icg summary",$stime);
      end
    end
  end
  `endif // SYNTHESIS
  `endif // SYNTH_LEVEL1_COMPILE
  `endif // NO_SIMTOP_END_OF_SIM
  `endif // ICG_SUMMARY
//=======================================
//DMA
//---------------------------------------
//|
//|

endmodule // NV_NVDLA_SDP_CORE_gate

