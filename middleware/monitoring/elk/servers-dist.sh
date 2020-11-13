#!/bin/bash

declare -Ag es_servers_map
es_servers_map=([192.168.56.11]=server1 \
    [192.168.56.12]=server2)

kibana_servers=(192.168.56.11)

filebeat_servers=(192.168.56.11 192.168.56.12 192.168.56.13)
