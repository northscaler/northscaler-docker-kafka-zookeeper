FROM bitnami/minideb:buster

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs-kafka /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 procps sudo unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "java" "11.0.6-0" --checksum f7446f8bec72b6b2606d37ba917accc243e6cd4e722700c39ef83832c46fb0c6
RUN . ./libcomponent.sh && component_unpack "render-template" "1.0.0-0" --checksum 63449e5ed4ece61d7bbeda0d173b68768d9fb444922b8ffa2e1042be20687142
RUN . ./libcomponent.sh && component_unpack "kafka" "2.4.0-0" --checksum cb923a585b78ab43ea458e03d2b6f9289b00e97b05173255357a26dc5113a205
RUN . ./libcomponent.sh && component_unpack "gosu" "1.11.0-3" --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root kafka

COPY rootfs-kafka /
RUN /postunpack.sh
#ENV BITNAMI_APP_NAME="kafka" \
#   BITNAMI_IMAGE_VERSION="2.4.0-debian-10-r46" \
ENV NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:/opt/bitnami/kafka/bin:/opt/bitnami/gosu/bin:$PATH"

EXPOSE 9092

#ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
#    HOME="/" \
#    OS_ARCH="amd64" \
#    OS_FLAVOUR="debian-10" \
#    OS_NAME="linux"

#COPY prebuildfs /
# Install required system packages and dependencies
#RUN install_packages ca-certificates curl libc6 procps sudo unzip zlib1g
#RUN . ./libcomponent.sh && component_unpack "java" "11.0.6-0" --checksum f7446f8bec72b6b2606d37ba917accc243e6cd4e722700c39ef83832c46fb0c6
RUN . ./libcomponent.sh && component_unpack "zookeeper" "3.6.0-0" --checksum 1f7efe908883b1e3a34b54eacc8fa80d8e8c3a240bf91a403bd127490d19f9c5
RUN . ./libcomponent.sh && component_unpack "wait-for-port" "1.0.0-1" --checksum 07c4678654b01811f22b5bb65a8d6f8e253abd4524ebb3b78c7d3df042cf23bd
#RUN . ./libcomponent.sh && component_unpack "gosu" "1.11.0-3" --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
#RUN useradd -r -u 1001 -g root zookeeper

COPY rootfs-zookeeper /rootfs-zookeeper
RUN for it in entrypoint postunpack run setup; do cp /rootfs-zookeeper/$it.sh /${it}-zookeeper.sh; done
RUN cp /rootfs-zookeeper/libzookeeper.sh /
RUN /postunpack-zookeeper.sh
ENV BITNAMI_APP_NAME="kafka-zookeeper" \
    BITNAMI_IMAGE_VERSION="2.4.0-debian-10-r46+3.6.0-debian-10-r2" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/zookeeper/bin:/opt/bitnami/common/bin:/opt/bitnami/gosu/bin:$PATH"
#    NAMI_PREFIX="/.nami" \

EXPOSE 2181 2888 3888 8080

COPY entrypoint.sh /
COPY run.sh /

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
