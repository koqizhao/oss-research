#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

remote_deploy()
{
    ssh $1 "mkdir -p $deploy_path/$component"
    ssh $1 "mkdir -p $deploy_path/data/$component"

    ssh $1 "curl -fsSL $gpg_site > gpg; echo '$PASSWORD' | sudo -S apt-key add gpg; rm gpg;"
    ssh $1 "echo '$PASSWORD' | sudo -S apt-key fingerprint $gpg_pub"
    ssh $1 "echo '$PASSWORD' | sudo -S add-apt-repository \"$apt_repo\""
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y debconf-utils"
    ssh $1 "echo '$PASSWORD' | sudo -S apt install -y $pg_pkg"

    declare data_dir
    data_dir=`escape_slash $deploy_path/data/$component`
    sed "s/DATA_DIR/$data_dir/g" postgresql.conf \
        | sed "s/PG_VERSION/$deploy_version/g" \
        > postgresql.conf.tmp
    scp postgresql.conf.tmp $server:$deploy_path/postgresql.conf
    rm postgresql.conf.tmp

    scp pg_hba.conf $server:$deploy_path/pg_hba.conf

    sed "s/PG_USER/$pg_db_user/g" init.sql \
        | sed "s/PG_PASSWORD/$pg_db_password/g" \
        > init.sql.tmp
    scp init.sql.tmp $server:$deploy_path/$component/init.sql
    rm init.sql.tmp

    ssh $1 "cd $deploy_path; \
        echo '$PASSWORD' | sudo -S chown postgres:postgres postgresql.conf; \
        echo '$PASSWORD' | sudo -S chmod 644 postgresql.conf; \
        echo '$PASSWORD' | sudo -S mv postgresql.conf /etc/postgresql/$deploy_version/main; \
        echo '$PASSWORD' | sudo -S chown -R postgres:postgres $deploy_path/data/$component; \
        echo '$PASSWORD' | sudo -S su - postgres -c \
            '/usr/lib/postgresql/$deploy_version/bin/initdb -D $deploy_path/data/$component'; \
        echo '$PASSWORD' | sudo -S chown postgres:postgres pg_hba.conf; \
        echo '$PASSWORD' | sudo -S chmod 640 pg_hba.conf; \
        echo '$PASSWORD' | sudo -S mv pg_hba.conf /etc/postgresql/$deploy_version/main; \
        echo '$PASSWORD' | sudo -S systemctl restart postgresql; \
        echo '$PASSWORD' | sudo -S su - postgres -c 'psql -f $deploy_path/$component/init.sql'; \
        rm $deploy_path/$component/init.sql; "
}

batch_deploy
