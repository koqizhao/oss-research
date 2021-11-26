#!/bin/bash

../samples/bookinfo/platform/kube/cleanup.sh

kubectl get virtualservices   #-- there should be no virtual services
kubectl get destinationrules  #-- there should be no destination rules
kubectl get gateway           #-- there should be no gateway
kubectl get pods              #-- the Bookinfo pods should be deleted
