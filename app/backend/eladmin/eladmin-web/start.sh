#!/bin/bash

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

$JAVA_HOME/bin/java -jar eladmin.jar > LOG_DIR/eladmin.out 2>&1 &
