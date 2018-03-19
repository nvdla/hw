#===========================================================================
# @(#) $Id: xlcheck.pl 1401 2015-03-01 17:58:52Z jstickle $
#===========================================================================

#   //_______________________
#  // Mentor Graphics, Corp. \_________________________________________________
# //                                                                         //
#//   (C) Copyright, Mentor Graphics, Corp. 2003-2014                        //
#//   All Rights Reserved                                                    //
#//                                                                          //
#//    Licensed under the Apache License, Version 2.0 (the                   //
#//    "License"); you may not use this file except in                       //
#//    compliance with the License.  You may obtain a copy of                //
#//    the License at                                                        //
#//                                                                          //
#//        http://www.apache.org/licenses/LICENSE-2.0                        //
#//                                                                          //
#//    Unless required by applicable law or agreed to in                     //
#//    writing, software distributed under the License is                    //
#//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR                //
#//    CONDITIONS OF ANY KIND, either express or implied.  See               //
#//    the License for the specific language governing                      //
#//    permissions and limitations under the License.                      //
#//-----------------------------------------------------------------------//

@toolVersions = (
    "questa 10.1* 10.2* 10.3* 10.4*",
    "gcc 4.3.3 4.4.5 4.5.0 4.7.4",
    "osciSysc 2.2.* 2.3.*",
    "vista 3.5.1 3.7.0 3.7.1 3.8.0",
    "ius 13* 14*" );

# These are the tool environments checked by this script.
# Note: lines with more than one entry are aliases to the same tool.
@supportedTools = (
    "env_questa",  "env_mti",
    "env_gcc",     "env_gcc_questa",
    "env_sysc",
    "env_uvm",     "env_uvmc",
    "env_ovm",
    "env_vista",
    "env_ius" );

%questaVersions = ();
%gccVersions = ();
%osciSyscVersions = ();
%vistaVersions = ();
%iusVersions = ();
$tool = "";
$key = "";
$is64bit = "";

$questaVersion = "";
$gccVersion = "";
$osciSyscVersion = "";
$vistaVersion = "";
$iusVersion = "";

%toolsToCheck = ();

#-----------------------------------------------------------------------------
# Build a table of supported tool versions to check against current
# env settings.
#-----------------------------------------------------------------------------

sub buildToolTable() {

    foreach $line (@toolVersions) {
        my @versionList = split " ", $line;

        foreach $token (@versionList) {
            if( $tool eq "" ) { $tool = $token; }
            else{
                if( $tool eq "questa" ){
                    if( $token =~ /([0-9]*\..)/ ) {
                        $key = $1;
                        $questaVersions{$key} = "valid";
                    }
                }
                elsif( $tool eq "gcc" ){
                    if( $token =~ /([0-9]\..\..)/ ) {
                        $key = $1;
                        $gccVersions{$key} = "valid";
                    }
                }
                elsif( $tool eq "osciSysc" ){
                    if( $token =~ /([0-9]\..)/ ) {
                        $key = $1;
                        $osciSyscVersions{$key} = "valid";
                    }
                }
                elsif( $tool eq "vista" ){
                    if( $token =~ /([0-9]\..\..)/ ) {
                        $key = $1;
                        $vistaVersions{$key} = "valid";
                    }
                }
                elsif( $tool eq "ius" ){
                    if( $token =~ /([0-9]*)/ ) {
                        $key = $1;
                        $iusVersions{$key} = "valid";
                    }
                }
            }
        }
        $tool = "";
    }
}

#-----------------------------------------------------------------------------
# Determine which tool environments to xlcheck
#
# if( argv[1] is passed )
#   Check only that tool environment.
# else
#   Check all tool environments for which env_<tool> switches are specified
#   in the environment.
#-----------------------------------------------------------------------------

sub determineWhatToCheck() {
    my $arg = shift( @ARGV ); # Purge "xlcheck" itself.
    my $argWasValid = "no";
    if( "$arg" ne "" ) {
        foreach $supportedTool (@supportedTools) {
            if( "$arg" eq "$supportedTool" ) {
                if( !defined($ENV{$supportedTool}) ) {
                    die "ERROR: You are asking to check '$arg' but your " .
                        "ENV for that tool has not been set up.\n" .
                        "Please 'setenv $arg' before " .
                        "sourcing your .toolsrc.\n"; }
                else {
                    $toolsToCheck{$supportedTool} = "yes";
                    $argWasValid = "yes";
                }
            }
        }
        if( "$argWasValid" eq "no" ) {
            die "ERROR: Invalid arg switch: $arg.\n" .
                "Must be one of [@supportedTools].\n"; }
    }
    else {
        foreach $supportedTool (@supportedTools) {
            if( defined($ENV{$supportedTool}) ) {
                $toolsToCheck{$supportedTool} = "yes"; }
        }
    }
    # Set up aliases to create a cross matrix of mutually dependent tool checks
    if( $toolsToCheck{"env_mti"} eq "yes" ) {
        $toolsToCheck{"env_questa"} = "yes"; }
    if( $toolsToCheck{"env_questa"} eq "yes" ) {
        $toolsToCheck{"env_gcc"} = "yes"; }
    if( $toolsToCheck{"env_gcc_questa"} eq "yes" ) {
        $toolsToCheck{"env_gcc"} = "yes"; }
    if( $toolsToCheck{"env_uvmc"} eq "yes" ) {
        $toolsToCheck{"env_uvm"} = "yes"; }
} 

#-----------------------------------------------------------------------------
# Check BITS setting
#
# At a very minimum, $BITS must be set indicate 32 or 64 bit.
#-----------------------------------------------------------------------------

sub checkBits() {
    if(  "$ENV{BITS}" eq "32" ) { $is64bit = 0 }
    elsif(  "$ENV{BITS}" eq "64" ) { $is64bit = 1 }
    else {
        die "ERROR: The \$BITS(=$ENV{BITS}) variable must " .
            "have a value of either 32 or 64 to indicate " .
            "whether 32 bit or 64 bit binaries are to be used " .
            "respectively.\n"; }
}

#-----------------------------------------------------------------------------
# Check GCC environent (env_gcc_questa, env_gcc)
#-----------------------------------------------------------------------------

sub checkGcc() {
    if( $toolsToCheck{"env_gcc"} eq "yes" ) {
        printf( "Checking GCC env ...\n" );

        if( "$ENV{GNUHOME}" eq "" ){
            die "ERROR: GNU GCC env must have \$GNUHOME set.\n"; }

        my $gccBanner = `gcc --ver 2>&1 | grep version`;
        if( $gccBanner =~ /([0-9]\..\..)/ ) { $gccVersion = $1; }
        if( $gccVersions{$gccVersion} ne "valid" ){
            printToolVersions();
            die "ERROR: Incompatible GNU gcc release: $gccBanner.\n"; }
        print "gcc$gccVersion\n";
    }
}

#-----------------------------------------------------------------------------
# Check QUESTA environent (env_questa, env_mti)
#-----------------------------------------------------------------------------

sub checkQuesta() {
    if( $toolsToCheck{"env_questa"} eq "yes" ) {
        printf( "Checking QUESTA env ...\n" );

        my $questaBanner = `vsim -version 2>&1`;
        if( $questaBanner =~ /([0-9]*\..)/ ) { $questaVersion = $1; }

        if( $questaVersions{$questaVersion} ne "valid" ){
            printToolVersions();
            die "ERROR: Incompatible Questa release: $questaBanner.\n"; }

        if( "$ENV{MTI_HOME}" eq "" ){
            die "ERROR: Questa env must have \$MTI_HOME set.\n"; }

        if( "$ENV{MGC_HOME}" eq "" ){
            die "ERROR: Questa env must have \$MGC_HOME set.\n"; }

        # Make sure CppPath entry in modelsim.ini matches gcc compiler.
        if( -r "modelsim.ini" ){
            local $iniCppPath = `grep "^CppPath" modelsim.ini`;
            if( $iniCppPath =~ /CppPath.*= *(.*)/ ){
                local $cppPath = $1;
                local $iniGccVersion = "";
                local $iniGccBanner = `$cppPath --ver 2>&1 | grep version`;
                if( $iniGccBanner =~ /([0-9]\..\..)/ ) { $iniGccVersion = $1; }
                if( $iniGccVersion ne $gccVersion ){
                    die "ERROR: Detected a modelsim.ini that does not have an " .
                        "[sccom] CppPath entry matching your " .
                        "gcc version=$gccVersion .\n"; }
            }
            else {
                die "ERROR: Detected a modelsim.ini that does not have an " .
                    "[sccom] CppPath entry.\n"; }
        }
        print "questa$questaVersion\n";
    }
}

#-----------------------------------------------------------------------------
# Check OSCI SystemC environent (env_sysc)
#-----------------------------------------------------------------------------

sub checkSysc() {
    if( $toolsToCheck{"env_sysc"} eq "yes" ) {
        $osciSyscBanner = `env | grep SYSTEMC`;
        if( $osciSyscBanner =~ systemc-/([0-9]\..)/ ) { $osciSyscVersion = $1; }

        print "osciSysc$osciSyscVersion\n";

        if( $osciSyscVersion ne ""
                && $osciSyscVersions{$osciSyscVersion} ne "valid" ){
            printToolVersions();
            die "ERROR: Incompatible OSCI SystemC release: $osciSyscBanner.\n";
        }
        if( ! -e "$ENV{SYSTEMC_TLM_HOME}/tlm.h" ) {
            die "ERROR: You must properly set your \$SYSTEMC_TLM_HOME path " .
                "to a standard TLM-2.0 compliant directory " .
                "containing tlm.h.\n" .
                "See template .toolsrc for a good example of a " .
                "'env_sysc' SystemC env setup.\n"; }
    }
}

#-----------------------------------------------------------------------------
# Check Vista environent (env_vista)
#-----------------------------------------------------------------------------

sub checkVista() {
    if( $toolsToCheck{"env_vista"} eq "yes" ) {
        $vistaBanner = `vista -version`;
        $osciSyscBanner = `env | grep SYSTEMC`;
        if( $osciSyscBanner =~ systemc-/([0-9]\..)/ ) { $osciSyscVersion = $1; }
        if( $vistaBanner =~ /([0-9]\..\..)/ ) { $vistaVersion = $1; }

        print "osciSysc$osciSyscVersion\n";
        print "vista$vistaVersion\n";

        if( $osciSyscVersion ne ""
                && $osciSyscVersions{$osciSyscVersion} ne "valid" ){
            printToolVersions();
            die "ERROR: Incompatible OSCI SystemC release: $osciSyscBanner.\n"; }

        if( $vistaVersion ne "" && $vistaVersions{$vistaVersion} ne "valid" ){
            printToolVersions();
            die "ERROR: Incompatible Vista release: $vistaBanner.\n"; }
    }
}

#-----------------------------------------------------------------------------
# Check IUS environent (env_ius)
#-----------------------------------------------------------------------------

sub checkIus() {
    if( $toolsToCheck{"env_ius"} eq "yes" ) {
        printf( "Checking IUS env ...\n" );

        my $iusBanner = `irun -version 2>&1`;
        if( $iusBanner =~ /([0-9]*)\../ ) { $iusVersion = $1; }

        if( $iusVersions{$iusVersion} ne "valid" ){
            printToolVersions();
            die "ERROR: Incompatible IUS release: $iusBanner.\n"; }

        if( $ENV{IUS_HOME} eq "" ){
            die "ERROR: IUS env must have \$IUS_HOME set.\n"; }

        print "ius$iusVersion\n";
    }
}

#-----------------------------------------------------------------------------
# Print supported tool versions.
#-----------------------------------------------------------------------------

sub printToolVersions(){
    print "Only the following tool versions are supported:\n";
    foreach $line (@toolVersions) {
        print "    $line\n";
    }
}

buildToolTable();

determineWhatToCheck();

checkBits();
checkGcc();
checkQuesta();
checkVista();
checkSysc();
checkIus();
