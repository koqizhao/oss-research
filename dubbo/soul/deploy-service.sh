#!/bin/bash

project_path=/home/koqizhao/Projects/misc/soul
components=(admin bootstrap)
deploy_path=/home/koqizhao/soul

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path
source ./servers.sh

deploy()
{
    server=$1
    component=soul-$2
    deploy_file=$project_path/$component/target/$component.jar

    echo -e "\ndeploy started: $server/$component\n"

    ssh $server "mkdir -p $deploy_path"

    scp $deploy_file $server:$deploy_path
    scp start-$component.sh $server:$deploy_path

    ssh $server "cd $deploy_path; ./start-$component.sh"

    echo -e "\ndeploy finished: $server/$component"
}

for server in ${servers[@]}
do
    for component in ${components[@]}
    do
        deploy $server $component
    done
done
