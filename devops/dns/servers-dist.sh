#!/bin/bash

primary_server=192.168.56.11
secondary_server=192.168.56.12
cache_servers=(192.168.56.13 192.168.56.14)

servers=(`merge_array $primary_server $secondary_server ${cache_servers[@]}`)
