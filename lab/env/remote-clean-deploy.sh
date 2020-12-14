#!/bin/bash

set -e

source ~/Research/lab/env/servers.sh

declare i
for i in ${servers[@]}
do
    echo -e "\n\nserver: $i\n\n"
    ~/Research/lab/deploy/clean.sh $i
done
