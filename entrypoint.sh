#!/usr/bin/env bash

if [ "$*" == "/run.sh" ]; then
  if [ -n "$ZOO_RUN_EMBEDDED" ]; then
    echo "Running zookeeper in container..."
    /entrypoint-zookeeper.sh /run-zookeeper.sh
  fi
  ./entrypoint-kafka.sh /run-kafka.sh
else
  $@
fi
