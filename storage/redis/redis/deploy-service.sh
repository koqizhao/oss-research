#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_version=redis-stable

build()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S apt update; \
        echo '$PASSWORD' | sudo -S apt install -y gcc make pkg-config tcl; "

    ssh $server "mkdir -p $deploy_path"

    scp ~/Software/redis/${deploy_version}.tar.gz $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf ${deploy_version}.tar.gz; \
        mv $deploy_version $component; rm ${deploy_version}.tar.gz"

    ssh $server "cd $deploy_path/$component; make;"
    ssh $server "cd $deploy_path/$component; mkdir bin; \
        mv src/redis-benchmark bin; \
        mv src/redis-check-aof bin; \
        mv src/redis-check-rdb bin; \
        mv src/redis-cli bin; \
        mv src/redis-sentinel bin; \
        mv src/redis-server bin; \
        make distclean; \
        cd $deploy_path; \
        tar cf $component.tar $component"

    rm -f $component.tar
    scp $server:$deploy_path/$component.tar ./

    ssh $server "rm -rf $deploy_path/$component"
    ssh $server "rm -f $deploy_path/$component.tar"

    ssh $server "echo '$PASSWORD' | sudo -S apt purge -y gcc make pkg-config tcl; \
        echo '$PASSWORD' | sudo -S apt update; \
        echo '$PASSWORD' | sudo -S apt autoremove -y --purge"
}

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path"
    ssh $server "mkdir -p $deploy_path/data/$component"
    ssh $server "mkdir -p $deploy_path/logs/$component"
    ssh $server "touch $deploy_path/logs/$component/$component.log"

    scp $component.tar $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf $component.tar; rm $component.tar;"

    data_dir=`escape_slash $deploy_path/data/$component`
    log_dir=`escape_slash $deploy_path/logs/$component`
    base_dir=`escape_slash $deploy_path/$component`

    sed "s/SERVER_IP/$server/g" redis.conf.$scale \
        | sed "s/DATA_DIR/$data_dir/g" \
        | sed "s/LOG_DIR/$log_dir/g" \
        > redis.conf.tmp
    scp redis.conf.tmp $server:$deploy_path/$component/redis.conf
    rm redis.conf.tmp

    sed "s/BASE_DIR/$base_dir/g" $component.service \
        | sed "s/LOG_DIR/$log_dir/g" \
        > $component.service.tmp
    scp $component.service.tmp $server:$deploy_path/$component.service
    rm $component.service.tmp

    ssh $server "echo '$PASSWORD' | sudo -S mv $deploy_path/$component.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S chown root:root /etc/systemd/system/$component.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start $component.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable $component.service"
}

create_cluster()
{
    nodes=""
    for i in ${servers[@]}
    do
        if [ -z "$nodes" ]; then
            nodes="$i:6379"
        else
            nodes="$nodes $i:6379"
        fi
    done

    ssh ${servers[0]} "cd $deploy_path/$component; \
        echo yes | bin/redis-cli --cluster create $nodes --cluster-replicas $cluster_replicas"
}

build ${servers[0]}

batch_deploy

if [ $scale == "dist" ]; then
    create_cluster
fi
