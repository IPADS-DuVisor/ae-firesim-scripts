TIMES=${TIMES:-3}

cd home/ubuntu/lmbench-3.0-a9/bin/riscv64-linux-gnu/
TIMES=1
n=0
while [ $n -lt $TIMES ]; do 
    echo "count:$n total:$TIMES"
    dd if=/dev/zero of=test.txt bs=10M count=1
    echo "running fcp"
    ./bw_mem 150M fcp
    ./bw_mem 100M fcp
    n=$(( n + 1 ))
done
