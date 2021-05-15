#!/bin/bash

# shellcheck disable=SC2048,SC2086

main() {
  local version registry_uri image

  [[ "$1" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Version should be vX.Y.Z."; exit 1; }

  version="$1"
  registry_uri="${2:-niclaslindstedt}"
  image="$registry_uri/docker-backup"

  echo "Pushing images"

  docker push --all-tags "$image"

  [ "$version" != "latest" ] && push_versions $version $registry_uri
}

SCRIPTDIR=$(dirname "$(readlink -f "$0")")
cd "$SCRIPTDIR/.." || exit 1

main $*
