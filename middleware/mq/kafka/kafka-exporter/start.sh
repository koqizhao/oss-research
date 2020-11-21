#!/bin/bash

./kafka_exporter --kafka.server=KAFKA_SERVER:9092 --web.listen-address=":9308" \
    > kafka_exporter.out 2>&1
