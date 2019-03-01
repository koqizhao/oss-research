#!/bin/bash

SIGNAL=${SIGNAL:-TERM}
PIDS=$(ps ax | grep -i 'kafka_exporter' | grep -v grep | awk '{print $1}')

if [ -z "$PIDS" ]; then
  echo "No kafka_exporter to stop"
  exit 1
else
  kill -s $SIGNAL $PIDS
fi

