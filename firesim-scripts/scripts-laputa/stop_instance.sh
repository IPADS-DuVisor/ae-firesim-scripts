#!/bin/bash

INSTANCE=${INSTANCE:-"i-0b43f7d60a9ed4aaf"}
STOP=""
STOP=$(aws ec2 stop-instances --instance-id $INSTANCE | grep stop)
while [ -z $STOP ]; do
    STOP=$(aws ec2 stop-instances --instance-id $INSTANCE | grep stop)
sleep 1
done
