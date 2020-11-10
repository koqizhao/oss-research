#!/bin/bash

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path

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

case $ops in 
    enable)
        cd zookeeper
        ./remote-start.sh $scale

        cd ../zkui
        ./remote-start.sh

        ;;
    disable)
        cd zkui
        ./remote-stop.sh

        cd ../zookeeper
        ./remote-stop.sh $scale

        ;;
    deploy)
        cd zookeeper
        ./deploy-service.sh $scale

        cd ../zkui
        ./deploy-service.sh

        ;;
     clean)
        cd zkui
        ./clean-service.sh

        cd ../zookeeper
        ./clean-service.sh $scale

        ;;
    *)
        echo "unknown ops: $ops"
        ;;
esac

echo
