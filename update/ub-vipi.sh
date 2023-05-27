#!/bin/bash

$AE_ROOT/update/sync-hw.sh $AE_ROOT/nightly-scripts/config_runtime-vipi.ini
cp $AE_ROOT/images/br-base-bin-kvm-micro-vipi $AE_ROOT/br-base-bin-kvm
