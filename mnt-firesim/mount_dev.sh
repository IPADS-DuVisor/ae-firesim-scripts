#!/bin/bash

mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev
mount -t proc proc /proc

mkdir -p /mnt/huge
sysctl -p && sysctl -p
mount -t hugetlbfs none /mnt/huge
