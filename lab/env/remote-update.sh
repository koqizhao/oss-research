#!/bin/bash

set -e

source ~/Research/lab/env/env.sh
read_server_pass

source ~/Research/lab/env/servers.sh
source ~/Research/lab/deploy/remote.sh

if [ "$1" != "" ]; then
    remote_update $1 $PASSWORD
    exit 0
fi

for i in ${servers[@]}
do
    remote_update $i $PASSWORD
done
