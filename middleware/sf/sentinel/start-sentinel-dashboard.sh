#!/bin/bash

nic=enp0s8
ip=`ip addr | grep "global $nic" | awk '{ print $2 }' | awk -F '/' '{ print $1 }'`
port=8085
java -Dserver.port=$port -Dcsp.sentinel.dashboard.server=${ip}:$port \
    -Dproject.name=sentinel-dashboard -jar sentinel-dashboard.jar > sentinel-dashboard.out 2>&1 &
