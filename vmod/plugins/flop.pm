#!/usr/bin/env perl

package flop;
use strict;
use warnings FATAL => qw(all);

use Carp qw(croak);
use Getopt::Long qw(GetOptions);
use Text::ParseWords qw(shellwords);

use EperlUtil;

=head1 FLOP

  &eperl::flop("[-en <enable>] [-d <pin>] [-q <pin>] [-clk <clk>] [-rst <rst>] [-rval <bool>] [-wid <n>]");

  Required Inputs:
    NONE

  Optional Inputs:
    -d    <pin>  :  name of input pin, "d" by default
    -q    <pin>  :  name of output pin, "q" by default
    
    -en   <pin>  :  name of enable pin, none by default 
    -clk  <clk>  :  name of clock, "clk" by default
    -rst  <rst>  :  name of reset, none by default
    -rval <bool> :  reset value, 0 means all bit are low, 1 means all bits are high
    -wid  <n>    :  width of input/output pin, 1 by default

=cut

use base ("Exporter");
our @EXPORT = qw(flop);

sub flop {
    my $args = shift;
    @ARGV = shellwords($args);
    
    #================================
    # OPTIONS
    #================================
    my $d     = "d";
    my $q     = "q";
    my $en;
    my $wid   = 1;
    
    my $clk   = "clk";
    my $rst;
    my $rval  = 0;
    
    my $indent= 0;
    GetOptions (
               'd=s'  => \$d,
               'q=s'  => \$q,
               'en=s'  => \$en,
               'wid=s'  => \$wid,
               'clk=s'     => \$clk,
               'rst=s'     => \$rst,
               'rval=s'    => \$rval,
               'indent=s'  => \$indent,
               )  or die "Unrecognized options @ARGV";
    
    #================================
    # VARIABLE
    #================================
    my $INDENT = " "x$indent;

    my $range = "$wid-1:0";
    
    my $Q = "$q"."[$range]";
    my $D = "$d"."[$range]";
    my $R = "{".$wid."{1'b".$rval."}"."}";
    my $X = "{".$wid."{1'bx}"."}";
    #================================
    # CODE BODY
    #================================
    #my @code = ();
    vprintl "${INDENT}reg [$range] $q;";
    vprintl "${INDENT}always @(posedge $clk or negedge $rst) begin" if $rst;
    vprintl "${INDENT}always @(posedge $clk) begin"             unless $rst;
    vprintl "${INDENT}   if (!$rst) begin"                          if $rst;
    vprintl "${INDENT}       ${Q} <= $R;"                           if $rst;
    vprintl "${INDENT}   end else begin"                            if $rst;
    if (defined $en) {
        vprintl "${INDENT}       if ($en == 1'b1) begin";
        vprintl "${INDENT}           ${Q} <= ${D};";
        vprintl "${INDENT}       // VCS coverage off";
        vprintl "${INDENT}       end else if ($en == 1'b0) begin";
        vprintl "${INDENT}       end else begin";
        vprintl "${INDENT}           ${Q} <= ${X};";
        vprintl "${INDENT}       // VCS coverage on";
        vprintl "${INDENT}       end";
    } else {
        vprintl "${INDENT}       ${Q} <= ${D};";
    }
    vprintl "${INDENT}   end"                                       if $rst;
    vprintl "${INDENT}end";


    #================================
    # PRINT OUT
    #================================
    #print $code; 
}

1;
