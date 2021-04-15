#!/bin/bash

testspec__is_not_empty__returns_false_if_empty() {
  test_begin "is_not_empty returns false if directory is empty"

  # Arrange
  mkdir -p "$TEST_PATH/empty_folder"
  result=false

  # Act
  is_not_empty "$TEST_PATH/empty_folder" && result=true

  # Assert
  assert_false "$result"
}

testspec__is_not_empty__returns_true_if_not_empty() {
  test_begin "is_not_empty returns true if directory is not empty"

  # Arrange
  mkdir -p "$TEST_PATH/non_empty_folder"
  /bin/echo "Test" > "$TEST_PATH/non_empty_folder/test_file"
  result=false

  # Act
  is_not_empty "$TEST_PATH/non_empty_folder" && result=true

  # Assert
  assert_true "$result"
}
