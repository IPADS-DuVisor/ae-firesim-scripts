#!/bin/bash

~/firesim/update/sync-hw.sh ~/firesim/nightly-scripts/config_runtime-vipi.ini
cp ~/firesim/images/br-base-bin-kvm-micro-mmio ~/firesim/br-base-bin-kvm
cp ~/firesim/images/qemu-kvm-vipi ~/firesim/mnt-firesim/qemu-system-riscv64
