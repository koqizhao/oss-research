#!/bin/bash

set -e

echo -n "password: "
read -s PASSWORD
echo

source ~/Research/servers.sh
source ~/Research/common/remote.sh

for i in ${servers[@]}
do
    remote_update $i $PASSWORD
done
