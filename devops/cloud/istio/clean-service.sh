#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    ssh $server "pid=\`ps aux | grep kiali | grep -v grep | awk '{ print \$2 }'\`; kill \$pid;"
    ssh $server "cd $deploy_path/$component/itools; ./uninstall-samples.sh; ./uninstall.sh;"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$component"
}

batch_clean
