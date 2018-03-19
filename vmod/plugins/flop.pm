#!/usr/bin/env perl

package flop;
use strict;
use warnings FATAL => qw(all);

use Carp qw(croak);
use Getopt::Long qw(GetOptions);
use Text::ParseWords qw(shellwords);

use EperlUtil;

=head1 FLOP

  &eperl::flop("[-en <enable>] [-d <pin>] [-q <pin>] [-nodeclare] [-norange] [-clk <clk>] [-rst <rst> | -norst] [-rval \"<str>\"] [-wid <n>]");

  Required Inputs:
    NONE

  Optional Inputs:
    -d    <pin>  :  name of input pin, "d" by default
    -q    <pin>  :  name of output pin, "q" by default
    
    -en   <pin>  :  name of enable pin, none by default, can be an expression
    -clk  <clk>  :  name of clock, "nvdla_core_clk" by default
    -rst  <rst>  :  name of reset, "nvdla_core_rstn" by default
    -norst       :  remove reset even if you specify -rst
    -rval \"<str>\"  :  reset value, string format, ie, \"5'd10\", or \"4'b1101\"
    -wid  <n>    :  width of input/output pin, 1 by default
    
    -nodeclare   :  turn off declartion of reg and wire, default is on
    -range       :  turn on [msb:lsb] appended on all signals, default is off

  Example:
    &eperl::flop("-wid 20 -rval \"5'd10\"");

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
    
    my $clk   = "nvdla_core_clk";
    my $rst   = "nvdla_core_rstn";
    my $norst = 0;
    my $rval;

    my $field = 0;
    my $declare = 1;
    
    my $indent= 0;
    GetOptions (
               'd=s'        => \$d,
               'q=s'        => \$q,
               'en=s'       => \$en,
               'wid=s'      => \$wid,
               'clk=s'      => \$clk,
               'rst=s'      => \$rst,
               'norst'      => \$norst,
               'range'      => \$field,
               'declare!'   => \$declare,
               'rval=s'     => \$rval,
               'indent=s'   => \$indent,
               )  or die "Unrecognized options @ARGV";
    
    #================================
    # VARIABLE
    #================================
    my $INDENT = " "x$indent;
    
    my $range;
    if ($wid =~ /^\d+$/) {
        my $msb = $wid - 1;
        $range = ($wid>1) ? "[$msb:0]" : "";
    } else {
        $range = "[$wid-1:0]";
    }
    
    my $Q = $field ? $q.$range : $q;
    my $D = $field ? $d.$range : $d;
    my $R = $rval || "'b0";
    my $X = "'bx";
    #================================
    # CODE BODY
    #================================
    #my @code = ();
    vprintl "${INDENT}reg $range $q;" if $declare;
    vprintl "${INDENT}always @(posedge $clk or negedge $rst) begin" unless $norst;
    vprintl "${INDENT}always @(posedge $clk) begin"                     if $norst;
    vprintl "${INDENT}   if (!$rst) begin"                          unless $norst;
    vprintl "${INDENT}       ${Q} <= $R;"                           unless $norst;
    vprintl "${INDENT}   end else begin"                            unless $norst;
    if (defined $en) {
        vprintl "${INDENT}       if (($en) == 1'b1) begin";
        vprintl "${INDENT}           ${Q} <= ${D};";
        vprintl "${INDENT}       // VCS coverage off";
        vprintl "${INDENT}       end else if (($en) == 1'b0) begin";
        vprintl "${INDENT}       end else begin";
        vprintl "${INDENT}           ${Q} <= ${X};";
        vprintl "${INDENT}       // VCS coverage on";
        vprintl "${INDENT}       end";
    } else {
        vprintl "${INDENT}       ${Q} <= ${D};";
    }
    vprintl "${INDENT}   end"                                       unless $norst;
    vprintl "${INDENT}end";

    #================================
    # PRINT OUT
    #================================
    #print $code; 
}

1;
