#!/bin/bash

source ~/Research/lang/shell/util.sh
source ~/Research/lab/deploy/remote.sh

declare folders=("middleware" "storage" "ops" "app")

for folder in ${folders[@]}
do
    remote_clean_empty_folder $1 $folder
done

echo
