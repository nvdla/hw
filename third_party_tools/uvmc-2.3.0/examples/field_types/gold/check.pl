#! /usr/bin/perl

$start_output = 0;
$stop_output = 0;

while( <> ) {
    if( /#.*UVM Report catcher Summary/ ){ $start_output = 1; }
    if( /# .*\$finish/ ){ $stop_output = 1; }

    if( $start_output && !$stop_output ){
        s+(# UVM_INFO :) *[0-9]*$+\1+; # Filter out UVM_INFO count
        if( ! /# .*Questa UVM/ ) { print( "$_" ); }
    }
}
