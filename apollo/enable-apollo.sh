#!/bin/bash

ops="enable"
if [ -n "$1" ]
then
    ops=$1
fi

rp=`realpath $0`
apollo_path=`dirname $rp`
cd $apollo_path

case $ops in 
    enable)
        cd config-service
        ./remote-start.sh

        cd ../admin-service
        ./remote-start.sh

        cd ../portal
        ./remote-start.sh

        cd ..

        ;;
    disable)
        cd portal
        ./remote-stop.sh

        cd ../admin-service
        ./remote-stop.sh

        cd ../config-service
        ./remote-stop.sh

        cd ..

        ;;
    *)
        echo "unknown ops: $ops"
        ;;
esac

echo
