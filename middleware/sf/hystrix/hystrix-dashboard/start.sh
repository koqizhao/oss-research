#!/bin/bash

java -DserverPort=8080 -DbindAddress=0.0.0.0 \
    -jar hystrix-dashboard.jar > hystrix-dashboard.out 2>&1 &
