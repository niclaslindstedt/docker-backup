#!/bin/bash

# shellcheck disable=SC2048,SC2086

main() {
  local docker_path

  docker_path="$SCRIPTDIR/../../docker"

  # Run tests on regular image
  docker-compose -f $docker_path/docker-compose.test.yml build --build-arg INSTALL_DOCKER=false
  docker-compose -f $docker_path/docker-compose.test.yml run --rm sut

  # Run tests with Docker installed
  docker-compose -f $docker_path/docker-compose.test.yml build --build-arg INSTALL_DOCKER=true
  docker-compose -f $docker_path/docker-compose.test.yml run -v /var/run/docker.sock:/var/run/docker.sock --rm sut

  # Run tests on alpine image
  docker-compose -f $docker_path/docker-compose.test.yml -f $docker_path/docker-compose.test.alpine.yml build
  docker-compose -f $docker_path/docker-compose.test.yml -f $docker_path/docker-compose.test.alpine.yml run --rm sut
}

SCRIPTDIR=$(dirname "$(readlink -f "$0")")

main $*
