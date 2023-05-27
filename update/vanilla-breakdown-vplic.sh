#!/bin/bash

# update qemu
cp $AE_ROOT/images/qemu-kvm-vanilla $AE_ROOT/mnt-firesim/qemu-system-riscv64

# update hardware
$AE_ROOT/update/sync-hw.sh $AE_ROOT/nightly-scripts/config_runtime-DV.ini

# update host kernel
cp $AE_ROOT/images/br-base-bin-vanillakvm-micro-vplic $AE_ROOT/br-base-bin-kvm 

# update guest kernel
cp $AE_ROOT/assets/vanillakvm-Image.vplic mnt-firesim/Image.vplic

# update guest kernel module
cp $AE_ROOT/assets/vanillakvm-vplic.ko firesim-scripts/scripts-rootfs/vplic.ko
