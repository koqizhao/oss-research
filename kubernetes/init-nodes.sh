#!/bin/bash

set -e

echo -n "password: "
read -s PASSWORD
echo

scale="dist"
if [ -n "$1" ]
then
    scale=$1
fi

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source servers-$scale.sh

for i in "${servers[@]}"
do
    scp init-env.sh $i:./
    ssh $i "echo '$PASSWORD' | sudo -S sh init-env.sh; rm init-env.sh; echo '$PASSWORD' | sudo -S reboot" || echo
done

echo
