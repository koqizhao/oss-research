#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

ops="enable"
if [ -n "$1" ]
then
    ops=$1
fi

es_servers=(192.168.56.11 192.168.56.14)
filebeat_servers=(192.168.56.11 192.168.56.12 192.168.56.13 192.168.56.14 192.168.56.15)
kibana_server=192.168.56.15

rp=`realpath $0`
dir=`dirname $rp`
source $dir/../remote-enable.sh

case $ops in 
    enable)
        for server in ${es_servers[@]}
        do
            $ops $server $PASSWORD elasticsearch
        done

        $ops $kibana_server $PASSWORD kibana

        for server in ${filebeat_servers[@]}
        do
            $ops $server $PASSWORD filebeat
        done

        ;;
    disable)
        for server in ${filebeat_servers[@]}
        do
            $ops $server $PASSWORD filebeat
        done

        $ops $kibana_server $PASSWORD kibana

        for server in ${es_servers[@]}
        do
            $ops $server $PASSWORD elasticsearch
        done

        ;;
    *)
        echo "unknown ops: $ops"
        ;;
esac

echo
