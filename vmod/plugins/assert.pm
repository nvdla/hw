#!/usr/bin/env perl

package assert;
use strict;
use warnings FATAL => qw(all);

use Carp qw(croak);
use Getopt::Long qw(GetOptions);
use Text::ParseWords qw(shellwords);

=head1 assert

  &eperl::assert("[-type <type>] [-inst <name>] [-desc <'description'>] [-expr <'expression'>] [-clk <clk>] [-rst <rst>]");

  Required Inputs:
    -type <type> :  one of never|always|no_x|zero_one_hot|one_hot|vld_credit_max|hold_throughout_event_interval
    -inst <str>  :  instance name, will append zzz_assert_ automatically
    -desc <str>  :  description of assertion
    -expr <expr> :  expression of signals, such as " sig_a & (sig_b || sig_c) "

  Optional Inputs:
    -wid <n>     :  used in zero_one_hot|one_hot
    
    -start_event <signal>  :  used when type is no_x, default is "1'b1"

    -vld <signal> : valid signal name, when type is vld_credit_max, default is "vld"
    -cdt <signal> : credit signal name, when type is vld_credit_max, default is "cdt"
    -init_cdt <n> : initial credit number when type is vld_credit_max, default is 1
    -max_cdt <n>  : max credit number when type is vld_credit_max, default is 65
    
    -clk  <clk>  :  name of clock, "nvdla_core_clk" by default
    -rst  <rst>  :  name of reset, "nvdla_core_rstn" by default

=cut

use base ("Exporter");
our @EXPORT = qw(assert);

sub assert {
    my $args = shift;
    @ARGV = shellwords($args);
    
    #================================
    # OPTIONS
    #================================
    my $type;
    my $desc;
    my $expr;
    my $inst;

    my $opt_se; # start event
    
    my $wid   = 1;
    
    my $init_cdt   = 1;
    my $max_cdt    = 65;
    my $vld   = "vld";
    my $cdt   = "cdt";
    
    my $clk   = "nvdla_core_clk";
    my $rst   = "nvdla_core_rstn";
    
    my $indent= 0;
    GetOptions (
               'type=s'     => \$type,
               'desc=s'     => \$desc,
               'expr=s'     => \$expr,
               'inst=s'     => \$inst,
               'start_event=s'     => \$opt_se,
               'wid=s'      => \$wid,
               'vld=s'      => \$vld,
               'cdt=s'      => \$cdt,
               'init_cdt=s' => \$init_cdt,
               'max_cdt=s'  => \$max_cdt,
               'clk=s'      => \$clk,
               'rst=s'      => \$rst,
               'indent=s'   => \$indent,
               )  or die "Unrecognized options @ARGV";
    
    croak "-type need be specified" unless defined $type;
    croak "$type type is not supported" unless $type =~ /^(never|always|no_x|zero_one_hot|one_hot|vld_credit_max|hold_throughout_event_interval)$/;
    croak "-desc need be specified" unless defined $desc;
    croak "-expr need be specified" unless defined $expr;
    croak "-inst need be specified" unless defined $inst;

    #================================
    # VARIABLE
    #================================
    my $INDENT = " "x$indent;

    #================================
    # CODE BODY
    #================================
    #
    # parameter
    my $severity_level = "0,";
    
    my $width = "";
    if ($type =~ /(one_hot|hold_throughout_event_interval)/) {
        $width = $wid.",";
    }

    my $options = "0,";
    
    #
    # signal
    my $start_event = "";
    if ($type eq "no_x") {
        $start_event = $opt_se || "1'b1";
        $start_event .= ",";
    }

    # CODE
    print "${INDENT}// VCS coverage off\n";
    if ($type eq "vld_credit_max") {
        print "${INDENT}nv_assert_${type} zzz_assert_${inst} #($severity_level $init_cdt $max_cdt, \"$desc\") ($clk, $rst, $vld, $cdt);\n";
    } else {
        print "${INDENT}nv_assert_${type} zzz_assert_${inst} #($severity_level $width $options \"$desc\") ($clk, $rst, $start_event ($expr)); // spyglass disable W504 SelfDeterminedExpr-ML\n";
    }
    print "${INDENT}// VCS coverage on\n";
}

1;
