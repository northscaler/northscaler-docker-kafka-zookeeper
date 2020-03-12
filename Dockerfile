FROM bitnami/kafka:2.4.0

# Taken from https://github.com/bitnami/bitnami-docker-zookeeper/blob/master/3/debian-10/Dockerfile

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

# COPY prebuildfs /
# Install required system packages and dependencies
# RUN install_packages ca-certificates curl libc6 procps sudo unzip zlib1g
# RUN . ./libcomponent.sh && component_unpack "java" "11.0.6-0" --checksum f7446f8bec72b6b2606d37ba917accc243e6cd4e722700c39ef83832c46fb0c6
RUN . ./libcomponent.sh && component_unpack "zookeeper" "3.6.0-0" --checksum 1f7efe908883b1e3a34b54eacc8fa80d8e8c3a240bf91a403bd127490d19f9c5
RUN . ./libcomponent.sh && component_unpack "wait-for-port" "1.0.0-1" --checksum 07c4678654b01811f22b5bb65a8d6f8e253abd4524ebb3b78c7d3df042cf23bd
# RUN . ./libcomponent.sh && component_unpack "gosu" "1.11.0-3" --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
# RUN useradd -r -u 1001 -g root zookeeper

# COPY rootfs /
RUN for it in entrypoint postunpack run setup; do \
    mv /$it.sh /${it}-kafka.sh; done
RUN for it in entrypoint postunpack run setup; do \
     curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-zookeeper/master/3/debian-10/rootfs/$it.sh > /${it}-zookeeper.sh \
     && chmod ugo+x /${it}-zookeeper.sh; done
ADD https://raw.githubusercontent.com/bitnami/bitnami-docker-zookeeper/master/3/debian-10/rootfs/libzookeeper.sh /
RUN sed --in-place 's/start-foreground/start/g' /run-zookeeper.sh

# RUN /postunpack.sh
RUN /postunpack-zookeeper.sh
ENV BITNAMI_APP_NAME="kafka-zookeeper" \
    BITNAMI_IMAGE_VERSION="3.6.0-debian-10-r2+2.4.0-debian-10-r46" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/zookeeper/bin:/opt/bitnami/common/bin:/opt/bitnami/gosu/bin:$PATH"
# ^^^ not really worried about harmless duplicate path entries above ^^^

EXPOSE 2181 2888 3888 8080

# USER 1001
# ENTRYPOINT [ "/entrypoint.sh" ]
# CMD [ "/run.sh" ]

COPY entrypoint.sh /
COPY run.sh /
