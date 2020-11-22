#!/bin/bash

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export KE_HOME=DEPLOY_PATH

cd $KE_HOME
bin/ke.sh $1
