#!/bin/bash

echo "Initializing..."

./mount_dev.sh

echo "Mount procfs..."

./guest_net.sh

echo "Setup network..."

./memcached_server.sh

echo "Memcached server started"

bash
