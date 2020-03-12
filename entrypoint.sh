#!/usr/bin/env bash

if [ -n "$ZOO_RUN_EMBEDDED" ]; then
  echo launch zookeeper
fi

./entrypoint-kafka.sh
