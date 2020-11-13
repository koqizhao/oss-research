#!/bin/bash

component=$1

mkdir -p /opt/logs
chmod -R 777 /opt/logs

mkdir -p $component

mv $component-*-github.zip $component

cd $component

apt install -y unzip
unzip $component-*-github.zip
rm $component-*-github.zip

mv -f ../app.properties config/
mv -f ../application-github.properties config/
mv -f ../apollo-env.properties config/
mv -f ../startup.sh scripts/
chmod +x scripts/*.sh
