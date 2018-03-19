#! /usr/bin/perl

$start_output = 0;
$stop_output = 0;

while( <> ) {
    if( /# .*\[PRODUCER\/GP\/SEND\]/ ){ $start_output = 1; }

    if( $start_output && !$stop_output ){
        s+(# UVM_INFO :) *[0-9]*$+\1+; # Filter out UVM_INFO count
        s+ \/.*\/uvm_(.*)\.sv\(+ uvm_\1.sv(+;
        s+ \/.*\/uvmc_(.*)\.sv\(+ uvmc_\1.sv(+;
        s+ \..*\/uvmc_(.*)\.sv\(+ uvmc_\1.sv(+;
        s+ \/.*\/uvm_(.*)\.svh\(+ uvm_\1.svh(+;
        s+ veri.*\/uvm_(.*)\.svh\(+ uvm_\1.svh(+;
        if( ! /# .*Questa UVM/ ) { print( "$_" ); }
    }
    if( /# \[TEST_DONE\] *1/ ){ $stop_output = 1; }
    if( /#  quit -f/ ){ $stop_output = 1; }
}
