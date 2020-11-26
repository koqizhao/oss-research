# Inventory

- [Inventory](#inventory)
  - [Machines](#machines)
  - [Apps](#apps)
    - [distribution](#distribution)
      - [Zookeeper](#zookeeper)
        - [zk](#zk)
        - [zkui](#zkui)
      - [Consul](#consul)
    - [Kafka](#kafka)
      - [Kafka Server](#kafka-server)
      - [Kafka Manager](#kafka-manager)
      - [Kafka Eagle](#kafka-eagle)
      - [Kafka Exporter](#kafka-exporter)
      - [Kafka Jmx Exporter](#kafka-jmx-exporter)
    - [metric](#metric)
      - [Promethues](#promethues)
      - [Alert Manager](#alert-manager)
      - [Grafana](#grafana)
      - [Thanos](#thanos)
      - [Push Gateway](#push-gateway)
      - [node exporter](#node-exporter)
      - [mysqld exporter](#mysqld-exporter)
    - [trace](#trace)
      - [skywalking](#skywalking)
        - [receiver](#receiver)
        - [aggregator](#aggregator)
        - [webapp](#webapp)
    - [ELK](#elk)
      - [ElasticSearch](#elasticsearch)
      - [FileBeat](#filebeat)
      - [Kibana](#kibana)
    - [Hadoop](#hadoop)
    - [kubernetes](#kubernetes)
      - [master](#master)
      - [worker](#worker)
      - [kubectl proxy](#kubectl-proxy)
    - [dubbo](#dubbo)
      - [dubbo admin](#dubbo-admin)
      - [nacos](#nacos)
      - [soul](#soul)
      - [sentinel](#sentinel)
    - [MySql](#mysql)
      - [MySql Server](#mysql-server)
      - [MySql Workbench](#mysql-workbench)
    - [Apollo](#apollo)
      - [portal](#portal)
      - [config-service](#config-service)
      - [admin-service](#admin-service)
    - [DNS](#dns)
      - [bind9](#bind9)
    - [gitlab](#gitlab)
    - [nexus](#nexus)

## Machines

- 192.168.56.11, 10.0.2.11, 4C 8G
- 192.168.56.12, 10.0.2.12, 4C 3G
- 192.168.56.13, 10.0.2.13, 4C 1G
- 192.168.56.14, 10.0.2.14, 4C 1G
- 192.168.56.15, 10.0.2.15, 4C 1G

## Apps

### distribution

#### Zookeeper

##### zk

- 192.168.56.11
- 192.168.56.12
- 192.168.56.13

port: 2181, 2888, 3888, 21811, 21812

##### zkui

- 192.168.56.11

[zkui](http://192.168.56.11:2190)

#### Consul

- 192.168.56.11
- 192.168.56.12
- 192.168.56.13

port: 8300, 8301, 8302, 8500, 8600

[ui](http://192.168.56.11:8500)

### Kafka

#### Kafka Server

- 192.168.56.11
- 192.168.56.12
- 192.168.56.13

#### Kafka Manager

- 192.168.56.11

[kafka-manager](http://192.168.56.11:9000/)

#### Kafka Eagle

- 192.168.56.11

[kafka-eagle](http://192.168.56.11:8048/)

#### Kafka Exporter

- 192.168.56.11

port: 9308

#### Kafka Jmx Exporter

- 192.168.56.11
- 192.168.56.12
- 192.168.56.13

port: 5556

### metric

#### Promethues

- 192.168.56.11

[prometheus](http://192.168.56.11:9090/graph)

#### Alert Manager

- 192.168.56.11

port: 9093, 9094

[AlertManager](http://192.168.56.11:9093)

#### Grafana

- 192.168.56.11

[grafana](http://192.168.56.11:3000)

#### Thanos

- 192.168.56.11

port

- sidecar: 19090, 19191
- query: 19192

[query](http://192.168.56.11:19192)

#### Push Gateway

- 192.168.56.11
- 192.168.56.12

port: 9091

#### node exporter

- 192.168.56.11
- 192.168.56.12

port: 19100

#### mysqld exporter

- 192.168.56.11

port: 9104

### trace

#### skywalking

##### receiver

- 192.168.56.11
- 192.168.56.12

port: 11800, 12800

##### aggregator

- 192.168.56.11
- 192.168.56.12

port: 11801, 12801

##### webapp

- 192.168.56.11

[console](http://192.168.56.11:13800)

### ELK

#### ElasticSearch

- 192.168.56.11
- 192.168.56.12

[elasticsearch](http://192.168.56.11:9200/)

#### FileBeat

- 192.168.56.11
- 192.168.56.12

#### Kibana

- 192.168.56.11

[kibana](http://192.168.56.11:5601/)

### Hadoop

- 192.168.56.11, name node
- 192.168.56.12
- 192.168.56.13

port: 9000, 9870, 9864

[name-node](http://192.168.56.11:9870/)

### kubernetes

#### master

- 192.168.56.13
- 192.168.56.14
- 192.168.56.15

port: 6443
vip: 10.0.2.100:16443

#### worker

- 192.168.56.11
- 192.168.56.12

#### kubectl proxy

[kubectl-proxy](http://192.168.56.13:8001/)
[kube-dashboard](http://192.168.56.13:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)

### dubbo

#### dubbo admin

- 192.168.56.11

[dubbo-admin](http://192.168.56.11:20881)

#### nacos

- 192.168.56.11

[nacos console](http://192.168.56.11:8848/nacos/index.html)

#### soul

- 192.168.56.11

[soul-admin](http://192.168.56.11:9095)
[soul-gateway](http://192.168.56.11:9195)

#### sentinel

- 192.168.56.11

[sentinel-dashboard](http://192.168.56.11:8085)
[sentinel-transport](http://192.168.56.11:8719)

### MySql

#### MySql Server

- 192.168.56.11:3306

#### MySql Workbench

- 192.168.56.1

### Apollo

#### portal

- 192.168.56.11

port: 38070

#### config-service

- 192.168.56.11
- 192.168.56.12

port: 38080

#### admin-service

- 192.168.56.11
- 192.168.56.12

port: 38090

### DNS

#### bind9

- 192.168.56.11
- 192.168.56.12
- 192.168.56.13
- 192.168.56.14

port: 53

### gitlab

- 192.168.56.11

port: 80, 8080等多个端口

[gitlab](https://gitlab.mydotey.com)

### nexus

- 192.168.56.11

[nexus](https://192.168.56.11:8081)
