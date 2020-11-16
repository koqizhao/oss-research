#!/bin/bash

./alertmanager --config.file=./alertmanager.yml \
    --storage.path=../data/alertmanager/ \
    CLUSTER_OPTS --web.listen-address=":9093"
