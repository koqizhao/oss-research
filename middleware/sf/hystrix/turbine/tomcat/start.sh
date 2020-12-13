#!/bin/bash

export CATALINA_OPTS="$CATALINA_OPTS \
    -Darchaius.configurationSource.additionalUrls=file://BASE_DIR/conf/config.properties"

bin/catalina.sh run
