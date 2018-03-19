# NVDLA Open Source Hardware
---

## NVDLA

The NVIDIA Deep Learning Accelerator (NVDLA) is a free and open architecture that promotes
a standard way to design deep learning inference accelerators. With its modular architecture,
NVDLA is scalable, highly configurable, and designed to simplify integration and portability.
Learn more about NVDLA on the project web page.

<http://nvdla.org/>

## Online Documentation

NVDLA documentation is located [here](http://nvdla.org/contents.html).  Hardware specific 
documentation is located at the following pages.
* [Hardware Architecture](http://nvdla.org/hwarch.html).
* [Integrator's Manual](http://nvdla.org/integration_guide.html).

This README file contains only basic information.

## Directory Structure

This repository contains the RTL, C-model, and testbench code associated with the NVDLA hardware 
release.  In this repository, you will find:

  * vmod/ -- RTL model, including:
    * vmod/nvdla/ -- Verilog implementation of NVDLA
    * vmod/vlibs/ -- library and cell models
    * vmod/rams/ -- behavioral models of RAMs used by NVDLA
  * syn/ -- example synthesis scripts for NVDLA
  * perf/ -- performance estimator spreadsheet for NVDLA
  * verif/ -- trace-player testbench for basic sanity validation
    * verif/traces/ -- sample traces associated with various networks
  * tools -- tools used for building the RTL and running simulation/synthesis/etc.
  * spec -- RTL configuration option settings.

## Building the NVDLA Hardware

See the [integrator's manual](http://nvdla.org/integration_guide.html) for more information on 
the setup and other build commands and options.  The basic build command to compile the design
and run a short sanity simulation is:

    bin/tmake

