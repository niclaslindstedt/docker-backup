#!/bin/bash

# shellcheck disable=SC1090

source "$APP_PATH/common.sh"

test__get_file_size_mb__returns_file_size_in_mb() {
  test_begin "get_file_size_mb returns file size in mb"

  # Arrange
  stat() {
    /bin/echo "6200000"
  }

  # Act
  result="$(get_file_size_mb /bin/bash)"

  # Assert
  assert_equals "5" "$result"
}
