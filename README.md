# Kafka+Zookeeper Docker Image

This Docker image is a temporary hack until https://github.com/bitnami/bitnami-docker-kafka/issues/89 is fixed.

# Usage

See

* bitnami/kafka usage: https://github.com/bitnami/bitnami-docker-kafka/blob/master/README.md#configuration and
* bitnami/zookeeper usage: https://github.com/bitnami/bitnami-docker-zookeeper/blob/master/README.md#configuration

The only environment variable you should add if you _don't_ want embedded zookeeper is:
```
# set to any non-empty string value
KAFKA_NO_EMBEDDED_ZOOKEEPER=1
```
Otherwise, kafka will use its own zookeeper instance inside this container.

> WARNING: This repo is not tracking upstream changes.
>Watch https://github.com/bitnami/bitnami-docker-kafka/issues/89 for progress.

