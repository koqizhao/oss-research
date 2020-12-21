#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

nginx_user=${nginx_user:=koqizhao}
nginx_server_port=${nginx_server_port:=80}
nginx_server_name=${nginx_server_name:=localhost}

deploy_version=1.19.6
deploy_file_name=nginx-$deploy_version
deploy_file=$deploy_file_name.tar.gz

dep_packages="gcc make libpcre3-dev libssl-dev libperl-dev zlib1g-dev"

build()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S apt update; \
        echo '$PASSWORD' | sudo -S apt install -y $dep_packages; "

    ssh $server "mkdir -p $deploy_path/$component"

    scp ~/Software/nginx/$deploy_file $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf $deploy_file; rm $deploy_file; "

    ssh $server "cd $deploy_path/$deploy_file_name; 
        ./configure \
        --user=koqizhao \
        --group=koqizhao \
        --prefix=$deploy_path/$component \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_realip_module \
        --with-threads; \
        make && make install; \
        cd $deploy_path; \
        tar cf $component.tar $component; \
        rm -rf $deploy_file_name;"

    rm -f $component.tar
    scp $server:$deploy_path/$component.tar ./

    ssh $server "rm -rf $deploy_path/$component; \
        rm -f $deploy_path/$component.tar; \
        echo '$PASSWORD' | sudo -S apt purge -y $dep_packages; \
        echo '$PASSWORD' | sudo -S apt update; \
        echo '$PASSWORD' | sudo -S apt autoremove -y --purge; "
}

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path"
    ssh $server "mkdir -p $deploy_path/data/$component"
    ssh $server "mkdir -p $deploy_path/logs/$component"
    ssh $server "touch $deploy_path/logs/$component/$component.log; \
        chmod a+w $deploy_path/logs/$component/$component.log; "

    scp $component.tar $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf $component.tar; rm $component.tar;"

    data_dir=`escape_slash $deploy_path/data/$component`
    log_dir=`escape_slash $deploy_path/logs/$component`
    base_dir=`escape_slash $deploy_path/$component`

    sed "s/SERVER_PORT/$nginx_server_port/g" conf/nginx.conf \
        | sed "s/SERVER_NAME/$nginx_server_name/g" \
        | sed "s/LOG_DIR/$log_dir/g" \
        | sed "s/USER/$nginx_user/g" \
        > conf/nginx.conf.tmp
    scp conf/nginx.conf.tmp $server:$deploy_path/$component/conf/nginx.conf
    rm conf/nginx.conf.tmp

    sed "s/BASE_DIR/$base_dir/g" nginx.service \
        | sed "s/LOG_DIR/$log_dir/g" \
        | sed "s/COMPONENT/$component/g" \
        > $component.service.tmp
    scp $component.service.tmp $server:$deploy_path/$component.service
    rm $component.service.tmp

    ssh $server "echo '$PASSWORD' | sudo -S mv $deploy_path/$component.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S chown root:root /etc/systemd/system/$component.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start $component.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable $component.service"
}

build ${servers[0]}

batch_deploy
