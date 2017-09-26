// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: assertion_task.h

`define ASSERT_MAX_REPORT_ERROR      10
`define ASSERT_MAX_REPORT_WARN       10
`define ASSERT_ERROR_FINISH_DELAY 10000
integer warning_count;
initial warning_count = 0;

reg assertion_off;
initial begin
    if ( $test$plusargs( "assertion_off" ) ) begin
        assertion_off = 1'b1;
    end else begin
        assertion_off = 1'b0;
    end
end

reg asserts_are_warnings_on;
initial begin
    if ( $test$plusargs( "asserts_are_warnings" ) ) begin
        asserts_are_warnings_on = 1'b1;
    end else begin
        asserts_are_warnings_on = 1'b0;
    end
end

reg unit_asserts_are_warnings_on;
initial begin
    if ( $test$plusargs( "unit_asserts_are_warnings" ) ) begin
        unit_asserts_are_warnings_on = 1'b1;
    end else begin
        unit_asserts_are_warnings_on = 1'b0;
    end
end

reg full_chip_asserts_are_warnings_on;
initial begin
    if ( $test$plusargs( "full_chip_asserts_are_warnings" ) ) begin
        full_chip_asserts_are_warnings_on = 1'b1;
    end else begin
        full_chip_asserts_are_warnings_on = 1'b0;
    end
end

integer start_assertion_check;
initial begin
    start_assertion_check=0;
	#1;
	if ($value$plusargs("ASSERT_START_TIME=%d", start_assertion_check)) begin
		//$display("Assertions start getting checked from time %0d",start_assertion_check);
	end 
end

// assertion_error optimized for memory usage
task assertion_error;
  reg supress_msg;
  reg is_error;

  begin
    if ( !assertion_off && ($time>start_assertion_check)) begin

      if
        (  
            (severity_level == 0)
         || (severity_level == 2 && !unit_asserts_are_warnings_on)
         || (severity_level == 3 && !full_chip_asserts_are_warnings_on)
        ) begin
         is_error = asserts_are_warnings_on ? 0 : 1;
      end
      else begin
         is_error = 0;
      end

      if (is_error) begin
         error_count = error_count + 1;
         supress_msg = error_count > `ASSERT_MAX_REPORT_ERROR ? 1 : 0;
      end
      else begin
         warning_count = warning_count + 1;
         supress_msg = warning_count > `ASSERT_MAX_REPORT_WARN ? 1 : 0;
      end

      `ifdef NV_ERROR_PLI
        if (!supress_msg) begin
           if (severity_level == 3) begin
              $display("COVER : %s : : severity %0d : time %0t : %m",
                      msg, severity_level, $time);
           end
           else if (is_error) begin
              $Error("ERROR : %s : : severity %0d : time %0t : %m",
                      msg, severity_level, $time);
           end
           else begin
              $Warning("WARNING : %s : : severity %0d : time %0t : %m",
                      msg, severity_level, $time);
           end
        end
      `else
        if (!supress_msg) begin
           if (is_error) begin
		      $display("ERROR : %s : : severity %0d : time %0t : %m",
                      msg, severity_level, $time);
              #`ASSERT_ERROR_FINISH_DELAY;
              $display("Exiting after assertion failure in module %m");
              $finish;
           end   
           else begin
		      $display("WARNING : %s : : severity %0d : time %0t : %m",
                      msg, severity_level, $time);
           end
        end   
      `endif
    end
  end
endtask


// assertion_error w/ err_msg param uses more memory (several hundred MB across all assertions on gf100)
task assertion_error_msg;
  input [8*15:0] err_msg;
  reg supress_msg;
  reg is_error;

  begin
    if ( !assertion_off && ($time>start_assertion_check)) begin

      if
        (  
            (severity_level == 0)
         || (severity_level == 2 && !unit_asserts_are_warnings_on)
         || (severity_level == 3 && !full_chip_asserts_are_warnings_on)
        ) begin
         is_error = asserts_are_warnings_on ? 0 : 1;
      end
      else begin
         is_error = 0;
      end

      if (is_error) begin
         error_count = error_count + 1;
         supress_msg = error_count > `ASSERT_MAX_REPORT_ERROR ? 1 : 0;
      end
      else begin
         warning_count = warning_count + 1;
         supress_msg = warning_count > `ASSERT_MAX_REPORT_WARN ? 1 : 0;
      end

      `ifdef NV_ERROR_PLI
        if (!supress_msg) begin
           if (severity_level == 3) begin
              $display("COVER : %s : %0s : severity %0d : time %0t : %m",
                      msg, err_msg, severity_level, $time);
           end
           else if (is_error) begin
              $Error("ERROR : %s : %0s : severity %0d : time %0t : %m",
                      msg, err_msg, severity_level, $time);
           end
           else begin
              $Warning("WARNING : %s : %0s : severity %0d : time %0t : %m",
                      msg, err_msg, severity_level, $time);
           end
        end
      `else
        if (!supress_msg) begin
           if (is_error) begin
		      $display("ERROR : %s : %0s : severity %0d : time %0t : %m",
                      msg, err_msg, severity_level, $time);
              #`ASSERT_ERROR_FINISH_DELAY;
              $display("Exiting after assertion failure in module %m");
              $finish;
           end   
           else begin
		      $display("WARNING : %s : %0s : severity %0d : time %0t : %m",
                      msg, err_msg, severity_level, $time);
           end
        end   
      `endif
    end
  end
endtask

task assertion_init_msg;
  begin
    if ( !assertion_off ) begin
      $display("ASSERTION_NOTE: initialized @ %m Severity: %0d, Message: %s",
  	            severity_level, msg);
    end
  end
endtask
			      
