#!/bin/bash

cp $AE_ROOT/images/br-base-bin-kvm-ulhcontext $AE_ROOT/br-base-bin-kvm
cp $AE_ROOT/images/Image-kvm-vanilla $AE_ROOT/mnt-firesim/Image
cp $AE_ROOT/images/qemu-kvm-vanilla $AE_ROOT/mnt-firesim/qemu-system-riscv64
$AE_ROOT/update/sync-hw.sh $AE_ROOT/nightly-scripts/config_runtime-DV.ini
