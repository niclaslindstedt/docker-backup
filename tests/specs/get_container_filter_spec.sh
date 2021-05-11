#!/bin/bash

# shellcheck disable=SC1091,SC2034

for f in "$APP_PATH"/common/*; do . "$f"; done

test__get_container_filter__returns_trimmed_project_name() {
  test_begin "get_container_filter returns trimmed project name"

  # Arrange
  result=""
  PROJECT_NAME=" proj1 "
  container_name="cont1"

  # Act
  result="$(get_container_filter "$container_name")"

  # Assert
  assert_equals "proj1_cont1_" "$result"
}

test__get_container_filter__returns_trimmed_container_name() {
  test_begin "get_container_filter returns trimmed container name"

  # Arrange
  result=""
  PROJECT_NAME="proj1"
  container_name=" cont1 "

  # Act
  result="$(get_container_filter "$container_name")"

  # Assert
  assert_equals "proj1_cont1_" "$result"
}
