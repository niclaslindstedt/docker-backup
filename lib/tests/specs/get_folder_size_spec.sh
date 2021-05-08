#!/bin/bash

# shellcheck disable=SC1090,SC1091

for f in "$APP_PATH"/common/*; do . "$f"; done

test__get_folder_size__returns_folder_size_in_kb_from_du() {
  test_begin "get_folder_size returns folder size in kilobytes from du"

  # Arrange
  du() {
    /bin/echo "22530640	/volumes/test"
  }

  # Act
  result="$(get_folder_size /volumes/test)"

  # Assert
  assert_equals "22530640" "$result"
}

test__get_folder_size__returns_0_if_not_a_directory() {
  test_begin "get_folder_size returns 0 if not a directory"

  # Arrange
  du() {
    /bin/echo "22530640	/not_a_directory"
  }

  # Act
  result="$(get_folder_size /not_a_directory)"

  # Assert
  assert_equals "0" "$result"
}
