# Inventory

- [Inventory](#inventory)
  - [Machines](#machines)
  - [OPS](#ops)
    - [DNS](#dns)
      - [bind9](#bind9)
    - [scm](#scm)
      - [gitlab](#gitlab)
    - [repo-manager](#repo-manager)
      - [nexus](#nexus)
    - [cd](#cd)
      - [jenkins](#jenkins)
    - [Web Server](#web-server)
      - [Tomcat](#tomcat)
    - [docker-registry](#docker-registry)
    - [docker-registry-frontend](#docker-registry-frontend)
    - [Kubernetes](#kubernetes)
      - [master](#master)
      - [worker](#worker)
      - [kubectl proxy](#kubectl-proxy)
    - [istio](#istio)
      - [kiali](#kiali)
  - [Middleware](#middleware)
    - [Distribution](#distribution)
      - [Zookeeper](#zookeeper)
        - [zk](#zk)
        - [zkui](#zkui)
      - [ETCD](#etcd)
        - [ETCD Server](#etcd-server)
        - [ETCD Keeper](#etcd-keeper)
      - [Tinyid](#tinyid)
      - [Leaf](#leaf)
    - [MQ](#mq)
      - [Kafka](#kafka)
        - [Kafka Server](#kafka-server)
        - [Kafka Manager](#kafka-manager)
        - [Kafka Eagle](#kafka-eagle)
        - [Kafka Exporter](#kafka-exporter)
        - [Kafka Jmx Exporter](#kafka-jmx-exporter)
      - [RocketMQ](#rocketmq)
        - [RocketMQ Name Server](#rocketmq-name-server)
        - [RocketMQ Broker](#rocketmq-broker)
        - [RocketMQ Console](#rocketmq-console)
      - [RabbitMQ](#rabbitmq)
        - [RabbitMQ Server](#rabbitmq-server)
    - [Metric](#metric)
      - [Promethues](#promethues)
      - [Alert Manager](#alert-manager)
      - [Grafana](#grafana)
      - [Thanos](#thanos)
      - [Push Gateway](#push-gateway)
      - [node exporter](#node-exporter)
      - [mysqld exporter](#mysqld-exporter)
    - [Trace](#trace)
      - [skywalking](#skywalking)
        - [receiver](#receiver)
        - [aggregator](#aggregator)
        - [webapp](#webapp)
    - [ELK](#elk)
      - [ElasticSearch](#elasticsearch)
      - [FileBeat](#filebeat)
      - [Kibana](#kibana)
    - [CAT](#cat)
    - [Dubbo](#dubbo)
      - [dubbo admin](#dubbo-admin)
      - [sentinel](#sentinel)
    - [Apollo](#apollo)
      - [portal](#portal)
      - [config-service](#config-service)
      - [admin-service](#admin-service)
    - [Gateway](#gateway)
      - [Nginx](#nginx)
      - [OpenResty](#openresty)
      - [apisix](#apisix)
        - [apisix server](#apisix-server)
        - [apisix dashboard](#apisix-dashboard)
      - [Kong](#kong)
        - [Kong Server](#kong-server)
        - [Konga](#konga)
      - [soul](#soul)
    - [Job](#job)
      - [xxl-job](#xxl-job)
        - [xxl-job-admin](#xxl-job-admin)
        - [xxl-job-executor](#xxl-job-executor)
      - [elasticjob](#elasticjob)
        - [elasticjob-lite-ui](#elasticjob-lite-ui)
        - [elasticjob-executor](#elasticjob-executor)
    - [SF](#sf)
      - [Eureka](#eureka)
        - [Netflix Eureka](#netflix-eureka)
        - [Spring Cloud Eureka](#spring-cloud-eureka)
      - [Nacos](#nacos)
      - [Consul](#consul)
      - [Artemis](#artemis)
      - [Hystrix](#hystrix)
        - [Hystrix Dashboard](#hystrix-dashboard)
        - [Turbine](#turbine)
  - [Storage](#storage)
    - [MySql](#mysql)
      - [MySql Server](#mysql-server)
      - [MySql Workbench](#mysql-workbench)
    - [PostgreSQL](#postgresql)
      - [PostgreSQL Server](#postgresql-server)
      - [PostgreSQL Admin](#postgresql-admin)
    - [ShardingSphere](#shardingsphere)
      - [ShardingSphere-Proxy](#shardingsphere-proxy)
      - [ShardingSphere-UI](#shardingsphere-ui)
    - [Hadoop](#hadoop)
    - [Redis](#redis)
      - [Redis Server](#redis-server)
      - [Redis Cluster Proxy](#redis-cluster-proxy)
      - [Codis](#codis)
        - [Codis Dashboard](#codis-dashboard)
        - [Codis Proxy](#codis-proxy)
        - [Codis Server](#codis-server)
        - [Codis FE](#codis-fe)
    - [mongodb](#mongodb)
      - [mongodb server](#mongodb-server)
    - [tidb](#tidb)
      - [tidb tiup](#tidb-tiup)
  - [App](#app)
    - [eladmin](#eladmin)
      - [eladmin-server](#eladmin-server)
      - [eladmin-web](#eladmin-web)

## Machines

- 192.168.56.11, 10.0.2.11, 8C 4G
- 192.168.56.12, 10.0.2.12, 8C 4G
- 192.168.56.13, 10.0.2.13, 8C 4G

## OPS

### DNS

#### bind9

- 192.168.56.11
- 192.168.56.12
- 192.168.56.13

port: 53

### scm

#### gitlab

- 192.168.56.11

port: 80, 8080等多个端口

[gitlab](https://gitlab.mydotey.com)

### repo-manager

#### nexus

- 192.168.56.11

[nexus](https://192.168.56.11:8081)

### cd

#### jenkins

- 192.168.56.11

[jenkins](https://192.168.56.11:18080)

### Web Server

#### Tomcat

- 192.168.56.11

port: 8080

### docker-registry

[registry](http://192.168.56.11:5000/v2)

### docker-registry-frontend

[registry-frontend](http://192.168.56.11:5080)

### Kubernetes

#### master

- 192.168.56.11
- 192.168.56.12
- 192.168.56.13

port: 6443
vip: 10.0.2.100:16443

#### worker

#### kubectl proxy

need ssh port forwarding to localhost: (have to log in with url localhost:8001)

```sh
ssh -L localhost:8001:localhost:8001 -NT koqizhao@192.168.56.11 &
```

[kubectl-proxy](http://localhost:8001/)

[kube-dashboard](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)

### istio

#### kiali

```sh
ssh -L localhost:20001:localhost:20001 -NT koqizhao@192.168.56.11 &
```

[kiali](http://localhost:20001)

## Middleware

### Distribution

#### Zookeeper

##### zk

- 192.168.56.11
- 192.168.56.12
- 192.168.56.13

port: 2181, 2888, 3888, 21811, 21812

##### zkui

- 192.168.56.11

[zkui](http://192.168.56.11:2190)

#### ETCD

##### ETCD Server

- 192.168.56.11
- 192.168.56.12
- 192.168.56.13

port: 2379, 2380

##### ETCD Keeper

- 192.168.56.11

[etcdkeeper](http://192.168.56.11:12380/etcdkeeper)

#### Tinyid

- 192.168.56.11

[nextid](http://192.168.56.11:9999/tinyid/id/nextId?bizType=test&token=0f673adf80504e2eaa552f5d791b644c)

#### Leaf

- 192.168.56.11
- 192.168.56.12

[segment](http://192.168.56.11:8081/api/segment/get/leaf-segment-test)

[snowflake](http://192.168.56.11:8081/api/snowflake/get/test)

port: 8081, 8082

### MQ

#### Kafka

##### Kafka Server

- 192.168.56.11
- 192.168.56.12
- 192.168.56.13

##### Kafka Manager

- 192.168.56.11

[kafka-manager](http://192.168.56.11:9000/)

##### Kafka Eagle

- 192.168.56.11

[kafka-eagle](http://192.168.56.11:8048/)

##### Kafka Exporter

- 192.168.56.11

port: 9308

##### Kafka Jmx Exporter

- 192.168.56.11
- 192.168.56.12
- 192.168.56.13

port: 5556

#### RocketMQ

##### RocketMQ Name Server

- 192.168.56.11
- 192.168.56.12

port: 9876

##### RocketMQ Broker

- 192.168.56.11
- 192.168.56.12

port: 10911, 10912, 11911, 11912

##### RocketMQ Console

- 192.168.56.11

[RocketMQ Console](http://192.168.56.11:8080)

#### RabbitMQ

##### RabbitMQ Server

- 192.168.56.11

[management ui](http://192.168.56.11:15672/)

port: 25672, 5672, 15672

### Metric

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

### Trace

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

### CAT

- 192.168.56.11
- 192.168.56.12

port: 8080, 8005, 2280

[cat](http://192.168.56.11:8080)

### Dubbo

#### dubbo admin

- 192.168.56.11

[dubbo-admin](http://192.168.56.11:20881)

#### sentinel

- 192.168.56.11

[sentinel-dashboard](http://192.168.56.11:8085)
[sentinel-transport](http://192.168.56.11:8719)

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

### Gateway

#### Nginx

192.168.56.11

port: 80

#### OpenResty

192.168.56.11

port: 80

#### apisix

##### apisix server

192.168.56.11

port: 9080, 9443

##### apisix dashboard

192.168.56.11

port: 8080

[apisix-dashboard](http://192.168.56.11:8080)

#### Kong

##### Kong Server

- 192.168.56.11

port: 8000, 8443, 8001, 8444

##### Konga

- 192.168.56.11

[konga](http://192.168.56.11:1337/)

#### soul

- 192.168.56.11

[soul-admin](http://192.168.56.11:9095)
[soul-gateway](http://192.168.56.11:9195)

### Job

#### xxl-job

##### xxl-job-admin

- 192.168.56.11

[xxl-job-admin](http://192.168.56.11:8080/xxl-job-admin)

##### xxl-job-executor

- 192.168.56.11

port: 8081, 9999

#### elasticjob

##### elasticjob-lite-ui

- 192.168.56.11

[lite-ui](http://192.168.56.11:8899)

##### elasticjob-executor

- 192.168.56.11

### SF

#### Eureka

##### Netflix Eureka

- 192.168.56.11

[Eureka](http://192.168.56.11:8080/eureka)

##### Spring Cloud Eureka

- 192.168.56.11

[Eureka](http://192.168.56.11:8080)

#### Nacos

- 192.168.56.11
- 192.168.56.12
- 192.168.56.13

[Nacos Console](http://192.168.56.11:8848/nacos/index.html)
user/pass: nacos/nacos

port: 8848, 9848, 9849, 7848, 59081

#### Consul

- 192.168.56.11
- 192.168.56.12
- 192.168.56.13

port: 8300, 8301, 8302, 8500, 8600

[ui](http://192.168.56.11:8500)

#### Artemis

- 192.168.56.11
- 192.168.56.12
- 192.168.56.13

[Swagger](http://192.168.56.11:8080/swagger-ui/)

[Status](http://192.168.56.11:8080/artemis/api/status/cluster.json)

#### Hystrix

##### Hystrix Dashboard

- 192.168.56.11

port: 8080

[hystrix-dashboard](http://192.168.56.11:8080/hystrix-dashboard)

##### Turbine

- 192.168.56.11

port: 18080

[turbine](http://192.168.56.11:18080/turbine/turbine.stream)

## Storage

### MySql

#### MySql Server

- 192.168.56.11, master
- 192.168.56.12, slave

port: 3306

#### MySql Workbench

- 192.168.56.1

### PostgreSQL

#### PostgreSQL Server

- 192.168.56.11

port: 5432

#### PostgreSQL Admin

- 192.168.56.1

[pgadmin](http://localhost:5480/pgadmin4)

### ShardingSphere

#### ShardingSphere-Proxy

- 192.168.56.11

port: 3307

#### ShardingSphere-UI

- 192.168.56.11

[ui](http://192.168.56.11:8088)

### Hadoop

- 192.168.56.11, name node
- 192.168.56.12
- 192.168.56.13

port: 9000, 9870, 9864

[name-node](http://192.168.56.11:9870/)

### Redis

#### Redis Server

- 192.168.56.11
- 192.168.56.12
- 192.168.56.13

port: 6379/16379

#### Redis Cluster Proxy

- 192.168.56.11

port: 7777

#### Codis

##### Codis Dashboard

- 192.168.56.11

port: 18080

##### Codis Proxy

- 192.168.56.11

port: 11080, 19090

##### Codis Server

- 192.168.56.11

port: 6379

##### Codis FE

- 192.168.56.11

port: 8080

### mongodb

#### mongodb server

- 192.168.56.11

port: 27017

### tidb

#### tidb tiup

- 192.168.56.11

[dashboard](http://192.168.11:2379/dashboard)

[prometheus](http://192.168.56.11:9090)

[grafana](http://192.168.56.11:3000)

pd/etcd: 2379, 2380, 33759, 43983

tikv: 20160, 20180

tidb: 4000, 10080

默认用户：root，无密码

## App

### eladmin

#### eladmin-server

- 192.168.56.11

port: 8000

[eladmin](http://192.168.56.11:8000/swagger-ui.html)

#### eladmin-web

- 192.168.56.11

port: 8013

[eladmin-web](http://192.168.56.11:8013/)
