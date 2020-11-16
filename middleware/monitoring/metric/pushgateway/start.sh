#!/bin/bash

./pushgateway --web.listen-address=":9091" \
    --persistence.file=../data/pushgateway/pushgateway.metrics \
    --persistence.interval=5m \
    --web.enable-admin-api \
    --web.enable-lifecycle

