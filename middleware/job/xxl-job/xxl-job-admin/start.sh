#!/bin/bash

java -Dserver.port=8080 -jar xxl-job-admin.jar > LOG_DIR/xxl-job-admin.out 2>&1 &
