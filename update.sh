#!/bin/bash

set -e

source ~/Research/lab/env/env.sh
read_server_pass

echo "$PASSWORD" | sudo -S su -c "apt update && apt update && apt upgrade -y && apt autoremove --purge -y"

echo

echo "$PASSWORD" | sudo -S snap refresh

echo
