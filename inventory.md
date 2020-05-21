# Inventory

- [Inventory](#inventory)
  - [Machines](#machines)
  - [Apps](#apps)
    - [Zookeeper](#zookeeper)
    - [zkui](#zkui)
    - [Kafka](#kafka)
    - [Kafka Manager](#kafka-manager)
    - [Kafka Exporter](#kafka-exporter)
    - [Jmx Exporter](#jmx-exporter)
    - [Promethues](#promethues)
    - [Grafana](#grafana)
    - [ElasticSearch](#elasticsearch)
    - [FileBeat](#filebeat)
    - [Kibana](#kibana)
    - [HDFS](#hdfs)
    - [kubernetes](#kubernetes)
      - [docker registry](#docker-registry)
      - [master](#master)
      - [kubectl proxy](#kubectl-proxy)
      - [node](#node)
    - [dubbo admin](#dubbo-admin)

## Machines

- 192.168.56.11, 10.0.2.11
- 192.168.56.12, 10.0.2.12
- 192.168.56.13, 10.0.2.13
- 192.168.56.14, 10.0.2.14
- 192.168.56.15, 10.0.2.15

## Apps

### Zookeeper

- 192.168.56.11

### zkui

- 192.168.56.11

[zkui](http://192.168.56.11:9090)

### Kafka

- 192.168.56.11
- 192.168.56.12
- 192.168.56.13

### Kafka Manager

- 192.168.56.11

[kafka-manager](http://192.168.56.11:9000/)

### Kafka Exporter

- 192.168.56.11

### Jmx Exporter

- 192.168.56.11
- 192.168.56.12
- 192.168.56.13

[jmx_exporter](http://192.168.56.11:9000/)

### Promethues

- 192.168.56.14

[prometheus](http://192.168.56.14:9090/graph)

### Grafana

- 192.168.56.15

[grafana](http://192.168.56.15:3000)

### ElasticSearch

- 192.168.56.11
- 192.168.56.14

[elasticsearch](http://192.168.56.14:9200/)

### FileBeat

- 192.168.56.11
- 192.168.56.12
- 192.168.56.13
- 192.168.56.14
- 192.168.56.15

### Kibana

- 192.168.56.15

[kibana](http://192.168.56.15:5601/)

### HDFS

- 192.168.56.12, name node
- 192.168.56.13
- 192.168.56.15

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

### dubbo admin

- 192.168.56.11

[dubbo-admin](http://192.168.56.11:8080)
