#!/usr/bin/env perl

package eperl;
use strict;
use warnings FATAL => qw(all);

# add plugin below, and check the usege in each package in the directory
use flop;
use pipe;
use retime;
use assert;
use fifo;
use ram;
 
sub vprintl {
  my @list = @_;
  foreach my $item (@list) {
    print $item, "\n";
  } 
} 
    

sub vprinti {
  my @list = @_;
  my $item;
  my $line;
  foreach $item (@list) {
    foreach $line (split ("\n", $item)) {
      next unless ($line =~ s/^\s*\|\s?//);
      print "$line\n";
    }
  }
}
1;
