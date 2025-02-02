#!/bin/bash

set -e

server_count=3
for i in `seq 1 $server_count`
do
    let "index=i-1" || index=0
    servers[$index]="192.168.56.1$i"
done
