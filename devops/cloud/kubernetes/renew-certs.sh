#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

check_certs()
{
    for s in ${master_servers[@]}
    do
        ssh $s "echo '$PASSWORD' | sudo -S kubeadm certs check-expiration"
    done

    echo
}

backup_certs()
{
    for s in ${master_servers[@]}
    do
        ssh $s "echo '$PASSWORD' | sudo -S cp -rp /etc/kubernetes /etc/kubernetes.bak"
        ssh $s "echo '$PASSWORD' | sudo -S cp -rp /var/lib/etcd /var/lib/etcd.bak"
    done

    echo
}

renew_certs()
{
    for s in ${master_servers[@]}
    do
        ssh $s "echo '$PASSWORD' | sudo -S kubeadm certs renew all"
        ssh $s "echo '$PASSWORD' | sudo -S kubeadm certs check-expiration"
    done

    echo
}

enable_certs()
{
    for s in ${master_servers[@]}
    do
        ssh $s "echo '$PASSWORD' | sudo -S systemctl daemon-reload;"
        ssh $s "echo '$PASSWORD' | sudo -S systemctl restart docker;"
    done

    echo
}

update_kube_config()
{
    for s in ${master_servers[@]}
    do
        ssh $s "echo '$PASSWORD' | sudo -S cp -f /etc/kubernetes/admin.conf ~/.kube/config;"
    done

    echo
}

clean_backup()
{
    for s in ${master_servers[@]}
    do
        ssh $s "echo '$PASSWORD' | sudo -S rm -rf /etc/kubernetes.bak"
        ssh $s "echo '$PASSWORD' | sudo -S rm -rf /var/lib/etcd.bak"
    done

    echo
}

check_certs
backup_certs
renew_certs
enable_certs
update_kube_config
clean_backup

echo
