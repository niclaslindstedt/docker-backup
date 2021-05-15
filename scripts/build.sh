#!/bin/bash

# shellcheck disable=SC2048,SC2086

main() {
  local registry

  registry="${1:-niclaslindstedt}"

  echo "Building latest-docker"
  docker build --build-arg INSTALL_DOCKER=true -t "$registry/docker-backup:latest-docker" . || exit 1

  echo "Building latest"
  docker build --build-arg INSTALL_DOCKER=false -t "$registry/docker-backup:latest" . || exit 1
}

SCRIPTDIR=$(dirname "$(readlink -f "$0")")
cd "$SCRIPTDIR/.." || exit 1

main $1
