#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

log_dir=`escape_slash $deploy_path/logs/$component`
sed "s/LOG_DIR_PLACEHOLDER/$log_dir/g" bin/webappService.sh \
    > bin/webappService.sh.tmp
chmod a+x bin/webappService.sh.tmp

oap_agg_servers=""
for s in ${aggregator_servers[@]}
do
    if [ -z "$oap_agg_servers" ]; then
        oap_agg_servers="$s:12801"
    else
        oap_agg_servers="$oap_agg_servers, $s:12801"
    fi
done
sed "s/OAP_AGGREGATORS/$oap_agg_servers/g" conf/webapp.yml \
    > conf/webapp.yml.tmp

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "mkdir -p $deploy_path/logs/$component"

    scp ~/Software/skywalking/$deploy_file $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf $deploy_file; mv $deploy_folder $component; rm $deploy_file"

    scp bin/webappService.sh.tmp $server:$deploy_path/$component/bin/webappService.sh
    scp conf/webapp.yml.tmp $server:$deploy_path/$component/webapp/webapp.yml

    remote_start $server $component
}

batch_deploy

rm conf/webapp.yml.tmp
