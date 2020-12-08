#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_deploy()
{
    ssh $1 "echo '$PASSWORD' | sudo -S mkdir -p $deploy_path;"

    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf $deploy_path/$deploy_folder"

    scp /home/koqizhao/Software/jdk/$deploy_file $1:./
    ssh $1 "tar xf $deploy_file"
    ssh $1 "rm $deploy_file"
    ssh $1 "echo '$PASSWORD' | sudo -S mv $deploy_folder $deploy_path"

    ssh $1 "echo '$PASSWORD' | sudo -S chown -R root:root $deploy_path; \
        echo '$PASSWORD' | sudo -S chmod -R 755 $deploy_path; "
    ssh $1 "echo '$PASSWORD' | sudo -S update-alternatives --install /usr/bin/java java \
        $deploy_path/$deploy_folder/bin/java $priority"
    ssh $1 "echo '$PASSWORD' | sudo -S update-alternatives --set java \
        $deploy_path/$deploy_folder/bin/java"
}

batch_deploy
