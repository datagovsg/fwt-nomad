FROM guangie88/rs-filewatch-trigger:v0.1.1 as fwt

# unfortunately Nomad is not fully statically linked, requires libc
FROM ubuntu:bionic

ARG NOMAD_VERSION="0.8.4"

COPY --from=fwt /usr/local/bin/fwt /usr/local/bin/fwt

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget unzip ca-certificates \
    && wget https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip \
    && unzip nomad_${NOMAD_VERSION}_linux_amd64.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/nomad \
    && rm nomad_${NOMAD_VERSION}_linux_amd64.zip \
    && apt-get remove -y wget unzip ca-certificates \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*
