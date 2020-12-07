#!/bin/bash

java -Dserver.port=8081 -Dxxl.job.executor.port=9999 -Dxxl.job.executor.ip=SERVER_IP \
    -jar xxl-job-executor-sample-springboot.jar \
    > LOG_DIR/xxl-job-executor-sample-springboot.out 2>&1 &
