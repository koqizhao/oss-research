#! /bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

read_server_pass

source common.sh

deploy_version=konga-0.14.9
deploy_file=$deploy_version.tar.gz
node_registry=https://registry.npm.taobao.org

sed "s/PG_USER/$pg_user/g" init.sql \
    | sed "s/PG_PASSWORD/$pg_password/g" \
    > init.sql.tmp
pg_db_exec init.sql.tmp
rm init.sql.tmp

sed "s/PG_USER/$pg_user/g" .env \
    | sed "s/PG_PASSWORD/$pg_password/g" \
    | sed "s/PG_HOST/$pg_db_server/g" \
    > .env.tmp

remote_deploy()
{
    server=$1
    component=$2

    ssh $server "echo '$PASSWORD' | sudo -S apt install -y nodejs npm"

    ssh $server "mkdir -p $deploy_path"

    scp ~/Software/kong/$deploy_file $server:$deploy_path
    ssh $server "cd $deploy_path; \
        tar xf $deploy_file; mv $deploy_version $component; \
        rm $deploy_file;"

    scp .env.tmp $server:$deploy_path/$component/.env
    scp start-konga.sh $server:$deploy_path/$component

    ssh $server "cd $deploy_path/$component; \
        npm --registry $node_registry i; \
        node ./bin/konga.js  prepare --adapter postgres \
            --uri postgresql://$pg_user:$pg_password@$pg_db_server:5432/konga; "
}

batch_deploy
rm .env.tmp

batch_start
