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

case $ops in 
    enable)
        cd config-service
        ./remote-start.sh ${config_servers[@]}

        cd ../admin-service
        ./remote-start.sh ${admin_servers[@]}

        cd ../portal
        ./remote-start.sh ${portal_servers[@]}

        cd ..

        ;;
    disable)
        cd portal
        ./remote-stop.sh ${portal_servers[@]}

        cd ../admin-service
        ./remote-stop.sh ${admin_servers[@]}

        cd ../config-service
        ./remote-stop.sh ${config_servers[@]}

        cd ..

        ;;
    deploy)
        cd config-service
        ./deploy-service.sh ${config_servers[@]}

        cd ../admin-service
        ./deploy-service.sh ${admin_servers[@]}

        cd ../portal
        ./deploy-service.sh ${portal_servers[@]}

        cd ..

        ;;
     clean)
        cd config-service
        ./clean-service.sh ${config_servers[@]}

        cd ../admin-service
        ./clean-service.sh ${admin_servers[@]}

        cd ../portal
        ./clean-service.sh ${portal_servers[@]}

        cd ..

        ;;
    *)
        echo "unknown ops: $ops"
        ;;
esac

echo
