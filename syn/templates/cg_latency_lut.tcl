# ===================================================================
# File: syn/templates/cg_latency_lut.tcl
# NVDLA Open Source Project
# Fanout based lookup table for overconstraining CG enable paths. 
#
# Copyright (c) 2016 – 2017 NVIDIA Corporation. Licensed under the
# NVDLA Open Hardware License; see the "LICENSE.txt" file that came
# with this distribution for more information.
# ===================================================================

    set timingDeltaTableForCgEnable(0)      106
    set timingDeltaTableForCgEnable(4)      108
    set timingDeltaTableForCgEnable(16)     112
    set timingDeltaTableForCgEnable(64)     127
    set timingDeltaTableForCgEnable(256)    162
    set timingDeltaTableForCgEnable(1024)   216
    set timingDeltaTableForCgEnable(4096)   280
    set timingDeltaTableForCgEnable(16384)  347
    set timingDeltaTableForCgEnable(65536)  415

foreach tableIndex [lsort -integer [array names timingDeltaTableForCgEnable]] {
     puts "\[CGTable\] - $tableIndex = $timingDeltaTableForCgEnable($tableIndex)"
}
