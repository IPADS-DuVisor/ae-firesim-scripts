#!/bin/bash

mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev
mount -t proc proc /proc

./qemu-system-riscv64 \
    -nographic \
    -cpu host \
    -smp 2 \
    -M virt,accel=kvm \
    -m 4096M \
    -bios none \
    -kernel ./eva_vipi_loop_guest_kvm.img
    #-kernel ./eva_vipi_loop_guest_noexit_kvm.img
