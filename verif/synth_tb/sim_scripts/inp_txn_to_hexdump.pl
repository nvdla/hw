#!/usr/bin/env perl

use strict;
my $memW="$ARGV[0]";

####################################################
# Following decoding for the commands
#
# 7 commands at most - 3 bits encode
# write_reg - 3'b000
# read_reg  - 3'b001
# write_mem - 3'b010
# read_mem  - 3'b011
# load_mem  - 3'b100
# dump_mem  - 3'b101
# wait      - 3'b110

# Each command is constant width - for the sequencer - 120 bits - pad 0's accordingly
# write_req     : cmd_addr_data
# read_reg      : cmd_addr_data_bmask_cmpmode_pollattmpt
# load/dump_mem : cmd_addr_offset
# Write_reg     : 00_00000000_00000000
# Read_reg      : 00_00000000_00000000_00000000_00_0000
# Load/Dump_mem : 00_0000000000_00000000

# Configurable parameters
my $read_reg_poll_retries = 50000;
my $word_bytes=32/8;
my $test_dir = '.';
my $output_test_dir = '.';
if($memW eq '256'){
   print "256 memory width\n";
   $word_bytes = 256/8; #This is the number of lines (bytes) read in to produce one line (word) of output
   $test_dir = $ARGV[1];
} elsif($memW eq '32'){
   $test_dir = $ARGV[1];
   print "32 memory width\n";
}else{
   # For VCS simulation, put the input.txn.raw file in the sim directory
   print "default 32 memory width\n";
   $test_dir = $ARGV[0];
}

# Creating a hash for the above - command - hex val
my %command_hash = (
    'write_reg' => '00',
    'read_reg'  => '01',
    'write_mem' => '02',
    'read_mem'  => '03',
    'load_mem'  => '04',
    'dump_mem'  => '05',
    'wait'      => '06',
);

my %MSEQ_defines;
populate_mseq_defines("../../synth_tb/syn_tb_defines.vh", \%MSEQ_defines);

my $input_file = "$test_dir/input.txn";
my $output_file = "$output_test_dir/input.txn.raw";

my $inf;
my $ouf;

my $load_file_counter = 0;
my $dump_file_counter = 0;
print "accessing $input_file\n";
open ($inf, "<", $input_file) || die "Cannot open $input_file";
open ($ouf, ">", $output_file) || die "Cannot open $output_file";

# SW Reset sequence from master_seq.sv
#write_reg("write_reg 0x27000200 0x00000000", 0); 
#write_reg("write_reg 0x27000200 0xffffffff", 0); 
#write_reg("write_reg 0x27000200 0x00000000", 0); 
#write_reg("write_reg 0x27000200 0xffffffff", 1); 
#write_reg("write_reg 0x27000200 0xc0012020", 1); 

#my @sw_reset_seq = (
#    "write_reg 0x27000200 0x00000000", 
#    "write_reg 0x27000200 0xffffffff", 
#    "write_reg 0x27000200 0x00000000", 
#    "write_reg 0x27000200 0xffffffff", 
#    "write_reg 0x27000200 0xc0012020" 
#);
#
#my $cmd;
#foreach $cmd (@sw_reset_seq) {
## Right now sw_reset_seq only has write_reg
#    my @values = split (' ', $cmd);
#    my $hex_string = $command_hash{$values[0]};
#
#    my $address = $values[1];
#    my $data = $values[2];
#
#    $address =~ m/0x(.*)/;
#    my $hex_addr = $1;
#    $data =~ m/0x(.*)/;
#    my $hex_data = $1;
#
#    $hex_string = $hex_string.$hex_addr.$hex_data;
#
#    # Pad extra 0's to maintain cmd length of 128 bits
#    $hex_string = $hex_string."00000000000000";
#    print $ouf "$hex_string\n";
#}

while(<$inf>)
{
  my $input_line = $_;
  $input_line =~ s/#.*//;
  my @values = split (' ', $input_line);
  #print "\n" . $input_line . "\n";

  my $size = scalar (split(' ', $input_line));
  #print "\nSIZE: ". $size . "\n";

  if($size != 0) {

    my $hex_string = $command_hash{$values[0]};
    #print $values[0] . "\t HexVal: " . $hex_string;

    if ($values[0] =~ /wait/) {
      $hex_string = $hex_string."000000000000000000000000000000";
    }
    elsif($values[0] =~ /write_reg/) {
      if($size != 3) { die "\nERROR: in write_reg command: $input_line\n" };

      # For CSB, top 16 bits are misc, lower 16 are addr
      my $address = $values[1]; 
      my $data = $values[2];

      $address =~ m/0x(.*)/;
      my $hex_addr = hex($1); 
      my $hex_addr_string = sprintf("%08x", $hex_addr);
      $data =~ m/0x(.*)/;
      my $hex_data = hex($1);
      my $hex_data_string = sprintf("%08x", $hex_data);

      # Pad extra 0's to maintain cmd length of 128 bits
      my $padding = (($MSEQ_defines{'MSEQ_MASK_BITS'}{'high'} - $MSEQ_defines{'MSEQ_MASK_BITS'}{'low'} + 1) + ($MSEQ_defines{'MSEQ_COMPARE_BITS'}{'high'} - $MSEQ_defines{'MSEQ_COMPARE_BITS'}{'low'} + 1) + ($MSEQ_defines{'MSEQ_NPOLLS_BITS'}{'high'} - $MSEQ_defines{'MSEQ_NPOLLS_BITS'}{'low'} + 1))/4;
      #print "(($MSEQ_defines{'MSEQ_MASK_BITS'}{'high'} - $MSEQ_defines{'MSEQ_MASK_BITS'}{'low'} + 1) + ($MSEQ_defines{'MSEQ_COMPARE_BITS'}{'high'} - $MSEQ_defines{'MSEQ_COMPARE_BITS'}{'low'} + 1) + ($MSEQ_defines{'MSEQ_NPOLLS_BITS'}{'high'} - $MSEQ_defines{'MSEQ_NPOLLS_BITS'}{'low'} + 1))/4 $padding\n";
      my $padding_string = '0'x$padding;
      $hex_string = $hex_string.$hex_addr_string.$hex_data_string.$padding_string;
      #print "$hex_string\n";
    } elsif ($values[0] =~ /read_reg/) {
      if($size < 4) { die "\n ERROR: in read_reg command: $input_line\n" };

      my $address;
      my $bitmask;
      my $cmp_mode;
      my $exp_data;
      my $poll_attempts = $read_reg_poll_retries;

      if($size == 6) {
        $address = $values[1];
        $bitmask = $values[2];
        $cmp_mode = $values[3];
        $exp_data = $values[4];
        $poll_attempts = $values[5];
      }
      if($size == 5) {
        $address = $values[1];
        $bitmask = $values[2];
        $cmp_mode = $values[3];
        $exp_data = $values[4];
      }

      if($size < 5) {
        $address = $values[1];
        $bitmask = $values[2];
        $cmp_mode = "==";
        $exp_data = $values[3];
      }

      $address =~ m/0x(.*)/;
      my $hex_addr = sprintf("%08x", hex($1));
      $bitmask =~ m/0x(.*)/;
      my $hex_bmask = sprintf("%08x", hex($1));
      $exp_data =~ m/0x(.*)/;
      my $hex_data = sprintf("%08x", hex($1));
      my $hex_cmp;
      if($cmp_mode =~ /==/) { $hex_cmp = "00";}
      if($cmp_mode =~ /<=/) { $hex_cmp = "01";}
      if($cmp_mode =~ />=/) { $hex_cmp = "02";}
      my $hex_patmpt = sprintf("%04x", $poll_attempts);

      $hex_string = $hex_string.$hex_addr.$hex_data.$hex_bmask.$hex_cmp.$hex_patmpt;
    } elsif ($values[0] =~ /(load|dump)_mem/) {
      my $addr = $values[1];
      my $offset = $values[2];
      my $mem_in = $values[3];
      my $raw_file;
      my $mem_out;
      my $minf, my $mouf;
      if($values[0] =~ /load_mem/) {
         #Convert loaded file to the appropriate width of the memory
         $raw_file = $load_file_counter . ".raw2";
         $mem_out = $raw_file;
         
         open $minf, "<". "$test_dir/$mem_in";
         open $mouf, ">". $mem_out;
         
         $load_file_counter++;
      } else {
         #Convert chiplib_dump file to the appropriate width of the memory so it can be compared
         #directly to the dumped chiplib_replay file
         $raw_file = $dump_file_counter . ".chiplib_replay.raw2";
         $mem_in =~ s/chiplib_replay/chiplib_dump/g;
         $mem_out = $raw_file;
         $mem_out =~ s/chiplib_replay/chiplib_dump/g;
         
         open $minf, "<". "$test_dir/$mem_in";
         open $mouf, ">". $mem_out;
         
         $dump_file_counter++;
      }
      my $output_line = "";
      
      #Convert the appropriate file from one byte per line to $word_bytes per line
      my $alignment_offset = 0;
      if($memW eq '256'){
         #Find the number of bytes needed to align the file to the 256-bit memory
         $alignment_offset = hex($addr) % (256/8);
         #Convert to nybbles; we count in hex characters.
         $alignment_offset *= 2;
      }
      print "File $load_file_counter $addr $offset $alignment_offset\n";

      if ($mem_in =~ m/\.dat$/) {
        while(<$minf>)
        {
           chomp;
           my $line = $_;
           next if ($line !~ m/^ ?0x/);
           $line =~ s/ ?0x//g;
           #assuming 32 bytes per line. 1st byte on line goes to addr0
           # So we split into groups of 8 nums (4 bytes) then reverse each byte
           my @bytes = ($line =~ m/([0-9a-z]{8})/g);
           die "Can't parse $line into 8 groups of 8 hex numbers. Got ".scalar(@bytes)." groups" if (scalar(@bytes) != 8);
           foreach my $byte (@bytes) {
               my @little_bytes = ($byte =~ m/([0-9a-z]{2})/g);
               foreach my $little_byte (reverse @little_bytes) {
                 print $mouf $little_byte;
               }
               print $mouf "\n";
               $output_line = "";
               $alignment_offset = 0;
          }
        }
      }
      else {
        while(<$minf>)
        {
           chomp;
           $output_line = $_ . $output_line;
           if((length($output_line) + $alignment_offset) == 2*$word_bytes) {
             print $mouf $output_line . "\n";
              $output_line = "";
              $alignment_offset = 0;
           }
        }
        if(length($output_line)) {
           print $mouf $output_line . "\n";
           $output_line = "";
        }
      }

      close $minf;
      close $mouf;
      
      #Write the command with the modified filename (1.raw2, 1.chiplib_replay.raw2, etc.) to the output file.
      #$addr =~ m/0x(.*)/;
      my $hex_addr = hex($addr);
      $hex_addr = sprintf("%016x",$hex_addr);
      #$offset =~ m/0x(.*)/;
      my $hex_offset = hex($offset);
      $hex_offset = sprintf("%08x",$hex_offset);
      $raw_file =~ s/(.)/sprintf("%x",ord($1))/eg;
      $hex_string = $raw_file . "_" .$hex_string . "_" . $hex_addr . "_" . $hex_offset;

      # Pad extra 0's to maintain cmd length of 120 bits
      $hex_string = $hex_string."_00_0000";
    }
    print $ouf "$hex_string\n";
#print " HexString: $hex_string" . "\n";
#my @split_hex = ($hex_string =~ m/../g);
#foreach(@split_hex) { print $ouf "$_\n";}
  }

}

my $end_of_test = "FF000000000000000000000000000000";
print $ouf "$end_of_test";
#my @split_hex = ($end_of_test =~ m/../g);
#foreach(@split_hex) { print $ouf "$_\n";}

close $inf;
close $ouf;

1;

sub populate_mseq_defines {
  my $file = shift;
  my $hash_r = shift;
  open(DEFINES, "<", $file) || die "Cannot open $file";
  while (<DEFINES>) {
    my $line = $_;
    $line =~ s/\/\/.*//g; #Make more robust for multiline comments
    if ($line =~ m/`define\s+(MSEQ\w+)\s([\d:]+)/) {
      my $define = $1;
      my $highlow = $2;
      my $high = $2;
      my $low = $2;
      if ($highlow =~ m/(\d+):(\d+)/) {
        $high = $1;
        $low = $2;
      }
      $$hash_r{$define}{'high'} = $high;
      $$hash_r{$define}{'low'} = $low;
    }
  }
  close DEFINES;
}
