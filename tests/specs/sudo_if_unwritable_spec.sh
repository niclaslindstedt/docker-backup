#!/bin/bash

# shellcheck disable=SC1090,SC1091,SC2034

for f in "$APP_PATH"/common/*; do . "$f"; done

test__sudo_if_unwritable__adds_sudo_if_unwritable() {
  test_begin "sudo_if_unwritable adds sudo if unwritable"

  # Arrange
  sudo mkdir -p sudo-test
  sudo chmod 700 sudo-test

  # Act
  result="$(sudo_if_unwritable ./sudo-test)"

  # Assert
  assert_equals "sudo" "$result"
}

test__sudo_if_unwritable__does_not_add_sudo_if_writable() {
  test_begin "sudo_if_unwritable does not add sudo if writable"

  # Arrange
  mkdir -p sudo-test

  # Act
  result="$(sudo_if_unwritable ./sudo-test)"

  # Assert
  assert_equals "" "$result"
}
