HOST=${HOST:-"http://127.0.0.1:80/"}
TIMES=${TIMES:-3}

n=0

while [ $n -lt $TIMES ]; do 
    ab -n 1000 -c $((32 * 1)) $HOST
n=$(( n + 1 ))
done
