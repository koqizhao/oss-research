#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" .

source common.sh

#mysql_version=8.0.21
#deploy_file_name=mysql-$mysql_version-linux-glibc2.12-x86_64
#deploy_file=$deploy_file_name.tar.xz

mysql_version=5.7.31
deploy_file_name=mysql-$mysql_version-linux-glibc2.12-x86_64
deploy_file=$deploy_file_name.tar.gz

remote_deploy()
{
    server=$1
    ssh $server "echo '$PASSWORD' | sudo -S apt install -y libaio1 libncurses5"

    ssh $server "echo '$PASSWORD' | sudo -S groupadd mysql"
    ssh $server "echo '$PASSWORD' | sudo -S useradd -r -g mysql -s /bin/false mysql"

    ssh $server "mkdir -p $deploy_path/data"
    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S chown -R mysql:mysql data;"
    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S chmod -R 750 data;"

    ssh $server "mkdir -p $deploy_path/logs"
    ssh $server "cd $deploy_path/logs; touch mysql.log;"
    ssh $server "cd $deploy_path/logs; echo '$PASSWORD' | sudo -S chown mysql:mysql mysql.log;"
    ssh $server "cd $deploy_path/logs; echo '$PASSWORD' | sudo -S chmod 666 mysql.log"

    scp ~/Software/mysql/$deploy_file $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf $deploy_file; mv $deploy_file_name $component; rm $deploy_file;"

    declare dp
    dp=`escape_slash $deploy_path`
    sed "s/BASE_DIR/$dp/g" defaults.conf \
        > defaults-tmp.conf
    scp defaults-tmp.conf $server:$deploy_path/$component/defaults.conf
    rm defaults-tmp.conf

    scp start.sh $server:$deploy_path/$component

    sed "s/MYSQL_PASSWORD/$mysql_db_password/g" init.sql \
        > init-tmp.sql
    scp init-tmp.sql $server:$deploy_path/$component/init.sql
    rm init-tmp.sql

    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S chown -R mysql:mysql $component;"
    ssh $server "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S bin/mysqld --defaults-file=defaults.conf --initialize --user=mysql 2>&1 | grep \"temporary password\" | awk -F\"root@localhost: \" '{ print \$2 }' > ../p.out;"
    ssh $server "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S ./start.sh;"
    ssh $server "cd $deploy_path/$component; bin/mysql --connect-expired-password --user=root --password=\`cat ../p.out\` < init.sql;"
    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S rm -f p.out; echo '$PASSWORD' | sudo -S rm -f mysql/init.sql;"

    sed "s/BASE_DIR/$dp/g" mysql.sh \
        > mysql.sh.tmp
    scp mysql.sh.tmp $server:$deploy_path/mysql.sh
    rm mysql.sh.tmp
    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S chown root:root mysql.sh;"
    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S mv mysql.sh /etc/profile.d;"
}

batch_deploy
