#!/bin/bash

../thanos query \
    --http-address 0.0.0.0:19192 \
    --query.replica-label replica \
STORE_PLACEHOLDER
