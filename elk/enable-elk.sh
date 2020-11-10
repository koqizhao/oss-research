#!/bin/bash

if [ -z "$PASSWORD" ]; then
    echo -n "password: "
    read -s PASSWORD
    export PASSWORD
    echo
fi

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

echo -e "\n$ops started\n"

case $ops in 
    enable)
        echo -e "\ncomponent: elasticsearch\n"
        ./elasticsearch/remote-start.sh $scale

        echo -e "\ncomponent: kibana\n"
        ./kibana/remote-start.sh

        echo -e "\ncomponent: filebeat\n"
        ./filebeat/remote-start.sh

        ;;
    disable)
        echo -e "\ncomponent: filebeat\n"
        ./filebeat/remote-stop.sh

        echo -e "\ncomponent: kibana\n"
        ./kibana/remote-stop.sh

        echo -e "\ncomponent: elasticsearch\n"
        ./elasticsearch/remote-stop.sh $scale

        ;;
    deploy)
        echo -e "\ncomponent: elasticsearch\n"
        ./elasticsearch/deploy-service.sh $scale

        echo -e "\ncomponent: kibana\n"
        ./kibana/deploy-service.sh

        echo -e "\ncomponent: filebeat\n"
        ./filebeat/deploy-service.sh

        ;;
    clean)
        echo -e "\ncomponent: filebeat\n"
        ./filebeat/clean-service.sh

        echo -e "\ncomponent: kibana\n"
        ./kibana/clean-service.sh

        echo -e "\ncomponent: elasticsearch\n"
        ./elasticsearch/clean-service.sh $scale

        ;;
    *)
        echo -e "\nunknown ops: $ops\n"
        ;;
esac

echo
