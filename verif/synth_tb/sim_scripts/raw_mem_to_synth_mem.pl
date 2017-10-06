#!/usr/bin/env perl

use strict;

####################################################
# Input is a file containing bytes (one per line), output contains one word per line for the synthesizable memory


my $input_file;
my $output_file;

my $inf;
my $ouf;

my $word_bytes = 32/8; #This is the number of lines (bytes) read in to produce one line (word) of output

if(scalar(@ARGV) < 1) {
   die "Usage: raw_mem_to_synth_mem.pl input_file.raw [...] " . scalar(@ARGV);
}

for(my $i = 0; $i < scalar(@ARGV); $i++) {
   my $firstLineFlag = 1;
   $input_file = $ARGV[$i];
   if( $input_file =~ /.*\.raw2/) {
      $output_file = substr $input_file, 0, -1;
      
      open $inf, "<". $input_file;
      open $ouf, ">". $output_file;
      
      my $output_line = "";
      
      while(<$inf>)
      {
         chomp;

         my $input_line = $_;
         if (($firstLineFlag != 1) || ($input_line !~ /^\@[0-9a-fA-F]+/)) {
           $firstLineFlag = 0;
           my $offset = length($input_line) - 2;
           while($offset >= 0) {
              print $ouf substr($input_line, $offset, 2) . "\n";
              $offset -= 2;
           }
         }
      }
   } else {
      $output_file = $input_file;
      $output_file .= "2";
      
      open $inf, "<". $input_file;
      open $ouf, ">". $output_file;
      
      my $output_line = "";
      
      while(<$inf>)
      {
         chomp;
         $output_line = $_ . $output_line;
         if(length($output_line) == 2*$word_bytes) {
            print $ouf $output_line . "\n";
            $output_line = "";
         }
      }
      if(length($output_line)) {
         print $ouf $output_line . "\n";
         $output_line = "";
      }
   }
   close $inf;
   close $ouf;
}
