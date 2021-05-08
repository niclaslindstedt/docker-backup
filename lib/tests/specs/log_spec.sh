#!/bin/bash

# shellcheck disable=SC1090,SC1091

for f in "$APP_PATH"/common/*; do . "$f"; done

test__log__calls_echo() {
  test_begin "log calls echo"

  # Arrange
  test_message="xx log xx"
  echo() { set_result "$*"; }

  # Act
  log "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}
