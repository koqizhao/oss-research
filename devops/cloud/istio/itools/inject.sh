#!/bin/bash

deployment=$1
if [ "$deployment" = "" ]; then
	echo "usage: <script> <deployment>"
	exit 1
fi

kubectl patch deployment $deployment --patch '{"spec": {"template": {"metadata": {"annotations": {"sidecar.istio.io/inject": "true"}}}}}'

kubectl get deployment $deployment -o yaml | istioctl kube-inject -f - | kubectl apply -f -
