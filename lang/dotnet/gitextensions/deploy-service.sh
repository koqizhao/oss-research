#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file=GitExtensions-2.51.05-Mono.zip

remote_deploy()
{
    mkdir -p $deploy_path

    echo $PASSWORD | sudo -S apt install -y kdiff3

    cp ~/Software/build/$deploy_file $deploy_path

    cd $deploy_path
    unzip $deploy_file
    rm $deploy_file
    rm $component/Plugins/Bitbucket.dll

    cd $work_path
    work_dir=`escape_slash $deploy_path/$component`
    sed "s/WORK_DIR/$work_dir/g" gitext.sh \
        > gitext.sh.tmp
    chmod a+x gitext.sh.tmp
    mv gitext.sh.tmp $deploy_path/$component/gitext.sh

    ln -s $deploy_path/$component/gitext.sh ~/Desktop/GitExtensions.link
}

batch_deploy
