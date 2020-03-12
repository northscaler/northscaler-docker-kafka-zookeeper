#!/usr/bin/env bash

if [ -n "$ZOO_RUN_EMBEDDED" ]; then
  ./run-zookeeper.sh $@
fi

./run-kafka.sh $@
