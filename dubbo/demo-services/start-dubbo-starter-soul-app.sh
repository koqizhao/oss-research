#!/bin/bash

java -Ddubbo.config-center.timeout=10000 \
    -Ddubbo.registry.timeout=10000 \
    -jar io.study.dubbo-starter-soul-app-0.0.1.jar > soul-app.out 2>&1 &
