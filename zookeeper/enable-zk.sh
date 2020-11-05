#!/bin/bash

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path/zookeeper

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
        ./remote-start.sh $scale

        ;;
    disable)
        ./remote-stop.sh $scale

        ;;
    deploy)
        ./deploy-service.sh $scale

        ;;
     clean)
        ./clean-service.sh $scale

        ;;
    *)
        echo "unknown ops: $ops"
        ;;
esac

echo
