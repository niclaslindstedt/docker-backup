#!/bin/bash

# shellcheck disable=SC1091

source "$APP_PATH/common.sh"

test__loga__calls_echo() {
  test_begin "loga calls echo"

  # Arrange
  test_message="xx loga xx"
  echo() { set_result "$*"; }

  # Act
  loga "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}
