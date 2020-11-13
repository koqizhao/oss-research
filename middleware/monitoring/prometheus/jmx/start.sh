#!/bin/bash

cd /home/koqizhao/jmx-exporter
http_port=5556
java -jar jmx_exporter.jar $http_port kafka.yml > jmx_exporter.out 2>&1
