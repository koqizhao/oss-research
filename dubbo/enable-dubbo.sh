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
        cd ./dubbo-admin
        ./remote-start.sh

        cd ../soul
        ./remote-start.sh

        cd ../sentinel
        ./remote-start.sh

        cd ../demo-services
        ./remote-start.sh $scale

        cd ..

        ;;
    disable)
        cd ./demo-services
        ./remote-stop.sh $scale

        cd ../sentinel
        ./remote-stop.sh

        cd ../soul
        ./remote-stop.sh

        cd ../dubbo-admin
        ./remote-stop.sh

        cd ..

        ;;
    deploy)
        cd ./dubbo-admin
        ./deploy-service.sh

        cd ../soul
        ./deploy-service.sh

        cd ../sentinel
        ./deploy-service.sh

        cd ../demo-services
        ./deploy-service.sh $scale

        cd ..

        ;;
     clean)
        cd ./demo-services
        ./clean-service.sh $scale

        cd ../sentinel
        ./clean-service.sh

        cd ../soul
        ./clean-service.sh

        cd ../dubbo-admin
        ./clean-service.sh

        cd ..

        ;;
    *)
        echo "unknown ops: $ops"
        ;;
esac

echo
