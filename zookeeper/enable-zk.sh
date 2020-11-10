#!/bin/bash

if [ -z "$PASSWORD" ]; then
    echo -n "password: "
    read -s PASSWORD
    export PASSWORD
    echo
fi

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
        echo -e "\ncomponent: zookeeper\n"
        cd zookeeper
        ./remote-start.sh $scale

        echo -e "\ncomponent: zkui\n"
        cd ../zkui
        ./remote-start.sh

        ;;
    disable)
        echo -e "\ncomponent: zkui\n"
        cd zkui
        ./remote-stop.sh

        echo -e "\ncomponent: zookeeper\n"
        cd ../zookeeper
        ./remote-stop.sh $scale

        ;;
    deploy)
        echo -e "\ncomponent: zookeeper\n"
        cd zookeeper
        ./deploy-service.sh $scale

        echo -e "\ncomponent: zkui\n"
        cd ../zkui
        ./deploy-service.sh

        ;;
     clean)
        echo -e "\ncomponent: zkui\n"
        cd zkui
        ./clean-service.sh

        echo -e "\ncomponent: zookeeper\n"
        cd ../zookeeper
        ./clean-service.sh $scale

        ;;
    *)
        echo -e "\nunknown ops: $ops\n"
        ;;
esac

echo
