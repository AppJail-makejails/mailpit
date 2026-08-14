ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/core:${FREEBSD_RELEASE}

ARG NO_PKGCLEAN

LABEL org.opencontainers.image.title="Mailpit" \
    org.opencontainers.image.description="Multi-platform email testing tool & API for developers" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/mailpit" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/mailpit" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN set -xe; \
    \
    pkg update; \
    pkg install mailpit; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then \
        pkg clean -a; \
        rm -rf /var/cache/pkg/*; \
    fi; \
    rm -rf /var/db/pkg/repos/*

VOLUME /data

RUN mkdir -p /data

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

EXPOSE 1025/tcp 1110/tcp 8025/tcp

ENTRYPOINT ["/entrypoint.sh"]
