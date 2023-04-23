#!/bin/bash

INSTANCE=${INSTANCE:-"i-0b43f7d60a9ed4aaf"}

RUNNING=$(aws ec2 describe-instance-status --instance-id $INSTANCE | grep running)
echo starting instance... RUNNING: $RUNNING

echo WAITING.... \n\n\n\n

if [[ -z $RUNNING ]]; then
aws ec2 start-instances --instance-id i-0b43f7d60a9ed4aaf
fi


while [[ -z $RUNNING ]]; do

RUNNING=$(aws ec2 describe-instance-status --instance-id $INSTANCE | grep running)
sleep 1
done


echo instance started
