#!/bin/bash
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
mkdir -p raw

# start manager node
RET=`aws ec2 describe-instances --instance-ids i-010dda3702a93b5e1 | grep running`
if [[ -z $RET ]]; then
    RET=`aws ec2 start-instances --instance-ids i-010dda3702a93b5e1 | grep running`
fi
while [[ -z $RET ]]; do
    RET=`aws ec2 describe-instances --instance-ids i-010dda3702a93b5e1 | grep running`
    sleep 1
done
echo "Firesim manager started!!!!"

# get manager ip addr
IP_STRING=`aws ec2 describe-instances --instance-ids i-010dda3702a93b5e1 | grep PublicIp | awk '{print $2}' | paste -d " " - - | cut -d '"' -f 2`
IP=`echo $IP_STRING | cut -d " " -f 1`
echo Manager IP is $IP

rsync -P -avz -e 'ssh  -o StrictHostKeyChecking=no -i ~/aws-scripts/west/firesim.pem' -r br-base-bin-kvm mnt-firesim firesim-scripts centos@${IP}:~/firesim
echo "${YELLOW} I'm going to aws server!! ${ENDCOLOR}"
ssh -f  -o StrictHostKeyChecking=no -i ~/aws-scripts/west/firesim.pem centos@${IP} "cd firesim/firesim-scripts && nohup ./scripts-laputa/breakdown.sh $1 > ~/laputa.log 2>&1 &"
