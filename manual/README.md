> Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
> NVDLA Open Hardware License; Check "LICENSE" which comes with 
> this distribution for more information.
> 
> File: README.md
> 

Make sure you have java 1.7 or later version installed
Update variable JAVA in make/tools.mk to point to your local java installation

then you can use below command to generate rtl, ral and cmod
```
make
```

Following backends will be generated:
* **regs_v.v**: verilog model
* **regs_ral.sv**: ral class  
* **cmod**: c++ model
* **sv**: systemverilog model
