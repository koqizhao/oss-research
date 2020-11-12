#!/bin/bash

read_server_pass()
{
    if [ -z "$PASSWORD" ]; then
        echo -n "server password: "
        read -s PASSWORD
        echo

        export PASSWORD
    fi
}

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

db_exec()
{
    scp $1 $db_server:./
    ssh $db_server "cd ~/mysql/mysql; bin/mysql --connect-expired-password --user=root --password=$db_password < ~/$1;"
    ssh $db_server "rm ~/$1"
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
