HOST=${HOST:-"127.0.0.1"}
TIMES=${TIMES:-3}

n=0

while [ $n -lt $TIMES ]; do 
    #./netperf -l 5 -H $HOST -t omni -- -T UDP -m 64,64 -d rr -O "THROUGHPUT, THROUGHPUT_UNITS, MIN_LATENCY, MAX_LATENCY, MEAN_LATENCY"
    ./netperf -l 3 -H $HOST -t TCP_STREAM
    ./netperf -l 3 -H $HOST -t TCP_MAERTS
n=$(( n + 1 ))
done
