#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_clean()
{
    ssh $1 "rm -rf $deploy_path/$component"
    ssh $1 "rm -rf $deploy_path/data/$component"
    ssh $1 "rm -rf ~/logs/consolelogs; rm -rf ~/logs/rocketmqlogs; \
        files=\`ls ~/logs\`; if [ -z "\$files" ]; then rm -rf ~/logs; fi; "
}

batch_stop

batch_clean
