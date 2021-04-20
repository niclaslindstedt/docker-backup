#!/bin/bash

# shellcheck disable=SC1091

source "$APP_PATH/common.sh"

test__get_free_space__returns_free_space_in_kb_from_df() {
  test_begin "get_free_space returns free space in kilobytes from df"

  # Arrange
  df() {
    /bin/echo "Filesystem    1024-blocks      Used Available Capacity Mounted on"
    /bin/echo "/dev/sda1       237584168 157483896  67961984      70% /volumes"
  }

  # Act
  result="$(get_free_space /volumes)"

  # Assert
  assert_equals "67961984" "$result"
}

test__get_free_space__returns_0_if_not_a_directory() {
  test_begin "get_free_space returns 0 if not a directory"

  # Arrange
  df() {
    /bin/echo "Filesystem    1024-blocks      Used Available Capacity Mounted on"
    /bin/echo "/dev/sda1       237584168 157483896  67961984      70% /not_a_directory"
  }

  # Act
  result="$(get_free_space /not_a_directory)"

  # Assert
  assert_equals "0" "$result"
}
