#!/bin/bash

cd rootfs
find . | cpio -o --format=newc > ../rootfs-net2.img

cd ..
cp rootfs-net2.img ~/firesim/mnt-firesim/laputa/rootfs-net.img
