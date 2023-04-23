ID=$1

if [ -e $ID ]; then
    echo "Usage: $0 <vm_id>";
    exit 1;
fi

DIR=/root/vm$ID
TAP=vmtap$ID
MAC=52:54:00:12:34:0$ID

/root/lkvm-static run \
    -m 1024 \
    -c 1 \
    --console serial \
    -p "console=ttyS0 earlycon=uart8250,mmio,0x3f8" \
    -k $DIR/Image \
    -i $DIR/rootfs.img \
    -d $DIR/blk-dev.img \
    -n trans=mmio,mode=tap,tapif=$TAP,guest_mac=$MAC
    --debug $@
