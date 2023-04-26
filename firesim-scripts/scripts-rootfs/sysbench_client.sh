HOST=${HOST:-'127.0.0.1'}

TIMES=${TIMES:-3}

n=0

while [ $n -lt $TIMES ]; do 
    /home/ubuntu/sysbench-0.4.12.16/sysbench/sysbench --num-threads=4 --max-requests=0 --max-time=10  --test=oltp --mysql-table-engine=innodb --oltp-table-size=1000000 --mysql-db=dbtest --mysql-user=root  --mysql-password=123 --mysql-host=$HOST run
    n=$(( n + 1 ))
done
