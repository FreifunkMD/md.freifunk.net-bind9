FROM debian:bullseye AS install

# Apt-proxy config
COPY apt-proxy-detect.sh /usr/local/lib/
COPY 01proxy /etc/apt/apt.conf.d

# Keep apt cache directories!
RUN apt-get update

# Download bind9 for the next stage
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    --download-only \
    bind9


FROM debian:bullseye

LABEL maintainer="tux@md.freifunk.net"

COPY --from=install /var/lib/apt/lists/ /var/lib/apt/lists/
COPY --from=install /var/cache/apt/ /var/cache/apt/

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    bind9 \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/*

EXPOSE 53/udp 53/tcp

COPY md.freifunk.net.zone /etc/bind
COPY named.conf.local /etc/bind

CMD ["/usr/sbin/named", "-f", "-g"]
