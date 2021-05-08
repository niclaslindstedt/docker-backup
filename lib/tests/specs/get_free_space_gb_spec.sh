#!/bin/bash

# shellcheck disable=SC1090,SC1091

for f in "$APP_PATH"/common/*; do . "$f"; done

test__get_free_space_gb__returns_free_space_in_gb() {
  test_begin "get_free_space_gb returns free space in gb"

  # Arrange
  df() {
    /bin/echo "Filesystem    1024-blocks      Used Available Capacity Mounted on"
    /bin/echo "/dev/sda1       237584168 157483896  67961984      70% /volumes"
  }

  # Act
  result="$(get_free_space_gb /volumes)"

  # Assert
  assert_equals "64" "$result"
}
