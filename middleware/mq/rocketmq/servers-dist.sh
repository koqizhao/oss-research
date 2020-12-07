#!/bin/bash

name_servers=(192.168.56.11 192.168.56.12)

declare -Ag broker_role_server_map
broker_role_server_map[broker-a]=192.168.56.11
broker_role_server_map[broker-a-s]=192.168.56.12
broker_role_server_map[broker-b]=192.168.56.12
broker_role_server_map[broker-b-s]=192.168.56.11
