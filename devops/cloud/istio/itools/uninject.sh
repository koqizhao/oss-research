#!/bin/bash

deployment=$1
if [ "$deployment" = "" ]; then
	echo "usage: <script> <deployment>"
	exit 1
fi

kubectl get deployment $deployment -o yaml | istioctl experimental kube-uninject -f - | kubectl apply -f -

kubectl patch deployment $deployment --patch '{"spec": {"template": {"metadata": {"annotations": {"sidecar.istio.io/inject": "true"}}}}}'
