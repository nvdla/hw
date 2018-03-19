#! /usr/bin/perl

$start_output = 0;
$stop_output = 0;

while( <> ) {
    if( /# Registering/ ){ $start_output = 1; }
    if( /# UVM_INFO/ ){ $start_output = 1; }

    if( $start_output && !$stop_output ){
        s+ \/.*\/uvm_(.*)\.sv\(+ uvm_\1.sv(+;
        s+ \/.*\/uvmc_(.*)\.sv\(+ uvmc_\1.sv(+;
        s+ \/.*\/uvm_(.*)\.svh\(+ uvm_\1.svh(+;
        s+ \/.*\/uvmc_(.*)\.svh\(+ uvmc_\1.svh(+;
        print( "$_" );
    }
    #if( /# .*\$finish/ ){ $stop_output = 1; }
}
