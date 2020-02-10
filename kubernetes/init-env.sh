#!/bin/bash

echo "vm.swappiness=0" >> /etc/sysctl.conf

apt install -y iptables arptables ebtables
update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
update-alternatives --set arptables /usr/sbin/arptables-legacy
update-alternatives --set ebtables /usr/sbin/ebtables-legacy

iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables --save
