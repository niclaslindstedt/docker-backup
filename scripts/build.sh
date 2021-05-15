#!/bin/bash

SCRIPTDIR=$(dirname "$(readlink -f "$0")")
cd "$SCRIPTDIR/.." || exit 1

version="${1:-latest}"
echo "Building $version"

docker build --build-arg INSTALL_DOCKER=true -t "docker-backup:$version-docker" .
docker build --build-arg INSTALL_DOCKER=false -t "docker-backup:$version" .
