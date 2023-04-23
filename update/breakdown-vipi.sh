#!/bin/bash

# update hardware
~/firesim/update/sync-hw.sh ~/firesim/nightly-scripts/config_runtime-vipi.ini

# update host kernel
cp ~/firesim/images/br-base-bin-kvm-micro-vipi ~/firesim/br-base-bin-kvm 

# update guest kernel
cp ~/firesim/assets/kvmopt-Image.vipi mnt-firesim/Image.vipi 


# update guest kernel module
cp ~/firesim/assets/kvmopt-vipi.ko firesim-scripts/scripts-rootfs/vipi.ko
