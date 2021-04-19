#!/bin/bash

# shellcheck disable=SC1090

source "$APP_PATH/common.sh"

test__get_container_ids__calls_docker_ps() {
  test_begin "get_container_ids calls docker ps"

  # Arrange
  set_result "false"
  PROJECT_NAME="proj1"
  docker() {
    [ "$1" = "ps" ] && [[ "$*" =~ "--filter name=proj1_cont1" ]] && set_result "true"
  }

  # Act
  get_container_ids cont1

  # Assert
  assert_true "$(get_result)"
}
