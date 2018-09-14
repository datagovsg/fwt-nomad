FROM guangie88/rs-filewatch-trigger:v0.1.1 as fwt

# unfortunately Nomad is not fully statically linked, requires libc
FROM ubuntu:bionic

ARG NOMAD_VERSION="0.8.4"
ARG RCLONE_VERSION="1.43.1"

COPY --from=fwt /usr/local/bin/fwt /usr/local/bin/fwt

RUN set -e \
    && apt-get update \
    && apt-get install -y --no-install-recommends curl unzip ca-certificates \
    && curl -O https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip \
    && unzip nomad_${NOMAD_VERSION}_linux_amd64.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/nomad \
    && rm nomad_${NOMAD_VERSION}_linux_amd64.zip \
    && curl -O https://downloads.rclone.org/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-amd64.zip \
    && unzip rclone-v${RCLONE_VERSION}-linux-amd64.zip \
    && mv rclone-v${RCLONE_VERSION}-linux-amd64/rclone /usr/local/bin/ \
    && chmod +x /usr/local/bin/rclone \
    && rm -rf rclone-v${RCLONE_VERSION}-linux-amd64* \
    && apt-get remove -y wget unzip ca-certificates \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*
