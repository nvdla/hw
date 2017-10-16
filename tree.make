## ================================================================
## NVDLA Open Source Project
## 
## Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
## NVDLA Open Hardware License; Check "LICENSE" which comes with 
## this distribution for more information.
## ================================================================
##
## set the chip you want to build 
PROJECTS := nv_large nv_small

#=================
# ENV TOOL setup
#=================
# c pre-processor
CPP  := /home/utils/gcc-4.0.0/bin/cpp

# used in ordt to generate reigster, need be newer than 1.7
JAVA := /home/utils/java/jdk1.8.0_131/bin/java

# used in ordt to generate reigster, need be newer than 1.7
PERL := /home/utils/perl-5.8.8/bin/perl

