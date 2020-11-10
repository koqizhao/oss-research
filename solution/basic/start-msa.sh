#!/bin/bash

cd ~/Research

cd mysql
echo "start mysql"
./remote-start.sh
echo

cd ../apollo
echo "start apollo"
./enable-apollo.sh enable basic
echo

cd ../zookeeper
echo "start zookeeper"
./enable-zk.sh enable basic
echo

cd ../elk
echo "start elk"
./enable-elk.sh enable basic
echo

cd ../dubbo
echo "start dubbo"
./enable-dubbo.sh enable basic
echo
