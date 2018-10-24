FROM alpine:3.8

MAINTAINER CeRiAl

# set version for s6 overlay
ARG S6_OVERLAY_VERSION="v1.21.7.0"
ARG S6_OVERLAY_ARCH="amd64"

# environment variables
ENV PS1="$(whoami)@$(hostname):$(pwd)\$ " \
    HOME="/root" \
    TERM="xterm"

RUN \
  echo "**** install build packages ****" && \
    apk add --no-cache --virtual=build-dependencies \
      curl \
      tar && \
  echo "**** install runtime packages ****" && \
    apk add --no-cache \
      bash \
      ca-certificates \
      coreutils \
      shadow \
      tzdata && \
  echo "**** add s6 overlay v${S6_OVERLAY_VERSION} (${S6_OVERLAY_ARCH}) ****" && \
    S6_DOWNLOAD_URL="https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.gz" && \
    curl -SL "${S6_DOWNLOAD_URL}" | tar x -C / -z && \
  echo "**** create abc user and make our folders ****" && \
    groupmod -g 1000 users && \
    useradd -u 911 -U -s /bin/false abc && \
    usermod -G users abc && \
    mkdir -p \
      /app \
      /home/abc && \
  echo "**** cleanup ****" && \
    apk del --purge \
      build-dependencies

# copy local files
COPY root/ /

ENTRYPOINT ["/init"]
