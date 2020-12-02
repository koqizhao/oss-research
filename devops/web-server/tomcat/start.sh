#!/bin/bash

export JAVA_OPTS=""
export CATALINA_OPTS="-Dms128m -Dmx512m"

bin/catalina.sh run
