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
      - [Kafka Exporter](#kafka-exporter)
      - [Jmx Exporter](#jmx-exporter)
    - [metric](#metric)
      - [Promethues](#promethues)
      - [Alert Manager](#alert-manager)
      - [Grafana](#grafana)
      - [Thanos](#thanos)
      - [Push Gateway](#push-gateway)
      - [node exporter](#node-exporter)
      - [mysqld exporter](#mysqld-exporter)
    - [ELK](#elk)
      - [ElasticSearch](#elasticsearch)
      - [FileBeat](#filebeat)
      - [Kibana](#kibana)
    - [HDFS](#hdfs)
    - [kubernetes](#kubernetes)
      - [docker registry](#docker-registry)
      - [master](#master)
      - [kubectl proxy](#kubectl-proxy)
      - [node](#node)
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

#### Kafka Exporter

- 192.168.56.11

#### Jmx Exporter

- 192.168.56.11
- 192.168.56.12
- 192.168.56.13

[jmx_exporter](http://192.168.56.11:9000/)

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

### HDFS

- 192.168.56.11, name node
- 192.168.56.12
- 192.168.56.13

### kubernetes

#### docker registry

- 192.168.56.11

[docker-registry](http://192.168.56.11:15000/)

#### master

- 192.168.56.11

[k8s-master](https://10.0.2.11:6443)

#### kubectl proxy

[kubectl-proxy](http://192.168.56.11:8001/)

#### node

- 192.168.56.12
- 192.168.56.13
- 192.168.56.14
- 192.168.56.15

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
