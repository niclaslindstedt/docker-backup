#!/bin/bash

[[ "$1" == "all" ]] && RUN_ALL="true"
[[ "$1" =~ ^test__ ]] && RUN_TEST="$1"
[[ "$1" =~ _spec$ ]] && RUN_SPEC="$1"

SCRIPTDIR=$(dirname "$(readlink -f "$0")")
RUN_ALL=$RUN_ALL RUN_TEST=$RUN_TEST RUN_SPEC=$RUN_SPEC "$SCRIPTDIR/.github/scripts/test.sh"
