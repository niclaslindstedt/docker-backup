#!/bin/bash

# shellcheck disable=SC1090,SC1091

for f in "$APP_PATH"/common/*; do . "$f"; done

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
