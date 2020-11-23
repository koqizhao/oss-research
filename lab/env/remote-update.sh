#!/bin/bash

set -e

source ~/Research/lab/env/env.sh
read_server_pass

source ~/Research/lab/env/servers.sh
source ~/Research/lab/deploy/remote.sh

for i in ${servers[@]}
do
    remote_update $i $PASSWORD
done
