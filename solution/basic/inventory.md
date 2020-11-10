# Inventory

- [Inventory](#inventory)
  - [Machines](#machines)
  - [Apps](#apps)
    - [Zookeeper](#zookeeper)
    - [Apollo](#apollo)
      - [portal](#portal)
      - [config-service](#config-service)
    - [kubernetes](#kubernetes)
      - [master](#master)
      - [node](#node)
    - [ELK](#elk)
      - [ElasticSearch](#elasticsearch)
      - [FileBeat](#filebeat)

## Machines

- 192.168.56.11, 10.0.2.11, 4C 4G
- 192.168.56.12, 10.0.2.12, 4C 4G
- 192.168.56.13, 10.0.2.13, 4C 2G
- 192.168.56.14, 10.0.2.14, 4C 1G
- 192.168.56.15, 10.0.2.15, 4C 1G

## Apps

### Zookeeper

- 192.168.56.11

port: 2181, 2888, 3888, 21811, 21812

### Apollo

#### portal

- 192.168.56.11

port: 38070

#### config-service

- 192.168.56.11

port: 38080

### kubernetes

#### master

- 192.168.56.11

[k8s-master](https://10.0.2.11:6443)

#### node

- 192.168.56.12

### ELK

#### ElasticSearch

- 192.168.56.11
- 192.168.56.12

[elasticsearch](http://192.168.56.11:9200/)

#### FileBeat

- 192.168.56.11
- 192.168.56.12
