#!/bin/bash

component=$1
deploy_path=/home/koqizhao/apollo/$component

shutdown_script=$deploy_path/scripts/shutdown.sh
if [ -f "$shutdown_script" ]; then
    $shutdown_script
fi

mkdir -p /opt/logs
chmod -R 777 /opt/logs

rm -rf $deploy_path
mkdir $deploy_path

mv apollo-$component-*-github.zip $deploy_path

cd $deploy_path

apt install -y unzip
unzip $deploy_path/apollo-$component-*-github.zip

mv -f ../app.properties config/
mv -f ../application-github.properties config/
mv -f ../startup.sh scripts/
chmod +x scripts/*.sh

chown -R koqizhao:koqizhao $deploy_path

su - koqizhao -c "cd $deploy_path; scripts/startup.sh"
