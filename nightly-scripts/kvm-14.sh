#!/bin/bash

mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev
mount -t proc proc /proc

./qemu-system-riscv64 \
    -nographic \
    -cpu host \
    -smp 1 \
    -M virt,accel=kvm \
    -m 4096M \
    -bios none \
    -kernel ./eva_mmio_tty.img
