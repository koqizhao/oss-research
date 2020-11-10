#!/bin/bash

rp=`realpath $0`
apollo_path=`dirname $rp`
cd $apollo_path

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
source servers-$scale.sh

echo -e "\n$ops started\n"

case $ops in 
    enable)
        echo -e "\ncomponent: config-service\n"
        cd config-service
        ./remote-start.sh ${config_servers[@]}

        echo -e "\ncomponent: admin-service\n"
        cd ../admin-service
        ./remote-start.sh ${admin_servers[@]}

        echo -e "\ncomponent: portal\n"
        cd ../portal
        ./remote-start.sh ${portal_servers[@]}

        cd ..

        ;;
    disable)
        echo -e "\ncomponent: portal\n"
        cd portal
        ./remote-stop.sh ${portal_servers[@]}

        echo -e "\ncomponent: admin-service\n"
        cd ../admin-service
        ./remote-stop.sh ${admin_servers[@]}

        echo -e "\ncomponent: config-service\n"
        cd ../config-service
        ./remote-stop.sh ${config_servers[@]}

        cd ..

        ;;
    deploy)
        echo -e "\ncomponent: config-service\n"
        cd config-service
        ./deploy-service.sh ${config_servers[@]}

        echo -e "\ncomponent: admin-service\n"
        cd ../admin-service
        ./deploy-service.sh ${admin_servers[@]}

        echo -e "\ncomponent: portal\n"
        cd ../portal
        ./deploy-service.sh ${portal_servers[@]}

        cd ..

        ;;
     clean)
        echo -e "\ncomponent: config-service\n"
        cd config-service
        ./clean-service.sh ${config_servers[@]}

        echo -e "\ncomponent: admin-service\n"
        cd ../admin-service
        ./clean-service.sh ${admin_servers[@]}

        echo -e "\ncomponent: portal\n"
        cd ../portal
        ./clean-service.sh ${portal_servers[@]}

        cd ..

        ;;
    *)
        echo -e "\nunknown ops: $ops\n"
        ;;
esac

echo
