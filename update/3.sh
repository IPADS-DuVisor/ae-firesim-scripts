#!/bin/bash

cp ~/firesim/images/br-base-bin-kvm-ulhcontext ~/firesim/br-base-bin-kvm
cp ~/firesim/images/Image-kvm-vanilla ~/firesim/mnt-firesim/Image
cp ~/firesim/images/qemu-kvm-vanilla ~/firesim/mnt-firesim/qemu-system-riscv64
~/firesim/update/sync-hw.sh ~/firesim/nightly-scripts/config_runtime-DV.ini
