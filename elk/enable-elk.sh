#!/bin/bash

ops="enable"
if [ -n "$1" ]
then
    ops=$1
fi

scale="dist"
if [ -n "$2" ]
then
    scale=$2
fi

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path

case $ops in 
    enable)
        ./elasticsearch/remote-start.sh $scale
        ./kibana/remote-start.sh
        ./filebeat/remote-start.sh

        ;;
    disable)
        ./filebeat/remote-stop.sh
        ./kibana/remote-stop.sh
        ./elasticsearch/remote-stop.sh $scale

        ;;
    deploy)
        ./elasticsearch/deploy-service.sh $scale
        ./kibana/deploy-service.sh
        ./filebeat/deploy-service.sh

        ;;
    clean)
        ./filebeat/clean-service.sh
        ./kibana/clean-service.sh
        ./elasticsearch/clean-service.sh $scale

        ;;
    *)
        echo "unknown ops: $ops"
        ;;
esac

echo
