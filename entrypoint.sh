#!/usr/bin/env bash

if [ -n "$ZOO_RUN_EMBEDDED" ]; then
  info "Running zookeeper in container..."
  /entrypoint-zookeeper.sh $@
  info "Zookeeper started"
fi

./entrypoint-kafka.sh $@
