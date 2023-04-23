#!/bin/bash

ip link set eth0 up
ip addr add 192.168.254.3/16 dev eth0
ip route add default via 192.168.10.1 dev eth0
