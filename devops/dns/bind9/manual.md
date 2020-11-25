# 普通机器网卡dns配置

## host

```sh
vi /etc/systemd/resolved.conf
```

```conf
[Resolve]
#DNS=
DNS=192.168.56.11
#FallbackDNS=
FallbackDNS=114.114.114.114
#Domains=
Domains=mydotey.com
#LLMNR=no
#MulticastDNS=no
#DNSSEC=no
#DNSOverTLS=no
#Cache=no-negative
#DNSStubListener=yes
#ReadEtcHosts=yes
```

```sh
systemctl restart systemd-resolved
systemd-resolve --status
```

## virtualbox vm

```sh
vi /etc/netplan/50-cloud-init.yaml
```

```yaml
network:
    ethernets:
        enp0s8:
            dhcp4: false
            addresses: [192.168.56.12/24]
            nameservers:
                search: [mydotey.com] #也可不配置
                addresses: [192.168.56.11] #可以配成主备2台，或cache、cache、master、slave 4台
    version: 2
```

```sh
netplan apply
```
