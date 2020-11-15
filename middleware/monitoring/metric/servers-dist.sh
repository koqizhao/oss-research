#!/bin/bash

prometheus_servers=(192.168.56.11 192.168.56.12)

node_exporter_servers=(192.168.56.11 192.168.56.12)
jmx_exporter_servers=(192.168.56.11 192.168.56.12)

grafana_servers=(192.168.56.11)

thanos_sidecar_servers=${prometheus_servers[@]}
thanos_query_servers=(192.168.56.11)
