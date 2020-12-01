#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file_name=etcd-v3.4.14-linux-amd64
deploy_file=$deploy_file_name.tar.gz

generate_urls()
{
    urls=""
    for s in $@
    do
        if [ -z "$urls" ]; then
            urls="http://$s:$port"
        else
            urls="$urls,http://$s:$port"
        fi
    done

    echo $urls
}

base_dir=`escape_slash $deploy_path/$component`
data_dir=`escape_slash $deploy_path/data/$component`
log_dir=`escape_slash $deploy_path/logs/$component`

port=2380
port=2379

initial_cluster=""
for s in ${servers[@]}
do
    if [ -z "$initial_cluster" ]; then
        initial_cluster="`ssh $s 'hostname'`=http://$s:2380"
    else
        initial_cluster="$initial_cluster,`ssh $s 'hostname'`=http://$s:2380"
    fi
done
initial_cluster=`escape_slash "$initial_cluster"`

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path/data/$component; \
        mkdir -p $deploy_path/logs/$component; \
        touch $deploy_path/logs/$component/$component.log; \
        chmod a+w $deploy_path/logs/$component/$component.log"

    scp ~/Software/etcd/$deploy_file $server:$deploy_path
    ssh $server "cd $deploy_path; \
        tar xf $deploy_file; mv $deploy_file_name $component; rm $deploy_file; \
        echo '$PASSWORD' | sudo -S mkdir -p /usr/local/bin; \
        echo '$PASSWORD' | sudo -S ln -s $deploy_path/$component/etcd /usr/local/bin/etcd; \
        echo '$PASSWORD' | sudo -S ln -s $deploy_path/$component/etcdctl /usr/local/bin/etcdctl; "

    port=2380
    peer_urls=`generate_urls $server`
    peer_urls=`escape_slash "$peer_urls"`
    i_ad_peer_urls=`generate_urls $server`
    i_ad_peer_urls=`escape_slash "$i_ad_peer_urls"`
    port=2379
    client_urls=`generate_urls $server`
    client_urls=`escape_slash "$client_urls"`
    ad_client_urls=`generate_urls $server`
    ad_client_urls=`escape_slash "$ad_client_urls"`

    server_name=`ssh $1 "hostname"`
    sed "s/SERVER_NAME/$server_name/g" etcd.yml \
        | sed "s/DATA_DIR/$data_dir/g" \
        | sed "s/ALL_PEER_URLS/$peer_urls/g" \
        | sed "s/ALL_CLIENT_URLS/$client_urls/g" \
        | sed "s/I_AD_PEER_URLS/$i_ad_peer_urls/g" \
        | sed "s/AD_CLIENT_URLS/$ad_client_urls/g" \
        | sed "s/CLUSTER_NAME/$cluster_name/g" \
        | sed "s/INITIAL_CLUSTER/$initial_cluster/g" \
        > etcd.yml.tmp
    scp etcd.yml.tmp $server:$deploy_path/$component/etcd.yml
    rm etcd.yml.tmp

    scp start.sh $server:$deploy_path/$component

    sed "s/BASE_DIR/$base_dir/g" $component.service \
        | sed "s/LOG_DIR/$log_dir/g" \
        > $component.service.tmp 
    scp $component.service.tmp $server:$deploy_path/$component/$component.service
    rm $component.service.tmp

    ssh $server "echo '$PASSWORD' | sudo -S chown root:root $deploy_path/$component/$component.service"
    ssh $server "echo '$PASSWORD' | sudo -S mv $deploy_path/$component/$component.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start $component.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable $component.service"
}

batch_deploy
