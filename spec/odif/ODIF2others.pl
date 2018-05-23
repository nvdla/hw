#!/usr/bin/env perl

#================================================================
#NVDLA Open Source Project
#
#Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
#NVDLA Open Hardware License; Check "LICENSE" which comes with 
#this distribution for more information.
#================================================================
 
use strict;
use warnings;
 
use Getopt::Long;
use Data::Dumper;
my $filename="";
my $Cmod=0;
my $interface_Verilog=0;
my $module_Verilog=0;
my $SystemVerilog=0;
my $Macros=0;
my $print_help=0;
my $OutDir="out";
my $current_state="";
my $group_name;
my %interface;
my %groups;
my %groups_flat;
my %modules;
my $module_name;
my $interface_name;

sub print_usage{
   print STDERR "USAGE: ./ODIF2others.pl -f <input_top.odif> [-c] [-iv] [-V] [-sv] [-m] [-o] <outdir>\nUse -help for advanced options\n";
   print STDERR " - '-f' specify the input top odif file\n";
   print STDERR " - '-c' emit Cmod backend (.h)\n";
   print STDERR " - '-iv' emit Verilog backend for interface(.v)\n";
   print STDERR " - '-V' emit Verilog backend for module(.v)\n";
   print STDERR " - '-sv' emit SystemVerilog backend (.svh)\n";
   print STDERR " - '-m' emit Macros backend (.h)\n";
   print STDERR " - '-o' specify the outdir\n";
   print STDERR " - '-help|h' print usage\n";
}

sub emit_sv
{
    foreach my $key_interface (keys %interface){
        open FILE,'>',"$OutDir/odif_${key_interface}.svh";
        print FILE "`ifdef INC_${key_interface}_structs_SVH\n`else\n`define INC_${key_interface}_structs_SVH\n\n";
        if(exists $interface{$key_interface}{packet}){
            my @packet=@{$interface{$key_interface}{packet}};
            my $id=$interface{$key_interface}{id};
            my $payload=$interface{$key_interface}{payload};
            my @width_diff=();
            foreach my $key_group (@packet){
                print FILE "`ifndef SV_STRUCT_DEFINED_${key_group}\n`define SV_STRUCT_DEFINED_${key_group}\n";
                print FILE "typedef struct packed {\n";
                my $field_array=$groups_flat{$key_interface}{$key_group};
                my $diff =$payload-$groups{$key_group}{WIDTH};
                push @width_diff,$diff;
                foreach my $field (@{$field_array}){
                    foreach my $key (keys %{$field}){
                        my $width=${$field}{$key}{width};
                        if(${$field}{$key}{size}==1){
                            print FILE "  bit [".eval($width-1).":0] $key;\n";  
                        }else{
                            my $size=${$field}{$key}{size};
                            print FILE "  bit [".eval($size-1).":0][".eval($width-1).":0] $key;\n"                            
                        }
                    }
                }
                print FILE "} ${key_group}_struct;\n";
                print FILE "`endif\n\n";
            }
            print FILE "`ifndef SV_STRUCT_DEFINED_${key_interface}\n`define SV_STRUCT_DEFINED_${key_interface}\n";  
            print FILE "typedef enum {\n";
            foreach my $group (@packet){
                print FILE "  ${key_interface}_PKT_$group,\n";
            }
            print FILE "  ${key_interface}_PKT_INVALID\n";   
            print FILE "} ${key_interface}_packets;\n";
            print FILE "typedef struct packed {\n";
            print FILE "  struct packed {\n";
            print FILE "    bit [".eval($id-1).":0] tag;\n";
            print FILE "    union packed {\n";
            for(my $index=0; $index<=$#packet;$index++){
                if($width_diff[$index]==0){
                    print FILE "      struct packed { $packet[$index]_struct pkt; } $packet[$index];\n";
                }else{
                    print FILE "      struct packed { bit [".eval($width_diff[$index]-1).":0] pad; $packet[$index]_struct pkt; } $packet[$index];\n";
                }
            }
            print FILE "    } payload;\n"; 
            print FILE "  } pd;\n";
            print FILE "} ${key_interface}_struct;\n";              
            print FILE "`endif\n\n";
        }elsif(exists $interface{$key_interface}{group}){
            print FILE "`ifndef SV_STRUCT_DEFINED_${key_interface}\n`define SV_STRUCT_DEFINED_${key_interface}\n";
            print FILE "typedef struct packed {\n";
            my $group=$interface{$key_interface}{group};
            my @fields=@{$groups_flat{$key_interface}{$group}};
            foreach my $field (@fields){
                foreach my $key (keys %{$field}){
                    my $width=${$field}{$key}{width};
                    if(${$field}{$key}{size}==1){
                        print FILE "  bit [".eval($width-1).":0] $key;\n";
                    }else{
                        my $size=${$field}{$key}{size};
                        print FILE "  bit [".eval($size-1).":0][".eval($width-1).":0] $key;\n"
                    }
                }
            }
            print FILE "} ${key_interface}_struct;\n";
            print FILE "`endif\n\n";
        }
        print FILE "`endif // !defined(INC_${key_interface}_structs_SVH)";    
        close FILE;
    }
}

sub emit_module_v
{
    foreach my $key_module (keys %modules){
        open  FILE,'>',"$OutDir/odif_${key_module}_ports.v";
        my @instances=@{$modules{$key_module}};
        foreach my $instance (@instances){
            foreach my $key_instance (keys %{$instance}){
                my @one_instance=@{${$instance}{$key_instance}}; 
                my $interface_name;
                my $inout;
                foreach my $detail (@one_instance){
                    if(exists ${$detail}{interface}){
                        $interface_name=${$detail}{interface};
                    }elsif(exists ${$detail}{inout}){
                        $inout=${$detail}{inout};
                    }
                }
                my $flow=$interface{$interface_name}{flow} || "none";
                if($flow=~/^valid_ready$/ && $inout eq "in"){
                    print FILE ",input ${key_instance}_valid\n,output ${key_instance}_ready\n";
                }elsif($flow=~/^valid_ready$/ && $inout eq "out"){
                    print FILE ",output ${key_instance}_valid\n,input ${key_instance}_ready\n";
                }elsif($flow=~/^valid$/ && $inout eq "in"){
                    print FILE ",input ${key_instance}_valid\n";
                }elsif($flow=~/^valid$/ && $inout eq "out"){
                    print FILE ",output ${key_instance}_valid\n";
                }
                if(exists $interface{$interface_name}{packet}){
                    my $msb=$interface{$interface_name}{pd}-1;
                    my $range = $msb ? "[$msb:0]" : "";
                    if($inout eq "in"){
                        print FILE ",input $range ${key_instance}_pd\n";
                    }else{ 
                        print FILE ",output $range ${key_instance}_pd\n";
                    }
                }elsif(exists $interface{$interface_name}{group}){
                    my $group=$interface{$interface_name}{group};
                    my @fields=@{$groups_flat{$interface_name}{$group}};
                    foreach my $field (@fields){
                        foreach my $key (keys %{$field}){
                            if(${$field}{$key}{size}==1){
                                my $msb=${$field}{$key}{width}-1;
                                my $range = $msb ? "[$msb:0]" : "";
                                if($inout eq "in"){
                                    print FILE ",input $range ${key_instance}_$key\n";
                                }else{
                                    print FILE ",output $range ${key_instance}_$key\n";
                                }
                             }else{
                                my $size=${$field}{$key}{size};
                                for(my $index=0;$index<$size;$index++){
                                    my $msb=${$field}{$key}{width}-1;
                                    my $range = $msb ? "[$msb:0]" : "";
                                    if($inout eq "in"){
                                        print FILE ",input $range ${key_instance}_$key$index\n";
                                    }else{
                                        print FILE ",output $range ${key_instance}_$key$index\n";
                                    }
                                }
                            }
                        }
                    }
                }
            } 
        }
        close FILE;
    }
}

sub emit_interface_v
{
    foreach my $key_interface (keys %interface){
        my $flow=$interface{$key_interface}{flow};
        open FILE0,'>',"$OutDir/odif_${key_interface}_io.v";
        open FILE1,'>',"$OutDir/odif_${key_interface}_input.v";
        open FILE2,'>',"$OutDir/odif_${key_interface}_output.v";
        if($flow=~/^valid_ready$/)
        {
            print FILE0 ",${key_interface}_valid\n,${key_interface}_ready\n";
            print FILE1 "input ${key_interface}_valid;\noutput ${key_interface}_ready;\n";
            print FILE2 "output ${key_interface}_valid;\ninput ${key_interface}_ready;\n";
        }elsif($flow=~/^valid$/){
            print FILE0 ",${key_interface}_valid\n";
            print FILE1 "input ${key_interface}_valid;\n";
            print FILE2 "output ${key_interface}_valid;\n";
        }        
        if(exists $interface{$key_interface}{packet}){
            print FILE0 ",${key_interface}_pd\n";
            my $msb=$interface{$key_interface}{pd}-1;
            my $range = $msb ? "[$msb:0]" : "";
            print FILE1 "input $range ${key_interface}_pd;\n";
            print FILE2 "output $range ${key_interface}_pd;\n";
        }elsif(exists $interface{$key_interface}{group}){
            my $group=$interface{$key_interface}{group};
            my @fields=@{$groups_flat{$key_interface}{$group}};
            foreach my $field (@fields){
                foreach my $key (keys %{$field}){
                    if(${$field}{$key}{size}==1){
                        print FILE0 ",${key_interface}_$key\n";
                        my $msb=${$field}{$key}{width}-1;
                        my $range = $msb ? "[$msb:0]" : "";
                        print FILE1 "input $range ${key_interface}_$key;\n";
                        print FILE2 "output $range ${key_interface}_$key;\n";
                    }else{
                        my $size=${$field}{$key}{size};
                        for(my $index=0;$index<$size;$index++){
                            print FILE0 ",${key_interface}_$key$index\n";
                            my $msb=${$field}{$key}{width}-1;
                            my $range = $msb ? "[$msb:0]" : "";
                            print FILE1 "input $range ${key_interface}_$key$index;\n";
                            print FILE2 "output $range ${key_interface}_$key$index;\n";
                        }
                    }
                }
            }
        
        }
        close FILE0;
        close FILE1;
        close FILE2;
    }
}

sub emit_macros
{
    foreach my $key_interface (keys %interface){
        my $flow=$interface{$key_interface}{flow} || "none";
        open FILE,'>',"$OutDir/odif_${key_interface}_def.h";
        print FILE "#if !defined(_${key_interface}_IFACE)\n#define _${key_interface}_IFACE\n\n";
        if(exists $interface{$key_interface}{packet}){
            my @packet=@{$interface{$key_interface}{packet}};
            foreach my $key_group (@packet){
                my $field_array=$groups_flat{$key_interface}{$key_group};
                my $lsb=-1;   #the last lsb.
                my $msb=-1;  #the last $msb;              
                foreach my $field (@{$field_array}){
                    foreach my $key (keys %{$field}){
                        my $width=${$field}{$key}{width};        
                        if(${$field}{$key}{size}==1){
                            $lsb=$msb+1;
                            $msb=$lsb+$width-1; 
                            print FILE "#define PKT_${key_group}_${key}_WIDTH $width\n";
                            print FILE "#define PKT_${key_group}_${key}_LSB $lsb\n";
                            print FILE "#define PKT_${key_group}_${key}_MSB $msb\n";
                            print FILE "#define PKT_${key_group}_${key}_FIELD $msb:$lsb\n";
                        }else{
                            my $size=${$field}{$key}{size};
                            my $last_msb=$msb;
                            for(my $index=0;$index<$size;$index++){
                                $lsb=$last_msb+1+$index*$width;
                                $msb=$lsb+$width-1;
                                print FILE "#define PKT_${key_group}_${key}${index}_WIDTH $width\n";
                                print FILE "#define PKT_${key_group}_${key}${index}_LSB $lsb\n";
                                print FILE "#define PKT_${key_group}_${key}${index}_MSB $msb\n";
                                print FILE "#define PKT_${key_group}_${key}${index}_FIELD $msb:$lsb\n";
                            }
                        }        
                    }
                }    
                print FILE "#define PKT_${key_group}_WIDTH $groups{$key_group}{WIDTH}\n\n";
            }
            print FILE "#define FLOW_${key_interface} $flow\n\n";
            my $pd=$interface{$key_interface}{pd};
            print FILE "#define SIG_${key_interface}_PD_WIDTH $pd\n";
            print FILE "#define SIG_${key_interface}_PD_FIELD ".eval($pd-1).":0\n\n"; 
            my $payload=$interface{$key_interface}{payload};
            print FILE "#define PKT_${key_interface}_PAYLOAD_WIDTH    $payload\n";
            print FILE "#define PKT_${key_interface}_PAYLOAD_FIELD    ".eval($payload-1).":0\n";    
            my $id=$interface{$key_interface}{id};
            print FILE "#define PKT_${key_interface}_ID_WIDTH    $id\n";
            print FILE "#define PKT_${key_interface}_ID_FIELD    ".eval($payload+$id-1).":$payload\n"; 
            for(my $index=0;$index<=$#packet;$index++){            
                print FILE "#define PKT_${key_interface}_$packet[$index]_FIELD    ".eval($groups{$packet[$index]}{WIDTH}-1).":0\n";
                print FILE "#define PKT_${key_interface}_$packet[$index]_ID       ${id}'d${index}\n";
                print FILE "#define PKT_${key_interface}_$packet[$index]_int_ID   $index\n";
            }
            print FILE "\n#endif // !defined(_${key_interface}_IFACE)\n";
        }elsif(exists $interface{$key_interface}{group}){
            print FILE "#define FLOW_${key_interface} $flow\n\n";
            my $group=$interface{$key_interface}{group};
            my @fields=@{$groups_flat{$key_interface}{$group}};
            foreach my $field (@fields){
                foreach my $key (keys %{$field}){
                    if(${$field}{$key}{size}==1){
                        print FILE "#define SIG_${key_interface}_${key}_WIDTH ${$field}{$key}{width}\n";
                        print FILE "#define SIG_${key_interface}_${key}_FIELD ".eval(${$field}{$key}{width}-1).":0\n"; 
                    }else{
                        my $size=${$field}{$key}{size};
                        for(my $index=0;$index<$size;$index++){
                            print FILE "#define SIG_${key_interface}_${key}${index}_WIDTH ${$field}{$key}{width}\n";
                            print FILE "#define SIG_${key_interface}_${key}${index}_FIELD ".eval(${$field}{$key}{width}-1).":0\n"; 
                        }
                    }  
                }
            }
            print FILE "\n#endif // !defined(_${key_interface}_IFACE)"; 
        }
        close FILE; 
    }
}

sub emit_c
{
    foreach my $key_interface (keys %interface){
        open FILE,'>',"$OutDir/odif_${key_interface}.h";
        print FILE "#if !defined(_${key_interface}_iface_H_)\n#define _${key_interface}_iface_H_\n\n";
        print FILE "#include <stdint.h>\n";
        if(exists $interface{$key_interface}{packet}){
            my $id=$interface{$key_interface}{id};
            my @packet=@{$interface{$key_interface}{packet}};
            foreach my $key_group (@packet){
                print FILE "#ifndef _${key_group}_struct_H_\n#define _${key_group}_struct_H_\n\n";
                my $field_array=$groups_flat{$key_interface}{$key_group};
                print FILE "typedef struct ${key_group}_s {\n";
                foreach my $field (@{$field_array}){
                    foreach my $key (keys %{$field}){
                        my $width=${$field}{$key}{width};
                        if(${$field}{$key}{size}==1){
                            print FILE "    sc_int<$width> $key ;\n";
                        }else{
                            my $size=${$field}{$key}{size}; 
                            print FILE "    sc_int<$width> $key\[$size\] ;\n";                 
                        }
                    }
                }
                print FILE "} ${key_group}_t;\n\n#endif\n";    
            }
            print FILE "union ${key_interface}_u {\n";
            #print FILE "    uint8_t tag;\n";        
            print FILE "    sc_int<$id> tag;\n";
            foreach my $key_group (@packet){
                    print FILE "    ${key_group}_t $key_group;\n";        
            }
            print FILE "};\n";
            print FILE "typedef struct ${key_interface}_s {\n";
            print FILE "    union ${key_interface}_u pd ;\n} ${key_interface}_t;\n\n";
            print FILE "#endif // !defined(_${key_interface}_iface_H_)\n";
        }elsif(exists $interface{$key_interface}{group}){
            print FILE "typedef struct ${key_interface}_s {\n";
            my $group=$interface{$key_interface}{group};
            my @fields=@{$groups_flat{$key_interface}{$group}};
            foreach my $field (@fields){
                foreach my $key (keys %{$field}){
                    my $width=${$field}{$key}{width};
                    if(${$field}{$key}{size}==1){
                        print FILE "    sc_int<$width> $key ;\n";
                    }else{
                        my $size=${$field}{$key}{size};
                        print FILE "    sc_int<$width> $key\[$size\] ;\n";
                    }
                }
            }
            print FILE "} ${key_interface}_t;\n\n";
            print FILE "#endif // !defined(_${key_interface}_iface_H_)\n";
        } 
        close FILE;
    }
}

#main
if(!@ARGV)
{
    print_usage;
    exit 1;
}
GetOptions (
    'f=s'       => \$filename,
    'o=s'       => \$OutDir,
    'c'         => \$Cmod,
    'iv'        => \$interface_Verilog,
    'V'       => \$module_Verilog,
    'sv'        => \$SystemVerilog,
    'm'         => \$Macros,
    'help|h'      => \$print_help
);
if ($print_help == 1){
    print_usage;
    exit 0;
}

#get all group information.
open FILE,'<',"$filename" or die "Cannot open $filename: $!";
while(<FILE>)
{
   next unless /^\s*import\s+(.+?)\s*$/;
   my $sub_filename = $1;
   open my $fh,'<',"$OutDir/$sub_filename" or die $!;
   while (<$fh>)
   {
       chomp;
       if(/^\s*$/){
           next;
       }elsif(/^\s*group\s+(\w+?)\s*$/){
           $current_state="group";
           $group_name=$1;
       }elsif(/^\s*interface\s+(\w+?)\s*$/){
           $current_state="interface";
           $interface_name=$1;
       }elsif(/^\s*flow\s+(\w+?)\s*$/){
           my $flow=$1;
           if($flow!~/^valid$/ && $flow!~/^valid_ready$/){
               print STDERR "ERROR: ODIF doesn't support flow \"$flow\" (in interface \"$interface_name\"). It only supports \"valid_ready\" and \"valid\" flow now!\n\n";
               exit 1;
           }
           $interface{$interface_name}{flow}=$flow;
       }elsif(/^\s*packet\s+(.+?)\s*$/){
           my @packet=split /\s+/,$1;
           $interface{$interface_name}{packet}=\@packet;
       }elsif(/^\s*field\s+(?<name>\w+?)\s*(\[(?<size>\d+)\])?\s+(?<width>\d+)\s*$/ && $current_state eq "group"){
           my %field=();
           $field{width}=$+{width};
           if(defined $+{size}){
               $field{size}=$+{size};
           }else{
               $field{size}=1;
           }
           push @{$groups{$group_name}{FIELD}},{$+{name}=>\%field};    
       }elsif(/^\s*add\s+(\w+?)\s*$/ && $current_state eq "group"){
           push @{$groups{$group_name}{FIELD}},{'add'=>$1};
       }elsif(/^\s*field\s+(?<name>\w+?)\s*(\[(?<size>\d+)\])?\s+(?<width>\d+)\s*$/ && $current_state eq "interface"){
           my %field=();
           $field{width}=$+{width};
           if(defined $+{size}){
               $field{size}=$+{size};
           }else{
               $field{size}=1;
           }
           push @{$groups{"${interface_name}_group"}{FIELD}},{$+{name}=>\%field};            
           $interface{$interface_name}{group}="${interface_name}_group";
       }elsif(/^\s*add\s+(\w+?)\s*$/ && $current_state eq "interface"){
           push @{$groups{"${interface_name}_group"}{FIELD}},{'add'=>$1};
           $interface{$interface_name}{group}="${interface_name}_group";
       }elsif(/^\s*module\s+(\w+?)\s*$/){
           $current_state="module";
           $module_name=$1;
       }elsif(/^\s*(in|out)\s+(?<interface>\w+?)(?:\s+(?<instance>\w+?))?(?:\s*\[(?<size>\d+)\])?\s*$/ && $current_state eq "module"){
           my $in_out=$1;
           my $interface=$+{interface};
           my $instance="";
           my $size=1;
           my @instances=();
           if(!defined $+{instance} && !defined $+{size}){
               $instance=$interface;
           }elsif(defined $+{instance} && !defined $+{size}){
               $instance=$+{instance}; 
           }elsif(!defined $+{instance} && defined $+{size}){
               $instance=$interface;
               $size=$+{size};
           }elsif(defined $+{instance} && defined $+{size}){
               $instance=$+{instance};
               $size=$+{size};
           }
           if($size<1){
               print STDERR "ERROR: instance size should be larger than 1 in \"$_\"!\n";
               exit 1;
           }
           if($size==1){
               push @instances,{'interface'=>$interface};
               push @instances,{'inout'=>$in_out};
               push @{$modules{$module_name}},{"$instance"=> \@instances};
           }else{
               push @instances,{'interface'=>$interface};
               push @instances,{'inout'=>$in_out};
               for(my $index=0;$index<$size;$index++){
                   push @{$modules{$module_name}},{"$instance$index"=>\@instances};
               }
           }
     }else{
           print STDERR "ERROR: ODIF doesn't support this feature \"$_\"!\n";
           exit 1;        
       }
   }
   close $fh;
}
close FILE;

#flatten 'add' information in group.
foreach my $key_interface (keys %interface){
    if(exists $interface{$key_interface}{packet}){
        my @packet=@{$interface{$key_interface}{packet}};
        foreach (@packet){
            my @tmp=@{$groups{$_}{FIELD}};
            $groups_flat{$key_interface}{$_}=\@tmp;
        }
    }elsif(exists $interface{$key_interface}{group}){
        my $group_name=$interface{$key_interface}{group};
        my @tmp=@{$groups{$group_name}{FIELD}};
        $groups_flat{$key_interface}{$group_name}=\@tmp;        
    }else{
        delete $groups_flat{$key_interface};
        delete $interface{$key_interface};
        next;
    }
    foreach my $key_group (keys %{$groups_flat{$key_interface}}){
        my $field_array=$groups_flat{$key_interface}{$key_group};
        my $flag=1;
        while($flag)
        {
            $flag=0;
            for(my $index=0;$index<=$#{$field_array};){
                if(exists ${${$field_array}[$index]}{add}){
                   $flag=1;
                   my @replace=@{$groups{${${$field_array}[$index]}{add}}{FIELD}};
                   splice @{$field_array},$index,1,@replace;
                   $index+=@replace;
                }else{
                   $index++;
                }
            }
        }
        if(!defined $groups{$key_group}{WIDTH}){
            my $width=0;
            foreach my $tmp_group (@{$field_array}){
                foreach my $tmp (keys %{$tmp_group}){
                    $width+=${$tmp_group}{$tmp}{width}*${$tmp_group}{$tmp}{size};
                }
            }
            $groups{$key_group}{WIDTH}=$width;
        }
    }
}    

#calculate id and payload and pd for each packet.
foreach my $key_interface (keys %interface){
    if(exists $interface{$key_interface}{packet}){
        my $payload=0; 
        my @packet=@{$interface{$key_interface}{packet}};
        foreach (@packet){
            my $load=$groups{$_}{WIDTH};
            if($payload < $load){
                $payload=$load;
            }
        }
        $interface{$key_interface}{payload}=$payload;
        my $id=sprintf("%b",@packet-1);
        $id=length($id);
        $interface{$key_interface}{id}=$id;
        my $pd=$payload+$id;
        $interface{$key_interface}{pd}=$pd;
    }else{
        next;
    }
}

if($Cmod){
    emit_c;
}

if($interface_Verilog)
{
    emit_interface_v;
}

if($SystemVerilog){
    emit_sv();
}

if($Macros){
    emit_macros;
}

if($module_Verilog)
{
    emit_module_v;
}
    
exit 0;
