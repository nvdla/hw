# NVDLA Open Source Project hardware
---

This repository contains all RTL, C-model, and testbench code associated with the NVDLA hardware release.  In this repository, you will find:

  * vmod/ -- RTL model, including:
    * vmod/nvdla/ -- Verilog implementation of NVDLA itself
    * vmod/vlibs/ -- library and cell models
    * vmod/rams/ -- behavioral models of RAMs used by NVDLA
  * syn/ -- example synthesis scripts for NVDLA
  * perf/ -- performance estimator spreadsheet for NVDLA
  * verif/ -- trace-player testbench for basic sanity validation
    * verif/traces/ -- sample traces associated with various networks

## Environment Requirement
    CPP:  gcc-4.0 or later is required and update CPP variable in make/tools.mk
    PERL: perl-5.8.8 or later is required and set as your default perl, use "/usr/bin/env perl -v" to check
    JAVA: jdk1.7 or later is required and update JAVA variable in make/tools.mk

For more information, please visit [NVDLA website](http://nvdla.org/).
