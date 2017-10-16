#! /home/utils/perl-5.8.8/bin/perl

package eplugin;
use strict;
use warnings FATAL => qw(all);

use Carp qw(croak);
use Getopt::Long qw(GetOptions);
use Text::ParseWords qw(shellwords);

=head1 FLOP

  &eplugin::flop [-en <enable>] [-d <pin>] [-q <pin>] [-clk <clk>] [-rst <rst>] [-rval <hex>] [-wid <value>]

  Required Inputs:
    NONE

  Optional Inputs:
    -d    <pin>  :  name of input pin, "d" by default
    -q    <pin>  :  name of output pin, "q" by default
    
    -en   <pin>  :  name of enable pin, none by default 
    -clk  <clk>  :  name of clock, "clk" by default
    -rst  <rst>  :  name of reset, "rst" by default
    -rval <hex>  :  reset value in hex, 0 by default
    -wid  <num>  :  wid of input/output pin, 1 by default

=cut

sub flop {
    my $args = shift;
    @ARGV = shellwords($args);
    
    #================================
    # OPTIONS
    #================================
    my $d     = "d";
    my $q     = "q";
    my $en    = "en";
    my $wid   = 1;
    
    my $clk   = "clk";
    my $rst   = "rst";
    my $rval  = 0;
    
    my $indent= 2;
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

    my $msb = eval($wid-1);
    my $range = "$msb:0";
    
    my $Q = "$q"."[$range]";
    my $D = "$d"."[$range]";
    #================================
    # CODE BODY
    #================================
    my @code = ();
    push @code, "${INDENT}always (posedge $clk or negedge $rst) begin";
    push @code, "${INDENT}   if (!$rst) begin";
    push @code, "${INDENT}       ${Q} <= ${wid}'h${rval};";
    push @code, "${INDENT}   end else begin";
    if (defined $en) {
        my $X = "{".$wid."{1'bx}"."}";
        push @code, "${INDENT}       if ($en == 1'b1) begin";
        push @code, "${INDENT}           ${Q} <= ${D};";
        push @code, "${INDENT}       // VCS coverage off";
        push @code, "${INDENT}       end else if ($en == 1'b0) begin";
        push @code, "${INDENT}       end else begin";
        push @code, "${INDENT}           ${Q} <= ${X};";
        push @code, "${INDENT}       // VCS coverage on";
        push @code, "${INDENT}       end";
    } else {
        push @code, "${INDENT}       ${Q} <= ${D};";
    }
    push @code, "${INDENT}   end";
    push @code, "${INDENT}end";

    my $code = join("\n",@code);
    $code .= "\n";

    #================================
    # PRINT OUT
    #================================
    print $code; 
}

=head1 PIPE

  &eplugin::pipe TODO

  Required Inputs:
    TODO

  Optional Inputs:
    TODO
   
=cut

sub pipe {
}

=head1 ARB

  &eplugin::arb TODO

  Required Inputs:
    TODO

  Optional Inputs:
    TODO
   
=cut

sub arb {
}

1;

