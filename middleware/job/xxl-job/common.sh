#!/bin/bash

deploy_path=/home/koqizhao/middleware/job/xxl-job
project_path=~/Projects/misc/xxl-job

admin_addresses=""
for s in ${servers[@]}
do
    if [ -z "$admin_addresses" ]; then
        admin_addresses="http://$s:8080/xxl-job-admin"
    else
        admin_addresses="$admin_addresses,http://$s:8080/xxl-job-admin"
    fi
done
