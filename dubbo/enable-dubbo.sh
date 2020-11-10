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

echo -e "\n$ops started\n"

case $ops in 
    enable)
        echo -e "\ncomponent: dubbo-admin\n"
        cd ./dubbo-admin
        ./remote-start.sh

        echo -e "\ncomponent: soul\n"
        cd ../soul
        ./remote-start.sh

        echo -e "\ncomponent: sentinel\n"
        cd ../sentinel
        ./remote-start.sh

        echo -e "\ncomponent: demo-services\n"
        cd ../demo-services
        ./remote-start.sh $scale

        cd ..

        ;;
    disable)
        echo -e "\ncomponent: demo-services\n"
        cd ./demo-services
        ./remote-stop.sh $scale

        echo -e "\ncomponent: sentinel\n"
        cd ../sentinel
        ./remote-stop.sh

        echo -e "\ncomponent: soul\n"
        cd ../soul
        ./remote-stop.sh

        echo -e "\ncomponent: dubbo-admin\n"
        cd ../dubbo-admin
        ./remote-stop.sh

        cd ..

        ;;
    deploy)
        echo -e "\ncomponent: dubbo-admin\n"
        cd ./dubbo-admin
        ./deploy-service.sh

        echo -e "\ncomponent: soul\n"
        cd ../soul
        ./deploy-service.sh

        echo -e "\ncomponent: sentinel\n"
        cd ../sentinel
        ./deploy-service.sh

        echo -e "\ncomponent: demo-services\n"
        cd ../demo-services
        ./deploy-service.sh $scale

        cd ..

        ;;
     clean)
        echo -e "\ncomponent: demo-services\n"
        cd ./demo-services
        ./clean-service.sh $scale

        echo -e "\ncomponent: sentinel\n"
        cd ../sentinel
        ./clean-service.sh

        echo -e "\ncomponent: soul\n"
        cd ../soul
        ./clean-service.sh

        echo -e "\ncomponent: dubbo-admin\n"
        cd ../dubbo-admin
        ./clean-service.sh

        cd ..

        ;;
    *)
        echo -e "\nunknown ops: $ops\n"
        ;;
esac

echo
