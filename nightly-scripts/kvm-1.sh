#!/bin/bash

mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev
mount -t proc proc /proc

./qemu-system-riscv64 \
    -nographic \
    -cpu host \
    -smp 1 \
    -M virt,accel=kvm \
    -m 512M \
    -name guest=riscv-guset \
    -bios none \
    -kernel ./Image \
    -append "root=/dev/vda rw console=ttyS0 earlycon=sbi" \
    -initrd ./rootfs.img \
    -device virtio-blk-pci,drive=hd0 \
    -drive file=/blk-dev.img,format=raw,id=hd0 \
    -device virtio-net-pci,netdev=vnet \
    -netdev tap,vhost=on,id=vnet,ifname=tap0,script=no $@
    #-netdev tap,id=vnet,ifname=tap0,script=no $@
