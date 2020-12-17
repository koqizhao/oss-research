#!/bin/bash

deploy_path=/home/koqizhao/middleware/sf/artemis

read_server_pass

export stop_start_interval=10

artemis_port=8080

artemis_service_url=""
for s in ${servers[@]}
do
    if [ -z "$artemis_service_url" ]; then
        artemis_service_url="http://$s:$artemis_port"
    else
        artemis_service_url="$artemis_service_url,http://$s:$artemis_port"
    fi
done

cluster_node_setting=""
for zone in ${zones[@]}
do
    declare c="echo \${${zone}_servers[@]}"
    declare zone_nodes=(`eval $c`)
    if [ ${#zone_nodes[@]} == 0 ]; then
        continue
    fi

    declare zone_node_setting=""
    for node in ${zone_nodes[@]}
    do
        if [ -z "$zone_node_setting" ]; then
            zone_node_setting="$zone:http://$node:$artemis_port"
        else
            zone_node_setting="$zone_node_setting,http://$node:$artemis_port"
        fi
    done

    if [ -z "$cluster_node_setting" ]; then
        cluster_node_setting="$zone_node_setting"
    else
        cluster_node_setting="$cluster_node_setting;$zone_node_setting"
    fi
done
