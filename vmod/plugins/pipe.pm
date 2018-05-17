#!/usr/bin/env perl

package pipe;
use strict;
use warnings FATAL => qw(all);

use Carp qw(croak);
use Getopt::Long qw(GetOptions);
use Text::ParseWords qw(shellwords);

use flop;
use EperlUtil;

=head1 PIPE

  &eperl::pipe("[-is] [-wid <n>]");
    
  Required Inputs:
    NONE

  Optional Inputs:
    -vi  : input valid signal name
    -di  : input data signal name
    -ro  : output ready signal name
    -vo  : output valid signal name
    -do  : output data signal name
    -ri  : input ready signal name

    -is  : input skid buffer            

    -wid <n> : width of data

  Example: 
    A pipe with input skip, 18 bits data
    &eperl::pipe("-is -wid 18");

  Behavior:
    ----------
    Basic Pipe
    ----------
    The pipe function generates a single pipe stage with bubble collapsing(bc).
    Input skid(is) adds comb logic on vi side, while make ro timing clean
        
    BASIC        | SKID
                 |
    pipe -bc     |   -is                           
    ------------ |   ----------------------------- 
     di,vi,ro    |     di,vi              ro       
      v     ^    |       v                ^        
      |     |    |     __|  __            |        
     _|_    |    |    | _|_|_ |           |        
    |>__|   |    |    | \___/-|------     |        
      | - >(*)   |    |  _|_  | |  _|_   _|_       
      |     |    |    | |>__| | | |>__| |>__|      
      |     |    |    |__ |___| |   |     |        
      |     |    |      _|_|_   |   ------|        
      v     ^    |      \___/---          |        
     do,vo,ri    |       _|_______________|_       
                 |      |        pipe       |      
                 |      |___________________|      
                 |        |               |        
                 |        v               ^        
                 |     do,v               ri       

=cut

use base ("Exporter");
our @EXPORT = qw(pipe);

my @code;
my @ports;
my @regs;
my @wires;
my $clk;
my $rst;
my $indent;

sub pipe {
    my $args = shift;
    @ARGV = shellwords($args);
    
    #================================
    # OPTIONS
    #================================
    @code = ();
    @ports = ();
    @regs = ();
    @wires = ();
    $clk = "nvdla_core_clk";
    $rst = "nvdla_core_rstn";
    $indent= 0;
    
    my $prefix;

    my $vi = "vi";
    my $di = "di";
    my $ro = "ro";
    my $vo = "vo";
    my $do = "do";
    my $ri = "ri";

    my $wid = 1;
    my $module;
    my $is;
    GetOptions (
               'prefix=s'  => \$prefix,
               'is'    => \$is,
               'vi=s'  => \$vi,
               'di=s'  => \$di,
               'ro=s'  => \$ro,
               'vo=s'  => \$vo,
               'do=s'  => \$do,
               'ri=s'  => \$ri,
               'wid=s' => \$wid,
               'module|m=s' => \$module,
               'clk=s' => \$clk,
               'rst=s' => \$rst,
               'indent=s' => \$indent,
               )  or die "Unrecognized options @ARGV";
    
    #================================
    # VARIABLE
    #================================
    $vi = $prefix."_".$vi if defined $prefix;
    $di = $prefix."_".$di if defined $prefix;
    $ro = $prefix."_".$ro if defined $prefix;
    $vo = $prefix."_".$vo if defined $prefix;
    $do = $prefix."_".$do if defined $prefix;
    $ri = $prefix."_".$ri if defined $prefix;

    my $range = ($wid>1) ? "[$wid-1:0]" : "";
    
    my $DI = $di."$range";
    my $DO = $do."$range";
    my $INDENT = " "x$indent;

    push @ports, "${INDENT}input  $clk;";
    push @ports, "${INDENT}input  $rst;";

    push @ports, "${INDENT}input  $vi;";
    push @ports, "${INDENT}output $ro;";
    push @ports, "${INDENT}input  $range $di;";
    
    push @ports, "${INDENT}output $vo;";
    push @ports, "${INDENT}input  $ri;";
    push @ports, "${INDENT}output $range $do;";
    
    my @pins;
    push @pins, $vi;
    push @pins, $di;
    push @pins, $ro;
    push @pins, $vo;
    push @pins, $do;
    push @pins, $ri;

    #================================
    # HEAD
    #================================

    # is
    ($vi,$di,$ro) = _skid($vi,$di,$ro,$range) if $is;

    # pipe
    ($vi,$di,$ro) = _pipe($vi,$di,$ro,$range);

    # os
    # ($vi,$di,$ro) = _skid($vi,$di,$ro,$range) if $os;

    #================================
    # TAIL
    #================================
    push @code, "// PIPE OUTPUT";
    push @wires, "$ro;";
    push @wires, "$vo;";
    push @wires, "$range $do;";
    push @code, "${INDENT}assign $ro = $ri;";
    push @code, "${INDENT}assign $vo = $vi;";
    push @code, "${INDENT}assign $do = $di;";
    
    my $regs = "reg ".join("\nreg ",@regs);
    
    my $wire = "wire ".join("\nwire ",@wires);

    my $code = join("\n",@code);

    #================================
    # PRINT OUT
    #================================
    if ($module) {
        vprintl "${INDENT}module $module (";
         print  "${INDENT}   ";
        vprintl join("\n${INDENT}  ,",@pins);
        vprintl "${INDENT}  );";
        vprintl "// Port";
        vprintl join("\n",@ports);
    }
    vprintl "// Reg";
    vprintl $regs;

    vprintl "// Wire";
    vprintl $wire;

    vprintl "// Code";
    vprintl $code;
    
    if ($module) {
        vprintl "${INDENT}endmodule";
    }
}

sub _pipe {
    my $vi = shift;
    my $di = shift;
    my $ro = shift;
    my $range = shift;

    my $INDENT = " "x$indent;

    my $vo = "pipe_".$vi;
    my $do = "pipe_".$di;
    my $ri = "pipe_".$ro;
    
    my $DI = $di."$range";
    my $DO = $do."$range";
    
    # READY
    push @code, "// PIPE READY";
    push @regs, "$vo;";
    push @wires,"$ro;";
    push @code, "${INDENT}assign $ro = $ri || !$vo;";
    push @code, "";
    # VALID
    push @code, "// PIPE VALID";
    push @code, "${INDENT}always @(posedge $clk or negedge $rst) begin";
    push @code, "${INDENT}    if (!$rst) begin";
    push @code, "${INDENT}        $vo <= 1'b0;";
    push @code, "${INDENT}    end else begin";
    push @code, "${INDENT}        if ($ro) begin";
    push @code, "${INDENT}            $vo <= $vi;";
    push @code, "${INDENT}        end";
    push @code, "${INDENT}    end";
    push @code, "${INDENT}end";
    push @code, "";
    # DATA
    push @code, "// PIPE DATA";
    push @regs, "$range $do;";
    push @code, "${INDENT}always @(posedge $clk) begin";
    push @code, "${INDENT}    if ($ro && $vi) begin";
    push @code, "${INDENT}        $DO <= $DI;";
    push @code, "${INDENT}    end";
    push @code, "${INDENT}end";
    push @code, "\n";

    return ($vo,$do,$ri);
}

sub _skid {
    my $vi = shift;
    my $di = shift;
    my $ro = shift;
    my $range = shift;
    
    my $INDENT = " "x$indent;

    my $vs = "skid_flop_".$vi;
    my $ds = "skid_flop_".$di;
    my $rs = "skid_flop_".$ro;

    my $vo = "skid_".$vi;
    my $do = "skid_".$di;
    my $ri = "skid_".$ro;
    
    my $DI = $di."$range";
    my $DS = $ds."$range";
    my $DO = $do."$range";
    
    
    # READY
    push @code, "// SKID READY";
    push @regs, "$ro;";
    push @regs, "$rs;";
    push @code, "${INDENT}always @(posedge $clk or negedge $rst) begin";
    push @code, "${INDENT}   if (!$rst) begin";
    push @code, "${INDENT}       $ro <= 1'b1;";
    push @code, "${INDENT}       $rs <= 1'b1;";
    push @code, "${INDENT}   end else begin";
    push @code, "${INDENT}       $ro <= $ri;";
    push @code, "${INDENT}       $rs <= $ri;";
    push @code, "${INDENT}   end";
    push @code, "${INDENT}end";
    push @code, "";

    # VALID
    push @code, "// SKID VALID";
    push @regs, "$vs;";
    push @wires,"$vo;";
    push @code, "${INDENT}always @(posedge $clk or negedge $rst) begin";
    push @code, "${INDENT}    if (!$rst) begin";
    push @code, "${INDENT}        $vs <= 1'b0;";
    push @code, "${INDENT}    end else begin";
    push @code, "${INDENT}        if ($rs) begin";
    push @code, "${INDENT}            $vs <= $vi;";
    push @code, "${INDENT}        end";
    push @code, "${INDENT}   end";
    push @code, "${INDENT}end";
    push @code, "${INDENT}assign $vo = ($rs) ? $vi : $vs;";
    push @code, "";
    
    # DATA
    push @code, "// SKID DATA";
    push @regs, "$range $ds;";
    push @wires,"$range $do;";
    push @code, "${INDENT}always @(posedge $clk) begin";
    push @code, "${INDENT}    if ($rs & $vi) begin";
    push @code, "${INDENT}        $DS <= $DI;";
    push @code, "${INDENT}    end";
    push @code, "${INDENT}end";
    push @code, "${INDENT}assign $DO = ($rs) ? $DI : $DS;";
    push @code, "\n";

    return ($vo,$do,$ri);
}

1;
