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
  $log = "$testdir/$testfile";
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

      $errors = 0;
   my $transaction_num = 0;

   while (<FH>) {
     my $line = $_;
     if ($line =~ m/.*ERROR.*/) {
        $errors = $errors + 1;
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
   my @dump_files = glob("$testdir/*chiplib_dump.raw2");
   my $dump_files_size=@dump_files;
   print "Warning: could not find any golden $testdir/*chiplib_dump.raw2\n" unless $dump_files_size;
   if ($dump_files_size) {
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
                  # Cadence emulator prints the address at the beginning; try stripping off the first line and cmp again
                  @cmp = `tail --lines=+2 $replay_file | cmp $_`;
                  if(scalar @cmp > 0) {
                      $dumpdiff_passed = 0;
                      $dumpdiff_string .= "Found mismatches between $_ and $replay_file. ";
                  }
              }
          }
       }
       my $num_dumps = scalar @dump_files;
       if($dumpdiff_passed && $num_dumps > 0) {
            $dumpdiff_string .= "($num_dumps of $num_dumps dump files matched)";
       }
   }

    my $plural = "";
    my $pluralfatal = "";
    if ($errors == 0) {
        if($dumpdiff_passed == 0) {
            print sprintf( "checktest : FAILED : %-40s : all transactions completed with no errors but dump_mem mismatched: $dumpdiff_string",$testdir) . "\n";
        } else {
            # NO errors found - declare a pass.
            print sprintf( "checktest : PASSED : %-40s ${total_time_string} ${dumpdiff_string}",$testdir) . "\n" ;
        }
    } else {
        print sprintf( "checktest : FAILED : %-40s : all transactions completed : with %0d error${plural}. $dumpdiff_string",$testdir,$errors) . "\n";
    }

} else {
   # Log file not found
   print (sprintf "checktest : NOTRUN : %-40s : no log found : please kick off with make run TESTDIR=%0s \n",$testdir,$testdir) ;
}

# TODO: Need perf script
#my @perf = `./perfcheck.pl $testdir`;
#foreach(@perf){ print "checkperf : $_"; }

exit;
