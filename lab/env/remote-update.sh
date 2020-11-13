#!/bin/bash

set -e

echo -n "password: "
read -s PASSWORD
echo

source ~/Research/lab/env/servers.sh
source ~/Research/lab/deploy/remote.sh

for i in ${servers[@]}
do
    remote_update $i $PASSWORD
done
