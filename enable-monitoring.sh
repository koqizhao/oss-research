#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

ops="enable"
if [ -n "$1" ]
then
    ops=$1
fi

prometheus_server=192.168.56.14
grafana_server=192.168.56.15

dir=`dirname $0`
source $dir/remote-enable.sh

case $ops in 
    enable)
        $ops $prometheus_server $PASSWORD prometheus
        $ops $grafana_server $PASSWORD grafana

        ;;
    disable)
        $ops $grafana_server $PASSWORD grafana
        $ops $prometheus_server $PASSWORD prometheus

        ;;
    *)
        echo "unknown ops: $ops"
        ;;
esac

echo
