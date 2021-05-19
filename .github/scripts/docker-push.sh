#!/bin/bash

# shellcheck disable=SC2048,SC2086

main() {
  local registry_uri image

  registry_uri="${1:-niclaslindstedt}"
  image="$registry_uri/docker-backup"

  echo "Pushing images"

  docker push --all-tags "$image"
}

SCRIPTDIR=$(dirname "$(readlink -f "$0")")
cd "$SCRIPTDIR/../.." || exit 1

main $*
