#!/bin/bash

source ./get-ingress.sh

for i in $(seq 1 100); do curl -s -o /dev/null "http://$GATEWAY_URL/productpage"; done
