#! /usr/bin/env perl

# ----------------------------------------------------------------------------
#      ___                                   _____                      ___     
#     /__/\          ___        ___         /  /::\       ___          /  /\    
#     \  \:\        /__/\      /  /\       /  /:/\:\     /  /\        /  /::\   
#      \  \:\       \  \:\    /  /:/      /  /:/  \:\   /  /:/       /  /:/\:\  
#  _____\__\:\       \  \:\  /__/::\     /__/:/ \__\:| /__/::\      /  /:/~/::\ 
# /__/::::::::\  ___  \__\:\ \__\/\:\__  \  \:\ /  /:/ \__\/\:\__  /__/:/ /:/\:\
# \  \:\~~\~~\/ /__/\ |  |:|    \  \:\/\  \  \:\  /:/     \  \:\/\ \  \:\/:/__\/
#  \  \:\  ~~~  \  \:\|  |:|     \__\::/   \  \:\/:/       \__\::/  \  \::/     
#   \  \:\       \  \:\__|:|     /__/:/     \  \::/        /__/:/    \  \:\     
#    \  \:\       \__\::::/      \__\/       \__\/         \__\/      \  \:\    
#     \__\/           ~~~~                                             \__\/    
#                                     ___                            ___   
#         _____                      /  /\             ___          /  /\  
#        /  /::\                    /  /::\           /  /\        /  /::\ 
#       /  /:/\:\                  /  /:/\:\         /  /:/       /  /:/\:\
#      /  /:/  \:\   __      __   /  /:/~/::\       /__/::\      /  /:/~/:/
#     /__/:/ \__\:/ /__/\   /  /\/__/:/ /:/\:\      \__\/\:\__  /__/:/ /:/ 
#     \  \:\ /  /:/ \  \:\ /  /:/\  \:\/:/__\/         \  \:\/\ \  \:\/:/  
#      \  \:\  /:/   \  \:\  /:/  \  \::/               \__\::/  \  \::/   
#       \  \:\/:/     \  \:\/:/    \  \:\               /__/:/    \  \:\   
#        \  \::/       \  \::/      \  \:\              \__\/      \  \:\  
#         \__\/         \__\/        \__\/                          \__\/  
# ----------------------------------------------------------------------------
#
# Simple log checker for pass fail status
#
# ----------------------------------------------------------------------------

use strict;
use warnings;

my $show_time = 1;

if ($show_time) {
use Time::Local;
}


my $testdir = $ARGV[0];
my $log = "";
my $testfile = "";
if (-d $testdir) {
  $testfile = $ARGV[1];
  $log = "$testdir/${testfile}.log";
  if (-e $log) {
  } else {
    print (sprintf "checktest : NOTRUN : %-40s : no log found : please kick off with make run TESTDIR=%0s \n",$testdir,$testdir) ;
    # print "UNEXPECTED INPUT0  testdir=$testdir  testfile=$testfile\n"; exit 1;
    exit 0;
  }

} else {
  if ($testdir =~ m/(\S+)\/([a-z0-9A-Z\.]+)$/) {
    $testdir = $1;
    $log = $2;
  } else {
    print "UNEXPECTED INPUT1\n"; exit 1;
  }
}

if ($#ARGV >= 1) {
 $log = "$testdir/${testfile}.log";
} else {
 $log = "$testdir/input.txn.log";
}
my $iface_errors_ok = 1;
my $found_uvm_msgs  = 0;
my $runstart = 0;
my $runend = 0;
my $expect_end_time_next = 0;
my $errors = 0;
my $start_found = 0;
my $end_found = 0;
my $start_month = "";
my $start_day = 0;
my $start_hr = 0;
my $start_min = 0;
my $start_year = 0;
my $end_month = "";
my $end_day = 0;
my $end_hr = 0;
my $end_min = 0;
my $end_sec = 0;
my $end_year = 0;


if (-e $log) {

   open (FH,"<$log");

   my $fatalerrors = 0;
      $errors = 0;
   my $drivers_idled = 0;
   my $shutdown_completed = 0;
   my $transaction_num = 0;

   while (<FH>) {
     my $line = $_;
     if ($line =~ m/^\s*UVM_ERROR.*@/) {
        $errors = $errors + 1;
     }
     if ($line =~ m/^\s*UVM_FATAL\s+:\s+(\d+)/) {
        $fatalerrors = $fatalerrors + $1;
        $errors = $errors + $fatalerrors;
        $found_uvm_msgs = 1;
     }
     if ($line =~ m/Waiting for drivers to idle/) {
        $drivers_idled = 1;
     } elsif ($line =~ m/Shutting down/) {
        $shutdown_completed = 1;
     } elsif ($line =~ m/Starting transaction (\d+)/) {
        $transaction_num = $1;
     } elsif ($line =~ m/Compiler .*\;\s+(\S+)\s+(\d+)\s+(\d+):(\d+)\s+(\d+)/) {
         $start_month = $1;
         $start_day = $2;
         $start_hr = $3;
         $start_min = $4;
         $start_year = $5;
         $start_found = 1;
     } elsif ($line =~ m/^CPU Time:/) {
         $expect_end_time_next = 1;
     } elsif ($expect_end_time_next) {
       if ($line =~ m/\s*\S+\s+(\S+)\s+(\d+)\s+(\d+):(\d+):(\d+)\s+(\d+)/) {
         $end_month = $1;
         $end_day = $2;
         $end_hr = $3;
         $end_min = $4;
         $end_sec = $5;
         $end_year = $6;
         $end_found = 1;
       }
     }
   }
  my %month2num = ();
     $month2num{"Jan"} = 0;
     $month2num{"Feb"} = 1;
     $month2num{"Mar"} = 2;
     $month2num{"Apr"} = 3;
     $month2num{"May"} = 4;
     $month2num{"Jun"} = 5;
     $month2num{"Jul"} = 6;
     $month2num{"Aug"} = 7;
     $month2num{"Sep"} = 8;
     $month2num{"Oct"} = 9;
     $month2num{"Nov"} = 10;
     $month2num{"Dec"} = 11;
  my $total_time = 0;
  my $total_time_string = "";
  if ($show_time && $start_found && $end_found) {
     my @startday = (0, $start_min, $start_hr, $start_day, $month2num{"$start_month"}, $start_year);
     my $startseconds = timelocal(@startday);
     my @endday = (0, $end_min, $end_hr, $end_day, $month2num{"$end_month"}, $end_year);
     my $endseconds = timelocal(@endday);
     $total_time = (($endseconds - $startseconds) / 60) / 60;
     $total_time_string = sprintf(": runtime was approximately %.2f hours",$total_time);
  }

   # Add other checks of the log file as it becomes necessary

   close(FH);

   my $dumpdiff_passed = 1;
   my $dumpdiff_string = "";
   my @dump_files = glob("$testdir/*chiplib_dump.raw");
   foreach(@dump_files) {
        chomp($_);
        my $replay_file = $_;
        $replay_file =~s/chiplib_dump/chiplib_replay/;
        if(!(-e $replay_file)) { 
            $dumpdiff_passed = 0;
            $dumpdiff_string .= "Did not find dump file $replay_file, could not compare. ";
        } else {
            my @cmp = `cmp $_ $replay_file`;
            if(scalar @cmp > 0) {
                $dumpdiff_passed = 0;
                $dumpdiff_string .= "Found mismatches between $_ and $replay_file. ";
            }
        }
   }
   my $num_dumps = scalar @dump_files;
   if($dumpdiff_passed && $num_dumps > 0) {
        $dumpdiff_string .= "($num_dumps of $num_dumps dump files matched)";
   }
   

    my $plural = "";
    my $pluralfatal = "";
    if ($errors == 0 && $found_uvm_msgs && $dumpdiff_passed) {
        # NO errors found - declare a pass.
        print sprintf( "checktest : PASSED : %-40s ${total_time_string} ${dumpdiff_string}",$testdir) . "\n" ;
    } elsif(!$found_uvm_msgs) {
         # NO uvm messages found - declare probably RUNNING .
         my $inputfile = "$testdir/input.txn";
         #open(FHI,"<$inputfile");
         #my $filesize = @{[<FHI>]}; ; #Out of memory!
         my $filesize = `wc -l $inputfile | cut -d ' ' -f1`;
         print sprintf( "checktest : RUNNING: %-40s : approximately %2.1f percent done. ",$testdir,100*($transaction_num/$filesize));
         if($errors > 0) {
            print sprintf( "(%d errors found)", $errors );
         } else {
            print "(no errors found)";
         }
         print "\n";
    } else {
       if (($fatalerrors == 0) && ($iface_errors_ok)) {
         # errors found but non fatal
         if ($errors > 1) {$plural = "s";} else {$plural = "";}
         print sprintf( "checktest : FAILED : %-40s : all transactions completed : with %0d error${plural}. $dumpdiff_string",$testdir,$errors) . "\n";
       } else {
       # errors found
         if ($errors > 1) {$plural = "s";} else {$plural = "";}
         if ($fatalerrors > 1) {$pluralfatal = "s";} else {$pluralfatal = "";}
       print sprintf( "checktest : FAILED : %-40s with %0d error${plural} : %0d fatal error${pluralfatal} : see $log for details. $dumpdiff_string",$testdir,$errors,$fatalerrors) . "\n" ;
       }
    }

} else {
   # Log file not found
   print (sprintf "checktest : NOTRUN : %-40s : no log found : please kick off with make run TESTDIR=%0s \n",$testdir,$testdir) ;
}

my @perf = `./perfcheck.pl $testdir`;
foreach(@perf){ print "checkperf : $_"; }

exit;
