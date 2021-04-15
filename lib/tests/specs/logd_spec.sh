#!/bin/bash

# shellcheck disable=SC1090,SC2034

source "$APP_PATH/common.sh"

testspec__logd__calls_echo_if_debug() {
  test_begin "logd calls echo if DEBUG is true"

  # Arrange
  DEBUG=true
  test_message="xx logd xx"
  echo() { set_result "$*"; }

  # Act
  logd "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}

testspec__logd__does_not_call_echo_if_not_debug() {
  test_begin "logd does not call echo if DEBUG is false"

  # Arrange
  DEBUG=false
  set_result "null"
  echo() { set_result "$*"; }

  # Act
  logd "test"

  # Assert
  assert_equals "null" "$(get_result)"
}
