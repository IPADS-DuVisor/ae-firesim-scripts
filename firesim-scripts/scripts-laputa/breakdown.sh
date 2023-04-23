#!/bin/bash
set -e

FPGA_IP=192.168.3.100
TYPE=$1

trap error ERR
function error {
    pkill screen
}

trap ctrl_c INT
function ctrl_c {
    pkill screen
}

echo "TYPE == $TYPE"

cd ~/firesim
source sourceme-f1-manager.sh
cd -
./scripts-laputa/start_instance.sh

cd ~/firesim
scp -r ~/firesim/firesim-scripts/scripts-rootfs $FPGA_IP:~/
tar -cvzf mnt-firesim.tar.gz mnt-firesim
scp ~/firesim/mnt-firesim.tar.gz $FPGA_IP:~/
ssh $FPGA_IP "sudo tar -vxzf mnt-firesim.tar.gz"
cd -
echo "assets copy to FPGA Node successfully"

ssh $FPGA_IP "./scripts-rootfs/copy_myself.sh"
echo "FPGA copy_myself successfully"

scp ~/firesim/br-base-bin-kvm $FPGA_IP:~/sim_slot_0/linux-uniform0-br-base-bin
echo "copy br-base-bin-kvm to FPGA node successfully"

./scripts-laputa/start_workload.sh
echo "infrasetup && runworkload successfully"

mkdir -p ~/firesim/log-laputa
mkdir -p ~/firesim/firesim-scripts/log-laputa
LOG_NAME="~/firesim/log-laputa/`date +%Y-%m-%d-%T`"
LOG_NAME1="./log-laputa/`date +%Y-%m-%d-%T`"
echo $LOG_NAME
echo $LOG_NAME1
if [[ "$TYPE" == "vipi" ]]; then
	./scripts-laputa/on_linux-vipi.expect $TYPE | tee $LOG_NAME1 | tee $LOG_NAME
elif [[ "$TYPE" == "ub-vipi" ]]; then
	./scripts-laputa/on_linux-ub-vipi.expect $TYPE | tee $LOG_NAME1 | tee $LOG_NAME
elif [[ "$TYPE" == "vplic" ]]; then
	./scripts-laputa/on_linux-vplic.expect $TYPE | tee $LOG_NAME1 | tee $LOG_NAME
else
	./scripts-laputa/on_baremetal.expect $TYPE | tee $LOG_NAME1 | tee $LOG_NAME
fi

./scripts-laputa/stop_workload.exp
./scripts-laputa/stop_instance.sh

pkill screen
