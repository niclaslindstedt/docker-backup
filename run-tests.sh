#!/bin/bash

[[ "$1" =~ ^test__ ]] && RUN_TEST="$1"
[[ "$1" =~ _spec$ ]] && RUN_SPEC="$1"

# Run tests on regular image
RUN_TEST=$RUN_TEST RUN_SPEC=$RUN_SPEC docker-compose -f docker-compose.test.yml build --build-arg INSTALL_DOCKER=false
RUN_TEST=$RUN_TEST RUN_SPEC=$RUN_SPEC docker-compose -f docker-compose.test.yml run --rm sut

# Run tests with Docker installed
RUN_TEST=$RUN_TEST RUN_SPEC=$RUN_SPEC docker-compose -f docker-compose.test.yml build --build-arg INSTALL_DOCKER=true
RUN_TEST=$RUN_TEST RUN_SPEC=$RUN_SPEC docker-compose -f docker-compose.test.yml run -v /var/run/docker.sock:/var/run/docker.sock --rm sut

# Run tests on alpine image
RUN_TEST=$RUN_TEST RUN_SPEC=$RUN_SPEC docker-compose -f docker-compose.test.yml -f docker-compose.test.alpine.yml build
RUN_TEST=$RUN_TEST RUN_SPEC=$RUN_SPEC docker-compose -f docker-compose.test.yml -f docker-compose.test.alpine.yml run --rm sut
