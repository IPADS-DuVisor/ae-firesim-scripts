#!/bin/bash
set -e

FPGA_IP=192.168.3.100
TYPE=${1:-""}
ARG2=$2

trap error ERR
function error {
    pkill screen
}

trap ctrl_c INT
function ctrl_c {
    pkill screen
}

if [[ "$TYPE" == "native" ]]; then
    ARG1="kvm"
else
    ARG1=$TYPE
fi

echo "TYPE == $TYPE"
echo "ARG1 == $ARG1"
echo "ARG2 == $ARG2"

if [[ -z $ARG1 || "$ARG1" != "kvm" && "$ARG1" != "laputa" ]]; then
    echo please choose kvm or laputa
    exit -1
fi

cd $AE_ROOT
source sourceme-f1-manager.sh
cd -
./scripts-laputa/start_instance.sh

echo "TRACE start_instance successfully!"


cd $AE_ROOT
echo "TARCE scp rootfs"
scp -r $AE_ROOT/firesim-scripts/scripts-rootfs $FPGA_IP:~/
echo "TARCE tar mnt-firesim"
tar -cvzf mnt-firesim.tar.gz mnt-firesim
echo "TARCE scp mnt-firesim"
scp $AE_ROOT/mnt-firesim.tar.gz $FPGA_IP:~/
echo "TARCE ssh-tar"
ssh $FPGA_IP "sudo tar -vxzf mnt-firesim.tar.gz"
cd -
echo "TRACE copy assets successfully!"

if [[ $ARG1 == "laputa" ]]; then
echo "TRACE copy laputa br-base-bin successfully!"
scp $AE_ROOT/br-base-bin-laputa $FPGA_IP:~/sim_slot_0/linux-uniform0-br-base-bin-ulh-correct
else
echo "TRACE copy kvm br-base-bin successfully!"
scp $AE_ROOT/br-base-bin-kvm $FPGA_IP:~/sim_slot_0/linux-uniform0-br-base-bin-kvm-correct
fi

scp $AE_ROOT/br-base-bin-$ARG1 $FPGA_IP:~/sim_slot_0/linux-uniform0-br-base-bin
echo "copy br-base-bin-$ARG1 to FPGA node successfully"

# echo "./switch_to_$ARG1.sh"
# while ! ssh $FPGA_IP "./switch_to_$ARG1.sh"
# do
#         echo "Trying again..."
#         sleep 2
# done

echo "ABCDEFG"
echo "./scripts-rootfs/copy_myself.sh"
ssh $FPGA_IP "./scripts-rootfs/copy_myself.sh"

# if [[ $ARG1 == "laputa" ]]; then
# ssh $FPGA_IP "cp sim_slot_0/linux-uniform0-br-base-bin-ulh-correct sim_slot_0/linux-uniform0-br-base-bin"
# else
# ssh $FPGA_IP "cp sim_slot_0/linux-uniform0-br-base-bin-kvm-correct sim_slot_0/linux-uniform0-br-base-bin"
# fi

./scripts-laputa/start_workload.sh
echo "TARCE: start fpga simulation successfully!!"

mkdir -p $AE_ROOT/log-laputa
mkdir -p $AE_ROOT/firesim-scripts/log-laputa
LOG_NAME="$AE_ROOT/log-laputa/`date +%Y-%m-%d-%T`"
LOG_NAME1="./log-laputa/`date +%Y-%m-%d-%T`"
echo $LOG_NAME
echo $LOG_NAME1
./scripts-laputa/1_core.expect $ARG1 $ARG2 | tee $LOG_NAME1 | tee $LOG_NAME

./scripts-laputa/stop_workload.exp
./scripts-laputa/stop_instance.sh

pkill screen
