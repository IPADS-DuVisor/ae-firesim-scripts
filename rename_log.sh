#!/bin/bash

function rename_log() {
    ls ./server-log | grep "^laputa-0" | sort | tail -n 1 | \
        xargs -I {} cp server-log/{} server-log/"$1-$2".log;

    ls ./client-log | grep "^laputa-1" | sort | tail -n 1 | \
        xargs -I {} cp client-log/{} client-log/"$1-$2".log;
}

rename_log $1 $2
