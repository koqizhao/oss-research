#!/bin/bash

kubectl apply -f ../samples/bookinfo/platform/kube/bookinfo.yaml

kubectl apply -f ../samples/bookinfo/networking/bookinfo-gateway.yaml

../bin/istioctl analyze
