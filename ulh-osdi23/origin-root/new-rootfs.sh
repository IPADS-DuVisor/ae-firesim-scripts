#!/bin/bash

cd rootfs
find . | cpio -o --format=newc > ../rootfs-net2.img

cd ..
cp rootfs-net2.img $AR_ROOT/mnt-firesim/laputa/rootfs-net.img
