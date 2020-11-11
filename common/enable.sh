#!/bin/bash

do_ops()
{
    ops="start"
    if [ -n "$1" ]
    then
        ops=$1
    fi

    case $ops in 
        start)
            do_start

            ;;
        stop)
            do_stop

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
