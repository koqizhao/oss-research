#!/bin/bash

manager=koqizhao
pod_network_cidr=10.217.0.0/16

get_ip()
{
    ip addr | grep "global $1" | awk '{ print $2 }' | awk -F '/' '{ print $1 }'
}

get_internal_ip()
{
    get_ip enp0s3
}

internal_ip=`get_internal_ip`
external_ip=`get_ip enp0s8`

export KUBECONFIG=/etc/kubernetes/admin.conf

pull_images()
{
    kubeadm config images pull \
        --image-repository registry.cn-hangzhou.aliyuncs.com/google_containers
}

init_cluster()
{
    kubeadm init \
        --image-repository registry.cn-hangzhou.aliyuncs.com/google_containers \
        --pod-network-cidr=$pod_network_cidr \
        --apiserver-advertise-address $internal_ip

    mkdir -p /home/$manager/.kube
    cp -i /etc/kubernetes/admin.conf /home/$manager/.kube/config
    chown -R $manager:$manager /home/$manager/.kube
}

install_network()
{
    kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
    kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
    #watch kubectl get pods -n calico-system
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
        --token "$2" \
        --discovery-token-ca-cert-hash "sha256:$3"
}

clean_iptables()
{
    iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
}

clean_ipvs()
{
    ipvsadm -C
}

reset_cluster()
{
    kubeadm reset -f
    clean_iptables
    #clean_ipvs
    rm -rf /etc/cni/net.d
    rm -rf /home/$manager/.kube
}

enable_api_proxy()
{
    kubectl proxy --address=$external_ip --port=8001 --accept-hosts=192.168.56.1
}

drain_node()
{
    kubectl drain $1 --delete-local-data --force --ignore-daemonsets
}

delete_node()
{
    kubectl delete node $1
}
