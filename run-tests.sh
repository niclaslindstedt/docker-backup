#!/bin/bash

[[ "$1" =~ ^test__ ]] && RUN_TEST="$1"
[[ "$1" =~ _spec$ ]] && RUN_SPEC="$1"

RUN_TEST=$RUN_TEST RUN_SPEC=$RUN_SPEC docker-compose -f docker-compose.test.yml build
RUN_TEST=$RUN_TEST RUN_SPEC=$RUN_SPEC docker-compose -f docker-compose.test.yml run --rm sut
