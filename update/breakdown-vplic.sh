#!/bin/bash

# update hardware
$AE_ROOT/update/sync-hw.sh $AE_ROOT/nightly-scripts/config_runtime-vipi.ini

# update host kernel
cp $AE_ROOT/images/br-base-bin-kvm-micro-vplic $AE_ROOT/br-base-bin-kvm

# update guest kernel
cp $AE_ROOT/assets/kvmopt-Image.vplic mnt-firesim/Image.vplic

# update guest kernel module
cp $AE_ROOT/assets/kvmopt-vplic.ko firesim-scripts/scripts-rootfs/vplic.ko
