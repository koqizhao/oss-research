#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

#mysql_version=8.0.21
#deploy_file_name=mysql-$mysql_version-linux-glibc2.12-x86_64
#deploy_file=$deploy_file_name.tar.xz

mysql_version=5.7.31
deploy_file_name=mysql-$mysql_version-linux-glibc2.12-x86_64
deploy_file=$deploy_file_name.tar.gz

generate_server_id()
{
    echo $1 | awk -F '.' '{ print $4 }'
}

remote_deploy()
{
    server=$1
    ssh $server "echo '$PASSWORD' | sudo -S apt install -y libaio1 libncurses5"

    ssh $server "echo '$PASSWORD' | sudo -S groupadd mysql"
    ssh $server "echo '$PASSWORD' | sudo -S useradd -r -g mysql -s /bin/false mysql"

    ssh $server "mkdir -p $deploy_path/data/$component"
    ssh $server "echo '$PASSWORD' | sudo -S chown -R mysql:mysql $deploy_path/data/$component"
    ssh $server "echo '$PASSWORD' | sudo -S chmod -R 750 $deploy_path/data/$component"

    ssh $server "mkdir -p $deploy_path/logs/$component"
    ssh $server "touch $deploy_path/logs/$component/$component.log"
    ssh $server "echo '$PASSWORD' | sudo -S chown -R mysql:mysql $deploy_path/logs/$component"

    scp ~/Software/mysql/$deploy_file $server:$deploy_path
    ssh $server "cd $deploy_path; tar xf $deploy_file; mv $deploy_file_name $component; rm $deploy_file;"
    ssh $server "mkdir -p $deploy_path/$component/conf"

    declare dp
    dp=`escape_slash $deploy_path`
    sed "s/BASE_DIR/$dp/g" conf/defaults.cnf \
        | sed "s/SERVER_ID/`generate_server_id $server`/g" \
        > conf/defaults.cnf.tmp
    scp conf/defaults.cnf.tmp $server:$deploy_path/$component/conf/defaults.cnf
    rm conf/defaults.cnf.tmp

    scp start.sh $server:$deploy_path/$component

    sed "s/MYSQL_PASSWORD/$mysql_db_password/g" conf/init.sql \
        > conf/init.sql.tmp
    scp conf/init.sql.tmp $server:$deploy_path/$component/conf/init.sql
    rm conf/init.sql.tmp

    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S chown -R mysql:mysql $component;"
    ssh $server "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S \
        bin/mysqld --defaults-file=conf/defaults.cnf --initialize --user=mysql; \
        echo '$PASSWORD' | sudo -S cat $deploy_path/logs/$component/$component.err | \
            grep 'temporary password' | awk -F 'root@localhost: ' '{ print \$2 }' \
            > ../p.out"
    ssh $server "cd $deploy_path/$component; echo '$PASSWORD' | sudo -S ./start.sh;"
    ssh $server "cd $deploy_path/$component; \
        bin/mysql --connect-expired-password --user=root --password=\"\`cat ../p.out\`\" < conf/init.sql;"
    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S \
        rm -f p.out; echo '$PASSWORD' | sudo -S rm -f $component/conf/init.sql;"

    sed "s/BASE_DIR/$dp/g" mysql.sh \
        > mysql.sh.tmp
    chmod a+x mysql.sh.tmp
    scp mysql.sh.tmp $server:$deploy_path/mysql.sh
    rm mysql.sh.tmp
    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S chown root:root mysql.sh;"
    ssh $server "cd $deploy_path; echo '$PASSWORD' | sudo -S mv mysql.sh /etc/profile.d;"
}

init_master()
{
    for master in ${master_servers[@]}
    do
        mysql_db_exec conf/init-master.sql $master 
    done
}

config_master_slave()
{
    master=${master_servers[0]}
    master_status=`mysql_db_exec conf/reset-master.sql $master 2>/dev/null | grep mysql-binlog`
    master_log_file=`echo "$master_status" | awk '{ print $1 }'`
    master_log_pos=`echo "$master_status" | awk '{ print $2 }'`

    sed "s/master_host/$master/g" conf/enable-slave.sql \
        | sed "s/master_password/$mysql_db_password/g" \
        | sed "s/master_log_file/$master_log_file/g" \
        | sed "s/master_log_pos/$master_log_pos/g" \
        > conf/enable-slave.sql.tmp
    for slave in ${slave_servers[@]}
    do
        mysql_db_exec conf/enable-slave.sql.tmp $slave 
    done
    rm conf/enable-slave.sql.tmp
}

batch_deploy

init_master

config_master_slave
