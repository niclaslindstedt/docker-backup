#!/bin/bash

# shellcheck disable=SC1090

source "$APP_PATH/common.sh"

test__get_folder_size_gb__returns_folder_size_in_gb() {
  test_begin "get_folder_size_gb returns folder size in gb"

  # Arrange
  du() {
    /bin/echo "22530640	/volumes/test"
  }

  # Act
  result="$(get_folder_size_gb /volumes/test)"

  # Assert
  assert_equals "21" "$result"
}
