#!/bin/bash

java -Delasticjob.preferred.network.interface=enp0s8 \
    -jar my-job.jar \
    > LOG_DIR/my-job.out 2>&1 &
