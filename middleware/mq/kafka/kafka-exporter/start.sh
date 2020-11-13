#!/bin/bash

cd /home/koqizhao/kafka-exporter

./kafka_exporter --kafka.server=KAFKA_SERVER:9092 > kafka_exporter.out 2>&1
