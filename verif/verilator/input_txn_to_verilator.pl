#!/usr/bin/env perl

use strict;

# Configurable parameters
my $read_reg_poll_retries = 50000;
my $test_dir = '.';
$test_dir = $ARGV[0];

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


my $input_file = "$test_dir/input.txn";
my $output_file = $ARGV[1];

my $inf;
my $ouf;

my $load_file_counter = 0;
my $dump_file_counter = 0;
print "converting $input_file to $output_file\n";
open ($inf, "<", $input_file) || die "Cannot open $input_file";
open ($ouf, ">:raw", $output_file) || die "Cannot open $output_file";

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

    if ($values[0] =~ /wait/) {
      print $ouf pack("C", 1);
    }
    elsif($values[0] =~ /write_reg/) {
      if($size != 3) { die "\nERROR: in write_reg command: $input_line\n" };

      # For CSB, top 16 bits are misc, lower 16 are addr
      my $address = $values[1]; 
      my $data = $values[2];

      print $ouf pack("CLL", 2, hex($address), hex($data));

    } elsif ($values[0] =~ /read_reg/) {
      if($size != 4) { die "\n ERROR: in read_reg command: $input_line\n" };

      my $address;
      my $bitmask;
      my $cmp_mode;
      my $exp_data;
      my $poll_attempts = $read_reg_poll_retries;

      $address = $values[1];
      $bitmask = $values[2];
      $exp_data = $values[3];
      
      print $ouf pack("CLLL", 3, hex($address), hex($bitmask), hex($exp_data));
    } elsif ($values[0] =~ /(load|dump)_mem/) {
      my $addr = $values[1];
      my $offset = $values[2];
      my $mem_in = $values[3];
      my $raw_file;
      my $mem_out;
      my $minf, my $mouf;
      my $cmd;
      
      $cmd = 5 if ($values[0] =~ /load_mem/);
      $cmd = 4 if ($values[0] =~ /dump_mem/);
      
      print $ouf pack("CLL", $cmd, hex($addr), hex($offset));
      open $minf, "<". "$test_dir/$mem_in";

      print "File $load_file_counter $addr $offset\n";
      
      my $totbytes = 0;

      if ($mem_in =~ m/\.dat$/) {
        while(<$minf>)
        {
           chomp;
           my $line = $_;
           next if ($line !~ m/^ ?0x/);
           $line =~ s/ ?0x//g;
           #assuming 32 bytes per line. 1st byte on line goes to addr0
           # So we split into groups of 8 nums (4 bytes) then reverse each byte
           my @bytes = ($line =~ m/([0-9a-z]{2})/g);
           die "Can't parse $line into 32 groups of 2 hex numbers. Got ".scalar(@bytes)." groups" if (scalar(@bytes) != 32);
           foreach my $byte (@bytes) {
             print $ouf pack("C", hex($byte));
           }
           $totbytes += 32;
           if ($totbytes == hex($offset)) {
             print "okay, that's all the bytes I expected -- I'm stopping here\n";
             last;
           }
        }
        die "expected ".hex($offset)." bytes, got $totbytes bytes" if hex($offset) != $totbytes;
      }
      else {
        die "only .dat files supported in this tool so far";
      }
      
      close $minf;
      
      if ($values[0] =~ /dump_mem/) {
       print $ouf pack("L", length($mem_in)) . $mem_in;
      }
    }
#print " HexString: $hex_string" . "\n";
#my @split_hex = ($hex_string =~ m/../g);
#foreach(@split_hex) { print $ouf "$_\n";}
  }

}

print $ouf pack("C", 0xFF);

close $inf;
close $ouf;

1;

