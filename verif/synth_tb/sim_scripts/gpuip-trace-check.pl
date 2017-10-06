#! /usr/bin/env perl

# Simple trace validation.
# Ideally the file format would include some form of checksum in a comment field!
# Without that we simply check that trace files being loaded exist and have the
# correct number of bytes.

# usage: gpuip-trace-check.pl input.txn.raw

# From syn_tb_defines.vh :
$MSEQ_OP_REG_WRITE = "00";
$MSEQ_OP_REG_READ  = "01";
$MSEQ_OP_MEM_WRITE = "02";
$MSEQ_OP_MEM_READ  = "03";
$MSEQ_OP_MEM_LOAD  = "04";
$MSEQ_OP_MEM_DUMP  = "05";
$MSEQ_OP_WAIT      = "06";
$MSEQ_OP_DONE      = "ff";

$path="$ARGV[0]" if ($ARGV[0]=~/\//);;
$path=~s,(^.*/)(.*),\1,g;
while (<>) {
  s/\_//g;
  s/\s//g;
  ($file,$op,$addr,$data,$mask,$compare,$npolls) = /(.*)(..)(..........)(........)(....)(....)(....)$/;

  if ($op eq $MSEQ_OP_MEM_LOAD) {
    $file =~ s/(([0-9a-f][0-9a-f])+)/pack('H*', $1)/ie;
    print "Checking $file @ $addr ($data bytes)... ";
    $file="$path".$file;

    open(F, "<$file") || die("Unable to open $file for reading!\n");
    $cnt = 0;
    while (<F>) {
      s/\_//g;
      s/\s//g;
      s/([0-9a-fA-f][0-9a-fA-F])/x/g;
      $cnt += length;
    }
    $expected = hex("0x" . $data);
    if ($expected != $cnt) {
      print "\n";
      die "MISMATCH - expected $expected - file contains $cnt bytes!!\n";
    }
    print "ok\n";
    close(F);
  }

  if ($op eq $MSEQ_OP_MEM_DUMP) {
    $file =~ s/(([0-9a-f][0-9a-f])+)/pack('H*', $1)/ie;
    print "Dump $file @ $addr ($data bytes)\n";
  }
}
