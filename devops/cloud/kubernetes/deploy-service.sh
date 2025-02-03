#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

#gpg_site=https://packages.cloud.google.com/apt/doc/apt-key.gpg
gpg_site=https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg

kube_version=1.20.10-00

remote_deploy()
{
    ssh $1 "mkdir -p $deploy_path/$component"

    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y curl apt-transport-https"
    ssh $1 "curl -fsSL $gpg_site > gpg; echo '$PASSWORD' | sudo -S apt-key add gpg; rm gpg;"
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key fingerprint $apt_hash"
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key fingerprint $apt_hash2"
    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository \"deb $mirror_site $artifact main\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y debconf-utils"
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y kubelet=$kube_version kubectl=$kube_version kubeadm=$kube_version"
    ssh $1 "echo '$PASSWORD' | sudo -S apt-mark hold kubelet kubectl kubeadm"
    ssh $1 "echo '$PASSWORD' | sudo -S apt upgrade -y"

    scp module-load-k8s.conf $1:$deploy_path/$component
    ssh $1 "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S chown root:root module-load-k8s.conf"
    ssh $1 "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S mv module-load-k8s.conf /etc/modules-load.d/"
    ssh $1 "echo '$PASSWORD' | sudo -S modprobe br_netfilter"

    scp k8s.conf $1:$deploy_path/$component
    ssh $1 "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S chown root:root k8s.conf"
    ssh $1 "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S mv k8s.conf /etc/sysctl.d/"
    ssh $1 "echo '$PASSWORD' | sudo -S sysctl --system"

    scp init-iptables.sh $1:$deploy_path/$component
    ssh $1 "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S sh init-iptables.sh; rm init-iptables.sh"

    dp=`escape_slash $deploy_path/$component`
    sed "s/DEPLOY_PATH/$dp/g" k8s-ops.sh \
        > k8s-ops.sh.tmp
    chmod a+x k8s-ops.sh.tmp
    scp k8s-ops.sh.tmp $1:$deploy_path/$component/k8s-ops.sh
    rm k8s-ops.sh.tmp
}

batch_deploy

deploy_cluster_basic()
{
    master_server=${master_servers[0]}

    echo -e "set up k8s cluster, master node: $master_server\n"
    server=$master_server
    failed=`execute_ops init_cluster | grep "couldn't initialize a Kubernetes cluster"`
    if [ -n "$failed" ]; then
        execute_ops reset_node
        failed=`execute_ops init_cluster | grep "couldn't initialize a Kubernetes cluster"`
        if [ -n "$failed" ]; then
            echo "init cluster failed"
            return 1
        fi
    fi

    ssh $master_server "mkdir -p $deploy_path/$component/calico"
    scp calico/* $master_server:$deploy_path/$component/calico
    execute_ops install_network

    enable_api_proxy $master_server

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
        execute_ops join_cluster $join_ip $join_token $join_hash
    done

    ssh $master_server "mkdir -p $deploy_path/$component/kube-dashboard"
    scp kube-dashboard/* $master_server:$deploy_path/$component/kube-dashboard
    server=$master_server
    execute_ops install_dashboard
}

deploy_cluster_dist()
{
    for s in ${master_servers[@]}
    do
        scp kube-vip/config.yaml.$s $s:$deploy_path/$component/config.yaml
        ssh $s "echo '$PASSWORD' | sudo -S mkdir -p /etc/kube-vip"
        ssh $s "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S mv config.yaml /etc/kube-vip"
    done

    master_server=${master_servers[0]}
    server=$master_server
    execute_ops prepare_ha_cluster_vip
    execute_ops init_ha_cluster

    ssh $master_server "mkdir -p $deploy_path/$component/calico"
    scp calico/* $master_server:$deploy_path/$component/calico
    execute_ops install_network

    enable_api_proxy $master_server

    master_cert_key=`execute_ops get_ha_master_cert_key`
    echo "master_cert_key: $master_cert_key"
    join_token=`execute_ops get_join_token`
    echo "join token: $join_token"
    join_hash=`execute_ops get_join_hash`
    echo "join hash: $join_hash"

    for s in ${master_servers[@]}
    do
        if [ $s == "$master_server" ]; then
            continue
        fi

        echo -e "join rest master node: $s\n"
        server=$s
        execute_ops join_ha_cluster_as_master $join_token $join_hash $master_cert_key
        execute_ops prepare_ha_cluster_vip
        enable_api_proxy $server
    done

    for s in ${worker_servers[@]}
    do
        echo -e "join worker node: $s\n"
        server=$s
        execute_ops join_ha_cluster_as_worker $join_token $join_hash
    done

    ssh $master_server "mkdir -p $deploy_path/$component/kube-dashboard"
    scp kube-dashboard/* $master_server:$deploy_path/$component/kube-dashboard
    server=$master_server
    execute_ops install_dashboard
}

deploy_cluster_$scale

# create pods on master nodes
ssh ${master_servers[0]} "kubectl taint nodes --all node-role.kubernetes.io/master-"

# apply local-path-storage
scp local-path-provisioner/local-path-storage.yaml ${master_servers[0]}:$deploy_path/$component
ssh ${master_servers[0]} "kubectl apply -f $deploy_path/$component/local-path-storage.yaml"
ssh ${master_servers[0]} "kubectl patch storageclass local-path -p '{\"metadata\": {\"annotations\":{\"storageclass.kubernetes.io/is-default-class\":\"true\"}}}'"
