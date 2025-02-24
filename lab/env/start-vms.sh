#!/bin/bash

action=$1
machine_count=3

if [ -n "$2" ]
then
    machine_count=$2
fi

for i in `seq 1 $machine_count`
do
    machine="server$i"
    case $action in
        stop)
            VBoxManage controlvm $machine poweroff
            ;;
        *)
            VBoxManage startvm $machine
            ;;
    esac
done
