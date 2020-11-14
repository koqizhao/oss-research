#!/bin/bash

./prometheus --config.file=./prometheus.yml \
    --storage.tsdb.path=../data/prometheus \
    --web.listen-address=0.0.0.0:9090 \
    --web.enable-lifecycle \
    --web.enable-admin-api
