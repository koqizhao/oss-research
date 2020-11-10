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

cd ~/Research
echo -e "\n$ops started\n"

case $ops in 
    enable)
        echo -e "\nelk\n"
        elk/enable-elk.sh $ops $scale
        echo

        echo -e "\nmysql\n"
        mysql/remote-start.sh $ops $scale
        echo

        echo -e "\napollo\n"
        apollo/enable-apollo.sh $ops $scale
        echo

        echo -e "\nzookeeper\n"
        zookeeper/enable-zk.sh $ops $scale
        echo

        echo -e "\ndubbo\n"
        dubbo/enable-dubbo.sh $ops $scale
        echo

        ;;
    disable)
        echo -e "\ndubbo\n"
        dubbo/enable-dubbo.sh $ops $scale
        echo

        echo -e "\nzookeeper\n"
        zookeeper/enable-zk.sh $ops $scale
        echo

        echo -e "\napollo\n"
        apollo/enable-apollo.sh $ops $scale
        echo

        echo -e "\nmysql\n"
        mysql/remote-stop.sh $ops $scale
        echo

        echo -e "\nelk\n"
        elk/enable-elk.sh $ops $scale
        echo

        ;;
     deploy)
        echo -e "\nelk\n"
        elk/enable-elk.sh $ops $scale
        echo

        echo -e "\nmysql\n"
        mysql/remote-start.sh $ops $scale
        echo

        echo -e "\napollo\n"
        apollo/enable-apollo.sh $ops $scale
        echo

        echo -e "\nzookeeper\n"
        zookeeper/enable-zk.sh $ops $scale
        echo

        echo -e "\ndubbo\n"
        dubbo/enable-dubbo.sh $ops $scale
        echo

        ;;
     clean)
        echo -e "\ndubbo\n"
        dubbo/enable-dubbo.sh $ops $scale
        echo

        echo -e "\nzookeeper\n"
        zookeeper/enable-zk.sh $ops $scale
        echo

        echo -e "\napollo\n"
        apollo/enable-apollo.sh $ops $scale
        echo

        echo -e "\nmysql\n"
        mysql/remote-stop.sh $ops $scale
        echo

        echo -e "\nelk\n"
        elk/enable-elk.sh $ops $scale
        echo

        ;;
    *)
        echo -e "\nunknown ops: $ops\n"
        ;;
esac

echo
