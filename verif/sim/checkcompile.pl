#! /usr/bin/env perl

# ----------------------------------------------------------------------------
#      ___                                   _____                      ___     
#     /__/\          ___        ___         /  /::\       ___          /  /\    
#     \  \:\        /__/\      /  /\       /  /:/\:\     /  /\        /  /::\   
#      \  \:\       \  \:\    /  /:/      /  /:/  \:\   /  /:/       /  /:/\:\  
#  _____\__\:\       \  \:\  /__/::\     /__/:/ \__\:| /__/::\      /  /:/~/::\ 
# /__/::::::::\  ___  \__\:\ \__\/\:\__  \  \:\ /  /:/ \__\/\:\__  /__/:/ /:/\:\
# \  \:\~~\~~\/ /__/\ |  |:|    \  \:\/\  \  \:\  /:/     \  \:\/\ \  \:\/:/__\/
#  \  \:\  ~~~  \  \:\|  |:|     \__\::/   \  \:\/:/       \__\::/  \  \::/     
#   \  \:\       \  \:\__|:|     /__/:/     \  \::/        /__/:/    \  \:\     
#    \  \:\       \__\::::/      \__\/       \__\/         \__\/      \  \:\    
#     \__\/           ~~~~                                             \__\/    
#                                     ___                            ___   
#         _____                      /  /\             ___          /  /\  
#        /  /::\                    /  /::\           /  /\        /  /::\ 
#       /  /:/\:\                  /  /:/\:\         /  /:/       /  /:/\:\
#      /  /:/  \:\   __      __   /  /:/~/::\       /__/::\      /  /:/~/:/
#     /__/:/ \__\:/ /__/\   /  /\/__/:/ /:/\:\      \__\/\:\__  /__/:/ /:/ 
#     \  \:\ /  /:/ \  \:\ /  /:/\  \:\/:/__\/         \  \:\/\ \  \:\/:/  
#      \  \:\  /:/   \  \:\  /:/  \  \::/               \__\::/  \  \::/   
#       \  \:\/:/     \  \:\/:/    \  \:\               /__/:/    \  \:\   
#        \  \::/       \  \::/      \  \:\              \__\/      \  \:\  
#         \__\/         \__\/        \__\/                          \__\/  
# ----------------------------------------------------------------------------
#
# Simple compile log checker for pass fail status
# For now any warning or error is considered fatal.
#
# ----------------------------------------------------------------------------

use strict;
use warnings;

my $show_time = 1;

if ($show_time) {
use Time::Local;
}


my $log = $ARGV[0];
my $executable = $ARGV[1];
my $errors = 0;
my $warnings = 0;
my $found_uptodate = 0;

if (-e $log) {

   open (FH,"<$log");

   while (<FH>) {
     my $line = $_;
     while ($line =~ m/\\$/) {
        # print "LINE extention: $line";
        $line =~ s/\\$//;
        chomp($line);
        $line .= <FH>;
        # print "LINE extended: $line";
     }
     if ($line =~ m/Warning/) {
        #$warnings = $warnings + 1;
     }
     if ($line =~ m/Error/) {
        $errors = $errors + 1;
     }
     if ($line =~ m/up to date/) {
        $found_uptodate = 1;
     }
   }
}

#STEPHENH: allowing warnings for now. Old vcs versions complain our linux environment is unsupported? Probably too new for vcs to consider
#if (($errors == 0) && ($warnings ==0) && $found_uptodate) {
if (($errors == 0) && $found_uptodate) {
print (sprintf "\ncheckcompile : Compile Successful! \n\n") ;
} else {
print (sprintf ("\ncheckcompile : Compile FAILED (Warnings=%d, Errors=%d, ExecutableReady=%d) \nThe executable (%s) has been removed.\n\n",$warnings,$errors, $found_uptodate, $executable)) ;
my $result = `rm -f $executable ./${executable}.daidir/.vcs.timestamp`;
}

exit;
