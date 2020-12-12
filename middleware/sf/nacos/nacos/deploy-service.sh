#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_version=2.0.0-ALPHA.1
deploy_file=nacos-server-$deploy_version.tar.gz

init_db()
{
    cat conf/init.sql > conf/init.sql.tmp
    cat conf/nacos-mysql.sql >> conf/init.sql.tmp
    mysql_db_exec conf/init.sql.tmp
    rm conf/init.sql.tmp
}

deploy_basic()
{
    scp conf/application.properties.$scale $server:$deploy_path/$component/conf/application.properties
}

deploy_dist()
{
    sed "s/MYSQL_DB_SERVER/$mysql_db_server/g" conf/application.properties.$scale \
        | sed "s/MYSQL_DB_USER/$mysql_db_user/g" \
        | sed "s/MYSQL_DB_PASSWORD/$mysql_db_password/g" \
        > conf/application.properties.tmp
    scp conf/application.properties.tmp $server:$deploy_path/$component/conf/application.properties
    rm conf/application.properties.tmp

    nodes=""
    for s in ${servers[@]}
    do
        if [ -z "$nodes" ]; then
            nodes="$s:8848"
        else
            nodes="${nodes}${char_nl}$s:8848"
        fi
    done
    sed "s/NODES/$nodes/g" conf/cluster.conf \
        | sed "s/$char_nl/\\n/g" \
        > conf/cluster.conf.tmp
    scp conf/cluster.conf.tmp $server:$deploy_path/$component/conf/cluster.conf
    rm conf/cluster.conf.tmp
}

remote_deploy()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S apt install -y openjdk-8-jdk"

    ssh $server "mkdir -p $deploy_path"

    scp ~/Software/nacos/$deploy_file $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf $deploy_file; rm $deploy_file; "

    scp bin/startup.sh $server:$deploy_path/$component/bin

    sed "s/SERVER_IP/$server/g" start.sh.$scale \
        > start.sh
    chmod a+x start.sh
    scp start.sh $server:$deploy_path/$component
    rm start.sh

    deploy_$scale
}

if [ $scale == "dist" ]; then
    init_db
fi

batch_deploy

batch_start
