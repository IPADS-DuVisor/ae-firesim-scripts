#!/bin/bash

cp $AE_ROOT/images/Image-kvm-vanilla $AE_ROOT/mnt-firesim/Image
cp $AE_ROOT/images/qemu-kvm-vanilla $AE_ROOT/mnt-firesim/qemu-system-riscv64
$AE_ROOT/update/sync-hw.sh $AE_ROOT/nightly-scripts/config_runtime-DV.ini
