#!/bin/bash

./codis-dashboard -c conf/codis-dashboard.toml \
    --log=LOG_DIR/codis-dashboard.log --log-level=INFO \
    > LOG_DIR/codis-dashboard.out 2>&1 &
