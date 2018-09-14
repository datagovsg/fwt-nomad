FROM guangie88/rs-filewatch-trigger:v0.1.1 as fwt

# unfortunately Nomad is not fully statically linked, requires libc
FROM ubuntu:bionic

ARG NOMAD_VERSION="0.8.4"

COPY --from=fwt /usr/local/bin/fwt /usr/local/bin/fwt

RUN set -e \
    && apt-get update \
    && apt-get install -y --no-install-recommends curl unzip ca-certificates \
    && curl -O https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip \
    && unzip nomad_${NOMAD_VERSION}_linux_amd64.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/nomad \
    && rm nomad_${NOMAD_VERSION}_linux_amd64.zip \
    && curl https://rclone.org/install.sh | bash \
    && apt-get remove -y wget unzip ca-certificates \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*
