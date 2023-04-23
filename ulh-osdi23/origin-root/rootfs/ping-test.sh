#!/bin/bash

NR_PING=$1

if [ -e $NR_PING ]; then
    echo "Usage: $0 <nr_ping>";
    exit 1;
fi

ping 192.168.10.1 -c $NR_PING

if [ $? -eq 0 ]; then
    echo "Ping test OK"
else
    echo "Ping test failed"
fi
