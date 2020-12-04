#!/bin/bash

init_scale()
{
    scale="basic"
    t_scale_dir=`pwd`
    if [ "$1" == "dist" ]; then
        scale="dist"
    fi

    if [ -n $2 ]; then
        t_scale_dir=$2
    fi

    t_dir_pwd=`pwd`
    cd $t_scale_dir
    source servers-$scale.sh
    cd $t_dir_pwd

    t_scale_dir=""
    t_dir_pwd=""
}

clean_all()
{
    for s in `merge_array $@`
    do
        ssh $s "rm -rf $deploy_path"
    done
}

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
        restart)
            do_stop

            declare interval_s=${stop_start_interval:-1}
            echo -e "\nsleep $interval_s seconds between stop and start\n"
            sleep $interval_s

            do_start

            ;;
        deploy)
            do_deploy

            ;;
        clean)
            do_clean

            ;;
        redeploy)
            do_clean
            do_deploy

            ;;
        status)
            do_status

            ;;
        *)
            echo -e "\nunknown ops: $ops\n"
            ;;
    esac

    echo
}

batch_start()
{
    for server in ${servers[@]}
    do
        echo -e "\nstart started: $server\n"
        remote_start $server $component
        echo -e "\nstart finished: $server\n"
    done
}

batch_stop()
{
    for server in ${servers[@]}
    do
        echo -e "\nstop started: $server\n"
        remote_stop $server $component
        echo -e "\nstop finished: $server\n"
    done
}

batch_deploy()
{
    for server in ${servers[@]}
    do
        echo -e "\ndeploy started: $server\n"
        remote_deploy $server $component
        echo -e "\ndeploy finished: $server\n"
    done
}

batch_clean()
{
    for server in ${servers[@]}
    do
        echo -e "\nclean started: $server\n"
        remote_clean $server $component
        echo -e "\nclean finished: $server\n"
    done
}

batch_status()
{
    for server in ${servers[@]}
    do
        echo -e "\nstatus started: $server\n"
        remote_status $server $component
        echo -e "\nstatus finished: $server\n"
    done
}

batch_restart()
{
    for server in ${servers[@]}
    do
        echo -e "\nstop started: $server\n"
        remote_stop $server $component
        echo -e "\nstop finished: $server\n"
        echo -e "\nstart started: $server\n"
        remote_start $server $component
        echo -e "\nstart finished: $server\n"
    done
}
