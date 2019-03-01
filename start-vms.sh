#!/bin/bash

MACHINES=(ubuntu-server ubuntu-server2 ubuntu-server3)

for i in "${MACHINES[@]}"
do
    case $1 in
        stop)
            VBoxManage controlvm $i poweroff
            ;;
        *)
            VBoxManage startvm $i
            ;;
    esac
done

