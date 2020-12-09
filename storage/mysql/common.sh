#!/bin/bash

deploy_path=/home/koqizhao/storage/mysql

read_server_pass

servers=(`merge_array ${master_servers[@]} ${slave_servers[@]}`)
