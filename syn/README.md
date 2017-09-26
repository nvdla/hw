# NVDLA Open Source Project

> File: README.md
> Commands to run synthesis
> 
> Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
> NVDLA Open Hardware License; Check "LICENSE" which comes with 
> this distribution for more information.


## Running Non-physical synthesis (Wireload Models)
---
You can run:
```
<OSDLA_RELEASE>/syn/scripts/syn_launch.sh -mode wlm -config /path/to/config.sh
```
You need to have a wire load model defined in your standard cell library, or a separate file (in liberty syntax, as described in [this SOLVNET article](https://solvnet.synopsys.com/dow_retrieve/N-2017.09/libolh/Content/lcug1/lcug16_Defining_Wire_Load_Groups.htm).

In the configuration file the following variables are required to be defined:
* **WIRELOAD_MODEL_NAME**
* **TARGET_LIB** 
* **LINK_LIB**
* **DC_PATH**

The following variables are optional:
**WIRELOAD_MODEL_FILE**

## Running physical synthesis 
---
You can run one of the following, To pick DC-Topographical-Graphical/Design Explorer:
```
<OSDLA_RELEASE>/syn/scripts/syn_launch.sh -mode dct -config /path/to/config.sh
<OSDLA_RELEASE>/syn/scripts/syn_launch.sh -mode dcg -config /path/to/config.sh
<OSDLA_RELEASE>/syn/scripts/syn_launch.sh -mode de -config /path/to/config.sh
```

In the configuration file, the following variables are required to be defined:
* **TARGET_LIB**
* **LINK_LIB**
* **MW_LIB**
* **DC_PATH**
* **TF_FILE**
* **TLUPLUS_FILE**
* **TLUPLUS_MAPPING_FILE**
* **MIN_ROUTING_LAYER**
* **MAX_ROUTING_LAYER**

Additionally, you may require the following variables depending on how your physical library views were built:
* **HORIZONTAL_LAYERS**
* **VERTICAL_LAYERS**

