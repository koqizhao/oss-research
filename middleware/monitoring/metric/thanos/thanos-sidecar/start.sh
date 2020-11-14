#!/bin/bash

../thanos sidecar \
    --tsdb.path                 ../../data/prometheus \
    --prometheus.url            http://localhost:9090 \
    --http-address              0.0.0.0:19191 \
    --grpc-address              0.0.0.0:19090
