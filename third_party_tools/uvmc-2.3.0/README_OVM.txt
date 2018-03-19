
This release of UVM Connect supports usage in OVM.
Testing was only made on the latest version of OVM, i.e. 2.1.2.


To compile the libraries for OVM:

> cd lib
> setenv OVM_HOME <path to OVM installation>
> make -f Makefile.<tool> OVM=1 all

This compiles the UVM Connect library into a package named ovmc_pkg,
which you can import into your OVM testbench.

 import ovmc_pkg::*;
 #include "uvmc_macros.s


Note: UVM Connect has been independently verified to run on VCS
and Incisive, but we can not yet distribute the Makefiles used
to build UVM Connect with those simulators. Ahead of other
simulators' Makefile availability, you can use the Questa
version as a template.

