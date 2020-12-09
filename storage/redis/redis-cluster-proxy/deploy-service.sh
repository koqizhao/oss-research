#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file_name=redis-cluster-proxy-1.0-beta2
deploy_file=$deploy_file_name.tar.gz

log_dir=`escape_slash $deploy_path/logs/$component`
base_dir=`escape_slash $deploy_path/$component`

build()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S apt update; \
        echo '$PASSWORD' | sudo -S apt install -y gcc make pkg-config tcl; "

    ssh $server "mkdir -p $deploy_path"

    scp ~/Software/redis/$deploy_file $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf $deploy_file; \
        mv $deploy_file_name build; rm $deploy_file; "

    ssh $server "cd $deploy_path/build; \
        make; mkdir bin; mv src/$component bin; \
        cd $deploy_path; mkdir $component; mv build/bin $component; \
        mv build/proxy.conf $component; tar cf $component.tar $component; \
        rm -rf build; "

    rm -f $component.tar
    scp $server:$deploy_path/$component.tar ./

    ssh $server "rm -rf $deploy_path/$component"
    ssh $server "rm -f $deploy_path/$component.tar"

    ssh $server "echo '$PASSWORD' | sudo -S apt purge -y gcc make pkg-config tcl; \
        echo '$PASSWORD' | sudo -S apt update; \
        echo '$PASSWORD' | sudo -S apt autoremove -y --purge"
}

generate_conf()
{
    declare cluster_address=""
    for s in ${redis_servers[@]}
    do
        if [ -z "$cluster_address" ]; then
            cluster_address="cluster $s:6379"
        else
            cluster_address="${cluster_address}${char_nl}cluster $s:6379"
        fi
    done
    sed "s/CLUSTER_ADDRESS/$cluster_address/g" proxy.conf \
        | sed "s/LOG_DIR/$log_dir/g" \
        | sed "s/$char_nl/\\n/g" \
        > proxy.conf.tmp
}

clean_conf()
{
    rm proxy.conf.tmp
}

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path"
    ssh $server "mkdir -p $deploy_path/logs/$component"
    ssh $server "touch $deploy_path/logs/$component/$component.log; \
        chmod a+w $deploy_path/logs/$component/$component.log; "

    scp $component.tar $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf $component.tar; rm $component.tar;"

    scp proxy.conf.tmp $server:$deploy_path/$component/proxy.conf

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

build ${servers[0]}

generate_conf

batch_deploy

clean_conf
