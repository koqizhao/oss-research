#!/bin/bash

../bin/istioctl dashboard --address=0.0.0.0 kiali > kiali.log 2>&1 &
