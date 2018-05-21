FROM alpine:latest as builder
LABEL maintainer Kenzo Okuda <kyokuheki@gmail.comt>
ENV LANG="en_US.UTF-8" \
    SOFTETHER_VERSION="v4.27-9666-beta"

RUN set -eux -o pipefail \
 && apk add --no-cache --virtual .build-deps \
    ca-certificates \
    gcc \
    make \
    musl-dev \
    ncurses-dev \
    openssl-dev \
    readline-dev \
    wget \
 && wget -q --no-check-certificate -O - https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/archive/${SOFTETHER_VERSION}.tar.gz | tar xzf - \
 && cd SoftEtherVPN_Stable-${SOFTETHER_VERSION:1} \
 && ./configure \
 && make && make install && make clean \
 && vpncmd /tools /cmd check \
 && apk del .build-deps \
 && cd .. \
 && rm -rf SoftEtherVPN_Stable-${SOFTETHER_VERSION:1}


FROM alpine:latest
LABEL maintainer Kenzo Okuda <kyokuheki@gmail.com>
ENV LANG="en_US.UTF-8" \
    SOFTETHER_VERSION="v4.27-9666-beta"

COPY --from=builder /usr/vpnserver /usr/vpnbridge /usr/vpncmd /usr/vpnserver/
COPY assets/entrypoint.sh /
RUN set -eux -o pipefail \
 && chmod +x /entrypoint.sh \
 && mkdir -p /etc/vpnserver /var/log/vpnserver \
 && ln -sv /etc/vpnserver/vpn_server.config /usr/vpnserver/ \
 && ln -svf /etc/vpnserver/lang.config /usr/vpnserver/ \
 && apk add --no-cache --virtual .run-deps \
    ca-certificates \
    libcap \
    libcrypto1.0 \
    libssl1.0 \
    ncurses-libs \
    readline \
 && /usr/vpnserver/vpncmd /tools /cmd check

EXPOSE 443/tcp 992/tcp 5555/tcp 8888/tcp 1194/tcp 1194/udp 500:500/udp 4500:4500/udp 1701:1701/udp
VOLUME ["/etc/vpnserver", "/var/log/vpnserver"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/vpnserver/vpnserver", "execsvc"]
