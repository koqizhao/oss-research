#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

log_dir=`escape_slash $deploy_path/logs/$component`
sed "s/LOG_DIR_PLACEHOLDER/$log_dir/g" bin/oapService.sh \
    > bin/oapService.sh.tmp
chmod a+x bin/oapService.sh.tmp

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path/logs/$component"

    scp ~/Software/skywalking/$deploy_file $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf $deploy_file; mv $deploy_folder $component; rm $deploy_file"

    scp bin/oapService.sh.tmp $server:$deploy_path/$component/bin/oapService.sh

    sed "s/HOST_PLACEHOLDER/$server/g" conf/application.yml \
        > conf/application.yml.tmp
    scp conf/application.yml.tmp $server:$deploy_path/$component/config/application.yml
    rm conf/application.yml.tmp

    remote_start $server $component
}

batch_deploy

rm bin/oapService.sh.tmp
