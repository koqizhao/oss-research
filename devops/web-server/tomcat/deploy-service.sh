#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

tomcat_version=${tomcat_version:=8}
tomcat_server_port=${tomcat_server_port:=8005}
tomcat_service_port=${tomcat_service_port:=8080}

case $tomcat_version in
    7)
        deploy_version=7.0.107

        ;;
    8)
        deploy_version=8.5.60

        ;;
    *)
        tomcat_version=9
        deploy_version=9.0.40

        ;;
esac

deploy_file_name=apache-tomcat-$deploy_version
deploy_file=$deploy_file_name.tar.gz
conf_d="conf.$tomcat_version"

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path/data/$component"
    ssh $server "mkdir -p $deploy_path/logs/$component"
    ssh $server "touch $deploy_path/logs/$component/$component.log"

    base_dir=`escape_slash $deploy_path/$component`
    data_dir=`escape_slash $deploy_path/data/$component`
    log_dir=`escape_slash $deploy_path/logs/$component`

    scp ~/Software/tomcat/$deploy_file $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf $deploy_file; \
        mv $deploy_file_name $component; rm $deploy_file; \
        mv $component/webapps/ROOT data/$component; "

    scp start.sh $server:$deploy_path/$component

    sed "s/LOG_DIR/$log_dir/g" $conf_d/logging.properties \
        > logging.properties.tmp
    scp logging.properties.tmp $server:$deploy_path/$component/conf/logging.properties
    rm logging.properties.tmp

    sed "s/SERVER_PORT/$tomcat_server_port/g" $conf_d/server.xml \
        | sed "s/SERVICE_PORT/$tomcat_service_port/g" \
        | sed "s/APP_BASE/$data_dir/g" \
        | sed "s/LOG_DIR/$log_dir/g" \
        > server.xml.tmp
    scp server.xml.tmp $server:$deploy_path/$component/conf/server.xml
    rm server.xml.tmp

    sed "s/BASE_DIR/$base_dir/g" $component.service \
        | sed "s/LOG_DIR/$log_dir/g" \
        > $component.service.tmp
    scp $component.service.tmp $server:$deploy_path/$component.service
    rm $component.service.tmp

    ssh $1 "echo '$PASSWORD' | sudo -S chown -R root:root $deploy_path/$component.service"
    ssh $1 "echo '$PASSWORD' | sudo -S mv $deploy_path/$component.service /etc/systemd/system"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl enable $component.service"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl start $component.service"
}

batch_deploy
