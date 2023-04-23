HOST=${HOST:-"127.0.0.1"}
TIMES=${TIMES:-3}

n=0

while [ $n -lt $TIMES ]; do 
    ./netperf -l 3 -H $HOST -t TCP_STREAM
n=$(( n + 1 ))
done
