#!/bin/bash

source ../common.sh

parent_component=thanos
all_servers=`merge_array ${thanos_sidecar_servers[@]} ${thanos_query_servers[@]}`
