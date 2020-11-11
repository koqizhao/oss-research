#!/bin/bash

do_ops()
{
    ops="enable"
    if [ -n "$1" ]
    then
        ops=$1
    fi

    case $ops in 
        enable)
            do_enable

            ;;
        disable)
            do_disable

            ;;
        deploy)
            do_deploy

            ;;
        clean)
            do_clean

            ;;
        *)
            echo -e "\nunknown ops: $ops\n"
            ;;
    esac

    echo
}
