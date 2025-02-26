#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

kubernetes_packages=(kubeadm kubectl kubelet)

clean_cluster_basic()
{
    master_server=${master_servers[0]}

    for s in ${worker_servers[@]}
    do
        echo -e "clean k8s worker node: $s\n"

        node_name=`ssh $s "hostname"`

        server=$master_server
        execute_ops drain_node $node_name

        server=$s
        execute_ops reset_node

        server=$master_server
        execute_ops delete_node $node_name
    done

    echo -e "clean k8s master node: $master_server\n"
    server=$master_server
    execute_ops reset_node
}

clean_cluster_dist()
{
    master_server=${master_servers[0]}

    for s in ${worker_servers[@]}
    do
        echo -e "clean k8s worker node: $s\n"

        node_name=`ssh $s "hostname"`

        server=$master_server
        execute_ops drain_node $node_name

        server=$s
        execute_ops reset_node

        server=$master_server
        execute_ops delete_node $node_name
    done

    for s in ${master_servers[@]}
    do
        if [ $s == "$master_server" ]; then
            continue
        fi

        echo -e "clean k8s ha rest master node: $s\n"
        node_name=`ssh $s "hostname"`

        server=$master_server
        execute_ops drain_node $node_name

        server=$s
        execute_ops reset_node

        server=$master_server
        execute_ops delete_node $node_name
    done

    echo -e "clean k8s ha last master node: $master_server\n"
    server=$master_server
    execute_ops reset_node
}

clean_cluster_$scale

remote_clean()
{
    for i in ${kubernetes_packages[@]}
    do
        ssh $1 "echo '$PASSWORD' | sudo -S apt-mark unhold $i"
        ssh $1 "echo '$PASSWORD' | sudo -S apt purge -y $i"
    done
    ssh $1 "echo '$PASSWORD' | sudo -S apt purge -y debconf-utils"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt upgrade -y"
    ssh $1 "echo '$PASSWORD' | sudo -S apt autoremove -y --purge"

    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository -r -y \"deb $mirror_site $artifact main\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key del $apt_hash"
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key del $apt_hash2"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"

    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /var/lib/kubelet"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /var/lib/containerd"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /var/lib/cni"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /var/lib/calico"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /var/lib/etcd"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /etc/kubernetes"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /etc/kube-vip"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /etc/cni"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /opt/cni"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf /opt/local-path-provisioner"

    ssh $1 "echo '$PASSWORD' | sudo -S rm -f /etc/sysctl.d/k8s.conf"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -f /etc/modules-load.d/module-load-k8s.conf"
    ssh $1 "echo '$PASSWORD' | sudo -S sysctl --system"

    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"

    ssh $1 "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
}

batch_clean
