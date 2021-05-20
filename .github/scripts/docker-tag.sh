#!/bin/bash

# shellcheck disable=SC2048,SC2086

main() {
  local version registry_uri major minor image

  [[ "$1" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Version should be vX.Y.Z."; exit 1; }

  version="${1##*v}" # removes the initial "v" from the version
  registry_uri="${2:-niclaslindstedt}"
  image="$registry_uri/docker-backup"
  major="${version%.*}"
  minor="${version%.*.*}"

  echo "Tagging images ($version, $major, $minor)"

  docker tag "$image:latest" "$image:$version"
  docker tag "$image:latest" "$image:$major"
  docker tag "$image:latest" "$image:$minor"
  docker tag "$image:latest-docker" "$image:$version-docker"
  docker tag "$image:latest-docker" "$image:$major-docker"
  docker tag "$image:latest-docker" "$image:$minor-docker"
  docker tag "$image:latest-alpine" "$image:$version-alpine"
  docker tag "$image:latest-alpine" "$image:$major-alpine"
  docker tag "$image:latest-alpine" "$image:$minor-alpine"
}

SCRIPTDIR=$(dirname "$(readlink -f "$0")")
cd "$SCRIPTDIR/../.." || exit 1

main $*
