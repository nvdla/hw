#!/usr/bin/env perl

package fifo;
use strict;
use warnings FATAL => qw(all);

use Carp qw(croak);
use Getopt::Long qw(GetOptions);
use Text::ParseWords qw(shellwords);

use EperlUtil;

=head1 fifo

=cut

use base ("Exporter");
our @EXPORT = qw(fifo);

sub fifo {
    my $args = shift;
    @ARGV = shellwords($args);
    
    #================================
    # OPTIONS
    #================================
    my $module;
    my $depth;
    my $width;
    my $indent= 0;
    GetOptions (
               'module|m=s' => \$module,
               'depth|d=s'  => \$depth,
               'width|w=s'  => \$width,
               'indent=s'   => \$indent,
               )  or die "Unrecognized options @ARGV";

    croak "-module need be defined" unless $module; 
    croak "-width need be defined" unless $width; 
    croak "-depth need be defined" unless $depth; 
    
    #================================
    # Variables
    #================================
    my $INDENT = " "x$indent;
    
    #================================
    # Code
    #================================
    vprintl "${INDENT}module $module (";
    vprintl "${INDENT});";

    vprintl "${INDENT}endmodule";
}

1;
