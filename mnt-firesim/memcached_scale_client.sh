#cd /home/ubuntu/memtier_benchmark
HOST=${HOST:-127.0.0.1}
TIMES=${TIMES:-3}
#./memtier_benchmark -s $HOST -p 11211 -P memcache_binary
#cd /home/ubuntu/libmemcached-1.0.18/clients
n=0

while [ $n -lt $TIMES ]; do
    echo "memcached data size:$1 count:$n"
    ./memtier_benchmark --hide-histogram -s $HOST -p 11211 -P memcache_binary --test-time=5 --threads=1 -d $1 # & #-d 1 -c 1
    #./memaslap -s $HOST:11211 -v 0.2 -e 0.05 -B -T 8 -c $((32 * 1)) -x 100000
    n=$(( n + 1 ))
done
