#!/bin/bash

# shellcheck disable=SC2048,SC2086

main() {
  local major minor

  [[ "$1" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Version should be vX.Y.Z."; exit 1; }

  major="${1%.*}"
  minor="${1%.*.*}"

  git tag latest
  git tag "$major"
  git tag "$minor"
  git push origin HEAD --follow-tags
}

SCRIPTDIR=$(dirname "$(readlink -f "$0")")
cd "$SCRIPTDIR/../.." || exit 1

main $*
