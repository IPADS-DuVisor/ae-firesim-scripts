#!/bin/bash

cd rootfs
find . | cpio -o --format=newc > ../rootfs-net2.img

cd ..
cp rootfs-net2.img ../laputa/test-files-laputa/rootfs-net.img
scp rootfs-net2.img ldj@r641:/home/ldj/firesim/mnt-firesim/laputa/rootfs-net.img
