#!/bin/bash

# shellcheck disable=SC2048,SC2086

main() {
  local registry_uri image

  [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Version should be X.Y.Z."; exit 1; }

  registry_uri="${2:-niclaslindstedt}"
  image="$registry_uri/docker-backup"

  echo "Pushing images"

  docker push --all-tags "$image"
}

SCRIPTDIR=$(dirname "$(readlink -f "$0")")
cd "$SCRIPTDIR/../.." || exit 1

main $*
