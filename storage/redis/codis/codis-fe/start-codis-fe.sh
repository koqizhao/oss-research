#!/bin/bash

./codis-fe --COORDINATOR_NAME=COORDINATOR_ADDR --listen=0.0.0.0:8080 \
    --log=LOG_DIR/codis-fe.log --log-level=INFO \
    > LOG_DIR/codis-fe.out 2>&1 &
