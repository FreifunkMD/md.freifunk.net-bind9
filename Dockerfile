FROM debian:bullseye

LABEL maintainer="tux@md.freifunk.net"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
    bind9 \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/*

EXPOSE 53/udp 53/tcp

COPY db.md.freifunk.net /etc/bind
COPY named.conf.local /etc/bind

CMD ["/usr/sbin/named", "-f", "-g"]
