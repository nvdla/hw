#!/usr/bin/env perl

package EperlUtil;
use strict;
use warnings FATAL => qw(all);
 
use base ("Exporter");
our @EXPORT = qw(
    vprintl
    vprinti
    );

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
