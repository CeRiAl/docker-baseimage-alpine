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
  USERNAME="abc" && \
  USERID="911" && \
  S6_DOWNLOAD_URL="https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.gz" && \
  echo -e "\n**** install build packages ****" && \
    apk add --no-cache --virtual=build-dependencies \
      curl \
      tar && \
  echo -e "\n**** install runtime packages ****" && \
    apk add --no-cache \
      bash \
      ca-certificates \
      coreutils \
      shadow \
      tzdata && \
  echo -e "\n**** add s6 overlay ${S6_OVERLAY_VERSION} (${S6_OVERLAY_ARCH}) ****" && \
    curl -SL "${S6_DOWNLOAD_URL}" | tar x -C / -z && \
  echo -e "\n**** create ${USERNAME} user and homedir ****" && \
    groupmod -g 1000 users && \
    useradd -u "${USERID}" -U -s /bin/false "${USERNAME}" && \
    usermod -G users "${USERNAME}" && \
    mkdir -p \
      "/home/${USERNAME}" && \
  echo -e "\n**** cleanup ****" && \
    apk del --purge \
      build-dependencies

# copy local files
COPY root/ /

ENTRYPOINT ["/init"]
