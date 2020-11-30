#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_deploy()
{
    curl -fsSL $gpg_site > gpg; echo $PASSWORD | sudo -S apt-key add gpg; rm gpg;
    echo $PASSWORD | sudo -S apt-key fingerprint $gpg_pub
    echo $PASSWORD | sudo -S add-apt-repository "$apt_repo"
    echo $PASSWORD | sudo -S apt update
    echo $PASSWORD | sudo -S apt install -y pgadmin4

    echo $PASSWORD | sudo -S cp -f ports.conf /etc/apache2
    echo $PASSWORD | sudo -S chmod 644 /etc/apache2/ports.conf

    sudo /usr/pgadmin4/bin/setup-web.sh
}

batch_deploy
