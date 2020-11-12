#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" .

source common.sh

mysql_version=8.0.21
deploy_file_name=mysql-$mysql_version-linux-glibc2.12-x86_64
deploy_file=$deploy_file_name.tar.xz

deploy()
{
    server=$1
    echo -e "\ndeploy started: $server\n"

    ssh $server "echo '$PASSWORD' | sudo -S apt install -y libaio1 libncurses5"

    ssh $server "echo '$PASSWORD' | sudo -S groupadd mysql"
    ssh $server "echo '$PASSWORD' | sudo -S useradd -r -g mysql -s /bin/false mysql"

    ssh $server "mkdir -p $deploy_path/data"
    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S chown -R mysql:mysql data;"
    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S chmod -R 750 data;"

    scp ~/Software/mysql/$deploy_file $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf $deploy_file; mv $deploy_file_name $component; rm $deploy_file;"
    scp defaults.conf $server:$deploy_path/$component
    scp start-mysql.sh $server:$deploy_path/$component
    scp init.sql $server:$deploy_path/$component
    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S chown -R mysql:mysql $component;"
    ssh $server "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S bin/mysqld --defaults-file=defaults.conf --initialize --user=mysql 2>&1 | grep \"temporary password\" | awk -F\"root@localhost: \" '{ print \$2 }' > ../p.out;"
    ssh $server "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S ./start-mysql.sh;"
    ssh $server "cd $deploy_path/$component; bin/mysql --connect-expired-password --user=root --password=\`cat ../p.out\` < init.sql;"
    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S rm -f p.out; echo '$PASSWORD' | sudo -S rm -f mysql/init.sql;"

    scp mysql.sh $server:$deploy_path
    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S chown root:root mysql.sh;"
    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S mv mysql.sh /etc/profile.d;"
}

remote_deploy
