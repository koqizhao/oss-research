#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

deploy_version=2.1-rc1
deploy_file_name=apisix-dashboard-$deploy_version
deploy_file=$deploy_file_name.tar.gz

nodejs_apt_repo="deb https://deb.nodesource.com/node_14.x \$(lsb_release -cs) main"
nodejs_gpg_key_pub=68576280
yarn_apt_repo="deb https://dl.yarnpkg.com/debian/ stable main"
yarn_gpg_key_pub=86E50310

build()
{
    server=$1

    ssh $server "echo '$PASSWORD' | sudo -S apt update; \
        echo '$PASSWORD' | sudo -S apt install -y gcc make; \
        echo '$PASSWORD' | sudo -S apt install -y golang; \
        go env -w GOPROXY=https://goproxy.cn,direct; \
        echo '$PASSWORD' | sudo -S apt install -y luarocks; "

    ssh $server "curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key > gpg; \
        echo '$PASSWORD' | sudo -S apt-key add gpg; rm gpg; \
        echo '$PASSWORD' | sudo -S apt-key fingerprint $nodejs_gpg_key_pub; \
        echo '$PASSWORD' | sudo -S add-apt-repository \"$nodejs_apt_repo\"; \
        curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg > gpg; \
        echo '$PASSWORD' | sudo -S apt-key add gpg; rm gpg; \
        echo '$PASSWORD' | sudo -S apt-key fingerprint $yarn_gpg_key_pub; \
        echo '$PASSWORD' | sudo -S add-apt-repository \"$yarn_apt_repo\"; \
        echo '$PASSWORD' | sudo -S apt update; \
        echo '$PASSWORD' | sudo -S apt install -y nodejs yarn"
 
    ssh $server "mkdir -p $deploy_path"

    scp ~/Software/apisix/$deploy_file $server:$deploy_path
    ssh $server "cd $deploy_path; \
        tar xf $deploy_file; mv $deploy_file_name $component; rm $deploy_file"

    ssh $server "cd $deploy_path/$component; \
        make build; mv output $component; \
        tar cf $component.tar $component; \
        mv $component.tar $deploy_path; "
    rm -f $component.tar
    scp $server:$deploy_path/$component.tar ./
    ssh $server "rm -rf $deploy_path/$component; \
        rm -f $deploy_path/$component.tar"

    ssh $server "echo '$PASSWORD' | sudo -S apt purge -y gcc make golang nodejs yarn; \
        echo '$PASSWORD' | sudo -S rm -rf ~/go; \
        echo '$PASSWORD' | sudo -S rm -rf ~/.npm; \
        echo '$PASSWORD' | sudo -S rm -rf ~/.yarn; \
        echo '$PASSWORD' | sudo -S rm -f ~/.yarnrc; \
        echo '$PASSWORD' | sudo -S add-apt-repository -r -y \"$nodejs_apt_repo\"; \
        echo '$PASSWORD' | sudo -S apt-key del $nodejs_gpg_key_pub; \
        echo '$PASSWORD' | sudo -S add-apt-repository -r -y \"$yarn_apt_repo\"; \
        echo '$PASSWORD' | sudo -S apt-key del $yarn_gpg_key_pub; \
        echo '$PASSWORD' | sudo -S apt update; \
        echo '$PASSWORD' | sudo -S apt autoremove -y --purge"
}

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "echo '$PASSWORD' | sudo -S apt install -y luarocks; "

    ssh $server "mkdir -p $deploy_path"

    scp $component.tar $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf $component.tar; rm $component.tar; "

    scp conf/conf.yaml $server:$deploy_path/$component/conf
    scp start.sh $server:$deploy_path/$component
}

build ${servers[0]}

batch_deploy

batch_start
