#!/bin/bash

./codis-proxy -c conf/codis-proxy.toml \
    --log=LOG_DIR/codis-proxy.log --log-level=INFO \
    > LOG_DIR/codis-proxy.out 2>&1 &
