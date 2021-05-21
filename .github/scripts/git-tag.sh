#!/bin/bash

# shellcheck disable=SC2048,SC2086

main() {
  local major minor

  [[ "$1" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Version should be vX.Y.Z."; exit 1; }

  major="${1%.*}"
  minor="${1%.*.*}"

  force_create_tag latest
  force_create_tag "$major"
  force_create_tag "$minor"
}

force_create_tag() {
  git push origin --delete "$1"
  git tag -f "$1"
  git push origin "$1"
}

SCRIPTDIR=$(dirname "$(readlink -f "$0")")
cd "$SCRIPTDIR/../.." || exit 1

main $*
