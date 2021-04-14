#!/bin/sh

[ -n "$1" ] && RUN_TEST="$1"

RUN_TEST=$RUN_TEST docker-compose -f docker-compose.test.yml build
RUN_TEST=$RUN_TEST docker-compose -f docker-compose.test.yml run --rm sut
