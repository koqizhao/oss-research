#!/bin/bash

manager=koqizhao
deploy_path=DEPLOY_PATH
pod_network_cidr=10.217.0.0/16
master_vip=10.0.2.100

get_ip()
{
    ip addr | grep "global $1" | awk '{ print $2 }' | awk -F '/' '{ print $1 }'
}

get_internal_ip()
{
    for i in `get_ip enp0s3`
    do
        if [ $i != $master_vip ]; then
            echo $i
        fi
    done
}

internal_ip=`get_internal_ip`
external_ip=`get_ip enp0s8`

export KUBECONFIG=/etc/kubernetes/admin.conf

pull_images()
{
    kubeadm config images pull \
        --image-repository registry.aliyuncs.com/google_containers
}

init_cluster()
{
    kubeadm init \
        --image-repository registry.aliyuncs.com/google_containers \
        --pod-network-cidr=$pod_network_cidr \
        --apiserver-advertise-address $internal_ip

    rm -rf /home/$manager/.kube
    mkdir -p /home/$manager/.kube
    cp -i /etc/kubernetes/admin.conf /home/$manager/.kube/config
    chown -R $manager:$manager /home/$manager/.kube
}

install_network()
{
    #kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
    #kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
    kubectl create -f $deploy_path/calico/tigera-operator.yaml
    kubectl create -f $deploy_path/calico/custom-resources.yaml
    #watch kubectl get pods -n calico-system
}

install_dashboard()
{
    #kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
    kubectl apply -f $deploy_path/kube-dashboard/recommended.yaml
    kubectl apply -f $deploy_path/kube-dashboard/dashboard-adminuser.yaml
    kubectl apply -f $deploy_path/kube-dashboard/dashboard-adminuser-role.yaml
}

get_join_token()
{
    kubeadm token list | grep token | awk '{ print $1 }'
}

get_join_hash()
{
    openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | \
        openssl rsa -pubin -outform der 2>/dev/null | \
        openssl dgst -sha256 -hex | sed 's/^.* //'
}

join_cluster()
{
    kubeadm join $1:6443 \
        --token $2 \
        --discovery-token-ca-cert-hash sha256:$3
}

clean_iptables()
{
    iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
}

clean_ipvs()
{
    ipvsadm -C
}

reset_node()
{
    kubeadm reset -f
    clean_iptables
    #clean_ipvs
    rm -rf /etc/cni/net.d
    rm -rf /home/$manager/.kube
}

drain_node()
{
    kubectl drain $1 --delete-local-data --force --ignore-daemonsets
}

delete_node()
{
    kubectl delete node $1
}

prepare_ha_cluster_vip()
{
    mkdir -p /etc/kubernetes/manifests
    docker run -i --rm plndr/kube-vip:0.1.1 /kube-vip sample manifest \
        | sed "s|plndr/kube-vip:'|plndr/kube-vip:0.1.1'|" \
        | tee /etc/kubernetes/manifests/kube-vip.yaml
}

init_ha_cluster()
{
    kubeadm init --control-plane-endpoint "$master_vip:16443" --upload-certs \
        --image-repository registry.aliyuncs.com/google_containers \
        --pod-network-cidr=$pod_network_cidr \
        --apiserver-advertise-address $internal_ip

    rm -rf /home/$manager/.kube
    mkdir -p /home/$manager/.kube
    cp -i /etc/kubernetes/admin.conf /home/$manager/.kube/config
    chown -R $manager:$manager /home/$manager/.kube
}

get_ha_master_cert_key()
{
    kubeadm init phase upload-certs --upload-certs | awk 'END { print $1 }'
}

join_ha_cluster_as_master()
{
    kubeadm join $master_vip:16443 \
        --token $1 \
        --discovery-token-ca-cert-hash sha256:$2 \
        --control-plane \
        --certificate-key $3

    rm -rf /home/$manager/.kube
    mkdir -p /home/$manager/.kube
    cp -i /etc/kubernetes/admin.conf /home/$manager/.kube/config
    chown -R $manager:$manager /home/$manager/.kube
}

join_ha_cluster_as_worker()
{
    kubeadm join $master_vip:16443 \
        --token $1 \
        --discovery-token-ca-cert-hash sha256:$2
}
