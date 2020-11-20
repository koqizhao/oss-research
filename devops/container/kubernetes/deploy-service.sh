#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

#gpg_site=https://packages.cloud.google.com/apt/doc/apt-key.gpg
gpg_site=https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg

remote_deploy()
{
    ssh $1 "mkdir -p $deploy_path/$component"

    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y curl apt-transport-https"
    ssh $1 "curl -fsSL $gpg_site > gpg; echo '$PASSWORD' | sudo -S apt-key add gpg; rm gpg;"
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key fingerprint BA07F4FB"
    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository \"deb $mirror_site $artifact main\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y kubelet kubectl kubeadm"
    ssh $1 "echo '$PASSWORD' | sudo -S apt-mark hold kubelet kubectl kubeadm"
    ssh $1 "echo '$PASSWORD' | sudo -S apt upgrade -y"

    scp k8s.conf $1:$deploy_path/$component
    ssh $1 "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S chown root:root k8s.conf"
    ssh $1 "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S mv k8s.conf /etc/sysctl.d/"
    ssh $1 "echo '$PASSWORD' | sudo -S sysctl --system"

    scp init-iptables.sh $1:$deploy_path/$component
    ssh $1 "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S sh init-iptables.sh; rm init-iptables.sh"

    scp k8s-ops.sh $1:$deploy_path/$component

    #ssh $1 "echo '$PASSWORD' | sudo -S reboot"
}

batch_deploy

deploy_basic()
{
    master_server=${master_servers[0]}

    echo -e "set up k8s cluster, master node: $master_server\n"
    server=$master_server
    execute_ops init_cluster
    execute_ops install_network
    join_ip=`execute_ops get_internal_ip`
    echo "join ip: $join_ip"
    join_token=`execute_ops get_join_token`
    echo "join token: $join_token"
    join_hash=`execute_ops get_join_hash`
    echo "join hash: $join_hash"

    for s in ${worker_servers[@]}
    do
        echo -e "join worker node: $s\n"
        server=$s
        execute_ops join_cluster $join_ip "$join_token" "$join_hash"
    done
}

deploy_dist()
{
    echo "ok"
}

deploy_$scale
