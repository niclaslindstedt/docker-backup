#!/bin/bash

# shellcheck disable=SC1090,SC1091

for f in "$APP_PATH"/common/*; do . "$f"; done

test__get_file_size__returns_file_size_in_bytes() {
  test_begin "get_file_size returns file size in bytes"

  # Arrange
  stat() {
    /bin/echo "1113999"
  }

  # Act
  result="$(get_file_size /bin/bash)"

  # Assert
  assert_equals "1113999" "$result"
}

test__get_file_size__returns_0_if_file_does_not_exist() {
  test_begin "get_file_size returns file size in bytes"

  # Arrange
  stat() {
    /bin/echo "1113999"
  }

  # Act
  result="$(get_file_size /bin/nonexistent_file)"

  # Assert
  assert_equals "0" "$result"
}
