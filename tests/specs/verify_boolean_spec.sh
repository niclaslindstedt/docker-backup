#!/bin/bash

# shellcheck disable=SC1090,SC1091,SC2034

for f in "$APP_PATH"/common/*; do . "$f"; done
for f in "$APP_PATH"/entrypoint/*; do . "$f"; done

test__verify_boolean__returns_true_on_true() {
  test_begin "verify_boolean returns true on true"

  # Arrange
  value="true"
  result=0

  # Act
  (verify_boolean value) && result=1

  # Assert
  assert_equals "1" "$result"
}

test__verify_boolean__returns_true_on_false() {
  test_begin "verify_boolean returns false on false"

  # Arrange
  value="false"
  result=0

  # Act
  (verify_boolean value) && result=1

  # Assert
  assert_equals "1" "$result"
}

test__verify_boolean__returns_false_on_uppercase_true() {
  test_begin "verify_boolean returns false on TRUE"

  # Arrange
  value="TRUE"
  result=0

  # Act
  (verify_boolean value) && result=1

  # Assert
  assert_equals "0" "$result"
}
