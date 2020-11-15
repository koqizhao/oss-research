#!/bin/bash

./node_exporter --web.listen-address=":9100" \
    --web.max-requests=40
