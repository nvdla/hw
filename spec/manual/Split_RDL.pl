#!/usr/bin/env perl
#================================================================
#NVDLA Open Source Project
#
#Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
#NVDLA Open Hardware License; Check "LICENSE" which comes with 
#this distribution for more information.
#================================================================
#
#########################################################################
# File Name: Split_RDL.pl
# Created Time: Mon Oct 23 18:22:24 2017
# Description:This script is used to split a global rdl file to sub rdl files for submodules.
#########################################################################
#
use strict;
use warnings;

my $subfile="";
my $last_regfile="";
my %regfile_baseaddr=();
my $usr_def_property="";
my $usr_def_flag=1;
my $begin_line;
if(!@ARGV)
{
    print "#############################################\n";
    print "#\tERROR:There is no input RDL file!\n";
    print "#############################################\n";
    exit 1;
}
my $filename=$ARGV[0];
if($filename!~/.*\.rdl\z/)
{
    print "#############################################\n";
    print "#\tERROR:The input file is not a RDL file!\n";
    print "#############################################\n";
    exit 1;   
}

#store user defined properties in rdl file and store base addr for each sub module.
open FILE,'<',$filename or die "Cannot open \"$filename\": $!";
while(<FILE>)
{
    if(/\A\s*regfile\s+regs_(.*?)\s*{\s+\z/)
    {
        if($usr_def_flag)
        {
            $begin_line=$.;
        }
        $usr_def_flag=0;
        next;
    }
    if($usr_def_flag)
    {
        $usr_def_property.=$_;  
        next; 
    }
    if(/\A\s*addrmap\s*{\s+\z/)
    { 
        %regfile_baseaddr=();
    }
    elsif(/\A\s*regs_(.+?)\s+.+\s*\@(.*?)\s*;\s+\z/)
    {
        $regfile_baseaddr{$1}=$2;
    }
    else    
    {
        next;
    }
}
close FILE;

#split 
open FILE,'<',$filename or die "Cannot open \"$filename\": $!";
while(<FILE>)
{
  if($.<$begin_line)
  {
    next;
  }
  if(/\A\s*addrmap\s*{\s+\z/)
  {  
        print FILE1 "addrmap  {\n    regs_$last_regfile $last_regfile \@$regfile_baseaddr{$last_regfile};\n}addrmap_$last_regfile;";
        close FILE1;
        last;      
  }
  if(/\A\s*regfile\s+regs_(.*?)\s*{\s+\z/)
  {
    if($last_regfile)
    {
        print FILE1 "addrmap  {\n    regs_$last_regfile $last_regfile \@$regfile_baseaddr{$last_regfile};\n}addrmap_$last_regfile;";
        close FILE1;
    }
    $last_regfile=$1;
    $subfile="$1.rdl";
    open FILE1,'>',$subfile or die $!;
    print FILE1 $usr_def_property;
    print FILE1 $_;
    next;
  }
  print FILE1 $_;
}
close FILE;
