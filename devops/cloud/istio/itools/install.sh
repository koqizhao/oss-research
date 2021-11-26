#!/bin/bash

TAG="$1"
if [ "" = "$TAG" ]; then
        echo "Usage: <script> <tag> [<profile>] [<hub>]"
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

../bin/istioctl install --set profile=$PROFILE \
        --set hub=$HUB \
        --set tag=$TAG \
        -y

kubectl label namespace default istio-injection=enabled
kubectl apply -f ../samples/addons
kubectl rollout status deployment/kiali -n istio-system

./start-kiali.sh
