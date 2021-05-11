#!/bin/bash

# shellcheck disable=SC1091,SC2034

for f in "$APP_PATH"/common/*; do . "$f"; done

test__logv__calls_echo_if_verbose() {
  test_begin "logv calls echo if VERBOSE is true"

  # Arrange
  VERBOSE=true
  test_message="xx logv xx"
  echo() { set_result "$*"; }

  # Act
  logv "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}

test__logv__does_not_call_echo_if_not_verbose() {
  test_begin "logv does not call echo if VERBOSE is false"

  # Arrange
  VERBOSE=false
  set_result "null"
  echo() { set_result "$*"; }

  # Act
  logv "test"

  # Assert
  assert_equals "null" "$(get_result)"
}
