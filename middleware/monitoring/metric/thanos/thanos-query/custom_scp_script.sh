#!/bin/bash

store_conf=""
for s in ${thanos_sidecar_servers[@]}
do
    if [ -z $store_conf ]; then
        store_conf=`echo -en "    --store $s:19090"`
    else
        store_conf=`echo -en "$store_conf \\\n    -store $s:19090"`
    fi
done

store_conf=`escape_slash "$store_conf"`

sed "s/STORE_PLACEHOLDER/$store_conf/g" $component/start.sh \
    > start.sh.tmp
scp start.sh.tmp $server:$deploy_path/$parent_component/$component/start.sh
rm start.sh.tmp

ssh $server "cd $deploy_path/$parent_component/$component; chmod +x start.sh"
