#!/bin/bash

deploy_path=/home/koqizhao/app/backend/eladmin

read_server_pass

admin_server_port=8000
web_server_port=8013

admin_server_http_url="http://${admin_servers[0]}:$admin_server_port"
admin_server_ws_url="wss://${admin_servers[0]}:$admin_server_port"
