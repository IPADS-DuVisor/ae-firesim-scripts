#!/bin/zsh

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"

INTERVAL=30
LIMIT=5400 # ulh needs 60+ min
SEQ_FILE=/tmp/cmd-seq
ARG1=${1:-""}
ARG2=${2:-""}
ARG3=${3:-""}

# wait untill tests done or timeout
function wait_for_tests() {
    local loop_acc=0
    IP_STRING=`aws ec2 describe-instances --instance-ids i-010dda3702a93b5e1 | grep PublicIp | awk '{print $2}' | paste -d " " - - | cut -d '"' -f 2`
    IP=`echo $IP_STRING | cut -d " " -f 1 | head -1`
    echo $IP

    while true; do
        echo -ne "\r ${YELLOW} Time spent: $(($loop_acc / 60)) min. LOG_NAME:$1 ${ENDCOLOR}"
        ret=$(ssh -i ~/aws-scripts/west/firesim.pem centos@$IP "cat ~/laputa.log|grep Winter|wc -l"|head -1|awk '{print $1}')
        if [ $ret -eq 1 ]; then
            scp -i ~/aws-scripts/west/firesim.pem centos@$IP:~/laputa.log log/$1
            break
        fi

        if [[ "$1" == "vanillakvm-breakdown-vplic.log" || "$1" == "kvm-breakdown-vplic.log" ]]; then
            (( $loop_acc >= 1200 )) && \
            scp -i ~/aws-scripts/west/firesim.pem centos@$IP:~/laputa.log log/$1 && \
            break
        fi

        if [ $loop_acc -ge $LIMIT ]; then
            echo "\n ${RED} TIMEOUT! ${ENDCOLOR}\n"
            break
        fi

        sleep $INTERVAL

        loop_acc=$(($loop_acc + $INTERVAL))
    done;
}

function update_scripts() {
    #cp ./nightly-scripts/ab-$1.sh \
    #    ./firesim-scripts/scripts-rootfs/nginx_client.sh

    cp ./nightly-scripts/cpu-$1.sh \
        ./firesim-scripts/scripts-rootfs/sysbench_cpu_run.sh

    cp ./nightly-scripts/memaslap-$1.sh \
        ./firesim-scripts/scripts-rootfs/memcached_client.sh

    #cp ./nightly-scripts/memcached-$1.sh \
    #    ./firesim-scripts/scripts-rootfs/memcached_server.sh
}

function test_kvm() {
    echo "${YELLOW} ./nightly-scripts/kvm-$1.sh ${ENDCOLOR}"

    if [[ "$2" == "fig9" ]]; then
        ./update/2.sh
        if [[ "$3" == "dv" ]]; then
            cp $AE_ROOT/images/br-base-bin-kvm-dv-fig9 $AE_ROOT/br-base-bin-kvm
        else
            cp $AE_ROOT/images/br-base-bin-kvm-fig9 $AE_ROOT/br-base-bin-kvm
            cp $AE_ROOT/images/qemu-kvm-vanilla $AE_ROOT/mnt-firesim/qemu-system-riscv64
        fi
    else
        ./update/0.sh # change hardware to vipi
        ./update/1.sh # change software to vipi
    fi
    if [[ "$2" == "fig10" ]]; then
        cp ./nightly-scripts/1_core.expect.kvm.fig10-$3 \
            ./firesim-scripts/scripts-laputa/1_core.expect
    else
        cp ./nightly-scripts/1_core.expect.kvm \
            ./firesim-scripts/scripts-laputa/1_core.expect
    fi
    cp ./nightly-scripts/kvm-$1.sh ./mnt-firesim/kvm_linux.sh

    ./firesim-scripts/kvm.sh sync
}

function test_ulh() {
    echo "${YELLOW} ./nightly-scripts/laputa-$1.sh ${ENDCOLOR}"

    cp images/br-base-bin-laputa  br-base-bin-laputa

    if [[ "$2" == "micro" ]]; then
        cp ./nightly-scripts/1_core.expect.ulh-micro \
            ./firesim-scripts/scripts-laputa/1_core.expect
        # micro does not need initrd, since image isn't linux
    elif [[ "$2" == "fig10" ]]; then
        cp ./nightly-scripts/1_core.expect.ulh.fig10 \
            ./firesim-scripts/scripts-laputa/1_core.expect
        cp ./assets/ulh-app-fig10-$4.initrd.cpio ./mnt-firesim/laputa/rootfs-net.img
    elif [[ "$2" == "fig10b" ]]; then
        cp ./nightly-scripts/1_core.expect.ulh.fig10b \
            ./firesim-scripts/scripts-laputa/1_core.expect
        echo "copy ./assets/ulh-app-fig10b-$4.initrd.cpio"
        cp ./assets/ulh-app-fig10b-$4.initrd.cpio ./mnt-firesim/laputa/rootfs-net.img
        if [[ "$3" == "pmp" ]]; then
            echo "Correct PMP Path"
            $AE_ROOT/update/sync-hw.sh $AE_ROOT/nightly-scripts/config_runtime-vipi.ini
            cp images/br-base-bin-laputa  br-base-bin-laputa
        else
            echo "Correct NOPMP Path"
            $AE_ROOT/update/sync-hw.sh $AE_ROOT/nightly-scripts/config_runtime-nopmp.ini
            cp images/br-base-bin-laputa  br-base-bin-laputa
            # cp images/br-base-bin-laputa-nopmp  br-base-bin-laputa
        fi
    else
        echo "TRACE: change hw to vipi"
        ./update/0.sh # change hardware to vipi
        cp ./nightly-scripts/1_core.expect.ulh \
            ./firesim-scripts/scripts-laputa/1_core.expect
        cp ./assets/ulh-app.initrd.cpio ./mnt-firesim/laputa/rootfs-net.img
    fi
    cp ./nightly-scripts/laputa-$1.sh ./mnt-firesim/laputa_linux.sh

    ./firesim-scripts/laputa.sh sync
}

function test_native() {
    echo "${YELLOW} native-$1 ${ENDCOLOR}"

    # set hardware to vanilla
    $AE_ROOT/update/sync-hw.sh $AE_ROOT/nightly-scripts/config_runtime-DV.ini
    cp ./assets/br-base-bin-native-$1 \
        ./br-base-bin-kvm
    cp ./nightly-scripts/1_core.expect.native \
        ./firesim-scripts/scripts-laputa/1_core.expect

    ./firesim-scripts/native.sh sync $1
}

function breakdown() {
    genre=$1
    ./update/breakdown-$genre.sh # sync host kernel and hardware
    ./firesim-scripts/ready-breakdown.sh $1 # preparation for breakdown
}

function vanilla_breakdown() {
    genre=$1
    ./update/vanilla-breakdown-$genre.sh # sync host kernel and hardware
    ./firesim-scripts/ready-breakdown.sh $1 # preparation for breakdown
}

function ub() {
    genre=$1
    ./update/ub-$genre.sh # sync host kernel and hardware
    ./firesim-scripts/ready-breakdown.sh ub-$1 # preparation for breakdown
}


# kill firesim on manager node
function reset_firesim() {
    ~/aws-scripts/west/reset.sh
}

function main() {
    while true; do
        if [ -s $SEQ_FILE ]; then
            head -n 1 $SEQ_FILE | IFS=" " read ARCH VCPU ADDI ADDI2 ADDI3
            sed -i '1d' $SEQ_FILE
        else
            echo
            break
        fi

        [[ "$ARCH" == "#" ]] && echo "continue" && continue
    
        reset_firesim
        # date
        # update_scripts $VCPU
    
        OLD_ARCH=$ARCH
        OLD_VCPU=$VCPU

        cp $AE_ROOT/images/qemu-kvm-vipi $AE_ROOT/mnt-firesim/qemu-system-riscv64
    
        # reuse ulh for hypercall / s2pf / mmio
        if [[ "$ARCH" == "ub" && ( "$VCPU" == "hypercall" || "$VCPU" == "s2pf" || "$VCPU" == "mmio" ) ]]; then
            OP=$VCPU
            cp assets/laputa-$OP mnt-firesim/laputa/laputa
            ARCH=ulh
            [ "$OP" = "hypercall" ] && VCPU=11
            [ "$OP" = "s2pf" ] && VCPU=13
            [ "$OP" = "mmio" ] && VCPU=14
            ADDI="micro"
        fi
    
        LOG_NAME="NONE"
    
        if [ "$ARCH" = "kvm" ]; then
            if [[ "$ADDI" == "fig9" ]]; then
                LOG_NAME=kvm-$VCPU-$ADDI-$ADDI2.log
            elif [[ "$ADDI" == "fig10" ]]; then
                LOG_NAME=kvm-$VCPU-$ADDI-$ADDI2.log
            else
                LOG_NAME=kvm-$VCPU.log
            fi
            test_kvm $VCPU $ADDI $ADDI2
            sleep 10
        elif [ "$ARCH" = "ulh" ]; then
            if [[ "$ADDI" != "micro" ]]; then 
                cp assets/laputa-app mnt-firesim/laputa/laputa
                if [[ "$ADDI" == "fig10" ]]; then
                    echo "[TRACE] ADDI:$ADDI ADDI2:$ADDI2"
                    LOG_NAME=ulh-$VCPU-fig10-$ADDI2.log
                elif [[ "$ADDI" == "fig10b" ]]; then
                    echo "[TRACE] ADDI:$ADDI ADDI2:$ADDI2 $ADDI3:$ADDI3"
                    LOG_NAME=ulh-$VCPU-fig10b-$ADDI2-$ADDI3.log
                else
                    LOG_NAME=ulh-$VCPU.log
                fi
            else
                # ub-options: ['hypercall', 's2pf', 'mmio']
                LOG_NAME=duvisor-breakdown-$OLD_VCPU.log
            fi
            test_ulh $VCPU $ADDI $ADDI2 $ADDI3
            sleep 10
        elif [ "$ARCH" = "native" ]; then
            LOG_NAME=native-$VCPU.log
            test_native $VCPU
            sleep 10
        elif [ "$ARCH" = "breakdown" ]; then
            # breakdown-options: ['hypercall', 's2pf', 'mmio', 'vipi', 'vplic']
            OP=$VCPU
            LOG_NAME=kvm-breakdown-$VCPU.log
            breakdown $OP
        elif [ "$ARCH" = "vanilla-breakdown" ]; then
            # vanilla-breakdown-options: ['vipi', 'vplic']
            OP=$VCPU
            LOG_NAME=vanillakvm-breakdown-$VCPU.log
            vanilla_breakdown $OP
        elif [ "$ARCH" = "ub" ]; then
            # ub-options: ['vipi', 'vplic']
            LOG_NAME=duvisor-breakdown-$VCPU.log
            OP=$VCPU
            ub $OP
        elif [ "$ARCH" = "update" ]; then
            cat ./update/$VCPU.sh
            ./update/$VCPU.sh
            continue
        else
            continue
        fi
        wait_for_tests $LOG_NAME
    done
}
main $@
