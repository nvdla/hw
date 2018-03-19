#!/usr/bin/env perl
#================================================================
#NVDLA Open Source Project
#
#Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
#NVDLA Open Hardware License; Check "LICENSE" which comes with
#this distribution for more information.
#================================================================
#
##################################################################################################
# File Name: RDLMerge.pl
# Created Time: Mon Nov 27 14:35:33 2017
# Description: This script is used to merge sub rdl files for submodules to a global rdl file.
##################################################################################################
use strict;
use warnings;
use File::Basename;
my @regfile_baseaddr=();
my $usr_def_property="";
my $content="";
my $first=1;
if(!@ARGV)
{
    print "#############################################\n";
    print "#\tERROR:There is no input RDL file!\n";
    print "#############################################\n";
    exit 1;
}
my $filename=$ARGV[0];
my $java_version=$ARGV[1];
my $perl_version=$ARGV[2];
my $OutDir="outdir";
$OutDir=$ARGV[3] if(defined $ARGV[3]);
if($filename!~/.*\.rdl\z/)
{
    print "#############################################\n";
    print "#\tERROR:The input file is not a RDL file!\n";
    print "#############################################\n";
    exit 1;
}
open FILE,'<',$filename or die "Cannot open \"$filename\": $!";
while(<FILE>)
{
    next unless /^\s*import\s+(.+?)\s*$/;
    my $sub_filename = $1;
    open my $fh,'<',$sub_filename or die $!;
    my $sub_file_prefix=basename($sub_filename);
    $sub_file_prefix = (split /\./,$sub_file_prefix)[0];
    #generate backends for sub rdl.
    system("$java_version -jar Ordt.jar -parms opendla.parms -xml $OutDir/$sub_file_prefix.xml -verilog $OutDir/${sub_file_prefix}_reg.v -uvmregspkg $OutDir/ordt_uvm_reg_pkg.sv -uvmregs $OutDir/${sub_file_prefix}_reg.sv -cppmod $OutDir/${sub_file_prefix}_reg_c $sub_filename") == 0 or die $!;
    system("$perl_version   ORDT_xml2others.pl -c -v -py -f $OutDir/$sub_file_prefix.xml -o $OutDir") == 0 or die $!;
    my $usr_def_flag=1;
    my $end_flag=0;
    while(<$fh>)
    {
        if(/\A\s*regfile\s+regs_(.*?)\s*{\s+\z/)
        {
            $usr_def_flag=0; 
        }elsif(/\A\s*addrmap\s*{\s+\z/)
        {
            $end_flag=1;
        }elsif(/\A\s*regs_.+?\s+.+\s*\@.*?\s*;\s+\z/)
        {
            push @regfile_baseaddr,"$_" if($end_flag);
        }
        if($usr_def_flag && $first)
        {
            $usr_def_property.=$_;
            next;
        }
        if(!$usr_def_flag && !$end_flag)
        {
            $content.=$_;
            next;
        } 
    }
    close $fh;
    $first=0;
}
close FILE;
open FILE,'>',"$OutDir/opendla.rdl" or die $!;
print FILE $usr_def_property;
print FILE $content;
print FILE "addrmap  {\n";
foreach my $regfile(@regfile_baseaddr){
    print FILE "$regfile";
}
print FILE "}addrmap_NVDLA;";
close FILE;

#generate backends for global rdl.
system("$java_version -jar Ordt.jar -parms opendla.parms -xml $OutDir/opendla.xml -verilog $OutDir/opendla_reg.v -uvmregs $OutDir/opendla_reg.sv -cppmod $OutDir/opendla_reg_c $OutDir/opendla.rdl") == 0 or die $!;

system("$perl_version   ORDT_xml2others.pl -c -v -py -u -f $OutDir/opendla.xml -o $OutDir") == 0 or die $!; 
