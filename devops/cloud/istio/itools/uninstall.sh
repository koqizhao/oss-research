#!/bin/bash

PROFILE="$1"

if [ "" = "$PROFILE" ]; then
	PROFILE="demo"
fi

../bin/istioctl manifest generate --set profile=$PROFILE \
       	| kubectl delete --ignore-not-found=true -f -

kubectl label namespace default istio-injection-

kubectl delete namespace istio-system
