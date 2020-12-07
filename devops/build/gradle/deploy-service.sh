#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_file=gradle-6.7.1-bin.zip

remote_deploy()
{
    mkdir -p $deploy_path

    cp ~/Software/build/$deploy_file $deploy_path
    cd $deploy_path
    unzip $deploy_file
    rm $deploy_file
    mv gradle-* gradle
    cd $work_path

    p=`realpath $deploy_path/$component`
    echo -e "\nexport PATH=$p/bin:\$PATH\n" >> ~/.profile
    source ~/.profile
}

batch_deploy
