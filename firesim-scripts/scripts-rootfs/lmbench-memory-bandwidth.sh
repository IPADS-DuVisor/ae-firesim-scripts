TIMES=${TIMES:-3}

cd home/ubuntu/lmbench-3.0-a9/bin/riscv64-linux-gnu/
n=0
PRIMITIVE=$1
while [ $n -lt $TIMES ]; do 
    echo "count:$n total:$TIMES"
    dd if=/dev/zero of=test.txt bs=10M count=1
    echo "running $PRIMITIVE"
    ./bw_mem 100M $PRIMITIVE
    n=$(( n + 1 ))
done
