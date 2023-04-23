#!/bin/bash

# update hardware
~/firesim/update/sync-hw.sh ~/firesim/nightly-scripts/config_runtime-vipi.ini

# update host kernel
cp ~/firesim/images/br-base-bin-kvm-micro-vplic ~/firesim/br-base-bin-kvm

# update guest kernel
cp ~/firesim/assets/kvmopt-Image.vplic mnt-firesim/Image.vplic

# update guest kernel module
cp ~/firesim/assets/kvmopt-vplic.ko firesim-scripts/scripts-rootfs/vplic.ko
