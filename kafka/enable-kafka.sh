#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

ops="enable"
if [ -n "$1" ]
then
    ops=$1
fi

servers=(192.168.56.11 192.168.56.12 192.168.56.13)
lead=192.168.56.11

rp=`realpath $0`
dir=`dirname $rp`
source $dir/../remote-enable.sh

case $ops in 
    enable)
        $ops $lead $PASSWORD zookeeper

        for server in ${servers[@]}
        do
            $ops $server $PASSWORD kafka
            $ops $server $PASSWORD jmx-exporter
        done

        $ops $lead $PASSWORD kafka-manager
        $ops $lead $PASSWORD kafka-exporter

        ;;
    disable)
        $ops $lead $PASSWORD kafka-manager
        $ops $lead $PASSWORD kafka-exporter
 
        for server in ${servers[@]}
        do
            $ops $server $PASSWORD jmx-exporter
            $ops $server $PASSWORD kafka
        done

        $ops $lead $PASSWORD zookeeper

        ;;
    *)
        echo "unknown ops: $ops"
        ;;
esac

echo
