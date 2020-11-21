#!/bin/bash

http_port=5556
java -jar jmx_prometheus_httpserver.jar $http_port kafka.yml
