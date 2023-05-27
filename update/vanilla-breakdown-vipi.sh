#!/bin/bash

# update qemu
cp $AE_ROOT/images/qemu-kvm-vanilla $AE_ROOT/mnt-firesim/qemu-system-riscv64

# update hardware
$AE_ROOT/update/sync-hw.sh $AE_ROOT/nightly-scripts/config_runtime-DV.ini

# update host kernel
cp $AE_ROOT/images/br-base-bin-vanillakvm-micro-vipi $AE_ROOT/br-base-bin-kvm 

# update guest kernel
cp $AE_ROOT/assets/vanillakvm-Image.vipi mnt-firesim/Image.vipi 

# update guest kernel module
cp $AE_ROOT/assets/vanillakvm-vipi.ko firesim-scripts/scripts-rootfs/vipi.ko
