#!/bin/bash

NR_DIR=$1
NR_FILE=$2

if [ -e $NR_DIR ] || [ -e $NR_FILE ]; then
    echo "Usage: $0 <nr_dir> <nr_file>";
    exit 1;
fi

# Generate data

mount /dev/vda /root

rm -rf /root/block-test

mkdir -p /root/block-test

for i in $(seq 1 $NR_DIR)
do
    mkdir -p /root/block-test/dir-$i &&
    echo "dir-$i" > /root/block-test/dir-$i/$i &&
    cat /root/block-test/dir-$i/$i;
done

for i in $(seq 1 $NR_FILE)
do
    echo "file-$i" > /root/block-test/file-$i;
done

sync

umount /root

# Check data

mount /dev/vda /root

for i in $(seq 1 $NR_DIR)
do
    CONTENT=$(cat /root/block-test/dir-$i/$i);
    if [ "$CONTENT" != "dir-$i" ]; then
        echo "Block test failed: ['$CONTENT' != 'dir-$i']";
        exit 1;
    fi
done

for i in $(seq 1 $NR_FILE)
do
    CONTENT=$(cat /root/block-test/file-$i);
    if [ "$CONTENT" != "file-$i" ]; then
        echo "Block test failed: ['$CONTENT' != 'file-$i']";
        exit 1;
    fi
done

sync

umount /root
    
echo "Block test OK"
