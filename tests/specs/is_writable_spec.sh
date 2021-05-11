#!/bin/bash

# shellcheck disable=SC1090,SC1091

for f in "$APP_PATH"/common/*; do . "$f"; done

test__is_writable__returns_true_on_nonexistant_file_if_directory_is_writable() {
  test_begin "is_writable returns true on non-existant file if directory is writable"

  # Arrange
  mkdir -p ./test/folder
  result=0

  # Act
  is_writable ./test/folder/non-existant-file && result=1

  # Assert
  assert_equals "1" "$result"
}

test__is_writable__returns_true_if_directory_is_writable() {
  test_begin "is_writable returns true if directory is writable"

  # Arrange
  mkdir -p ./test/folder
  result=0

  # Act
  is_writable ./test/folder && result=1

  # Assert
  assert_equals "1" "$result"
}

test__is_writable__returns_false_on_nonexistant_file_if_directory_is_not_writable() {
  test_begin "is_writable returns false on non-existant file if directory is not writable"

  # Arrange
  mkdir -p ./test/folder
  sudo chown root:root ./test/folder
  result=0

  # Act
  is_writable ./test/folder/non-existant-file && result=1

  # Assert
  assert_equals "0" "$result"
}

test__is_writable__returns_false_if_directory_is_not_writable() {
  test_begin "is_writable returns false if directory is not writable"

  # Arrange
  mkdir -p ./test/folder
  sudo chown root:root ./test/folder
  result=0

  # Act
  is_writable ./test/folder && result=1

  # Assert
  assert_equals "0" "$result"
}
