#! /usr/bin/perl

$start_output = 0;
$stop_output = 0;

while( <> ) {
    if( /# 0 s/ ){ $start_output = 1; }
    if( /# *quit -f/ ){ $stop_output = 1; }

    if( $start_output && !$stop_output ){
        print( "$_" );
    }
}
