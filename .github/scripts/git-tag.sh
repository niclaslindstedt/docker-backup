#!/bin/bash

# shellcheck disable=SC2048,SC2086

main() {
  local major minor

  [[ "$1" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Version should be vX.Y.Z."; exit 1; }

  major="${1%.*}"
  minor="${1%.*.*}"

  git tag -f latest
  git tag -f "$major"
  git tag -f "$minor"
  git push origin latest
  git push origin "$major"
  git push origin "$minor"
}

SCRIPTDIR=$(dirname "$(readlink -f "$0")")
cd "$SCRIPTDIR/../.." || exit 1

main $*
