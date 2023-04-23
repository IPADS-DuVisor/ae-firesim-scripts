#!/bin/bash

cd laputa

./laputa \
    --smp 1 \
    --initrd ./test-files-laputa/rootfs-net.img \
    --dtb ./test-files-laputa/vmlinux.dtb  \
    --kernel ./test-files-laputa/Image \
    --memory 1024 \
    --machine laputa_virt \
    --block /blk-dev.img
