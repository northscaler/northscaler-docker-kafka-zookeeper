#!/usr/bin/env bash

if [ "$*" == "/run.sh" ]; then
  if [ -z "$KAFKA_NO_EMBEDDED_ZOOKEEPER" ]; then
    echo "Running zookeeper in container..."
    export ALLOW_ANONYMOUS_LOGIN=yes
    /entrypoint-zookeeper.sh /run-zookeeper.sh
  fi
  ./entrypoint-kafka.sh /run-kafka.sh
else
  $@
fi
