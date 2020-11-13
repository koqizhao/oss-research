#!/bin/bash

java -Ddubbo.config-center.timeout=10000 \
    -Ddubbo.registry.timeout=10000 \
    -jar io.study.dubbo-starter-springboot-client-0.0.1.jar > springboot-client.out 2>&1 &
