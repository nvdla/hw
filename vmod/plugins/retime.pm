#!/usr/bin/env perl

package retime;
use strict;
use warnings FATAL => qw(all);

use Carp qw(croak);
use Getopt::Long qw(GetOptions);
use Text::ParseWords qw(shellwords);

=head1 retime

  &eperl::retime("-i <sig> -o <sig> [-wid <n>] [-stage <n>] [-clk <clk>] [-cg_en_i <sig>] [-cg_en_o <sig>] [-cg_en_rtm]");

  OPTIONS:
    Required:

    Optional:
      -i   <sig>      : input bus name, sig_i by default
      -o   <sig>      : output bus name, sig_o by default

      -clk <clk>      : clock name, default is nvdla_core_clk
      -wid <n>        : width of the bus, default is 1

      -stage <n>      : number of stage bus will be retimed (0 is feedthrough), 1 by default

      -cg_en_i <sig>  : input clock enable signal to gate the bus, none by default
      -cg_en_o <sig>  : output clock enable signal from cg_en_i, with retime or assign according to option of -cg_en_rtm 
      -cg_en_rtm      : cg_en_o is retimed along with the bus, default is assign from, not retimed

=cut

use base ("Exporter");
our @EXPORT = qw(retime);

sub retime {
    my $args = shift;
    @ARGV = shellwords($args);
    
    #================================
    # OPTIONS
    #================================
    my $sig_i     = "sig_i";
    my $sig_o     = "sig_o";
    
    my $wid   = 1;
    my $stages= 1;
    
    my $clk   = "nvdla_core_clk";
    
    my $cg_en_i;
    my $cg_en_o;
    my $cg_en_rtm;
    
    my $indent = 0;
    GetOptions (
               'i=s'       => \$sig_i,
               'o=s'       => \$sig_o,
               'wid=s'     => \$wid,
               'stage=s'   => \$stages,
               'clk=s'     => \$clk,
               'cg_en_i=s' => \$cg_en_i,
               'cg_en_o=s' => \$cg_en_o,
               'cg_en_rtm' => \$cg_en_rtm,
               'indent=s'  => \$indent,
               )  or die "Unrecognized options @ARGV";
    
    #================================
    # VARIABLE
    #================================
    my $INDENT = " "x$indent;

    my $range = ($wid == 1) ? "" : "[$wid-1:0]";
    
    #================================
    # CODE BODY
    #================================
    my @code = ();
    
    # Retiming
    my $sig_cur=$sig_i;
    my $cg_en_cur = $cg_en_i;
    my $cg_en_str="";

    foreach my $stage (1..$stages) {
        $cg_en_str = "($cg_en_cur)" if $cg_en_i;
        my $sig_nxt = $sig_i."_d$stage";

        my $SIG_NXT = $sig_nxt.$range;
        my $SIG_CUR = $sig_cur.$range;
        
        push @code, "${INDENT}reg $range $sig_nxt;";
        push @code, "${INDENT}always @(posedge $clk) begin";
        push @code, "${INDENT}    if ($cg_en_str) begin" if $cg_en_i;
        push @code, "${INDENT}        $SIG_NXT <= $SIG_CUR;";
        push @code, "${INDENT}    end" if $cg_en_i;
        push @code, "${INDENT}end";
        push @code, "";
        
        $sig_cur = $sig_nxt;
        
        if ($cg_en_rtm) {
            my $cg_en_nxt = $cg_en_i."_d$stage";
            if ($stage < $stages or $cg_en_o) {
                push @code, "${INDENT}reg $cg_en_nxt;";
                push @code, "${INDENT}always @(posedge $clk) begin";
                push @code, "${INDENT}    $cg_en_nxt <= $cg_en_cur;";
                push @code, "${INDENT}end";
                push @code, "";
            }
            $cg_en_cur = $cg_en_nxt;
        }
    }

    ### OUTPUT
    # bus
    push @code, "${INDENT}wire $range $sig_o;";
    push @code, "${INDENT}assign $sig_o = $sig_cur;";
    push @code, "";

    # enable
    if ($cg_en_o) {
        push @code, "${INDENT}wire $cg_en_o;";
        push @code, "${INDENT}assign $cg_en_o = $cg_en_cur;";
        push @code, "";
    }

    my $code = join("\n",@code);
    $code .= "\n";

    #================================
    # PRINT OUT
    #================================
    print $code; 
}

1;
