#!/bin/bash

# must comment /swap in /etc/fstab instead
#echo "vm.swappiness=0" >> /etc/sysctl.conf

apt install -y -q iptables arptables ebtables iptables-persistent

update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
update-alternatives --set arptables /usr/sbin/arptables-legacy
update-alternatives --set ebtables /usr/sbin/ebtables-legacy

iptables -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 6443 -j ACCEPT
iptables -A INPUT -p tcp --dport 2379:2380 -j ACCEPT
iptables -A INPUT -p tcp --dport 10250:10252 -j ACCEPT
iptables -A INPUT -p tcp --dport 30000:32767 -j ACCEPT

# for: kubectl expose NodePort service
iptables -P FORWARD ACCEPT

# for: kubectl proxy
iptables -A INPUT -p tcp --dport 8001 -j ACCEPT

# for other common use
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp --dport 9000 -j ACCEPT
iptables -A INPUT -p tcp --dport 9092 -j ACCEPT
iptables -A INPUT -p tcp --dport 9200 -j ACCEPT
iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
iptables -A INPUT -p tcp --dport 3000 -j ACCEPT
iptables -A INPUT -p tcp --dport 5601 -j ACCEPT

# for consul
iptables -A INPUT -p tcp --dport 8300:8302 -j ACCEPT
iptables -A INPUT -p tcp --dport 8500 -j ACCEPT

# for all ports
#iptables -A INPUT -p tcp --dport 0:65535 -j ACCEPT

netfilter-persistent save
