#!/bin/bash
set -e

REPOSITORY=registry.hubbe.club
IMAGE=weechat

TAG=$(git describe --tags --abbrev=0)

buildah bud -t $REPOSITORY/$IMAGE:$TAG -t $REPOSITORY/$IMAGE:latest .
buildah push $REPOSITORY/$IMAGE:$TAG
buildah push $REPOSITORY/$IMAGE:latest
