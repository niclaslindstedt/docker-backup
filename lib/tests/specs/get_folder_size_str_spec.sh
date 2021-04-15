#!/bin/bash

# shellcheck disable=SC1090

source "$APP_PATH/common.sh"

testspec__get_folder_size_str__returns_folder_size_in_mb_with_unit() {
  test_begin "get_folder_size_str returns folder size in mb with unit"

  # Arrange
  du() {
    /bin/echo "22530640	/volumes/test"
  }

  # Act
  result="$(get_folder_size_str /volumes/test)"

  # Assert
  assert_equals "22002 MB" "$result"
}
