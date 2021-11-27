#!/bin/bash

TAG="$1"
if [ "" = "$TAG" ]; then
        echo "Usage: <script> <tag> [<profile>] [<hub>] [<jwt_policy>]"
        exit 1
fi
PROFILE="$2"
if [ "" = "$PROFILE" ]; then
        PROFILE="demo"
fi
HUB="$3"
if [ "" = "$HUB" ]; then
        HUB="gcr.io/istio-testing"
fi
JWT_POLICY="$4"
if [ "" = "$HUB" ]; then
        JWT_POLICY="third-party-jwt"
fi

../bin/istioctl manifest generate --set profile=$PROFILE \
        --set hub=$HUB \
        --set tag=$TAG \
        --set values.global.jwtPolicy=$JWT_POLICY \
        > $TAG.yaml
