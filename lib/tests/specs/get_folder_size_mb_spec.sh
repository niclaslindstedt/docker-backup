#!/bin/bash

# shellcheck disable=SC1090,SC1091

for f in "$APP_PATH"/common/*; do . "$f"; done

test__get_folder_size_mb__returns_folder_size_in_mb() {
  test_begin "get_folder_size_mb returns folder size in mb"

  # Arrange
  du() {
    /bin/echo "22530640	/volumes/test"
  }

  # Act
  result="$(get_folder_size_mb /volumes/test)"

  # Assert
  assert_equals "22002" "$result"
}
