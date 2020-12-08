#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

clean_tomcat()
{
    sed "s/servers/tomcat_servers/g" ../servers-$scale.sh \
        > servers-$scale.sh.tmp
    chmod a+x servers-$scale.sh.tmp
    cp servers-$scale.sh.tmp $tomcat_path/../servers-$scale.sh
    rm servers-$scale.sh.tmp

    dp=`escape_slash $deploy_path`
    sed "s/DEPLOY_PATH/$dp/g" tomcat/common.sh \
        > tomcat/common.sh.tmp
    cp tomcat/common.sh.tmp $tomcat_path/../common.sh
    rm tomcat/common.sh.tmp

    $tomcat_path/clean-service.sh $scale

    git checkout -- $tomcat_path/../
}

remote_clean()
{
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
}

clean_tomcat

batch_clean
