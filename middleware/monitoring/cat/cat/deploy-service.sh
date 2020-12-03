#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

project_path=~/Projects/dianping/cat

init_db()
{
    cp init.sql init.sql.tmp
    echo >> init.sql.tmp
    cat $project_path/script/CatApplication.sql >> init.sql.tmp
    mysql_db_exec init.sql.tmp
    rm init.sql.tmp
}

char_nl="NEW_LINE"
generate_conf()
{
    sed "s/DB_SERVER/$mysql_db_server/g" conf/datasources.xml \
        | sed "s/DB_USER/$mysql_db_user/g" \
        | sed "s/DB_PASSWORD/$mysql_db_password/g" \
        > conf/datasources.xml.tmp

    declare client_servers=""
    for s in ${servers[@]}
    do
        if [ -z "$client_servers" ]; then
            client_servers="        <server ip=\"$s\" port=\"2280\" http-port=\"$tomcat_service_port\"/>"
        else
            client_servers="$client_servers$char_nl        <server ip=\"$s\" port=\"2280\" http-port=\"$tomcat_service_port\"/>"
        fi
    done
    client_servers=`escape_slash "$client_servers"`
    sed "s/CLIENT_SERVERS/$client_servers/g" conf/client.xml \
        | sed "s/NEW_LINE/\\n/g" \
        | sed "s/192.168.56.1/10.0.2.1/g" \
        > conf/client.xml.tmp

    declare remote_servers=""
    for s in ${servers[@]}
    do
        if [ -z "$remote_servers" ]; then
            remote_servers="$s:$tomcat_service_port"
        else
            remote_servers="$remote_servers,$s:$tomcat_service_port"
        fi
    done
    sed "s/REMOTE_SERVERS/$remote_servers/g" manual/server-config.xml \
        | sed "s/SERVER_JOB/${servers[0]}/g" \
        | sed "s/192.168.56.1/10.0.2.1/g" \
        > manual/server-config.xml.tmp

    declare default_servers=""
    for s in ${servers[@]}
    do
        declare enabled=true
        if [ "$s" == "${servers[0]}" ] && [ ${#servers[@]} -gt 1 ]; then
            enabled=false
        fi
        if [ -z "$default_servers" ]; then
            default_servers="   <default-server id=\"$s\" weight=\"1.0\" port=\"2280\" enable=\"$enabled\"/>"
        else
            default_servers="$default_servers$char_nl   <default-server id=\"$s\" weight=\"1.0\" port=\"2280\" enable=\"$enabled\"/>"
        fi
    done
    default_servers=`escape_slash "$default_servers"`
    declare default_group_servers=""
    for s in ${servers[@]}
    do
        if [ "$s" == "${servers[0]}" ] && [ ${#servers[@]} -gt 1 ]; then
            continue
        elif [ -z "$default_group_servers" ]; then
            default_group_servers="      <group-server id=\"$s\"/>"
        else
            default_group_servers="$default_group_servers$char_nl      <group-server id=\"$s\"/>"
        fi
    done
    default_group_servers=`escape_slash "$default_group_servers"`
    declare domain_group_servers=""
    for s in ${servers[@]}
    do
        if [ "$s" == "${servers[0]}" ] && [ ${#servers[@]} -gt 1 ]; then
            continue
        elif [ -z "$domain_group_servers" ]; then
            domain_group_servers="         <server id=\"$s\" port=\"2280\" weight=\"1.0\"/>"
        else
            domain_group_servers="$domain_group_servers$char_nl         <server id=\"$s\" port=\"2280\" weight=\"1.0\"/>"
        fi
    done
    domain_group_servers=`escape_slash "$domain_group_servers"`
    sed "s/BACKUP_SERVER/${servers[0]}/g" manual/route-config.xml \
        | sed "s/DEFAULT_SERVERS/$default_servers/g" \
        | sed "s/DEFAULT_GROUP_SERVERS/$default_group_servers/g" \
        | sed "s/DOMAIN_GROUP_SERVERS/$domain_group_servers/g" \
        | sed "s/NEW_LINE/\\n/g" \
        | sed "s/192.168.56.1/10.0.2.1/g" \
        > manual/route-config.xml.tmp
}

clean_conf()
{
    rm conf/datasources.xml.tmp
    rm conf/client.xml.tmp
}

init_server()
{
    generate_conf

    for s in ${servers[@]}
    do
        ssh $s "echo '$PASSWORD' | sudo -S apt install -y openjdk-8-jdk"

        ssh $s "echo '$PASSWORD' | sudo -S mkdir -p /data/appdatas/cat"
        ssh $s "echo '$PASSWORD' | sudo -S mkdir -p /data/applogs/cat"
        ssh $s "echo '$PASSWORD' | sudo -S chown -R koqizhao:koqizhao /data"
        ssh $s "echo '$PASSWORD' | sudo -S chmod -R 777 /data"

        scp conf/datasources.xml.tmp $s:/data/appdatas/cat/datasources.xml
        scp conf/client.xml.tmp $s:/data/appdatas/cat/client.xml
    done

    clean_conf
}

deploy_tomcat()
{
    export tomcat_version=8

    cp tomcat/server.xml $tomcat_path/conf.$tomcat_version
    cp tomcat/start.sh $tomcat_path
    cp tomcat/setenv.sh $tomcat_path

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

    $tomcat_path/deploy-service.sh $scale

    git checkout -- $tomcat_path/../

    unset tomcat_version
}

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path/$component"

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop tomcat"
    sleep $stop_start_interval
    scp $project_path/cat-home/target/cat*.war $server:$deploy_path/data/tomcat/cat.war
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start tomcat"
}

init_db

init_server

deploy_tomcat

batch_deploy
