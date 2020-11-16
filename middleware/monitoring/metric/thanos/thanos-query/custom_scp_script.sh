#!/bin/bash

store_conf=""
nlh=NL_PLACE_HOLDER
for s in ${thanos_sidecar_servers[@]}
do
    if [ -z "$store_conf" ]; then
        store_conf="    --store $s:19090"
    else
        store_conf="${store_conf} \\$nlh    --store $s:19090"
    fi
done

store_conf=`escape_slash "$store_conf"`
sed "s/STORE_PLACEHOLDER/$store_conf/g" $component/start.sh \
    | sed "s/$nlh/\n/g" \
    > start.sh.tmp
chmod a+x start.sh.tmp
scp start.sh.tmp $server:$deploy_path/$parent_component/$component/start.sh
rm start.sh.tmp

ssh $server "cd $deploy_path/$parent_component/$component; chmod +x start.sh"
