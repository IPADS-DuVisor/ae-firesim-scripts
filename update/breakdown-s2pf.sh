#!/bin/bash

$AE_ROOT/update/sync-hw.sh $AE_ROOT/nightly-scripts/config_runtime-vipi.ini
cp $AE_ROOT/images/br-base-bin-kvm-micro-s2pf $AE_ROOT/br-base-bin-kvm
cp $AE_ROOT/images/qemu-kvm-vipi $AE_ROOT/mnt-firesim/qemu-system-riscv64
