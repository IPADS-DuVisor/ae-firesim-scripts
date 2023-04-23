TIMES=${TIMES:-1}

n=0

while [ $n -lt $TIMES ]; do 
    /home/ubuntu/sysbench-0.4.12.16/sysbench/sysbench --test=cpu --num-threads=4 --cpu-max-prime=10000 run
n=$(( n + 1 ))
done
