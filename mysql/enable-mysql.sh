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

echo -e "\n$ops started\n"

case $ops in 
    enable)
        ./remote-start.sh

        ;;
    disable)
        ./remote-stop.sh

        ;;
    deploy)
        ./deploy-service.sh

        ;;
    clean)
        ./clean-service.sh

        ;;
    *)
        echo -e "\nunknown ops: $ops\n"
        ;;
esac

echo
