#!/usr/bin/env bash
set -e  # Exit on error

IMAGE_NAME="cryptopath/alpine"
VERSION="$(cat VERSION)"
BASEVERSION="${VERSION%%-*}"

echo -e "NAME:\t\t${IMAGE_NAME}"
echo -e "VERSION:\t${VERSION}"
echo -e "BASEVERSION:\t${BASEVERSION}"

docker build \
  --tag ${IMAGE_NAME}:latest \
  --tag ${IMAGE_NAME}:${VERSION} \
  --tag ${IMAGE_NAME}:${BASEVERSION} .
