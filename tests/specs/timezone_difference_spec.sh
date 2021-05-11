#!/bin/bash

# shellcheck disable=SC1090,SC1091

for f in "$APP_PATH"/common/*; do . "$f"; done

test__contains_numeric_date__returns_true_if_ok_date() {
  test_begin "contains_numeric_date returns false if ok date"

  # Arrange
  backup_filename="backup-test-backup-19891131235959.tgz"
  result=false

  # Act
  contains_numeric_date "$backup_filename" && result=true

  # Assert
  assert_true "$result"
}

test__contains_numeric_date__returns_false_if_bad_second() {
  test_begin "contains_numeric_date returns false if bad second"

  # Arrange
  backup_filename="backup-test-backup-19891131235960.tgz"
  result=false

  # Act
  contains_numeric_date "$backup_filename" && result=true

  # Assert
  assert_false "$result"
}
