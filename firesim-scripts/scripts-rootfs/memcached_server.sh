MEM=2048
if [ -n "$1" ]; then
    MEM="$1"
fi
echo "MEMCACHED SIZE:${MEM}MB"
/usr/local/bin/memcached -d -M ${MEM}M -u root -t 4
