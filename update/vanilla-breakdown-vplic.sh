#!/bin/bash

# update qemu
cp ~/firesim/images/qemu-kvm-vanilla ~/firesim/mnt-firesim/qemu-system-riscv64

# update hardware
~/firesim/update/sync-hw.sh ~/firesim/nightly-scripts/config_runtime-DV.ini

# update host kernel
cp ~/firesim/images/br-base-bin-vanillakvm-micro-vplic ~/firesim/br-base-bin-kvm 

# update guest kernel
cp ~/firesim/assets/vanillakvm-Image.vplic mnt-firesim/Image.vplic

# update guest kernel module
cp ~/firesim/assets/vanillakvm-vplic.ko firesim-scripts/scripts-rootfs/vplic.ko
