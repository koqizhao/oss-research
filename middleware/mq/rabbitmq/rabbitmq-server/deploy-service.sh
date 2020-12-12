#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

admin_user="rabbitmq-admin"
admin_password="xx123456XX"

cluster_nodes=""
i=0
for s in ${servers[@]}
do
    let i+=1
    server_name=`ssh $s "hostname"`
    if [ -z "$cluster_nodes" ]; then
        cluster_nodes="cluster_formation.classic_config.nodes.$i = rabbit@${server_name}"
    else
        cluster_nodes="${cluster_nodes}${char_nl}cluster_formation.classic_config.nodes.$i = rabbit@${server_name}"
    fi
done

remote_deploy()
{
    server=$1

    ssh $1 "mkdir -p $deploy_path/$component"
    ssh $1 "mkdir -p $deploy_path/data/$component"
    ssh $1 "mkdir -p $deploy_path/logs/$component"

    ssh $1 "curl -fsSL $gpg_site > gpg; echo '$PASSWORD' | sudo -S apt-key add gpg; rm gpg;"
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key fingerprint $gpg_pub"
    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository \"$apt_repo\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y $component"

    declare base_dir=`escape_slash $deploy_path/$component`
    declare data_dir=`escape_slash $deploy_path/data/$component`
    declare log_dir=`escape_slash $deploy_path/logs/$component`

    sed "s/LOG_DIR/$log_dir/g" rabbitmq.conf.$scale \
        | sed "s/CLUSTER_NODES/$cluster_nodes/g" \
        | sed "s/$char_nl/\\n/g" \
        > rabbitmq.conf.tmp
    scp rabbitmq.conf.tmp $server:$deploy_path/$component/rabbitmq.conf
    rm rabbitmq.conf.tmp

    sed "s/DATA_DIR/$data_dir/g" rabbitmq-env.conf \
        | sed "s/LOG_DIR/$log_dir/g" \
        > rabbitmq-env.conf.tmp
    scp rabbitmq-env.conf.tmp $server:$deploy_path/$component/rabbitmq-env.conf
    rm rabbitmq-env.conf.tmp

    ssh $1 "cd $deploy_path/$component; \
        echo '$PASSWORD' | sudo -S chown root:root rabbitmq.conf; \
        echo '$PASSWORD' | sudo -S chmod 644 rabbitmq.conf; \
        echo '$PASSWORD' | sudo -S mv rabbitmq.conf /etc/rabbitmq/; \
        echo '$PASSWORD' | sudo -S chown root:root rabbitmq-env.conf; \
        echo '$PASSWORD' | sudo -S chmod 644 rabbitmq-env.conf; \
        echo '$PASSWORD' | sudo -S mv rabbitmq-env.conf /etc/rabbitmq/; \
        echo '$PASSWORD' | sudo -S chown -R rabbitmq:rabbitmq $deploy_path/data/$component; \
        echo '$PASSWORD' | sudo -S chown -R rabbitmq:rabbitmq $deploy_path/logs/$component; \
        echo '$PASSWORD' | sudo -S systemctl stop rabbitmq-server; \
        echo '$PASSWORD' | sudo -S systemctl start rabbitmq-server; \
        echo '$PASSWORD' | sudo -S rabbitmq-plugins enable rabbitmq_management; \
        echo '$PASSWORD' | sudo -S rabbitmqctl add_user $admin_user $admin_password; \
        echo '$PASSWORD' | sudo -S rabbitmqctl set_user_tags $admin_user administrator; "
}

init_cluster()
{
    for s in ${servers[@]}
    do
        ssh $s "cd $deploy_path/$component; \
            echo '$PASSWORD' | sudo -S rabbitmqctl stop_app; \
            echo '$PASSWORD' | sudo -S rabbitmqctl force_reset; \
            echo '$PASSWORD' | sudo -S systemctl stop $component; "
    done

    ssh ${servers[0]} "cd $deploy_path/$component; \
        echo '$PASSWORD' | sudo -S cp /var/lib/rabbitmq/.erlang.cookie ~/; \
        echo '$PASSWORD' | sudo -S chmod a+r ~/.erlang.cookie; "
    scp ${servers[0]}:./.erlang.cookie ./
    ssh ${servers[0]} "cd $deploy_path/$component; \
        echo '$PASSWORD' | sudo -S rm -f ~/.erlang.cookie; "

    for s in ${servers[@]}
    do
        scp ./.erlang.cookie $s:./.erlang.cookie
        ssh $s "cd $deploy_path/$component; \
            echo '$PASSWORD' | sudo -S chown rabbitmq:rabbitmq ~/.erlang.cookie; \
            echo '$PASSWORD' | sudo -S chmod 400 ~/.erlang.cookie; \
            echo '$PASSWORD' | sudo -S mv ~/.erlang.cookie /var/lib/rabbitmq/; \
            echo '$PASSWORD' | sudo -S systemctl start $component; \
            echo '$PASSWORD' | sudo -S rabbitmqctl start_app; "
    done

    rm -f ./.erlang.cookie

    ssh ${servers[0]} "cd $deploy_path/$component; \
        echo '$PASSWORD' | sudo -S rabbitmqctl add_user $admin_user $admin_password; \
        echo '$PASSWORD' | sudo -S rabbitmqctl set_user_tags $admin_user administrator; "
}

batch_deploy

if [ $scale == "dist" ]; then
    init_cluster
fi
