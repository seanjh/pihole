FROM debian:bookworm-slim AS build

ARG UNBOUND_VERSION=1.25.0

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    build-essential \
    pkg-config \
    libssl-dev \
    libexpat1-dev \
    bison \
    flex \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /build

RUN wget "https://github.com/NLnetLabs/unbound/archive/refs/tags/release-${UNBOUND_VERSION}.tar.gz" \
  && tar xzf "release-${UNBOUND_VERSION}.tar.gz"

WORKDIR /build/unbound-release-${UNBOUND_VERSION}

RUN ./configure \
    --prefix=/usr/local \
    --sysconfdir=/opt/unbound/etc \
    --with-ssl=/usr \
    --with-libexpat=/usr \
  && make -j"$(nproc)" \
  && make install


FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libssl3 \
    libexpat1 \
  && rm -rf /var/lib/apt/lists/* \
  && useradd --system --home /nonexistent --shell /usr/sbin/nologin unbound \
  && mkdir -p /opt/unbound/etc/unbound /var/lib/unbound \
  && chown -R unbound:unbound /opt/unbound /var/lib/unbound

COPY --from=build /usr/local/sbin/unbound /usr/local/sbin/unbound
COPY --from=build /usr/local/sbin/unbound-checkconf /usr/local/sbin/unbound-checkconf
COPY --from=build /usr/local/sbin/unbound-anchor /usr/local/sbin/unbound-anchor
COPY --from=build /usr/local/lib /usr/local/lib

ENV LD_LIBRARY_PATH=/usr/local/lib

EXPOSE 5335/tcp 5335/udp

USER unbound

ENTRYPOINT ["unbound"]
CMD ["-d", "-c", "/opt/unbound/etc/unbound/unbound.conf"]
