#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_deploy()
{
    server=$1

    ssh $server "mkdir -p $deploy_path/$component"
    ssh $server "mkdir -p $deploy_path/data/$component"
    ssh $server "mkdir -p $deploy_path/logs/$component"

    declare base_dir=`escape_slash $deploy_path/$component`
    declare data_dir=`escape_slash $deploy_path/data/$component`
    declare log_dir=`escape_slash $deploy_path/logs/$component`

    sed "s/BASE_DIR/$base_dir/g" start.sh.$scale \
        | sed "s/LOG_DIR/$log_dir/g" \
        | sed "s/HOST/$server/g" \
        > start.sh.tmp
    chmod a+x start.sh.tmp
    scp start.sh.tmp $server:$deploy_path/$component/start.sh
    rm start.sh.tmp

    ssh $server "cd $deploy_path/$component; \
        curl --proto '=https' --tlsv1.2 -sSf https://tiup-mirrors.pingcap.com/install.sh > install.sh;
        sh install.sh; "

    if [ $scale == "dist" ]; then
        sed "s/BASE_DIR/$base_dir/g" topo.yaml \
            | sed "s/DATA_DIR/$data_dir/g" \
            | sed "s/HOST/$server/g" \
            > topo.yaml.tmp
        scp topo.yaml.tmp $server:$deploy_path/$component/topo.yaml
        rm topo.yaml.tmp

        sed "s/BASE_DIR/$base_dir/g" init.sh \
            | sed "s/HOST/$server/g" \
            > init.sh.tmp
        chmod a+x init.sh.tmp
        scp init.sh.tmp $server:$deploy_path/$component/init.sh
        rm init.sh.tmp
        ssh $server "cd $deploy_path/$component; \
            echo '$PASSWORD' | sudo -S su -c ./init.sh"

        ssh $server "cd $deploy_path/$component; tiup cluster; "
        ssh $server "cd $deploy_path/$component; \
            tiup cluster deploy lab v4.0.8 topo.yaml --user root --identity_file id_rsa -y;"
    fi
}

batch_deploy

batch_start
