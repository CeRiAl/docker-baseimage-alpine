#!/usr/bin/env bash
set -e  # Exit on error

# set environment variables used in build-hook scripts
DOCKER_REPO="cryptopath/alpine"
DOCKER_TAG="$(cat VERSION)"

# source-in post_push hook (but don't push, only tag)
source hooks/post_push --no-push
